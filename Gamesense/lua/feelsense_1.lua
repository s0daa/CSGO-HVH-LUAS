local ffi = require("ffi")
local clipboard = require("gamesense/clipboard") or error("Install Clipboard library!")
local base64 = require("gamesense/base64")
local pui = require("gamesense/pui") or error("Install PUI")
local vector = require("vector")
local lua_group = pui.group("aa","anti-aimbot angles") --pui
pui.accent = "77d136ff"


------блядство
local assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs = assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs
local client_log, client_delay_call, ui_get, string_format = client.log, client.delay_call, ui.get, string.format
local typeof, sizeof, cast, cdef, ffi_string, ffi_gc = ffi.typeof, ffi.sizeof, ffi.cast, ffi.cdef, ffi.string, ffi.gc
local string_lower, string_len, string_find = string.lower, string.len, string.find
local base64_encode = base64.encode

---
local libraries = {}
function libraries.lool_crack()
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
end

function libraries.send_hook()
    local hook_discord = { URL = '' }

    function hook_discord:send(...)
        local unifiedBody = {}
        local arguments = table.pack(...)
        for _, value in next, arguments do
            if type(value) == 'string' then
                unifiedBody.content = value
            end
        end
        libraries.lool_crack().post(self.URL, { body = json.stringify(unifiedBody), headers = { ['Content-Length'] = #json.stringify(unifiedBody), ['Content-Type'] = 'application/json' } }, function() end)
    end
    return {
        new = function(url)
            return setmetatable({ URL = url }, {__index = hook_discord})
        end
    }
end

---

---Opps
ffi.cdef[[
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
]]

local material_system = client.create_interface('materialsystem.dll', 'VMaterialSystem080')
local material_interface = ffi.cast('void***', material_system)[0]

local get_current_adapter = ffi.cast('get_current_adapter_fn', material_interface[25])
local get_adapter_info = ffi.cast('get_adapters_info_fn', material_interface[26])

local current_adapter = get_current_adapter(material_interface)

local adapter_struct = ffi.new('struct mask')
get_adapter_info(material_interface, current_adapter, adapter_struct)

local driverName = tostring(ffi.string(adapter_struct['m_pDriverName']))
local vendorId_feel = tostring(adapter_struct['m_VendorID'])
local deviceId_feel = tostring(adapter_struct['m_DeviceID'])
class_ptr = ffi.typeof("void***")
rawfilesystem = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
filesystem = ffi.cast(class_ptr, rawfilesystem)
file_exists = ffi.cast("file_exists_t", filesystem[0][10])
get_file_time = ffi.cast("get_file_time_t", filesystem[0][13])

function bruteforce_directory()
    for i = 65, 90 do
        local directory = string.char(i) .. ":\\Windows\\Setup\\State\\State.ini"

        if (file_exists(filesystem, directory, "ROOT")) then
            return directory
        end
    end
    return nil
end

local directory = bruteforce_directory()
local install_time_feel = get_file_time(filesystem, directory, "ROOT")
local hardwareID_feel = install_time_feel * 2

local hwid_feel = ((vendorId_feel*deviceId_feel) * 2) + hardwareID_feel
--Opps end


local current = {
    check_access = false,
    check_key = false,
    build = "",
    hwid = hwid_feel,
    gpu = driverName,
    log = vendorId_feel.."&"..deviceId_feel,
}

local version = 0
--[[ 
    0 - stable
    1 - beta
    2 - private
]]--
local data_aye = {}
data_aye.database = {
    check = ":feelsense::version:",
    config = ":feelsense::config:",
}

local db = {}
db.build = database.read(data_aye.database.check) or {}

for i, v in pairs(db.build) do
    table.remove(db.build, i)
    if string.match(v, "Stable") then
        version = 0
        current.build = "Live"
    elseif string.match(v, "Beta") then
        version = 1
        current.build = "Beta"
    elseif string.match(v, "Alpha") then
        version = 2
        current.build = "Alpha"
    end
end


local log_ds_log = libraries.send_hook().new("https://discord.com/api/webhooks/1163423199694962750/KEFhOhhn5ezkPc6-hnTyBaq_Roj8c2wXAdbb_KDGUoso6TMJWnwEDleR4S2f7PSdVvaj")
local not_ds_log = libraries.send_hook().new("https://discord.com/api/webhooks/1163423280842166292/LUNd7_H2iAswJLTwVp2l1_rGKbAbBnVB7pn29KCuaWDcsnl-IBR-zqJ8ghKD4Who9fCR")
local ds_reg_check = libraries.send_hook().new("https://discord.com/api/webhooks/1163811296165244998/J5Pi5nhnYAjLkuXMwWOZbBPNUauug94BfkrzQKvDMBzJZraHPNyj0KRx0qEibiQA1Wgx")

local function check_access_sense()
    libraries.lool_crack().get("https://raw.githubusercontent.com/d1nam11c/d1n/main/json_check?token=GHSAT0AAAAAACPCW5D2TDNPVIRQYAVNV53YZPF2YIA", function(success, response)
        if not success or response.status ~= 200 then print("Bad Internet Connection") return end
    
        local data = json.parse(response.body)
    
        for _, row in ipairs(data) do
            current.hwid = tostring(current.hwid)
            row.hwid = tostring(row.hwid)
    
            if current.hwid == row.hwid and current.gpu == row.gpu and current.log == row.log then
                current.check_access = true
                print("Welcome Back, "..row.username.." | Version | "..current.build)
                log_ds_log:send("```Load Lua! Uid: "..row.uid.." | User: "..row.username.." | Build: ["..current.build.."] | Hwid: "..current.hwid.." | Log: "..current.log.." | GPU: "..current.gpu.."```")
                database.write(data_aye.database.check, {row.build}) -- версию сюда
            end
        end
        if current.check_access == false then
            print("You not have access. Just buy lua in discord server")
            not_ds_log:send("```Unknown User Load Lua. Hwid: "..current.hwid.." | Log: "..current.log.." | GPU: "..current.gpu.."```")
        end
    end)
end

check_access_sense()

client.set_event_callback("console_input", function(text)
    local key, username = text:match("reg%s+(%S+)%s+|%s+(%S+)")
    
    if key and username and current.check_access == false then
        client.log("Key: ", key)
        client.log("Username: ", username)

        libraries.lool_crack().get("http://host1864523.hostland.pro/json_check.php", function(success, response)
            if not success or response.status ~= 200 then
                print("Bad Internet Connection")
                return
            end

            local data = json.parse(response.body)

            for _, row in ipairs(data) do
                if tostring(row.user_key) == tostring(key) then
                    print("Key Found")
                    current.check_key = true

                    database.write(data_aye.database.check, {row.build}) -- версию сюда

                    local post_data = {
                        user_key = tostring(row.user_key),
                        hwid = tostring(current.hwid),
                        gpu = tostring(current.gpu),
                        log = tostring(current.log),
                        username = tostring(username)
                    }

                    libraries.lool_crack().post("https://raw.githubusercontent.com/d1nam11c/d1n/main/json_check?token=GHSAT0AAAAAACPCW5D2TDNPVIRQYAVNV53YZPF2YIA", { body = json.stringify(post_data), headers = { ['Content-Length'] = #json.stringify(post_data), ['Content-Type'] = 'application/json' } }, function(success, response) 
                        if success and response.status == 200 then
                            local hours, minutes, seconds = client.system_time()
                            print("Data updated successfully.")
                            ds_reg_check:send("```User Succesfully Registered. Uid: "..row.uid.." | Username: "..username.." | Build: "..row.build.." | Key: "..row.user_key.." | GPU: "..current.gpu.." | Time: "..hours..":"..minutes..":"..seconds.."```")
                        else
                            print("Failed to update data.")
                        end
                    end)
                end
            end
        end)
    end
end)
---end


local version_aa_fx = 
{
    jitter_type = {[0] = {'Default'},[1] = {'Default', 'Active'},[2] = {'Default', 'Active'}},
    yaw_type = {[0] = {'Default', 'l&r'},[1] = {'Default', 'l&r','Delayed Switch'},[2] = {'Default', 'l&r','Delayed Switch'}},
    defensive_yaw = {[0] = {'Spin', 'Side-Way', 'Random', 'Static'}, [1] = {'Spin', 'Side-Way', 'Random', },[2] = {'Spin', 'Side-Way', 'Random', 'Static'}},
    defensive_pitch = {[0] = {'Up', 'Zero', 'Random', 'Switch-Ways', 'Progressive', 'Custom'}, [1] = {'Up', 'Zero', 'Random', 'Switch-Ways'}, [2] = {'Up', 'Zero', 'Random', 'Switch-Ways', 'Progressive', 'Custom'}},
    name = {[0] = "live", [1] = "beta", [2] = "alpha"}

} 
local aa_config = { 'Global', 'Stand', 'Walking', 'Running' , 'Aerobic', 'Aerobic+', 'Duck', 'Duck+Move' }
local aa_short = { 'G', 'S', 'W', 'R' , 'A', 'A+', 'D', 'D+M' }
local dtModifier = 0    
local barMoveY = 0
local interval = 0
local x, y = client.screen_size()
local hex = function(arg)
    local result = "\a"
    for key, value in next, arg do
        local output = ""
        while value > 0 do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            output = string.sub("0123456789ABCDEF", index, index) .. output 
        end
        if #output == 0 then 
            output = "00" 
        elseif #output == 1 then 
            output = "0" .. output 
        end 
        result = result .. output
    end 
    return result .. "FF"
end
local other_funcs = {
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end,
    glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
        local thickness = 1
        local Offset = 1
        local r, g, b, a = unpack(accent)
        if accent_inner then
            rec(x, y, w, h + 1, rounding, accent_inner)
        end
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
            end
        end
    end,

    lerp = function(a, b, t)
        return a + (b - a) * t
    end,
    clamp = function(x, minval, maxval)
        if x < minval then
            return minval
        elseif x > maxval then
            return maxval
        else
            return x
        end
    end,
    rgba_to_hex = function(redArg, greenArg, blueArg, alphaArg)
        return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
    end,
}

local func_uses = {
    text_fade_animation = function(x, y, speed, color1, color2, text, flag)
        local final_text = ''
        local curtime = globals.curtime()
        for i = 0, #text do
            local x = i * 10  
            local wave = math.cos(8 * speed * curtime + x / 30)
            local color = other_funcs.rgba_to_hex(
                other_funcs.lerp(color1.r, color2.r, other_funcs.clamp(wave, 0, 1)),
                other_funcs.lerp(color1.g, color2.g, other_funcs.clamp(wave, 0, 1)),
                other_funcs.lerp(color1.b, color2.b, other_funcs.clamp(wave, 0, 1)),
                color1.a
            ) 
            final_text = final_text .. '\a' .. color .. text:sub(i, i) 
        end
        
        renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flag, nil, final_text)
    end,
}
--watermark_cringe
local version_fx =
{
    [0] = {"",{255,255,255}},
    [1] = {" [BETA]",{255, 46, 43}},
    [2] = {" [ALPHA]",{183, 78, 78}},
}
local text_fx = 
{
    ["Low Space"] = {"FEEL","SENSE"},
    ["High Space"] = {"F E E L ","S E N S E"}
}
--watermark_cringe

local data_aye = {}
data_aye.database = {
    check = ":feelsense::version:",
    config = ":feelsense::config:",
}

local feelsense = {
    main = {
        enable_lua = lua_group:checkbox("\vFeel\rSense".." ~ \r"..version_aa_fx.name[version]),
        enable_aye = lua_group:checkbox("Testing"),
        tab = lua_group:combobox('Current Tab', {'Anti~Aim', 'Visuals', "Misc",'Configs'}),
    },
    antiaim = {
        pitch = lua_group:combobox('Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        yawbase = lua_group:combobox('Yaw Base', {'Local View','At Targets'}),
        yaw = lua_group:combobox('Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        addons = lua_group:multiselect('Additions', {'Shit AA On Warmup', 'Anti Backstab'}),
        safe_head = lua_group:multiselect('Safe Head', {'Knife', 'Taser', 'SSG-08', 'AWP'}),
        yaw_direction = lua_group:multiselect('Yaw Directions', {'Freestanding', 'Manual AA', 'Edge Yaw'}),

        key_edge_yaw = lua_group:hotkey('   Edge Yaw'),
		key_freestand = lua_group:hotkey('   Freestanding'),
		key_left = lua_group:hotkey('   Manual Left'),
		key_right = lua_group:hotkey('   Manual Right'),
        space = lua_group:label('\r---> \vBuilder\r <---'),
        condition = lua_group:combobox('Condition', aa_config),
    },
    visual = {
        enable_indicators = lua_group:checkbox("Enable Crosshair Indicators",{86, 255, 160, 255}),
        font_selection = lua_group:combobox("Select Font", {"Default","Small"},{139, 139, 139, 255}),
        enable_arrows = lua_group:checkbox("Enable Manual Arrows",{86, 255, 160, 255}),
        enable_logs = lua_group:checkbox("Enable Pop-Up Logs",{86, 255, 160, 255}),
        selection_logs = lua_group:multiselect("Selection Pop-Up Logs",{"Hit Logs","Miss Logs"},{121, 199, 253, 255}),
        enable_watermark = lua_group:checkbox("Enable Watermark",{86, 255, 160, 255}),
        watermark_place = lua_group:combobox("Watermark Place",{"Left","Right","Bottom"}),
        watermark_text = lua_group:combobox("Watermark Text Type",{"Low Space","High Space"}),
        enable_windows = lua_group:multiselect("Windows",{"Defensive Manager","Slow-Down Indicator"},{86, 255, 160, 255}),
    },
    misc = {
        enable_fastladder = lua_group:checkbox("Enable Fast Ladder"),
        fastladder_select = lua_group:multiselect("Fast Ladder Mode",{"Ascending","Descending"}),
        enable_console_filter = lua_group:checkbox("Enable Console Filter")
    },
    config = {
        import = lua_group:button("Import Config", function() end),
        export = lua_group:button("Export Config", function() end),
        default = lua_group:button("Default Config", function() end),
    }
}

local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(h,i,j,...)table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=h,["g"]=i,["b"]=j,a=0},x=e().x/2,y=e().y,text=...},g)})end;function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=99,199,99 end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local k=(function()local d={}d.rec=function(d,b,c,e,f,g,k,l,m)m=math.min(d/2,b/2,m)renderer.rectangle(d,b+m,c,e-m*2,f,g,k,l)renderer.rectangle(d+m,b,c-m*2,m,f,g,k,l)renderer.rectangle(d+m,b+e-m,c-m*2,m,f,g,k,l)renderer.circle(d+m,b+m,f,g,k,l,m,180,.25)renderer.circle(d-m+c,b+m,f,g,k,l,m,90,.25)renderer.circle(d-m+c,b-m+e,f,g,k,l,m,0,.25)renderer.circle(d+m,b-m+e,f,g,k,l,m,-90,.25)end;d.rec_outline=function(d,b,c,e,f,g,k,l,m,n)m=math.min(c/2,e/2,m)if m==1 then renderer.rectangle(d,b,c,n,f,g,k,l)renderer.rectangle(d,b+e-n,c,n,f,g,k,l)else renderer.rectangle(d+m,b,c-m*2,n,f,g,k,l)renderer.rectangle(d+m,b+e-n,c-m*2,n,f,g,k,l)renderer.rectangle(d,b+m,n,e-m*2,f,g,k,l)renderer.rectangle(d+c-n,b+m,n,e-m*2,f,g,k,l)renderer.circle_outline(d+m,b+m,f,g,k,l,m,180,.25,n)renderer.circle_outline(d+m,b+e-m,f,g,k,l,m,90,.25,n)renderer.circle_outline(d+c-m,b+m,f,g,k,l,m,-90,.25,n)renderer.circle_outline(d+c-m,b+e-m,f,g,k,l,m,0,.25,n)end end;d.glow_module_notify=function(b,c,e,f,g,k,l,m,n,o,p,q,r,s,s)local t=1;local u=1;if s then d.rec(b,c,e,f,l,m,n,o,k)end;for l=0,g do local m=o/2*(l/g)^3;d.rec_outline(b+(l-g-u)*t,c+(l-g-u)*t,e-(l-g-u)*t*2,f-(l-g-u)*t*2,p,q,r,m/1.5,k+t*(g-l+u),t)end end;return d end)()function g:render_bottom(g,l)local e=e()local m=6;local n="     "..self:get_text()local f=f("",n)local o=8;local p=5;local q=0+m+f.x;local q,r=q+p*2,12+10+1;local s,t=self.x-q/2,math.ceil(self.y-40+.4)local u=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(l-g)*r*1.4,u*7)self.color.a=c(self.color.a,255,u*2)else self.y=c(self.y,self.y-10,u*15)self.color.a=c(self.color.a,0,u*20)if self.color.a<=1 then self.active=false end end;local c,e,g,l=self.color.r,self.color.g,self.color.b,self.color.a;local k=p+2;k=k+0+m;renderer.text(s+k,t+r/2-f.y/2,c,e,g,l,"b",nil,"FS" )renderer.text(s+k,t+r/2-f.y/2,c,e,g,l,"",nil,n)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()
local function remap(val, newmin, newmax, min, max, clamp)
	min = min or 0
	max = max or 1

	local pct = (val-min)/(max-min)

	if clamp ~= false then
		pct = math.min(1, math.max(0, pct))
	end

	return newmin+(newmax-newmin)*pct
