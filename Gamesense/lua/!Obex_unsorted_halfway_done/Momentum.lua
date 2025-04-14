-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require "gamesense/antiaim_funcs"
local ffi = require "ffi"
local vector = require "vector"
local base64 = require "gamesense/base64"
local clipboard = require "gamesense/clipboard"
local surface = require "gamesense/surface"
local csgo_weapons = require "gamesense/csgo_weapons"

tab, container = "AA", "Anti-aimbot angles"
player_memory = {}
local freestanddisabled = false

function lerp(start, vend, time)
    return start + (vend - start) * time 
end

local main = {}
local gui = {}
local funcs = {}
local render = {}
local elements = {}
local helper = {}
local logs = {}
local rendering = {}

local reference = {
	antiaim = {
		enabled = ui.reference(tab, container, "Enabled"),
		pitch = ui.reference(tab, container, "pitch"),
		yawbase = ui.reference(tab, container, "Yaw base"),
		yaw = {ui.reference(tab, container, "Yaw")},
		fakeyawlimit = ui.reference(tab, container, "Fake yaw limit"),
		fsbodyyaw = ui.reference(tab, container, "Freestanding body yaw"),
		edgeyaw = ui.reference(tab, container, "Edge yaw"),
		yaw_jitt = {ui.reference(tab, container, "Yaw jitter")},
		body_yaw = {ui.reference(tab, container, "Body yaw")},
		freestand = {ui.reference(tab, container, "Freestanding")},
		roll = ui.reference(tab, container, "Roll"),
		edge = ui.reference(tab, container, "Edge yaw"),
	},
	fakelag = {
		fl_limit = ui.reference(tab, "Fake lag", "Limit"),
		fl_amount = ui.reference(tab, "Fake lag", "Amount"),
		enablefl = ui.reference(tab,"Fake lag","Enabled"),
		fl_var = ui.reference(tab, "Fake lag", "Variance"),
		fakelag = {ui.reference(tab, "Fake lag", "Limit")},
	},
	rage = {
		dt = {ui.reference("RAGE", "Other", "Double tap")},
		os = {ui.reference(tab, "Other", "On shot anti-aim")},
		lm = ui.reference(tab,"Other","Leg movement"),
		fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
		safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
		forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
		quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
		slow = {ui.reference(tab, "Other", "Slow motion")},
		sw, slowwalk = ui.reference("AA","Other","Slow motion"),
		slow_type = ui.reference(tab,"Other","Slow motion type"),
		damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
		ping_spike = {ui.reference('MISC', 'Miscellaneous', 'Ping spike')},
        air_strafe = ui.reference("Misc", "Movement", "Air strafe"),
	},
}

function funcs:on_load()
	ui.set(reference.antiaim.yaw_jitt[1], "Off")
	ui.set(reference.antiaim.yaw_jitt[2], 0)
	ui.set(reference.antiaim.body_yaw[1], "Static")
	ui.set(reference.antiaim.body_yaw[2], 0)
	ui.set(reference.antiaim.yaw[1], "180")
	ui.set(reference.antiaim.yaw[2], 0)
	ui.set(reference.antiaim.fakeyawlimit, 0)
	ui.set_visible(reference.antiaim.enabled, false)
end

local var = {
	p_states = {"Stand", "Move", "Slow walk", "In air", "Duck", "Air duck", "Fakelag"},
	s_to_int = {["Air duck"] = 6,["Fakelag"] = 7, ["Stand"] = 1, ["Move"] = 2, ["Slow walk"] = 3, ["In air"] = 4, ["Duck"] = 5},
	player_statess = {"S", "M", "SW", "IA", "D", "AD", "FL"},
	state_to_int = {["AD"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["IA"] = 4, ["D"] = 5},
	p_state = 1
}

function helper:contains(table, value)
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

elements[0] = {
	aa_dir   = 0,
	last_press = 0,
	lua_select = ui.new_slider(tab, container, "\aFFFFFF8Dmomentum.codes © 2022", 1, 3, 1, true, "", 1, {[1] = "anti-aim", [2] = "visuals", [3] = "misc"}),
	aa_presets = ui.new_slider(tab, container, "\aDBCDFFFF➣ Anti-aim presets", 1, 2, 1, true, "", 1, {[1] = "Default", [2] = "Experimental"}),
	additions = ui.new_combobox(tab, container, "\aDBCDFFFF➣ Additions", "Main", "Keybinds"),
	force_label = ui.new_label(tab, container, "\aFFFFFF8DForce defensive"),
	force_def = ui.new_hotkey(tab, container, "Force defensive", true),
	fs_label = ui.new_label(tab, container, "\aFFFFFF8DFreestanding"),
	fs = ui.new_hotkey(tab, container, "Freestanding", true),
	edge_yaw = ui.new_hotkey(tab, container, "\aFFFFFF8DEdge yaw", false),
	fs_options = ui.new_slider(tab, container, "\aDBCDFFFF➣ Frestanding options", 1, 2, 2, true, "", 1, {[1] = "default", [2] = "static"}),
	fs_dis = ui.new_multiselect(tab, container, "\aDBCDFFFF➣ Freestanding disablers", "Stand", "Move", "Slowwalk", "In Air", "Crouch", "Fakeduck"),
	aa_abf = ui.new_checkbox(tab, container,"\aFFFFFF8DAnti-bruteforce"),
	legit_aa = ui.new_checkbox(tab, container, "\aFFFFFF8DLegit aa on use"),
	aa_stc_tillhit = ui.new_checkbox(tab, container,"static until hittable"),
	manual_left = ui.new_hotkey(tab, container, "\aFFFFFF8DManual left"),
	manual_right = ui.new_hotkey(tab, container, "\aFFFFFF8DManual right"),
	manual_forward = ui.new_hotkey(tab, container, "\aFFFFFF8DManual forward"),
	manual_reset = ui.new_hotkey(tab, container, "\aFFFFFF8DManual reset"),
	aa_builder = ui.new_checkbox(tab, container, "\aFFFFFF8DOverride presets"),
	player_state = ui.new_combobox(tab, container, "\aDBCDFFFF➣ Antiaim-states", "Fakelag", "Stand", "Move", "Slow walk", "In air", "Duck", "Air duck"),
}

local vis = {
	inds_selct = ui.new_combobox(tab, container, "\aDBCDFFFF➣ Screen indicators", { "-", "Minimalistic", "Modern"}),
	enable_anim = ui.new_checkbox(tab, container, "\aFFFFFF8DIndicators animation"),
	anims_speed = ui.new_slider(tab, container, "\aFFFFFF8DAnimation speed", 1, 10, 5, true, "", 1),
	main_clr_l = ui.new_label(tab, container, "\aFFFFFF8DMain color"),
	main_clr = ui.new_color_picker(tab, container, "Main color", 255, 255, 255, 255),
	main_clr_l2 = ui.new_label(tab, container, "\aFFFFFF8DSecond color"),
	main_clr2 = ui.new_color_picker(tab, container, "Second color", 255, 255, 255, 255),
	watermark_on = ui.new_checkbox(tab, container, "\aFFFFFF8DWatermark"),
	manaa_inds = ui.new_checkbox(tab, container, "\aFFFFFF8DEnable anti-aim arrows"),
	enable_logs = ui.new_checkbox(tab, container, "\aFFFFFF8DLogs"),
	print_to = ui.new_multiselect(tab, container, "\aDBCDFFFF➣ Print logs to","Console", "Screen")
}

local misc = {
	anti_knife = ui.new_checkbox(tab, container, "\aDBCDFFFF➣ Anti-backstab"),
	knife_distance = ui.new_slider(tab, container, "\aFFFFFF8DAnti-backstab distance",0,1000,450,true),
	pred_sw = ui.new_checkbox(tab, container, "\aFFFFFF8DBreak prediction on slowwalk"),
    jumpsc_out = ui.new_checkbox(tab, container, "\aFFFFFF8DJump scout fix"),
	animations = ui.new_multiselect(tab, container, "\aDBCDFFFF➣ Animations breaker", {"Leg breaker", "Static slowwalk legs", "Static legs", "0 pitch on land"}),
	prefer_baim = ui.new_multiselect(tab, container,"\aDBCDFFFF➣ Prefer body aim", "Lethal health", "In air", "Low damage"),
	force_baim = ui.new_multiselect(tab, container,"\aDBCDFFFF➣ Force body aim", "Lethal health", "In air", "Low damage")
}

local fl_tab = {
	advanced_fl = ui.new_checkbox	(tab, "Fake lag", "\aFFFFFF8DAdvanced fakelag"),
	fakelag_tab = ui.new_combobox(tab,"Fake lag","\aFFFFFF8DFake lag", "Maximum", "Dynamic", "Alternative"),
	trigger = ui.new_multiselect(tab,"Fake lag","\aFFFFFF8DTrigger while", "Standing", "Moving", "Slowwalk", "In air", "On land"),
	triggerlimit = ui.new_slider(tab,"Fake lag","\aFFFFFF8DLimit",1,15,15),
	sendlimit = ui.new_slider(tab,"Fake lag","\aFFFFFF8DSend limit",1,15,13),
	forcelimit = ui.new_multiselect(tab,"Fake lag", "\aFFFFFF8DLow fakelag", "While standing", "While shooting", "While OS-AA")
}

for i=1, 7 do
	elements[i] = {
		enable_state =  ui.new_checkbox(tab, container, "\aFFFFFF8DOverride ".. "[\aDBCDFFFF"..var.p_states[i].."\aFFFFFF8D] state"),
		yawaddl = ui.new_slider(tab, container, "\aFFFFFF8Dadd yaw -\aDBCDFFFF> left\n" .. var.p_states[i], -180, 180, 0),
		yawaddr = ui.new_slider(tab, container, "\aFFFFFF8Dadd yaw -\aDBCDFFFF> right\n" .. var.p_states[i], -180, 180, 0),
		yaw_jitt = ui.new_combobox(tab, container, "\aFFFFFF8Dyaw jitter\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		yaw_jitt_addl = ui.new_slider(tab, container, "\aFFFFFF8Dadd yaw jitter -\aDBCDFFFF> left\n" .. var.p_states[i], -180, 180, 0),
		yaw_jitt_addr = ui.new_slider(tab, container, "\aFFFFFF8Dadd yaw jitter -\aDBCDFFFF> right\n" .. var.p_states[i], -180, 180, 0),
		b_yaw = ui.new_combobox(tab, container, "\aFFFFFF8Dbody yaw options\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		body_left = ui.new_slider(tab, container, "\aFFFFFF8Dadd body yaw -\aDBCDFFFF> left\n".. var.p_states[i], -180, 180, 0),
		body_right = ui.new_slider(tab, container, "\aFFFFFF8Dadd body yaw -\aDBCDFFFF> right\n" .. var.p_states[i], -180, 180, 0),
		fake_left = ui.new_slider(tab, container, "\aFFFFFF8Dadd fake limit -\aDBCDFFFF> left\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fake_right = ui.new_slider(tab, container, "\aFFFFFF8Dadd fake limit -\aDBCDFFFF> right\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		antibrute =  ui.new_checkbox(tab, container, "\aDBCDFFFF["..var.p_states[i].."]\aFFFFFF8D anti-bruteforce\n"),
		disable_jitt = ui.new_checkbox(tab, container, "\aDBCDFFFF["..var.p_states[i].."]\aFFFFFF8D disable jitter on fakelag\n"),
        force_defens = ui.new_checkbox(tab,container, "\aDBCDFFFF["..var.p_states[i].."]\aFFFFFF8D force defensive\n")
	}
end

function funcs:oppositefix(c)
	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end

local function renderer_shit(x, y, w, r, g, b, a, edge_h)if edge_h == nil then edge_h = 0 end local c1,c2,c3 = ui.get(vis.main_clr)	local hex = funcs:RGBtoHEX(c1,c2,c3)renderer.rectangle(x+2, y-2, w-5, 2.5, 15, 15, 15, 120)	renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 200)renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 200)renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 120)renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 120)renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 200)renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 120)renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 200)renderer.rectangle(x+2, y, w-5, 16, 0, 0, 0, 255)renderer.gradient(x+w-2, y+19, 2, -19+edge_h, c1, c2, c3, 255, c1, c2, c3, 0, false)renderer.gradient(x-1, y-2, 2, 19+edge_h, c1, c2, c3, 255, c1, c2, c3, 0, false)renderer.gradient(x, y-2, 50+edge_h, 2, c1, c2, c3, 255, c1, c2, c3, 0, true)renderer.gradient(x+w-2, y+17, -50+edge_h, 2, c1, c2, c3, 255, c1, c2, c3, 0, true)end
local yaw_am, yaw_val = ui.reference(tab,container,"Yaw")
jyaw, jyaw_val = ui.reference(tab,container,"Yaw Jitter")
local byaw2, byaw_val2 = ui.reference(tab,container,"Body yaw")
byaw, byaw_val = ui.reference(tab,container,"Body yaw")
fs_body_yaw = ui.reference(tab,container,"Freestanding body yaw")
fake_yaw = ui.reference(tab,container,"Fake yaw limit")

