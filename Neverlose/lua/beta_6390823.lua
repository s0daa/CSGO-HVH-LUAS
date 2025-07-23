-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local MTools = require "neverlose/mtools"
local clipboard = require "neverlose/clipboard"
local csgo_weapons = require "neverlose/csgo_weapons"
local gradient = require "neverlose/gradient"
local vector = require "vector"
local pui = require "neverlose/pui"
local ffi = require "ffi"
local data = require "neverlose/anti_aim"
local Exploits = require "neverlose/exploits"
local system = require "neverlose/drag_system"
local base64 = require "neverlose/base64"

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    
    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } animstate_layer_t;

    typedef struct {
        float m_flPoseParameter[24]; // Assuming it has 24 elements
    } CPlayer;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local lp = entity.get_local_player()
local animslsg = nil

local gradient_animation = gradient.text_animate("lonely", -0.8, {
    color(255, 255, 255),
    color(192, 192, 192),
    color(128, 128, 128)
})

events.render:set(function(ctx)
    sidebar = ui.sidebar(gradient_animation:get_animated_text(), "sparkles")
    gradient_animation:animate()
end)

local ui_main = pui.create("About", "About")
local ui_main2 = pui.create("About", "Links")
local ui_config = pui.create("About", "Config")

local ui_list = pui.create("Main", " ")
local list = ui_list:list("", "Builder", "Tweaks", "Visuals / Misc")
local ui_aa1 = pui.create("Main", "Main")
local ui_aa = pui.create("Main", "State")
local ui_aa2 = pui.create("Main", " ")
local ui_aa4 = pui.create("Main", "")
local ui_aa3 = pui.create("Main", "Builder")
local labelforspace = ui_aa4:switch("Anti bruteforce")
local labelfortweaks = ui_aa4:label("Meow")

ui_main:label("\aFFFFFFFFWelcome back to lonely, \aAAAAAAFF" .. common.get_username() .. "\aFFFFFFFF.\n\bFFFFFF\bAAAAAA[Are you ready to kill 'em all?!]")

ui_main2:button("🔗 Discord", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/uhPHuAGUaX") end)

local main_aa_switch = ui_aa1:switch("Enabled")
local manuals = ui_aa1:switch("Manuals")
local manualref = manuals:create()
local manual_left = manualref:hotkey("Manual Left", 0x5A)
local manual_right = manualref:hotkey("Manual Right", 0x58)
local espam = manualref:switch("Flick Opposite on manual")

local state = ui_aa:combo("State", {"FakeLag", "Stand", "Walk", "Slowwalk", "Air", "AirDuck", "Duck", "DuckRun"})

local ui_visuals = pui.create("Main", "Visuals")
local ui_misc = pui.create("Main", "Misc")
local manualindswitch = ui_visuals:switch("Manual indicator")
local desyncindswitch = ui_visuals:switch("Desync arrows")
local custom_scope = ui_visuals:switch("Custom scope")
local dmgind = ui_visuals:switch("Minimum damage indicator")
local hitlogs = ui_visuals:switch("Hit logs")
local centerind = ui_visuals:switch("Center indicators")

local menu = {}

local tooltips = {
    [59] = 'Off', [177] = '16:9', [160] = '16:10', 
    [150] = '3:2', [133] = '4:3', [125] = '5:4'
}

local aspect_ratio = ui_visuals:slider('Aspect Ratio', 59, 200, 59, 0.01, function(v)
    return tooltips[v]
end)

local animfix = ui_visuals:label("Animfix")

----
local animfix_ref = animfix:create()
local animfix_lisable = animfix_ref:selectable("", "Jitter legs on land", "Static legs in air", "Kangaroo")
----
local custom_scope_ref = custom_scope:create()
local custom_scope_color = custom_scope_ref:color_picker("Color", color(255, 255, 255, 255))
local custom_scope_gap = custom_scope_ref:slider("Gap", 0, 200, 0)
local custom_scope_size = custom_scope_ref:slider("Size", 0, 320, 0)
----
local tag = ui_misc:switch("Clantag")
local nofall = ui_misc:switch("No fall")
local fastladder = ui_misc:switch("Fast ladder")
local toss = ui_misc:switch("Super toss")
local tt = ui_misc:switch("Kill say")
----

local freestandswitch = ui_aa2:switch("Freestanding")
local freestandref = freestandswitch:create()
local freestanddisabler = freestandref:selectable("Disabler", "Stand", "Walk", "Slowwalk", "Air", "AirDuck", "Duck", "DuckRun")
local freestandbite = freestandref:switch("Peek opposite")
local safehead = ui_aa2:selectable("Safehead mode", "Knife", "Zeus")
local pingunlock = ui_aa2:switch("Ping unlock")
local ping_ref = pingunlock:create()
local ping_slider = ping_ref:slider("Ping value", 0, 200, 0)
local legitaa = ui_aa2:switch("Legit AA")
local fakelagalternative = ui_aa2:switch("Alternative fakelags")
local tweakss = ui_aa2:selectable("Tweaks", "Bombsite e fix", "Warmup AA")
local states = {"FakeLag", "Stand", "Walk", "Slowwalk", "Air", "AirDuck", "Duck", "DuckRun"}
local settings = {}

for _, state_name in ipairs(states) do
    settings[state_name] = {
        offset_left = ui_aa3:slider("Offset left", -180, 180, 0):visibility(false),
        offset_right = ui_aa3:slider("Offset right", -180, 180, 0):visibility(false),
        bodyyawslider = ui_aa3:switch("Body yaw"):visibility(false),
        random = ui_aa3:slider("Randomization", 0, 100, 0):visibility(false),
        speed = ui_aa3:slider("Delay", 1, 10, 1):visibility(false),
        body_ref = nil,
        body_combo = nil,
        body_left = nil,
        body_right = nil,
        switch_def = nil,
        def_ref = nil,
        pitch_def = nil,
        yaw_def = nil,
        delay_ref = nil,
        delay_random = nil
    }

    local current_state = settings[state_name]
    current_state.body_ref = current_state.bodyyawslider:create():visibility(false)
    current_state.body_combo = current_state.body_ref:combo("Body Type", {"Left", "Right", "Jitter"}):visibility(false)
    current_state.body_left = current_state.body_ref:slider("Body Left", 0, 58, 0):visibility(false)
    current_state.body_right = current_state.body_ref:slider("Body Right", 0, 58, 0):visibility(false)
    current_state.delay_ref = current_state.speed:create():visibility(false)
    current_state.delay_random = current_state.delay_ref:slider("Delay random", 0, 10, 0):visibility(false)

    if state_name ~= "FakeLag" then
        current_state.switch_def = ui_aa3:switch("Force Defensive"):visibility(false)
        current_state.def_ref = current_state.switch_def:create():visibility(false)
        current_state.pitch_def = current_state.def_ref:combo("Defensive Pitch", {"Up", "Down", "Zero", "Semi up", "Semi down", "Switch", "Sway", "Fast sway"}):visibility(false)
        current_state.yaw_def = current_state.def_ref:combo("Defensive Yaw", {"Sideways", "Spin", "Slow spin", "Random", "Opposite"}):visibility(false)
    end
end

local angle = 79
local increment = 0

local function customsway()
    if angle >= 79 then
        increment = -1
    elseif angle <= -79 then
        increment = 1
    end

    angle = angle + increment
    return angle
end

local angle1 = 89
local increment1 = 0

local function fast_customsway()
    if angle1 >= 79 then
        increment1 = -3
    elseif angle1 <= -79 then
        increment1 = 3
    end

    angle1 = angle1 + increment1
    return angle1
end

local function update_visibility()
    local list_value = list:get()

    local aa_visible = list_value == 1
    main_aa_switch:visibility(aa_visible)

    if aa_visible then
        local switch_state = main_aa_switch:get(false)
        
        manuals:visibility(switch_state)
        manual_left:visibility(switch_state)
        manual_right:visibility(switch_state)
        espam:visibility(switch_state)
        state:visibility(switch_state)
        labelforspace:visibility(switch_state)

        for state_name, controls in pairs(settings) do
            for _, element in pairs(controls) do
                if element then
                    element:visibility(switch_state and state:get() == state_name)
                end
            end
        end
    else
        manuals:visibility(false)
        manual_left:visibility(false)
        manual_right:visibility(false)
        espam:visibility(false)
        state:visibility(false)
        labelforspace:visibility(false)

        for _, controls in pairs(settings) do
            for _, element in pairs(controls) do
                if element then
                    element:visibility(false)
                end
            end
        end
    end

    local misc_visible = list_value == 3
    
    manualindswitch:visibility(misc_visible)
    desyncindswitch:visibility(misc_visible)
    custom_scope:visibility(misc_visible)
    dmgind:visibility(misc_visible)
    animfix:visibility(misc_visible)
    tag:visibility(misc_visible)
    tt:visibility(misc_visible)
    centerind:visibility(misc_visible)
    fastladder:visibility(misc_visible)
    nofall:visibility(misc_visible)
    toss:visibility(misc_visible)
    hitlogs:visibility(misc_visible)
    aspect_ratio:visibility(misc_visible)

    if not misc_visible then
        manualindswitch:visibility(false)
        desyncindswitch:visibility(false)
        centerind:visibility(false)
        custom_scope:visibility(false)
        dmgind:visibility(false)
        animfix:visibility(false)
        tag:visibility(false)
        tt:visibility(false)
        toss:visibility(false)
        fastladder:visibility(false)
        nofall:visibility(false)
        hitlogs:visibility(false)
        aspect_ratio:visibility(false)
    end

    local aa2_visible = list_value == 2
    
    freestandswitch:visibility(aa2_visible)
    freestandbite:visibility(aa2_visible)
    safehead:visibility(aa2_visible)
    pingunlock:visibility(aa2_visible)
    ping_slider:visibility(aa2_visible)
    legitaa:visibility(aa2_visible)
    fakelagalternative:visibility(aa2_visible)
    tweakss:visibility(aa2_visible)
    labelfortweaks:visibility(aa2_visible)

    if not aa2_visible then
        freestandswitch:visibility(false)
        freestandbite:visibility(false)
        safehead:visibility(false)
        pingunlock:visibility(false)
        ping_slider:visibility(false)
        legitaa:visibility(false)
        fakelagalternative:visibility(false)
        tweakss:visibility(false)
        labelfortweaks:visibility(false)
    end
end

update_visibility()

state:set_callback(update_visibility)
main_aa_switch:set_callback(update_visibility)
list:set_callback(update_visibility)

local function override_setts()
    if main_aa_switch:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):override(true)
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Down")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Backward")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"):override("At target")
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"):override(true)
        ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Break LC")
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"):override("Local view")
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"):override(false)
        ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override("Favor Fire Rate")
    end
