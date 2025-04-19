-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local surface = require("gamesense/surface")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
-- cumex

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'source', discord=''}


local vector = require('vector')

client.set_event_callback('paint', function()

    local screen_size = vector(client.screen_size())
    local username = (('%s  -  %s'):format(obex_data.username, obex_data.build)):upper()
end)

if obex_data.build == "Debug" then
    obex_data.build = "alpha"
end


--el que borra esto es gay
local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "odyssey.lua - " ..obex_data.username)




local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

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
	body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
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
	p_states = {"standing", "moving", "slowwalk", "in air", "crouching", "in air + crouching", "fakelag"},
	s_to_int = {["in air + crouching"] = 6,["fakelag"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalk"] = 3, ["in air"] = 4, ["crouching"] = 5},
	player_states = {"standing", "moving", "slowwalk", "in air", "crouching", "in air + crouching", "fakelag"},
	state_to_int = {["in air + crouching"] = 6,["fakelag"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalk"] = 3, ["in air"] = 4, ["crouching"] = 5},
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
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "tabs", "rage", "anti aim", "visuals"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "select anti aim", "cNze's preset", "t0ggle's preset", "antiaim builder"),
	force_dfs_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "\aA9A95FFFforce defensive"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "left hotkey"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "right hotkey"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "forward hotkey"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "freestanding hotkey"),
	fix_hs = ui.new_checkbox("AA", "Anti-aimbot angles", "remove fakelag from hideshots"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "antiaim states", "standing", "moving", "slowwalk", "in air", "crouching", "in air + crouching", "fakelag"),
}

local function print_welcome(x)
	client.color_log(192, 187, 255, "odyssey \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "welcome to \0")
	client.color_log(192, 187, 255, "odyssey")
	--return client.color_log(200, 200, 200, " " .. x)
end

local function print_error(x)
	client.color_log(192, 187, 255, "odyssey \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "error occured \0")
	client.color_log(155, 155, 155, "-> \0")
	return client.color_log(255, 150, 150, " " .. x)
end

--#region "visuals indicators whatever"
local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "indicators accent")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "indicators accent", 255, 100, 30, 255)
local watermark_tgl = ui.new_checkbox("AA", "Anti-aimbot angles", "watermark")
local static_legs = ui.new_checkbox("AA", "Anti-aimbot angles", "static legs in air")
local legs_fucker = ui.new_checkbox("AA", "Anti-aimbot angles", "break legs movement")
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "indicators")
local inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "indicators", { "off", "modern", "classic", "alufart", "acatel" })
local arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "arrow style", { "off", "small", "classic", "modern", "triangle", "teamskeet" })
local draw_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "always draw arrows")
local dtimp = ui.new_checkbox("AA", "Anti-aimbot angles", "doubletap enhancements")
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "avoid backstab")
local debug_panel = ui.new_checkbox("AA", "Anti-aimbot angles", "debug panel")

for i=1, 7 do
	aa_init[i] = {
		overridestate =  ui.new_checkbox("AA", "Anti-aimbot angles", "override ".. var.p_states[i]),
		yawleft = ui.new_slider("AA", "Anti-aimbot angles", var.p_states[i].." - yaw left\n", -180, 180, 0),
		yawright = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - yaw right\n", -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles",var.p_states[i].." - yaw jitter\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - yaw jitter add\n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles",var.p_states[i].." - body yaw\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		--side_body = ui.new_combobox("AA", "Anti-aimbot angles",var.p_states[i].." - body yaw side\n" .. var.p_states[i], { "left", "right" }),
		bodyyawleft = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - body yaw left\n", -180, 180, 0),
		bodyyawright = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - body yaw right\n", -180, 180, 0),
		--side_fake = ui.new_combobox("AA", "Anti-aimbot angles",var.p_states[i].." - fake limit\n" .. var.p_states[i], { "left", "right" }),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - fake limit left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - fake limit right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		roll = ui.new_slider("AA", "Anti-aimbot angles",var.p_states[i].." - roll ammount\n".. var.p_states[i], -50, 50, 0, true, "°"),
	}