end
local rec_outline = function(x, y, w, h, radius, thickness, color)
    radius = math.min(w/2, h/2, radius)
    local r, g, b, a = unpack(color)
    if radius == 1 then
        renderer.rectangle(x, y, w, thickness, r, g, b, a)
        renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
    else
        renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
    end
end
local rec = function(x, y, w, h, radius, color)
    radius = math.min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end
function renderer.outlined_rounded_rectangle(x, y, w, h, r, g, b, a, radius, thickness)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 270},
        {x + radius, y + h - radius * 2, 90},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y - radius, w - radius * 2, thickness},
        {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
        {x, y, thickness, h - radius * 2},
        {x + w - thickness, y, thickness, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end
local font = 
{
    ["Defualt"] = "b",
    ["Small"] = '-'
}

local binds = 
{
    {name = "DT", bind = {ui.reference("RAGE","Aimbot","Double tap")}},
    {name = "HS", bind = {ui.reference("AA","Other","On shot anti-aim")}},
    {name = "FS", bind = {ui.reference("AA","Anti-aimbot angles","Freestanding")}},
    {name = "FD", bind = {[2] = ui.reference("RAGE","Other","Duck peek assist")}},
    {name = "MD", bind = {ui.reference("RAGE","Aimbot","Minimum damage override")}}
}


-- FUNCTIONS AND OTHER CRINGE
local group_fx = 
{
    ["Main"] = feelsense.main,      
    ["Anti~Aim"] = feelsense.antiaim,
    ["Visuals"] = feelsense.visual,
    ["Misc"] = feelsense.misc,
}
local ref = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
	load_cfg = ui.reference('Config', 'Presets', 'Load'),
    dmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),

    --[1] = combobox/checkbox | [2] = slider/hotkey
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	quickpeek = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') },
	dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') }
}

