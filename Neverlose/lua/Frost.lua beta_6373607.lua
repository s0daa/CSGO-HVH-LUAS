-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- #region : Ffi

ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder;
        int m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        void *m_pOwner;
        char  pad_0038[4];
    } animstate_layer_t;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animslsg = nil

-- #endregion

-- #region : Library

local pui = require "neverlose/pui"
local clipboard = require "neverlose/clipboard"
local base64 = require "neverlose/base64"
local gradient = require "neverlose/gradient"
local bomb = require "neverlose/bomb"

-- #endregion

-- #region : Animation handler | Lerp

math.max_lerp_low_fps = (1 / 45) * 100
math.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * math.min(frametime, math.max_lerp_low_fps)

    local val = start + (end_pos - start) * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

local animations = {}
animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or 0
    end

    animations._list[name] = math.lerp(animations._list[name], new_value, speed)
    
    return animations._list[name]
end

-- #endregion

-- #region : Get original cvar function

local function get_original(convar)
    return tonumber(convar:string())
end

-- #endregion

-- #region : Get bind function

get_bind = function(name)
    local state = false
    local value = 0
    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].name == name and binds[i].active then
            state = true
            value = binds[i].value
        end
    end
    return {state, value}
end

-- #endregion

-- #region : Menu references

local refs = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    hidden_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    freestanding_body = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
	hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    hideshots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    legs_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    force_viewmodel = ui.find("Visuals", "World", "Main", "Override Zoom", "Force Viewmodel"),
    pistols_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Pistols", "Hit Chance"),
    auto_snipers_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"),
    awp_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"),
    ssg08_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    revolver_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"),
    weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
    bullet_impact_duration = ui.find("Visuals", "World", "Other", "Bullet Impacts", "Duration"),
}

-- #endregion

-- #region : Menu tabs

local tabs = {
    global = pui.create("\f<house>", {
        {"tab_selection", "\n", 1},
        {"under_tab_selection", "\n\n", 1},
        {"information", "\n\n\n", 2},
        {"config", "\n\n\n\n", 2},
        {"links", "\n\n\n\n\n", 2},
    }),
    anti_aim = pui.create("\f<rotate-right>", {
        {"settings", "\n\n", 1},
        {"other", "\n\n\n", 1},
        {"upper_builder", "\n\n\n\n\n\n", 2},
        {"builder", "\n\n\n\n", 2},
        {"under_builder", "\n\n\n\n\n\n\n\n\n\n", 2},
        {"defensive_aa", "\n\n\n\n\n", 1}
    }),
    settings = pui.create("\f<gear>", {
        {"interface", "\n", 1},
        {"view", "\n\n", 2},
        {"additionals", "\n\n\n", 1},
        {"movement", "\n\n\n\n", 2},
        {"ragebot", "\n\n\n\n\n", 2},
    })
}

-- #endregion

-- #region : Database stuff

database = db.frost or { }

database.hits = database.hits or 1
database.misses = database.misses or 0

-- #endregion

-- #region : Menu

local ratios = {
    ["16:10"] = 160,
    ["16:9"] = 180,
    ["5:4"] = 125,
    ["4:3"] = 133,
    ["3:2"] = 150
}

local stateenable_i = {[1] = "Shared", [2] = "Standing", [3] = "Moving", [4] = "Air", [5] = "Air-Crouching", [6] = "Crouching", [7] = "Crouching Moving", [8] = "Slow-Walking", [9] = "Fake Lag"}
local force_defensive_mass = {[1] = "Standing", [2] = "Moving", [3] = "Air", [4] = "Air-Crouching", [5] = "Crouching", [6] = "Crouching Moving", [7] = "Slow-Walking"}
local freestanding_mass = {[1] = "Standing", [2] = "Moving", [3] = "Air", [4] = "Air-Crouching", [5] = "Crouching", [6] = "Crouching Moving", [7] = "Slow-Walking"}

local menu = {
    global = {
        information = {
            welcome_back = tabs.global.tab_selection:label("\f<hand-wave>   Welcome back, \v" ..common.get_username().. "!"),
            current_build = tabs.global.tab_selection:label(" \f<tag>   Build: \vBeta"),
            version = tabs.global.tab_selection:label("\f<cloud-question>  Last update: \v13.10.2024"),
            discord_server = tabs.global.tab_selection:button("                 \v\f<discord>                  ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/CXEB7nfTSp")
            end, true),
            youtube = tabs.global.tab_selection:button("                 \v\f<youtube>                  ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtube.com/@v_1966?si=FpInmvP8uBzKZW1O")
            end, true),
            hits = tabs.global.under_tab_selection:label("\v\f<bullseye-arrow>\r  Hits " .. database.hits),
            misses = tabs.global.under_tab_selection:label("\v\f<magnifying-glass>\r  Misses " .. database.misses),
        },
    },
    anti_aim = {
        main = {
            team = tabs.anti_aim.builder:combo("\v\f<screen-users>\r  Team", {"T", "CT"}),
            conditions = tabs.anti_aim.builder:combo("\v\f<filter>\r  Condition", {"Shared", "Standing", "Moving", "Air", "Air-Crouching", "Crouching", "Crouching Moving", "Slow-Walking", "Fake Lag"}),
            manual_yaw = tabs.anti_aim.other:combo("Manual Yaw", {"Disabled", "Forward", "Left", "Right", "Freestanding"}, function(gear)
                return 
                {
                    static_yaw = gear:switch("Static Yaw", false),
                }
            end),
        },
        other = {
            force_defensive = tabs.anti_aim.other:selectable("\v\f<shield-halved>\r  Force Defensive", force_defensive_mass),
            auto_lag_exploit = tabs.anti_aim.other:combo("\v\f<chart-bar>\r  Auto Lag Exploit", {"Disabled", "Default", "Smart"}, function(gear)
                return 
                {
                    ticks = gear:slider("Ticks", 8, 32, 15, 1)
                }
            end),
            animation_breakers = tabs.anti_aim.other:switch("\v\f<bone-break>\r  Animations", false),
            safe_head = tabs.anti_aim.other:switch("\v\f<user-helmet-safety>\r  Safe Head", false, function(gear)
                return
                {
                    conditions = gear:selectable("Conditions", {"Knife", "Taser", "Height Advantage"}),
                    tip = gear:label("\vKnife & Taser works only on air-crouch!"),
                    e_spam = gear:switch("E-Spam", false)
                }
            end),
            avoid_backstab = tabs.anti_aim.other:switch("\v\f<sword>\r  Avoid Backstab", false),
            freestanding_disablers = tabs.anti_aim.other:selectable("\v\f<person>\r  Freestanding Disablers", freestanding_mass),
        },
    },
    settings = {
        visuals = {
            crosshair_indicators = tabs.settings.interface:switch("Crosshair Indicators", false),
            damage_indicator = tabs.settings.interface:switch("Damage Indicator", false),
            watermark = tabs.settings.interface:switch("Watermark", false),
            manual_arrows = tabs.settings.interface:switch("Manual Arrows", false, function(gear)
                return 
                {
                    offset = gear:slider("Offset", 0, 100, 0, 1),
                    accent_color = gear:color_picker("Color", color(255)),
                    manual_color = gear:color_picker("Manual Color", color(255))
                }
            end),
            grenade_radius = tabs.settings.interface:switch("Grenade Radius", false, function(gear)
                return 
                {
                    select = gear:selectable("Select", {"Molotov", "Smoke"}),
                    molotov_color = gear:color_picker("Molotov Color", color(225, 89, 89, 255)),
                    smoke_color = gear:color_picker("Smoke Color", color(142, 142, 228, 255)),
                }
            end),
            gamesense_indicators = tabs.settings.interface:switch("GS Indicators", false, function(gear)
                return 
                {
                    select = gear:selectable("Select", {"Double Tap", "Hideshots", "Freestanding", "Force Baim", "Min. damage override", "Hitchance Override", "Ping reduce", "Fake Duck", "Dormant aim", "Force safepoint", "Bomb info", "Hit/Miss"})
                }
            end),
            hitmarker_world = tabs.settings.interface:switch("Hitmarker World", false, function(gear)
                return 
                {
                    hitmarker_color = gear:color_picker("Color")
                }
            end),
            custom_scope_overlay = tabs.settings.view:switch("Custom Scope Lines", false),
        },  
        misc = {
           aimlogs = tabs.settings.additionals:switch("Aimbot Logs", false, function(gear)
            return 
            {
                select = gear:selectable("Select", "Console", "Event", "Notify"),
                hit_color = gear:color_picker("Hit Color", color("AA7777FF")),
                miss_color = gear:color_picker("Miss Color", color("AA7777FF")),
                fired_at_you_color = gear:color_picker("Fired At You Color", color("AA7777FF")),
            }
           end),
           fake_latency_unlocker = tabs.settings.additionals:switch("\aAA6767FFFake Latency Unlocker", false, function(gear)
                return 
                {   
                    ping = gear:slider("Fake Latency", 0, 200, 0)
                }
           end),
           unmute_silenced_player = tabs.settings.additionals:switch("Unmute Silenced Player", false),
           no_fall_damage = tabs.settings.movement:switch("No Fall Damage", false),
           fast_ladder = tabs.settings.movement:switch("Fast Ladder", false),
           avoid_collisions = tabs.settings.movement:switch("Avoid Collisions", false, function(gear)
                return 
                {
                    distance = gear:slider("Distance", 40, 100)
                }
           end),
           super_toss = tabs.settings.movement:switch("Super Toss", false),
           nade_throw_fix = tabs.settings.movement:switch("Nade Throw Fix", false),
           killsay = tabs.settings.additionals:switch("Killsay", false, function(gear)
                return 
                {
                    delay = gear:slider("Delay", 0, 50, 0, 0.1, "s")
                }
           end),
           clantag = tabs.settings.additionals:switch("Clantag", false),
           aspect_ratio = tabs.settings.view:switch("Aspect Ratio", false),
           viewmodel = tabs.settings.view:switch("Viewmodel Changer", false),
           perfomance_boost = tabs.settings.view:switch("Perfomance Boost", false),
        },
        ragebot = {
            dormant_aimbot = tabs.settings.ragebot:switch("Dormant Aimbot", false, function(gear)
                return 
                {
                    hitboxes = gear:selectable("Hitboxes", {"Head", "Chest", "Stomach", "Legs"}),
                    accuracy = gear:slider("Accuracy", 50, 85, 0, 1, "%"),
                    minimum_damage = gear:slider("Min. Damage", 0, 130, 0, 1),
                }
            end),
            hitchance = tabs.settings.ragebot:switch("Hitchance", false, function(gear)
                return 
                {
                    current_weapon = gear:list("\n", {"Pistols", "Auto-Snipers", "AWP", "SSG-08", "R8 Revolver"}),
                    pistols_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    auto_snipers_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    auto_snipers_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    awp_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    awp_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    ssg08_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    ssg08_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    revolver_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                }
            end),
            r8_helper = tabs.settings.ragebot:switch("R8 Helper", false),
        }
    }
}

-- #endregion

-- #region : Hits & Misses & Total Time stuff

function shot_statistic(e)
    if e.state == nil then
        database.hits = database.hits + 1
        menu.global.information.hits:name("\v\f<bullseye-arrow>\r  Hits " .. database.hits) 
    else
        database.misses = database.misses + 1
        menu.global.information.misses:name("\v\f<magnifying-glass>\r  Misses " .. database.misses) 
    end
end

events.shutdown:set(function() 
    db.frost = database
end)

-- endregion

-- #region : Creating gear

-- TODO: Rework this shit >.< (including gear elements)

local gear = {
    animation_breakers = menu.anti_aim.other.animation_breakers:create(),
    crosshair_indicators = menu.settings.visuals.crosshair_indicators:create(),
    watermark = menu.settings.visuals.watermark:create(),
    custom_scope_overlay = menu.settings.visuals.custom_scope_overlay:create(),
    aspect_ratio = menu.settings.misc.aspect_ratio:create(),
    viewmodel = menu.settings.misc.viewmodel:create(),
}

-- #endregion

-- #region : Gear elements

local gear_funcs = {
    animation_breakers_select = gear.animation_breakers:selectable("Select", "In Air Legs", "Ground Legs", "Addons"),
    animation_breakers_select_in_air = gear.animation_breakers:combo("In Air", "Disabled", "Static", "Jitter", "Allah"),
    animation_breakers_select_ground = gear.animation_breakers:combo("Ground", "Static", "Jitter", "Allah"),
    animation_breakers_addons = gear.animation_breakers:selectable("Addons", "Move Lean", "Earth Quake", "Pitch 0 On Land"),
    animation_breakers_addons_move_lean_amount = gear.animation_breakers:slider("Amount", 0, 100, 0, 1, "%"),
    crosshair_indicators_first_color = gear.crosshair_indicators:color_picker("First Color", color(255, 255, 255, 255)),
    crosshair_indicators_second_color = gear.crosshair_indicators:color_picker("Second Color", color(255, 255, 255, 255)),
    crosshair_indicators_glow_color = gear.crosshair_indicators:color_picker("Glow Color", color(255, 255, 255, 255)),
    watermark_style = gear.watermark:combo("Style", {"Frost", "Gradient"}),
    watermark_style_frost_type = gear.watermark:combo("Type", {"Classic", "Modern"}),
    watermark_position = gear.watermark:combo("Position", {"Right", "Left", "Bottom"}),
    watermark_color = gear.watermark:color_picker("Color", color(255, 255, 255, 255)),
    custom_scope_overlay_inverted = gear.custom_scope_overlay:switch("Inverted", false),
    custom_scope_overlay_gap = gear.custom_scope_overlay:slider("Gap", 0, 100, 5),
    custom_scope_overlay_line = gear.custom_scope_overlay:slider("Line", 0, 300, 100),
    custom_scope_overlay_color = gear.custom_scope_overlay:color_picker("Color", color(255, 255, 255, 255)),
    aspect_ratio_value = gear.aspect_ratio:slider("Value", 0, 200, 0, 0.01),
    viewmodel_fov = gear.viewmodel:slider("Fov", 0, 100, 60, 1),
    viewmodel_x = gear.viewmodel:slider("X", -1500, 1500, 0, 0.01),
    viewmodel_y = gear.viewmodel:slider("Y", -1500, 1500, 0, 0.01),
    viewmodel_z = gear.viewmodel:slider("Z", -1500, 1500, 0, 0.01),
    cs2_scope_viewmodel = gear.viewmodel:switch("CS:2 Scope Viewmodel"),
}

for ratio, value in pairs(ratios) do
    aspect_ratio_button = gear.aspect_ratio:button(" " .. ratio .. " ", function()
        gear_funcs.aspect_ratio_value:set(value)
    end, true):depend(menu.settings.misc.aspect_ratio)
end

-- #endregion

-- #region : Depends

