--
-- dependencies
--

local ffi = require "ffi"
local typeof, sizeof, cast, ffi_string, ffi_gc, string_format = ffi.typeof, ffi.sizeof, ffi.cast, ffi.string, ffi.gc, string.format

--
-- helper functions
--

local function find_sig(mdlname, pattern, typename, offset, deref_count)
	local raw_match = client.find_signature(mdlname, pattern) or error("signature not found", 2)
	local match = cast("uintptr_t", raw_match)

	if offset ~= nil and offset ~= 0 then
		match = match + offset
	end

	if deref_count ~= nil then
		for i = 1, deref_count do
			match = cast("uintptr_t*", match)[0]
			if match == nil then
				return error("signature not found")
			end
		end
	end

	return cast(typename, match)
end

--
-- steam api
--

local register_call_result, register_callback
do
	if not pcall(ffi.sizeof, "SteamAPICall_t") then
		ffi.cdef[[
			typedef uint64_t SteamAPICall_t;

			struct SteamAPI_callback_base_vtbl {
				void(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);
				void(__thiscall *run2)(struct SteamAPI_callback_base *, void *);
				int(__thiscall *get_size)(struct SteamAPI_callback_base *);
			};

			struct SteamAPI_callback_base {
				struct SteamAPI_callback_base_vtbl *vtbl;
				uint8_t flags;
				int id;
				uint64_t api_call_handle;
				struct SteamAPI_callback_base_vtbl vtbl_storage[1];
			};
		]]
	end

	local ESteamAPICallFailure = {
		[-1] = "No failure",
		[0]  = "Steam gone",
		[1]  = "Network failure",
		[2]  = "Invalid handle",
		[3]  = "Mismatched callback"
	}

	local SteamAPI_RegisterCallResult, SteamAPI_UnregisterCallResult
	local SteamAPI_RegisterCallback, SteamAPI_UnregisterCallback

	local callback_base        = typeof("struct SteamAPI_callback_base")
	local sizeof_callback_base = sizeof(callback_base)
	local callback_base_array  = typeof("struct SteamAPI_callback_base[1]")
	local callback_base_ptr    = typeof("struct SteamAPI_callback_base*")
	local uintptr_t            = typeof("uintptr_t")
	local api_call_handlers    = {}
	local pending_call_results = {}
	local registered_callbacks = {}

	local function pointer_key(p)
		return tostring(tonumber(cast(uintptr_t, p)))
	end

	local function callback_base_run_common(self, param, io_failure)
		-- prevent SteamAPI_UnregisterCallResult from being called for this callresult
		self.api_call_handle = 0

		local key = pointer_key(self)
		local handler = api_call_handlers[key]
		if handler ~= nil then
			xpcall(handler, client.error_log, param, io_failure)
		end

		if pending_call_results[key] ~= nil then
			api_call_handlers[key] = nil
			pending_call_results[key] = nil
		end
	end

	local function callback_base_run1(self, param, io_failure, api_call_handle)
		if api_call_handle == self.api_call_handle then
			callback_base_run_common(self, param, io_failure)
		end
	end

	local function callback_base_run2(self, param)
		callback_base_run_common(self, param, false)
	end

	local function callback_base_get_size(self)
		return sizeof_callback_base
	end

	local function call_result_cancel(self)
		if self.api_call_handle ~= 0 then
			SteamAPI_UnregisterCallResult(self, self.api_call_handle)
			self.api_call_handle = 0

			local key = pointer_key(self)
			api_call_handlers[key] = nil
			pending_call_results[key] = nil
		end
	end

	pcall(ffi.metatype, callback_base, {
		__gc = call_result_cancel,
		__index = {
			cancel = call_result_cancel
		}
	})

	local callback_base_run1_ct = cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", callback_base_run1)
	local callback_base_run2_ct = cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", callback_base_run2)
	local callback_base_get_size_ct = cast("int(__thiscall *)(struct SteamAPI_callback_base *)", callback_base_get_size)

	function register_call_result(api_call_handle, handler, id)
		assert(api_call_handle ~= 0)
		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)

		instance.vtbl_storage[0].run1 = callback_base_run1_ct
		instance.vtbl_storage[0].run2 = callback_base_run2_ct
		instance.vtbl_storage[0].get_size = callback_base_get_size_ct
		instance.vtbl = instance.vtbl_storage
		instance.api_call_handle = api_call_handle
		instance.id = id

		local key = pointer_key(instance)
		api_call_handlers[key] = handler
		pending_call_results[key] = instance_storage

		SteamAPI_RegisterCallResult(instance, api_call_handle)

		return instance
	end

	function register_callback(id, handler)
		assert(registered_callbacks[id] == nil)

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)

		instance.vtbl_storage[0].run1 = callback_base_run1_ct
		instance.vtbl_storage[0].run2 = callback_base_run2_ct
		instance.vtbl_storage[0].get_size = callback_base_get_size_ct
		instance.vtbl = instance.vtbl_storage
		instance.api_call_handle = 0
		instance.id = id

		local key = pointer_key(instance)
		api_call_handlers[key] = handler
		registered_callbacks[id] = instance_storage

		SteamAPI_RegisterCallback(instance, id)
	end

	local function vmt_entry(instance, index, type)
		return cast(type, (cast("void***", instance)[0])[index])
	end

	-- SteamAPI_RunCallbacks = find_sig("steam_api.dll", "\x32\xC9\x83\x3D\xCC\xCC\xCC\xCC\xCC", "void(__cdecl*)(void)")

	SteamAPI_RegisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xFF\x75\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
	SteamAPI_UnregisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\xFF\x75\x10\xFF\x75\x0C", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")

	SteamAPI_RegisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
	SteamAPI_UnregisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\xEC\x08\x80\x3D", "void(__cdecl*)(struct SteamAPI_callback_base *)")

	client.set_event_callback("shutdown", function()
		for key, value in pairs(pending_call_results) do
			local instance = cast(callback_base_ptr, value)
			call_result_cancel(instance)
		end

		for key, value in pairs(registered_callbacks) do
			local instance = cast(callback_base_ptr, value)
			SteamAPI_UnregisterCallback(instance)
		end
	end)
