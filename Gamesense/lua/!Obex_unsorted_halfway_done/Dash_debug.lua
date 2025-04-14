-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--[[
________                 ______  
___  __ \______ ____________  /_ 
__  / / /_  __ `/__  ___/__  __ \
_  /_/ / / /_/ / _(__  ) _  / / /
/_____/  \__,_/  /____/  /_/ /_/ 
     by jello#0110 | Anti-Aim.net | .gg/dashlua                           
--]]
local aa = {
    dtmode = ui.reference("RAGE", "Aimbot", "Double tap"),
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
	smtype = { ui.reference("AA", "Other", "Slow motion") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	fs = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	sw = { ui.reference("AA", "Other", "Slow motion") },
	dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
	ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
	fakelag = ui.reference("AA", "Fake lag", "Limit"),
	mindmg = {ui.reference("Rage", "Aimbot", "Minimum damage override")},
    mindmg2 = {ui.reference("Rage", "Aimbot", "Minimum damage")},
}
local csgo_weapons = require "gamesense/csgo_weapons"
local anti_aim = require 'gamesense/antiaim_funcs'
local vector = require "vector"
local images = require "gamesense/images"
local csgo_weapons = require "gamesense/csgo_weapons"
local anti_aim = require 'gamesense/antiaim_funcs'
local manual_state = ui.new_slider("AA", "Anti-aimbot angles", "\n Manual Direction Number", 0, 3, 0)
local tbl = {}
local debug = false
client.set_event_callback("paint_ui", function(e)
	ui.set(aa.roll,0)
	ui.set_visible(manual_state,debug)
    ui.set_visible(aa.fs[1],debug)
	ui.set_visible(aa.fs[2],debug)
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
local header = ui.new_label("AA", "Anti-aimbot angles", 'a')
local menu_choice = ui.new_combobox("AA", "Anti-aimbot angles","Menu",{'builder', 'visuals', 'misc'})
local menu = {}
menu.bindlist = {
    m_left = ui.new_hotkey("AA", "Anti-aimbot angles", " manaual left "),
	m_right = ui.new_hotkey("AA", "Anti-aimbot angles", " manual right "),
	m_back = ui.new_hotkey("AA", "Anti-aimbot angles", " manual back "),
}
local pstate = {"static","run","jump","jump+","ctrl","slow-mo"}
menu.builder = {
    state = ui.new_combobox("AA", "Anti-aimbot angles","\aFF92BDFF movement state",pstate),
}
for i=1,6 do
    menu.builder[i] = {
        yawlr_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF yaw options",{"normal","custom"}),
        yaw = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF yaw add",-180,180,0),
        yawl = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF left",-180,180,0),
        yawr = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF right",-180,180,0),
        jittermode = ui.new_combobox("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF jitter ",{"off","offset","center","random","skitter"}),
        jitter = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF jitter add",-180,180,0),
        jitterl = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF left",-180,180,0),
        jitterr = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF right",-180,180,0),
        byawmode = ui.new_combobox("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF body yaw",{"static","jitter"}),
        byaw = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF body add",-180,180,0),
        abf_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF antibrute",{"off","invert yaw","invert body yaw","mixed"}),
        abf_switch = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF yaw",-180,180,0),
        abf_switchb = ui.new_slider("AA", "Anti-aimbot angles","\aFF92BDFF"..pstate[i].."\aFFFFFFFF body yaw",-180,180,0),
    }
end
local cur
local sel_state
local function hide_builder_functional()
    for i=1,6 do
        if ui.get(menu.builder[i].abf_sett) == "off" or ui.get(menu.builder[i].abf_sett) == "invert body yaw" then
            ui.set_visible(menu.builder[i].abf_switch,false)
        end
        if ui.get(menu.builder[i].abf_sett) ~= "mixed" and ui.get(menu.builder[i].abf_sett) ~= "invert body yaw" then
            ui.set_visible(menu.builder[i].abf_switchb,false)
        end
        if ui.get(menu.builder[i].yawlr_sett) ~= "custom" then

            ui.set_visible(menu.builder[i].yawl,false)
            ui.set_visible(menu.builder[i].yawr,false)
            ui.set_visible(menu.builder[i].jitterl,false)
            ui.set_visible(menu.builder[i].jitterr,false)      
        else
            ui.set_visible(menu.builder[i].yaw,false)  

            ui.set_visible(menu.builder[i].jitter,false)
        end 
    end
end
local function hide_builder()
    sel_state = ui.get(menu.builder.state)
    for z=1,6 do
       for i,v in pairs(menu.builder[z]) do
            ui.set_visible(v,sel_state == pstate[z] and cur == "builder")
       end
    end
    hide_builder_functional()
end
local function menuhandler()
    cur = ui.get(menu_choice)
    ui.set(header,'\aFF92BDFFdash ~ mega bouse systems')
    for i,v in pairs(menu.bindlist) do
        ui.set_visible(v,cur == "builder")
    end
    ui.set_visible(menu.builder.state,cur == "builder")
    hide_builder()
end
menuhandler()
ui.set_callback(menu_choice,menuhandler)
ui.set_callback(menu.builder.state,hide_builder)
for i=1,6 do
    ui.set_callback(menu.builder[i].yawlr_sett,hide_builder)
    ui.set_callback(menu.builder[i].abf_sett,hide_builder)
end
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
local abftimer = globals.tickcount()
local timer = globals.tickcount()
local last_abftick = 0
local reversed = false
local ref = {
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	bodyyaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
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
        if value == key then return true end
    end
    return false
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
local bind_system = {left = false, right = false, back = false,}
function bind_system:update()
	ui.set(menu.bindlist.m_left, "On hotkey")
	ui.set(menu.bindlist.m_right, "On hotkey")
	ui.set(menu.bindlist.m_back, "On hotkey")
	local m_state = ui.get(manual_state)
	local left_state, right_state, backward_state = 
		ui.get(menu.bindlist.m_left), 
		ui.get(menu.bindlist.m_right),
		ui.get(menu.bindlist.m_back)
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
    if client.key_state(0x20) or not onground then
        if infiniteduck then
            if onexploit then
                snum = 4
            else
                snum = 4
            end
        else
            if onexploit then
                snum = 3
            else
                snum = 3
            end
        end
    elseif onground and infiniteduck or onground and ui.get(aa.fakeduck) then
        snum = 5
    elseif ui.get(aa.sw[1]) and ui.get(aa.sw[2]) then
        snum = 6
    elseif onground and speed > 5 then
        if onexploit then
            snum = 2
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
    if ui.get(menu.builder[snum].abf_sett) ~= "off" then
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "invert body yaw" then
            setting.yaw = ui.get(menu.builder[snum].abf_switch)
        end
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "invert yaw" then
            setting.byaw = ui.get(menu.builder[snum].abf_switchb)
        end
    end
    if ui.get(menu.builder[snum].yawlr_sett) == "custom" then
        setting.yaw = chokerev(ui.get(menu.builder[snum].yawl),ui.get(menu.builder[snum].yawr))
        if ui.get(menu.builder[snum].jittermode) == "center" then
            setting.yaw = setting.yaw + chokerev(-1 * (ui.get(menu.builder[snum].jitterl) / 2),ui.get(menu.builder[snum].jitterr) / 2)
            setting.jitter = 0
        else
            setting.jitter = chokerev(ui.get(menu.builder[snum].jitterl),ui.get(menu.builder[snum].jitterr))
        end
    end
	local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0
	if mwork then
		setting.yaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87 or setting.yaw
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
end)

-- visuals
local vector = require('vector')
local images = require("gamesense/images")
local http = require "gamesense/http"
--local inspect = require'inspect'
local build = "beta"

local dash = (function()
    local dash = {}
	dash.ref = {
		fd = ui.reference("Rage", "Other", "Duck peek assist"),
		dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
		hs = {ui.reference("AA", "Other", "On shot anti-aim")},
		silent = ui.reference("Rage", "Other", "Silent aim"),
		slow_motion = {ui.reference("AA", "Other", "Slow motion")}
	}
	dash.helpers = {
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
				t_out[t_out_iter] = "\a" .. dash.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
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
			local state = vel > 3 and "run" or "static"
			if air then
				state = duck and "jump+" or "jump"
			elseif ui.get(dash.ref.slow_motion[1]) and ui.get(dash.ref.slow_motion[2]) and ent == entity.get_local_player() then
				state = "slow-mo"
			elseif duck then
				state = "crtl"
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
	dash.menu = {
		label = ui.new_label("AA", "Anti-aimbot angles", "\aFF92BDFFcolor"),
		color = ui.new_color_picker("AA", "Anti-aimbot angles", "log color", 255, 146, 189, 255),
		notifications = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF92BDFFpush module"),
		options = ui.new_multiselect("AA", "Anti-aimbot angles", "\n", {"rounding", "size", "glow", "time", }),
		rounding = ui.new_slider("AA", "Anti-aimbot angles", "smoothing", 1, 10, 0.8, true, "%", 0.1),
		size = ui.new_slider("AA", "Anti-aimbot angles", "size", 0, 10, 10, true, "x", 0.2),
		glow = ui.new_slider("AA", "Anti-aimbot angles", "glow", 0, 20, 110, true, "x", 0.1),
		time = ui.new_slider("AA", "Anti-aimbot angles", "time", 3, 15, 5, true, "s",1),
		indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF92BDFFcrosshair inds"),
		style = ui.new_combobox("AA", "Anti-aimbot angles", "\n", {"#1"}),
		initialize = function(self)
			local callback = function()
				local notifs = ui.get(self.notifications)
				local options = ui.get(self.options)
				local indicators = ui.get(self.indicators)

				ui.set_visible(self.options, notifs)
				ui.set_visible(self.rounding, notifs and dash.helpers:contains(options, "rounding"))
				ui.set_visible(self.size, notifs and dash.helpers:contains(options, "size"))
				ui.set_visible(self.glow, notifs and dash.helpers:contains(options, "glow"))
				ui.set_visible(self.time, notifs and dash.helpers:contains(options, "time"))
			end

			for _, item in pairs(self) do
				if type(item) ~= "function" then
					ui.set_callback(item, callback)
				end
			end
			callback()
		end
	}
	dash.m_render = {
		rec = function(self, x, y, w, h, radius, color)
			radius = math.min(x/2, y/2, radius)
            local mr, mg, mb, ma = ui.get(dash.menu.color)
            renderer.rectangle(x + 2, y - 2, w - 5, 2.5, mr, mg, mb, 85)
            renderer.rectangle(x - 2, y - 3, w + 3, 1.5, 10, 10, 10, 200)
            renderer.rectangle(x - 2, y - 2, 2, 20, 10, 10, 10, 200)
            renderer.rectangle(x, y - 2, 2.5, 20, mr, mg, mb, 85)
            renderer.rectangle(x + w - 3, y - 2, 2.5, 20, mr, mg, mb, 85)
            renderer.rectangle(x + w - 1, y - 2, 2, 20, 10, 10, 10, 200)
            renderer.rectangle(x + 2, y + 16, w - 5, 2.5, mr, mg, mb, 85)
            renderer.rectangle(x - 2, y + 18, w + 3, 1.5, 10, 10, 10, 200)
            renderer.rectangle(x + 2, y, w - 5, 16, 28, 28, 28, 255)
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
					self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2,thickness * (width - k + offset), thickness, accent)
				end
			end
		end
	}
    dash.m_render2 = {
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
    

	dash.notifications = {
		anim_time = 0.65,
		max_notifs = 6,
		data = {},

		new = function(self, string, r, g, b)
			table.insert(self.data, {
				time = globals.curtime(),
				string = string,
				color = {r, g, b, 255},
				fraction = 0
			})
			local time = 5
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
            local mr, mg, mb, ma = ui.get(dash.menu.color)
			for i = 1, #self.data do
				local notif = self.data[i]

				local options = ui.get(dash.menu.options)
				local data = {rounding = 8, size = 4, glow = 8, time = 2}
				for _, item in ipairs(options) do
					data[item] = ui.get(dash.menu[item])
				end

				if notif.time + data.time - globals.curtime() > 0 then
					notif.fraction = dash.helpers:clamp(notif.fraction + globals.frametime() / self.anim_time, 0, 1)
				else
					notif.fraction = dash.helpers:clamp(notif.fraction - globals.frametime() / self.anim_time, 0, 1)
				end

				if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
					table.insert(to_remove, i)
				end
				local fraction = dash.helpers:easeInOut(notif.fraction)

				local r, g, b, a = unpack(notif.color)
				local string = dash.helpers:color_text(notif.string, r, g, b, a * fraction)

				local strw, strh = renderer.measure_text("", string)
				local strw2 = renderer.measure_text("b", " !DASH!  ")

				local paddingx, paddingy = 7, data.size
				data.rounding = math.ceil(data.rounding/10 * (strh + paddingy*2)/2)

				offset = offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction

				dash.m_render:glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {mr, mg, mb, 45 * fraction}, {25,25,25,255 * fraction})
				renderer.text(x/2 + strw2/2, y - 102 - offset, 255, 255, 255, 255 * fraction, "c", 0, string)
				renderer.text(x/2 - strw/2, y - 102 - offset, 255, 255, 255, 255 * fraction, "cb", 0, dash.helpers:color_text(" !DASH!  ", r, g, b, a * fraction))
			end

			for i = #to_remove, 1, -1 do
				table.remove(self.data, to_remove[i])
			end
		end,

		clear = function(self)
			self.data = {}
		end
	}

	dash.indicators = {
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

			local state = dash.helpers:get_state(me)
			local x, y = client.screen_size()
			local r, g, b = ui.get(dash.menu.color)

			local style = ui.get(dash.menu.indicators)
			local scoped = entity.get_prop(me, "m_bIsScoped") == 1

			if scoped then
				self.scoped_fraction = dash.helpers:clamp(self.scoped_fraction + globals.frametime()/0.5, 0, 1)
			else
				self.scoped_fraction = dash.helpers:clamp(self.scoped_fraction - globals.frametime()/0.5, 0, 1)
			end

			local scoped_fraction = dash.helpers:easeInOut(self.scoped_fraction)

			if style then
				local DASH_w, DASH_h = renderer.measure_text("-", "DASH")
                local mr, mg, mb, ma = ui.get(dash.menu.color)
				renderer.text(x/2 + ((DASH_w + 2)/2) * scoped_fraction, y/2 + 20, mr, mg, mb, 255, "-c", 0, "DASH ")

				local next_attack = entity.get_prop(me, "m_flNextAttack")
				local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

				local dt_toggled = ui.get(dash.ref.dt[1]) and ui.get(dash.ref.dt[2])
				local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime())

				if dt_toggled and dt_active then
					self.active_fraction = dash.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.active_fraction = dash.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
				end

				if dt_toggled and not dt_active then
					self.inactive_fraction = dash.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.inactive_fraction = dash.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
				end

				if ui.get(dash.ref.hs[1]) and ui.get(dash.ref.hs[2]) and ui.get(dash.ref.silent) and not dt_toggled then
					self.hide_fraction = dash.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.hide_fraction = dash.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
				end

				if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
					self.fraction = dash.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
				else
					self.fraction = dash.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
				end

				local dt_size = renderer.measure_text("-", "DT ")
				local ready_size = renderer.measure_text("-", "READY")
				renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.active_fraction * 255, "-c", dt_size + self.active_fraction * ready_size + 1, "DT ", "\a" .. dash.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction) .. "READY")

				local charging_size = renderer.measure_text("-", "CHARGING")
				local ret = dash.helpers:animate_text(globals.curtime(), "CHARGING", 255, 100, 100, 255)
				renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.inactive_fraction * 255, "-c", dt_size + self.inactive_fraction * charging_size + 1, "DT ", unpack(ret))

				local hide_size = renderer.measure_text("-", "HIDE ")
				local active_size = renderer.measure_text("-", "ACTIVE")
				renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.hide_fraction * 255, "-c", hide_size + self.hide_fraction * active_size + 1, "HIDE ", "\a" .. dash.helpers:rgba_to_hex(155, 155, 200, 255 * self.hide_fraction) .. "ACTIVE")
			
				local state_size = renderer.measure_text("-", '/ ' .. string.upper(state) .. ' /')
				renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * dash.helpers:easeInOut(self.fraction), 255, 255, 255, 255, "-c", 0, '/ ' .. string.upper(state) .. ' /')
		end
    end
	}

	dash.watermark = {
		render = function()
			local me = entity.get_local_player()
			local r, g, b = ui.get(dash.menu.color)
			local x, y = client.screen_size()

			local accent = '\a' .. dash.helpers:rgba_to_hex(r, g, b, 255)
			local reset = '\a' .. dash.helpers:rgba_to_hex(255, 255, 255, 255)

			local str = 'dash +/- anti-aim.net [' .. accent .. build .. reset .. ']' 
			local w, h = renderer.measure_text("", str)
			local paddingw, paddingh = 8, 4
			dash.m_render:rec(x/2 - (w + paddingw)/2 - 700, y - 40 - (h + paddingh)/2, (w + paddingw), (h + paddingh), 8, 6, {r, g, b, 100}, {25, 25, 25, 155})
			renderer.text(x/2 -1 -700, y - 40, 255, 255, 255, 255, "c", 0, str)
		end
	}

	return dash
end)()

do
	local r, g, b = ui.get(dash.menu.color)
	dash.notifications:new("SETUP STARTED", r, g, b)
	client.delay_call(1, function()
		dash.notifications:new("MEGA BOUSE SYSTEMS LOADED ", r, g, b)
	end)
end

local function time_to_ticks(t)
	return math.floor(0.5 + (t / globals.tickinterval()))
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local ccheck = function(val)
	for k, v in pairs(ui.get(dash.menu.options)) do
		if v == val then
			return true
		end
	end
	return false
end


for _, cid in ipairs({
	{
		"paint_ui", 0, function()
			if cur ~= "visuals" then
				ui.set_visible(dash.menu.label,false)
				ui.set_visible(dash.menu.color,false)
				ui.set_visible(dash.menu.notifications,false)
				ui.set_visible(dash.menu.options,false)
				ui.set_visible(dash.menu.rounding,false)
				ui.set_visible(dash.menu.size,false)
				ui.set_visible(dash.menu.glow,false)
				ui.set_visible(dash.menu.time,false)
				ui.set_visible(dash.menu.indicators,false)
				ui.set_visible(dash.menu.style,false)
			else
				ui.set_visible(dash.menu.label,true)
				ui.set_visible(dash.menu.color,true)
				ui.set_visible(dash.menu.notifications,true)
				ui.set_visible(dash.menu.indicators,true)
				ui.set_visible(dash.menu.style,false)
				if ui.get(dash.menu.notifications) then
					ui.set_visible(dash.menu.options,false)
					ui.set_visible(dash.menu.rounding,false)
					ui.set_visible(dash.menu.size,false)
					ui.set_visible(dash.menu.glow,false)
					ui.set_visible(dash.menu.time,false)
				else

				end
			end	
		end
		
	},
	{
		"paint", 0, function()
            local me = entity.get_local_player()
			if ui.get(dash.menu.notifications) then
				dash.notifications:render()
			end

			if ui.get(dash.menu.indicators) then
				dash.indicators:render()
			end	
            if me then
                dash.watermark:render()
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
			local r, g, b, a = ui.get(dash.menu.color)
			dash.notifications:new(string.format('fired at %s (%s) for %d dmg (chance=%d%%, bt=%2d, flags=%s)', string.lower(entity.get_player_name(e.target)), group, e.damage, math.floor(e.hit_chance + 0.5), time_to_ticks(e.backtrack), table.concat(flags)), r, g, b)
		end
	},
	{
		"aim_hit", 0 , function(e)
			local r, g, b = ui.get(dash.menu.color)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			dash.notifications:new(string.format('hit %s in the %s for %d damage (%d health remaining)', string.lower(entity.get_player_name(e.target)), group, e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b)
		end
	},
	{
		"aim_miss", 0 , function(e)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			dash.notifications:new(string.format('missed %s (%s) due to %s', string.lower(entity.get_player_name(e.target)), group, e.reason), 255, 120, 120)
		end
	},
	{
		"ui_callback", 0, function()
			dash.menu:initialize()
		end
	},
	{
		"round_start", 0, function()
			dash.notifications:clear()
		end
	},
	{
		"client_disconnect", 0, function()
			dash.notifications:clear()
		end
	},
	{
		"predict_command", 0, function()
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			dash.helpers.defensive = math.abs(tickbase - dash.helpers.checker)
			dash.helpers.checker = math.max(tickbase, dash.helpers.checker or 0)
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

-- misc shit

local miscref = {
	killsay = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF92BDFFkillsay"),

	legitness_key = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF92BDFFe-peek aa"),
	mindmgind = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF92BDFFmin dmg ind"),
    mindmgoption = ui.new_combobox("AA", "Anti-aimbot angles", "\aFF92BDFFstates", "constant", "on override")

} 


local function ballsack()
	if cur ~= "misc" then
		ui.set_visible(miscref.killsay, false)

		ui.set_visible(miscref.legitness_key, false)
		ui.set_visible(miscref.mindmgind, false)
		ui.set_visible(miscref.mindmgoption, false)
	else
		ui.set_visible(miscref.killsay, true)

		ui.set_visible(miscref.legitness_key, true)
		ui.set_visible(miscref.mindmgind, true)
		ui.set_visible(miscref.mindmgoption, true)
	end
end
client.set_event_callback("paint_ui", ballsack)
local function player_death(e)
    local killsay = {
        "U think u good? luckily im here",
        "youre value compared to me  is but a grain of sand",
        "all romanian(you) will die to me(boss)",
        "this isnt phasmaphobia: global offensive please dont speak",
        "mega bouse",
        "I guarntee youre loss forever and always",
        "𝕡𝕣𝕠𝕓𝕝𝕖𝕞?",
        "cope",
        " 格拉格拉 < you? 无功无过 < me B)",
        "in hvh war i will win",
        "below average performance",
        "SPEAK BULGARIAN? WILL TALK",
        "you are loss it is decided",
        "you do not perform this hvh",
        "qahahaha i am top of this region",
        "this weak snail is spoke of victory but is door unhinged to loss",
        "you do not have the impression of owning the performance-enhancing software known as Gamesense.pub",
        "how you will feel knowing im skeethaving and u will skeetless",
        "your mexican familia never make it out from trailer",
        "grub. you are foods, this meal of mine? worthless",
        "cant understand u. any noname translator?",
        "you waste aka fecal matter/shit(you)",
        "sorry for u loss, me always better like life",
        "better luck next round, oh wait i alr won BAHAHHA",
        "kekalaff u sucks",
        "when you spawn tell me why u die to me",
        "how hit chance in deagle? i sit.",
        "do i need to get an xray to shoot magnets into ur skull to find out the plan?",
        "shitting on your chest speedrun any% WR run",
        "smelly lapdog dreams of success in 1x1 but is handed 9 casualities",
        "dude where are my diamonds?",
        "QUABALABABABAB"
    }
    if ui.get(miscref.killsay) then
        local attacker_entindex = client.userid_to_entindex(e.attacker)
        local victim_entindex = client.userid_to_entindex(e.userid)
        if attacker_entindex ~= entity.get_local_player() then
            return
        end
        client.exec("say " .. killsay[math.random(1, #killsay)])
    end
  end

	local function dmg_ind()
		local x, y = client.screen_size()
		local thingy1 = ui.get(aa.mindmg[2])
		local thingy2 = ui.get(aa.mindmg[3])
		local thingy3 = ui.get(aa.mindmg2[1])
		if thingy1 and ui.get(miscref.mindmgoption) == "on override" and ui.get(miscref.mindmgind) then
			renderer.text(x / 2 + 2 , y / 2 - 15, 255, 255, 255, 255, "-", 0, thingy2)
		end
		if ui.get(miscref.mindmgind) and ui.get(miscref.mindmgoption) == "constant" and not thingy1 then
			renderer.text(x / 2 + 2 , y / 2 - 15, 255, 255, 255, 255, "-", 0, thingy3)
		end
		if thingy1 and ui.get(miscref.mindmgoption) == "constant" and ui.get(miscref.mindmgind) then
			renderer.text(x / 2 + 2, y / 2 - 15,255, 255, 255, 255, "-", 0, thingy2)
		end
	  end

	  local weaponn = entity.get_player_weapon()
    if ui.get(miscref.legitness_key) then
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


client.set_event_callback("paint", dmg_ind)
client.set_event_callback("player_death",player_death)
client.exec("playvol \"survival/buy_item_01.wav\" 1")