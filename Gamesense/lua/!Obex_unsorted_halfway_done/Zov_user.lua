-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require('vector')
local http = require('gamesense/http')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local gamesense_entity = require('gamesense/entity')
local images = require('gamesense/images')

local anti_aim_pressed = true
local visuals_pressed = false
local miscellaneous_pressed = false

local last_press = 0
local direction = 0

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'Source', discord = ''}

local function contains(source, target)
	for id, name in pairs(ui.get(source)) do
		if name == target then
			return true
		end
	end

	return false
end

local m_iSide = 0
local prev_side = 0
canbepressed = true 
time = globals.realtime()
function manualaa()
    canbepressed = time+0.1 < globals.realtime()
    if ui.get(ManualLeft) and canbepressed then
        m_iSide = 1   
        if prev_side == m_iSide then
            m_iSide = 0
        end
        time = globals.realtime()
    end
    if ui.get(ManualRight) and canbepressed then
        m_iSide = 2
        if prev_side == m_iSide then
            m_iSide = 0
        end
        time = globals.realtime()
    end
    if ui.get(ManualForward) and canbepressed then
        m_iSide = 3
        if prev_side == m_iSide then
            m_iSide = 0
        end
        time = globals.realtime()
    end

    prev_side = m_iSide
    
    if m_iSide == 1 then return 1 end 
    if m_iSide == 2 then return 2 end 
    if m_iSide == 3 then return 3 end
    if m_iSide == 0 then return 0 end
end

local settings = {}
local anti_aim_settings = {}
local anti_aim_states = {'Global', 'Standing', 'Moving', 'Slow walking', 'Crouching', 'In air', 'In air & crouching', 'On use'}