end

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
	ui.set_visible(ref.edgeyaw, state)
	ui.set_visible(ref.enabled, state)
end

_G.odyssey_push=(function()
	_G.odyssey_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.odyssey_notify_cache;
			for g=#f,1,-1 do
				_G.odyssey_notify_cache[g].time=_G.odyssey_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.odyssey_notify_cache,g)
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
			local m={math.floor(renderer.measure_text(nil,"[odyssey]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[odyssey]  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}
			local c1,c2,c3,c4 = ui.get(main_clr)
			local x, y = client.screen_size()
			

			renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,10, 10, 10,255)
			--renderer.circle(p[1]-1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 180, 0.5)
			--renderer.circle(p[1]+m[1]+1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 0, 0.5)
			--renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			--renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			--renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			--renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[odyssey]  ")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;


function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.odyssey_notify_cache[g]=_G.odyssey_notify_cache[g-1]
	end;
	_G.odyssey_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

odyssey_push:paint(4,"welcome " ..obex_data.username.." to odyssey - build: " ..obex_data.build)

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
	local is_aa = ui.get(aa_init[0].lua_select) == "anti aim"
	local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "rage"
	local is_debug = ui.get(aa_init[0].lua_select) == "debug stuff"
	local is_knife = ui.get(anti_knife)
	local is_enabled = ui.get(lua_enable)
	

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
		ui.set(ref.enabled, true)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
		ui.set(ref.enabled, false)
	end

	if is_misc and is_enabled then
		ui.set_visible(dtimp, true)
		ui.set_visible(aa_init[0].force_dfs_hotkey, true)
		ui.set_visible(anti_knife, true)
		ui.set_visible(aa_init[0].fix_hs, true)
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(dtimp, false)
		ui.set_visible(aa_init[0].force_dfs_hotkey, false)
		ui.set_visible(aa_init[0].fix_hs, false)
	end

	if is_debug and is_enabled then
		ui.set_visible(debug_panel, true)
	else
		ui.set_visible(debug_panel, false)
	end
	
	if ui.get(aa_init[0].presets) == "dynamic" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		ui.set_visible(aa_init[0].fs, true)
		
	else
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].fs, false)
	end

	if is_vis and is_enabled then
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(static_legs, true)
		ui.set_visible(legs_fucker, true)
		ui.set_visible(watermark_tgl, true)
	else
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(static_legs, false)
		ui.set_visible(legs_fucker, false)
		ui.set_visible(watermark_tgl, false)

	end

	if ui.get(crosshair_inds) and is_vis and is_enabled then
		ui.set_visible(inds_selct, true)
		ui.set_visible(arrw_selct, true)
	else
		ui.set_visible(inds_selct, false)
		ui.set_visible(arrw_selct, false)
		ui.set_visible(draw_arrows, false)
	end

	if is_aa and is_enabled then
		--ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].presets, true)
	else
		ui.set_visible(aa_init[0].presets, false)
		--ui.set_visible(aa_init[0].aa_builder, false)
	end
	if ui.get(aa_init[0].presets) == "antiaim builder" and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[i].overridestate,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].overridestate) then
				ui.set_visible(aa_init[i].yawleft,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawright,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_aa)

				--ui.set_visible(aa_init[i].side_body,var.active_i == i and is_aa and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")
				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].bodyyawleft, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")
				ui.set_visible(aa_init[i].bodyyawright, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")

				--ui.set_visible(aa_init[i].side_fake,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].roll, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].yawleft,false)
				ui.set_visible(aa_init[i].yawright,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].yawjitteradd,false)


	
				--ui.set_visible(aa_init[i].side_body,false)
				ui.set_visible(aa_init[i].bodyyaw,false)
	
				ui.set_visible(aa_init[i].bodyyawleft,false)
				ui.set_visible(aa_init[i].bodyyawright,false)
	
				--ui.set_visible(aa_init[i].side_fake,false)
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitr,false)
				ui.set_visible(aa_init[i].roll,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].overridestate,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawleft,false)
			ui.set_visible(aa_init[i].yawright,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitteradd,false)

			--ui.set_visible(aa_init[i].side_body,false)
		--	ui.set_visible(aa_init[i].side_fake,false)
			ui.set_visible(aa_init[i].bodyyaw,false)


			ui.set_visible(aa_init[i].bodyyawleft,false)
			ui.set_visible(aa_init[i].bodyyawright,false)

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
            if entity.get_classname(weapon) == "CKnife" and distance <= 150 then
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

	if ui.get(aa_init[0].force_dfs_hotkey) then
		c.force_defensive = 0
	end

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
	if not is_dt and not is_os and not p_still and ui.get(aa_init[7].overridestate) and ui.get(aa_init[0].presets) == "antiaim builder" then
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


	if ui.get(dtimp) then
		if lastdt < globals.curtime() then
			ui.set(ref.maxprocticks, 17)
			client.set_cvar("cl_clock_correction", "0")
			ui.set(ref.dt_limit, 1)
			ui.set(ref.dtholdaim, true)
		else
			ui.set(ref.maxprocticks, 19)
			client.set_cvar("cl_clock_correction", "0")
			ui.set(ref.dt_limit, 1)
			ui.set(ref.dtholdaim, true)
		end
	else
		ui.set(ref.maxprocticks, 16)
	end
