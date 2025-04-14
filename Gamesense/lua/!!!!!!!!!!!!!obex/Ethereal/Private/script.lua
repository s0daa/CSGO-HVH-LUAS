-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for API functions. any changes to the line below will be lost on re-generationlocal 
bit_band, client_camera_angles, client_color_log, client_create_interface, client_current_threat, client_eye_position, client_key_state, client_latency, client_log, client_random_int, client_register_esp_flag, client_scale_damage, client_screen_size, client_set_clan_tag, client_set_cvar, client_set_event_callback, client_trace_bullet, client_trace_line, client_userid_to_entindex, entity_get_all, entity_get_classname, entity_get_game_rules, entity_get_local_player, entity_get_player_resource, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, entity_set_prop, globals_chokedcommands, globals_curtime, globals_framecount, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, math_atan, math_atan2, math_ceil, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, panorama_loadstring, renderer_circle, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_char, string_gmatch, string_gsub, table_insert, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible, toticks, setmetatable, string_sub, table_remove, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ipairs = bit.band, client.camera_angles, client.color_log, client.create_interface, client.current_threat, client.eye_position, client.key_state, client.latency, client.log, client.random_int, client.register_esp_flag, client.scale_damage, client.screen_size, client.set_clan_tag, client.set_cvar, client.set_event_callback, client.trace_bullet, client.trace_line, client.userid_to_entindex, entity.get_all, entity.get_classname, entity.get_game_rules, entity.get_local_player, entity.get_player_resource, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, entity.set_prop, globals.chokedcommands, globals.curtime, globals.framecount, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, math.atan, math.atan2, math.ceil, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, panorama.loadstring, renderer.circle, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.char, string.gmatch, string.gsub, table.insert, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible, toticks, setmetatable, string.sub, table.remove, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ipairs

--//library
vector = require 'vector'
ffi = require 'ffi'
anti_aim_f = require 'gamesense/antiaim_funcs'
c_entity = require 'gamesense/entity'
base64 = require 'gamesense/base64'
clipboard = require 'gamesense/clipboard'
csgo_weapons = require 'gamesense/csgo_weapons'

--//cfg system
gui_handler = {}
gui_handler.export={['number']={},['boolean']={},['table']={},['string']={}}gui_handler.call={}gui_handler.export_config=function()local a=function(b)b=ui_get(b)local c=''for d=1,#b do c=c..b[d]..(d==#b and''or',')end;if c==''then c='-'end;return c end;local c=''for d,e in pairs(gui_handler.export['number'])do c=c..tostring(ui_get(e))..'|'end;for d,e in pairs(gui_handler.export['string'])do c=c..ui_get(e)..'|'end;for d,e in pairs(gui_handler.export['boolean'])do c=c..tostring(ui_get(e))..'|'end;for d,e in pairs(gui_handler.export['table'])do c=c..a(e)..'|'end;clipboard.set(base64.encode(c,'base64'))end;gui_handler.load_config=function()local f=function(g,h)local i={}for c in string.gmatch(g,'([^'..h..']+)')do i[#i+1]=string.gsub(c,'\n','')end;return i end;local j=function(c)if c=='true'or c=='false'then return c=='true'else return c end end;local k=f(base64.decode(clipboard.get(),'base64'),'|')local l=1;for d,e in pairs(gui_handler.export['number'])do ui_set(e,tonumber(k[l]))l=l+1 end;for d,e in pairs(gui_handler.export['string'])do ui_set(e,k[l])l=l+1 end;for d,e in pairs(gui_handler.export['boolean'])do ui_set(e,j(k[l]))l=l+1 end;for d,e in pairs(gui_handler.export['table'])do ui_set(e,f(k[l],','))l=l+1 end end;gui_handler.update_callbacks=function()for m,n in pairs(gui_handler.call)do if n~=nil then ui_set_visible(n.ref,n.conditon())end end end;gui_handler.new=function(n,o,...)if type(n)~='number'then print('unable to create new register,register should be a number')end;if type(n)=='number'then table_insert(gui_handler.export[type(ui_get(n))],n)end;if o==nil then o=function()return true end end;if gui_handler.call[n]==nil then gui_handler.call[n]={}end;gui_handler.call[n]={ref=n,conditon=function()return o end}gui_handler.update_callbacks()ui_set_callback(n,gui_handler.update_callbacks)return n end

