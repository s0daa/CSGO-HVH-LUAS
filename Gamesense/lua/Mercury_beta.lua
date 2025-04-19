-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for obex
local obex_data = obex_fetch and obex_fetch() or {username = 'FiveQe', build = 'DEV'}

local username = obex_data.username
local build = obex_data.build

-- stealing detection
local ui_get = ui.get
ui.get = function(a, ...)

    if a==545 or a==426 then
        return
    end
    
    return ui_get(a)
end

-- stealing detection of resolver idea 

local playerlistown_get = plist.get

plist.get = function(a, b, ...)
	if b == "Override safe point" then
		playerlistown_get(a, b)
	else
	return
	end
end

-- string conversion
if build == "Debug" then build = "DEV";elseif build == "Beta" then build = "BETA"; elseif build == "User" then build = "LIVE" end;

-- depedencies
local antiaim_funcs = require("gamesense/antiaim_funcs") or error("Failed to get gamesense/antiaim_funcs please sub to it.", 2)
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local base64 = require("gamesense/base64") or error("Failed to get gamesense/base64. Please download it from Workshop.", 2)
local clipboard = require("gamesense/clipboard") or error("Failed to get gamesense/clipboard. Please download it from Workshop.", 2)
local vector = require("vector") or error("Failed to get Vector please sub to it", 2)
local bit = require "bit" or error("Failed to get bit depedency. Please make sure that u have it.", 2)
local images = require 'gamesense/images' or error("Failed to load images, make sure you are subscribed to it on workshop.")
local screen = {client.screen_size()}
local vector = require "vector"

-- welcome labels
ui.new_label("AA", "Anti-aimbot angles", "|-------------------------------------------|")
ui.new_label("AA", "Anti-aimbot angles", "  Welcome \a5ed5ebff" .. username .. "\affffffff!")
ui.new_label("AA", "Anti-aimbot angles", "  Your build is: \a5ed5ebff" .. build .. "\affffffff!")
ui.new_label("AA", "Anti-aimbot angles", "|-------------------------------------------|")

-- lua masterswitch
local lua_masterswitch = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable\a4287f5FF Mercury.lua")



-- USSR[ZSSR] SHIT (fuck hitler)

local stalin = {}

stalin.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

-- main functions
local function helloWorld()
    client.log('/$$   ')
    client.log('| $$        ')
    client.log(' /$$$$$$/$$$$   /$$$$$$   /$$$$$$   /$$$$$$$ /$$   /$$  /$$$$$$  /$$   /$$    | $$ /$$   /$$  /$$$$$$ ')
    client.log('| $$_  $$_  $$ /$$__  $$ /$$__  $$ /$$_____/| $$  | $$ /$$__  $$| $$  | $$    | $$| $$  | $$ |____  $$')
    client.log('| $$ \' $$ \' $$| $$$$$$$$| $$  \'__/| $$      | $$  | $$| $$  \'__/| $$  | $$    | $$| $$  | $$  /$$$$$$$')
    client.log('| $$ | $$ | $$| $$_____/| $$      | $$      | $$  | $$| $$      | $$  | $$    | $$| $$  | $$ /$$__  $$')
    client.log('| $$ | $$ | $$|  $$$$$$$| $$      |  $$$$$$$|  $$$$$$/| $$      |  $$$$$$$ /$$| $$|  $$$$$$/|  $$$$$$$')
    client.log('|__/ |__/ |__/ \'_______/|__/       \'_______/ \'______/ |__/       \'____  $$|__/|__/ \'______/_______/')
    client.log('                                                                 /$$  | $$                           ')
    client.log('                                                                |  $$$$$$/                            ')
    client.log('                                                                 \'______/                             ')
    client.log('Welcome ' .. username .. '! Thank you for using Mercury.LUA(RECODE)!')
    client.log('Your build type is:  ' .. build .. '!')
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end


-- main functions usage
helloWorld()