end

--
-- ffi definitions
--

if not pcall(sizeof, "http_HHTMLBrowser") then
	ffi.cdef[[
		typedef uint32_t http_HHTMLBrowser;

		struct http_ISteamHTMLSurfaceVtbl {
			bool(__thiscall *ISteamHTMLSurface)(uintptr_t);
			bool(__thiscall *Init)(uintptr_t);
			bool(__thiscall *Shutdown)(uintptr_t);
			SteamAPICall_t(__thiscall *CreateBrowser)(uintptr_t, const char*, const char*);
			void(__thiscall *RemoveBrowser)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *LoadURL)(uintptr_t, http_HHTMLBrowser, const char*, const char*);
			void(__thiscall *SetSize)(uintptr_t, http_HHTMLBrowser, uint32_t, uint32_t);
			void(__thiscall *StopLoad)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *Reload)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *GoBack)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *GoForward)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *AddHeader)(uintptr_t, http_HHTMLBrowser, const char*, const char*);
			void(__thiscall *ExecuteJavascript)(uintptr_t, http_HHTMLBrowser, const char*);
			void(__thiscall *MouseUp)(uintptr_t, http_HHTMLBrowser, int);
			void(__thiscall *MouseDown)(uintptr_t, http_HHTMLBrowser, int);
			void(__thiscall *MouseDoubleClick)(uintptr_t, http_HHTMLBrowser, int);
			void(__thiscall *MouseMove)(uintptr_t, http_HHTMLBrowser, int, int);
			void(__thiscall *MouseWheel)(uintptr_t, http_HHTMLBrowser, int32_t);
			void(__thiscall *KeyDown)(uintptr_t, http_HHTMLBrowser, uint32_t, int, bool);
			void(__thiscall *KeyUp)(uintptr_t, http_HHTMLBrowser, uint32_t, int);
			void(__thiscall *KeyChar)(uintptr_t, http_HHTMLBrowser, uint32_t, int);
			void(__thiscall *SetHorizontalScroll)(uintptr_t, http_HHTMLBrowser, uint32_t);
			void(__thiscall *SetVerticalScroll)(uintptr_t, http_HHTMLBrowser, uint32_t);
			void(__thiscall *SetKeyFocus)(uintptr_t, http_HHTMLBrowser, bool);
			void(__thiscall *ViewSource)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *CopyToClipboard)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *PasteFromClipboard)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *Find)(uintptr_t, http_HHTMLBrowser, const char*, bool, bool);
			void(__thiscall *StopFind)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *GetLinkAtPosition)(uintptr_t, http_HHTMLBrowser, int, int);
			void(__thiscall *SetCookie)(uintptr_t, const char*, const char*, const char*, const char*, uint32_t, bool, bool);
			void(__thiscall *SetPageScaleFactor)(uintptr_t, http_HHTMLBrowser, float, int, int);
			void(__thiscall *SetBackgroundMode)(uintptr_t, http_HHTMLBrowser, bool);
			void(__thiscall *SetDPIScalingFactor)(uintptr_t, http_HHTMLBrowser, float);
			void(__thiscall *OpenDeveloperTools)(uintptr_t, http_HHTMLBrowser);
			void(__thiscall *AllowStartRequest)(uintptr_t, http_HHTMLBrowser, bool);
			void(__thiscall *JSDialogResponse)(uintptr_t, http_HHTMLBrowser, bool);
			void(__thiscall *FileLoadDialogResponse)(uintptr_t, http_HHTMLBrowser, const char**);
		};
	]]
