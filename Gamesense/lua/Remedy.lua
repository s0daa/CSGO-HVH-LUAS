
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local find_material = materialsystem.find_material
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error




local lib = {
    ['gamesense/antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665',
    ['gamesense/base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619',
    ['gamesense/clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678',
    ['gamesense/http'] = 'https://gamesense.pub/forums/viewtopic.php?id=19253',
    ['gamesense/surface'] = 'https://gamesense.pub/forums/viewtopic.php?id=18793',
    ['gamesense/images'] = "https://gamesense.pub/forums/viewtopic.php?id=22917",
    ['gamesense/easing'] = 'https://gamesense.pub/forums/viewtopic.php?id=22920'

}
local lib_notsub = { }

for i, v in pairs(lib) do
    if not pcall(require, i) then
        lib_notsub[#lib_notsub + 1] = lib[i]
    end
end

for i=1, #lib_notsub do
    error("pls sub the API \n" .. table.concat(lib_notsub, ", \n"))
end

local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
--local http = require('gamesense/http')
local surface = require('gamesense/surface')
local images = require('gamesense/images')
local easing = require "gamesense/easing"
local md5 = require "gamesense/md5"

local ffi = require("ffi")
local bit = require("bit")
local vector = require("vector")
local websockets = require "gamesense/websockets"

local js = panorama.open()

local antiaim = {
    enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    yaw_jitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") } ,
    body_yaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    roll =  ui_reference("AA", "Anti-aimbot angles", "Roll") ,

    slow_motion = { ui_reference("AA", "Other", "Slow motion") },
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    hide_shots = { ui_reference("AA", "Other", "On shot anti-aim") },
    fake_peek = { ui_reference("AA", "Other", "Fake peek") },
    fake_lag = ui_reference("AA", "Fake lag", "Enabled") ,
    fake_lag_limit = ui_reference("AA", "Fake lag", "Limit") ,
    anti_untrusted = ui.reference("MISC", "Settings", "Anti-untrusted"),

    fakeduck = ui.reference("Rage", "Other", "Duck peek assist"),

    doubletap = {ui_reference("RAGE","Aimbot","Double tap")},
    force_body_aim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    force_safe_point = ui.reference("RAGE", "Aimbot", "Force safe point"),
    ping_spike = {ui_reference("MISC", "miscellaneous", "ping spike")},

    quick_peek_assist = { ui.reference("RAGE", "Other", "Quick peek assist") },
}
local status = {
    build = "beta",
    last_updatetime = "01.01.2024",
    username = username,
}

local check_roll = false

local main = {}
local gui = {}
local funcs = {}
local render = {}
local g_antiaim = {}

funcs.misc = {}

function funcs.misc:lua_msg(msg)
    client_color_log(192,138,138,'[Remedy] '..msg)
end

function funcs.misc:lua_msg_banned(msg)
    client_color_log(255,0,0,'[Remedy] '..msg)
end

funcs.ui = {}

function funcs.ui:str_to_sub(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", "")
    end
    return t
end


function funcs.ui:arr_to_string(arr)
	arr = ui_get(arr)
	local str = ""
	for i=1, #arr do
		str = str .. arr[i] .. (i == #arr and "" or ",")
	end

	if str == "" then
		str = "-"
	end

	return str
end


function funcs.ui:to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

function funcs.ui:table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

funcs.math = {}

funcs.aa = {}


function main:ui(register,need_export,... )
    local number_ = register
    if type(number_) == 'number' then
        table.insert(gui.callback,number_)
    end

    if need_export then
        if type(number_) == 'number' then
            table.insert(gui.export[type(ui.get(number_))],number_)
        end
    end

    return number_
end

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end
gui.callback = {}
gui.export = {
    ['number'] = {},
    ['boolean'] = {},
    ['table'] = {},
    ['string'] = {}
}
gui.tab = {
    "LUA","B","AA","Anti-aimbot angles"
}

local menu1,menu2,menu3,menu4 = "646464FF","646464FF","646464FF","646464FF"
local _state = {"Stand","Move","Slow walk","Duck","Air","Air + D"}
local __state = {"\aC08A8AFF[ST]\aFFFFFFC8","\aC08A8AFF[M]\aFFFFFFC8","\aC08A8AFF[SW]\aFFFFFFC8","\aC08A8AFF[D]\aFFFFFFC8","\aC08A8AFF[A]\aFFFFFFC8","\aC08A8AFF[AD]\aFFFFFFC8"}

lua_color = {r = 222, g = 55, b = 55}
info = {
    username = "remedy.rip",
    build = "VIP",
  }
gui.menu = {
    spacing = main:ui(ui.new_label(gui.tab[1],gui.tab[2],"  "),false),
    info_user = main:ui(ui.new_label(gui.tab[1],gui.tab[2],"\aFFFFFFB2Welcome back, â”€ \aC08A8AFF"..tostring(info.username)),false),
    info_3_ = main:ui(ui.new_label(gui.tab[1],gui.tab[2],"\aFFFFFFB2Latest build â”€ \aC08A8AFF"..tostring(info.build)),false),
    info_4_ = main:ui(ui.new_label(gui.tab[1],gui.tab[2],"\aFFFFFFB2Last update time â”€ \aC08A8AFF"..status.last_updatetime),false),
    master_swtich = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"\aC08A8AFF Remedy.rip"),true),
    main_list = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"\aC08A8AFF[â›¥] \aFFFFFFFFMain feature list",
    "\a"..menu1.."\aC08A8AFF Indicators","\a"..menu2.."\aC08A8AFF Presets","\a"..menu3.."\aC08A8AFF Extra Settings","\a"..menu4.."\aC08A8AFF Misc Features","\a707070E6 -"),true),
    presets = main:ui(ui_new_combobox(gui.tab[1],gui.tab[2],"[-] Presets manager",{"\aFFFFFFB2VIP","Custom"}),true),
    preset_static = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"Presets suppress jitter select","\aFFFFFFFF Stand","\aFFFFFFFF Move","\aFFFFFFFF Slow walk","\aFFFFFFFF Duck","\aFFFFFFFF Air"),true),
    indicator_settings = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"\aC08A8AFF[~]\aFFFFFFC8 Indicator settings","\aFFFFFFFF Manual arrows","\aFFFFFFFF Center indicator","\aFFFFFFFF Watermark","\aFFFFFFFF Menu effect"),true),

    indicator_color = main:ui(ui_new_color_picker(gui.tab[1],gui.tab[2],"Mainc",192,138,138,255),true),
    watermark_color = main:ui(ui_new_color_picker(gui.tab[1],gui.tab[2],"watermark",192,138,138,255),true),
    center_mode = main:ui(ui_new_combobox(gui.tab[1],gui.tab[2],"[-] Center mode",{"Text","Icon"}),true),
    manualarrow_size = main:ui(ui_new_combobox(gui.tab[1],gui.tab[2],"[-] Arrow mode",{"+","-"}),true),
    manualarrow_back = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"Background shadow"),true),
    manualarrow_distance = main:ui(ui_new_slider(gui.tab[1],gui.tab[2],"Arrow distance",0,100,15,true,"*"),true),
    antiaim_settings = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"\aC08A8AFF[~]\aFFFFFFC8 Extra settings","\aFFFFFFFF Manual antiaim","\aFFFFFFFF Antiaim on use","\aFFFFFFFF Edge yaw","\aFFFFFFFF Freestanding","\aFFFFFFFF Roll"),true),
    forceroll_states = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"[-] Roll states","\aFFFFFFFF Stand","\aFFFFFFFF Move","\aFFFFFFFF Slow walk","\aFFFFFFFF Duck","\aFFFFFFFF Air","\aFFFFFFFF Use","\aFFFFFFFF Manual"),true),
    roll_key = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"[-] Roll states",0),false),
    roll_selects = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"[-] Extra roll options",{"\aF8F884D1 Match making","\aF8F884D1 Jitter","\aF8F884D1 Disable roll when peeking","\aFA3F3FFF Unsafe roll"})),
    roll_inverter = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Inverter"),false),
    disable_use = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"Disable use to plant"),true),
    static_onuse = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"Force static on use"),true),
    prevent_jitter = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"Prevent sideways jitter"),true),
    manual_left = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Manual left"),false),
    manual_right = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Manual right"),false),
    manual_reset = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Reset"),false),
    edge_yaw_key = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Edge yaw"),false),
    freestanding_key = main:ui(ui_new_hotkey(gui.tab[1],gui.tab[2],"Freestanding"),false),
    misc_settings = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"\aC08A8AFF[~]\aFFFFFFC8 Misc settings","\aFFFFFFFF Anti knife","\aFFFFFFFF Animation breaker","\aFFFFFFFF Trash talk","\aFFFFFFFF Clantag"),true),
    pitch0_onknife = main:ui(ui_new_checkbox(gui.tab[1],gui.tab[2],"Reset pitch on knife"),true),
    knife_distance = main:ui(ui_new_slider(gui.tab[1],gui.tab[2],"Anti knife radius",0,1000,280,true,"u"),true),
    anim_list = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"Break anims","In air","On land","Leg fucker"),true),
    states_selection = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],"Condition selection",_state),true),

    fake_lag_limit_d = main:ui(ui_new_slider(gui.tab[3],"Fake lag","Limit",1,15,14),true),

    temp_manual = main:ui(ui_new_slider(gui.tab[3],"Fake lag","TEMP_STATE",0,3,0),true),

    
}


gui.menu.custom = {}
for k, v in pairs(_state) do
    gui.menu.custom[k] = {
        enable = main:ui(ui_new_checkbox(gui.tab[3],gui.tab[4],"Enable ".._state[k].. " setting"),true),
        extra_options = main:ui(ui_new_multiselect(gui.tab[3],gui.tab[4],__state[k].." Extra options","Suppress jitter when choking commands","-"),true),
        yaw_mode = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],__state[k].." Yaw mode built-in funcs",{"Static","Period jitter \aC08A8AFF[Tick]","Period jitter \aC08A8AFF[Choke]","Period jitter \aC08A8AFF[Desync]","Period jitter \aC08A8AFF[Desync 2]"}),true),
        static_yaw = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier",-90,90,0,true,"Â°"),true),
        tick_yaw_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier left \aC08A8AFF[Tick]",-90,90,0,true,"Â°"),true),
        tick_yaw_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier right \aC08A8AFF[Tick]",-90,90,0,true,"Â°"),true),
        choke_yaw_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier left \aC08A8AFF[Choke]",-90,90,0,true,"Â°"),true),
        choke_yaw_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier right \aC08A8AFF[Choke]",-90,90,0,true,"Â°"),true),
        desync_yaw_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier left \aC08A8AFF[Desync]",-90,90,0,true,"Â°"),true),
        desync_yaw_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier right \aC08A8AFF[Desync]",-90,90,0,true,"Â°"),true),
        desync_yaw_left_2 = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier left \aC08A8AFF[Desync 2]",-90,90,0,true,"Â°"),true),
        desync_yaw_right_2 = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Yaw modifier right \aC08A8AFF[Desync 2]",-90,90,0,true,"Â°"),true),
        yaw_jitter = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],__state[k].." Native yaw mode",{ "Off", "Offset", "Center", "Random" }),true),
        yaw_jitter_degree = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Native yaw jitter degree",0,120,0,true,"Â°"),true),
        self_bodyyaw_mode = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],__state[k].." Native body yaw mode",{ "Off", "Opposite", "Jitter", "Static"  }),true),
        bodyyaw_mode = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],__state[k].." Body yaw mode built-in funcs",{"Static","Period jitter","Recursion"}),true),
        bodyyaw_degree = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Body yaw modifier",-180,180,0,true,"Â°"),true),
        jitter_bodyyaw_degree_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Body yaw modifier left \aC08A8AFF[Period]",-180,180,0,true,"Â°"),true),
        jitter_bodyyaw_degree_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Body yaw modifier right \aC08A8AFF[Period]",-180,180,0,true,"Â°"),true),
        body_yaw_step_ticks = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Recursion ticks ",0,15,1,true,"'"),true),
        body_yaw_step_value = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Recursion value",0,180,5,true,"Â°"),true),
        step_bodyyaw_degree_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Body yaw modifier min \aC08A8AFF[Recursion]",-180,180,0,true,"Â°"),true),
        step_bodyyaw_degree_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Body yaw modifier max \aC08A8AFF[Recursion]",-180,180,0,true,"Â°"),true),
        fake_yaw_mode = main:ui(ui_new_combobox(gui.tab[3],gui.tab[4],__state[k].." Desync modifier mode built-in funcs",{"Static","Period tick jitter","Progressively increase"}),true),
        static_fakeyaw = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Fake yaw limit",0,60,58,true,"Â°"),true),
        jitter_fakeyaw_left = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Fake yaw limit left \aC08A8AFF[Period]",0,60,30,true,"Â°"),true),
        jitter_fakeyaw_right = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Fake yaw limit right \aC08A8AFF[Period]",0,60,30,true,"Â°"),true),
        step_ticks = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Progressive ticks",0,15,7,true,"'"),true),
        step_value = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Progressive value",0,60,5,true,"Â°"),true),
        step_abs = main:ui(ui_new_checkbox(gui.tab[3],gui.tab[4],__state[k].." Increment absolute value"),true),
        step_fake_min = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Fake yaw limit - \aC08A8AFFmin",0,60,58,true,"Â°"),true),
        step_fake_max = main:ui(ui_new_slider(gui.tab[3],gui.tab[4],__state[k].." Fake yaw limit - \aC08A8AFFmax",0,60,58,true,"Â°"),true),
        freestanding_bodyyaw = main:ui(ui_new_checkbox(gui.tab[3],gui.tab[4],__state[k].." Freestanding bodyyaw"),true)
    }
end