-- menu references

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
	p_states = {"Stand", "Run", "Slowwalk", "Air", "Duck", "Air-Duck", "FakeLag(air/run)"},
	s_to_int = {["Air-Duck"] = 6,["FakeLag(air/run)"] = 7, ["Stand"] = 1, ["Run"] = 2, ["Slowwalk"] = 3, ["Air"] = 4, ["Duck"] = 5},
	int_to_state = {[1] = "Stand", [2] = "Run", [3] = "Slowwalk", [4] = "Air", [5] = "Duck", [6] = "Air-Duck", [7] = "FakeLag(air/run)"},
	player_states = {"Stand", "Run", "Slowwalk", "Air", "Duck", "Air-Duck", "FakeLag"},
	-- state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
	state_to_int = {["Air-Duck"] = 6,["FakeLag"] = 7, ["Stand"] = 1, ["Run"] = 2, ["Slowwalk"] = 3, ["Air"] = 4, ["Duck"] = 5},
	p_state = 1
}


local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-- Anti-aimbot angles menu

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "Selected Tab:", "Anti-aimbot angles", "Miscellaneous", "Visuals", "Configuration"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-Aim Presets:", "Unhittable", "Big Jitter"),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles","\ae60edbFFAnti-Bruteforce \a0ee6dfFF[BETA]"),
	legit_e_key = ui.new_checkbox("AA", "Anti-aimbot angles", "\a80777fFFLegit AA \a0ee6dfFF(E)"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "\a80777fFFFreestanding \a0ee6dfFF[REBIND]"),
	fsDisablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a80777fFFFreestanding disablers:", "Manual AA", "FakeLag(air/run)", "Stand", "Run", "Slowwalk", "Air", "Duck", "Air-Duck"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\a80777fFFManual \a0ee6dfFF[LEFT]"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\a80777fFFManual \a0ee6dfFF[RIGHT]"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\a80777fFFManual \a0ee6dfFF[FORWARD]"),
    aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-aimbot angles builder \a0ee6dfFF[CUSTOM]"),
	-- p_states = {"Stand", "Run", "Slowmotion", "Air", "Duck", "Air-Duck", "FakeLag"},
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "Player States", "FakeLag(air/run)", "Stand", "Run", "Slowwalk", "Air", "Duck", "Air-Duck"),
}

-- Visuals
local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "Color picker \a0ee6dfFF[MAIN]")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Color picker \a0ee6dfFF[MAIN]", 176, 189, 255, 255)
local main_clr_l2 = ui.new_label("AA", "Anti-aimbot angles", "Color picker \a0ee6dfFF[SECONDARY]")
local main_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Color picker \a0ee6dfFF[SECONDARY]", 152, 255, 255, 255)
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "\a4287f5FFMercury.lua \affffffffIndicators")
local wtrmark = ui.new_checkbox("AA", "Anti-aimbot angles", "\a4287f5FFMercury.lua \affffffffWatermark")
local manualaa_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\a4287f5FFMercury.lua \affffffffManual AA Arrows")
local tsarrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\a4287f5FFMercury.lua \affffffffTeamSkeet AA Arrows be like")

-- Misc
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Backstab \a0ee6dfFF[BETA]")
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "Anti-Backstab RADIUS:",0,300,150,true,"u")
local trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", "Trashtalk - Mercury") 
local hideshots_fix = ui.new_checkbox("AA", "Anti-aimbot angles", "Hideshots Fix")
local legszz = ui.new_multiselect("AA", "Anti-aimbot angles", "OG Anims:", "Static Legs in Air", "Leg Fucker")