end

--
-- constants
--

-- https://wiki.facepunch.com/steamworks/CallbackType
local CALLBACK_HTML_BrowserReady_t = 4501
local CALLBACK_HTML_NeedsPaint_t = 4502
local CALLBACK_HTML_StartRequest_t = 4503
local CALLBACK_HTML_CloseBrowser_t = 4504
local CALLBACK_HTML_URLChanged_t = 4505
local CALLBACK_HTML_FinishedRequest_t = 4506
local CALLBACK_HTML_OpenLinkInNewTab_t = 4507
local CALLBACK_HTML_ChangedTitle_t = 4508
local CALLBACK_HTML_SearchResults_t = 4509
local CALLBACK_HTML_CanGoBackAndForward_t = 4510
local CALLBACK_HTML_HorizontalScroll_t = 4511
local CALLBACK_HTML_VerticalScroll_t = 4512
local CALLBACK_HTML_LinkAtPosition_t = 4513
local CALLBACK_HTML_JSAlert_t = 4514
local CALLBACK_HTML_JSConfirm_t = 4515
local CALLBACK_HTML_FileOpenDialog_t = 4516
local CALLBACK_HTML_NewWindow_t = 4521
local CALLBACK_HTML_SetCursor_t = 4522
local CALLBACK_HTML_StatusText_t = 4523
local CALLBACK_HTML_ShowToolTip_t = 4524
local CALLBACK_HTML_UpdateToolTip_t = 4525
local CALLBACK_HTML_HideToolTip_t = 4526
local CALLBACK_HTML_BrowserRestarted_t = 4527

--
-- private functions
--

local function find_isteamhtmlsurface()
	local steam_client_context = find_sig(
		"client_panorama.dll",
		"\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x0F\x84",
		"uintptr_t",
		1, 1
	)

	local steamhtmlsurface = cast("uintptr_t*", steam_client_context)[18]

	if steamhtmlsurface == 0 then
		return error("find_isteamhtmlsurface failed")
	end

	local vmt = cast("struct http_ISteamHTMLSurfaceVtbl**", steamhtmlsurface)[0]
	if vmt == nil then
		return error("find_isteamhtmlsurface failed")
	end

	return steamhtmlsurface, vmt
end

local function func_bind(func, arg)
	return function(...)
		return func(arg, ...)
	end
end

--
-- isteamhtmlsurface callback types
--

local HTML_BrowserReady_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
} *
]])

local HTML_StartRequest_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchTarget;
	const char* pchPostData;
	bool bIsRedirect;
} *
]])

local HTML_FinishedRequest_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchPageTitle;
} *
]])

local HTML_JSAlert_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchMessage;
} *
]])

local HTML_JSConfirm_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchMessage;
} *
]])

local HTML_ChangedTitle_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchTitle;
} *
]])

local HTML_URLChanged_t_ptr = typeof([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchPostData;
	bool bIsRedirect;
	const char* pchPageTitle;
	bool bNewNavigation;
} *
]])

--
-- get isteamhtmlsurface interface
--

local steam_htmlsurface, steam_htmlsurface_vtable = find_isteamhtmlsurface()

--
-- isteamhtmlsurface functions
--

