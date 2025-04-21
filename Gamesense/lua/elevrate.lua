--[[ 
    E L E V R A T E . C O D E S
]]

ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;
    
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
    } CAnimationLayer;

    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char         pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_t        vecOrigin; // 0xB0
        Vector_t        vecLastOrigin;// 0xBC
        Vector_t        vecVelocity; // 0xC8
        Vector_t        vecVelocityNormalized; // 0xD4
        Vector_t        vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char    pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char    pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char    pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
]]

local function calcfloor(value)
    return (math.floor(value * 100) / 100)
end

local function hitmarker_animation(bool, alpha, max_alpha, speed)
    
    local get_frametime = 144 / ( 1 / globals.frametime )

    if bool then

        if alpha ~= max_alpha then

            alpha = alpha + (max_alpha + 5 - alpha) * speed * get_frametime

        else

            alpha = max_alpha

        end

    else

        if (alpha > 0) then

            alpha = alpha - alpha * speed * get_frametime

        else

            alpha = 0

        end

    end

    return calcfloor(alpha)

end

local function log_color(color)

    local text = ''

    text = text .. ('\a%02x%02x%02x'):format(color.r, color.g, color.b)

    return text

end

local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")
local vmt_hook = require("neverlose/vmt_hook")
local drag_system = require("neverlose/drag_system")

local menu = {}
local antiaim = {}
local antibruteforce = {}
local adress = {}
local visuals = {}
local misc = {}
local c4_info = {}
local ragebot = {}
local hitlogs = {}
local hitmarker1 = {}

local function render_gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
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

adress.client_dll = "client.dll"
adress.bind_argument = function(fn, arg) 
    return function(...) 
        return fn(arg, ...) 
    end 
end
adress.entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface(adress.client_dll, "VClientEntityList003"))
adress.get_entity_address = adress.bind_argument(ffi.cast("get_client_entity_t", adress.entity_list_003[0][3]), adress.entity_list_003)

local colors = {
    main = "\a2A80FEFF", --  7AB0FFFF
    default = "\aDEFAULT",
    green = "\aA0FF7AFF",
    disabled = "\a404750FF",
    yellow = "\aFFED3AFF"
}

local refs = {

    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),

    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),

    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),

    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inventer = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),

    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),

    slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),

    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    bodyaim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    damage = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage"),
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),

    airstrafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),

    fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    fakelag_v = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")   


}

local vars = {

    lua = {
        name = "Elevrate",
        version = "1.0",
        last_update = "09.08.2023",
        build = "Secret"
    },

    cheat = {
        user = common.get_username()
    },
}

misc.watermark_size = function()

    local player = entity.get_local_player()
    local ping = globals.is_connected and math.floor(utils.net_channel().latency[1] * 1000) or 0
    local asd = string.format(ping)
    local watermark_size = render.measure_text(1, nil, "     Elevrate.Codes ∙ "..vars.lua.build.. " ∙ " ..vars.cheat.user.."  ")

    return watermark_size
end

local func = {
    disabled = colors.disabled .. ui.get_icon("lock-keyhole"),
    secret = colors.main .. ui.get_icon("lock-keyhole-open").. colors.default .."   Available from "..colors.main.."Elevate Secret",
    nightly = colors.main .. ui.get_icon("lock-keyhole-open").. colors.default .."   Available from "..colors.main.."Elevate Nightly"
}

local icons = {

    main = ui.get_icon("feather-pointed"),
    home = ui.get_icon("folder-minus"),
    antihit = ui.get_icon("shield"),

    share = ui.get_icon("file-circle-plus"),
    import = ui.get_icon("file-circle-check"),
    default = ui.get_icon("floppy-disk"),

    neverlose = ui.get_icon("toggle-on"),
    discord = ui.get_icon("users"),
    telegram = ui.get_icon("telegram"),
    youtube = ui.get_icon("youtube"),

    preset_load = ui.get_icon("file-circle-plus"),
    preset_save = ui.get_icon("file-circle-check"),
    preset_import = ui.get_icon("file-import"),
    preset_export = ui.get_icon("file-export"),  

    antihit_main = ui.get_icon("shield"),
    anithit_constructor = ui.get_icon("user-shield"),
    anithit_presets = ui.get_icon("pen-to-square"),
    antihit_antibrute = ui.get_icon("rotate-right"),

    other_ragebot = ui.get_icon("swords"),
    other_visuals = ui.get_icon("sparkles"),
    other_misc = ui.get_icon("gear"),

    -- НЕ ЗАБУДЬ lock-keyhole ICON

}

ui.sidebar( render_gradient_text( 42, 128, 254, 255, 255,255,255,255, "Elevrate [ Secret ]"), colors.main .. icons.main)

local tab = {
    home = {
        main = ui.create(" Home", "Main"),
        config = ui.create(" Home", "Config", 2),
        also = ui.create(" Home", "Verify", 2)
    },

    antihit = {
        main = ui.create(colors.main .. icons.antihit, colors.main .. icons.antihit_main .. colors.default .. " Main"),
        constructor = ui.create(colors.main .. icons.antihit, colors.main .. icons.anithit_constructor .. colors.default .. " Builder"),
        preset_manager = ui.create(colors.main .. icons.antihit, colors.main .. icons.anithit_presets .. colors.default .. " Preset Manager"),
        antibruteforce = ui.create(colors.main .. icons.antihit, colors.main .. icons.antihit_antibrute .. colors.default .. " Anti-Bruteforce")
    },

    other = {
        ragebot = ui.create("Other", colors.main .. ui.get_icon("bow-arrow") .. colors.default .."  Ragebot"),
        visuals = ui.create("Other", colors.main .. ui.get_icon("sparkles") .. colors.default .."  Indication"),
        misc = ui.create("Other", colors.main .. ui.get_icon("dice") .. colors.default .."  Misc"),
        helpers = ui.create("Other", colors.main .. ui.get_icon("user-gear") .. colors.default .."  Helpers"),
    }
}


menu.picture = tab.home.also:label(" "..colors.main.."How to verify in our discord"..colors.default.."\n 1. Join our discord\n 2. Open channel #tickets\n 3. Create ticket \n 4. Send a screenshot with the purchase")
menu.welcome = tab.home.main:label("Glad to see you, "..colors.main..vars.cheat.user..colors.default.."\nBuild: "..colors.main..vars.lua.build..colors.default.."\nVersion: "..colors.main..vars.lua.version..colors.default.."\nLast Update: "..colors.main..vars.lua.last_update )
menu.neverlose_config = tab.home.main:button("                "..colors.main..icons.neverlose..colors.default.." Author Neverlose Config".."             ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks1")  end, true)
menu.discord = tab.home.main:button(colors.main..icons.discord..colors.default.."Best Config Lua Leaks Here", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")  end, true)
menu.youtube = tab.home.main:button(colors.main..icons.youtube..colors.default.." Youtube ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")  end, true)

menu.nade_throw_fix = tab.other.ragebot:switch("Nade Throw Fix")

menu.auto_teleport = tab.other.ragebot:switch(colors.main .."Auto Teleport"):tooltip(colors.yellow .. ui.get_icon("circle-exclamation").. colors.default .."   This feature is under development")
menu.auto_teleport_tab = menu.auto_teleport:create()
menu.auto_teleport_delay = menu.auto_teleport_tab:slider("Delay", 0, 20, 0, 1, " Tick")
menu.auto_teleport_force_recharge = menu.auto_teleport_tab:switch("Force Recharge")

menu.round_start_notify = tab.other.helpers:switch("Round Start Notify")

menu.super_toss = tab.other.helpers:switch(colors.main .."Accurate Nade Throw"):tooltip(colors.yellow .. ui.get_icon("circle-exclamation").. colors.default .."   If you use grenade helper, turn off this function")
menu.jump_scout = tab.other.helpers:switch("Jump Scout")

menu.local_player_angles = tab.other.helpers:switch("Player Angles")
menu.local_player_angles_tab = menu.local_player_angles:create()
menu.local_player_angles_fake = menu.local_player_angles_tab:color_picker("Fake")
menu.local_player_angles_real = menu.local_player_angles_tab:color_picker("Real")

menu.no_scope_mode = tab.other.ragebot:switch("No Scope Mode")
menu.no_scope_mode_tab = menu.no_scope_mode:create()
menu.no_scope_mode_scout = menu.no_scope_mode_tab:slider("Scout Hit Chance", 0, 100, 0)
menu.no_scope_mode_awp = menu.no_scope_mode_tab:slider("AWP Hit Chance", 0, 100, 0)
menu.no_scope_mode_auto = menu.no_scope_mode_tab:slider("Auto Hit Chance", 0, 100, 0)

menu.air_mode = tab.other.ragebot:switch("In-Air Mode")
menu.air_mode_tab = menu.air_mode:create()
menu.air_mode_scout = menu.air_mode_tab:slider("Scout Hit Chance", 0, 100, 0)
menu.air_mode_awp = menu.air_mode_tab:slider("AWP Hit Chance", 0, 100, 0)
menu.air_mode_auto = menu.air_mode_tab:slider("Auto Hit Chance", 0, 100, 0)
menu.air_mode_r8 = menu.air_mode_tab:slider("R8 Hit Chance", 0, 100, 0)
menu.air_mode_deagle = menu.air_mode_tab:slider("Deagle Hit Chance", 0, 100, 0)

menu.debug_panel = tab.other.visuals:switch("Watermark", true)
menu.debug_panel_tab = menu.debug_panel:create()
menu.debug_panel_glow_color = menu.debug_panel_tab:color_picker("Glow Color")
menu.debug_panel_x = menu.debug_panel_tab:slider("X", 1, render.screen_size().x, render.screen_size().x - misc.watermark_size().x)
menu.debug_panel_y = menu.debug_panel_tab:slider("Y", 1, render.screen_size().y, render.screen_size().y - render.screen_size().y)

menu.velocity_indication = tab.other.visuals:switch("Velocity Indication")
menu.velocity_indication_tab = menu.velocity_indication:create()
menu.velocity_indication_color = menu.velocity_indication_tab:color_picker("Color")
menu.velocity_x = menu.velocity_indication_tab:slider("X", 1, render.screen_size().x, render.screen_size().x / 2 - (render.screen_size().x / 15) / 2)
menu.velocity_y = menu.velocity_indication_tab:slider("Y", 1, render.screen_size().y, render.screen_size().y / 3.2)

menu.crosshair_indication = tab.other.visuals:switch("Crosshair Indication")
menu.crosshair_indication_tab = menu.crosshair_indication:create()
menu.crosshair_indication_main_color = menu.crosshair_indication_tab:color_picker("Main Color")
menu.crosshair_indication_addative_color = menu.crosshair_indication_tab:color_picker("Addative Color")

menu.indication500 = tab.other.visuals:switch(colors.green .. "GameSense" .. colors.default .. " Indication")

menu.kibit_min_damage = tab.other.visuals:switch("Damage Indication")
menu.kibit_min_damage_tab = menu.kibit_min_damage:create()
menu.kibit_min_damage_color = menu.kibit_min_damage_tab:color_picker("Color") 

menu.custom_scope = tab.other.visuals:switch("Custom Scope Overlay")
menu.custom_scope_tab = menu.custom_scope:create()
menu.custom_scope_color = menu.custom_scope_tab:color_picker("Color")
menu.custom_scope_gap = menu.custom_scope_tab:slider("Gap", 0, 500, 0)
menu.custom_scope_size = menu.custom_scope_tab:slider("Size", 0, 500, 0)

menu.hitmarker = tab.other.visuals:switch("Custom Hit Marker")
menu.hitmarker_tab = menu.hitmarker:create()
menu.hitmarker_font = menu.hitmarker_tab:slider("Font", 1, 4, 0)
menu.hitmarker_type = menu.hitmarker_tab:combo("Hit Marker Type", {"Text", "Icon"})
menu.hitmarker_text = menu.hitmarker_tab:input("Marker")
menu.hitmarker_color = menu.hitmarker_tab:color_picker("Color")

menu.greande_radius = tab.other.visuals:switch("Nade Radius")
menu.greande_radius_tab = menu.greande_radius:create()
menu.enemy_molotov_color = menu.greande_radius_tab:color_picker("Molotov Color")
menu.smoke_color = menu.greande_radius_tab:color_picker("Smoke Color")


menu.hitlable = menu.hitmarker_tab:label(colors.main.."Example:"..colors.default.."\nFont: "..colors.main.."1"..colors.default.."\nType: "..colors.main.."Icon"..colors.default.."\nMarker: "..colors.main.."heart"..colors.default.."\nIcons: "..colors.main.."fontawesome.com/icons")


menu.logging = tab.other.misc:switch("Ragebot Logging")
menu.logging_tab = menu.logging:create()
menu.logging_types = menu.logging_tab:selectable("", {"Screen", "Console"})
menu.logging_color = menu.logging_tab:color_picker("Shot Color")
menu.logging_color_miss = menu.logging_tab:color_picker("Miss Color")
menu.logging_position = menu.logging_tab:slider("Position", 0, 20, 10)

menu.auto_mute = tab.other.misc:switch("Auto Mute & Unmute")
menu.auto_mute_tab = menu.auto_mute:create()
menu.auto_mute_type =  menu.auto_mute_tab:combo("Type", "Mute", "Unmute")

menu.aspect_ratio = tab.other.misc:switch("Aspect Ratio", false)
menu.aspect_ratio_tab = menu.aspect_ratio:create()
menu.aspect_ratio_value = menu.aspect_ratio_tab:slider("Value", 0, 30, 0, 0.1)

menu.custom_viewmodel = tab.other.misc:switch("Custom Viewmodel", false)
menu.custom_viewmodel_tab = menu.custom_viewmodel:create()
menu.custom_viewmodel_fov = menu.custom_viewmodel_tab:slider("Fov", 0, 100, 68)
menu.custom_viewmodel_x = menu.custom_viewmodel_tab:slider("X", -10, 10, 1)
menu.custom_viewmodel_y = menu.custom_viewmodel_tab:slider("Y", -10, 10, 1)
menu.custom_viewmodel_z = menu.custom_viewmodel_tab:slider("Z", -10, 10, -1)

menu.trashtalk = tab.other.misc:switch("Trash Talk")
menu.trashtalk_tab = menu.trashtalk:create()
menu.trashtalk_states = menu.trashtalk_tab:selectable("", {"On Kill", "On Death"})

menu.clantag = tab.other.misc:switch("Clan Tag")

menu.config_list = tab.antihit.preset_manager:list("", {"Slot - 1", "Slot - 2", "Slot - 3"})

