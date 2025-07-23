-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

 
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

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local vmt_hook = require("neverlose/vmt_hook")

local JSON = panorama.loadstring([[
    return {
        stringify: JSON.stringify,
        parse: JSON.parse
    };
]])()

local 
    system,
    sidebar,
    interface,
    defines,
    vars,
    icon,
    refs,
    tabs,
    fast_ladder,
    antiaim_system,
    condition_settings,
    config_system,
    misc_system,
    ffis,
    visuals_system,
    c4_info,
    defensive_antiaim,
    break_lc = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}


ffis.hwnd = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")) + 2)[0])[0] + 2)
ffis.fwindow = ffi.cast("int(__stdcall*)(uintptr_t, int)", utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7"))
ffis.get_window = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")) + 2)[0])[0]
ffis.gameoverlayrenderer = ffi.cast("int(__thiscall*)(uintptr_t)", utils.opcode_scan("gameoverlayrenderer.dll", "FF E1"))
ffis.bind_argument = function(fn, arg) return function(...) return fn(arg, ...) end end
ffis.entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
ffis.get_entity_address = ffis.bind_argument(ffi.cast("get_client_entity_t", ffis.entity_list_003[0][3]), ffis.entity_list_003)

refs.slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
refs.yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw")
refs.yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
refs.yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
refs.avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")
refs.hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
refs.pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")
refs.yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier")
refs.yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
refs.body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
refs.inventer = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter")
refs.left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit")
refs.right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
refs.options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
refs.freestandingt = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
refs.freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
refs.disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers")
refs.body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
refs.legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
refs.logs = ui.find("Miscellaneous", "Main", "Other", "Log Events")
refs.double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
refs.hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
refs.dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
refs.peek_assist = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
refs.safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
refs.body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
refs.scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

vars.user = common.get_username()
vars.build = "Stable"

icon.file_export = ui.get_icon("file-export")
icon.file_import = ui.get_icon("file-import")
icon.folder_gear = ui.get_icon("folder-gear")
icon.discord = ui.get_icon("discord")
icon.youtube = ui.get_icon("youtube")
icon.config = ui.get_icon("sketch")
icon.gear = ui.get_icon("gear")
icon.house = ui.get_icon("house")
icon.rotate = ui.get_icon("rotate")

tabs.main = ui.create("\aCDFFA1FF"..icon.house, "\aCDFFA1FFGet Good. Get Anti Neverlose")
tabs.config_system = ui.create("\aCDFFA1FF"..icon.house, "\aCDFFA1FFMain")
tabs.links = ui.create("\aCDFFA1FF"..icon.house, "\aCDFFA1FFLinks")
tabs.ragebot = ui.create("\aCDFFA1FF"..icon.gear, "\aCDFFA1FFRagebot")
tabs.visuals = ui.create("\aCDFFA1FF"..icon.gear, "\aCDFFA1FFVisuals")
tabs.misc = ui.create("\aCDFFA1FF"..icon.gear, "\aCDFFA1FFMiscellaneous")
tabs.movement = ui.create("\aCDFFA1FF"..icon.gear, "\aCDFFA1FFMovement")
tabs.antiaim = ui.create("\aCDFFA1FF"..icon.rotate, "\aCDFFA1FFAnti aim")
tabs.builder = ui.create("\aCDFFA1FF"..icon.rotate, "\aCDFFA1FFBuilder")

--https://cdn.discordapp.com/attachments/1101290762592849980/1110931811908976730/GET_GOOD_9.gif
imageee = render.load_image(network.get("https://cdn.discordapp.com/attachments/1101290762592849980/1110931811908976730/GET_GOOD_9.gif"), vector(270,200))
interface.antineverlose = tabs.main:texture(imageee, vector(270,200))
interface.youtube = tabs.main:button("\aCDFFA1FF"..icon.youtube.."\aDEFAULT Youtube", function() 
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UCKYqJrcbdPsW6FH2nlb5sGg") 
end, true)

interface.config = tabs.main:button("\aCDFFA1FF"..icon.config.."\aDEFAULT Paid Neverlose Config       ", function() 
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=uz7juh") 
end, true)
interface.discord_server = tabs.main:button("                     \aCDFFA1FF"..icon.discord.."\aDEFAULT Our Discord Server                    ", function() 
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/kCXx7yBXus") 
end, true)
tabs.main:label("Authors: \aCDFFA1FFSecs#1136".." \aDEFAULT& ".."\aCDFFA1FFaugust#6530")



interface.user = tabs.config_system:label("Username: \aCDFFA1FF"..vars.user)
tabs.config_system:label("Current Version: \aCDFFA1FF6.0.0                    ")

interface.share_cfg = tabs.config_system:button("\aCDFFA1FF"..icon.file_export.." \aDEFAULTExport", nil, true)
interface.apply_cfg = tabs.config_system:button("\aCDFFA1FF"..icon.file_import.." \aDEFAULTImport", nil, true)
interface.load_cfg = tabs.config_system:button("\aCDFFA1FF"..icon.folder_gear.." \aDEFAULTDef. Config", nil, true)

interface.visuals_aimbotlogs = tabs.ragebot:switch("Ragebot Logging", false)
interface.visuals_aimbotlogs_tab = interface.visuals_aimbotlogs:create()
interface.aimbotlogs_print = interface.visuals_aimbotlogs_tab:selectable("Print", "Logs", "Сonsole", "Screen")
interface.aimbotlogs_color = interface.visuals_aimbotlogs_tab:color_picker("Color")
interface.no_scope_hitchance = tabs.ragebot:switch("No Scope Mode")
interface.no_scope_hitchance_tab = interface.no_scope_hitchance:create()
interface.no_scope_hitchance_weapons = interface.no_scope_hitchance_tab:selectable("Weapons", {"Auto", "Scout", "Awp"})
interface.no_scope_hitchance_value = interface.no_scope_hitchance_tab:slider("Hit Chance", 0, 100, 0)
interface.no_scope_hitchance_distance = interface.no_scope_hitchance_tab:slider("Distance", 0, 1000, 0, 1, function(self)
    if self == 1000 then
        return "Inf."
    else
        return self
    end
end)

interface.air_hitchance = tabs.ragebot:switch("Air Mode")
interface.air_hitchance_tab = interface.air_hitchance:create()
interface.air_hitchance_weapons = interface.air_hitchance_tab:selectable("Weapons", {"Scout", "Revolver", "Awp", "Auto", "All"})
interface.air_hitchance_value = interface.air_hitchance_tab:slider("Hit Chance", 0, 100, 0)

interface.visuals_crosshairid = tabs.visuals:switch("Crosshair Indication", false)
interface.visuals_crosshairid_tab = interface.visuals_crosshairid:create()
interface.visuals_crosshairid_add_y = interface.visuals_crosshairid_tab:slider("Add Y", render.screen_size().y/-2, render.screen_size().y/2, 0)
interface.visuals_crosshairid_main_color = interface.visuals_crosshairid_tab:color_picker("Main")
interface.visuals_crosshairid_state_color = interface.visuals_crosshairid_tab:color_picker("Addative")
interface.visuals_crosshairid_addative_color = interface.visuals_crosshairid_tab:color_picker("Binds")
interface.visuals_crosshairid_glow_color = interface.visuals_crosshairid_tab:color_picker("Glow")
interface.visuals_damageid = tabs.visuals:switch("Damage Indication", false)
interface.visuals_damageid_tab = interface.visuals_damageid:create()
interface.visuals_damageid_pos = interface.visuals_damageid_tab:combo("Position", "Left", "Right")
interface.visuals_damageid_color = interface.visuals_damageid_tab:color_picker("Color")
interface.visuals_velocityid = tabs.visuals:switch("Velocity Indication", false)
interface.visuals_velocityid_tab = interface.visuals_velocityid:create()
interface.visuals_velocityid_x = interface.visuals_velocityid_tab:slider("X", 0, render.screen_size().x, render.screen_size().x/2)
interface.visuals_velocityid_y = interface.visuals_velocityid_tab:slider("Y", 0, render.screen_size().y, render.screen_size().y/9)
interface.visuals_velocityid_color = interface.visuals_velocityid_tab:color_picker("Color")
interface.visuals_gamesense = tabs.visuals:switch("\aCDFFA1FF500$ \aDEFAULTIndication", false)
interface.visuals_scopeoverlay = tabs.visuals:switch("Custom Scope Overlay", false)
interface.visuals_scopeoverlay_tab = interface.visuals_scopeoverlay:create()
interface.visuals_scopeoverlay_color = interface.visuals_scopeoverlay_tab:color_picker("Color")
interface.visuals_scopeoverlay_gap = interface.visuals_scopeoverlay_tab:slider("Gap", 0, 500, 0)
interface.visuals_scopeoverlay_line_size = interface.visuals_scopeoverlay_tab:slider("Line Size", 0, 500, 0)

interface.clantag = tabs.misc:switch("Clan Tag", false)
interface.misc_trashtalk = tabs.misc:switch("Kill Say", false)
interface.misc_automuteunmute = tabs.misc:switch("Auto Mute/Unmute", false)
interface.misc_automuteunmute_tab = interface.misc_automuteunmute:create()
interface.misc_automuteunmute_settings = interface.misc_automuteunmute_tab:combo("Auto", "Mute", "Unmute")
interface.misc_automuteunmute_player = interface.misc_automuteunmute_tab:combo("Players", "Enemy", "Every")
interface.misc_taskbarnotify = tabs.misc:switch("Taskbar Notify [New Round]", false)
interface.misc_aspectratio = tabs.misc:switch("Override Aspect Ratio", false)
interface.misc_aspectratio_tab = interface.misc_aspectratio:create()
interface.misc_aspectratio_value = interface.misc_aspectratio_tab:slider("Value", 0, 35, 0, 0.1)
interface.misc_viewmodel = tabs.misc:switch("Override Viewmodel", false)
interface.misc_viewmodel_tab = interface.misc_viewmodel:create()
interface.misc_viewmodel_x = interface.misc_viewmodel_tab:slider("Position X", -10, 10, 0)
interface.misc_viewmodel_y = interface.misc_viewmodel_tab:slider("Position Y", -10, 10, 0)
interface.misc_viewmodel_z = interface.misc_viewmodel_tab:slider("Position Z", -10, 10, 0)
interface.misc_viewmodel_fov = interface.misc_viewmodel_tab:slider("FOV", 0, 120, 0)

interface.misc_fastladder = tabs.movement:switch("Fast Ladder", false)
interface.breal_lc = tabs.movement:switch("Force Break LC In Air", false)

interface.antiaim_enable = tabs.antiaim:switch("Enable Anti Aims", false)
interface.manual_yaw_base = tabs.antiaim:combo("Manual Yaw", "Off", "Left", "Right", "Forward")
interface.avoid_backstab = tabs.antiaim:switch("Avoid Backstab", false)
interface.animation = tabs.antiaim:switch("Anim. Breakers", false)
interface.animation_tab = interface.animation:create()
interface.air_legs = interface.animation_tab:combo("Air Legs", "Default", "Static", "Walking")
interface.ground_legs = interface.animation_tab:combo("Ground Legs", "Default", "Static", "Walking")
interface.move_lean = interface.animation_tab:switch("Move Lean")
interface.move_lean_range = interface.animation_tab:slider("Move Lean Effect", 0, 10, 0)
interface.pitch_zero = interface.animation_tab:switch("Pitch 0 On Land")
interface.sliding_slow_walk = interface.animation_tab:switch("Sliding Slow Walk")
interface.freestanding = tabs.antiaim:switch("Freestanding", false)
interface.freestanding_tab = interface.freestanding:create()
interface.disable_yaw_modifiers = interface.freestanding_tab:switch("Disable Yaw Modifiers", false)
interface.body_freestanding = interface.freestanding_tab:switch("Body Freestanding", false)

interface.antiaim_condition = tabs.builder:combo("", "Standing", "Moving", "Slow Walking", "Crouching", "Air", "Crouching Air", "Legit AA")

for i = 0, 6 do
    condition_settings[i] = {}
    
    condition_settings[i].pitch = tabs.builder:combo("Pitch", "Disabled", "Down", "Fake Down", "Fake Up")

    condition_settings[i].yaw = tabs.builder:combo("Yaw", "Disabled", "Backward", "Static")
    condition_settings[i].yaw_tab = condition_settings[i].yaw:create()    
    condition_settings[i].yaw_base = condition_settings[i].yaw_tab:combo("Yaw Base", "Local View", "At Target")
    condition_settings[i].left_offset = condition_settings[i].yaw_tab:slider("Offset Left", -180, 180, 0)
    condition_settings[i].right_offset = condition_settings[i].yaw_tab:slider("Offset Right", -180, 180, 0)

    condition_settings[i].yaw_modifier = tabs.builder:combo("Yaw Modifier", "Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way")
    condition_settings[i].yaw_modifier_tab = condition_settings[i].yaw_modifier:create()

    condition_settings[i].modifier_mode = condition_settings[i].yaw_modifier_tab:combo("Modifier Mode", "Default", "Jitter", "Random", "3 Way", "5 Way")
    condition_settings[i].modifier_offset = condition_settings[i].yaw_modifier_tab:slider("Offset", -180, 180, 0)
    condition_settings[i].modifier_offset_left = condition_settings[i].yaw_modifier_tab:slider("Left Offset", -180, 180, 0)
    condition_settings[i].modifier_offset_right = condition_settings[i].yaw_modifier_tab:slider("Right Offset", -180, 180, 0)
    condition_settings[i].modifier_offset_way1 = condition_settings[i].yaw_modifier_tab:slider("Way #1", -180, 180, 0)
    condition_settings[i].modifier_offset_way2 = condition_settings[i].yaw_modifier_tab:slider("Way #2", -180, 180, 0)
    condition_settings[i].modifier_offset_way3 = condition_settings[i].yaw_modifier_tab:slider("Way #3", -180, 180, 0)
    condition_settings[i].modifier_offset_way4 = condition_settings[i].yaw_modifier_tab:slider("Way #4", -180, 180, 0)
    condition_settings[i].modifier_offset_way5 = condition_settings[i].yaw_modifier_tab:slider("Way #5", -180, 180, 0)

    condition_settings[i].body_yaw = tabs.builder:switch("Body Yaw", false)
    condition_settings[i].body_yaw_tab = condition_settings[i].body_yaw:create()
    condition_settings[i].inventer = condition_settings[i].body_yaw_tab:switch("Inventer", false)
    condition_settings[i].left_limit = condition_settings[i].body_yaw_tab:slider("Left Limit", 0, 60, 0)
    condition_settings[i].right_limit = condition_settings[i].body_yaw_tab:slider("Right Limit", 0, 60, 0)
    condition_settings[i].options = condition_settings[i].body_yaw_tab:selectable("Options", "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce")
    condition_settings[i].freestanding = condition_settings[i].body_yaw_tab:combo("Freestanding", "Off", "Peek Fake", "Peek Real") 

    condition_settings[i].defensive_aa = tabs.builder:switch("Defensive Anti Aim", false)
    condition_settings[i].defensive_aa_tab = condition_settings[i].defensive_aa:create()
    condition_settings[i].defensive_aa_pitch = condition_settings[i].defensive_aa_tab:combo("Pitch", "Disabled", "Down", "Fake Down", "Fake Up", "Random")
    condition_settings[i].defensive_aa_yaw = condition_settings[i].defensive_aa_tab:combo("Yaw", "Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way")
    condition_settings[i].defensive_aa_disablers = condition_settings[i].defensive_aa_tab:selectable("Disablers", "Freestanding", "Manual Yaw", "Hide Shots", "Double Tap")
end

system.enabled = false
system.start_time = globals.realtime
antiaim_system.anti_aim_on_use = function(cmd)

    system.enabled = false

    if not cmd.in_use then
        system.start_time = globals.realtime
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local player_origin = player:get_origin()

    local CPlantedC4 = entity.get_entities("CPlantedC4")
    local dist_to_bomb = 999

    if #CPlantedC4 > 0 then
        local bomb = CPlantedC4[1]

        local bomb_origin = bomb:get_origin()

        dist_to_bomb = player_origin:dist(bomb_origin)
    end

    local CHostage = entity.get_entities("CHostage")
    local dist_to_hostage = 999

    if #CHostage > 0 then
        local hostage_origin = {CHostage[1]:get_origin(), CHostage[2]:get_origin()}

        dist_to_hostage = math.min(player_origin:dist(hostage_origin[1]), player_origin:dist(hostage_origin[2]))
    end

    if dist_to_hostage < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if dist_to_bomb < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if cmd.in_use then
        if globals.realtime - system.start_time < 0.02 then
            return
        end
    end

    cmd.in_use = false
    system.enabled = true
end

antiaim_system.state = function()
    if not entity.get_local_player() then return end
    local standing = math.sqrt(entity.get_local_player().m_vecVelocity.x ^ 2 + entity.get_local_player().m_vecVelocity.y ^ 2) < 2   
    local jumping = bit.band(entity.get_local_player().m_fFlags, 1) == 0
    local ducking = entity.get_local_player().m_flDuckAmount > 0.5
    local ducking_in_jumping = ducking and ducking and not standing
    local walking = refs.slow_walk:get()
    local legit = system.enabled
    
    if walking and not legit then return "walking"
    elseif ducking and not jumping  and not legit then return "ducking"
    elseif jumping and not ducking  and not legit then return "jumping"
    elseif ducking_in_jumping  and not legit then return "ducking_in_jumping"
    elseif standing  and not legit then return "standing"
    elseif not standing and not ducking  and not legit then return "running" 
    elseif legit then return "legit_aa" end
end


defensive_antiaim.time_to_ticks = function(t)
    return math.floor(0.5 + (t / globals.tickinterval))
end

defensive_antiaim.defensive = false
defensive_antiaim.defensive_ticks = 0
defensive_antiaim.system = function()
    local st = 0
    local rt = 0
    if interface.antiaim_condition:get() == "Standing" then st = 0 end
    if interface.antiaim_condition:get() == "Moving" then st = 1 end
    if interface.antiaim_condition:get() == "Slow Walking" then st = 2 end
    if interface.antiaim_condition:get() == "Crouching" then st = 3 end
    if interface.antiaim_condition:get() == "Air" then st = 4 end
    if interface.antiaim_condition:get() == "Crouching Air" then st = 5 end
    if interface.antiaim_condition:get() == "Legit AA" then st = 6 end

    if antiaim_system.state() == "standing" then do rt = 0 end end
    if antiaim_system.state() == "running" then do rt = 1 end end
    if antiaim_system.state() == "walking" then do rt = 2 end end
    if antiaim_system.state() == "ducking" then do rt = 3 end end
    if antiaim_system.state() == "jumping" then do rt = 4 end end
    if antiaim_system.state() == "ducking_in_jumping" then do rt = 5 end end
    if antiaim_system.state() == "legit_aa" then do rt = 6 end end
    
    local player = entity.get_local_player()
    if not player then return end

    if condition_settings[rt].defensive_aa:get() then 
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")

        if condition_settings[rt].defensive_aa_disablers:get("Freestanding") and refs.freestanding:get() then return end
        if condition_settings[rt].defensive_aa_disablers:get("Manual Yaw") and interface.manual_yaw_base:get() ~= "Off" then return end
        if condition_settings[rt].defensive_aa_disablers:get("Hide Shots") and refs.hide_shots:get() then return end
        if condition_settings[rt].defensive_aa_disablers:get("Double Tap") and refs.double_tap:get() then return end

        local defensive = false
        local simtime = player:get_simulation_time()
        defensive_antiaim.defensive = defensive_antiaim.time_to_ticks(simtime.current - simtime.old) < 0

        if defensive_antiaim.defensive then 
            defensive = true 
        end

        if defensive then
            defensive_antiaim.defensive_ticks = defensive_antiaim.defensive_ticks + 1
        end

        if defensive_antiaim.defensive_ticks >= 10 then
            defensive = false
            defensive_antiaim.defensive_ticks = 0
        end
    else
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override(nil)
    end
end

antiaim_system.side = false
antiaim_system.desync_side = function()
    if entity.get_local_player() == nil then return end
    if globals.choked_commands ~= 0 then return end
    local body_yaw = entity.get_local_player().m_flPoseParameter[11] * 120 - 60
    antiaim_system.side = body_yaw < 0
end

antiaim_system.main = function()
    local st = 0
    local rt = 0
    if interface.antiaim_condition:get() == "Standing" then st = 0 end
    if interface.antiaim_condition:get() == "Moving" then st = 1 end
    if interface.antiaim_condition:get() == "Slow Walking" then st = 2 end
    if interface.antiaim_condition:get() == "Crouching" then st = 3 end
    if interface.antiaim_condition:get() == "Air" then st = 4 end
    if interface.antiaim_condition:get() == "Crouching Air" then st = 5 end
    if interface.antiaim_condition:get() == "Legit AA" then st = 6 end

    if antiaim_system.state() == "standing" then do rt = 0 end end
    if antiaim_system.state() == "running" then do rt = 1 end end
    if antiaim_system.state() == "walking" then do rt = 2 end end
    if antiaim_system.state() == "ducking" then do rt = 3 end end
    if antiaim_system.state() == "jumping" then do rt = 4 end end
    if antiaim_system.state() == "ducking_in_jumping" then do rt = 5 end end
    if antiaim_system.state() == "legit_aa" then do rt = 6 end end

        if interface.antiaim_enable:get() then    
            if defensive_antiaim.defensive then
                local pp = utils.random_int(1, 3)
                if condition_settings[rt].defensive_aa_pitch:get() == "Random" then
                    if pp == 1 then
                        refs.pitch:override("Down")
                    elseif pp == 2 then
                        refs.pitch:override("Fake Up")
                    elseif pp == 3 then
                        refs.pitch:override("Disabled")
                    end
                else
                    refs.pitch:override(condition_settings[rt].defensive_aa_pitch:get())
                end
            else
                refs.pitch:override(condition_settings[rt].pitch:get())
            end
            refs.yaw_base:override(condition_settings[rt].yaw_base:get())
            if defensive_antiaim.defensive then
                refs.yaw_modifier:override(condition_settings[rt].defensive_aa_yaw:get())
            else
                refs.yaw_modifier:override(condition_settings[rt].yaw_modifier:get())
            end
            refs.body_yaw:override(true)
            refs.left_limit:override(condition_settings[rt].left_limit:get())
            refs.right_limit:override(condition_settings[rt].right_limit:get())
            refs.options:override(condition_settings[rt].options:get())
            refs.freestandingt:override(condition_settings[rt].freestanding:get())
            refs.freestanding:override(interface.freestanding:get())
            refs.body_freestanding:override(interface.body_freestanding:get())
            refs.disable_yaw_modifiers:override(interface.disable_yaw_modifiers:get())
            refs.inventer:override(condition_settings[rt].inventer:get())

            if interface.manual_yaw_base:get() == "Off" then
                yaw_offset = antiaim_system.side and condition_settings[rt].right_offset:get() or condition_settings[rt].left_offset:get()
            elseif interface.manual_yaw_base:get() == "Left" then
                yaw_offset = -90
            elseif interface.manual_yaw_base:get() == "Right" then
                yaw_offset = 90
            else
                yaw_offset = -180
            end
            refs.yaw_offset:override(yaw_offset)

            if condition_settings[rt].modifier_mode:get() == "Default" then
                refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset:get())
            elseif condition_settings[rt].modifier_mode:get() == "Jitter" then  
                local yaw_modifier_offset = antiaim_system.side and condition_settings[rt].modifier_offset_right:get() or condition_settings[rt].modifier_offset_left:get()
                refs.yaw_modifier_offset:override(yaw_modifier_offset)
            elseif condition_settings[rt].modifier_mode:get() == "Random" then                
                local yaw_modifier_random = utils.random_int(condition_settings[rt].modifier_offset_right:get(), condition_settings[rt].modifier_offset_left:get())
                refs.yaw_modifier_offset:override(yaw_modifier_random)
            elseif condition_settings[rt].modifier_mode:get() == "3 Way" then
                if globals.tickcount % 3 == 0 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way1:get())
                elseif globals.tickcount % 3 == 1 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way2:get())
                elseif globals.tickcount % 3 == 2 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way3:get())
                end
            elseif condition_settings[rt].modifier_mode:get() == "5 Way" then
                if globals.tickcount % 5 == 0 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way1:get())
                elseif globals.tickcount % 5 == 1 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way2:get())
                elseif globals.tickcount % 5 == 2 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way3:get())
                elseif globals.tickcount % 5 == 3 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way4:get())
                elseif globals.tickcount % 5 == 4 then
                    refs.yaw_modifier_offset:override(condition_settings[rt].modifier_offset_way5:get())
                end
            end
            refs.avoid_backstab:override(interface.avoid_backstab:get())
        else
            refs.pitch:override(nil)
            refs.yaw_base:override(nil)
            refs.yaw:override(nil)
            refs.yaw_modifier:override(nil)
            refs.body_yaw:override(nil)
            refs.left_limit:override(nil)
            refs.right_limit:override(nil)
            refs.options:override(nil)
            refs.freestandingt:override(nil)
            refs.freestanding:override(nil)
            refs.body_freestanding:override(nil)
            refs.disable_yaw_modifiers:override(nil)
            refs.yaw_offset:override(nil)
            refs.yaw_modifier_offset:override(nil)
            refs.avoid_backstab:override(nil)
            refs.hidden:override(nil)
        end
