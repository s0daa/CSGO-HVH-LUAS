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
    local clantags = {"p", "pr", "pre", "prec", "preci", "precis", "precisi", "precisio", "precision", "precision  ", "precision", "precision", "precisi", "precisi", "precis", "preci", "prec", "pre" ,"pr","p"}
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

local contains = function(table, value)
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
    flags = ui.new_multiselect(tab, container, ui_tag('Information flags'), {'Desync Correction', 'Flick Correction', 'Player Velocity', 'Current resolved angle'}),
    clantag = ui.new_checkbox(tab, container, ui_tag('Clantag')),
    antiaim = {
        enable = ui.new_checkbox(tab2, container2, gradient_text(true, 108, 172, 156, 255, 88, 155, 222, 255, 'Anti-Aim'), true),
        preset = ui.new_combobox(tab2, container2, "Presets Enable", {"Builder", "Presets"}),
        presets = ui.new_combobox(tab2, container2, "Presets", {"Aggressive"}),
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
        }
    }
}

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

local newAngle = cycle[client.random_int(1, #cycle)]
local oldtime = globals.curtime()

local on_run = function(cmd)
    local curtime = globals.curtime()
    local players = entity.get_players(true)
    if not (players) then return end
    if (curtime - oldtime > 3) then
        for i=1, #players do
            local player = players[i]
            local vel = vector(entity.get_prop(player, 'm_vecVelocity'))
            local speed = math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z)
            if (speed < 1) then return end
            if (playersdata[player] ~= nil and playersdata[player].hit ~= nil and playersdata[player].angle1 ~= nil) then
                plist.set(player, 'Force body yaw', true)
                plist.set(player, "Force body yaw value", playersdata[player].angle1)
                plist.set(player, 'Override safe point', client.random_int(0, 1) == 0 and '-' or 'On')
            end
        end 
        oldtime = globals.curtime()
    end
end

local on_aim_hit = function(shot)
    if not (ui.get(interface.angles)) then return end
    local angle = math.floor(entity.get_prop(shot.target, 'm_flPoseParameter', 11) * 120 - 60)
    client.color_log(0, 255, 0, "[precision] - Inserting angle for " .. entity.get_player_name(shot.target) .. " - Angle: " .. angle)

    playersdata[shot.target] = {
        angle1 = angle, 
        hit = true,
        missedangle = nil
    }

    plist.set(shot.target, 'Force body yaw', false)
    plist.set(shot.target, 'Force body yaw value', 0)
    plist.set(shot.target, 'Override safe point', '-')
end

local on_aim_miss = function(shot)
    if (shot.reason ~= "resolver" or "?" or "unknown") then return end
    local angle = math.floor(entity.get_prop(shot.target, 'm_flPoseParameter', 11) * 120 - 60)

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

client.register_esp_flag('CYCLE', 255, 255, 0, function(e)
    if not (ui.get(interface.flags)) then return end

    return plist.get(e, 'Force body yaw value') ~= 0
end)

client.register_esp_flag('SAFE', 0, 255, 0, function(e)
    if not (ui.get(interface.flags)) then return end

    return plist.get(e, 'Override safe point') == 'On'
end)

client.register_esp_flag('velocity', 255, 255, 255, function(e)
    if not (ui.get(interface.flags) == "Player Velocity") then return end
    if not (ui.get(interface.extrap)) then return end

    local vel = vector(entity.get_prop(e, 'm_vecVelocity'))
    local speed = math.sqrt(vel.x*vel.x + vel.y*vel.y + vel.z*vel.z)
    local rounded = math.floor(speed + 0.5)

    return true, string.format('V:%s', rounded)
end)

client.register_esp_flag('desync', 255, 255, 255, function(e)
    if not (ui.get(interface.flags) == "Desync Correction") then return end

    local yaw = entity.get_prop(e, 'm_flPoseParameter', 11)
    local angle = math.floor(yaw * 120 - 60)

    return true, string.format('A:%s', angle)
end)

--#endregion

--#region Callbacks
local on_paint_ui = function()
    if not (ui.is_menu_open()) then return end
    SetTableVisibility({refs.pitch, refs.yawbase, refs.yaw[1], refs.yaw[2], refs.yawjitter[1], refs.yawjitter[2], refs.bodyyaw[1], refs.bodyyaw[2], refs.freestandingby, refs.fakeyawlim, refs.edgeyaw, refs.freestanding[1], refs.freestanding[2], refs.roll}, false)
    SetTableVisibility({interface.options, interface.fallback.enabled, interface.fallback.count, interface.extrap, interface.angles, interface.flags, interface.clantag}, ui.get(interface.enabled))

    if (ui.get(interface.antiaim.enable)) then 
        SetTableVisibility({interface.antiaim.preset, interface.antiaim.presets}, true)
        if (ui.get(interface.antiaim.preset) == "Presets" and ui.get(interface.antiaim.presets) and ui.get(interface.antiaim.enable)) then
            --hide builder
            SetTableVisibility({interface.antiaim.playerstates}, false)
            SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawvalstanding}, false)
            SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawvalmoving}, false)
            SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawvalair}, false)
            SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawvalaircrouch}, false)
        elseif (ui.get(interface.antiaim.preset) == "Builder") then
            SetTableVisibility({interface.antiaim.playerstates}, true)
            SetTableVisibility({interface.antiaim.presets}, false)
            --show builder
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
        SetTableVisibility({interface.antiaim.preset, interface.antiaim.presets}, false)
        SetTableVisibility({refs.pitch, refs.yawbase, refs.yaw[1], refs.yaw[2], refs.yawjitter[1], refs.yawjitter[2], refs.bodyyaw[1], refs.bodyyaw[2], refs.freestandingby, refs.fakeyawlim, refs.edgeyaw, refs.freestanding[1], refs.freestanding[2], refs.roll}, true)
        SetTableVisibility({interface.antiaim.playerstates}, false)
        SetTableVisibility({interface.antiaim.standing.pitch, interface.antiaim.standing.yawbase, interface.antiaim.standing.yawcombo, interface.antiaim.standing.yawslider, interface.antiaim.standing.yawjittercombo, interface.antiaim.standing.yawjitterslider, interface.antiaim.standing.bodyyawcombo, interface.antiaim.standing.fakeyawval}, false)
        SetTableVisibility({interface.antiaim.moving.pitch, interface.antiaim.moving.yawbase, interface.antiaim.moving.yawcombo, interface.antiaim.moving.yawslider, interface.antiaim.moving.yawjittercombo, interface.antiaim.moving.yawjitterslider, interface.antiaim.moving.bodyyawcombo, interface.antiaim.moving.fakeyawval}, false)
        SetTableVisibility({interface.antiaim.air.pitch, interface.antiaim.air.yawbase, interface.antiaim.air.yawcombo, interface.antiaim.air.yawslider, interface.antiaim.air.yawjittercombo, interface.antiaim.air.yawjitterslider, interface.antiaim.air.bodyyawcombo, interface.antiaim.air.fakeyawval}, false)
        SetTableVisibility({interface.antiaim.aircrouch.pitch, interface.antiaim.aircrouch.yawbase, interface.antiaim.aircrouch.yawcombo, interface.antiaim.aircrouch.yawslider, interface.antiaim.aircrouch.yawjittercombo, interface.antiaim.aircrouch.yawjitterslider, interface.antiaim.aircrouch.bodyyawcombo, interface.antiaim.aircrouch.fakeyawval}, false)
    end
end

local on_paint = function() 
    if (ui.get(interface.clantag)) then
        clantagfunction()
    end
end

local on_setup = function() 
    if not (ui.get(refs.enablebutton) and ui.get(interface.antiaim.enable)) then return end

    local velocity = string.format('%.2f', vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')):length2d())
    if (ui.get(interface.antiaim.preset) == "Presets") then
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
        end
    elseif (ui.get(interface.antiaim.preset) == "Builder") then
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

local handle_event_callback = function(self)
    local handle = ui.get(self) and client.set_event_callback or client.unset_event_callback
    
    handle('run_command', on_run)
    handle('aim_miss', on_aim_miss)
    handle('aim_hit', on_aim_hit)
end

client.set_event_callback('shutdown', function() 
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
client.set_event_callback("paint", on_paint)
client.set_event_callback('paint_ui', on_paint_ui)
client.set_event_callback('setup_command', on_setup)
--#endregion

ui.set_callback(interface.enabled, handle_event_callback)
handle_event_callback(interface.enabled)