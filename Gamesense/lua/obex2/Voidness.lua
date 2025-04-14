-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Enable Allow unsafe scripts", 2)
local vector = require("vector") or error("Missing Vector",2)
local base64 = require("gamesense/base64")
local http = require("gamesense/http")
local clipboard = require("gamesense/clipboard") or error("Missing Clipboard")
local easing = require "gamesense/easing" or error("Missing Easing")
local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec
local ui_get = ui.get
local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entity_is_enemy = entity.is_enemy
local client_screen_size, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_frametime, renderer_gradient, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.screen_size, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.frametime, renderer.gradient, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible
local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end
local m_alpha = 0
local obex_data = obex_fetch and obex_fetch() or {username = 'weke', build = 'debug'}
local lastupd = "03.09.2022"
local upper_case = obex_data.username:upper()
local lower_case = obex_data.username:lower()
local skeetclantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')

-----------------------------
--LOGGER
-----------------------------

http.get("https://fakelag.com/vnlog", function(essa)
    if essa then
	end
end)

-----------------------------
--WELCOME MESSAGE
-----------------------------

print("---------------------------------")
print("Welcome to voidness " .. obex_data.username)
print("You're currently using: " .. obex_data.build)
print("Last updated: " .. lastupd)
print("---------------------------------")

local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "enable \a9FCA2BFFvoidness\aFFFFFFC9.systems")

local anim = { }

local animationum = {}

animationum.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

-----------------------------
--REFS
-----------------------------

local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
	fl_varia = ui.reference("AA", "Fake lag", "Variance"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
	quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
	yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	os = {ui.reference("AA", "Other", "On shot anti-aim")},
	slow = {ui.reference("AA", "Other", "Slow motion")},
	dt = {ui.reference("RAGE", "Other", "Double tap")},
	ps = {ui.reference("RAGE", "Other", "Double tap")},
	fakelag = {ui.reference("AA", "Fake lag", "Limit")},
	dt_enable, dt_hotkey = ui.reference("RAGE", "Other", "Double tap")
}

-----------------------------
--ON LOAD
-----------------------------

local function on_load()
	ui.set(ref.yawjitter[1], "off")
	ui.set(ref.yawjitter[2], 0)
	ui.set(ref.bodyyaw[1], "static")
	ui.set(ref.bodyyaw[2], -180)
	ui.set(ref.yaw[1], "180")
	ui.set(ref.yaw[2], -90)
	ui.set(ref.fakeyawlimit, 60)
end

on_load()

local aa_init = { }

-----------------------------
--VARS
-----------------------------

local var = {
	p_states = {"standing", "moving", "slowwalking", "in-air", "ducking", "air-ducking", "FL"},
	s_to_int = {["air-ducking"] = 6,["FL"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalking"] = 3, ["in-air"] = 4, ["ducking"] = 5},
	player_states = {"S", "M", "SW", "A", "C", "AD", "FL"},
	state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
	p_state = 1
}

local function contains(table, value)

	if table == nil then
		return false
	end
	
	table = ui.get(table)
	for i=0, #table do
		if table[i] == value then
			return true
		end
	end
	return false
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-----------------------------
--AA MENU
-----------------------------

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	heyl1 = ui.new_label("AA", "Anti-aimbot angles", "         \a494949FF------------------------------"),
	heylabel = ui.new_label("AA", "Anti-aimbot angles", "            Welcome to \a9FCA2BFFvoidness"),
	heylabel2 = ui.new_label("AA", "Anti-aimbot angles", "         \a9FCA2BFFLast update :\aFFFFFFC9 " .. lastupd),
	heyl2 = ui.new_label("AA", "Anti-aimbot angles", "         \a494949FF------------------------------"),
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "lua \a9FCA2BFFsection", "anti-aimbot", "visuals", "miscellaneous"),
	heyl3 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- presets", "jitter", "jitter2", "experimental", "exploit"),
	preset_warning = ui.new_label("AA", "Anti-aimbot angles", "\aFF4700FF⚠️ Turn on 'Edge Yaw' and 'Fake Peek'"),
	preset_warning1 = ui.new_label("AA", "Anti-aimbot angles", "\aFF4700FFto 'Always on' !"),
	aalabelextra = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles","\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- anti-\a9FCA2BFFbruteforce"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	legit_e_key = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- \a9FCA2BFFlegit \aFFFFFFC9anti-aimbot on \a9FCA2BFF'e'"),
	keyaalabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- free\a9FCA2BFFstanding"),
	edgey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- edge\a9FCA2BFFyaw"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- manual anti-aimbot - \a9FCA2BFFleft"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- manual anti-aimbot - \a9FCA2BFFright"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾aa⏌ \aFFFFFFC9- manual anti-aimbot - \a9FCA2BFFforward"),
	customaalabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "custom \a9FCA2BFFanti-aimbot \aFFFFFFC9builder"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "anti-aimbot \a9FCA2BFFstates", "standing", "moving", "slowwalking", "in-air", "ducking", "air-ducking"),
}

-----------------------------
--VISUALS MENU
-----------------------------

local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- \a9FCA2BFFmain \aFFFFFFC9color")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 159, 202, 43, 255)
local vislabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- crosshair \a9FCA2BFFindicators")
local inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "\a9FCA2BFFindicators \aFFFFFFC9style", { "voidness", "ephemeral", "ephemeral right", "acatel"})
local manaa_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- \a9FCA2BFFcrosshair \aFFFFFFC9anti-aimbot \a9FCA2BFFarrows")
local arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "arrow \a9FCA2BFFstyle", { "default", "manual", "desync" })
local watermarko = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- void\a9FCA2BFFness \aFFFFFFC9water\a9FCA2BFFmark")
local scopelabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local master_switch = ui.new_checkbox("AA", "Anti-aimbot angles", '\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- scope \a9FCA2BFFcustomization')
local color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", '\n scope_lines_color_picker', 255, 255, 255, 255)
local overlay_position = ui.new_slider("AA", "Anti-aimbot angles", 'initial \a9FCA2BFFposition', 0, 500, 0)
local overlay_offset = ui.new_slider("AA", "Anti-aimbot angles", 'lines \a9FCA2BFFoffset', 0, 500, 40)
local fade_time = ui.new_slider("AA", "Anti-aimbot angles", 'fade \a9FCA2BFFanimation \aFFFFFFC9speed', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' })
local othlabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local enable_def = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- tickbase spam \a9FCA2BFFwarning")
local trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- trash\a9FCA2BFFtalk")
local clantagspam = ui.new_checkbox('AA', 'Anti-aimbot angles', '\a9FCA2BFF⎾vis⏌ \aFFFFFFC9- clan tag\a9FCA2BFF spammer')
local legszz = ui.new_multiselect("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾misc⏌ \aFFFFFFC9- animation \a9FCA2BFFbreakers", "static legs in-air", "leg breaker")
local vislabelleg = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾misc⏌ \aFFFFFFC9- \a9FCA2BFFanti \aFFFFFFC9knife \a9FCA2BFFbackstab")
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "activation \a9FCA2BFFdistance",0,500,310,true)
local fllabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local expflclick = ui.new_checkbox("AA", "Anti-aimbot angles", "\a9FCA2BFF⎾misc⏌ \aFFFFFFC9- \a9FCA2BFF16-60 \aFFFFFFC9ticks fakelag")
local expfl = ui.new_combobox("AA", "Anti-aimbot angles", "value \a9FCA2BFFselection", { "16", "25", "40", "60"})
local erlabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF")

-----------------------------
--AA BUILDER MENU
-----------------------------

for i=1, 7 do
	aa_init[i] = {
		aabuilderenable =  ui.new_checkbox("AA", "Anti-aimbot angles", "enable | ".. ""..var.p_states[i].." \a9FCA2BFFanti-aimbot \aFFFFFFC9state"),
		enablelabelu = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aayawleft = ui.new_slider("AA", "Anti-aimbot angles", ""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFLeft\aFFFFFFC9]\n", -180, 180, 0),
		aayawright = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFRight\aFFFFFFC9]\n", -180, 180, 0),
		enablelabelu1 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aayawjitter = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFJitter\aFFFFFFC9]\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		aayawjitterslider = ui.new_slider("AA", "Anti-aimbot angles","\n" .. var.p_states[i], -180, 180, 0),
		enablelabelu2 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aayawbody = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFBody\aFFFFFFC9]\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		aayawstatic = ui.new_slider("AA", "Anti-aimbot angles","\n", -180, 180, 0),
		enablelabelu3 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aafakeside = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFFake Limit Side\aFFFFFFC9]\n" .. var.p_states[i], { "left", "right" }),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","\n", 0, 60, 60, true,"°"),
		fakeyawlimitri = ui.new_slider("AA", "Anti-aimbot angles","\n", 0, 60, 60, true,"°"),
		enablelabelu4 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aayawroll = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFRoll\aFFFFFFC9]\n".. var.p_states[i], -50, 50, 0, true, "°"),
		enablelabelu5 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
		aayawantibrute =  ui.new_checkbox("AA", "Anti-aimbot angles", ""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFAnti-Bruteforce\aFFFFFFC9]"),
		aayawavoidoverlap =  ui.new_checkbox("AA", "Anti-aimbot angles", ""..var.p_states[i].." | Yaw \aFFFFFFC9[\a9FCA2BFFAvoid Overlap\aFFFFFFC9]"),
		enablelabelu6 = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------"),
	}
end

-----------------------------
--OPPOSITE FIX AND SHIT
-----------------------------

local function oppositefix(c)
	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end

local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

-----------------------------
--OG MENU
-----------------------------

local function set_og_menu(state)
	ui.set_visible(ref.pitch, state)
	ui.set_visible(ref.roll, state)
	ui.set_visible(ref.yawbase, state)
	ui.set_visible(ref.yaw[1], state)
	ui.set_visible(ref.yaw[2], state)
	ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.yawjitter[2], state)
	ui.set_visible(ref.bodyyaw[1], state)
	ui.set_visible(ref.bodyyaw[2], state)
	ui.set_visible(ref.freestand[1], state)
	ui.set_visible(ref.freestand[2], state)
	ui.set_visible(ref.fakeyawlimit, state)
	ui.set_visible(ref.fsbodyyaw, state)
	ui.set_visible(ref.edgeyaw, state)
end

-----------------------------
--SET VISIBLE FOR VN MENU
-----------------------------