end


local function smoothJitter(switchyaw1, switchyaw2, speed)
    local localPlayer = entity.get_local_player()

    if localPlayer == nil or not localPlayer:is_alive() or not globals.is_connected then
        return
    end

    if jitter_timer == nil then
        jitter_timer = 0
    end

    local speed2 = speed
    local interval = math.max(1, speed2)

    if globals.choked_commands == 0 then
        jitter_timer = jitter_timer + 1

        if jitter_timer % interval == 0 then
            jitter_state = not jitter_state
        end
    end

    local yawforadd = 0
    if jitter_state then
        yawforadd = switchyaw1
        invrt = 1
    else
        yawforadd = switchyaw2
        invrt = 2
    end

    return yawforadd
end

local function forinvert(switchyaw1, switchyaw2, speed)
    local yawforadd = smoothJitter(switchyaw1, switchyaw2, speed)
    
    if yawforadd == switchyaw1 then
        return true
    else
        return false
    end
end

local function ExtendedMTools()
    MTools.AntiAims.Condition.Update()

    local player = entity.get_local_player()
    if not player or not player:is_alive() then
        return
    end

    local velocity_vector = player.m_vecVelocity

    if not velocity_vector then
        return
    end

    local velocity_x = velocity_vector.x
    local velocity_y = velocity_vector.y

    local velocity = math.sqrt(velocity_x^2 + velocity_y^2)
    local condition = MTools.AntiAims.Condition:Get()

    if condition == "C" and velocity > 13 then
        return "CR"
    end
    
    return condition
end

local last_bullet_near_time = 0

function distance_to_line(point, line_start, line_end)
    local line_dir = (line_end - line_start):normalized()
    local point_to_line_start = point - line_start
    local projection_length = point_to_line_start:dot(line_dir)
    local projection_point = line_start + (line_dir * projection_length)
    return (point - projection_point):length()
end

function process_bullet_impact(e)
    local attacker_userid = e.userid
    local get_attacker_as_player = entity.get(attacker_userid, true)

    if not get_attacker_as_player then
        return
    end

    if get_attacker_as_player == entity.get_local_player() then
        return
    end

    local self_eye_position = entity.get_local_player():get_eye_position()
    local enemy_eye_position = get_attacker_as_player:get_eye_position()
    local bullet_impact_position = vector(e.x, e.y, e.z)

    local distance_to_bullet = distance_to_line(self_eye_position, enemy_eye_position, bullet_impact_position)

    if distance_to_bullet < 50 then
        on_bullet_nearby()
    end
end

local function updateAA()
    MTools.AntiAims.Condition.Update()
    local condition = ExtendedMTools()
    local switchyaw1, switchyaw2, speed, body_left_limits, body_right_limits, bodytype, bodyen, speedrandom
    local lp = entity.get_local_player()

    if lp == nil or not lp:is_alive() or not globals.is_connected then
        speed = 1
        switchyaw1 = 0
        switchyaw2 = 0
        body_left_limits = 0
        body_right_limits = 0
        bodytype = nil
        bodyen = false
    else
        local current_settings = nil

        if condition == "S" then
            current_settings = settings.Stand
        elseif condition == "A" then
            current_settings = settings.Air
        elseif condition == "AC" then
            current_settings = settings.AirDuck
        elseif condition == "W" then
            current_settings = settings.Walk
        elseif condition == "C" then
            current_settings = settings.Duck
        elseif condition == "SW" then
            current_settings = settings.Slowwalk
        elseif condition == "CR" then
            current_settings = settings.DuckRun
        elseif condition == "NE" then
            current_settings = settings.FakeLag
        end

        if current_settings then
            switchyaw1 = current_settings.offset_left:get() + math.random(0, current_settings.random:get())
            switchyaw2 = current_settings.offset_right:get() + math.random(0, current_settings.random:get())
            speed = current_settings.speed:get() + math.random(0, current_settings.delay_random:get())
            body_left_limits = current_settings.body_left:get()
            body_right_limits = current_settings.body_right:get()
            bodytype = current_settings.body_combo:get()
            bodyen = current_settings.bodyyawslider:get()
        end

        if globals.curtime and globals.curtime - last_bullet_near_time <= 2 and labelforspace:get(true) then
            local random_addition_yaw1 = math.random(-3, 3)
            local random_addition_yaw2 = math.random(-3, 3)
            local random_addition_body_left = math.random(-3, 3)
            local random_addition_body_right = math.random(-3, 3)
            
            switchyaw1 = switchyaw1 + random_addition_yaw1
            switchyaw2 = switchyaw2 + random_addition_yaw2
            body_left_limits = body_left_limits + random_addition_body_left
            body_right_limits = body_right_limits + random_addition_body_right
        end
    end

    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(smoothJitter(switchyaw1, switchyaw2, speed))

    if bodyen then
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):set(true)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"):set(body_left_limits)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"):set(body_right_limits)
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):set(false)
    end

    if bodytype == "Jitter" then
        if invrt == 1 then
            rage.antiaim:inverter(true)
        elseif invrt == 2 then
            rage.antiaim:inverter(false)
        end
    elseif bodytype == "Left" then
        rage.antiaim:inverter(true)
    elseif bodytype == "Right" then
        rage.antiaim:inverter(false)
    end
end

function on_bullet_nearby()
    last_bullet_near_time = globals.curtime
end

events.bullet_impact:set(function(e)
    process_bullet_impact(e)
end)


local forrealtime = 0