menu.condition = tab.antihit.constructor:combo("", {"Standing", "Running", "Slow Walk", "Duck", "Air", "Air & Duck"})

menu.yaw_base = tab.antihit.main:combo("Player Yaw Base", {"Local View", "At Target"})
menu.freestanding = tab.antihit.main:switch("Freestanding")
menu.freestanding_tab = menu.freestanding:create()
menu.freestanding_dym = menu.freestanding_tab:switch("Disable Yaw Modifiers")
menu.freestanding_bf = menu.freestanding_tab:switch("Body Freestanding")

menu.antiaim_tweaks = tab.antihit.main:selectable("Utility & Exploits", {"Avoid Backstab", "Force Break LC In-Air", "Fast Ladder Move"})

menu.desync_swither = tab.antihit.main:switch("Desync Switcher")

menu.animation_breakers = tab.antihit.main:switch(colors.main .. "Animation Correction")
menu.animation_breakerstab = menu.animation_breakers:create()
menu.air_legs = menu.animation_breakerstab:combo("Legs In-Air", "Default", "Static", "Walk")
menu.ground_legs = menu.animation_breakerstab:combo("Legs On Ground", "Default", "Static", "Walk")
menu.move_lean = menu.animation_breakerstab:switch("Move Lean")
menu.move_lean_effect = menu.animation_breakerstab:slider("Move Lean Effect", 0, 10, 0)
menu.pitch_null = menu.animation_breakerstab:switch("Pitch 0 On Land")
menu.sliding_slow_walk = menu.animation_breakerstab:switch("Sliding Slow Walk")

menu.antibruteforce = tab.antihit.antibruteforce:switch("Enable Anti-Bruteforce")
menu.antibruteforce_modifiers = tab.antihit.antibruteforce:selectable("Modifiers", {"Desync", "Yaw"})


antiaim.state = {
    stand = 0,
    move = 1,
    slowwalk = 2,
    duck = 3,
    air = 4,
    air_duck = 5
}
antiaim.player_state = 0
antiaim.game_state = 0
antiaim.menu_state = 0
for i = 0, 5 do

    antiaim[i] = {}

    antiaim[i].pitch = tab.antihit.constructor:combo("Pitch", {"Disabled", "Down", "Fake Down", "Fake Up"})
    antiaim[i].swap_delay = tab.antihit.constructor:switch("Side Swap Delay")
    antiaim[i].swap_delay_tab = antiaim[i].swap_delay:create()
    antiaim[i].swap_delay_ticks = antiaim[i].swap_delay_tab:slider("Delay", 1, 20, 0, 1, " Tick")
    antiaim[i].player_side = tab.antihit.constructor:combo("Side", {"Left", "Right"})

    antiaim[i].yaw_left = tab.antihit.constructor:combo("Yaw", {"Disabled", "Static", "Backward"})
    antiaim[i].yaw_left_tab = antiaim[i].yaw_left:create()
    antiaim[i].yaw_offset_left = antiaim[i].yaw_left_tab:slider("Yaw Offset", -180, 180, 0, 1, "°")
    antiaim[i].yaw_modifier_left = antiaim[i].yaw_left_tab:combo("Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
    antiaim[i].yaw_modifier_left_offset = antiaim[i].yaw_left_tab:slider("Modifier Offset", -180, 180, 0, 1, "°")
    antiaim[i].body_yaw_left = tab.antihit.constructor:switch("Body Yaw")
    antiaim[i].body_yaw_left_tab = antiaim[i].body_yaw_left:create()
    antiaim[i].fake_limit_left = antiaim[i].body_yaw_left_tab:slider("Fake Limit", 0, 60, 0, 1, "°")
    antiaim[i].options_left = antiaim[i].body_yaw_left_tab:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter"})
    antiaim[i].body_yaw_freestanding_left = antiaim[i].body_yaw_left_tab:combo("Freestanding", {"Disabled", "Peek Fake", "Peek Real"})


    antiaim[i].yaw_right = tab.antihit.constructor:combo("Yaw", {"Disabled", "Static", "Backward"})
    antiaim[i].yaw_right_tab = antiaim[i].yaw_right:create()
    antiaim[i].yaw_offset_right = antiaim[i].yaw_right_tab:slider("Yaw Offset", -180, 180, 0, 1, "°")
    antiaim[i].yaw_modifier_right = antiaim[i].yaw_right_tab:combo("Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
    antiaim[i].yaw_modifier_right_offset = antiaim[i].yaw_right_tab:slider("Modifier Offset", -180, 180, 0, 1, "°")
    antiaim[i].body_yaw_right = tab.antihit.constructor:switch("Body Yaw")
    antiaim[i].body_yaw_right_tab = antiaim[i].body_yaw_right:create()
    antiaim[i].fake_limit_right = antiaim[i].body_yaw_right_tab:slider("Fake Limit", 0, 60, 0, 1, "°")
    antiaim[i].options_right = antiaim[i].body_yaw_right_tab:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter"})
    antiaim[i].body_yaw_freestanding_right = antiaim[i].body_yaw_right_tab:combo("Freestanding", {"Disabled", "Peek Fake", "Peek Real"})



    antiaim[i].defensive = tab.antihit.constructor:switch("Defensive AA")
    antiaim[i].defensivetab = antiaim[i].defensive:create()
    antiaim[i].defensive_pitch_left = antiaim[i].defensivetab:slider("Pitch", -89, 89, 0, 1, "°")
    antiaim[i].defensive_pitch_right = antiaim[i].defensivetab:slider("Pitch", -89, 89, 0, 1, "°")
    antiaim[i].defensive_offset_left = antiaim[i].defensivetab:slider("Yaw Offset", -180, 180, 0, 1, "°")
    antiaim[i].defensive_offset_right = antiaim[i].defensivetab:slider("Yaw Offset", -180, 180, 0, 1, "°")

    antiaim[i].fakelags = tab.antihit.constructor:switch("Fake Lag")
    antiaim[i].fakelags_tab = antiaim[i].fakelags:create()
    antiaim[i].fakelags_ticks = antiaim[i].fakelags_tab:slider("Limit", 0, 14, 0)
    antiaim[i].fakelags_v = antiaim[i].fakelags_tab:slider("Veriability", 0, 100, 0, 1, "%")

end

antiaim.get_state = function(cmd)

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    local flags = player.m_fFlags
    
    local on_ground = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_air = cmd.in_jump
    local is_duck = bit.band(flags, bit.lshift(1, 1)) ~= 0 or ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get()
    local is_not_move = player.m_vecVelocity:length() < 2
    local is_slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get()
    
    if is_duck and (is_air or not on_ground) then
        antiaim.player_state = antiaim.state.air_duck
        antiaim.game_state = 5        
        return
    elseif (is_air or not on_ground) and not is_duck then
        antiaim.player_state = antiaim.state.air
        antiaim.game_state = 4     
        return  
    elseif is_slow_walk then
        antiaim.player_state = antiaim.state.slowwalk
        antiaim.game_state = 2
        return
    elseif not is_duck and is_not_move and not is_air then
        antiaim.player_state = antiaim.state.stand
        antiaim.game_state = 0
        return
    elseif is_duck and not is_air then
        antiaim.player_state = antiaim.state.duck
        antiaim.game_state = 3
        return
    elseif not is_duck and not is_not_move and not is_slow_walk and not is_air then
        antiaim.player_state =  antiaim.state.move
        antiaim.game_state = 1
        return
    end

end

antiaim.side = false
antiaim.swap = false
antiaim.side_switcher = function()

    local player = entity.get_local_player()

    if not player then
        return
    end

    if globals.choked_commands ~= 0 then 
        return
    end

    if antiaim[antiaim.game_state].swap_delay:get() then

        if globals.tickcount % antiaim[antiaim.game_state].swap_delay_ticks:get() == antiaim[antiaim.game_state].swap_delay_ticks:get() - 1 then
            antiaim.swap = not antiaim.swap
        end

        rage.antiaim:inverter(antiaim.swap)

        antiaim.side = rage.antiaim:inverter()

    else

        antiaim.side = player.m_flPoseParameter[11] * 120 - 60 < 0 and true or false 

    end

end

antiaim.yaw = 0
antiaim.yaw_offset = 0
antiaim.yaw_system = function()

    local player = entity.get_local_player()

    local antibruteforce = {
        yaw_offset
    }

    antiaim.yaw = antiaim.side and antiaim[antiaim.game_state].yaw_left:get() or antiaim[antiaim.game_state].yaw_right:get()
    antiaim.yaw_offset = antiaim.side and antiaim[antiaim.game_state].yaw_offset_left:get() or antiaim[antiaim.game_state].yaw_offset_right:get()

    if antiaim[antiaim.game_state].defensive:get() then

        refs.hidden:override(true)        
        rage.antiaim:override_hidden_yaw_offset(antiaim.side and antiaim[antiaim.game_state].defensive_offset_left:get() or antiaim[antiaim.game_state].defensive_offset_right:get())
        rage.antiaim:override_hidden_pitch(antiaim.side and antiaim[antiaim.game_state].defensive_pitch_left:get() or antiaim[antiaim.game_state].defensive_pitch_right:get())

    else

        refs.hidden:override(nil) 

    end

    refs.fakelag:override(antiaim[antiaim.game_state].fakelags:get())
    refs.fakelag_limit:override(antiaim[antiaim.game_state].fakelags_ticks:get())
    refs.fakelag_v:override(antiaim[antiaim.game_state].fakelags_v:get())

    refs.pitch:override(antiaim[antiaim.game_state].pitch:get())
    refs.yaw:override(antiaim.yaw)
    refs.yaw_base:override(menu.yaw_base:get())
    refs.avoid_backstab:override(menu.antiaim_tweaks:get("Avoid Backstab"))

    if menu.antibruteforce_modifiers:get("Yaw") then

        local random = math.random(0, 5)
        local znak_random = math.random(1, 2)

        if znak_random == 1 then
            antibruteforce.yaw_offset = antiaim.yaw_offset - random
        elseif znak_random == 2 then
            antibruteforce.yaw_offset = antiaim.yaw_offset + random
        end
        
        refs.yaw_offset:override(antibruteforce.yaw_offset)

    else

        refs.yaw_offset:override(antiaim.yaw_offset)

    end

end

antiaim.yaw_modifier = 0
antiaim.yaw_modifier_offset = 0
antiaim.yaw_modifier_system = function()

    local player = entity.get_local_player()
        
    antiaim.yaw_modifier = antiaim.side and antiaim[antiaim.game_state].yaw_modifier_left:get() or antiaim[antiaim.game_state].yaw_modifier_right:get()
    antiaim.yaw_modifier_offset = antiaim.side and antiaim[antiaim.game_state].yaw_modifier_left_offset:get() or antiaim[antiaim.game_state].yaw_modifier_right_offset:get()

    refs.yaw_modifier:override(antiaim.yaw_modifier)
    refs.modifier_offset:override(antiaim.yaw_modifier_offset)

end

antiaim.body_yaw = 0
antiaim.fake_limit = 0 
antiaim.options = 0
antiaim.body_yaw_freestanding = 0
antiaim.body_yaw_system = function()

    local player = entity.get_local_player()

    local antibruteforce = {
        fake_limit
    }

    antiaim.body_yaw = antiaim.side and antiaim[antiaim.game_state].body_yaw_left:get() or antiaim[antiaim.game_state].body_yaw_right:get()
    antiaim.fake_limit = antiaim.side and antiaim[antiaim.game_state].fake_limit_left:get() or antiaim[antiaim.game_state].fake_limit_right:get()
    antiaim.options = antiaim.side and antiaim[antiaim.game_state].options_left:get() or antiaim[antiaim.game_state].options_right:get()
    antiaim.body_yaw_freestanding = antiaim.side and antiaim[antiaim.game_state].body_yaw_freestanding_left:get() or antiaim[antiaim.game_state].body_yaw_freestanding_right:get()

    refs.body_yaw:override(antiaim.body_yaw)
    refs.options:override(antiaim.options)
    refs.body_yaw_freestanding:override(antiaim.body_yaw_freestanding)

    refs.freestanding:override(menu.freestanding:get())
    refs.disable_yaw_modifiers:override(menu.freestanding_dym:get())
    refs.body_freestanding:override(menu.freestanding_bf:get())

    if menu.antibruteforce_modifiers:get("Desync") then

        local random = math.random(0, 14)

        antibruteforce.fake_limit = antiaim.fake_limit - random

        refs.left_limit:override(antibruteforce.fake_limit)
        refs.right_limit:override(antibruteforce.fake_limit)

    else

        refs.left_limit:override(antiaim.fake_limit)
        refs.right_limit:override(antiaim.fake_limit)

    end

end

antiaim.break_lc_in_air = function()

    local player = entity.get_local_player()
    local air = bit.band(player.m_fFlags, 1) == 0

    if air and menu.antiaim_tweaks:get("Force Break LC In-Air") then
        if globals.tickcount % 2 == 0 then
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
        elseif globals.tickcount % 2 == 1 then
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("On Peek")
        end
    end
    
end

antiaim.fast_ladder = function(cmd)

    if not menu.antiaim_tweaks:get("Fast Ladder Move") then 
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if player.m_MoveType ~= 9 then 
        return
    end

    local weapons = {43, 44, 45, 46, 47, 48}

    for k, w in pairs(weapons) do

        if player:get_player_weapon():get_weapon_index() == w then
            return
        end

    end

    cmd.in_moveleft = cmd.in_back

    if cmd.sidemove == 0 then 
        cmd.view_angles.y = cmd.view_angles.y + 45 
    end

    if cmd.in_forward and cmd.sidemove < 0 then 
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    if cmd.in_back and cmd.sidemove > 0 then 
        cmd.view_angles.y = cmd.view_angles.y + 90 
    end

    if cmd.view_angles.x < 0 then 
        cmd.view_angles.x = -45 
    end

    cmd.in_moveright = cmd.in_forward

end

antiaim.main = function(cmd)

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    antiaim.side_switcher()
    antiaim.yaw_system()
    antiaim.yaw_modifier_system()
    antiaim.body_yaw_system()
    antiaim.break_lc_in_air()
    antiaim.fast_ladder(cmd)
    antiaim.get_state(cmd)

end

antiaim.menu_manager = function()

    if menu.condition:get() == "Standing" then
        antiaim.menu_state = 0
    end

    if menu.condition:get() == "Running" then
        antiaim.menu_state = 1
    end

    if menu.condition:get() == "Slow Walk" then
        antiaim.menu_state = 2
    end

    if menu.condition:get() == "Duck" then
        antiaim.menu_state = 3
    end

    if menu.condition:get() == "Air" then
        antiaim.menu_state = 4
    end

    if menu.condition:get() == "Air & Duck" then
        antiaim.menu_state = 5
    end

end

antiaim.visible = function()

    for k, state in pairs(antiaim[0]) do 
        state:visibility(menu.condition:get() == "Standing") 
    end

    for k, state in pairs(antiaim[1]) do 
        state:visibility(menu.condition:get() == "Running") 
    end

    for k, state in pairs(antiaim[2]) do 
        state:visibility(menu.condition:get() == "Slow Walk") 
    end

    for k, state in pairs(antiaim[3]) do 
        state:visibility(menu.condition:get() == "Duck") 
    end

    for k, state in pairs(antiaim[4]) do 
        state:visibility(menu.condition:get() == "Air")
    end

    for k, state in pairs(antiaim[5]) do 
        state:visibility(menu.condition:get() == "Air & Duck") 
    end

    antiaim[antiaim.menu_state].yaw_left:visibility(false)
    antiaim[antiaim.menu_state].yaw_offset_left:visibility(false)
    antiaim[antiaim.menu_state].yaw_modifier_left:visibility(false)
    antiaim[antiaim.menu_state].yaw_modifier_left_offset:visibility(false)
    antiaim[antiaim.menu_state].body_yaw_left:visibility(false)
    antiaim[antiaim.menu_state].fake_limit_left:visibility(false)
    antiaim[antiaim.menu_state].options_left:visibility(false)
    antiaim[antiaim.menu_state].body_yaw_freestanding_left:visibility(false)

    antiaim[antiaim.menu_state].yaw_right:visibility(false)
    antiaim[antiaim.menu_state].yaw_offset_right:visibility(false)
    antiaim[antiaim.menu_state].yaw_modifier_right:visibility(false)
    antiaim[antiaim.menu_state].yaw_modifier_right_offset:visibility(false)
    antiaim[antiaim.menu_state].body_yaw_right:visibility(false)
    antiaim[antiaim.menu_state].fake_limit_right:visibility(false)
    antiaim[antiaim.menu_state].options_right:visibility(false)
    antiaim[antiaim.menu_state].body_yaw_freestanding_right:visibility(false)

    antiaim[antiaim.menu_state].defensive_pitch_left:visibility(false)
    antiaim[antiaim.menu_state].defensive_pitch_right:visibility(false)
    antiaim[antiaim.menu_state].defensive_offset_left:visibility(false)
    antiaim[antiaim.menu_state].defensive_offset_right:visibility(false)

    if antiaim[antiaim.menu_state].player_side:get() == "Left" then 

        antiaim[antiaim.menu_state].yaw_left:visibility(true)

        if antiaim[antiaim.menu_state].yaw_left:get() == "Backward" or antiaim[antiaim.menu_state].yaw_left:get() == "Static" then

            antiaim[antiaim.menu_state].yaw_offset_left:visibility(true)
            antiaim[antiaim.menu_state].yaw_modifier_left:visibility(true)
            antiaim[antiaim.menu_state].yaw_modifier_left_offset:visibility(true)

        end

        antiaim[antiaim.menu_state].body_yaw_left:visibility(true)

        if antiaim[antiaim.menu_state].body_yaw_left:get() then

            antiaim[antiaim.menu_state].fake_limit_left:visibility(true)
            antiaim[antiaim.menu_state].options_left:visibility(true)
            antiaim[antiaim.menu_state].body_yaw_freestanding_left:visibility(true)

        end

        if antiaim[antiaim.menu_state].defensive:get() then

            antiaim[antiaim.menu_state].defensive_pitch_left:visibility(true)
            antiaim[antiaim.menu_state].defensive_offset_left:visibility(true)

        end

    elseif antiaim[antiaim.menu_state].player_side:get() == "Right" then


        antiaim[antiaim.menu_state].yaw_right:visibility(true)

        if antiaim[antiaim.menu_state].yaw_right:get() == "Backward" or antiaim[antiaim.menu_state].yaw_right:get() == "Static" then

            antiaim[antiaim.menu_state].yaw_offset_right:visibility(true)
            antiaim[antiaim.menu_state].yaw_modifier_right:visibility(true)
            antiaim[antiaim.menu_state].yaw_modifier_right_offset:visibility(true)

        end

        antiaim[antiaim.menu_state].body_yaw_right:visibility(true)

        if antiaim[antiaim.menu_state].body_yaw_right:get() then

            antiaim[antiaim.menu_state].fake_limit_right:visibility(true)
            antiaim[antiaim.menu_state].options_right:visibility(true)
            antiaim[antiaim.menu_state].body_yaw_freestanding_right:visibility(true)

        end

        if antiaim[antiaim.menu_state].defensive:get() then

            antiaim[antiaim.menu_state].defensive_pitch_right:visibility(true)
            antiaim[antiaim.menu_state].defensive_offset_right:visibility(true)

        end

    end

    menu.debug_panel_x:visibility(false)
    menu.debug_panel_y:visibility(false)
    menu.velocity_x:visibility(false)
    menu.velocity_y:visibility(false)
    menu.velocity_indication_color:visibility(false)

    if menu.velocity_indication:get() then
        menu.velocity_indication_color:visibility(true)
    end

    menu.debug_panel_glow_color:visibility(false)

    if menu.debug_panel:get() then
        menu.debug_panel_glow_color:visibility(true)
    end

    menu.auto_teleport_delay:visibility(false)
    menu.auto_teleport_force_recharge:visibility(false)
    if menu.auto_teleport:get() then 

        menu.auto_teleport_delay:visibility(true)
        menu.auto_teleport_force_recharge:visibility(true)

    end
 
    menu.local_player_angles_fake:visibility(false)
    menu.local_player_angles_real:visibility(false)
    if menu.local_player_angles:get() then

        menu.local_player_angles_fake:visibility(true)
        menu.local_player_angles_real:visibility(true)

    end

    menu.no_scope_mode_scout:visibility(false)
    menu.no_scope_mode_awp:visibility(false)
    menu.no_scope_mode_auto:visibility(false)
    if menu.no_scope_mode:get() then 

        menu.no_scope_mode_scout:visibility(true)
        menu.no_scope_mode_awp:visibility(true)
        menu.no_scope_mode_auto:visibility(true)

    end

    menu.air_mode_scout:visibility(false)
    menu.air_mode_awp:visibility(false)
    menu.air_mode_auto:visibility(false)
    menu.air_mode_r8:visibility(false)
    menu.air_mode_deagle:visibility(false)
    if menu.air_mode:get() then

        menu.air_mode_scout:visibility(true)
        menu.air_mode_awp:visibility(true)
        menu.air_mode_auto:visibility(true)
        menu.air_mode_r8:visibility(true)
        menu.air_mode_deagle:visibility(true)

    end

    menu.crosshair_indication_main_color:visibility(false)
    menu.crosshair_indication_addative_color:visibility(false)
    if menu.crosshair_indication:get() then
        menu.crosshair_indication_main_color:visibility(true)
        menu.crosshair_indication_addative_color:visibility(true)
    end

    menu.kibit_min_damage_color:visibility(false)
    if menu.kibit_min_damage:get() then
        menu.kibit_min_damage_color:visibility(true)
    end

    menu.custom_scope_color:visibility(false)
    menu.custom_scope_gap:visibility(false)
    menu.custom_scope_size:visibility(false)
    if menu.custom_scope:get() then
        menu.custom_scope_color:visibility(true)
        menu.custom_scope_gap:visibility(true)
        menu.custom_scope_size:visibility(true)
    end

    menu.hitmarker_font:visibility(false)
    menu.hitmarker_type:visibility(false)
    menu.hitmarker_text:visibility(false)
    menu.hitmarker_color:visibility(false)
    menu.hitlable:visibility(false)
    if menu.hitmarker:get() then
        menu.hitmarker_font:visibility(true)
        menu.hitmarker_type:visibility(true)
        menu.hitmarker_text:visibility(true)
        menu.hitlable:visibility(true)
        menu.hitmarker_color:visibility(true)
    end

    menu.logging_types:visibility(false)
    menu.logging_color:visibility(false)
    menu.logging_color_miss:visibility(false)
    menu.logging_position:visibility(false)

    if menu.logging:get() then
        menu.logging_types:visibility(true)
        menu.logging_color:visibility(true)
        menu.logging_color_miss:visibility(true)
        menu.logging_position:visibility(true)
    end

    menu.aspect_ratio_value:visibility(false)
    if menu.aspect_ratio:get() then
        menu.aspect_ratio_value:visibility(true)
    end

    menu.custom_viewmodel_fov:visibility(false)
    menu.custom_viewmodel_x:visibility(false)
    menu.custom_viewmodel_y:visibility(false)
    menu.custom_viewmodel_z:visibility(false)
    if menu.custom_viewmodel:get() then
        menu.custom_viewmodel_fov:visibility(true)
        menu.custom_viewmodel_x:visibility(true)
        menu.custom_viewmodel_y:visibility(true)
        menu.custom_viewmodel_z:visibility(true)
    end

    menu.auto_mute_type:visibility(false)
    if menu.auto_mute:get() then
        menu.auto_mute_type:visibility(true)
    end

    menu.trashtalk_states:visibility(false)
    if menu.trashtalk:get() then
        menu.trashtalk_states:visibility(true)
    end

    menu.enemy_molotov_color:visibility(false)
    menu.smoke_color:visibility(false)
    if  menu.greande_radius:get() then
        menu.enemy_molotov_color:visibility(true)
        menu.smoke_color:visibility(true)
    end

end

antiaim.animations = function(thisptr, edx)
    hooked_function(thisptr, edx)

    if not menu.animation_breakers:get() then
        return
    end

    local player = entity.get_local_player()

    if not player then
        return 
    end

    if not player:is_alive() then 
        return 
    end

    local player_state = antiaim.player_state
    local leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")

    if menu.air_legs:get() == "Default" then

        leg_movement:override("Default")

    elseif menu.air_legs:get() == "Static" then

        leg_movement:override("Sliding")
        player.m_flPoseParameter[6] = 1

    elseif player_state == antiaim.state.air or player_state == antiaim.state.air_duck and menu.air_legs:get() == antiaim.state.slow_walk then

        ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][6].m_flWeight = 1

    end

    if menu.ground_legs:get() == "Default" then

        leg_movement:override("Default")

    elseif menu.ground_legs:get() == "Static" then

        leg_movement:override("Sliding")
        player.m_flPoseParameter[0] = 1

    elseif menu.ground_legs:get() == "Walk" then

        leg_movement:override("Walking")
        player.m_flPoseParameter[7] = 0

    end

    if menu.move_lean:get() and player.m_vecVelocity:length() > 3 then

        ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][12].m_flWeight = (menu.move_lean_effect:get()/10)

    end

    if menu.pitch_null:get() then

        if player_state ~= antiaim.state.air and player_state ~= antiaim.state.air_duck and ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi.cast("uintptr_t", thisptr) + 0x9960)[0].bHitGroundAnimation then
            player.m_flPoseParameter[12] = 0.5
        end

    end

    if menu.sliding_slow_walk:get() then

        player.m_flPoseParameter[9] = 0

    end

