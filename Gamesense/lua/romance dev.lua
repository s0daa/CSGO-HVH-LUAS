local menu_get, menu_set, menu_checkbox, menu_slider, menu_combobox, menu_multiselect, menu_hotkey, menu_button, menu_colorpicker, menu_textbox, menu_listbox, menu_string, menu_label, menu_reference, menu_set_callback, menu_setvisible, client_set_event_callback, render_measure_text, client_trace_line, client_eye_position, client_trace_bullet = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_multiselect, ui.new_hotkey, ui.new_button, ui.new_color_picker, ui.new_textbox, ui.new_listbox, ui.new_string, ui.new_label, ui.reference, ui.set_callback, ui.set_visible, client.set_event_callback, renderer.measure_text, client.trace_line, client.eye_position, client.trace_bullet
local entity_get_prop, entity_get_local_player, entity_is_alive, entity_get_player_weapon, entity_get_classname, entity_get_origin, globals_frametime, client_screen_size, globals_framecount, is_menu_open, menu_mouse_position, client_key_state, table_insert, entity_get_steam64, render_circle_outline, entity_get_all, globals_tickinterval, client_set_clantag = entity.get_prop, entity.get_local_player, entity.is_alive, entity.get_player_weapon, entity.get_classname, entity.get_origin, globals.frametime, client.screen_size, globals.framecount, ui.is_menu_open, ui.mouse_position, client.key_state, table.insert, entity.get_steam64, renderer.circle_outline, entity.get_all, globals.tickinterval, client.set_clan_tag
local math_sqrt, bit_band, globals_curtime, math_floor, bit_lshift, globals_tickcount, entity_get_players, entity_get_player_name, entity_get_steam64, client_userid_to_entindex, entity_is_enemy, entity_is_dormant, entity_hitbox_position, math_max, math_abs, render_text, render_world_to_screen, client_exec, entity_get_bounding_box, client_create_interface, render_box, render_circle, render_gradient = math.sqrt, bit.band, globals.curtime, math.floor, bit.lshift, globals.tickcount, entity.get_players, entity.get_player_name, entity.get_steam64, client.userid_to_entindex, entity.is_enemy, entity.is_dormant, entity.hitbox_position, math.max, math.abs, renderer.text, renderer.world_to_screen, client.exec, entity.get_bounding_box, client.create_interface, renderer.rectangle, renderer.circle, renderer.gradient

local vector = require("vector")
local ffi = require("ffi")
local http = require 'gamesense/http'


ffi.cdef[[
    typedef unsigned char wchar_t;
	typedef void*(__thiscall* get_client_entity_t)(void*, int);

]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client_create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local gui = {}
local menu = {}
local aa = {}
local ent = {}
local visuals = {}
local misc = {}
local helpers = {}
local exptbl = {}
local ragebot = {}
local exploits = {}

--############################################## MENU ELEMENTS & EXTRA##############################################
--local loader_astral = "you use Monstry"
local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'DEV'}
local build = string.upper(obex_data.build:gsub('User', 'Live'))

menu.f = {}
menu.aa = {}
menu.misc = {}
menu.add_ons = {}
menu.ref = {}

gui.aa = {}
gui.misc = {}
gui.add_ons = {}

menu.f.hex_label = function(rgb)
    local hexadecimal= '\a'
    
    for key, value in pairs(rgb) do
        local hex = ''

        while value > 0 do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value/16)
            hex = ('0123456789ABCDEF'):sub(index, index) .. hex
        end

        if #hex == 0 then 
            hex= '00' 
        elseif #hex == 1 then 
            hex= '0' .. hex 
        end

        hexadecimal = hexadecimal .. hex
    end 
    
    return hexadecimal .. 'FF'
end

menu.draw_clr_txt = function(self, text1, text2, text3)
	return menu.clr.grey2 .. text1 .. menu.clr.main .. text2 .. menu.clr.grey2  .. text3 .. menu.clr.grey .. " - " .. menu.clr.txt
end

local conditions = {"Global", "Stand", "Slow", "Move", "Air", "Air+Duck", "Duck"}
local conditions_fix = {
	["1"] = "Global",
	["2"] = "Stand", 
	["3"] = "Slow", 
	["4"] = "Move",
	["5"] = "Air", 
	["6"] = "Duck"
}

local conds_disablers = {"Stand", "Slow", "Move", "Air", "Air+Duck", "Duck"}


local exploits_options = {"Roll", "Fake flick", "Defensive manipulation"}
local cond_to_int = {}

menu.clr = {}
--menu.clr.main = menu.f.hex_label({250, 155, 155})
local menu_r, menu_g, menu_b, menu_a = menu_get(menu_reference("misc", "settings", "menu color"))

menu.clr.main = menu.f.hex_label({menu_r, menu_g, menu_b})
menu.clr.txt = menu.f.hex_label({165,165,165})
menu.clr.txt2 = menu.f.hex_label({215,215,215})
menu.clr.grey = menu.f.hex_label({55,55,55})
menu.clr.grey2 = menu.f.hex_label({75, 75, 75})
menu.txt = {}
menu.txt.keybinds = "     " .. menu.clr.grey2 .. "[" .. menu.clr.main .. "KEY" .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "> " .. menu.clr.txt
aa_color = menu:draw_clr_txt("[", "ANTI-AIM", "]")

gui.astral = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "")
--gui.spacer = menu_label("aa", "anti-aimbot angles", "\n")
menu.categories = {"Ragebot", "Anti-Aim", "Visuals", "Misc", "Settings"}
gui.selector = menu_combobox("aa", "anti-aimbot angles", menu:draw_clr_txt("[", "ASTRAL", "]") .. "Category", menu.categories)

gui.label_aa = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "<" .. menu.clr.grey2 .. "---------" .. menu.clr.txt .. " Anti-Aim configuration " .. menu.clr.grey2 .. "--------" .. menu.clr.main .. ">")

menu.aa.category_opt = {"Default", "Algorithm", "Exploits", "Misc/Keybinds"}
gui.aa.category = menu_combobox("aa", "anti-aimbot angles", "\n", menu.aa.category_opt)

gui.aa.enhancements = menu_multiselect("aa", "anti-aimbot angles", aa_color .. "Enhancements", {"Better on-shot", "Anti backstab", "Anti zeus"})
gui.aa.backstab_options = menu_multiselect("aa", "anti-aimbot angles", aa_color .. "Anti backstab options", {"Disable if more than 1 in range", "Predict enemy high in air velocity", "Pull out secondary weapon"})

gui.aa.keybinds = menu_multiselect("aa", "anti-aimbot angles", aa_color .. "Keybinds", {"Legit AA","Edge-Yaw","Freestand","Manual AA"})
gui.aa.legitaa_options = menu_combobox("aa", "anti-aimbot angles", aa_color .. "Legit AA options", {"Static", "Jitter"})
gui.aa.freestand_disablers = menu_multiselect("aa", "anti-aimbot angles", aa_color .. "Freestand disablers", conds_disablers)
gui.aa.freestand_options = menu_combobox("aa", "anti-aimbot angles", aa_color .. "Freestand options", {"Static", "Jitter"})
gui.aa.manual_options = menu_combobox("aa", "anti-aimbot angles", aa_color .. "Manual AA options", {"At targets", "Local view"})

gui.aa.hide_keybinds = menu_checkbox("aa", "anti-aimbot angles", aa_color .. "Show keybinds")
gui.aa.key_legit_aa = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Legit AA")
gui.aa.key_edge_yaw = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Edge-yaw")
gui.aa.key_freestand = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Freestand")
gui.aa.key_left = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Left")
gui.aa.key_right = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Right")
gui.aa.key_forward = menu_hotkey("aa", "anti-aimbot angles", menu.txt.keybinds .. "Forwards")

local algorithm = menu:draw_clr_txt("[", "ALGORTIHM", "]")

gui.aa.enable = menu_checkbox("aa", "anti-aimbot angles", algorithm .. "Enable Algorithm AA")
gui.aa.state = menu_combobox("aa", "anti-aimbot angles", "\n", conditions)
menu.aa.mode = {"Default", "Custom"}

menu.aa.exploits = {}

misc.string = {}

local debug = {
	get_state =  nil,
	can_desync =  nil,
	check_desync = nil,
	apply_aa = nil,
	micromove = nil,
	freestand = nil,
	keybinds = nil,
	anti_zeus = nil,
	anti_backstab = nil,
	roll = nil,
	at_targets = nil,
	better_onshot = nil,
	prefer_baim = nil,
	prefer_sp = nil,
	defensive_exploit = nil,
}

local VGUI_System010 =  client.create_interface('vgui2.dll', 'VGUI_System010')
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010)
ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', VGUI_System[0][7])
local set_clipboard_text = ffi.cast('set_clipboard_text', VGUI_System[0][9])
local get_clipboard_text = ffi.cast('get_clipboard_text', VGUI_System[0][11])


for l, m in next, menu.categories do
	if gui[m] == nil then gui[m] = {} end
	if m == "Ragebot" then
		local ragebot = menu:draw_clr_txt("[", "RAGEBOT", "]")
		local body = menu:draw_clr_txt("[", "BODY", "]")
		local safepoint = menu:draw_clr_txt("[", "SAFEPOINT", "]")

		gui[m] = {
			label = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "<" .. menu.clr.grey2 .. "-----------------" .. menu.clr.txt .. " Ragebot " .. menu.clr.grey2 .. "-----------------" .. menu.clr.main .. ">"),
			prefers_options = menu_multiselect("aa", "anti-aimbot angles", ragebot .. "Body Prefers", {"Has height","Is lethal","High velocity","After X misses", "HP lower than X"}),
			prefers_after_x = menu_slider("aa", "anti-aimbot angles", body .. "After X misses", 0, 10, 2, true, "", 1),
			prefers_lower_than = menu_slider("aa", "anti-aimbot angles", body .. "Lower than X", 0, 100, 80, true, "hp", 1),

			sp_options = menu_multiselect("aa", "anti-aimbot angles", ragebot .. "Force safepoint", {"Has height","Is lethal","High velocity","After X misses", "HP lower than X"}),
			sp_after_x = menu_slider("aa", "anti-aimbot angles", safepoint .. "After X misses", 0, 10, 2, true, "", 1),
			sp_lower_than = menu_slider("aa", "anti-aimbot angles", safepoint .. "Lower than X", 0, 100, 80, true, "hp", 1),

		}
	end

	if m == "Visuals" then
		c1 = menu:draw_clr_txt("[", "VISUALS", "]")
		c2 = menu:draw_clr_txt("[", "COLORS", "]")

		c3 = "     " .. menu.clr.grey2 .. "[" .. menu.clr.main .. "COLOR" .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "> " .. menu.clr.txt
		c4 = menu:draw_clr_txt("[", "CENTER", "]")
		c5 = menu:draw_clr_txt("[", "LOGS", "]")
		c6 = menu:draw_clr_txt("[", "Arrows", "]")

		gui[m] = {
			label = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "<" .. menu.clr.grey2 .. "------------------" .. menu.clr.txt .. " Visuals " .. menu.clr.grey2 .. "------------------" .. menu.clr.main .. ">"),
			selector = menu_combobox("aa", "anti-aimbot angles", "\n", {"Indicators", "Colors"}),
			indicators = {
				center = menu_combobox("aa", "anti-aimbot angles", c1 .. "Center indicators", {"Off", "Simple"}),
				center_height = menu_slider("aa", "anti-aimbot angles", c4 .. "Center height", -100, 100, 0, true, "px", 1),
				esp = menu_combobox("aa", "anti-aimbot angles", c1 .. "Ragebot ESP", {"Off", "Flag", "Above head"}),
				additional = menu_multiselect("aa", "anti-aimbot angles", c1 .. "Additional indicators", {"Warnings", "Debug text", "Logs", "Arrows"}),
				arrows_padding = menu_slider("aa", "anti-aimbot angles", c6 .. "Padding", -100, 100, 0, true, "px", 1),
				arrows_height = menu_slider("aa", "anti-aimbot angles", c6 .. "Height", -100, 100, 0, true, "px", 1),
				arrow_options = menu_multiselect("aa", "anti-aimbot angles", c6 .. "Options", {"Move with velocity", "Hide in scope", "Move in scope", "Show only toggled side"}),
			},
			colors = {
				options = menu_combobox("aa", "anti-aimbot angles", c2 .. "Select to change", {"Center indicators", "Ragebot"}),
				label = menu_label("aa", "anti-aimbot angles", menu.clr.grey2 .. "[" .. menu.clr.main .. " Center " .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "-> "),
				clr_lua_name = menu_label("aa", "anti-aimbot angles", c3 .. "Lua name 1\aFFFFffff"),
				clr_lua_name_1 = menu_colorpicker("aa", "anti-aimbot angles", "Lua name 1", 255, 0, 255, 255),
				clr_lua_name2 = menu_label("aa", "anti-aimbot angles", c3 .. "Lua name 2\aFFFFffff"),
				clr_lua_name2_1 = menu_colorpicker("aa", "anti-aimbot angles", "Lua name 2", 125, 125, 255, 255),
				clr_DEV = menu_label("aa", "anti-aimbot angles", c3 .. "Build\aFFFFffff"),
				clr_DEV_1 = menu_colorpicker("aa", "anti-aimbot angles", "Build", 125, 125, 255, 255),

				clr_state = menu_label("aa", "anti-aimbot angles", c3 .. "State\aFFFFffff"),
				clr_state_1 = menu_colorpicker("aa", "anti-aimbot angles", "State", 250, 250, 250, 125),
				clr_dt = menu_label("aa", "anti-aimbot angles", c3 .. "DT\aFFFFffff"),
				clr_dt_1 = menu_colorpicker("aa", "anti-aimbot angles", "DT", 250, 250, 250, 175),
				clr_dtcircle = menu_label("aa", "anti-aimbot angles", c3 .. "DT Circle\aFFFFffff"),
				clr_dtcircle_1 = menu_colorpicker("aa", "anti-aimbot angles", "DT Circle", 250, 250, 250, 175),

				clr_os = menu_label("aa", "anti-aimbot angles", c3 .. "OSAA\aFFFFffff"),
				clr_os_1 = menu_colorpicker("aa", "anti-aimbot angles", "OSAA", 250, 250, 250, 175),

				clr_stars = menu_label("aa", "anti-aimbot angles", c3 .. "Stars color\aFFFFffff"),
				clr_stars_1 = menu_colorpicker("aa", "anti-aimbot angles", "Stars color", 250, 250, 250, 250),
				clr_starstwo = menu_label("aa", "anti-aimbot angles", c3 .. "2. Star color\aFFFFffff"),
				clr_starstwo_1 = menu_colorpicker("aa", "anti-aimbot angles", "2. Star color", 250, 250, 250, 250),

				label_rage = menu_label("aa", "anti-aimbot angles", menu.clr.grey2 .. "[" .. menu.clr.main .. " Rage " .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "-> "),
				clr_prefer = menu_label("aa", "anti-aimbot angles", c3 .. "Body\aFFFFffff"),
				clr_prefer_1 = menu_colorpicker("aa", "anti-aimbot angles", "Body", 250, 250, 250, 175),
				clr_safepoint = menu_label("aa", "anti-aimbot angles", c3 .. "Safepoint\aFFFFffff"),
				clr_safepoint_1 = menu_colorpicker("aa", "anti-aimbot angles", "Safepoint", 250, 250, 250, 175),
				clr_safepointprefer = menu_label("aa", "anti-aimbot angles", c3 .. "Body and prefer\aFFFFffff"),
				clr_safepointprefer_1 = menu_colorpicker("aa", "anti-aimbot angles", "Body and prefer", 250, 250, 250, 175),

				label_warn = menu_label("aa", "anti-aimbot angles", menu.clr.grey2 .. "[" .. menu.clr.main .. " Warnings " .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "-> "),
				clr_warnings = menu_label("aa", "anti-aimbot angles", c3 .. "Warnings\aFFFFffff"),
				clr_warnings_1 = menu_colorpicker("aa", "anti-aimbot angles", "Warnings", 225, 0, 0, 200),

				label_logs = menu_label("aa", "anti-aimbot angles", menu.clr.grey2 .. "[" .. menu.clr.main .. " Logs " .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "-> "),
				clr_logstxt = menu_label("aa", "anti-aimbot angles", c3 .. "Logs\aFFFFffff"),
				clr_logstxt_1 = menu_colorpicker("aa", "anti-aimbot angles", "Logs text", 250, 250, 250, 250),

				clr_logsglow = menu_label("aa", "anti-aimbot angles", c3 .. "Logs glow\aFFFFffff"),
				clr_logsglow_1 = menu_colorpicker("aa", "anti-aimbot angles", "Logs glow", 250, 250, 250, 250),

				label_arrows = menu_label("aa", "anti-aimbot angles", menu.clr.grey2 .. "[" .. menu.clr.main .. " Arrows " .. menu.clr.grey2 .. "] " .. menu.clr.grey2 .. "-> "),
				clr_arrow_active = menu_label("aa", "anti-aimbot angles", c3 .. "Active color\aFFFFffff"),
				clr_arrow_active_1 = menu_colorpicker("aa", "anti-aimbot angles", "Active color", 250, 250, 250, 250),
			},
		}
	end

	if m == "Misc" then
		c1 = menu:draw_clr_txt("[", "MISC", "]")

		gui[m] = {
			label = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "<" .. menu.clr.grey2 .. "------------------" .. menu.clr.txt .. " Misc " .. menu.clr.grey2 .. "------------------" .. menu.clr.main .. ">"),
			clantag = menu_checkbox("aa", "anti-aimbot angles", c1 .. "Enable Astral clantag"),
			animations = menu_multiselect("aa", "anti-aimbot angles", c1 .. "Animation breakers", {"Static legs", "Static legs in air", "0 Pitch on land", "Moonwalk"}),
			defensive = menu_combobox("aa", "anti-aimbot angles", c1 .. "Defensive", {"-", "Always", "Dynamic", "Peek logic"}),
			kill_death_say = menu_multiselect("aa", "anti-aimbot angles", c1 .. "Kill and Death say", {"Headshot", "Baim"}),
			nade_fix = menu_multiselect("aa", "anti-aimbot angles", c1 .. "nade fix (malva)", {"when holding nade", "when pin is pulled"}),
			console_logs = menu_multiselect("aa", "anti-aimbot angles", c1 .. "Console logs", {"Shot information", "Anti-Aim data", "Configurations"}),
		}
	end

	if m == "Settings" then
		gui[m] = {
			label = menu_label("aa", "anti-aimbot angles", menu.clr.main .. "<" .. menu.clr.grey2 .. "-----------------" .. menu.clr.txt .. " Settings " .. menu.clr.grey2 .. "-----------------" .. menu.clr.main .. ">"),
			--export = menu_button("aa", "anti-aimbot angles", menu.clr.main .. "Export configuration", menu.export_settings),
			--import = menu_button("aa", "anti-aimbot angles", menu.clr.main .. "Import configuration", menu.import_settings)
		}
	end

	if m == "Anti-Aim" then
		for u, d in next, menu.aa.category_opt do
			if d == "Default" then
				local color = menu:draw_clr_txt("[", "DEFAULT", "]")
				gui[m][d] = {
					enable = menu_checkbox("aa", "anti-aimbot angles", color .. "Enable Default AA"),
					antiaim = menu_combobox("aa", "anti-aimbot angles", color .. "Method", {"Off", "New", "Custom desync", "Break freestand"}),
					antibf = menu_multiselect("aa", "anti-aimbot angles", color .. "Anti-Bruteforce", {"Jitter"}),

					generate = menu_combobox("aa", "anti-aimbot angles", color .. "Generation method", {"Default", "Medium", "High", "Custom"}),

					main_yaw = menu_slider("aa", "anti-aimbot angles", color .. "Main yaw", -75, 75, 0, true, "", 1),
					yaw_min = menu_slider("aa", "anti-aimbot angles", color .. "Left yaw min", -75, 0, -35, true, "", 1),
					yaw_max = menu_slider("aa", "anti-aimbot angles", color .. "Left yaw max", -75, 0, -44, true, "", 1),
					yaw2_min = menu_slider("aa", "anti-aimbot angles", color .. "Right yaw min", -75, 75, 14, true, "", 1),
					yaw2_max = menu_slider("aa", "anti-aimbot angles", color .. "Right yaw max", -75, 75, 22, true, "", 1),
					fake_min = menu_slider("aa", "anti-aimbot angles", color .. "Fake min", 0, 120, 25, true, "", 1),
					fake_max = menu_slider("aa", "anti-aimbot angles", color .. "Fake max", 0, 120, 75, true, "", 1),

				}
			end
			if d == "Algorithm" then
				for i, j in next, conditions do
					local mode = menu:draw_clr_txt("[", string.upper(conditions[i]), "]")
					cond_to_int[conditions[i]] = i
					if gui[m][d] == nil then gui[m][d] = {} end
					if gui[m][d][i] == nil then gui[m][d][i] = {} end
					
					if j ~= "Global" then
						gui[m][d][i].enable = menu_checkbox("aa", "anti-aimbot angles", mode .. "Enable")
					end
					gui[m][d][i].selector = menu_combobox("aa", "anti-aimbot angles", mode .. "Type", menu.aa.mode)

					for o, k in next, menu.aa.mode do
						if gui[m][d][k] == nil then gui[m][d][k] = {} end
						if k == "Default" then
							if j == "Global" then
								gui[m][d][k][i] = {
									pitch = menu_combobox("aa", "anti-aimbot angles", mode .. "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
									pitch_slider = menu_slider("aa", "anti-aimbot angles", "\nptich", -89, 89, 0),
									yaw_base = menu_combobox("aa", "anti-aimbot angles", mode .. "Yaw base", {"Local view", "At targets"}),
									yaw = menu_slider("aa", "anti-aimbot angles", mode ..  "Yaw", -180, 180, 0),
									jitter_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Yaw", {"Off", "Center", "Offset", "Random", "Skitter"}),
									jitter_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nJitterSlider", -180, 180, 0),
									body_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Body Yaw", {"Off", "Jitter", "Static"}),
									body_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nBodySlider", -180, 180, 0),
								}
							else
								gui[m][d][k][i] = {
									pitch = menu_combobox("aa", "anti-aimbot angles", mode .. "Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
									pitch_slider = menu_slider("aa", "anti-aimbot angles", "\npitich", -89, 89, 0),
									yaw = menu_slider("aa", "anti-aimbot angles", mode ..  "Yaw", -180, 180, 0),
									jitter_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Yaw", {"Off", "Center", "Offset", "Random", "Skitter"}),
									jitter_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nJitterYaw", -180, 180, 0),
									body_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Body Yaw", {"Off", "Jitter", "Static"}),
									body_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nBodyYaw", -180, 180, 0),
								}
							end
						end
					if k == "Custom" then
						if j == "Global" then
							gui[m][d][k][i] = {
								yaw_base = menu_combobox("aa", "anti-aimbot angles", mode .. "Yaw base", {"Local view", "At targets"}),
								yaw = menu_slider("aa", "anti-aimbot angles", mode ..  "Yaw", -180, 180, 0),
								jitter_method = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Method", {"Unchoked", "Tickbase"}),
								jit_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Yaw", {"Off", "Center", "Offset", "Random", "L & R jitter"}),
								jit_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nJitterSlider", -180, 180, 0),
								left = menu_slider("aa", "anti-aimbot angles", mode .. "Left", -180, 180, 0),
								right = menu_slider("aa", "anti-aimbot angles", mode .. "Right", -180, 180, 0),
								fake_mode = menu_combobox("aa", "anti-aimbot angles", mode .. "Fake mode", {"Off", "Jitter", "Static"}),
								left_limit = menu_slider("aa", "anti-aimbot angles", mode .. "Left Limit", 0, 60, 0),
								right_limit = menu_slider("aa", "anti-aimbot angles", mode .. "Right Limit", 0, 60, 0),

							}
						else
							gui[m][d][k][i] = {
								yaw_base = menu_combobox("aa", "anti-aimbot angles", mode .. "Yaw base", {"Local view", "At targets"}),
								yaw = menu_slider("aa", "anti-aimbot angles", mode ..  "Yaw", -180, 180, 0),
								jitter_method = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Method", {"Unchoked", "Tickbase"}),
								jit_yaw = menu_combobox("aa", "anti-aimbot angles", mode .. "Jitter Yaw", {"Off", "Center", "Offset", "Random", "L & R jitter"}),
								jit_yaw_slider = menu_slider("aa", "anti-aimbot angles", "\nJitterSlider", -180, 180, 0),
								left = menu_slider("aa", "anti-aimbot angles", mode .. "Left", -180, 180, -10),
								right = menu_slider("aa", "anti-aimbot angles", mode .. "Right", -180, 180, 10),
								fake_mode = menu_combobox("aa", "anti-aimbot angles", mode .. "Fake mode", {"Off", "Jitter", "Static"}),
								left_limit = menu_slider("aa", "anti-aimbot angles", mode .. "Left Limit", 0, 60, 0),
								right_limit = menu_slider("aa", "anti-aimbot angles", mode .. "Right Limit", 0, 60, 0),
							}
						end
					end
				end
				end
			end
			if d == "Exploits" then
				local color = menu:draw_clr_txt("[", "EXPLOITS", "]")
				local roll = menu:draw_clr_txt("[", "ROLL", "]")
				local fakeflick = menu:draw_clr_txt("[", "FLICK", "]")
				local defensive = menu:draw_clr_txt("[", "DEFENSIVE", "]")

				gui[m][d] = {
					exploits = menu_combobox("aa", "anti-aimbot angles", "\nComboBox", exploits_options),
				}
				for x, i in next, exploits_options do
					if i == "Roll" then
						gui[m][d][i] = {
							enable = menu_checkbox("aa", "anti-aimbot angles", roll .. "Enable Roll"),
							key_roll = menu_hotkey("aa", "anti-aimbot angles", "Roll Key", true),
							yaw = menu_combobox("aa", "anti-aimbot angles", roll .. "Yaw", {"Backwards", "Right", "Left", "Automatic"}),
							yaw_amount = menu_slider("aa", "anti-aimbot angles", "\nSlider Yaw", -180, 180, 0),
							disablers = menu_multiselect("aa", "anti-aimbot angles", roll .. "Roll disablers", conds_disablers),
							mode = menu_multiselect("aa", "anti-aimbot angles", roll .. "Mode", {"Lean", "Insecure pitch"}),
							direction = menu_combobox("aa", "anti-aimbot angles", roll .. "Lean direction", {"Inverter", "Automatic"}),
							key_inverter = menu_hotkey("aa", "anti-aimbot angles", roll .. "Invert key", true),
							left = menu_slider("aa", "anti-aimbot angles", roll .. "Lean amount (left)", 0, 100, 0),
							right = menu_slider("aa", "anti-aimbot angles", roll .."Lean amount (right)", 0, 100, 0),
						}
					end
					if i == "Fake flick" then
						gui[m][d][i] = {
							enable = menu_checkbox("aa", "anti-aimbot angles", fakeflick .. "Enable Fake flick"),
							key_enable = menu_hotkey("aa", "anti-aimbot angles", "Enable key", true),
							mode = menu_combobox("aa", "anti-aimbot angles", fakeflick .. "Detection", {"Manual", "Auto"}),
							label = menu_label("aa", "anti-aimbot angles", fakeflick .. "Invert key"),
							key_invert = menu_hotkey("aa", "anti-aimbot angles", "Invert Key", true),
						}
					end
					if i == "Defensive manipulation" then
						gui[m][d][i] = {
							enable = menu_checkbox("aa", "anti-aimbot angles", defensive .. "Enable defensive manipulation"),
							key_enable = menu_hotkey("aa", "anti-aimbot angles", "Enable key", true),
							disablers = menu_multiselect("aa", "anti-aimbot angles", defensive .. "Disablers", conds_disablers),
							mode = menu_combobox("aa", "anti-aimbot angles", defensive .. "Mode", {"Randomize sides", "Custom"}),
							speed = menu_slider("aa", "anti-aimbot angles", defensive .. "Speed", 0, 10, 3, true, ""),
							fake_jitter = menu_checkbox("aa", "anti-aimbot angles", defensive .. "Fake jitter"),
							left_min = menu_slider("aa", "anti-aimbot angles", defensive .. "Left min", 0, 180, 0, true, "°"),
							left_max = menu_slider("aa", "anti-aimbot angles", defensive .. "Left max", 0, 180, 0, true, "°"),
							right_min = menu_slider("aa", "anti-aimbot angles", defensive .."Right min", 0, 180, 0, true, "°"),
							right_max = menu_slider("aa", "anti-aimbot angles", defensive .."Right max", 0, 180, 0, true, "°"),
							real_jitter = menu_slider("aa", "anti-aimbot angles", defensive .. "Real jitter", 0, 180, 0, true, "°"),
						}
					end
				end
			end
		end
	end
end

local function contains(table, val)
    if #table > 0 then
        for i=1, #table do
            if table[i] == val then
                return true
            end
        end
    end
    return false
end

local function print_log(msg, type)
local enabled = menu_get(gui["Misc"].console_logs, type)
	if enabled then
		print(msg)
	end
end

--###############################################[ CONFIG SYSTEM ]##############################################
local base64 = {}
extract = function(v, from, width)
    return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
end
function base64.makeencoder(alphabet)
    local encoder = {}
    local t_alphabet = {}
    for i = 1, #alphabet do
        t_alphabet[i - 1] = alphabet:sub(i, i)
    end
    for b64code, char in pairs(t_alphabet) do
        encoder[b64code] = char:byte()
    end
    return encoder
end
function base64.makedecoder(alphabet)
    local decoder = {}
    for b64code, charcode in pairs(base64.makeencoder(alphabet)) do
        decoder[charcode] = b64code
    end
    return decoder
end
DEFAULT_ENCODER = base64.makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
DEFAULT_DECODER = base64.makedecoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")

CUSTOM_ENCODER = base64.makeencoder("KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=")
CUSTOM_DECODER = base64.makedecoder("KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=")

function base64.encode(str, encoder, usecaching)
    str = tostring(str)

    encoder = encoder or DEFAULT_ENCODER
    local t, k, n = {}, 1, #str
    local lastn = n % 3
    local cache = {}
    for i = 1, n - lastn, 3 do
        local a, b, c = str:byte(i, i + 2)
        local v = a * 0x10000 + b * 0x100 + c
        local s
        if usecaching then
            s = cache[v]
            if not s then
                s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                        encoder[extract(v, 0, 6)])
                cache[v] = s
            end
        else
            s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                    encoder[extract(v, 0, 6)])
        end
        t[k] = s
        k = k + 1
    end
    if lastn == 2 then
        local a, b = str:byte(n - 1, n)
        local v = a * 0x10000 + b * 0x100
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                   encoder[64])
    elseif lastn == 1 then
        local v = str:byte(n) * 0x10000
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[64], encoder[64])
    end
    return table.concat(t)
end
function base64.decode(b64, decoder, usecaching)
    decoder = decoder or DEFAULT_DECODER
    local pattern = "[^%w%+%/%=]"
    if decoder then
        local s62, s63
        for charcode, b64code in pairs(decoder) do
            if b64code == 62 then
                s62 = charcode
            elseif b64code == 63 then
                s63 = charcode
            end
        end
        pattern = ("[^%%w%%%s%%%s%%=]"):format(string.char(s62), string.char(s63))
    end
    b64 = b64:gsub(pattern, "")
    local cache = usecaching and {}
    local t, k = {}, 1
    local n = #b64
    local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0
    for i = 1, padding > 0 and n - 4 or n, 4 do
        local a, b, c, d = b64:byte(i, i + 3)
        local s
        if usecaching then
            local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
            s = cache[v0]
            if not s then
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                cache[v0] = s
            end
        else
            local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
            s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
        end
        t[k] = s
        k = k + 1
    end
    if padding == 1 then
        local a, b, c = b64:byte(n - 3, n - 1)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
        t[k] = string.char(extract(v, 16, 8), extract(v, 8, 8))
    elseif padding == 2 then
        local a, b = b64:byte(n - 3, n - 2)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
        t[k] = string.char(extract(v, 16, 8))
    end
    return table.concat(t)
end

local configs = {}
configs.validation_key = "aae93c994bd9f81ea4f55ced07e494f3"


-- color: userdata holding "r, g, b, a" as floats (0.0 - 1.0)
configs.convertColorToString = function(color)
	r = math_round(color.r * 255)
	g = math_round(color.g * 255)
	b = math_round(color.b * 255)
	a = math_round(color.a * 255)

    return string.format("%i, %i, %i, %i", r, g, b, a)
end


-- split "str" at "sep" and return a table of the resulting substrings
configs.splitString = function(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-- loop through "tbl" and save content into "saveTbl"
configs.saveTable = function(tbl, saveTbl)
    -- table loop
    for k, v in pairs(tbl) do 
        -- if "v" is a table, call the function again with adjusted arguments, basic recursion
        if type(v) == "table" then
            -- since our value is a table we need to create an empty table
            -- in our "saveTbl" with our key as the name of the table
            saveTbl[k] = {}
            -- call this function again with adjusted arguments
            -- "v" is the table thats being looped over and our newly created table
            -- is the table that the values of "v" get saved in
            configs.saveTable(v, saveTbl[k])
        else
            -- since "v" isnt a table, we can safely assume its a menu element
            -- so get its value and save it in our "saveTbl"
            if string.find(k, "clr") ~= nil then
                if string.find(k, "clr") > 0 and string.find(k, "_1") then
                    v = {
                    	type = "color",
                    	v = {ui.get(v)},
                    }
                else
                    v = ui.get(v)
                end
            else
				v = ui.get(v)
				if type(v) == "table" then
					v = {
						type = "multi",
						v = v
					}
				end
            end
            --print(k .. " " .. json.stringify(v) .. " t: " .. json.stringify(type(v)))
            --v = ui.get
            -- if "v" is of type "userdata", it means that the menu element is a color picker
            -- so get the color and save that to "saveTbl"
            saveTbl[k] = v
        end
    end    
end

-- tbl: values to load, menuElementsTable: table to save values into, should be the table that holds the menu elements, tblName: ignore, just for debugging
configs.loadTable = function(tbl, menuElementsTable, tblName)
    -- set "tblName" to "tblName" if it isnt set
    tblName = tblName or ""
    -- loop through "tbl"
    for k, v in pairs(tbl) do 
        -- same thing as in "saveTable"
        -- if "v" is a table, call the function again with adjusted arguments
		if menuElementsTable[k] == nil then 
			if tonumber(k) then
				if menuElementsTable[tonumber(k)] ~= nil then
					configs.loadTable(v, menuElementsTable[tonumber(k)], tblName .. tonumber(k) .. ".")
				end

				--local newK = conditions_fix[k]
				--configs.loadTable(v, menuElementsTable[tostring(k)], tblName .. tostring(k) .. ".")
				--print(json.stringify(menuElementsTable))
				goto skip

			else
				goto skip 
			end
		end
        if type(v) == "table" then
            if v.type ~= nil then 
                --print(k .. " " .. v.type .. " v: " .. json.stringify(v.v))
        		-- custom table, not a sub menu
        		-- meaning its either a color picker or a multiselect
        		if v.type == "color" then
        			-- yep, color picker
        			local r, g, b, a = unpack(v.v)
                    ui.set(menuElementsTable[k], r, g, b, a)
        		elseif v.type == "multi" then 
        			-- yep, multi select
        			ui.set(menuElementsTable[k], v.v)
        		end
        	else
	            -- our table to loop through becomes "v"
            	-- and the table to save values in becomes the table that has the same name as "km"
            	configs.loadTable(v, menuElementsTable[k], tblName .. k .. ".")
        	end
        else
        -- if the value contains spacebar it should be a color
		if menuElementsTable == nil then goto skip end
		if menuElementsTable[k] == nil then goto skip end

        if string.find(k, "key") ~= nil or string.find(k, "label") ~= nil then
            goto skip
        else
			local test = ui.get(menuElementsTable[k], v)
			if test == nil then goto skip end

			local success, err = pcall(function () ui.set(menuElementsTable[k], v) end)
            --ui.set(menuElementsTable[k], v)
        end
        --print(type(v))
        --if v.type ~= nil then 
        --    print("true")
        --end
		--print("Setting " .. tblName .. k .. " to " .. tostring(v) .. " (prev " .. tostring(menuElementsTable[k]) .. ")")

			::skip::
            
        end      
		::skip::  
    end   
end

configs.clipboard_import = function(self)
    local clipboard_text_length = get_clipboard_text_count( VGUI_System )
    local clipboard_data = ''

  if clipboard_text_length > 0 then
      buffer = ffi.new('char[?]', clipboard_text_length)
      size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)

      get_clipboard_text( VGUI_System, 0, buffer, size )
      clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
  end

  return clipboard_data
end

configs.clipboard_export = function(self, string)
	if string then
		set_clipboard_text(VGUI_System, string, #string)
	end
end

--add to list
local db_configs = database.read("astral_configs") or {}
local cloud_presets = {} 

--array for storing
configs.getConfigNames = function()
	local values = {}

	for cconfig_name, __ in pairs(cloud_presets) do
		table.insert(values, cconfig_name)
	end	
	
	for config_name, _ in pairs(db_configs) do
		table.insert(values, config_name)
	end

	return values
end

configs.getConfigNameForID = function(id)
	return configs.getConfigNames()[id]
end

configs.list = menu_listbox("aa", "anti-aimbot angles", "configs list", function(self)
	--ui.set(configs.config_name, "asd")
	
end)

menu_set_callback(configs.list, function()
	local configID = menu_get(configs.list)
	if configID == nil then return end
	local name = configs.getConfigNameForID(configID + 1)

	menu_set(configs.config_name, name)
end)

--load from web
function init_database()
    if database.read(db_configs) == nil then
        database.write(db_configs, {})
    end

    local user, token = 'github username', 'auth token' -- get from github account settings (lmk if you need help, you probably wont need it unless your repo is private)

    http.get('https://starlua.net/cloud_cfgs/gamesense.json', function(success, response) -- {authorization = {user, token}} < ONLY USE IF YOUR REPO IS PRIVATE
        if not success then
            print('Failed to get presets')
            return
        end

		presets = json.parse(response.body)

        --local db = database.read(db_configs)

        for i, preset in pairs(presets.presets) do
			local name = '*'.. preset.name .. " (" .. preset.update .. ")"
			local config = preset.config
			cloud_presets[name] = config
            --table.insert(cloud_presets, { name = '*'..preset.name .. " (" .. preset.update .. ")", config = preset.config})
        end

        ui.update(configs.list, configs.getConfigNames())
    end) 
end

init_database()

configs.config_name = menu_textbox("aa", "anti-aimbot angles", menu.clr.main .. "Config")

local valueTable = {}

configs.save = menu_button("aa", "anti-aimbot angles", menu.clr.main .. "Save", function(self)
	local txtbox = menu_get(configs.config_name)

    local configID = menu_get(configs.list)
	local name = ""

	if configID ~= nil then 
		name = configs.getConfigNameForID(configID + 1)
		if name == "" then 
			return 
		end
	end
	
	if txtbox == "" then
		return
	end

	local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
	local clr = menu.f.hex_label({r, g, b})
	local w = "\aFFFFffff"

	if name == txtbox then
		-- get stuff
		configs.saveTable(gui, valueTable)
		valueTable[configs.validation_key] = true

		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)

		db_configs[name] = json_config
		visuals:add_to_log("Succesfully " .. clr .. "saved " .. w .. "configuration " .. clr .. name)
		print_log("Succesfully saved configuration " .. name, "Configurations")
	else
		configs.saveTable(gui, valueTable)
		valueTable[configs.validation_key] = true

		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)
	
		db_configs[txtbox] = json_config
		visuals:add_to_log("Succesfully " .. clr .. "created " .. w .. "configuration " .. clr .. name)
		print_log("Succesfully created configuration " .. name, "Configurations")
	end

	database.write("astral_configs", db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
end)


configs.load = ui.new_button("aa", "anti-aimbot angles", "Load", function()
    local configID = menu_get(configs.list)
	if configID == nil then return end

    local name = configs.getConfigNameForID(configID + 1)

	local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
	local clr = menu.f.hex_label({r, g, b})
	local w = "\aFFFFffff"	

    local protected = function()
		local cfg = db_configs[name]

		if cfg == nil then
			cfg = cloud_presets[name]
		end

        local json_config = base64.decode(cfg, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
            error("cannot_find_validation_key")
            return
        end

        json_config = json.parse(json_config)

        if json_config == nil then
            error("wrong_json")
            return
        end

		print_log("Succesfully loaded configuration " .. name, "Configurations")
		visuals:add_to_log("Succesfully " .. clr .. "loaded " .. w .. "configuration " .. clr .. name)
        configs.loadTable(json_config, gui)
    end

    local status, message = pcall(protected)

    if not status then
		print_log("Failed to load configuration " .. name, "Configurations")
		visuals:add_to_log("Failed " .. clr .. "to load " .. w .. "configuration " .. clr .. name)
        print("Failed to load config:", message)
        return
    end
end)

configs.delete = ui.new_button("aa", "anti-aimbot angles", "Delete", function()
    local configID = menu_get(configs.list)
	if configID == nil then return end
	local txtbox = menu_get(configs.config_name)
	local name = configs.getConfigNameForID(configID + 1)

	if name == "" or txtbox == "" or name == nil then
		print_log("Configuration name is empty!", "Configurations")
		return
	end

	if cloud_presets[name] then
		print_log("You can't delete cloud configurations!", "Configurations")
		return
	end

	local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
	local clr = menu.f.hex_label({r, g, b})
	local w = "\aFFFFffff"	
	
	print_log("Succesfully deleted configuration " .. name, "Configurations")
	visuals:add_to_log("Succesfully " .. clr .. "deleted " .. w .. "configuration " .. clr .. name)

	db_configs[name] = nil
	database.write("astral_configs", db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
end)

--update listbox on load
ui.update(configs.list, configs.getConfigNames())

configs.import = menu_button("aa", "anti-aimbot angles", menu.clr.main .. "Import from clipboard", function(self)
	local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
	local clr = menu.f.hex_label({r, g, b})
	local w = "\aFFFFffff"	

    local protected = function()
        local clipboard = text == nil and configs:clipboard_import() or text

        local json_config = base64.decode(clipboard, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
			visuals:add_to_log(clr .. "Failed " .. w .. "to load configuration from clipboard")
			print_log("Failed to load configuration from clipboard", "Configurations")
            error("cannot_find_validation_key")
            return
        end

        json_config = json.parse(json_config)

        if json_config == nil then
			visuals:add_to_log(clr .. "Failed " .. w .. "to load configuration from clipboard")
			print_log("Failed to load configuration from clipboard", "Configurations")
            error("wrong_json")
            return
        end

		visuals:add_to_log("Succesfully " .. clr .. "loaded " .. w .. "configuration from " .. clr .. "clipboard")
		print_log("Succesfully loaded configuration from clipboard", "Configurations")
        configs.loadTable(json_config, gui)

    end

    local status, message = pcall(protected)

    if not status then
		print_log("Failed to load configuration from clipboard", "Configurations")
		visuals:add_to_log(clr .. "Failed " .. w .. "to load configuration from clipboard")
        print("Failed to load config:", message)
        return
    end
end)

configs.export = menu_button("aa", "anti-aimbot angles", menu.clr.main .. "Export to clipboard", function()
    local configID = menu_get(configs.list)
	
	configs.saveTable(gui, valueTable)
	valueTable[configs.validation_key] = true

	local json_config = json.stringify(valueTable)
	
	json_config = base64.encode(json_config, CUSTOM_ENCODER)

	configs:clipboard_export(json_config)	

	local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
	local clr = menu.f.hex_label({r, g, b})
	local w = "\aFFFFffff"	

	visuals:add_to_log("Succesfully " .. clr .. "exported" .. w .. " configuration to " .. clr .. "clipboard")
	print_log("Succesfully exported configuration to clipboard", "Configurations")
end)


--##############################################[ MENU CALLBACKS ]##############################################
menu.f.call = function(x)
	return { menu_reference("aa", "anti-aimbot angles", x) }
end


menu.aa_skeet = {
	pitch = menu.f.call("pitch"),
	base = menu.f.call("yaw base"),
	yaw = menu.f.call("yaw"),
	jitter = menu.f.call("yaw jitter"),
	body = menu.f.call("body yaw"),
	fs = menu.f.call("freestanding body yaw"),
	edge = menu.f.call("edge yaw"),
	freestand = menu.f.call("freestanding"),
	roll = menu.f.call("roll"),
}

menu.refs = {
	pitch = menu.f.call("pitch"),
	base = menu.f.call("yaw base"),
	yaw = menu.f.call("yaw"),
	jitter = menu.f.call("yaw jitter"),
	body = menu.f.call("body yaw"),
	fs = menu.f.call("freestanding body yaw"),
	edge = menu.f.call("edge yaw"),
	freestand = menu.f.call("freestanding"),
	roll = menu.f.call("roll"),
	slowmotion = { menu_reference("aa", "other", "Slow motion") },
	fd = menu_reference("rage", "other", "duck peek assist"),
	dt = { menu_reference("rage", "aimbot", "double tap") },
	hs = { menu_reference("aa", "other", "on shot anti-aim") },
	fl_enabled = menu_reference("aa", "fake lag", "enabled"),
	fl_limit = menu_reference("aa", "fake lag", "limit"),
	leg_movement = menu_reference("aa", "other", "leg movement"),
}

menu.reset = function(bool)
	for x, z in next, menu.aa_skeet do
		menu_setvisible(z[1], bool)
		if z[2] ~= nil then
			menu_setvisible(z[2], bool)
		end
	end
end

local newStr = ""

menu.visiblity = function(self)
	menu.reset(false)
	local category = menu_get(gui.selector)

	--Main
	local isMain = category == "Main"
	--menu_setvisible(gui.info, isMain)

	--add ons
	local isAddOns = category == "Add-Ons"
	pcall(function() menu_setvisible(menu.add_ons.resolver, isAddOns) end)

	--handle anti-aims
	local state = menu_get(gui.aa.state)
	local state_to_int = cond_to_int[state]

	local isAA = category == "Anti-Aim"
	local isDefault = isAA and menu_get(gui.aa.category) == "Default"
	local isBuilder = isAA and menu_get(gui.aa.category) == "Algorithm"
	local isExploits = isAA and menu_get(gui.aa.category) == "Exploits"

	local legitAA = contains(menu_get(gui.aa.keybinds), "Legit AA")
	local edgeYaw = contains(menu_get(gui.aa.keybinds), "Edge-Yaw")
	local freestand = contains(menu_get(gui.aa.keybinds), "Freestand")
	local manualAA = contains(menu_get(gui.aa.keybinds), "Manual AA")

	local isAAMisc = isAA and menu_get(gui.aa.category) == "Misc/Keybinds"
	menu_setvisible(gui.aa.keybinds, isAAMisc)
	menu_setvisible(gui.aa.enhancements, isAAMisc)

	local backstab = contains(menu_get(gui.aa.enhancements), "Anti backstab")

	menu_setvisible(gui.aa.backstab_options, isAAMisc and backstab)
	
	menu_setvisible(gui.aa.hide_keybinds, isAAMisc and legitAA or isAAMisc and edgeYaw or isAAMisc and freestand or isAAMisc and manualAA)
	local showBinds = menu_get(gui.aa.hide_keybinds)

	menu_setvisible(gui.aa.key_legit_aa, isAAMisc and showBinds and legitAA)
	menu_setvisible(gui.aa.key_edge_yaw, isAAMisc and showBinds and edgeYaw)
	menu_setvisible(gui.aa.key_freestand, isAAMisc and showBinds and freestand)
	menu_setvisible(gui.aa.key_left, isAAMisc and showBinds and manualAA)
	menu_setvisible(gui.aa.key_right, isAAMisc and showBinds and manualAA)
	menu_setvisible(gui.aa.key_forward, isAAMisc and showBinds and manualAA)
	menu_setvisible(gui.aa.legitaa_options, isAAMisc and legitAA)
	menu_setvisible(gui.aa.manual_options, isAAMisc and manualAA)
	menu_setvisible(gui.aa.freestand_disablers, isAAMisc and freestand)
	menu_setvisible(gui.aa.freestand_options, isAAMisc and freestand)

	menu_setvisible(gui.label_aa, isAA)
	menu_setvisible(gui.aa.category, isAA)

	--menu_setvisible(menu.aa.presets, isBuilder)
	menu_setvisible(gui.aa.enable, isBuilder)
	menu_setvisible(gui.aa.state, isBuilder and menu_get(gui.aa.enable))

	--visuals
	local visuals = menu_get(gui["Visuals"].selector)

	--i just handle exploits here cuz easier
	menu_setvisible(gui["Anti-Aim"]["Exploits"].exploits, isExploits)

	local roll = gui["Anti-Aim"]["Exploits"]["Roll"]
	local roll_tab = menu_get(gui["Anti-Aim"]["Exploits"].exploits) == "Roll"
	local roll_enabled = isExploits and menu_get(roll.enable) and roll_tab
	menu_setvisible(roll.enable, isExploits and roll_tab)
	menu_setvisible(roll.key_roll, roll_enabled)
	menu_setvisible(roll.yaw, roll_enabled)
	menu_setvisible(roll.yaw_amount, roll_enabled)
	menu_setvisible(roll.disablers, roll_enabled)
	menu_setvisible(roll.mode, roll_enabled)
	menu_setvisible(roll.key_inverter, roll_enabled)
	menu_setvisible(roll.direction, roll_enabled)
	menu_setvisible(roll.left, roll_enabled)
	menu_setvisible(roll.right, roll_enabled)

	local fakeflick = gui["Anti-Aim"]["Exploits"]["Fake flick"]
	local fakeflick_tab = menu_get(gui["Anti-Aim"]["Exploits"].exploits) == "Fake flick"
	local fakeflick_enabled = isExploits and menu_get(fakeflick.enable) and fakeflick_tab
	menu_setvisible(fakeflick.enable, isExploits and fakeflick_tab)
	menu_setvisible(fakeflick.key_enable, isExploits and fakeflick_tab)
	menu_setvisible(fakeflick.mode, isExploits and fakeflick_enabled)
	menu_setvisible(fakeflick.label, fakeflick_enabled)
	menu_setvisible(fakeflick.key_invert, fakeflick_enabled)

	
	local defensive_exploit = gui["Anti-Aim"]["Exploits"]["Defensive manipulation"]
	local defensive_tab = menu_get(gui["Anti-Aim"]["Exploits"].exploits) == "Defensive manipulation"
	local defensive_enabled = isExploits and menu_get(defensive_exploit.enable) and defensive_tab
	menu_setvisible(defensive_exploit.enable, isExploits and defensive_tab)
	menu_setvisible(defensive_exploit.key_enable, isExploits and defensive_tab)
	menu_setvisible(defensive_exploit.disablers, defensive_enabled)
	menu_setvisible(defensive_exploit.mode, isExploits and defensive_enabled)
	menu_setvisible(defensive_exploit.speed, defensive_enabled)
	menu_setvisible(defensive_exploit.fake_jitter, defensive_enabled)
	menu_setvisible(defensive_exploit.left_min, defensive_enabled and menu_get(defensive_exploit.mode) == "Custom")
	menu_setvisible(defensive_exploit.left_max, defensive_enabled and menu_get(defensive_exploit.mode) == "Custom")
	menu_setvisible(defensive_exploit.right_min, defensive_enabled and menu_get(defensive_exploit.mode) == "Custom")
	menu_setvisible(defensive_exploit.right_max, defensive_enabled and menu_get(defensive_exploit.mode) == "Custom")
	menu_setvisible(defensive_exploit.real_jitter, defensive_enabled and menu_get(defensive_exploit.mode) == "Custom")


	for l, m in next, menu.categories do
		if m == "Anti-Aim" then
			for u, d in next, menu.aa.category_opt do
				if d == "Default" then
					for u, n in next, gui[m][d] do
						local enabled = menu_get(gui[m][d].enable)
						local dynamic = menu_get(gui[m][d].antiaim) == "Dynamic"
						menu_setvisible(gui[m][d].enable, isDefault)
						if type(gui[m][d][u]) == "number" then
							menu_setvisible(gui[m][d][u], isDefault and enabled)
						else
							for i, v in next, gui[m][d][u] do
								local automatic = ui.get(gui[m][d][u]["toggle"]["Global"])
								if i ~= "toggle" and i ~= "dynamic" and i ~= "method" then
									if type(v) == "table" then
										local feature = true
										if i == "bfleft" or i == "bfright" then
											feature = contains(ui.get(gui[m][d][u]["options"][ui.get(gui[m][d][u]["state"])]), "Anti BF")
										end
										if i == "jitter" then
											feature = contains(ui.get(gui[m][d][u]["options"][ui.get(gui[m][d][u]["state"])]), "Jitter")
										end
										if i == "yaw" then
											feature = contains(ui.get(gui[m][d][u]["options"][ui.get(gui[m][d][u]["state"])]), "Center")
										end
										if i == "lby" then
											feature = contains(ui.get(gui[m][d][u]["options"][ui.get(gui[m][d][u]["state"])]), "Custom LBY")
										end
										for x, z in next, gui[m][d][u][i] do
											menu_setvisible(z, isDefault and enabled and dynamic and automatic and x == ui.get(gui[m][d][u]["state"]) and feature)
										end
									else
										menu_setvisible(v, isDefault and enabled and dynamic and automatic)
									end
								else
									if type(v) == "table" then
										for x, z in next, gui[m][d][u][i] do
											if x == "Global" then
												menu_setvisible(z, isDefault and enabled and dynamic)
											else
												menu_setvisible(z, isDefault and enabled and dynamic and automatic and x == ui.get(gui[m][d][u]["state"]))
											end
										end
									else
										menu_setvisible(v, isDefault and enabled and dynamic and not automatic)
									end
								end
							end
							menu_setvisible(gui[m][d][u]["state"], isDefault and enabled and dynamic)
						end
					end
				end
				if d == "Algorithm" then	
					for i, j in next, conditions do
						local enabled = j ~= "Global" and menu_get(gui[m][d][i].enable) or false
						local mode = menu_get(gui[m][d][i].selector)
						local active_state = j ~= "Global" and state_to_int == i and isBuilder
						if j ~= "Global" then
							menu_setvisible(gui[m][d][i].enable, state_to_int == i and isBuilder and menu_get(gui.aa.enable))
							active_state = active_state and enabled
						else
							active_state = state_to_int == i and isBuilder
						end

						active_state = active_state and menu_get(gui.aa.enable)
						menu_setvisible(gui[m][d][i].selector, active_state)
						for o, k in next, menu.aa.mode do
							for x, z in next, gui[m][d][k][i] do
								local str = string.find(x, "slider") ~= nil and string.find(x, "slider") > 0
								if str then
									local fixed_string = x:gsub('_slider', '')
									if gui[m][d][k][i][fixed_string] == nil then goto skip end
									local active = menu_get(gui[m][d][k][i][fixed_string]) ~= "Off"
									menu_setvisible(gui[m][d][k][i][x], mode == k and active_state and active)
								else
									menu_setvisible(gui[m][d][k][i][x], mode == k and active_state)
									if gui[m][d][k][i].jit_yaw ~= nil then
										menu_setvisible(gui[m][d][k][i].left, mode == k and active_state and menu_get(gui[m][d][k][i].jit_yaw) == "L & R jitter" and menu_get(gui[m][d][k][i].jit_yaw) ~= "Off")
										menu_setvisible(gui[m][d][k][i].right, mode == k and active_state and menu_get(gui[m][d][k][i].jit_yaw) == "L & R jitter" and menu_get(gui[m][d][k][i].jit_yaw) ~= "Off")
										menu_setvisible(gui[m][d][k][i].jit_yaw_slider, mode == k and active_state and menu_get(gui[m][d][k][i].jit_yaw) ~= "L & R jitter" and menu_get(gui[m][d][k][i].jit_yaw) ~= "Off")
									end
									if gui[m][d][k][i].pitch ~= nil then
										menu_setvisible(gui[m][d][k][i].pitch_slider, mode == k and active_state and menu_get(gui[m][d][k][i].pitch) == "Custom")
									end
									if gui[m][d][k][i].fake_mode ~= nil then
										menu_setvisible(gui[m][d][k][i].left_limit, mode == k and active_state and menu_get(gui[m][d][k][i].fake_mode) ~= "Off")
										menu_setvisible(gui[m][d][k][i].right_limit, mode == k and active_state and menu_get(gui[m][d][k][i].fake_mode) ~= "Off")
									end

								end
								::skip::
							end
						end
					end
				end

			end
		else
			for c, o in next, gui[m] do
				if type(gui[m][c]) == "table" then 
					for v, x in next, gui[m][c] do
						local active = category == m and visuals:lower() == c
						menu_setvisible(gui[m][c][v], category == m and active)
					end
				else
					menu_setvisible(gui[m][c], category == m)
				end
			end
		end
	end

	if menu_get(gui["Anti-Aim"]["Default"].antiaim) == "Break freestand" then
		menu_setvisible(gui["Anti-Aim"]["Default"].generate, false)
	end
	local settings = menu_get(gui.selector) == "Settings"

	menu_setvisible(configs.list, settings)
	menu_setvisible(configs.config_name, settings)
	menu_setvisible(configs.save, settings)
	menu_setvisible(configs.load, settings)
	menu_setvisible(configs.delete, settings)

	menu_setvisible(configs.import, settings)
	menu_setvisible(configs.export, settings)

	local visuals_active = menu_get(gui.selector) == "Visuals"
	local clr_center_indicator = menu_get(gui["Visuals"].indicators.center) == "Simple" and menu_get(gui["Visuals"].colors.options) == "Center indicators" and menu_get(gui["Visuals"].selector) == "Colors"

	menu_setvisible(gui["Visuals"].indicators.center_height, visuals_active and menu_get(gui["Visuals"].indicators.center) == "Simple" and menu_get(gui["Visuals"].colors.options) == "Center indicators" and menu_get(gui["Visuals"].selector) == "Indicators")


	menu_setvisible(gui["Visuals"].colors.clr_lua_name, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_lua_name_1, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_lua_name2, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_lua_name2_1, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_DEV, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_DEV_1, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_state, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_state_1, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_dt, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_dt_1, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_dtcircle, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_dtcircle_1, visuals_active and clr_center_indicator)

	menu_setvisible(gui["Visuals"].colors.clr_os, visuals_active and clr_center_indicator)
	menu_setvisible(gui["Visuals"].colors.clr_os_1, visuals_active and clr_center_indicator)

	menu_setvisible(gui["Visuals"].colors.label_warn, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Warnings") and menu_get(gui["Visuals"].colors.options) == "Center indicators")
	menu_setvisible(gui["Visuals"].colors.clr_warnings, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Warnings") and menu_get(gui["Visuals"].colors.options) == "Center indicators")
	menu_setvisible(gui["Visuals"].colors.clr_warnings_1, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Warnings") and menu_get(gui["Visuals"].colors.options) == "Center indicators")

	menu_setvisible(gui["Visuals"].colors.label_logs, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Logs") and menu_get(gui["Visuals"].colors.options) == "Center indicators")
	menu_setvisible(gui["Visuals"].colors.clr_logstxt, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Logs") and menu_get(gui["Visuals"].colors.options) == "Center indicators")
	menu_setvisible(gui["Visuals"].colors.clr_logstxt_1, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Logs") and menu_get(gui["Visuals"].colors.options) == "Center indicators")

	menu_setvisible(gui["Visuals"].colors.clr_logsglow, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Logs") and menu_get(gui["Visuals"].colors.options) == "Center indicators")
	menu_setvisible(gui["Visuals"].colors.clr_logsglow_1, visuals_active and menu_get(gui["Visuals"].selector) == "Colors" and contains(menu_get(gui["Visuals"].indicators.additional), "Logs") and menu_get(gui["Visuals"].colors.options) == "Center indicators")


	local show_arrows = visuals_active and contains(menu_get(gui["Visuals"].indicators.additional), "Arrows") and menu_get(gui["Visuals"].selector) == "Indicators"
	menu_setvisible(gui["Visuals"].indicators.arrows_padding, show_arrows)
	menu_setvisible(gui["Visuals"].indicators.arrows_height, show_arrows)
	menu_setvisible(gui["Visuals"].indicators.arrow_options, show_arrows)

	local clr_arrows = contains(menu_get(gui["Visuals"].indicators.additional), "Arrows") and menu_get(gui["Visuals"].selector) == "Colors"

	menu_setvisible(gui["Visuals"].colors.label_arrows, visuals_active and clr_arrows)
	menu_setvisible(gui["Visuals"].colors.clr_arrow_active, visuals_active and clr_arrows)
	menu_setvisible(gui["Visuals"].colors.clr_arrow_active_1, visuals_active and clr_arrows)


	local clr_esp = menu_get(gui["Visuals"].indicators.esp) == "Above head" and menu_get(gui["Visuals"].colors.options) == "Ragebot" and menu_get(gui["Visuals"].selector) == "Colors"
	menu_setvisible(gui["Visuals"].colors.label_rage, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_prefer, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_prefer_1, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_safepoint, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_safepoint_1, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_safepointprefer, visuals_active and clr_esp)
	menu_setvisible(gui["Visuals"].colors.clr_safepointprefer_1, visuals_active and clr_esp)

	local ragebot = menu_get(gui.selector) == "Ragebot"
	menu_setvisible(gui["Ragebot"].prefers_options, ragebot)
	menu_setvisible(gui["Ragebot"].sp_options, ragebot)

	menu_setvisible(gui["Ragebot"].prefers_after_x, ragebot and contains(menu_get(gui["Ragebot"].prefers_options), "After X misses"))
	menu_setvisible(gui["Ragebot"].sp_after_x, ragebot and contains(menu_get(gui["Ragebot"].sp_options), "After X misses"))

	menu_setvisible(gui["Ragebot"].prefers_lower_than, ragebot and contains(menu_get(gui["Ragebot"].prefers_options), "HP lower than X"))
	menu_setvisible(gui["Ragebot"].sp_lower_than, ragebot and contains(menu_get(gui["Ragebot"].sp_options), "HP lower than X"))

	local def_aa_active = menu_get(gui.selector) == "Anti-Aim" and menu_get(gui.aa.category) == "Default" and menu_get(gui["Anti-Aim"]["Default"].generate) == "Custom" and menu_get(gui["Anti-Aim"]["Default"].enable) and menu_get(gui["Anti-Aim"]["Default"].antiaim) ~= "Off"

	menu_setvisible(gui["Anti-Aim"]["Default"].main_yaw, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].yaw_min, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].yaw_max, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].yaw2_min, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].yaw2_max, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].fake_min, def_aa_active)
	menu_setvisible(gui["Anti-Aim"]["Default"].fake_max, def_aa_active)
end

menu.anim = 0
menu.delay = 0

menu.animate = function(self, abc, wasd)
	local a = menu.clr.txt2 .. "ROMANCE"
	local b = menu.clr.main .. " " .. build
	menu.delay = menu.delay + 1
	if menu.delay > 77 then
		menu.delay = 0
	end
	if menu.delay == 0 then
		menu.anim = menu.anim + 1
	end
	if menu.anim > 7 then
		menu.anim = 0
	end
	if menu.anim == 1 then
		a = menu.clr.txt2 .. "ROMANCE"
	end
	if menu.anim == 2 then
		a = menu.clr.main .. "R" .. menu.clr.txt2 .. "OMANCE"
	end
	if menu.anim == 3 then
		a = menu.clr.txt2 .. "R" .. menu.clr.main .. "O" .. menu.clr.txt2 .. "OMA"
	end
	if menu.anim == 4 then
		a = menu.clr.txt2 .. "RO" .. menu.clr.main .. "M" .. menu.clr.txt2 .. "NCE"
	end
	if menu.anim == 5 then
		a = menu.clr.txt2 .. "ROM" .. menu.clr.main .. "A" .. menu.clr.txt2 .. "CE"
	end
	if menu.anim == 6 then
		a = menu.clr.txt2 .. "ROMA" .. menu.clr.main .. "N" .. menu.clr.txt2 .. "E"
	end
	if menu.anim == 7 then
		a = menu.clr.txt2 .. "ROMAN" .. menu.clr.main .. "C"
	end
	ui.set(abc, a .. b)
end

helpers.clamp = function(self, val, min_val, max_val)
	return math_max(min_val, math_min(max_val, val))
end

helpers.round = function(self, num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

helpers.normalize_yaw = function(self, yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

helpers.calc_angle = function(self, local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = self:normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = self:normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end


helpers.TICKS_TO_TIME = function(self, ticks)
	return globals.tickinterval() * ticks;
end

helpers.extrapolateTick = function(self, entity, ticks)
	local VelX,VelY,VelZ = entity_get_prop(entity, 'm_vecVelocity')

	--local position = entity:GetProp("DT_BaseEntity", "m_vecOrigin")
	local px, py, pz = entity_hitbox_position(entity, 0)
	
	return {
		px + VelX * (self:TICKS_TO_TIME(ticks)), 
		py + VelY * (self:TICKS_TO_TIME(ticks)), 
		pz + VelZ * (self:TICKS_TO_TIME(ticks))
	}
end

helpers.calcangle = function(self, localplayerxpos, localplayerypos, enemyxpos, enemyypos)
	local relativeyaw = math.atan( (localplayerypos - enemyypos) / (localplayerxpos - enemyxpos) )
	return relativeyaw * 180 / math.pi
end

helpers.angle_vector = function(self, angle_x, angle_y)
	local sp, sy, cp, cy = nil
	sy = math.sin(math.rad(angle_y));
	cy = math.cos(math.rad(angle_y));
	sp = math.sin(math.rad(angle_x));
	cp = math.cos(math.rad(angle_x));
	return cp * cy, cp * sy, -sp;
end

--############################## EXPLOITS ###################################
exploits.sim_cache = {}
exploits.data = {
	shift = 0,
	charged = false,
	update = false,
	manual_shot = 0,
	shot = 0,
}

exploits.dt_charged = function(self)
	local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])
	local shiftedTicks = 0

	if dt_on then
		--if self.data.update then			
			for i = 1, #self.sim_cache do
				shiftedTicks = shiftedTicks + self.sim_cache[i]
		--	end 
		--else
		--	shiftedTicks = 100
		end
	else
		shiftedTicks = 0
		self.data.shift = 0
		self.data.charged = false
		exploits.data.update = true
	end

	if self.data.charged == false then
		self.data.shift = shiftedTicks
	end

	if shiftedTicks >= 100 and self.data.charged == false  then
		self.data.shift = 100
		self.data.charged = true
		self.data.update = false
	end

	if self.data.shot + 0.5 > globals_curtime() or self.data.manual_shot + 0.5 > globals_curtime() then
		self.data.shift = 0
		self.data.charged = false
		self.data.update = true
		shiftedTicks = 0
	end
end

exploits.simtimeAverage = function(self)
	local localPlayer = entity_get_local_player()
	if localPlayer == nil then return end
    local sim_time = entity.get_prop(localPlayer, "m_flSimulationTime")

	if (sim_time and type(sim_time) == "number") then
        table.insert(self.sim_cache, math.abs(sim_time / globals.tickinterval() - globals.tickcount()))

        if (#self.sim_cache > 8) then
            table.remove(self.sim_cache, 1)
        end
    end
end

--############################## ENTITY ###################################
entity.get_local = function(self)
	local player = entity_get_local_player()
	if player == nil or not entity_is_alive(player) then
		player = nil
	end
	return player
end

entity.get_velocity = function(self, player)
	if player == nil then return end
	local x,y,z = entity_get_prop(player, 'm_vecVelocity')
	return math_sqrt(x*x + y*y + z*z)
end

local esp = {
	player = {}
}

entity.has_height = function(self, ent, me)
	local ex, ey, ez = entity_get_prop(ent, "m_vecOrigin")
	local lx, ly, lz = entity_get_prop(me, "m_vecOrigin")

	local eh = math_floor(math_abs(ez))
	local lh = math_floor(math_abs(lz))

	local max_distance = 85

	esp.player[ent].height = eh + max_distance < lh

	return eh + max_distance < lh
end

entity.baim_hitboxes = {3,4,5,6}
entity.extrapolate_position = function(self, xpos,ypos,zpos,ticks,player)
	local x,y,z = entity_get_prop(player, "m_vecVelocity")
	for i = 0, ticks do
		xpos =  xpos + (x * globals_tickinterval())
		ypos =  ypos + (y * globals_tickinterval())
		zpos =  zpos + (z * globals_tickinterval())
	end
	return xpos,ypos,zpos
end

entity.is_baimable = function(self, ent, me)	
	local final_damage  = 0

	local eyepos_x, eyepos_y, eyepos_z = client_eye_position()
	local fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z

	eyepos_x, eyepos_y, eyepos_z = self:extrapolate_position(eyepos_x, eyepos_y, eyepos_z, 20, me)

	fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z = eyepos_x, eyepos_y, eyepos_z
	for k,v in pairs(self.baim_hitboxes) do
		local hitbox    = vector(entity_hitbox_position(ent, v))
		local ___, dmg  = client_trace_bullet(me, fs_stored_eyepos_x, fs_stored_eyepos_y, fs_stored_eyepos_z, hitbox.x, hitbox.y, hitbox.z, true)

		if ( dmg > final_damage) then
			final_damage = dmg
		end
	end

	return final_damage
end

entity.baim_lethal = function(self, ent, me)
    local weapon    = entity_get_player_weapon(me)
    local players   = entity_get_players()

    if weapon == nil then return false end
	
	local target_health = entity_get_prop(ent, "m_iHealth") 
	local is_lethal     = self:is_baimable(ent, me) >= target_health

	if ( target_health <= 0 ) then return end

	return is_lethal
end

entity.baim_high_vel = function(self, ent)
	local velocity = self:get_velocity(ent)
	return velocity > 300
end

entity.miss = {}
entity.after_missed = function(self, ent, max)
	return entity.miss[ent].missed >= max
end

entity.land_delay = 0
entity.cur_state = "Global"
entity.state = function(self)
	-- {"Global", "Stand", "Slow", "Move", "Air", "Duck"}

	debug.get_state = "entity:get_state() -> L575"
	local player = self:get_local()

	if player == nil then return end

	local vel = self:get_velocity(player)
	local on_ground = bit_band(entity_get_prop(player, "m_fFlags"), 1) == 1
	local stand = on_ground and vel < 1.2
	local slowwalk = menu_get(menu.refs.slowmotion[1]) and menu_get(menu.refs.slowmotion[2])
	local move = on_ground and vel > 3 and not slowwalk
	local in_air = bit_band(entity_get_prop(player, "m_fFlags"), 1) == 0
	local ducking = entity_get_prop(player, "m_flDuckAmount") > 0.7

	if in_air then
		if ducking then
			entity.land_delay = globals_curtime() + 0.25
			entity.cur_state = "Air+Duck"
		else
			entity.land_delay = globals_curtime() + 0.25
			entity.cur_state = "Air"

		end
	end
	if entity.land_delay < globals_curtime() then
		if stand then
			entity.cur_state = "Stand"
		end
		if slowwalk then
			entity.cur_state = "Slow"
		end
		if move then
			entity.cur_state = "Move"
		end
		if ducking then
			entity.cur_state = "Duck"
		end
	end
	return entity.cur_state
end

entity.canEnemyHitUsPeek = function(self, ent, ticks)
    if ent == nil then
        return
    end

	local localPlayer = entity_get_local_player()
	
	if localPlayer == nil then
		return
	end
	
    local ox, oy, oz = entity_hitbox_position(ent, 0)
    local o2x, o2y, o2z = entity_hitbox_position(localPlayer, 0)
	
    if ox == nil or o2x == nil then
        return
    end

	local local_vel = self:get_velocity(localPlayer)
	--local oScrn = Render.ScreenPosition(origin2)
    local canHitUs = false
	
    --for i = 1, ticks do

	local trace = 0

	extrapolatedPosition = helpers:extrapolateTick(ent, ticks)

	positionX, positionY = render_world_to_screen(extrapolatedPosition[1], extrapolatedPosition[2], extrapolatedPosition[3])
	local fraction, entindex_hit = client_trace_line(localPlayer, o2x, o2y, o2z, extrapolatedPosition[1], extrapolatedPosition[2], extrapolatedPosition[3])

	oScrnX, oscrnY = render_world_to_screen(o2x, o2y, o2z)

        if fraction > 0.7 then
            canHitUs = true
        end

	-- debug code
			if fraction > 0.7 then
				renderer.line(oScrnX, oscrnY, positionX, positionY, 255, 0, 0, 255)
			else
				renderer.line(oScrnX, oscrnY, positionX, positionY, 0, 255, 0, 255)
			end
		-- Render.Text(string.format("d: %.2f", trace.damage), position, Color.new(1.0, 1.0, 1.0, 1.0), 8)
    return canHitUs
end

--############################## ANTI-AIM ################################

--fake flick
aa.micromovements_fake_flick = function(self, cmd, player)
    local velocity = math_floor(entity:get_velocity(player))

    local m_fFlags = entity_get_prop(player, "m_fFlags")
    local duck = entity_get_prop(player, "m_flDuckAmount") > 0.7

    local on_ground = bit_band(m_fFlags, bit_lshift(1, 0)) == 1

    --we dont rly need the vel check but lets just have it
    local micro = globals.tickcount() % 10
	local w, a, s, d = cmd.in_forward == 1, cmd.in_moveleft == 1, cmd.in_moveright == 1, cmd.in_back == 1

    if not on_ground then return end
    if w or a or s or d then return end

	local amount = duck and 3.25 or 5.1

	if micro > 0 and micro < 5 then
		cmd.sidemove = amount
	elseif micro > 5 then
		cmd.sidemove = -amount
	end
    --if velocity < 1.1 then
end

aa.fake_flick = function(self, cmd)
	--force aa off
	if menu_get(gui["Anti-Aim"]["Exploits"]["Fake flick"].enable) and menu_get(gui["Anti-Aim"]["Exploits"]["Fake flick"].key_enable) then
		local me = entity_get_local_player()
		if me == nil then return end

		local vel = entity:get_velocity(me)
		local count = globals.tickcount()

		local can_desync = self:can_desync(cmd, me, count, vel)
		
		local choke = self:get_choke(cmd)

		local pitch, yaw2 = client.camera_angles()
		local current_player = client.current_threat()
		
		local _, yaw = self:at_targets(current_player)

		local hs_on = menu_get(menu.refs.hs[2]) and menu_get(menu.refs.hs[1])
		local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])


		if not hs_on then
			cmd.allow_send_packet = false
		end
	

		self:micromovements_fake_flick(cmd, entity:get_local())

		if menu_get(gui["Anti-Aim"]["Exploits"]["Fake flick"].mode) == "Auto" then
			self:get_freestand(cmd)
			switch = self.fs_data.side == 1
		else
			switch = menu_get(gui["Anti-Aim"]["Exploits"]["Fake flick"].key_invert)
		end


		if can_desync then
			if choke then
			--handle micromovements
				if hs_on then
					cmd.allow_send_packet = false
				end
	
				self.c_store.jitter = not self.c_store.jitter
				if self.c_store.jitter then
					self.c_store.yaw = -120
				else
					self.c_store.yaw = 120
				end

			else
				--self.c_store.yaw = math.sin(globals_curtime() * menu_get(speed)) * menu_get(dist) - 15
				if switch then
					self.c_store.yaw = 15
				else
					self.c_store.yaw = -15
				end
			end

			if globals.tickcount() % 25 < 2 then
				--self.c_store.yaw = 75 good against nl
				if switch then
					self.c_store.yaw = -65
				else
					self.c_store.yaw = 65
				end
			end
			
			cmd.pitch = 89
			cmd.yaw = yaw + self.c_store.yaw
		end
	end
end

-- needs fixing
aa.micromovements = function(self, cmd, player)
	local active_wpn = entity_get_player_weapon(player)
	if active_wpn == nil then return end

	local weapon = entity_get_classname(active_wpn)
	if weapon == nil then return end

	if weapon:find("Grenade") then
		return
	end

	local velocity = math_floor(entity:get_velocity(player))
    local m_fFlags = entity_get_prop(player, "m_fFlags")
    local duck = entity_get_prop(player, "m_flDuckAmount") > 0.7

    local on_ground = bit_band(m_fFlags, bit_lshift(1, 0)) == 1

    --we dont rly need the vel check but lets just have it
    local micro = globals.tickcount() % 2 == 0
	local w, a, s, d = cmd.in_forward == 1, cmd.in_moveleft == 1, cmd.in_moveright == 1, cmd.in_back == 1

    if not on_ground then return end
    if w or a or s or d then return end

	local amount = duck and 3.25 or 1.1
    if velocity < 1.1 then
		debug.micromove = "antiaim:micromove() -> L855"
        cmd.sidemove = micro and amount or -amount;
    end
end

aa.get_desync_side = function()
	local player = entity:get_local()

	local desync_type = entity_get_prop(player, 'm_flPoseParameter', 11) * 120 - 60
	local desync_side = desync_type > 0 and true or false
	return desync_side
end

aa.skeet_builder = function(self, path)
	--have to be forced always, so lets grab from global
	local yaw_base	 		= menu_get(gui["Anti-Aim"]["Algorithm"]["Default"][1].yaw_base)

	local pitch 			= menu_get(path.pitch)
	local pitch_slider		= menu_get(path.pitch_slider)
	local yaw 		 		= menu_get(path.yaw)
	local jitter_yaw 		= menu_get(path.jitter_yaw)
	local jitter_yaw_slider = menu_get(path.jitter_yaw_slider)
	local body_yaw			= menu_get(path.body_yaw)
	local body_yaw_slider	= menu_get(path.body_yaw_slider)

	local desync_side = self:get_desync_side()


	menu_set(menu.refs.yaw[2], yaw)

	--force aa on
	menu_set(menu.refs.pitch[1], pitch)
	menu_set(menu.refs.pitch[2], pitch_slider)
	menu_set(menu.refs.yaw[1], "180")
	menu_set(menu.refs.base[1], yaw_base)
	menu_set(menu.refs.jitter[1], jitter_yaw)
	menu_set(menu.refs.jitter[2], jitter_yaw_slider)
	menu_set(menu.refs.body[1], body_yaw)
	menu_set(menu.refs.body[2], body_yaw_slider)
	--menu_set(menu.refs.limit[1], limit)
end

local delays = {
	choked = 0,
	mouse1 = 0,
	dt = 0,
	dt2 = 0,
}

aa.disablers = {
	at_targets_builder = false,
	at_targets = true,
	manual_yaw = 0,
	legit_aa = false,
	anti_backstab = false,
}

aa.n_cache = {
	nade = 0,
	on_ladder = false,
	holding_nade = false
}

aa.run_command_check = function()
	local me = entity_get_local_player()
	if me == nil then return end

	aa.n_cache.on_ladder = entity_get_prop(me, "m_MoveType") == 9 
end


aa.nade_check = function(self, weapon, cmd)
	local pin_pulled = entity_get_prop(weapon, "m_bPinPulled")
	local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])

	if pin_pulled ~= nil then
		if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
			local throw_time = entity_get_prop(weapon, "m_fThrowTime")
			local check = dt_on and throw_time > globals_curtime() or throw_time < globals_curtime()
			if throw_time ~= nil and throw_time > 0 and check then
				local wpnclass = entity_get_classname(weapon)
				self.n_cache.holding_nade = wpnclass:find("Grenade")
				return true
			end
		end
	end
	return false
end

aa.can_desync = function(self, cmd, ent, count, vel)
	debug.can_desync = nil
	if self.disablers.anti_backstab then return end
	if self.var.fs_true and self.keys.disable_fs then return end

	local weapon = entity_get_player_weapon(ent)
	if weapon == nil then return end
	local srv_time = entity_get_prop(ent, "m_nTickBase") * globals.tickinterval()
	local wpnclass = entity_get_classname(weapon)

	local nade_fix = menu_get(gui["Misc"].nade_fix)
	local pin = entity.get_prop(weapon, "m_bPinPulled")

	if contains(nade_fix, "when holding nade") then
		if wpnclass:find("Grenade") then return end
	end

	if contains(nade_fix, "when pin is pulled") then
		if pin == 1 then return end
	end

	if wpnclass:find("Grenade") == nil and cmd.in_attack == 1 and srv_time > entity.get_prop(weapon, "m_flNextPrimaryAttack") - 0.1 and entity_get_classname(weapon) ~= "CC4" then return end

	if self:nade_check(weapon, cmd) then return end
	if entity_get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then return false end
	if self.n_cache.on_ladder and vel ~= 0 then return false end
	if cmd.in_use == 1 then return false end
	
	debug.can_desync = "antiaim:can_desync() -> L790"

	return true
end

aa.can_shift_shot = function(self, cmd, ticks)
	local me = entity_get_local_player()

	if me == nil then return end
	local wpn = entity_get_player_weapon(me)

	if wpn == nil then return end
	
	local tickbase = entity_get_prop(me, "m_nTickBase")
	local curtime = globals.tickinterval() * (tickbase-ticks)

	if curtime < entity_get_prop(me, "m_flNextAttack") then
		return false
	end

	local weapon_id = bit_band(entity_get_prop(wpn, "m_iItemDefinitionIndex"), 0xFFFF)

	if weapon_id ~= 40 and curtime < entity_get_prop(wpn, "m_flNextPrimaryAttack") then
		return false
	end
	return true
end

aa.get_choke = function(self, cmd)
    local fakelag = menu_get(menu.refs.fl_limit)

	local check_fakelag = fakelag % 2 == 1

    local choked = cmd.chokedcommands
    local check_choke = choked % 2 == 0

	local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])
	local hs_on = menu_get(menu.refs.hs[2]) and menu_get(menu.refs.hs[1])
	local fd_on = menu_get(menu.refs.fd)

	local vel = entity:get_velocity(entity:get_local())
	if dt_on then
		if delays.choked > 2 then
			if cmd.chokedcommands >= 0 then
				check_choke = false
			end
		end
	end

	delays.choked = cmd.chokedcommands

	if delays.dt ~= dt_on then
		delays.dt2 = globals_curtime() + 0.25
	end

	if not dt_on and not hs_on and not cmd.no_choke or fd_on then
        if not check_fakelag then
			if delays.dt2 > globals_curtime() then
				if cmd.chokedcommands >= 0 and cmd.chokedcommands < fakelag then
					check_choke = choked % 2 == 0
				else
					check_choke = choked % 2 == 1
				end
			else
				check_choke = choked % 2 == 1
			end
        end
    end
	
	delays.dt = dt_on
	return check_choke
end

aa.set_gs_preset = function(self, yaw, jitter)
	if yaw == nil then yaw = 0 end
	local ref = menu.refs
	menu_set(ref.pitch[1], "Down")
	menu_set(ref.base[1], "At targets")
	menu_set(ref.yaw[1], "180")
	menu_set(ref.yaw[2], yaw)
	menu_set(ref.body[1], jitter and "Jitter" or "Static")
	menu_set(ref.body[2], 0)
	menu_set(ref.jitter[1], jitter and "Center" or "Off")
	menu_set(ref.jitter[2], jitter and 64 or 0)
	menu_set(ref.fs[1], false)

end

aa.legit_aa_preset = function(self, jitter, at_targets)
	local ref = menu.refs
	menu_set(ref.pitch[1], "Off")
	menu_set(ref.base[1], at_targets and "At targets" or "Local view")
	menu_set(ref.yaw[1], at_targets and "180" or "Off")
	menu_set(ref.yaw[2], at_targets and 180 or 0)
	menu_set(ref.jitter[1], "Off")
	menu_set(ref.jitter[2], 0)
	menu_set(ref.body[1], jitter and "Jitter" or "Opposite")
	menu_set(ref.body[2], 0)
	menu_set(ref.fs[1], jitter and false or true)
	menu_set(ref.roll[1], 0)
end

aa.can_defuse = function(self)
	local me = entity_get_local_player()
	if entity_get_prop(me, "m_iTeamNum") ~= 3 then
		return false
	end

	local lx, ly = entity_get_origin(me)
	local c4 = entity_get_all("CPlantedC4")

	for index, ent in ipairs(c4) do
		local x, y = entity_get_origin(ent)
		local distance = math_sqrt((lx-x)^2 + (ly-y)^2)
		if distance < 128 then
			return true
		end
	end
	return false
end

aa.legit_aa = function(self, cmd)
	local me = entity_get_local_player()
	if me == nil then return end

	local weaponn = entity_get_player_weapon()
	local can_defuse = self:can_defuse()

	if not can_defuse then
		local jitter = menu_get(gui.aa.legitaa_options) == "Jitter"
		self:legit_aa_preset(jitter)
		self.disablers.legit_aa = true
		if weaponn ~= nil and entity_get_classname(weaponn) == "CC4" then
			if cmd.in_attack == 1 then
				cmd.in_attack = 0 
				cmd.in_use = 1
			end
		else
			if cmd.chokedcommands == 0 then
				cmd.in_use = 0
			end
		end
	end
end

aa.keybind_active = false
aa.freestand_key = { 
	["0"] = "Always on",
	["1"] = "On hotkey",
	["2"] = "Toggle",
	["3"] = "Off hotkey"
}

aa.var = {
	aa_dir = 0,
	last_press_t = 0,
	last_fs = 0,
	fs_true = false,
}

aa.keys = {
	stored_fs = false,
	stored_left = false,
	stored_right = false,
	stored_forward = false,
	disable_fs = false,
}

local reset_once = false
--menu_set(menu.refs.freestand[1], )
menu_set(menu.refs.freestand[2], "Toggle")

aa.handle_keybinds = function(self, cmd)
	local legitAA = contains(menu_get(gui.aa.keybinds), "Legit AA")
	local edgeYaw = contains(menu_get(gui.aa.keybinds), "Edge-Yaw")
	local freestand = contains(menu_get(gui.aa.keybinds), "Freestand")
	local manualAA = contains(menu_get(gui.aa.keybinds), "Manual AA")

	local legitaa_active = { menu_get(gui.aa.key_legit_aa) }
	local edge_active = menu_get(gui.aa.key_edge_yaw)
	local freestand_active = { menu_get(gui.aa.key_freestand) }
	local left_active = menu_get(gui.aa.key_left)
	local right_active = menu_get(gui.aa.key_right)
	local forward_active = menu_get(gui.aa.key_forward)

	local fs_test = {menu_get(gui.aa.key_freestand) }
	local man_left = {menu_get(gui.aa.key_left) }
	local man_right = {menu_get(gui.aa.key_right) }
	local man_forward = {menu_get(gui.aa.key_forward) }

	--menu_set(gui.aa.key_freestand, "On hotkey")
	--menu_set(gui.aa.key_left, "On hotkey")
	--menu_set(gui.aa.key_right, "On hotkey")
	--menu_set(gui.aa.key_forward, "On hotkey")

	local manual_active = left_active or right_active or forward_active

	if legitAA then
		if legitaa_active[1] then
			self:legit_aa(cmd)
		else
			reset_once = true
			self.disablers.legit_aa = false
		end
	else
		self.disablers.legit_aa = false
	end

	if edgeYaw then
		if edge_active then
			self:set_gs_preset()
		end
		menu_set(menu.refs.edge[1], edge_active)
	end

	local options = menu_get(gui.aa.manual_options)
	local set_menu_key = self.freestand_key[tostring(freestand_active[2])]

	if manualAA then
		local left_check = man_left[2] == 2 and self.keys.stored_left ~= left_active
		local right_check = man_right[2] == 2 and self.keys.stored_right ~= right_active
		local forward_check = man_forward[2] == 2 and self.keys.stored_forward ~= forward_active

		if left_check or right_check or forward_check then
			if forward_check and self.var.last_press_t + 0.01 < globals_curtime() then
				self.disablers.manual_yaw = self.disablers.manual_yaw == 180 and 0 or 180
				self.var.last_press_t = globals_curtime()
				self.keys.stored_forward = forward_active
				self.var.fs_true = false
			elseif right_check and self.var.last_press_t + 0.01 < globals_curtime() then
				self.disablers.manual_yaw = self.disablers.manual_yaw == 90 and 0 or 90
				self.var.last_press_t = globals_curtime()
				self.keys.stored_right = right_active
				self.var.fs_true = false
			elseif left_check and self.var.last_press_t + 0.01 < globals_curtime() then
				self.disablers.manual_yaw = self.disablers.manual_yaw == -90 and 0 or -90
				self.var.last_press_t = globals_curtime()
				self.keys.stored_left = left_active
				self.var.fs_true = false
			elseif self.var.last_press_t > globals_curtime() then
				self.var.last_press_t = globals_curtime()
			end
			self.keys.stored_forward = forward_active
			self.keys.stored_right = right_active
			self.keys.stored_left = left_active
		else

			if man_left[2] ~= 2 and man_right[2] ~= 2 then
				if left_active then
					self.disablers.manual_yaw = -90
				elseif right_active then
					self.disablers.manual_yaw = 90
				elseif forward_active then
					self.disablers.manual_yaw = 180
				else
					self.disablers.manual_yaw = 0
				end
			end
		end
	else
		self.disablers.manual_yaw = 0
	end

	if self.disablers.manual_yaw ~= 0 then
		self.keys.disable_fs = true
		self.var.fs_true = false
		freestand_active[1] = false
		self.var.last_fs = globals_curtime()
	else
		self.keys.disable_fs = false
	end

	local state = entity:state()
	local fs_disablers = contains(menu_get(gui.aa.freestand_disablers), state)
	local mode = menu_get(gui.aa.freestand_options)

	local freestand = menu_get(gui.aa.key_freestand) and not fs_disablers and self.disablers.manual_yaw == 0

    menu_set(menu.refs.freestand[1], freestand)
    menu_set(menu.refs.freestand[2], freestand and 'Always on' or 'Toggle')
	self.var.fs_true = freestand

	if self.var.fs_true then
		self:set_gs_preset(0, mode == "Jitter")
	end
	--[[
	if fs_disablers then
		reset_once = true
		menu_set(menu.refs.freestand[1], "-")
	else
		if reset_once then
			if self.var.fs_true then
				self:set_gs_preset(0, mode == "Jitter")
				menu_set(menu.refs.freestand[2], "Always on")
				menu_set(menu.refs.freestand[1], "Default")
				reset_once = false
			end
		end
	end

	if freestand and fs_disablers == false or legitaa_active[1] == false then
			local fs_check = fs_test[2] == 2 and self.keys.stored_fs ~= freestand_active[1]

			if fs_check then
				if self.keys.disable_fs == false then
					if self.var.last_fs + 0.05 < globals_curtime() then
						self.var.last_fs = globals_curtime()
						self.var.fs_true = not self.var.fs_true
					elseif self.var.last_fs > globals_curtime() then
						self.var.last_fs = globals_curtime()
					end

					if self.var.fs_true then
						self:set_gs_preset(0, mode == "Jitter")
						menu_set(menu.refs.freestand[2], "Always on")
						menu_set(menu.refs.freestand[1], "Default")
					else
						menu_set(menu.refs.freestand[1], "-")
					end
				end
				self.keys.stored_fs = freestand_active[1]
			else
				if fs_test[2] ~= 2 then
					if freestand_active[1] then
						self.var.fs_true = true
						self:set_gs_preset(0, mode == "Jitter")
						menu_set(menu.refs.freestand[2], "Always on")
						menu_set(menu.refs.freestand[1], "Default")
					else
						self.var.fs_true = false
						menu_set(menu.refs.freestand[1], "-")
					end	
				end
		end
		--menu_set(menu.refs.freestand[1], "-")
		--menu_set(menu.refs.freestand[2], set_menu_key)
	end

	--]]

	local first = legitAA and legitaa_active[1]
	local second = edgeYaw and edge_active 
	--local third = freestand and freestand_active[1] and self.keys.disable_fs == false
	local third = self.var.fs_true
	local fourth = manualAA and manual_active and self.keys.disable_fs

	if fourth then
		if options == "Local view" then
			self.disablers.at_targets = true
		else
			self.disablers.at_targets = false
		end
	else
		self.disablers.at_targets = false
	end

	self.keybind_active = first or second or third
	if self.keybind_active then
		debug.keybinds = "antiaim:keybinds() -> L132"
	end

	--print("active: " .. tostring(third))
	--if self.keys.stored_fs ~= freestand_active[1] then
	--	self.keys.stored_fs = freestand_active[1]
	--end
end

aa.c_store = {
	jitter = false,
	yaw = 0,
	invert = false,
	disable_at_targets = true,
	tick = 0,
	did_shoot = false,
}

aa.at_targets = function(self, threat)
	local pitch, yaw2 = client.camera_angles()
	if self.disablers.at_targets or self.disablers.at_targets_builder then
		debug.at_targets = "antiaim:at_targets() -> L114"
		return pitch, yaw2 + self.disablers.manual_yaw + 180
	else
		if threat ~= nil then
			local eyepos = vector(client.eye_position())
			local origin = vector(entity_get_origin(threat))
			local target = origin + vector(0, 0, 40)
			pitch, yaw = eyepos:to(target):angles() 
			debug.at_targets = "antiaim:at_targets() " .. threat .. " -> L120"
			return pitch, yaw + self.disablers.manual_yaw + 180
		else
			debug.at_targets = "antiaim:at_targets() -> L122"
			return pitch, yaw2 + self.disablers.manual_yaw + 180
		end
	end
end

aa.choke_now = false

local choke = false
aa.custom_desync = function(self, cmd, values, legitaa)
	--force aa off
	local me = entity.get_local_player()
	if me == nil then return end

	local vel = entity:get_velocity(me)
	local count = globals.tickcount()

	local can_desync = self:can_desync(cmd, me, count, vel)

	debug.apply_aa = "antiaim:custom_desync() -> L185"
	
	local pitch, yaw2 = client.camera_angles()
    local current_player = client.current_threat()
	
	if values[1] == nil or values[2] == nil or values[3] == nil or values[4] == nil then return end
	local r, r2 = values[1], values[2]
	local f, f2 = values[3], values[4]
	local _, yaw = self:at_targets(current_player)

	local jitter_method = values[7]

	if jitter_method ~= nil then
		if jitter_method == "Unchoked" then
			choke = self:get_choke(cmd) 
		elseif jitter_method == "Tickbase" then
			--local tick = entity_get_prop(me, "m_nTickbase") % 2 == 0
			choke = self:get_choke(cmd) 
			cmd.force_defensive = choke
		end
	else
		choke = self:get_choke(cmd)
	end

	pitch = 89

	local hs_on = menu_get(menu.refs.hs[2]) and menu_get(menu.refs.hs[1])
	local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])

	if not hs_on and not dt_on then
		cmd.allow_send_packet = false
	end

	self:micromovements(cmd, entity:get_local())

	if can_desync then
		if choke and cmd.chokedcommands < 14 then
		--handle micromovements
		--print(cmd.chokedcommands)
			cmd.allow_send_packet = false
			self.c_store.jitter = not self.c_store.jitter
			if values[6] then --jitter fake
				if self.c_store.jitter then
					cmd.yaw = math.random(f) + yaw
				else
					cmd.yaw = math.random(f2) + yaw
				end
			else
				cmd.yaw = f + yaw
			end
		else

			if values[5] then --jitter real
				if self.c_store.jitter then
					cmd.yaw = r + yaw
				else
					cmd.yaw = r2 + yaw
				end
			else
				cmd.yaw = r + yaw
			end
		end
		if not legitaa then
			cmd.pitch = 89
		end
		--cmd.yaw = yaw + self.c_store.yaw
	end

end

local builder = {
	main = 0,
	left = 0,
	right = 0,
	fake_left = 0,
	fake_right = 0,
}

aa.main_builder_handle = function(self, cmd)
local state = entity:state()
local player = entity:get_local()

if player == nil then return end
local state_to_int = cond_to_int[state]

local enabled = menu_get(gui["Anti-Aim"]["Algorithm"][state_to_int].enable)
local mode = enabled and menu_get(gui["Anti-Aim"]["Algorithm"][state_to_int].selector) or menu_get(gui["Anti-Aim"]["Algorithm"][1].selector)

local default = mode == "Default"
local custom = mode == "Custom"

local path = enabled and gui["Anti-Aim"]["Algorithm"][mode][state_to_int] or gui["Anti-Aim"]["Algorithm"][mode][1]
--local statenz = enabled and state:lower() or "global"

if default then
		debug.apply_aa = "antiaim:gs_builder() -> L734"
		self:skeet_builder(path)
	elseif custom then
		debug.apply_aa = "antiaim:custom_builder() -> L737"

		local yaw_base 			= menu_get(path.yaw_base)
		local yaw 	   			= menu_get(path.yaw)
		local jitter_method 	= menu_get(path.jitter_method)
		local jitter_yaw 		= menu_get(path.jit_yaw)
		local jitter_yaw_slider = menu_get(path.jit_yaw_slider)
		local left 				= menu_get(path.left)
		local right 			= menu_get(path.right)
		local fake_mode 		= menu_get(path.fake_mode)
		local left_limit 		= menu_get(path.left_limit)
		local right_limit 		= menu_get(path.right_limit)

		self.disablers.at_targets_builder = yaw_base == "Local view" and true or false

		if jitter_yaw == "Center" then
			builder.left = jitter_yaw_slider
			builder.right = -jitter_yaw_slider
		elseif jitter_yaw == "Offset" then
			builder.left = yaw
			builder.right = -jitter_yaw_slider
		elseif jitter_yaw == "Random" then
			builder.left = math.random(-jitter_yaw_slider, jitter_yaw_slider)
			builder.right = math.random(-jitter_yaw_slider, jitter_yaw_slider)
		elseif jitter_yaw == "L & R jitter" then
			builder.left = left
			builder.right = right
		else
			builder.left = 0
			builder.right = 0
		end

		if fake_mode == "Jitter" then
			builder.fake_left = left_limit
			builder.fake_right = right_limit
		elseif fake_mode == "Static" then
			builder.fake_left = left_limit
			builder.fake_right = right_limit
		else
			builder.fake_left = 0
			builder.fake_right = 0
		end

		self:custom_desync(cmd, {builder.left + yaw, builder.right + yaw, -builder.fake_left * 2, builder.fake_right * 2, jitter_yaw ~= "Off", fake_mode == "Jitter", jitter_method})
	end
end

aa.p_data = {
    yaw_status = "default",
    indexed_angle = 0,
    last_miss = 0,
    best_angle = 0,
    misses = { }, --this is either nil, 1 or 2
    hit_reverse = { },
    log = {},
    switch = false,
}

aa.log_check = function(self)
    for j, x in next, self.p_data.log do
        local hp = entity_get_prop(x.idx, "m_iHealth")
        local team = entity_get_prop(x.idx, "m_iTeamNum")
        if hp == nil or team == nil then
            --print("id: " .. j .. " entid: " .. x.idx .. " hp: " .. tostring(hp))
            --print ("succesfully removed") 
            table.remove(self.p_data.log, j)
        else
            if team == entity_get_prop(me, "m_iTeamNum") then
                --print ("succesfully removed " .. entity_get_player_name(j) .. " due to being same team") 
                table.remove(self.p_data.log, j)
            end
        end
    end
end

aa.reset_log = false
aa.cached_mode = {
	mode = "",
	real_min = menu_get(gui["Anti-Aim"]["Default"].yaw_min),
	real_max = menu_get(gui["Anti-Aim"]["Default"].yaw_max),
	real2_min = menu_get(gui["Anti-Aim"]["Default"].yaw2_min),
	real2_max = menu_get(gui["Anti-Aim"]["Default"].yaw2_max),
	fake_min = menu_get(gui["Anti-Aim"]["Default"].fake_min),
	fake_max = menu_get(gui["Anti-Aim"]["Default"].fake_max),
}

aa.generate_log = function(self)
	if menu_get(gui["Anti-Aim"]["Default"].generate) ~= aa.cached_mode.mode or 
	   menu_get(gui["Anti-Aim"]["Default"].yaw_min) ~= aa.cached_mode.real_min or
	   menu_get(gui["Anti-Aim"]["Default"].yaw_max) ~= aa.cached_mode.real_max or
	   menu_get(gui["Anti-Aim"]["Default"].yaw2_min) ~= aa.cached_mode.real2_min or
	   menu_get(gui["Anti-Aim"]["Default"].yaw2_max) ~= aa.cached_mode.real2_max or
	   menu_get(gui["Anti-Aim"]["Default"].fake_min) ~= aa.cached_mode.fake_min or
	   menu_get(gui["Anti-Aim"]["Default"].fake_max) ~= aa.cached_mode.fake_max
	   then
		self.p_data.log = {}
	end
    local ents = entity_get_players(true)
    local me = entity_get_local_player()
    for i=1, #ents do
        local enemy = ents[i]
        local hp = entity_get_prop(enemy, "m_iHealth")
        if enemy == nil then goto skip end
        if entity_get_prop(enemy, "m_iTeamNum") == entity_get_prop(me, "m_iTeamNum") then goto skip end
        if player == me then goto skip end
            if self.p_data.log[enemy] == nil then
                self.p_data.log[enemy] = {
                    idx = enemy,
                    name = entity_get_player_name(enemy),
                    steam = entity_get_steam64(enemy),
                    jitter = math.random(55, 80),
                    yaw = {y = 0, y2 = 0},
                    fake = {f = 0, f2 = 0},
					fs1 = {y = 0, y2 = 0},
					fs2 = {y = 0, y2 = 0},	
                    range_check = {y1 = {}, y2 = {}},
                    should_update = true,
					should_update_yaw = false,
                    last_miss = 0,
                    misses = 0,
                    side = false,
                }
                --print("generated log for " .. entity_get_player_name(enemy))
				print_log("Succesfully generated anti-aim for " .. entity_get_player_name(enemy), "Anti-Aim data")
                self:log_check()
            end
            
        ::skip::
    end
	self.cached_mode.mode = menu_get(gui["Anti-Aim"]["Default"].generate)

	self.cached_mode.real_min = menu_get(gui["Anti-Aim"]["Default"].yaw_min)
	self.cached_mode.real_max = menu_get(gui["Anti-Aim"]["Default"].yaw_max)
	self.cached_mode.real2_min = menu_get(gui["Anti-Aim"]["Default"].yaw2_min)
	self.cached_mode.real2_max = menu_get(gui["Anti-Aim"]["Default"].yaw2_max)
	self.cached_mode.fake_min = menu_get(gui["Anti-Aim"]["Default"].fake_min)
	self.cached_mode.fake_max = menu_get(gui["Anti-Aim"]["Default"].fake_max)

end

aa.cache = {y1 = 0, y2 = 0}

aa.dynamic_mode = {
	["Default"] = { 
		real = {
			-24, -32
		},
		real2 = {
			14, 17
		},
		fake = {
			80, 110
		},
	},
	["Medium"] = { 
		real = {
			-33, -36
		},
		real2 = {
			12, 17
		},
		fake = {
			45, 90
		},
	},
	["High"] = { 
		real = {
			-37, -44
		},
		real2 = {
			14, 20
		},
		fake = {
			25, 75
		},
	},
	["Custom"] = {
		real = {
			-37, -44
		},
		real2 = {
			14, 20
		},
		fake = {
			25, 75
		},
	}
}

aa.cached_user = {}

aa.calculate_yaw = function(self, cmd, yaw)
    local localplayer = entity_get_local_player()
    if localplayer == nil or not entity_is_alive(localplayer) then
        return
    end
    math.randomseed(client.unix_time())

    local state = entity:state()
    local velocity = entity:get_velocity(localplayer)
    
    local target = client.current_threat()
	if target == nil then
		return { -23, 43, 120, -120, false }
	end

	local get_mode = menu_get(gui["Anti-Aim"]["Default"].generate)
	values = self.dynamic_mode[get_mode]
	local main_yaw = 0
	if get_mode == "Custom" then
		values.real[1] = menu_get(gui["Anti-Aim"]["Default"].yaw_min)
		values.real[2] = menu_get(gui["Anti-Aim"]["Default"].yaw_max)
		values.real2[1] = menu_get(gui["Anti-Aim"]["Default"].yaw2_min)
		values.real2[2] = menu_get(gui["Anti-Aim"]["Default"].yaw2_max)
		values.fake[1] = menu_get(gui["Anti-Aim"]["Default"].fake_min)
		values.fake[2] = menu_get(gui["Anti-Aim"]["Default"].fake_max)

		main_yaw = menu_get(gui["Anti-Aim"]["Default"].main_yaw)
	end

	if menu_get(gui["Anti-Aim"]["Default"].antiaim) == "Break freestand" then
		values = self.dynamic_mode["Default"]
	end

    if self.p_data.log[target] then
		if self.p_data.log[target].should_update then
			if self.p_data.log[target].yaw == nil then self.p_data.log[target].yaw = {y = 0, y2 = 0} end
            self.p_data.log[target].yaw.y = math.random(values.real[1], values.real[2]) + 4
            self.p_data.log[target].yaw.y2 = math_abs(self.p_data.log[target].yaw.y) + math.random(values.real2[1], values.real2[2]) + 4
            self.p_data.log[target].fake.f = math.random(values.fake[1], values.fake[2])
            self.p_data.log[target].fake.f2 = -self.p_data.log[target].fake.f / 2

			--print_log("Succesfully updated anti-aim for " .. self.p_data.log[target].name, "Anti-Aim data")
            self.p_data.log[target].should_update = false
        end
        return { self.p_data.log[target].yaw.y + main_yaw, self.p_data.log[target].yaw.y2 + main_yaw, self.p_data.log[target].fake.f, self.p_data.log[target].fake.f2, true }

    end
    return {0, 0}    
end

aa.calculate_yaw_fs = function(self, cmd, yaw)
    local localplayer = entity_get_local_player()
    if localplayer == nil or not entity_is_alive(localplayer) then
        return
    end
    math.randomseed(client.unix_time())

    local state = entity:state()
    local velocity = entity:get_velocity(localplayer)
    
    local target = client.current_threat()
	if target == nil then
		return { -23, 43, 0, 0, false }
	end

    if self.p_data.log[target] then
		if self.p_data.log[target].should_update then
			if self.p_data.log[target].yaw == nil then self.p_data.log[target].yaw = {y = 0, y2 = 0} end
			if self.p_data.log[target].fs1 == nil then return end
            self.p_data.log[target].fs1.y = math.random(30, 40)
			self.p_data.log[target].fs1.y2 = -math.random(35, 45)
            self.p_data.log[target].should_update = false
        end
        return { self.p_data.log[target].fs1.y, self.p_data.log[target].fs1.y2, self.p_data.log[target].fs2.y, self.p_data.log[target].fs2.y2, true }

    end
    return {0, 0}    
end



aa.antibf_impact = function(self, e)
    --if not ui.get(menu.main_aa) then return end

    local me = entity_get_local_player()

    if not entity_is_alive(me) then return end

    local shooter_id = e.userid
    local shooter = client_userid_to_entindex(shooter_id)

    -- Distance calculations can sometimes bug when the entity is dormant hence the 2nd check.
    if not entity_is_enemy(shooter) or entity_is_dormant(shooter) then return end

    local lx, ly, lz = entity_hitbox_position(me, "head_0")
    
    local ox, oy, oz = entity_get_prop(me, "m_vecOrigin")
    local ex, ey, ez = entity_get_prop(shooter, "m_vecOrigin")

    local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
    
    -- 32 is our miss detection radius and the 2nd check is to avoid adding more than 1 miss for a singular bullet (bullet_impact gets called mulitple times per shot).

	if math_abs(dist) <= 65 and globals_curtime() - self.p_data.last_miss > 0.015 then
        self.p_data.last_miss = globals_curtime()
        if self.p_data.log[shooter] == nil then
        self.p_data.log[shooter] = {
                idx = shooter,
                jitter = math.random(55, 80),
                fake = {c = 0, j = 0, f = 0},
                should_update = true,
				should_update_yaw = false,
                last_miss = 0,
                misses = 0,
				side = false,
            }
            else
				local mode = menu_get(gui["Anti-Aim"]["Default"].antibf)

				if contains(mode, "Jitter") then
					self.p_data.log[shooter].should_update = true
				end

				local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
				--menu.f.hex_label({250, 155, 155})
				local clr = menu.f.hex_label({r, g, b})
				local w = "\aFFFFffff"
					
				local txt = 'Player ' .. clr .. entity.get_player_name( shooter ) .. w .. " activated anti-bruteforce " .. clr .. "[" .. tostring(self.p_data.log[shooter].side) .. "]" .. w .. " total: " .. clr .. self.p_data.log[shooter].misses
				local console_txt = 'Player ' .. entity.get_player_name( shooter ) .. " activated anti-bruteforce [" .. tostring(self.p_data.log[shooter].side) .. "] total: " .. self.p_data.log[shooter].misses
				
            --self.p_data.log[shooter].should_update = true
			--print(self.p_data.log[shooter].side)
            self.p_data.log[shooter].side = not self.p_data.log[shooter].side

			visuals:add_to_log(txt, client.userid_to_entindex(shooter))
			print_log(console_txt, "Anti-Aim data")


            self.p_data.log[shooter].misses = self.p_data.log[shooter].misses + 1
            self.p_data.log[shooter].last_miss = globals_curtime()
        end
    end
end

aa.antibf_death = function(self, e)        
    local victim_id = e.userid
    local victim = client.userid_to_entindex(victim_id)

    if victim ~= entity_get_local_player() then return end

    local attacker_id = e.attacker
    local attacker = client_userid_to_entindex(attacker_id)

    if not entity_is_enemy(attacker) then return end

    if not e.headshot then return end

    if self.p_data.misses[attacker] == nil or (globals_curtime() - self.p_data.last_miss < 0.06 and self.p_data.misses[attacker] == 1) then
        math.randomseed(client.unix_time())
        if self.p_data.log[attacker] == nil then
            self.p_data.log[attacker] = {
                idx = attacker,
                name = entity_get_player_name(attacker),
                steam = entity_get_steam64(attacker),
                jitter = math.random(55, 80),
                yaw = {y = 0, y2 = 0},
                fake = {f = 0, f2 = 0},
				fs1 = {y = 0, y2 = 0},
                fs2 = {y = 0, y2 = 0},
                range_check = {y1 = {}, y2 = {}},
                should_update = true,
				should_update_yaw = false,
                last_miss = 0,
                misses = 0,
                side = false,
            }
        else
            self.p_data.log[attacker].should_update = true
        end
    end
end


aa.on_shot = {
	on = false,
	update = false,
	better_onshot = 0,
	cache_fakelag = 1,
}

aa.better_onshot = function(self, cmd)
	local active = contains(menu_get(gui.aa.enhancements), "Better on-shot")

	debug.better_onshot = nil


	if active then
		local refs = menu.refs
		local dt_on = menu_get(refs.dt[2]) and menu_get(refs.dt[1])
		local hs_on = menu_get(refs.hs[2]) and menu_get(refs.hs[1])
		local fd_on = menu_get(menu.refs.fd)

		self.on_shot.on = self.on_shot.better_onshot > globals_curtime()

		if self.on_shot.on then
			self.on_shot.update = true
			--if dt_on then
				if fd_on then
					menu_set(refs.fl_limit, 14)
					debug.better_onshot = "antiaim:better_onshot() BLOCK -> L1490"
				else
					debug.better_onshot = "antiaim:better_onshot() -> L1580"
					menu_set(refs.fl_limit, 1)
				end
			--end
		end
		
		if not self.on_shot.on and self.on_shot.update then
			--menu_set(refs.fl_limit, self.on_shot.cache_fakelag)
			debug.better_onshot = "antiaim:better_onshot() RESET -> L1580"
			menu_set(refs.fl_limit, 14)
			self.on_shot.update = false
		end
	end
end

aa.defensive_preset = function(self, fake, real)
	local ref = menu.refs
	menu_set(ref.pitch[1], "Default")
	menu_set(ref.base[1], "At targets")
	menu_set(ref.yaw[1], 180)
	--menu_set(ref.yaw[2], yaw)
	menu_set(ref.jitter[1], "Center")
	menu_set(ref.jitter[2], real)
	menu_set(ref.body[1], fake and "Jitter" or "Off")
	menu_set(ref.body[2], 0)
	menu_set(ref.fs[1], false)
	menu_set(ref.roll[1], 0)
end

local flick_back = false
local delay = 0
local defensive_exploit_active = false

aa.defensive_exploit = function(self, cmd)
	local defensive_exploit = gui["Anti-Aim"]["Exploits"]["Defensive manipulation"]
	local state = entity:state()

	local disablers = contains(menu_get(defensive_exploit.disablers), state)

	local check_and_key = menu_get(defensive_exploit.enable) and menu_get(defensive_exploit.key_enable)

	local enabled = check_and_key and disablers == false
	defensive_exploit_active = enabled

	if enabled then
		local me = entity_get_local_player()
		if me == nil then return end

		local jitter_fake = menu_get(defensive_exploit.fake_jitter)
		local real_jitter = menu_get(defensive_exploit.real_jitter)

		local mode = menu_get(defensive_exploit.mode)

		local left_min = menu_get(defensive_exploit.left_min)
		local left_max = menu_get(defensive_exploit.left_max)
		local right_min = menu_get(defensive_exploit.right_min)
		local right_max = menu_get(defensive_exploit.right_max)

		local speed = menu_get(defensive_exploit.speed)

		debug.defensive_exploit = "antiaim:defensive_exploit() -> L1802"

		local tick = entity_get_prop(me, "m_nTickbase") % speed == 0
		if tick then
			cmd.force_defensive = true
			delay = delay + 1
			if delay > 3 then
				delay = 0
			end
			flick_back = not flick_back

			self:defensive_preset(jitter_fake, 0)

			if mode == "Custom" then
				menu_set(menu.refs.yaw[2], delay > 1 and -math.random(left_min, left_max) or math.random(right_min, right_max) )
			else
				menu_set(menu.refs.yaw[2], delay > 1 and -math.random(45, 65) or math.random(45, 90) )
			end
		else
			self:defensive_preset(jitter_fake, mode == "Custom" and real_jitter or 0)

			menu_set(menu.refs.yaw[1], "180")
			menu_set(menu.refs.yaw[2], 14)
		end
	end
end

aa.new_desync = function(self, cmd, values, at_targets)
	local me = entity.get_local_player()
	if me == nil then return end

	local vel = entity:get_velocity(me)
	local count = globals.tickcount()

	local can_desync = self:can_desync(cmd, me, count, vel)
	
	local choke = self:get_choke(cmd)

	local pitch, yaw2 = client.camera_angles()
    local current_player = client.current_threat()

	if values[1] == nil or values[2] == nil or values[3] == nil or values[4] == nil then return end
	local r, r2 = values[1], values[2]
	local f, f2 = values[3], values[4]
	pitch = 89

	local _, yaw = self:at_targets(current_player)

	self:micromovements(cmd, entity_get_local_player())

	local count = globals_tickcount()
	if can_desync then
		if self.c_store.tick ~= count then
			self.c_store.tick = count
			if cmd.command_number % 2 == 0 then
				self.c_store.jitter = not self.c_store.jitter
			end

			local nn = cmd.command_number % 2 == 0
			if self.c_store.jitter then
				--cmd.allow_send_packet = true
				self.c_store.yaw = nn and r or r2
			else
				--if cmd.chokedcommands == 0 then
					self.c_store.yaw = nn and f or f2
				--end
			end
		end
		debug.apply_aa = "antiaim:apply_new() -> L122"
		cmd.yaw = yaw + self.c_store.yaw
		cmd.pitch = 90		
	end
end

aa.handle_dynamic = function(self, cmd)

	self:generate_log()

	local mode = menu_get(gui["Anti-Aim"]["Default"].antiaim)
	local value = {}
	--if mode ~= "Break freestand" then
		value = self:calculate_yaw(cmd)
	--else
	--	value = self:calculate_yaw_fs(cmd)
	--end
    main_yaw = 0

    local real = value[1] + main_yaw
    local real2 = value[2] + main_yaw
	if value[3] == nil then value[3] = 120 end
	if value[4] == nil then value[4] = 120 end
    local fake = value[3] + main_yaw
    local fake2 = value[4] + main_yaw

	local state = entity:state()
	local in_air = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1) == 0

	local current_player = client.current_threat()

	if current_player == nil or entity_is_dormant(current_player) then
		real = -16
		real2 = 43
		fake = 120
		fake2 = -120
	end

	if mode == "New" then
		if state == "Move" then
			real = real - 5
			real2 = real2 + 5
		end	
		if in_air then
			main_yaw = 5
		end
		self:new_desync(cmd, {real, real, real2, real2})
	elseif mode == "Custom desync" then
		if state == "Move" then
			real = real - 8
			real2 = real2 + 10
		end
		self:custom_desync(cmd, {real, real2, fake, fake2, true, true})
	elseif mode == "Break freestand" then
		local fs1_right = value[1]
		local fs1_left = value[2]
		local fs2_right = value[3]
		local fs2_left = value[4]
		local fake = 0
		local fake2 = 0

		self:get_freestand(cmd)
		local side = self.fs_data.side == 1

		if side then
			--print("true")
			real = -real2
			real2 = 35
			fake = 120
			fake2 = -120
			--fake = self.p_data.log[current_player].side and 0 or 120
			--fake2 = self.p_data.log[current_player].side and 0 or -120
		else
			--print("false")
			real = -35
			real2 = real2
			fake = 120
			fake2 = -120
			--fake = self.p_data.log[current_player].side and 0 or 120
			--fake2 = self.p_data.log[current_player].side and 0 or -120
		end

		if entity.cur_state == "Stand" or entity.cur_state == "Duck" then
			real = real + 5
			real2 = real2 - 3
			fake = 120
			fake2 = -120
		end

		if entity.cur_state == "Air" then
			real = value[1] + main_yaw + 20
			real2 = value[2] + main_yaw + 17
			fake = 120
			fake2 = -120
		end

		--if self.fs_data.can_be_hit and entity.cur_state ~= "Air" then
		--	self:new_desync(cmd, {real, real, real2, real2})
		--	return
		--end
		--if self.p_data.log[current_player].side then
		--	self:new_desync(cmd, {real, real, real2, real2})
		--else
			self:custom_desync(cmd, {real, real2, fake, fake2, true, true})
		--end
	end
end

aa.back_stab = {
	store_dt = 0,
	reset_dt = false
}

aa.anti_backstab = function(self, cmd)
	local me = entity_get_local_player()
	if me == nil then return end

	local backstab_options = menu_get(gui.aa.backstab_options)
	local disable_more_one = contains(backstab_options, "Disable if more than 1 in range")
	local predict_high_vel = contains(backstab_options, "Predict enemy high velocity")
	local pull_secondary = contains(backstab_options, "Pull out secondary weapon")

	self.disablers.anti_backstab = false

	local lx, ly = entity_get_origin(me)

	local enemies = entity_get_players(true)
	local people_in_range = 0

	for i=1, #enemies do
		local enemy = enemies[i]

		local active_wpn = entity_get_player_weapon(enemy)
		if active_wpn == nil then return end

		local weapon = entity_get_classname(active_wpn)
		if weapon == nil then return end

		local x, y = entity_get_origin(enemy)
		local distance = math_sqrt((lx-x)^2 + (ly-y)^2)

		local check_range = 200
		local has_knife = weapon:find("Knife")

		if pull_secondary then
			if distance < check_range + 175 then
				if has_knife then
					client_exec("slot2")
				end
			end
		end

		if distance < check_range then
			people_in_range = people_in_range + 1
			if disable_more_one then
				if people_in_range > 1 then
					debug.anti_backstab = "antiaim:anti_backstab() -> ERR"
					return
				end
			end
			if has_knife then
				debug.anti_backstab = "antiaim:anti_backstab() -> L990"
				self.disablers.anti_backstab = true
				self:legit_aa_preset(false, true)
			end
		end

		if predict_high_vel then
			local newextrapolatedPos = helpers:extrapolateTick(enemy, 125)
			local newDist = math_sqrt((lx-newextrapolatedPos[1])^2 + (ly-newextrapolatedPos[2])^2)
			if is_air then
				if has_knife then
					if newDist < check_range then
						debug.anti_backstab = "antiaim:anti_backstab_pred() -> L997"
						self.disablers.anti_backstab = true
						self:legit_aa_preset(false, true)
					end
				end
			end
		end
	end
end

aa.anti_zeus = function(self, cmd)
	local me = entity_get_local_player()
	if me == nil then return end

	local lx, ly = entity_get_origin(me)

	local enemies = entity_get_players(true)

	for i=1, #enemies do
		local enemy = enemies[i]

		local active_wpn = entity_get_player_weapon(enemy)
		if active_wpn == nil then return end

		local weapon = entity_get_classname(active_wpn)
		if weapon == nil then return end

		local x, y = entity_get_origin(enemy)
		local newextrapolatedPos = helpers:extrapolateTick(enemy, 125)
		local distance = math_sqrt((lx-newextrapolatedPos[1])^2 + (ly-newextrapolatedPos[2])^2)

		local check_range = 300
		local has_zeus = weapon:find("Taser")
		
		if distance < check_range then
			if has_zeus then
				debug.anti_zeus = "antiaim:anti_zeus() -> L602"
				client_exec("slot11")
			end
		end
	end
end

aa.fs_data = {
	side = 0,
	last_side = 0,
	can_be_hit = 0
}

aa.get_freestand = function(self, cmd, mode)
	local me = entity_get_local_player()

	self.fs_data.can_be_hit = false

	if not me or entity_get_prop(me, "m_lifeState") ~= 0 then return end
	local now = globals_curtime()
	local index, damage = 0
	local threat = client.current_threat()

	if entity_is_alive(threat) then
		local lx, ly, lz = entity_get_prop(me, "m_vecOrigin")
		local enemyx, enemyy, enemyz = entity_get_prop(threat, "m_vecOrigin")
		local yaw = helpers:calcangle(lx, ly, enemyx, enemyy)
		local dir_x, dir_y, dir_z = helpers:angle_vector(0, (yaw))
		local end_x = lx + dir_x * 55
		local end_y = ly + dir_y * 55
		local end_z = lz + 80
		index, damage = client_trace_bullet(threat, enemyx, enemyy, enemyz + 70, end_x, end_y, end_z,true)
	end

	if damage == nil then 
		return 
	end

		if damage > 1 then
			self.fs_data.side = self.fs_data.side
			self.fs_data.can_be_hit = true
			debug.freestand = "antiaim:get_freestand() LOCK -> L282"
			return
		end

	if damage < 1 then
		--local _mode = getmenu(lua_menu.custom.stand.freestand)

		local x, y, z = client_eye_position()
		--local x, y, z = entity.get_origin(entity.get_local_player())
		local _, yaw = client.camera_angles()


		local trace_data = {left = 0, right = 0}

		for i = yaw - 90, yaw + 90, 30 do
			if i ~= yaw then
				local rad = math.rad(i)

				local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z

				local fraction = client.trace_line(me, x, y, z, px, py, pz)
				local side = i < yaw and "left" or "right"

				trace_data[side] = trace_data[side] + fraction
			end
		end

		self.fs_data.side = trace_data.left < trace_data.right and 1 or 2

		if self.fs_data.side == self.fs_data._lastside then 
			return 
		end

		debug.freestand = "antiaim:get_freestand() " .. self.fs_data.side ..  " -> L288"

		self.fs_data.last_side = self.fs_data.side
	end
end

aa.roll_preset = function(self, yaw, side)
	local ref = menu.refs
	menu_set(ref.pitch[1], "Down")
	menu_set(ref.base[1], "At targets")
	menu_set(ref.yaw[1], "180")
	if yaw <= -180 then yaw = -180 end
	if yaw >= 180 then yaw = 180 end
	menu_set(ref.yaw[2], yaw)
	menu_set(ref.jitter[1], "Off")
	menu_set(ref.jitter[2], 0)
	menu_set(ref.body[1], "Static")
	menu_set(ref.body[2], side and -180 or 180)
	menu_set(ref.fs[1], false)
	menu_set(ref.roll[1], 0)
end

aa.yaws = {
	["Backwards"] = 0,
	["Right"] = 90,
	["Left"] = -90,
}

aa.roll_active = false
aa.roll_amount = 0
aa.roll_key_cache = false
aa.roll_invert = false

aa.roll = function(self, cmd)

	self.roll_active = false
	local me = entity_get_local_player()
	if me == nil then return end

	local roll_menu = gui["Anti-Aim"]["Exploits"]["Roll"]
	local active = menu_get(roll_menu.enable) and menu_get(roll_menu.key_roll)

	if active then
		self.roll_active = true
		local yaw = menu_get(roll_menu.yaw)
		local yaw_amount = menu_get(roll_menu.yaw_amount)
		local disablers = menu_get(roll_menu.disablers)
		local mode = menu_get(roll_menu.mode)
		local direction = menu_get(roll_menu.direction)
		local key_inverter = menu_get(roll_menu.key_inverter)
		local left = menu_get(roll_menu.left)
		local right = menu_get(roll_menu.right)

		debug.roll = "antiaim:roll() -> L1290"

		local state = entity:state()
		local disable_roll = contains(disablers, state)

		if disable_roll then self.roll_amount = 0 self.roll_active = false return end

		self:get_freestand(cmd)
		local side = self.fs_data.side == 1

		local new_yaw = 0
		if yaw ~= "Automatic" then
			new_yaw = self.yaws[yaw] + yaw_amount
		else
			new_yaw = side and -90 - yaw_amount or 90 + yaw_amount
		end

		local side_left = 50 / 100 * left
		local side_right = 50 / 100 * right

		if contains(mode, "Lean") then
			if direction == "Automatic" then
				self.roll_amount = side and side_left or -side_right
			elseif direction == "Inverter" then
				if self.roll_key_cache ~= menu_get(roll_menu.key_inverter) then
					self.roll_invert = not self.roll_invert 
				end
				self.roll_amount = self.roll_invert and side_left or -side_right
				self.roll_key_cache = key_inverter
			end
		end

		if contains(mode, "Insecure pitch") then
			cmd.pitch = 121
		end

		cmd.roll = self.roll_amount
		self:roll_preset(new_yaw, side)
	end
end

aa.handle = function(self, cmd)
	debug.apply_aa = nil
	debug.can_desync = nil
	debug.get_state = nil
	debug.keybinds = nil
	debug.micromove = nil
	debug.check_desync = nil
	debug.freestand = nil
	debug.anti_zeus = nil
	debug.anti_backstab = nil
	debug.roll = nil
	debug.at_targets = nil
	debug.prefer_sp = nil
	debug.prefer_baim = nil
	debug.defensive_exploit = nil

	self:handle_keybinds(cmd)
	self:defensive_exploit(cmd)

	self:roll(cmd)

	if defensive_exploit_active then return end
	if self.keybind_active then return end
	if self.roll_active then return end

	local dynamic = menu_get(gui["Anti-Aim"]["Default"].enable)
	if dynamic then
		self:handle_dynamic(cmd)
	else
		self:main_builder_handle(cmd)
	end

	local anti_backstab = contains(menu_get(gui.aa.enhancements), "Anti backstab")
	local anti_zeus = contains(menu_get(gui.aa.enhancements), "Anti zeus")

	if anti_backstab then
		self:anti_backstab(cmd)
	else
		self.disablers.anti_backstab = false
	end

	if anti_zeus then
		self:anti_zeus(cmd)
	end

	self:fake_flick(cmd)
end


-- region visuals start --
-- all visually stuff defiend here
visuals.lerp = function(self, start, vend, time)
	return start + (vend - start) * time
end

visuals.clamp = function(self, val, min, max)
	if val > max then return max end
	if min > val then return min end
   return val
end

visuals.gradient = function(self, r1, g1, b1, a1, r2, g2, b2, a2, text)
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

visuals.colorrange = function(self, value, ranges) -- ty tony for dis function u a homie
    if value <= ranges[1].start then
        return ranges[1].color
    end
    if value >= ranges[#ranges].start then
        return ranges[#ranges].color
    end

    local selected = #ranges
    for i = 1, #ranges - 1 do
        if value < ranges[i + 1].start then
            selected = i
            break
        end
    end
    local minColor = ranges[selected]
    local maxColor = ranges[selected + 1]
    local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)
    return {
        self:lerp(lerpValue, minColor.color[1], maxColor.color[1]),
        self:lerp(lerpValue, minColor.color[2], maxColor.color[2]),
        self:lerp(lerpValue, minColor.color[3], maxColor.color[3]),
        self:lerp(lerpValue, minColor.color[4], maxColor.color[4]),
    }
end

visuals.cool_bar = function(self, x, y, w, h, color) -- this is so fucking ugly to read i wish table.unpack worked in here like it did on roblox

	renderer.gradient(x, y, w, h/2, color[1], color[2], color[3], 0, color[1], color[2], color[3], color[4], false)
	renderer.gradient(x, y + h/2, w, h/2, color[1], color[2], color[3], color[4], color[1], color[2], color[3], 0, false)
end

visuals.arrow_stuff = {
	alpha = 0,
	alpha2 = 0,
	alpha3 = 0,
	alpha4 = 0,
	alpha5 = 0,
	x = 0,
}

visuals.arrow = function(self, x, y, width, height, direction, color, alpha)

	local dirc = direction == 1 and x + width or x - width

	for i = (height/2 - height), height/2 do
		renderer.line(x, y, dirc, y + i, color[1], color[2], color[3], color[4] * 0.5)
	end

	local newcolor = color
	newcolor[4] = math.ceil(alpha)

	renderer.line(x, y, dirc, y + height/2, table.unpack(newcolor))    
	renderer.line(x, y, dirc, y - height/2, table.unpack(newcolor))
	renderer.line(dirc, y - height/2, dirc, y + height/2, table.unpack(newcolor))
end

visuals.render_arrow = function(self)
	if contains(menu_get(gui["Visuals"]["indicators"].additional), "Arrows") then
		local me = entity_get_local_player()

		if me == nil or not entity_is_alive(me) then return end
		local m_r, m_g, m_b, m_a = {menu_get(gui["Visuals"]["colors"].clr_arrow_active_1)}
		local padding = menu_get(gui["Visuals"]["indicators"].arrows_padding)
		local height = menu_get(gui["Visuals"]["indicators"].arrows_height)

		local options = menu_get(gui["Visuals"]["indicators"].arrow_options)
		local move_with_vel = contains(options, "Move with velocity")
		local hide_in_scope = contains(options, "Hide in scope")
		local move_in_scope = contains(options, "Move in scope")
		local only_toggled  = contains(options, "Show only toggled side")
		local sw, sh = client.screen_size()
		local cw, ch = math.floor(sw/2), math.floor(sh/2) + height
		local r, g, b, a = menu_get(gui["Visuals"]["colors"].clr_arrow_active_1)

		local adjust = 0
		if move_with_vel then
			adjust = (self:clamp(entity:get_velocity(me), 30, 200) - 30)/200
		end

		local scoped = entity_get_prop(me, "m_bIsScoped") == 1
		local hide_and_scoped = not scoped and hide_in_scope

		self.arrow_stuff.alpha = self:animation(hide_and_scoped, self.arrow_stuff.alpha, a, 8)
		self.arrow_stuff.alpha2 = self:animation(hide_and_scoped, self.arrow_stuff.alpha2, 110, 8)
		self.arrow_stuff.alpha3 = self:animation(hide_and_scoped, self.arrow_stuff.alpha3, 255, 8)
		self.arrow_stuff.alpha4 = self:animation(hide_and_scoped, self.arrow_stuff.alpha4, 150, 8)

		if move_in_scope then
			self.arrow_stuff.x = self:animation(scoped and move_in_scope, self.arrow_stuff.x, 25, 8)
		else
			self.arrow_stuff.x = self:animation(false, self.arrow_stuff.x, 25, 8)
		end

		if hide_in_scope == false then
			hide_and_scoped = true
			self.arrow_stuff.alpha = a
			self.arrow_stuff.alpha2 = 110
			self.arrow_stuff.alpha3 = 255
			self.arrow_stuff.alpha4 = 150
		end
		local new_color = {}

		local camera_angles = { client.camera_angles() }
		local cam = vector(client.camera_angles())

		local h = vector(entity_hitbox_position(me, "head_0"))
		local p = vector(entity_hitbox_position(me, "pelvis"))

		local yaw = helpers:normalize_yaw(helpers:calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
		local bodyyaw = entity_get_prop(me, "m_flPoseParameter", 11) * 120 - 60

		local fakeangle = helpers:normalize_yaw(yaw + bodyyaw)

		local desync_type = entity_get_prop(me, 'm_flPoseParameter', 11) * 120 - 60
		local desync_side = desync_type > 0 and 1 or 0
	
		local angle = entity_get_prop(me, "m_angEyeAngles[1]")

		local fs = menu_get(gui.aa.key_freestand)

		local left = aa.disablers.manual_yaw == -90
		local right = aa.disablers.manual_yaw == 90

		local fs_side = 0
		if fs then
			left = fakeangle > 0
			right = fakeangle < 0 
		end

		local arrow_color = {r, g, b, self.arrow_stuff.alpha}
		local angle_clr = {r, g, b, self.arrow_stuff.alpha}
		local modulate_ang = math.abs(desync_type)
		
		if modulate_ang > 0 then
			local sub = (modulate_ang - 90)
			modulate_ang = modulate_ang - sub
		end

		local angle_clr = self:colorrange( modulate_ang, { [1] = { start = 0, color = {110, 110, 110, self.arrow_stuff.alpha2} }, [2] = { start = 40, color = {r, g, b, self.arrow_stuff.alpha} } } )

		if only_toggled then
			if desync_side == 0 then
				self:arrow(cw - 36 - (20 * adjust) - padding - self.arrow_stuff.x , ch, 13, 12, 1, aa.manualaa == 1 and manual_clr or desync_side == 0 and angle_clr or {110, 110, 110, self.arrow_stuff.alpha2}, self.arrow_stuff.alpha3)
				self:cool_bar(cw - 20 - (20 * adjust) - padding - self.arrow_stuff.x , ch - 10, 2, 20, (left) and {r, g, b, self.arrow_stuff.alpha3} or {110, 110, 110, self.arrow_stuff.alpha4})
			else
				self:arrow(cw + 36 + (20 * adjust) + padding + self.arrow_stuff.x, ch, 13, 12, 2, aa.manualaa == 2 and manual_clr or desync_side == 1 and angle_clr or {110, 110, 110, self.arrow_stuff.alpha2}, self.arrow_stuff.alpha3)
				self:cool_bar(cw + 18 + (20 * adjust) + padding + self.arrow_stuff.x, ch - 10, 2, 20, (right) and {r, g, b, self.arrow_stuff.alpha3} or {110, 110, 110, self.arrow_stuff.alpha4})
			end
		else
			self:arrow(cw - 36 - (20 * adjust) - padding - self.arrow_stuff.x , ch, 13, 12, 1, aa.manualaa == 1 and manual_clr or desync_side == 0 and angle_clr or {110, 110, 110, self.arrow_stuff.alpha2}, self.arrow_stuff.alpha3)
			self:cool_bar(cw - 20 - (20 * adjust) - padding - self.arrow_stuff.x , ch - 10, 2, 20, (left) and {r, g, b, self.arrow_stuff.alpha3} or {110, 110, 110, self.arrow_stuff.alpha4})
			self:arrow(cw + 36 + (20 * adjust) + padding + self.arrow_stuff.x, ch, 13, 12, 2, aa.manualaa == 2 and manual_clr or desync_side == 1 and angle_clr or {110, 110, 110, self.arrow_stuff.alpha2}, self.arrow_stuff.alpha3)
			self:cool_bar(cw + 18 + (20 * adjust) + padding + self.arrow_stuff.x, ch - 10, 2, 20, (right) and {r, g, b, self.arrow_stuff.alpha3} or {110, 110, 110, self.arrow_stuff.alpha4})
		end
	end
end


local yoffset = 0
visuals.debug = function(self)
	local me = entity_get_local_player()
	if me == nil then return end
	local lifestate = entity_get_prop(me, "m_lifeState") ~= 0
	if lifestate then return end

	if contains(menu_get(gui["Visuals"]["indicators"].additional), "Debug text") then
		yoffset = 0
		screen = {client_screen_size()}

		for i, j in next, debug do
			render_text(screen[1] - 250, 15 + yoffset, 255, 255, 255, 255, "r", 0, j)
			yoffset = yoffset + 15
		end
	end
end

local fOffset = 0

visuals.active_builder = function(self)
	fOffset = 15
	screen = {client_screen_size()}

	local mode = gui["Anti-Aim"]["Algorithm"]
	local gglobal = mode[1]
	local stand = mode[2].enable
	local slow = mode[3].enable
	local move = mode[4].enable
	local air = mode[5].enable
	local duck = mode[6].enable

	for i=1, 6 do
		local state_to_int = conditions[i]
		if i ~= 1 then
			if menu_get(mode[i].enable) then
				local state_to_int = conditions[i]
				r, g, b, a = 255,255,255,255
				fOffset = fOffset + 45

				render_text(25, screen[2] / 2 - 125 + fOffset, r, g, b, a, "", 0, "mode: " .. menu_get(mode[i].selector))

				for p, x in next, menu.aa.mode do

				end

			else
				fOffset = fOffset + 15
				r, g, b, a = 125,125,125,125
			end
			render_text(15, screen[2] / 2 - 125 + fOffset, r, g, b, a, "", 0, state_to_int)

		else
			r, g, b, a = 255,255,255,255
			render_text(15, screen[2] / 2 - 125 + fOffset, r, g, b, a, "", 0, state_to_int)
			render_text(25, screen[2] / 2 - 125 + fOffset + 15, r, g, b, a, "", 0, "mode: " .. menu_get(mode[i].selector))
			fOffset = fOffset + 15

		end
	end
	render_text(15, screen[2] / 2 - 125, 255, 255, 255, 255, "bd", 0, "Anti-Aim Builder")
end

visuals.rounded_box = function(self, x, y, w, h, radius, r, g, b, a)
	renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)
	renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)
	renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)
	renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)
	renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)
	renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)
	renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)
	renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)
	renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25)
end

visuals.rounded_box_bottom = function(self, x, y, w, h, radius, r, g, b, a)
	renderer.rectangle(x+radius - 4,y,w-radius*2 + 4,radius,r,g,b,a)
	renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)
	renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)
	renderer.rectangle(x+w-radius,y+radius,radius - 4,h-radius*2,r,g,b,a)
	renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)
	renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)
end

visuals.color_mode = {
	white_mode = {
		notifcation = {
			box = { 254, 254, 254, 255 },
			inac_bar = { 217,225,236, 255 },
			load_bar = { 142, 18, 252, 255 },
		},
	},
	dark_mode = {
		notifcation = {

		}
	}
}

visuals.boxes = {}
visuals.check_text = false

visuals.dragable_box = function(self, str, minX, width, minY, height, additional)
	local cursorX, cursorY = menu_mouse_position()

	if self.boxes[str] == nil then
		self.boxes[str] = {
			drag = false,
			grabbed = {},
			x = minX,
			y = minY,
			hover = false,
			alpha = 0,
			sizing_drag = false,
			update_sizing = true,
			w = width,
			h = height,
			h_cache = height
		}
		self.boxes[str].w = self.boxes[str].w
		self.boxes[str].h = self.boxes[str].h_cache
	end

	if self.boxes[str].h_cache ~= height then
		if self.boxes[str].y + height < self.boxes[str].h then
			self.boxes[str].h = self.boxes[str].h
		else
			self.boxes[str].h_cache = height
			self.boxes[str].h = self.boxes[str].h_cache	
		end
	end

	local newminX, newMaxX = self.boxes[str].x, self.boxes[str].w + self.boxes[str].x
	local newminY, newMaxY = self.boxes[str].y, self.boxes[str].h + self.boxes[str].y
	local screen = {client_screen_size()}

	if is_menu_open() then
		local minsizeX, maxsizeX = newMaxX - 5, newMaxX + 10
		local minsizeY, maxsizeY = newMaxY - 5, newMaxY + 10
		
		--those are fine
		if (cursorX > minsizeX  and cursorX < maxsizeX) and (cursorY > minsizeY and cursorY < maxsizeY) or self.boxes[str].sizing_drag then		
			self.boxes[str].drag = false
				if not self.boxes[str].drag then	
						if client_key_state(0x1) then
							--print("mouseX: " .. cursorX .. " mouseY: " .. cursorY)
							if not self.boxes[str].sizing_drag then
								--this one
								self.boxes[str].grabbed = {w = cursorX - self.boxes[str].w, h = cursorY - self.boxes[str].h}
								self.boxes[str].sizing_drag = true		
							else
								self.boxes[str].drag = false
								--print("w: " .. self.boxes[str].w .. " h:" .. self.boxes[str].h .. " grab w:" .. self.boxes[str].grabbed.w .. " grab h:" .. self.boxes[str].h)

								--its somewhere here or in the .grabbed above
								if cursorX - self.boxes[str].grabbed.w < width then
									self.boxes[str].w = self.boxes[str].w
								else
									self.boxes[str].w = cursorX - self.boxes[str].grabbed.w
								end
								if cursorY - self.boxes[str].grabbed.h < height then
									self.boxes[str].h = self.boxes[str].h
								else
									self.boxes[str].h = cursorY - self.boxes[str].grabbed.h
								end	
							end
						else
							self.boxes[str].sizing_drag = false
							self:rounded_box(cursorX - 40, cursorY + 15, 67, 15, 4, 15,15,15,225)
							render_text(cursorX - 8, cursorY + 22, 255, 255, 255, 255, "-c", 0, "HOLD TO RESIZE")
	
						end		
					end
				end
				
				if not self.boxes[str].sizing_drag then
					if (cursorX > newminX and cursorX < newMaxX) and (cursorY > newminY and cursorY < newMaxY) or self.boxes[str].drag then
						self.boxes[str].hover = true				
							if client_key_state(0x1) then
								if not self.boxes[str].drag then
									self.boxes[str].grabbed = {x = cursorX - self.boxes[str].x, y = cursorY - self.boxes[str].y, w = self.boxes[str].w, h = self.boxes[str].h}
									self.boxes[str].drag = true
								else
									self.boxes[str].alpha = self.boxes[str].alpha + 5
									self.boxes[str].x = self.boxes[str].w + self.boxes[str].x >= screen[1] and self.boxes[str].x - 1 or self:clamp(cursorX - self.boxes[str].grabbed.x, 0, screen[1])
									self.boxes[str].y = self.boxes[str].h + self.boxes[str].y >= screen[2] and self.boxes[str].y - 1 or self:clamp(cursorY - self.boxes[str].grabbed.y, 0, screen[2])
									
									self.boxes[str].w = self.boxes[str].x <= 0 and self.boxes[str].w or self:clamp(self.boxes[str].grabbed.w, 0, screen[1])
									self.boxes[str].h = self.boxes[str].y <= 0 and self.boxes[str].h or self:clamp(self.boxes[str].grabbed.h, 0, screen[2])
								end
								else
								self.boxes[str].drag = false
							end
						else
							self.boxes[str].hover = false		
						end
					end		
				end

		return {self.boxes[str].x, self.boxes[str].y, self.boxes[str].w, self.boxes[str].h}
	end
	local avatar_storage = {}

visuals.animation = function(self, check, name, value, speed) 
	if check then 
		return helpers:round(name + (value - name) * globals.frametime() * speed, 2)
	else 
		return name > 0.9 and helpers:round(name - (value + name) * globals.frametime() * speed / 2, 2) or 0
	end
end

visuals.p_text = {}

visuals.pulsate_text = function(self, text, speed, max)
	if self.p_text[text] == nil then
		self.p_text[text] = {
			a = true,
			p = 0,
			wait = 0,
		}
	else
		if self.p_text[text].a then
			self.p_text[text].p = self.p_text[text].p + speed
			if self.p_text[text].p >= max then
				self.p_text[text].a = false
			end
		elseif self.p_text[text].a == false then
			self.p_text[text].p = self.p_text[text].p - speed
			if self.p_text[text].p <= 0 then
				self.p_text[text].a = true
			end
		end
		return self.p_text[text].p
	end
end
local d3 = '<svg id="svg" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="400" height="400" viewBox="0, 0, 400,400"><g id="svgg"><path id="path0" d="M359.600 0.400 C 359.600 0.640,358.011 0.800,355.633 0.800 C 351.134 0.800,350.400 0.974,350.400 2.043 C 350.400 2.727,350.069 2.800,346.963 2.800 C 343.862 2.800,343.505 2.878,343.316 3.600 C 343.190 4.082,342.767 4.402,342.253 4.405 C 340.606 4.416,339.600 4.887,339.600 5.647 C 339.600 6.307,339.280 6.400,337.000 6.400 C 334.463 6.400,334.400 6.425,334.400 7.445 C 334.400 8.458,334.343 8.482,332.600 8.221 C 330.865 7.961,330.800 7.988,330.800 8.975 C 330.800 9.809,330.608 10.000,329.774 10.000 C 328.403 10.000,327.200 10.682,327.200 11.459 C 327.200 11.976,326.889 12.044,325.486 11.834 C 323.624 11.555,322.831 12.902,324.539 13.444 C 325.152 13.639,325.195 13.758,324.753 14.038 C 324.449 14.230,324.387 14.391,324.615 14.394 C 324.843 14.397,325.074 14.981,325.128 15.692 C 325.183 16.414,325.662 17.438,326.213 18.014 C 327.750 19.618,327.706 24.400,326.155 24.400 C 325.041 24.400,325.032 24.489,325.822 27.700 C 326.074 28.723,326.006 28.800,324.847 28.800 C 323.689 28.800,323.600 28.899,323.600 30.200 C 323.600 31.593,323.610 31.600,325.400 31.600 C 327.017 31.600,327.200 31.694,327.200 32.530 C 327.200 33.491,325.711 35.200,324.874 35.200 C 324.579 35.200,324.400 35.879,324.400 37.000 C 324.400 37.990,324.580 38.800,324.800 38.800 C 325.037 38.800,325.200 40.267,325.200 42.400 C 325.200 45.973,325.207 46.000,326.200 46.000 C 327.000 46.000,327.200 46.200,327.200 47.000 C 327.200 47.904,327.043 48.000,325.557 48.000 C 324.224 48.000,323.960 48.119,324.157 48.633 C 324.291 48.981,324.401 49.656,324.403 50.133 C 324.404 50.676,324.852 51.255,325.603 51.681 C 326.526 52.207,326.812 52.665,326.854 53.681 C 326.890 54.537,326.968 54.700,327.076 54.146 C 327.249 53.262,329.261 52.543,330.103 53.064 C 330.349 53.216,330.405 53.132,330.238 52.862 C 330.081 52.608,330.163 52.400,330.419 52.400 C 330.676 52.400,330.782 52.130,330.655 51.800 C 330.489 51.367,330.699 51.200,331.413 51.200 C 331.956 51.200,332.379 51.065,332.353 50.900 C 332.107 49.346,332.396 49.109,334.200 49.379 C 335.935 49.639,336.000 49.612,336.000 48.625 C 336.000 47.677,336.135 47.600,337.800 47.600 C 339.333 47.600,339.600 47.481,339.600 46.800 C 339.600 46.119,339.867 46.000,341.400 46.000 C 343.053 46.000,343.200 45.919,343.200 45.000 C 343.200 44.081,343.347 44.000,345.000 44.000 C 346.519 44.000,346.800 43.878,346.800 43.218 C 346.800 42.532,347.128 42.422,349.500 42.318 C 351.953 42.211,352.212 42.118,352.328 41.300 C 352.438 40.521,352.695 40.400,354.228 40.400 C 355.733 40.400,356.000 40.280,356.000 39.600 C 356.000 38.882,356.267 38.800,358.600 38.800 L 361.200 38.800 361.200 41.400 C 361.200 43.733,361.118 44.000,360.400 44.000 C 359.719 44.000,359.600 44.267,359.600 45.800 C 359.600 46.790,359.420 47.623,359.200 47.650 C 358.980 47.678,358.575 47.723,358.300 47.750 C 357.967 47.783,357.760 48.704,357.682 50.500 C 357.578 52.872,357.468 53.200,356.782 53.200 C 356.122 53.200,356.000 53.481,356.000 55.000 C 356.000 56.653,355.919 56.800,355.000 56.800 C 354.081 56.800,354.000 56.947,354.000 58.600 C 354.000 60.133,353.881 60.400,353.200 60.400 C 352.519 60.400,352.400 60.667,352.400 62.200 C 352.400 63.853,352.319 64.000,351.400 64.000 C 350.481 64.000,350.400 64.147,350.400 65.800 C 350.400 67.333,350.281 67.600,349.600 67.600 C 349.008 67.600,348.800 67.867,348.800 68.624 C 348.800 69.187,348.636 69.546,348.436 69.422 C 347.568 68.886,346.800 69.718,346.800 71.196 C 346.800 72.370,346.622 72.753,346.000 72.916 C 345.369 73.081,345.200 73.462,345.200 74.719 C 345.200 76.086,345.057 76.349,344.200 76.564 C 343.554 76.726,343.200 77.096,343.200 77.608 C 343.200 78.133,342.931 78.400,342.400 78.400 C 341.719 78.400,341.600 78.667,341.600 80.200 C 341.600 81.853,341.519 82.000,340.600 82.000 C 339.681 82.000,339.600 82.147,339.600 83.800 C 339.600 85.333,339.481 85.600,338.800 85.600 C 338.269 85.600,338.000 85.867,338.000 86.392 C 338.000 86.904,337.646 87.274,337.000 87.436 C 336.123 87.656,336.000 87.903,336.000 89.443 C 336.000 90.933,335.879 91.200,335.200 91.200 C 334.667 91.200,334.400 91.467,334.400 92.000 C 334.400 92.594,334.133 92.800,333.364 92.800 C 332.376 92.800,332.334 92.888,332.464 94.697 C 332.582 96.346,332.500 96.595,331.834 96.597 C 331.413 96.599,330.995 96.870,330.904 97.200 C 330.757 97.733,330.786 97.733,331.163 97.200 C 331.397 96.870,331.591 96.789,331.594 97.020 C 331.604 97.725,330.691 98.400,329.728 98.400 C 328.876 98.400,328.832 98.521,329.062 100.200 C 329.310 102.010,329.163 102.214,327.729 102.037 C 327.470 102.005,327.200 102.388,327.129 102.889 C 327.029 103.594,326.784 103.770,326.047 103.666 C 325.215 103.549,325.119 103.663,325.291 104.566 C 325.482 105.561,325.239 105.778,324.100 105.630 C 323.610 105.566,323.488 105.900,323.492 107.291 C 323.493 107.671,323.339 107.886,323.150 107.769 C 322.693 107.486,322.840 109.661,323.322 110.300 C 323.529 110.575,324.036 110.800,324.449 110.800 C 325.152 110.800,325.200 111.206,325.200 117.200 C 325.200 123.333,325.167 123.600,324.400 123.600 C 322.935 123.600,323.314 125.843,324.830 126.146 C 326.411 126.462,326.315 127.740,324.697 127.927 C 323.446 128.071,323.436 128.105,324.109 130.000 C 324.839 132.056,325.142 132.400,326.224 132.400 C 327.114 132.400,327.200 132.558,327.200 134.200 C 327.200 135.853,327.119 136.000,326.200 136.000 C 325.281 136.000,325.200 136.147,325.200 137.800 C 325.200 138.790,325.020 139.600,324.800 139.600 C 324.580 139.600,324.400 140.410,324.400 141.400 C 324.400 142.390,324.220 143.200,324.000 143.200 C 323.290 143.200,323.575 145.054,324.400 145.800 C 325.276 146.593,325.628 152.400,324.800 152.400 C 324.580 152.400,324.400 153.210,324.400 154.200 C 324.400 155.990,324.407 156.000,325.800 156.000 C 326.933 156.000,327.200 156.152,327.200 156.800 C 327.200 157.240,327.020 157.600,326.800 157.600 C 326.580 157.600,326.400 157.969,326.400 158.420 C 326.400 159.486,325.501 161.203,324.441 162.163 C 323.377 163.126,323.387 163.351,324.519 163.957 C 325.951 164.723,326.556 165.897,325.465 165.793 C 324.939 165.743,324.877 165.778,325.306 165.884 C 325.694 165.979,325.927 166.194,325.824 166.362 C 325.720 166.530,325.889 166.667,326.200 166.667 C 326.511 166.667,326.672 166.517,326.559 166.333 C 326.445 166.150,326.538 166.000,326.764 166.000 C 326.990 166.000,327.080 165.753,326.964 165.452 C 326.734 164.851,327.838 164.252,328.463 164.639 C 328.678 164.772,328.820 164.637,328.779 164.340 C 328.620 163.182,328.832 162.852,329.636 163.007 C 330.335 163.141,330.391 163.071,329.979 162.575 C 329.576 162.089,329.599 162.025,330.104 162.218 C 330.529 162.382,330.702 162.230,330.660 161.727 C 330.618 161.218,330.865 161.009,331.483 161.030 C 332.050 161.049,332.349 160.835,332.319 160.430 C 332.169 158.380,332.422 157.600,333.237 157.600 C 333.725 157.600,334.158 157.281,334.274 156.837 C 334.384 156.417,334.817 155.984,335.237 155.874 C 335.681 155.758,336.000 155.325,336.000 154.837 C 336.000 154.254,336.254 154.000,336.837 154.000 C 337.325 154.000,337.758 153.681,337.874 153.237 C 337.984 152.817,338.417 152.384,338.837 152.274 C 339.428 152.120,339.600 151.712,339.600 150.465 C 339.600 149.101,339.737 148.836,340.500 148.728 C 341.078 148.646,341.446 148.278,341.528 147.700 C 341.610 147.122,341.932 146.800,342.428 146.800 C 342.924 146.800,343.200 146.524,343.200 146.028 C 343.200 145.532,343.522 145.210,344.100 145.128 C 344.844 145.022,345.021 144.712,345.121 143.341 C 345.212 142.093,345.435 141.632,346.021 141.479 C 346.480 141.359,346.800 140.931,346.800 140.437 C 346.800 139.854,347.054 139.600,347.637 139.600 C 348.125 139.600,348.558 139.281,348.674 138.837 C 348.784 138.417,349.217 137.984,349.637 137.874 C 350.227 137.720,350.400 137.313,350.400 136.081 C 350.400 134.714,350.543 134.451,351.400 134.236 C 352.046 134.074,352.400 133.704,352.400 133.192 C 352.400 132.667,352.669 132.400,353.200 132.400 C 353.718 132.400,354.000 132.133,354.000 131.643 C 354.000 131.170,354.374 130.793,355.000 130.636 C 355.857 130.421,356.000 130.157,356.000 128.792 C 356.000 127.467,356.134 127.200,356.800 127.200 C 357.381 127.200,357.600 126.933,357.600 126.228 C 357.600 125.524,357.849 125.220,358.500 125.128 C 359.248 125.022,359.421 124.713,359.523 123.300 C 359.622 121.926,359.795 121.600,360.423 121.600 C 360.931 121.600,361.200 121.326,361.200 120.808 C 361.200 120.296,361.554 119.926,362.200 119.764 C 363.052 119.550,363.200 119.283,363.200 117.957 C 363.200 116.667,363.337 116.400,364.000 116.400 C 364.581 116.400,364.800 116.133,364.800 115.428 C 364.800 114.724,365.049 114.420,365.700 114.328 C 366.448 114.222,366.621 113.913,366.723 112.500 C 366.822 111.126,366.995 110.800,367.623 110.800 C 368.118 110.800,368.400 110.526,368.400 110.043 C 368.400 109.570,368.774 109.193,369.400 109.036 C 370.257 108.821,370.400 108.557,370.400 107.192 C 370.400 105.867,370.534 105.600,371.200 105.600 C 371.781 105.600,372.000 105.333,372.000 104.628 C 372.000 103.924,372.249 103.620,372.900 103.528 C 373.648 103.422,373.821 103.113,373.923 101.700 C 374.022 100.326,374.195 100.000,374.823 100.000 C 375.475 100.000,375.600 99.716,375.600 98.228 C 375.600 96.695,375.721 96.438,376.500 96.328 C 377.078 96.246,377.446 95.878,377.528 95.300 C 377.610 94.722,377.932 94.400,378.428 94.400 C 379.076 94.400,379.200 94.112,379.200 92.600 C 379.200 90.947,379.281 90.800,380.200 90.800 C 381.119 90.800,381.200 90.653,381.200 89.000 C 381.200 87.467,381.319 87.200,382.000 87.200 C 382.681 87.200,382.800 86.933,382.800 85.400 C 382.800 83.747,382.881 83.600,383.800 83.600 C 384.533 83.600,384.800 83.387,384.800 82.800 C 384.800 82.267,385.067 82.000,385.600 82.000 C 386.280 82.000,386.400 81.733,386.400 80.228 C 386.400 78.695,386.521 78.438,387.300 78.328 C 388.118 78.212,388.211 77.953,388.318 75.500 C 388.422 73.128,388.532 72.800,389.218 72.800 C 389.878 72.800,390.000 72.519,390.000 71.000 C 390.000 69.347,390.081 69.200,391.000 69.200 C 391.919 69.200,392.000 69.053,392.000 67.400 C 392.000 65.867,392.119 65.600,392.800 65.600 C 393.517 65.600,393.600 65.333,393.600 63.028 C 393.600 60.665,393.673 60.445,394.500 60.328 C 395.248 60.222,395.421 59.913,395.523 58.500 C 395.622 57.126,395.795 56.800,396.423 56.800 C 397.134 56.800,397.200 56.498,397.200 53.228 C 397.200 49.828,397.243 49.649,398.100 49.528 C 398.975 49.404,399.003 49.253,399.112 44.100 C 399.177 41.016,399.386 38.800,399.612 38.800 C 399.844 38.800,400.000 36.626,400.000 33.400 C 400.000 30.189,399.843 28.000,399.613 28.000 C 399.394 28.000,399.177 26.054,399.113 23.500 C 399.004 19.177,398.965 18.995,398.100 18.872 C 397.321 18.762,397.200 18.505,397.200 16.972 C 397.200 15.484,397.075 15.200,396.423 15.200 C 395.795 15.200,395.622 14.874,395.523 13.500 C 395.421 12.087,395.248 11.778,394.500 11.672 C 393.922 11.590,393.600 11.268,393.600 10.772 C 393.600 10.276,393.324 10.000,392.828 10.000 C 392.332 10.000,392.010 9.678,391.928 9.100 C 391.846 8.522,391.478 8.154,390.900 8.072 C 390.322 7.990,390.000 7.668,390.000 7.172 C 390.000 6.676,389.724 6.400,389.228 6.400 C 388.732 6.400,388.410 6.078,388.328 5.500 C 388.222 4.752,387.913 4.579,386.500 4.477 C 385.126 4.378,384.800 4.205,384.800 3.577 C 384.800 2.925,384.516 2.800,383.028 2.800 C 381.495 2.800,381.238 2.679,381.128 1.900 C 381.005 1.035,380.823 0.996,376.500 0.887 C 373.946 0.823,372.000 0.606,372.000 0.387 C 372.000 0.154,369.527 0.000,365.800 0.000 C 361.933 0.000,359.600 0.151,359.600 0.400 M297.105 80.283 C 297.602 80.379,298.322 80.375,298.705 80.275 C 299.087 80.175,298.680 80.096,297.800 80.101 C 296.920 80.105,296.607 80.187,297.105 80.283 M319.333 100.971 C 319.585 101.505,319.855 101.878,319.932 101.801 C 320.181 101.553,319.558 100.000,319.211 100.000 C 319.026 100.000,319.081 100.437,319.333 100.971 M348.800 183.000 C 348.800 184.560,348.688 184.800,347.963 184.800 C 347.462 184.800,347.041 185.121,346.916 185.600 C 346.800 186.043,346.370 186.400,345.953 186.400 C 345.416 186.400,345.200 186.687,345.200 187.400 C 345.200 188.148,344.989 188.400,344.363 188.400 C 343.862 188.400,343.441 188.721,343.316 189.200 C 343.200 189.643,342.770 190.000,342.353 190.000 C 341.822 190.000,341.600 190.287,341.600 190.972 C 341.600 191.676,341.351 191.980,340.700 192.072 C 339.952 192.178,339.779 192.487,339.677 193.900 C 339.578 195.274,339.405 195.600,338.777 195.600 C 338.276 195.600,338.000 195.874,338.000 196.372 C 338.000 196.868,337.678 197.190,337.100 197.272 C 336.522 197.354,336.154 197.722,336.072 198.300 C 335.990 198.878,335.668 199.200,335.172 199.200 C 334.669 199.200,334.400 199.476,334.400 199.992 C 334.400 200.504,334.046 200.874,333.400 201.036 C 332.774 201.193,332.400 201.570,332.400 202.043 C 332.400 202.533,332.118 202.800,331.600 202.800 C 330.919 202.800,330.800 203.067,330.800 204.600 C 330.800 205.590,330.620 206.423,330.400 206.450 C 330.180 206.478,329.775 206.526,329.500 206.557 C 329.225 206.588,329.011 206.984,329.024 207.437 C 329.043 208.078,328.851 208.222,328.155 208.089 C 327.419 207.949,327.238 208.120,327.131 209.059 C 327.052 209.749,326.763 210.200,326.400 210.200 C 325.708 210.200,325.058 211.046,325.366 211.545 C 325.481 211.732,325.131 211.799,324.588 211.696 C 323.750 211.535,323.600 211.659,323.600 212.507 C 323.600 213.140,323.223 213.755,322.573 214.181 C 321.699 214.754,321.622 214.953,322.054 215.527 C 322.483 216.096,322.475 216.123,322.001 215.700 C 321.022 214.827,320.098 215.086,320.220 216.200 C 320.280 216.750,320.200 217.200,320.042 217.200 C 319.885 217.200,319.135 217.662,318.378 218.226 C 317.042 219.221,317.034 219.244,318.100 218.983 C 318.866 218.795,319.200 218.868,319.200 219.223 C 319.200 219.504,319.305 219.628,319.434 219.499 C 319.976 218.957,321.573 220.904,321.183 221.631 C 320.680 222.572,320.691 224.400,321.200 224.400 C 321.420 224.400,321.600 224.748,321.600 225.173 C 321.600 225.710,321.937 225.998,322.700 226.113 L 323.800 226.280 322.700 226.340 L 321.600 226.400 321.600 230.800 C 321.600 235.012,321.564 235.200,320.755 235.200 C 320.013 235.200,319.942 235.360,320.174 236.500 C 320.319 237.215,320.539 238.385,320.663 239.100 C 320.786 239.815,321.048 240.400,321.244 240.400 C 321.440 240.400,321.600 241.660,321.600 243.200 C 321.600 245.783,321.535 246.000,320.755 246.000 C 320.013 246.000,319.942 246.160,320.174 247.300 C 320.319 248.015,320.539 249.185,320.663 249.900 C 320.865 251.067,321.026 251.200,322.244 251.200 L 323.600 251.200 323.600 253.200 L 323.600 255.200 321.800 255.200 L 320.000 255.200 320.000 256.800 C 320.000 258.133,320.133 258.400,320.800 258.400 C 321.493 258.400,321.600 258.667,321.600 260.400 C 321.600 261.500,321.420 262.400,321.200 262.400 C 320.980 262.400,320.800 263.120,320.800 264.000 C 320.800 264.880,320.980 265.600,321.200 265.600 C 321.429 265.600,321.600 266.800,321.600 268.400 C 321.600 270.933,321.524 271.200,320.800 271.200 C 320.097 271.200,320.000 271.467,320.000 273.400 C 320.000 275.429,320.072 275.600,320.920 275.600 C 322.300 275.600,322.827 276.303,322.305 277.449 C 322.067 277.972,321.630 278.400,321.336 278.400 C 321.041 278.400,320.800 278.580,320.800 278.800 C 320.800 279.020,320.980 279.200,321.200 279.200 C 321.996 279.200,321.663 283.781,320.800 284.708 C 319.716 285.871,319.763 287.099,320.900 287.318 C 321.789 287.489,321.788 287.492,320.851 287.546 C 320.046 287.592,319.979 287.693,320.411 288.213 C 320.823 288.709,320.822 289.123,320.406 290.383 C 319.742 292.395,320.032 293.159,321.364 292.905 C 321.929 292.797,322.298 292.558,322.184 292.374 C 322.071 292.191,322.343 291.845,322.789 291.606 C 323.324 291.320,323.600 290.768,323.600 289.986 C 323.600 289.334,323.780 288.800,324.000 288.800 C 324.648 288.800,324.468 291.199,323.800 291.455 C 323.470 291.582,323.200 291.866,323.200 292.086 C 323.200 292.306,323.470 292.382,323.800 292.255 C 324.130 292.129,324.400 292.210,324.400 292.436 C 324.400 292.662,324.599 292.724,324.843 292.574 C 325.152 292.382,325.122 292.185,324.743 291.920 C 324.321 291.624,324.311 291.494,324.700 291.336 C 324.975 291.225,325.200 290.698,325.200 290.167 C 325.200 289.485,325.423 289.200,325.957 289.200 C 326.744 289.200,327.369 288.198,326.978 287.564 C 326.854 287.364,327.102 287.200,327.530 287.200 C 328.322 287.200,328.784 286.214,328.795 284.500 C 328.799 283.808,329.031 283.600,329.800 283.600 C 330.533 283.600,330.800 283.387,330.800 282.800 C 330.800 282.274,331.067 282.000,331.578 282.000 C 332.223 282.000,332.377 281.674,332.478 280.100 C 332.580 278.507,332.729 278.200,333.400 278.200 C 334.052 278.200,334.237 277.867,334.400 276.400 C 334.559 274.966,334.742 274.624,335.300 274.718 C 335.814 274.804,336.000 274.565,336.000 273.818 C 336.000 272.999,336.195 272.800,337.000 272.800 C 337.919 272.800,338.000 272.653,338.000 271.000 C 338.000 269.467,338.119 269.200,338.800 269.200 C 339.517 269.200,339.600 268.933,339.600 266.628 C 339.600 264.265,339.673 264.045,340.500 263.928 C 341.248 263.822,341.421 263.513,341.523 262.100 C 341.622 260.726,341.795 260.400,342.423 260.400 C 343.075 260.400,343.200 260.116,343.200 258.628 C 343.200 257.095,343.321 256.838,344.100 256.728 C 344.918 256.612,345.011 256.353,345.118 253.900 C 345.222 251.528,345.332 251.200,346.018 251.200 C 346.713 251.200,346.800 250.913,346.800 248.628 C 346.800 246.265,346.873 246.045,347.700 245.928 C 348.545 245.808,348.607 245.584,348.716 242.300 C 348.820 239.129,348.905 238.800,349.616 238.800 C 350.336 238.800,350.400 238.510,350.400 235.228 C 350.400 231.828,350.443 231.649,351.300 231.528 C 352.184 231.402,352.202 231.291,352.310 225.100 C 352.415 219.131,352.462 218.800,353.210 218.800 C 353.985 218.800,354.000 218.453,354.000 200.000 L 354.000 181.200 351.400 181.200 L 348.800 181.200 348.800 183.000 M322.770 292.476 C 322.442 293.841,322.485 294.400,322.917 294.400 C 323.516 294.400,323.725 292.924,323.175 292.584 C 322.969 292.457,322.787 292.408,322.770 292.476 M321.284 293.815 C 320.860 294.296,320.870 294.400,321.341 294.400 C 321.657 294.400,322.018 294.130,322.145 293.800 C 322.436 293.041,321.960 293.049,321.284 293.815 M319.701 297.800 C 319.705 298.680,319.787 298.993,319.883 298.495 C 319.979 297.998,319.975 297.278,319.875 296.895 C 319.775 296.513,319.696 296.920,319.701 297.800 " stroke="none" fill="#e2a3a9" fill-rule="evenodd"></path><path id="path1" d="M179.200 46.800 C 179.200 47.547,173.183 48.036,169.100 47.621 C 168.597 47.570,168.400 47.838,168.400 48.575 C 168.400 49.599,168.397 49.600,164.800 49.600 C 161.467 49.600,161.200 49.659,161.200 50.400 C 161.200 51.165,158.220 51.563,154.700 51.268 C 154.205 51.227,154.000 51.501,154.000 52.205 C 154.000 53.163,153.903 53.200,151.400 53.200 C 148.858 53.200,148.800 53.223,148.800 54.254 L 148.800 55.307 145.995 55.107 C 144.059 54.968,143.206 55.045,143.242 55.353 C 143.376 56.489,143.116 56.800,142.033 56.800 C 140.345 56.800,139.600 57.181,139.600 58.043 C 139.600 58.459,139.375 58.801,139.100 58.803 C 138.825 58.804,139.140 59.182,139.800 59.642 C 140.658 60.240,140.772 60.428,140.200 60.301 C 139.452 60.137,139.409 60.301,139.532 62.831 C 139.656 65.393,139.614 65.545,138.732 65.714 C 137.801 65.891,137.800 65.891,138.700 65.946 C 139.671 66.004,140.099 69.644,139.200 70.200 C 138.980 70.336,138.800 70.977,138.800 71.624 C 138.800 72.271,138.620 72.800,138.400 72.800 C 138.180 72.800,138.000 73.250,138.000 73.800 C 138.000 74.533,138.213 74.800,138.800 74.800 C 140.098 74.800,140.003 79.867,138.700 80.118 L 137.800 80.291 138.700 80.346 C 139.474 80.392,139.600 80.624,139.600 82.000 C 139.600 83.391,139.482 83.601,138.700 83.606 C 138.178 83.610,137.987 83.736,138.245 83.906 C 139.596 84.799,140.025 95.342,138.824 98.144 C 138.221 99.552,138.109 100.256,138.402 100.803 C 138.621 101.212,138.800 102.009,138.800 102.574 C 138.800 103.138,138.980 103.600,139.200 103.600 C 139.443 103.600,139.600 105.400,139.600 108.200 C 139.600 112.438,139.541 112.800,138.847 112.800 C 138.375 112.800,138.027 113.149,137.915 113.731 C 137.763 114.526,137.874 114.637,138.669 114.485 C 139.535 114.319,139.600 114.436,139.600 116.153 C 139.600 117.733,139.484 118.000,138.800 118.000 C 137.645 118.000,137.679 119.895,138.837 120.072 C 139.636 120.194,139.623 120.246,138.573 121.200 C 137.967 121.750,137.575 122.017,137.701 121.793 C 137.828 121.570,137.535 121.199,137.049 120.970 C 136.172 120.556,136.166 120.579,136.056 124.771 C 135.995 127.090,136.037 128.896,136.149 128.784 C 136.261 128.672,136.389 127.220,136.433 125.557 C 136.494 123.279,136.651 122.533,137.070 122.533 C 137.453 122.533,137.498 122.662,137.213 122.947 C 136.986 123.174,136.832 124.269,136.872 125.380 L 136.944 127.400 137.094 125.500 C 137.284 123.086,138.000 123.007,138.000 125.400 C 138.000 126.390,138.160 127.200,138.356 127.200 C 139.649 127.200,140.084 150.238,138.813 151.389 C 137.637 152.453,137.627 156.000,138.800 156.000 C 139.481 156.000,139.600 156.267,139.600 157.800 C 139.600 159.333,139.481 159.600,138.800 159.600 C 138.267 159.600,138.000 159.867,138.000 160.400 C 138.000 160.933,138.267 161.200,138.800 161.200 C 139.898 161.200,139.876 163.048,138.768 163.946 C 137.898 164.650,137.927 164.873,139.275 167.820 C 139.575 168.477,139.542 173.558,139.200 179.400 C 139.174 179.840,139.275 180.795,139.425 181.522 C 139.644 182.584,139.516 183.038,138.779 183.822 L 137.861 184.800 138.723 185.718 L 139.586 186.636 138.714 187.508 L 137.842 188.380 138.721 189.316 C 139.933 190.606,139.988 193.600,138.800 193.600 C 138.213 193.600,138.000 193.867,138.000 194.600 C 138.000 195.333,138.213 195.600,138.800 195.600 C 139.728 195.600,139.853 196.608,139.122 198.211 C 138.752 199.023,138.752 199.431,139.122 200.024 C 140.008 201.442,139.737 204.318,138.700 204.518 L 137.800 204.691 138.700 204.746 C 139.471 204.792,139.600 205.025,139.600 206.372 C 139.600 207.685,139.451 207.973,138.700 208.118 L 137.800 208.291 138.700 208.346 C 139.677 208.405,140.173 217.200,139.200 217.200 C 138.980 217.200,138.800 217.662,138.800 218.226 C 138.800 218.791,138.605 219.618,138.366 220.064 C 138.014 220.721,138.096 221.050,138.794 221.794 C 140.028 223.108,139.584 232.409,138.245 233.294 C 137.987 233.464,138.178 233.590,138.700 233.594 C 139.482 233.599,139.600 233.809,139.600 235.200 C 139.600 236.533,139.467 236.800,138.800 236.800 C 138.213 236.800,138.000 237.067,138.000 237.800 C 138.000 238.548,138.211 238.800,138.837 238.800 C 139.617 238.800,139.658 238.958,139.439 241.100 C 139.223 243.208,139.189 243.849,139.184 245.900 C 139.179 247.966,138.678 251.200,138.363 251.200 C 138.163 251.200,138.000 251.650,138.000 252.200 C 138.000 252.933,138.213 253.200,138.800 253.200 C 139.731 253.200,139.907 254.719,139.122 255.976 C 138.752 256.569,138.752 256.977,139.122 257.789 C 139.825 259.331,139.709 260.433,138.734 261.470 L 137.868 262.392 138.734 263.143 C 140.008 264.248,140.065 271.200,138.800 271.200 C 138.059 271.200,138.000 271.467,138.000 274.800 C 138.000 278.133,138.059 278.400,138.800 278.400 C 139.560 278.400,139.600 278.667,139.600 283.800 C 139.600 287.133,139.447 289.200,139.200 289.200 C 138.963 289.200,138.800 290.667,138.800 292.800 C 138.800 294.933,138.637 296.400,138.400 296.400 C 138.180 296.400,138.000 296.850,138.000 297.400 C 138.000 298.143,138.212 298.400,138.824 298.400 C 139.618 298.400,139.641 298.563,139.465 303.100 C 139.264 308.276,138.901 310.800,138.356 310.800 C 138.160 310.800,138.000 311.610,138.000 312.600 C 138.000 313.590,138.180 314.400,138.400 314.400 C 138.620 314.400,138.800 315.019,138.800 315.776 C 138.800 316.533,138.980 317.264,139.200 317.400 C 139.993 317.890,139.668 320.000,138.800 320.000 C 138.119 320.000,138.000 320.267,138.000 321.800 C 138.000 323.333,138.119 323.600,138.800 323.600 C 139.481 323.600,139.600 323.867,139.600 325.400 C 139.600 326.933,139.481 327.200,138.800 327.200 C 137.724 327.200,137.728 328.830,138.806 329.806 L 139.612 330.535 138.806 331.393 C 137.780 332.486,137.764 334.462,138.774 335.376 C 139.422 335.963,139.475 336.238,139.096 337.068 C 138.756 337.814,138.763 338.248,139.122 338.824 C 139.741 339.815,139.732 341.400,139.101 342.410 C 138.516 343.346,139.392 345.364,140.414 345.436 C 140.768 345.461,140.802 345.410,140.500 345.309 C 140.225 345.217,140.003 344.840,140.006 344.471 C 140.011 343.942,140.085 343.915,140.356 344.343 C 140.559 344.662,140.799 344.725,140.940 344.496 C 141.073 344.282,141.680 344.206,142.290 344.327 L 143.400 344.548 142.400 344.834 L 141.400 345.120 142.519 345.160 C 143.209 345.185,143.976 344.844,144.519 344.270 C 145.004 343.759,145.715 343.224,146.100 343.083 C 146.485 342.941,146.800 342.562,146.800 342.240 C 146.800 341.919,147.205 341.598,147.700 341.528 C 148.278 341.446,148.646 341.078,148.728 340.500 C 148.839 339.720,149.094 339.600,150.645 339.600 C 152.128 339.600,152.415 339.480,152.318 338.900 C 152.239 338.433,152.499 338.158,153.100 338.072 C 153.751 337.980,154.000 337.676,154.000 336.972 C 154.000 336.202,154.208 336.000,155.000 336.000 C 155.723 336.000,156.000 335.785,156.000 335.223 C 156.000 334.595,156.326 334.422,157.700 334.323 C 158.692 334.251,159.421 333.992,159.450 333.700 C 159.478 333.425,159.523 333.020,159.550 332.800 C 159.578 332.580,159.960 332.400,160.400 332.400 C 160.924 332.400,161.200 332.133,161.200 331.628 C 161.200 331.132,161.522 330.810,162.100 330.728 C 162.678 330.646,163.046 330.278,163.128 329.700 C 163.210 329.122,163.532 328.800,164.028 328.800 C 164.524 328.800,164.800 328.524,164.800 328.028 C 164.800 327.532,165.122 327.210,165.700 327.128 C 166.278 327.046,166.646 326.678,166.728 326.100 C 166.838 325.321,167.095 325.200,168.628 325.200 C 170.133 325.200,170.400 325.080,170.400 324.400 C 170.400 323.867,170.667 323.600,171.200 323.600 C 171.787 323.600,172.000 323.333,172.000 322.600 C 172.000 321.800,172.200 321.600,173.000 321.600 C 173.733 321.600,174.000 321.387,174.000 320.800 C 174.000 320.267,174.267 320.000,174.800 320.000 C 175.387 320.000,175.600 319.733,175.600 319.000 C 175.600 318.081,175.747 318.000,177.400 318.000 C 178.912 318.000,179.200 317.876,179.200 317.228 C 179.200 316.732,179.522 316.410,180.100 316.328 C 180.678 316.246,181.046 315.878,181.128 315.300 C 181.210 314.722,181.532 314.400,182.028 314.400 C 182.524 314.400,182.800 314.124,182.800 313.628 C 182.800 313.132,183.122 312.810,183.700 312.728 C 184.278 312.646,184.646 312.278,184.728 311.700 C 184.810 311.122,185.132 310.800,185.628 310.800 C 186.124 310.800,186.400 310.524,186.400 310.028 C 186.400 309.532,186.722 309.210,187.300 309.128 C 187.878 309.046,188.246 308.678,188.328 308.100 C 188.438 307.321,188.695 307.200,190.228 307.200 C 191.733 307.200,192.000 307.080,192.000 306.400 C 192.000 305.867,192.267 305.600,192.800 305.600 C 193.387 305.600,193.600 305.333,193.600 304.600 C 193.600 303.800,193.800 303.600,194.600 303.600 C 195.333 303.600,195.600 303.387,195.600 302.800 C 195.600 302.267,195.867 302.000,196.400 302.000 C 196.987 302.000,197.200 301.733,197.200 301.000 C 197.200 300.200,197.400 300.000,198.200 300.000 C 199.000 300.000,199.200 299.800,199.200 299.000 C 199.200 298.267,199.413 298.000,200.000 298.000 C 200.533 298.000,200.800 297.733,200.800 297.200 C 200.800 296.613,201.067 296.400,201.800 296.400 C 202.600 296.400,202.800 296.200,202.800 295.400 C 202.800 294.481,202.947 294.400,204.600 294.400 C 206.133 294.400,206.400 294.281,206.400 293.600 C 206.400 293.067,206.667 292.800,207.200 292.800 C 207.787 292.800,208.000 292.533,208.000 291.800 C 208.000 291.000,208.200 290.800,209.000 290.800 C 209.733 290.800,210.000 290.587,210.000 290.000 C 210.000 289.467,210.267 289.200,210.800 289.200 C 211.387 289.200,211.600 288.933,211.600 288.200 C 211.600 287.400,211.800 287.200,212.600 287.200 C 213.333 287.200,213.600 286.987,213.600 286.400 C 213.600 285.867,213.867 285.600,214.400 285.600 C 214.987 285.600,215.200 285.333,215.200 284.600 C 215.200 283.800,215.400 283.600,216.200 283.600 C 216.933 283.600,217.200 283.387,217.200 282.800 C 217.200 282.267,217.467 282.000,218.000 282.000 C 218.587 282.000,218.800 281.733,218.800 281.000 C 218.800 280.200,219.000 280.000,219.800 280.000 C 220.533 280.000,220.800 279.787,220.800 279.200 C 220.800 278.667,221.067 278.400,221.600 278.400 C 222.187 278.400,222.400 278.133,222.400 277.400 C 222.400 276.600,222.600 276.400,223.400 276.400 C 224.133 276.400,224.400 276.187,224.400 275.600 C 224.400 275.067,224.667 274.800,225.200 274.800 C 225.787 274.800,226.000 274.533,226.000 273.800 C 226.000 273.000,226.200 272.800,227.000 272.800 C 227.733 272.800,228.000 272.587,228.000 272.000 C 228.000 271.461,228.267 271.200,228.818 271.200 C 229.267 271.200,229.606 270.975,229.570 270.700 C 229.420 269.543,229.655 269.200,230.600 269.200 C 231.333 269.200,231.600 268.987,231.600 268.400 C 231.600 267.717,231.867 267.600,233.425 267.600 C 235.088 267.600,235.239 267.520,235.125 266.700 C 235.031 266.024,235.224 265.768,235.900 265.672 C 236.544 265.581,236.800 265.275,236.800 264.596 C 236.800 264.074,237.008 263.519,237.262 263.362 C 237.548 263.185,237.615 263.252,237.438 263.538 C 237.256 263.832,237.463 264.000,238.008 264.000 C 238.753 264.000,238.829 263.843,238.596 262.783 C 238.340 261.618,238.375 261.578,239.422 261.841 C 240.432 262.095,240.500 262.036,240.317 261.080 C 240.135 260.124,240.208 260.062,241.260 260.272 C 242.488 260.518,242.697 260.102,241.999 258.798 C 241.532 257.926,242.289 257.173,242.800 258.000 C 243.202 258.651,244.009 258.151,243.968 257.276 C 243.949 256.860,243.859 256.792,243.735 257.100 C 243.624 257.375,243.358 257.600,243.143 257.600 C 242.928 257.600,242.871 257.408,243.017 257.173 C 243.162 256.939,243.037 256.780,242.740 256.821 C 240.916 257.071,240.800 256.903,240.800 254.000 C 240.800 251.280,240.771 251.200,239.800 251.200 C 238.900 251.200,238.800 251.040,238.800 249.600 C 238.800 248.160,238.900 248.000,239.800 248.000 C 240.600 248.000,240.800 247.800,240.800 247.000 C 240.800 246.200,240.600 246.000,239.800 246.000 C 239.020 246.000,238.800 245.795,238.800 245.070 C 238.800 244.558,239.250 243.717,239.800 243.200 C 241.037 242.038,241.350 230.561,240.187 229.024 C 239.382 227.959,239.442 226.500,240.300 226.276 C 240.731 226.163,240.577 226.075,239.900 226.046 C 238.478 225.986,238.435 224.883,239.804 223.596 L 240.808 222.653 239.771 221.570 C 239.113 220.883,238.893 220.390,239.167 220.220 C 239.405 220.073,239.600 219.333,239.600 218.576 C 239.600 217.620,239.783 217.200,240.200 217.200 C 240.573 217.200,240.800 216.822,240.800 216.200 C 240.800 215.390,240.603 215.200,239.761 215.200 C 238.742 215.200,238.728 215.162,238.986 213.100 C 239.130 211.945,239.339 209.155,239.450 206.900 C 239.607 203.698,239.777 202.800,240.226 202.800 C 240.670 202.800,240.800 202.166,240.800 200.000 C 240.800 197.280,240.771 197.200,239.800 197.200 C 238.633 197.200,238.410 195.337,239.286 192.912 C 239.668 191.857,239.668 191.400,239.286 190.789 C 238.698 189.848,238.646 188.400,239.200 188.400 C 239.437 188.400,239.600 186.933,239.600 184.800 C 239.600 181.867,239.711 181.200,240.200 181.200 C 240.573 181.200,240.800 180.822,240.800 180.200 C 240.800 179.400,240.600 179.200,239.800 179.200 L 238.800 179.200 238.800 173.000 L 238.800 166.800 239.800 166.800 C 240.713 166.800,240.800 166.649,240.800 165.070 C 240.800 163.741,240.568 163.121,239.800 162.400 C 239.250 161.883,238.800 161.039,238.800 160.525 C 238.800 159.589,238.884 159.359,240.132 156.868 C 240.944 155.247,240.957 154.441,240.187 153.424 C 239.378 152.354,239.388 148.800,240.200 148.800 C 240.676 148.800,240.800 148.222,240.800 146.000 C 240.800 143.778,240.676 143.200,240.200 143.200 C 239.783 143.200,239.600 142.780,239.600 141.824 C 239.600 141.067,239.406 140.328,239.170 140.181 C 238.894 140.011,239.059 139.576,239.628 138.970 L 240.517 138.024 239.695 136.047 L 238.874 134.070 239.837 133.165 C 241.057 132.019,241.113 130.800,239.944 130.800 C 238.016 130.800,237.433 128.556,239.200 127.940 C 240.626 127.443,240.705 126.958,239.529 125.938 C 238.860 125.358,238.767 125.073,239.129 124.711 C 239.704 124.136,239.749 122.539,239.200 122.200 C 238.307 121.648,238.757 120.000,239.800 120.000 C 240.771 120.000,240.800 119.920,240.800 117.200 C 240.800 114.480,240.771 114.400,239.800 114.400 C 238.672 114.400,238.447 113.354,239.286 112.011 C 239.668 111.400,239.668 110.943,239.286 109.888 C 238.700 108.268,238.639 103.347,239.200 103.000 C 239.420 102.864,239.600 102.133,239.600 101.376 C 239.600 100.420,239.783 100.000,240.200 100.000 C 240.689 100.000,240.800 99.333,240.800 96.400 C 240.800 92.827,240.793 92.800,239.800 92.800 L 238.800 92.800 238.800 87.400 L 238.800 82.000 239.800 82.000 C 240.771 82.000,240.800 81.920,240.800 79.200 C 240.800 76.480,240.771 76.400,239.800 76.400 C 238.483 76.400,238.472 75.248,239.777 74.021 C 240.695 73.159,240.717 73.045,240.131 72.151 C 239.567 71.290,239.567 71.110,240.131 70.249 C 240.717 69.355,240.695 69.241,239.777 68.379 C 238.329 67.018,238.345 64.000,239.800 64.000 C 240.600 64.000,240.800 63.800,240.800 63.000 C 240.800 62.200,240.600 62.000,239.800 62.000 C 238.900 62.000,238.800 61.840,238.800 60.400 C 238.800 58.960,238.900 58.800,239.800 58.800 C 240.600 58.800,240.800 58.600,240.800 57.800 C 240.800 57.000,240.600 56.800,239.800 56.800 C 238.881 56.800,238.800 56.653,238.800 55.000 C 238.800 53.492,238.925 53.200,239.567 53.200 C 241.146 53.200,241.707 52.768,240.912 52.165 C 240.252 51.665,240.273 51.622,241.200 51.573 L 242.200 51.520 241.200 51.242 C 240.650 51.089,240.200 50.702,240.200 50.382 C 240.200 49.916,239.344 49.777,235.900 49.686 C 231.632 49.574,231.600 49.566,231.600 48.591 C 231.600 47.901,231.392 47.627,230.900 47.668 C 226.502 48.037,220.800 47.547,220.800 46.800 C 220.800 46.010,220.533 46.000,200.000 46.000 C 179.467 46.000,179.200 46.010,179.200 46.800 M126.105 109.087 C 126.714 109.179,127.614 109.177,128.105 109.082 C 128.597 108.987,128.100 108.911,127.000 108.914 C 125.900 108.917,125.497 108.995,126.105 109.087 M134.400 115.200 C 134.400 116.433,135.063 116.777,135.875 115.965 C 136.188 115.652,136.385 115.652,136.578 115.965 C 136.726 116.204,137.062 116.395,137.324 116.388 C 137.586 116.381,137.440 116.163,137.000 115.903 C 135.935 115.275,135.132 115.167,135.460 115.697 C 135.617 115.951,135.534 116.006,135.255 115.834 C 134.647 115.458,135.056 114.808,135.924 114.772 C 136.475 114.749,136.452 114.680,135.800 114.400 C 134.530 113.854,134.400 113.929,134.400 115.200 M136.114 118.200 C 136.117 119.300,136.195 119.703,136.287 119.095 C 136.379 118.486,136.377 117.586,136.282 117.095 C 136.187 116.603,136.111 117.100,136.114 118.200 M136.930 119.274 C 136.952 120.342,137.159 120.800,137.680 120.937 C 138.671 121.196,138.999 120.517,138.031 120.210 C 137.583 120.068,137.175 119.500,137.075 118.881 C 136.954 118.129,136.910 118.249,136.930 119.274 M233.230 304.100 C 233.376 305.222,233.159 305.600,232.371 305.600 C 230.592 305.600,231.690 306.992,233.574 307.126 C 235.140 307.239,235.283 307.181,234.822 306.626 C 234.222 305.904,233.004 305.759,233.438 306.462 C 233.614 306.746,233.548 306.815,233.266 306.641 C 232.937 306.437,232.988 306.085,233.450 305.379 C 233.803 304.841,233.936 304.397,233.746 304.394 C 233.556 304.391,233.670 304.213,234.000 304.000 C 234.510 303.671,234.492 303.611,233.882 303.606 C 233.488 303.603,233.194 303.825,233.230 304.100 M229.600 307.556 C 229.600 308.396,230.636 308.754,231.068 308.063 C 231.433 307.479,231.350 307.354,230.551 307.288 C 230.028 307.244,229.600 307.365,229.600 307.556 M228.900 309.128 C 228.322 309.210,228.000 309.532,228.000 310.028 C 228.000 310.584,227.721 310.800,227.005 310.800 C 226.211 310.800,226.029 310.982,226.105 311.699 C 226.175 312.362,225.964 312.631,225.300 312.727 C 224.722 312.809,224.400 313.132,224.400 313.628 C 224.400 314.170,224.122 314.400,223.468 314.400 C 222.759 314.400,222.544 314.615,222.568 315.300 C 222.596 316.077,222.353 316.227,220.800 316.400 C 219.556 316.538,219.000 316.785,219.000 317.200 C 219.000 317.530,218.595 317.858,218.100 317.928 C 217.449 318.020,217.200 318.324,217.200 319.028 C 217.200 319.786,216.990 320.000,216.244 320.000 C 215.580 320.000,215.306 320.213,215.344 320.700 C 215.380 321.143,215.070 321.447,214.500 321.528 C 213.849 321.620,213.600 321.924,213.600 322.628 C 213.600 323.398,213.392 323.600,212.600 323.600 C 212.050 323.600,211.621 323.735,211.647 323.900 C 211.787 324.784,211.516 325.200,210.800 325.200 C 210.213 325.200,210.000 325.467,210.000 326.200 C 210.000 327.000,209.800 327.200,209.000 327.200 C 208.450 327.200,208.021 327.335,208.047 327.500 C 208.215 328.560,207.873 328.800,206.200 328.800 C 204.547 328.800,204.400 328.881,204.400 329.800 C 204.400 330.533,204.187 330.800,203.600 330.800 C 203.067 330.800,202.800 331.067,202.800 331.600 C 202.800 332.187,202.533 332.400,201.800 332.400 C 201.000 332.400,200.800 332.600,200.800 333.400 C 200.800 334.133,200.587 334.400,200.000 334.400 C 199.467 334.400,199.200 334.667,199.200 335.200 C 199.200 335.787,198.933 336.000,198.200 336.000 C 197.400 336.000,197.200 336.200,197.200 337.000 C 197.200 337.919,197.053 338.000,195.400 338.000 C 193.867 338.000,193.600 338.119,193.600 338.800 C 193.600 339.333,193.333 339.600,192.800 339.600 C 192.213 339.600,192.000 339.867,192.000 340.600 C 192.000 341.400,191.800 341.600,191.000 341.600 C 190.267 341.600,190.000 341.813,190.000 342.400 C 190.000 342.933,189.733 343.200,189.200 343.200 C 188.613 343.200,188.400 343.467,188.400 344.200 C 188.400 345.000,188.200 345.200,187.400 345.200 C 186.667 345.200,186.400 345.413,186.400 346.000 C 186.400 346.681,186.133 346.800,184.600 346.800 C 182.947 346.800,182.800 346.881,182.800 347.800 C 182.800 348.533,182.587 348.800,182.000 348.800 C 181.467 348.800,181.200 349.067,181.200 349.600 C 181.200 350.187,180.933 350.400,180.200 350.400 C 179.281 350.400,179.200 350.547,179.200 352.200 L 179.200 354.000 200.000 354.000 C 220.533 354.000,220.800 353.990,220.800 353.200 C 220.800 352.453,226.496 351.964,230.898 352.332 C 231.282 352.364,231.576 352.257,231.551 352.095 C 231.327 350.647,231.634 350.399,233.700 350.368 C 235.956 350.334,235.900 350.217,233.428 349.801 C 232.563 349.656,232.023 349.416,232.228 349.268 C 232.432 349.121,232.660 348.640,232.733 348.200 C 232.807 347.760,233.032 347.229,233.233 347.020 C 234.134 346.086,233.655 343.200,232.600 343.200 C 231.322 343.200,231.237 341.838,232.434 340.564 C 233.107 339.847,233.184 339.518,232.834 338.864 C 232.191 337.661,232.287 336.000,233.000 336.000 C 233.772 336.000,233.761 335.245,232.963 333.647 C 232.381 332.480,232.381 332.288,232.963 331.400 C 233.369 330.781,233.600 329.547,233.600 328.000 C 233.600 326.453,233.369 325.219,232.963 324.600 C 232.381 323.712,232.381 323.520,232.963 322.353 C 233.314 321.651,233.600 320.142,233.600 319.000 C 233.600 317.858,233.314 316.349,232.963 315.647 C 232.381 314.480,232.381 314.288,232.963 313.400 C 233.925 311.933,233.763 310.855,232.500 310.300 C 231.895 310.034,231.285 309.655,231.145 309.457 C 231.004 309.259,230.705 309.212,230.479 309.351 C 230.253 309.491,230.008 309.469,229.934 309.302 C 229.860 309.136,229.395 309.057,228.900 309.128 " stroke="none" fill="#e8cfe9" fill-rule="evenodd"></path><path id="path2" d="M80.000 102.600 C 80.000 103.343,79.788 103.600,79.175 103.600 C 78.549 103.600,78.380 103.817,78.475 104.500 C 78.567 105.165,78.376 105.432,77.741 105.522 C 77.268 105.590,76.790 105.995,76.678 106.422 C 76.556 106.889,76.130 107.200,75.612 107.200 C 75.030 107.200,74.773 107.428,74.821 107.900 C 74.998 109.637,74.766 110.800,74.243 110.800 C 73.726 110.800,73.008 111.864,73.123 112.460 C 73.151 112.603,72.729 112.831,72.187 112.968 C 71.344 113.179,71.200 113.448,71.200 114.808 C 71.200 116.133,71.066 116.400,70.400 116.400 C 69.684 116.400,69.413 116.816,69.553 117.700 C 69.579 117.865,69.142 118.000,68.582 118.000 C 68.000 118.000,67.593 118.214,67.630 118.500 C 67.879 120.416,67.562 121.600,66.800 121.600 C 65.955 121.600,65.876 121.822,65.990 123.900 C 66.053 125.049,65.941 125.200,65.031 125.200 C 64.076 125.200,64.000 125.332,64.000 127.000 C 64.000 128.673,63.760 129.015,62.700 128.847 C 62.356 128.793,62.290 129.271,62.390 131.100 C 62.452 132.223,62.331 132.400,61.509 132.400 C 60.672 132.400,60.544 132.604,60.457 134.090 C 60.361 135.706,59.800 136.571,59.119 136.150 C 58.944 136.042,58.778 136.143,58.750 136.376 C 58.723 136.609,58.655 136.980,58.600 137.200 C 58.545 137.420,58.477 138.050,58.450 138.600 C 58.414 139.317,58.173 139.600,57.600 139.600 C 56.925 139.600,56.800 139.867,56.800 141.305 C 56.800 142.690,56.631 143.085,55.900 143.405 C 54.926 143.832,54.924 143.840,54.850 146.800 C 54.807 148.517,54.687 148.800,54.000 148.800 C 53.282 148.800,53.200 149.067,53.200 151.400 C 53.200 153.397,53.066 154.000,52.624 154.000 C 51.703 154.000,51.436 154.793,51.211 158.200 C 51.029 160.962,50.904 161.384,50.300 161.282 C 49.667 161.176,49.600 161.605,49.600 165.755 C 49.600 170.210,49.574 170.348,48.700 170.472 C 47.826 170.596,47.797 170.752,47.685 175.800 C 47.583 180.440,47.486 181.059,46.785 181.549 C 46.024 182.080,46.000 182.666,46.000 200.315 C 46.000 210.335,46.111 218.422,46.248 218.286 C 47.085 217.448,47.554 219.407,47.673 224.245 C 47.796 229.242,47.828 229.404,48.700 229.528 C 49.508 229.643,50.124 235.479,49.647 238.500 C 49.621 238.665,49.960 238.800,50.400 238.800 C 51.109 238.800,51.200 239.067,51.200 241.150 C 51.200 244.612,51.558 246.000,52.450 246.000 C 53.106 246.000,53.200 246.324,53.200 248.600 C 53.200 250.933,53.282 251.200,54.000 251.200 C 54.591 251.200,54.816 251.487,54.861 252.300 C 54.894 252.905,54.939 253.670,54.961 254.000 C 54.982 254.330,55.405 254.658,55.900 254.728 C 56.727 254.845,57.241 257.807,56.837 260.130 C 56.806 260.311,56.928 260.368,57.109 260.256 C 57.752 259.859,58.314 260.622,58.541 262.200 C 58.667 263.080,58.777 263.845,58.785 263.900 C 58.793 263.955,59.160 264.000,59.600 264.000 C 60.281 264.000,60.400 264.267,60.400 265.800 C 60.400 267.468,60.476 267.600,61.431 267.600 C 62.341 267.600,62.453 267.751,62.390 268.900 C 62.276 270.978,62.355 271.200,63.200 271.200 C 63.881 271.200,64.000 271.467,64.000 273.000 C 64.000 274.668,64.076 274.800,65.031 274.800 C 65.941 274.800,66.053 274.951,65.990 276.100 C 65.876 278.178,65.955 278.400,66.800 278.400 C 67.481 278.400,67.600 278.667,67.600 280.200 C 67.600 281.853,67.681 282.000,68.600 282.000 C 69.150 282.000,69.579 282.135,69.553 282.300 C 69.413 283.184,69.684 283.600,70.400 283.600 C 71.081 283.600,71.200 283.867,71.200 285.400 C 71.200 287.053,71.281 287.200,72.200 287.200 C 72.750 287.200,73.179 287.335,73.153 287.500 C 72.982 288.579,73.260 289.262,73.787 289.060 C 74.518 288.780,74.753 289.144,74.875 290.745 C 74.927 291.435,75.157 292.003,75.385 292.006 C 75.613 292.009,75.530 292.187,75.200 292.400 C 74.709 292.717,74.755 292.789,75.451 292.794 C 76.270 292.800,77.663 293.958,76.949 294.040 C 76.757 294.062,77.016 294.197,77.524 294.340 C 78.032 294.483,78.476 294.780,78.512 295.000 C 78.547 295.220,79.077 295.821,79.689 296.336 C 80.301 296.852,80.698 297.441,80.571 297.646 C 80.444 297.852,80.489 297.994,80.670 297.963 C 81.748 297.775,82.000 298.114,82.000 299.753 C 82.000 301.530,83.562 302.693,84.274 301.446 C 84.414 301.201,84.394 301.120,84.231 301.267 C 83.688 301.754,82.502 300.121,82.330 298.650 C 82.237 297.852,82.329 297.200,82.534 297.200 C 82.740 297.200,83.334 296.741,83.854 296.179 C 84.938 295.010,85.164 292.800,84.200 292.800 C 83.827 292.800,83.600 292.422,83.600 291.800 C 83.600 291.250,83.759 290.800,83.953 290.800 C 84.619 290.800,84.774 289.020,84.186 288.123 C 83.440 286.983,83.446 286.207,84.211 285.040 C 84.679 284.325,84.726 283.857,84.411 283.028 C 84.127 282.282,84.131 281.703,84.422 281.159 C 84.737 280.570,84.687 280.055,84.222 279.124 C 83.342 277.360,83.334 268.378,84.211 267.040 C 84.679 266.325,84.726 265.857,84.411 265.028 C 84.135 264.304,84.132 263.701,84.400 263.200 C 85.014 262.052,84.896 260.400,84.200 260.400 C 83.827 260.400,83.600 260.022,83.600 259.400 C 83.600 258.778,83.827 258.400,84.200 258.400 C 84.633 258.400,84.800 257.956,84.800 256.800 C 84.800 255.644,84.633 255.200,84.200 255.200 C 83.428 255.200,83.435 253.651,84.213 252.624 C 85.022 251.554,85.012 248.000,84.200 248.000 C 83.695 248.000,83.600 247.111,83.600 242.400 C 83.600 237.689,83.695 236.800,84.200 236.800 C 85.123 236.800,85.030 233.719,84.100 233.476 C 83.669 233.363,83.823 233.275,84.500 233.246 C 85.509 233.204,85.600 233.068,85.600 231.600 C 85.600 230.132,85.509 229.996,84.500 229.954 C 83.823 229.925,83.669 229.837,84.100 229.724 C 85.030 229.481,85.123 226.400,84.200 226.400 C 83.224 226.400,83.384 222.719,84.400 221.800 C 85.402 220.893,85.411 220.329,84.433 219.624 C 83.745 219.128,83.725 218.981,84.242 218.192 C 84.827 217.300,84.636 216.058,83.829 215.506 C 83.592 215.344,83.836 215.210,84.376 215.206 C 85.327 215.200,85.332 215.183,84.576 214.570 C 84.149 214.224,84.016 214.049,84.280 214.182 C 84.544 214.314,84.949 214.069,85.180 213.637 C 85.717 212.634,85.715 212.000,85.176 212.000 C 84.943 212.000,84.867 212.225,85.006 212.500 C 85.145 212.775,85.001 212.685,84.686 212.300 C 84.356 211.898,83.565 211.600,82.829 211.600 C 81.728 211.600,81.582 211.486,81.800 210.800 C 82.009 210.142,81.872 210.000,81.027 210.000 C 80.198 210.000,80.000 209.807,80.000 209.000 C 80.000 208.267,79.787 208.000,79.200 208.000 C 78.537 208.000,78.400 207.733,78.400 206.443 C 78.400 205.117,78.252 204.850,77.400 204.636 L 76.400 204.385 76.400 193.592 C 76.400 186.697,76.544 182.782,76.800 182.750 C 77.020 182.722,77.425 182.678,77.700 182.650 C 78.293 182.591,78.286 182.640,78.350 177.800 C 78.389 174.843,78.524 174.000,78.957 174.000 C 79.773 174.000,80.000 173.084,80.000 169.794 C 80.000 167.205,80.096 166.824,80.800 166.600 C 81.704 166.313,81.732 166.199,81.613 163.300 C 81.543 161.610,81.650 161.200,82.163 161.200 C 82.809 161.200,83.050 160.578,82.500 160.333 C 82.335 160.260,82.308 159.390,82.440 158.400 L 82.680 156.600 82.746 158.400 C 82.848 161.184,83.498 161.656,83.445 158.908 C 83.402 156.664,84.236 154.770,84.952 155.486 C 85.228 155.761,85.242 155.637,85.335 152.134 C 85.396 149.800,85.076 149.216,84.274 150.200 C 84.094 150.420,84.062 150.195,84.201 149.700 C 84.350 149.171,84.278 148.800,84.027 148.800 C 83.756 148.800,83.600 147.485,83.600 145.200 C 83.600 141.627,83.607 141.600,84.600 141.600 C 85.892 141.600,85.959 140.234,84.730 138.926 L 83.861 138.000 84.730 137.074 C 85.618 136.129,85.922 134.400,85.200 134.400 C 84.971 134.400,84.800 133.200,84.800 131.600 C 84.800 129.378,84.676 128.800,84.200 128.800 C 83.396 128.800,83.406 125.691,84.213 124.624 C 84.536 124.196,84.800 123.286,84.800 122.600 C 84.800 121.914,84.536 121.004,84.213 120.576 C 83.064 119.058,83.376 112.800,84.600 112.800 C 85.519 112.800,85.600 112.653,85.600 111.000 C 85.600 109.347,85.519 109.200,84.600 109.200 C 83.380 109.200,83.184 106.957,84.222 104.876 C 84.678 103.961,84.734 103.425,84.433 102.862 C 83.989 102.031,81.604 101.450,81.594 102.169 C 81.590 102.449,81.485 102.460,81.294 102.200 C 80.701 101.393,80.000 101.609,80.000 102.600 M33.152 288.313 C 33.021 289.107,33.079 289.481,33.301 289.259 C 33.503 289.057,33.601 288.467,33.519 287.946 C 33.393 287.145,33.337 287.202,33.152 288.313 M41.553 293.585 C 41.527 293.923,41.534 294.356,41.568 294.547 C 41.603 294.737,41.354 295.316,41.016 295.832 C 40.160 297.138,40.148 302.000,41.000 302.000 C 41.444 302.000,41.600 302.467,41.600 303.800 C 41.600 304.790,41.780 305.600,42.000 305.600 C 42.220 305.600,42.400 306.410,42.400 307.400 C 42.400 309.053,42.319 309.200,41.400 309.200 C 39.855 309.200,39.855 315.748,41.400 317.200 C 41.950 317.717,42.400 318.558,42.400 319.070 C 42.400 319.795,42.180 320.000,41.400 320.000 C 40.407 320.000,40.400 320.027,40.400 323.600 C 40.400 326.533,40.511 327.200,41.000 327.200 C 41.719 327.200,41.777 328.373,41.128 329.798 C 40.722 330.689,40.773 330.951,41.493 331.670 L 42.329 332.507 41.365 333.472 C 40.008 334.828,40.013 337.497,41.375 338.776 C 42.185 339.538,42.271 339.818,41.884 340.437 C 41.537 340.992,41.532 341.485,41.862 342.360 C 42.255 343.400,42.195 343.634,41.353 344.366 C 40.511 345.099,40.407 345.508,40.460 347.897 C 40.516 350.430,40.537 350.487,40.786 348.800 L 41.052 347.000 41.256 348.800 L 41.460 350.600 41.530 348.714 C 41.585 347.244,41.787 346.728,42.448 346.374 C 43.044 346.055,43.216 346.051,43.025 346.360 C 42.875 346.602,42.924 346.800,43.134 346.800 C 43.667 346.800,44.000 345.778,44.000 344.144 C 44.000 343.318,44.163 342.853,44.400 343.000 C 44.620 343.136,44.800 343.046,44.800 342.800 C 44.800 342.554,44.977 342.462,45.192 342.595 C 45.411 342.730,45.697 342.136,45.838 341.254 C 46.011 340.170,46.330 339.607,46.846 339.472 C 47.429 339.320,47.600 338.906,47.600 337.645 C 47.600 336.237,47.737 335.981,48.607 335.762 C 49.161 335.623,49.590 335.305,49.560 335.055 C 49.369 333.461,49.667 332.476,50.400 332.284 C 50.840 332.169,51.200 331.817,51.200 331.502 C 51.200 331.186,51.650 330.723,52.200 330.473 C 52.991 330.112,53.200 329.723,53.200 328.609 C 53.200 327.328,53.498 326.994,54.500 327.153 C 54.665 327.179,54.800 326.419,54.800 325.464 C 54.800 324.001,54.957 323.657,55.800 323.273 C 56.350 323.022,56.800 322.543,56.800 322.209 C 56.800 321.867,57.151 321.600,57.600 321.600 C 58.352 321.600,58.400 321.333,58.400 317.200 C 58.400 313.120,58.344 312.800,57.628 312.800 C 57.132 312.800,56.810 312.478,56.728 311.900 C 56.658 311.405,56.375 310.978,56.100 310.950 C 55.825 310.923,55.441 310.878,55.247 310.850 C 55.052 310.822,54.799 310.440,54.684 310.000 C 54.569 309.560,54.201 309.200,53.865 309.200 C 53.530 309.200,53.198 308.795,53.128 308.300 C 53.058 307.805,52.775 307.378,52.500 307.350 C 52.225 307.322,51.820 307.278,51.600 307.250 C 51.380 307.223,51.200 306.463,51.200 305.563 C 51.200 304.262,51.036 303.882,50.400 303.716 C 49.960 303.601,49.600 303.261,49.600 302.961 C 49.600 302.661,49.150 302.302,48.600 302.164 C 47.751 301.951,47.600 301.682,47.600 300.384 C 47.600 299.205,47.416 298.796,46.800 298.600 C 46.360 298.460,46.000 298.198,46.000 298.016 C 46.000 297.835,45.550 297.574,45.000 297.436 C 44.029 297.192,43.786 296.367,43.895 293.686 C 43.911 293.288,43.788 293.278,43.349 293.643 C 42.893 294.021,42.830 293.988,43.025 293.479 C 43.203 293.016,43.043 292.862,42.434 292.907 C 41.975 292.942,41.579 293.247,41.553 293.585 M82.083 340.539 C 82.174 341.193,81.929 341.442,81.000 341.644 L 79.800 341.905 81.000 342.007 C 82.017 342.093,82.060 342.136,81.278 342.285 C 80.771 342.382,80.104 342.252,79.796 341.996 C 79.144 341.456,78.400 341.790,78.400 342.624 C 78.400 342.941,78.126 343.200,77.790 343.200 C 77.455 343.200,77.009 343.650,76.800 344.200 C 76.483 345.034,76.157 345.200,74.837 345.200 C 73.605 345.200,73.198 345.378,73.000 346.000 C 72.803 346.621,72.395 346.800,71.173 346.800 C 69.659 346.800,69.337 347.137,69.553 348.500 C 69.579 348.665,69.150 348.800,68.600 348.800 C 67.829 348.800,67.600 349.006,67.600 349.703 C 67.600 350.528,67.444 350.593,65.800 350.463 C 64.091 350.327,64.000 350.372,64.000 351.360 C 64.000 352.326,63.872 352.400,62.200 352.400 C 60.667 352.400,60.400 352.519,60.400 353.200 C 60.400 353.881,60.133 354.000,58.600 354.000 C 56.947 354.000,56.800 354.081,56.800 355.000 C 56.800 355.919,56.653 356.000,55.000 356.000 C 53.467 356.000,53.200 356.119,53.200 356.800 C 53.200 357.511,52.933 357.600,50.790 357.600 C 48.588 357.600,48.347 357.686,48.000 358.600 C 47.718 359.342,47.308 359.613,46.410 359.650 C 44.349 359.735,44.197 359.798,44.318 360.509 C 44.419 361.106,44.039 361.209,41.518 361.269 L 38.600 361.338 41.200 361.600 L 43.800 361.862 41.200 361.985 C 39.770 362.053,39.050 362.180,39.600 362.266 C 42.438 362.713,42.400 362.679,42.400 364.808 C 42.400 366.666,42.333 366.800,41.400 366.800 C 40.068 366.800,40.068 368.031,41.400 369.364 C 42.873 370.836,42.873 374.000,41.400 374.000 C 39.851 374.000,39.855 380.549,41.405 382.005 C 42.084 382.643,42.279 383.081,42.005 383.355 C 41.782 383.578,41.600 384.354,41.600 385.080 C 41.600 385.987,41.412 386.400,41.000 386.400 C 40.501 386.400,40.400 387.178,40.400 391.000 C 40.400 394.822,40.501 395.600,41.000 395.600 C 41.745 395.600,41.833 397.839,41.100 398.135 C 40.825 398.246,42.220 398.369,44.200 398.408 C 46.742 398.459,47.506 398.578,46.800 398.815 C 46.022 399.076,46.199 399.126,47.600 399.039 C 49.085 398.947,49.422 398.779,49.526 398.079 C 49.641 397.300,49.935 397.221,53.126 397.115 C 56.149 397.015,56.593 396.909,56.544 396.300 C 56.502 395.763,56.797 395.600,57.812 395.600 C 59.653 395.600,60.400 395.241,60.400 394.357 C 60.400 393.692,60.716 393.600,63.000 393.600 C 65.333 393.600,65.600 393.518,65.600 392.800 C 65.600 392.119,65.867 392.000,67.400 392.000 C 69.053 392.000,69.200 391.919,69.200 391.000 C 69.200 390.081,69.347 390.000,71.000 390.000 C 72.533 390.000,72.800 389.881,72.800 389.200 C 72.800 388.519,73.067 388.400,74.600 388.400 C 75.590 388.400,76.379 388.265,76.353 388.100 C 76.130 386.691,76.446 386.400,78.200 386.400 C 79.874 386.400,80.000 386.327,80.000 385.355 C 80.000 384.405,80.118 384.327,81.285 384.498 C 82.677 384.702,83.819 383.948,83.475 383.052 C 83.332 382.678,83.583 382.567,84.337 382.668 C 85.250 382.791,85.287 382.760,84.600 382.448 C 83.833 382.099,83.842 382.067,84.800 381.667 C 85.350 381.438,85.571 381.239,85.290 381.225 C 84.235 381.173,83.983 379.305,84.780 377.446 L 85.537 375.680 84.569 374.770 C 83.418 373.689,83.274 371.576,84.222 369.676 C 84.687 368.745,84.737 368.230,84.422 367.641 C 84.135 367.105,84.128 366.515,84.400 365.800 C 85.040 364.116,84.914 361.200,84.200 361.200 C 82.998 361.200,83.357 350.898,84.604 349.596 L 85.608 348.547 84.604 347.604 C 83.832 346.879,83.600 346.261,83.600 344.930 C 83.600 343.816,83.422 343.198,83.100 343.194 C 82.767 343.190,82.800 343.058,83.200 342.800 C 83.530 342.587,83.605 342.409,83.367 342.406 C 83.128 342.403,82.933 342.138,82.933 341.818 C 82.933 341.497,83.083 341.328,83.267 341.441 C 83.450 341.555,83.600 341.436,83.600 341.178 C 83.600 340.883,84.051 340.775,84.817 340.888 C 85.688 341.016,85.979 340.922,85.840 340.559 C 85.733 340.280,85.812 339.995,86.015 339.926 C 86.219 339.857,85.391 339.776,84.176 339.747 C 82.143 339.699,81.975 339.763,82.083 340.539 M41.443 345.788 C 41.298 346.775,40.800 346.990,40.800 346.067 C 40.800 345.590,40.964 345.200,41.165 345.200 C 41.365 345.200,41.490 345.465,41.443 345.788 M40.500 351.087 C 39.813 351.334,39.869 352.000,40.576 352.000 C 41.239 352.000,41.763 351.340,41.307 351.082 C 41.138 350.986,40.775 350.989,40.500 351.087 " stroke="none" fill="#ada6dc" fill-rule="evenodd"></path><path id="path3" d="M134.767 59.040 C 134.511 59.348,134.450 59.600,134.631 59.600 C 135.776 59.600,133.892 60.375,132.557 60.453 C 131.372 60.523,130.926 60.719,130.957 61.158 C 130.985 61.556,130.511 61.850,129.586 62.006 C 127.834 62.303,127.200 62.680,127.200 63.424 C 127.200 63.841,126.698 64.000,125.376 64.000 C 124.340 64.000,123.653 64.162,123.785 64.376 C 124.022 64.760,122.514 66.400,121.925 66.400 C 121.746 66.400,121.600 66.670,121.600 67.000 C 121.600 67.434,121.154 67.600,119.990 67.600 C 118.641 67.600,118.319 67.762,118.000 68.600 C 117.791 69.150,117.345 69.600,117.010 69.600 C 116.667 69.600,116.400 69.950,116.400 70.400 C 116.400 71.081,116.133 71.200,114.600 71.200 C 113.059 71.200,112.800 71.317,112.800 72.010 C 112.800 72.506,112.412 72.967,111.800 73.200 C 111.250 73.409,110.800 73.844,110.800 74.167 C 110.800 74.572,110.272 74.792,109.100 74.877 C 107.687 74.979,107.378 75.152,107.272 75.900 C 107.190 76.478,106.868 76.800,106.372 76.800 C 105.876 76.800,105.600 77.076,105.600 77.572 C 105.600 78.068,105.278 78.390,104.700 78.472 C 104.122 78.554,103.754 78.922,103.672 79.500 C 103.562 80.279,103.305 80.400,101.772 80.400 C 100.267 80.400,100.000 80.520,100.000 81.200 C 100.000 81.733,99.733 82.000,99.200 82.000 C 98.613 82.000,98.400 82.267,98.400 83.000 C 98.400 83.800,98.200 84.000,97.400 84.000 C 96.667 84.000,96.400 84.213,96.400 84.800 C 96.400 85.333,96.133 85.600,95.600 85.600 C 95.013 85.600,94.800 85.867,94.800 86.600 C 94.800 87.400,94.600 87.600,93.800 87.600 C 93.067 87.600,92.800 87.813,92.800 88.400 C 92.800 88.947,92.533 89.200,91.957 89.200 C 91.380 89.200,91.186 89.385,91.340 89.788 C 91.633 90.550,90.550 91.633,89.788 91.340 C 89.385 91.186,89.200 91.380,89.200 91.957 C 89.200 92.539,88.947 92.800,88.382 92.800 C 87.933 92.800,87.594 93.025,87.630 93.300 C 87.779 94.452,87.547 94.800,86.628 94.800 C 85.924 94.800,85.620 95.049,85.528 95.700 C 85.441 96.314,85.170 96.561,84.677 96.477 C 84.263 96.407,83.984 96.578,84.025 96.877 C 84.183 98.060,83.949 98.400,82.973 98.400 C 82.128 98.400,81.991 98.542,82.200 99.200 C 82.437 99.948,81.920 100.240,80.700 100.047 C 80.535 100.021,80.400 100.192,80.400 100.427 C 80.400 100.671,80.786 100.756,81.300 100.625 L 82.200 100.396 81.300 100.859 C 80.805 101.114,80.400 101.485,80.400 101.685 C 80.400 101.884,80.565 101.945,80.766 101.821 C 80.967 101.697,81.223 101.821,81.334 102.098 C 81.446 102.374,81.551 102.406,81.568 102.169 C 81.621 101.456,83.987 102.029,84.433 102.862 C 84.734 103.425,84.678 103.961,84.222 104.876 C 83.184 106.957,83.380 109.200,84.600 109.200 C 85.519 109.200,85.600 109.347,85.600 111.000 C 85.600 112.653,85.519 112.800,84.600 112.800 C 83.376 112.800,83.064 119.058,84.213 120.576 C 84.536 121.004,84.800 121.914,84.800 122.600 C 84.800 123.286,84.536 124.196,84.213 124.624 C 83.406 125.691,83.396 128.800,84.200 128.800 C 84.676 128.800,84.800 129.378,84.800 131.600 C 84.800 133.200,84.971 134.400,85.200 134.400 C 85.922 134.400,85.618 136.129,84.730 137.074 L 83.861 138.000 84.730 138.926 C 85.959 140.234,85.892 141.600,84.600 141.600 C 83.607 141.600,83.600 141.627,83.600 145.200 C 83.600 147.485,83.756 148.800,84.027 148.800 C 84.278 148.800,84.350 149.171,84.201 149.700 C 84.062 150.195,84.094 150.420,84.274 150.200 C 85.059 149.238,85.397 149.787,85.342 151.933 L 85.283 154.200 85.542 152.200 C 85.712 150.881,85.990 150.200,86.357 150.200 C 86.713 150.200,86.974 149.625,87.078 148.611 C 87.249 146.942,87.757 146.332,88.680 146.686 C 88.984 146.803,89.204 146.741,89.169 146.549 C 88.875 144.938,89.274 143.274,90.000 143.084 C 90.636 142.918,90.800 142.538,90.800 141.237 C 90.800 139.655,91.027 139.404,92.306 139.572 C 92.585 139.608,92.788 139.494,92.759 139.319 C 92.618 138.482,92.867 138.033,93.600 137.800 C 94.214 137.605,94.400 137.195,94.400 136.037 C 94.400 134.816,94.591 134.442,95.400 134.073 C 95.950 133.822,96.400 133.364,96.400 133.055 C 96.400 132.746,96.760 132.399,97.200 132.284 C 97.836 132.118,98.000 131.738,98.000 130.437 C 98.000 128.958,98.096 128.800,99.000 128.800 C 99.733 128.800,100.000 128.587,100.000 128.000 C 100.000 127.560,100.264 127.200,100.586 127.200 C 101.364 127.200,102.000 125.945,102.000 124.409 C 102.000 123.446,102.158 123.191,102.700 123.282 C 103.167 123.361,103.442 123.101,103.528 122.500 C 103.611 121.917,103.931 121.600,104.438 121.600 C 104.904 121.600,105.374 121.196,105.601 120.597 C 105.811 120.045,106.207 119.640,106.482 119.697 C 106.756 119.754,107.043 119.395,107.118 118.900 C 107.209 118.308,107.533 118.000,108.065 118.000 C 108.525 118.000,108.961 117.671,109.074 117.237 C 109.184 116.817,109.617 116.384,110.037 116.274 C 110.481 116.158,110.800 115.725,110.800 115.237 C 110.800 114.654,111.054 114.400,111.637 114.400 C 112.125 114.400,112.558 114.081,112.674 113.637 C 112.784 113.217,113.217 112.784,113.637 112.674 C 114.071 112.561,114.400 112.125,114.400 111.665 C 114.400 111.133,114.708 110.809,115.300 110.718 C 115.795 110.643,116.153 110.355,116.096 110.079 C 115.963 109.433,116.510 109.263,119.200 109.118 C 121.133 109.013,121.415 108.890,121.528 108.099 C 121.708 106.831,123.492 106.832,123.672 108.100 C 123.792 108.940,123.965 108.991,126.300 108.868 C 127.884 108.785,128.818 108.895,128.850 109.168 C 128.878 109.406,128.922 109.825,128.950 110.100 C 128.980 110.402,129.743 110.648,130.879 110.721 C 132.275 110.811,132.705 110.983,132.548 111.390 C 132.326 111.970,133.716 112.951,134.147 112.519 C 134.286 112.380,134.400 112.653,134.400 113.126 C 134.400 113.725,134.726 114.067,135.477 114.255 L 136.554 114.525 135.577 114.891 L 134.600 115.257 135.531 116.018 C 136.308 116.653,136.442 117.092,136.345 118.684 C 136.244 120.314,136.355 120.654,137.111 121.031 C 137.597 121.273,137.861 121.635,137.698 121.836 C 137.534 122.036,137.912 121.750,138.537 121.200 C 139.613 120.254,139.629 120.193,138.837 120.072 C 137.679 119.895,137.645 118.000,138.800 118.000 C 139.484 118.000,139.600 117.733,139.600 116.153 C 139.600 114.436,139.535 114.319,138.669 114.485 C 137.874 114.637,137.763 114.526,137.915 113.731 C 138.027 113.149,138.375 112.800,138.847 112.800 C 139.541 112.800,139.600 112.438,139.600 108.200 C 139.600 105.400,139.443 103.600,139.200 103.600 C 138.980 103.600,138.800 103.138,138.800 102.574 C 138.800 102.009,138.621 101.212,138.402 100.803 C 138.109 100.256,138.221 99.552,138.824 98.144 C 140.025 95.342,139.596 84.799,138.245 83.906 C 137.987 83.736,138.178 83.610,138.700 83.606 C 139.480 83.601,139.600 83.390,139.600 82.028 C 139.600 80.715,139.451 80.427,138.700 80.282 L 137.800 80.109 138.700 80.054 C 140.007 79.975,140.106 74.800,138.800 74.800 C 138.213 74.800,138.000 74.533,138.000 73.800 C 138.000 73.250,138.180 72.800,138.400 72.800 C 138.620 72.800,138.800 72.271,138.800 71.624 C 138.800 70.977,138.980 70.336,139.200 70.200 C 140.085 69.653,139.670 66.069,138.700 65.882 L 137.800 65.709 138.733 65.654 C 139.628 65.602,139.660 65.489,139.533 62.863 C 139.409 60.302,139.452 60.136,140.200 60.297 C 140.755 60.416,140.632 60.228,139.800 59.683 C 138.222 58.649,135.391 58.288,134.767 59.040 M137.000 115.903 C 137.440 116.163,137.586 116.381,137.324 116.388 C 137.062 116.395,136.734 116.217,136.596 115.993 C 136.458 115.770,136.190 115.683,136.000 115.800 C 135.810 115.917,135.552 115.846,135.426 115.642 C 135.128 115.160,135.980 115.301,137.000 115.903 M138.031 120.210 C 138.999 120.517,138.671 121.196,137.680 120.937 C 137.159 120.800,136.952 120.342,136.930 119.274 C 136.910 118.249,136.954 118.129,137.075 118.881 C 137.175 119.500,137.583 120.068,138.031 120.210 M136.470 122.767 C 136.794 125.775,136.320 128.756,135.500 128.872 C 134.922 128.954,134.554 129.322,134.472 129.900 C 134.388 130.495,134.070 130.800,133.535 130.800 C 133.075 130.800,132.639 131.129,132.526 131.563 C 132.416 131.983,131.983 132.416,131.563 132.526 C 131.119 132.642,130.800 133.075,130.800 133.563 C 130.800 134.146,130.546 134.400,129.963 134.400 C 129.475 134.400,129.042 134.719,128.926 135.163 C 128.816 135.583,128.383 136.016,127.963 136.126 C 127.370 136.281,127.200 136.688,127.200 137.955 C 127.200 139.354,127.060 139.620,126.213 139.832 C 125.671 139.969,125.242 140.197,125.261 140.340 C 125.374 141.205,125.104 141.600,124.400 141.600 C 123.808 141.600,123.600 141.867,123.600 142.624 C 123.600 143.187,123.436 143.546,123.236 143.422 C 122.368 142.886,121.600 143.718,121.600 145.196 C 121.600 146.370,121.422 146.753,120.800 146.916 C 120.332 147.038,120.000 147.462,120.000 147.935 C 120.000 148.470,119.695 148.788,119.100 148.872 C 118.352 148.978,118.179 149.287,118.077 150.700 C 117.978 152.074,117.805 152.400,117.177 152.400 C 116.525 152.400,116.400 152.684,116.400 154.172 C 116.400 155.705,116.279 155.962,115.500 156.072 C 114.752 156.178,114.579 156.487,114.477 157.900 C 114.378 159.274,114.205 159.600,113.577 159.600 C 112.923 159.600,112.800 159.884,112.800 161.400 C 112.800 163.053,112.719 163.200,111.800 163.200 C 110.836 163.200,110.800 163.293,110.800 165.800 C 110.800 168.133,110.718 168.400,110.000 168.400 C 109.276 168.400,109.200 168.667,109.200 171.200 C 109.200 173.920,109.171 174.000,108.200 174.000 C 107.207 174.000,107.200 174.027,107.200 177.600 C 107.200 180.933,107.141 181.200,106.400 181.200 C 105.622 181.200,105.600 181.467,105.600 190.972 L 105.600 200.744 104.700 200.872 C 103.882 200.988,103.789 201.247,103.682 203.700 C 103.578 206.072,103.468 206.400,102.782 206.400 C 102.122 206.400,102.000 206.681,102.000 208.200 L 102.000 210.000 100.200 210.000 C 98.688 210.000,98.400 210.124,98.400 210.772 C 98.400 211.268,98.078 211.590,97.500 211.672 C 96.915 211.755,96.554 212.122,96.469 212.721 C 96.339 213.638,96.318 213.641,90.773 213.521 C 86.459 213.427,85.162 213.518,85.007 213.925 C 84.896 214.214,84.579 214.336,84.303 214.196 C 84.026 214.055,84.149 214.224,84.576 214.570 C 85.332 215.183,85.327 215.200,84.376 215.206 C 83.836 215.210,83.592 215.344,83.829 215.506 C 84.636 216.058,84.827 217.300,84.242 218.192 C 83.725 218.981,83.745 219.128,84.433 219.624 C 85.411 220.329,85.402 220.893,84.400 221.800 C 83.384 222.719,83.224 226.400,84.200 226.400 C 85.123 226.400,85.030 229.481,84.100 229.724 C 83.669 229.837,83.823 229.925,84.500 229.954 C 85.509 229.996,85.600 230.132,85.600 231.600 C 85.600 233.068,85.509 233.204,84.500 233.246 C 83.823 233.275,83.669 233.363,84.100 233.476 C 85.030 233.719,85.123 236.800,84.200 236.800 C 83.695 236.800,83.600 237.689,83.600 242.400 C 83.600 247.111,83.695 248.000,84.200 248.000 C 85.012 248.000,85.022 251.554,84.213 252.624 C 83.435 253.651,83.428 255.200,84.200 255.200 C 84.633 255.200,84.800 255.644,84.800 256.800 C 84.800 257.956,84.633 258.400,84.200 258.400 C 83.827 258.400,83.600 258.778,83.600 259.400 C 83.600 260.022,83.827 260.400,84.200 260.400 C 84.896 260.400,85.014 262.052,84.400 263.200 C 84.132 263.701,84.135 264.304,84.411 265.028 C 84.726 265.857,84.679 266.325,84.211 267.040 C 83.334 268.378,83.342 277.360,84.222 279.124 C 84.687 280.055,84.737 280.570,84.422 281.159 C 84.131 281.703,84.127 282.282,84.411 283.028 C 84.726 283.857,84.679 284.325,84.211 285.040 C 83.446 286.207,83.440 286.983,84.186 288.123 C 84.774 289.020,84.619 290.800,83.953 290.800 C 83.759 290.800,83.600 291.250,83.600 291.800 C 83.600 292.422,83.827 292.800,84.200 292.800 C 85.164 292.800,84.938 295.010,83.854 296.179 C 83.334 296.741,82.740 297.200,82.534 297.200 C 81.912 297.200,82.449 300.049,83.216 300.816 C 83.611 301.211,84.007 301.460,84.097 301.370 C 84.187 301.280,84.177 301.773,84.076 302.467 C 83.920 303.525,83.999 303.686,84.567 303.468 C 85.071 303.275,85.351 303.515,85.661 304.404 C 85.927 305.167,86.354 305.600,86.839 305.600 C 87.333 305.600,87.600 305.880,87.600 306.400 C 87.600 306.918,87.867 307.200,88.357 307.200 C 88.838 307.200,89.208 307.579,89.375 308.242 C 89.572 309.029,89.827 309.234,90.418 309.079 C 91.034 308.918,91.200 309.079,91.200 309.837 C 91.200 310.515,91.424 310.800,91.957 310.800 C 92.433 310.800,92.808 311.176,92.968 311.815 C 93.136 312.483,93.458 312.791,93.911 312.715 C 94.366 312.639,94.643 312.906,94.728 313.500 C 94.808 314.065,95.133 314.400,95.600 314.400 C 96.067 314.400,96.392 314.735,96.472 315.300 C 96.542 315.795,96.825 316.223,97.100 316.250 C 97.375 316.278,97.780 316.322,98.000 316.350 C 98.220 316.378,98.400 316.760,98.400 317.200 C 98.400 317.724,98.667 318.000,99.172 318.000 C 99.668 318.000,99.990 318.322,100.072 318.900 C 100.178 319.644,100.488 319.821,101.859 319.921 C 103.107 320.012,103.568 320.235,103.721 320.821 C 103.841 321.280,104.269 321.600,104.763 321.600 C 105.323 321.600,105.600 321.855,105.600 322.371 C 105.600 322.795,105.915 323.224,106.300 323.324 C 106.967 323.498,106.967 323.509,106.300 323.554 C 105.891 323.581,105.600 323.921,105.600 324.372 C 105.600 324.868,105.278 325.190,104.700 325.272 C 104.122 325.354,103.754 325.722,103.672 326.300 C 103.564 327.063,103.299 327.200,101.935 327.200 C 100.688 327.200,100.280 327.372,100.126 327.963 C 100.016 328.383,99.583 328.816,99.163 328.926 C 98.719 329.042,98.400 329.475,98.400 329.963 C 98.400 330.589,98.148 330.800,97.400 330.800 C 96.677 330.800,96.400 331.015,96.400 331.577 C 96.400 332.205,96.074 332.378,94.700 332.477 C 93.287 332.579,92.978 332.752,92.872 333.500 C 92.789 334.089,92.469 334.400,91.949 334.400 C 91.511 334.400,91.242 334.544,91.350 334.719 C 91.753 335.371,90.951 335.931,89.399 336.081 C 88.114 336.205,87.775 336.408,87.672 337.118 C 87.602 337.603,87.366 338.000,87.149 338.000 C 86.931 338.000,86.875 338.198,87.025 338.440 C 87.214 338.747,87.038 338.742,86.443 338.423 C 85.973 338.171,85.612 338.108,85.642 338.283 C 85.800 339.231,85.488 339.605,84.500 339.647 L 83.400 339.695 84.567 339.947 C 86.163 340.293,86.377 341.117,84.811 340.887 C 84.050 340.775,83.600 340.884,83.600 341.178 C 83.600 341.436,83.450 341.555,83.267 341.441 C 83.083 341.328,82.933 341.497,82.933 341.818 C 82.933 342.138,83.128 342.403,83.367 342.406 C 83.605 342.409,83.530 342.587,83.200 342.800 C 82.800 343.058,82.767 343.190,83.100 343.194 C 83.422 343.198,83.600 343.816,83.600 344.930 C 83.600 346.261,83.832 346.879,84.604 347.604 L 85.608 348.547 84.604 349.596 C 83.357 350.898,82.998 361.200,84.200 361.200 C 84.914 361.200,85.040 364.116,84.400 365.800 C 84.128 366.515,84.135 367.105,84.422 367.641 C 84.737 368.230,84.687 368.745,84.222 369.676 C 83.274 371.576,83.418 373.689,84.569 374.770 L 85.537 375.680 84.780 377.446 C 83.983 379.305,84.235 381.173,85.290 381.225 C 85.571 381.239,85.350 381.438,84.800 381.667 C 83.664 382.141,84.442 382.714,86.300 382.772 C 87.259 382.802,87.562 381.813,86.700 381.465 C 86.425 381.354,86.830 381.246,87.600 381.226 C 89.822 381.167,90.800 380.779,90.800 379.953 C 90.800 379.327,91.104 379.200,92.600 379.200 C 94.116 379.200,94.400 379.077,94.400 378.423 C 94.400 377.795,94.726 377.622,96.100 377.523 C 97.513 377.421,97.822 377.248,97.928 376.500 C 98.039 375.715,98.652 375.387,99.700 375.553 C 99.865 375.579,100.000 375.240,100.000 374.800 C 100.000 374.189,100.283 373.988,101.200 373.950 C 103.297 373.863,103.398 373.817,103.528 372.900 C 103.612 372.305,103.930 372.000,104.465 372.000 C 104.938 372.000,105.362 371.668,105.484 371.200 C 105.637 370.617,106.033 370.398,106.947 370.394 C 108.199 370.388,109.299 369.937,109.234 369.455 C 109.123 368.622,109.284 368.400,110.000 368.400 C 110.525 368.400,110.800 368.133,110.800 367.623 C 110.800 366.995,111.126 366.822,112.500 366.723 C 113.913 366.621,114.222 366.448,114.328 365.700 C 114.412 365.105,114.730 364.800,115.265 364.800 C 115.738 364.800,116.162 364.468,116.284 364.000 C 116.437 363.417,116.833 363.198,117.747 363.194 C 118.999 363.188,120.099 362.737,120.034 362.255 C 119.923 361.422,120.084 361.200,120.800 361.200 C 121.333 361.200,121.600 360.933,121.600 360.400 C 121.600 359.789,121.883 359.588,122.800 359.550 C 124.895 359.463,124.998 359.417,125.125 358.525 C 125.202 357.979,125.579 357.602,126.125 357.525 C 126.606 357.456,127.000 357.130,127.000 356.800 C 127.000 356.400,127.481 356.160,128.444 356.079 C 129.494 355.991,130.030 355.692,130.411 354.979 C 130.699 354.441,131.265 354.000,131.668 354.000 C 132.190 354.000,132.400 353.701,132.400 352.957 C 132.400 352.237,132.570 351.980,132.949 352.125 C 133.265 352.246,133.719 351.924,134.017 351.368 C 134.496 350.473,135.494 350.155,137.131 350.377 C 137.423 350.417,137.755 350.095,137.868 349.662 C 137.981 349.228,138.441 348.778,138.890 348.661 C 139.444 348.516,139.644 348.211,139.513 347.712 C 139.408 347.307,139.564 346.750,139.861 346.472 C 140.220 346.136,140.400 346.116,140.400 346.413 C 140.400 346.669,140.653 346.604,141.000 346.257 C 141.330 345.927,141.600 345.464,141.600 345.229 C 141.600 344.993,142.005 344.782,142.500 344.760 C 143.359 344.722,143.354 344.707,142.400 344.424 C 141.850 344.261,141.193 344.286,140.939 344.480 C 140.653 344.700,140.399 344.638,140.270 344.317 C 140.134 343.976,140.052 344.029,140.032 344.471 C 140.014 344.840,140.274 345.226,140.608 345.330 C 141.048 345.467,141.024 345.501,140.522 345.456 C 139.407 345.357,138.489 343.390,139.101 342.410 C 139.732 341.400,139.741 339.815,139.122 338.824 C 138.763 338.248,138.756 337.814,139.096 337.068 C 139.475 336.238,139.422 335.963,138.774 335.376 C 137.743 334.444,137.760 332.341,138.806 331.394 L 139.612 330.665 138.806 329.807 C 137.736 328.668,137.733 327.200,138.800 327.200 C 139.481 327.200,139.600 326.933,139.600 325.400 C 139.600 323.867,139.481 323.600,138.800 323.600 C 138.119 323.600,138.000 323.333,138.000 321.800 C 138.000 320.267,138.119 320.000,138.800 320.000 C 139.668 320.000,139.993 317.890,139.200 317.400 C 138.980 317.264,138.800 316.533,138.800 315.776 C 138.800 315.019,138.620 314.400,138.400 314.400 C 138.180 314.400,138.000 313.590,138.000 312.600 C 138.000 311.610,138.160 310.800,138.356 310.800 C 138.901 310.800,139.264 308.276,139.465 303.100 C 139.641 298.563,139.618 298.400,138.824 298.400 C 138.212 298.400,138.000 298.143,138.000 297.400 C 138.000 296.850,138.180 296.400,138.400 296.400 C 138.637 296.400,138.800 294.933,138.800 292.800 C 138.800 290.667,138.963 289.200,139.200 289.200 C 139.447 289.200,139.600 287.133,139.600 283.800 C 139.600 278.667,139.560 278.400,138.800 278.400 C 138.059 278.400,138.000 278.133,138.000 274.800 C 138.000 271.467,138.059 271.200,138.800 271.200 C 140.065 271.200,140.008 264.248,138.734 263.143 L 137.868 262.392 138.734 261.470 C 139.709 260.433,139.825 259.331,139.122 257.789 C 138.752 256.977,138.752 256.569,139.122 255.976 C 139.907 254.719,139.731 253.200,138.800 253.200 C 138.213 253.200,138.000 252.933,138.000 252.200 C 138.000 251.650,138.163 251.200,138.363 251.200 C 138.678 251.200,139.179 247.966,139.184 245.900 C 139.189 243.849,139.223 243.208,139.439 241.100 C 139.658 238.958,139.617 238.800,138.837 238.800 C 138.211 238.800,138.000 238.548,138.000 237.800 C 138.000 237.067,138.213 236.800,138.800 236.800 C 139.467 236.800,139.600 236.533,139.600 235.200 C 139.600 233.809,139.482 233.599,138.700 233.594 C 138.178 233.590,137.987 233.464,138.245 233.294 C 139.584 232.409,140.028 223.108,138.794 221.794 C 138.096 221.050,138.014 220.721,138.366 220.064 C 138.605 219.618,138.800 218.791,138.800 218.226 C 138.800 217.662,138.980 217.200,139.200 217.200 C 140.166 217.200,139.677 208.470,138.700 208.282 L 137.800 208.109 138.700 208.054 C 139.471 208.008,139.600 207.775,139.600 206.428 C 139.600 205.115,139.451 204.827,138.700 204.682 L 137.800 204.509 138.700 204.454 C 139.740 204.392,140.019 201.461,139.122 200.024 C 138.752 199.431,138.752 199.023,139.122 198.211 C 139.853 196.608,139.728 195.600,138.800 195.600 C 138.213 195.600,138.000 195.333,138.000 194.600 C 138.000 193.867,138.213 193.600,138.800 193.600 C 139.982 193.600,139.934 190.607,138.730 189.326 L 137.861 188.400 138.723 187.482 L 139.586 186.564 138.714 185.692 L 137.842 184.820 138.770 183.832 C 139.516 183.038,139.644 182.586,139.425 181.522 C 139.275 180.795,139.174 179.840,139.200 179.400 C 139.542 173.558,139.575 168.477,139.275 167.820 C 137.927 164.873,137.898 164.650,138.768 163.946 C 139.876 163.048,139.898 161.200,138.800 161.200 C 138.267 161.200,138.000 160.933,138.000 160.400 C 138.000 159.867,138.267 159.600,138.800 159.600 C 139.481 159.600,139.600 159.333,139.600 157.800 C 139.600 156.267,139.481 156.000,138.800 156.000 C 137.627 156.000,137.637 152.453,138.813 151.389 C 140.084 150.238,139.649 127.200,138.356 127.200 C 138.160 127.200,138.000 126.390,138.000 125.400 C 138.000 123.007,137.284 123.086,137.094 125.500 L 136.944 127.400 136.872 125.380 C 136.832 124.269,136.986 123.174,137.213 122.947 C 137.498 122.662,137.442 122.533,137.036 122.533 C 136.710 122.533,136.456 122.638,136.470 122.767 M82.357 158.449 C 82.268 159.501,82.393 160.478,82.647 160.715 C 82.974 161.020,83.046 160.630,82.914 159.266 C 82.652 156.548,82.533 156.375,82.357 158.449 M83.293 158.400 C 83.293 159.170,83.375 159.485,83.476 159.100 C 83.576 158.715,83.576 158.085,83.476 157.700 C 83.375 157.315,83.293 157.630,83.293 158.400 M81.714 163.000 C 81.717 164.100,81.795 164.503,81.887 163.895 C 81.979 163.286,81.977 162.386,81.882 161.895 C 81.787 161.403,81.711 161.900,81.714 163.000 M79.941 342.101 C 80.143 342.303,80.733 342.401,81.254 342.319 C 82.055 342.193,81.998 342.137,80.887 341.952 C 80.093 341.821,79.719 341.879,79.941 342.101 " stroke="none" fill="#c5b8e3" fill-rule="evenodd"></path><path id="path4" d="M36.196 284.007 C 36.058 284.230,35.777 284.309,35.572 284.183 C 35.368 284.056,35.200 284.311,35.200 284.749 C 35.200 285.269,34.889 285.589,34.300 285.672 C 33.519 285.783,33.400 286.038,33.400 287.600 C 33.400 289.214,33.307 289.395,32.500 289.352 C 31.806 289.315,31.600 289.522,31.600 290.252 C 31.600 290.984,31.383 291.200,30.647 291.200 C 29.800 291.200,29.692 291.384,29.671 292.861 C 29.650 294.429,29.029 295.388,28.319 294.950 C 28.144 294.842,28.000 295.111,28.000 295.549 C 28.000 296.069,27.689 296.389,27.100 296.472 C 26.183 296.602,26.137 296.703,26.050 298.800 C 26.012 299.717,25.811 300.000,25.200 300.000 C 24.613 300.000,24.400 300.267,24.400 301.000 C 24.400 301.800,24.200 302.000,23.400 302.000 C 22.436 302.000,22.400 302.093,22.400 304.600 C 22.400 306.933,22.318 307.200,21.600 307.200 C 21.013 307.200,20.800 307.467,20.800 308.200 C 20.800 309.000,20.600 309.200,19.800 309.200 C 18.881 309.200,18.800 309.347,18.800 311.000 C 18.800 312.533,18.681 312.800,18.000 312.800 C 17.319 312.800,17.200 313.067,17.200 314.600 C 17.200 316.253,17.119 316.400,16.200 316.400 C 15.281 316.400,15.200 316.547,15.200 318.200 C 15.200 319.733,15.081 320.000,14.400 320.000 C 13.719 320.000,13.600 320.267,13.600 321.800 C 13.600 323.453,13.519 323.600,12.600 323.600 C 11.681 323.600,11.600 323.747,11.600 325.400 C 11.600 326.933,11.481 327.200,10.800 327.200 C 10.119 327.200,10.000 327.467,10.000 329.000 C 10.000 330.653,9.919 330.800,9.000 330.800 C 8.081 330.800,8.000 330.947,8.000 332.600 C 8.000 334.133,7.881 334.400,7.200 334.400 C 6.483 334.400,6.400 334.667,6.400 336.972 C 6.400 339.335,6.327 339.555,5.500 339.672 C 4.682 339.788,4.589 340.047,4.482 342.500 C 4.378 344.872,4.268 345.200,3.582 345.200 C 2.887 345.200,2.800 345.487,2.800 347.772 C 2.800 350.135,2.727 350.355,1.900 350.472 C 1.025 350.596,0.997 350.747,0.888 355.900 C 0.823 358.984,0.614 361.200,0.388 361.200 C 0.160 361.200,0.000 363.092,0.000 365.800 C 0.000 368.508,0.160 370.400,0.388 370.400 C 0.614 370.400,0.823 372.616,0.888 375.700 C 0.997 380.853,1.025 381.004,1.900 381.128 C 2.679 381.238,2.800 381.495,2.800 383.028 C 2.800 384.533,2.920 384.800,3.600 384.800 C 4.133 384.800,4.400 385.067,4.400 385.600 C 4.400 386.187,4.667 386.400,5.400 386.400 C 6.319 386.400,6.400 386.547,6.400 388.200 C 6.400 389.712,6.524 390.000,7.172 390.000 C 7.668 390.000,7.990 390.322,8.072 390.900 C 8.154 391.478,8.522 391.846,9.100 391.928 C 9.678 392.010,10.000 392.332,10.000 392.828 C 10.000 393.476,10.288 393.600,11.800 393.600 C 13.453 393.600,13.600 393.681,13.600 394.600 C 13.600 395.333,13.813 395.600,14.400 395.600 C 14.933 395.600,15.200 395.867,15.200 396.400 C 15.200 397.124,15.467 397.200,18.000 397.200 C 20.720 397.200,20.800 397.229,20.800 398.200 C 20.800 399.193,20.827 399.200,24.400 399.200 C 26.533 399.200,28.000 399.363,28.000 399.600 C 28.000 399.849,30.333 400.000,34.200 400.000 C 38.067 400.000,40.400 399.849,40.400 399.600 C 40.400 399.377,41.593 399.182,43.100 399.160 C 47.492 399.095,48.375 398.491,44.200 398.408 C 42.220 398.369,40.825 398.246,41.100 398.135 C 41.833 397.839,41.745 395.600,41.000 395.600 C 40.501 395.600,40.400 394.822,40.400 391.000 C 40.400 387.178,40.501 386.400,41.000 386.400 C 41.412 386.400,41.600 385.987,41.600 385.080 C 41.600 384.354,41.782 383.578,42.005 383.355 C 42.279 383.081,42.084 382.643,41.405 382.005 C 39.855 380.549,39.851 374.000,41.400 374.000 C 42.320 374.000,42.400 373.855,42.400 372.182 C 42.400 370.776,42.173 370.137,41.400 369.364 C 40.850 368.814,40.400 368.012,40.400 367.582 C 40.400 367.015,40.674 366.800,41.400 366.800 C 42.330 366.800,42.400 366.664,42.400 364.843 C 42.400 362.718,42.135 362.454,39.867 362.331 C 39.170 362.293,39.770 362.144,41.200 362.000 L 43.800 361.738 41.332 361.669 L 38.863 361.600 38.732 358.564 C 38.630 356.224,38.737 355.423,39.200 355.064 C 39.722 354.660,39.729 354.691,39.251 355.300 C 38.765 355.920,38.801 356.000,39.566 356.000 C 40.219 356.000,40.411 355.779,40.353 355.100 C 40.186 353.157,40.410 352.484,41.300 352.260 C 42.095 352.059,42.215 351.739,42.329 349.523 C 42.399 348.143,42.669 346.756,42.929 346.441 C 43.330 345.954,43.267 345.940,42.500 346.349 C 41.778 346.733,41.588 347.202,41.540 348.714 L 41.480 350.600 41.214 348.800 L 40.948 347.000 40.744 348.800 C 40.566 350.367,40.531 350.250,40.470 347.897 C 40.408 345.502,40.508 345.101,41.353 344.366 C 42.195 343.634,42.255 343.400,41.862 342.360 C 41.532 341.485,41.537 340.992,41.884 340.437 C 42.271 339.818,42.185 339.538,41.375 338.776 C 40.013 337.497,40.008 334.828,41.365 333.472 L 42.329 332.507 41.493 331.670 C 40.773 330.951,40.722 330.689,41.128 329.798 C 41.777 328.373,41.719 327.200,41.000 327.200 C 40.511 327.200,40.400 326.533,40.400 323.600 C 40.400 320.027,40.407 320.000,41.400 320.000 C 42.753 320.000,42.753 318.471,41.400 317.200 C 40.480 316.336,40.400 315.979,40.400 312.730 C 40.400 309.231,40.409 309.200,41.400 309.200 C 42.319 309.200,42.400 309.053,42.400 307.400 C 42.400 306.410,42.220 305.600,42.000 305.600 C 41.780 305.600,41.600 304.790,41.600 303.800 C 41.600 302.467,41.444 302.000,41.000 302.000 C 40.148 302.000,40.160 297.138,41.016 295.832 C 41.354 295.316,41.603 294.737,41.568 294.547 C 41.404 293.641,41.640 292.778,41.993 292.996 C 42.233 293.144,42.369 292.457,42.341 291.237 C 42.317 290.136,42.185 289.248,42.048 289.265 C 40.947 289.398,40.400 289.097,40.400 288.357 C 40.400 287.786,40.214 287.586,39.820 287.737 C 39.166 287.988,38.765 287.060,38.712 285.170 C 38.683 284.178,38.533 283.976,37.938 284.132 C 37.532 284.238,37.200 284.162,37.200 283.963 C 37.200 283.472,36.508 283.502,36.196 284.007 M43.047 293.421 C 42.916 293.762,42.972 293.941,43.170 293.818 C 43.369 293.695,43.619 293.821,43.725 294.098 C 43.831 294.374,43.899 294.195,43.874 293.700 C 43.823 292.661,43.394 292.517,43.047 293.421 M44.000 296.757 C 44.000 297.114,44.941 297.600,45.633 297.600 C 45.835 297.600,45.986 297.285,45.968 296.900 C 45.950 296.482,45.856 296.401,45.735 296.700 C 45.624 296.975,45.358 297.200,45.143 297.200 C 44.928 297.200,44.864 297.020,45.000 296.800 C 45.136 296.580,44.967 296.400,44.624 296.400 C 44.281 296.400,44.000 296.561,44.000 296.757 M45.600 342.224 C 45.600 342.567,45.420 342.736,45.200 342.600 C 44.980 342.464,44.800 342.543,44.800 342.776 C 44.800 343.009,45.070 343.200,45.400 343.200 C 45.733 343.200,46.000 342.844,46.000 342.400 C 46.000 341.960,45.910 341.600,45.800 341.600 C 45.690 341.600,45.600 341.881,45.600 342.224 M40.800 346.067 C 40.800 346.543,40.925 346.808,41.078 346.655 C 41.511 346.223,41.571 345.200,41.165 345.200 C 40.964 345.200,40.800 345.590,40.800 346.067 M41.383 351.628 C 41.086 352.108,40.000 352.113,40.000 351.633 C 40.000 351.200,40.868 350.833,41.307 351.082 C 41.475 351.177,41.509 351.423,41.383 351.628 " stroke="none" fill="#9998d4" fill-rule="evenodd"></path><path id="path5" d="" stroke="none" fill="#c6acd4" fill-rule="evenodd"></path><path id="path6" d="M323.600 13.645 C 323.600 13.947,323.017 14.003,321.800 13.821 C 320.190 13.580,320.000 13.633,320.000 14.330 C 320.000 14.947,319.625 15.165,318.200 15.379 C 316.778 15.592,316.400 15.812,316.400 16.425 C 316.400 17.077,316.114 17.200,314.600 17.200 C 313.067 17.200,312.800 17.319,312.800 18.000 C 312.800 18.561,312.532 18.802,311.900 18.805 C 310.208 18.816,309.200 19.279,309.200 20.047 C 309.200 20.673,308.896 20.800,307.400 20.800 C 305.867 20.800,305.600 20.919,305.600 21.600 C 305.600 22.217,305.333 22.400,304.433 22.400 C 302.745 22.400,302.000 22.781,302.000 23.643 C 302.000 24.184,301.714 24.400,301.000 24.400 C 300.197 24.400,300.000 24.599,300.000 25.413 C 300.000 26.309,299.849 26.415,298.685 26.336 C 297.170 26.234,296.400 26.601,296.400 27.424 C 296.400 27.748,296.021 28.000,295.533 28.000 C 295.057 28.000,294.780 28.114,294.919 28.253 C 295.610 28.943,294.311 30.026,292.924 29.915 C 291.776 29.823,291.469 29.951,291.373 30.560 C 291.227 31.485,290.473 32.003,289.702 31.707 C 289.286 31.548,289.167 31.748,289.265 32.444 C 289.384 33.284,289.242 33.400,288.100 33.396 C 287.385 33.394,286.800 33.540,286.800 33.720 C 286.800 33.900,286.639 33.948,286.442 33.826 C 286.051 33.585,285.450 34.783,285.791 35.124 C 285.906 35.239,286.000 35.191,286.000 35.018 C 286.000 34.844,286.270 34.926,286.600 35.200 C 286.930 35.474,287.197 35.901,287.194 36.149 C 287.191 36.397,287.013 36.330,286.800 36.000 C 286.469 35.487,286.411 35.502,286.406 36.100 C 286.403 36.491,286.709 36.814,287.100 36.832 C 287.522 36.851,287.601 36.944,287.298 37.066 C 287.021 37.177,286.889 37.421,287.004 37.607 C 287.119 37.793,287.002 38.075,286.745 38.234 C 286.452 38.415,286.384 38.350,286.562 38.062 C 286.947 37.439,286.205 37.471,285.684 38.100 C 285.020 38.900,286.489 40.400,287.936 40.400 C 288.885 40.400,289.172 40.594,289.272 41.300 C 289.379 42.055,289.707 42.232,291.310 42.400 C 292.360 42.510,293.191 42.780,293.155 43.000 C 293.120 43.220,293.468 43.575,293.929 43.788 C 294.390 44.001,294.820 44.541,294.884 44.988 C 295.002 45.817,295.113 45.863,297.200 45.950 C 298.117 45.988,298.400 46.189,298.400 46.800 C 298.400 47.240,298.535 47.579,298.700 47.553 C 300.682 47.240,302.000 47.658,302.000 48.600 C 302.000 49.313,302.216 49.600,302.753 49.600 C 303.170 49.600,303.600 49.957,303.716 50.400 C 303.841 50.879,304.262 51.200,304.763 51.200 C 305.389 51.200,305.600 51.452,305.600 52.200 C 305.600 53.119,305.747 53.200,307.400 53.200 C 308.933 53.200,309.200 53.319,309.200 54.000 C 309.200 54.518,309.467 54.800,309.957 54.800 C 310.430 54.800,310.807 55.174,310.964 55.800 C 311.126 56.446,311.496 56.800,312.008 56.800 C 312.538 56.800,312.800 57.069,312.800 57.614 C 312.800 58.388,313.006 58.422,317.100 58.314 C 320.365 58.227,321.374 58.075,321.294 57.681 C 321.235 57.396,321.711 56.980,322.350 56.757 C 323.226 56.452,323.463 56.161,323.310 55.576 C 323.114 54.827,324.293 54.509,326.300 54.770 C 327.422 54.916,326.852 52.393,325.603 51.681 C 324.852 51.255,324.404 50.676,324.403 50.133 C 324.401 49.656,324.291 48.981,324.157 48.633 C 323.960 48.119,324.224 48.000,325.557 48.000 C 327.043 48.000,327.200 47.904,327.200 47.000 C 327.200 46.200,327.000 46.000,326.200 46.000 C 325.207 46.000,325.200 45.973,325.200 42.400 C 325.200 40.267,325.037 38.800,324.800 38.800 C 324.580 38.800,324.400 37.990,324.400 37.000 C 324.400 35.772,324.568 35.200,324.930 35.200 C 325.745 35.200,327.200 33.453,327.200 32.474 C 327.200 31.705,326.984 31.600,325.400 31.600 C 323.610 31.600,323.600 31.593,323.600 30.200 C 323.600 28.899,323.689 28.800,324.847 28.800 C 326.006 28.800,326.074 28.723,325.822 27.700 C 325.032 24.489,325.041 24.400,326.155 24.400 C 327.691 24.400,327.751 19.627,326.235 18.022 C 325.704 17.460,325.209 16.460,325.136 15.800 C 325.063 15.140,324.822 14.468,324.601 14.306 C 324.364 14.133,324.446 14.007,324.800 14.000 C 325.333 13.989,325.333 13.945,324.800 13.600 C 324.005 13.086,323.600 13.101,323.600 13.645 M287.063 73.117 C 286.973 73.273,287.045 73.760,287.222 74.200 C 287.399 74.640,287.556 74.765,287.572 74.477 C 287.594 74.074,287.802 74.096,288.485 74.575 C 289.607 75.360,289.539 78.164,288.367 79.426 C 287.158 80.727,287.222 87.200,288.444 87.200 C 289.200 87.200,289.260 87.356,289.020 88.700 C 288.435 91.978,288.326 94.400,288.763 94.400 C 289.003 94.400,289.200 94.850,289.200 95.400 C 289.200 95.950,289.040 96.400,288.844 96.400 C 288.460 96.400,288.078 98.160,287.739 101.500 C 287.543 103.432,287.593 103.600,288.363 103.600 C 288.989 103.600,289.200 103.852,289.200 104.600 C 289.200 105.333,288.987 105.600,288.400 105.600 C 287.471 105.600,287.418 106.109,288.089 108.616 C 288.490 110.115,288.480 110.503,288.037 110.777 C 287.659 111.011,287.579 111.515,287.771 112.456 C 287.922 113.195,288.001 114.250,287.947 114.800 C 287.856 115.728,287.891 136.432,287.991 140.700 C 288.053 143.370,288.057 144.507,288.004 145.200 C 287.491 151.977,287.513 152.400,288.370 152.400 C 289.125 152.400,289.200 152.635,289.200 155.000 C 289.200 156.430,289.042 157.600,288.848 157.600 C 288.538 157.600,287.965 161.406,287.991 163.300 C 287.996 163.685,287.989 164.315,287.976 164.700 C 287.582 175.962,287.582 177.600,287.971 177.600 C 288.207 177.600,288.400 178.062,288.400 178.626 C 288.400 179.191,288.595 180.018,288.834 180.464 C 289.184 181.118,289.107 181.447,288.434 182.164 C 287.509 183.149,287.326 184.642,288.100 184.900 C 288.500 185.034,288.500 185.442,288.100 186.939 C 287.237 190.171,287.425 195.600,288.400 195.600 C 288.987 195.600,289.200 195.867,289.200 196.600 C 289.200 197.150,289.040 197.600,288.845 197.600 C 288.305 197.600,287.929 199.791,287.728 204.100 L 287.547 208.000 288.597 208.000 C 289.175 208.000,289.546 208.163,289.423 208.362 C 289.300 208.562,288.839 208.631,288.400 208.516 C 287.554 208.295,287.292 208.963,288.043 209.426 C 288.361 209.623,288.351 209.783,288.009 209.994 C 287.661 210.210,287.693 210.350,288.127 210.517 C 288.764 210.761,288.805 210.182,288.220 209.200 C 288.001 208.833,288.200 208.896,288.731 209.362 C 289.215 209.786,289.600 209.919,289.600 209.662 C 289.600 209.408,289.915 209.186,290.300 209.168 C 290.712 209.150,290.796 209.054,290.504 208.936 C 289.767 208.639,290.993 207.529,291.891 207.680 C 292.394 207.765,292.562 207.581,292.470 207.046 C 292.235 205.683,292.776 204.400,293.585 204.400 C 294.124 204.400,294.311 204.174,294.208 203.644 C 294.099 203.078,294.357 202.829,295.231 202.654 C 296.061 202.488,296.400 202.185,296.400 201.610 C 296.400 201.161,296.664 200.800,296.992 200.800 C 297.318 200.800,297.697 200.351,297.835 199.803 C 297.973 199.254,298.245 198.904,298.440 199.024 C 298.834 199.268,300.257 198.586,300.100 198.228 C 299.817 197.582,300.085 197.200,300.824 197.200 C 301.277 197.200,301.538 197.023,301.404 196.806 C 301.270 196.590,301.754 196.051,302.480 195.610 C 303.206 195.168,303.755 194.715,303.700 194.604 C 303.439 194.072,303.654 193.600,304.157 193.600 C 304.464 193.600,304.819 193.327,304.947 192.994 C 305.075 192.661,305.634 192.215,306.190 192.004 C 307.038 191.681,307.200 191.363,307.200 190.018 C 307.200 188.628,307.337 188.381,308.233 188.156 C 308.994 187.965,309.215 187.699,309.071 187.148 C 308.919 186.570,309.094 186.400,309.837 186.400 C 310.530 186.400,310.800 186.178,310.800 185.608 C 310.800 185.096,311.154 184.726,311.800 184.564 C 312.426 184.407,312.800 184.030,312.800 183.557 C 312.800 183.067,313.082 182.800,313.600 182.800 C 314.131 182.800,314.400 182.533,314.400 182.008 C 314.400 181.496,314.754 181.126,315.398 180.965 C 316.307 180.736,316.374 180.577,316.147 179.157 C 315.906 177.654,316.110 177.368,317.293 177.550 C 317.454 177.575,317.699 177.146,317.836 176.598 C 317.974 176.049,318.342 175.600,318.653 175.600 C 318.965 175.600,319.398 175.132,319.615 174.559 C 319.861 173.914,320.223 173.600,320.569 173.733 C 320.922 173.868,321.216 173.590,321.371 172.973 C 321.505 172.438,321.886 172.000,322.218 172.000 C 322.549 172.000,322.994 171.542,323.207 170.982 C 323.453 170.334,323.850 170.007,324.297 170.082 C 324.892 170.182,324.980 169.938,324.873 168.500 C 324.798 167.503,324.922 166.779,325.173 166.750 C 325.408 166.722,325.780 166.655,326.000 166.600 C 326.220 166.545,326.578 166.477,326.796 166.450 C 327.214 166.397,325.045 164.177,324.007 163.595 C 323.495 163.308,323.564 163.079,324.451 162.127 C 325.754 160.730,326.400 159.503,326.400 158.426 C 326.400 157.972,326.580 157.600,326.800 157.600 C 327.020 157.600,327.200 157.240,327.200 156.800 C 327.200 156.152,326.933 156.000,325.800 156.000 C 324.407 156.000,324.400 155.990,324.400 154.200 C 324.400 153.210,324.580 152.400,324.800 152.400 C 325.628 152.400,325.276 146.593,324.400 145.800 C 323.575 145.054,323.290 143.200,324.000 143.200 C 324.220 143.200,324.400 142.390,324.400 141.400 C 324.400 140.410,324.580 139.600,324.800 139.600 C 325.020 139.600,325.200 138.790,325.200 137.800 C 325.200 136.147,325.281 136.000,326.200 136.000 C 327.119 136.000,327.200 135.853,327.200 134.200 C 327.200 132.558,327.114 132.400,326.224 132.400 C 325.142 132.400,324.839 132.056,324.109 130.000 C 323.436 128.105,323.446 128.071,324.697 127.927 C 326.315 127.740,326.411 126.462,324.830 126.146 C 323.314 125.843,322.935 123.600,324.400 123.600 C 325.167 123.600,325.200 123.333,325.200 117.200 C 325.200 111.206,325.152 110.800,324.449 110.800 C 324.036 110.800,323.529 110.575,323.322 110.300 C 322.829 109.646,322.698 107.490,323.168 107.780 C 323.367 107.903,323.469 107.688,323.395 107.302 C 323.322 106.916,323.247 106.356,323.231 106.057 C 323.212 105.735,322.947 105.611,322.578 105.753 C 322.142 105.921,321.832 105.638,321.543 104.808 C 321.316 104.156,320.941 103.663,320.710 103.712 C 320.227 103.813,319.514 101.643,319.788 100.905 C 319.889 100.632,319.843 100.446,319.686 100.490 C 319.016 100.678,317.643 99.554,317.858 98.994 C 318.024 98.560,317.798 98.400,317.016 98.400 C 316.150 98.400,315.992 98.256,316.185 97.646 C 316.366 97.076,316.178 96.831,315.412 96.639 C 314.771 96.478,314.400 96.105,314.400 95.620 C 314.400 95.132,314.075 94.809,313.500 94.728 C 312.906 94.643,312.639 94.366,312.715 93.911 C 312.791 93.458,312.483 93.136,311.815 92.968 C 311.176 92.808,310.800 92.433,310.800 91.957 C 310.800 91.424,310.515 91.200,309.837 91.200 C 309.079 91.200,308.918 91.034,309.079 90.418 C 309.234 89.827,309.029 89.572,308.242 89.375 C 307.579 89.208,307.200 88.838,307.200 88.357 C 307.200 87.867,306.918 87.600,306.400 87.600 C 305.869 87.600,305.600 87.333,305.600 86.808 C 305.600 86.296,305.246 85.926,304.600 85.764 C 303.991 85.611,303.600 85.228,303.600 84.784 C 303.600 84.333,303.257 84.007,302.700 83.928 C 302.110 83.844,301.800 83.525,301.800 83.001 C 301.800 82.562,301.575 82.179,301.300 82.151 C 301.025 82.123,300.620 82.078,300.400 82.050 C 300.180 82.023,300.000 81.640,300.000 81.200 C 300.000 80.519,299.733 80.400,298.200 80.400 C 296.672 80.400,296.400 80.280,296.400 79.608 C 296.400 79.096,296.046 78.726,295.400 78.564 C 294.774 78.407,294.400 78.030,294.400 77.557 C 294.400 77.140,294.265 76.821,294.100 76.847 C 293.216 76.987,292.800 76.716,292.800 76.000 C 292.800 75.560,292.620 75.177,292.400 75.150 C 292.180 75.123,291.820 75.055,291.600 75.000 C 291.380 74.945,290.750 74.877,290.200 74.850 C 289.536 74.817,289.198 74.565,289.194 74.100 C 289.189 73.502,289.131 73.487,288.800 74.000 C 288.463 74.521,288.411 74.513,288.406 73.943 C 288.400 73.263,287.350 72.618,287.063 73.117 M328.893 100.800 C 328.893 101.570,328.975 101.885,329.076 101.500 C 329.176 101.115,329.176 100.485,329.076 100.100 C 328.975 99.715,328.893 100.030,328.893 100.800 M321.600 214.249 C 321.600 214.804,321.701 214.821,322.300 214.362 C 322.685 214.067,323.075 213.775,323.167 213.713 C 323.258 213.651,322.943 213.600,322.467 213.600 C 321.934 213.600,321.600 213.850,321.600 214.249 M318.000 217.849 C 318.000 218.404,318.101 218.421,318.700 217.962 C 319.085 217.667,319.475 217.375,319.567 217.313 C 319.658 217.251,319.343 217.200,318.867 217.200 C 318.334 217.200,318.000 217.450,318.000 217.849 M317.289 219.084 C 316.788 219.180,316.405 219.470,316.437 219.729 C 316.688 221.765,316.371 222.886,315.600 222.684 C 315.160 222.569,314.778 222.638,314.750 222.837 C 314.723 223.037,314.678 223.425,314.650 223.700 C 314.623 223.975,314.195 224.258,313.700 224.328 C 313.117 224.411,312.800 224.731,312.800 225.238 C 312.800 225.704,312.396 226.173,311.800 226.400 C 311.250 226.609,310.800 227.055,310.800 227.390 C 310.800 227.733,310.450 228.000,310.000 228.000 C 309.463 228.000,309.200 228.267,309.200 228.810 C 309.200 229.306,308.812 229.767,308.200 230.000 C 307.650 230.209,307.200 230.655,307.200 230.990 C 307.200 231.333,306.850 231.600,306.400 231.600 C 305.890 231.600,305.600 231.867,305.600 232.336 C 305.600 232.740,305.150 233.277,304.600 233.527 C 304.050 233.778,303.600 234.257,303.600 234.591 C 303.600 234.933,303.249 235.200,302.800 235.200 C 302.360 235.200,302.021 235.335,302.047 235.500 C 302.175 236.308,301.916 236.710,301.000 237.127 C 300.450 237.378,300.000 237.857,300.000 238.191 C 300.000 238.549,299.642 238.800,299.133 238.800 C 298.657 238.800,298.380 238.914,298.519 239.053 C 298.872 239.406,298.035 240.869,297.625 240.616 C 297.080 240.279,296.475 241.303,296.333 242.802 C 296.246 243.719,295.994 244.200,295.600 244.200 C 295.270 244.200,294.942 244.605,294.872 245.100 C 294.750 245.962,294.394 246.172,293.300 246.030 C 293.014 245.993,292.800 246.400,292.800 246.982 C 292.800 247.733,292.590 248.000,292.000 248.000 C 291.467 248.000,291.200 248.267,291.200 248.800 C 291.200 249.574,290.808 249.780,289.645 249.617 C 289.269 249.565,289.161 249.807,289.309 250.375 C 289.521 251.183,288.447 252.223,287.853 251.786 C 287.714 251.684,287.684 251.714,287.786 251.853 C 288.234 252.461,287.182 253.520,286.346 253.302 C 285.572 253.099,285.511 253.191,285.761 254.189 C 285.995 255.120,285.933 255.260,285.376 255.046 C 284.942 254.880,284.769 254.966,284.877 255.295 C 285.129 256.061,283.365 257.605,282.839 257.079 C 282.196 256.436,281.965 256.926,282.247 258.336 C 282.390 259.050,282.750 259.600,283.074 259.600 C 283.389 259.600,283.536 259.780,283.400 260.000 C 283.264 260.220,283.343 260.400,283.576 260.400 C 283.812 260.400,284.000 261.200,284.000 262.200 C 284.000 263.853,283.919 264.000,283.000 264.000 C 282.081 264.000,282.000 264.147,282.000 265.800 C 282.000 266.790,282.180 267.600,282.400 267.600 C 282.620 267.600,282.800 268.062,282.800 268.626 C 282.800 269.191,282.995 270.018,283.234 270.464 C 283.584 271.118,283.508 271.447,282.841 272.156 L 282.014 273.036 282.886 273.908 L 283.758 274.780 282.877 275.718 L 281.996 276.656 282.998 277.598 C 283.970 278.511,284.000 278.698,284.000 283.870 L 284.000 289.200 283.000 289.200 C 282.007 289.200,282.000 289.227,282.000 292.800 C 282.000 296.373,282.007 296.400,283.000 296.400 C 283.904 296.400,284.000 296.557,284.000 298.042 C 284.000 299.210,283.711 300.028,283.000 300.873 C 281.937 302.136,281.495 307.241,282.400 307.800 C 282.620 307.936,282.800 308.667,282.800 309.424 C 282.800 310.181,282.620 310.800,282.400 310.800 C 281.441 310.800,281.948 316.212,283.000 317.200 C 284.161 318.290,284.349 320.740,283.400 322.400 C 282.638 323.733,282.638 325.200,283.400 325.200 C 283.773 325.200,284.000 325.578,284.000 326.200 C 284.000 326.867,284.222 327.200,284.667 327.200 C 285.033 327.200,285.222 327.311,285.086 327.448 C 284.950 327.584,285.087 327.944,285.390 328.248 C 286.030 328.887,286.563 328.988,286.200 328.400 C 286.064 328.180,286.128 328.000,286.343 328.000 C 286.558 328.000,286.824 328.225,286.935 328.500 C 287.046 328.775,287.151 328.591,287.168 328.090 C 287.189 327.504,287.556 327.045,288.200 326.800 C 288.750 326.591,289.200 326.145,289.200 325.810 C 289.200 325.353,289.656 325.200,291.018 325.200 C 292.523 325.200,292.815 325.081,292.718 324.504 C 292.648 324.093,292.969 323.644,293.500 323.409 C 293.995 323.190,294.400 322.693,294.400 322.305 C 294.400 321.917,294.580 321.600,294.800 321.600 C 295.689 321.600,295.811 321.522,296.087 320.776 C 296.255 320.321,296.752 319.998,297.287 319.995 C 298.991 319.984,300.000 319.523,300.000 318.753 C 300.000 318.267,300.283 318.000,300.800 318.000 C 301.249 318.000,301.600 317.733,301.600 317.391 C 301.600 317.057,302.050 316.578,302.600 316.327 C 303.150 316.077,303.600 315.540,303.600 315.136 C 303.600 314.675,303.889 314.400,304.373 314.400 C 304.798 314.400,305.257 314.049,305.394 313.620 C 305.530 313.192,305.992 312.730,306.420 312.594 C 306.849 312.457,307.200 311.998,307.200 311.573 C 307.200 311.076,307.476 310.800,307.973 310.800 C 308.398 310.800,308.857 310.449,308.994 310.020 C 309.130 309.592,309.592 309.130,310.020 308.994 C 310.500 308.841,310.800 308.387,310.800 307.810 C 310.800 307.072,310.968 306.919,311.600 307.084 C 312.321 307.273,312.589 306.917,312.461 305.940 C 312.442 305.797,312.878 305.567,313.430 305.428 C 313.981 305.290,314.335 305.018,314.215 304.824 C 313.793 304.141,314.495 303.132,315.255 303.330 C 315.912 303.502,316.171 303.184,316.061 302.340 C 316.042 302.197,316.487 301.964,317.050 301.823 C 317.724 301.654,317.997 301.370,317.851 300.989 C 317.620 300.387,318.903 299.436,319.347 299.881 C 319.486 300.020,319.600 299.306,319.600 298.294 C 319.600 296.692,319.716 296.439,320.500 296.328 C 321.432 296.195,322.083 294.400,321.199 294.400 C 320.921 294.400,320.977 294.166,321.343 293.800 C 322.139 293.004,322.432 293.041,322.124 293.900 C 321.986 294.285,322.005 294.481,322.166 294.337 C 322.328 294.192,322.510 293.742,322.572 293.337 C 322.647 292.835,322.957 292.640,323.542 292.725 C 324.014 292.794,324.400 292.665,324.400 292.438 C 324.400 292.211,324.130 292.129,323.800 292.255 C 323.470 292.382,323.200 292.306,323.200 292.086 C 323.200 291.866,323.470 291.582,323.800 291.455 C 324.468 291.199,324.648 288.800,324.000 288.800 C 323.780 288.800,323.600 289.334,323.600 289.986 C 323.600 290.768,323.324 291.320,322.789 291.606 C 322.343 291.845,322.071 292.191,322.184 292.374 C 322.298 292.558,321.929 292.797,321.364 292.905 C 320.032 293.159,319.742 292.395,320.406 290.383 C 320.808 289.164,320.815 288.700,320.436 288.244 C 320.040 287.767,320.120 287.630,320.877 287.485 L 321.800 287.309 320.900 287.254 C 319.748 287.185,319.697 285.892,320.800 284.708 C 321.663 283.781,321.996 279.200,321.200 279.200 C 320.980 279.200,320.800 279.020,320.800 278.800 C 320.800 278.580,321.041 278.400,321.336 278.400 C 321.630 278.400,322.067 277.972,322.305 277.449 C 322.827 276.303,322.300 275.600,320.920 275.600 C 320.072 275.600,320.000 275.429,320.000 273.400 C 320.000 271.467,320.097 271.200,320.800 271.200 C 321.524 271.200,321.600 270.933,321.600 268.400 C 321.600 266.800,321.429 265.600,321.200 265.600 C 320.980 265.600,320.800 264.880,320.800 264.000 C 320.800 263.120,320.980 262.400,321.200 262.400 C 321.420 262.400,321.600 261.500,321.600 260.400 C 321.600 258.667,321.493 258.400,320.800 258.400 C 320.133 258.400,320.000 258.133,320.000 256.800 L 320.000 255.200 321.800 255.200 L 323.600 255.200 323.600 253.200 L 323.600 251.200 322.244 251.200 C 321.026 251.200,320.865 251.067,320.663 249.900 C 320.539 249.185,320.319 248.015,320.174 247.300 C 319.942 246.160,320.013 246.000,320.755 246.000 C 321.535 246.000,321.600 245.783,321.600 243.200 C 321.600 241.660,321.440 240.400,321.244 240.400 C 321.048 240.400,320.786 239.815,320.663 239.100 C 320.539 238.385,320.319 237.215,320.174 236.500 C 319.942 235.360,320.013 235.200,320.755 235.200 C 321.564 235.200,321.600 235.012,321.600 230.827 L 321.600 226.453 322.700 226.287 L 323.800 226.120 322.700 226.060 C 321.887 226.016,321.600 225.792,321.600 225.200 C 321.600 224.760,321.420 224.400,321.200 224.400 C 320.691 224.400,320.680 222.572,321.183 221.631 C 321.573 220.904,319.976 218.957,319.434 219.499 C 319.305 219.628,319.200 219.523,319.200 219.267 C 319.200 218.794,318.932 218.769,317.289 219.084 M281.332 258.967 C 281.452 259.279,281.291 259.633,280.975 259.754 C 280.659 259.876,280.400 260.167,280.400 260.402 C 280.400 260.702,280.640 260.700,281.208 260.396 C 281.653 260.158,282.211 260.083,282.450 260.231 C 282.688 260.378,282.574 260.026,282.195 259.449 C 281.452 258.315,280.981 258.052,281.332 258.967 M282.800 329.720 C 282.800 330.094,282.575 330.406,282.300 330.413 C 281.243 330.440,280.207 331.568,280.750 332.101 C 281.156 332.500,281.231 332.486,281.129 332.033 C 281.018 331.546,281.937 330.828,283.400 330.256 C 283.644 330.161,283.605 329.894,283.300 329.570 C 282.888 329.134,282.800 329.160,282.800 329.720 " stroke="none" fill="#e8b6c0" fill-rule="evenodd"></path><path id="path7" d="M288.200 33.200 L 287.000 33.505 288.076 33.553 C 288.668 33.579,289.264 33.420,289.400 33.200 C 289.536 32.980,289.592 32.821,289.524 32.847 C 289.456 32.873,288.860 33.032,288.200 33.200 M285.493 35.252 C 285.108 35.467,284.636 35.546,284.442 35.426 C 283.905 35.094,283.589 36.832,284.035 37.665 C 284.461 38.462,285.404 38.641,285.800 38.000 C 285.936 37.780,286.227 37.600,286.447 37.600 C 286.667 37.600,286.719 37.808,286.562 38.062 C 286.384 38.350,286.452 38.415,286.745 38.234 C 287.002 38.075,287.119 37.793,287.004 37.607 C 286.889 37.421,287.021 37.177,287.298 37.066 C 287.601 36.944,287.522 36.851,287.100 36.832 C 286.709 36.814,286.403 36.491,286.406 36.100 C 286.411 35.502,286.469 35.487,286.800 36.000 C 287.013 36.330,287.191 36.397,287.194 36.149 C 287.205 35.336,286.246 34.831,285.493 35.252 M270.800 62.625 C 269.477 63.126,269.459 63.156,270.476 63.177 C 271.068 63.190,271.674 63.396,271.822 63.635 C 272.011 63.941,272.225 63.926,272.545 63.585 C 272.886 63.221,272.874 63.054,272.498 62.916 C 272.221 62.815,272.097 62.567,272.221 62.366 C 272.345 62.165,272.392 62.021,272.324 62.048 C 272.256 62.074,271.570 62.334,270.800 62.625 M270.100 63.865 C 269.503 64.106,269.409 67.600,270.000 67.600 C 270.220 67.600,270.400 68.410,270.400 69.400 C 270.400 70.390,270.220 71.200,270.000 71.200 C 269.763 71.200,269.600 72.667,269.600 74.800 C 269.600 78.133,269.659 78.400,270.400 78.400 C 271.081 78.400,271.200 78.667,271.200 80.200 C 271.200 81.733,271.081 82.000,270.400 82.000 C 269.719 82.000,269.600 82.267,269.600 83.800 C 269.600 85.333,269.719 85.600,270.400 85.600 C 270.924 85.600,271.200 85.867,271.200 86.373 C 271.200 86.910,271.537 87.198,272.300 87.313 C 272.979 87.416,272.674 87.503,271.500 87.540 L 269.600 87.600 269.600 89.172 C 269.600 90.485,269.749 90.773,270.500 90.918 L 271.400 91.091 270.500 91.146 C 269.224 91.223,269.127 94.400,270.400 94.400 C 270.987 94.400,271.200 94.667,271.200 95.400 C 271.200 96.133,270.987 96.400,270.400 96.400 C 269.633 96.400,269.600 96.667,269.600 102.800 C 269.600 108.222,269.508 109.200,269.000 109.200 C 268.556 109.200,268.400 109.667,268.400 111.000 C 268.400 112.333,268.556 112.800,269.000 112.800 C 269.513 112.800,269.600 113.956,269.600 120.800 C 269.600 128.533,269.627 128.800,270.400 128.800 C 270.987 128.800,271.200 129.067,271.200 129.800 C 271.200 130.548,270.989 130.800,270.363 130.800 C 269.584 130.800,269.542 130.960,269.754 133.100 C 269.880 134.365,270.004 135.670,270.030 136.000 C 270.056 136.330,269.947 137.275,269.787 138.100 C 269.523 139.455,269.578 139.600,270.348 139.600 C 270.990 139.600,271.200 139.846,271.200 140.600 C 271.200 141.333,270.987 141.600,270.400 141.600 C 269.456 141.600,269.181 144.993,270.100 145.300 C 270.500 145.434,270.500 145.842,270.100 147.339 C 269.825 148.369,269.600 150.708,269.600 152.536 C 269.600 155.567,269.511 155.944,268.598 156.802 L 267.596 157.744 268.467 158.672 C 268.947 159.182,269.758 159.600,270.270 159.600 C 270.933 159.600,271.200 159.829,271.200 160.400 C 271.200 160.933,270.933 161.200,270.400 161.200 C 269.641 161.200,269.600 161.467,269.600 166.420 C 269.600 170.374,269.448 171.933,268.974 172.850 C 268.406 173.949,268.406 174.149,268.974 175.016 C 269.749 176.199,269.762 178.668,269.000 180.000 C 268.238 181.333,268.238 182.800,269.000 182.800 C 269.512 182.800,269.600 183.889,269.600 190.200 C 269.600 196.511,269.512 197.600,269.000 197.600 C 267.438 197.600,268.720 200.775,270.314 200.854 C 271.257 200.902,271.281 200.932,270.500 201.082 C 269.731 201.230,269.600 201.509,269.600 202.999 C 269.600 204.374,269.392 204.905,268.616 205.516 L 267.632 206.290 268.616 207.215 C 270.026 208.539,270.105 214.811,268.730 216.274 L 267.861 217.200 268.730 218.126 C 269.491 218.936,269.600 219.505,269.600 222.677 C 269.600 225.399,269.748 226.425,270.196 226.796 C 270.523 227.068,270.690 227.455,270.566 227.655 C 270.280 228.117,271.214 227.931,271.842 227.400 C 272.103 227.180,272.234 226.865,272.134 226.700 C 272.035 226.535,272.188 226.387,272.476 226.372 C 272.764 226.356,272.640 226.180,272.200 225.979 C 271.577 225.696,271.754 225.631,273.000 225.688 C 274.102 225.738,274.567 225.605,274.493 225.259 C 274.370 224.683,275.335 223.600,275.971 223.600 C 276.207 223.600,276.400 223.330,276.400 223.000 C 276.400 222.670,276.580 222.378,276.800 222.350 C 277.020 222.322,277.425 222.273,277.700 222.241 C 277.975 222.209,278.147 221.871,278.082 221.491 C 277.999 221.000,278.235 220.800,278.897 220.800 C 279.560 220.800,279.848 220.555,279.893 219.955 C 279.970 218.933,280.113 218.771,281.063 218.632 C 281.469 218.572,281.800 218.279,281.800 217.980 C 281.800 217.681,282.216 217.338,282.724 217.218 C 283.232 217.098,283.637 216.865,283.624 216.700 C 283.531 215.519,283.696 215.200,284.400 215.200 C 284.840 215.200,285.200 214.951,285.200 214.646 C 285.200 214.341,285.650 213.797,286.200 213.437 C 286.750 213.076,287.200 212.535,287.200 212.234 C 287.200 211.933,287.650 211.574,288.200 211.436 C 289.369 211.142,289.535 209.970,288.523 209.149 C 287.939 208.675,287.897 208.682,288.212 209.200 C 288.805 210.174,288.767 210.762,288.127 210.517 C 287.693 210.350,287.661 210.210,288.009 209.994 C 288.351 209.783,288.361 209.623,288.043 209.426 C 287.292 208.963,287.554 208.295,288.400 208.516 C 288.839 208.631,289.300 208.562,289.423 208.362 C 289.546 208.163,289.175 208.000,288.597 208.000 L 287.547 208.000 287.728 204.100 C 287.929 199.791,288.305 197.600,288.845 197.600 C 289.040 197.600,289.200 197.150,289.200 196.600 C 289.200 195.867,288.987 195.600,288.400 195.600 C 287.425 195.600,287.237 190.171,288.100 186.939 C 288.500 185.442,288.500 185.034,288.100 184.900 C 287.326 184.642,287.509 183.149,288.434 182.164 C 289.107 181.447,289.184 181.118,288.834 180.464 C 288.595 180.018,288.400 179.191,288.400 178.626 C 288.400 178.062,288.207 177.600,287.971 177.600 C 287.582 177.600,287.582 175.962,287.976 164.700 C 287.989 164.315,287.996 163.685,287.991 163.300 C 287.965 161.406,288.538 157.600,288.848 157.600 C 289.042 157.600,289.200 156.430,289.200 155.000 C 289.200 152.635,289.125 152.400,288.370 152.400 C 287.579 152.400,287.549 152.243,287.755 149.100 C 287.874 147.285,287.966 145.350,287.961 144.800 C 287.955 144.250,287.972 143.485,287.999 143.100 C 288.026 142.715,288.025 141.590,287.997 140.600 C 287.893 136.915,287.852 115.763,287.947 114.800 C 288.001 114.250,287.922 113.195,287.771 112.456 C 287.579 111.515,287.659 111.011,288.037 110.777 C 288.480 110.503,288.490 110.115,288.089 108.616 C 287.418 106.109,287.471 105.600,288.400 105.600 C 288.987 105.600,289.200 105.333,289.200 104.600 C 289.200 103.852,288.989 103.600,288.363 103.600 C 287.593 103.600,287.543 103.432,287.739 101.500 C 288.078 98.160,288.460 96.400,288.844 96.400 C 289.040 96.400,289.200 95.950,289.200 95.400 C 289.200 94.850,289.003 94.400,288.763 94.400 C 288.326 94.400,288.435 91.978,289.020 88.700 C 289.260 87.356,289.200 87.200,288.444 87.200 C 287.222 87.200,287.158 80.727,288.367 79.426 C 289.519 78.185,289.607 75.361,288.518 74.598 C 287.878 74.150,287.626 74.123,287.503 74.490 C 287.414 74.759,287.235 74.579,287.107 74.089 C 286.979 73.600,287.036 73.298,287.233 73.420 C 287.825 73.786,287.137 72.239,286.468 71.700 C 286.126 71.425,285.354 71.200,284.751 71.200 C 283.920 71.200,283.625 70.983,283.528 70.300 C 283.445 69.717,283.164 69.439,282.729 69.511 C 282.298 69.582,282.012 69.305,281.929 68.735 C 281.829 68.048,281.486 67.818,280.400 67.709 C 278.363 67.505,277.948 67.292,278.081 66.522 C 278.181 65.946,277.922 65.852,276.500 65.947 C 275.171 66.036,274.800 65.924,274.800 65.431 C 274.800 65.084,274.609 64.800,274.376 64.800 C 274.143 64.800,274.053 64.638,274.175 64.440 C 274.298 64.242,273.848 64.118,273.176 64.164 C 272.504 64.211,271.864 64.103,271.753 63.925 C 271.535 63.571,270.886 63.548,270.100 63.865 M292.454 206.113 C 292.418 206.863,292.106 207.344,291.500 207.588 C 290.891 207.832,290.810 207.957,291.251 207.975 C 292.183 208.011,292.891 206.998,292.685 205.922 C 292.531 205.113,292.502 205.137,292.454 206.113 M282.054 258.620 C 282.025 259.071,282.177 259.617,282.394 259.834 C 282.771 260.211,282.333 260.334,280.308 260.421 C 279.927 260.438,279.510 260.622,279.380 260.832 C 279.251 261.042,278.977 261.109,278.772 260.983 C 278.568 260.856,278.400 261.235,278.400 261.825 C 278.400 262.703,278.298 262.813,277.836 262.430 C 277.403 262.071,277.202 262.074,276.974 262.442 C 276.773 262.767,276.860 262.829,277.238 262.632 C 277.547 262.472,277.451 262.624,277.024 262.970 C 276.451 263.435,276.398 263.607,276.824 263.625 C 277.141 263.639,276.950 263.847,276.400 264.088 C 275.850 264.328,275.265 264.497,275.100 264.462 C 274.935 264.428,274.800 264.779,274.800 265.243 C 274.800 265.794,274.610 266.013,274.249 265.874 C 273.537 265.601,272.801 266.337,273.074 267.049 C 273.277 267.577,272.797 267.775,271.677 267.625 C 271.390 267.586,271.186 267.790,271.225 268.077 C 271.375 269.197,271.177 269.677,270.649 269.474 C 269.961 269.210,269.197 269.928,269.454 270.597 C 269.677 271.178,268.529 271.727,267.902 271.339 C 267.654 271.186,267.593 271.266,267.757 271.530 C 268.088 272.066,267.351 273.600,266.762 273.600 C 266.537 273.600,266.488 273.375,266.653 273.100 C 266.857 272.760,266.737 272.776,266.277 273.149 C 265.544 273.743,265.349 274.202,266.000 273.800 C 266.480 273.503,266.514 274.001,266.062 274.714 C 265.882 274.997,265.436 275.112,265.068 274.971 C 264.545 274.770,264.400 274.950,264.400 275.800 C 264.400 276.660,264.255 276.835,263.700 276.642 C 263.061 276.419,263.063 276.447,263.724 276.961 C 264.182 277.317,264.292 277.619,264.024 277.785 C 263.791 277.929,263.600 277.876,263.600 277.666 C 263.600 277.082,262.461 276.778,262.151 277.279 C 261.976 277.562,262.060 277.610,262.381 277.412 C 262.749 277.184,262.816 277.321,262.627 277.916 C 262.478 278.384,262.572 278.859,262.846 279.028 C 263.168 279.227,263.218 279.153,263.000 278.800 C 262.779 278.443,262.832 278.373,263.165 278.579 C 263.434 278.745,263.558 279.133,263.440 279.440 C 263.322 279.748,263.399 280.000,263.613 280.000 C 264.418 280.000,264.039 283.707,263.134 284.670 C 262.044 285.831,262.979 287.200,264.862 287.200 C 265.850 287.200,265.993 287.345,265.946 288.300 C 265.899 289.243,265.866 289.272,265.718 288.500 C 265.609 287.937,265.255 287.600,264.772 287.600 C 264.067 287.600,264.000 287.909,264.000 291.138 C 264.000 294.168,263.885 294.780,263.200 295.400 C 262.760 295.798,262.400 296.546,262.400 297.062 C 262.400 297.733,262.627 298.000,263.200 298.000 C 264.467 298.000,264.430 310.490,263.159 311.843 L 262.319 312.738 263.159 313.458 C 264.125 314.285,264.489 323.600,263.556 323.600 C 263.259 323.600,263.208 324.095,263.400 325.100 C 263.559 325.925,263.768 329.109,263.866 332.174 C 264.036 337.495,264.089 337.791,265.043 338.674 C 266.112 339.666,268.396 339.955,268.406 339.100 C 268.410 338.767,268.542 338.800,268.800 339.200 C 269.117 339.690,269.189 339.644,269.194 338.945 C 269.199 338.244,269.514 338.044,270.953 337.828 C 272.268 337.631,272.692 337.395,272.653 336.883 C 272.613 336.371,272.975 336.169,274.100 336.076 C 274.925 336.008,275.603 335.738,275.606 335.476 C 275.610 335.191,275.768 335.240,276.000 335.600 C 276.316 336.088,276.389 336.038,276.394 335.328 C 276.398 334.743,276.684 334.414,277.264 334.328 C 277.739 334.258,278.175 333.869,278.234 333.463 C 278.374 332.487,278.363 332.494,280.164 332.320 C 281.294 332.211,281.758 331.969,281.834 331.450 C 281.934 330.766,281.902 330.764,281.170 331.427 C 280.746 331.811,280.400 331.931,280.400 331.696 C 280.400 331.460,280.940 331.028,281.600 330.736 C 282.260 330.444,282.800 329.968,282.800 329.679 C 282.800 329.389,282.999 329.276,283.243 329.426 C 283.541 329.611,283.607 329.389,283.447 328.750 C 283.315 328.228,283.311 328.025,283.437 328.300 C 283.709 328.892,285.600 328.980,285.600 328.400 C 285.600 328.180,285.409 328.000,285.176 328.000 C 284.943 328.000,284.864 327.820,285.000 327.600 C 285.136 327.380,284.967 327.200,284.624 327.200 C 284.225 327.200,284.000 326.839,284.000 326.200 C 284.000 325.578,283.773 325.200,283.400 325.200 C 282.638 325.200,282.638 323.733,283.400 322.400 C 284.349 320.740,284.161 318.290,283.000 317.200 C 281.948 316.212,281.441 310.800,282.400 310.800 C 282.620 310.800,282.800 310.181,282.800 309.424 C 282.800 308.667,282.620 307.936,282.400 307.800 C 281.495 307.241,281.937 302.136,283.000 300.873 C 283.711 300.028,284.000 299.210,284.000 298.042 C 284.000 296.557,283.904 296.400,283.000 296.400 C 282.007 296.400,282.000 296.373,282.000 292.800 C 282.000 289.227,282.007 289.200,283.000 289.200 L 284.000 289.200 284.000 283.870 C 284.000 278.698,283.970 278.511,282.998 277.598 L 281.996 276.656 282.867 275.728 L 283.739 274.800 282.877 273.882 L 282.014 272.964 282.847 272.131 C 283.525 271.452,283.598 271.144,283.240 270.475 C 282.998 270.023,282.800 269.191,282.800 268.626 C 282.800 268.062,282.620 267.600,282.400 267.600 C 282.180 267.600,282.000 266.790,282.000 265.800 C 282.000 264.147,282.081 264.000,283.000 264.000 C 283.919 264.000,284.000 263.853,284.000 262.200 C 284.000 261.200,283.812 260.400,283.576 260.400 C 283.343 260.400,283.264 260.220,283.400 260.000 C 283.536 259.780,283.379 259.600,283.051 259.600 C 282.724 259.600,282.378 259.195,282.282 258.700 C 282.126 257.886,282.104 257.879,282.054 258.620 M280.396 259.404 C 279.857 260.055,280.280 260.191,281.143 259.644 C 281.472 259.435,281.529 259.204,281.288 259.054 C 281.069 258.919,280.668 259.077,280.396 259.404 M265.717 276.388 C 265.346 276.821,264.962 277.096,264.864 276.998 C 264.626 276.759,265.605 275.600,266.045 275.600 C 266.236 275.600,266.089 275.955,265.717 276.388 M265.930 280.349 L 265.860 282.200 265.703 280.408 C 265.616 279.422,265.332 278.342,265.072 278.008 C 264.660 277.477,264.688 277.469,265.300 277.949 C 265.809 278.348,265.981 279.002,265.930 280.349 M260.800 279.133 C 260.800 279.610,260.964 280.000,261.165 280.000 C 261.571 280.000,261.511 278.977,261.078 278.545 C 260.925 278.392,260.800 278.657,260.800 279.133 " stroke="none" fill="#e9bcce" fill-rule="evenodd"></path><path id="path8" d="M241.124 51.645 C 240.286 51.867,240.268 51.919,240.934 52.201 C 241.839 52.584,241.094 53.184,239.700 53.194 C 238.901 53.199,238.800 53.402,238.800 55.000 C 238.800 56.653,238.881 56.800,239.800 56.800 C 240.600 56.800,240.800 57.000,240.800 57.800 C 240.800 58.600,240.600 58.800,239.800 58.800 C 238.900 58.800,238.800 58.960,238.800 60.400 C 238.800 61.840,238.900 62.000,239.800 62.000 C 240.600 62.000,240.800 62.200,240.800 63.000 C 240.800 63.800,240.600 64.000,239.800 64.000 C 238.345 64.000,238.329 67.018,239.777 68.379 C 240.695 69.241,240.717 69.355,240.131 70.249 C 239.567 71.110,239.567 71.290,240.131 72.151 C 240.717 73.045,240.695 73.159,239.777 74.021 C 238.472 75.248,238.483 76.400,239.800 76.400 C 240.771 76.400,240.800 76.480,240.800 79.200 C 240.800 81.920,240.771 82.000,239.800 82.000 L 238.800 82.000 238.800 87.400 L 238.800 92.800 239.800 92.800 C 240.793 92.800,240.800 92.827,240.800 96.400 C 240.800 99.333,240.689 100.000,240.200 100.000 C 239.783 100.000,239.600 100.420,239.600 101.376 C 239.600 102.133,239.420 102.864,239.200 103.000 C 238.639 103.347,238.700 108.268,239.286 109.888 C 239.668 110.943,239.668 111.400,239.286 112.011 C 238.447 113.354,238.672 114.400,239.800 114.400 C 240.771 114.400,240.800 114.480,240.800 117.200 C 240.800 119.920,240.771 120.000,239.800 120.000 C 238.757 120.000,238.307 121.648,239.200 122.200 C 239.749 122.539,239.704 124.136,239.129 124.711 C 238.767 125.073,238.860 125.358,239.529 125.938 C 240.705 126.958,240.626 127.443,239.200 127.940 C 237.433 128.556,238.016 130.800,239.944 130.800 C 241.113 130.800,241.057 132.019,239.837 133.165 L 238.874 134.070 239.695 136.047 L 240.517 138.024 239.628 138.970 C 239.059 139.576,238.894 140.011,239.170 140.181 C 239.406 140.328,239.600 141.067,239.600 141.824 C 239.600 142.780,239.783 143.200,240.200 143.200 C 240.676 143.200,240.800 143.778,240.800 146.000 C 240.800 148.222,240.676 148.800,240.200 148.800 C 239.388 148.800,239.378 152.354,240.187 153.424 C 240.957 154.441,240.944 155.247,240.132 156.868 C 238.884 159.359,238.800 159.589,238.800 160.525 C 238.800 161.039,239.250 161.883,239.800 162.400 C 240.568 163.121,240.800 163.741,240.800 165.070 C 240.800 166.649,240.713 166.800,239.800 166.800 L 238.800 166.800 238.800 173.000 L 238.800 179.200 239.800 179.200 C 240.600 179.200,240.800 179.400,240.800 180.200 C 240.800 180.822,240.573 181.200,240.200 181.200 C 239.711 181.200,239.600 181.867,239.600 184.800 C 239.600 186.933,239.437 188.400,239.200 188.400 C 238.646 188.400,238.698 189.848,239.286 190.789 C 239.668 191.400,239.668 191.857,239.286 192.912 C 238.410 195.337,238.633 197.200,239.800 197.200 C 240.771 197.200,240.800 197.280,240.800 200.000 C 240.800 202.166,240.670 202.800,240.226 202.800 C 239.777 202.800,239.607 203.698,239.450 206.900 C 239.339 209.155,239.130 211.945,238.986 213.100 C 238.728 215.162,238.742 215.200,239.761 215.200 C 240.603 215.200,240.800 215.390,240.800 216.200 C 240.800 216.822,240.573 217.200,240.200 217.200 C 239.783 217.200,239.600 217.620,239.600 218.576 C 239.600 219.333,239.405 220.073,239.167 220.220 C 238.893 220.390,239.113 220.883,239.771 221.570 L 240.808 222.653 239.804 223.596 C 238.435 224.883,238.478 225.986,239.900 226.046 C 240.577 226.075,240.731 226.163,240.300 226.276 C 239.442 226.500,239.382 227.959,240.187 229.024 C 241.350 230.561,241.037 242.038,239.800 243.200 C 239.250 243.717,238.800 244.558,238.800 245.070 C 238.800 245.795,239.020 246.000,239.800 246.000 C 240.600 246.000,240.800 246.200,240.800 247.000 C 240.800 247.800,240.600 248.000,239.800 248.000 C 238.900 248.000,238.800 248.160,238.800 249.600 C 238.800 251.040,238.900 251.200,239.800 251.200 C 240.771 251.200,240.800 251.280,240.800 254.000 C 240.800 256.922,240.878 257.032,242.800 256.832 C 243.196 256.791,243.098 257.013,242.510 257.485 C 241.859 258.008,241.724 258.361,242.004 258.800 C 242.215 259.130,242.391 259.203,242.394 258.961 C 242.405 258.169,243.806 256.881,244.810 256.739 C 245.532 256.637,245.863 256.280,246.050 255.400 C 246.190 254.740,246.327 254.357,246.353 254.549 C 246.379 254.741,246.668 254.676,246.996 254.404 C 247.323 254.132,247.500 253.762,247.389 253.582 C 247.278 253.402,247.684 253.197,248.293 253.127 C 249.088 253.036,249.436 252.746,249.528 252.100 C 249.610 251.522,249.932 251.200,250.428 251.200 C 250.924 251.200,251.200 250.924,251.200 250.428 C 251.200 249.932,251.522 249.610,252.100 249.528 C 252.678 249.446,253.046 249.078,253.128 248.500 C 253.210 247.922,253.532 247.600,254.028 247.600 C 254.524 247.600,254.800 247.324,254.800 246.828 C 254.800 246.332,255.122 246.010,255.700 245.928 C 256.278 245.846,256.646 245.478,256.728 244.900 C 256.810 244.322,257.132 244.000,257.628 244.000 C 258.124 244.000,258.400 243.724,258.400 243.228 C 258.400 242.732,258.722 242.410,259.300 242.328 C 259.878 242.246,260.246 241.878,260.328 241.300 C 260.408 240.735,260.733 240.400,261.200 240.400 C 261.667 240.400,261.992 240.065,262.072 239.500 C 262.156 238.909,262.475 238.600,263.000 238.600 C 263.525 238.600,263.844 238.291,263.928 237.700 C 264.010 237.122,264.332 236.800,264.828 236.800 C 265.324 236.800,265.600 236.524,265.600 236.028 C 265.600 235.532,265.922 235.210,266.500 235.128 C 267.240 235.023,267.415 234.722,267.486 233.432 C 267.569 231.931,268.203 231.031,268.881 231.450 C 269.056 231.558,269.203 231.232,269.206 230.724 C 269.212 229.774,269.982 228.174,269.994 229.087 C 269.997 229.356,270.270 229.471,270.600 229.345 C 270.930 229.218,271.200 228.763,271.200 228.334 C 271.200 227.845,271.027 227.660,270.738 227.838 C 270.470 228.004,270.384 227.949,270.534 227.707 C 270.675 227.478,270.523 227.068,270.196 226.796 C 269.748 226.425,269.600 225.399,269.600 222.677 C 269.600 219.505,269.491 218.936,268.730 218.126 L 267.861 217.200 268.730 216.274 C 270.105 214.811,270.026 208.539,268.616 207.215 L 267.632 206.290 268.616 205.516 C 269.392 204.905,269.600 204.374,269.600 202.999 C 269.600 201.509,269.731 201.230,270.500 201.082 C 271.281 200.932,271.257 200.902,270.314 200.854 C 268.720 200.775,267.438 197.600,269.000 197.600 C 269.512 197.600,269.600 196.511,269.600 190.200 C 269.600 183.889,269.512 182.800,269.000 182.800 C 268.238 182.800,268.238 181.333,269.000 180.000 C 269.762 178.668,269.749 176.199,268.974 175.016 C 268.406 174.149,268.406 173.949,268.974 172.850 C 269.448 171.933,269.600 170.374,269.600 166.420 C 269.600 161.467,269.641 161.200,270.400 161.200 C 270.933 161.200,271.200 160.933,271.200 160.400 C 271.200 159.829,270.933 159.600,270.270 159.600 C 269.758 159.600,268.947 159.182,268.467 158.672 L 267.596 157.744 268.598 156.802 C 269.511 155.944,269.600 155.567,269.600 152.536 C 269.600 150.708,269.825 148.369,270.100 147.339 C 270.500 145.842,270.500 145.434,270.100 145.300 C 269.181 144.993,269.456 141.600,270.400 141.600 C 270.987 141.600,271.200 141.333,271.200 140.600 C 271.200 139.846,270.990 139.600,270.348 139.600 C 269.578 139.600,269.523 139.455,269.787 138.100 C 269.947 137.275,270.056 136.330,270.030 136.000 C 270.004 135.670,269.880 134.365,269.754 133.100 C 269.542 130.960,269.584 130.800,270.363 130.800 C 270.989 130.800,271.200 130.548,271.200 129.800 C 271.200 129.067,270.987 128.800,270.400 128.800 C 269.627 128.800,269.600 128.533,269.600 120.800 C 269.600 113.956,269.513 112.800,269.000 112.800 C 268.556 112.800,268.400 112.333,268.400 111.000 C 268.400 109.667,268.556 109.200,269.000 109.200 C 269.508 109.200,269.600 108.222,269.600 102.800 C 269.600 96.667,269.633 96.400,270.400 96.400 C 270.987 96.400,271.200 96.133,271.200 95.400 C 271.200 94.667,270.987 94.400,270.400 94.400 C 269.139 94.400,269.232 91.326,270.500 91.082 L 271.400 90.909 270.500 90.854 C 269.726 90.808,269.600 90.576,269.600 89.200 L 269.600 87.600 271.500 87.540 C 272.674 87.503,272.979 87.416,272.300 87.313 C 271.537 87.198,271.200 86.910,271.200 86.373 C 271.200 85.867,270.924 85.600,270.400 85.600 C 269.719 85.600,269.600 85.333,269.600 83.800 C 269.600 82.267,269.719 82.000,270.400 82.000 C 271.081 82.000,271.200 81.733,271.200 80.200 C 271.200 78.667,271.081 78.400,270.400 78.400 C 269.659 78.400,269.600 78.133,269.600 74.800 C 269.600 72.667,269.763 71.200,270.000 71.200 C 270.220 71.200,270.400 70.390,270.400 69.400 C 270.400 68.410,270.220 67.600,270.000 67.600 C 269.780 67.600,269.600 66.802,269.600 65.827 C 269.600 63.918,270.642 63.039,271.784 63.986 C 272.191 64.325,272.404 64.318,272.626 63.958 C 272.808 63.663,272.755 63.581,272.489 63.745 C 272.251 63.892,271.942 63.830,271.804 63.607 C 271.666 63.383,271.068 63.175,270.476 63.146 C 269.534 63.098,269.512 63.070,270.300 62.918 C 271.519 62.683,271.445 62.000,270.200 62.000 C 269.460 62.000,269.200 61.788,269.200 61.182 C 269.200 60.733,268.975 60.394,268.700 60.430 C 266.840 60.671,265.600 60.358,265.600 59.647 C 265.600 58.779,264.570 58.413,262.100 58.405 C 260.668 58.401,260.400 58.274,260.400 57.600 C 260.400 56.919,260.133 56.800,258.600 56.800 C 257.520 56.800,256.800 56.618,256.800 56.344 C 256.800 55.451,255.369 54.825,253.300 54.813 C 251.471 54.802,251.200 54.697,251.200 54.000 C 251.200 53.282,250.933 53.200,248.600 53.200 C 246.556 53.200,246.000 53.072,246.000 52.600 C 246.000 52.270,245.730 52.000,245.400 52.000 C 245.070 52.000,244.800 51.865,244.800 51.700 C 244.800 51.339,242.413 51.303,241.124 51.645 M145.700 55.087 C 146.305 55.178,147.295 55.178,147.900 55.087 C 148.505 54.995,148.010 54.920,146.800 54.920 C 145.590 54.920,145.095 54.995,145.700 55.087 M136.905 58.687 C 137.514 58.779,138.414 58.777,138.905 58.682 C 139.397 58.587,138.900 58.511,137.800 58.514 C 136.700 58.517,136.297 58.595,136.905 58.687 M272.100 225.876 C 272.485 225.976,273.115 225.976,273.500 225.876 C 273.885 225.775,273.570 225.693,272.800 225.693 C 272.030 225.693,271.715 225.775,272.100 225.876 M272.200 226.800 C 272.336 227.020,272.257 227.200,272.024 227.200 C 271.791 227.200,271.600 227.350,271.600 227.533 C 271.600 227.717,271.870 227.867,272.200 227.867 C 272.530 227.867,272.800 227.537,272.800 227.133 C 272.800 226.730,272.609 226.400,272.376 226.400 C 272.143 226.400,272.064 226.580,272.200 226.800 M265.837 274.200 C 265.476 274.750,265.366 275.200,265.591 275.200 C 265.816 275.200,266.000 275.033,266.000 274.829 C 266.000 274.624,266.283 274.174,266.629 273.829 C 266.974 273.483,267.085 273.200,266.875 273.200 C 266.664 273.200,266.197 273.650,265.837 274.200 M265.192 276.210 C 264.914 276.545,264.766 276.900,264.864 276.998 C 264.962 277.096,265.346 276.821,265.717 276.388 C 266.089 275.955,266.236 275.600,266.045 275.600 C 265.854 275.600,265.470 275.874,265.192 276.210 M262.170 277.763 C 261.713 278.284,261.383 279.001,261.435 279.355 C 261.563 280.227,260.906 280.179,260.676 279.300 C 260.538 278.773,260.481 278.823,260.446 279.500 C 260.420 280.003,260.141 280.400,259.814 280.400 C 259.492 280.400,259.042 280.748,258.814 281.173 C 258.587 281.598,258.041 282.060,257.600 282.200 C 257.160 282.340,256.800 282.802,256.800 283.227 C 256.800 283.652,256.536 284.000,256.214 284.000 C 255.892 284.000,255.442 284.348,255.214 284.773 C 254.987 285.198,254.441 285.660,254.000 285.800 C 253.560 285.940,253.200 286.402,253.200 286.827 C 253.200 287.324,252.924 287.600,252.427 287.600 C 252.002 287.600,251.543 287.951,251.406 288.380 C 251.270 288.808,250.812 289.269,250.388 289.404 C 249.963 289.539,249.634 289.773,249.655 289.924 C 249.770 290.731,249.537 291.200,249.023 291.200 C 248.705 291.200,248.210 291.527,247.923 291.926 C 247.635 292.326,247.074 292.775,246.675 292.924 C 246.276 293.072,246.039 293.339,246.148 293.516 C 246.407 293.935,245.998 294.486,245.000 295.063 C 244.560 295.317,244.245 295.722,244.300 295.963 C 244.360 296.223,243.749 296.400,242.791 296.400 C 241.467 296.400,241.103 296.575,240.731 297.392 C 240.482 297.938,239.946 298.490,239.539 298.619 C 239.133 298.748,238.800 299.069,238.800 299.332 C 238.800 299.595,238.395 299.988,237.900 300.205 C 237.405 300.422,237.000 300.870,237.000 301.200 C 237.000 301.530,236.595 302.031,236.100 302.313 C 235.605 302.595,235.200 303.120,235.200 303.479 C 235.200 303.839,235.086 304.020,234.947 303.881 C 234.561 303.495,233.143 304.385,233.423 304.838 C 233.558 305.056,233.465 305.481,233.215 305.782 C 232.875 306.192,232.882 306.403,233.242 306.626 C 233.547 306.815,233.619 306.755,233.438 306.462 C 232.996 305.747,234.227 305.910,234.839 306.647 C 235.323 307.231,235.192 307.280,233.503 307.146 C 231.895 307.018,231.563 307.122,231.155 307.885 C 230.893 308.373,230.516 308.672,230.316 308.548 C 230.116 308.424,230.278 308.061,230.676 307.740 C 231.339 307.205,231.321 307.194,230.469 307.609 C 229.883 307.894,229.623 308.284,229.769 308.663 C 229.896 308.995,230.000 309.351,230.000 309.456 C 230.000 309.561,230.200 309.524,230.445 309.372 C 230.689 309.221,231.004 309.259,231.145 309.457 C 231.285 309.655,231.895 310.034,232.500 310.300 C 233.763 310.855,233.925 311.933,232.963 313.400 C 232.381 314.288,232.381 314.480,232.963 315.647 C 233.314 316.349,233.600 317.858,233.600 319.000 C 233.600 320.142,233.314 321.651,232.963 322.353 C 232.381 323.520,232.381 323.712,232.963 324.600 C 233.369 325.219,233.600 326.453,233.600 328.000 C 233.600 329.547,233.369 330.781,232.963 331.400 C 232.381 332.288,232.381 332.480,232.963 333.647 C 233.761 335.245,233.772 336.000,233.000 336.000 C 232.287 336.000,232.191 337.661,232.834 338.864 C 233.184 339.518,233.107 339.847,232.434 340.564 C 231.237 341.838,231.322 343.200,232.600 343.200 C 233.799 343.200,234.026 345.487,233.020 347.426 C 232.702 348.040,232.532 348.691,232.644 348.871 C 232.756 349.052,232.612 349.211,232.324 349.225 C 231.175 349.281,233.693 349.971,235.996 350.231 C 238.278 350.489,238.462 350.450,238.670 349.654 C 238.872 348.880,239.168 348.800,241.814 348.800 C 245.254 348.800,246.000 348.578,246.000 347.557 C 246.000 346.892,246.316 346.800,248.600 346.800 C 250.933 346.800,251.200 346.718,251.200 346.000 C 251.200 345.313,251.468 345.199,253.100 345.195 C 255.767 345.187,256.800 344.840,256.800 343.953 C 256.800 343.383,257.091 343.200,258.000 343.200 C 258.690 343.200,259.203 342.988,259.206 342.700 C 259.210 342.362,259.333 342.390,259.585 342.789 C 259.905 343.296,259.993 343.284,260.214 342.708 C 260.355 342.340,260.382 341.895,260.273 341.719 C 260.163 341.544,261.159 341.462,262.484 341.538 C 264.167 341.634,264.812 341.543,264.622 341.235 C 264.472 340.993,264.630 340.687,264.972 340.555 C 265.315 340.424,265.496 340.155,265.374 339.958 C 265.252 339.761,265.353 339.600,265.597 339.600 C 265.841 339.600,265.592 339.184,265.043 338.674 C 264.089 337.791,264.036 337.495,263.866 332.174 C 263.768 329.109,263.559 325.925,263.400 325.100 C 263.208 324.095,263.259 323.600,263.556 323.600 C 264.489 323.600,264.125 314.285,263.159 313.458 L 262.319 312.738 263.159 311.843 C 264.430 310.490,264.467 298.000,263.200 298.000 C 262.627 298.000,262.400 297.733,262.400 297.062 C 262.400 296.546,262.760 295.798,263.200 295.400 C 263.885 294.780,264.000 294.168,264.000 291.138 C 264.000 287.909,264.067 287.600,264.772 287.600 C 265.255 287.600,265.609 287.937,265.718 288.500 C 265.866 289.272,265.899 289.243,265.946 288.300 C 265.993 287.345,265.850 287.200,264.862 287.200 C 262.979 287.200,262.044 285.831,263.134 284.670 C 264.039 283.707,264.418 280.000,263.613 280.000 C 263.399 280.000,263.322 279.748,263.440 279.440 C 263.558 279.133,263.434 278.745,263.165 278.579 C 262.827 278.370,262.775 278.450,262.997 278.838 C 263.235 279.255,263.196 279.288,262.846 278.967 C 262.586 278.729,262.489 278.234,262.630 277.867 C 262.913 277.129,263.600 276.957,263.600 277.624 C 263.600 277.857,263.799 277.924,264.043 277.774 C 264.351 277.583,264.321 277.396,263.943 277.156 C 263.180 276.673,263.100 276.700,262.170 277.763 M265.072 278.008 C 265.332 278.342,265.616 279.422,265.703 280.408 L 265.860 282.200 265.930 280.349 C 265.981 279.002,265.809 278.348,265.300 277.949 C 264.688 277.469,264.660 277.477,265.072 278.008 " stroke="none" fill="#ecc4d2" fill-rule="evenodd"></path></g></svg>'

local logo = renderer.load_svg(d3, 14, 14)

local logs = {}

local easings = {
	lerp = function(self, start, vend, time)
		return start + (vend - start) * time
	end,

	clamp = function(self, val, min, max)
		if val > max then return max end
		if min > val then return min end
		return val
	end,

    ease_in_out_quart = function(self, x)
        local sqt = x^2
        return sqt / (2 * (sqt - x) + 1);
    
    end
}

local colors = {
	green = {163, 255, 15, 255},
	white = {250, 250, 250, 255},
	red = {231, 52, 52, 255},
	yellow = {252, 209, 4, 255},
	orange = {249, 140, 70, 255},
	blue = {61, 211, 236, 255},
}

local fag = {

	rounding = 9,
    rad = 9 + 2, --rounding + 2
    n = 45,
    o = 20,

    OutlineGlow = function(self, x, y, w, h, radius, r, g, b, a, mode)
        render_box(x+2,y+radius+self.rad,1,h-self.rad*2-radius*2,r,g,b,a)
        render_box(x+w-3,y+radius+self.rad,1,h-self.rad*2-radius*2,r,g,b,a)
        render_box(x+radius+self.rad,y+2,w-self.rad*2-radius*2,1,r,g,b,a)
        render_box(x+radius+self.rad,y+h-3,w-self.rad*2-radius*2,1,r,g,b,a)
        render_circle_outline(x+radius+self.rad,y+radius+self.rad,r,g,b,a,radius+self.rounding,180,0.25,1)
        render_circle_outline(x+w-radius-self.rad,y+radius+self.rad,r,g,b,a,radius+self.rounding,270,0.25,1)
        render_circle_outline(x+radius+self.rad,y+h-radius-self.rad,r,g,b,a,radius+self.rounding,90,0.25,1)
        render_circle_outline(x+w-radius-self.rad,y+h-radius-self.rad,r,g,b,a,radius+self.rounding,0,0.25,1) 
        
    end,

	rounded_box = function(self, x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) 
		render_box(x+radius,y,w-radius*2,radius,r,g,b,a)
		render_box(x,y+radius,radius,h-radius*2,r,g,b,a)
		render_box(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)
		render_box(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)
		render_box(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)
		render_circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)
		render_circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)
		render_circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)
		render_circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25)
	end,

	rounded_box3 = function(self, x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) 
		render_circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)
		render_circle(x-radius + 24,y+radius,r,g,b,a,radius,90,0.25)
		render_circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)
		render_circle(x-radius+ 24,y+h-radius,r,g,b,a,radius,0,0.25)
	end,

	rounded_box2 = function(self, x, y, w, h, radius,  r, g, b, a, glow, r1, g1, b1) 
		local n=a/255*self.n
        render_box(x+radius,y,w-radius*2,1,r,g,b,n)
        render_circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)
        render_circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)
        render_box(x,y+radius,1,h-radius*2,r,g,b,n)
        render_box(x+w-1,y+radius,1,h-radius*2,r,g,b,n)
        render_circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)
        render_circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)
        render_box(x+radius,y+h-1,w-radius*2,1,r,g,b,n)
		for radius=4,glow do 
            local radius=radius/2
            self:OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)
        end 
	end,

	OutlineGlow = function(self, x, y, w, h, radius, r, g, b, a) 
        renderer.rectangle(x+2,y+radius+self.rad,1,h-self.rad*2-radius*2,r,g,b,a)
        renderer.rectangle(x+w-3,y+radius+self.rad,1,h-self.rad*2-radius*2,r,g,b,a)
        renderer.rectangle(x+radius+self.rad,y+2,w-self.rad*2-radius*2,1,r,g,b,a)
        renderer.rectangle(x+radius+self.rad,y+h-3,w-self.rad*2-radius*2,1,r,g,b,a)
        renderer.circle_outline(x+radius+self.rad,y+radius+self.rad,r,g,b,a,radius+self.rounding,180,0.25,1)
        renderer.circle_outline(x+w-radius-self.rad,y+radius+self.rad,r,g,b,a,radius+self.rounding,270,0.25,1)
        renderer.circle_outline(x+radius+self.rad,y+h-radius-self.rad,r,g,b,a,radius+self.rounding,90,0.25,1)
        renderer.circle_outline(x+w-radius-self.rad,y+h-radius-self.rad,r,g,b,a,radius+self.rounding,0,0.25,1) 
    end,

	FadedRoundedGlow = function(self, x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) 
        local n=a/255*self.n
        renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)
        renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)
        renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)
        renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)
        renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)
        renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)
        renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)
        renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n)
        for radius=4,glow do 
            local radius=radius/2
            self:OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)
        end 
	end
}
local avatar_storage = {}

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2} 

visuals.add_to_side = function(self)
	local screen = {client.screen_size()}
	local center = {screen[1]/2, screen[2]/2} 
	
	alphatest = globals.realtime() + 15
	
	
	table.insert(side_storage, {
		text = input,
		player = event_player,
	
		timer = globals.realtime(),
		alpha = 0,
		alpha2 = 0,
		alpha3 = 0,
	
		ypos = center[2],
		ypos2 = center[2],
	})

end

visuals.side_indicator = function(self)

	local r, g, b, a = 0, 0, 0, 125
	local r2, g2, b2, a2 = 0, 0, 0, 0

	local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])
	local hs_on = menu_get(menu.refs.hs[2]) and menu_get(menu.refs.hs[1])

	side_storage[1].active_description = true
	if dt_on then
		side_storage[1].description = "You currently have DT charged"
	elseif hs_on then
		side_storage[1].description = "You currently have HS charged"
	else
		side_storage[1].active_description = nil
	end

	

	for i, content in pairs(side_storage) do
		--renderer.gradient(x: number, y: number, w: number, h: number, r1: number, g1: number, b1: number, a1: number, r2: number, g2: number, b2: number, a2: number, ltr: boolean)
		
		if content.active_description == nil then
			content.ypos_descrption = easings:lerp(
				content.ypos_descrption,
				content.ypos + 25,
				globals.frametime() * 10
			)
			content.alpha_description = easings:lerp(
				content.alpha_description,
				0,
				globals.frametime() * 10
			)
			content.ypos_header = easings:lerp(
				content.ypos_header,
				content.ypos + 12,
				globals.frametime() * 10
			)
			
		else
			content.ypos_descrption = easings:lerp(
				content.ypos_descrption,
				content.ypos + 32,
				globals.frametime() * 10
			)
			content.alpha_description = easings:lerp(
				content.alpha_description,
				175,
				globals.frametime() * 10
			)
			content.ypos_header = easings:lerp(
				content.ypos_header,
				content.ypos + 2,
				globals.frametime() * 15
			)
		end
		render_gradient(15, content.ypos, 235, 52, r, g, b, a, r2, g2, b2, a2, true)
		render_box(15, content.ypos, 4, 52, 255, 0, 0, 255)
		
		render_text(30, content.ypos_header + 2, 255, 255, 255, 255, "bd+", 0, content.header)
		render_text(30, content.ypos_descrption, 175, 175, 175, content.alpha_description, "bd", 0, content.description)

	end
end


visuals.add_to_log = function(self, input, event_player)
	local screen = {client.screen_size()}
	local center = {screen[1]/2, screen[2]/2} 
	
	alphatest = globals.realtime() + 15
	
	
	table.insert(logs, {
		text = input,
		player = event_player,
	
		timer = globals.realtime(),
		alpha = 0,
		alpha2 = 0,
		alpha3 = 0,
	
		ypos = 0,
		ypos2 = screen[2],
	})
end	

visuals.logs = function(self)
	if contains(menu_get(gui["Visuals"].indicators.additional), "Logs") then
    screen = {client.screen_size()} 
    center = { screen[1] / 2, screen[2] / 2}


	x = center[1]
	y = screen[2]

	for i, info in ipairs(logs) do
		if i > 6 then
			table.remove(logs, i)
		end

		local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
		local r2, g2, b2, a2 = menu_get(gui["Visuals"].colors.clr_logsglow_1)

		local bR, bG, bB, bA = 25,25,25,255

		local speed = 0
		if info.timer + 3.8 < globals.realtime() then
			if info.timer + 3.95 < globals.realtime() then
				info.text = ""
			end
			info.ypos = easings:lerp(
				info.ypos,
				215,
				globals.frametime() * 2
			)

			info.alpha = easings:lerp(
				info.alpha,
				0,
				globals.frametime() * 15
			)

			info.alpha2 = easings:lerp(
				info.alpha2,
				0,
				globals.frametime() * 50
			)

			info.alpha3 = easings:lerp(
				info.alpha3,
				0,
				globals.frametime() * 15
			)

			speed = globals.frametime() * 5

		else
			info.ypos = easings:lerp(
				info.ypos,
				175,
				globals.frametime() * 4
			)
			info.alpha = easings:lerp(
				info.alpha,
				255,
				globals.frametime() * 5
			)
			info.alpha2 = easings:lerp(
				info.alpha2,
				bA,
				globals.frametime() * 10
			)
			info.alpha3 = easings:lerp(
				info.alpha3,
				18,
				globals.frametime() * 15
			)

			speed = globals.frametime() * 15
		end

		local textSizeX, textSizeY = render_measure_text("", info.text)
        info.ypos2 = easings:lerp(info.ypos2, y, speed)

		local newY = info.ypos2 - info.ypos

		local fade_alpha = info.alpha
		local fade_alpha2 = info.alpha2

		local mode = 0
		local centerTxt = (textSizeX * 2 ) / 2
		local centerTxt2 = textSizeX / 2

		fag:FadedRoundedGlow(x - centerTxt2 - 19, newY - 1, textSizeX + 33, 22, 5, bR, bG, bB, fade_alpha2, info.alpha3, r2, g2, b2)

		fag:rounded_box(x - centerTxt2 - 18, newY, textSizeX + 31, 20, 3, bR, bG, bB, fade_alpha, 255, 255, 255, fade_alpha)

		if info.player ~= nil then
			renderer.texture(logo, x - centerTxt2 - 12, newY + 3, 14, 14, 255, 255, 255, fade_alpha, "")
			render_text(x - centerTxt2 + 8, newY + 3, 225, 225, 225, fade_alpha2, "", 0, info.text)

		else
			render_text(x - centerTxt2 + 8, newY + 3, 225, 225, 225, fade_alpha2, "", 0, info.text)
			renderer.texture(logo, x - centerTxt2 - 12, newY + 3, 14, 14, 255, 255, 255, fade_alpha, "")

		end

		y = y + 25
		if info.timer + 4 < globals.realtime() then table.remove(logs, i) end
	end
	::skip::
else
	logs = {}
end
end

local value_current = 0
local value_body = 0
local scope_fix = false
local scope_int = 0

local shift_int = 0
local list_shift = (function()
	local index, max = { }, 16
	for i=1, max do
		index[#index+1] = 0
		if i == max then
			return index
		end
	end
end)()
client.set_event_callback('net_update_start', function()
	exploits:simtimeAverage()
end)

local animkeys = {
	dt = 0,
	duck = 0,
	hide = 0,
	safe = 0,
	baim = 0
}

visuals.animate = {
	name = 0,
	state = 0,
	dt = 0,
	hs = 0,
	dtY = 0,
	hsY = 0,
	dtA = 0,
	dtcA = 0,
	hsA = 0,
	dtY = 0,
	globalY = 0,
}

menu.refs.sp = ui.reference("rage", "aimbot", "force safe point")
menu.refs.fb = ui.reference("rage", "aimbot", "force body aim")

visuals.gradienttext = function(self, text_to_draw, speed)
    local base_r, base_g, base_b,base_a = menu_get(gui["Visuals"].colors.clr_lua_name_1)
    local r2, g2, b2, a2 = menu_get(gui["Visuals"].colors.clr_lua_name2_1)
    local highlight_fraction =  (globals.realtime() / 2 % 1.2 * speed) - 1.2
    local output = ""
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw

        local r, g, b, a = base_r, base_g, base_b, base_a
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text_to_draw:sub(idx, idx))
    end
    return output
end


local alphas = {
	color1 = {},
	color2 = {},
	one = {},
	two = {},
	three = {},
	four = {},
	five = {},
	six = {},
	seven = {},
	update = false,
}

local star1_e = base64.encode("✨", CUSTOM_ENCODER)
local star1_d = base64.decode(star1_e, CUSTOM_DECODER)
local star2_e = base64.encode("⋆", CUSTOM_ENCODER)
local star2_d = base64.decode(star2_e, CUSTOM_DECODER)

visuals.indicator = function(self)
	local active = menu_get(gui["Visuals"].indicators.center) == "Simple"

	if active then
		local ypos = menu_get(gui["Visuals"].indicators.center_height)
		screen = {client_screen_size()}
		center = { screen[1] / 2, screen[2] / 2 + ypos}

		local me = entity_get_local_player()
		if me == nil then return end
		local lifestate = entity_get_prop(me, "m_lifeState") ~= 0
		if lifestate then return end

		local scoped = entity_get_prop(me, "m_bIsScoped") == 1

		local n1R, n1G, n1B, n1A = menu_get(gui["Visuals"].colors.clr_lua_name_1)
		local n2R, n2G, n2B, n2A = menu_get(gui["Visuals"].colors.clr_lua_name2_1)
		local bR, bG, bB, bA = menu_get(gui["Visuals"].colors.clr_DEV_1)
		local sR, sG, sB, sA = menu_get(gui["Visuals"].colors.clr_state_1)
		local dR, dG, dB, dA = menu_get(gui["Visuals"].colors.clr_dt_1)
		local dcR, dcG, dcB, dcA = menu_get(gui["Visuals"].colors.clr_dtcircle_1)
	
		local oR, oG, oB, oA = menu_get(gui["Visuals"].colors.clr_os_1)

		local version = build
		if version == "SOURCE" then version = "DEBUG" end
	
		if version == "LIVE" then
			self.animate.name = self:animation(scoped, self.animate.name, 24, 8)
		elseif version == "DEV" then
			self.animate.name = self:animation(scoped, self.animate.name, 26, 8)
		elseif version == "DEBUG" then
			self.animate.name = self:animation(scoped, self.animate.name, 28, 8)
		end

		self.animate.state = self:animation(scoped, self.animate.state, 17, 8)
		self.animate.dt = self:animation(scoped, self.animate.dt, 10, 8)
		
		self.animate.hs = self:animation(scoped, self.animate.hs, 13, 8)

		local DEVAlpha = self:pulsate_text(version, 0.75, 255)

		local astraltxt = self:gradienttext("RXMVNC3" .. version, 2)

		local state = entity:state()

		if state == nil then return end

		local dt_on = menu_get(menu.refs.dt[2]) and menu_get(menu.refs.dt[1])
		local hs_on = menu_get(menu.refs.hs[2]) and menu_get(menu.refs.hs[1])

		if dt_on == false and hs_on == false then
			state = "DEFAULT"
		end

		yOffset = 10

		self.animate.dtcA = self:animation(dt_on, self.animate.dtcA, dcA, 8)
		self.animate.dtA = self:animation(dt_on, self.animate.dtA, dA, 8)
		self.animate.hsA = self:animation(hs_on, self.animate.hsA, oA, 8)

		local speed = globals.frametime() * 25
		self.animate.dtY = self:animation(dt_on, self.animate.dtY, yOffset, 8)

		if dt_on then yOffset = yOffset + 9 end
			local dtX = render_measure_text("-", "DT") / 2
			render_circle_outline(center[1] - dtX + self.animate.dt + 12, center[2] + 55 + self.animate.dtY, 15, 15, 15, self.animate.dtcA, 3, 0, 1, 1)
			render_circle_outline(center[1] - dtX + self.animate.dt + 12, center[2] + 55 + self.animate.dtY, dcR, dcG, dcB, self.animate.dtcA, 3, 0, exploits.data.shift / 100, 1)

			render_text(center[1] - dtX + self.animate.dt - 3, center[2] + 50 + self.animate.dtY, dR, dG, dB, self.animate.dtA, "-", 0, "DT")

		self.animate.hsY = self:animation(hs_on, self.animate.hsY, yOffset, 8)
		if hs_on then yOffset = yOffset + 10 end
			local hsX = render_measure_text("-", "OSAA") / 2
			render_text(center[1] - hsX + self.animate.hs, center[2] + 50 + self.animate.hsY, oR, oG, oB, self.animate.hsA, "-", 0, "OSAA")

		local fullnameX = 0
		if version ~= "LIVE" then
			fullnameX = render_measure_text("-", "ASTRAL " .. version) / 4 - 2
		else
			fullnameX = render_measure_text("-", "ASTRAL") / 4 - 2
		end

		local nameX = render_measure_text("-", "ASTRAL") / 2
		if version == "DEBUG" then
			nameX = nameX + 1
		elseif version == "LIVE" then
			nameX = nameX + 4
		end

		local star1 = self:pulsate_text("star1", 0.25, 255)
		local star2 = self:pulsate_text("star2", 0.2, 255)
		local star3 = self:pulsate_text("star3", 0.33, 185)
		local star4 = self:pulsate_text("star4", 0.5, 255)
		local star5 = self:pulsate_text("star5", 0.2, 200)
		local star6 = self:pulsate_text("star6", 0.3, 255)
		local star7 = self:pulsate_text("star7", 0.4, 255)

		local sr, sg, sb = menu_get(gui["Visuals"].colors.clr_stars_1)
		local s2r, s2g, s2b = menu_get(gui["Visuals"].colors.clr_starstwo_1)

		alphas.color1.r = sr
		alphas.color1.g = sg
		alphas.color1.b = sb

		alphas.color2.r = s2r
		alphas.color2.g = s2g
		alphas.color2.b = s2b

		if star1 == nil then star1 = 0 end
		if star2 == nil then star2 = 0 end
		if star3 == nil then star3 = 0 end
		if star4 == nil then star4 = 0 end
		if star5 == nil then star5 = 0 end
		if star6 == nil then star6 = 0 end
		if star7 == nil then star7 = 0 end

		if star1 < 3 then
			local ran = math.random(1,2)
			alphas.one.r = alphas["color" .. ran].r
			alphas.one.g = alphas["color" .. ran].g
			alphas.one.b = alphas["color" .. ran].b
		end

		if star2 < 3 then
			local ran = math.random(1,2)
			alphas.two.r = alphas["color" .. ran].r
			alphas.two.g = alphas["color" .. ran].g
			alphas.two.b = alphas["color" .. ran].b
		end

		if star3 < 3 then
			local ran = math.random(1,2)
			alphas.three.r = alphas["color" .. ran].r
			alphas.three.g = alphas["color" .. ran].g
			alphas.three.b = alphas["color" .. ran].b
		end

		if star4 < 3  then
			local ran = math.random(1,2)
			alphas.four.r = alphas["color" .. ran].r
			alphas.four.g = alphas["color" .. ran].g
			alphas.four.b = alphas["color" .. ran].b
		end

		if star5 < 3  then
			local ran = math.random(1,2)
			alphas.five.r = alphas["color" .. ran].r
			alphas.five.g = alphas["color" .. ran].g
			alphas.five.b = alphas["color" .. ran].b
		end

		if star6 < 3 then
			local ran = math.random(1,2)
			alphas.six.r = alphas["color" .. ran].r
			alphas.six.g = alphas["color" .. ran].g
			alphas.six.b = alphas["color" .. ran].b
		end

		if star7 < 3 then
			local ran = math.random(1,2)
			alphas.seven.r = alphas["color" .. ran].r
			alphas.seven.g = alphas["color" .. ran].g
			alphas.seven.b = alphas["color" .. ran].b
		end

		render_text(center[1] + self.animate.name - fullnameX, center[2] + 39, alphas.one.r, alphas.one.g, alphas.one.b, star1, "c-", 0, star1_d)
		render_text(center[1] + self.animate.name - fullnameX + 12, center[2] + 34, alphas.two.r, alphas.two.g, alphas.two.b, star2, "c-", 0, star1_d)
		render_text(center[1] + self.animate.name - fullnameX + 20, center[2] + 34, alphas.three.r, alphas.three.g, alphas.three.b, star3, "c+", 0, star2_d)
		render_text(center[1] + self.animate.name - fullnameX + 27, center[2] + 29, alphas.four.r, alphas.four.g, alphas.four.b, star4, "c+", 0, star2_d)
		render_text(center[1] + self.animate.name - fullnameX + 4, center[2] + 26, alphas.five.r, alphas.five.g, alphas.five.b, star5, "c+", 0, star2_d)
		render_text(center[1] + self.animate.name - fullnameX + 30, center[2] + 39, alphas.six.r, alphas.six.g, alphas.six.b, star6, "c-", 0, star1_d)
		render_text(center[1] + self.animate.name - fullnameX - 5, center[2] + 34, alphas.seven.r, alphas.seven.g, alphas.seven.b, star7, "c-", 0, star1_d)


		--render_text(center[1] + self.animate.name - fullnameX, center[2] + 45, 255, 255, 255, 255, "-c", 0, astraltxt)
		render_text(center[1] + self.animate.name, center[2] + 45, 255, 255, 255, 255, "-c", 0, astraltxt)
		--if version ~= "LIVE" then
		--	render_text(center[1] + self.animate.name + nameX, center[2] + 45, bR, bG, bB, DEVAlpha, "-c", 0, version)
	--	end

		local stateX = render_measure_text("-", string.upper(state)) / 2 + 4
		if scoped then
			stateX = 15
		end

		render_text(center[1] - stateX + self.animate.state, center[2] + 50, sR, sG, sB, sA, "-", 0, " <" .. string.upper(state) .. "> ")
	end
end

visuals.statics_kills = function(self, x, y, w, h, title, users, clr, clr2, txt, txt2)

	local box = self:dragable_box(title, x, w, y, h)

	--background
	self:rounded_box(box[1], box[2], box[3], box[4], 4, clr[1], clr[2], clr[3], clr[4])

	--green line
	local gX, gY = box[1] + 145, box[2] + 10
	local gW, gH = box[3] - box[3] + 3, box[4] - 20

	-- render colored splítter
	self:rounded_box(gX,gY, gW, gH, 0, clr2[1], clr2[2], clr2[3], clr2[4])

	moveX = 0
	local pX, pY = box[1] + 110, box[2] + 15
	local cX, cY = pX + 13, pY + 14

	for i=1, #users do
		if i > 5 then goto skip end
		local entindex = users[i]
		
		local steam_id = entity_get_steam64(entindex)
		local avatar = images.get_steam_avatar(steam_id)

		--is it a bot
		if steam_id == nil or avatar == nil then
			avatar = images.get_steam_avatar(entity.get_steam64(entity.get_local_player()))
		end
		
		if avatar_storage[entindex] == nil or avatar_storage[entindex].conts ~= avatar.contents then
			avatar_storage[entindex] = {
				conts = avatar.contents,
				texture = renderer.load_rgba(avatar.contents, avatar.width, avatar.height)
			}
		end

		render_texture(avatar_storage[entindex].texture, pX + moveX, pY, 28, 28, 255, 255, 255, 255, "f")

		--this goes in another pic so dont change the thickness ndat
		render_circle_outline(cX + moveX, cY, 255, 255, 255, 255, 16, 0, 1, 2)

		--left sidecover up
		render_circle_outline(cX + moveX - 5, cY, 255, 255, 255, 255, 16, 90, 0.5, 4)

		if moveX == 0 then
			render_circle_outline(cX + moveX + 12, cY - 10, 255, 255, 255, 255, 5, 225, 0.55, 6)
			render_circle_outline(cX + moveX + 11, cY - 11, 255, 255, 255, 255, 5, 225, 0.55, 6)

			--render_circle_outline(cX + moveX + 11, cY - 10, 255, 0, 255, 255, 5, 225, 0.5, 4)

			render_circle_outline(cX + moveX + 11, cY + 10, 255, 255, 255, 255, 5, 320, 0.5, 4)
			render_circle_outline(cX + moveX + 12, cY + 10, 255, 255, 255, 255, 5, 320, 0.5, 4)

		else
			render_circle_outline(cX + moveX + 14, cY - 14, 255, 255, 255, 255, 2, 220, 0.5, 4)
			render_circle_outline(cX + moveX + 10, cY - 11, 255, 255, 255, 255, 5, 220, 0.5, 4)
			render_circle_outline(cX + moveX + 11, cY + 10, 255, 255, 255, 255, 5, 320, 0.5, 4)
			render_circle_outline(cX + moveX + 11, cY + 12, 255, 255, 255, 255, 5, 320, 0.5, 4)

		end
		moveX = moveX - 25

		renderer.draw_text(gX + 45, gY, 125, 25, 25, 255, fonts.f1, "ASDASDASD")

	end
	::skip::
end

visuals.esp = function(self)
	local enemies = entity_get_players(true)
	local me = entity_get_local_player()

	if me == nil then entity.miss = {} return end
	local above_head = menu_get(gui["Visuals"].indicators.esp) == "Above head"
	
	if above_head then
		for i=1, #enemies do
			local entindex = enemies[i]
			
			if esp.player[entindex] ~= nil then
				if esp.player[entindex].prefer then
					local x, y, x2, y2, alpha_mult = entity_get_bounding_box(entindex)
					if alpha_mult == 0 then return end
					if x == nil or y == nil or x2 == nil or y2 == nil then return end
					local mode = esp.player[entindex].mode
					local r,g,b,a = menu_get(gui["Visuals"].colors.clr_prefer_1)
					if mode == "BODY" then
						r,g,b,a = menu_get(gui["Visuals"].colors.clr_prefer_1)
					elseif mode == "SP" then
						r,g,b,a = menu_get(gui["Visuals"].colors.clr_safepoint_1)
					elseif mode == "BODY+SP" then
						r,g,b,a = menu_get(gui["Visuals"].colors.clr_safepointprefer_1)
					end

					local txtX, txtY = render_measure_text("", mode)
					local calcX = (x  + x2) / 2 - (txtX / 2) - 2
					render_text(calcX, y - 24, r,g,b,a, "b", 0, mode)
				end
			end
		end
	end
end


visuals.warnings = function(self)
	local active = contains(menu_get(gui["Visuals"]["indicators"].additional), "Warnings")

	if active then
		local me = entity_get_local_player()

		local screen = {client_screen_size()}
		local center = { screen[1] / 2, screen[2] / 2}


		if me == nil then return end
		local threat = client.current_threat()

		if threat == nil then return end
		local hp = entity_get_prop(me, "m_iHealth")
		local enemyhp = entity:is_baimable(me, threat) >= hp

		if ( hp <= 0 ) then goto skip end
		yOffset = 0

		local wR, wG, wB, wA = menu_get(gui["Visuals"].colors.clr_warnings_1)

		local warnAlpha = self:pulsate_text("WARNING", 1, wA)

		if enemyhp then
			render_text(center[1], center[2] - 45, wR, wG, wB, warnAlpha, "-c", 0, "WARNING:  YOU'RE  LETHAL  " .. tostring(hp) .. " HP  REMAINING")
			yOffset = yOffset + 10
		end

		local wpn = entity_get_player_weapon(me)
		local ammo = entity_get_prop(wpn, 'm_iClip1')	
		local is_taser = entity_get_classname(wpn) == "CWeaponTaser"

		if ammo == nil or is_taser then return end
		if ammo <= 2 and ammo > 0 then
			render_text(center[1], center[2] - 45 + yOffset, wR, wG, wB, warnAlpha, "-c", 0, "WARNING:  " .. ammo .. "  BULLETS  LEFT")
			yOffset = yOffset + 10
		end
		::skip::
	end
end

misc.breaker = {
	ground_ticks = 1, 
    end_time = 0,
}

misc.animation_breaker = function(self, cmd)
	local anims = menu_get(gui["Misc"].animations) --"legs", "freeze legs in air", "0 pitch land", "fakelag animation"
	local me = entity.get_local_player()

	if me ==  nil then return end
	
	local hs = menu_get(menu.refs.hs[1]) and menu_get(menu.refs.hs[2])
	local dt = menu_get(menu.refs.dt[1]) and menu_get(menu.refs.dt[2])

	if contains(anims, "Static legs") then
		local strafing = entity.get_prop(me, "m_bStrafing") == 1
		local random = math.random(1, 2)
		entity.set_prop(me, "m_flPoseParameter", 1, 0)
		if strafing then
			value = "Never slide"
		else
			value = "Always slide"
		end
		ui.set(menu.refs.leg_movement, value)
	end

	if contains(anims, "Static legs in air") then
		entity.set_prop(me, "m_flPoseParameter", 1, 6)
	end

	if contains(anims, "0 Pitch on land") then
		local on_ground = bit.band(entity.get_prop(me, "m_fFlags"), 1) == 1
		
		if on_ground then
			self.breaker.ground_ticks = self.breaker.ground_ticks + 1
		else
			self.breaker.ground_ticks = 0
			self.breaker.end_time = globals_curtime() + 1
		end 
		if self.breaker.ground_ticks > menu_get(menu.refs.fl_limit)+1 and self.breaker.end_time > globals_curtime() then
			entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
		end
	end
end

misc.moonwalk = function(self)
	local anims = menu_get(gui["Misc"].animations) --"legs", "freeze legs in air", "0 pitch land", "fakelag animation"
	local me = entity.get_local_player()

	if me ==  nil then return end

	if contains(anims, "Moonwalk") then
		entity.set_prop(me, "m_flPoseParameter", 0, 7) 
		ui.set(menu.refs.leg_movement, "Off")
	end
end

client_set_event_callback("net_update_end", function()

	misc:moonwalk()

end)

misc.killsay = function(self, e)
	local options = menu_get(gui["Misc"].kill_death_say)
	
	local on_hs = contains(options, "Headshot")
	local on_baim = contains(options, "Baim")

	local victim_id = e.userid
	local victim = client_userid_to_entindex(victim_id)

	local me = entity_get_local_player()

	local attacker_id = e.attacker
	local attacker = client_userid_to_entindex(attacker_id)

	if attacker == me then
		if e.headshot then
			if on_hs then
			killsay_nn = {
				'хс мартышка', 'хэдшот'
				}  
				ran_pick = math.random(1,9)
				client.exec("say " .. killsay_nn[ran_pick])
			end
		else
			if on_baim then
				killsay_nn = {
					'забаимлен гавно'
					}  
					ran_pick = math.random(1,7)
					client.exec("say " .. killsay_nn[ran_pick])	
			end
		end
	end
end

misc.old_time = 0
misc.reset_tag = false
misc.clantag_anim = {
	"",
	"a",
	"as",
	"ast",
	"astr",
	"astra",
	"astral",
	"astral.",
	"astral.l",
	"astral.lu",
	"astral.lua",
	"astral.lua",
	"astral.lua",
	"astral.lu",
	"astral.l",
	"astral.",
	"astral",
	"astra",
	"astr",
	"ast",
	"as",
	"a",
	"",
}

misc.astral_clantag = function(self)
	local clantag_on = menu_get(gui["Misc"].clantag) --"legs", "freeze legs in air", "0 pitch land", "fakelag animation"

	if clantag_on then
		local me = entity.get_local_player()

		if me ==  nil then return end
			
		local curtime = math.floor(globals_curtime() * 3)
		if self.old_time ~= curtime then
			client_set_clantag(self.clantag_anim[curtime % #self.clantag_anim+1])
		end

		self.old_time = curtime
			self.reset_tag = true
		else
		
		if self.reset_tag then
			client_set_clantag("")
			self.reset_tag = false
		end				
	end
end

ragebot.hp_lower = function(self, player, amount)
	local hp = entity_get_prop(player, "m_iHealth")
	return amount > hp
end

ragebot.prefers = function(self)
	local enemies = entity_get_players(true)
	local me = entity_get_local_player()

	if me == nil then entity.miss = {} return end

	for i=1, #enemies do
		local entindex = enemies[i]

		plist.set(entindex, "override prefer body aim", "-")

		if esp.player[entindex] == nil then
			esp.player[entindex] = {
				prefer = false,
				mode = nil
			}
		end

		if entity.miss[entindex] == nil then
			entity.miss[entindex] = {
				missed = 0,
			}
		end

		if entity.miss[entindex] then

			local prefer_options = menu_get(gui["Ragebot"].prefers_options)
			local height_check_on = contains(prefer_options, "Has height")
			local lethal_check_on = contains(prefer_options, "Is lethal")
			local high_vel_check_on = contains(prefer_options, "High velocity")
			local missed_check_on = contains(prefer_options, "After X misses")
			local hp_lower_than = contains(prefer_options, "HP lower than X")
			
			height_check = height_check_on and entity:has_height(entindex, me) or false

			lethal_check = lethal_check_on and entity:baim_lethal(entindex, me) or false

			high_vel_check = high_vel_check_on and entity:baim_high_vel(entindex) or false
			missed_check = missed_check_on and entity:after_missed(entindex, menu_get(gui["Ragebot"].prefers_after_x)) or false

			hp_check = hp_lower_than and ragebot:hp_lower(entindex, menu_get(gui["Ragebot"].prefers_lower_than)) or false

			local baim = height_check or lethal_check or high_vel_check or missed_check or hp_check

			esp.player[entindex].mode = nil

			if baim then
				esp.player[entindex].mode = "BODY"
				plist.set(entindex, "override prefer body aim", "Force")
				debug.prefer_baim = "rage:prefer_baim() -> L1556"
			else
				plist.set(entindex, "override prefer body aim", "-")
			end

			local safepoint_options = menu_get(gui["Ragebot"].sp_options)
			local height_check_sp_on = contains(safepoint_options, "Has height")
			local lethal_check_sp_on = contains(safepoint_options, "Is lethal")
			local high_vel_check_sp_on = contains(safepoint_options, "High velocity")
			local missed_check_sp_on = contains(safepoint_options, "After X misses")
			local hp_lower_than_sp = contains(safepoint_options, "HP lower than X")

			height_check_sp = height_check_sp_on and entity:has_height(entindex, me) or false

			lethal_check_sp = lethal_check_sp_on and entity:baim_lethal(entindex, me) or false

			high_vel_check_sp = high_vel_check_sp_on and entity:baim_high_vel(entindex) or false
			missed_check_sp = missed_check_sp_on and entity:after_missed(entindex, menu_get(gui["Ragebot"].sp_after_x)) or false

			hp_check_sp = hp_lower_than_sp and ragebot:hp_lower(entindex, menu_get(gui["Ragebot"].sp_lower_than)) or false

			local safepoint = height_check_sp or lethal_check_sp or high_vel_check_sp or missed_check_sp or hp_check_sp
			
			esp.player[entindex].prefer = safepoint or baim

			if safepoint then
				if baim then
					debug.prefer_baim = "rage:prefer_baim() -> L1556"
					esp.player[entindex].mode = "BODY+SP"
				else
					debug.prefer_sp = "rage:prefer_sp() -> L1605"
					esp.player[entindex].mode = "SP"
				end
				plist.set(entindex, "override safe point", "On")
			else
				plist.set(entindex, "override safe point", "-")
			end
		end
	end
end

client_set_event_callback("run_command", function()
	aa:run_command_check()
	ragebot:prefers()
end)


client_set_event_callback("round_start", function(e)
	entity.miss = {}
end)

client.register_esp_flag("{ASTRAL}", 225, 225, 225, function(ent)
	if menu_get(gui["Visuals"].indicators.esp) == "Flag" then
		if esp.player[ent] ~= nil then
			if esp.player[ent].prefer then
				if esp.player[ent].mode ~= nil then
					return true, esp.player[ent].mode
				end
			end
		end
	end
end)


client_set_event_callback("pre_render", function(cmd)

	misc:animation_breaker()

end)

client_set_event_callback("aim_fire", function()

	aa.on_shot.better_onshot = globals_curtime() + 1
	exploits.data.shot = globals_curtime()
end)

client_set_event_callback("setup_command", function(cmd)
	aa:handle(cmd)

	if cmd.in_attack == 1 then
		exploits.data.manual_shot = globals_curtime()
	end

	if menu_get(gui["Misc"].defensive) ~= "-" and aa.on_shot.better_onshot < globals_curtime() then
		if aa.n_cache.holding_nade then return end
		if menu_get(gui["Misc"].defensive) == "Always" then
			cmd.force_defensive = true
		elseif menu_get(gui["Misc"].defensive) == "Dynamic" then
			cmd.force_defensive = cmd.weaponselect ~= 0 or cmd.quick_stop
		else
			local me = entity_get_local_player()
			if me == nil then return end
			local threat = client.current_threat()
			if threat == nil then return end
			local can_hit = entity:is_baimable(threat, me) > 0
			if can_hit then
				cmd.force_defensive = true
			end
		end
	end
end)

client_set_event_callback("paint_ui", function()

	aa:better_onshot(cmd)

	if is_menu_open() then
		menu:visiblity()
		menu:animate(gui.astral, gui.label_aa)
	end

	local me = entity.get_local_player()
	visuals:logs()

	if me == nil then 
		aa.p_data.log = {}
		aa.on_shot.better_onshot = 0
		return
	end
	visuals:indicator()
	visuals:warnings()
	visuals:render_arrow()

	local dt = exploits:dt_charged()
	--print("Charged: " .. tostring(dt.charged) .. " percentage: " .. dt.percentage)

	--visuals:side_indicator()

	misc:astral_clantag()



	visuals:esp()

	--local enemies = entity_get_players(true)
	
	--screen = {client_screen_size()}
	--center = { screen[1] / 2, screen[2] / 2}

	--visuals:statics_kills(100, 450, 225, 65, "kill statics", enemies, {255, 255, 255, 255}, {0, 255, 0, 255}, "50%", "done in 3 days")

	visuals:debug()
	--visuals:active_builder()
end)

local logs = {
	hitgroup_names = {
		"generic",
		"head",
		"chest",
		"stomach",
		"left arm",
		"right arm",
		"left leg",
		"right leg",
		"neck",
		"?",
		"gear"
	},

	count_hits = {},
	count_miss = {},

	hit = function(self, event)
		local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
		--menu.f.hex_label({250, 155, 155})
		local clr = menu.f.hex_label({r, g, b})
		local w = "\aFFFFffff"
	
		local target = event.target
	
		local killed = entity_get_prop(target, "m_iHealth") == 0
		local txt = "failed to register"
		local console_txt = "failed to register"
	
		if self.count_hits[target] == nil then
			self.count_hits[target] = {
				total_hits = 1,
				total_dmg = event.damage
			}
		else
			self.count_hits[target].total_hits = self.count_hits[target].total_hits + 1
			self.count_hits[target].total_dmg = self.count_hits[target].total_dmg + event.damage
		end
	
	
		if killed then
			txt = 'Killed ' .. clr .. entity.get_player_name( target ) .. w .. " in " .. clr .. self.count_hits[target].total_hits .. w .. " hit(s) and did " .. clr .. self.count_hits[target].total_dmg .. w .. " total damage"
			console_txt = 'Killed ' .. entity.get_player_name( target ) .. " in " .. self.count_hits[target].total_hits .. " hit(s) and did " .. self.count_hits[target].total_dmg .. " total damage"

			self.count_hits[target] = nil
		else
			txt = 'Hit ' .. clr .. entity.get_player_name( target ) .. w .. " in " .. clr .. self.hitgroup_names[ event.hitgroup + 1 ] .. w .. " for " ..  clr .. event.damage .. w .. " damage"
			console_txt = 'Hit ' .. entity.get_player_name( target ) .. " in " .. self.hitgroup_names[ event.hitgroup + 1 ] .. " for " .. event.damage .. " damage"
		end
			visuals:add_to_log(txt, client.userid_to_entindex(target))
			print_log(console_txt, "Anti-Aim data")

		--	count_hits[event.target].hits = 0
		--end
	end,

	miss = function(self, event)
		local r, g, b, a = menu_get(gui["Visuals"].colors.clr_logstxt_1)
		--menu.f.hex_label({250, 155, 155})
		local clr = menu.f.hex_label({r, g, b})
		local w = "\aFFFFffff"

		local target = event.target
	
		local txt = 'Missed ' .. clr .. entity.get_player_name( target ) .. w .. " due to " .. clr .. event.reason .. w
		local console_txt = 'Missed ' .. entity.get_player_name( target ) .. " due to " .. event.reason

		txt = 'Missed ' .. clr .. entity.get_player_name( target ) .. w .. " due to " .. clr .. event.reason .. w

		visuals:add_to_log(txt, client.userid_to_entindex(target))
		print_log(console_txt, "Anti-Aim data")
		--	count_hits[event.target].hits = 0
		--end

	end,
}

client_set_event_callback("aim_miss", function(e)
	if entity.miss[e.target] == nil then 
		entity.miss[e.target] = {
			missed = 1,
		}
	else
		entity.miss[e.target].missed = entity.miss[e.target].missed + 1
	end
	local enabled = contains(menu_get(gui["Visuals"].indicators.additional), "Logs")
	if enabled then
		logs:miss(e)
	end

end)

client_set_event_callback("aim_hit", function(event)
	local enabled = contains(menu_get(gui["Visuals"].indicators.additional), "Logs")

	if enabled then
		logs:hit(event)
	end
end)


visuals:add_to_log(
	"Welcome to Astral!"
)

client_set_event_callback("shutdown", function()

	menu.reset(true)

end)

client_set_event_callback("bullet_impact", function(e)
	aa:antibf_impact(e)
end)

client_set_event_callback("player_death", function(e)
	local options = menu_get(gui["Misc"].kill_death_say)
	if contains(options, "Headshot") or contains(options, "Baim") then
		misc:killsay(e)
	end
	aa:antibf_death(e)

	local died = client_userid_to_entindex(e.userid)
	local attacker = client_userid_to_entindex(e.attacker)

	local me = entity_get_local_player()
	if me == died then
		entity.miss = {}
		aa.var.fs_true = false
	elseif attacker == me then
		if entity.miss[died] then
			entity.miss[died] = nil
		end
	end

	if aa.p_data.log[died] then
		if aa.p_data.log[died].side ~= nil then
			aa.p_data.log[died].should_update = true
			aa.p_data.log[died].should_update_yaw = false
			aa.p_data.log[died].side = nil
		end
	end
end)

client_set_event_callback("switch_team", function(e)
    aa:log_check()
end)

client_set_event_callback("player_disconnect", function(e)
    aa:log_check()
end)

menu_set_callback(menu.refs.fl_limit, function()
	if aa.on_shot.better_onshot + 5 > globals_curtime() then return end
	aa.on_shot.cache_fakelag = menu_get(menu.refs.fl_limit)
end)

menu_set_callback(gui["Anti-Aim"]["Default"].enable, function(active)

	if menu_get(gui["Anti-Aim"]["Default"].enable) then
		menu_set(gui.aa.enable, not active)
	end
end)

menu_set_callback(gui.aa.enable, function(active)

	if menu_get(gui.aa.enable) then
		menu_set(gui["Anti-Aim"]["Default"].enable, not active)
	end
end)