function gui:set_og_menu(state)
	ui.set_visible(reference.antiaim.pitch, state)
	ui.set_visible(reference.antiaim.yawbase, state)
	ui.set_visible(reference.antiaim.yaw[1], state)
	ui.set_visible(reference.antiaim.yaw[2], state)
	ui.set_visible(reference.antiaim.yaw_jitt[1], state)
	ui.set_visible(reference.antiaim.yaw_jitt[2], state)
	ui.set_visible(reference.antiaim.body_yaw[1], state)
	ui.set_visible(reference.antiaim.body_yaw[2], state)
	ui.set_visible(reference.antiaim.freestand[1], state)
	ui.set_visible(reference.antiaim.freestand[2], state)
	ui.set_visible(reference.antiaim.fsbodyyaw, state)
	ui.set_visible(reference.antiaim.fakeyawlimit, state)
	ui.set_visible(reference.antiaim.edgeyaw, state)
	ui.set_visible(reference.antiaim.roll, state)
end

_G.momentum_push=(function()
	_G.momentum_stored_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.momentum_stored_cache;
			for g=#f,1,-1 do
				_G.momentum_stored_cache[g].time=_G.momentum_stored_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local lerpy2 = 50
				local j=f[g]
				if j.time<0 then
					table.remove(_G.momentum_stored_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1 and 1 or k;
				if j.time<1 or k<1 then
					i=(k<1 and k or j.time)/1;
					i2=(k<1 and k or j.time)/1;
					h=i*255;
					lerpy=i*150	;
					lerp_circ=i*0.5
					lerpy2=i*50
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"Momentum  "..j.draw)*1)}
			local n={renderer.measure_text(nil,"Momentum  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*12.5+e}
			local c1,c2,c3,c4 = ui.get(vis.main_clr)
			local x, y = client.screen_size()
			renderer.rectangle(p[1]-1, p[2]-19, m[1]+2, 22, 19, 7, 8,h > 255 and 255 or h)
			renderer.circle(p[1]-1, p[2]-8, 18, 7, 8, h > 255 and 255 or h, 11, 180, 0.5)
			renderer.circle(p[1]+m[1]+1, p[2]-8, 18, 7, 8, h > 255 and 255 or h, 11.4, 0, 0.5)
			renderer.circle_outline(p[1]-1,p[2]-8, c1,c2,c3,h > 200 and 200 or h, 12, 90, lerp_circ, 2)
			renderer.circle_outline(p[1]+m[1]+1,p[2]-8, c1,c2,c3,h > 200 and 200 or h, 12, -90, lerp_circ, 2)
			renderer.line(p[1]+m[1]+2, p[2]+3, p[1] + 149-lerpy, p[2]+3, c1, c2, c3, h > 225 and 225 or h)
			renderer.line(p[1]-1,p[2]-19,p[1]-149+m[1]+lerpy,p[2]-19,c1,c2,c3, h > 255 and 255 or h)	
			renderer.line(p[1]+m[1]+2, p[2]+3, p[1] + 149-lerpy, p[2]+3, c1, c2, c3, h > 225 and 225 or h)
			renderer.line(p[1]-1,p[2]-19,p[1]-149+m[1]+lerpy,p[2]-19,c1,c2,c3, h > 255 and 255 or h)	
			renderer.text(p[1]+m[1]/2-o[1]/2 - 2,p[2] - 9,c1,c2,c3,h,"c",nil,"Momentum")
			renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h>255 and 255 or h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.momentum_stored_cache[g]=_G.momentum_stored_cache[g-1]
	end;
	_G.momentum_stored_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

local obex_data = obex_fetch and obex_fetch() or {username = 'Admin', build = 'Source'}

momentum_push:paint(5,"connection success, welcome - ".. string.lower(obex_data.username) .." - build: " .. string.lower(obex_data.build) .."")

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

function funcs:RGBtoHEX(redArg, greenArg, blueArg)
	return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)
end

hitgroup_names = {"generic","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"}

function logs:hit(e)
	local enemies = entity.get_players(true)
	local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
	local name = string.lower(entity.get_player_name(e.target))
	local health = entity.get_prop(e.target, "m_iHealth")
	local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
	local chance = math.floor(e.hit_chance)
	local bt = globals.tickcount() - e.tick
	local r,g,b = 102, 255, 153
	local hex = funcs:RGBtoHEX(r,g,b)

	if helper:contains(vis.print_to, "Screen") then	
	momentum_push:paint(3, string.format("\a".. hex .."Hit \aFFFFFFFF" .. name .. "'s \a".. hex .. hgroup .. "\aFFFFFFFF for \a".. hex .. e.damage .. "\aFFFFFFFF remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .. " bt: "    .. bt .. ""))
	end
	if helper:contains(vis.print_to, "Console") and ui.get(vis.enable_logs) then
		client.color_log(158, 146, 252, "[momentum] \0")
		client.color_log(255, 255, 255, "Hit " .. name .. "'s " .. hgroup .. " for " .. e.damage .. " and remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .. " bt: "  .. bt .. "")
	end
end

function logs:miss(e)
	local enemies = entity.get_players(true)
	local hgroup = hitgroup_names[e.hitgroup + 1] or "?"
	local name = string.lower(entity.get_player_name(e.target))
	local health = entity.get_prop(e.target, "m_iHealth")
	local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60)
	local chance = math.floor(e.hit_chance)
	local bt = globals.tickcount() - e.tick
	local r,g,b = 255, 102, 102
	local hex = funcs:RGBtoHEX(r,g,b)
	local r1,g1,b1 = 255, 255, 255
	local hex2 = funcs:RGBtoHEX(r1,g1,b1)

	if helper:contains(vis.print_to, "Screen") then	
	momentum_push:paint(3, string.format("\a".. hex .. "Missed \aFFFFFFFF" .. name .. "'s \a"..hex .. hgroup .. "\aFFFFFFFF due to \a".. hex .. e.reason ..  "\aFFFFFFFF remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .." bt: " .. bt .. ""))
	end
	if helper:contains(vis.print_to, "Console") and ui.get(vis.enable_logs) then
		client.color_log(158, 146, 252, "[momentum] \0")
		client.color_log(255, 255, 255, "Missed " .. name .. "'s " .. hgroup .. " due to " .. e.reason ..  " and remaining (" .. health .. "hp) angle: " .. angle .. "° hc: ".. chance .." bt: " .. bt .. "")
	end
	
	if e.reason ~= "?" then
		return 
	end
end
function gui:set_lua_menu()
	var.active_i = var.s_to_int[ui.get(elements[0].player_state)]
	local aa_tab = ui.get(elements[0].lua_select) == 1
	local vis_tab = ui.get(elements[0].lua_select) == 2
	local mics_tab = ui.get(elements[0].lua_select) == 3
	local is_knife = ui.get(misc.anti_knife)
	local main = ui.get(elements[0].additions)
	local add_main = ui.get(elements[0].additions) == "Main"
	local add_keys = ui.get(elements[0].additions) == "Keybinds"
	
	ui.set_visible(elements[0].lua_select, true)
	gui:set_og_menu(false)

	if add_main and aa_tab and not add_keys then
		ui.set_visible(elements[0].fs_options, true)
		ui.set_visible(elements[0].fs_dis, true)
		ui.set_visible(elements[0].aa_abf, true)
		ui.set_visible(elements[0].additions, true)
		ui.set_visible(elements[0].aa_builder, true)
		ui.set_visible(elements[0].aa_presets, true)
		ui.set_visible(elements[0].additions, true)
		ui.set_visible(elements[0].legit_aa, true)
	else
		ui.set_visible(elements[0].fs_options, false)
		ui.set_visible(elements[0].fs_dis, false)
		ui.set_visible(elements[0].aa_abf, false)
		ui.set_visible(elements[0].legit_aa, false)
		ui.set_visible(elements[0].aa_presets, false)
		ui.set_visible(elements[0].additions, false)
		ui.set_visible(elements[0].additions, true)
		ui.set_visible(elements[0].aa_builder, false)
	end

	if add_keys and aa_tab and not add_main then
		ui.set_visible(elements[0].manual_left, true)
		ui.set_visible(elements[0].manual_right, true)
		ui.set_visible(elements[0].manual_forward, true)
		ui.set_visible(elements[0].manual_reset, true)
		ui.set_visible(elements[0].fs, true)
		ui.set_visible(elements[0].edge_yaw, true)
		ui.set_visible(elements[0].fs_label, true)
		ui.set_visible(elements[0].force_label, true)
		ui.set_visible(elements[0].force_def, true)
	else
		ui.set_visible(elements[0].edge_yaw, false)
		ui.set_visible(elements[0].manual_left, false)
		ui.set_visible(elements[0].manual_right, false)
		ui.set_visible(elements[0].manual_forward, false)
		ui.set_visible(elements[0].manual_reset, false)
		ui.set_visible(elements[0].fs, false)
		ui.set_visible(elements[0].fs_label, false)
		ui.set_visible(elements[0].force_label, false)
		ui.set_visible(elements[0].force_def, false)		
	end

	if add_main and add_main and aa_tab then
		ui.set_visible(elements[0].additions, true)
	else
		ui.set_visible(elements[0].additions, true)
	end

	if vis_tab then
		ui.set_visible(elements[0].additions, false)
		ui.set_visible(vis.enable_logs, true)
		ui.set_visible(vis.print_to, true)
		ui.set_visible(vis.main_clr, true)
		ui.set_visible(vis.main_clr_l, true)
		ui.set_visible(vis.main_clr2, true)
		ui.set_visible(vis.inds_selct, true)
		ui.set_visible(vis.enable_anim, true)
		ui.set_visible(vis.anims_speed, true)
		ui.set_visible(vis.main_clr_l2, true)
		ui.set_visible(vis.watermark_on, true)
		ui.set_visible(vis.manaa_inds, true)
		if ui.get(vis.enable_anim) then
			ui.set_visible(vis.anims_speed, true)
		else
			ui.set_visible(vis.anims_speed, false)
		end
		if ui.get(vis.enable_logs) then
			ui.set_visible(vis.print_to, true)
		else
			ui.set_visible(vis.print_to, false)
		end
	else
		ui.set_visible(vis.enable_logs, false)
		ui.set_visible(vis.print_to, false)
		ui.set_visible(vis.main_clr, false)
		ui.set_visible(vis.main_clr_l, false)
		ui.set_visible(vis.main_clr2, false)
		ui.set_visible(vis.inds_selct, false)
		ui.set_visible(vis.enable_anim, false)
		ui.set_visible(vis.anims_speed, false)
		ui.set_visible(vis.main_clr_l2, false)
		ui.set_visible(vis.watermark_on, false)
		ui.set_visible(vis.manaa_inds, false)
	end

	if mics_tab then		
		ui.set_visible(elements[0].additions, false)
		ui.set_visible(misc.prefer_baim, true)
		ui.set_visible(misc.force_baim, true)
		ui.set_visible(misc.jumpsc_out, true)
		ui.set_visible(misc.animations, true)
		ui.set_visible(misc.pred_sw, true)
		ui.set_visible(misc.anti_knife, true)
		if is_knife then
			ui.set_visible(misc.knife_distance, true)
		else
			ui.set_visible(misc.knife_distance, false)
		end
	else
		ui.set_visible(misc.prefer_baim, false)
		ui.set_visible(misc.force_baim, false)
		ui.set_visible(misc.jumpsc_out, false)
		ui.set_visible(misc.animations, false)
		ui.set_visible(misc.pred_sw, false)
		ui.set_visible(misc.anti_knife, false)
		ui.set_visible(misc.knife_distance, false)
	end

	if ui.get(elements[0].aa_presets) == "Jitter #2" and aa_tab then
		ui.set_visible(elements[0].aa_stc_tillhit, false)
	else
		ui.set_visible(elements[0].aa_stc_tillhit, false)
	end

	if ui.get(fl_tab.advanced_fl) then 
		ui.set_visible(fl_tab.advanced_fl, true)
        ui.set_visible(reference.fakelag.enablefl,false)
        ui.set_visible(reference.fakelag.fl_amount,false)
        ui.set_visible(reference.fakelag.fl_limit,false)
        ui.set_visible(reference.fakelag.fl_var,false)
        ui.set_visible(fl_tab.fakelag_tab, true)
        if ui.get(fl_tab.fakelag_tab) == "Dynamic" then
            ui.set_visible(fl_tab.trigger,true)
        else
            ui.set_visible(fl_tab.trigger,false)
        end
        if ui.get(fl_tab.fakelag_tab) == "Maximum" then
            ui.set_visible(fl_tab.triggerlimit,false)
        else
            ui.set_visible(fl_tab.triggerlimit,true)
        end
        ui.set_visible(fl_tab.sendlimit,true)
        ui.set_visible(fl_tab.forcelimit,true)
    else
        ui.set_visible(reference.fakelag.enablefl,true)
        ui.set_visible(reference.fakelag.fl_amount,true)
        ui.set_visible(reference.fakelag.fl_limit,true)
        ui.set_visible(reference.fakelag.fl_var,true)
        ui.set_visible(fl_tab.fakelag_tab, false)
        ui.set_visible(fl_tab.trigger,false)
        ui.set_visible(fl_tab.forcelimit,false)
        ui.set_visible(fl_tab.triggerlimit,false)
        ui.set_visible(fl_tab.sendlimit,false)
    end

	if ui.get(elements[0].aa_builder) then
		for i=1, 7 do
			ui.set_visible(elements[i].enable_state,var.active_i == i and aa_tab and add_main)
			ui.set_visible(elements[0].player_state,aa_tab and add_main)

			if ui.get(elements[i].enable_state) then
				ui.set_visible(elements[i].yawaddl,var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].yawaddr,var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].yaw_jitt,var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].yaw_jitt_addl,var.active_i == i and ui.get(elements[var.active_i].yaw_jitt) ~= "off" and ui.get(elements[var.active_i].yaw_jitt) ~= "offset" and aa_tab and add_main)
				ui.set_visible(elements[i].yaw_jitt_addr,var.active_i == i and ui.get(elements[var.active_i].yaw_jitt) ~= "off" and aa_tab and add_main)
				ui.set_visible(elements[i].body_left or elements[i].body_right,var.active_i == i and aa_tab and add_main and ui.get(elements[i].b_yaw) ~= "off" and ui.get(elements[i].b_yaw) ~= "opposite")
				ui.set_visible(elements[i].b_yaw, var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].antibrute, var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].disable_jitt, var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].force_defens, var.active_i == i and aa_tab and add_main)
				ui.set_visible(elements[i].body_left, var.active_i == i and ui.get(elements[i].b_yaw) ~= "off" and ui.get(elements[i].b_yaw) ~= "opposite" and aa_tab and add_main)
				ui.set_visible(elements[i].body_right, var.active_i == i and ui.get(elements[i].b_yaw) ~= "off" and ui.get(elements[i].b_yaw) ~= "opposite" and aa_tab and add_main)
				ui.set_visible(elements[i].fake_left,var.active_i == i and aa_tab and add_main) 
				ui.set_visible(elements[i].fake_right,var.active_i == i and aa_tab and add_main)
			else
				ui.set_visible(elements[i].yawaddl,false)
				ui.set_visible(elements[i].yawaddr,false)
				ui.set_visible(elements[i].yaw_jitt,false)
				ui.set_visible(elements[i].yaw_jitt_addl,false)
				ui.set_visible(elements[i].yaw_jitt_addr,false)
				ui.set_visible(elements[i].antibrute, false)
				ui.set_visible(elements[i].disable_jitt, false)
				ui.set_visible(elements[i].force_defens, false)
				ui.set_visible(elements[i].b_yaw,false)
				ui.set_visible(elements[i].body_left,false)
				ui.set_visible(elements[i].body_right,false)
				ui.set_visible(elements[i].fake_left,false)
				ui.set_visible(elements[i].fake_right,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(elements[i].enable_state,false)
			ui.set_visible(elements[0].player_state,false)
			ui.set_visible(elements[i].yawaddl,false)
			ui.set_visible(elements[i].yawaddr,false)
			ui.set_visible(elements[i].yaw_jitt,false)
			ui.set_visible(elements[i].yaw_jitt_addl,false)
			ui.set_visible(elements[i].yaw_jitt_addr,false)
			ui.set_visible(elements[i].b_yaw,false)
			ui.set_visible(elements[i].antibrute, false)
			ui.set_visible(elements[i].disable_jitt, false)
			ui.set_visible(elements[i].force_defens, false)
			ui.set_visible(elements[i].body_left,false)
			ui.set_visible(elements[i].body_right,false)
			ui.set_visible(elements[i].fake_left,false)
			ui.set_visible(elements[i].fake_right,false)	
		end
	end
end

function main:anti_knife_dist(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function main:anti_knife()
    if ui.get(misc.anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference(tab, container, "Yaw")
        local pitch = ui.reference(tab, container, "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = main:anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(misc.knife_distance) then
                ui.set(yaw_slider,180)
                ui.set(pitch,"Off")
			else
				ui.set(pitch,"Minimal")
            end
        end
    end
end

local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0

function funcs:normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

function funcs:ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

function funcs:get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(funcs:normalize_yaw(funcs:ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

function funcs:extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

function funcs:get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

function funcs:get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return funcs:normalize_yaw(model_yaw - eye_yaw)
end

function funcs:in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	if bit.band(flags, 1) == 0 then
		return true
	end
	
	return false
end

local ChokedCommands = 0

local lastdt = 0

swap_angle = false
ground_ticks, end_time = 1, 0

function funcs:apply_variance(ticks, wish_variance, seed)
    wish_variance = wish_variance >= ticks and ticks-1 or wish_variance
    local minimum_ticks = ticks-wish_variance
    math.randomseed(seed or client.timestamp())
    return math.random(minimum_ticks, ticks)
end

function funcs:consistent(wish_ticks, maximum_ticks)
    return math.min(wish_ticks, maximum_ticks)
end

function main:on_setup_command(c)
	local plocal = entity.get_local_player()
	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
	local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2])
	local wpn = entity.get_player_weapon(plocal)
	local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")
	local is_def = ui.get(elements[0].aa_builder) and ui.get(elements[var.p_state].force_defens) and ui.get(elements[var.p_state].enable_state)
    local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
    local is_os = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])


	if not is_dt and not is_os and ui.get(elements[7].enable_state) and ui.get(elements[0].aa_builder) then		
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
	if ui.get(elements[0].force_def) or is_def and ui.get(reference.rage.dt[2]) then
		c.force_defensive = true
		c.no_choke = true
		c.quick_stop = true
	else
		c.force_defensive = false
		c.no_choke = false
		c.quick_stop = false
	end

	if ui.get(misc.jumpsc_out) then
		local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
		local vel = math.sqrt(vel_x^2 + vel_y^2)
		ui.set(reference.rage.air_strafe, not (c.in_jump and (vel < 10)) or ui.is_menu_open())
	end
end

function main:fl_adaptive(c)
	local m_velocity = vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity'))

	local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
	local distance_per_tick = m_velocity:length2d() * globals.tickinterval()
	local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

	if on_ground == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime() + 1
    end 
	
	if not entity.is_alive(entity.get_local_player()) then 
		return
	end

	local lpweapon = entity.get_player_weapon(entity.get_local_player())
	local wpnindx = bit.band(65535,entity.get_prop(lpweapon, "m_iItemDefinitionIndex"))

	if wpnindx == nil or lpweapon == nil then
		return
	end

	local moving_t = distance_per_tick > 0.0158 and not funcs:in_air(entity.get_local_player()) and (helper:contains(fl_tab.trigger, "Moving"))
    local air_t = funcs:in_air(entity.get_local_player()) and (helper:contains(fl_tab.trigger, "In air"))
    local standing_t = distance_per_tick < 0.0158 and (helper:contains(fl_tab.trigger, "Standing"))
    local land_heavy_t = ground_ticks > c.chokedcommands+1 and end_time > globals.curtime() and (helper:contains(fl_tab.trigger, "On land") )
	local p_slow = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2]) and (helper:contains(fl_tab.trigger, "Slowwalk") )

    if air_t or moving_t or land_heavy_t or standing_t or ui.get(reference.rage.fakeduck) or p_slow then
        triggering = true 
    else
        triggering = false
    end 

	local lc = funcs:in_air(entity.get_local_player()) or distance_per_tick >= 3 or ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2]) and distance_per_tick > 0.0158
	if ui.get(reference.rage.fakeduck) then
        choke = 14
    else
        if (c.in_attack == 1 and helper:contains(fl_tab.forcelimit, "While shooting") and not (wpnindx == 44 or wpnindx == 46 or wpnindx == 43 or wpnindx == 47 or wpnindx == 45 or wpnindx == 48)) or (distance_per_tick < 0.0158 and not funcs:in_air(entity.get_local_player()) and helper:contains(fl_tab.forcelimit, "While standing")) or (ui.get(reference.rage.os[2]) and helper:contains(fl_tab.forcelimit, "While OS-AA")) then
            choke = 1
        elseif ui.get(fl_tab.fakelag_tab) == "Maximum" then
            choke = ui.get(fl_tab.sendlimit)
        elseif ui.get(fl_tab.fakelag_tab) == "Dynamic" then
            choke = (triggering == true and ui.get(fl_tab.triggerlimit) or ui.get(fl_tab.sendlimit))
        else
            choke = (swap_angle and ui.get(fl_tab.triggerlimit) or ui.get(fl_tab.sendlimit))
        end
    end

	local fl_stabile = lc and 14 or choke
	
	local send = funcs:consistent(14,15)
    local lagcomp = lc and send or 2
    local outgoing_cmd = globals.lastoutgoingcommand() / globals.tickcount() *5
    local amount = funcs:apply_variance(lagcomp, 1, outgoing_cmd) == 2 and fl_stabile or 0

	if ui.get(fl_tab.advanced_fl) then
        ui.set(reference.fakelag.enablefl, false)
        ui.set(reference.fakelag.fl_limit,choke)
        ui.set(reference.fakelag.fl_amount, "Maximum")
        ui.set(reference.fakelag.fl_var, 0)

        c.allow_send_packet = amount
    else
        ui.set(reference.fakelag.enablefl, true)
    end
