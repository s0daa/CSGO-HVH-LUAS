-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server


client.exec("clear");
print("░██╗░░░░░░░██╗██╗███╗░░██╗██████╗░██████╗░░█████╗░████████╗██╗░░██╗░░░██╗░░░░░██╗░░░██╗░█████╗░")
print("░██║░░██╗░░██║██║████╗░██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║░░██║░░░██║░░░░░██║░░░██║██╔══██╗")
print("░╚██╗████╗██╔╝██║██╔██╗██║██║░░██║██████╔╝███████║░░░██║░░░███████║░░░██║░░░░░██║░░░██║███████║")
print("░░████╔═████║░██║██║╚████║██║░░██║██╔══██╗██╔══██║░░░██║░░░██╔══██║░░░██║░░░░░██║░░░██║██╔══██║")
print("░░╚██╔╝░╚██╔╝░██║██║░╚███║██████╔╝██║░░██║██║░░██║░░░██║░░░██║░░██║██╗███████╗╚██████╔╝██║░░██║")
print("░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚══════╝░╚═════╝░╚═╝░░╚═╝")
print("                                                                                      ")
print("██████╗░███████╗░██████╗████████╗  ██╗░░░░░██╗░░░██╗░█████╗░  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗")
print("██╔══██╗██╔════╝██╔════╝╚══██╔══╝  ██║░░░░░██║░░░██║██╔══██╗  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝")
print("██████╦╝█████╗░░╚█████╗░░░░██║░░░  ██║░░░░░██║░░░██║███████║  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░")
print("██╔══██╗██╔══╝░░░╚═══██╗░░░██║░░░  ██║░░░░░██║░░░██║██╔══██║  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░")
print("██████╦╝███████╗██████╔╝░░░██║░░░  ███████╗╚██████╔╝██║░░██║  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░")
print("╚═════╝░╚══════╝╚═════╝░░░░╚═╝░░░  ╚══════╝░╚═════╝░╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░")
print("                                                                                     ")
print("░██████╗░░█████╗░███╗░░░███╗███████╗░██████╗███████╗███╗░░██╗░██████╗███████╗")
print("██╔════╝░██╔══██╗████╗░████║██╔════╝██╔════╝██╔════╝████╗░██║██╔════╝██╔════╝")
print("██║░░██╗░███████║██╔████╔██║█████╗░░╚█████╗░█████╗░░██╔██╗██║╚█████╗░█████╗░░")
print("██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░░╚═══██╗██╔══╝░░██║╚████║░╚═══██╗██╔══╝░░")
print("╚██████╔╝██║░░██║██║░╚═╝░██║███████╗██████╔╝███████╗██║░╚███║██████╔╝███████╗")
print("░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░╚══════╝╚═╝░░╚══╝╚═════╝░╚══════╝")
local anti_aim = require 'gamesense/antiaim_funcs'
local csgo_weapons = require 'gamesense/csgo_weapons'
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
client.exec("playvol \"survival/buy_item_01.wav\" 1");

local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFWin\aFFFFFFFFdrath.\aA7D42EFFlua")

local anim = { }

local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

local double_tap = { ui.reference("RAGE", "Other", "Double tap") }
local hide_shots = { ui.reference("AA", "Other", "On shot anti-aim") }

local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = {ui.reference("AA", "Anti-aimbot angles", "Edge yaw")},
	maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
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

local var = {
	p_states = {"Standing", "Moving", "Slow Motion", "Air", "Duck", "Air + C", "FakeLag"},
	s_to_int = {["Air + C"] = 6,["FakeLag"] = 7, ["Standing"] = 1, ["Moving"] = 2, ["Slow Motion"] = 3, ["Air"] = 4, ["Duck"] = 5},
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

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFTab \aA7D42EFFSelection", "Anti-Aim", "Anti-Bruteforce", "Visuals", "Other", "Colors"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Aim \aA7D42EFFMode", "Adaptive", "Agressive"),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles","\aFFFFFFFFEnable \aA7D42EFFAnti-Bruteforce"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFLocal Yaw \aA7D42EFF(Left)"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFLocal Yaw \aA7D42EFF(Right)"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFLocal Yaw \aA7D42EFF(Forward)"),
--s	edgeyaw = ui.new_checkbox("AA", "Anti-aimbot angles", "Edge yaw"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFLocal Yaw \aA7D42EFF(Freestand)"),
	legit_e_key = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFLocal Yaw \aA7D42EFF(Legit AA)"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable \aA7D42EFF(Custom Anti-Aim Builder)"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "Conditions", "Standing", "Moving", "Slow Motion", "Air", "Duck", "Air + C", "FakeLag"),
}