end

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

client.set_event_callback("pre_render", function ()
	local is_staticlegs = ui.get(static_legs)
    local is_legfucker = ui.get(legs_fucker)
	if not entity.is_alive(entity.get_local_player()) then return end

	if is_staticlegs then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
	end

	local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}

	if is_legfucker then
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

	if ui.get(aa_init[0].fs) then
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always on")
	else
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "On hotkey")
	end

	local l = 1

	if ui.get(aa_init[0].fix_hs) then
		if is_os and not is_dt and not is_fd then
			ui.set(ref.fakelag[1], math.random(1,3))
		else
			ui.set(ref.fakelag[1], 14)
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
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].bodyyawleft))
		ui.set(byaw, ui.get(aa_init[var.p_state].bodyyaw))
		if ui.get(aa_init[var.p_state].overridestate) and ui.get(aa_init[0].presets) == "antiaim builder" then
            if var.p_state == 6 then
                ui.set(ref.pitch, "Default")
            else
                ui.set(ref.pitch, "Minimal")
            end
			ui.set(jyaw, ui.get(aa_init[var.p_state].yawjitter))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].yawjitteradd))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].yawleft) or ui.get(aa_init[var.p_state].yawright)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

			if bodyyaw > 0 then
				ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitr))
			elseif bodyyaw < 0 then
				ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
			end
		else
			ui.set(ref.pitch, "Minimal")
			if ui.get(aa_init[0].presets) == "cNze's preset" or ui.get(aa_init[0].presets) == "antiaim builder" then
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
			elseif ui.get(aa_init[0].presets) == "t0ggle's preset" then
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
	--renderer.rectangle(x+2, y-2, w-5, 2.5, 15, 15, 15, 120)
	--renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 200)
	--renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 200)
	--renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 120)
	--renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 120)
	--renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 200)
	--renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 120)
	--renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 200)
	renderer.rectangle(x+2, y + 2, w, 19, 25, 25, 25, 255)
	local me = entity.get_local_player()
	local desync_type = antiaim_funcs.get_overlap(float)
	local r,g,b = ui.get(main_clr)
	local hex = RGBtoHEX(r,g,b)

	--renderer.gradient(x-3, y+8, 2, 4+edge_h, r, g, b, a, r, g, b, 0, false)
	-- renderer.gradient(x+w+1, y+8, 2, 4+edge_h, r, g, b, a, r, g, b, 0, false)
end

