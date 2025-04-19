local ffi = require("ffi") or error("enable unsafe script")

local function bind_signature(module, interface, signature, typestring)
	local interface = client.create_interface(module, interface) or error("invalid interface", 2)
	local instance = client.find_signature(module, signature) or error("invalid signature", 2)
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = ffi.cast(typeof, instance) or error("invalid typecast", 2)
	return function(...)
		return fnptr(interface, ...)
	end
end

local find_first = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local find_next	= bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local find_close = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")

local current_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
local add_to_searchpath = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
local find_is_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")

local function get_all_luas()
	local current_path = ffi.typeof("char[?]")(128)
	current_directory(current_path, ffi.sizeof(current_path))
	current_path = string.format("%s\\autoload\\", ffi.string(current_path))
	add_to_searchpath(current_path, "autoload", 0)

	local files = {}
	local file_handle = ffi.typeof("int[1]")()
	local file = find_first("*", "autoload", file_handle)
	while file ~= nil do
		local file_name = ffi.string(file)
		if find_is_directory(file_handle[0]) == false and (file_name:find(".lua")) then
            table.insert(files, file_name)
		end
		file = find_next(file_handle[0])
	end
	find_close(file_handle[0])
	
    return files
end

get_all_luas()

for i=1, #get_all_luas() do
    local file_name = get_all_luas()[i]
    loadstring(readfile("autoload/"..file_name))()
end

