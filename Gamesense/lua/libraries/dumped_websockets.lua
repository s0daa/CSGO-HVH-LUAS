slot0 = require("ffi")
slot1 = slot0.typeof
slot2 = slot0.sizeof
slot3 = slot0.cast
slot4 = slot0.string
slot5 = slot0.gc
slot6 = string.format

function slot7(slot0, slot1, slot2, slot3, slot4)
	if slot3 ~= nil and slot3 ~= 0 then
		slot6 = uv0("uintptr_t", client.find_signature(slot0, slot1) or error("signature not found", 2)) + slot3
	end

	if slot4 ~= nil then
		for slot10 = 1, slot4 do
			if uv0("uintptr_t*", slot6)[0] == nil then
				return error("signature not found")
			end
		end
	end

	return uv0(slot2, slot6)
end

slot8, slot9 = nil

if not pcall(slot0.sizeof, "SteamAPICall_t") then
	slot0.cdef([[
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
		]])
end

slot10 = {
	[0] = "Steam gone",
	"Network failure",
	"Invalid handle",
	[-1.0] = "No failure",
	[3.0] = "Mismatched callback"
}
slot11, slot12, slot13, slot14 = nil
slot15 = slot1("struct SteamAPI_callback_base")
slot16 = slot2(slot15)
slot17 = slot1("struct SteamAPI_callback_base[1]")
slot18 = slot1("struct SteamAPI_callback_base*")
slot19 = slot1("uintptr_t")
slot20 = {}
slot21 = {}
slot22 = {}

function slot23(slot0)
	return tostring(tonumber(uv0(uv1, slot0)))
end

function slot24(slot0, slot1, slot2)
	slot0.api_call_handle = 0

	if uv1[uv0(slot0)] ~= nil then
		xpcall(slot4, client.error_log, slot1, slot2)
	end

	if uv2[slot3] ~= nil then
		uv1[slot3] = nil
		uv2[slot3] = nil
	end
end

function slot28(slot0)
	if slot0.api_call_handle ~= 0 then
		uv0(slot0, slot0.api_call_handle)

		slot0.api_call_handle = 0
		slot1 = uv1(slot0)
		uv2[slot1] = nil
		uv3[slot1] = nil
	end
end

pcall(slot0.metatype, slot15, {
	__gc = slot28,
	__index = {
		cancel = slot28
	}
})

slot29 = slot3("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", function (slot0, slot1, slot2, slot3)
	if slot3 == slot0.api_call_handle then
		uv0(slot0, slot1, slot2)
	end
end)
slot30 = slot3("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", function (slot0, slot1)
	uv0(slot0, slot1, false)
end)
slot31 = slot3("int(__thiscall *)(struct SteamAPI_callback_base *)", function (slot0)
	return uv0
end)

function slot8(slot0, slot1, slot2)
	assert(slot0 ~= 0)

	slot3 = uv0()
	slot4 = uv1(uv2, slot3)
	slot4.vtbl_storage[0].run1 = uv3
	slot4.vtbl_storage[0].run2 = uv4
	slot4.vtbl_storage[0].get_size = uv5
	slot4.vtbl = slot4.vtbl_storage
	slot4.api_call_handle = slot0
	slot4.id = slot2
	slot5 = uv6(slot4)
	uv7[slot5] = slot1
	uv8[slot5] = slot3

	uv9(slot4, slot0)

	return slot4
end

function slot9(slot0, slot1)
	assert(uv0[slot0] == nil)

	slot2 = uv1()
	slot3 = uv2(uv3, slot2)
	slot3.vtbl_storage[0].run1 = uv4
	slot3.vtbl_storage[0].run2 = uv5
	slot3.vtbl_storage[0].get_size = uv6
	slot3.vtbl = slot3.vtbl_storage
	slot3.api_call_handle = 0
	slot3.id = slot0
	uv8[uv7(slot3)] = slot1
	uv0[slot0] = slot2

	uv9(slot3, slot0)
end

function slot32(slot0, slot1, slot2)
	return uv0(slot2, uv0("void***", slot0)[0][slot1])
