local ffi = require('ffi')
 
local voice_loopback = cvar.voice_loopback
 
local utils = { }
local menu_elements = { }
local runtime_elements = { }
local killvoice_list = database.read('killvoice_list') or { }
 
ffi.cdef([[
    typedef uint32_t( __thiscall *get_file_attributes_t )( uintptr_t, const char * );
    typedef uintptr_t( __thiscall *get_mod_address_t )( void *, const char * );
    typedef uintptr_t( __thiscall *get_proc_address_t )( void *, uintptr_t, const char * );
    typedef void( __fastcall *voice_record_start_t )( const char *, const char *, const char * );
]])
 
menu_elements.callbacks = { }
 
menu_elements.general_enable = ui.new_checkbox('lua', 'A', 'Enable killvoice')
menu_elements.show_settings = ui.new_checkbox('lua', 'B', 'Killvoice settings')
menu_elements.general_label = ui.new_label('lua', 'B', 'Killvoice file')
menu_elements.killvoice_file = ui.new_listbox('lua', 'B', 'Select file', killvoice_list)
menu_elements.error_not_found = ui.new_label('lua', 'B', '\aFF6060FFFile not found!')
menu_elements.file_name = ui.new_textbox('lua', 'B', 'File name')
menu_elements.add_button = ui.new_button('lua', 'B', 'Add', function() return menu_elements.callbacks.on_add_button() end)
menu_elements.remove_button = ui.new_button('lua', 'B', 'Remove', function() return menu_elements.callbacks.on_remove_button() end)
menu_elements.enable_loopback = ui.new_checkbox('lua', 'B', 'Loopback')
menu_elements.random_selection = ui.new_checkbox('lua', 'B', 'Random file')
menu_elements.play_if_assisted = ui.new_checkbox('lua', 'B', 'Play even was assisted')
menu_elements.killvoice_length = ui.new_slider('lua', 'B', 'Play duration', 0, 10, 1, true, 's')
menu_elements.play_button = ui.new_button('lua', 'B', 'Test', function() return runtime_elements.play_killvoice() end)
 
runtime_elements.callbacks = { }
runtime_elements.voice_end_timestamp = 0
runtime_elements.processing_killvoice = false
 
ui.set_visible(menu_elements.general_label, false)
ui.set_visible(menu_elements.enable_loopback, false)
ui.set_visible(menu_elements.killvoice_file, false)
ui.set_visible(menu_elements.show_settings, false)
ui.set_visible(menu_elements.file_name, false)
ui.set_visible(menu_elements.add_button, false)
ui.set_visible(menu_elements.remove_button, false)
ui.set_visible(menu_elements.killvoice_length, false)
ui.set_visible(menu_elements.random_selection, false)
ui.set_visible(menu_elements.play_if_assisted, false)
ui.set_visible(menu_elements.error_not_found, false)
ui.set_visible(menu_elements.play_button, false)
 
utils.interfaces = { }
utils.voice_record_start = ffi.cast(
    'voice_record_start_t',
    client.find_signature('engine.dll', '\x55\x8B\xEC\x83\xEC\x0C\x83\x3D\xCC\xCC\xCC\xCC\xCC\x56\x57') or error('voice_record_start not found!')
)
utils.get_mod_address = client.find_signature('client.dll', '\xC6\x06\x00\xFF\x15\xCC\xCC\xCC\xCC\x50') or error('get_mod_address not found!')
utils.get_proc_address = client.find_signature('client.dll', '\x50\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x0F\x84\xCC\xCC\xCC\xCC\x6A\x00') or error('get_proc_address not found!')
utils.winapi_bridge = client.find_signature('client.dll', '\x51\xC3') or error('winapi_bridge not found!')
 
utils.is_file_exists = function(file)
    local get_mod_address = ffi.cast('void***', ffi.cast('char*', utils.get_mod_address) + 5)[0][0]
    local get_proc_address = ffi.cast('void***', ffi.cast('char*', utils.get_proc_address) + 3)[0][0]
 
    local kernel32 = ffi.cast('get_mod_address_t', utils.winapi_bridge)(get_mod_address, 'kernel32.dll')
    local get_file_attributes = ffi.cast('get_proc_address_t', utils.winapi_bridge)(get_proc_address, kernel32, 'GetFileAttributesA')
 
    return tonumber(ffi.cast('get_file_attributes_t', utils.winapi_bridge)(get_file_attributes, file)) ~= 0xffffffff
end
 
utils.table_length = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
 
menu_elements.callbacks.on_general_enable = function()
    local general_enable = ui.get(menu_elements.general_enable)
 
    ui.set_visible(menu_elements.show_settings, general_enable)
    if not general_enable then ui.set(menu_elements.show_settings, false) end
end
 
