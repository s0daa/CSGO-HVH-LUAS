--- @region: dependencies
local json = require "ch_json"
local base64 = require "ch_base64"
--- @endregion

--- @region: vtable
local function vtable_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end
--- @endregion

--- @region: enums
local cache = setmetatable({}, {__mode = "v"})

local inline_comment = "^%s*//[^\n]*\n()"
local multi_line_comment = "^%s*/%*.-*/%s*()"
local enumpat = "^(%s*([%w_][%a_]*)%s*(=?)%s*([x%x]*)%s*())"

local function enum(defs)
  	local cached = cache[defs]
  	if cached then return cached end

  	local N = 0
  	local pos = 1
  	local len = #defs
  	local res = {}
  	local coma = false

  	while true do
    	if pos == len + 1 then break end
    	if pos > len + 1 then error("LARGER: "..pos.." "..len) end

    	local p = defs:match(inline_comment, pos) or defs:match(multi_line_comment, pos)

    	if not p then
      		if coma then
        		p = defs:match("^%s*,%s*()", pos)
        		if not p then error"malformed enum: coma expected" end
        		coma = false
      		else
        		local chunk, name, eq, value
        		chunk, name, eq, value, p = defs:match(enumpat, pos)
        		if not p then error("malformed enum definition") end

        		if value ~= "" then
          			assert(value:find"^%-?%d+$" or value:find"0x%x+", "badly formed number "..value.." in enum")
         	 		N = tonumber(value)
        		end

        		local i = N
        		N = N + 1

        		if eq == "" and value == "" or eq == "=" and value ~= "" then
          			res[#res+1] = "  static const int "..name.." = "..i..";"
        		else
          			error("badly formed enum: " .. chunk)
        		end

        		coma = true
      		end
    	end

    	pos = p
  	end

  	res = ffi.new("struct{ \n"..table.concat(res, "\n").."\n}")
  	cache[defs] = res
  	return res
end
--- @endregion

--- @region: steam api
local register_call_result, register_callback, steam_client_context
do
	if not pcall(ffi.sizeof, "SteamAPICallty_t") then
		ffi.cdef[[
			typedef uint64_t SteamAPICallty_t;

			struct SteamAPI_callback_base_vtblt {
				void(__thiscall *run1)(struct SteamAPI_callback_baset *, void *, bool, uint64_t);
				void(__thiscall *run2)(struct SteamAPI_callback_baset *, void *);
				int(__thiscall *get_size)(struct SteamAPI_callback_baset *);
			};

			struct SteamAPI_callback_baset {
				struct SteamAPI_callback_base_vtblt *vtbl;
				uint8_t flags;
				int id;
				uint64_t api_call_handle;
				struct SteamAPI_callback_base_vtblt vtbl_storage[1];
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
	local GetAPICallFailureReason

	local callback_base = ffi.typeof("struct SteamAPI_callback_baset")
	local sizeof_callback_base = ffi.sizeof(callback_base)
	local callback_base_array = ffi.typeof("struct SteamAPI_callback_baset[1]")
	local callback_base_ptr = ffi.typeof("struct SteamAPI_callback_baset*")
	local uintptr_t = ffi.typeof("uintptr_t")
	local api_call_handlers = {}
	local pending_call_results = {}
	local registered_callbacks = {}

	local function pointer_key(p)
		return tostring(tonumber(ffi.cast(uintptr_t, p)))
	end

	local function callback_base_run_common(self, param, io_failure)
		if io_failure then
			io_failure = ESteamAPICallFailure[GetAPICallFailureReason(self.api_call_handle)] or "Unknown error"
		end

		-- prevent SteamAPI_UnregisterCallResult from being called for this callresult
		self.api_call_handle = 0

		xpcall(function()
			local key = pointer_key(self)
			local handler = api_call_handlers[key]
			if handler ~= nil then
				xpcall(handler, client.log, param, io_failure)
			end

			if pending_call_results[key] ~= nil then
				api_call_handlers[key] = nil
				pending_call_results[key] = nil
			end
		end, client.log)
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

	local callback_base_run1_ct = ffi.cast("void(__thiscall *)(struct SteamAPI_callback_baset *, void *, bool, uint64_t)", callback_base_run1)
	local callback_base_run2_ct = ffi.cast("void(__thiscall *)(struct SteamAPI_callback_baset *, void *)", callback_base_run2)
	local callback_base_get_size_ct = ffi.cast("int(__thiscall *)(struct SteamAPI_callback_baset *)", callback_base_get_size)

	function register_call_result(api_call_handle, handler, id)
		assert(api_call_handle ~= 0)
		local instance_storage = callback_base_array()
		local instance = ffi.cast(callback_base_ptr, instance_storage)

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
		local instance = ffi.cast(callback_base_ptr, instance_storage)

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

	local function find_sig(mdlname, pattern, typename, offset, deref_count)
		local raw_match = memory.find_pattern(mdlname, pattern) or error("signature not found", 2)
		local match = ffi.cast("uintptr_t", raw_match)

		if offset ~= nil and offset ~= 0 then
			match = match + offset
		end

		if deref_count ~= nil then
			for i = 1, deref_count do
				match = ffi.cast("uintptr_t*", match)[0]
				if match == nil then
					return error("signature not found")
				end
			end
		end

		return ffi.cast(typename, match)
	end

	SteamAPI_RegisterCallResult = find_sig("steam_api.dll", "55 8B EC 83 3D ?? ?? ?? ?? ?? 7E 0D 68 ?? ?? ?? ?? FF 15 ?? ?? ?? ?? 5D C3 FF 75 10", "void(__cdecl*)(struct SteamAPI_callback_baset *, uint64_t)")
	SteamAPI_UnregisterCallResult = find_sig("steam_api.dll", "55 8B EC FF 75 10 FF 75 0C", "void(__cdecl*)(struct SteamAPI_callback_baset *, uint64_t)")

	SteamAPI_RegisterCallback = find_sig("steam_api.dll", "55 8B EC 83 3D ?? ?? ?? ?? ?? 7E 0D 68 ?? ?? ?? ?? FF 15 ?? ?? ?? ?? 5D C3 C7 05", "void(__cdecl*)(struct SteamAPI_callback_baset *, int)")
	SteamAPI_UnregisterCallback = find_sig("steam_api.dll", "55 8B EC 83 EC 08 80 3D", "void(__cdecl*)(struct SteamAPI_callback_baset *)")

	steam_client_context = find_sig(
		"client.dll",
		"B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 83 3D ?? ?? ?? ?? ?? 0F 84",
		"uintptr_t",
		1, 1
	)

	-- initialize isteamutils and native_GetAPICallFailureReason
	local steamutils = ffi.cast("uintptr_t*", steam_client_context)[3]
	local native_GetAPICallFailureReason = vtable_entry(steamutils, 12, "int(__thiscall*)(void*, SteamAPICallty_t)")

	function GetAPICallFailureReason(handle)
		return native_GetAPICallFailureReason(steamutils, handle)
	end

	callbacks.add(e_callbacks.SHUTDOWN, function()
		for key, value in pairs(pending_call_results) do
			local instance = ffi.cast(callback_base_ptr, value)
			call_result_cancel(instance)
		end

		for key, value in pairs(registered_callbacks) do
			local instance = ffi.cast(callback_base_ptr, value)
			SteamAPI_UnregisterCallback(instance)
		end
	end)
end
--- @endregion

--- @region: ffi definitions
if not pcall(ffi.sizeof, "http_HTTPRequestHandlett") then
	ffi.cdef([[
		typedef uint32_t http_HTTPRequestHandlett;
		typedef uint32_t http_HTTPCookieContainerHandlet;

		enum http_EHTTPMethodt {
			k_EHTTPMethodInvalidt,
			k_EHTTPMethodGETt,
			k_EHTTPMethodHEADt,
			k_EHTTPMethodPOSTt,
			k_EHTTPMethodPUTt,
			k_EHTTPMethodDELETEt,
			k_EHTTPMethodOPTIONSt,
			k_EHTTPMethodPATCHt,
		};

		struct http_ISteamHTTPVtbl {
			http_HTTPRequestHandlett(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethodt, const char *);
			bool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandlett, uint64_t);
			bool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandlett, uint32_t);
			bool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandlett, const char *, const char *);
			bool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandlett, const char *, const char *);
			bool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandlett, SteamAPICallty_t *);
			bool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandlett, SteamAPICallty_t *);
			bool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandlett);
			bool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandlett);
			bool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandlett, const char *, uint32_t *);
			bool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandlett, const char *, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandlett, uint32_t *);
			bool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandlett, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandlett, uint32_t, uint8_t *, uint32_t);
			bool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandlett);
			bool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandlett, float *);
			bool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandlett, const char *, uint8_t *, uint32_t);
			http_HTTPCookieContainerHandlet(__thiscall *CreateCookieContainer)(uintptr_t, bool);
			bool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandlet);
			bool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandlet, const char *, const char *, const char *);
			bool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandlett, http_HTTPCookieContainerHandlet);
			bool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandlett, const char *);
			bool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandlett, bool);
			bool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandlett, uint32_t);
			bool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandlett, bool *pbWasTimedOut);
		};
	]])
