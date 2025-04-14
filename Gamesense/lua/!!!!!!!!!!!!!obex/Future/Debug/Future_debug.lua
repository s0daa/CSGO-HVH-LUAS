-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

-- shit workshops libraries >:v
client.exec("playvol \"survival/buy_item_01.wav\" 1");
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") 
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local images = require "gamesense/images"
local surface = require"gamesense/surface"
local http = require "gamesense/http"
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname

--client.exec("clear")
--client.exec("toggleconsole")




--caca

local obex_data = obex_fetch and obex_fetch() or {username = 'tumadre', build = 'source', discord=''}


local vector = require('vector')

client.set_event_callback('paint', function()

    local screen_size = vector(client.screen_size())
    local username = (('%s  -  %s'):format(obex_data.username, obex_data.build)):upper()
end)





--ELPEPE LUA.

local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\a54DCFFFFfuture.lua - \aFFFFFFFF"..obex_data.build.."")
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
	dthholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "presets", "Load"),
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
	fakelag = {ui.reference("AA", "Fake lag", "Limit")}
}

local function on_load()
	ui.set(ref.yawjitter[1], "Center")
	ui.set(ref.yawjitter[2], 0)
	ui.set(ref.bodyyaw[1], "static")
	ui.set(ref.bodyyaw[2], -180)
	ui.set(ref.yaw[1], "180")
	ui.set(ref.yaw[2], 0)
	ui.set(ref.fakeyawlimit, 60)
	ui.set(ref.enabled,true)
end
slidewalk = ui.reference("AA", "other", "leg movement")
local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0

on_load()

local aa_init = { }

local var = {
	p_states = {"standing", "moving", "slow-motion", "air", "crouching", "air-crouching", "fakelag"},
	s_to_int = {["air-crouching"] = 6,["fakelag"] = 7, ["standing"] = 1, ["moving"] = 2, ["slow-motion"] = 3, ["air"] = 4, ["crouching"] = 5},
	player_states = {"S", "M", "SW", "A", "C", "AC", "FL"},
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


--referencias qlias.
aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "category", "anti-aim", "visuals", "misc", "alpha"),
	label2 = ui.new_label("AA", "Anti-aimbot angles", " " ),
	antiaim_config = ui.new_combobox("AA", "Anti-aimbot angles", " anti-aim Categories \n","Builder", "Keybinds"),
	manualcheck = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ manual anti-aim"),
	manual_backward = ui.new_hotkey("AA", "Anti-aimbot angles","manual backward"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles","manual forward"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "manual left"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles","manual right"),
	enablefs = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ freestanding"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "freestanding bind"),
	aa_tweaks = ui.new_multiselect("AA", "Anti-aimbot angles", "anti-aim additions \n","anti-bruteforce", "anti-backstab", "os-aa fix", "leg fucker"),
	label1 = ui.new_label("AA", "Anti-aimbot angles", " " ),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Anti-Bruteforce"),
	anti_backstab = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Backstab"),
	fix_hs = ui.new_checkbox("AA", "Anti-aimbot angles", "Onshot Fakelag Fix"), 
	legfucker = ui.new_checkbox("AA", "Anti-aimbot angles", "Leg Fucker"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "anti-aim presets", "hybrid", "tank"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","Disable Jitter on Dormant"),
	roll_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Roll Bind"),
	legit_e_key = ui.new_hotkey("AA", "Anti-aimbot angles", "legit anti-aim"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ anti-aim builder"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "localplayer state", "standing", "moving", "air", "air-crouching", "crouching", "slow-motion","fakelag"),
	brutelogic = ui.new_combobox("AA", "Anti-aimbot angles","Anti-Brute Logic", "Fast", "Accurate"),
	pepefix = ui.new_checkbox("AA", "Anti-aimbot angles", "disablepepe")



}
	
	
	




for i=1, 7 do
	aa_init[i] = {
		overridestate =  ui.new_checkbox("AA", "Anti-aimbot angles", "override ".. var.p_states[i]),
		yawaddl = ui.new_slider("AA", "Anti-aimbot angles", ""..var.p_states[i].." -  yaw add left \n", -180, 180, 0),
		yawaddr = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - yaw add right \n", -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." - jitter types \n" .. var.p_states[i], { "Off", "Offset", "Center", "Random" }),
		yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - yaw jitter \n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." - body yaw \n" .. var.p_states[i], { "Off", "Opposite", "Jitter", "Static"}),
		aa_static = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - body yaw left\n", -180, 180, 0),
		aa_static_2 = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - body yaw right\n", -180, 180, 0),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - desync limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." - desync limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		roll = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].."  Roll \n".. var.p_states[i], -50, 50, 0, true, "°"),
	}
end

--SI
local asd = {

 popup_clr_l = ui.new_label("AA", "Anti-aimbot angles", "main accent"),
 popup_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "a", 73, 167, 255),
 wtmrk = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ enable watermark"),
 grdnt_clr_l = ui.new_label("AA", "Anti-aimbot angles", "watermark accent"),
 grdnt_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "bold", 73, 167, 255),
 desync_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Desync Bar Color"),
 desync_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "dsy", 73, 167, 255),
 Bold_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Bold Indicators Color"),
 Bold_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "bold", 73, 167, 255),
 enableinds = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ enable indicators"),
 inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "Indicators", { "Off", "Ideal Yaw", "Modern", "Gradient", "Bold"}),
 main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Indicators Color"),
 main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 73, 167, 255),
 mierdacolor_l = ui.new_label("AA", "Anti-aimbot angles", "indicators accent"),
 mierdacolor = ui.new_color_picker("AA", "Anti-aimbot angles", "indicators", 255, 255, 255),
 enablearrows = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ enable arrows"),
 arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "arrow types", { "off", "normal", "teamskeet" }),
 Arrows_clr_l = ui.new_label("AA", "Anti-aimbot angles", "arrows accent"),
 Arrows_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "bold", 255, 255, 255),
 animasion = ui.new_multiselect("AA", "Anti-aimbot angles", "better animations", "Static Legs In Air", "Pitch Zero on Land"),
 amb_logger = ui.new_checkbox("AA", "Anti-aimbot angles", "ragebot logging"),
 displaypepe = ui.new_multiselect("AA", "Anti-aimbot angles", "logs", "Console", "Pop Up"),
 debugpene = ui.new_checkbox("AA", "Anti-aimbot angles", "↪ enable debug panel"),
 debug_clr_l = ui.new_label("AA", "Anti-aimbot angles", "debug panel accent"),
 debug_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "debug", 73, 167, 255),
 
} 




