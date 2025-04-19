-- Skybox Changer, Made By Exodouding (13429) for skeet.cc/gamesense.pub

local ffi = require("ffi")

local Skyboxes =
{
	["Assault"] = "sky_cs15_daylight04_hdr",
	["Aztec"] = "jungle",
	["Baggage"] = "cs_baggage_skybox_",
	["Canals"] = "sky_venice",	
	["Clear"] = "nukeblank",	
	["Clouds"] = "sky_cs15_daylight02_hdr",
	["Clouds (2)"] = "vertigo",
	["Clouds (Dark)"] = "sky_csgo_cloudy01",
	["Cobblestone"] = "sky_cs15_daylight03_hdr",
	["Daylight"] = "sky_cs15_daylight01_hdr",
	["Daylight (2)"] = "vertigoblue_hdr",
	["Dusty"] = "sky_dust",
	["Gray"] = "sky_day02_05_hdr",	
	["Italy"] = "italy",
	["Monastery"] = "embassy",
	["Night"] =" sky_csgo_night02",
	["Night (2)"] = "sky_csgo_night02b",
	["Night (Flat)"] = "sky_csgo_night_flat",
	["Rainy"] = "vietnam",	
   	["Tibet"] = "cs_tibet",
	["Vertigo"] = "office"
}

local function Patterns(module, interface, signature, typestring)

    local interface = client.create_interface(module, interface) or error("invalid interface", 2)
    local signature = client.find_signature(module, signature) or error("invalid signature", 2)
	
    local success, typeof = pcall(ffi.typeof, typestring)
	
    if not success then
        error(typeof, 2)
    end
	
    local fnptr = ffi.cast(typeof, signature) or error("invalid typecast", 2)
	
    return function(...)
        return fnptr(interface, ...)
    end
end

local int_ptr           = ffi.typeof("int[1]")
local char_buffer       = ffi.typeof("char[?]")

local find_first        = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local find_next         = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local find_close        = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")

local current_directory = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
local add_to_searchpath = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
local find_is_directory = Patterns("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")