gear_funcs.animation_breakers_select:depend(menu.anti_aim.other.animation_breakers)
gear_funcs.animation_breakers_select_in_air:depend(menu.anti_aim.other.animation_breakers, {gear_funcs.animation_breakers_select, "In Air Legs"})
gear_funcs.animation_breakers_select_ground:depend(menu.anti_aim.other.animation_breakers, {gear_funcs.animation_breakers_select, "Ground Legs"})
gear_funcs.animation_breakers_addons:depend(menu.anti_aim.other.animation_breakers, {gear_funcs.animation_breakers_select, "Addons"})
gear_funcs.animation_breakers_addons_move_lean_amount:depend(menu.anti_aim.other.animation_breakers, {gear_funcs.animation_breakers_addons, "Move Lean"})
menu.anti_aim.other.safe_head.conditions:depend(menu.anti_aim.other.safe_head)
menu.anti_aim.other.safe_head.tip:depend(menu.anti_aim.other.safe_head)
menu.anti_aim.other.safe_head.e_spam:depend(menu.anti_aim.other.safe_head)
menu.anti_aim.other.auto_lag_exploit.ticks:depend({menu.anti_aim.other.auto_lag_exploit, "Default"})
gear_funcs.crosshair_indicators_first_color:depend(menu.settings.visuals.crosshair_indicators)
gear_funcs.crosshair_indicators_second_color:depend(menu.settings.visuals.crosshair_indicators)
gear_funcs.crosshair_indicators_glow_color:depend(menu.settings.visuals.crosshair_indicators)
gear_funcs.watermark_style:depend(menu.settings.visuals.watermark)
gear_funcs.watermark_style_frost_type:depend(menu.settings.visuals.watermark, {gear_funcs.watermark_style, "Frost"})
gear_funcs.watermark_position:depend(menu.settings.visuals.watermark, {gear_funcs.watermark_style, "Frost"}, {gear_funcs.watermark_style_frost_type, "Classic"})
gear_funcs.watermark_color:depend(menu.settings.visuals.watermark)
menu.settings.visuals.manual_arrows.offset:depend(menu.settings.visuals.manual_arrows)
menu.settings.visuals.manual_arrows.accent_color:depend(menu.settings.visuals.manual_arrows)
menu.settings.visuals.manual_arrows.manual_color:depend(menu.settings.visuals.manual_arrows)
menu.settings.visuals.grenade_radius.select:depend(menu.settings.visuals.grenade_radius)
menu.settings.visuals.grenade_radius.molotov_color:depend(menu.settings.visuals.grenade_radius)
menu.settings.visuals.grenade_radius.smoke_color:depend(menu.settings.visuals.grenade_radius)
menu.settings.visuals.gamesense_indicators.select:depend(menu.settings.visuals.gamesense_indicators)
menu.settings.visuals.hitmarker_world.hitmarker_color:depend(menu.settings.visuals.hitmarker_world)
gear_funcs.custom_scope_overlay_inverted:depend(menu.settings.visuals.custom_scope_overlay)
gear_funcs.custom_scope_overlay_gap:depend(menu.settings.visuals.custom_scope_overlay)
gear_funcs.custom_scope_overlay_line:depend(menu.settings.visuals.custom_scope_overlay)
gear_funcs.custom_scope_overlay_color:depend(menu.settings.visuals.custom_scope_overlay)
menu.settings.misc.aimlogs.select:depend(menu.settings.misc.aimlogs)
menu.settings.misc.aimlogs.hit_color:depend(menu.settings.misc.aimlogs)
menu.settings.misc.aimlogs.miss_color:depend(menu.settings.misc.aimlogs)
menu.settings.misc.aimlogs.fired_at_you_color:depend(menu.settings.misc.aimlogs)
menu.settings.misc.fake_latency_unlocker.ping:depend(menu.settings.misc.fake_latency_unlocker)
menu.settings.misc.avoid_collisions.distance:depend(menu.settings.misc.avoid_collisions)
menu.settings.misc.killsay.delay:depend(menu.settings.misc.killsay)
gear_funcs.aspect_ratio_value:depend(menu.settings.misc.aspect_ratio)
gear_funcs.viewmodel_fov:depend(menu.settings.misc.viewmodel)
gear_funcs.viewmodel_x:depend(menu.settings.misc.viewmodel)
gear_funcs.viewmodel_y:depend(menu.settings.misc.viewmodel)
gear_funcs.viewmodel_z:depend(menu.settings.misc.viewmodel)
gear_funcs.cs2_scope_viewmodel:depend(menu.settings.misc.viewmodel)
menu.settings.ragebot.dormant_aimbot.hitboxes:depend(menu.settings.ragebot.dormant_aimbot)
menu.settings.ragebot.dormant_aimbot.accuracy:depend(menu.settings.ragebot.dormant_aimbot)
menu.settings.ragebot.dormant_aimbot.minimum_damage:depend(menu.settings.ragebot.dormant_aimbot)

menu.settings.ragebot.hitchance.current_weapon:depend(menu.settings.ragebot.hitchance)

menu.settings.ragebot.hitchance.pistols_air_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 1})

menu.settings.ragebot.hitchance.auto_snipers_air_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 2})
menu.settings.ragebot.hitchance.auto_snipers_no_scope_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 2})

menu.settings.ragebot.hitchance.awp_air_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 3})
menu.settings.ragebot.hitchance.awp_no_scope_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 3})

menu.settings.ragebot.hitchance.ssg08_air_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 4})
menu.settings.ragebot.hitchance.ssg08_no_scope_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 4})

menu.settings.ragebot.hitchance.revolver_air_amount:depend(menu.settings.ragebot.hitchance, {menu.settings.ragebot.hitchance.current_weapon, 5})

-- #endregion

-- #region : Anti-aim builder elements

local custom_aa = { }

for i, v in next, stateenable_i do
    custom_aa[v] = { }
    for index, value in next, {"CT", "T"} do
        custom_aa[v][value] = {
            state_enable = tabs.anti_aim.builder:switch("Override " .. stateenable_i[i], false),
            yaw = tabs.anti_aim.builder:combo("\v\f<triangle>\r  Yaw", {"Static", "Left And Right"}, function(gear)
                return 
                {
                    yaw_offset_variability = gear:slider("Offset Variability", 0, 100, 0, 1, "%"),
                    yaw_static_offset = gear:slider("Yaw Offset", -180, 180, 0),
                    yaw_left_offset = gear:slider("Yaw Left Offset", -180, 180, 0),
                    yaw_right_offset = gear:slider("Yaw Right Offset", -180, 180, 0),
                    swap_delay = gear:switch("Swap Delay", false),
                    swap_delay_ticks = gear:slider("Delay", 1, 14, 8),
                }
            end),
            yaw_modifier = tabs.anti_aim.builder:combo("\v\f<fan>\r  Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, function(gear)
                return 
                {
                    yaw_modifier_offset_variability = gear:slider("Offset Variability\n", 0, 100, 0, 1, "%"),
                    yaw_modifier_offset = gear:slider("Offset", -180, 180, 0),
                }
            end),
            body_yaw = tabs.anti_aim.builder:switch("\v\f<shield>\r  Body Yaw", false, function(gear)
                return 
                {
                    left_limit = gear:slider("Left Limit", 0, 60, 0),
                    right_limit = gear:slider("Right Limit", 0, 60, 0),
                    options = gear:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}),
                    freestanding = gear:combo("Freestanding", {"Off", "Peek Fake", "Peek Real"}),
                }
            end),
            defensive_aa = tabs.anti_aim.under_builder:switch("\v\f<arrows-spin>\r  Defensive AA", false, function(gear)
                return 
                {
                    mode = gear:combo("\v\f<gear>\r  Mode", {"On Peek", "Always On"}),
                    allow_with_hide_shots = gear:switch("\v\f<check-double>\r  Allow with Hideshots", false),
                    custom_defensive_aa_pitch = gear:combo("\v\f<arrows-up-to-line>\r  Pitch", {"Down", "Zero", "Up", "Random"}),
                    random_pitch_first_value = gear:slider("First Value", -89, 89, 0, 1),
                    random_pitch_second_value = gear:slider("Second Value", -89, 89, 0, 1),
                    custom_defensive_aa_yaw = gear:combo("\v\f<triangle>\r  Yaw", {"Sideways", "Spin", "Switch", "Forward", "Random"}),
                    spin_speed = gear:slider("Speed", 1, 20, 0, 1),
                    switch_yaw_first_value = gear:slider("First Value", -180, 180, 0, 1),
                    switch_yaw_second_value = gear:slider("Second Value", -180, 180, 0, 1),
                    random_yaw_first_value = gear:slider("First Value", -180, 180, 0, 1),
                    random_yaw_second_value = gear:slider("Second Value", -180, 180, 0, 1),
                }
            end),
        }
    end
end

local button_t = tabs.anti_aim.builder:button("\v\f<arrow-right-to-bracket>\r  Send to \vT\r", function()
    cvar.play:call("ambient\\tones\\elev1")

    for i, v in next, stateenable_i do 
        for index, value in next, {"CT", "T"} do
            custom_aa[v]["T"].state_enable:set(custom_aa[v]["CT"].state_enable:get())

            custom_aa[v]["T"].yaw:set(custom_aa[v]["CT"].yaw:get())
            custom_aa[v]["T"].yaw.yaw_offset_variability:set(custom_aa[v]["CT"].yaw.yaw_offset_variability:get())
            custom_aa[v]["T"].yaw.yaw_static_offset:set(custom_aa[v]["CT"].yaw.yaw_static_offset:get())
            custom_aa[v]["T"].yaw.yaw_left_offset:set(custom_aa[v]["CT"].yaw.yaw_left_offset:get())
            custom_aa[v]["T"].yaw.yaw_right_offset:set(custom_aa[v]["CT"].yaw.yaw_right_offset:get())
            custom_aa[v]["T"].yaw.swap_delay:set(custom_aa[v]["CT"].yaw.swap_delay:get())
            custom_aa[v]["T"].yaw.swap_delay_ticks:set(custom_aa[v]["CT"].yaw.swap_delay_ticks:get())
    
            custom_aa[v]["T"].yaw_modifier:set(custom_aa[v]["CT"].yaw_modifier:get())
            custom_aa[v]["T"].yaw_modifier.yaw_modifier_offset_variability:set(custom_aa[v]["CT"].yaw_modifier.yaw_modifier_offset_variability:get())
            custom_aa[v]["T"].yaw_modifier.yaw_modifier_offset:set(custom_aa[v]["CT"].yaw_modifier.yaw_modifier_offset:get())
    
            custom_aa[v]["T"].body_yaw:set(custom_aa[v]["CT"].body_yaw:get())
            custom_aa[v]["T"].body_yaw.left_limit:set(custom_aa[v]["CT"].body_yaw.left_limit:get())
            custom_aa[v]["T"].body_yaw.right_limit:set(custom_aa[v]["CT"].body_yaw.right_limit:get())
            custom_aa[v]["T"].body_yaw.options:set(custom_aa[v]["CT"].body_yaw.options:get())
            custom_aa[v]["T"].body_yaw.freestanding:set(custom_aa[v]["CT"].body_yaw.freestanding:get())

            custom_aa[v]["T"].defensive_aa:set(custom_aa[v]["CT"].defensive_aa:get())
            custom_aa[v]["T"].defensive_aa.mode:set(custom_aa[v]["CT"].defensive_aa.mode:get())
            custom_aa[v]["T"].defensive_aa.allow_with_hide_shots:set(custom_aa[v]["CT"].defensive_aa.allow_with_hide_shots:get())
            custom_aa[v]["T"].defensive_aa.custom_defensive_aa_pitch:set(custom_aa[v]["CT"].defensive_aa.custom_defensive_aa_pitch:get())
            custom_aa[v]["T"].defensive_aa.random_pitch_first_value:set(custom_aa[v]["CT"].defensive_aa.random_pitch_first_value:get())
            custom_aa[v]["T"].defensive_aa.random_pitch_second_value:set(custom_aa[v]["CT"].defensive_aa.random_pitch_second_value:get())
            custom_aa[v]["T"].defensive_aa.custom_defensive_aa_yaw:set(custom_aa[v]["CT"].defensive_aa.custom_defensive_aa_yaw:get())
            custom_aa[v]["T"].defensive_aa.spin_speed:set(custom_aa[v]["CT"].defensive_aa.spin_speed:get())
            custom_aa[v]["T"].defensive_aa.switch_yaw_first_value:set(custom_aa[v]["CT"].defensive_aa.switch_yaw_first_value:get())
            custom_aa[v]["T"].defensive_aa.switch_yaw_second_value:set(custom_aa[v]["CT"].defensive_aa.switch_yaw_second_value:get())
            custom_aa[v]["T"].defensive_aa.random_yaw_first_value:set(custom_aa[v]["CT"].defensive_aa.random_yaw_first_value:get())
            custom_aa[v]["T"].defensive_aa.random_yaw_second_value:set(custom_aa[v]["CT"].defensive_aa.random_yaw_second_value:get())
        end
    end
end, true)

local button_ct = tabs.anti_aim.builder:button("\v\f<arrow-right-to-bracket>\r  Send to \vCT\r", function()
    cvar.play:call("ambient\\tones\\elev1")

    for i, v in next, stateenable_i do 
        for index, value in next, {"CT", "T"} do
            custom_aa[v]["CT"].state_enable:set(custom_aa[v]["T"].state_enable:get())

            custom_aa[v]["CT"].yaw:set(custom_aa[v]["T"].yaw:get())
            custom_aa[v]["CT"].yaw.yaw_offset_variability:set(custom_aa[v]["T"].yaw.yaw_offset_variability:get())
            custom_aa[v]["CT"].yaw.yaw_static_offset:set(custom_aa[v]["T"].yaw.yaw_static_offset:get())
            custom_aa[v]["CT"].yaw.yaw_left_offset:set(custom_aa[v]["T"].yaw.yaw_left_offset:get())
            custom_aa[v]["CT"].yaw.yaw_right_offset:set(custom_aa[v]["T"].yaw.yaw_right_offset:get())
            custom_aa[v]["CT"].yaw.swap_delay:set(custom_aa[v]["T"].yaw.swap_delay:get())
            custom_aa[v]["CT"].yaw.swap_delay_ticks:set(custom_aa[v]["T"].yaw.swap_delay_ticks:get())
    
            custom_aa[v]["CT"].yaw_modifier:set(custom_aa[v]["T"].yaw_modifier:get())
            custom_aa[v]["CT"].yaw_modifier.yaw_modifier_offset_variability:set(custom_aa[v]["T"].yaw_modifier.yaw_modifier_offset_variability:get())
            custom_aa[v]["CT"].yaw_modifier.yaw_modifier_offset:set(custom_aa[v]["T"].yaw_modifier.yaw_modifier_offset:get())
    
            custom_aa[v]["CT"].body_yaw:set(custom_aa[v]["T"].body_yaw:get())
            custom_aa[v]["CT"].body_yaw.left_limit:set(custom_aa[v]["T"].body_yaw.left_limit:get())
            custom_aa[v]["CT"].body_yaw.right_limit:set(custom_aa[v]["T"].body_yaw.right_limit:get())
            custom_aa[v]["CT"].body_yaw.options:set(custom_aa[v]["T"].body_yaw.options:get())
            custom_aa[v]["CT"].body_yaw.freestanding:set(custom_aa[v]["T"].body_yaw.freestanding:get())

            custom_aa[v]["CT"].defensive_aa:set(custom_aa[v]["T"].defensive_aa:get())
            custom_aa[v]["CT"].defensive_aa.mode:set(custom_aa[v]["T"].defensive_aa.mode:get())
            custom_aa[v]["CT"].defensive_aa.allow_with_hide_shots:set(custom_aa[v]["T"].defensive_aa.allow_with_hide_shots:get())
            custom_aa[v]["CT"].defensive_aa.custom_defensive_aa_pitch:set(custom_aa[v]["T"].defensive_aa.custom_defensive_aa_pitch:get())
            custom_aa[v]["CT"].defensive_aa.random_pitch_first_value:set(custom_aa[v]["T"].defensive_aa.random_pitch_first_value:get())
            custom_aa[v]["CT"].defensive_aa.random_pitch_second_value:set(custom_aa[v]["T"].defensive_aa.random_pitch_second_value:get())
            custom_aa[v]["CT"].defensive_aa.custom_defensive_aa_yaw:set(custom_aa[v]["T"].defensive_aa.custom_defensive_aa_yaw:get())
            custom_aa[v]["CT"].defensive_aa.spin_speed:set(custom_aa[v]["T"].defensive_aa.spin_speed:get())
            custom_aa[v]["CT"].defensive_aa.switch_yaw_first_value:set(custom_aa[v]["T"].defensive_aa.switch_yaw_first_value:get())
            custom_aa[v]["CT"].defensive_aa.switch_yaw_second_value:set(custom_aa[v]["T"].defensive_aa.switch_yaw_second_value:get())
            custom_aa[v]["CT"].defensive_aa.random_yaw_first_value:set(custom_aa[v]["T"].defensive_aa.random_yaw_first_value:get())
            custom_aa[v]["CT"].defensive_aa.random_yaw_second_value:set(custom_aa[v]["T"].defensive_aa.random_yaw_second_value:get())
        end
    end
end, true)