end

function main:anti_aim_on_use(e)
    if ui.get(elements[0].legit_aa) and e.in_use == 1 then
		ui.set(reference.antiaim.yaw[2], 0)
		ui.set(reference.antiaim.yaw_jitt[2], 0)
		ui.set(reference.antiaim.body_yaw[1], "Static")
		ui.set(reference.antiaim.fsbodyyaw, true)
        if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CC4" then return end
        if e.in_attack == 1 then
            e.in_use = 1
        end
        if e.chokedcommands == 0 then
            e.in_use = 0
        end
    end
end

local mode = (function()
	local aa = {}
	aa.sync = function(a,b)
		local invert = (math.floor(math.min(ui.get(reference.antiaim.fakeyawlimit), (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (ui.get(reference.antiaim.fakeyawlimit) * 2) - ui.get(reference.antiaim.fakeyawlimit))))) > 0

		return invert  and a or b
	end
	return aa
end)()

local back_dir = true
local left_dir = false
local right_dir = false
local forward_dir = false

function main:fs_diablers()
	freestanddisabled = false

	if ui.get(elements[0].edge_yaw) then
		ui.set(reference.antiaim.edge, true)
	else
		ui.set(reference.antiaim.edge, false)
    end

	if ui.get(elements[0].fs) then
		ui.set(reference.antiaim.freestand[1], "Default")
		ui.set(reference.antiaim.freestand[2], "Always on")
	end
	if helper:contains(elements[0].fs_dis, "Stand") and var.p_state == 1 then
		freestanddisabled = true
	end
	if helper:contains(elements[0].fs_dis, "Move") and var.p_state == 2 then
		freestanddisabled = true
	end
	if helper:contains(elements[0].fs_dis, "Slowwalk") and var.p_state == 3 then
		freestanddisabled = true
	end
	if helper:contains(elements[0].fs_dis, "In Air") and var.p_state == 4 or helper:contains(elements[0].fs_dis, "In Air") and var.p_state == 6 then
		freestanddisabled = true
	end
	if helper:contains(elements[0].fs_dis, "Crouch") and var.p_state == 5 then
		freestanddisabled = true
	end
	if helper:contains(elements[0].fs_dis, "Fakeduck") and ui.get(reference.rage.fakeduck) then
		freestanddisabled = true
	end
	if not ui.get(elements[0].fs) or freestanddisabled then
		ui.set(reference.antiaim.freestand[1], {})
	end