local function set_lua_menu()
	var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
	local is_aa = ui.get(aa_init[0].lua_select) == "anti-aimbot"
	local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "miscellaneous"
	local is_knife = ui.get(anti_knife)
	local is_enabled = ui.get(lua_enable)

	if is_enabled then
	    ui.set_visible(aa_init[0].heyl1, true)
		ui.set_visible(aa_init[0].heylabel, true)
		ui.set_visible(aa_init[0].heylabel2, true)
		ui.set_visible(aa_init[0].heyl2, true)
		ui.set_visible(aa_init[0].lua_select, true)
		ui.set_visible(aa_init[0].heyl3, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].heyl1, false)
		ui.set_visible(aa_init[0].heylabel, false)
		ui.set_visible(aa_init[0].heylabel2, false)
		ui.set_visible(aa_init[0].heyl2, false)
		ui.set_visible(aa_init[0].lua_select, false)
		ui.set_visible(aa_init[0].heyl3, false)
		set_og_menu(true)
	end

	if is_misc and is_enabled then
		ui.set_visible(legszz, true)
		ui.set_visible(vislabelleg, true)
		ui.set_visible(anti_knife, true)
		ui.set_visible(fllabel, true)
		ui.set_visible(expflclick, true)
		ui.set_visible(erlabel, true)
		if is_knife then
			ui.set_visible(knife_distance, true)
		else
			ui.set_visible(knife_distance, false)
		end
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(knife_distance, false)
		ui.set_visible(legszz, false)
		ui.set_visible(vislabelleg, false)
		ui.set_visible(fllabel, false)
		ui.set_visible(expflclick, false)
		ui.set_visible(erlabel, false)
	end

	if ui.get(aa_init[0].presets) == "exploit" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].preset_warning, true)
		ui.set_visible(aa_init[0].preset_warning1, true)
	else
		ui.set_visible(aa_init[0].preset_warning, false)
		ui.set_visible(aa_init[0].preset_warning1, false)
	end

	if ui.get(aa_init[0].presets) == "dynamic" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].legit_e_key, true)
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		ui.set_visible(aa_init[0].fs, true)
		ui.set_visible(aa_init[0].edgey, true)
		ui.set_visible(aa_init[0].aalabelextra, true)
		ui.set_visible(aa_init[0].keyaalabel, true)
		ui.set_visible(aa_init[0].customaalabel, true)
	else
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].fs, false)
		ui.set_visible(aa_init[0].edgey, false)
		ui.set_visible(aa_init[0].aalabelextra, false)
		ui.set_visible(aa_init[0].keyaalabel, false)
		ui.set_visible(aa_init[0].customaalabel, false)
	end

	if is_vis and is_enabled then
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(vislabel, true)
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(enable_def, true)
		ui.set_visible(trashtalk, true)
		ui.set_visible(master_switch, true)
		ui.set_visible(color_picker, true)
		ui.set_visible(overlay_position, true)
		ui.set_visible(overlay_offset, true)
		ui.set_visible(fade_time, true)
		ui.set_visible(scopelabel, true)
		ui.set_visible(othlabel, true)
		ui.set_visible(manaa_inds, true)
		ui.set_visible(watermarko, true)
		ui.set_visible(clantagspam, true)
	else
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(vislabel, false)
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(enable_def, false)
		ui.set_visible(trashtalk, false)
		ui.set_visible(master_switch, false)
		ui.set_visible(color_picker, false)
		ui.set_visible(overlay_position, false)
		ui.set_visible(overlay_offset, false)
		ui.set_visible(fade_time, false)
		ui.set_visible(scopelabel, false)
		ui.set_visible(othlabel, false)
		ui.set_visible(manaa_inds, false)
		ui.set_visible(watermarko, false)
		ui.set_visible(clantagspam, false)
	end

	if ui.get(crosshair_inds) and is_vis and is_enabled then
		ui.set_visible(inds_selct, true)
	else
		ui.set_visible(inds_selct, false)
	end

    if ui.get(manaa_inds) and is_vis and is_enabled then
		ui.set_visible(arrw_selct, true)
	else
		ui.set_visible(arrw_selct, false)
	end

	if ui.get(expflclick) and is_misc and is_enabled then
		ui.set_visible(expfl, true)
	else
		ui.set_visible(expfl, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_abf, true)
		ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].presets, true)
	else
		ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].presets, false)
		ui.set_visible(aa_init[0].aa_builder, false)
	end
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[i].aabuilderenable,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].aabuilderenable) then
			    ui.set_visible(aa_init[i].enablelabelu,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawleft,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawright,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu1,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu2,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu3,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu4,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu5,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu6,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawjitterslider,var.active_i == i and ui.get(aa_init[var.active_i].aayawjitter) ~= "off" and is_aa)

				ui.set_visible(aa_init[i].aayawbody, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawantibrute, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aayawstatic, var.active_i == i and ui.get(aa_init[i].aayawbody) ~= "off" and ui.get(aa_init[i].aayawbody) ~= "opposite" and is_aa)

				ui.set_visible(aa_init[i].aafakeside,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and ui.get(aa_init[i].aafakeside) == "left" and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitri,var.active_i == i and ui.get(aa_init[i].aafakeside) == "right" and is_aa)
				ui.set_visible(aa_init[i].aayawroll, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawavoidoverlap, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].enablelabelu,false)
				ui.set_visible(aa_init[i].enablelabelu1,false)
			    ui.set_visible(aa_init[i].enablelabelu2,false)
			    ui.set_visible(aa_init[i].enablelabelu3,false)
			    ui.set_visible(aa_init[i].enablelabelu4,false)
			    ui.set_visible(aa_init[i].enablelabelu5,false)
			    ui.set_visible(aa_init[i].enablelabelu6,false)
				ui.set_visible(aa_init[i].aayawleft,false)
				ui.set_visible(aa_init[i].aayawright,false)
				ui.set_visible(aa_init[i].aayawjitter,false)
				ui.set_visible(aa_init[i].aayawjitterslider,false)

				ui.set_visible(aa_init[i].aayawantibrute, false)
	
				ui.set_visible(aa_init[i].aayawbody,false)
	
				ui.set_visible(aa_init[i].aayawstatic,false)
	
				ui.set_visible(aa_init[i].aafakeside,false)
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitri,false)
				ui.set_visible(aa_init[i].aayawroll,false)
				ui.set_visible(aa_init[i].aayawavoidoverlap,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].aabuilderenable,false)
			ui.set_visible(aa_init[i].enablelabelu,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].aayawleft,false)
			ui.set_visible(aa_init[i].aayawright,false)
			ui.set_visible(aa_init[i].enablelabelu1,false)
			ui.set_visible(aa_init[i].enablelabelu2,false)
			ui.set_visible(aa_init[i].enablelabelu3,false)
			ui.set_visible(aa_init[i].enablelabelu4,false)
			ui.set_visible(aa_init[i].enablelabelu5,false)
			ui.set_visible(aa_init[i].enablelabelu6,false)
			ui.set_visible(aa_init[i].aayawjitter,false)
			ui.set_visible(aa_init[i].aayawjitterslider,false)

			ui.set_visible(aa_init[i].aafakeside,false)
			ui.set_visible(aa_init[i].aayawbody,false)

			ui.set_visible(aa_init[i].aayawantibrute, false)

			ui.set_visible(aa_init[i].aayawstatic,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitri,false)
			ui.set_visible(aa_init[i].aayawroll,false)
			ui.set_visible(aa_init[i].aayawavoidoverlap,false)
		end
	end
end

-----------------------------
--ANTI KNIFE
-----------------------------

misc = {}
misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

misc.anti_knife = function()
    if ui.get(anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(knife_distance) then
                ui.set(yaw_slider,180)
                ui.set(pitch,"Off")
            end
        end
    end
end

client.set_event_callback("setup_command",misc.anti_knife)

-----------------------------
--ANTIBRUTE AND SHIT
-----------------------------

local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	best_angle = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
	hit_reverse = { }
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0
local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end

local function get_best_angle()
	local me = entity.get_local_player()

	if best_enemy == nil then return end

	local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
	if origin_z == nil then return end
	origin_z = origin_z + 64

	local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
	
	local lx,ly,lz = client.eye_position()
	local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0) 
	local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
			
	if head_dmg ~= nil and head_dmg > 1 then
		brute.can_hit_head = 1
	else
		brute.can_hit_head = 0
	end

	local view_x, view_y, roll = client.camera_angles()
	
	local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

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
			
	local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
	local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

	local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
	local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)
end

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	if bit.band(flags, 1) == 0 then
		return true
	end
	
	return false
end

local ChokedCommands = 0

local aa = {
	ignore = false,
	manaa = 0,
	input = 0,
}
local lastdt = 0

local function on_setup_command(c)
	--run_shit(c)

	local plocal = entity.get_local_player()

	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")

	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
	local lp_vel = get_velocity(entity.get_local_player())
	local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

	local wpn = entity.get_player_weapon(plocal)
	local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")

	local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local state = "AFK"
	
-----------------------------
--STATES
-----------------------------

	if not is_dt and not is_os and not p_still and ui.get(aa_init[7].aabuilderenable) and ui.get(aa_init[0].aa_builder) then
		var.p_state = 7
	elseif c.in_duck == 1 and on_ground then
		var.p_state = 5
	elseif c.in_duck == 1 and not on_ground then
		var.p_state = 6
	elseif not on_ground then
		var.p_state = 4
	elseif p_slow then
		var.p_state = 3
	elseif p_still then
		var.p_state = 1
	elseif not p_still then
		var.p_state = 2
	end

	if var.p_state == 6 then
		c.roll = ui.get(aa_init[6].aayawroll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[1].aayawroll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[7].aayawroll)
	elseif var.p_state == 2 then
		c.roll = ui.get(aa_init[2].aayawroll)
	elseif var.p_state == 3 then
		c.roll = ui.get(aa_init[3].aayawroll)
	elseif var.p_state == 4 then
		c.roll = ui.get(aa_init[4].aayawroll)
	elseif var.p_state == 5 then
		c.roll = ui.get(aa_init[5].aayawroll)
	end

	local weaponn = entity.get_player_weapon()
	if ui.get(aa_init[0].legit_e_key) then
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if c.in_attack == 1 then
				c.in_attack = 0 
				c.in_use = 1
			end
		else
			if c.chokedcommands == 0 then
				c.in_use = 0
			end
		end
	end

-----------------------------
--NEW FAKELAG
-----------------------------

if not ui.get(expflclick) then
        ui.set(ref.maxprocticks, 16)
   elseif ui.get(expfl) == "16" then
        ui.set(ref.maxprocticks, 17)
		ui.set(ref.fl_limit, 16)
   elseif ui.get(expfl) == "25" then
		ui.set(ref.maxprocticks, 26)
		ui.set(ref.fl_limit, 25)
   elseif ui.get(expfl) == "40" then
		ui.set(ref.maxprocticks, 41)
		ui.set(ref.fl_limit, 40)
   elseif ui.get(expfl) == "60" then
		ui.set(ref.maxprocticks, 61)
		ui.set(ref.fl_limit, 60)
	end
end

-----------------------------
--ANIM BREAKERS
-----------------------------

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

client.set_event_callback("pre_render", function ()

	if not entity.is_alive(entity.get_local_player()) then return end

	if table_contains(ui.get(legszz),"static legs in-air") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

	local legs_types = {[1] = "Off", [2] = "Always slide" , [3] = "Never slide"}

	if table_contains(ui.get(legszz),"leg breaker") then
		ui.set(antiaim.leg_movement, legs_types[2])
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 2, math.random(0,1)) 
	end

end)