g_antiaim.save_antiaims = {
    pitch = "Off",
    yaw_base = "Local view",
    yaw_1 = "Off",
    yaw_2 = 0,
    yaw_jitter_1 = "Off",
    yaw_jitter_2 = 0,
    body_yaw_1 = "Off",
    body_yaw_2 = 0,
    freestanding_body_yaw = false
}

function g_antiaim:og_menu(state)
    ui_set_visible(antiaim.pitch, state)
    ui_set_visible(antiaim.yaw_base, state)
    ui_set_visible(antiaim.yaw[1], state)
    ui_set_visible(antiaim.yaw[2], state)
    ui_set_visible(antiaim.yaw_jitter[1], state)
    ui_set_visible(antiaim.yaw_jitter[2], state)
    ui_set_visible(antiaim.body_yaw[1], state)
    ui_set_visible(antiaim.body_yaw[2], state)
    ui_set_visible(antiaim.freestanding_body_yaw, state)
    ui_set_visible(antiaim.edge_yaw, state)
    ui_set_visible(antiaim.freestanding[1], state)
    ui_set_visible(antiaim.freestanding[2], state)
    ui_set_visible(antiaim.roll, state)
end


g_antiaim.c_var = {
    c = 1,
    ground_ticks = 0,
    step_ticks = 0,
    min = 0,
    max = 0,
    step = 0,
    return_value = 0,
    bodystep_ticks = 0,
    bodystep_min = 0,
    bodystep_max = 0,
    bodystep_step = 0,
    bodystep_return_value = 0
}

g_antiaim.jitter = {}
g_antiaim.jitter.c_var = {
    choke = 0,
    yaw_v = 0,
    yaw_r = 1,
    byaw_v = 0,
    byaw_r = 1,
    fyaw_v = 0,
    fyaw_r = 0
}

function g_antiaim.jitter:tick(a,b)
    return globals_tickcount() % 4 >= 2 and a or b
end

function g_antiaim.jitter:choke_yaw(a,b)
    if globals_tickcount() - self.c_var.yaw_v > 1  and self.c_var.choke == 1 then
        self.c_var.yaw_r = self.c_var.yaw_r == 1 and 0 or 1
        self.c_var.yaw_v = globals_tickcount()
    end
    local inverted = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

    return self.c_var.yaw_r >= 1 and a or b
end

function g_antiaim.jitter:normalize_yaw(p)
    while p > 180 do
        p = p - 360
    end
    while p < -180 do
        p = p + 360
    end
    return p
end

function g_antiaim.jitter:choke_body_yaw(a,b)
    local inverted = self:normalize_yaw( antiaim_funcs.get_body_yaw(1) - antiaim_funcs.get_abs_yaw() ) > 0
    local invert = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

    if ui_get(antiaim.body_yaw[1]) == "Jitter" then
        return inverted and a or b
    elseif ui_get(antiaim.body_yaw[1]) == "Static" then
        return invert and a or b
    end

end

function g_antiaim.jitter:choke_fake(a,b)
    if globals_tickcount() - self.c_var.fyaw_v > 1  and self.c_var.choke == 1 then
        self.c_var.fyaw_r = self.c_var.fyaw_r == 1 and 0 or 1
        self.c_var.fyaw_v = globals_tickcount()
    end
    local inverted = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

    return self.c_var.fyaw_r >= 1 and a or b
end

local start_time = globals_curtime()

local function get_tick()
    local end_time = globals_curtime()
    local get_time = math_abs(math_floor((start_time - end_time) * 100)) % 2
    return get_time
end

function g_antiaim.jitter:desync(a,b)
    local inverted = self:normalize_yaw( antiaim_funcs.get_body_yaw(1) - antiaim_funcs.get_abs_yaw() ) > 0
    local invert = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

    if ui_get(antiaim.body_yaw[1]) == "Jitter" then
        return inverted and a or b
    elseif ui_get(antiaim.body_yaw[1]) == "Static" then
        return invert and a or b
    else 
        return a
    end
end

function g_antiaim.jitter:desync_2(v,c)

    local get_desync = math_floor(antiaim_funcs.get_desync(1))
    local lp_bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (60 * 2) - 60 > 0

    local FKLMNWAMGBA = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (60 * 2) - 60)))) > 0
    return FKLMNWAMGBA and v or c
end

function g_antiaim:clamp(num, min, max)
    if num < min then
        num = min
    elseif num > max then
        num = max
    end
    return num
end


function g_antiaim:doubletap_charged()
    if not ui.get(antiaim.doubletap[1]) or not ui.get(antiaim.doubletap[2])  then
        return false
    end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
        return
    end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then
        return false
    end

    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
    local jewfag = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if jewfag == nil then
        return
    end
    local next_primary_attack = jewfag + 0.5
    if next_attack == nil or next_primary_attack == nil then
        return false
    end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end