for i=1, 7 do
	aa_init[i] = {
		enable_state =  ui.new_checkbox("AA", "Anti-aimbot angles", "Enable ".. ""..var.p_states[i].." state"),
		yawadd_left = ui.new_slider("AA", "Anti-aimbot angles", "Yaw add left\n"  .. var.p_states[i], -180, 180, 0),
		yawadd_right = ui.new_slider("AA", "Anti-aimbot angles", "Yaw add right\n" .. var.p_states[i], -180, 180, 0),
		yaw_randomizer = ui.new_slider("AA", "Anti-aimbot angles", "Yaw randomizer\n"  .. var.p_states[i], 0, 10, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles","Yaw jitter\n" .. var.p_states[i], { "Off", "Offset", "Center", "Random" }),
		yawjitter_value = ui.new_slider("AA", "Anti-aimbot angles","Yaw jitter value\n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles","Body options\n" .. var.p_states[i], { "Off", "Opposite", "Jitter", "Static"}),
		bodyval = ui.new_slider("AA", "Anti-aimbot angles","Body value\n", -180, 180, 0),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","Fake-yaw limit\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		anti_bf = ui.new_checkbox("AA", "Anti-aimbot angles", "\ae60edbFFAnti-Bruteforce \a0ee6dfFF[BETA]"),
		dynamic_freestand = ui.new_checkbox("AA", "Anti-aimbot angles", "Dynamic Freestand"),
	}
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
	ui.set_visible(ref.edgeyaw, state)
end



_G.mercury_push=(function()
	_G.mercury_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.mercury_notify_cache;
			for g=#f,1,-1 do
				_G.mercury_notify_cache[g].time=_G.mercury_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.mercury_notify_cache,g)
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
			local m={math.floor(renderer.measure_text(nil,"[Mercury]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[Mercury]  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
			local c1,c2,c3,c4 = ui.get(main_clr)
			local x, y = client.screen_size()
			--renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,6, 6, 6,h>255 and 255 or h)
			renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,6, 6, 6,20)
			renderer.circle(p[1]-1,p[2]-8, 6, 6, 6,20, 12, 180, 0.5)
			renderer.circle(p[1]+m[1]+1,p[2]-8, 6, 6, 6,20, 12, 0, 0.5)
			renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[Mercury]  ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.mercury_notify_cache[g]=_G.mercury_notify_cache[g-1]
	end;
	_G.mercury_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

mercury_push:paint(4, "Welcome - " .. username ..  " to Mercury.lua - build: " .. build)

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
	local is_aa = ui.get(aa_init[0].lua_select) == "Anti-aimbot angles"
	local is_vis = ui.get(aa_init[0].lua_select) == "Visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "Miscellaneous"
	local is_knife = ui.get(anti_knife)
	local is_enabled = ui.get(lua_masterswitch)

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
	end

	if is_misc and is_enabled then
		ui.set_visible(legszz, true)
		ui.set_visible(hideshots_fix, true)
		ui.set_visible(trashtalk, true)
		ui.set_visible(anti_knife, true)
		if is_knife then
			ui.set_visible(knife_distance, true)
		else
			ui.set_visible(knife_distance, false)
		end
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(hideshots_fix, false)
		ui.set_visible(trashtalk, false)
		ui.set_visible(knife_distance, false)
		ui.set_visible(legszz, false)
	end


	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].legit_e_key, true)
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		ui.set_visible(aa_init[0].fs, true)
		ui.set_visible(aa_init[0].fsDisablers, true)
	else
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].fs, false)
		ui.set_visible(aa_init[0].fsDisablers, false)

	end
	if is_vis and is_enabled then
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(main_clr2, true)
		ui.set_visible(main_clr_l2, true)
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(wtrmark, true)
		ui.set_visible(manualaa_arrows, true)
		ui.set_visible(tsarrows, true)
	else
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(main_clr2, false)
		ui.set_visible(main_clr_l2, false)
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(wtrmark, false)
		ui.set_visible(manualaa_arrows, false)
		ui.set_visible(tsarrows, false)

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
			ui.set_visible(aa_init[i].enable_state,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].enable_state) then
				ui.set_visible(aa_init[i].yawadd_left,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawadd_right,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yaw_randomizer,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter_value,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "Off" and is_aa)
				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].bodyval, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].anti_bf, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].dynamic_freestand, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].bodyval, var.active_i == i and is_aa and ui.get(aa_init[var.active_i].bodyyaw) ~= "Off" and ui.get(aa_init[var.active_i].bodyyaw) ~= "Opposite")
			else
				ui.set_visible(aa_init[i].yawadd_left,false)
				ui.set_visible(aa_init[i].yawadd_right,false)
				ui.set_visible(aa_init[i].yaw_randomizer,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].bodyyaw,false)
				ui.set_visible(aa_init[i].yawjitter_value,false)
				ui.set_visible(aa_init[i].anti_bf, false)
				ui.set_visible(aa_init[i].dynamic_freestand, false)
				ui.set_visible(aa_init[i].bodyval, false)
				ui.set_visible(aa_init[i].fakeyawlimit,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].enable_state,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawadd_left,false)
			ui.set_visible(aa_init[i].yawadd_right,false)
			ui.set_visible(aa_init[i].yaw_randomizer,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitter_value,false)
			ui.set_visible(aa_init[i].bodyyaw,false)
			ui.set_visible(aa_init[i].bodyval, false)
			ui.set_visible(aa_init[i].anti_bf, false)
			ui.set_visible(aa_init[i].dynamic_freestand, false)


			ui.set_visible(aa_init[i].fakeyawlimit,false)
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
		if ui.get(aa_init[var.p_state].dynamic_freestand) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
		else
			brute.best_angle = 1
		end
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		if ui.get(aa_init[var.p_state].dynamic_freestand) then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
		else
			brute.best_angle = 2
		end
	end