client.set_event_callback("run_command", function(c)

	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end)

local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

local function set_og_menu(state)
	
	ui.set_visible(ref.enabled, state)
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
--notificaciones qlias

_G.future_push=(function()
	_G.future_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.future_notify_cache;
			for g=#f,1,-1 do
				_G.future_notify_cache[g].time=_G.future_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 1.0;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.future_notify_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1.5 and 1.5 or k;
				if j.time<1.5 or k<1.5 then
					i=(k<1.5 and k or j.time)/1.5;
					i2=(k<1.5 and k or j.time)/1.5;
					h=i*255;
					lerpy=i*150;
					lerp_circ=i*1.0
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"[future]        "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[future]")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
			local c1,c2,c3,c4 = ui.get(asd.popup_clr)
			local x, y = client.screen_size()

		
			
			renderer.rectangle(p[1],p[2]-20,m[1]+10, 25, 23 , 23, 23,255)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[future]    ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
			renderer.circle_outline(p[1]+m[1]-2,p[2]-8, c1,c2,c3,h>200 and 200 or h, 6, 360, lerp_circ , 2)
		end
	end;
	self.callback_registered=true end)
end;

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.future_notify_cache[g]=_G.future_notify_cache[g-1]
	end;
	_G.future_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

future_push:paint(4,"Loading script modules")
future_push:paint(7,"Logged in as \aA8AAEAC3"..obex_data.username.."\aFFFFFFFF, build : \aA8AAEAC3"..obex_data.build.." ")




function HEXtoRGB(hexArg)

	hexArg = hexArg:gsub('#','')

	if(string.len(hexArg) == 3) then
		return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
	elseif(string.len(hexArg) == 8) then
		return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6)), tonumber('0x'..hexArg:sub(7,8))
	else
		return 0 , 0 , 0
	end

end



function RGBtoHEX(redArg, greenArg, blueArg)

	return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)

end


	
local function set_lua_menu()
	var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
	local is_aa = ui.get(aa_init[0].lua_select) == "anti-aim"
	local is_misc = ui.get(aa_init[0].lua_select) == "misc"
	local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
	local is_alpha = ui.get(aa_init[0].lua_select) == "alpha"
	local is_knife = ui.get(aa_init[0].anti_backstab)
	local is_enabled = ui.get(lua_enable)

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
	end
	



	if ui.get(aa_init[0].presets) == "Offensive" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end


	


	if is_misc and is_enabled then
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(asd.animasion, true)
		ui.set_visible(asd.amb_logger, true)

		ui.set_visible(aa_init[0].legfucker, false)
		ui.set_visible(aa_init[0].anti_backstab, false)
		ui.set_visible(aa_init[0].fix_hs, false)
	else
		ui.set_visible(asd.amb_logger, false)
		ui.set_visible(asd.animasion, false)
	end

	if ui.get(asd.amb_logger) and is_misc and is_enabled  then
		ui.set_visible(asd.displaypepe, true)
		else
		ui.set_visible(asd.displaypepe, false)
		end

	

	if is_vis and is_enabled  then 
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(aa_init[0].legfucker, false)
		ui.set_visible(aa_init[0].anti_backstab, false)
		ui.set_visible(aa_init[0].fix_hs, false)
		ui.set_visible(asd.wtmrk, true)
		
		ui.set_visible(aa_init[0].brutelogic, false)
		ui.set_visible(asd.popup_clr_l, true)
		ui.set_visible(asd.popup_clr, true)
		ui.set_visible(asd.main_clr_l, false)
		ui.set_visible(asd.main_clr, false)
		ui.set_visible(asd.mierdacolor_l, true)
		ui.set_visible(asd.mierdacolor, true)
		ui.set_visible(asd.grdnt_clr_l, true)
		ui.set_visible(asd.grdnt_clr, true)

		ui.set_visible(asd.enableinds, true)
		ui.set_visible(asd.enablearrows, true)

	else
		
		
		ui.set_visible(aa_init[0].brutelogic, false)
		ui.set_visible(asd.popup_clr_l, false)
		ui.set_visible(asd.popup_clr, false)
		ui.set_visible(asd.mierdacolor_l, false)
		ui.set_visible(asd.mierdacolor, false)
		ui.set_visible(asd.debug_clr_l, false)
		ui.set_visible(asd.debug_clr, false)
		ui.set_visible(asd.main_clr_l, false)
		ui.set_visible(asd.main_clr, false)
		ui.set_visible(asd.wtmrk, false)
		ui.set_visible(asd.grdnt_clr_l, false)
		ui.set_visible(asd.grdnt_clr, false)
		ui.set_visible(asd.debugpene, false)
		ui.set_visible(asd.enableinds, false)
		ui.set_visible(asd.enablearrows, false)
		

end

if ui.get (asd.enableinds) and is_vis and is_enabled then
    ui.set_visible(asd.inds_selct, true)
	ui.set_visible(asd.mierdacolor_l, true)
	ui.set_visible(asd.mierdacolor, true)

else
	ui.set_visible(asd.inds_selct, false)
	ui.set_visible(asd.mierdacolor, false)
	ui.set_visible(asd.mierdacolor_l, false)
end

if ui.get (asd.enablearrows) and is_vis and is_enabled then
	ui.set_visible(asd.arrw_selct, true)
	ui.set_visible(asd.Arrows_clr_l, true)
	ui.set_visible(asd.Arrows_clr, true)
else
	ui.set_visible(asd.Arrows_clr_l, false)
	ui.set_visible(asd.Arrows_clr, false)
	ui.set_visible(asd.arrw_selct, false)
end

if ui.get (asd.wtmrk) and is_vis and is_enabled then
	ui.set_visible(asd.grdnt_clr_l, true)
	ui.set_visible(asd.grdnt_clr, true)
else
	ui.set_visible(asd.grdnt_clr_l, false)
	ui.set_visible(asd.grdnt_clr, false)
end

if is_alpha and is_enabled  then 
	ui.set_visible(asd.debugpene, true)
else
	ui.set_visible(asd.debugpene, false)
end