client.set_event_callback("setup_command", function(c)

-----------------------------
--BINDS
-----------------------------

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local localp = entity.get_local_player()

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

	ui.set(aa_init[0].manual_left, "On hotkey")
	ui.set(aa_init[0].manual_right, "On hotkey")

	if ui.get(aa_init[0].fs) then
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always on")
	else
		ui.set(ref.freestand[1], "-")
		ui.set(ref.freestand[2], "On hotkey")
	end

	if ui.get(aa_init[0].edgey) then
        ui.set(ref.edgeyaw, true)
	else
        ui.set(ref.edgeyaw, false)
	end

	local l = 1

-----------------------------
--MANUAL AA
-----------------------------

	if aa.input + 0.22 < globals.curtime() then
		if aa.manaa == 0 then
			if ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 1 then
			if ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 2 then
			if ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 3 then
			if ui.get(aa_init[0].manual_forward) then
				aa.manaa = 0
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			end
		end
	end
	if aa.manaa == 1 or aa.manaa == 2 or aa.manaa == 3 then
		aa.ignore = true
		if aa.manaa == 1 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], -90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 2 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 3 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "at targets")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 180)
			ui.set(ref.fakeyawlimit, 60)
		end
	else
		aa.ignore = false
		ui.set(ref.yawbase, "at targets")
	end

-----------------------------
--ANTIAIM
-----------------------------

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aayawstatic))
		ui.set(byaw, ui.get(aa_init[var.p_state].aayawbody))
		if ui.get(aa_init[var.p_state].aabuilderenable) and ui.get(aa_init[0].aa_builder) then
            if var.p_state == 6 then
                ui.set(ref.pitch, "Default")
            else
                ui.set(ref.pitch, "Minimal")
            end
			ui.set(jyaw, ui.get(aa_init[var.p_state].aayawjitter))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].aayawjitterslider))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].aayawleft) or ui.get(aa_init[var.p_state].aayawright)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

			if bodyyaw > 0 then
				ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitri))
			elseif bodyyaw < 0 then
				ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
			end
		else
			ui.set(ref.pitch, "Minimal")
			if ui.get(aa_init[0].presets) == "jitter" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 28)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 44)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -8 or 8))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 75)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 15))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 70)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 8 or -3))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			elseif ui.get(aa_init[0].presets) == "jitter2" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 49)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 40)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 60)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 25)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 2))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 23)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 25)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 2))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			elseif ui.get(aa_init[0].presets) == "experimental" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Offset")
					ui.set(ref.yawjitter[2], math.random(-25,90))
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			elseif ui.get(aa_init[0].presets) == "exploit" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Off")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			end
		end
	end
end)

-----------------------------
--BRUTE2
-----------------------------

local function brute_impact(e)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then

		brute.last_miss = globals.curtime()
		if brute.misses[shooter] == nil then
			brute.misses[shooter] = 1 
			brute.misses_ind[shooter] = 1
		elseif brute.misses[shooter] >= 2 then
			brute.misses[shooter] = nil
		else
			brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
			brute.misses[shooter] = brute.misses[shooter] + 1
		end
	end
end

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end

local function brute_death(e)
	
	local victim_id = e.userid
	local victim = client.userid_to_entindex(victim_id)

	if victim ~= entity.get_local_player() then return end

	local attacker_id = e.attacker
	local attacker = client.userid_to_entindex(attacker_id)

	if not entity.is_enemy(attacker) then return end

	if not e.headshot then return end

	if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
		if brute.hit_reverse[attacker] == nil then
			brute.hit_reverse[attacker] = true
		else
			brute.hit_reverse[attacker] = nil
		end
	end
end

local value = 0
local once1 = false
local once2 = false
local dt_a = 0
local dt_y = 45
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 45
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 45
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0

local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end

local was_on_ground = false

-----------------------------
--INDICATORS
-----------------------------

local function renderer_shit(x, y, w, r, g, b, a, edge_h)
	if edge_h == nil then edge_h = 0 end
	local local_player = entity.get_local_player()
	local velocity = string.format('%.2f', vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d())		
	local pos_x, pos_y, pos_z = entity.get_origin(local_player)
	renderer.rectangle(x+1, y-2, w-5, 2.5, 15, 15, 15, 45) --
	renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 45) --
	renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 45) --
	renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 45) -- 
	renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 45) --
	renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 45) -- 
	renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 45) -- 
	renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 45) --
	renderer.rectangle(x+2, y, w-5, 16, 0, 0, 0, 65) ---
	local me = entity.get_local_player()
	local desync_type = antiaim_funcs.get_overlap(float)
	local r,g,b = ui.get(main_clr)
end

-----------------------------
--WATERMARK
-----------------------------

local function watermark()
	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d'):format(h, m)

	local latency = client.latency()*1000

	local latency_text = ('  %d'):format(latency) or ''

	local czit = 'void\a9FCA2BFFness\aFFFFFFFF.sys'

	local wersja = obex_data.build

	local nazwa = obex_data.username

	local ticki = "64tick"

	local r,g,b = ui.get(main_clr)

	text = (" %s ~ \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFFdelay:%sms \a5b5d63FF| \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFF%s "):format(czit, wersja, nazwa, latency_text, ticki, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10

	if ui.get(watermarko) then
		renderer_shit(x, y, w, 65, 65, 65, 180, 2)
		renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
	else
		renderer.text(x+160, y + 1, 255, 255, 255, 255, '', 0, "")
	end
end

client.set_event_callback("paint", watermark)

-----------------------------
--CROSSHAIR INDS
-----------------------------

animationum.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

linear_interpolation = function(start, _end, time)
	return (_end - start) * time + start
end

clamp = function(value, minimum, maximum)
	if minimum > maximum then
		return math.min(math.max(value, maximum), minimum)
	else
		return math.min(math.max(value, minimum), maximum)
	end
end

local function clamp2(val, min_val, max_val)
	return math.max(min_val, math.min(max_val, val))
end

lerp2 = function(start, _end, time)
	time = time or 0.005;
	time = clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
	local a = linear_interpolation(start, _end, time)
	if _end == 0.0 and a < 0.01 and a > -0.01 then
		a = 0.0
	elseif _end == 1.0 and a < 1.01 and a > 0.99 then
		a = 1.0
	end
	return a
end

local testx = 0
local aaa = 0
local lele = 0

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

local function draw()
	local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2}

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(main_clr)

	local x, y = client.screen_size()

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(aa_init[0].fs)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=167, 252, 121,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
	--sine_in
	value = value + globals.frametime() * 9

	local _, y2 = client.screen_size()

	local state = "MOVING"

	--states [for searching]
	if ui.get(aa_init[0].aa_stc_tillhit) then
		if brute.can_hit == 0 then
			state = "INDEXED"
		end
	else
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 and ui.get(aa_init[0].aa_builder) then
			state = "FL"
		elseif var.p_state == 5 then
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "AIRDUCK"
		elseif var.p_state == 4 then
			state = "AIR"
		elseif var.p_state == 3 then
			state = "SLOWWALK"
		elseif var.p_state == 1 then
			state = "STAND"
		elseif var.p_state == 2 then
			state = "MOVE"
		end
	end

	local realtime = globals.realtime() % 3
	local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180

	local exp_ind = ""

	if is_dt then
		exp_ind = "DT"
	elseif is_os then
		exp_ind = "HS"
	end

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local flag = "c-"
	local ting = 0
	local testting = 0

	--animation shit

	if is_dt or is_os then
		n4_x = animationum.lerp(n4_x, 8, globals.frametime() * 8)
	else
		n4_x = animationum.lerp(n4_x, -1, globals.frametime() * 8)
	end

	if act then
		flag = "-"
		ting = 23
		testting = 11

		testx = animationum.lerp(testx, 30, globals.frametime() * 5)

		n2_x = animationum.lerp(n2_x, 11, globals.frametime() * 5)

		n3_x = animationum.lerp(n3_x, 5, globals.frametime() * 5)

	else
		testx = animationum.lerp(testx, 0, globals.frametime() * 5)

		n2_x = animationum.lerp(n2_x, -1, globals.frametime() * 5)

		n3_x = animationum.lerp(n3_x, 0, globals.frametime() * 5)

		flag = "c-"
		ting = 28
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if ui.get(inds_selct) == "ephemeral" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + os_y+ 13, dr, dg, db, os_a, "c-", os_w, "OS ")
		end
		renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + dt_y+ 13, dr, dg, db, dt_a, "c-", dt_w, "DT")

		renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 13, 255, 255, 255, fs_a, "c-", fs_w, "FS")

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2-30 + testx, y / 2 + 25, mr,mg,mb, 255, "-", 0, 'VOIDNESS')
		renderer.text(x / 2+7 + testx, y / 2 + 25, 255,255,255, alpha, "-", 0, '' .. obex_data.build:upper())
		renderer.text(x / 2 + n2_x - testting, y / 2 + ting + 11 , 255, 255, 255, 180, flag, 0, state)
	end

	if ui.get(inds_selct) == "ephemeral right" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 + 40 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			renderer.text(x / 2 + 40 + n3_x, y2 / 2 + os_y+ 15, dr, dg, db, os_a, "c-", os_w, "OS ")
		end
		renderer.text(x / 2 + 40 + n3_x, y2 / 2 + dt_y+ 15, dr, dg, db, dt_a, "c-", dt_w, "DT")

		renderer.text(x / 2 + 40 + fs_x + n3_x, y2 / 2 + fs_y+ 15, 255, 255, 255, fs_a, "c-", fs_w, "FS")

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2 + 11, y / 2 + 27, mr,mg,mb, 255, "-", 0, 'VOIDNESS')
		renderer.text(x / 2 + 48, y / 2 + 27, 255,255,255, alpha, "-", 0, '' .. obex_data.build:upper())
		renderer.text(x / 2 + 40 + n2_x - testting, y / 2 + ting + 13 , 255, 255, 255, 180, flag, 0, state)
	end

	local localp = entity.get_local_player()

	if ui.get(inds_selct) == "acatel" and ui.get(crosshair_inds) then
		if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
		renderer.text(center[1] + 4, center[2] + 50, 255,255,255,255,  "-c", nil, "VOIDNESS")
		renderer.text(center[1] + 35, center[2] + 50, 255,255,255, alpha, "-c", nil, "BETA")
		renderer.text(center[1] + 6, center[2] + 59, 120, 169, 255, 255, "-c", nil, "FAKE   YAW:")
		if bodyyaw > 0 then
			renderer.text(center[1] + 30, center[2] + 59, 255,255,255,255, "-c", 0, "L")
		else
			renderer.text(center[1] + 30, center[2] + 59, 255,255,255,255, "-c", 0, "R")
		end
		if ui.get(ref.forcebaim) then
			renderer.text(center[1] - 4, center[2] + 68, 255,255,255, alpha, "-c", nil, "BAIM")
		else
			renderer.text(center[1] - 4, center[2] + 68, 255,255,255, 170, "-c", nil, "BAIM")
		end
		if is_sp then
			renderer.text(center[1] + 12, center[2] + 68, 255,255,255, alpha, "-c", nil, "SP")
		else
			renderer.text(center[1] + 12, center[2] + 68, 255,255,255, 170, "-c", nil, "SP")
		end
		if ui.get(ref.freestand[2]) then
			renderer.text(center[1] + 24, center[2] + 68, 255,255,255, alpha, "-c", nil, "FS")
		else
			renderer.text(center[1] + 24, center[2] + 68, 255,255,255, 170, "-c", nil, "FS")
		end  
     end

	if ui.get(inds_selct) == "voidness" and ui.get(crosshair_inds) then
		if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
		renderer.text(center[1] + 17, center[2] + 25, mr,mg,mb,255,  "-c", nil, "VOIDNESS")
		renderer.text(center[1] + 46, center[2] + 25, 255,255,255, alpha, "-c", nil, "BETA")
		renderer.text(center[1] + 28, center[2] + 39, 255,255,255,180, "-c", nil, state)
		renderer.text(center[1] + 27, center[2] + 31, 255,255,255,255,  "-c", nil, "·")
		renderer.text(center[1] + 16, center[2] + 28, 255,255,255,100, "-c", 0, "⏤⏤")
		renderer.text(center[1] + 41, center[2] + 28, 255,255,255,100, "-c", 0, "⏤⏤")
		if bodyyaw > 0 then
			renderer.text(center[1] + 16, center[2] + 28, mr,mg,mb,255, "-c", 0, "⏤⏤")
		else
            renderer.text(center[1] + 41, center[2] + 28, mr,mg,mb,255, "-c", 0, "⏤⏤")
		end
		if ui.get(ref.forcebaim) then
			renderer.text(center[1] + 18, center[2] + 59, 255,255,255,255, "-c", nil, "BAIM")
		else
			renderer.text(center[1] + 18, center[2] + 59, 255,255,255, 170, "-c", nil, "BAIM")
		end
		if is_qp then
		    renderer.text(center[1] + 37, center[2] + 59, 255,255,255,255, "-c", nil, "QPA")
		else
		    renderer.text(center[1] + 37, center[2] + 59, 255,255,255, 170, "-c", nil, "QPA")
		end
		if is_dt then
		    renderer.text(center[1] + 34, center[2] + 49, 255,255,255,255, "-c", nil, "DT")
		else
		    renderer.text(center[1] + 34, center[2] + 49, 255,255,255, 170, "-c", nil, "DT")
		end
		if is_os then
		    renderer.text(center[1] + 47, center[2] + 49, 255,255,255,255, "-c", nil, "OS")
		else
		    renderer.text(center[1] + 47, center[2] + 49, 255,255,255, 170, "-c", nil, "OS")
		end
		if is_sp then
			renderer.text(center[1] + 10, center[2] + 49, 255,255,255,255, "-c", nil, "SP")
		else
			renderer.text(center[1] + 10, center[2] + 49, 255,255,255, 170, "-c", nil, "SP")
		end
		if ui.get(ref.freestand[2]) then
			renderer.text(center[1] + 22, center[2] + 49, 255,255,255,255, "-c", nil, "FS")
		else
			renderer.text(center[1] + 22, center[2] + 49, 255,255,255, 170, "-c", nil, "FS")
		end  
	end

