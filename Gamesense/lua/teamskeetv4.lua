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

local VGUI_System010 =  client_create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast(ffi.typeof('void***'), VGUI_System010 )

local IEngineClient__GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)")
local INetChannelInfo__GetAvgLoss = vtable_thunk(11, "float (__thiscall*)(void* ecx, int flow)")
local INetChannelInfo__GetAvgChoke = vtable_thunk(12, "float (__thiscall*)(void* ecx, int flow)")

local function get_loss()
    local pInfo = IEngineClient__GetNetChannelInfo()
    return INetChannelInfo__GetAvgLoss(pInfo, 1)
end

local function get_choke()
    local pInfo = IEngineClient__GetNetChannelInfo()
    return INetChannelInfo__GetAvgChoke(pInfo, 1)
end

local get_clipboard_text_count = ffi_cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local function clipboard_import( )
  	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	local clipboard_data = ""

	if clipboard_text_length > 0 then
		buffer = ffi.new("char[?]", clipboard_text_length)
		size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

		get_clipboard_text( VGUI_System, 0, buffer, size )

		clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	end
	return clipboard_data
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local ref = {
	enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui_reference("AA", "Anti-aimbot angles", "pitch"),
	yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    fakeyawlimit = ui_reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    lowerbodyyaw = ui_reference("AA", "Anti-aimbot angles", "Lower body yaw target"),
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
	freestand = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui_reference("AA", "Other", "On shot anti-aim") },
	slow = { ui_reference("AA", "Other", "Slow motion") },
	dt = { ui_reference("RAGE", "Other", "Double tap") },
	ps = { ui_reference("RAGE", "Other", "Double tap") },
	fakelag = { ui_reference("AA", "Fake lag", "Enabled") }
}

local var = {
	legit_changed = false,
	player_states = {"Global", "Standing", "Moving", "Slow motion", "Air", "On-key"},
	state_to_idx = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slow motion"] = 4, ["Air"] = 5, ["On-key"] = 6},
	aa_dir   = 0,
	auto_rage = false,
	active_i = 1,
	last_press_t = 0,
	forward = false,
	p_state = 0,
	last_sway_time = 0,
	choked_cmds = 0,
	ts_time = 0,
	miss = {},
	on_shot_mode = "KEY",
	custom_keys = {},
	custom_key_saves = {},
	hit = {},
	shots = {},
	last_hit = {},
	stored_misses = {},
	stored_shots = {},
	last_nn = 0,
	hotkey_modes1 = { "ALWAYS ON", "HELD", "TOGGLED", "OFF HOTKEY" },
	hotkey_modes = { "Always on", "On hotkey", "Toggle", "Off hotkey" },
	best_value = 180,
	flip_value = 90,
	bestenemy = 0,
	flip_once = false,
	clantag_enbl = false,
	dragging = false,
	disable_fs = false,
	disable_edge = false,
	initialized = false,
	ox = 0, 
	oy = 0,
	last_selected = 0,
	classnames = {
	"CWorld",
	"CCSPlayer",
	"CFuncBrush"
	},
	nonweapons = {
	"knife",
	"hegrenade",
	"inferno",
	"flashbang",
	"decoy",
	"smokegrenade",
	"taser"
	},
	ts_clantag = "t e a m s k e e t . l u a"
}

local plist_aa = {}
for i=0, 64 do
	plist_aa[i] = ui_new_combobox("PLAYERS", "Adjustments", "Override desync\n" .. tostring(i), {"-", "Freestanding", "Small", "Spin"})
	ui_set_visible(plist_aa[i], false)
end

local anti_aim = { }

anti_aim[0] = {
	anti_aim_mode = ui_new_combobox("AA", "Anti-aimbot angles", "Anti-aim mode", {"Rage", "Legit", "Automatic rage"}),
	player_state = ui_new_combobox("AA", "Anti-aimbot angles", "Player state", var.player_states),
	onshot_aa_settings = ui_new_multiselect("AA", "Other", "On shot anti-aim", {"While standing", "While moving", "On slow-mo", "In air", "While crouching", "On key"}),
	onshot_aa_key =  ui_new_hotkey("AA", "Other", "On shot anti-aim key", false),
}
ui_set_visible(ref.maxprocticks, true)

for i=1, 6 do
	anti_aim[i] = {
        enable = i == 6 and ui_new_hotkey("AA", "Anti-aimbot angles", "Enable " .. string_lower(var.player_states[i]) .. " anti-aim") or ui_new_checkbox("AA", "Anti-aimbot angles", "Enable " .. string_lower(var.player_states[i]) .. " anti-aim"),
		pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch\n" .. var.player_states[i], { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
		yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base\n" .. var.player_states[i], { "Local view", "At targets" }),
		yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw\n" .. var.player_states[i], { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
		yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add" .. var.player_states[i], -180, 180, 0),
		yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter\n" .. var.player_states[i], { "Off", "Offset", "Center", "Random" }),
		yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add" .. var.player_states[i], -180, 180, 0),
		aa_mode = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw type\n" .. var.player_states[i], {"Teamskeet", "GameSense"}),
		gs_bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw\n GS" .. var.player_states[i], { "Off", "Opposite", "Jitter", "Static" }),
		gs_bodyyawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nBody yaw add" .. var.player_states[i], -180, 180, 0),
		bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw\n" .. var.player_states[i], { "Off", "Opposite", "Freestanding", "Reversed Freestanding", "Jitter", "Switch key"}),
		bodyyaw_settings = ui_new_multiselect("AA", "Anti-aimbot angles", "Body yaw settings\n" .. var.player_states[i], { "Jitter when vulnerable", "Anti-resolver", "Detect missed angle"}),
		lowerbodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw\n" .. var.player_states[i], { "Off", "Sway", "Half sway", "Opposite", "Eye yaw"}),
		fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit\n" .. var.player_states[i], 0, 60, 60),
		fakeyawmode = ui_new_combobox("AA", "Anti-aimbot angles", "Customize fake yaw limit\n" .. var.player_states[i], { "Off", "Jitter", "Random", "Custom right" }),
		fakeyawamt = ui_new_slider("AA", "Anti-aimbot angles", "\nFake yaw randomization" .. var.player_states[i], 0, 60, 0),
	}
end
ui_set(anti_aim[1].enable, true)
ui_set_visible(anti_aim[1].enable, false)

anti_aim[7] = {
	tp_lethal = ui_new_checkbox("AA", "Fake lag", "Teleport on lethal"),
	aa_settings = ui_new_multiselect("AA", "Fake lag", "Anti-aim settings", {"Anti-aim on use", "Disable use to plant", "Custom on-shot anti-aim", "On-key resets manual AA"}),
	legit_sett = ui_new_multiselect("AA", "Fake lag", "Disable Anti-aim", { "High ping", "High loss", "High choke", "Low FPS", "Show values" }),
	
	ping = ui_new_slider("AA", "Fake lag", "Disable if ping >", 0, 1000, 150),
	choke = ui_new_slider("AA", "Fake lag", "Disable if choke >=", 0, 100, 1),
	loss = ui_new_slider("AA", "Fake lag", "Disable if loss >=", 0, 100, 1),
	fps = ui_new_slider("AA", "Fake lag", "Disable if fps <", 0, 300, 64),

	manual_enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Manual anti-aim"),
	manual_left = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual left"),
	manual_right = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual right"),
	manual_back = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual back"),
	switch_k = ui_new_hotkey("AA", "Anti-aimbot angles", "Body yaw switch key"),

	freestand = { ui_new_checkbox("AA", "Anti-aimbot angles", "Freestanding\nTS"),
				ui_new_hotkey("AA", "Anti-aimbot angles", "Freestanding key", true),
				ui_new_multiselect("AA", "Fake lag", "Disable freestanding", { "While slow walking", "In air", "While crouching", "While fakeducking" }) 
	},

	edge = { ui_new_checkbox("AA", "Anti-aimbot angles", "Edge yaw\nTS"), 
			ui_new_hotkey("AA", "Anti-aimbot angles", "Edge yaw key", true),
			ui_new_multiselect("AA", "Fake lag", "Disable edye yaw", { "While slow walking", "In air", "While crouching", "While fakeducking" }) 
	},
	
	ind_set = ui_new_multiselect("AA", "Other", "Teamskeet ESP", {"Indicators", "Key states", "Anti-aim", "Clantag"}),
	ind_sli = ui_new_multiselect("AA", "Other", "Indicator settings", {"Desync", "Fake lag", "Speed", "Gradient", "Show values", "Big", "Remove skeet indicators"}),
	ind_clr = ui_new_color_picker("AA", "Other", "Indicator color picker", 175, 255, 0, 255),
	aa_ind_type = ui_new_combobox("AA", "Other", "Anti-aim indicator type", {"Arrows", "Circle", "Static"}),
	ind_clr2 = ui_new_color_picker("AA", "Other", "Indicator desync color", 0, 200, 255, 255),
	
	pos_x = ui_new_slider("LUA", "B", "\nSaved Position X TS INDICATOR", 0, 10000, 10),
	pos_y = ui_new_slider("LUA", "B", "\nSaved Position Y TS INDICATOR", 0, 10000, 420)
}

ui_set_visible(anti_aim[7].pos_x, false)
ui_set_visible(anti_aim[7].pos_y, false)