function g_antiaim:run_custom(cmd)
    if entity_get_local_player() == nil then
        return
    end
    local p_duck = entity_get_prop(entity_get_local_player(), "m_flDuckAmount")
    local inair = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags" ), 1 ) == 0 and cmd.in_jump
    local on_ground = bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) 
    local vx, vy, vz = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
    local p_still = math_sqrt(vx ^ 2 + vy ^ 2)
    local p_slow = ui_get(antiaim.slow_motion[1]) and ui_get(antiaim.slow_motion[2])

    self.jitter.c_var.choke = cmd.chokedcommands
    local m = gui.menu.custom
    self.save_antiaims.yaw_1 = "180"

    if on_ground == 1 then
        self.c_var.ground_ticks = self.c_var.ground_ticks + 1
    else
        self.c_var.ground_ticks = 0
    end
    if ui_get(m[3].enable) and p_slow then
        self.c_var.c = 3
    elseif inair and p_duck > 0.8 and cmd.in_jump and ui_get(m[6].enable) then
        self.c_var.c = 6
    elseif inair and cmd.in_jump and ui_get(m[5].enable) then
        self.c_var.c = 5
    elseif p_duck > 0.8 and not inair and self.c_var.ground_ticks > 8 and ui_get(m[4].enable)  then
        self.c_var.c = 4
    elseif p_still > 70 and self.c_var.ground_ticks > 8  and ui_get(m[2].enable) then
        self.c_var.c = 2
    elseif p_still < 2 and  self.c_var.ground_ticks > 8  and ui_get(m[1].enable) then
        self.c_var.c = 1
    else
        self.c_var.c = 6
    end
    self.save_antiaims.yaw_base = "At targets"
    self.save_antiaims.yaw_1 = "180"
    self.save_antiaims.pitch = "Remedy"

    if self.c_var.c == 1 and funcs.ui:table_contains(ui_get(m[1].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 0
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif self.c_var.c == 2 and funcs.ui:table_contains(ui_get(m[2].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 0
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif self.c_var.c == 3 and funcs.ui:table_contains(ui_get(m[3].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 24 
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif self.c_var.c == 4 and funcs.ui:table_contains(ui_get(m[4].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 35 
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif self.c_var.c == 5 and funcs.ui:table_contains(ui_get(m[5].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 15
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif self.c_var.c == 6 and funcs.ui:table_contains(ui_get(m[6].extra_options),"Suppress jitter when choking commands") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 15
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    else
        
    
    

        self.c_var.max = ui_get(m[self.c_var.c].step_fake_max)
        self.c_var.min = ui_get(m[self.c_var.c].step_fake_min)
        self.c_var.step = ui_get(m[self.c_var.c].step_value)
        self.c_var.step_ticks = globals_tickcount() % ui_get(m[self.c_var.c].step_ticks)

        if ui_get(m[self.c_var.c].step_fake_min) >= ui_get(m[self.c_var.c].step_fake_max) then
            ui_set(m[self.c_var.c].step_fake_min,ui_get(m[self.c_var.c].step_fake_max))
        end

        if self.c_var.step_ticks == ui_get(m[self.c_var.c].step_ticks) - 1 then
            if self.c_var.return_value < self.c_var.max then
                self.c_var.return_value = self.c_var.return_value + ui_get(m[self.c_var.c].step_value)
            elseif self.c_var.return_value >= self.c_var.max then
                self.c_var.return_value = self.c_var.min
            end
        end

        self.c_var.bodystep_max = ui_get(m[self.c_var.c].step_bodyyaw_degree_right)
        self.c_var.bodystep_min = ui_get(m[self.c_var.c].step_bodyyaw_degree_left)
        self.c_var.bodystep_step = ui_get(m[self.c_var.c].body_yaw_step_value)
        self.c_var.bodystep_ticks = globals_tickcount() % ui_get(m[self.c_var.c].body_yaw_step_ticks)

        if ui_get(m[self.c_var.c].step_bodyyaw_degree_left) >= ui_get(m[self.c_var.c].step_bodyyaw_degree_right) then
            ui_set(m[self.c_var.c].step_bodyyaw_degree_left,ui_get(m[self.c_var.c].step_bodyyaw_degree_right))
        end
        if self.c_var.bodystep_ticks == ui_get(m[self.c_var.c].body_yaw_step_ticks) - 1 then
            if self.c_var.bodystep_return_value < self.c_var.bodystep_max then
                self.c_var.bodystep_return_value = self.c_var.bodystep_return_value + self.c_var.bodystep_step
            elseif self.c_var.bodystep_return_value >= self.c_var.bodystep_max then
                self.c_var.bodystep_return_value = self.c_var.bodystep_min
            end
        end


        -- {"Static","Period jitter \aC08A8AFF[Tick]","Period jitter \aC08A8AFF[Choke]","Period jitter \aC08A8AFF[Desync]"}
        if ui_get(m[self.c_var.c].yaw_mode) == "Static" then
            self.save_antiaims.yaw_2 = ui_get(m[self.c_var.c].static_yaw)
        elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Tick]" then
            self.save_antiaims.yaw_2 = self.jitter:tick(ui_get(m[self.c_var.c].tick_yaw_left),ui_get(m[self.c_var.c].tick_yaw_right))
        elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Choke]" then
            self.save_antiaims.yaw_2 = self.jitter:choke_yaw(ui_get(m[self.c_var.c].choke_yaw_left),ui_get(m[self.c_var.c].choke_yaw_right))
        elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync]" then
            self.save_antiaims.yaw_2 = self.jitter:desync(ui_get(m[self.c_var.c].desync_yaw_left),ui_get(m[self.c_var.c].desync_yaw_right))
        elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync 2]" then
            self.save_antiaims.yaw_2 = self.jitter:desync_2(ui_get(m[self.c_var.c].desync_yaw_left_2),ui_get(m[self.c_var.c].desync_yaw_right_2))

        end


        self.save_antiaims.yaw_jitter_1 = ui_get(m[self.c_var.c].yaw_jitter)
        self.save_antiaims.yaw_jitter_2 = ui_get(m[self.c_var.c].yaw_jitter_degree)
        self.save_antiaims.body_yaw_1 = ui_get(m[self.c_var.c].self_bodyyaw_mode)

        if ui_get(m[self.c_var.c].bodyyaw_mode) == "Static" then
            self.save_antiaims.body_yaw_2 = ui_get(m[self.c_var.c].bodyyaw_degree)
        elseif ui_get(m[self.c_var.c].bodyyaw_mode) == "Period jitter" then
            if ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync]" then
                self.save_antiaims.body_yaw_2 = self.jitter:desync(ui_get(m[self.c_var.c].jitter_bodyyaw_degree_left) ,  ui_get(m[self.c_var.c].jitter_bodyyaw_degree_right)) 
            elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync 2]" then
                self.save_antiaims.body_yaw_2 = self.jitter:desync_2(ui_get(m[self.c_var.c].jitter_bodyyaw_degree_left) ,  ui_get(m[self.c_var.c].jitter_bodyyaw_degree_right)) 
            else
                self.save_antiaims.body_yaw_2 = self.jitter:choke_body_yaw(ui_get(m[self.c_var.c].jitter_bodyyaw_degree_left) ,  ui_get(m[self.c_var.c].jitter_bodyyaw_degree_right)) 
            end
        elseif ui_get(m[self.c_var.c].bodyyaw_mode) == "Recursion" then
            self.save_antiaims.body_yaw_2 = self:clamp(self.c_var.bodystep_return_value,self.c_var.bodystep_min,self.c_var.bodystep_max)
        end

        -- {"Static","Period tick jitter","Progressively increase"}
        if ui_get(m[self.c_var.c].fake_yaw_mode) == "Static" then
            self.save_antiaims.fake_yaw_limit = ui_get(m[self.c_var.c].static_fakeyaw)
        elseif ui_get(m[self.c_var.c].fake_yaw_mode) == "Period tick jitter" then
            if ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync]" then
                self.save_antiaims.fake_yaw_limit = self.jitter:desync(ui_get(m[self.c_var.c].jitter_fakeyaw_left),ui_get(m[self.c_var.c].jitter_fakeyaw_right))
            elseif ui_get(m[self.c_var.c].yaw_mode) == "Period jitter \aC08A8AFF[Desync 2]" then
                self.save_antiaims.fake_yaw_limit = self.jitter:desync_2(ui_get(m[self.c_var.c].jitter_fakeyaw_left),ui_get(m[self.c_var.c].jitter_fakeyaw_right))
            else
                self.save_antiaims.fake_yaw_limit = self.jitter:choke_fake(ui_get(m[self.c_var.c].jitter_fakeyaw_left),ui_get(m[self.c_var.c].jitter_fakeyaw_right))
            end

        elseif ui_get(m[self.c_var.c].fake_yaw_mode) == "Progressively increase" then
            if ui_get(m[self.c_var.c].step_abs) then
                self.save_antiaims.fake_yaw_limit = math_abs(self:clamp(self.c_var.return_value,self.c_var.min,self.c_var.max))
            else
                self.save_antiaims.fake_yaw_limit = self:clamp(self.c_var.return_value,self.c_var.min,self.c_var.max)
            end
        end
        self.save_antiaims.freestanding_body_yaw = ui_get(m[self.c_var.c].freestanding_bodyyaw)
    end

    self:og_menu(false)

end

local presets_ticks = 0
function g_antiaim:run_presets_states(cmd)
    local p_duck = entity.get_prop(entity.get_local_player(), "m_flDuckAmount")
    local inair = bit.band( entity.get_prop( entity.get_local_player( ), "m_fFlags" ), 1 ) == 0 
    local on_ground = bit.band(entity.get_prop( entity.get_local_player( ), "m_fFlags"), 1) 
    local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local p_still = math.sqrt(vx ^ 2 + vy ^ 2)
    local p_slow = ui.get(antiaim.slow_motion[1]) and ui.get(antiaim.slow_motion[2])
    if on_ground == 1 then
        presets_ticks = presets_ticks + 1
    else 
        presets_ticks = 0
    end

    if client.key_state(0x45) then
        return 7
    elseif self.direction.c_var.saved_dir ~= 0 then
        return 6
    elseif inair  then
        return 5
    elseif p_slow and presets_ticks > 8 then
        return 4
    elseif p_duck > 0.8 and presets_ticks > 8 then
        return 3
    elseif p_still > 5 and presets_ticks > 8 then
        return 2
    elseif p_still < 2 and presets_ticks > 8 then
        return 1
    else 
        return 5
    end


end

local presets_vars = {
    --stand 
    st_min = 0,
    st_max = 0,
    st_step = 0,
    st_stepticks = 0,
    st_return_values =0,
    st_min_desync = 0,
    st_max_desync = 0,
    st_step_desync = 0,
    st_stepticks_desync = 0,
    st_return_values_desync =0,
    --move
    m_min_desync = 0,
    m_max_desync = 0,
    m_step_desync = 0,
    m_stepticks_desync = 0,
    m_return_values_desync =0,    
}

function g_antiaim:run_presets_1(cmd)
    local states = self:run_presets_states(cmd)

    self.save_antiaims.yaw_base = "At targets"
    self.save_antiaims.yaw_1 = "180"
    self.save_antiaims.pitch = "Remedy"
    if states == 1 and funcs.ui:table_contains(ui_get(gui.menu.preset_static),"\aFFFFFFFF Stand") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 0
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif states == 1 then
        self.save_antiaims.yaw_2 = self.jitter:desync(18,28)
        self.save_antiaims.yaw_jitter_1 = "Center"
        self.save_antiaims.yaw_jitter_2 = 67
        self.save_antiaims.body_yaw_1 = "Static"
        presets_vars.st_max = 180
        presets_vars.st_min = 90
        presets_vars.st_step = 1
        presets_vars.st_stepticks = globals_tickcount() % 1
        if presets_vars.st_stepticks == 1 - 1 then
            if presets_vars.st_return_values < presets_vars.st_max then
                presets_vars.st_return_values = presets_vars.st_return_values + 1
            elseif presets_vars.st_return_values >= presets_vars.st_max  then
                presets_vars.st_return_values = presets_vars.st_min
            end
        end
        self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
        presets_vars.st_max_desync = 60
        presets_vars.st_min_desync = 20
        presets_vars.st_step_desync = 5
        presets_vars.st_stepticks_desync = globals_tickcount() % 3
        if presets_vars.st_stepticks_desync == 1 - 1 then
            if presets_vars.st_return_values_desync < presets_vars.st_max_desync then
                presets_vars.st_return_values_desync = presets_vars.st_return_values_desync + 1
            elseif presets_vars.st_return_values_desync >= presets_vars.st_max_desync  then
                presets_vars.st_return_values_desync = presets_vars.st_min_desync
            end
        end
        self.save_antiaims.fake_yaw_limit = self:clamp(presets_vars.st_return_values_desync,presets_vars.st_min_desync,presets_vars.st_max_desync)
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 2 and funcs.ui:table_contains(ui_get(gui.menu.preset_static),"\aFFFFFFFF Move") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 0
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif states == 2 then
        self.save_antiaims.yaw_2 = self.jitter:desync(10,-5)
        self.save_antiaims.yaw_jitter_1 = "Center"
        self.save_antiaims.yaw_jitter_2 = 70
        self.save_antiaims.body_yaw_1 = "Jitter"
        self.save_antiaims.body_yaw_2 = 0
        presets_vars.m_max_desync = 60
        presets_vars.m_min_desync = 30
        presets_vars.m_step_desync = 5
        presets_vars.m_stepticks_desync = globals_tickcount() % 2
        if presets_vars.m_stepticks_desync == 1 - 1 then
            if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
            elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                presets_vars.m_return_values_desync = presets_vars.m_min_desync
            end
        end
        self.save_antiaims.fake_yaw_limit = self:clamp(presets_vars.m_return_values_desync,presets_vars.m_min_desync,presets_vars.m_max_desync)
        self.save_antiaims.freestanding_body_yaw = false
    end



    if states == 3 and funcs.ui:table_contains(ui_get(gui.menu.preset_static),"\aFFFFFFFF Duck") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 24 
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif states == 3 then 
        self.save_antiaims.yaw_2 = self.jitter:desync(35,-10)
        self.save_antiaims.yaw_jitter_1 = "Center"
        self.save_antiaims.yaw_jitter_2 = 25
        self.save_antiaims.body_yaw_1 = "Jitter"
        self.save_antiaims.body_yaw_2 = 0
        presets_vars.m_max_desync = 60
        presets_vars.m_min_desync = 30
        presets_vars.m_step_desync = 5
        presets_vars.m_stepticks_desync = globals_tickcount() % 2
        if presets_vars.m_stepticks_desync == 1 - 1 then
            if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
            elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                presets_vars.m_return_values_desync = presets_vars.m_min_desync
            end
        end
        self.save_antiaims.fake_yaw_limit = self:clamp(presets_vars.m_return_values_desync,presets_vars.m_min_desync,presets_vars.m_max_desync)
        self.save_antiaims.freestanding_body_yaw = false
    end


    if states == 4 and funcs.ui:table_contains(ui_get(gui.menu.preset_static),"\aFFFFFFFF Slow walk") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 35 
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif states == 4 then 
        self.save_antiaims.yaw_2 = self.jitter:desync(30,10)
        self.save_antiaims.yaw_jitter_1 = "Center"
        self.save_antiaims.yaw_jitter_2 = 41
        self.save_antiaims.body_yaw_1 = "Static"
        presets_vars.st_max = 180
        presets_vars.st_min = 90
        presets_vars.st_step = 1
        presets_vars.st_stepticks = globals_tickcount() % 1
        if presets_vars.st_stepticks == 1 - 1 then
            if presets_vars.st_return_values < presets_vars.st_max then
                presets_vars.st_return_values = presets_vars.st_return_values + 1
            elseif presets_vars.st_return_values >= presets_vars.st_max  then
                presets_vars.st_return_values = presets_vars.st_min
            end
        end
        self.save_antiaims.body_yaw_2 = self:clamp(presets_vars.st_return_values,presets_vars.st_min,presets_vars.st_max)
        presets_vars.m_max_desync = 60
        presets_vars.m_min_desync = 30
        presets_vars.m_step_desync = 1
        presets_vars.m_stepticks_desync = globals_tickcount() % 1
        if presets_vars.m_stepticks_desync == 1 - 1 then
            if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
            elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                presets_vars.m_return_values_desync = presets_vars.m_min_desync
            end
        end
        self.save_antiaims.fake_yaw_limit = self:clamp(presets_vars.m_return_values_desync,presets_vars.m_min_desync,presets_vars.m_max_desync)
        self.save_antiaims.freestanding_body_yaw = false
    end


    if states == 5 and funcs.ui:table_contains(ui_get(gui.menu.preset_static),"\aFFFFFFFF Air") == true and not (ui.get(antiaim.doubletap[1]) and ui.get(antiaim.doubletap[2])) and not (ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2])) then
        self.save_antiaims.yaw_2 = 15
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    elseif states == 5 then
        self.save_antiaims.yaw_2 = self.jitter:desync(20,6)
        self.save_antiaims.yaw_jitter_1 = "Center"
        self.save_antiaims.yaw_jitter_2 = 66
        self.save_antiaims.body_yaw_1 = "Jitter"
        self.save_antiaims.body_yaw_2 = 0
        presets_vars.m_max_desync = 60
        presets_vars.m_min_desync = 30
        presets_vars.m_step_desync = 1
        presets_vars.m_stepticks_desync = globals_tickcount() % 1
        if presets_vars.m_stepticks_desync == 1 - 1 then
            if presets_vars.m_return_values_desync < presets_vars.m_max_desync then
                presets_vars.m_return_values_desync = presets_vars.m_return_values_desync + 1
            elseif presets_vars.m_return_values_desync >= presets_vars.m_max_desync  then
                presets_vars.m_return_values_desync = presets_vars.m_min_desync
            end
        end
        self.save_antiaims.fake_yaw_limit = self:clamp(presets_vars.m_return_values_desync,presets_vars.m_min_desync,presets_vars.m_max_desync)
        self.save_antiaims.freestanding_body_yaw = false
    end




end
g_antiaim.direction = {}
g_antiaim.direction.c_var = {
    saved_dir = 0,
    saved_press_tick = 0,
    left = false,
    right = false,
    back = false
}
function g_antiaim.direction:run_direction()
    if funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == false then
        return
    end
    ui_set(gui.menu.manual_left,"On hotkey")
    ui_set(gui.menu.manual_right,"On hotkey")
    ui_set(gui.menu.manual_reset,"On hotkey")
    ui_set(antiaim.freestanding[2],"Always on")
    local statements = ui.get(gui.menu.antiaim_settings)

    local fs_e = ui_get(gui.menu.freestanding_key) and funcs.ui:table_contains(statements,"\aFFFFFFFF Freestanding")
	local edge_e = ui_get(gui.menu.edge_yaw_key) and funcs.ui:table_contains(statements,"\aFFFFFFFF Edge yaw")
    ui_set(antiaim.freestanding[1], fs_e)
    ui_set(antiaim.edge_yaw, edge_e)
    if funcs.ui:table_contains(statements,"\aFFFFFFFF Manual antiaim") and client.key_state( 0x45 ) then
        ui_set(antiaim.freestanding[1], false)
        ui_set(antiaim.edge_yaw, false)
   end

    m_state = ui.get(gui.menu.temp_manual)

    left_state, right_state, backward_state = ui.get(gui.menu.manual_left), ui.get(gui.menu.manual_right), -- this lua so sb
    ui.get(gui.menu.manual_reset)

    if left_state == self.c_var.left and right_state == self.c_var.right and backward_state == self.c_var.back then
        return
    end

    self.c_var.left, self.c_var.right, self.c_var.back = left_state, right_state, backward_state

    if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
        ui.set(gui.menu.temp_manual, 0)
        return
    end




    if left_state and m_state ~= 1 then
        ui.set(gui.menu.temp_manual, 1)
    end
    if right_state and m_state ~= 2 then
        ui.set(gui.menu.temp_manual, 2)
    end
    if backward_state and m_state ~= 3 then
        ui.set(gui.menu.temp_manual, 3)
    end

    






    -- if funcs.ui:table_contains(statements,"\aFFFFFFFF Manual antiaim") and client.key_state( 0x45 ) then
    --     ui_set(antiaim.freestanding[1], "-")
	-- 	ui_set(antiaim.edge_yaw, false)
	-- 	self.c_var.saved_dir = 0
	-- 	self.c_var.saved_press_tick = globals_curtime()
	-- 	return
    -- end
    -- local fs_e = ui_get(gui.menu.freestanding_key) and funcs.ui:table_contains(statements,"\aFFFFFFFF Freestanding")
	-- local edge_e = ui_get(gui.menu.edge_yaw_key) and funcs.ui:table_contains(statements,"\aFFFFFFFF Edge yaw")

	-- ui_set(antiaim.freestanding[1], fs_e and "Remedy" or "-")
	-- ui_set(antiaim.edge_yaw, edge_e)


	-- if ui_get(gui.menu.manual_reset) then
    --     if fs_e then
    --         self.c_var.saved_press_tick = globals_curtime()
    --     end
	-- 	self.c_var.saved_dir = 0
	-- elseif ui_get(gui.menu.manual_right) and self.c_var.saved_press_tick + 0.2 < globals_curtime() then
    --         self.c_var.saved_dir = self.c_var.saved_dir == 90 and 0 or 90
      
    --     self.c_var.saved_press_tick = globals_curtime()
	-- elseif ui_get(gui.menu.manual_left) and self.c_var.saved_press_tick + 0.2 < globals_curtime() then
 
    --     self.c_var.saved_dir = self.c_var.saved_dir == -90 and 0 or -90
        
	-- 	self.c_var.saved_press_tick = globals_curtime()
	-- elseif self.c_var.saved_press_tick > globals_curtime() then
	-- 	self.c_var.saved_press_tick = globals_curtime()
	-- end
	
end
local roll_ground_ticks = 0
function g_antiaim:run_states(cmd)
    local p_duck = entity.get_prop(entity.get_local_player(), "m_flDuckAmount")
    local inair = bit.band( entity.get_prop( entity.get_local_player( ), "m_fFlags" ), 1 ) == 0 
    local on_ground = bit.band(entity.get_prop( entity.get_local_player( ), "m_fFlags"), 1) 
    local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local p_still = math.sqrt(vx ^ 2 + vy ^ 2)
    local p_slow = ui.get(antiaim.slow_motion[1]) and ui.get(antiaim.slow_motion[2])
    if on_ground == 1 then
        roll_ground_ticks = roll_ground_ticks + 1
    else 
        roll_ground_ticks = 0
    end
    
    if client.key_state(0x45) then
        return 7
    elseif self.direction.c_var.saved_dir ~= 0 then
        return 6
    elseif inair  then
        return 5
    elseif p_slow and roll_ground_ticks > 8 then
        return 4
    elseif p_duck > 0.8 and roll_ground_ticks > 8 then
        return 3
    elseif p_still > 5 and roll_ground_ticks > 8 then
        return 2
    elseif p_still < 2 and roll_ground_ticks > 8 then
        return 1
    else 
        return 5
    end




end

local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]
function g_antiaim:run_trustd()
    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if funcs.ui:table_contains(ui_get(gui.menu.roll_selects),"\aF8F884D1 Match making") == true then
            is_valve_ds[0] = 0
        else
            is_valve_ds[0] = 1
        end
    end