-----------------------------
--CROSSHAIR ARROWS
-----------------------------
	
	if ui.get(arrw_selct) == "default" and ui.get(manaa_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		aa.manaa == 2 and mr or 25, 
		aa.manaa == 2 and mg or 25, 
		aa.manaa == 2 and mb or 25, 
		aa.manaa == 2 and ma or 160)

		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		aa.manaa == 1 and mr or 25, 
		aa.manaa == 1 and mg or 25, 
		aa.manaa == 1 and mb or 25, 
		aa.manaa == 1 and ma or 160)
	
		renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		bodyyaw < -10 and mr or 25,
		bodyyaw < -10 and mg or 25,
		bodyyaw < -10 and mb or 25,
		bodyyaw < -10 and ma or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		bodyyaw > 10 and mr or 25,
		bodyyaw > 10 and mg or 25,
		bodyyaw > 10 and mb or 25,
		bodyyaw > 10 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)

	if ui.get(arrw_selct) == "manual" and ui.get(manaa_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		aa.manaa == 2 and mr or 25, 
		aa.manaa == 2 and mg or 25, 
		aa.manaa == 2 and mb or 25, 
		aa.manaa == 2 and ma or 160)

		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		aa.manaa == 1 and mr or 25, 
		aa.manaa == 1 and mg or 25, 
		aa.manaa == 1 and mb or 25, 
		aa.manaa == 1 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)

	if ui.get(arrw_selct) == "desync" and ui.get(manaa_inds) then
        renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		bodyyaw < -10 and mr or 25,
		bodyyaw < -10 and mg or 25,
		bodyyaw < -10 and mb or 25,
		bodyyaw < -10 and ma or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		bodyyaw > 10 and mr or 25,
		bodyyaw > 10 and mg or 25,
		bodyyaw > 10 and mb or 25,
		bodyyaw > 10 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)
end

-----------------------------
--CONFIGS
-----------------------------

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(json.stringify(settings))
	print("You have sucessfully exported your voidness configuration! It's ready for your friends to use.")
end

local export_btn = ui.new_button("AA", "Other", "export \a9FCA2BFFvoidness \aFFFFFFC9configuration", export_config)

local function import_config()

	local settings = json.parse(clipboard.get())

	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	print("You have sucessfully imported your voidness configuration! Enjoy using this config.")
end

local import_btn = ui.new_button("AA", "Other", "import \a9FCA2BFFvoidness \aFFFFFFC9configuration", import_config)

local function config_menu()
	local is_enabled = ui.get(lua_enable)
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		ui.set_visible(export_btn, true)
		ui.set_visible(import_btn, true)
	else
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
	end
end

client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)

-----------------------------
--DEFENSIVE DT
-----------------------------

local entity = require "gamesense/entity"


local esp_flag_set = false


local data = {}

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end


local function on_net_update_end (c)
    for _, player in ipairs(entity.get_players(true)) do
        local sim_time = time_to_ticks(player:get_prop("m_flSimulationTime"))
        local ent_index = player:get_entindex()

        local player_data = data[ent_index]

        if player_data == nil then
            data[ent_index] = {
                last_sim_time = sim_time,
                defensive_active_until = 0,
                defensive_shift = 0
            }

            goto continue
        end

        local delta = sim_time - player_data.last_sim_time
    
        if delta < 0 then
            player_data.defensive_active_until = globals.tickcount() + math.abs(delta)
            player_data.defensive_shift = delta

            print(string.format("Registered %s's exploit as unusual due to tick spike, t= %s", player:get_player_name(), delta))

        end

        player_data.last_sim_time = sim_time

        ::continue::
    end
end


local function handle_esp_flag (idx) 
    if not ui.get(enable_def) or data[idx] == nil then return false end

    return globals.tickcount() <= data[idx].defensive_active_until, "d " .. data[idx].defensive_shift
end


ui.set_callback(enable_def, function()
    local callback = ui.get(enable_def) and client.set_event_callback or client.unset_event_callback

    callback("net_update_end", on_net_update_end)

    if not esp_flag_set then
        client.register_esp_flag("DEFENSIVE", 159, 202, 43, handle_esp_flag)
        esp_flag_set = true    
    end
end)

-----------------------------
--KILLSAY/TRASHTALK
-----------------------------