local function print_welcome(x)
	client.color_log(255, 255, 255, "Windrath \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "Hello \0")
	client.color_log(192, 187, 255, "Windrath.lua")
	--return client.color_log(200, 200, 200, " " .. x)
end

local function print_error(x)
	client.color_log(192, 187, 255, "Windrath \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "error \0")
	client.color_log(155, 155, 155, "-> \0")
	return client.color_log(255, 150, 150, " " .. x)
end

--#region "visuals indicators whatever"
local watermark_tgl = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFalpha Panel")
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFAnti-Aim Crosshair Indicators")
local inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFUnder Crosshair \aA7D42EFFIndicators List", { "Windrath Advanced", "Windrath Modern" })
local manaa_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFManual Anti-Aim Arrows")
local arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFArrows \aA7D42EFFType", { "Default", "TEAMSKEET", "XO-YAW" })
local under_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Under Crosshair Color")
local under_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Under Crosshair Color", 167, 212, 46, 255)
local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Active Arrows Color")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Active Arrows Color", 167, 212, 46, 255)
local main_clr_l2 = ui.new_label("AA", "Anti-aimbot angles", "Background Arrows Color")
local main_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "main \aA7D42EFFcolor", 0, 0, 0, 255)
local ab_clr_l2 = ui.new_label("AA", "Anti-aimbot angles", "Anti-Bruteforce Color")
local ab_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Anti-Bruteforce Color", 167, 212, 46, 255)
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFAnti-Backstab")
local fast_switch_on = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFFast Weapon Switch")
local trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable \aA7D42EFFKill Say")
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Backstab \aA7D42EFFDistans",150,300,150,true,"unit")
local legszz = ui.new_multiselect("AA", "Anti-aimbot angles", "\aFFFFFFFFAnimation \aA7D42EFFBreaker", "Static Leg In Air", "Jitter Leg On Ground")

for i=1, 7 do
	aa_init[i] = {
		enable_state =  ui.new_checkbox("AA", "Anti-aimbot angles", " ".. "\aA7D42EFF"..var.p_states[i].." Settings"),
		yawaddl = ui.new_slider("AA", "Anti-aimbot angles", "\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 yaw left\n", -180, 180, 0),
		yawaddr = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 yaw right\n", -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 yaw jitter\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 yaw jitter add\n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 body options\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		side_body = ui.new_combobox("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 body-side\n" .. var.p_states[i], { "left", "right" }),
		aa_static = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 body left\n", -180, 180, 0),
		aa_static_2 = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 body right\n", -180, 180, 0),
		side_fake = ui.new_combobox("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 fake limit-side\n" .. var.p_states[i], { "left", "right" }),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 fake limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 fake limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		roll = ui.new_slider("AA", "Anti-aimbot angles","\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 Roll \n".. var.p_states[i], -50, 50, 0, true, "°"),
		anti_bf =  ui.new_checkbox("AA", "Anti-aimbot angles", "\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 Anti-Bruteforce"),
		hybrid_fs =  ui.new_checkbox("AA", "Anti-aimbot angles", "\aA7D42EFF"..var.p_states[i].."\aFFFFFFC9 Freestand"),
	}
end


local switchtick = nil
local weaponselect = false
function foo(e)
    if not ui.get(fast_switch_on) then return end

    if e.weaponselect ~= 0 then
        local weapon = csgo_weapons(e.weaponselect)
        if weapon.type == "equipment" or weapon.type == "grenade" or weapon.type == "knife" then return end
        
        ui.set(double_tap[1], false)
        ui.set(hide_shots[1], false)
        
        
        switchtick = globals.tickcount()
    end

    --e.force_defensive = weaponselect or (switchtick ~= nil)
end
client.set_event_callback("setup_command", foo)