end

antiaim_system.visibility_manager = function()
    local st = 0
    local rt = 0
    if interface.antiaim_condition:get() == "Standing" then st = 0 end
    if interface.antiaim_condition:get() == "Moving" then st = 1 end
    if interface.antiaim_condition:get() == "Slow Walking" then st = 2 end
    if interface.antiaim_condition:get() == "Crouching" then st = 3 end
    if interface.antiaim_condition:get() == "Air" then st = 4 end
    if interface.antiaim_condition:get() == "Crouching Air" then st = 5 end
    if interface.antiaim_condition:get() == "Legit AA" then st = 6 end

    if antiaim_system.state() == "standing" then do rt = 0 end end
    if antiaim_system.state() == "running" then do rt = 1 end end
    if antiaim_system.state() == "walking" then do rt = 2 end end
    if antiaim_system.state() == "ducking" then do rt = 3 end end
    if antiaim_system.state() == "jumping" then do rt = 4 end end
    if antiaim_system.state() == "ducking_in_jumping" then do rt = 5 end end
    if antiaim_system.state() == "legit_aa" then do rt = 6 end end
    
    for b, v in pairs(condition_settings[0]) do v:visibility(interface.antiaim_condition:get() == "Standing") end
    for b, v in pairs(condition_settings[1]) do v:visibility(interface.antiaim_condition:get() == "Moving") end
    for b, v in pairs(condition_settings[2]) do v:visibility(interface.antiaim_condition:get() == "Slow Walking") end
    for b, v in pairs(condition_settings[3]) do v:visibility(interface.antiaim_condition:get() == "Crouching") end
    for b, v in pairs(condition_settings[4]) do v:visibility(interface.antiaim_condition:get() == "Air") end
    for b, v in pairs(condition_settings[5]) do v:visibility(interface.antiaim_condition:get() == "Crouching Air") end
    for b, v in pairs(condition_settings[6]) do v:visibility(interface.antiaim_condition:get() == "Legit AA") end

    condition_settings[st].modifier_offset:visibility(false)
    condition_settings[st].modifier_offset_left:visibility(false)
    condition_settings[st].modifier_offset_right:visibility(false)
    condition_settings[st].modifier_offset_way1:visibility(false)
    condition_settings[st].modifier_offset_way2:visibility(false)
    condition_settings[st].modifier_offset_way3:visibility(false)
    condition_settings[st].modifier_offset_way4:visibility(false)
    condition_settings[st].modifier_offset_way5:visibility(false)
    condition_settings[st].pitch:visibility(false)
    condition_settings[st].left_offset:visibility(false)
    condition_settings[st].right_offset:visibility(false)
    condition_settings[st].yaw_modifier:visibility(false)
    condition_settings[st].modifier_mode:visibility(false)
    condition_settings[st].freestanding:visibility(false)
    condition_settings[st].left_limit:visibility(false)
    condition_settings[st].right_limit:visibility(false)
    condition_settings[st].options:visibility(false)

    interface.avoid_backstab:visibility(false)
    condition_settings[st].defensive_aa:visibility(false)
    condition_settings[st].body_yaw:visibility(false)
    condition_settings[st].yaw:visibility(false)
    interface.visuals_velocityid_x:visibility(false)
    interface.visuals_velocityid_y:visibility(false)


    interface.animation:visibility(false)
    interface.manual_yaw_base:visibility(false)
    interface.freestanding:visibility(false)
    interface.disable_yaw_modifiers:visibility(false)
    interface.body_freestanding:visibility(false)
    interface.antiaim_condition:visibility(false)

    if interface.antiaim_enable:get() then
        interface.animation:visibility(true)
        interface.manual_yaw_base:visibility(true)
        interface.freestanding:visibility(true)
        interface.disable_yaw_modifiers:visibility(true)
        interface.body_freestanding:visibility(true)
        interface.antiaim_condition:visibility(true)
        condition_settings[st].pitch:visibility(true)
        condition_settings[st].left_offset:visibility(true)
        condition_settings[st].right_offset:visibility(true)
        condition_settings[st].yaw_modifier:visibility(true)
        condition_settings[st].modifier_mode:visibility(true)
        condition_settings[st].freestanding:visibility(true)
        condition_settings[st].left_limit:visibility(true)
        condition_settings[st].right_limit:visibility(true)
        condition_settings[st].options:visibility(true)

        interface.avoid_backstab:visibility(true)
        condition_settings[st].defensive_aa:visibility(true)
        condition_settings[st].body_yaw:visibility(true)
        condition_settings[st].yaw:visibility(true)

        if condition_settings[st].modifier_mode:get() == "Default" then
            condition_settings[st].modifier_offset:visibility(true)
        elseif condition_settings[st].modifier_mode:get() == "Jitter" or condition_settings[st].modifier_mode:get() == "Random" then
            condition_settings[st].modifier_offset_left:visibility(true)
            condition_settings[st].modifier_offset_right:visibility(true)
        elseif condition_settings[st].modifier_mode:get() == "3 Way" then
            condition_settings[st].modifier_offset_way1:visibility(true)
            condition_settings[st].modifier_offset_way2:visibility(true)
            condition_settings[st].modifier_offset_way3:visibility(true)
        elseif condition_settings[st].modifier_mode:get() == "5 Way" then
            condition_settings[st].modifier_offset_way1:visibility(true)
            condition_settings[st].modifier_offset_way2:visibility(true)
            condition_settings[st].modifier_offset_way3:visibility(true)
            condition_settings[st].modifier_offset_way4:visibility(true)
            condition_settings[st].modifier_offset_way5:visibility(true)
        end

    end