end

antiaim.anim_update = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local local_player_ptr = adress.get_entity_address(player:get_index())

    if local_player_ptr == nil or hooked_function then
        return
    end

    local hook_lplayer = vmt_hook.new(local_player_ptr)
    hooked_function = hook_lplayer.hook("void(__fastcall*)(void*, void*)", antiaim.animations, 224)
end

animation = 0
doubletap_alpha = 0
doubletap_move = 0
hideshots_alpha = 0
hideshots_move = 0
damage_alpha = 0
damage_move = 0
bodyaim_alpha = 0
bodyaim_move = 0
safepoint_alpha = 0
safepoint_move = 0
local lerp = function(a, b, c)
    return a - (a - b) * c
end
visuals.crosshair_indication = function()

    if not menu.crosshair_indication:get() then
        return
    end

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    if not player:is_alive() then 
        return 
    end

    if common.is_button_down(0x09) then 
        return 
    end

    local add_y = 0
    local anim_score = 40
    local state_anim_speed = 8
    local main_color = menu.crosshair_indication_main_color:get()
    local addative_color = menu.crosshair_indication_addative_color:get()
    local scope = player.m_bIsScoped
    local frametime = globals.frametime
    
    local min_damage = false
    local get_binds = ui.get_binds()
    for i = 1, #get_binds do 
        local binds = get_binds[i] 
        if binds.name == 'Min. Damage' and binds.active then 
            min_damage = true 
        end 
    end

    animation = lerp(animation, scope and 1 or 0, 20 * frametime)
    doubletap_alpha = lerp(doubletap_alpha, refs.doubletap:get() and 1 or 0, 8 * frametime)
    doubletap_move = lerp(doubletap_move, refs.doubletap:get() and 1 or 0, 8 * frametime)
    hideshots_alpha = lerp(hideshots_alpha, refs.hideshots:get() and 1 or 0, 8 * frametime)
    hideshots_move = lerp(hideshots_move, refs.hideshots:get() and 1 or 0, 8 * frametime)
    damage_alpha = lerp(damage_alpha, min_damage and 1 or 0, 8 * frametime)
    damage_move = lerp(damage_move, min_damage and 1 or 0, 8 * frametime)
    bodyaim_alpha = lerp(bodyaim_alpha, refs.bodyaim:get() == "Force" and 1 or 0, 8 * frametime)
    bodyaim_move = lerp(bodyaim_move, refs.bodyaim:get() == "Force" and 1 or 0, 8 * frametime)
    safepoint_alpha = lerp(safepoint_alpha, refs.safepoint:get() == "Force" and 1 or 0, 8 * frametime)
    safepoint_move = lerp(safepoint_move, refs.safepoint:get() == "Force" and 1 or 0, 8 * frametime)

    local screen = {
        x = render.screen_size().x,
        y = render.screen_size().y
    }

    if antiaim.player_state == antiaim.state.stand then
      
        pstate2 = "standing"

    elseif antiaim.player_state == antiaim.state.move then
    
        pstate2 = "running"

    elseif antiaim.player_state == antiaim.state.slowwalk then
       
        pstate2 = "slow motion"

    elseif antiaim.player_state == antiaim.state.duck then
       
        pstate2 = "crouching"

    elseif antiaim.player_state == antiaim.state.air then
       
        pstate2 = "jumping"

    elseif antiaim.player_state == antiaim.state.air_duck then

        pstate2 = "crouching air"

    end

    local names = {
        lua_name = string.upper("elevrate"),
        lua_build = string.upper(vars.lua.build),
        pstate = string.upper(pstate2),
        doubletap = string.upper("dt"),
        hideshots = string.upper("os"),
        damage = string.upper("dmg"),
        bodyaim = string.upper("baim"),
        safepoint = string.upper("safe"),
    }

    local text_size = {
        lua_name = render.measure_text(2, nil, names.lua_name),
        lua_build = render.measure_text(2, nil, names.lua_build),
        pstate = render.measure_text(2, nil, names.pstate),
        doubletap = render.measure_text(2, nil, names.doubletap),
        hideshots = render.measure_text(2, nil, names.hideshots),
        damage = render.measure_text(2, nil, names.damage),
        bodyaim = render.measure_text(2, nil, names.bodyaim),
        safepoint = render.measure_text(2, nil, names.safepoint),
    }

    local dt_recharge_color = color(255, 76, 81, addative_color.a * doubletap_alpha)
   
    function add_text(pos, color, text)
        render.text(2, pos, color, nil, text)
    end

    render.shadow(vector( (screen.x / 2) - (text_size.lua_name.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + text_size.lua_name.y / 2), vector((screen.x / 2) + (text_size.lua_name.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y + text_size.lua_name.y/2), main_color, text_size.lua_name.y * 2, 0)
    add_text(vector( (screen.x / 2) - (text_size.lua_name.x / 2) - (text_size.lua_build.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22)), main_color, names.lua_name)
    add_text(vector( (screen.x / 2) + (text_size.lua_name.x / 2) - (text_size.lua_build.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22)), main_color, names.lua_build)
    add_y = add_y + (text_size.lua_name.y/1.3)
    add_text(vector( (screen.x / 2) - (text_size.pstate.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), addative_color, names.pstate)
    add_y = add_y + (text_size.pstate.y/1.3)
    add_text(vector( (screen.x / 2) - (text_size.doubletap.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), rage.exploit:get() == 1 and color(addative_color.r, addative_color.g, addative_color.b, addative_color.a * doubletap_alpha) or dt_recharge_color, names.doubletap)
    add_y = add_y + ((text_size.doubletap.y/1.3) * doubletap_move)
    add_text(vector( (screen.x / 2) - (text_size.hideshots.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), color(addative_color.r, addative_color.g, addative_color.b, addative_color.a * hideshots_alpha), names.hideshots)
    add_y = add_y + ((text_size.hideshots.y/1.3) * hideshots_move)
    add_text(vector( (screen.x / 2) - (text_size.damage.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), color(addative_color.r, addative_color.g, addative_color.b, addative_color.a * damage_alpha), names.damage)
    add_y = add_y + ((text_size.damage.y/1.3) * damage_move)
    add_text(vector( (screen.x / 2) - (text_size.bodyaim.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), color(addative_color.r, addative_color.g, addative_color.b, addative_color.a * bodyaim_alpha), names.bodyaim)
    add_y = add_y + ((text_size.bodyaim.y/1.3) * bodyaim_move)
    add_text(vector( (screen.x / 2) - (text_size.safepoint.x / 2) + ((screen.x / anim_score) * animation), screen.y / 2 + (screen.y / 22) + add_y), color(addative_color.r, addative_color.g, addative_color.b, addative_color.a * safepoint_alpha), names.safepoint)
    add_y = add_y + ((text_size.safepoint.y/1.3) * safepoint_move)   

end

visuals.kibit_damage = function()

    if not menu.kibit_min_damage:get() then
        return 
    end

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    if not player:is_alive() then 
        return 
    end

    if common.is_button_down(0x09) then 
        return 
    end

    local screen = {
        x = render.screen_size().x,
        y = render.screen_size().y
    }

    local text = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()

    function add_text(pos, color, text)
        render.text(1, pos, color, nil, text)
    end

    add_text(vector(screen.x / 2 + 6, screen.y / 2.08), menu.kibit_min_damage_color:get(), text)

end

local animation = 0
visuals.custom_scope = function()
    
    if not menu.custom_scope:get() then 
        return 
    end
    
    local player = entity.get_local_player()

    if not player then 
        return 
    end

    if not player:is_alive() then 
        return 
    end

    if common.is_button_down(0x09) then 
        return 
    end

    local screen = {
        x = render.screen_size().x,
        y = render.screen_size().y
    }

    local scope = player.m_bIsScoped
    local frametime = globals.frametime
    local main_clr =  menu.custom_scope_color:get()

    local gap = menu.custom_scope_gap:get()
    local size = menu.custom_scope_size:get()

    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")

    animation = lerp(animation, scope and 1 or 0, 12 * frametime)

    if not scope and animation < 0.05 then 
        return 
    end

    render.gradient(vector( screen.x / 2 -gap * animation, screen.y / 2), vector( screen.x / 2 -gap * animation - size * animation, screen.y / 2 + 1), main_clr, color(255, 255, 255, 0), main_clr, color(255, 255, 255, 0))
    render.gradient(vector( screen.x / 2 +gap * animation + 1, screen.y / 2), vector( screen.x / 2 +gap * animation + size * animation, screen.y / 2 + 1), main_clr, color(255, 255, 255, 0), main_clr, color(255, 255, 255, 0))
    render.gradient(vector( screen.x / 2, screen.y / 2 +gap * animation), vector( screen.x / 2 + 1, screen.y / 2 +gap * animation + size * animation), main_clr, main_clr, color(255, 255, 255, 0), color(255, 255, 255, 0))
    render.gradient(vector( screen.x / 2, screen.y / 2 -gap * animation), vector( screen.x / 2 + 1, screen.y / 2 -gap * animation - size * animation), main_clr, main_clr, color(255, 255, 255, 0), color(255, 255, 255, 0))    
end

local watermark = drag_system.register({menu.debug_panel_x, menu.debug_panel_y}, vector(misc.watermark_size().x, misc.watermark_size().y * 2), "Watermark", function(self)

    if not menu.debug_panel:get() then 
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    local avatar = player:get_steam_avatar()
    
    local ping = globals.is_connected and math.floor(utils.net_channel().latency[1] * 1000) or 0
    local asd = string.format(ping)

    local elevrate_size = render.measure_text(1, nil, "     Elevrate.Codes ∙ "..vars.lua.build.. " ∙ " ..vars.cheat.user.."  ")

    render.shadow(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y - 3), menu.debug_panel_glow_color:get(), 30)
    render.rect(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y - 3), color(24, 24, 24, 180)) 
    render.rect(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y - 2), menu.debug_panel_glow_color:get()) 
    render.text(1, vector(self.position.x, self.position.y + 5), color(255, 255, 255, 255), nil, "     Elevrate.Codes ∙ "..vars.lua.build.. " ∙ " ..vars.cheat.user.."  ")  
    render.texture(avatar, vector(self.position.x + 5, self.position.y + 6), vector(11, 11), color(), 6)  

end)

local velocity_anim = 0
local velocity_indicator = drag_system.register({menu.velocity_x, menu.velocity_y}, vector(render.screen_size().x / 15, render.screen_size().y / 20), "Velocity", function(self)

    if not menu.velocity_indication:get() then
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    local mod = player["m_flVelocityModifier"]

    local text = math.floor(mod*(render.screen_size().x / 15))
    local velocity = math.floor(mod*100)
    local text_size = render.measure_text(1, nil, "Velocity "..velocity.."%")
    local clr = menu.velocity_indication_color:get()

    if ui.get_alpha() > 0.5 then 
        velocity_anim = lerp(velocity_anim, ui.get_alpha() > 0.5 and 1 or 0, 10 * globals.frametime)
    elseif velocity ~= 100 and ui.get_alpha() < 0.5 then
        velocity_anim = lerp(velocity_anim, (velocity ~= 100 and ui.get_alpha() < 0.5) and 1 or 0, 10 * globals.frametime)
    elseif velocity == 100 and ui.get_alpha() < 0.5 then
        velocity_anim = lerp(velocity_anim, velocity == 100 and 0 or 1, 10 * globals.frametime)
    elseif not player:is_alive() and ui.get_alpha() < 0.5 then
        velocity_anim = lerp(velocity_anim, player:is_alive() and 1 or 0, 10 * globals.frametime)
    end

    position = {render.screen_size().x - (render.screen_size().x / 15), render.screen_size().y + render.screen_size().y}

    render.text(1, vector(self.position.x + (self.size.x / 2) - (text_size.x / 2), self.position.y - 16), color(255, 255, 255, 255 * velocity_anim), nil, "Velocity "..velocity.."%")
    render.shadow(vector(self.position.x, self.position.y - 2), vector(self.position.x + text, self.position.y + 2), color(clr.r, clr.g, clr.b, clr.a * velocity_anim), (render.screen_size().y / 20) / 2, 3)
    render.rect_outline(vector(self.position.x, self.position.y - 2), vector(self.position.x + self.size.x, self.position.y + 2), color(24,24,24,255 * velocity_anim), 3, 3)
    render.rect(vector(self.position.x, self.position.y - 2), vector(self.position.x + text, self.position.y + 2), color(clr.r, clr.g, clr.b, clr.a * velocity_anim), 3) 

end)

local calibri = render.load_font("Calibri", 23, "abd")

render.indicator = function(str, ay, clr, circle_clr, circle_degree)
    local x, y = render.screen_size().x/100 + 2, render.screen_size().y/1.47
    ts = render.measure_text(calibri, nil, str)
    render.gradient(vector(x/1.9, y + ay), vector(x/1.9 + (ts.x) / 2, y + ay + ts.y + 6), color(0, 0, 0, 0), color(0, 0, 0, 45), color(0, 0, 0, 0), color(0, 0, 0, 45))
    render.gradient(vector(x/1.9 + (ts.x) / 2, y + ay), vector(x/1.9 + (ts.x), y + ay + ts.y + 6), color(0, 0, 0, 45), color(0, 0, 0, 0), color(0, 0, 0, 45), color(0, 0, 0, 0))
    render.text(calibri, vector(x, y + 4 + ay), clr, nil, str)

    if circle_clr and circle_degree then
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+2), color(0, 0, 0, 255), 10.5, 90, 1, 4)
        render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y/2+2), circle_clr, 10, 90, circle_degree, 3)
    end
