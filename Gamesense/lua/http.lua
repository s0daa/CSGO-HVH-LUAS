--
-- dependencies
--

local ffi = require "ffi"
local base64 = require "gamesense/base64"

local assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs = assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs
local client_log, client_delay_call, ui_get, string_format = client.log, client.delay_call, ui.get, string.format
local typeof, sizeof, cast, cdef, ffi_string, ffi_gc = ffi.typeof, ffi.sizeof, ffi.cast, ffi.cdef, ffi.string, ffi.gc
local string_lower, string_len, string_find = string.lower, string.len, string.find
local base64_encode = base64.encode

--
-- steam api
--

local register_call_result, register_callback, steam_client_context
do
	if not pcall(ffi.sizeof, "SteamAPICall_t") then
		cdef([[
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
		if io_failure then
			io_failure = ESteamAPICallFailure[GetAPICallFailureReason(self.api_call_handle)] or "Unknown error"
		end

		-- prevent SteamAPI_UnregisterCallResult from being called for this callresult
		self.api_call_handle = 0

		xpcall(function()
			local key = pointer_key(self)
			local handler = api_call_handlers[key]
			if handler ~= nil then
				xpcall(handler, client.error_log, param, io_failure)
			end

			if pending_call_results[key] ~= nil then
				api_call_handlers[key] = nil
				pending_call_results[key] = nil
			end
		end, client.error_log)
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

	local function vtable_entry(instance, index, type)
		return cast(type, (cast("void***", instance)[0])[index])
	end

	SteamAPI_RegisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xFF\x75\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
	SteamAPI_UnregisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\xFF\x75\x10\xFF\x75\x0C", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")

	SteamAPI_RegisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
	SteamAPI_UnregisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\xEC\x08\x80\x3D", "void(__cdecl*)(struct SteamAPI_callback_base *)")

	steam_client_context = find_sig(
		"client_panorama.dll",
		"\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x0F\x84",
		"uintptr_t",
		1, 1
	)

	-- initialize isteamutils and native_GetAPICallFailureReason
	local steamutils = cast("uintptr_t*", steam_client_context)[3]
	local native_GetAPICallFailureReason = vtable_entry(steamutils, 12, "int(__thiscall*)(void*, SteamAPICall_t)")

	function GetAPICallFailureReason(handle)
		return native_GetAPICallFailureReason(steamutils, handle)
	end

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

if not pcall(sizeof, "http_HTTPRequestHandle") then
	cdef([[
		typedef uint32_t http_HTTPRequestHandle;
		typedef uint32_t http_HTTPCookieContainerHandle;

		enum http_EHTTPMethod {
			k_EHTTPMethodInvalid,
			k_EHTTPMethodGET,
			k_EHTTPMethodHEAD,
			k_EHTTPMethodPOST,
			k_EHTTPMethodPUT,
			k_EHTTPMethodDELETE,
			k_EHTTPMethodOPTIONS,
			k_EHTTPMethodPATCH,
		};

		struct http_ISteamHTTPVtbl {
			http_HTTPRequestHandle(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethod, const char *);
			bool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandle, uint64_t);
			bool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandle, uint32_t);
			bool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);
			bool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);
			bool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);
			bool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);
			bool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandle, const char *, uint32_t *);
			bool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandle, uint32_t *);
			bool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint32_t, uint8_t *, uint32_t);
			bool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandle, float *);
			bool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);
			http_HTTPCookieContainerHandle(__thiscall *CreateCookieContainer)(uintptr_t, bool);
			bool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandle);
			bool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandle, const char *, const char *, const char *);
			bool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandle, http_HTTPCookieContainerHandle);
			bool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandle, const char *);
			bool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandle, bool);
			bool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandle, uint32_t);
			bool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandle, bool *pbWasTimedOut);
		};
	]])
end

--
-- constants
--