end
--- @endregion

--- @region: constants
local http_EHTTPMethodt = enum[[
	k_EHTTPMethodInvalidt,
	k_EHTTPMethodGETt,
	k_EHTTPMethodHEADt,
	k_EHTTPMethodPOSTt,
	k_EHTTPMethodPUTt,
	k_EHTTPMethodDELETEt,
	k_EHTTPMethodOPTIONSt,
	k_EHTTPMethodPATCHt,
]]

local method_name_to_enum = {
	get = http_EHTTPMethodt.k_EHTTPMethodGETt,
	head = http_EHTTPMethodt.k_EHTTPMethodHEADt,
	post = http_EHTTPMethodt.k_EHTTPMethodPOSTt,
	put = http_EHTTPMethodt.k_EHTTPMethodPUTt,
	delete = http_EHTTPMethodt.k_EHTTPMethodDELETEt,
	options = http_EHTTPMethodt.k_EHTTPMethodOPTIONSt,
	patch = http_EHTTPMethodt.k_EHTTPMethodPATCHt,
}

local status_code_to_message = {
	[100]="Continue",[101]="Switching Protocols",[102]="Processing",[200]="OK",[201]="Created",[202]="Accepted",[203]="Non-Authoritative Information",[204]="No Content",[205]="Reset Content",[206]="Partial Content",[207]="Multi-Status",
	[208]="Already Reported",[250]="Low on Storage Space",[226]="IM Used",[300]="Multiple Choices",[301]="Moved Permanently",[302]="Found",[303]="See Other",[304]="Not Modified",[305]="Use Proxy",[306]="Switch Proxy",
	[307]="Temporary Redirect",[308]="Permanent Redirect",[400]="Bad Request",[401]="Unauthorized",[402]="Payment Required",[403]="Forbidden",[404]="Not Found",[405]="Method Not Allowed",[406]="Not Acceptable",[407]="Proxy Authentication Required",
	[408]="Request Timeout",[409]="Conflict",[410]="Gone",[411]="Length Required",[412]="Precondition Failed",[413]="Request Entity Too Large",[414]="Request-URI Too Long",[415]="Unsupported Media Type",[416]="Requested Range Not Satisfiable",
	[417]="Expectation Failed",[418]="I'm a teapot",[420]="Enhance Your Calm",[422]="Unprocessable Entity",[423]="Locked",[424]="Failed Dependency",[424]="Method Failure",[425]="Unordered Collection",[426]="Upgrade Required",[428]="Precondition Required",
	[429]="Too Many Requests",[431]="Request Header Fields Too Large",[444]="No Response",[449]="Retry With",[450]="Blocked by Windows Parental Controls",[451]="Parameter Not Understood",[451]="Unavailable For Legal Reasons",[451]="Redirect",
	[452]="Conference Not Found",[453]="Not Enough Bandwidth",[454]="Session Not Found",[455]="Method Not Valid in This State",[456]="Header Field Not Valid for Resource",[457]="Invalid Range",[458]="Parameter Is Read-Only",[459]="Aggregate Operation Not Allowed",
	[460]="Only Aggregate Operation Allowed",[461]="Unsupported Transport",[462]="Destination Unreachable",[494]="Request Header Too Large",[495]="Cert Error",[496]="No Cert",[497]="HTTP to HTTPS",[499]="Client Closed Request",[500]="Internal Server Error",
	[501]="Not Implemented",[502]="Bad Gateway",[503]="Service Unavailable",[504]="Gateway Timeout",[505]="HTTP Version Not Supported",[506]="Variant Also Negotiates",[507]="Insufficient Storage",[508]="Loop Detected",[509]="Bandwidth Limit Exceeded",
	[510]="Not Extended",[511]="Network Authentication Required",[551]="Option not supported",[598]="Network read timeout error",[599]="Network connect timeout error"
}

