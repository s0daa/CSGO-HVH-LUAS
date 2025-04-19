-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local remove_obex_print = true
if remove_obex_print then client.exec("clear") end
local reached = false
local scripts = {}
--local automatic = database.read("automatic") or {}
local loader = function(name)
	print(("You already loaded: %s, %s"):format(name, automatic[name] and "You disabled Auto-Load on Startup!" or "You will now automaticly load this Module on Startup of the Lua!"))
	--automatic[name] = not automatic[name]
	--database.write("automatic", automatic)
end
scripts["Anti-Aim"] = function(name, check)
scripts[name] = loader
if check ~= secret and not reached then return end
print("Loading: ", name)
--      I				Paralyze your enemys
--		   hate
--				Discord
--						Code
--	Mewtwo.Technologies		 Preview



--ToDo:
--287,288 is a (.) In arrows that its not apperaring, because rn its broken that the Arrows Color are changing

local memorys = {}
local ffi = require("ffi")
local vector = require("vector")
local base64 = require("gamesense/base64")
local images = require("gamesense/images")
local clipboard = require("gamesense/clipboard")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local csgo_weapons = require("gamesense/csgo_weapons")
local trace  = require "gamesense/trace"
local gif_decoder = require "gamesense/gif_decoder"
local http = require "gamesense/http"
local js = panorama.open()
local api = js.MyPersonaAPI
local name = api.GetName()
local globals_realtime, client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_unset_event_callback, client_color_log, client_camera_position, client_create_interface, client_random_int, client_latency, client_find_signature, client_delay_call, client_trace_line, client_register_esp_flag, client_exec, client_key_state, client_set_cvar, client_unix_time, client_error_log, client_draw_debug_text, client_update_player_list, client_camera_angles, client_eye_position, client_draw_hitboxes, client_random_float, entity_get_local_player, entity_is_enemy, entity_get_all, entity_set_prop, entity_is_alive, entity_get_steam64, entity_get_classname, entity_get_player_resource, entity_is_dormant, entity_get_player_name, entity_get_origin, entity_hitbox_position, entity_get_player_weapon, entity_get_players, entity_get_prop, globals_absoluteframetime, globals_chokedcommands, globals_tickcount, globals_commandack, globals_lastoutgoingcommand, globals_curtime, globals_tickinterval, globals_framecount, globals_frametime, ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_new_checkbox, ui_new_multiselect, ui_new_hotkey, ui_set, ui_set_callback, ui_new_button, ui_new_label, ui_get, renderer_world_to_screen, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_indicator, math_atan2, math_rad, math_ceil, math_tan, math_cos, math_sinh, math_random, math_huge, math_pi, math_max, math_floor, math_sqrt, math_deg, math_atan, math_pow, math_abs, math_min, math_sin, math_log, table_concat, string_format, string_byte, string_char, bit_band, panorama_loadstring, panorama_open = globals.realtime, client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.unset_event_callback, client.color_log, client.camera_position, client.create_interface, client.random_int, client.latency, client.find_signature, client.delay_call, client.trace_line, client.register_esp_flag, client.exec, client.key_state, client.set_cvar, client.unix_time, client.error_log, client.draw_debug_text, client.update_player_list, client.camera_angles, client.eye_position, client.draw_hitboxes, client.random_float, entity.get_local_player, entity.is_enemy, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.is_dormant, entity.get_player_name, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop, globals.absoluteframetime, globals.chokedcommands, globals.tickcount, globals.commandack, globals.lastoutgoingcommand, globals.curtime, globals.tickinterval, globals.framecount, globals.frametime, ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.new_multiselect, ui.new_hotkey, ui.set, ui.set_callback, ui.new_button, ui.new_label, ui.get, renderer.world_to_screen, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.indicator, math.atan2, math.rad, math.ceil, math.tan, math.cos, math.sinh, math.random, math.huge, math.pi, math.max, math.floor, math.sqrt, math.deg, math.atan, math.pow, math.abs, math.min, math.sin, math.log, table.concat, string.format, string.byte, string.char, bit.band, panorama.loadstring, panorama.open
memorys.reference = {
    fakelag = ui.reference("AA", "Fake lag", "Limit"),
    dt = { ui_reference("RAGE", "Aimbot", "Double tap") },
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    fd = ui_reference("RAGE", "Other", "Duck peek assist"),
    hs = { ui_reference("AA", "Other", "On shot anti-aim") },
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    slowwalk = { ui_reference("AA", "Other", "Slow motion") },
    sp_key = ui_reference("RAGE", "Aimbot", "Force safe point"),
    fakelag_amount = ui_reference("AA", "Fake lag", "Amount"),
    fakelag_variance = ui_reference("AA", "Fake lag", "Variance"),
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    yawj = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
    fs = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    antiuntrusted = ui.reference("Misc", "Settings", "Anti-untrusted"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    ping_spike = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
    bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
    ref_force_bodyaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    --fakelimit = ui_reference("AA", "Anti-aimbot angles", "Body Yaw"),
    fs_bodyyaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    --fakelag_maxusrcmd = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
}

memorys.ffi_helpers = {
	gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0],
	is_in_game = (function()
		local classptr = ffi.typeof("void***")
		local rawivengineclient = client.create_interface("engine.dll", "VEngineClient014")
		local ivengineclient = ffi.cast(classptr, rawivengineclient)
		local is_in_game = ffi.cast("bool(__thiscall*)(void*)", ivengineclient[0][26])
		return is_in_game
	end)()
}

memorys.data = {
	end_time = 0,
	ground_ticks = 0,
	last_freestand = 1,
	cached_missed = {},
	choked_reset = false,
	player_state = "Default",
	shooting_data = {false, 0},
	menu_directory = {"AA", "anti-aimbot angles"},
	last_miss_time = globals_curtime() + 0.005,
	freestand = {side = 1, last_side = 0, last_hit = 0, hit_side = 0},
	player_status = {"Default", "Stand", "Moving", "Slow walk", "In Air", "Air Crouch", "Crouch", "Shoot"},
	steamid = panorama.loadstring([[
		return MyPersonaAPI.GetXuid()
	]])(),

	manual_adjusts = {
		left = false,
		right = false,
		back = false,
	},

	ani = {
		dt = 0,
		onshot = 0,
		fd = 0,
		fs = 0,
		baim = 0,
		ping = 0,
		sp = 0,
		s = 0,
		xx = 0,
		x1 =0,
		y1 = 0,
		y2 = 0,
		y3 = 0,
		y4 = 0,
		y5 = 0,
		y6 = 0,
		y7 = 0,
		yy1 = 0,
		yy2 = 0,
		yy3 = 0,
		yy4 = 0,
		yy5 = 0,
		yy6 = 0,
		yy7 = 0,
		fs_alpha = 0,
		dt_alpha = 0,
		hide_alpha = 0,
		baim_alpha = 0,
		duck_alpha = 0,
		ping_alpha = 0,
		sp_alpha = 0,
		glow = 0,
		glow2 = 0
	}
}

memorys.data.elements = {
	main = {
		master_switch = ui_new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "\a12EC0997Enable \abbc4fbffMe\abbc4fbffwt\ac9bdf9ffwo.\ad6b6f7ffTe\ae4aff5ffch\ae4aff5ffno\afea1f1fflo\aff96edffgies"),
		element_groups = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "    						              \ad6b6f7ff + Main Navigator +", {"Anti-Aim", "Visuals", "Misc"}),
		owner_label = ui.new_label(memorys.data.menu_directory[1], memorys.data.menu_directory[2], " ")
	},

	antiaim = {
		master_switch = ui_new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "\a12EC0997Enable \ad6b6f7ffMewtwo.Technologies Anti-Aim"),
		handle_visible = ui_new_multiselect(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "\a00FFEA8D                + Display Manager +", {"Keys", "Anti-Bruteforce", "Custom"}),
		manual_left_dir = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Manual Left"),
		manual_right_dir = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Manual Right"),
		manual_backward_dir = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Manual Back"),
        freestanding = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Freestand"),
		edge = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Edge Yaw"), 
		roll_inverter = ui_new_hotkey(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Roll Inverter"),
		manual_state = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "\nManual status", 0, 3, 0),
		anti_bruteforce = ui_new_multiselect(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Mewtwo Anti-Bruteforce", {"On miss", "On hit"}),
		current_player_status = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Select Anti-Aim State:", memorys.data.player_status),
		shoot_condition = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Shooting Trigger Condition", {"On Unattack", "On Fired", "On Fast Fired"}),
		custom = (function()
			local elements = {}
			for idx, data in pairs(memorys.data.player_status) do
				elements[idx] = {
					enabled = ui_new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\a12EC0997Enable\aFFFFFFFF %s State "):format(data)),
					pitch = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("			[%s] Pitch"):format(data), {"Off", "Default", "Up", "Down", "Minimal", "Random",}),
					yaw_base = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("		[%s] Yaw base"):format(data), {"Local view", "At targets"}),
					yaw = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("		[%s] Yaw Add"):format(data), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
					yaw_slider = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Yaw Slider"):format(data), - 180, 180, 0, true, "°" ),
					yaw_slider_right = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Yaw Slider right"):format(data), - 180, 180, 0, true, "°" ),
					yaw_jitter = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s]Yaw jitter"):format(data), {"Off", "Offset", "Center", "Random", "Skitter"}),
					yaw_jitter_slider = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Yaw jitter Slider"):format(data), - 180, 180, 0, true, "°" ),
					yaw_jitter_slider_right = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Yaw jitter Slider right"):format(data), - 180, 180, 0, true, "°" ),
					body_yaw = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s] Body yaw"):format(data), {"Off", "Static", "Jitter", "Opposite", "Freestand", "Reserved freestand", "Calculation freestand"}),
					body_yaw_slider = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Body yaw Slider"):format(data), - 180, 180, 0, true, "°" ),
					fake_yaw = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s] Fake Yaw Mode"):format(data), {"Off", "Jitter", "Random", "Aggressive"}),
					fake_yaw_slider = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Fake Yaw Slider"):format(data), 0, 60, 60, true, "°" ),
					fake_yaw_slider_right = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Fake Yaw Slider Right"):format(data), 0, 60, 60, true, "°" ),
					fake_yaw_slider_extended = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s] Fake Yaw Extended Angle"):format(data), 0, 60, 60, true, "°" ),
					extended_angle = ui_new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s] Extended Angle/Roll [Force 60 Fake Limit]"):format(data)),
					extended_angle_mode = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s] Extended Angle Mode"):format(data), {"Off", "Jitter", "Random", "Aggressive"}),
					extended_angle_slider = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Extended Angle Slider"):format(data), - 100, 100, 0, true, "°" ),
					extended_angle_slider_right = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("\n%s Extended Angle Slider Right"):format(data), - 100, 100, 0, true, "°" ),
					extended_angle_extra = ui_new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], ("[%s]Extended Angle Extra Angle"):format(data), - 100, 100, 0, true, "°" ),
				}
			end

			ui.set(elements[1].enabled, true)
			ui.set_visible(elements[1].enabled, false)
			return elements
		end)(),

	},

	visuals = {
		master_switch = ui_new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "\a12EC0997Enable \ad6b6f7ffMewtwo Visuals"),
		indication_list = ui_new_multiselect(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Indication list", {"Crosshair Indicator","Manual Arrows","Debug Window"}),
		crosshair_indicator_mode = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Crosshair Indicator Type", {"v1", "v2"}),
		crosshair_color_alab = ui.new_label(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Indicator Color Main"),
		crosshair_color_a = ui.new_color_picker(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Crosshair Indicator Color 1", 155, 255, 255, 85),
		crosshair_color_blab = ui.new_label(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Indicator Color Secondary"),
		crosshair_color_b = ui.new_color_picker(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Crosshair Indicator Color 2", 255, 155, 255, 255),
		arrows_mode = ui_new_combobox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Arrow Type", {"Arrows", "Circle"}),
		arrows_circular_lable = ui.new_label(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Circle Color"),
		arrows_circular_color = ui.new_color_picker(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Circle Color", 255, 255, 255, 255),
		arrows_circular_size = ui.new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Circle Size", 8, 14, 8),
		arrows_color_lable = ui.new_label(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Arrows Color"),
		arrows_color = ui.new_color_picker(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Arrows Color", 255, 255, 255, 255),

		x_offset = ui.new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Drag Debug Window (⇵)", -1000, 1000, 0), 
        y_offset = ui.new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Drag Debug Window (⇆)", -1000, 1000, 0), 
	},

	misc = {
		misc_list = ui_new_multiselect(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Misc Functions", {"Breaker leg", "Static leg In Air", "Fake pitch on land", "Anti-backstab"}),
		jitter_leg = ui.new_checkbox(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Jitter Leg Movement"),
		jitter_leg_frequency = ui.new_slider(memorys.data.menu_directory[1], memorys.data.menu_directory[2], "Jitter Leg Frequency", 1, 10, 4),
	}
}

memorys.contains = function(tab, var)
	for _, data in pairs(type(tab) == "table" and tab or ui.get(tab)) do
		if data == var then
			return true
		end
	end

	return false
end
memorys.get_config_package = function()
	local config_element = {
	}

	for idx, element in pairs(memorys.data.elements.antiaim.custom) do
		for key, data in pairs(element) do
			config_element[("%s %s"):format(idx, key)] = data
		end
	end

	return config_element
end

memorys.import = function()
	local package = memorys.get_config_package()
	local configs = json.parse(base64.decode(clipboard.get()))
	for key, data in pairs(package) do
		if configs[key] then
			ui.set(data, configs[key])
		end
	end

	print("[Mewtwo] Config successfully imported from Clipboard!")
end

memorys.export = function()
	local configs = {}
	local package = memorys.get_config_package()
	for key, data in pairs(package) do
		configs[key] = ui.get(data)
	end

	clipboard.set(base64.encode(json.stringify(configs)))
	print("[Mewtwo] Config successfully exported to Clipboard!")
end
--Anti Aim
ui.new_label("AA", "Anti-Aimbot Angles", "          ")
ui.new_label("AA", "Anti-Aimbot Angles", "               \ad6b6f7ffImport/Export Anti-Aim")
ui.new_button("AA", "Anti-Aimbot Angles", "\aFFDEADFFExport AA", memorys.export)
ui.new_button("AA", "Anti-Aimbot Angles", "\aFFDEADFFImport AA", memorys.import)
memorys.handle_menu = function()
	ui.set_visible(memorys.data.elements.antiaim.manual_state, false)
	ui.set_visible(memorys.data.elements.main.owner_label, ui.get(memorys.data.elements.main.master_switch))
	ui.set_visible(memorys.data.elements.main.element_groups, ui.get(memorys.data.elements.main.master_switch))
	ui.set_visible(memorys.data.elements.antiaim.master_switch, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim")
	ui.set_visible(memorys.data.elements.antiaim.handle_visible, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch))
	ui.set_visible(memorys.data.elements.antiaim.roll_inverter, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.manual_left_dir, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.manual_right_dir, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.manual_backward_dir, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.edge, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.freestanding, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Keys"))
	ui.set_visible(memorys.data.elements.antiaim.current_player_status, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom"))
	ui.set_visible(memorys.data.elements.antiaim.anti_bruteforce, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Anti-Bruteforce"))
	ui.set_visible(memorys.data.elements.antiaim.shoot_condition, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == "Shoot")
	for idx, data in pairs(memorys.data.elements.antiaim.custom) do
		ui.set_visible(data.enabled, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and idx ~= 1)
		ui.set_visible(data.yaw, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled))
		ui.set_visible(data.pitch, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled))
		ui.set_visible(data.yaw_base, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled))
		ui.set_visible(data.body_yaw, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled))
		ui.set_visible(data.yaw_jitter, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.yaw) ~= "Off")
		ui.set_visible(data.yaw_slider, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.yaw) ~= "Off")
		ui.set_visible(data.fake_yaw, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off")
		ui.set_visible(data.yaw_slider_right, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.yaw) ~= "Off")
		ui.set_visible(data.fake_yaw_slider, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off")
		ui.set_visible(data.extended_angle, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off")
		ui.set_visible(data.fake_yaw_slider_right, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off")
		ui.set_visible(data.yaw_jitter_slider, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.yaw) ~= "Off" and ui.get(data.yaw_jitter) ~= "Off")
		ui.set_visible(data.yaw_jitter_slider_right, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.yaw) ~= "Off" and ui.get(data.yaw_jitter) ~= "Off")
		ui.set_visible(data.extended_angle_slider, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.extended_angle))
		ui.set_visible(data.extended_angle_mode, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.extended_angle))
		ui.set_visible(data.body_yaw_slider, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.body_yaw) ~= "Opposite")
		ui.set_visible(data.extended_angle_slider_right, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.extended_angle))
		ui.set_visible(data.fake_yaw_slider_extended, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.fake_yaw) ~= "Off")
		ui.set_visible(data.extended_angle_extra, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Anti-Aim" and ui.get(memorys.data.elements.antiaim.master_switch) and memorys.contains(memorys.data.elements.antiaim.handle_visible, "Custom") and ui.get(memorys.data.elements.antiaim.current_player_status) == memorys.data.player_status[idx] and ui.get(data.enabled) and ui.get(data.body_yaw) ~= "Off" and ui.get(data.extended_angle) and ui.get(data.extended_angle_mode) ~= "Off")
	end
	--Visuals
	ui.set_visible(memorys.data.elements.visuals.master_switch, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals")
	ui.set_visible(memorys.data.elements.visuals.indication_list, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch))
	ui.set_visible(memorys.data.elements.visuals.arrows_mode, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows"))
	ui.set_visible(memorys.data.elements.visuals.crosshair_color_a, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator"))
	ui.set_visible(memorys.data.elements.visuals.crosshair_color_alab, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator"))
	ui.set_visible(memorys.data.elements.visuals.x_offset, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Debug Window"))
	ui.set_visible(memorys.data.elements.visuals.y_offset, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Debug Window"))
	ui.set_visible(memorys.data.elements.visuals.crosshair_indicator_mode, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator"))
	ui.set_visible(memorys.data.elements.visuals.arrows_circular_size, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") and ui.get(memorys.data.elements.visuals.arrows_mode) == "Circle")
	ui.set_visible(memorys.data.elements.visuals.arrows_circular_lable, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") and ui.get(memorys.data.elements.visuals.arrows_mode) == "Circle")
	ui.set_visible(memorys.data.elements.visuals.arrows_circular_color, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") and ui.get(memorys.data.elements.visuals.arrows_mode) == "Circle")
	ui.set_visible(memorys.data.elements.visuals.arrows_color, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") and ui.get(memorys.data.elements.visuals.arrows_mode) == "Arrows.")
	ui.set_visible(memorys.data.elements.visuals.arrows_color_lable, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") and ui.get(memorys.data.elements.visuals.arrows_mode) == "Arrows.")
	ui.set_visible(memorys.data.elements.visuals.crosshair_color_b, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator") and ui.get(memorys.data.elements.visuals.crosshair_indicator_mode) == "v2")
	ui.set_visible(memorys.data.elements.visuals.crosshair_color_blab, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Visuals" and ui.get(memorys.data.elements.visuals.master_switch) and memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator") and ui.get(memorys.data.elements.visuals.crosshair_indicator_mode) == "v2")
	--Misc
	ui.set_visible(memorys.data.elements.misc.misc_list, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Misc")
	ui.set_visible(memorys.data.elements.misc.jitter_leg, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Misc" and memorys.contains(memorys.data.elements.misc.misc_list, "Breaker leg"))
	ui.set_visible(memorys.data.elements.misc.jitter_leg_frequency, ui.get(memorys.data.elements.main.master_switch) and ui.get(memorys.data.elements.main.element_groups) == "Misc" and memorys.contains(memorys.data.elements.misc.misc_list, "Breaker leg") and ui.get(memorys.data.elements.misc.jitter_leg))
end

memorys.lerp = function(start, vend, time)
	return start + (vend - start) * time
end

memorys.anti_untrusted = function()
	ui.set(memorys.reference.antiuntrusted, true)
end

memorys.distance_3d = function(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

memorys.air = function(player)
	if not player or not entity.is_alive(player) then
		return false
	end

	return bit.band(entity.get_prop(player, "m_fFlags"), 1) == 0
end

memorys.air_crouch = function(player)
    if not player or not entity.is_alive(player) then
        return false
    end
    
    local on_ground = (bit.band(entity.get_prop(entity_get_local_player(), 'm_fFlags'), 1) == 1)
    local duck_amount = entity.get_prop(entity.get_local_player(), "m_flDuckAmount")

    return not on_ground and duck_amount > 0.8
end

memorys.crouch = function(player)
	if not player or not entity.is_alive(player) then
		return false
	end

	return bit.band(entity.get_prop(player, "m_fFlags"), 2) == 2
end

memorys.velocity = function(player)
	if not player or not entity.is_alive(player) then
		return 0
	end

	local vx, vy, vz = entity_get_prop(player, "m_vecVelocity")
	return math_sqrt(vx ^ 2 + vy ^ 2)
end

client.set_event_callback("paint_ui", function(e)
	if ui.get(memorys.data.elements.antiaim.edge) then
		ui.set(memorys.reference.edge_yaw,true)
	else
		ui.set(memorys.reference.edge_yaw,false)
	end
	
	if ui.get(memorys.data.elements.antiaim.freestanding) then
		ui.set(memorys.reference.fs[2], "Always on")
		ui.set(memorys.reference.fs[1], true)
	else
		ui.set(memorys.reference.fs[2], "On hotkey")
		ui.set(memorys.reference.fs[1], false)
	
	end
end)

memorys.update_manual = function()
	ui.set(memorys.data.elements.antiaim.manual_left_dir, "On hotkey")
	local m_state = ui.get(memorys.data.elements.antiaim.manual_state)
	ui.set(memorys.data.elements.antiaim.manual_right_dir, "On hotkey")
	ui.set(memorys.data.elements.antiaim.manual_backward_dir, "On hotkey")
	local left_state, right_state, backward_state = ui.get(memorys.data.elements.antiaim.manual_left_dir), ui.get(memorys.data.elements.antiaim.manual_right_dir), ui.get(memorys.data.elements.antiaim.manual_backward_dir)
	if left_state == memorys.data.manual_adjusts.left and right_state == memorys.data.manual_adjusts.right and backward_state == memorys.data.manual_adjusts.back then
		return
	end

	memorys.data.manual_adjusts.left, memorys.data.manual_adjusts.right, memorys.data.manual_adjusts.back = left_state, right_state, backward_state
	if (left_state and m_state == 1) or (right_state and m_state == 2)  then
		ui.set(memorys.data.elements.antiaim.manual_state, 0)
		return
	end

	if left_state and m_state ~= 1 then
		ui.set(memorys.data.elements.antiaim.manual_state, 1)
	end

	if right_state and m_state ~= 2 then  
		ui.set(memorys.data.elements.antiaim.manual_state, 2)
	end

	if backward_state and m_state ~= 0 then
		ui.set(memorys.data.elements.antiaim.manual_state, 0)
	end
end

memorys.animation_breaker = function()
	local local_player = entity_get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	if memorys.contains(memorys.data.elements.misc.misc_list, "Breaker leg") then
		ui.set(memorys.reference.leg_movement, "Always slide") 
		if ui.get(memorys.data.elements.misc.jitter_leg) then
			if math.random(1, 10) > ui.get(memorys.data.elements.misc.jitter_leg_frequency) then
				entity.set_prop(local_player, "m_flPoseParameter", 1, 0)
			end
		else
			entity.set_prop(local_player, "m_flPoseParameter", 1, 0)
		end
	end

	if memorys.contains(memorys.data.elements.misc.misc_list, "Static leg In Air") then
		entity.set_prop(local_player, "m_flPoseParameter", 1, 6) 
	end

	if memorys.contains(memorys.data.elements.misc.misc_list, "Fake pitch on land") then
		local air = memorys.air(local_player)
		if not air then
			memorys.data.ground_ticks = memorys.data.ground_ticks + 1
		else
			memorys.data.ground_ticks = 0
			memorys.data.end_time = globals.curtime() + 1
		end

		if memorys.data.ground_ticks > ui.get(memorys.reference.fakelag) + 1 and memorys.data.end_time > globals.curtime() then
			entity.set_prop(local_player, "m_flPoseParameter", 0.5, 12)
		end
	end
end

memorys.anti_backstab = function()
	if not memorys.contains(memorys.data.elements.misc.misc_list, "Anti-backstab") then
		return false
	end

	local players = entity.get_players(true)
	local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
	for _, ptr in pairs(players) do
		local weapon = entity.get_player_weapon(ptr)
		local x, y, z = entity.get_prop(ptr, "m_vecOrigin")
		local distance = memorys.distance_3d(lx, ly, lz, x, y, z)
		if entity.get_classname(weapon) == "CKnife" and distance <= 164 then
			return true
		end
	end
	
	return false
end

memorys.breaker_lower_body = function(cmd)
	if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then
		return
	end

	local desync_amount = antiaim_funcs.get_desync(2)
	if desync_amount == nil then
		return
	end

	if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then
		return
	end

	if (entity.get_prop(entity.get_local_player(), "m_MoveType") or 0) == 9 then
		return
	end

	cmd.forwardmove = 0.000000000000000000000000000000001
	cmd.in_forward = 1
end

memorys.hit_anti_bruteforce = function(e)
	local local_player = entity_get_local_player()
	if e == nil or not ui.get(memorys.data.elements.main.master_switch) or not ui.get(memorys.data.elements.antiaim.master_switch) or (globals_curtime() - memorys.data.last_miss_time) <= 0.005 or not memorys.contains(memorys.data.elements.antiaim.anti_bruteforce, "On hiting") then
		return
	end

	local target = client.userid_to_entindex(e.userid)
	local shooter = client.userid_to_entindex(e.attacker)
	if target ~= local_player then
		return
	end

	if memorys.data.cached_missed[shooter] == nil then
		memorys.data.cached_missed[shooter] = false
	end

	memorys.data.cached_missed[shooter] = not memorys.data.cached_missed[shooter]
end

memorys.calc_anti_bruteforce = function(e)
	local local_player, shooter = entity_get_local_player(), client_userid_to_entindex(e.userid)
	if not ui.get(memorys.data.elements.main.master_switch) or not ui.get(memorys.data.elements.antiaim.master_switch) or not entity_is_alive(local_player) or not entity_is_enemy(shooter) or entity_is_dormant(shooter) or (globals_curtime() - memorys.data.last_miss_time) <= 0.005 or not memorys.contains(memorys.data.elements.antiaim.anti_bruteforce, "On missed") then
		return
	end

	if memorys.data.cached_missed[shooter] == nil then
		memorys.data.cached_missed[shooter] = false
	end

	local enemy_pos = vector(entity.get_prop(shooter, "m_vecOrigin"))
	local local_pos = vector(entity.get_prop(local_player, "m_vecOrigin"))
	local dist = ((e.y - enemy_pos.y) * local_pos.x - (e.x - enemy_pos.x) * local_pos.y + e.x * enemy_pos.y - e.y * enemy_pos.x) / math_sqrt((e.y - enemy_pos.y) ^ 2 + (e.x - enemy_pos.x) ^ 2)
	if math_abs(dist) <= 35 then
		memorys.data.last_miss_time = globals_curtime()
		memorys.data.cached_missed[shooter] = not memorys.data.cached_missed[shooter]
	end
end

memorys.reset = function()
	memorys.data.last_freestand = 1
	memorys.data.cached_missed = {}
	memorys.data.freestand.hit_side = 0
	memorys.data.freestand.last_side = 0
	memorys.data.freestand.last_hit = globals.curtime()
end

memorys.shooting = function(e)
	local local_player = entity.get_local_player()
	local fired_user = client.userid_to_entindex(e.userid)
	if fired_user ~= local_player then
		return
	end

	if ui.get(memorys.data.elements.antiaim.shoot_condition) == "On Fired" then
		memorys.data.shooting_data[1] = false
		memorys.data.shooting_data[2] = globals_curtime() + 0.8
	elseif ui.get(memorys.data.elements.antiaim.shoot_condition) == "On Fast Fired" then
		memorys.data.shooting_data[2] = 0
		memorys.data.shooting_data[1] = true
	end
end

memorys.get_attack = function(tickbase_correct)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return false
	end

	local weapons = entity.get_player_weapon(local_player)
	local tickbase = entity.get_prop(local_player, "m_nTickBase")
	local curtime = globals.tickinterval() * (tickbase - tickbase_correct)
	if curtime < entity.get_prop(local_player, "m_flNextAttack") then
		return false
	end
    
	if curtime < entity.get_prop(weapons, "m_flNextPrimaryAttack") then
		return false
	end
    
	return true
end

memorys.get_player_status = function(cmd)
	local local_player = entity_get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local player_status_index = 1
	local air = memorys.air(local_player)
	memorys.data.player_state = "Default"
	local crouch = memorys.crouch(local_player)
	local velocity = memorys.velocity(local_player)
	local air_crouch = memorys.air_crouch(local_player)
	local slow_walk = ui.get(memorys.reference.slowwalk[1]) and ui.get(memorys.reference.slowwalk[2])
	if ui.get(memorys.data.elements.antiaim.custom[2].enabled) and velocity <= 1.1 then
		player_status_index = 2
		memorys.data.player_state = "Standing"
	end

	if ui.get(memorys.data.elements.antiaim.custom[3].enabled) and velocity > 1.1 then
		player_status_index = 3
		memorys.data.player_state = "Moving"
	end

	if ui.get(memorys.data.elements.antiaim.custom[4].enabled) and slow_walk then
		player_status_index = 4
		memorys.data.player_state = "Slow walk"
	end

	if ui.get(memorys.data.elements.antiaim.custom[7].enabled) and crouch then
		player_status_index = 7
		memorys.data.player_state = "Crouch"
	end

	if ui.get(memorys.data.elements.antiaim.custom[5].enabled) and air then
		player_status_index = 5
		memorys.data.player_state = "In Air"
	end

	if ui.get(memorys.data.elements.antiaim.custom[6].enabled) and air_crouch then
		player_status_index = 6
		memorys.data.player_state = "Air Crouch"
	end

	-- The incomplete if statement starts here
	if ui.get(memorys.data.elements.antiaim.custom[8].enabled) and not crouch then
		if ui.get(memorys.data.elements.antiaim.shoot_condition) == "On Unattack" and not memorys.get_attack(13) then
			player_status_index = 8
			memorys.data.player_state = "Shot"
		elseif ui.get(memorys.data.elements.antiaim.shoot_condition) == "On Fired" and globals_curtime() < memorys.data.shooting_data[2] then
			player_status_index = 8
			memorys.data.player_state = "Shot"
		elseif ui.get(memorys.data.elements.antiaim.shoot_condition) == "On Fast Fired" and memorys.data.shooting_data[1] then
			player_status_index = 8
			memorys.data.player_state = "Shot"
			if cmd.chokedcommands == 0 and memorys.data.shooting_data[1] then
				memorys.data.shooting_data[1] = type(memorys.data.shooting_data[1]) == "boolean" and 1 or memorys.data.shooting_data[1] + 1
				if memorys.data.shooting_data[1] >= 2 then
					memorys.data.shooting_data[1] = false
				end
			end
		end
	end

	return player_status_index
end

memorys.adjust_yaw = function(yaw)
	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < - 180 do
		yaw = yaw + 360
	end

	return yaw
end

memorys.angle_vector = function(angle_x, angle_y)
	local sy, cy = math_sin(math_rad(angle_y)), math_cos(math_rad(angle_y))
	local sp, cp = math_sin(math_rad(angle_x)), math_cos(math_rad(angle_x))
	return cp * cy, cp * sy, - sp
end

memorys.calc_angle = function(local_x, local_y, enemy_x, enemy_y)
	if local_x == nil or local_y == nil or enemy_x == nil or enemy_y == nil then
		return 0
	end

	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan(ydelta / xdelta)
	relativeyaw = memorys.adjust_yaw(relativeyaw * 180 / math.pi)
	if xdelta >= 0 then
		relativeyaw = memorys.adjust_yaw(relativeyaw + 180)
	end

	return relativeyaw
end

memorys.calc_damage = function(me, enemy, x, y, z)
	local ex = {}
	local ey = {}
	local ez = {}
	local data = {
		ptr = nil,
		damage = 0
	}

	ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
	if ex[0] == nil or ey[0] == nil or ez[0] == nil then
		return 0
	end

	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	for i = 0, 6 do
		local ent, damage = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > data.damage then
			data.ptr = ent
			data.damage = damage
		end
	end

	return data.ptr == nil and client.scale_damage(me, 1, data.damage == nil and 0 or data.damage) or data.damage
end

memorys.calculate_freestand = function()
	local x, y, z = client.eye_position()
	local curt_times = globals.curtime()
	local _, yaw = client.camera_angles()
	local trace_data = {left = 0, right = 0}
	if memorys.data.freestand.hit_side ~= 0 and curt_times - memorys.data.freestand.last_hit > 5 then
		memorys.data.freestand.last_hit = 0
		memorys.data.freestand.hit_side = 0
		memorys.data.freestand.last_side = 0
	end

	for i = yaw - 90, yaw + 90, 30 do
		if i ~= yaw then
			local rad = math.rad(i)
			local side = i < yaw and "left" or "right"
			local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z
			local fraction = client.trace_line(entity.get_local_player(), x, y, z, px, py, pz)
			trace_data[side] = trace_data[side] + fraction
		end
	end

	memorys.data.freestand.side = trace_data.left < trace_data.right and 2 or 1
	if memorys.data.freestand.side == memorys.data.freestand.last_side then
		return
	end

	memorys.data.freestand.last_side = memorys.data.freestand.side
	if memorys.data.freestand.hit_side ~= 0 then
		memorys.data.freestand.side = memorys.data.freestand.hit_side == 1 and 1 or 2
	end
end

memorys.update_freestand = function(e)
	local local_player = entity.get_local_player()
	local userid, attacker = client.userid_to_entindex(e.userid), client.userid_to_entindex(e.attacker)
	if local_player == userid and local_player ~= attacker then
		memorys.data.freestand.last_side = 0
		memorys.data.freestand.last_hit = globals.curtime()
		memorys.data.freestand.hit_side = memorys.data.freestand.side
	end
end

memorys.body_yaw_freestand = function(state)
	memorys.data.last_freestand = 1
	local best_enemy = client.current_threat()
	local local_player = entity_get_local_player()
	if best_enemy == nil then
		return
	end

	local lx, ly, lz = client_eye_position()
	local view_x, view_y, roll = client_camera_angles()
	local e_x, e_y, e_z = entity_hitbox_position(best_enemy, 0)
	local yaw = memorys.calc_angle(lx, ly, e_x, e_y)
	local rdir_x, rdir_y, rdir_z = memorys.angle_vector(0, (yaw + 90))
	local rend_x = lx + rdir_x * 15
	local rend_y = ly + rdir_y * 15
	local ldir_x, ldir_y, ldir_z = memorys.angle_vector(0, (yaw - 90))
	local lend_x = lx + ldir_x * 15
	local lend_y = ly + ldir_y * 15
	local r2dir_x, r2dir_y, r2dir_z = memorys.angle_vector(0, (yaw + 90))
	local r2end_x = lx + r2dir_x * 100
	local r2end_y = ly + r2dir_y * 100
	local l2dir_x, l2dir_y, l2dir_z = memorys.angle_vector(0, (yaw - 90))
	local l2end_x = lx + l2dir_x * 100
	local l2end_y = ly + l2dir_y * 100
	local rdamage = memorys.calc_damage(local_player, best_enemy, lend_x, lend_y, lz)
	local ldamage = memorys.calc_damage(local_player, best_enemy, rend_x, rend_y, lz)
	local r2damage = memorys.calc_damage(local_player, best_enemy, l2end_x, l2end_y, lz)
	local l2damage = memorys.calc_damage(local_player, best_enemy, r2end_x, r2end_y, lz)
	if l2damage > r2damage or ldamage > rdamage then
		memorys.data.last_freestand = 1
	elseif r2damage > l2damage or rdamage > ldamage then
		memorys.data.last_freestand = 2
	end

	memorys.data.last_freestand = state == 1 and memorys.data.last_freestand or ({2, 1})[memorys.data.last_freestand]
	if state == 3 then
		memorys.calculate_freestand()
		memorys.data.last_freestand = memorys.data.freestand.side
	end
end

memorys.running_desync = function(cmd)
	local local_player = entity_get_local_player()
	if not ui.get(memorys.data.elements.main.master_switch) or not ui.get(memorys.data.elements.antiaim.master_switch) or not local_player or not entity.is_alive(local_player) then
		return
	end

	memorys.update_manual()
	local is_inverter = ui.get(memorys.reference.bodyyaw[2]) > 0
	local data = memorys.data.elements.antiaim.custom[memorys.get_player_status(cmd)]
	if cmd.chokedcommands == 0 then
		memorys.data.choked_reset = not memorys.data.choked_reset
	end

	ui.set(memorys.reference.pitch, ui.get(data.pitch))
	ui.set(memorys.reference.yaw[1], ui.get(data.yaw))
	ui.set(memorys.reference.yawj[1], ui.get(data.yaw_jitter))
	ui.set(memorys.reference.yaw_base, ui.get(data.yaw_base))
	ui.set(memorys.reference.yawj[2], ui.get(is_inverter and data.yaw_jitter_slider_right or data.yaw_jitter_slider))
		ui.set(memorys.reference.yaw[2], memorys.anti_backstab() and 180 or ({- 90, 90})[ui.get(memorys.data.elements.antiaim.manual_state)] or ui.get(is_inverter and data.yaw_slider_right or data.yaw_slider))
	if ui.get(data.body_yaw) ~= "Off" then
		if not ui.get(data.extended_angle) then
			local best_enemy = client.current_threat()
			local fake_limit = ui.get(is_inverter and data.fake_yaw_slider_right or data.fake_yaw_slider)
			if ui.set(data.fake_yaw) == "Jitter" then
				fake_limit = memorys.data.choked_reset and ui.get(data.fake_yaw_slider_extended) or fake_limit
			elseif ui.set(data.fake_yaw) == "Random" then
				fake_limit = math.random(ui.get(data.fake_yaw_slider_extended), fake_limit)
			elseif ui.set(data.fake_yaw) == "Aggressive" then
				fake_limit = globals.tickcount() % 2 == 0 and ui.get(data.fake_yaw_slider_extended) or fake_limit
			end

			if memorys.contains({"Static", "Jitter", "Opposite"}, ui.get(data.body_yaw)) then
				local body_yaw_slider = ui.get(data.body_yaw_slider)
				ui.set(memorys.reference.bodyyaw[1], ui.get(data.body_yaw))
				if memorys.data.cached_missed[best_enemy] then
					body_yaw_slider = - body_yaw_slider
				end

				ui.set(memorys.reference.bodyyaw[2], body_yaw_slider)
			else
				ui.set(memorys.reference.bodyyaw[1], "Static")
				memorys.body_yaw_freestand(({["Freestand"] = 1, ["Reserved freestand"] = 2, ["Calculation freestand"] = 3})[ui.get(data.body_yaw)])
				local body_yaw_slider = memorys.data.last_freestand == 2 and ui.get(data.body_yaw_slider) or - ui.get(data.body_yaw_slider)
				if memorys.data.cached_missed[best_enemy] then
					body_yaw_slider = - body_yaw_slider
				end

				ui.set(memorys.reference.bodyyaw[2], body_yaw_slider)
			end
		else
			ui.set(memorys.reference.roll, 50)
			--ui.set(memorys.reference.fakelimit, 60)
			ui.set(memorys.reference.bodyyaw[1], "Static")
			ui.set(memorys.reference.bodyyaw[2], ui.get(memorys.data.elements.antiaim.roll_inverter) and 180 or - 180)
			local roll_angle = ui.get(ui.get(memorys.data.elements.antiaim.roll_inverter) and data.extended_angle_slider_right or data.extended_angle_slider)
			if ui.set(data.extended_angle_mode) == "Jitter" then
				roll_angle = memorys.data.choked_reset and ui.get(data.extended_angle_extra) or roll_angle
			elseif ui.set(data.extended_angle_mode) == "Random" then
				roll_angle = math.random(ui.get(data.extended_angle_extra), roll_angle)
			elseif ui.set(data.extended_angle_mode) == "Aggressive" then
				roll_angle = globals.tickcount() % 2 == 0 and ui.get(data.extended_angle_extra) or roll_angle
			end

			cmd.roll = roll_angle
			memorys.breaker_lower_body(cmd)
			local is_valve_ds = ffi.cast("bool*", memorys.ffi_helpers.gamerules[0] + 124)
			if is_valve_ds ~= nil then
				is_valve_ds[0] = 0
				ui.set(memorys.reference.antiuntrusted, false)
			end
		end
	else
		ui.set(memorys.reference.roll, 0)
		ui.set(memorys.reference.bodyyaw[1], "Off")
	end

	if ui.get(memorys.data.elements.antiaim.manual_state) == 1 or ui.get(memorys.data.elements.antiaim.manual_state) == 2 then ui.set(memorys.reference.yawj[1], "Off") ui.set(memorys.reference.bodyyaw[1], "Static") end
end

memorys.charged = function()
	local local_player = entity_get_local_player()
	if not local_player or not entity.is_alive(local_player) or not ui_get(memorys.reference.dt[1]) or not ui_get(memorys.reference.dt[2]) or ui_get(memorys.reference.fd) then
		return false
	end

	local weapon = entity.get_prop(local_player, "m_hActiveWeapon")
	if weapon == nil then
		return false
	end

	local next_attack = entity.get_prop(local_player, "m_flNextAttack") + 0.25
	local next_primary_attack = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	return next_attack - globals.curtime() < 0 and (next_primary_attack + 0.5) - globals.curtime() < 0
end

memorys.gradient_text = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
	local output = ""
	local len = #text - 1
	local rinc = (r2 - r1) / len
	local ainc = (a2 - a1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	for i = 1, len + 1 do
		output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text:sub(i, i))
		r1 = r1 + rinc
		g1 = g1 + ginc
		b1 = b1 + binc
		a1 = a1 + ainc
	end

	return output
end

memorys.visuals = function()
	local local_player = entity_get_local_player()
	if not local_player or not ui.get(memorys.data.elements.visuals.master_switch) then
		return
	end

	local w, h = client_screen_size()
	local realtime = globals_realtime() % 3
	local alpha = math.floor(math.sin(realtime * 4) * (255/3-1) + 255/2) or 255
	local e_pose_param = math.min(57, entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)
	if memorys.contains(memorys.data.elements.visuals.indication_list, "Crosshair Indicator") then
		local h_index = 0
		local color_a = {ui.get(memorys.data.elements.visuals.crosshair_color_a)}
		if ui.get(memorys.data.elements.visuals.crosshair_indicator_mode) == "v1" then
			renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 255, 255, 255, 255, "-", 0, "MEWTWO")
			local body = math.min(57, entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)
			renderer.text(w / 2 + 15 + renderer_measure_text("-", "MEWTWO  ") , h / 2 + (h_index * 10) + 30, color_a[1], color_a[2], color_a[3], alpha, "-", 0, "TECH")
			h_index = h_index + 1
			renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, 157, 47, 188, 255, "-", 0, memorys.data.player_state:upper())
			renderer.text(w / 2 + 15 + renderer_measure_text("-", memorys.data.player_state:upper() .. "  ") , h / 2 + (h_index * 10) + 30, 255, 255, 255, 255, "-", 0, body > 0 and "L" or "R")
			h_index = h_index + 1
			if ui.get(memorys.reference.dt[1]) and ui.get(memorys.reference.dt[2]) then
				if memorys.charged() then
					renderer.text(w / 2 + 15, h / 2 + (h_index * 10) + 30, 0, 255, 0, 255, "-", 0, "DT")
				else
					renderer.text(w / 2 + 15, h / 2 + (h_index * 10) + 30, 255, 0, 0, 255, "-", 0, "DT")
				end

				h_index = h_index + 1
			end

			renderer.text(w / 2 + 15 , h / 2 + (h_index * 10) + 30, ui.get(memorys.reference.ref_force_bodyaim) and 255 or 155, ui.get(memorys.reference.ref_force_bodyaim) and 255 or 155, ui.get(memorys.reference.ref_force_bodyaim) and 255 or 155, ui.get(memorys.reference.ref_force_bodyaim) and 255 or 155, "-", 0, "BAIM")
			renderer.text(w / 2 + 37 , h / 2 + (h_index * 10) + 30, ui.get(memorys.reference.fs[2]) and 255 or 155, ui.get(memorys.reference.fs[2]) and 255 or 155, ui.get(memorys.reference.fs[2]) and 255 or 155, ui.get(memorys.reference.fs[2]) and 255 or 155, "-", 0, "FS")
			renderer.text(w / 2 + 50 , h / 2 + (h_index * 10) + 30, ui.get(memorys.reference.hs[2]) and 255 or 155, ui.get(memorys.reference.hs[2]) and 255 or 155, ui.get(memorys.reference.hs[2]) and 255 or 155, ui.get(memorys.reference.hs[2]) and 255 or 155, "-", 0, "OS")
		else
			if ui.get(memorys.reference.fs[2]) then
				memorys.data.ani.y1 = memorys.lerp(memorys.data.ani.y1, 15, globals.frametime() * 6)
				memorys.data.ani.yy1 = memorys.lerp(memorys.data.ani.yy1, 80, globals.frametime() * 6)
				memorys.data.ani.fs_alpha = memorys.lerp(memorys.data.ani.fs_alpha, 255, globals.frametime() * 6)
			else
				memorys.data.ani.y1 = memorys.lerp(memorys.data.ani.y1,0,globals.frametime() * 6)
				memorys.data.ani.yy1 = memorys.lerp(memorys.data.ani.yy1,0,globals.frametime() * 6)
				memorys.data.ani.fs_alpha = memorys.lerp(memorys.data.ani.fs_alpha,0,globals.frametime() * 6)
			end

			if ui_get(memorys.reference.dt[2]) then
				memorys.data.ani.y2 = memorys.lerp(memorys.data.ani.y2,15,globals.frametime() * 6)
				memorys.data.ani.yy2 = memorys.lerp(memorys.data.ani.yy2,80,globals.frametime() * 6)
				memorys.data.ani.dt_alpha = memorys.lerp(memorys.data.ani.dt_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y2 = memorys.lerp(memorys.data.ani.y2,0,globals.frametime() * 6)
				memorys.data.ani.yy2 = memorys.lerp(memorys.data.ani.yy2,0,globals.frametime() * 6)
				memorys.data.ani.dt_alpha = memorys.lerp(memorys.data.ani.dt_alpha,0,globals.frametime() * 6)
			end

			if ui.get(memorys.reference.hs[2]) then
				memorys.data.ani.y3 = memorys.lerp(memorys.data.ani.y3,15,globals.frametime() * 6)
				memorys.data.ani.yy3 = memorys.lerp(memorys.data.ani.yy3,80,globals.frametime() * 6)
				memorys.data.ani.hide_alpha = memorys.lerp(memorys.data.ani.hide_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y3 = memorys.lerp(memorys.data.ani.y3,0,globals.frametime() * 6)
				memorys.data.ani.yy3 = memorys.lerp(memorys.data.ani.yy3,0,globals.frametime() * 6)
				memorys.data.ani.hide_alpha = memorys.lerp(memorys.data.ani.hide_alpha,0,globals.frametime() * 6)
			end

			if ui.get(memorys.reference.ref_force_bodyaim) then
				memorys.data.ani.y4 = memorys.lerp(memorys.data.ani.y4,15,globals.frametime() * 6)
				memorys.data.ani.yy4 = memorys.lerp(memorys.data.ani.yy4,80,globals.frametime() * 6)
				memorys.data.ani.baim_alpha = memorys.lerp(memorys.data.ani.baim_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y4 = memorys.lerp(memorys.data.ani.y4,0,globals.frametime() * 6)
				memorys.data.ani.yy4 = memorys.lerp(memorys.data.ani.yy4,0,globals.frametime() * 6)
				memorys.data.ani.baim_alpha = memorys.lerp(memorys.data.ani.baim_alpha,0,globals.frametime() * 6)
			end

			if ui.get(memorys.reference.fd) then
				memorys.data.ani.y5 = memorys.lerp(memorys.data.ani.y5,15,globals.frametime() * 6)
				memorys.data.ani.yy5 = memorys.lerp(memorys.data.ani.yy5,80,globals.frametime() * 6)
				memorys.data.ani.duck_alpha = memorys.lerp(memorys.data.ani.duck_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y5 = memorys.lerp(memorys.data.ani.y5,0,globals.frametime() * 6)
				memorys.data.ani.yy5 = memorys.lerp(memorys.data.ani.yy5,0,globals.frametime() * 6)
				memorys.data.ani.duck_alpha = memorys.lerp(memorys.data.ani.duck_alpha,0,globals.frametime() * 6)
			end
            if ui.get(memorys.reference.sp_key) then
				memorys.data.ani.y6 = memorys.lerp(memorys.data.ani.y6,15,globals.frametime() * 6)
				memorys.data.ani.yy6 = memorys.lerp(memorys.data.ani.yy6,80,globals.frametime() * 6)
				memorys.data.ani.sp_alpha = memorys.lerp(memorys.data.ani.sp_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y6 = memorys.lerp(memorys.data.ani.y6,0,globals.frametime() * 6)
				memorys.data.ani.yy6 = memorys.lerp(memorys.data.ani.yy6,0,globals.frametime() * 6)
				memorys.data.ani.sp_alpha = memorys.lerp(memorys.data.ani.sp_alpha,0,globals.frametime() * 6)
			end
			if ui.get(memorys.reference.ping_spike[1]) and ui.get(memorys.reference.ping_spike[2]) then
				memorys.data.ani.y7 = memorys.lerp(memorys.data.ani.y7,10,globals.frametime() * 6)
				memorys.data.ani.yy7 = memorys.lerp(memorys.data.ani.yy7,80,globals.frametime() * 6)
				memorys.data.ani.ping_alpha = memorys.lerp(memorys.data.ani.ping_alpha,255,globals.frametime() * 6)
			else
				memorys.data.ani.y7 = memorys.lerp(memorys.data.ani.y7,0,globals.frametime() * 6)
				memorys.data.ani.yy7 = memorys.lerp(memorys.data.ani.yy7,0,globals.frametime() * 6)
				memorys.data.ani.ping_alpha = memorys.lerp(memorys.data.ani.ping_alpha,0,globals.frametime() * 6)
			end
			
			local local_player = entity.get_local_player()
			local is_scoped = entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_zoomLevel" )
			local my_weapon = entity.get_player_weapon(local_player)
			local wpn_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
			local is_grenade =
				({
				[43] = true,
				[44] = true,
				[45] = true,
				[46] = true,
				[47] = true,
				[48] = true,
				[68] = true
			})[wpn_id] or false
			if is_scoped == nil then is_scoped = 0 end
			if is_scoped >= 1 or is_grenade then
				memorys.data.ani.s = memorys.lerp(memorys.data.ani.s, 20,globals.frametime() * 8)
				memorys.data.ani.xx = memorys.lerp(memorys.data.ani.xx, 5,globals.frametime() * 8)
				memorys.data.ani.x1 = memorys.lerp(memorys.data.ani.x1, 22,globals.frametime() * 8)
				memorys.data.ani.glow = memorys.lerp(memorys.data.ani.glow, 0,globals.frametime() * 8)
				memorys.data.ani.glow2 = memorys.lerp(memorys.data.ani.glow2, 255,globals.frametime() * 8)
			else
				memorys.data.ani.glow = memorys.lerp(memorys.data.ani.glow, 255,globals.frametime() * 8)
				memorys.data.ani.glow2 = memorys.lerp(memorys.data.ani.glow2, 0,globals.frametime() * 8)
				memorys.data.ani.s = memorys.lerp(memorys.data.ani.s, 0,globals.frametime() * 8)
				memorys.data.ani.xx = memorys.lerp(memorys.data.ani.xx, 0,globals.frametime() * 8)
				memorys.data.ani.x1 = memorys.lerp(memorys.data.ani.x1, 0,globals.frametime() * 8)
			end

			local color_a = {ui.get(memorys.data.elements.visuals.crosshair_color_a)}
			local color_b = {ui.get(memorys.data.elements.visuals.crosshair_color_b)}
			local first_offset = memorys.data.ani.y1
			local second_offset = first_offset + memorys.data.ani.y2
			local thrid_offset = second_offset + memorys.data.ani.y3
			local fourth_offset = thrid_offset + memorys.data.ani.y4
			local fiveth_offset = fourth_offset + memorys.data.ani.y5
			local sixth_offset = fiveth_offset + memorys.data.ani.y6
			local seventh_offset = sixth_offset + memorys.data.ani.y7
			local body = e_pose_param
			local perc = math.abs(e_pose_param) / 60
			local dys = math.floor(perc * 60)
			local logo = memorys.gradient_text(color_a[1], color_a[2], color_a[3], 255, color_b[1], color_b[2], color_b[3], alpha, ("MEWTWO.TECH"))
			renderer.text(w / 2 +  memorys.data.ani.x1 , h / 2 + 30 , 255, 255, 255, 255, "c-", 0, logo:upper())
            renderer.text(w / 2  + memorys.data.ani.s , h / 2 + 40 , 255, 255, 255, memorys.data.ani.glow, "c-", 0, body > 0 and "" or "", string.upper("  "..memorys.data.player_state),"  ",string.upper(math.floor(math.abs(dys))).." %")
            renderer.gradient(w / 2 - 3 + memorys.data.ani.xx,h / 2 + 39 ,math.floor(math.abs(dys)), 4, memorys.data.elements.visuals.crosshair_color_a, memorys.data.ani.glow2, memorys.data.elements.visuals.crosshair_color_b, memorys.data.ani.glow2,true)
            renderer.text(w / 2 + 2 + memorys.data.ani.x1 , h / 2 + 40 , 255, 255, 255, memorys.data.ani.glow2, "c-", 0, string.upper("  "..memorys.data.player_state),"  ",string.upper(math.floor(math.abs(dys))).." %")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y1) / 1.5, 220, 220, 220, memorys.data.ani.fs_alpha, "c-", nil, "FREESTAND")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y2) / 1.5 + first_offset / 1.5, 0, 255, 0, memorys.data.ani.dt_alpha, "c-", nil, "DOUBLETAP")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y3) / 1.5 + second_offset / 1.5, 255, 38, 104, memorys.data.ani.hide_alpha, "c-", nil, "HIDE")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y4) / 1.5 + thrid_offset / 1.5, 170, 50, 255, memorys.data.ani.baim_alpha, "c-", nil, "BAIM")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y5) / 1.5 + fourth_offset / 1.5, 80, 80, 255, memorys.data.ani.duck_alpha, "c-", nil, "DUCK")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y6) / 1.5 + fiveth_offset / 1.5, 210, 124, 11, memorys.data.ani.sp_alpha, "c-", nil, "SAFE")
			renderer.text(w / 2  + memorys.data.ani.x1 , h / 2 + 41 + math_floor(memorys.data.ani.y7) / 0.95 + sixth_offset / 1.5, 20, 229, 236, memorys.data.ani.ping_alpha, "c-", nil, "PING")
		end
	end

	if memorys.contains(memorys.data.elements.visuals.indication_list, "Manual Arrows") then
		local color_a = {ui.get(memorys.data.elements.visuals.arrows_color)}
		if ui.get(memorys.data.elements.visuals.arrows_mode) == "Arrows" then
			if ui.get(memorys.data.elements.antiaim.manual_state) == 1 then 
				renderer_text(w / 2 - 55, h / 2 , color_a[1], color_a[2], color_a[3], 255, "cb+", 0, "❮")
				renderer_text(w / 2 + 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "❯")
			elseif ui.get(memorys.data.elements.antiaim.manual_state) == 2 then
				renderer_text(w / 2 - 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "❮")
				renderer_text(w / 2 + 55, h / 2 , color_a[1], color_a[2], color_a[3], 255, "cb+", 0, "❯")
			elseif ui.get(memorys.data.elements.antiaim.manual_state) == 0 then
				renderer_text(w / 2 - 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "❮")
				renderer_text(w / 2 + 55, h / 2 , 25, 25, 25, 255, "cb+", 0, "❯")
			end
		else
			local crosshair_size_1 = ui.get(memorys.data.elements.visuals.arrows_circular_size)
			local circular_color = {ui.get(memorys.data.elements.visuals.arrows_circular_color)}
			local cam = vector(client_camera_angles())
			local h = vector(entity_hitbox_position(local_player, "head_0"))
			local p = vector(entity_hitbox_position(local_player, "pelvis"))
			local scrsize_x, scrsize_y = client.screen_size()
			local center_x, center_y = scrsize_x / 2, scrsize_y / 2.003
			local yaw = memorys.adjust_yaw(memorys.calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
			renderer.circle_outline(center_x + 1, center_y, circular_color[1], circular_color[2], circular_color[3], circular_color[4], crosshair_size_1 * 1.833, (yaw * - 1) - 15, 0.14, 3.6)
		end
	end

	local mx, my = client.screen_size()
	if memorys.contains(memorys.data.elements.visuals.indication_list, "Debug Window") then               
		local scrsize_x, scrsize_y = client.screen_size()
		local center_x, center_y = scrsize_x / 2, scrsize_y / 2.003
		local local_avatar = images.get_steam_avatar(entity.get_steam64(entity.get_local_player()))
		local_avatar:draw(center_x-952 + ui.get(memorys.data.elements.visuals.y_offset), center_y - 4 + ui.get(memorys.data.elements.visuals.x_offset), nil, 33)
		renderer.text(center_x-910 + ui.get(memorys.data.elements.visuals.y_offset), center_y + 19 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, "b", 0, "Anti-Aim State - "..string.lower(memorys.data.player_state:upper()))
		local SM3 =  memorys.gradient_text(132, 255, 255, 225, 89, 170, 255, 255, "Mewtwo. ")
		renderer.text(center_x-910 + ui.get(memorys.data.elements.visuals.y_offset), center_y - 7 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, 'b', 0, SM3)
		local SM4 =  memorys.gradient_text(132, 255, 255, 160, 245, 60, 180, 255, "Technoglogies [VIP]")
		renderer.text(center_x-865 + ui.get(memorys.data.elements.visuals.y_offset), center_y - 7 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, 'b', 0, SM4)
		renderer.text(center_x-913 + ui.get(memorys.data.elements.visuals.y_offset), center_y + 6 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, 'b', 0, " \a90AEFFFFuser:\aFFFFFFFF "..name)
		renderer.text(center_x-910 + ui.get(memorys.data.elements.visuals.y_offset), center_y + 19 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, "b", 0, "Anti-Aim State - "..string.lower(memorys.data.player_state:upper()))
		--renderer.text(center_x-910 + ui.get(memorys.data.elements.visuals.y_offset), center_y + 25 + ui.get(memorys.data.elements.visuals.x_offset), 255, 255, 255, 255, "b", 0," \a90AEFFFFPredicted:\aFFFFFFFF "..entity_get_player_name(best_enemy))	
	end
end


local function jiemian()
	if ui.get(memorys.data.elements.main.master_switch) then
    ui.set_visible(memorys.reference.yaw[2], false)
    ui.set_visible(memorys.reference.yawj[1], false)
    ui.set_visible(memorys.reference.yaw[1], false)
    ui.set_visible(memorys.reference.yawj[2], false)
    ui.set_visible(memorys.reference.pitch, false)
    ui.set_visible(memorys.reference.bodyyaw[1], false)
    ui.set_visible(memorys.reference.bodyyaw[2], false)
    ui.set_visible(memorys.reference.fs_bodyyaw, false)
    ui.set_visible(memorys.reference.yaw_base, false)
    ui.set_visible(memorys.reference.edge_yaw, false)
    ui.set_visible(memorys.reference.fs[1], false)
    ui.set_visible(memorys.reference.fs[2], false)
	ui.set_visible(memorys.reference.roll, false)
else
    ui.set_visible(memorys.reference.yaw[2], true)
    ui.set_visible(memorys.reference.yawj[1], true)
    ui.set_visible(memorys.reference.yaw[1], true)
    ui.set_visible(memorys.reference.yawj[2], true)
    ui.set_visible(memorys.reference.pitch, true)
    ui.set_visible(memorys.reference.bodyyaw[1], true)
    ui.set_visible(memorys.reference.bodyyaw[2], true)
    ui.set_visible(memorys.reference.fs_bodyyaw, true)
    ui.set_visible(memorys.reference.yaw_base, true)
    ui.set_visible(memorys.reference.edge_yaw, true)
    ui.set_visible(memorys.reference.fs[1], true)
    ui.set_visible(memorys.reference.fs[2], true)
	ui.set_visible(memorys.reference.roll, true)
    end
end

memorys.callbacks = {
	["paint"] = function()
		memorys.visuals()
	end,

	["weapon_fire"] = function(e)
		memorys.shooting(e)
	end,

	["setup_command"] = function(e)
		memorys.running_desync(e)
	end,

	["pre_render"] = function()
		memorys.animation_breaker()
	end,

	["player_hurt"] = function(e)
		memorys.update_freestand(e)
		memorys.hit_anti_bruteforce(e)
	end,

	["bullet_impact"] = function(e)
		memorys.calc_anti_bruteforce(e)
	end,

	["round_start"] = function(e)
		memorys.reset()
	end,

	["game_newmap"] = function(e)
		memorys.reset()
	end,

	["client_disconnect"] = function(e)
		memorys.reset()
	end,

	["cs_game_disconnected"] = function(e)
		memorys.reset()
	end,

	["pre_config_load"] = function(e)
		memorys.anti_untrusted()
	end,

	["pre_config_save"] = function(e)
		memorys.anti_untrusted()
	end,

	["shutdown"] = function(e)
		memorys.anti_untrusted()
		ui.set(memorys.data.elements.main.master_switch, false)
		jiemian()
	end
}

client.set_event_callback("paint", jiemian)
jiemian()

memorys.initialization = function()
	local elements = {}
	memorys.handle_menu()
	for _, data in pairs(memorys.data.elements.misc) do
		table.insert(elements, data)
	end

	for _, data in pairs(memorys.data.elements.main) do
		table.insert(elements, data)
	end

	for _, data in pairs(memorys.data.elements.visuals) do
		table.insert(elements, data)
	end

	for key, data in pairs(memorys.data.elements.antiaim) do
		if key == "custom" then
			for _, element_list in pairs(data) do
				for _, g_data in pairs(element_list) do
					table.insert(elements, g_data)
				end
			end
		else
			table.insert(elements, data)
		end
	end

	ui.set(memorys.reference.antiuntrusted, true)
	for _, data in pairs(elements) do
		ui.set_callback(data, memorys.handle_menu)
	end

	for name, callback in pairs(memorys.callbacks) do
		client.set_event_callback(name, callback)
	end
end

memorys.initialization()

--Mewtwo.Technologies Fakelag 
local fakelag_enabled = ui.new_checkbox("AA", "Fake lag", "\a12EC0997Enable \abbc4fbffMe\abbc4fbffwt\ac9bdf9ffwo.\ad6b6f7ffTe\ae4aff5ffch\ae4aff5ffno\afea1f1fflo\aff96edffgies Fakelag")
local amount_mode = ui.new_combobox("AA", "Fake lag", "Fakelag Amount", "Dynamic", "Maximum", "Fluctuate")
local variance_slider = ui.new_slider("AA", "Fake lag", "Fakelag Variance", 0, 100, 0, true, "%")
local fakelag_limit = ui.new_slider("AA", "Fake lag", " Fakelag Limit", 1, 15, 13, true)
local fakelag_fluctuate_limit = ui.new_slider("AA", "Fake lag", " Fakelag Fluctuate Limit", 1, 16, 1, true)
local variance_mode = ui.new_combobox("AA", "Fake lag", "Fakelag Variance Types", "Random", "Fluctuate")
local fakelag_slider_trigger = ui.new_multiselect("AA", "Fake lag", "Select Fake-Lag Limiters", {"In Air Limit", "Fired Limit", "Wall Peek Limit", "Visible Limit"})
local trigger_aerial_limit = ui.new_slider("AA", "Fake lag", "In Air Limit", 1, 15, 13, true)
local trigger_fired_limit = ui.new_slider("AA", "Fake lag", "Fired Limit", 1, 15, 1, true)
local trigger_wall_limit = ui.new_slider("AA", "Fake lag", "Wall Peek Limit", 1, 15, 13, true)
local trigger_visible_limit = ui.new_slider("AA", "Fake lag", "Visible Limit ", 1, 15, 13, true)
local fakelag_trigger_types = ui.new_combobox("AA", "Fake lag", "Fakelag Trigger Types", "Fakelag Send Packet Trigger","Fakelag Limiter")
local fakelag_send_packet_trigger = ui.new_multiselect("AA", "Fake lag", "Fakelag Triggers Settings", {"On Standing", "While Moving", "On Duck", "On High Speed", "On Jump", "On Exploit", "On Use", "On Freezetime", "Weapon Switch", "Weapon Reload", "Weapon Fired", "On Land", "While Climbing Ladder"})
local fakelag_limit_trigger_limit = ui.new_slider("AA", "Fake lag", "Unselected Triggers Limiter", 1, 15, 3, true)
local lagcomp_break = ui.new_checkbox("AA", "Fake lag", "Break Lag Compstation")

local limit = ui.reference("AA", "Fake lag", "Limit")
local amount = ui.reference("AA", "Fake lag", "Amount")
local variance = ui.reference("AA", "Fake lag", "Variance")
local ref_pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local ref_fakeduck = ui.reference("RAGE", "Other", "Duck peek assist")
local ref_yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local slow_walk, slow_hotkey =  ui.reference("AA", "Other", "Slow motion")
local ref_yaw, ref_yawslider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local on_shot, on_shot_hotkey = ui.reference("AA", "Other", "On shot anti-aim")
local double_tap, double_tap_hotkey = ui.reference("RAGE", "Aimbot", "Double tap")
local ref_jitter, ref_jitterslider = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local bodyyaw, bodyyaw_slider = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
--local fakelag_urmaxprocess = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local freestanding_bodyyaw =  ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")

--ui.set_visible(fakelag_urmaxprocess, true)
local directionadd = 0
local desyncside = LEFT
local noenemies = false
local LEFT, RIGHT = 1, 2
local aadirection = "LEFT"
local stored_target = false
local aadirection = "BACK"
local flags_on_land = false
local State = "Default"
local weapon_visible = false
local last_manual_presstime = 0
local trigger_send_packet = true

local lag_info = {
    current_phase = 1,
    prev_choked = 15
}

local lag_shit = {{
    variance = 0,
    limit = 13,
    break_lagcomp = true,
    amount = "Dynamic"
},

{
    variance = 0,
    limit = 13,
    break_lagcomp = false,
    amount = "Dynamic"
}}


local weapons_disabled = {
    "CKnife",
    "CWeaponTaser",
    "CC4",
    "CHEGrenade",
    "CSmokeGrenade",
    "CMolotovGrenade",
    "CSensorGrenade",
    "CFlashbang",
    "CDecoyGrenade",
    "CIncendiaryGrenade"
}

local cache = { }
local data = {
    threshold = false,
    stored_last_shot = 0,
    stored_item = 0
}

local function multi_select(tab, val, sys)
	for index, value in ipairs(tab) do
		if sys == 1 and index == val then
			return true
		elseif value == val then
			return true
		end
	end
		return false
end


local function vec_3(_x, _y, _z)
	return { x = _x or 0, y = _y or 0, z = _z or 0 }
end

local function ticks_to_time(ticks)
	return globals.tickinterval() * ticks
end

local function player_will_peek(e)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local enemies = entity.get_players(true)
	if not enemies then
		return false
	end

	local eye_position = vec_3(client.eye_position())
	local velocity_prop_local = vec_3( entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
	local predicted_eye_position = vec_3( eye_position.x + velocity_prop_local.x * ticks_to_time(16), eye_position.y + velocity_prop_local.y * ticks_to_time(16), eye_position.z + velocity_prop_local.z * ticks_to_time(16))

	for i = 1, #enemies do
		local player = enemies[i]
		local velocity_prop = vec_3(entity.get_prop(player, "m_vecVelocity"))
		local origin = vec_3(entity.get_prop(player, "m_vecOrigin"))
		local predicted_origin = vec_3(origin.x + velocity_prop.x * ticks_to_time(16), origin.y + velocity_prop.y * ticks_to_time(16), origin.z + velocity_prop.z * ticks_to_time(16))
		entity.get_prop(player, "m_vecOrigin", predicted_origin)
		local head_origin = vec_3(entity.hitbox_position(player, 0))
		local predicted_head_origin = vec_3( head_origin.x + velocity_prop.x * ticks_to_time(16), head_origin.y + velocity_prop.y * ticks_to_time(16), head_origin.z + velocity_prop.z * ticks_to_time(16))
		local trace_entity, damage = client.trace_bullet( entity.get_local_player(), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z)
		entity.get_prop(player, "m_vecOrigin", origin)

		if damage > 0 then
			return true
		end
	end

	return false
end


local function vec2_distance(f_x, f_y, t_x, t_y)
	local delta_x, delta_y = f_x - t_x, f_y - t_y
	return math.sqrt(delta_x*delta_x + delta_y*delta_y)
end

local function get_all_player_positions(ctx, screen_width, screen_height, enemies_only)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local player_indexes = {}
	local player_positions = {}
	local players = entity.get_players(enemies_only)

	if #players == 0 then
		return
	end

	for i=1, #players do
		local player = players[i]
		local px, py, pz = entity.get_prop(player, "m_vecOrigin")
		local vz = entity.get_prop(player, "m_vecViewOffset[2]")
		if pz ~= nil and vz ~= nil then
		pz = pz + (vz*0.5)

		local sx, sy = client.world_to_screen(ctx, px, py, pz)
			if sx ~= nil and sy ~= nil then
				if sx >= 0 and sx <= screen_width and sy >= 0 and sy <= screen_height then 
					player_indexes[#player_indexes+1] = player
					player_positions[#player_positions+1] = {sx, sy}
				end
			end
		end
	end
		return player_indexes, player_positions
	end

local function check_fov(ctx)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	local screen_width, screen_height = client.screen_size()
	local screen_center_x, screen_center_y = screen_width*0.5, screen_height*0.5
	local fov_limit = 250
	
	if get_all_player_positions(ctx, screen_width, screen_height, true) == nil then
		return
	end

	local enemy_indexes, enemy_coords = get_all_player_positions(ctx, screen_width, screen_height, true)
	if #enemy_indexes <= 0 then
		return true
	end

	if #enemy_coords == 0 then
		return true
	end

	local closest_fov = 133337
	local closest_entindex = 133337

	for i=1, #enemy_coords do
		local x = enemy_coords[i][1]
		local y = enemy_coords[i][2]
		local current_fov = vec2_distance(x, y, screen_center_x, screen_center_y)

		if current_fov < closest_fov then
			closest_fov = current_fov -- found a target that is closer to center of our screen
			closest_entindex = enemy_indexes[i]
		end
	end
		return closest_fov > fov_limit, closest_entindex
	end

local function can_see(ent)	
	for i=0, 18 do
		if client.visible(entity.hitbox_position(ent, i)) then
			return true
		end
	end
		return false
	end

local function visible_enemy(ctx)
	local local_entindex = entity.get_local_player()
	if entity.get_prop(local_entindex, "m_lifeState") ~= 0 then	
		weapon_visible = false
		return
	end
	
	local enemy_visible, enemy_entindex = check_fov(ctx)
	if enemy_entindex == nil then
		return
	end
	
	if enemy_visible and enemy_entindex ~= nil and stored_target ~= enemy_entindex then
		stored_target = enemy_entindex
	end

	local visible = can_see(enemy_entindex)
	if visible then
		weapon_visible = true
	else
		weapon_visible = false
	end

	stored_target = enemy_entindex
	local enemy_player_number = entity.get_players(true)
end

client.set_event_callback("paint",visible_enemy)

client.set_event_callback("weapon_fire", function(e)
	local localplayer = entity.get_local_player()
	if not localplayer or not entity.is_alive(localplayer) or not client.userid_to_entindex(e.userid) == localplayer then
		return
	end

	flags_weapon_reload = true
	client.delay_call(0.45, function(reload)
		flags_weapon_reload = false
	end)
end)


local function status_lagshift(e)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) or not ui.get(fakelag_enabled) then
		return
	end

	local player_move_type = entity.get_prop(local_player, "m_movetype")
	local flags_status = entity.get_prop(local_player, "m_fFlags")
	local flags_climbing_adder = player_move_type == 9
	local can_fire_wall = player_will_peek()

	if ui.get(amount_mode) == "Dynamic" then
		lag_new_amo = "Dynamic"
		lag_get_limit = - ui.get(variance_slider) * 0.01
		lag_variance_limit = - lag_get_limit * ui.get(fakelag_limit)
		lag_variance_fixer = lag_variance_limit <= 0 and lag_variance_limit or lag_variance_limit
		lag_variance_status = ui.get(variance_mode) == "Random" and math.random(ui.get(fakelag_limit) - lag_variance_fixer, ui.get(fakelag_limit)) or ui.get(fakelag_limit) - ui.get(variance_slider) * 0.01 * ui.get(fakelag_limit)
		lag_first_limit = lag_variance_status
		lag_two_limit = ui.get(fakelag_limit)
	elseif ui.get(amount_mode) == "Maximum" then
		lag_new_amo = "Maximum"
		lag_get_limit = - ui.get(variance_slider) * 0.01
		lag_variance_limit = - lag_get_limit * ui.get(fakelag_limit)
		lag_variance_fixer = lag_variance_limit <= 0 and lag_variance_limit or lag_variance_limit
		lag_variance_status = ui.get(variance_mode) == "Random" and math.random(ui.get(fakelag_limit) - lag_variance_fixer, ui.get(fakelag_limit)) or ui.get(fakelag_limit) - ui.get(variance_slider) * 0.01 * ui.get(fakelag_limit)
		lag_first_limit = lag_variance_status
		lag_two_limit = ui.get(fakelag_limit)
	elseif ui.get(amount_mode) == "Fluctuate" then
		lag_new_amo = "Fluctuate"
		lag_get_limit = - ui.get(variance_slider) * 0.01
		lag_variance_limit = - lag_get_limit * ui.get(fakelag_limit)
		lag_variance_fixer = lag_variance_limit <= 0 and lag_variance_limit or lag_variance_limit
		lag_variance_status = ui.get(variance_mode) == "Random" and math.random(ui.get(fakelag_limit) - lag_variance_fixer, ui.get(fakelag_limit)) or ui.get(fakelag_limit) - ui.get(variance_slider) * 0.01 * ui.get(fakelag_limit)
		lag_first_limit = lag_variance_status
		lag_two_limit = ui.get(fakelag_fluctuate_limit)
	end

	if multi_select(ui.get(fakelag_slider_trigger), "Wall Peek Limit") and can_fire_wall == true and weapon_visible == false then
		lag_first_limit = ui.get(amount_mode) == "Fluctuate" and ui.get(fakelag_fluctuate_limit) or ui.get(trigger_wall_limit)
		lag_two_limit = ui.get(trigger_wall_limit)
	else
		lag_first_limit = lag_first_limit < 1 and 1 or lag_first_limit
		lag_two_limit = lag_two_limit < 1 and 1 or lag_two_limit
	end

	if multi_select(ui.get(fakelag_slider_trigger), "Visible Limit") and weapon_visible == true then
		lag_first_limit = ui.get(amount_mode) == "Fluctuate" and ui.get(fakelag_fluctuate_limit) or ui.get(trigger_visible_limit)
		lag_two_limit = ui.get(trigger_visible_limit)
	else
		lag_first_limit = lag_first_limit < 1 and 1 or lag_first_limit
		lag_two_limit = lag_two_limit < 1 and 1 or lag_two_limit
	end

	if multi_select(ui.get(fakelag_slider_trigger), "In Air Limit") and flags_status == 256 and not flags_climbing_adder then
		lag_first_limit = ui.get(amount_mode) == "Fluctuate" and ui.get(fakelag_fluctuate_limit) or ui.get(trigger_aerial_limit)
		lag_two_limit = ui.get(trigger_aerial_limit)
	else
		lag_first_limit = lag_first_limit < 1 and 1 or lag_first_limit
		lag_two_limit = lag_two_limit < 1 and 1 or lag_two_limit
	end

	lag_shit ={{
		variance = 0,
		limit = lag_first_limit,
		break_lagcomp = true,
		amount = lag_new_amo
	},
	{
		variance = 0,
		limit = lag_two_limit,
		break_lagcomp = false,
		amount = lag_new_amo
	}}
end

client.set_event_callback("setup_command", status_lagshift)

client.set_event_callback("setup_command", function(cmd)
	local localplayer = entity.get_local_player()
	if not localplayer or not entity.is_alive(localplayer) or not ui.get(fakelag_enabled) then
		return
	end

	local flags_weapon_switch = cmd.weaponselect
	local flags_on_use = cmd.in_use
	local trigger_choked = cmd.chokedcommands
	local vx, vy, vz = entity.get_prop(localplayer, "m_vecVelocity")
	local velocity_speed = math.sqrt((vx * vx) + (vy * vy))
	local onground = (bit.band(entity.get_prop(localplayer, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(localplayer, "m_fFlags"), 2) == 2)
	local slowwalking = ui.get(slow_walk) and ui.get(slow_hotkey)
	local exploit = ui.get(on_shot) and ui.get(on_shot_hotkey) or ui.get(double_tap) and ui.get(double_tap_hotkey) or ui.get(ref_fakeduck)
	local weapons = entity.get_player_weapon(localplayer)
	local next_attack = entity.get_prop(weapons, "m_flNextPrimaryAttack")
	local tickbase_shift = entity.get_prop(localplayer, "m_nTickBase")
	local fired_shoot = next_attack <= tickbase_shift * globals.tickinterval() - 0.12
	local in_freeze_time = entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1
	local player_move_type = entity.get_prop(localplayer, "m_movetype")
	local flags_climbing_adder = player_move_type == 9

	local flags_on_land = false
	if not onground then
		client.delay_call(0.75, function(land)
			flags_on_land = true
		end)

		client.delay_call(0.9, function(land)
			flags_on_land = false
		end)
	end

	if velocity_speed < 5 and not slowwalking and onground and not infiniteduck and velocity_speed < 190 and not exploit and fired_shoot == true and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then 
		State = "Default"
	elseif velocity_speed > 2 and not slowwalking and onground and not infiniteduck and velocity_speed < 190 and not exploit and fired_shoot == true and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then
		State = "Running"
	elseif velocity_speed > 2 and slowwalking and onground and not infiniteduck and velocity_speed < 190 and not exploit and fired_shoot == true and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then
		State = "Slow Motion"
	elseif velocity_speed > 190 and onground and not infiniteduck and not exploit and fired_shoot == true and flags_on_use == 0 and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then
		State = "High Speed"
	elseif not onground and not exploit and fired_shoot == true and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then
		State = "Air"
	elseif infiniteduck and velocity_speed < 190 and not exploit and fired_shoot == true and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and flags_on_land == false and not flags_climbing_adder then
		State = "Crouching"
	elseif exploit and flags_on_use == 0 and not in_freeze_time and flags_weapon_switch <= 0 and not flags_climbing_adder then
		State = "Exploit"
	elseif flags_on_use == 1 and fired_shoot == true and not in_freeze_time and flags_weapon_switch <= 0 and not flags_climbing_adder then
		State = "In Use"
	elseif fired_shoot == false and not in_freeze_time and flags_weapon_switch <= 0 and flags_weapon_reload == true and not flags_climbing_adder then
		State = "Fired"
	elseif flags_weapon_switch >= 0.001 and not in_freeze_time and onground and flags_on_land == false and not flags_climbing_adder then
		State = "Weapon Switch"
	elseif fired_shoot == false and flags_weapon_reload == false and onground and not in_freeze_time and flags_on_land == false and flags_weapon_switch <= 0 and not flags_climbing_adder then
		State = "Weapon Reload"
	elseif flags_on_land == true and flags_weapon_switch <= 0 and not in_freeze_time and fired_shoot == false and not flags_climbing_adder then
		State = "On Land"
	elseif flags_climbing_adder and not in_freeze_time then
		State = "Climbing Ldder"
	elseif in_freeze_time then
		State = "Freeze Time"
	end

	local trigger_always_packet = true
	local trigger_send_packet = true
	if multi_select(ui.get(fakelag_send_packet_trigger), "On Standing") and State == "Default" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "While Moving") and State == "Running" or multi_select(ui.get(fakelag_send_packet_trigger), "While Moving") and State == "Slow Motion" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Duck") and State == "Crouching" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On High Speed") and State == "High Speed" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Jump") and State == "Air" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Exploit") and State == "Exploit" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "Weapon Fired") and State == "Fired" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Use") and State == "In Use" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Freezetime") and State == "Freeze Time" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "Weapon Switch") and State == "Weapon Switch" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "Weapon Reload") and State == "Weapon Reload" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "On Land") and State == "On Land" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if multi_select(ui.get(fakelag_send_packet_trigger), "While Climbing Ladder") and State == "Climbing Ldder" then
		trigger_send_packet = trigger_choked >= ui.get(limit)
		trigger_always_packet = false
	end

	if ui.get(fakelag_trigger_types) == "Fakelag Limiter" then
		cmd.allow_send_packet = false
		fakelag_limit_trigger_status = trigger_always_packet == true and ui.get(fakelag_limit_trigger_limit) or lag_shit[lag_info.current_phase].limit
	elseif ui.get(fakelag_trigger_types) == "Fakelag Send Packet Trigger" then
		cmd.allow_send_packet = ui.get(amount_mode) == "Fluctuate" and false or trigger_send_packet
		fakelag_limit_trigger_status = lag_shit[lag_info.current_phase].limit
	end

end)


local function choke_cycle(cmd)
	local local_player = entity.get_local_player()
	if not local_player or not entity.is_alive(local_player) then
		return
	end

	if cmd.chokedcommands < lag_info.prev_choked then
		lag_info.current_phase = lag_info.current_phase + 1
		if lag_info.current_phase > #lag_shit then
			lag_info.current_phase = 1
		end
	end

	if ui.get(fakelag_enabled) then
		ui.set(amount, ui.get(ref_fakeduck) and "Maximum" or lag_shit[lag_info.current_phase].amount)
		ui.set(variance, ui.get(ref_fakeduck) and 0 or lag_shit[lag_info.current_phase].variance)
		ui.set(limit, ui.get(ref_fakeduck) and 15 or fakelag_limit_trigger_status)
	end

	ui.set(lagcomp_break, lag_shit[lag_info.current_phase].break_lagcomp)
	lag_info.prev_choked = cmd.chokedcommands
end

client.set_event_callback("setup_command",choke_cycle)

local set_cache = function(self)
	local localplayer = entity.get_local_player()
	local weapon = entity.get_player_weapon(localplayer)
	local player_move_type = entity.get_prop(localplayer, "m_movetype")
	local flags_status = entity.get_prop(localplayer, "m_fFlags")
	local flags_climbing_adder = player_move_type == 9
	local aerial_flags = not flags_climbing_adder and flags_status == 256
	if not localplayer or not entity.is_alive(localplayer) or not ui.get(fakelag_enabled) or ui.get(ref_fakeduck) or weapon == nil or multi_select(weapons_disabled, entity.get_classname(weapon)) or not multi_select(ui.get(fakelag_slider_trigger), "Avoid Fired Limit") or aerial_flags then
		return
	end

	local process = function(name, condition, should_call, VAR)
	local hotkey_modes = {
		[0] = "always on",
		[1] = "on hotkey",
		[2] = "toggle",
		[3] = "off hotkey"
	}

	local _cond = ui.get(condition)
	local _type = type(_cond)

	local value, mode = ui.get(condition)
	local finder = mode ~= nil and mode or (_type == "boolean" and tostring(_cond) or _cond)
	cache[name] = cache[name] ~= nil and cache[name] or finder

	if should_call then ui.set(condition, mode ~= nil and hotkey_modes[VAR] or VAR) else
		if cache[name] ~= nil then
			local _cache = cache[name]
			if _type == "boolean" then
				if _cache == "true" then 
					_cache = true 
				end

				if _cache == "false" then 
					_cache = false 
				end
			end
    
				ui.set(condition, mode ~= nil and hotkey_modes[_cache] or _cache)
				cache[name] = nil
			end
		end
	end

	process("limit", limit, (self == nil and false or self), ui.get(trigger_fired_limit))
end

client.set_event_callback("shutdown", set_cache)

client.set_event_callback("setup_command", function(cmd)
	local localplayer = entity.get_local_player()
	local weapon = entity.get_player_weapon(localplayer)
	local player_move_type = entity.get_prop(localplayer, "m_movetype")
	local flags_status = entity.get_prop(localplayer, "m_fFlags")
	local flags_climbing_adder = player_move_type == 9
	local aerial_flags = not flags_climbing_adder and flags_status == 256
	if not localplayer or not entity.is_alive(localplayer) or not ui.get(fakelag_enabled) or ui.get(ref_fakeduck) or weapon == nil or multi_select(weapons_disabled, entity.get_classname(weapon)) or not multi_select(ui.get(fakelag_slider_trigger), "Avoid Fired Limit") or aerial_flags then
		return
	end

	local last_shot_time = entity.get_prop(weapon, "m_fLastShotTime")
	local m_iItem = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
	local limitation = function(cmd)
	local in_accel = function()
		local localplayer = entity.get_local_player()
		local x, y = entity.get_prop(localplayer, "m_vecVelocity")
		return math.sqrt(x^2 + y^2) ~= 0
	end

	local max_commands = in_accel() and 1 or 2
	if not data.threshold and last_shot_time ~= data.stored_last_shot then
		data.stored_last_shot = last_shot_time
		if not onshot_mode then
			data.threshold = true
		end

		return true
	end

	if data.threshold and cmd.chokedcommands >= max_commands then
		data.threshold = false
		return true
	end
		return false
	end
    
	if data.stored_item ~= m_iItem then
		data.stored_last_shot = last_shot_time
		data.stored_item = m_iItem
	end

	set_cache(limitation(cmd))
end)

client.set_event_callback("paint",function(e)
	ui.set_visible(lagcomp_break, false)
	ui.set_visible(fakelag_limit, ui.get(fakelag_enabled))
	ui.set_visible(variance_slider, ui.get(fakelag_enabled))
	ui.set_visible(amount_mode, ui.get(fakelag_enabled))
	ui.set_visible(variance_mode, ui.get(fakelag_enabled))
	ui.set_visible(fakelag_slider_trigger, ui.get(fakelag_enabled))
	ui.set_visible(fakelag_trigger_types, ui.get(fakelag_enabled))
	ui.set_visible(fakelag_send_packet_trigger, ui.get(fakelag_enabled))
	ui.set_visible(fakelag_fluctuate_limit, ui.get(fakelag_enabled) and ui.get(amount_mode) == "Fluctuate" )
	ui.set_visible(trigger_wall_limit, ui.get(fakelag_enabled) and multi_select(ui.get(fakelag_slider_trigger), "Wall Peek Limit"))
	ui.set_visible(trigger_fired_limit, ui.get(fakelag_enabled) and multi_select(ui.get(fakelag_slider_trigger), "Fired Limit"))
	ui.set_visible(trigger_aerial_limit, ui.get(fakelag_enabled) and multi_select(ui.get(fakelag_slider_trigger), "In Air Limit"))
	ui.set_visible(trigger_visible_limit, ui.get(fakelag_enabled) and multi_select(ui.get(fakelag_slider_trigger), "Visible Limit"))
	ui.set_visible(fakelag_limit_trigger_limit, ui.get(fakelag_enabled) and ui.get(fakelag_trigger_types) == "Fakelag Limiter")
end)

--Side Menu Panel Updatelog
local menu_disabler = ui.new_checkbox("AA", "Other", "Disable Mewtwo Side Menu")
local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'
local pattern = table.concat{
  x,x,o,x,
  o,x,o,x,
  o,x,x,x,
  o,x,o,x
}
local tex_id = renderer.load_rgba(pattern, 4, 4)
renderer.texture(tex_id, x, y, w, h, 255, 255, 255, 255, 'r')

client.set_event_callback("paint_ui", function()
    local menux, menuy = ui.menu_position()
    if ui.is_menu_open() then
        if not ui.get(menu_disabler) then
            renderer.gradient(menux - 300, menuy + 80, 270, 2, 39, 245, 245, 255, 184, 39, 212, 255, true)
            renderer.rectangle(menux - 300, menuy + 80, 270, 200, 0, 0, 0, 50)
            renderer.text(menux - 280, menuy + 90, 255, 255, 255, 255, '-', 0, 'MEWTWO.TECHNOLOGIES')
		    renderer.text(menux - 183, menuy + 90, 255, 251, 0, 255, '-', 0, 'VIP')  --VersionReplace
            renderer.text(menux - 155, menuy + 90, 255, 255, 255, 255, '-', 0, 'FOR')
		    renderer.text(menux - 135, menuy + 90, 255, 255, 255, 255, '-', 0, 'GAME')
		    renderer.text(menux - 113.1, menuy + 90, 30, 255, 0, 255, '-', 0, 'SENSE')
            renderer.text(menux - 280, menuy + 105, 255, 255, 255, 255, '-', 0, 'LATEST UPDATE: 02.08.2023')
            renderer.text(menux - 280, menuy + 120, 255, 255, 255, 255, '-', 0, '[UPDATE 19.05]')
            renderer.text(menux - 270, menuy + 130, 255, 255, 255, 255, '-', 0, '-[+] ADDED MEWTWO RADIO + SONG INDICATOR - VISUALS>OTHER ESP')
            renderer.text(menux - 270, menuy + 140, 255, 255, 255, 255, '-', 0, '-[+] FIXED FREESTAND HOTKEY + MENU RETURN ON UNLOAD')
            renderer.text(menux - 270, menuy + 150, 255, 255, 255, 255, '-', 0, '-[+] ADDED LAST SEEN ESP WITH CHANGEABLE COLOR ')
		    renderer.text(menux - 270, menuy + 160, 255, 255, 255, 255, '-', 0, '-[+] ADDED AUTO WALK PEEK COMBINDED WITH HITPREDICTION')
            renderer.text(menux - 270, menuy + 170, 255, 255, 255, 255, '-', 0, '-[-] REMOVED MEWTWO RESOLVER (EARLY STATE) DUE TO REWORK')
		    renderer.text(menux - 270, menuy + 180, 255, 255, 255, 255, '-', 0, '-[+] ADDED ANIMATED HITLOGS WITH ALOT OF CUSTOMIZATION')
		    renderer.text(menux - 280, menuy + 200, 255, 255, 255, 255, '-', 0, '-[LOOKING FORWARD TO ADD]')
            renderer.text(menux - 270, menuy + 210, 0, 255, 0, 255, '-', 0, '-SHARED LOGO (NL USERS WILL SEE MEWTWO GS USERS)')
            renderer.text(menux - 270, menuy + 220, 0, 255, 0, 255, '-', 0, '-RAGEBOT LIVE READER (IF HEAD RESOLVABLE OR PREFERS BODY)')
            renderer.text(menux - 270, menuy + 230, 0, 255, 0, 255, '-', 0, '-3/5 WAY JITTER, CUSTOMIZABLE IN EVERYWAY')
		    --renderer.text(menux - 270, menuy + 240, 0, 255, 0, 255, '-', 0, '-FIXING SMALL ERRORS HIDE RAGE AND ERROR IMAGE ON LOAD')
		    renderer.text(menux - 270, menuy + 245, 35, 235, 185, 255, '-', 0, 'FOR SUPPORT OR TO REPORT BUGS PLEASE JOIN OUR DISCORD!')
            renderer.text(menux - 230, menuy + 260, 255, 0, 120, 255, '-', 0, 'DISCORD: DISCORD.GG/MEWTWOTECH')
        end
    end
end)

print("Anti-Aim has been loaded!")
end
scripts["Essentials"] = function(name, check)
scripts[name] = loader
if check ~= secret and not reached then return end
print("Loading: ", name)
--Mewtwo Essentials
local images = require 'gamesense/images'
local http = require 'gamesense/http'
local vector = require 'vector'

local visual_label_spacer = ui.new_label("Visuals","Other ESP", " ")
local visual_label = ui.new_label("Visuals","Other ESP", "              \ad6b6f7ff+ Mewtwo Essentials + ")
--LC Debug + DT Shift 
local g_esp_data = { }
local g_sim_ticks, g_net_data = { }, { }

local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local entity_get_bounding_box = entity.get_bounding_box
local entity_get_player_name = entity.get_player_name
local renderer_text = renderer.text
local w2s = renderer.world_to_screen
local line = renderer.line
local table_insert = table.insert
local client_trace_line = client.trace_line
local math_floor = math.floor
local globals_frametime = globals.frametime

local sv_gravity = cvar.sv_gravity
local sv_jump_impulse = cvar.sv_jump_impulse

--UI 
local lc_enabler = ui.new_checkbox("Visuals", "Other ESP", "Enable LC Prediction Box")
local box_color = ui.new_color_picker("Visuals", "Other ESP", "Box Color")
local text_enabler = ui.new_checkbox("Visuals", "Other ESP", "Enable Text (LC/DT Shift)")
local color_text = ui.new_color_picker("Visuals", "Other ESP", "Color Text")

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_add = function(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local get_entities = function(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}

    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()
    
	for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
	end

	return result
end

local extrapolate = function(ent, origin, flags, ticks)
    local tickinterval = globals_tickinterval()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = origin, origin

    local velocity = { entity_get_prop(ent, 'm_vecVelocity') }
    local gravity = velocity[3] > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin = {
            p_origin[1] + (velocity[1] * tickinterval),
            p_origin[2] + (velocity[2] * tickinterval),
            p_origin[3] + (velocity[3]+gravity) * tickinterval,
        }

        local fraction = client_trace_line(-1, 
            prev_origin[1], prev_origin[2], prev_origin[3], 
            p_origin[1], p_origin[2], p_origin[3]
        )

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

local function g_net_update()
	local me = entity_get_local_player()
    local players = get_entities(true, true)

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
            g_esp_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    local extrapolated = extrapolate(idx, player_origin, m_fFlags, delta-1)
    
                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        predicted_origin = extrapolated,

                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end
    
            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
	end
end

local function g_paint_handler()
    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()

    if not me or not entity_is_alive(me) then
        return
    end
 
	local observer_mode = entity_get_prop(me, "m_iObserverMode")
	local active_players = {}

	if (observer_mode == 0 or observer_mode == 1 or observer_mode == 2 or observer_mode == 6) then
		active_players = get_entities(true, true)
	elseif (observer_mode == 4 or observer_mode == 5) then
		local all_players = get_entities(false, true)
		local observer_target = entity_get_prop(me, "m_hObserverTarget")
		local observer_target_team = entity_get_prop(observer_target, "m_iTeamNum")

		for test_player = 1, #all_players do
			if (
				observer_target_team ~= entity_get_prop(all_players[test_player], "m_iTeamNum") and
				all_players[test_player ] ~= me
			) then
				table_insert(active_players, all_players[test_player])
			end
		end
	end

    if #active_players == 0 then
        return
    end

    for idx, net_data in pairs(g_net_data) do
        if entity_is_alive(idx) and entity_is_enemy(idx) and net_data ~= nil then
            if net_data.lagcomp then
                local predicted_pos = net_data.predicted_origin

                local min = vec_add({ entity_get_prop(idx, 'm_vecMins') }, predicted_pos)
                local max = vec_add({ entity_get_prop(idx, 'm_vecMaxs') }, predicted_pos)

                local points = {
                    {min[1], min[2], min[3]}, {min[1], max[2], min[3]},
                    {max[1], max[2], min[3]}, {max[1], min[2], min[3]},
                    {min[1], min[2], max[3]}, {min[1], max[2], max[3]},
                    {max[1], max[2], max[3]}, {max[1], min[2], max[3]},
                }

                local edges = {
                    {0, 1}, {1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8},
                    {0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}
                }

                local rgblc = {ui.get(box_color)}

                for i = 1, #edges do
                    if i == 1 then
                        local origin = { entity_get_origin(idx) }
                        local origin_w2s = { w2s(origin[1], origin[2], origin[3]) }
                        local min_w2s = { w2s(min[1], min[2], min[3]) }

                        if origin_w2s[1] ~= nil and min_w2s[1] ~= nil then
                            if ui.get(lc_enabler) then
                                line(origin_w2s[1], origin_w2s[2], min_w2s[1], min_w2s[2], rgblc[1], rgblc[2], rgblc[3], 255)
                            end
                        end
                    end

                    if points[edges[i][1]] ~= nil and points[edges[i][2]] ~= nil then
                        local p1 = { w2s(points[edges[i][1]][1], points[edges[i][1]][2], points[edges[i][1]][3]) }
                        local p2 = { w2s(points[edges[i][2]][1], points[edges[i][2]][2], points[edges[i][2]][3]) }
                        if ui.get(lc_enabler) then
                            line(p1[1], p1[2], p2[1], p2[2], rgblc[1], rgblc[2], rgblc[3], 255)
                        end
                    end
                end
            end

            local text = {
                [0] = '', [1] = 'LC BROKEN',
                [2] = 'DT SHIFT'
            }
            local x1, y1, x2, y2, a = entity_get_bounding_box(idx)
            local palpha = 0

            if g_esp_data[idx] > 0 then
                g_esp_data[idx] = g_esp_data[idx] - globals_frametime()*2
                g_esp_data[idx] = g_esp_data[idx] < 0 and 0 or g_esp_data[idx]

                palpha = g_esp_data[idx]
            end

            local tb = net_data.tickbase or g_esp_data[idx] > 0
            local lc = net_data.lagcomp

            if not tb or net_data.lagcomp then
                palpha = a
            end

            local rgbtext = {ui.get(color_text)}

            if x1 ~= nil and a > 0 then
                local name = entity_get_player_name(idx)
                local y_add = name == '' and -8 or 0
                if ui.get(text_enabler) then
                    renderer_text(x1 + (x2-x1)/2, y1 - 18 + y_add, rgbtext[1], rgbtext[2], rgbtext[3], palpha*255, 'c-', 0, text[tb and 2 or (lc and 1 or 0)])
                end
            end
        end
    end
end

client.set_event_callback('paint', g_paint_handler)
client.set_event_callback('net_update_end', g_net_update)




--Airwalk Clientside Animation
local ent = require "gamesense/entity"
local checkbox = ui.new_checkbox("Visuals", "Other ESP", "Air-Walking Animation")
--Last Seen ESP
local round = function(b) return math.floor(b + 0.5) end
local contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end

local tab, container = 'VISUALS', 'Other ESP'
local reference = {
    name = ui.reference('Visuals', 'Player ESP', 'Name')
}
local interface = {
    enabled = ui.new_checkbox(tab, container, 'Last Seen ESP'),
    fading = ui.new_color_picker(tab, container, 'Fading', 255, 255, 255, 255),
    bounding = ui.new_color_picker(tab, container, 'Fully Dormant', 255, 255, 255, 255),
    options = ui.new_multiselect(tab, container, '\n', 'Fading', 'Fully Dormant Box')
}

local get_players = function(enemies_only)
    local result = {}

    local maxplayers = globals.maxplayers()
    local player_resource = entity.get_player_resource()
    
	for player = 1, maxplayers do
        local enemy = entity.is_enemy(player)
        local alive = entity.get_prop(player_resource, 'm_bAlive', player)

        if (not enemy and enemies_only) or alive ~= 1 then goto skip end

        table.insert(result, player) 

        ::skip::
	end

	return result
end

local paint_box = function(x, y, w, h, r, g, b, a)
    renderer.rectangle(x + 1, y, w - 1, 1, r, g, b, a)
    renderer.rectangle(x + w - 1, y + 1, 1, h - 1, r, g, b, a)
    renderer.rectangle(x, y + h - 1, w - 1, 1, r, g, b, a)
    renderer.rectangle(x, y, 1, h - 1, r, g, b, a)
end

local on_paint = function()
    local local_player = entity.get_local_player()
    local is_alive = entity.is_alive(local_player)
    
    if not local_player or not is_alive then return end

    players = get_players(true)

    local name = ui.get(reference.name)
    local color = { 
        { ui.get(interface.fading) },
        { ui.get(interface.bounding) }
    }
    local options = ui.get(interface.options)

    for i, player in pairs(players) do
        local box = { entity.get_bounding_box(player) }
        local height = 20 or 8
        local alpha, fading = box[5]*255, round(box[5]*10)
        local is_dormant = entity.is_dormant(player)
        local is_alive = entity.is_alive(player)

        if box[1] and box[5] > 0 and is_dormant and contains(options, 'Fading') and is_alive then
            renderer.text(box[1]/2 + box[3]/2, box[2] - height, color[1][1], color[1][2], color[1][3], alpha, 'c-', 0, string.format('DORMANT (%s0%%)', fading))
        elseif box[1] and box[5] == 0 and is_dormant and contains(options, 'Fully Dormant Box') and is_alive then
            renderer.text(box[1]/2 + box[3]/2, box[2] - 8, color[2][1], color[2][2], color[2][3], color[2][4], 'c-', 0, 'LAST SEEN')
            paint_box(box[1] + 1, box[2] + 1, box[3] - box[1] - 2, box[4] - box[2] - 2, 0, 0, 0, color[2][4])
            paint_box(box[1], box[2], box[3] - box[1], box[4] - box[2], color[2][1], color[2][2], color[2][3], color[2][4])
            paint_box(box[1] - 1, box[2] - 1, box[3] - box[1] + 2, box[4] - box[2] + 2, 0, 0, 0, color[2][4])
        end
    end
end

local handle_callback = function(event)
	local handle = event and client.set_event_callback or client.unset_event_callback

	handle('paint', on_paint)
end

ui.set_callback(interface.enabled, function()
	local enabled = ui.get(interface.enabled)
	handle_callback(enabled)
end)

--Hitprediction
-- Define initial scan parameters
local scanWidth, scanLength = 5, 120
local scanResult = nil

-- Define menu parameters
local menuParams = {"Visuals", "Other ESP"}
local widthChoices  = {"Exact", "Accurate", "Default", "Unstable", "Inaccurate"}
local lengthChoices = {"Very Close", "Close", "Default", "Far", "Very Far"}

-- Define menu elements
local menu = {}
menu.label  = ui.new_label(menuParams[1], menuParams[2], " ")
menu.enable = ui.new_checkbox(menuParams[1], menuParams[2], "\a12EC0997Enable \ad6b6f7ffMewtwo Hitprediction")
menu.hotkey = ui.new_hotkey(menuParams[1], menuParams[2], '\nAutopeek hotkey', menu.enable)
menu.width  = ui.new_slider(menuParams[1], menuParams[2], "Accuracy", 1, 5, 3, true, "", 1, widthChoices)
menu.length = ui.new_slider(menuParams[1], menuParams[2], "Distance", 1, 5, 3, true, "", 1, lengthChoices)
    
menu.textColorLabel = ui.new_label(menuParams[1], menuParams[2], "Text Color")
menu.textColorPicker = ui.new_color_picker(menuParams[1], menuParams[2], "__Text Color", 255, 255, 255, 255)

menu.lineColorLabel = ui.new_label(menuParams[1], menuParams[2], "Line Color")
menu.lineColorPicker = ui.new_color_picker(menuParams[1], menuParams[2], "__Line Color", 255, 255, 255, 255)

local quackPeekArschist_Checkbox, quackPeekArschist_Hotkey = ui.reference('RAGE', 'Other', 'Quick peek assist')

-- Function to set visibility of elements in a table
local function setVisibility(table, visibility)
    for key, value in pairs(table) do
        -- If the value is a table, iterate through its elements
        if type(table[key]) == "table" then
            for subKey, subValue in pairs(table[key]) do
                ui.set_visible(table[key][subKey], visibility)
            end
        else
            ui.set_visible(table[key], visibility)
        end
    end
end

-- Function to set color
local function setColor(red, green, blue, alpha)
    if red == nil then
        return {r = 255, g = 255, b = 255, a = 255}
    elseif type(red) == "number" then
        return {r = math.floor(red) or 255, g = math.floor(green) or 255, b = math.floor(blue) or 255, a = math.floor(alpha) or 255}
    elseif type(red) == "table" then
        return {
            r = math.floor(red[1]) or 255,
            g = math.floor(red[2]) or 255,
            b = math.floor(red[3]) or 255,
            a = math.floor(red[4]) or 255
        }
    else
        return error("[setColor] Invalid Type : " .. type(red))
    end
end

-- Function to handle callback
local function handleCallback(event, callback, isSet)
    local eventFunction = isSet and client.set_event_callback or client.unset_event_callback
    eventFunction(event, callback)
end

-- Function to calculate vector angles
local function calculateVectorAngles(vector1, vector2)
    local vectorA, vectorB
    if vector2 == nil then
        vectorB, vectorA = vector1, vector(client.eye_position())
        if vectorA.x == nil then
            return
        end
    else
        vectorA, vectorB = vector1, vector2
    end
    local vectorDiff = vectorB - vectorA
    if vectorDiff.x == 0 and vectorDiff.y == 0 then
        return 0, vectorDiff.z > 0 and 270 or 90
    else
        local angleY = math.deg(math.atan2(vectorDiff.y, vectorDiff.x))
        local hypotenuse = math.sqrt(vectorDiff.x * vectorDiff.x + vectorDiff.y * vectorDiff.y)
        local angleX = math.deg(math.atan2(-vectorDiff.z, hypotenuse))
        return angleX, angleY
    end
end

-- Function to check overlap
local function checkOverlap(object1, object2)
    if object1 and not object2 then
        return object1
    elseif not object1 and object2 then
        return object2
    end
    if object1.is_active and object2.is_active then
        if object1.length < object2.length then
            object2.is_active = false
            return object1
        elseif object1.length > object2.length then
            object1.is_active = false
            return object2
        end
    else
        return object1.is_active and object1 or object2
    end
end

-- Function to scan side
local function scanSide(entityIndex, origin, target, direction, position, side)
    local scanLength, hitFraction, counter = 15, 0, 0
    local previousPosition = position
    while hitFraction < 1 and scanLength < scan_length do
        position = origin + direction * scanLength
        _, hitFraction = client.trace_bullet(entityIndex, target.x, target.y, target.z, position.x, position.y, position.z)
        scanLength = scanLength + scan_width

		local fraction, entity_index = client.trace_line( entity.get_local_player(),
			previousPosition.x, previousPosition.y, previousPosition.z,
			position.x, position.y, position.z
		)
        if fraction < 1 and counter > 4 then
            return nil
        end
        previousPosition = position
        counter = counter + 1
    end
    return scanLength <= scan_length and {is_active = true, vector = position, index = entityIndex, length = scanLength, side = side} or nil
end

-- Function to calculate right angle
local function calculateRightAngle(angle)
    local sinX = math.sin(math.rad(angle.x))
    local cosX = math.cos(math.rad(angle.x))
    local sinY = math.sin(math.rad(angle.y))
    local cosY = math.cos(math.rad(angle.y))
    local sinZ = math.sin(math.rad(angle.z))
    local cosZ = math.cos(math.rad(angle.z))
    return vector(-1.0 * sinZ * sinX * cosY + -1.0 * cosZ * -sinY, -1.0 * sinZ * sinX * sinY + -1.0 * cosZ * cosY, -1.0 * sinZ * cosX)
end

-- Function to get scan result
local function getScanResult(entityIndex)
    if entityIndex == -1 then
        return nil
    end
    if not entity.is_alive(entityIndex) or not entity.is_enemy(entityIndex) then
        return nil
    end
    local localPlayer = entity.get_local_player()
    local eyePosition = vector(client.eye_position())
    local localOrigin = vector(entity.get_origin(localPlayer))
    local entityOrigin = vector(entity.get_prop(entityIndex, "m_vecOrigin"))
    local entityView = entityOrigin + vector(entity.get_prop(entityIndex, "m_vecViewOffset"))
    local angleX, angleY = calculateVectorAngles(localOrigin, entityOrigin)
    local angleVector = vector(angleX, angleY, 0)
    local rightAngleVector = calculateRightAngle(angleVector)
    local leftAngleVector = rightAngleVector*-1
    local leftPosition = eyePosition + leftAngleVector * scan_width
    local rightPosition = eyePosition + rightAngleVector * scan_width
    local hitboxPosition = vector(entity.hitbox_position(localPlayer, 1))
    local _, hitFraction = client.trace_bullet(entityIndex, entityView.x, entityView.y, entityView.z, hitboxPosition.x, hitboxPosition.y, hitboxPosition.z)
    if hitFraction <= 0 then
        local leftScan = scanSide(entityIndex, eyePosition, entityView, leftAngleVector, leftPosition, "left")
        local rightScan = scanSide(entityIndex, eyePosition, entityView, rightAngleVector, rightPosition, "right")
        return (leftScan or rightScan) and checkOverlap(leftScan, rightScan) or nil
    else
        return nil
    end
end

local function set_movement(cmd, desired_pos)
    local local_player = entity.get_local_player()
	local vec_angles = {
		vector(
			entity.get_origin( local_player )
		):to(
			desired_pos
		):angles()
	}

    local pitch, yaw = vec_angles[1], vec_angles[2]

    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0

    cmd.forwardmove = 800
    cmd.sidemove = 0

    cmd.move_yaw = yaw
end

-- Define main functions
local function angleScan()
    local target = client.current_threat()
	if not target then return end

    local target_result = getScanResult(target)
    local t_scan_result = getScanResult(scan_result and scan_result.index or -1)      

    if not t_scan_result and target_result then
        scan_result = target_result
    elseif t_scan_result and target_result then   
        scan_result = target_result.length < t_scan_result.length and target_result or t_scan_result
    elseif not t_scan_result and not target_result then
        scan_result = nil
    end
end

local function drawHitLines()
    if not scan_result then return end

    local local_player  = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local local_origin  = vector(entity.get_origin(local_player))

    local t_clr = setColor({ui.get(menu.textColorPicker)})
    local l_clr = setColor({ui.get(menu.lineColorPicker)})

    local pos = scan_result.vector
    local xl, yl = renderer.world_to_screen(pos.x, pos.y, pos.z)
    if xl ~= nil and yl ~= nil then
        local x, y = renderer.world_to_screen(pos.x, pos.y, local_origin.z)
        renderer.text(xl, yl - 15, t_clr.r, t_clr.g, t_clr.b, t_clr.a, "bcd", 0, "Hit")
        renderer.line(xl, yl, x, y, l_clr.r, l_clr.g, l_clr.b, l_clr.a)    
    end
end

local function on_setup_command(cmd)
	if not scan_result or not ui.get(menu.hotkey) then return end
	if not scan_result.vector then return end
	set_movement(cmd, scan_result.vector)
end

local function paint()
	local local_player = entity.get_local_player()
	if not local_player then return end
    
    local is_alive = entity.is_alive(local_player)
    if not is_alive then return end

    scan_width, scan_length = ui.get(menu.width) * 2, ui.get(menu.length) * 40

    drawHitLines()
end

local function handleUI(enabled)
    setVisibility({menu.width, menu.length, menu.textColorLabel, menu.textColorPicker, menu.lineColorPicker, menu.lineColorLabel}, enabled)
end
local function on_enable()
	local enabled = ui.get(menu.enable)
	handleUI(enabled)
	local call = client[enabled and 'set_event_callback' or 'unset_event_callback']
	call('paint', paint)
	call('setup_command', on_setup_command)
	call('run_command', angleScan)
end
ui.set_callback(menu.enable, on_enable)
-- Call the UI handler function
handleUI()



--Tracer Debugging with Hitboxes
local client_eye_position, client_screen_size, client_set_event_callback, client_trace_bullet, client_trace_line, entity_get_local_player, entity_get_players, entity_hitbox_position, renderer_line, renderer_world_to_screen, ui_get, ui_new_checkbox, ui_new_multiselect, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_reference, ui_set_callback, ui_set_visible, ipairs, entity_get_prop, math_sqrt, math_abs, math_min, math_max = client.eye_position, client.screen_size, client.set_event_callback, client.trace_bullet, client.trace_line, entity.get_local_player, entity.get_players, entity.hitbox_position, renderer.line, renderer.world_to_screen, ui.get, ui.new_checkbox, ui.new_multiselect, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.reference, ui.set_callback, ui.set_visible, ipairs, entity.get_prop, math.sqrt, math.abs, math.min, math.max

local teammates = ui_reference("VISUALS", "Player ESP", "Teammates")
local menu_enabled = ui_new_checkbox("VISUALS", "Player ESP", "Player Tracers")

local menu_color_hit = ui_new_color_picker("VISUALS", "Player ESP", "Color Hit", 0, 255, 0, 255)

local hitboxes = {
    "Head",
    "Neck",
    "Pelvis",
    "Spine 0",
    "Spine 1",
    "Spine 2",
    "Spine 3",
    "Upper Left Leg",
    "Upper Right Leg",
    "Lower Left Leg",
    "Lower Right Leg",
    "Left Ankle",
    "Right Ankle",
    "Left Hand",
    "Right Hand",
    "Upper Left Arm",
    "Lower Left Arm",
    "Upper Right Arm",
    "Lower Right Arm"
}

local menu_hitbox_tracers = ui_new_multiselect("VISUALS", "Player ESP", "Hitbox", hitboxes)

local menu_only_closest = ui_new_checkbox("VISUALS", "Player ESP", "Only closest")

local menu_visibility_check = ui_new_combobox("VISUALS", "Player ESP", "Tracer check", "None", "Damage", "Visible")
local menu_color_miss = ui_new_color_picker("VISUALS", "Player ESP", "Color Miss", 255, 0, 0, 255)

local menu_damage_threshold = ui_new_slider("VISUALS", "Player ESP", "Damage Threshold", 1, 100, 1, true, "", 1, {[1] = "Can hit", [100] = "HP"})

local menu_distance_calculations = ui_new_combobox("VISUALS", "Player ESP", "Fade mode", "None", "Near crosshair", "Distance")
local menu_distance_factor = ui_new_slider("VISUALS", "Player ESP", "Distance factor", 1, 5, 1, true)

local function handleUI()
    local enabled = ui_get(menu_enabled)
    ui_set_visible(menu_color_hit, enabled)
    ui_set_visible(menu_hitbox_tracers, enabled)
    if ((#ui_get(menu_hitbox_tracers)) > 1) then
        ui_set_visible(menu_only_closest, enabled)
    else
        ui_set_visible(menu_only_closest, false)
    end
    ui_set_visible(menu_visibility_check, enabled)
    ui_set_visible(menu_distance_calculations, enabled)
    if ui_get(menu_visibility_check) ~= "None" then
        ui_set_visible(menu_color_miss, enabled)
    else
        ui_set_visible(menu_color_miss, false)
    end
    if ui_get(menu_visibility_check) == "Damage" then
        ui_set_visible(menu_damage_threshold, enabled)
    else
        ui_set_visible(menu_damage_threshold, false)
    end
    if ui_get(menu_distance_calculations) ~= "None" then
        ui_set_visible(menu_distance_factor, enabled)
    else
        ui_set_visible(menu_distance_factor, false)
    end
end

ui_set_callback(menu_enabled, handleUI)
ui_set_callback(menu_hitbox_tracers, handleUI)
ui_set_callback(menu_visibility_check, handleUI)
ui_set_callback(menu_distance_calculations, handleUI)

handleUI() --call handleUI to not fuck up when reloading cfg/luas

function indexIn(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--distance functions
local function distance2d(x1, y1, x2, y2)
    local x, y = math_abs(x1-x2), math_abs(y1-y2)
    return math_sqrt(x*x+y*y)
end

local function distance3d(x1, y1, z1, x2, y2, z2)
    local x, y, z = math_abs(x1-x2), math_abs(y1-y2), math_abs(z1-z2)
    return math_sqrt(x*x+y*y+z*z)
end

client_set_event_callback("paint", function(ctx)
    if not ui_get(menu_enabled) then return end
    local players = entity_get_players(not ui_get(teammates))
    if #players == nil then return end

    local me = entity_get_local_player()

    local vis_type = ui_get(menu_visibility_check)
    local dist_type = ui_get(menu_distance_calculations)
    local dist_factor = ui_get(menu_distance_factor)
    local closest_only = ui_get(menu_only_closest)

    local trace_hitboxes = ui_get(menu_hitbox_tracers)

    for i = 1, #players do 
        if players[i] ~= me then
            local player_lines = {}
            local last_dist = math.huge
            for n = 1, #trace_hitboxes do
                local hbox_x, hbox_y, hbox_z = entity_hitbox_position(players[i], indexIn(hitboxes, trace_hitboxes[n])-1)
                local me_x, me_y, me_z = client_eye_position()

                local hit = false

                if vis_type == "Damage" then
                    local entindex, damage = client_trace_bullet(me, me_x, me_y, me_z, hbox_x, hbox_y, hbox_z)
                    local min_damage = ui_get(menu_damage_threshold)
                    if min_damage == 100 then
                        min_damage = entity_get_prop(players[i], "m_iHealth")
                    end

                    if damage >= min_damage and entindex == players[i] then
                        hit = true
                    end
                elseif vis_type == "Visible" then
                    local fraction, entindex = client_trace_line(me, me_x, me_y, me_z, hbox_x, hbox_y, hbox_z)
                    if entindex == players[i] then 
                        hit = true
                    end
                else
                    hit = true
                end

                local r, g, b, a = 0, 0, 0, 0
                if hit then
                    r, g, b, a = ui_get(menu_color_hit)
                else
                    r, g, b, a = ui_get(menu_color_miss)
                end

                local xa, ya = renderer_world_to_screen(hbox_x, hbox_y, hbox_z)
                if xa ~= nil then
                    local w, h = client_screen_size()

                    if dist_type == "Near crosshair" then
                        local distance = distance2d(w/2, h/2, xa, ya)
                        local distance_delta = distance - 25*dist_factor
                        local max_fade_delta = 150*dist_factor - 25*dist_factor
                        local new_a = math_max(0, math_min(a, (a * (distance_delta / max_fade_delta))))
                        a = new_a
                    elseif dist_type == "Distance" then
                        -- calculate 3d distance between you and the current player, and fade the line depending on the distance
                        local distance = distance3d(me_x, me_y, me_z, hbox_x, hbox_y, hbox_z)
                        local new_a = math_max(0, ((300*dist_factor) - distance) / (300*dist_factor)) * a
                        a = new_a
                    end

                    if closest_only then
                        local cur_dist = distance2d(w/2, h/2, xa, ya)
                        if last_dist > cur_dist and hit then
                            player_lines[1] = {w/2, h/2, xa, ya, r, g, b, a}
                            last_dist = cur_dist
                        end
                    else
                        player_lines[#player_lines+1] = {w/2, h/2, xa, ya, r, g, b, a}
                    end
                end
            end

            for i = 1, #player_lines do
                renderer_line(player_lines[i][1], player_lines[i][2], player_lines[i][3], player_lines[i][4], player_lines[i][5], player_lines[i][6], player_lines[i][7], player_lines[i][8])
            end
        end
    end
end)

local csgo_weapons = require 'gamesense/csgo_weapons'

-- Utils
local function contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

local function extrapolate_position(xpos, ypos, zpos, ticks, ent)
    local x, y, z = entity.get_prop(ent, 'm_vecVelocity')
    for i = 0, ticks do
        xpos = xpos + (x * globals.tickinterval())
        ypos = ypos + (y * globals.tickinterval())
        zpos = zpos + (z * globals.tickinterval())
    end

    return xpos, ypos, zpos
end

local function is_in_air(ent)
    return bit.band(entity.get_prop(ent, 'm_fFlags'), 1) ~= 1
end

-- References
local ref = {
    dt = {ui.reference('RAGE', 'AIMBOT', 'Double tap')}
}

-- Menu
local TAB, CONTAINER = 'AA', 'Other'
local WEAPONS = { 'SSG 08', 'AWP', 'R8 Revolver' }
local interface = {
    switch = ui.new_checkbox(TAB, CONTAINER, 'Teleport helper'),
    tp_hk = ui.new_hotkey(TAB, CONTAINER, 'tp_hk', true),
    tp_weapon_select = ui.new_multiselect(TAB, CONTAINER, 'Teleport weapons', WEAPONS),
    dmg_slider = ui.new_slider(TAB, CONTAINER, 'Minimum teleport damage', 0, 100, 0, true, nil, 1, { [0] = 'Lethal' }),
    ticks_slider = ui.new_slider(TAB, CONTAINER, 'Predicted ticks', 0, 30, 0, true, nil, 1),
    disable_air_switch = ui.new_checkbox(TAB, CONTAINER, 'Disable teleport in air'),
}

local function handle_visibility()
    local enabled = ui.get(interface.switch)

    ui.set_visible(interface.disable_air_switch, enabled)
    ui.set_visible(interface.dmg_slider, enabled)
    ui.set_visible(interface.ticks_slider, enabled)
end

handle_visibility()
ui.set_callback(interface.switch, handle_visibility)

local HITGROUP = 3 -- The hitgroup we want to trace
local teleporting = false -- Needed for indicator
local clr = {0, 255, 0, 255} -- Indicator color

-- Main
local function tp_helper()
    local me = entity.get_local_player()
    
    ui.set(ref.dt[1], true)
    teleporting = false

    if not ui.get(interface.switch) or (ui.get(interface.disable_air_switch) and not is_in_air(me)) or not ui.get(interface.tp_hk) then
        return
    end

    -- Check if we're holding a weapon we want to teleport
    local me_wpn = csgo_weapons(entity.get_player_weapon(me))
    local wpn_name = me_wpn.name
    if not contains(WEAPONS, wpn_name) then
        return
    end
    
    -- Extrapolate player pos
    local ticks = ui.get(interface.ticks_slider)
    local me_pos = {entity.hitbox_position(me, HITGROUP)}
    local x, y, z = extrapolate_position(me_pos[1], me_pos[2], me_pos[3], ticks, me)

    -- Damage calculation
    local dmg = ui.get(interface.dmg_slider)
    local players = entity.get_players(true)
    local hp = entity.get_prop(me, 'm_iHealth')

    for _, player in pairs(players) do
        -- Trace bullet from enemy eye pos to our hitbox
        local eye_pos = {entity.hitbox_position(player, 0)}

        local _, b_dmg = client.trace_bullet(player, eye_pos[1], eye_pos[2], eye_pos[3], x, y, z, true)
        b_dmg = client.scale_damage(me, HITGROUP, b_dmg)

        local should_tp = dmg == 0 and b_dmg >= hp or b_dmg >= dmg

        if should_tp then
            ui.set(ref.dt[1], false)
            teleporting = true
            clr = {0, 255, 0, 255}
            break
        elseif b_dmg > 0 then
            teleporting = true
            clr = {255, 0, 0, 255}
        else
            teleporting = false
        end
    end
end

-- Indicator
local function tp_indicator()
    local me = entity.get_local_player()

    if not entity.is_alive(me) then
        return
    end

    if teleporting then
        renderer.indicator(clr[1], clr[2], clr[3], clr[4], 'TELEPORTING')
    elseif ui.get(interface.tp_hk) then
        renderer.indicator(255, 255, 255, 255, 'TP')
    end
end

-- Callbacks
client.set_event_callback('setup_command', tp_helper)
client.set_event_callback('paint', tp_indicator)

--Clantag
local client_set_clan_tag = client.set_clan_tag
local entity_get_local_player, entity_is_alive = entity.get_local_player, entity.is_alive
local globals_tickcount, globals_tickinterval = globals.tickcount, globals.tickinterval
local ui_new_checkbox, ui_reference, ui_set_visible, ui_get, ui_set_callback = ui.new_checkbox, ui.reference, ui.set_visible, ui.get, ui.set_callback
local math_floor = math.floor
local string_sub = string.sub

local visual_label_spacer = ui.new_label("Visuals", "Other ESP", " ")

local function time_to_ticks(time)
    return math_floor(time / globals_tickinterval() + .5)
end

local skeet_tag_name = "Mewtwo.Tech"

local enabled_reference = ui_new_checkbox("Visuals", "Other ESP", "Enable Mewtwo Clantag")
local default_reference = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")

local clan_tag_prev = ""
local enabled_prev = false

local function gamesense_anim(text, indices)
    local text_anim = "               " .. text .. "                      "
    local tickcount = globals_tickcount()
    local i = tickcount / time_to_ticks(0.3)
    i = math_floor(i % #indices)
    i = indices[i+1]+1

    return string_sub(text_anim, i, i+15)
end

local function run_tag_animation()
    if ui_get(enabled_reference) and not ui_get(default_reference) then
        local clan_tag = gamesense_anim("Mewtwo.Tech", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
        if clan_tag ~= clan_tag_prev then
            client_set_clan_tag(clan_tag)
        end
        clan_tag_prev = clan_tag
    end
end

local function on_paint(ctx)
    local enabled = ui_get(enabled_reference)
    if enabled then
        local local_player = entity_get_local_player()
        if local_player ~= nil and (not entity_is_alive(local_player)) and globals_tickcount() % 2 == 0 then
            run_tag_animation()
        end
    elseif enabled_prev then
        client_set_clan_tag("\0")
    end
    enabled_prev = enabled
end
client.set_event_callback("paint", on_paint)

local function on_run_command(e)
    if ui_get(enabled_reference) then
        if e.chokedcommands == 0 then
            run_tag_animation()
        end
    end
end
client.set_event_callback("run_command", on_run_command)

--Hitlogs
local function contains(b,c)for d,e in pairs(b)do if e==c then return true end end;return false end
local function set_table(b,c,d)for e,f in pairs(c)do if type(f)=='table'then set_table(b,f,d)else b(f,d)end end end
function renderer.outline(x, y, w, h, r, g, b, a) renderer.rectangle(x - 1, y - 1, w + 2, 1, r, g, b, a) renderer.rectangle(x - 1, y + h, w + 2, 1, r, g, b, a) renderer.rectangle(x - 1, y, 1, h, r, g, b, a) renderer.rectangle(x + w, y, 1, h, r, g, b, a) end
function math.clamp(a, b, c)return math.min(math.max(a, b), c)end

local icons = {
    info = images.get_panorama_image('icons/ui/info.svg'),
    error = images.get_panorama_image('icons/ui/warning.svg'),
    miss = images.get_panorama_image('hud/deathnotice/icon_suicide.svg'),
    buy = images.get_panorama_image('icons/ui/inventory.svg'),
    hit = images.get_panorama_image('icons/ui/deathmatch.svg'),
}


local sizes = {}
for i, v in pairs(icons) do
    local i_w, i_h = v:measure();
    sizes[i] = { w = i_w, h = i_h }
end

local colorful_text = {
    lerp = function(self, from, to, duration)
        if type(from) == 'table' and type(to) == 'table' then
            return { 
                self:lerp(from[1], to[1], duration), 
                self:lerp(from[2], to[2], duration), 
                self:lerp(from[3], to[3], duration) 
            };
        end
    
        return from + (to - from) * duration;
    end,
    console = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local l = self:lerp(v[1], v[2], k / #v[3]);
                    client.color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
                end
            elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
                client.color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
            end
        end
    end,
    text = function(self, ...)
        local menu = false;
        local alpha = 255
        local f = '';
        
        for i, v in ipairs({ ... }) do
            if type(v) == 'boolean' then
                menu = v;
            elseif type(v) == 'number' then
                alpha = v;
            elseif type(v) == 'string' then
                f = f .. v;
            elseif type(v) == 'table' then
                if type(v[1]) == 'table' and type(v[2]) == 'string' then
                    f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
                elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                    for k = 1, #v[3] do
                        local g = self:lerp(v[1], v[2], k / #v[3])
                        f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                    end
                end
            end
        end
    
        return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
    end,
    log = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v) == 'table' then
                if type(v[1]) == 'table' then
                    if type(v[2]) == 'string' then
                        self:console({ v[1], v[1], v[2] })
                        if (v[3]) then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    elseif type(v[2]) == 'table' then
                        self:console({ v[1], v[2], v[3] })
                        if v[4] then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    end
                elseif type(v[1]) == 'string' then
                    self:console({ { 205, 205, 205 }, v[1] });
                    if v[2] then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                end
            end
        end
    end
}

local notify = {
    add = function(self, type, ...)
        table.insert(self.items, {
            ['text'] = table.concat({...}, ''),
            ['time'] = self.time,
            ['type'] = type or 'info',
            ['a'] = 255.0,
        });
    end,
    setup = function(self, data)
        self.max_logs = data.max_logs or 10
        self.position = data.position or { 8, 5 }
        self.time = data.time or 8.0
        self.images = data.images or false
        self.center_screen = data.center_screen or false
        self.center_additive = data.center_additive or 0
        self.simple = data.simple or false
        self.items = self.items or {}
    end,
    think = function(self)
        if #self.items <= 0 then return end
        if #self.items > self.max_logs then
            table.remove(self.items, 1);
        end

        for i, v in ipairs(self.items) do
            v.time = v.time - globals.frametime();
            if v.time <= 0 then
                table.remove(self.items, i);
            end
        end

        local s_w, s_h = client.screen_size();
        local c_w, c_h = s_w * 0.5, s_h * 0.5;

        local x, y, w, h, offset = 0, 0, 0, 0, { 5, 2 }
        local image_offset = 0;
        local text = ''
        local f = 0.0

        if (self.images) then
            offset[2] = 8;
            image_offset = 25;
        end

        if self.simple then
            offset = { 0, 0 }
            image_offset = 0;
        end

        local scale = 0.65

        if self.center_screen then
            x, y = c_w, c_h + 35 + self.center_additive;
            for i = #self.items, 1, -1 do
                local v = self.items[i]

                local text = string.gsub(v.text, '(%x%x%x%x%x%x%x%x)', function(hex) 
                    return ('%s%02x'):format(string.sub(hex, 1, -3), v.a); 
                end):gsub(' ', '  '):upper();
    
                local w, h = renderer.measure_text('cd-', text);
        
                local f = v.time;
                if (f < 0.5) then
                    math.clamp(f, 0.0, 0.5);
    
                    f = f / 0.5;
        
                    v.a = 255.0 * f;
        
                    if (i == 1 and f < 0.3) then
                        y = y + (h * (1.0 - f / 0.3));
                    end
                end
    
                if not self.simple then
                    renderer.rectangle(x - (w * 0.5), y, w + offset[1] * 2 + image_offset, h + offset[2] * 2, 20, 20, 20, v.a);
                    renderer.outline(x - (w * 0.5), y, w + offset[1] * 2 + image_offset, h + offset[2] * 2, 0, 0, 0, v.a);
                    renderer.rectangle(x - (w * 0.5), y + 1, w + offset[1] * 2 + image_offset, 1, 0, 0, 0, v.a);
                    renderer.gradient(x - (w * 0.5), y, math.min(w, w * (v.time / self.time)) + offset[1] * 2 + image_offset, 1, 155, 255, 255, v.a, 255, 155, 255, v.a, true);
                    if self.images then
                        icons[v.type]:draw(x - (w * 0.5) + offset[1], y + offset[2] * 0.5, sizes[v.type].w * scale, sizes[v.type].h * scale, 255, 255, 255, math.abs(math.cos(globals.realtime()))*v.a);
                    end
                end

                local text_pos = { x + offset[1] + image_offset, y + (h * 0.5) +  offset[2] }
                if self.simple then
                    text_pos = { x, y }
                end

                renderer.text(text_pos[1], text_pos[2], 255, 255, 255, v.a, 'cd-', 0, text);

                y = y + h + ((self.simple) and 0 or offset[2] * 2 + 5);
            end
        else
            x, y = self.position[1], self.position[2]
            for i, v in ipairs(self.items) do
                local text = string.gsub(v.text, '(%x%x%x%x%x%x%x%x)', function(hex) 
                    return ('%s%02x'):format(string.sub(hex, 1, -3), v.a); 
                end);
    
                local w, h = renderer.measure_text('d', text);
        
                local f = v.time;
                if (f < 0.5) then
                    math.clamp(f, 0.0, 0.5);
    
                    f = f / 0.5;
        
                    v.a = 255.0 * f;
        
                    if (i == 1 and f < 0.3) then
                        y = y - (h * (1.0 - f / 0.3));
                    end
                end
    
                if not self.simple then
                    renderer.rectangle(x, y + 800, w + offset[1] * 2 + image_offset, h + offset[2] * 2, 20, 20, 20, v.a);
                    renderer.outline(x, y + 800, w + offset[1] * 2 + image_offset, h + offset[2] * 2, 0, 0, 0, v.a);
                    renderer.rectangle(x, y + 800 + 1, w + offset[1] * 2 + image_offset, 1, 0, 0, 0, v.a);
                    renderer.gradient(x, y + 800, math.min(w, w * (v.time / self.time)) + offset[1] * 2 + image_offset, 1, 155, 255, 255, v.a, 255, 155, 255, v.a, true);
                    if self.images then
                        icons[v.type]:draw(x + offset[1], y + offset[2] * 0.5, sizes[v.type].w * scale, sizes[v.type].h * scale, 255, 255, 255, math.abs(math.cos(globals.realtime()))*v.a);
                    end
                end

                local text_pos = { x + offset[1] + image_offset, y + 800 + offset[2] }
                if self.simple then
                    text_pos = { x, y }
                end

                renderer.text(text_pos[1], text_pos[2], 255, 255, 255, v.a, 'd', 0, text);

                y = y + h + ((self.simple) and 0 or offset[2] * 2 + 5);
            end
        end
    end
}

local items = {
    colorful_text:text(true, { { 173, 173, 173 }, { 173, 173, 173 }, "Misses" } ), 
    colorful_text:text(true, { { 173, 173, 173 }, { 173, 173, 173 }, "Hit" } ), 
    colorful_text:text(true, { { 173, 173, 173 }, { 173, 173, 173 }, "Harmed" } ), 
    colorful_text:text(true, { { 173, 173, 173 }, { 173, 173, 173 }, "Buy Logs" } ),
}

local menu = {
    main = ui.new_checkbox("Visuals", "Other ESP", "[" .. colorful_text:text(true, { { 155, 255, 255 }, { 255, 155, 255 }, "Mewtwo" } ) .. "] Hitlogs"),
    entries = {
        options = ui.new_multiselect("Visuals", "Other ESP", "\noptions", items),
        simple_logs = ui.new_checkbox("Visuals", "Other ESP", colorful_text:text(true, { { 173, 173, 173 }, "" } ) .. "Toggle Animation Mode"),
        crosshair_logs = ui.new_checkbox("Visuals", "Other ESP", colorful_text:text(true, { { 173, 173, 173 }, "" } ) .. "Crosshair Logs"),
        crosshair_additive = ui.new_slider("Visuals", "Other ESP", colorful_text:text(true, { { 173, 173, 173 }, "" } ) .. "Crosshair Log Position", 0, 400, 200),
    }
}

local ref = {
    log_weapon_purchases = ui.reference('MISC', 'Miscellaneous', 'Log weapon purchases'),
    log_damage_dealt = ui.reference('MISC', 'Miscellaneous', 'Log damage dealt'),
    log_misses_due_to_spread = ui.reference('RAGE', 'Other', 'Log misses due to spread'),
    hitchance = ui.reference('RAGE', 'Aimbot', 'Minimum hit chance'),
    min_dmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
    legit_enabled = ui.reference('LEGIT', 'Aimbot', 'Enabled'),
    values = {
        log_weapon_purchases = false,
        log_damage_dealt = false,
        log_misses_due_to_spread = false,
    }
}

local vars = {
    local_player = 0,
    hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
}

local on_paint_ui = function()
    notify:think();
end

local on_aim_miss = function(data)
    if not contains(ui.get(menu.entries.options), items[1]) then return end

    if data.reason == "death" then
        if entity.is_alive(vars.local_player) then
            data.reason = "player death"
        else
            data.reason = "local death"
        end
    end

    if data.reason == "prediction error" then
        data.reason = "prediction"
    end

    if data.reason == "?" then
        data.reason = "resolver"
    end

    local ping = math.min(999, client.real_latency() * 1000)
    local ping_col = (ping >= 100) and { 255, 0, 0 } or { 150, 200, 60 }

    local hc = math.floor(data.hit_chance + 0.5);
    local hc_col = (hc < ui.get(ref.hitchance)) and { 255, 0, 0 } or { 150, 200, 60 };

    colorful_text:log(
        { { 155, 255, 255 }, { 255, 155, 255 }, "[Mewtwo] " },
        { { 205, 205, 205 }, ("Missed %s's %s due to "):format(entity.get_player_name(data.target), vars.hitgroup_names[data.hitgroup + 1] or '?') },
        { { 255, 0, 0 }, ("%s"):format((data.reason == '?' and 'resolver' or data.reason)) },
        { { 205, 205, 205 }, ". [ BT: "},
        { ping_col, ("%dms"):format(ping) },
        { { 205, 205, 205 }, " | Ang: " },
        { { 155, 255, 255 }, ("%d"):format(math.floor( entity.get_prop(data.target, 'm_flPoseParameter', 11 ) * 120 - 60 )) },
        { { 205, 205, 205 }, " | HC: "},
        { hc_col, ("%d%%"):format(hc) },
        { { 205, 205, 205 }, " ]", true }
    );

    notify:add(
        "miss",
        colorful_text:text({ { 255, 255, 255 }, ("Missed %s's %s due to "):format(entity.get_player_name(data.target), vars.hitgroup_names[data.hitgroup + 1] or '?') }),
        colorful_text:text({ { 255, 0, 0 }, ("%s"):format((data.reason == '?' and 'resolver' or data.reason))}),
        colorful_text:text({ { 255, 255, 255 }, ". [ BT: "}),
        colorful_text:text({ ping_col, ("%dms"):format(ping) }),
        colorful_text:text({ { 255, 255, 255 }, " | Ang: " }),
        colorful_text:text({ { 155, 255, 255 }, ("%d"):format(math.floor( entity.get_prop(data.target, 'm_flPoseParameter', 11 ) * 120 - 60 )) }),
        colorful_text:text({ { 255, 255, 255 }, " | HC: "}),
        colorful_text:text({ hc_col, ("%d%%"):format(hc) }),
        colorful_text:text({ { 255, 255, 255 }, " ]" })
    );
end

local on_item_purchase = function(event)
    if not contains(ui.get(menu.entries.options), items[4]) then return end

    local userid = event.userid
    if userid == nil then return end

    if event.team == entity.get_prop(vars.local_player, 'm_iTeamNum') then return end

    local buyer = client.userid_to_entindex(userid)
    if buyer == nil then return end

    if event.weapon == "weapon_unknown" then return end

    local item = event.weapon;
    item = item:gsub('weapon_', '')

    if item == 'item_assaultsuit' then
        item = 'kevlar + helmet'
    elseif item == 'item_kevlar' then
        item = 'kevlar'
    elseif item == 'item_defuser' then
        item = 'defuser'
    else
        item = item:gsub('grenade', ' grenade');
    end

    colorful_text:log(
        { { 155, 255, 255 }, { 255, 155, 255 }, "[Mewtwo] " },
        { { 205, 205, 205 }, ("%s purchased "):format(entity.get_player_name(buyer)) },
        { { 255, 0, 0 }, ("%s"):format(item) },
        { { 205, 205, 205 }, ".", true }
    )

    notify:add(
        "buy",
        colorful_text:text({ { 255, 255, 255 }, ("%s purchased "):format(entity.get_player_name(duder))}),
        colorful_text:text({ { 255, 0, 0 }, ("%s"):format(item) }),
        colorful_text:text({ { 255, 255, 255 }, "." })
    );
end

local on_player_hurt = function(event)
    local victim_idx, attacker_idx = event.userid, event.attacker
	if victim_idx == nil or attacker_idx == nil then
		return
	end

    local dmg_color = (ui.get(ref.min_dmg) <= event.dmg_health and not ui.get(ref.legit_enabled)) and { 150, 200, 60 } or { 255, 0, 0 }
    local baimable = (ui.get(ref.min_dmg) <= event.health and not ui.get(ref.legit_enabled)) and { 150, 200, 60 } or { 255, 0, 0 }

    local victim, attacker = client.userid_to_entindex(victim_idx), client.userid_to_entindex(attacker_idx)
    if attacker ~= vars.local_player or victim == vars.local_player then 
        if (victim == vars.local_player and attacker ~= vars.local_player) then
            if contains(ui.get(menu.entries.options), items[3]) then
                local attacker_name = entity.get_player_name(attacker)
                if attacker_name == 'unknown' then return end

                colorful_text:log(
                    { { 155, 255, 255 }, { 255, 155, 255 }, "[Mewtwo] " },
                    { { 205, 205, 205 }, ("Harmed by %s in the %s for "):format(attacker_name, vars.hitgroup_names[event.hitgroup + 1] or '?') },
                    { { 160, 200, 50 }, ("%s"):format(event.dmg_health) },
                    { { 205, 205, 205 }, ".", true}
                );

                notify:add(
                    "error",
                    colorful_text:text({ { 255, 255, 255 }, ("Harmed by %s in the %s for "):format(attacker_name, vars.hitgroup_names[event.hitgroup + 1] or '?') }),
                    colorful_text:text({ { 160, 200, 50 }, ("%s"):format(event.dmg_health) }),
                    colorful_text:text({ { 255, 255, 255 }, "." })
                );
            end
        end
        return
    end

    if contains(ui.get(menu.entries.options), items[2]) then 
        colorful_text:log(
            { { 155, 255, 255 }, { 255, 155, 255 }, "[Mewtwo] " },
            { { 205, 205, 205 }, ("Hit %s's %s for "):format(entity.get_player_name(victim), vars.hitgroup_names[event.hitgroup + 1] or '?') },
            { dmg_color, ("%s"):format(event.dmg_health) },
            { { 205, 205, 205 }, ". ( " },
            { baimable, ("%s"):format(event.health) },
            { { 205, 205, 205 }, " health remaining )", true }
        );

        notify:add(
            "Hit",
            colorful_text:text({ { 255, 255, 255 }, ("Hit %s's %s for "):format(entity.get_player_name(victim), vars.hitgroup_names[event.hitgroup + 1] or '?') }),
            colorful_text:text({ dmg_color, ("%s"):format(event.dmg_health) }),
            colorful_text:text({ { 255, 255, 255 }, ". ( " }),
            colorful_text:text({ baimable, ("%s"):format(event.health) }),
            colorful_text:text({ { 255, 255, 255 }, " health remaining )" })
        );
    end
end

local on_setup_command = function(cmd)
    vars.local_player = entity.get_local_player();
end 

local on_load = function(state)
    local func = (state) and client.set_event_callback or client.unset_event_callback

    set_table(ui.set_visible, { ref.log_weapon_purchases, ref.log_damage_dealt, ref.log_misses_due_to_spread }, not state);
    if not state then
        ui.set(ref.log_weapon_purchases, ref.values.log_weapon_purchases);
        ui.set(ref.log_damage_dealt, ref.values.log_damage_dealt);
        ui.set(ref.log_misses_due_to_spread, ref.values.log_misses_due_to_spread);
    else
        set_table(ui.set, { ref.log_weapon_purchases, ref.log_damage_dealt, ref.log_misses_due_to_spread }, false);
    end

    set_table(ui.set_visible, { menu.entries }, state);
    ui.set_visible(menu.entries.crosshair_additive, ui.get(menu.entries.crosshair_logs) and state)

    func("paint_ui", on_paint_ui);
    func("item_purchase", on_item_purchase);
    func("player_hurt", on_player_hurt);
    func("setup_command", on_setup_command);
    func("aim_miss", on_aim_miss);

    notify:setup({ center_screen = ui.get(menu.entries.crosshair_logs), simple = ui.get(menu.entries.simple_logs), center_additive = ui.get(menu.entries.crosshair_additive) });
end

ui.set_callback(menu.main, function()
    local state = ui.get(menu.main);
    on_load(state)
end)

ui.set_callback(menu.entries.crosshair_logs, function()
    local state = ui.get(menu.entries.crosshair_logs)

    set_table(ui.set_visible, { menu.entries.crosshair_additive }, state);

    notify:setup({ center_screen = state, simple = ui.get(menu.entries.simple_logs), center_additive = ui.get(menu.entries.crosshair_additive) });
end)

ui.set_callback(menu.entries.simple_logs, function()
    local state = ui.get(menu.entries.simple_logs)
    notify:setup({ center_screen = ui.get(menu.entries.crosshair_logs), simple = state, center_additive = ui.get(menu.entries.crosshair_additive) });
end)

ui.set_callback(menu.entries.crosshair_additive, function()
    local value = ui.get(menu.entries.crosshair_additive);


    notify:setup({ center_screen = ui.get(menu.entries.crosshair_logs), simple = ui.get(menu.entries.simple_logs), center_additive = value });
end)

ref.values.log_weapon_purchases = ui.get(ref.log_weapon_purchases);
ref.values.log_damage_dealt = ui.get(ref.log_damage_dealt);
ref.values.log_misses_due_to_spread = ui.get(ref.log_misses_due_to_spread);

on_load(false);
local spacermacer = ui.new_label("Visuals", "Other ESP", " ")
local visual_label = ui.new_label("Visuals","Other ESP", "                \ad6b6f7ff+ Mewtwo Essentials + ")

print(name, " has been loaded!")
end
scripts["Weapon Adaptive"] = function(name, check)
scripts[name] = loader
if check ~= secret and not reached then return end
print("Loading: ", name)
-- Mewtwo Adaptive
local vector = require 'vector'

local ffi = require('ffi')
local ffi_cast = ffi.cast

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local dependencies = {
    ["gamesense/csgo_weapons"] = "https://gamesense.pub/forums/viewtopic.php?id=18807",
}

local missing_libs = { }

for i, v in pairs(dependencies) do
    if not pcall(require, i) then
        missing_libs[#missing_libs + 1] = dependencies[i]
    end
end

for i=1, #missing_libs do
    error("Miss the lib: \n" .. table_concat(missing_libs, ", \n"))
end

local csgo_weapons = require "gamesense/csgo_weapons"

local includes = function (table,key)
    for i=1, #table do
      if table[i] == key then
        return true;
      end; 
    end;
    return false;
end

local function vtable_thunk(index, typedef)
    return function(v0, ...)
        local instance = ffi.cast(ffi.typeof('void***'), v0)

        local tdef = nil

        if seen[typedef] then
            tdef = seen[typedef]
        else
            tdef = ffi.typeof(typedef)

            seen[typedef] = tdef
        end

        return ffi.cast(tdef, instance[0][index])(instance, ...)
    end
end

local function vtable_bind(interface, index, typedef)
    local instance = ffi.cast('void***', interface);

    return function(...)
        return ffi.cast(typedef, instance[0][index])(instance, ...)
    end
end

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast(ffi.typeof('void***'), VGUI_System010 )

local IEngineClient__GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)")
local INetChannelInfo__GetAvgLoss = vtable_thunk(11, "float (__thiscall*)(void* ecx, int flow)")
local INetChannelInfo__GetAvgChoke = vtable_thunk(12, "float (__thiscall*)(void* ecx, int flow)")

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

local function arr_to_string(arr)
	arr = ui.get(arr)
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
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
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

local version = '[VIP]'
local label = ui.new_label("RAGE", "Aimbot", " ")
local label = ui.new_label("RAGE", "Aimbot", "                     \abbc4fbffMe\abbc4fbffwt\ac9bdf9ffwo\ad6b6f7ff.T\ae4aff5ffec\ae4aff5ffh")
local label2 = ui.new_label("RAGE", "Aimbot", "                   \abbc4fbffWea\abbc4fbffpon \ac9bdf9ffAd\ad6b6f7ffap\ae4aff5ffti\ae4aff5ffve")
local label3 = ui.new_label("RAGE", "Aimbot", "                    \abbc4fbffVersion: \ae4aff5ff[VIP]")
local label = ui.new_label("RAGE", "Aimbot", " ")

local weapon_name = { "Global", "Taser", "Revolver", "Pistol", "Auto", "Scout", "AWP", "Rifle", "SMG", "Shotgun", "Deagle" }
local name_to_num = { ["Global"] = 1, ["Taser"] = 2, ["Revolver"] = 3, ["Pistol"] = 4, ["Auto"] = 5, ["Scout"] = 6, ["AWP"] = 7, ["Rifle"] = 8, ["SMG"] = 9, ["Shotgun"] = 10, ["Deagle"] = 11 }
local weapon_idx_list = { [1] = 11, [2] = 4,[3] = 4,[4] = 4,[7] = 8,[8] = 8,[9] = 7,[10] = 8,[11] = 5,[13] = 8,[14] = 8,[16] = 8,[17] = 9,[19] = 9,[23] = 9,[24] = 9,[25] = 10,[26] = 9,[27] = 10,[28] = 8,[29] = 10,[30] = 4,[31] = 2,  [32] = 4,[33] = 9,[34] = 9,[35] = 10,[36] = 4,[38] = 5,[39] = 8,[40] = 6,[60] = 8,[61] = 4,[63] = 4,[64] = 3}
local damage_idx  = { [0] = "Auto", [101] = "HP + 1", [102] = "HP + 2", [103] = "HP + 3", [104] = "HP + 4", [105] = "HP + 5", [106] = "HP + 6", [107] = "HP + 7", [108] = "HP + 8", [109] = "HP + 9", [110] = "HP + 10", [111] = "HP + 11", [112] = "HP + 12", [113] = "HP + 13", [114] = "HP + 14", [115] = "HP + 15", [116] = "HP + 16", [117] = "HP + 17", [118] = "HP + 18", [119] = "HP + 19", [120] = "HP + 20", [121] = "HP + 21", [122] = "HP + 22", [123] = "HP + 23", [124] = "HP + 24", [125] = "HP + 25", [126] = "HP + 26" }
local scoped_wpn_idx = {
    name_to_num["Scout"],
    name_to_num["Auto"],
    name_to_num["AWP"],
}
local screen_size_x,screen_size_y = client.screen_size()
local weapon = {
    main_switch = ui.new_checkbox("Rage", "Aimbot", "\a12EC0997Enable Mewtwo Weapon Adaptive"), 
    adjust = ui.new_checkbox("Rage", "Aimbot", "Adjust weapon selection if menu not opened"),
    run_hide = ui.new_checkbox("Rage", "Aimbot", "Hide skeet rage menu"),
    allow_fake_ping = ui.new_checkbox("Rage", "Aimbot", "Allow ping-spike adjustment in lua"),
    fake_ping_key = ui.new_hotkey("Rage", "Aimbot", "Ping spike"),
    lua_label = ui.new_combobox("Rage", "Aimbot","\aB0C4DEFFMin DMG Indicator:",{'Screen center','Skeet indicator'}),
    lua_clr = ui.new_color_picker("Rage", "Aimbot", "\aB0C4DEFFMin DMG Indicator", 100,149,237, 255),
    high_pro = ui.new_multiselect("Rage", "Aimbot","High priority target:",{'Bomb carrier','AWP user'}),
    key_text = ui.new_label("Rage", "Aimbot","\aFFE7BAFFOverride keys:"),
    available = ui.new_multiselect("Rage", "Aimbot","Select Keys:",{'Min DMG','Hit chance','Hitbox','Multipoint','Unsafe hitbox','Quick stop','Delay shot'}),
    ovr_dmg = ui.new_hotkey("Rage", "Aimbot", "Min damage [1]"),
    ovr_dmg_2 = ui.new_hotkey("Rage", "Aimbot", "Min damage [2]"),
    ovr_hc = ui.new_hotkey("Rage", "Aimbot", "Hitchance [1]"),
    ovr_hc_2 = ui.new_hotkey("Rage", "Aimbot", "Hitchance [2]"),
    ovr_box = ui.new_hotkey("Rage", "Aimbot", "Hitbox [1]"),
    ovr_box_2 = ui.new_hotkey("Rage", "Aimbot", "Hitbox [2]"),
    ovr_multi = ui.new_hotkey("Rage", "Aimbot", "Multi-point"),
    ovr_unsafe = ui.new_hotkey("Rage", "Aimbot", "Unsafe hitbox"),
    ovr_stop = ui.new_hotkey("Rage", "Aimbot", "Quick stop"),
    ovr_forcehead = ui.new_hotkey("Rage", "Aimbot", "Force head"),
    ovr_delay = ui.new_hotkey("Rage", "Aimbot", "Delay shot"),
    ovr_dmg_smart = ui.new_hotkey("Rage", "Aimbot", "Smart penetration dmg"),
    key_text_1 = ui.new_label("Rage", "Aimbot","\aFFE7BAFFWeapon config:"),
    weapon_select = ui.new_combobox("Rage", "Aimbot", "Weapon:", weapon_name),
}

weapon.cfg = {}

for i,o in ipairs(weapon_name) do 
    weapon.cfg[i] = {
        enable = ui.new_checkbox("Rage", "Aimbot", "Enable "..o.." config"),
        extra_feature = ui.new_multiselect("Rage", "Aimbot","["..o.."] Available extra tweak",{'Hitbox','Multi-Point','Unsafe hitbox','Hitchance','Damage','Quick stop'}),
        target_selection = ui.new_combobox("Rage", "Aimbot", "[" .. o .. "] Target selection", {"Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"}),
        hitbox_text = ui.new_label("Rage", "Aimbot","                 ------ Hitbox ------"),
        hitbox_mode = ui.new_multiselect("Rage", "Aimbot","["..o.."] Extra hitbox tweak",{'Double-tap','In-air','Override 1','Override 2'}), 
        target_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target hitbox", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_target_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target hitbox \a87CEEBFF[Double-tap]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        air_target_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target hitbox \a87CEEBFF[In-air]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        ovr_target_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target hitbox \a87CEEBFF[Override 1]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        ovr_target_hitbox_2 = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target hitbox \a87CEEBFF[Override 2]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multi_text = ui.new_label("Rage", "Aimbot","              ------ Multi-point ------"),
        multi_mode = ui.new_multiselect("Rage", "Aimbot","["..o.."] Extra multi-point tweak",{'Ping-spike','Double-tap','In-air','Override'}),
        multi_complex = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Target multi-point complexity",0,1,0,true,'',1, {[0] = 'Original',[1] = 'Visible/Autowall'}),
        target_multi = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multipoint_scale = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        multi_hitbox_v = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \aF08080FF[Visible]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multipoint_scale_v = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \aF08080FF[Visible]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        multi_hitbox_a = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \aF08080FF[Autowall]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        multipoint_scale_a = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \aF08080FF[Autowall]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        ping_avilble = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Therehold value \a87CEEBFF[Ping-spike]", 0, 200, 100, true),
        ping_multi_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \a87CEEBFF[Ping-spike]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        ping_multipoint_scale = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \a87CEEBFF[Ping-spike]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        dt_multi_complex = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Target multi-point complexity \a87CEEBFF[Double-tap]",0,1,0,true,'',1, {[0] = 'Original',[1] = 'Visible/Autowall'}),
        dt_multi_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \a87CEEBFF[Double-tap]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_multipoint_scale = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \a87CEEBFF[Double-tap]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        dt_multi_hitbox_v = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \aF08080FF[Visible] \a87CEEBFF[Double-tap]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_multipoint_scale_v = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \aF08080FF[Visible] \a87CEEBFF[Double-tap]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        dt_multi_hitbox_a = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \aF08080FF[Autowall] \a87CEEBFF[Double-tap]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_multipoint_scale_a = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \aF08080FF[Autowall] \a87CEEBFF[Double-tap]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        air_multi_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \a87CEEBFF[In-air]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        air_multipoint_scale = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \a87CEEBFF[In-air]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        ovr_multi_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Target multi-point \a87CEEBFF[Override]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        ovr_multipoint_scale = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Multi-point scale \a87CEEBFF[Override]", 24, 100, 60, true, "%", 1, { [24] = "Auto" }),
        unsafe_text = ui.new_label("Rage", "Aimbot","           ------ Unsafe Hitbox ------"),
        unsafe_mode = ui.new_multiselect("Rage", "Aimbot","["..o.."] Extra unsafe hitbox tweak",{'Double-tap','In-air','Override'}),
        unsafe_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Unsafe hitbox", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        dt_unsafe_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Unsafe hitbox \a87CEEBFF[Double-tap]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        air_unsafe_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Unsafe hitbox \a87CEEBFF[In-air]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        ovr_unsafe_hitbox = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Unsafe hitbox \a87CEEBFF[Override]", { "Head", "Chest", "Arms", "Stomach", "Legs", "Feet" }),
        general_text = ui.new_label("Rage", "Aimbot","                ------ General ------"),
        safepoint = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Prefer safepoint", { 'In-air','Double-tap','Always on' }),
        automatic_fire = ui.new_checkbox("Rage", "Aimbot", "[" .. o .. "] Automatic fire"),
        automatic_penetration = ui.new_checkbox("Rage", "Aimbot", "[" .. o .. "] Automatic penetration"),
        automatic_scope_e = ui.new_checkbox("Rage", "Aimbot", "[" .. o .. "] Automatic scope"),
        automatic_scope = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Automatic scope disabler",{'In distance','On doubletap'}),
        autoscope_therehold = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Therehold for distance", 0, 3000, 500, true, "f", 1),
        silent_aim = ui.new_checkbox("Rage", "Aimbot", "[" .. o .. "] Silent aim"),
        max = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Maximum FOV", 1, 180, 180, true, "°", 1),
        fps_boost = ui.new_multiselect("Rage", "Aimbot", "[" .. o .. "] Low FPS mitigations",{'Force low accuracy boost','Disable multipoint: feet','Disable multipoint: arms','Disable multipoint: legs','Disable hitbox: feet','Lower hit chance precision','Limit targets per tick'}),
        hitchance_text = ui.new_label("Rage", "Aimbot","               ------ Hitchance ------"),
        hitchance_mode = ui.new_multiselect("Rage", "Aimbot","["..o.."] Extra hitchance tweak",{'Double-tap','On-shot','Fake duck','In-air','Unscoped','Crouching','Override 1','Override 2'}),
        hitchance = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance ", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_ovr = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Override 1]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_ovr_2 = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Override 2]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_air = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[In-air]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_os = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[On-shot]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_fd = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Fake-duck]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_usc = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Unscoped]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_dt = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Double-tap]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),
        hitchance_cro = ui.new_slider("Rage", "Aimbot", "[" .. o .. "] Hitchance \a87CEEBFF[Crouching]", 0, 100, 60, true, "%", 1, { [0] = "Off" }),  
        damage_text = ui.new_label("Rage", "Other","                 ------ Damage ------"),
        damage_mode = ui.new_multiselect("Rage", "Other","["..o.."] Extra Damage tweak",{'Double-tap','On-shot','Fake duck','In-air','Unscoped','Override 1','Override 2'}),
        damage_complex = ui.new_combobox("Rage", "Other", "[" .. o .. "] Damage complexity",{'Original','Visible/autowall'}), 
        damage = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage ", 0, 126, 60, true,nil,1,damage_idx),
        damage_cro = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \aF08080FF[Visible]", 0, 126, 60, true,nil,1,damage_idx),
        damage_aut = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \aF08080FF[Autowall]", 0, 126, 60, true,nil,1,damage_idx),
        damage_ovr = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[Override 1]", 0, 126, 60, true,nil,1,damage_idx),
        damage_ovr_2 = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[Override 2]", 0, 126, 60, true,nil,1,damage_idx),
        damage_air = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[In-air]", 0, 126, 60, true,nil,1,damage_idx),
        damage_os = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[On-shot]", 0, 126, 60, true,nil,1,damage_idx),
        damage_fd = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[Fake-duck]", 0, 126, 60, true,nil,1,damage_idx),
        damage_usc = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[Unscoped]", 0, 126, 60, true,nil,1,damage_idx),   
        damage_complex_dt = ui.new_combobox("Rage", "Other", "[" .. o .. "] Damage complexity \a87CEEBFF[Double-tap]",{'Original','Visible/autowall'}), 
        damage_dt = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \a87CEEBFF[Double-tap]", 0, 126, 60, true,nil,1,damage_idx),
        damage_cro_dt = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \aF08080FF[Visible] \a87CEEBFF[Double-tap]", 0, 126, 60, true,nil,1,damage_idx),
        damage_aut_dt = ui.new_slider("Rage", "Other", "[" .. o .. "] Damage \aF08080FF[Autowall] \a87CEEBFF[Double-tap]", 0, 126, 60, true,nil,1,damage_idx),
        c = ui.new_label("Rage", "Other","\n"),
        accuarcy_boost = ui.new_combobox("Rage", "Other", "[" .. o .. "] Accuracy boost",{'Low','Medium','High','Maximum'}),
        delay_shot = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Delay shot",{'On key','Always on'}),
        stop_text = ui.new_label("Rage", "Other","               ------ Quick stop ------"),
        stop_mode = ui.new_multiselect("Rage", "Other","["..o.."] Extra Quick stop tweak",{'Double-tap','Unscoped','Override'}),
        stop = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Quick stop"),
        stop_option = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Quick stop options", {'Early','Slow motion','Duck','Fake duck','Move between shots','Ignore molotov','Taser', 'Jump scout'}),
        stop_dt = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Quick stop \a87CEEBFF[Double-tap]"),
        stop_option_dt = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Quick stop options \a87CEEBFF[Double-tap]", {'Early','Slow motion','Duck','Fake duck','Move between shots','Ignore molotov','Taser', 'Jump scout'}),
        stop_unscoped = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Quick stop \a87CEEBFF[Unscoped]"),
        stop_option_unscoped = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Quick stop options \a87CEEBFF[Unscoped]", {'Early','Slow motion','Duck','Fake duck','Move between shots','Ignore molotov','Taser', 'Jump scout'}),
        stop_ovr = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Quick stop \a87CEEBFF[Override]"),
        stop_option_ovr = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Quick stop options \a87CEEBFF[Override]", {'Early','Slow motion','Duck','Fake duck','Move between shots','Ignore molotov','Taser', 'Jump scout'}),
        ext_text = ui.new_label("Rage", "Other","                  ------ Extra ------"),
        fp = ui.new_combobox("Rage", "Other", "[" .. o .. "] Use ping-spike",{'On key','Always on'}),
        preferbm = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Prefer body aim"),
        lethal = ui.new_checkbox("Rage", "Other", "[" .. o .. "] Prefer lethal baim"),
        prefer_baim_disablers = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Prefer body aim disablers", {"Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot",'High pitch','Side way'}),
        dt = ui.new_multiselect("Rage", "Other",'['..o..'] Available doubletap option',{'Doubletap mode','Doubletap hitchance','Doubletap quick stop','Doubletap fakelag'}),
        doubletap_mode =  ui.new_combobox("Rage", "Other", "[" .. o .. "] Double tap mode",{'Offensive','Defensive'}),
        doubletap_hc = ui.new_slider("Rage", "Other", "[" .. o .. "] Double tap hit chance", 0, 100, 0, true, "%", 1),
        doubletap_fl = ui.new_slider("Rage", "Other", "[" .. o .. "] Double tap fake lag limit", 1, 10, 1),
        doubletap_stop = ui.new_multiselect("Rage", "Other", "[" .. o .. "] Double tap quick stop", { "Slow motion", "Duck", "Move between shots" }),
    }
end

local function export_cfg()
	local str = ""

    for i,o in ipairs(weapon_name) do 
		str = str .. tostring(ui.get(weapon.cfg[i].enable)) .. "|"
		.. arr_to_string((weapon.cfg[i].extra_feature)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].target_selection)) .. "|"
		.. arr_to_string((weapon.cfg[i].hitbox_mode)) .. "|"
		.. arr_to_string((weapon.cfg[i].target_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].dt_target_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].air_target_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].ovr_target_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].ovr_target_hitbox_2)) .. "|"
		.. arr_to_string((weapon.cfg[i].multi_mode)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].multi_complex)) .. "|"
		.. arr_to_string((weapon.cfg[i].target_multi)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].multipoint_scale)) .. "|"
		.. arr_to_string((weapon.cfg[i].multi_hitbox_v)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].multipoint_scale_v)) .. "|"
		.. arr_to_string((weapon.cfg[i].multi_hitbox_a)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].multipoint_scale_a)) .. "|"

        .. tostring(ui.get(weapon.cfg[i].ping_avilble)) .. "|"
		.. arr_to_string((weapon.cfg[i].ping_multi_hitbox)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].ping_multipoint_scale)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].dt_multi_complex)) .. "|"
		.. arr_to_string((weapon.cfg[i].dt_multi_hitbox)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].dt_multipoint_scale)) .. "|"
		.. arr_to_string((weapon.cfg[i].dt_multi_hitbox_v)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].dt_multipoint_scale_v)) .. "|"
		.. arr_to_string((weapon.cfg[i].dt_multi_hitbox_a)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].dt_multipoint_scale_a)) .. "|"
		.. arr_to_string((weapon.cfg[i].air_multi_hitbox)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].air_multipoint_scale)) .. "|"
		.. arr_to_string((weapon.cfg[i].ovr_multi_hitbox)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].ovr_multipoint_scale)) .. "|"
		.. arr_to_string((weapon.cfg[i].unsafe_mode)) .. "|"
		.. arr_to_string((weapon.cfg[i].unsafe_hitbox)) .. "|"

        .. arr_to_string((weapon.cfg[i].dt_unsafe_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].ovr_unsafe_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].air_unsafe_hitbox)) .. "|"
		.. arr_to_string((weapon.cfg[i].safepoint)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].automatic_fire)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].automatic_penetration)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].automatic_scope_e)) .. "|"
		.. arr_to_string((weapon.cfg[i].automatic_scope)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].autoscope_therehold)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].silent_aim)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].max)) .. "|"
		.. arr_to_string((weapon.cfg[i].fps_boost)) .. "|"
		.. arr_to_string((weapon.cfg[i].hitchance_mode)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_ovr)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_ovr_2)) .. "|"

        .. tostring(ui.get(weapon.cfg[i].hitchance_air)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_os)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_fd)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_usc)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].hitchance_cro)) .. "|"
		.. arr_to_string((weapon.cfg[i].damage_mode)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].damage_complex)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_cro)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].damage_aut)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_ovr)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_ovr_2)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_air)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_os)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_fd)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_usc)) .. "|"

        .. tostring(ui.get(weapon.cfg[i].damage_complex_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_cro_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].damage_aut_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].accuarcy_boost)) .. "|"
		.. arr_to_string((weapon.cfg[i].delay_shot)) .. "|"
		.. arr_to_string((weapon.cfg[i].stop_mode)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].stop)) .. "|"
		.. arr_to_string((weapon.cfg[i].stop_option)) .. "|"
        .. tostring(ui.get(weapon.cfg[i].stop_dt)) .. "|"
		.. arr_to_string((weapon.cfg[i].stop_option_dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].stop_unscoped)) .. "|"
		.. arr_to_string((weapon.cfg[i].stop_option_unscoped)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].stop_ovr)) .. "|"
		.. arr_to_string((weapon.cfg[i].stop_option_ovr)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].fp)) .. "|"

        .. tostring(ui.get(weapon.cfg[i].preferbm)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].lethal)) .. "|"
		.. arr_to_string((weapon.cfg[i].prefer_baim_disablers)) .. "|"
		.. arr_to_string((weapon.cfg[i].dt)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].doubletap_mode)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].doubletap_hc)) .. "|"
		.. tostring(ui.get(weapon.cfg[i].doubletap_fl)) .. "|"
		.. arr_to_string((weapon.cfg[i].doubletap_stop)) .. "|"
	end

	clipboard_export(str)
end

local function load_cfg()
	local tbl = str_to_sub(clipboard_import(), "|")

    for i,o in ipairs(weapon_name) do 
		ui.set(weapon.cfg[i].enable, to_boolean(tbl[1 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].extra_feature, str_to_sub(tbl[2 + (90 * (i - 1))],","))
        ui.set(weapon.cfg[i].target_selection, tbl[3 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].hitbox_mode, str_to_sub(tbl[4 + (90 * (i - 1))], ","))
        ui.set(weapon.cfg[i].target_hitbox, str_to_sub(tbl[5 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].dt_target_hitbox, str_to_sub(tbl[6 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].air_target_hitbox, str_to_sub(tbl[7 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].ovr_target_hitbox, str_to_sub(tbl[8 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].ovr_target_hitbox_2, str_to_sub(tbl[9 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].multi_mode, str_to_sub(tbl[10 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].multi_complex, tbl[11 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].target_multi, str_to_sub(tbl[12 + (90 * (i - 1))], ","))	
		ui.set(weapon.cfg[i].multipoint_scale, tbl[13 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].multi_hitbox_v, str_to_sub(tbl[14 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].multipoint_scale_v, tbl[15 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].multi_hitbox_a, str_to_sub(tbl[16 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].multipoint_scale_a, tbl[17 + (90 * (i - 1))])

		ui.set(weapon.cfg[i].ping_avilble, (tbl[18 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].ping_multi_hitbox, str_to_sub(tbl[19 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].ping_multipoint_scale, (tbl[20 + (90 * (i - 1))]))	
		ui.set(weapon.cfg[i].dt_multi_complex, tbl[21 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].dt_multi_hitbox, str_to_sub(tbl[22 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].dt_multipoint_scale, tbl[23 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].dt_multi_hitbox_v, str_to_sub(tbl[24 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].dt_multipoint_scale_v, tbl[25 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].dt_multi_hitbox_a, str_to_sub(tbl[26 + (90 * (i - 1))], ","))
        ui.set(weapon.cfg[i].dt_multipoint_scale_a, (tbl[27 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].air_multi_hitbox, str_to_sub(tbl[28 + (90 * (i - 1))], ","))	
		ui.set(weapon.cfg[i].air_multipoint_scale, tbl[29 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].ovr_multi_hitbox, str_to_sub(tbl[30 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].ovr_multipoint_scale, tbl[31 + (90 * (i - 1))])
		ui.set(weapon.cfg[i].unsafe_mode, str_to_sub(tbl[32 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].unsafe_hitbox, str_to_sub(tbl[33 + (90 * (i - 1))], ","))

		ui.set(weapon.cfg[i].dt_unsafe_hitbox, str_to_sub(tbl[34 + (90 * (i - 1))], ","))
        ui.set(weapon.cfg[i].air_unsafe_hitbox, str_to_sub(tbl[35 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].ovr_unsafe_hitbox, str_to_sub(tbl[36 + (90 * (i - 1))], ","))	
		ui.set(weapon.cfg[i].safepoint, to_boolean(tbl[37 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].automatic_fire, to_boolean(tbl[38 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].automatic_penetration, to_boolean(tbl[39 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].automatic_scope_e, to_boolean(tbl[40 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].automatic_scope, str_to_sub(tbl[41 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].autoscope_therehold, (tbl[42 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].silent_aim, to_boolean(tbl[43 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].max, (tbl[44 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].fps_boost, str_to_sub(tbl[45 + (90 * (i - 1))], ","))
        ui.set(weapon.cfg[i].hitchance_mode, str_to_sub(tbl[46 + (90 * (i - 1))], ","))	
		ui.set(weapon.cfg[i].hitchance, (tbl[47 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].hitchance_ovr, (tbl[48 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].hitchance_ovr_2, (tbl[49 + (90 * (i - 1))]))

		ui.set(weapon.cfg[i].hitchance_air, (tbl[50 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].hitchance_os, (tbl[51 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].hitchance_fd, (tbl[52 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].hitchance_usc, (tbl[53 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].hitchance_dt, (tbl[54 + (90 * (i - 1))]))	
		ui.set(weapon.cfg[i].hitchance_cro, (tbl[55 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_mode, str_to_sub(tbl[56 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].damage_complex, (tbl[57 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage, (tbl[58 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_cro, (tbl[59 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_aut, (tbl[60 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].damage_ovr, (tbl[61 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_ovr_2, (tbl[62 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_air, (tbl[63 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].damage_os, (tbl[64 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_fd, (tbl[65 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_usc, (tbl[66 + (90 * (i - 1))]))

        ui.set(weapon.cfg[i].damage_complex_dt, (tbl[67 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_dt, (tbl[68 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].damage_cro_dt, (tbl[69 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].damage_aut_dt, (tbl[70 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].accuarcy_boost, (tbl[71 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].delay_shot, str_to_sub(tbl[72 + (90 * (i - 1))], ","))	
		ui.set(weapon.cfg[i].stop_mode, str_to_sub(tbl[73 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].stop, to_boolean(tbl[74 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].stop_option, str_to_sub(tbl[75 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].stop_dt, to_boolean(tbl[76 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].stop_option_dt, str_to_sub(tbl[77 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].stop_unscoped, to_boolean(tbl[78 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].stop_option_unscoped, str_to_sub(tbl[79 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].stop_ovr, to_boolean(tbl[80 + (90 * (i - 1))]))	
		ui.set(weapon.cfg[i].stop_option_ovr, str_to_sub(tbl[81 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].fp, (tbl[82 + (90 * (i - 1))]))

		ui.set(weapon.cfg[i].preferbm, to_boolean(tbl[83 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].lethal, to_boolean(tbl[84 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].prefer_baim_disablers, str_to_sub(tbl[85 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].dt, str_to_sub(tbl[86 + (90 * (i - 1))], ","))
		ui.set(weapon.cfg[i].doubletap_mode, (tbl[87 + (90 * (i - 1))]))
        ui.set(weapon.cfg[i].doubletap_hc, (tbl[88 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].doubletap_fl, (tbl[89 + (90 * (i - 1))]))
		ui.set(weapon.cfg[i].doubletap_stop, str_to_sub(tbl[90 + (90 * (i - 1))], ","))
	end


end

ui.new_label("Rage", "Aimbot","\n")
ui.new_label("Rage", "Other","\n")
local cfg1 = ui.new_label("Rage", "Other","      \ad6b6f7ffImport/Export Weapon Settings")
local cfg2 = ui.new_button("Rage", "Other",'\aF0E68CFFExport',export_cfg)
local cfg3 = ui.new_button("Rage", "Other",'\aF0E68CFFImport',load_cfg)

--References

local ref_enabled, ref_enabledkey = ui.reference("RAGE", "Aimbot", "Enabled")
local ref_fov = ui.reference("RAGE", "Other", "Maximum FOV")
local ref_target_selection = ui.reference("RAGE", "Aimbot", "Target selection")
local ref_target_hitbox = ui.reference("RAGE", "Aimbot", "Target hitbox")
local ref_multipoint, ref_multipointkey = ui.reference("RAGE", "Aimbot", "Multi-point")
local ref_unsafe = ui.reference("RAGE", "Aimbot", "Avoid unsafe hitboxes")
local ref_multipoint_scale = ui.reference("RAGE", "Aimbot", "Multi-point scale")
local ref_prefer_safepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point")
local ref_force_safepoint = ui.reference("RAGE", "Aimbot", "Force safe point")
local ref_automatic_fire = ui.reference("RAGE", "Other", "Automatic fire")
local ref_automatic_penetration = ui.reference("RAGE", "Other", "Automatic penetration")
local ref_silent_aim = ui.reference("RAGE", "Other", "Silent aim")
local ref_hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
local ref_mindamage = ui.reference("RAGE", "Aimbot", "Minimum damage")
local ref_automatic_scope = ui.reference("RAGE", "Aimbot", "Automatic scope")
local ref_reduce_aimstep = ui.reference("RAGE", "Other", "Reduce aim step")
local ref_log_spread = ui.reference("RAGE", "Other", "Log misses due to spread")
local ref_low_fps_mitigations = ui.reference("RAGE", "Other", "Low FPS mitigations")
local ref_remove_recoil = ui.reference("RAGE", "Other", "Remove recoil")
local ref_accuracy_boost = ui.reference("RAGE", "Other", "Accuracy boost")
local ref_delay_shot = ui.reference("RAGE", "Other", "Delay shot")
local ref_quickstop, ref_quickstopkey, ref_quickstop_options = ui.reference("RAGE", "Aimbot", "Quick stop")
local ref_quickpeek, ref_quickpeek_key, ref_quickpeek_mode = ui.reference("RAGE", "Other", "Quick peek assist")
local ref_antiaim_correction = ui.reference("RAGE", "Other", "Anti-aim correction")
--local ref_antiaim_correction_override = ui.reference("RAGE", "Other", "Anti-aim correction override")
local ref_prefer_bodyaim = ui.reference("RAGE", "Aimbot", "Prefer body aim")
--local ref_prefer_bodyaim_disablers = ui.reference("RAGE", "Other", "Prefer body aim disablers")
local ref_force_bodyaim = ui.reference("RAGE", "Aimbot", "Force body aim")
local ref_duck_peek_assist = ui.reference("RAGE", "Other", "Duck peek assist")
local ref_doubletap, ref_doubletapkey, ref_doubletap_mode = ui.reference("RAGE", "Aimbot", "Double tap")
local ref_slowwalk, ref_slowwalk_key = ui.reference("AA", "Other", "Slow motion")
local ref_osaa, ref_osaakey = ui.reference("AA", "Other", "On shot anti-aim")
local ref_doubletap_hc = ui.reference("RAGE", "Aimbot", "Double tap hit chance")
local ref_doubletap_stop = ui.reference("RAGE", "Aimbot", "Double tap quick stop")
local ref_doubletap_fl = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit")
--local ref_doubletap_mode = ui.reference("RAGE", "Aimbot", "Double tap mode")
local ping_spike = { ui.reference("MISC", "Miscellaneous", "Ping spike") }
local ref_skeet_min_dmg = ui.reference("Rage", "Aimbot", "Minimum damage override")

local function hide_skeet()
    local disable_show = not ui.get(weapon.run_hide)
    ui.set_visible(ref_enabled,disable_show)
    ui.set_visible(ref_log_spread,disable_show)
    ui.set_visible(ref_fov,disable_show)
    ui.set_visible(ref_enabledkey,disable_show)
    ui.set_visible(ref_remove_recoil,disable_show)
    ui.set_visible(ref_reduce_aimstep,disable_show)
    ui.set_visible(ref_target_selection,disable_show)
    ui.set_visible(ref_target_hitbox,disable_show)
    ui.set_visible(ref_multipoint,disable_show)
    ui.set_visible(ref_multipointkey,disable_show)
    ui.set_visible(ref_unsafe,disable_show)
    ui.set_visible(ref_multipoint_scale,disable_show)
    ui.set_visible(ref_prefer_safepoint,disable_show)
    ui.set_visible(ref_automatic_fire,disable_show)
    ui.set_visible(ref_automatic_penetration,disable_show)
    ui.set_visible(ref_silent_aim,disable_show)
    ui.set_visible(ref_hitchance,disable_show)
    ui.set_visible(ref_mindamage,disable_show)
    ui.set_visible(ref_automatic_scope,disable_show)
    ui.set_visible(ref_low_fps_mitigations,disable_show)
    ui.set_visible(ref_accuracy_boost,disable_show)
    ui.set_visible(ref_delay_shot,disable_show)
    ui.set_visible(ref_doubletap_fl,disable_show)
    ui.set_visible(ref_quickstop,disable_show)
    ui.set_visible(ref_quickstopkey,disable_show)
    ui.set_visible(ref_quickstop_options,disable_show)
    ui.set_visible(ref_doubletap_hc,disable_show)
    ui.set_visible(ref_doubletap_stop,disable_show)
    ui.set_visible(ref_doubletap_mode,disable_show)
    ui.set_visible(ref_skeet_min_dmg,disable_show)
end

local function in_air()
    if entity.get_local_player( ) == nil then return false end
    return bit.band( entity.get_prop( entity.get_local_player( ), "m_fFlags" ), 1 ) == 0
end

local check = {0,3,8}

local function enemy_visible(idx)

    if idx == nil then return false end

    for k, v in pairs(check) do

        local cx, cy, cz = entity.hitbox_position(idx, v)
        if client.visible(cx, cy, cz) then
            return true
        end

    end
    return false
end

local vector_angles = function(x1, y1, z1, x2, y2, z2)
    local origin_x, origin_y, origin_z
    local target_x, target_y, target_z
    if x2 == nil then
        target_x, target_y, target_z = x1, y1, z1
        origin_x, origin_y, origin_z = client.eye_position()
        if origin_x == nil then
            return
        end
    else
        origin_x, origin_y, origin_z = x1, y1, z1
        target_x, target_y, target_z = x2, y2, z2
    end

    local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

    if delta_x == 0 and delta_y == 0 then
        return (delta_z > 0 and 270 or 90), 0
    else

        local yaw = math.deg(math.atan2(delta_y, delta_x))


        local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
        local pitch = math.deg(math.atan2(-delta_z, hyp))

        return pitch, yaw
    end
end

local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

local is_player_moving = function(ent)
    local vec_vel = { entity.get_prop(ent, 'm_vecVelocity') }
    local velocity = math.floor(math.sqrt(vec_vel[1]^2 + vec_vel[2]^2) + 0.5)

    return velocity > 1
end

local predict_positions = function(posx, posy, posz, ticks, ent)
    local x, y, z = entity.get_prop(ent, 'm_vecVelocity')

    for i = 0, ticks, 1 do
        posx = posx + x * globals.tickinterval()
        posy = posy + y * globals.tickinterval()
        posz = posz + z * globals.tickinterval() + 9.81 * globals.tickinterval() * globals.tickinterval() / 2
    end

    return posx, posy, posz
end

local calculate_damage = function(local_player, target, predictive)

    local entindex, dmg = -1, -1
    local lx, ly, lz = client.eye_position()

    local px, py, pz = entity.hitbox_position(target, 6) -- middle chest
    local px1, py1, pz1 = entity.hitbox_position(target, 4) -- upper chest
    local px2, py2, pz2 = entity.hitbox_position(target, 2) -- pelvis

    if predictive and is_player_moving(local_player) then
        lx, ly, lz = predict_positions(lx, ly, lz, 20, local_player)
    end
    
    for i=0, 2 do
        if i == 0 then
            entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px, py, pz)
        else 
            if i==1 then
                entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px1, py1, pz1)
            else
                entindex, dmg = client.trace_bullet(local_player, lx, ly, lz, px2, py2, pz2)
            end
        end

        if entindex == nil or entindex == local_player or not entity.is_enemy(entindex) then
            return -1
        end
        
        return dmg
    end

    return -1
end

local clamp = function(v, min, max)
    return ((v > max) and max) or ((v < min) and min or v)
end

local function angle_forward(angle) 
    local sin_pitch = math.sin(math.rad(angle[1]))
    local cos_pitch = math.cos(math.rad(angle[1]))
    local sin_yaw = math.sin(math.rad(angle[2]))
    local cos_yaw = math.cos(math.rad(angle[2]))

    return {        
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    }
end

function weapon:get_weapon_idx()
    local local_player = entity.get_local_player()
    if local_player == nil then return nil end
    local weapon_ent = entity.get_player_weapon(local_player)
    if weapon_ent == nil then return nil end
    local weapon_idx = bit.band(entity.get_prop(weapon_ent, "m_iItemDefinitionIndex"), 0xFFFF)
    if weapon_idx == nil then return nil end
    local get_idx = weapon_idx_list[weapon_idx] ~= nil and weapon_idx_list[weapon_idx] or 1
    return get_idx
end

function weapon:recorrect()
    local idx = self:get_weapon_idx()
    if idx == nil then return 1 end
    if ui.get(self.cfg[idx].enable) then
        return idx
    else     
        return 1
    end
end

function weapon:get_hitbox(idx)
    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Hitbox')
    if ui.get(self.ovr_forcehead) and includes(ui.get(self.available),'Hitbox') then
        return {'Head'}
    elseif ui.get(self.ovr_box) and includes(ui.get(self.available),'Hitbox') and includes(ui.get(self.cfg[idx].hitbox_mode),'Override 1') and complex then
        return ui.get(self.cfg[idx].ovr_target_hitbox) -- override 1
    elseif ui.get(self.ovr_box_2) and includes(ui.get(self.available),'Hitbox') and includes(ui.get(self.cfg[idx].hitbox_mode),'Override 2') and complex then
        return ui.get(self.cfg[idx].ovr_target_hitbox_2) -- override 2
    elseif in_air() and includes(ui.get(self.cfg[idx].hitbox_mode),'In-air') and complex then
        return ui.get(self.cfg[idx].air_target_hitbox) -- air
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].hitbox_mode),'Double-tap') and complex then
        return ui.get(self.cfg[idx].dt_target_hitbox) -- dt
    end
    return ui.get(self.cfg[idx].target_hitbox) -- global
end

local is_visible = false

function weapon:get_multipoint(idx)
    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Multi-Point')

    if ui.get(self.ovr_multi) and includes(ui.get(self.available),'Multipoint') and includes(ui.get(self.cfg[idx].multi_mode),'Override') and complex then
        return { [1] = ui.get(self.cfg[idx].ovr_multi_hitbox) , [2] = ui.get(self.cfg[idx].ovr_multipoint_scale) } -- override
    elseif ui.get(ping_spike[1]) and ui.get(ping_spike[2]) and ui.get(ping_spike[3]) >= ui.get(self.cfg[idx].ping_avilble) and includes(ui.get(weapon.cfg[idx].multi_mode),'Ping-spike') and complex then
        return { [1] = ui.get(self.cfg[idx].ping_multi_hitbox) , [2] = ui.get(self.cfg[idx].ping_multipoint_scale)} -- ping spike
    elseif in_air() and includes(ui.get(self.cfg[idx].multi_mode),'In-air') and complex then
        return { [1] = ui.get(self.cfg[idx].air_multi_hitbox) , [2] = ui.get(self.cfg[idx].air_multipoint_scale)} -- inair
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].multi_mode),'Double-tap') and complex then
        if ui.get(self.cfg[idx].dt_multi_complex) == 0 then
            return { [1] = ui.get(self.cfg[idx].dt_multi_hitbox) , [2] = ui.get(self.cfg[idx].dt_multipoint_scale) } -- dt
        elseif ui.get(self.cfg[idx].dt_multi_complex) == 1 and is_visible then
            return { [1] = ui.get(self.cfg[idx].dt_multi_hitbox_v) , [2] = ui.get(self.cfg[idx].dt_multipoint_scale_v) } -- dt
        elseif ui.get(self.cfg[idx].dt_multi_complex) == 1 and not is_visible then
            return { [1] = ui.get(self.cfg[idx].dt_multi_hitbox_a) , [2] = ui.get(self.cfg[idx].dt_multipoint_scale_a) } -- dt
        end
    end
    if ui.get(self.cfg[idx].multi_complex) == 0  or not includes(ui.get(weapon.cfg[idx].extra_feature),'Multi-Point') then
        return { [1] = ui.get(self.cfg[idx].target_multi) , [2] = ui.get(self.cfg[idx].multipoint_scale) } -- dt
    elseif ui.get(self.cfg[idx].multi_complex) == 1 and is_visible then
        return { [1] = ui.get(self.cfg[idx].multi_hitbox_v) , [2] = ui.get(self.cfg[idx].multipoint_scale_v) } -- dt
    elseif ui.get(self.cfg[idx].multi_complex) == 1 and not is_visible then
        return { [1] = ui.get(self.cfg[idx].multi_hitbox_a) , [2] = ui.get(self.cfg[idx].multipoint_scale_a) } -- dt
    end
end

function weapon:get_unsafe_hitbox(idx)
    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Unsafe hitbox')
    if ui.get(self.ovr_unsafe) and includes(ui.get(self.available),'Unsafe hitbox') and includes(ui.get(self.cfg[idx].unsafe_mode),'Override') and complex then
        return ui.get(self.cfg[idx].ovr_unsafe_hitbox) -- override
    elseif in_air() and includes(ui.get(self.cfg[idx].unsafe_mode),'In-air') and complex then
        return ui.get(self.cfg[idx].air_unsafe_hitbox) -- inair
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].unsafe_mode),'Double-tap') and complex then
        return ui.get(self.cfg[idx].dt_unsafe_hitbox) -- dt
    end
    return ui.get(self.cfg[idx].unsafe_hitbox) -- global
end

function weapon:get_prefer_safe_point(idx)
    if includes(ui.get(self.cfg[idx].safepoint),'Always on') then
        return true
    elseif includes(ui.get(self.cfg[idx].safepoint),'In-air') and in_air() then
        return true
    elseif includes(ui.get(self.cfg[idx].safepoint),'Double-tap') and ui.get(ref_doubletap) and ui.get(ref_doubletapkey) then
        return true
    end
    return false
end

function weapon:get_dis()
    local target = client.current_threat()
    if target == nil then return 99999999 end
    local target_vector = vector(entity.get_origin(target))

    local local_player = entity.get_local_player()
    if local_player == nil then return 99999999 end
    local local_vector = vector(entity.get_origin(local_player))

    local dis = local_vector:dist(target_vector)
    return dis
end

function weapon:get_scope(idx)
    if not ui.get(self.cfg[idx].automatic_scope_e) then
        return false
    end
    local dis = self:get_dis()
    if includes(ui.get(self.cfg[idx].automatic_scope),'In distance') and dis < ui.get(self.cfg[idx].autoscope_therehold) then
        return false
    elseif includes(ui.get(self.cfg[idx].automatic_scope),'On doubletap') and ui.get(ref_doubletap) and ui.get(ref_doubletapkey) then
        return false
    end
    return true
end

function weapon:get_hitchance(idx)

    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Hitchance')
    if ui.get(self.ovr_hc) and includes(ui.get(self.available),'Hit chance') and includes(ui.get(self.cfg[idx].hitchance_mode),'Override 1') and complex then
        return ui.get(self.cfg[idx].hitchance_ovr) -- override 1
    elseif ui.get(self.ovr_hc_2) and includes(ui.get(self.available),'Hit chance') and includes(ui.get(self.cfg[idx].hitchance_mode),'Override 2') and complex then
        return ui.get(self.cfg[idx].hitchance_ovr_2) -- override 2
    elseif in_air() and includes(ui.get(self.cfg[idx].hitchance_mode),'In-air') and complex then
        return ui.get(self.cfg[idx].hitchance_air) -- air
    elseif ui.get(ref_duck_peek_assist) and includes(ui.get(self.cfg[idx].hitchance_mode),'Fake duck') and complex then
        return ui.get(self.cfg[idx].hitchance_fd) -- fd
    elseif ui.get(ref_osaa) and ui.get(ref_osaakey) and includes(ui.get(self.cfg[idx].hitchance_mode),'On-shot') and complex then
        return ui.get(self.cfg[idx].hitchance_os) -- os
    elseif entity.get_prop(entity.get_local_player(),'m_bIsScoped') == 0 and includes(ui.get(self.cfg[idx].hitchance_mode),'Unscoped') and complex and includes(scoped_wpn_idx,idx) then
        return ui.get(self.cfg[idx].hitchance_usc) -- scope
    elseif entity.get_prop(entity.get_local_player(), "m_flDuckAmount") > 0.8 and includes(ui.get(self.cfg[idx].hitchance_mode),'Crouching') and complex then
        return ui.get(self.cfg[idx].hitchance_cro) -- duck
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].hitchance_mode),'Double-tap') and complex then
        return ui.get(self.cfg[idx].hitchance_dt) -- dt
    end
    return ui.get(self.cfg[idx].hitchance) -- global

end

function weapon:get_damage(idx)

    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Damage')
    if ui.get(self.ovr_dmg) and includes(ui.get(self.available),'Min DMG') and includes(ui.get(self.cfg[idx].damage_mode),'Override 1') and complex then
        return ui.get(self.cfg[idx].damage_ovr)
    elseif ui.get(self.ovr_dmg_2) and includes(ui.get(self.available),'Min DMG') and includes(ui.get(self.cfg[idx].damage_mode),'Override 2') and complex then
        return ui.get(self.cfg[idx].damage_ovr_2)
    elseif in_air() and includes(ui.get(self.cfg[idx].damage_mode),'In-air') and complex then
        return ui.get(self.cfg[idx].damage_air) -- air
    elseif ui.get(ref_duck_peek_assist) and includes(ui.get(self.cfg[idx].damage_mode),'Fake duck') and complex then
        return ui.get(self.cfg[idx].damage_fd) -- fd
    elseif ui.get(ref_osaa) and ui.get(ref_osaakey) and includes(ui.get(self.cfg[idx].damage_mode),'On-shot') and complex then
        return ui.get(self.cfg[idx].damage_os) -- os
    elseif includes(ui.get(self.cfg[idx].damage_mode),'Unscoped') and entity.get_prop(entity.get_local_player(),'m_bIsScoped') == 0 and complex and includes(scoped_wpn_idx,idx) then
        return ui.get(self.cfg[idx].damage_usc) -- scope
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].damage_mode),'Double-tap') and complex then
        
        if ui.get(self.cfg[idx].damage_complex_dt) == 'Original' then
            return ui.get(self.cfg[idx].damage_dt)
        elseif ui.get(self.cfg[idx].damage_complex_dt) == 'Visible/autowall' and is_visible then
            return ui.get(self.cfg[idx].damage_cro_dt)
        elseif ui.get(self.cfg[idx].damage_complex_dt) == 'Visible/autowall' and not is_visible then
            return ui.get(self.cfg[idx].damage_aut_dt)
        end
    end

    if ui.get(self.cfg[idx].damage_complex) == 'Original' or not includes(ui.get(self.cfg[idx].extra_feature),'Damage') then
        return ui.get(self.cfg[idx].damage)
    elseif ui.get(self.cfg[idx].damage_complex) == 'Visible/autowall' and is_visible then
        return ui.get(self.cfg[idx].damage_cro)
    elseif ui.get(self.cfg[idx].damage_complex) == 'Visible/autowall' and not is_visible then
        return ui.get(self.cfg[idx].damage_aut)
    end

end

function weapon:get_delay(idx)
    if includes(ui.get(self.cfg[idx].delay_shot),'Always on') then
        return true
    elseif includes(ui.get(self.cfg[idx].delay_shot),'On key') and includes(ui.get(self.available),'Delay shot') and ui.get(self.ovr_delay) then
        return true
    end
    return false
end

function weapon:get_stop(idx)
    local complex = includes(ui.get(self.cfg[idx].extra_feature),'Quick stop')

    if ui.get(self.ovr_stop) and includes(ui.get(self.available),'Quick stop') and includes(ui.get(self.cfg[idx].stop_mode),'Override') and complex then
        return { [1] = ui.get(self.cfg[idx].stop_ovr) , [2] = ui.get(self.cfg[idx].stop_option_ovr) }
    elseif entity.get_prop(entity.get_local_player(),'m_bIsScoped') == 0 and includes(ui.get(self.cfg[idx].stop_mode),'Unscoped') and complex and includes(scoped_wpn_idx,idx) then
        return { [1] = ui.get(self.cfg[idx].stop_unscoped) , [2] = ui.get(self.cfg[idx].stop_option_unscoped) }
    elseif ui.get(ref_doubletap) and ui.get(ref_doubletapkey) and includes(ui.get(self.cfg[idx].stop_mode),'Double-tap') and complex then
        return { [1] = ui.get(self.cfg[idx].stop_dt) , [2] = ui.get(self.cfg[idx].stop_option_dt) }
    end
    return { [1] = ui.get(self.cfg[idx].stop) , [2] = ui.get(self.cfg[idx].stop_option) }
end

function weapon:get_baim(idx)
    if ui.get(self.ovr_forcehead) and includes(ui.get(self.available),'Hitbox') then
        return false
    end
    return ui.get(self.cfg[idx].preferbm)
end

function weapon:disabler(idx)

    local disable_list = {}

    if includes(ui.get(self.cfg[idx].prefer_baim_disablers),"Low inaccuracy") then
        table.insert(disable_list,"Low inaccuracy")
    end

    if includes(ui.get(self.cfg[idx].prefer_baim_disablers),"Target shot fired") then
        table.insert(disable_list,"Target shot fired")
    end

    if includes(ui.get(self.cfg[idx].prefer_baim_disablers),"Target resolved") then
        table.insert(disable_list,"Target resolved")
    end

    if includes(ui.get(self.cfg[idx].prefer_baim_disablers),"Safe point headshot") then
        table.insert(disable_list,"Safe point headshot")
    end

    is_visible = false

    local me = entity.get_local_player() 
    for _, players in pairs(entity.get_players(true)) do

        plist.set(players, "High priority",false)

        if enemy_visible(players) then
            is_visible = true
        end

        if includes(ui.get(self.high_pro),'AWP user') then
            local weapon = entity.get_player_weapon(players)
            if weapon ~= nil then
                plist.set(players, "High priority", entity.get_classname(weapon) == "CWeaponAWP")
            end
        end

        if includes(ui.get(self.high_pro),'Bomb carrier') then
            for i = 64 , 0 , -1 do
                local idx = entity.get_prop(entity.get_prop(players, "m_hMyWeapons", i), "m_iItemDefinitionIndex")
                if idx == 49 then
                    plist.set(players, "High priority", true)
                end
            end
        end

        local me_origin = { entity.get_prop(me, 'm_vecAbsOrigin') }
        local e_wpn = entity.get_player_weapon(players)
        local shot_time = globals.tickinterval() * 14
        local vec_vel = { entity.get_prop(players, 'm_vecVelocity') }
        local eye_pos = { client.eye_position() }
        local abs_origin = { entity.get_prop(players, 'm_vecAbsOrigin') }
        local ang_abs = { entity.get_prop(players, 'm_angAbsRotation') }
        local pitch, yaw = vector_angles(abs_origin[1], abs_origin[2], abs_origin[2], eye_pos[1], eye_pos[2], eye_pos[3])
        local yaw_degress = math.floor(math.abs(normalize_yaw(yaw - ang_abs[2])))

        local health = entity.get_prop(players, "m_iHealth")
        local g_damage = calculate_damage(me, players, true)

        if includes(ui.get(self.cfg[idx].prefer_baim_disablers),'High pitch') and ui.get(ref_prefer_bodyaim) then
            if me_origin[3] > abs_origin[3] and math.abs(me_origin[3] - abs_origin[3]) > 30 or false then
                plist.set(players, "Override prefer body aim","Off" )
            end
        end

        if includes(ui.get(self.cfg[idx].prefer_baim_disablers),'Side way') and ui.get(ref_prefer_bodyaim) then
            if yaw_degress > 90 + 20 or yaw_degress < 90 - 20 then
                plist.set(players, "Override prefer body aim","Off" ) 
            end
        end

        if ui.get(self.cfg[idx].lethal) then
            if g_damage >= health then
                plist.set(players, "Override prefer body aim","Force" )
            end
        end

        plist.set(players, "Override prefer body aim","-" )
    end
end

function weapon:get_ping(idx)
    if ui.get(self.allow_fake_ping) == false then return end

    if (ui.get(self.cfg[idx].fp) == 'Always on') then
        ui.set(ping_spike[1],true)
    elseif (ui.get(self.cfg[idx].fp) == 'On key') and ui.get(self.fake_ping_key) then
        ui.set(ping_spike[1],true)
    else
        ui.set(ping_spike[1],false)
    end

    ui.set(ping_spike[2],'Always on')
end

local wpn_ignored = {
	'CKnife',
	'CWeaponTaser',
	'CC4',
	'CHEGrenade',
	'CSmokeGrenade',
	'CMolotovGrenade',
	'CSensorGrenade',
	'CFlashbang',
	'CDecoyGrenade',
	'CIncendiaryGrenade'
}

function weapon:main_funcs()

    if ui.get(self.main_switch) == false then return end

    local local_player = entity.get_local_player()

    local weapon_d = entity.get_player_weapon(local_player)

    if weapon_d == nil then return end
    
    local weapon_id = self:recorrect()

    if weapon_id == nil then weapon_id = 1 end

    local allow_use_pene = false
    local dmg_out = 0

    if weapon_d ~= nil and not includes(wpn_ignored, entity.get_classname(weapon_d)) then

        if  ui.get(self.ovr_dmg_smart) and includes(ui.get(self.available),'Min DMG') then

            local pitch, yaw = client.camera_angles()
            local fwd = angle_forward({ pitch, yaw, 0 })
            local start_pos = { client.eye_position() }
            
            local fraction = client.trace_line(local_player, start_pos[1], start_pos[2], start_pos[3], start_pos[1] + (fwd[1] * 8192), start_pos[2] + (fwd[2] * 8192), start_pos[3] + (fwd[3] * 8192))

            if fraction < 1 then
                local end_pos = {
                    start_pos[1] + (fwd[1] * (8192 * fraction + 128)),
                    start_pos[2] + (fwd[2] * (8192 * fraction + 128)),
                    start_pos[3] + (fwd[3] * (8192 * fraction + 128)),
                }

                local ent, dmg = client.trace_bullet(local_player, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2], end_pos[3])

                if ent == nil then
                    ent = -1
                end

                if dmg > 0 and ui.get(self.ovr_dmg_smart) and includes(ui.get(self.available),'Min DMG') then
                    allow_use_pene = true
                    dmg_out = dmg
                end
            end
        end
    end     

    --ui.set(ref_target_selection,ui.get(self.cfg[weapon_id].target_selection))

    local target_hitbox = self:get_hitbox(weapon_id)
    if #target_hitbox == 0 then
        target_hitbox = {'Head'}
    end

    ui.set(ref_target_hitbox,target_hitbox)
    ui.set(ref_multipoint,self:get_multipoint(weapon_id)[1])
    ui.set(ref_multipointkey,'Always on')
    ui.set(ref_multipoint_scale,self:get_multipoint(weapon_id)[2])
    ui.set(ref_unsafe,self:get_unsafe_hitbox(weapon_id))
    ui.set(ref_prefer_safepoint,self:get_prefer_safe_point(weapon_id))
    ui.set(ref_automatic_fire,ui.get(self.cfg[weapon_id].automatic_fire))
    ui.set(ref_automatic_penetration,ui.get(self.cfg[weapon_id].automatic_penetration))
    ui.set(ref_automatic_scope,self:get_scope(weapon_id))
    ui.set(ref_silent_aim,ui.get(self.cfg[weapon_id].silent_aim))
    ui.set(ref_fov,ui.get(self.cfg[weapon_id].max))
    ui.set(ref_low_fps_mitigations,ui.get(self.cfg[weapon_id].fps_boost))
    ui.set(ref_hitchance,self:get_hitchance(weapon_id) )
    ui.set(ref_mindamage,allow_use_pene and clamp(dmg_out,0,126) or self:get_damage(weapon_id) )
    --ui.set(ref_accuracy_boost,ui.get(self.cfg[weapon_id].accuarcy_boost) )
    ui.set(ref_delay_shot,self:get_delay(weapon_id) )
    ui.set(ref_quickstop,self:get_stop(weapon_id)[1] )
    ui.set(ref_quickstopkey,'Always on')
    ui.set(ref_quickstop_options,self:get_stop(weapon_id)[2])
    self:disabler(weapon_id)
    self:get_ping(weapon_id)

    if includes(ui.get(self.cfg[weapon_id].dt),'Doubletap mode') then
        ui.set(ref_doubletap_mode,ui.get(self.cfg[weapon_id].doubletap_mode))
    end

    if includes(ui.get(self.cfg[weapon_id].dt),'Doubletap quick stop') then
        ui.set(ref_doubletap_stop,ui.get(self.cfg[weapon_id].doubletap_stop))
    end
    
    if includes(ui.get(self.cfg[weapon_id].dt),'Doubletap hitchance') then
        ui.set(ref_doubletap_hc,ui.get(self.cfg[weapon_id].doubletap_hc))
    end

    if includes(ui.get(self.cfg[weapon_id].dt),'Doubletap fakelag') then
        ui.set(ref_doubletap_fl,ui.get(self.cfg[weapon_id].doubletap_fl))
    end
end

local function invisible()
    local vis = ui.is_menu_open()
    if vis == false and ui.get(weapon.adjust) then
        local id = weapon:recorrect()
        if id == nil then id = 1 end
        ui.set(weapon.weapon_select,weapon_name[id])
    end
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

local function indicator()
    local screen_size_x,screen_size_y = client.screen_size()
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    local color = {ui.get(weapon.lua_clr)}
    local test = gradient_text(176,196,222, 255,color[1],color[2],color[3],color[4], "DMG -> "..ui.get(ref_mindamage))

    local id = weapon:recorrect()
    if id == nil then id = 1 end
    if ui.get(weapon.ovr_dmg_smart) and includes(ui.get(weapon.available),'Min DMG') then
        renderer.indicator(100,220,220,255, 'AUTO PENETRATION')
    end

    if ui.get(weapon.ovr_dmg_2) and includes(ui.get(weapon.available),'Min DMG') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].damage_mode),'Override 2') and (not (ui.get(weapon.ovr_dmg) and includes(ui.get(weapon.cfg[id].damage_mode),'Override 1')) and 255 or 150) or 150, 'OVR DAMAGE 2')
    end

    if ui.get(weapon.ovr_hc) and includes(ui.get(weapon.available),'Hit chance') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].hitchance_mode),'Override 1') and 255 or 150, 'OVR HITCHANCE [1]')
    end

    if ui.get(weapon.ovr_hc_2) and includes(ui.get(weapon.available),'Hit chance') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].hitchance_mode),'Override 2') and (not (ui.get(weapon.ovr_hc) and includes(ui.get(weapon.cfg[id].hitchance_mode),'Override 1')) and 255 or 150) or 150, 'OVR HITCHANCE 2')
    end

    if ui.get(weapon.ovr_box) and includes(ui.get(weapon.available),'Hitbox') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].hitbox_mode),'Override 1') and 255 or 150, 'OVR HITBOX [1]')
    end

    if ui.get(weapon.ovr_box_2) and includes(ui.get(weapon.available),'Hitbox') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].hitbox_mode),'Override 2') and (not (ui.get(weapon.ovr_box) and includes(ui.get(weapon.cfg[id].hitbox_mode),'Override 1')) and 255 or 150) or 150, 'OVR HITBOX 2')
    end

    if ui.get(weapon.ovr_multi) and includes(ui.get(weapon.available),'Multipoint') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].multi_mode),'Override') and 255 or 150, 'OVR MULTIPOINT')
    end

    if ui.get(weapon.ovr_unsafe) and includes(ui.get(weapon.available),'Unsafe hitbox') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].unsafe_mode),'Override') and 255 or 150, 'OVR UNSAFE HITBOX')
    end

    if ui.get(weapon.ovr_stop) and  includes(ui.get(weapon.available),'Quick stop') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].stop_mode),'Override') and 255 or 150, 'OVR QUICK STOP')
    end

    if ui.get(weapon.ovr_delay) and includes(ui.get(weapon.available),'Delay shot') then
        renderer.indicator(220,220,220,includes(ui.get(weapon.cfg[id].delay_shot),'On key') and 255 or 150, 'FORCE DELAY')
    end

    if ui.get(weapon.ovr_forcehead) and includes(ui.get(weapon.available),'Hitbox') then
        renderer.indicator(220,0,0,255, 'FORCE HEAD')
    end

    if ui.get(weapon.lua_label) == 'Skeet indicator' then
        renderer.indicator(100,149,237,255, test)
    else
        local size_x,size_y = renderer.measure_text('',ui.get(ref_mindamage))
        renderer.text(screen_size_x/2-size_x*2,screen_size_y/2-size_y*2.5,color[1],color[2],color[3],color[4],"b",'',ui.get(ref_mindamage))
    end

    
end
--Mewtwo Radio
local ffi = require("ffi")
local logo = renderer.load_png('\137\80\78\71\13\10\26\10\0\0\0\13\73\72\68\82\0\0\1\53\0\0\0\96\8\6\0\0\0\124\43\229\244\0\0\18\51\73\68\65\84\120\156\237\157\123\112\84\215\125\199\127\231\222\125\233\253\98\37\33\144\16\32\192\54\66\216\194\248\133\1\169\38\182\105\27\219\36\158\62\6\63\80\39\51\157\22\55\99\60\113\154\102\38\181\155\153\182\147\78\103\226\127\220\255\90\172\54\228\143\118\226\184\113\18\27\76\204\195\136\26\19\64\88\193\40\32\217\90\64\66\15\30\150\37\164\125\221\251\235\156\115\239\93\237\174\86\72\72\43\27\105\191\31\205\142\118\239\222\123\238\153\115\238\124\247\119\206\239\119\126\71\16\0\179\200\231\87\204\134\222\238\161\53\167\114\243\191\67\76\85\26\51\233\6\145\96\238\254\230\157\250\98\180\61\72\55\16\53\48\107\52\7\152\117\83\10\152\18\49\82\239\77\34\141\173\99\154\73\215\182\173\214\74\208\3\32\157\104\104\77\48\27\72\65\147\194\197\170\108\86\34\70\113\191\162\246\231\226\223\188\115\116\7\58\0\164\19\136\26\72\59\157\29\67\207\144\18\48\86\86\153\102\10\37\102\117\163\151\26\165\202\137\184\239\110\44\190\127\55\122\0\164\19\23\90\19\164\155\35\238\220\255\178\134\156\82\186\152\54\122\251\27\23\87\150\31\180\111\35\222\60\107\114\236\150\140\230\7\233\5\162\6\102\5\22\68\204\68\207\46\211\18\230\109\127\118\86\14\75\77\107\32\42\152\158\168\211\49\175\11\210\10\68\13\164\149\67\135\78\55\116\145\237\12\72\85\176\96\98\22\214\247\230\204\239\124\234\189\72\151\198\180\68\57\30\152\165\243\161\103\197\6\237\207\221\5\174\195\232\217\204\4\115\106\32\173\116\85\215\29\80\229\77\36\90\60\230\253\156\169\243\253\196\251\97\89\202\18\203\17\193\106\184\75\44\74\59\63\48\15\158\123\59\140\129\109\134\2\81\3\233\199\182\210\238\184\222\211\152\92\118\188\71\116\38\19\106\82\208\164\136\41\89\116\254\91\74\234\178\212\146\169\227\23\33\110\61\220\218\128\30\206\44\32\106\32\109\244\244\222\80\2\162\73\113\97\166\226\98\79\170\162\47\10\178\172\42\249\247\118\155\201\111\183\221\218\56\244\248\129\200\57\37\100\182\120\214\172\49\154\106\31\247\136\65\62\217\36\98\222\85\165\107\148\127\245\46\120\87\51\12\204\169\129\180\241\94\40\251\128\227\245\148\194\178\116\153\255\96\138\178\171\200\142\96\155\254\156\26\175\176\60\17\68\57\254\238\198\156\138\106\117\159\135\254\240\129\55\136\72\190\232\252\47\194\108\11\92\53\122\56\179\128\165\6\210\66\115\128\175\58\229\48\147\81\254\89\107\211\68\229\154\154\99\77\89\243\107\26\19\183\28\248\109\67\223\165\107\147\14\21\251\78\12\191\168\174\177\175\175\185\187\58\149\112\198\172\56\57\215\6\50\11\184\211\193\140\9\244\132\55\31\140\184\247\17\145\71\83\83\101\220\253\236\82\109\220\186\206\143\79\117\53\116\122\170\14\56\75\167\52\103\201\148\12\196\53\217\10\210\181\188\152\1\34\170\110\188\63\113\32\49\120\121\100\199\249\118\247\110\231\218\123\182\184\83\62\191\150\149\230\4\254\82\111\245\55\188\11\209\203\153\3\68\13\204\8\185\28\42\254\122\193\52\248\92\181\40\76\85\230\207\63\49\89\134\93\88\235\63\133\18\38\75\124\172\57\54\123\161\187\122\40\157\117\162\190\232\39\77\235\55\215\169\33\229\177\131\81\117\189\252\206\239\191\182\171\178\174\236\181\228\123\72\175\167\19\222\33\175\95\182\205\139\103\60\195\64\135\131\105\147\36\104\82\76\130\130\105\232\217\165\162\44\85\153\111\157\49\173\121\46\91\116\164\56\201\121\49\221\22\55\41\66\186\179\172\138\217\62\207\186\214\19\177\222\216\86\26\215\111\113\143\155\58\249\253\47\109\11\205\180\230\245\150\63\229\193\243\157\129\160\211\193\45\115\241\170\177\227\253\97\45\217\171\40\5\237\228\115\213\98\195\76\90\116\228\243\232\142\143\218\105\183\53\52\229\216\16\85\10\29\141\5\216\118\202\233\180\250\45\238\132\107\219\127\25\102\71\32\107\158\132\133\150\169\160\227\193\45\145\60\220\116\120\126\137\152\149\103\233\255\14\71\99\195\73\103\21\130\176\70\168\20\47\106\237\191\10\127\166\153\84\29\231\81\21\43\158\76\25\82\2\230\57\240\126\130\41\51\129\160\5\150\4\142\205\94\128\171\224\177\64\93\22\180\238\145\212\206\1\98\43\116\67\8\107\142\14\100\46\136\83\3\147\242\254\241\246\77\23\75\87\29\74\62\239\97\253\139\166\229\139\11\222\152\173\22\60\250\65\148\41\206\74\211\220\237\106\133\66\242\176\147\156\33\135\173\125\81\151\32\205\64\191\102\42\16\53\112\83\142\159\235\105\248\196\187\240\64\242\57\179\53\220\116\56\114\36\202\100\142\205\143\48\137\238\250\141\181\41\99\210\28\212\74\5\251\10\83\159\205\218\129\219\25\12\63\193\77\249\42\4\237\131\150\40\11\123\40\41\172\212\107\23\214\55\186\39\221\207\64\45\104\71\130\182\140\7\150\26\152\144\230\0\95\180\85\66\137\216\108\139\217\137\150\246\29\35\98\249\110\103\65\188\156\67\187\191\193\53\165\123\170\169\55\97\133\133\120\195\76\33\68\115\100\44\176\212\64\74\14\159\189\252\45\34\90\252\101\9\218\229\75\87\27\110\136\26\21\38\162\242\229\50\209\131\155\166\38\104\10\59\174\141\210\144\210\8\204\109\32\106\32\37\159\101\151\127\55\110\44\247\217\108\183\210\194\197\37\106\190\204\206\137\214\183\97\227\45\8\154\92\129\96\56\41\136\172\203\188\225\89\170\40\184\237\129\168\129\113\52\7\248\18\17\173\136\179\210\150\125\25\173\180\233\33\151\168\42\187\218\248\240\195\174\242\91\189\150\53\203\90\35\132\115\100\60\16\53\144\138\69\113\199\122\103\163\133\114\220\57\63\43\240\20\22\37\31\175\170\41\187\169\135\115\98\4\57\118\154\102\66\216\50\25\136\26\72\224\84\96\32\33\144\182\62\20\248\179\116\182\80\77\205\202\236\71\30\217\50\228\202\114\109\142\114\228\122\186\202\21\118\182\15\194\140\90\198\3\239\39\72\32\112\101\112\45\45\88\16\59\180\102\101\245\184\160\219\105\34\190\254\245\167\62\223\186\245\177\188\250\123\235\69\203\225\15\114\255\254\239\94\73\107\227\179\157\159\205\208\32\107\153\12\68\13\36\48\184\96\185\180\204\66\114\174\61\93\45\83\182\176\98\232\165\93\47\101\111\110\216\164\101\121\61\52\52\60\68\247\174\95\71\175\254\227\171\50\111\218\146\151\191\251\242\140\239\97\37\156\180\108\53\151\193\20\197\206\123\25\11\68\13\36\35\211\6\165\37\30\127\195\198\141\195\77\127\249\87\89\171\239\92\73\21\254\50\45\20\28\161\145\145\17\202\205\201\165\188\252\28\26\29\25\245\181\181\157\73\75\7\88\11\217\173\229\84\140\1\104\70\3\81\3\201\44\154\169\168\213\44\124\124\232\249\23\190\102\110\123\234\81\94\125\215\106\141\217\248\162\127\224\74\190\105\184\169\176\40\159\152\77\50\77\147\74\22\148\148\166\175\245\237\56\53\101\181\153\84\253\13\95\250\138\6\115\10\56\10\64\50\158\248\185\246\230\192\212\60\137\217\222\2\221\165\187\7\137\104\180\124\193\146\172\239\124\251\165\252\213\119\221\153\27\10\143\80\212\8\229\231\230\249\130\190\44\47\231\228\100\147\203\229\34\77\211\40\191\32\239\170\223\95\210\246\198\238\255\152\113\39\8\219\77\32\43\30\213\53\238\122\19\129\106\153\10\68\13\204\24\175\59\183\52\24\25\30\53\217\200\39\65\190\99\159\252\84\127\243\167\39\149\193\231\245\184\201\136\186\232\220\153\168\47\59\219\99\232\154\70\186\166\147\176\22\40\20\249\188\190\226\116\212\129\133\105\103\201\101\211\29\229\14\244\106\230\2\81\3\201\156\149\198\206\84\91\37\223\91\36\162\70\240\34\17\171\124\64\154\16\20\49\134\232\245\151\78\240\15\183\13\211\161\55\71\233\159\155\70\233\215\255\98\80\78\158\181\205\138\99\7\106\66\104\190\156\172\241\121\132\166\193\216\198\198\164\85\108\243\252\19\122\53\115\193\156\26\72\102\36\254\185\120\126\201\205\39\221\111\68\6\229\238\1\9\115\112\210\8\203\246\120\196\249\67\35\116\230\192\8\69\70\93\244\208\211\114\249\147\75\152\108\18\155\76\134\97\144\166\11\26\29\189\17\245\121\103\54\255\213\241\113\87\131\56\111\111\208\46\197\205\45\102\45\199\27\184\253\129\165\6\18\40\238\111\255\201\173\180\72\121\214\221\28\31\238\170\98\197\92\58\185\179\242\136\124\33\114\229\133\136\125\35\228\46\14\71\162\134\161\71\163\6\69\141\168\18\181\112\56\66\35\35\163\236\203\201\154\81\39\116\119\244\154\170\6\112\122\102\60\4\81\3\201\84\149\22\183\198\31\250\93\231\133\155\166\234\174\244\109\213\92\148\165\60\154\82\210\164\21\230\119\215\211\162\252\187\169\180\212\77\5\217\30\34\67\205\119\185\45\33\11\171\87\36\18\33\211\228\225\226\162\5\33\158\246\78\237\22\75\232\158\189\20\219\125\10\75\164\50\29\136\26\72\160\184\176\32\225\115\56\60\241\244\154\63\171\38\215\175\63\196\85\190\39\136\89\144\105\18\21\186\106\233\129\130\127\160\28\151\139\116\87\152\10\139\61\202\130\170\90\27\165\209\209\176\8\6\131\36\95\150\168\25\185\151\123\122\202\47\247\244\204\172\19\152\124\202\255\201\68\21\127\234\131\189\150\225\96\78\13\36\112\177\183\159\200\87\25\59\148\237\155\120\71\166\34\177\174\200\235\113\139\7\203\94\164\234\225\70\210\132\139\202\115\234\168\184\32\159\12\30\166\209\48\81\240\58\83\78\89\152\214\62\150\123\245\250\181\145\18\41\102\110\183\139\66\161\16\237\125\103\223\240\223\126\239\251\17\65\226\180\32\177\150\167\145\181\182\235\231\161\94\43\237\183\10\232\232\236\254\239\16\45\250\147\180\45\134\0\115\16\136\26\72\224\188\175\50\33\125\247\29\75\23\79\152\53\35\87\171\172\240\184\124\90\118\94\152\150\103\175\37\211\20\164\187\76\10\241\32\9\210\72\119\107\212\119\37\72\79\124\143\200\157\101\22\69\62\39\234\235\235\231\150\150\150\27\71\91\62\188\118\240\224\161\186\127\123\253\117\25\219\70\59\119\190\112\203\29\17\28\224\134\222\195\225\50\77\173\40\80\6\90\13\122\19\64\212\192\180\233\53\90\158\41\25\170\13\25\122\177\55\63\39\143\116\45\139\116\205\77\186\174\209\208\80\144\34\97\157\22\61\24\48\87\54\20\208\71\71\46\210\177\99\199\134\247\237\221\31\61\213\218\90\188\117\235\227\252\234\43\63\160\191\222\185\51\150\216\241\86\185\124\36\124\64\133\187\205\112\78\14\204\47\48\255\0\98\36\239\235\57\89\10\111\183\238\249\95\143\238\223\152\231\170\112\121\220\134\158\231\45\247\228\186\42\216\171\231\136\47\130\215\141\104\208\43\242\235\78\222\32\210\46\118\158\187\240\240\142\191\120\118\104\223\222\253\234\218\242\133\86\30\200\119\222\121\119\90\29\240\233\91\33\150\78\1\105\161\201\255\149\79\99\46\13\88\192\82\3\138\182\75\87\254\248\100\220\94\153\119\69\47\55\77\214\50\126\207\186\39\73\25\74\137\206\132\144\113\99\220\185\203\87\86\37\124\158\174\152\73\58\222\10\91\203\214\229\144\147\9\130\6\18\128\168\1\197\73\163\228\223\157\247\171\242\105\215\250\162\138\73\3\88\7\194\39\200\163\251\41\207\85\49\165\70\252\209\143\254\117\70\141\125\238\237\80\167\96\81\41\183\205\115\22\175\27\119\246\79\42\190\32\179\128\168\1\135\88\198\140\7\138\196\107\83\105\149\136\17\166\136\209\77\55\194\221\19\159\212\146\158\246\237\60\113\245\69\163\71\44\21\196\49\171\172\119\193\153\166\251\87\215\99\245\0\72\0\162\6\110\107\142\236\107\123\181\36\178\234\149\200\101\34\157\237\180\221\76\131\75\183\121\11\209\115\32\21\16\53\224\96\58\193\216\167\251\135\55\173\45\205\61\252\85\181\204\199\39\207\237\16\253\213\187\149\128\25\228\100\223\80\223\121\86\13\55\86\222\81\50\205\205\89\64\38\0\81\3\14\114\215\40\53\57\214\58\154\115\232\171\242\140\247\118\69\27\250\207\153\246\166\198\150\101\198\118\170\238\21\79\96\219\117\48\57\120\72\64\140\228\144\14\74\195\206\236\251\143\27\247\109\89\175\127\52\149\115\79\189\23\233\22\76\21\50\68\67\90\103\154\41\151\62\49\221\249\71\16\51\48\117\240\176\128\4\82\9\155\102\18\221\229\250\98\103\97\126\254\187\199\251\185\76\99\113\94\48\15\105\76\166\220\27\64\103\214\158\92\173\203\205\90\232\215\173\198\163\194\164\237\26\209\147\154\201\121\50\119\163\18\40\153\18\200\36\10\141\124\184\235\209\45\27\198\57\34\190\184\110\52\124\250\91\83\173\102\208\77\162\53\143\185\241\108\130\105\129\225\39\72\166\139\136\170\157\99\78\232\68\123\36\255\117\125\128\236\223\65\142\104\166\8\9\230\136\90\115\201\164\189\221\102\228\104\166\112\73\203\74\56\99\70\41\100\194\138\39\19\106\202\78\80\109\237\250\214\84\45\222\113\194\60\160\150\59\49\211\141\236\115\8\211\0\211\6\191\134\32\37\173\23\250\254\230\52\151\254\64\48\249\165\70\73\235\73\90\90\206\208\48\118\204\126\47\119\69\215\236\133\229\154\138\242\183\44\60\251\24\107\38\135\132\41\196\166\13\174\148\25\33\79\237\143\176\176\203\174\123\20\195\77\48\125\240\240\128\73\249\201\167\220\161\153\180\92\115\114\150\57\162\197\166\45\110\214\208\210\201\103\166\217\226\39\179\208\106\76\215\254\224\62\189\100\178\123\156\122\47\194\154\189\203\58\68\13\204\4\12\63\193\164\60\179\76\36\100\191\248\205\135\167\118\12\22\172\181\60\148\166\148\33\86\139\210\87\250\135\155\122\47\116\84\143\122\234\94\145\71\116\41\112\193\147\95\155\202\61\28\21\179\179\109\0\48\109\240\4\129\105\179\255\131\15\27\106\87\215\146\207\227\166\51\109\173\244\208\3\247\29\104\187\16\108\234\27\240\236\86\225\24\38\211\35\247\185\166\244\140\181\190\23\102\103\200\90\251\56\44\53\48\125\96\169\129\105\179\101\227\3\9\65\176\7\143\125\178\43\228\94\181\219\73\7\84\228\187\212\56\229\178\229\234\39\158\78\154\72\0\18\65\58\111\144\22\186\6\70\118\4\61\43\127\44\3\66\44\135\2\209\186\186\234\41\71\254\87\213\107\74\0\97\162\129\153\50\169\165\150\42\110\9\204\127\132\74\237\99\197\151\89\158\77\65\142\163\64\216\195\68\221\118\6\200\243\206\94\98\21\142\161\126\37\5\211\35\235\167\54\236\116\136\134\131\36\200\173\202\62\251\171\48\43\103\131\237\73\37\117\63\185\121\139\166\156\19\78\80\174\186\159\237\180\0\153\131\127\251\205\83\77\77\248\101\115\128\79\19\81\29\158\149\204\196\10\219\176\61\152\6\199\47\38\183\189\155\210\235\105\197\163\233\113\214\153\252\255\232\189\250\180\12\174\223\189\27\102\17\87\182\18\76\182\239\109\8\59\92\196\241\176\138\152\136\10\100\190\205\72\38\18\183\148\195\207\255\217\219\190\3\130\6\148\160\153\214\230\196\28\11\196\29\179\214\216\201\2\196\214\43\95\191\208\56\93\65\179\202\177\118\132\34\187\108\225\132\250\170\13\146\217\250\5\182\163\129\149\37\73\72\229\157\201\12\236\9\166\180\209\199\137\90\115\128\143\142\220\177\106\119\166\55\88\38\35\98\86\26\219\187\52\141\153\244\106\56\40\236\115\132\101\53\121\134\91\155\182\214\235\226\193\181\75\103\148\61\163\118\171\91\92\142\92\251\190\186\167\122\50\29\107\141\98\98\103\89\104\113\187\177\103\122\103\101\56\169\132\109\220\51\113\171\121\234\1\0\224\203\96\34\203\140\136\250\252\219\125\229\206\135\4\75\173\57\192\125\241\159\235\189\180\11\189\5\0\184\29\144\115\104\242\149\127\183\153\172\75\101\3\123\130\29\206\135\152\168\29\61\222\245\124\124\74\103\201\154\242\169\165\117\6\0\128\47\11\239\234\236\215\120\241\96\114\210\131\229\227\68\237\124\233\146\231\226\207\88\251\121\199\212\3\39\1\0\224\75\164\116\115\217\27\185\203\56\94\216\204\129\61\193\0\57\115\106\29\159\93\111\104\209\10\99\59\115\99\30\13\0\48\23\24\216\19\188\68\68\139\236\170\6\253\219\125\89\202\82\171\89\90\148\224\181\106\14\32\154\17\0\112\251\115\153\126\191\61\174\146\62\57\183\166\68\173\57\192\231\227\190\128\149\6\0\152\19\212\109\95\43\247\211\232\136\171\235\50\103\78\173\6\93\8\0\152\163\188\16\87\109\161\53\7\56\16\119\224\42\89\115\106\232\92\0\192\156\32\92\208\217\19\95\79\105\169\85\217\239\71\229\70\216\232\70\0\192\92\194\51\184\188\45\190\186\241\193\183\89\181\131\189\47\163\55\1\0\115\9\255\246\196\109\47\18\82\15\173\171\91\248\149\237\202\13\0\0\233\0\73\34\1\0\243\138\228\181\159\232\93\0\192\156\6\150\26\0\96\94\1\81\3\0\204\43\18\68\13\241\105\0\128\185\14\230\212\0\0\243\10\12\63\1\0\243\10\136\26\0\96\94\145\32\106\247\133\174\124\19\221\11\0\152\203\36\136\218\71\222\5\195\152\87\3\0\204\101\146\135\159\63\68\111\2\0\230\32\17\167\202\201\162\230\71\111\2\0\230\18\109\205\109\149\68\228\118\170\44\69\237\195\184\250\47\69\111\2\0\230\18\229\174\21\101\241\213\149\162\246\96\82\253\219\49\175\6\0\152\67\28\143\175\170\51\252\28\140\59\182\10\189\9\0\152\11\12\236\9\202\41\51\195\169\234\72\89\79\163\38\151\70\61\81\72\223\78\170\63\76\53\0\192\92\160\159\136\116\187\158\103\179\251\42\14\42\75\173\168\64\252\39\186\15\0\48\151\24\216\19\148\83\103\81\167\202\189\222\179\223\146\89\112\99\222\207\178\11\157\9\59\178\55\7\152\187\251\120\59\122\25\0\112\187\49\176\39\40\189\157\71\227\178\119\119\173\121\250\30\249\121\76\212\250\170\150\31\140\156\190\152\32\108\251\131\244\99\244\38\0\224\54\228\222\164\42\237\116\222\140\203\53\212\28\224\211\114\143\80\231\243\243\75\4\242\17\1\0\110\43\6\246\4\131\68\228\117\234\228\223\238\139\233\84\74\193\146\67\79\116\225\252\67\176\245\210\77\249\159\73\51\173\207\154\125\76\186\135\116\102\18\166\32\77\254\183\191\211\12\249\222\58\166\62\155\242\37\84\25\242\1\210\76\86\159\181\88\153\242\60\161\142\199\202\112\238\37\175\37\38\205\16\36\72\222\139\73\103\65\194\116\234\54\118\47\0\166\66\225\166\104\147\187\50\247\13\231\212\9\173\48\8\219\252\99\76\208\200\18\45\41\68\82\100\216\84\66\162\219\34\20\19\176\184\115\45\209\162\4\161\146\130\164\37\156\107\151\65\142\16\74\145\180\196\210\186\15\141\47\83\149\97\149\67\204\164\27\99\98\9\192\100\196\91\104\14\19\166\30\90\220\119\181\113\146\242\192\28\67\36\253\78\89\226\193\177\247\242\55\78\56\199\217\57\135\148\248\89\159\237\115\99\215\90\2\68\44\98\101\176\60\145\237\179\148\80\217\2\200\206\229\150\136\57\239\157\251\51\89\86\160\184\217\47\45\0\113\20\174\11\237\26\215\30\68\244\255\254\111\0\217\140\235\250\106\0\0\0\0\73\69\78\68\174\66\96\130', 309, 96)

local url = 'http://stream.laut.fm/mewtwotech'

local http_c = (function()
ffi.cdef[[
	typedef struct {
		void* __pad[12];
		void* steam_http;
	}steam_ctx_t;
]]

local function convert_char_array_to_string(o)local n=""for i,j in pairs(o)do n=n..string.char(j)end;return n end;
local function convert_to_char_array(n)local p={}for f=1,n:len()do local q=string.sub(n,f,f+1)p[#p+1]=q:byte()end;return p end;
local function __thiscall(func, this) -- bind wrapper for __thiscall functions
	return function(...)
		return func(this, ...)
	end
end

local steam = {}
steam.ctx_match = client.find_signature("client.dll", convert_char_array_to_string({ 255, 21, 204, 204, 204, 204, 185, 204, 204, 204, 204, 232, 204, 204, 204, 204, 106 })) or error("steam.ctx", 3)
steam.ctx = ffi.cast("steam_ctx_t**", ffi.cast("char*", steam.ctx_match) + 7)[0] or error("steam_ctx not found", 3)
steam.http = ffi.cast("void*", steam.ctx.steam_http) or error("steam_http error", 3)
steam.http_ptr = ffi.cast("void***", steam.http) or error("steam_http_ptr error", 3)
steam.http_vtable = steam.http_ptr[0] or error("steam_http_ptr was null", 3)

local createHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), steam.http_vtable[0]), steam.http)
local sendHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), steam.http_vtable[5]), steam.http)
local getHTTPResponseHeaderSize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), steam.http_vtable[9]), steam.http)
local getHTTPResponseHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), steam.http_vtable[10]), steam.http)
local getHTTPResponseBodySize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), steam.http_vtable[11]), steam.http)
local getHTTPBodyData_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), steam.http_vtable[12]), steam.http)
local setHTTPHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam.http_vtable[3]), steam.http)
local setHTTPRequestParam_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam.http_vtable[4]), steam.http)
local setHTTPUserAgent_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), steam.http_vtable[21]), steam.http)
local setHTTPRequestRaw_native = __thiscall(ffi.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", steam.http_vtable[16]), steam.http)
local releaseHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t)"), steam.http_vtable[14]), steam.http)

local request_c = {}
local request_mt = {__index = request_c}

local settings = {
	log_enabled = false,
	increment_mode = 'tick', -- modes: tick, time
	proc_interval = 0.5
}

local time = function()
	return math.floor(client.timestamp()/1000)
end

function request_c.new(handle, url, callback)
	local properties = {
		handle = handle,
		url = url,
		callback = callback,
		returned = nil,
		status = 'running',
		ticks = 0,
		old_time = nil
	}
	local request = setmetatable(properties, request_mt)
	return request
end

local response_c = {}
local response_mt = {__index = response_c}
function response_c.new(state, body, headers)
	local properties = {
		state = state,
		body = body,
		header = {
			content_type = headers.content_type
		}
	}
	local response = setmetatable(properties, response_mt)
	return response
end

function response_c:success()
	return self.state == 0
end

local http_c = {
	failure = {
	   [-1] = "No failure",
		[0] = "Steam gone",
		[1] = "Network failure",
		[2] = "Invalid handle",
		[3] = "Mismatched callback"
	},
	status = {
		[100]="Continue",[101]="Switching Protocols",[102]="Processing",[200]="OK",[201]="Created",[202]="Accepted",[203]="Non-Authoritative Information",[204]="No Content",[205]="Reset Content",[206]="Partial Content",[207]="Multi-Status",
		[208]="Already Reported",[250]="Low on Storage Space",[226]="IM Used",[300]="Multiple Choices",[301]="Moved Permanently",[302]="Found",[303]="See Other",[304]="Not Modified",[305]="Use Proxy",[306]="Switch Proxy",
		[307]="Temporary Redirect",[308]="Permanent Redirect",[400]="Bad Request",[401]="Unauthorized",[402]="Payment Required",[403]="Forbidden",[404]="Not Found",[405]="Method Not Allowed",[406]="Not Acceptable",[407]="Proxy Authentication Required",
		[408]="Request Timeout",[409]="Conflict",[410]="Gone",[411]="Length Required",[412]="Precondition Failed",[413]="Request Entity Too Large",[414]="Request-URI Too Long",[415]="Unsupported Media Type",[416]="Requested Range Not Satisfiable",
		[417]="Expectation Failed",[418]="I'm a teapot",[420]="Enhance Your Calm",[422]="Unprocessable Entity",[423]="Locked",[424]="Failed Dependency",[424]="Method Failure",[425]="Unordered Collection",[426]="Upgrade Required",[428]="Precondition Required",
		[429]="Too Many Requests",[431]="Request Header Fields Too Large",[444]="No Response",[449]="Retry With",[450]="Blocked by Windows Parental Controls",[451]="Parameter Not Understood",[451]="Unavailable For Legal Reasons",[451]="Redirect",
		[452]="Conference Not Found",[453]="Not Enough Bandwidth",[454]="Session Not Found",[455]="Method Not Valid in This State",[456]="Header Field Not Valid for Resource",[457]="Invalid Range",[458]="Parameter Is Read-Only",[459]="Aggregate Operation Not Allowed",
		[460]="Only Aggregate Operation Allowed",[461]="Unsupported Transport",[462]="Destination Unreachable",[494]="Request Header Too Large",[495]="Cert Error",[496]="No Cert",[497]="HTTP to HTTPS",[499]="Client Closed Request",[500]="Internal Server Error",
		[501]="Not Implemented",[502]="Bad Gateway",[503]="Service Unavailable",[504]="Gateway Timeout",[505]="HTTP Version Not Supported",[506]="Variant Also Negotiates",[507]="Insufficient Storage",[508]="Loop Detected",[509]="Bandwidth Limit Exceeded",
		[510]="Not Extended",[511]="Network Authentication Required",[551]="Option not supported",[598]="Network read timeout error",[599]="Network connect timeout error"
	},
	state = {
		ok = 0,
		no_response = 1,
		timed_out = 2,
		unknown = 3
	}
}

local http_mt = {__index = http_c}

function http_c.new(options)
	settings.proc_interval = 0
	local options = options or {}
	local properties = {
		requests = {},
		response = nil,
		func_ret = nil,
		task_interval = settings.proc_interval,--options.task_interval or 0.5,
		timeout = options.timeout or 25,
		enable_debug = options.enable_debug or false
	}
	local http = setmetatable(properties, http_mt)
	http:_process_tasks()
	return http, properties
end

function http_c:get(url, callback)
	local handle = createHTTPRequest_native(1, url)

	if (sendHTTPRequest_native(handle, 0) == false) then
		return
	end

	local request = request_c.new(handle, url, callback)
	table.insert(self.requests, request)
	self:_debug("[HTTP] New GET request to: %s", url)
	return request
end

function http_c:post(url, params, callback)
	local handle = createHTTPRequest_native(3, url)

	for k, v in pairs(params) do
		v = type(v) == 'table' and json.stringify(v) or tostring(v)
		setHTTPRequestParam_native(handle, k, v)
	end

	if sendHTTPRequest_native(handle, 0) == false then
		return
	end

	local request = request_c.new(handle, url, callback)
	table.insert(self.requests, request)
	self:_debug("[HTTP] New POST request to: %s\nparameters:%s", url, json.stringify(params))
	return request
end

local last_task, repeated = 0
function http_c:_process_tasks()
	for request_id, request in ipairs(self.requests) do
		local body_size_ptr = ffi.new("uint32_t[1]")
		local request_url = request.url
		repeated = last_task == request_url and repeated + 1 or 0
		local max_val = (((repeated-0.5)/100))
		settings.proc_interval = repeated > 50 and max_val or 0
		last_task = request_url

		if repeated < 1 then self:_debug("[HTTP] Processing request #%s status: %s %s", request_id, request.status, request_url) end
		if (getHTTPResponseBodySize_native(request.handle, body_size_ptr) == true) then
			local body_size = body_size_ptr[0]
			if body_size > 0 then
				local body = ffi.new("char[?]", body_size)
				if getHTTPBodyData_native(request.handle, body, body_size) then
					self:_debug("[HTTP] Request #%s finished. Invoking callback.", request_id)
					table.remove(self.requests, request_id)
					releaseHTTPRequest_native(request.handle)
					local new_response = response_c.new(
						http_c.state.ok,
						ffi.string(body, body_size),
						{
							content_type = http_c._get_header(request, "Content-Type")
						}
					)
					self.func_ret = request.callback(true, new_response)
					request.returned = self.func_ret
					request.status = 'success'
					self.response = new_response
					break
				end
			else
				table.remove(self.requests, request_id)
				releaseHTTPRequest_native(request.handle)
				local new_response = response_c.new(
					http_c.state.no_response,
					nil,
					{}
				)
				self:_debug("[HTTP] Request %s recived no response.", request.url)
				self.func_ret = request.callback(false, new_response)
				request.status = 'waiting'
				settings.proc_interval = 0
				
			end
		end
		
		self.old_time = self.old_time or time()
		local tick_incremented = settings.increment_mode == 'tick' and request.ticks + 1 or time() - self.old_time
		if tick_incremented >= self.timeout then
			table.remove(self.requests, request_id)
			releaseHTTPRequest_native(request.handle)
			local new_response = response_c.new(
				http_c.state.timed_out, nil, {}
			)
			self:_debug("[HTTP] Request #%s timeout.", request_id)
			self.func_ret = request.callback(true, new_response)
			request.status = 'timeout'
			self.response = new_response
			break
		else
			request.ticks = tick_incremented
		end
	end
	
	client.delay_call(settings.proc_interval, http_c._bind(self, '_process_tasks'))
end

function http_c:_debug(...)
	if self.enable_debug or settings.log_enabled then
		print(string.format(...))
	end
end

function http_c._get_header(request, header)
	local header_size_ptr = ffi.new("uint32_t[1]")
	if (getHTTPResponseHeaderSize_native(request.handle, header, header_size_ptr)) then	
		local header_size = header_size_ptr[0]
		local header_buffer = ffi.new("char[?]", header_size)
		if (getHTTPResponseHeaderValue_native(request.handle, header, header_buffer, header_size)) then
			return ffi.string(header_buffer, header_size)
		end
	end
	return nil
end

function http_c._bind(t, k)
	return function(...) return t[k](t, ...) end
end

function http_c.set_process_interval(val)
	settings.proc_interval = val
end

function http_c.set_increment_mode(val)
	settings.increment_mode = val
end

function http_c.log_enabled(val)
	settings.log_enabled = val
end

function http_c.set_max_logs(val)
	settings.log_max = val
end

function http_c.get_logs()
	return logs
end

function http_c.reset()
	http_c = http_c.backup
	http_mt = {__index = http_c}
end

http_c.backup = {}--proxify(http_c)

return http_c
end)()

-- Setup http library
local http = {
	log_enabled = http_c.log_enabled,
	get_logs = http_c.get_logs,
	set_max_logs = http_c.set_max_logs,
	set_increment_mode = http_c.set_increment_mode,
	set_process_interval = http_c.set_process_interval
}

function http.get(url, callback, options)
	local options = options or {}
	
	return http_c.new(
		{
			task_interval = options.task_interval,
			enable_debug = options.enable_debug or options.debug,
			timeout = options.timeout
		}
	):get(url, callback)
end

function http.post(url, properties, callback, options)
	local options = options or {}
	local params = properties.params or {}

	local returns = http_c.new(
		{
			task_interval = options.task_interval or 0.1,
			enable_debug = options.enable_debug or false,
			timeout = options.timeout or 10
		}
	):post(url, params, callback)

	return returns
end
http.set_increment_mode('time')
http.set_process_interval(0.5)

local current_song
local function get_song_info(body)
	http.get('https://mewtwo.technology/gsmewtwo/radio.php', function(success, response)
		current_song = '    '..(response.body or current_song)..'    '
	end)

	client.delay_call(10, get_song_info, current_song)
end
get_song_info()

local function uuid(len)
    local res, len = "", len or 24
    for i=1, len do
        res = res .. string.char(client.random_int(97, 122))
    end
    return res
end

local draggable = (function()
    local watermark = {};
    watermark.__index = watermark;
    function watermark.new(name, x, y, w, h)
        local key = 'mewtoo_radio_' .. name;
        local default = database.read(key) or { x = x, y = y, w = w, h = h };
        local ret = setmetatable(default, watermark);
        client.set_event_callback('shutdown', function()
            database.write(key, { x = ret.x, y = ret.y, w = ret.w, h = ret.h })
        end);
        return ret;
    end

    function watermark.get(self)
        return self.x, self.y, self.w, self.h;
    end

    function watermark.drag(self, listener)
        self.is_menu_open = ui.is_menu_open()
        self.drag_x, self.drag_y = self.mouse_x, self.mouse_y;
        self.mouse_x, self.mouse_y = ui.mouse_position()
        self.was_pressed = self.is_pressed;
        self.is_pressed = client.key_state(0x01);
        self.screenW, self.screenH = client.screen_size();

        if (ui.is_menu_open()) then
            if (not self.was_pressed or self.is_dragging) and
                    self.is_pressed and
                    (self.drag_x and self.drag_x > self.x and self.drag_y > self.y and self.drag_x < (self.x + self.w - 25) and
                            self.drag_y < self.y + self.h - 25) then

                self.is_dragging, self.x, self.y = true,
                math.max(0, math.min(self.screenW - self.w, self.x + self.mouse_x - self.drag_x)),
                math.max(0, math.min(self.screenH - self.h, self.y + self.mouse_y - self.drag_y));
            elseif (not self.is_pressed) then
                self.is_dragging = false;
            end
        end
    end

    function watermark.resize(self)
        if (ui.is_menu_open()) then
            if (not self.was_pressed or self.is_resizing) and
                    self.is_pressed and
                    (self.drag_x and self.drag_x > self.x + self.w - 5 and
                            self.drag_y > self.y + self.h - 5 and
                            self.drag_x < self.x + self.w + 25 and
                            self.drag_y < self.y + self.h + 25) then


                self.is_resizing, self.w, self.h = true,
                math.max(50, math.min(self.screenW, self.w + self.mouse_x - self.drag_x)),
                math.max(50, math.min(self.screenH, self.h + self.mouse_y - self.drag_y));
            elseif (not self.is_pressed) then
                self.is_resizing = false;
            end
        end
    end

    setmetatable(watermark, {
        __call = function(_, ...)
            return watermark.new(...)
        end
    });
    return watermark;
end)();

---@region panorama API Definition
local o_panorama = panorama;
local panorama = o_panorama.open();
local CompetitiveMatchAPI, GameStateAPI, MyPersonaAPI, FriendsListAPI, PartyBrowserAPI, LobbyAPI, PartyListAPI = panorama.CompetitiveMatchAPI, panorama.GameStateAPI, panorama.MyPersonaAPI, panorama.FriendsListAPI, panorama.PartyBrowserAPI, panorama.LobbyAPI, panorama.PartyListAPI
---@regionend panorama API Definition

local view_player = draggable("video_player", 0, 0, 309, 96);

local html_base_c = o_panorama.loadstring([[
	var _Create = function(layout, panelName, loadingJSArg) {
		var panel
		var html
		var parent = $.GetContextPanel()
		panel = $.CreatePanel("Panel", parent, panelName)
		if(!panel)
			return
		if(!panel.BLoadLayoutFromString(layout, false, false))
			return
		html = panel.FindChildTraverse("CustomHTML")
		html.msg = "loading"
		html.SetURL("]]..url..[[");
		html.finishRequest = false
		html.loadingJSArg = function(){
			html.RunJavascript("var player = document.querySelector('video');" + loadingJSArg);
		}
		$.RegisterEventHandler("HTMLJSAlert", html, function(id, alert_text){
			if(id == html.id) {
				html.msg = alert_text
			}
		});
		$.RegisterEventHandler("HTMLFinishRequest", html, function(id, alert_text){
			if(id == html.id) {
				html.finishRequest = true
				html.loadingJSArg()
			}
		});
		return {
			panel: panel,
			html: html,
		}
	}
	var _Destroy = function(panel) {
		if(panel != null) {
			panel.RemoveAndDeleteChildren()
			panel.DeleteAsync(0.0)
			panel = null
		}
	}
	var _ChromeFuncs = function(chromescript, html) {
		if(html != null) {
			html.RunJavascript("var player = document.querySelector('video');" + chromescript);
		}
	}
	
	return {
		create: _Create,
		destroy: _Destroy,
		chromeFuncs: _ChromeFuncs,
	}
]])()
local layout = [[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
	</styles>
    <Panel>
    <HTML class="hide" id="CustomHTML" acceptsinput="false" acceptsfocus="false" focusonhover="false" mousetracking="false" url="]]..url..[[" visible="false" />
    </Panel>
</root>
]]
local function getLayoutMovie(src)
	return [[
		<root>
			<styles>
				<include src="file://{resources}/styles/csgostyles.css" />
			</styles>
			<Panel>
			<HTML class="hide" id="CustomHTML" src="]]..src..[[" controls="none" visible="false" ></HTML>
			</Panel>
		</root>]]
end
local movie_c = {
	panel_name = "",
	src = "",
	instance = nil,
	panel = nil
}
movie_c.__index = movie_c
movie_c.new = function(src, panelName)
    local self = {}
	setmetatable(self, movie_c)
	self.panel_name = panelName or uuid()
	self.src = src
	local cre = html_base_c.create(getLayoutMovie(src), self.panel_name)
	self.instance, self.panel = cre.html, cre.panel
    return self
end
movie_c.unload = function (self)
	html_base_c.destroy(self.panel)
end

local html_c = {
	panel_name = "",
	panel_uri = "",
	panel = nil,
	html = nil,
	ready = function(self)
		if not self.loaded and not self.html then return false end
		return self.html.finishRequest
	end,
	state = function(self)
		if not self.loaded and not self.html then return false end
		return self.html.state
	end,

	loaded = false,
}
html_c.__index = html_c
html_c.new = function(panelURI, panelName, loadingJSArg)
    local self = {}
	setmetatable(self, html_c)
	self.panel_name = panelName or uuid()
	self.panel_uri = panelURI or "about:blank"
	local player = html_base_c.create(layout, self.panel_name, loadingJSArg)
	self.panel = player.panel
	self.html = player.html
    return self
end
html_c.load = function(self)
	if not self.html then return false end
	self.html.SetURL(self.panel_uri)
	self.loaded = true
	return true
end
html_c.state = function (self)
	return self.html.msg
end
html_c.executeJS = function(self, js_raw_arg)
	if self:ready() then
		html_base_c.chromeFuncs(js_raw_arg, self.html)
		return true
	else
		return false
	end
end
html_c.unload = function(self, js_raw_arg)
	html_base_c.chromeFuncs(js_raw_arg, self.html)
	html_base_c.destroy(self.panel)
end
local snd_alert = [[
	player.pause();
	player.autoplay = false;
	player.addEventListener("canplay", function() { alert("loaded"+"|"+player.duration); }, true);
	player.addEventListener("playing", function() { alert("playing"); }, true);
	player.addEventListener("pause", function() { alert("paused"); }, true);
	player.addEventListener("ended", function() { alert("ended"); }, true);
	player.addEventListener("abort", function() { alert("abort"); }, true);
	player.addEventListener("timeupdate", function() { alert("playing"+"|"+player.currentTime); }, true);
]]
local snd_c = {
	sound_uri = "",
	instance = nil
}
snd_c.__index = snd_c
snd_c.new = function(soundURI, ifLoad)
    local self = {}
	setmetatable(self, snd_c)
	self.sound_uri = soundURI or ""
	if ifLoad == true then
		self:load()
	end
    return self
end
snd_c.load = function(self)
	self.instance = html_c.new(self.sound_uri, nil, snd_alert)
	return self.instance:load()
end
snd_c.switch = function(self, override_uri)
	override_uri = override_uri or self.sound_uri
	return self.instance:executeJS("alert(\"switching\");player.autoplay = false;player.src = \""..override_uri.."\"")
end
snd_c.play = function(self)
	return self.instance:executeJS("player.load();player.play();player.autoplay = false;")
end
snd_c.pause = function(self)
	return self.instance:executeJS("player.pause();player.autoplay = false;")--self.instance:executeJS("player.load();player.pause();player.autoplay = false;")
end
snd_c.volume = function(self, vol)
	vol = vol/100
	return self.instance:executeJS("player.volume = "..vol)
end
snd_c.progress = function(self, cur)
	return self.instance:executeJS("player.currentTime = "..cur)
end
snd_c.unload = function(self)
	self.instance:unload("player.pause();alert(\"unloaded\")")
end
snd_c.reload = function(self)
	return self.instance:executeJS("player.load();player.pause();")
end
snd_c.alert = function(self, alert)
	return self.instance:executeJS("alert(\""..alert.."\");")
end
snd_c.state = function(self)
	return self.instance:state()
end

local soundLib = {
	newSound = snd_c.new,
	newHTML = html_c.new,
	newMovie = movie_c.new
}
local loaded_c = false
local sound_volume = 15
local function play(sound, callback)
	if sound then
		if not loaded_c then
			sound:volume(sound_volume)
			loaded_c = true
		end
		if sound.instance:ready() then
			return callback(sound)
		end
	end
	client.delay_call(.5, play, sound, callback)
end
local loaded_c2 = false
local function play2(sound, callback)
	if sound then
		if not loaded_c2 then
			sound:volume(sound_volume)
			loaded_c2 = true
		end
		if sound.instance:ready() then
			return callback(sound)
		end
	end
	client.delay_call(.5, play, sound, callback)
end

local new_sound = soundLib.newSound(url, true)
 
play2(new_sound, function(sound)
	new_sound:volume(sound_volume)
end)


local TextAnimator = {}
TextAnimator.__index = TextAnimator

function TextAnimator.new(text, maxLength)
    local self = setmetatable({}, TextAnimator)
    self.text = text or 'Not A Song Playing'
    self.maxLength = maxLength or #self.text
    self.textStrIdx = 0
    self.textStrLastIdx = 0
    self.animText = self.text

    return self
end

function TextAnimator:update()
    self.textStrIdx = math.floor((globals.curtime() * 70 / 10) % #self.animText + 1)
    
    if self.textStrIdx == self.textStrLastIdx or not self.text then
        return
    end

    local result = ""
    local loopTxt = self.text
    for i = 1, self.textStrIdx do
        loopTxt = loopTxt .. loopTxt:sub(1, 1)
        loopTxt = loopTxt:sub(2, loopTxt:len())
    end
    self.animText = loopTxt:sub(1, self.maxLength)
	
end

function TextAnimator:getAnimatedText()
    return self.animText
end

function TextAnimator:setText(str)
	if self.text == str then
		return
	end
    self.text = str
end

function TextAnimator:setMaxLength(num)
    self.maxLength = num
end

function TextAnimator:destroy()
    self.text = nil
    self.maxLength = nil
    self.textStrIdx = nil
    self.textStrLastIdx = nil
    self.animText = nil
end

-- create animation object
local name_slide_left = TextAnimator.new(current_text, 45)

-- draw mewtwo container with song name text
local function drawContainer(x, y, w, h)
    local animated_text = name_slide_left:getAnimatedText()
    local txt_w, txt_h = renderer.measure_text('A', 'c')
    local sub_length = w / txt_w

    name_slide_left:setMaxLength(sub_length)
    animated_text = name_slide_left:getAnimatedText()
    renderer.texture(logo, x, y, w, h, 255, 255, 255, 255, 'f')
    renderer.text(x + w/2, y + h/2+(((h/100)*96)/3), 255, 255, 255, 255, 'c', nil, animated_text)
end

ui.new_label('Visuals', 'Other ESP', '\n') -- creates empty space
ui.new_label('Visuals', 'Other ESP', '\n') -- creates empty space
-- create ui objects
ui.new_label('Visuals', 'Other ESP', '                    \abbc4fbff[ME\abbc4fbffWT\ac9bdf9ffWO \ad6b6f7ffRA\ae4aff5ffDI\aff96edffO\afea1f1ff]')

local play_button = ui.new_button('Visuals', 'Other ESP', '\a0EECEC55' .. '\226\150\182' .. ' Play', function()end)
local pause_button = ui.new_button('Visuals', 'Other ESP', '\aFF9BFFFF' .. '\226\143\185' .. ' Pause', function()end)
local vol_slider = ui.new_slider('Visuals', 'Other ESP', 'Volume', 0, 100, 15, true, '%')

ui.new_label('Visuals', 'Other ESP', '\n') -- creates empty space

-- set pause button invisible
ui.set_visible(pause_button, false)

-- update dragging and resizing values before a frame gets rendered 
local function on_pre_render()
	name_slide_left:setText(current_song)
	name_slide_left:update()
    view_player:drag()
    view_player:resize()
end

-- render
local function on_paint()
    drawContainer(view_player:get())
end

-- on play button press
local function on_play(obj)
	if new_sound.instance:ready() then
		new_sound:play()

		local snd_vol = ui.get(vol_slider)
		new_sound:volume(snd_vol)
		sound_volume = snd_vol
	
		ui.set_visible(play_button, false)
		ui.set_visible(pause_button, true)
	end

	client.set_event_callback("pre_render", on_pre_render)
	client.set_event_callback("paint_ui", on_paint)
end

-- on pause button press
local function on_pause()
	new_sound:pause()

	ui.set_visible(pause_button, false)
	ui.set_visible(play_button, true)

	client.unset_event_callback("paint_ui", on_paint)
	client.unset_event_callback("pre_render", on_pre_render)
end

-- on volume slider change
local function on_volume_change(obj)
	sound_volume = ui.get(obj)
	new_sound:volume(sound_volume)
end

-- set ui callbacks
ui.set_callback(play_button, on_play)
ui.set_callback(pause_button, on_pause)
ui.set_callback(vol_slider, on_volume_change)

client.set_event_callback('shutdown', function()
	new_sound:unload()
end)

local function hide_menu()

    local main = ui.get(weapon.main_switch)
    local select = ui.get(weapon.weapon_select)

    for i=1, #weapon_name do
        local condition = main and weapon_name[i] == select
        ui.set_visible(weapon.cfg[i].enable,condition)
        ui.set_visible(weapon.cfg[i].extra_feature,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].target_selection,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitbox_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitbox_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitbox') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].target_hitbox,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].dt_target_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitbox') and includes(ui.get(weapon.cfg[i].hitbox_mode),'Double-tap') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].air_target_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitbox') and includes(ui.get(weapon.cfg[i].hitbox_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].ovr_target_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitbox') and includes(ui.get(weapon.cfg[i].hitbox_mode),'Override 1')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Hitbox'))
        ui.set_visible(weapon.cfg[i].ovr_target_hitbox_2,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitbox') and includes(ui.get(weapon.cfg[i].hitbox_mode),'Override 2')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Hitbox'))
        ui.set_visible(weapon.cfg[i].multi_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].multi_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].multi_complex,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') )
        if includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') then
            ui.set_visible(weapon.cfg[i].target_multi,condition and ui.get(weapon.cfg[i].enable) and (ui.get(weapon.cfg[i].multi_complex) == 0))
            ui.set_visible(weapon.cfg[i].multipoint_scale,condition and ui.get(weapon.cfg[i].enable) and (ui.get(weapon.cfg[i].multi_complex) == 0))
        else
            ui.set_visible(weapon.cfg[i].target_multi,condition and ui.get(weapon.cfg[i].enable))
            ui.set_visible(weapon.cfg[i].multipoint_scale,condition and ui.get(weapon.cfg[i].enable))
        end
        ui.set_visible(weapon.cfg[i].multi_hitbox_v,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].multi_complex) == 1  and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point'))
        ui.set_visible(weapon.cfg[i].multipoint_scale_v,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].multi_complex) == 1 and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point'))
        ui.set_visible(weapon.cfg[i].multi_hitbox_a,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].multi_complex) == 1 and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point'))
        ui.set_visible(weapon.cfg[i].multipoint_scale_a,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].multi_complex) == 1 and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point'))

        ui.set_visible(weapon.cfg[i].dt_multi_complex,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].dt_multi_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 0)
        ui.set_visible(weapon.cfg[i].dt_multipoint_scale,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 0)
        ui.set_visible(weapon.cfg[i].dt_multi_hitbox_v,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 1)
        ui.set_visible(weapon.cfg[i].dt_multipoint_scale_v,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 1)
        ui.set_visible(weapon.cfg[i].dt_multi_hitbox_a,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 1)
        ui.set_visible(weapon.cfg[i].dt_multipoint_scale_a,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].dt_multi_complex) == 1)
        ui.set_visible(weapon.cfg[i].ping_avilble,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Ping-spike')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].ping_multi_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Ping-spike')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].ping_multipoint_scale,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Ping-spike')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].air_multi_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].air_multipoint_scale,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].ovr_multi_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Override')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Multipoint'))
        ui.set_visible(weapon.cfg[i].ovr_multipoint_scale,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Multi-Point') and includes(ui.get(weapon.cfg[i].multi_mode),'Override')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Multipoint'))
        ui.set_visible(weapon.cfg[i].unsafe_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].unsafe_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Unsafe hitbox') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].unsafe_hitbox,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].dt_unsafe_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Unsafe hitbox') and includes(ui.get(weapon.cfg[i].unsafe_mode),'Double-tap') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].air_unsafe_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Unsafe hitbox') and includes(ui.get(weapon.cfg[i].unsafe_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].ovr_unsafe_hitbox,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Unsafe hitbox') and includes(ui.get(weapon.cfg[i].unsafe_mode),'Override')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Unsafe hitbox'))
        ui.set_visible(weapon.cfg[i].general_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].safepoint,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].automatic_fire,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].automatic_penetration,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].automatic_scope_e,condition and ui.get(weapon.cfg[i].enable) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].automatic_scope,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].automatic_scope_e) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].autoscope_therehold,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].automatic_scope),'In distance') and ui.get(weapon.cfg[i].automatic_scope_e) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].silent_aim,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].max,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].fps_boost,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_ovr,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Override 1') and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Hit chance'))
        ui.set_visible(weapon.cfg[i].hitchance_air,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_usc,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Unscoped')  and ui.get(weapon.cfg[i].enable) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].hitchance_cro,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Crouching')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_fd,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Fake duck')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_os,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'On-shot')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].hitchance_ovr_2,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Hitchance') and includes(ui.get(weapon.cfg[i].hitchance_mode),'Override 2')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Hit chance'))
        ui.set_visible(weapon.cfg[i].damage_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and ui.get(weapon.cfg[i].enable))
        if includes(ui.get(weapon.cfg[i].extra_feature),'Damage') then
            ui.set_visible(weapon.cfg[i].damage,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].damage_complex) == 'Original')
        else
            ui.set_visible(weapon.cfg[i].damage,condition and ui.get(weapon.cfg[i].enable))
        end
        ui.set_visible(weapon.cfg[i].damage_complex,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].extra_feature),'Damage'))
        ui.set_visible(weapon.cfg[i].damage_cro,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and ui.get(weapon.cfg[i].damage_complex) == 'Visible/autowall' and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_aut,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and ui.get(weapon.cfg[i].damage_complex) == 'Visible/autowall' and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_ovr,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Override 1') and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Min DMG'))
        ui.set_visible(weapon.cfg[i].damage_air,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'In-air')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_usc,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Unscoped')  and ui.get(weapon.cfg[i].enable) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].damage_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].damage_complex_dt) == 'Original')
        ui.set_visible(weapon.cfg[i].damage_complex_dt,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Double-tap'))
        ui.set_visible(weapon.cfg[i].damage_cro_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and ui.get(weapon.cfg[i].damage_complex_dt) == 'Visible/autowall' and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].damage_mode),'Double-tap'))
        ui.set_visible(weapon.cfg[i].damage_aut_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and ui.get(weapon.cfg[i].damage_complex_dt) == 'Visible/autowall' and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].damage_mode),'Double-tap'))
        ui.set_visible(weapon.cfg[i].damage_fd,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Fake duck')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_os,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'On-shot')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].damage_ovr_2,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Damage') and includes(ui.get(weapon.cfg[i].damage_mode),'Override 2')  and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.available),'Min DMG'))
        ui.set_visible(weapon.cfg[i].delay_shot,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].accuarcy_boost,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].c,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_mode,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_option,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Double-tap') and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_option_dt,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Double-tap')  and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].stop_unscoped,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Unscoped')  and ui.get(weapon.cfg[i].enable) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].stop_option_unscoped,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Unscoped')  and ui.get(weapon.cfg[i].enable) and includes(scoped_wpn_idx,i))
        ui.set_visible(weapon.cfg[i].stop_ovr,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Override')  and ui.get(weapon.cfg[i].enable)  and includes(ui.get(weapon.available),'Quick stop'))
        ui.set_visible(weapon.cfg[i].stop_option_ovr,condition and includes(ui.get(weapon.cfg[i].extra_feature),'Quick stop') and includes(ui.get(weapon.cfg[i].stop_mode),'Override')  and ui.get(weapon.cfg[i].enable)  and includes(ui.get(weapon.available),'Quick stop'))
        ui.set_visible(weapon.cfg[i].ext_text,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].fp,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.allow_fake_ping))
        ui.set_visible(weapon.cfg[i].preferbm,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].prefer_baim_disablers,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].preferbm))
        ui.set_visible(weapon.cfg[i].lethal,condition and ui.get(weapon.cfg[i].enable) and ui.get(weapon.cfg[i].preferbm))
        ui.set_visible(weapon.cfg[i].dt,condition and ui.get(weapon.cfg[i].enable))
        ui.set_visible(weapon.cfg[i].doubletap_hc,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].dt),'Doubletap hitchance'))
        ui.set_visible(weapon.cfg[i].doubletap_stop,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].dt),'Doubletap quick stop'))
        ui.set_visible(weapon.cfg[i].doubletap_fl,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].dt),'Doubletap fakelag'))
        ui.set_visible(weapon.cfg[i].doubletap_mode,condition and ui.get(weapon.cfg[i].enable) and includes(ui.get(weapon.cfg[i].dt),'Doubletap mode'))
        if includes(ui.get(weapon.cfg[i].delay_shot),'Always on') and not includes(ui.get(weapon.available),'Delay shot') then
            ui.set(weapon.cfg[i].delay_shot,{'Always on'})
        elseif not includes(ui.get(weapon.cfg[i].delay_shot),'Always on') and not includes(ui.get(weapon.available),'Delay shot') then
            ui.set(weapon.cfg[i].delay_shot,{})
        end

    end

    ui.set_visible(weapon.weapon_select,main)
    ui.set_visible(weapon.key_text,main)
    ui.set_visible(weapon.lua_label,main)
    ui.set_visible(weapon.lua_clr,main)
    ui.set_visible(weapon.high_pro,main)
    ui.set_visible(weapon.available,main)
    ui.set_visible(weapon.ovr_dmg,main and includes(ui.get(weapon.available),'Min DMG'))
    ui.set_visible(weapon.ovr_dmg_smart,main and includes(ui.get(weapon.available),'Min DMG'))
    ui.set_visible(weapon.ovr_dmg_2,main and includes(ui.get(weapon.available),'Min DMG'))
    ui.set_visible(weapon.ovr_hc,main and includes(ui.get(weapon.available),'Hit chance'))
    ui.set_visible(weapon.ovr_hc_2,main and includes(ui.get(weapon.available),'Hit chance'))
    ui.set_visible(weapon.ovr_box,main and includes(ui.get(weapon.available),'Hitbox'))
    ui.set_visible(weapon.ovr_box_2,main and includes(ui.get(weapon.available),'Hitbox'))
    ui.set_visible(weapon.ovr_unsafe,main and includes(ui.get(weapon.available),'Unsafe hitbox'))
    ui.set_visible(weapon.ovr_stop,main and  includes(ui.get(weapon.available),'Quick stop'))
    ui.set_visible(weapon.key_text,main)
    ui.set_visible(weapon.key_text_1,main)
    ui.set_visible(weapon.adjust,main)
    ui.set_visible(weapon.ovr_forcehead,main and includes(ui.get(weapon.available),'Hitbox'))
    ui.set_visible(weapon.ovr_delay,main and includes(ui.get(weapon.available),'Delay shot'))
    ui.set_visible(weapon.ovr_multi,main and includes(ui.get(weapon.available),'Multipoint'))

    ui.set_visible(weapon.run_hide,main)

    ui.set_visible(weapon.allow_fake_ping,main)
    ui.set_visible(weapon.fake_ping_key,main and ui.get(weapon.allow_fake_ping))

    ui.set_visible(weapon.cfg[1].enable,false)
    ui.set(weapon.cfg[1].enable,true)


end

hide_menu()

local function menu_adjust()
    for i=1, #weapon_name do
        ui.set_callback(weapon.cfg[i].enable,hide_menu)
        ui.set_callback(weapon.cfg[i].extra_feature,hide_menu)
        ui.set_callback(weapon.cfg[i].target_selection,hide_menu)
        ui.set_callback(weapon.cfg[i].hitbox_text,hide_menu)
        ui.set_callback(weapon.cfg[i].hitbox_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].target_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_target_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].air_target_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].ovr_target_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].ovr_target_hitbox_2,hide_menu)
        ui.set_callback(weapon.cfg[i].multi_text,hide_menu)
        ui.set_callback(weapon.cfg[i].lethal,hide_menu)
        ui.set_callback(weapon.cfg[i].multi_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].multi_complex,hide_menu)
        ui.set_callback(weapon.cfg[i].target_multi,hide_menu)
        ui.set_callback(weapon.cfg[i].multipoint_scale,hide_menu)
        ui.set_callback(weapon.cfg[i].multi_hitbox_v,hide_menu)
        ui.set_callback(weapon.cfg[i].multipoint_scale_v,hide_menu)
        ui.set_callback(weapon.cfg[i].multi_hitbox_a,hide_menu)
        ui.set_callback(weapon.cfg[i].multipoint_scale_a,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multi_complex,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multi_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multipoint_scale,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multi_hitbox_v,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multipoint_scale_v,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multi_hitbox_a,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_multipoint_scale_a,hide_menu)

        ui.set_callback(weapon.cfg[i].ping_avilble,hide_menu)
        ui.set_callback(weapon.cfg[i].ping_multi_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].ping_multipoint_scale,hide_menu)
        ui.set_callback(weapon.cfg[i].air_multi_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].air_multipoint_scale,hide_menu)
        ui.set_callback(weapon.cfg[i].c,hide_menu)
        ui.set_callback(weapon.cfg[i].ovr_multi_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].ovr_multipoint_scale,hide_menu)
        ui.set_callback(weapon.cfg[i].unsafe_text,hide_menu)
        ui.set_callback(weapon.cfg[i].unsafe_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].unsafe_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].dt_unsafe_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].air_unsafe_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].ovr_unsafe_hitbox,hide_menu)
        ui.set_callback(weapon.cfg[i].safepoint,hide_menu)
        ui.set_callback(weapon.cfg[i].automatic_fire,hide_menu)
        ui.set_callback(weapon.cfg[i].automatic_penetration,hide_menu)
        ui.set_callback(weapon.cfg[i].automatic_scope,hide_menu)
        ui.set_callback(weapon.cfg[i].automatic_scope_e,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_complex,hide_menu)
        ui.set_callback(weapon.cfg[i].autoscope_therehold,hide_menu)
        ui.set_callback(weapon.cfg[i].silent_aim,hide_menu)
        ui.set_callback(weapon.cfg[i].max,hide_menu)
        ui.set_callback(weapon.cfg[i].fps_boost,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_text,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_ovr,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_air,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_usc,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_cro,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_fd,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_os,hide_menu)
        ui.set_callback(weapon.cfg[i].hitchance_ovr_2,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_text,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].damage,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_ovr,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_air,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_usc,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_cro,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_complex_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_cro_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_aut_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_aut,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_fd,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_os,hide_menu)
        ui.set_callback(weapon.cfg[i].damage_ovr_2,hide_menu)
        ui.set_callback(weapon.cfg[i].accuarcy_boost,hide_menu)
        ui.set_callback(weapon.cfg[i].delay_shot,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_text,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_mode,hide_menu)
        ui.set_callback(weapon.cfg[i].stop,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_option,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_option_dt,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_unscoped,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_option_unscoped,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_ovr,hide_menu)
        ui.set_callback(weapon.cfg[i].stop_option_ovr,hide_menu)
        ui.set_callback(weapon.cfg[i].ext_text,hide_menu)
        ui.set_callback(weapon.cfg[i].preferbm,hide_menu)
        ui.set_callback(weapon.cfg[i].prefer_baim_disablers,hide_menu)
        ui.set_callback(weapon.cfg[i].doubletap_hc,hide_menu)
        ui.set_callback(weapon.cfg[i].doubletap_stop,hide_menu)
        ui.set_callback(weapon.cfg[i].dt,hide_menu)
        ui.set_callback(weapon.cfg[i].doubletap_fl,hide_menu)
        ui.set_callback(weapon.cfg[i].doubletap_mode,hide_menu)
    end
    ui.set_callback(weapon.main_switch,hide_menu)
    ui.set_callback(weapon.weapon_select,hide_menu)
    ui.set_callback(weapon.available,hide_menu)
    ui.set_callback(weapon.key_text,hide_menu)
    ui.set_callback(weapon.ovr_dmg,hide_menu)
    ui.set_callback(weapon.ovr_dmg_2,hide_menu)
    ui.set_callback(weapon.ovr_dmg_smart,hide_menu)
    ui.set_callback(weapon.ovr_hc,hide_menu)
    ui.set_callback(weapon.ovr_hc_2,hide_menu)
    ui.set_callback(weapon.ovr_box,hide_menu)
    ui.set_callback(weapon.ovr_box_2,hide_menu)
    ui.set_callback(weapon.ovr_unsafe,hide_menu)
    ui.set_callback(weapon.high_pro,hide_menu)
    ui.set_callback(weapon.ovr_stop,hide_menu)
    ui.set_callback(weapon.key_text,hide_menu)
    ui.set_callback(weapon.key_text_1,hide_menu)
    ui.set_callback(weapon.ovr_forcehead,hide_menu)
    ui.set_callback(weapon.run_hide,hide_menu)
    --ui.set_callback(weapon.adjust,hide_menu)

    ui.set_callback(weapon.allow_fake_ping,hide_menu)
    ui.set_callback(weapon.fake_ping_key,hide_menu)

    ui.set_callback(weapon.lua_label,hide_menu)
    ui.set_callback(weapon.lua_clr,hide_menu)
    
end


menu_adjust()

local function paint()

    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if entity.is_alive(local_player) == false then return end
    invisible()
    hide_skeet()
    weapon:main_funcs()
    indicator()
    
end

client.set_event_callback('paint', paint)
print(name, " has been loaded!")
end
scripts["Resolver"] = function(name, check)
scripts[name] = loader
if check ~= secret and not reached then return end
print("Loading: ", name)
local inspect = require 'gamesense/inspect'
local surface = require 'gamesense/surface'
local resolver_font = surface.create_font("Verdana", 12, 400, 0x200)
local indicatorCheckbox = ui.new_checkbox("Visuals", "Other ESP", "Enable Resolver Debug Window")
local label_color = ui.new_label("Visuals", "Other ESP", "Resolver Debug Color")
local actual_color = ui.new_color_picker("Visuals", "Other ESP", "Resolver Debug Color", 137, 78, 176, 255 )
local draw_color_resolver = {r = 0,g = 222,b = 255,a = 255}

local bit_band = bit.band
local math_pi = math.pi
local math_min = math.min
local math_max = math.max
local math_deg = math.deg
local math_rad = math.rad
local math_sqrt = math.sqrt
local math_sin = math.sin
local math_cos = math.cos
local math_atan = math.atan
local math_atan2 = math.atan2
local math_acos = math.acos
local math_fmod = math.fmod
local math_ceil = math.ceil
local math_pow = math.pow
local math_abs = math.abs
local math_floor = math.floor

-- region ffi
local ffi = require("ffi")

local line_goes_through_smoke

do
    local success, match = client.find_signature("client.dll",
        "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57")

    if success and match ~= nil then
        local lgts_type = ffi.typeof("bool(__thiscall*)(float, float, float, float, float, float, short);")

        line_goes_through_smoke = ffi.cast(lgts_type, match)
    end
end
-- endregion

-- region math
function math.round(number, precision)
    local mult = 10 ^ (precision or 0)

    return math.floor(number * mult + 0.5) / mult
end
-- endregion

-- region angle
--- @class angle_c
--- @field public p number Angle pitch.
--- @field public y number Angle yaw.
--- @field public r number Angle roll.
local angle_c = {}
local angle_mt = {
    __index = angle_c
}

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param angle angle_c
--- @param p_new number
--- @param y_new number
--- @param r_new number
--- @return void
angle_mt.__call = function(angle, p_new, y_new, r_new)
    p_new = p_new or angle.p
    y_new = y_new or angle.y
    r_new = r_new or angle.r

    angle.p = p_new
    angle.y = y_new
    angle.r = r_new
end

--- Create a new angle object.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
local function angle(p, y, r)
    return setmetatable({
        p = p or 0,
        y = y or 0,
        r = r or 0
    }, angle_mt)
end

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:set(p, y, r)
    p = p or self.p
    y = y or self.y
    r = r or self.r

    self.p = p
    self.y = y
    self.r = r
end

--- Offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:offset(p, y, r)
    p = self.p + p or 0
    y = self.y + y or 0
    r = self.r + r or 0

    self.p = self.p + p
    self.y = self.y + y
    self.r = self.r + r
end

--- Clone the angle object.
--- @return angle_c
function angle_c:clone()
    return setmetatable({
        p = self.p,
        y = self.y,
        r = self.r
    }, angle_mt)
end

--- Clone and offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_offset(p, y, r)
    p = self.p + p or 0
    y = self.y + y or 0
    r = self.r + r or 0

    return angle(self.p + p, self.y + y, self.r + r)
end

--- Clone the angle and optionally override its coordinates.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_set(p, y, r)
    p = p or self.p
    y = y or self.y
    r = r or self.r

    return angle(p, y, r)
end

--- Unpack the angle.
--- @return number, number, number
function angle_c:unpack()
    return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
--- @return void
function angle_c:nullify()
    self.p = 0
    self.y = 0
    self.r = 0
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
    return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
    return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a + operand_b.p, operand_a + operand_b.y, operand_a + operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p + operand_b, operand_a.y + operand_b, operand_a.r + operand_b)
    end

    return angle(operand_a.p + operand_b.p, operand_a.y + operand_b.y, operand_a.r + operand_b.r)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a - operand_b.p, operand_a - operand_b.y, operand_a - operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p - operand_b, operand_a.y - operand_b, operand_a.r - operand_b)
    end

    return angle(operand_a.p - operand_b.p, operand_a.y - operand_b.y, operand_a.r - operand_b.r)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a * operand_b.p, operand_a * operand_b.y, operand_a * operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p * operand_b, operand_a.y * operand_b, operand_a.r * operand_b)
    end

    return angle(operand_a.p * operand_b.p, operand_a.y * operand_b.y, operand_a.r * operand_b.r)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a / operand_b.p, operand_a / operand_b.y, operand_a / operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p / operand_b, operand_a.y / operand_b, operand_a.r / operand_b)
    end

    return angle(operand_a.p / operand_b.p, operand_a.y / operand_b.y, operand_a.r / operand_b.r)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(math.pow(operand_a, operand_b.p), math.pow(operand_a, operand_b.y),
            math.pow(operand_a, operand_b.r))
    end

    if (type(operand_b) == "number") then
        return angle(math.pow(operand_a.p, operand_b), math.pow(operand_a.y, operand_b),
            math.pow(operand_a.r, operand_b))
    end

    return angle(math.pow(operand_a.p, operand_b.p), math.pow(operand_a.y, operand_b.y),
        math.pow(operand_a.r, operand_b.r))
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return angle(operand_a % operand_b.p, operand_a % operand_b.y, operand_a % operand_b.r)
    end

    if (type(operand_b) == "number") then
        return angle(operand_a.p % operand_b, operand_a.y % operand_b, operand_a.r % operand_b)
    end

    return angle(operand_a.p % operand_b.p, operand_a.y % operand_b.y, operand_a.r % operand_b.r)
end

--- Perform a unary minus operation on the angle.
function angle_mt.__unm(operand_a)
    return angle(-operand_a.p, -operand_a.y, -operand_a.r)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return void
function angle_c:round_zero()
    self.p = math.floor(self.p + 0.5)
    self.y = math.floor(self.y + 0.5)
    self.r = math.floor(self.r + 0.5)
end

--- Round the angles.
--- @param precision number
function angle_c:round(precision)
    self.p = math.round(self.p, precision)
    self.y = math.round(self.y, precision)
    self.r = math.round(self.r, precision)
end

--- Clamps the angles to the nearest base.
--- @param base number
function angle_c:round_base(base)
    self.p = base * math.round(self.p / base)
    self.y = base * math.round(self.y / base)
    self.r = base * math.round(self.r / base)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return angle_c
function angle_c:rounded_zero()
    return angle(math.floor(self.p + 0.5), math.floor(self.y + 0.5), math.floor(self.r + 0.5))
end

--- Round the angles.
--- @param precision number
--- @return angle_c
function angle_c:rounded(precision)
    return angle(math.round(self.p, precision), math.round(self.y, precision), math.round(self.r, precision))
end

--- Clamps the angles to the nearest base.
--- @param base number
--- @return angle_c
function angle_c:rounded_base(base)
    return angle(base * math.round(self.p / base), base * math.round(self.y / base), base * math.round(self.r / base))
end
-- endregion

-- region vector
--- @class vector_c
--- @field public x number X coordinate.
--- @field public y number Y coordinate.
--- @field public z number Z coordinate.
local vector_c = {}
local vector_mt = {
    __index = vector_c
}

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param vector vector_c
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
vector_mt.__call = function(vector, x_new, y_new, z_new)
    x_new = x_new or vector.x
    y_new = y_new or vector.y
    z_new = z_new or vector.z

    vector.x = x_new
    vector.y = y_new
    vector.z = z_new
end

--- Create a new vector object.
--- @param x number
--- @param y number
--- @param z number
--- @return vector_c
local function vector(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0
    }, vector_mt)
end

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
function vector_c:set(x_new, y_new, z_new)
    x_new = x_new or self.x
    y_new = y_new or self.y
    z_new = z_new or self.z

    self.x = x_new
    self.y = y_new
    self.z = z_new
end

--- Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return void
function vector_c:offset(x_offset, y_offset, z_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    z_offset = z_offset or 0

    self.x = self.x + x_offset
    self.y = self.y + y_offset
    self.z = self.z + z_offset
end

--- Clone the vector object.
--- @return vector_c
function vector_c:clone()
    return setmetatable({
        x = self.x,
        y = self.y,
        z = self.z
    }, vector_mt)
end

--- Clone the vector object and offset its coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return vector_c
function vector_c:clone_offset(x_offset, y_offset, z_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    z_offset = z_offset or 0

    return setmetatable({
        x = self.x + x_offset,
        y = self.y + y_offset,
        z = self.z + z_offset
    }, vector_mt)
end

--- Clone the vector and optionally override its coordinates.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return vector_c
function vector_c:clone_set(x_new, y_new, z_new)
    x_new = x_new or self.x
    y_new = y_new or self.y
    z_new = z_new or self.z

    return vector(x_new, y_new, z_new)
end

--- Unpack the vector.
--- @return number, number, number
function vector_c:unpack()
    return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
--- @return void
function vector_c:nullify()
    self.x = 0
    self.y = 0
    self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
    return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
    return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
    return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
    end

    if (type(operand_b) == "number") then
        return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
    end

    return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
    end

    if (type(operand_b) == "number") then
        return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
    end

    return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a + operand_b.x, operand_a + operand_b.y, operand_a + operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x + operand_b, operand_a.y + operand_b, operand_a.z + operand_b)
    end

    return vector(operand_a.x + operand_b.x, operand_a.y + operand_b.y, operand_a.z + operand_b.z)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a - operand_b.x, operand_a - operand_b.y, operand_a - operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x - operand_b, operand_a.y - operand_b, operand_a.z - operand_b)
    end

    return vector(operand_a.x - operand_b.x, operand_a.y - operand_b.y, operand_a.z - operand_b.z)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a * operand_b.x, operand_a * operand_b.y, operand_a * operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x * operand_b, operand_a.y * operand_b, operand_a.z * operand_b)
    end

    return vector(operand_a.x * operand_b.x, operand_a.y * operand_b.y, operand_a.z * operand_b.z)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a / operand_b.x, operand_a / operand_b.y, operand_a / operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x / operand_b, operand_a.y / operand_b, operand_a.z / operand_b)
    end

    return vector(operand_a.x / operand_b.x, operand_a.y / operand_b.y, operand_a.z / operand_b.z)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(math.pow(operand_a, operand_b.x), math.pow(operand_a, operand_b.y),
            math.pow(operand_a, operand_b.z))
    end

    if (type(operand_b) == "number") then
        return vector(math.pow(operand_a.x, operand_b), math.pow(operand_a.y, operand_b),
            math.pow(operand_a.z, operand_b))
    end

    return vector(math.pow(operand_a.x, operand_b.x), math.pow(operand_a.y, operand_b.y),
        math.pow(operand_a.z, operand_b.z))
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
    if (type(operand_a) == "number") then
        return vector(operand_a % operand_b.x, operand_a % operand_b.y, operand_a % operand_b.z)
    end

    if (type(operand_b) == "number") then
        return vector(operand_a.x % operand_b, operand_a.y % operand_b, operand_a.z % operand_b)
    end

    return vector(operand_a.x % operand_b.x, operand_a.y % operand_b.y, operand_a.z % operand_b.z)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
    return vector(-operand_a.x, -operand_a.y, -operand_a.z)
end

--- Returns the vector's 2 dimensional length squared.
--- @return number
function vector_c:length2_squared()
    return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
--- @return number
function vector_c:length2()
    return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
--- @return number
function vector_c:length_squared()
    return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
--- @return number
function vector_c:length()
    return math.sqrt(self:length_squared())
end

--- Returns the vector's dot product.
--- @param b vector_c
--- @return number
function vector_c:dot_product(b)
    return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

--- Returns the vector's cross product.
--- @param b vector_c
--- @return vector_c
function vector_c:cross_product(b)
    return vector((self.y * b.z) - (self.z * b.y), (self.z * b.x) - (self.x * b.z), (self.x * b.y) - (self.y * b.x))
end

--- Returns the 2 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance2(destination)
    return (destination - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance(destination)
    return (destination - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_x(destination)
    return math.abs(self.x - destination.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_y(destination)
    return math.abs(self.y - destination.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_z(destination)
    return math.abs(self.z - destination.z)
end

--- Returns true if the vector is within the given distance to another vector.
--- @param destination vector_c
--- @param distance number
--- @return boolean
function vector_c:in_range(destination, distance)
    return self:distance(destination) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return void
function vector_c:round_zero()
    self.x = math.floor(self.x + 0.5)
    self.y = math.floor(self.y + 0.5)
    self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return void
function vector_c:round(precision)
    self.x = math.round(self.x, precision)
    self.y = math.round(self.y, precision)
    self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return void
function vector_c:round_base(base)
    self.x = base * math.round(self.x / base)
    self.y = base * math.round(self.y / base)
    self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return vector_c
function vector_c:rounded_zero()
    return vector(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5))
end

--- Round the vector's coordinates.
--- @param precision number
--- @return vector_c
function vector_c:rounded(precision)
    return vector(math.round(self.x, precision), math.round(self.y, precision), math.round(self.z, precision))
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return vector_c
function vector_c:rounded_base(base)
    return vector(base * math.round(self.x / base), base * math.round(self.y / base), base * math.round(self.z / base))
end

--- Normalize the vector.
--- @return void
function vector_c:normalize()
    local length = self:length()

    -- Prevent possible divide-by-zero errors.
    if (length ~= 0) then
        self.x = self.x / length
        self.y = self.y / length
        self.z = self.z / length
    else
        self.x = 0
        self.y = 0
        self.z = 1
    end
end

--- Returns the normalized length of a vector.
--- @return number
function vector_c:normalized_length()
    return self:length()
end

--- Returns a copy of the vector, normalized.
--- @return vector_c
function vector_c:normalized()
    local length = self:length()

    if (length ~= 0) then
        return vector(self.x / length, self.y / length, self.z / length)
    else
        return vector(0, 0, 1)
    end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the vector is off-screen.
--- @return vector_c
function vector_c:to_screen(only_within_screen_boundary)
    local x, y = renderer.world_to_screen(self.x, self.y, self.z)

    if (x == nil or y == nil) then
        return nil
    end

    if (only_within_screen_boundary == true) then
        local screen_x, screen_y = client.screen_size()

        if (x < 0 or x > screen_x or y < 0 or y > screen_y) then
            return nil
        end
    end

    return vector(x, y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
--- @return number
function vector_c:magnitude()
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2) + math.pow(self.z, 2))
end

--- Returns the angle of the vector in regards to another vector.
--- @param destination vector_c
--- @return angle_c
function vector_c:angle_to(destination)
    -- Calculate the delta of vectors.
    local delta_vector = vector(destination.x - self.x, destination.y - self.y, destination.z - self.z)

    -- Calculate the yaw.
    local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

    -- Calculate the pitch.
    local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
    local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

    return angle(pitch, yaw)
end

--- Lerp to another vector.
--- @param destination vector_c
--- @param percentage number
--- @return vector_c
function vector_c:lerp(destination, percentage)
    return self + (destination - self) * percentage
end

--- Internally divide a ray.
--- @param source vector_c
--- @param destination vector_c
--- @param m number
--- @param n number
--- @return vector_c
local function vector_internal_division(source, destination, m, n)
    return vector((source.x * n + destination.x * m) / (m + n), (source.y * n + destination.y * m) / (m + n),
        (source.z * n + destination.z * m) / (m + n))
end

--- Returns the result of client.trace_line between two vectors.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number|nil
function vector_c:trace_line_to(destination, skip_entindex)
    skip_entindex = skip_entindex or -1

    return client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y, destination.z)
end

--- Trace line to another vector and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number, vector_c
function vector_c:trace_line_impact(destination, skip_entindex)
    skip_entindex = skip_entindex or -1

    local fraction, eid = client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y,
        destination.z)
    local impact = self:lerp(destination, fraction)

    return fraction, eid, impact
end

--- Trace line to another vector, skipping any entity indices returned by the callback and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param callback fun(eid: number): boolean
--- @param max_traces number
--- @return number, number, vector_c
function vector_c:trace_line_skip_indices(destination, max_traces, callback)
    max_traces = max_traces or 10

    local fraction, eid = 0, -1
    local impact = self
    local i = 0

    while (max_traces >= i and fraction < 1 and ((eid > -1 and callback(eid)) or impact == self)) do
        fraction, eid, impact = impact:trace_line_impact(destination, eid)
        i = i + 1
    end

    return self:distance(impact) / self:distance(destination), eid, impact
end

--- Traces a line from source to destination and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_classes table
--- @param skip_distance number
--- @return number, number
function vector_c:trace_line_skip_class(destination, skip_classes, skip_distance)
    local should_skip = function(index, skip_entity)
        local class_name = entity.get_classname(index) or ""
        for i in 1, #skip_entity do
            if class_name == skip_entity[i] then
                return true
            end
        end

        return false
    end

    local angles = self:angle_to(destination)
    local direction = angles:to_forward_vector()

    local last_traced_position = self

    while true do -- Start tracing.
        local fraction, hit_entity = last_traced_position:trace_line_to(destination)

        if fraction == 1 and hit_entity == -1 then -- If we didn't hit anything.
            return 1, -1 -- return nothing.
        else -- BOIS WE HIT SOMETHING.
            if should_skip(hit_entity, skip_classes) then -- If entity should be skipped.
                -- Set last traced position according to fraction.
                last_traced_position = vector_internal_division(self, destination, fraction, 1 - fraction)

                -- Add a little gap per each trace to prevent inf loop caused by intersection.
                last_traced_position = last_traced_position + direction * skip_distance
            else -- That's the one I want.
                return fraction, hit_entity, self:lerp(destination, fraction)
            end
        end
    end
end

--- Returns the result of client.trace_bullet between two vectors.
--- @param eid number
--- @param destination vector_c
--- @return number|nil, number
function vector_c:trace_bullet_to(destination, eid)
    return client.trace_bullet(eid, self.x, self.y, self.z, destination.x, destination.y, destination.z)
end

--- Returns the vector of the closest point along a ray.
--- @param ray_start vector_c
--- @param ray_end vector_c
--- @return vector_c
function vector_c:closest_ray_point(ray_start, ray_end)
    local to = self - ray_start
    local direction = ray_end - ray_start
    local length = direction:length()

    direction:normalize()

    local ray_along = to:dot_product(direction)

    if (ray_along < 0) then
        return ray_start
    elseif (ray_along > length) then
        return ray_end
    end

    return ray_start + direction * ray_along
end

--- Returns a point along a ray after dividing it.
--- @param ray_end vector_c
--- @param ratio number
--- @return vector_c
function vector_c:ray_divided(ray_end, ratio)
    return (self * ratio + ray_end) / (1 + ratio)
end

--- Returns a ray divided into a number of segments.
--- @param ray_end vector_c
--- @param segments number
--- @return table<number, vector_c>
function vector_c:ray_segmented(ray_end, segments)
    local points = {}

    for i = 0, segments do
        points[i] = vector_internal_division(self, ray_end, i, segments - i)
    end

    return points
end

--- Returns the best source vector and destination vector to draw a line on-screen using world-to-screen.
--- @param ray_end vector_c
--- @param total_segments number
--- @return vector_c|nil, vector_c|nil
function vector_c:ray(ray_end, total_segments)
    total_segments = total_segments or 128

    local segments = {}
    local step = self:distance(ray_end) / total_segments
    local angle = self:angle_to(ray_end)
    local direction = angle:to_forward_vector()

    for i = 1, total_segments do
        table.insert(segments, self + (direction * (step * i)))
    end

    local src_screen_position = vector(0, 0, 0)
    local dst_screen_position = vector(0, 0, 0)
    local src_in_screen = false
    local dst_in_screen = false

    for i = 1, #segments do
        src_screen_position = segments[i]:to_screen()

        if src_screen_position ~= nil then
            src_in_screen = true

            break
        end
    end

    for i = #segments, 1, -1 do
        dst_screen_position = segments[i]:to_screen()

        if dst_screen_position ~= nil then
            dst_in_screen = true

            break
        end
    end

    if src_in_screen and dst_in_screen then
        return src_screen_position, dst_screen_position
    end

    return nil
end

--- Returns true if the ray goes through a smoke. False if not.
--- @param ray_end vector_c
--- @return boolean
function vector_c:ray_intersects_smoke(ray_end)
    if (line_goes_through_smoke == nil) then
        error("Unsafe scripts must be allowed in order to use vector_c:ray_intersects_smoke")
    end

    return line_goes_through_smoke(self.x, self.y, self.z, ray_end.x, ray_end.y, ray_end.z, 1)
end

--- Returns true if the vector lies within the boundaries of a given 2D polygon. The polygon is a table of vectors. The Z axis is ignored.
--- @param polygon table<any, vector_c>
--- @return boolean
function vector_c:inside_polygon2(polygon)
    local odd_nodes = false
    local polygon_vertices = #polygon
    local j = polygon_vertices

    for i = 1, polygon_vertices do
        if (polygon[i].y < self.y and polygon[j].y >= self.y or polygon[j].y < self.y and polygon[i].y >= self.y) then
            if (polygon[i].x + (self.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) <
                self.x) then
                odd_nodes = not odd_nodes
            end
        end

        j = i
    end

    return odd_nodes
end

--- Draws a world circle with an origin of the vector. Code credited to sapphyrus.
--- @param radius number
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @param accuracy number
--- @param width number
--- @param outline number
--- @param start_degrees number
--- @param percentage number
--- @return void
function vector_c:draw_circle(radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
    local accuracy = accuracy ~= nil and accuracy or 3
    local width = width ~= nil and width or 1
    local outline = outline ~= nil and outline or false
    local start_degrees = start_degrees ~= nil and start_degrees or 0
    local percentage = percentage ~= nil and percentage or 1

    local screen_x_line_old, screen_y_line_old

    for rot = start_degrees, percentage * 360, accuracy do
        local rot_temp = math.rad(rot)
        local lineX, lineY, lineZ = radius * math.cos(rot_temp) + self.x, radius * math.sin(rot_temp) + self.y, self.z
        local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
        if screen_x_line ~= nil and screen_x_line_old ~= nil then

            for i = 1, width do
                local i = i - 1

                renderer.line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
            end

            if outline then
                local outline_a = a / 255 * 160

                renderer.line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16,
                    16, 16, outline_a)

                renderer.line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16,
                    outline_a)
            end
        end

        screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
    end
end

--- Performs math.min on the vector.
--- @param value number
--- @return void
function vector_c:min(value)
    self.x = math.min(value, self.x)
    self.y = math.min(value, self.y)
    self.z = math.min(value, self.z)
end

--- Performs math.max on the vector.
--- @param value number
--- @return void
function vector_c:max(value)
    self.x = math.max(value, self.x)
    self.y = math.max(value, self.y)
    self.z = math.max(value, self.z)
end

--- Performs math.min on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:minned(value)
    return vector(math.min(value, self.x), math.min(value, self.y), math.min(value, self.z))
end

--- Performs math.max on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:maxed(value)
    return vector(math.max(value, self.x), math.max(value, self.y), math.max(value, self.z))
end
-- endregion

-- region angle_vector_methods
--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_forward_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))

    return vector(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_up_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_right_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_backward_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))

    return -vector(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_left_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_down_vector()
    local degrees_to_radians = function(degrees)
        return degrees * math.pi / 180
    end

    local sp = math.sin(degrees_to_radians(self.p))
    local cp = math.cos(degrees_to_radians(self.p))
    local sy = math.sin(degrees_to_radians(self.y))
    local cy = math.cos(degrees_to_radians(self.y))
    local sr = math.sin(degrees_to_radians(self.r))
    local cr = math.cos(degrees_to_radians(self.r))

    return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Calculate where a vector is in a given field of view.
--- @param source vector_c
--- @param destination vector_c
--- @return number
function angle_c:fov_to(source, destination)
    local fwd = self:to_forward_vector()
    local delta = (destination - source):normalized()
    local fov = math.acos(fwd:dot_product(delta) / delta:length())

    return math.max(0.0, math.deg(fov))
end

--- Returns the degrees bearing of the angle's yaw.
--- @param precision number
--- @return number
function angle_c:bearing(precision)
    local yaw = 180 - self.y + 90
    local degrees = (yaw % 360 + 360) % 360

    degrees = degrees > 180 and degrees - 360 or degrees

    return math.round(degrees + 180, precision)
end

--- Returns the yaw appropriate for renderer circle's start degrees.
--- @return number
function angle_c:start_degrees()
    local yaw = self.y
    local degrees = (yaw % 360 + 360) % 360

    degrees = degrees > 180 and degrees - 360 or degrees

    return degrees + 180
end

--- Returns a copy of the angles normalized and clamped.
--- @return number
function angle_c:normalize()
    local pitch = self.p

    if (pitch < -89) then
        pitch = -89
    elseif (pitch > 89) then
        pitch = 89
    end

    local yaw = self.y

    while yaw > 180 do
        yaw = yaw - 360
    end

    while yaw < -180 do
        yaw = yaw + 360
    end

    return angle(pitch, yaw, 0)
end

--- Normalizes and clamps the angles.
--- @return number
function angle_c:normalized()
    if (self.p < -89) then
        self.p = -89
    elseif (self.p > 89) then
        self.p = 89
    end

    local yaw = self.y

    while yaw > 180 do
        yaw = yaw - 360
    end

    while yaw < -180 do
        yaw = yaw + 360
    end

    self.y = yaw
    self.r = 0
end
-- endregion

-- region functions
--- Draws a polygon to the screen.
--- @param polygon table<number, vector_c>
--- @return void
function vector_c.draw_polygon(polygon, r, g, b, a, segments)
    for id, vertex in pairs(polygon) do
        local next_vertex = polygon[id + 1]

        if (next_vertex == nil) then
            next_vertex = polygon[1]
        end

        local ray_a, ray_b = vertex:ray(next_vertex, (segments or 64))

        if (ray_a ~= nil and ray_b ~= nil) then
            renderer.line(ray_a.x, ray_a.y, ray_b.x, ray_b.y, r, g, b, a)
        end
    end
end

--- Returns the eye position of a player.
--- @param eid number
--- @return vector_c
function vector_c.eye_position(eid)
    local origin = vector(entity.get_origin(eid))
    local duck_amount = entity.get_prop(eid, "m_flDuckAmount") or 0

    origin.z = origin.z + 46 + (1 - duck_amount) * 18

    return origin
end
-- endregion
-- endregion

local function in_air(player)
    local flags = entity.get_prop(player, "m_fFlags")

    if bit_band(flags, 1) == 0 then
        return true
    end

    return false
end

local targetAngle = {}
local pressing_e_timer = {}

local function calc_angle(x_src, y_src, z_src, x_dst, y_dst, z_dst)
    local x_delta = x_src - x_dst
    local y_delta = y_src - y_dst
    local z_delta = z_src - z_dst
    local hyp = math.sqrt(x_delta ^ 2 + y_delta ^ 2)
    local x = math.atan2(z_delta, hyp) * 57.295779513082
    local y = math.atan2(y_delta, x_delta) * 180 / 3.14159265358979323846

    if y > 180 then
        y = y - 180
    end
    if y < -180 then
        y = y + 180
    end
    return y
end

local function normalize_yaw(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end

local ffi = require 'ffi'
local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')
ffi.cdef [[
    struct animation_layer_t {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    };
    struct c_animstate { 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]


local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                           error('VClientEntityList003 wasnt found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or
                                   error('get_client_networkable_t is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                              error('get_client_entity is nil', 2)

local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

local seq_activity_sig = client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(b)
    if b then
        b = ffi.cast(classptr, b)
        local c = ffi.cast(crr_t, b[0][0])
        local d = c(b) or error('error getting client unknown', 2)
        if d then
            d = ffi.cast(classptr, d)
            local e = ffi.cast(cr_t, d[0][5])(d) or error('error getting client renderable', 2)
            if e then
                e = ffi.cast(classptr, e)
                return ffi.cast(gm_t, e[0][8])(e) or error('error getting model_t', 2)
            end
        end
    end
end
local function get_sequence_activity(b, c, d)
    b = ffi.cast(classptr, b)
    local e = get_studio_model(ivmodelinfo, get_model(c))
    if e == nil then
        return -1
    end
    local f = ffi.cast(gsa_t, seq_activity_sig)
    return f(b, e, d)
end
local function get_anim_layer(b, c)
    c = c or 1;
    b = ffi.cast(classptr, b)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', b) + 0x2990)[0][c]
end

local player_list = ui.reference('PLAYERS', 'Players', 'Player list')
local pl_reset = ui.reference('PLAYERS', 'Players', 'Reset all')

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true

    local result = {}

    local me = entity.get_local_player()
    local player_resource = entity.get_player_resource()

    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true

        if enemy_only and not entity.is_enemy(player) then
            is_enemy = false
        end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then
                is_alive = false
            end
            if is_alive then
                table.insert(result, player)
            end
        end
    end

    return result
end

local resolver_c = {}
local resolver_mt = {
    __index = resolver_c
}

local x = 0

function resolver_c.setup()
    return setmetatable({
        miss_reason = {},
        entity_data = {},
        animstate_data = {},
        animlayer_data = {},
        freestand_data = {},
        misses = 0,
        hit = 0,
        shots = 0
    }, resolver_mt)
end

function resolver_c:reset()

    self.miss_reason = {}
    self.entity_data = {}
    self.animstate_data = {}
    self.animlayer_data = {}
    self.freestand_data = {}

end

function resolver_c:GetAnimationState(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
    local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

    return state
end

function GetAnimationState1(_Entity)
    if not (_Entity) then
        return
    end
    local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, _Entity))
    local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
    local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

    return state
end

function GetPlayerMaxFeetYaw1(_Entity)
    local S_animationState_t = GetAnimationState1(_Entity)
    local nDuckAmount = S_animationState_t.m_fDuckAmount
    local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
    local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
    local nValue = (S_animationState_t.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) *
                       nFeetSpeedForwardsOrSideWays + 1
    if nDuckAmount > 0 then
        nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
    end
    local nDeltaYaw = S_animationState_t.m_flMaxYaw * nValue
    return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
end

function resolver_c:GetPlayerMaxFeetYaw(_Entity)
    local S_animationState_t = self:GetAnimationState(_Entity)
    local nDuckAmount = S_animationState_t.m_fDuckAmount
    local nFeetSpeedForwardsOrSideWays = math.max(0, math.min(1, S_animationState_t.m_flFeetSpeedForwardsOrSideWays))
    local nFeetSpeedUnknownForwardOrSideways = math.max(1, S_animationState_t.m_flFeetSpeedUnknownForwardOrSideways)
    local nValue = (S_animationState_t.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) *
                       nFeetSpeedForwardsOrSideWays + 1
    if nDuckAmount > 0 then
        nValue = nValue + nDuckAmount * nFeetSpeedUnknownForwardOrSideways * (0.5 - nValue)
    end
    local nDeltaYaw = S_animationState_t.m_flMaxYaw * nValue
    return nDeltaYaw < 60 and nDeltaYaw >= 0 and nDeltaYaw or 0
end

function resolver_c:on_miss(handle)
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg",
                            "neck", "?", "gear"} -- hitgroup_names[e.hitgroup + 1] or "?"
    if handle.reason ~= "?" then
        return
    end

    self.misses = self.misses + 1

    if not self.entity_data[handle.target] then
        self.entity_data[handle.target] = {}
    end

    if not self.miss_reason[handle.target] then
        self.miss_reason[handle.target] = {}
    end

    local miss_count = self.entity_data[handle.target].miss or 0

    self.entity_data[handle.target].miss = miss_count + 1

    local miss_data = handle

    local ent_name = entity.get_player_name(handle.target)

    miss_data.name = ent_name

    local yaw = (entity.get_prop(handle.target, "m_flPoseParameter", 11) or 0) * 116 - 58

    local should_fix = self.entity_data[handle.target].miss > 2 and self.entity_data[handle.target].miss < 5

    self.miss_reason[handle.target].count = self.entity_data[handle.target].miss
    self.miss_reason[handle.target].reason = self.entity_data[handle.target].miss > 2 and
                                                 (string.format("lowdelta: %s", yaw) or "?") or "?"

    local fix_value = 20 * (self.entity_data[handle.target].miss % 2 == 0 and -1 or 1)
	self.freestand_data[handle.target].side_fix = fix_value > 0 and "right" or "left"
        plist.set(handle.target, "Force body yaw", true)
        plist.set(handle.target, "Force body yaw value", fix_value)
end

function resolver_c:on_hit(handle)
    self.hit = self.hit + 1
end

function resolver_c:on_fire(handle)
    self.shots = self.shots + 1
end

OverlayRect = function(x, y, w, h, resize_box_h, color_1)
    surface.draw_filled_gradient_rect(x - 1, y - 1, w + 2, h + 2, color_1[1], color_1[2], color_1[3], 255, 20,20,20,200, false)
    surface.draw_filled_gradient_rect(x, y, w, h, 20, 20, 20, 100, 20,20,20,200, false)
    if resize_box_h ~= nil and resize_box_h > 0 then
        resize_box_h = resize_box_h + 5
        surface.draw_filled_gradient_rect(x - 1, y + h + 1, w + 2, resize_box_h, 20,20,20,200, 20,20,20, 0, false)
        surface.draw_filled_gradient_rect(x - 1, y, 1, h + 1 + resize_box_h, color_1[1], color_1[2], color_1[3], 255, 20,20,20, 0, false)
        surface.draw_filled_gradient_rect(x + w, y, 1, h + 1 + resize_box_h, color_1[1], color_1[2], color_1[3], 255, 20,20,20, 0, false)
    end
end

local box_height_space = 0
local box_lenght = {
    s = 150,
    idx = 0
}
function resolver_c:render()

    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then
        return
    end

    local entities = get_entities(true, true)

    if #entities == 0 then
        self.animlayer_data = {}
        return
    end

    local indicator = {}
    indicator.fix_value = 0
    indicator.name = "Test"
	indicator.active = false
    indicator.username = ""
	
    for i = 1, #entities do
        local target = entities[i]
        local lpent = get_client_entity(ientitylist, target)
        local lpentnetworkable = get_client_networkable(ientitylist, target)

        local max_yaw = self:GetPlayerMaxFeetYaw(target)

        self.animstate_data[target] = {
            max_yaw = max_yaw
        }

        local act_table = {}

        for i = 1, 12 do
            local layer = get_anim_layer(lpent, i)

            if layer.m_pOwner ~= nil then
                local act = get_sequence_activity(lpent, lpentnetworkable, layer.m_nSequence)

                if act ~= -1 then
                    --print(string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))
                end

                if act == 964 then
                    --print(string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))
                end

                --renderer.text(10, 200 + 15*i, 255, 255, 255, 255, nil, 0, string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle))

                if i == 12 then 
                    --renderer.text(10, 800 + 15*13, 255, 255, 255, 255, nil, 0, string.format("max_desync: %s", self:GetPlayerMaxFeetYaw(target)))
                end

                --renderer.indicator(255, 255, 255, 255, string.format('act: %.5f weight: %.5f cycle: %.5f', act, layer.m_flWeight, layer.m_flCycle)) --]]

                act_table[act] = {
                    ["m_nSequence"] = layer.m_nSequence,
                    ["m_flPrevCycle"] = layer.m_flPrevCycle,
                    ["m_flWeight"] = layer.m_flWeight,
                    ["m_flCycle"] = layer.m_flCycle
                }

            end
        end

        self.animlayer_data[target] = act_table

        local lp_origin = vector(entity.get_origin(me))
        local entity_eye_yaw = vector_c.eye_position(target) -- vector(self:GetAnimationState(target).m_flEyeYaw)
        local entity_angle = entity_eye_yaw:angle_to(lp_origin) -- vector(self:GetAnimationState(target).m_flEyeYaw)
        local entity_set_prop = entity.set_prop
        local entity_get_prop = entity.get_prop
        local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")

        local trace_data = {
            left = 0,
            right = 0
        }

        -- :trace_line_impact(destination, skip_entindex)
        for i = entity_angle.y - 90, entity_angle.y + 90, 25 do
            if i ~= entity_angle.y then
                local rad = math.rad(i)

                local point_start = vector(entity_eye_yaw.x + 50 * math.cos(rad), entity_eye_yaw.y + 50 * math.sin(rad),
                    entity_eye_yaw.z)
                local point_end = vector(entity_eye_yaw.x + 256 * math.cos(rad), entity_eye_yaw.y + 256 * math.sin(rad),
                    entity_eye_yaw.z)

                local fraction, eid, impact = point_start:trace_line_impact(point_end, me)

                local side = i < entity_angle.y and "left" or "right"

                trace_data[side] = trace_data[side] + fraction

            end
        end
        local side = trace_data.left < trace_data.right and 1 or 2
        if not self.freestand_data[target] then
            self.freestand_data[target] = {}
        end

        self.freestand_data[target] = {
            side = side,
            side_fix = ""
        }

        local hitbox_pos = {x, y, z}
        hitbox_pos.x, hitbox_pos.y, hitbox_pos.z = entity.hitbox_position(target, 0)
        local local_x, local_y, local_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        local dynamic = calc_angle(local_x, local_y, local_z, hitbox_pos.x, hitbox_pos.y, hitbox_pos.z)
        local Pitch = entity.get_prop(target, "m_angEyeAngles[0]")
        local FakeYaw = math.floor(normalize_yaw(entity.get_prop(target, "m_angEyeAngles[1]")))

        local BackAng = math.floor(normalize_yaw(dynamic + 180))
        local LeftAng = math.floor(normalize_yaw(dynamic - 90))
        local RightAng = math.floor(normalize_yaw(dynamic + 90))
        local ForwAng = math.floor(normalize_yaw(dynamic))
        local AreaDist = 35

        if (RightAng - FakeYaw <= AreaDist and RightAng - FakeYaw > -AreaDist) or
            (RightAng - FakeYaw >= -AreaDist and RightAng - FakeYaw < AreaDist) then
            targetAngle[target] = "right"
        elseif (LeftAng - FakeYaw <= AreaDist and LeftAng - FakeYaw > -AreaDist) or
            (LeftAng - FakeYaw >= -AreaDist and LeftAng - FakeYaw < AreaDist) then
            targetAngle[target] = "left"
        elseif (BackAng - FakeYaw <= AreaDist and BackAng - FakeYaw > -AreaDist) or
            (BackAng - FakeYaw >= -AreaDist and BackAng - FakeYaw < AreaDist) then
            targetAngle[target] = "backward"
        elseif (ForwAng - FakeYaw <= AreaDist and ForwAng - FakeYaw > -AreaDist) or
            (ForwAng - FakeYaw >= -AreaDist and ForwAng - FakeYaw < AreaDist) then
            targetAngle[target] = "forward"
        else
            targetAngle[target] = nil
        end

        -- velocity
        local vec_vel = vector(entity.get_prop(target, 'm_vecVelocity'))
        local velocity = math.floor(math.sqrt(vec_vel.x ^ 2 + vec_vel.y ^ 2) + 0.5)

        -- standing
        local standing = velocity < 1.1
        -- slowwalk
        local slowwalk = in_air(target) == false and velocity > 1.1 and self:GetPlayerMaxFeetYaw(target) >= 37
        -- moving
        local moving = in_air(target) == false and velocity > 1.1 and self:GetPlayerMaxFeetYaw(target) <= 36
        -- air
        local air = in_air(target)

        local pitch_e = Pitch >= -10 and Pitch <= 51
        local pitch_sideways = Pitch <= 90 and Pitch >= 70
        local e_check = targetAngle[target] == "forward" and pitch_e
        local sideways_forward = targetAngle[target] == "forward" and pitch_sideways
        local sideways_left_right = ((targetAngle[target] == "left") or (targetAngle[target] == "right")) and
                                        pitch_sideways

        if e_check then
            if pressing_e_timer[target] == nil then
                pressing_e_timer[target] = 0
            end
            pressing_e_timer[target] = pressing_e_timer[target] + 1
        else
            pressing_e_timer[target] = 0
        end

        local pressing_e = e_check and pressing_e_timer[target] > 5 and not in_air(target)
        local onshot = e_check and pressing_e_timer[target] < 5 and not in_air(target)

        local calculate_angles = side == 1 and -1 or 1
        local calculate_phase = self.entity_data[target] and (self.entity_data[target].miss % 4 < 2 and 1 or 2) or 1
        local calculate_phase_sw = self.entity_data[target] and
                                       (self.entity_data[target].miss % 5 < 1 and 1 or
                                           (self.entity_data[target].miss % 5 < 3 and 2 or 3)) or 1
        local calculate_invert = self.entity_data[target] and (self.entity_data[target].miss % 2 == 1 and 1 or -1) or -1

        bruteforce_phases = {
            standing = {
                [1] = -50,
                [2] = 50,
                [3] = 30,
                [4] = 0
            },
            moving = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            },
            air = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            },
            slowwalk = {
                [1] = 30,
                [2] = -max_yaw,
                [3] = max_yaw,
                [4] = max_yaw,
                [5] = 0
            },
            pressing_e = {
                [1] = 0,
                [2] = -58,
                [3] = 58,
                [4] = 58
            },
            onshot = {
                [1] = 60,
                [2] = -60,
                [3] = -60
            },
            other = {
                [1] = -max_yaw,
                [2] = max_yaw,
                [3] = max_yaw,
                [4] = 0
            }
        }

        

            table.insert(indicator, {
                name = "standing",
                fix_value = bruteforce_phases.standing[calculate_phase] * calculate_invert * calculate_angles,
                active = standing and not moving and not slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "moving",
                fix_value = bruteforce_phases.moving[calculate_phase] * calculate_invert * calculate_angles,
                active = moving and not slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "slowwalk",
                fix_value = bruteforce_phases.slowwalk[calculate_phase],
                active = slowwalk and not air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "in air",
                fix_value = bruteforce_phases.air[calculate_phase] * calculate_invert * calculate_angles,
                active = air and not pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "e",
                fix_value = bruteforce_phases.pressing_e[calculate_phase] * calculate_invert * calculate_angles,
                active = pressing_e and not onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "fired",
                fix_value = bruteforce_phases.onshot[calculate_phase] * calculate_invert * calculate_angles,
                active = onshot and not sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "forward",
                fix_value = (max_yaw / 2 + (max_yaw / 4)) * calculate_invert * calculate_angles * (-2),
                active = sideways_forward and not sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
            table.insert(indicator, {
                name = "left/right",
                fix_value = (max_yaw / 2 - 4) * calculate_invert * calculate_angles,
                active = sideways_left_right,
                username = entity.get_player_name(target),
                get_max_yaw = max_yaw
            })
    end
    if ui.get(indicatorCheckbox) then
        local spacex = 0

        local draw_pos = {
            x = 1,
            y = 554,
            w = box_lenght.s,
            h = 30
        }
        local box_r, box_g, box_b = ui.get(actual_color)
        --OverlayRect(draw_pos.x, draw_pos.y, draw_pos.w, draw_pos.h, box_height_space, {box_r, box_g, box_b})

        local text_title = "Mewtwo Resolver"

        local text_size_title = surface.get_text_size(resolver_font, text_title)
        surface.draw_text(draw_pos.x - 27 + draw_pos.w/2 - text_size_title/2, draw_pos.y + 5 + (draw_pos.h)/2 - 12/2, box_r, box_g, box_b, 255, resolver_font, text_title)
    
        for i = 1, #indicator, 1 do
            local active = indicator[i].active
            local name = indicator[i].name
            local fix_value = indicator[i].fix_value
            local username = indicator[i].username
            local max_yaw = indicator[i].get_max_yaw

            if active then
                local draw_text = username .. ": " .. name .. "" .. max_yaw .. "" .. "" .. fix_value .. ""
                local text_size = surface.get_text_size(resolver_font, draw_text)
                surface.draw_text(draw_pos.x + 5, draw_pos.y + (draw_pos.h) + spacex, box_r, box_g, box_b, draw_color_resolver.a, resolver_font, username)
                surface.draw_text(draw_pos.x + 5 + surface.get_text_size(resolver_font, username), draw_pos.y + (draw_pos.h) + spacex, 255,255,255,255, resolver_font, ": " .. name .. "|" .. max_yaw .. "" .. "|" .. fix_value .. "")
                if 5 + text_size > box_lenght.s then
                    box_lenght.s = 5 + text_size
                    box_lenght.idx = username
                end
                if 5 + text_size < box_lenght.s and box_lenght.idx == username then
                    box_lenght.s = 150
                end
                spacex = spacex + 18
            end
        end
        box_height_space = spacex
        
    end
    
end


local resolver = resolver_c.setup()

--local esp_flag = client_register_esp_flag("DESYNC:" max_yaw)

local miss_count_label = ui.new_label("PLAYERS", "Adjustments", "Miss count: 0")

local globals_realtime = globals.realtime

client.set_event_callback("paint", function()

    local ent = ui.get(player_list)

    ui.set(miss_count_label,
        string.format("Miss count: %s", resolver.entity_data[ent] and resolver.entity_data[ent].miss or 0))

    resolver:render()
end)

client.set_event_callback("aim_miss", function(handle)
    resolver:on_miss(handle)
end)

client.set_event_callback("aim_hit", function(handle)
    resolver:on_hit(handle)
end)

client.set_event_callback("aim_fire", function(handle)
    resolver:on_fire(handle)
    -- on_fire
end)

-- RESET values

client.set_event_callback("player_death", function(handle)
    local entity_id = client.userid_to_entindex(handle.userid)
    local attacker_id = client.userid_to_entindex(handle.attacker)
    local me = entity.get_local_player()

    if me == entity_id or me == attacker_id then
        resolver:reset()
    end
end)

client.set_event_callback('cs_game_disconnected', resolver.reset)
client.set_event_callback('game_newmap', resolver.reset)
client.set_event_callback('round_start', resolver.reset)
-- client.set_event_callback("aim_fire", aim_fire)
-- client.set_event_callback("aim_hit", aim_hit)

print(name, " has been loaded!")
end
local obex_tbl = obex_tbl or { ["count"] = client.random_int(1,10000) }
local find_window_rand_num = find_window_rand_num or client.random_int(1,10000)
local unix = unix or client.random_int(1,10000)
local ffi_random = ffi_random or client.random_int
local secret = unix + (ffi_random(1, 10000) + obex_tbl.count) + find_window_rand_num
local function convert(tbl)
	local converted = {}
	for i in next, tbl do
		converted[#converted+1] = i
	end
	return converted
end

reached = true
local script = ui.new_combobox("Config", "Lua", "\abbc4fbffM\abbc4fbffe\ac9bdf9ffw\ad6b6f7fft\ae4aff5ffw\ae4aff5ffo.\afea1f1ffTe\aff96edffch \acdcdcdcdModule Loader", convert(scripts))
local loadscript = ui.new_button("Config", "Lua", "Load Module", function()
	local current = ui.get(script)
	scripts[current](current, secret)
end)
if remove_obex_print then return end