-- #endregion

-- #region : Anti-aim builder

local stateid = 0
local stateid2 = 0
local ground_ticks, end_time = 1, 0
local state_name = "NONE"
local if_inverted = false
local safe_head_trigger = false
local yawadd = 0
local yaw_offset_add = 0
local ticks = 0
local is_edging = false
local vecTraceStart = vector(0, 0, 0)

in_air = function()
    if not entity.get_local_player() == nil then return end
    if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime + 1
    end
    return ground_ticks > 1 and end_time > globals.curtime
end

get_player_state = function(cmd)
    in_air()

    on_ground = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) ~= 0
    jump = end_time > (globals.curtime + 0.9)
    is_slowwalk = refs.slowwalk:get()
    crouch = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 1)) ~= 0 or refs.fakeduck:get()
    vx, vy, vz = entity.get_local_player().m_vecVelocity.x, entity.get_local_player().m_vecVelocity.y, entity.get_local_player().m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5

    local team = entity.get_local_player().m_iTeamNum == 2 and "T" or "CT"

    if not (refs.doubletap:get() or refs.hideshots:get()) and custom_aa["Fake Lag"][team].state_enable:get() then
        return "FAKE-LAG"
    else
        if on_ground and not move and not crouch then return "STANDING"
        elseif not jump and not crouch and not is_slowwalk then return "MOVING"
        elseif is_slowwalk and on_ground then return "SLOW-WALK"
        elseif crouch and not move and (not jump and on_ground) then return "CROUCH"
        elseif crouch and move and (not jump and on_ground) then return "CROUCH-MOVING"
        elseif jump and not crouch then return "AIR"
        elseif crouch and (jump or not on_ground) then return "AIR-C"
        end
    end
end

function anti_aim(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    state_name = get_player_state(cmd)

    local team = lp.m_iTeamNum == 2 and "T" or "CT"
    
    if custom_aa["Standing"][team].state_enable:get() and get_player_state(cmd) == "STANDING" then stateid = "Standing" stateid2 = 1
    elseif custom_aa["Moving"][team].state_enable:get() and get_player_state(cmd) == "MOVING" then stateid = "Moving" stateid2 = 2
    elseif custom_aa["Air"][team].state_enable:get() and get_player_state(cmd) == "AIR" then stateid = "Air" stateid2 = 3
    elseif custom_aa["Air-Crouching"][team].state_enable:get() and get_player_state(cmd) == "AIR-C" then stateid = "Air-Crouching" stateid2 = 4
    elseif custom_aa["Crouching"][team].state_enable:get() and get_player_state(cmd) == "CROUCH" then stateid = "Crouching" stateid2 = 5
    elseif custom_aa["Crouching Moving"][team].state_enable:get() and get_player_state(cmd) == "CROUCH-MOVING" then stateid = "Crouching Moving" stateid2 = 6
    elseif custom_aa["Slow-Walking"][team].state_enable:get() and get_player_state(cmd) == "SLOW-WALK" then stateid = "Slow-Walking" stateid2 = 7
    elseif custom_aa["Fake Lag"][team].state_enable:get() and get_player_state(cmd) == "FAKE-LAG" then stateid = "Fake Lag"
    else
        stateid = "Shared"
    end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end
    
    local weapon_class = weapon:get_classname()
    if weapon_class == nil then return end

    refs.avoid_backstab:override(menu.anti_aim.other.avoid_backstab:get())

    if menu.anti_aim.other.freestanding_disablers:get(freestanding_mass[stateid]) then
        refs.freestanding:override(false)
        refs.yaw_mod:override(false)
        refs.body_fs:override(false)
    else
        if menu.anti_aim.main.manual_yaw:get() == "Freestanding" then
            refs.freestanding:override(true)
            refs.yaw_mod:override(true)
            refs.body_fs:override(true)
        else
            refs.freestanding:override(false)
            refs.yaw_mod:override(false)
            refs.body_fs:override(false)
        end
    end

    refs.pitch:override("Down")

    refs.yaw:override("Backward")

    inverted = not rage.antiaim:inverter()

    if cmd.choked_commands == 0 then
        if custom_aa[stateid][team].yaw:get() == "Left And Right" then
            if custom_aa[stateid][team].yaw.swap_delay:get() and custom_aa[stateid][team].yaw.swap_delay_ticks:get() > 1 then

                ticks = ticks + 1
                
                if ticks > custom_aa[stateid][team].yaw.swap_delay_ticks:get() then
                    ticks = 0
                    if_inverted = not if_inverted
                end

                inverted = if_inverted

                refs.inverter:override(inverted)
            else
                refs.inverter:override()
            end

            refs.yaw_offset:override((inverted and custom_aa[stateid][team].yaw.yaw_left_offset:get() or custom_aa[stateid][team].yaw.yaw_right_offset:get()) + utils.random_float(-custom_aa[stateid][team].yaw.yaw_offset_variability:get() / 5, custom_aa[stateid][team].yaw.yaw_offset_variability:get() / 5))
        else
            refs.yaw_offset:override(custom_aa[stateid][team].yaw.yaw_static_offset:get())
        end
    end

    refs.yaw_modifier:override(custom_aa[stateid][team].yaw_modifier:get())
    refs.modifier_degree:override(custom_aa[stateid][team].yaw_modifier.yaw_modifier_offset:get() + utils.random_float(-custom_aa[stateid][team].yaw_modifier.yaw_modifier_offset_variability:get() / 5, custom_aa[stateid][team].yaw_modifier.yaw_modifier_offset_variability:get() / 5))

    refs.body_yaw:override(custom_aa[stateid][team].body_yaw:get())
    refs.left_limit:override(custom_aa[stateid][team].body_yaw.left_limit:get())
    refs.right_limit:override(custom_aa[stateid][team].body_yaw.right_limit:get())

    if custom_aa[stateid][team].yaw.swap_delay:get() and custom_aa[stateid][team].yaw.swap_delay_ticks:get() > 1 then
        refs.options:override("")
    else
        refs.options:override(custom_aa[stateid][team].body_yaw.options:get())
    end

    refs.freestanding_body:override(custom_aa[stateid][team].body_yaw.freestanding:get())

    local safe_head do
        local is_knife = weapon_class == "CKnife" local is_taser = weapon_class == "CWeaponTaser"

        local threat = entity.get_threat()

        if threat ~= nil then
            local my_origin = lp:get_origin()
            local threat_origin = threat:get_origin()
        
            local delta = threat_origin - my_origin
            local distancesqr = delta:length2dsqr()
    
            function values()
                refs.pitch:override("Down")
                refs.yaw_offset:override(0)
                refs.yaw_modifier:override("Disabled")
                refs.modifier_degree:override(0)
                refs.body_yaw:override(true)
                refs.options:override("")
                refs.left_limit:override(0)
                refs.right_limit:override(0)
                refs.freestanding_body:override("Off")
                refs.hidden_yaw:set(false)
            end
        
            if menu.anti_aim.other.safe_head:get() then
                safe_head_trigger = false
    
                if menu.anti_aim.other.safe_head.conditions:get("Knife") and is_knife and get_player_state(cmd) == "AIR-C" then
                    values()
                    safe_head_trigger = menu.anti_aim.other.safe_head.e_spam:get() and true or false
                elseif menu.anti_aim.other.safe_head.conditions:get("Taser") and is_taser and get_player_state(cmd) == "AIR-C" then
                    values()
                    safe_head_trigger = menu.anti_aim.other.safe_head.e_spam:get() and true or false
                elseif menu.anti_aim.other.safe_head.conditions:get("Height Advantage") and lp:get_origin().z - threat:get_origin().z > 55 then
                    values()
                end
            end
        end
    end

    local manual_aa do
        if menu.anti_aim.main.manual_yaw:get() == "Forward" then
            refs.yaw_offset:override(180)
            refs.yaw_base:override("Local View")
        elseif menu.anti_aim.main.manual_yaw:get() == "Left" then
            refs.yaw_offset:override(-90)
            refs.yaw_base:override("Local View")
        elseif menu.anti_aim.main.manual_yaw:get() == "Right" then
            refs.yaw_offset:override(90)
            refs.yaw_base:override("Local View")
        else
            refs.yaw_base:override("At Target")
        end
    
        if menu.anti_aim.main.manual_yaw.static_yaw:get() then
            if menu.anti_aim.main.manual_yaw:get() ~= "Disabled" then
                refs.yaw_modifier:override("Disabled")
                refs.modifier_degree:override(0)
                refs.options:override("")
            end
        end
    end

    local defensive_aa do
        if safe_head_trigger then
            refs.hidden_yaw:set(true)
            refs.lag_options:override("Always On")

            if custom_aa[stateid][team].defensive_aa.allow_with_hide_shots:get() then
                refs.hideshots_options:override("Break LC")
            else
                refs.hideshots_options:override("Favor Fire Rate")
            end

            rage.antiaim:override_hidden_pitch(0)
            rage.antiaim:override_hidden_yaw_offset(180)
        else
            refs.hidden_yaw:set(false)
    
            if custom_aa[stateid][team].defensive_aa:get() then
                refs.hidden_yaw:set(true)
    
                if custom_aa[stateid][team].defensive_aa.custom_defensive_aa_pitch:get() == "Down" then
                    rage.antiaim:override_hidden_pitch(89)
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_pitch:get() == "Zero" then
                    rage.antiaim:override_hidden_pitch(0)
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_pitch:get() == "Up" then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_pitch:get() == "Random" then
                    rage.antiaim:override_hidden_pitch(math.random(custom_aa[stateid][team].defensive_aa.random_pitch_first_value:get(), custom_aa[stateid][team].defensive_aa.random_pitch_second_value:get()))
                end
    
                if custom_aa[stateid][team].defensive_aa.custom_defensive_aa_yaw:get() == "Sideways" then
                    rage.antiaim:override_hidden_yaw_offset(inverted and -120 or 120)
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_yaw:get() == "Spin" then
                    if yawadd >= 180 then
                        yawadd = -180
                    else
                        yawadd = yawadd + custom_aa[stateid][team].defensive_aa.spin_speed:get()
                    end
                    rage.antiaim:override_hidden_yaw_offset(yawadd)    
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_yaw:get() == "Switch" then
                    rage.antiaim:override_hidden_yaw_offset(inverted and custom_aa[stateid][team].defensive_aa.switch_yaw_first_value:get() or custom_aa[stateid][team].defensive_aa.switch_yaw_second_value:get())
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_yaw:get() == "Forward" then
                    rage.antiaim:override_hidden_yaw_offset(inverted and 180 or -180)
                elseif custom_aa[stateid][team].defensive_aa.custom_defensive_aa_yaw:get() == "Random" then
                    rage.antiaim:override_hidden_yaw_offset(math.random(custom_aa[stateid][team].defensive_aa.random_yaw_first_value:get(), custom_aa[stateid][team].defensive_aa.random_yaw_second_value:get()))
                end
            else
                refs.lag_options:override("On Peek")
                refs.hideshots_options:override("Favor Fire Rate")
                refs.hidden_yaw:set(false)
            end
        end

        if menu.anti_aim.other.force_defensive:get(force_defensive_mass[stateid2]) and not custom_aa[stateid][team].defensive_aa:get() then
            refs.lag_options:override("Always On")
            refs.hideshots_options:override("Break LC")
        else
            if custom_aa[stateid][team].defensive_aa.mode:get() == "On Peek" then
                refs.lag_options:override("On Peek")
            elseif custom_aa[stateid][team].defensive_aa.mode:get() == "Always On" then
                refs.lag_options:override("Always On")
            else
                refs.lag_options:override("Disabled")
            end

            if custom_aa[stateid][team].defensive_aa.allow_with_hide_shots:get() then
                refs.hideshots_options:override("Break LC")
            else
                refs.hideshots_options:override("Favor Fire Rate")
            end
        end
    end

    local auto_lag_exploit do
        if menu.anti_aim.other.auto_lag_exploit:get() ~= "Disabled" then
            if menu.anti_aim.other.auto_lag_exploit:get() == "Default" then
                if globals.tickcount % (menu.anti_aim.other.auto_lag_exploit.ticks:get()) == 0 then
                    rage.exploit:force_teleport()
                else
                    rage.exploit:force_charge()
                end
            else
                if get_player_state(cmd) == "AIR-C" or get_player_state(cmd) == "AIR" then
                    if entity.get_threat(true) then
                        if globals.tickcount % 15 == 0 then
                            rage.exploit:force_teleport()
                        else
                            rage.exploit:force_charge()
                        end
                    end
                end
            end
        end
    end
end

-- #endregion

-- #region : Anti-aim builder visibility

function set_visible_aa()
    for i, v in next, stateenable_i do
        for index, value in next, {"CT", "T"} do 
            condit_fn2 = function()
                if i ~= 1 then
                    return custom_aa[v][value].state_enable:get()
                else
                    return true
                end
            end
    
            custom_aa[v][value].state_enable:visibility(menu.anti_aim.main.conditions:get() == v and menu.anti_aim.main.team:get() == value and i ~= 1)
            custom_aa[v][value].yaw:visibility(menu.anti_aim.main.conditions:get() == v and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.yaw_offset_variability:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Left And Right" and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.yaw_static_offset:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Static" and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.yaw_left_offset:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Left And Right" and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.yaw_right_offset:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Left And Right" and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.swap_delay:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Left And Right" and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw.swap_delay_ticks:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].yaw:get() == "Left And Right" and menu.anti_aim.main.team:get() == value and custom_aa[v][value].yaw.swap_delay:get() and condit_fn2())
            custom_aa[v][value].yaw_modifier:visibility(menu.anti_aim.main.conditions:get() == v and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].yaw_modifier.yaw_modifier_offset_variability:visibility(menu.anti_aim.main.conditions:get() == v and menu.anti_aim.main.team:get() == value and custom_aa[v][value].yaw_modifier:get() ~= "Disabled" and condit_fn2())
            custom_aa[v][value].yaw_modifier.yaw_modifier_offset:visibility(menu.anti_aim.main.conditions:get() == stateenable_i[i] and menu.anti_aim.main.team:get() == value and custom_aa[v][value].yaw_modifier:get() ~= "Disabled" and condit_fn2())
            custom_aa[v][value].body_yaw:visibility(menu.anti_aim.main.conditions:get() == v and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].body_yaw.left_limit:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].body_yaw:get() and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].body_yaw.right_limit:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].body_yaw:get() and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].body_yaw.options:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].body_yaw:get() and menu.anti_aim.main.team:get() == value and condit_fn2())
            custom_aa[v][value].body_yaw.freestanding:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].body_yaw:get() and menu.anti_aim.main.team:get() == value and condit_fn2())
    
            custom_aa[v][value].defensive_aa:visibility(menu.anti_aim.main.conditions:get() == v and condit_fn2() and menu.anti_aim.main.team:get() == value and v ~= 9)
            custom_aa[v][value].defensive_aa.mode:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.allow_with_hide_shots:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.custom_defensive_aa_pitch:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9) 
            custom_aa[v][value].defensive_aa.random_pitch_first_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_pitch:get() == "Random" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.random_pitch_second_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_pitch:get() == "Random" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.spin_speed:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:get() == "Spin" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.switch_yaw_first_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:get() == "Switch" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.switch_yaw_second_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:get() == "Switch" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.random_yaw_first_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:get() == "Random" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            custom_aa[v][value].defensive_aa.random_yaw_second_value:visibility(menu.anti_aim.main.conditions:get() == v and custom_aa[v][value].defensive_aa.custom_defensive_aa_yaw:get() == "Random" and custom_aa[v][value].defensive_aa:get() and menu.anti_aim.main.team:get() == value and condit_fn2() and v ~= 9)
            
            button_t:visibility(menu.anti_aim.main.team:get() == "CT")
            button_ct:visibility(menu.anti_aim.main.team:get() == "T" )
        end
    end
