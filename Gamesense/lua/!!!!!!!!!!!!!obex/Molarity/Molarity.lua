-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
client.color_log(215, 70, 222, "Loading Molarity.....")
-- kk
local vector = require 'vector'
local http = require "gamesense/http" or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
local js = panorama.open()
local persona_api = js.MyPersonaAPI
local username = persona_api.GetName()  

require 'bit'
local surface = require 'gamesense/surface'
local csgo_weapons = require('gamesense/csgo_weapons')
local anti_aim = require('gamesense/antiaim_funcs')
local width, height = client.screen_size()
local center_width = width/2
local center_height = height/2


-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname
local plist_set = plist.get
local vector = require('vector')
local ffi = require('ffi')
local ffi_cast = ffi.cast

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local ref = {
	enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui_reference("AA", "Anti-aimbot angles", "pitch"),
	yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    fakeyawlimit = ui_reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui_reference("RAGE", "Other", "Force body aim"),
	player_list = ui_reference("PLAYERS", "Players", "Player list"),
	reset_all = ui_reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui_reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui_reference("Config", "Presets", "Load"),
	fl_limit = ui_reference("AA", "Fake lag", "Limit"),
	dt_limit = ui_reference("RAGE", "Other", "Double tap fake lag limit"),

	quickpeek = { ui_reference("RAGE", "Other", "Quick peek assist") },
	yawjitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
	freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui_reference("AA", "Other", "On shot anti-aim") },
	slowwalk = { ui_reference("AA", "Other", "Slow motion") },
	dt = { ui_reference("RAGE", "Other", "Double tap") },
	ps = { ui_reference("RAGE", "Other", "Double tap") },
	fakelag = { ui_reference("AA", "Fake lag", "Enabled") }
}

refv = {
	-- Default Skeet AA
	enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui_reference("AA", "Anti-aimbot angles", "pitch"),
	yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
	yawjitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
	fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
    fakeyawlimit = ui_reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
	roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
	-- Other
    maxprocticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui_reference("RAGE", "Other", "Force body aim"),
	player_list = ui_reference("PLAYERS", "Players", "Player list"),
	reset_all = ui_reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui_reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui_reference("Config", "Presets", "Load"),
	fl_limit = ui_reference("AA", "Fake lag", "Limit"),
	dt_limit = ui_reference("RAGE", "Other", "Double tap fake lag limit"),
	quickpeek = { ui_reference("RAGE", "Other", "Quick peek assist") },

}

local refs = {
    dt = { ui_reference("RAGE", "Other", "Double tap") },
    md = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    sp = ui_reference("RAGE", "Aimbot", "Force safe point"),
    baim = ui_reference("RAGE", "Other", "Force body aim"),
    fd = ui_reference("RAGE", "Other", "Duck peek assist"),
    dt_mode = ui_reference("RAGE", "Other", "Double tap mode"),
    dt_hc = ui_reference("RAGE", "Other", "Double tap hit chance"),
    dt_fl = ui_reference("RAGE", "Other", "Double tap fake lag limit"),
    quickpeek = { ui_reference("RAGE", "Other", "Quick peek assist") },

    aa = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    yawj = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    fs = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },

    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    fs_bodyyaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),  
    fakelimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    fl = ui_reference("AA", "Fake lag", "Enabled"),
    fl_amt = ui_reference("AA", "Fake lag", "Amount"),
    fl_var = ui_reference("AA", "Fake lag", "Variance"),
    fl_limit = ui_reference("AA", "Fake lag", "Limit"),

    osaa = { ui_reference("AA", "Other", "On shot anti-aim") },

    menu_color = ui.reference("misc", "settings", "menu color"),

    scope_overlay = ui_reference('VISUALS', 'Effects', 'Remove scope overlay'),

    maxprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    holdaim = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks_holdaim"),
    tag_reference = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
}

local vars = {
    best_enemy = nil,
    best_angle = 0,
    move_right = 0,
    move_left = 0,
    move_back = 0,
    move_forward = 0,
    misses = { },
    end_choke_cycle = 0,
    last_miss = 0,
    indexed_angle = 0,
    ideal_tick_enabled = false,
    manual_aa = false,
    freestanding = false,
    taycan_tag = "Taycansync",
    clan_tag_prev = "",
    enabled_prev = "Off",
    frametimes = {},
    fps_prev = 0,
    value_prev = {},
    last_update_time = 0,
    m_alpha = 0,
}


AA_freestanding1,AA_freestanding_key1 = ui.reference("AA", "Anti-aimbot angles", "Freestanding")


var = {
	player_states = { "Standing", "Moving", "Slow motion", "Air", "On-key"},
	p_state = 0
}
-- local player_state = ui.new_combobox("AA", "Anti-aimbot angles", "[Mol?lurity] AA Builder", var.player_states)
-- No code repeat
local anti_aim_store = { }

function Color(color,endcolor,text)
    return '\a' .. color .. "FF".. " " .. text .. " " .. "\a" ..endcolor .. "FF"
end

anti_aim_store[0] = {
	anti_aim_mode = "Rage",
	molartiy_aa = ui.new_combobox("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." AntiAim Mode", {"Autopilot", "Builder"}),
	player_state = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." AA Builder", var.player_states),
	onshot_aa_settings = ui_new_multiselect("AA", "Other", "On shot anti-aim", {"While standing", "While moving", "On slow-mo", "In air", "While crouching", "On key"}),
	onshot_aa_key =  ui_new_hotkey("AA", "Other", "On shot anti-aim key", false),
}
-- ui_set_visible(ref.maxprocticks, true)

for i=1, 5 do
	anti_aim_store[i] = {
        enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Enable " .. string_lower(var.player_states[i]) .. " anti-aim"),
		on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "On Key", true),
		pitch = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Pitch",  { "Off", "Default", "Up", "Down", "Minimal", "Random" }),

		-- Default Skeet Section
		yawbase = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Yaw base\n" .. var.player_states[i], { "Local view", "At targets" }),
		yaw = ui_new_combobox("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Yaw\n" .. var.player_states[i], { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
		yawadd = ui_new_slider("AA", "Anti-aimbot angles","\nYaw add" .. var.player_states[i], -180, 180, 0),
		yawjitter = ui_new_combobox("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Yaw jitter\n" .. var.player_states[i], { "Off", "Offset", "Center", "Random" }),
		yawjitter_1value = ui_new_slider("AA", "Anti-aimbot angles","\nYaw jitter 1" .. var.player_states[i], -180, 180, 0),
		-- yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles","\nYaw jitter add" .. var.player_states[i], -180, 180, 0),
		bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Body Yaw",  { "Off", "Opposite", "Jitter", "Static" }),
		bodyyawadd = ui_new_slider("AA", "Anti-aimbot angles","\nBody yaw Add" .. var.player_states[i], -180, 180, 0),
		free_standing_key = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Freestanding" ),
		free_standing_body_yaw = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Freestanding Body Yaw" ),
		fake_yaw_limit = ui_new_slider("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Fake Yaw Limit", 0, 60, 50),

		edge_yaw = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Edge Yaw" ),
		roll_slider = ui_new_slider("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Roll", -50, 50, 50),

		-- Roll section
		roll_aa_enable = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Roll AA"),
		enable_force_roll = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Enable Force Roll"),
		force_roll_value = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Force Roll", -180, 180, 180),
		master = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Smart Lean Enable"),
		master2 = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Smart Lean Key", true),
		int = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Smart Lean Value", -180, 180, 180),
	   
		randomize_lean = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Randomize Lean"),
		flick_lean = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Jitter Lean" ),

		-- Customize Default Skeet Section
		fake_yaw_customize = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Fake Yaw Option",  { "Default", "Flick", "Randomize", "Randomize Range" }),
		fake_yaw_flick = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Fake Yaw Flick" ),
		fake_yaw_flick_1st_slider = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Flick 1st Value", 0, 60, 60),
		fake_yaw_flick_2nd_slider = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Flick 2nd Value", 0, 60, 60),
		fake_yaw_randomize = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Fake Yaw Ransomize" ),
		fake_yaw_randomize_range = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Fake Yaw Randomize Range" ),
		fake_yaw_randomize_range1 = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Range 1", 0, 60, 60),
		fake_yaw_randomize_range2 = ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", var.player_states[i]) ..']'.." Range 2", 0, 60, 60),

	}
end

-- Autopilot code
enable_autopilot = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.. " Enable Autopilot")
autopilot_mode = ui.new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.. " Autopilot Mode", {"MODEX", "MODEY"})
free_standing_key = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.. " Freestanding" )

ui.new_label("AA", "Anti-aimbot angles", "\aff0800FF ------------------------------------------------")


local MM_enable = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." ENABLE MM ROLL")