local shifttime = nil
function bar()
    local player = entity.get_local_player()
    local weapon = entity.get_player_weapon(player)
    local nextPrimaryAttack = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    local nextAttack = entity.get_prop(player, "m_flNextAttack")

    if switchtick ~= nil then
        if shifttime == nil then shifttime = anti_aim.get_tickbase_shifting() * globals.tickinterval() end
        
        if (globals.tickcount() - switchtick) > 8 then
            nextPrimaryAttack = nextPrimaryAttack - shifttime
            nextAttack = nextAttack - shifttime
            --entity.set_prop(weapon, "m_flNextPrimaryAttack", nextPrimaryAttack)
            --entity.set_prop(player, "m_flNextAttack", nextAttack)
            switchtick = nil
            shifttime = nil
            weaponselect = true
        end
    end

    if weaponselect and nextAttack <= globals.curtime() and nextPrimaryAttack <= globals.curtime() then
        ui.set(double_tap[1], true)
        ui.set(hide_shots[1], true)
        weaponselect = false
    end
end
client.set_event_callback("net_update_start", bar)

function onfire()
    ui.set(double_tap[1], true)
    ui.set(hide_shots[1], true)
    weaponselect = false
end
client.set_event_callback("aim_fire", onfire)

function onbullet(b)
    if entity.get_local_player() == client.userid_to_entindex(b.userid) then
        ui.set(double_tap[1], true)
        ui.set(hide_shots[1], true)
        weaponselect = false
    end
end
client.set_event_callback("bullet_impact", onbullet)



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
	--ui.set_visible(ref.edgeyaw, state)
end

_G.windrath_push=(function()
	_G.windrath_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.windrath_notify_cache;
			for g=#f,1,-1 do
				_G.windrath_notify_cache[g].time=_G.windrath_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.windrath_notify_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1 and 1 or k;
				if j.time<1 or k<1 then
					i=(k<1 and k or j.time)/1;
					i2=(k<1 and k or j.time)/1;
					h=i*255;
					lerpy=i*150;
					lerp_circ=i*0.5
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"[windrath]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[windrath]")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
			local c1,c2,c3,c4 = ui.get(ab_clr2)
			local x, y = client.screen_size()

			renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,18, 7, 8,h>255 and 255 or h)
			renderer.circle(p[1]-1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 180, 0.5)
			renderer.circle(p[1]+m[1]+1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 0, 0.5)
			renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil," [windrath] ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;


function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.windrath_notify_cache[g]=_G.windrath_notify_cache[g-1]
	end;
	_G.windrath_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

windrath_push:paint(4," Hello: Admin. Thx for using Windrath.lua - Good Luck")

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
	local is_aa = ui.get(aa_init[0].lua_select) == "Anti-Aim"
	local is_ab = ui.get(aa_init[0].lua_select) == "Anti-Bruteforce"
	local is_vis = ui.get(aa_init[0].lua_select) == "Visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "Other"
	local is_color = ui.get(aa_init[0].lua_select) == "Colors"
	local is_knife = ui.get(anti_knife)
	local is_enabled = ui.get(lua_enable)

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
	end

	if is_misc and is_enabled then
		ui.set_visible(legszz, true)
		ui.set_visible(anti_knife, true)
		ui.set_visible(fast_switch_on,true)
		ui.set_visible(trashtalk, true)
		if is_knife then
			ui.set_visible(knife_distance, true)
		else
			ui.set_visible(knife_distance, false)
		end
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(legszz, false)
		ui.set_visible(knife_distance, false)
		ui.set_visible(fast_switch_on,false)
		ui.set_visible(trashtalk, false)

	end

	if ui.get(aa_init[0].presets) == "Agressive" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].legit_e_key, true)
		ui.set_visible(aa_init[0].manual_forward, true)
	--	ui.set_visible(aa_init[0].edgeyaw, true)
		ui.set_visible(aa_init[0].fs, true)
	else
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		--ui.set_visible(aa_init[0].edgeyaw, false)
		ui.set_visible(aa_init[0].fs, false)
	end

	if is_ab and is_enabled then
		ui.set_visible(aa_init[0].aa_abf, true)
	else
		ui.set_visible(aa_init[0].aa_abf, false)
	end

	if is_color and is_enabled then
		ui.set_visible(ab_clr2, true)
		ui.set_visible(ab_clr_l2, true)
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(under_clr, true)
		ui.set_visible(under_clr_l, true)
		ui.set_visible(main_clr2, true)
		ui.set_visible(main_clr_l2, true)
	else
		ui.set_visible(ab_clr_l2, false)
		ui.set_visible(ab_clr2, false)
		ui.set_visible(under_clr, false)
		ui.set_visible(under_clr_l, false)
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(main_clr2, false)
		ui.set_visible(main_clr_l2, false)
	end

	if is_vis and is_enabled then
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(watermark_tgl, true)
		ui.set_visible(manaa_inds, true)
	else
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(watermark_tgl, false)
		ui.set_visible(manaa_inds, false)
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

	if is_aa and is_enabled then