end

-- #endregion

-- #region : Animation breakers

local anim_breakers = function()
    if not menu.anti_aim.other.animation_breakers:get() then return end
    local lp = entity.get_local_player()
    if not lp or lp == nil then return end
    if lp:get_index() == nil then return end

    animslsg = get_entity_address(lp:get_index())

    local animstate = lp:get_anim_state()
    if not animstate or animstate == nil then return end

    move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
    jump = bit.band(lp.m_fFlags, 1) == 0

    if gear_funcs.animation_breakers_select:get("In Air Legs") then
        if gear_funcs.animation_breakers_select_in_air:get() == "Static" then
            lp.m_flPoseParameter[6] = 1
        elseif gear_funcs.animation_breakers_select_in_air:get() == "Jitter" then
            lp.m_flPoseParameter[6] = globals.tickcount % 4 > 1 and math.random(math.random(0.1, 5), 5) / 10 or math.random(0.1, 1)
        elseif gear_funcs.animation_breakers_select_in_air:get() == "Allah" and jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        else
            lp.m_flPoseParameter[6] = 0
        end
    end

    if gear_funcs.animation_breakers_select:get("Ground Legs") then
        if gear_funcs.animation_breakers_select_ground:get() == "Jitter" then
            lp.m_flPoseParameter[0] = globals.tickcount % 4 > 1 and math.random(utils.random_float(0.1, 1.0), 1) or math.random(0.1, 1)
        elseif gear_funcs.animation_breakers_select_ground:get() == "Allah" and move and not jump then
            lp.m_flPoseParameter[7] = 1
            refs.legs_movement:set("Walking")
        else
            lp.m_flPoseParameter[0] = 1
            refs.legs_movement:set("Sliding")
        end
    end

    if gear_funcs.animation_breakers_select:get("Addons") then
        if gear_funcs.animation_breakers_addons:get("Pitch 0 On Land") and animstate.landing then
            lp.m_flPoseParameter[12] = 0.5
        elseif gear_funcs.animation_breakers_addons:get("Move Lean") and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = gear_funcs.animation_breakers_addons_move_lean_amount:get() / 100
        elseif gear_funcs.animation_breakers_addons:get("Earth Quake") then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = utils.random_float(0.1, 1)
        end
    end
end

-- #endregion

-- #region : Screen-size references

local x = render.screen_size().x
local y = render.screen_size().y

-- #endregion

-- #region : Crosshair indicators

local indicators = function() 
    local lp = entity.get_local_player()
	if lp == nil or not lp:is_alive() then return end 

    local scoped = lp.m_bIsScoped
    local first_color = gear_funcs.crosshair_indicators_first_color:get()
    local second_color = gear_funcs.crosshair_indicators_second_color:get()
    local glow_color = gear_funcs.crosshair_indicators_glow_color:get()

    move_scope = animations.new("move_scope", scoped and 1 or 0, 0.1)

    dt_key_alpha = animations.new("dt_key_alpha", (refs.doubletap:get()) and 255 or 0, 0.1)
    osaa_key_alpha = animations.new("osaa_key_alpha", (refs.hideshots:get() and not refs.doubletap:get()) and 255 or 0, 0.1)

    key_move = animations.new("key_move", (refs.doubletap:get() or refs.hideshots:get()) and 10 or 0, 0.1)

    local gradient_text = gradient.text_animate("FROST BETA", -1, {color(first_color.r, first_color.g, first_color.b, 255), color(second_color.r, second_color.g, second_color.b, 255)})
    gradient_text:animate()

    local frost_size = render.measure_text(2, "c", "FROST BETA")
    render.shadow(vector(x/2 - frost_size.x/2 + (frost_size.x / 2 * move_scope), y/2 + 25), vector(x/2 + frost_size.x/2 + (frost_size.x / 2 * move_scope), y/2 + 26), color(glow_color.r, glow_color.g, glow_color.b, 255), 50, 0, 5)
    render.text(2, vector(x/2 + ((frost_size.x / 2 + 2) * move_scope), y/2 + 25), color(255), "c", gradient_text:get_animated_text()) 
    
    local state_size = render.measure_text(2, "c", state_name)
    render.text(2, vector(x / 2 + ((state_size.x / 2 + 5) * move_scope), y / 2 + 35), color(255, 255, 255, 255), "c", "-" .. state_name .. "-")

    local dt_size = render.measure_text(2, "c", "DT") local osaa_size = render.measure_text(2, "c", "OS-AA")
    render.text(2, vector(x / 2 + ((dt_size.x / 2 + 10) * move_scope), y / 2 + 35 + key_move), color(255, 255, 255, osaa_key_alpha), "c", "OS-AA")
    render.text(2, vector(x / 2 + ((osaa_size.x / 2 - 4) * move_scope), y / 2 + 35 + key_move), color(255, 255, 255, dt_key_alpha), "c", "DT")
end

-- #endregion

-- #region : Damage indicators

local damage_indicator = function()
    if not menu.settings.visuals.damage_indicator:get() then return end
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
    local min_damage_animated = animations.new("min_damage_animated", min_damage:get(), 0.2)

    render.text(1, vector(x / 2 + 4, y / 2 - 15), color(255, 255, 255, 255), nil, math.floor(min_damage_animated))
end 

-- #endregion

-- #region : Watermark

local watermark = function() 
    local frost_color = gear_funcs.watermark_color:get()

    if gear_funcs.watermark_style:get() == "Frost" then
        local gradient_animation_watermark_classic = gradient.text_animate("F R O S T L U A", -2, {color(frost_color.r, frost_color.g, frost_color.b, 255), color(50, 50, 50, 255)})
        gradient_animation_watermark_classic:animate()

        local gradient_animation_watermark_modern = gradient.text_animate(">/ frost anti aim - " .. common.get_username() .. " - [beta] /<", -2, {color(frost_color.r, frost_color.g, frost_color.b, 255), color(50, 50, 50, 255)})
        gradient_animation_watermark_modern:animate()

        if gear_funcs.watermark_style_frost_type:get() == "Classic" then
            if gear_funcs.watermark_position:get() == "Right" then
                render.text(1, vector(x - 90, y / 2 - 20), color(255, 255, 255, 255), nil, gradient_animation_watermark_classic:get_animated_text())
            elseif gear_funcs.watermark_position:get() == "Left" then
                render.text(1, vector(10, y / 2 - 20), color(255, 255, 255, 255), nil, gradient_animation_watermark_classic:get_animated_text())
            elseif gear_funcs.watermark_position:get() == "Bottom" then
                render.text(1, vector(x / 2, y - 10), color(255, 255, 255, 255), "c", gradient_animation_watermark_classic:get_animated_text())
            end
        else
            render.text(1, vector(10, y / 2 - 20), color(255, 255, 255, 255), nil, gradient_animation_watermark_modern:get_animated_text())
        end
    else
        local frost_lua_size = render.measure_text(1, nil, "frost.lua")
        
        render.gradient(vector(x - 180, 6), vector(x - 4, 28), color(0, 0, 0, 0), frost_color, color(0, 0, 0, 0), frost_color, 5)
        render.text(1, vector(x - 118, 10), color(255, 255, 255, 255), nil, "discord.gg/frostlua " .. ui.get_icon("snowflake"))
    end
end

-- #endregion

-- #region : Watermark

local manual_arrows_font = render.load_font("Verdana", 22, "bad")

local manual_arrows = function()
    if not menu.settings.visuals.manual_arrows:get() then return end
    local lp = entity.get_local_player()
    if not lp then return end

    local add_y = animations.new("add_y_manual_arrows", lp.m_bIsScoped and 15 or 0, 0.1)

    local accent_color = menu.settings.visuals.manual_arrows.accent_color:get()
    local manual_color = menu.settings.visuals.manual_arrows.manual_color:get()

    local add_x_offset = animations.new("add_x_offset", menu.settings.visuals.manual_arrows.offset:get(), 0.1)

    render.text(manual_arrows_font, vector(x / 2 + 43 + add_x_offset, y / 2 - 13 - add_y), menu.anti_aim.main.manual_yaw:get() == "Right" and manual_color or accent_color, nil, ">")
    render.text(manual_arrows_font, vector(x / 2 - 62 - add_x_offset, y / 2 - 13 - add_y), menu.anti_aim.main.manual_yaw:get() == "Left" and manual_color or accent_color, nil, "<")
end

-- #endregion

-- #region : Grenade Radius

local grenade_radius = { }

grenade_radius.get = function()
    local lp = entity.get_local_player() 
    if lp == nil then return end

    local CSmokeGrenadeProjectile = entity.get_entities("CSmokeGrenadeProjectile")
    local CInferno = entity.get_entities("CInferno")
    local is_not_friendly_fire = cvar.mp_friendlyfire:int() == 0

    local smoke = {}
    local molotov = {}

    local tickcount = globals.tickcount
    local tickinterval = globals.tickinterval

    if CSmokeGrenadeProjectile ~= nil then
        for k, v in pairs(CSmokeGrenadeProjectile) do
            if smoke[k] == nil then
                smoke[k] = {}
                smoke[k].position = vector(0, 0, 0)
                smoke[k].alpha = 0
                smoke[k].draw = false
            end

            smoke[k].position = v:get_origin()
            smoke[k].alpha = v:get_bbox().alpha*255

            if v.m_bDidSmokeEffect and v:get_bbox().alpha > 0 then
                smoke[k].draw = true
            end
        end
    end

    if CInferno ~= nil then
        for k, v in pairs(CInferno) do
            if molotov[k] == nil then
                molotov[k] = {}
                molotov[k].position = vector(0, 0, 0)
                molotov[k].alpha = 0
                molotov[k].draw = false
                molotov[k].teammate = false
            end

            local percentage = (7.125 -  tickinterval * (tickcount - v.m_nFireEffectTickBegin))/7.125
            molotov[k].position = v:get_origin()
            molotov[k].alpha = percentage*255

            local m_hOwnerEntity = v.m_hOwnerEntity

            if m_hOwnerEntity ~= nil and is_not_friendly_fire and m_hOwnerEntity ~= lp and not m_hOwnerEntity:is_enemy() then
                molotov[k].teammate = true
            end

            local cells = {}
            local highest_distance = 100
            for i = 1, 64 do
                if v.m_bFireIsBurning[i] then
                    table.insert(cells, {v.m_fireXDelta[i], v.m_fireYDelta[i], v.m_fireZDelta[i]})
                end
            end

            for i = 1, #cells do
				local cell = cells[i]
				local x_delta, y_delta, z_delta = unpack(cell)

				for i2 = 1, #cells do
					local cell2 = cells[i2]
					local distance = vector(x_delta, y_delta):dist(vector(cell2[1], cell2[2]))
					if distance > highest_distance then
						highest_distance = distance
					end
				end
			end

            if percentage > 0 then
                molotov[k].draw = true
                molotov[k].radius = highest_distance/2 + 40
            end
        end
    end

    return {smoke = smoke, molotov = molotov}
end

grenade_radius.render = function()
    local lp = entity.get_local_player()
    if lp == nil then return end

    if not menu.settings.visuals.grenade_radius:get() then return end 

    local grenade = grenade_radius.get()  
    if grenade == nil then return end

    local molotov_color = menu.settings.visuals.grenade_radius.molotov_color:get()
    local smoke_color = menu.settings.visuals.grenade_radius.smoke_color:get()

    local molotov_alpha = molotov_color.a / 255

    if menu.settings.visuals.grenade_radius.select:get("Molotov") then
        for i = 1, #grenade.molotov do
            local v = grenade.molotov[i]
            local molotov_radius = { } molotov_radius[i] = animations.new("molotov_radius" .. i, v.draw and v.radius or 0, 0.095)
    
            if v.draw then
                render.circle_3d_outline(v.position, molotov_color, molotov_radius[i], 0, 1, 1.5)
                render.text(2, render.world_to_screen(v.position), color(255), nil, "MOLLY")
            end
        end
    end

    if menu.settings.visuals.grenade_radius.select:get("Smoke") then
        for i = 1, #grenade.smoke do
            local v = grenade.smoke[i]
            local smoke_radius = { } smoke_radius[i] = animations.new("smoke_radius" .. i, v.draw and 125 or 0, 0.095)
    
            if v.draw then
                render.circle_3d_outline(v.position, smoke_color, smoke_radius[i], 0, 1, 1.5)
                render.text(2, render.world_to_screen(v.position), color(255), nil, "SMOKE")
            end
        end
    end
end

-- #endregion

-- #region : Custom scope overlay

local length = 0
local gap = 0

local custom_scope = function() 
    local lp = entity.get_local_player()
    if menu.settings.visuals.custom_scope_overlay:get() then
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")
        if lp == nil then return end
        if lp.m_iHealth < 1 then return end
		length = animations.new("length", lp.m_bIsScoped and gear_funcs.custom_scope_overlay_line:get() or 0, 0.1) 
		gap = animations.new("gap", lp.m_bIsScoped and gear_funcs.custom_scope_overlay_gap:get() or 0, 0.1) 
		local scopeColor_x = color(gear_funcs.custom_scope_overlay_color:get().r, gear_funcs.custom_scope_overlay_color:get().g, gear_funcs.custom_scope_overlay_color:get().b, gear_funcs.custom_scope_overlay_inverted:get() and 0 or gear_funcs.custom_scope_overlay_color:get().a)
		local scopeColor_y = color(gear_funcs.custom_scope_overlay_color:get().r, gear_funcs.custom_scope_overlay_color:get().g, gear_funcs.custom_scope_overlay_color:get().b, gear_funcs.custom_scope_overlay_inverted:get() and gear_funcs.custom_scope_overlay_color:get().a or 0)
		render.gradient(vector(x / 2 - gap, y / 2), vector(x / 2 - gap - length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2 + gap, y / 2), vector(x / 2 + gap + length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 + gap), vector(x / 2 + 1, y / 2 + gap + length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
		render.gradient(vector(x / 2, y / 2 - gap), vector(x / 2 + 1, y / 2 - gap - length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
	else
		ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove Overlay")
	end
end

-- #endregion

-- #region : GS Indicators

local calibri = render.load_font("Calibri Bold", 24, "ad")

local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))

local function calc_dist(pos1, pos2)
    local lx = pos1.x
    local ly = pos1.y
    local lz = pos1.z
    local tx = pos2.x
    local ty = pos2.y
    local tz = pos2.z
    local dx = lx - tx
    local dy = ly - ty
    local dz = lz - tz
    return math.sqrt(dx * dx + dy * dy + dz * dz);
end

local hitted, reg_shot = 0, 0

local hitrate_stuff = function(e)
    if e.state == nil then hitted = hitted + 1 end
    reg_shot = reg_shot + 1
end

local function render_indicators(text, colors, ind_dst, img)
    local ts = render.measure_text(calibri, "ad", text)
    local x = 28
    local y = y - 350
    if img then
        render.gradient(vector(5, y + 3 - ind_dst), vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80))
        render.gradient(vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 3 - ind_dst), vector(x + (ts.x) + (img.width) + 29, y + 37 - ind_dst), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0))
        render.texture(img, vector(x, y + 6 - ind_dst), colors)
        render.text(calibri, vector(x + (img.width) + 6, y + 10 - ind_dst), colors, "d", text)
    else
        render.gradient(vector(5, y + 3 - ind_dst), vector(x + (ts.x) / 2, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80))
        render.gradient(vector(x + (ts.x) / 2, y + 3 - ind_dst), vector(x + (ts.x) + 23, y + 37 - ind_dst), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0))
        render.text(calibri, vector(x, y + 4 - ind_dst + 5), colors, "d", text)
    end
end