if ui.get(asd.debugpene) and is_alpha and is_enabled then
ui.set_visible(asd.debug_clr_l, true)
ui.set_visible(asd.debug_clr, true)
else
ui.set_visible(asd.debug_clr_l, false)
ui.set_visible(asd.debug_clr, false)
end

    if is_colors and is_enabled then
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(asd.Arrows_clr_l, true)
		ui.set_visible(asd.Arrows_clr, true)
		ui.set_visible(aa_init[0].legfucker, false)
		ui.set_visible(aa_init[0].anti_backstab, false)
		ui.set_visible(aa_init[0].fix_hs, false)
		ui.set_visible(asd.desync_clr_l, true)
		ui.set_visible(asd.desync_clr, true)
		ui.set_visible(asd.Bold_clr_l, true)
		ui.set_visible(asd.Bold_clr, true)

		

	else

		ui.set_visible(asd.desync_clr_l, false)
		ui.set_visible(asd.desync_clr, false)
		ui.set_visible(asd.Bold_clr_l, false)
		ui.set_visible(asd.Bold_clr, false)

	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
		ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].aa_tweaks, true)
		ui.set_visible(aa_init[0].antiaim_config, false)
		ui.set_visible(aa_init[0].presets, true)
		ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].manualcheck, true)
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].enablefs, true)
		
		

		
	else
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].manualcheck, false)
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
		ui.set_visible(aa_init[0].presets, false)
		ui.set_visible(aa_init[0].antiaim_config, false)
		ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(aa_init[0].aa_builder, false)
		ui.set_visible(aa_init[0].enablefs, false)
		
	end
	ui.set(aa_init[0].pepefix,true)
	ui.set_visible(aa_init[0].pepefix,false)

	if ui.get(aa_init[0].enablefs) and is_aa and is_enabled then
		ui.set_visible(aa_init[0].fs, true)
	else
		ui.set_visible(aa_init[0].fs, false)
	end



	if ui.get(aa_init[0].manualcheck) and is_aa and is_enabled then
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		ui.set_visible(aa_init[0].manual_backward, true)
	else
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].manual_backward, false)
	end


	if is_aa and is_aacfg and is_enabled then
		ui.set_visible(aa_init[0].legfucker, false)
		ui.set_visible(aa_init[0].label1, true)
		ui.set_visible(aa_init[0].label2, true)
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
		ui.set_visible(aa_init[0].presets, false)
		ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(aa_init[0].fix_hs, false)
		ui.set_visible(aa_init[0].aa_builder, false)
		ui.set_visible(aa_init[0].anti_backstab, false)
		ui.set_visible(aa_init[0].roll_key, true)
		
		
    	else
		ui.set_visible(aa_init[0].label1, false)
		ui.set_visible(aa_init[0].label2, false)
		ui.set_visible(aa_init[0].roll_key, false)
		
	end






	if  is_aa and is_aacfg4 and is_enabled then
		ui.set_visible(aa_init[0].aa_tweaks, false)
		ui.set_visible(aa_init[0].legfucker, true)
		ui.set_visible(aa_init[0].anti_backstab, true)
		ui.set_visible(aa_init[0].fix_hs, true)
		ui.set_visible(aa_init[0].aa_builder, false)
		ui.set_visible(aa_init[0].presets, false)
	else
		ui.set_visible(aa_init[0].legfucker, false)
		ui.set_visible(aa_init[0].anti_backstab, false)
		ui.set_visible(aa_init[0].fix_hs, false)
	end


	if ui.get(aa_init[0].aa_builder) and is_aa and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[i].overridestate,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].overridestate) then
				ui.set_visible(aa_init[i].yawaddl,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawaddr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "Off" and is_aa)

				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aa_static, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "Off" and is_aa)
				ui.set_visible(aa_init[i].aa_static_2, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "Off" and is_aa)

				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].roll, false)
			else
				ui.set_visible(aa_init[i].yawaddl,false)
				ui.set_visible(aa_init[i].yawaddr,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].yawjitteradd,false)
	
				ui.set_visible(aa_init[i].bodyyaw,false)
	
				ui.set_visible(aa_init[i].aa_static,false)
				ui.set_visible(aa_init[i].aa_static_2,false)
	
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitr,false)
				ui.set_visible(aa_init[i].roll,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].overridestate,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawaddl,false)
			ui.set_visible(aa_init[i].yawaddr,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitteradd,false)

			ui.set_visible(aa_init[i].bodyyaw,false)


			ui.set_visible(aa_init[i].aa_static,false)
			ui.set_visible(aa_init[i].aa_static_2,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitr,false)
			ui.set_visible(aa_init[i].roll,false)
		end
	end
end

misc = {}
misc.anti_backstab_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

misc.anti_backstab = function()
    if table_contains(ui.get(aa_init[0].aa_tweaks),"anti-backstab")  then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_backstab_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 150 then
                ui.set(yaw_slider,180)
                ui.set(pitch, "Off")
            end
        end
    end
end


client.set_event_callback("setup_command",misc.anti_backstab)

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
	--states [for searching]'
	if not is_dt and not is_os and not p_still and ui.get(aa_init[0].aa_builder) then
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
	if ui.get(aa_init[0].roll_key) and contains(aa_init[0].antiaim_config, "Keybinds") then
	if var.p_state == 6 then
	 ui.set(ref.roll,ui.get(aa_init[6].roll))
	elseif var.p_state == 1 then
	ui.set(ref.roll,ui.get(aa_init[1].roll))
	elseif var.p_state == 1 then
		ui.set(ref.roll,ui.get(aa_init[7].roll))
	elseif var.p_state == 2 then
		ui.set(ref.roll,ui.get(aa_init[2].roll))
	elseif p_slow and var.p_state ==3 then
		ui.set(ref.roll,ui.get(aa_init[3].roll))
	elseif var.p_state == 4 then
		ui.set(ref.roll,ui.get(aa_init[4].roll))
	elseif var.p_state == 5 then
		ui.set(ref.roll,ui.get(aa_init[5].roll))
	end
end
local e_key = client.key_state(0x45)
        
            if table_contains(ui.get(aa_init[0].aa_tweaks), "anti-aim on use") and e_key then 
                ui.set(ref.bodyyaw[1], "Static")
                ui.set(ref.bodyyaw[2], 180)
			    ui.set(ref.yawjitter[1],"Off")
				ui.set(ref.yaw[1], "Off")
                ui.set(ref.yaw[2], -90)
				ui.set(ref.pitch,"Off")
				ui.set(ref.yawbase,"local view")
                ui.set(ref.fsbodyyaw,false)
    
            else
			ui.set(ref.yaw[1],"180")
			end
        
end