enable_fake_flick = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Fake Flick")
fake_flick_yaw = ui.new_slider("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Flick Yaw", 0, 180, 90)
fake_flick_tick = ui.new_slider("AA", "Anti-aimbot angles",'['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Flick Ticks", 3, 100, 16)
fake_flick_invert_side = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Invert Fake Side", false)
enable_fake_flick_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Flick Indicator")
-- Combo
other_selector = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Tab Selector",  { "Manual AA", "Indicators", "Misc", "Other" })

-- Manual
manual_master = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Enable Manual")
manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Manual Left")
manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Manual Right")
manual_yaw_base =  ui.new_slider("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Yaw", -180, 180, 0)
manual_yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") }

local elements = {
	enable = ui.new_checkbox('AA', 'Fake lag', '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'..' Ideal Tick'),
	hotkey = ui.new_hotkey('AA', 'Fake lag', '\nHotkey', true),
	slider = ui.new_slider('AA', 'Fake lag', '[Mol?lurity] Fake lag', 1, 15, 13, true, 't')
}


-- Static Legs, Pitch 0
local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0

local static_legs_air = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Static Legs Air")
local pitch_land_zero = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Pitch 0 On Land")

local hotkey_slowwalk = ui.new_hotkey("AA", "Other", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Slow walk")
local slider_slowwalk = ui.new_slider("AA", "Other", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Slow walk speed", 1, 100, 100, true, "%")


local i_on = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Indicators")

local color = ui.new_color_picker("AA", "Anti-Aimbot angles", "Indicator color", 227, 20, 20, 255)
-- local indi_styles = ui_new_combobox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Styles",  { "Style A", "Style B", "Style C"})

local mindmgref = ui.reference("Rage", "Aimbot", "Minimum damage")
local laglimitref = ui.reference("AA", "Fake lag", "Limit")
local hcref = ui.reference("Rage", "Aimbot", "Minimum hit chance")
local fakeduck, fakeduck_key = ui.reference("Rage", "Other", "Duck peek assist")
local quickpeek, quickpeek_key = ui.reference("Rage", "Other", "quick peek assist")
local doubletap, doubletap_key = ui.reference("Rage", "Other", "Double tap")
local onshot, onshot_key = ui.reference("AA", "Other", "On shot anti-aim")
local slowref, hk_slowref = ui.reference("AA", "Other", "Slow motion")

local indicator_inactive_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Inactive Color", 10, 109, 247, 255)
local arrow_indicator = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Arrows")
local arrow_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Arrow Color", 255,0,0, 255)
local enableClantag = ui.new_checkbox("AA", "Anti-aimbot angles", '['.. Color("f63436", "ffffff", "Mol?lurity") ..']'.." Clantag")

-- local clear_clantag = ui.new_button("AA", "Anti-aimbot angles", "[Mol?lurity] Clear Clantag", function()
	
-- 	ui.set(enableClantag, false)
-- 	client.set_clan_tag("")

-- end)


function lean_standing(cmd)
	if ui_get(master) and ui_get(master2) then
		local localplayer = entity.get_local_player
		local vx, vy, vz = entity.get_prop(localplayer(), 'm_vecVelocity')	
        -- print(math.abs(vy))
        if (true) then
			cmd.roll = ui_get(int)
        end
	end

	if(ui_get(randomize_lean)) then
		cmd.roll = math.random(-50,50)
	end
	if(ui_get(flick_lean)) then
		if(math.random(1,2) == 1) then
			cmd.roll = -50
		else
			cmd.roll = 50
		end
		
	end
end

function chat_func(info)
	print(info.name)
	print(info.text)

end

function on_paint()
	r, g, b, a = 132, 196, 20, 255

	
	
	
	if(ui.get(enable_fake_flick)) then
		ui.set_visible(fake_flick_yaw, true)
		ui.set_visible(fake_flick_tick, true)
		ui.set_visible(fake_flick_invert_side, true)
		ui.set_visible(enable_fake_flick_indicator, true)
		
	else 
		ui.set_visible(fake_flick_yaw, false)
		ui.set_visible(fake_flick_tick, false)
		ui.set_visible(fake_flick_invert_side, false)
		ui.set_visible(enable_fake_flick_indicator, false)
	end

	
	if ui.get(other_selector) == "Manual AA" then
		
		ui.set_visible(manual_master, true)
		if(ui.get(manual_master)) then
			ui.set_visible(manual_left, true) 
			ui.set_visible(manual_right, true) 
			ui.set_visible(manual_yaw_base, true) 
		else
			ui.set_visible(manual_left, false) 
			ui.set_visible(manual_right, false) 
			ui.set_visible(manual_yaw_base, false) 
		end

	else
		ui.set_visible(manual_master, false)
		ui.set_visible(manual_left, false) 
		ui.set_visible(manual_right, false) 
		ui.set_visible(manual_yaw_base, false) 
	
	end

	if( ui.get(other_selector) == "Indicators" ) then
		ui.set_visible(i_on, true)
		-- ui.set_visible(indi_styles, true)
		ui.set_visible(indicator_inactive_color, true)
		ui.set_visible(arrow_indicator, true)
		ui.set_visible(arrow_color, true)
	else
		-- ui.set_visible(indi_styles, false)
		ui.set_visible(i_on, false)
		ui.set_visible(indicator_inactive_color, false)
		ui.set_visible(arrow_indicator, false)
		ui.set_visible(arrow_color, false)
	end

	if ( ui.get(other_selector) == "Misc") then
		ui.set_visible(static_legs_air, true)
		ui.set_visible(pitch_land_zero, true)

	else
		ui.set_visible(static_legs_air, false)
		ui.set_visible(pitch_land_zero, false)
	end

	if(ui.get(other_selector) == "Other") then
		ui.set_visible(enableClantag,true)	
	
	else
		ui.set_visible(enableClantag,false)	
		
		
	end
	

end

local function setSpeed(newSpeed)
	if client.get_cvar("cl_sidespeed") == 450 and newSpeed == 450 then
		return
	end

    client.set_cvar("cl_sidespeed", newSpeed)
    client.set_cvar("cl_forwardspeed", newSpeed)
    client.set_cvar("cl_backspeed", newSpeed)
end


function slow_walk()
	if not ui_get(hotkey_slowwalk) then
		setSpeed(450)
	else
		local final_val = 250 * ui_get(slider_slowwalk) / 100
		setSpeed(final_val)
	end
end


function static_legs_fix()
	if ui.get(static_legs_air) then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
    end
	
	if entity.is_alive(entity.get_local_player()) then
	
    if ui.get(pitch_land_zero) then
        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
    
        if ground_ticks > ui.get(fakelag)+1 and end_time > globals.curtime() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
end
end


local ref = {
	fakelagenabled = ui.reference('AA', 'Fake lag', 'Enabled'),
	fakelag = ui.reference('AA', 'Fake lag', 'Limit'),
	doubletap = {ui.reference('Rage', 'Other', 'Double tap')},
	doubletapmode = ui.reference('Rage', 'Other', 'Double tap mode'),
	doubletaplag = ui.reference('Rage', 'Other', 'Double tap fake lag limit'),
	quickstop = ui.reference('Rage', 'Other', 'Quick stop options'),
	ticks = ui.reference('Misc', 'Settings', 'sv_maxusrcmdprocessticks')
}

local function on_run()
	local local_player = entity.get_local_player()
	local weapon_ent = entity.get_player_weapon(local_player)
	local weapon = csgo_weapons(weapon_ent)
	if not local_player then return end
	if weapon == nil then return end
	if weapon_ent == nil then return end
	if  ui.get(elements.hotkey) then
		ui.set(ref.doubletap[2], 'Always on')
		ui.set(ref.fakelag, 1)
                ui.set(ref.doubletaplag, 1)
		ui.set(ref.doubletapmode, 'Defensive')
		ui.set(ref.fakelagenabled, false)
	else
		ui.set(ref.doubletap[2], 'Toggle')
		ui.set(ref.fakelag, ui.get(elements.slider))
		ui.set(ref.fakelagenabled, true)
	end

end


local function ideal_tick_func()
	r, g, b, a = 132, 196, 20, 255
	if anti_aim.get_double_tap() then
		if ui.get(elements.hotkey) then
			renderer.indicator(r, g, b, a, 'IDEAL TICK')
		end		
	end

	if ui.get(elements.enable) then
		ui.set_visible(elements.slider, true)
	else

		ui.set_visible(elements.slider, false)
	end
end

function manual_aa ()

    if ui.get(manual_left) then
        ui.set(manual_yaw[2], -90)
	elseif ui.get(manual_right) then
        ui.set(manual_yaw[2], 90)
	else
		ui.set(manual_yaw[2], ui.get(manual_yaw_base))
	end

end




function 	handle_menu()

	

end

function visuals_function() 
	ui.set(refv.enabled , true)
	ui.set_visible(refv.enabled, false)
	ui.set_visible(refv.pitch,false)
	ui.set_visible(refv.yawbase,false)
	ui.set_visible(refv.yaw[1],false)
	ui.set_visible(refv.yaw[2],false)
	ui.set_visible(refv.yawjitter[1],false)
	ui.set_visible(refv.yawjitter[2],false)
	
	ui.set_visible(refv.bodyyaw[1],false)
	ui.set_visible(refv.bodyyaw[2],false)
	
	ui.set_visible(refv.fsbodyyaw,false)
	ui.set_visible(refv.fakeyawlimit,false)
	ui.set_visible(refv.edgeyaw,false)
	ui.set_visible(refv.roll,false)
	ui.set_visible(refv.freestand[1], false)
	ui.set_visible(refv.freestand[2], false)
	for i=1, 5 do
		
		-- ui.get(anti_aim_store[0].player_state == "Standing")
		local value_of_i = 99
		if(ui.get(anti_aim_store[0].player_state) == "Standing") then
			value_of_i = 1
		elseif (ui.get(anti_aim_store[0].player_state) == "Moving") then
			value_of_i = 2
		elseif (ui.get(anti_aim_store[0].player_state) == "Slow motion") then
			value_of_i = 3
		elseif (ui.get(anti_aim_store[0].player_state) == "Air") then
			value_of_i = 4
		elseif (ui.get(anti_aim_store[0].player_state) == "On-key") then
			value_of_i = 5
		end
		-- print(value_of_i)
		
		-- var.player_states
		-- 1"Standing",2 "Moving", 3"Slow motion", 4"Air", 5"On-key"
		-- Others
		ui.set_visible(anti_aim_store[i].enable,  value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].on_key,  false)
		ui.set_visible(anti_aim_store[5].on_key, value_of_i == 5 and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].roll_aa_enable,  value_of_i == i and ui.get(anti_aim_store[i].enable)  and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].pitch, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		-- Default Skeet Section
		ui.set_visible(anti_aim_store[i].yawbase, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].yaw, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].yawadd, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].bodyyaw, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].bodyyawadd, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].roll_slider, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].yawjitter, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].yawjitter_1value, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		-- ui.set_visible(anti_aim_store[i].yawjitter_2value, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].yawjitter) == "Center" or  ui.get(anti_aim_store[i].yawjitter) == "Random" or  ui.get(anti_aim_store[i].yawjitter) == "Offset")
		-- yawjitter_1value
		-- yawjitter_2value

		-- ui.set_visible(anti_aim_store[i].yawjitteradd, ui.get(anti_aim_store[i].enable) and value_of_i == i)
		ui.set_visible(anti_aim_store[i].free_standing_body_yaw, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].free_standing_key, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		
        
		ui.set_visible(anti_aim_store[i].fake_yaw_limit, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].edge_yaw, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		

		
		
		
		
		-- Roll aa Section
		
		ui.set_visible(anti_aim_store[i].master, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		ui.set_visible(anti_aim_store[i].master2, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable)and ui.get(anti_aim_store[i].master) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
        ui.set_visible(anti_aim_store[i].int, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable) and ui.get(anti_aim_store[i].master) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

        ui.set_visible(anti_aim_store[i].randomize_lean, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].flick_lean, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		-- Force roll
		
		ui.set_visible(anti_aim_store[i].enable_force_roll, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		ui.set_visible(anti_aim_store[i].force_roll_value, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].roll_aa_enable)and ui.get(anti_aim_store[i].enable_force_roll) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		-- Skeet Default section Customize
		-- fake_yaw_customize )"Flick", "Randomize", "Randomize Range"
		-- fake_yaw_flick
		-- fake_yaw_flick_1st_slider
		-- fake_yaw_flick_2nd_slider
		-- fake_yaw_randomize
		-- fake_yaw_randomize_range
		-- fake_yaw_randomize_range1
		-- fake_yaw_randomize_range1

		ui.set_visible(anti_aim_store[i].fake_yaw_customize, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].fake_yaw_flick, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].fake_yaw_flick_1st_slider, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[i].fake_yaw_flick) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].fake_yaw_flick_2nd_slider, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[i].fake_yaw_flick) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")

		ui.set_visible(anti_aim_store[i].fake_yaw_randomize, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		
		ui.set_visible(anti_aim_store[i].fake_yaw_randomize_range, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Randomize Range" and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].fake_yaw_randomize_range1, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Randomize Range" and ui.get(anti_aim_store[i].fake_yaw_randomize_range) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		ui.set_visible(anti_aim_store[i].fake_yaw_randomize_range2, ui.get(anti_aim_store[i].enable) and value_of_i == i and ui.get(anti_aim_store[i].fake_yaw_customize) == "Randomize Range" and ui.get(anti_aim_store[i].fake_yaw_randomize_range) and ui.get(anti_aim_store[0].molartiy_aa) == "Builder")
		
	end

	if(ui.get(anti_aim_store[0].molartiy_aa) == "Builder") then
		ui.set_visible(anti_aim_store[0].player_state, true)
	else
		ui.set_visible(anti_aim_store[0].player_state, false)
	end

	if(ui.get(anti_aim_store[0].molartiy_aa) == "Autopilot") then
		ui.set_visible(enable_autopilot, true)
		
	else	
		ui.set_visible(enable_autopilot, false)
	end

	if(ui.get(anti_aim_store[0].molartiy_aa) == "Autopilot" and ui.get(enable_autopilot)) then
		ui.set_visible(autopilot_mode, true)	
		ui.set_visible(free_standing_key, true)
	else
		ui.set_visible(autopilot_mode, false)
		ui.set_visible(free_standing_key, true)
	end

end

-- refv ---
-- enabled = DONE
-- pitch = DONE
-- yawbase = DONE
-- yaw
-- yawjitter
-- bodyyaw
-- fsbodyyaw
-- fakeyawlimit
-- edgeyaw



-- Mol ---
-- enable
-- pitch
-- yawbase
-- yaw
-- yawadd
-- yawjitter
-- yawjitter_1value
-- yawjitteradd
-- bodyyaw
-- bodyyawadd
-- free_standing_body_yaw
-- fake_yaw_limit
-- edge_yaw
-- roll_slider

-- Mol roll
-- roll_aa_enable
-- enable_force_roll
-- force_roll_value
-- master
-- master2
-- int
-- randomize_lean
-- flick_lean
-- fake_yaw_customize
-- fake_yaw_flick
-- fake_yaw_flick_1st_slider
-- fake_yaw_flick_2nd_slider
-- fake_yaw_randomize
-- fake_yaw_randomize_range
-- fake_yaw_randomize_range1
-- fake_yaw_randomize_range2

ui.set_visible(refv.pitch,false)
ui.set_visible(refv.yawbase,false)
ui.set_visible(refv.yaw[1],false)
ui.set_visible(refv.yaw[2],false)
ui.set_visible(refv.yawjitter[1],false)
ui.set_visible(refv.yawjitter[2],false)

ui.set_visible(refv.bodyyaw[1],false)
ui.set_visible(refv.bodyyaw[2],false)

ui.set_visible(refv.fsbodyyaw,false)
ui.set_visible(refv.fakeyawlimit,false)
ui.set_visible(refv.edgeyaw,false)
ui.set_visible(refv.roll,false)



function standing_aa_manager(cmd)
	-- print("Coming from Standing Manager")

	if( not ui.get(anti_aim_store[1].enable) ) then
		return 
	end
	-- print(ui.get(anti_aim_store[1].pitch))
	ui.set(refv.pitch,ui.get(anti_aim_store[1].pitch))
	ui.set(refv.yawbase, ui.get(anti_aim_store[1].yawbase))
	ui.set(refv.yaw[1], ui.get(anti_aim_store[1].yaw))
	ui.set(refv.yaw[2], ui.get(anti_aim_store[1].yawadd))
	ui.set(refv.yawjitter[1], ui.get(anti_aim_store[1].yawjitter))
	ui.set(refv.yawjitter[2], ui.get(anti_aim_store[1].yawjitter_1value))
	-- ui.set(refv.yawjitter[4], ui.get(anti_aim_store[1].yawjitteradd))

	ui.set(refv.bodyyaw[1], ui.get(anti_aim_store[1].bodyyaw))
	ui.set(refv.bodyyaw[2], ui.get(anti_aim_store[1].bodyyawadd))

	ui.set(refv.fsbodyyaw, ui.get(anti_aim_store[1].free_standing_body_yaw))

	ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[1].fake_yaw_limit))
	ui.set(refv.edgeyaw, ui.get(anti_aim_store[1].edge_yaw))
	ui.set(refv.roll, ui.get(anti_aim_store[1].roll_slider))
	

	if(ui.get(anti_aim_store[1].free_standing_key)) then
		ui.set(refs.fs[1], "Default")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = true
	else
		ui.set(refs.fs[1], "-")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = false
	end

	-- Roll Section
	if(ui.get(anti_aim_store[1].roll_aa_enable)) then
		if(ui.get(anti_aim_store[1].enable_force_roll)) then
			cmd.roll = ui.get(anti_aim_store[1].force_roll_value)
		end

		if(ui.get(anti_aim_store[1].master) and ui.get(anti_aim_store[1].master2)) then
			cmd.roll = ui.get(anti_aim_store[1].int)
		end

		if(ui.get(anti_aim_store[1].randomize_lean)) then
			cmd.roll = math.random(-50, 50)
		end

		if(ui.get(anti_aim_store[1].flick_lean)) then
			if( math.random(1,2) == 1) then
				cmd.roll = 50
			else	 
				cmd.roll = -50
			end
		end

	end

	-- Fake Yaw Option
	if(ui.get(anti_aim_store[1].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[1].fake_yaw_flick)) then
		if(math.random(1,2) == 1) then
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[1].fake_yaw_flick_1st_slider))
		else
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[1].fake_yaw_flick_2nd_slider))
		end
		
	end

	if(ui.get(anti_aim_store[1].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[1].fake_yaw_randomize)) then

		ui.set(refv.fakeyawlimit, math.random(0,60))
		
	end

	if(ui.get(anti_aim_store[1].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[1].fake_yaw_randomize_range)) then

		ui.set(refv.fakeyawlimit, math.random(ui.get(anti_aim_store[1].fake_yaw_randomize_range1),ui.get(anti_aim_store[1].fake_yaw_randomize_range2)))
		
	end

	-- ui.set(refv.pitch)

