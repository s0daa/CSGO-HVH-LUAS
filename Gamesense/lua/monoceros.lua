local v ector = require('vector')
local http = require('gamesense/http')
local base64 = require('gamesense/base64')
local antiaim_funcs = require("gamesense/antiaim_funcs")
local clipboard = require('gamesense/clipboard')
local gamesense_entity = require('gamesense/entity')
local images = require('gamesense/images')

local anti_aim_pressed = true
local visuals_pressed = false
local miscellaneous_pressed = false

local last_press = 0
local direction = 0

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'Private', discord = ''}


local function contains(source, target)
	for id, name in pairs(ui.get(source)) do
		if name == target then
			return true
		end
	end

	return false
end

local var_table = {};

local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0

function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
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
    {ui.reference('AA', 'Fake lag', 'Enabled')},
    ui.reference('AA', 'Fake lag', 'Amount'),
    ui.reference('AA', 'Fake lag', 'Variance'),
    ui.reference('AA', 'Fake lag', 'Limit'),
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

function RGBAtoHEX(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

animation_menu = ui.new_label("AA", "Anti-aimbot angles", ".")
fakelag_anim_menu = ui.new_label("AA", "Fake lag", ".")

client.set_event_callback("paint_ui", function()
    local aA = {
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
        {230,230,230, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 0 / 30))}
    }
    --Monoceros
    label_text = string.format(".・。.・゜✭.・。.・゜✭ \aFFFFFFFF      \a%sM\a%so\a%sn\a%so\a%sc\a%se\a%sr\a%so\a%ss", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8])), RGBAtoHEX(unpack(aA[9])))
    fakelag_text = string.format(".・。.・゜✭.・。.・゜✭ \aFFFFFFFF      \a%sC\a%so\a%sn\a%sf\a%si\a%sg\a%ss", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])))

    ui.set(animation_menu, label_text)
    ui.set(fakelag_anim_menu, fakelag_text)
end)

OverrideSkeet = ui.new_checkbox("AA", "Anti-aimbot angles","Enable Monoceros")
Tabs = ui.new_combobox("AA", "Anti-aimbot angles"," ",{"Anti-Aim","Visuals", "Misc"})


local menu = {
    color_label = ui.new_label("AA", "Anti-aimbot angles", "accent color"),
    color = ui.new_color_picker("AA", "Anti-aimbot angles", "accent", 220, 231, 255, 255)
}

Builder = {}
Builder.Conditions = {"General","Stand","Slow walk","Move","Duck","Aerobic","Aerobic+"}
ManualLeft = ui.new_hotkey('AA', 'Anti-aimbot angles',"  Manual Left")
ManualRight = ui.new_hotkey('AA', 'Anti-aimbot angles',"  Manual Right")
ManualForward = ui.new_hotkey('AA', 'Anti-aimbot angles',"  Manual Forward")
Freestand = ui.new_hotkey('AA', 'Anti-aimbot angles',"Freestand")
Builder.ConditionSelect = ui.new_combobox('AA', 'Anti-aimbot angles',"Condition", Builder.Conditions)
Hitlogs = ui.new_multiselect('AA', 'Anti-aimbot angles',"Hitlogs", {"Hit","Miss"})
Windows = ui.new_multiselect('AA', 'Anti-aimbot angles',"Windows", {"Min damage indicator", "Defensive panel", "Watermark", "Manual Arrows", "Indicators"})
Indicators = ui.new_checkbox('AA', 'Anti-aimbot angles',"Other")
indicators_color = ui.new_color_picker('AA', 'Anti-aimbot angles',"Other Color", 255, 95, 95, 255)
AvoidBack = ui.new_checkbox("AA", "Anti-aimbot angles","Avoid Backstab")
enableRoundTime = ui.new_checkbox("AA", "Anti-aimbot angles", "Shit preset on warmup")
ForceDefense = ui.new_checkbox("AA", "Anti-aimbot angles","Force Defense In Air")
ForceDefenseKey = ui.new_hotkey("AA", "Anti-aimbot angles","Force Defense on Key")
defensive_panel_icon = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Defensive panel icon')
settingsminimum_damage_override_indicator = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Minimum damage override indicator'); ui.set_visible(settingsminimum_damage_override_indicator, false)

local function rotate_point(x, y, rot, size)
	return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