end

misc_system.fast_ladder = function(cmd)

    if not entity.get_local_player() then return end

    if entity.get_local_player().m_MoveType ~= 9 then return end

    local p = {43, 44, 45, 46, 47, 48}

    for k, v in pairs(p) do if entity.get_local_player():get_player_weapon():get_weapon_index() == v then return end end

    cmd.in_moveleft = cmd.in_back

    if cmd.sidemove == 0 then cmd.view_angles.y = cmd.view_angles.y + 45 end

    if cmd.in_forward and cmd.sidemove < 0 then cmd.view_angles.y = cmd.view_angles.y + 90 end

    if cmd.in_back and cmd.sidemove > 0 then cmd.view_angles.y = cmd.view_angles.y + 90 end

    if cmd.view_angles.x < 0 then cmd.view_angles.x = -45 end

    cmd.in_moveright = cmd.in_forward

end

local phrases = {
    "Хочешь Хаесать?Купи anti neverlose.lua", "Чё умираешь?Купи antineverlose.lua Нищий!",
    "By Anti neverlose.lua" , "Китаец ебанный играть научись", "Нищий найди 3НЛЕ и купи уже себе норм луашку", "ANGRY ? ? ? ? its anti neverlose lua BETA","antineverlose beta",
    "GET GOOD BUY ANTINEVERLOSE.LUA","Fucked by Anti-Neverlose.lua", "СЫН ПОМОЙКИ 1", "antineverlose.wav", "ВЫебан,Кидай хвх тебе максимум полы мыть", "Купи себе кфг У Секса чем играть дальше со своей хуйней", "Нищая 1 , терпи дальше",
    "Миссает чит?Купи луа которая его улучшит) anti neverlose.lua", "its a anti neverlose.lua bro", "antineverlose.lua ☆☆☆ ✟ ✟ ✟", "Yes im user anti neverlose.lua", "Секс?Нет лучше возьму anti neverlose.lua", "anti neverlose.lua boosted ", "Купил луа и кфг от Секса , ебать оно ебет", "By AntiNeverlose.lua",
    "☆｡ antineverlose fucked you(^･ω･^) ⋆｡°", "Трахнул даже не заметив", "resolver boosted by anti neverlose.lua", "resolver boosted by anti neverlose.lua", "resolver boosted by anti neverlose.lua","resolver boosted by anti neverlose.lua","resolver boosted by anti neverlose.lua"
}