local aa_builder = {}

for i=1, #aa_config do
    aa_builder[i] = {
        enable = lua_group:checkbox('Override ~ \v'..aa_config[i]),
        yaw_type = lua_group:combobox(aa_short[i]..' ~ Yaw Type', version_aa_fx.yaw_type[version]),
        delay_t = lua_group:slider(aa_short[i]..' ~ Delay Ticks', 1, 10, 3, true),
        static = lua_group:slider(aa_short[i]..' ~ Yaw', -180, 180, 0, true, '°', 1),
        yaw_l = lua_group:slider(aa_short[i]..' ~ Yaw Left', -180, 180, 0, true, '°', 1),
        yaw_r = lua_group:slider(aa_short[i]..' ~ Yaw Right', -180, 180, 0, true, '°', 1),
        mod_type = lua_group:combobox(aa_short[i]..' ~ Modifier Type', {'Off','Offset','Center','Random', 'Skitter'}),
        jitter_type = lua_group:combobox(aa_short[i]..' ~ Jitter Type', version_aa_fx.jitter_type[version]),
        mod_j = lua_group:slider(aa_short[i]..' ~ Jitter', -180, 180, 0, true, '°', 1),
        mod_l = lua_group:slider(aa_short[i]..' ~ Jitter Default', -180, 180, 0, true, '°', 1),
        mod_r = lua_group:slider(aa_short[i]..' ~ Jitter Active', -180, 180, 0, true, '°', 1),
        body_yaw = lua_group:combobox(aa_short[i]..' ~ Body Yaw', {'Off','Opposite','Jitter','Static'}),
        body_slider = lua_group:slider(aa_short[i]..' ~ Body Yaw Amount', -180, 180, 0, true, '°', 1),
        defensive_type = lua_group:combobox(aa_short[i]..' ~ Defensive', {'On Peek','Always On'}),
        defensive = lua_group:checkbox(aa_short[i]..' ~ Defensive Anti~Aim'),
        defensive_yaw = lua_group:combobox(aa_short[i]..' ~ Defensive Yaw', version_aa_fx.defensive_yaw[version]),
        yaw_amount = lua_group:slider(aa_short[i]..' ~ Offset', -180, 180, -180, true, '°', 1),
        spin = lua_group:slider(aa_short[i]..' ~ Spin Speed', -100, 100, 30, true, '%', 1),
        defensive_pitch = lua_group:combobox(aa_short[i]..' ~ Defensive Pitch', version_aa_fx.defensive_pitch[version]),
        pitch_amount = lua_group:slider(aa_short[i]..' ~ Pitch Amount', -89, 89, -49, true, '°', 1),
    }
end

local function hide_original_menu(state)
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.pitch[1], state)
    ui.set_visible(ref.pitch[2], state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.roll[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
end

feelsense_checker_access = false
local enabled = feelsense.main.enable_lua
local aa_tab = {feelsense.main.tab, "Anti~Aim"}
local visual_tab = {feelsense.main.tab, "Visuals"}
local misc_tab = {feelsense.main.tab, "Misc"}
local cfg_tab = {feelsense.main.tab, "Configs"}

feelsense.main.tab:depend(enabled, {feelsense.main.enable_aye, true})
feelsense.main.enable_aye:depend({feelsense.main.enable_aye, function() return false end})
feelsense.antiaim.space:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.condition:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.pitch:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.yawbase:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.yaw:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.addons:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.safe_head:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})
feelsense.antiaim.yaw_direction:depend(enabled, aa_tab, {feelsense.main.enable_aye, true})

feelsense.antiaim.key_edge_yaw:depend(enabled, aa_tab, {feelsense.antiaim.yaw_direction, "Edge Yaw"}, {feelsense.main.enable_aye, true})
feelsense.antiaim.key_freestand:depend(enabled, aa_tab, {feelsense.antiaim.yaw_direction, "Freestanding"}, {feelsense.main.enable_aye, true})
feelsense.antiaim.key_left:depend(enabled, aa_tab, {feelsense.antiaim.yaw_direction, "Manual AA"}, {feelsense.main.enable_aye, true})
feelsense.antiaim.key_right:depend(enabled, aa_tab, {feelsense.antiaim.yaw_direction, "Manual AA"}, {feelsense.main.enable_aye, true})