settingsdisableshadows = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Disable shadows'); ui.set_visible(settingsdisableshadows, true)

local function disableshadows()
    if ui.get(settingsdisableshadows) then
        cvar.cl_csm_shadows:set_int(0)
    else
        cvar.cl_csm_shadows:set_int(1)
    end
end

ui.set_callback(settingsdisableshadows, disableshadows)

local function get_mode()
    local lp = entity.get_local_player()
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1
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

for i = 1, #Builder.Conditions do
    if Builder[i] == nil then Builder[i] = {} end 
    Builder[i]["Enable"] = ui.new_checkbox("AA", "Anti-aimbot angles","Enable "..Builder.Conditions[i])
    Builder[i]["AllowFreestand"] = ui.new_checkbox("AA", "Anti-aimbot angles","Allow Freestand "..Builder.Conditions[i])
    Builder[i]["Pitch"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Pitch",{'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random', 'Custom','\aDCE7FFFFExploit'})
    Builder[i]["PitchVal"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Pitch",-89,89,0)
    Builder[i]["Yaw Base"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Yaw Base",{'Local view', 'At targets'})
    Builder[i]["Yaw"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Yaw",{'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'})
    Builder[i]["YawOff"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Yaw Offset",{"Default","Switch Between"})
    Builder[i]["YawOffVal"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Yaw Offset Right", -180, 180, 0)
    Builder[i]["YawOffInv"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Yaw Offset Left", -180, 180, 0)
    Builder[i]["YawOffHz"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Switches/sec", 1, 360, 144)
    Builder[i]["YawMod"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Yaw Modifier",{ 'Off', 'Offset', 'Center', 'Random', 'Skitter', "X-Way"})
    Builder[i]["ModAngle"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."]  Modifier Right", -180, 180, 0)
    Builder[i]["ModAngleInv"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Modifier Left", -180, 180, 0)
    Builder[i]["Ways"] = ui.new_slider("AA", "Anti-aimbot angles", "["..i.."] Ways",1,5)
    Builder[i]["TestExploit"] = ui.new_checkbox("AA", "Anti-aimbot angles", "["..i.."] Exploit", false)

    Builder[i]["WayHz"] = ui.new_slider("AA", "Anti-aimbot angles",")".." ["..i.."] Way Switches/sec",1,360,144)
    for xi = 1, 5 do
        Builder[i]["Way"..xi] = ui.new_slider("AA", "Anti-aimbot angles","["..i.."]"..xi.."Way", -180, 180, 0)
    end

    Builder[i]["BodyYaw"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Body Yaw",{ 'Off', 'Opposite', 'Jitter', 'Static'})
    Builder[i]["BodyYawC"] = ui.new_combobox("AA", "Anti-aimbot angles","".." ["..i.."] Body Limit",{ "Static","Jitter L-R"})
    Builder[i]["BYawOffVal"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Body Yaw Right", -180, 180, 0)
    Builder[i]["BYawOffInv"] = ui.new_slider("AA", "Anti-aimbot angles","".." ["..i.."] Body Yaw Left", -180, 180, 0)
    Builder[i]["FreestandBody"] = ui.new_checkbox("AA", "Anti-aimbot angles","".." ["..i.."]  Freestand")
end

Vis = ui.set_visible
visibility = function()
    Vis(Tabs,ui.get(OverrideSkeet))
    Vis(Windows,ui.get(Tabs) == "Visuals")
    Vis(Hitlogs,ui.get(Tabs) == "Visuals")
    Vis(Indicators,false)--ui.get(Tabs) == "Visuals")
    Vis(indicators_color,false)--ui.get(Tabs) == "Visuals")
    Vis(OverrideSkeet,ui.get(Tabs) == "Anti-Aim")
    Vis(ManualLeft,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet) )
    Vis(AvoidBack,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) ) 
    Vis(killsay,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(enableRoundTime,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) ) 
    Vis(fastladder,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(animation,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(settingsdisableshadows,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ForceDefense,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ForceDefenseKey,ui.get(Tabs) == "Misc" and ui.get(OverrideSkeet) )
    Vis(ManualRight,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(ManualForward,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(Freestand,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet) )
    Vis(Builder.ConditionSelect,ui.get(Tabs) == "Anti-Aim" and ui.get(OverrideSkeet))
    Vis(Export,ui.get(OverrideSkeet))
    Vis(Import,ui.get(OverrideSkeet))
    Vis(XWAYCFG, ui.get(OverrideSkeet))
    Vis(DefaultCFG, ui.get(OverrideSkeet))
    Vis(animation_menu, ui.get(OverrideSkeet))
    Vis(fakelag_anim_menu, ui.get(OverrideSkeet))
    Vis(defensive_panel_icon, contains(ui.get(Windows),"Defensive panel") and ui.get(Tabs) == "Visuals")

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
        Vis(Builder[i]["TestExploit"], DefaultOnEnable)


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

function doExpoit(i)
    if ui.get(Builder[i]["TestExploit"]) then
        local randomyaw = client.random_int(60, 130)
        ui.set(GameSzensze[4][2], globals.tickcount() % 5 < 3 and randomyaw or -randomyaw)
        ui.set(GameSzensze[2][1], globals.tickcount() % 3 < 1 and "Up" or "Down")
    else
        ui.set(GameSzensze[2][1], ui.get(Builder[i]["Pitch"]))
    end
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
    if ui.get(Builder[i]["Pitch"]) ~= '\aDCE7FFFFExploit' then
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
        ui.set(GameSzensze[6][1], "Static")
        ui.set(GameSzensze[5][1], "Off")
        ui.set(GameSzensze[5][2], 0)
    end
    if manualaa() == 2 then
        ui.set(GameSzensze[4][2],90)
        ui.set(GameSzensze[6][1], "Static")
        ui.set(GameSzensze[5][1], "Off")
        ui.set(GameSzensze[5][2], 0)
    end
    if manualaa() == 3 then
        ui.set(GameSzensze[4][2],180)
        ui.set(GameSzensze[6][1], "Static")
        ui.set(GameSzensze[5][1], "Off")
        ui.set(GameSzensze[5][2], 0)
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

    doExpoit(i)
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
http.get("https://media.discordapp.net/attachments/1062810573814910987/1104889105202024488/cute_anime_girl_excited_by_cupcakes_renders_db9xl7r-fullview.png", function(success, response)
    if not success or response.status ~= 200 then
        return
    end

    logo = renderer.load_png(response.body, 40, 47)
end)

local my_country, image

http.get('https://api.country.is/', function(s,r)
    if s and r.status == 200 then
        local data = json.parse(r.body)
        my_country = data.country:lower()

        http.get("https://flagcdn.com/w40/" .. my_country .. ".png", function(s, r)
            if s and r.status == 200 then
                image = images.load(r.body)
            end
        end)
    end
end)

function manualaa_arrows() 
    local screen = {client.screen_size()}
    local r,g,b = ui.get(menu.color)
    if contains(ui.get(Windows),"Manual Arrows") == false then return end

    if manualaa() == 1 then
        --renderer.triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, r: number, g: number, b: number, a: number)
        renderer.triangle(screen[1] /2 - 40, screen[2] / 2 + 7, screen[1] / 2 - 48, screen[2] / 2, screen[1]/2 - 40, screen[2] /2 - 7, r,g,b,255)
    elseif manualaa() == 2 then
        renderer.triangle(screen[1] /2 + 40, screen[2] / 2 + 7, screen[1] / 2 + 48, screen[2] / 2, screen[1]/2 + 40, screen[2] /2 - 7, r,g,b,255)
    elseif manualaa() == 3 then
        renderer.triangle(screen[1] / 2 - 7, screen[2] / 2 - 7, screen[1] / 2, screen[2] / 2 - 15, screen[1] / 2 + 7, screen[2] / 2 - 7,r,g,b, 255)
    end
end

function watermark()
    local screen = {client.screen_size()}
    local r,g,b = ui.get(menu.color)

    local aA = { 
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
        {r,g,b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 0 / 30))}
    }

    if contains(ui.get(Windows),"Watermark") == false then 
        renderer.text(screen[1] - 55, screen[2] / 2, 255,255,255,255, "c", 0, string.format("\a%sM O N O \a%sC \a%sE \a%sR \a%sO \a%sS",RGBAtoHEX(r,g,b,255), RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5]))))
    else
        if image ~= nil then
            renderer.gradient(0,  screen[2] /2 - 2,  90,  22,  r,  g,  b,  150,  30,  30,  30,  0,  true)
            image:draw(2,screen[2] / 2 ,30,18)
            renderer.text(35, screen[2] /2, 255,255,255,255, "-", 0, "MONOCEROS")
            renderer.text(35, screen[2] /2 + 8, 255,255,255,255, "-", 0, "\aFFFFFFFF[\a"..RGBAtoHEX(r,g,b,255)..string.upper(obex_data.build).."\aFFFFFFFF]")
            debugguwnojebaane()
        end
    end
end

local best_enemy = nil
function get_best_enemy()
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

function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

function debugguwnojebaane()
    get_best_enemy()
    local screen = {client.screen_size()}
    local r,g,b = ui.get(menu.color)

    local kondycjaichuj = get_mode()
    local desync_amount = antiaim_funcs.get_desync(2)
    local target = best_enemy
    local def_percentichuj = math.floor(calculatePercentage(to_draw_ticks))

    renderer.text(1, screen[2] /2 + 40, 255,255,255,255, "-", 0, "-CONDITION: "..string.upper(Builder.Conditions[kondycjaichuj]))
    renderer.text(1, screen[2] /2 + 48, 255,255,255,255, "-", 0, "-DESYNC: "..string.upper(math.floor(desync_amount)))
    renderer.text(1, screen[2] /2 + 56, 255,255,255,255, "-", 0, "-TARGET: "..string.upper(entity.get_player_name(target)))
    renderer.text(1, screen[2] /2 + 64, 255,255,255,255, "-", 0, "-DEFENSIVE: "..string.upper(def_percentichuj))
    renderer.text(1, screen[2] /2 + 72, 255,255,255,255, "-", 0, "-OVERLAP: "..string.upper(math.floor(antiaim_funcs.get_overlap(float))))
end

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
    local string = string.format("Hit %s for %s [%s] in the %s [%s] [hc: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), e.damage, stored_shot.damage, hitgroup_names[e.hitgroup + 1] or '?', stored_shot.hitbox, math.floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
    table.insert(logs, {
        text = string
    }) 
    r,g,b = ui.get(menu.color)
    client.color_log(r, g, b, "[Monoceros] \0")
    client.color_log(255, 255, 255, string)
end
end

function missed(e)
    if contains(ui.get(Hitlogs),"Miss") then
        local string = string.format("Missed %s's %s due to %s [dmg: %s, bt: %s, lc: %s]", string.lower(entity.get_player_name(e.target)), stored_shot.hitbox, e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
        table.insert(logs, {
            text = string
        })
        r,g,b = ui.get(menu.color)
        client.color_log(r, g, b, "[gamesense] \0")
        client.color_log(255,129,129, string)
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
        renderer.text(screen[1]/2-20, screen[2]-logs[i].y:get(), 255,255,255,255,"c",0,logs[i].text)
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

local indicators_add_x = 0

local double_tap_transparency = 0
local hide_shots_transparency = 0
local damage_transparency = 0

total = 0
exploitready = 0 

sim_time_dt = 0
to_draw = "no"
to_up = "no"
to_draw_ticks = 0
go_ = "no"

function defensive_indicator()

--if not ui.get(gui.menu.defensive_dt_indicator) then return end

    X,Y = client.screen_size()
   
    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme <= -1 then
        to_draw = "yes"
        to_up = "yes"
        go_ = "yes"
     
    end
end 

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
    if self == nil or entity.is_alive(self) == false or contains(ui.get(Windows),"Indicators") == false then return end

    local x, y = client.screen_size()

    local indicators_color = {ui.get(menu.color)}

    local aA = { 
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 45 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 40 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 35 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 30 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 25 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 20 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 15 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 10 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 5 / 30))},
        {indicators_color[1],indicators_color[2], indicators_color[3], 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 0 / 30))}
    }

    indicators_add_x = lerp(indicators_add_x, entity.get_prop(self, 'm_bIsScoped') == 1 and 18 or 0, 17 * globals.frametime())

    --Monoceros
    renderer.text(x / 2 + math.floor(indicators_add_x), y / 2 + 17, 255, 255, 255, 255, 'c-', 0, string.upper(string.format("\a%sM\a%so\a%sn\a%so\a%sc\a%se\a%sr\a%so\a%ss", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8])), RGBAtoHEX(unpack(aA[9])))))

    double_tap_transparency = lerp(double_tap_transparency, ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2]) and 1 or 0, 20 * globals.frametime())
    hide_shots_transparency = lerp(hide_shots_transparency, ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2]) and not (ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])) and 1 or 0, 20 * globals.frametime())
    damage_transparency = lerp(damage_transparency, ui.get(reference.minimum_damage_override[1]) and ui.get(reference.minimum_damage_override[2]) and 1 or 0, 20 * globals.frametime())

    dton = ui.get(reference.double_tap[1]) and ui.get(reference.double_tap[2])
    hson = ui.get(reference.on_shot_anti_aim[1]) and ui.get(reference.on_shot_anti_aim[2])
    dmgon = ui.get(reference.minimum_damage_override[1]) and ui.get(reference.minimum_damage_override[2])
    dtcolor = dmgon and {indicators_color[1],indicators_color[2], indicators_color[3]} or {92,92,92}

    local m_indicators = {{text = "DT", color = dton and {indicators_color[1],indicators_color[2], indicators_color[3]} or {92,92,92}}, {text = "OS", color = hson and {indicators_color[1],indicators_color[2], indicators_color[3]} or {92,92,92}}}
    for i, v in pairs(m_indicators) do
        local r,g,b = unpack(v.color)
        renderer.text(x / 2 + math.floor(indicators_add_x) - 18 + i*12, y / 2 + 26, r,g,b, 255, 'c-', 0, v.text)
    end

    local kr, kg, kb = unpack(dtcolor)
    renderer.text(x / 2 + math.floor(indicators_add_x), y / 2 + 34, kr,kg,kb,255, 'c-', 0, 'DMG')
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
    watermark()
    manualaa_arrows() 
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