local function watermark()
	local data_suffix = 'odyssey'

	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d:%02d'):format(h, m, s)

	local nickname = obex_data.username

	local r,g,b = ui.get(main_clr)
	local hex = RGBtoHEX(r,g,b)
		
	local latency = client.latency()*1000
	local latency_text = ('  %d'):format(latency) or ''

	text = ("%s ["..obex_data.build.. "] | %s | delay:%sms | 64tick | %s "):format(data_suffix, nickname, latency_text, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10

	local mr,mg,mb,ma = ui.get(main_clr)

	if ui.get(watermark_tgl) then
	    renderer_shit(x, y, w, 65, 65, 65, 180, 2)
		renderer.gradient(x+2, y - 1 , w, 3, 25, 25, 25, 50, mr,mg,mb, 255, true)
		--renderer.text(x+160, y + 1, 255, 255, 255, 255, '', 0, "\aFFCCE6FFodyssey\aD6BDFDFF~\aC9C2F9FFlua")

		renderer.text(x+7, y + 5, 255, 255, 255, 255, '', 0, text)

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

	if is_charged then dr,dg,db,da=0, 255, 0,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
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
		elseif var.p_state == 7 and ui.get(aa_init[0].presets) == "antiaim builder" then
			state = "FAKELAG"
		elseif var.p_state == 5 then
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "AIR" -- + DUCK
		elseif var.p_state == 4 then
			state = "AIR"
		elseif var.p_state == 3 then
			state = "SLOW"
		elseif var.p_state == 1 then
			state = "STAND"
		elseif var.p_state == 2 then
			state = "RUNNING"
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

	if ui.get(inds_selct) == "acatel" and ui.get(crosshair_inds) then
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
		

		renderer.text(x / 2 - 5 +5, y / 2 + 24, 255,255,255, 255, "-", 0, string.upper'odyssey')
		renderer.text(x / 2 + 26 +8, y / 2 + 24.9, 255, 161, 161, alpha,  "-", 0, "LUA")
		renderer.text(x / 2 -5 + 5, y / 2 + 32, 142, 165, 229, 255, "-", 0, string.upper'FAKE YAW:')
		renderer.text(x / 2 + 32 +5, y / 2 + 32, 255, 255, 255, 255, "-", 0, string.upper ""..pep.."")
		if is_dt then

			renderer.text(x / 2 + 4, y / 2 + 46 , dr, dg, db, dt_a, "c-", 0, "DT")
			add_y=add_y+10
			else
				if is_os then
	
					renderer.text(x / 2 + 5, y / 2 + 46 + add_y, 255, 217, 217, 255, "c-", 0, "OS")
					add_y=add_y+10
				end
			end
	
	
			
	
			renderer.text(x / 2+ 9 , y / 2  + 46 + add_y, br, bg, bb, ba, "c-", 0, "BAIM")
			renderer.text(x / 2+ 25 , y / 2  + 46 + add_y, sr, sg, sb, sa, "c-", 0, "SP")
			renderer.text(x / 2+ 35 , y / 2  + 46 + add_y, fr, fg, fb, fa, "c-", 0, "FS")
	end

	if ui.get(inds_selct) == "modern" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 - 0.5, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", 0, " ") --  + os_x
		else
			renderer.text(x / 2 - 0.5, y2 / 2 + 35 + 13, dr, dg, db, os_a, "c-", 0, "HS ") --  + n3_x
		end
		renderer.text(x / 2 - 0.5, y2 / 2 + 35 + 13, dr, dg, db, dt_a, "c-", 0, "DT") --  + n3_x

		--renderer.text(x / 2 - 0.5, y2 / 2 + fs_y+ 13, 255, 255, 255, fs_a, "c-", fs_w, "FS") -- + fs_x + n3_x

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2-1, y / 2 + 30, mr,mg,mb, 255, "c-", 0, 'ODYSSEY') -- testx = scope
		--renderer.text(x / 2+13 + testx, y / 2 + 25, 255,255,255, alpha, "-", 0, 'BETA')
		renderer.text(x / 2-1, y / 2 + 28 + 11 , 255, 255, 255, 180, "c-", 0, state) -- + n2_x - testting
		--renderer.text(x / 2-1, y / 2 + 58, br, bg, bb, ba, "-", 0, "BAIM")
		--renderer.text(x / 2+18, y / 2 + 58, sr, sg, sb, sa, "-", 0, "SP")
		--renderer.text(x / 2+29, y / 2 + 58, fr, fg, fb, fa, "-", 0, "FS")
	end

	if ui.get(inds_selct) == "alufart" and ui.get(crosshair_inds) then
		local wx, wy = client.screen_size()
	   local add_y=0
	   --round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
	   
	   local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	   local side = bodyyaw > 0 and 1 or -1
	   local pep="0"
	   if side == 1 then
	   pep = "odys       "
	   elseif side == -1 then
	   pep = "      sey"--done
	   end
	   local desync_type = antiaim_funcs.get_overlap(float)
	   local desync_type2 = antiaim_funcs.get_desync(2)
	   
	
	   renderer.text(x / 2 + 0 , y / 2 + 23, 255,255,255, 255, "bc", 0, "odyssey°")
	   renderer.text(x / 2 + 0 , y / 2 + 23, mr,mg,mb, 255, "bc", 0, ""..pep.."")


	   
   
   
	   if is_dt then

	   renderer.text(x / 2 - 24, y / 2 + 32 + add_y, mr,mg,mb, 255, "l-", 0, "DOUBLETAP")
	   add_y=add_y+10
	   end
	   if is_os then

		renderer.text(x / 2 - 24, y / 2 + 32 + add_y, mr,mg,mb, 255, "l-", 0, "OS-AA")
		add_y=add_y+10
		
		end

	   if is_ba then

		renderer.text(x / 2 - 25, y / 2  + 32 + add_y, mr,mg,mb, 255, "l-", 0, " BAIM")
		add_y=add_y+10
		
	   end
	   
	   if is_fs then

		renderer.text(x / 2 - 24, y / 2  + 32 + add_y, mr,mg,mb, 255, "l-", 0, "FS")
		add_y=add_y+10
		
	end

	if is_qp then 

		renderer.text(x / 2 - 24, y / 2  + 32 + add_y, mr,mg,mb, 255, "l-", 0, "QP")
		add_y=add_y+10
		
	
