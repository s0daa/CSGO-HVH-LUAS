--stay og leaks kids....
local aa = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	leg = ui.reference("AA", "Other", "Leg Movement"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	dmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
	roll = ui.reference("AA", "anti-aimbot angles", "Roll"),
	hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
	baim = ui.reference("RAGE", "Aimbot", "Force body aim"),
	preferbaim = ui.reference("RAGE", "Aimbot", "Prefer body aim"),
	prefersp = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
	sp = { ui.reference("RAGE", "Aimbot", "Force safe point") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	sw = { ui.reference("AA", "Other", "Slow motion") },
	dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
	ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
	fakelag = ui.reference("AA", "Fake lag", "Limit"),
}

local fs_fix = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local easing = require "gamesense/easing"
local base64 = require "gamesense/base64"
local clipboard = require 'gamesense/clipboard'
local images = require "gamesense/images"
local csgo_weapons = require "gamesense/csgo_weapons"
local anti_aim = require 'gamesense/antiaim_funcs'
local vector = require "vector"
local screen_x, screen_y = client.screen_size()
local real_x, real_y = screen_x / 2, screen_y / 2
local manual_state = ui.new_slider("AA", "Anti-aimbot angles", "\n Manual Direction Number", 0, 3, 0)
local tbl = {}
-- hide shits
local debug = false
client.set_event_callback("paint_ui", function(e)
	ui.set(aa.roll,0)
	ui.set_visible(manual_state,debug)
    ui.set_visible(fs_fix,debug)
	ui.set_visible(aa.pitch,debug)
	ui.set_visible(aa.yawbase,debug)
	ui.set_visible(aa.yaw[1],debug)
	ui.set_visible(aa.yaw[2],debug)
	ui.set_visible(aa.fsbodyyaw,debug)
	ui.set_visible(aa.edgeyaw,debug)
	ui.set_visible(aa.yawjitter[1],debug)
	ui.set_visible(aa.yawjitter[2],debug)
	ui.set_visible(aa.bodyyaw[1],debug)
	ui.set_visible(aa.bodyyaw[2],debug)
	ui.set_visible(aa.roll,debug)
end)

local header = ui.new_label("AA", "Anti-aimbot angles", '\aD0B0FFFFStrike Anti-Aim System - [ Exploits ]')
local menu_choice = ui.new_combobox("AA", "Anti-aimbot angles","\a7FE5FFFF\nMenu",{"Keybinds",'Anti-Aim Builder','Exploits','Visuals'})
local menu = {}
menu.hotkey = {
    m_left = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Left \aFFFFFFFF+"),
	m_right = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Right \aFFFFFFFF+"),
	m_back = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Back \aFFFFFFFF+"),
    pitch_breaker = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFPitch Breaker \aFFFFFFFF+"),
	tp = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFTeleport on Vulnerable \aFFFFFFFF+"),
    fs = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFFreestanding \aFFFFFFFF+"),
}
menu.exploits = {
    force_def = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFForce Defensive \aFFFFFFFF-"),
    ext_def = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFExtrapolate Defensive Cycle \aFFFFFFFF-"),    
}
local pstate = {"STAND","MOVE","MOVE+","AIR","AIR+","AIR-D","AIR-D+","CROUCH","SLOWWALK"}
menu.builder = {
    epeek_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFEnable E-peek \aFFFFFFFF-"),
    state = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFFPlayer State",pstate),
}
for i=1,9 do
    menu.builder[i] = {
        yawlr_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Settings",{"Static Yaw","Yaw L&R"}),
        yaw = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw",-180,180,0),
        yawl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw [L]",-180,180,0),
        yawr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw [R]",-180,180,0),
        yaw_sway = ui.new_checkbox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway"),
        yaws1 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [1]",-180,180,0),
        yaws2 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [2]",-180,180,0),
        yaws3 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [3]",-180,180,0),
        yaws4 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [4]",-180,180,0),
        yaw_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAdditional Yaw Settings",{"Off","Twist [Customized Swap-Time]","Switch [Tick-Based]","Switch [Choke-Based]"}),
        yaw_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw (Switch)",-180,180,0),
        yaw_twist = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Twist Time (Tick)",2,100,0),
        jittermode = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Mode",{"Off","Offset","Center","Random"}),
        jitter = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value",-180,180,0),
        jitterl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value [L]",-180,180,0),
        jitterr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value [R]",-180,180,0),
        byawmode = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Mode",{"Jitter","Static"}),
        byaw = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value",-180,180,0),
        --byawl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value [L]",-180,180,0),
        --byawr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value [R]",-180,180,0),
        byaw_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAdditional Body Yaw Settings",{"Off","Twist [Customized Swap-Time]","Switch [Tick-Based]","Switch [Choke-Based]"}),
        byaw_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw (Switch)",-180,180,0),
        byaw_twist = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Twist Time (Tick)",2,100,0),
        fakelimit = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit",0,60,60),
        fakelimitl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit [L]",0,60,60),
        fakelimitr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit [R]",0,60,60),
        abf_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce Setting",{"Off","Switch Yaw Offset","Switch Body Yaw Offset","Hybrid"}),
        abf_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce >> Yaw",-180,180,0),
        abf_switchb = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce >> Body Yaw",-180,180,0),
    }
end
local cur
local sel_state
local function hide_builder_functional()
    for i=1,9 do
        if ui.get(menu.builder[i].yaw_sett) == "Off" then
            ui.set_visible(menu.builder[i].yaw_switch,false)
        end
        if ui.get(menu.builder[i].yaw_sett) ~= "Twist [Customized Swap-Time]" then
            ui.set_visible(menu.builder[i].yaw_twist,false)
        end
        if ui.get(menu.builder[i].byaw_sett) == "Off" then
            ui.set_visible(menu.builder[i].byaw_switch,false)
        end
        if ui.get(menu.builder[i].byaw_sett) ~= "Twist [Customized Swap-Time]" then
            ui.set_visible(menu.builder[i].byaw_twist,false)
        end  
        if ui.get(menu.builder[i].abf_sett) == "Off" or ui.get(menu.builder[i].abf_sett) == "Switch Body Yaw Offset" then
            ui.set_visible(menu.builder[i].abf_switch,false)
        end
        if ui.get(menu.builder[i].abf_sett) ~= "Hybrid" and ui.get(menu.builder[i].abf_sett) ~= "Switch Body Yaw Offset" then
            ui.set_visible(menu.builder[i].abf_switchb,false)
        end
        if ui.get(menu.builder[i].yawlr_sett) ~= "Yaw L&R" then
            ui.set_visible(menu.builder[i].fakelimitl,false)
            ui.set_visible(menu.builder[i].fakelimitr,false)
            ui.set_visible(menu.builder[i].yawl,false)
            ui.set_visible(menu.builder[i].yawr,false)
            ui.set_visible(menu.builder[i].jitterl,false)
            ui.set_visible(menu.builder[i].jitterr,false)      
            --ui.set_visible(menu.builder[i].byawl,false)
            --ui.set_visible(menu.builder[i].byawr,false)
        else
            ui.set_visible(menu.builder[i].yaw,false)  
            ui.set_visible(menu.builder[i].fakelimit,false)
            ui.set_visible(menu.builder[i].jitter,false)
            --ui.set_visible(menu.builder[i].byaw,false)       
        end 
        if not ui.get(menu.builder[i].yaw_sway) then
            ui.set_visible(menu.builder[i].yaws1,false)
            ui.set_visible(menu.builder[i].yaws2,false)
            ui.set_visible(menu.builder[i].yaws3,false)
            ui.set_visible(menu.builder[i].yaws4,false)
        end
    end
end
local function hide_builder()
    sel_state = ui.get(menu.builder.state)
    for z=1,9 do
       for i,v in pairs(menu.builder[z]) do
            ui.set_visible(v,sel_state == pstate[z] and cur == "Anti-Aim Builder")
       end
    end
    hide_builder_functional()
end
local function menuhandler()
    cur = ui.get(menu_choice)
    ui.set(header,'\aD0B0FFFFStrike Anti-Aim System - [ '..cur..' ]')
    for i,v in pairs(menu.exploits) do
        ui.set_visible(v,cur == "Exploits")
    end
    for i,v in pairs(menu.hotkey) do
        ui.set_visible(v,cur == "Keybinds")
    end
    ui.set_visible(menu.builder.epeek_enable,cur == "Anti-Aim Builder")
    ui.set_visible(menu.builder.state,cur == "Anti-Aim Builder")
    hide_builder()
end
menuhandler()
ui.set_callback(menu_choice,menuhandler)
ui.set_callback(menu.builder.state,hide_builder)
for i=1,9 do
    ui.set_callback(menu.builder[i].yawlr_sett,hide_builder)
    ui.set_callback(menu.builder[i].yaw_sett,hide_builder)
    ui.set_callback(menu.builder[i].byaw_sett,hide_builder)
    ui.set_callback(menu.builder[i].abf_sett,hide_builder)
    ui.set_callback(menu.builder[i].yaw_sway,hide_builder)
end

client.set_event_callback("setup_command", function(cmd)
    if ui.get(menu.exploits.force_def) then
        cmd.force_defensive = 1
    end
end)
client.set_event_callback("paint_ui", function()
    local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
end)

-- tp on vul

client.set_event_callback("setup_command", function()
	if not ui.get(menu.hotkey.tp) then
		ui.set(aa.dt[1],true)
		return
	end
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
	local enemies = entity.get_players(true)
	local vis = false
	for i=1, #enemies do
		local entindex = enemies[i]
		local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
		if client.visible(body_x, body_y, body_z + 20) then
			vis = true
		end
	end	
	if vis then
		ui.set(aa.dt[1],false)
	else
		ui.set(aa.dt[1],true)
	end
end)

local fsdirection = "M"

local function fs_system()
    local cpitch, cyaw = client.camera_angles()
	local local_player = entity.get_local_player()
    local re_x, re_y, re_z = client.eye_position()
	local enemies = entity.get_players(true)
	for i=1, #enemies do
        local entindex = enemies[i]
        local body_x,body_y,body_z = entity.hitbox_position(entindex, 3)
        local r = 70
        local xoffs = {}
        local yoffs = {}
        local worldpos = {}
        local dmgpredicts = {}
        local bestdirection = 0
        local bestdmg = 0
        local useless = false
		local enmvis = client.visible(body_x, body_y, body_z)

        for i=1,12 do
            local offset = i * 20 - 120
            xoffs[i] = math.cos(math.rad(cyaw - offset)) * r
            yoffs[i] = math.sin(math.rad(cyaw - offset)) * r
            useless, dmgpredicts[i] = client.trace_bullet(entindex, re_x + xoffs[i], re_y + yoffs[i], re_z, body_x, body_y, body_z, true)
            local visibleornot = client.visible(re_x + xoffs[i] + 2, re_y + yoffs[i] + 2 , re_z)
            if visibleornot then
                if dmgpredicts[i] > bestdmg then
                    bestdmg = dmgpredicts[i]
                    bestdirection = cyaw - offset
                end
            end
        end
        local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
		if not client.visible(body_x, body_y, body_z + 20) then
			if bestdirection == 0 then
				fsdirection = "M"
			elseif cyaw > bestdirection then
				fsdirection = "L"
			else 
				fsdirection = "R"
			end
		else
            fsdirection = "M"
        end
    end
    
end
client.set_event_callback("paint_ui", fs_system)

-- pasted & fixed anti-bf

local abftimer = globals.tickcount()
local timer = globals.tickcount()
local last_abftick = 0
local reversed = false
local ref = {
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	bodyyaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
	fs = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
	os = {ui.reference('AA', 'Other', 'On shot anti-aim')},
	dt = {ui.reference('RAGE', 'Aimbot', 'Double tap')}
}
local sc 			= {client.screen_size()}
local cw 			= sc[1]/2
local ch 			= sc[2]/2
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
local iu = {
	x = database.read("ui_x") or 250,
	y = database.read("ui_y") or 250,
	w = 140,
	h = 1,
	dragging = false
}
local function intersect(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end
local function clamp(x, min, max)
	return x < min and min or x > max and max or x
end
local function contains(table, key)
    for index, value in pairs(table) do
        if value == key then return true end -- , index
    end
    return false -- , nil
end
local function KaysFunction(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end
local function reset_brute()
	pct = 1
	start = 720
	reversed = false
end
local function on_bullet_impact(e)
	local local_player = entity.get_local_player()
	local shooter = client.userid_to_entindex(e.userid)

	if not true then return end

	if not entity.is_enemy(shooter) or not entity.is_alive(local_player) then
		return
	end

	local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

	if globals.tickcount() - abftimer < 0 then
		abftimer = globals.tickcount()
	end

	if globals.tickcount() - abftimer > 3 and closest < 70 then
		pct = 1
		start = 720
		abftimer = globals.tickcount()
		reversed = not reversed
		last_abftick = globals.tickcount()
	end
end
local function handle_callbacks()
	local call_back = client.set_event_callback
	call_back('bullet_impact', on_bullet_impact)
	call_back('shutdown', function()
		reset_brute()
	end)
	call_back('round_end', reset_brute)
	call_back('round_start', reset_brute)
	call_back('client_disconnect', reset_brute)
	call_back('level_init', reset_brute)
	call_back('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then reset_brute() end end)
end
handle_callbacks()

--epeek

client.set_event_callback("setup_command",function(e)
    if not ui.get(menu.builder.epeek_enable) then
        return
    end
    local weaponn = entity.get_player_weapon()
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
end)

--manual bind system

local bind_system = {left = false, right = false, back = false,}
function bind_system:update()
	ui.set(menu.hotkey.m_left, "On hotkey")
	ui.set(menu.hotkey.m_right, "On hotkey")
	ui.set(menu.hotkey.m_back, "On hotkey")
	local m_state = ui.get(manual_state)
	local left_state, right_state, backward_state = 
		ui.get(menu.hotkey.m_left), 
		ui.get(menu.hotkey.m_right),
		ui.get(menu.hotkey.m_back)
	if left_state == self.left and 
		right_state == self.right and
		backward_state == self.back then
		return
	end
	self.left, self.right, self.back = 
		left_state, 
		right_state, 
		backward_state
	if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
		ui.set(manual_state, 0)
		return
	end
	if left_state and m_state ~= 1 then
		ui.set(manual_state, 1)
	end
	if right_state and m_state ~= 2 then
		ui.set(manual_state, 2)
	end
	if backward_state and m_state ~= 3 then
		ui.set(manual_state, 3)	
	end
end

-- functions
local tbl = {}
tbl.checker = 0
tbl.defensive = 0
local tickreversed = false
local chokereversed = false
local twisted = false
local tick_var = 0
local tick_var2 = 0
local tick_var3 = 0
local sway_stage = 1
local function tickrev(a,b)
	return tickreversed and a or b
end
local function chokerev(a,b)
	return chokereversed and a or b
end
local function twist(a,b,time)
    if globals.tickcount() % time == 0 then
        twisted = true
    else
        twisted = false
    end
    return twisted and b or a
end
local function sway(a,b,c,d,e)
	return sway_stage == 1 and a or sway_stage == 2 and b or sway_stage == 3 and c or sway_stage == 4 and d or sway_stage == 5 and e
end
client.set_event_callback("paint_ui", function()
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    tbl.defensive = math.abs(tickbase - tbl.checker)
    tbl.checker = math.max(tickbase, tbl.checker or 0)
end)
-- main callback
local snum = 1
local setting = {}
client.set_event_callback("setup_command", function(arg)
    if globals.tickcount() - last_abftick > 600 and reversed then
		reset_brute()
	end
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
	if globals.tickcount() - tick_var2 > 1 then
		tickreversed = not tickreversed
		tick_var2 = globals.tickcount()
	elseif globals.tickcount() - tick_var2 < -1 then
		tick_var2 = globals.tickcount()
	end
    if globals.tickcount() - tick_var > 0 and arg.chokedcommands == 1 then
		chokereversed = not chokereversed
		tick_var = globals.tickcount()
	elseif globals.tickcount() - tick_var < -1 then
		tick_var = globals.tickcount()
	end
    if globals.tickcount() - tick_var3 > 1 and globals.chokedcommands() == 1 then
		if sway_stage < 5 then 
            sway_stage = sway_stage + 1
        elseif sway_stage >= 5 then
            sway_stage = 1
        end
		tick_var3 = globals.tickcount()
	elseif globals.tickcount() - tick_var3 < -1 then
		tick_var3 = globals.tickcount()
	end
    local vx, vy = entity.get_prop(local_player, "m_vecVelocity")
	local speed = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + 0.5))
	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
	local ekey = client.key_state(0x45)
    local onexploit = ui.get(aa.dt[2]) or ui.get(aa.os[2])
    bind_system:update()
    --state detection
    if client.key_state(0x20) or not onground then
        if infiniteduck then
            if onexploit then
                snum = 7
            else
                snum = 6
            end
        else
            if onexploit then
                snum = 5
            else
                snum = 4
            end
        end
    elseif onground and infiniteduck or onground and ui.get(aa.fakeduck) then
        snum = 8
    elseif ui.get(aa.sw[1]) and ui.get(aa.sw[2]) then
        snum = 9
    elseif onground and speed > 5 then
        if onexploit then
            snum = 3
        else
            snum = 2
        end
    else
        snum = 1
    end
    local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0 and ui.get(manual_state) ~= 3
	if mwork then
		msyaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87
	end
    setting.yaw = ui.get(menu.builder[snum].yaw)
    setting.jitter = ui.get(menu.builder[snum].jitter)
    setting.byaw = ui.get(menu.builder[snum].byaw)
    setting.fakelimit = ui.get(menu.builder[snum].fakelimit)
    if ui.get(menu.builder[snum].yaw_sett) ~= "Off" then
        if ui.get(menu.builder[snum].yaw_sett) == "Twist [Customized Swap-Time]" then
            setting.yaw = twist(setting.yaw,ui.get(menu.builder[snum].yaw_switch),ui.get(menu.builder[snum].yaw_twist))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Tick-Based]" then
            setting.yaw = tickrev(setting.yaw,ui.get(menu.builder[snum].yaw_switch))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Choke-Based]" then
            setting.yaw = chokerev(setting.yaw,ui.get(menu.builder[snum].yaw_switch))
        end
    end
    if ui.get(menu.builder[snum].byaw_sett) ~= "Off" then
        if ui.get(menu.builder[snum].byaw_sett) == "Twist [Customized Swap-Time]" then
            setting.byaw = twist(setting.byaw,ui.get(menu.builder[snum].byaw_switch),ui.get(menu.builder[snum].byaw_twist))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Tick-Based]" then
            setting.byaw = tickrev(setting.byaw,ui.get(menu.builder[snum].byaw_switch))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Choke-Based]" then
            setting.byaw = chokerev(setting.byaw,ui.get(menu.builder[snum].byaw_switch))
        end
    end
    if ui.get(menu.builder[snum].abf_sett) ~= "Off" then
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "Switch Body Yaw Offset" then
            setting.yaw = ui.get(menu.builder[snum].abf_switch)
        end
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "Switch Yaw Offset" then
            setting.byaw = ui.get(menu.builder[snum].abf_switchb)
        end
    end
    if ui.get(menu.builder[snum].yawlr_sett) == "Yaw L&R" then
        setting.yaw = chokerev(ui.get(menu.builder[snum].yawl),ui.get(menu.builder[snum].yawr))
        if ui.get(menu.builder[snum].jittermode) == "Center" then
            setting.yaw = setting.yaw + chokerev(-1 * (ui.get(menu.builder[snum].jitterl) / 2),ui.get(menu.builder[snum].jitterr) / 2)
            setting.jitter = 0
        else
            setting.jitter = chokerev(ui.get(menu.builder[snum].jitterl),ui.get(menu.builder[snum].jitterr))
        end
        setting.fakelimit = chokerev(ui.get(menu.builder[snum].fakelimitl),ui.get(menu.builder[snum].fakelimitr))
    end
    if ui.get(menu.builder[snum].yaw_sway) then
        if ui.get(menu.builder[snum].yawlr_sett) == "Yaw L&R" then
            setting.yaw = sway(ui.get(menu.builder[snum].yaws1),ui.get(menu.builder[snum].yaws2),setting.yaw,ui.get(menu.builder[snum].yaws3),ui.get(menu.builder[snum].yaws4)) + chokerev(-1 * (ui.get(menu.builder[snum].jitterl) / 2),ui.get(menu.builder[snum].jitterr) / 2)
        else
            setting.yaw = sway(ui.get(menu.builder[snum].yaws1),ui.get(menu.builder[snum].yaws2),setting.yaw,ui.get(menu.builder[snum].yaws3),ui.get(menu.builder[snum].yaws4))
        end
    end 
    if setting.fakelimit == 60 then
        setting.fakelimit = 59
    end
	local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0
	if mwork then
		setting.yaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87 or setting.yaw
	end
    if (tbl.defensive > 2 and tbl.defensive < 14) and ui.get(menu.hotkey.pitch_breaker) then
        ui.set(aa.pitch,"Up")
    else
        ui.set(aa.pitch,"Minimal")
    end
	if mwork then
    	ui.set(aa.yawbase,"Local view")
	else
		ui.set(aa.yawbase,"At targets")
	end
    ui.set(aa.yaw[1],"180")
    ui.set(aa.yaw[2],setting.yaw)
    ui.set(aa.yawjitter[1],ui.get(menu.builder[snum].jittermode))
    ui.set(aa.yawjitter[2],setting.jitter)
    ui.set(aa.bodyyaw[1],ui.get(menu.builder[snum].byawmode))
    ui.set(aa.bodyyaw[2],setting.byaw)
    if ui.get(menu.hotkey.fs) then
        ui.set(fs_fix, true)
        ui.set(fs_fix[1],"Always On")
    else
        ui.set(fs_fix, false)
    end