misc_system.trash_talk = function(enemy)
    if interface.misc_trashtalk:get() then
        if entity.get(enemy.userid,true) ~= entity.get(enemy.attacker,true) and entity.get(enemy.attacker,true) == entity.get_local_player() then
            utils.console_exec("say "..phrases[utils.random_int(1, #phrases)])
        end
    end
end

misc_system.override_viewmodel = function()
    cvar.viewmodel_fov:int(interface.misc_viewmodel_fov:get(), true)
    cvar.viewmodel_offset_x:float(interface.misc_viewmodel_x:get(), true)
    cvar.viewmodel_offset_y:float(interface.misc_viewmodel_y:get(), true)
    cvar.viewmodel_offset_z:float(interface.misc_viewmodel_z:get(), true)
end

misc_system.unmute_mute = function()
    if not interface.misc_automuteunmute:get() then return end
    local settings = interface.misc_automuteunmute_settings:get()

    local players = entity.get_players(interface.misc_automuteunmute_player:get() == "Enemy", true, function(player)
        local get_player_info = player:get_player_info()
        local get_mute = panorama.FriendsListAPI.IsSelectedPlayerMuted(get_player_info.steamid64)

        if settings == "Unmute" and get_mute then panorama.FriendsListAPI.ToggleMute(get_player_info.steamid64)
        elseif settings == "Mute" and not get_mute then panorama.FriendsListAPI.ToggleMute(get_player_info.steamid64) end
    end)
end

misc_system.hwnd = function() return ffis.hwnd[0] end
misc_system.fhwnd = function() return ffis.gameoverlayrenderer(ffis.get_window) end
misc_system.taskbar_notify = function()
    local cs_process = misc_system.hwnd()
    if interface.misc_taskbarnotify:get() and misc_system.fhwnd() ~= cs_process then ffis.fwindow(cs_process, 1) end
end

interface.misc_aspectratio_value:set_callback(function () if interface.misc_aspectratio:get() then cvar.r_aspectratio:float(interface.misc_aspectratio_value:get() / 10) end end, false)
interface.misc_aspectratio:set_callback(function () cvar.r_aspectratio:float(interface.misc_aspectratio:get() and interface.misc_aspectratio_value:get() / 10 or 0) end, true)

local hitlogs = {}

local lerp = function(start, end_pos, time)
    time = globals.frametime * (time * 175)
    if time < 0 then
      time = 0.01
    elseif time > 1 then
      time = 1
    end

    if type(start) == "userdata" then
        local color_data = {0, 0, 0, 0}

        for v, k in ipairs({"r", "g", "b", "a"}) do
            color_data[v] = lerp(start[k], end_pos[k], time)
        end

        return Color.new(unpack(color_data))
    end

    if (math.abs(start-end_pos) < (delta or 0.01)) then return end_pos end

    return ((end_pos - start)*time +start)
end

local hitgroup_str = {[0] = 'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'}
local function log_color(color)
    local output = ''
    output = output .. ('\a%02x%02x%02x'):format(color.r, color.g, color.b)
    return output
end

events.aim_ack:set(function(shot)
    local text 
    local name = shot.target:get_name()
    local damage = shot.damage
    local wanted_damage = shot.wanted_damage
    local hit_chance = shot.hitchance
    local hitbox = shot.hitgroup
    local backtrack = shot.backtrack

    --Hit in Joe's right leg for 19(24) damage (hitchance: 53% | 0 ticks)
    --Missed in Joe's right leg due to spread (hitchance: 53% | 0 ticks)

    if interface.aimbotlogs_print:get("Logs") then
        if not shot.state then
            print_dev("Hit "..name.." in the "..hitgroup_str[shot.hitgroup].." for "..damage.."("..wanted_damage..")")
        end
        if shot.state then
            print_dev("Missed shot due to "..shot.state)
        end
    end

    if interface.aimbotlogs_print:get("Сonsole") then
        if not shot.state then
            print_raw("\aFFFFFF- anti neverlose - \aDEFAULTHit "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..name.."\aDEFAULT in the "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..hitgroup_str[shot.hitgroup].."\aDEFAULT for "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..damage.."\aDEFAULT("..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..wanted_damage.."\aDEFAULT) damage (hitchance "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..hit_chance.."\aDEFAULT | backtrack: "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..backtrack.."\aDEFAULT)")                                                               
        end
        if shot.state then
            print_raw("\aFFFFFF- anti neverlose - \aDEFAULTMissed shot due to "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..shot.state.."\aDEFAULT (hitchance "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..hit_chance.."\aDEFAULT | backtrack: "..log_color(interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get(),interface.aimbotlogs_color:get())..backtrack.."\aDEFAULT)")
        end
    end

    if interface.aimbotlogs_print:get("Screen") then
        if not shot.state then
            table.insert(hitlogs, {
                {
                        "Hit "..name.." in the "..hitgroup_str[shot.hitgroup].." for "..damage.."("..wanted_damage..")",
                },
                anim = 0,
                anim1 = 0,
                time = globals.realtime,
                color = interface.aimbotlogs_color:get(),
            })
        end
        if shot.state then
            table.insert(hitlogs, {
                {
                        "Missed shot due to "..shot.state,
                },
                anim = 0,
                anim1 = 0,
                time = globals.realtime,
                color = interface.aimbotlogs_color:get(),
            })
        end
    end
        

end)

events.render:set(function()

    if not interface.aimbotlogs_print:get("Screen") then return end

    local screen = render.screen_size()
    local x, y = screen.x/2, screen.y/1.32
    add_y = 0
    for i, hitlog in ipairs(hitlogs) do

        local text = hitlog[1]
        local some_text = render.measure_text(1, "", text[1]).x
        local some_text_y = render.measure_text(1, "", text[1]).y

        if hitlog.time + 1 > globals.realtime then
            hitlog.anim = lerp(hitlog.anim, 1, 0.07)
            hitlog.anim1 = lerp(hitlog.anim1, 1, 0.05)
        end

        add_y = add_y + 20*hitlog.anim

        render.rect(vector((x - some_text / 2 ) - 5, y - 2 - add_y), vector((x + some_text / 2 ) + 4, y + some_text_y + 3 - add_y), color(interface.aimbotlogs_color:get().r,interface.aimbotlogs_color:get().g,interface.aimbotlogs_color:get().b,100*hitlog.anim1), 4)
        render.rect_outline(vector((x - some_text / 2 ) - 5, y - 2 - add_y), vector((x + some_text / 2 ) + 4, y + some_text_y + 3 - add_y), color(255,255,255,100*hitlog.anim1), 0, 4)
        render.text(1, vector(x - some_text/2, y - add_y), color(255, 255, 255, 255*hitlog.anim1), "", text[1])

        if hitlog.time + 3 < globals.realtime then 
            hitlog.anim = lerp(hitlog.anim, 0, 0.05)
            hitlog.anim1 = lerp(hitlog.anim1, 0, 0.05)
        end

        if hitlog.anim < 0.01 and (hitlog.time + 4 < globals.realtime) or #hitlogs > 5 then
            table.remove(hitlogs, i) 
        end
    end

end)

local animation = 0
local add_y = 0
local animation1 = 0
local animation2 = 0
local animation3 = 0
local animation4 = 0
local animation5 = 0

local alpha1 = 0
local alpha2 = 0
local alpha3 = 0
local alpha4 = 0
local alpha5 = 0

local manual_anim = 0
local velocity_anim = 0

local skeet1 = 0
local skeet2 = 0
local skeet3 = 0
local skeet4 = 0
local skeet5 = 0
local gamesense1 = 0
local gamesense2 = 0
local gamesense3 = 0
local gamesense4 = 0
local gamesense5 = 0

local cross_lerp = function(a, b, c)
    return a - (a - b) * c
end
visuals_system.crosshair_indicators = function()
    if common.is_button_down(0x09) then return end
    if not interface.visuals_crosshairid:get() then return end  
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    if not globals.is_in_game then return end   
    local is_scoped = player.m_bIsScoped
    
    local screen = render.screen_size()
    local min_damage = false
    local get_binds = ui.get_binds()
    local state = nil
    
    if antiaim_system.state() == "standing" then state = "STANDING"
    elseif antiaim_system.state() == "running" then state = "RUNNING" 
    elseif antiaim_system.state() == "walking" then state = "WALKING" 
    elseif antiaim_system.state() == "ducking" then state = "DUCKING" 
    elseif antiaim_system.state() == "jumping" then state = "JUMPING" 
    elseif antiaim_system.state() == "legit_aa" then state = "LEGIT AA" 
    elseif antiaim_system.state() == "ducking_in_jumping" then state = "CROUCHING AIR" end

    local pussy = "ANTI"
    local choker = "NEVERLOSE"
    local ws = "WS"
    local dt = "DOUBLE TAP"
    local hs = "HIDE SHOTS"
    local da = "DORMANT"
    local baim = "BODY"
    local md = "MIN. DAMAGE"
    
    local pussy_name = render.measure_text(2, "", pussy)
    local choker_name = render.measure_text(2, "", choker)
    local axcord_name = render.measure_text(2, "", pussy..choker)
    local ws_name = render.measure_text(2, "", ws)
    local state_name = render.measure_text(2, "", state)
    local dt_name = render.measure_text(2, "", dt)
    local hs_name = render.measure_text(2, "", hs)
    local da_name = render.measure_text(2, "", da)
    local body_name = render.measure_text(2, "", baim)
    local min_damage_name = render.measure_text(2, "", md)

    for i = 1, #get_binds do local binds = get_binds[i] if binds.name == 'Min. Damage' and binds.active then min_damage = true end end
    
    if is_scoped then
        x_plus = 2
    else
        x_plus = 0
    end
    
    for i = 0, 1 do
        animation = cross_lerp(animation, x_plus*i, 0.03) 
    end

    add_y = interface.visuals_crosshairid_add_y:get()
       
    y_plus1 = 0 
    y_plus2 = 0 
    y_plus3 = 0 
    y_plus4 = 0 
    y_plus5 = 0 

    local r,g,b = interface.visuals_crosshairid_addative_color:get().r, interface.visuals_crosshairid_addative_color:get().g, interface.visuals_crosshairid_addative_color:get().b
    
    render.shadow(vector(screen.x/2-axcord_name.x/2+axcord_name.x/2*animation+1+5*animation, screen.y/2+19+ add_y), vector(screen.x/2+axcord_name.x/2+axcord_name.x/2*animation+1+5*animation, screen.y/2+19+ add_y), interface.visuals_crosshairid_glow_color:get(), axcord_name.y*1.2, 0, 9)
    render.shadow(vector(screen.x/2-state_name.x/2+state_name.x/2*animation+1+5*animation, screen.y/2+29+ add_y), vector(screen.x/2+state_name.x/2+state_name.x/2*animation+1+5*animation, screen.y/2+29+ add_y), interface.visuals_crosshairid_glow_color:get(), axcord_name.y*1.2, 0, 9)
    render.text(2, vector(screen.x/2-axcord_name.x/2+axcord_name.x/2*animation+1+5*animation, screen.y/2+13+ add_y), interface.visuals_crosshairid_main_color:get(), "", pussy)
    render.text(2, vector(screen.x/2-axcord_name.x/2+pussy_name.x+axcord_name.x/2*animation+1+5*animation, screen.y/2+13+ add_y), interface.visuals_crosshairid_state_color:get(), "", choker)
    render.text(2, vector(screen.x/2-state_name.x/2+state_name.x/2*animation+1+5*animation, screen.y/2+23+ add_y), interface.visuals_crosshairid_state_color:get(), "", state)

    if refs.double_tap:get() then
        animation1 = cross_lerp(animation1, 1, 0.035)
        alpha1 = cross_lerp(alpha1, 1, 0.06)
        y_plus1 = 10*animation1
        if rage.exploit:get() == 0 then
            render.text(2, vector(screen.x/2-dt_name.x/2+dt_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus1 + add_y), color(interface.visuals_crosshairid_state_color:get().r,interface.visuals_crosshairid_state_color:get().g,interface.visuals_crosshairid_state_color:get().b,interface.visuals_crosshairid_state_color:get().a*alpha1), "", dt)
        else
            render.text(2, vector(screen.x/2-dt_name.x/2+dt_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus1 + add_y), color(r,g,b,255*alpha1), "", dt)
        end
    else
        animation1 = cross_lerp(animation1, 0, 0.035)
        alpha1 = cross_lerp(alpha1, 0, 0.06)
        y_plus1 = 10*animation1
        render.text(2, vector(screen.x/2-dt_name.x/2+dt_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus1 + add_y), color(r,g,b,255*alpha1), "", dt)
    end

    if refs.hide_shots:get() then
        animation2 = cross_lerp(animation2, 1, 0.035)
        alpha2 = cross_lerp(alpha2, 1, 0.06)
        y_plus2 = 10*animation2
        render.text(2, vector(screen.x/2-hs_name.x/2+hs_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus2+y_plus1 + add_y), color(r,g,b,255*alpha2), "", hs)
    else
        animation2 = cross_lerp(animation2, 0, 0.035)
        alpha2 = cross_lerp(alpha2, 0, 0.06)
        y_plus2 = 10*animation2
        render.text(2, vector(screen.x/2-hs_name.x/2+hs_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus2+y_plus1 + add_y), color(r,g,b,255*alpha2), "", hs)
    end

    if min_damage then
        animation3 = cross_lerp(animation3, 1, 0.035)
        alpha3 = cross_lerp(alpha3, 1, 0.06)
        y_plus3 = 10*animation3
        render.text(2, vector(screen.x/2-min_damage_name.x/2+min_damage_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus3+y_plus2+y_plus1 + add_y), color(r,g,b,255*alpha3), "", md)
    else
        animation3 = cross_lerp(animation3, 0, 0.035)
        alpha3 = cross_lerp(alpha3, 0, 0.06)
        y_plus3 = 10*animation3
        render.text(2, vector(screen.x/2-min_damage_name.x/2+min_damage_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus3+y_plus2+y_plus1 + add_y), color(r,g,b,255*alpha3), "", md)
    end

    if refs.body_aim:get() == "Force" then
        animation4 = cross_lerp(animation4, 1, 0.035)
        alpha4 = cross_lerp(alpha4, 1, 0.06)
        y_plus4 = 10*animation4
        render.text(2, vector(screen.x/2-body_name.x/2+body_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus4+y_plus2+y_plus1+y_plus3 + add_y), color(r,g,b,255*alpha4), "", baim)
    else
        animation4 = cross_lerp(animation4, 0, 0.035)
        alpha4 = cross_lerp(alpha4, 0, 0.06)
        y_plus4 = 10*animation4
        render.text(2, vector(screen.x/2-body_name.x/2+body_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus4+y_plus2+y_plus1+y_plus3 + add_y), color(r,g,b,255*alpha4), "", baim)
    end

    if refs.dormant_aimbot:get() then
        animation5 = cross_lerp(animation5, 1, 0.035)
        alpha5 = cross_lerp(alpha5, 1, 0.06)
        y_plus5 = 10*animation5
        render.text(2, vector(screen.x/2-da_name.x/2+da_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus4+y_plus2+y_plus1+y_plus3+y_plus5 + add_y), color(r,g,b,150*alpha5), "", da)
    else
        animation5 = cross_lerp(animation5, 0, 0.035)
        alpha5 = cross_lerp(alpha5, 0, 0.06)
        y_plus5 = 10*animation5
        render.text(2, vector(screen.x/2-da_name.x/2+da_name.x/2*animation+1+5*animation, screen.y/2+23+y_plus4+y_plus2+y_plus1+y_plus3+y_plus5 + add_y), color(r,g,b,150*alpha5), "", da)
    end
end

local anim_num = 0
local scope_lerp = function(a, b, c)
    return a + (b - a) * c
end
visuals_system.custom_scope = function()
    
    if not interface.visuals_scopeoverlay:get() then return end
    refs.scope_overlay:set("Remove All")
    if common.is_button_down(0x09) then return end
    
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    if not globals.is_in_game then return end

    local is_alive = player:is_alive()
    local is_scoped = player.m_bIsScoped

    local i = 0
    local x = render.screen_size().x
    local y = render.screen_size().y

    local color2 = color(255, 255, 255, 0)
    local color =  interface.visuals_scopeoverlay_color:get()
    local gap = interface.visuals_scopeoverlay_gap:get()
    local size = interface.visuals_scopeoverlay_line_size:get()

    if not player or not is_alive or not is_scoped then i = 0 else i = 1 end

    anim_num = scope_lerp(anim_num, i, 8.3 * globals.frametime)

    if not is_scoped and anim_num < 0.01 then return end

    render.gradient(vector(x / 2 -gap * anim_num, y / 2), vector(x / 2 -gap * anim_num - size * anim_num, y / 2 + 1), color, color2, color, color2)
    render.gradient(vector(x / 2 +gap * anim_num + 1, y / 2), vector(x / 2 +gap * anim_num + size * anim_num, y / 2 + 1), color, color2, color, color2)
    render.gradient(vector(x / 2, y / 2 +gap * anim_num), vector(x / 2 + 1, y / 2 +gap * anim_num + size * anim_num), color, color, color2, color2)
    render.gradient(vector(x / 2, y / 2 -gap * anim_num), vector(x / 2 + 1, y / 2 -gap * anim_num - size * anim_num), color, color, color2, color2)    
end

visuals_system.kibit_damage = function()
    if common.is_button_down(0x09) then return end
    if not interface.visuals_damageid:get() then return end 
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    if not globals.is_in_game then return end

    local screen = render.screen_size()
    local mcolor = interface.visuals_damageid_color:get()
    local pos = interface.visuals_damageid_pos
    local xyi = 0

    local some_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
    
    local mdamage = render.measure_text(1, "", some_damage)

    if pos:get() == "Left" then
        xyi = -5 - mdamage.x
    elseif pos:get() == "Right" then
        xyi = 5
    end

    render.text(1, vector(screen.x/2+xyi, screen.y/2.02-10), mcolor, "", some_damage)
end

visuals_system.velocity_indicator = drag_system.register({interface.visuals_velocityid_x, interface.visuals_velocityid_y}, vector(30, 30), "Test", function(self)
    if common.is_button_down(0x09) then return end
    if not interface.visuals_velocityid:get() then return end   
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    if not globals.is_in_game then return end

    local screen = render.screen_size()
    local x = interface.visuals_velocityid_x:get()
    local y = interface.visuals_velocityid_y:get()
    local mcolor = interface.visuals_velocityid_color:get()

    local mod = player['m_flVelocityModifier']

    local text = ("Slowed Down: "..math.floor(mod*100).."%")
    
    local some_text = render.measure_text(1, "", text).x
    local some_text_y = render.measure_text(1, "", text).y

    if ui.get_alpha() > 0.5 then
        velocity_anim = 1
    else
        if math.floor(mod*100) ~= 100 then 
            velocity_anim = cross_lerp(velocity_anim, 1, 0.03)
        else
            velocity_anim = cross_lerp(velocity_anim, 0, 0.01)
        end
    end

    render.rect(vector((self.position.x - some_text / 2 ) - 5, self.position.y - 2 ), vector((self.position.x  + some_text / 2 ) + 4, self.position.y + some_text_y + 3), color(mcolor.r, mcolor.g, mcolor.b, 100*velocity_anim), 4)   
    render.rect_outline(vector((self.position.x - some_text / 2 ) - 5, self.position.y - 2 ), vector((self.position.x  + some_text / 2 ) + 4, self.position.y + some_text_y + 3), color(255,255,255,100*velocity_anim), 0, 4)
    render.text(1, vector(self.position.x - some_text/2, self.position.y), color(255, 255, 255, 255*velocity_anim), "", text)
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

visuals_system.get_bind = function(name)
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

visuals_system.spectators_get = function()
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

visuals_system.skeetcc_ebaniy = function()
    if not interface.visuals_gamesense:get() then return end    
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    if not globals.is_in_game then return end

    local screen = render.screen_size()
    local fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get()

    local add_y = 5
    local spectators = visuals_system.spectators_get()

    for _, spec in pairs(spectators) do
        local name = spec:get_name() 
        local text_size = render.measure_text(1, nil, name).x

        render.text(1, vector(render.screen_size().x - text_size - 2, 2 + add_y), color(255,255,255,255), nil, name)

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
                
                local barlength = (((render.screen_size().y - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, render.screen_size().y), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, render.screen_size().y), color(25, 25, 25, 160))
                
                render.rect(vector(0, render.screen_size().y - barlength), vector(16, render.screen_size().y), clr)
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

    local getbind = visuals_system.get_bind

    local ping = player:get_resource().m_iPing
    local delta = (math.abs(ping % 360)) / (fake_latency / 2)
    if delta > 1 then delta = 1 end

    local ping_color = color(255 - (125 * delta), 200 * delta, 0)

    local binds = {
        {"DA", refs.dormant_aimbot:get(), color(255, 200)},
        {"PING", fake_latency > 0 and player:is_alive(), ping_color},
        {"BODY", refs.body_aim:get() == "Force", color(255, 200)},
        {"SAFE", refs.safe_points:get() == "Force", color(255, 200)},
        {"DT", refs.double_tap:get(), rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 0, 255)},
        {"OSAA", refs.hide_shots:get(), color(255, 200)},
        {"DUCK", ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(), color(255, 200)},
        {"FS", interface.freestanding:get(), color(255, 200)},        
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
antiaim_system.animations = function(thisptr, edx)
    hooked_function(thisptr, edx)
    local player = entity.get_local_player()
    if not player then return end
    if not player:is_alive() then return end
    
    if interface.animation:get() then 
    
        -- air legs
        if interface.air_legs:get() == "Default" then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Default")
        elseif interface.air_legs:get() == "Static" then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
            player.m_flPoseParameter[6] = 1
        elseif antiaim_system.state() == "jumping" or antiaim_system.state() == "ducking_in_jumping" and interface.air_legs:get() == "Walking" then
            ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][6].m_flWeight = 1
        end

        -- ground legs
        if interface.ground_legs:get() == "Default" then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Default")
        elseif interface.ground_legs:get() == "Static" then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
            player.m_flPoseParameter[0] = 1
        elseif interface.ground_legs:get() == "Walking" then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Walking")
            player.m_flPoseParameter[7] = 0
        end

        -- pitch zero
        if interface.pitch_zero:get() then
            if antiaim_system.state() ~= "jumping" and antiaim_system.state() ~= "ducking_in_jumping" and ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi.cast("uintptr_t", thisptr) + 0x9960)[0].bHitGroundAnimation then
                player.m_flPoseParameter[12] = 0.5
            end
        end

        -- slow walk
        if interface.sliding_slow_walk:get() then
            player.m_flPoseParameter[9] = 0
        end

        -- move lean
        if interface.move_lean:get() and player.m_vecVelocity:length() > 3 then
            ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", thisptr) + 0x2990)[0][12].m_flWeight = (interface.move_lean_range:get()/10)
        end
    end
end

antiaim_system.move_lean = function(cmd)
    if interface.move_lean:get() then
        cmd.animate_move_lean = true
    else
        cmd.animate_move_lean = false
    end
end

antiaim_system.anim_update = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local local_player_ptr = ffis.get_entity_address(player:get_index())

    if local_player_ptr == nil or hooked_function then
        return
    end

    local new_point = vmt_hook.new(local_player_ptr)
    hooked_function = new_point.hook("void(__fastcall*)(void*, void*)", antiaim_system.animations, 224)
end

break_lc.main = function()
    local bbb = utils.random_int(1,2)
    if antiaim_system.state() == "jumping" or antiaim_system.state() == "ducking_in_jumping" and interface.breal_lc:get() then
        if bbb == 1 then
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Always On")
        else
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("On Peek")
        end
    end
end

misc_system.get_nearest_enemy = function()    
    local player = entity.get_local_player()
    if not player or not player:is_alive() then
        return
    end
    
    local get_first = math.huge
    local get_second = math.huge

    for _, enemy in ipairs(entity.get_players(true, true)) do
        if(enemy == nil or enemy.m_iHealth <= 0) then goto skip end
        local enemy_origin = enemy:get_origin()
            
    
        local get_dist = enemy_origin:dist_to_ray(
            render.camera_position(), player:get_origin()
        )
            
        if get_dist < get_first then
            get_first = get_dist
            get_second = enemy
        end
        ::skip::
    end
    
    if not get_second then
        return
    end
    return player:get_origin():dist(get_second:get_origin()) 
end

misc_system.air_hitchance = function()
    if not interface.air_hitchance:get() then return end

    ssg = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance")
    awp = ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance")
    auto = ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance")
    revolver = ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance")
    all = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")

    hitchance = air_hitchance_value:get()

    if antiaim_system.state() == "ducking_in_jumping" or antiaim_system.state() == "jumping" then

        if interface.air_hitchance_weapons:get("Scout") then
            ssg:override(hitchance)
        end

        if interface.air_hitchance_weapons:get("Awp") then
            awp:override(hitchance)
        end

        if interface.air_hitchance_weapons:get("Auto") then
            auto:override(hitchance)
        end

        if interface.air_hitchance_weapons:get("Revolver") then
            revolver:override(hitchance)
        end

        if interface.air_hitchance_weapons:get("All") then
            all:override(hitchance)
        end

    end
end

misc_system.no_scope_hitchance = function()
    if not interface.no_scope_hitchance:get() then return end
    local is_scoped = entity.get_local_player().m_bIsScoped

    ssg = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance")
    awp = ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance")
    auto = ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance")

    hitchance = interface.no_scope_hitchance_value:get()

    if not is_scoped then
        if interface.no_scope_hitchance_distance:get() == 1000 then 
            if interface.no_scope_hitchance_weapons:get("Scout") then
                ssg:override(hitchance)
            end
            if interface.no_scope_hitchance_weapons:get("Auto") then
                auto:override(hitchance)
            end
            if interface.no_scope_hitchance_weapons:get("Awp") then
                awp:override(hitchance)
            end
        elseif misc_system.get_nearest_enemy() < interface.no_scope_hitchance_distance:get() then
            if interface.no_scope_hitchance_weapons:get("Scout") then
                ssg:override(hitchance)
            end
            if interface.no_scope_hitchance_weapons:get("Auto") then
                auto:override(hitchance)
            end
            if interface.no_scope_hitchance_weapons:get("Awp") then
                awp:override(hitchance)
            end
        else
            ssg:override(nil)
            awp:override(nil)
            auto:override(nil)
        end
    else
        ssg:override(nil)
        awp:override(nil)
        auto:override(nil)
    end

end

local tag_animation =  {
    "a ",
    "an ",
    "ant ",
    "anti ",
    "antin ",
    "antine ",
    "antinev ",
    "antineve ",
    "antinever ",
    "antineverl ",
    "antineverlo ",
    "antineverlos ",
    "antineverlose ",
    "ntineverlose ",
    "tineverlose ",
    "ineverlose ",
    "neverlose ",
    "everlose ",
    "verlose ",
    "erlose ",
    "rlose ",
    "lose ",
    "ose ",
    "se ",
    "e ",
    " "
}
local function get_tag_animation()
    if utils.net_channel() == nil then return end
    local set_tag = math.floor(math.fmod((globals.tickcount + (utils.net_channel().latency[0] / globals.tickinterval)) / 22, #tag_animation + 1) + 1)
    return tag_animation[set_tag]
end

misc_system.check_nil = nil
misc_system.clan_tag = function(tag_animation)
    if tag_animation == misc_system.check_nil then return end
    if tag_animation == nil then return end

    common.set_clan_tag(tag_animation)
    misc_system.check_nil = tag_animation
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
events.player_death:set(function(enemy)
    misc_system.trash_talk(enemy)
end)

events.createmove:set(function(cmd)
    if interface.misc_fastladder:get() then
        misc_system.fast_ladder(cmd)
    end

    antiaim_system.main()
    antiaim_system.desync_side()
    antiaim_system.anti_aim_on_use(cmd)       
    defensive_antiaim.system()
    antiaim_system.anim_update()
    antiaim_system.move_lean(cmd)
    misc_system.unmute_mute()
    break_lc.main()   
    misc_system.no_scope_hitchance()

    if interface.misc_viewmodel:get() then
        misc_system.override_viewmodel()
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end)

events.render:set(function()

    antiaim_system.visibility_manager()
    visuals_system.crosshair_indicators()
    visuals_system.custom_scope()
    visuals_system.kibit_damage()
    visuals_system.velocity_indicator:update()
    visuals_system.skeetcc_ebaniy()

    if interface.clantag:get() then
        misc_system.clan_tag(get_tag_animation())
    else
        misc_system.clan_tag(" ")
    end

    if interface.aimbotlogs_print:get("Logs") then
        refs.logs:set("Select")
    end
end)

events.round_start:set(function()
    misc_system.taskbar_notify()
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)

local config = {

    elements = {
        interface.visuals_aimbotlogs,
        interface.aimbotlogs_print,
        interface.visuals_crosshairid,
        interface.visuals_crosshairid_add_y,
        interface.visuals_gamesense,
        interface.visuals_damageid ,
        interface.visuals_damageid_pos,
        interface.visuals_velocityid,
        interface.visuals_velocityid_x ,
        interface.visuals_velocityid_y,
        interface.visuals_scopeoverlay,
        interface.visuals_scopeoverlay_gap,
        interface.visuals_scopeoverlay_line_size,       
        interface.misc_trashtalk,
        interface.misc_automuteunmute,
        interface.misc_automuteunmute_settings,
        interface.misc_automuteunmute_player,
        interface.misc_taskbarnotify,
        interface.misc_aspectratio,
        interface.misc_aspectratio_value,
        interface.misc_viewmodel,
        interface.misc_viewmodel_x,
        interface.misc_viewmodel_y,
        interface.misc_viewmodel_z,
        interface.misc_viewmodel_fov,       
        interface.misc_fastladder,        
        interface.antiaim_enable,
        interface.freestanding,
        interface.disable_yaw_modifiers,
        interface.body_freestanding,       
        interface.avoid_backstab,
        interface.manual_yaw_base,
        interface.animation,
        interface.air_legs,
        interface.ground_legs,
        interface.move_lean,
        interface.move_lean_range,
        interface.pitch_zero,
        interface.sliding_slow_walk,
        interface.breal_lc,
        interface.no_scope_hitchance,
        interface.no_scope_hitchance_weapons,
        interface.no_scope_hitchance_value,
        interface.no_scope_hitchance_distance,
        interface.air_hitchance,
        interface.air_hitchance_weapons,
        interface.air_hitchance_value,
        interface.clantag,

        condition_settings[0].defensive_aa,
        condition_settings[0].defensive_aa_pitch,
        condition_settings[0].defensive_aa_yaw,
        condition_settings[0].defensive_aa_disablers,

        condition_settings[1].defensive_aa,
        condition_settings[1].defensive_aa_pitch,
        condition_settings[1].defensive_aa_yaw,
        condition_settings[1].defensive_aa_disablers,

        condition_settings[2].defensive_aa,
        condition_settings[2].defensive_aa_pitch,
        condition_settings[2].defensive_aa_yaw,
        condition_settings[2].defensive_aa_disablers,

        condition_settings[3].defensive_aa,
        condition_settings[3].defensive_aa_pitch,
        condition_settings[3].defensive_aa_yaw,
        condition_settings[3].defensive_aa_disablers,

        condition_settings[4].defensive_aa,
        condition_settings[4].defensive_aa_pitch,
        condition_settings[4].defensive_aa_yaw,
        condition_settings[4].defensive_aa_disablers,

        condition_settings[5].defensive_aa,
        condition_settings[5].defensive_aa_pitch,
        condition_settings[5].defensive_aa_yaw,
        condition_settings[5].defensive_aa_disablers,

        condition_settings[6].defensive_aa,
        condition_settings[6].defensive_aa_pitch,
        condition_settings[6].defensive_aa_yaw,
        condition_settings[6].defensive_aa_disablers,

            condition_settings[0].pitch,        
            condition_settings[0].yaw,
            condition_settings[0].yaw_base,
            condition_settings[0].left_offset,
            condition_settings[0].right_offset,        
            condition_settings[0].yaw_modifier,        
            condition_settings[0].modifier_mode,
            condition_settings[0].modifier_offset,
            condition_settings[0].modifier_offset_left,
            condition_settings[0].modifier_offset_right,
            condition_settings[0].modifier_offset_way1,
            condition_settings[0].modifier_offset_way2,
            condition_settings[0].modifier_offset_way3,
            condition_settings[0].modifier_offset_way4,
            condition_settings[0].modifier_offset_way5,        
            condition_settings[0].body_yaw,
            condition_settings[0].freestanding,
            condition_settings[0].options,
            condition_settings[0].inventer,
            condition_settings[0].left_limit,
            condition_settings[0].right_limit,

            condition_settings[1].pitch,        
            condition_settings[1].yaw,
            condition_settings[1].yaw_base,
            condition_settings[1].left_offset,
            condition_settings[1].right_offset,        
            condition_settings[1].yaw_modifier,        
            condition_settings[1].modifier_mode,
            condition_settings[1].modifier_offset,
            condition_settings[1].modifier_offset_left,
            condition_settings[1].modifier_offset_right,
            condition_settings[1].modifier_offset_way1,
            condition_settings[1].modifier_offset_way2,
            condition_settings[1].modifier_offset_way3,
            condition_settings[1].modifier_offset_way4,
            condition_settings[1].modifier_offset_way5,        
            condition_settings[1].body_yaw,
            condition_settings[1].freestanding,
            condition_settings[1].options,
            condition_settings[1].inventer,
            condition_settings[1].left_limit,
            condition_settings[1].right_limit,

            condition_settings[2].pitch,        
            condition_settings[2].yaw,
            condition_settings[2].yaw_base,
            condition_settings[2].left_offset,
            condition_settings[2].right_offset,        
            condition_settings[2].yaw_modifier,        
            condition_settings[2].modifier_mode,
            condition_settings[2].modifier_offset,
            condition_settings[2].modifier_offset_left,
            condition_settings[2].modifier_offset_right,
            condition_settings[2].modifier_offset_way1,
            condition_settings[2].modifier_offset_way2,
            condition_settings[2].modifier_offset_way3,
            condition_settings[2].modifier_offset_way4,
            condition_settings[2].modifier_offset_way5,        
            condition_settings[2].body_yaw,
            condition_settings[2].freestanding,
            condition_settings[2].options,
            condition_settings[2].inventer,
            condition_settings[2].left_limit,
            condition_settings[2].right_limit,

            condition_settings[3].pitch,        
            condition_settings[3].yaw,
            condition_settings[3].yaw_base,
            condition_settings[3].left_offset,
            condition_settings[3].right_offset,        
            condition_settings[3].yaw_modifier,        
            condition_settings[3].modifier_mode,
            condition_settings[3].modifier_offset,
            condition_settings[3].modifier_offset_left,
            condition_settings[3].modifier_offset_right,
            condition_settings[3].modifier_offset_way1,
            condition_settings[3].modifier_offset_way2,
            condition_settings[3].modifier_offset_way3,
            condition_settings[3].modifier_offset_way4,
            condition_settings[3].modifier_offset_way5,        
            condition_settings[3].body_yaw,
            condition_settings[3].freestanding,
            condition_settings[3].options,
            condition_settings[3].inventer,
            condition_settings[3].left_limit,
            condition_settings[3].right_limit,

            condition_settings[4].pitch,        
            condition_settings[4].yaw,
            condition_settings[4].yaw_base,
            condition_settings[4].left_offset,
            condition_settings[4].right_offset,        
            condition_settings[4].yaw_modifier,        
            condition_settings[4].modifier_mode,
            condition_settings[4].modifier_offset,
            condition_settings[4].modifier_offset_left,
            condition_settings[4].modifier_offset_right,
            condition_settings[4].modifier_offset_way1,
            condition_settings[4].modifier_offset_way2,
            condition_settings[4].modifier_offset_way3,
            condition_settings[4].modifier_offset_way4,
            condition_settings[4].modifier_offset_way5,        
            condition_settings[4].body_yaw,
            condition_settings[4].freestanding,
            condition_settings[4].options,
            condition_settings[4].inventer,
            condition_settings[4].left_limit,
            condition_settings[4].right_limit,

            condition_settings[5].pitch,        
            condition_settings[5].yaw,
            condition_settings[5].yaw_base,
            condition_settings[5].left_offset,
            condition_settings[5].right_offset,        
            condition_settings[5].yaw_modifier,        
            condition_settings[5].modifier_mode,
            condition_settings[5].modifier_offset,
            condition_settings[5].modifier_offset_left,
            condition_settings[5].modifier_offset_right,
            condition_settings[5].modifier_offset_way1,
            condition_settings[5].modifier_offset_way2,
            condition_settings[5].modifier_offset_way3,
            condition_settings[5].modifier_offset_way4,
            condition_settings[5].modifier_offset_way5,        
            condition_settings[5].body_yaw,
            condition_settings[5].freestanding,
            condition_settings[5].options,
            condition_settings[5].inventer,
            condition_settings[5].left_limit,
            condition_settings[5].right_limit,

            condition_settings[6].pitch,        
            condition_settings[6].yaw,
            condition_settings[6].yaw_base,
            condition_settings[6].left_offset,
            condition_settings[6].right_offset,        
            condition_settings[6].yaw_modifier,        
            condition_settings[6].modifier_mode,
            condition_settings[6].modifier_offset,
            condition_settings[6].modifier_offset_left,
            condition_settings[6].modifier_offset_right,
            condition_settings[6].modifier_offset_way1,
            condition_settings[6].modifier_offset_way2,
            condition_settings[6].modifier_offset_way3,
            condition_settings[6].modifier_offset_way4,
            condition_settings[6].modifier_offset_way5,        
            condition_settings[6].body_yaw,
            condition_settings[6].freestanding,
            condition_settings[6].options,
            condition_settings[6].inventer,
            condition_settings[6].left_limit,
            condition_settings[6].right_limit,
    }, 
    
    colors = {      
        interface.visuals_crosshairid_main_color,
        interface.visuals_crosshairid_state_color,
        interface.visuals_crosshairid_addative_color,
        interface.visuals_crosshairid_glow_color,
        interface.visuals_scopeoverlay_color,
        interface.visuals_velocityid_color,
        interface.visuals_damageid_color,
        interface.aimbotlogs_color,
    },
}

local export_config = function()
    local export = {{}, {}}

    for _, elements in pairs(config.elements) do
        table.insert(export[1], elements:get())
    end
    
    for _, colors in pairs(config.colors) do
        table.insert(export[2], {colors:get().r, colors:get().g, colors:get().b, colors:get().a})
    end
    
    clipboard.set(base64.encode(JSON.stringify(export)))
    common.add_notify("anti neverlose", "Exported to clipboard")
end

local import_config = function(text)
    local import = function()
        some_config = JSON.parse(base64.decode(text))   
        for ftype, value in pairs(some_config) do

            ftype = ({[1] = "elements", [2] = "colors"})[ftype]

            for ftype2, value2 in pairs(value) do
                if (ftype == "elements") then
                    config[ftype][ftype2]:set(value2)
                end
                
                if (ftype == "colors") then
                    config[ftype][ftype2]:set(color(unpack(value2)))
                end
            end
        end
        common.add_notify("anti neverlose", "Imported from clipboard")
    end
    
    if not pcall(import) then
        common.add_notify("anti neverlose", "Failed to import")
    return end
end

interface.share_cfg:set_callback(function()
    export_config()
end)

interface.apply_cfg:set_callback(function()
    import_config(clipboard.get())
end)

interface.load_cfg:set_callback(function()  
    import_config([[eyIxIjp7IjEiOnRydWUsIjIiOnsiMSI6IkxvZ3MiLCIyIjoi0KFvbnNvbGUiLCIzIjoiU2NyZWVuIn0sIjMiOnRydWUsIjQiOjMwLCI1Ijp0cnVlLCI2Ijp0cnVlLCI3IjoiTGVmdCIsIjgiOnRydWUsIjkiOjgwMCwiMTAiOjEwMCwiMTEiOnRydWUsIjEyIjo1LCIxMyI6NjAsIjE0Ijp0cnVlLCIxNSI6ZmFsc2UsIjE2IjoiTXV0ZSIsIjE3IjoiRW5lbXkiLCIxOCI6ZmFsc2UsIjE5Ijp0cnVlLCIyMCI6MTYsIjIxIjp0cnVlLCIyMiI6MiwiMjMiOi00LCIyNCI6MSwiMjUiOjQxLCIyNiI6dHJ1ZSwiMjciOnRydWUsIjI4IjpmYWxzZSwiMjkiOnRydWUsIjMwIjp0cnVlLCIzMSI6dHJ1ZSwiMzIiOiJPZmYiLCIzMyI6dHJ1ZSwiMzQiOiJXYWxraW5nIiwiMzUiOiJXYWxraW5nIiwiMzYiOnRydWUsIjM3IjoxMCwiMzgiOnRydWUsIjM5Ijp0cnVlLCI0MCI6dHJ1ZSwiNDEiOnRydWUsIjQyIjp7IjEiOiJBdXRvIiwiMiI6IlNjb3V0IiwiMyI6IkF3cCJ9LCI0MyI6MjUsIjQ0IjoxMDAwLCI0NSI6dHJ1ZSwiNDYiOnsiMSI6IkFsbCJ9LCI0NyI6MjUsIjQ4Ijp0cnVlLCI0OSI6dHJ1ZSwiNTAiOnRydWUsIjUxIjoiRmFrZSBVcCIsIjUyIjoiRGlzYWJsZWQiLCI1MyI6e30sIjU0Ijp0cnVlLCI1NSI6IkZha2UgVXAiLCI1NiI6IjUtV2F5IiwiNTciOnt9LCI1OCI6ZmFsc2UsIjU5IjoiRGlzYWJsZWQiLCI2MCI6IkRpc2FibGVkIiwiNjEiOnt9LCI2MiI6ZmFsc2UsIjYzIjoiRGlzYWJsZWQiLCI2NCI6IkRpc2FibGVkIiwiNjUiOnt9LCI2NiI6ZmFsc2UsIjY3IjoiRGlzYWJsZWQiLCI2OCI6IkRpc2FibGVkIiwiNjkiOnt9LCI3MCI6dHJ1ZSwiNzEiOiJGYWtlIFVwIiwiNzIiOiI1LVdheSIsIjczIjp7fSwiNzQiOmZhbHNlLCI3NSI6IkRpc2FibGVkIiwiNzYiOiJEaXNhYmxlZCIsIjc3Ijp7fSwiNzgiOiJEb3duIiwiNzkiOiJCYWNrd2FyZCIsIjgwIjoiQXQgVGFyZ2V0IiwiODEiOjE1LCI4MiI6LTIyLCI4MyI6IkRpc2FibGVkIiwiODQiOiJEZWZhdWx0IiwiODUiOjAsIjg2IjowLCI4NyI6MCwiODgiOjAsIjg5IjowLCI5MCI6MCwiOTEiOjAsIjkyIjowLCI5MyI6dHJ1ZSwiOTQiOiJPZmYiLCI5NSI6eyIxIjoiSml0dGVyIn0sIjk2IjpmYWxzZSwiOTciOjYwLCI5OCI6NjAsIjk5IjoiRG93biIsIjEwMCI6IkJhY2t3YXJkIiwiMTAxIjoiQXQgVGFyZ2V0IiwiMTAyIjo0NiwiMTAzIjo1NiwiMTA0IjoiT2Zmc2V0IiwiMTA1IjoiSml0dGVyIiwiMTA2IjotNTUsIjEwNyI6LTU1LCIxMDgiOi02NSwiMTA5IjowLCIxMTAiOjAsIjExMSI6MCwiMTEyIjowLCIxMTMiOjAsIjExNCI6dHJ1ZSwiMTE1IjoiT2ZmIiwiMTE2Ijp7IjEiOiJKaXR0ZXIifSwiMTE3IjpmYWxzZSwiMTE4Ijo2MCwiMTE5Ijo2MCwiMTIwIjoiRGlzYWJsZWQiLCIxMjEiOiJEaXNhYmxlZCIsIjEyMiI6IkxvY2FsIFZpZXciLCIxMjMiOjAsIjEyNCI6MCwiMTI1IjoiRGlzYWJsZWQiLCIxMjYiOiJEZWZhdWx0IiwiMTI3IjowLCIxMjgiOjAsIjEyOSI6MCwiMTMwIjowLCIxMzEiOjAsIjEzMiI6MCwiMTMzIjowLCIxMzQiOjAsIjEzNSI6ZmFsc2UsIjEzNiI6Ik9mZiIsIjEzNyI6e30sIjEzOCI6ZmFsc2UsIjEzOSI6MCwiMTQwIjowLCIxNDEiOiJEb3duIiwiMTQyIjoiQmFja3dhcmQiLCIxNDMiOiJBdCBUYXJnZXQiLCIxNDQiOjQwLCIxNDUiOi00MCwiMTQ2IjoiRGlzYWJsZWQiLCIxNDciOiJEZWZhdWx0IiwiMTQ4IjowLCIxNDkiOjAsIjE1MCI6MCwiMTUxIjowLCIxNTIiOjAsIjE1MyI6MCwiMTU0IjowLCIxNTUiOjAsIjE1NiI6dHJ1ZSwiMTU3IjoiT2ZmIiwiMTU4Ijp7IjEiOiJKaXR0ZXIifSwiMTU5IjpmYWxzZSwiMTYwIjo2MCwiMTYxIjo2MCwiMTYyIjoiRG93biIsIjE2MyI6IkJhY2t3YXJkIiwiMTY0IjoiQXQgVGFyZ2V0IiwiMTY1IjoxMiwiMTY2IjotMTIsIjE2NyI6IkRpc2FibGVkIiwiMTY4IjoiRGVmYXVsdCIsIjE2OSI6MCwiMTcwIjowLCIxNzEiOjAsIjE3MiI6MCwiMTczIjowLCIxNzQiOjAsIjE3NSI6MCwiMTc2IjowLCIxNzciOnRydWUsIjE3OCI6Ik9mZiIsIjE3OSI6eyIxIjoiSml0dGVyIn0sIjE4MCI6ZmFsc2UsIjE4MSI6NjAsIjE4MiI6NjAsIjE4MyI6IkRvd24iLCIxODQiOiJCYWNrd2FyZCIsIjE4NSI6IkF0IFRhcmdldCIsIjE4NiI6LTE4LCIxODciOi0yOSwiMTg4IjoiT2Zmc2V0IiwiMTg5IjoiRGVmYXVsdCIsIjE5MCI6NTgsIjE5MSI6MCwiMTkyIjowLCIxOTMiOjAsIjE5NCI6MCwiMTk1IjowLCIxOTYiOjAsIjE5NyI6MCwiMTk4Ijp0cnVlLCIxOTkiOiJPZmYiLCIyMDAiOnsiMSI6IkppdHRlciJ9LCIyMDEiOmZhbHNlLCIyMDIiOjYwLCIyMDMiOjYwLCIyMDQiOiJEaXNhYmxlZCIsIjIwNSI6IkRpc2FibGVkIiwiMjA2IjoiTG9jYWwgVmlldyIsIjIwNyI6MCwiMjA4IjowLCIyMDkiOiJEaXNhYmxlZCIsIjIxMCI6IkRlZmF1bHQiLCIyMTEiOjAsIjIxMiI6MCwiMjEzIjowLCIyMTQiOjAsIjIxNSI6MCwiMjE2IjowLCIyMTciOjAsIjIxOCI6MCwiMjE5IjpmYWxzZSwiMjIwIjoiT2ZmIiwiMjIxIjp7fSwiMjIyIjpmYWxzZSwiMjIzIjowLCIyMjQiOjB9LCIyIjp7IjEiOnsiMSI6MjU1LCIyIjoyNTUsIjMiOjI1NSwiNCI6MjU1fSwiMiI6eyIxIjoxNzQsIjIiOjE4OSwiMyI6MjU1LCI0IjoyNTV9LCIzIjp7IjEiOjI1NSwiMiI6MjU1LCIzIjoyNTUsIjQiOjI1NX0sIjQiOnsiMSI6MjU1LCIyIjoyNTUsIjMiOjI1NSwiNCI6MjU1fSwiNSI6eyIxIjoyMDQsIjIiOjIwMywiMyI6MjAzLCI0IjoxODh9LCI2Ijp7IjEiOjE3NCwiMiI6MTg5LCIzIjoyNTUsIjQiOjI1NX0sIjciOnsiMSI6MjU1LCIyIjoyNTUsIjMiOjI1NSwiNCI6MjU1fSwiOCI6eyIxIjoxNzQsIjIiOjE4OSwiMyI6MjU1LCI0IjoyNTV9fX0=]])
end)

sidebar.main = ui.sidebar("𝘼𝙉𝙏𝙄 \aCDFFA1FF𝙉𝙀𝙑𝙀𝙍𝙇𝙊𝙎𝙀 ", "\aCDFFA1FF"..ui.get_icon("spider-black-widow"))