local single_allowed_keys = {"params", "body", "json"}

-- https://github.com/AlexApps99/SteamworksSDK/blob/fe3524b655eb9df6ae4d24e0ffb365357a370c7f/public/steam/isteamhttp.h#L162-L214
local CALLBACK_HTTPRequestCompleted = 2101
local CALLBACK_HTTPRequestHeadersReceived = 2102
local CALLBACK_HTTPRequestDataReceived = 2103
--- @endregion

--- @region: private functions
local function find_isteamhttp()
	local steamhttp = ffi.cast("uintptr_t*", steam_client_context)[12]

	if steamhttp == 0 or steamhttp == nil then
		return error("find_isteamhttp failed")
	end

	local vmt = ffi.cast("struct http_ISteamHTTPVtbl**", steamhttp)[0]
	if vmt == 0 or vmt == nil then
		return error("find_isteamhttp failed")
	end

	return steamhttp, vmt
end

local function func_bind(func, arg)
	return function(...)
		return func(arg, ...)
	end
end
--- @endregion

--- @region: steamhttp ffi stuff
local HTTPRequestCompleted_t_ptr = ffi.typeof[[
	struct {
		http_HTTPRequestHandlett m_hRequest;
		uint64_t m_ulContextValue;
		bool m_bRequestSuccessful;
		int m_eStatusCode;
		uint32_t m_unBodySize;
	} *
]]

local HTTPRequestHeadersReceived_t_ptr = ffi.typeof[[
	struct {
		http_HTTPRequestHandlett m_hRequest;
		uint64_t m_ulContextValue;
	} *
]]

local HTTPRequestDataReceived_t_ptr = ffi.typeof[[
	struct {
		http_HTTPRequestHandlett m_hRequest;
		uint64_t m_ulContextValue;
		uint32_t m_cOffset;
		uint32_t m_cBytesReceived;
	} *
]]