local baimtable = {
    '𝔼𝕦𝕘𝕖𝕟 𝔾𝕣𝕘𝕚𝕔 "𝕘𝕣𝕚𝕞𝕫𝕨𝕒𝕣𝕖" 𝕒𝕣𝕣𝕖𝕤𝕥𝕖𝕕 𝕒𝕗𝕥𝕖𝕣 𝕣𝕖𝕢𝕦𝕖𝕤𝕥𝕚𝕟𝕘 𝟙𝟝𝟘𝔼𝕋ℍ 𝕗𝕣𝕠𝕞 𝔸𝟙',
	'ｉ ｈｓ ｓｉｎｃｅ ｍｙ ｍｏｔｈｅｒ ｂｏｒｎｅｄ ｍｅ',
	'i live and laugh knowing u die.',
	'my spotlight is bigger then united states of 𝒦𝒪𝒮𝒪𝒱𝒪 𝑅𝐸𝒫𝒰𝐵𝐿𝐼𝒞',
	'I AM LEGEND TO MY FAMILY',
	'tommorow Nemanja Danilovic will suffer his last blow after gsense ban',
	'𝗲𝗻𝗷𝗼𝘆 𝗱𝗶𝗲 𝘁𝗼 𝗚 𝗟𝗢𝗦𝗦 𝗟𝗨𝗔',
	'𝕥𝕙𝕚𝕤 𝕠𝕟𝕖 𝕚𝕤 𝕗𝕠𝕣 𝕞𝕪 𝕄𝕌𝕄𝕄ℤ𝕐 𝕖𝕟𝕛𝕠𝕪 𝕕𝕚𝕖',
	'𝓽𝓱𝓲𝓼 𝔀𝓮𝓪𝓴 𝓭𝓸𝓰 "VAX" 𝓌𝒶𝓈 𝒹𝑒𝓅𝑜𝓇𝓉𝑒𝒹 𝓉𝑜 ""𝒦𝐿𝒜𝒟𝒪𝒱𝒪""',
	'after killing "ReDD" 𝕚 𝕘𝕠𝕥 𝕡𝕣𝕖𝕤𝕚𝕕𝕖𝕟𝕥 𝕠𝕗 𝕒𝕔𝕖𝕥𝕠𝕝',
	'by funny color player',
    'you think you are 𝔰𝔦𝔤𝔪𝔞 𝔭𝔯𝔢𝔡𝔦𝔠𝔱𝔦𝔬𝔫 but no.',
    'neverlose will always use as long father esotartliko has my back.',
    'after winning 1vALL i went on vacation to 𝒢𝒜𝐵𝐸𝒩 𝐻𝒪𝒰𝒮𝐸',
    'i superior resolver(selling shoppy.gg/@KURAC))',
    'ＹＯＵ ＨＡＤ ＦＵＮ ＬＡＵＧＨＩＮＧ ＵＮＴＩＬ ＮＯＷ',
    'once this game started 𝔂𝓸𝓾 𝓵𝓸𝓼𝓮𝓭 𝓪𝓵𝓻𝓮𝓭𝔂',
    'WOMANBOSS VS 𝙀𝙑𝙀𝙍𝙔𝙊𝙉𝙀(𝙌𝙏𝙍𝙐𝙀,𝙍𝙊𝙊𝙏,𝙍𝘼𝙕𝙊,𝙍𝙀𝘿𝘿,𝙍𝙓𝙕𝙀𝙔,𝘽𝙀𝘼𝙕𝙏,𝙎𝙄𝙂𝙈𝘼,𝙂𝙍𝙄𝙈𝙕𝙒𝘼𝙍𝙀)',
	'𝕖𝕤𝕠𝕥𝕒𝕣𝕥𝕝𝕚𝕜 𝔸𝕃 ℙ𝕌𝕋𝕆 𝕊𝕌𝔼𝕃𝕆!',
	'𝘨𝘢𝘮𝘦𝘴𝘯𝘴𝘦 𝘪𝘴 𝘥𝘪𝘦 𝘵𝘰 𝘶.',
	'𝙨𝙬𝙖𝙢𝙥𝙢𝙤𝙣𝙨𝙩𝙚𝙧 𝙤𝙛 𝙢𝙚 𝙞𝙨 𝙘𝙤𝙢𝙚 𝙤𝙪𝙩',
	'weak gay femboy "cho" is depression after lose https://gamesense.pub/forums/viewtopic.php?id=35658',
	'after ban from galaxy i go on all servers to 𝓂𝒶𝓀𝑒 𝑒𝓋𝑒𝓇𝓎𝑜𝓃𝑒 𝓅𝒶𝓎 𝒻𝑜𝓇 𝒷𝒶𝓃 𝑜𝒻 𝓂𝑒',
	'𝚠𝚎𝚊𝚔 𝚍𝚘𝚐(𝚖𝚋𝚢 𝚋𝚕𝚊𝚌𝚔) 𝚐𝚘 𝚑𝚎𝚕𝚕 𝚊𝚏𝚝𝚎𝚛 𝚔𝚒𝚕𝚕',
	'𝔻𝕠𝕟’𝕥 𝕡𝕝𝕒𝕪 𝕓𝕒𝕟𝕜 𝕧𝕤 𝕞𝕖, 𝕚𝕞 𝕝𝕚𝕧𝕖 𝕥𝕙𝕖𝕣𝕖.',
	'𝙙𝙖𝙮 666 𝙃𝙑𝙃𝙔𝘼𝙒 𝙨𝙩𝙞𝙡𝙡 𝙣𝙤 𝙧𝙞𝙫𝙖𝙡𝙨',
	'𝕌 ℂ𝔸ℕ 𝔹𝕌𝕐 𝔸 ℕ𝔼𝕎 𝔸ℂℂ𝕆𝕌ℕ𝕋 𝔹𝕌𝕋 𝕌 ℂ𝔸ℕ𝕋 𝔹𝕌𝕐 𝔸 𝕎𝕀ℕ',
	'my config better than your',
	'1 STFU NN WHO.RU $$$ UFF YA UID?',
	'𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕁ℤ 𝕤𝕠𝕠𝕟.',
	'𝕀 𝔸𝕄 𝕃𝔸𝕍𝔸 𝕐𝕆𝕌 𝔸ℝ𝔼 𝔽ℝ𝕆𝔾',
	'game vs you is free win',
	'𝙖𝙛𝙩𝙚𝙧 𝙠𝙞𝙡𝙡𝙞𝙣𝙜 𝙜𝙧𝙞𝙢𝙯𝙬𝙖𝙧𝙚 𝙞 𝙘𝙡𝙖𝙞𝙢𝙚𝙙 𝙢𝙮 𝙥𝙡𝙖𝙘𝙚 𝙖𝙨 𝙋𝙍𝙀𝙕𝙄𝘿𝙀𝙉𝙏 𝙊𝙁 𝘾𝙍𝙊𝘼𝙏𝙄𝘼',
	'𝘴𝘩𝘰𝘱𝘱𝘺.𝘨𝘨/@𝘢𝘧𝘳𝘪𝘤𝘬𝘢𝘴𝘭𝘫𝘪𝘷𝘢 𝘵𝘰 𝘪𝘯𝘤𝘳𝘦𝘢𝘴𝘦 𝘩𝘷𝘩 𝘱𝘰𝘵𝘦𝘯𝘵𝘪𝘢𝘭',
	'𝔦 𝔰𝔱𝔬𝔭 𝔲 𝔴𝔦𝔱𝔥 𝔱𝔥𝔦𝔰 ℌ$',
	'𝔲 𝔫𝔢𝔢𝔡 𝔱𝔯𝔞𝔫𝔰𝔩𝔞𝔱𝔬𝔯 𝔱𝔬 𝔥𝔦𝔱 𝔪𝔶 𝔞𝔫𝔱𝔦 𝔞𝔦𝔪𝔟𝔬𝔱',
	'𝒻𝒶𝓃𝒸𝒾𝑒𝓈𝓉 𝒽𝓋𝒽 𝓇𝑒𝓈𝑜𝓁𝓋𝑒𝓇 𝒾𝓃 𝒾𝓃𝒹𝓊𝓈𝓉𝓇𝓎 𝑜𝒻 𝓋𝒾𝓉𝓂𝒶',
	'𝕒𝕗𝕥𝕖𝕣 𝕝𝕖𝕒𝕧𝕚𝕟𝕘 𝕣𝕠𝕞𝕒𝕟𝕚𝕒 𝕚 𝕓𝕖𝕔𝟘𝕞𝕖 = 𝕝𝕖𝕘𝕖𝕟𝕕𝕒',
	'gσ∂ вℓєѕѕ υηιтє∂ ѕтαтєѕ σƒ яσмαηι & ѕєявια',
	'ur lua cracked like egg',
	'i am america after doing u like japan in HVH',
	'winning not possibility, sry.',
	'after this ＨＥＡＤＳＨＯＲＴ i become sigma',
	'𝕘𝕠𝕕 𝕘𝕒𝕧𝕖 𝕞𝕖 𝕡𝕠𝕨𝕖𝕣 𝕠𝕗 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣 𝕁𝔸𝕍𝔸𝕊ℂℝ𝕀ℙ𝕋𝔸',
	'ｉ ａｍ ａｍｂａｓｓａｄｏｒ ｏｆ ｇｓｅｎｓｅ',
	'𝓼𝓴𝓮𝓮𝓽 𝓬𝓻𝓪𝓬𝓴 𝓷𝓸 𝔀𝓸𝓻𝓴 𝓪𝓷𝔂𝓶𝓸𝓻𝓮 𝔀𝓱𝓪𝓽 𝓾 𝓾𝓼𝓮 𝓷𝓸𝔀',
	'𝕡𝕠𝕠𝕣 𝕕𝟘𝕘 𝕊ℙ𝔸𝔻𝔼𝔻 𝕟𝕖𝕖𝕕 𝟚𝟘$ 𝕥𝕠 𝕓𝕦𝕪 𝕟𝕖𝕨 𝕒𝕚𝕣 𝕞𝕒𝕥𝕥𝕣𝕖𝕤𝕤.',
	'i am KING go slave for me',
	'Don"t cry, say ᶠᵘᶜᵏ ʸᵒᵘ and smile.',
	'My request for 150 ETH was not filled in. It passed almost 48 hours, I gave them 72...',
    '𝒶𝒻𝓉𝑒𝓇 𝒷𝒶𝓃 𝒻𝓇𝑜𝓂 𝓈𝓀𝑒𝑒𝓉(𝑔𝓈𝑒𝓃𝓈𝑒) 𝒾 𝒷𝒶𝓃 𝓎𝑜𝓊 𝒻𝓇𝑜𝓂 𝒽𝑒𝒶𝓋𝑒𝓃.𝓁𝓊𝒶',
    '𝘨𝘰𝘥 𝘣𝘭𝘦𝘴𝘴𝘦𝘥 𝘨𝘢𝘮𝘦𝘴𝘦𝘯𝘴𝘦 𝘢𝘯𝘥 𝘳𝘦𝘨𝘦𝘭𝘦 𝘰𝘧 𝘸𝘰𝘳𝘭𝘥(𝘮𝘦)',
   	'𝕒𝕗𝕥𝕖𝕣 𝕣𝕖𝕔𝕚𝕖𝕧𝕖 𝕤𝕜𝕖𝕖𝕥𝕓𝕖𝕥𝕒 𝕚 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦',
    'ｅｖｅｎ ｓｉｇｍａ ｃａｎｔ ｔｏｕｃｈ ｍｙ ａｎｔｉ ｒｅｓｏｌｖｅｒ',
    '𝓊 𝑔𝑜 𝓈𝓁𝑒𝑒𝓅 𝓁𝒾𝓀𝑒 𝓎𝑜𝓊𝓇 *𝒟𝐸𝒜𝒟* 𝓂𝑜𝓉𝒽𝑒𝓇𝓈',
   	'𝒾 𝓀𝒾𝓁𝓁𝑒𝒹 𝓊 𝒻𝓇𝑜𝓂 𝓂𝑜𝑜𝓃',
   	'𝕖𝕝𝕖𝕡𝕙𝕒𝕟𝕥 𝕝𝕠𝕠𝕜 𝕒𝕝𝕚𝕜𝕖 "𝕎𝕀𝕊ℍ" 𝕕𝕚𝕖𝕕 𝕥𝕠 𝕞𝕖 𝕤𝕠 𝕨𝕚𝕝𝕝 𝕪𝕠𝕦',
    'ᵍᵒᵒᵈ ᵈᵃʸ ᵗᵒ ʰˢ ⁿᵒⁿᵃᵐᵉˢ.',
    '𝙖𝙛𝙩𝙚𝙧 𝙘𝙖𝙧𝙙𝙞𝙣𝙜 𝙛𝙤𝙤𝙙 𝙛𝙤𝙧 𝙭𝙖𝙉𝙚 𝙞 𝙧𝙚𝙘𝙞𝙚𝙫𝙚𝙙 𝙨𝙠𝙚𝙚𝙩𝙗𝙚𝙩𝙖',
	'𝔫𝔢𝔳𝔢𝔯 𝔱𝔥𝔦𝔫𝔨 𝔶𝔬𝔲𝔯 𝔠𝔬𝔦𝔫𝔟𝔞𝔰𝔢 𝔦𝔰 𝔰𝔞𝔣𝔢',
	'𝓲 𝔀𝓲𝓵𝓵 𝓼𝓲𝓶𝓼𝔀𝓪𝓹 𝔂𝓸𝓾𝓻 𝓯𝓪𝓶𝓲𝓵𝔂',
	'𝕗𝕣𝕖𝕖 𝕙𝕧𝕙 𝕝𝕖𝕤𝕤𝕠𝕟𝕤 𝕪𝕠𝕦𝕥𝕦𝕓𝕖.𝕔𝕠𝕞/𝕊𝕖𝕣𝕓𝕚𝕒𝕟𝔾𝕒𝕞𝕖𝕤𝔹𝕃',
	'(っ◔◡◔)っ ♥ enjoy this H$ and spectate me ♥',
	'𝕚 𝕒𝕞 𝕜𝕝𝕒𝕕𝕠𝕧𝕠 𝕡𝕖𝕖𝕜 (◣_◢)',
	'𝓎𝑜𝓊𝓇 𝒹𝑜𝓍 𝒾𝓈 𝒶𝓁𝓇𝑒𝒶𝒹𝓎 𝓅𝑜𝓈𝓉𝑒𝒹.',
    '𝔦 𝔥$ 𝔞𝔫𝔡 𝔰𝔪𝔦𝔩𝔢',
	'ｙｏｕ ｃｒｙ？',
	'𝙞 𝙚𝙣𝙩𝙚𝙧𝙚𝙙 𝙧𝙪𝙧𝙪𝙧𝙪 𝙨𝙩𝙖𝙩𝙚 𝙤𝙛 𝙢𝙞𝙣𝙙',
    '𝓇𝑒𝓏𝑜𝓁𝓋𝑒𝓇 𝑜𝓃 𝓎𝑜𝓊 = 𝐹𝒪𝑅𝒞𝐸 𝐻$',
	'𝔸𝔽𝕋𝔼ℝ 𝔼𝕊ℂ𝔸ℙ𝕀ℕ𝔾 𝕊𝔼ℂ𝕌ℝ𝕀𝕋𝕐 𝕀 𝕎𝔼ℕ𝕋 𝕆ℕ 𝕂𝕀𝕃𝕃𝕀ℕ𝔾 𝕊ℙℝ𝔼𝔸𝕂 𝕌ℝ 𝕀ℕ 𝕀𝕋',
	'𝘪 𝘩𝘴 𝘺𝘰𝘶. 𝘦𝘷𝘦𝘳𝘺𝘵𝘪𝘮𝘦 𝘫𝘶𝘴𝘵 𝘩𝘴. 𝘣𝘶𝘺 𝘮𝘺 𝘬𝘧𝘨.',
	'cu@gsense/spotlight section of forum by MOGYORO',
	'u die while i talk with prezident of 𝙰𝙵𝙶𝙷𝙰𝙽𝙸𝚂𝚃𝙰𝙽𝙸 making $$$',
	'my coinbase is thicker then the hs i gave u',
	'olympics every 4 years next chance to kill me is in 100',
	'stop talk u *DEAD*',
	'𝒩𝐸𝒱𝐸𝑅 𝒯𝐻𝐼𝒩𝒦 𝒴𝒪𝒰 "yerebko"',
	'𝕟𝕠 𝕤𝕜𝕚𝕝𝕝 𝕟𝕖𝕖𝕕 𝕥𝕠 𝕜𝕚𝕝𝕝 𝕪𝕠𝕦',
	'𝕥𝕙𝕚𝕤 𝕓𝕠𝕥𝕟𝕖𝕥 𝕨𝕚𝕝𝕝 𝕖𝕟𝕕 𝕦 𝕙𝕒𝕣𝕕𝕖𝕣 𝕥𝕙𝕖𝕟 𝕞𝕪 𝕓𝕦𝕝𝕝𝕖𝕥',
	'𝘸𝘰𝘮𝘢𝘯𝘣𝘰$$ 𝘰𝘸𝘯𝘪𝘯𝘨 𝘲𝘶𝘢𝘥𝘳𝘶𝘱𝘭𝘦𝘵 𝘪𝘯𝘥𝘪𝘢𝘯𝘴 𝘢𝘯𝘥 𝘨𝘺𝘱𝘴𝘪𝘴 𝘴𝘪𝘯𝘤𝘦 2001',
	'𝘺𝘰𝘶 𝘫𝘶𝘴𝘵 𝘨𝘰𝘵 𝘵𝘢𝘱𝘱𝘦𝘥 𝘣𝘺 𝘢 𝘴𝘶𝘱𝘦𝘳𝘪𝘰𝘳 𝘱𝘭𝘢𝘺𝘦𝘳, 𝘨𝘰 𝘤𝘰𝘮𝘮𝘪𝘵 𝘩𝘰𝘮𝘪𝘤𝘪𝘥𝘦',
	'𝕁𝕦𝕤𝕥 𝕘𝕠𝕥 𝕟𝕖𝕞𝕒𝕟𝕛𝕒"𝕕 𝕤𝕥𝕒𝕪 𝕠𝕨𝕟𝕖𝕕 𝕒𝕟𝕕 𝕗𝕒𝕥',
	'𝕪𝕠𝕦 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕞𝕖 𝕠𝕟𝕔𝕖 , 𝕚 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕪𝕠𝕦 𝕥𝕨𝕚𝕔𝕖 (◣_◢) ',
	'𝓫𝔂 𝔀𝓸𝓶𝓪𝓷𝓫𝓸𝓼𝓼 𝓻𝓮𝓼𝓸𝓵𝓿𝓮𝓻 $',
	'𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘵𝘩𝘦 𝘨𝘰𝘥𝘴, 𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘮𝘦',
	'1',
	'𝟙,𝟚,𝟛 𝕚𝕟𝕥𝕠 𝕥𝕙𝕖 𝟜, 𝕨𝕠𝕞𝕒𝕟 𝕞𝕗𝕚𝕟𝕘 𝕓𝕠𝕤𝕤 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕔𝕙𝕣𝕠𝕞𝕖 𝕥𝕠 𝕪𝕒 𝕕𝕠𝕞𝕖',
	'𝔧𝔢𝔴𝔦𝔰𝔥 𝔱𝔢𝔯𝔪𝔦𝔫𝔞𝔱𝔬𝔯',
	'𝕐𝕠𝕦 𝕜𝕚𝕝𝕝 𝕞𝕖 𝕀 𝕖𝕩𝕥𝕠𝕣𝕥 𝕪𝕠𝕦 𝕗𝕠𝕣 𝟙𝟝𝟘 𝕖𝕥𝕙',
	'𝘢𝘭𝘸𝘢𝘺𝘴 𝘩𝘴, 𝘯𝘦𝘷𝘦𝘳 𝘣𝘢𝘮𝘦.',
	'𝘒𝘪𝘉𝘪𝘛 𝘷𝘚 𝘰𝘊𝘪𝘖 (𝘨𝘖𝘖𝘥𝘌𝘭𝘌𝘴𝘴 𝘥0𝘨) 𝘰𝘞𝘯𝘌𝘥 𝘐𝘯 3𝘹3',
	'𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟',
	'ｗｅａｋ ｂｏｔ ｍａｌｖａ ａｌｗａｙｓ ｄｏｇ',
	'𝙥𝙧𝙞𝙫𝙖𝙩𝙚 𝙞𝙙𝙚𝙖𝙡 𝙩𝙞𝙘𝙠 𝙩𝙚𝙘𝙝𝙣𝙤𝙡𝙤𝙜𝙞𝙚𝙨 ◣_◢',
	'𝕓𝕖𝕤𝕥 𝕤𝕖𝕣𝕓𝕚𝕒𝕟 𝕝𝕠𝕘 𝕞𝕖𝕥𝕙𝕠𝕕𝕤 𝕥𝕒𝕡 𝕚𝕟',
	'UHQ DoorDash logs tap in!',
	'cheap mcdonald giftcard method ◣_◢ selly.gg/mcsauce',
	'womanboss>all',
	'𝕨𝕙𝕒𝕥 𝕚𝕤 𝕒 𝕘𝕚𝕣𝕝 𝕥𝕠 𝕒 𝕨𝕠𝕞𝕒𝕟?',
	'drain balls for superior womanboss.technology invite',
	'𝚒𝚏 𝚢𝚘𝚞 𝚠𝚊𝚗t 𝚜𝚎𝚎 𝚖𝚢 𝚌𝚊𝚝 𝚢𝚘𝚞  𝚔𝚒𝚕𝚕 𝚖𝚎',
	'ミ💖 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 💖彡',
	'▄︻デ 𝔦 𝔱𝔲𝔯𝔫 𝔶𝔬𝔲 𝔴𝔞𝔱𝔢𝔯 𝔲𝔫𝔡𝔢𝔯 𝔟𝔯𝔦𝔡𝔤𝔢 ══━一',
	'died to a womän',
	'get fucked in the ass by serb gods, u can freely commit genocide just like eren yeager did $$$ kukubra simulator inreallif',
	'weak dog attend quandale dingle academic',
	'24 btc`d',
	'天安门广场抗议 黑人使我不舒服 I LOVE VALORATN 天安门广场抗议 黑人使我不舒服 Glory to China long live Xi Jinping',
	'𝟩 𝐼𝓃𝓉𝓇𝑒𝓈𝓉𝒾𝓃𝑔 𝐹𝒶𝒸𝓉𝓈 𝒶𝒷𝑜𝓊𝓉 𝒞𝑜𝓈𝓉𝒶 𝑅𝒾𝒸𝒶',
	'Black nigga balls HD',
	'when round is end i kill ghost.',
	'i swim entire mediterranean sea and atlantic ocean to 1 weak NA dogs',
	'🅆🄷🅈 🄳🄾 🅈🄾🅄 🅂🄾 🅂🄷🄸🅃.',
	'sowwy >_<',
	'Approved feminist  ◣_◢',
	'ХАХАХАХАХХАХА НИЩИЙ УЛЕТЕЛ (◣_◢)',
	'so i recive KILLSEY BOOST SYSTEM and now it"S dead all',
	'𝑴𝒚 𝒈𝒊𝒓𝒍𝒇𝒓𝒊𝒆𝒏𝒅𝒔 𝒂𝒏𝒅 𝑰 𝒋𝒖𝒔𝒕 𝒘𝒂𝒏𝒕𝒆𝒅 𝒕𝒐 𝒉𝒂𝒗𝒆 𝒂 𝒈𝒊𝒓𝒍𝒔 𝒏𝒊𝒈𝒉𝒕 𝒐𝒖𝒕 𝒃𝒖𝒕 𝒊𝒕 𝒕𝒖𝒓𝒏𝒆𝒅 𝒊𝒏𝒕𝒐 𝒎𝒆 𝒈𝒆𝒕𝒕𝒊𝒏𝒈 FREE HELL TIKET',
	'𝕀𝕋 𝕎𝔸𝕊 𝔸 𝕄𝕀𝕊𝕋𝔸𝕂𝔼 𝕋𝕆 𝔹𝔸ℕ ℙ𝔼𝕋ℝ𝔼ℕ𝕂𝕆 𝕋ℍ𝔼 ℂ𝔸𝕋 𝔽ℝ𝕆𝕄 𝔹ℝ𝔸ℤ𝕀𝕃 ℕ𝕆𝕎 𝔼𝕊𝕆𝕋𝕀𝕃𝔸ℝℂ𝕆 𝕊ℍ𝔸𝕃𝕃 ℙ𝔸𝕐',
	'𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝘾𝙤𝙣𝙛𝙞𝙧𝙢 𝙩𝙧𝙖𝙣𝙨𝙛𝙚𝙧 𝙧𝙚𝙦𝙪𝙚𝙨𝙩. 𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝙔𝙤𝙪 𝙨𝙚𝙣𝙩 10.244 𝙀𝙏𝙃 𝙩𝙤 𝙬𝙤𝙢𝙖𝙣𝙗𝙤𝙨𝙨.𝙚𝙩𝙝',
	'ᴊᴀʀᴠɪs: ɴɴ ᴅᴏɢ ᴛᴀᴘᴘᴇᴅ sɪʀ',
	'𝚒 𝚜𝚗𝚒𝚝𝚌𝚑𝚎𝚍 𝚘𝚗 𝚎𝚞𝚐𝚎𝚗𝚎 𝚐𝚛𝚐𝚒𝚌…',
	'𝙜𝙖𝙢𝙚𝙨𝙚𝙣𝙨𝙚.𝙥𝙪𝙗 𝙚𝙧𝙧𝙤𝙧 404 𝙙𝙪𝙚 𝙩𝙤  𝕔𝕝𝕠𝕦𝕕𝕗𝕝𝕒𝕣𝕖 𝕓𝕪𝕡𝕒𝕤𝕤𝕖𝕤 ◣_◢',
	'game-sense is a reaaly good against nevelooss and some other',
	'the server shivers when the when 𝐰𝐨𝐦𝐚𝐧𝐛𝐨𝐬𝐬 𝐭𝐞𝐚𝐦 connect..',
	'𝕟𝕠 𝕞𝕒𝕥𝕔𝕙 𝕗𝕠𝕣 𝕜𝕦𝕣𝕒𝕔 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣',
	'𝕋𝕙𝕚𝕤 𝕕𝕠𝕘 𝕤𝕠𝕗𝕚 𝕥𝕙𝕚𝕟𝕜 𝕙𝕖 𝕙𝕒𝕤 𝕓𝕖𝕤𝕥 𝕙𝕒𝕔𝕜 𝕓𝕦𝕥 𝕙𝕖 𝕙𝕒𝕤𝕟”𝕥 𝕓𝕖𝕖𝕟 𝕥𝕠 𝕞𝕒𝕝𝕕𝕚𝕧𝕖𝕤 𝕌𝕊𝔸 𝕖𝕤𝕠𝕥𝕒𝕝𝕜𝕚𝕜',
	'𝕚𝕞 𝕒𝕝𝕨𝕒𝕪𝕤 𝟙𝕧𝕤𝟛𝟠 𝕤𝕥𝕒𝕔𝕜 𝕘𝕠𝕠𝕕𝕝𝕖𝕤𝕤 𝕓𝕦𝕥 𝕥𝕙𝕖𝕪 𝕚𝕥𝕤 𝕟𝕠𝕥 𝕨𝕚𝕟 𝕧𝕤 𝕄𝔼',
	'𝕚𝕞 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦 𝕨𝕙𝕖𝕟 𝕚 𝕨𝕒𝕤 𝕣𝕖𝕔𝕚𝕧𝕖𝕕 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕗𝕣𝕠𝕞 𝕖𝕤𝕠𝕥𝕒𝕝𝕚𝕜',
	'𝕘𝕠𝕕 𝕟𝕚𝕘𝕙𝕥 - 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕫.𝕦𝕫𝕓𝕖𝕜𝕚𝕤𝕥𝕒𝕟',
	'𝘶𝘯𝘧𝘰𝘳𝘵𝘶𝘯𝘢𝘵𝘦 𝘮𝘦𝘮𝘣𝘦𝘳 𝘬𝘯𝘦𝘦 𝘢𝘨𝘢𝘪𝘯𝘴𝘵 𝘸𝘰𝘮𝘢𝘯𝘣𝘰𝘴𝘴',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕕𝕠𝕟𝕥 𝕘𝕠 𝕗𝕠𝕣 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞 𝕠𝕟𝕝𝕪 𝕚𝕕𝕖𝕒𝕝 𝕥𝕚𝕜 𝕥𝕖𝕔𝕟𝕠𝕝𝕠𝕛𝕚𝕤 ◣_◢',
	'+𝕨 𝕨𝕚𝕥𝕙 𝕚𝕞𝕡𝕝𝕖𝕞𝕖𝕟𝕥 𝕠𝕗 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤.𝕤𝕖𝕣𝕓𝕚𝕒',
	'𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕪𝕝𝕪 𝕪𝕠𝕦 𝕚𝕥𝕤 𝕣𝕖𝕔𝕚𝕧𝕖 𝔽𝕣𝕖𝕖 𝕙𝕖𝕝𝕝 𝕖𝕩𝕡𝕖𝕕𝕚𝕥𝕚𝕠𝕟',
	'𝚗𝚘 𝚋𝚊𝚖𝚎𝚜 𝚠𝚒𝚝𝚑 𝚞𝚜𝚎 𝚘𝚏 𝚔𝚞𝚛𝚊𝚌 𝚛𝚎𝚣𝚘𝚕𝚟𝚎𝚛 𝚝𝚎𝚌𝚑𝚗𝚘𝚕𝚘𝚓𝚒𝚎𝚜',
	'ℕ𝕖𝕨 𝕗𝕣𝕖𝕖 +𝕨 𝕥𝕣𝕚𝕔𝕜 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟 𝕚𝕟 𝕤𝕖𝕣𝕓𝕚𝕒 𝕦𝕡𝕕𝕒𝕥𝕖 𝕠𝕗 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖 𝕤𝕖𝕟𝕤𝕖𝕣𝕚𝕟𝕘',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕘𝕠 𝟙𝕧𝟛𝟞 𝕧𝕤 𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕖 𝕞𝕖𝕞𝕓𝕖𝕣𝕤… 𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕒𝕞 𝕧𝕚𝕔𝕥𝕠𝕣𝕪  ◣_◢',
	'(っ◔◡◔)っ ♥ fnay”ed ♥',
	'𝕚 𝕒𝕞 𝕚𝕥”𝕤 𝕕𝕠𝕟𝕥 𝕝𝕠𝕤𝕖  ◣_◢',
	'𝕚 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝕔𝕣𝕠𝕒𝕥𝕚𝕒 𝕡𝕠𝕨𝕖𝕣 𝕘𝕣𝕚𝕕 𝕚𝕟 𝕞𝕖𝕞𝕠𝕣𝕪 𝕠𝕗 𝕕𝕖𝕒𝕣 𝔼𝕦𝕘𝕖𝕟𝕖 𝔾𝕣𝕘𝕚𝕔',
	'𝕣𝕠𝕞𝕒𝕟𝕪 𝕓𝕖𝕘 𝕞𝕖 𝕗𝕠𝕣 𝕜𝕗𝕘 𝕓𝕦𝕥 𝕚𝕞 𝕤𝕒𝕪 𝟝 𝕡𝕖𝕤𝕠𝕤',
	'𝕚𝕞 𝕔𝕒𝕟 𝕙𝕒𝕔𝕜 𝕗𝕟𝕒𝕪 𝕒𝕟𝕕 𝕡𝕣𝕖𝕕𝕚𝕔𝕥𝕚𝕠𝕟 𝕒𝕝𝕝 𝕟𝕖𝕩𝕥 𝕣𝕠𝕦𝕟𝕕..',
	'𝕡𝕣𝕖𝕞𝕚𝕦𝕞 𝕗𝕚𝕧𝕖 𝕟𝕚𝕘𝕙𝕥𝕤 𝕒𝕥 𝕗𝕣𝕖𝕕𝕕𝕪𝕤 𝕙𝕒𝕔𝕜𝕤 @𝕤𝕙𝕠𝕡𝕡𝕪.𝕘𝕘/𝕥𝕦𝕣𝕜𝕝𝕚𝕗𝕖𝕤𝕥𝕪𝕝𝕖',
	'𝕀𝔾𝔸𝕄𝔼𝕊𝔼ℕ𝕊𝔼 𝔸ℕ𝕋𝕀-𝔸𝕀𝕄 ℍ𝔼𝔸𝔻𝕊ℍ𝕆𝕋 ℙℝ𝔼𝔻𝕀ℂ𝕋+',
	'𝟙𝔸ℕ𝕋𝕀-ℕ𝔼𝕎-𝕋𝔼ℂℍℕ𝕆𝕃𝕆𝔾𝕐 𝕀𝕊 ℙℝ𝔼𝕊𝔼ℕ𝕋𝔼𝔻!',
	'!𝔹𝕐 𝕄𝕌𝕊𝕋𝔸𝔹𝔸ℝ𝔹𝔸𝔸ℝ𝕀𝟙𝟛𝟛𝟟𝟙-',
	'!𝔽ℝ𝔼𝔼 𝕃𝕌𝔸 𝕋𝕆𝕄𝕆ℝℝ𝕆𝕎!',
	'𝕆𝕎ℕ𝔼𝔻 𝔸𝕃𝕃!',
	'развертывать freddy fazbear',
	'𝕓𝕦𝕘𝕤 𝕔𝕒𝕞𝕖 𝕗𝕣𝕠𝕞 𝕤𝕚𝕘𝕞𝕒’𝕤 𝕟𝕠𝕤𝕖 𝕒𝕟𝕕 𝕙𝕚𝕤 𝕖𝕪𝕖𝕤 𝕥𝕦𝕣𝕟𝕖𝕕 𝕓𝕝𝕒𝕔𝕜 ◣_◢',
	'𝕤𝕠 𝕒 𝕨𝕖𝕒𝕜 𝕗𝕣𝕖𝕕𝕕𝕪 𝕗𝕒𝕫𝕓𝕖𝕒𝕣 𝕋𝕋 𝕤𝕠 𝕚 𝕤𝕡𝕖𝕟𝕕 𝟙𝟘 𝕟𝕚𝕘𝕙𝕥”𝕤 𝕨𝕚𝕥𝕙 𝕙𝕚𝕞 𝕞𝕠𝕥𝕙𝕖𝕣',
	'𝕤𝕡𝕖𝕔𝕚𝕒𝕝 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕥𝕠 𝕝𝕚𝕘𝕙𝕥𝕠𝕟 𝕙𝕧𝕙 𝕨𝕖 𝕨𝕚𝕝𝕝 𝕔𝕠𝕞𝕖 𝕥𝕠 𝕦𝕣 𝕙𝕠𝕦𝕤𝕖 𝕒𝕘𝕒𝕚𝕟 𝕒𝕟𝕕 𝕥𝕙𝕚𝕤 𝕥𝕚𝕞𝕖 𝕚𝕥 𝕨𝕚𝕝𝕝 𝕟𝕠𝕥 𝕓𝕖 𝕡𝕖𝕒𝕔𝕖𝕗𝕦𝕝 ◣_◢',
	'𝐞𝐩𝐢𝐜𝐟𝐨𝐧𝐭𝐬.𝐬𝐞𝐫𝐛𝐢𝐚 𝐩𝐫𝐞𝐦𝐢𝐮𝐢𝐦 𝐮𝐬𝐞𝐫',
	'𝕒𝕔𝕔𝕠𝕣𝕕𝕚𝕟𝕘 𝕥𝕠 𝕪𝕠𝕦𝕥𝕦𝕓𝕖 𝕒𝕟𝕒𝕝𝕚𝕥𝕚𝕔𝕤, 𝟟𝟘% 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕤𝕦𝕓𝕤𝕔𝕣𝕚𝕓𝕖𝕤... ◣_◢',
	'FATALITY.WIN Finish Him and Everyone',
	'𝖘𝖔 𝖙𝖍𝖊𝖞 𝖗𝖊𝖆𝖑𝖑𝖞 𝖙𝖍𝖔𝖚𝖌𝖍𝖙 𝖙𝖍𝖊𝖞 𝖈𝖆𝖓 𝖘𝖍𝖔𝖈𝖐 𝖙𝖍𝖊 𝖐𝖎𝖓𝖌, 𝖘𝖔 𝖎 𝖘𝖍𝖔𝖈𝖐𝖊𝖉 𝖙𝖍𝖊𝖎𝖗 𝖎𝖓𝖋𝖆𝖓𝖙 𝖈𝖍𝖎𝖑𝖉𝖘',
	'ℍ𝕖𝕣𝕠𝕓𝕣𝕚𝕟𝕖 𝕞𝕚𝕘𝕙𝕥 𝕓𝕖 𝕔𝕙𝕖𝕒𝕥𝕚𝕟𝕘 𝕚𝕟 ℂ𝕊:𝔾𝕆...',
	'ɪ ᴄᴀʟʟ ᴀʟʟᴀʜ ᴛᴏ ᴘᴀʀᴛ ꜱᴇᴠᴇɴ ꜱᴇᴀꜱ ᴡʜᴇɴ ɪ ᴛʀᴀᴠᴇʟ ᴛᴏ ᴋɪʟʟ ᴡᴇᴀᴋ ɴᴀ ʀᴀᴛꜱ ◣_◢',
	'𝓼𝓸 𝓲 𝓶𝓲𝓰𝓱𝓽 𝓫𝓮 𝓼𝓮𝓵𝓵𝓲𝓷𝓰 𝓷𝓮𝓿𝓮𝓻𝓵𝓸𝓼𝓮 𝓲𝓷𝓿𝓲𝓽𝓪𝓽𝓲𝓸𝓷...',
	'ＴＨＥＲＥ ＩＳ ＮＯ  ＷＡＹ ＴＨＡＴＳ ＬＥＧＩＴ．．．ಠ_ಠ',
	'𝕊𝕠 𝕀 𝕗𝕚𝕟𝕒𝕝𝕝𝕪 𝕙𝕒𝕕 𝕤𝕖𝕩 𝕚𝕟 ℍ𝕦𝕟𝕚𝕖ℙ𝕠𝕡...',
	'𝐚𝐟𝐭𝐞𝐫 𝐟𝐢𝐯𝐞 𝐧𝐢𝐠𝐡𝐭𝐬 𝐟𝐫𝐞𝐝𝐝𝐲 𝐟𝐚𝐳𝐛𝐞𝐚𝐫 𝐠𝐚𝐯𝐞 𝐭𝐡𝐞𝐬𝐞 𝐭𝐞𝐜𝐡𝐧𝐨𝐥𝐨𝐠𝐢𝐜𝐚𝐥  ◣_◢',
	'𝖘𝖔 𝖙𝖍𝖎𝖘 𝖜𝖊𝖆𝖐 𝖗𝖆𝖙 𝖇𝖆𝖓𝖓𝖊𝖉 𝖒𝖎𝖓𝖊 𝖋𝖗𝖎𝖊𝖓𝖉 (𝖓𝖔𝖘𝖙𝖆𝖑𝖌𝖎𝖆) 𝖓𝖔𝖜 𝖎 𝖆𝖗𝖊 𝖚𝖘𝖊𝖉 𝖔𝖋 𝖆𝖓𝖙𝖎-𝖕𝖗𝖎𝖒𝖔𝖗𝖉𝖎𝖆𝖑 𝖙𝖊𝖈𝖍𝖓𝖔𝖑𝖔𝖌𝖎𝖈𝖆𝖑 ◣_◢',
	'𝐒𝐨 𝐈 𝐜𝐚𝐥𝐥𝐞𝐝 𝐭𝐡𝐞 𝐖𝐎𝐌𝐀𝐍𝐁𝐎𝐒𝐒 𝐚𝐭 𝟒𝐚𝐦... 𝐢𝐭 𝐰𝐚𝐬 𝐩𝐫𝐞𝐭𝐭𝐲 𝐬𝐜𝐚𝐫𝐲',
	'𝗞𝗜𝗭𝗔𝗥𝗨 𝗪𝗔𝗡𝗧𝗦 𝗪𝗢𝗠𝗔𝗡𝗕𝗢𝗦𝗦𝗘𝗦 𝗧𝗢 𝗝𝗢𝗜𝗡 𝗚𝗢𝗗𝗘𝗟𝗘𝗦𝗦?! (𝗴𝗼𝗶𝗻𝗴 𝗽𝗿𝗼)',
	'UNDERAGE? CALL ME',
	'ＦＯＯＬ ＭＥ ＯＮＣＥ， ＳＨＡＭＥ ＯＮ ＹＯＵ， ＦＯＯＬ ＭＥ ＴＷＩＣＥ， Ｉ ＴＲＯＬＬ ＹＯＵ．',
	'go buy Nixware for the best hacker facing hacker gone wrong experience.',
	'UFF SilenZIO$$$ U have Ben 1TAPED by PORTUGAL Technology',
	'you"re are poor go bay beter turkish cheat (onetap su) ',
	'Romanian Technology I steal real model and REZOLVE.',
	'ᴡᴀʀɴɪɴɢ: ɢᴏɪɴɢ ᴛᴏ ꜱʟᴇᴇᴘ ᴏɴ ꜱᴜɴᴅᴀʏ ᴡɪʟʟ ᴄᴀᴜꜱᴇ ᴍᴏɴᴅᴀʏ',
	
}
local hstable = baimtable

