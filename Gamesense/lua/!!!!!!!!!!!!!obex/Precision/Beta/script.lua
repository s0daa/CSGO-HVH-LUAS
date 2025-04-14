-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local username = _G.obex_name == nil and 'Precision' or _G.obex_name
local build = _G.obex_build == nil and 'Source' or _G.obex_build
local ffi = require 'ffi'
local bit = require 'bit'
local vector = require 'vector'
local surface = require 'gamesense/surface'
local easing = require 'gamesense/easing'
local antiaim_funcs = require 'gamesense/antiaim_funcs'

--#region refs 
local panorama = panorama.open()
local GameStateAPI = panorama.GameStateAPI
local refs = { 
    enablebutton = ui.reference("AA","Anti-aimbot angles","Enabled"),
    pitch = ui.reference("AA","Anti-aimbot angles","Pitch"),
    yawbase = ui.reference("AA","Anti-aimbot angles","Yaw base"),
    yaw = {ui.reference("AA","Anti-aimbot angles","Yaw")},
    yawjitter = {ui.reference("AA","Anti-aimbot angles","Yaw jitter")},
    bodyyaw = {ui.reference("AA","Anti-aimbot angles","Body yaw")},
    freestandingby = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw"),
    fakeyawlim = ui.reference("AA","Anti-aimbot angles","Fake yaw limit"),
    edgeyaw = ui.reference("AA","Anti-aimbot angles","Edge yaw"),
    freestanding = {ui.reference("AA","Anti-aimbot angles","Freestanding")},
    roll = ui.reference("AA","Anti-aimbot angles", "Roll"),
    slowwalk = {ui.reference("AA", "Other", "Slow motion")},
    fakeduck = ui.reference("Rage", "Other", "Duck peek assist"),
    onshotantiaim = {ui.reference("AA","Other","On shot anti-aim")},
    fakelag = ui.reference("AA", "Fake lag", "Amount"),
    fakelaglim = ui.reference("AA", "Fake lag", "Limit"),
    fakelagvar = ui.reference("AA", "Fake lag", "Variance"),
}
--#endregion