end

visuals.get_bind = function(name)
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

visuals.spectators_get = function()
    local spectators = {}

    local local_player, target = entity.get_local_player()

    if local_player ~= nil then
        if local_player.m_hObserverTarget then
            target = local_player.m_hObserverTarget
        else
            target = local_player
        end

        local players = entity.get_players(false, false)

        if players ~= nil then
            for k, player in pairs(players) do
                local obtarget = player.m_hObserverTarget

                if obtarget and obtarget == target then
                    table.insert(spectators, player)
                end
            end
        end
    end

    return spectators
end

visuals.skeet_indication = function()

    if not menu.indication500:get() then 
        return 
    end    

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    if not player:is_alive() then 
        return 
    end

    local screen = {
        x = render.screen_size().x,
        y = render.screen_size().y
    }

    local add_y = 5
    local spectators = visuals.spectators_get()

    for _, spec in pairs(spectators) do

        local name = spec:get_name() 
        local text_size = render.measure_text(1, nil, name).x

        render.text(1, vector(screen.x - text_size - 2, 2 + add_y), color(255,255,255,255), nil, name)

        add_y = add_y + 17

    end

    local c4 = entity.get_entities("CPlantedC4", true)[1]
    local bombsite = ""
    local timer = 0
    local defused = false
    local damage = 0
    local dmg = 0
    local willKill = false
    if c4 ~= nil then
        timer = (c4.m_flC4Blow - globals.curtime)
        defused = c4.m_bBombDefused
        if timer > 0 and not defused then
            local defusestart = c4.m_hBombDefuser ~= 4294967295
            local defuselength = c4.m_flDefuseLength
            local defusetimer = defusestart and (c4.m_flDefuseCountDown - globals.curtime) or -1
            if defusetimer > 0 then
                local clr = timer > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                
                local barlength = (((screen.y - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, screen.y), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, screen.y), color(25, 25, 25, 160))
                
                render.rect(vector(0, screen.y - barlength), vector(16, screen.y), clr)
            end
            
            bombsite = c4.m_nBombSite == 0 and "A" or "B"
            local health = player.m_iHealth
            local armor = player.m_ArmorValue
            local eLoc = c4.m_vecOrigin
            local lLoc = player.m_vecOrigin
            local distance = eLoc:dist(lLoc)
            local a = 450.7
            local b = 75.68
            local c = 789.2
            local d = (distance - b) / c;

            damage = a * math.exp(-d * d)
            
            if armor > 0 then
                local newDmg = damage * 0.5;

                local armorDmg = (damage - newDmg) * 0.5
                if armorDmg > armor then
                    armor = armor * (1 / .5)
                    newDmg = damage - armorDmg
                end
                damage = newDmg;
            end

            dmg = math.ceil(damage)

            if dmg >= health then
                willKill = true
            else 
                willKill = false
            end
        end
    end
    if c4_info.planting then
        c4_info.fill = 3.125 - (3.125 + c4_info.on_plant_time - globals.curtime)
        if(c4_info.fill > 3.125) then
            c4_info.fill = 3.125
        end
    end

    local adjust_adding = 37
    local add_y = 0

    local getbind = visuals.get_bind

    local ping = player:get_resource().m_iPing

    local delta = (math.abs(ping % 360)) / (refs.fake_latency:get() / 2)

    if delta > 1 then 
        delta = 1 
    end

    local ping_color = color(255 - (125 * delta), 200 * delta, 0)

    local binds = {

        {"DA", refs.dormant_aimbot:get(), color(255, 200)},
        {"PING", refs.fake_latency:get() > 0 and player:is_alive(), ping_color},
        {"BODY", refs.bodyaim:get() == "Force", color(255, 200)},
        {"SAFE", refs.safepoint:get() == "Force", color(255, 200)},
        {"DT", refs.doubletap:get(), rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 0, 255)},
        {"OSAA", refs.hideshots:get(), color(255, 200)},
        {"DUCK", ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(255, 200)},
        {"FS", menu.freestanding:get(), color(255, 200)},        
        {"HITCHANCE OVR", getbind("Hit Chance")[1], color(255, 200)},
        {"HITBOX OVR", getbind("Hitboxes")[1], color(255, 200)},
        {"MD", getbind("Min. Damage")[1], color(255, 200)},
        {bombsite.." - " .. string.format("%.1f", timer) .. "s", timer > 0 and not defused, color(255, 200)},
        {"FATAL", player:is_alive() and willKill, color(255, 0, 0, 255)},
        {"-" .. dmg .. " HP", player:is_alive() and not willKill and damage > 0.5, color(210, 216, 112, 255)},
        {c4_info.planting_site, c4_info.planting, color(210, 216, 112, 255), color(255, 255), skeet_indication_style == "New" and c4_info.fill/3.3 or nil},

    }

    for k, v in pairs(binds) do
        if v[2] then
            render.indicator(v[1], add_y, v[3], v[4], v[5])
            add_y = add_y - adjust_adding
        end
    end