end

function moving_aa_manager(cmd)
	-- print("Coming from Moving Manager")
	if( not ui.get(anti_aim_store[2].enable) ) then
		return 
	end
	-- print(ui.get(anti_aim_store[2].pitch))
	ui.set(refv.pitch,ui.get(anti_aim_store[2].pitch))
	ui.set(refv.yawbase, ui.get(anti_aim_store[2].yawbase))
	ui.set(refv.yaw[1], ui.get(anti_aim_store[2].yaw))
	ui.set(refv.yaw[2], ui.get(anti_aim_store[2].yawadd))
	ui.set(refv.yawjitter[1], ui.get(anti_aim_store[2].yawjitter))
	ui.set(refv.yawjitter[2], ui.get(anti_aim_store[2].yawjitter_1value))
	-- ui.set(refv.yawjitter[4], ui.get(anti_aim_store[2].yawjitteradd))

	ui.set(refv.bodyyaw[1], ui.get(anti_aim_store[2].bodyyaw))
	ui.set(refv.bodyyaw[2], ui.get(anti_aim_store[2].bodyyawadd))

	ui.set(refv.fsbodyyaw, ui.get(anti_aim_store[2].free_standing_body_yaw))
	ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[2].fake_yaw_limit))
	ui.set(refv.edgeyaw, ui.get(anti_aim_store[2].edge_yaw))
	ui.set(refv.roll, ui.get(anti_aim_store[2].roll_slider))
	

	if(ui.get(anti_aim_store[2].free_standing_key)) then
		ui.set(refs.fs[1], "Default")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = true
	else
		ui.set(refs.fs[1], "-")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = false
	end

	-- Roll Section
	if(ui.get(anti_aim_store[2].roll_aa_enable)) then
		if(ui.get(anti_aim_store[2].enable_force_roll)) then
			cmd.roll = ui.get(anti_aim_store[2].force_roll_value)
		end

		if(ui.get(anti_aim_store[2].master) and ui.get(anti_aim_store[2].master2)) then
			cmd.roll = ui.get(anti_aim_store[2].int)
		end

		if(ui.get(anti_aim_store[2].randomize_lean)) then
			cmd.roll = math.random(-50, 50)
		end

		if(ui.get(anti_aim_store[2].flick_lean)) then
			if( math.random(1,2) == 1) then
				cmd.roll = 50
			else	 
				cmd.roll = -50
			end
		end

	end

	-- Fake Yaw Option
	if(ui.get(anti_aim_store[2].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[2].fake_yaw_flick)) then
		if(math.random(1,2) == 1) then
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[2].fake_yaw_flick_1st_slider))
		else
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[2].fake_yaw_flick_2nd_slider))
		end
		
	end

	if(ui.get(anti_aim_store[2].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[2].fake_yaw_randomize)) then

		ui.set(refv.fakeyawlimit, math.random(0,60))
		
	end

	if(ui.get(anti_aim_store[2].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[2].fake_yaw_randomize_range)) then

		ui.set(refv.fakeyawlimit, math.random(ui.get(anti_aim_store[2].fake_yaw_randomize_range1),ui.get(anti_aim_store[2].fake_yaw_randomize_range2)))
		
	end