end

slot11 = slot7("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot12 = slot7("steam_api.dll", "U\\x8b\\xec\\xffu\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot13 = slot7("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xc7", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
slot14 = slot7("steam_api.dll", "U\\x8b\\xec\\x83\\xec\\x80=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")

client.set_event_callback("shutdown", function ()
	for slot3, slot4 in pairs(uv0) do
		uv3(uv1(uv2, slot4))
	end

	for slot3, slot4 in pairs(uv4) do
		uv5(uv1(uv2, slot4))
	end
end)

if not pcall(slot2, "http_HHTMLBrowser") then
	slot0.cdef([[
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
	]])
end

slot10 = 4501
slot11 = 4502
slot12 = 4503
slot13 = 4504
slot14 = 4505
slot15 = 4506
slot16 = 4507
slot17 = 4508
slot18 = 4509
slot19 = 4510
slot20 = 4511
slot21 = 4512
slot22 = 4513
slot23 = 4514
slot24 = 4515
slot25 = 4516
slot26 = 4521
slot27 = 4522
slot28 = 4523
slot29 = 4524
slot30 = 4525
slot31 = 4526
slot32 = 4527

function slot34(slot0, slot1)
	return function (...)
		return uv0(uv1, ...)
	end
end

slot35 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
} *
]])
slot36 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchTarget;
	const char* pchPostData;
	bool bIsRedirect;
} *
]])
slot37 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchPageTitle;
} *
]])
slot38 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchMessage;
} *
]])
slot39 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchMessage;
} *
]])
slot40 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchTitle;
} *
]])
slot41 = slot1([[
struct {
	http_HHTMLBrowser unBrowserHandle;
	const char* pchURL;
	const char* pchPostData;
	bool bIsRedirect;
	const char* pchPageTitle;
	bool bNewNavigation;
} *
]])
slot42, slot43 = function ()
	if uv1("uintptr_t*", uv0("client_panorama.dll", "\\xb9\\xcc\\xcc\\xcc\\xcc\\xe8\\xcc\\xcc\\xcc̃=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", "uintptr_t", 1, 1))[18] == 0 then
		return error("find_isteamhtmlsurface failed")
	end

	if uv1("struct http_ISteamHTMLSurfaceVtbl**", slot1)[0] == nil then
		return error("find_isteamhtmlsurface failed")
	end

	return slot1, slot2
end()
slot44 = slot34(slot43.Init, slot42)
slot45 = slot34(slot43.Shutdown, slot42)
slot46 = slot34(slot43.CreateBrowser, slot42)
slot47 = slot34(slot43.RemoveBrowser, slot42)
slot48 = slot34(slot43.LoadURL, slot42)
slot49 = slot34(slot43.SetSize, slot42)
slot50 = slot34(slot43.StopLoad, slot42)
slot51 = slot34(slot43.Reload, slot42)
slot52 = slot34(slot43.GoBack, slot42)
slot53 = slot34(slot43.GoForward, slot42)
slot54 = slot34(slot43.AddHeader, slot42)
slot55 = slot34(slot43.ExecuteJavascript, slot42)
slot56 = slot34(slot43.MouseUp, slot42)
slot57 = slot34(slot43.MouseDown, slot42)
slot58 = slot34(slot43.MouseDoubleClick, slot42)
slot59 = slot34(slot43.MouseMove, slot42)
slot60 = slot34(slot43.MouseWheel, slot42)
slot61 = slot34(slot43.KeyDown, slot42)
slot62 = slot34(slot43.KeyUp, slot42)
slot63 = slot34(slot43.KeyChar, slot42)
slot64 = slot34(slot43.SetHorizontalScroll, slot42)
slot65 = slot34(slot43.SetVerticalScroll, slot42)
slot66 = slot34(slot43.SetKeyFocus, slot42)
slot67 = slot34(slot43.ViewSource, slot42)
slot68 = slot34(slot43.CopyToClipboard, slot42)
slot69 = slot34(slot43.PasteFromClipboard, slot42)
slot70 = slot34(slot43.Find, slot42)
slot71 = slot34(slot43.StopFind, slot42)
slot72 = slot34(slot43.GetLinkAtPosition, slot42)
slot73 = slot34(slot43.SetCookie, slot42)
slot74 = slot34(slot43.SetPageScaleFactor, slot42)
slot75 = slot34(slot43.SetBackgroundMode, slot42)
slot76 = slot34(slot43.SetDPIScalingFactor, slot42)
slot77 = slot34(slot43.OpenDeveloperTools, slot42)
slot78 = slot34(slot43.AllowStartRequest, slot42)
slot79 = slot34(slot43.JSDialogResponse, slot42)
slot80 = slot34(slot43.FileLoadDialogResponse, slot42)
slot81 = nil
slot82 = {}
slot83 = {
	send = function (slot0)
		if uv0 ~= nil then
			uv1(uv0, string.format("Client.receive(%s)", json.stringify(slot0)))
		end
	end,
	receive = function (slot0, slot1)
		if uv0[json.parse(slot0).type] ~= nil then
			uv0[slot0.type](slot0)
		end
	end,
	register_handler = function (slot0, slot1)
		uv0[slot0] = slot1
	end
}
slot84 = {}
slot85 = {
	register = function (slot0, slot1)
		uv0[slot0] = slot1
	end
}