local native_ISteamHTMLSurface_Init = func_bind(steam_htmlsurface_vtable.Init, steam_htmlsurface)
local native_ISteamHTMLSurface_Shutdown = func_bind(steam_htmlsurface_vtable.Shutdown, steam_htmlsurface)
local native_ISteamHTMLSurface_CreateBrowser = func_bind(steam_htmlsurface_vtable.CreateBrowser, steam_htmlsurface)
local native_ISteamHTMLSurface_RemoveBrowser = func_bind(steam_htmlsurface_vtable.RemoveBrowser, steam_htmlsurface)
local native_ISteamHTMLSurface_LoadURL = func_bind(steam_htmlsurface_vtable.LoadURL, steam_htmlsurface)
local native_ISteamHTMLSurface_SetSize = func_bind(steam_htmlsurface_vtable.SetSize, steam_htmlsurface)
local native_ISteamHTMLSurface_StopLoad = func_bind(steam_htmlsurface_vtable.StopLoad, steam_htmlsurface)
local native_ISteamHTMLSurface_Reload = func_bind(steam_htmlsurface_vtable.Reload, steam_htmlsurface)
local native_ISteamHTMLSurface_GoBack = func_bind(steam_htmlsurface_vtable.GoBack, steam_htmlsurface)
local native_ISteamHTMLSurface_GoForward = func_bind(steam_htmlsurface_vtable.GoForward, steam_htmlsurface)
local native_ISteamHTMLSurface_AddHeader = func_bind(steam_htmlsurface_vtable.AddHeader, steam_htmlsurface)
local native_ISteamHTMLSurface_ExecuteJavascript = func_bind(steam_htmlsurface_vtable.ExecuteJavascript, steam_htmlsurface)
local native_ISteamHTMLSurface_MouseUp = func_bind(steam_htmlsurface_vtable.MouseUp, steam_htmlsurface)
local native_ISteamHTMLSurface_MouseDown = func_bind(steam_htmlsurface_vtable.MouseDown, steam_htmlsurface)
local native_ISteamHTMLSurface_MouseDoubleClick = func_bind(steam_htmlsurface_vtable.MouseDoubleClick, steam_htmlsurface)
local native_ISteamHTMLSurface_MouseMove = func_bind(steam_htmlsurface_vtable.MouseMove, steam_htmlsurface)
local native_ISteamHTMLSurface_MouseWheel = func_bind(steam_htmlsurface_vtable.MouseWheel, steam_htmlsurface)
local native_ISteamHTMLSurface_KeyDown = func_bind(steam_htmlsurface_vtable.KeyDown, steam_htmlsurface)
local native_ISteamHTMLSurface_KeyUp = func_bind(steam_htmlsurface_vtable.KeyUp, steam_htmlsurface)
local native_ISteamHTMLSurface_KeyChar = func_bind(steam_htmlsurface_vtable.KeyChar, steam_htmlsurface)
local native_ISteamHTMLSurface_SetHorizontalScroll = func_bind(steam_htmlsurface_vtable.SetHorizontalScroll, steam_htmlsurface)
local native_ISteamHTMLSurface_SetVerticalScroll = func_bind(steam_htmlsurface_vtable.SetVerticalScroll, steam_htmlsurface)
local native_ISteamHTMLSurface_SetKeyFocus = func_bind(steam_htmlsurface_vtable.SetKeyFocus, steam_htmlsurface)
local native_ISteamHTMLSurface_ViewSource = func_bind(steam_htmlsurface_vtable.ViewSource, steam_htmlsurface)
local native_ISteamHTMLSurface_CopyToClipboard = func_bind(steam_htmlsurface_vtable.CopyToClipboard, steam_htmlsurface)
local native_ISteamHTMLSurface_PasteFromClipboard = func_bind(steam_htmlsurface_vtable.PasteFromClipboard, steam_htmlsurface)
local native_ISteamHTMLSurface_Find = func_bind(steam_htmlsurface_vtable.Find, steam_htmlsurface)
local native_ISteamHTMLSurface_StopFind = func_bind(steam_htmlsurface_vtable.StopFind, steam_htmlsurface)
local native_ISteamHTMLSurface_GetLinkAtPosition = func_bind(steam_htmlsurface_vtable.GetLinkAtPosition, steam_htmlsurface)
local native_ISteamHTMLSurface_SetCookie = func_bind(steam_htmlsurface_vtable.SetCookie, steam_htmlsurface)
local native_ISteamHTMLSurface_SetPageScaleFactor = func_bind(steam_htmlsurface_vtable.SetPageScaleFactor, steam_htmlsurface)
local native_ISteamHTMLSurface_SetBackgroundMode = func_bind(steam_htmlsurface_vtable.SetBackgroundMode, steam_htmlsurface)
local native_ISteamHTMLSurface_SetDPIScalingFactor = func_bind(steam_htmlsurface_vtable.SetDPIScalingFactor, steam_htmlsurface)
local native_ISteamHTMLSurface_OpenDeveloperTools = func_bind(steam_htmlsurface_vtable.OpenDeveloperTools, steam_htmlsurface)
local native_ISteamHTMLSurface_AllowStartRequest = func_bind(steam_htmlsurface_vtable.AllowStartRequest, steam_htmlsurface)
local native_ISteamHTMLSurface_JSDialogResponse = func_bind(steam_htmlsurface_vtable.JSDialogResponse, steam_htmlsurface)
local native_ISteamHTMLSurface_FileLoadDialogResponse = func_bind(steam_htmlsurface_vtable.FileLoadDialogResponse, steam_htmlsurface)