end

local lean_lby = function(cmd)
     if check_roll == false then
         return
     end
     local local_player = entity_get_local_player()
     if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 or entity_get_prop(local_player, "m_MoveType") == 9 then
         return
     end

     local desync_amount = antiaim_funcs.get_desync(2)

     if desync_amount == nil then
         return
     end
    
   if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
         return
     end
     local vx, vy, vz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")

     local p_still = math.sqrt(vx ^ 2 + vy ^ 2)
     local inair = bit.band( entity.get_prop( entity.get_local_player( ), "m_fFlags" ), 1 ) == 0 and cmd.in_jump


    if p_still > 80 and not inair then return end

     cmd.forwardmove = 0
    cmd.in_forward = 1


end

function g_antiaim:run_roll(cmd)
    if funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == false then
        return
    end

    
    self.save_antiaims.pitch = "Remedy"

    self.save_antiaims.yaw_2 = "180"

    local states = self:run_states(cmd)

    -- "\aFFFFFFFF Stand","\aFFFFFFFF Move","\aFFFFFFFF Slow walk","\aFFFFFFFF Duck","\aFFFFFFFF Air","\aFFFFFFFF Use","\aFFFFFFFF Manual"  
    if ui_get(antiaim.quick_peek_assist[1]) and ui_get(antiaim.quick_peek_assist[2]) and funcs.ui:table_contains(ui_get(gui.menu.roll_selects),"\aF8F884D1 Disable roll when peeking") == true then
        check_roll = false
     
    elseif ui_get(gui.menu.roll_key) and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Stand") and states == 1 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Move") and states == 2 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Slow walk") and states == 4 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Duck") and states == 3 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Air") and states == 5 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Use") and states == 7 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    elseif funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aFFFFFFFF Manual") and states == 6 and funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") then
        check_roll = true 
    else 
        check_roll = false
    end
    if check_roll == true then
        lean_lby(cmd)

    end
    

    if states == 7 then
        self.save_antiaims.yaw_2 = 0
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        if ui_get(gui.menu.roll_inverter) then
            self.save_antiaims.body_yaw_2 = 180
        else
            self.save_antiaims.body_yaw_2 = -180
        end


        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if self.direction.c_var.saved_dir ~= 0 and states == 6 then
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = -180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 5 then
        self.save_antiaims.yaw_2 = 29
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 4 then
        self.save_antiaims.yaw_2 = 9
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 3 then
        self.save_antiaims.yaw_2 = 45
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 2 then
        self.save_antiaims.yaw_2 = 4
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.yaw_jitter_2 = 0
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.fake_yaw_limit = 60
        self.save_antiaims.freestanding_body_yaw = false
    end

    if states == 1 then
        if funcs.ui:table_contains(ui_get(gui.menu.roll_selects),"\aFA3F3FFF Unsafe roll") == true then
            if ui_get(gui.menu.roll_inverter) then
                self.save_antiaims.yaw_2 = 10
                self.save_antiaims.yaw_jitter_1 = "Off"
                self.save_antiaims.yaw_jitter_2 = 0
                self.save_antiaims.body_yaw_1 = "Static"
                self.save_antiaims.body_yaw_2 = -180
                self.save_antiaims.fake_yaw_limit = 60
                self.save_antiaims.freestanding_body_yaw = false
            else
                self.save_antiaims.yaw_2 = 10
                self.save_antiaims.yaw_jitter_1 = "Off"
                self.save_antiaims.yaw_jitter_2 = 0
                self.save_antiaims.body_yaw_1 = "Static"
                self.save_antiaims.body_yaw_2 = 180
                self.save_antiaims.fake_yaw_limit = 60
                self.save_antiaims.freestanding_body_yaw = false
            end

            
        else
            
            self.save_antiaims.yaw_2 = 4
            self.save_antiaims.yaw_jitter_1 = "Off"
            self.save_antiaims.yaw_jitter_2 = 0
            self.save_antiaims.body_yaw_1 = "Static"
            if ui_get(gui.menu.roll_inverter) then
                self.save_antiaims.body_yaw_2 = -180
            else
                self.save_antiaims.body_yaw_2 = 180
            end


            self.save_antiaims.fake_yaw_limit = 60
            self.save_antiaims.freestanding_body_yaw = false
        end

    end
    local degree = 50
    if funcs.ui:table_contains(ui_get(gui.menu.roll_selects),"\aFA3F3FFF Unsafe roll") == true then
        degree = 80
        ui_set(antiaim.anti_untrusted,false)
    else
        ui_set(antiaim.anti_untrusted,true)
    end



    if check_roll == true then
        if self.direction.c_var.saved_dir ~= 0 then
            cmd.roll = -degree
        else 
            if funcs.ui:table_contains(ui_get(gui.menu.roll_selects),"\aF8F884D1 Jitter") == true then
                cmd.roll = globals_tickcount() % 4 >= 2 and degree or -degree

            else
                cmd.roll = degree
            end
        end
    elseif check_roll == false then
        cmd.roll = 0
    end

end


g_antiaim.legit = {}
g_antiaim.legit.classnames = {"CWorld","CCSPlayer","CFuncBrush"}

function g_antiaim.legit:get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function g_antiaim.legit:entity_has_c4(ent)
	local bomb = entity_get_all("CC4")[1]
	return bomb ~= nil and entity_get_prop(bomb, "m_hOwnerEntity") == ent
end

function g_antiaim.legit:run_legit(cmd)
    if funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == false then
        return
    end
    if funcs.ui:table_contains(ui.get(gui.menu.antiaim_settings),"\aFFFFFFFF Antiaim on use") then

  
        local plocal = entity_get_local_player()
		
		local distance = 100
		local bomb = entity_get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(plocal, "m_vecOrigin")
			distance = self:get_distance(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity_get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity_get_prop(plocal, "m_bInBombZone")
   
		local has_bomb = self:entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not ui_get(gui.menu.disable_use)
		
		local px, py, pz = client_eye_position()
		local pitch, yaw = client_camera_angles()
	
		local sin_pitch = math_sin(math_rad(pitch))
		local cos_pitch = math_cos(math_rad(pitch))
		local sin_yaw = math_sin(math_rad(yaw))
		local cos_yaw = math_cos(math_rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client_trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #self.classnames do
				if entity_get_classname(entindex) == self.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			cmd.in_use = 0
		end
    end
end
function g_antiaim:run_knife()

        self.save_antiaims.pitch = "Remedy"
        self.save_antiaims.yaw_2 = 44
        self.save_antiaims.yaw_jitter_1 = "Off"
        self.save_antiaims.body_yaw_1 = "Static"
        self.save_antiaims.body_yaw_2 = 180
        self.save_antiaims.freestanding_body_yaw = false
        self.save_antiaims.fake_yaw_limit = 60
 
end

g_antiaim.anti_knife = {}
function g_antiaim.anti_knife:get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)

end

function g_antiaim.anti_knife:on_run_command()
    if funcs.ui:table_contains(ui_get(gui.menu.misc_settings),"\aFFFFFFFF Anti knife") == true then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = self:get_distance(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui_get(gui.menu.knife_distance) then
                ui.set(yaw_slider,180)
                if ui_get(gui.menu.pitch0_onknife) then
                    ui.set(pitch,"Off")
                end
            end
        end
    end
end

g_antiaim.pre_render = {}
g_antiaim.pre_render.vars = {
    ground_ticks = 0,
    end_time = 0
}
function g_antiaim.pre_render:animation_breaker()
    if funcs.ui:table_contains(ui_get(gui.menu.misc_settings),"\aFFFFFFFF Animation breaker") == true then
        -- anim_list = main:ui(ui_new_multiselect(gui.tab[1],gui.tab[2],"Break anims","In air","On land","Leg fucker"),false,true),
        if not entity.is_alive(entity.get_local_player()) then return end
    
        if funcs.ui:table_contains(ui_get(gui.menu.anim_list),"In air") then 
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
        end
           
        if funcs.ui:table_contains(ui_get(gui.menu.anim_list),"On land") then
            local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)
            if on_ground == 1 then
                self.vars.ground_ticks = self.vars.ground_ticks + 1
            else
                self.vars.ground_ticks = 0
                self.vars.end_time = globals.curtime() + 1
            end 
        
            if self.vars.ground_ticks > ui.get(antiaim.fake_lag_limit)+1 and self.vars.end_time > globals.curtime() then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
            end
        end 
        local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
    
        if funcs.ui:table_contains(ui_get(gui.menu.anim_list),"Leg fucker") then
            ui.set(antiaim.leg_movement, legs_types[2])
            entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 8, 0)
        end
    end
    
end

function g_antiaim:run_main(cmd)

    local m = gui.menu
    self.direction:run_direction()
    self.legit:run_legit(cmd)

    if ui.get(gui.menu.temp_manual) == 0 then

        self.direction.c_var.saved_dir = 0
    end
    if ui.get(gui.menu.temp_manual) == 1 then

        if check_roll == true then
            self.direction.c_var.saved_dir =  -90 

        elseif check_roll == false then
            self.direction.c_var.saved_dir =  -70 

        end
    end
    if ui.get(gui.menu.temp_manual) == 2 then
  
        if check_roll == true then
            self.direction.c_var.saved_dir =  90 

        elseif check_roll == false then
            self.direction.c_var.saved_dir =  110

        end
    end

    self:run_roll(cmd)

    local wpn_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
    local p_duck = entity.get_prop(entity.get_local_player(), "m_flDuckAmount")
    local weapons = wpn_id ~= nil and bit.band(wpn_id, 0xFFFF) or 0
    if weapons == nil or wpn_id == nil then return end
    local is_knife = wpn_id >= 500 and wpn_id <= 525 or wpn_id == 41 or wpn_id == 42 or wpn_id == 59
    local in_air = bit.band( entity.get_prop( entity.get_local_player( ), "m_fFlags" ), 1 ) == 0 

    if is_knife and in_air and p_duck > 0.8 and not client.key_state(0x45) then
        self:run_knife()
    else
        if check_roll == false then
            if ui_get(m.presets) == "\aFFFFFFB2VIP" then
                self:run_presets_1(cmd)
            elseif ui_get(m.presets) == "Custom" then
                self:run_custom(cmd)
            end
        end
    end
        
    

    if funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == true then
        if funcs.ui:table_contains(ui.get(gui.menu.antiaim_settings),"\aFFFFFFFF Antiaim on use") and client.key_state(0x45) then

            self.save_antiaims.pitch = "Off"
            self.save_antiaims.yaw_1 = "Off"
            if ui_get(gui.menu.static_onuse) and not funcs.ui:table_contains(ui.get(gui.menu.forceroll_states),"\aFFFFFFFF Use") == true or not ui_get(gui.menu.roll_key) then
                self.save_antiaims.body_yaw_1 = "Static"
                self.save_antiaims.body_yaw_2 = 180
                self.save_antiaims.yaw_jitter_1 = "Off"
                self.save_antiaims.freestanding_body_yaw = true
    
            end
        end
    end
  

 
    

   
 


    if funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == true then


        if self.direction.c_var.saved_dir ~= 0 then
            self.save_antiaims.yaw_2 = self.direction.c_var.saved_dir
            if ui_get(gui.menu.prevent_jitter) then
                self.save_antiaims.body_yaw_1 = "Static"
                self.save_antiaims.yaw_jitter_1 = "Off"
                self.save_antiaims.fake_yaw_limit = 60
            end
            if check_roll == true then
                if self.direction.c_var.saved_dir ~= 0 then
                    self.save_antiaims.body_yaw_2 = 180

                else
                    self.save_antiaims.body_yaw_2 = -180
                end
            else
                self.save_antiaims.body_yaw_2 = 180
            end
        end
   
    end

    -- ui_set(antiaim.pitch,self.save_antiaims.pitch)
    ui_set(antiaim.yaw_base,self.direction.c_var.saved_dir == 0 and not client.key_state(0x45) and "At targets" or "Local view")
    ui_set(antiaim.yaw[1],self.save_antiaims.yaw_1)
    ui_set(antiaim.yaw[2],self.save_antiaims.yaw_2)
    ui_set(antiaim.yaw_jitter[1],self.save_antiaims.yaw_jitter_1)
    ui_set(antiaim.yaw_jitter[2],self.save_antiaims.yaw_jitter_2)
    ui_set(antiaim.body_yaw[1],self.save_antiaims.body_yaw_1)
    ui_set(antiaim.body_yaw[2],self.save_antiaims.body_yaw_2)
    ui_set(antiaim.freestanding_body_yaw,self.save_antiaims.freestanding_body_yaw)

    self:og_menu(false)
end

local renderer_rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
	y = y + radius
	local datacircle = {
		{x + radius, y, 180},
		{x + w - radius, y, 90},
		{x + radius, y + h - radius * 2, 270},
		{x + w - radius, y + h - radius * 2, 0},
	}

	local data = {
		{x + radius, y, w - radius * 2, h - radius * 2},
		{x + radius, y - radius, w - radius * 2, radius},
		{x + radius, y + h - radius * 2, w - radius * 2, radius},
		{x, y, radius, h - radius * 2},
		{x + w - radius, y, radius, h - radius * 2},
	}

	for _, data in pairs(datacircle) do
		renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
	end

	for _, data in pairs(data) do
	   renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
	end
end



local render_glow_rectangle = function(x,y,w,h,r,g,b,a,round,size,g_w)
    for i = 1 , size , 0.3 do 
        local fixpositon = (i  - 1) * 2	 
        local fixi = i  - 1
        renderer_rounded_rectangle(x - fixi, y - fixi, w + fixpositon , h + fixpositon , r , g ,b , (a -  i * g_w) ,round)	
    end