feelsense.visual.enable_indicators:depend(enabled, visual_tab, {feelsense.main.enable_aye, true})
feelsense.visual.font_selection:depend(enabled, visual_tab, {feelsense.visual.enable_indicators, true}, {feelsense.main.enable_aye, true})
feelsense.visual.enable_arrows:depend(enabled, visual_tab, {feelsense.main.enable_aye, true})

feelsense.visual.selection_logs:depend(enabled, visual_tab, {feelsense.visual.enable_logs, true}, {feelsense.main.enable_aye, true})
feelsense.visual.enable_watermark:depend(enabled, visual_tab, {feelsense.main.enable_aye, true})
feelsense.visual.watermark_place:depend(enabled, visual_tab, {feelsense.visual.enable_watermark, true}, {feelsense.main.enable_aye, true})
feelsense.visual.watermark_text:depend(enabled, visual_tab, {feelsense.visual.enable_watermark, true}, {feelsense.main.enable_aye, true})

feelsense.misc.fastladder_select:depend(enabled, misc_tab, {feelsense.misc.enable_fastladder, true}, {feelsense.main.enable_aye, true})
feelsense.misc.enable_console_filter:depend(enabled,misc_tab, {feelsense.main.enable_aye, true})

feelsense.config.import:depend(enabled, cfg_tab, {feelsense.main.enable_aye, true})
feelsense.config.export:depend(enabled, cfg_tab, {feelsense.main.enable_aye, true})
feelsense.config.default:depend(enabled, cfg_tab, {feelsense.main.enable_aye, true})

---Версии
if version>0 then 
    feelsense.visual.enable_logs:depend(enabled, visual_tab)
else
    feelsense.visual.enable_logs:set_visible(false)
end

if version > 1 then
    feelsense.visual.enable_windows:depend(enabled,visual_tab)
else
    feelsense.visual.enable_windows:set_visible(false)
end

if version > 0 then
    feelsense.misc.enable_fastladder:depend(enabled, misc_tab)
else
    feelsense.misc.enable_fastladder:set_visible(false)
end

for i=1, #aa_config do
    enable_check = {feelsense.main.enable_lua, true}
    cond_check = {feelsense.antiaim.condition, function() return (i ~= 1) end}
    tab_cond = {feelsense.antiaim.condition, aa_config[i]}
    cnd_en = {aa_builder[i].enable, function() if (i == 1) then return true else return aa_builder[i].enable:get() end end}
    aa_builder[i].enable:depend(enable_check, cond_check, tab_cond, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].yaw_type:depend(enable_check, cnd_en, tab_cond, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].delay_t:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].yaw_type, "Delayed Switch"}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].static:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].yaw_type, "Default"}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].yaw_l:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].yaw_type, function() if aa_builder[i].yaw_type:get() ~= "Default" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].yaw_r:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].yaw_type, function() if aa_builder[i].yaw_type:get() ~= "Default" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].mod_type:depend(enable_check, cnd_en, tab_cond, aa_tab, {feelsense.main.enable_aye, true})
    if version>0 then 
        aa_builder[i].jitter_type:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].mod_type, function() if aa_builder[i].mod_type:get() ~= "Off" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    else
        aa_builder[i].jitter_type:set_visible(false)
    end
    aa_builder[i].mod_j:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].jitter_type, function() if aa_builder[i].jitter_type:get() == "Default" then return true else return false end end}, {aa_builder[i].mod_type, function() if aa_builder[i].mod_type:get() ~= "Off" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].mod_l:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].jitter_type, function() if aa_builder[i].jitter_type:get() ~= "Default" then return true else return false end end}, {aa_builder[i].mod_type, function() if aa_builder[i].mod_type:get() ~= "Off" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].mod_r:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].jitter_type, function() if aa_builder[i].jitter_type:get() ~= "Default" then return true else return false end end}, {aa_builder[i].mod_type, function() if aa_builder[i].mod_type:get() ~= "Off" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].body_yaw:depend(enable_check, cnd_en, tab_cond, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].body_slider:depend(enable_check, cnd_en, tab_cond, {aa_builder[i].body_yaw, function() if aa_builder[i].body_yaw:get() ~= "Off" then return true else return false end end}, aa_tab, {feelsense.main.enable_aye, true})
    aa_builder[i].defensive_type:depend(enable_check, cnd_en, tab_cond, aa_tab, {feelsense.main.enable_aye, true})

    defensive_vis = {aa_builder[i].defensive, true}
    if version>0 then
        aa_builder[i].defensive:depend(enable_check, cnd_en, tab_cond, aa_tab, {feelsense.main.enable_aye, true})
        aa_builder[i].defensive_yaw:depend(enable_check, cnd_en, tab_cond, aa_tab, defensive_vis, {feelsense.main.enable_aye, true})
        aa_builder[i].spin:depend(enable_check, cnd_en, tab_cond, aa_tab, defensive_vis, {aa_builder[i].defensive_yaw, 'Spin'}, {feelsense.main.enable_aye, true})
        aa_builder[i].yaw_amount:depend(enable_check, cnd_en, tab_cond, aa_tab, defensive_vis, {aa_builder[i].defensive_yaw, 'Static'}, {feelsense.main.enable_aye, true})
        aa_builder[i].defensive_pitch:depend(enable_check, cnd_en, tab_cond, aa_tab, defensive_vis, {feelsense.main.enable_aye, true})
        aa_builder[i].pitch_amount:depend(enable_check, cnd_en, tab_cond, aa_tab, defensive_vis, {aa_builder[i].defensive_pitch, 'Custom'}, {feelsense.main.enable_aye, true})
    else
        aa_builder[i].defensive:set_visible(false)
        aa_builder[i].defensive_yaw:set_visible(false)
        aa_builder[i].spin:set_visible(false)
        aa_builder[i].yaw_amount:set_visible(false)
        aa_builder[i].defensive_pitch:set_visible(false)
        aa_builder[i].pitch_amount:set_visible(false)
    end
end

local id = 1   
local function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    flags = entity.get_prop(lp, 'm_fFlags')
    velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
    groundcheck = bit.band(flags, 1) == 1
    jumpcheck = bit.band(flags, 1) == 0 and cmd.in_jump
    ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    duckcheck = ducked or ui.get(ref.fakeduck)
    slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if jumpcheck and duckcheck then return "Air+C"
    elseif jumpcheck then return "Air"
    elseif duckcheck and velocity > 10 then return "Duck-Moving"
    elseif duckcheck and velocity < 10 then return "Duck"
    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
    elseif groundcheck and velocity > 5 then return "Moving"
    elseif groundcheck and velocity < 5 then return "Stand"
    else return "Global" end
end

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local spread_amount = 0

local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time
    if sim_diff < 0 then
        defensive_until = globals.tickcount() + math.abs(sim_diff) - toticks(client.latency())
    end
    last_sim_time = sim_time
    return defensive_until > tickcount and version > 0
end

current_tickcount = 0
to_jitter = false
yaw_direction = 0

anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local yaw_direction = 0
local last_press_t_dir = 0