local gamesense_indicators = function()
    if not menu.settings.visuals.gamesense_indicators:get() then return end
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end  
    if lp == nil or not lp:is_alive() then hitted, reg_shot = 0, 0 end

	local ind_dst = 0
    local ind_spr = 41

    local x = 28
    local y = y - 350

    if menu.settings.visuals.gamesense_indicators.select:get("Hit/Miss") then
		local percent = hitted > 0 and reg_shot > 0 and (hitted / reg_shot) * 100 or 0
        render_indicators(string.format("%d/%d (%.1f)", hitted, reg_shot, percent), color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

    if menu.settings.visuals.gamesense_indicators.select:get("Ping Reduce") and refs.fake_latency:get() > 0 then
		render_indicators("PING", color(150, 189, 18, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

	if menu.settings.visuals.gamesense_indicators.select:get("Double Tap") and menu.settings.visuals.gamesense_indicators.select:get("Hideshots") then
		if refs.doubletap:get() and refs.hideshots:get() then
			render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
			ind_dst = ind_dst + ind_spr
		elseif refs.hideshots:get() then
			render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
			ind_dst = ind_dst + ind_spr
		elseif refs.doubletap:get() then
			render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
			ind_dst = ind_dst + ind_spr
		end
    elseif menu.settings.visuals.gamesense_indicators.select:get("Doubletap") and refs.doubletap:get() then
		render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	elseif menu.settings.visuals.gamesense_indicators.select:get("Hideshots") and refs.hideshots:get() then
		render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end
    
    if menu.settings.visuals.gamesense_indicators.select:get("Freestanding") and refs.freestanding:get() then
		render_indicators("FS", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

    if menu.settings.visuals.gamesense_indicators.select:get("Force Baim") and refs.body_aim:get() == "Force" then
		render_indicators("BODY", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

    if menu.settings.visuals.gamesense_indicators.select:get("Min. damage override") and get_bind("Min. Damage")[1] then
		render_indicators("MD", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

    if menu.settings.visuals.gamesense_indicators.select:get("Hitchance Override") and get_bind("Hit Chance")[1] then
		render_indicators("HC", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end
    	
	if menu.settings.visuals.gamesense_indicators.select:get("Fake Duck") and refs.fakeduck:get() then
		render_indicators("DUCK", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

    local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
    if menu.settings.visuals.gamesense_indicators.select:get("Dormant aim") and refs.dormant_aimbot:get() then
        if dormant_work then
            render_indicators("DA", color(215, 215, 215, 255), ind_dst)
        else
            render_indicators("DA", color(255, 0, 0, 255), ind_dst)
        end
        ind_dst = ind_dst + ind_spr
    end

    if menu.settings.visuals.gamesense_indicators.select:get("Force safepoint") and refs.safe_point:get() == "Force" then
		render_indicators("SAFE", color(215, 215, 215, 255), ind_dst)
		ind_dst = ind_dst + ind_spr
	end

	if menu.settings.visuals.gamesense_indicators.select:get("Bomb Info") then
		local c4 = entity.get_entities("CPlantedC4")[1];
		if c4 ~= nil then
            local lp = entity.get_local_player()
            if lp == nil then return end
            local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
            local defused = c4.m_bBombDefused
			if math.floor(time) >= -1 and not defused then
                local defusestart = c4.m_hBombDefuser ~= 4294967295
                local defuselength = c4.m_flDefuseLength
                local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1
				if defusetimer > 0 and not abort_defuse then
                    local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                    local barlength = (((screen.y - 50) / defuselength) * (defusetimer))
                    render.rect(vector(0, 0), vector(16, screen.y), color(25, 25, 25, 160))
                    render.rect(vector(0, screen.y - barlength), vector(16, screen.y), col)
                end
				local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                local health = lp.m_iHealth
                local armor = lp.m_ArmorValue
                local will_die = false
                local eLoc = c4.m_vecOrigin
                local lLoc = lp.m_vecOrigin
                local distance = calc_dist(eLoc, lLoc)
                local a = 450.7
                local b = 75.68
                local c = 789.2
                local d = (distance - b) / c;
				local damage = a * math.exp(-d * d)
                if armor > 0 then
                    local newDmg = damage * 0.5;
                    local armorDmg = (damage - newDmg) * 0.5
                    if armorDmg > armor then
                        armor = armor * (1 / .5)
                        newDmg = damage - armorDmg
                    end
                    damage = newDmg;
                end
				local dmg = math.ceil(damage)
                if dmg >= health then
                    will_die = true
                else
                    will_die = false
                end
                if time > 0.01 then
                    render_indicators(bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, bomb_img)
                    ind_dst = ind_dst + ind_spr

                    if lp:is_alive() then
                        if will_die then
                            render_indicators("FATAL", color(255, 0, 0, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        elseif damage > 0.5 then
                            render_indicators("-" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end
			end
		end

		if bomb.state == false then
			render_indicators(bomb.site, color(255, 240, 100, 255), ind_dst, bomb_img)
            ts = render.measure_text(calibri, "ad", bomb.site) + vector(20, 0)
            render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(0, 0, 0, 255), 9.5, 0, 1, 4)
            render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(255, 255, 255, 255), 9, 0, bomb.plant_percentage, 3)
			ind_dst = ind_dst + ind_spr
        end
	end
end

-- #endregion

-- #region : R8 Helper

local width = 1
local alpha = 255
local queue = {}

local on_fire = function(e)
    queue[#queue + 1] = {
        e.aim.x,
        e.aim.y,
        e.aim.z,
        globals.realtime + refs.bullet_impact_duration:get()
    }
end

local hitmarker_world = function()
    if not menu.settings.visuals.hitmarker_world:get() then return end

    for tick, data in pairs(queue) do
        if data[1] and globals.is_connected then
            local pos = render.world_to_screen(vector(data[1], data[2], data[3]))
            if pos ~= nil then
                if width <= 2 then
                    render.line(vector(pos.x - 6, pos.y), vector(pos.x + 6, pos.y), menu.settings.visuals.hitmarker_world.hitmarker_color:get())
                    if width == 2 then
                        render.line(vector(pos.x - 6, pos.y + 1), vector(pos.x + 6, pos.y + 1), color(menu.settings.visuals.hitmarker_world.hitmarker_color:get().r, menu.settings.visuals.hitmarker_world.hitmarker_color:get().g, menu.settings.visuals.hitmarker_world.hitmarker_color:get().b, alpha:get()))
                    end

                    render.line(vector(pos.x, pos.y - 6), vector(pos.x, pos.y + 6), menu.settings.visuals.hitmarker_world.hitmarker_color:get())
                    if width == 2 then
                        render.line(vector(pos.x + 1, pos.y - 6), vector(pos.x + 1, pos.y + 6), color(menu.settings.visuals.hitmarker_world.hitmarker_color:get().r, menu.settings.visuals.hitmarker_world.hitmarker_color:get().g, menu.settings.visuals.hitmarker_world.hitmarker_color:get().b, alpha:get()))
                    end
                else
                    render.rect(vector(pos.x - 6, pos.y - (width - 2)), vector(pos.x + 6, pos.y + (width - 2)), menu.settings.visuals.hitmarker_world.hitmarker_color:get())
                    render.rect(vector(pos.x - (width - 2), pos.y - 6), vector(pos.x + (width - 2), pos.y + 6), menu.settings.visuals.hitmarker_world.hitmarker_color:get())
                end
            end
        end
        if globals.realtime > data[4] then
            table.remove(queue, tick)
        end
    end
end

-- #endregion

-- #region : R8 Helper

local low_health = 20

local r8_helper = esp.enemy:new_text("R8 Helper", "DMG+", function(player)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    if not menu.settings.ragebot.r8_helper:get() then return end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end

    local weapon_index = weapon:get_weapon_index()
    if weapon_index == nil then return end

    local dist_local = lp:get_origin()
    local dist_enemy = player:get_origin()
    local un = dist_local:dist(dist_enemy)

    if weapon_index == 64 then
        if (player['m_ArmorValue']) == 0 then
            if un < 585 then
                return "DMG+"
            else
                return
            end
        else
            return
        end
    else
        return
    end
end)

-- #endregion

-- #region : Notify

local notify_data = {}

local notifications = function()
    local y_add = 0
    
    for i, logs in ipairs(notify_data) do
        if logs.time + 2 > globals.realtime then
            logs.alpha = math.lerp(logs.alpha, 255, 0.095)
        end

        local string = tostring(logs.text)

        local accent_color = logs.color

        local size = render.measure_text(1, "", tostring(string)).x / 2

        render.rect(vector(x / 2 - size - 10, y / 1.15 - y_add - 6), vector(x / 2 + size + 10, y / 1.15 - y_add + 20), color(15, 15, 15, logs.alpha), 12)
        render.shadow(vector(x / 2 - size - 10, y / 1.15 - y_add - 6), vector(x / 2 + size + 10, y / 1.15 - y_add + 20), color(accent_color.r, accent_color.g, accent_color.b, logs.alpha * 0.8), 40, 0, 12)
        render.text(1, vector(x / 2 - size, y / 1.15 - y_add), color(255, 255, 255, logs.alpha), nil, string)

        y_add = y_add + 35 * logs.alpha / 255

        if logs.time + 5 < globals.realtime then
            logs.alpha = math.lerp(logs.alpha, 0, 0.095)
        end

        if logs.alpha < 1 or #notify_data > 5 then
            table.remove(notify_data, i)
        end
    end
end

-- #endregion

-- #region : Aimbot logs

local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

local ragebot_logs = function(e)
    if menu.settings.misc.aimlogs:get() == false then return end
    local id = e.id
    local target = entity.get(e.target)
    local damage = e.damage
    local wanted_damage = e.wanted_damage
    local hitgroup = hitgroup_str[e.hitgroup]
    local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
    local hitchance = e.hitchance
    local state = e.state
    local bt = e.backtrack
    if not target then return end
    if target == nil then return end
    local health = target["m_iHealth"]
    local type_hit = 'hit'

    if weapon == 'hegrenade' then 
        type_hit = 'naded'
    end

    if weapon == 'inferno' then
        type_hit = 'burned'
    end

    if weapon == 'knife' then 
        type_hit = 'knifed'
    end

    if state == nil then
        if menu.settings.misc.aimlogs.select:get("Notify") then
            table.insert(notify_data, 1, {
                text = "\a" .. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "" .. ui.get_icon("snowflake") .. "\aDEFAULT  Hit \a" .. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "" .. target:get_name() .. "\aDEFAULT in the \a" .. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. hitgroup .."\aDEFAULT for \a" .. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. e.damage .."" , 
                alpha = 0, time = globals.realtime, color = menu.settings.misc.aimlogs.hit_color:get()})
        else
            notify_data = {}
        end

        if menu.settings.misc.aimlogs.select:get("Event") then
            print_dev((""..type_hit.."\a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. " ".. string.lower(target:get_name()) .."\aDEFAULT hb: \a" .. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. hitgroup .." \aDEFAULTdmg: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. e.damage .."\aDEFAULT bt: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. bt .."\aDEFAULT hc: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. hitchance .."%\aDEFAULT"))
        end
        if menu.settings.misc.aimlogs.select:get("Console") then
            print_raw(("\aA39DDFD8frost\aDEFAULT • "..type_hit.."\a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. " ".. string.lower(target:get_name()) .."\aDEFAULT hb: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. hitgroup .." \aDEFAULTdmg: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. e.damage .."\aDEFAULT bt: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. bt .."\aDEFAULT hc: \a".. menu.settings.misc.aimlogs.hit_color:get():to_hex() .. "".. hitchance .."%\aDEFAULT"))
        end
    else
        if menu.settings.misc.aimlogs.select:get("Notify") then
            table.insert(notify_data, 1, {
                text = "\a" .. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "" .. ui.get_icon("snowflake") .. "\aDEFAULT  Missed \a" .. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "shot\aDEFAULT due to \a" .. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. state .."", 
                alpha = 0, time = globals.realtime, color = menu.settings.misc.aimlogs.miss_color:get()})
        else
            notify_data = {}
        end

        if menu.settings.misc.aimlogs.select:get("Event") then
            print_dev(("missed shot\a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. " ".. string.lower(target:get_name()) .."\aDEFAULT r: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. state .."\aDEFAULT hb: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. wanted_hitgroup .." \aDEFAULTbt: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. bt .."\aDEFAULT"))
        end
        if menu.settings.misc.aimlogs.select:get("Console") then
            print_raw(("\aA39DDFD8frost\aDEFAULT • missed shot\a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. " ".. string.lower(target:get_name()) .."\aDEFAULT r: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. state .."\aDEFAULT hb: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. wanted_hitgroup .." \aDEFAULTbt: \a".. menu.settings.misc.aimlogs.miss_color:get():to_hex() .. "".. bt .."\aDEFAULT"))
        end
    end
end

-- #endregion

-- #region : Fake latency unlocker

local fake_latency_unlocker = function()
    if menu.settings.misc.fake_latency_unlocker:get() then
        cvar.sv_maxunlag:float(0.400)
        refs.fake_latency:override(menu.settings.misc.fake_latency_unlocker.ping:get())
    else
        cvar.sv_maxunlag:float(0.200)
        refs.fake_latency:override()
    end
end

-- #endregion

-- #region : Viewmodel changer

local viewmodel_changer = function()
    local lp = entity.get_local_player()
    if lp == nil then return end

    if gear_funcs.cs2_scope_viewmodel:get() then
        refs.force_viewmodel:set(true)
    else
        refs.force_viewmodel:set(false)
    end

    viewmodel_fov_interpolated = animations.new("viewmodel_fov_interpolated", menu.settings.misc.viewmodel:get() and (gear_funcs.cs2_scope_viewmodel:get() and (lp.m_bIsScoped and 30 or menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_fov:get() or get_original(cvar.viewmodel_fov)) or (menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_fov:get() or get_original(cvar.viewmodel_fov))) or get_original(cvar.viewmodel_fov), 0.05)
    viewmodel_x_interpolated = animations.new("viewmodel_x_interpolated", menu.settings.misc.viewmodel:get() and (gear_funcs.cs2_scope_viewmodel:get() and (lp.m_bIsScoped and -5.5 or menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_x:get() / 100 or get_original(cvar.viewmodel_offset_x)) or (menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_x:get() / 100 or get_original(cvar.viewmodel_offset_x))) or get_original(cvar.viewmodel_offset_x), 0.05)
    viewmodel_y_interpolated = animations.new("viewmodel_y_interpolated", menu.settings.misc.viewmodel:get() and (gear_funcs.cs2_scope_viewmodel:get() and (lp.m_bIsScoped and 5 or menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_y:get() / 100 or get_original(cvar.viewmodel_offset_y)) or (menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_y:get() / 100 or get_original(cvar.viewmodel_offset_y))) or get_original(cvar.viewmodel_offset_y), 0.05)
    viewmodel_z_interpolated = animations.new("viewmodel_z_interpolated", menu.settings.misc.viewmodel:get() and (gear_funcs.cs2_scope_viewmodel:get() and (lp.m_bIsScoped and -4 or menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_z:get() / 100 or get_original(cvar.viewmodel_offset_z)) or (menu.settings.misc.viewmodel:get() and gear_funcs.viewmodel_z:get() / 100 or get_original(cvar.viewmodel_offset_z))) or get_original(cvar.viewmodel_offset_z), 0.05)
    
    cvar.viewmodel_fov:int(viewmodel_fov_interpolated, true)
    cvar.viewmodel_offset_x:float(viewmodel_x_interpolated, true)
    cvar.viewmodel_offset_y:float(viewmodel_y_interpolated, true)
    cvar.viewmodel_offset_z:float(viewmodel_z_interpolated, true)
end

-- #endregion

-- #region : Aspect ratio changer

local aspect_ratio = function() 
    aspect_ratio_value_interpolated = animations.new("aspect_ratio_value_interpolated", gear_funcs.aspect_ratio_value:get() / 100, 0.05)
    
    if menu.settings.misc.aspect_ratio:get() then
        cvar.r_aspectratio:float(aspect_ratio_value_interpolated)
    else
        cvar.r_aspectratio:float(0)
    end
end

-- #endregion

-- #region : Perfomance boost

local perfomance_boost = function()
    if menu.settings.misc.perfomance_boost:get() then
        table.insert(notify_data, 1, {
            text = "All cvars have been successfully updated!", 
            alpha = 0, time = globals.realtime, color = color(255, 255, 255, 255)})

        cvar.cl_disable_ragdolls:int(1, true)
        cvar.dsp_slow_cpu:int(1, true)
        cvar.mat_disable_bloom:int(1, true)
        cvar.r_drawparticles:int(0, true)
        cvar.func_break_max_pieces:int(0, true)
        cvar.mat_queue_mode:int(2, true)
        cvar.muzzleflash_light:int(0, true)
        cvar.mat_hdr_enabled:int(0, true)
        cvar.r_eyemove:int(0, true)
        cvar.r_eyegloss:int(0, true)
        cvar.fps_max:int(0, true)
    end
end
 
-- #endregion

-- #region : Unmute silenced players

local toggle_mute = panorama.FriendsListAPI.ToggleMute
local is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted

local unmute_silenced_players = function()
    if menu.settings.misc.unmute_silenced_players:get() then
        local players = entity.get_players(true, true, function(player)
            local info = player:get_player_info()
            local steamid64 = info.steamid64
            local is_muted = is_muted(steamid64)
    
            if is_muted then
                toggle_mute(steamid64)
            end
        end)
    end
end

-- #endregion

-- #region : Clantag

local clantag = {} do
    clantag.time_to_ticks = function(t) return math.floor(t / globals.tickinterval + 0.5) end
    clantag.vars = {
        clantag_cache = "",
        set_clantag = function(self, tag)
            if tag ~= self.clantag_cache then
                common.set_clan_tag(tag)    
                self.clantag_cache = tag
            end
        end
    }
    clantag.animation = function(text, indices)
        local text_anim = "               " .. text .. "                      " 
        local netchann_info = utils.net_channel()
        if netchann_info == nil then return end
        local tickcount = globals.tickcount + clantag.time_to_ticks(netchann_info.latency[0] + 0.321)
        local i = tickcount / clantag.time_to_ticks(0.3)
        i = math.floor(i % #indices)
        i = indices[i+1]+1
        return text_anim:sub(i, i+15)
    end
    clantag.clan_tag_prev = ''
    clantag.executer = function()
        local local_player = entity.get_local_player()
        if not local_player then return end
        if menu.settings.misc.clantag:get() then
            local clan_tag = clantag.animation("frost", {0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23})
            local game_rules = entity.get_game_rules()
            if game_rules.m_gamePhase == 5 or game_rules.m_timeUntilNextPhaseStarts ~= 0 then
                clantag.vars:set_clantag(clantag.animation("frost", {11}))
            end
            if clan_tag ~= clantag.clan_tag_prev then
                clantag.vars:set_clantag(clan_tag)
            end
            clantag.clan_tag_prev = clan_tag
        end
    end
end

menu.settings.misc.clantag:set_callback(function(el) if not el:get() then common.set_clan_tag("\0") end end)
events.pre_render:set(clantag.executer)

-- #endregion

-- #region : Killsay

local killsay = function(enemy)
    if menu.settings.misc.killsay:get() then
        local player = entity.get_local_player():get_player_info()['userid']
        local enemys = enemy['userid']
        local attack = enemy['attacker']
        if enemys ~= player and player == attack then
            utils.execute_after(menu.settings.misc.killsay.delay:get() / 10, function() utils.console_exec('say 1') end)
        end
    end
end

-- #endregion

-- #region : No fall damage

local nofalldamage = function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if menu.settings.misc.no_fall_damage:get() then
        local origin = lp:get_origin()
        if lp.m_vecVelocity.z <= -500 then
            if utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 15)).fraction ~= 1 then
                cmd.in_duck = 0
            elseif utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 50)).fraction ~= 1 then
                cmd.in_duck = 1
            end
        end   
    end
end

-- #endregion

-- #region : Supertoss

local WEAPONTYPE_GRENADE = 9
local GRENADE_SECONDARY_DAMPENING = 0.3

local function get_throw_toss(throw_angle, throw_velocity, throw_strength, abs_velocity)
    local vel = math.clamp(throw_velocity, 15, 750)
    local clamped_throw_strength = math.clamp(throw_strength, 0.0, 1.0)

    vel = vel * math.lerp(GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

    local forward = vector():angles(throw_angle)
    local throw = forward * vel - abs_velocity

    return throw:angles()
end

local supertoss = function(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    if menu.settings.misc.super_toss:get() then
        if render.camera_angles() ~= cmd.view_angles:clone() then return end
    
        local weapon = lp:get_player_weapon()
        if weapon == nil then return end
    
        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end
    
        local weapon_type = weapon_info.weapon_type
    
        if weapon_type == WEAPONTYPE_GRENADE then
            local predicted_time = globals.curtime - to_time(globals.clock_offset)
            
            if weapon.m_fThrowTime > predicted_time then
                cmd.in_speed = true
    
                cmd.view_angles = get_throw_toss(
                    render.camera_angles(),
                    weapon_info.throw_velocity,
                    weapon.m_flThrowStrength,
                    lp.m_vecVelocity
                )
            end
        end
    end
end

-- #endregion

-- #region : Nade throw fix

local nade_throw_fix = function()
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end

    local weapon_info = weapon:get_weapon_info()
    if weapon_info == nil then return end

    local weapon_type = weapon_info.weapon_type
    if weapon == nil then return end

    if menu.settings.misc.nade_throw_fix:get() then
        if weapon_type == 9 then
            refs.weapon_actions:override("")
        else
            refs.weapon_actions:override()
        end
    else
        refs.weapon_actions:override()
    end
end

-- #endregion

-- #region : Dormant Aimbot

local WEAPONTYPE_SNIPER_RIFLE = 5

local aim_target
local aim_point
local aim_hitbox
local aim_damage
local aim_accuracy

local is_hit = false
local is_shot = false

local target_index = 1
local round_started = 0.0

local e_hitbox = {
    [0]  = "Generic",
    [1]  = "Head",
    [2]  = "Chest",
    [3]  = "Stomach",
    [4]  = "Chest",
    [5]  = "Chest",
    [6]  = "Legs",
    [7]  = "Legs",
    [8]  = "Head",
    [10] = "Gear"
}

local hitbox_points = {
    {
        scale = 5,
        hitbox = "Stomach",
        vec = vector(0, 0, 40)
    },

    {
        scale = 6,
        hitbox = "Chest",
        vec = vector(0, 0, 50)
    },

    {
        scale = 3,
        hitbox = "Head",
        vec = vector(0, 0, 58)
    },

    {
        scale = 4,
        hitbox = "Legs",
        vec = vector(0, 0, 20)
    }
}

local function contains(list, value)
    for i = 1, #list do
        if list[i] == value then
            return true
        end
    end

    return false
end

local function is_weapon_gun(type)
    return type >= 1 and type <= 6
end

local function get_aimbot_targets()
    local list = { }

    local player_resource = entity.get_player_resource()

    for i = 1, globals.max_players do
        local player = entity.get(i)

        if player == nil then
            goto continue
        end

        local is_target_valid = player_resource.m_bConnected[i]
            and player:is_enemy() and player:is_dormant()

        if not is_target_valid then
            goto continue
        end

        table.insert(list, player)
        ::continue::
    end

    return list
end

local function create_multipoints(from, to, radius)
    local angles = from:to(to):angles()
    local radian = math.rad(angles.y + 90)

    local forward = vector(math.cos(radian), math.sin(radian), 0)
    local direction = forward * radius

    return {
        {
            text = "Middle",
            vec = to
        },

        {
            text = "Left",
            vec = to + direction
        },

        {
            text = "Right",
            vec = to - direction
        }
    }
end

local function trace_bullet(player, start_pos, end_pos, skip)
    local damage, trace = utils.trace_bullet(player, start_pos, end_pos, skip)

    if trace ~= nil then
        local ent = trace.entity

        if ent == nil then
            return 0, trace
        end

        if ent:is_player() and not ent:is_enemy() then
            return 0, trace
        end
    end

    return damage, trace
end

local dormant_aimbot = function(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end
    
    if menu.settings.ragebot.dormant_aimbot:get() then
        refs.dormant_aimbot:override(false)

        local weapon = lp:get_player_weapon()
        if weapon == nil then return end

        local weapon_info = weapon:get_weapon_info()
        if weapon_info == nil then return end

        local inaccuracy = weapon:get_inaccuracy()
        if inaccuracy == nil then return end

        local tickcount = globals.tickcount

        local eye_pos = lp:get_eye_position()
        local simtime = lp:get_simulation_time().current

        local onground = bit.band(lp.m_fFlags, bit.lshift(1, 0)) ~= 0

        if tickcount < round_started then
            return
        end

        if cmd.in_jump and not onground then
            return
        end

        local weapon_type = weapon_info.weapon_type

        if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
            return false
        end

        local targets = get_aimbot_targets()
        local hitboxes = menu.settings.ragebot.dormant_aimbot.hitboxes:get()

        if tickcount % #targets ~= 0 then
            target_index = target_index + 1
        else
            target_index = 1
        end

        local target = targets[target_index]

        if target == nil then
            return
        end

        local bbox = target:get_bbox()
        local origin = target:get_origin()

        local duck_amount = target.m_flDuckAmount

        local hitchance = menu.settings.ragebot.dormant_aimbot.accuracy:get()
        local desired_damage = menu.settings.ragebot.dormant_aimbot.minimum_damage:get()

        if desired_damage == -1 then
            desired_damage = refs.minimum_damage:get()
        end

        if desired_damage > 100 then
            desired_damage = desired_damage - 100 + target.m_iHealth
        end

        local points = { }

        for i = 1, #hitbox_points do
            local data = hitbox_points[i]

            local vec = data.vec
            local scale = data.scale
            local hitbox = data.hitbox

            if hitbox == "Head" then
                vec = vec - vector(0, 0, 10 * duck_amount)
            end

            if hitbox == "Chest" then
                vec = vec - vector(0, 0, 4 * duck_amount)
            end

            if #hitboxes ~= 0 then
                if contains(hitboxes, hitbox) then
                    table.insert(points, {
                        vec = vec,
                        scale = scale,
                        hitbox = hitbox
                    })
                end
            else
                table.insert(points, 1, {
                    vec = vec,
                    scale = scale,
                    hitbox = hitbox
                })
            end
        end

        local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
            or math.max(lp.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime

        if not is_available_to_shoot then
            return
        end

        local found_pos
        local found_damage

        if hitchance >= math.floor(bbox.alpha * 100) + 5 then
            return
        end

        for j = 1, #points do
            local point = points[j]
            local multipoints = create_multipoints(eye_pos, origin + point.vec, point.scale)

            for k = 1, #multipoints do
                local multipoint = multipoints[k]
                local aimpoint = multipoint.vec

                local damage, tr = trace_bullet(lp, eye_pos, aimpoint, function(ent)
                    return ent == target
                end)

                if tr ~= nil and tr:is_visible() then
                    goto continue
                end

                if damage ~= 0 and desired_damage < damage then
                    found_pos = aimpoint
                    found_damage = damage

                    aim_target = target
                    aim_hitbox = point.hitbox
                    aim_damage = damage
                    aim_point = multipoint.text
                    aim_accuracy = bbox.alpha

                    break
                end

                ::continue::
            end

            if found_pos and found_damage then
                break
            end
        end

        if not found_pos or not found_damage then
            return
        end

        local angles = eye_pos:to(found_pos):angles()

        cmd.block_movement = 1

        if inaccuracy < 0.01 then
            cmd.view_angles = angles
            cmd.in_attack = true

            is_shot = true
        end
    else
        refs.dormant_aimbot:override()
    end
end

-- #endregion

-- #region : Hitchance

local hitchance = function(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end
    
    local weapon_index = weapon:get_weapon_index()
    if weapon_index == nil then return end
    
    if menu.settings.ragebot.hitchance:get() then
        if get_player_state(cmd) == "AIR-C" or get_player_state(cmd) == "AIR" then
            if weapon_index == 1 or weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61 then
                refs.pistols_hitchance:override(menu.settings.ragebot.hitchance.pistols_air_amount:get())
            end

            if weapon_index == 38 or weapon_index == 11 then
                refs.auto_snipers_hitchance:override(menu.settings.ragebot.hitchance.auto_snipers_air_amount:get())
            end

            if weapon_index == 9 then
                refs.awp_hitchance:override(menu.settings.ragebot.hitchance.awp_air_amount:get())
            end

            if weapon_index == 40 then
                refs.ssg08_hitchance:override(menu.settings.ragebot.hitchance.ssg08_air_amount:get())
            end

            if weapon_index == 64 then
                refs.revolver_hitchance:override(menu.settings.ragebot.hitchance.revolver_air_amount:get())
            end
        else
            refs.pistols_hitchance:override()
            refs.auto_snipers_hitchance:override()
            refs.awp_hitchance:override()
            refs.ssg08_hitchance:override()
            refs.revolver_hitchance:override()
        end
        
        if not lp.m_bIsScoped or get_player_state(cmd) == "AIR-C" or get_player_state(cmd) == "AIR" then
            if get_player_state(cmd) == "AIR-C" or get_player_state(cmd) == "AIR" then
                if weapon_index == 1 or weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61 then
                    refs.pistols_hitchance:override(menu.settings.ragebot.hitchance.pistols_air_amount:get())
                end
    
                if weapon_index == 38 or weapon_index == 11 then
                    refs.auto_snipers_hitchance:override(menu.settings.ragebot.hitchance.auto_snipers_air_amount:get())
                end
    
                if weapon_index == 9 then
                    refs.awp_hitchance:override(menu.settings.ragebot.hitchance.awp_air_amount:get())
                end
    
                if weapon_index == 40 then
                    refs.ssg08_hitchance:override(menu.settings.ragebot.hitchance.ssg08_air_amount:get())
                end
    
                if weapon_index == 64 then
                    refs.revolver_hitchance:override(menu.settings.ragebot.hitchance.revolver_air_amount:get())
                end
            else
                if weapon_index == 38 or weapon_index == 11 then
                    refs.auto_snipers_hitchance:override(menu.settings.ragebot.hitchance.auto_snipers_no_scope_amount:get())
                end
    
                if weapon_index == 9 then
                    refs.awp_hitchance:override(menu.settings.ragebot.hitchance.awp_no_scope_amount:get())
                end
    
                if weapon_index == 40 then
                    refs.ssg08_hitchance:override(menu.settings.ragebot.hitchance.ssg08_no_scope_amount:get())
                end
            end
        else
            refs.pistols_hitchance:override()
            refs.auto_snipers_hitchance:override()
            refs.awp_hitchance:override()
            refs.ssg08_hitchance:override()
            refs.revolver_hitchance:override()
        end
    else
        refs.pistols_hitchance:override()
        refs.auto_snipers_hitchance:override()
        refs.awp_hitchance:override()
        refs.ssg08_hitchance:override()
        refs.revolver_hitchance:override()
    end
end

-- #endregion

-- #region : Fast ladder

local fast_ladder = function(c)
    if not menu.settings.misc.fast_ladder:get() then return end

    self = entity.get_local_player()

    if self == nil then return end

    if self.m_MoveType == 9 then
        c.view_angles.y = math.floor(c.view_angles.y + 0.5)

        if c.forwardmove > 0 then
            if c.view_angles.x < 45 then
                c.view_angles.x = 89
                c.in_moveright = 1
                c.in_moveleft = 0
                c.in_forward = 0
                c.in_back = 1

                if c.sidemove == 0 then
                    c.view_angles.y = c.view_angles.y + 90
                end

                if c.sidemove < 0 then
                    c.view_angles.y = c.view_angles.y + 150
                end

                if c.sidemove > 0 then
                    c.view_angles.y = c.view_angles.y + 30
                end
            end
        elseif c.forwardmove < 0 then
            c.view_angles.x = 89
            c.in_moveleft = 1
            c.in_moveright = 0
            c.in_forward = 1
            c.in_back = 0

            if c.sidemove == 0 then
                c.view_angles.y = c.view_angles.y + 90
            end

            if c.sidemove > 0 then
                c.view_angles.y = c.view_angles.y + 150
            end

            if c.sidemove < 0 then
                c.view_angles.y = c.view_angles.y + 30
            end
        end
    end
end

-- #endregion

-- #region : Fast ladder

function sin_vec(x, y)
    sin_x = math.sin(math.rad(x))
    cos_x = math.cos(math.rad(x))
    sin_y = math.sin(math.rad(y))
    cos_y = math.cos(math.rad(y))
    return vector(cos_x * cos_y, cos_x * sin_y, -sin_x);
end

local avoid_collisions = function(cmd)
    local lp = entity.get_local_player()
    if lp == nil or not lp:is_alive() then return end

    if menu.settings.misc.avoid_collisions:get() then
        local minimum, value = math.huge, math.huge
        local jump = cmd.in_jump
    
        for z = 1, 180 do
            local line_trace = utils.trace_line(lp.m_vecOrigin, vector(lp.m_vecOrigin.x + sin_vec(0, (render.camera_angles().y + z - 90)).x * 70, lp.m_vecOrigin.y + sin_vec(0, (render.camera_angles().y + z - 90)).y * 70, lp.m_vecOrigin.z + 60), nil, nil, 1)
            if(lp.m_vecOrigin:dist(line_trace.end_pos) < minimum) then
                minimum = lp.m_vecOrigin:dist(line_trace.end_pos)
                value = z
            end
        end
        if minimum < menu.settings.misc.avoid_collisions.distance:get() and jump and not (cmd.in_back or cmd.in_moveleft or cmd.in_moveright) then
            if(value >= 90) then
                cmd.sidemove = lp.m_vecVelocity:length() * math.sin(math.rad(value))
            else
                cmd.sidemove = (lp.m_vecVelocity:length() * math.sin(math.rad(value))) * -1
            end
            cmd.forwardmove = math.abs(lp.m_vecVelocity:length() * math.cos(math.rad(value)))
        end
    end
end

-- #endregion

-- #region : Config system

local config = pui.setup({custom_aa, menu.anti_aim, gear_funcs, menu.settings}, true)
local configsystem = { }
configdata = db.cfg_dbggg1 or { }
configdata.cfg_list = configdata.cfg_list or {{'Default', 'W3siQWlyIjp7IkNUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi01LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi01LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiQWlyLUNyb3VjaGluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJBbHdheXMgT24iLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjMwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi00LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6IkFsd2F5cyBPbiIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6LTIxLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MzAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6LTQuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19LCJDcm91Y2hpbmciOnsiQ1QiOnsiYm9keV95YXciOnRydWUsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiTGVmdCBBbmQgUmlnaHQiLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6My4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fSwiVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjozLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiQ3JvdWNoaW5nIE1vdmluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotMTMuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX0sIlQiOnsiYm9keV95YXciOnRydWUsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiTGVmdCBBbmQgUmlnaHQiLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6LTEzLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiRmFrZSBMYWciOnsiQ1QiOnsiYm9keV95YXciOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJTdGF0aWMiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fSwiVCI6eyJib2R5X3lhdyI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhdyI6IlN0YXRpYyIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjowLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiTW92aW5nIjp7IkNUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi0zLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi0zLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiU2hhcmVkIjp7IkNUIjp7ImJvZHlfeWF3IjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3IjoiU3RhdGljIiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX0sIlQiOnsiYm9keV95YXciOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJTdGF0aWMiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fX0sIlNsb3ctV2Fsa2luZyI6eyJDVCI6eyJib2R5X3lhdyI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhdyI6IlN0YXRpYyIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjowLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3IjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3IjoiU3RhdGljIiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19LCJTdGFuZGluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjotMjEuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0Ijo1LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjUuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19fSx7Im1haW4iOnsiY29uZGl0aW9ucyI6Ik1vdmluZyIsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInRlYW0iOiJUIiwifm1hbnVhbF95YXciOnsic3RhdGljX3lhdyI6ZmFsc2V9fSwib3RoZXIiOnsiYW5pbWF0aW9uX2JyZWFrZXJzIjpmYWxzZSwiYXV0b19sYWdfZXhwbG9pdCI6IkRpc2FibGVkIiwiYXZvaWRfYmFja3N0YWIiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJ+Il0sImZyZWVzdGFuZGluZ19kaXNhYmxlcnMiOlsifiJdLCJzYWZlX2hlYWQiOnRydWUsIn5hdXRvX2xhZ19leHBsb2l0Ijp7InRpY2tzIjoxNS4wfSwifnNhZmVfaGVhZCI6eyJjb25kaXRpb25zIjpbIktuaWZlIiwiVGFzZXIiLCJ+Il0sImVfc3BhbSI6ZmFsc2V9fX0seyJhbmltYXRpb25fYnJlYWtlcnNfYWRkb25zIjpbIk1vdmUgTGVhbiIsIkVhcnRoIFF1YWtlIiwifiJdLCJhbmltYXRpb25fYnJlYWtlcnNfYWRkb25zX21vdmVfbGVhbl9hbW91bnQiOjEwMC4wLCJhbmltYXRpb25fYnJlYWtlcnNfc2VsZWN0IjpbIkluIEFpciBMZWdzIiwiR3JvdW5kIExlZ3MiLCJ+Il0sImFuaW1hdGlvbl9icmVha2Vyc19zZWxlY3RfZ3JvdW5kIjoiQWxsYWgiLCJhbmltYXRpb25fYnJlYWtlcnNfc2VsZWN0X2luX2FpciI6IkFsbGFoIiwiYXNwZWN0X3JhdGlvX3ZhbHVlIjoxMjAuMCwiY3Jvc3NoYWlyX2luZGljYXRvcnNfZmlyc3RfY29sb3IiOiIjOEE4MjlBRkYiLCJjcm9zc2hhaXJfaW5kaWNhdG9yc19nbG93X2NvbG9yIjoiIzQ4NDg0OEZGIiwiY3Jvc3NoYWlyX2luZGljYXRvcnNfc2Vjb25kX2NvbG9yIjoiI0QzRDNEM0ZGIiwiY3MyX3Njb3BlX3ZpZXdtb2RlbCI6ZmFsc2UsImN1c3RvbV9zY29wZV9vdmVybGF5X2NvbG9yIjoiIzk0OTQ5NEM3IiwiY3VzdG9tX3Njb3BlX292ZXJsYXlfZ2FwIjo1LjAsImN1c3RvbV9zY29wZV9vdmVybGF5X2ludmVydGVkIjpmYWxzZSwiY3VzdG9tX3Njb3BlX292ZXJsYXlfbGluZSI6MTQ4LjAsInZpZXdtb2RlbF9mb3YiOjgxLjAsInZpZXdtb2RlbF94IjotMTEyLjAsInZpZXdtb2RlbF95IjotMzgxLjAsInZpZXdtb2RlbF96Ijo2Ny4wLCJ3YXRlcm1hcmtfY29sb3IiOiIjOTE5OUI2RkYiLCJ3YXRlcm1hcmtfcG9zaXRpb24iOiJMZWZ0Iiwid2F0ZXJtYXJrX3N0eWxlIjoiR3JhZGllbnQiLCJ3YXRlcm1hcmtfc3R5bGVfZnJvc3RfdHlwZSI6Ik1vZGVybiJ9LHsibWlzYyI6eyJhaW1sb2dzIjp0cnVlLCJhc3BlY3RfcmF0aW8iOnRydWUsImF2b2lkX2NvbGxpc2lvbnMiOmZhbHNlLCJjbGFudGFnIjpmYWxzZSwiZmFrZV9sYXRlbmN5X3VubG9ja2VyIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImtpbGxzYXkiOmZhbHNlLCJuYWRlX3Rocm93X2ZpeCI6dHJ1ZSwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInBlcmZvbWFuY2VfYm9vc3QiOmZhbHNlLCJzdXBlcl90b3NzIjp0cnVlLCJ1bm11dGVfc2lsZW5jZWRfcGxheWVyIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsIn5haW1sb2dzIjp7ImZpcmVkX2F0X3lvdV9jb2xvciI6IiNDQ0NDQ0M2NCIsImhpdF9jb2xvciI6IiNDQ0NDQ0M2MyIsIm1pc3NfY29sb3IiOiIjQ0NDQ0NDNjQiLCJzZWxlY3QiOlsiQ29uc29sZSIsIkV2ZW50IiwiTm90aWZ5IiwifiJdfSwifmF2b2lkX2NvbGxpc2lvbnMiOnsiZGlzdGFuY2UiOjUxLjB9LCJ+ZmFrZV9sYXRlbmN5X3VubG9ja2VyIjp7InBpbmciOjEzNy4wfSwifmtpbGxzYXkiOnsiZGVsYXkiOjIwLjB9fSwicmFnZWJvdCI6eyJkb3JtYW50X2FpbWJvdCI6ZmFsc2UsImhpdGNoYW5jZSI6ZmFsc2UsInI4X2hlbHBlciI6dHJ1ZSwifmRvcm1hbnRfYWltYm90Ijp7ImFjY3VyYWN5Ijo4NS4wLCJoaXRib3hlcyI6WyJIZWFkIiwiQ2hlc3QiLCJTdG9tYWNoIiwiTGVncyIsIn4iXSwibWluaW11bV9kYW1hZ2UiOjEwLjB9LCJ+aGl0Y2hhbmNlIjp7ImF1dG9fc25pcGVyc19haXJfYW1vdW50IjowLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjAuMCwiYXdwX2Fpcl9hbW91bnQiOjAuMCwiYXdwX25vX3Njb3BlX2Ftb3VudCI6MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjAuMCwicmV2b2x2ZXJfYWlyX2Ftb3VudCI6MC4wLCJzc2cwOF9haXJfYW1vdW50IjowLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6MC4wfX0sInZpc3VhbHMiOnsiY3Jvc3NoYWlyX2luZGljYXRvcnMiOmZhbHNlLCJjdXN0b21fc2NvcGVfb3ZlcmxheSI6dHJ1ZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZ2FtZXNlbnNlX2luZGljYXRvcnMiOmZhbHNlLCJncmVuYWRlX3JhZGl1cyI6dHJ1ZSwiaGl0bWFya2VyX3dvcmxkIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsIndhdGVybWFyayI6dHJ1ZSwifmdhbWVzZW5zZV9pbmRpY2F0b3JzIjp7InNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZXNob3RzIiwiRnJlZXN0YW5kaW5nIiwiRm9yY2UgQmFpbSIsIk1pbi4gZGFtYWdlIG92ZXJyaWRlIiwiSGl0Y2hhbmNlIE92ZXJyaWRlIiwiUGluZyByZWR1Y2UiLCJGYWtlIER1Y2siLCJEb3JtYW50IGFpbSIsIn4iXX0sIn5ncmVuYWRlX3JhZGl1cyI6eyJtb2xvdG92X2NvbG9yIjoiIzg5ODFCN0ZGIiwic2VsZWN0IjpbIk1vbG90b3YiLCJTbW9rZSIsIn4iXSwic21va2VfY29sb3IiOiIjOEE4MUI4RkYifSwifmhpdG1hcmtlcl93b3JsZCI6eyJoaXRtYXJrZXJfY29sb3IiOiIjRkZGRkZGRkYifSwifm1hbnVhbF9hcnJvd3MiOnsiYWNjZW50X2NvbG9yIjoiI0ZGRkZGRjM2IiwibWFudWFsX2NvbG9yIjoiI0ZGRkZGRkZGIiwib2Zmc2V0IjowLjB9fX1d'}}
configdata.menu_list = configdata.menu_list or {'Default'}

configdata.cfg_list[1][2] = "W3siQWlyIjp7IkNUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi01LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi01LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiQWlyLUNyb3VjaGluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJBbHdheXMgT24iLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjMwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi00LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6IkFsd2F5cyBPbiIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6LTIxLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MzAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6LTQuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19LCJDcm91Y2hpbmciOnsiQ1QiOnsiYm9keV95YXciOnRydWUsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiTGVmdCBBbmQgUmlnaHQiLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6My4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fSwiVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjozLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiQ3JvdWNoaW5nIE1vdmluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjotMTMuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX0sIlQiOnsiYm9keV95YXciOnRydWUsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6dHJ1ZSwieWF3IjoiTGVmdCBBbmQgUmlnaHQiLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6LTEzLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiRmFrZSBMYWciOnsiQ1QiOnsiYm9keV95YXciOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJTdGF0aWMiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fSwiVCI6eyJib2R5X3lhdyI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhdyI6IlN0YXRpYyIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjowLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiTW92aW5nIjp7IkNUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi0zLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOi0zLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19fSwiU2hhcmVkIjp7IkNUIjp7ImJvZHlfeWF3IjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3IjoiU3RhdGljIiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX0sIlQiOnsiYm9keV95YXciOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXciOiJTdGF0aWMiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wfSwifmRlZmVuc2l2ZV9hYSI6eyJhbGxvd193aXRoX2hpZGVfc2hvdHMiOmZhbHNlLCJjdXN0b21fZGVmZW5zaXZlX2FhX3BpdGNoIjoiRG93biIsImN1c3RvbV9kZWZlbnNpdmVfYWFfeWF3IjoiU2lkZXdheXMiLCJtb2RlIjoiT24gUGVlayIsInJhbmRvbV9waXRjaF9maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21fcGl0Y2hfc2Vjb25kX3ZhbHVlIjowLjAsInJhbmRvbV95YXdfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19zZWNvbmRfdmFsdWUiOjAuMCwic3Bpbl9zcGVlZCI6MS4wLCJzd2l0Y2hfeWF3X2ZpcnN0X3ZhbHVlIjowLjAsInN3aXRjaF95YXdfc2Vjb25kX3ZhbHVlIjowLjB9LCJ+eWF3Ijp7InN3YXBfZGVsYXkiOmZhbHNlLCJzd2FwX2RlbGF5X3RpY2tzIjo4LjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjAuMCwieWF3X3N0YXRpY19vZmZzZXQiOjAuMH0sIn55YXdfbW9kaWZpZXIiOnsieWF3X21vZGlmaWVyX29mZnNldCI6MC4wLCJ5YXdfbW9kaWZpZXJfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjB9fX0sIlNsb3ctV2Fsa2luZyI6eyJDVCI6eyJib2R5X3lhdyI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhdyI6IlN0YXRpYyIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjowLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IjowLjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3IjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3IjoiU3RhdGljIiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwibGVmdF9saW1pdCI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjAuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19LCJTdGFuZGluZyI6eyJDVCI6eyJib2R5X3lhdyI6dHJ1ZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwic3RhdGVfZW5hYmxlIjp0cnVlLCJ5YXciOiJMZWZ0IEFuZCBSaWdodCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+ZGVmZW5zaXZlX2FhIjp7ImFsbG93X3dpdGhfaGlkZV9zaG90cyI6ZmFsc2UsImN1c3RvbV9kZWZlbnNpdmVfYWFfcGl0Y2giOiJEb3duIiwiY3VzdG9tX2RlZmVuc2l2ZV9hYV95YXciOiJTaWRld2F5cyIsIm1vZGUiOiJPbiBQZWVrIiwicmFuZG9tX3BpdGNoX2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV9waXRjaF9zZWNvbmRfdmFsdWUiOjAuMCwicmFuZG9tX3lhd19maXJzdF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X3NlY29uZF92YWx1ZSI6MC4wLCJzcGluX3NwZWVkIjoxLjAsInN3aXRjaF95YXdfZmlyc3RfdmFsdWUiOjAuMCwic3dpdGNoX3lhd19zZWNvbmRfdmFsdWUiOjAuMH0sIn55YXciOnsic3dhcF9kZWxheSI6ZmFsc2UsInN3YXBfZGVsYXlfdGlja3MiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjotMjEuMCwieWF3X29mZnNldF92YXJpYWJpbGl0eSI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXdfc3RhdGljX29mZnNldCI6MC4wfSwifnlhd19tb2RpZmllciI6eyJ5YXdfbW9kaWZpZXJfb2Zmc2V0Ijo1LjAsInlhd19tb2RpZmllcl9vZmZzZXRfdmFyaWFiaWxpdHkiOjAuMH19LCJUIjp7ImJvZHlfeWF3Ijp0cnVlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJzdGF0ZV9lbmFibGUiOnRydWUsInlhdyI6IkxlZnQgQW5kIFJpZ2h0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn5kZWZlbnNpdmVfYWEiOnsiYWxsb3dfd2l0aF9oaWRlX3Nob3RzIjpmYWxzZSwiY3VzdG9tX2RlZmVuc2l2ZV9hYV9waXRjaCI6IkRvd24iLCJjdXN0b21fZGVmZW5zaXZlX2FhX3lhdyI6IlNpZGV3YXlzIiwibW9kZSI6Ik9uIFBlZWsiLCJyYW5kb21fcGl0Y2hfZmlyc3RfdmFsdWUiOjAuMCwicmFuZG9tX3BpdGNoX3NlY29uZF92YWx1ZSI6MC4wLCJyYW5kb21feWF3X2ZpcnN0X3ZhbHVlIjowLjAsInJhbmRvbV95YXdfc2Vjb25kX3ZhbHVlIjowLjAsInNwaW5fc3BlZWQiOjEuMCwic3dpdGNoX3lhd19maXJzdF92YWx1ZSI6MC4wLCJzd2l0Y2hfeWF3X3NlY29uZF92YWx1ZSI6MC4wfSwifnlhdyI6eyJzd2FwX2RlbGF5IjpmYWxzZSwic3dhcF9kZWxheV90aWNrcyI6OC4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfb2Zmc2V0X3ZhcmlhYmlsaXR5IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQwLjAsInlhd19zdGF0aWNfb2Zmc2V0IjowLjB9LCJ+eWF3X21vZGlmaWVyIjp7Inlhd19tb2RpZmllcl9vZmZzZXQiOjUuMCwieWF3X21vZGlmaWVyX29mZnNldF92YXJpYWJpbGl0eSI6MC4wfX19fSx7Im1haW4iOnsiY29uZGl0aW9ucyI6Ik1vdmluZyIsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInRlYW0iOiJUIiwifm1hbnVhbF95YXciOnsic3RhdGljX3lhdyI6ZmFsc2V9fSwib3RoZXIiOnsiYW5pbWF0aW9uX2JyZWFrZXJzIjpmYWxzZSwiYXV0b19sYWdfZXhwbG9pdCI6IkRpc2FibGVkIiwiYXZvaWRfYmFja3N0YWIiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJ+Il0sImZyZWVzdGFuZGluZ19kaXNhYmxlcnMiOlsifiJdLCJzYWZlX2hlYWQiOnRydWUsIn5hdXRvX2xhZ19leHBsb2l0Ijp7InRpY2tzIjoxNS4wfSwifnNhZmVfaGVhZCI6eyJjb25kaXRpb25zIjpbIktuaWZlIiwiVGFzZXIiLCJ+Il0sImVfc3BhbSI6ZmFsc2V9fX0seyJhbmltYXRpb25fYnJlYWtlcnNfYWRkb25zIjpbIk1vdmUgTGVhbiIsIkVhcnRoIFF1YWtlIiwifiJdLCJhbmltYXRpb25fYnJlYWtlcnNfYWRkb25zX21vdmVfbGVhbl9hbW91bnQiOjEwMC4wLCJhbmltYXRpb25fYnJlYWtlcnNfc2VsZWN0IjpbIkluIEFpciBMZWdzIiwiR3JvdW5kIExlZ3MiLCJ+Il0sImFuaW1hdGlvbl9icmVha2Vyc19zZWxlY3RfZ3JvdW5kIjoiQWxsYWgiLCJhbmltYXRpb25fYnJlYWtlcnNfc2VsZWN0X2luX2FpciI6IkFsbGFoIiwiYXNwZWN0X3JhdGlvX3ZhbHVlIjoxMjAuMCwiY3Jvc3NoYWlyX2luZGljYXRvcnNfZmlyc3RfY29sb3IiOiIjOEE4MjlBRkYiLCJjcm9zc2hhaXJfaW5kaWNhdG9yc19nbG93X2NvbG9yIjoiIzQ4NDg0OEZGIiwiY3Jvc3NoYWlyX2luZGljYXRvcnNfc2Vjb25kX2NvbG9yIjoiI0QzRDNEM0ZGIiwiY3MyX3Njb3BlX3ZpZXdtb2RlbCI6ZmFsc2UsImN1c3RvbV9zY29wZV9vdmVybGF5X2NvbG9yIjoiIzk0OTQ5NEM3IiwiY3VzdG9tX3Njb3BlX292ZXJsYXlfZ2FwIjo1LjAsImN1c3RvbV9zY29wZV9vdmVybGF5X2ludmVydGVkIjpmYWxzZSwiY3VzdG9tX3Njb3BlX292ZXJsYXlfbGluZSI6MTQ4LjAsInZpZXdtb2RlbF9mb3YiOjgxLjAsInZpZXdtb2RlbF94IjotMTEyLjAsInZpZXdtb2RlbF95IjotMzgxLjAsInZpZXdtb2RlbF96Ijo2Ny4wLCJ3YXRlcm1hcmtfY29sb3IiOiIjOTE5OUI2RkYiLCJ3YXRlcm1hcmtfcG9zaXRpb24iOiJMZWZ0Iiwid2F0ZXJtYXJrX3N0eWxlIjoiR3JhZGllbnQiLCJ3YXRlcm1hcmtfc3R5bGVfZnJvc3RfdHlwZSI6Ik1vZGVybiJ9LHsibWlzYyI6eyJhaW1sb2dzIjp0cnVlLCJhc3BlY3RfcmF0aW8iOnRydWUsImF2b2lkX2NvbGxpc2lvbnMiOmZhbHNlLCJjbGFudGFnIjpmYWxzZSwiZmFrZV9sYXRlbmN5X3VubG9ja2VyIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImtpbGxzYXkiOmZhbHNlLCJuYWRlX3Rocm93X2ZpeCI6dHJ1ZSwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInBlcmZvbWFuY2VfYm9vc3QiOmZhbHNlLCJzdXBlcl90b3NzIjp0cnVlLCJ1bm11dGVfc2lsZW5jZWRfcGxheWVyIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsIn5haW1sb2dzIjp7ImZpcmVkX2F0X3lvdV9jb2xvciI6IiNDQ0NDQ0M2NCIsImhpdF9jb2xvciI6IiNDQ0NDQ0M2MyIsIm1pc3NfY29sb3IiOiIjQ0NDQ0NDNjQiLCJzZWxlY3QiOlsiQ29uc29sZSIsIkV2ZW50IiwiTm90aWZ5IiwifiJdfSwifmF2b2lkX2NvbGxpc2lvbnMiOnsiZGlzdGFuY2UiOjUxLjB9LCJ+ZmFrZV9sYXRlbmN5X3VubG9ja2VyIjp7InBpbmciOjEzNy4wfSwifmtpbGxzYXkiOnsiZGVsYXkiOjIwLjB9fSwicmFnZWJvdCI6eyJkb3JtYW50X2FpbWJvdCI6ZmFsc2UsImhpdGNoYW5jZSI6ZmFsc2UsInI4X2hlbHBlciI6dHJ1ZSwifmRvcm1hbnRfYWltYm90Ijp7ImFjY3VyYWN5Ijo4NS4wLCJoaXRib3hlcyI6WyJIZWFkIiwiQ2hlc3QiLCJTdG9tYWNoIiwiTGVncyIsIn4iXSwibWluaW11bV9kYW1hZ2UiOjEwLjB9LCJ+aGl0Y2hhbmNlIjp7ImF1dG9fc25pcGVyc19haXJfYW1vdW50IjowLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjAuMCwiYXdwX2Fpcl9hbW91bnQiOjAuMCwiYXdwX25vX3Njb3BlX2Ftb3VudCI6MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjAuMCwicmV2b2x2ZXJfYWlyX2Ftb3VudCI6MC4wLCJzc2cwOF9haXJfYW1vdW50IjowLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6MC4wfX0sInZpc3VhbHMiOnsiY3Jvc3NoYWlyX2luZGljYXRvcnMiOmZhbHNlLCJjdXN0b21fc2NvcGVfb3ZlcmxheSI6dHJ1ZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZ2FtZXNlbnNlX2luZGljYXRvcnMiOmZhbHNlLCJncmVuYWRlX3JhZGl1cyI6dHJ1ZSwiaGl0bWFya2VyX3dvcmxkIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsIndhdGVybWFyayI6dHJ1ZSwifmdhbWVzZW5zZV9pbmRpY2F0b3JzIjp7InNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZXNob3RzIiwiRnJlZXN0YW5kaW5nIiwiRm9yY2UgQmFpbSIsIk1pbi4gZGFtYWdlIG92ZXJyaWRlIiwiSGl0Y2hhbmNlIE92ZXJyaWRlIiwiUGluZyByZWR1Y2UiLCJGYWtlIER1Y2siLCJEb3JtYW50IGFpbSIsIn4iXX0sIn5ncmVuYWRlX3JhZGl1cyI6eyJtb2xvdG92X2NvbG9yIjoiIzg5ODFCN0ZGIiwic2VsZWN0IjpbIk1vbG90b3YiLCJTbW9rZSIsIn4iXSwic21va2VfY29sb3IiOiIjOEE4MUI4RkYifSwifmhpdG1hcmtlcl93b3JsZCI6eyJoaXRtYXJrZXJfY29sb3IiOiIjRkZGRkZGRkYifSwifm1hbnVhbF9hcnJvd3MiOnsiYWNjZW50X2NvbG9yIjoiI0ZGRkZGRjM2IiwibWFudWFsX2NvbG9yIjoiI0ZGRkZGRkZGIiwib2Zmc2V0IjowLjB9fX1"
configsystem.save_config = function(id)
    if id == 1 then return end
    local raw = config:save()
    configdata.cfg_list[id][2] = base64.encode(json.stringify(raw))
    cvar.play:call("ambient\\tones\\elev1")
    db.cfg_dbggg1 = configdata
end

configsystem.update_values = function(id)
    local name = configdata.cfg_list[id][1]
    local new_name = "Loaded - " .. "\a{Link Active}" .. name
    for k, v in ipairs(configdata.cfg_list) do
        configdata.menu_list[k] = v[1]
    end
    configdata.menu_list[id] = new_name
end

configsystem.create_config = function(name)
    if type(name) ~= 'string' then return end
    if name == nil or name == '' or name == ' ' then return end
    for i=#configdata.menu_list, 1, -1 do if configdata.menu_list[i] == name then common.add_notify('\vFrost', 'Config with this name has already been created') return end end
    if #configdata.cfg_list > 6 then common.add_notify('\vFrost', 'Too much configs') return end
    local completed = {name, ''}
    table.insert(configdata.cfg_list, completed)
    table.insert(configdata.menu_list, name)
    db.cfg_dbggg1 = configdata
end

configsystem.remove_config = function(id)
    if id == 1 then return end
    local item = configdata.cfg_list[id][1]
    for i=#configdata.cfg_list, 1, -1 do if configdata.cfg_list[i][1] == item then table.remove(configdata.cfg_list, i) table.remove(configdata.menu_list, i) end end
    db.cfg_dbggg1 = configdata
end

configsystem.load_config = function(id)
    if configdata.cfg_list[id][2] == nil or configdata.cfg_list[id][2] == '' then print("Error[data_base[".. id .."]]") return end
    if id > #configdata.cfg_list then print("Error[data_base[".. id .."]]") return end
        config:load(json.parse(base64.decode(configdata.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
end
configs = {
    cfg_selector = tabs.global.config:list('', configdata.menu_list),
    name = tabs.global.config:input("\f<bars>" .. "  Config name"),
    
    create = tabs.global.config:button("          \aA3A6DBFF\f<wand-magic-sparkles>\r Create         ", function()
        configsystem.create_config(configs.name:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true):tooltip("\aA3A6DBFFCreate\aDEFAULT config"),
    
    remove  = tabs.global.config:button("          \aA86464FF\f<trash-can-xmark>\r Remove         ", function()
        configsystem.remove_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true):tooltip("\aA86464FFRemove\aDEFAULT config"),
    
    save = tabs.global.config:button("  \a90E190FF\f<download>\r Save  ", function()
        configsystem.save_config(configs.cfg_selector:get())
    end, true):tooltip("\a90E190FFSave\aDEFAULT config"),

    import = tabs.global.config:button(" \vImport ", function()
        config:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true),

    export = tabs.global.config:button(" \vExport ", function()
        clipboard.set(base64.encode(json.stringify(config:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true),

    load = tabs.global.config:button("  \aA3A6DBFF\f<upload>\r Load  ", function()
        configsystem.update_values(configs.cfg_selector:get())
        configsystem.load_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configdata.menu_list)
    end, true):tooltip("\aA3A6DBFFLoad\aDEFAULT config"),
}

-- #endregion

-- #region : Callbacks

events.render:set(function()
    local gradient_animation_side_bar = gradient.text_animate("frost", 1, { ui.get_style("Link Active"), color(50) })
    pui.sidebar(gradient_animation_side_bar:get_animated_text(), "snowflake")
    gradient_animation_side_bar:animate()

    gamesense_indicators()
    hitmarker_world()
    set_visible_aa()
    damage_indicator()
    custom_scope()
    viewmodel_changer()
    aspect_ratio()
    fake_latency_unlocker()
    manual_arrows()
    grenade_radius.render()
    notifications()
    nade_throw_fix()

    if menu.settings.visuals.watermark:get() or menu.settings.visuals.crosshair_indicators:get() then
        if menu.settings.visuals.watermark:get() then
            watermark()
        end

        if menu.settings.visuals.crosshair_indicators:get() then
            indicators()
        end
    else
        render.text(4, vector(x / 2, y - 10), color(255, 255, 255, 255), "c", "frost.lua")
    end
end)

events.round_start:set(function()
    perfomance_boost()
end)

events.aim_ack:set(function(e) 
    shot_statistic(e)
    ragebot_logs(e)
    hitrate_stuff(e)
    on_fire(e)
end)

events.player_death:set(function(enemy)
    killsay(enemy)
end)    

events.createmove:set(function(cmd)
    anti_aim(cmd)
    nofalldamage(cmd)
    fast_ladder(cmd)
    avoid_collisions(cmd)
    supertoss(cmd)
    dormant_aimbot(cmd)
    hitchance(cmd)
end)

events.grenade_override_view:set(function(e)
    local lp = entity.get_local_player()
    if lp == nil then return end

    local weapon = lp:get_player_weapon()
    if weapon == nil then return end

    local weapon_info = weapon:get_weapon_info()
    if weapon_info == nil then return end

    e.angles = get_throw_toss(
        e.angles,
        weapon_info.throw_velocity,
        weapon.m_flThrowStrength,
        e.velocity
    )
end)

events.post_update_clientside_animation:set(function() 
    anim_breakers()
end)

events.shutdown:set(function() 
    cvar.r_aspectratio:int(0, true)
    cvar.viewmodel_fov:int(get_original(cvar.viewmodel_fov), true)
    cvar.viewmodel_offset_x:float(get_original(cvar.viewmodel_offset_x), true)
    cvar.viewmodel_offset_y:float(get_original(cvar.viewmodel_offset_y), true)
    cvar.viewmodel_offset_z:float(get_original(cvar.viewmodel_offset_z), true)

    common.set_clan_tag("\0")
end)

-- #endregion