end

local glow_color = function(x, y, long, width, round, color_r, color_g, color_b, alpha)
    renderer_rectangle(x, y + round, 1, width - round * 2 + 2, color_r, color_g, color_b, alpha)
    renderer_rectangle(x + long - 1, y + round, 1, width - round * 2 + 1, color_r, color_g, color_b, alpha)
    renderer_rectangle(x + round, y, long - round * 2, 1, color_r, color_g, color_b, alpha)
    renderer_rectangle(x + round, y + width, long - round * 2, 1, color_r, color_g, color_b, alpha)
    renderer_circle_outline(x + round, y + round, color_r, color_g, color_b, alpha, round, 180, 0.25, 2)
    renderer_circle_outline(x + long - round, y + round, color_r, color_g, color_b, alpha, round, 270, 0.25, 2)
    renderer_circle_outline(x + round, y + width - round + 1, color_r, color_g, color_b, alpha, round, 90, 0.25, 2)
    renderer_circle_outline(x + long - round, y + width - round + 1, color_r, color_g, color_b, alpha, round, 0, 0.25, 2)
end

local render_glow_rectangle_box = function(x,y,w,h,r,g,b,a,round,size,g_w)
    for i = 1 , size , 0.3 do 
        local fixpositon = (i  - 1) * 2	 
        local fixi = i  - 1
        glow_color(x - fixi, y - fixi, w + fixpositon , h + fixpositon ,round, r , g ,b , (a -  i * g_w) )	
    end
end
render.center = {}
render.center.vars = {
    alpha = 0,
    alpha_glow = 0,
    add_x =0,
    add_y = 0,
    rect_add_y =0,
    rect_alpha = 0,
    rect_width = 0,
    icon_alpha = 0,
    icon_back_alpha = 0

}

function render:lerp(start, vend, time)
    return start + (vend - start) * time
end


function render.center:draw()

        local sc = {client_screen_size()}
        local cx,cy = sc[1]/2,sc[2]/2
        local r,g,b,a = ui_get(gui.menu.indicator_color)
        local text_size = {renderer_measure_text("b",remedy)}
        local alpha = math.floor(math.sin(math.abs(-math.pi + (globals_curtime() * (1.25 / .75)) % (math.pi * 2))) * 8)
        if alpha <= 1 then
            alpha = 1
        end
        local wpn_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
        local weapons = wpn_id ~= nil and bit.band(wpn_id, 0xFFFF) or 0
        if weapons == nil or wpn_id == nil then
            return
        end
        local is_scoped = entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_zoomLevel" )
        local is_knife =wpn_id >= 500 and wpn_id <= 525 or wpn_id == 41 or wpn_id == 42 or wpn_id == 59

        local modifier = entity_get_prop(entity_get_local_player(), "m_flVelocityModifier")
        if funcs.ui:table_contains(ui_get(gui.menu.indicator_settings),"\aFFFFFFFF Center indicator") then

            if is_scoped ~= 0 and not is_knife then
                self.vars.alpha =  render:lerp(self.vars.alpha,55,globals_frametime() * 8)
                self.vars.icon_alpha =  render:lerp(self.vars.icon_alpha,20,globals_frametime() * 8)
                self.vars.icon_back_alpha =  render:lerp(self.vars.icon_back_alpha,20,globals_frametime() * 8)

                
                self.vars.add_x = render:lerp(self.vars.add_x,30,globals_frametime() * 8)
                self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,55,globals_frametime() * 8)

                self.vars.alpha_glow = render:lerp(self.vars.alpha_glow,0,globals_frametime() * 8)
            else
                self.vars.icon_alpha =  render:lerp(self.vars.icon_alpha,a,globals_frametime() * 8)
                self.vars.icon_back_alpha =  render:lerp(self.vars.icon_back_alpha,150,globals_frametime() * 8)

                self.vars.alpha =  render:lerp(self.vars.alpha,a,globals_frametime() * 8)
                self.vars.alpha_glow = render:lerp(self.vars.alpha_glow,alpha,globals_frametime() * 8)
                self.vars.add_x = render:lerp(self.vars.add_x,0,globals_frametime() * 8)
                if modifier ~= 1 then
                    self.vars.add_y = render:lerp(self.vars.add_y,4,globals_frametime() * 8)
                    self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,255,globals_frametime() * 8)
                    self.vars.rect_add_y = render:lerp(self.vars.rect_add_y,4,globals_frametime() * 8)
                    self.vars.rect_width = render:lerp(self.vars.rect_width,math_floor((text_size[1]- 1) * modifier),globals_frametime() * 8)
                else
                    self.vars.rect_alpha = render:lerp(self.vars.rect_alpha,0,globals_frametime() * 8)
                    self.vars.add_y = render:lerp(self.vars.add_y,0,globals_frametime() * 8)
                    self.vars.rect_add_y = render:lerp(self.vars.rect_add_y,0,globals_frametime() * 8)
                    self.vars.rect_width = render:lerp(self.vars.rect_width,0,globals_frametime() * 8)
        
                end
        
            end
                
        local bullet = {
            32,
            32,
            '<svg style="color: white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <g> <path fill="white" d="M0 0H24V24H0z"></path> <path d="M21 3v2c0 9.627-5.373 14-12 14H7.098c.212-3.012 1.15-4.835 3.598-7.001 1.204-1.065 1.102-1.68.509-1.327-4.084 2.43-6.112 5.714-6.202 10.958L5 22H3c0-1.363.116-2.6.346-3.732C3.116 16.974 3 15.218 3 13 3 7.477 7.477 3 13 3c2 0 4 1 8 0z" fill="white"></path> </g> </svg>'
        }
        local svg = renderer.load_svg(bullet[3], 32 , 25 )
        local svg_2 = renderer.load_svg(bullet[4], 32 , 25 )
        if ui_get(gui.menu.center_mode) == "Text" then
            -- render_glow_rectangle(cx  - text_size[1]/2 + math_floor(self.vars.add_x),cy + - math_floor(self.vars.add_y),text_size[1] - 2 + 2,text_size[2] - 5,r,g,b,15,8,self.vars.alpha_glow,2)
            renderer_text(cx - text_size[1]/16 + math_floor(self.vars.add_x),cy + 16 - math_floor(self.vars.add_y),r,g,b,self.vars.alpha,"c-",0,"REMEDY")
            renderer_rectangle(
                cx - text_size[2]/1 + math_floor(self.vars.add_x),cy + 14 + text_size[2] - 2 - math_floor(self.vars.add_y) + math_floor(self.vars.rect_add_y),text_size[1],16,25,25,25,math_floor(self.vars.rect_alpha)
            )
            renderer_rectangle(
                cx - text_size[1]/2 + math_floor(self.vars.add_x) +1,cy + 16   + text_size[2] - 2 - math_floor(self.vars.add_y) + math_floor(self.vars.rect_add_y) + 1,self.vars.rect_width,1,r,g,b,math_floor(self.vars.rect_alpha)
            )
        elseif ui_get(gui.menu.center_mode) == "Icon" then
            renderer.texture(svg_2,cx - 20+ 6 + 1 +  math_floor(self.vars.add_x) ,cy + 18 + 1,32 ,25 ,255,255,255,self.vars.icon_back_alpha)
            renderer.texture(svg_2,cx - 20+ 6 - 1  +  math_floor(self.vars.add_x),cy + 18 - 1, 32,25 ,255,255,255,self.vars.icon_back_alpha)
            renderer.texture(svg_2,cx - 20+ 6- 1 +  math_floor(self.vars.add_x),cy + 18 + 1,32 ,25 ,255,255,255,self.vars.icon_back_alpha)
            renderer.texture(svg_2,cx - 20+ 6 + 1+  math_floor(self.vars.add_x) ,cy + 18 - 1,32 ,25 ,255,255,255,self.vars.icon_back_alpha)
            renderer.texture(svg,cx - 20 + 6+  math_floor(self.vars.add_x) ,cy + 18,32 ,25 ,r,g,b,self.vars.icon_alpha)
        end
      

      
    end
end

render.arrows = {}
render.arrows.c_var ={
    lerp = 0,
    rerp = 0
}
function render.arrows:draw()
    if funcs.ui:table_contains(ui_get(gui.menu.indicator_settings),"\aFFFFFFFF Manual arrows") == true then
        local w, h = client.screen_size()
        local r, g, b = ui.get(gui.menu.indicator_color)
        local realtime = globals.realtime() % 3
        local distance = (w/2) / 210 * ui_get(gui.menu.manualarrow_distance)
        if entity_get_local_player() == nil then
            return
        end
  
        if g_antiaim.direction.c_var.saved_dir == 90 or g_antiaim.direction.c_var.saved_dir == 110 then
            self.c_var.lerp = render:lerp(self.c_var.lerp,255,globals_frametime() * 12)
            self.c_var.rerp = render:lerp(self.c_var.rerp,0,globals_frametime() * 12)
        elseif g_antiaim.direction.c_var.saved_dir == -90 or g_antiaim.direction.c_var.saved_dir == -70 then
            self.c_var.rerp = render:lerp(self.c_var.rerp,255,globals_frametime() * 12)
            self.c_var.lerp = render:lerp(self.c_var.lerp,0,globals_frametime() * 12)
        else
            self.c_var.rerp = render:lerp(self.c_var.rerp,0,globals_frametime() * 12)
            self.c_var.lerp = render:lerp(self.c_var.lerp,0,globals_frametime() * 12)
        end
        local flag = "c"
        if ui_get(gui.menu.manualarrow_size) == "+" then
            flag = "+c"
        elseif ui_get(gui.menu.manualarrow_size) == "-" then
            flag = "c"
        end
        if ui_get(gui.menu.manualarrow_back) then
            renderer.text(w/2 + distance, h / 2 - 1, 60, 60, 60, 125, flag, 0, "â¯")
            renderer.text(w/2 - distance, h / 2 - 1, 60, 60, 60, 125, flag, 0, "â®")
        end

        renderer.text(w/2 + distance, h / 2 - 1, r, g, b, self.c_var.lerp, flag, 0, "â¯")
        renderer.text(w/2 - distance, h / 2 - 1, r, g, b, self.c_var.rerp, flag, 0, "â®")
        
    end

end

render.roll = {}

render.roll.c_var = {
    roll_r = 0,
    roll_g = 0,
    roll_b = 0,
    roll_a = 0
}
function render.roll:draw()
    if funcs.ui:table_contains(ui_get(gui.menu.antiaim_settings),"\aFFFFFFFF Roll") == true and funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu4.."\aC08A8AFF Extra Settings") == true then
        if check_roll == true then
            -- 200,200,200,255
            self.c_var.roll_r = render:lerp(self.c_var.roll_r,200,globals_frametime() * 8)
            self.c_var.roll_g = render:lerp(self.c_var.roll_g,200,globals_frametime() * 8)
            self.c_var.roll_b = render:lerp(self.c_var.roll_b,200,globals_frametime() * 8)
            self.c_var.roll_a = render:lerp(self.c_var.roll_a,255,globals_frametime() * 8)
        elseif check_roll == false then
            self.c_var.roll_r = render:lerp(self.c_var.roll_r,255,globals_frametime() * 8)
            self.c_var.roll_g = render:lerp(self.c_var.roll_g,0,globals_frametime() * 8)
            self.c_var.roll_b = render:lerp(self.c_var.roll_b,50,globals_frametime() * 8)
            self.c_var.roll_a = render:lerp(self.c_var.roll_a,255,globals_frametime() * 8)
        end

        renderer_indicator(self.c_var.roll_r,self.c_var.roll_g,self.c_var.roll_b,self.c_var.roll_a,"ROLL")
    end
end

render.watermark = {}
render.watermark.c_var = {
    alpha = 0,
    alpha2 = 0,
    back = 0,
    backa = 0,
    cur_alpha = 1,
    min_alpha = 0.2,
    max_alpha = 1,
    target_alpha = 0,
    speed = 0.12,

    --menu 

    MENU_ADD_X = 0,
    MENU_ALPHA = 0,
    OPEN_ALPHA = 0


}