end

function slow_aa_manager(cmd)
	-- print("Coming from Slow Manager")

	if( not ui.get(anti_aim_store[3].enable) ) then
		return 
	end
	-- print("Coming from Slow Manager v2")
	-- print(ui.get(anti_aim_store[3].pitch))
	ui.set(refv.pitch,ui.get(anti_aim_store[3].pitch))
	ui.set(refv.yawbase, ui.get(anti_aim_store[3].yawbase))
	ui.set(refv.yaw[1], ui.get(anti_aim_store[3].yaw))
	ui.set(refv.yaw[2], ui.get(anti_aim_store[3].yawadd))
	ui.set(refv.yawjitter[1], ui.get(anti_aim_store[3].yawjitter))
	ui.set(refv.yawjitter[2], ui.get(anti_aim_store[3].yawjitter_1value))
	-- ui.set(refv.yawjitter[4], ui.get(anti_aim_store[3].yawjitteradd))

	ui.set(refv.bodyyaw[1], ui.get(anti_aim_store[3].bodyyaw))
	ui.set(refv.bodyyaw[2], ui.get(anti_aim_store[3].bodyyawadd))

	ui.set(refv.fsbodyyaw, ui.get(anti_aim_store[3].free_standing_body_yaw))
	ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[3].fake_yaw_limit))
	ui.set(refv.edgeyaw, ui.get(anti_aim_store[3].edge_yaw))
	ui.set(refv.roll, ui.get(anti_aim_store[3].roll_slider))
	

	if(ui.get(anti_aim_store[3].free_standing_key)) then
		ui.set(refs.fs[1], "Default")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = true
	else
		ui.set(refs.fs[1], "-")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = false
	end

	-- Roll Section
	if(ui.get(anti_aim_store[3].roll_aa_enable)) then
		if(ui.get(anti_aim_store[3].enable_force_roll)) then
			cmd.roll = ui.get(anti_aim_store[3].force_roll_value)
		end

		if(ui.get(anti_aim_store[3].master) and ui.get(anti_aim_store[3].master2)) then
			cmd.roll = ui.get(anti_aim_store[3].int)
		end

		if(ui.get(anti_aim_store[3].randomize_lean)) then
			cmd.roll = math.random(-50, 50)
		end

		if(ui.get(anti_aim_store[3].flick_lean)) then
			if( math.random(1,2) == 1) then
				cmd.roll = 50
			else	 
				cmd.roll = -50
			end
		end

	end

	-- Fake Yaw Option
	if(ui.get(anti_aim_store[3].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[3].fake_yaw_flick)) then
		if(math.random(1,2) == 1) then
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[3].fake_yaw_flick_1st_slider))
		else
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[3].fake_yaw_flick_2nd_slider))
		end
		
	end

	if(ui.get(anti_aim_store[3].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[3].fake_yaw_randomize)) then

		ui.set(refv.fakeyawlimit, math.random(0,60))
		
	end

	if(ui.get(anti_aim_store[3].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[3].fake_yaw_randomize_range)) then

		ui.set(refv.fakeyawlimit, math.random(ui.get(anti_aim_store[3].fake_yaw_randomize_range1),ui.get(anti_aim_store[3].fake_yaw_randomize_range2)))
		
	end


end