local CookieContainerHandle_t = ffi.typeof[[
	struct {
		http_HTTPCookieContainerHandlet m_hCookieContainer;
	}
]]

local SteamAPICallt_t_arr = ffi.typeof("SteamAPICallty_t[1]")
local char_ptr = ffi.typeof("const char[?]")
local unit8_ptr = ffi.typeof("uint8_t[?]")
local uint_ptr = ffi.typeof("unsigned int[?]")
local bool_ptr = ffi.typeof("bool[1]")
local float_ptr = ffi.typeof("float[1]")
--- @endregion

--- @region: get isteamhttp interface
local steam_http, steam_http_vtable = find_isteamhttp()
--- @endregion

--- @region: isteamhttp functions
local native_CreateHTTPRequest = func_bind(steam_http_vtable.CreateHTTPRequest, steam_http)
local native_SetHTTPRequestContextValue = func_bind(steam_http_vtable.SetHTTPRequestContextValue, steam_http)
local native_SetHTTPRequestNetworkActivityTimeout = func_bind(steam_http_vtable.SetHTTPRequestNetworkActivityTimeout, steam_http)
local native_SetHTTPRequestHeaderValue = func_bind(steam_http_vtable.SetHTTPRequestHeaderValue, steam_http)
local native_SetHTTPRequestGetOrPostParameter = func_bind(steam_http_vtable.SetHTTPRequestGetOrPostParameter, steam_http)
local native_SendHTTPRequest = func_bind(steam_http_vtable.SendHTTPRequest, steam_http)
local native_SendHTTPRequestAndStreamResponse = func_bind(steam_http_vtable.SendHTTPRequestAndStreamResponse, steam_http)
local native_DeferHTTPRequest = func_bind(steam_http_vtable.DeferHTTPRequest, steam_http)
local native_PrioritizeHTTPRequest = func_bind(steam_http_vtable.PrioritizeHTTPRequest, steam_http)
local native_GetHTTPResponseHeaderSize = func_bind(steam_http_vtable.GetHTTPResponseHeaderSize, steam_http)
local native_GetHTTPResponseHeaderValue = func_bind(steam_http_vtable.GetHTTPResponseHeaderValue, steam_http)
local native_GetHTTPResponseBodySize = func_bind(steam_http_vtable.GetHTTPResponseBodySize, steam_http)
local native_GetHTTPResponseBodyData = func_bind(steam_http_vtable.GetHTTPResponseBodyData, steam_http)
local native_GetHTTPStreamingResponseBodyData = func_bind(steam_http_vtable.GetHTTPStreamingResponseBodyData, steam_http)
local native_ReleaseHTTPRequest = func_bind(steam_http_vtable.ReleaseHTTPRequest, steam_http)
local native_GetHTTPDownloadProgressPct = func_bind(steam_http_vtable.GetHTTPDownloadProgressPct, steam_http)
local native_SetHTTPRequestRawPostBody = func_bind(steam_http_vtable.SetHTTPRequestRawPostBody, steam_http)
local native_CreateCookieContainer = func_bind(steam_http_vtable.CreateCookieContainer, steam_http)
local native_ReleaseCookieContainer = func_bind(steam_http_vtable.ReleaseCookieContainer, steam_http)
local native_SetCookie = func_bind(steam_http_vtable.SetCookie, steam_http)
local native_SetHTTPRequestCookieContainer = func_bind(steam_http_vtable.SetHTTPRequestCookieContainer, steam_http)
local native_SetHTTPRequestUserAgentInfo = func_bind(steam_http_vtable.SetHTTPRequestUserAgentInfo, steam_http)
local native_SetHTTPRequestRequiresVerifiedCertificate = func_bind(steam_http_vtable.SetHTTPRequestRequiresVerifiedCertificate, steam_http)
local native_SetHTTPRequestAbsoluteTimeoutMS = func_bind(steam_http_vtable.SetHTTPRequestAbsoluteTimeoutMS, steam_http)
local native_GetHTTPRequestWasTimedOut = func_bind(steam_http_vtable.GetHTTPRequestWasTimedOut, steam_http)
--- @endregion

--- @region: private variables
local completed_callbacks, is_in_callback = {}, false
local headers_received_callback_registered, headers_received_callbacks = false, {}
local data_received_callback_registered, data_received_callbacks = false, {}

-- weak table containing headers tbl -> cookie container handle
local cookie_containers = setmetatable({}, {__mode = "k"})

-- weak table containing headers tbl -> request handle
local headers_request_handles, request_handles_headers = setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "v"})

-- table containing in-flight http requests
local pending_requests = {}
--- @endregion