end)

local ui_get = ui.get
local ui_set = ui.set
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
local function export_cfg()
	local str = ""

	for i=1, 9 do

		str = str
		.. tostring(ui.get(menu.builder[i].yawlr_sett)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaw)) .. "|"
		.. tostring(ui.get(menu.builder[i].yawl)) .. "|"
		.. tostring(ui.get(menu.builder[i].yawr)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaw_sway)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws1)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws2)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws3)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaws4)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_twist)) .. "|"
        .. tostring(ui.get(menu.builder[i].jittermode)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitter)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitterl)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitterr)) .. "|"
        .. tostring(ui.get(menu.builder[i].byawmode)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw)) .. "|"
    --    .. tostring(ui.get(menu.builder[i].byawl)) .. "|"
    --    .. tostring(ui.get(menu.builder[i].byawr)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_twist)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimit)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimitl)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimitr)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_switchb)) .. "|"
	end
	clipboard.set(base64.encode(str))
end

local function load_cfg(input)
	local tbl = str_to_sub(input, "|")
	for i=1, 9 do
		ui_set(menu.builder[i].yawlr_sett, tostring(tbl[1 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaw, tonumber(tbl[2 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yawl, tonumber(tbl[3 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yawr, tonumber(tbl[4 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaw_sway, to_boolean(tbl[5 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws1, tonumber(tbl[6 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws2, tonumber(tbl[7 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws3, tonumber(tbl[8 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaws4, tonumber(tbl[9 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_sett, tostring(tbl[10 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_switch, tonumber(tbl[11 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_twist, tonumber(tbl[12 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jittermode, tostring(tbl[13 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jitter, tonumber(tbl[14 + (27 * (i - 1))]))   
        ui_set(menu.builder[i].jitterl, tonumber(tbl[15 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jitterr, tonumber(tbl[16 + (27 * (i - 1))]))       
        ui_set(menu.builder[i].byawmode, to_boolean(tbl[17 + (27 * (i - 1))]))    
        ui_set(menu.builder[i].byaw, tonumber(tbl[18 + (27 * (i - 1))]))  
 --       ui_set(menu.builder[i].byawl, tonumber(tbl[19 + (29 * (i - 1))]))   
 --       ui_set(menu.builder[i].byawr, tonumber(tbl[20 + (29 * (i - 1))]))
        ui_set(menu.builder[i].byaw_sett, tostring(tbl[19 + (27 * (i - 1))]))       
        ui_set(menu.builder[i].byaw_switch, tonumber(tbl[20 + (27 * (i - 1))]))    
        ui_set(menu.builder[i].byaw_twist, tonumber(tbl[21 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimit, tonumber(tbl[22 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimitl, tonumber(tbl[23 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimitr, tonumber(tbl[24 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_sett, tostring(tbl[25 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_switch, tonumber(tbl[26 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_switchb, tonumber(tbl[27 + (27 * (i - 1))]))         
	end
end

local function export_stage_cfg()
	local str = ""

	for i=1, 9 do
        if sel_state == pstate[i] then
            str = str
            .. tostring(ui.get(menu.builder[i].yawlr_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw)) .. "|"
            .. tostring(ui.get(menu.builder[i].yawl)) .. "|"
            .. tostring(ui.get(menu.builder[i].yawr)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_sway)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws1)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws2)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws3)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws4)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_twist)) .. "|"
            .. tostring(ui.get(menu.builder[i].jittermode)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitter)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitterl)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitterr)) .. "|"
            .. tostring(ui.get(menu.builder[i].byawmode)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw)) .. "|"
 --           .. tostring(ui.get(menu.builder[i].byawl)) .. "|"
 --           .. tostring(ui.get(menu.builder[i].byawr)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_twist)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimit)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimitl)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimitr)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_switchb)) .. "|"
        end
	end
	clipboard.set(base64.encode(str))
end

local function load_stage_cfg(input)
	local tbl = str_to_sub(input, "|")
	for i=1, 9 do
        if sel_state == pstate[i] then
            ui_set(menu.builder[i].yawlr_sett, tostring(tbl[1]))
            ui_set(menu.builder[i].yaw, tonumber(tbl[2]))
            ui_set(menu.builder[i].yawl, tonumber(tbl[3]))
            ui_set(menu.builder[i].yawr, tonumber(tbl[4]))
            ui_set(menu.builder[i].yaw_sway, to_boolean(tbl[5]))
            ui_set(menu.builder[i].yaws1, tonumber(tbl[6]))
            ui_set(menu.builder[i].yaws2, tonumber(tbl[7]))
            ui_set(menu.builder[i].yaws3, tonumber(tbl[8]))
            ui_set(menu.builder[i].yaws4, tonumber(tbl[9]))
            ui_set(menu.builder[i].yaw_sett, tostring(tbl[10]))
            ui_set(menu.builder[i].yaw_switch, tonumber(tbl[11]))
            ui_set(menu.builder[i].yaw_twist, tonumber(tbl[12]))
            ui_set(menu.builder[i].jittermode, tostring(tbl[13]))
            ui_set(menu.builder[i].jitter, tonumber(tbl[14]))   
            ui_set(menu.builder[i].jitterl, tonumber(tbl[15]))
            ui_set(menu.builder[i].jitterr, tonumber(tbl[16]))       
            ui_set(menu.builder[i].byawmode, to_boolean(tbl[17]))    
            ui_set(menu.builder[i].byaw, tonumber(tbl[18]))  
 --           ui_set(menu.builder[i].byawl, tonumber(tbl[19]))   
--            ui_set(menu.builder[i].byawr, tonumber(tbl[20]))
            ui_set(menu.builder[i].byaw_sett, tostring(tbl[19]))       
            ui_set(menu.builder[i].byaw_switch, tonumber(tbl[20]))    
            ui_set(menu.builder[i].byaw_twist, tonumber(tbl[21]))         
            ui_set(menu.builder[i].fakelimit, tonumber(tbl[22]))         
            ui_set(menu.builder[i].fakelimitl, tonumber(tbl[23]))         
            ui_set(menu.builder[i].fakelimitr, tonumber(tbl[24]))         
            ui_set(menu.builder[i].abf_sett, tostring(tbl[25]))         
            ui_set(menu.builder[i].abf_switch, tonumber(tbl[26]))         
            ui_set(menu.builder[i].abf_switchb, tonumber(tbl[27]))         
        end
	end
end

local function import_cfg()
	local cfgtext = base64.decode(clipboard.get())
	load_cfg(cfgtext)
end
local function import_stage_cfg()
	local cfgtext = base64.decode(clipboard.get())
	load_stage_cfg(cfgtext)
end




-- visuals
local vector = require('vector')
local images = require("gamesense/images")
local http = require "gamesense/http"
--local inspect = require'inspect'
local build = "nightly"

local ctx = (function()
	local ctx = {
		logo = nil
	}

	http.get("https://cdn.discordapp.com/attachments/1059923204715589793/1061782417557442601/strike_shit_lua-removebg.png", function(success, response)
		if not success or response.status ~= 200 then
			return
		end
	
		ctx.logo = images.load_png(response.body)
	end)

	ctx.ref = {
		fd = ui.reference("Rage", "Other", "Duck peek assist"),
		dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
		dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
		hs = {ui.reference("AA", "Other", "On shot anti-aim")},
		silent = ui.reference("Rage", "Other", "Silent aim"),
		slow_motion = {ui.reference("AA", "Other", "Slow motion")}
	}

	ctx.helpers = {
		defensive = 0,
		checker = 0,
		contains = function(self, tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		split = function(self, inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end,

		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		hex_to_rgba = function(self, hex)
    	local color = tonumber(hex, 16)

    	return 
        math.floor(color / 16777216) % 256, 
        math.floor(color / 65536) % 256, 
        math.floor(color / 256) % 256, 
        color % 256
		end,

		color_text = function(self, string, r, g, b, a)
			local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
			local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

			local str = ""
			for i, s in ipairs(self:split(string, "$")) do
				str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end

			return str
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (155 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. ctx.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

		get_velocity = function(self, ent)
			return vector(entity.get_prop(ent, "m_vecVelocity")):length()
		end,

		in_air = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
	
			if bit.band(flags, 1) == 0 then
				return true
			end
			
			return false
		end,

		in_duck = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
			
			if bit.band(flags, 4) == 4 then
				return true
			end
			
			return false
		end,

		get_state = function(self, ent)
			local vel = self:get_velocity(ent)
			local air = self:in_air(ent)
			local duck = self:in_duck(ent)

			local state = vel > 3 and "run" or "stand"
			if air then
				state = duck and "duck jump" or "jump"
			elseif ui.get(ctx.ref.slow_motion[1]) and ui.get(ctx.ref.slow_motion[2]) and ent == entity.get_local_player() then
				state = "slow move"
			elseif duck then
				state = "duck"
			end

			return state
		end,

		get_time = function(self, h12)
			local hours, minutes, seconds = client.system_time()

			if h12 then
					local hrs = hours % 12

					if hrs == 0 then
							hrs = 12
					else
							hrs = hrs < 10 and hrs or ('%02d'):format(hrs)
					end

					return ('%s:%02d %s'):format(
							hrs,
							minutes,
							hours >= 12 and 'pm' or 'am'
					)
			end

			return ('%02d:%02d:%02d'):format(
					hours,
					minutes,
					seconds
			)
	end,
	}

	ctx.menu = {
		label = ui.new_label("AA", "Anti-aimbot angles", "\a8BFF7CFFAccent >>"),
		color = ui.new_color_picker("AA", "Anti-aimbot angles", "log color", 208, 176, 255, 255),
		notifications = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFNotification \aFFFFFFFF-"),
		options = ui.new_multiselect("AA", "Anti-aimbot angles", "\n", {"rounding", "size", "glow", "time", }),
		rounding = ui.new_slider("AA", "Anti-aimbot angles", "notification rounding", 1, 10, 0.8, true, "%", 0.1),
		size = ui.new_slider("AA", "Anti-aimbot angles", "notification size", 0, 10, 10, true, "x", 0.2),
		glow = ui.new_slider("AA", "Anti-aimbot angles", "notification glow size", 0, 20, 110, true, "x", 0.1),
		time = ui.new_slider("AA", "Anti-aimbot angles", "notification time", 3, 15, 5, true, "s",1),
		indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFIndicators \aFFFFFFFF-"),
		style = ui.new_combobox("AA", "Anti-aimbot angles", "\n", {"#1", "#2"}),
		watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFWatermark \aFFFFFFFF-"),
		initialize = function(self)
			local callback = function()
				local notifs = ui.get(self.notifications)
				local options = ui.get(self.options)
				local indicators = ui.get(self.indicators)

				ui.set_visible(self.options, notifs)
				ui.set_visible(self.rounding, notifs and ctx.helpers:contains(options, "rounding"))
				ui.set_visible(self.size, notifs and ctx.helpers:contains(options, "size"))
				ui.set_visible(self.glow, notifs and ctx.helpers:contains(options, "glow"))
				ui.set_visible(self.time, notifs and ctx.helpers:contains(options, "time"))
				ui.set_visible(self.style, indicators)
			end

			for _, item in pairs(self) do
				if type(item) ~= "function" then
					ui.set_callback(item, callback)
				end
			end
			callback()
		end
	}
	ctx.m_render = {
		rec = function(self, x, y, w, h, radius, color)
			radius = math.min(x/2, y/2, radius)
			local r, g, b, a = unpack(color)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end,

		rec_outline = function(self, x, y, w, h, radius, thickness, color)
			radius = math.min(w/2, h/2, radius)
			local r, g, b, a = unpack(color)
			if radius == 1 then
				renderer.rectangle(x, y, w, thickness, r, g, b, a)
				renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
			else
				renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
				renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
			end
		end,

		glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = unpack(accent)
			if accent_inner then
				self:rec(x , y, w, h + 1, rounding, accent_inner)
				--renderer.blur(x , y, w, h)
				--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
			end
			for k = 0, width do
				if a * (k/width)^(1) > 5 then
					local accent = {r, g, b, a * (k/width)^(2)}
					self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
				end
			end
		end
	}

	ctx.notifications = {
		anim_time = 0.75,
		max_notifs = 6,
		data = {},

		new = function(self, string, r, g, b)
			table.insert(self.data, {
				time = globals.curtime(),
				string = string,
				color = {r, g, b, 255},
				fraction = 0
			})
			local time = ctx.helpers:contains(ui.get(ctx.menu.options), "time") and ui.get(ctx.menu.time) or 5
			for i = #self.data, 1, -1 do
				local notif = self.data[i]
				if #self.data - i + 1 > self.max_notifs and notif.time + time - globals.curtime() > 0 then
					notif.time = globals.curtime() - time
				end
			end
		end,

		render = function(self)
			local x, y = client.screen_size()
			local to_remove = {}
			local offset = 0
			for i = 1, #self.data do
				local notif = self.data[i]

				local options = ui.get(ctx.menu.options)
				local data = {rounding = 8, size = 4, glow = 8, time = 5}
				for _, item in ipairs(options) do
					data[item] = ui.get(ctx.menu[item])
				end

				if notif.time + data.time - globals.curtime() > 0 then
					notif.fraction = ctx.helpers:clamp(notif.fraction + globals.frametime() / self.anim_time, 0, 1)
				else
					notif.fraction = ctx.helpers:clamp(notif.fraction - globals.frametime() / self.anim_time, 0, 1)
				end

				if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
					table.insert(to_remove, i)
				end
				local fraction = ctx.helpers:easeInOut(notif.fraction)

				local r, g, b, a = unpack(notif.color)
				local string = ctx.helpers:color_text(notif.string, r, g, b, a * fraction)

				local strw, strh = renderer.measure_text("", string)
				local strw2 = renderer.measure_text("b", " strike  ")

				local paddingx, paddingy = 7, data.size
				data.rounding = math.ceil(data.rounding/10 * (strh + paddingy*2)/2)

				offset = offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction

				ctx.m_render:glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,255 * fraction})
				renderer.text(x/2 + strw2/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "c", 0, string)
				renderer.text(x/2 - strw/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "cb", 0, ctx.helpers:color_text(" $strike  ", r, g, b, a * fraction))
			end

			for i = #to_remove, 1, -1 do
				table.remove(self.data, to_remove[i])
			end
		end,

		clear = function(self)
			self.data = {}
		end
	}

	ctx.indicators = {
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		scoped_fraction = 0,
		fraction = 0,
		render = function(self)
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end

			local state = ctx.helpers:get_state(me)
			local x, y = client.screen_size()
			local r, g, b = ui.get(ctx.menu.color)

			local style = ui.get(ctx.menu.style)
			local scoped = entity.get_prop(me, "m_bIsScoped") == 1

			if scoped then
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction + globals.frametime()/0.5, 0, 1)
			else
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction - globals.frametime()/0.5, 0, 1)
			end

			local scoped_fraction = ctx.helpers:easeInOut(self.scoped_fraction)

			if style == "#1" then
				local strike_w, strike_h = renderer.measure_text("-", "STRIKE YAW")

				ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_fraction - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
				renderer.text(x/2 + ((strike_w + 2)/2) * scoped_fraction, y/2 + 20, 255, 255, 255, 255, "-c", 0, "STRIKE ", "\a" .. ctx.helpers:rgba_to_hex( r, g, b, 255 * math.abs(math.cos(globals.curtime()*2))) .. "YAW")

				local next_attack = entity.get_prop(me, "m_flNextAttack")
				local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

				local dt_toggled = ui.get(ctx.ref.dt[1]) and ui.get(ctx.ref.dt[2])
				local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

				if dt_toggled and dt_active then
					self.active_fraction = ctx.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.active_fraction = ctx.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
				end

				if dt_toggled and not dt_active then
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
				end

				if ui.get(ctx.ref.hs[1]) and ui.get(ctx.ref.hs[2]) and ui.get(ctx.ref.silent) and not dt_toggled then
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
				end

				if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
					self.fraction = ctx.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
				else
					self.fraction = ctx.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
				end

				local dt_size = renderer.measure_text("-", "DT ")
				local ready_size = renderer.measure_text("-", "READY")
				renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.active_fraction * 255, "-c", dt_size + self.active_fraction * ready_size + 1, "DT ", "\a" .. ctx.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction) .. "READY")

				local charging_size = renderer.measure_text("-", "CHARGING")
				local ret = ctx.helpers:animate_text(globals.curtime(), "CHARGING", 255, 100, 100, 255)
				renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.inactive_fraction * 255, "-c", dt_size + self.inactive_fraction * charging_size + 1, "DT ", unpack(ret))

				local hide_size = renderer.measure_text("-", "HIDE ")
				local active_size = renderer.measure_text("-", "ACTIVE")
				renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.hide_fraction * 255, "-c", hide_size + self.hide_fraction * active_size + 1, "HIDE ", "\a" .. ctx.helpers:rgba_to_hex(155, 155, 200, 255 * self.hide_fraction) .. "ACTIVE")
			
				local state_size = renderer.measure_text("-", '- ' .. string.upper(state) .. ' -')
				renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * ctx.helpers:easeInOut(self.fraction), 255, 255, 255, 255, "-c", 0, '- ' .. string.upper(state) .. ' -')
			elseif style == "#2" then
				renderer.text(x/2, y/2 + 20, r, g, b, 255 * math.abs(math.cos(globals.curtime()*2)), "-", 0, "...")
			end
		end
	}

	ctx.watermark = {
		render = function()
			local me = entity.get_local_player()
			local r, g, b = ui.get(ctx.menu.color)
			local x, y = client.screen_size()

			local accent = '\a' .. ctx.helpers:rgba_to_hex(r, g, b, 255)
			local reset = '\a' .. ctx.helpers:rgba_to_hex(255, 255, 255, 255)
			local hours, minutes = client.system_time()


			local str = 'strike.lua [' .. accent .. build .. reset .. '] / ' .. entity.get_player_name(me) .. ' ' .. math.floor((client.latency()*1000)) .. ' ms ' .. ctx.helpers:get_time(true)
			local w, h = renderer.measure_text("", str)
			local paddingw, paddingh = 6, 6
			ctx.m_render:glow_module(x/2 - (w + paddingw)/2, y - 40 - (h + paddingh)/2, (w + paddingw), (h + paddingh), 8, 2, {r, g, b, 20 + 55 * math.abs(math.sin(globals.curtime()*5))}, {25, 25, 25, 155})
			renderer.text(x/2, y - 40, 255, 255, 255, 255, "c", 0, str)
		end
	}

	return ctx
end)()

do
	local r, g, b = ui.get(ctx.menu.color)
	ctx.notifications:new("successfully $loaded$ strike.lua!", r, g, b)
	client.delay_call(1, function()
		ctx.notifications:new("welcome back.", r, g, b)
	end)
end

local function time_to_ticks(t)
	return math.floor(0.5 + (t / globals.tickinterval()))
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local ccheck = function(val)
	for k, v in pairs(ui.get(ctx.menu.options)) do
		if v == val then
			return true
		end
	end
	return false
end


for _, cid in ipairs({
	{
		"paint_ui", 0, function()
			if cur ~= "Visuals" then
				ui.set_visible(ctx.menu.label,false)
				ui.set_visible(ctx.menu.color,false)
				ui.set_visible(ctx.menu.notifications,false)
				ui.set_visible(ctx.menu.options,false)
				ui.set_visible(ctx.menu.rounding,false)
				ui.set_visible(ctx.menu.size,false)
				ui.set_visible(ctx.menu.glow,false)
				ui.set_visible(ctx.menu.time,false)
				ui.set_visible(ctx.menu.indicators,false)
				ui.set_visible(ctx.menu.style,false)
				ui.set_visible(ctx.menu.watermark,false)
			else
				ui.set_visible(ctx.menu.label,true)
				ui.set_visible(ctx.menu.color,true)
				ui.set_visible(ctx.menu.notifications,true)
				ui.set_visible(ctx.menu.indicators,true)
				ui.set_visible(ctx.menu.style,ui.get(ctx.menu.indicators))
				ui.set_visible(ctx.menu.watermark,true)
				if ui.get(ctx.menu.notifications) then
					ui.set_visible(ctx.menu.options,true)
					ui.set_visible(ctx.menu.rounding,ui.get(ctx.menu.notifications) and ccheck("rounding"))
					ui.set_visible(ctx.menu.size,ui.get(ctx.menu.notifications) and ccheck("size"))
					ui.set_visible(ctx.menu.glow,ui.get(ctx.menu.notifications) and ccheck("glow"))
					ui.set_visible(ctx.menu.time,ui.get(ctx.menu.notifications) and ccheck("time"))
				else
					ui.set_visible(ctx.menu.options,false)
				end
			end	
		end
		
	},
	{
		"paint", 0, function()
			if ui.get(ctx.menu.notifications) then
				ctx.notifications:render()
			end

			if ui.get(ctx.menu.indicators) then
				ctx.indicators:render()
			end

			if ui.get(ctx.menu.watermark) then
				ctx.watermark:render()
			end		
		end
		
	},
	{
		"aim_fire" .. "remove_this", 0, function(e)	
			local flags = {
        e.teleported and 'T' or '',
        e.interpolated and 'I' or '',
        e.extrapolated and 'E' or '',
        e.boosted and 'B' or '',
        e.high_priority and 'H' or ''
    	}
    	local group = hitgroup_names[e.hitgroup + 1] or '?'
			local r, g, b, a = ui.get(ctx.menu.color)
			ctx.notifications:new(string.format('fired at %s (%s) for %d dmg (chance=%d%%, bt=%2d, flags=%s)', string.lower(entity.get_player_name(e.target)), group, e.damage, math.floor(e.hit_chance + 0.5), time_to_ticks(e.backtrack), table.concat(flags)), r, g, b)
		end
	},
	{
		"aim_hit", 0 , function(e)
			local r, g, b = ui.get(ctx.menu.color)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			ctx.notifications:new(string.format('hit %s in the %s for %d damage (%d health remaining)', string.lower(entity.get_player_name(e.target)), group, e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b)
		end
	},
	{
		"aim_miss", 0 , function(e)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			ctx.notifications:new(string.format('missed %s (%s) due to %s', string.lower(entity.get_player_name(e.target)), group, e.reason), 255, 120, 120)
		end
	},
	{
		"ui_callback", 0, function()
			ctx.menu:initialize()
		end
	},
	{
		"round_start", 0, function()
			ctx.notifications:clear()
		end
	},
	{
		"client_disconnect", 0, function()
			ctx.notifications:clear()
		end
	},
	{
		"predict_command", 0, function()
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			ctx.helpers.defensive = math.abs(tickbase - ctx.helpers.checker)
			ctx.helpers.checker = math.max(tickbase, ctx.helpers.checker or 0)
		end
	}
}) do
	if cid[1] == 'ui_callback' then
		cid[3]()
	else
		client.delay_call(cid[2], function()
				client.set_event_callback(cid[1], cid[3])
		end)
	end
end

local exp_stage = ui.new_button("AA", "Anti-aimbot angles", "Export Stage Config", export_stage_cfg)
local imp_stage = ui.new_button("AA", "Anti-aimbot angles", "Import Stage Config", import_stage_cfg)
local exp = ui.new_button("AA", "Anti-aimbot angles", "Export Full Config", export_cfg)
local imp = ui.new_button("AA", "Anti-aimbot angles", "Import Full Config", import_cfg)