-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local js = panorama.open()
local persona_api = js.MyPersonaAPI
local builddate = "2022/07/10"
local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFB6enable \aE5CEFDFFjupiter.lua")
local name2 = _G.obex_name == nil and 'rude' or _G.obex_name -- You can set your own name here in this example
local entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_get_all, entity_set_prop, entity_is_alive, entity_get_steam64, entity_get_classname, entity_get_player_resource, entity_get_esp_data, entity_is_dormant, entity_get_player_name, entity_get_game_rules, entity_get_origin, entity_hitbox_position, entity_get_player_weapon, entity_get_players, entity_get_prop = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.get_esp_data, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop

-- Returns build type
local build = _G.obex_build == nil and 'debug' or _G.obex_build


-- This example shows you how to easily manipulate the string to be only lower or uppercase
local upper_case = build:upper()


--clantags
local duration = 100


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
	p_states = {"standing", "running", "slowwalk", "in air", "duck", "air+crouching", "fakelag"},
	s_to_int = {["in air+duck"] = 6,["fakelag"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalk"] = 3, ["in air"] = 4, ["duck"] = 5},
	player_states = {"stand", "move", "slow", "air", "duck", "airc"},
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

local anim = { }

local hitler = {}

hitler.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "jupiter lua selects", "\aE5CEFDFFAnti-aim", "\aE5CEFDFFVisuals", "\aE5CEFDFFMisc"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim Presets", "Custom Jitter", "Aggressive" ),
	Manualx = ui.new_checkbox("AA", "Anti-aimbot angles", "Manual Anti-aim"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Yaw Right"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Yaw Left"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-aim builder"),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "selected state", "standing", "moving",  "duck", "in air", "in air+duck", "slowwalk"),
}

local function print_welcome(x)
	client.color_log(192, 187, 255, "jupiter \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "welcome to \0")
	client.color_log(192, 187, 255, "prazol.lua")
	--return client.color_log(200, 200, 200, " " .. x)
end

local function print_error(x)
	client.color_log(192, 187, 255, "prazol \0")
	client.color_log(155, 155, 155, "- \0")
	client.color_log(225, 225, 225, "error occured \0")
	client.color_log(155, 155, 155, "-> \0")
	return client.color_log(255, 150, 150, " " .. x)
end



--#region "visuals indicators whatever"
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "enable indicators")
local inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "indicators", {"-", "#1", "#2", "#3" })
local manaa_inds = ui.new_combobox("AA", "Anti-aimbot angles", "manual anti-aim arrows","-",  "teamskeet", "simple")
local debugbox_tgl = ui.new_combobox("AA", "Anti-aimbot angles", "debug info", "-", "modern", "simple")
local watermark_tgl = ui.new_checkbox("AA", "Anti-aimbot angles", "enable watermark")
local main_clr_5 = ui.new_label("AA", "Anti-aimbot angles", "        -[COLORS]-")
local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "|- customized color [1]")
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 204, 150, 120, 255)
local main_clr_l2 = ui.new_label("AA", "Anti-aimbot angles", "|- customized color [2]")
local main_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "main dfgf color", 255, 255, 255, 255)
local main_clr_l4 = ui.new_label("AA", "Anti-aimbot angles", "|- debug box color [1]")
local main_clr4 = ui.new_color_picker("AA", "Anti-aimbot angles", "main dscolor", 255, 255, 255, 255)
local main_clr_l3 = ui.new_label("AA", "Anti-aimbot angles", "|- debug box color [2]")
local main_clr3 = ui.new_color_picker("AA", "Anti-aimbot angles", "mains color", 255, 255, 255, 255)

local jupiterclantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Jupiter clantag")
local clantags = {"j", "ju", "jup", "jupi", "jupit", "jupite", "jupiter", "jupiter.", "jupiter.l", "jupiter.lu", "jupiter.lua" ,  "jupiter.lua" ,"jupiter.lu" , "jupiter.l" , "jupiter." , "jupiter", "jupite", "jupit", "jupi", "jup", "ju", "j", ""}
local logs = ui.new_checkbox("AA", "Anti-aimbot angles", "enable logs")
local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0
local menu_r, menu_g, menu_b, menu_a = 255,255,255,255
local android_notify=(function()local a={callback_registered=false,maximum_count=7,data2={}}function a:register_callback()if self.callback_registered then return end;client.set_event_callback('paint_ui',function()local b={client.screen_size()}local c={56,56,57}local d=5;local e=self.data2;for f=#e,1,-1 do self.data2[f].time=self.data2[f].time-globals.frametime()local g,h=255,0;local i=e[f]if i.time<0 then table.remove(self.data2,f)else local j=i.def_time-i.time;local j=j>1 and 1 or j;if i.time<0.5 or j<0.5 then h=(j<1 and j or i.time)/0.5;g=h*255;if h<0.2 then d=d+15*(1.0-h/0.2)end end;local k={renderer.measure_text(nil,i.draw)}local l={b[1]/2-k[1]/2+3,b[2]-b[2]/100*17.4+d}renderer.rectangle(l[1]- 6,l[2],k[1] + 12,24,25,25,25,166)renderer.rectangle(l[1]-6,l[2],k[1]+12,1, menu_r, menu_g, menu_b, menu_a)renderer.gradient(l[1]-7,l[2],1,25, menu_r, menu_g, menu_b, menu_a, menu_r, menu_g, menu_b, 0,false)renderer.gradient(l[1] +k[1] + 6,l[2],1,25, menu_r, menu_g, menu_b, menu_a, menu_r, menu_g, menu_b, 0,false)renderer.text(l[1]+k[1]/2,l[2]+12,255,255,255,g,'c',nil,i.draw)d=d-50 end end;self.callback_registered=true end)end;function a:paint(m,n)local o=tonumber(m)+1;for f=self.maximum_count,2,-1 do self.data2[f]=self.data2[f-1]end;self.data2[1]={time=o,def_time=o,draw=n}self:register_callback()end;return a end)()



client.set_event_callback("run_command", function()
	local cur = math.floor(globals.tickcount() / duration * 4) % #clantags
	local clantag = clantags[cur+1]
  
	if ui.get(jupiterclantag) then
		client.set_clan_tag(clantag)
	end
  
  end)



for i=1, 7 do
	aa_init[i] = {
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 yaw jitter\n" .. var.p_states[i], { "off", "offset", "center", "random" }),
		yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 yaw jitter add\n" .. var.p_states[i], -180, 180, 0),
		bodyyaw = ui.new_combobox("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 body options\n" .. var.p_states[i], { "off", "opposite", "jitter", "static"}),
		side_body = ui.new_combobox("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 body-side\n" .. var.p_states[i], { "left", "right" }),
		aa_static = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 body left\n", -180, 180, 0),
		aa_static_2 = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 body right\n", -180, 180, 0),
		yawaddr = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 right yaw\n", -180, 180, 0),
		yawaddl = ui.new_slider("AA", "Anti-aimbot angles", "{"..var.p_states[i].."} ->\aFFFFFFC9 left yaw\n", -180, 180, 0),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 left fake limit \n" .. var.p_states[i], 0, 60, 60,true,"°"),
		fakeyawlimitr = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 right fake limit\n" .. var.p_states[i], 0, 60, 60,true,"°"),
		roll = ui.new_slider("AA", "Anti-aimbot angles","{"..var.p_states[i].."} ->\aFFFFFFC9 roll \n".. var.p_states[i], -50, 50, 0, true, "°"),
		avoid_overlap =  ui.new_checkbox("AA", "Anti-aimbot angles", "{"..var.p_states[i].."} -> avoid overlap"),
		anti_bf =  ui.new_checkbox("AA", "Anti-aimbot angles", "{"..var.p_states[i].."} ->\aFFFFFFC9 anti bruteforce"),
		
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
	ui.set_visible(ref.enabled, state)
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
hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }

client.set_event_callback("aim_hit", function(e)
    
    local enemies = entity.get_players(true)
    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local name = string.lower(entity.get_player_name(e.target))
    local health = entity.get_prop(e.target, 'm_iHealth')
    local mr,mg,mb,ma = ui.get(main_clr)
    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
    --[[if health == 0 and ui.get(killsay) then
        client.exec(killsays[math.random(1,5)])
    end
    if not ui.get(enablelogger) then return end]]

    if ui.get(logs) then
    	android_notify:paint(3, string.format(' Hit '..name.."'s "..hgroup..' for '..e.damage..'hp, remaining: '..health..'hp [dsy: '..angle..']'))
    end

end)
player_memory = {}
misses = 0
client.set_event_callback("aim_miss", function(e)
    
    local enemies = entity.get_players(true)
    local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local name = string.lower(entity.get_player_name(e.target))
    local health = entity.get_prop(e.target, 'm_iHealth')
    local menu_r, menu_b, menu_g, menu_a = ui.get(main_clr)
    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
	
	if ui.get(logs) then
        android_notify:paint(3, string.format(' Missed '..name.."'s "..hgroup..' due to '..e.reason..' [dsy: '..angle..']'))
    end


    if e.reason ~= "?" then return end
    if not player_memory[e.target] then
        table.insert(player_memory, e.target, {
            misses = misses + 1
        })
    else
        if player_memory[e.target].misses == nil or player_memory[e.target].misses == true or player_memory[e.target].misses == false then player_memory[e.target].misses = 0 end
        player_memory[e.target].misses = player_memory[e.target].misses + 1
    end
end)


_G.ephemeral_push=(function()
	_G.ephemeral_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.ephemeral_notify_cache;
			for g=#f,1,-1 do
				_G.ephemeral_notify_cache[g].time=_G.ephemeral_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.ephemeral_notify_cache,g)
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
			local m={math.floor(renderer.measure_text(nil,""..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]}
			local c1,c2,c3,c4 = ui.get(main_clr)
			local x, y = client.screen_size()



			--	renderer.rectangle(p[1]-1,p[2]-20,m[1]+2,22,18, 7, 8,h>255 and 255 or h)
			--renderer.circle(p[1]-1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 180, 0.5)
			--renderer.circle(p[1]+m[1]+1,p[2]-8, 18, 7, 8,h>255 and 255 or h, 12, 0, 0.5)
			--renderer.circle_outline(p[1]-1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 90, lerp_circ, 2)
			--renderer.circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, -90, lerp_circ, 2)
			--renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			--renderer.line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
			--renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,c1,c2,c3,h>255 and 255 or h)
			--renderer.line(p[1]-1,p[2]-21,p[1]-149+m[1],p[2]-21,c1,c2,c3,h>255 and 255 or h)
			--renderer.text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,h,"c",nil,"[xd]  ")
			--renderer.text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,h,"c",nil,j.draw)e=e-33
		end
	end;
	self.callback_registered=true end)