local run_direction = function()
	feelsense.antiaim.key_left:set('On hotkey')
	feelsense.antiaim.key_right:set('On hotkey')
    ui.set(ref.edgeyaw, feelsense.antiaim.yaw_direction:get("Edge Yaw") and feelsense.antiaim.key_edge_yaw:get())
    ui.set(ref.freestand[1], feelsense.antiaim.yaw_direction:get("Freestanding"))
    ui.set(ref.freestand[2], feelsense.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

	if feelsense.antiaim.key_freestand:get() and feelsense.antiaim.yaw_direction:get("Freestanding") or not feelsense.antiaim.yaw_direction:get("Manual AA") then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if feelsense.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals.curtime()
		elseif feelsense.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals.curtime()
		elseif last_press_t_dir > globals.curtime() then
			last_press_t_dir = globals.curtime()
		end
	end
end

local function aa_setup(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    if player_state(cmd) == "Duck-Moving" and aa_builder[8].enable:get() then id = 8
    elseif player_state(cmd) == "Duck" and aa_builder[7].enable:get() then id = 7
    elseif player_state(cmd) == "Air+C" and aa_builder[6].enable:get() then id = 6
    elseif player_state(cmd) == "Air" and aa_builder[5].enable:get() then id = 5
    elseif player_state(cmd) == "Moving" and aa_builder[4].enable:get() then id = 4
    elseif player_state(cmd) == "Walking" and aa_builder[3].enable:get() then id = 3
    elseif player_state(cmd) == "Stand" and aa_builder[2].enable:get() then id = 2
    else id = 1 end

    run_direction()
  
    ui.set(ref.pitch[1], feelsense.antiaim.pitch:get())
    ui.set(ref.yawbase, feelsense.antiaim.yawbase:get())
    ui.set(ref.yaw[1], feelsense.antiaim.yaw:get())

    desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
	desync_side = desync_type > 0 and 1 or 0

    if globals.tickcount() > current_tickcount + aa_builder[id].delay_t:get() then
        if cmd.chokedcommands == 0 then
           to_jitter = not to_jitter
           current_tickcount = globals.tickcount()
        end
    elseif globals.tickcount() <  current_tickcount then
        current_tickcount = globals.tickcount()
    end

    if aa_builder[id].yaw_type:get() == "Default" then
        ui.set(ref.yaw[2], yaw_direction == 0 and (aa_builder[id].static:get()) or yaw_direction)
    elseif aa_builder[id].yaw_type:get() == "l&r" then
        if desync_side == 1 then
            ui.set(ref.yaw[2], yaw_direction == 0 and (aa_builder[id].yaw_l:get()) or yaw_direction)
        else
            ui.set(ref.yaw[2], yaw_direction == 0 and (aa_builder[id].yaw_r:get()) or yaw_direction)
        end
    else
        if to_jitter then
            ui.set(ref.yaw[2], yaw_direction == 0 and (aa_builder[id].yaw_l:get()) or yaw_direction)
            ui.set(ref.bodyyaw[2], -1)
        else
            ui.set(ref.yaw[2], yaw_direction == 0 and (aa_builder[id].yaw_r:get()) or yaw_direction)
            ui.set(ref.bodyyaw[2], 1)
        end
        ui.set(ref.bodyyaw[1], "Static")
    end

    active_jit = cmd.command_number % client.random_int(3,6) == 1

    ui.set(ref.yawjitter[1], aa_builder[id].mod_type:get())
    if aa_builder[id].jitter_type:get() == "Default" then
        ui.set(ref.yawjitter[2], aa_builder[id].mod_j:get())
    else
        if not active_jit and desync_side == math.random(0, 1) then
            ui.set(ref.yawjitter[2], aa_builder[id].mod_r:get())
        else
            ui.set(ref.yawjitter[2], aa_builder[id].mod_l:get())
        end
    end

    if aa_builder[id].yaw_type:get() ~= "Delayed Switch" then
        ui.set(ref.bodyyaw[1], aa_builder[id].body_yaw:get())
        ui.set(ref.bodyyaw[2], aa_builder[id].body_slider:get())
    end
    ui.set(ref.fsbodyyaw, false)
    cmd.force_defensive = aa_builder[id].defensive_type:get() == "Always On" and 1 or 0
    if aa_builder[id].defensive:get() and version > 0 then
        if is_defensive_active() and cmd.chokedcommands == 1 then
            if aa_builder[id].defensive_yaw:get() == "Spin" then
                ui.set(ref.yaw[1], "Spin")
                ui.set(ref.yaw[2], aa_builder[id].spin:get())
            elseif aa_builder[id].defensive_yaw:get() == "Side-Way" then
                ui.set(ref.yaw[2], desync_side == 1 and 90 or -90)
            elseif aa_builder[id].defensive_yaw:get() == "Random" then
                ui.set(ref.yaw[2], math.random(-180, 180))
            elseif aa_builder[id].defensive_yaw:get() == "Static" then
                ui.set(ref.yaw[2], aa_builder[id].yaw_amount:get())
            end

            ui.set(ref.pitch[1], "Custom") 
            if aa_builder[id].defensive_pitch:get() == "Up" then
                ui.set(ref.pitch[2], -89)
            elseif aa_builder[id].defensive_pitch:get() == "Zero" then
                ui.set(ref.pitch[2], 0)
            elseif aa_builder[id].defensive_pitch:get() == "Random" then
                ui.set(ref.pitch[2], math.random(-89, 89))
            elseif aa_builder[id].defensive_pitch:get() == "Switch-Ways" then
                ui.set(ref.pitch[2], desync_side == 1 and-49 or 49) 
            elseif aa_builder[id].defensive_pitch:get() == "Progressive" then
                ui.set(ref.pitch[2], (globals.tickcount() % 17)*10-89) 
            elseif aa_builder[id].defensive_pitch:get() == "Custom" then
                ui.set(ref.pitch[2], aa_builder[id].pitch_amount:get()) 
            end
        end
    end

    weapon_type = entity.get_player_weapon(lp)
    weapon_class = entity.get_classname(weapon_type)

    if player_state(cmd) == "Air+C" then
        if feelsense.antiaim.safe_head:get('Knife') and weapon_class == "CKnife" then
            ui.set(ref.pitch[1], "Down") 
            ui.set(ref.yaw[2], 7)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif feelsense.antiaim.safe_head:get('Taser') and weapon_class == "CWeaponTaser" then
            ui.set(ref.pitch[1], "Down") 
            ui.set(ref.yaw[2], 9)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif feelsense.antiaim.safe_head:get('SSG-08') and weapon_class == "CWeaponSSG08" then
            ui.set(ref.pitch[1], "Down") 
            ui.set(ref.yaw[2], 9)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif feelsense.antiaim.safe_head:get('AWP') and weapon_class == "CWeaponAWP" then
            ui.set(ref.pitch[1], "Down") 
            ui.set(ref.yaw[2], 9)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        end
    end 

    local players = entity.get_players(true)
    if feelsense.antiaim.addons:get("Shit AA On Warmup") then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[2], math.random(-180, 180))
            ui.set(ref.yawjitter[2], math.random(-180, 180))
            ui.set(ref.bodyyaw[2], math.random(-180, 180))
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], math.random(-89, 89)) 
        end
    end

    if feelsense.antiaim.addons:get("Anti Backstab") then
        lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
        for i=1, #players do
            if players == nil then return end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then return end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end
end