--#region other functions
local toint = function(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

local getState = function()
    return entity.get_prop(entity.get_local_player(), "m_fFlags")
end

local SetTableVisibility = function(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

local clantagfunction = function()
    local duration = 25
    local clantags = {"p", "pr", "pre", "prec", "preci", "precis", "precisi", "precisio", "precision", "precision  beta", "  precision", "precision", "precisi", "precisi", "precis", "preci", "prec", "pre" ,"pr","p"}
    local clantag_prev
    local cur = math.floor(globals.tickcount() / duration) % #clantags
    local clantag = clantags[cur+1]

    if clantag ~= clantag_prev then
        clantag_prev = clantag
        client.set_clan_tag(clantag)
    else
        client.set_clan_tag("")
    end
end

local gradient_text = function(yes, r1, g1, b1, a1, r2, g2, b2, a2, text)
	local output = ''

	local len = #text-1

	local rinc = (r2 - r1) / len
	local ginc = (g2 - g1) / len
	local binc = (b2 - b1) / len
	local ainc = (a2 - a1) / len

	for i = 1, len + 1 do
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

		r1 = r1 + rinc
		g1 = g1 + ginc
		b1 = b1 + binc
		a1 = a1 + ainc
	end

    if (yes == false) then
	    return output
    else
        return '\a808080FF[~] '..output
    end
end

local contains = function(table, value)
    for _, v in ipairs(ui.get(table)) do
        if v == value then
            return true
        end
    end
    return false
end

local ui_tag = function(text)
    return '\a808080FF[~] \aFFFFFFFF'..text
end

--#endregion

--#region Menu Elements
local tab, container = 'Rage', 'Other'
local tab2, container2 = 'AA', 'Anti-aimbot angles'
local interface = {
    enabled = ui.new_checkbox(tab, container, gradient_text(true, 108, 172, 156, 255, 88, 155, 222, 255, 'Precision'), true),
    options = ui.new_multiselect(tab, container, ui_tag('Corrections'), {'Desync correction', --[['Roll correction',]] 'Flick correction'}),
    extrap = ui.new_checkbox(tab, container, ui_tag('Fix extrapolation')),
    angles = ui.new_checkbox(tab, container, ui_tag('Log enemy angles')),
    fallback = {
        enabled = ui.new_checkbox(tab, container, ui_tag('Fallback on miss')),
        count = ui.new_slider(tab, container, '\n', 0, 6, 1, true),
    },
    flag = ui.new_checkbox(tab, container, ui_tag('Player Flags')),
    flags = ui.new_multiselect(tab, container, ui_tag('Information flags'), {'Desync Correction', 'Safe-Point', 'Player Velocity', 'Current resolved angle'}),
    clantag = ui.new_checkbox(tab, container, ui_tag('Clantag')),
    killsay = ui.new_checkbox(tab, container, ui_tag('Killsay')),
    --visualsenable = ui.new_checkbox(tab, container, ui_tag('Enable Visuals')),
    --watermark = ui.new_checkbox(tab, container, ui_tag('Watermark')),
    --indicator = ui.new_checkbox(tab, container, ui_tag('Precision Indicator')),
    antiaim = {
        enable = ui.new_checkbox(tab2, container2, gradient_text(true, 108, 172, 156, 255, 88, 155, 222, 255, 'Anti-Aim'), true),
        antibrute = ui.new_checkbox(tab2, container2, ui_tag('Anti-bruteforce')),
        preset = ui.new_combobox(tab2, container2, "Presets Enable", {"Builder", "Presets"}),
        presets = ui.new_combobox(tab2, container2, "Presets", {"Aggressive", "Safe"}),
        playerstates = ui.new_combobox(tab2, container2, "Conditions", {"Standing", "Moving", "In-Air", "In-Air Crouch"}),
        standing = {
            pitch = ui.new_combobox(tab2, container2, "[S] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
            yawbase = ui.new_combobox(tab2, container2, "[S] Yaw Base", {"Local view", "At targets"}),
            yawcombo = ui.new_combobox(tab2, container2, "[S] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
            yawslider = ui.new_slider(tab2, container2, "Yaw", -180, 180, 0, true, "°"),
            yawjittercombo = ui.new_combobox(tab2, container2, "[S] Yaw Jitter", {"Off", "Offset", "Center", "Random"}),
            yawjitterslider = ui.new_slider(tab2, container2, "Yaw jitter", -180, 180, 0, true, "°"),
            bodyyawcombo = ui.new_combobox(tab2, container2, "[S] Body Yaw", {"Off", "Opposite", "Jitter", "Static"}),
            fakeyawvalstanding = ui.new_slider(tab2, container2, "Fake yaw limit", 0, 60, 60, true),
        },
        moving = {
            pitch = ui.new_combobox(tab2, container2, "[M] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
            yawbase = ui.new_combobox(tab2, container2, "[M] Yaw Base", {"Local view", "At targets"}),
            yawcombo = ui.new_combobox(tab2, container2, "[M] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
            yawslider = ui.new_slider(tab2, container2, "Yaw", -180, 180, 0, true, "°"),
            yawjittercombo = ui.new_combobox(tab2, container2, "[M] Yaw Jitter", {"Off", "Offset", "Center", "Random"}),
            yawjitterslider = ui.new_slider(tab2, container2, "Yaw jitter", -180, 180, 0, true, "°"),
            bodyyawcombo = ui.new_combobox(tab2, container2, "[M] Body Yaw", {"Off", "Opposite", "Jitter", "Static"}),
            fakeyawvalmoving = ui.new_slider(tab2, container2, "Fake yaw limit", 0, 60, 60, true),
        },
        air = {
            pitch = ui.new_combobox(tab2, container2, "[A] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
            yawbase = ui.new_combobox(tab2, container2, "[A] Yaw Base", {"Local view", "At targets"}),
            yawcombo = ui.new_combobox(tab2, container2, "[A] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
            yawslider = ui.new_slider(tab2, container2, "Yaw", -180, 180, 0, true, "°"),
            yawjittercombo = ui.new_combobox(tab2, container2, "[A] Yaw Jitter", {"Off", "Offset", "Center", "Random"}),
            yawjitterslider = ui.new_slider(tab2, container2, "Yaw jitter", -180, 180, 0, true, "°"),
            bodyyawcombo = ui.new_combobox(tab2, container2, "[A] Body Yaw", {"Off", "Opposite", "Jitter", "Static"}),
            fakeyawvalair = ui.new_slider(tab2, container2, "Fake yaw limit", 0, 60, 60, true),
        },
        aircrouch = {
            pitch = ui.new_combobox(tab2, container2, "[A+] Pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
            yawbase = ui.new_combobox(tab2, container2, "[A+] Yaw Base", {"Local view", "At targets"}),
            yawcombo = ui.new_combobox(tab2, container2, "[A+] Yaw", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
            yawslider = ui.new_slider(tab2, container2, "Yaw", -180, 180, 0, true, "°"),
            yawjittercombo = ui.new_combobox(tab2, container2, "[A+] Yaw Jitter", {"Off", "Offset", "Center", "Random"}),
            yawjitterslider = ui.new_slider(tab2, container2, "Yaw jitter", -180, 180, 0, true, "°"),
            bodyyawcombo = ui.new_combobox(tab2, container2, "[A+] Body Yaw", {"Off", "Opposite", "Jitter", "Static"}),
            fakeyawvalaircrouch = ui.new_slider(tab2, container2, "Fake yaw limit", 0, 60, 60, true),
        },
        freestand = ui.new_checkbox("AA", "Anti-aimbot angles", "Freestanding"),
        FreeStandOnKey = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestand Key", true),
    }
}
--#endregion

--#region nasty 
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
--#endregion

--#region Resolver Stuff
local cycle = {
    15,
    51,
    38,
    -15,
    -51,
    -38,
}

local misses = { 

}

local playersdata = {

}

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

local newAngle = cycle[client.random_int(1, #cycle)]
local oldtime = globals.curtime()

local on_run = function(cmd)
    if (ui.get(interface.antiaim.freestand) and ui.get(interface.antiaim.FreeStandOnKey) and ui.get(refs.enablebutton) and ui.get(interface.antiaim.enable)) then
        ui.set(refs.freestanding[1], {"Default"})
    end
    if not (ui.get(interface.antiaim.FreeStandOnKey) and ui.get(refs.enablebutton) and ui.get(interface.antiaim.enable)) then
        ui.set(refs.freestanding[1], {})
    end
    local curtime = globals.curtime()
    local players = entity.get_players(true)
    if not (players) then return end
    if (curtime - oldtime > 3) then
        for i=1, #players do
            local player = players[i]
            local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(player)
            local is_bot = GameStateAPI.IsFakePlayer(xuid)
            if (is_bot) then return end

            local vel = vector(entity.get_prop(player, 'm_vecVelocity'))
            local speed = math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z)
            if (speed < 1) then return end
            if (playersdata[player] ~= nil and playersdata[player].hit ~= nil and playersdata[player].angle1 ~= nil) then
                plist.set(player, 'Force body yaw', true)
                plist.set(player, "Force body yaw value", normalize_yaw(playersdata[player].angle1))
                plist.set(player, 'Override safe point', client.random_int(0, 1) == 0 and '-' or 'On')
            elseif (playersdata[player] == nil or playersdata[player].hit == nil or playersdata[player].angle1 == nil) then
                plist.set(player, 'Force body yaw', true)
                plist.set(player, "Force body yaw value", normalize_yaw(newAngle))
                plist.set(player, 'Override safe point', client.random_int(0, 1) == 0 and '-' or 'On')
            end
        end 
        oldtime = globals.curtime()
    end
end

local on_aim_hit = function(shot)
    if not (ui.get(interface.angles)) then return end
    local is_bot = GameStateAPI.IsFakePlayer(GameStateAPI.GetPlayerXuidStringFromEntIndex(shot.target))
    if (is_bot) then return end
    local angle = normalize_yaw(math.floor(entity.get_prop(shot.target, 'm_flPoseParameter', 11) * 120 - 60))
    client.color_log(0, 255, 0, "[precision] - Inserting angle for " .. entity.get_player_name(shot.target) .. " - Angle: " .. angle)

    playersdata[shot.target] = {
        angle1 = angle, 
        hit = true
    }

    plist.set(shot.target, 'Force body yaw', false)
    plist.set(shot.target, 'Force body yaw value', 0)
    plist.set(shot.target, 'Override safe point', '-')
end

local on_aim_miss = function(shot)
    local is_bot = GameStateAPI.IsFakePlayer(GameStateAPI.GetPlayerXuidStringFromEntIndex(shot.target))
    if (shot.reason ~= "resolver" or "?" or "unknown") then return end
    if (is_bot) then return end
    local angle = math.floor(entity.get_prop(shot.target, 'm_flPoseParameter', 11) * 120 - 60)
    playersdata[shot.taret] = {hit = false, missedangle = angle}
    client.error_log("[precision] - Missed angle: " .. angle)
    newAngle = cycle[client.random_int(1, #cycle)]

    shot.reason = 'spread' or 'prediction' or 'unregistered shot'
    plist.set(shot.target, 'Force body yaw', true)
    if (ui.get(interface.angles)) then
        plist.set(shot.target, 'Force body yaw value', playersdata[shot.target].angle1)
    else 
        plist.set(shot.target, 'Force body yaw value', client.random_int(0, 1) == 1 and angle*-1 or cycle[client.random_int(1, #cycle)])
    end
    plist.set(shot.target, 'Override safe point', 'On')
end

client.register_esp_flag('SAFE', 0, 255, 0, function(e)
    if not (ui.get(interface.flag) and contains(interface.flags, "Safe-Point") == true) then return end
    return plist.get(e, 'Override safe point') == 'On'
end)

client.register_esp_flag('velocity', 255, 255, 255, function(e)
    if not (ui.get(interface.flag) and contains(interface.flags, "Player Velocity") == true) then return end
    local vel = vector(entity.get_prop(e, 'm_vecVelocity'))
    local rounded = math.floor(math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z) + 0.5)

    return true, string.format('V:%s', rounded)
end)

client.register_esp_flag('desync', 255, 255, 255, function(e)
    if not (ui.get(interface.flag) and contains(interface.flags, "Desync Correction") == true) then return end
    return true, string.format('A:%s', math.floor(entity.get_prop(e, 'm_flPoseParameter', 11) * 120 - 60))
end)

--#endregion

--#region Callbacks
local on_paint_ui = function()
    if not (ui.is_menu_open()) then return end
    SetTableVisibility({refs.pitch, refs.yawbase, refs.yaw[1], refs.yaw[2], refs.yawjitter[1], refs.yawjitter[2], refs.bodyyaw[1], refs.bodyyaw[2], refs.freestandingby, refs.fakeyawlim, refs.edgeyaw, refs.freestanding[1], refs.freestanding[2], refs.roll}, false)
    SetTableVisibility({interface.options, interface.fallback.enabled, interface.fallback.count, interface.extrap, interface.angles, interface.flags, interface.flag, interface.clantag, interface.killsay}--[[,]] --[[interface.visualsenable, interface.watermark}]], ui.get(interface.enabled))

    if (ui.get(interface.antiaim.enable)) then 
        SetTableVisibility({interface.antiaim.preset, interface.antiaim.presets, interface.antiaim.freestand, interface.antiaim.FreeStandOnKey}, true)
        if (ui.get(interface.antiaim.preset) == "Presets" and ui.get(interface.antiaim.presets) and ui.get(interface.antiaim.enable)) then
            SetTableVisibility({interface.antiaim.playerstates}, false)
            SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
            SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
            SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
            SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)
        elseif (ui.get(interface.antiaim.preset) == "Builder") then
            SetTableVisibility({interface.antiaim.playerstates}, true)
            SetTableVisibility({interface.antiaim.presets}, false)
            if (ui.get(interface.antiaim.playerstates) == "Standing" and ui.get(interface.antiaim.enable)) then
                SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, true)
                SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
                SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
                SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)
            elseif (ui.get(interface.antiaim.playerstates) == "Moving" and ui.get(interface.antiaim.enable)) then
                SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
                SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, true)
                SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
                SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)
            elseif (ui.get(interface.antiaim.playerstates) == "In-Air" and ui.get(interface.antiaim.enable)) then
                SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
                SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
                SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, true)
                SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)         
            elseif (ui.get(interface.antiaim.playerstates) == "In-Air Crouch" and ui.get(interface.antiaim.enable)) then
                SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
                SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
                SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
                SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, true)
            end 
        end
    else 
        SetTableVisibility({refs.freestanding[1], refs.freestanding[2]}, true)
        SetTableVisibility({interface.antiaim.preset, interface.antiaim.presets, interface.antiaim.freestand, interface.antiaim.FreeStandOnKey}, false)
        SetTableVisibility({interface.antiaim.playerstates}, false)
        SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
        SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
        SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
        SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)
    end
end

local on_bullet = function(e)
    if ui.get(interface.antiaim.antibrute) then
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
            client.log("Switched due to Anti-bruteforce")
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
end

local brute_death = function(e)
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

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end


local on_setup = function() 
    if not (ui.get(refs.enablebutton) and ui.get(interface.antiaim.enable)) then return end

    if (ui.get(interface.clantag) and (entity.is_alive(entity.get_local_player()))) then
        clantagfunction()
    else
        client.set_clan_tag("")
    end

    local velocity = string.format('%.2f', vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')):length2d())
    if (ui.get(interface.antiaim.preset) == "Presets") then
        if not (ui.get(interface.antiaim.FreeStandOnKey)) then
            ui.set(refs.pitch, "Minimal")
            ui.set(refs.yawbase, "At targets")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], "0")
            ui.set(refs.yawjitter[1], "Center")
            ui.set(refs.yawjitter[2], "20")
            ui.set(refs.bodyyaw[1], "Opposite")
            ui.set(refs.freestandingby, true)
            ui.set(refs.fakeyawlim, "58")
        end
        if (ui.get(interface.antiaim.presets) == "Aggressive") then
            if (getState() == 257 and toint(velocity) < 5) then -- standing
                ui.set(refs.pitch, "Default")
                ui.set(refs.yawbase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], "3")
                ui.set(refs.yawjitter[1], "Center")
                ui.set(refs.yawjitter[2], "0")
                ui.set(refs.bodyyaw[1], "Static")
                ui.set(refs.freestandingby, true)
                ui.set(refs.fakeyawlim, "53")
            elseif (getState() == 263) then -- crouching
                ui.set(refs.pitch, "Default")
                ui.set(refs.yawbase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], "3")
                ui.set(refs.yawjitter[1], "Center")
                ui.set(refs.yawjitter[2], "1")
                ui.set(refs.bodyyaw[1], "Jitter")
                ui.set(refs.freestandingby, true)
                ui.set(refs.fakeyawlim, "53")
            elseif (toint(velocity) < 250 and getState() == 257) then -- moving
                ui.set(refs.pitch, "Default")
                ui.set(refs.yawbase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], "0")
                ui.set(refs.yawjitter[1], "Center")
                ui.set(refs.yawjitter[2], "45")
                ui.set(refs.bodyyaw[1], "Jitter")
                ui.set(refs.freestandingby, false)
                ui.set(refs.fakeyawlim, "60")
            elseif (getState() == 256) then -- in air
                ui.set(refs.pitch, "Default")
                ui.set(refs.yawbase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], "-20")
                ui.set(refs.yawjitter[1], "Offset")
                ui.set(refs.yawjitter[2], "35")
                ui.set(refs.bodyyaw[1], "Jitter")
                ui.set(refs.freestandingby, false)
                ui.set(refs.fakeyawlim, "60")
            elseif (getState() == 262) then -- crouch in air
                ui.set(refs.pitch, "Default")
                ui.set(refs.yawbase, "At targets")
                ui.set(refs.yaw[1], "180")
                ui.set(refs.yaw[2], "-20")
                ui.set(refs.yawjitter[1], "Offset")
                ui.set(refs.yawjitter[2], "52")
                ui.set(refs.bodyyaw[1], "Jitter")
                ui.set(refs.freestandingby, false)
                ui.set(refs.fakeyawlim, "60")
            end
        elseif (ui.get(interface.antiaim.presets) == "Safe") then 

        end
    elseif (ui.get(interface.antiaim.preset) == "Builder") then
        if not (ui.get(interface.antiaim.FreeStandOnKey)) then
            ui.set(refs.pitch, "Minimal")
            ui.set(refs.yawbase, "At targets")
            ui.set(refs.yaw[1], "180")
            ui.set(refs.yaw[2], "0")
            ui.set(refs.yawjitter[1], "Center")
            ui.set(refs.yawjitter[2], "20")
            ui.set(refs.bodyyaw[1], "Opposite")
            ui.set(refs.freestandingby, true)
            ui.set(refs.fakeyawlim, "58")
        end
        if (getState() == 257 and toint(velocity) < 5) then
            ui.set(refs.pitch, ui.get(interface.antiaim.standing.pitch))
            ui.set(refs.yawbase, ui.get(interface.antiaim.standing.yawbase))
            ui.set(refs.yaw[1], ui.get(interface.antiaim.standing.yawcombo))
            ui.set(refs.yaw[2], ui.get(interface.antiaim.standing.yawslider))
            ui.set(refs.yawjitter[1], ui.get(interface.antiaim.standing.yawjittercombo))
            ui.set(refs.yawjitter[2], ui.get(interface.antiaim.standing.yawjitterslider))
            ui.set(refs.bodyyaw[1], ui.get(interface.antiaim.standing.bodyyawcombo))
            ui.set(refs.fakeyawlim, ui.get(interface.antiaim.standing.fakeyawvalstanding))
        elseif (toint(velocity) < 250 and getState() == 257) then
            ui.set(refs.pitch, ui.get(interface.antiaim.moving.pitch))
            ui.set(refs.yawbase, ui.get(interface.antiaim.moving.yawbase))
            ui.set(refs.yaw[1], ui.get(interface.antiaim.moving.yawcombo))
            ui.set(refs.yaw[2], ui.get(interface.antiaim.moving.yawslider))
            ui.set(refs.yawjitter[1], ui.get(interface.antiaim.moving.yawjittercombo))
            ui.set(refs.yawjitter[2], ui.get(interface.antiaim.moving.yawjitterslider))
            ui.set(refs.bodyyaw[1], ui.get(interface.antiaim.moving.bodyyawcombo))
            ui.set(refs.fakeyawlim, ui.get(interface.antiaim.moving.fakeyawvalmoving))
        elseif (getState() == 256) then
            ui.set(refs.pitch, ui.get(interface.antiaim.air.pitch))
            ui.set(refs.yawbase, ui.get(interface.antiaim.air.yawbase))
            ui.set(refs.yaw[1], ui.get(interface.antiaim.air.yawcombo))
            ui.set(refs.yaw[2], ui.get(interface.antiaim.air.yawslider))
            ui.set(refs.yawjitter[1], ui.get(interface.antiaim.air.yawjittercombo))
            ui.set(refs.yawjitter[2], ui.get(interface.antiaim.air.yawjitterslider))
            ui.set(refs.bodyyaw[1], ui.get(interface.antiaim.air.bodyyawcombo))
            ui.set(refs.fakeyawlim, ui.get(interface.antiaim.air.fakeyawvalair))
        elseif (getState() == 262) then
            ui.set(refs.pitch, ui.get(interface.antiaim.aircrouch.pitch))
            ui.set(refs.yawbase, ui.get(interface.antiaim.aircrouch.yawbase))
            ui.set(refs.yaw[1], ui.get(interface.antiaim.aircrouch.yawcombo))
            ui.set(refs.yaw[2], ui.get(interface.antiaim.aircrouch.yawslider))
            ui.set(refs.yawjitter[1], ui.get(interface.antiaim.aircrouch.yawjittercombo))
            ui.set(refs.yawjitter[2], ui.get(interface.antiaim.aircrouch.yawjitterslider))
            ui.set(refs.bodyyaw[1], ui.get(interface.antiaim.aircrouch.bodyyawcombo))
            ui.set(refs.fakeyawlim, ui.get(interface.antiaim.aircrouch.fakeyawvalaircrouch))
        end
    end 