local function smoothJitterfordefaa(switchyaw1, switchyaw2, speed)
    local finalyawgg
    local lp = entity.get_local_player()

    if lp == nil or not lp:is_alive() or not globals.is_connected then
        return nil
    end

    if forrealtime == 0 then
        forrealtime = globals.realtime
    end

    local speed_adjusted = speed + 3

    if globals.realtime > forrealtime + 1 / (speed_adjusted * 2) then
        finalyawgg = switchyaw1
        if globals.realtime - forrealtime > 2 / (speed_adjusted * 2) then
            forrealtime = globals.realtime
        end
    else
        finalyawgg = switchyaw2
    end

    return finalyawgg
end

local rotations = 0
local pitch_sleap = 45
local last_yaw_def = 0

function update_yaw_and_pitch()
    local yaw_def = math.normalize_yaw(globals.curtime * -650)

    if (last_yaw_def < 0 and yaw_def >= 0) or (last_yaw_def > 0 and yaw_def <= 0) then
        rotations = rotations + 1

        if rotations % 8 == 0 then
            if pitch_sleap == 45 then
                pitch_sleap = -45
            else
                pitch_sleap = 45
            end
        end
    end

    last_yaw_def = yaw_def

    return yaw_def
end



local function deff_pitch(condition)
    local pitch_def = 0
    if condition.pitch_def:get() == "Up" then
        pitch_def = -89
    elseif condition.pitch_def:get() == "Down" then
        pitch_def = 89
    elseif condition.pitch_def:get() == "Zero" then
        pitch_def = 0
    elseif condition.pitch_def:get() == "Semi up" then
        pitch_def = -44
    elseif condition.pitch_def:get() == "Semi down" then
        pitch_def = 44
    elseif condition.pitch_def:get() == "Sway" then
        pitch_def = customsway()
    elseif condition.pitch_def:get() == "Fast sway" then
        pitch_def = fast_customsway()
    elseif condition.pitch_def:get() == "Switch" then
        pitch_def = pitch_sleap
    end
    return pitch_def
end

local function deff_yaw(condition)
    local yaw_def = 0
    if condition.yaw_def:get() == "Sideways" then
        yaw_def = smoothJitterfordefaa(90, -90, 5)
    elseif condition.yaw_def:get() == "Spin" then
        yaw_def = update_yaw_and_pitch()
    elseif condition.yaw_def:get() == "Slow spin" then
        yaw_def = math.normalize_yaw(globals.curtime * -250)
    elseif condition.yaw_def:get() == "Random" then
        yaw_def = math.random(180, -180)
    elseif condition.yaw_def:get() == "Opposite" then
        yaw_def = 180
    end
    return yaw_def
end

local function deffaa()
    MTools.AntiAims.Condition.Update()
    local condition = ExtendedMTools()

    local hidden_option = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
    if hidden_option then
        hidden_option:override(false)
    end

    local current_settings = nil
    local pitch_def, yaw_def = 89, 0

    local current_settings

    if condition == "S" then
        current_settings = settings.Stand
    elseif condition == "W" then
        current_settings = settings.Walk
    elseif condition == "SW" then
        current_settings = settings.Slowwalk
    elseif condition == "A" then
        current_settings = settings.Air
    elseif condition == "AC" then
        current_settings = settings.AirDuck
    elseif condition == "C" then
        current_settings = settings.Duck
    elseif condition == "CR" then
        current_settings = settings.DuckRun
    end
    

    if current_settings and current_settings.switch_def:get(true) then
        pitch_def = deff_pitch(current_settings)
        yaw_def = deff_yaw(current_settings)

        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always on")
        hidden_option:override(true)
        rage.antiaim:override_hidden_pitch(pitch_def)
        rage.antiaim:override_hidden_yaw_offset(yaw_def)

        if condition == "AC" or condition == "CR" then
            ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):override("Disabled")
        end
    else
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("On peek")
        hidden_option:override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"):override(0)
        rage.antiaim:override_hidden_pitch(89)
        rage.antiaim:override_hidden_yaw_offset(0)
    end
end

---fakelag
local valuesmooth = 20
local incrementsmooth = 0.5
local directionsmooth = 1

local function lag_sway()
    if directionsmooth == 1 then
        valuesmooth = valuesmooth + incrementsmooth
        if valuesmooth >= 40 then
            directionsmooth = -1
        end
    elseif directionsmooth == -1 then
        valuesmooth = valuesmooth - incrementsmooth
        if valuesmooth <= 20 then
            directionsmooth = 1
        end
    end
    return valuesmooth
end

local function alternatfakelag()
    if not fakelagalternative:get(true) then
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"):override(0)
    end
    if fakelagalternative:get(true) then
        ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"):override(lag_sway())
    end
end


local function is_bind()
    local binds = ui.get_binds()
    for _, bind in ipairs(binds) do
        if bind.name == "Body Aim" and bind.active then
            return true
        end
    end
    return false
end

local function is_scout()
    local local_player = entity.get_local_player()
    if not local_player then return false end
    local weapon = csgo_weapons(local_player:get_player_weapon())
    if not weapon then return false end
    return weapon.name == "SSG 08"
end


local function prevent_bomb_plant(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() or not globals.is_connected then
        return
    end

    local team_num = lp.m_iTeamNum
    local on_bombsite = lp.m_bInBombZone
    local has_bomb = lp.m_hActiveWeapon and lp.m_hActiveWeapon:get_classname() == "CC4"

    if on_bombsite and team_num == 2 and not has_bomb and tweakss:get("Bombsite e fix") then
        cmd.in_use = false
    end
end

local object_detected = false

local function angle_to_vector(pitch, yaw)
    local rad_pitch = math.rad(pitch)
    local rad_yaw = math.rad(yaw)

    local x = math.cos(rad_pitch) * math.cos(rad_yaw)
    local y = math.cos(rad_pitch) * math.sin(rad_yaw)
    local z = -math.sin(rad_pitch)

    return vector(x, y, z)
end

local function trace_direction(lp, direction_vector)
    local eye_pos = lp:get_eye_position()
    local trace_end = eye_pos + direction_vector * 125
    return utils.trace_line(eye_pos, trace_end, lp)
end

local function legit_aa(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() or not globals.is_connected then return end

    local on_bombsite = lp.m_bInBombZone
    local view_angles = lp.m_angEyeAngles
    local forward = angle_to_vector(view_angles.x, view_angles.y)
    local right = angle_to_vector(view_angles.x, view_angles.y + 90)
    local left = angle_to_vector(view_angles.x, view_angles.y - 90)
    local back = angle_to_vector(view_angles.x, view_angles.y + 180)

    local directions = {forward, right, left, back, (forward + right):normalize(), (forward + left):normalize(), (back + right):normalize(), (back + left):normalize()}

    local is_using_object = false

    for _, direction in ipairs(directions) do
        local trace_result = trace_direction(lp, direction)
        if trace_result and trace_result.entity then
            local classname = trace_result.entity:get_classname()
            if classname == "CBaseDoor" or classname == "CBaseButton" or classname == "func_door" or classname == "CPropDoorRotating" then
                is_using_object = true
                break
            end
        end
    end

    if legitaa:get(true) and common.is_button_down(0x45) and not on_bombsite and not is_using_object then
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):override(true)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"):override(58)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"):override(58)
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"):override("Local view")
        cmd.in_use = false
    elseif on_bombsite or is_using_object then
        cmd.in_use = cmd.in_use
    end
end

local clan_tags = {
    "~lonely~", "~lonely", "~lonel", "~lone", "~lon", "~lo", "~l", "~", " ", "~",
    "~l", "~lo", "~lon", "~lone", "~lonel", "~lonely", "~lonely~"
}

local current_tag = 1
local update_interval = 0.5
local last_update_time = 0

function clan_tag()
    if not globals.is_connected then
        current_tag = 1
        return
    end

    if not tag:get(true) then
        ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"):set(true)
        ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"):set(false)
        return
    end

    if globals.curtime - last_update_time >= update_interval then
        common.set_clan_tag(clan_tags[current_tag])
        current_tag = current_tag + 1
        if current_tag > #clan_tags then
            current_tag = 1
        end
        last_update_time = globals.curtime
    end
end

local font = render.load_font("Verdana", 13, "a")

local function create_gradient_text()
    local text = "lonely"
    local gradient_animation = gradient.text_animate(text, -0.8, {
        color(255, 255, 255),
        color(128, 128, 128),
        color(128, 128, 128)
    })
    return gradient_animation