--
-- handle to our browser, forward declared
--

local browser_handle

--
-- communication with web page
--

local handlers = {}
local Client = {
	send = function(message)
		if browser_handle ~= nil then
			native_ISteamHTMLSurface_ExecuteJavascript(browser_handle, string.format("Client.receive(%s)", json.stringify(message)))
		end
	end,
	receive = function(message, transport)
		message = json.parse(message)

		-- print("received message: ", inspect(message))

		if handlers[message.type] ~= nil then
			handlers[message.type](message)
		end
	end,
	register_handler = function(type, callback)
		handlers[type] = callback
	end
}

-- rpc server
local rpc_functions = {}
local RPCServer = {
	register = function(name, callback)
		rpc_functions[name] = callback
	end
}

Client.register_handler("rpc", function(message)
	if rpc_functions[message.method] then
		local resp = {
			type = "rpc_resp",
			id = message.id
		}

		local success, ret = pcall(rpc_functions[message.method], unpack(message.params or {}))

		if success then
			resp.result = ret
		else
			resp.error = ret
		end

		Client.send(resp)
	end
end)

local pending_rpc_callbacks, rpc_index = {}, 0
local RPCClient = {
	call = function(method, callback, ...)
		rpc_index = rpc_index + 1

		local message = {
			type = "rpc",
			method = method,
			id = rpc_index
		}

		local args = {...}

		if #args > 0 then
			message.params = args
		end

		pending_rpc_callbacks[rpc_index] = callback
		Client.send(message)
	end
}

Client.register_handler("rpc_resp", function(resp)
	if pending_rpc_callbacks[resp.id] ~= nil then
		if resp.error ~= nil then
			xpcall(pending_rpc_callbacks[resp.id], client.error_log, resp.error)
		else
			xpcall(pending_rpc_callbacks[resp.id], client.error_log, nil, resp.result)
		end
	end
end)

--
-- browser implementation
--