--//reference
local ref = {
    enabled = ui_reference('AA', 'Anti-aimbot angles', 'Enabled'),
    pitch = { ui_reference('AA', 'Anti-aimbot angles', 'Pitch') },
    yaw_base = ui_reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = { ui_reference('AA', 'Anti-aimbot angles', 'Yaw') },
    yaw_jitter = {ui_reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
    body_yaw = { ui_reference('AA', 'Anti-aimbot angles', 'Body yaw') },
    freestanding_body_yaw = ui_reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
    edge_yaw = ui_reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    roll = ui_reference('AA', 'Anti-aimbot angles', 'Roll'),
    freestanding = { ui_reference('AA', 'Anti-aimbot angles', 'Freestanding') },
    slowwalk = { ui_reference('AA', 'Other', 'Slow motion') },
    leg_movement = ui_reference('AA', 'Other', 'Leg movement'),
    doubletap = { ui_reference('RAGE', 'Aimbot', 'Double tap') },
    doubletapfl = ui_reference('RAGE', 'Aimbot', 'Double tap fake lag limit'),
    fakeduck = ui_reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui_reference('RAGE', 'Aimbot', 'Force safe point'),
    forcebaim = ui_reference('RAGE', 'Aimbot', 'Force body aim'),
    quickpeek = { ui_reference('RAGE', 'Other', 'Quick peek assist') },
    onshotaa = { ui_reference('AA', 'Other', 'On shot anti-aim') },
    fakelag = { ui_reference('AA', 'Fake lag', 'Enabled') },
    amout = ui_reference('AA', 'Fake lag', 'Amount'),
    limit = ui_reference('AA', 'Fake lag', 'Limit'),
    variance = ui_reference('AA', 'Fake lag', 'Variance'),
    ping_spike = { ui_reference('MISC', 'Miscellaneous', 'Ping spike') },
    playerlist = ui_reference('Players', 'Players', 'Player list')
}

--//variables
local variables = {
    conditions = { 'Global', 'Stand', 'Move', 'Crouch', 'Crouch Move', 'Slowwalk', 'Air duck', 'Air', 'Legitaa', 'Fakelag', 'Fakeduck' },
    cheat_conditions = { 'Normal', 'Neverlose'},
    player_state = 1,
    antiaim_state = 'Global',
    legitaaon = false,
    fs_disabled = 0,
    aa_dir = 0,
    last_press_t = 0,
    changer_state = 0,
    yaw_value = 0,
    bodyyaw_value = 0,
    fakelimit_value = 0,
    classnames = {
        'CWorld',
        'CCSPlayer',
        'CFuncBrush'
    },
    checker = 0,
    defensive = 0,
    update_dt = 0,
    yaw_choke = false,
    yaw_tick = 0,
    sway_stage = 1,
    tick_var3 = 0,
    label = ui.new_label('AA', 'Anti-aimbot angles',' '),
    label2 = ui.new_label('AA', 'Anti-aimbot angles',' '),
    label3 = ui.new_label('AA', 'Anti-aimbot angles',' '),
    label4 = ui.new_label('AA', 'Anti-aimbot angles',' '),
    counter = 0,
    location = 1,
    flip     = false,
    nl_player = {},
    plist_aa = {},
    last_selected = 0
}

--//function
local function get_velocity(player)
    local velocity_vec = vector(entity_get_prop(player, 'm_vecVelocity'))
    return velocity_vec:length()
end

local function on_ground(player)
    return bit_band(entity_get_prop(player, 'm_fFlags'), 1) == 1
end

local function in_air(player)
    return bit_band(entity_get_prop(player, 'm_fFlags'), 1) == 0
end

local function is_crouching(player)
    return bit_band(entity_get_prop(player, 'm_fFlags'), 4) == 4
end

local function contains(array, value)
    if not array then
        return false
    end
    array = ui_get(array)
    for i, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

local function entity_has_c4(ent)
    local bomb = entity_get_all('CC4')[1]
    return bomb ~= nil and entity_get_prop(bomb, 'm_hOwnerEntity') == ent
end

local function sway(max, speed, min)
    return math_abs(math_floor((math_sin(globals_curtime()/speed*1)*max)))
end

local rgba_to_hex = function(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

local function text_fade_animation(speed, r, g, b, a, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i=0, #text do
        local color = rgba_to_hex(r, g, b, a*math.abs(1*math.cos(2*speed*curtime/4+i*5/30)))
        final_text = final_text..'\a'..color..text:sub(i, i)
    end
    return final_text
end

-- Animation
local function animationtext()
    local text = text_fade_animation(2, 95, 98, 155, 255,'Lullaby [ Nightly ]')
    local text2 = text_fade_animation(2, 95, 98, 155, 255,'DC : F1veF1ve#9999')
    local text3 = text_fade_animation(2, 95, 98, 155, 255,'QQ : 2328264465')
    if not ui.is_menu_open() then return end
    ui.set(variables.label, text)
    ui.set(variables.label2, text2)
    ui.set(variables.label3, text3)
end

local function defensivepitch()
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) or ui_get(ref.onshotaa[1]) and ui_get(ref.onshotaa[2]) then
        return
    end
    local tickbase = entity.get_prop(local_player, 'm_nTickBase')
    variables.defensive = math.abs(tickbase - (variables.checker or 0))
    variables.checker = math.max(tickbase, variables.checker or 0)
end

for i=0, 64 do
	variables.plist_aa[i] = ui_new_checkbox("PLAYERS", "Adjustments", "Neverlose User")
    ui_set_visible(variables.plist_aa[i], false)
end

local function lpbodyyaw(a, b)
    local at_target = client_current_threat()
    local cheatmode = 1
    if at_target ~= nil then 
        cheatmode = ui_get(variables.plist_aa[at_target]) and 2 or 1
    end
    local check = (ui_get(builder[cheatmode][variables.player_state].enabled) and variables.player_state or 1)
    local local_player = entity_get_local_player()
    local desync = math.min(60, entity_get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)
    local overlap = anti_aim_f.get_overlap(rotation)
    local defensive_brute = builder[cheatmode][check].defensive_brute
    local avoid_overlap = contains(defensive_brute, 'Avoid overlap')
    if avoid_overlap then
        return (desync > 0 and overlap > 0.6 and a or b)
    else
        return (desync > 0 and a or b)
    end
end

--call back

--//aa menu
menu =  {'AA', 'Anti-aimbot angles'}

active_tab = ui_new_combobox(menu[1], menu[2], 'Tabs selector', {'Anti-Aim', 'Visuals', 'Misc', 'Config' })

cheat_selector = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Cheat selector', variables.cheat_conditions))
conditions_selector = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Conditions selector', variables.conditions))

builder = {}
for idx, v in pairs(variables.cheat_conditions) do
    if builder[idx] == nil then
        builder[idx] = {}
    end
    for i, v in pairs(variables.conditions) do
    f = '\a6DF9B1FF'..variables.conditions[i]..''..'\aFFFFFFC8'
    g = '\a6DF9B1FF'..variables.cheat_conditions[idx]..''..'\aFFFFFFC8'
    builder[idx][i] = {
        enabled = gui_handler.new(ui_new_checkbox(menu[1], menu[2], 'Enable Conditions [' .. f .. '] '..'['.. g ..']')),
        pitch = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Pitch [' .. f .. '] '..'['.. g ..']', { 'Off', 'Default', 'Up', 'Down', 'Minimal', 'Custom'})),
        custompitch = gui_handler.new(ui_new_slider(menu[1], menu[2], 'custom pitch [' .. f .. '] '..'['.. g ..']', -89, 89, 0)),

        yaw = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Yaw [' .. f .. '] '..'['.. g ..']', {'180', 'rotation[Way]', 'Spin', '180L/R'})),
        yaw_rotation = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Yaw rotation [' .. f .. '] '..'['.. g ..']', 3, 6, 3)),
        
        yaw_val_1 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[1] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_val_2 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[2] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_val_3 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[3] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_val_4 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[4] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_val_5 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[5] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_val_6 = gui_handler.new(ui_new_slider(menu[1], menu[2], '[6] Yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),

        yaw_jitter = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Yaw jitter [' .. f .. '] '..'['.. g ..']', { 'Off', 'Offset', 'Center', 'Random', 'Skitter', 'Custom' })),
        yaw_jitter_lr_three = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Custom Yaw jitter [' .. f .. '] '..'['.. g ..']', { 'Offset', 'Center', 'Random', 'Skitter' })),
        yaw_jitter_add = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Yaw jitter offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_jitter_left = gui_handler.new(ui_new_slider(menu[1], menu[2], '[L] Yaw jitter offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        yaw_jitter_right = gui_handler.new(ui_new_slider(menu[1], menu[2], '[R] Yaw jitter offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),

        body_yaw = gui_handler.new(ui_new_combobox(menu[1], menu[2], 'Body yaw [' .. f .. '] '..'['.. g ..']', { 'Off', 'Opposite', 'Jitter', 'Static','Lullaby[Tick]', 'Lullaby[Choke]'})),
        body_yaw_left = gui_handler.new(ui_new_slider(menu[1], menu[2], '[R] Body yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        body_yaw_right = gui_handler.new(ui_new_slider(menu[1], menu[2], '[L] Body yaw offset [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),

        yaw_time = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Custom tick [' .. f .. '] '..'['.. g ..']', 1, 15, 2)),
        fake_yaw_left = gui_handler.new(ui_new_slider(menu[1], menu[2], '[R] Fake Limit offset [' .. f .. '] '..'['.. g ..']', 0, 60, 0)),
        fake_yaw_right = gui_handler.new(ui_new_slider(menu[1], menu[2], '[L] Fake Limit offset [' .. f .. '] '..'['.. g ..']', 0, 60, 0)),

        defensive_brute = gui_handler.new(ui_new_multiselect(menu[1], menu[2], 'Extra [' .. f .. '] '..'['.. g ..']', {'Yaw', 'Pitch', 'Avoid overlap', 'Height advantage Safe'})),
        advantage_l = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Safe limit [' .. f .. '] '..'['.. g ..']', 25, 250, 50)),
        defensive_brute_tick = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Break Tick [' .. f .. '] '..'['.. g ..']', 2, 12, 12)),
        defensive_brute_yaw = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Yaw break [' .. f .. '] '..'['.. g ..']', -180, 180, 0)),
        defensive_brute_pitch = gui_handler.new(ui_new_slider(menu[1], menu[2], 'Pitch break [' .. f .. '] '..'['.. g ..']', -89, 89, 0)),

        freestanding_body_yaw = gui_handler.new(ui_new_checkbox(menu[1], menu[2], 'Freestanding body yaw [' .. f .. '] '..'['.. g ..']')),
    }
end
end
--aa tab
misctab = gui_handler.new(ui_new_multiselect(menu[1], menu[2], 'KeyBinds', { 'Freestanding', 'Legit anti-aimbot', 'Edge yaw', 'Manual AA', 'Force Defensive'}))
legit_aa_key = ui_new_hotkey(menu[1], menu[2], 'Legit anti-aimbot', false, 0x45)
freestanding = ui_new_hotkey(menu[1], menu[2], 'Freestanding', false)
freestanding_dis = gui_handler.new(ui_new_multiselect(menu[1], menu[2], 'Freestanding disablers', { 'Slow motion', 'In air', 'Crouching', 'Moving' }))
edge_yaw = ui_new_hotkey(menu[1], menu[2], 'Edge yaw', false)
manual_left = ui_new_hotkey(menu[1], menu[2], 'Manual left', false)
manual_right = ui_new_hotkey(menu[1], menu[2], 'Manual right', false)
force_def = ui_new_hotkey(menu[1], menu[2], 'Force Defensive', false)
force_def_conditions = gui_handler.new(ui_new_multiselect(menu[1], menu[2], 'Force Defensive Conditions', variables.conditions))

--cfg system
export_button = ui_new_button(menu[1], menu[2], 'Export Config To Clipboard', function ()
    gui_handler.export_config()
    print('Exported Config to Clipboard')
end)

load_button = ui_new_button(menu[1], menu[2], 'Load Config From Clipboard', function ()
    gui_handler.load_config()
    print('Loaded Config From Clipboard')
end)


--//handle_menu
local function handle_menu()
    for i, v in pairs(variables.conditions) do
    for idx, v in pairs(variables.cheat_conditions) do

        local show = ui_get(conditions_selector) == variables.conditions[i]
        local show_conditions = show and ui_get(builder[idx][i].enabled)
        local activetab = ui_get(active_tab)
        
        ui_set_visible(cheat_selector, activetab == 'Anti-Aim')
        ui_set_visible(conditions_selector, activetab == 'Anti-Aim')
        ui_set(builder[idx][1].enabled, true)
        ui_set_visible(builder[idx][1].enabled, false)

        ui_set_visible(builder[idx][i].enabled, show and ui_get(cheat_selector) == v and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].pitch, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].custompitch, show_conditions and ui_get(builder[idx][i].pitch) == 'Custom' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].yaw, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_rotation, show_conditions and ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_1, show_conditions and (ui_get(builder[idx][i].yaw) == '180' or ui_get(builder[idx][i].yaw) == 'Spin' or ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 1) and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_2, show_conditions and (ui_get(builder[idx][i].yaw) == '180L/R' or ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 2) and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_3, show_conditions and (ui_get(builder[idx][i].yaw) == '180L/R' or ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 3) and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_4, show_conditions and ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 4 and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_5, show_conditions and ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 5 and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_val_6, show_conditions and ui_get(builder[idx][i].yaw) == 'rotation[Way]' and ui_get(builder[idx][i].yaw_rotation) >= 6 and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].yaw_jitter, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_jitter_lr_three, show_conditions and ui_get(builder[idx][i].yaw_jitter) == 'Custom' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_jitter_add, show_conditions and (ui_get(builder[idx][i].yaw_jitter) == 'Offset' or ui_get(builder[idx][i].yaw_jitter) == 'Center' or ui_get(builder[idx][i].yaw_jitter) == 'Random' or ui_get(builder[idx][i].yaw_jitter) == 'Skitter') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_jitter_left, show_conditions and ui_get(builder[idx][i].yaw_jitter) == 'Custom' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].yaw_jitter_right, show_conditions and ui_get(builder[idx][i].yaw_jitter) == 'Custom' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].body_yaw, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].body_yaw_left, show_conditions and ui_get(builder[idx][i].body_yaw) ~= 'Off' and ui_get(builder[idx][i].body_yaw) ~= 'Opposite' and ui_get(builder[idx][i].body_yaw) ~= 'Lullaby[Tick]' and ui_get(builder[idx][i].body_yaw) ~= 'Lullaby[Choke]' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].body_yaw_right, show_conditions and ui_get(builder[idx][i].body_yaw) ~= 'Off' and ui_get(builder[idx][i].body_yaw) ~= 'Opposite' and ui_get(builder[idx][i].body_yaw) ~= 'Lullaby[Tick]' and ui_get(builder[idx][i].body_yaw) ~= 'Lullaby[Choke]' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].yaw_time, show_conditions and ui_get(builder[idx][i].body_yaw) == 'Lullaby[Tick]' and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].fake_yaw_left, show_conditions and (ui_get(builder[idx][i].body_yaw) == 'Lullaby[Tick]' or ui_get(builder[idx][i].body_yaw) == 'Lullaby[Choke]') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].fake_yaw_right, show_conditions and (ui_get(builder[idx][i].body_yaw) == 'Lullaby[Tick]' or ui_get(builder[idx][i].body_yaw) == 'Lullaby[Choke]') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        
        ui_set_visible(builder[idx][i].defensive_brute, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].defensive_brute_tick, show_conditions and (contains(builder[idx][i].defensive_brute, 'Yaw') or contains(builder[idx][i].defensive_brute, 'Pitch') or contains(builder[idx][i].defensive_brute, 'Yaw jitter')) and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].defensive_brute_yaw, show_conditions and contains(builder[idx][i].defensive_brute, 'Yaw') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].defensive_brute_pitch, show_conditions and contains(builder[idx][i].defensive_brute, 'Pitch') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')
        ui_set_visible(builder[idx][i].advantage_l, show_conditions and contains(builder[idx][i].defensive_brute, 'Height advantage Safe') and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        ui_set_visible(builder[idx][i].freestanding_body_yaw, show_conditions and ui_get(cheat_selector) == v and activetab == 'Anti-Aim')

        local misc_options = {
            {control = legit_aa_key, name = 'Legit anti-aimbot'},
            {control = freestanding, name = 'Freestanding'},
            {control = freestanding_dis, name = 'Freestanding'},
            {control = edge_yaw, name = 'Edge yaw'},
            {control = manual_left, name = 'Manual AA'},
            {control = manual_right, name = 'Manual AA'},
            {control = force_def, name = 'Force Defensive'},
            {control = force_def_conditions, name = 'Force Defensive'}
        }
        
        for _, option in ipairs(misc_options) do
            ui_set_visible(option.control, contains(misctab, option.name) and activetab == 'Misc')
        end
        
        ui_set_visible(misctab, activetab == 'Misc')
        
        local buttons = {
            {button = export_button, tab = 'Config'},
            {button = load_button, tab = 'Config'}
        }
          
        for _, button in ipairs(buttons) do
            ui_set_visible(button.button, activetab == button.tab)
        end
          
        local selected = ui_get(ref.playerlist)
        if selected ~= variables.last_selected and selected ~= nil then
            ui_set_visible(variables.plist_aa[selected], true)
            if variables.last_selected ~= 0 then
                ui_set_visible(variables.plist_aa[variables.last_selected], false)
            end
            variables.last_selected = selected
        end
        

    end
    end
end

local function player_condition_main(e)
    local localplayer = entity_get_local_player()
    if localplayer == nil then return end

    local enemies = entity_get_players(true)
    local onground = on_ground(localplayer) and e.in_jump == 0
    local legit_aa = ui_get(legit_aa_key)
    local velocity = get_velocity(localplayer)
    local crouched = is_crouching(localplayer) and onground
    local crouchmove = is_crouching(localplayer) and onground
    local flags = entity_get_prop(localplayer, 'm_fFlags') --263 crouch, 257 on ground, 256 in air
    local slowwalking = ui_get(ref.slowwalk[ 2 ]) and onground and velocity > 2 and not crouched
    local inair_crouch = in_air(localplayer) and not onground and flags == 262
    local inair = in_air(localplayer) and not onground
    local fakeducking = ui_get(ref.fakeduck) and onground

    variables.player_state = 1
    variables.antiaim_state = 'Global'
    if legit_aa then
        variables.player_state = 9
        variables.antiaim_state = 'Legitaa'
    elseif not ui_get(ref.doubletap[2]) and not ui_get(ref.onshotaa[2]) and not legit_aa then
        variables.player_state = 10
        variables.antiaim_state = 'Fakelag'
    elseif inair_crouch then
        variables.player_state = 7
        variables.antiaim_state = 'Air duck'
    elseif inair then
        variables.player_state = 8
        variables.antiaim_state = 'Air'
    elseif slowwalking and not fakeducking then
        variables.player_state = 6
        variables.antiaim_state = 'Slowwalk'
    elseif onground and velocity > 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
        variables.player_state = 3
        variables.antiaim_state = 'Move'
    elseif fakeducking then
        variables.player_state = 11
        variables.antiaim_state = 'Fakeduck'
    elseif onground and velocity < 2 and flags ~= 256 and flags ~= 263 and not fakeducking then
        variables.player_state = 2
        variables.antiaim_state = 'Stand'
    elseif crouchmove and velocity > 2 and not fakeducking then
        variables.player_state = 5
        variables.antiaim_state = 'Crouch Move'
    elseif crouched or fakeducking then
        variables.player_state = 4
        variables.antiaim_state = 'Crouch'
    end
    if legit_aa then
        variables.legitaaon = true
    else
        variables.legitaaon = false
    end
end
    

local function aa_on_use(e)
    local legitaa_key = ui_get(legit_aa_key)

    if legitaa_key then
        local plocal = entity_get_local_player()
        
        local distance = 100
        local bomb = entity_get_all('CPlantedC4')[1]
        local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, 'm_vecOrigin')

        if bomb_x then
            local player_x, player_y, player_z = entity_get_prop(plocal, 'm_vecOrigin')
            distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
        end
        
        local team_num = entity_get_prop(plocal, 'm_iTeamNum')
        local defusing = team_num == 3 and distance < 62

        local on_bombsite = entity_get_prop(plocal, 'm_bInBombZone')

        local has_bomb = entity_has_c4(plocal)
        
        local px, py, pz = client_eye_position()
        local pitch, yaw = client_camera_angles()
        
        local rad_pitch = math.rad(pitch)
        local rad_yaw = math.rad(yaw)
        local sin_pitch = math.sin(rad_pitch)
        local cos_pitch = math.cos(rad_pitch)
        local sin_yaw = math.sin(rad_yaw)
        local cos_yaw = math.cos(rad_yaw)

        local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

        local fraction, entindex = client_trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

        local using = true

        if entindex then
            for i=1, #variables.classnames do
                if entity_get_classname(entindex) == variables.classnames[i] then
                    using = false
                    break
                end
            end
        end

        if not using and not defusing then
            e.in_use = 0
        end
    end