local deathtable = {
    'you think you win?',
	'im no trying.',
	'lucky monkey.',
	'my teammate bait for you.',
	'𝕒𝕟𝕥𝕚 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣 𝕨𝕒𝕤 𝕠𝕗𝕗.',
	'𝕜𝕚𝕝𝕝 𝕞𝕖 𝕟𝕠𝕨 𝕚 𝕤𝕚𝕞𝕤𝕨𝕒𝕡 𝕪𝕠𝕦 𝕗𝕠𝕣 𝕔𝕠𝕚𝕟𝕓𝕒𝕤𝕖 𝕔𝕠𝕟𝕗𝕚𝕣𝕞𝕒𝕥𝕚𝕠𝕟𝕤',
	'how u live on luck.',
	'bot u will see me next round...',
	'luckbased player enjoy DDO$.',
	'𝐲𝐨𝐮 𝐤𝐢𝐥𝐥 𝐦𝐞 𝐛𝐮𝐭 𝐢 𝐤𝐢𝐥𝐥 𝐲𝐨𝐮𝐫 𝐬𝐢𝐦 𝐜𝐚𝐫𝐝',
}


local function get_table_length(data)
  if type(data) ~= 'table' then
    return 0
  end
  local count = 0
  for _ in pairs(data) do
    count = count + 1
  end
  return count