end
end


	if ui.get(inds_selct) == "classic" and ui.get(crosshair_inds) then

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2-1, y / 2 + 25, mr,mg,mb, 255, "", 0, 'ODYSSEY')
		--renderer.text(x / 2+13, y / 2 + 25, 255, 161, 161, 255, "-", 0, 'BETA')
		renderer.text(wx / 2-1, y / 2 + 36 , 255,255,255, 255, "", 0, state)
		--renderer.text(x / 2-15, y / 2 + 47 + n4_x, br, bg, bb, ba, "", 0, "BAIM")
		--renderer.text(x / 2, y / 2 + 47 + n4_x, qr,qg,qb,qa, "", 0, "QP")
		--renderer.text(x / 2+10, y / 2 + 47 + n4_x, sr, sg, sb, sa, "", 0, "SP")
		--renderer.text(x / 2+20, y / 2 + 47 + n4_x, fr, fg, fb, fa, "", 0, "FS")
	end

	local localp = entity.get_local_player()

	local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60

	if ui.get(arrw_selct) == "off" then
		ui.set_visible(draw_arrows, false)
	end

	if ui.get(arrw_selct) == "teamskeet" and ui.get(crosshair_inds) then
		ui.set_visible(draw_arrows, false)
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
		if ui.get(arrw_selct) == "modern" and ui.get(crosshair_inds) then
			ui.set_visible(draw_arrows, true)
			if ui.get(draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⮜')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⮞')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⮞')
				if ui.get(draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⮜')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⮜')
				if ui.get(draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⮞')
				end
			end
		end

		if ui.get(arrw_selct) == "small" and ui.get(crosshair_inds) then
			ui.set_visible(draw_arrows, true)
			if ui.get(draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '‹')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '›')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '›')
				if ui.get(draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '‹')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '‹')
				if ui.get(draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '›')
				end
			end
		end
		 
		if ui.get(arrw_selct) == "triangle" and ui.get(crosshair_inds) then
			ui.set_visible(draw_arrows, true)
			if ui.get(draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⯇')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⯈')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⯈')
				if ui.get(draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⯇')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				lele = hitler.lerp(lele, 255, globals.frametime() * 3)
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '⯇')
				if ui.get(draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '⯈')
				end
			end
		end

	if ui.get(arrw_selct) == "classic" and ui.get(crosshair_inds) then
		ui.set_visible(draw_arrows, true)
		if ui.get(draw_arrows) then
			renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '<')
			renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '>')
		end

		if ui.get(ref.yaw[2]) == 90 then
			lele = hitler.lerp(lele, 255, globals.frametime() * 3)
			renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '>')
			if ui.get(draw_arrows) then
			else
			renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '<')
			end
		end
		if ui.get(ref.yaw[2]) == -90 then
			lele = hitler.lerp(lele, 255, globals.frametime() * 3)
			renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, lele, "c+", 0, '<')
			if ui.get(draw_arrows) then
			else
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '>')
			end
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