for i=1, 64 do
    var.miss[i], var.hit[i], var.shots[i], var.last_hit[i], var.stored_misses[i], var.stored_shots[i] = {}, {}, {}, 0, 0, 0
	for k=1, 3 do
		var.miss[i][k], var.hit[i][k], var.shots[i][k] = {}, {}, {}
		for j=1, 1000 do
			var.miss[i][k][j], var.hit[i][k][j], var.shots[i][k][j] = 0, 0, 0
		end
	end
	var.miss[i][4], var.hit[i][4], var.shots[i][4] = 0, 0, 0
end

local function contains(table, value)

	if table == nil then
		return false
	end
	
    table = ui_get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function set_og_menu(state)
	ui_set_visible(ref.pitch, state)
	ui_set_visible(ref.yawbase, state)
	ui_set_visible(ref.yaw[1], state)
	ui_set_visible(ref.yaw[2], state)
	ui_set_visible(ref.yawjitter[1], state)
	ui_set_visible(ref.yawjitter[2], state)
	ui_set_visible(ref.bodyyaw[1], state)
	ui_set_visible(ref.bodyyaw[2], state)
	ui_set_visible(ref.fakeyawlimit, state)
	ui_set_visible(ref.fsbodyyaw, state)
	ui_set_visible(ref.edgeyaw, state)
	ui_set_visible(ref.freestand[1], state)
	ui_set_visible(ref.freestand[2], state)
	ui_set_visible(ref.lowerbodyyaw, state)
	ui_set_visible(ref.os[1], not contains(anti_aim[7].aa_settings, "Custom on-shot anti-aim"))
	ui_set_visible(ref.os[2], not contains(anti_aim[7].aa_settings, "Custom on-shot anti-aim"))
end

local function handle_menu(hide_all)
    var.active_i = var.state_to_idx[ui_get(anti_aim[0].player_state)]
	set_og_menu(false)

	local show_menu = tostring(hide_all) ~= "hide"

	local sk = false
	local rage = ui_get(anti_aim[0].anti_aim_mode) == "Rage"
	local legit = ui_get(anti_aim[0].anti_aim_mode) == "Legit"
	local auto = ui_get(anti_aim[0].anti_aim_mode) == "Automatic rage"
	local selected = ui_get(ref.player_list)

	ui_set_visible(anti_aim[0].player_state, not auto and show_menu)

	if selected ~= var.last_selected and selected ~= nil then
		ui_set_visible(plist_aa[selected], true)
		if var.last_selected ~= 0 then
			ui_set_visible(plist_aa[var.last_selected], false)
		end
		var.last_selected = selected
	end

    for i=1, 6 do
		ui_set_visible(anti_aim[i].enable, var.active_i == i and i > 1 and show_menu)
		
        ui_set_visible(anti_aim[i].pitch, rage and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].yawbase, rage and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].yaw, rage and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].yawadd, rage and var.active_i == i and ui_get(anti_aim[var.active_i].yaw) ~= "Off" and show_menu)
		ui_set_visible(anti_aim[i].yawjitter,rage and  var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].yawjitteradd, rage and var.active_i == i and ui_get(anti_aim[var.active_i].yawjitter) ~= "Off" and show_menu)

		local gs_aa = ui_get(anti_aim[i].aa_mode) == "GameSense"
		ui_set_visible(anti_aim[i].aa_mode, not auto and var.active_i == i and show_menu)

		ui_set_visible(anti_aim[i].gs_bodyyaw, not auto and gs_aa and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].gs_bodyyawadd, not auto and gs_aa and var.active_i == i and ui_get(anti_aim[i].gs_bodyyaw) ~= "Off" and ui_get(anti_aim[i].gs_bodyyaw) ~= "Opposite" and show_menu)

		ui_set_visible(anti_aim[i].bodyyaw, not auto and var.active_i == i and not gs_aa and show_menu)
		ui_set_visible(anti_aim[i].bodyyaw_settings, not auto and not gs_aa and var.active_i == i and ui_get(anti_aim[i].bodyyaw) ~= "Off" and show_menu)

		ui_set_visible(anti_aim[i].lowerbodyyaw, not auto and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].fakeyawlimit, not auto and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].fakeyawmode, not auto and var.active_i == i and show_menu)
		ui_set_visible(anti_aim[i].fakeyawamt, not auto and var.active_i == i and ui_get(anti_aim[i].fakeyawmode) ~= "Off" and show_menu)

		if ui_get(anti_aim[i].bodyyaw) == "Switch key" and ui_get(anti_aim[i].enable) then
			sk = true
		end
	end

	local show_legit = ui_get(anti_aim[0].anti_aim_mode) == "Legit" and show_menu
	ui_set_visible(anti_aim[7].legit_sett, show_legit)

	ui_set_visible(anti_aim[7].fps, show_legit and contains(anti_aim[7].legit_sett, "Low FPS") and contains(anti_aim[7].legit_sett, "Show values"))
	ui_set_visible(anti_aim[7].ping, show_legit and contains(anti_aim[7].legit_sett, "High ping") and contains(anti_aim[7].legit_sett, "Show values"))
	ui_set_visible(anti_aim[7].choke, show_legit and contains(anti_aim[7].legit_sett, "High choke") and contains(anti_aim[7].legit_sett, "Show values"))
	ui_set_visible(anti_aim[7].loss, show_legit and contains(anti_aim[7].legit_sett, "High loss") and contains(anti_aim[7].legit_sett, "Show values"))

	ui_set_visible(anti_aim[7].switch_k, ui_get(anti_aim[var.active_i].bodyyaw) == "Switch key" and show_menu)
	ui_set_visible(anti_aim[7].aa_ind_type, contains(anti_aim[7].ind_set, "Anti-aim"))
	ui_set_visible(anti_aim[7].ind_clr2, contains(anti_aim[7].ind_set, "Anti-aim"))

	ui_set_visible(anti_aim[7].freestand[1], not legit)
	ui_set_visible(anti_aim[7].edge[1], not legit)
	ui_set_visible(anti_aim[7].freestand[2], not legit)
	ui_set_visible(anti_aim[7].edge[2], not legit)

	ui_set_visible(anti_aim[7].freestand[3], not legit and ui_get(anti_aim[7].freestand[1]))
	ui_set_visible(anti_aim[7].edge[3], not legit and ui_get(anti_aim[7].edge[1]))

	ui_set_visible(anti_aim[7].manual_enable, not legit)
	ui_set_visible(anti_aim[7].manual_left, not legit and ui_get(anti_aim[7].manual_enable))
	ui_set_visible(anti_aim[7].manual_right, not legit and ui_get(anti_aim[7].manual_enable))
    ui_set_visible(anti_aim[7].manual_back, not legit and ui_get(anti_aim[7].manual_enable))
    
    ui_set_visible(anti_aim[0].onshot_aa_settings, contains(anti_aim[7].aa_settings, "Custom on-shot anti-aim"))
    ui_set_visible(anti_aim[0].onshot_aa_key, contains(anti_aim[7].aa_settings, "Custom on-shot anti-aim"))
end
handle_menu(nil)

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math_atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math_pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local c_tag = {
	i = 1,
	a = 1,
	c = 0
}
local function animate_string()
	local str = ""
	local cur = 0

	if c_tag.i == 0 then
		str = str .. "|"
	end

	for i in string.gmatch(var.ts_clantag, "%S+") do
		cur = cur + 1
		str = str .. i

		if c_tag.i == cur then
			str = str .. "|"
		end

		if cur > c_tag.c then
			c_tag.c = cur
		end
	end

	if c_tag.i >= c_tag.c then
		c_tag.a = -1
	elseif c_tag.i <= 0 then
		c_tag.a = 1
	end

	c_tag.i = c_tag.i + c_tag.a
	return str
end

local function arr_to_string(arr)
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

local function str_to_sub(input, sep)
	local t = {}
	for str in string_gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string_gsub(str, "\n", "")
	end
	return t
end

local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end

local function get_key_mode(ref, secondary)
	local k = { ui_get(ref) }
	local hk_mode = k[2]
	if hk_mode == nil then
		return "nil"
	end
    return secondary == nil and var.hotkey_modes[hk_mode + 1] or var.hotkey_modes1[hk_mode + 1]
end

