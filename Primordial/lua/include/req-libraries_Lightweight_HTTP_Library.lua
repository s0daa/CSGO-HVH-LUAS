-- #region ffi
local ffi = require("ffi")
local steam_http_raw = ffi.cast("uint32_t**", ffi.cast("char**", ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) + 1)[0] + 48)[0] or error("steam_http error")
local steam_http_ptr = ffi.cast("void***", steam_http_raw) or error("steam_http_ptr error")
local steam_http = steam_http_ptr[0] or error("steam_http_ptr was null")
-- #endregion

--#region helper functions
local function __thiscall(func, this) -- bind wrapper for __thiscall functions
	return function(...)
		return func(this, ...)
	end
end
--#endregion

-- #region native casts
local createHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), steam_http[0]), steam_http_raw)
local sendHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), steam_http[5]), steam_http_raw)
local getHTTPResponseHeaderSize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), steam_http[9]), steam_http_raw)
local getHTTPResponseHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), steam_http[10]), steam_http_raw)
local getHTTPResponseBodySize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), steam_http[11]), steam_http_raw)
local getHTTPBodyData_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), steam_http[12]), steam_http_raw)
local setHTTPHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[3]), steam_http_raw)
local setHTTPRequestParam_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[4]), steam_http_raw)
local setHTTPUserAgent_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), steam_http[21]), steam_http_raw)
local setHTTPRequestRaw_native = __thiscall(ffi.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", steam_http[16]), steam_http_raw)
local releaseHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t)"), steam_http[14]), steam_http_raw)
-- #endregion

local requests = {}
callbacks.add(e_callbacks.PAINT, function ()
	for _, instance in ipairs(requests) do
		if global_vars.cur_time() - instance.ls > instance.task_interval then
			instance:_process_tasks()
			instance.ls = global_vars.cur_time()
		end
	end
end)

-- #region Models
local request = {}
local request_mt = {__index = request}
function request.new(requestHandle, requestAddress, callbackFunction)
	return setmetatable({handle = requestHandle, url = requestAddress, callback = callbackFunction, ticks = 0}, request_mt)
end
local data = {}
local data_mt = {__index = data}
function data.new(state, body, headers)
	return setmetatable({status = state, body = body, headers = headers}, data_mt)
end
function data:success()
	return self.status == 200
end
-- #endregion

-- #region Main
local http = {state = {ok = 200, no_response = 204, timed_out = 408, unknown = 0}}
local http_mt = {__index = http}
function http.new(task)
	task = task or {}
	local instance = setmetatable({requests = {}, task_interval = task.task_interval or 0.3, enable_debug = task.debug or false, timeout = task.timeout or 10, ls = global_vars.cur_time()}, http_mt)
	table.insert(requests, instance)
	return instance
end
local method_t = {['get'] = 1, ['head'] = 2, ['post'] = 3, ['put'] = 4, ['delete'] = 5, ['options'] = 6, ['patch'] = 7}
function http:request(method, url, options, callback)
	-- prepare
	if type(options) == "function" and callback == nil then
		callback = options
		options = {}
	end
	options = options or {}
	local method_num = method_t[tostring(method):lower()]
	local reqHandle = createHTTPRequest_native(method_num, url)
	-- header
	local content_type = "application/text"
	if type(options.headers) == "table" then
		for name, value in pairs(options.headers) do
			name = tostring(name)
			value = tostring(value)
			if name:lower() == "content-type" then
				content_type = value
			end
			setHTTPHeaderValue_native(reqHandle, name, value)
		end
	end
	-- raw
	if type(options.body) == "string" then
		local len = options.body:len()
		setHTTPRequestRaw_native(reqHandle, content_type, ffi.cast("unsigned char*", options.body), len)
	end
	-- params
	if type(options.params) == "table" then
		for k, v in pairs(options.params) do
			setHTTPRequestParam_native(reqHandle, k, v)
		end
	end
	-- useragent
	if type(options.user_agent_info) == "string" then
		setHTTPUserAgent_native(reqHandle, options.user_agent_info)
	end
	-- send
	if not sendHTTPRequest_native(reqHandle, 0) then
		return
	end
	local reqInstance = request.new(reqHandle, url, callback)
	self:_debug("[HTTP] New %s request to: %s", method:upper(), url)
	table.insert(self.requests, reqInstance)
end
function http:get(url, callback)
	local reqHandle = createHTTPRequest_native(1, url)
	if not sendHTTPRequest_native(reqHandle, 0) then
		return
	end
	local reqInstance = request.new(reqHandle, url, callback)
	self:_debug("[HTTP] New GET request to: %s", url)
	table.insert(self.requests, reqInstance)
end
function http:post(url, params, callback)
	local reqHandle = createHTTPRequest_native(3, url)
	for k, v in pairs(params) do
		setHTTPRequestParam_native(reqHandle, k, v)
	end
	if not sendHTTPRequest_native(reqHandle, 0) then
		return
	end
	local reqInstance = request.new(reqHandle, url, callback)
	self:_debug("[HTTP] New POST request to: %s", url)
	table.insert(self.requests, reqInstance)
end
function http:_process_tasks()
	for k, v in ipairs(self.requests) do
		local data_ptr = ffi.new("uint32_t[1]")
		self:_debug("[HTTP] Processing request #%s", k)
		if getHTTPResponseBodySize_native(v.handle, data_ptr) then
			local reqData = data_ptr[0]
			if reqData > 0 then
				local strBuffer = ffi.new("char[?]", reqData)
				if getHTTPBodyData_native(v.handle, strBuffer, reqData) then
					self:_debug("[HTTP] Request #%s finished. Invoking callback.", k)
					v.callback(data.new(http.state.ok, ffi.string(strBuffer, reqData), setmetatable({}, {__index = function(tbl, val) return http._get_header(v, val) end})))
					table.remove(self.requests, k)
					releaseHTTPRequest_native(v.handle)
				end
			else
				v.callback(data.new(http.state.no_response, nil, {}))
				table.remove(self.requests, k)
				releaseHTTPRequest_native(v.handle)
			end
		end
		local timeoutCheck = v.ticks + 1;
		if timeoutCheck >= self.timeout then
			v.callback(data.new(http.state.timed_out, nil, {}))
			table.remove(self.requests, k)
			releaseHTTPRequest_native(v.handle)
		else
			v.ticks = timeoutCheck
		end
	end
end
function http:_debug(...)
	if self.enable_debug then
		client.log(string.format(...))
	end
end
function http._get_header(reqInstance, query)
	local data_ptr = ffi.new("uint32_t[1]")
	if getHTTPResponseHeaderSize_native(reqInstance.handle, query, data_ptr) then
		local reqData = data_ptr[0]
		local strBuffer = ffi.new("char[?]", reqData)
		if getHTTPResponseHeaderValue_native(reqInstance.handle, query, strBuffer, reqData) then
			return ffi.string(strBuffer, reqData)
		end
	end
	return nil
end
function http._bind(class, funcName)
	return function(...)
		return class[funcName](class, ...)
	end
end
-- #endregion

return http