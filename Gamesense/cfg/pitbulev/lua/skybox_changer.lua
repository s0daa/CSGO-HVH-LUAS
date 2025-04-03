local ffi = require("ffi")

local client_create_interface, client_find_signature, client_userid_to_entindex, client_reload_active_scripts, client_set_event_callback, client_unset_event_callback = client.create_interface, client.find_signature, client.userid_to_entindex, client.reload_active_scripts, client.set_event_callback, client.unset_event_callback
local entity_get_local_player = entity.get_local_player
local ui_new_checkbox, ui_new_listbox, ui_new_color_picker, ui_get, ui_set, ui_set_callback, ui_set_visible = ui.new_checkbox, ui.new_listbox, ui.new_color_picker, ui.get, ui.set, ui.set_callback, ui.set_visible
local materialsystem_find_materials = materialsystem.find_materials;
local string_format = string.format
local table_sort = table.sort
local pairs, pcall, error, next = pairs, pcall, error, next
local ffi_cast, ffi_typeof, ffi_string, ffi_sizeof = ffi.cast, ffi.typeof, ffi.string, ffi.sizeof

local skybox_names = {}

local skybox_list = {
    ["Tibet"] = "cs_tibet",
	["Baggage"] = "cs_baggage_skybox_",
	["Monastery"] = "embassy",
	["Italy"] = "italy",
	["Aztec"] = "jungle",
	["Vertigo"] = "office",
	["Daylight"] = "sky_cs15_daylight01_hdr",
	["Daylight (2)"] = "vertigoblue_hdr",
	["Clouds"] = "sky_cs15_daylight02_hdr",
	["Clouds (2)"] = "vertigo",
	["Gray"] = "sky_day02_05_hdr",
	["Clear"] = "nukeblank",
	["Canals"] = "sky_venice",
	["Cobblestone"] = "sky_cs15_daylight03_hdr",
	["Assault"] = "sky_cs15_daylight04_hdr",
	["Clouds (Dark)"] = "sky_csgo_cloudy01",
	["Night"] =" sky_csgo_night02",
	["Night (2)"] = "sky_csgo_night02b",
	["Night (Flat)"] = "sky_csgo_night_flat",
	["Dusty"] = "sky_dust",
	["Rainy"] = "vietnam",
}

local old_custom_skyboxes = nil

local function bind_signature(module, interface, signature, typestring)
    local interface = client_create_interface(module, interface) or error("invalid interface", 2)
    local instance = client_find_signature(module, signature) or error("invalid signature", 2)
    local success, typeof = pcall(ffi_typeof, typestring)
    if not success then
        error(typeof, 2)
    end
    local fnptr = ffi_cast(typeof, instance) or error("invalid typecast", 2)
    return function(...)
        return fnptr(interface, ...)
    end
end

local int_ptr           = ffi_typeof("int[1]")
local char_buffer       = ffi_typeof("char[?]")

local find_first        = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local find_next         = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local find_close        = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")

local current_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
local add_to_searchpath = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
local find_is_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")