end

local round = function(num, numDecimalPlaces) 
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num)) 
end

local hitgroup_text = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}

events.aim_ack:set(function(shot)

    if not menu.logging:get() then 
        return 
    end

    local shot_info = {
        name = shot.target:get_name(),
        damage = shot.damage,
        hitbox = shot.hitgroup,
        wanted_damage = shot.wanted_damage,
        backtrack = shot.backtrack
    }

    if not shot.state then 

        table.insert(hitlogs, {state = "shot",
            name = string.lower(shot_info.name), 
            hitbox = hitgroup_text[shot.hitgroup], 
            damage = shot_info.damage, 
            wanted_dmg = shot_info.wanted_damage, 
            bt = shot_info.backtrack,                                                                                    
            anim = 0,
            time = globals.realtime,
            clr_r = menu.logging_color:get().r,
            clr_g = menu.logging_color:get().g,
            clr_b = menu.logging_color:get().b,
            clr_a = menu.logging_color:get().a
        })     

    elseif shot.state then    

        table.insert(hitlogs, {state = "miss", 
            name = string.lower(shot_info.name),
            reason = shot.state,
            wanted_hitbox = hitgroup_text[shot.wanted_hitgroup],
            anim = 0,
            time = globals.realtime,
            clr_r = menu.logging_color_miss:get().r,
            clr_g = menu.logging_color_miss:get().g,
            clr_b = menu.logging_color_miss:get().b,
            clr_a = menu.logging_color_miss:get().a
        })     

    end 

    if menu.logging_types:get("Console") then
        if not shot.state then 
           
            print_raw(" ["..log_color(menu.logging_color:get()).."Elevrate.Codes\aFFFFFF] " .. "hit "..log_color(menu.logging_color:get())..string.lower(shot_info.name.." "..hitgroup_text[shot.hitgroup].." \aFFFFFFfor "..log_color(menu.logging_color:get())..shot_info.damage.."\aFFFFFF ("..log_color(menu.logging_color:get())..shot.wanted_damage.."\aFFFFFF) [remained "..log_color(menu.logging_color:get())..shot.target.m_iHealth.."\aFFFFFF hp | bt: "..log_color(menu.logging_color:get())..shot_info.backtrack.."\aFFFFFF | ang: "..log_color(menu.logging_color:get()).. round(shot.target.m_flPoseParameter[11] * 120 - 60, 2) .."\aFFFFFF | hc "..log_color(menu.logging_color:get())..shot.hitchance.."\aFFFFFF%] "))

        else

            print_raw(" ["..log_color(menu.logging_color_miss:get()).."Elevrate.Codes\aFFFFFF] ".."missed "..string.lower( log_color(menu.logging_color_miss:get()).. shot_info.name .. " ".. hitgroup_text[shot.wanted_hitgroup].. "\aFFFFFF due to "..log_color(menu.logging_color_miss:get())..shot.state.."\aFFFFFF ("..log_color(menu.logging_color_miss:get())..shot.wanted_damage.."\aFFFFFF) [bt: "..log_color(menu.logging_color_miss:get())..shot_info.backtrack.."\aFFFFFF | ang: "..log_color(menu.logging_color_miss:get()).. round(shot.target.m_flPoseParameter[11] * 120 - 60, 2) .."\aFFFFFF | hc "..log_color(menu.logging_color_miss:get())..shot.hitchance.."\aFFFFFF%]"))

        end
    end

end)

visuals.hitlogs = function()

    if not menu.logging:get() then 
        return 
    end

    local screen = {
        x = render.screen_size().x / 2,
        y = render.screen_size().y / (menu.logging_position:get() / 10),
    }

    add_y = 0
    
    for i, hitlog in ipairs(hitlogs) do

        local text_size = {

            hit = render.measure_text(1, nil, " Hit "),
            name = render.measure_text(1, nil, hitlog.name),
            inthe = render.measure_text(1, nil, " "),
            hitbox = render.measure_text(1, nil, hitlog.hitbox),
            forr = render.measure_text(1, nil, " for "),
            damage = render.measure_text(1, nil, hitlog.damage),
            fs = render.measure_text(1, nil, " ("),
            wanted_dmg = render.measure_text(1, nil, hitlog.wanted_dmg),
            ss = render.measure_text(1, nil, ") bt: "),
            bt = render.measure_text(1, nil, hitlog.bt),

            missed_in = render.measure_text(1, nil, " Missed "),
            space = render.measure_text(1, nil, " "),
            wanted_hitbox = render.measure_text(1, nil, hitlog.wanted_hitbox),
            reason_t = render.measure_text(1, nil, " due to "),
            reason = render.measure_text(1, nil, hitlog.reason),

        }

        if hitlog.state == "shot" then

            text_size.log_size = render.measure_text(1, nil, " Hit " .. hitlog.name .. " ".. hitlog.hitbox .. " for " .. hitlog.damage .. " (" .. hitlog.wanted_dmg .. ") bt: " .. hitlog.bt.." ")

        elseif hitlog.state == "miss" then

            text_size.log_size = render.measure_text(1, nil, " Missed " .. hitlog.name .. " " .. hitlog.wanted_hitbox .. " due to ".. hitlog.reason.." ")

        end

        if menu.logging_types:get("Screen") then

            if hitlog.time + 2 > globals.realtime then
                hitlog.anim = lerp(hitlog.anim, 1, 12 * globals.frametime)
            end

            add_x = 0
            add_x2 = 0
            add_y = add_y + (render.screen_size().y / 40)*hitlog.anim

            if hitlog.state == "shot" then

                render.shadow(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector(( screen.x + text_size.log_size.x / 2 ) + 4, screen.y + text_size.log_size.y + 3 - add_y), color(hitlog.clr_r, hitlog.clr_g, hitlog.clr_b, hitlog.clr_a*hitlog.anim), 30)
                render.rect(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector((( screen.x + text_size.log_size.x / 2 ) + 4) , screen.y + text_size.log_size.y + 3 - add_y), color(24, 24, 24, 180*hitlog.anim))
                render.rect(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector((( screen.x + text_size.log_size.x / 2 ) + 4) , screen.y - 3 - add_y), color(hitlog.clr_r, hitlog.clr_g, hitlog.clr_b, hitlog.clr_a*hitlog.anim)) 

                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " Hit ")
                add_x = add_x + text_size.hit.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(menu.logging_color:get().r, menu.logging_color:get().g, menu.logging_color:get().b, 255*hitlog.anim), nil, hitlog.name)
                add_x = add_x + text_size.name.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " ")
                add_x = add_x + text_size.inthe.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(menu.logging_color:get().r, menu.logging_color:get().g, menu.logging_color:get().b, 255*hitlog.anim), nil, hitlog.hitbox)
                add_x = add_x + text_size.hitbox.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " for ")
                add_x = add_x + text_size.forr.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(menu.logging_color:get().r, menu.logging_color:get().g, menu.logging_color:get().b, 255*hitlog.anim), nil, hitlog.damage)
                add_x = add_x + text_size.damage.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " (")
                add_x = add_x + text_size.fs.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(menu.logging_color:get().r, menu.logging_color:get().g, menu.logging_color:get().b, 255*hitlog.anim), nil, hitlog.wanted_dmg)
                add_x = add_x + text_size.wanted_dmg.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, ") bt: ")
                add_x = add_x + text_size.ss.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x, screen.y - add_y), color(menu.logging_color:get().r, menu.logging_color:get().g, menu.logging_color:get().b, 255*hitlog.anim), nil, hitlog.bt.." ")

            elseif hitlog.state == "miss" then

                render.shadow(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector(( screen.x + text_size.log_size.x / 2 ) + 4, screen.y + text_size.log_size.y + 3 - add_y), color(hitlog.clr_r, hitlog.clr_g, hitlog.clr_b, hitlog.clr_a*hitlog.anim), 30)
                render.rect(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector(( screen.x + text_size.log_size.x / 2 ) + 4, screen.y + text_size.log_size.y + 3 - add_y), color(24, 24, 24, 180*hitlog.anim))
                render.rect(vector(( screen.x - text_size.log_size.x / 2 ) - 4, screen.y - 3 - add_y), vector(( screen.x + text_size.log_size.x / 2 ) + 4, screen.y - 3 - add_y), color(hitlog.clr_r, hitlog.clr_g, hitlog.clr_b, hitlog.clr_a*hitlog.anim)) 

                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " Missed ")
                add_x2 = add_x2 + text_size.missed_in.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(menu.logging_color_miss:get().r, menu.logging_color_miss:get().g, menu.logging_color_miss:get().b, 255*hitlog.anim), nil, hitlog.name)
                add_x2 = add_x2 + text_size.name.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " ")
                add_x2 = add_x2 + text_size.space.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(menu.logging_color_miss:get().r, menu.logging_color_miss:get().g, menu.logging_color_miss:get().b, 255*hitlog.anim), nil, hitlog.wanted_hitbox)
                add_x2 = add_x2 + text_size.wanted_hitbox.x              
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(255, 255, 255, 255*hitlog.anim), nil, " due to ")
                add_x2 = add_x2 + text_size.reason_t.x
                render.text(1, vector( screen.x - text_size.log_size.x / 2 + add_x2, screen.y - add_y), color(menu.logging_color_miss:get().r, menu.logging_color_miss:get().g, menu.logging_color_miss:get().b, 255*hitlog.anim), nil, hitlog.reason.." ")

            end

            if hitlog.time + 4 < globals.realtime then 
                hitlog.anim = lerp(hitlog.anim, 0, 6 * globals.frametime)
            end

            if hitlog.time + 4 < globals.realtime then 
                hitlog.anim_2 = lerp(hitlog.anim, 0, 6 * globals.frametime)
            end

            if hitlog.anim < 0.01 and (hitlog.time + 3 < globals.realtime) or #hitlogs > 5 then
                table.remove(hitlogs, i)
            end

        end

    end


end

c4_info.reset = function()
    c4_info.planting = false
    c4_info.fill = 0
    c4_info.on_plant_time = 0
    c4_info.planting_site = ""
end

c4_info.bomb_beginplant = function(e)
    local player_resource = entity.get_player_resource()

    if player_resource == nil then
        return
    end

    c4_info.on_plant_time = globals.curtime
    c4_info.planting = true

    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB
    
    local userid = entity.get(e.userid, true)
    local userid_origin = userid:get_origin()
    local dist_to_a = userid_origin:dist(m_bombsiteCenterA)
    local dist_to_b = userid_origin:dist(m_bombsiteCenterB)
    
    c4_info.planting_site = dist_to_a < dist_to_b and "Bombsite A" or "Bombsite B"
end

function aim_ack_no_chole(e)

    table.insert(hitmarker1, {vector = e.aim, time = globals.realtime, alpha = 0})

end

local animations = {}

animations.color_lerp = function(start, end_pos, time)
    local frametime = globals.frametime * 100
    time = time * math.min(frametime, animations.max_lerp_low_fps)
    return start:lerp(end_pos, time)
end

animations.max_lerp_low_fps = (1 / 45) * 100

animations.lerp = function(start, end_pos, time)
    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * frametime

    local val = start + (end_pos - start) * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

animations.base_speed = 0.095
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed
    
    local is_color = type(new_value) == "userdata"

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or (is_color and colors.white or 0)
    end

    local interp_func

    if is_color then
        interp_func = animations.color_lerp
    else
        interp_func = animations.lerp
    end

    animations._list[name] = interp_func(animations._list[name], new_value, speed)
    
    return animations._list[name]
end

visuals.get_grenade = function()
    local player = entity.get_local_player()
    
    if player == nil then
        return
    end

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

            if m_hOwnerEntity ~= nil and is_not_friendly_fire and m_hOwnerEntity ~= player and not m_hOwnerEntity:is_enemy() then
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

visuals.grenade_radius = function()

    if not menu.greande_radius:get() then 
        return
    end 

    local grenade = visuals.get_grenade()
    
    if grenade == nil then
        return
    end

    local molotov_color = menu.enemy_molotov_color
    local smoke_color = menu.smoke_color

    local anim = {}

    local molotov_alpha = molotov_color:get().a / 255

    anim.molotov_radius = {}
    if true then
        for i = 1, #grenade.molotov do
            local v = grenade.molotov[i]
            anim.molotov_radius[i] = animations.new("molotov_radius_" .. i, v.draw and v.radius or 0, 0.095)
            if v.draw then
                render.circle_3d(v.position, molotov_color:get(), anim.molotov_radius[i], 0, 1, 1.5)
                render.circle_3d_outline(v.position, molotov_color:get(), anim.molotov_radius[i], 0, 1, 1.5)
                render.text(2, render.world_to_screen(v.position), (v.teammate and color(149, 184, 6, 255) or molotov_color:get()), nil, v.teammate and "TEAM" or "DANGER")
            end
        end
    end

    anim.smoke_radius = {}
    if true then
        for i = 1, #grenade.smoke do
            local v = grenade.smoke[i]
            anim.smoke_radius[i] = animations.new("smoke_radius_" .. i, v.draw and 125 or 0, 0.095)

            if v.draw then
                render.circle_3d(v.position, smoke_color:get(), anim.smoke_radius[i], 0, 1, 1.5)
                render.circle_3d_outline(v.position, smoke_color:get(), anim.smoke_radius[i], 0, 1, 1.5)
            end
        end
    end
end

visuals.custom_hitmarker = function()

    if not menu.hitmarker:get() then 
        return 
    end

    local player = entity.get_local_player()

    if not player then 
        return 
    end

    if not player:is_alive() then 
        return 
    end

    ui.find("Visuals", "World", "Other", "Hit Marker", "3D Marker"):override(false)

    local marker = {
        font = menu.hitmarker_font:get(),
        type = menu.hitmarker_type:get(),
        text = menu.hitmarker_text:get()
    }

    for i, hit_info in ipairs(hitmarker1) do

        if (globals.realtime - hit_info.time < 1) then

            hit_info.alpha = hitmarker_animation(true, hit_info.alpha, 255, 0.05)

        elseif (globals.realtime - hit_info.time > 3) then

            hit_info.alpha = hitmarker_animation(false, hit_info.alpha, 255, 0.05)

            if (hit_info.alpha == 0) then
                table.remove(hitmarker1, i)
            end

        end

        render.text(marker.font, render.world_to_screen(hit_info.vector), color(menu.hitmarker_color:get().r, menu.hitmarker_color:get().g, menu.hitmarker_color:get().b, hit_info.alpha), "c", marker.type == "Icon" and ui.get_icon(""..marker.text.."") or marker.text)
    end
    