--		ui.set_visible(aa_init[0].aa_abf, true)
		ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].presets, true)
	--	ui.set_visible(aa_init[0].presets1, true)
	--	ui.set_visible(aa_init[0].presets2, true)
	--	ui.set_visible(aa_init[0].presets3, true)
	--	ui.set_visible(aa_init[0].presets4, true)
	else
	--	ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].presets, false)
		--ui.set_visible(aa_init[0].presets1, true)
	--ui.set_visible(aa_init[0].presets2, true)
		--ui.set_visible(aa_init[0].presets3, true)
		--ui.set_visible(aa_init[0].presets4, true)
		ui.set_visible(aa_init[0].aa_builder, false)
	end
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[i].enable_state,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].enable_state) then
				ui.set_visible(aa_init[i].yawaddl,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawaddr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_aa)

				ui.set_visible(aa_init[i].side_body,var.active_i == i and is_aa and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")
				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].anti_bf, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].hybrid_fs, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aa_static, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "left" and is_aa)
				ui.set_visible(aa_init[i].aa_static_2, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "right" and is_aa)

				ui.set_visible(aa_init[i].side_fake,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and ui.get(aa_init[i].side_fake) == "left" and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and ui.get(aa_init[i].side_fake) == "right" and is_aa)
				ui.set_visible(aa_init[i].roll, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].yawaddl,false)
				ui.set_visible(aa_init[i].yawaddr,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].yawjitteradd,false)

				ui.set_visible(aa_init[i].anti_bf, false)
				ui.set_visible(aa_init[i].hybrid_fs, false)
	
				ui.set_visible(aa_init[i].side_body,false)
				ui.set_visible(aa_init[i].bodyyaw,false)
	
				ui.set_visible(aa_init[i].aa_static,false)
				ui.set_visible(aa_init[i].aa_static_2,false)
	
				ui.set_visible(aa_init[i].side_fake,false)
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitr,false)
				ui.set_visible(aa_init[i].roll,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].enable_state,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawaddl,false)
			ui.set_visible(aa_init[i].yawaddr,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitteradd,false)

			ui.set_visible(aa_init[i].side_body,false)
			ui.set_visible(aa_init[i].side_fake,false)
			ui.set_visible(aa_init[i].bodyyaw,false)

			ui.set_visible(aa_init[i].anti_bf, false)
			ui.set_visible(aa_init[i].hybrid_fs, false)

			ui.set_visible(aa_init[i].aa_static,false)
			ui.set_visible(aa_init[i].aa_static_2,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitr,false)
			ui.set_visible(aa_init[i].roll,false)
		end
	end
end

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

	if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
		if ui.get(aa_init[var.p_state].hybrid_fs) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
		else
			brute.best_angle = 1
		end
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		if ui.get(aa_init[var.p_state].hybrid_fs) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
		else
			brute.best_angle = 2
		end
	end
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
	if not is_dt and not is_os and not p_still and ui.get(aa_init[7].enable_state) and ui.get(aa_init[0].aa_builder) then
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
		c.roll = ui.get(aa_init[6].roll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[1].roll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[7].roll)
	elseif var.p_state == 2 then
		c.roll = ui.get(aa_init[2].roll)
	elseif var.p_state == 3 then
		c.roll = ui.get(aa_init[3].roll)
	elseif var.p_state == 4 then
		c.roll = ui.get(aa_init[4].roll)
	elseif var.p_state == 5 then
		c.roll = ui.get(aa_init[5].roll)
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
end

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