end;



client.color_log(255, 255, 255, "----------------------------------------------------------")
client.color_log(204, 150, 120,  "                   Welcome Back " .. name2 .. "!            ")
client.color_log(204, 150, 120, "                   Current build: " .. build .. "                  ")
client.color_log(204, 150, 120,  "                   Build Date: " .. builddate .."            ")
client.color_log(255, 255, 255, "----------------------------------------------------------")

function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.ephemeral_notify_cache[g]=_G.ephemeral_notify_cache[g-1]
	end;
	_G.ephemeral_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()


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
	local is_aa = ui.get(aa_init[0].lua_select) == "\aE5CEFDFFAnti-aim"
	local is_vis = ui.get(aa_init[0].lua_select) == "\aE5CEFDFFVisuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "\aE5CEFDFFMisc"
	local is_enabled = ui.get(lua_enable)
	local legs_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
	local leg_movement = ui.reference("AA", "Other", "Leg movement")
	

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		set_og_menu(false)
		ui.set(leg_movement, legs_types[math.random(1, 3)])
	else
		ui.set_visible(aa_init[0].lua_select, false)
		set_og_menu(true)
	end

	if is_misc and is_enabled then
		ui.set_visible(jupiterclantag, true)
		ui.set_visible(logs, true)
		
	else
		ui.set_visible(jupiterclantag, false)
		ui.set_visible(logs, false)
	end


	if ui.get(aa_init[0].presets) == "Aggressive" or ui.get(aa_init[0].presets) == "Custom Jitter" or ui.get(aa_init[0].aa_builder) and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].Manualx, true)
		ui.set_visible(aa_init[0].fs, true)
		
	else
		ui.set_visible(aa_init[0].Manualx, false)
		ui.set_visible(aa_init[0].fs, false)
	end


	if ui.get(aa_init[0].Manualx) and is_aa then
		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)		
	else
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)		
	end

	if is_vis and is_enabled then
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(main_clr_5, true)
		ui.set_visible(main_clr2, true)
		ui.set_visible(main_clr_l2, true)
		ui.set_visible(main_clr3, true)
		ui.set_visible(main_clr_l3, true)
		ui.set_visible(main_clr4, true)
		ui.set_visible(main_clr_l4, true)
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(watermark_tgl, true)
		ui.set_visible(debugbox_tgl, true)
		ui.set_visible(manaa_inds, true)
	else
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(main_clr_5, false)
		ui.set_visible(main_clr2, false)
		ui.set_visible(main_clr_l2, false)
		ui.set_visible(main_clr3, false)
		ui.set_visible(main_clr_l3, false)
		ui.set_visible(main_clr4, false)
		ui.set_visible(main_clr_l4, false)
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(watermark_tgl, false)
		ui.set_visible(debugbox_tgl, false)
		ui.set_visible(manaa_inds, false)
	end

	if ui.get(crosshair_inds) and is_vis and is_enabled then
		ui.set_visible(inds_selct, true)
		ui.set_visible(manaa_inds, true)
		ui.set_visible(debugbox_tgl, true)
	else
		ui.set_visible(inds_selct, false)
		ui.set_visible(manaa_inds, false)
		ui.set_visible(debugbox_tgl, false)
	end


	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].presets, true)
	else
		ui.set_visible(aa_init[0].presets, false)
		ui.set_visible(aa_init[0].aa_builder, false)
	end
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[0].aa_builder) then
				ui.set_visible(aa_init[i].yawaddl,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawaddr,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].yawjitteradd,var.active_i == i and ui.get(aa_init[var.active_i].yawjitter) ~= "off" and is_aa)

				ui.set_visible(aa_init[i].side_body,var.active_i == i and is_aa and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite")
				ui.set_visible(aa_init[i].bodyyaw, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].anti_bf, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aa_static, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "left" and is_aa)
				ui.set_visible(aa_init[i].aa_static_2, var.active_i == i and ui.get(aa_init[i].bodyyaw) ~= "off" and ui.get(aa_init[i].bodyyaw) ~= "opposite" and ui.get(aa_init[i].side_body) == "right" and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitr, var.active_i == i and is_aa)
				

				ui.set_visible(aa_init[i].roll, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].avoid_overlap, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].yawaddl,false)
				ui.set_visible(aa_init[i].yawaddr,false)
				ui.set_visible(aa_init[i].yawjitter,false)
				ui.set_visible(aa_init[i].yawjitteradd,false)

				ui.set_visible(aa_init[i].anti_bf, false)
	
				ui.set_visible(aa_init[i].side_body,false)
				ui.set_visible(aa_init[i].bodyyaw,false)
	
				ui.set_visible(aa_init[i].aa_static,false)
				ui.set_visible(aa_init[i].aa_static_2,false)
	
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitr,false)
				ui.set_visible(aa_init[i].roll,false)
				ui.set_visible(aa_init[i].avoid_overlap,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].yawaddl,false)
			ui.set_visible(aa_init[i].yawaddr,false)
			ui.set_visible(aa_init[i].yawjitter,false)
			ui.set_visible(aa_init[i].yawjitteradd,false)

			ui.set_visible(aa_init[i].side_body,false)
			ui.set_visible(aa_init[i].bodyyaw,false)

			ui.set_visible(aa_init[i].anti_bf, false)

			ui.set_visible(aa_init[i].aa_static,false)
			ui.set_visible(aa_init[i].aa_static_2,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitr,false)
			ui.set_visible(aa_init[i].roll,false)
			ui.set_visible(aa_init[i].avoid_overlap,false)
		end
	end