function calculatePercentage(ticks)
    local percentage = (ticks / 27) * 100
    return percentage
end

function defensive_indicator_paint()
    if to_draw == "yes" and ui.get(references.double_tap[2]) then

        draw_art = to_draw_ticks * 100 / 27
        r,g,b = ui.get(menu.color)

        renderer.text(X / 2 + 2, Y / 2 - 345, 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFFdefensive \a%schoking \aFFFFFFFF(\a%s%s%%\aFFFFFFFF)", RGBAtoHEX(r, g, b, 255), RGBAtoHEX(r, g, b, 255), math.floor(calculatePercentage(to_draw_ticks))))
        renderer.rectangle(X / 2 - 49,Y / 2 - 331,100,4,50,50,50,255)
        m_render.glow_module_notify(X / 2 - 49, Y/2 - 331,100,4,20,4,30,30,30,255,r,g,b,255, true)
        renderer.rectangle(X / 2,Y / 2 - 330,draw_art / 2,2,r,g,b,255)
        renderer.rectangle(X / 2,Y / 2 - 330,-draw_art / 2,2,r,g,b,255)
        if ui.get(defensive_panel_icon) then
            renderer.texture(logo, X / 2 - 20, Y / 2 - 400, 40, 47,255, 255, 255, 255,"f")
        end
        to_draw_ticks = to_draw_ticks + 1

        if to_draw_ticks == 27 then
            to_draw_ticks = 0
            to_draw = "no"
            to_up = "no"
        end
    end
end

local lerp = function(a, b, t)
    return a + (b - a) * t
end

should_animate = "start"
local y = 0
local alpha = 255
function intro_animation()

    -------------------> INTRO CHECKS <-------------------
    if should_animate == "start" or should_animate == "stop_intro" then
        should_animate = "should_intro"
    end

    
    -------------------> INTRO START <-------------------
    if should_animate == "should_intro" then
      
        X,Y = client.screen_size()

    
        y = lerp(y, Y / 2, globals.frametime() * 2)

         if y >= Y / 2 - 10 then
            alpha = lerp(alpha, 0, globals.frametime() * 1)
        end
        -------------------> INTRO TEXT <-------------------
        renderer.rectangle(X - X,Y - Y,X,Y,10,10,10,alpha )
        renderer.text(X / 2, y - 20, 255, 255, 255, alpha,"c+",0,"Monoceros")
        renderer.text(X / 2, y + 5, 255, 255, 255, alpha,"c",0,string.format("User - %s",obex_data.username))

        -------------------> INTRO STOP <-------------------
        if alpha <= 0 then
            should_animate = "stop" 
        end
    end

end

function notify:render_bottom(index, visible_amount)
    local screen = screen_size()

    local prefix_padding = 6

    local text = self:get_text()
    local text_size = measure_text('', text)
    local glow_steps = 8
    local padding = 5
    local text_width = prefix_padding + text_size.x
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

    m_render.glow_module_notify(x, y, w, h, 25, 5, 25, 25, 25, a, r, g, b, a, true)

    local offset = padding + 2

    renderer.text(x + offset + 2, y + h / 2 - text_size.y / 2, r, g, b, a, '', nil, text)
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
       -- print(conditions[cond])
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

Export = ui.new_button("AA", "Fake lag","Export",function()
    get_config_code()
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Exported'},
        {'successfully', true},
        {'!'}
    })