local vector = require 'vector'
local solus_render = (function()
    local solus_m = {};
    local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
        renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius,
                           r, g, b, a)
        renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2,
                           r, g, b, a)
        renderer.rectangle(x + radius, y + radius, w - radius * 2,
                           h - radius * 2, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270,
                        0.25)
        renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0,
                        0.25)
    end;
    local rounding = 4;
    local rad = rounding + 2;
    local n = 45;
    local o = 20;
    local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
        renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2,
                           r, g, b, a)
        renderer.rectangle(x + w - 3, y + radius + rad, 1,
                           h - rad * 2 - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1,
                           r, g, b, a)
        renderer.rectangle(x + radius + rad, y + h - 3,
                           w - rad * 2 - radius * 2, 1, r, g, b, a)
        renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a,
                                radius + rounding, 180, 0.25, 1)
        renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b,
                                a, radius + rounding, 270, 0.25, 1)
        renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b,
                                a, radius + rounding, 90, 0.25, 1)
        renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r,
                                g, b, a, radius + rounding, 0, 0.25, 1)
    end;
    local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow)
        local n = a / 255 * n;
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180,
                                0.25, 1)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius,
                                270, 0.25, 1)
        renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b,
                          n, false)
        renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a,
                          r, g, b, n, false)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius,
                                90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n,
                                radius, 0, 0.25, 1)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
            for radius = 4, glow do
                local radius = radius / 2;
                OutlineGlow(x - radius, y - radius, w + radius * 2,
                            h + radius * 2, radius, r, g, b, glow - radius * 2)
            end
        
    end;
    local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a,
                                                glow, r1, g1, b1)
        local n = a / 255 * n;
        renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180,
                                0.25, 1)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius,
                                90, 0.25, 1)
        renderer.gradient(x + radius, y, w / 3.5 - radius * 2, 1, r, g, b, a, 0,
                          0, 0, n / 0, true)
        renderer.gradient(x + radius, y + h - 1, w / 3.5 - radius * 2, 1, r, g,
                          b, a, 0, 0, 0, n / 0, true)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r1, g1, b1,
                           n)
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r1, g1, b1, n)
        renderer.circle_outline(x + w - radius, y + radius, r1, g1, b1, n,
                                radius, -90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r1, g1, b1, n,
                                radius, 0, 0.25, 1)
        renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r1, g1, b1,
                           n)
            for radius = 4, glow do
                local radius = radius / 2;
                OutlineGlow(x - radius, y - radius, w + radius * 2,
                            h + radius * 2, radius, r1, g1, b1,
                            glow - radius * 2)
            end
        
    end;
    local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1,
                                      g1, b1)
        local n = a / 255 * n;
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, n)
        renderer.circle_outline(x + radius, y + radius, r, g, b, n, radius, 180,
                                0.25, 1)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, n, radius,
                                270, 0.25, 1)
        renderer.rectangle(x, y + radius, 1, h - radius * 2, r, g, b, n)
        renderer.rectangle(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, n)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, n, radius,
                                90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, n,
                                radius, 0, 0.25, 1)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, n)
        if ui_get(glow_enabled) then
            for radius = 4, glow do
                local radius = radius / 2;
                OutlineGlow(x - radius, y - radius, w + radius * 2,
                            h + radius * 2, radius, r1, g1, b1,
                            glow - radius * 2)
            end
        end
    end;
    solus_m.linear_interpolation = function(start, _end, time)
        return (_end - start) * time + start
    end
    solus_m.clamp = function(value, minimum, maximum)
        if minimum > maximum then
            return math.min(math.max(value, maximum), minimum)
        else
            return math.min(math.max(value, minimum), maximum)
        end
    end
    solus_m.lerp = function(start, _end, time)
        time = time or 0.005;
        time = solus_m.clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
        local a = solus_m.linear_interpolation(start, _end, time)
        if _end == 0.0 and a < 0.01 and a > -0.01 then
            a = 0.0
        elseif _end == 1.0 and a < 1.01 and a > 0.99 then
            a = 1.0
        end
        return a
    end
    solus_m.outlined_glow = function(x, y, w, h, radius, r, g, b, a,glow)

        for radius = 4, glow do
            local radius = radius / 2;
            OutlineGlow(x - radius, y - radius, w + radius * 2,
                        h + radius * 2, radius, r, g, b,
                        glow - radius * 2)
        end
    end

    solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn)
        if a > 0 then
            renderer.blur(x, y, w, h) 
        end

        RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
        FadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o)
        if not fn then return end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end;
    solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1,
                                            g1, b1, fn)
        if alpha * 255 > 0 then renderer.blur(x, y, w, h) end
        RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
        HorizontalFadedRoundedRect(x, y, w, h, rounding, r, g, b, alpha * 255,
                                   alpha * o, r1, g1, b1)
        if not fn then return end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end;
    solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1,
                                      fn)
        if alpha * 255 > 0 then renderer.blur(x, y, w, h) end
        RoundedRect(x, y, w, h, rounding, 17, 17, 17, a)
        FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o,
                         r1, g1, b1)
        if not fn then return end
        fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
    end;
    solus_m.measure_multitext = function(flags, _table)
        local a = 0;
        for b, c in pairs(_table) do
            c.flags = c.flags or ''
            a = a + renderer.measure_text(c.flags, c.text)
        end
        return a
    end
    solus_m.multitext = function(x, y, _table)
        for a, b in pairs(_table) do
            b.flags = b.flags or ''
            b.limit = b.limit or 0;
            b.color = b.color or {255, 255, 255, 255}
            b.color[4] = b.color[4] or 255;
            renderer.text(x, y, b.color[1], b.color[2], b.color[3], b.color[4],
                          b.flags, b.limit, b.text)
            x = x + renderer.measure_text(b.flags, b.text)
        end
    end
    return solus_m
end)()



render.watermark.clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

function render.watermark:draw_menu()
    if funcs.ui:table_contains(ui_get(gui.menu.indicator_settings),"\aFFFFFFFF Watermark") == true then
        self.c_var.MENU_ALPHA = render:lerp(self.c_var.MENU_ALPHA,1,globals_frametime() * 3.5)
    else
        self.c_var.MENU_ALPHA = render:lerp(self.c_var.MENU_ALPHA,0,globals_frametime() * 3.5)
    end

    local menu_open = ui_is_menu_open()
    local sx,sy = client_screen_size()
    local w ,h = 140,40
    local steamid64 = js.MyPersonaAPI.GetXuid()
    local avatar = images.get_steam_avatar(steamid64)
    local r,g,b,a = ui_get(gui.menu.watermark_color)

    if menu_open then
        renderer.blur((sx/2 - (w+3))+ w/2,8*self.c_var.MENU_ADD_X,w,h)

        self.c_var.OPEN_ALPHA = render:lerp(self.c_var.OPEN_ALPHA,1*self.c_var.MENU_ALPHA,globals_frametime() * 6)
        self.c_var.MENU_ADD_X = render:lerp(self.c_var.MENU_ADD_X,1,globals_frametime() * 12)
    else
        self.c_var.OPEN_ALPHA = render:lerp(self.c_var.OPEN_ALPHA,0,globals_frametime() * 6)
        self.c_var.MENU_ADD_X = render:lerp(self.c_var.MENU_ADD_X,0,globals_frametime() * 6)
    end

    if (self.c_var.cur_alpha < self.c_var.min_alpha + 0.02) then
        self.c_var.target_alpha = self.c_var.max_alpha
    elseif (self.c_var.cur_alpha > self.c_var.max_alpha - 0.02) then
        self.c_var.target_alpha = self.c_var.min_alpha
    end
    self.c_var.cur_alpha = self.c_var.cur_alpha + (self.c_var.target_alpha - self.c_var.cur_alpha)*self.c_var.speed*(globals.absoluteframetime()*10)
    solus_render.outlined_glow(sx/2 - (w+3) + w/2,8*self.c_var.MENU_ADD_X,w,h,8,r,g,b,255*self.c_var.OPEN_ALPHA,(30*self.c_var.cur_alpha)*self.c_var.OPEN_ALPHA)

    renderer_rounded_rectangle(sx/2 - (w+3) + w/2,math_floor(8*self.c_var.MENU_ADD_X),w,h,25,25,25,a*self.c_var.OPEN_ALPHA,6)
    if  avatar ~= nil then
        avatar:draw(sx/2 - (w+3)+ w/2 + 7.5 ,math_floor(8*self.c_var.MENU_ADD_X) + 7,25,25,255,255,255,255*self.c_var.OPEN_ALPHA,true,"f")
        renderer_circle_outline(sx/2 - (w+3) + w/2+ 19 ,8*self.c_var.MENU_ADD_X + 20,25,25,25,255*self.c_var.OPEN_ALPHA,17.9,360,1,4.5)

    end
    local svg = {
        32,
        32,
        '<svg style="color: white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <g> <path fill="white" d="M0 0H24V24H0z"></path> <path d="M21 3v2c0 9.627-5.373 14-12 14H7.098c.212-3.012 1.15-4.835 3.598-7.001 1.204-1.065 1.102-1.68.509-1.327-4.084 2.43-6.112 5.714-6.202 10.958L5 22H3c0-1.363.116-2.6.346-3.732C3.116 16.974 3 15.218 3 13 3 7.477 7.477 3 13 3c2 0 4 1 8 0z" fill="white"></path> </g> </svg>'
    }
    local svg = renderer.load_svg(svg[3], 12 , 12 )
    renderer.texture(svg,(sx/2 - (w+3)+ w/2 ) + 35 + 1 ,8*self.c_var.MENU_ADD_X + 7,10 ,10 ,0,0,0,175*self.c_var.OPEN_ALPHA )
    renderer.texture(svg,(sx/2 - (w+3) + w/2) + 35 - 1,8*self.c_var.MENU_ADD_X + 5,10,10 ,0,0,0,175*self.c_var.OPEN_ALPHA )
    renderer.texture(svg,(sx/2 - (w+3)+ w/2) + 35 + 1,8*self.c_var.MENU_ADD_X + 5,10 ,10 ,0,0,0,175*self.c_var.OPEN_ALPHA )
    renderer.texture(svg,(sx/2 - (w+3) + w/2) + 35 - 1,8*self.c_var.MENU_ADD_X + 7,10 ,10 ,0,0,0,175*self.c_var.OPEN_ALPHA )

    renderer.texture(svg,(sx/2 - (w+3)+ w/2 +1 ) + 35 ,8*self.c_var.MENU_ADD_X+6,10 ,10 ,r,g,b,a*self.c_var.OPEN_ALPHA )
    local text = {
        {text = "@REMEDY",color = {r,g,b,255*self.c_var.OPEN_ALPHA},flags = "-"},
        {text = ".RIP",color = {255,255,255,255*self.c_var.OPEN_ALPHA},flags = "-"},
        {text = "    ",color = {255,255,255,255*self.c_var.OPEN_ALPHA},flags = "-"},
        {text = string_upper(info.build),color = {159,227,255,255*self.c_var.OPEN_ALPHA},flags = "-"},


    }
    -- lua_color = {r = 222, g = 55, b = 55}
    solus_render.multitext((sx/2 - (w+3)+ w/2 ) + 46, 8*self.c_var.MENU_ADD_X+5, text)
    local username = gradient_text(222,55,55,255*self.c_var.OPEN_ALPHA,r,g,b,255*self.c_var.OPEN_ALPHA,"@"..tostring(info.username))
    renderer_text((sx/2 - (w+3)+ w/2 ) + 39 ,8*self.c_var.MENU_ADD_X+20,255,255,255,255*self.c_var.OPEN_ALPHA,"b",0,username)

end

function render.watermark:draw()
    local alpha_glow_then = math.floor(math.sin(math.abs(-math.pi + (globals_curtime() * (1.25 / 1)) % (math.pi * 2))) * 2)
    if alpha_glow_then < 0 then
        alpha_glow_then = 0.8
    end
    local r,g,b,a = ui_get(gui.menu.watermark_color)
    if (self.c_var.cur_alpha < self.c_var.min_alpha + 0.02) then
        self.c_var.target_alpha = self.c_var.max_alpha
    elseif (self.c_var.cur_alpha > self.c_var.max_alpha - 0.02) then
        self.c_var.target_alpha = self.c_var.min_alpha
    end
    self.c_var.cur_alpha = self.c_var.cur_alpha + (self.c_var.target_alpha - self.c_var.cur_alpha)*self.c_var.speed*(globals.absoluteframetime()*10)
    if funcs.ui:table_contains(ui_get(gui.menu.indicator_settings),"\aFFFFFFFF Watermark") == true then
        self.c_var.alpha = render:lerp(self.c_var.alpha,255,globals_frametime() * 12)
        self.c_var.backa = render:lerp(self.c_var.backa,a,globals_frametime() * 12)
        self.c_var.alpha2 = render:lerp(self.c_var.alpha2,170,globals_frametime() * 12)

        self.c_var.back = render:lerp(self.c_var.back,self.c_var.cur_alpha,globals_frametime() * 12)

    else
        self.c_var.alpha2 = render:lerp(self.c_var.alpha2,0,globals_frametime() * 12)

        self.c_var.alpha = render:lerp(self.c_var.alpha,0,globals_frametime() * 12)
        self.c_var.back = render:lerp(self.c_var.back,0,globals_frametime() * 12)
        self.c_var.backa = render:lerp(self.c_var.backa,0,globals_frametime() * 12)

    end
    local sx,sy = client_screen_size()
    local text = {
        {text = "",color = {r,g,b,self.c_var.alpha},flags = "-"},
        {text = "",color = {255,255,255,self.c_var.alpha},flags = "-"},
        {text = "",color = {255,255,255,self.c_var.alpha},flags = "-"},
        {text = ""..string_upper(tostring(info.username)),color = {r,g,b,self.c_var.alpha},flags = "-"},
        {text = "",color = {255,255,255,self.c_var.alpha},flags = "-"},



    }
    local svg = {
        42,
        42,
        '<svg style="color: white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <g> <path fill="white" d="M0 0H24V24H0z"></path> <path d="M21 3v2c0 9.627-5.373 14-12 14H7.098c.212-3.012 1.15-4.835 3.598-7.001 1.204-1.065 1.102-1.68.509-1.327-4.084 2.43-6.112 5.714-6.202 10.958L5 22H3c0-1.363.116-2.6.346-3.732C3.116 16.974 3 15.218 3 13 3 7.477 7.477 3 13 3c2 0 4 1 8 0z" fill="white"></path> </g> </svg>'
    }



    local lua = solus_render.measure_multitext("-", text) + 8
    local svg = renderer.load_svg(svg[3], 12 , 12 )
    local text_d = {renderer_measure_text("-",string_upper(tostring(info.username)))}
    local w,h = lua+ 50 ,20
    local screenx,yd = client_screen_size()
    local x ,y = screenx/ 2 -(lua -20)/ 2 - 4 + 15, sy - 30

    -- solus_render.container(x, y, w, h, r, g, b, self.c_var.backa,self.c_var.back )
    -- solus_render.multitext(x + 5 + 2, y + 3, text)

    -- renderer.texture(svg,x + 2 + 1,y + 4 + 1,12 ,20 ,0,0,0,self.c_var.alpha2)
    -- renderer.texture(svg,x + 2 - 1,y + 4 - 1,12 ,20 ,0,0,0,self.c_var.alpha2)
    -- renderer.texture(svg,x + 2 + 1,y + 4 - 1,12 ,20 ,0,0,0,self.c_var.alpha2)
    -- renderer.texture(svg,x + 2 - 1,y + 4 + 1,12 ,20 ,0,0,0,self.c_var.alpha2)
    -- renderer.texture(svg,x - 20 + 6+  math_floor(self.vars.add_x) ,cy + 18,32 ,25 ,r,g,b,self.vars.icon_alpha)
    renderer.texture(svg,x - 20 ,y + 66,12 ,12 ,r,g,b,self.c_var.alpha)

    