end

misc = {}





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
		if is_enabled then
			brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
		else
			brute.best_angle = 1
		end
	elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
		if is_enabled then
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
	
	if c.in_duck == 1 and on_ground then
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
	if ui.get(aa_init[0].presets) == "Aggressive" or ui.get(aa_init[0].presets) == "Custom Jitter" or ui.get(aa_init[0].aa_builder) then
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



client.set_event_callback("pre_render", function ()

	--

end)



local swap = 1

client.set_event_callback("setup_command", function(c)
	local tickcount = globals.tickcount() % 14
	local me = entity.get_local_player()
	if tickcount%2 == 0 then
		swap = swap *-1
	end

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

	if  ui.get(aa_init[0].presets) == "Aggressive" or ui.get(aa_init[0].presets) == "Custom Jitter" or ui.get(aa_init[0].aa_builder) then
		if is_os and not is_dt and not is_fd then
			ui.set(ref.fakelag[1], 3)
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
			end
		elseif aa.manaa == 1 then
			if ui.get(aa_init[0].manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_left) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 2 then
			if ui.get(aa_init[0].manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_init[0].manual_right) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 3 then
			
			if ui.get(aa_init[0].manual_left) then
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
		if ui.get(aa_init[0].aa_builder) then
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
			
			if ui.get(aa_init[0].presets) == "Aggressive" then
					if var.p_state == 1 then -- standing
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 67)
						ui.set(ref.bodyyaw[1], "jitter")
						ui.set(ref.bodyyaw[2], 0)
						ui.set(ref.yawbase, "At targets")
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and  -33 or -33))
						end
						ui.set(ref.fakeyawlimit, 35)
					elseif var.p_state == 2 then --run
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 69)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -40 or -40))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 3 then --slow
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 69)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -40 or -40))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 4 then --air
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 69)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -40 or -40))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 5 then -- air duck
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 69)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -40 or -40))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 6 then --duck
						ui.set(ref.yawjitter[1], "offset")
						ui.set(ref.yawjitter[2], 69)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -40 or -40))
						end
						ui.set(ref.fakeyawlimit, 59)				
					end
			elseif ui.get(aa_init[0].presets) == "Custom Jitter" then
					if var.p_state == 1 then -- standing
						ui.set(ref.yawjitter[1], "off")
						ui.set(ref.yawjitter[2], 0)
						ui.set(ref.bodyyaw[1], "static")
						ui.set(ref.bodyyaw[2], 180)
						ui.set(ref.yawbase, "At targets")
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and  0 or 0))
						end

					
						if swap>0 then
							ui.set(ref.fakeyawlimit, 42)
						else
							ui.set(ref.fakeyawlimit, 21)
						end
					elseif var.p_state == 2 then --run
						ui.set(ref.yawjitter[1], "center")
						ui.set(ref.yawjitter[2], 72)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -10 or 5))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 3 then --slow
						ui.set(ref.yawjitter[1], "off")
						ui.set(ref.yawjitter[2], 0)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and 6 or 6))
						end
						if swap>0 then
							ui.set(ref.fakeyawlimit, 24)
						else
							ui.set(ref.fakeyawlimit, 45)
						end
					elseif var.p_state == 4 then --air
						ui.set(ref.yawjitter[1], "center")
						ui.set(ref.yawjitter[2], 48)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -11 or 23))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 5 then -- air duck
						ui.set(ref.yawjitter[1], "center")
						ui.set(ref.yawjitter[2], 48)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -11 or 23))
						end
						ui.set(ref.fakeyawlimit, 59)
					elseif var.p_state == 6 then --duck
						ui.set(ref.yawjitter[1], "center")
						ui.set(ref.yawjitter[2], 48)
						ui.set(ref.bodyyaw[1], "Jitter")
						ui.set(ref.bodyyaw[2], 0)
						if c.chokedcommands ~= 0 then
						else
							ui.set(ref.yaw[2],(side == -1 and -11 or 23))
						end
						ui.set(ref.fakeyawlimit, 59)				
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
		if ui.get(aa_init[0].presets) == "#4" or ui.get(aa_init[0].presets) == "#3" or ui.get(aa_init[0].presets) == "Aggressive" or ui.get(aa_init[0].presets) == "Custom Jitter" or ui.get(aa_init[0].aa_builder) then
			--android_notify:paint(3, string.format('Switched Side / Anti-bruteforce'))
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

	if not entity.is_alive(me) then return end

end

local OldChoke = 0
local toDraw4 = 0
local toDraw3 = 0
local toDraw2 = 0
local toDraw1 = 0
local toDraw0 = 0

local function setup_command(cmd)

	if cmd.chokedcommands < OldChoke then --sent
		toDraw0 = toDraw1
		toDraw1 = toDraw2
		toDraw2 = toDraw3
		toDraw3 = toDraw4
		toDraw4 = OldChoke
	end
	
	OldChoke = cmd.chokedcommands