-- creates a browser, loads our js and calls the callback when done
local function setup_browser(browser_ready_callback)
	-- setup the steam callbacks
	local js_string = [[
		// communication with client
		var Client = (function(){
			var handlers = {}
			var _SendMessage = function(message) {
				var json = JSON.stringify(message)

				// console.log(`sending ${json}`)

				if(json.length > 10200) {
					// alert has a size limit, so we need to use document.location.hash - should be rare since it has its own rate limiting too
					var ensureChangeChar = document.location.hash[1] == "h" ? "H" : "h"

					// setting location causes a HTML_ChangedTitle_t event (even if the title didnt actually change) so we set it to an empty string here and avoid that
					document.title = ""
					document.location.hash = ensureChangeChar + json

					// console.log("used hash with ensureChangeChar " + JSON.stringify(ensureChangeChar))
				} else if(json.length > 4090) {
					// alert has no rate limit but is rather slow (and limited to 10240 chars), so only use it if its required
					alert(json)
					// console.log("used alert")
				} else {
					// title has an even smaller size limit (4096), but its the fastest
					var ensureChangeChar = document.title[0] == "t" ? "T" : "t"
					document.title = ensureChangeChar + json
					// console.log("used title with ensureChangeChar " + JSON.stringify(ensureChangeChar) + " because title is " + JSON.stringify(document.title))
				}
			}

			var _RegisterHandler = function(type, callback) {
				handlers[type] = callback
			}

			var _ReceiveMessage = function(message) {
				if(handlers[message.type]) {
					handlers[message.type](message)
				}
			}

			return {
				send: _SendMessage,
				register_handler: _RegisterHandler,
				receive: _ReceiveMessage
			}
		})()

		var RPCServer = (function(){
			var rpc_functions = {}

			// internal func to handle incoming RPC messages
			var _RPCHandler = function(message) {
				if(rpc_functions[message.method]) {
					var resp = {
						type: "rpc_resp",
						id: message.id
					}

					try {
						var params = message.params || []

						resp.result = rpc_functions[message.method](...params)
					} catch (e) {
						resp.error = e.toString()
					}

					Client.send(resp)
				}
			}
			Client.register_handler("rpc", _RPCHandler)

			var _RegisterRPCFunction = function(name, callback) {
				rpc_functions[name] = callback
			}

			return {
				register: _RegisterRPCFunction
			}
		})()

		RPCServer.register("add", function(a, b){
			return a + b
		})

		var RPCClient = (function(){
			var index = 0
			var pending_requests = {}

			var _RPCRespHandler = function(message) {
				if(pending_requests[message.id]) {
					if(message.error) {
						pending_requests[message.id].reject(message.error)
					} else {
						pending_requests[message.id].resolve(message.result)
					}
					pending_requests[message.id] = null
				}
			}
			Client.register_handler("rpc_resp", _RPCRespHandler)

			var _Call = async function(method, params) {
				index += 1
				var req = {
					type: "rpc",
					method: method,
					id: index
				}

				if(params) {
					req.params = params
				}

				var result = new Promise((resolve, reject) => {
					pending_requests[index] = {resolve: resolve, reject: reject}
				})

				Client.send(req)

				return result
			}

			return {
				call: _Call
			}
		})()

		// websocket implementation
		var ws_api = (function(){
			var open_websockets = []
			var socket_index = 0

			var _OnOpen = function(index, e) {
				RPCClient.call("ws_open", [index, {extensions: e.target.extensions, protocol: e.target.protocol}])
			}

			var _OnMessage = function(index, e) {
				RPCClient.call("ws_message", [index, e.data])
			}

			var _OnClose = function(index, e) {
				RPCClient.call("ws_closed", [index, e.code, e.reason, e.wasClean])
				open_websockets[index] = null
			}

			var _OnError = function(index, error) {
				RPCClient.call("ws_error", [index])
			}

			RPCServer.register("ws_create", function(url, protocols){
				var index = socket_index++
				console.log(`creating websocket with index ${index}`)
				var socket = (typeof protocols != "undefined") ? (new WebSocket(url, protocols)) : (new WebSocket(url))

				socket.onopen = _OnOpen.bind(null, index)
				socket.onmessage = _OnMessage.bind(null, index)
				socket.onclose = _OnClose.bind(null, index)
				socket.onerror = _OnError.bind(null, index)

				open_websockets[index] = socket

				return index
			})

			RPCServer.register("ws_send", function(index, data){
				if(open_websockets[index]) {
					console.log("sending ", data)
					open_websockets[index].send(data)
				}
			})

			RPCServer.register("ws_close", function(index, code, reason){
				if(open_websockets[index]) {
					open_websockets[index].close(code, reason)
				}
			})
		})()

		RPCClient.call("browser_ready")
	]]

	local js_loaded = false

	local function browser_ready(param, io_failure)
		if param == nil then
			return
		end

		local data = cast(HTML_BrowserReady_t_ptr, param)

		if data.unBrowserHandle == nil then
			return
		end

		-- our browser is ready
		browser_handle = data.unBrowserHandle

		-- load blank page so we can load our js
		native_ISteamHTMLSurface_LoadURL(browser_handle, "about:blank", "")

		-- debug stuff yo
		-- native_ISteamHTMLSurface_OpenDeveloperTools(browser_handle)
	end

	-- required to allow navigation
	register_callback(CALLBACK_HTML_StartRequest_t, function(param, io_failure)
		if param == nil then return end

		local data = cast(HTML_StartRequest_t_ptr, param)

		if data.unBrowserHandle == browser_handle then
			native_ISteamHTMLSurface_AllowStartRequest(browser_handle, true)
			-- native_ISteamHTMLSurface_ExecuteJavascript(browser_handle, [[window.stop()]])
		end
	end)

	-- alert handler
	register_callback(CALLBACK_HTML_JSAlert_t, function(param, io_failure)
		if param == nil then return end

		local data = cast(HTML_JSAlert_t_ptr, param)

		if data.unBrowserHandle == browser_handle and data.pchMessage ~= nil then
			local message = ffi.string(data.pchMessage)

			Client.receive(message, "alert")
			native_ISteamHTMLSurface_JSDialogResponse(browser_handle, false)
		end
	end)

	register_callback(CALLBACK_HTML_ChangedTitle_t, function(param, io_failure)
		if param == nil then return end

		local data = cast(HTML_ChangedTitle_t_ptr, param)

		if data.unBrowserHandle == browser_handle and data.pchTitle ~= nil then
			local message = ffi.string(data.pchTitle)

			if js_loaded then
				message = message:gsub("^about:blank#", "")

				local first_char = message:sub(1, 1)

				if first_char == "t" or first_char == "T" then
					Client.receive(message:sub(2, -1), "changedtitle")
				end
			else
				if message == "about:blank" then
					native_ISteamHTMLSurface_ExecuteJavascript(browser_handle, js_string)

					js_loaded = true

					if browser_ready_callback ~= nil then
						xpcall(browser_ready_callback, client.error_log)
					end
				end
			end
		end
	end)

	register_callback(CALLBACK_HTML_URLChanged_t, function(param, io_failure)
		if param == nil then return end

		local data = cast(HTML_URLChanged_t_ptr, param)

		if data.unBrowserHandle == browser_handle and data.bNewNavigation == false and data.bIsRedirect == false and data.pchURL ~= nil then
			local pchURL = ffi.string(data.pchURL)

			if js_loaded then
				local sub = pchURL:sub(1, 13)

				-- make sure its a message dedicated to the hash
				if sub == "about:blank#h" or sub == "about:blank#H" then
					Client.receive(pchURL:sub(14, -1), "hash")
				end
			end
		end
	end)

	local call_handle = native_ISteamHTMLSurface_CreateBrowser(nil, nil)
	register_call_result(call_handle, browser_ready, CALLBACK_HTML_BrowserReady_t)

	client.set_event_callback("shutdown", function()
		if browser_handle ~= nil then
			native_ISteamHTMLSurface_RemoveBrowser(browser_handle)
			browser_handle = nil
		end
	end)