end)

Import = ui.new_button("AA", "Fake lag","Import",function()
    set_config(clipboard.get())
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Imported'},
        {'successfully', true},
        {'!'}
    })
end)

DefaultCFG = ui.new_button("AA", "Fake lag","Default",function()
    set_config("W2ZhbHNlX09mZl8wX0xvY2FsIHZpZXdfT2ZmX0RlZmF1bHRfMF8wXzE0NF9PZmZfMF8wXzE0NF8wXzBfMF8wXzBfT2ZmX1N0YXRpY18wXzBfZmFsc2VfMV9mYWxzZV9dLFt0cnVlX0RlZmF1bHRfMV9BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzFfMF8xNDRfT2Zmc2V0Xy0zMF8zXzE0NF8wXzBfMF8wXzBfSml0dGVyX1N0YXRpY18wXzBfZmFsc2VfMV90cnVlX10sW3RydWVfRGVmYXVsdF8xX0F0IHRhcmdldHNfMTgwX0RlZmF1bHRfN18tMTZfNzJfT2Zmc2V0XzE2Xy01XzE0NF8wXzBfMF8wXzBfSml0dGVyX1N0YXRpY18wXy03X2ZhbHNlXzFfdHJ1ZV9dLFt0cnVlX0RlZmF1bHRfMV9BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzNfLTE0XzkyX1NraXR0ZXJfMTBfLTEyXzE0NF8wXzBfMF8wXzBfT3Bwb3NpdGVfU3RhdGljXzBfMF9mYWxzZV8xX3RydWVfXSxbdHJ1ZV9EZWZhdWx0XzFfQXQgdGFyZ2V0c18xODBfRGVmYXVsdF81XzBfMTQ0X09mZnNldF8tM18tMTJfMTQ0XzBfMF8wXzBfMF9KaXR0ZXJfU3RhdGljXzBfMF9mYWxzZV8xX3RydWVfXSxbdHJ1ZV9EZWZhdWx0XzFfQXQgdGFyZ2V0c18xODBfRGVmYXVsdF81XzBfMTQ0X1NraXR0ZXJfN18tOV8xNDRfMF8wXzBfMF8wX09wcG9zaXRlX1N0YXRpY18wXzBfZmFsc2VfMV9mYWxzZV9dLFt0cnVlX0RlZmF1bHRfMV9BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzdfMF8xNDRfT2Zmc2V0Xy0xNl8tMTJfMTQ0XzBfMF8wXzBfMF9PcHBvc2l0ZV9KaXR0ZXIgTC1SXzE0Xy0xMl9mYWxzZV8xX2ZhbHNlX10s")
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'Default config'},
        {'successfully imported', true},
        {'!'}
    })