end

-- localize often used API variables to improve performance. It's usually fine to not do this, but lua then has to look them up as globals every time.
local client_latency, client_screen_size, client_system_time, globals_tickinterval, math_floor, renderer_measure_text, renderer_rectangle, renderer_text, string_format = client.latency, client.screen_size, client.system_time, globals.tickinterval, math.floor, renderer.measure_text, renderer.rectangle, renderer.text, string.format
local function watermark()
	
		-- fetch dynamic info. latency is in seconds so we convert it to ms and round it. tickrate is calculated with 1 / tickinterval
		local screen_width, screen_height = client_screen_size()
		local latency = math_floor(client_latency()*1000+0.5)
		local tickrate = 1/globals_tickinterval()
		local hours, minutes, seconds = client_system_time()
		local mr,mg,mb,ma = ui.get(main_clr)
		local mr2,mg2,mb2,ma2 = ui.get(main_clr2)
		local mr3,mg3,mb3,ma3 = ui.get(main_clr3)
		local mr4,mg4,mb4,ma4 = ui.get(main_clr4)
		local is_charged = antiaim_funcs.get_double_tap()
		local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
		local is_fd = ui.get(ref.fakeduck)
		local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

		local x, y = client.screen_size()

		-- create text
		local text = " jupiter ".. string_format("[%s]", build) .. " |".. string_format(" %s", name2) .. " | delay: " ..  string_format("%dms", latency) .. " | "..  string_format("%dtick", tickrate) .. " | ".. string_format("%02d:%02d:%02d", hours, minutes, seconds)
	
		-- modify these to change how the text appears. margin is the distance from the top right corner, padding is the size the background rectangle is larger than the text
		local margin, padding, flags = 18, 4, nil
	
		-- uncomment this for a "small and capital" style
		-- flags, text = "-", (text:upper():gsub(" ", "   "))
	
		-- measure text size to properly offset the text from the top right corner
		local text_width, text_height = renderer_measure_text(flags, text)
	
		-- draw background and text


	local fun1 = 52
	local fun2 = 87
	local realtime = globals.realtime() % 3

	local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
	local desync_strength = math.floor(math.min(58, math.abs(entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11)*120-60)))


	if ui.get(debugbox_tgl) == "modern"  and ui.get(crosshair_inds) then


		local whatexploit = 0
		if is_dt then
			whatexploit = doubletap
		elseif is_os then
			whatexploit = onshot 
		end
		renderer_rectangle(	 13, y/2 - 54, 135, 19, mr4,mg4,mb4,100)
		renderer_rectangle(	 13, y/2 - 55, 135, 1,  255,255,255,255)
		renderer_rectangle(	 13, y/2 - 14, 135, 1,  255,255,255,255)


		renderer_rectangle(	 20, y/2 - 39, 121, 1, 255,255,255,255)
		renderer.gradient(	 13, y/2 - 35, 135 , 21, mr4,mg4,mb4,100, mr3,mg3,mb3,100, false)
		renderer.gradient(	 13, y/2 - 54, 1 , 40, 255,255,255,255, 255,255,255,255, false)
		renderer.gradient(	 147, y/2 - 55, 1 , 42, 255,255,255,255, 255,255,255,255, false)
		renderer_text( fun1 + 14, y/ 2 - 47,255,255,255,255, "c", 0,"jupiter")
		renderer_text( fun2 + 13, y/ 2 - 47,255,255,255,alpha, "c", 0,"beta")

		-- ~~~~~~~~~~~[FAKELAG]~~~~~~~~
		renderer_text( 135, y/ 2 - 32,255,255,255,255, "c-", 0,"", toDraw4)
		renderer_text( 32, y/ 2 - 32,255,255,255,255, "c", 0,"chk:")
		renderer_rectangle(	 42 , y/2 - 34, 87, 6, 44,44,44,188)
		renderer.gradient(	 43 , y/2 - 33, toDraw4* 6.1, 4, mr4,mg4,mb4,255, mr3,mg3,mb3,255, true)
		-- ~~~~~~~~~~~[FAKELAG]~~~~~~~~

		-- ~~~~~~~~~~~[DSY]~~~~~~~~
		renderer_text( 135 , y/ 2 - 22,255,255,255,255, "c-", 0,"", desync_strength)
		renderer_text( 32 , y/ 2 - 22,255,255,255,255, "c", 0,"dsy:")
		renderer_rectangle(	42, y/2 - 24, 87, 6, 44,44,44,188)
		renderer.gradient( 43 , y/2 - 23, desync_strength * 1.47, 4, mr4,mg4,mb4,255, mr3,mg3,mb3,255, true)
		-- ~~~~~~~~~~~[DSY]~~~~~~~~
	elseif ui.get(debugbox_tgl) == "simple" and ui.get(crosshair_inds)  then
		renderer_text( 12, y/ 2 - 65,255,255,255,255, "", 0,"- jupiter \aFFFFFFFFa\aD7D7D7FFn\aB9B9B9FFt\aA1A1A1FFi\a828282FF-\a717171FFa\a5A5A5AFFi\a343434FFm\aFFFFFFFF technology ["..build.."]")
		renderer_text( 12, y/ 2 - 55,255,255,255,255, "", 0,"  > fakelag: ", toDraw4,"ticks choked")
		renderer_text( 12, y/ 2 - 45,255,255,255,255, "", 0,"  > desync: ", desync_strength,"°")
		if is_dt then
			if is_charged then
				renderer_text( 12, y/ 2 - 35,255,255,255,255, "", 0,"  > exploit: dubletap, charged" )
			else
				renderer_text( 12, y/ 2 - 35,255,255,255,255, "", 0,"  > exploit: dubletap, \a8E8E8EFFcharging" )
			end
		elseif is_os then
			renderer_text( 12, y/ 2 - 35,255,255,255,255, "", 0,"  > exploit: onshot anti-aim" )
		else
			renderer_text( 12, y/ 2 - 35,255,255,255,255, "", 0,"  > exploit: nil" )
		end

	end

	if ui.get(watermark_tgl) then
		renderer.gradient(screen_width-text_width-margin-padding + text_width+padding*2 + 7, margin-padding - 6, 1      , text_height+padding*2  , mr2,mg2,mb2, 255, mr2,mg2,mb2, 0, false)
		renderer_rectangle(screen_width-text_width-margin-padding + 7, margin-padding - 5, text_width+padding*2, text_height+padding*2, 33, 33, 33, ma)
		renderer_rectangle(screen_width-text_width-margin-padding + 2, margin-padding +2, 5, 13, 33, 33, 33, ma)
		renderer.triangle(screen_width-text_width-margin-padding + 7, margin-padding - 5, screen_width-text_width-margin-padding +2, margin-padding + 2, screen_width-text_width-margin-padding + 7, margin-padding + 2, 33, 33, 33, ma)
		renderer.line(screen_width-text_width-margin-padding + 7, margin-padding - 5, screen_width-text_width-margin-padding +1, margin-padding + 2, mr2,mg2,mb2, 255)
		renderer.gradient(screen_width-text_width-margin-padding + 1, margin-padding , 1     , text_height+padding*2 - 5 , mr2,mg2,mb2, 255, mr2,mg2,mb2, 21, false)

		renderer_text(screen_width-text_width-margin + 4, margin - 5, 235, 235, 235, 255, flags, 0, text)
		
		renderer.gradient(screen_width-text_width-margin-padding + 7, margin-padding - 6, text_width+padding*2     , text_height+padding*2 - 19, mr2,mg2,mb2, 255, mr2,mg2,mb2, 255, true)
		
	else
		--renderer.text(x+160, y + 1, 255, 255, 255, 255, '', 0, "\aFFCCE6FFprazol\aD6BDFDFF~\aC9C2F9FFlua")
	end