end

local num_quotes_baim = get_table_length(baimtable)
local num_quotes_hs = get_table_length(hstable)
local num_quotes_death = get_table_length(deathtable)

local function on_player_death(e)
	if not ui_get(trashtalk) then
		return
	end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex   = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)
	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
		if e.headshot then
			    local commandhs = 'say ' .. hstable[math.random(num_quotes_hs)]
                console_cmd(commandhs)
		else
			    local commandbaim = 'say ' .. baimtable[math.random(num_quotes_baim)]
                console_cmd(commandbaim)
		end
	end
	if victim_entindex == get_local_player() and attacker_entindex ~= get_local_player() then
          local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
          console_cmd(commandbaim)
	elseif victim_entindex == get_local_player() and attacker_entindex == get_local_player() then
			console_cmd("say I had to die to make it fair.")
	end
end

client.set_event_callback("player_death", on_player_death)

-----------------------------
--CUSTOM SCOPE
-----------------------------

local scope_overlay = ui_reference('VISUALS', 'Effects', 'Remove scope overlay')

local g_paint_ui = function()
	ui_set(scope_overlay, true)
end

local g_paint = function()
	ui_set(scope_overlay, false)

	local width, height = client_screen_size()
	local offset, initial_position, speed, color =
		ui_get(overlay_offset) * height / 1080, 
		ui_get(overlay_position) * height / 1080, 
		ui_get(fade_time), { ui_get(color_picker) }

	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals_frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer_gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer_gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local ui_callback = function(c)
	local master_switch, addr = ui_get(c), ''

	if not master_switch then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	ui_set_visible(scope_overlay, not master_switch)
	ui_set_visible(overlay_position, master_switch)
	ui_set_visible(overlay_offset, master_switch)
	ui_set_visible(fade_time, master_switch)

	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)