local g_antiaim= {}
g_antiaim.legit = {}
g_antiaim.legit.classnames = {"CWorld","CCSPlayer","CFuncBrush"}

function g_antiaim.legit:get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function g_antiaim.legit:entity_has_c4(ent)
	local bomb = entity_get_all("CC4")[1]
	return bomb ~= nil and entity_get_prop(bomb, "m_hOwnerEntity") == ent
end

client.set_event_callback("setup_command", function(cmd)

    if not table_contains(ui.get(aa_init[0].aa_tweaks), "anti-aim on use") then 
        return
    end
    if table_contains(ui.get(aa_init[0].aa_tweaks), "anti-aim on use") then

  
        local plocal = entity_get_local_player()
		
		local distance = 100
		local bomb = entity_get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(plocal, "m_vecOrigin")
			distance = g_antiaim.legit:get_distance(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity_get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity_get_prop(plocal, "m_bInBombZone")
   
		local has_bomb = g_antiaim.legit:entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not ui.get(aa_init[0].pepefix)
		
		local px, py, pz = client_eye_position()
		local pitch, yaw = client_camera_angles()
	
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client_trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #g_antiaim.legit.classnames do
				if entity_get_classname(entindex) == g_antiaim.legit.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			cmd.in_use = 0
		end
    end
end)



client.set_event_callback("setup_command", function(c)

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
		ui.set(ref.freestand[1], "Off hotkey")
		ui.set(ref.freestand[2], "Default")
	end

	local l = 1

	if table_contains(ui.get(aa_init[0].aa_tweaks),"OS-AA Fix") then
		if is_os and not is_dt and not is_fd then
			ui.set(ref.fakelag[1], math.random(1,3))
		else
			ui.set(ref.fakelag[1], 15)
		end
	end

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
			elseif ui.get(aa_init[0].manual_backward) then
				aa.manaa = 4
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
			elseif ui.get(aa_init[0].manual_backward) then
				aa.manaa = 4
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
			elseif ui.get(aa_init[0].manual_backward) then
				aa.manaa = 4
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
			elseif ui.get(aa_init[0].manual_backward) then
				aa.manaa = 4
				aa.input = globals.curtime()
				
			end
		end

		elseif aa.manaa == 4 then
			if ui.get(aa_init[0].manual_forward) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 4
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_backward) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		end

	if aa.manaa == 1 or aa.manaa == 2 or aa.manaa == 3 or aa.manaa == 4 then
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
		elseif aa.manaa == 4 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], 0)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 0)
			ui.set(ref.fakeyawlimit, 60)
		end
	else
		aa.ignore = false
		ui.set(ref.yawbase, "at targets")
	end


	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aa_static))
		ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
		if ui.get(aa_init[var.p_state].overridestate) and ui.get(aa_init[0].aa_builder) then
            if var.p_state == 6 then
                ui.set(ref.pitch, "Default")
            else
                ui.set(ref.pitch, "Minimal")
            end
			ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitteradd))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].yawaddl) or ui.get(aa_init[var.p_state].yawaddr)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

			if bodyyaw > 0 then
				ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitr))
			elseif bodyyaw < 0 then
				ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
			end
		else
			ui.set(ref.pitch, "Minimal")
			if ui.get(aa_init[0].presets) == "hybrid" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(ref.bodyyaw[1], "jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 38)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -23 or 20))
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
					ui.set(ref.yawjitter[2], 63)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 5 or 12))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 48)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 15))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 53)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			elseif ui.get(aa_init[0].presets) == "tank" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 8 or 19)) --yaw offset left/right
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 71)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], -28)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 13 or 13))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 78)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 6 or 8))
					end
					ui.set(ref.fakeyawlimit, 58)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], -30)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 2 or 36))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 66)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 6 or 8))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], -54)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], -36)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 10 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			end
		end
	end
end)



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

local function renderer_shit(x, y, w, r, g, b, a, edge_h)
	if edge_h == nil then edge_h = 0 end
	local local_player = entity.get_local_player()
	local velocity = string.format('%.2f', vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d())		
	local pos_x, pos_y, pos_z = entity.get_origin(local_player)
	renderer.rectangle(x+2, y-2, w-5, 2.5, 15, 15, 15, 120)
	renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 200)
	renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 200)
	renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 120)
	renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 120)
	renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 200)
	renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 120)
	renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 200)
	renderer.rectangle(x+2, y, w-5, 16, 0, 0, 0, 255)
	local me = entity.get_local_player()
	local desync_type = antiaim_funcs.get_overlap(float)
	local r,g,b = ui.get(asd.main_clr)
	local hex = RGBtoHEX(r,g,b)

	if not entity.is_alive(me) then return end
	--renderer.gradient(x-3, y+8, 2, 4+edge_h, r, g, b, a, r, g, b, 0, false)
	-- renderer.gradient(x+w+1, y+8, 2, 4+edge_h, r, g, b, a, r, g, b, 0, false)
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

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * globals.frametime() * speed 
    else 
        return name - (value + name) * globals.frametime() * speed -- add / 2 if u want goig back effect

    end
end
local xpos = 0



local function draw()

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(asd.Arrows_clr)
	local v1,v2,v3,v4 = ui.get(asd.grdnt_clr)
	local tk,c9,ql,jj = ui.get(asd.debug_clr)
	local pn, zh, vx, iw = ui.get(asd.mierdacolor)
	local fh, qn, px, wa = ui.get(asd.Bold_clr)
	


	local x, y = client.screen_size()

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end
	
	
	local scpd = entity.get_prop(me, "m_bIsScoped")
	local scoped_default = ui.get(asd.inds_selct) == "Bold" and scpd == 1
	xpos = animation(scoped_default, xpos, 15, 10)

	
	
	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(aa_init[0].fs)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=0, 255, 20,255 elseif is_os then dr,dg,db,da=255,0,0,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
	--sine_in
	value = value + globals.frametime() * 9

	local _, y2 = client.screen_size()

	local state = "MOVING"

	--states [for searching]
	if ui.get(aa_init[0].aa_stc_tillhit) then
		if brute.can_hit == 0 then
			state = "INACTIVE"
		end
	else
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 and ui.get(aa_init[0].aa_builder) then
			state = "fakelag"
		elseif var.p_state == 5 then
			state = "crouching"
		elseif var.p_state == 6 then
			state = "air-duck"
		elseif var.p_state == 4 then
			state = "air"
		elseif var.p_state == 3 then
			state = "slow-motion"
		elseif var.p_state == 1 then
			state = "standing"
		elseif var.p_state == 2 then
			state = "moving"
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

	--asd.animasiones :v:v