slot83.register_handler("rpc", function (slot0)
	if uv0[slot0.method] then
		slot2, slot3 = pcall(uv0[slot0.method], unpack(slot0.params or {}))

		if slot2 then
			-- Nothing
		else
			slot1.error = slot3
		end

		uv1.send({
			type = "rpc_resp",
			id = slot0.id,
			result = slot3
		})
	end
end)

slot86 = {}
slot87 = 0
slot88 = {
	call = function (slot0, slot1, ...)
		uv0 = uv0 + 1

		if #{
			...
		} > 0 then
			-- Nothing
		end

		uv1[uv0] = slot1

		uv2.send({
			type = "rpc",
			method = slot0,
			id = uv0,
			params = slot3
		})
	end
}

slot83.register_handler("rpc_resp", function (slot0)
	if uv0[slot0.id] ~= nil then
		if slot0.error ~= nil then
			xpcall(uv0[slot0.id], client.error_log, slot0.error)
		else
			xpcall(uv0[slot0.id], client.error_log, nil, slot0.result)
		end
	end
end)

function slot89(slot0)
	slot1 = [[
		// communication with lua
		var Client = (function(){
			var handlers = {}
			var _SendMessage = function(message) {
				var json = JSON.stringify(message)

				if(json.length > 10200) {
					// alert has a size limit, so we need to use document.location.hash - should be rare since it has its own rate limiting too
					var ensureChangeChar = document.location.hash[1] == "h" ? "H" : "h"

					// setting location causes a HTML_ChangedTitle_t event (even if the title didnt actually change) so we set it to an empty string here and avoid that
					document.title = ""
					document.location.hash = ensureChangeChar + json
				} else if(json.length > 4090) {
					// alert has no rate limit but is rather slow (and limited to 10240 chars), so only use it if its required
					alert(json)
				} else {
					// title has an even smaller size limit (4096), but its the fastest
					var ensureChangeChar = document.title[0] == "t" ? "T" : "t"
					document.title = ensureChangeChar + json
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
				if (e.data instanceof Blob) {
					e.data.arrayBuffer().then(buf => {
						var data = [...new Uint8Array(buf)]
						RPCClient.call("ws_message", [index, data])
					})
				} else if (e.data instanceof ArrayBuffer) {
					var data = [...new Uint8Array(e.data)]
					RPCClient.call("ws_message", [index, data])
				} else {
					RPCClient.call("ws_message", [index, e.data])
				}
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

				var socket = null
				try {
					socket = (typeof protocols != "undefined") ? (new WebSocket(url, protocols)) : (new WebSocket(url))

					socket.onopen = _OnOpen.bind(null, index)
					socket.onmessage = _OnMessage.bind(null, index)
					socket.onclose = _OnClose.bind(null, index)
					socket.onerror = _OnError.bind(null, index)
				} catch(e) {
					setTimeout(function() {
						RPCClient.call("ws_error", [index])
						RPCClient.call("ws_closed", [index, 1006, e.message.replace("Failed to construct 'WebSocket': ", ""), false])
					}, 10)
				}

				open_websockets[index] = socket

				return index
			})

			RPCServer.register("ws_send", function(index, data){
				if(open_websockets[index]) {
					// console.log("sending ", data)
					var ws = open_websockets[index]
					if (Array.isArray(data)) {
						// isBinary
						var u8 = new Uint8Array(data)
						ws.send(u8.buffer)
					} else {
						// isText
						ws.send(data)
					}
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
	slot2 = false

	uv4(uv5, function (slot0, slot1)
		if slot0 == nil then
			return
		end

		if uv0(uv1, slot0).unBrowserHandle == uv2 then
			uv3(uv2, true)
		end
	end)
	uv4(uv8, function (slot0, slot1)
		if slot0 == nil then
			return
		end

		if uv0(uv1, slot0).unBrowserHandle == uv2 and slot2.pchMessage ~= nil then
			uv4.receive(uv3.string(slot2.pchMessage), "alert")
			uv5(uv2, false)
		end
	end)
	uv4(uv13, function (slot0, slot1)
		if slot0 == nil then
			return
		end

		if uv0(uv1, slot0).unBrowserHandle == uv2 and slot2.pchTitle ~= nil then
			if uv4 then
				if uv3.string(slot2.pchTitle):gsub("^about:blank#", ""):sub(1, 1) == "t" or slot4 == "T" then
					uv5.receive(slot3:sub(2, -1), "changedtitle")
				end
			elseif slot3 == "about:blank" then
				uv6(uv2, uv7)

				uv4 = true

				if uv8 ~= nil then
					xpcall(uv8, client.error_log)
				end
			end
		end
	end)
	uv4(uv16, function (slot0, slot1)
		if slot0 == nil then
			return
		end

		if uv0(uv1, slot0).unBrowserHandle == uv2 and slot2.bNewNavigation == false and slot2.bIsRedirect == false and slot2.pchURL ~= nil then
			slot3 = uv3.string(slot2.pchURL)

			if uv4 and (slot3:sub(1, 13) == "about:blank#h" or slot4 == "about:blank#H") then
				uv5.receive(slot3:sub(14, -1), "hash")
			end
		end
	end)
	uv19(uv18(nil, ), function (slot0, slot1)
		if slot0 == nil then
			return
		end

		if uv0(uv1, slot0).unBrowserHandle == nil then
			return
		end

		uv2 = slot2.unBrowserHandle

		uv3(uv2, "about:blank", "")
	end, uv20)
	client.set_event_callback("shutdown", function ()
		if uv0 ~= nil then
			uv1(uv0)

			uv0 = nil
		end
	end)
end

slot90 = {}
slot91 = setmetatable({}, {
	__mode = "k"
})

function slot92(slot0, slot1, slot2)
	if slot1 ~= nil and uv0[slot0] ~= nil and slot3.callback_error ~= nil then
		xpcall(slot3.callback_error, client.error_log, slot0, slot1)
	end
end

slot93 = {
	__metatable = false,
	__index = {
		close = function (slot0, slot1, slot2)
			if uv0[slot0] == nil then
				return error("invalid websocket")
			end

			if not slot3.open then
				return error("websocket not open")
			end

			uv1.call("ws_close", uv2(uv3, slot0), slot3.index, slot1, slot2)
		end,
		send = function (slot0, slot1)
			if uv0[slot0] == nil then
				return error("invalid websocket")
			end

			if not slot2.open then
				return error("websocket not open")
			end

			uv1.call("ws_send", uv2(uv3, slot0), slot2.index, type(slot1) == "table" and slot1 or tostring(slot1))
		end
	}
}

slot85.register("ws_open", function (slot0, slot1)
	if uv1[uv0[slot0]] ~= nil then
		slot2.open = true
		slot3.open = true
		slot2.protocol = slot1.protocol
		slot2.extensions = slot1.extensions

		if slot3.callback_open ~= nil then
			xpcall(slot3.callback_open, client.error_log, slot2)
		end
	end
end)
slot85.register("ws_message", function (slot0, slot1)
	if uv1[uv0[slot0]] ~= nil and slot3.callback_message ~= nil then
		xpcall(slot3.callback_message, client.error_log, slot2, slot1)
	end
end)
slot85.register("ws_closed", function (slot0, slot1, slot2, slot3)
	if uv1[uv0[slot0]] ~= nil then
		slot4.open = false
		slot5.open = false

		if slot5.callback_close ~= nil then
			xpcall(slot5.callback_close, client.error_log, slot4, slot1, slot2, slot3)
		end

		uv0[slot0] = nil
		uv1[slot4] = nil
	end
end)
slot85.register("ws_error", function (slot0, slot1)
	if uv1[uv0[slot0]] ~= nil and slot3.callback_error ~= nil then
		xpcall(slot3.callback_error, client.error_log, slot2)
	end
end)

slot94 = 0
slot95 = {}

function slot96(slot0, slot1, slot2, slot3)
	uv0[slot0] = {
		open = false,
		callback_open = slot3.open,
		callback_error = slot3.error,
		callback_message = slot3.message,
		callback_close = slot3.close
	}

	uv1.call("ws_create", function (slot0, slot1)
		if slot0 then
			if uv0 ~= nil then
				xpcall(uv0, client.error_log, uv1, slot0)
			end

			uv2[uv1] = nil

			return
		end

		uv3[slot1] = uv1
		uv2[uv1].index = slot1
	end, slot1, slot2)
end

return {
	connect = function (slot0, slot1, slot2)
		if slot2 == nil then
			slot2 = slot1
			slot1 = nil
		end

		if type(slot0) ~= "string" then
			return error("Invalid url, has to be a string")
		end

		if type(slot2) ~= "table" then
			return error("Invalid callbacks, has to be a table")
		elseif slot2.open == nil or type(slot2.open) ~= "function" then
			return error("Invalid callbacks, open callback has to be registered")
		elseif slot2.open == nil and slot2.error == nil and slot2.message == nil and slot2.close == nil then
			return error("Invalid callbacks, at least one callback has to be registered")
		elseif slot2.error ~= nil and type(slot2.error) ~= "function" or slot2.message ~= nil and type(slot2.message) ~= "function" or slot2.close ~= nil and type(slot2.close) ~= "function" then
			return error("Invalid callbacks, all callbacks have to be functions")
		end

		slot3 = nil

		if type(slot1) == "table" then
			if type(slot1.protocols) == "string" then
				slot3 = slot1.protocols
			elseif type(slot1.protocols) == "table" and #slot1.protocols > 0 then
				for slot7 = 1, #slot1.protocols do
					if type(slot1.protocols[slot7]) ~= "string" then
						return error("Invalid options.protocols, has to be an array of strings")
					end
				end

				slot3 = slot1.protocols
			elseif slot1.protocols ~= nil then
				return error("Invalid options.protocols, has to be a string or array")
			end
		elseif slot1 ~= nil then
			return error("Invalid options, has to be a table")
		end

		if uv0 == 0 then
			uv0 = 1

			uv1(function ()
				uv0 = 2

				for slot3 = 1, #uv1 do
					slot4 = uv1[slot3]

					xpcall(uv2, client.error_log, slot4.websocket, slot4.url, slot4.protocols, slot4.callbacks)
				end

				uv1 = nil
			end)
		end

		if uv0 ~= 2 then
			table.insert(uv2, {
				websocket = setmetatable({
					open = false,
					url = slot0
				}, uv4),
				url = slot0,
				protocols = slot3,
				callbacks = slot2
			})
		else
			uv3(slot4, slot0, slot3, slot2)
		end

		return slot4
	end
}