end)

XWAYCFG = ui.new_button("AA", "Fake lag","X-WAY",function()
    set_config("W2ZhbHNlX09mZl8wX0xvY2FsIHZpZXdfT2ZmX0RlZmF1bHRfMF8wXzE0NF9PZmZfMF8wXzE0NF8wXzBfMF8wXzBfT2ZmX1N0YXRpY18wXzBfZmFsc2VfMV9mYWxzZV9dLFt0cnVlX0Rvd25fM19BdCB0YXJnZXRzXzE4MF9Td2l0Y2ggQmV0d2Vlbl8tOV8xMF8xMzdfWC1XYXlfLTNfMV8xNDRfMjZfNDNfNTRfMF8wX0ppdHRlcl9KaXR0ZXIgTC1SXzBfMF90cnVlXzNfdHJ1ZV9dLFt0cnVlX0Rvd25fM19BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzdfMF8xNDRfQ2VudGVyXzlfLTNfMTQ0XzBfMF8wXzBfMF9KaXR0ZXJfSml0dGVyIEwtUl8tMTZfMTBfZmFsc2VfMV90cnVlX10sW3RydWVfRG93bl8zX0F0IHRhcmdldHNfMTgwX1N3aXRjaCBCZXR3ZWVuXzE1Xy0xMF8xMzVfWC1XYXlfNzVfNDFfMTM3XzYzXy0zNl8zNl8wXzBfSml0dGVyX0ppdHRlciBMLVJfLTM3XzE5X2ZhbHNlXzNfdHJ1ZV9dLFt0cnVlX0Rvd25fM19BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzdfMF8xNDRfWC1XYXlfNTVfNzdfMTQ0XzI4Xy0yXzU0XzYwXzBfSml0dGVyX0ppdHRlciBMLVJfLTI3XzEyX2ZhbHNlXzNfdHJ1ZV9dLFt0cnVlX0Rvd25fM19BdCB0YXJnZXRzXzE4MF9EZWZhdWx0XzEwXy0xNV8xX0NlbnRlcl81N181OV8xNDRfMF8wXzBfMF8wX0ppdHRlcl9TdGF0aWNfM18wX2ZhbHNlXzFfZmFsc2VfXSxbdHJ1ZV9Eb3duXzNfQXQgdGFyZ2V0c18xODBfRGVmYXVsdF8wXzBfMTQ0X0NlbnRlcl8wXzBfMTQ0XzBfMF8wXzBfMF9KaXR0ZXJfSml0dGVyIEwtUl8tMl80X2ZhbHNlXzFfZmFsc2VfXSw=")
	
	    ui.set(Indicators, true)
		
	    local r, g, b = ui.get(indicators_color)

    notify.new_bottom(5, {r, g, b}, {
        {'X-WAY config'},
        {'successfully imported', true},
        {'!'}
    })
end)