end

--
-- websocket client (lua) implementation
--

local open_websockets, open_websockets_data = {}, setmetatable({}, {__mode = "k"})

local function ws_rpc_callback(self, err, res)
	if err ~= nil then
		local ws_data = open_websockets_data[self]

		if ws_data ~= nil and ws_data.callback_error ~= nil then
			xpcall(ws_data.callback_error, client.error_log, self, err)
		end
	end
end

local websocket_mt = {
	__metatable = false
}
websocket_mt.__index = {
	close = function(self, code, reason)
		local ws_data = open_websockets_data[self]

		-- check if valid
		if ws_data == nil then return error("invalid websocket") end
		if not ws_data.open then return error("websocket not open") end

		RPCClient.call("ws_close", func_bind(ws_rpc_callback, self), ws_data.index, code, reason)
	end,
	send = function(self, data)
		local ws_data = open_websockets_data[self]

		-- check if valid
		if ws_data == nil then return error("invalid websocket") end
		if not ws_data.open then return error("websocket not open") end

		RPCClient.call("ws_send", func_bind(ws_rpc_callback, self), ws_data.index, tostring(data))
	end
}

--
-- websocket callbacks (rpc)
--

RPCServer.register("ws_open", function(index, event)
	local ws = open_websockets[index]
	local ws_data = open_websockets_data[ws]

	if ws_data ~= nil then
		ws.open = true
		ws_data.open = true

		ws.protocol = event.protocol
		ws.extensions = event.extensions

		if ws_data.callback_open ~= nil then
			xpcall(ws_data.callback_open, client.error_log, ws)
		end
	end
end)