local function collect_custom_skyboxes()
    local files = {}
    local file_handle = int_ptr()
    local file = find_first("*", "XGAME", file_handle)
    while file ~= nil do
        local file_name = ffi_string(file)
        if find_is_directory(file_handle[0]) == false and (file_name:find("dn.vtf")) then
            files[#files+1] = file_name:sub(1, -7)
        end
        file = find_next(file_handle[0])
    end
    find_close(file_handle[0])
    return files
end

local function normalize_file_name(name)
    -- uppcercase the first letter
    local first_letter = name:sub(1, 1)
    local rest = name:sub(2)
    name = "Custom: ".. first_letter:upper() .. rest
    if name:find("_") then
        name = name:gsub("_", " ")
    end
    if name:find(".vtf") then
        name = name:gsub(".vtf", "")
    end
    return name
end

-- find the differences between two tables
local function table_diff(t1, t2)
    local diff = {}
    for k, v in pairs(t1) do
        if t2[k] ~= v then
            diff[k] = v
        end
    end
    for k, v in pairs(t2) do
        if t1[k] ~= v then
            diff[k] = v
        end
    end
    return next(diff) ~= nil
end

local function collect()
    local current_path = char_buffer(192)
	current_directory(current_path, ffi_sizeof(current_path))
	current_path = string_format("%s\\csgo\\materials\\skybox", ffi_string(current_path))
	add_to_searchpath(current_path, "XGAME", 0)

    local custom_skyboxes = collect_custom_skyboxes()

    if old_custom_skyboxes ~= nil and table_diff(custom_skyboxes, old_custom_skyboxes) then
        client_reload_active_scripts()
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
        skybox_names[#skybox_names+1] = k
    end
    table_sort(skybox_names)
end

collect()

local skybox_settings = {
    override = ui_new_checkbox("VISUALS", "Effects", "Override skybox"),
    color = ui_new_color_picker("VISUALS", "Effects", "Override skybox", 255, 255, 255, 255),
    skybox = ui_new_listbox("VISUALS", "Effects", "Skybox name", skybox_names),
    remove_3d_sky = ui_new_checkbox("VISUALS", "Effects", "Remove 3D Sky"),
}

ui_set_visible(skybox_settings.skybox, false)
ui_set_visible(skybox_settings.remove_3d_sky, false)

local load_name_sky_address = client_find_signature("engine.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45") or error("signature for load_name_sky is outdated")
local load_name_sky = ffi_cast(ffi_typeof("void(__fastcall*)(const char*)"), load_name_sky_address)

local sv_skyname = cvar.sv_skyname
local r_3dsky = cvar.r_3dsky
local default_skyname = nil

local function update_skybox()
    if default_skyname == nil then
        default_skyname = sv_skyname:get_string()
    end

    if not ui_get(skybox_settings.override) then
        load_name_sky(default_skyname)
        return
    end

    local name = skybox_names[ui_get(skybox_settings.skybox) + 1]
    load_name_sky(skybox_list[name])
end

local function on_color_changed()
  local enabled = ui_get(skybox_settings.override)
  
  if entity_get_local_player() == nil then return end
  
	if enabled then
		local r, g, b, a = ui_get(skybox_settings.color)
		if not enabled then
			r, g, b, a = 255, 255, 255, 255
		end
		local materials = materialsystem_find_materials("skybox/")
		for i=1, #materials do
			materials[i]:color_modulate(r, g, b)
			materials[i]:alpha_modulate(a)
		end
	end
end

local function on_player_connect_full(event)
    if client_userid_to_entindex(event.userid) == entity_get_local_player() then
        default_skyname = nil
        update_skybox()
        on_color_changed();
        collect()
    end
end

ui_set_callback(skybox_settings.override, function(var)
    local state = ui_get(var)

    ui_set_visible(skybox_settings.skybox, state)
    ui_set_visible(skybox_settings.remove_3d_sky, state)
    if not state then
        if default_skyname ~= nil then
            load_name_sky(default_skyname)
        else
            load_name_sky(sv_skyname:get_string())
        end
    else
        update_skybox()
        on_color_changed();
    end

end)

ui_set_callback(skybox_settings.skybox, update_skybox)
ui_set_callback(skybox_settings.remove_3d_sky, function(var)
    local state = ui_get(var)
    r_3dsky:set_raw_int(state and 0 or 1)
end)

ui_set_callback(skybox_settings.color, on_color_changed);

client_set_event_callback("player_connect_full", on_player_connect_full)
client_set_event_callback("shutdown", function()
    if default_skyname ~= nil then
        load_name_sky(default_skyname)
        on_color_changed();
    end
end)

update_skybox()
on_color_changed();

client_set_event_callback('post_config_load', function()
    update_skybox()
    on_color_changed();
end)