client.set_event_callback('setup_command', function(cmd)
    local self = entity.get_local_player()
	 if entity.get_prop(self, 'm_MoveType') == 9 then print_state_id = 9; print_state = 'climbing' elseif self_planting == true and planting == true then print_state_id = 8; print_state = 'planting' elseif entity.get_prop(self, 'm_bIsDefusing') == 1 then print_state_id = 7; print_state = 'defusing' elseif cmd.in_use == 1 and entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 0 then print_state_id = 6; print_state = 'using' elseif (cmd.in_jump == 1 or bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0) and entity.get_prop(entity.get_game_rules(), 'm_bFreezePeriod') == 0 then print_state_id = 5; print_state = 'jumping' elseif entity.get_prop(self, 'm_flDuckAmount') > 0.8 and bit.band(cmd.buttons, 1) == 0 or ui.get(reference.duck_peek_assist) then print_state_id = 4; print_state = 'crouching' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and bit.band(cmd.buttons, 1) == 0 and (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) then print_state_id = 3; print_state = 'walking' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() > 2 and bit.band(cmd.buttons, 1) == 0 and not (ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])) then print_state_id = 2; print_state = 'moving' elseif vector(entity.get_prop(self, 'm_vecVelocity')):length() < 2 and bit.band(cmd.buttons, bit.lshift(1, 0)) == 0 then print_state_id = 1; print_state = 'standing' end
    if self == nil or entity.is_alive(self) == false then return end
    if ui.get(ForceDefense) or ui.get(ForceDefenseKey) and bit.band(entity.get_prop(self, 'm_fFlags'), 1) == 0 then
        cmd.force_defensive = globals.tickcount() % 5 < 3
    end
    defensive_indicator()