end

local ChokedCommands = 0

local aa = {
	ignore = false,
	manaa = 0,
	input = 0,
}

-- teamskeet arrows aa
local function tsarrow_render(cx, cy, r, g, b, a, bodyyaw)
    renderer.triangle(cx + 55, cy + 2, cx + 42, cy - 7, cx + 42, cy + 11, 
    aa.manaa == 2 and r or 35, 
    aa.manaa == 2 and g or 35, 
    aa.manaa == 2 and b or 35, 
    aa.manaa == 2 and a or 150)

    renderer.triangle(cx - 55, cy + 2, cx - 42, cy - 7, cx - 42, cy + 11, 
    aa.manaa == 1 and r or 35, 
    aa.manaa == 1 and g or 35, 
    aa.manaa == 1 and b or 35, 
    aa.manaa == 1 and a or 150)
    
    renderer.rectangle(cx + 38, cy - 7, 2, 18, 
    bodyyaw < -10 and r or 35,
    bodyyaw < -10 and g or 35,
    bodyyaw < -10 and b or 35,
    bodyyaw < -10 and a or 150)
    renderer.rectangle(cx - 40, cy - 7, 2, 18,			
    bodyyaw > 10 and r or 35,
    bodyyaw > 10 and g or 35,
    bodyyaw > 10 and b or 35,
    bodyyaw > 10 and a or 150)
end


local lastdt = 0

local function on_setup_command(c)
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
	-- if ui.get(aa_init[0].roll_aa) then
	-- 	c.roll = 50
	-- 	ui.set(ref.pitch, "Default")
	-- 	ui.set(ref.yawbase, "At targets")
	-- 	ui.set(ref.yaw[1], "180")
	-- 	ui.set(ref.yaw[2], 0)
	-- 	ui.set(ref.yawjitter[1], "Off")
	-- 	ui.set(ref.yawjitter[2], 0)
	-- 	ui.set(ref.bodyyaw[1], "Static")
	-- 	ui.set(ref.bodyyaw[2], -180)
	-- 	ui.set(ref.fakeyawlimit, 60)
	-- end

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
    client.set_cvar("cl_clock_correction", "0")
    ui.set(ref.dt_limit, 1)
    ui.set(ref.dtholdaim, true)

end

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