client.set_event_callback("pre_render", function ()

	local timer = globals.tickcount() % 3;

	if not entity.is_alive(entity.get_local_player()) then return end

	if table_contains(ui.get(legszz),"Static Leg In Air") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

	if table_contains(ui.get(legszz),"Jitter Leg On Ground") then
	if timer > 1 then
	ui.set(antiaim.leg_movement, "always slide" or "never slide")
	entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
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
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "On hotkey")
	end

	local l = 1

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


	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aa_static))
		ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
		if ui.get(aa_init[var.p_state].enable_state) and ui.get(aa_init[0].aa_builder) then
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
			ui.set(ref.pitch, "Default")
			if ui.get(aa_init[0].presets) == "Adaptive" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Static")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 42)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
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
			elseif ui.get(aa_init[0].presets) == "Agressive" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "opposite")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "opposite")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 11))
					end
					ui.set(ref.fakeyawlimit, 59)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 6)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 6)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 7))
					end
					ui.set(ref.fakeyawlimit, 58)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "Static")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 39)
					ui.set(byaw, "opposite")
					ui.set(ref.bodyyaw[2], 6)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -5 or 14))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			end
		end
	end
end)

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
		if ui.get(aa_init[0].aa_abf) or ui.get(aa_init[var.p_state].anti_bf) then
			windrath_push:paint(5,"Switched Anti-bruteforce due to enemy shot")
		else
     	end
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
	local r,g,b = ui.get(main_clr)
	local hex = RGBtoHEX(r,g,b)
end

local ur,ug,ub,ua = ui.get(under_clr)


--client.register_esp_flag("RESOLVED", " ", 255, 255, 255, resik)

