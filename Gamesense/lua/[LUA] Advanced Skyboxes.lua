local ffi = require('ffi')

local skybox_names = {}

local skybox_list = {
    ['Tibet'] = 'cs_tibet',
	['Baggage'] = 'cs_baggage_skybox_',
	['Monastery'] = 'embassy',
	['Italy'] = 'italy',
	['Aztec'] = 'jungle',
	['Vertigo'] = 'office',
	['Daylight'] = 'sky_cs15_daylight01_hdr',
	['Daylight (2)'] = 'vertigoblue_hdr',
	['Clouds'] = 'sky_cs15_daylight02_hdr',
	['Clouds (2)'] = 'vertigo',
	['Gray'] = 'sky_day02_05_hdr',
	['Clear'] = 'nukeblank',
	['Canals'] = 'sky_venice',
	['Cobblestone'] = 'sky_cs15_daylight03_hdr',
	['Assault'] = 'sky_cs15_daylight04_hdr',
	['Clouds (Dark)'] = 'sky_csgo_cloudy01',
	['Night'] =' sky_csgo_night02',
	['Night (2)'] = 'sky_csgo_night02b',
	['Night (Flat)'] = 'sky_csgo_night_flat',
	['Dusty'] = 'sky_dust',
	['Rainy'] = 'vietnam'
}

local old_custom_skyboxes = nil

local function bind_signature(module, interface, signature, typestring)
    local interface = client.create_interface(module, interface) or error('invalid interface', 2)
    local instance = client.find_signature(module, signature) or error('invalid signature', 2)

    local success, typeof = pcall(ffi.typeof, typestring)
    if not success then error(typeof, 2) end

    local fnptr = ffi.cast(typeof, instance) or error('invalid typecast', 2)

    return function(...)
        return fnptr(interface, ...)
    end
end

local int_ptr = ffi.typeof('int[1]')
local char_buffer = ffi.typeof('char[?]')

local find_first = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)')
local find_next = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)')
local find_close = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)')

local current_directory = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)')
local add_to_searchpath = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57', 'void(__thiscall*)(void*, const char*, const char*, int)')
local find_is_directory = bind_signature('filesystem_stdio.dll', 'VFileSystem017', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)')

local function collect_custom_skyboxes()
    local files = {}
    local file_handle = int_ptr()
    local file = find_first('*', 'XGAME', file_handle)

    while file ~= nil do
        local file_name = ffi.string(file)

        if find_is_directory(file_handle[0]) == false and (file_name:find('dn.vtf')) then
            files[#files + 1] = file_name:sub(1, -7)
        end

        file = find_next(file_handle[0])
    end

    find_close(file_handle[0])

    return files
end

local function normalize_file_name(name)
    local first_letter = name:sub(1, 1)
    local rest = name:sub(2)

    name = 'Custom: '.. first_letter:upper() .. rest

    if name:find('_') then
        name = name:gsub('_', ' ')
    end

    if name:find('.vtf') then
        name = name:gsub('.vtf', '')
    end

    return name
end

local function table_diff(t1, t2)
    local diff = {}

    for k, v in pairs(t1) do
        if t2[k] ~= v then diff[k] = v end
    end

    for k, v in pairs(t2) do
        if t1[k] ~= v then diff[k] = v end
    end

    return next(diff) ~= nil
end

local function collect()
    local current_path = char_buffer(192)
    local custom_skyboxes = collect_custom_skyboxes()

	current_directory(current_path, ffi.sizeof(current_path))

	current_path = string.format('%s\\csgo\\materials\\skybox', ffi.string(current_path))

	add_to_searchpath(current_path, 'XGAME', 0)

    if old_custom_skyboxes ~= nil and table_diff(custom_skyboxes, old_custom_skyboxes) then
        client.reload_active_scripts()
    end

    for i = 1, #custom_skyboxes do
        local file_name = custom_skyboxes[i]
        local normalized_name = normalize_file_name(file_name)

        if not skybox_list[normalized_name] then
            skybox_list[normalized_name] = file_name
            skybox_names[#skybox_names + 1] = normalized_name
        end
    end

    old_custom_skyboxes = custom_skyboxes

    skybox_names = {}

    for k, v in pairs(skybox_list) do
        skybox_names[#skybox_names + 1] = k
    end

    table.sort(skybox_names)
end

collect()

local skybox_settings = {
    override = ui.new_checkbox('LUA', 'A', 'Override skybox'),
    remove_3d_sky = ui.new_checkbox('LUA', 'A', 'Remove 3D skybox'),
    skybox = ui.new_listbox('LUA', 'A', 'Skybox name', skybox_names)
}

ui.set_visible(skybox_settings.skybox, false)
ui.set_visible(skybox_settings.remove_3d_sky, false)

local load_name_sky_address = client.find_signature('engine.dll', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45') or error('signature for load_name_sky is outdated')
local load_name_sky = ffi.cast(ffi.typeof('void(__fastcall*)(const char*)'), load_name_sky_address)

local default_skyname = nil

local function update_skybox()
    if default_skyname == nil then
        default_skyname = cvar.sv_skyname:get_string()
    end

    if not ui.get(skybox_settings.override) then
        load_name_sky(default_skyname)

        return
    end

    load_name_sky(skybox_list[skybox_names[ui.get(skybox_settings.skybox) + 1]])
end

client.set_event_callback('player_connect_full', function(event)
    local self = entity.get_local_player()

    if client.userid_to_entindex(event.userid) == self then
        default_skyname = nil

        update_skybox()
        collect()
    end
end)

ui.set_callback(skybox_settings.override, function(var)
    ui.set_visible(skybox_settings.skybox, ui.get(var))
    ui.set_visible(skybox_settings.remove_3d_sky, ui.get(var))

    if not ui.get(var) then
        if default_skyname ~= nil then
            load_name_sky(default_skyname)
        else
            load_name_sky(cvar.sv_skyname:get_string())
        end
    else
        update_skybox()
    end
end)

ui.set_callback(skybox_settings.skybox, update_skybox)

local function remove_3d_skybox()
    cvar.r_3dsky:set_raw_int(ui.get(skybox_settings.remove_3d_sky) and 0 or 1)
end

remove_3d_skybox()
ui.set_callback(skybox_settings.remove_3d_sky, remove_3d_skybox)

client.set_event_callback('shutdown', function()
    if default_skyname ~= nil then
        load_name_sky(default_skyname)
    end
end)