client.set_event_callback("pre_render", function ()

	if not entity.is_alive(entity.get_local_player()) then return end

	if table_contains(ui.get(legszz),"Static Legs in Air") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

	local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}

	if table_contains(ui.get(legszz),"Leg Fucker") then
		ui.set(antiaim.leg_movement, legs_types[math.random(1, 3)])
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
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
	ui.set(aa_init[0].manual_forward, "On hotkey")
	local disablerOnManualAA = false

	if table_contains(ui.get(aa_init[0].fsDisablers), "Manual AA") and aa.manaa ~= 0 then
		disablerOnManualAA = true
	else
		disablerOnManualAA = false
	end

	if ui.get(aa_init[0].fs) and not table_contains(ui.get(aa_init[0].fsDisablers), var.int_to_state[var.p_state]) and not disablerOnManualAA then
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always on")
	else
		ui.set(ref.freestand[1], "-")
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
			-- ui.set(ref.yawjitter[1], "off")
			-- ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], -90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 2 then
			-- ui.set(ref.yawjitter[1], "off")
			-- ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 3 then
			-- ui.set(ref.yawjitter[1], "off")
			-- ui.set(ref.yawjitter[2], 0)
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
	if aa.ignore == true then
		if ui.get(aa_init[var.p_state].yawjitter_value) ~= 0 then
			ui.set(ref.yawjitter[1], ui.get(aa_init[var.p_state].yawjitter))
			ui.set(ref.yawjitter[2], ui.get(aa_init[var.p_state].yawjitter_value))
		else
			ui.set(ref.yawjitter[1], "Center")
			ui.set(ref.yawjitter[2], 60)
		end
	end
	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].bodyval))
		ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
		if ui.get(aa_init[var.p_state].enable_state) and ui.get(aa_init[0].aa_builder) then
            if var.p_state == 6 then
                ui.set(ref.pitch, "Default")
            else
                ui.set(ref.pitch, "Minimal")
            end
			ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitter_value))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].yawadd_left) or ui.get(aa_init[var.p_state].yawadd_right)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
			ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
		else
			ui.set(ref.pitch, "Minimal")
			-- 	s_to_int = {["Air-Duck"] = 6,["FakeLag(air/run)"] = 7, ["Stand"] = 1, ["Run"] = 2, ["Slowmotion"] = 3, ["Air"] = 4, ["Duck"] = 5},
			if ui.get(aa_init[0].presets) == "Unhittable" and not aa_builder then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 42)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 77)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
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
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and 5 or 12))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 17)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 15))
					end
					ui.set(ref.fakeyawlimit, 47)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 53)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					ui.set(ref.fakeyawlimit, 40)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
				end
			elseif ui.get(aa_init[0].presets) == "Big Jitter" and not aa_builder then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 36)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 53)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -10 or 11))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 50)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -13 or 9))
					end
					ui.set(ref.fakeyawlimit, 59)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 43)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 7))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 43)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -12 or 17))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 47)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yaw[1], "180")
					ui.set(ref.yaw[2], 0)
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
			mercury_push:paint(5,"Switched anti-brute due to enemy shot at you")
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

stalin.lerp = function(start, vend, time)
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


local function calcMeas(text)
	local textMeas = renderer.measure_text("-", text)
	return textMeas
end