end

local on_player_death = function(e) 
    if (ui.get(interface.antiaim.antibrute)) then
        brute_death(e)
        if client.userid_to_entindex(e.userid) == entity.get_local_player() then
            client.log("Reset data due to death")
            brute.reset()
        end
    end

    local messages = {
        "headshot featuring precision.lua",
        "precision.lua > all",
        "precision.lua owns me and all",
        "precisionlua.sellix.io",
        "get good, get precision",
        "precision-less? why?",
        "discord.gg/precision",
        "precision.lua best lua",
        "this loss ft precision.lua",
        "1",
        "precision.lua, buy or die",
        "precision resolver > all",
        "imagine being precision-less"
    }

    if (ui.get(interface.killsay)) then
        local vic = e.userid
        local vicent = client.userid_to_entindex(vic)
        local attk = e.attacker
        local attkent = client.userid_to_entindex(attk)

        local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(vicent)
        local is_bot = GameStateAPI.IsFakePlayer(xuid)
        if (is_bot) then return end

        if (vic == nil or attk == nil) then return end
        if (vicent == attkent or attkent ~= entity.get_local_player()) then return end
        client.exec("say " .. messages[client.random_int(1, #messages)])
    end
end
--#endregion

local handle_event_callback = function(self)
    local handle = ui.get(self) and client.set_event_callback or client.unset_event_callback
    handle('bullet_impact', on_bullet)
    handle('run_command', on_run)
    handle('player_death', on_player_death)
    handle('aim_miss', on_aim_miss)
    handle('aim_hit', on_aim_hit)
end

client.set_event_callback('shutdown', function() 
    SetTableVisibility({refs.pitch, refs.yawbase, refs.yaw[1], refs.yaw[2], refs.yawjitter[1], refs.yawjitter[2], refs.bodyyaw[1], refs.bodyyaw[2], refs.freestandingby, refs.fakeyawlim, refs.edgeyaw, refs.freestanding[1], refs.freestanding[2], refs.roll}, true)
    ui.set(refs.pitch, "Off")
    ui.set(refs.yawbase, "Local View")
    ui.set(refs.yaw[1], "Off")
    ui.set(refs.yaw[2], 0)
    ui.set(refs.yawjitter[1], "Off")
    ui.set(refs.yawjitter[2], 0)
    ui.set(refs.bodyyaw[1], "Off")
    ui.set(refs.bodyyaw[2], 0)
    ui.set(refs.fakeyawlim, 60)
    client.set_clan_tag("")
end)

client.set_event_callback('paint_ui', on_paint_ui)
client.set_event_callback('setup_command', on_setup)
--#endregion

ui.set_callback(interface.enabled, handle_event_callback)
handle_event_callback(interface.enabled)