end)

client.set_event_callback('setup_command', function(e)
    local weaponn = entity.get_player_weapon()
    if ui.get(OverrideSkeet) then
        if get_mode() ~= nil then
            if ui.get(Builder[get_mode()]["Enable"]) then
                DoAntiAim(get_mode())
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
        {'to monoceros', true},
        {'~ ' .. obex_data.build},
        {'!'}
    })
end)

client.set_event_callback('paint_ui', function()
    intro_animation()
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
    if contains(ui.get(Windows),"Defensive panel") then 
        defensive_indicator_paint()
    end
    local sw, sh = client.screen_size()
    local x, y = sw / 2, sh - 200

    if contains(ui.get(Windows),"Min damage indicator") then 
        if ui.get(mindmgov[2]) then
            client.draw_text(ctx, sw / 2+9, sh / 2.5+100, 255,255,255, 255, "c", 0, ui.get(mindmgov[3]))
        end
    end
end

client.set_event_callback('paint', on_paint)

client.set_event_callback('shutdown', function()
    cvar.cl_csm_shadows:set_int(1)
end)

-- Killsay

local client_exec, client_set_event_callback, client_system_time, client_userid_to_entindex, entity_get_local_player, entity_get_player_name, entity_get_prop, string_format, ui_get, ui_new_checkbox, ui_new_textbox, ui_set_callback = client.exec, client.set_event_callback, client.system_time, client.userid_to_entindex, entity.get_local_player, entity.get_player_name, entity.get_prop, string.format, ui.get, ui.new_checkbox, ui.new_textbox, ui.set_callback

-- Create a new checkbox UI element with the label "Toggle Feature"
--local feature_enabled = ui_new_checkbox("AA", "Anti-aimbot angles", "Killsay")

killsay = ui.new_checkbox('AA', 'Anti-aimbot angles',"Killsay")

local rand = math.random

local function player_death(e)
    -- Check if the feature is enabled in the UI
    if not ui_get(killsay) then
        return
    end

    local attacker_entindex = client_userid_to_entindex(e.attacker)
    local victim_entindex = client_userid_to_entindex(e.userid)
    if attacker_entindex ~= entity_get_local_player() then
        return
    end
    local x = rand(1, 6)
    if (x == 1) then
        client_exec("say 1")
    end
    if (x == 2) then
        client_exec("say walkbot")
    end
    if (x == 3) then
        client_exec("say sit nn dog")
    end
    if (x == 4) then
        client_exec("say 1")
    end
    if (x == 5) then
        client_exec("say get good get monoceros")
    end
    if (x == 6) then
        client_exec("say 1")
    end
end

client_set_event_callback("player_death", player_death)

-- Add a callback function to the checkbox UI element
ui_set_callback(killsay, function()
    -- Add your logic here for when the checkbox is checked or unchecked
end)

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
end)