end

manaa = function()
	ui.set(yaw_am,"180")
	ui.set(reference.antiaim.yawbase,"Local view")
	ui.set(reference.antiaim.yaw_jitt[1], "Off")
	ui.set(reference.antiaim.body_yaw[1], "Static")
    ui.set(reference.antiaim.body_yaw[2], "0")
end

function main:manualaa()
	if ui.get(elements[0].manual_reset) then
		back_dir = true
		right_dir = false
		left_dir = false
		elements[0].last_press = globals.curtime()
	elseif ui.get(elements[0].manual_right) then
		if right_dir == true and elements[0].last_press + 0.02 < globals.curtime() then
		back_dir = true
		right_dir = false
		left_dir = false
		forward_dir = false
		elseif right_dir == false and elements[0].last_press + 0.02 < globals.curtime() then
		right_dir = true
		back_dir = false
		left_dir = false
		forward_dir = false
		end
		elements[0].last_press = globals.curtime()
	elseif ui.get(elements[0].manual_left) then
		if left_dir == true and elements[0].last_press + 0.02 < globals.curtime() then
		back_dir = true
		right_dir = false
		left_dir = false
		forward_dir = false
		elseif left_dir == false and elements[0].last_press + 0.02 < globals.curtime() then
		left_dir = true
		back_dir = false
		right_dir = false
		forward_dir = false
		end
		elements[0].last_press = globals.curtime()
	elseif ui.get(elements[0].manual_forward) then
		if forward_dir == true and elements[0].last_press + 0.02 < globals.curtime() then
		back_dir = true
		right_dir = false
		left_dir = false
		forward_dir = false
		elseif forward_dir == false and elements[0].last_press + 0.02 < globals.curtime() then
		left_dir = false
		back_dir = false
		right_dir = false
		forward_dir = true
		end
	end

	if right_dir == true then
		manaa()
		ui.set(yaw_val,90)
	elseif left_dir == true then
		manaa()
		ui.set(yaw_val,-90)
	elseif forward_dir == true then
		manaa()
		ui.set(yaw_val, 180)
	end