end

ui_set_callback(master_switch, ui_callback)
ui_callback(master_switch)

---------------------------------------------
--CLAN TAG SPAMMER
---------------------------------------------

local duration = 14
local clantags = {

	"",
	"v",
	"v0",
	"vo",
	"vo1",
	"voi",
	"voio|",
	"void",
	"void|>|",
	"voidn",
	"voidn3",
	"voidne",
	"voidne5",
	"voidnes",
	"voidnes5",
	"voidness",
	"voidness.",
	"voidness.<",
	"voidness.l<",
	"voidness.lu<",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lu<",
	"voidness.l<",
	"voidness.<",
	"voidness.",
	"voidnes5",
	"voidnes",
	"voidne5",
	"voidne",
	"voidn3",
	"voidn",
	"void|>|",
	"void",
	"voio|",
	"voi",
	"vo1",
	"vo",
	"v0",
	"v",
	""
}

local empty = {''}
local clantag_prev
client.set_event_callback('net_update_end', function()
    if ui.get(skeetclantag) then 
        return 
    end

    local cur = math.floor(globals.tickcount() / duration) % #clantags
    local clantag = clantags[cur+1]

    if ui.get(clantagspam) then
        if clantag ~= clantag_prev then
            clantag_prev = clantag
            client.set_clan_tag(clantag)
        end
    end
end)
ui.set_callback(clantagspam, function() client.set_clan_tag('\0') end)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

-----------------------------
--WERYFIKACJA
-----------------------------

local alfabet = "base64"

local h, m, s, mst = client.system_time()
local actual_time = ('%2d:%02d'):format(h, m)

local tekst_nazwa = ("U: " .. obex_data.username)
local tekst_wersja = ("VN: " .. obex_data.build)
local tekst_weryfikacja = ("TUFLSSxXRUtF")
local tekst_czas = ("T: " .. actual_time)

local encoded1 = base64.encode(tekst_nazwa, alfabet)
local encoded2 = base64.encode(tekst_wersja, alfabet)
local encoded3 = base64.encode(tekst_weryfikacja, alfabet)
local encoded4 = base64.encode(tekst_czas, alfabet)

local function guzikweryfikacji()
print("-------VN-------")
print("U: ", encoded1)
print("VN: ", encoded2)
print("VF: ", encoded3)
print("T: ",  encoded4)
print("-------VN-------")
end

local ver_guzik = ui.new_button("AA", "Other", "Verify V\a9FCA2BFFN", guzikweryfikacji)

-----------------------------
--BASE64
-----------------------------

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("Missing sig1")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("Match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0
local function reduce(e)
	local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
	if lastlocal + 0.9 > globals.curtime() then
		cmd.tick_count = cmd.tick_count + 8
	else
		cmd.tick_count = cmd.tick_count + 1
	end
end

client.set_event_callback("setup_command", reduce)


local function fire(e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		lastlocal = globals.curtime()
		if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
			lastdt = globals.curtime() + 1.1
		end
	end
end

client.set_event_callback("weapon_fire", fire)

-----------------------------
--LUA FUNCS
-----------------------------

local function main()
	client.set_event_callback("run_command", function()
		get_best_enemy()
		get_best_angle()
	end)

	client.set_event_callback("bullet_impact", function(e)
		brute_impact(e)
	end)

	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			brute.reset()
		end
	end)

	client.set_event_callback("round_start", function()
		aa.input = 0
		aa.ignore = false
		lastlocal = 0
		lastdt = 0
		brute.reset()
		local me = entity.get_local_player()
		if not entity.is_alive(me) then return end
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
client.set_event_callback("setup_command", on_setup_command)
main()