function air_aa_manager()
	-- print("Coming from Air Manager")
	if( not ui.get(anti_aim_store[4].enable) ) then
		return 
	end
	-- print(ui.get(anti_aim_store[4].pitch))
	ui.set(refv.pitch,ui.get(anti_aim_store[4].pitch))
	ui.set(refv.yawbase, ui.get(anti_aim_store[4].yawbase))
	ui.set(refv.yaw[1], ui.get(anti_aim_store[4].yaw))
	ui.set(refv.yaw[2], ui.get(anti_aim_store[4].yawadd))
	ui.set(refv.yawjitter[1], ui.get(anti_aim_store[4].yawjitter))
	ui.set(refv.yawjitter[2], ui.get(anti_aim_store[4].yawjitter_1value))
	-- ui.set(refv.yawjitter[4], ui.get(anti_aim_store[4].yawjitteradd))

	ui.set(refv.bodyyaw[1], ui.get(anti_aim_store[4].bodyyaw))
	ui.set(refv.bodyyaw[2], ui.get(anti_aim_store[4].bodyyawadd))

	ui.set(refv.fsbodyyaw, ui.get(anti_aim_store[4].free_standing_body_yaw))
	ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[4].fake_yaw_limit))
	ui.set(refv.edgeyaw, ui.get(anti_aim_store[4].edge_yaw))
	ui.set(refv.roll, ui.get(anti_aim_store[4].roll_slider))
	

	if(ui.get(anti_aim_store[4].free_standing_key)) then
		ui.set(refs.fs[1], "Default")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = true
	else
		ui.set(refs.fs[1], "-")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = false
	end

	-- Roll Section
	if(ui.get(anti_aim_store[4].roll_aa_enable)) then
		if(ui.get(anti_aim_store[4].enable_force_roll)) then
			cmd.roll = ui.get(anti_aim_store[4].force_roll_value)
		end

		if(ui.get(anti_aim_store[4].master) and ui.get(anti_aim_store[4].master2)) then
			cmd.roll = ui.get(anti_aim_store[4].int)
		end

		if(ui.get(anti_aim_store[4].randomize_lean)) then
			cmd.roll = math.random(-50, 50)
		end

		if(ui.get(anti_aim_store[4].flick_lean)) then
			if( math.random(1,2) == 1) then
				cmd.roll = 50
			else	 
				cmd.roll = -50
			end
		end

	end

	-- Fake Yaw Option
	if(ui.get(anti_aim_store[4].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[4].fake_yaw_flick)) then
		if(math.random(1,2) == 1) then
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[4].fake_yaw_flick_1st_slider))
		else
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[4].fake_yaw_flick_2nd_slider))
		end
		
	end

	if(ui.get(anti_aim_store[4].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[4].fake_yaw_randomize)) then

		ui.set(refv.fakeyawlimit, math.random(0,60))
		
	end

	if(ui.get(anti_aim_store[4].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[4].fake_yaw_randomize_range)) then

		ui.set(refv.fakeyawlimit, math.random(ui.get(anti_aim_store[4].fake_yaw_randomize_range1),ui.get(anti_aim_store[4].fake_yaw_randomize_range2)))
		
	end


end


function on_key_aa_manager(cmd)
	-- print("Coming from Air Manager")
	if( not ui.get(anti_aim_store[5].enable)  ) then
		return 
	end
	
	-- print("work")
	-- print(ui.get(anti_aim_store[4].pitch))
	ui.set(refv.pitch,ui.get(anti_aim_store[5].pitch))
	ui.set(refv.yawbase, ui.get(anti_aim_store[5].yawbase))
	ui.set(refv.yaw[1], ui.get(anti_aim_store[5].yaw))
	ui.set(refv.yaw[2], ui.get(anti_aim_store[5].yawadd))
	ui.set(refv.yawjitter[1], ui.get(anti_aim_store[5].yawjitter))
	ui.set(refv.yawjitter[2], ui.get(anti_aim_store[5].yawjitter_1value))
	-- ui.set(refv.yawjitter[4], ui.get(anti_aim_store[5].yawjitteradd))

	ui.set(refv.bodyyaw[1], ui.get(anti_aim_store[5].bodyyaw))
	ui.set(refv.bodyyaw[2], ui.get(anti_aim_store[5].bodyyawadd))

	ui.set(refv.fsbodyyaw, ui.get(anti_aim_store[5].free_standing_body_yaw))
	ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[5].fake_yaw_limit))
	ui.set(refv.edgeyaw, ui.get(anti_aim_store[5].edge_yaw))
	ui.set(refv.roll, ui.get(anti_aim_store[5].roll_slider))
	

	if(ui.get(anti_aim_store[5].free_standing_key)) then
		ui.set(refs.fs[1], "Default")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = true
	else
		ui.set(refs.fs[1], "-")
        ui.set(refs.fs[2], "always on")
        vars.freestanding = false
	end

	-- Roll Section
	if(ui.get(anti_aim_store[5].roll_aa_enable)) then
		if(ui.get(anti_aim_store[5].enable_force_roll)) then
			cmd.roll = ui.get(anti_aim_store[5].force_roll_value)
		end

		if(ui.get(anti_aim_store[5].master) and ui.get(anti_aim_store[5].master2)) then
			cmd.roll = ui.get(anti_aim_store[5].int)
		end

		if(ui.get(anti_aim_store[5].randomize_lean)) then
			cmd.roll = math.random(-50, 50)
		end

		if(ui.get(anti_aim_store[5].flick_lean)) then
			if( math.random(1,2) == 1) then
				cmd.roll = 50
			else	 
				cmd.roll = -50
			end
		end

	end

	-- Fake Yaw Option
	if(ui.get(anti_aim_store[5].fake_yaw_customize) == "Flick" and ui.get(anti_aim_store[5].fake_yaw_flick)) then
		if(math.random(1,2) == 1) then
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[5].fake_yaw_flick_1st_slider))
		else
			ui.set(refv.fakeyawlimit, ui.get(anti_aim_store[5].fake_yaw_flick_2nd_slider))
		end
		
	end

	if(ui.get(anti_aim_store[5].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[5].fake_yaw_randomize)) then

		ui.set(refv.fakeyawlimit, math.random(0,60))
		
	end

	if(ui.get(anti_aim_store[5].fake_yaw_customize) == "Randomize" and ui.get(anti_aim_store[5].fake_yaw_randomize_range)) then

		ui.set(refv.fakeyawlimit, math.random(ui.get(anti_aim_store[5].fake_yaw_randomize_range1),ui.get(anti_aim_store[5].fake_yaw_randomize_range2)))
		
	end


end