end

ragebot.teleport_inair = function(cmd)

    if not menu.auto_teleport:get() then 
        return 
    end

    local player = entity.get_local_player()

    if not player then
        return
    end
    
    if not player:is_alive() then
        return 
    end

    local teleport = {
        need_tp = false
    }

    local selected = player:get_player_weapon()

    local weapon = selected:get_classname()

    if string.match(weapon, "Grenade") then
        return
    end
    
    local try_hit = function(entity)

        local damage, trace = utils.trace_bullet(entity, entity:get_hitbox_position(3), player:get_hitbox_position(3))
  
        if damage ~= 0 then

            if damage > 0 and ((trace.entity and trace.entity == player) or false) then

                return true

            end

        end
  
        return false
        
    end

    for _, get_players in pairs(entity.get_players(true)) do

        if get_players == player then 
            goto skip 
        end

        if try_hit(get_players) then
            teleport.need_tp = true            
        end

        ::skip::

    end

    if teleport.need_tp and (antiaim.player_state == antiaim.state.air_duck or antiaim.player_state == antiaim.state.air) then

        cmd.force_defensive = true

        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"):override(math.random(10))

        if rage.exploit:get() == 1 then

            rage.exploit:force_teleport()

        end

        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"):override(math.random(5))

        if globals.tickcount % menu.auto_teleport_delay:get() == menu.auto_teleport_delay:get() - 1 then

            if menu.auto_teleport_force_recharge:get() then
                rage.exploit:force_charge()
            end

        end

    else
        
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"):override(nil)

    end


end

ragebot.air_mode = function()

    if not menu.air_mode:get() then 
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if not player:is_alive() then
        return 
    end

    local weapons = {
        scout = menu.air_mode_scout:get(),
        awp = menu.air_mode_awp:get(),
        auto = menu.air_mode_auto:get(),
        r8 = menu.air_mode_r8:get(),
        deagle = menu.air_mode_deagle:get()
    }

    local state = antiaim.player_state

    if state == antiaim.state.air or state == antiaim.state.air_duck then

        ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"):override(weapons.scout)
        ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"):override(weapons.awp)
        ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"):override(weapons.auto)
        ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"):override(weapons.r8)
        ui.find("Aimbot", "Ragebot", "Selection", "Desert Eagle", "Hit Chance"):override(weapons.deagle)

    else

        ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "Desert Eagle", "Hit Chance"):override(nil)

    end

end

ragebot.no_scope_mode = function()

    if not menu.no_scope_mode:get() then 
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if not player:is_alive() then
        return 
    end

    local weapons = {
        scout = menu.no_scope_mode_scout:get(),
        awp = menu.no_scope_mode_awp:get(),
        auto = menu.no_scope_mode_auto:get()
    }

    local scope = player.m_bIsScoped

    if not scope then

        ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"):override(weapons.scout)
        ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"):override(weapons.awp)
        ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"):override(weapons.auto)

    else

        ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"):override(nil)
        ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"):override(nil)

    end

end

ragebot.off_stafe = false
ragebot.super_toss = function(cmd) 

    local player = entity.get_local_player()

    if not player then
        return
    end
    
    if not player:is_alive() then
        return 
    end

    local selected = player:get_player_weapon()

    local weapon = selected:get_classname()

    if weapon == nil then
        return
    end

    math_velocity = math.sqrt(player.m_vecVelocity.x ^ 2 + player.m_vecVelocity.y ^ 2)
  
    if string.match(weapon, "Grenade") then

        if not menu.super_toss:get() then
            return
        end

        ragebot.off_stafe = false

        refs.airstrafe:set(math_velocity >= 5)  

        if cmd.in_attack then
            cmd.forwardmove = 0
            cmd.sidemove = 0
        end 

    elseif string.match(weapon, "SSG-08") then

        if not menu.jump_scout:get() then
            return
        end

        ragebot.off_stafe = false

        refs.airstrafe:set(math_velocity >= 5)  

        if cmd.in_attack then
            cmd.forwardmove = 0
            cmd.sidemove = 0
        end  

    else

        ragebot.off_stafe = true

    end

    if ragebot.off_stafe == true then
        refs.airstrafe:set(true)
    end
 
end

events.shutdown:set(function()
    if menu.super_toss:get() then
        refs.airstrafe:set(true)
    end

    if menu.jump_scout:get() then
        refs.airstrafe:set(true)
    end
end)

ragebot.nade_throw_fix = function(cmd)

    if not menu.nade_throw_fix:get() then 
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end
    
    if not player:is_alive() then
        return 
    end

    local selected = player:get_player_weapon()

    if selected == nil then 
        return 
    end

    local weapon = selected:get_classname()

    local throw = selected.m_fThrowTime

    if (throw ~= nil and throw ~= 0) then

        rage.exploit:allow_defensive(false)

    else

        if cmd.in_attack then

            if string.match(weapon, "Grenade") then

                rage.exploit:allow_defensive(false)

            end

        end

    end

end

misc.auto_mute = function()

    if not menu.auto_mute:get() then 
        return 
    end

    local m_type = menu.auto_mute_type:get()

    local players = entity.get_players(nil, true, function(player)

        local information = player:get_player_info()
        local get_mute = panorama.FriendsListAPI.IsSelectedPlayerMuted(information.steamid64)

        if m_type == "Unmute" and get_mute then 

            panorama.FriendsListAPI.ToggleMute(information.steamid64)

        elseif m_type == "Mute" and not get_mute then 

            panorama.FriendsListAPI.ToggleMute(information.steamid64) 

        end
    end)
end

local notify = {

    handle = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")) + 2)[0])[0] + 2),

    find_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")),

    get_window = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")) + 2)[0])[0],

    gameoverlayrenderer = ffi.cast("int(__thiscall*)(uintptr_t)", utils.opcode_scan("gameoverlayrenderer.dll", "FF E1"))

}

misc.get_procces_handle = function() 
    return notify.handle[0] 
end

misc.game_overlay = function() 
    return notify.gameoverlayrenderer(notify.get_window) 
end

misc.taskbar_notify = function()

    local handle = misc.get_procces_handle()

    if menu.round_start_notify:get() and misc.game_overlay() ~= handle then 
        notify.find_window(handle, 1) 
    end
end

misc.viewmodel = function()
    if menu.custom_viewmodel:get() then
        cvar.viewmodel_fov:float(menu.custom_viewmodel_fov:get(), true)
        cvar.viewmodel_offset_x:float(menu.custom_viewmodel_x:get() / 1, true)
        cvar.viewmodel_offset_y:float(menu.custom_viewmodel_y:get() / 1, true)
        cvar.viewmodel_offset_z:float(menu.custom_viewmodel_z:get() / 1, true)
    else
        cvar.viewmodel_fov:float(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-5)
    end
end

misc.aspect_ratio = function()
    local aspect_value = menu.aspect_ratio_value:get() / 10

    if not menu.aspect_ratio:get() then
        aspect_value = 0
    end

    if aspect_value ~= cvar.r_aspectratio.float(cvar.r_aspectratio) then
        cvar.r_aspectratio.float(cvar.r_aspectratio, aspect_value)
    end
end

local one_kill_phrases = {
    [1] = {"ты чо жирдяй на кого лезешь нищита ебанная"},
    [2] = {"Я же твоей матери шлюхе говорил, что сын пидарас, замуваться не может"},
    [3] = {"ты снова кста бабки на пасту проебал и тут же упал"},
    [4] = {"ты первее мамки на колени упал, 1"},
    [5] = {"научи меня так же муваться"},
    [6] = {"АЛО ХОХЛОДРОН ТЕ КАК ТАМ ЖИВЕТСЯ?"},
    [7] = {"say I kissed your mom last night"},
    [8] = {"отец твой чурка, я увидел ахуел"},
    [9] = {"планы на кд строим?? HHH"},
    [10] = {"freeqn.net/refund.php"},
    [11] = {"ТЫ ЧО С ЛУАСЕНСОМ ИГРАЕШЬ? ЗАХВПЗХЪАПРАПХЪРЗАПЗХР"},
    [12] = {"kd rate is good HHHHH"},
    [13] = {"снюс под губу, анти попадайки на On, распрыжочку на фулл и полетели ебашить твою мать"},
    [14] = {"на ротан маман?"},
    [15] = {"хорошо поговорил, больше не говори"},
    [16] = {"ЧОТ НЛЧЕК ТЯ НЕ БУСТИТ ДОЛБАЕБА "},
    [17] = {"ты куда исчез?"},
    [18] = {"уно, дос, трез - твоей матери пиздец"},
    [19] = {"че случилось?))"},
    [20] = {"ну и читуха у тебя"},
    [21] = {"у меня так глаза болят твой *DEAD* видеть ((("},
    [22] = {"Ｓｔａｙ ｗｉｔｈ Ｅｌｅｖｒａｔｅ.ｃｏｄｅｓ"},
    [23] = {"I'ᗰ ᑎOT SᑌᖇᑭᖇISEᗪ TᕼᗩT YOᑌ'ᖇE ᒪOSIᑎG - YOᑌ ᗪOᑎ'T ᕼᗩᐯE EᒪEᐯᖇᗩTE.ᑕOᗪES"},
    [24] = {"ᏔǶ𐌙 𐌃𐌏 𐌙𐌏𐌵 𐌄ᕓ𐌄𐌍 𐌓𐌋𐌀𐌙 Ꮤ𐌉𐌕Ƕ𐌏𐌵𐌕 𐌄𐌋𐌄ᕓ𐌐𐌀𐌕𐌄.𐌂𐌏𐌃𐌄𐌔?"},
    [25] = {"я бы советовал тебе у меня в ногах посидеть, ты все равно не вылезешь без Elevrate.Codes"},
    [26] = {"Ｈｖｈ ｄｏｇｓ ｆｏｒ ｓｏｍｅ ｒｅａｓｏｎ ａｌｗａｙｓ ｆｕｃｋ ｗｉｔｈ Ｅｌｅｖｒａｔｅ.ｌｕａ"},
    [27] = {"G E T G O O D G E T E L E V R A T E"},
    [28] = {"Получай удовольствие вместе с Elevrate.codes"},
    [29] = {"Смотрю на неё и у меня глаза сияют...Elevrate..."}
}

local double_kill_phrases = {
    [1] = {"Каждая шлюха девушка", "но не каждый пендос пидарас"},
    [2] = {"А КОГДА НЕ УБИВАЛИ?", "ВСЕГДА УБИВАЛИ"},
    [3] = {"випикс кодинг корпарейшн?", "хъыапзхываъпзваъхп"},
    [4] = {"знаешь..В жизни много огорчений", "но всё это может погасить Elevrate.Codes"},
    [5] = {"Я порой смотрю на HVH коммунити в 23 и вахуе", "как же Elevrate вынесла все пасты"},
    [6] = {"Мне не нужны шлюхи на столе", "как минимум из-за Elevrate.codes"},
    [7] = {"𝘛𝘩𝘪𝘴 𝘥𝘰𝘨 𝘪𝘴 𝘱𝘭𝘢𝘺𝘪𝘯𝘨 𝘸𝘪𝘵𝘩 𝘉𝘶𝘳𝘨𝘦𝘳𝘚𝘦𝘯𝘴𝘦�", "𝘺𝘰𝘶 𝘤𝘰𝘯𝘴𝘪𝘥𝘦𝘳 𝘩𝘪𝘮 𝘢 𝘱𝘭𝘢𝘺𝘦𝘳 𝘣𝘺 𝘮𝘢𝘵𝘤𝘩𝘪𝘯𝘨 𝘸𝘪𝘵𝘩 𝘌𝘭𝘦𝘷𝘳𝘢𝘵𝘦.𝘤𝘰𝘥𝘦𝘴"}
}

local triple_kill_phrases = {
    [1] = {"че ты упал пидарас", "я же говорил тебе что у тебя шансов нет", "уебище тупое"}, 
    [2] = {"жирдяй", "ты снова упал", "долбаеб тупой"},
    [3] = {"мне похуй", "вчера твоей матери член заебашил", "ты от нее не отличаешься младенец"},
    [4] = {"АХПВЩЗАПХВППХЪВАЪПЗР", "ПЗХЪВАХРЗВАПЪР", "ТЫ ЧО ЖИРНЫЙ В *DEAD* СНОВА ЗАСЕЛ"},
    [5] = {"где твоя мать? где твои родные?", "АХЪЗВПХЪВЗАПРЪВПР ТОЧНО", "они же так же съебались с тебя как твой брейн"},
    [6] = {"ливай с сервера", "или нахуй твою коморку подорву", "кишки на фанарях висеть будут"},
    [7] = {"слышь ты", "хуйня", "пока пизду не разорвал ливни"},
    [8] = {"ЭЙ ЕБАТЬ АЛО", "ПРОДАМ МАТЬ МЕРТВОГО ПИДАРАСА", "+75561238865"},
    [9] = {"ХЪАВПЗВАХЪПРЗЪВАПР", "ПИЗДАНИ МНЕ ЧТО НИТЬ С ДЕДА", "Я ВАХУЕ БУДУ ЗХЪПАЫЗХПЪВАП"},
    [10] = {"АХПАПХЪВАПРЗХ", "Порой я так ахуеваю", "С твоих мувов"},
    [11] = {"ПИЗДАНИ МНЕ ЧТО ТО", "ЕСЛИ МАТЬ НЕ ДУРА", "ПОРЖЕМ НАД ТОБОЙ ПИДАРАСОМ"},
    [12] = {"когда ко мне зашла мать и увидела, что я с чимерой играю", "чуть не убила", "но я сразу же инжектнул Elevrate.Codes"},
    [13] = {"Бля, в какой же я разъеб ухожу под Elevrate.Codes", "мои нервные клетки бекнулись", "да и мать за чимеру уже не пиздит"}
}