local function draw()
	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(main_clr)
	local mr2,mg2,mb2,ma2 = ui.get(main_clr2)

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
		-- p_states = {"Stand", "Run", "Slowmotion", "Air", "Duck", "Air-Duck", "FakeLag"},
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 and ui.get(aa_init[0].aa_builder) then
			state = "FAKELAG"
		elseif var.p_state == 5 then
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "AIR-DUCK"
		elseif var.p_state == 4 then
			state = "AIR"
		elseif var.p_state == 3 then
			state = "SLOWWALK"
		elseif var.p_state == 1 then
			state = "STAND"
		elseif var.p_state == 2 then
			state = "RUN"
		end
	local realtime = globals.realtime() % 3

	local exp_ind = ""


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
		n4_x = stalin.lerp(n4_x, 8, globals.frametime() * 8)
	else
		n4_x = stalin.lerp(n4_x, -1, globals.frametime() * 8)
	end

	if act then
		flag = "-"
		ting = 23
		testting = 11

		testx = stalin.lerp(testx, 30, globals.frametime() * 5)

		n2_x = stalin.lerp(n2_x, 11, globals.frametime() * 5)

		n3_x = stalin.lerp(n3_x, 5, globals.frametime() * 5)

	else
		testx = stalin.lerp(testx, 0, globals.frametime() * 5)

		n2_x = stalin.lerp(n2_x, 0, globals.frametime() * 5)

		n3_x = stalin.lerp(n3_x, 0, globals.frametime() * 5)

		flag = "c-"
		ting = 28
	end

	if ui.get(crosshair_inds) then
		local previousTicks = 0
		local ticks = antiaim_funcs.get_tickbase_shifting()
		local ticksForCircle = 0
		if ticks > 12 then
			ticks = 12
		else
			ticksForCircle = ticks / 12
		end
		local measurement2 = calcMeas("MERCURY")
		local stateMeas = calcMeas(state)
		local buildMeas = calcMeas(build)
		renderer.text((screen[1] / 2) - stateMeas / 2, (screen[2] / 2) + 35, 255, 255, 255, 255, "-", 0, state)
		local alpha = math.sin(math.abs(-3.14 + (globals.curtime() * (1 / .50)) % (3.14 * 2))) * 255
		renderer.text((screen[1] / 2) - measurement2 / 2 - buildMeas + 5, (screen[2] / 2) + 27, mr,mg,mb, 255, "-", 0,'MERCURY')
		renderer.text((screen[1] / 2) + 10, (screen[2] / 2) + 27, mr2,mg2,mb2, alpha, "-", nil, build)
		if ui.get(ref.dt[2]) then
			if antiaim_funcs.get_double_tap() then
				renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, " DT")
			else
				renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 255, 0, 0, 240, "-", 0, " DT")
			end
			elseif ui.get(ref.os[2]) then
				renderer.text((screen[1] / 2) - calcMeas("HS") / 2 - 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "HS")
			else
				renderer.text((screen[1] / 2) - calcMeas("DT") / 2 - 2, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, " DT")
			end
			if ui.get(ref.forcebaim) then
				renderer.text((screen[1] / 2) - calcMeas("BAIM") - calcMeas("HS") / 2 - 4, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "BAIM")
			else
				renderer.text((screen[1] / 2) - calcMeas("BAIM") - calcMeas("HS") / 2 - 4, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "BAIM")
			end
			if ui.get(ref.freestand[2]) then
				renderer.text((screen[1] / 2) + calcMeas("HS") / 2 , (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "FS")
			else
				renderer.text((screen[1] / 2) + calcMeas("HS") / 2 , (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "FS")
			end
			if ui.get(ref.quickpeek[2]) then
				renderer.text((screen[1] / 2) + calcMeas("HS") / 2 + calcMeas("FS") + 2, (screen[2] / 2) + 44, 255, 255, 255, 255, "-", 0, "QP")
			else
				renderer.text((screen[1] / 2) + calcMeas("HS") / 2 + calcMeas("FS") + 2, (screen[2] / 2) + 44, 150, 150, 150, 240, "-", 0, "QP")
		end
	
	end
	if ui.get(wtrmark) then
		local avatar = images.get_steam_avatar(entity.get_steam64(entity.get_local_player()))
		local measurement = renderer.measure_text("-", string.upper(username))

		 -- top
		 renderer.gradient(screen[1] - 100 - measurement / 4, 15, 91 + measurement / 4, 3, 83, 114, 242, 0, 80, 114, 232, 255, true)
		 -- bottom
		 renderer.gradient(screen[1] - 100 - measurement / 4, 52, 94 + measurement / 4, 3, 83, 114, 242, 0, 80, 114, 232, 255, true)
		 -- right
		 renderer.gradient(screen[1] - 10, 15, 3, 37, 83, 114, 242, 255, 80, 114, 232, 255, false)
		 -- center box
		 renderer.gradient(screen[1] - 100 - measurement / 2, 17, 90 + measurement / 2 +1, 35, 93, 114, 232, 0, 90, 114, 232, 125, true)
		 renderer.text(screen[1] - 62 - measurement / 3,25, 255, 255, 255, 255, "", 0,'MERCURY')
		 renderer.text(screen[1] - 63 - measurement / 3,35, 255, 255, 255, 255, "-", 0,string.upper(username))
		 renderer.text(screen[1] - 63 - measurement / 3 + measurement + 2,35, 255, 255, 255, 255, "-", 0,"[" .. build .. "]")
		 avatar:draw(screen[1] - 92 - measurement / 3, 25, 23, 23)
	end
	if ui.get(tsarrows) then
		tsarrow_render(screen[1]/2, screen[2]/2, mr, mg, mb, ma, bodyyaw)
	end

	if ui.get(manualaa_arrows) then
		-- 1 left, 2 right, 3 forward
		if aa.manaa == 1 then
			renderer.text(screen[1] / 2 - 30, screen[2] / 2 - 3, 255, 255, 255, 255, "cd", 0, '⮜')
		elseif aa.manaa == 2 then
			renderer.text(screen[1] / 2 + 30, screen[2] / 2 - 3, 255, 255, 255, 255, "cd", 0, '⮞')
		elseif aa.manaa == 3 then
			renderer.text(screen[1] / 2, screen[2] / 2 - 33, 255, 255, 255, 255, "cd", 0, '⮝')
		end
	end


end

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(base64.encode(json.stringify(settings)))
	print("Anti-aimbot angles settings exported to ur clipboard!")
end



local function import_config()

	local settings = json.parse(base64.decode(clipboard.get()))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	print("Anti-aimbot angles settings imported from ur clipboard!")
end

local label_config = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFConfig Export/Import is in \a0ee6dfFF[BETA] \aFFFFFFFFstate!")
local export_button = ui.new_button("AA", "Anti-aimbot angles", "Export Configuration", export_config)
local import_button = ui.new_button("AA", "Anti-aimbot angles", "Import Configuration", import_config)


local function configurationMenuHandler()

	local is_configuration = ui.get(aa_init[0].lua_select) == "Configuration"
	local is_enabled = ui.get(lua_masterswitch)

	if is_configuration and is_enabled then
		ui.set_visible(label_config, true)
		ui.set_visible(export_button, true)
		ui.set_visible(import_button, true)
	else
		ui.set_visible(label_config, false)
		ui.set_visible(export_button, false)
		ui.set_visible(import_button, false)
	end

end



client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", configurationMenuHandler)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

--- CHECK IF SOMETHING WRONG 


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


local function hideShotsFix(e)
	local hsFixEnabled = ui.get(hideshots_fix)
	local hsEnabled = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local fdEnabled = ui.get(ref.fakeduck)
	local dtEnabled = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	if hsEnabled and hsFixEnabled and not dtEnabled and not fdEnabled then
		ui.set(ref.fakelag[1], 1)
	else
		ui.set(ref.fakelag[1], 14)
	end
end

client.set_event_callback("setup_command", hideShotsFix)



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
			mercury_push:paint(5, "Anti-bruteforce data got resetted due to player death.")
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
		mercury_push:paint(5, "Anti-bruteforce data got resetted due to new round.")
	end)

	client.set_event_callback("client_disconnect", function()
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


local function unload()
	ui.set_visible(ref.yawbase,true)
	ui.set_visible(ref.yaw[1], true)
	ui.set_visible(ref.yaw[2], true)
	ui.set_visible(ref.pitch,true)
	ui.set_visible(ref.fakeyawlimit, true)
	ui.set_visible(ref.roll, true)
	ui.set_visible(ref.freestand[1], true)
	ui.set_visible(ref.bodyyaw[1], true)
	ui.set_visible(ref.bodyyaw[2], true)
	ui.set_visible(ref.fsbodyyaw, true)
	ui.set_visible(ref.edgeyaw, true)
	ui.set_visible(ref.yawjitter[1], true)
	ui.set_visible(ref.yawjitter[2], true)
	ui.set(ref.pitch, "Default")
	ui.set(ref.yawbase, "At targets")
	ui.set(ref.yaw[1], "180")
	ui.set(ref.yaw[2], 0)
	ui.set(ref.yawjitter[1], "Center")
	ui.set(ref.yawjitter[2], 0)
	ui.set(ref.bodyyaw[1], "Static")
	ui.set(ref.bodyyaw[2], 0)
	ui.set(ref.fakeyawlimit, 0)
	ui.set(ref.edgeyaw, false)
	ui.set(ref.roll, 0)
end

client.set_event_callback('shutdown', unload)

local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

local trashtalkHead = {"zostales stapowany bo nie masz mercury.lua", "wez ty kurw0 kup mercury, hs", "bez problemu tapik ez", "juz boty na mirage sa lepszym przeciwnikiem, hs 1"}
local trashtalkOther = {"ez baimik randomie ft. mercury.lua", "idealtick to potega z powodu mercury.lua", "nie masz podjazdu nn", "ez baim kill so ez"}


local function trashtalkEvent(e)
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)

	if ui.get(trashtalk) then
		if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
			console_cmd("say ", e.headshot and trashtalkHead[math.random(0,3)] or trashtalkOther[math.random(0,3)])
		end
	end

end


client.set_event_callback("player_death", trashtalkEvent)