local function angle_vector(angle_x, angle_y)
	local sy = math_sin(math_rad(angle_y))
	local cy = math_cos(math_rad(angle_y))
	local sp = math_sin(math_rad(angle_x))
	local cp = math_cos(math_rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_eye_pos(ent)
	local x, y, z = entity_get_prop(ent, "m_vecOrigin")
	local hx, hy, hz = entity_hitbox_position(ent, 0)
	return x, y, hz
end

local function rotate_point(x, y, rot, size)
	return math_cos(math_rad(rot)) * size + x, math_sin(math_rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer_triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
	end
	
    return math_deg(math_atan2(ydelta, xdelta))
end

local function get_damage(plocal, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local ent, dmg = 0
	for i=0, 6 do
		if dmg == 0 or dmg == nil then
			ent, dmg = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		end
	end
	return ent == nil and client_scale_damage(plocal, 1, dmg) or dmg
end

local function get_nearest_enemy(plocal, enemies)
	local lx, ly, lz = client_eye_position()
	local view_x, view_y, roll = client_camera_angles()

	local bestenemy = nil
    local fov = 180
    for i=1, #enemies do
        local cur_x, cur_y, cur_z = entity_get_prop(enemies[i], "m_vecOrigin")
        local cur_fov = math_abs(normalize_yaw(calc_shit(lx - cur_x, ly - cur_y) - view_y + 180))
        if cur_fov < fov then
			fov = cur_fov
			bestenemy = enemies[i]
		end
	end

	return bestenemy
end

local function is_valid(nn)
	if nn == 0 then
		return false
	end

	if not entity_is_alive(nn) then
		return false
	end

	if entity_is_dormant(nn) then
		return false
	end

	return true
end


local function get_best_desync()
    local plocal = entity_get_local_player()

    local lx, ly, lz = client_eye_position()
	local view_x, view_y, roll = client_camera_angles()

	if ui_get(anti_aim[var.p_state].bodyyaw) == "Switch key" and not var.auto_rage then
		local should_flip = false

		if var.flip_once and ui_get(anti_aim[7].switch_k) then
			var.flip_value = var.flip_value == 90 and -90 or 90
			var.flip_once = false
		elseif not ui_get(anti_aim[7].switch_k) then
			var.flip_once = true
		end
	end

    local enemies = entity_get_players(true)

	if #enemies == 0 then
		
		if not var.auto_rage then
			if ui_get(anti_aim[var.p_state].bodyyaw) == "Opposite" then
				var.best_value = 180
			elseif ui_get(anti_aim[var.p_state].bodyyaw) == "Jitter" then
				var.best_value = 0
			elseif ui_get(anti_aim[var.p_state].bodyyaw) == "Switch key" then
				var.best_value = var.flip_value
			else
				var.best_value = 90
			end
		else
			var.best_value = 90
		end

		return var.best_value
    end

	var.bestenemy = is_valid(var.last_nn) and var.last_nn or get_nearest_enemy(plocal, enemies)

    if var.bestenemy ~= nil and var.bestenemy ~= 0 and entity_is_alive(var.bestenemy) then
        local calc_hit = var.last_hit[var.bestenemy] ~= 0 and contains(anti_aim[var.p_state].bodyyaw_settings, "Anti-resolver")
        local calc_miss = var.miss[var.bestenemy][4] > 0 and contains(anti_aim[var.p_state].bodyyaw_settings, "Anti-resolver")

		if not calc_hit and not calc_miss then
            local e_x, e_y, e_z = entity_hitbox_position(var.bestenemy, 0)

            local yaw = calc_angle(lx, ly, e_x, e_y)
            local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
			local rend_x = lx + rdir_x * 10
            local rend_y = ly + rdir_y * 10
            
            local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
			local lend_x = lx + ldir_x * 10
            local lend_y = ly + ldir_y * 10
            
			local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
			local r2end_x = lx + r2dir_x * 100
			local r2end_y = ly + r2dir_y * 100

			local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
			local l2end_x = lx + l2dir_x * 100
            local l2end_y = ly + l2dir_y * 100      
			
			local ldamage = get_damage(plocal, var.bestenemy, rend_x, rend_y, lz)
			local rdamage = get_damage(plocal, var.bestenemy, lend_x, lend_y, lz)

			local l2damage = get_damage(plocal, var.bestenemy, r2end_x, r2end_y, lz)
			local r2damage = get_damage(plocal, var.bestenemy, l2end_x, l2end_y, lz)

			if not var.auto_rage and ldamage > 0 and rdamage > 0 and contains(anti_aim[var.p_state].bodyyaw_settings, "Jitter when vulnerable") then
				var.best_value = 0
			else
				if not var.auto_rage then
					if ui_get(anti_aim[var.p_state].bodyyaw) == "Opposite" then
						var.best_value = 180
					elseif ui_get(anti_aim[var.p_state].bodyyaw) == "Jitter" then
						var.best_value = 0
					elseif ui_get(anti_aim[var.p_state].bodyyaw) == "Switch key" then
						var.best_value = var.flip_value
					else
						if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
							var.best_value = ui_get(anti_aim[var.p_state].bodyyaw) == "Freestanding" and -90 or 90
						elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
							var.best_value = ui_get(anti_aim[var.p_state].bodyyaw) == "Freestanding" and 90 or -90
						end
					end
				else
					if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
						var.best_value = 90
					elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
						var.best_value = -90
					end
				end
			end
        elseif calc_hit then
            var.best_value = var.last_hit[var.bestenemy] == 90 and -90 or 90
        elseif calc_miss then
			if var.stored_misses[var.bestenemy] ~= var.miss[var.bestenemy][4] then
                var.best_value = var.miss[var.bestenemy][2][var.miss[var.bestenemy][4]]
                var.stored_misses[var.bestenemy] = var.miss[var.bestenemy][4]
            end
        end
	else
		if not var.auto_rage and ui_get(anti_aim[var.p_state].bodyyaw) == "Opposite" then
			var.best_value = 180
		elseif not var.auto_rage and ui_get(anti_aim[var.p_state].bodyyaw) == "Jitter" then
			var.best_value = 0
		elseif not var.auto_rage and ui_get(anti_aim[var.p_state].bodyyaw) == "Switch key" then
			var.best_value = var.flip_value
		else
			var.best_value = 90
		end
	end
    return var.best_value
end

local function run_direction()

	ui_set(anti_aim[7].switch_k, "On hotkey")
	ui_set(ref.freestand[2], "Always on")
	ui_set(anti_aim[7].manual_back, "On hotkey")
	ui_set(anti_aim[7].manual_left, "On hotkey")
	ui_set(anti_aim[7].manual_right, "On hotkey")

	local k = { ui_get(anti_aim[6].enable) }

	if (k[1] and k[3] == 69) or ui_get(anti_aim[0].anti_aim_mode) == "Legit" then
		ui_set(ref.freestand[1], "-")
		ui_set(ref.edgeyaw, false)

		if contains(anti_aim[7].aa_settings, "On-key resets manual AA") then
			var.aa_dir = 0
			var.last_press_t = globals_curtime()
		end

		return
	end

	local fs_e = ui_get(anti_aim[7].freestand[2]) and ui_get(anti_aim[7].freestand[1]) and not disable_fs
	local edge_e = ui_get(anti_aim[7].edge[2]) and ui_get(anti_aim[7].edge[1]) and not disable_edge

	ui_set(ref.freestand[1], fs_e and "Default" or "-")
	ui_set(ref.edgeyaw, edge_e)

	if fs_e or not ui_get(anti_aim[7].manual_enable) then
		var.aa_dir = 0
		var.last_press_t = globals_curtime()
	else
		if ui_get(anti_aim[7].manual_back) then
			var.aa_dir = 0
		elseif ui_get(anti_aim[7].manual_right) and var.last_press_t + 0.2 < globals_curtime() then
			var.aa_dir = var.aa_dir == 90 and 0 or 90
			var.last_press_t = globals_curtime()
		elseif ui_get(anti_aim[7].manual_left) and var.last_press_t + 0.2 < globals_curtime() then
			var.aa_dir = var.aa_dir == -90 and 0 or -90
			var.last_press_t = globals_curtime()
		elseif var.last_press_t > globals_curtime() then
			var.last_press_t = globals_curtime()
		end
	end
end

local function run_shit(c)
	local plocal = entity_get_local_player()

	local vx, vy, vz = entity_get_prop(plocal, "m_vecVelocity")

	local p_still = math_sqrt(vx ^ 2 + vy ^ 2) < 2
	local on_ground = bit_band(entity_get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui_get(ref.slow[1]) and ui_get(ref.slow[2])
	local p_key = ui_get(anti_aim[6].enable) and not var.auto_rage

	local wpn = entity_get_player_weapon(plocal)
	local wpn_id = entity_get_prop(wpn, "m_iItemDefinitionIndex")
	local m_item = bit_band(wpn_id, 0xFFFF)

	local onshotaa = false
	local doubletapping = ui_get(ref.dt[1]) and ui_get(ref.dt[2])

	var.p_state = 1
	disable_edge = false
	disable_fs = false

	if p_key then
		var.p_state = 6
	else
		if not on_ground and ui_get(anti_aim[5].enable) then
			var.p_state = 5
		else
			if p_slow and ui_get(anti_aim[4].enable) then
				var.p_state = 4
			else
				if p_still and ui_get(anti_aim[2].enable) then
					var.p_state = 2
				elseif not p_still and ui_get(anti_aim[3].enable) then
					var.p_state = 3
				end
			end
		end
	end

	if not on_ground then

		if contains(anti_aim[7].edge[3], "In air") then
			disable_edge = true
		end

		if contains(anti_aim[7].freestand[3], "In air") then
			disable_fs = true
		end

		onshotaa = contains(anti_aim[0].onshot_aa_settings, "In air")
		var.on_shot_mode = contains(anti_aim[0].onshot_aa_settings, "In air") and "IN AIR" or var.on_shot_mode
	else
		if p_slow then

			if contains(anti_aim[7].edge[3], "While slow walking") then
				disable_edge = true
			end
	
			if contains(anti_aim[7].freestand[3], "While slow walking") then
				disable_fs = true
			end

			onshotaa = contains(anti_aim[0].onshot_aa_settings, "On slow-mo")
			var.on_shot_mode = contains(anti_aim[0].onshot_aa_settings, "On slow-mo") and "SLOW-MO" or var.on_shot_mode
		else
			if c.in_duck == 1 and not ui_get(ref.fakeduck) then
				
				if contains(anti_aim[7].edge[3], "While crouching") then
					disable_edge = true
				end
		
				if contains(anti_aim[7].freestand[3], "While crouching") then
					disable_fs = true
				end

				onshotaa = contains(anti_aim[0].onshot_aa_settings, "While crouching")
				var.on_shot_mode = contains(anti_aim[0].onshot_aa_settings, "While crouching") and "CROUCHING" or var.on_shot_mode
			elseif not ui_get(ref.fakeduck) then
				onshotaa = p_still and contains(anti_aim[0].onshot_aa_settings, "While standing") or contains(anti_aim[0].onshot_aa_settings, "While moving")
				var.on_shot_mode = (contains(anti_aim[0].onshot_aa_settings, "While standing") or contains(anti_aim[0].onshot_aa_settings, "While moving")) and (p_still and "STANDING" or "MOVING") or var.on_shot_mode
			else
				onshotaa = false

				if contains(anti_aim[7].edge[3], "While fakeducking") then
					disable_edge = true
				end
		
				if contains(anti_aim[7].freestand[3], "While fakeducking") then
					disable_fs = true
				end
			end
		end
	end

	if ui_get(anti_aim[0].onshot_aa_key) and not ui_get(ref.fakeduck) then
		var.on_shot_mode = get_key_mode(anti_aim[0].onshot_aa_key, 1)
		onshotaa = true
	end

    if contains(anti_aim[7].aa_settings, "Custom on-shot anti-aim") then
		ui_set(ref.os[2], "Always on")
        ui_set(ref.os[1], onshotaa and m_item ~= 64 and not ui_get(ref.dt[2]))
    else
        var.on_shot_mode = get_key_mode(ref.os[2], 1)
    end
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function entity_has_c4(ent)
	local bomb = entity_get_all("CC4")[1]
	return bomb ~= nil and entity_get_prop(bomb, "m_hOwnerEntity") == ent
end

local function scan_dmg(e, p, x, y, z)
	for i=1, 6 do
		local h = { entity_hitbox_position(e, i) }
		local ent, dmg = client_trace_bullet(p, x, y, z, h[1], h[2], h[3], p)

		if dmg ~= nil and dmg > 0 then
			return dmg
		end
	end
	return 0
end

local o_o = { 0, 0, 0 }
local last_shot = 0

local function tp_peek()
	if not ui_get(ref.dt[2]) or not ui_get(anti_aim[7].tp_lethal) then
		return
	end

	if last_shot + 1 > globals_curtime() then
		ui_set(ref.dt[1], true)
		return
	end

	local plocal = entity_get_local_player()
	local o = { entity_get_prop(plocal, "m_vecOrigin") }
	local eye = { client_eye_position() }

	o[3] = eye[3]

	if o == nil then 
		return
	end

	--movement per tick
	local v = { o[1] - o_o[1], o[2] - o_o[2], o[3] - o_o[3] }

	local tp_ticks = ui_get(ref.maxprocticks) - ui_get(ref.dt_limit)
	
	v = {v[1]*tp_ticks, v[2]*tp_ticks, v[3]*tp_ticks}

	p = { o[1] + v[1], o[2] + v[2], o[3] - v[3]}

	o_o = o

	if var.bestenemy == 0 or var.bestenemy == nil or not is_valid(var.bestenemy) then
		ui_set(ref.dt[1], true)
		return
	end

	local dmg = scan_dmg(var.bestenemy, plocal, p[1], p[2], p[3])

	if dmg > entity_get_prop(var.bestenemy, "m_iHealth") then
		ui_set(ref.dt[1], false)
		return
	end

	ui_set(ref.dt[1], true)
end

client_set_event_callback("aim_fire", function(e)
	last_shot = globals_curtime()
end)

local function aa_on_use(c)

	if contains(anti_aim[7].aa_settings, "Anti-aim on use") then
		local plocal = entity_get_local_player()
		
		local distance = 100
		local bomb = entity_get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(plocal, "m_vecOrigin")
			distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity_get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity_get_prop(plocal, "m_bInBombZone")

		local has_bomb = entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not contains(anti_aim[7].aa_settings, "Disable use to plant")
		
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
			for i=0, #var.classnames do
				if entity_get_classname(entindex) == var.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			c.in_use = 0
		end
	end
end

local function handle_shots()
	local enemies = entity_get_players(true)

	for i=1, #enemies do
		local idx = enemies[i]
		local s = var.shots[idx][4]
		local h = var.hit[idx][4]

		if s ~= var.stored_shots[idx] then
			local missed = true
			
			if var.shots[idx][1][s] == var.hit[idx][1][h] then
				if var.hit[idx][2][h] ~= 0 and var.hit[idx][2][h] ~= 180 then
					var.last_hit[idx] = var.hit[idx][2][h]
				end
				missed = false
			end

			if missed then
				var.last_hit[idx] = 0
				var.hit[idx][2][h] = 0
				var.miss[idx][4] = var.miss[idx][4] + 1
				var.miss[idx][2][var.miss[idx][4]] = var.shots[idx][2][s]
			end

			var.last_nn = idx
			var.stored_shots[idx] = s
		end
	end
end

local frametimes = {}
local fps_prev = 0
local last_update_time = 0
local function get_fps()
    local ft = globals_absoluteframetime()
    if ft > 0 then
        table_insert(frametimes, 1, ft)
    end
    local count = #frametimes
    if count == 0 then
        return 0
    end
    local i, accum = 0, 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end
    accum = accum / i
    while i < count do
        i = i + 1
        table_remove(frametimes)
    end
    local fps = 1 / accum
    local rt = globals_realtime()
    if math_abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
        fps_prev = fps
        last_update_time = rt
    else
        fps = fps_prev
    end
    return math_floor(fps + 0.5)
end

local function should_use_aa()
	local ping = client.latency() * 1000
	local choke = get_choke() * 100
	local loss = get_loss() * 100
	local fps = get_fps()

	if contains(anti_aim[7].legit_sett, "High ping") and ping > ui_get(anti_aim[7].ping) then
		return false
	end

	if contains(anti_aim[7].legit_sett, "High choke") and choke > ui_get(anti_aim[7].choke) then
		return false
	end

	if contains(anti_aim[7].legit_sett, "High loss") and loss > ui_get(anti_aim[7].loss) then
		return false
	end

	if contains(anti_aim[7].legit_sett, "Low FPS") and fps < ui_get(anti_aim[7].fps) then
		return false
	end

	return true
end

local js = panorama.open()
local GameStateAPI = js.GameStateAPI
local function resolver_improvements()
	local enemies = entity_get_players(true)

	if #enemies == 0 then
		return
	end

	for i=1, #enemies do
		local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(enemies[i])
		local is_bot = GameStateAPI.IsFakePlayer(xuid)
	
		if is_bot then
			plist_set(enemies[i], "Correction active", false)
		end
	end
end

local function on_setup_command(c)

    if not ui_get(ref.enabled) then
        return
	end

	run_shit(c)
	run_direction()
	handle_shots()
	aa_on_use(c)
	resolver_improvements()
	local best_desync = get_best_desync()
	tp_peek()

	local k = { ui_get(anti_aim[6].enable) }

	local doubletapping = ui_get(ref.dt[1]) and ui_get(ref.dt[2])
	local onshotaa = ui_get(ref.os[1]) and ui_get(ref.os[2])
	local low_legit_fl = ui_get(ref.fl_limit) < 3 and ui_get(anti_aim[0].anti_aim_mode) == "Legit"
	local exploiting = doubletapping or onshotaa or low_legit_fl

	local holding_e = (k[1] and k[3] == 69) or (var.auto_rage and client_key_state(69))
	local yaw_to_add = holding_e and 0 or var.aa_dir
	var.forward = ui_get(ref.yaw[2]) == 180

	ui_set(ref.fsbodyyaw, ui_get(plist_aa[var.bestenemy]) == "Freestanding")

	if ui_get(anti_aim[0].anti_aim_mode) == "Rage" then
		ui_set(ref.pitch, ui_get(anti_aim[var.p_state].pitch))
		ui_set(ref.yawbase, var.aa_dir == 0 and ui_get(anti_aim[var.p_state].yawbase) or "Local view")
		ui_set(ref.yaw[1], ui_get(anti_aim[var.p_state].yaw))
		ui_set(ref.yaw[2], normalize_yaw(ui_get(anti_aim[var.p_state].yawadd) + yaw_to_add))
		ui_set(ref.yawjitter[1], ui_get(anti_aim[var.p_state].yawjitter))
		ui_set(ref.yawjitter[2], ui_get(anti_aim[var.p_state].yawjitteradd))
	elseif holding_e or ui_get(anti_aim[0].anti_aim_mode) == "Legit" then
		ui_set(ref.pitch, "Off")
		ui_set(ref.yawbase, "Local view")
		ui_set(ref.yaw[1], "Off")
		ui_set(ref.yaw[2], 180)
	else
		ui_set(ref.pitch, "Default")
		ui_set(ref.yawbase, var.aa_dir == 0 and "At targets" or "Local view")
		ui_set(ref.yaw[1], "180")
		ui_set(ref.yaw[2], yaw_to_add)
		ui_set(ref.yawjitter[1], "Off")
	end

	if ui_get(plist_aa[var.bestenemy]) == "Spin" then
		ui_set(ref.yaw[1], "Spin")
		ui_set(ref.yaw[2], 40)
	end

	local fakelimit = var.auto_rage and 60 or ui_get(anti_aim[var.p_state].fakeyawlimit)
	local fakemode = var.auto_rage and "Random" or ui_get(anti_aim[var.p_state].fakeyawmode)
	local fakeamt = var.auto_rage and 30 or ui_get(anti_aim[var.p_state].fakeyawamt)
	local lby = var.auto_rage and "Half sway" or ui_get(anti_aim[var.p_state].lowerbodyyaw)

	if fakemode == "Jitter" then
		fakelimit = client_random_int(0, 1) == 1 and fakeamt or fakelimit
	elseif fakemode == "Random" then
		fakelimit = client_random_int(math_max(math_min(60, fakelimit - fakeamt), 0), fakelimit)
	elseif fakemode == "Smart" then
		fakelimit = best_desync == 90 and 40 or fakelimit
	end

	if ui_get(plist_aa[var.bestenemy]) == "Small" then
		fakelimit = fakelimit / 2
	end

	ui_set(ref.fakeyawlimit, holding_e and 60 or fakelimit)

	local should_disable = not should_use_aa() and ui_get(anti_aim[0].anti_aim_mode) == "Legit"

	if var.auto_rage then
		if best_desync == 0 or best_desync == 180 then
			ui_set(ref.bodyyaw[1], best_desync == 0 and "Jitter" or "Opposite")
			ui_set(ref.bodyyaw[2], 0)
		else
			ui_set(ref.bodyyaw[1], "Static")
			ui_set(ref.bodyyaw[2], var.forward and -best_desync or best_desync)
		end
	else
		if ui_get(anti_aim[var.p_state].aa_mode) == "Teamskeet" then
			if ui_get(anti_aim[var.p_state].bodyyaw) ~= "Off" and not should_disable then
				if best_desync == 0 or best_desync == 180 then
					ui_set(ref.bodyyaw[1], best_desync == 0 and "Jitter" or "Opposite")
					ui_set(ref.bodyyaw[2], 0)
				else
					ui_set(ref.bodyyaw[1], "Static")
					ui_set(ref.bodyyaw[2], var.forward and -best_desync or best_desync)
				end
			else
				ui_set(ref.bodyyaw[1], "Off")
			end
		else
			ui_set(ref.bodyyaw[1], ui_get(anti_aim[var.p_state].gs_bodyyaw))
			ui_set(ref.bodyyaw[2], ui_get(anti_aim[var.p_state].gs_bodyyawadd))
		end
	end

	--lowerbody
	if holding_e or (var.auto_rage and exploiting) then
		ui_set(ref.lowerbodyyaw, exploiting and "Eye yaw" or "Opposite")
	else
		if lby ~= "Half sway" then
			ui_set(ref.lowerbodyyaw, (lby == "Opposite" and (exploiting or best_desync == 0)) and "Eye yaw" or lby)
		else
			if var.last_sway_time + 1.1 < globals_curtime() then
				ui_set(ref.lowerbodyyaw, ui_get(ref.lowerbodyyaw) == "Eye yaw" and "Opposite" or "Eye yaw")
				var.last_sway_time = globals_curtime()
			elseif var.last_sway_time > globals_curtime() then
				var.last_sway_time = globals_curtime()
			end
		end
	end
	
	var.choked_cmds = c.chokedcommands
	set_og_menu(false)
end

local function is_dragging(x, y, w, h)
	local mx, my = ui_mouse_position()
	local click = client_key_state(0x01)
	
	local in_x = mx > x and mx < x + w	
	local in_y = my > y and my < y + h 

	return in_x and in_y and click and ui_is_menu_open()
end

local function is_dragging_menu()
	local x, y = ui_mouse_position()
	local px, py = ui_menu_position()
	local sx, sy = ui_menu_size()
	local click = client_key_state(0x01)
	
	local in_x = x > px and x < px + sx	
	local in_y = y > py and y < py + sy 

	return in_x and in_y and click and ui_is_menu_open()
end

local function run_clantag()
	if contains(anti_aim[7].ind_set, "Clantag") then
		local time = globals.tickcount() * globals.tickinterval()

		if var.ts_time + 0.3 < time then
			client_set_clan_tag(animate_string())
			var.ts_time = time
		elseif var.ts_time > time then
			var.ts_time = time
		end
		
		var.clantag_enbl = true
	elseif not contains(anti_aim[7].ind_set, "Clantag") and var.clantag_enbl then
		client_set_clan_tag("")
		var.clantag_enbl = false
	end
end

local function run_remove_skeet()
	if contains(anti_aim[7].ind_sli, "Remove skeet indicators") then
		for i=1, 400 do
			renderer_indicator(0, 0, 0, 0, " ")
		end
	end
end

local function run_dragging()
	local click = client_key_state(0x01)
	local mx, my = ui_mouse_position()
	local x, y = ui_get(anti_aim[7].pos_x), ui_get(anti_aim[7].pos_y)
	local sx, sy = client_screen_size()

	if var.dragging then
		local dx, dy = x - var.ox, y - var.oy
		ui_set(anti_aim[7].pos_x, math_min(math_max(mx + dx, 0), sx))
		ui_set(anti_aim[7].pos_y, math_min(math_max(my + dy, 0), sy))
		var.ox, var.oy = mx, my
	else
		var.ox, var.oy = mx, my
	end
end

local function get_sliders(plocal)
	local arr = {}

	local desync = entity_get_prop(plocal, "m_flPoseParameter", 11) * 116 - 58
	local vx, vy, vz = entity_get_prop(plocal, "m_vecVelocity")
	local speed = math_sqrt(vx ^ 2 + vy ^ 2)

	if contains(anti_aim[7].ind_sli, "Desync") and ui_get(ref.enabled) then
		arr[#arr + 1] = {
			v = round(desync, 0),
			p = math_abs(desync / 58),
			t = "FAKE YAW",
		}
	end

	if contains(anti_aim[7].ind_sli, "Fake lag") then
		arr[#arr + 1] = {
			v = var.choked_cmds,
			p = var.choked_cmds / (ui_get(ref.maxprocticks) - 2),
			t = "FAKE LAG"
		}
	end

	if contains(anti_aim[7].ind_sli, "Speed") then
		arr[#arr + 1] = {
			v = round(speed),
			p = speed / 250,
			t = "VELOCITY"
		}
	end
	return arr
end

local function get_chk(chk)
	return chk == nil and true or ui_get(chk)
end

local function get_keys()
	local arr = {}

	if ui_get(ref.fakeduck) then
		arr[#arr + 1] = {
			t = "FAKE DUCK",
			v = get_key_mode(ref.fakeduck, 1)
		}
	end

	if ui_get(anti_aim[7].edge[1]) and ui_get(anti_aim[7].edge[2]) and not disable_edge then
		arr[#arr + 1] = {
			t = "EDGE YAW",
			v = get_key_mode(anti_aim[7].edge[2], 1)
		}
	end
	
	if ui_get(anti_aim[6].enable) and not var.auto_rage then
		arr[#arr + 1] = {
			t = "ON-KEY AA",
			v = get_key_mode(anti_aim[6].enable, 1)
		}
	end
	
	if ui_get(ref.os[1]) and ui_get(ref.os[2]) then
		arr[#arr + 1] = {
			t = "ONSHOT AA",
			v = var.on_shot_mode
		}
	end
	
	if ui_get(ref.dt[1]) and ui_get(ref.dt[2]) then
		arr[#arr + 1] = {
			t = "DOUBLE TAP",
			v = get_key_mode(ref.dt[2], 1)
		}
	end
	
	if ui_get(ref.safepoint) then
		arr[#arr + 1] = {
			t = "SAFE POINT",
			v = get_key_mode(ref.safepoint, 1)
		}
	end

	if ui_get(ref.forcebaim) then
		arr[#arr + 1] = {
			t = "FORCE BAIM",
			v = get_key_mode(ref.forcebaim, 1)
		}
	end
	
	if ui_get(anti_aim[7].freestand[1]) and ui_get(anti_aim[7].freestand[2]) and not disable_fs then
		arr[#arr + 1] = {
			t = "FREESTANDING",
			v = get_key_mode(anti_aim[7].freestand[2], 1)
		}
	end
	
	if ui_get(ref.quickpeek[1]) and ui_get(ref.quickpeek[2]) then
		arr[#arr + 1] = {
			t = "QUICK PEEK",
			v = get_key_mode(ref.quickpeek[2], 1)
		}
	end
	
	for i=1, #var.custom_keys do
		if ui_get(var.custom_keys[i].ref) and get_chk(var.custom_keys[i].chk) then
			arr[#arr + 1] = {
				t = var.custom_keys[i].name,
				v = get_key_mode(var.custom_keys[i].ref, 1)
			}
		end
	end

	return arr
end

local function on_paint()
	local plocal = entity_get_local_player()

	run_clantag()
	run_remove_skeet()

	if not entity_is_alive(plocal) then
		return
	end

	tp_peek()

	local click = client_key_state(0x01)
	local sx, sy = client_screen_size()
	local cx, cy = sx / 2, sy / 2 - 2
	local r, g, b, a = ui_get(anti_aim[7].ind_clr)
	local r1, g1, b1, a1 = ui_get(anti_aim[7].ind_clr2)

	local x, y = ui_get(anti_aim[7].pos_x), ui_get(anti_aim[7].pos_y)

	local sliders, keys = {}, {}
	local scale = contains(anti_aim[7].ind_sli, "Big") and 1.5 or 1
	local w, h = 200 * scale, 20 * scale		
	local i_dist = scale == 1 and 16 or 18 

	if contains(anti_aim[7].ind_set, "Indicators") then

		sliders = get_sliders(plocal)

		renderer_rectangle(x, y, w, h, 20, 20, 20, 255)
		renderer_text(x + w/2, y + i_dist/2, 255, 255, 255, 255, scale == 1 and "-c" or "cb", nil, "INDICATORS")	
		
        if contains(anti_aim[7].ind_sli, "Gradient") then
            renderer_gradient(x, y, w/2, scale^2, 0, 200, 255, 255, 255, 0, 255, 255, true)
            renderer_gradient(x + w/2, y, w/2, scale^2, 255, 0, 255, 255, 175, 255, 0, 255, true)
        else
			renderer_rectangle(x, y, w, scale^2, r, g, b, a)
			renderer_rectangle(x, y, w, scale^2, r, g, b, a)
		end

		local m_h = (#sliders * i_dist)

		renderer_rectangle(x, y+i_dist, w, m_h, 25, 25, 25, 255)
		renderer_rectangle(x, y+i_dist + m_h, w, 5, 20, 20, 20, 255)

		for i=1, #sliders do
            renderer_text(x + 5, y + ((i + 1) * i_dist) - 15, 255, 255, 255, 255, scale == 1 and "-" or "b", nil, sliders[i].t)

			local stx = x + math_floor(w/4.5) - 1
			local sty = y + ((i + 1) * i_dist) - 14
			local m_w = math_floor(w/1.33) + (scale == 1 and 0 or 1)
			local height = scale == 1 and h/2.25 or h/2.75

			if contains(anti_aim[7].ind_sli, "Show values") then
				stx = x + math_floor(w/3.25)
				sty = y + ((i + 1) * i_dist) - 14
				m_w = math_floor(w/1.5)
				renderer_text(x + math_floor(w/4.5), y + ((i + 1) * i_dist) - 15, 255, 255, 255, 255, scale == 1 and "-" or "", nil, sliders[i].v)
			end

			local width = math_max(math_min(m_w, m_w * sliders[i].p), 5)

			if contains(anti_aim[7].ind_sli, "Gradient") then
				renderer_gradient(stx, sty, math_floor(m_w/2), height, 0, 200, 255, 255, 255, 0, 255, 255, true)
				renderer_gradient(stx + math_floor(m_w/2), sty, math_floor(m_w/2), height, 255, 0, 255, 255, 175, 255, 0, 255, true)
				renderer_rectangle(stx + 1, sty + 1, m_w - 2, height - 2, 25, 25, 25, 150)

				local amt = m_w - width
				if amt > 0 then
					renderer_rectangle(x + w - 5 - amt, sty, amt, height, 25, 25, 25, 255)
				end
			else
				renderer_rectangle(stx, sty, width, height, r, g, b, a)
				renderer_rectangle(stx + 1, sty + 1, width - 2, height - 2, 25, 25, 25, 150)
			end
		end
		
		if is_dragging(x, y, w, h + m_h) and not is_dragging_menu() then
			var.dragging = true
		elseif not click then
			var.dragging = false
		end
	end

	if contains(anti_aim[7].ind_set, "Key states") then
		local x2, y2 = x, y + h + (#sliders * i_dist) + 5

		renderer_rectangle(x2, y2, w, h, 20, 20, 20, 255)
		renderer_text(x2 + w/2, y2 + i_dist/2, 255, 255, 255, 255, scale == 1 and "-c" or "cb", nil, "KEYBINDS")
		
		if contains(anti_aim[7].ind_sli, "Gradient") then
            renderer_gradient(x2, y2, w/2, scale^2, 0, 200, 255, 255, 255, 0, 255, 255, true)
            renderer_gradient(x2 + w/2, y2, w/2, scale^2, 255, 0, 255, 255, 175, 255, 0, 255, true)
        else
			renderer_rectangle(x2, y2, w, scale^2, r, g, b, a)
			renderer_rectangle(x2, y2, w, scale^2, r, g, b, a)
		end

		keys = get_keys()

        renderer_rectangle(x2, y2 + i_dist, w, #keys * i_dist + (4 * scale^2), 25, 25, 25, 255)

		for i=1, #keys do
			local tw, th = renderer_measure_text(scale == 1 and "-" or "b", keys[i].v)
			local cur_pos = y2 + ((i + 1) * i_dist) - 13
			if contains(anti_aim[7].ind_sli, "Gradient") then
				renderer_text(x2 + 5, cur_pos, 100, 200, 255, 255,  scale == 1 and "-" or "b", nil, keys[i].t)
				renderer_text(x2 + w - 10 - tw, cur_pos, 175, 255, 0, 255, scale == 1 and "-" or "b", nil, keys[i].v)
			else
				renderer_text(x2 + 5, cur_pos, r, g, b, a, scale == 1 and "-" or "b", nil, keys[i].t)
				renderer_text(x2 + w - 10 - tw, cur_pos, 255, 255, 255, 255, scale == 1 and "-" or "b", nil, keys[i].v)
			end
		end
				
		if is_dragging(x2, y2, w, (#keys * i_dist) + h) and not is_dragging_menu() then
			var.dragging = true
		elseif not click then
			var.dragging = false
		end
	end

	if contains(anti_aim[7].ind_set, "Anti-aim") then	
		local cam = vector(client_camera_angles())

		local h = vector(entity_hitbox_position(plocal, "head_0"))
		local p = vector(entity_hitbox_position(plocal, "pelvis"))
	
		local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
		local bodyyaw = entity_get_prop(plocal, "m_flPoseParameter", 11) * 120 - 60
	
		local fakeangle = normalize_yaw(yaw + bodyyaw)

		if ui_get(anti_aim[7].aa_ind_type) == "Circle" then	
			renderer_circle_outline(cx, cy + 1, 100, 100, 100, 100, 30, 0, 1, 4)
			renderer_circle_outline(cx, cy + 1, r, g, b, a, 30, (fakeangle * -1) - 15, 0.1, 4)
			renderer_circle_outline(cx, cy + 1, r1, g1, b1, a1, 30, (yaw * -1) - 15, 0.1, 4)
		elseif ui_get(anti_aim[7].aa_ind_type) == "Arrows" then	
			renderer_arrow(cx, cy, r, g, b, a, (yaw - 25) * -1, 45)
			renderer_arrow(cx, cy, r1, g1, b1, a1, (fakeangle - 25) * -1, 25)
		else
			renderer_triangle(cx + 55, cy + 2, cx + 42, cy - 7, cx + 42, cy + 11, 
			var.aa_dir == 90 and r or 35, 
			var.aa_dir == 90 and g or 35, 
			var.aa_dir == 90 and b or 35, 
			var.aa_dir == 90 and a or 150)

			renderer_triangle(cx - 55, cy + 2, cx - 42, cy - 7, cx - 42, cy + 11, 
			var.aa_dir == -90 and r or 35, 
			var.aa_dir == -90 and g or 35, 
			var.aa_dir == -90 and b or 35, 
			var.aa_dir == -90 and a or 150)
			
			renderer_rectangle(cx + 38, cy - 7, 2, 18, 
			bodyyaw < -10 and r1 or 35,
			bodyyaw < -10 and g1 or 35,
			bodyyaw < -10 and b1 or 35,
			bodyyaw < -10 and a1 or 150)
			renderer_rectangle(cx - 40, cy - 7, 2, 18,			
			bodyyaw > 10 and r1 or 35,
			bodyyaw > 10 and g1 or 35,
			bodyyaw > 10 and b1 or 35,
			bodyyaw > 10 and a1 or 150)
		end
	end

	run_dragging(dragging)
end

local function dist_from_3dline(shooter, e)
	local x, y, z = entity_hitbox_position(shooter, 0)
	local x1, y1, z1 = client_eye_position()

	return ((e.y - y)*x1 - (e.x - x)*y1 + e.x*y - e.y*x) / math_sqrt((e.y-y)^2 + (e.x - x)^2)
end

local function on_bullet_impact(e)
	local plocal = entity_get_local_player()
	local shooter = client_userid_to_entindex(e.userid)

	if not entity_is_enemy(shooter) or not entity_is_alive(plocal) then
		return
	end

	local d = dist_from_3dline(shooter, e)

	if math_abs(d) < 100 then
		local dsy = var.forward and (ui_get(ref.bodyyaw[2]) * -1) or ui_get(ref.bodyyaw[2])

		local previous_record = var.shots[shooter][1][var.shots[shooter][4]] == globals_curtime()
		var.shots[shooter][4] = previous_record and var.shots[shooter][4] or var.shots[shooter][4] + 1

		var.shots[shooter][1][var.shots[shooter][4]] = globals_curtime()

		local dtc = (not var.forward and not var.auto_rage and contains(anti_aim[var.p_state].bodyyaw_settings, "Detect missed angle")) or dsy == 0 or dsy == 180

		if dtc then
			var.shots[shooter][2][var.shots[shooter][4]] = math_abs(d) > 0.5 and (d < 0 and 90 or -90) or dsy
		else
			var.shots[shooter][2][var.shots[shooter][4]] = (dsy == 90 and -90 or 90)
		end
	end
end

local function on_player_hurt(e)
	local plocal = entity_get_local_player()
	local victim = client_userid_to_entindex(e.userid)
	local attacker = client_userid_to_entindex(e.attacker)

	if not entity_is_enemy(attacker) or not entity_is_alive(plocal) then
		return
	end

	for i=1, #var.nonweapons do
		if e.weapon == var.nonweapons[i] then
			return
		end
	end

	local dsy = var.forward and (ui_get(ref.bodyyaw[2]) * -1) or ui_get(ref.bodyyaw[2])

	var.hit[attacker][4] = var.hit[attacker][4] + 1
	var.hit[attacker][1][var.hit[attacker][4]] = globals_curtime()
	var.hit[attacker][2][var.hit[attacker][4]] = victim ~= plocal and 0 or dsy
	var.hit[attacker][3][var.hit[attacker][4]] = e.hitgroup
end

local function reset_data(keep_hit)
	for i=1, 64 do
		var.last_hit[i], var.stored_misses[i], var.stored_shots[i] = (keep_hit and var.hit[i][2][var.hit[i][4]] ~= 0) and var.hit[i][2][var.hit[i][4]] or 0, 0, 0
		for k=1, 3 do
			for j=1, 1000 do
				var.miss[i][k][j], var.hit[i][k][j], var.shots[i][k][j] = 0, 0, 0
			end
		end
		var.miss[i][4], var.hit[i][4], var.shots[i][4], var.last_nn, var.best_value = 0, 0, 0, 0, 180
	end
end

local function load_cfg(input)
	local tbl = str_to_sub(input, "|")

	for i=1, 6 do
		ui_set(anti_aim[i].enable, to_boolean(tbl[1 + (16 * (i - 1))]))
		ui_set(anti_aim[i].pitch, tbl[2 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawbase, tbl[3 + (16 * (i - 1))])
		ui_set(anti_aim[i].yaw, tbl[4 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawadd, tonumber(tbl[5 + (16 * (i - 1))]))
		ui_set(anti_aim[i].yawjitter, tbl[6 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawjitteradd, tonumber(tbl[7 + (16 * (i - 1))]))
		ui_set(anti_aim[i].aa_mode, tbl[8 + (16 * (i - 1))])
		ui_set(anti_aim[i].bodyyaw, tbl[9 + (16 * (i - 1))])
		ui_set(anti_aim[i].bodyyaw_settings, str_to_sub(tbl[10 + (16 * (i - 1))], ","))	
		ui_set(anti_aim[i].lowerbodyyaw, tbl[11 + (16 * (i - 1))])
		ui_set(anti_aim[i].fakeyawlimit, tonumber(tbl[12 + (16 * (i - 1))]))
		ui_set(anti_aim[i].fakeyawmode, tbl[13 + (16 * (i - 1))])
		ui_set(anti_aim[i].fakeyawamt, tonumber(tbl[14 + (16 * (i - 1))]))
		ui_set(anti_aim[i].gs_bodyyaw, tbl[15 + (16 * (i - 1))])
		ui_set(anti_aim[i].gs_bodyyawadd, tonumber(tbl[16 + (16 * (i - 1))]))
	end

	ui_set(anti_aim[7].manual_enable, to_boolean(tbl[97]))
	ui_set(anti_aim[0].onshot_aa_settings, str_to_sub(tbl[98], ","))
	ui_set(anti_aim[7].ind_set, str_to_sub(tbl[99], ","))
	ui_set(anti_aim[7].ind_sli, str_to_sub(tbl[100], ","))
	ui_set(anti_aim[7].aa_ind_type, tbl[101])
	ui_set(anti_aim[7].aa_settings, str_to_sub(tbl[102], ","))
	ui_set(anti_aim[7].tp_lethal, tbl[103])

	client_log("Loaded config from clipboard")
end

local function export_cfg()
	local str = ""

	for i=1, 6 do
		local get_key = i == 6 and get_key_mode or ui_get

		str = str .. tostring(get_key(anti_aim[i].enable)) .. "|"
		.. tostring(ui_get(anti_aim[i].pitch)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawbase)) .. "|"
		.. tostring(ui_get(anti_aim[i].yaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawadd)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawjitter)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawjitteradd)) .. "|"
		.. tostring(ui_get(anti_aim[i].aa_mode)) .. "|"
		.. tostring(ui_get(anti_aim[i].bodyyaw)) .. "|"
		.. arr_to_string(anti_aim[i].bodyyaw_settings) .. "|"
		.. tostring(ui_get(anti_aim[i].lowerbodyyaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawlimit)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawmode)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawamt)) .. "|"
		.. tostring(ui_get(anti_aim[i].gs_bodyyaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].gs_bodyyawadd)) .. "|"
	end

	str = str .. tostring(ui_get(anti_aim[7].manual_enable)) .. "|"
	.. arr_to_string (anti_aim[0].onshot_aa_settings) .. "|"
	.. arr_to_string (anti_aim[7].ind_set) .. "|"
	.. arr_to_string (anti_aim[7].ind_sli) .. "|"
	.. tostring(ui_get(anti_aim[7].aa_ind_type)) .. "|"
	.. arr_to_string (anti_aim[7].aa_settings) .. "|"
	.. tostring(ui_get(anti_aim[7].tp_lethal))
	clipboard_export(str)
	client_log("Exported config to clipboard")
end

local function add_custom_key(input)
	local str = string_gsub(input, "//add_keybind ", "")

	local subs = str_to_sub(str, ",")

	local ref1, ref2 = nil, nil
	local got_reference = pcall(function() ref1, ref2 = ui_reference(subs[1], subs[2], subs[3]) end)

	if got_reference and #subs == 4 then
		var.custom_keys[#var.custom_keys + 1] = {
			ref = ref2 == nil and ref1 or ref2,
			chk = ref2 == nil and nil or ref1,
			name = subs[4]
		}

		var.custom_key_saves[#var.custom_key_saves + 1] = str
		client_log("Succesfully added " .. subs[4] .. " to the keybinds list!")
	else
		if got_reference then
			client_log("You forgot to add the name of the key you fucking retard")
		else
			client_log("Failed to add the key :( Couldn't find it in the menu")
		end	
	end
end

local function load_kace()
	for i=2, 5 do
		ui_set(anti_aim[i].enable, false)
	end
	--global
	ui_set(anti_aim[1].pitch, "Default")
	ui_set(anti_aim[1].yawbase, "At targets")
	ui_set(anti_aim[1].yaw, "180")
	ui_set(anti_aim[1].yawadd, 0)
	ui_set(anti_aim[1].yawjitter, "Off")
	ui_set(anti_aim[1].yawjitteradd, 0)
	ui_set(anti_aim[1].aa_mode, "Teamskeet")
	ui_set(anti_aim[1].bodyyaw, "Reversed freestanding")
	ui_set(anti_aim[1].bodyyaw_settings, {"Anti-resolver", "Jitter when vulnerable"})
	ui_set(anti_aim[1].lowerbodyyaw, "Half sway")
	ui_set(anti_aim[1].fakeyawlimit, 60)
	ui_set(anti_aim[1].fakeyawmode, "Custom right")
	ui_set(anti_aim[1].fakeyawamt, 35)
	--slow motion
	ui_set(anti_aim[4].enable, true)
	ui_set(anti_aim[4].pitch, "Default")
	ui_set(anti_aim[4].yawbase, "At targets")
	ui_set(anti_aim[4].yaw, "180")
	ui_set(anti_aim[4].yawadd, 0)
	ui_set(anti_aim[4].yawjitter, "Off")
	ui_set(anti_aim[4].yawjitteradd, 0)
	ui_set(anti_aim[4].aa_mode, "GameSense")
	ui_set(anti_aim[4].gs_bodyyaw, "Static")
	ui_set(anti_aim[4].gs_bodyyawadd, 60)
	ui_set(anti_aim[4].lowerbodyyaw, "Eye yaw")
	ui_set(anti_aim[4].fakeyawlimit, 40)
	ui_set(anti_aim[4].fakeyawmode, "Jitter")
	ui_set(anti_aim[4].fakeyawamt, 30)
	--air
	ui_set(anti_aim[5].enable, true)
	ui_set(anti_aim[5].pitch, "Default")
	ui_set(anti_aim[5].yawbase, "At targets")
	ui_set(anti_aim[5].yaw, "180")
	ui_set(anti_aim[5].yawadd, 0)
	ui_set(anti_aim[5].yawjitter, "Off")
	ui_set(anti_aim[5].yawjitteradd, 0)
	ui_set(anti_aim[5].aa_mode, "Teamskeet")
	ui_set(anti_aim[5].bodyyaw, "Opposite")
	ui_set(anti_aim[5].bodyyaw_settings, {"Anti-resolver"})
	ui_set(anti_aim[5].lowerbodyyaw, "Opposite")
	ui_set(anti_aim[5].fakeyawlimit, 60)
	ui_set(anti_aim[5].fakeyawmode, "Off")
	--on-key
	ui_set(anti_aim[6].pitch, "Off")
	ui_set(anti_aim[6].yawbase, "Local view")
	ui_set(anti_aim[6].yaw, "180")
	ui_set(anti_aim[6].yawadd, 180)
	ui_set(anti_aim[6].yawjitter, "Off")
	ui_set(anti_aim[6].yawjitteradd, 0)
	ui_set(anti_aim[6].aa_mode, "Teamskeet")
	ui_set(anti_aim[6].bodyyaw, "Reversed freestanding")
	ui_set(anti_aim[6].bodyyaw_settings, {"Anti-resolver"})
	ui_set(anti_aim[6].lowerbodyyaw, "Opposite")
	ui_set(anti_aim[6].fakeyawlimit, 60)
	ui_set(anti_aim[6].fakeyawmode, "Off")
	ui_set(anti_aim[6].fakeyawamt, 0)

	ui_set(anti_aim[7].manual_enable, true)
	ui_set(anti_aim[0].onshot_aa_key, "Toggle")
	ui_set(anti_aim[0].onshot_aa_settings, {"On slow-mo", "While crouching", "On key"})
	ui_set(anti_aim[7].ind_set, {"Indicators", "Anti-aim", "Key states"})
	ui_set(anti_aim[7].ind_sli, {"Desync", "Fake lag", "Speed", "Gradient", "Big"})
	ui_set(anti_aim[7].aa_ind_type, "Arrows")

	ui_set(anti_aim[7].aa_settings, {"Anti-aim on use", "Disable use to plant", "Custom on-shot anti-aim"})
end

local function on_console_input(input)
	if string_find(input, "//load kace") then
		load_kace()

		client_log("Config loaded!")
	elseif string_find(input, "//load sigma") then
		client_log("Config loaded!")
		--global
		ui_set(anti_aim[1].pitch, "Default")
		ui_set(anti_aim[1].yawbase, "At targets")
		ui_set(anti_aim[1].yaw, "180")
		ui_set(anti_aim[1].yawadd, 0)
		ui_set(anti_aim[1].yawjitter, "Off")
		ui_set(anti_aim[1].yawjitteradd, 0)
		ui_set(anti_aim[1].aa_mode, "Teamskeet")
		ui_set(anti_aim[1].bodyyaw, "Reversed freestanding")
		ui_set(anti_aim[1].bodyyaw_settings, {"Anti-resolver", "Jitter when vulnerable"})
		ui_set(anti_aim[1].lowerbodyyaw, "Eye yaw")
		ui_set(anti_aim[1].fakeyawlimit, 60)
		ui_set(anti_aim[1].fakeyawmode, "Off")

		for i=2, 5 do
			ui_set(anti_aim[i].enable, false)
		end
		
		ui_set(anti_aim[7].manual_enable, true)
		ui_set(anti_aim[0].onshot_aa_key, "Toggle")
		ui_set(anti_aim[0].onshot_aa_settings, {"On key"})
		ui_set(anti_aim[7].ind_set, {"Indicators", "Anti-aim", "Key states"})
		ui_set(anti_aim[7].ind_sli, {"Desync", "Fake lag", "Speed", "Gradient"})
		ui_set(anti_aim[7].aa_ind_type, "Static")
	elseif string_find(input, "//help") then
		client_color_log(255, 255, 255, "|--------------------------------------------------------|")
		client_color_log(0, 150, 255, 	"[//load kace] Load Kace's AA settings")
		client_color_log(150, 0, 200,   "[//load sigma] Load Sigma's AA settings")
		client_color_log(225, 0, 225, 	"[//export] Export your anti-aim settings to your clipboard")
		client_color_log(255, 150, 175, "[//import] Import anti-aim settings from your clipboard")
		client_color_log(255, 150, 150, "[//add_keybind TAB,CONTAINER,ELEMENT,INDICATOR NAME] Add a custom keybind to the keybind indicator")
		client_color_log(255, 200, 60,  "[//keybinds] Lists the stored keybinds")
		client_color_log(230, 255, 60,  "[//remove_keybind #] Removes the selected keybind")
		client_color_log(175, 255, 0, 	"[//help] Print a list of commands")
		client_color_log(255, 255, 255, "|--------------------------------------------------------|")
		client_color_log()
	elseif string_find(input, "//export") then
		export_cfg()
	elseif string_find(input, "//import") then
		load_cfg(clipboard_import())
	elseif string_find(input, "//add_keybind") then
		add_custom_key(input)
	elseif string_find(input, "//keybinds") then
		for i=1, #var.custom_key_saves do
			local subs = str_to_sub(var.custom_key_saves[i], ",")
			client_log(i .. " - " .. subs[4])
		end
	elseif string_find(input, "//remove_keybind") then
		local t_str = string_gsub(input, "//remove_keybind ", "")

		local num = tonumber(t_str)
		local subs = str_to_sub(var.custom_key_saves[num], ",")

		if #var.custom_keys >= num and var.custom_keys[num].name == subs[4] then
			table_remove(var.custom_keys, num)
		end
		
		table_remove(var.custom_key_saves, num)
		database_write("ts_custom_keys", var.custom_key_saves)

		client_log("Succesfuly removed " .. tostring(subs[4]) .. " from the stored keybinds!")
	end
end

local function reset_plist()
	for i=0, 64 do
		ui_set(plist_aa[i], "-")
	end
end
client_delay_call(1, reset_plist)

local function apply_to_all()

	local cur_selected = ui_get(plist_aa[ui_get(ref.player_list)])

	if cur_selected == nil then
		return
	end

	for i=1, 64 do
		ui_set(plist_aa[i], cur_selected)
	end
end

local function handle_callbacks()
	client_color_log(255, 255, 255, "|--------------------------------------------------------|")
	client_color_log(0, 150, 255, 	"           Thanks for downloading Teamskeet V4!           ")
	client_color_log(150, 0, 200,   "            Type //help for a list of commands            ")
	client_color_log(225, 0, 225, 	"   Support the script: https://patreon.com/luascripting   ")
	client_color_log(255, 150, 175, "   For the best skeet configs: https://shoppy.gg/@amgis   ")
	client_color_log(255, 255, 0, 	" Join the discord for updates: https://discord.gg/eQj9fEe ")
	client_color_log(175, 255, 0, 	"Join the group:  https://steamcommunity.com/groups/kacelua")
	client_color_log(255, 255, 255, "|--------------------------------------------------------|")

    ui_set_callback(anti_aim[7].aa_settings, handle_menu)
	ui_set_callback(anti_aim[0].player_state, handle_menu)
	ui_set_callback(ref.player_list, handle_menu)
	ui_set_callback(anti_aim[7].legit_sett, handle_menu)
	ui_set_callback(anti_aim[7].manual_enable, handle_menu)
	ui_set_callback(anti_aim[7].ind_set, handle_menu)
	ui_set_callback(ref.reset_all, reset_plist)
	ui_set_callback(ref.apply_all, apply_to_all)
	ui_set_callback(ref.load_cfg, reset_plist)
	ui_set_callback(anti_aim[7].edge[1], handle_menu)
	ui_set_callback(anti_aim[7].freestand[1], handle_menu)

	for i=1, 6 do
		ui_set_callback(anti_aim[i].aa_mode, handle_menu)
		ui_set_callback(anti_aim[i].yaw, handle_menu)
		ui_set_callback(anti_aim[i].yawadd, handle_menu)
		ui_set_callback(anti_aim[i].bodyyaw, handle_menu)
        ui_set_callback(anti_aim[i].yawjitter, handle_menu)
        ui_set_callback(anti_aim[i].fakeyawmode, handle_menu)
	end

	ui_set_callback(anti_aim[0].anti_aim_mode, function()
		local mode = ui_get(anti_aim[0].anti_aim_mode)
		if mode ~= "Automatic rage" then
			var.auto_rage = false
			handle_menu()
		else

			ui_set(anti_aim[7].manual_enable, true)
			ui_set(anti_aim[0].onshot_aa_key, "Toggle")
			ui_set(anti_aim[0].onshot_aa_settings, {"On slow-mo", "While crouching", "On key"})
			ui_set(anti_aim[7].ind_set, {"Indicators", "Anti-aim", "Key states"})
			ui_set(anti_aim[7].ind_sli, {"Desync", "Fake lag", "Speed", "Gradient", "Big"})
			ui_set(anti_aim[7].aa_ind_type, "Arrows")
		
			ui_set(anti_aim[7].aa_settings, {"Anti-aim on use", "Disable use to plant", "Custom on-shot anti-aim"})

			handle_menu("hide")
			var.auto_rage = true
		end
	end)

	local stored = database_read("ts_custom_keys")

	if stored ~= nil then
		var.custom_key_saves = database_read("ts_custom_keys")
	end

	for i=1, #var.custom_key_saves do
		local subs = str_to_sub(var.custom_key_saves[i], ",")

		local ref1, ref2 = nil, nil
		if pcall(function() ref1, ref2 = ui_reference(subs[1], subs[2], subs[3]) end) then
			var.custom_keys[i] = {
				ref = ref2 == nil and ref1 or ref2,
				chk = ref2 == nil and nil or ref1,
				name = subs[4]
			}
		else
			client_log(subs[4] .. " not found!")
		end
	end
	
    client_set_event_callback("shutdown", function()
		set_og_menu(true)
		database_write("ts_custom_keys", var.custom_key_saves)
	end)

	client_set_event_callback("player_death", function(e)
		if client_userid_to_entindex(e.userid) == entity_get_local_player() then
			reset_data(true)
		end
	end)

	client_set_event_callback("round_start", function()
		reset_data(true)
	end)

	client_set_event_callback("client_disconnect", function()
		reset_data(false)
	end)

	client_set_event_callback("game_newmap", function()
		reset_data(false)
	end)

	client_set_event_callback("cs_game_disconnected", function()
		reset_data(false)
	end)
	
	client_set_event_callback("bullet_impact", on_bullet_impact)
	client_set_event_callback("player_hurt", on_player_hurt)
	client_set_event_callback("console_input", on_console_input)
	client_set_event_callback("setup_command", on_setup_command)
	client_set_event_callback("paint", on_paint)
end
handle_callbacks()