local death_phases = {
    [1] = {"зхъпзъап", "ты чо сделал", "ты как меня убил"},
    [2] = {"как же меня ", "твои мувы блядские", "вымораживают"},
    [3] = {"ЕЩЕ 1 ТАКОЙ МУВ", "ПИДАРАСИНА","МАТЕРИ ЛИШИШЬСЯ"},
    [4] = {"Пиздец тебе", "свинья немытая", "!admin"},
    [5] = {"НУ ТЫ ПОСМОТРИ", "ЧТО ОНО ДЕЛАЕТ", "ТЫ СЕБЯ ИГРОКОМ СЧИТАЕШЬ?"},
    [6] = {"ХУЖЕ ТЕБЯ ИГРОКА", "Я никогда не видел", "ливай пока не поздно нах"},
    [7] = {"жирный", "ты что сделал", "не играй больше хвх"},
    [8] = {"БЛЯТЬ КАК ТЫ МЕНЯ БЕСИШЬ ПИДАРАС", "К МАМЕ ПОДОЙДИ", "И В ЕБАЛО ЕЙ ХАРКНИ"},
    [9] = {"бля ну так то да", "не всегда я должен тебя ебать", "ты же вылетишь как тупая обезьяна"},
    [10] = {"БАРЕБУХ", "ТЫ РЕАЛЬНО?", "ТЫ СЕБЯ ПОСЛЕ ЭТОГО ИГРОКОМ СЧИТАЕШЬ?"},
    [11] = {"лан мне похуй на тебя", "и на твою семью", "живи"},
    [12] = {"...", "я вахуе", "чит обосрался"},
    [13] = {"бля...", "я хуже мува в жизни не видел", "пидарас"},
    [14] = {"дал шанс - пользуйся", "все равно в некст раунде", "я тебе отпиздошу"},
}

local currentphrase = ""
local can_talk = true
local trash_talk_type_end = nil

misc.say_trash_talk = function(args)

    can_talk = false

    local phrases 

    if trash_talk_type_end == one_kill_phrases then
        phrases = 1
    elseif trash_talk_type_end == double_kill_phrases then
        phrases = 2
    elseif trash_talk_type_end == triple_kill_phrases then
        phrases = 3
    else 
        phrases = 3
    end


    if can_talk == false then

        currentphrase = args

        for i = 1, #currentphrase do

            utils.execute_after(phrases * i, function()

                if currentphrase[i] == nil then
                    return
                end

                utils.console_exec('say "' .. currentphrase[i]:gsub('\"', '') .. '"')

            end)

        end

        utils.execute_after(1, function()
            can_talk = true 
        end)

    end

    trash_talk_type_end = nil

end