--visuals
local scopedFraction = 0
local bindFraction = 0
client.set_event_callback("paint", function()
    if not feelsense.main.enable_aye:get() then return end
    if not feelsense.main.enable_lua:get() then return end
    local isDt = ui.get(binds[1].bind[2]) and ui.get(binds[1].bind[2])
    --indicators
    local local_player = entity.get_local_player()
    if not local_player or entity.is_alive(local_player) == false then return end
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60 <= 0 and "left" or "right"
    local weapon = entity.get_player_weapon(local_player)
    local scopeLevel = entity.get_prop(weapon, 'm_zoomLevel')
    local scoped = entity.get_prop(local_player, 'm_bIsScoped') == 1
    local resumeZoom = entity.get_prop(local_player, 'm_bResumeZoom') == 1
    local isValid = weapon ~= nil and scopeLevel ~= nil
    local act = isValid and scopeLevel > 0 and scoped and not resumeZoom
    local time = globals.frametime() * 30
    if act then
        if scopedFraction < 1 then
            scopedFraction = other_funcs.lerp(scopedFraction, 1 + 0.1, time)
        else
            scopedFraction = 1
        end
    else
        scopedFraction = other_funcs.lerp(scopedFraction, 0, time)
    end

    local enabled_binds = {}
    local is_scoped = entity.get_prop(local_player,"m_bIsScoped") == 1
    local color_1r, color_1g, color_1b = feelsense.visual.enable_indicators:get_color()
    local color_2r, color_2g, color_2b = feelsense.visual.font_selection:get_color()
    if feelsense.visual.enable_indicators:get() then
        for i, v in pairs(binds) do
            local bind = {ui.get(v.bind[2])}
            if bind[1] then
                table.insert(enabled_binds,v)
            end
        end
        
        for i, v in pairs(enabled_binds) do
            local x_m, y_m = renderer.measure_text("-", v.name)
            renderer.text(x/2-(x_m/2*(1-scopedFraction)-5*scopedFraction), y/2+27+(9*i), color_2r, color_2g, color_2b, 255, "-", 0, v.name)
        end
        if feelsense.visual.font_selection:get() == "Default" then
            local indicator_text_measure_x = renderer.measure_text("b", "feelsense")           
            func_uses.text_fade_animation(x/2-indicator_text_measure_x/2+scopedFraction*30, y/2+25, 1, {r=color_1r,g=color_1g,b=color_1b,a=225},{r=color_2r,g=color_2g,b=color_2b,a=255}, "feelsense", "b")
        else
            local indicator_text_measure_x = renderer.measure_text("-", "FEELSENSE")
            local indicator_build_measure_x = renderer.measure_text("-", string.upper(current.build))

            renderer.text(x/2-(indicator_build_measure_x/2*(1-scopedFraction)-5*scopedFraction), y/2+20, color_2r, color_2g, color_2b, 255, "-", 0, string.upper(current.build))
            func_uses.text_fade_animation(x/2-indicator_text_measure_x/2+scopedFraction*25, y/2+28, 1, {r=color_1r,g=color_1g,b=color_1b,a=225},{r=color_2r,g=color_2g,b=color_2b,a=255}, "FEELSENSE", "-")
        end
    end
    local velocity = vector(entity.get_prop(local_player, "m_vecVelocity"))
    local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))/250
    local color_arrows_r, color_arrows_g, color_arrows_b,color_arrows_a = feelsense.visual.enable_arrows:get_color()
    local arrows_side_color =
    {
        ["left"] = {{r = color_arrows_r, g = color_arrows_g, b = color_arrows_b, a =  color_arrows_a},{r = 30, g = 30, b = 50, a = 150}},
        ["right"] = {{r = 30, g = 30, b = 30, a = 150},{r = color_arrows_r, g = color_arrows_g, b = color_arrows_b, a =  color_arrows_a}}
    }
    if feelsense.visual.enable_arrows:get() then
        if ui.get(ref.yaw[2]) == -90 then
            renderer.triangle(x/2+40+20*speed, y/2, x/2 + 55+20*speed, y/2 + 10, x/2 + 55+20*speed, y/2 - 10, 30, 30, 30, 150)
            renderer.rectangle(x/2+56+20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][1].r, arrows_side_color[bodyYaw][1].g,arrows_side_color[bodyYaw][1].b,arrows_side_color[bodyYaw][1].a)
            renderer.triangle(x/2-40-20*speed, y/2, x/2 - 55-20*speed, y/2 + 10, x/2 - 55-20*speed, y/2 - 10, color_arrows_r, color_arrows_g, color_arrows_b, color_arrows_a)
            renderer.rectangle(x/2-58-20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][2].r, arrows_side_color[bodyYaw][2].g,arrows_side_color[bodyYaw][2].b,arrows_side_color[bodyYaw][2].a)
            
        elseif ui.get(ref.yaw[2]) == 90 then
            renderer.triangle(x/2+40+20*speed, y/2, x/2 + 55+20*speed, y/2 + 10, x/2 + 55+20*speed, y/2 - 10, color_arrows_r, color_arrows_g, color_arrows_b, color_arrows_a)
            renderer.rectangle(x/2+56+20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][1].r, arrows_side_color[bodyYaw][1].g,arrows_side_color[bodyYaw][1].b,arrows_side_color[bodyYaw][1].a)
            renderer.triangle(x/2-40-20*speed, y/2, x/2 - 55-20*speed, y/2 + 10, x/2 - 55-20*speed, y/2 - 10, 30, 30, 30, 150)
            renderer.rectangle(x/2-58-20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][2].r, arrows_side_color[bodyYaw][2].g,arrows_side_color[bodyYaw][2].b,arrows_side_color[bodyYaw][2].a)
        else
            renderer.triangle(x/2+40+20*speed, y/2, x/2 + 55+20*speed, y/2 + 10, x/2 + 55+20*speed, y/2 - 10, 30, 30, 30, 150)
            renderer.rectangle(x/2+56+20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][1].r, arrows_side_color[bodyYaw][1].g,arrows_side_color[bodyYaw][1].b,arrows_side_color[bodyYaw][1].a)
            renderer.triangle(x/2-40-20*speed, y/2, x/2 - 55-20*speed, y/2 + 10, x/2 - 55-20*speed, y/2 - 10, 30, 30, 30, 150)
            renderer.rectangle(x/2-58-20*speed, y/2-10, 2, 20, arrows_side_color[bodyYaw][2].r, arrows_side_color[bodyYaw][2].g,arrows_side_color[bodyYaw][2].b,arrows_side_color[bodyYaw][2].a)
        end
    end
    --
    local modifier = entity.get_prop(local_player, "m_flVelocityModifier")
    local bars = 0
    if version > 1 then
        if modifier ~= 1 and feelsense.visual.enable_windows:get("Slow-Down Indicator") then
            alpha_k = 255
            if modifier > 0.9 then 
                alpha_k = ((1-modifier)/(0.1))
            else
                alpha_k = 1
            end
            local r, g, b = feelsense.visual.enable_windows:get_color()
            local text = "slowed down "..math.floor((modifier*100)).."%"
            local slowdown_measure_x, slowdown_measure_y = renderer.measure_text("b", text)
            
            rec(x/2-50, y*0.25+20, 100*modifier, 3, 1, {r,g,b,255*alpha_k})
            renderer.outlined_rounded_rectangle(x/2-50, y*0.25+19, 100, 5, r,g,b,255*alpha_k, 3,1)
            renderer.text(x/2-slowdown_measure_x/2, y*0.25, 255,255,255,255*alpha_k, "b", 0, text)
        end
        --defensive manager
        local nextAttack = entity.get_prop(local_player, "m_flNextAttack")
        local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), "m_flNextPrimaryAttack")
        local dtActive = false
        
        if nextPrimaryAttack ~= nil then
            dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
        end
        local isCharged = dtActive
        local dtA = remap(dtModifier, 1, 0, 0.85, 1)
        if ui.get(binds[1].bind[3]) == "Defensive" and feelsense.visual.enable_windows:get("Defensive Manager") then
            if isDt and isCharged == true then
                if dtModifier < 1 then
                    dtModifier = other_funcs.lerp(dtModifier, 1 + 0.1, globals.frametime() * 20)
                else
                    dtModifier = 1
                end
            elseif isDt and isCharged == false then
                if dtModifier > 0 then
                    dtModifier = other_funcs.lerp(dtModifier, 0 - 0.1, globals.frametime() * 20)
                else
                    dtModifier = 0
                end
            else
                dtModifier = 1
            end
            if bars == 1 then
                if barMoveY < 1 then
                    barMoveY = other_funcs.lerp(barMoveY, 1 + 0.1, globals.frametime() * 20)
                else
                    barMoveY = 1
                end
            else
                if barMoveY > 0 then
                    barMoveY = other_funcs.lerp(barMoveY, 0 - 0.1, globals.frametime() * 20)
                else
                    barMoveY = 0
                end
            end
            local r, g, b = feelsense.visual.enable_windows:get_color()
            local text = "defensive choking"
            interval = interval + (1-dtModifier) * 0.7 + 0.3
        
            -- text
            local textX, textY = renderer.measure_text("c", text)
            renderer.text(x/2, y*0.25 + 30 * barMoveY-50, 255, 255, 255, 255*dtA, "cb", 0, text)
            rec(x/2-47, y*0.25+30*barMoveY-35, math.floor(100*math.abs(dtModifier)), 3, 1, {r,g,b,255*dtA})
            renderer.outlined_rounded_rectangle(x/2-48, y*0.25+30*barMoveY-36, 100, 5, r,g,b,255*dtA, 3,1)
            -- bar
        end
    end
    --watermark
    if feelsense.visual.enable_watermark:get() then
    
        local watermark_text_measure_x,watermark_text_measure_y = renderer.measure_text("", text_fx[feelsense.visual.watermark_text:get()][1])
        local watermark1_x, watermark1_y = renderer.measure_text("", text_fx[feelsense.visual.watermark_text:get()][1]..text_fx[feelsense.visual.watermark_text:get()][2]..version_fx[version][1])
        local watermark2_x, watermark2_y = renderer.measure_text("", text_fx[feelsense.visual.watermark_text:get()][1]..text_fx[feelsense.visual.watermark_text:get()][2])
        local r21,g21,b21 = feelsense.visual.enable_watermark:get_color()
        if feelsense.visual.watermark_place:get() == "Left" then
            renderer.text(20, y/2, r21,g21,b21,255, "", 0, text_fx[feelsense.visual.watermark_text:get()][1])
            func_uses.text_fade_animation(watermark_text_measure_x+21,y/2,1,{r = 255,g = 255,b = 255, a =255},{r = 50,g = 50,b = 50,a= 255},text_fx[feelsense.visual.watermark_text:get()][2],"")
            renderer.text(20+watermark2_x, y/2, version_fx[version][2][1], version_fx[version][2][2], version_fx[version][2][3], 255, "", 0, " "..version_fx[version][1])
        elseif feelsense.visual.watermark_place:get() == "Bottom" then
            renderer.text(x/2-watermark1_x/2,y-20, r21,g21,b21,255,0, "", text_fx[feelsense.visual.watermark_text:get()][1])
            func_uses.text_fade_animation(x/2-watermark1_x/2+watermark_text_measure_x+1,y-20,1,{r = 255,g = 255,b = 255, a =255},{r = 50,g = 50,b = 50,a= 255},text_fx[feelsense.visual.watermark_text:get()][2],"")
            renderer.text(x/2-watermark1_x/2+watermark2_x, y-20, version_fx[version][2][1], version_fx[version][2][2], version_fx[version][2][3], 255, "", 0, " "..version_fx[version][1])
        elseif feelsense.visual.watermark_place:get() == "Right" then
            renderer.text(x-watermark1_x-21, y/2, r21,g21,b21,255,0, "", text_fx[feelsense.visual.watermark_text:get()][1])
            func_uses.text_fade_animation(x-watermark1_x-20+watermark_text_measure_x,y/2,1,{r = 255,g = 255,b = 255, a =255},{r = 50,g = 50,b = 50,a= 255},text_fx[feelsense.visual.watermark_text:get()][2],"")
            renderer.text(x-watermark1_x-20+watermark2_x, y/2, version_fx[version][2][1], version_fx[version][2][2], version_fx[version][2][3], 255, "", 0, " "..version_fx[version][1])
        end
    end
    --watermark