--- @region: response headers metatable
local response_headers_mt = {
	__index = function(req_key, name)
		local req = headers_request_handles[req_key]
		if req == nil then
			return
		end

		name = tostring(name)
		if req.m_hRequest ~= 0 then
			local header_size = uint_ptr(1)
			if native_GetHTTPResponseHeaderSize(req.m_hRequest, name, header_size) then
				if header_size ~= nil then
					header_size = header_size[0]
					if header_size < 0 then
						return
					end

					local buffer = unit8_ptr(header_size)
					if native_GetHTTPResponseHeaderValue(req.m_hRequest, name, buffer, header_size) then
						req_key[name] = ffi.string(buffer, header_size-1)
						return req_key[name]
					end
				end
			end
		end
	end,
	__metatable = false
}
--- @endregion

--- @region: cookie container metatable
local cookie_container_mt = {
	__index = {
		set_cookie = function(handle_key, host, url, name, value)
			local handle = cookie_containers[handle_key]
			if handle == nil or handle.m_hCookieContainer == 0 then
				return
			end

			native_SetCookie(handle.m_hCookieContainer, host, url, tostring(name) .. "=" .. tostring(value))
		end
	},
	__metatable = false
}
--- @endregion

--- @region: garbage collection callbaks
local function cookie_container_gc(handle)
	if handle.m_hCookieContainer ~= 0 then
		native_ReleaseCookieContainer(handle.m_hCookieContainer)
		handle.m_hCookieContainer = 0
	end
end

local function http_request_gc(req)
	if req.m_hRequest ~= 0 then
		native_ReleaseHTTPRequest(req.m_hRequest)
		req.m_hRequest = 0
	end
end

local function http_request_error(req_handle, ...)
	native_ReleaseHTTPRequest(req_handle)
	return error(...)
end

local function http_request_callback_common(req, callback, successful, data, ...)
	local headers = request_handles_headers[req.m_hRequest]
	if headers == nil then
		headers = setmetatable({}, response_headers_mt)
		request_handles_headers[req.m_hRequest] = headers
	end
	headers_request_handles[headers] = req
	data.headers = headers

	-- run callback
	is_in_callback = true
	xpcall(callback, client.log, successful, data, ...)
	is_in_callback = false
end

local function http_request_completed(param, io_failure)
	if param == nil then
		return
	end

	local req = ffi.cast(HTTPRequestCompleted_t_ptr, param)

	if req.m_hRequest ~= 0 then
		local callback = completed_callbacks[req.m_hRequest]

		-- if callback ~= nil the request was sent by us
		if callback ~= nil then
			completed_callbacks[req.m_hRequest] = nil
			data_received_callbacks[req.m_hRequest] = nil
			headers_received_callbacks[req.m_hRequest] = nil

			-- callback can be false
			if callback then
				local successful = io_failure == false and req.m_bRequestSuccessful
				local status = req.m_eStatusCode

				local response = {
					status = status
				}

				local body_size = req.m_unBodySize
				if successful and body_size > 0 then
					local buffer = unit8_ptr(body_size)
					if native_GetHTTPResponseBodyData(req.m_hRequest, buffer, body_size) then
						response.body = ffi.string(buffer, body_size)
					end
				elseif not req.m_bRequestSuccessful then
					local timed_out = bool_ptr()
					native_GetHTTPRequestWasTimedOut(req.m_hRequest, timed_out)
					response.timed_out = timed_out ~= nil and timed_out[0] == true
				end

				if status > 0 then
					response.status_message = status_code_to_message[status] or "Unknown status"
				elseif io_failure then
					response.status_message = string.format("IO Failure: %s", io_failure)
				else
					response.status_message = response.timed_out and "Timed out" or "Unknown error"
				end

				-- release http request on garbage collection
				-- ffi.gc(req, http_request_gc)

				http_request_callback_common(req, callback, successful, response)
			end

			http_request_gc(req)
		end
	end
end

local function http_request_headers_received(param, io_failure)
	if param == nil then
		return
	end

	local req = ffi.cast(HTTPRequestHeadersReceived_t_ptr, param)

	if req.m_hRequest ~= 0 then
		local callback = headers_received_callbacks[req.m_hRequest]
		if callback then
			http_request_callback_common(req, callback, io_failure == false, {})
		end
	end
end

local function http_request_data_received(param, io_failure)
	if param == nil then
		return
	end

	local req = ffi.cast(HTTPRequestDataReceived_t_ptr, param)

	if req.m_hRequest ~= 0 then
		local callback = data_received_callbacks[req.m_hRequest]
		if data_received_callbacks[req.m_hRequest] then
			local data = {}

			local download_percentage_prt = float_ptr()
			if native_GetHTTPDownloadProgressPct(req.m_hRequest, download_percentage_prt) then
				data.download_progress = tonumber(download_percentage_prt[0])
			end

			local buffer = unit8_ptr(req.m_cBytesReceived)
			if native_GetHTTPStreamingResponseBodyData(req.m_hRequest, req.m_cOffset, buffer, req.m_cBytesReceived) then
				data.body = ffi.string(buffer, req.m_cBytesReceived)
			end

			http_request_callback_common(req, callback, io_failure == false, data)
		end
	end
end