local me = entity_get_local_player()
   
    local rounding = 4
    local o = 20
    local rad = rounding + 2
    local n = 45
    local velocity_x, velocity_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local velocity = math.sqrt(velocity_x^2 + velocity_y^2)
    local offset = (400 - velocity)/400*60
    local screen = {client.screen_size()}
    local center = {screen[1] / 2, screen[2] / 2}
        local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,570,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
    local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.65,1) end
    local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,140)renderer.circle_outline(x+radius,y+radius,r,g,b,140,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,140,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,140)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,140)renderer.circle_outline(x+radius,y+h-radius,r,g,b,140,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,140,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,140) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
    local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,18,18,18,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end
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
local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 3) * 3) * 75 + 150), 255)
  local scrsize_x, scrsize_y = client.screen_size()
  local center_x, center_y = scrsize_x / 2, scrsize_y / 2.003
  if ui.get(asd.wtmrk) then
				 local SM4 = gradient_text(255, 255, 255, 255, v1, v2, v3, v4, '~ future yaw anti-aim systems ' )  

				  renderer.text(center_x-955 , center_y  - 18, 255, 255, 255, 255, '', 0, SM4)
				  renderer.text(center_x-805 , center_y - 18 , 255, 255, 255, alpha_pulse,  '', 0, '['..obex_data.build..']')
  end


	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<19 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if ui.get(asd.inds_selct) == "Ideal Yaw" then
        local add_y=0
		if is_dt then

	        renderer.text(x / 2 +1, y / 2 + 48 + add_y , dr, dg, db, dt_a, "", 0, "DT")
			add_y=add_y+11
		else
			if is_os then

				renderer.text(x / 2 +1, y / 2 + 48 + add_y, 209, 139, 230, 255,  "", 0, "OS")
				
			end
		end


		
        --renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 10, 255, 255, 255, fs_a, "c-", fs_w, "FS")

        local wx, wy = client.screen_size()

        --round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

        local desync_type = antiaim_funcs.get_overlap(float)
        local desync_type2 = antiaim_funcs.get_desync(2)

        renderer.text(x / 2 + 1 , y / 2 + 28, 218, 118, 0, 255, "", 0, 'FUTURE.TECH')
        renderer.text(x / 2 + 1 , y / 2 + 38, 209, 139, 230, 255, "", 0, 'DYNAMIC')
    end

	if ui.get(asd.inds_selct) == "Modern"   then 
 		local wx, wy = client.screen_size()
		local add_y=0
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
		
		local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
		local side = bodyyaw > 0 and 1 or -1
		local pep="0"
		if side == 1 then
		pep = "L"
		elseif side == -1 then
		pep = "R"
		end
		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		

		renderer.text(x / 2 - 5 +5, y / 2 + 24, 255,255,255, 255, "-", 0, 'FUTURE')
		renderer.text(x / 2 + 26 +3, y / 2 + 24.9, 255, 161, 161, alpha_pulse, "-", 0, 'YAW')
		renderer.text(x / 2 -5 + 5, y / 2 + 32, 142, 165, 229, 255, "-", 0, 'FAKE YAW:')
		renderer.text(x / 2 + 32 +5, y / 2 + 32, 255, 255, 255, 255, "-", 0, ""..pep.."")
		
	
	
		if is_dt then

	    renderer.text(x / 2 + 4, y / 2 + 46 , dr, dg, db, dt_a, "c-", 0, "DT")
		add_y=add_y+10
		else
			if is_os then

				renderer.text(x / 2 + 5, y / 2 + 46 + add_y, 255, 217, 217, 255, "c-", 0, "OS")
				add_y=add_y+10
			end
		end


		

		renderer.text(x / 2+ 24 +xpos, y / 2  + 46 + add_y , br, bg, bb, ba, "c-", 0, "BAIM")
		renderer.text(x / 2+40 +xpos, y / 2  + 46 + add_y , sr, sg, sb, sa, "c-", 0, "SP")
		renderer.text(x / 2+50 +xpos, y / 2  + 46 + add_y , fr, fg, fb, fa, "c-", 0, "FS")
	end


	if ui.get(asd.inds_selct) == "Bold"   then 



	end


	if ui.get(asd.inds_selct) == "Bold"   then 
		local wx, wy = client.screen_size()
	   local add_y=0
	   --round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
	   
	   local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	   local side = bodyyaw > 0 and 1 or -1
	   local pep="0"
	   if side == 1 then
	   pep = "futu            "
	   elseif side == -1 then
	   pep = "     reyaw"--done
	   end
	   local desync_type = antiaim_funcs.get_overlap(float)
	   local desync_type2 = antiaim_funcs.get_desync(2)
	   local SM4 = gradient_text(255, 255, 255, 255, v1, v2, v3, v4, 'futureyaw')  

	   renderer.text(x/ 2 + 15 + xpos, y/2 + 20 , 255, 255, 255, 255, 'bc', 0, SM4)
	


	   
   
   
	   if is_dt then

	   renderer.text(x / 2 - 12 + xpos, y / 2 + 32 + add_y, fh, qn, px, wa, "l-", 0, "DOUBLETAP")
	   add_y=add_y+10
	   end
	   if is_os then

		renderer.text(x / 2 - 12 + xpos, y / 2 + 32 + add_y, fh, qn, px, wa, "l-", 0, "OS-AA")
		add_y=add_y+10
		
		end

	   if is_ba then

		renderer.text(x / 2 - 13 + xpos, y / 2  + 32 + add_y, fh, qn, px, wa, "l-", 0, " BAIM")
		add_y=add_y+10
		
	   end
	   
	   if is_fs then

		renderer.text(x / 2 - 12 + xpos, y / 2  + 32 + add_y, fh, qn, px, wa, "l-", 0, "FS")
		add_y=add_y+10
		
	end

	if is_qp then 

		renderer.text(x / 2 - 12 + xpos, y / 2  + 32 + add_y, fh, qn, px, wa, "l-", 0, "QP")
		add_y=add_y+10
		
	