end

function main:freestand()
	local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local is_fs = ui.get(elements[0].fs) and not freestanddisabled
	local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = b_yaw > 0 and 1 or -1
	local disable_on_fl = ui.get(elements[var.p_state].disable_jitt) and not ui.get(reference.rage.os[2]) and not ui.get(reference.rage.dt[2])
	if ui.get(elements[0].fs_options) == 2 and is_fs or disable_on_fl then			
		ui.set(reference.antiaim.yaw[1], "180")
		ui.set(reference.antiaim.pitch, "Down")
		ui.set(reference.antiaim.yaw[2], (side == 1 and 0 or 0))
		ui.set(reference.antiaim.yaw_jitt[1], "Off")
		ui.set(reference.antiaim.body_yaw[1], "Opposite")
		ui.set(reference.antiaim.yawbase, "At targets")
	end
	local is_sw = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2])
	local exploting = ui.get(reference.rage.dt[2]) or ui.get(reference.rage.os[2]) or ui.get(reference.rage.fakeduck)

    if not exploting and is_sw then
        ui.set(reference.rage.slow_type, (swap_angle and "Favor anti-aim" or "Favor high speed"))
    else
        ui.set(reference.rage.slow_type, "Favor high speed")
    end
end

function main:antiaim(c)
	funcs:oppositefix(c)
	if not entity.is_alive(entity.get_local_player()) then
		return
	end

	local is_os = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
	local is_fd = ui.get(reference.rage.fakeduck)
	local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
	local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = b_yaw > 0 and 1 or -1

	if back_dir == true then
		ui.set(reference.antiaim.fsbodyyaw, false)
		ui.set(byaw, ui.get(elements[var.p_state].b_yaw))
		if ui.get(elements[var.p_state].enable_state) and ui.get(elements[0].aa_builder) then
			ui.set(reference.antiaim.yaw[1], "180")
			if var.p_state == 6 then
				ui.set(reference.antiaim.pitch, "Default")
			else
				ui.set(reference.antiaim.pitch, "Minimal")
			end
			ui.set(jyaw, ui.get(elements[var.p_state].yaw_jitt))
			if c.chokedcommands ~= 0 then
			else
				ui.set(reference.antiaim.body_yaw[2], (side == 1 and ui.get(elements[var.p_state].body_left) or ui.get(elements[var.p_state].body_right))) 
				ui.set(yaw_val,(side == 1 and ui.get(elements[var.p_state].yawaddl) or ui.get(elements[var.p_state].yawaddr)))
				ui.set(jyaw_val,(side == 1 and ui.get(elements[var.p_state].yaw_jitt_addl) or ui.get(elements[var.p_state].yaw_jitt_addr)))
			end
			if b_yaw < 0 then
				ui.set(fake_yaw, ui.get(elements[var.p_state].fake_right))
			elseif b_yaw > 0 then
				ui.set(fake_yaw, ui.get(elements[var.p_state].fake_left))
			end
		else
			ui.set(reference.antiaim.fsbodyyaw, false)
			ui.set(reference.antiaim.pitch, "Minimal")
			if ui.get(elements[0].aa_presets) == 1 then
				if var.p_state == 1 then
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.body_yaw[1], "jitter")
					if c.chokedcommands ~= 0 then
					else
						ui.set(reference.antiaim.yaw[2], mode.sync(-10,21))
						ui.set(reference.antiaim.yaw_jitt[2], mode.sync(26,26))
						ui.set(reference.antiaim.body_yaw[2], mode.sync(16,0))
						ui.set(reference.antiaim.fakeyawlimit, mode.sync(33,54))
					end
				elseif var.p_state == 2 then
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], 49)
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					if c.chokedcommands ~= 0 then
					else
						ui.set(reference.antiaim.yaw[2], mode.sync(-2,26))
					end
					ui.set(reference.antiaim.body_yaw[2], 0)
					ui.set(reference.antiaim.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(reference.antiaim.yaw[2], mode.sync(-13,9))
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], 50)
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], 0)
					ui.set(reference.antiaim.fakeyawlimit, 59)
				elseif var.p_state == 4 then
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					if c.chokedcommands ~= 0 then
					else
						ui.set(reference.antiaim.yaw[2], mode.sync(14,12))
						ui.set(reference.antiaim.yaw_jitt[2], mode.sync(30,33))
						ui.set(reference.antiaim.body_yaw[2], mode.sync(10,0))
						ui.set(reference.antiaim.fakeyawlimit, mode.sync(60,60))
					end
				elseif var.p_state == 5 then
					ui.set(reference.antiaim.yaw[2], mode.sync(-12,17))
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], 43)
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], 0)
					ui.set(reference.antiaim.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(reference.antiaim.yaw[2], mode.sync(-12,15))
						ui.set(reference.antiaim.yaw_jitt[2], mode.sync(30,44))
					end
					ui.set(reference.antiaim.fakeyawlimit, 60)
				end
			elseif ui.get(elements[0].aa_presets) == 2 then
				if var.p_state == 1 then
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(reference.antiaim.yaw[2], mode.sync(5,0))
						ui.set(reference.antiaim.yaw_jitt[2], mode.sync(-5,0))
					end
					ui.set(reference.antiaim.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					if is_dt or is_os then
					ui.set(reference.antiaim.yaw[2], mode.sync(11,11))
					ui.set(reference.antiaim.yaw_jitt[1], "center")
					ui.set(reference.antiaim.yaw_jitt[2], mode.sync(-76,-77))
					ui.set(reference.antiaim.body_yaw[1], "off")
					ui.set(reference.antiaim.fakeyawlimit, mode.sync(60,60))
					else
						ui.set(reference.antiaim.yaw[2], 0)
						ui.set(reference.antiaim.yaw_jitt[2], 0)
						ui.set(reference.antiaim.body_yaw[1], "Opposite")
						ui.set(reference.antiaim.yawbase, "At targets")
						ui.set(reference.antiaim.fakeyawlimit, 60)
					end
				elseif var.p_state == 3 then
					ui.set(reference.antiaim.yaw[2], mode.sync(-8,-17))
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], mode.sync(5,17))
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], mode.sync(-43,43))
					ui.set(reference.antiaim.fakeyawlimit, mode.sync(59,59))
				elseif var.p_state == 4 then
					if is_dt or is_os then
					ui.set(reference.antiaim.yaw[2], 0)
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], mode.sync(30,60))
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], mode.sync(-60,30))
					ui.set(reference.antiaim.fakeyawlimit, mode.sync(60,60))
					else
						ui.set(reference.antiaim.yaw[2], 0)
						ui.set(reference.antiaim.yaw_jitt[2], 0)
						ui.set(reference.antiaim.body_yaw[1], "Opposite")
						ui.set(reference.antiaim.yawbase, "At targets")
						ui.set(reference.antiaim.fakeyawlimit, 60)
					end							
				elseif var.p_state == 5 then
					ui.set(reference.antiaim.yaw[2], mode.sync(0,25))
					ui.set(reference.antiaim.yaw_jitt[1], "center")
					ui.set(reference.antiaim.yaw_jitt[2], mode.sync(-70,0))
					ui.set(reference.antiaim.body_yaw[1], "static")
					ui.set(reference.antiaim.body_yaw[2], mode.sync(11,11))
					ui.set(reference.antiaim.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(reference.antiaim.yaw[2], mode.sync(0,0))
					ui.set(reference.antiaim.yaw_jitt[1], "Center")
					ui.set(reference.antiaim.yaw_jitt[2], mode.sync(30,0))
					ui.set(reference.antiaim.body_yaw[1], "Jitter")
					ui.set(reference.antiaim.body_yaw[2], mode.sync(0,30))
					ui.set(reference.antiaim.fakeyawlimit, 60)
				end
			end
		end
	end
end

function funcs:brute_impact(e)
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
		if ui.get(elements[0].aa_abf) or ui.get(elements[var.p_state].antibrute) then
			momentum_push:paint(5,"Switched side due to enemy shot")
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
	brute.misses_ind = { }
	brute.misses = { }
end

function funcs:weapon_is_enabled(idx)
	if (idx == 38 or idx == 11) then
		return true
	elseif (idx == 40) then
		return true
	elseif (idx == 9) then
		return true
	elseif (idx == 64) then
		return true
	elseif (idx == 1) then
		return true
	else
		return true
	end
	return false
end

function funcs:lethal_calc(player)
    local local_player = entity.get_local_player()
    if local_player == nil or not entity.is_alive(local_player) then return end
    local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
    local dstc = local_origin:dist(vector(entity.get_prop(player, "m_vecOrigin")))
    local enemy_health = entity.get_prop(player, "m_iHealth")

	local entity_weapon = entity.get_player_weapon(entity.get_local_player())
	if entity_weapon == nil then return end
	
	local weapon_idx = entity.get_prop(entity_weapon, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end

	if not funcs:weapon_is_enabled(weapon_idx) then return end

	local dmg_x_range = (weapon.damage * math.pow(weapon.range_modifier, (dstc * 0.002))) * 1.25
	local armor = entity.get_prop(player,"m_ArmorValue")
	local newdmg = dmg_x_range * (weapon.armor_ratio * 0.5)
	if dmg_x_range - (dmg_x_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
		newdmg = dmg_x_range - (armor / 0.5)
	end
	return newdmg >= enemy_health
end

function main:baim_if()
	local enemies = entity.get_players(true)
	local c1,c2,c3 = ui.get(vis.main_clr)

	for itter = 1, #enemies do
        local i = enemies[itter]
        
        if funcs:lethal_calc(i) then
            if helper:contains(misc.force_baim, "Lethal health") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif helper:contains(misc.prefer_baim, "Lethal health") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        elseif ui.get(reference.rage.damage) < 8 then
            if helper:contains(misc.force_baim, "Low damage") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif helper:contains(misc.prefer_baim, "Low damage") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        elseif funcs:in_air(i) then
            if helper:contains(misc.force_baim, "In air") then
                plist.set(i,"Override prefer body aim", "Force")
            elseif helper:contains(misc.prefer_baim, "In air") then
                plist.set(i,"Override prefer body aim", "On")
            else
                plist.set(i,"Override prefer body aim", "-")
            end
        else
            plist.set(i,"Override prefer body aim", "-")
        end
	end
end

function funcs:get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

function render:legfucker()
    local localplayer = entity.get_local_player()
	if not entity.is_alive(localplayer) then return end 
	local m_flDuckAmount = entity.get_prop(localplayer, "m_flDuckAmount") > 0.5
	local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
	local is_os = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
	local timer = globals.tickcount() % 20
    local lp_vel = funcs:get_velocity(entity.get_local_player())

	if helper:contains(misc.animations, "Leg breaker") and not funcs:in_air(localplayer) and timer > 1 then
		if var.p_state == 2 or var.p_state == 7 then
		ui.set(reference.rage.lm,swap_angle and lp_vel > 50 and "always slide" or "never slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
		end
	end

	if not is_dt and not is_os and not m_flDuckAmount and not helper:contains(misc.animations, "Leg breaker") then
		if var.p_state == 1 then
			entity.set_prop(localplayer, "m_flPoseParameter", 50 and 50 * 0.01 or 0, 3)
		elseif var.p_state == 3 then
			entity.set_prop(localplayer, "m_flPoseParameter", 5 and 50 * 0.01 or 0, 10)
		else
			entity.set_prop(localplayer, "m_flPoseParameter", 5 and 70 * 0.01 or 0, 8)
		end
	end
end

function rendering:old()
	local localplayer = entity.get_local_player( )
    if localplayer == nil then return end
	local is_sw = ui.get(reference.rage.slow[1]) and ui.get(reference.rage.slow[2])
	local bodyyaw = entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1

	if helper:contains(misc.animations, "Static legs") then 
        entity.set_prop(localplayer, "m_flPoseParameter", 1, 6) 
	end

	if helper:contains(misc.animations, "0 pitch on land") then
        local on_ground = bit.band(entity.get_prop(localplayer, "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
    
        if ground_ticks > ui.get(reference.fakelag.fl_limit)+1 and end_time > globals.curtime() then
            entity.set_prop(localplayer, "m_flPoseParameter", 0.5, 12)
        end
	end
	
	if helper:contains(misc.animations, "Static slowwalk legs") and is_sw then
		entity.set_prop(localplayer, "m_flPoseParameter", 0.9 * side, 11)
		entity.set_prop(localplayer, "m_flPoseParameter", 0, 9)
	end
end

render.center = {
	animtest = 0,
	dt = 0,
	fs = 0,
	baim = 0,
	sp = 0,
	s = 0,
	xx = 0,
	x1 =0,
	x2 = 0,
	x3 = 0,
	x4 = 0,
	x5 = 0,
	x6 = 0,
	x7 = 0,
	y1 = 0,
	y2 = 0,
	y3 = 0,
	y4 = 0,
	y5 = 0,
	y6 = 0,
	y7 = 0,
	bar = 0,
	dt_alpha = 0,
	hide_alpha = 0,
	baim_alpha = 0,
	duck_alpha = 0,
	sp_alpha = 0,
	glow = 0,
	glow2 = 0,
	testx = 0,
}

function render:watermark()
	swap_angle = not swap_angle
	local data_suffix = 'momentum.codes'
	local h, m, s, mst = client.system_time()
	local nickname = obex_data.username or "admin"
	local c1,c2,c3 = ui.get(vis.main_clr)
	local hex = funcs:RGBtoHEX(c1,c2,c3)
	local scriptVersion = obex_data.build or "beta";
	local latency = client.latency()*1000
	local latency_text = ('  %d'):format(latency) or ''
	text = ("\a"..hex.."%s\a737373FF |\a737373FF %s |\a"..hex.."%s \a737373FFms \a"..hex.."[%s] "):format(data_suffix, nickname, latency_text, scriptVersion)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10

	if ui.get(vis.watermark_on) then
		renderer_shit(x, y, w, 65, 65, 65, 255, 2)
		renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
	end
end

lerp = function(start, vend, time)
    return start + (vend - start) * time
end

function funcs:multicolor(r1, g1, b1, a1, r2, g2, b2, a2, str)
    local output = ''
    local len = #str
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i=1, len do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, str:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end
    return output
end

function funcs:map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

local font_123 = surface.create_font("Tahoma", 12, 12, 400, {16, 512})
local testx = 0
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

function helper:round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function render:indicators()	
	local b_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = b_yaw > 0 and 1 or -1
	local c1,c2,c3,c4 = ui.get(vis.main_clr)
	local c_1,c_2,c_3,c_4 = ui.get(vis.main_clr2)
	local x, y = client.screen_size()
	local me = entity.get_local_player()
	if not entity.is_alive(me) then return end
	local state = "MOVING"

    if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
        state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
    elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
        state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
    elseif var.p_state == 7 and ui.get(elements[0].aa_builder) then
        state = "FL"
    elseif var.p_state == 5 then
        state = "DUCK"
    elseif var.p_state == 6 then
        state = "AIR + D"
    elseif var.p_state == 4 then
        state = "AIR"
    elseif var.p_state == 3 then
        state = "SLOWMO"
    elseif var.p_state == 1 then
        state = "STAND"
    elseif var.p_state == 2 then
        state = "MOVE"
    end

	local realtime = globals.realtime() % 3
	local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
	local pulsating = math.min(math.floor(math.sin((globals.realtime() % 3) * 3) * 75 + 150), 255)
	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2])
	local is_os = ui.get(reference.rage.os[1]) and ui.get(reference.rage.os[2])
	local is_fs = ui.get(elements[0].fs) and freestanddisabled == false
	local is_ba = ui.get(reference.rage.forcebaim)
	local is_sp = ui.get(reference.rage.safepoint)
	local is_qp = ui.get(reference.rage.quickpeek[2])
	local exp_ind = ""
	if ui.get(vis.inds_selct) == "-" then return end

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
	local colored_text = funcs:multicolor(c1,c2,c3,255, c_1,c_2,c_3,255, 'MOMENTUM')
	local _, y2 = client.screen_size()
	local wpn_id = entity.get_prop(entity.get_player_weapon(me), "m_iItemDefinitionIndex")
    local is_grenade =({[43] = true, [44] = true, [45] = true, [46] = true, [47] = true, [48] = true, [68] = true})[wpn_id] or false
	local local_player = entity.get_local_player()
	local flag = "c-"
	local ting = 0
	local testting = 0

	if is_dt or is_os then
		n4_x = lerp(n4_x, 8, globals.frametime() * ui.get(vis.anims_speed) + 3)
	else
		n4_x = lerp(n4_x, -1, globals.frametime() * ui.get(vis.anims_speed) + 3)
	end

	if ui.get(vis.enable_anim) and act or is_grenade then 
		flag = "-"
		ting = 23
		testting = 11
		testx = lerp(testx, 32, globals.frametime() * ui.get(vis.anims_speed))
		n2_x = lerp(n2_x, 13, globals.frametime() * ui.get(vis.anims_speed))
		n3_x = lerp(n3_x, 7, globals.frametime() * ui.get(vis.anims_speed))
	else
		testx = lerp(testx, 0, globals.frametime() * ui.get(vis.anims_speed))
		n2_x = lerp(n2_x, 0, globals.frametime() * ui.get(vis.anims_speed))
		n3_x = lerp(n3_x, 0, globals.frametime() * ui.get(vis.anims_speed))
		flag = "c-"
		ting = 28
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if is_charged then dr,dg,db,da=167, 252, 121,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end

	if ui.get(vis.inds_selct) == "Minimalistic" then
		if is_dt then
			renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + os_y+ 13, dr, dg, db, os_a, "c-", os_w, "OS ")
		end
		renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + dt_y+ 13, dr, dg, db, dt_a, "c-", dt_w, "DT")
		renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 13, 255, 255, 255, fs_a, "c-", fs_w, "FS")
		renderer.text(x / 2-30 + testx, y / 2 + 25, 255, 255, 255, 255, "-", 0, colored_text)
		renderer.text(x / 2+13 + testx, y / 2 + 25, 255,255,255, pulsating, "-", 0, 'LIVE')
		renderer.text(x / 2 + n2_x - testting, y / 2 + ting + 11 , 255, 255, 255, 180, flag, 0, state)
	end

	if ui.get(vis.inds_selct) == "Modern" then
		local lp_vel = funcs:get_velocity(local_player)
		local e_pose_param = math.min(57, entity.get_prop(local_player, "m_flPoseParameter", 11)*120-60)
		local perc = math.abs( e_pose_param )/60
		local dys = math.floor( perc*43 )
		local body = math.min(57, entity.get_prop(local_player, "m_flPoseParameter", 11)*120-60)
		local is_def = ui.get(elements[0].aa_builder) and ui.get(elements[var.p_state].force_defens) and ui.get(elements[var.p_state].enable_state)
		local text
		if ui.get(elements[0].force_def) or is_def then 
			text = "DEFENSIVE"
		else
			text = "RAPID"
		end

		if ui.get(vis.enable_anim) and act or is_grenade then 
			self.center.x3 = lerp(self.center.x3, 13,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x4 = lerp(self.center.x4, 23,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x5 = lerp(self.center.x5, 10,globals.frametime() * ui.get(vis.anims_speed))
			self.center.xx = lerp(self.center.xx, 12,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x1 = lerp(self.center.x1, 24,globals.frametime() * ui.get(vis.anims_speed))
			if ui.get(elements[0].force_def) or is_def then
				self.center.x2 = lerp(self.center.x2, 21,globals.frametime() * ui.get(vis.anims_speed))
			else
				self.center.x2 = lerp(self.center.x2, 14,globals.frametime() * ui.get(vis.anims_speed))
			end
		else
			self.center.x2 = lerp(self.center.x2, 0,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x3 = lerp(self.center.x3, 0,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x4 = lerp(self.center.x4, 0,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x5 = lerp(self.center.x5, 0,globals.frametime() * ui.get(vis.anims_speed))
			self.center.xx = lerp(self.center.xx, 0,globals.frametime() * ui.get(vis.anims_speed))
			self.center.x1 = lerp(self.center.x1, 0,globals.frametime() * ui.get(vis.anims_speed))
		end

		if is_charged then
			red,ggre,b = 179, 255, 154
		else
			red,ggre,b = 255, 127, 96
		end
		self.center.bar = lerp(self.center.bar, dys, globals.frametime() *5)
		if var.p_state == 2 then
			renderer.rectangle(x/2-18+self.center.x4, y/2 + 26, lp_vel / 5.6, 2, 255,255,255,255)
			renderer.text(x/2 + lp_vel / 5.7 - 10+self.center.x4, y/2 + 26, 255,255,255,255, "-c", 0, helper:round(lp_vel))
			renderer.text(x/2+self.center.x5, y/2 + 33, 255,255,255, 255,"-c",0, helper:round(self.center.bar).." %")
		else
			renderer.rectangle(x/2-18+self.center.x4, y/2 + 26, self.center.bar, 2, 255,255,255,255)
			renderer.text(x/2+self.center.xx, y/2 + 33, 255,255,255, alpha,"-c",0, "LIVE")
		end

		if ui.get(reference.rage.dt[2]) and reference.rage.dt[1] then
			self.center.y2 = lerp(self.center.y2,0,globals.frametime() * 6)
			self.center.dt_alpha = lerp(self.center.dt_alpha,255,globals.frametime() * 6)
		else
			self.center.y2 = lerp(self.center.y2,8,globals.frametime() * 6)
			self.center.dt_alpha = lerp(self.center.dt_alpha,0,globals.frametime() * 6)
		end

		if ui.get(reference.rage.os[2]) and not ui.get(reference.rage.dt[2]) then
			self.center.y3 = lerp(self.center.y3,0,globals.frametime() * 6)
			self.center.hide_alpha = lerp(self.center.hide_alpha,255,globals.frametime() * 6)
		else
			self.center.y3 = lerp(self.center.y3,8,globals.frametime() * 6)
			self.center.hide_alpha = lerp(self.center.hide_alpha,0,globals.frametime() * 6)
		end

		if ui.get(elements[0].fs) and not freestanddisabled then
			renderer.text(x/2+3+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 179, 255, 154,255,"-c",0, "FS")
		else
			renderer.text(x/2+3+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 255,255,255,100,"-c",0, "FS")
		end

		if ui.get(reference.rage.forcebaim) then
			renderer.text(x/2-12+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 179, 255, 154,255,"-c",0, "BAIM")
		else
			renderer.text(x/2-12+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 255,255,255,100,"-c",0, "BAIM")
		end
		
		if ui.get(reference.rage.safepoint) then
			renderer.text(x/2+15+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 179, 255, 154,255,"-c",0, "SP")
		else
			renderer.text(x/2+15+self.center.x1, y/2 + 58-self.center.y3-self.center.y2, 255,255,255,100,"-c",0, "SP")
		end

		renderer.text(x/2 + self.center.x3, y/2 + 42 - self.center.y3, 255, 255, 255, self.center.hide_alpha, "c-", nil, "OS-AA")
		renderer.text(x/2 + self.center.x2, y/2 + 42 - self.center.y2, red,ggre,b, self.center.dt_alpha,"-c",0, text)
		renderer.text(x/2+self.center.x4, y/2 + 20, 255,255,255,255,"-c",0, colored_text)
	end
end

function render:aa_arrows()
	local x, y = client.screen_size()
	local localp = entity.get_local_player()
	local b_yaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60
	local c1,c2,c3,c4 = ui.get(vis.main_clr)

	if not entity.is_alive(entity.get_local_player()) then 
		return
	end

	if ui.get(vis.manaa_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		right_dir == true and c1 or 25, 
		right_dir == true and c2 or 25, 
		right_dir == true and c3 or 25, 
		right_dir == true and c4 or 160)
		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		left_dir == true and c1 or 25, 
		left_dir == true and c2 or 25, 
		left_dir == true and c3 or 25, 
		left_dir == true and c4 or 160)
		renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		b_yaw < -10 and c1 or 25,
		b_yaw < -10 and c2 or 25,
		b_yaw < -10 and c3 or 25,
		b_yaw < -10 and c4 or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		b_yaw > 10 and c1 or 25,
		b_yaw > 10 and c2 or 25,
		b_yaw > 10 and c3 or 25,
		b_yaw > 10 and c4 or 160)
	end
end

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_statess) do
		settings[tostring(value)] = {}
		for k, v in pairs(elements[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	clipboard.set(base64.encode(json.stringify(settings)))
	momentum_push:paint(3, "Anti-aim exported")
end

local export_btn = ui.new_button(tab, container, "export antiaim settings", export_config)

local function import_config()
	local cpilboard_get = clipboard.get()
	local clip_Decoded = base64.decode(cpilboard_get )
	local settings = json.parse(clip_Decoded )
	for key, value in pairs(var.player_statess) do
		for k, v in pairs(elements[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	momentum_push:paint(3, "Anti-aim imported")
end

local import_btn = ui.new_button(tab, container, "import antiaim settings", import_config)
function gui:config_menu()
	local aa_tab = ui.get(elements[0].lua_select) == 1
	if ui.get(elements[0].aa_builder) and aa_tab then
		ui.set_visible(export_btn, true)
		ui.set_visible(import_btn, true)
	else
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
	end
end

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

client.register_esp_flag("condition", 255, 255, 255, function(entity_index)
	if not helper:contains(misc.force_baim) or not helper:contains(misc.prefer_baim) then return end
	if plist.get(entity_index, "Override prefer body aim") == "On" then condition = "PREFER" elseif plist.get(entity_index, "Override prefer body aim") == "Force" then condition = "FORCE" else condition = "DEFAULT" end
	return true, condition
end)

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("sig1 not found")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0

function main:reduce(c)
	local cmd = get_user_cmd(g_inputclass , 0, c.command_number)
	if lastlocal + 0.9 > globals.curtime() then
		cmd.tick_count = cmd.tick_count + 8
	else
		cmd.tick_count = cmd.tick_count + 1
	end
end

function setup(c)
	main:on_setup_command(c)
	main:reduce(c)
	main:baim_if()
	main:antiaim(c)
	main:fl_adaptive(c)
	main:anti_knife()
    main:anti_aim_on_use(c)
	main:fs_diablers()
	main:freestand()
	main:manualaa()
end

function fire(c)
	if client.userid_to_entindex(c.userid) == entity.get_local_player() then
		lastlocal = globals.curtime()
		if ui.get(reference.rage.dt[1]) and ui.get(reference.rage.dt[2]) then
			lastdt = globals.curtime() + 1.1
		end
	end
end

function impact(e)
	funcs:brute_impact(e)
end

function down()
	gui:set_og_menu(true)
	ui.set(reference.antiaim.yaw[1], "180")
	ui.set(reference.antiaim.yaw[2], 0)
	ui.set(reference.antiaim.yaw_jitt[1], "Off")
	ui.set(reference.antiaim.yaw_jitt[2], 0)
	ui.set(reference.antiaim.body_yaw[1], "Off")
	ui.set(reference.antiaim.body_yaw[2], 0)
	ui.set(reference.fakelag.enablefl,true)
	ui.set_visible(reference.fakelag.enablefl,true)
	ui.set_visible(reference.fakelag.fl_amount,true)
	ui.set_visible(reference.fakelag.fl_limit,true)
	ui.set_visible(reference.fakelag.fl_var,true)
end

function died(e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		brute.reset()
		momentum_push:paint(3, "Restoring cache due to death")
	end
end

function fuckingshit()
    elements[0].last_press = 0
	lastlocal = 0
	lastdt = 0
	brute.reset()
	local me = entity.get_local_player()
	if not entity.is_alive(me) then return end
	momentum_push:paint(2, "Cache restored due to new round")
end

function logs_miss(e)
	logs:miss(e)
end

function logs_hit(e)
	logs:hit(e)	
end

function oldanim()
	rendering:old()
end

client.set_event_callback("paint", function()
	render:watermark()
	render:indicators()
	render:legfucker()
	render:aa_arrows()
end)

client.set_event_callback("paint_ui", function()
	gui:config_menu()
	gui:set_lua_menu()
	gui:set_og_menu()
end)
client.set_event_callback("setup_command", setup)
client.set_event_callback("run_command", function()
funcs:get_best_enemy()
end)

client.set_event_callback("weapon_fire", fire)
client.set_event_callback("bullet_impact", impact)
client.set_event_callback("shutdown", down)
client.set_event_callback("player_death", died)
client.set_event_callback("round_start", fuckingshit)
client.set_event_callback("client_disconnect", function()
	brute.reset()
end)
client.set_event_callback("game_newmap",function()
	brute.reset()
	momentum_push:paint(3, "Cache restored due to new map")
end)
client.set_event_callback("cs_game_disconnected", function()
	brute.reset()
end)
client.set_event_callback("aim_miss", logs_miss)
client.set_event_callback("aim_hit", logs_hit)
client.set_event_callback("pre_render", oldanim)
funcs:on_load()