RPCServer.register("ws_message", function(index, data)
	local ws = open_websockets[index]
	local ws_data = open_websockets_data[ws]

	if ws_data ~= nil then
		if ws_data.callback_message ~= nil then
			xpcall(ws_data.callback_message, client.error_log, ws, data)
		end
	end
end)

RPCServer.register("ws_closed", function(index, code, reason, was_clean)
	local ws = open_websockets[index]
	local ws_data = open_websockets_data[ws]

	if ws_data ~= nil then
		ws.open = false
		ws_data.open = false
		if ws_data.callback_close ~= nil then
			xpcall(ws_data.callback_close, client.error_log, ws, code, reason, was_clean)
		end

		open_websockets[index] = nil
		open_websockets_data[ws] = nil
	end
end)

RPCServer.register("ws_error", function(index, event)
	local ws = open_websockets[index]
	local ws_data = open_websockets_data[ws]

	if ws_data ~= nil then
		if ws_data.callback_error ~= nil then
			xpcall(ws_data.callback_error, client.error_log, ws)
		end
	end
end)

-- websocket data
local browser_ready_state, pending_websockets = 0, {}

local function create_websocket_impl(websocket, url, protocols, callbacks)
	local callback_error = callbacks.error

	-- save some data about it (internally and inaccessible to the user)
	open_websockets_data[websocket] = {
		open = false,
		callback_open = callbacks.open,
		callback_error = callback_error,
		callback_message = callbacks.message,
		callback_close = callbacks.close
	}

	-- actually call to js to create our websocket
	RPCClient.call("ws_create", function(err, index)
		if err then
			if callback_error ~= nil then
				xpcall(callback_error, client.error_log, websocket, err)
			end

			open_websockets_data[websocket] = nil

			return
		end

		-- websocket created successfully, save index for later
		open_websockets[index] = websocket
		open_websockets_data[websocket].index = index
	end, url, protocols)
end

local function create_websocket(url, options, callbacks)
	if callbacks == nil then
		callbacks = options
		options = nil
	end

	if type(url) ~= "string" then
		return error("Invalid url, has to be a string")
	end

	-- make sure callbacks are valid
	if type(callbacks) ~= "table" then
		return error("Invalid callbacks, has to be a table")
	elseif callbacks.open == nil or type(callbacks.open) ~= "function" then
		return error("Invalid callbacks, open callback has to be registered")
	elseif callbacks.open == nil and callbacks.error == nil and callbacks.message == nil and callbacks.close == nil then
		return error("Invalid callbacks, at least one callback has to be registered")
	elseif (callbacks.error ~= nil and type(callbacks.error) ~= "function") or (callbacks.message ~= nil and type(callbacks.message) ~= "function") or (callbacks.close ~= nil and type(callbacks.close) ~= "function") then
		return error("Invalid callbacks, all callbacks have to be functions")
	end

	-- parse options
	local protocols

	if type(options) == "table" then
		if type(options.protocols) == "string" then
			protocols = options.protocols
		elseif type(options.protocols) == "table" and #options.protocols > 0 then
			for i=1, #options.protocols do
				if type(options.protocols[i]) ~= "string" then
					return error("Invalid options.protocols, has to be an array of strings")
				end
			end
			protocols = options.protocols
		elseif options.protocols ~= nil then
			return error("Invalid options.protocols, has to be a string or array")
		end
	elseif options ~= nil then
		return error("Invalid options, has to be a table")
	end

	-- check if browser is ready
	if browser_ready_state == 0 then
		-- browser isnt ready, initialize it
		browser_ready_state = 1

		setup_browser(function()
			browser_ready_state = 2

			-- actually open pending websocket(s)
			for i=1, #pending_websockets do
				local pending_websocket = pending_websockets[i]
				xpcall(create_websocket_impl, client.error_log, pending_websocket.websocket, pending_websocket.url, pending_websocket.protocols, pending_websocket.callbacks)
			end
			pending_websockets = nil
		end)
	end

	-- create websocket open
	local websocket = setmetatable({
		url = url,
		open = false
	}, websocket_mt)

	if browser_ready_state ~= 2 then
		table.insert(pending_websockets, {websocket=websocket, url=url, protocols=protocols, callbacks=callbacks})
	else
		create_websocket_impl(websocket, url, protocols, callbacks)
	end

	-- give websocket handle to user
	return websocket
end

--
-- public module functions
--

local M = {
	connect = create_websocket
}

return M