end

local function draw_indicator()
    local lp = entity.get_local_player()

    if not lp or not lp:is_alive() or not globals.is_connected then
        return
    end
    local screen_size = render.screen_size()
    local screen_width = screen_size.x
    local screen_height = screen_size.y
    
    local width = 65
    local height = 15
    local x = (screen_width - width) / 2
    local y = screen_height - height

    local gradient_animation = create_gradient_text()
    
    render.rect(vector(x, y), vector(x + width, y + height), color(0, 0, 0, 150))

    render.rect(vector(x, y + 0.7), vector(x + 8, y + 1.7), color(128, 128, 128, 255))
    render.rect(vector(x, y + 0.7), vector(x + 1, y + 8.7), color(128, 128, 128, 255))
    
    render.rect(vector(x + width - 8, y + 0.7), vector(x + width, y + 1.7), color(128, 128, 128, 255))
    render.rect(vector(x + width - 1, y + 0.7), vector(x + width, y + 8.7), color(128, 128, 128, 255))

    render.text(font, vector(x + width / 2, y + height / 2 - 0.4), color(255, 255, 255, 255), "c", gradient_animation:get_animated_text())

    gradient_animation:animate()
end


events.render:set(function()
    draw_indicator()
end)

local font1 = render.load_font("Arial", 11, "a b")

local valuepitch = -10
local swpte = 2
local directions1 = 1

local function pitchpeek()
    if directions1 == 1 then
        valuepitch = valuepitch + swpte
        if valuepitch >= 10 then
            directions1 = -1
        end
    elseif directions1 == -1 then
        valuepitch = valuepitch - swpte
        if valuepitch <= -10 then
            directions1 = 1
        end
    end
    return valuepitch
end


local function sfreestand()
    if not freestandswitch:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"):override(false)
        return
    end

    local condition = ExtendedMTools()
    local disabler_conditions = freestanddisabler:get()

    if not disabler_conditions then
        return
    end

    local is_disabled = false

    if condition == "S" then
        is_disabled = table_contains(disabler_conditions, "Stand")
    elseif condition == "A" then
        is_disabled = table_contains(disabler_conditions, "Air")
    elseif condition == "AC" then
        is_disabled = table_contains(disabler_conditions, "AirDuck")
    elseif condition == "W" then
        is_disabled = table_contains(disabler_conditions, "Walk")
    elseif condition == "C" then
        is_disabled = table_contains(disabler_conditions, "Duck")
    elseif condition == "SW" then
        is_disabled = table_contains(disabler_conditions, "Slowwalk")
    elseif condition == "CR" then
        is_disabled = table_contains(disabler_conditions, "DuckRun")
    elseif condition == "NE" then
        is_disabled = table_contains(disabler_conditions, "FakeLag")
    end

    if is_disabled then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):override(false)
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"):override(false)
        return
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):override(true)
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"):override(true)
    end

    local w_pressed = common.is_button_down(0x57)
    local s_pressed = common.is_button_down(0x53)
    local a_pressed = common.is_button_down(0x41)
    local d_pressed = common.is_button_down(0x44)

    if freestandswitch:get() and freestandbite:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(true)
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("On peek")
        rage.antiaim:override_hidden_pitch(pitchpeek())

        if ((w_pressed and a_pressed) or a_pressed) then
            rage.antiaim:override_hidden_yaw_offset(90)
            ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(0)
        elseif ((w_pressed and d_pressed) or d_pressed) then
            ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(0)
            rage.antiaim:override_hidden_yaw_offset(-90)
        elseif (w_pressed or s_pressed) then
            rage.antiaim:override_hidden_pitch(89)
        end
    end
end

function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local manual_left_active = false
local manual_right_active = false
local manual_left_last_state = false
local manual_right_last_state = false
local function manual_yaw()
    local lp = entity.get_local_player()

    if not lp or not lp:is_alive() or not globals.is_connected or not main_aa_switch:get() or not manuals:get() then
        return
    end

    local yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
    local yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
    local hidden_yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
    local lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
    local freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")

    if manual_left:get() and not manual_left_last_state then
        manual_left_active = not manual_left_active
        manual_right_active = false
    end
    manual_left_last_state = manual_left:get()

    if manual_right:get() and not manual_right_last_state then
        manual_right_active = not manual_right_active
        manual_left_active = false
    end
    manual_right_last_state = manual_right:get()

    if manual_left_active or manual_right_active then
        freestanding:override(false)
    end

    if manual_left_active or manual_right_active then
        hidden_yaw_offset:override(espam:get())
        lag_options:override(espam:get() and "Always on" or nil)
        rage.antiaim:override_hidden_pitch(pitchpeek())
        rage.antiaim:inverter(false)

        if manual_left_active then
            yaw_offset:override(-90)
            yaw_base:override("Local view")
            rage.antiaim:override_hidden_yaw_offset(espam:get() and 180 or 0)
        elseif manual_right_active then
            yaw_offset:override(90)
            yaw_base:override("Local view")
            rage.antiaim:override_hidden_yaw_offset(espam:get() and -180 or 0)
        end
    end
end

local indicator_alpha = 255
local indicator_target_alpha = 255
local indicator_fade_speed = 0.1

local arrow_font = render.load_font("Arial", 25, "a b")

local function is_scoped(player)
    return player and player.m_bIsScoped
end

local function is_tab_pressed()
    return common.is_button_down(0x09)
end

local function lerp(start_value, end_value, alpha)
    return start_value + (end_value - start_value) * alpha
end

local function render_manual_indicators()
    local screen_center_x = render.screen_size().x / 2
    local screen_center_y = render.screen_size().y / 2 - 2
    local player = entity.get_local_player()


    local scoped_offset_target = 0
    local scoped_offset = scoped_offset or 0
    local offset_speed = 0.2

    if player and player:is_alive() and globals.is_connected and manualindswitch:get(true) and manuals:get(true) then
        if is_scoped(player) then
            scoped_offset_target = -100
        else
            scoped_offset_target = 0
        end

        scoped_offset = lerp(scoped_offset, scoped_offset_target, offset_speed)

        indicator_alpha = 255

        if is_tab_pressed() then
            indicator_alpha = indicator_alpha / 3
        end

        local text_color = color(255, 255, 255, indicator_alpha)

        if manual_left_active then
            render.text(arrow_font, vector(screen_center_x - 80, screen_center_y + scoped_offset), text_color, "c", "‹")
        elseif manual_right_active then
            render.text(arrow_font, vector(screen_center_x + 82, screen_center_y + scoped_offset), text_color, "c", "›")
        end
    end
end

events.render:set(render_manual_indicators)

local function pingun()
    if not pingunlock:get(true) then
        ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override()
        return
    end

    ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override(ping_slider:get())
end

local animation = 0
local function customscope()
    local customScopeEnabled = custom_scope:get()
    
    local overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
    if not customScopeEnabled then
        overlay:set("Remove overlay")
        return
    end

    local player = entity.get_local_player()
    if not player or not player:is_alive() or common.is_button_down(0x09) then
        return
    end

    local screen = render.screen_size()
    local scope = player.m_bIsScoped
    local frametime = globals.frametime
    local main_clr = custom_scope_color:get()
    local gap = custom_scope_gap:get()
    local size = custom_scope_size:get()

    overlay:set("Remove All")

    animation = lerp(animation, scope and 1 or 0, 12 * frametime)
    if not scope and animation < 0.05 then
        return
    end

    local center_x, center_y = screen.x / 2, screen.y / 2
    local animation_gap = gap * animation
    local animation_size = size * animation

    render.gradient(
        vector(center_x - animation_gap, center_y),
        vector(center_x - animation_gap - animation_size, center_y + 1),
        main_clr, color(255, 255, 255, 0), main_clr, color(255, 255, 255, 0)
    )
    render.gradient(
        vector(center_x + animation_gap + 1, center_y),
        vector(center_x + animation_gap + animation_size, center_y + 1),
        main_clr, color(255, 255, 255, 0), main_clr, color(255, 255, 255, 0)
    )

    render.gradient(
        vector(center_x, center_y + animation_gap),
        vector(center_x + 1, center_y + animation_gap + animation_size),
        main_clr, main_clr, color(255, 255, 255, 0), color(255, 255, 255, 0)
    )
    render.gradient(
        vector(center_x, center_y - animation_gap),
        vector(center_x + 1, center_y - animation_gap - animation_size),
        main_clr, main_clr, color(255, 255, 255, 0), color(255, 255, 255, 0)
    )