--fast ladder 

local entity_get_prop = entity.get_prop
local ui_get = ui.get
local client_camera_angles = client.camera_angles

fastladder = ui.new_multiselect("AA", "Anti-aimbot angles", " Fast ladder", "Up", "Down")

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



-- Animations

require 'bit'

local options = { "Static Legs", "Pitch 0 on land", "Moonwalk" }
animation = ui.new_multiselect("AA", "Anti-aimbot angles", " Animations", options)

local fakelag = ui.reference("AA", "Fake lag", "Limit")
local ground_ticks, end_time = 1, 0
local original_pitch = 0

local ent = require "gamesense/entity"

client.set_event_callback("pre_render", function()
    if not entity.is_alive(entity.get_local_player()) then
        return
    end

    if ui.get(animation) then
        for i, v in ipairs(ui.get(animation)) do
            if v == "Static Legs" then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
            elseif v == "Pitch 0 on land" then
                local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

                if on_ground == 1 then
                    ground_ticks = ground_ticks + 1
                    original_pitch = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 12)
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 12)
                else
                    ground_ticks = 0
                    end_time = globals.curtime() + 1
                end

                if ground_ticks > ui.get(fakelag) + 1 and end_time > globals.curtime() then
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
                else
                    entity.set_prop(entity.get_local_player(), "m_flPoseParameter", original_pitch, 12)
                end
            elseif v == "Moonwalk" then
                local me = ent.get_local_player()
                local m_fFlags = me:get_prop("m_fFlags")
                local is_onground = bit.band(m_fFlags, 1) ~= 0
                if not is_onground then
                    local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
                    my_animlayer.weight = 1
                end
            end
        end
    end
end)

-- disable Anti-aim on warm up

local function getRoundTime()
    local game_rules = entity.get_game_rules()
    if not game_rules then
        return
    end
    return entity.get_prop(game_rules, "m_bWarmupPeriod")
end

client.set_event_callback("setup_command", function(e)
    if ui.get(enableRoundTime) then
        local game_rules = entity.get_game_rules()
        if game_rules and entity.get_prop(game_rules, "m_bWarmupPeriod") == 1 then
--ui.set(GameSzensze[1], false)
            ui.set(GameSzensze[5][2], math.random(-180,180))
        else
            ui.set(GameSzensze[1], true)
        end
    end
end)