local function watermark()
	--if ui.get(watermark_tgl) then
	local realtime = globals.realtime() % 3
	local alpha3 = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180

	local data_suffix = 'windrath.icu'

	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d'):format(h, m)

	local nickname = "malva"

	local r,g,b = ui.get(main_clr)
	local hex = RGBtoHEX(r,g,b)
		
	local latency = client.latency()*1000
	local latency_text = ('  %d'):format(latency) or ''

	text = ("\a"..hex.."%s\a737373FF [dev] \a737373FF/ %s\a"..hex.."%s \a737373FFms \a"..hex.."%s \a737373FFtime "):format(data_suffix, nickname, latency_text, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10

	if not ui.get(watermark_tgl) then
		--	renderer_shit(x, y, w, 65, 65, 65, 180, 2)
		--	renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
		else
			renderer.text(x-1678, y + 486, 255, 255, 255, 255, '', 0, "windrath.\aFFFFFFFFlua -")
			renderer.text(x-1608, y + 485, 255, 255, 255, alpha3, '', 0, entity.get_player_name(entity.get_local_player()))
			renderer.text(x-1678, y + 498, 255, 255, 255, 255, '', 0, "Version -")
			renderer.text(x-1636, y + 497, 255, 255, 255, alpha3, '', 0, " \aFFFFFFFFalpha")
			renderer.text(x-1678, y + 509, 255, 255, 255, 255, '', 0, "Last update - ")
			renderer.text(x-1608, y + 509, 255, 255, 255, alpha3, '', 0, "\aFFFFFFFF03.09.22")
			renderer.text(x-1678, y + 522, 255, 255, 255, 255, '', 0, "Exploit speed:")
			renderer.text(x-1608, y + 522, 255, 255, 255, alpha3, '', 0,entity.is_enemy(client.current_threat()))
			renderer.text(x-1678, y + 534, 255, 255, 255, 255, '', 0, "\aFFFFFFFFTarget - ")
            renderer.text(x-1635, y + 534, 255, 255, 255, alpha3, '',0, entity.get_player_name(client.current_threat()))
			renderer.text(x-1678, y + 547, 255, 255, 255, 255, '', 0, "Coding - ")
			renderer.text(x-1635, y + 547, 255, 255, 255, alpha3, '', 0, "\aFFFFFFFFWINDRATH.TEAM")
			renderer.text(x-1677, y + 559, 255, 255, 255, 255, '', 0, "Powered by -")
			renderer.text(x-1612, y + 558, 255, 255, 255, alpha3, '', 0, "\aFFFFFFFFKileo")
--			renderer.text(x-1678, y + 554, 255, 255, 255, 255, '', 0, "Target Weapon - ")
		end

end

client.set_event_callback("paint", watermark)

hitler.lerp = function(start, vend, time)
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
--	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
--	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(main_clr)
	local mr2,mg2,mb2,ma = ui.get(main_clr2)
	local ur,ug,ub,ua = ui.get(under_clr)

	local x, y = client.screen_size()

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(aa_init[0].fs)
	--local is_edgeyaw = ui.get(aa_init[0].edgeyaw)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=255, 255, 255,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=148, 148, 148,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
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
			state = "FAKELAG"
		elseif var.p_state == 5 then
			state = "DUCKING"
		elseif var.p_state == 6 then
			state = "DUCK+JUMP"
		elseif var.p_state == 4 then
			state = "JUMPING"
		elseif var.p_state == 3 then
			state = "SLOWWALK"
		elseif var.p_state == 1 then
			state = "STANDING"
		elseif var.p_state == 2 then
			state = "MOVING"
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

	local flag = "c-"
	local ting = 0
	local testting = 0

	--animation shit

	if is_dt or is_os then
		n4_x = hitler.lerp(n4_x, 8, globals.frametime() * 8)
	else
		n4_x = hitler.lerp(n4_x, -1, globals.frametime() * 8)
	end

	if act then
		flag = "-"
		ting = 23
		testting = 11

		testx = hitler.lerp(testx, 30, globals.frametime() * 5)

		n2_x = hitler.lerp(n2_x, 11, globals.frametime() * 5)

		n3_x = hitler.lerp(n3_x, 5, globals.frametime() * 5)

	else
		testx = hitler.lerp(testx, 0, globals.frametime() * 5)

		n2_x = hitler.lerp(n2_x, 0, globals.frametime() * 5)

		n3_x = hitler.lerp(n3_x, 0, globals.frametime() * 5)

		flag = "c-"
		ting = 28
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if ui.get(inds_selct) == "Windrath Advanced" and ui.get(crosshair_inds) then
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

		renderer.text(x / 2-28 + testx, y / 2 + 25, ur,ug,ub, 255, "-", 0, 'WINDRATH')
		renderer.text(x / 2+11 + testx, y / 2 + 25, 255,255,255, alpha, "-", 0, 'BETA')
		renderer.text(x / 2 + n2_x - testting, y / 2 + ting + 11 , 255, 255, 255, 180, flag, 0, state)
		--renderer.text(x / 2-1, y / 2 + 58, br, bg, bb, ba, "-", 0, "BAIM")
		--renderer.text(x / 2+18, y / 2 + 58, sr, sg, sb, sa, "-", 0, "SP")
		--renderer.text(x / 2+29, y / 2 + 58, fr, fg, fb, fa, "-", 0, "FS")
	end

	if ui.get(inds_selct) == "Windrath Modern" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 - 0.5, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			renderer.text(x / 2 - 0.5, y2 / 2 + os_y+ 10.5, dr, dg, db, os_a, "c-", os_w, "OS ")
		end
		renderer.text(x / 2 - 0.5, y2 / 2 + dt_y+ 10.5, dr, dg, db, dt_a, "c-", dt_w, "DT")

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2-19, y / 2 + 25, ur,ug,ub, 255, "-", 0, 'WINDRATH')
		renderer.text(x / 2 + n2_x - testting, y / 2 + ting + 10 , 255, 255, 255, alpha, flag, 0, state)
		renderer.text(x / 2-23, y / 2 + 47 + n4_x, br, bg, bb, ba, "c-", 0, "BAIM")
		renderer.text(x / 2+0, y / 2 + 47 + n4_x, qr,qg,qb,qa, "c-", 0, "QUEEK")
		renderer.text(x / 2+24, y / 2 + 47 + n4_x, sr, sg, sb, sa, "c-", 0, "SAFE")
	end

	local localp = entity.get_local_player()

	local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60

	if ui.get(arrw_selct) == "TEAMSKEET" and ui.get(manaa_inds) then
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

if ui.get(arrw_selct) == "XO-YAW" and ui.get(manaa_inds) then
	if ui.get(ref.yaw[2]) == 90 then
		lele = hitler.lerp(lele, 255, globals.frametime() * 3)
		renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⯈')
		renderer.text(x / 2 - 45, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '')
	elseif ui.get(ref.yaw[2]) == -90 then
		lele = hitler.lerp(lele, 255, globals.frametime() * 3)
		renderer.text(x / 2 + 45, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '')
		renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⯇')
	else
		lele = hitler.lerp(lele, 0, globals.frametime() * 11)
		renderer.text(x / 2 + 45, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '')
		renderer.text(x / 2 - 45, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '')
    end
