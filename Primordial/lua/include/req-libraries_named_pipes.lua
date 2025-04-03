local string_match, string_len, string_gsub, string_gmatch, string_byte = string.match, string.len, string.gsub, string.gmatch, string.byte
local cast, typeof, ffi_string = ffi.cast, ffi.typeof, ffi.string

local pGetModuleHandle_sig = memory.find_pattern("engine.dll", "FF 15 ?? ?? ?? ?? 85 C0 74 0B") or error("Couldn't find signature #1")
local pGetProcAddress_sig = memory.find_pattern("engine.dll", "FF 15 ?? ?? ?? ?? A3 ?? ?? ?? ?? EB 05") or error("Couldn't find signature #2")

local jmp_ecx = memory.find_pattern("engine.dll", "FF E1")

local pGetProcAddress = cast("uint32_t**", cast("uint32_t", pGetProcAddress_sig) + 2)[0][0]
local fnGetProcAddress = cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", jmp_ecx)

local pGetModuleHandle = cast("uint32_t**", cast("uint32_t", pGetModuleHandle_sig) + 2)[0][0]
local fnGetModuleHandle = cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", jmp_ecx)

local function proc_bind(module_name, function_name, typedef)
	local ctype = typeof(typedef)
	local module_handle = fnGetModuleHandle(pGetModuleHandle, 0, module_name)
	local proc_address = fnGetProcAddress(pGetProcAddress, 0, module_handle, function_name)
	local call_fn = cast(ctype, jmp_ecx)

	return function(...)
		return call_fn(proc_address, 0, ...)
	end
end

local ulong_arr = typeof("unsigned long[?]")
local char_ptr = typeof("const char*")
local char_arr = typeof("const char[?]")
local ushort_ptr = typeof("unsigned short*")
local ushort_arr = typeof("unsigned short[?]")

local function to_wchar(str)
	local size = string_len(str)+1
	local buffer = ushort_arr(size)

	local i = 0
	for c in string_gmatch(str, ".") do
		buffer[i] = string_byte(c)

		i = i + 1
	end

	return cast(ushort_ptr, buffer)
end

local native_CreateFileW = proc_bind("kernel32.dll", "CreateFileW", "void*(__fastcall*)(unsigned int, unsigned int, const wchar_t*, unsigned long, unsigned long, void*, unsigned long, unsigned long, void*)")
local native_CloseHandle = proc_bind("kernel32.dll", "CloseHandle", "bool(__fastcall*)(unsigned int, unsigned int, void*)")
local native_WriteFile = proc_bind("kernel32.dll", "WriteFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
local native_ReadFile = proc_bind("kernel32.dll", "ReadFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
local native_PeekNamedPipe = proc_bind("kernel32.dll", "PeekNamedPipe", "bool(__fastcall*)(unsigned int, unsigned int, void*, void*, unsigned long, unsigned long*, unsigned long*, unsigned long*)")
local native_GetLastError = proc_bind("kernel32.dll", "GetLastError", "unsigned long(__fastcall*)(unsigned int, unsigned int)")
local native_GetFileType = proc_bind("kernel32.dll", "GetFileType", "unsigned long(__fastcall*)(unsigned int, unsigned int, void*)")

local GENERIC_READ = 0x80000000
local GENERIC_WRITE = 0x40000000
local GENERIC_READ_WRITE = bit.bor(GENERIC_READ, GENERIC_WRITE)

local CREATE_NEW = 1
local OPEN_EXISTING = 3

local FILE_NORMAL_DELETE_ON_CLOSE = 0x04000080
local FILE_ATTRIBUTE_NORMAL = 0x80

local FILE_TYPE_PIPE = 0x0003

local INVALID_HANDLE_VALUE = ffi.cast("void*", -1)

-- set up metatable
local named_pipe_mt = {}

-- store private data for open pipes here
local open_pipes = {}

--
-- GetLastError and nice formatting
--

local ERROR_CODES = {
	[0x02] = "File not found",
	[0x03] = "Path not found",
	[0x05] = "Access denied",
	[0x50] = "File exists",
	[0x6D] = "Broken pipe",
	[0xE6] = "Bad pipe",
	[0xE7] = "Pipe busy"
}

local function get_last_error()
	local err = native_GetLastError()

	return ERROR_CODES[err] or tostring(err)
end

--
-- open new named pipe
--

local function open_pipe(path)
	if type(path) ~= "string" then
		return error("Invalid path, expected string", 2)
	elseif not string_match(path, "^\\\\%?\\pipe\\") then
		return error("Invalid path, expected \\\\?\\pipe\\", 2)
	end

	local path_wchar = to_wchar(path)
	local handle = native_CreateFileW(path_wchar, GENERIC_READ_WRITE, 0, nil, OPEN_EXISTING, 0, nil)

	if handle == INVALID_HANDLE_VALUE then
		return error("Failed to open pipe: " .. get_last_error())
	elseif native_GetFileType(handle) ~= FILE_TYPE_PIPE then
		native_CloseHandle(handle)
		return error("Failed to open pipe: Invalid file type")
	end

	-- tbl returned to the user
	local tbl = setmetatable({
		path = path
	}, named_pipe_mt)

	-- store stuff hidden from user here
	open_pipes[tbl] = {
		handle = handle,
		open = true
	}

	return tbl
end

local function close_pipe(self)
	local open_pipe = open_pipes[self]
	if open_pipe == nil then
		return error("Invalid pipe")
	end

	open_pipes[self] = nil
	if not native_CloseHandle(open_pipe.handle) then
		return error("Failed to close pipe: " .. get_last_error())
	end
end

local function write_pipe(self, data)
	local open_pipe = open_pipes[self]
	if open_pipe == nil then
		return error("Invalid pipe")
	end

	data = tostring(data) or ""

	local bytes_written = ulong_arr(1)
	local len = string_len(data)

	if native_WriteFile(open_pipe.handle, data, len, bytes_written, nil) then
		return tonumber(bytes_written[0])
	else
		return error("Failed to write: " .. get_last_error())
	end
end

local function read_pipe(self, size)
	if size ~= nil then
		if type(size) ~= "number" then
			return error("Invalid size, expected number or nil", 2)
		elseif 0 > size then
			return error("Invalid size", 2)
		end
	end

	local open_pipe = open_pipes[self]
	if open_pipe == nil then
		return error("Invalid pipe [read_pipe]")
	end

	local bytes_available = ulong_arr(1)
	if native_PeekNamedPipe(open_pipe.handle, nil, 0, nil, bytes_available, nil) then
		local avail = bytes_available[0]

		if size == nil and avail > 0 then
			-- size wasn't set, read all thats available
			size = avail
		elseif size ~= nil and size > avail then
			-- size was set but not enough data is available. read nothing
			size = nil
		end

		if size ~= nil then
			local out_buffer = char_arr(size)
			local bytes_read = ulong_arr(1)

			local read_success = native_ReadFile(open_pipe.handle, out_buffer, size, bytes_read, nil)

			if read_success and bytes_read[0] == size then
				return ffi_string(out_buffer, size)
			else
				return error("Failed to read: " .. get_last_error())
			end
		end
	else
		return error("Failed to peek: " .. get_last_error())
	end
end

-- set up index table
named_pipe_mt.__index = {
	close = close_pipe,
	read = read_pipe,
	write = write_pipe
}

-- close all open pipes on shutdown
callbacks.add(e_callbacks.SHUTDOWN, function()
	for key, _ in pairs(open_pipes) do
		pcall(close_pipe, key)
	end
end)

return {
	open_pipe = open_pipe
}