function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
function arrow_ind_func()

	if entity.get_local_player() == nil then
        return
    end

	 if entity.get_prop(entity.get_local_player(), 'm_iHealth') == 0 then

		return
	 end

	local alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219 
    if ui.get(arrow_indicator) then
        alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219
    else
        alpha = a     
    end
    if ui.get(arrow_indicator) then
        local screen = {client.screen_size()}
        local center = {screen[1]/2, screen[2]/2}
        r, g, b, a = ui.get(arrow_color)

        fyawlimit2 = math.max(-40, math.min(40, round((entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
        if fyawlimit2 < 0 then
          renderer.text(center[1] - 52, center[2] - 0,r,g,b,alpha, "+cb", nil, "<")
          renderer.text(center[1] + 52, center[2] - 0,45, 45, 45,alpha, "+cb", 0, ">")
        else
            renderer.text(center[1] - 52, center[2] - 0,45, 45, 45,alpha, "+cb", 0, "<")
            renderer.text(center[1] + 52, center[2] - 0,r,g,b,alpha, "+cb", nil, ">")
        end
    end

end
local aa_name 
function aa_manager(cmd) 
	local me = entity_get_local_player()
    if me == nil or not entity_is_alive(me) then return end
 

    local screen_w, screen_h = client_screen_size()
    local center_x, center_y = screen_w / 2, screen_h / 2
    local x, y = entity_get_prop(entity_get_local_player(), "m_vecVelocity")
    local speed = x ~= nil and math_floor(math_sqrt( x * x + y * y + 0.5 )) or 0
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")

	
    local aa_pos

    if  flags == 256 or flags == 262 then
        aa_name = "Air"
        aa_pos = 17
    elseif  speed <=1 then
        aa_name = "Standing"
        aa_pos = 25
    elseif  speed >= 1 and speed <= 80 then
        aa_name = "Slow Motion"
        aa_pos = 14
    else
        aa_name = "Moving"
        aa_pos = 20
    end

	if(ui.get(anti_aim_store[5].on_key))then
		aa_name = "Key"
	end
	-- print(aa_name)
	-- Array index Standing 1, Moving 2, Slow 3, air 4
	if(ui.get(anti_aim_store[0].molartiy_aa) == "Builder") then
		if(aa_name == "Standing") then
			standing_aa_manager(cmd)
		end

		if(aa_name == "Moving") then
			moving_aa_manager(cmd)
		end

		if(aa_name == "Slow Motion") then
			slow_aa_manager(cmd)
		end

		if(aa_name == "Air") then
			air_aa_manager(cmd)
		end

		if(aa_name == "Key") then
			on_key_aa_manager(cmd)
		end
	end
	-- print(aa_name)


end

-- Roll aa
local roll_checkbox = ui.new_checkbox("AA", "Other", "Roll invert key")

local roll_hotkey = ui.new_hotkey("AA", "Other", "Roll invert key", true)
local disablers = ui.new_multiselect("AA", "Other", "Roll disablers", "Quick peek assist", "Duck peek assist", "Edge yaw", "Velocity", "Jump at edge")
local disablers_hk = ui.new_hotkey("AA", "Other", "\n", true)
local velocity_slider = ui.new_slider("AA","Other", "Velocity limit", 2, 135)


ui.set_visible(roll_checkbox, false)
ui.set_visible(roll_hotkey, false)
ui.set_visible(disablers, false)
ui.set_visible(disablers_hk, false)
ui.set_visible(velocity_slider, false)





local aa_ref = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local roll_ref = ui.reference("AA", "Anti-aimbot angles", "Roll")
local qps_ref = ui.reference("RAGE", "OTHER", "Quick Peek assist")
local fd_ref = ui.reference("RAGE", "Other", "Duck peek assist")
local edge_ref = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
local fl_limit_ref = ui.reference("AA", "Fake lag", "Limit")
local edge_jump_ref = ui.reference("MISC", "Movement", "Jump at edge")

local csgo_weapons = require "gamesense/csgo_weapons"

local ffi = require("ffi")
local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]

local return_fl = return_fl
local is_valve_ds_spoofed = 0

local function contains(tbl, val) 
    for i=1, #tbl do
        if tbl[i] == val then return true end 
    end 
    return false 
end

function roll_setup_cmd  (cmd)
    local weapon = csgo_weapons[entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")]

    local xv, yv, zv = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	local velocity = math.sqrt(xv^2 + yv^2)
    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), bit.lshift(1, 0))

    local disabler_tbl = {
        {
            Name = "Quick peek assist",
            Variable = (ui.get(qps_ref + 1))
        },
        {
            Name = "Duck peek assist",
            Variable = (({ui.get(fd_ref)})[1])
        },
        {
            Name = "Edge yaw",
            Variable = (ui.get(edge_ref))
        },
        {
            Name = "Velocity",
            Variable = (on_ground == 1 and velocity >= ui.get(velocity_slider))
        },
        {
            Name = "Jump at edge",
            Variable = (({ui.get(edge_jump_ref + 1)})[1])
        }
    }

    cmd.roll = ui.get(roll_ref)
    
    if is_valve_ds_spoofed == 1 then
        if cmd.chokedcommands > 6 then
            cmd.chokedcommands = 0
        end
        if ui.get(fl_limit_ref) > 6 then
            return_fl = ui.get(fl_limit_ref)
            ui.set(fl_limit_ref, 6)
        end
        if ui.get(roll_ref) > 44 then
            ui.set(roll_ref, 44)
        end
        if ui.get(roll_ref) < -44 then
            ui.set(roll_ref, -44)
        end
    else
        if ui.get(fl_limit_ref) == 6 and return_fl ~= nil then
            ui.set(fl_limit_ref, return_fl)
            return_fl = nil
        end
        if ui.get(roll_ref) == 44 then
            ui.set(roll_ref, 50)
        end
        if ui.get(roll_ref) == -44 then
            ui.set(roll_ref, -50)
        end
    end

    if weapon == nil then goto skip end

    if entity.get_prop(entity.get_local_player(), "m_MoveType") == 9 or weapon.type == "grenade" and velocity >= 1.01001 and on_ground == 1 or ui.get(roll_ref) == 0 or not ui.get(aa_ref) then
        cmd.roll = 0
    end

    if ui.get(roll_checkbox) then
        ui.set(roll_ref, ui.get(roll_hotkey) and (50 - (is_valve_ds_spoofed * 6)) or (-50 + (is_valve_ds_spoofed * 6)))
    end
    
    for _, v in ipairs(disabler_tbl) do
        if contains(ui.get(disablers), v.Name) and ui.get(disablers_hk) then
            if v.Variable then
                cmd.roll = 0
            end
        end
    end

    if contains(ui.get(disablers), "Velocity") then
        ui.set_visible(velocity_slider, true)
    else
        ui.set_visible(velocity_slider, false)
    end

    ::skip::

    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if cmd.roll ~= 0 and ui.get(MM_enable) then
            if is_valve_ds[0] == true then
                is_valve_ds[0] = 0
                is_valve_ds_spoofed = 1
            end
        else
            if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
                --is_valve_ds[0] = 1
                --is_valve_ds_spoofed = 0
                cmd.roll = 0
            end
        end
    end
end




client.set_event_callback("shutdown", function()
    if return_fl ~= nil then
        ui.set(fl_limit_ref, return_fl)
        return_fl = nil
    end
    if globals.mapname() == nil then 
        is_valve_ds_spoofed = 0
        return
    end
    local is_valve_ds = ffi.cast('bool*', gamerules[0] + 124)
    if is_valve_ds ~= nil then
        if is_valve_ds[0] == false and is_valve_ds_spoofed == 1 then
            is_valve_ds[0] = 1
            is_valve_ds_spoofed = 0
        end
    end
end)

client.set_event_callback("pre_config_load", function()
    return_fl = nil
end)

-- -- fakelag 
local current_fakelag = 0
local lastchoke = 0
local non_current_choke = 0

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function last_choke_gay(e)
	if e ~= nil then
        if e.chokedcommands < lastchoke then --sent
            current_fakelag = lastchoke
        end
        lastchoke = e.chokedcommands
        non_current_choke = e.chokedcommands
    end
end



local Furore = surface.create_font('Furore', 12, 400, { 0x200 --[[ Outline ]] })

local x, y = client.screen_size()
local function normalize_yaw(angle)
    angle = (angle % 360 + 360) % 360
    return angle > 180 and angle - 360 or angle
end
local slowwalk, slowwalk_key = ui.reference("AA", "Other", "Slow motion")
local doubletaap = {ui.reference("RAGE", "Other", "Double tap")}
local fakelag = {ui.reference("AA", "Fake lag", "Enabled")}
local fakelag2 = ui.reference("AA", "Fake lag", "Limit")
local roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
local baim = ui.reference("Rage", "Other", "Force body aim")
local sp = ui.reference("Rage", "Aimbot", "Force safe point")
local fs = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") }


local hsv_to_rgb = function(b,c,d,e)local f,g,h;local i=math.floor(b*6)local j=b*6-i;local k=d*(1-c)local l=d*(1-j*c)local m=d*(1-(1-j)*c)i=i%6;if i==0 then f,g,h=d,m,k elseif i==1 then f,g,h=l,d,k elseif i==2 then f,g,h=k,d,m elseif i==3 then f,g,h=k,l,d elseif i==4 then f,g,h=m,k,d elseif i==5 then f,g,h=d,k,l end;return f*255,g*255,h*255,e*255 end

local function get_bar_color()
  local r, g, b, a = 255,255,255,255
  local rgb_split_ratio = 100 / 50
  local h = globals.realtime() * 30 / 50 or 60 / 500
  r, g, b = hsv_to_rgb(h, 1, 1, 1)
  r, g, b = r * rgb_split_ratio,g * rgb_split_ratio,b * rgb_split_ratio
  return r, g, b, a
end

local function get_velocity(player)
    local velocity = vector(entity.get_prop(player, 'm_vecVelocity'))
    return velocity:length()
end

function pain_indicator_center ()

	if not ui.get(i_on) then return end

    if entity.get_local_player() == nil then
        return
    end

	 if entity.get_prop(entity.get_local_player(), 'm_iHealth') == 0 then

		return
	 end

	 local local_player = entity.get_local_player()

	 if local_player == nil then
		 return
	 end
 
	 if entity.is_alive(local_player) == false then
		 return
	 end

    local screenX, screenY = client.screen_size()
    local xPos = screenX / 2 + 1 * 0
    local yPos = screenY / 2 + 20 - 15 *0
    local eyeX, eyeY, eyeZ = client.eye_position()
    local pitch, yaw = client.camera_angles()
    local ent_exists = false
    local wall_dmg = 0
    local sin_pitch = math.sin(math.rad(pitch))
    local cos_pitch = math.cos(math.rad(pitch))
    local sin_yaw = math.sin(math.rad(yaw))
    local cos_yaw = math.cos(math.rad(yaw))
    local dirVector = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
    local fraction, entindex = client.trace_line(entity.get_local_player(), eyeX, eyeY, eyeZ, eyeX + (dirVector[1] * 8192), eyeY + (dirVector[2] * 8192), eyeZ + (dirVector[3] * 8192))
    local r, g, b, a = ui.get(indicator_inactive_color)
    local mindmg = ui.get(mindmgref)
    local laglimit = ui.get(laglimitref)
    local hc = ui.get(hcref)
    local offset_y = - 25

    if fraction < 1 then
        local entindex_1, dmg = client.trace_bullet(entity.get_local_player(), eyeX, eyeY, eyeZ, eyeX + (dirVector[1] * (8192 * fraction + 128)), eyeY + (dirVector[2] * (8192 * fraction + 128)), eyeZ + (dirVector[3] * (8192 * fraction + 128)))

        if entindex_1 ~= nil then
            ent_exists = true
        end

        if wall_dmg < dmg then
            wall_dmg = dmg
        end
    end

	local fl2 = ui.get(fakelag2)
	local last_switch = client.timestamp() - 100000
    local last_weapon
    local player_state = "Unknown"
    local dpa_key = ui.reference("RAGE", "Other", "Duck peek assist")
    local slowwalking = ui.get(slowwalk_key)
    local fakeducking = ui.get(dpa_key)
    local myself = entity.get_local_player()
    local _, camera_yaw = client.camera_angles()
    local _, rotation = entity.get_prop(myself, 'm_angAbsRotation')
    local body_pos = entity.get_prop(myself, "m_flPoseParameter", 11) or 0        
    local body_yaw_safety = math.max(-60, math.min(60, body_pos*120-60+0.5))
    local verdana = surface.create_font('Verdana', 12, 400, { 0x200 --[[ For main font ]] })
    body_yaw_safety = (body_yaw_safety < 1 and body_yaw_safety > 0.0001) and math.floor(body_yaw_safety, 1) or body_yaw_safety
    local abs_yaw = math.abs(body_yaw_safety) 
    local abs_yaw_format = string.format('%.0f%%', abs_yaw/60*100)
    local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
    local vel_x, vel_y = entity.get_prop(local_player, "m_vecVelocity")
    local vel_real = math.floor(math.min(10000, math.sqrt(vel_x * vel_x + vel_y * vel_y) + 0.5))
    local shift_true = anti_aim.get_tickbase_shifting()
    fyawlimit2 = math.max(-40, math.min(40, round((entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
    if camera_yaw ~= nil and rotation ~= nil and 60 < math.abs(normalize_yaw(camera_yaw-(rotation+body_yaw_safety))) then
        body_yaw_safety = -body_yaw_safety
    end

	-- NEW STYLES
	local lp = entity.get_local_player()

    if lp == nil or entity.is_alive(lp) == false then
        return
    end

    local num_round = function(x, n)
        n = math.pow(10, n or 0);
        x = x * n
        x = x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
        return x / n
    end

    local screen = { client.screen_size() }
    local center = { screen[1] / 2, screen[2] / 2 }
    local me = entity.get_local_player()
    local body_pos = entity.get_prop(me, "m_flPoseParameter", 11) or 0
    local body_yaw = math.max(-60, math.min(60, num_round(body_pos * 120 - 60 + 0.5, 1)))
    local x, y, z = entity.get_prop(me, "m_vecAbsOrigin")
    local x1, y1 = renderer.world_to_screen(x, y, z)
    local w, h = client.screen_size()
    local window_x, window_y = w / 2, h / 2
    local abs_yaw = math.floor(math.abs(body_yaw))
    local alpha = 1 + math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 2))) * 219
    local color_g = { ui.get(color) }



    local lp = entity.get_local_player()

    if lp == nil or entity.is_alive(lp) == false then
        return
    end
    local localplayer = entity.get_local_player( )
    if localplayer == nil then return end
    
    local velocity = get_velocity( localplayer )
    -- print(velocity/6)
    local line_offset = velocity/6

	local small_pixel = surface.create_font('small_pixel-7', 12, 400, { 0x200 --[[ Outline ]] })

    -- renderer.text(center[1] - 42, center[2] - 3, color_g[1], color_g[2], color_g[3], color_g[4], "cb+", 0, "<")
    -- renderer.text(center[1] + 42, center[2] - 3, 45, 45, 45, 255, "cb+", 0, ">")
	-- renderer.text(center[1] - 5, center[2] + 36, color_g[1], color_g[2], color_g[3], color_g[4], "", 0, abs_yaw .. "°")
    -- renderer.text(center[1] - 20, center[2] + 15, color_g[1], color_g[2], color_g[3], color_g[4], "b", 0, "molarity")
	
	surface.draw_text(center[1] - 5, center[2] + 36, 255, 34, 5, 255, small_pixel, abs_yaw .. "°")

	surface.draw_text(center[1] - 17, center[2] + 15, 255, 34, 5, 255, small_pixel, "molarity")

	local r,g,b,a = get_bar_color()
    -- renderer.line(center[1] - 23,center[2]+ 29,center[1] + line_offset,center[2]+ 29 ,255,0,0, color_g[4])
    -- renderer.line(center[1] - line_offset,center[2]+ 33,center[1] + 23,center[2]+ 33 ,255,0,0, color_g[4])

	surface.draw_line(center[1] - 23,center[2]+ 29,center[1] + line_offset,center[2]+ 29, 255,0,0, color_g[4])
	surface.draw_line(center[1] - line_offset,center[2]+ 33,center[1] + 23,center[2]+ 33, 255,0,0, color_g[4])

	local space = 36

	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
    local induck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
		-- STATE
	-- if onground and induck then
		
	-- 	renderer.text(center[1] - 20, center[2] + space, 130, 130, 255, color_g[4], "", 0, "crouching")
	-- else
	-- 	if(aa_name == "Standing") then
		
	-- 		renderer.text(center[1] - 20, center[2] + space, 130, 130, 255, color_g[4], "", 0, "standing")
	-- 	end
	
	-- 	if(aa_name == "Moving") then
			
	-- 		renderer.text(center[1] - 20, center[2] + space, 130, 130, 255, color_g[4], "", 0, "moving")
	-- 	end
	
	-- 	if(aa_name == "Slow Motion") then
			
	-- 		renderer.text(center[1] - 20, center[2] + space, 130, 130, 255, color_g[4], "", 0, "slowwalk")
	-- 	end
	
	-- 	if(aa_name == "Air") then
			
	-- 		renderer.text(center[1] - 20, center[2] + space, 130, 130, 255, color_g[4], "", 0, "airplane")
	-- 	end
	-- end

	space = space + 10
	if ui.get(onshot_key) then
		-- renderer.text(center[1] - 20, center[2] + space, 237, 152, 161, color_g[4], "", 0, "onshot")
		surface.draw_text(center[1] - 20, center[2] + space, 237, 152, 161, 255, small_pixel, "onshot")
	else
		-- renderer.text(center[1] - 20, center[2] + space, 255, 255, 255, color_g[4], "", 0, "onshot")
		surface.draw_text(center[1] - 20, center[2] + space, 255, 255, 255, 255, small_pixel, "onshot")
	end
	if ui.get(doubletap) and ui.get(doubletap_key) then
		-- renderer.text(center[1] +15, center[2] + space, 45, 252, 45, color_g[4], "", 0, "dt")
		surface.draw_text(center[1] +15, center[2] + space, 45, 252, 45, 255, small_pixel, "dt")
	else
		-- renderer.text(center[1] +15, center[2] + space, 255, 255, 255, color_g[4], "", 0, "dt")
		surface.draw_text(center[1] +15, center[2] + space, 255, 255, 255, 255, small_pixel, "dt")
	end
	space = space + 10
	if ui.get(quickpeek_key) then
		-- renderer.text(center[1] - 20, center[2] + space, 255,0,0, color_g[4], "", 0, "peek")
		surface.draw_text(center[1] - 20, center[2] + space, 255,0,0, 255, small_pixel, "peek")
	else
		-- renderer.text(center[1] - 20, center[2] + space, 255, 255, 255, color_g[4], "", 0, "peek")
		surface.draw_text(center[1] - 20, center[2] + space, 255, 255, 255, 255, small_pixel, "peek")
	end

	if ui.get(fakeduck) then
		-- renderer.text(center[1] +10, center[2] + space, 255,0,0, color_g[4], "", 0, "fd")
		surface.draw_text(center[1] +10, center[2] + space, 255,0,0, 255, small_pixel, "fd")
	else
		-- renderer.text(center[1] +10, center[2] + space, 255, 255, 255, color_g[4], "", 0, "fd")
		surface.draw_text(center[1] +10, center[2] + space, 255, 255, 255, 255, small_pixel, "fd")
	end






	


end

function roll_paint()

	if globals.mapname() == nil and entity.get_local_player() == nil then
        is_valve_ds_spoofed = 0
        if return_fl ~= nil then
            ui.set(fl_limit_ref, return_fl)
            return_fl = nil
        end
    end

end

----------CLAN TAG----------
local tag = {
    " ",
    "| ",
    "-/ ",
    "M| ",
    "M-/ ",
    "MO| ",
    "MO-/ ",
    "MOL| ",
    "MOL-/ ",
    "MOLA| ",
    "MOLA-/ ",
    "MOLAR| ",
    "MOLAR-/ ",
    "MOLARI| ",
    "MOLARI-/ ",
    "MOLARITY| ",
    "MOLARITY-/ ",
    "MOLARITY | ",
    "MOLARITY -/ ",
    "MOLARITY L| ",
    "MOLARITY L-/ ",
    "MOLARITY LU| ",
    "MOLARITY LU-/ ",
    "MOLARITY LUA| ",
    "MOLARITY LUA ",
    "MOLARITY LUA ",
    "MOLARITY LUA| ",
    "MOLARITY LU! ",
    "MOLARITY LU| ",
    "MOLARITY L! ",
    "MOLARITY L| ",
    "MOLARITY ! ",
    "MOLARITY | ",
    "MOLARITY! ",
    "MOLARITY| ",
    "MOLARI! ",
    "MOLARI| ",
    "MOLAR! ",
    "MOLAR| ",
    "MOLA! ",
    "MOLA| ",
    "MOL! ",
    "MOL| ",
    "MO! ",
    "MO| ",
    "M! ",
    "M| ",
    "! ",
    "| ",
    " ",
}

local old_tag = ""

local function time_to_ticks(time)
    return math.floor(time / globals.tickinterval() + 0.2)
end

function clan_tag()
	if not ui.get(enableClantag) then
        return
    end
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + time_to_ticks(client.latency())
    local i = tickcount / time_to_ticks(0.3)
    i = math.floor(i % #tag)
    i = tag[i+1]

 
        if old_tag ~= i then
            client.set_clan_tag(i)
            old_tag = i
        end

end

function fake_flick_cmd(cmd) 
	if(ui.get(enable_fake_flick)) then

        if(ui.get(fake_flick_invert_side)) then
            if(globals.tickcount() % ui.get(fake_flick_tick) == 0) then
                cmd.yaw = -ui.get(fake_flick_yaw)
                
            end
        else
            if(globals.tickcount() % ui.get(fake_flick_tick) == 0) then
                cmd.yaw = ui.get(fake_flick_yaw)
                
            end

        end
        

    end

end

function fake_flick_indi()

	if entity.get_local_player() == nil then
        return
    end

	 if entity.get_prop(entity.get_local_player(), 'm_iHealth') == 0 then

		return
	 end

	if(ui.get(enable_fake_flick_indicator)) then
		if(ui.get(enable_fake_flick) and ui.get(fake_flick_invert_side)) then
			renderer.indicator(132, 196, 20, 255, 'FLICK: LEFT')
		else
			renderer.indicator(132, 196, 20, 255, 'FLICK: RIGHT')

		end
	end

end

function modex()
	-- print("INSIDE MODEX")
	-- print(aa_name)
	ui.set(refv.enabled , true)
	if(aa_name == "Standing") then
		ui.set(refv.pitch,"Minimal")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180 Z")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Center")
		ui.set(refv.yawjitter[2], -25)
		ui.set(refv.bodyyaw[1], "Static")
		ui.set(refv.bodyyaw[2], 73)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Moving") then
		-- moving_aa_manager(cmd)
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Center")
		ui.set(refv.yawjitter[2], 63)
		ui.set(refv.bodyyaw[1], "Jitter")
		ui.set(refv.bodyyaw[2], -8)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Slow Motion") then
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Off")
		ui.set(refv.yawjitter[2], 0)
		ui.set(refv.bodyyaw[1], "Opposite")
		ui.set(refv.bodyyaw[2], 108)
		ui.set(refv.fakeyawlimit, 50)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Air") then
		-- air_aa_manager(cmd)
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Offset")
		ui.set(refv.yawjitter[2], 12)
		ui.set(refv.bodyyaw[1], "Static")
		ui.set(refv.bodyyaw[2], 39)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Key") then
		-- on_key_aa_manager(cmd)
	end

end

function modey()
	-- print("INSIDE MODEX")
	-- print(aa_name)
	ui.set(refv.enabled , true)
	if(aa_name == "Standing") then
		ui.set(refv.pitch,"Minimal")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180 Z")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Center")
		ui.set(refv.yawjitter[2], -5)
		ui.set(refv.bodyyaw[1], "Static")
		ui.set(refv.bodyyaw[2], 73)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Moving") then
		-- moving_aa_manager(cmd)
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Center")
		ui.set(refv.yawjitter[2], 63)
		ui.set(refv.bodyyaw[1], "Jitter")
		ui.set(refv.bodyyaw[2], -8)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Slow Motion") then
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Center")
		ui.set(refv.yawjitter[2], 10)
		ui.set(refv.bodyyaw[1], "Opposite")
		ui.set(refv.bodyyaw[2], 108)
		ui.set(refv.fakeyawlimit, 50)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Air") then
		-- air_aa_manager(cmd)
		ui.set(refv.pitch,"Down")
		ui.set(refv.yawbase, "At targets")
		ui.set(refv.yaw[1], "180")
		ui.set(refv.yaw[2], 0)
		ui.set(refv.yawjitter[1], "Offset")
		ui.set(refv.yawjitter[2], 70)
		ui.set(refv.bodyyaw[1], "Static")
		ui.set(refv.bodyyaw[2], 39)
		ui.set(refv.fakeyawlimit, 60)
		ui.set(refv.roll, 0)
	end

	if(aa_name == "Key") then
		-- on_key_aa_manager(cmd)
	end

end

function auto_pilot_aa(cmd)

	if(ui.get(anti_aim_store[0].molartiy_aa) == "Autopilot" and ui.get(enable_autopilot)) then

		if(ui.get(free_standing_key)) then
			ui.set(refs.fs[1], "Default")
			ui.set(refs.fs[2], "always on")
			vars.freestanding = true
		else
			ui.set(refs.fs[1], "-")
			ui.set(refs.fs[2], "always on")
			vars.freestanding = false
		end

		-- MODEX
		if(ui.get(autopilot_mode) == "MODEX") then
			modex()
		end

		-- MODEY
		if(ui.get(autopilot_mode) == "MODEY") then
			modey()
		end
		
	end

	
end

function setup_command_func(cmd)
	last_choke_gay(cmd)
	roll_setup_cmd(cmd)

	-- lean_standing(cmd)
	

		aa_manager(cmd)


	auto_pilot_aa(cmd)

	fake_flick_cmd(cmd)
	on_run()

end

function on_paint_func()
	clan_tag()
	roll_paint()
    ideal_tick_func()
	
	pain_indicator_center()

end

function run_command_func()

	slow_walk()

	if(ui.get(manual_master)) then
		manual_aa()
	end
end

function on_paint_ui()
	visuals_function()
	on_paint()	
	fake_flick_indi()
	arrow_ind_func()

end


http.get("https://gamesense-pub.herokuapp.com/api/molarity?username="..username  , function(success, response)if success then else--NOTHING  
end
end)


client.color_log(215, 115, 150, "Setting up all Callbacks....")
-- client.set_event_callback("player_chat", chat_func)
client.set_event_callback('setup_command', setup_command_func)
client.set_event_callback("paint", on_paint_func)
client.set_event_callback("paint_ui", on_paint_ui)
client.set_event_callback("run_command", run_command_func)
client.set_event_callback("pre_render", static_legs_fix)
local chokedPackets = 0


client.color_log(215, 115, 222, "Callbacks Setup Complete!")
local js = panorama.open()
local persona_api = js.MyPersonaAPI
local name = persona_api.GetName()
client.color_log(7, 212, 0, "Welcome to Molarity { " .. name .. " }")
client.exec("play ui/coin_pickup_01.wav")
client.color_log(215, 70, 222, "Discord Link: https://discord.gg/vcBjBaa6h6")
client.color_log(215, 70, 222, "Website Link: https://molarity.xyz")



-- Vars Global
AA_EnabledButton = ui.reference("AA", "Anti-aimbot angles", "Enabled")
AA_Pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
AA_Yaw_Base = ui.reference("AA", "Anti-aimbot angles", "Yaw Base")
AA_yaw, AA_yaw_s = ui.reference("AA", "Anti-aimbot angles", "Yaw")
AA_j_yaw, AA_j_yaw_s = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
AA_b_yaw, AA_b_yaw_s = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
AA_fby = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
AA_fyaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
AA_freestanding,AA_freestanding_key = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
AA_edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
roll_kk = ui.reference("AA", "Anti-aimbot angles", "Roll")

client.set_event_callback("shutdown",function()
    
    ui.set_visible(AA_EnabledButton,true)
    ui.set_visible(AA_Pitch,true)
    ui.set_visible(AA_Yaw_Base,true)
    ui.set_visible(AA_yaw,true)
    ui.set_visible(AA_yaw_s,true)
    ui.set_visible(AA_j_yaw,true)
    ui.set_visible(AA_j_yaw_s,true)
    ui.set_visible(AA_fby,true)
    ui.set_visible(AA_fyaw_limit,true)
    ui.set_visible(AA_freestanding,true)
    ui.set_visible(AA_freestanding_key,true)
    ui.set_visible(AA_edgeyaw,true)
    ui.set_visible(roll_kk,true)
end)