local function http_request_new(method, url, options, callbacks)
	-- support overload: http.request(method, url, callback)
	if type(options) == "function" and callbacks == nil then
		callbacks = options
		options = {}
	end

	options = options or {}

	local method = method_name_to_enum[string.lower(tostring(method))]
	if method == nil then
		return error("invalid HTTP method")
	end

	if type(url) ~= "string" then
		return error("URL has to be a string")
	end

	local completed_callback, headers_received_callback, data_received_callback
	if type(callbacks) == "function" then
		completed_callback = callbacks
	elseif type(callbacks) == "table" then
		completed_callback = callbacks.completed or callbacks.complete
		headers_received_callback = callbacks.headers_received or callbacks.headers
		data_received_callback = callbacks.data_received or callbacks.data

		if completed_callback ~= nil and type(completed_callback) ~= "function" then
			return error("callbacks.completed callback has to be a function")
		elseif headers_received_callback ~= nil and type(headers_received_callback) ~= "function" then
			return error("callbacks.headers_received callback has to be a function")
		elseif data_received_callback ~= nil and type(data_received_callback) ~= "function" then
			return error("callbacks.data_received callback has to be a function")
		end
	else
		return error("callbacks has to be a function or table")
	end

	local req_handle = native_CreateHTTPRequest(method, url)
	if req_handle == 0 then
		return error("Failed to create HTTP request")
	end

	local set_one = false
	for i, key in ipairs(single_allowed_keys) do
		if options[key] ~= nil then
			if set_one then
				return error("can only set options.params, options.body or options.json")
			else
				set_one = true
			end
		end
	end

	local json_body
	if options.json ~= nil then
		local success
		success, json_body = pcall(json.encode, options.json)

		if not success then
			return error("options.json is invalid: " .. json_body)
		end
	end

	-- WARNING:
	-- use http_request_error after this point to properly free the http request

	local network_timeout = options.network_timeout
	if network_timeout == nil then
		network_timeout = 10
	end

	if type(network_timeout) == "number" and network_timeout > 0 then
		if not native_SetHTTPRequestNetworkActivityTimeout(req_handle, network_timeout) then
			return http_request_error(req_handle, "failed to set network_timeout")
		end
	elseif network_timeout ~= nil then
		return http_request_error(req_handle, "options.network_timeout has to be of type number and greater than 0")
	end

	local absolute_timeout = options.absolute_timeout
	if absolute_timeout == nil then
		absolute_timeout = 30
	end

	if type(absolute_timeout) == "number" and absolute_timeout > 0 then
		if not native_SetHTTPRequestAbsoluteTimeoutMS(req_handle, absolute_timeout*1000) then
			return http_request_error(req_handle, "failed to set absolute_timeout")
		end
	elseif absolute_timeout ~= nil then
		return http_request_error(req_handle, "options.absolute_timeout has to be of type number and greater than 0")
	end

	local content_type = json_body ~= nil and "application/json" or "text/plain"
	local authorization_set

	local headers = options.headers
	if type(headers) == "table" then
		for name, value in pairs(headers) do
			name = tostring(name)
			value = tostring(value)

			local name_lower = string.lower(name)

			if name_lower == "content-type" then
				content_type = value
			elseif name_lower == "authorization" then
				authorization_set = true
			end

			if not native_SetHTTPRequestHeaderValue(req_handle, name, value) then
				return http_request_error(req_handle, "failed to set header " .. name)
			end
		end
	elseif headers ~= nil then
		return http_request_error(req_handle, "options.headers has to be of type table")
	end

	local authorization = options.authorization
	if type(authorization) == "table" then
		if authorization_set then
			return http_request_error(req_handle, "Cannot set both options.authorization and the 'Authorization' header.")
		end

		local username, password = authorization[1], authorization[2]
		local header_value = string_format("Basic %s", base64.encode(string.format("%s:%s", tostring(username), tostring(password)), "base64"))

		if not native_SetHTTPRequestHeaderValue(req_handle, "Authorization", header_value) then
			return http_request_error(req_handle, "failed to apply options.authorization")
		end
	elseif authorization ~= nil then
		return http_request_error(req_handle, "options.authorization has to be of type table")
	end

	local body = json_body or options.body
	if type(body) == "string" then
		local len = string.len(body)

		if not native_SetHTTPRequestRawPostBody(req_handle, content_type, ffi.cast("unsigned char*", body), len) then
			return http_request_error(req_handle, "failed to set post body")
		end
	elseif body ~= nil then
		return http_request_error(req_handle, "options.body has to be of type string")
	end

	local params = options.params
	if type(params) == "table" then
		for name, value in pairs(params) do
			name = tostring(name)

			if not native_SetHTTPRequestGetOrPostParameter(req_handle, name, tostring(value)) then
				return http_request_error(req_handle, "failed to set parameter " .. name)
			end
		end
	elseif params ~= nil then
		return http_request_error(req_handle, "options.params has to be of type table")
	end

	local require_ssl = options.require_ssl
	if type(require_ssl) == "boolean" then
		if not native_SetHTTPRequestRequiresVerifiedCertificate(req_handle, require_ssl == true) then
			return http_request_error(req_handle, "failed to set require_ssl")
		end
	elseif require_ssl ~= nil then
		return http_request_error(req_handle, "options.require_ssl has to be of type boolean")
	end

	local user_agent_info = options.user_agent_info
	if type(user_agent_info) == "string" then
		if not native_SetHTTPRequestUserAgentInfo(req_handle, tostring(user_agent_info)) then
			return http_request_error(req_handle, "failed to set user_agent_info")
		end
	elseif user_agent_info ~= nil then
		return http_request_error(req_handle, "options.user_agent_info has to be of type string")
	end

	local cookie_container = options.cookie_container
	if type(cookie_container) == "table" then
		local handle = cookie_containers[cookie_container]

		if handle ~= nil and handle.m_hCookieContainer ~= 0 then
			if not native_SetHTTPRequestCookieContainer(req_handle, handle.m_hCookieContainer) then
				return http_request_error(req_handle, "failed to set user_agent_info")
			end
		else
			return http_request_error(req_handle, "options.cookie_container has to a valid cookie container")
		end
	elseif cookie_container ~= nil then
		return http_request_error(req_handle, "options.cookie_container has to a valid cookie container")
	end

	local send_func = native_SendHTTPRequest
	local stream_response = options.stream_response
	if type(stream_response) == "boolean" then
		if stream_response then
			send_func = native_SendHTTPRequestAndStreamResponse

			-- at least one callback is required
			if completed_callback == nil and headers_received_callback == nil and data_received_callback == nil then
				return http_request_error(req_handle, "a 'completed', 'headers_received' or 'data_received' callback is required")
			end
		else
			-- completed callback is required and others cant be used
			if completed_callback == nil then
				return http_request_error(req_handle, "'completed' callback has to be set for non-streamed requests")
			elseif headers_received_callback ~= nil or data_received_callback ~= nil then
				return http_request_error(req_handle, "non-streamed requests only support 'completed' callbacks")
			end
		end
	elseif stream_response ~= nil then
		return http_request_error(req_handle, "options.stream_response has to be of type boolean")
	end

	if headers_received_callback ~= nil or data_received_callback ~= nil then
		headers_received_callbacks[req_handle] = headers_received_callback or false
		if headers_received_callback ~= nil then
			if not headers_received_callback_registered then
				register_callback(CALLBACK_HTTPRequestHeadersReceived, http_request_headers_received)
				headers_received_callback_registered = true
			end
		end

		data_received_callbacks[req_handle] = data_received_callback or false
		if data_received_callback ~= nil then
			if not data_received_callback_registered then
				register_callback(CALLBACK_HTTPRequestDataReceived, http_request_data_received)
				data_received_callback_registered = true
			end
		end
	end

	local call_handle = SteamAPICallt_t_arr()
	if not send_func(req_handle, call_handle) then
		native_ReleaseHTTPRequest(req_handle)

		if completed_callback ~= nil then
			completed_callback(false, {status = 0, status_message = "Failed to send request"})
		end

		return
	end

	if options.priority == "defer" or options.priority == "prioritize" then
		local func = options.priority == "prioritize" and native_PrioritizeHTTPRequest or native_DeferHTTPRequest

		if not func(req_handle) then
			return http_request_error(req_handle, "failed to set priority")
		end
	elseif options.priority ~= nil then
		return http_request_error(req_handle, "options.priority has to be 'defer' of 'prioritize'")
	end

	completed_callbacks[req_handle] = completed_callback or false
	if completed_callback ~= nil then
		register_call_result(call_handle[0], http_request_completed, CALLBACK_HTTPRequestCompleted)
	end
