--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local ffi = require 'ffi'
local uix = require 'gamesense/uix'
local client_set_event_callback, client_unset_event_callback, client_userid_to_entindex, entity_get_local_player, ui_get, ui_new_checkbox, ui_new_combobox, ui_set_callback, ui_set_visible = client.set_event_callback, client.unset_event_callback, client.userid_to_entindex, entity.get_local_player, ui.get, ui.new_checkbox, ui.new_combobox, ui.set_callback, ui.set_visible

--------------------------------------------------------------------------------
-- FFI functions
--------------------------------------------------------------------------------
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

local function vmt_entry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_bind(module, interface, index, typestring)
	local instance = client.create_interface(module, interface) or error("invalid interface")
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = vmt_entry(instance, index, typeof) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

--------------------------------------------------------------------------------
-- Constants, variables, and data structures
--------------------------------------------------------------------------------
local enable_ref
local head_sound_ref
local body_sound_ref
local volume_ref

local sound_names = {}
local sound_name_to_file = {}

local int_ptr	   = ffi.typeof("int[1]")
local char_buffer   = ffi.typeof("char[?]")

local find_first	= bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local find_next	 = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local find_close	= bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")

local current_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
local add_to_searchpath = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
local find_is_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")

local sndplaydelay = cvar.sndplaydelay
local native_Surface_PlaySound = vmt_bind("vguimatsurface.dll", "VGUI_Surface031", 82, "void(__thiscall*)(void*, const char*)")

--------------------------------------------------------------------------------
-- Utility functions
--------------------------------------------------------------------------------
local function collect_files()
	local files = {}
	local file_handle = int_ptr()
	local file = find_first("*", "XGAME", file_handle)
	while file ~= nil do
		local file_name = ffi.string(file)
		if find_is_directory(file_handle[0]) == false and (file_name:find(".mp3") or file_name:find(".wav")) then
			files[#files+1] = file_name
		end
		file = find_next(file_handle[0])
	end
	find_close(file_handle[0])
	return files
end

local function normalize_file_name(name)
	if name:find("_") then
		name = name:gsub("_", " ")
	end
	if name:find(".mp3") then
		name = name:gsub(".mp3", "")
	end
	if name:find(".wav") then
		name = name:gsub(".wav", "")
	end
	return name
end

--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_player_hurt(e)
	if client_userid_to_entindex(e.attacker) == entity_get_local_player() then
		local sound_file = sound_name_to_file[e.hitgroup == 1 and ui_get(head_sound_ref) or ui_get(body_sound_ref)]
		if sound_file then
			for i=1, ui_get(volume_ref) do
				native_Surface_PlaySound(sound_file)
			end
		end
	end
end

local function on_player_blind(e)
	if client_userid_to_entindex(e.attacker) == entity_get_local_player() then
		local sound_file = sound_name_to_file[ui_get(body_sound_ref)]
		sndplaydelay:invoke_callback(0, sound_file)
	end
end

local function on_hit_sound_toggle(ref, value)
	local state = value or ui_get(ref)
	ui_set_visible(head_sound_ref, state)
	ui_set_visible(body_sound_ref, state)
	ui_set_visible(volume_ref, state)
end

--------------------------------------------------------------------------------
-- Initilization code
--------------------------------------------------------------------------------
local function init_sound(sound_name, sound_file)
	sound_names[#sound_names+1] = sound_name
	sound_name_to_file[sound_name] = sound_file
end

local function init()
	init_sound("Wood stop", "doors/wood_stop1.wav")
	init_sound("Wood strain", "physics/wood/wood_strain7.wav")
	init_sound("Wood plank impact", "physics/wood/wood_plank_impact_hard4.wav")
	init_sound("Warning", "resource/warning.wav")

	-- Setup serach path for hitsounds
	local current_path = char_buffer(128)
	current_directory(current_path, ffi.sizeof(current_path))
	current_path = string.format("%s\\csgo\\sound\\hitsounds", ffi.string(current_path))
	add_to_searchpath(current_path, "XGAME", 0)

	-- Collect sound files and add them to the hit sound list
	local sound_files = collect_files()
	for i=1, #sound_files do
		local file_name = sound_files[i]
		init_sound(normalize_file_name(file_name), string.format("hitsounds/%s", file_name))
	end
    ui.new_label('VISUALS', 'Colored models', '=------------  [ Custom Hitsound ]  -----------=')
	enable_ref	  = uix.new_checkbox("VISUALS", "Colored Models", "Custom Hitsound")
	head_sound_ref  = ui_new_combobox("VISUALS", "Colored Models", "Head Shot Sound", sound_names)
	body_sound_ref  = ui_new_combobox("VISUALS", "Colored Models", "Body Shot Sound", sound_names)
	volume_ref	  = ui.new_slider("VISUALS", "Colored Models", "Sound Volume", 1, 100, 1, true, "%")

	enable_ref:on("change", on_hit_sound_toggle)
	enable_ref:on("player_hurt", on_player_hurt)
	enable_ref:on("player_blind", on_player_blind)
end

init()