local method_name_to_enum = {
	get = ffi.C.k_EHTTPMethodGET,
	head = ffi.C.k_EHTTPMethodHEAD,
	post = ffi.C.k_EHTTPMethodPOST,
	put = ffi.C.k_EHTTPMethodPUT,
	delete = ffi.C.k_EHTTPMethodDELETE,
	options = ffi.C.k_EHTTPMethodOPTIONS,
	patch = ffi.C.k_EHTTPMethodPATCH,
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

--
-- private functions
--

local function find_isteamhttp()
	local steamhttp = cast("uintptr_t*", steam_client_context)[12]

	if steamhttp == 0 or steamhttp == nil then
		return error("find_isteamhttp failed")
	end

	local vmt = cast("struct http_ISteamHTTPVtbl**", steamhttp)[0]
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

--
-- steamhttp ffi stuff
--

local HTTPRequestCompleted_t_ptr = typeof([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
	bool m_bRequestSuccessful;
	int m_eStatusCode;
	uint32_t m_unBodySize;
} *
]])

local HTTPRequestHeadersReceived_t_ptr = typeof([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
} *
]])

local HTTPRequestDataReceived_t_ptr = typeof([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
	uint32_t m_cOffset;
	uint32_t m_cBytesReceived;
} *
]])

local CookieContainerHandle_t = typeof([[
struct {
	http_HTTPCookieContainerHandle m_hCookieContainer;
}
]])

local SteamAPICall_t_arr = typeof("SteamAPICall_t[1]")
local char_ptr = typeof("const char[?]")
local unit8_ptr = typeof("uint8_t[?]")
local uint_ptr = typeof("unsigned int[?]")
local bool_ptr = typeof("bool[1]")
local float_ptr = typeof("float[1]")

--
-- get isteamhttp interface
--

local steam_http, steam_http_vtable = find_isteamhttp()

--
-- isteamhttp functions
--

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

--
-- private variables
--

local completed_callbacks, is_in_callback = {}, false
local headers_received_callback_registered, headers_received_callbacks = false, {}
local data_received_callback_registered, data_received_callbacks = false, {}

-- weak table containing headers tbl -> cookie container handle
local cookie_containers = setmetatable({}, {__mode = "k"})

-- weak table containing headers tbl -> request handle
local headers_request_handles, request_handles_headers = setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "v"})

-- table containing in-flight http requests
local pending_requests = {}

--
-- response headers metatable
--

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
						req_key[name] = ffi_string(buffer, header_size-1)
						return req_key[name]
					end
				end
			end
		end
	end,
	__metatable = false
}

--
-- cookie container metatable
--

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

--
-- garbage collection callbaks
--

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
	xpcall(callback, client.error_log, successful, data, ...)
	is_in_callback = false
end

local function http_request_completed(param, io_failure)
	if param == nil then
		return
	end

	local req = cast(HTTPRequestCompleted_t_ptr, param)

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
						response.body = ffi_string(buffer, body_size)
					end
				elseif not req.m_bRequestSuccessful then
					local timed_out = bool_ptr()
					native_GetHTTPRequestWasTimedOut(req.m_hRequest, timed_out)
					response.timed_out = timed_out ~= nil and timed_out[0] == true
				end

				if status > 0 then
					response.status_message = status_code_to_message[status] or "Unknown status"
				elseif io_failure then
					response.status_message = string_format("IO Failure: %s", io_failure)
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

	local req = cast(HTTPRequestHeadersReceived_t_ptr, param)

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

	local req = cast(HTTPRequestDataReceived_t_ptr, param)

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
				data.body = ffi_string(buffer, req.m_cBytesReceived)
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

	local method = method_name_to_enum[string_lower(tostring(method))]
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
		success, json_body = pcall(json.stringify, options.json)

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

			local name_lower = string_lower(name)

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
		local header_value = string_format("Basic %s", base64_encode(string_format("%s:%s", tostring(username), tostring(password)), "base64"))

		if not native_SetHTTPRequestHeaderValue(req_handle, "Authorization", header_value) then
			return http_request_error(req_handle, "failed to apply options.authorization")
		end
	elseif authorization ~= nil then
		return http_request_error(req_handle, "options.authorization has to be of type table")
	end

	local body = json_body or options.body
	if type(body) == "string" then
		local len = string_len(body)

		if not native_SetHTTPRequestRawPostBody(req_handle, content_type, cast("unsigned char*", body), len) then
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

	local call_handle = SteamAPICall_t_arr()
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
		ffi_gc(handle, cookie_container_gc)

		local key = setmetatable({}, cookie_container_mt)
		cookie_containers[key] = handle

		return key
	end
end

--
-- public module functions
--

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

return M