GameSzensze = {
    ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
    {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
}
references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

local reference = {
    minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
    minimum_damage_override = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}


local ref = {
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	quickpeek = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding', 'Default') },
	os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') },
	fakelag = { ui.reference('AA', 'Fake lag', 'Enabled') },
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
}

OverrideSkeet = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF Enable ZOV")
Tabs = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF Tabs",{"Anti-Aim","Visuals", "Misc", "Config"})


local menu = {
    console = ui.new_checkbox("AA", "Anti-aimbot angles", "print logs to console"),
    color_label = ui.new_label("AA", "Anti-aimbot angles", "accent color"),
    color = ui.new_color_picker("AA", "Anti-aimbot angles", "accent")
}


BodyYawOnE = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF - Body Yaw On Use")
Builder = {}
Builder.Conditions = {"Global","Stand","Slow","Move","Duck","Air","Air+"}
ManualLeft = ui.new_hotkey('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Manual Left")
ManualRight = ui.new_hotkey('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Manual Right")
ManualForward = ui.new_hotkey('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Manual Forward")
Freestand = ui.new_hotkey('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Freestand")
Builder.ConditionSelect = ui.new_combobox('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Condition", Builder.Conditions)
Hitlogs = ui.new_multiselect('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF Hitlogs", {"Hit","Miss"})
Windows = ui.new_multiselect('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF Windows", {"Min damage indicator"})
kibit = ui.new_checkbox('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF - Kibit")
Indicators = ui.new_checkbox('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF Other")
indicators_color = ui.new_color_picker('AA', 'Anti-aimbot angles', "".."\aFF5F5FFFZ".."\aFFFFFFFF)Other Color", 255, 95, 95, 255)
AvoidBack = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF - Avoid Backstab")
ForceDefense = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF - Force Defense In Air")
ForceDefenseKey = ui.new_hotkey("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF - Force Defense on Key")
settingsindicators = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aFF5F5FFFZ\aFFFFFFFF - \aFFFFFFFFIndicators')
settingsindicators_color = ui.new_color_picker('AA', 'Anti-aimbot angles', '\nIndicators color', 255, 95, 95, 255)
settingsminimum_damage_override_indicator = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aFF5F5FFFZ\aFFFFFFFF - \aFFFFFFC8Minimum damage override indicator'); ui.set_visible(settingsminimum_damage_override_indicator, false)

local function rotate_point(x, y, rot, size)
	return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

settingsdisableshadows = ui.new_checkbox('AA', 'Anti-aimbot angles', '\aFF5F5FFFZ\aFFFFFFFF - \aFFFFFFFFDisable shadows'); ui.set_visible(settingsdisableshadows, true)

local function disableshadows()
    if ui.get(settingsdisableshadows) then
        cvar.cl_csm_shadows:set_int(0)
    else
        cvar.cl_csm_shadows:set_int(1)
    end
end

ui.set_callback(settingsdisableshadows, disableshadows)

local function get_mode(e)
    local lp = entity.get_local_player()
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1 and e.in_jump == 0
    local not_moving = velocity < 2

    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')
    
    if not on_ground then
        return (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) and 7 or 6
    else
        if (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
            return 5 
        elseif not_moving then
            return 2
        elseif not not_moving then
            if slowwalk_key then
                return 3
            else
                return 4
            end
        end
    end
end

function clamp(v,min,max)
    if v > max then return max end
    if v < min then return min end
    return v
end

ShortCuts = {"Global","Stand","Slow","Move","Duck","Air","Air+"}

for i = 1, #Builder.Conditions do
    if Builder[i] == nil then Builder[i] = {} end 
    Builder[i]["Enable"] = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF Enable "..Builder.Conditions[i])
    Builder[i]["AllowFreestand"] = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF Allow Freestand "..Builder.Conditions[i])
    Builder[i]["Pitch"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Pitch",{'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom','\aFF5F5FFF Exploit'})
    Builder[i]["PitchVal"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Pitch",-89,89,0)
    Builder[i]["Yaw Base"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw Base",{'Local view', 'At targets'})
    Builder[i]["Yaw"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw",{'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'})
    Builder[i]["YawOff"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw Offset",{"Default","Switch Between"})
    Builder[i]["YawOffVal"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw Offset Right", -180, 180, 0)
    Builder[i]["YawOffInv"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw Offset Left", -180, 180, 0)
    Builder[i]["YawOffHz"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Switches/sec", 1, 360, 144)
    Builder[i]["YawMod"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Yaw Modifier",{ 'Off', 'Offset', 'Center', 'Random', 'Skitter', "X-Way"})
    Builder[i]["ModAngle"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ]  Modifier Right", -180, 180, 0)
    Builder[i]["ModAngleInv"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Modifier Left", -180, 180, 0)
    Builder[i]["Ways"] = ui.new_slider("AA", "Anti-aimbot angles", "["..ShortCuts[i].."] Ways",1,5)

    Builder[i]["WayHz"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF)".." [ "..ShortCuts[i].." ] Way Switches/sec",1,360,144)
    for xi = 1, 5 do
        Builder[i]["Way"..xi] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF [ "..ShortCuts[i].." ] "..xi.."Way", -180, 180, 0)
    end

    Builder[i]["BodyYaw"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Body Yaw",{ 'Off', 'Opposite', 'Jitter', 'Static'})
    Builder[i]["BodyYawC"] = ui.new_combobox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Body Limit",{ "Static","Jitter L-R"})
    Builder[i]["BYawOffVal"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Body Yaw Right", -180, 180, 0)
    Builder[i]["BYawOffInv"] = ui.new_slider("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Body Yaw Left", -180, 180, 0)
    Builder[i]["FreestandBody"] = ui.new_checkbox("AA", "Anti-aimbot angles", "".."\aFF5F5FFFZ".."\aFFFFFFFF".." [ "..ShortCuts[i].." ] Freestand")
end

Vis = ui.set_visible
visibility = function()
    Vis(Tabs,ui.get(OverrideSkeet))
    Vis(Windows,ui.get(Tabs) == "Visuals")
    Vis(Hitlogs,ui.get(Tabs) == "Visuals")
    Vis(Indicators,false)--ui.get(Tabs) == "Visuals")
	Vis(settingsindicators,ui.get(Tabs) == "Visuals")
	Vis(settingsindicators_color,ui.get(Tabs) == "Visuals")
    Vis(indicators_color,false)--ui.get(Tabs) == "Visuals")
	Vis(kibit,ui.get(Tabs) == "Visuals")
    Vis(OverrideSkeet,ui.get(Tabs) == "Anti-Aim")
    Vis(ManualLeft,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet) )
    Vis(AvoidBack,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) ) 
    Vis(clantag,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(fastladder,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(settingsdisableshadows,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ForceDefense,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ForceDefenseKey,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ManualRight,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(ManualForward,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(Freestand,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet) )
    Vis(BodyYawOnE,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(Builder.ConditionSelect,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(Export,ui.get(Tabs) == "Config")
    Vis(Import,ui.get(Tabs) == "Config")


    for i = 1, #GameSzensze do 
        if type(GameSzensze[i]) == "table" then 
            for xdskeetshit = 1, #GameSzensze[i] do 
                Vis(GameSzensze[i][xdskeetshit],not ui.get(OverrideSkeet) and ui.get(Tabs) == "Anti-Aim")
            end
        else
            Vis(GameSzensze[i],not ui.get(OverrideSkeet) and ui.get(Tabs) == "Anti-Aim")
        end
    end

    for i = 1, #Builder.Conditions do
        DefaultOn = ui.get(Builder.ConditionSelect) == Builder.Conditions[i] and ui.get(OverrideSkeet) and ui.get(Tabs) == "Anti-Aim"
        Vis(Builder[i]["Enable"], DefaultOn)
        DefaultOnEnable = ui.get(Builder.ConditionSelect) == Builder.Conditions[i] and ui.get(Builder[i]["Enable"]) and ui.get(OverrideSkeet) and ui.get(Tabs) == "Anti-Aim"
        Vis(Builder[i]["AllowFreestand"], DefaultOnEnable)
        Vis(Builder[i]["Pitch"], DefaultOnEnable)
        Vis(Builder[i]["PitchVal"], DefaultOnEnable and ui.get(Builder[i]["Pitch"]) == "Custom")
        Vis(Builder[i]["Yaw Base"], DefaultOnEnable)
        Vis(Builder[i]["Yaw"], DefaultOnEnable)
        Vis(Builder[i]["YawOff"], DefaultOnEnable)
        Vis(Builder[i]["YawOffVal"], DefaultOnEnable)
        Vis(Builder[i]["YawOffInv"], DefaultOnEnable and ui.get(Builder[i]["YawOff"]) ~= "Default")
        Vis(Builder[i]["YawOffHz"], DefaultOnEnable and ui.get(Builder[i]["YawOff"]) == "Switch Between")
        Vis(Builder[i]["YawMod"], DefaultOnEnable)
        Vis(Builder[i]["ModAngle"], DefaultOnEnable and ui.get(Builder[i]["YawMod"]) ~= "Off" and ui.get(Builder[i]["YawMod"]) ~= "X-Way")
        Vis(Builder[i]["WayHz"], DefaultOnEnable and ui.get(Builder[i]["YawMod"]) == "X-Way")
        Vis(Builder[i]["ModAngleInv"], DefaultOnEnable  and ui.get(Builder[i]["YawMod"]) ~= "X-Way" and ui.get(Builder[i]["YawMod"]) ~= "Off")
        
        Vis(Builder[i]["Ways"], DefaultOnEnable and ui.get(Builder[i]["YawMod"]) == "X-Way")
        for xi = 1, 5 do
            Vis(Builder[i]["Way"..xi], DefaultOnEnable and ui.get(Builder[i]["YawMod"]) == "X-Way" and ui.get(Builder[i]["Ways"]) >= xi)
        end


        Vis(Builder[i]["BodyYaw"], DefaultOnEnable)
        Vis(Builder[i]["BodyYawC"], DefaultOnEnable and ui.get(Builder[i]["BodyYaw"]) ~= "Disabled")
        Vis(Builder[i]["BYawOffVal"], DefaultOnEnable and ui.get(Builder[i]["BodyYaw"]) ~= "Disabled")
        Vis(Builder[i]["BYawOffInv"], DefaultOnEnable and ui.get(Builder[i]["BodyYaw"]) ~= "Disabled" and ui.get(Builder[i]["BodyYawC"]) == "Jitter L-R")
        Vis(Builder[i]["FreestandBody"],DefaultOnEnable)
    end
    Vis(menu.color,ui.get(Tabs) == "Visuals")
    Vis(menu.color_label,ui.get(Tabs) == "Visuals")
    Vis(menu.console,ui.get(Tabs) == "Visuals")
end

Yaw = {
    ThisSwitch = "l",
    ThisDelay = globals.realtime(),
    WaySwitch = 1,
    WayDelay = 0,
    JitterDsy = "l",
    JitterDelay = globals.realtime(),
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

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end
local vector = require('vector')
local measure_text = function(flags, ...)
    local args = {...}
    local string = table.concat(args, '')

    return vector(renderer.measure_text(flags, string))
end


function DoAntiAim(i)
    
    local self = entity.get_local_player()

    local players = entity.get_players(true)
    local eye_x, eye_y, eye_z = client.eye_position()
    returnthat = false 
    if ui.get(AvoidBack) then
        if players ~= nil then
            for i, enemy in pairs(players) do
                local head_x, head_y, head_z = entity.hitbox_position(players[i], 5)
                local wx, wy = renderer.world_to_screen(head_x, head_y, head_z)
                local fractions, entindex_hit = client.trace_line(self, eye_x, eye_y, eye_z, head_x, head_y, head_z)
    
                if 250 >= vector(entity.get_prop(enemy, 'm_vecOrigin')):dist(vector(entity.get_prop(self, 'm_vecOrigin'))) and entity.is_alive(enemy) and entity.get_player_weapon(enemy) ~= nil and entity.get_classname(entity.get_player_weapon(enemy)) == 'CKnife' and (entindex_hit == players[i] or fractions == 1) and not entity.is_dormant(players[i]) then
                    ui.set(references.yaw[1], '180')
                    ui.set(references.yaw[2], 180)
                    returnthat = true
                end
            end
        end
    end


    if Yaw.ThisDelay+1/(ui.get(Builder[i]["YawOffHz"])) < globals.realtime() then
        Yaw.ThisSwitch = Yaw.ThisSwitch == "l" and "r" or "l"
        Yaw.ThisDelay = globals.realtime()
    end

    if entity.get_player_weapon(self) == nil then return end

    local using = false
    local anti_aim_on_use = false

    local inverted = get_body_yaw(self) > 0 and false or true

    if Yaw.ThisDelay+1/(ui.get(Builder[i]["YawOffHz"])) < globals.realtime() then
        Yaw.ThisSwitch = Yaw.ThisSwitch == "l" and "r" or "l"
        Yaw.ThisDelay = globals.realtime()
    end

    if entity.get_player_weapon(self) == nil then return end

    local using = false
    local anti_aim_on_use = false

    DefensiveExploit = globals.tickcount() % 5 
    ui.set(GameSzensze[1],ui.get(Builder[i]["Enable"]))
    if ui.get(Builder[i]["Pitch"]) ~= '\aFF5F5FFF Exploit' then
        ui.set(GameSzensze[2][1],ui.get(Builder[i]["Pitch"]))
        ui.set(GameSzensze[2][2],ui.get(Builder[i]["PitchVal"]))
    else
        if DefensiveExploit == 4 then
            ui.set(GameSzensze[2][1],"Up")
        else
            ui.set(GameSzensze[2][1],"Down")
        end
    end
    ui.set(GameSzensze[3],ui.get(Builder[i]["Yaw Base"]))
    if not returnthat then
    ui.set(GameSzensze[4][1],ui.get(Builder[i]["Yaw"]))
    if manualaa() == 1 then
        ui.set(GameSzensze[4][2],-90)
    end
    if manualaa() == 2 then
        ui.set(GameSzensze[4][2],90)
    end
    if manualaa() == 3 then
        ui.set(GameSzensze[4][2],180)
    end
    if Yaw.JitterDelay+0.02<globals.realtime() then 
        Yaw.JitterDsy = Yaw.JitterDsy == "l" and "r" or "l" 
        Yaw.JitterDelay = globals.realtime()
    end
    if manualaa() == 0 then
        if ui.get(Builder[i]["YawOff"])== "Default" then
            ui.set(GameSzensze[4][2],ui.get(Builder[i]["YawOffVal"]))
        else
            ui.set(GameSzensze[4][2],Yaw.ThisSwitch == "l" and ui.get(Builder[i]["YawOffVal"]) or ui.get(Builder[i]["YawOffInv"]))
        end
    end
end

    if ui.get(Builder[i]["YawMod"]) ~= "X-Way" then
        ui.set(GameSzensze[5][1],ui.get(Builder[i]["YawMod"]))
        center = (ui.get(Builder[i]["ModAngle"]) + ui.get(Builder[i]["ModAngleInv"])) / 2
        if center > -180 and center < 180 then 
            ui.set(GameSzensze[5][2],center)
        end
    else
        ui.set(GameSzensze[5][1],"Center")
        if Yaw.WayDelay+1/(ui.get(Builder[i]["WayHz"])) < globals.realtime() then
            Yaw.WaySwitch = Yaw.WaySwitch+1
            if Yaw.WaySwitch > ui.get(Builder[i]["Ways"]) then Yaw.WaySwitch = 1 end
            Yaw.WayDelay = globals.realtime()
        end
        ui.set(GameSzensze[5][2],ui.get(Builder[i]["Way"..Yaw.WaySwitch]))
    end

    ui.set(GameSzensze[6][1],ui.get(Builder[i]["BodyYaw"]))
    if ui.get(Builder[i]["BodyYawC"]) == "Static" then
        ui.set(GameSzensze[6][2],ui.get(Builder[i]["BYawOffVal"]))
    else
        ui.set(GameSzensze[6][2],Yaw.JitterDsy == "l" and ui.get(Builder[i]["BYawOffInv"]) or ui.get(Builder[i]["BYawOffVal"]))
    end
    ui.set(GameSzensze[8],ui.get(Builder[i]["FreestandBody"]))
    ui.set(GameSzensze[7][1], ui.get(Freestand) and ui.get(Builder[i]["AllowFreestand"]))
    ui.set(GameSzensze[7][2], ui.get(Freestand) and 'Always on' or 'Off hotkey')
end

local vector = require('vector')
local images = require("gamesense/images")
local http = require "gamesense/http"
local build = "nightly"
local pi, max = math.pi, math.max

local dynamic = {}
dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:get()
   return self.y
end

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
    renderer.rectangle(b, c, d, e, f, g, h, i)
    renderer.circle(b, c, f - 8, g - 8, h - 8, i, k, -180, 0.25)
    renderer.circle(b + d, c, f - 8, g - 8, h - 8, i, k, 90, 0.25)
    renderer.rectangle(b, c - k, d, k, f, g, h, i)
    renderer.circle(b + d, c + e, f - 8, g - 8, h - 8, i, k, 0, 0.25)
    renderer.circle(b, c + e, f - 8, g - 8, h - 8, i, k, -90, 0.25)
    renderer.rectangle(b, c + e, d, k, f, g, h, i)
    renderer.rectangle(b - k, c, k, e, f, g, h, i)
    renderer.rectangle(b + d, c, k, e, f, g, h, i)
end
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local logs = {}
logo = nil 
http.get("https://cdn.discordapp.com/attachments/1091676945252626463/1091749991745335419/gopng.png", function(success, response)
    if not success or response.status ~= 200 then
        return
    end

    logo = renderer.load_png(response.body, 23, 23)
end)
contains = function(n,v)
    truee = false 
    for i = 1,#n do 
        if n[i] == v then
            truee = true 
        end
    end
    return truee
end

function fired(e)
    stored_shot = {
        damage = e.damage,
        hitbox = hitgroup_names[e.hitgroup + 1],
        lagcomp = e.teleported,
        backtrack = globals.tickcount() - e.tick
    }
end

function hit(e)
    if contains(ui.get(Hitlogs),"Hit") then
    local string = string.format("hit %s for %s [%s] in the %s [%s] [hc: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), e.damage, stored_shot.damage, hitgroup_names[e.hitgroup + 1] or '?', stored_shot.hitbox, math.floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
    table.insert(logs, {
        text = string
    }) 
    if ui.get(menu.console) then
        r,g,b = ui.get(menu.color)
        client.color_log(r, g, b, "[ZOV] \0")
        client.color_log(147, 182, 23, string)
    end
end
end

function missed(e)
    if contains(ui.get(Hitlogs),"Miss") then
        local string = string.format("missed %s's %s due to %s [dmg: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), stored_shot.hitbox, e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
        table.insert(logs, {
            text = string
        })
        if ui.get(menu.console) then
            r,g,b = ui.get(menu.color)
            client.color_log(r, g, b, "[ZOV] \0")
            client.color_log(220, 85, 85, string)
        end
    end
end

function logging()
    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 1, 1, -30)
            logs[i].time = globals.tickcount() + 256
            logs[i].init = true
        end
        r,g,b,a = ui.get(menu.color)
        local string_size = renderer.measure_text("c", logs[i].text)
        roundedRectangle(screen[1]/2-string_size/2-35, screen[2]-logs[i].y:get(), string_size+0, 0, 0,0,0,0,"", 0)
        renderer.text(screen[1]/2-20, screen[2]-logs[i].y:get()+8, 255,255,255,255,"c",0,logs[i].text)
        renderer.texture(logo, screen[1]/2-40-string_size/2, screen[2]-logs[i].y:get()-3, 22, 22,255, 255, 255, 255,"f")
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-logs[i].y:get()+0, 0, 0, 0, 0, 0, 0, 0, 0)
        renderer.circle_outline(screen[1]/2+string_size/2-6, screen[2]-logs[i].y:get()+0, r,g,b,a, 0, 0, (logs[i].time-globals.tickcount())/0, 0)
        if tonumber(logs[i].time) < globals.tickcount() then
            if logs[i].y:get() < -10 then
                table.remove(logs, i)
            else
                logs[i].y:update(globals.frametime(), -50, nil)
            end
        else
            logs[i].y:update(globals.frametime(), 20+(i*28), nil)
        end
    end
end




local screen_size = { client.screen_size() }

local self_planting = nil
local planting = false

local indicators_data = {
    last_sim_time = 0,
    defensive_active_until = 0,
    dt_charged = false
}

local indicators_table = {}

client.set_event_callback('indicator', function(indicator)
    if indicator.text == 'DT' then
        indicators_data.dt_charged = (indicator.r == 255 and indicator.g == 255 and indicator.b == 255)

        if globals.tickcount() <= indicators_data.defensive_active_until then
            indicator.r = 130
            indicator.g = 195
            indicator.b = 20
        end
    end

    indicators_table[#indicators_table + 1] = indicator
end)


client.set_event_callback('round_start', function()
    planting = false
end)

client.set_event_callback('bomb_abortplant', function()
    planting = false
end)

client.set_event_callback('bomb_planted', function()
    planting = false
end)

client.set_event_callback('bomb_beginplant', function(event)
    local self = entity.get_local_player()

    local userid = client.userid_to_entindex(event.userid)
    if userid == nil then return end

    self_planting = userid == self
    planting = true
end)

function lerp(a, b, t)
    if type(a) == 'table' then
        local result = {}

        for k, v in pairs(a) do
            result[k] = a[k] + (b[k] - a[k]) * t
        end

        return result
    elseif type(a) == 'cdata' then
        return vector(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t)
    else
        return a + (b - a) * t
    end
end

lerp = function(a,b,c) 
    return a+(b-a)*c
end


local checker = true

local indicators_add_x = 0
local indicators_states_add_x = 0
local indicators_damage_add_x = 0
local indicators_damage_add_y = 0

local double_tap_transparency = 0
local hide_shots_transparency = 0
local damage_transparency = 0

local double_tap_ready = 0
local double_tap_active = 0
local double_tap_waiting = 0

local hide_shots_ready_add_x = 0
local hide_shots_waiting_add_x = 0

local double_tap_ready_add_x = 0
local double_tap_active_add_x = 0
local double_tap_waiting_add_x = 0

local hide_shots_ready = 0
local hide_shots_waiting = 0

total = 0
exploitready = 0 

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

local print_x = 0

local function indicators_rendering()
    local self = entity.get_local_player()
    if self == nil or entity.is_alive(self) == false or ui.get(settingsindicators) == false then return end

    local x, y = client.screen_size()

    local indicators_color = {ui.get(settingsindicators_color)}

    indicators_add_x = lerp(indicators_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 32 or 0, 20 * globals.frametime())

    renderer.text(x / 2 - 30 + math.floor(indicators_add_x), y / 2 + 17, 255, 255, 255, 255, 'd', 0, ' zov')
    renderer.text(x / 2 - 7 + math.floor(indicators_add_x), y / 2 + 17, indicators_color[1], indicators_color[2], indicators_color[3], 255 * math.abs(globals.curtime() * 2 % 2 - 1), 'd', 0, 'private')

    if print_state_id == 9 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 24; width_value = 40 elseif print_state_id == 8 then print_x, print_y = x / 2, y / 2 + 38; add_x_value = 25 elseif print_state_id == 7 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 25 elseif print_state_id == 6 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 17 elseif print_state_id == 5 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 25 elseif print_state_id == 4 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 27 elseif print_state_id == 3 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 23 elseif print_state_id == 2 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 21 elseif print_state_id == 1 then print_x, print_y = x / 2, y / 2 + 34; add_x_value = 26 end

    indicators_states_add_x = lerp(indicators_states_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and add_x_value or 0, 35 * globals.frametime())

    renderer.text(print_x + math.floor(indicators_states_add_x), print_y, 255, 255, 255, 255, 'cd', 0, print_state)

    double_tap_transparency = lerp(double_tap_transparency, ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and 1 or 0, 20 * globals.frametime())
    hide_shots_transparency = lerp(hide_shots_transparency, ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]) and not (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) and 1 or 0, 20 * globals.frametime())
    damage_transparency = lerp(damage_transparency, ui.get(reference.minimum_damage_override[1]) and ui.get(reference.minimum_damage_override[2]) and 1 or 0, 20 * globals.frametime())

    double_tap_ready = lerp(double_tap_ready, ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and indicators_data.dt_charged and not (globals.tickcount() <= indicators_data.defensive_active_until) and 1 or 0, 20 * globals.frametime())
    double_tap_active = lerp(double_tap_active, ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and globals.tickcount() <= indicators_data.defensive_active_until and 1 or 0, 20 * globals.frametime())
    double_tap_waiting = lerp(double_tap_waiting, ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and (not indicators_data.dt_charged or ui.get(reference.duck_peek_assist)) and 1 or 0, 20 * globals.frametime())

    hide_shots_ready = lerp(hide_shots_ready, ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]) and ui.get(reference.duck_peek_assist) == false and not (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) and 1 or 0, 25 * globals.frametime())
    hide_shots_waiting = lerp(hide_shots_waiting, ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]) and ui.get(reference.duck_peek_assist) and not (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) and 1 or 0, 20 * globals.frametime())

    double_tap_ready_add_x = lerp(double_tap_ready_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 24 or 0, 20 * globals.frametime())
    double_tap_active_add_x = lerp(double_tap_active_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 25 or 0, 20 * globals.frametime())
    double_tap_waiting_add_x = lerp(double_tap_waiting_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 28 or 0, 20 * globals.frametime())

    hide_shots_ready_add_x = lerp(hide_shots_ready_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 30 or 0, 20 * globals.frametime())
    hide_shots_waiting_add_x = lerp(hide_shots_waiting_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 34 or 0, 20 * globals.frametime())

    indicators_damage_add_x = lerp(indicators_damage_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 23 or 0, 20 * globals.frametime())
    indicators_damage_add_y = lerp(indicators_damage_add_y, ui.get(reference.minimum_damage_override[1]) and ui.get(reference.minimum_damage_override[2]) and (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) or ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2])) and 18 or 6, 20 * globals.frametime())

    if ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) then
        if checker then
            checker = false

            on_shot_anti_aim1_cache = ui.get(reference.on_shot_anti_aim[1])
        end

        ui.set(reference.on_shot_anti_aim[1], false)
    else
        if not checker then
            checker = true

            ui.set(reference.on_shot_anti_aim[1], on_shot_anti_aim1_cache)
        end
    end

    if indicators_data.dt_charged and not (globals.tickcount() <= indicators_data.defensive_active_until) and ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and ui.get(reference.duck_peek_assist) == false or (ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]) and ui.get(reference.duck_peek_assist) == false) then
        charge_text = 'ready'

        dt_x1 = x / 2 - 20 + math.floor(double_tap_ready_add_x)
        dt_x2 = x / 2 - 7 + math.floor(double_tap_ready_add_x)

        hs_x1 = x / 2 - 25 + math.floor(hide_shots_ready_add_x)
        hs_x2 = x / 2 - 1 + math.floor(hide_shots_ready_add_x)

        r_dt = 160; g_dt = 235; b_dt = 135; a_dt = 255 * double_tap_ready
        r_hs = 160; g_hs = 235; b_hs = 135; a_hs = 255 * hide_shots_ready
    elseif globals.tickcount() <= indicators_data.defensive_active_until then
        charge_text = 'active'

        dt_x1 = x / 2 - 21 + math.floor(double_tap_active_add_x)
        dt_x2 = x / 2 - 8 + math.floor(double_tap_active_add_x)

        r_dt = indicators_color[1]; g_dt = indicators_color[2]; b_dt = indicators_color[3]; a_dt = 255 * double_tap_active
    else
        charge_text = 'waiting'

        dt_x1 = x / 2 - 24 + math.floor(double_tap_waiting_add_x)
        dt_x2 = x / 2 - 11 + math.floor(double_tap_waiting_add_x)

        hs_x1 = x / 2 - 29 + math.floor(hide_shots_waiting_add_x)
        hs_x2 = x / 2 - 5 + math.floor(hide_shots_waiting_add_x)

        r_dt = 250; g_dt = 45; b_dt = 45; a_dt = 255 * double_tap_waiting
        r_hs = 250; g_hs = 45; b_hs = 45; a_hs = 255 * hide_shots_waiting
    end

    renderer.text(hs_x1, y / 2 + 39, 255, 255, 255, 255 * hide_shots_transparency, 'd', 0, 'hide')
    renderer.text(hs_x2, y / 2 + 39, r_hs, g_hs, b_hs, a_hs, 'd', 0, charge_text)

    renderer.text(dt_x1, y / 2 + 39, 255, 255, 255, 255 * double_tap_transparency, 'd', 0, 'dt')
    renderer.text(dt_x2, y / 2 + 39, r_dt, g_dt, b_dt, a_dt, 'd', 0, charge_text)

    renderer.text(x / 2 + math.floor(indicators_damage_add_x), y / 2 + 39 + math.floor(indicators_damage_add_y), 255, 255, 255, 255 * damage_transparency, 'cd', 0, 'damage')
end

local manual_transparency = 0

local function minimum_damage_override_indicator_rendering()
    local self = entity.get_local_player()
    if ui.get(settingsminimum_damage_override_indicator) == false or self == nil or entity.is_alive(self) == false then return end

    local x, y = client.screen_size()

    if ui.get(reference.minimum_damage_override[2]) then
        renderer.text(x / 2 + 2, y / 2 - 14, 255, 255, 255, 225, 'd', 0, ui.get(reference.minimum_damage_override[3]))
    end
end

client.set_event_callback('paint', function()
    indicators_rendering()
    minimum_damage_override_indicator_rendering()
end)


client.set_event_callback('paint', indicators_rendering)
client.set_event_callback('paint', logging)
client.set_event_callback("aim_fire", fired)
client.set_event_callback("aim_hit", hit)
client.set_event_callback("aim_miss", missed)

client.set_event_callback('paint_ui', function()
    visibility()
end)


http.get('https://i.imgur.com/juCfLK4.png', function(a, b)
    if a and b.status == 200 then
        zov_icon = images.load(b.body)
    else
        error('Couldn\'t load icon')
    end
end)

local screen_size = function()
    return vector(client.screen_size())
end

local measure_text = function(flags, ...)
    local args = {...}
    local string = table.concat(args, '')

    return vector(renderer.measure_text(flags, string))
end

local notify = {notifications = {bottom = {}}, max = {bottom = 6}}

notify.__index = notify

notify.queue_bottom = function()
    if #notify.notifications.bottom <= notify.max.bottom then
        return 0
    end

    return #notify.notifications.bottom - notify.max.bottom
end

notify.clear_bottom = function()
    for i = 1, notify.queue_bottom() do
        table.remove(notify.notifications.bottom, #notify.notifications.bottom)
    end
end

notify.new_bottom = function(timeout, color, ...)
    table.insert(notify.notifications.bottom, {
        started = false,
        instance = setmetatable({
            active = false,
            timeout = timeout,
            color = {r = color[1], g = color[2], b = color[3], a = 0},
            x = screen_size().x / 2,
            y = screen_size().y,
            text = ...
        }, notify)
    })
end

function notify:handler()
    local bottom_count = 0
    local bottom_visible_amount = 0

    for index, notification in pairs(notify.notifications.bottom) do
        if not notification.instance.active and notification.started then
            table.remove(notify.notifications.bottom, index)
        end
    end

    for i = 1, #notify.notifications.bottom do
        if notify.notifications.bottom[i].instance.active then
            bottom_visible_amount = bottom_visible_amount + 1
        end
    end

    for index, notification in pairs(notify.notifications.bottom) do
        if index > notify.max.bottom then
            goto skip
        end

        if notification.instance.active then
            notification.instance:render_bottom(bottom_count, bottom_visible_amount)
            bottom_count = bottom_count + 1
        end

        if not notification.started then
            notification.instance:start()
            notification.started = true
        end
    end

    ::skip::
end

function notify:start()
    self.active = true
    self.delay = globals.realtime() + self.timeout
end

function notify:get_text()
    local text = ''

    for i, curr_text in pairs(self.text) do
        local text_size = measure_text('', curr_text[1])

        local r, g, b = 255, 255, 255

        if curr_text[2] then
            r, g, b = self.color.r, self.color.g, self.color.b
        end

        text = text .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, self.color.a, curr_text[1]) .. ' '
    end

    return text
end

local m_render = (function()
    local A = {}

    A.rec = function(x, y, w, h, r, g, b, a, radius)
        radius = math.min(x / 2, y / 2, radius)

        renderer.rectangle(x, y + radius, w, h - radius * 2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)

        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, .25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, .25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, .25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, .25)
    end

    A.rec_outline = function(x, y, w, h, r, g, b, a, radius, thickness)
        radius = math.min(w / 2, h / 2, radius)

        if radius == 1 then
            renderer.rectangle(x, y, w, thickness, r, g, b, a)
            renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
        else
            renderer.rectangle(x + radius, y, w - radius * 2, thickness, r, g, b, a)
            renderer.rectangle(x + radius, y + h - thickness, w - radius * 2, thickness, r, g, b, a)
            renderer.rectangle(x, y + radius, thickness, h - radius * 2, r, g, b, a)
            renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius * 2, r, g, b, a)

            renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, .25, thickness)
            renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, .25, thickness)
            renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, .25, thickness)
            renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, .25, thickness)
        end
    end

    A.glow_module_notify = function(x, y, w, h, width, rounding, cr, cg, cb, ca, g_cr, g_cg, g_cb, g_ca, show)
        local thickness = 1
        local offset = 1

        if show then
            A.rec(x, y, w, h, cr, cg, cb, ca, rounding)
        end

        for k = 0, width do
            local a = ca / 2 * (k / width) ^ 3

            A.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h - (k - width - offset)*thickness*2, g_cr, g_cg, g_cb, a / 1.5, rounding + thickness * (width - k + offset), thickness)
        end
    end

    return A
end)()

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'Source', discord = ''}

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()

    local prefix_padding = 6

    prefix_size = vector(zov_icon:measure() - 990)

    local text = self:get_text()
    local text_size = measure_text('', text)
    local glow_steps = 8
    local padding = 5
    local text_width = prefix_size.x + prefix_padding + text_size.x
    local w, h = text_width + padding * 2, 12 + 10 + 1
    local x, y = self.x - w / 2, math.ceil(self.y - 40 + .4)

    if globals.realtime() < self.delay then
        self.y = lerp(self.y, (screen.y - 45) - ((visible_amount - index) * h * 1.4), globals.frametime() * 7)
        self.color.a = lerp(self.color.a, 255, globals.frametime() * 2)
    else
        self.y = lerp(self.y, self.y - 10, globals.frametime() * 15)
        self.color.a = lerp(self.color.a, 0, globals.frametime() * 20)

        if self.color.a <= 1 then
            self.active = false
        end
    end

    local r, g, b, a = self.color.r, self.color.g, self.color.b, self.color.a

    m_render.glow_module_notify(x, y, w, h, 15, glow_steps, 25, 25, 25, a, r, g, b, a, true)

    local offset = padding + 2

    if zov_icon then
        local color = {255, 255, 255}

        zov_icon:draw(x + offset - 5, y, nil, 24, color[1], color[2], color[3], a, true, 'f')

        offset = offset + prefix_size.x + prefix_padding
    end

    renderer.text(x + offset, y + h / 2 - text_size.y / 2, r, g, b, a, '', nil, text)
end


tabletostring = function(table)
    local string = ""
    for i = 1, #table:get() do
        string = string .. table:get()[i] .. (i == #table:get() and "" or ",")
    end

    if string == "" then
        string = "-"
    end

    return string
end

stringtosub = function(i, s)
    local text = {}
    for string in string.gmatch(i, "([^" .. s .. "]+)") do
        text[#text + 1] = string.gsub(string, "\n", "")
    end
    return text
end
config_elements = {}
for i = 1, #Builder.Conditions do 
    if config_elements[i] == nil then config_elements[i] = {} end 
    table.insert(config_elements[i],Builder[i]["Enable"])
    table.insert(config_elements[i],Builder[i]["Pitch"])
    table.insert(config_elements[i],Builder[i]["PitchVal"])
    table.insert(config_elements[i],Builder[i]["Yaw Base"])
    table.insert(config_elements[i],Builder[i]["Yaw"])
    table.insert(config_elements[i],Builder[i]["YawOff"])
    table.insert(config_elements[i],Builder[i]["YawOffVal"])
    table.insert(config_elements[i],Builder[i]["YawOffInv"])
    table.insert(config_elements[i],Builder[i]["YawOffHz"])
    table.insert(config_elements[i],Builder[i]["YawMod"])
    table.insert(config_elements[i],Builder[i]["ModAngle"])
    table.insert(config_elements[i],Builder[i]["ModAngleInv"])

    table.insert(config_elements[i],Builder[i]["WayHz"])
    for xi = 1, 5 do
        table.insert(config_elements[i],Builder[i]["Way"..xi])
    end
    table.insert(config_elements[i],Builder[i]["BodyYaw"])
    table.insert(config_elements[i],Builder[i]["BodyYawC"])
    table.insert(config_elements[i],Builder[i]["BYawOffVal"])
    table.insert(config_elements[i],Builder[i]["BYawOffInv"])
    table.insert(config_elements[i],Builder[i]["FreestandBody"])
    table.insert(config_elements[i],Builder[i]["Ways"])
    table.insert(config_elements[i],Builder[i]["AllowFreestand"])
end
table.insert(config_elements[1],kibit)


function get_config_code()
    string = ""
    for i = 1, #Builder.Conditions do 
        thisstring = ""
        thisexport = {}

        table.insert(thisexport,Builder[i]["Enable"])
        table.insert(thisexport,Builder[i]["Pitch"])
        table.insert(thisexport,Builder[i]["PitchVal"])
        table.insert(thisexport,Builder[i]["Yaw Base"])
        table.insert(thisexport,Builder[i]["Yaw"])
        table.insert(thisexport,Builder[i]["YawOff"])
        table.insert(thisexport,Builder[i]["YawOffVal"])
        table.insert(thisexport,Builder[i]["YawOffInv"])
        table.insert(thisexport,Builder[i]["YawOffHz"])
        table.insert(thisexport,Builder[i]["YawMod"])
        table.insert(thisexport,Builder[i]["ModAngle"])
        table.insert(thisexport,Builder[i]["ModAngleInv"])
        table.insert(thisexport,Builder[i]["WayHz"])
        for xi = 1, 5 do
            table.insert(thisexport,Builder[i]["Way"..xi])
        end
        table.insert(thisexport,Builder[i]["BodyYaw"])
        table.insert(thisexport,Builder[i]["BodyYawC"])
        table.insert(thisexport,Builder[i]["BYawOffVal"])
        table.insert(thisexport,Builder[i]["BYawOffInv"])
        table.insert(thisexport,Builder[i]["FreestandBody"])
        table.insert(thisexport,Builder[i]["Ways"])
        table.insert(thisexport,Builder[i]["AllowFreestand"])

        for xd = 1,#thisexport do
            item = thisexport[xd] 
            if type(ui.get(item)) == "table" then
                tablestring = ""
                for xd = 1, #ui.get(item) do 
                    tablestring = tablestring..tostring(ui.get(item)[xd])..","
                end 
                thisstring = thisstring.."{"..tablestring.."}_"
            else
                thisstring = thisstring..""..tostring(ui.get(item)).."_"
            end
        end
        string = string.."["..thisstring.."],"
    end
    clipboard.set(base64.encode(string))
    return base64.encode(string)
end


function set_config(code) 
    conditions = stringtosub(base64.decode(code),"]")
    for cond = 1, #conditions do
        print(conditions[cond])
        items = stringtosub(conditions[cond],"_[,")
        for item = 1,#items do
            if conditions[cond] ~= nil then
                if config_elements[cond] ~= nil then 
                    if items[item] == "true" or items[item] == "false" then
                        ui.set(config_elements[cond][item],items[item] == "true" and true or false)
                    elseif tonumber(items[item]) ~= nil then
                        ui.set(config_elements[cond][item],tonumber(items[item]))
                    else
                        ui.set(config_elements[cond][item],items[item])
                    end
                end
            end
        end
    end
end

Export = ui.new_button("AA", "Anti-aimbot angles","Export",function()
    get_config_code()
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Exported'},
        {'successfully', true},
        {'!'}
    })
end)

Import = ui.new_button("AA", "Anti-aimbot angles","Import",function()
    set_config(clipboard.get())
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Imported'},
        {'successfully', true},
        {'!'}
    })
end)


client.set_event_callback('setup_command', function(cmd)
    local self = entity.get_local_player()
	 if entity.get_prop(self, 'm_MoveType') == 9 then print_state_id = 9; print_state = 'climbing' elseif self_planting == true and planting == true then print_state_id = 8; print_state = 'planting' elseif entity.get_prop(self, 'm_bIsDefusing') == 1 then print_state_id = 7; print_state = 'defusing' elseif cmd.in_use == 1 and entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 0 then print_state_id = 6; print_state = 'using' elseif (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 0 then print_state_id = 5; print_state = 'jumping' elseif entity.get_prop(self, 'm_flDuckAmount') > 0.8 and bit.band(cmd.buttons, 1) == 0 or ui.get(reference.duck_peek_assist) then print_state_id = 4; print_state = 'crouching' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and bit.band(cmd.buttons, 1) == 0 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) then print_state_id = 3; print_state = 'walking' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and bit.band(cmd.buttons, 1) == 0 and not (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) then print_state_id = 2; print_state = 'moving' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() < 2 and bit.band(cmd.buttons, bit.lshift(1, 0)) == 0 then print_state_id = 1; print_state = 'standing' end
    if self == nil or entity.is_alive(self) == false then return end
    if ui.get(ForceDefense) or ui.get(ForceDefenseKey) and bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0 then
        cmd.force_defensive = globals.tickcount() % 5 == 4
    end
end)

client.set_event_callback('setup_command', function(e)
    local weaponn = entity.get_player_weapon()
    if ui.get(BodyYawOnE) then
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
    end
    if ui.get(OverrideSkeet) then
        if get_mode(e) ~= nil then
            if ui.get(Builder[get_mode(e)]["Enable"]) then
                DoAntiAim(get_mode(e))
            else
                if ui.get(Builder[1]["Enable"]) then
                    DoAntiAim(1)
                end
            end
        end
    end
end)

client.delay_call(1, function()
    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Welcome'},
        { '~ ' .. obex_data.username},
        {'to ZOV YAW', true},
        {'~ ' .. obex_data.build},
        {'!'}
    })
end)

client.set_event_callback('paint_ui', function()
    notify:handler()

    if ui.is_menu_open() then
        ui.set(references.enabled, true)
 
    end

    local h = select(2, client.screen_size())
    local starting = h - 350

    for index, indicator in pairs(indicators_table) do index = index - 1
        local width, height = renderer.measure_text('d+', indicator.text)
        local offset = index * (height + 8)

        local gradient_width = math.floor(width / 2)

        local y = starting - offset

        renderer.gradient(10, y, gradient_width, height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
        renderer.gradient(10 + gradient_width, y, gradient_width, height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)

        renderer.text(20, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
    end

    indicators_table = {}
end)

local mindmg = ui.reference("rage", "aimbot", "minimum damage")
local mindmgov = {ui.reference("rage", "aimbot", "Minimum damage override")}

local function on_paint(c)
    local sw, sh = client.screen_size()
    local x, y = sw / 2, sh - 200

    if contains(ui.get(Windows),"Min damage indicator") then 
        if ui.get(kibit) then
            client.draw_text(ctx, sw / 2-15, sh / 2.5+80, 255,255,255, 255, "c", 0, ui.get(mindmgov[2]) and "1" or "0")
            client.draw_text(ctx, sw / 2+10, sh / 2.5+80, 255,255,255, 255, "c", 0, ui.get(mindmgov[2]) and ui.get(mindmgov[3]) or ui.get(mindmg))
        else
            if ui.get(mindmgov[2]) then
                client.draw_text(ctx, sw / 2+9, sh / 2.5+100, 255,255,255, 255, "c", 0, ui.get(mindmgov[3]))
            end
        end
    end
end

client.set_event_callback('paint', on_paint)

client.set_event_callback('shutdown', function()
    cvar.cl_csm_shadows:set_int(1)
end)


-- Clantag

clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFF5F5FFFZ".."\aFFFFFFFF - Clantag")
local clantag_table = { }
local function generate_clantag(clantag)
    for i = 1, string.len(clantag) do
        table.insert(clantag_table, string.sub(clantag, 1, i))
    end
    for i = #clantag_table, 1, -1 do
        table.insert(clantag_table, string.sub(clantag, 1, i))
    end
end
generate_clantag("Zov-Yaw")
setmetatable(clantag_table, {__index = function() return "" end})

local next_chat_time = 0
local say_queue = { }
local function say_queue_execute()
    local curtime = globals.curtime()
    if curtime > next_chat_time then
        if #say_queue > 0 then
            local str = say_queue[1]
            str = string.gsub(str, "%\"", "")
            str = string.gsub(str, "%\'", "")
            str = string.gsub(str, "%;", "")
            client.exec(string.format("say \"%s\"", str))
            table.remove(say_queue, 1)
            next_chat_time = curtime + 0.85
        end
    end
end

client.set_event_callback("run_command", function()
    say_queue_execute()
    if ui.get(clantag) then
        client.set_clan_tag(clantag_table[math.floor(globals.curtime()*1.54)%#clantag_table])
    end
end)




--fast ladder 


local entity_get_prop = entity.get_prop
local ui_get = ui.get
local client_camera_angles = client.camera_angles

fastladder = ui.new_multiselect("AA", "Anti-aimbot angles", "\aFF5F5FFFZ".."\aFFFFFFFF Fast ladder", "Up", "Down")

local function contains(tbl, val) 
    for i=1, #tbl do
        if tbl[i] == val then return true end 
    end 
    return false 
end

client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client_camera_angles()
    if entity_get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0

        if contains(ui_get(fastladder), "Up") then
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
        end

        if contains(ui_get(fastladder), "Down") then
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
    end
end)