end
	-- ⮜ ⮞
	if ui.get(arrw_selct) == "Default" and ui.get(manaa_inds) then
		if ui.get(ref.yaw[2]) == 90 then
			lele = hitler.lerp(lele, 255, globals.frametime() * 3)
			renderer.text(x / 2 + 75	, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⮞')
			renderer.text(x / 2 - 75, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '⮜')
		elseif ui.get(ref.yaw[2]) == -90 then
			lele = hitler.lerp(lele, 255, globals.frametime() * 3)
			renderer.text(x / 2 + 75, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '⮞')
			renderer.text(x / 2 - 75, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⮜')
		else
			lele = hitler.lerp(lele, 0, globals.frametime() * 11)
			renderer.text(x / 2 + 75, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '⮞')
			renderer.text(x / 2 - 75, y / 2 - 2.5, mr2,mg2,mb2, lele, "c+", 0, '⮜')
		end
	end
end


ui.get(trashtalk)
local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec
local ui_get = ui.get

local baimtable = {
	"you got it wrong HAHAHAHAH",
	"Nice desync, is that Neverpaste?",
	"You so bad XD",
	"Fucking bitch from the countryside",
	"Jestem znanym pasterzem, daję Ci kutasa do wypasania",
	"Nice miss sucker HAAHAH",
	"ЕБАНЫЙ ХОХОЛ ЧТО ТЫ ДЕЛАЕШЬ",
	"ебаный клоп ливай нахуй",
	"Zamierzałem wpaść w twoją głupią cipkę",
    "Włóż te ciężkie jaja do swojej cipki",
    "Włoże swojego penisa do krypty, w której cie trzymam",
    "Zapytaj mnie, czy nadal boli mnie kolano po nocy z twoją matką",
    "Jak położę swojego penisa na Twoim ramieniu, powiesz, że nosiłeś kłody do domu",
    "Oho, konfigurowałem negeva",
    "nie chcesz kutasa w ustach, a ciągle go bierzesz",
    "Ty srasz kamieniami kolejowymi",
    "Wiesz, że jestem lichwiarzem, rozrywam na strzępy, a potem znikam",
	"Look at it on the right side, at least you hit the wall xD",
	"ESC -> Help and Options -> How to Play",
	"For pregnant girls, I recommend skeet with vitamins",
	"Hakuna matataaaa, how 1 comes hereeee...",
	"You looked at me like you nodded",
	"fuck you, fuck me like a villager",
	"Are you scared? Yeah!",
	"grill cold ice cream",  
	"Я ТВОЕЙ МАТЕРИ РАКЕТУ ПУСТИЛ",
	"Ебаная тварь у тебя ник TADZH33K БУДЕТ поговорим",
	"WINDRATH.LUA SO BEST",
	"EZ BY WINDRATH.LUA ",
	"Go take a bath and give me a blowjob",
	"You're a bitch from the village looking for ravens with a bag",
	"I'm a famous shepherd, give you my dick to graze",
	"иди у бабки пенсию укради",
	"куда ты чепуха ебаная",
	"nice iq dog. OWNED BY SANCHEZj BO$$",
	"nice iq хуесос, бабке череп сдавил",

}
local hstable = baimtable

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
       --   local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
          console_cmd(commandbaim)
	elseif victim_entindex == get_local_player() and attacker_entindex == get_local_player() then
			console_cmd("say I did it on purpose xD")
	end
end

client.set_event_callback("player_death", on_player_death)


local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(json.stringify(settings))
	windrath_push:paint(5, "Exported antiaim config to clipboard")
end

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "export antiaim settings", export_config)

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
	windrath_push:paint(5, "Imported antiaim config from clipboard")
end

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "import antiaim settings", import_config)

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

	client.set_event_callback("bullet_impact", function(e)
		brute_impact(e)
	end)

	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			windrath_push:paint(5, "Reversed Anti-Bruteforce due to death")
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
		windrath_push:paint(5, "Reversed Anti-Bruteforce due to new round")
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		windrath_push:paint(5, "Reversed Anti-Bruteforce due to new map")
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