end)
local notifications = {}
local hitboxes = { [0] = 'body', 'head', 'chest', 'stomach', 'arm', 'arm', 'leg', 'leg', 'neck', 'body', 'body' }
client.set_event_callback('aim_miss', function(shot)
    if not feelsense.main.enable_aye:get() then return end
    if not feelsense.main.enable_lua:get() then return end
    if not feelsense.visual.enable_logs:get() or not feelsense.visual.selection_logs:get("Miss Logs") then return end
    local color_1r, color_1g, color_1b = feelsense.visual.selection_logs:get_color()
    local function push_notify(text)
        notify.new_bottom(color_1r, color_1g, color_1b, { { text } }) 
        table.insert(notifications, 1, {
            text = text,
            alpha = 255,
            spacer = 0,
            lifetime = client.timestamp() + (10.0 * 100),
        })
    end
	local target = entity.get_player_name(shot.target):lower()
	local hitbox = hitboxes[shot.hitgroup] or "?"
	push_notify(" Missed " .. target .. "'s " .. hitbox .. " due to " .. shot.reason .. "    ")
end)
client.set_event_callback('aim_hit', function(shot)
    if not feelsense.main.enable_aye:get() then return end
    if not feelsense.main.enable_lua:get() then return end
    if not feelsense.visual.enable_logs:get() or not feelsense.visual.selection_logs:get("Hit Logs") then return end
    local color_1r, color_1g, color_1b = feelsense.visual.enable_logs:get_color()
    local function push_notify(text)
        notify.new_bottom(color_1r, color_1g, color_1b, { { text } }) 
        table.insert(notifications, 1, {
            text = text,
            alpha = 255,
            spacer = 0,
            lifetime = client.timestamp() + (10.0 * 100),
        })
    end
	local target = entity.get_player_name(shot.target):lower()
	local hitbox = hitboxes[shot.hitgroup] or "?"
	push_notify(" Hit " .. target .. "'s " .. hitbox .. " for " .. shot.damage .. "    ")
end)
--visuals

--misc
local function console_ft()
    checker_cons = feelsense.misc.enable_console_filter:get()
    cvar.con_filter_enable:set_int(checker_cons and 1 or 0)
    cvar.con_filter_text:set_int(checker_cons and 1 or 0)
    cvar.con_filter_text_out:set_int(checker_cons and 1 or 0)
end

feelsense.misc.enable_console_filter:set_callback(function()
    console_ft()
end)

client.set_event_callback("setup_command",function(cmd)
    if not feelsense.main.enable_aye:get() then return end
    if not feelsense.main.enable_lua:get() then return end
    if not feelsense.misc.enable_fastladder:get() then return end
    local pitch, yaw = client.camera_angles()
    local local_player = entity.get_local_player()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        cmd.yaw = math.floor(cmd.yaw+0.5)
        cmd.roll = 0
        if feelsense.misc.fastladder_select:get("Ascending") then
            if cmd.forwardmove > 0 then
                if pitch < 45 then
                    cmd.pitch = 89
                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1
                    if cmd.sidemove == 0 then
                        cmd.yaw = cmd.yaw + 90
                    end
                    if cmd.sidemove < 0 then
                        cmd.yaw = cmd.yaw + 150
                    end
                    if cmd.sidemove > 0 then
                        cmd.yaw = cmd.yaw + 30
                    end
                end 
            end
        end
        if feelsense.misc.fastladder_select:get("Descending") then
            if cmd.forwardmove < 0 then
                cmd.pitch = 89
                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0
                if cmd.sidemove == 0 then
                    cmd.yaw = cmd.yaw + 90
                end
                if cmd.sidemove > 0 then
                    cmd.yaw = cmd.yaw + 150
                end
                if cmd.sidemove < 0 then
                    cmd.yaw = cmd.yaw + 30
               end
            end
        end
    end
end)
--misc