end



   end

	if ui.get(asd.inds_selct) == "Gradient"   then 
		local wx, wy = client.screen_size()
	   local add_y=0
	   --round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
	   local side = bodyyaw > 0 and 1 or -1
	   local pep="0"
	   if side == 1 then
	   pep = "L"
	   elseif side == -1 then
	   pep = "R"
	   end
	   local desync_type = antiaim_funcs.get_overlap(float)
	   local desync_type2 = antiaim_funcs.get_desync(2)
	   

	   renderer.text(x / 2 - 5 +-11, y / 2 + 23, 255,255,255, 255, "-", 0, 'FUTURE')
	   --1
	   renderer.gradient(x/2 - 30, y/2 + 35, 30, 2, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255)
	   renderer.gradient(x/2, y/2 + 35, 30, 2, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255)
	   --2
	   renderer.gradient(x/2, y/2 + 35, 0 -(math.abs(bodyyaw*30/58)), 2, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw )
	   renderer.gradient(x/2 , y/2 + 35, 0 + (math.abs(bodyyaw*30/58)), 2, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw )

	 
	   
   
   
	   if is_dt then

	   renderer.text(x / 2 + -1 +-2, y / 2 + 45 + add_y, dr, dg, db, dt_a, "c-", 0, "DT")
	   add_y=add_y+10
	   end

	   renderer.text(x / 2 - 25, y / 2  + 45 + add_y ,sr, sg, sb, sa, "c-", 0, "SP")
	   renderer.text(x / 2+18 + xpos, y / 2  + 45 + add_y , br, bg, bb, ba, "c-", 0, "BAIM")
	   renderer.text(x / 2+ 40 + xpos, y / 2  + 45 + add_y , fr, fg, fb, fa, "c-", 0, "FS")
	   
   end

   if ui.get(asd.inds_selct) == "LGBTQ+" then

   local putalawea="U_U"
   if var.p_state == 2 then
   putalawea = ">///<"
   elseif var.p_state == 4 then
   putalawea = "UWU"
elseif var.p_state == 6 then
	putalawea = "U///U"
elseif var.p_state == 1 then
	putalawea = ">_<"
elseif var.p_state == 3 then
	putalawea = "OWO"
   end


   renderer.text(x / 2 + 0, y / 2 + 25, 242, 176, 255, 255, "bc", 0, 'TORONJAPEEK')
   renderer.text(x / 2 + 0, y / 2 + 45, 255, 255, 255, 255, "c", 0, ""..putalawea.."")
   renderer.gradient(x/2 - 30, y/2 + 35, 30, 2, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255)
   renderer.gradient(x/2, y/2 + 35, 30, 2, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255, 40,40,40, 255)
   renderer.gradient(x/2, y/2 + 35, -38, 2, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw )
   renderer.gradient(x/2 , y/2 + 35, 40, 2, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw, pn, zh, vx, iw )


end



	local localp = entity.get_local_player()

	local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60

	if ui.get(asd.debugpene) then
		local wx, wy = client.screen_size()
		local add_y=0
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
		
		local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
		local side = bodyyaw > 0 and 1 or -1
		local pep="0"
		if side == 1 then
		pep = "<"
		elseif side == -1 then
		pep = ">"
		end
		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		local desync_amount = antiaim_funcs.get_desync(2)
		local mierda = antiaim_funcs.get_body_yaw(1)
		local target = tostring(entity.get_player_name(client.current_threat())):lower()
		if desync_amount < 0 then
			desync_amount = desync_amount+100/120
		end
		local caca = string.format("%0.f", desync_amount)
	

		renderer.text(x / 2 -5 + -940, y / 2 + 0, 255, 255, 255, 255, "", 0, 'future.tech -')
		renderer.text(x / 2 -5 + -878, y / 2 + 0, tk,c9,ql ,jj,  "", 0, ' '..obex_data.username..' ')
		renderer.text(x / 2 -5 + -940, y / 2 + 12, 255, 255, 255, 255, "", 0, 'current build:')
		renderer.text(x / 2 -5 + -876, y / 2 + 12, tk,c9,ql , alpha_pulse, "", 0, ' '..obex_data.build..' ')
		renderer.text(x / 2 -5 + -940, y / 2 + 24, 255, 255, 255, 255, "", 0, 'desync delta:')
		renderer.text(x / 2 -5 + -873, y / 2 + 24, tk,c9,ql ,jj, "", 35, '('..caca..'°) ')
		renderer.text(x / 2 -5 + -940, y / 2 + 36, 255, 255, 255, 255, "", 0, 'player state:')
		renderer.text(x / 2 -5 + -880, y / 2 + 36, tk,c9,ql ,jj,  "", 0, ' '..state..' ')
		renderer.text(x / 2 -5 + -940, y / 2 + 48, 255, 255, 255, 255, "", 0, 'target:')
		renderer.text(x / 2 -5 + -904, y / 2 + 48, tk,c9,ql ,jj, "", 0, ''..target..' ')





		local localp = entity.get_local_player()

		local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60


	end
	
		if ui.get(asd.arrw_selct) == "teamskeet" then
			
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
	-- ⯇ ⯈ ⯅ ⯆
	if ui.get(asd.arrw_selct) == "normal" then
		if aa.manaa == 1 then 
		renderer.text(x / 2 - 70, y / 2 , mr,mg,mb, 255, "c", 0, '❰')
		end
		
		if aa.manaa == 2 then
		renderer.text(x / 2 + 70, y / 2 , mr,mg,mb, 255, "c", 0, '❱')
	end
end
	

	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)
end

local cfg_stuff = {}
local encode_and_decode = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