end

events.render:set(customscope)

local function check_grenade()
    local lp = entity.get_local_player()

    if lp == nil or not lp:is_alive() then
        return
    end

    rage.exploit:allow_defensive(true)

    local active_weapon = lp:get_player_weapon()
    if active_weapon == nil then
        return
    end

    local weapon_classname = active_weapon:get_classname()
    if weapon_classname and string.find(weapon_classname, "Grenade") then
        rage.exploit:allow_defensive(false)
    end
end


local function warmup()
    if not tweakss:get("Warmup AA") then
        return
    end

    local gamerules = entity.get_game_rules()
    if gamerules.m_bWarmupPeriod == true then
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(math.normalize_yaw(globals.curtime * -250))
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Disabled")
    end
end

local function jitterlegs()
    MTools.AntiAims.Condition.Update()
    local lp = entity.get_local_player()
    
    if not lp or not lp:is_alive() then
        return
    end

    local condition = MTools.AntiAims.Condition.Get()

    if animfix_lisable:get("Jitter legs on land") and condition == "W" then
        if globals.tickcount % 5 > 1 then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Default")
        else
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
        end
    end
end

local function staticlegs()
    MTools.AntiAims.Condition.Update()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then
        return
    end

    local condition = MTools.AntiAims.Condition.Get()

    if not animfix_lisable:get("Static legs in air") and (condition == "A" or condition == "AC") then
        return
    end
    
    if animfix_lisable:get("Static legs in air") and (condition == "A" or condition == "AC") then
        ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
    end
end


    local fontdmg = render.load_font("Verdana", 10, "ab")

    local function damage_indicator()
        if not dmgind:get() then
            return
        end
    
        local player = entity.get_local_player()
    
        if not player or not player:is_alive() then
            return
        end
    
        local screen = {
            x = render.screen_size().x,
            y = render.screen_size().y
        }
    
        local text = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
    
        local alpha = common.is_button_down(0x09) and 63 or 255
    
        render.text(fontdmg, vector(screen.x / 2 + 6, screen.y / 2.08 + 5), color(255, 255, 255, alpha), nil, text)
    end
    

events.createmove:set(function()
    update_visibility()
    override_setts()
    updateAA()
    update_yaw_and_pitch()

    local states = { 
        deff_pitch_stand, deff_pitch_walk, deff_pitch_slowwalk,
        deff_pitch_air, deff_pitch_airduck, deff_pitch_duck, deff_pitch_duckrun 
    }
    for _, func in ipairs(states) do
        func()
    end

    customsway()
    fast_customsway()

    local yaw_states = { 
        deff_yaw_stand, deff_yaw_airduck, deff_yaw_air, 
        deff_yaw_duck, deff_yaw_slowwalk, deff_yaw_walk, deff_yaw_duckrun 
    }
    for _, func in ipairs(yaw_states) do
        func()
    end

    deffaa()
    lag_sway()
    alternatfakelag()
    is_scout()
    is_bind()
    pingun()
    sfreestand()
    manual_yaw()
    check_grenade()
    warmup()
    jitterlegs()
    staticlegs()
end)

local function render_desync_indicator()
    local screen_center_x, screen_center_y = render.screen_size().x / 2, render.screen_size().y / 2 - 2
    local player = entity.get_local_player()

    if not (player and player:is_alive() and globals.is_connected) then
        return
    end
    if not desyncindswitch:get(true) then
        return
    end

    local desync_delta = data.get_desync_delta()

    local target_alpha = is_scoped(player) and 0 or 255
    indicator_alpha = lerp(indicator_alpha, target_alpha, indicator_fade_speed)

    if is_tab_pressed() then
        indicator_alpha = indicator_alpha / 3
    end

    local alpha_left = indicator_alpha
    local alpha_right = indicator_alpha

    if desync_delta >= 0 then
        alpha_left = alpha_left / 4
    end

    if desync_delta <= 0 then
        alpha_right = alpha_right / 4
    end

    local scoped_offset = is_scoped(player) and -19 or 0

    local arrow_offset = 100
    local arrow_size_offset = 1

    render.text(arrow_font, vector(screen_center_x - arrow_offset, screen_center_y + scoped_offset - arrow_size_offset + 1), color(255, 255, 255, alpha_left), "c", "‹")
    render.text(arrow_font, vector(screen_center_x + arrow_offset, screen_center_y + scoped_offset + arrow_size_offset), color(255, 255, 255, alpha_right), "c", "›")
end


local function on_net_update_start()
    clan_tag()
end 

local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

local hitlog = {}
local gray_color = color(192, 192, 192, 255)
local font = render.load_font("Verdana", 10, "a")

local function lerp(a, b, t)
    return a + (b - a) * t
end

events.aim_ack:set(function(shot)
    if not hitlogs:get(true) then return end
    local lp = entity.get_local_player()

    if lp == nil or not lp:is_alive() or not globals.is_connected then
        return
    end

    local player_name = shot.target:get_name()
    local hitgroup = hitgroup_str[shot.hitgroup]
    local state = shot.state
    local log_text

    if state then
        log_text = ("Missed shot in %s in the %s due to %s (bt: %d ms, HC: %d%%)"):format(
            player_name,
            hitgroup_str[shot.wanted_hitgroup],
            state,
            shot.backtrack,
            shot.hitchance
        )
    else
        log_text = ("Hit %s in the %s for %d damage (bt: %d ms, HC: %d%%)"):format(
            player_name,
            hitgroup,
            shot.damage,
            shot.backtrack,
            shot.hitchance
        )
    end

    print_raw("[LONELY] " .. log_text)

    table.insert(hitlog, 1, {
        text = log_text,
        end_time = globals.tickcount + 450,
        alpha = 255,
        offset_y = 0,
        line_width = 0
    })
end)

events.render:set(function()
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() or not globals.is_connected then
        hitlog = {}
        return
    end

    local screen_size = render.screen_size()
    local base_y = screen_size.y / 2 + 250
    local remove_indices = {}

    for i = 1, #hitlog do
        local hitlog_item = hitlog[i]
        if globals.tickcount >= hitlog_item.end_time then
            if hitlog_item.alpha > 0 then
                hitlog_item.alpha = lerp(hitlog_item.alpha, 0, 0.05)
                hitlog_item.offset_y = lerp(hitlog_item.offset_y, hitlog_item.offset_y - 20, 0.05)
            else
                table.insert(remove_indices, i)
            end
        else
            hitlog_item.alpha = lerp(hitlog_item.alpha, 255, 0.1)
        end

        local target_y = base_y + (i - 1) * 30
        hitlog_item.offset_y = lerp(hitlog_item.offset_y, target_y, 0.1)

        local text_size = render.measure_text(font, nil, hitlog_item.text)
        local log_width = text_size.x + 10
        local rect_start = vector(screen_size.x / 2 - log_width / 2, hitlog_item.offset_y)
        local rect_end = vector(screen_size.x / 2 + log_width / 2, hitlog_item.offset_y + 20)

        render.rect(rect_start, rect_end, color(0, 0, 0, math.floor(hitlog_item.alpha * 0.7)))

        local corner_size = 6
        local thickness = 1
        local gray_color = color(128, 128, 128, hitlog_item.alpha)

        render.rect(vector(rect_start.x, rect_start.y), vector(rect_start.x + corner_size, rect_start.y + thickness), gray_color)
        render.rect(vector(rect_start.x, rect_start.y), vector(rect_start.x + thickness, rect_start.y + corner_size), gray_color)
        
        render.rect(vector(rect_end.x - corner_size, rect_start.y), vector(rect_end.x, rect_start.y + thickness), gray_color)
        render.rect(vector(rect_end.x - thickness, rect_start.y), vector(rect_end.x, rect_start.y + corner_size), gray_color)

        hitlog_item.line_width = lerp(hitlog_item.line_width, log_width, 0.05)
        render.rect(vector(rect_start.x, rect_end.y - 1), vector(rect_start.x + hitlog_item.line_width, rect_end.y), gray_color)

        render.text(font, vector(screen_size.x / 2, hitlog_item.offset_y + 7), color(192, 192, 192, hitlog_item.alpha), "c", hitlog_item.text)
    end

    for i = #remove_indices, 1, -1 do
        table.remove(hitlog, remove_indices[i])
    end
end)

