--|
local filesystem = ffi.cast("void***", memory.create_interface("filesystem_stdio.dll", "VFileSystem017"))
ffi.cdef([[
    typedef void (__thiscall* AddSearchPath)(void*, const char*, const char*);
    typedef void (__thiscall* RemoveSearchPaths)(void*, const char*);
    typedef const char* (__thiscall* FindNext)(void*, int);
    typedef bool (__thiscall* FindIsDirectory)(void*, int);
    typedef void (__thiscall* FindClose)(void*, int);
    typedef const char* (__thiscall* FindFirstEx)(void*, const char*, const char*, int*);
    typedef long (__thiscall* GetFileTime)(void*, const char*, const char*);
]])

--|
local add_search_path = ffi.cast("AddSearchPath", filesystem[0][11])
local remove_search_paths = ffi.cast("RemoveSearchPaths", filesystem[0][14])
local find_next = ffi.cast("FindNext", filesystem[0][33])
local find_is_directory = ffi.cast("FindIsDirectory", filesystem[0][34])
local find_close = ffi.cast("FindClose", filesystem[0][35])
local find_first_ex = ffi.cast("FindFirstEx", filesystem[0][36])
local get_file_time = ffi.cast("GetFileTime", filesystem[0][94])

--|
local function list_files(relative_path)
    local file_handle = ffi.new("int[1]")
    remove_search_paths(filesystem, "prim_temp")
    add_search_path(filesystem, relative_path, "prim_temp")

    local file_names = {}
    local file = find_first_ex(filesystem, "*", "prim_temp", file_handle)
    while file ~= nil do
        local file_name = ffi.string(file)
        if find_is_directory(filesystem, file_handle[0]) == false and not file_name:find("banmdls[.]res") then
            table.insert(file_names, file_name)
        end

        file = find_next(filesystem, file_handle[0])
    end
    find_close(filesystem, file_handle[0])

    return file_names
end
local function collect_lua_times()
    local lua_time = {}
    for _, file_name in next, list_files("./primordial/scripts") do
        if file_name:find("[.]lua") then
            lua_time[file_name] = get_file_time(filesystem, file_name, "prim_temp")
        end
    end
    return lua_time
end

--|
local filetime_cache = collect_lua_times()
local last_cache = 0
local function on_paint()
    if global_vars.real_time() - last_cache > 1 then
        local filetimes = collect_lua_times()
        table.foreach(filetimes, function(file_name, filetime)
            if filetime_cache[file_name] ~= filetime then
                print(("Script '%s' has been changed, reloading all scripts..."):format(file_name))
                menu.reload_scripts()
            end
        end)

        filetime_cache = filetimes
        last_cache = global_vars.real_time()
    end
end

--|
callbacks.add(e_callbacks.PAINT, on_paint)