local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(cfg_stuff.encode(json.stringify(settings)))
	odyssey_push:paint(5, "Copied settings to clipboard")
end

local export_btn = ui.new_button("AA", "Anti-aimbot angles", "copy settings to clipboard", export_config)

local function import_config(text)

	local settings = json.parse(cfg_stuff.decode(clipboard.get(text)))
    if settings == nil then 
    	odyssey_push:paint(5, "Failed to load settings")
	else
	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	odyssey_push:paint(5, "loaded settings from clipboard")
    end
end

local import_btn = ui.new_button("AA", "Anti-aimbot angles", "import settings from clipboard", import_config)

local function default_config(text)

	local settings = json.parse(cfg_stuff.decode(text))
    if settings == nil then 
    	odyssey_push:paint(5, "Failed to load settings")
	else
	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	odyssey_push:paint(5, "Loaded default settings")
    end
end

local function config_menu()
	local is_enabled = ui.get(lua_enable)
	local is_aa = ui.get(aa_init[0].lua_select) == "anti aim"
	if ui.get(aa_init[0].presets) == "antiaim builder" and is_enabled and is_aa then
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




local function tings()
    if ui.get(ref.pitch) == "Off" then
        pitch = 0
    elseif ui.get(ref.pitch) == "Default" then
        pitch = 1
    elseif ui.get(ref.pitch) == "Up" then
        pitch = 2
    elseif ui.get(ref.pitch) == "Down" then
        pitch = 3
    elseif ui.get(ref.pitch) == "Minimal" then
        pitch = 4
    elseif ui.get(ref.pitch) == "Random" then
        pitch = 5
    end

    if ui.get(ref.yaw[1]) == "Off" then
        yaw = 0
    elseif ui.get(ref.yaw[1]) == "180" then
        yaw = 1
    elseif ui.get(ref.yaw[1]) == "Spin" then
        yaw = 2
    elseif ui.get(ref.yaw[1]) == "Static" then
        yaw = 3
    elseif ui.get(ref.yaw[1]) == "180 Z" then
        yaw = 4
    elseif ui.get(ref.yaw[1]) == "Crosshair" then
        yaw = 5
    end

    if ui.get(ref.yawjitter[1]) == "Off" then
        yawjit = 0
    elseif ui.get(ref.yawjitter[1]) == "Offset" then
        yawjit = 1
    elseif ui.get(ref.yawjitter[1]) == "Center" then
        yawjit = 2
    elseif ui.get(ref.yawjitter[1]) == "Random" then
        yawjit = 3
    end

    if ui.get(ref.bodyyaw[1]) == "Off" then
        boyaw = 0
    elseif ui.get(ref.bodyyaw[1]) == "Opposite" then
        boyaw = 1
    elseif ui.get(ref.bodyyaw[1]) == "Jitter" then
        boyaw = 2
    elseif ui.get(ref.bodyyaw[1]) == "Static" then
        boyaw = 3
    end