events.player_death:set(function(e)

    if not menu.trashtalk:get() then 
        return
    end

    if can_talk == false then 
        return
    end

    local userid = entity.get(e.userid,true)
    local killer = entity.get(e.attacker,true)
    local player = entity.get_local_player()
    
    if menu.trashtalk_states:get("On Kill") then

        if userid:is_bot() then
            return
        end

        if userid ~= killer and killer == player then

            if can_talk == true then

                local trash_talk_type = math.random(1, 3)

                if trash_talk_type == 1 then
                    trash_talk_type_end = one_kill_phrases
                elseif trash_talk_type == 2 then
                    trash_talk_type_end = double_kill_phrases
                elseif trash_talk_type == 3 then 
                    trash_talk_type_end = triple_kill_phrases
                end

                misc.say_trash_talk(trash_talk_type_end[math.random(1, #trash_talk_type_end)])
            end

        end

    end

    if menu.trashtalk_states:get("On Death") then

        if userid == player and player ~= killer then

            if can_talk == true then
                trash_talk_type_end = death_phases
                misc.say_trash_talk(death_phases[math.random(1, #death_phases)])
            end

        end

    end


end)

ragebot.text_line = function(str, dst, location, origin, yaw, clr)

    location = vector(location.x + math.cos(math.rad(yaw))*dst, location.y + math.sin(math.rad(yaw))*dst, location.z)

	local world = render.world_to_screen(location)

    if world == nil then return end

    render.line(origin, world, clr)
    render.text(2, world - vector(5, 5), clr, nil, str)

end

ragebot.player_angles = function()

    if not menu.local_player_angles:get() then
        return
    end

    local player = entity.get_local_player()

    if not player then
        return
    end

    if not player:is_alive() then
        return 
    end

    if not common.is_in_thirdperson() then
        return
    end

    local angles = {

        fake = player.m_angEyeAngles.y,
        real = rage.antiaim:get_rotation() + player.m_flPoseParameter[11] * 120 - 60

    }

    local player_pos = player:get_origin()

	player_pos.z = player_pos.z + 1

    local world = render.world_to_screen(player_pos)

    ragebot.text_line("-FAKE-", 30, player_pos, world, angles.fake, menu.local_player_angles_fake:get())
    ragebot.text_line("-REAL-", 30, player_pos, world, angles.real, menu.local_player_angles_real:get())
  
end

local clan_tag =  {

    "e",
    "el",
    "ele",
    "elev",
    "elevr",
    "elevra",
    "elevrat",
    "elevrate",
    "levrate",
    "evrate",
    "vrate",
    "rate",
    "ate",
    "te",
    "e",
    " "

}

misc.get_clantag = function()

    if utils.net_channel() == nil then 
        return
    end

    local set_tag = math.floor(math.fmod((globals.tickcount + (utils.net_channel().latency[0] / globals.tickinterval)) / 16, #clan_tag + 1) + 1)

    return clan_tag[set_tag]

end

misc.tag = nil
misc.clan_tag = function()

    local clan_tag = misc.get_clantag()

    if clan_tag == misc.tag then 
        return 
    end

    if clan_tag == nil then 
        return 
    end

    if menu.clantag:get() then
        common.set_clan_tag(clan_tag)
    else
        common.set_clan_tag(" ")
    end

    misc.tag = clan_tag

end

events.bomb_abortplant:set(function()
    c4_info.reset()
end)
events.bomb_defused:set(function()
    c4_info.reset()
end)
events.bomb_planted:set(function()
    c4_info.reset()
end)
events.round_prestart:set(function()
    c4_info.reset()
end)
events.bomb_beginplant:set(function(e)
    c4_info.bomb_beginplant(e)
end)

events.aim_ack:set(aim_ack_no_chole)

events.createmove:set(function(cmd)

    ragebot.nade_throw_fix(cmd)
    ragebot.super_toss(cmd)
    ragebot.no_scope_mode()
    ragebot.air_mode()
    ragebot.teleport_inair(cmd)

    antiaim.main(cmd)
    antiaim.anim_update()

    misc.viewmodel()
    misc.auto_mute()
    misc.taskbar_notify()

    if menu.animation_breakers:get() and menu.move_lean:get() then
        cmd.animate_move_lean = true
    else
        cmd.animate_move_lean = false
    end

end)

events.render:set(function()

    ragebot.player_angles()

    antiaim.visible()
    antiaim.menu_manager()

    visuals.crosshair_indication()
    visuals.kibit_damage()
    visuals.custom_scope()
    visuals.skeet_indication()
    visuals.hitlogs()
    visuals.custom_hitmarker()
    visuals.grenade_radius()
    
    misc.aspect_ratio()
    misc.clan_tag()

    watermark:update()
    velocity_indicator:update()

end)


local config = {

    elements = {

        menu.nade_throw_fix   ,      
        menu.auto_teleport ,
        menu.auto_teleport_delay ,
        menu.auto_teleport_force_recharge   ,      
        menu.round_start_notify   ,   
        menu.super_toss ,
        menu.jump_scout  ,     
        menu.local_player_angles    ,   
        menu.no_scope_mode ,
        menu.no_scope_mode_scout ,
        menu.no_scope_mode_awp ,
        menu.no_scope_mode_auto  ,       
        menu.air_mode ,
        menu.air_mode_scout ,
        menu.air_mode_awp ,
        menu.air_mode_auto ,
        menu.air_mode_r8 ,
        menu.air_mode_deagle   ,     
        menu.debug_panel      ,  
        menu.debug_panel_x,
        menu.debug_panel_y,
        menu.velocity_indication,
        menu.velocity_x,
        menu.velocity_y,
        menu.crosshair_indication    ,     
        menu.indication500   ,     
        menu.kibit_min_damage   ,     
        menu.custom_scope ,
        menu.custom_scope_gap ,
        menu.custom_scope_size ,     
        menu.hitmarker,
        menu.hitmarker_font ,
        menu.hitmarker_type ,
        menu.hitmarker_text  ,       
        menu.greande_radius  ,      
        menu.logging,
        menu.logging_types ,
        menu.logging_position,
        menu.auto_mute ,
        menu.auto_mute_type ,
        menu.aspect_ratio ,
        menu.aspect_ratio_value   ,  
        menu.custom_viewmodel ,
        menu.custom_viewmodel_fov ,
        menu.custom_viewmodel_x ,
        menu.custom_viewmodel_y ,
        menu.custom_viewmodel_z  ,
        menu.trashtalk ,
        menu.trashtalk_states  ,
        menu.clantag
        
    },

    colors = {
        menu.logging_color ,
        menu.logging_color_miss ,
        menu.enemy_molotov_color ,
        menu.smoke_color ,
        menu.hitmarker_color ,
        menu.custom_scope_color ,
        menu.kibit_min_damage_color ,
        menu.crosshair_indication_main_color ,
        menu.crosshair_indication_addative_color,
        menu.debug_panel_glow_color ,
        menu.local_player_angles_fake ,
        menu.local_player_angles_real ,
        menu.velocity_indication_color,
    },

    aa = {

        menu.yaw_base,
        menu.animation_breakers,
        menu.air_legs,
        menu.ground_legs,
        menu.move_lean,
        menu.move_lean_effect,
        menu.pitch_null,
        menu.sliding_slow_walk,
        menu.freestanding,
        menu.freestanding_dym,
        menu.freestanding_bf,
        menu.antibruteforce,
        menu.antibruteforce_modifiers,
        menu.antiaim_tweaks,
        menu.desync_swither,

        antiaim[0].pitch, 
        antiaim[0].swap_delay,
        antiaim[0].swap_delay_ticks,
        antiaim[0].player_side ,   
        antiaim[0].yaw_left ,
        antiaim[0].yaw_offset_left ,
        antiaim[0].yaw_modifier_left ,
        antiaim[0].yaw_modifier_left_offset ,
        antiaim[0].body_yaw_left ,
        antiaim[0].fake_limit_left ,
        antiaim[0].options_left ,
        antiaim[0].body_yaw_freestanding_left   ,
        antiaim[0].yaw_right ,
        antiaim[0].yaw_offset_right ,
        antiaim[0].yaw_modifier_right ,
        antiaim[0].yaw_modifier_right_offset ,
        antiaim[0].body_yaw_right ,
        antiaim[0].fake_limit_right ,
        antiaim[0].options_right ,
        antiaim[0].body_yaw_freestanding_right   ,
        antiaim[0].defensive ,
        antiaim[0].defensive_pitch_left ,
        antiaim[0].defensive_pitch_right ,
        antiaim[0].defensive_offset_left ,
        antiaim[0].defensive_offset_right  , 
        antiaim[0].fakelags,
        antiaim[0].fakelags_ticks,
        antiaim[0].fakelags_v,

        antiaim[1].pitch, 
        antiaim[1].swap_delay,
        antiaim[1].swap_delay_ticks,
        antiaim[1].player_side ,   
        antiaim[1].yaw_left ,
        antiaim[1].yaw_offset_left ,
        antiaim[1].yaw_modifier_left ,
        antiaim[1].yaw_modifier_left_offset ,
        antiaim[1].body_yaw_left ,
        antiaim[1].fake_limit_left ,
        antiaim[1].options_left ,
        antiaim[1].body_yaw_freestanding_left   ,
        antiaim[1].yaw_right ,
        antiaim[1].yaw_offset_right ,
        antiaim[1].yaw_modifier_right ,
        antiaim[1].yaw_modifier_right_offset ,
        antiaim[1].body_yaw_right ,
        antiaim[1].fake_limit_right ,
        antiaim[1].options_right ,
        antiaim[1].body_yaw_freestanding_right   ,
        antiaim[1].defensive ,
        antiaim[1].defensive_pitch_left ,
        antiaim[1].defensive_pitch_right ,
        antiaim[1].defensive_offset_left ,
        antiaim[1].defensive_offset_right  , 
        antiaim[1].fakelags,
        antiaim[1].fakelags_ticks,
        antiaim[1].fakelags_v,

        antiaim[2].pitch, 
        antiaim[2].swap_delay,
        antiaim[2].swap_delay_ticks,
        antiaim[2].player_side ,   
        antiaim[2].yaw_left ,
        antiaim[2].yaw_offset_left ,
        antiaim[2].yaw_modifier_left ,
        antiaim[2].yaw_modifier_left_offset ,
        antiaim[2].body_yaw_left ,
        antiaim[2].fake_limit_left ,
        antiaim[2].options_left ,
        antiaim[2].body_yaw_freestanding_left   ,
        antiaim[2].yaw_right ,
        antiaim[2].yaw_offset_right ,
        antiaim[2].yaw_modifier_right ,
        antiaim[2].yaw_modifier_right_offset ,
        antiaim[2].body_yaw_right ,
        antiaim[2].fake_limit_right ,
        antiaim[2].options_right ,
        antiaim[2].body_yaw_freestanding_right   ,
        antiaim[2].defensive ,
        antiaim[2].defensive_pitch_left ,
        antiaim[2].defensive_pitch_right ,
        antiaim[2].defensive_offset_left ,
        antiaim[2].defensive_offset_right  , 
        antiaim[2].fakelags,
        antiaim[2].fakelags_ticks,
        antiaim[2].fakelags_v,

        antiaim[3].pitch, 
        antiaim[3].swap_delay,
        antiaim[3].swap_delay_ticks,
        antiaim[3].player_side ,   
        antiaim[3].yaw_left ,
        antiaim[3].yaw_offset_left ,
        antiaim[3].yaw_modifier_left ,
        antiaim[3].yaw_modifier_left_offset ,
        antiaim[3].body_yaw_left ,
        antiaim[3].fake_limit_left ,
        antiaim[3].options_left ,
        antiaim[3].body_yaw_freestanding_left   ,
        antiaim[3].yaw_right ,
        antiaim[3].yaw_offset_right ,
        antiaim[3].yaw_modifier_right ,
        antiaim[3].yaw_modifier_right_offset ,
        antiaim[3].body_yaw_right ,
        antiaim[3].fake_limit_right ,
        antiaim[3].options_right ,
        antiaim[3].body_yaw_freestanding_right   ,
        antiaim[3].defensive ,
        antiaim[3].defensive_pitch_left ,
        antiaim[3].defensive_pitch_right ,
        antiaim[3].defensive_offset_left ,
        antiaim[3].defensive_offset_right  , 
        antiaim[3].fakelags,
        antiaim[3].fakelags_ticks,
        antiaim[3].fakelags_v,

        antiaim[4].pitch, 
        antiaim[4].swap_delay,
        antiaim[4].swap_delay_ticks,
        antiaim[4].player_side ,   
        antiaim[4].yaw_left ,
        antiaim[4].yaw_offset_left ,
        antiaim[4].yaw_modifier_left ,
        antiaim[4].yaw_modifier_left_offset ,
        antiaim[4].body_yaw_left ,
        antiaim[4].fake_limit_left ,
        antiaim[4].options_left ,
        antiaim[4].body_yaw_freestanding_left   ,
        antiaim[4].yaw_right ,
        antiaim[4].yaw_offset_right ,
        antiaim[4].yaw_modifier_right ,
        antiaim[4].yaw_modifier_right_offset ,
        antiaim[4].body_yaw_right ,
        antiaim[4].fake_limit_right ,
        antiaim[4].options_right ,
        antiaim[4].body_yaw_freestanding_right   ,
        antiaim[4].defensive ,
        antiaim[4].defensive_pitch_left ,
        antiaim[4].defensive_pitch_right ,
        antiaim[4].defensive_offset_left ,
        antiaim[4].defensive_offset_right  , 
        antiaim[4].fakelags,
        antiaim[4].fakelags_ticks,
        antiaim[4].fakelags_v,

        antiaim[5].pitch, 
        antiaim[5].swap_delay,
        antiaim[5].swap_delay_ticks,
        antiaim[5].player_side ,   
        antiaim[5].yaw_left ,
        antiaim[5].yaw_offset_left ,
        antiaim[5].yaw_modifier_left ,
        antiaim[5].yaw_modifier_left_offset ,
        antiaim[5].body_yaw_left ,
        antiaim[5].fake_limit_left ,
        antiaim[5].options_left ,
        antiaim[5].body_yaw_freestanding_left   ,
        antiaim[5].yaw_right ,
        antiaim[5].yaw_offset_right ,
        antiaim[5].yaw_modifier_right ,
        antiaim[5].yaw_modifier_right_offset ,
        antiaim[5].body_yaw_right ,
        antiaim[5].fake_limit_right ,
        antiaim[5].options_right ,
        antiaim[5].body_yaw_freestanding_right   ,
        antiaim[5].defensive ,
        antiaim[5].defensive_pitch_left ,
        antiaim[5].defensive_pitch_right ,
        antiaim[5].defensive_offset_left ,
        antiaim[5].defensive_offset_right  , 
        antiaim[5].fakelags,
        antiaim[5].fakelags_ticks,
        antiaim[5].fakelags_v,

    }

}

files.default = "nl\\lua"
files.config_path = files.default .."\\configs.txt"
files.config_path2 = files.default .."\\configs2.txt"
files.config_path3 = files.default .."\\configs3.txt"

files.first_load = function()
    if files.read(files.config_path) == nil then
        files.create_folder(files.default)
        files.write(files.config_path, json.stringify(""))
    end

    if files.read(files.config_path2) == nil then
        files.create_folder(files.default)
        files.write(files.config_path2, json.stringify(""))
    end

    if files.read(files.config_path3) == nil then
        files.create_folder(files.default)
        files.write(files.config_path3, json.stringify(""))
    end
end

files.first_load()
menu.load_preset = tab.antihit.preset_manager:button(colors.main..icons.preset_load..colors.default.." Load", function()

    local ref = menu.config_list
    local save_path 

    if ref:get() == 1 then
        save_path = files.read(files.config_path)
    elseif ref:get() == 2 then
        save_path = files.read(files.config_path2)
    elseif ref:get() == 3 then
        save_path = files.read(files.config_path3)
    end

    local preset = json.parse(base64.decode(save_path))

    for class, get_value in pairs(preset) do

        class = ({[1] = "aa"})[class]

        for s_class, get_values in pairs(get_value) do

            if (class == "aa") then
                config[class][s_class]:set(get_values)
            end

        end

    end

    common.add_notify(vars.lua.name, "Preset succesfully loaded!")
    utils.console_exec("play ui\\beepclear")

end, true)

menu.save_preset = tab.antihit.preset_manager:button(colors.main..icons.preset_save..colors.default.." Save", function()

    local save = {{}}

    local ref = menu.config_list
    local save_path 

    if ref:get() == 1 then
        save_path = files.config_path
    elseif ref:get() == 2 then
        save_path = files.config_path2
    elseif ref:get() == 3 then
        save_path = files.config_path3
    end

    for _, aa in pairs(config.aa) do
        table.insert(save[1], aa:get())
    end

    files.write(save_path, base64.encode(json.stringify(save)))

    common.add_notify(vars.lua.name, "Preset succesfully saved!")
    utils.console_exec("play ui\\beepclear")


end, true)

menu.import_preset = tab.antihit.preset_manager:button(colors.main..icons.preset_import..colors.default.." Import", function()

    function import()

        local ref = menu.config_list
        local save_path 

        if ref:get() == 1 then
            save_path = files.config_path
        elseif ref:get() == 2 then
            save_path = files.config_path2
        elseif ref:get() == 3 then
            save_path = files.config_path3
        end

        some_config = json.parse(base64.decode(clipboard.get()))

        files.write(save_path, some_config)

    end

    import()

    function load()

        local ref = menu.config_list
        local save_path 

        if ref:get() == 1 then
            save_path = files.read(files.config_path)
        elseif ref:get() == 2 then
            save_path = files.read(files.config_path2)
        elseif ref:get() == 3 then
            save_path = files.read(files.config_path3)
        end

        local preset = json.parse(base64.decode(save_path))

        for class, get_value in pairs(preset) do

            class = ({[1] = "aa"})[class]

            for s_class, get_values in pairs(get_value) do

                if (class == "aa") then
                    config[class][s_class]:set(get_values)
                end

            end

        end

    end

    load()
        

    common.add_notify(vars.lua.name, "Preset succesfully imported!")
    utils.console_exec("play ui\\beepclear")

end, true)

menu.export_preset = tab.antihit.preset_manager:button(colors.main..icons.preset_export..colors.default.." Export", function() 

    local ref = menu.config_list
    local save_path 

    if ref:get() == 1 then
        save_path = files.config_path
    elseif ref:get() == 2 then
        save_path = files.config_path2
    elseif ref:get() == 3 then
        save_path = files.config_path3
    end

    local config = files.read(save_path)

    clipboard.set(base64.encode(json.stringify(config)))
    
    common.add_notify(vars.lua.name, "Preset succesfully exported!")
    utils.console_exec("play ui\\beepclear")

end, true)

menu.import_config = tab.home.config:button(colors.main..icons.preset_import..colors.default.." Import ", nil, true)

local importcfg = function(cfg)

    local import = function() 

        some_config = json.parse(base64.decode(cfg))   

        for ftype, value in pairs(some_config) do

            ftype = ({[1] = "elements", [2] = "colors", [3] = "aa"})[ftype]

            for ftype2, value2 in pairs(value) do
                if (ftype == "elements") then
                    config[ftype][ftype2]:set(value2)
                end
                
                if (ftype == "colors") then
                    config[ftype][ftype2]:set(color(unpack(value2)))
                end

                if (ftype == "aa") then
                    config[ftype][ftype2]:set(value2)
                end
            end
        end

        drag_system.on_config_load()
        common.add_notify(vars.lua.name, "Config succesfully imported!")
        utils.console_exec("play ui\\beepclear")

    end

    if not pcall(import) then
        common.add_notify(vars.lua.name, "Failed to import!")
    return end

end

menu.import_config:set_callback(function()
    importcfg(clipboard.get())
end)

menu.export_config = tab.home.config:button(colors.main..icons.preset_export..colors.default.." Export ", function() 

    local save = {{}, {}, {}}

    for _, elements in pairs(config.elements) do
        table.insert(save[1], elements:get())
    end

    for _, colors in pairs(config.colors) do
        table.insert(save[2], {colors:get().r, colors:get().g, colors:get().b, colors:get().a})
    end

    for _, aa in pairs(config.aa) do
        table.insert(save[3], aa:get())
    end

    clipboard.set(base64.encode(json.stringify(save)))

    common.add_notify(vars.lua.name, "Config succesfully exported!")
    utils.console_exec("play ui\\beepclear")

end, true)

menu.default_config = tab.home.config:button(colors.main..icons.main..colors.default.." Recommend ", function() 

    importcfg("W1t0cnVlLGZhbHNlLDQuMCx0cnVlLGZhbHNlLHRydWUsdHJ1ZSxmYWxzZSx0cnVlLDM1LjAsMzUuMCwzNS4wLHRydWUsMjUuMCwyNS4wLDI1LjAsMjUuMCwyNS4wLHRydWUsMTY1OC4wLDcuMCx0cnVlLDg5Ni4wLDMzNy4wLHRydWUsdHJ1ZSx0cnVlLHRydWUsMTAuMCw4MC4wLHRydWUsNC4wLCJUZXh0Iiwib3duZWQiLGZhbHNlLHRydWUsWyJTY3JlZW4iLCJDb25zb2xlIl0sMTIuMCxmYWxzZSwiTXV0ZSIsdHJ1ZSwxNS4wLHRydWUsODEuMCw1LjAsLTguMCwxLjAsZmFsc2UsW10sZmFsc2VdLFtbMTU3LjAsMTkwLjAsMjU1LjAsMjU1LjBdLFsyNTUuMCwxNTcuMCwxNTcuMCwyNTUuMF0sWzI1NS4wLDI1NS4wLDI1NS4wLDI1NS4wXSxbMjU1LjAsMjU1LjAsMjU1LjAsMjU1LjBdLFsxNTcuMCwxOTAuMCwyNTUuMCwyNTUuMF0sWzIyNC4wLDIyNC4wLDIyNC4wLDI1NS4wXSxbMjU1LjAsMjU1LjAsMjU1LjAsMjU1LjBdLFsxNTcuMCwxOTAuMCwyNTUuMCwyNTUuMF0sWzI1NS4wLDI1NS4wLDI1NS4wLDE1MS4wXSxbMTU3LjAsMTkwLjAsMjU1LjAsMjU1LjBdLFsyNTUuMCwyNTUuMCwyNTUuMCwyNTUuMF0sWzI1NS4wLDI1NS4wLDI1NS4wLDI1NS4wXSxbMTU3LjAsMTkwLjAsMjU1LjAsMjU1LjBdXSxbIkF0IFRhcmdldCIsdHJ1ZSwiU3RhdGljIiwiU3RhdGljIix0cnVlLDEwLjAsZmFsc2UsZmFsc2UsZmFsc2UsZmFsc2UsdHJ1ZSx0cnVlLFsiRGVzeW5jIiwiWWF3Il0sWyJBdm9pZCBCYWNrc3RhYiIsIkZvcmNlIEJyZWFrIExDIEluLUFpciIsIkZhc3QgTGFkZGVyIE1vdmUiXSxmYWxzZSwiRG93biIsZmFsc2UsNy4wLCJSaWdodCIsIkJhY2t3YXJkIiwwLjAsIjUtV2F5IiwzNS4wLHRydWUsNjAuMCxbIkppdHRlciJdLCJEaXNhYmxlZCIsIkJhY2t3YXJkIiwwLjAsIjUtV2F5IiwtMzUuMCx0cnVlLDYwLjAsWyJKaXR0ZXIiXSwiRGlzYWJsZWQiLGZhbHNlLDAuMCwwLjAsMC4wLDAuMCx0cnVlLDE0LjAsMTAwLjAsIkRvd24iLHRydWUsNC4wLCJSaWdodCIsIkJhY2t3YXJkIiwtMzEuMCwiRGlzYWJsZWQiLDAuMCx0cnVlLDU0LjAsWyJKaXR0ZXIiXSwiRGlzYWJsZWQiLCJCYWNrd2FyZCIsNTUuMCwiRGlzYWJsZWQiLDAuMCx0cnVlLDU0LjAsWyJKaXR0ZXIiXSwiRGlzYWJsZWQiLGZhbHNlLDg5LjAsODkuMCwxMi4wLDEyLjAsdHJ1ZSwxNC4wLDEwMC4wLCJEb3duIix0cnVlLDIuMCwiUmlnaHQiLCJCYWNrd2FyZCIsMC4wLCIzLVdheSIsMjAuMCx0cnVlLDYwLjAsWyJBdm9pZCBPdmVybGFwIiwiSml0dGVyIl0sIkRpc2FibGVkIiwiQmFja3dhcmQiLDAuMCwiMy1XYXkiLDIwLjAsdHJ1ZSw2MC4wLFsiQXZvaWQgT3ZlcmxhcCIsIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiXSwiRGlzYWJsZWQiLGZhbHNlLDAuMCwwLjAsMC4wLDAuMCx0cnVlLDE0LjAsMTAwLjAsIkRvd24iLHRydWUsMy4wLCJMZWZ0IiwiQmFja3dhcmQiLC0yNi4wLCJEaXNhYmxlZCIsMC4wLHRydWUsNjAuMCxbIkppdHRlciJdLCJEaXNhYmxlZCIsIkJhY2t3YXJkIiw1NS4wLCJSYW5kb20iLDAuMCx0cnVlLDYwLjAsWyJKaXR0ZXIiXSwiRGlzYWJsZWQiLHRydWUsLTM3LjAsLTQ4LjAsLTUuMCwxMS4wLHRydWUsMTQuMCwxMDAuMCwiRG93biIsdHJ1ZSw0LjAsIkxlZnQiLCJCYWNrd2FyZCIsLTE3LjAsIlJhbmRvbSIsMC4wLHRydWUsNTQuMCxbIkppdHRlciJdLCJEaXNhYmxlZCIsIkJhY2t3YXJkIiwzNi4wLCJSYW5kb20iLDAuMCx0cnVlLDU0LjAsWyJKaXR0ZXIiXSwiRGlzYWJsZWQiLHRydWUsLTQzLjAsLTQzLjAsMTguMCwtMTguMCx0cnVlLDE0LjAsMTAwLjAsIkRvd24iLHRydWUsNC4wLCJSaWdodCIsIkJhY2t3YXJkIiwtOS4wLCJEaXNhYmxlZCIsMC4wLHRydWUsNjAuMCxbIkppdHRlciJdLCJEaXNhYmxlZCIsIkJhY2t3YXJkIiw1OS4wLCI1LVdheSIsMTEuMCx0cnVlLDYwLjAsWyJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIl0sIkRpc2FibGVkIixmYWxzZSwtMjUuMCwtMjUuMCwtNDguMCwtNDguMCx0cnVlLDE0LjAsMTAwLjBdXQ==")

end, true)