end

render.menu_effect = {}

render.menu_effect.c_var = {
    alpha = 0,
    height = 0,
    cur_alpha = 200,
    min_alpha = 75,
    max_alpha = 200,
    target_alpha = 0,
    speed = 0.08,
    last_change = globals_realtime() - 1,

    dots_alpha = 0,
    key_last_press = 0
}

local function distance(x1, y1, x2, y2)
	return math_sqrt((x2-x1)^2 + (y2-y1)^2)
end
local dots = {}
local dot_size = 3
local menu_hotkey_reference = ui.reference("MISC", "Settings", "Menu key")
local menu_open_prev = true
local key_pressed_prev = false
function render.menu_effect:draw()
    if funcs.ui:table_contains(ui_get(gui.menu.indicator_settings),"\aFFFFFFFF Menu effect") then
        
        if (self.c_var.cur_alpha < self.c_var.min_alpha + 2) then
            self.c_var.target_alpha = self.c_var.max_alpha
        elseif (self.c_var.cur_alpha > self.c_var.max_alpha - 2) then
            self.c_var.target_alpha = self.c_var.min_alpha
        end
        self.c_var.cur_alpha = self.c_var.cur_alpha + (self.c_var.target_alpha - self.c_var.cur_alpha)*self.c_var.speed*(globals.absoluteframetime()*10)
        local SCR = {client_screen_size()}
        local r,g,b,a = ui_get(gui.menu.indicator_color)

        if ui.is_menu_open() then
            self.c_var.alpha = render:lerp(self.c_var.alpha, self.c_var.cur_alpha,globals_frametime() * 3.5)
            self.c_var.height = render:lerp(self.c_var.height,0,globals_frametime() * 3.5)

        else
            self.c_var.height = render:lerp(self.c_var.height,600,globals_frametime() * 3.5)
            self.c_var.alpha = render:lerp(self.c_var.alpha,0,globals_frametime() * 3.5)
            self.c_var.height = render:lerp(self.c_var.height,0,globals_frametime() * 3.5)
        end
        renderer.gradient(0,0,SCR[1],600 -self.c_var.height ,r,g,b,self.c_var.alpha,r,g,b,0,false)
        
        local menu_open = ui.is_menu_open()
        local realtime = globals_realtime()
        if menu_open and not menu_open_prev then
            self.c_var.last_change = realtime
        end
    
        
        if not menu_open then
            return
        end
    
        local key_pressed = ui_get(menu_hotkey_reference)
        if key_pressed and not key_pressed_prev then
            self.c_var.key_last_press = realtime
        end
        key_pressed_prev = key_pressed
    
        local opacity_multiplier = menu_open and 1 or 0
    
        local menu_fade_time = 0.2
    
        if realtime - self.c_var.last_change < menu_fade_time then
            opacity_multiplier = (realtime - self.c_var.last_change) / menu_fade_time
        elseif realtime - self.c_var.key_last_press < menu_fade_time then
            opacity_multiplier = (realtime - self.c_var.key_last_press) / menu_fade_time
            opacity_multiplier = 1 - opacity_multiplier
        end
    
        if opacity_multiplier ~= 1 then
            --client.log(opacity_multiplier)
        end

        local screen_width, screen_height = client_screen_size()

        
        --@credit to sapphyrus 
        if opacity_multiplier > 0 then

            local r, g, b, a = 255,255,255,self.c_var.alpha
            a = a * opacity_multiplier
            local r_connect, g_connect, b_connect, a_connect = 255,255,255,self.c_var.alpha
            a_connect = a_connect * opacity_multiplier * 0.5
            local speed_multiplier = 61 / 100
            local dots_amount = 23
            local dots_connect_distance = 307
            local line_a = a/4
            while #dots > dots_amount do
                table_remove(dots, #dots)
            end
            while #dots < dots_amount do
                local x, y = client_random_int(-dots_connect_distance, screen_width+dots_connect_distance), client_random_int(-dots_connect_distance, screen_height+dots_connect_distance)
                local max = 12
                local min = 4

                local velocity_x
                if client_random_int(0, 1) == 1 then
                    velocity_x = client_random_float(-max, -min)
                else
                    velocity_x = client_random_float(min, max)
                end

                local velocity_y
                if client_random_int(0, 1) == 1 then
                    velocity_y = client_random_float(-max, -min)
                else
                    velocity_y = client_random_float(min, max)
                end

                local size = client_random_float(dot_size-1, dot_size+1)
                table_insert(dots, {x, y, velocity_x, velocity_y, size})
            end

            local dots_new = {}
            for i=1, #dots do
                local dot = dots[i]
                local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                x = x + velocity_x*speed_multiplier*0.2
                y = y + velocity_y*speed_multiplier*0.2
                if x > -dots_connect_distance and x < screen_width+dots_connect_distance and y > -dots_connect_distance and y < screen_height+dots_connect_distance then
                    table_insert(dots_new, {x, y, velocity_x, velocity_y, size})
                end
            end
            dots = dots_new

            for i=1, #dots do
                local dot = dots[i]
                local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                for i2=1, #dots do
                    local dot2 = dots[i2]
                    local x2, y2 = dot2[1], dot2[2]
                    local distance = distance(x, y, x2, y2)
                    if distance <= dots_connect_distance then
                        local a_connect_multiplier = 1
                        if distance > dots_connect_distance * 0.7 then
                            a_connect_multiplier = (dots_connect_distance - distance) / (dots_connect_distance * 0.3)
                            --distance - dots_connect_distance / 
                        end
                        client.draw_line(ctx, x, y, x2, y2, r_connect, g_connect, b_connect, a_connect*a_connect_multiplier)
                    end
                end
            end

            for i=1, #dots do
                local dot = dots[i]
                local x, y, velocity_x, velocity_y, size = dot[1], dot[2], dot[3], dot[4], dot[5]
                client.draw_circle(ctx, x, y, r, g, b, a, size, 0, 1, 1)
            end
        end

      
    end

   
end

render.notifications = {}
render.notifications.table_text = {}
render.notifications.c_var = {
    screen = {client.screen_size()},

}



table.insert(render.notifications.table_text, {
    text = "\aFFFFFFC8Welcome! \a96C83BFF"..tostring(info.username).."\aFFFFFFC8 Build: \a9FE3FFFF"..info.build.."",
    timer = globals.realtime(),

    smooth_y = render.notifications.c_var.screen[2] + 100,
    alpha = 0,
    alpha2 = 0,
    alpha3 = 0,


    box_left = renderer.measure_text(nil,"\aFFFFFFC8Welcome! \a96C83BFF"..tostring(status.username).."\aFFFFFFC8 Build: \a9FE3FFFF"..info.build.."\aFFFFFFC8 Last update time: "..status.last_updatetime),
    box_right = renderer.measure_text(nil,"\aFFFFFFC8Welcome! \a96C83BFF"..tostring(status.username).."\aFFFFFFC8 Build: \a9FE3FFFF"..info.build.."\aFFFFFFC8 Last update time: "..status.last_updatetime),

    box_left_1 = 0,
    box_right_1 = 0
})   

local function noti()
    local y = render.notifications.c_var.screen[2] - 100

    
    for i, info in ipairs(render.notifications.table_text) do
        if i > 5 then
            table.remove(render.notifications.table_text,i)
        end
        if info.text ~= nil and info ~= "" then
            local text_size = {renderer.measure_text(nil,info.text)}
            local r,g,b,a = ui_get(gui.menu.watermark_color)
            if info.timer + 3.8 < globals.realtime() then
    
                info.box_left = render:lerp(info.box_left,text_size[1],globals.frametime() * 1)
                info.box_right = render:lerp(info.box_right,text_size[1],globals.frametime() * 1)
                info.box_left_1 = render:lerp(info.box_left_1,0,globals.frametime() * 1)
                info.box_right_1 = render:lerp(info.box_right_1,0 ,globals.frametime() * 1)
                info.smooth_y = render:lerp(info.smooth_y,render.notifications.c_var.screen[2] + 100,globals.frametime() * 2)
                info.alpha = render:lerp(info.alpha,0,globals.frametime() * 4)
                info.alpha2 = render:lerp(info.alpha2,0,globals.frametime() * 4)
                info.alpha3 = render:lerp(info.alpha3,0,globals.frametime() * 4)


            else
                info.alpha = render:lerp(info.alpha,a,globals.frametime() * 4)
                info.alpha2 = render:lerp(info.alpha2,1,globals.frametime() * 4)
                info.alpha3 = render:lerp(info.alpha3,255,globals.frametime() * 4)

                info.smooth_y = render:lerp(info.smooth_y,y,globals.frametime() * 2)
            
                info.box_left = render:lerp(info.box_left,text_size[1] - text_size[1] /2 -2,globals.frametime() * 1)
                info.box_right = render:lerp(info.box_right,text_size[1]  - text_size[1] /2 +4,globals.frametime() * 1)
                info.box_left_1 = render:lerp(info.box_left_1,text_size[1] +13,globals.frametime() * 2)
                info.box_right_1 = render:lerp(info.box_right_1,text_size[1] +14 ,globals.frametime() * 2)
            end

            local add_y = math.floor(info.smooth_y)
            local alpha = info.alpha
            local alpha2 = info.alpha2
            local alpha3 = info.alpha3

            local left_box = math.floor(info.box_left)
            local right_box = math.floor(info.box_right)
            local left_box_1 = math.floor(info.box_left_1)
            local right_box_1 = math.floor(info.box_right_1)

            solus_render.container(render.notifications.c_var.screen[1] / 2 - text_size[1] / 2 - 4 + 5,add_y - 21,text_size[1] +8 + 4 - 7 + 4 + 14 ,text_size[2] + 7 ,r,g,b,alpha,alpha2 )


            local svg = {
                42,
                42,
                '<svg style="color: white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <g> <path fill="white" d="M0 0H24V24H0z"></path> <path d="M21 3v2c0 9.627-5.373 14-12 14H7.098c.212-3.012 1.15-4.835 3.598-7.001 1.204-1.065 1.102-1.68.509-1.327-4.084 2.43-6.112 5.714-6.202 10.958L5 22H3c0-1.363.116-2.6.346-3.732C3.116 16.974 3 15.218 3 13 3 7.477 7.477 3 13 3c2 0 4 1 8 0z" fill="white"></path> </g> </svg>'
            }
            local svg = renderer.load_svg(svg[3], 12 , 12 )

            renderer.texture(svg,render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5,add_y - 19 + 1,12 ,12 ,r,g,b,alpha3)

            renderer.text(
                render.notifications.c_var.screen[1] / 2 - text_size[1] / 2  + 5 + 14,add_y - 19 + 1,
                255, 255, 255, 255,nil,0,info.text
            )
    
            y = y - 30
            if info.timer + 4 < globals.realtime() then
                table.remove(render.notifications.table_text,i)
            end
        end
    end
    
end
render.esp = {}



local r,g,b,a = ui_get(gui.menu.indicator_color)

client.register_esp_flag("AT",191,137,137, function(player)
    local current_threat = client.current_threat()
    return  current_threat == player and entity_is_alive(player) 
end)

function render:paint()
    
    if entity_get_local_player() == nil or not entity_is_alive(entity_get_local_player()) or ui_get(gui.menu.master_swtich) == false or funcs.ui:table_contains(ui_get(gui.menu.main_list),"\a"..menu1.."\aC08A8AFF Indicators") == false then
        return
    end

    self.center:draw()
    self.arrows:draw()
    self.roll:draw()
    self.watermark:draw()
end


local say  = {
    "kitten anti aim ;w; â—£_â—¢",
    "remedy.rip > you â—£_â—¢",
    "DU HURENSOHN PWNED â—£_â—¢",
    "ARE U ACOUSTIC? YOU ARE LOSING TO REMEDY HAHAHA"
}

local function trash_talk()
    if funcs.ui:table_contains(ui_get(gui.menu.misc_settings),"\aFFFFFFFF Trash talk") then
        local sendconsole = client.exec
        local _first = say[math.random(1, #say)]
        if _first ~= nil  then
            local say = 'say ' .._first
           sendconsole(say)
        end
    end
end

local function clan_tag()
    if funcs.ui:table_contains(ui_get(gui.menu.misc_settings),"\aFFFFFFFF Clantag") then
        client_set_clan_tag("Remedy.rip")
    end
end

local function expd()
	local str = ""
    for i,o in pairs(gui.export['number']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['string']) do
        str = str .. (ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['boolean']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(gui.export['table']) do
        str = str .. funcs.ui:arr_to_string(o) .. '|'
    end
    clipboard.set(base64.encode(str, 'base64'))
end

local function loadd()
    local tbl = funcs.ui:str_to_sub(base64.decode(clipboard.get(), 'base64'), "|")
    local p = 1
    for i,o in pairs(gui.export['number']) do

        ui.set(o,tonumber(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(gui.export['string']) do
        ui.set(o,tbl[p])
        p = p + 1
    end
    for i,o in pairs(gui.export['boolean']) do
        ui.set(o,funcs.ui:to_boolean(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(gui.export['table']) do
        ui.set(o,funcs.ui:str_to_sub(tbl[p],','))
        p = p + 1
    end
end



local function default_config()
    print("Removed http connection")
end





local export = ui.new_button("LUA","B",'\aC08A8AFFâ–¶  \aFFFFFFC8Export config to clipboard',expd)
local load = ui.new_button("LUA","B",'\aC08A8AFFâ–¶ \aFFFFFFC8Import config from clipboard',loadd)



local spacing_2 = main:ui(ui.new_label(gui.tab[1],gui.tab[2],"                                       "),false)


function main:callback(event_name,function_name,state)
    if state then
        client_set_event_callback(event_name,function_name)
    else
        client.unset_event_callback(event_name,function_name)
    end
end


local setup_command = function(cmd)
    self = main or self

    if  ui_get(antiaim.hide_shots[1]) and  ui_get(antiaim.hide_shots[2]) and not ui_get(antiaim.fakeduck) then
        ui_set(antiaim.fake_lag,false)
        ui_set(antiaim.fake_lag_limit,1)

        cmd.allow_send_packet = cmd.chokedcommands >= 1
    else
        ui_set(antiaim.fake_lag_limit,ui_get(gui.menu.fake_lag_limit_d))
        ui_set(antiaim.fake_lag,true)
    end

    g_antiaim:og_menu(false)

    g_antiaim:run_main(cmd)
end

local run_command = function(cmd)
    self = main or self
    g_antiaim.anti_knife:on_run_command()
end

local pre_render = function()
    self = main or self
    g_antiaim.pre_render:animation_breaker()
end

local player_death = function(e)
    self = main or self
    if client_userid_to_entindex(e.userid) == entity_get_local_player() then
        table.insert(render.notifications.table_text, {
            text = "\aFFFFFFC8Reseted data due to death",
            timer = globals.realtime(),
        
            smooth_y = render.notifications.c_var.screen[2] + 100,
            alpha = 0,
            alpha2 = 0,
            alpha3 = 0,

            box_left = renderer.measure_text(nil,"\aFFFFFFC8Reseted data due to death"),
            box_right = renderer.measure_text(nil,"\aFFFFFFC8Reseted data due to death"),
        
            box_left_1 = 0,
            box_right_1 = 0
        })   
    end
end

local round_start = function()
    self = main or self
        table.insert(render.notifications.table_text, {
            text = "\aFFFFFFC8Reseted data due to round start",
            timer = globals.realtime(),
        
            smooth_y = render.notifications.c_var.screen[2] + 100,
            alpha = 0,
            alpha2 = 0,
            alpha3 = 0,

            box_left = renderer.measure_text(nil,"\aFFFFFFC8Reseted data due to round start"),
            box_right = renderer.measure_text(nil,"\aFFFFFFC8Reseted data due to round start"),
        
            box_left_1 = 0,
            box_right_1 = 0
        })   
    
end

   
local aim_hit = function()
    self = main or self
    trash_talk()
end

local paint = function()
    self = main or self

    render:paint()
end




local verify = function()
    render.menu_effect:draw()
    render.watermark:draw_menu()

end



function main:shutdown()
    g_antiaim:og_menu(true)
    ui_set_visible(antiaim.fake_lag_limit,true) 
end



function main:init_gui()
    local enable = ui_get(gui.menu.master_swtich)
    local m = gui.menu

    ui_set_visible(export,enable) 
    ui_set_visible(load,enable) 
    -- ui_set_visible(load_default,enable) 
    ui_set_visible(m.fake_lag_limit_d,enable) 
    ui_set_visible(antiaim.fake_lag_limit,false) 
    ui_set_visible(m.temp_manual,false) 

    if enable then
        -- ui_set_visible(m.info_1 ,  false)
        -- ui_set_visible(m.info_2,false)
        -- ui_set_visible(m.info_2_,false )
        -- ui_set_visible(m.info_2__,false )
        -- ui_set_visible(m.info_2___,false )
        ui_set_visible(m.info_user,false)
        ui_set_visible(m.info_3_,false )
        ui_set_visible(m.info_4_,false)
    else
        -- ui_set_visible(m.info_1 ,  true)
        -- ui_set_visible(m.info_2, true)
        -- ui_set_visible(m.info_2_, true )
        -- ui_set_visible(m.info_2__,true )
        -- ui_set_visible(m.info_2___,true )
        ui_set_visible(m.info_user,true)
        ui_set_visible(m.info_3_,true )
        ui_set_visible(m.info_4_,true)
    end
    --[+]
    ui_set_visible(m.main_list,enable)
    ui_set_visible(m.presets,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu2.."\aC08A8AFF Presets") == true)
    ui_set_visible(m.preset_static,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu2.."\aC08A8AFF Presets") == true and ui_get(m.presets) ~= "Custom")

    ui_set_visible(m.indicator_settings,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu1.."\aC08A8AFF Indicators") == true)
    ui_set_visible(m.indicator_color,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu1.."\aC08A8AFF Indicators") == true)
    ui_set_visible(m.antiaim_settings,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu3.."\aC08A8AFF Extra Settings") == true)
    ui_set_visible(m.misc_settings,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu4.."\aC08A8AFF Misc Features") == true)

   --[-]
   ui_set_visible(m.center_mode,enable and funcs.ui:table_contains(ui_get(m.indicator_settings),"\aFFFFFFFF Center indicator") == true)
   ui_set_visible(m.manualarrow_distance,enable and funcs.ui:table_contains(ui_get(m.indicator_settings),"\aFFFFFFFF Manual arrows") == true)
   ui_set_visible(m.manualarrow_size,enable and funcs.ui:table_contains(ui_get(m.indicator_settings),"\aFFFFFFFF Manual arrows") == true)
   ui_set_visible(m.manualarrow_back,enable and funcs.ui:table_contains(ui_get(m.indicator_settings),"\aFFFFFFFF Manual arrows") == true)
   ui_set_visible(m.watermark_color,enable and funcs.ui:table_contains(ui_get(m.indicator_settings),"\aFFFFFFFF Watermark") == true)
    local antiaim_settings  = funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu3.."\aC08A8AFF Extra Settings") == true
   ui_set_visible(m.forceroll_states,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Roll") == true and antiaim_settings)
   ui_set_visible(m.roll_selects,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Roll") == true and antiaim_settings)
   ui_set_visible(m.roll_inverter,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Roll") == true and antiaim_settings)

   ui_set_visible(m.disable_use,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Antiaim on use") == true and antiaim_settings )
   ui_set_visible(m.static_onuse,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Antiaim on use") == true and antiaim_settings )
   ui_set_visible(m.roll_key,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Roll") == true and antiaim_settings)
   ui_set_visible(m.manual_left,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Manual antiaim") == true and antiaim_settings)
   ui_set_visible(m.manual_right,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Manual antiaim") == true and antiaim_settings)
   ui_set_visible(m.manual_reset,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Manual antiaim") == true and antiaim_settings)
   ui_set_visible(m.prevent_jitter,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Manual antiaim") == true and antiaim_settings)

   ui_set_visible(m.edge_yaw_key,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Edge yaw") == true and antiaim_settings) 
   ui_set_visible(m.freestanding_key,enable and funcs.ui:table_contains(ui_get(m.antiaim_settings),"\aFFFFFFFF Freestanding") == true and antiaim_settings )
    local misc_d = funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu4.."\aC08A8AFF Misc Features") == true
   ui_set_visible(m.pitch0_onknife,enable and funcs.ui:table_contains(ui_get(m.misc_settings),"\aFFFFFFFF Anti knife") == true and misc_d)
   ui_set_visible(m.knife_distance,enable and funcs.ui:table_contains(ui_get(m.misc_settings),"\aFFFFFFFF Anti knife") == true and misc_d)
   ui_set_visible(m.anim_list,enable and funcs.ui:table_contains(ui_get(m.misc_settings),"\aFFFFFFFF Animation breaker") == true and misc_d)
    ui_set_visible(m.states_selection,enable and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu2.."\aC08A8AFF Presets") == true and ui_get(m.presets) == "Custom")
    
    for i = 1,#_state do
        local selects = ui_get(m.states_selection)
        local cswitch = ui_get(m.custom[i].enable)
        local show = enable and selects == _state[i] and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu2.."\aC08A8AFF Presets") == true and ui_get(m.presets) == "Custom" and cswitch
        ui_set_visible(m.custom[i].enable,selects == _state[i] and funcs.ui:table_contains(ui_get(m.main_list),"\a"..menu2.."\aC08A8AFF Presets") == true and ui_get(m.presets) == "Custom")
        ui_set_visible(m.custom[i].extra_options,show)
        ui_set_visible(m.custom[i].yaw_mode,show)
        -- {"Static","Period jitter \aC08A8AFF[Tick]","Period jitter \aC08A8AFF[Choke]","Period jitter \aC08A8AFF[Desync]"}
        ui_set_visible(m.custom[i].static_yaw,show and ui_get(m.custom[i].yaw_mode) == "Static")
        ui_set_visible(m.custom[i].tick_yaw_left,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Tick]")
        ui_set_visible(m.custom[i].tick_yaw_right,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Tick]")
        ui_set_visible(m.custom[i].choke_yaw_left,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Choke]")
        ui_set_visible(m.custom[i].choke_yaw_right,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Choke]")
        ui_set_visible(m.custom[i].desync_yaw_left,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync]")
        ui_set_visible(m.custom[i].desync_yaw_right,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync]")
        ui_set_visible(m.custom[i].desync_yaw_left_2,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync 2]")
        ui_set_visible(m.custom[i].desync_yaw_right_2,show and ui_get(m.custom[i].yaw_mode) == "Period jitter \aC08A8AFF[Desync 2]")
        ui_set_visible(m.custom[i].yaw_jitter,show)
        ui_set_visible(m.custom[i].yaw_jitter_degree,show)      
        -- { "Off", "Opposite", "Jitter", "Static"  }  
        -- {"Static","Period jitter","Recursion"}
        ui_set_visible(m.custom[i].self_bodyyaw_mode,show)
        ui_set_visible(m.custom[i].bodyyaw_mode,show and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")     
        ui_set_visible(m.custom[i].bodyyaw_degree,show and ui_get(m.custom[i].bodyyaw_mode) == "Static" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite" )
        ui_set_visible(m.custom[i].jitter_bodyyaw_degree_left,show and ui_get(m.custom[i].bodyyaw_mode) == "Period jitter" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
        ui_set_visible(m.custom[i].jitter_bodyyaw_degree_right,show and ui_get(m.custom[i].bodyyaw_mode) == "Period jitter" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
        ui_set_visible(m.custom[i].step_bodyyaw_degree_left,show and ui_get(m.custom[i].bodyyaw_mode) == "Recursion" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
        ui_set_visible(m.custom[i].step_bodyyaw_degree_right,show and ui_get(m.custom[i].bodyyaw_mode) == "Recursion" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
        ui_set_visible(m.custom[i].body_yaw_step_ticks,show and ui_get(m.custom[i].bodyyaw_mode) == "Recursion" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")
        ui_set_visible(m.custom[i].body_yaw_step_value,show and ui_get(m.custom[i].bodyyaw_mode) == "Recursion" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Opposite")

    
        -- {"Static","Period tick jitter","Progressively increase"}
        ui_set_visible(m.custom[i].fake_yaw_mode,show and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off")
        ui_set_visible(m.custom[i].static_fakeyaw,show and ui_get(m.custom[i].fake_yaw_mode) == "Static" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" )
        ui_set_visible(m.custom[i].jitter_fakeyaw_left,show and ui_get(m.custom[i].fake_yaw_mode) == "Period tick jitter" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off"and ui_get(m.custom[i].fake_yaw_mode) ~= "Static" )
        ui_set_visible(m.custom[i].jitter_fakeyaw_right,show and ui_get(m.custom[i].fake_yaw_mode) == "Period tick jitter" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].fake_yaw_mode) ~= "Static")
        ui_set_visible(m.custom[i].step_ticks,show and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off"and ui_get(m.custom[i].fake_yaw_mode) ~= "Static" )
        ui_set_visible(m.custom[i].step_value,show and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off"and ui_get(m.custom[i].fake_yaw_mode) ~= "Static")
        ui_set_visible(m.custom[i].step_ticks,show and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].fake_yaw_mode) ~= "Static")

        ui_set_visible(m.custom[i].step_abs,show and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].fake_yaw_mode) ~= "Static")
        ui_set_visible(m.custom[i].step_fake_min,show  and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].fake_yaw_mode) ~= "Static" )
        ui_set_visible(m.custom[i].step_fake_max,show  and ui_get(m.custom[i].fake_yaw_mode) == "Progressively increase" and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off" and ui_get(m.custom[i].fake_yaw_mode) ~= "Static" )
        ui_set_visible(m.custom[i].freestanding_bodyyaw,show and ui_get(m.custom[i].self_bodyyaw_mode) ~= "Off")
    end

    main:callback("shutdown",main.shutdown,enable)
    main:callback("setup_command",setup_command,enable)
    main:callback("run_command",run_command,enable)
    main:callback("paint",paint,enable)
    main:callback("pre_render",pre_render,enable)
    main:callback("aim_hit",aim_hit,enable)
    main:callback("player_death",player_death,enable)
    main:callback("round_start",round_start,enable)
    main:callback("paint_ui",verify,enable)
    -- main:callback("setup_command",lean_lby,check_roll == true)

    main:callback("setup_command",g_antiaim.run_trustd,funcs.ui:table_contains(ui_get(gui.menu.forceroll_states),"\aF8F884D1 Match making") == true)

    main:callback("paint",clan_tag,funcs.ui:table_contains(ui_get(gui.menu.misc_settings),"\aFFFFFFFF Clantag") == true)


end

main:init_gui()

function main:register_callbacks()
        -- funcs.misc:lua_msg('..#gui.callback)
        for k, v in pairs(gui.callback) do
            ui_set_callback(v,main.init_gui)
        end
        ui_set_callback(load,main.init_gui)
        ui_set_callback(export,main.init_gui)
        -- ui_set_callback(load_default,main.init_gui)
        -- ui_set_callback(get_logs,main.init_gui)
        ui_set_callback(load,loadd)
        ui_set_callback(export,expd)
        -- ui_set_callback(load_default,default_config)
        -- ui_set_callback(get_logs,draw_logs)
end

client_set_event_callback("paint_ui",noti)

main:register_callbacks()