end

local function is_dead()
    dead = false
    if ( entity.get_prop( entity.get_local_player( ), "m_iHealth" ) <= 0 ) then
        dead = true
    else
        dead = false
    end
    return dead
end

local function dormant()
    local dorms = {}

    for _, enemy in pairs(entity.get_players(true)) do
        table.insert(dorms, enemy)
    end
    return dorms
end



	local function paint()

		tings()
		local dormant = dormant()
		local threat = client.current_threat()
		local cur_threat = threat == nil and "nil" or entity.get_player_name(threat)
		local shifting = antiaim_funcs.get_tickbase_shifting()
		local bodyyaw = antiaim_funcs.get_balance_adjust()
		local players = globals.maxplayers()

		if ui.get(debug_panel) then
		if #dormant * ( players / 2 ) ~= 0 and cur_threat ~= "nil" then
			renderer.text(8, 520, 255, 255, 255, 255, '+', 0, "target: " .. cur_threat)
			--renderer.text(8, 520, 255, 255, 255, 255, '+', 0, "1 " .. #dormant * ( players / 2 ))
			renderer.text(8, 540, 255, 255, 255, 255, '+', 0, "jt: " .. ui.get(ref.yawjitter[2]))
			renderer.text(8, 560, 255, 255, 255, 255, '+', 0, "tb: " .. shifting) --ticks shifteados
			renderer.text(8, 580, 255, 255, 255, 255, '+', 0, "yw: " .. ui.get(ref.bodyyaw[2]))
			renderer.text(8, 600, 255, 255, 255, 255, '+', 0, "dl: " .. ui.get(ref.fakeyawlimit))
			renderer.text(8, 620, 255, 255, 255, 255, '+', 0, "ta: " .. #dormant)
		elseif #dormant * ( players / 2 ) == 0 or cur_threat ~= "nil" then
			renderer.text(8, 540, 255, 255, 255, 255, '+', 0, "jt: " .. ui.get(ref.yawjitter[2]))
			renderer.text(8, 560, 255, 255, 255, 255, '+', 0, "tb: " .. shifting) --ticks shifteados
			renderer.text(8, 580, 255, 255, 255, 255, '+', 0, "yw: " .. ui.get(ref.bodyyaw[2]))
			renderer.text(8, 600, 255, 255, 255, 255, '+', 0, "dl: " .. ui.get(ref.fakeyawlimit))
			renderer.text(8, 620, 255, 255, 255, 255, '+', 0, "ta: " .. #dormant)
		end
		if #dormant ~= 0 and shifting > 0 and is_dead() == false then
			renderer.text(8, 580, 255, 255, 255, 255, '+', 0, "yw: " .. ui.get(ref.bodyyaw[2]))
			renderer.text(8, 600, 255, 255, 255, 255, '+', 0, "dl: " .. ui.get(ref.fakeyawlimit))
			renderer.text(8, 620, 255, 255, 255, 255, '+', 0, "ta: " .. #dormant)
		elseif #dormant == 0 and #dormant * ( players / 2 ) == 0 and cur_threat ~= "nil" then
			renderer.text(8, 520, 255, 255, 255, 255, '+', 0, "target is dormant")
		end
		if cur_threat == "nil" then
			renderer.text(8, 520, 255, 255, 255, 255, '+', 0, "no potential threat")
		end
	end

end



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
			odyssey_push:paint(5, "Reset data due to death")
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
		odyssey_push:paint(5, "Reset data due to new round")
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		odyssey_push:paint(5, "Reset data due to new map")
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
client.set_event_callback("setup_command", on_setup_command)
client.set_event_callback("paint", paint)
main()