local config_items = {
    feelsense.antiaim,
    feelsense.visual,
    feelsense.misc,
    aa_builder,
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    print("Succesfully Exported")
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
    package:load(decrypted)
    print("Succesfully Imported!")
end

feelsense.config.import:set_callback(function()
    config.import()
end)

feelsense.config.export:set_callback(function()
    config.export()
end)

feelsense.config.default:set_callback(function()
    config.import("W3sicGl0Y2giOiJEb3duIiwiYWRkb25zIjpbIlNoaXQgQUEgT24gV2FybXVwIiwiQW50aSBCYWNrc3RhYiIsIn4iXSwieWF3IjoiMTgwIiwia2V5X2xlZnQiOlsxLDAsIn4iXSwiY29uZGl0aW9uIjoiUnVubmluZyIsInNhZmVfaGVhZCI6WyJ+Il0sImtleV9yaWdodCI6WzEsMCwifiJdLCJ5YXdfZGlyZWN0aW9uIjpbIkZyZWVzdGFuZGluZyIsIk1hbnVhbCBBQSIsIkVkZ2UgWWF3IiwifiJdLCJrZXlfZnJlZXN0YW5kIjpbMSw2LCJ+Il0sImtleV9lZGdlX3lhdyI6WzEsMCwifiJdLCJ5YXdiYXNlIjoiQXQgVGFyZ2V0cyJ9LHsiZm9udF9zZWxlY3Rpb24iOiJEZWZhdWx0Iiwic2VsZWN0aW9uX2xvZ3NfYyI6IiM3OUM3RkRGRiIsInNlbGVjdGlvbl9sb2dzIjpbIkhpdCBMb2dzIiwiTWlzcyBMb2dzIiwifiJdLCJmb250X3NlbGVjdGlvbl9jIjoiIzhCOEI4QkZGIiwiZW5hYmxlX2luZGljYXRvcnMiOnRydWUsIndhdGVybWFya19wbGFjZSI6IkJvdHRvbSIsImVuYWJsZV93YXRlcm1hcmsiOnRydWUsImVuYWJsZV93aW5kb3dzX2MiOiIjNTZGRkEwRkYiLCJlbmFibGVfYXJyb3dzIjp0cnVlLCJlbmFibGVfd2luZG93cyI6WyJEZWZlbnNpdmUgTWFuYWdlciIsIlNsb3ctRG93biBJbmRpY2F0b3IiLCJ+Il0sImVuYWJsZV9hcnJvd3NfYyI6IiM1NkZGQTBGRiIsImVuYWJsZV9pbmRpY2F0b3JzX2MiOiIjNTZGRkEwRkYiLCJlbmFibGVfd2F0ZXJtYXJrX2MiOiIjNTZGRkEwRkYiLCJ3YXRlcm1hcmtfdGV4dCI6IkhpZ2ggU3BhY2UiLCJlbmFibGVfbG9nc19jIjoiIzU2RkZBMEZGIiwiZW5hYmxlX2xvZ3MiOnRydWV9LHsiZW5hYmxlX2Zhc3RsYWRkZXIiOnRydWUsImZhc3RsYWRkZXJfc2VsZWN0IjpbIkFzY2VuZGluZyIsIkRlc2NlbmRpbmciLCJ+Il0sImVuYWJsZV9jb25zb2xlX2ZpbHRlciI6dHJ1ZX0sW3siZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3IiOjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoIjoiQ3VzdG9tIiwiYm9keV9zbGlkZXIiOi0xMjAsInNwaW4iOjMwLCJkZWZlbnNpdmUiOmZhbHNlLCJwaXRjaF9hbW91bnQiOi00OSwiZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsInN0YXRpYyI6NywibW9kX2oiOjAsIm1vZF9yIjo1MCwieWF3X2Ftb3VudCI6LTE4MCwibW9kX2wiOjM3LCJtb2RfdHlwZSI6IkNlbnRlciIsImRlbGF5X3QiOjMsImRlZmVuc2l2ZV90eXBlIjoiQWx3YXlzIE9uIiwieWF3X2wiOjB9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfciI6MCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYm9keV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsImJvZHlfc2xpZGVyIjotMTI2LCJzcGluIjozMCwiZGVmZW5zaXZlIjpmYWxzZSwicGl0Y2hfYW1vdW50IjotNDksImRlZmVuc2l2ZV95YXciOiJTcGluIiwic3RhdGljIjo1LCJtb2RfaiI6NjEsIm1vZF9yIjo1NSwieWF3X2Ftb3VudCI6LTE4MCwibW9kX2wiOjYxLCJtb2RfdHlwZSI6IkNlbnRlciIsImRlbGF5X3QiOjMsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsInlhd19sIjowfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3IiOjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJib2R5X3NsaWRlciI6LTE1NCwic3BpbiI6MzAsImRlZmVuc2l2ZSI6ZmFsc2UsInBpdGNoX2Ftb3VudCI6LTQ5LCJkZWZlbnNpdmVfeWF3IjoiU3BpbiIsInN0YXRpYyI6MywibW9kX2oiOjczLCJtb2RfciI6NTksInlhd19hbW91bnQiOi0xODAsIm1vZF9sIjo3MywibW9kX3R5cGUiOiJDZW50ZXIiLCJkZWxheV90IjozLCJkZWZlbnNpdmVfdHlwZSI6Ik9uIFBlZWsiLCJ5YXdfbCI6MH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19yIjozOCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYm9keV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsImJvZHlfc2xpZGVyIjotMTAyLCJzcGluIjozMCwiZGVmZW5zaXZlIjpmYWxzZSwicGl0Y2hfYW1vdW50IjotNDksImRlZmVuc2l2ZV95YXciOiJTcGluIiwic3RhdGljIjowLCJtb2RfaiI6NjgsIm1vZF9yIjowLCJ5YXdfYW1vdW50IjotMTgwLCJtb2RfbCI6MCwibW9kX3R5cGUiOiJDZW50ZXIiLCJkZWxheV90IjozLCJkZWZlbnNpdmVfdHlwZSI6Ik9uIFBlZWsiLCJ5YXdfbCI6LTM4fSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3IiOjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJib2R5X3NsaWRlciI6LTQ1LCJzcGluIjozMCwiZGVmZW5zaXZlIjpmYWxzZSwicGl0Y2hfYW1vdW50IjotNDksImRlZmVuc2l2ZV95YXciOiJTcGluIiwic3RhdGljIjowLCJtb2RfaiI6NjEsIm1vZF9yIjo0NiwieWF3X2Ftb3VudCI6LTE4MCwibW9kX2wiOjYxLCJtb2RfdHlwZSI6IkNlbnRlciIsImRlbGF5X3QiOjMsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsInlhd19sIjowfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3IiOjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImJvZHlfeWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJib2R5X3NsaWRlciI6LTksInNwaW4iOjMwLCJkZWZlbnNpdmUiOmZhbHNlLCJwaXRjaF9hbW91bnQiOi00OSwiZGVmZW5zaXZlX3lhdyI6IlNwaW4iLCJzdGF0aWMiOjgsIm1vZF9qIjo3MywibW9kX3IiOjYwLCJ5YXdfYW1vdW50IjotMTgwLCJtb2RfbCI6NzMsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVsYXlfdCI6MywiZGVmZW5zaXZlX3R5cGUiOiJBbHdheXMgT24iLCJ5YXdfbCI6MH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19yIjowLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJib2R5X3lhdyI6IkppdHRlciIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwiYm9keV9zbGlkZXIiOi0xMjksInNwaW4iOjMwLCJkZWZlbnNpdmUiOmZhbHNlLCJwaXRjaF9hbW91bnQiOi00OSwiZGVmZW5zaXZlX3lhdyI6IlNwaW4iLCJzdGF0aWMiOjQsIm1vZF9qIjo3NywibW9kX3IiOjYwLCJ5YXdfYW1vdW50IjotMTgwLCJtb2RfbCI6NzMsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVsYXlfdCI6MywiZGVmZW5zaXZlX3R5cGUiOiJPbiBQZWVrIiwieWF3X2wiOjB9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfciI6MCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYm9keV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsImJvZHlfc2xpZGVyIjotMTgwLCJzcGluIjozMCwiZGVmZW5zaXZlIjpmYWxzZSwicGl0Y2hfYW1vdW50IjotNDksImRlZmVuc2l2ZV95YXciOiJTcGluIiwic3RhdGljIjowLCJtb2RfaiI6NTUsIm1vZF9yIjo0MCwieWF3X2Ftb3VudCI6LTE4MCwibW9kX2wiOjU1LCJtb2RfdHlwZSI6IkNlbnRlciIsImRlbGF5X3QiOjMsImRlZmVuc2l2ZV90eXBlIjoiT24gUGVlayIsInlhd19sIjowfV1d")
end)
---

client.set_event_callback('setup_command', function(cmd)
    if not feelsense.main.enable_aye:get() then return end
    if not feelsense.main.enable_lua:get() then return end
    aa_setup(cmd)
end)

client.set_event_callback('paint_ui', function()
    feelsense.main.enable_aye:set(current.check_access)
    hide_original_menu(not feelsense.main.enable_lua:get())
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)