local function cat()
    if not Exploits.InDefensive() then
        return
    end

    if Exploits.InDefensive() and not freestandswitch:get() and not (manual_left_active or manual_right_active) then
        local aimbot_ui_element = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
        if aimbot_ui_element then
            aimbot_ui_element:override(0)
        end
    end
end

local function safe_head()
    local local_player = entity.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local weapon = local_player:get_player_weapon()
    if not weapon then
        return
    end

    local weapon_class = weapon:get_classname()
    local condition = MTools.AntiAims.Condition:Get()

    local is_knife = (weapon_class == "CKnife" or weapon_class:lower():find("knife"))
    local is_taser = (weapon_class == "CWeaponTaser")
    

    if is_knife and safehead:get("Knife") and condition == "AC" then
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Down")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Backward")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(0)
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(false)
        rage.antiaim:inverter(true)
    end

if is_taser and safehead:get("Zeus") and condition == "AC" then
    ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):override("Down")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Backward")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(0)
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(false)
    rage.antiaim:inverter(true)
end
end

local function no_fall_damage(cmd)
    if not nofall:get() then
        return
    end

    local lp = entity.get_local_player()
    if not lp then
        return
    end

    local velocity_z = lp.m_vecVelocity.z
    if velocity_z > -500 then
        return
    end

    local origin = lp:get_origin()
    local trace_down_15 = utils.trace_line(origin, vector(origin.x, origin.y, origin.z - 15))

    if trace_down_15.fraction < 1 then
        cmd.in_duck = 0
        return
    end

    local trace_down_50 = utils.trace_line(origin, vector(origin.x, origin.y, origin.z - 50))
    if trace_down_50.fraction < 1 then
        cmd.in_duck = 1
    end
end

local function fast_ladder_movement(cmd)
    local lp = entity.get_local_player()
    if not lp or lp["m_MoveType"] ~= 9 then return end

    if not fastladder:get(true) then
        return
    end

    if cmd.sidemove == 0 then
        cmd.view_angles.y = cmd.view_angles.y + 45
    elseif (cmd.sidemove < 0 and cmd.in_forward) or (cmd.sidemove > 0 and cmd.in_back) then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    cmd.in_moveleft = cmd.in_back
    cmd.in_moveright = cmd.in_forward

    if cmd.view_angles.x < 0 then
        cmd.view_angles.x = -45
    end
end

events.createmove:set(cat)
events.net_update_start:set(on_net_update_start)
events.render:set(render_desync_indicator)
events.render:set(damage_indicator)
events.createmove:set(safe_head)

local function on_createmove(cmd)
    prevent_bomb_plant(cmd)
    legit_aa(cmd)
    fast_ladder_movement(cmd)
    no_fall_damage(cmd)
end

local function apply_config(config)
    for state_name, elements in pairs(settings) do
        if config[state_name] then
            elements.offset_left:set(config[state_name].offset_left)
            elements.offset_right:set(config[state_name].offset_right)
            elements.bodyyawslider:set(config[state_name].body_yaw)
            elements.random:set(config[state_name].randomization)
            elements.speed:set(config[state_name].speed)
            elements.body_combo:set(config[state_name].body_type)
            elements.body_left:set(config[state_name].body_left)
            elements.body_right:set(config[state_name].body_right)
            elements.delay_random:set(config[state_name].delay_random)
            if elements.switch_def then
                elements.switch_def:set(config[state_name].force_defensive)
                elements.pitch_def:set(config[state_name].pitch_defensive)
                elements.yaw_def:set(config[state_name].yaw_defensive)
            end
        end
    end

    main_aa_switch:set(config["main_aa_switch"] or false)
    manuals:set(config["manuals"] or false)
    manual_left:set(config["manual_left"] or 0)
    manual_right:set(config["manual_right"] or 0)
    espam:set(config["espam"] or false)
    state:set(config["state"] or 1)
    manualindswitch:set(config["manualindswitch"] or false)
    desyncindswitch:set(config["desyncindswitch"] or false)
    custom_scope:set(config["custom_scope"] or false)
    custom_scope_color:set(config["custom_scope_color"] or {255, 255, 255, 255})
    custom_scope_gap:set(config["custom_scope_gap"] or 0)
    custom_scope_size:set(config["custom_scope_size"] or 0)
    centerind:set(config["centerinds"] or false)
    dmgind:set(config["dmgind"] or false)
    hitlogs:set(config["hitlogs"] or false)
    labelforspace:set(config["labelforspace"] or false)
    freestandswitch:set(config["freestandswitch"] or false)
    freestandbite:set(config["freestandbite"] or false)
    safehead:set(config["safehead"] or 1)
    pingunlock:set(config["pingunlock"] or false)
    ping_slider:set(config["ping_slider"] or 0)
    legitaa:set(config["legitaa"] or false)
    fakelagalternative:set(config["fakelagalternative"] or false)
    tweakss:set(config["tweakss"] or 1)
    aspect_ratio:set(config["aspectratio"] or false)
    toss:set(config["toss"] or false)
    tag:set(config["tag"] or false)
    nofall:set(config["nofall"] or false)
    fastladder:set(config["fastladder"] or false)
    tt:set(config["tt"] or false)
end

local default_config = {
    Air = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = false,
        offset_left = -19.0,
        offset_right = 20.0,
        pitch_defensive = "Sway",
        randomization = 13.0,
        speed = 1.0,
        yaw_defensive = "Spin"
    },
    AirDuck = {
        body_left = 58.0,
        body_right = 56.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = false,
        offset_left = -15.0,
        offset_right = 45.0,
        pitch_defensive = "Zero",
        randomization = 6.0,
        speed = 2.0,
        yaw_defensive = "Slow spin"
    },
    Duck = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = true,
        offset_left = -20.0,
        offset_right = 20.0,
        pitch_defensive = "Sway",
        randomization = 21.0,
        speed = 3.0,
        yaw_defensive = "Sideways"
    },
    DuckRun = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = true,
        offset_left = -20.0,
        offset_right = 20.0,
        pitch_defensive = "Sway",
        randomization = 24.0,
        speed = 3.0,
        yaw_defensive = "Sideways"
    },
    FakeLag = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 0.0,
        force_defensive = false,
        offset_left = 0.0,
        offset_right = 0.0,
        pitch_defensive = 0.0,
        randomization = 8.0,
        speed = 3.0,
        yaw_defensive = 0.0
    },
    Slowwalk = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 0.0,
        force_defensive = true,
        offset_left = 0.0,
        offset_right = 0.0,
        pitch_defensive = "Semi down",
        randomization = 12.0,
        speed = 1.0,
        yaw_defensive = "Slow spin"
    },
    Stand = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = true,
        offset_left = 32.0,
        offset_right = -32.0,
        pitch_defensive = "Sway",
        randomization = 0.0,
        speed = 3.0,
        yaw_defensive = "Sideways"
    },
    Walk = {
        body_left = 58.0,
        body_right = 58.0,
        body_type = "Jitter",
        body_yaw = true,
        delay_random = 1.0,
        force_defensive = false,
        offset_left = -20.0,
        offset_right = 20.0,
        pitch_defensive = "Up",
        randomization = 0.0,
        speed = 2.0,
        yaw_defensive = "Sideways"
    },
    aspectratio = 129.0,
    centerinds = true,
    custom_scope = false,
    custom_scope_color = nil,
    custom_scope_gap = 0.0,
    custom_scope_size = 0.0,
    desyncindswitch = true,
    dmgind = false,
    espam = true,
    fakelagalternative = true,
    fastladder = true,
    freestandbite = true,
    freestandswitch = false,
    hitlogs = true,
    labelforspace = true,
    legitaa = false,
    main_aa_switch = true,
    manual_left = false,
    manual_right = false,
    manualindswitch = true,
    manuals = true,
    nofall = true,
    ping_slider = 0.0,
    pingunlock = false,
    safehead = {"Knife"},
    state = "Slowwalk",
    tag = false,
    toss = true,
    tt = true,
    tweakss = {"Bombsite e fix"}
}