end

local function cookie_container_new(allow_modification)
	if allow_modification ~= nil and type(allow_modification) ~= "boolean" then
		return error("allow_modification has to be of type boolean")
	end

	local handle_raw = native_CreateCookieContainer(allow_modification == true)

	if handle_raw ~= nil then
		local handle = CookieContainerHandle_t(handle_raw)
		ffi.gc(handle, cookie_container_gc)

		local key = setmetatable({}, cookie_container_mt)
		cookie_containers[key] = handle

		return key
	end
end
--- @endregion

--- @region: public module functions
local M = {
	request = http_request_new,
	create_cookie_container = cookie_container_new
}

-- shortcut for http methods
for method in pairs(method_name_to_enum) do
	M[method] = function(...)
		return http_request_new(method, ...)
	end
end

local a = require("ffi")
local b =
    a.cast(
    "uint32_t**",
    a.cast(
        "char**",
        a.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) + 1
    )[0] + 48
)[0] or error("steam_http error")
local c = a.cast("void***", b) or error("steam_http_ptr error")
local d = c[0] or error("steam_http_ptr was null")
local function e(f, g)
    return function(...)
        return f(g, ...)
    end
end
local h = e(a.cast(a.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), d[0]), b)
local i = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), d[5]), b)
local j = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), d[9]), b)
local k = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), d[10]), b)
local l = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), d[11]), b)
local m = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), d[12]), b)
local n = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), d[3]), b)
local o = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), d[4]), b)
local p = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), d[21]), b)
local q = e(a.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", d[16]), b)
local r = e(a.cast(a.typeof("bool(__thiscall*)(void*, uint32_t)"), d[14]), b)
local s = {}
callbacks.add(
    e_callbacks.PAINT,
    function()
        for t, u in ipairs(s) do
            if global_vars.cur_time() - u.ls > u.task_interval then
                u:_process_tasks()
                u.ls = global_vars.cur_time()
            end
        end
    end
)
local v = {}
local w = {__index = v}
function v.new(x, y, z)
    return setmetatable({handle = x, url = y, callback = z, ticks = 0}, w)
end
local A = {}
local B = {__index = A}
function A.new(C, D, E)
    return setmetatable({status = C, body = D, headers = E}, B)
end
function A:success()
    return self.status == 200
end
local F = {state = {ok = 200, no_response = 204, timed_out = 408, unknown = 0}}
local G = {__index = F}
function F.new(H)
    H = H or {}
    local u =
        setmetatable(
        {
            requests = {},
            task_interval = H.task_interval or 0.3,
            enable_debug = H.debug or false,
            timeout = H.timeout or 10,
            ls = global_vars.cur_time()
        },
        G
    )
    table.insert(s, u)
    return u
end
local I = {["get"] = 1, ["head"] = 2, ["post"] = 3, ["put"] = 4, ["delete"] = 5, ["options"] = 6, ["patch"] = 7}
function F:request(J, K, L, M)
    if type(L) == "function" and M == nil then
        M = L
        L = {}
    end
    L = L or {}
    local N = I[tostring(J):lower()]
    local O = h(N, K)
    local P = "application/text"
    if type(L.headers) == "table" then
        for Q, R in pairs(L.headers) do
            Q = tostring(Q)
            R = tostring(R)
            if Q:lower() == "content-type" then
                P = R
            end
            n(O, Q, R)
        end
    end
    if type(L.body) == "string" then
        local S = L.body:len()
        q(O, P, a.cast("unsigned char*", L.body), S)
    end
    if type(L.params) == "table" then
        for T, U in pairs(L.params) do
            o(O, T, U)
        end
    end
    if type(L.user_agent_info) == "string" then
        p(O, L.user_agent_info)
    end
    if not i(O, 0) then
        return
    end
    local V = v.new(O, K, M)
    self:_debug("[HTTP] New %s request to: %s", J:upper(), K)
    table.insert(self.requests, V)
end
function F:get(K, M)
    local O = h(1, K)
    if not i(O, 0) then
        return
    end
    local V = v.new(O, K, M)
    self:_debug("[HTTP] New GET request to: %s", K)
    table.insert(self.requests, V)
end
function F:post(K, W, M)
    local O = h(3, K)
    for T, U in pairs(W) do
        o(O, T, U)
    end
    if not i(O, 0) then
        return
    end
    local V = v.new(O, K, M)
    self:_debug("[HTTP] New POST request to: %s", K)
    table.insert(self.requests, V)
end
function F:_process_tasks()
    for T, U in ipairs(self.requests) do
        local X = a.new("uint32_t[1]")
        self:_debug("[HTTP] Processing request #%s", T)
        if l(U.handle, X) then
            local Y = X[0]
            if Y > 0 then
                local Z = a.new("char[?]", Y)
                if m(U.handle, Z, Y) then
                    self:_debug("[HTTP] Request #%s finished. Invoking callback.", T)
                    U.callback(
                        A.new(
                            F.state.ok,
                            a.string(Z, Y),
                            setmetatable(
                                {},
                                {__index = function(_, a0)
                                        return F._get_header(U, a0)
                                    end}
                            )
                        )
                    )
                    table.remove(self.requests, T)
                    r(U.handle)
                end
            else
                U.callback(A.new(F.state.no_response, nil, {}))
                table.remove(self.requests, T)
                r(U.handle)
            end
        end
        local a1 = U.ticks + 1
        if a1 >= self.timeout then
            U.callback(A.new(F.state.timed_out, nil, {}))
            table.remove(self.requests, T)
            r(U.handle)
        else
            U.ticks = a1
        end
    end
end
function F:_debug(...)
    if self.enable_debug then
        client.log(string.format(...))
    end
end
function F._get_header(V, a2)
    local X = a.new("uint32_t[1]")
    if j(V.handle, a2, X) then
        local Y = X[0]
        local Z = a.new("char[?]", Y)
        if k(V.handle, a2, Z, Y) then
            return a.string(Z, Y)
        end
    end
    return nil
end
function F._bind(a3, a4)
    return function(...)
        return a3[a4](a3, ...)
    end
end

return {M, F}
--- @endregion