menu_elements.callbacks.on_show_settings = function()
    local show_settings = ui.get(menu_elements.show_settings)
 
    ui.set_visible(menu_elements.general_label, show_settings)
    ui.set_visible(menu_elements.enable_loopback, show_settings)
    ui.set_visible(menu_elements.killvoice_file, show_settings)
    ui.set_visible(menu_elements.killvoice_length, show_settings)
    ui.set_visible(menu_elements.file_name, show_settings)
    ui.set_visible(menu_elements.add_button, show_settings)
    ui.set_visible(menu_elements.remove_button, show_settings)
    ui.set_visible(menu_elements.killvoice_length, show_settings)
    ui.set_visible(menu_elements.random_selection, show_settings)
    ui.set_visible(menu_elements.play_button, show_settings)
    ui.set_visible(menu_elements.play_if_assisted, show_settings)
end
 
menu_elements.callbacks.on_add_button = function()
    local file_name = ui.get(menu_elements.file_name)
    if not utils.is_file_exists('csgo\\sound\\' .. file_name) then
        ui.set_visible(menu_elements.error_not_found, true)
        error('file ' .. '\"csgo\\sound\\' .. file_name .. '\" not found!')
        return
    end
 
    ui.set_visible(menu_elements.error_not_found, false)
    table.insert(killvoice_list, file_name)
    ui.update(menu_elements.killvoice_file, killvoice_list)
    database.write('killvoice_list', killvoice_list)
    database.flush()
end
 
menu_elements.callbacks.on_remove_button = function()
    table.remove(killvoice_list, ui.get(menu_elements.killvoice_file) + 1) 
    ui.update(menu_elements.killvoice_file, killvoice_list)
 
    database.write('killvoice_list', killvoice_list)
    database.flush()
end
 
menu_elements.callbacks.on_killvoice_file = function()
    ui.set_visible(menu_elements.error_not_found, false)
    
    local killvoice_file = killvoice_list[ui.get(menu_elements.killvoice_file) + 1]
    if not utils.is_file_exists('csgo\\sound\\' .. killvoice_file) then
        ui.set_visible(menu_elements.error_not_found, true)
        error('file ' .. '\"csgo\\sound\\' .. killvoice_file .. '\" not found!')
    end
end
 
menu_elements.callbacks.on_enable_loopback = function()
    local enable_loopback = ui.get(menu_elements.enable_loopback)
    voice_loopback:set_int(enable_loopback)
end
 
runtime_elements.callbacks.on_player_death = function(event_info)
    if client.userid_to_entindex(event_info.attacker) == entity.get_local_player() then
        runtime_elements.play_killvoice()
    elseif ui.get(menu_elements.play_if_assisted) and client.userid_to_entindex(event_info.assister) == entity.get_local_player() then
        runtime_elements.play_killvoice()
    end
end
 
runtime_elements.callbacks.on_render = function()
    if not runtime_elements.processing_killvoice then 
        return 
    end
    if globals.realtime() >= runtime_elements.voice_end_timestamp then
        runtime_elements.processing_killvoice = false
        voice_loopback:set_int(0)
        client.exec('-voicerecord')
    end
end
 
runtime_elements.play_killvoice = function()
    if ui.get(menu_elements.killvoice_file) == nil or not ui.get(menu_elements.general_enable) then return end
    if ui.get(menu_elements.enable_loopback) then
        voice_loopback:set_int(1)
    end
    if ui.get(menu_elements.random_selection) then
        local killvoice_file = killvoice_list[math.random(1, utils.table_length(killvoice_list))]
        if not utils.is_file_exists('csgo\\sound\\' .. killvoice_file) then
            error('file ' .. '\"csgo\\sound\\' .. killvoice_file .. '\" not found!')
            return
        end
        utils.voice_record_start(nil, nil, 'csgo\\sound\\' .. killvoice_file)
    else
        local killvoice_file = killvoice_list[ui.get(menu_elements.killvoice_file) + 1]
        if not utils.is_file_exists('csgo\\sound\\' .. killvoice_file) then
            error('file ' .. '\"csgo\\sound\\' .. killvoice_file .. '\" not found!')
            return
        end
        utils.voice_record_start(nil, nil, 'csgo\\sound\\' .. killvoice_file)
    end
    runtime_elements.voice_end_timestamp = globals.realtime() + ui.get(menu_elements.killvoice_length)
    runtime_elements.processing_killvoice = true
end
 
runtime_elements.callbacks.shutdown = function()
    voice_loopback:set_int(0)
end
 
ui.set_callback(menu_elements.general_enable, menu_elements.callbacks.on_general_enable)
ui.set_callback(menu_elements.show_settings, menu_elements.callbacks.on_show_settings)
ui.set_callback(menu_elements.enable_loopback, menu_elements.callbacks.on_enable_loopback)
ui.set_callback(menu_elements.killvoice_file, menu_elements.callbacks.on_killvoice_file)
 
client.set_event_callback('player_death', runtime_elements.callbacks.on_player_death)
client.set_event_callback('shutdown', runtime_elements.callbacks.shutdown)
client.set_event_callback('paint', runtime_elements.callbacks.on_render)