local function apply_default_config()
    apply_config(default_config)
    print("Default config loaded")
end

local function get_current_config()
    local config = {}

    for state_name, elements in pairs(settings) do
        config[state_name] = {
            offset_left = elements.offset_left:get(),
            offset_right = elements.offset_right:get(),
            body_yaw = elements.bodyyawslider:get(),
            randomization = elements.random:get(),
            speed = elements.speed:get(),
            body_type = elements.body_combo:get(),
            body_left = elements.body_left:get(),
            body_right = elements.body_right:get(),
            delay_random = elements.delay_random:get() or 0,
            force_defensive = elements.switch_def and elements.switch_def:get() or false,
            pitch_defensive = elements.pitch_def and elements.pitch_def:get() or 0,
            yaw_defensive = elements.yaw_def and elements.yaw_def:get() or 0
        }
    end

    config["main_aa_switch"] = main_aa_switch:get()
    config["manuals"] = manuals:get()
    config["manual_left"] = manual_left:get()
    config["manual_right"] = manual_right:get()
    config["espam"] = espam:get()
    config["state"] = state:get()
    config["manualindswitch"] = manualindswitch:get()
    config["desyncindswitch"] = desyncindswitch:get()
    config["custom_scope"] = custom_scope:get()
    config["custom_scope_color"] = custom_scope_color:get()
    config["custom_scope_gap"] = custom_scope_gap:get()
    config["custom_scope_size"] = custom_scope_size:get()
    config["centerinds"] = centerind:get()
    config["dmgind"] = dmgind:get()
    config["hitlogs"] = hitlogs:get()
    config["labelforspace"] = labelforspace:get()
    config["freestandswitch"] = freestandswitch:get()
    config["freestandbite"] = freestandbite:get()
    config["safehead"] = safehead:get()
    config["pingunlock"] = pingunlock:get()
    config["ping_slider"] = ping_slider:get()
    config["legitaa"] = legitaa:get()
    config["fakelagalternative"] = fakelagalternative:get()
    config["tweakss"] = tweakss:get()
    config["toss"] = toss:get()
    config["tag"] = tag:get()
    config["nofall"] = nofall:get()
    config["fastladder"] = fastladder:get()
    config["tt"] = tt:get()
    config["aspectratio"] = aspect_ratio:get()

    return config
end

local function export_config()
    local config_data = get_current_config()
    local serialized = base64.encode(json.stringify(config_data))
    clipboard.set(serialized)
    print("Exported.")
end

local function import_config()
    local serialized = clipboard.get()
    if serialized and serialized ~= "" then
        local config_data = json.parse(base64.decode(serialized))
        apply_config(config_data)
        print("Imported")
    else
        print("Error.")
    end
end

ui_config:button("Export", export_config)
ui_config:button("Import", import_config)
ui_config:button("Load Default", apply_default_config)

events.createmove:set(on_createmove)

local resource = {}

local WEAPONTYPE_GRENADE = 9
local GRENADE_SECONDARY_DAMPENING = 0.3

function lerp(a, b, t)
    return a + t * (b - a)
end

function get_throw_toss(throw_angle, throw_velocity, throw_strength, abs_velocity)
    local vel = math.clamp(throw_velocity, 15, 750)
    local clamped_throw_strength = math.clamp(throw_strength, 0.0, 1.0)

    vel = vel * lerp(GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

    local forward = vector():angles(throw_angle)
    local throw = forward * vel - abs_velocity

    return throw:angles()
end

function on_createmove123(cmd)
    if render.camera_angles() ~= cmd.view_angles:clone() then
        return
    end

    local me = entity.get_local_player()

    if me == nil then
        return
    end

    local weapon = me:get_player_weapon()

    if weapon == nil then
        return
    end

    local weapon_info = weapon:get_weapon_info()

    if weapon_info == nil then
        return
    end

    local weapon_type = weapon_info.weapon_type

    if weapon_type ~= WEAPONTYPE_GRENADE then
        return
    end

    local predicted_time = globals.curtime - to_time(globals.clock_offset)

    if weapon.m_fThrowTime < predicted_time then
        return
    end

    cmd.in_speed = true

    cmd.view_angles = get_throw_toss(
        render.camera_angles(),
        weapon_info.throw_velocity,
        weapon.m_flThrowStrength,
        me.m_vecVelocity
    )
end

function on_grenade_override_view(e)
    local me = entity.get_local_player()

    if me == nil then
        return
    end

    local weapon = me:get_player_weapon()

    if weapon == nil then
        return
    end

    local weapon_info = weapon:get_weapon_info()

    if weapon_info == nil then
        return
    end

    e.angles = get_throw_toss(
        e.angles,
        weapon_info.throw_velocity,
        weapon.m_flThrowStrength,
        e.velocity
    )
end

toss:set_callback(function(item)
    local value = toss:get()

    events.createmove(on_createmove123, value)
    events.grenade_override_view(on_grenade_override_view, value)
end)

menu.aspect_ratio = aspect_ratio

local value
local function aspect_ratio_callback(self)
    value = self:get()
    value = value == 59 and 0 or value * 0.01
end

aspect_ratio:set_callback(aspect_ratio_callback, true)

local r_aspectratio = cvar.r_aspectratio

local function update_aspect_ratio()
    r_aspectratio:float(value, true)
end

r_aspectratio:set_callback(update_aspect_ratio)
aspect_ratio:set_callback(update_aspect_ratio)

update_aspect_ratio()

local function on_shutdown()
    r_aspectratio:float(0, true)
end

events.shutdown(on_shutdown)


events.post_update_clientside_animation:set(function(player)
    if not animfix_lisable:get("Kangaroo") then
        return
    end

    local me = entity.get_local_player()

    if player == me then
        local anim_state = player:get_anim_state()
        if animfix_lisable:get("Kangaroo") then
            player.m_flPoseParameter[3] = (math.random(0 , 10) / 10)
            player.m_flPoseParameter[6] = (math.random(0 , 10) / 10)
            player.m_flPoseParameter[7] = (math.random(0 , 10) / 10)

        end

    end
end)

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, const char* LPCSTR3, int a, int LPBINDSTATUSCALLBACK);
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
]]
local urlmon = ffi.load 'UrlMon'
local FileSystem = {}
FileSystem.__index = FileSystem
function FileSystem.download(url, path)
    urlmon.URLDownloadToFileA(nil, url, path, 0, 0)
end

files.create_folder('nl\\lonely')
FileSystem.download("https://github.com/vandalcat/cat/raw/main/small_pixel.ttf", "nl\\lonely\\small_pixel.ttf")

local pixel_font = render.load_font('nl\\lonely\\small_pixel.ttf', 10, "ao")

local dt_color_red = color(255, 0, 0, 255)
local dt_color_white = color(255, 255, 255, 255)
local hs_color = color(255, 255, 255, 255)
local baim_color = color(255, 255, 255, 255)
local md_color = color(255, 255, 255, 255)

local color_white = color(255, 255, 255, 255)
local color_gray = color(128, 128, 128, 255)

local time = 0
local gradient_speed = 4

local refs = {
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    rage = {exploit = rage.exploit},
}

local function get_screen_size()
    local screen_size = render.screen_size()
    return screen_size.x, screen_size.y
end

local function lerp(a, b, t)
    return a + (b - a) * t
end


local function GetConditionText()
    local condition = ExtendedMTools()

    local condition_map = {
        A = "AIR",
        AC = "AIR%DUCK",
        W = "WALK",
        SW = "SLOW%WALK",
        C = "DUCK",
        CR = "DUCK%RUN",
        NE = "FAKE%LAG",
        S = "STAND"
    }

    return condition_map[condition] or "FAKE-LAG"
end

local function is_min_damage_active()
    local binds = ui.get_binds()
    for _, bind in ipairs(binds) do
        if bind.name == "Min. Damage" and bind.active then
            return true
        end
    end
    return false
end

local function is_tab_pressed()
    return common.is_button_down(0x09)
end

local function is_scoped(player)
    return player.m_bIsScoped
end