cfg_stuff.encode = function(data)
    return ((data:gsub(".", function(x)
        local r,encode_and_decode= '', x:byte()
        for i=8,1,-1 do r=r..(encode_and_decode%2^i-encode_and_decode%2^(i-1)>0 and "1" or "0") end
        return r;
    end).."0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=="1" and 2^(6-i) or 0) end
        return encode_and_decode:sub(c+1,c+1)
    end)..({ "", "==", "=" })[#data%3+1])
end

cfg_stuff.decode = function(data)
    data = string.gsub(data, "[^"..encode_and_decode.."=]", "")
    return (data:gsub(".", function(x)
        if (x == "=") then return "" end
        local r,f="",(encode_and_decode:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and "1" or "0") end
        return r;
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if (#x ~= 8) then return "" end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=="1" and 2^(8-i) or 0) end
            return string.char(c)
    end))
end
--config system semelmo

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(cfg_stuff.encode(json.stringify(settings)))
	future_push:paint(4, "Successfully exported settings to clipboard")
end

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "Export to clipboard", export_config)

local function import_config(text)

	local settings = json.parse(cfg_stuff.decode(clipboard.get(text)))
    if settings == nil then 
    	future_push:paint(4, "Failed to load settings")
	else
	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	future_push:paint(5, "Successfully imported settings from clipboard")
    end
end

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "Import from clipboard", import_config)



local function on_console_input(input)
if string.find(input, "//export") then
	export_config()
end

if string.find(input, "//import") then
	import_config()
end

if string.find(input, "//load_default") then
	default_config("eyJNIjp7InNpZGVfZmFrZSI6ImxlZnQiLCJhYV9zdGF0aWMiOjAsImJvZHl5YXciOiJqaXR0ZXIiLCJmYWtleWF3bGltaXQiOjYwLCJ5YXdqaXR0ZXJhZGQiOjcyLCJhYV9zdGF0aWNfMiI6MCwieWF3YWRkciI6OCwieWF3aml0dGVyIjoiY2VudGVyIiwicm9sbCI6MCwic2lkZV9ib2R5IjoibGVmdCIsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwieWF3YWRkbCI6LTUsImFudGlfYmYiOnRydWUsImZha2V5YXdsaW1pdHIiOjYwfSwiUyI6eyJzaWRlX2Zha2UiOiJsZWZ0IiwiYWFfc3RhdGljIjowLCJib2R5eWF3Ijoiaml0dGVyIiwiZmFrZXlhd2xpbWl0Ijo2MCwieWF3aml0dGVyYWRkIjo0MiwiYWFfc3RhdGljXzIiOjAsInlhd2FkZHIiOjEyLCJ5YXdqaXR0ZXIiOiJjZW50ZXIiLCJyb2xsIjowLCJzaWRlX2JvZHkiOiJsZWZ0IiwiZW5hYmxlX3N0YXRlIjp0cnVlLCJ5YXdhZGRsIjotNSwiYW50aV9iZiI6dHJ1ZSwiZmFrZXlhd2xpbWl0ciI6NjB9LCJGTCI6eyJzaWRlX2Zha2UiOiJsZWZ0IiwiYWFfc3RhdGljIjowLCJib2R5eWF3Ijoib2ZmIiwiZmFrZXlhd2xpbWl0Ijo2MCwieWF3aml0dGVyYWRkIjowLCJhYV9zdGF0aWNfMiI6MCwieWF3YWRkciI6MCwieWF3aml0dGVyIjoib2ZmIiwicm9sbCI6MCwic2lkZV9ib2R5IjoibGVmdCIsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsInlhd2FkZGwiOjAsImFudGlfYmYiOmZhbHNlLCJmYWtleWF3bGltaXRyIjo2MH0sIkFDIjp7InNpZGVfZmFrZSI6ImxlZnQiLCJhYV9zdGF0aWMiOjAsImJvZHl5YXciOiJqaXR0ZXIiLCJmYWtleWF3bGltaXQiOjYwLCJ5YXdqaXR0ZXJhZGQiOjQ3LCJhYV9zdGF0aWNfMiI6MCwieWF3YWRkciI6OCwieWF3aml0dGVyIjoiY2VudGVyIiwicm9sbCI6MCwic2lkZV9ib2R5IjoibGVmdCIsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwieWF3YWRkbCI6LTE0LCJhbnRpX2JmIjp0cnVlLCJmYWtleWF3bGltaXRyIjo2MH0sIkMiOnsic2lkZV9mYWtlIjoibGVmdCIsImFhX3N0YXRpYyI6MCwiYm9keXlhdyI6ImppdHRlciIsImZha2V5YXdsaW1pdCI6NjAsInlhd2ppdHRlcmFkZCI6MzcsImFhX3N0YXRpY18yIjowLCJ5YXdhZGRyIjoxNywieWF3aml0dGVyIjoiY2VudGVyIiwicm9sbCI6MCwic2lkZV9ib2R5IjoibGVmdCIsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwieWF3YWRkbCI6LTI2LCJhbnRpX2JmIjpmYWxzZSwiZmFrZXlhd2xpbWl0ciI6NjB9LCJBIjp7InNpZGVfZmFrZSI6ImxlZnQiLCJhYV9zdGF0aWMiOjAsImJvZHl5YXciOiJqaXR0ZXIiLCJmYWtleWF3bGltaXQiOjYwLCJ5YXdqaXR0ZXJhZGQiOjUxLCJhYV9zdGF0aWNfMiI6MCwieWF3YWRkciI6MTcsInlhd2ppdHRlciI6ImNlbnRlciIsInJvbGwiOjAsInNpZGVfYm9keSI6ImxlZnQiLCJlbmFibGVfc3RhdGUiOnRydWUsInlhd2FkZGwiOi0xMCwiYW50aV9iZiI6ZmFsc2UsImZha2V5YXdsaW1pdHIiOjYwfSwiU1ciOnsic2lkZV9mYWtlIjoibGVmdCIsImFhX3N0YXRpYyI6MCwiYm9keXlhdyI6Im9mZiIsImZha2V5YXdsaW1pdCI6NjAsInlhd2ppdHRlcmFkZCI6MCwiYWFfc3RhdGljXzIiOjAsInlhd2FkZHIiOjAsInlhd2ppdHRlciI6Im9mZiIsInJvbGwiOjAsInNpZGVfYm9keSI6ImxlZnQiLCJlbmFibGVfc3RhdGUiOmZhbHNlLCJ5YXdhZGRsIjowLCJhbnRpX2JmIjpmYWxzZSwiZmFrZXlhd2xpbWl0ciI6NjB9fQ==")
end


end
client.set_event_callback("console_input", on_console_input)


local function config_menu()
	local is_enabled = ui.get(lua_enable)
	local is_aa = ui.get(aa_init[0].lua_select) == "anti-aim"
	local is_prst = ui.get(aa_init[0].lua_select) == "presets"
	local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "misc"
	local is_alpha = ui.get(aa_init[0].lua_select) == "alpha"


	if is_aa and is_enabled then
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
	end

if ui.get(aa_init[0].aa_builder) and is_aa and is_enabled then
	ui.set_visible(export_btn, true)
	ui.set_visible(import_btn, true)
else
	ui.set_visible(export_btn, false)
	ui.set_visible(import_btn, false)
end

if is_vis and is_enabled then
	ui.set_visible(export_btn, false)
	ui.set_visible(import_btn, false)
else
end


if is_misc and is_enabled then
	ui.set_visible(export_btn, false)
	ui.set_visible(import_btn, false)

else
end
if is_alpha and is_enabled then
	ui.set_visible(export_btn, false)
	ui.set_visible(import_btn, false)

else
end

end
client.set_event_callback("paint", config_menu)
client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
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

local function main()
	client.set_event_callback("run_command", function()
		get_best_enemy()
		get_best_angle()
	end)


	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			future_push:paint(5, "Reseted data due to death")
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
		future_push:paint(5, "Reset data due to new round")
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		future_push:paint(5, "Reset data due to new map")
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


--LOGS XDXD
local client_camera_angles, client_create_interface, client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_name, entity_get_prop, entity_is_alive, globals_chokedcommands, globals_realtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, string_format, string_lower, table_concat, table_insert, ui_new_checkbox, ui_reference, error, pairs, plist_get, ui_get, print, ui_set_callback = client.camera_angles, client.create_interface, client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_name, entity.get_prop, entity.is_alive, globals.chokedcommands, globals.realtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, string.format, string.lower, table.concat, table.insert, ui.new_checkbox, ui.reference, error, pairs, plist.get, ui.get, print, ui.set_callback

local ffi = require 'ffi'
local vector = require 'vector'
local inspect = require 'gamesense/inspect'

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local prefer_safe_point = ui_reference('RAGE', 'Aimbot', 'Prefer safe point')
local force_safe_point = ui_reference('RAGE', 'Aimbot', 'Force safe point')

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local classes = {
    net_channel = function()
        local this = { }

        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client_create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local net_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client_set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
        
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
        
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
        
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
        
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    aimbot = function(net_channel)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist_get(target, 'Override safe point')
            local ui_safety = { ui_get(prefer_safe_point), ui_get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                        spread_angle = vector(aim-shot):length2d()
                    break
                end
            end

            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity_get_local_player()
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
        
                handle_time = globals_realtime(),
                self_choke = globals_chokedcommands(),
        
                flags = {
                    boosted = e.boosted
                },

                safety = get_safety(e, p_ent),
                correction = plist_get(p_ent, 'Correction active'),
        
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client_eye_position()),
                view = vector(client_camera_angles()),
        
                velocity_modifier = entity_get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity_get_prop(me, 'm_totalHitsOnServer'),

                history = globals.tickcount() - e.tick
            }
        end
        
        this.missed = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            
            local net_data = net_channel:get()
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string_format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math_abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math_abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            
            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
        
            local reasons = {
                ['event_timeout'] = function()
                    print(string_format(
                        'Missed %s shot due to event timeout [%s] [%s]', 
                        shot_id, target_name, net_state
                    ))
                end,

                ['death'] = function()
					 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death [dropped: %d ]', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets
                    ))
					end
					 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Pop Up") then
					 
					  future_push:paint(5,string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death ', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets
                    ))
					end
                end,
        
                ['prediction_error'] = function(type)

                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
					 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [bt: %d ]', 
                        shot_id, target_name, hgroup, hit_chance, type, net_state, pre_data.history
                    ))
					end
					 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Pop Up") then
					 future_push:paint(5,string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error ', 
                        shot_id, target_name, hgroup, hit_chance, type
                    ))
					end
                end,
        
                ['spread'] = function()
				 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread ( damage: %d | bt: %d )',
                        shot_id, target_name, hgroup, hit_chance, spread_angle, 
                        pre_data.original.damage, pre_data.history
                    ))
					end
					 if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Pop Up") then
					 future_push:paint(5,string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread ',
                        shot_id, target_name, hgroup, hit_chance, spread_angle 
                        
                    ))
					end
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string_format('unknown [angle: ?° | ?°]')
                    }
					if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | bt: %d  )',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history
                    ))
					end
					 if juan and martina then
					  future_push:paint(5,string_format(
                        'oe los sus ',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown']
                        
                    ))
					end
                end
				
            }
        
            local post_data = {
                event_timeout = (globals_realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= entity_get_prop(me, 'm_totalHitsOnServer'),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local p_ent = e.target

            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)

            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'

            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            local _verification = function()
                local text = ''

                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage
        
                if hg_diff or dmg_diff then
                    text = string_format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''

                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                            return addr
                        end)()
                    )
                end

                return text
            end
            if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Console") then
            print(string_format(
                'Fired %s shot in %s %s for %d damage ( hc: %d%% | bt: %d )',
                shot_id, target_name, hgroup, e.damage,
                hit_chance, pre_data.history, _verification()
            ))
            end

            if ui.get(asd.amb_logger) and contains(asd.displaypepe, "Pop Up") then

            future_push:paint(5, string_format(
                'Fired %s shot in %s %s for %d damage ',
                shot_id, target_name, hgroup, e.damage

         ))
		end
        end
        
        this.bullet_impact = function(e)
            local tick = globals_tickcount()
            local me = entity_get_local_player()
            local user = client_userid_to_entindex(e.userid)
            
            if user ~= me then
                return
            end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client_eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
        
            if net_data == nil then
                return
            end

            if not net_channel.is_valid_packet then
                for id in pairs(aim_data) do
                    table_insert(aim_data[id].dropped_packets, net_channel.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local aimbot = classes.aimbot(net_channel)

local g_player_hurt = function(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
	
    if attacker_id == nil or attacker_id ~= entity_get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
	
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client_userid_to_entindex(e.userid)
		local target_name = entity_get_player_name(target_id)

		print(string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
	end
end

local interface_callback = function(c)
    local addr = not ui_get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']

    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui_set_callback(asd.amb_logger, interface_callback)
interface_callback(asd.amb_logger)

--asd.animasiones nuebas :v
client.set_event_callback("pre_render", function()

    if table_contains(ui.get(asd.animasion),"Static Legs In Air") then 
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	else
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0) 
    end
	
	if entity.is_alive(entity.get_local_player()) then
	
		if table_contains(ui.get(asd.animasion),"Pitch Zero on Land") then 
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
end end)

client.set_event_callback("net_update_end", function()
	if ui.get(asd.animasion) then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
	end
end)

client.set_event_callback("run_command", function(ctx)
    if table_contains(ui.get(aa_init[0].aa_tweaks), "leg fucker") then
	p = client.random_int(1, 3)
	if p == 1 then
		ui.set(slidewalk, "Off")
	elseif p == 2 then
       ui.set(slidewalk, "Always slide")
    elseif p == 3 then
		ui.set(slidewalk, "Off")
    end
    ui.set_visible(slidewalk, false)
else
    ui.set_visible(slidewalk, true)
end
end)