end

client.register_esp_flag("NL MODE", 42, 57, 189, function(player)
    local current_threat = client.current_threat()
    return ui_get(variables.plist_aa[current_threat])
end)

local function check_sway_stage(e)
    local at_target = client_current_threat()
    local cheatmode = at_target and ui_get(variables.plist_aa[at_target]) and 2 or 1
    local changer_state = ui_get(builder[cheatmode][variables.player_state].enabled) and variables.player_state or 1
    local yaw_rotation = ui_get(builder[cheatmode][changer_state].yaw_rotation)
    local tickcount = globals.tickcount()
    
    if tickcount - variables.tick_var3 > 1 and e.chokedcommands == 0 then
        if yaw_rotation >= 3 and yaw_rotation <= 6 then
            local max_stage = yaw_rotation + 1
            if variables.sway_stage < max_stage then 
                variables.sway_stage = variables.sway_stage + 1
            else
                variables.sway_stage = 1
            end
            variables.tick_var3 = tickcount
        end
    elseif tickcount - variables.tick_var3 < -1 then
        variables.tick_var3 = tickcount
    end
end

local function disable_custom(e)
    local local_player = entity.get_local_player()
    if not entity_is_alive(local_player) then
        return
    end
    weapon = csgo_weapons[entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex")]
    if weapon == nil then
        return
    end 

    local check = entity_get_prop(entity.get_local_player(), "m_MoveType") == 9
    local check2 = weapon.type == "grenade"

    if check2 or e.in_attack == 1 then
        return true
    end
    return e.in_attack == 1 and not check2 or frozen or check
end

local function handle_main_antiaim(e)
    local local_player = entity_get_local_player()
    if not entity_is_alive(local_player) then
        return
    end
    ui_set(manual_left, 'On hotkey')
    ui_set(manual_right, 'On hotkey')
    ui_set(ref.edge_yaw, ui_get(edge_yaw))

    if contains(freestanding_dis, 'Crouching') and (variables.player_state == 4 or variables.player_state == 5 or variables.player_state == 11) then
        variables.fs_disabled = 1
    elseif contains(freestanding_dis, 'In air') and (variables.player_state == 7 or variables.player_state == 8) then
        variables.fs_disabled = 1
    elseif contains(freestanding_dis, 'Slow motion') and variables.player_state == 6 then
        variables.fs_disabled = 1
    elseif contains(freestanding_dis, 'Moving') and variables.player_state == 3 then
        variables.fs_disabled = 1
    elseif variables.player_state == 9 or variables.aa_dir ~= 0 then
        variables.fs_disabled = 1
    else
        variables.fs_disabled = 0
    end

    if contains(force_def_conditions, 'Global') and variables.player_state == 1 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Stand') and variables.player_state == 2 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Move') and variables.player_state == 3 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Crouch') and variables.player_state == 4 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Crouch Move') and variables.player_state == 5 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Slowwalk') and variables.player_state == 6 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Air duck') and variables.player_state == 7 then
        --e.force_defensive = variables.update_dt + 0.1 < globals.tickcount()
        --variables.update_dt = globals.tickcount()
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Air') and variables.player_state == 8 then
        --e.force_defensive = variables.update_dt + 0.1 < globals.tickcount()
        --variables.update_dt = globals.tickcount()
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Legitaa') and variables.player_state == 9 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Fakelag') and variables.player_state == 10 then
        e.force_defensive = 1
    elseif contains(force_def_conditions, 'Fackduck') and variables.player_state == 11 then
        e.force_defensive = 1
    end

    ui_set(ref.limit, ui_get(ref.onshotaa[1]) and ui_get(ref.onshotaa[2]) and not (ui_get(ref.doubletap[1]) and ui_get(ref.doubletap[2])) and not ui_get(ref.fakeduck) and 5 or 14)


    if variables.fs_disabled == 0 and ui_get(freestanding) then
        ui_set(ref.freestanding[1], true)
        ui_set(ref.freestanding[2], 'Always on')
    else
        ui_set(ref.freestanding[1], false)
    end

    if variables.legitaaon then
        variables.last_press_t = globals_curtime()
    else
        if ui_get(manual_right) and variables.last_press_t + 0.2 < globals_curtime() then
            variables.aa_dir = variables.aa_dir == 90 and 0 or 90
            variables.last_press_t = globals_curtime()
        elseif ui_get(manual_left) and variables.last_press_t + 0.2 < globals_curtime() then
            variables.aa_dir = variables.aa_dir == -90 and 0 or -90
            variables.last_press_t = globals_curtime()
        elseif variables.last_press_t > globals_curtime() then
            variables.last_press_t = globals_curtime()
        end
    end

    local at_target = client_current_threat()
    
    local cheatmode = at_target and ui_get(variables.plist_aa[at_target]) and 2 or 1

    variables.changer_state = (ui_get(builder[cheatmode][variables.player_state].enabled) and variables.player_state or 1)

    ui_set(ref.yaw_base, (variables.player_state ~= 9 and variables.aa_dir == 0) and 'At targets' or 'Local view')

    if variables.aa_dir ~= 0 and variables.player_state ~= 9 then
        ui_set(ref.yaw[2], variables.aa_dir)
        ui_set(ref.yaw_jitter[1], 'Off')
        ui_set(ref.yaw_jitter[2], 0)
        ui_set(ref.body_yaw[1], 'Static')
        ui_set(ref.body_yaw[2], 180)
        ui_set(ref.freestanding_body_yaw, false)
    end

    local last_origin = vector(0, 0, 0)
    local origin = vector(entity.get_origin(entity_get_local_player()))
    local threat = client_current_threat()
    local height_to_threat = 0

    if e.chokedcommands == 0 then
        last_origin = origin
    end

    if threat then
        local threat_origin = vector(entity.get_origin(threat))
        height_to_threat = origin.z-threat_origin.z
    end

    tickbase = entity_get_prop(entity_get_local_player(), 'm_nTickBase')

    variables.yaw_value = ui_get(builder[cheatmode][variables.changer_state].yaw_val_1)

    local body_yaw = ui_get(builder[cheatmode][variables.changer_state].body_yaw)
    local choke = e.chokedcommands ~= 0
    
    if body_yaw == 'Lullaby[Tick]' then
        local tick_time = ui_get(builder[cheatmode][variables.changer_state].yaw_time)
        local tick_check = tickbase > variables.yaw_tick + tick_time
    
        if choke and tick_check then
            variables.yaw_choke = not variables.yaw_choke
            variables.yaw_tick = tickbase
        end
    elseif body_yaw == 'Lullaby[Choke]' and choke then
        variables.yaw_choke = not variables.yaw_choke
    end

    if contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Yaw') and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) and variables.aa_dir == 0 then
        variables.yaw_value = ui_get(builder[cheatmode][variables.changer_state].defensive_brute_yaw)
        ui_set(ref.yaw[2], variables.yaw_value)
    elseif choke and variables.changer_state ~= 0 and (ui_get(builder[cheatmode][variables.changer_state].yaw) == 'rotation[Way]') and variables.aa_dir == 0 then
        R = {}
        for i = 1, ui_get(builder[cheatmode][variables.changer_state].yaw_rotation) do
        R[i] = ui_get(builder[cheatmode][variables.changer_state]['yaw_val_'.. i])
        end
        if variables.sway_stage <= ui_get(builder[cheatmode][variables.changer_state].yaw_rotation) and choke then
            variables.yaw_value = R[variables.sway_stage]
        end
        ui_set(ref.yaw[2], variables.yaw_value)
    elseif variables.changer_state ~= 0 and (ui_get(builder[cheatmode][variables.changer_state].yaw) == '180') and variables.aa_dir == 0 then
        variables.yaw_value = ui_get(builder[cheatmode][variables.changer_state].yaw_val_1)
        ui_set(ref.yaw[2], variables.yaw_value)
    elseif choke and variables.changer_state ~= 0 and variables.aa_dir == 0 then
        variables.yaw_value = lpbodyyaw(ui_get(builder[cheatmode][variables.changer_state].yaw_val_2), ui_get(builder[cheatmode][variables.changer_state].yaw_val_3))
        ui_set(ref.yaw[2], variables.yaw_value)
    end

    if (contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Pitch')) and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) then
        pitchval = ui_get(builder[cheatmode][variables.changer_state].defensive_brute_pitch)
    end
    
    if (ui_get(builder[cheatmode][variables.changer_state].yaw) == 'rotation[Way]') and ui_get(builder[cheatmode][variables.changer_state].yaw_rotation) >= 3 then
        variables.bodyyaw_value = lpbodyyaw(ui_get(builder[cheatmode][variables.changer_state].body_yaw_left), ui_get(builder[cheatmode][variables.changer_state].body_yaw_right))
    else
        variables.bodyyaw_value = lpbodyyaw(ui_get(builder[cheatmode][variables.changer_state].body_yaw_left), ui_get(builder[cheatmode][variables.changer_state].body_yaw_right))
    end

    if variables.changer_state ~= 0 and variables.aa_dir == 0 then
            if ui_get(builder[cheatmode][variables.changer_state].yaw) == 'rotation[Way]' and variables.legitaaon then
                ui_set(ref.pitch[1], 'Off')
            elseif contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Pitch') and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) then
                ui_set(ref.pitch[1], 'Custom')
                ui_set(ref.pitch[2], pitchval)
            elseif ui_get(builder[cheatmode][variables.changer_state].yaw) == 'Spin' then
                ui_set(ref.pitch[1], ui_get(builder[cheatmode][variables.changer_state].pitch))
                ui_set(ref.pitch[2], ui_get(builder[cheatmode][variables.changer_state].custompitch))
                ui_set(ref.yaw[1], 'Spin')
                ui_set(ref.yaw[2], ui_get(builder[cheatmode][variables.changer_state].yaw_val_1))
            elseif ui_get(builder[cheatmode][variables.changer_state].yaw) == '180' or ui_get(builder[cheatmode][variables.changer_state].yaw) == '180L/R' or ui_get(builder[cheatmode][variables.changer_state].yaw) == '180L/R[Choke]' or ui_get(builder[cheatmode][variables.changer_state].yaw) == '180L/R[Tick]'then
                ui_set(ref.pitch[1], ui_get(builder[cheatmode][variables.changer_state].pitch))
                ui_set(ref.pitch[2], ui_get(builder[cheatmode][variables.changer_state].custompitch))
                ui_set(ref.yaw[1], '180')
            else
                ui_set(ref.pitch[1], ui_get(builder[cheatmode][variables.changer_state].pitch))
                ui_set(ref.pitch[2], ui_get(builder[cheatmode][variables.changer_state].custompitch))
            end

        if ui_get(builder[cheatmode][variables.changer_state].yaw_jitter) == 'Custom' then
            jittervalue = lpbodyyaw(ui_get(builder[cheatmode][variables.changer_state].yaw_jitter_left), ui_get(builder[cheatmode][variables.changer_state].yaw_jitter_right))
            ui_set(ref.yaw_jitter[1], ui_get(builder[cheatmode][variables.changer_state].yaw_jitter_lr_three))
            ui_set(ref.yaw_jitter[2], jittervalue)
        else
            jittervalue = ui_get(builder[cheatmode][variables.changer_state].yaw_jitter_add)
            ui_set(ref.yaw_jitter[1], ui_get(builder[cheatmode][variables.changer_state].yaw_jitter))
            ui_set(ref.yaw_jitter[2], ui_get(builder[cheatmode][variables.changer_state].yaw_jitter_add) ~= 'Off' and jittervalue or 0)
        end

        if body_yaw ~= 'Lullaby[Tick]' and body_yaw ~= 'Lullaby[Choke]' then
            ui_set(ref.body_yaw[1], ui_get(builder[cheatmode][variables.changer_state].body_yaw)) 
            ui_set(ref.body_yaw[2], variables.bodyyaw_value)
            ui_set(ref.freestanding_body_yaw, ui_get(builder[cheatmode][variables.player_state].freestanding_body_yaw))
        else
            if e.in_use == 1 or variables.legitaaon then 
                return
            end
    
            if disable_custom(e) then 
                if weapon == nil or weapon.type == "grenade" then 
                    ui_set(ref.body_yaw[1], 'Static') 
                    ui_set(ref.body_yaw[2], variables.bodyyaw_value)
                    ui_set(ref.freestanding_body_yaw, ui_get(builder[cheatmode][variables.player_state].freestanding_body_yaw))
                end
            else
                local aX = vector(entity.get_origin(entity_get_local_player()))
                local aY, aZ = client.camera_angles()
                local a_ = c_entity.new(client.current_threat())
                local b0 = aZ
                if client.current_threat() ~= nil then
                    if not a_:is_dormant() then
                        local b1 = vector(a_:get_origin())
                        _, b0 = aX:to(b1):angles()
                    end
                end
                local b3 = b0 + 180
                local yaw = b3
                local yawy = yaw + (variables.yaw_choke and (57 + ui_get(builder[cheatmode][variables.changer_state].fake_yaw_right)) or (-57 - ui_get(builder[cheatmode][variables.changer_state].fake_yaw_left)))
                e.allow_send_packet = false
                if e.chokedcommands == 0 then
                    e.yaw = yawy
                end
                --Yaw
                if contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Yaw') and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) and variables.aa_dir == 0 then
                    e.yaw = math.random(180, -180) + yaw
                    e.pitch = math.random(-89, 89)
                    if (contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Pitch')) and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) then
                        e.pitch = ui_get(builder[cheatmode][variables.changer_state].defensive_brute_pitch)
                    end
                end
                --Pitch
                if (contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Pitch')) and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) then
                    e.pitch = ui_get(builder[cheatmode][variables.changer_state].defensive_brute_pitch)
                    e.yaw = yawy
                    if contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Yaw') and (variables.defensive > ui_get(builder[cheatmode][variables.changer_state].defensive_brute_tick) and variables.defensive < 14) and variables.aa_dir == 0 then
                        e.yaw = ui_get(builder[cheatmode][variables.changer_state].defensive_brute_yaw) + yaw
                    end
                end
                --Height advantage Safe
                if contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Height advantage Safe') and variables.aa_dir == 0 and variables.player_state ~= 9 and threat and height_to_threat > ui_get(builder[cheatmode][variables.changer_state].advantage_l) then
                    e.yaw = yaw
                    e.pitch = 89
                end
                ui_set(ref.freestanding_body_yaw, ui_get(builder[cheatmode][variables.player_state].freestanding_body_yaw))
            end
        end
        
        if contains(builder[cheatmode][variables.changer_state].defensive_brute, 'Height advantage Safe') and variables.aa_dir == 0 and variables.player_state ~= 9 and threat and height_to_threat > ui_get(builder[cheatmode][variables.changer_state].advantage_l) then
            ui_set(ref.yaw[2], 0)
            ui_set(ref.yaw_jitter[1], 'Off')
            ui_set(ref.yaw_jitter[2], 0)
            ui_set(ref.body_yaw[1], 'Static')
            ui_set(ref.body_yaw[2], 0)
            ui_set(ref.freestanding_body_yaw, false)
        end
    end

end

local function handle_indicators()
    local local_player = entity_get_local_player()
    if not entity_is_alive(local_player) then
        return
    end

    local width, height = client_screen_size()
    local x = width / 2
    local y = height / 2
    if variables.aa_dir ~= 0 then
        renderer_text(x - 50 - 5, y, (variables.aa_dir == -90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == -90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == -90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == -90 and not variables.legitaaon) and 255 or 150, 'c+', nil, '◂')
        renderer_text(x + 50 + 5, y, (variables.aa_dir == 90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == 90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == 90 and not variables.legitaaon) and 255 or 100, (variables.aa_dir == 90 and not variables.legitaaon) and 255 or 150, 'c+', nil, '▸')
    end
    local text = text_fade_animation(2, 95, 98, 155, 255, 'L u l l a b y')
    --renderer_text(x / 10, y, 255, 255, 255, 255,'cb', nil, text)
    local main = text_fade_animation(3, 95, 98, 155, 255, 'Lullaby')
    --renderer_text(x, y + 20, 255, 255, 255, 255, 'cb', nil, main)
end

local function leg_breaker(cmd)
    ui_set(ref.leg_movement, cmd.command_number % 3 == 0 and 'Always slide' or 'Never slide')
end

--//set_og_menu

local function set_og_menu(state)
    local ui_elements = {
        ref.pitch[1],
        ref.pitch[2],
        ref.yaw_base,
        ref.yaw[1],
        ref.yaw[2],
        ref.yaw_jitter[1],
        ref.yaw_jitter[2],
        ref.body_yaw[1],
        ref.body_yaw[2],
        ref.freestanding_body_yaw,
        ref.freestanding[1],
        ref.freestanding[2],
        ref.edge_yaw,
        ref.roll
    }
    for _, ui_element in ipairs(ui_elements) do
        ui_set_visible(ui_element, state)
    end
end

--//callback
local callbacks = {
    paint_ui = function()
        set_og_menu(false)
        defensivepitch()
        handle_menu()
        animationtext()
    end,
    paint = function()
        handle_indicators()
    end,
    setup_command = function(e)
        weapon = csgo_weapons[entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex")]
        handle_menu()
        aa_on_use(e)
        player_condition_main(e)
        
        --obex issue
        handle_main_antiaim(e)

        leg_breaker(e)
        check_sway_stage(e)
        if ui_get(force_def) then
            e.force_defensive = 1
        end
        if weapon == nil or weapon.type == "grenade" then 
            e.force_defensive = 0
        end
    end,
    shutdown = function()
        set_og_menu(true)
    end,
    game_newmap = function()
        variables.checker = 0
        variables.defensive = 0
        variables.yaw_tick = 0
    end,
    cs_game_disconnected = function()
        variables.checker = 0
        variables.defensive = 0
        variables.yaw_tick = 0
    end,
    client_disconnect = function()
        variables.checker = 0
        variables.defensive = 0
        variables.yaw_tick = 0
    end,
    round_start = function()
        variables.checker = 0
        variables.defensive = 0
        variables.yaw_tick = 0
        variables.aa_dir = 0
    end,
    player_death = function(e)
        if client_userid_to_entindex(e.userid) == entity_get_local_player() then
            variables.checker = 0
            variables.defensive = 0
            variables.yaw_tick = 0
        end
    end,
}

for event, callback in pairs(callbacks) do
    client_set_event_callback(event, callback)
end

local function final()
    for key, value in pairs(gui_handler.call) do
        ui_set_callback(value.ref, handle_menu)
    end
end

final()