local function GetCustomSkybox()

    local files = {}
	
    local file_handle = int_ptr()
	
    local file = find_first("*", "XGAME", file_handle)
	
    while file ~= nil do
	
        local file_name = ffi.string(file)
		
        if find_is_directory(file_handle[0]) == false and (file_name:find("dn.vtf")) then
            files[#files+1] = file_name:sub(1, -7)
        end
		
        file = find_next(file_handle[0])
    end
	
    find_close(file_handle[0])
	
    return files
end

local function NormalizeFileName(name)

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

local function TableDifference(t1, t2)

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

local function CompareSkyboxNames(a, b)

    local function GetComparisonValue(name)
	
        if name:sub(1, 6) == "Custom" then
            return "\255" .. name 
        else
            return name
        end
    end

    local nameA, numA = a:match("(%D+)(%d*)")
    local nameB, numB = b:match("(%D+)(%d*)")

    nameA = GetComparisonValue(nameA)
    nameB = GetComparisonValue(nameB)

    if nameA == nameB then
        if numA == "" then
            return false
        elseif numB == "" then
            return true
        else
            return tonumber(numA) < tonumber(numB)
        end
    else
        return nameA < nameB
    end
end

local skybox_names = {}
local old_custom_skyboxes = nil

local function CollectSkybox()

    local current_path = char_buffer(192)
	
    current_directory(current_path, ffi.sizeof(current_path))
    current_path = string.format("%s\\csgo\\materials\\skybox", ffi.string(current_path))
    add_to_searchpath(current_path, "XGAME", 0)

    local custom_skyboxes = GetCustomSkybox()

    if old_custom_skyboxes ~= nil and TableDifference(custom_skyboxes, old_custom_skyboxes) then
        client.reload_active_scripts()
    end

    for i = 1, #custom_skyboxes do
	
        local file_name = custom_skyboxes[i]
		
        local normalized_name = NormalizeFileName(file_name)
		
        if not Skyboxes[normalized_name] then
            Skyboxes[normalized_name] = file_name
            skybox_names[#skybox_names + 1] = normalized_name
        end
    end

    old_custom_skyboxes = custom_skyboxes

    local temp_skybox_names = {}
    for k, v in pairs(Skyboxes) do
        temp_skybox_names[#temp_skybox_names + 1] = k
    end

    table.sort(temp_skybox_names, CompareSkyboxNames)

    skybox_names = temp_skybox_names
end

local function CollectSkyboxRefresh()
    CollectSkybox()
    client.delay_call(5, CollectSkyboxRefresh)
end

CollectSkyboxRefresh()

local skybox = ui.new_checkbox("VISUALS", "Effects", "Skybox Changer")
local skybox_names_listbox = ui.new_listbox("VISUALS", "Effects", "Skybox Names", skybox_names)
local skybox_color_checkbox = ui.new_checkbox("VISUALS", "Effects", "Skybox Color")
local skybox_color = ui.new_color_picker("VISUALS", "Effects", "Skybox Color", 255, 255, 255, 255)
local remove_3d_sky = ui.new_checkbox("VISUALS", "Effects", "Remove 3D Sky")

ui.set_visible(skybox_names_listbox, false)

local load_name_sky_address = client.find_signature("engine.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45") or error("signature for load_name_sky is outdated")
local load_name_sky = ffi.cast(ffi.typeof("void(__fastcall*)(const char*)"), load_name_sky_address)

local default_skyname = nil

local function UpdateSkybox()

    if default_skyname == nil then
        default_skyname = cvar.sv_skyname:get_string()
    end

    if not ui.get(skybox) then
	
        load_name_sky(default_skyname)
		
        return
    end

    local name = skybox_names[ui.get(skybox_names_listbox) + 1]
	
    load_name_sky(Skyboxes[name])
end

local function SkyboxColor()

	if not entity.get_local_player() then 
		return 
	end
	
	if ui.get(skybox_color_checkbox) then
	
		local r, g, b, a = ui.get(skybox_color)
		
		local materials = materialsystem.find_materials("skybox/")
		
		for i=1, #materials do
			materials[i]:color_modulate(r, g, b)
			materials[i]:alpha_modulate(a)
		end
		
	else 
	
		local materials = materialsystem.find_materials("skybox/")
	
		for i=1, #materials do
			materials[i]:color_modulate(255, 255, 255)
			materials[i]:alpha_modulate(255)
		end
	end
end

local function PlayerConnectFull(evt)

    if client.userid_to_entindex(evt.userid) == entity.get_local_player() then
        default_skyname = nil
        UpdateSkybox()
		SkyboxColor()
        CollectSkybox()
    end
end

local function Skybox(x)

    ui.set_visible(skybox_names_listbox, ui.get(x))
	
    if not ui.get(x) then
	
        if default_skyname ~= nil then
            load_name_sky(default_skyname)
        else
            load_name_sky(cvar.sv_skyname:get_string())
        end
		
    else
		SkyboxColor()
        UpdateSkybox()
    end
end

local function Remove3DSky()
	client.set_cvar("r_3dsky", ui.get(remove_3d_sky) and 0 or 1)
end

local function Unload()

	if not entity.get_local_player() then 
		return
	end

    if default_skyname ~= nil then
        load_name_sky(default_skyname)
    end
	
	local materials = materialsystem.find_materials("skybox/")
	
	for i=1, #materials do
		materials[i]:color_modulate(255, 255, 255)
		materials[i]:alpha_modulate(255)
	end
	
	client.set_cvar("r_3dsky", 1)
end

ui.set_callback(skybox_names_listbox, UpdateSkybox)
ui.set_callback(remove_3d_sky, Remove3DSky)
ui.set_callback(skybox, Skybox)
client.set_event_callback("player_connect_full", PlayerConnectFull)
client.set_event_callback("pre_render_3d", SkyboxColor)
client.set_event_callback("shutdown", Unload)