end



client.set_event_callback('setup_command', setup_command)


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
local testx2 = 0	
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

	if is_charged then dr,dg,db,da=233, 233, 233,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,33,33,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
	--sine_in
	if is_charged then dr2,dg2,db2,da=233, 233, 233,255 elseif is_os then dr2,dg2,db2,da=255,255,255,255 else dr2,dg2,db2,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end

	if is_charged then dr3,dg3,db3,da3=mr, mg, mb, 255 elseif is_os then dr3,dg3,db3,da3=mr, mg, mb,0 else dr3,dg3,db3,da3=mr, mg, mb,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end

	
	value = value + globals.frametime() * 9

	local _, y2 = client.screen_size()

	local state = "RUNNING"

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
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "IN AIR + D"
		elseif var.p_state == 4 then
			state = "IN AIR"
		elseif var.p_state == 3 then
			state = "SLOWWALKING"
		elseif var.p_state == 1 then
			state = "STANDING"
		elseif var.p_state == 2 then
			state = "RUNNING"
		end
	end



	local state3 = "RUNNING"

	--states [for searching]
	if ui.get(aa_init[0].aa_stc_tillhit) then
		if brute.can_hit == 0 then
			state = "INDEXED"
		end
	else
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state3 = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state3 = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 and ui.get(aa_init[0].aa_builder) then
			state3 = "FAKELAG"
		elseif var.p_state == 5 then
			state3 = "DUCK"
		elseif var.p_state == 6 then
			state3 = "AIR[D]"
		elseif var.p_state == 4 then
			state3 = "AIR"
		elseif var.p_state == 3 then
			state3 = "SLOW"
		elseif var.p_state == 1 then
			state3 = "STAND"
		elseif var.p_state == 2 then
			state3 = "RUN"
		end
	end





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
	local funny = 0
	local testfun = 0
	--animation shit

	if is_dt or is_os then
		n4_x = hitler.lerp(n4_x, 8, globals.frametime() * 5)
	else
		n4_x = hitler.lerp(n4_x, -1, globals.frametime() * 5)
	end




	if act then
		flag = "-"
		ting = 23
		testting = 11
		funny = 3
		testfun = 15

		testx = hitler.lerp(testx, 30, globals.frametime() * 3)
		testx2 = hitler.lerp(testx2, 20, globals.frametime() * 3)

		n2_x = hitler.lerp(n2_x, 11, globals.frametime() * 3)

		n3_x = hitler.lerp(n3_x, 5, globals.frametime() * 3)

	else
		testx = hitler.lerp(testx, 0, globals.frametime() * 3)
		testx2 = hitler.lerp(testx2, 0, globals.frametime() * 3)

		n2_x = hitler.lerp(n2_x, 0, globals.frametime() * 3)

		n3_x = hitler.lerp(n3_x, 0, globals.frametime() * 3)

		flag = "c-"
		ting = 23
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if ui.get(inds_selct) == "#1" and ui.get(crosshair_inds) then	
		local wx, wy = client.screen_size()
	
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
	

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		--renderer.text(x / 2 + testx - funny, y / 2 + 34, mr,mg,mb, 255, "c", 0, 'JUPITER')

		renderer.gradient(x / 2  - 40 + n2_x + testx2 + testfun, y / 2 + 39, 83, 1, mr2,mg2,mb2, 255, mr2,mg2,mb2, 255, true)
		renderer.gradient(x / 2  - 40 + n2_x + testx2 + testfun, y / 2 + 39, 83, 10, mr2,mg2,mb2, 55, mr2,mg2,mb2, 0, false)

		renderer.gradient(x / 2  + 42 + n2_x + testx2 + testfun, y / 2 + 39, 1, 10, mr2,mg2,mb2, 255, mr2,mg2,mb2, 0, false)
		renderer.gradient(x / 2  - 40 + n2_x + testx2 + testfun, y / 2 + 39, 1, 10, mr2,mg2,mb2, 255, mr2,mg2,mb2, 0, false)
		local text = " JUPITER ".. string_format("%s", upper_case)
		renderer.text(x / 2 + n2_x + testx2 + testfun, y / 2 + 33,mr, mg, mb, 255, "cb", 0, text)
		renderer.text(x / 2 + n2_x + testx2 + testfun, y / 2 + 45 , 223, 223, 223, 180, "-c", 0,  state)

		local margin, padding, flags = 18, 4, nil
		local text_width, text_height = renderer_measure_text(flags, text)
		local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
		local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
		local CHECK = entity.get_prop(weapon, "m_flNextPrimaryAttack")
					
		if CHECK == nil then return end
					
		local next_primary_attack = CHECK + 0.5
					
		if next_primary_attack - globals.curtime() < 0 and next_attack - globals.curtime() < 0 then
			lima = 1.4
		else
			lima = next_primary_attack - globals.curtime()
		end
					
		local CHECKCHECK = math.abs((lima * 10/6) - 1)
			if is_dt then
				renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + 10, dr, dg, db, os_a, "c-", 0, " ")
			else
				renderer.text(x / 2  + n2_x + testx2 + testfun, y2 / 2 + 53, dr, dg, db, os_a, "c-", 0, "ONSHOT")
			end
			renderer.text(x / 2 -3 + n2_x + testx2 + testfun, y2 / 2+ 53, dr, dg, db, dt_a, "c-", 0, "DT")
			if is_dt then
				renderer.circle_outline(x/2 + 11 -3 + n2_x + testx2 + testfun, y2 / 2 + 53 , 150, 150, 150, CHECKCHECK == 1 and 1 or 255, 2.9, 270, 5, 1)
				renderer.circle_outline(x/2 + 11 -3 + n2_x + testx2 + testfun, y2 / 2 + 53 ,  dr3, dg3, db3, CHECKCHECK == 1 and 1 or 255, 2.9, 270, CHECKCHECK, 1)
			end
			--renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 14, 255, 255, 255, fs_a, "c-", 0, "FS")



		--+ testx + testting
	end

	if ui.get(inds_selct) == "#2" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			--renderer.text(x / 2 - 0.5  , y2 / 2 + 47, dr, dg, db, os_a, "c-", 0, "OS ")
		end
		


		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
		local entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_get_all, entity_set_prop, entity_is_alive, entity_get_steam64, entity_get_classname, entity_get_player_resource, entity_get_esp_data, entity_is_dormant, entity_get_player_name, entity_get_game_rules, entity_get_origin, entity_hitbox_position, entity_get_player_weapon, entity_get_players, entity_get_prop = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.get_esp_data, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop
		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		local desync_strength = math.floor(math.min(58, math.abs(entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11)*120-60)))

		--renderer.text(x / 2 + 1 + testx + testting, y / 2 + 47, mr,mg,mb, 255, "cb", 0, 'jupiter.tech')
		renderer.text(x / 2 + 1 + testx + testting, y / 2 + 47, mr,mg,mb, 255, "c-", 0, 'JUPITER   TECH')
		renderer.text(x / 2 - 37 + n2_x + testx2 + testting, y / 2  + 26 , 223, 223, 223, 180, "-", 0,  state3)
		renderer.text(x / 2  + 28 + n2_x + testx2 + testting , y / 2 + 26,223, 223, 223, 180, "-", 0, string.format(" %s", desync_strength))
		renderer.rectangle(x / 2 - 36 + testx + testting, y / 2 + 36 , 75, 5 , 25,25,25,255	)
		renderer.gradient(x / 2  - 35 + testx + testting, y / 2 + 37, desync_strength* 1.28, 3, mr2,mg2,mb2, 255, mr2,mg2,mb2, 0, true)

		renderer.text(x / 2  + testx + testting + n2_x  / 5 , y2 / 2 + 55, dr2,dg2,db2, dt_a, "-c", 0, "RAPID")
		if is_os and not is_dt then
			renderer.text(x / 2  + testx + testting + n2_x  / 5 , y2 / 2 + 55, dr, dg, db, os_a, "c-", 0, "ONSHOT")
		end
		if is_dt or is_os then
			renderer.text(x / 2  + testx + testting + n2_x / 5 , y2 / 2 + 63, 255, 255, 255, fs_a, "c-", 0, "FS")
		else 
			renderer.text(x / 2  + testx + testting + n2_x / 5 , y2 / 2 + 55, 255, 255, 255, fs_a, "c-", 0, "FS")
			
		end


		
		

		--renderer.text(x / 2+1 , y / 2 + 25, 255,255,255, alpha, "", 0, 'ALPHA')
		--renderer.text(x / 2 , y / 2 + ting + 11 , 255, 255, 255, 180, flag, 0, state)
		--[[renderer.text(x / 2-10, y / 2 + 34, br, bg, bb, ba, "-", 0, "BAIM")
		renderer.text(x / 2-21, y / 2 + 34, sr, sg, sb, sa, "-", 0, "SP")
		renderer.text(x / 2+10, y / 2 + 34, fr, fg, fb, fa, "-", 0, "FS")]]
	end


	if ui.get(inds_selct) == "#3" and ui.get(crosshair_inds) then
		--[[if is_dt then
			renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + 10, dr, dg, db, os_a, "c-", 0, " ")
		else
			renderer.text(x / 2  + n3_x, y2 / 2 + 51, dr, dg, db, os_a, "c-", 0, "OS ")
		end
		renderer.text(x / 2  + n3_x, y2 / 2+ 51, dr, dg, db, dt_a, "c-", 0, "DT")]]

		--renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 14, 255, 255, 255, fs_a, "c-", 0, "FS")

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)
				local entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_get_all, entity_set_prop, entity_is_alive, entity_get_steam64, entity_get_classname, entity_get_player_resource, entity_get_esp_data, entity_is_dormant, entity_get_player_name, entity_get_game_rules, entity_get_origin, entity_hitbox_position, entity_get_player_weapon, entity_get_players, entity_get_prop = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.get_esp_data, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop
		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		local desync_strength = math.floor(math.min(58, math.abs(entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11)*120-60)))

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)
		--renderer.text(x / 2 + testx - funny, y / 2 + 34, mr,mg,mb, 255, "c", 0, 'JUPITER')
		renderer.text(x / 2 + n2_x + testx2 + testfun, y / 2 + 34,mr, mg, mb, 255, "-c", 0, string.format("JUPITER  %s",upper_case, desync_strength))
		renderer.text(x / 2 + n2_x + testx2 + testfun, y / 2 + 43 , 223, 223, 223, 180, "-c", 0,  state)
	end
	
	local localp = entity.get_local_player()

	local bodyyaw = entity.get_prop(localp, "m_flPoseParameter", 11) * 120 - 60


	
	if ui.get(manaa_inds) == "teamskeet" and ui.get(crosshair_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2 - testx, x / 2 + 42  , y / 2 - 7 - testx, x / 2 + 42, y / 2 + 11 - testx, 
		aa.manaa == 2 and mr or 25, 
		aa.manaa == 2 and mg or 25, 
		aa.manaa == 2 and mb or 25, 
		aa.manaa == 2 and 255 or 160)

		renderer.triangle(x / 2 - 55, y / 2 + 2 - testx, x / 2 - 42, y / 2 - 7 - testx, x / 2 - 42, y / 2 + 11 - testx, 
		aa.manaa == 1 and mr or 25, 
		aa.manaa == 1 and mg or 25, 
		aa.manaa == 1 and mb or 25, 
		aa.manaa == 1 and 255 or 160)
	
		renderer.rectangle(x / 2 + 38, y / 2 - 7 - testx, 2, 18, 
		bodyyaw < -10 and mr or 25,
		bodyyaw < -10 and mg or 25,
		bodyyaw < -10 and mb or 25,
		bodyyaw < -10 and 255 or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7  - testx, 2, 18,			
		bodyyaw > 10 and mr or 25,
		bodyyaw > 10 and mg or 25,
		bodyyaw > 10 and mb or 25,
		bodyyaw > 10 and 255 or 160)
	elseif ui.get(manaa_inds) == "simple" and ui.get(crosshair_inds) then
		renderer.text(x/2 + 60, y / 2 , 		
		aa.manaa == 2 and mr or 255, 
		aa.manaa == 2 and mg or 255, 
		aa.manaa == 2 and mb or 255, 
		aa.manaa == 2 and 255 or 100,
		"+c", 0, ">")


		renderer.text(x/2 - 60, y / 2 , 		
		aa.manaa == 1 and mr or 255, 
		aa.manaa == 1 and mg or 255, 
		aa.manaa == 1 and mb or 255, 
		aa.manaa == 1 and 255 or 100,
		 "+c", 0, "<")


		--renderer.text(x/2 , y / 2 + 55, 255,255,255,100, "+c", 0, "v")



	end
	-- ⯇ ⯈ ⯅ ⯆
	

	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)
end

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(json.stringify(settings))

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
			--
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
		ephemeral_push:paint(5, "Reset data due to new round")
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		--ephemeral_push:paint(5, "Reset data due to new map")
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
--ui.new_label("AA", "Anti-aimbot angles", "              -[INFO]-")
ui.new_label("AA", "Anti-aimbot angles", "current build: ".. build.. "")
--ui.new_label("AA", "Anti-aimbot angles", "user : "..name.. "")
client.set_event_callback("setup_command", on_setup_command)
main()