local last_x_offset = 0
local function draw_indicators()
    if not centerind:get(true) then
        return
    end
    local player = entity.get_local_player()
    if not player or not player:is_alive() then return end

    local screen_width, screen_height = get_screen_size()
    local x_pos = screen_width / 2
    local y_pos_lonely = screen_height / 2 + 22
    local alpha_multiplier = 1
    local target_x_offset = 0

    if is_scoped(player) then
        target_x_offset = 30
    elseif is_tab_pressed() then
        alpha_multiplier = 0.25
    end

    last_x_offset = lerp(last_x_offset, target_x_offset, gradient_speed * globals.frametime)
    local lonely_alpha = lerp(0, 255, alpha_multiplier)
    render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_lonely), color(255, 255, 255, lonely_alpha), "c", "Lonely")

    local condition_text = GetConditionText()
    local condition_alpha = lerp(0, 255, alpha_multiplier)
    local y_pos_condition = y_pos_lonely + 10
    render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_condition), color(128, 128, 128, condition_alpha), "c", condition_text)

    local y_offset = 9

    if refs.dt:get() then
        local y_pos_dt = y_pos_condition + y_offset
        local exploit_value = refs.rage.exploit:get()
        local dt_color = exploit_value < 1 and dt_color_red or dt_color_white
        local dt_alpha = lerp(0, 255, alpha_multiplier)
        render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_dt), color(dt_color.r, dt_color.g, dt_color.b, dt_alpha), "c", "DT")
        y_offset = y_offset + 9
    elseif refs.hs:get() then
        local y_pos_hs = y_pos_condition + y_offset
        local hs_alpha = lerp(0, 255, alpha_multiplier)
        render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_hs), color(255, 255, 255, hs_alpha), "c", "HS")
        y_offset = y_offset + 9
    end

    if refs.baim:get() == "Force" then
        local y_pos_baim = y_pos_condition + y_offset
        local baim_alpha = lerp(0, 255, alpha_multiplier)
        render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_baim), color(255, 255, 255, baim_alpha), "c", "BAIM")
        y_offset = y_offset + 9
    end

    if is_min_damage_active() then
        local y_pos_md = y_pos_condition + y_offset
        local md_alpha = lerp(0, 255, alpha_multiplier)
        render.text(pixel_font, vector(x_pos + last_x_offset, y_pos_md), color(255, 255, 255, md_alpha), "c", "MD")
    end
end

events.render:set(function()
    draw_indicators()
end)

local trash_talks = {
    "ＶＡＮＤＡＬ 𝘾𝙍𝙀𝘼𝙏𝙀𝘿 𝙏𝙃𝙀 𝘽𝙀𝙎𝙏 𝙇𝙐𝘼 𝙊𝙁 𝙏𝙃𝙀 𝘾𝙀𝙉𝙏𝙐𝙍𝙔",
    "ɎØɄ Ø₩₦ɆĐ ฿Ɏ ⱠØ₦ɆⱠɎ , Ⱨ₳Ⱨ₳Ⱨ₳Ⱨ₳ ฿Ø₮ ɎØɄ ₥Ʉ₴₮ ฿ɄɎ ⱠØ₦ɆⱠɎ.ⱠɄ₳",
    "𝔚ℌ𝔈𝔑 𝔏𝔘𝔄 ℌ𝔄𝔖 𝔅𝔈𝔈𝔑 ℜ𝔈ℭ𝔒ℜ𝔇𝔈𝔇 𝔜𝔒𝔘 𝔚𝔈ℜ𝔈𝔑'𝔗 𝔅𝔒ℜ𝔑",
    "▄︻デ══━一:boom:ＹＯＵＲ ＭＯＭ ＨＡＳ ＢＥＥＮ ＫＩＬＬＥＤ ＢＹ ＬＯＮＥＬＹ.ＬＵＡ",
    "𝕐𝕠𝕦𝕣 𝕞𝕠𝕥𝕙𝕖𝕣 𝕚𝕤 𝕒 𝕧𝕚𝕣𝕘𝕚𝕟, 𝕓𝕦𝕥 𝕀 𝕙𝕒𝕧𝕖 𝕤𝕠𝕝𝕧𝕖𝕕 𝕚𝕥 𝕥𝕠𝕘𝕖𝕥𝕙𝕖𝕣 𝕨𝕚𝕥𝕙 𝕃𝕆ℕ𝔼𝕃𝕐",
    "Μιστερ, ιφ σομεονε ηυμιλιατεσ τηε περφυμε οφ μψ ασσ, ανδ ψου ωον'τ ηαωε α 𝕃𝕆ℕ𝔼𝕃𝕐",
    "ⓜⓨ ⓛⓞⓝⓔⓛⓨ ⓟⓤⓣⓢ ⓐ ⓑⓞⓛⓣ ⓞⓝ ⓨⓞⓤⓡ ⓗⓞⓟⓔⓢ",
    "𝙜𝙚𝙩 𝙧𝙚𝙖𝙡 𝙥𝙡𝙚𝙖𝙨𝙪𝙧𝙚 𝙛𝙧𝙤𝙢 𝕝𝕠𝕟𝕖𝕝𝕪 ~ 𝕦𝕣 𝕨𝕒𝕪 𝕥𝕠 𝕨𝕚𝕟!",
    "𝕃𝕆ℕ𝔼𝕃𝕐 𝕍𝕊 𝕊𝔸ℕℂℍ𝔼ℤ𝕁, 𝕃𝔼𝔾𝔼ℕ𝕊 𝔹𝔼𝕒𝕥",
    "𝕋𝕠 𝕘𝕖𝕥 𝕣𝕖𝕒𝕝 𝕝𝕦𝕔𝕜, 𝕪𝕠𝕦 𝕟𝕖𝕖𝕕 𝕃𝕠𝕟𝕖𝕝𝕪",
    "𝕡𝕝𝕒𝕪𝕖𝕣𝕤 𝕝𝕠𝕤𝕖, 𝕝𝕦𝕒𝕤𝕖𝕟𝕤𝕖 𝕕𝕠𝕖𝕤𝕟'𝕥 𝕙𝕖𝕝𝕡",
    "𝔹𝕖𝕣𝕦𝕙𝕚𝕘 𝕕𝕚𝕔𝕙, 𝕕𝕦 𝕙𝕒𝕤𝕥 𝕜𝕖𝕚𝕟𝕖 𝕊𝕔𝕙𝕒𝕟𝕔𝕖 𝕘𝕖𝕘𝕖𝕟 𝕃𝕆ℕ𝔼𝕃𝕐",
    "𝔻𝕚𝕖𝕤 𝕚𝕤𝕥 𝕜𝕖𝕚𝕟𝕖 𝕍𝕖𝕣𝕙𝕒𝕟𝕕𝕝𝕦𝕟𝕘. 𝕃𝕆ℕ𝔼𝕃𝕐 𝕞𝕒𝕔𝕙𝕥 𝕕𝕚𝕔𝕙 𝕟𝕦𝕣 𝕓𝕖𝕤𝕤𝕖𝕣",
    "𝕍𝕖𝕣𝕤𝕦𝕔𝕙𝕤 𝕘𝕒𝕣 𝕟𝕚𝕔𝕙𝕥, 𝕞𝕚𝕥 𝕃𝕆ℕ𝔼𝕃𝕐 𝕘𝕖𝕨𝕚𝕟𝕟𝕖 𝕚𝕔𝕙",
    "𝕁𝕖𝕕𝕖 𝔹𝕒𝕝𝕝𝕖𝕣𝕒𝕥𝕥𝕒𝕔𝕜𝕖 𝕚𝕤𝕥 𝕟𝕚𝕖𝕞𝕒𝕝𝕤 𝕗ü𝕣 𝕞𝕚𝕔𝕙, 𝕚𝕔𝕙 𝕙𝕒𝕓𝕖 𝕃𝕆ℕ𝔼𝕃𝕐!"
}

events.player_death:set(function(event)
    if not tt:get(true) then
        return
    end

    local me = entity.get_local_player()
    if me == nil then return end

    local attacker = entity.get(event.attacker, true)

    if attacker == me then
        local kill_say = trash_talks[math.random(#trash_talks)]
        utils.console_exec("say " .. kill_say)
    end
end)