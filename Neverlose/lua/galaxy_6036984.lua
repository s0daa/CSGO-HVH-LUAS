-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--[[
    Coded by blameless1337
    author:youngskeet
]]


local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local MTools = require("neverlose/mtools")
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local vmt_hook = require("neverlose/vmt_hook")
local pui = require("neverlose/pui")
local renderer = require "neverlose/side_indicator"

local tabs = {
    main2 = pui.create("\f<stars> Info", "\f<stars> Main ", 1),
    main = pui.create("\f<stars> Info", "\f<rss> Recomendations ", 1),
    main1 = pui.create("\f<stars> Info", "\f<layer-plus> Configs ", 2),
    anti1 = pui.create("\f<user-shield> Anti~Aim", "\f<gear>     Enable     ", 1),
    antis = pui.create("\f<user-shield> Anti~Aim", "\f<star>     Main     ", 1),
    antic = pui.create("\f<user-shield> Anti~Aim", "\f<star>     Condition     ", 2),
    anti2 = pui.create("\f<user-shield> Anti~Aim", "\f<sliders-up>  Builder   ", 2),
    visuals = pui.create("\f<stars> Visuals", "\f<stars> Visuals ", 2),
    mod = pui.create("\f<gun> Ragebot Addons", "\f<gun> Ragebot Addons ", 1),
    misc = pui.create("\f<gears> Misc", "\f<gear> Misc ", 1),
}

local style = ui.get_style "Button"
local style_hex = style:to_hex()
tabs.main2:label(" »   Welcome, \b"..style_hex.."\bFFFFFFFF["..common.get_username().."]")
tabs.main2:label(" »   Author - \b"..style_hex.."\bFFFFFFFF[spaceX#2276]")
tabs.main2:label("\bFFFFFFFF\b"..style_hex.."[ »   Space.codes ~ galaxy]")
tabs.main2:label("\bFFFFFFFF\b"..style_hex.."[ »   Latest Update - 14.06.2023]")

tabs.main2:button(ui.get_icon('headset').."\bFFFFFFFF\b"..style_hex.."[    Discord Server   ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/fzF7pk2w3R")
end, true) 

tabs.main2:button(ui.get_icon('video').."\bFFFFFFFF\b"..style_hex.."[        Youtube        ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtube.com/@justspacex")
end, true) 

tabs.main2:button(ui.get_icon('gear').."\bFFFFFFFF\b"..style_hex.."[                        Neverlose CFG                          ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=UV6uFq")
end, true) 

local function sidebar()
    local gradient_animation = gradient.text_animate(".codes ~ galaxy", -0.57, {
        color(255, 255, 255),
        style
    })
    local gradient_animation1 = gradient.text_animate("space", 0.5, {
        color(255, 255, 255),
        style
    })
    local icon = "\a" .. style_hex .. ui.get_icon("stars")
    ui.sidebar(gradient_animation1:get_animated_text()..gradient_animation:get_animated_text(), icon)
    gradient_animation:animate()
    gradient_animation1:animate()
end

local reference = {
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hsopt = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yawmod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yawoff = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    disableyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    bodyfrees = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    removesc = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    hc = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
}

local aa_table = {}
aa_table.cond_aa = {"\vGlobal", "\vStanding", "\vRunning", "\vSlow-Walk", "\vCrouch", "\vAir", "\vAir+C", "\vFake~Lag", "\vWith Pistol"}
aa_table.cnd_aa = {"G", "S", "R", "S-W", "C", "A", "A+C", "F", "\vP"}
aa_table.enable_aa = tabs.anti1:switch("Enable \vAnti~Aim")
aa_table.condition = tabs.antic:combo("", aa_table.cond_aa):depend(aa_table.enable_aa)
aa_table.pitch = tabs.antis:combo("Pitch", reference.pitch:list()):depend(aa_table.enable_aa)
aa_table.yaw_base = tabs.antis:combo("Yaw Base", {"Backward", "At Target", "Forward", "Left", "Right"}):depend(aa_table.enable_aa)
aa_table.yaw_base_create = aa_table.yaw_base:create()
aa_table.yaw_base_disabler = aa_table.yaw_base_create:selectable("Disablers", {"Jitter", "Defensive AA", "On Freestand"}):depend(aa_table.enable_aa)
aa_table.freestanding = tabs.antis:switch("Freestanding"):depend(aa_table.enable_aa)
aa_table.frees_create = aa_table.freestanding:create()
aa_table.frees_type = aa_table.frees_create:list("", {"Default", "Edge Yaw"}):depend(aa_table.enable_aa)
aa_table.huynya_ne_nuzhnaya = tabs.antis:selectable("FakeDuck Addons", {"Edge Yaw", "Forward"}):depend(aa_table.enable_aa)
aa_table.static_frees = aa_table.frees_create:selectable("Disablers", {"Defensive AA", "Jitter", "On Manual"}):depend(aa_table.enable_aa)
aa_table.legit_aa = tabs.antis:combo("Legit Anti\v~Aim On E", {"Off", "Static", "Jitter", "Custom Desync"}):depend(aa_table.enable_aa)
aa_table.anti_backstab = tabs.antis:switch("Anti~\vBackstab"):depend(aa_table.enable_aa)
aa_table.shit_aa = tabs.antis:combo("Warmup \vAnti~Aim", {"Default", "Shit", "Disabled", "Random"}):depend(aa_table.enable_aa)
aa_table.safe_head = tabs.antis:selectable("Safe Head In Air", {"Knife", "Zeus", "Grenade", "Scout", "Awp", "Bomb C4"}):depend(aa_table.enable_aa)
aa_table.animbreaker = tabs.antis:switch("Animation Breaker"):depend(aa_table.enable_aa)
aa_table.anim_create = aa_table.animbreaker:create()
aa_table.groundbreaker = aa_table.anim_create:combo("Ground", {"Off", "Follow Direction", "Jitter", "MoonWalk"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.airbreaker = aa_table.anim_create:combo("Air", {"Off", "Static Legs", "MoonWalk"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.otherbreaker = aa_table.anim_create:selectable("Other", {"Pitch 0 On Land", "Movement Lean", "Sliding Slow-Walk"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.lean_value = aa_table.anim_create:slider("Lean Value", 0, 100, 1, "°"):depend(aa_table.enable_aa, aa_table.animbreaker, {aa_table.otherbreaker, "Movement Lean"})
aa_table.legs_value = aa_table.anim_create:slider("Jitter Legs Value", 0, 100, 1, "°"):depend(aa_table.enable_aa, aa_table.animbreaker, {aa_table.groundbreaker, "Jitter"})

local other_table = {}

other_table.fast_fall = tabs.misc:switch("\f<person-falling>  Fast Fall")

other_table.clantag = tabs.misc:switch("\f<tag>  Clantag")
other_table.nade_fix = tabs.misc:switch("\f<bomb>  Nade Fix")
other_table.nade_fix_create = other_table.nade_fix:create()
other_table.nade_fix_select = other_table.nade_fix_create:combo("Type", "Default", "Discharge"):depend(other_table.nade_fix)

other_table.trashtalk = tabs.misc:switch("\f<comment-exclamation>  TrashTalk")

other_table.fps_boost = tabs.misc:switch("\f<arrow-up-from-bracket>  Fps Boost")

other_table.fast_ladder = tabs.misc:switch("\f<water-ladder>  Fast Ladder")

other_table.shared_icon = tabs.misc:switch("\f<icons>  Shared Icon")

other_table.logs = tabs.misc:switch("\f<list>  Ragebot logs")
other_table.logs_create = other_table.logs:create()
other_table.check_print = other_table.logs_create:listable("", {"Hit", "Miss", "Anti~Bruteforce"}):depend(other_table.logs)
other_table.printconsole = other_table.logs_create:selectable("", {"Console", "Screen"}):depend(other_table.logs)
other_table.font_log = other_table.logs_create:combo("Font", {"Default", "Small", "Console", "Bold"}):depend(other_table.logs, {other_table.printconsole, "Screen"})
other_table.log_type = other_table.logs_create:list("", {"Default", "Alternative"}):depend(other_table.logs, {other_table.printconsole, "Screen"})

other_table.avoid_collision = tabs.misc:switch("\f<block-brick>  Avoid Collision")

other_table.no_fall_damage = tabs.misc:switch("\f<person-falling-burst>  No Fall Damage")

other_table.mute_unmute = tabs.misc:switch("\f<volume-xmark>  Unmute/Mute Players")
other_table.mute_unmute_create = other_table.mute_unmute:create()
other_table.mute_set = other_table.mute_unmute_create:combo("Action", {"Mute", "Unmute"}):depend(other_table.mute_unmute)
other_table.taskbar = tabs.misc:switch("\f<bell-on>  Taskbar notify on round start")


tabs.misc:button("Warmup Helper",function()
    utils.console_exec("bot_kick")
    utils.console_exec("sv_cheats 1")
    utils.console_exec("mp_roundtime_defuse 99999999999999999999")
    utils.console_exec("mp_roundtime_hostage 99999999999999999999")
    utils.console_exec("mp_roundtime 99999999999999999999")
    utils.console_exec("mp_warmup_end")
    utils.console_exec("sv_infinite_ammo 1")
    utils.console_exec("mp_maxmoney 64000")
    utils.console_exec("mp_startmoney 64000")
    utils.console_exec("ammo_grenade_limit_total 6")
    utils.console_exec("mp_buy_anywhere 1")
    utils.console_exec("sv_grenade_trajectory 1")
    utils.console_exec("sv_showimpacts_time 10")
    utils.console_exec("sv_showimpacts 1")
    utils.console_exec("sv_grenade_trajectory_time 10")
    utils.console_exec("mp_buytime 99999999999999999999")
    utils.console_exec("mp_restartgame 1")
    utils.console_exec("mp_freezetime 1")
    utils.console_exec("sv_airaccelerate 206")
    utils.console_exec("mp_respawn_on_death_ct 1")
    utils.console_exec("mp_respawn_on_death_t 1")
    utils.console_exec("sv_regeneration_force_on 1")
    utils.console_exec("bot_stop 1")    
    utils.console_exec("bot_add_ct Erik") 
end, true) 

----RAGE
other_table.ideal_tick = tabs.mod:switch("\f<circle-xmark>  IdealTick")

other_table.baim_switch = tabs.mod:switch("\f<person-military-rifle>  Baim if hp <")
other_table.baim_switch_create = other_table.baim_switch:create()
other_table.baim_select = other_table.baim_switch_create:selectable("Weapon", {"Scout", "Awp", "R8"}):depend(other_table.baim_switch)
other_table.baim_scout = other_table.baim_switch_create:slider("Scout Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "Scout"})
other_table.baim_awp = other_table.baim_switch_create:slider("Awp Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "Awp"})
other_table.baim_r8 = other_table.baim_switch_create:slider("R8 Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "R8"})

other_table.resolver = tabs.mod:switch("\f<scanner-gun>  Roll Resolver") 

other_table.jumpscout = tabs.mod:switch("\f<person-ski-jumping>  Jumpscout fix")

other_table.safe_switch = tabs.mod:switch("\f<person-rifle>  Safepoint if hp <")
other_table.safe_switch_create = other_table.safe_switch:create()
other_table.safe_select = other_table.safe_switch_create:selectable("Weapon", {"Scout", "Awp", "R8"}):depend(other_table.safe_switch)
other_table.safe_scout = other_table.safe_switch_create:slider("Scout Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "Scout"})
other_table.safe_awp = other_table.safe_switch_create:slider("Awp Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "Awp"})
other_table.safe_r8 = other_table.safe_switch_create:slider("R8 Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "R8"})

other_table.drop_nades = tabs.mod:hotkey("\f<bomb>  Fast Drop Nades")

other_table.quick_switch = tabs.mod:switch("\f<bomb>  Quick Switch Fix") 

other_table.defe_addons = tabs.mod:switch("\f<gun-squirt>  Defensive Addon")

other_table.fast_dt = tabs.mod:switch("\f<gun>  Faster Doubletap")
other_table.fast_dt_create = other_table.fast_dt:create()

other_table.fast_dt_select = other_table.fast_dt_create:slider("Speed", 15, 18):depend(other_table.fast_dt)

other_table.teleport = tabs.mod:switch("\f<transporter-1>  Auto Teleport In Air")
other_table.teleport_create = other_table.teleport:create()
other_table.teleport_delay = other_table.teleport_create:slider("Delay", 0, 20, 5):depend(other_table.teleport)
other_table.teleport_wpn = other_table.teleport_create:selectable("Weapon", {"Taser", "Knife", "Scout", "AWP", "Shotgun", "Pistols", "Bomb C4"}):depend(other_table.teleport)

other_table.auto_mp = tabs.mod:switch("\f<crosshairs>  Automatic MultiPoints")

other_table.air_switch = tabs.mod:switch("\f<person-falling>  Hitchance Manipulations")
other_table.air_switch_create = other_table.air_switch:create()
other_table.hs_select = other_table.air_switch_create:selectable("Select", {"In Air", "No Scope"}):depend(other_table.air_switch)
other_table.air_select = other_table.air_switch_create:selectable("[Air] Weapon", {"Scout", "R8", "Pistols"}):depend(other_table.air_switch, {other_table.hs_select, "In Air"})
other_table.air_scout = other_table.air_switch_create:slider("[Air] Scout HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "Scout"}, {other_table.hs_select, "In Air"})
other_table.air_awp = other_table.air_switch_create:slider("[Air] R8 HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "R8"}, {other_table.hs_select, "In Air"})
other_table.air_pistols = other_table.air_switch_create:slider("[Air] Pistols HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "Pistols"}, {other_table.hs_select, "In Air"})

other_table.scope_select = other_table.air_switch_create:selectable("[NS] Weapon", {"Scout", "Auto", "Awp"}):depend(other_table.scope_switch, {other_table.hs_select, "No Scope"})
other_table.scope_scout = other_table.air_switch_create:slider("[NS] Scout HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Scout"}, {other_table.hs_select, "No Scope"})
other_table.scope_auto = other_table.air_switch_create:slider("[NS] Auto HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Auto"}, {other_table.hs_select, "No Scope"})
other_table.scope_awp = other_table.air_switch_create:slider("[NS] Awp HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Awp"}, {other_table.hs_select, "No Scope"})

local visual_table = {}
visual_table.solus = tabs.visuals:switch("\f<list>  Solus UI")
visual_table.solus_create = visual_table.solus:create()
visual_table.additional_water = visual_table.solus_create:switch(" Additional Watermark"):depend(visual_table.solus)
visual_table.solus_select = visual_table.solus_create:listable("Windows", {"Watermark", "Keybinds", "Spectator List"}):depend(visual_table.solus)
visual_table.solus_type = visual_table.solus_create:list("Watermark Style", {"Default", "Alternative", "Modern"}):depend(visual_table.solus, {visual_table.solus_select, 1})
visual_table.soluskey_type = visual_table.solus_create:list("Keybinds Style", {"Default", "Alternative", "Modern"}):depend(visual_table.solus, {visual_table.solus_select, 2})
visual_table.solusspec_type = visual_table.solus_create:list("Speclist Style", {"Default", "Alternative", "Modern"}):depend(visual_table.solus, {visual_table.solus_select, 3})
visual_table.solus_color = visual_table.solus_create:color_picker("Color", color(163, 146, 255)):depend(visual_table.solus)
visual_table.solus_glow = visual_table.solus_create:switch("Glow"):depend(visual_table.solus)
visual_table.custom_name = visual_table.solus_create:input("Username", ""..common.get_username().."", nil, false):depend(visual_table.solus, {visual_table.solus_select, "Water\vmark"})

visual_table.snaplines = tabs.visuals:switch("\f<lines-leaning>  Snaplines")
visual_table.snaplines_create = visual_table.snaplines:create()
visual_table.snaplines_helper = visual_table.snaplines_create:switch("Revolver Helper"):depend(visual_table.snaplines)
visual_table.snaplines_color = visual_table.snaplines_create:color_picker("Color", color(255, 255, 255)):depend(visual_table.snaplines)

other_table.viewmodel = tabs.visuals:switch("\f<hands-holding>  Viewmodel")
other_table.viewmodel_create = other_table.viewmodel:create()
other_table.viewmodel_fov = other_table.viewmodel_create:slider("FOV", -100, 100, 68):depend(other_table.viewmodel)
other_table.viewmodel_x = other_table.viewmodel_create:slider("X", -10, 10, 2.5):depend(other_table.viewmodel)
other_table.viewmodel_y = other_table.viewmodel_create:slider("Y", -10, 10, 0):depend(other_table.viewmodel)
other_table.viewmodel_z = other_table.viewmodel_create:slider("Z", -10, 10, -1.5):depend(other_table.viewmodel)
other_table.aspect_ratio = tabs.visuals:switch("\f<arrows-left-right-to-line>  Aspect Ratio")
other_table.aspect_ratio_create = other_table.aspect_ratio:create()
other_table.aspect_ratio_slider = other_table.aspect_ratio_create:slider("Aspect Ratio", 0, 20, 13, 0.1):depend(other_table.aspect_ratio)

visual_table.scope = tabs.visuals:switch("\f<crosshairs>  Custom Scope")
visual_table.scope_create = visual_table.scope:create()
visual_table.scope_lines = visual_table.scope_create:selectable("Lines", {"Up", "Down", "Left", "Right"}):depend(visual_table.scope)
visual_table.scope_lines:set("Up", "Down", "Left", "Right")
visual_table.Scopeinverted = visual_table.scope_create:switch("Invert scope lines", false):depend(visual_table.scope)
visual_table.Scopelength = visual_table.scope_create:slider("Scope length", 5, 200, 55):depend(visual_table.scope)
visual_table.Scopeoffset = visual_table.scope_create:slider("Scope offset", 1, 50, 11):depend(visual_table.scope)
visual_table.scope_color = visual_table.scope_create:color_picker("Color", color(255, 255, 255)):depend(visual_table.scope)

visual_table.console_color = tabs.visuals:switch("\f<square>  Console Color")
visual_table.console_color_create = visual_table.console_color:create()
visual_table.clr_console = visual_table.console_color_create:color_picker("Color", color(100, 100, 100, 100)):depend(visual_table.console_color)

visual_table.arrows = tabs.visuals:switch("\f<arrows-left-right>  Manual Arrows")
visual_table.arrows_create = visual_table.arrows:create()
visual_table.arrows_type = visual_table.arrows_create:list("", {"Default", "Alternative"}):depend(visual_table.arrows)
visual_table.arrows_color = visual_table.arrows_create:color_picker("Color", color(134, 126, 255)):depend(visual_table.arrows)

visual_table.grenade_radius = tabs.visuals:switch("\f<circle-dashed>  Grenade Radius")
visual_table.grenade_radius_create = visual_table.grenade_radius:create()
visual_table.grenade_select = visual_table.grenade_radius_create:listable("", {"Smoke", "Molotov"}):depend(visual_table.grenade_radius)
visual_table.molotov_color = visual_table.grenade_radius_create:color_picker("Friendly Molotov Color", color(116, 192, 41, 255)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 2})
visual_table.molotov_color2 = visual_table.grenade_radius_create:color_picker("Enemy Molotov Color", color(255, 63, 63, 255)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 2})
visual_table.smoke_color = visual_table.grenade_radius_create:color_picker("Smoke Color", color(61, 147, 250, 180)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 1})

visual_table.sense_ind = tabs.visuals:switch("\f<list>  \vSense \rIndicators")
visual_table.sense_ind_create = visual_table.sense_ind:create()
visual_table.sense_select = visual_table.sense_ind_create:listable("", {"Aimbot Stats", "Freestanding", "Min. Damage", "DoubleTap", "Hit Chance", "Hideshots", "Dormant",  "Baim", "Duck", "Ping", "Safe"}):depend(visual_table.sense_ind)

visual_table.crosshair = tabs.visuals:switch("\f<star>  Crosshair Indicators")
visual_table.crosshair_create = visual_table.crosshair:create()
visual_table.crosshair_style = visual_table.crosshair_create:list("", {"Default", "Alternative", "Minimalistic"}):depend(visual_table.crosshair)
visual_table.crosshair_color1 = visual_table.crosshair_create:color_picker("First", color(68, 68, 68)):depend(visual_table.crosshair)
visual_table.crosshair_color2 = visual_table.crosshair_create:color_picker("Second", color(255, 255, 255)):depend(visual_table.crosshair)
visual_table.slowed_down = tabs.visuals:switch("\f<triangle-exclamation>  Slowed down indicator")
visual_table.slowed_down_create = visual_table.slowed_down:create()
visual_table.slowed_down_type = visual_table.slowed_down_create:list("", {"Default", "Alternative"}):depend(visual_table.slowed_down)
visual_table.slowed_down_color = visual_table.slowed_down_create:color_picker("First", color(177, 166, 237)):depend(visual_table.slowed_down)
visual_table.slowed_down_color2 = visual_table.slowed_down_create:color_picker("Second", color(107, 58, 255)):depend(visual_table.slowed_down)
visual_table.slowed_down_color3 = visual_table.slowed_down_create:color_picker("Text Color", color(255, 255, 255)):depend(visual_table.slowed_down)
visual_table.mindmg = tabs.visuals:switch("\f<eye>  Minimum damage indicator")
visual_table.mindmg_create = visual_table.mindmg:create()
visual_table.mindmg_font = visual_table.mindmg_create:combo("Font", {"Default", "Small", "Console", "Bold"}):depend(visual_table.mindmg)

other_table.aspect_ratio_create:button(" 5:4 ", function()
    other_table.aspect_ratio_slider:set(12)
end, true):depend(other_table.aspect_ratio)
other_table.aspect_ratio_create:button(" 4:3 ", function()
    other_table.aspect_ratio_slider:set(13)
end, true):depend(other_table.aspect_ratio)
other_table.aspect_ratio_create:button(" 3:2 ", function()
    other_table.aspect_ratio_slider:set(15)
end, true):depend(other_table.aspect_ratio)
other_table.aspect_ratio_create:button(" 16:10 ", function()
    other_table.aspect_ratio_slider:set(16)
end, true):depend(other_table.aspect_ratio)
other_table.aspect_ratio_create:button(" 16:9 ", function()
    other_table.aspect_ratio_slider:set(18)
end, true):depend(other_table.aspect_ratio)



antiaim_cicle = {}
for z, x in pairs(aa_table.cond_aa) do
    antiaim_cicle[z] = {}
    antiaim_cicle[z].enable = tabs.anti2:switch("Enable " .. aa_table.cond_aa[z])
    antiaim_cicle[z].yaw_type = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].yaw_type_create = antiaim_cicle[z].yaw_type:create()
    antiaim_cicle[z].delay_type = antiaim_cicle[z].yaw_type_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].delay_type_t = antiaim_cicle[z].yaw_type_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].delay_type_ms = antiaim_cicle[z].yaw_type_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].yaw_l = tabs.anti2:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].yaw_r = tabs.anti2:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jit_type = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].modifier_gear = antiaim_cicle[z].jit_type:create()
    antiaim_cicle[z].jitter_type = antiaim_cicle[z].modifier_gear:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].jitter_center = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jitter_center_left = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jitter_center_right = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].bodyyaw = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].bodyyaw_gear = antiaim_cicle[z].bodyyaw:create()
    antiaim_cicle[z].options = antiaim_cicle[z].bodyyaw_gear:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].freestand = antiaim_cicle[z].bodyyaw_gear:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].lby_l = antiaim_cicle[z].bodyyaw_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].lby_r = antiaim_cicle[z].bodyyaw_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].def_type = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].def_aa = tabs.anti2:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].def_create = antiaim_cicle[z].def_aa:create()
    antiaim_cicle[z].def_yaw_type = antiaim_cicle[z].def_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].yaw_sens = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1)
    antiaim_cicle[z].way_delay = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].way_select = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].way1 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].way2 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].way3 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].way4 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].way5 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].def_pitch_type = antiaim_cicle[z].def_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].def_pitch = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].p_way_delay = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].p_way_select = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].p_way1 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].p_way2 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].p_way3 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].p_way4 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].p_way5 = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")



    antiaim_cicle[z].ab_enable = tabs.anti2:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFAnti~Bruteforce")
    
    antiaim_cicle[z].ab_phase = tabs.anti2:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhases", 1, 10, 1)

    ----------1
    antiaim_cicle[z].ab_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 1")
    antiaim_cicle[z].ab_create = antiaim_cicle[z].ab_label:create()

    antiaim_cicle[z].ab1_yaw_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab1_delay_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab1_delay_type_t = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab1_delay_type_ms = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab1_yaw_l = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_yaw_r = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_jit_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab1_jitter_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab1_jitter_center = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_jitter_center_left = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_jitter_center_right = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_bodyyaw = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab1_options = antiaim_cicle[z].ab_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab1_freestand = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab1_lby_l = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab1_lby_r = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab1_def_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab1_def_aa = antiaim_cicle[z].ab_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab1_def_yaw_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab1_yaw_sens = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1)
    antiaim_cicle[z].ab1_way_delay = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab1_way_select = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1, "°")
    antiaim_cicle[z].ab1_way1 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_way2 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_way3 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_way4 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_way5 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab1_def_pitch_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab1_def_pitch = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab1_p_way_delay = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab1_p_way_select = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab1_p_way1 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab1_p_way2 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab1_p_way3 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab1_p_way4 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab1_p_way5 = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")


    ----2
    antiaim_cicle[z].ab2_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 2")
    antiaim_cicle[z].ab2_create = antiaim_cicle[z].ab2_label:create()

    antiaim_cicle[z].ab2_yaw_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab2_delay_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab2_delay_type_t = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab2_delay_type_ms = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab2_yaw_l = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_yaw_r = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_jit_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab2_jitter_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab2_jitter_center = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_jitter_center_left = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_jitter_center_right = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_bodyyaw = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab2_options = antiaim_cicle[z].ab2_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab2_freestand = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab2_lby_l = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab2_lby_r = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab2_def_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab2_def_aa = antiaim_cicle[z].ab2_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab2_def_yaw_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab2_yaw_sens = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab2_way_delay = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab2_way_select = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab2_way1 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_way2 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_way3 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_way4 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_way5 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab2_def_pitch_type = antiaim_cicle[z].ab2_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab2_def_pitch = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab2_p_way_delay = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab2_p_way_select = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab2_p_way1 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab2_p_way2 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab2_p_way3 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab2_p_way4 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab2_p_way5 = antiaim_cicle[z].ab2_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab3
    antiaim_cicle[z].ab3_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 3")
    antiaim_cicle[z].ab3_create = antiaim_cicle[z].ab3_label:create()

    antiaim_cicle[z].ab3_yaw_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab3_delay_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab3_delay_type_t = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab3_delay_type_ms = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab3_yaw_l = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_yaw_r = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_jit_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab3_jitter_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab3_jitter_center = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_jitter_center_left = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_jitter_center_right = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_bodyyaw = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab3_options = antiaim_cicle[z].ab3_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab3_freestand = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab3_lby_l = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab3_lby_r = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab3_def_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab3_def_aa = antiaim_cicle[z].ab3_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab3_def_yaw_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab3_yaw_sens = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab3_way_delay = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab3_way_select = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab3_way1 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_way2 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_way3 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_way4 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_way5 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab3_def_pitch_type = antiaim_cicle[z].ab3_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab3_def_pitch = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab3_p_way_delay = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab3_p_way_select = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab3_p_way1 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab3_p_way2 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab3_p_way3 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab3_p_way4 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab3_p_way5 = antiaim_cicle[z].ab3_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

        ---ab4
    antiaim_cicle[z].ab4_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 4")
    antiaim_cicle[z].ab4_create = antiaim_cicle[z].ab4_label:create()
    
    antiaim_cicle[z].ab4_yaw_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab4_delay_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab4_delay_type_t = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab4_delay_type_ms = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab4_yaw_l = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_yaw_r = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_jit_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab4_jitter_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab4_jitter_center = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_jitter_center_left = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_jitter_center_right = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_bodyyaw = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab4_options = antiaim_cicle[z].ab4_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab4_freestand = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab4_lby_l = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab4_lby_r = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab4_def_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab4_def_aa = antiaim_cicle[z].ab4_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab4_def_yaw_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab4_yaw_sens = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab4_way_delay = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab4_way_select = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab4_way1 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_way2 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_way3 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_way4 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_way5 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab4_def_pitch_type = antiaim_cicle[z].ab4_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab4_def_pitch = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab4_p_way_delay = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab4_p_way_select = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab4_p_way1 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab4_p_way2 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab4_p_way3 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab4_p_way4 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab4_p_way5 = antiaim_cicle[z].ab4_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab5
    antiaim_cicle[z].ab5_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 5")
    antiaim_cicle[z].ab5_create = antiaim_cicle[z].ab5_label:create()
            
    antiaim_cicle[z].ab5_yaw_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab5_delay_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab5_delay_type_t = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab5_delay_type_ms = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab5_yaw_l = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_yaw_r = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_jit_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab5_jitter_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab5_jitter_center = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_jitter_center_left = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_jitter_center_right = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_bodyyaw = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab5_options = antiaim_cicle[z].ab5_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab5_freestand = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab5_lby_l = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab5_lby_r = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab5_def_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab5_def_aa = antiaim_cicle[z].ab5_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab5_def_yaw_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab5_yaw_sens = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab5_way_delay = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab5_way_select = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab5_way1 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_way2 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_way3 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_way4 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_way5 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab5_def_pitch_type = antiaim_cicle[z].ab5_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab5_def_pitch = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab5_p_way_delay = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab5_p_way_select = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab5_p_way1 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab5_p_way2 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab5_p_way3 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab5_p_way4 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab5_p_way5 = antiaim_cicle[z].ab5_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

        ---ab6
    antiaim_cicle[z].ab6_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 6")
    antiaim_cicle[z].ab6_create = antiaim_cicle[z].ab6_label:create()
                
    antiaim_cicle[z].ab6_yaw_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab6_delay_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab6_delay_type_t = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab6_delay_type_ms = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab6_yaw_l = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_yaw_r = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_jit_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab6_jitter_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab6_jitter_center = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_jitter_center_left = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_jitter_center_right = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_bodyyaw = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab6_options = antiaim_cicle[z].ab6_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab6_freestand = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab6_lby_l = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab6_lby_r = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab6_def_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab6_def_aa = antiaim_cicle[z].ab6_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab6_def_yaw_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab6_yaw_sens = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab6_way_delay = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab6_way_select = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab6_way1 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_way2 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_way3 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_way4 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_way5 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab6_def_pitch_type = antiaim_cicle[z].ab6_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab6_def_pitch = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab6_p_way_delay = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab6_p_way_select = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab6_p_way1 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab6_p_way2 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab6_p_way3 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab6_p_way4 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab6_p_way5 = antiaim_cicle[z].ab6_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab7
    antiaim_cicle[z].ab7_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 7")
    antiaim_cicle[z].ab7_create = antiaim_cicle[z].ab7_label:create()
                        
    antiaim_cicle[z].ab7_yaw_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab7_delay_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab7_delay_type_t = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab7_delay_type_ms = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab7_yaw_l = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_yaw_r = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_jit_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab7_jitter_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab7_jitter_center = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_jitter_center_left = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_jitter_center_right = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_bodyyaw = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab7_options = antiaim_cicle[z].ab7_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab7_freestand = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab7_lby_l = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab7_lby_r = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab7_def_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab7_def_aa = antiaim_cicle[z].ab7_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab7_def_yaw_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab7_yaw_sens = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab7_way_delay = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab7_way_select = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab7_way1 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_way2 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_way3 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_way4 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_way5 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab7_def_pitch_type = antiaim_cicle[z].ab7_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab7_def_pitch = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab7_p_way_delay = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab7_p_way_select = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab7_p_way1 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab7_p_way2 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab7_p_way3 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab7_p_way4 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab7_p_way5 = antiaim_cicle[z].ab7_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab8
    antiaim_cicle[z].ab8_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 8")
    antiaim_cicle[z].ab8_create = antiaim_cicle[z].ab8_label:create()

    antiaim_cicle[z].ab8_yaw_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab8_delay_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab8_delay_type_t = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab8_delay_type_ms = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab8_yaw_l = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_yaw_r = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_jit_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab8_jitter_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab8_jitter_center = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_jitter_center_left = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_jitter_center_right = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_bodyyaw = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab8_options = antiaim_cicle[z].ab8_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab8_freestand = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab8_lby_l = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab8_lby_r = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab8_def_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab8_def_aa = antiaim_cicle[z].ab8_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab8_def_yaw_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab8_yaw_sens = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab8_way_delay = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab8_way_select = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab8_way1 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_way2 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_way3 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_way4 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_way5 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab8_def_pitch_type = antiaim_cicle[z].ab8_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab8_def_pitch = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab8_p_way_delay = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab8_p_way_select = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab8_p_way1 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab8_p_way2 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab8_p_way3 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab8_p_way4 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab8_p_way5 = antiaim_cicle[z].ab8_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab9
    antiaim_cicle[z].ab9_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 9")
    antiaim_cicle[z].ab9_create = antiaim_cicle[z].ab9_label:create()

    antiaim_cicle[z].ab9_yaw_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab9_delay_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab9_delay_type_t = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab9_delay_type_ms = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab9_yaw_l = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_yaw_r = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_jit_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab9_jitter_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab9_jitter_center = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_jitter_center_left = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_jitter_center_right = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_bodyyaw = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab9_options = antiaim_cicle[z].ab9_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab9_freestand = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab9_lby_l = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab9_lby_r = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab9_def_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab9_def_aa = antiaim_cicle[z].ab9_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab9_def_yaw_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab9_yaw_sens = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab9_way_delay = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab9_way_select = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab9_way1 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_way2 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_way3 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_way4 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_way5 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab9_def_pitch_type = antiaim_cicle[z].ab9_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab9_def_pitch = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab9_p_way_delay = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab9_p_way_select = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab9_p_way1 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab9_p_way2 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab9_p_way3 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab9_p_way4 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab9_p_way5 = antiaim_cicle[z].ab9_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")

    ---ab10
    antiaim_cicle[z].ab10_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 10")
    antiaim_cicle[z].ab10_create = antiaim_cicle[z].ab10_label:create()

    antiaim_cicle[z].ab10_yaw_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch", "Delay Yaw"})
    antiaim_cicle[z].ab10_delay_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Ticks", "MS"})
    antiaim_cicle[z].ab10_delay_type_t = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFTicks", 1, 5, 0, 1, " t")
    antiaim_cicle[z].ab10_delay_type_ms = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay", 1, 100, 0, 1, " ms")
    antiaim_cicle[z].ab10_yaw_l = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_yaw_r = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_jit_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab10_jitter_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab10_jitter_center = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_jitter_center_left = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_jitter_center_right = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_bodyyaw = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw", {"Off", "Default", "Custom"})
    antiaim_cicle[z].ab10_options = antiaim_cicle[z].ab10_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab10_freestand = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab10_lby_l = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab10_lby_r = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab10_def_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBreak LC", {"Off", "On Peek", "Always On", "Hittable"})
    antiaim_cicle[z].ab10_def_aa = antiaim_cicle[z].ab10_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab10_def_yaw_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Hidden", "Custom", "Spin", "180Z", "Side-Ways", "Custom Ways"})
    antiaim_cicle[z].ab10_yaw_sens = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab10_way_delay = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab10_way_select = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab10_way1 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #1", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_way2 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #2", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_way3 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #3", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_way4 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #4", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_way5 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Y ~ Way #5", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab10_def_pitch_type = antiaim_cicle[z].ab10_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom", "Progressive", "Custom Ways"})
    antiaim_cicle[z].ab10_def_pitch = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab10_p_way_delay = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Delay", 1, 5, 0, 1)
    antiaim_cicle[z].ab10_p_way_select = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Ways", 1, 5, 0, 1)
    antiaim_cicle[z].ab10_p_way1 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #1", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab10_p_way2 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #2", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab10_p_way3 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #3", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab10_p_way4 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #4", -89, 89, 0, 1, "°")
    antiaim_cicle[z].ab10_p_way5 = antiaim_cicle[z].ab10_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF P ~ Way #5", -89, 89, 0, 1, "°")
end

local ab_enabler_check = false
local maxphase = 1
currentphase = 0
time_antibrute = globals.realtime
last_antibrute = globals.realtime
events.bullet_impact:set(function(e)
    if entity.get_local_player() == nil or not entity.get_local_player():is_alive() then return end
    if not aa_table.enable_aa:get() then return end
    playerb = entity.get_local_player()
    if playerb == nil then return end
    if not playerb:is_alive() then return end
    local player = entity.get(e.userid, true)
    if player == nil then return end
    if not player:is_enemy() then return end
    if entity.get_threat(true) == nil then return end
    if entity.get_threat(true):get_index() ~= player:get_index() then return end
    local s_pos = vector(e.x, e.y, e.z)
    local enemy_angles = (s_pos - player:get_hitbox_position(0)):angles()
    local angles = ((playerb:get_hitbox_position(3) - player:get_hitbox_position(0)):angles() - enemy_angles)
    angles.y = math.clamp(angles.y, -180, 180)
    local fov = math.sqrt(angles.y*angles.y + angles.x*angles.x)
    if fov < 10 and last_antibrute + 0.1 < globals.realtime then
        if ab_enabler_check == true then
            currentphase = currentphase + 1
            if currentphase > maxphase then
                currentphase = 1
            end
            if other_table.check_print:get(3) and other_table.printconsole:get("Screen") then
                render.log("Anti~Bruteforce Switched Due To \a74FF34FF"..player:get_name().." \aFFFFFFFFShot. Phase: "..currentphase)
            end
            time_antibrute = globals.realtime
            last_antibrute = globals.realtime + 0.1
        end
    end
end)


tick_switch = 0
yaw_adds = 0
spin_adds = 0
sto_adds = 0

local function current_state()
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = bit.band(local_player.m_fFlags, 1) == 0
    crouch = local_player.m_flDuckAmount > 0.6
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    move = math.sqrt(vx ^ 2 + vy ^ 2) > 5
    if jump and crouch then return "Air+C" end
    if jump then return "Air" end
    if crouch then return "Ducking" end
    if on_ground and reference.slow:get() and move then return "Walking" end
    if on_ground and not move then return "Standing" end
    if on_ground and move then return "Running" end
end

local function edge_yaw_func()
    local lp = entity.get_local_player()
    if (lp == nil or not lp:is_alive()) then return end
    end_point = {}
    dist_to_wall = {}
    eye_pos = lp:get_eye_position()
    for max_yaw = 18, 360, 18 do
        max_yaw = math.normalize_yaw(max_yaw)
        last_trace = eye_pos + vector():angles(0, max_yaw) * 198
        trace_eye = utils.trace_line(eye_pos, last_trace, lp, 0x200400B)
        table.insert(dist_to_wall, eye_pos:dist(trace_eye.end_pos))
        if trace_eye.fraction < 0.3 then
            end_point[#end_point+1] = {last_trace = last_trace, max_yaw = max_yaw}
        end
    end
    table.sort(dist_to_wall)
    if dist_to_wall[1] < 45 then
        table.sort(end_point, function(z, x) return x.max_yaw > z.max_yaw end)
        if #end_point > 2 then
            edge_angle = (eye_pos - (end_point[1].last_trace/2)):angles()
        end
        if edge_angle then
            normas_edge = math.normalize_yaw(edge_angle.y - render.camera_angles().y)
            if math.abs(normas_edge) <= 89 then 
                normas_edge = 0
                render.camera_angles().y = math.normalize_yaw(edge_angle.y + 180)
            end
            new_max_yaw = -(render.camera_angles().y)
            new_max_yaw = math.normalize_yaw(new_max_yaw + edge_angle.y + normas_edge + 180)
            func_return = new_max_yaw
        end
        return func_return
    end
end
cur_time = 0
local function legit_func(cmd)
    local local_player = entity.get_local_player()
    if (local_player == nil or not local_player:is_alive()) then return end
    check_legit = true
    local teamnum = local_player.m_iTeamNum
    for _, entities in pairs({entity.get_entities("CPlantedC4"), entity.get_entities("CHostage")}) do
        for _, entity in pairs(entities) do
            local origin = local_player:get_origin() 
            local entity_origin = entity:get_origin()
            local ent_distance = origin:dist(entity_origin) 
            local distance = ent_distance < 65 and ent_distance > 1 
            if distance and teamnum == 3 then 
                check_legit = false 
            end
        end
    end
    if teamnum == 2 and local_player.m_bInBombZone then
        check_legit = false 
    end
    if bit.band(cmd.buttons, 32) == 32 and check_legit then 
        if globals.curtime - cur_time > 0.02 then
            cmd.buttons = bit.band(cmd.buttons, bit.bnot(32)) 
            if set_legit then
                set_legit = false
            end
        end
    else
        if not set_legit then
            set_legit = true
        end
        cur_time = globals.curtime
    end
end
delay_way = 0
delay_way1 = 0
pitch_ads = 0

local function aa_setup(cmd)
    reference.enable:set(aa_table.enable_aa:get())
    if not aa_table.enable_aa:get() then return end
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    pistol_cnd = false
    local selected = local_player:get_player_weapon()
    if selected ~= nil then
        weapon = selected:get_classname()
        pistol_cnd = (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "DEagle") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000"))
    end

    cond_ps = antiaim_cicle[9].enable:get() and pistol_cnd

    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = bit.band(local_player.m_fFlags, 1) == 0
    crouch = local_player.m_flDuckAmount > 0.5
    vx, vy = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y
    move = math.sqrt(vx ^ 2 + vy ^ 2) > 5
    if antiaim_cicle[2].enable:get() and current_state() == "Standing" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) and not cond_ps then id = 2
    elseif antiaim_cicle[3].enable:get() and current_state() == "Running" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) and not cond_ps then id = 3
    elseif antiaim_cicle[4].enable:get() and current_state() == "Walking" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) and not cond_ps then id = 4
    elseif antiaim_cicle[5].enable:get() and current_state() == "Ducking" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) and not cond_ps then id = 5
    elseif antiaim_cicle[6].enable:get() and current_state() == "Air" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9)  and not cond_ps then id = 6
    elseif antiaim_cicle[7].enable:get() and current_state() == "Air+C" and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) and not cond_ps then id = 7
    elseif antiaim_cicle[8].enable:get() and (rage.exploit:get() < 0.9) and rage.exploit:get() < 0.9 then id = 8 --fl
    elseif cond_ps then id = 9
    else
        id = 1
    end
    if antiaim_cicle[id].ab_enable:get() then
        ab_enabler_check = true
    else
        ab_enabler_check = false
    end

    maxphase = antiaim_cicle[id].ab_phase:get()

    if (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 1 then
        yaw_type = antiaim_cicle[id].ab1_yaw_type:get()
        delay_type = antiaim_cicle[id].ab1_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab1_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab1_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab1_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab1_yaw_r:get()
        jit_type = antiaim_cicle[id].ab1_jit_type:get()
        jitter_type = antiaim_cicle[id].ab1_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab1_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab1_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab1_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab1_bodyyaw:get()
        options = antiaim_cicle[id].ab1_options:get()
        freestand = antiaim_cicle[id].ab1_freestand:get()
        lby_l = antiaim_cicle[id].ab1_lby_l:get()
        lby_r = antiaim_cicle[id].ab1_lby_r:get()
        def_type = antiaim_cicle[id].ab1_def_type:get()
        def_aa = antiaim_cicle[id].ab1_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab1_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab1_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab1_way_delay:get()
        way_select = antiaim_cicle[id].ab1_way_select:get()
        way1 = antiaim_cicle[id].ab1_way1:get()
        way2 = antiaim_cicle[id].ab1_way2:get()
        way3 = antiaim_cicle[id].ab1_way3:get()
        way4 = antiaim_cicle[id].ab1_way4:get()
        way5 = antiaim_cicle[id].ab1_way5:get()
        def_pitch_type = antiaim_cicle[id].ab1_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab1_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab1_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab1_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab1_p_way1:get()
        p_way2 = antiaim_cicle[id].ab1_p_way2:get()
        p_way3 = antiaim_cicle[id].ab1_p_way3:get()
        p_way4 = antiaim_cicle[id].ab1_p_way4:get()
        p_way5 = antiaim_cicle[id].ab1_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 2 then
        yaw_type = antiaim_cicle[id].ab2_yaw_type:get()
        delay_type = antiaim_cicle[id].ab2_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab2_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab2_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab2_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab2_yaw_r:get()
        jit_type = antiaim_cicle[id].ab2_jit_type:get()
        jitter_type = antiaim_cicle[id].ab2_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab2_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab2_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab2_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab2_bodyyaw:get()
        options = antiaim_cicle[id].ab2_options:get()
        freestand = antiaim_cicle[id].ab2_freestand:get()
        lby_l = antiaim_cicle[id].ab2_lby_l:get()
        lby_r = antiaim_cicle[id].ab2_lby_r:get()
        def_type = antiaim_cicle[id].ab2_def_type:get()
        def_aa = antiaim_cicle[id].ab2_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab2_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab2_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab2_way_delay:get()
        way_select = antiaim_cicle[id].ab2_way_select:get()
        way1 = antiaim_cicle[id].ab2_way1:get()
        way2 = antiaim_cicle[id].ab2_way2:get()
        way3 = antiaim_cicle[id].ab2_way3:get()
        way4 = antiaim_cicle[id].ab2_way4:get()
        way5 = antiaim_cicle[id].ab2_way5:get()
        def_pitch_type = antiaim_cicle[id].ab2_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab2_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab2_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab2_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab2_p_way1:get()
        p_way2 = antiaim_cicle[id].ab2_p_way2:get()
        p_way3 = antiaim_cicle[id].ab2_p_way3:get()
        p_way4 = antiaim_cicle[id].ab2_p_way4:get()
        p_way5 = antiaim_cicle[id].ab2_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 3 then
        yaw_type = antiaim_cicle[id].ab3_yaw_type:get()
        delay_type = antiaim_cicle[id].ab3_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab3_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab3_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab3_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab3_yaw_r:get()
        jit_type = antiaim_cicle[id].ab3_jit_type:get()
        jitter_type = antiaim_cicle[id].ab3_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab3_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab3_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab3_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab3_bodyyaw:get()
        options = antiaim_cicle[id].ab3_options:get()
        freestand = antiaim_cicle[id].ab3_freestand:get()
        lby_l = antiaim_cicle[id].ab3_lby_l:get()
        lby_r = antiaim_cicle[id].ab3_lby_r:get()
        def_type = antiaim_cicle[id].ab3_def_type:get()
        def_aa = antiaim_cicle[id].ab3_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab3_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab3_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab3_way_delay:get()
        way_select = antiaim_cicle[id].ab3_way_select:get()
        way1 = antiaim_cicle[id].ab3_way1:get()
        way2 = antiaim_cicle[id].ab3_way2:get()
        way3 = antiaim_cicle[id].ab3_way3:get()
        way4 = antiaim_cicle[id].ab3_way4:get()
        way5 = antiaim_cicle[id].ab3_way5:get()
        def_pitch_type = antiaim_cicle[id].ab3_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab3_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab3_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab3_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab3_p_way1:get()
        p_way2 = antiaim_cicle[id].ab3_p_way2:get()
        p_way3 = antiaim_cicle[id].ab3_p_way3:get()
        p_way4 = antiaim_cicle[id].ab3_p_way4:get()
        p_way5 = antiaim_cicle[id].ab3_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 4 then
        yaw_type = antiaim_cicle[id].ab4_yaw_type:get()
        delay_type = antiaim_cicle[id].ab4_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab4_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab4_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab4_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab4_yaw_r:get()
        jit_type = antiaim_cicle[id].ab4_jit_type:get()
        jitter_type = antiaim_cicle[id].ab4_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab4_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab4_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab4_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab4_bodyyaw:get()
        options = antiaim_cicle[id].ab4_options:get()
        freestand = antiaim_cicle[id].ab4_freestand:get()
        lby_l = antiaim_cicle[id].ab4_lby_l:get()
        lby_r = antiaim_cicle[id].ab4_lby_r:get()
        def_type = antiaim_cicle[id].ab4_def_type:get()
        def_aa = antiaim_cicle[id].ab4_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab4_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab4_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab4_way_delay:get()
        way_select = antiaim_cicle[id].ab4_way_select:get()
        way1 = antiaim_cicle[id].ab4_way1:get()
        way2 = antiaim_cicle[id].ab4_way2:get()
        way3 = antiaim_cicle[id].ab4_way3:get()
        way4 = antiaim_cicle[id].ab4_way4:get()
        way5 = antiaim_cicle[id].ab4_way5:get()
        def_pitch_type = antiaim_cicle[id].ab4_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab4_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab4_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab4_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab4_p_way1:get()
        p_way2 = antiaim_cicle[id].ab4_p_way2:get()
        p_way3 = antiaim_cicle[id].ab4_p_way3:get()
        p_way4 = antiaim_cicle[id].ab4_p_way4:get()
        p_way5 = antiaim_cicle[id].ab4_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 5 then
        yaw_type = antiaim_cicle[id].ab5_yaw_type:get()
        delay_type = antiaim_cicle[id].ab5_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab5_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab5_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab5_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab5_yaw_r:get()
        jit_type = antiaim_cicle[id].ab5_jit_type:get()
        jitter_type = antiaim_cicle[id].ab5_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab5_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab5_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab5_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab5_bodyyaw:get()
        options = antiaim_cicle[id].ab5_options:get()
        freestand = antiaim_cicle[id].ab5_freestand:get()
        lby_l = antiaim_cicle[id].ab5_lby_l:get()
        lby_r = antiaim_cicle[id].ab5_lby_r:get()
        def_type = antiaim_cicle[id].ab5_def_type:get()
        def_aa = antiaim_cicle[id].ab5_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab5_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab5_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab5_way_delay:get()
        way_select = antiaim_cicle[id].ab5_way_select:get()
        way1 = antiaim_cicle[id].ab5_way1:get()
        way2 = antiaim_cicle[id].ab5_way2:get()
        way3 = antiaim_cicle[id].ab5_way3:get()
        way4 = antiaim_cicle[id].ab5_way4:get()
        way5 = antiaim_cicle[id].ab5_way5:get()
        def_pitch_type = antiaim_cicle[id].ab5_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab5_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab5_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab5_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab5_p_way1:get()
        p_way2 = antiaim_cicle[id].ab5_p_way2:get()
        p_way3 = antiaim_cicle[id].ab5_p_way3:get()
        p_way4 = antiaim_cicle[id].ab5_p_way4:get()
        p_way5 = antiaim_cicle[id].ab5_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 6 then
        yaw_type = antiaim_cicle[id].ab6_yaw_type:get()
        delay_type = antiaim_cicle[id].ab6_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab6_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab6_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab6_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab6_yaw_r:get()
        jit_type = antiaim_cicle[id].ab6_jit_type:get()
        jitter_type = antiaim_cicle[id].ab6_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab6_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab6_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab6_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab6_bodyyaw:get()
        options = antiaim_cicle[id].ab6_options:get()
        freestand = antiaim_cicle[id].ab6_freestand:get()
        lby_l = antiaim_cicle[id].ab6_lby_l:get()
        lby_r = antiaim_cicle[id].ab6_lby_r:get()
        def_type = antiaim_cicle[id].ab6_def_type:get()
        def_aa = antiaim_cicle[id].ab6_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab6_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab6_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab6_way_delay:get()
        way_select = antiaim_cicle[id].ab6_way_select:get()
        way1 = antiaim_cicle[id].ab6_way1:get()
        way2 = antiaim_cicle[id].ab6_way2:get()
        way3 = antiaim_cicle[id].ab6_way3:get()
        way4 = antiaim_cicle[id].ab6_way4:get()
        way5 = antiaim_cicle[id].ab6_way5:get()
        def_pitch_type = antiaim_cicle[id].ab6_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab6_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab6_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab6_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab6_p_way1:get()
        p_way2 = antiaim_cicle[id].ab6_p_way2:get()
        p_way3 = antiaim_cicle[id].ab6_p_way3:get()
        p_way4 = antiaim_cicle[id].ab6_p_way4:get()
        p_way5 = antiaim_cicle[id].ab6_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 7 then
        yaw_type = antiaim_cicle[id].ab7_yaw_type:get()
        delay_type = antiaim_cicle[id].ab7_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab7_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab7_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab7_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab7_yaw_r:get()
        jit_type = antiaim_cicle[id].ab7_jit_type:get()
        jitter_type = antiaim_cicle[id].ab7_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab7_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab7_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab7_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab7_bodyyaw:get()
        options = antiaim_cicle[id].ab7_options:get()
        freestand = antiaim_cicle[id].ab7_freestand:get()
        lby_l = antiaim_cicle[id].ab7_lby_l:get()
        lby_r = antiaim_cicle[id].ab7_lby_r:get()
        def_type = antiaim_cicle[id].ab7_def_type:get()
        def_aa = antiaim_cicle[id].ab7_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab7_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab7_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab7_way_delay:get()
        way_select = antiaim_cicle[id].ab7_way_select:get()
        way1 = antiaim_cicle[id].ab7_way1:get()
        way2 = antiaim_cicle[id].ab7_way2:get()
        way3 = antiaim_cicle[id].ab7_way3:get()
        way4 = antiaim_cicle[id].ab7_way4:get()
        way5 = antiaim_cicle[id].ab7_way5:get()
        def_pitch_type = antiaim_cicle[id].ab7_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab7_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab7_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab7_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab7_p_way1:get()
        p_way2 = antiaim_cicle[id].ab7_p_way2:get()
        p_way3 = antiaim_cicle[id].ab7_p_way3:get()
        p_way4 = antiaim_cicle[id].ab7_p_way4:get()
        p_way5 = antiaim_cicle[id].ab7_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 8 then
        yaw_type = antiaim_cicle[id].ab8_yaw_type:get()
        delay_type = antiaim_cicle[id].ab8_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab8_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab8_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab8_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab8_yaw_r:get()
        jit_type = antiaim_cicle[id].ab8_jit_type:get()
        jitter_type = antiaim_cicle[id].ab8_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab8_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab8_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab8_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab8_bodyyaw:get()
        options = antiaim_cicle[id].ab8_options:get()
        freestand = antiaim_cicle[id].ab8_freestand:get()
        lby_l = antiaim_cicle[id].ab8_lby_l:get()
        lby_r = antiaim_cicle[id].ab8_lby_r:get()
        def_type = antiaim_cicle[id].ab8_def_type:get()
        def_aa = antiaim_cicle[id].ab8_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab8_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab8_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab8_way_delay:get()
        way_select = antiaim_cicle[id].ab8_way_select:get()
        way1 = antiaim_cicle[id].ab8_way1:get()
        way2 = antiaim_cicle[id].ab8_way2:get()
        way3 = antiaim_cicle[id].ab8_way3:get()
        way4 = antiaim_cicle[id].ab8_way4:get()
        way5 = antiaim_cicle[id].ab8_way5:get()
        def_pitch_type = antiaim_cicle[id].ab8_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab8_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab8_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab8_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab8_p_way1:get()
        p_way2 = antiaim_cicle[id].ab8_p_way2:get()
        p_way3 = antiaim_cicle[id].ab8_p_way3:get()
        p_way4 = antiaim_cicle[id].ab8_p_way4:get()
        p_way5 = antiaim_cicle[id].ab8_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 9 then
        yaw_type = antiaim_cicle[id].ab9_yaw_type:get()
        delay_type = antiaim_cicle[id].ab9_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab9_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab9_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab9_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab9_yaw_r:get()
        jit_type = antiaim_cicle[id].ab9_jit_type:get()
        jitter_type = antiaim_cicle[id].ab9_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab9_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab9_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab9_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab9_bodyyaw:get()
        options = antiaim_cicle[id].ab9_options:get()
        freestand = antiaim_cicle[id].ab9_freestand:get()
        lby_l = antiaim_cicle[id].ab9_lby_l:get()
        lby_r = antiaim_cicle[id].ab9_lby_r:get()
        def_type = antiaim_cicle[id].ab9_def_type:get()
        def_aa = antiaim_cicle[id].ab9_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab9_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab9_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab9_way_delay:get()
        way_select = antiaim_cicle[id].ab9_way_select:get()
        way1 = antiaim_cicle[id].ab9_way1:get()
        way2 = antiaim_cicle[id].ab9_way2:get()
        way3 = antiaim_cicle[id].ab9_way3:get()
        way4 = antiaim_cicle[id].ab9_way4:get()
        way5 = antiaim_cicle[id].ab9_way5:get()
        def_pitch_type = antiaim_cicle[id].ab9_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab9_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab9_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab9_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab9_p_way1:get()
        p_way2 = antiaim_cicle[id].ab9_p_way2:get()
        p_way3 = antiaim_cicle[id].ab9_p_way3:get()
        p_way4 = antiaim_cicle[id].ab9_p_way4:get()
        p_way5 = antiaim_cicle[id].ab9_p_way5:get()
    elseif (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) and currentphase == 10 then
        yaw_type = antiaim_cicle[id].ab10_yaw_type:get()
        delay_type = antiaim_cicle[id].ab10_delay_type:get()
        delay_type_t = antiaim_cicle[id].ab10_delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].ab10_delay_type_ms:get()
        yaw_l = antiaim_cicle[id].ab10_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab10_yaw_r:get()
        jit_type = antiaim_cicle[id].ab10_jit_type:get()
        jitter_type = antiaim_cicle[id].ab10_jitter_type:get()
        jitter_center = antiaim_cicle[id].ab10_jitter_center:get()
        jitter_center_left = antiaim_cicle[id].ab10_jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].ab10_jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].ab10_bodyyaw:get()
        options = antiaim_cicle[id].ab10_options:get()
        freestand = antiaim_cicle[id].ab10_freestand:get()
        lby_l = antiaim_cicle[id].ab10_lby_l:get()
        lby_r = antiaim_cicle[id].ab10_lby_r:get()
        def_type = antiaim_cicle[id].ab10_def_type:get()
        def_aa = antiaim_cicle[id].ab10_def_aa:get()
        def_yaw_type = antiaim_cicle[id].ab10_def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].ab10_yaw_sens:get()
        way_delay = antiaim_cicle[id].ab10_way_delay:get()
        way_select = antiaim_cicle[id].ab10_way_select:get()
        way1 = antiaim_cicle[id].ab10_way1:get()
        way2 = antiaim_cicle[id].ab10_way2:get()
        way3 = antiaim_cicle[id].ab10_way3:get()
        way4 = antiaim_cicle[id].ab10_way4:get()
        way5 = antiaim_cicle[id].ab10_way5:get()
        def_pitch_type = antiaim_cicle[id].ab10_def_pitch_type:get()
        def_pitch = antiaim_cicle[id].ab10_def_pitch:get()
        p_way_delay = antiaim_cicle[id].ab10_p_way_delay:get()
        p_way_select = antiaim_cicle[id].ab10_p_way_select:get()
        p_way1 = antiaim_cicle[id].ab10_p_way1:get()
        p_way2 = antiaim_cicle[id].ab10_p_way2:get()
        p_way3 = antiaim_cicle[id].ab10_p_way3:get()
        p_way4 = antiaim_cicle[id].ab10_p_way4:get()
        p_way5 = antiaim_cicle[id].ab10_p_way5:get()
    else
        yaw_type = antiaim_cicle[id].yaw_type:get()
        delay_type = antiaim_cicle[id].delay_type:get()
        delay_type_t = antiaim_cicle[id].delay_type_t:get()
        delay_type_ms = antiaim_cicle[id].delay_type_ms:get()
        yaw_l = antiaim_cicle[id].yaw_l:get()
        yaw_r = antiaim_cicle[id].yaw_r:get()
        jit_type = antiaim_cicle[id].jit_type:get()
        jitter_type = antiaim_cicle[id].jitter_type:get()
        jitter_center = antiaim_cicle[id].jitter_center:get()
        jitter_center_left = antiaim_cicle[id].jitter_center_left:get()
        jitter_center_right = antiaim_cicle[id].jitter_center_right:get()
        bodyyaw = antiaim_cicle[id].bodyyaw:get()
        options = antiaim_cicle[id].options:get()
        freestand = antiaim_cicle[id].freestand:get()
        lby_l = antiaim_cicle[id].lby_l:get()
        lby_r = antiaim_cicle[id].lby_r:get()
        def_type = antiaim_cicle[id].def_type:get()
        def_aa = antiaim_cicle[id].def_aa:get()
        def_yaw_type = antiaim_cicle[id].def_yaw_type:get()
        yaw_sens = antiaim_cicle[id].yaw_sens:get()
        way_delay = antiaim_cicle[id].way_delay:get()
        way_select = antiaim_cicle[id].way_select:get()
        way1 = antiaim_cicle[id].way1:get()
        way2 = antiaim_cicle[id].way2:get()
        way3 = antiaim_cicle[id].way3:get()
        way4 = antiaim_cicle[id].way4:get()
        way5 = antiaim_cicle[id].way5:get()
        def_pitch_type = antiaim_cicle[id].def_pitch_type:get()
        def_pitch = antiaim_cicle[id].def_pitch:get()
        p_way_delay = antiaim_cicle[id].p_way_delay:get()
        p_way_select = antiaim_cicle[id].p_way_select:get()
        p_way1 = antiaim_cicle[id].p_way1:get()
        p_way2 = antiaim_cicle[id].p_way2:get()
        p_way3 = antiaim_cicle[id].p_way3:get()
        p_way4 = antiaim_cicle[id].p_way4:get()
        p_way5 = antiaim_cicle[id].p_way5:get()
    end
      
    reference.yawmod:override(jit_type)
    reference.yaw:override("Backward")
    reference.bodyyaw:override(bodyyaw == "Default")
    if bodyyaw == "Custom" then
        cmd.send_packet = false
        local_player.m_flLowerBodyYawTarget  = rage.antiaim:get_rotation() - 180
    end
    reference.options:override(options)
    reference.freestanding:override(freestand)
    reference.right_limit:override(lby_r)
    reference.left_limit:override(lby_l)
    
    if def_type == "On Peek" then
        reference.lag:override("On Peek")
    elseif def_type == "Always On" then
        reference.lag:override("Always On")
        reference.hsopt:override("Break LC")
    elseif (def_type == "Hittable" and entity.get_threat(true) ~= nil) then
        reference.lag:override("Always On")
        reference.hsopt:override("Break LC")
    else
        reference.lag:override("On Peek")
        reference.hsopt:override("Favor Fire Rate")
    end

    reference.hidden:override(def_aa)
    def_amount = 0
    if def_aa then
        ---yaw
        if def_yaw_type == "Custom" then
            if yaw_adds <= 179 then
                yaw_adds = yaw_adds +yaw_sens
            else
                yaw_adds = -(yaw_adds+180)+yaw_sens
            end
            def_amount = yaw_adds
        elseif def_yaw_type == "180Z" then
            if spin_adds >= 180 then
                spin_adds = 0
            else
                spin_adds = spin_adds +10
            end
            def_amount = rage.antiaim:inverter() and spin_adds or spin_adds * -1
        elseif def_yaw_type == "Spin" then
            if sto_adds <= 179 then
                sto_adds = sto_adds +5
            else
                sto_adds = -(sto_adds+180)+5
            end
            def_amount = sto_adds
        elseif def_yaw_type == "Default" then
            def_amount = reference.yawoffset:get()
        elseif def_yaw_type == "Side-Ways" then
            reference.options:override("Jitter")
            def_amount = rage.antiaim:inverter() and 90 or -90
        elseif def_yaw_type == "Custom Ways" then
            if way_delay >= 4 then
                if cmd.send_packet == true and cmd.choked_commands < 1 then 
                    delay_way = delay_way + 1
                end
            elseif way_delay >= 3 then
                if cmd.choked_commands == 0 then
                    delay_way = delay_way + 1
                end
            else
                delay_way = delay_way + 1
            end
            if way_select == 1 then  ---1
                def_amount = way1
            elseif way_select == 2 then ---2S
                if delay_way == 1 then
                    def_amount = way1
                elseif delay_way >= 2 then
                    def_amount = way2
                    delay_way = 0
                end
            elseif way_select == 3 then ---3S
                if delay_way == 1 then
                    def_amount = way1
                elseif delay_way == 2 then
                    def_amount = way2
                elseif delay_way >= 3 then
                    def_amount = way3
                    delay_way = 0
                end
            elseif way_select == 4 then ---4S
                if delay_way == 1 then
                    def_amount = way1
                elseif delay_way == 2 then
                    def_amount = way2
                elseif delay_way == 3 then
                    def_amount = way3
                elseif delay_way >= 4 then
                    def_amount = way4
                    delay_way = 0
                end
            elseif way_select == 5 then ---5S
                if delay_way == 1 then
                    def_amount = way1
                elseif delay_way == 2 then
                    def_amount = way2
                elseif delay_way == 3 then
                    def_amount = way3
                elseif delay_way == 4 then
                    def_amount = way4
                elseif delay_way >= 5 then
                    def_amount = way5
                    delay_way = 0
                end
            end
        end
        --pitch
        if def_pitch_type == "Zero" then
            pitch_amount = 0
        elseif def_pitch_type == "Down" then
            pitch_amount = 89
        elseif def_pitch_type == "Up" then
            pitch_amount = -89
        elseif def_pitch_type == "Random" then
            pitch_amount = math.random(-89, 89)
        elseif def_pitch_type == "Progressive" then
            if pitch_ads <= 86 then
                pitch_ads = pitch_ads + 5
            else
                pitch_ads = (-pitch_ads) + 5
            end
            pitch_amount = pitch_ads
        elseif def_pitch_type == "Custom Ways" then  
            if p_way_delay >= 4 then
                if cmd.send_packet == true and cmd.choked_commands < 1 then 
                    delay_way1 = delay_way1 + 1
                end
            elseif p_way_delay >= 3 then
                if cmd.choked_commands == 0 then
                    delay_way1 = delay_way1 + 1
                end
            else
                delay_way1 = delay_way1 + 1
            end
            if p_way_select == 1 then  ---1
                pitch_amount = p_way1
            elseif p_way_select == 2 then ---2S
                if delay_way1 == 1 then
                    pitch_amount = p_way1
                elseif delay_way1 >= 2 then
                    pitch_amount = p_way2
                    delay_way1 = 0
                end
            elseif p_way_select == 3 then ---3S
                if delay_way1 == 1 then
                    pitch_amount = p_way1
                elseif delay_way1 == 2 then
                    pitch_amount = p_way2
                elseif delay_way1 >= 3 then
                    pitch_amount = p_way3
                    delay_way1 = 0
                end
            elseif p_way_select == 4 then ---4S
                if delay_way1 == 1 then
                    pitch_amount = p_way1
                elseif delay_way1 == 2 then
                    pitch_amount = p_way2
                elseif delay_way1 == 3 then
                    pitch_amount = p_way3
                elseif delay_way1 >= 4 then
                    pitch_amount = p_way4
                    delay_way1 = 0
                end
            elseif p_way_select == 5 then ---5S
                if delay_way1 == 1 then
                    pitch_amount = p_way1
                elseif delay_way1 == 2 then
                    pitch_amount = p_way2
                elseif delay_way1 == 3 then
                    pitch_amount = p_way3
                elseif delay_way1 == 4 then
                    pitch_amount = p_way4
                elseif delay_way1 >= 5 then
                    pitch_amount = p_way5
                    delay_way1 = 0
                end
            end
        else
            pitch_amount = def_pitch
        end
        --end
        if def_yaw_type ~= "Hidden" then
            rage.antiaim:override_hidden_yaw_offset(def_amount)
        end
        rage.antiaim:override_hidden_pitch(pitch_amount) 
    end
    if jitter_type == "L&R" then
	    reference.yawoff:override(rage.antiaim:inverter() and jitter_center_left or jitter_center_right)
    else
        reference.yawoff:override(jitter_center)
    end
    if yaw_type == "Default" then
        reference.yawoffset:override(rage.antiaim:inverter() and yaw_l or yaw_r)
        reference.inverter:override(false)
    elseif yaw_type == "Delay Switch" then 
        reference.options:override(nil)     
        if delay_type == "MS" then
            switch = (cmd.command_number %(8+delay_type_ms/15) > cmd.command_number %(4+delay_type_ms/30))
            if cmd.send_packet == true and cmd.choked_commands < 1 then
                reference.yawoffset:override(switch and yaw_l or yaw_r)
                reference.inverter:override(switch)
            end
        else
            if cmd.choked_commands == 0 then
                tick_switch = tick_switch + 1
            end
            if tick_switch == delay_type_t then
                reference.yawoffset:override(yaw_l)
                reference.inverter:override(true)
            end
            if tick_switch >= delay_type_t*2 then
                reference.yawoffset:override(yaw_r)
                reference.inverter:override(false)
                tick_switch = 0
            end
        end
    else
        reference.options:override(nil)
        reference.inverter:override(false)
        if delay_type == "MS" then
            switch = (cmd.command_number %(8+delay_type_ms/15) > cmd.command_number %(4+delay_type_ms/30))
            if cmd.send_packet == true and cmd.choked_commands < 1 then
                reference.yawoffset:override(switch and yaw_l or yaw_r)
            end
        else
            if cmd.choked_commands == 0 then
                tick_switch = tick_switch + 1
            end
            if tick_switch == delay_type_t then
                reference.yawoffset:override(yaw_l)
            end
            if tick_switch >= delay_type_t*2 then
                reference.yawoffset:override(yaw_r)
                tick_switch = 0
            end
        end
    end

    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    local head_check = false
    if aa_table.safe_head:get("Knife") and string.match(weapon, "Knife") then head_check = true end
    if aa_table.safe_head:get("Zeus") and string.match(weapon, "Taser") then head_check = true end
    if aa_table.safe_head:get("Grenade") and string.match(weapon, "Grenade") then head_check = true end
    if aa_table.safe_head:get("AWP") and string.match(weapon, "AWP") then head_check = true end
    if aa_table.safe_head:get("Scout") and string.match(weapon, "SSG08") then head_check = true end
    if aa_table.safe_head:get("Bomb C4") and string.match(weapon, "CC4") then head_check = true end
    if (jump and head_check == true) then
        reference.yawoff:set(0)
        reference.disableyaw:set(true)
        reference.bodyfrees:set(true)
        reference.options:set("")
        reference.inverter:set(false)
        reference.yawoffset:set(15)
        reference.hidden:set(false)
    end

    if (aa_table.shit_aa:get() == "Shit" and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
        reference.right_limit:set(math.random(0, 30))
        reference.left_limit:set(math.random(0, 30))
        reference.yawoff:set(math.random(-90, 90))
    elseif (aa_table.shit_aa:get() == "Disabled" and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
        reference.enable:set(false)
    elseif (aa_table.shit_aa:get() == "Random" and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
        reference.yawoff:set(math.random(-180, 180))
        reference.yawoffset:set(math.random(-180, 180))
    end
    -----------------
    reference.pitch:override(aa_table.pitch:get())


    if aa_table.static_frees:get("On Manual") and (aa_table.yaw_base:get() == "Left" or aa_table.yaw_base:get() == "Right") then
    else
        reference.freestand:set(aa_table.freestanding:get() and aa_table.frees_type:get() == 1 )
        if aa_table.freestanding:get() then
            edge_yaw_func()
            if (aa_table.frees_type:get() == 2) then
                reference.yawbase:override("Local View")
                reference.yawoffset:set(edge_yaw_func())
            end
            if aa_table.static_frees:get("Defensive AA") then
                reference.hidden:set(false)
            end
            if aa_table.static_frees:get("Jitter") then
                if aa_table.frees_type:get() == 1 then
                    reference.yawoffset:set(0)
                end
                reference.disableyaw:set(true)
                reference.bodyfrees:set(true)
                reference.options:set("")
                reference.inverter:set(false)
                reference.yawoff:set(0)
            end
        end
    end
    reference.backstab:set(aa_table.anti_backstab:get())
    if aa_table.yaw_base:get() == "At Target" then
        reference.yawbase:override("At Target")
    elseif aa_table.yaw_base:get() == "Backward" then
        reference.yawbase:override("Local View")
    elseif aa_table.yaw_base:get() == "Forward" then
        reference.yawoffset:override(180)
        reference.yawoff:override(0)
        reference.yawbase:override("Local View")
    end
    if aa_table.yaw_base_disabler:get("On Freestand") and aa_table.freestanding:get() then
        return
    else
        if aa_table.yaw_base:get() == "Left" then
            reference.yawoffset:override(-85)
            if aa_table.yaw_base_disabler:get("Jitter") then
                reference.yawoff:override(0)
                reference.options:override("")
            end
            if aa_table.yaw_base_disabler:get("Defensive AA") then
                reference.hidden:override(false)
            end
            reference.yawbase:override("Local View")
        elseif aa_table.yaw_base:get() == "Right" then
            reference.yawoffset:override(85)
            if aa_table.yaw_base_disabler:get("Defensive AA") then
                reference.yawoff:override(0)
                reference.options:override("")
            end
            if aa_table.yaw_base_disabler:get("Defensive AA") then
                reference.hidden:override(false)
            end
            reference.yawbase:override("Local View")
        end
    end
    if aa_table.legit_aa:get() == "Jitter" and bit.band(cmd.buttons, 32) == 32 then
        legit_func(cmd)
        reference.yawoffset:override(180)
        reference.options:override("Jitter")
        reference.yawbase:override("Local View")
        reference.pitch:override("Disabled")
        reference.hidden:override(false)
    elseif aa_table.legit_aa:get() == "Static" and bit.band(cmd.buttons, 32) == 32 then
        legit_func(cmd)
        reference.yawoffset:override(180)
        reference.yawbase:override("Local View")
        reference.pitch:override("Disabled")
        reference.hidden:override(false)
        reference.disableyaw:override(true)
        reference.bodyfrees:override(true)
        reference.options:override("")
        reference.inverter:override(false)
        reference.yawoff:override(0)
        reference.bodyyaw:override(true)
        reference.right_limit:override(60)
        reference.left_limit:override(60)
    elseif aa_table.legit_aa:get() == "Custom Desync" and bit.band(cmd.buttons, 32) == 32 then
        reference.pitch:override("Disabled")
        reference.yawoffset:override(180)
        legit_func(cmd)
        reference.hidden:override(false)
        reference.bodyyaw:override(false)
        reference.yawbase:override("Local View")
        local_player.m_flLowerBodyYawTarget  = rage.antiaim:get_rotation() - 180
    end

    if aa_table.huynya_ne_nuzhnaya:get("Edge Yaw") and reference.fd:get() then
        reference.yawoffset:override(edge_yaw_func())
        reference.yawbase:override("Local View")
        reference.disableyaw:override(true)
        reference.bodyfrees:override(true)
        reference.options:override("")
        reference.inverter:override(false)
        reference.yawoff:override(0)
    elseif aa_table.huynya_ne_nuzhnaya:get("Forward") and reference.fd:get() then
        reference.yawoffset:override(180)
        reference.yawoff:override(0)
        reference.yawbase:override("Local View")
    end
end


----animbreaker
ground_ticks, end_time = 1, 0
local function in_air()
    if not entity.get_local_player() == nil then return end
    if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime + 1
    end
    return ground_ticks > 1 and end_time > globals.curtime
end

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
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local anmsfct = nil
local anmsupd = function(animslsg, lsg)
    anmsfct(animslsg, lsg)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', animslsg) == nil then return end 
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    if get_entity_address(lp:get_index()) ~= animslsg then
        return;
    end
    move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
    jump = bit.band(lp.m_fFlags, 1) == 0
    if aa_table.groundbreaker:get() == "Follow Direction" and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        lp.m_flPoseParameter[0] = 1
        reference.legs:set("Sliding")
    end
    if aa_table.groundbreaker:get() == "Jitter" and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        lp.m_flPoseParameter[0] = globals.tickcount%4 > 1 and aa_table.legs_value:get()/200 or 1
        reference.legs:set("Sliding")
    end
    if aa_table.airbreaker:get() == "Static Legs" and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        lp.m_flPoseParameter[6] = 1
    end
    if aa_table.groundbreaker:get() == "MoonWalk" and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        lp.m_flPoseParameter[7] = 1
        reference.legs:set("Walking")
    end
    if aa_table.otherbreaker:get("Pitch 0 On Land") and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        if in_air() then
            lp.m_flPoseParameter[12] = 0.5
        end
    end
    if aa_table.airbreaker:get() == "MoonWalk" and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        if jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        end
    end
    if aa_table.otherbreaker:get("Movement Lean") and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        if move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = aa_table.lean_value:get()/100
        end
    end
    if aa_table.otherbreaker:get("Sliding Slow-Walk") and aa_table.animbreaker:get() and aa_table.enable_aa:get() then
        lp.m_flPoseParameter[9] = 0
    end
end

upd_hkd = function(cmd)
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    local local_index = lp:get_index()
    local local_address = get_entity_address(local_index)
    if not local_address or anmsfct then return end
    local pntr = vmt_hook.new(local_address)
    anmsfct = pntr.hook("void(__fastcall*)(void*, void*)", anmsupd, 224)
end
events.createmove_run:set(upd_hkd)

-------
for z, x in pairs(aa_table.cond_aa) do
    enableaa = antiaim_cicle[z].enable
    enaa = {enableaa, function() if(z == 1) then return true else return antiaim_cicle[z].enable:get() end end}
    need_select = {aa_table.condition, aa_table.cond_aa[z]}
    antiaim_cicle[1].enable:depend(true)
    antiaim_cicle[z].enable:depend(aa_table.enable_aa, need_select, {aa_table.condition, function() return (z ~= 1) end})
    antiaim_cicle[z].yaw_type:depend(aa_table.enable_aa, need_select, enaa)
    antiaim_cicle[z].delay_type:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].yaw_type, function() if antiaim_cicle[z].yaw_type:get() == "Default" then return false else return true end end})   
    antiaim_cicle[z].delay_type_t:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].delay_type, "Ticks"}, {antiaim_cicle[z].yaw_type, function() if antiaim_cicle[z].yaw_type:get() == "Default" then return false else return true end end})
    antiaim_cicle[z].delay_type_ms:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].delay_type, "MS"}, {antiaim_cicle[z].yaw_type, function() if antiaim_cicle[z].yaw_type:get() == "Default" then return false else return true end end})
    antiaim_cicle[z].yaw_l:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].yaw_r:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].jit_type:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].jitter_type:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "Default"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center_left:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "L&R"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center_right:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "L&R"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].bodyyaw:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].lby_l:depend(aa_table.enable_aa, {antiaim_cicle[z].bodyyaw, "Default"}, enaa, need_select)
    antiaim_cicle[z].lby_r:depend(aa_table.enable_aa, {antiaim_cicle[z].bodyyaw, "Default"}, enaa, need_select)
    antiaim_cicle[z].options:depend(aa_table.enable_aa, {antiaim_cicle[z].bodyyaw, "Default"}, enaa, need_select)
    antiaim_cicle[z].freestand:depend(aa_table.enable_aa, {antiaim_cicle[z].bodyyaw, "Default"}, enaa, need_select)
    antiaim_cicle[z].def_aa:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].def_type:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].def_pitch_type:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select)
    antiaim_cicle[z].def_pitch:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, {antiaim_cicle[z].def_pitch_type, "Custom"}, enaa, need_select)

    antiaim_cicle[z].p_way_delay:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"})
    antiaim_cicle[z].p_way_select:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"})
    antiaim_cicle[z].p_way1:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"}, {antiaim_cicle[z].p_way_select, function() if antiaim_cicle[z].p_way_select:get() >= 1 then return true else return false end end})
    antiaim_cicle[z].p_way2:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"}, {antiaim_cicle[z].p_way_select, function() if antiaim_cicle[z].p_way_select:get() >= 2 then return true else return false end end})
    antiaim_cicle[z].p_way3:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"}, {antiaim_cicle[z].p_way_select, function() if antiaim_cicle[z].p_way_select:get() >= 3 then return true else return false end end})
    antiaim_cicle[z].p_way4:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"}, {antiaim_cicle[z].p_way_select, function() if antiaim_cicle[z].p_way_select:get() >= 4 then return true else return false end end})
    antiaim_cicle[z].p_way5:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_pitch_type, "Custom Ways"}, {antiaim_cicle[z].p_way_select, function() if antiaim_cicle[z].p_way_select:get() >= 5 then return true else return false end end})

    antiaim_cicle[z].def_yaw_type:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select)


    antiaim_cicle[z].way_delay:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"})
    antiaim_cicle[z].way_select:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"})
    antiaim_cicle[z].way1:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"}, {antiaim_cicle[z].way_select, function() if antiaim_cicle[z].way_select:get() >= 1 then return true else return false end end})
    antiaim_cicle[z].way2:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"}, {antiaim_cicle[z].way_select, function() if antiaim_cicle[z].way_select:get() >= 2 then return true else return false end end})
    antiaim_cicle[z].way3:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"}, {antiaim_cicle[z].way_select, function() if antiaim_cicle[z].way_select:get() >= 3 then return true else return false end end})
    antiaim_cicle[z].way4:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"}, {antiaim_cicle[z].way_select, function() if antiaim_cicle[z].way_select:get() >= 4 then return true else return false end end})
    antiaim_cicle[z].way5:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom Ways"}, {antiaim_cicle[z].way_select, function() if antiaim_cicle[z].way_select:get() >= 5 then return true else return false end end})


    antiaim_cicle[z].yaw_sens:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom"})
    antiaim_cicle[z].ab_enable:depend(aa_table.enable_aa, enaa, need_select)
    ab_check = antiaim_cicle[z].ab_enable
    antiaim_cicle[z].ab_phase:depend(aa_table.enable_aa, ab_check, enaa, need_select)

    ab_vis = aa_table.enable_aa, ab_check, enaa, need_select
    tick_check = {antiaim_cicle[z].ab1_yaw_type, function() if antiaim_cicle[z].ab1_yaw_type:get() == "Default" then return false else return true end end}
    jitter = {antiaim_cicle[z].ab1_jit_type, function() if antiaim_cicle[z].ab1_jit_type:get() == "Disabled" then return false else return true end end}
    bodyyaw = {antiaim_cicle[z].ab1_bodyyaw, "Default"}
    defensive = antiaim_cicle[z].ab1_def_aa

    phase_check1 = {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 1 then return true else return false end end}


    ----ab1
    custom_way = {antiaim_cicle[z].ab1_def_yaw_type, "Custom Ways"}
    select_way1 = {antiaim_cicle[z].ab1_way_select, function() if antiaim_cicle[z].ab1_way_select:get() >= 1 then return true else return false end end}
    select_way2 = {antiaim_cicle[z].ab1_way_select, function() if antiaim_cicle[z].ab1_way_select:get() >= 2 then return true else return false end end}
    select_way3 = {antiaim_cicle[z].ab1_way_select, function() if antiaim_cicle[z].ab1_way_select:get() >= 3 then return true else return false end end}
    select_way4 = {antiaim_cicle[z].ab1_way_select, function() if antiaim_cicle[z].ab1_way_select:get() >= 4 then return true else return false end end}
    select_way5 = {antiaim_cicle[z].ab1_way_select, function() if antiaim_cicle[z].ab1_way_select:get() >= 5 then return true else return false end end}
    p_way = {antiaim_cicle[z].ab1_def_pitch_type, "Custom Ways"}
    p_way1 = {antiaim_cicle[z].ab1_p_way_select, function() if antiaim_cicle[z].ab1_p_way_select:get() >= 1 then return true else return false end end}
    p_way2 = {antiaim_cicle[z].ab1_p_way_select, function() if antiaim_cicle[z].ab1_p_way_select:get() >= 2 then return true else return false end end}
    p_way3 = {antiaim_cicle[z].ab1_p_way_select, function() if antiaim_cicle[z].ab1_p_way_select:get() >= 3 then return true else return false end end}
    p_way4 = {antiaim_cicle[z].ab1_p_way_select, function() if antiaim_cicle[z].ab1_p_way_select:get() >= 4 then return true else return false end end}
    p_way5 = {antiaim_cicle[z].ab1_p_way_select, function() if antiaim_cicle[z].ab1_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab_label:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab1_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab1_delay_type:depend(ab_vis, tick_check)
    antiaim_cicle[z].ab1_delay_type_t:depend(ab_vis, tick_check, {antiaim_cicle[z].ab1_delay_type, "Ticks"})
    antiaim_cicle[z].ab1_delay_type_ms:depend(ab_vis, tick_check, {antiaim_cicle[z].ab1_delay_type, "MS"})
    antiaim_cicle[z].ab1_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab1_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab1_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab1_jitter_type:depend(ab_vis, jitter)
    antiaim_cicle[z].ab1_jitter_center:depend(ab_vis, jitter, {antiaim_cicle[z].ab1_jitter_type, "Default"})
    antiaim_cicle[z].ab1_jitter_center_left:depend(ab_vis, jitter, {antiaim_cicle[z].ab1_jitter_type, "L&R"})
    antiaim_cicle[z].ab1_jitter_center_right:depend(ab_vis, jitter, {antiaim_cicle[z].ab1_jitter_type, "L&R"})
    antiaim_cicle[z].ab1_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab1_options:depend(ab_vis, bodyyaw)
    antiaim_cicle[z].ab1_freestand:depend(ab_vis, bodyyaw)
    antiaim_cicle[z].ab1_lby_l:depend(ab_vis, bodyyaw)
    antiaim_cicle[z].ab1_lby_r:depend(ab_vis, bodyyaw)
    antiaim_cicle[z].ab1_def_type:depend(ab_vis)
    antiaim_cicle[z].ab1_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab1_def_yaw_type:depend(ab_vis, defensive)
    antiaim_cicle[z].ab1_yaw_sens:depend(ab_vis, defensive, {antiaim_cicle[z].ab1_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab1_way_delay:depend(ab_vis, defensive, custom_way)
    antiaim_cicle[z].ab1_way_select:depend(ab_vis, defensive, custom_way)
    antiaim_cicle[z].ab1_way1:depend(ab_vis, defensive, custom_way, select_way1)
    antiaim_cicle[z].ab1_way2:depend(ab_vis, defensive, custom_way, select_way2)
    antiaim_cicle[z].ab1_way3:depend(ab_vis, defensive, custom_way, select_way3)
    antiaim_cicle[z].ab1_way4:depend(ab_vis, defensive, custom_way, select_way4)
    antiaim_cicle[z].ab1_way5:depend(ab_vis, defensive, custom_way, select_way5)
    antiaim_cicle[z].ab1_def_pitch_type:depend(ab_vis, defensive)
    antiaim_cicle[z].ab1_def_pitch:depend(ab_vis, defensive, {antiaim_cicle[z].ab1_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab1_p_way_delay:depend(ab_vis, defensive, p_way)
    antiaim_cicle[z].ab1_p_way_select:depend(ab_vis, defensive, p_way)
    antiaim_cicle[z].ab1_p_way1:depend(ab_vis, defensive, p_way1, p_way)
    antiaim_cicle[z].ab1_p_way2:depend(ab_vis, defensive, p_way2, p_way)
    antiaim_cicle[z].ab1_p_way3:depend(ab_vis, defensive, p_way3, p_way)
    antiaim_cicle[z].ab1_p_way4:depend(ab_vis, defensive, p_way4, p_way)
    antiaim_cicle[z].ab1_p_way5:depend(ab_vis, defensive, p_way5, p_way)

    ---ab2

    ab2_tick_check = {antiaim_cicle[z].ab2_yaw_type, function() if antiaim_cicle[z].ab2_yaw_type:get() == "Default" then return false else return true end end}
    ab2_jitter = {antiaim_cicle[z].ab2_jit_type, function() if antiaim_cicle[z].ab2_jit_type:get() == "Disabled" then return false else return true end end}
    ab2_bodyyaw = {antiaim_cicle[z].ab2_bodyyaw, "Default"}
    ab2_defensive = antiaim_cicle[z].ab2_def_aa

    ab2_custom_way = {antiaim_cicle[z].ab2_def_yaw_type, "Custom Ways"}
    ab2_select_way1 = {antiaim_cicle[z].ab2_way_select, function() if antiaim_cicle[z].ab2_way_select:get() >= 1 then return true else return false end end}
    ab2_select_way2 = {antiaim_cicle[z].ab2_way_select, function() if antiaim_cicle[z].ab2_way_select:get() >= 2 then return true else return false end end}
    ab2_select_way3 = {antiaim_cicle[z].ab2_way_select, function() if antiaim_cicle[z].ab2_way_select:get() >= 3 then return true else return false end end}
    ab2_select_way4 = {antiaim_cicle[z].ab2_way_select, function() if antiaim_cicle[z].ab2_way_select:get() >= 4 then return true else return false end end}
    ab2_select_way5 = {antiaim_cicle[z].ab2_way_select, function() if antiaim_cicle[z].ab2_way_select:get() >= 5 then return true else return false end end}
    ab2_p_way = {antiaim_cicle[z].ab2_def_pitch_type, "Custom Ways"}
    ab2_p_way1 = {antiaim_cicle[z].ab2_p_way_select, function() if antiaim_cicle[z].ab2_p_way_select:get() >= 1 then return true else return false end end}
    ab2_p_way2 = {antiaim_cicle[z].ab2_p_way_select, function() if antiaim_cicle[z].ab2_p_way_select:get() >= 2 then return true else return false end end}
    ab2_p_way3 = {antiaim_cicle[z].ab2_p_way_select, function() if antiaim_cicle[z].ab2_p_way_select:get() >= 3 then return true else return false end end}
    ab2_p_way4 = {antiaim_cicle[z].ab2_p_way_select, function() if antiaim_cicle[z].ab2_p_way_select:get() >= 4 then return true else return false end end}
    ab2_p_way5 = {antiaim_cicle[z].ab2_p_way_select, function() if antiaim_cicle[z].ab2_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab2_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 2 then return true else return false end end})
    antiaim_cicle[z].ab2_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab2_delay_type:depend(ab_vis, ab2_tick_check)
    antiaim_cicle[z].ab2_delay_type_t:depend(ab_vis, ab2_tick_check, {antiaim_cicle[z].ab2_delay_type, "Ticks"})
    antiaim_cicle[z].ab2_delay_type_ms:depend(ab_vis, ab2_tick_check, {antiaim_cicle[z].ab2_delay_type, "MS"})
    antiaim_cicle[z].ab2_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab2_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab2_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab2_jitter_type:depend(ab_vis, ab2_jitter)
    antiaim_cicle[z].ab2_jitter_center:depend(ab_vis, ab2_jitter, {antiaim_cicle[z].ab2_jitter_type, "Default"})
    antiaim_cicle[z].ab2_jitter_center_left:depend(ab_vis, ab2_jitter, {antiaim_cicle[z].ab2_jitter_type, "L&R"})
    antiaim_cicle[z].ab2_jitter_center_right:depend(ab_vis, ab2_jitter, {antiaim_cicle[z].ab2_jitter_type, "L&R"})
    antiaim_cicle[z].ab2_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab2_options:depend(ab_vis, ab2_bodyyaw)
    antiaim_cicle[z].ab2_freestand:depend(ab_vis, ab2_bodyyaw)
    antiaim_cicle[z].ab2_lby_l:depend(ab_vis, ab2_bodyyaw)
    antiaim_cicle[z].ab2_lby_r:depend(ab_vis, ab2_bodyyaw)
    antiaim_cicle[z].ab2_def_type:depend(ab_vis)
    antiaim_cicle[z].ab2_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab2_def_yaw_type:depend(ab_vis, ab2_defensive)
    antiaim_cicle[z].ab2_yaw_sens:depend(ab_vis, ab2_defensive, {antiaim_cicle[z].ab2_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab2_way_delay:depend(ab_vis, ab2_defensive, ab2_custom_way)
    antiaim_cicle[z].ab2_way_select:depend(ab_vis, ab2_defensive, ab2_custom_way)
    antiaim_cicle[z].ab2_way1:depend(ab_vis, ab2_defensive, ab2_custom_way, ab2_select_way1)
    antiaim_cicle[z].ab2_way2:depend(ab_vis, ab2_defensive, ab2_custom_way, ab2_select_way2)
    antiaim_cicle[z].ab2_way3:depend(ab_vis, ab2_defensive, ab2_custom_way, ab2_select_way3)
    antiaim_cicle[z].ab2_way4:depend(ab_vis, ab2_defensive, ab2_custom_way, ab2_select_way4)
    antiaim_cicle[z].ab2_way5:depend(ab_vis, ab2_defensive, ab2_custom_way, ab2_select_way5)
    antiaim_cicle[z].ab2_def_pitch_type:depend(ab_vis, ab2_defensive)
    antiaim_cicle[z].ab2_def_pitch:depend(ab_vis, ab2_defensive, {antiaim_cicle[z].ab2_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab2_p_way_delay:depend(ab_vis, ab2_defensive, ab2_p_way)
    antiaim_cicle[z].ab2_p_way_select:depend(ab_vis, ab2_defensive, ab2_p_way)
    antiaim_cicle[z].ab2_p_way1:depend(ab_vis, ab2_defensive, ab2_p_way1, ab2_p_way)
    antiaim_cicle[z].ab2_p_way2:depend(ab_vis, ab2_defensive, ab2_p_way2, ab2_p_way)
    antiaim_cicle[z].ab2_p_way3:depend(ab_vis, ab2_defensive, ab2_p_way3, ab2_p_way)
    antiaim_cicle[z].ab2_p_way4:depend(ab_vis, ab2_defensive, ab2_p_way4, ab2_p_way)
    antiaim_cicle[z].ab2_p_way5:depend(ab_vis, ab2_defensive, ab2_p_way5, ab2_p_way)


        ---ab3

        ab3_tick_check = {antiaim_cicle[z].ab3_yaw_type, function() if antiaim_cicle[z].ab3_yaw_type:get() == "Default" then return false else return true end end}
        ab3_jitter = {antiaim_cicle[z].ab3_jit_type, function() if antiaim_cicle[z].ab3_jit_type:get() == "Disabled" then return false else return true end end}
        ab3_bodyyaw = {antiaim_cicle[z].ab3_bodyyaw, "Default"}
        ab3_defensive = antiaim_cicle[z].ab3_def_aa
    
        ab3_custom_way = {antiaim_cicle[z].ab3_def_yaw_type, "Custom Ways"}
        ab3_select_way1 = {antiaim_cicle[z].ab3_way_select, function() if antiaim_cicle[z].ab3_way_select:get() >= 1 then return true else return false end end}
        ab3_select_way2 = {antiaim_cicle[z].ab3_way_select, function() if antiaim_cicle[z].ab3_way_select:get() >= 2 then return true else return false end end}
        ab3_select_way3 = {antiaim_cicle[z].ab3_way_select, function() if antiaim_cicle[z].ab3_way_select:get() >= 3 then return true else return false end end}
        ab3_select_way4 = {antiaim_cicle[z].ab3_way_select, function() if antiaim_cicle[z].ab3_way_select:get() >= 4 then return true else return false end end}
        ab3_select_way5 = {antiaim_cicle[z].ab3_way_select, function() if antiaim_cicle[z].ab3_way_select:get() >= 5 then return true else return false end end}
        ab3_p_way = {antiaim_cicle[z].ab3_def_pitch_type, "Custom Ways"}
        ab3_p_way1 = {antiaim_cicle[z].ab3_p_way_select, function() if antiaim_cicle[z].ab3_p_way_select:get() >= 1 then return true else return false end end}
        ab3_p_way2 = {antiaim_cicle[z].ab3_p_way_select, function() if antiaim_cicle[z].ab3_p_way_select:get() >= 2 then return true else return false end end}
        ab3_p_way3 = {antiaim_cicle[z].ab3_p_way_select, function() if antiaim_cicle[z].ab3_p_way_select:get() >= 3 then return true else return false end end}
        ab3_p_way4 = {antiaim_cicle[z].ab3_p_way_select, function() if antiaim_cicle[z].ab3_p_way_select:get() >= 4 then return true else return false end end}
        ab3_p_way5 = {antiaim_cicle[z].ab3_p_way_select, function() if antiaim_cicle[z].ab3_p_way_select:get() >= 5 then return true else return false end end}
    
        antiaim_cicle[z].ab3_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 3 then return true else return false end end})
        antiaim_cicle[z].ab3_yaw_type:depend(ab_vis)
        antiaim_cicle[z].ab3_delay_type:depend(ab_vis, ab3_tick_check)
        antiaim_cicle[z].ab3_delay_type_t:depend(ab_vis, ab3_tick_check, {antiaim_cicle[z].ab3_delay_type, "Ticks"})
        antiaim_cicle[z].ab3_delay_type_ms:depend(ab_vis, ab3_tick_check, {antiaim_cicle[z].ab3_delay_type, "MS"})
        antiaim_cicle[z].ab3_yaw_l:depend(ab_vis)
        antiaim_cicle[z].ab3_yaw_r:depend(ab_vis)
        antiaim_cicle[z].ab3_jit_type:depend(ab_vis)
        antiaim_cicle[z].ab3_jitter_type:depend(ab_vis, ab3_jitter)
        antiaim_cicle[z].ab3_jitter_center:depend(ab_vis, ab3_jitter, {antiaim_cicle[z].ab3_jitter_type, "Default"})
        antiaim_cicle[z].ab3_jitter_center_left:depend(ab_vis, ab3_jitter, {antiaim_cicle[z].ab3_jitter_type, "L&R"})
        antiaim_cicle[z].ab3_jitter_center_right:depend(ab_vis, ab3_jitter, {antiaim_cicle[z].ab3_jitter_type, "L&R"})
        antiaim_cicle[z].ab3_bodyyaw:depend(ab_vis)
        antiaim_cicle[z].ab3_options:depend(ab_vis, ab3_bodyyaw)
        antiaim_cicle[z].ab3_freestand:depend(ab_vis, ab3_bodyyaw)
        antiaim_cicle[z].ab3_lby_l:depend(ab_vis, ab3_bodyyaw)
        antiaim_cicle[z].ab3_lby_r:depend(ab_vis, ab3_bodyyaw)
        antiaim_cicle[z].ab3_def_type:depend(ab_vis)
        antiaim_cicle[z].ab3_def_aa:depend(ab_vis)
        antiaim_cicle[z].ab3_def_yaw_type:depend(ab_vis, ab3_defensive)
        antiaim_cicle[z].ab3_yaw_sens:depend(ab_vis, ab3_defensive, {antiaim_cicle[z].ab3_def_yaw_type, "Custom"})
        antiaim_cicle[z].ab3_way_delay:depend(ab_vis, ab3_defensive, ab3_custom_way)
        antiaim_cicle[z].ab3_way_select:depend(ab_vis, ab3_defensive, ab3_custom_way)
        antiaim_cicle[z].ab3_way1:depend(ab_vis, ab3_defensive, ab3_custom_way, ab3_select_way1)
        antiaim_cicle[z].ab3_way2:depend(ab_vis, ab3_defensive, ab3_custom_way, ab3_select_way2)
        antiaim_cicle[z].ab3_way3:depend(ab_vis, ab3_defensive, ab3_custom_way, ab3_select_way3)
        antiaim_cicle[z].ab3_way4:depend(ab_vis, ab3_defensive, ab3_custom_way, ab3_select_way4)
        antiaim_cicle[z].ab3_way5:depend(ab_vis, ab3_defensive, ab3_custom_way, ab3_select_way5)
        antiaim_cicle[z].ab3_def_pitch_type:depend(ab_vis, ab3_defensive)
        antiaim_cicle[z].ab3_def_pitch:depend(ab_vis, ab3_defensive, {antiaim_cicle[z].ab3_def_pitch_type, "Custom"})
        antiaim_cicle[z].ab3_p_way_delay:depend(ab_vis, ab3_defensive, ab3_p_way)
        antiaim_cicle[z].ab3_p_way_select:depend(ab_vis, ab3_defensive, ab3_p_way)
        antiaim_cicle[z].ab3_p_way1:depend(ab_vis, ab3_defensive, ab3_p_way1, ab3_p_way)
        antiaim_cicle[z].ab3_p_way2:depend(ab_vis, ab3_defensive, ab3_p_way2, ab3_p_way)
        antiaim_cicle[z].ab3_p_way3:depend(ab_vis, ab3_defensive, ab3_p_way3, ab3_p_way)
        antiaim_cicle[z].ab3_p_way4:depend(ab_vis, ab3_defensive, ab3_p_way4, ab3_p_way)
        antiaim_cicle[z].ab3_p_way5:depend(ab_vis, ab3_defensive, ab3_p_way5, ab3_p_way)

    
    --ab4
    ab4_tick_check = {antiaim_cicle[z].ab4_yaw_type, function() if antiaim_cicle[z].ab4_yaw_type:get() == "Default" then return false else return true end end}
    ab4_jitter = {antiaim_cicle[z].ab4_jit_type, function() if antiaim_cicle[z].ab4_jit_type:get() == "Disabled" then return false else return true end end}
    ab4_bodyyaw = {antiaim_cicle[z].ab4_bodyyaw, "Default"}
    ab4_defensive = antiaim_cicle[z].ab4_def_aa

    ab4_custom_way = {antiaim_cicle[z].ab4_def_yaw_type, "Custom Ways"}
    ab4_select_way1 = {antiaim_cicle[z].ab4_way_select, function() if antiaim_cicle[z].ab4_way_select:get() >= 1 then return true else return false end end}
    ab4_select_way2 = {antiaim_cicle[z].ab4_way_select, function() if antiaim_cicle[z].ab4_way_select:get() >= 2 then return true else return false end end}
    ab4_select_way3 = {antiaim_cicle[z].ab4_way_select, function() if antiaim_cicle[z].ab4_way_select:get() >= 3 then return true else return false end end}
    ab4_select_way4 = {antiaim_cicle[z].ab4_way_select, function() if antiaim_cicle[z].ab4_way_select:get() >= 4 then return true else return false end end}
    ab4_select_way5 = {antiaim_cicle[z].ab4_way_select, function() if antiaim_cicle[z].ab4_way_select:get() >= 5 then return true else return false end end}
    ab4_p_way = {antiaim_cicle[z].ab4_def_pitch_type, "Custom Ways"}
    ab4_p_way1 = {antiaim_cicle[z].ab4_p_way_select, function() if antiaim_cicle[z].ab4_p_way_select:get() >= 1 then return true else return false end end}
    ab4_p_way2 = {antiaim_cicle[z].ab4_p_way_select, function() if antiaim_cicle[z].ab4_p_way_select:get() >= 2 then return true else return false end end}
    ab4_p_way3 = {antiaim_cicle[z].ab4_p_way_select, function() if antiaim_cicle[z].ab4_p_way_select:get() >= 3 then return true else return false end end}
    ab4_p_way4 = {antiaim_cicle[z].ab4_p_way_select, function() if antiaim_cicle[z].ab4_p_way_select:get() >= 4 then return true else return false end end}
    ab4_p_way5 = {antiaim_cicle[z].ab4_p_way_select, function() if antiaim_cicle[z].ab4_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab4_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 4 then return true else return false end end})
    antiaim_cicle[z].ab4_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab4_delay_type:depend(ab_vis, ab4_tick_check)
    antiaim_cicle[z].ab4_delay_type_t:depend(ab_vis, ab4_tick_check, {antiaim_cicle[z].ab4_delay_type, "Ticks"})
    antiaim_cicle[z].ab4_delay_type_ms:depend(ab_vis, ab4_tick_check, {antiaim_cicle[z].ab4_delay_type, "MS"})
    antiaim_cicle[z].ab4_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab4_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab4_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab4_jitter_type:depend(ab_vis, ab4_jitter)
    antiaim_cicle[z].ab4_jitter_center:depend(ab_vis, ab4_jitter, {antiaim_cicle[z].ab4_jitter_type, "Default"})
    antiaim_cicle[z].ab4_jitter_center_left:depend(ab_vis, ab4_jitter, {antiaim_cicle[z].ab4_jitter_type, "L&R"})
    antiaim_cicle[z].ab4_jitter_center_right:depend(ab_vis, ab4_jitter, {antiaim_cicle[z].ab4_jitter_type, "L&R"})
    antiaim_cicle[z].ab4_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab4_options:depend(ab_vis, ab4_bodyyaw)
    antiaim_cicle[z].ab4_freestand:depend(ab_vis, ab4_bodyyaw)
    antiaim_cicle[z].ab4_lby_l:depend(ab_vis, ab4_bodyyaw)
    antiaim_cicle[z].ab4_lby_r:depend(ab_vis, ab4_bodyyaw)
    antiaim_cicle[z].ab4_def_type:depend(ab_vis)
    antiaim_cicle[z].ab4_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab4_def_yaw_type:depend(ab_vis, ab4_defensive)
    antiaim_cicle[z].ab4_yaw_sens:depend(ab_vis, ab4_defensive, {antiaim_cicle[z].ab4_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab4_way_delay:depend(ab_vis, ab4_defensive, ab4_custom_way)
    antiaim_cicle[z].ab4_way_select:depend(ab_vis, ab4_defensive, ab4_custom_way)
    antiaim_cicle[z].ab4_way1:depend(ab_vis, ab4_defensive, ab4_custom_way, ab4_select_way1)
    antiaim_cicle[z].ab4_way2:depend(ab_vis, ab4_defensive, ab4_custom_way, ab4_select_way2)
    antiaim_cicle[z].ab4_way3:depend(ab_vis, ab4_defensive, ab4_custom_way, ab4_select_way3)
    antiaim_cicle[z].ab4_way4:depend(ab_vis, ab4_defensive, ab4_custom_way, ab4_select_way4)
    antiaim_cicle[z].ab4_way5:depend(ab_vis, ab4_defensive, ab4_custom_way, ab4_select_way5)
    antiaim_cicle[z].ab4_def_pitch_type:depend(ab_vis, ab4_defensive)
    antiaim_cicle[z].ab4_def_pitch:depend(ab_vis, ab4_defensive, {antiaim_cicle[z].ab4_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab4_p_way_delay:depend(ab_vis, ab4_defensive, ab4_p_way)
    antiaim_cicle[z].ab4_p_way_select:depend(ab_vis, ab4_defensive, ab4_p_way)
    antiaim_cicle[z].ab4_p_way1:depend(ab_vis, ab4_defensive, ab4_p_way1, ab4_p_way)
    antiaim_cicle[z].ab4_p_way2:depend(ab_vis, ab4_defensive, ab4_p_way2, ab4_p_way)
    antiaim_cicle[z].ab4_p_way3:depend(ab_vis, ab4_defensive, ab4_p_way3, ab4_p_way)
    antiaim_cicle[z].ab4_p_way4:depend(ab_vis, ab4_defensive, ab4_p_way4, ab4_p_way)
    antiaim_cicle[z].ab4_p_way5:depend(ab_vis, ab4_defensive, ab4_p_way5, ab4_p_way)


    ---ab5
    ab5_tick_check = {antiaim_cicle[z].ab5_yaw_type, function() if antiaim_cicle[z].ab5_yaw_type:get() == "Default" then return false else return true end end}
    ab5_jitter = {antiaim_cicle[z].ab5_jit_type, function() if antiaim_cicle[z].ab5_jit_type:get() == "Disabled" then return false else return true end end}
    ab5_bodyyaw = {antiaim_cicle[z].ab5_bodyyaw, "Default"}
    ab5_defensive = antiaim_cicle[z].ab5_def_aa

    ab5_custom_way = {antiaim_cicle[z].ab5_def_yaw_type, "Custom Ways"}
    ab5_select_way1 = {antiaim_cicle[z].ab5_way_select, function() if antiaim_cicle[z].ab5_way_select:get() >= 1 then return true else return false end end}
    ab5_select_way2 = {antiaim_cicle[z].ab5_way_select, function() if antiaim_cicle[z].ab5_way_select:get() >= 2 then return true else return false end end}
    ab5_select_way3 = {antiaim_cicle[z].ab5_way_select, function() if antiaim_cicle[z].ab5_way_select:get() >= 3 then return true else return false end end}
    ab5_select_way4 = {antiaim_cicle[z].ab5_way_select, function() if antiaim_cicle[z].ab5_way_select:get() >= 4 then return true else return false end end}
    ab5_select_way5 = {antiaim_cicle[z].ab5_way_select, function() if antiaim_cicle[z].ab5_way_select:get() >= 5 then return true else return false end end}
    ab5_p_way = {antiaim_cicle[z].ab5_def_pitch_type, "Custom Ways"}
    ab5_p_way1 = {antiaim_cicle[z].ab5_p_way_select, function() if antiaim_cicle[z].ab5_p_way_select:get() >= 1 then return true else return false end end}
    ab5_p_way2 = {antiaim_cicle[z].ab5_p_way_select, function() if antiaim_cicle[z].ab5_p_way_select:get() >= 2 then return true else return false end end}
    ab5_p_way3 = {antiaim_cicle[z].ab5_p_way_select, function() if antiaim_cicle[z].ab5_p_way_select:get() >= 3 then return true else return false end end}
    ab5_p_way4 = {antiaim_cicle[z].ab5_p_way_select, function() if antiaim_cicle[z].ab5_p_way_select:get() >= 4 then return true else return false end end}
    ab5_p_way5 = {antiaim_cicle[z].ab5_p_way_select, function() if antiaim_cicle[z].ab5_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab5_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 5 then return true else return false end end})
    antiaim_cicle[z].ab5_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab5_delay_type:depend(ab_vis, ab5_tick_check)
    antiaim_cicle[z].ab5_delay_type_t:depend(ab_vis, ab5_tick_check, {antiaim_cicle[z].ab5_delay_type, "Ticks"})
    antiaim_cicle[z].ab5_delay_type_ms:depend(ab_vis, ab5_tick_check, {antiaim_cicle[z].ab5_delay_type, "MS"})
    antiaim_cicle[z].ab5_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab5_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab5_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab5_jitter_type:depend(ab_vis, ab5_jitter)
    antiaim_cicle[z].ab5_jitter_center:depend(ab_vis, ab5_jitter, {antiaim_cicle[z].ab5_jitter_type, "Default"})
    antiaim_cicle[z].ab5_jitter_center_left:depend(ab_vis, ab5_jitter, {antiaim_cicle[z].ab5_jitter_type, "L&R"})
    antiaim_cicle[z].ab5_jitter_center_right:depend(ab_vis, ab5_jitter, {antiaim_cicle[z].ab5_jitter_type, "L&R"})
    antiaim_cicle[z].ab5_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab5_options:depend(ab_vis, ab5_bodyyaw)
    antiaim_cicle[z].ab5_freestand:depend(ab_vis, ab5_bodyyaw)
    antiaim_cicle[z].ab5_lby_l:depend(ab_vis, ab5_bodyyaw)
    antiaim_cicle[z].ab5_lby_r:depend(ab_vis, ab5_bodyyaw)
    antiaim_cicle[z].ab5_def_type:depend(ab_vis)
    antiaim_cicle[z].ab5_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab5_def_yaw_type:depend(ab_vis, ab5_defensive)
    antiaim_cicle[z].ab5_yaw_sens:depend(ab_vis, ab5_defensive, {antiaim_cicle[z].ab5_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab5_way_delay:depend(ab_vis, ab5_defensive, ab5_custom_way)
    antiaim_cicle[z].ab5_way_select:depend(ab_vis, ab5_defensive, ab5_custom_way)
    antiaim_cicle[z].ab5_way1:depend(ab_vis, ab5_defensive, ab5_custom_way, ab5_select_way1)
    antiaim_cicle[z].ab5_way2:depend(ab_vis, ab5_defensive, ab5_custom_way, ab5_select_way2)
    antiaim_cicle[z].ab5_way3:depend(ab_vis, ab5_defensive, ab5_custom_way, ab5_select_way3)
    antiaim_cicle[z].ab5_way4:depend(ab_vis, ab5_defensive, ab5_custom_way, ab5_select_way4)
    antiaim_cicle[z].ab5_way5:depend(ab_vis, ab5_defensive, ab5_custom_way, ab5_select_way5)
    antiaim_cicle[z].ab5_def_pitch_type:depend(ab_vis, ab5_defensive)
    antiaim_cicle[z].ab5_def_pitch:depend(ab_vis, ab5_defensive, {antiaim_cicle[z].ab5_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab5_p_way_delay:depend(ab_vis, ab5_defensive, ab5_p_way)
    antiaim_cicle[z].ab5_p_way_select:depend(ab_vis, ab5_defensive, ab5_p_way)
    antiaim_cicle[z].ab5_p_way1:depend(ab_vis, ab5_defensive, ab5_p_way1, ab5_p_way)
    antiaim_cicle[z].ab5_p_way2:depend(ab_vis, ab5_defensive, ab5_p_way2, ab5_p_way)
    antiaim_cicle[z].ab5_p_way3:depend(ab_vis, ab5_defensive, ab5_p_way3, ab5_p_way)
    antiaim_cicle[z].ab5_p_way4:depend(ab_vis, ab5_defensive, ab5_p_way4, ab5_p_way)
    antiaim_cicle[z].ab5_p_way5:depend(ab_vis, ab5_defensive, ab5_p_way5, ab5_p_way)



    ---ab6
    ab6_tick_check = {antiaim_cicle[z].ab6_yaw_type, function() if antiaim_cicle[z].ab6_yaw_type:get() == "Default" then return false else return true end end}
    ab6_jitter = {antiaim_cicle[z].ab6_jit_type, function() if antiaim_cicle[z].ab6_jit_type:get() == "Disabled" then return false else return true end end}
    ab6_bodyyaw = {antiaim_cicle[z].ab6_bodyyaw, "Default"}
    ab6_defensive = antiaim_cicle[z].ab6_def_aa

    ab6_custom_way = {antiaim_cicle[z].ab6_def_yaw_type, "Custom Ways"}
    ab6_select_way1 = {antiaim_cicle[z].ab6_way_select, function() if antiaim_cicle[z].ab6_way_select:get() >= 1 then return true else return false end end}
    ab6_select_way2 = {antiaim_cicle[z].ab6_way_select, function() if antiaim_cicle[z].ab6_way_select:get() >= 2 then return true else return false end end}
    ab6_select_way3 = {antiaim_cicle[z].ab6_way_select, function() if antiaim_cicle[z].ab6_way_select:get() >= 3 then return true else return false end end}
    ab6_select_way4 = {antiaim_cicle[z].ab6_way_select, function() if antiaim_cicle[z].ab6_way_select:get() >= 4 then return true else return false end end}
    ab6_select_way5 = {antiaim_cicle[z].ab6_way_select, function() if antiaim_cicle[z].ab6_way_select:get() >= 5 then return true else return false end end}
    ab6_p_way = {antiaim_cicle[z].ab6_def_pitch_type, "Custom Ways"}
    ab6_p_way1 = {antiaim_cicle[z].ab6_p_way_select, function() if antiaim_cicle[z].ab6_p_way_select:get() >= 1 then return true else return false end end}
    ab6_p_way2 = {antiaim_cicle[z].ab6_p_way_select, function() if antiaim_cicle[z].ab6_p_way_select:get() >= 2 then return true else return false end end}
    ab6_p_way3 = {antiaim_cicle[z].ab6_p_way_select, function() if antiaim_cicle[z].ab6_p_way_select:get() >= 3 then return true else return false end end}
    ab6_p_way4 = {antiaim_cicle[z].ab6_p_way_select, function() if antiaim_cicle[z].ab6_p_way_select:get() >= 4 then return true else return false end end}
    ab6_p_way5 = {antiaim_cicle[z].ab6_p_way_select, function() if antiaim_cicle[z].ab6_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab6_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 6 then return true else return false end end})
    antiaim_cicle[z].ab6_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab6_delay_type:depend(ab_vis, ab6_tick_check)
    antiaim_cicle[z].ab6_delay_type_t:depend(ab_vis, ab6_tick_check, {antiaim_cicle[z].ab6_delay_type, "Ticks"})
    antiaim_cicle[z].ab6_delay_type_ms:depend(ab_vis, ab6_tick_check, {antiaim_cicle[z].ab6_delay_type, "MS"})
    antiaim_cicle[z].ab6_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab6_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab6_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab6_jitter_type:depend(ab_vis, ab6_jitter)
    antiaim_cicle[z].ab6_jitter_center:depend(ab_vis, ab6_jitter, {antiaim_cicle[z].ab6_jitter_type, "Default"})
    antiaim_cicle[z].ab6_jitter_center_left:depend(ab_vis, ab6_jitter, {antiaim_cicle[z].ab6_jitter_type, "L&R"})
    antiaim_cicle[z].ab6_jitter_center_right:depend(ab_vis, ab6_jitter, {antiaim_cicle[z].ab6_jitter_type, "L&R"})
    antiaim_cicle[z].ab6_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab6_options:depend(ab_vis, ab6_bodyyaw)
    antiaim_cicle[z].ab6_freestand:depend(ab_vis, ab6_bodyyaw)
    antiaim_cicle[z].ab6_lby_l:depend(ab_vis, ab6_bodyyaw)
    antiaim_cicle[z].ab6_lby_r:depend(ab_vis, ab6_bodyyaw)
    antiaim_cicle[z].ab6_def_type:depend(ab_vis)
    antiaim_cicle[z].ab6_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab6_def_yaw_type:depend(ab_vis, ab6_defensive)
    antiaim_cicle[z].ab6_yaw_sens:depend(ab_vis, ab6_defensive, {antiaim_cicle[z].ab6_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab6_way_delay:depend(ab_vis, ab6_defensive, ab6_custom_way)
    antiaim_cicle[z].ab6_way_select:depend(ab_vis, ab6_defensive, ab6_custom_way)
    antiaim_cicle[z].ab6_way1:depend(ab_vis, ab6_defensive, ab6_custom_way, ab6_select_way1)
    antiaim_cicle[z].ab6_way2:depend(ab_vis, ab6_defensive, ab6_custom_way, ab6_select_way2)
    antiaim_cicle[z].ab6_way3:depend(ab_vis, ab6_defensive, ab6_custom_way, ab6_select_way3)
    antiaim_cicle[z].ab6_way4:depend(ab_vis, ab6_defensive, ab6_custom_way, ab6_select_way4)
    antiaim_cicle[z].ab6_way5:depend(ab_vis, ab6_defensive, ab6_custom_way, ab6_select_way5)
    antiaim_cicle[z].ab6_def_pitch_type:depend(ab_vis, ab6_defensive)
    antiaim_cicle[z].ab6_def_pitch:depend(ab_vis, ab6_defensive, {antiaim_cicle[z].ab6_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab6_p_way_delay:depend(ab_vis, ab6_defensive, ab6_p_way)
    antiaim_cicle[z].ab6_p_way_select:depend(ab_vis, ab6_defensive, ab6_p_way)
    antiaim_cicle[z].ab6_p_way1:depend(ab_vis, ab6_defensive, ab6_p_way1, ab6_p_way)
    antiaim_cicle[z].ab6_p_way2:depend(ab_vis, ab6_defensive, ab6_p_way2, ab6_p_way)
    antiaim_cicle[z].ab6_p_way3:depend(ab_vis, ab6_defensive, ab6_p_way3, ab6_p_way)
    antiaim_cicle[z].ab6_p_way4:depend(ab_vis, ab6_defensive, ab6_p_way4, ab6_p_way)
    antiaim_cicle[z].ab6_p_way5:depend(ab_vis, ab6_defensive, ab6_p_way5, ab6_p_way)


    ---ab7
    ab7_tick_check = {antiaim_cicle[z].ab7_yaw_type, function() if antiaim_cicle[z].ab7_yaw_type:get() == "Default" then return false else return true end end}
    ab7_jitter = {antiaim_cicle[z].ab7_jit_type, function() if antiaim_cicle[z].ab7_jit_type:get() == "Disabled" then return false else return true end end}
    ab7_bodyyaw = {antiaim_cicle[z].ab7_bodyyaw, "Default"}
    ab7_defensive = antiaim_cicle[z].ab7_def_aa

    ab7_custom_way = {antiaim_cicle[z].ab7_def_yaw_type, "Custom Ways"}
    ab7_select_way1 = {antiaim_cicle[z].ab7_way_select, function() if antiaim_cicle[z].ab7_way_select:get() >= 1 then return true else return false end end}
    ab7_select_way2 = {antiaim_cicle[z].ab7_way_select, function() if antiaim_cicle[z].ab7_way_select:get() >= 2 then return true else return false end end}
    ab7_select_way3 = {antiaim_cicle[z].ab7_way_select, function() if antiaim_cicle[z].ab7_way_select:get() >= 3 then return true else return false end end}
    ab7_select_way4 = {antiaim_cicle[z].ab7_way_select, function() if antiaim_cicle[z].ab7_way_select:get() >= 4 then return true else return false end end}
    ab7_select_way5 = {antiaim_cicle[z].ab7_way_select, function() if antiaim_cicle[z].ab7_way_select:get() >= 5 then return true else return false end end}
    ab7_p_way = {antiaim_cicle[z].ab7_def_pitch_type, "Custom Ways"}
    ab7_p_way1 = {antiaim_cicle[z].ab7_p_way_select, function() if antiaim_cicle[z].ab7_p_way_select:get() >= 1 then return true else return false end end}
    ab7_p_way2 = {antiaim_cicle[z].ab7_p_way_select, function() if antiaim_cicle[z].ab7_p_way_select:get() >= 2 then return true else return false end end}
    ab7_p_way3 = {antiaim_cicle[z].ab7_p_way_select, function() if antiaim_cicle[z].ab7_p_way_select:get() >= 3 then return true else return false end end}
    ab7_p_way4 = {antiaim_cicle[z].ab7_p_way_select, function() if antiaim_cicle[z].ab7_p_way_select:get() >= 4 then return true else return false end end}
    ab7_p_way5 = {antiaim_cicle[z].ab7_p_way_select, function() if antiaim_cicle[z].ab7_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab7_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 7 then return true else return false end end})
    antiaim_cicle[z].ab7_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab7_delay_type:depend(ab_vis, ab7_tick_check)
    antiaim_cicle[z].ab7_delay_type_t:depend(ab_vis, ab7_tick_check, {antiaim_cicle[z].ab7_delay_type, "Ticks"})
    antiaim_cicle[z].ab7_delay_type_ms:depend(ab_vis, ab7_tick_check, {antiaim_cicle[z].ab7_delay_type, "MS"})
    antiaim_cicle[z].ab7_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab7_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab7_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab7_jitter_type:depend(ab_vis, ab7_jitter)
    antiaim_cicle[z].ab7_jitter_center:depend(ab_vis, ab7_jitter, {antiaim_cicle[z].ab7_jitter_type, "Default"})
    antiaim_cicle[z].ab7_jitter_center_left:depend(ab_vis, ab7_jitter, {antiaim_cicle[z].ab7_jitter_type, "L&R"})
    antiaim_cicle[z].ab7_jitter_center_right:depend(ab_vis, ab7_jitter, {antiaim_cicle[z].ab7_jitter_type, "L&R"})
    antiaim_cicle[z].ab7_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab7_options:depend(ab_vis, ab7_bodyyaw)
    antiaim_cicle[z].ab7_freestand:depend(ab_vis, ab7_bodyyaw)
    antiaim_cicle[z].ab7_lby_l:depend(ab_vis, ab7_bodyyaw)
    antiaim_cicle[z].ab7_lby_r:depend(ab_vis, ab7_bodyyaw)
    antiaim_cicle[z].ab7_def_type:depend(ab_vis)
    antiaim_cicle[z].ab7_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab7_def_yaw_type:depend(ab_vis, ab7_defensive)
    antiaim_cicle[z].ab7_yaw_sens:depend(ab_vis, ab7_defensive, {antiaim_cicle[z].ab7_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab7_way_delay:depend(ab_vis, ab7_defensive, ab7_custom_way)
    antiaim_cicle[z].ab7_way_select:depend(ab_vis, ab7_defensive, ab7_custom_way)
    antiaim_cicle[z].ab7_way1:depend(ab_vis, ab7_defensive, ab7_custom_way, ab7_select_way1)
    antiaim_cicle[z].ab7_way2:depend(ab_vis, ab7_defensive, ab7_custom_way, ab7_select_way2)
    antiaim_cicle[z].ab7_way3:depend(ab_vis, ab7_defensive, ab7_custom_way, ab7_select_way3)
    antiaim_cicle[z].ab7_way4:depend(ab_vis, ab7_defensive, ab7_custom_way, ab7_select_way4)
    antiaim_cicle[z].ab7_way5:depend(ab_vis, ab7_defensive, ab7_custom_way, ab7_select_way5)
    antiaim_cicle[z].ab7_def_pitch_type:depend(ab_vis, ab7_defensive)
    antiaim_cicle[z].ab7_def_pitch:depend(ab_vis, ab7_defensive, {antiaim_cicle[z].ab7_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab7_p_way_delay:depend(ab_vis, ab7_defensive, ab7_p_way)
    antiaim_cicle[z].ab7_p_way_select:depend(ab_vis, ab7_defensive, ab7_p_way)
    antiaim_cicle[z].ab7_p_way1:depend(ab_vis, ab7_defensive, ab7_p_way1, ab7_p_way)
    antiaim_cicle[z].ab7_p_way2:depend(ab_vis, ab7_defensive, ab7_p_way2, ab7_p_way)
    antiaim_cicle[z].ab7_p_way3:depend(ab_vis, ab7_defensive, ab7_p_way3, ab7_p_way)
    antiaim_cicle[z].ab7_p_way4:depend(ab_vis, ab7_defensive, ab7_p_way4, ab7_p_way)
    antiaim_cicle[z].ab7_p_way5:depend(ab_vis, ab7_defensive, ab7_p_way5, ab7_p_way)


    --ab8
    ab8_tick_check = {antiaim_cicle[z].ab8_yaw_type, function() if antiaim_cicle[z].ab8_yaw_type:get() == "Default" then return false else return true end end}
    ab8_jitter = {antiaim_cicle[z].ab8_jit_type, function() if antiaim_cicle[z].ab8_jit_type:get() == "Disabled" then return false else return true end end}
    ab8_bodyyaw = {antiaim_cicle[z].ab8_bodyyaw, "Default"}
    ab8_defensive = antiaim_cicle[z].ab8_def_aa

    ab8_custom_way = {antiaim_cicle[z].ab8_def_yaw_type, "Custom Ways"}
    ab8_select_way1 = {antiaim_cicle[z].ab8_way_select, function() if antiaim_cicle[z].ab8_way_select:get() >= 1 then return true else return false end end}
    ab8_select_way2 = {antiaim_cicle[z].ab8_way_select, function() if antiaim_cicle[z].ab8_way_select:get() >= 2 then return true else return false end end}
    ab8_select_way3 = {antiaim_cicle[z].ab8_way_select, function() if antiaim_cicle[z].ab8_way_select:get() >= 3 then return true else return false end end}
    ab8_select_way4 = {antiaim_cicle[z].ab8_way_select, function() if antiaim_cicle[z].ab8_way_select:get() >= 4 then return true else return false end end}
    ab8_select_way5 = {antiaim_cicle[z].ab8_way_select, function() if antiaim_cicle[z].ab8_way_select:get() >= 5 then return true else return false end end}
    ab8_p_way = {antiaim_cicle[z].ab8_def_pitch_type, "Custom Ways"}
    ab8_p_way1 = {antiaim_cicle[z].ab8_p_way_select, function() if antiaim_cicle[z].ab8_p_way_select:get() >= 1 then return true else return false end end}
    ab8_p_way2 = {antiaim_cicle[z].ab8_p_way_select, function() if antiaim_cicle[z].ab8_p_way_select:get() >= 2 then return true else return false end end}
    ab8_p_way3 = {antiaim_cicle[z].ab8_p_way_select, function() if antiaim_cicle[z].ab8_p_way_select:get() >= 3 then return true else return false end end}
    ab8_p_way4 = {antiaim_cicle[z].ab8_p_way_select, function() if antiaim_cicle[z].ab8_p_way_select:get() >= 4 then return true else return false end end}
    ab8_p_way5 = {antiaim_cicle[z].ab8_p_way_select, function() if antiaim_cicle[z].ab8_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab8_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 8 then return true else return false end end})
    antiaim_cicle[z].ab8_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab8_delay_type:depend(ab_vis, ab8_tick_check)
    antiaim_cicle[z].ab8_delay_type_t:depend(ab_vis, ab8_tick_check, {antiaim_cicle[z].ab8_delay_type, "Ticks"})
    antiaim_cicle[z].ab8_delay_type_ms:depend(ab_vis, ab8_tick_check, {antiaim_cicle[z].ab8_delay_type, "MS"})
    antiaim_cicle[z].ab8_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab8_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab8_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab8_jitter_type:depend(ab_vis, ab8_jitter)
    antiaim_cicle[z].ab8_jitter_center:depend(ab_vis, ab8_jitter, {antiaim_cicle[z].ab8_jitter_type, "Default"})
    antiaim_cicle[z].ab8_jitter_center_left:depend(ab_vis, ab8_jitter, {antiaim_cicle[z].ab8_jitter_type, "L&R"})
    antiaim_cicle[z].ab8_jitter_center_right:depend(ab_vis, ab8_jitter, {antiaim_cicle[z].ab8_jitter_type, "L&R"})
    antiaim_cicle[z].ab8_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab8_options:depend(ab_vis, ab8_bodyyaw)
    antiaim_cicle[z].ab8_freestand:depend(ab_vis, ab8_bodyyaw)
    antiaim_cicle[z].ab8_lby_l:depend(ab_vis, ab8_bodyyaw)
    antiaim_cicle[z].ab8_lby_r:depend(ab_vis, ab8_bodyyaw)
    antiaim_cicle[z].ab8_def_type:depend(ab_vis)
    antiaim_cicle[z].ab8_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab8_def_yaw_type:depend(ab_vis, ab8_defensive)
    antiaim_cicle[z].ab8_yaw_sens:depend(ab_vis, ab8_defensive, {antiaim_cicle[z].ab8_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab8_way_delay:depend(ab_vis, ab8_defensive, ab8_custom_way)
    antiaim_cicle[z].ab8_way_select:depend(ab_vis, ab8_defensive, ab8_custom_way)
    antiaim_cicle[z].ab8_way1:depend(ab_vis, ab8_defensive, ab8_custom_way, ab8_select_way1)
    antiaim_cicle[z].ab8_way2:depend(ab_vis, ab8_defensive, ab8_custom_way, ab8_select_way2)
    antiaim_cicle[z].ab8_way3:depend(ab_vis, ab8_defensive, ab8_custom_way, ab8_select_way3)
    antiaim_cicle[z].ab8_way4:depend(ab_vis, ab8_defensive, ab8_custom_way, ab8_select_way4)
    antiaim_cicle[z].ab8_way5:depend(ab_vis, ab8_defensive, ab8_custom_way, ab8_select_way5)
    antiaim_cicle[z].ab8_def_pitch_type:depend(ab_vis, ab8_defensive)
    antiaim_cicle[z].ab8_def_pitch:depend(ab_vis, ab8_defensive, {antiaim_cicle[z].ab8_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab8_p_way_delay:depend(ab_vis, ab8_defensive, ab8_p_way)
    antiaim_cicle[z].ab8_p_way_select:depend(ab_vis, ab8_defensive, ab8_p_way)
    antiaim_cicle[z].ab8_p_way1:depend(ab_vis, ab8_defensive, ab8_p_way1, ab8_p_way)
    antiaim_cicle[z].ab8_p_way2:depend(ab_vis, ab8_defensive, ab8_p_way2, ab8_p_way)
    antiaim_cicle[z].ab8_p_way3:depend(ab_vis, ab8_defensive, ab8_p_way3, ab8_p_way)
    antiaim_cicle[z].ab8_p_way4:depend(ab_vis, ab8_defensive, ab8_p_way4, ab8_p_way)
    antiaim_cicle[z].ab8_p_way5:depend(ab_vis, ab8_defensive, ab8_p_way5, ab8_p_way)

    --ab9
    ab9_tick_check = {antiaim_cicle[z].ab9_yaw_type, function() if antiaim_cicle[z].ab9_yaw_type:get() == "Default" then return false else return true end end}
    ab9_jitter = {antiaim_cicle[z].ab9_jit_type, function() if antiaim_cicle[z].ab9_jit_type:get() == "Disabled" then return false else return true end end}
    ab9_bodyyaw = {antiaim_cicle[z].ab9_bodyyaw, "Default"}
    ab9_defensive = antiaim_cicle[z].ab9_def_aa

    ab9_custom_way = {antiaim_cicle[z].ab9_def_yaw_type, "Custom Ways"}
    ab9_select_way1 = {antiaim_cicle[z].ab9_way_select, function() if antiaim_cicle[z].ab9_way_select:get() >= 1 then return true else return false end end}
    ab9_select_way2 = {antiaim_cicle[z].ab9_way_select, function() if antiaim_cicle[z].ab9_way_select:get() >= 2 then return true else return false end end}
    ab9_select_way3 = {antiaim_cicle[z].ab9_way_select, function() if antiaim_cicle[z].ab9_way_select:get() >= 3 then return true else return false end end}
    ab9_select_way4 = {antiaim_cicle[z].ab9_way_select, function() if antiaim_cicle[z].ab9_way_select:get() >= 4 then return true else return false end end}
    ab9_select_way5 = {antiaim_cicle[z].ab9_way_select, function() if antiaim_cicle[z].ab9_way_select:get() >= 5 then return true else return false end end}
    ab9_p_way = {antiaim_cicle[z].ab9_def_pitch_type, "Custom Ways"}
    ab9_p_way1 = {antiaim_cicle[z].ab9_p_way_select, function() if antiaim_cicle[z].ab9_p_way_select:get() >= 1 then return true else return false end end}
    ab9_p_way2 = {antiaim_cicle[z].ab9_p_way_select, function() if antiaim_cicle[z].ab9_p_way_select:get() >= 2 then return true else return false end end}
    ab9_p_way3 = {antiaim_cicle[z].ab9_p_way_select, function() if antiaim_cicle[z].ab9_p_way_select:get() >= 3 then return true else return false end end}
    ab9_p_way4 = {antiaim_cicle[z].ab9_p_way_select, function() if antiaim_cicle[z].ab9_p_way_select:get() >= 4 then return true else return false end end}
    ab9_p_way5 = {antiaim_cicle[z].ab9_p_way_select, function() if antiaim_cicle[z].ab9_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab9_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 9 then return true else return false end end})
    antiaim_cicle[z].ab9_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab9_delay_type:depend(ab_vis, ab9_tick_check)
    antiaim_cicle[z].ab9_delay_type_t:depend(ab_vis, ab9_tick_check, {antiaim_cicle[z].ab9_delay_type, "Ticks"})
    antiaim_cicle[z].ab9_delay_type_ms:depend(ab_vis, ab9_tick_check, {antiaim_cicle[z].ab9_delay_type, "MS"})
    antiaim_cicle[z].ab9_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab9_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab9_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab9_jitter_type:depend(ab_vis, ab9_jitter)
    antiaim_cicle[z].ab9_jitter_center:depend(ab_vis, ab9_jitter, {antiaim_cicle[z].ab9_jitter_type, "Default"})
    antiaim_cicle[z].ab9_jitter_center_left:depend(ab_vis, ab9_jitter, {antiaim_cicle[z].ab9_jitter_type, "L&R"})
    antiaim_cicle[z].ab9_jitter_center_right:depend(ab_vis, ab9_jitter, {antiaim_cicle[z].ab9_jitter_type, "L&R"})
    antiaim_cicle[z].ab9_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab9_options:depend(ab_vis, ab9_bodyyaw)
    antiaim_cicle[z].ab9_freestand:depend(ab_vis, ab9_bodyyaw)
    antiaim_cicle[z].ab9_lby_l:depend(ab_vis, ab9_bodyyaw)
    antiaim_cicle[z].ab9_lby_r:depend(ab_vis, ab9_bodyyaw)
    antiaim_cicle[z].ab9_def_type:depend(ab_vis)
    antiaim_cicle[z].ab9_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab9_def_yaw_type:depend(ab_vis, ab9_defensive)
    antiaim_cicle[z].ab9_yaw_sens:depend(ab_vis, ab9_defensive, {antiaim_cicle[z].ab9_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab9_way_delay:depend(ab_vis, ab9_defensive, ab9_custom_way)
    antiaim_cicle[z].ab9_way_select:depend(ab_vis, ab9_defensive, ab9_custom_way)
    antiaim_cicle[z].ab9_way1:depend(ab_vis, ab9_defensive, ab9_custom_way, ab9_select_way1)
    antiaim_cicle[z].ab9_way2:depend(ab_vis, ab9_defensive, ab9_custom_way, ab9_select_way2)
    antiaim_cicle[z].ab9_way3:depend(ab_vis, ab9_defensive, ab9_custom_way, ab9_select_way3)
    antiaim_cicle[z].ab9_way4:depend(ab_vis, ab9_defensive, ab9_custom_way, ab9_select_way4)
    antiaim_cicle[z].ab9_way5:depend(ab_vis, ab9_defensive, ab9_custom_way, ab9_select_way5)
    antiaim_cicle[z].ab9_def_pitch_type:depend(ab_vis, ab9_defensive)
    antiaim_cicle[z].ab9_def_pitch:depend(ab_vis, ab9_defensive, {antiaim_cicle[z].ab9_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab9_p_way_delay:depend(ab_vis, ab9_defensive, ab9_p_way)
    antiaim_cicle[z].ab9_p_way_select:depend(ab_vis, ab9_defensive, ab9_p_way)
    antiaim_cicle[z].ab9_p_way1:depend(ab_vis, ab9_defensive, ab9_p_way1, ab9_p_way)
    antiaim_cicle[z].ab9_p_way2:depend(ab_vis, ab9_defensive, ab9_p_way2, ab9_p_way)
    antiaim_cicle[z].ab9_p_way3:depend(ab_vis, ab9_defensive, ab9_p_way3, ab9_p_way)
    antiaim_cicle[z].ab9_p_way4:depend(ab_vis, ab9_defensive, ab9_p_way4, ab9_p_way)
    antiaim_cicle[z].ab9_p_way5:depend(ab_vis, ab9_defensive, ab9_p_way5, ab9_p_way)


    ---ab10
    ab10_tick_check = {antiaim_cicle[z].ab10_yaw_type, function() if antiaim_cicle[z].ab10_yaw_type:get() == "Default" then return false else return true end end}
    ab10_jitter = {antiaim_cicle[z].ab10_jit_type, function() if antiaim_cicle[z].ab10_jit_type:get() == "Disabled" then return false else return true end end}
    ab10_bodyyaw = {antiaim_cicle[z].ab10_bodyyaw, "Default"}
    ab10_defensive = antiaim_cicle[z].ab10_def_aa

    ab10_custom_way = {antiaim_cicle[z].ab10_def_yaw_type, "Custom Ways"}
    ab10_select_way1 = {antiaim_cicle[z].ab10_way_select, function() if antiaim_cicle[z].ab10_way_select:get() >= 1 then return true else return false end end}
    ab10_select_way2 = {antiaim_cicle[z].ab10_way_select, function() if antiaim_cicle[z].ab10_way_select:get() >= 2 then return true else return false end end}
    ab10_select_way3 = {antiaim_cicle[z].ab10_way_select, function() if antiaim_cicle[z].ab10_way_select:get() >= 3 then return true else return false end end}
    ab10_select_way4 = {antiaim_cicle[z].ab10_way_select, function() if antiaim_cicle[z].ab10_way_select:get() >= 4 then return true else return false end end}
    ab10_select_way5 = {antiaim_cicle[z].ab10_way_select, function() if antiaim_cicle[z].ab10_way_select:get() >= 5 then return true else return false end end}
    ab10_p_way = {antiaim_cicle[z].ab10_def_pitch_type, "Custom Ways"}
    ab10_p_way1 = {antiaim_cicle[z].ab10_p_way_select, function() if antiaim_cicle[z].ab10_p_way_select:get() >= 1 then return true else return false end end}
    ab10_p_way2 = {antiaim_cicle[z].ab10_p_way_select, function() if antiaim_cicle[z].ab10_p_way_select:get() >= 2 then return true else return false end end}
    ab10_p_way3 = {antiaim_cicle[z].ab10_p_way_select, function() if antiaim_cicle[z].ab10_p_way_select:get() >= 3 then return true else return false end end}
    ab10_p_way4 = {antiaim_cicle[z].ab10_p_way_select, function() if antiaim_cicle[z].ab10_p_way_select:get() >= 4 then return true else return false end end}
    ab10_p_way5 = {antiaim_cicle[z].ab10_p_way_select, function() if antiaim_cicle[z].ab10_p_way_select:get() >= 5 then return true else return false end end}

    antiaim_cicle[z].ab10_label:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_phase, function() if antiaim_cicle[z].ab_phase:get() >= 10 then return true else return false end end})
    antiaim_cicle[z].ab10_yaw_type:depend(ab_vis)
    antiaim_cicle[z].ab10_delay_type:depend(ab_vis, ab10_tick_check)
    antiaim_cicle[z].ab10_delay_type_t:depend(ab_vis, ab10_tick_check, {antiaim_cicle[z].ab10_delay_type, "Ticks"})
    antiaim_cicle[z].ab10_delay_type_ms:depend(ab_vis, ab10_tick_check, {antiaim_cicle[z].ab10_delay_type, "MS"})
    antiaim_cicle[z].ab10_yaw_l:depend(ab_vis)
    antiaim_cicle[z].ab10_yaw_r:depend(ab_vis)
    antiaim_cicle[z].ab10_jit_type:depend(ab_vis)
    antiaim_cicle[z].ab10_jitter_type:depend(ab_vis, ab10_jitter)
    antiaim_cicle[z].ab10_jitter_center:depend(ab_vis, ab10_jitter, {antiaim_cicle[z].ab10_jitter_type, "Default"})
    antiaim_cicle[z].ab10_jitter_center_left:depend(ab_vis, ab10_jitter, {antiaim_cicle[z].ab10_jitter_type, "L&R"})
    antiaim_cicle[z].ab10_jitter_center_right:depend(ab_vis, ab10_jitter, {antiaim_cicle[z].ab10_jitter_type, "L&R"})
    antiaim_cicle[z].ab10_bodyyaw:depend(ab_vis)
    antiaim_cicle[z].ab10_options:depend(ab_vis, ab10_bodyyaw)
    antiaim_cicle[z].ab10_freestand:depend(ab_vis, ab10_bodyyaw)
    antiaim_cicle[z].ab10_lby_l:depend(ab_vis, ab10_bodyyaw)
    antiaim_cicle[z].ab10_lby_r:depend(ab_vis, ab10_bodyyaw)
    antiaim_cicle[z].ab10_def_type:depend(ab_vis)
    antiaim_cicle[z].ab10_def_aa:depend(ab_vis)
    antiaim_cicle[z].ab10_def_yaw_type:depend(ab_vis, ab10_defensive)
    antiaim_cicle[z].ab10_yaw_sens:depend(ab_vis, ab10_defensive, {antiaim_cicle[z].ab10_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab10_way_delay:depend(ab_vis, ab10_defensive, ab10_custom_way)
    antiaim_cicle[z].ab10_way_select:depend(ab_vis, ab10_defensive, ab10_custom_way)
    antiaim_cicle[z].ab10_way1:depend(ab_vis, ab10_defensive, ab10_custom_way, ab10_select_way1)
    antiaim_cicle[z].ab10_way2:depend(ab_vis, ab10_defensive, ab10_custom_way, ab10_select_way2)
    antiaim_cicle[z].ab10_way3:depend(ab_vis, ab10_defensive, ab10_custom_way, ab10_select_way3)
    antiaim_cicle[z].ab10_way4:depend(ab_vis, ab10_defensive, ab10_custom_way, ab10_select_way4)
    antiaim_cicle[z].ab10_way5:depend(ab_vis, ab10_defensive, ab10_custom_way, ab10_select_way5)
    antiaim_cicle[z].ab10_def_pitch_type:depend(ab_vis, ab10_defensive)
    antiaim_cicle[z].ab10_def_pitch:depend(ab_vis, ab10_defensive, {antiaim_cicle[z].ab10_def_pitch_type, "Custom"})
    antiaim_cicle[z].ab10_p_way_delay:depend(ab_vis, ab10_defensive, ab10_p_way)
    antiaim_cicle[z].ab10_p_way_select:depend(ab_vis, ab10_defensive, ab10_p_way)
    antiaim_cicle[z].ab10_p_way1:depend(ab_vis, ab10_defensive, ab10_p_way1, ab10_p_way)
    antiaim_cicle[z].ab10_p_way2:depend(ab_vis, ab10_defensive, ab10_p_way2, ab10_p_way)
    antiaim_cicle[z].ab10_p_way3:depend(ab_vis, ab10_defensive, ab10_p_way3, ab10_p_way)
    antiaim_cicle[z].ab10_p_way4:depend(ab_vis, ab10_defensive, ab10_p_way4, ab10_p_way)
    antiaim_cicle[z].ab10_p_way5:depend(ab_vis, ab10_defensive, ab10_p_way5, ab10_p_way)
end
local screen_size = render.screen_size()
username, screen_center = common.get_username(), screen_size * 0.5

math.pulse = function()
    return math.clamp((math.floor(math.sin(globals.curtime * 2) * 220 + 221)) / 900 * 6.92, 0, 1) * 235 + 20
end

hit_check = 0
miss_check = 0

local function sense_ind_func()
    y = 30
    local active_binds = ui.get_binds()
    hitrate = math.ceil(hit_check/miss_check*100)
    if hit_check == 0 or miss_check == 0 then
        text_miss = hit_check.." / "..miss_check.." (0%)"
    else
        text_miss = hit_check.." / "..miss_check.." ("..math.ceil(hit_check/miss_check*100).."%)"
    end
    if visual_table.sense_select:get(1) then
        renderer.indicator(color(255, 255, 255, 255), text_miss,  y, true)
        y = y - 35
    end

    for i in pairs(active_binds) do
		if active_binds[i].name == "Fake Latency" and visual_table.sense_select:get(10) then
			if active_binds[i].active then
                renderer.indicator(color(), "\a74C029FFPING",  y, true)
                y = y - 35
			end
		end

        if active_binds[i].name == "Hit Chance" and visual_table.sense_select:get(5) then
			if active_binds[i].active then
                renderer.indicator(color(255, 255, 255, 255), "HC: "..ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):get(),  y, true)
                y = y - 35
			end
		end

        if active_binds[i].name == "Min. Damage" and visual_table.sense_select:get(3) then
			if active_binds[i].active then
                renderer.indicator(color(255, 255, 255, 255), "DMG: "..ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get(),  y, true)
                y = y - 35
			end
		end
	end

    if ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"):get() == "Force" and visual_table.sense_select:get(11) then
        renderer.indicator(color(255, 255, 255, 255), "SAFE",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"):get() == "Force" and visual_table.sense_select:get(8) then
        renderer.indicator(color(255, 255, 255, 255), "BAIM",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() and visual_table.sense_select:get(9) then
        renderer.indicator(color(255, 255, 255, 255), "DUCK",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):get() and visual_table.sense_select:get(2) then
        renderer.indicator(color(255, 255, 255, 255), "FS",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and visual_table.sense_select:get(6) then
        renderer.indicator(color(255, 255, 255, 255), "OSAA",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and visual_table.sense_select:get(4) then
        renderer.indicator(color(255, 255*rage.exploit:get(), 255*rage.exploit:get(), 255), "DT",  y, true)
        y = y - 35
    end

    if ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):get() and visual_table.sense_select:get(7) then
        renderer.indicator(color(255, 255, 255, 255), "DA",  y, true)
        y = y - 35
    end
end


local function crosshair_indicator()
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not local_player:is_alive() then return end
	MTools.Animation:Register("cross_ind");
	MTools.Animation:Update("cross_ind", 6);
	space_lerp = MTools.Animation:Lerp("cross_ind", "space.codes", (local_player.m_bIsScoped), vector(screen_center.x, screen_center.y), vector(screen_center.x + 40, screen_center.y), 30);
	local cross_gradient = gradient.text_animate("SPACE", -1, {
		visual_table.crosshair_color1:get(), 
		visual_table.crosshair_color2:get()
	})
    local cross_gradient2 = gradient.text_animate("SPACE.CODES", -1, {
		visual_table.crosshair_color1:get(), 
		visual_table.crosshair_color2:get()
	})
    local cross_gradient3 = gradient.text_animate("SPACE", -1, {
		visual_table.crosshair_color1:get(), 
		visual_table.crosshair_color2:get()
	})
    if visual_table.crosshair_style:get() == 1 then
        render.shadow(vector(space_lerp.x-25, screen_center.y + 40), vector(space_lerp.x-4, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.shadow(vector(space_lerp.x+4, screen_center.y + 40), vector(space_lerp.x + 22, screen_center.y + 40), color(255, 255, 255, math.pulse()), 20, 0, 0)
        render.text(2, vector(space_lerp.x-13, screen_center.y + 40), color(), "c", cross_gradient:get_animated_text())
        render.text(2, vector(space_lerp.x+15, screen_center.y + 40), color(visual_table.crosshair_color2:get().r, visual_table.crosshair_color2:get().g, visual_table.crosshair_color2:get().b, math.pulse()), "c", "GALAXY")
    elseif visual_table.crosshair_style:get() == 2 then
        render.shadow(vector(space_lerp.x-22, screen_center.y + 40), vector(space_lerp.x+22, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.text(2, vector(space_lerp.x+2, screen_center.y + 40), color(), "c", cross_gradient2:get_animated_text())
        render.text(2, vector(space_lerp.x+2, screen_center.y + 30), color(visual_table.crosshair_color2:get().r, visual_table.crosshair_color2:get().g, visual_table.crosshair_color2:get().b, math.pulse()), "c", "GALAXY")
    else
        render.shadow(vector(space_lerp.x-12, screen_center.y + 40), vector(space_lerp.x+12, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.text(2, vector(space_lerp.x+1, screen_center.y + 40), color(), "c", cross_gradient3:get_animated_text())
    end
	ind_space = 2
    if reference.dt:get() then
		render.text(2, vector(space_lerp.x+2, screen_center.y+17 + ind_space+30), color(255,rage.exploit:get()*255,rage.exploit:get()*255,255), "c", "DT")
        ind_space = ind_space + 10
	end
    local active_binds = ui.get_binds()
	for i in pairs(active_binds) do
		if active_binds[i].name == "Min. Damage" then
			if active_binds[i].active then
                if not local_player.m_bIsScoped then
				    render.text(2, vector(space_lerp.x+2, screen_center.y+17+ind_space+30), color(), "c", "DMG")
                else
                    render.text(2, vector(space_lerp.x+3, screen_center.y+17+ind_space+30), color(), "c", "DMG")
                end
                ind_space = ind_space + 10
			end
		end
	end
	if reference.hideshots:get() then
		render.text(2, vector(space_lerp.x+3, screen_center.y+17 + ind_space+30), color(), "c", "HS")
        ind_space = ind_space + 10
	end
	if aa_table.freestanding:get() then
		render.text(2, vector(space_lerp.x+2, screen_center.y+17 + ind_space+30), color(), "c", "FS")
        ind_space = ind_space + 10
	end
	for i in pairs(active_binds) do
		if active_binds[i].name == "Safe Points" then
			if active_binds[i].active then
				render.text(2, vector(space_lerp.x+3, screen_center.y+17 + ind_space+30), color(), "c", "SP")
                ind_space = ind_space + 10
			end
		end
	end
	for i in pairs(active_binds) do
		if active_binds[i].name == "Body Aim" then
			if active_binds[i].active then
                if not local_player.m_bIsScoped then
				    render.text(2, vector(space_lerp.x+2, screen_center.y+17 + ind_space+30), color(), "c", "BA")
                else
                    render.text(2, vector(space_lerp.x+3, screen_center.y+17 + ind_space+30), color(), "c", "BA")
                end
                ind_space = ind_space + 10
			end
		end
	end
	for i in pairs(active_binds) do
		if active_binds[i].name == "Hit Chance" then
			if active_binds[i].active then
                if not local_player.m_bIsScoped then
				    render.text(2, vector(space_lerp.x+2, screen_center.y+47 + ind_space), color(), "c", "HC")
                else
                    render.text(2, vector(space_lerp.x+3, screen_center.y+47 + ind_space), color(), "c", "HC")
                end
                ind_space = ind_space + 10
			end
		end
	end
	cross_gradient:animate()
    cross_gradient2:animate()
    cross_gradient3:animate()
end

local function xueten()
   render.text(1, vector(screen_size.x-100, 39), color(255), nil, "discord.gg/\a8787FFFFsxc")
   render.shadow(vector(screen_size.x-100, 45), vector(screen_size.x-32, 45), color(255, 255, 255, 255), 20, 0, 0)
end


damage_x = tabs.visuals:slider("dmg_x", 1, screen_size.x, screen_center.x + 10)
damage_y = tabs.visuals:slider("dmg_y", 1, screen_size.y, screen_center.y - 25)
damage_x:visibility(false)
damage_y:visibility(false)
local mindmg_drag = drag_system.register({damage_x, damage_y}, vector(20, 20), "MinDMG", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    if visual_table.mindmg_font:get() == "Default" then
        font = 1
    elseif visual_table.mindmg_font:get() == "Small" then
        font = 2
    elseif visual_table.mindmg_font:get() == "Console" then
        font = 3
    else
        font = 4
    end
	render.text(font, vector(self.position.x + 11, self.position.y + 10), color(), "cbd", ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end)

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end
main = {}
vel_x = tabs.visuals:slider("x", 1, render.screen_size().x, render.screen_size().x/2-90)
vel_y = tabs.visuals:slider("y", 1, render.screen_size().y, render.screen_size().y/2-250)
vel_x:visibility(false)
vel_y:visibility(false)
main.size = 0
main.vel_alpha = 0
local velocity_ind = drag_system.register({vel_x, vel_y}, vector(190, 40), "Velocity", function(self)
    if entity.get_local_player() then
        if not entity.get_local_player():is_alive() then return end
        local vel_mod = entity.get_local_player().m_flVelocityModifier  
        if ui.get_alpha() > 0 or vel_mod < 1 then
            main.vel_alpha = math.lerp(main.vel_alpha, 1, 12)
        else
            main.vel_alpha = math.lerp(main.vel_alpha, 0, 12)
        end
        main.size = vel_mod * 160 == 160 and math.lerp(vel_mod * 160, main.size, 4) or math.lerp(main.size, vel_mod * 160, 4)
        local x,y,w = self.x, self.y, self.w
        local gc1, gc2, gc3 = visual_table.slowed_down_color:get(), visual_table.slowed_down_color2:get(), visual_table.slowed_down_color3:get()
        local gradient1, gradient2, gradient3 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main.vel_alpha * 255)), color(gc3.r, gc3.g, gc3.b, math.floor(main.vel_alpha * 255))
        if visual_table.slowed_down_type:get() == 1 then
            render.shadow(vector(self.position.x+15, self.position.y+13), vector(self.position.x+175, self.position.y+29), color(255, 255, 255, math.floor(main.vel_alpha * 155)), 25, 0, 4)
            render.rect(vector(self.position.x+15, self.position.y+12), vector(self.position.x+175, self.position.y+30), color(50, 50, 50, math.floor(main.vel_alpha * 150)), 4)
            render.gradient(vector(self.position.x+15, self.position.y+13), vector(self.position.x+15 + main.size, self.position.y+29), gradient2, gradient1, gradient2, gradient1, 4)
            render.rect_outline(vector(self.position.x+15, self.position.y+12), vector(self.position.x+175, self.position.y+30), gradient2, 1, 4)
            render.text(1, vector(self.position.x+45, self.position.y+14), gradient3, nil, "Slowed Down: " ..math.floor(vel_mod * 100).." %")
            render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
        else
            render.rect(vector(self.position.x+15, self.position.y+12), vector(self.position.x+15+main.size, self.position.y+30), color(50, 50, 50, math.floor(main.vel_alpha * 150)), 4)
            render.rect_outline(vector(self.position.x+15, self.position.y+12), vector(self.position.x+175, self.position.y+30), gradient2, 1, 4)
            render.text(1, vector(self.position.x+45, self.position.y+14), gradient3, nil, "Slowed Down: " ..math.floor(vel_mod * 100).." %")
        end
    end
end)

local verdana = render.load_font("Verdana", 21, "ab")

local function ts_arrows()
    local lp = entity.get_local_player()
    if (lp == nil or not lp:is_alive()) then return end
    MTools.Animation:Register("scope");
	MTools.Animation:Update("scope", 6);
	local scope = MTools.Animation:Lerp("scope", "scoping", (lp.m_bIsScoped), vector(screen_center.x, screen_center.y), vector(screen_center.x, screen_center.y-20), 30);
    if visual_table.arrows_type:get() == 1 then
        render.poly(aa_table.yaw_base:get() == "Right" and visual_table.arrows_color:get() or color(35, 35, 35, 150), vector(scope.x+55, scope.y), vector(scope.x+42, scope.y-9), vector(scope.x+42, scope.y+9))
        render.poly(aa_table.yaw_base:get() == "Left" and visual_table.arrows_color:get() or color(35, 35, 35, 150), vector(scope.x-55, scope.y), vector(scope.x-42, scope.y-9), vector(scope.x-42, scope.y+9))   
        render.rect(vector(scope.x+38, scope.y-9), vector(scope.x+40, scope.y+9), rage.antiaim:inverter() == true and visual_table.arrows_color:get() or color(35, 35, 35, 120))
        render.rect(vector(scope.x-40, scope.y-9), vector(scope.x-38, scope.y+9), rage.antiaim:inverter() == false and visual_table.arrows_color:get() or color(35, 35, 35, 120))
    else
        render.text(verdana, vector(scope.x-50, scope.y-1), aa_table.yaw_base:get() == "Left" and visual_table.arrows_color:get() or color(35, 35, 35, 150), "c", "<")
        render.text(verdana, vector(scope.x+50, scope.y-1), aa_table.yaw_base:get() == "Right" and visual_table.arrows_color:get() or color(35, 35, 35, 150), "c", ">")
    end
end

local function customscope()
    if globals.is_connected then
        local me = entity.get_local_player()
        if not me then return end
        if not me:is_alive() then return end
        local x = render.screen_size().x/2
        local y = render.screen_size().y/2
        local Player = entity.get_local_player()
        local Scope = Player.m_bIsScoped
        local col = visual_table.scope_color:get()
        local color = color(col.r, col.g, col.b, 1)
        local FirstCol = (function(a,s) if not visual_table.Scopeinverted:get() then return s else return a end end)(col, color)
        local SecondCol = (function(a,s) if not visual_table.Scopeinverted:get() then return a else return s end end)(col, color)
        if Scope then  
            if visual_table.scope_lines:get("Down") then
                render.gradient(vector(x, y + (visual_table.Scopeoffset:get()-1)+1), vector(x + 1, y + visual_table.Scopelength:get() + (visual_table.Scopeoffset:get()-1)+1), SecondCol, SecondCol, FirstCol, FirstCol) --Нижний
            end
            if visual_table.scope_lines:get("Right") then
                render.gradient(vector((x+1 + (visual_table.Scopelength:get())) + (visual_table.Scopeoffset:get()-1), y), vector(x+1 + (visual_table.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol) --правый
            end
            if visual_table.scope_lines:get("Up") then
                render.gradient(vector(x, y - (visual_table.Scopeoffset:get()-1) - visual_table.Scopelength:get()), vector(x + 1, y - (visual_table.Scopeoffset:get()-1)), FirstCol, FirstCol, SecondCol, SecondCol) --верхний
            end
            if visual_table.scope_lines:get("Left") then
                render.gradient(vector((x - visual_table.Scopelength:get()) - (visual_table.Scopeoffset:get()-1), y), vector(x - (visual_table.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol) --левый
            end
        end
    end
end

---я хуй знает нахуя это нужно
local low_health = 20

local text_example = esp.enemy:new_text("LETHAL IND", "lethal", function(player)
	local health = player.m_iHealth
	if health > low_health then
		return
	end
	return "lethal"
end)

snap_r8_help = false

r8_helper_flag = esp.enemy:new_text("Revolver Helper", "R8 Helper", function(index)
    local lp = entity.get_local_player()
    if not lp:is_alive() then return end
    if index.m_ArmorValue ~= 0 then return end
    origin_local = lp:get_origin()
    origin = index:get_origin()
    local wpn = lp:get_player_weapon()
    if wpn == nil then return end
    local wpn_id = wpn:get_weapon_index()
    if wpn_id ~= 64 then return end
    distance_r = origin_local:dist(origin)
    snap_r8_help = false
    if distance_r > 583 then return end
    snap_r8_help = true
    if index ~= nil and index ~= lp then
        if distance_r < 583 and distance_r > 509 then
            return 'R8 Helper'
        elseif distance_r < 509 then
            return 'R8 Helper+'
        end
    end
end)

---
function lerpx(time,a,b) return a * (1-time) + b * time end
function window(x, y, w, h, name, alpha) 
    local me = entity.get_local_player()
    if not me then return end
	local name_size = render.measure_text(1, "", name) 
    local r, g, b = visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b
    if visual_table.solus_type:get() == 1 then
        render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 20, 0, 0)
        end
        render.rect(vector(x, y + 2), vector(x + w + 3, y + 19), color(0, 0, 0, alpha/4), 0)
    elseif visual_table.solus_type:get() == 2 then
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/4), 4)
        render.rect_outline(vector(x, y), vector(x + w + 3, y + 20), color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, alpha/2), 1, 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    end
    render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
end

function windowkey(x, y, w, h, name, alpha) 
    local me = entity.get_local_player()
    if not me then return end
	local name_size = render.measure_text(1, "", name) 
    local r, g, b = visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b
    if visual_table.soluskey_type:get() == 1 then
        render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 20, 0, 0)
        end
        render.rect(vector(x, y + 2), vector(x + w + 3, y + 19), color(0, 0, 0, alpha/4), 0)
    elseif visual_table.soluskey_type:get() == 2 then
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/4), 4)
        render.rect_outline(vector(x, y), vector(x + w + 3, y + 20), color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, alpha/2), 1, 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    end
    render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
end

function windowspec(x, y, w, h, name, alpha) 
    local me = entity.get_local_player()
    if not me then return end
	local name_size = render.measure_text(1, "", name) 
    local r, g, b = visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b
    if visual_table.solusspec_type:get() == 1 then
        render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 2), color(r, g, b, alpha), 20, 0, 0)
        end
        render.rect(vector(x, y + 2), vector(x + w + 3, y + 19), color(0, 0, 0, alpha/4), 0)
    elseif visual_table.solusspec_type:get() == 2 then
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/4), 4)
        render.rect_outline(vector(x, y), vector(x + w + 3, y + 20), color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, alpha/2), 1, 4)
        if visual_table.solus_glow:get() then
            render.shadow(vector(x, y), vector(x + w + 3, y + 20), color(r, g, b, alpha), 20, 0, 0)
        end
    end
    render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
end

local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec = render.screen_size().x, render.screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1

local pos_x = tabs.visuals:slider("posx", 0, x, 200)
local pos_y = tabs.visuals:slider("posy", 0, y, 200)
local pos_x1 = tabs.visuals:slider("posx1", 0, x, 300)
local pos_y1 = tabs.visuals:slider("posy1", 0, y, 300)

local pos_x2 = tabs.visuals:slider("posx2", 0, x, x-300)
local pos_y2 = tabs.visuals:slider("posy2", 0, y, 5)
pos_x:visibility(false)
pos_y:visibility(false)
pos_x1:visibility(false)
pos_y1:visibility(false)
pos_x2:visibility(false)
pos_y2:visibility(false)
local render_watermark = drag_system.register({pos_x2, pos_y2}, vector(250, 25), "Test3", function(self)
    if visual_table.solus:get() and visual_table.solus_select:get(1) then
        local actual_time = ""
        local latency_text = ""
        local nexttext = ""
        actual_time = common.get_date("%H:%M")
        if not globals.is_in_game then
            latency_text = ''
        else
            latency_text = ' | '..MTools.Client.GetPing().."ms"
        end
        solushex = color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, 255):to_hex()
        local nexttext = (' space.\a'..solushex..'codes \aFFFFFFFF| '..visual_table.custom_name:get()..latency_text.." | "..actual_time.." ")
        local text_size = render.measure_text(1, "", nexttext).x
        window(self.position.x - text_size+220, self.position.y+2, text_size + 4, 16, nexttext, 255)
        render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    end
end)
local new_drag_object = drag_system.register({pos_x, pos_y}, vector(120, 60), "Test", function(self)
    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local total_width = 66
    local active_binds = {}
    local binds = ui.get_binds()
    solushex = color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, 255):to_hex()
    for i = 1, #binds do
        local bind = binds[i]
        local get_mode = binds[i].mode == 1 and 'holding' or (binds[i].mode == 2 and 'toggled') or '[?]'
        local get_value = binds[i].value
        local c_name = binds[i].name
        local bind_state_size = render.measure_text(1, "", get_mode)
        local bind_name_size = render.measure_text(1, "", c_name)
        if data_k[bind.name] == nil then
            data_k[bind.name] = {alpha_k = 0}
        end
        data_k[bind.name].alpha_k = lerpx(frametime, data_k[bind.name].alpha_k, (bind.active and 255 or 0))
        render.text(1, vector(self.position.x+3, self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)
        if (c_name == "Fake Latency" or c_name == "Min. Damage" or c_name == "Hit Chance") then
            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x- render.measure_text(1, nil, get_value).x + 28), self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
        else
            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
        end
        add_y = add_y + 16 * data_k[bind.name].alpha_k/255
        local width_k = bind_state_size.x + bind_name_size.x + 18
        if width_k > 130-11 then
            if width_k > max_width then
                max_width = width_k
            end
        end
        if binds.active then
            table.insert(active_binds, binds)
        end
    end
    alpha_k = lerpx(frametime, alpha_k, (ui.get_alpha() > 0 or add_y > 0) and 1 or 0)
    width_ka = lerpx(frametime,width_ka, math.max(max_width, 130-11))
    if ui.get_alpha()>0 or add_y > 6 then
        alphabinds = lerpx(frametime, alphabinds, math.max(ui.get_alpha()*255, (add_y > 1 and 255 or 0)))
    elseif add_y < 15.99 and ui.get_alpha() == 0 then
        alphabinds = lerpx(frametime, alphabinds, 0)
    end
    if ui.get_alpha() or #active_binds > 0 then
        windowkey(self.position.x, self.position.y, width_ka, 16, "key\a"..solushex.."binds", alphabinds)
    end
end)

local new_drag_object1 = drag_system.register({pos_x1, pos_y1}, vector(120, 60), "Test2", function(self)
    local width_spec = 120
    if width_spec > 160-11 then
        if width_spec > max_width then
            max_width = width_spec
        end
    end
    solushex = color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, 255):to_hex()
    if ui.get_alpha() > 0.3 or (ui.get_alpha() > 0.3 and not globals.is_in_game) then
        windowspec(self.position.x, self.position.y, width_spec, 16,  'spec\a'..solushex..'tators', 255)
        render.text(1, vector(self.position.x + 5, self.position.y + 8 + (1*15)), color(), 'u', "Spectator")
    end
    local me = entity.get_local_player()
    if me == nil then return end
    local speclist = me:get_spectators()
    if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        me = me.m_hObserverTarget
    end

    local speclist = me:get_spectators()
    if speclist == nil then return end
    for idx,player_ptr in pairs(speclist) do
        local name = player_ptr:get_name()
        local tx = render.measure_text(1, '', name).x
        name_sub = string.len(name) > 20 and string.sub(name, 0, 20) .. "..." or name;
        if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
        render.text(1, vector(self.position.x + 5, self.position.y + 8 + (idx*15)), color(), 'u', name_sub)
        ::skip::
    end
    if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        windowspec(self.position.x, self.position.y, width_spec, 16,  'spec\a'..solushex..'tators', 255)
    end
end)


local logpos_x = tabs.visuals:slider("logposx", 0, x, x/2-150)
local logpos_y = tabs.visuals:slider("logposy", 0, y, y/2+250)
logpos_x:visibility(false)
logpos_y:visibility(false)
pos_x1:visibility(false)
pos_y1:visibility(false)

local logs = {}
local ragebot_logs = drag_system.register({logpos_x, logpos_y}, vector(320, 150), "Test2", function(self)
    local offset, x, y = 0, self.position.x+150, self.position.y
    render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    for idx, data in ipairs(logs) do
        if globals.curtime - data[3] < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 4)
        else
            data[2] = math.lerp(data[2], 0, 4)
        end
        if other_table.log_type:get() == 1 then
            offset = offset - 20 * (data[2] / 255)
        else
            offset = offset - 40 * (data[2] / 255)
        end

        if other_table.font_log:get() == "Default" then
            font = 1
        elseif other_table.font_log:get() == "Small" then
            font = 2
        elseif other_table.font_log:get() == "Console" then
            font = 3
        else
            font = 4
        end
        if other_table.font_log:get() == "Small" then
            text_size = render.measure_text(font, s, string.upper(data[1]))
        else
            text_size = render.measure_text(font, s, data[1])
        end

        if other_table.log_type:get() == 1 then
            render.shadow(vector(x+13 - text_size.x / 2, y - offset+text_size.y-5), vector(x + 3 + text_size.x / 2, y - offset+text_size.y-5), color(255, 255, 255, data[2]), 35, -1, 0)
        else
            render.rect(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+8), vector(x+13 + text_size.x / 2, y - offset+text_size.y+5), color(29, 29, 29, data[2]/3), 4)
            render.rect_outline(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+8), vector(x+13 + text_size.x / 2, y - offset+text_size.y+5), color(visual_table.solus_color:get().r, visual_table.solus_color:get().g, visual_table.solus_color:get().b, data[2]/2), 1, 4)
        end
        if other_table.font_log:get() == "Small" then
            render.text(font, vector(x + 9 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", string.upper(data[1]))
        else
            render.text(font, vector(x + 9 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", data[1])
        end
        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end
render.log("Stay With Us - Space.codes")


---again xueta
local helps = {
    distance_2d = function(position_a, position_b)
        return math.sqrt((position_b.x - position_a.x) ^ 2 + (position_b.y - position_a.y) ^ 2)
    end,

    lerp_position = function(position_al, position_bl, recharge)
        return vector((position_bl.x - position_al.x) * recharge + position_al.x, (position_bl.y - position_al.y) * recharge + position_al.y, (position_bl.z - position_al.z) * recharge + position_al.z)
    end
}

local smoke_duration = 17.55
local smoke_radius_units = 125

local function radius_nade()
    local lp = entity.get_local_player()
    if not lp then return end

    if visual_table.grenade_select:get(2) then
        local molotov_entity = entity.get_entities('CInferno')
        for i = 1, #molotov_entity do
            local new_molotov = molotov_entity[i]
            local molotov_origin = new_molotov:get_origin()
            local molotov_onwer = new_molotov.m_hOwnerEntity
            local onwer_team = molotov_onwer.m_iTeamNum
            local lp_team = lp.m_iTeamNum
            if onwer_team == lp_team then
                color_mol = visual_table.molotov_color:get()
            else
                color_mol = visual_table.molotov_color2:get()
            end
            local cell_radius = 40
            local cell = {}
            local maximum_distance = 0
            local max_a, max_b 

            local old_molotov = molotov_entity[i]
            for i = 1, 64 do
                if old_molotov.m_bFireIsBurning[i] == true then
                    table.insert(cell, vector(new_molotov.m_fireXDelta[i], new_molotov.m_fireYDelta[i], new_molotov.m_fireZDelta[i]))
                end
            end

            for v = 1, #cell do
                for k = 1, #cell do
                    local distance = helps.distance_2d(cell[v], cell[k])
                    if distance > maximum_distance then
                        maximum_distance = distance
                        max_a = cell[v]
                        max_b = cell[k]
                    end
                end
            end

            if max_a ~= nil and max_b ~= nil then
                local center_delta = helps.lerp_position(max_a, max_b, 0.5)
                local center = molotov_origin + center_delta
                render.circle_3d_outline(center, color(color_mol.r, color_mol.g, color_mol.b, 255), maximum_distance / 2 + cell_radius, 0,1,1)  
            end
        end
    end

    if visual_table.grenade_select:get(1) then
        local tickcount = globals.tickcount
        local tickinterval = globals.tickinterval
        local Smokes = entity.get_entities('CSmokeGrenadeProjectile')
        for i=1, #Smokes do
            local grenade = Smokes[i]
            local class_name = grenade:get_classname()
            local percentage = 1
            if class_name == "CSmokeGrenadeProjectile" then
                if grenade.m_bDidSmokeEffect == true then
                    local ticks_created =grenade.m_nSmokeEffectTickBegin
                    if ticks_created ~= nil then
                        local time_since_explosion = tickinterval * (tickcount - ticks_created)
                        if time_since_explosion > 0 and smoke_duration-time_since_explosion > 0 then
                            if grenade_timer then
                                percentage = 1 - time_since_explosion / smoke_duration
                            end
                            local r, g, b, a = visual_table.smoke_color:get().r, visual_table.smoke_color:get().g, visual_table.smoke_color:get().b, visual_table.smoke_color:get().a
                            local radius = smoke_radius_units
                            if 0.3 > time_since_explosion then
                                radius = radius * 0.6 + (radius * (time_since_explosion / 0.3))*0.4
                                a = a * (time_since_explosion / 0.3)
                            end
                            if 1.0 > smoke_duration-time_since_explosion then
                                radius = radius * (((smoke_duration-time_since_explosion) / 1.0)*0.3 + 0.7)
                            end
                            render.circle_3d_outline(grenade:get_origin(),color(r, g, b, a*math.min(1, percentage*1.3)), radius, 0,1)
                        end
                    end
                end	
            end
        end
    end
end
---end

local function fastladder(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if lp["m_MoveType"] == 9 then
        cmd.view_angles.y = math.floor(cmd.view_angles.y + 0.5)
        if cmd.forwardmove > 0 then
            if cmd.view_angles.x < 45 then
                cmd.view_angles.x = 89
                cmd.in_forward = 0
                cmd.in_back = 1
                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                if cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
                if cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                end
                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                end
            end
        elseif cmd.forwardmove < 0 then
            cmd.view_angles.x = 89
            cmd.in_forward = 1
            cmd.in_back = 0
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            if cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 30
            end
            if cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 150
            end
            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            end
        end
    end
end

local function fastfall()
    local lp = entity.get_local_player()
    if lp == nil then return end
    local utils_trace = utils.trace_line(lp.m_vecOrigin, vector(lp.m_vecOrigin.x, lp.m_vecOrigin.y, lp.m_vecOrigin.z - 75), nil, nil, 1)
    if(lp.m_vecVelocity.z < -100) then
        if(lp.m_vecOrigin.z - utils_trace.end_pos.z <= 55) then
            rage.exploit:force_teleport()
        end
    end
end


local function no_fall_damage(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    local origin = lp:get_origin()
    if lp.m_vecVelocity.z <= -500 then
        if utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 15)).fraction ~= 1 then
            cmd.in_duck = 0
        elseif utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 50)).fraction ~= 1 then
            cmd.in_duck = 1
        end
    end    
end


local bind_cache = false
local tables_nade = {"weapon_hegrenade", "weapon_molotov"}
local function fast_drop()
    local local_player = entity.get_local_player()
    if (local_player == nil or not local_player:is_alive()) then return end
    local teamnum = local_player.m_iTeamNum
    if teamnum == 3 then
        tables_nade = {"weapon_hegrenade", "weapon_incgrenade"}
    else
        tables_nade = {"weapon_hegrenade", "weapon_molotov"}
    end
    if other_table.drop_nades:get() and not bind_cache then
        for curr_nade, nade in pairs(tables_nade) do
            utils.execute_after(0.1 * curr_nade, function()
                utils.console_exec(string.format("use %s", nade))
                utils.execute_after(0.05 * curr_nade, function() utils.console_exec("drop") end)
            end)
        end
    end
    bind_cache = other_table.drop_nades:get()
end


local function fix_nade()
    local lp = entity.get_local_player()
    if not (lp or lp:is_alive()) then return end
    ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):override()
    rage.exploit:allow_defensive(true)
    rage.exploit:allow_charge(true)
    local selected = lp:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    if string.match(wpn, "Grenade") then
        if other_table.quick_switch:get() then
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):override("Auto Pistols")
        end
        if other_table.nade_fix:get() then
            if other_table.nade_fix_select:get() == "Default" then
                rage.exploit:allow_defensive(false)
            else
                rage.exploit:force_teleport()
                rage.exploit:allow_charge(false)
            end
        end
    end
end

local function auto_teleport()
    local tp_check = false
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not local_player:is_alive() then return end
    local jump = bit.band(local_player.m_fFlags, 1) == 0 and math.sqrt(local_player.m_vecVelocity.x ^ 2 + local_player.m_vecVelocity.y ^ 2) > 150
    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    if other_table.teleport_wpn:get("AWP") and string.match(weapon, "AWP") then tp_check = true end
    if other_table.teleport_wpn:get("Bomb C4") and string.match(weapon, "CC4") then tp_check = true end
    if other_table.teleport_wpn:get("Scout") and string.match(weapon, "SSG08") then tp_check = true end
    if other_table.teleport_wpn:get("Knife") and string.match(weapon, "Knife") then tp_check = true end
    if other_table.teleport_wpn:get("Taser") and string.match(weapon, "Taser") then tp_check = true end
    if other_table.teleport_wpn:get("Shotgun") and (string.match(weapon, "Mag7") or string.match(weapon, "Sawedoff") or string.match(weapon, "NOVA") or string.match(weapon, "XM1014")) then tp_check = true end
    if other_table.teleport_wpn:get("Pistols") and (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "DEagle") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000")) then tp_check = true end
    if other_table.teleport:get() and jump then
        if (tp_check == true and entity.get_threat(true) ~= nil) then
            rage.exploit:force_teleport()
            tp_check = false
            utils.execute_after(other_table.teleport_delay:get()/10, function()
                rage.exploit:force_charge()
                rage.exploit:force_teleport()
            end)
        end
    end
end

local function players_mute()
    local sets_mute = other_table.mute_set:get()
    entity.get_players(false, true, function(player)
        local get_player_info = player:get_player_info()
        local check_mute = panorama.FriendsListAPI.IsSelectedPlayerMuted(get_player_info.steamid64)
        if sets_mute == "Unmute" and check_mute then panorama.FriendsListAPI.ToggleMute(get_player_info.steamid64)
        elseif sets_mute == "Mute" and not check_mute then panorama.FriendsListAPI.ToggleMute(get_player_info.steamid64) end
    end)
end

local function snapline_func()
    local player = entity.get_local_player()
    if player == nil then return end
	if not player:is_alive() then return end
	local players = entity.get_players(true, true)
	if (players == nil and #players < 1) then return end
	local player_origin = player:get_origin() 
	local player_origin_screen = render.world_to_screen(player_origin)
	if (player_origin_screen == nil) then
		return
	end
	for key, enemy in pairs(players) do
		if (not enemy:is_alive() or enemy:is_dormant()) then
			goto skip
		end
		local origin = enemy:get_origin() 
		if (origin == nil) then
			goto skip
		end
		local origin_screen = render.world_to_screen(origin)
		if (origin_screen == nil) then
			goto skip
		end
        if snap_r8_help == true and visual_table.snaplines_helper:get() then
		    render.line(player_origin_screen, origin_screen, color(255, 0, 0, 255))
        else
            render.line(player_origin_screen, origin_screen, visual_table.snaplines_color:get())
        end
		::skip::
	end
end

local material_console = {"vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4"}


func_argum = function(func, argum)
    return function(...)
        return func(argum, ...)
    end
end
dll_engine = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"))
viibility_console = func_argum(ffi.cast("bool(__thiscall*)(void*)", dll_engine[0][11]), dll_engine)

check_color = 0
local function custom_color(color_cons)
    if check_color ~= color_cons then
        for _, cs in pairs(material_console) do
            materials.get_materials(cs)[1]:color_modulate(color(color_cons.r, color_cons.g, color_cons.b))
            materials.get_materials(cs)[1]:alpha_modulate(color_cons.a/255)
        end
        check_color = color_cons
    end
end

local function check_console()
    local color_cons = (viibility_console() and visual_table.console_color:get()) and visual_table.clr_console:get() or color(255)
    custom_color(color_cons)
end


local function safe_xueta()
    local local_player = entity.get_local_player()
    if (local_player == nil or not local_player:is_alive()) then return end
    low_health = other_table.baim_scout:get()
    local jump = bit.band(local_player.m_fFlags, 1) == 0
    local ground = bit.band(local_player.m_fFlags, 1) == 1
    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    local scoped = local_player.m_bIsScoped
    awp_check = false
    if string.match(weapon, "AWP") then awp_check = true end
    r8_check = false
    if string.match(weapon, "DEagle") then r8_check = true end
    pistols_check = false
    if (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000")) then pistols_check = true end
    scout_check = false
    if string.match(weapon, "SSG08") then scout_check = true end
    auto_check = false
    if string.match(weapon, "SCAR20") or string.match(weapon, "G3SG1") then auto_check = true end
    ---baim
    if (entity.get_threat() ~= nil and other_table.baim_switch:get()) then
        if other_table.baim_select:get("Scout") and scout_check == true then
            if entity.get_threat().m_iHealth <= other_table.baim_scout:get() then
                reference.baim:override("Force")
            else
                reference.baim:override()
            end
        elseif other_table.baim_select:get("Awp") and awp_check == true then
            if entity.get_threat().m_iHealth <= other_table.baim_awp:get() then
                reference.baim:override("Force")
            else
                reference.baim:override()
            end
        elseif other_table.baim_select:get("R8") and r8_check == true then
            if entity.get_threat().m_iHealth <= other_table.baim_r8:get() then
                reference.baim:override("Force")
            else
                reference.baim:override()
            end
        else
            reference.baim:override()
        end
    else
        reference.baim:override()
    end
    ---safe
    if (entity.get_threat() ~= nil and other_table.safe_switch:get()) then
        if other_table.safe_select:get("Scout") and scout_check == true then
            if entity.get_threat().m_iHealth <= other_table.safe_scout:get() then
                reference.safe:override("Force")
            else
                reference.safe:override()
            end
        elseif other_table.safe_select:get("Awp") and awp_check == true then
            if entity.get_threat().m_iHealth <= other_table.safe_awp:get() then
                reference.safe:override("Force")
            else
                reference.safe:override()
            end
        elseif other_table.safe_select:get("R8") and r8_check == true then
            if entity.get_threat().m_iHealth <= other_table.safe_r8:get() then
                reference.safe:override("Force")
            else
                reference.safe:override()
            end
        else
            reference.safe:override()
        end
    else
        reference.safe:override()
    end
    ---air hc
    reference.hc:override()
    if (jump and other_table.air_switch:get() and other_table.hs_select:get("In Air")) then
        if other_table.air_select:get("Scout") and scout_check == true then
            reference.hc:override(other_table.air_scout:get())
        end
        if other_table.air_select:get("R8") and r8_check == true then
            reference.hc:override(other_table.air_awp:get())
        end
        if other_table.air_select:get("Pistols") and pistols_check == true then
            reference.hc:override(other_table.air_pistols:get())
        end
    end 
    --noscope
    if (other_table.air_switch:get() and not scoped and ground and other_table.hs_select:get("No Scope")) then
        if other_table.scope_select:get("Scout") and scout_check == true then
            reference.hc:override(other_table.scope_scout:get())
        end
        if other_table.scope_select:get("Auto") and auto_check == true then
            reference.hc:override(other_table.scope_auto:get())
        end
        if other_table.scope_select:get("Awp") and awp_check == true then
            reference.hc:override(other_table.scope_awp:get())
        end
    end
end


local function strafe_fix()
    local lp = entity.get_local_player()
    if not (lp or lp:is_alive()) then return end
    local move = math.sqrt(lp.m_vecVelocity.x^2 + lp.m_vecVelocity.y^2) < 10
    local selected = lp:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    local selected = lp:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    if other_table.jumpscout:get() then
        if move then
            reference.strafe:set(false)
        else
            reference.strafe:set(true)
        end
    else
        reference.strafe:set(true)
    end
    if string.match(wpn, "Grenade") then
        reference.strafe:set(true)
    end 
end

function sin_vec(x, y)
    sin_x = math.sin(math.rad(x))
    cos_x = math.cos(math.rad(x))
    sin_y = math.sin(math.rad(y))
    cos_y = math.cos(math.rad(y))
    return vector(cos_x * cos_y, cos_x * sin_y, -sin_x);
end
local function avoid_colision(cmd)
    local lp = entity.get_local_player()
    local minimum, value = math.huge, math.huge
    for z = 1, 180 do
        local line_trace = utils.trace_line(lp.m_vecOrigin, vector(lp.m_vecOrigin.x + sin_vec(0, (render.camera_angles().y + z - 90)).x * 70, lp.m_vecOrigin.y + sin_vec(0, (render.camera_angles().y + z - 90)).y * 70, lp.m_vecOrigin.z + 60), nil, nil, 1)
        if(lp.m_vecOrigin:dist(line_trace.end_pos) < minimum) then
            minimum = lp.m_vecOrigin:dist(line_trace.end_pos)
            value = z
        end
    end
    if minimum < 40 and cmd.in_jump and not (cmd.in_back or cmd.in_moveleft or cmd.in_moveright) then
        if(value >= 90) then
            cmd.sidemove = lp.m_vecVelocity:length() * math.sin(math.rad(value))
        else
            cmd.sidemove = (lp.m_vecVelocity:length() * math.sin(math.rad(value))) * -1
        end
        cmd.forwardmove = math.abs(lp.m_vecVelocity:length() * math.cos(math.rad(value)))
    end
end

local function auto_mp()
    if other_table.auto_mp:get() then
        ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"):override(math.random(20, 100))
        ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"):override(math.random(20, 100))
    else
        ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"):override()
        ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"):override()
    end 
end

local function fps_boost()
    if other_table.fps_boost:get() then
        cvar.r_shadows:int(0)
        cvar.cl_csm_static_prop_shadows:int(0)
        cvar.cl_csm_shadows:int(0)
        cvar.cl_csm_world_shadows:int(0)
        cvar.cl_foot_contact_shadows:int(0)
        cvar.cl_csm_viewmodel_shadows:int(0)
        cvar.cl_csm_rope_shadows:int(0)
        cvar.cl_csm_sprite_shadows:int(0)
        cvar.r_dynamic:int(0)
        cvar.cl_autohelp:int(0)
        cvar.r_eyesize:int(0)
        cvar.r_eyeshift_z:int(0)
        cvar.r_eyeshift_y:int(0)
        cvar.r_eyeshift_x:int(0)
        cvar.r_eyemove:int(0)
        cvar.r_eyegloss:int(0)
        cvar.r_drawtracers_firstperson:int(0)
        cvar.r_drawtracers:int(0)
        cvar.fog_enable_water_fog:int(0)
        cvar.mat_postprocess_enable:int(0)
        cvar.cl_disablefreezecam:int(0)
        cvar.cl_freezecampanel_position_dynamic:int(0)
        cvar.r_drawdecals:int(0)
        cvar.muzzleflash_light:int(0)
        cvar.r_drawropes:int(0)
        cvar.r_drawsprites:int(0)
        cvar.cl_disablehtmlmotd:int(0)
        cvar.cl_freezecameffects_showholiday:int(0)
        cvar.cl_bob_lower_amt:int(0)
        cvar.cl_detail_multiplier:int(0)
        cvar.mat_drawwater:int(0) 
    else
        cvar.r_shadows:int(1)
        cvar.cl_csm_static_prop_shadows:int(1)
        cvar.cl_csm_shadows:int(1)
        cvar.cl_csm_world_shadows:int(1)
        cvar.cl_foot_contact_shadows:int(1)
        cvar.cl_csm_viewmodel_shadows:int(1)
        cvar.cl_csm_rope_shadows:int(1)
        cvar.cl_csm_sprite_shadows:int(1)
        cvar.r_dynamic:int(1)
        cvar.cl_autohelp:int(1)
        cvar.r_eyesize:int(1)
        cvar.r_eyeshift_z:int(1)
        cvar.r_eyeshift_y:int(1)
        cvar.r_eyeshift_x:int(1)
        cvar.r_eyemove:int(1)
        cvar.r_eyegloss:int(1)
        cvar.r_drawtracers_firstperson:int(1)
        cvar.r_drawtracers:int(1)
        cvar.fog_enable_water_fog:int(1)
        cvar.mat_postprocess_enable:int(1)
        cvar.cl_disablefreezecam:int(1)
        cvar.cl_freezecampanel_position_dynamic:int(1)
        cvar.r_drawdecals:int(1)
        cvar.muzzleflash_light:int(1)
        cvar.r_drawropes:int(1)
        cvar.r_drawsprites:int(1)
        cvar.cl_disablehtmlmotd:int(1)
        cvar.cl_freezecameffects_showholiday:int(1)
        cvar.cl_bob_lower_amt:int(1)
        cvar.cl_detail_multiplier:int(1)
        cvar.mat_drawwater:int(1)
    end
end

local function defensive_addon(cmd)
    if globals.tickcount % 3 == 0 then
        cmd.send_packet = false
    elseif globals.tickcount % 3 == 1 then
        cmd.send_packet = true
    elseif globals.tickcount % 3 == 2 then
        cmd.send_packet = false
    end
end

local function ideal_tick(cmd)
    ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):override(true)
    if not ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() then return end
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"):override(false)
    if globals.tickcount % 3 == 0 then
        cmd.send_packet = false
    elseif globals.tickcount % 3 == 1 then
        cmd.send_packet = true
        cmd.force_defensive = true
    elseif globals.tickcount % 3 == 2 then
        cmd.send_packet = false
    end
end

local taskbar = {}
taskbar.hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")
taskbar.hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", taskbar.hwnd) + 2)[0])[0] + 2)
taskbar.overlay = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1")
taskbar.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", taskbar.overlay)
taskbar.Window = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")
taskbar.GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", taskbar.Window) + 2)[0])[0]
taskbar.FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")
taskbar.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", taskbar.FlashWindow)
notify_round = function()
    if taskbar.insn_jmp_ecx(taskbar.GetForegroundWindow) ~= taskbar.hwnd_ptr[0] then
        taskbar.flash_window(taskbar.hwnd_ptr[0], 1)
    end
end

local next_call, pos = 0, 0
local tag = {
    "s ",
    "sp ",
    "spa ",
    "spac ",
    "space ",
    "space. ",
    "space.c ",
    "space.co ",
    "space.cod ",
    "space.code ",
    "space.codes ",
    "space.codes ",
    "space.codes ",
    "space.codes ",
    "space.codes ",
    "space.code ",
    "space.cod ",
    "space.co ",
    "space.c ",
    "space. ",
    "space ",
    "spac ",
    "spa ",
    "sp ",
    "s ",
}

other_table.clantag:set_callback(function() if not other_table.clantag:get() then common.set_clan_tag("") end end)

events.render:set(function()
    if other_table.clantag:get() then
        if next_call < globals.tickcount then
            pos = pos + 1
            if pos > #tag then
                pos = 1
            end
            common.set_clan_tag(tag[pos])
            next_call = globals.tickcount + 20
        end
    end
end)

local phase_first = {
    "не переживай брат, всё с space.codes получится",
    "ну пидарас упал что случилось головка бобо?",
    "1 лёгкий 0 импакта от тебя лакерный",
    "да, жалуйся на свою паганую луа и кфг покупай ещё и ещё,",
    "какой же ты сладкий сочник, без space.codes упал",
    "да всё ебало завали своё, жирное создание кому твоё нытьё нужно",
    "фу блять позорник проёбывает мапу когда я спиной стою",
    "блять, куда я хаеснул бича, я его не вижу даже",
    "фу блять лакер ссанный, опять уменя по серверу летит",
    "Space.codes technology activated, 1 dog",
    "у тебя проблемы с конфигом школьник или с луа? почему ты такой изичный",
    "легкий ублюдок",
    "ну у меня пинг большой",
    "всё же это легко когда утебя есть space.codes",
    "так сын шлюшки 1 упал как бич",
    "gg wp ez mid",
    "ну что бичара снова поновой опять сдох",
    "1 легчайше",
    "owned by space.codes оправдания в хуяку",
    "хаеснут бичара (>^.^)>",
    "как там погодка снизу <^O^>",
    "какой же ты жирный",
    "иди уже в роблокс играй",
    "бездарность тупая научись уже играт",
    "изич для space.codes",
    "не ной уже хватит",
    "что ты сделал?",
    "ты такой смешной прям блять со стула упаду щас",
    "ублюдок оправдания сюда на базу почему муваешься как жиробас",
  }
  local phase_second = {
    "а пока что 1 нищий заебал играть как первоклашка.",
    "совет дам, на твоём отсталом языке,шоб головка не бобо купи Space.codes перестанет болеть)",
    "как таких только земля держит",
    "правда разници нету,ты как и был отсталым так и остался им",
    "думал умнее будешь",
    "да в хуй оправдания будут 1x1,2x2,3x3,5x5 ты же мне всё пролузаешь без space.codes 9-0",
    "ты безнадёжен",
    "просто пиздец изичный для моего кфг и луа",
    "найс миснул в бест луа 1",
    "so ez for Space.codes",
    "купи space.codes и не потей как бич, не выходя при этом в кд 1",
    "фух ели как это лакера забрал",
    "не сыровно луашка запенила",
    "ебало завали фанат луашки завидуй блять",
    "всё же ты не поймёшь что ты еблан и нечего не добьёшся",
    "16-0 owned",
    "мне тебя жалко",
    "для величайшего",
    "ну сразу замолчал ублюдок скареный",
    "иди сюда,обниму а то уже весь заревелся ᕙ(⇀‸↼‶)ᕗ",
    "это намёк что ты упал))))UwU",
    "уже по кнопкам не поподаешь",
    "твоя игра по жизни",
    "лёгкий",
    "1 легко",
    "а то сидишь уже в муте у каждого",
    "ez 1",
    "это сарказм",
    "по твоему голосу уже понятно всё ебало заволи",
  }

events.player_death:set(function(e)
    if not other_table.trashtalk:get() then return end
    local lp = entity.get_local_player()
    if (lp == nil or not lp:is_alive()) then return end
    local atcr = entity.get(e.attacker, true)
    local dd = entity.get(e.userid, true)
    if (lp == atcr and dd ~= lp) then
        utils.execute_after(2, utils.console_exec,"say "..phase_first[math.random(1, #phase_first)])
        utils.execute_after(4, utils.console_exec,"say "..phase_second[math.random(1, #phase_second)])     
    end
end)
--..text[rnd]
aspect_value = 0
local function aspect_ratio()
    if other_table.fast_dt:get() then
        cvar.sv_maxusrcmdprocessticks:float(other_table.fast_dt_select:get())
    else
        cvar.sv_maxusrcmdprocessticks:float(14)
    end
    aspect_value = math.lerp(aspect_value, other_table.aspect_ratio_slider:get()/10, 10)
    if other_table.aspect_ratio:get() then
        cvar.r_aspectratio:float(aspect_value)
    else
        cvar.r_aspectratio:float(0)
    end
    if other_table.viewmodel:get() then
        cvar.viewmodel_fov:int(other_table.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(other_table.viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(other_table.viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(other_table.viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end

events.render:set(function()
    if visual_table.additional_water:get() and visual_table.solus:get() then
        xueten()
    end
    if visual_table.grenade_radius:get() then
        radius_nade()
    end
    safe_xueta()
    fast_drop()
    if visual_table.sense_ind:get() then
        sense_ind_func()
    end
    if visual_table.scope:get() then
        reference.removesc:override("Remove all")
    else
        reference.removesc:override()
    end
    if visual_table.solus:get() then
        if visual_table.solus_select:get(1) then
            render_watermark:update()
        end
        if visual_table.solus_select:get(2) then
            new_drag_object:update()
        end
        if visual_table.solus_select:get(3) then
            new_drag_object1:update()
        end
    end
    if other_table.logs:get() and other_table.printconsole:get("Screen") then
        ragebot_logs:update()
    end
    if ui.get_alpha() > 0 then
        sidebar()
    end
    if visual_table.crosshair:get() then
        crosshair_indicator()
    end
    if visual_table.mindmg:get() then
        mindmg_drag:update()
    end
    if visual_table.slowed_down:get() then
        velocity_ind:update()
    end
    if visual_table.arrows:get() then
        ts_arrows()
    end
    if visual_table.scope:get() then
        customscope()
    end
    if visual_table.snaplines:get() then
        snapline_func()
    end
    check_console()
end)

events.createmove:set(function(cmd)
    aa_setup(cmd)
    if other_table.fast_ladder:get() then
        fastladder(cmd)
    end
    if other_table.fast_fall:get() then
        fastfall()
    end
    fix_nade()
    if other_table.no_fall_damage:get() then
        no_fall_damage(cmd)
    end
    if other_table.teleport:get() then
        auto_teleport()
    end
    strafe_fix()
    aspect_ratio()
    if other_table.mute_unmute:get() then
        players_mute()
    end
    if other_table.avoid_collision:get() then
        avoid_colision(cmd)
    end
    auto_mp()
    fps_boost()
    if other_table.defe_addons:get() then
        defensive_addon(cmd)
    end
    ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):override()
    if other_table.ideal_tick:get() then
        ideal_tick(cmd)
    end
    ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Override Resolver"):override(other_table.resolver:get())
end)

other_table.shared_icon:set_callback(function(self)
    local lp = entity.get_local_player()
    if lp == nil then return end
    if self:get() then
        lp:set_icon("https://media.discordapp.net/attachments/1112432776122216569/1124763775317315735/GALAXY.png?width=140&height=140")
    else
        lp:set_icon()
    end
    entity.get_players(false, true, function(xd)
        if not self:get() then
            xd:set_icon()
        end
    end)
end)

events.voice_message(function(ctx)
    local buffer = ctx.buffer
    local code = buffer:read_bits(16)
    if code == 0x1561 then
        if other_table.shared_icon:get() then
            ctx.entity:set_icon("https://media.discordapp.net/attachments/1112432776122216569/1124763775837413377/LIVE.png?width=140&height=140")
        else
            ctx.entity:set_icon()
        end
    end
    if code == 0x1678 then
        if other_table.shared_icon:get() then
            ctx.entity:set_icon("https://media.discordapp.net/attachments/1112432776122216569/1124763774952415323/ALPHA.png?width=140&height=140")
        else
            ctx.entity:set_icon()
        end
    end
    if code == 0x1741 then
        if other_table.shared_icon:get() then
            ctx.entity:set_icon("https://media.discordapp.net/attachments/1112432776122216569/1124763775317315735/GALAXY.png?width=140&height=140")
        else
            ctx.entity:set_icon()
        end
    end
end)

events.voice_message:call(function(buffer)
    buffer:write_bits(0x1741, 16)
end)

events.round_start:set(function()
    if other_table.taskbar:get() then
        notify_round()
    end
    if other_table.check_print:get(3) and other_table.printconsole:get("Screen") then
        render.log("Anti~Bruteforce Angle Switched Due To New Round Start")
    end
    events.voice_message:call(function(buffer)
        buffer:write_bits(0x1741, 16)
    end)
end)

events.mouse_input:set(function()
    return not (ui.get_alpha() > 0)
end) 

events.shutdown:set(function()
    common.set_clan_tag('')
    cvar.r_aspectratio:float(0)
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
    ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"):override()
    ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"):override()
    custom_color(color(255))
    entity.get_players(false, true, function(ptr)
        ptr:set_icon()
    end)
end)

local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

events.aim_ack:set(function(e)
    local me = entity.get_local_player()
    local target = entity.get(e.target)
    local damage = e.damage
    local wanted_damage = e.wanted_damage
    local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
    local hitchance = e.hitchance
    local state = e.state
    local bt = e.backtrack
    if not target then return end
    if target == nil then return end
    local health = target["m_iHealth"]
    local hitgroup = hitgroup_str[e.hitgroup]
    if not globals.is_connected and not globals.is_in_game then return false end
    miss_check = miss_check + 1
    if state == nil then
        hit_check = hit_check + 1
        if not other_table.logs:get() then return end
        if other_table.check_print:get(1) and other_table.printconsole:get("Screen") then
            render.log(("Hit \a8FB9FFFF%s's \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if (other_table.printconsole:get("Console") and other_table.check_print:get(1)) then
            print_raw(("» space.codes \a52B140[+] Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
    end
    if state ~= nil then
        if not other_table.logs:get() then return end
        if (other_table.check_print:get(2) and other_table.printconsole:get("Screen")) then
            render.log(('Missed \a8FB9FFFF%s \aFFFFFFFFin the %s due to \aFF3939FF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (bt: '..string.format("%.f", bt)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
        if (other_table.printconsole:get("Console") and other_table.check_print:get(2)) then
            print_raw(('» space.codes \aFF3939[-] Missed %s in the %s due to '..state..' (hc: '..string.format("%.f", hitchance)..') (bt: '..string.format("%.f", bt)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
    end
end)

events.player_hurt:set(function(e)
    if not other_table.logs:get() then return end
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    local weapon = e.weapon
    local type_hit = 'Hit'

    if weapon == 'hegrenade' then 
        type_hit = 'Naded'
    end

    if weapon == 'inferno' then
        type_hit = 'Burned'
    end

    if weapon == 'knife' then 
        type_hit = 'Knifed'
    end

    if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
        if me == attacker then
            local user = entity.get(e.userid, true)
            if (other_table.printconsole:get("Console") and other_table.check_print:get(1)) then
                print_raw(('\a4562FF[space.codes] \aD5D5D5'..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if (other_table.check_print:get(1) and other_table.printconsole:get("Screen")) then
                render.log((type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
        end
    end
end)


---@Config System
local config_cfg = pui.setup({aa_table, other_table, visual_table, antiaim_cicle}, true)
local cfg_system = { }
configs_db = db.cfg_spacenightly or { }
configs_db.cfg_list = configs_db.cfg_list or {{'Default', 'W3siYWlyYnJlYWtlciI6IlN0YXRpYyBMZWdzIiwiYW5pbWJyZWFrZXIiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWUsImJyZWFrX2xjIjp0cnVlLCJjb25kaXRpb24iOiJcdTAwMDc3NEE2QTlGRkZha2V+TGFnIiwiZW5hYmxlX2FhIjp0cnVlLCJmcmVlc190eXBlIjoxLjAsImZyZWVzdGFuZGluZyI6ZmFsc2UsImdyb3VuZGJyZWFrZXIiOiJKaXR0ZXIiLCJodXlueWFfbmVfbnV6aG5heWEiOlsifiJdLCJsZWFuX3ZhbHVlIjoxLjAsIm90aGVyYnJlYWtlciI6WyJQaXRjaCAwIE9uIExhbmQiLCJ+Il0sInBpdGNoIjoiRG93biIsInNhZmVfaGVhZCI6WyJLbmlmZSIsIn4iXSwic2hpdF9hYSI6IlJhbmRvbSIsInN0YXRpY19mcmVlcyI6WyJPbiBNYW51YWwiLCJ+Il0sInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X2Jhc2VfZGlzYWJsZXIiOlsiSGlkZGVuIiwifiJdfSx7ImFpcl9hd3AiOjIwLjAsImFpcl9waXN0b2xzIjo4OS4wLCJhaXJfc2NvdXQiOjQwLjAsImFpcl9zZWxlY3QiOlsiU2NvdXQiLCJSOCIsIn4iXSwiYWlyX3N3aXRjaCI6dHJ1ZSwiYXNwZWN0X3JhdGlvIjp0cnVlLCJhc3BlY3RfcmF0aW9fc2xpZGVyIjoxMTAuMCwiYmFpbV9hd3AiOjg5LjAsImJhaW1fcjgiOjg5LjAsImJhaW1fc2NvdXQiOjkyLjAsImJhaW1fc2VsZWN0IjpbIlNjb3V0IiwifiJdLCJiYWltX3N3aXRjaCI6dHJ1ZSwiY2hlY2tfcHJpbnQiOlsxLjAsMi4wLDMuMCwifiJdLCJjbGFudGFnIjp0cnVlLCJkcm9wX25hZGVzIjowLjAsImZhc3RfZHQiOnRydWUsImZhc3RfZHRfc2VsZWN0IjoiRmFzdGVyIiwiZmFzdF9sYWRkZXIiOnRydWUsImp1bXBzY291dCI6dHJ1ZSwibG9ncyI6dHJ1ZSwibmFkZV9maXgiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlLCJwcmludGNvbnNvbGUiOnRydWUsInNhZmVfYXdwIjo4OS4wLCJzYWZlX3I4Ijo4OS4wLCJzYWZlX3Njb3V0Ijo4OS4wLCJzYWZlX3NlbGVjdCI6WyJ+Il0sInNhZmVfc3dpdGNoIjpmYWxzZSwic2NvcGVfYXV0byI6ODkuMCwic2NvcGVfYXdwIjo4OS4wLCJzY29wZV9zY291dCI6ODkuMCwic2NvcGVfc2VsZWN0IjpbIn4iXSwic2NvcGVfc3dpdGNoIjpmYWxzZSwidGFza2JhciI6dHJ1ZSwidGVsZXBvcnQiOmZhbHNlLCJ0ZWxlcG9ydF93cG4iOlsiS25pZmUiLCJTY291dCIsIkFXUCIsIn4iXSwidHJhc2h0YWxrIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsInZpZXdtb2RlbF9mb3YiOjUwLjAsInZpZXdtb2RlbF94IjoxLjAsInZpZXdtb2RlbF95IjowLjAsInZpZXdtb2RlbF96IjotMS4wfSx7IlNjb3BlaW52ZXJ0ZWQiOnRydWUsIlNjb3BlbGVuZ3RoIjo0NS4wLCJTY29wZW9mZnNldCI6MS4wLCJhcnJvd3MiOnRydWUsImFycm93c19jb2xvciI6IiMzNThERkZGRiIsImNyb3NzaGFpciI6dHJ1ZSwiY3Jvc3NoYWlyX2NvbG9yMSI6IiMwMEE3RkZGRiIsImNyb3NzaGFpcl9jb2xvcjIiOiIjMzVDMEZGRkYiLCJjcm9zc2hhaXJfc3R5bGUiOjIuMCwiZ3JlbmFkZV9yYWRpdXMiOnRydWUsImdyZW5hZGVfc2VsZWN0IjpbMS4wLDIuMCwifiJdLCJtaW5kbWciOnRydWUsIm1vbG90b3ZfY29sb3IiOiIjRkZBQTFFQkUiLCJzY29wZSI6dHJ1ZSwic2NvcGVfY29sb3IiOiIjRkZGRkZGRkYiLCJzZW5zZV9pbmQiOnRydWUsInNlbnNlX3NlbGVjdCI6WzEuMCwyLjAsMy4wLDQuMCw1LjAsNi4wLDcuMCw4LjAsOS4wLDEwLjAsMTEuMCwifiJdLCJzbG93ZWRfZG93biI6dHJ1ZSwic2xvd2VkX2Rvd25fY29sb3IiOiIjMkYyRjJGRkYiLCJzbG93ZWRfZG93bl9jb2xvcjIiOiIjOUE2NUZGNDIiLCJzbG93ZWRfZG93bl9jb2xvcjMiOiIjRkZGRkZGRkYiLCJzbW9rZV9jb2xvciI6IiNEMUQxRDFCNCIsInNvbHVzIjp0cnVlLCJzb2x1c19jb2xvciI6IiMzNUMwRkZGRiIsInNvbHVzX2dsb3ciOnRydWUsInNvbHVzX3NlbGVjdCI6WzEuMCwyLjAsMy4wLCJ+Il0sInNvbHVzX3R5cGUiOjEuMCwic29sdXNrZXlfdHlwZSI6MS4wLCJzb2x1c3NwZWNfdHlwZSI6MS4wfSxbeyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6ZmFsc2UsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6dHJ1ZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiYWJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlIjoiQ3VzdG9tIiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzMuMCwiYWJfeWF3X3IiOjQwLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjM3LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6dHJ1ZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfZnJlZXN0YW5kIjoiT2ZmIiwiYWJfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWJfbGJ5X2wiOjYwLjAsImFiX2xieV9yIjo2MC4wLCJhYl9vcHRpb25zIjpbIn4iXSwiYWJfeWF3X2wiOi0zMy4wLCJhYl95YXdfciI6MzguMCwiYWJfeWF3X3NlbnMiOjUwLjAsImFiX3lhd190eXBlIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjM1LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IlNsb3ciLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzUuMCwiYWJfeWF3X3IiOjQ1LjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IlNsb3ciLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjQwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotNTAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjEwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOmZhbHNlLCJhYl9kZWZfYWEiOmZhbHNlLCJhYl9kZWZfcGl0Y2giOjAuMCwiYWJfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiX2RlbGF5X3R5cGUiOiJGYXN0IiwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfZnJlZXN0YW5kIjoiT2ZmIiwiYWJfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWJfbGJ5X2wiOjYwLjAsImFiX2xieV9yIjo2MC4wLCJhYl9vcHRpb25zIjpbIn4iXSwiYWJfeWF3X2wiOjAuMCwiYWJfeWF3X3IiOjAuMCwiYWJfeWF3X3NlbnMiOjUwLjAsImFiX3lhd190eXBlIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6dHJ1ZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImRlbGF5X3R5cGUiOiJGYXN0IiwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTMwLjAsInlhd19yIjozMC4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6dHJ1ZSwiYWJfZGVmX3BpdGNoIjotNDUuMCwiYWJfZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJhYl9kZWZfdHlwZSI6IkFsd2F5cyBPbiIsImFiX2RlZl95YXdfdHlwZSI6IkN1c3RvbSIsImFiX2RlbGF5X3R5cGUiOiJTbG93IiwiYWJfZW5hYmxlIjp0cnVlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6LTIwLjAsImFiX3lhd19yIjo1MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWxheSBTd2l0Y2giLCJib2R5eWF3Ijp0cnVlLCJkZWZfYWEiOnRydWUsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6IlJhbmRvbSIsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiQ3VzdG9tIiwiZGVsYXlfdHlwZSI6IlNsb3ciLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMTUuMCwieWF3X3IiOjQ1LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotMjEuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOjE4MC4wLCJ5YXdfciI6MTgwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifV1d'}}
configs_db.menu_list = configs_db.menu_list or {'Default'}

configs_db.cfg_list[1][2] = "W3siYWlyYnJlYWtlciI6IlN0YXRpYyBMZWdzIiwiYW5pbWJyZWFrZXIiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWUsImNvbmRpdGlvbiI6Ilx1MDAwNzRGN0NGRkZGV2l0aCBQaXN0b2wiLCJlbmFibGVfYWEiOnRydWUsImZyZWVzX3R5cGUiOjEuMCwiZnJlZXN0YW5kaW5nIjpmYWxzZSwiZ3JvdW5kYnJlYWtlciI6IkppdHRlciIsImh1eW55YV9uZV9udXpobmF5YSI6WyJ+Il0sImxlYW5fdmFsdWUiOjEuMCwibGVnaXRfYWEiOiJKaXR0ZXIiLCJsZWdzX3ZhbHVlIjoxMDAuMCwib3RoZXJicmVha2VyIjpbIlBpdGNoIDAgT24gTGFuZCIsIn4iXSwicGl0Y2giOiJEb3duIiwic2FmZV9oZWFkIjpbIktuaWZlIiwifiJdLCJzaGl0X2FhIjoiUmFuZG9tIiwic3RhdGljX2ZyZWVzIjpbIkRlZmVuc2l2ZSBBQSIsIk9uIE1hbnVhbCIsIn4iXSwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfYmFzZV9kaXNhYmxlciI6WyJEZWZlbnNpdmUgQUEiLCJ+Il19LHsiYWlyX2F3cCI6MjAuMCwiYWlyX3Bpc3RvbHMiOjg5LjAsImFpcl9zY291dCI6NDAuMCwiYWlyX3NlbGVjdCI6WyJTY291dCIsIlI4IiwifiJdLCJhaXJfc3dpdGNoIjp0cnVlLCJhc3BlY3RfcmF0aW8iOnRydWUsImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzLjAsImF1dG9fbXAiOmZhbHNlLCJhdm9pZF9jb2xsaXNpb24iOmZhbHNlLCJiYWltX2F3cCI6ODkuMCwiYmFpbV9yOCI6ODkuMCwiYmFpbV9zY291dCI6OTIuMCwiYmFpbV9zZWxlY3QiOlsiU2NvdXQiLCJ+Il0sImJhaW1fc3dpdGNoIjpmYWxzZSwiY2hlY2tfcHJpbnQiOlsxLjAsMi4wLDMuMCwifiJdLCJjbGFudGFnIjp0cnVlLCJkZWZlX2FkZG9ucyI6dHJ1ZSwiZHJvcF9uYWRlcyI6MC4wLCJmYXN0X2R0Ijp0cnVlLCJmYXN0X2R0X3NlbGVjdCI6IkZhc3QiLCJmYXN0X2ZhbGwiOmZhbHNlLCJmYXN0X2xhZGRlciI6dHJ1ZSwiZm9udF9sb2ciOiJEZWZhdWx0IiwiZnBzX2Jvb3N0Ijp0cnVlLCJoc19zZWxlY3QiOlsiSW4gQWlyIiwifiJdLCJpZGVhbF90aWNrIjpmYWxzZSwianVtcHNjb3V0Ijp0cnVlLCJsb2dfdHlwZSI6OC4wLCJsb2dzIjp0cnVlLCJtdXRlX3NldCI6Ik11dGUiLCJtdXRlX3VubXV0ZSI6ZmFsc2UsIm5hZGVfZml4Ijp0cnVlLCJuYWRlX2ZpeF9zZWxlY3QiOiJEZWZhdWx0Iiwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInByaW50Y29uc29sZSI6WyJDb25zb2xlIiwiU2NyZWVuIiwifiJdLCJxdWlja19zd2l0Y2giOnRydWUsInJlc29sdmVyIjpmYWxzZSwic2FmZV9hd3AiOjg5LjAsInNhZmVfcjgiOjg5LjAsInNhZmVfc2NvdXQiOjg5LjAsInNhZmVfc2VsZWN0IjpbIn4iXSwic2FmZV9zd2l0Y2giOmZhbHNlLCJzY29wZV9hdXRvIjo4OS4wLCJzY29wZV9hd3AiOjg5LjAsInNjb3BlX3Njb3V0Ijo4OS4wLCJzY29wZV9zZWxlY3QiOlsifiJdLCJzaGFyZWRfaWNvbiI6dHJ1ZSwidGFza2JhciI6dHJ1ZSwidGVsZXBvcnQiOmZhbHNlLCJ0ZWxlcG9ydF93cG4iOlsiS25pZmUiLCJTY291dCIsIkFXUCIsIn4iXSwidHJhc2h0YWxrIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsInZpZXdtb2RlbF9mb3YiOjMyLjAsInZpZXdtb2RlbF94IjoyLjAsInZpZXdtb2RlbF95IjotMy4wLCJ2aWV3bW9kZWxfeiI6Mi4wfSx7IlNjb3BlaW52ZXJ0ZWQiOmZhbHNlLCJTY29wZWxlbmd0aCI6ODYuMCwiU2NvcGVvZmZzZXQiOjguMCwiYWRkaXRpb25hbF93YXRlciI6dHJ1ZSwiYXJyb3dzIjp0cnVlLCJhcnJvd3NfY29sb3IiOiIjMzU4REZGRkYiLCJhcnJvd3NfdHlwZSI6MS4wLCJjbHJfY29uc29sZSI6IiM2NDY0NjQ2NCIsImNvbnNvbGVfY29sb3IiOmZhbHNlLCJjcm9zc2hhaXIiOnRydWUsImNyb3NzaGFpcl9jb2xvcjEiOiIjMDBBN0ZGRkYiLCJjcm9zc2hhaXJfY29sb3IyIjoiIzM1QzBGRkZGIiwiY3Jvc3NoYWlyX3N0eWxlIjoyLjAsImdyZW5hZGVfcmFkaXVzIjp0cnVlLCJncmVuYWRlX3NlbGVjdCI6WzEuMCwyLjAsIn4iXSwibWluZG1nIjp0cnVlLCJtaW5kbWdfZm9udCI6IkRlZmF1bHQiLCJtb2xvdG92X2NvbG9yIjoiI0ZGQUExRUJFIiwibW9sb3Rvdl9jb2xvcjIiOiIjRkYzRjNGRkYiLCJzY29wZSI6dHJ1ZSwic2NvcGVfY29sb3IiOiIjRkZGRkZGRkYiLCJzY29wZV9saW5lcyI6WyJVcCIsIkRvd24iLCJMZWZ0IiwiUmlnaHQiLCJ+Il0sInNlbnNlX2luZCI6ZmFsc2UsInNlbnNlX3NlbGVjdCI6WzEuMCwyLjAsMy4wLDQuMCw1LjAsNi4wLDcuMCw4LjAsOS4wLDEwLjAsMTEuMCwifiJdLCJzbG93ZWRfZG93biI6dHJ1ZSwic2xvd2VkX2Rvd25fY29sb3IiOiIjNjc2Q0ZGRkYiLCJzbG93ZWRfZG93bl9jb2xvcjIiOiIjNTQ4RkZGNDIiLCJzbG93ZWRfZG93bl9jb2xvcjMiOiIjRkZGRkZGRkYiLCJzbG93ZWRfZG93bl90eXBlIjoxLjAsInNtb2tlX2NvbG9yIjoiI0QxRDFEMUI0Iiwic25hcGxpbmVzIjp0cnVlLCJzbmFwbGluZXNfY29sb3IiOiIjRkZGRkZGRkYiLCJzbmFwbGluZXNfaGVscGVyIjp0cnVlLCJzb2x1cyI6dHJ1ZSwic29sdXNfY29sb3IiOiIjMzVDMEZGRkYiLCJzb2x1c19nbG93IjpmYWxzZSwic29sdXNfc2VsZWN0IjpbMS4wLDIuMCwzLjAsIn4iXSwic29sdXNfdHlwZSI6My4wLCJzb2x1c2tleV90eXBlIjozLjAsInNvbHVzc3BlY190eXBlIjozLjB9LFt7ImFiMTBfYm9keXlhdyI6Ik9mZiIsImFiMTBfZGVmX2FhIjpmYWxzZSwiYWIxMF9kZWZfcGl0Y2giOjAuMCwiYWIxMF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjEwX2RlZl90eXBlIjoiT24gUGVlayIsImFiMTBfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMTBfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIxMF9kZWxheV90eXBlX21zIjoxLjAsImFiMTBfZGVsYXlfdHlwZV90IjoxLjAsImFiMTBfZnJlZXN0YW5kIjoiT2ZmIiwiYWIxMF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxMF9qaXR0ZXJfY2VudGVyIjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjEwX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMTBfbGJ5X2wiOjYwLjAsImFiMTBfbGJ5X3IiOjYwLjAsImFiMTBfb3B0aW9ucyI6WyJ+Il0sImFiMTBfcF93YXkxIjowLjAsImFiMTBfcF93YXkyIjowLjAsImFiMTBfcF93YXkzIjowLjAsImFiMTBfcF93YXk0IjowLjAsImFiMTBfcF93YXk1IjowLjAsImFiMTBfcF93YXlfZGVsYXkiOjEuMCwiYWIxMF9wX3dheV9zZWxlY3QiOjEuMCwiYWIxMF93YXkxIjowLjAsImFiMTBfd2F5MiI6MC4wLCJhYjEwX3dheTMiOjAuMCwiYWIxMF93YXk0IjowLjAsImFiMTBfd2F5NSI6MC4wLCJhYjEwX3dheV9kZWxheSI6MS4wLCJhYjEwX3dheV9zZWxlY3QiOjEuMCwiYWIxMF95YXdfbCI6MC4wLCJhYjEwX3lhd19yIjowLjAsImFiMTBfeWF3X3NlbnMiOjUwLjAsImFiMTBfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2JvZHl5YXciOiJPZmYiLCJhYjFfZGVmX2FhIjpmYWxzZSwiYWIxX2RlZl9waXRjaCI6MC4wLCJhYjFfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxX2RlZl90eXBlIjoiT24gUGVlayIsImFiMV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMV9kZWxheV90eXBlX21zIjoxLjAsImFiMV9kZWxheV90eXBlX3QiOjEuMCwiYWIxX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjFfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjFfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxX2xieV9sIjo2MC4wLCJhYjFfbGJ5X3IiOjYwLjAsImFiMV9vcHRpb25zIjpbIn4iXSwiYWIxX3Bfd2F5MSI6MC4wLCJhYjFfcF93YXkyIjowLjAsImFiMV9wX3dheTMiOjAuMCwiYWIxX3Bfd2F5NCI6MC4wLCJhYjFfcF93YXk1IjowLjAsImFiMV9wX3dheV9kZWxheSI6MS4wLCJhYjFfcF93YXlfc2VsZWN0IjoxLjAsImFiMV93YXkxIjowLjAsImFiMV93YXkyIjowLjAsImFiMV93YXkzIjowLjAsImFiMV93YXk0IjowLjAsImFiMV93YXk1IjowLjAsImFiMV93YXlfZGVsYXkiOjEuMCwiYWIxX3dheV9zZWxlY3QiOjEuMCwiYWIxX3lhd19sIjowLjAsImFiMV95YXdfciI6MC4wLCJhYjFfeWF3X3NlbnMiOjUwLjAsImFiMV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfYm9keXlhdyI6Ik9mZiIsImFiMl9kZWZfYWEiOmZhbHNlLCJhYjJfZGVmX3BpdGNoIjowLjAsImFiMl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIyX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIyX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIyX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjJfZnJlZXN0YW5kIjoiT2ZmIiwiYWIyX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjJfaml0dGVyX2NlbnRlciI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjJfbGJ5X2wiOjYwLjAsImFiMl9sYnlfciI6NjAuMCwiYWIyX29wdGlvbnMiOlsifiJdLCJhYjJfcF93YXkxIjowLjAsImFiMl9wX3dheTIiOjAuMCwiYWIyX3Bfd2F5MyI6MC4wLCJhYjJfcF93YXk0IjowLjAsImFiMl9wX3dheTUiOjAuMCwiYWIyX3Bfd2F5X2RlbGF5IjoxLjAsImFiMl9wX3dheV9zZWxlY3QiOjEuMCwiYWIyX3dheTEiOjAuMCwiYWIyX3dheTIiOjAuMCwiYWIyX3dheTMiOjAuMCwiYWIyX3dheTQiOjAuMCwiYWIyX3dheTUiOjAuMCwiYWIyX3dheV9kZWxheSI6MS4wLCJhYjJfd2F5X3NlbGVjdCI6MS4wLCJhYjJfeWF3X2wiOjAuMCwiYWIyX3lhd19yIjowLjAsImFiMl95YXdfc2VucyI6NTAuMCwiYWIyX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19ib2R5eWF3IjoiT2ZmIiwiYWIzX2RlZl9hYSI6ZmFsc2UsImFiM19kZWZfcGl0Y2giOjAuMCwiYWIzX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiM19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjNfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19kZWxheV90eXBlIjoiVGlja3MiLCJhYjNfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjNfZGVsYXlfdHlwZV90IjoxLjAsImFiM19mcmVlc3RhbmQiOiJPZmYiLCJhYjNfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiM19qaXR0ZXJfY2VudGVyIjowLjAsImFiM19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIzX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIzX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiM19sYnlfbCI6NjAuMCwiYWIzX2xieV9yIjo2MC4wLCJhYjNfb3B0aW9ucyI6WyJ+Il0sImFiM19wX3dheTEiOjAuMCwiYWIzX3Bfd2F5MiI6MC4wLCJhYjNfcF93YXkzIjowLjAsImFiM19wX3dheTQiOjAuMCwiYWIzX3Bfd2F5NSI6MC4wLCJhYjNfcF93YXlfZGVsYXkiOjEuMCwiYWIzX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjNfd2F5MSI6MC4wLCJhYjNfd2F5MiI6MC4wLCJhYjNfd2F5MyI6MC4wLCJhYjNfd2F5NCI6MC4wLCJhYjNfd2F5NSI6MC4wLCJhYjNfd2F5X2RlbGF5IjoxLjAsImFiM193YXlfc2VsZWN0IjoxLjAsImFiM195YXdfbCI6MC4wLCJhYjNfeWF3X3IiOjAuMCwiYWIzX3lhd19zZW5zIjo1MC4wLCJhYjNfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2JvZHl5YXciOiJPZmYiLCJhYjRfZGVmX2FhIjpmYWxzZSwiYWI0X2RlZl9waXRjaCI6MC4wLCJhYjRfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI0X2RlZl90eXBlIjoiT24gUGVlayIsImFiNF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNF9kZWxheV90eXBlX21zIjoxLjAsImFiNF9kZWxheV90eXBlX3QiOjEuMCwiYWI0X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI0X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjRfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI0X2xieV9sIjo2MC4wLCJhYjRfbGJ5X3IiOjYwLjAsImFiNF9vcHRpb25zIjpbIn4iXSwiYWI0X3Bfd2F5MSI6MC4wLCJhYjRfcF93YXkyIjowLjAsImFiNF9wX3dheTMiOjAuMCwiYWI0X3Bfd2F5NCI6MC4wLCJhYjRfcF93YXk1IjowLjAsImFiNF9wX3dheV9kZWxheSI6MS4wLCJhYjRfcF93YXlfc2VsZWN0IjoxLjAsImFiNF93YXkxIjowLjAsImFiNF93YXkyIjowLjAsImFiNF93YXkzIjowLjAsImFiNF93YXk0IjowLjAsImFiNF93YXk1IjowLjAsImFiNF93YXlfZGVsYXkiOjEuMCwiYWI0X3dheV9zZWxlY3QiOjEuMCwiYWI0X3lhd19sIjowLjAsImFiNF95YXdfciI6MC4wLCJhYjRfeWF3X3NlbnMiOjUwLjAsImFiNF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfYm9keXlhdyI6Ik9mZiIsImFiNV9kZWZfYWEiOmZhbHNlLCJhYjVfZGVmX3BpdGNoIjowLjAsImFiNV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjVfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI1X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI1X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI1X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjVfZnJlZXN0YW5kIjoiT2ZmIiwiYWI1X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjVfaml0dGVyX2NlbnRlciI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjVfbGJ5X2wiOjYwLjAsImFiNV9sYnlfciI6NjAuMCwiYWI1X29wdGlvbnMiOlsifiJdLCJhYjVfcF93YXkxIjowLjAsImFiNV9wX3dheTIiOjAuMCwiYWI1X3Bfd2F5MyI6MC4wLCJhYjVfcF93YXk0IjowLjAsImFiNV9wX3dheTUiOjAuMCwiYWI1X3Bfd2F5X2RlbGF5IjoxLjAsImFiNV9wX3dheV9zZWxlY3QiOjEuMCwiYWI1X3dheTEiOjAuMCwiYWI1X3dheTIiOjAuMCwiYWI1X3dheTMiOjAuMCwiYWI1X3dheTQiOjAuMCwiYWI1X3dheTUiOjAuMCwiYWI1X3dheV9kZWxheSI6MS4wLCJhYjVfd2F5X3NlbGVjdCI6MS4wLCJhYjVfeWF3X2wiOjAuMCwiYWI1X3lhd19yIjowLjAsImFiNV95YXdfc2VucyI6NTAuMCwiYWI1X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9ib2R5eWF3IjoiT2ZmIiwiYWI2X2RlZl9hYSI6ZmFsc2UsImFiNl9kZWZfcGl0Y2giOjAuMCwiYWI2X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjZfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjZfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjZfZGVsYXlfdHlwZV90IjoxLjAsImFiNl9mcmVlc3RhbmQiOiJPZmYiLCJhYjZfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNl9qaXR0ZXJfY2VudGVyIjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI2X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNl9sYnlfbCI6NjAuMCwiYWI2X2xieV9yIjo2MC4wLCJhYjZfb3B0aW9ucyI6WyJ+Il0sImFiNl9wX3dheTEiOjAuMCwiYWI2X3Bfd2F5MiI6MC4wLCJhYjZfcF93YXkzIjowLjAsImFiNl9wX3dheTQiOjAuMCwiYWI2X3Bfd2F5NSI6MC4wLCJhYjZfcF93YXlfZGVsYXkiOjEuMCwiYWI2X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjZfd2F5MSI6MC4wLCJhYjZfd2F5MiI6MC4wLCJhYjZfd2F5MyI6MC4wLCJhYjZfd2F5NCI6MC4wLCJhYjZfd2F5NSI6MC4wLCJhYjZfd2F5X2RlbGF5IjoxLjAsImFiNl93YXlfc2VsZWN0IjoxLjAsImFiNl95YXdfbCI6MC4wLCJhYjZfeWF3X3IiOjAuMCwiYWI2X3lhd19zZW5zIjo1MC4wLCJhYjZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2JvZHl5YXciOiJPZmYiLCJhYjdfZGVmX2FhIjpmYWxzZSwiYWI3X2RlZl9waXRjaCI6MC4wLCJhYjdfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI3X2RlZl90eXBlIjoiT24gUGVlayIsImFiN19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiN19kZWxheV90eXBlX21zIjoxLjAsImFiN19kZWxheV90eXBlX3QiOjEuMCwiYWI3X2ZyZWVzdGFuZCI6Ik9mZiIsImFiN19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI3X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjdfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI3X2xieV9sIjo2MC4wLCJhYjdfbGJ5X3IiOjYwLjAsImFiN19vcHRpb25zIjpbIn4iXSwiYWI3X3Bfd2F5MSI6MC4wLCJhYjdfcF93YXkyIjowLjAsImFiN19wX3dheTMiOjAuMCwiYWI3X3Bfd2F5NCI6MC4wLCJhYjdfcF93YXk1IjowLjAsImFiN19wX3dheV9kZWxheSI6MS4wLCJhYjdfcF93YXlfc2VsZWN0IjoxLjAsImFiN193YXkxIjowLjAsImFiN193YXkyIjowLjAsImFiN193YXkzIjowLjAsImFiN193YXk0IjowLjAsImFiN193YXk1IjowLjAsImFiN193YXlfZGVsYXkiOjEuMCwiYWI3X3dheV9zZWxlY3QiOjEuMCwiYWI3X3lhd19sIjowLjAsImFiN195YXdfciI6MC4wLCJhYjdfeWF3X3NlbnMiOjUwLjAsImFiN195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfYm9keXlhdyI6Ik9mZiIsImFiOF9kZWZfYWEiOmZhbHNlLCJhYjhfZGVmX3BpdGNoIjowLjAsImFiOF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjhfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI4X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI4X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI4X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjhfZnJlZXN0YW5kIjoiT2ZmIiwiYWI4X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjhfaml0dGVyX2NlbnRlciI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjhfbGJ5X2wiOjYwLjAsImFiOF9sYnlfciI6NjAuMCwiYWI4X29wdGlvbnMiOlsifiJdLCJhYjhfcF93YXkxIjowLjAsImFiOF9wX3dheTIiOjAuMCwiYWI4X3Bfd2F5MyI6MC4wLCJhYjhfcF93YXk0IjowLjAsImFiOF9wX3dheTUiOjAuMCwiYWI4X3Bfd2F5X2RlbGF5IjoxLjAsImFiOF9wX3dheV9zZWxlY3QiOjEuMCwiYWI4X3dheTEiOjAuMCwiYWI4X3dheTIiOjAuMCwiYWI4X3dheTMiOjAuMCwiYWI4X3dheTQiOjAuMCwiYWI4X3dheTUiOjAuMCwiYWI4X3dheV9kZWxheSI6MS4wLCJhYjhfd2F5X3NlbGVjdCI6MS4wLCJhYjhfeWF3X2wiOjAuMCwiYWI4X3lhd19yIjowLjAsImFiOF95YXdfc2VucyI6NTAuMCwiYWI4X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9ib2R5eWF3IjoiT2ZmIiwiYWI5X2RlZl9hYSI6ZmFsc2UsImFiOV9kZWZfcGl0Y2giOjAuMCwiYWI5X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjlfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjlfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjlfZGVsYXlfdHlwZV90IjoxLjAsImFiOV9mcmVlc3RhbmQiOiJPZmYiLCJhYjlfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOV9qaXR0ZXJfY2VudGVyIjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI5X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOV9sYnlfbCI6NjAuMCwiYWI5X2xieV9yIjo2MC4wLCJhYjlfb3B0aW9ucyI6WyJ+Il0sImFiOV9wX3dheTEiOjAuMCwiYWI5X3Bfd2F5MiI6MC4wLCJhYjlfcF93YXkzIjowLjAsImFiOV9wX3dheTQiOjAuMCwiYWI5X3Bfd2F5NSI6MC4wLCJhYjlfcF93YXlfZGVsYXkiOjEuMCwiYWI5X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjlfd2F5MSI6MC4wLCJhYjlfd2F5MiI6MC4wLCJhYjlfd2F5MyI6MC4wLCJhYjlfd2F5NCI6MC4wLCJhYjlfd2F5NSI6MC4wLCJhYjlfd2F5X2RlbGF5IjoxLjAsImFiOV93YXlfc2VsZWN0IjoxLjAsImFiOV95YXdfbCI6MC4wLCJhYjlfeWF3X3IiOjAuMCwiYWI5X3lhd19zZW5zIjo1MC4wLCJhYjlfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfcGhhc2UiOjEuMCwiYm9keXlhdyI6Ik9mZiIsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IlRpY2tzIiwiZGVsYXlfdHlwZV9tcyI6MS4wLCJkZWxheV90eXBlX3QiOjEuMCwiZW5hYmxlIjpmYWxzZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwicF93YXkxIjowLjAsInBfd2F5MiI6MC4wLCJwX3dheTMiOjAuMCwicF93YXk0IjowLjAsInBfd2F5NSI6MC4wLCJwX3dheV9kZWxheSI6MS4wLCJwX3dheV9zZWxlY3QiOjEuMCwid2F5MSI6MC4wLCJ3YXkyIjowLjAsIndheTMiOjAuMCwid2F5NCI6MC4wLCJ3YXk1IjowLjAsIndheV9kZWxheSI6MS4wLCJ3YXlfc2VsZWN0IjoxLjAsInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiMTBfYm9keXlhdyI6Ik9mZiIsImFiMTBfZGVmX2FhIjpmYWxzZSwiYWIxMF9kZWZfcGl0Y2giOjAuMCwiYWIxMF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjEwX2RlZl90eXBlIjoiT24gUGVlayIsImFiMTBfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMTBfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIxMF9kZWxheV90eXBlX21zIjoxLjAsImFiMTBfZGVsYXlfdHlwZV90IjoxLjAsImFiMTBfZnJlZXN0YW5kIjoiT2ZmIiwiYWIxMF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxMF9qaXR0ZXJfY2VudGVyIjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjEwX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMTBfbGJ5X2wiOjYwLjAsImFiMTBfbGJ5X3IiOjYwLjAsImFiMTBfb3B0aW9ucyI6WyJ+Il0sImFiMTBfcF93YXkxIjowLjAsImFiMTBfcF93YXkyIjowLjAsImFiMTBfcF93YXkzIjowLjAsImFiMTBfcF93YXk0IjowLjAsImFiMTBfcF93YXk1IjowLjAsImFiMTBfcF93YXlfZGVsYXkiOjEuMCwiYWIxMF9wX3dheV9zZWxlY3QiOjEuMCwiYWIxMF93YXkxIjowLjAsImFiMTBfd2F5MiI6MC4wLCJhYjEwX3dheTMiOjAuMCwiYWIxMF93YXk0IjowLjAsImFiMTBfd2F5NSI6MC4wLCJhYjEwX3dheV9kZWxheSI6MS4wLCJhYjEwX3dheV9zZWxlY3QiOjEuMCwiYWIxMF95YXdfbCI6MC4wLCJhYjEwX3lhd19yIjowLjAsImFiMTBfeWF3X3NlbnMiOjUwLjAsImFiMTBfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2JvZHl5YXciOiJEZWZhdWx0IiwiYWIxX2RlZl9hYSI6ZmFsc2UsImFiMV9kZWZfcGl0Y2giOjAuMCwiYWIxX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjFfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjFfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjFfZGVsYXlfdHlwZV90IjoyLjAsImFiMV9mcmVlc3RhbmQiOiJPZmYiLCJhYjFfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMV9qaXR0ZXJfY2VudGVyIjowLjAsImFiMV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMV9sYnlfbCI6NjAuMCwiYWIxX2xieV9yIjo2MC4wLCJhYjFfb3B0aW9ucyI6WyJ+Il0sImFiMV9wX3dheTEiOjAuMCwiYWIxX3Bfd2F5MiI6MC4wLCJhYjFfcF93YXkzIjowLjAsImFiMV9wX3dheTQiOjAuMCwiYWIxX3Bfd2F5NSI6MC4wLCJhYjFfcF93YXlfZGVsYXkiOjEuMCwiYWIxX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjFfd2F5MSI6MC4wLCJhYjFfd2F5MiI6MC4wLCJhYjFfd2F5MyI6MC4wLCJhYjFfd2F5NCI6MC4wLCJhYjFfd2F5NSI6MC4wLCJhYjFfd2F5X2RlbGF5IjoxLjAsImFiMV93YXlfc2VsZWN0IjoxLjAsImFiMV95YXdfbCI6LTMzLjAsImFiMV95YXdfciI6NDAuMCwiYWIxX3lhd19zZW5zIjo1MC4wLCJhYjFfeWF3X3R5cGUiOiJEZWxheSBTd2l0Y2giLCJhYjJfYm9keXlhdyI6IkRlZmF1bHQiLCJhYjJfZGVmX2FhIjpmYWxzZSwiYWIyX2RlZl9waXRjaCI6MC4wLCJhYjJfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIyX2RlZl90eXBlIjoiT24gUGVlayIsImFiMl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMl9kZWxheV90eXBlX21zIjoxLjAsImFiMl9kZWxheV90eXBlX3QiOjIuMCwiYWIyX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIyX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIyX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIyX2xieV9sIjo2MC4wLCJhYjJfbGJ5X3IiOjYwLjAsImFiMl9vcHRpb25zIjpbIn4iXSwiYWIyX3Bfd2F5MSI6MC4wLCJhYjJfcF93YXkyIjowLjAsImFiMl9wX3dheTMiOjAuMCwiYWIyX3Bfd2F5NCI6MC4wLCJhYjJfcF93YXk1IjowLjAsImFiMl9wX3dheV9kZWxheSI6MS4wLCJhYjJfcF93YXlfc2VsZWN0IjoxLjAsImFiMl93YXkxIjowLjAsImFiMl93YXkyIjowLjAsImFiMl93YXkzIjowLjAsImFiMl93YXk0IjowLjAsImFiMl93YXk1IjowLjAsImFiMl93YXlfZGVsYXkiOjEuMCwiYWIyX3dheV9zZWxlY3QiOjEuMCwiYWIyX3lhd19sIjotMzUuMCwiYWIyX3lhd19yIjo0My4wLCJhYjJfeWF3X3NlbnMiOjUwLjAsImFiMl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImFiM19ib2R5eWF3IjoiRGVmYXVsdCIsImFiM19kZWZfYWEiOmZhbHNlLCJhYjNfZGVmX3BpdGNoIjowLjAsImFiM19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjNfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIzX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIzX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIzX2RlbGF5X3R5cGVfdCI6Mi4wLCJhYjNfZnJlZXN0YW5kIjoiT2ZmIiwiYWIzX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjNfaml0dGVyX2NlbnRlciI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiM19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiM19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjNfbGJ5X2wiOjYwLjAsImFiM19sYnlfciI6NjAuMCwiYWIzX29wdGlvbnMiOlsifiJdLCJhYjNfcF93YXkxIjowLjAsImFiM19wX3dheTIiOjAuMCwiYWIzX3Bfd2F5MyI6MC4wLCJhYjNfcF93YXk0IjowLjAsImFiM19wX3dheTUiOjAuMCwiYWIzX3Bfd2F5X2RlbGF5IjoxLjAsImFiM19wX3dheV9zZWxlY3QiOjEuMCwiYWIzX3dheTEiOjAuMCwiYWIzX3dheTIiOjAuMCwiYWIzX3dheTMiOjAuMCwiYWIzX3dheTQiOjAuMCwiYWIzX3dheTUiOjAuMCwiYWIzX3dheV9kZWxheSI6MS4wLCJhYjNfd2F5X3NlbGVjdCI6MS4wLCJhYjNfeWF3X2wiOi0zMy4wLCJhYjNfeWF3X3IiOjQwLjAsImFiM195YXdfc2VucyI6NTAuMCwiYWIzX3lhd190eXBlIjoiRGVsYXkgU3dpdGNoIiwiYWI0X2JvZHl5YXciOiJPZmYiLCJhYjRfZGVmX2FhIjpmYWxzZSwiYWI0X2RlZl9waXRjaCI6MC4wLCJhYjRfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI0X2RlZl90eXBlIjoiT24gUGVlayIsImFiNF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNF9kZWxheV90eXBlX21zIjoxLjAsImFiNF9kZWxheV90eXBlX3QiOjEuMCwiYWI0X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI0X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjRfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI0X2xieV9sIjo2MC4wLCJhYjRfbGJ5X3IiOjYwLjAsImFiNF9vcHRpb25zIjpbIn4iXSwiYWI0X3Bfd2F5MSI6MC4wLCJhYjRfcF93YXkyIjowLjAsImFiNF9wX3dheTMiOjAuMCwiYWI0X3Bfd2F5NCI6MC4wLCJhYjRfcF93YXk1IjowLjAsImFiNF9wX3dheV9kZWxheSI6MS4wLCJhYjRfcF93YXlfc2VsZWN0IjoxLjAsImFiNF93YXkxIjowLjAsImFiNF93YXkyIjowLjAsImFiNF93YXkzIjowLjAsImFiNF93YXk0IjowLjAsImFiNF93YXk1IjowLjAsImFiNF93YXlfZGVsYXkiOjEuMCwiYWI0X3dheV9zZWxlY3QiOjEuMCwiYWI0X3lhd19sIjowLjAsImFiNF95YXdfciI6MC4wLCJhYjRfeWF3X3NlbnMiOjUwLjAsImFiNF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfYm9keXlhdyI6Ik9mZiIsImFiNV9kZWZfYWEiOmZhbHNlLCJhYjVfZGVmX3BpdGNoIjowLjAsImFiNV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjVfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI1X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI1X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI1X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjVfZnJlZXN0YW5kIjoiT2ZmIiwiYWI1X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjVfaml0dGVyX2NlbnRlciI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjVfbGJ5X2wiOjYwLjAsImFiNV9sYnlfciI6NjAuMCwiYWI1X29wdGlvbnMiOlsifiJdLCJhYjVfcF93YXkxIjowLjAsImFiNV9wX3dheTIiOjAuMCwiYWI1X3Bfd2F5MyI6MC4wLCJhYjVfcF93YXk0IjowLjAsImFiNV9wX3dheTUiOjAuMCwiYWI1X3Bfd2F5X2RlbGF5IjoxLjAsImFiNV9wX3dheV9zZWxlY3QiOjEuMCwiYWI1X3dheTEiOjAuMCwiYWI1X3dheTIiOjAuMCwiYWI1X3dheTMiOjAuMCwiYWI1X3dheTQiOjAuMCwiYWI1X3dheTUiOjAuMCwiYWI1X3dheV9kZWxheSI6MS4wLCJhYjVfd2F5X3NlbGVjdCI6MS4wLCJhYjVfeWF3X2wiOjAuMCwiYWI1X3lhd19yIjowLjAsImFiNV95YXdfc2VucyI6NTAuMCwiYWI1X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9ib2R5eWF3IjoiT2ZmIiwiYWI2X2RlZl9hYSI6ZmFsc2UsImFiNl9kZWZfcGl0Y2giOjAuMCwiYWI2X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjZfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjZfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjZfZGVsYXlfdHlwZV90IjoxLjAsImFiNl9mcmVlc3RhbmQiOiJPZmYiLCJhYjZfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNl9qaXR0ZXJfY2VudGVyIjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI2X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNl9sYnlfbCI6NjAuMCwiYWI2X2xieV9yIjo2MC4wLCJhYjZfb3B0aW9ucyI6WyJ+Il0sImFiNl9wX3dheTEiOjAuMCwiYWI2X3Bfd2F5MiI6MC4wLCJhYjZfcF93YXkzIjowLjAsImFiNl9wX3dheTQiOjAuMCwiYWI2X3Bfd2F5NSI6MC4wLCJhYjZfcF93YXlfZGVsYXkiOjEuMCwiYWI2X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjZfd2F5MSI6MC4wLCJhYjZfd2F5MiI6MC4wLCJhYjZfd2F5MyI6MC4wLCJhYjZfd2F5NCI6MC4wLCJhYjZfd2F5NSI6MC4wLCJhYjZfd2F5X2RlbGF5IjoxLjAsImFiNl93YXlfc2VsZWN0IjoxLjAsImFiNl95YXdfbCI6MC4wLCJhYjZfeWF3X3IiOjAuMCwiYWI2X3lhd19zZW5zIjo1MC4wLCJhYjZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2JvZHl5YXciOiJPZmYiLCJhYjdfZGVmX2FhIjpmYWxzZSwiYWI3X2RlZl9waXRjaCI6MC4wLCJhYjdfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI3X2RlZl90eXBlIjoiT24gUGVlayIsImFiN19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiN19kZWxheV90eXBlX21zIjoxLjAsImFiN19kZWxheV90eXBlX3QiOjEuMCwiYWI3X2ZyZWVzdGFuZCI6Ik9mZiIsImFiN19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI3X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjdfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI3X2xieV9sIjo2MC4wLCJhYjdfbGJ5X3IiOjYwLjAsImFiN19vcHRpb25zIjpbIn4iXSwiYWI3X3Bfd2F5MSI6MC4wLCJhYjdfcF93YXkyIjowLjAsImFiN19wX3dheTMiOjAuMCwiYWI3X3Bfd2F5NCI6MC4wLCJhYjdfcF93YXk1IjowLjAsImFiN19wX3dheV9kZWxheSI6MS4wLCJhYjdfcF93YXlfc2VsZWN0IjoxLjAsImFiN193YXkxIjowLjAsImFiN193YXkyIjowLjAsImFiN193YXkzIjowLjAsImFiN193YXk0IjowLjAsImFiN193YXk1IjowLjAsImFiN193YXlfZGVsYXkiOjEuMCwiYWI3X3dheV9zZWxlY3QiOjEuMCwiYWI3X3lhd19sIjowLjAsImFiN195YXdfciI6MC4wLCJhYjdfeWF3X3NlbnMiOjUwLjAsImFiN195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfYm9keXlhdyI6Ik9mZiIsImFiOF9kZWZfYWEiOmZhbHNlLCJhYjhfZGVmX3BpdGNoIjowLjAsImFiOF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjhfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI4X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI4X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI4X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjhfZnJlZXN0YW5kIjoiT2ZmIiwiYWI4X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjhfaml0dGVyX2NlbnRlciI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjhfbGJ5X2wiOjYwLjAsImFiOF9sYnlfciI6NjAuMCwiYWI4X29wdGlvbnMiOlsifiJdLCJhYjhfcF93YXkxIjowLjAsImFiOF9wX3dheTIiOjAuMCwiYWI4X3Bfd2F5MyI6MC4wLCJhYjhfcF93YXk0IjowLjAsImFiOF9wX3dheTUiOjAuMCwiYWI4X3Bfd2F5X2RlbGF5IjoxLjAsImFiOF9wX3dheV9zZWxlY3QiOjEuMCwiYWI4X3dheTEiOjAuMCwiYWI4X3dheTIiOjAuMCwiYWI4X3dheTMiOjAuMCwiYWI4X3dheTQiOjAuMCwiYWI4X3dheTUiOjAuMCwiYWI4X3dheV9kZWxheSI6MS4wLCJhYjhfd2F5X3NlbGVjdCI6MS4wLCJhYjhfeWF3X2wiOjAuMCwiYWI4X3lhd19yIjowLjAsImFiOF95YXdfc2VucyI6NTAuMCwiYWI4X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9ib2R5eWF3IjoiT2ZmIiwiYWI5X2RlZl9hYSI6ZmFsc2UsImFiOV9kZWZfcGl0Y2giOjAuMCwiYWI5X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjlfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjlfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjlfZGVsYXlfdHlwZV90IjoxLjAsImFiOV9mcmVlc3RhbmQiOiJPZmYiLCJhYjlfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOV9qaXR0ZXJfY2VudGVyIjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI5X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOV9sYnlfbCI6NjAuMCwiYWI5X2xieV9yIjo2MC4wLCJhYjlfb3B0aW9ucyI6WyJ+Il0sImFiOV9wX3dheTEiOjAuMCwiYWI5X3Bfd2F5MiI6MC4wLCJhYjlfcF93YXkzIjowLjAsImFiOV9wX3dheTQiOjAuMCwiYWI5X3Bfd2F5NSI6MC4wLCJhYjlfcF93YXlfZGVsYXkiOjEuMCwiYWI5X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjlfd2F5MSI6MC4wLCJhYjlfd2F5MiI6MC4wLCJhYjlfd2F5MyI6MC4wLCJhYjlfd2F5NCI6MC4wLCJhYjlfd2F5NSI6MC4wLCJhYjlfd2F5X2RlbGF5IjoxLjAsImFiOV93YXlfc2VsZWN0IjoxLjAsImFiOV95YXdfbCI6MC4wLCJhYjlfeWF3X3IiOjAuMCwiYWI5X3lhd19zZW5zIjo1MC4wLCJhYjlfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZW5hYmxlIjp0cnVlLCJhYl9waGFzZSI6My4wLCJib2R5eWF3IjoiRGVmYXVsdCIsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9mZiIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiVGlja3MiLCJkZWxheV90eXBlX21zIjoxLjAsImRlbGF5X3R5cGVfdCI6Mi4wLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInBfd2F5MSI6MC4wLCJwX3dheTIiOjAuMCwicF93YXkzIjowLjAsInBfd2F5NCI6MC4wLCJwX3dheTUiOjAuMCwicF93YXlfZGVsYXkiOjEuMCwicF93YXlfc2VsZWN0IjoxLjAsIndheTEiOjAuMCwid2F5MiI6MC4wLCJ3YXkzIjowLjAsIndheTQiOjAuMCwid2F5NSI6MC4wLCJ3YXlfZGVsYXkiOjEuMCwid2F5X3NlbGVjdCI6MS4wLCJ5YXdfbCI6LTMwLjAsInlhd19yIjozNy4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiMTBfYm9keXlhdyI6Ik9mZiIsImFiMTBfZGVmX2FhIjpmYWxzZSwiYWIxMF9kZWZfcGl0Y2giOjAuMCwiYWIxMF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjEwX2RlZl90eXBlIjoiT24gUGVlayIsImFiMTBfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMTBfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIxMF9kZWxheV90eXBlX21zIjoxLjAsImFiMTBfZGVsYXlfdHlwZV90IjoxLjAsImFiMTBfZnJlZXN0YW5kIjoiT2ZmIiwiYWIxMF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxMF9qaXR0ZXJfY2VudGVyIjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjEwX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMTBfbGJ5X2wiOjYwLjAsImFiMTBfbGJ5X3IiOjYwLjAsImFiMTBfb3B0aW9ucyI6WyJ+Il0sImFiMTBfcF93YXkxIjowLjAsImFiMTBfcF93YXkyIjowLjAsImFiMTBfcF93YXkzIjowLjAsImFiMTBfcF93YXk0IjowLjAsImFiMTBfcF93YXk1IjowLjAsImFiMTBfcF93YXlfZGVsYXkiOjEuMCwiYWIxMF9wX3dheV9zZWxlY3QiOjEuMCwiYWIxMF93YXkxIjowLjAsImFiMTBfd2F5MiI6MC4wLCJhYjEwX3dheTMiOjAuMCwiYWIxMF93YXk0IjowLjAsImFiMTBfd2F5NSI6MC4wLCJhYjEwX3dheV9kZWxheSI6MS4wLCJhYjEwX3dheV9zZWxlY3QiOjEuMCwiYWIxMF95YXdfbCI6MC4wLCJhYjEwX3lhd19yIjowLjAsImFiMTBfeWF3X3NlbnMiOjUwLjAsImFiMTBfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2JvZHl5YXciOiJEZWZhdWx0IiwiYWIxX2RlZl9hYSI6ZmFsc2UsImFiMV9kZWZfcGl0Y2giOjAuMCwiYWIxX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjFfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjFfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjFfZGVsYXlfdHlwZV90IjoxLjAsImFiMV9mcmVlc3RhbmQiOiJPZmYiLCJhYjFfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMV9qaXR0ZXJfY2VudGVyIjowLjAsImFiMV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMV9sYnlfbCI6NjAuMCwiYWIxX2xieV9yIjo2MC4wLCJhYjFfb3B0aW9ucyI6WyJ+Il0sImFiMV9wX3dheTEiOjAuMCwiYWIxX3Bfd2F5MiI6MC4wLCJhYjFfcF93YXkzIjowLjAsImFiMV9wX3dheTQiOjAuMCwiYWIxX3Bfd2F5NSI6MC4wLCJhYjFfcF93YXlfZGVsYXkiOjEuMCwiYWIxX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjFfd2F5MSI6MC4wLCJhYjFfd2F5MiI6MC4wLCJhYjFfd2F5MyI6MC4wLCJhYjFfd2F5NCI6MC4wLCJhYjFfd2F5NSI6MC4wLCJhYjFfd2F5X2RlbGF5IjoxLjAsImFiMV93YXlfc2VsZWN0IjoxLjAsImFiMV95YXdfbCI6LTMzLjAsImFiMV95YXdfciI6MzguMCwiYWIxX3lhd19zZW5zIjo1MC4wLCJhYjFfeWF3X3R5cGUiOiJEZWxheSBTd2l0Y2giLCJhYjJfYm9keXlhdyI6IkRlZmF1bHQiLCJhYjJfZGVmX2FhIjpmYWxzZSwiYWIyX2RlZl9waXRjaCI6MC4wLCJhYjJfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIyX2RlZl90eXBlIjoiT24gUGVlayIsImFiMl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMl9kZWxheV90eXBlX21zIjoxLjAsImFiMl9kZWxheV90eXBlX3QiOjEuMCwiYWIyX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIyX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIyX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIyX2xieV9sIjo2MC4wLCJhYjJfbGJ5X3IiOjYwLjAsImFiMl9vcHRpb25zIjpbIn4iXSwiYWIyX3Bfd2F5MSI6MC4wLCJhYjJfcF93YXkyIjowLjAsImFiMl9wX3dheTMiOjAuMCwiYWIyX3Bfd2F5NCI6MC4wLCJhYjJfcF93YXk1IjowLjAsImFiMl9wX3dheV9kZWxheSI6MS4wLCJhYjJfcF93YXlfc2VsZWN0IjoxLjAsImFiMl93YXkxIjowLjAsImFiMl93YXkyIjowLjAsImFiMl93YXkzIjowLjAsImFiMl93YXk0IjowLjAsImFiMl93YXk1IjowLjAsImFiMl93YXlfZGVsYXkiOjEuMCwiYWIyX3dheV9zZWxlY3QiOjEuMCwiYWIyX3lhd19sIjotMzUuMCwiYWIyX3lhd19yIjo0MC4wLCJhYjJfeWF3X3NlbnMiOjUwLjAsImFiMl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImFiM19ib2R5eWF3IjoiRGVmYXVsdCIsImFiM19kZWZfYWEiOmZhbHNlLCJhYjNfZGVmX3BpdGNoIjowLjAsImFiM19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjNfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIzX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIzX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIzX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjNfZnJlZXN0YW5kIjoiT2ZmIiwiYWIzX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjNfaml0dGVyX2NlbnRlciI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiM19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiM19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjNfbGJ5X2wiOjYwLjAsImFiM19sYnlfciI6NjAuMCwiYWIzX29wdGlvbnMiOlsifiJdLCJhYjNfcF93YXkxIjowLjAsImFiM19wX3dheTIiOjAuMCwiYWIzX3Bfd2F5MyI6MC4wLCJhYjNfcF93YXk0IjowLjAsImFiM19wX3dheTUiOjAuMCwiYWIzX3Bfd2F5X2RlbGF5IjoxLjAsImFiM19wX3dheV9zZWxlY3QiOjEuMCwiYWIzX3dheTEiOjAuMCwiYWIzX3dheTIiOjAuMCwiYWIzX3dheTMiOjAuMCwiYWIzX3dheTQiOjAuMCwiYWIzX3dheTUiOjAuMCwiYWIzX3dheV9kZWxheSI6MS4wLCJhYjNfd2F5X3NlbGVjdCI6MS4wLCJhYjNfeWF3X2wiOi0zMy4wLCJhYjNfeWF3X3IiOjM4LjAsImFiM195YXdfc2VucyI6NTAuMCwiYWIzX3lhd190eXBlIjoiRGVsYXkgU3dpdGNoIiwiYWI0X2JvZHl5YXciOiJPZmYiLCJhYjRfZGVmX2FhIjpmYWxzZSwiYWI0X2RlZl9waXRjaCI6MC4wLCJhYjRfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI0X2RlZl90eXBlIjoiT24gUGVlayIsImFiNF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNF9kZWxheV90eXBlX21zIjoxLjAsImFiNF9kZWxheV90eXBlX3QiOjEuMCwiYWI0X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI0X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjRfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI0X2xieV9sIjo2MC4wLCJhYjRfbGJ5X3IiOjYwLjAsImFiNF9vcHRpb25zIjpbIn4iXSwiYWI0X3Bfd2F5MSI6MC4wLCJhYjRfcF93YXkyIjowLjAsImFiNF9wX3dheTMiOjAuMCwiYWI0X3Bfd2F5NCI6MC4wLCJhYjRfcF93YXk1IjowLjAsImFiNF9wX3dheV9kZWxheSI6MS4wLCJhYjRfcF93YXlfc2VsZWN0IjoxLjAsImFiNF93YXkxIjowLjAsImFiNF93YXkyIjowLjAsImFiNF93YXkzIjowLjAsImFiNF93YXk0IjowLjAsImFiNF93YXk1IjowLjAsImFiNF93YXlfZGVsYXkiOjEuMCwiYWI0X3dheV9zZWxlY3QiOjEuMCwiYWI0X3lhd19sIjowLjAsImFiNF95YXdfciI6MC4wLCJhYjRfeWF3X3NlbnMiOjUwLjAsImFiNF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfYm9keXlhdyI6Ik9mZiIsImFiNV9kZWZfYWEiOmZhbHNlLCJhYjVfZGVmX3BpdGNoIjowLjAsImFiNV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjVfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI1X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI1X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI1X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjVfZnJlZXN0YW5kIjoiT2ZmIiwiYWI1X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjVfaml0dGVyX2NlbnRlciI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjVfbGJ5X2wiOjYwLjAsImFiNV9sYnlfciI6NjAuMCwiYWI1X29wdGlvbnMiOlsifiJdLCJhYjVfcF93YXkxIjowLjAsImFiNV9wX3dheTIiOjAuMCwiYWI1X3Bfd2F5MyI6MC4wLCJhYjVfcF93YXk0IjowLjAsImFiNV9wX3dheTUiOjAuMCwiYWI1X3Bfd2F5X2RlbGF5IjoxLjAsImFiNV9wX3dheV9zZWxlY3QiOjEuMCwiYWI1X3dheTEiOjAuMCwiYWI1X3dheTIiOjAuMCwiYWI1X3dheTMiOjAuMCwiYWI1X3dheTQiOjAuMCwiYWI1X3dheTUiOjAuMCwiYWI1X3dheV9kZWxheSI6MS4wLCJhYjVfd2F5X3NlbGVjdCI6MS4wLCJhYjVfeWF3X2wiOjAuMCwiYWI1X3lhd19yIjowLjAsImFiNV95YXdfc2VucyI6NTAuMCwiYWI1X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9ib2R5eWF3IjoiT2ZmIiwiYWI2X2RlZl9hYSI6ZmFsc2UsImFiNl9kZWZfcGl0Y2giOjAuMCwiYWI2X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjZfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjZfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjZfZGVsYXlfdHlwZV90IjoxLjAsImFiNl9mcmVlc3RhbmQiOiJPZmYiLCJhYjZfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNl9qaXR0ZXJfY2VudGVyIjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI2X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNl9sYnlfbCI6NjAuMCwiYWI2X2xieV9yIjo2MC4wLCJhYjZfb3B0aW9ucyI6WyJ+Il0sImFiNl9wX3dheTEiOjAuMCwiYWI2X3Bfd2F5MiI6MC4wLCJhYjZfcF93YXkzIjowLjAsImFiNl9wX3dheTQiOjAuMCwiYWI2X3Bfd2F5NSI6MC4wLCJhYjZfcF93YXlfZGVsYXkiOjEuMCwiYWI2X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjZfd2F5MSI6MC4wLCJhYjZfd2F5MiI6MC4wLCJhYjZfd2F5MyI6MC4wLCJhYjZfd2F5NCI6MC4wLCJhYjZfd2F5NSI6MC4wLCJhYjZfd2F5X2RlbGF5IjoxLjAsImFiNl93YXlfc2VsZWN0IjoxLjAsImFiNl95YXdfbCI6MC4wLCJhYjZfeWF3X3IiOjAuMCwiYWI2X3lhd19zZW5zIjo1MC4wLCJhYjZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2JvZHl5YXciOiJPZmYiLCJhYjdfZGVmX2FhIjpmYWxzZSwiYWI3X2RlZl9waXRjaCI6MC4wLCJhYjdfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI3X2RlZl90eXBlIjoiT24gUGVlayIsImFiN19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiN19kZWxheV90eXBlX21zIjoxLjAsImFiN19kZWxheV90eXBlX3QiOjEuMCwiYWI3X2ZyZWVzdGFuZCI6Ik9mZiIsImFiN19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI3X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjdfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI3X2xieV9sIjo2MC4wLCJhYjdfbGJ5X3IiOjYwLjAsImFiN19vcHRpb25zIjpbIn4iXSwiYWI3X3Bfd2F5MSI6MC4wLCJhYjdfcF93YXkyIjowLjAsImFiN19wX3dheTMiOjAuMCwiYWI3X3Bfd2F5NCI6MC4wLCJhYjdfcF93YXk1IjowLjAsImFiN19wX3dheV9kZWxheSI6MS4wLCJhYjdfcF93YXlfc2VsZWN0IjoxLjAsImFiN193YXkxIjowLjAsImFiN193YXkyIjowLjAsImFiN193YXkzIjowLjAsImFiN193YXk0IjowLjAsImFiN193YXk1IjowLjAsImFiN193YXlfZGVsYXkiOjEuMCwiYWI3X3dheV9zZWxlY3QiOjEuMCwiYWI3X3lhd19sIjowLjAsImFiN195YXdfciI6MC4wLCJhYjdfeWF3X3NlbnMiOjUwLjAsImFiN195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfYm9keXlhdyI6Ik9mZiIsImFiOF9kZWZfYWEiOmZhbHNlLCJhYjhfZGVmX3BpdGNoIjowLjAsImFiOF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjhfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI4X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI4X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI4X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjhfZnJlZXN0YW5kIjoiT2ZmIiwiYWI4X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjhfaml0dGVyX2NlbnRlciI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjhfbGJ5X2wiOjYwLjAsImFiOF9sYnlfciI6NjAuMCwiYWI4X29wdGlvbnMiOlsifiJdLCJhYjhfcF93YXkxIjowLjAsImFiOF9wX3dheTIiOjAuMCwiYWI4X3Bfd2F5MyI6MC4wLCJhYjhfcF93YXk0IjowLjAsImFiOF9wX3dheTUiOjAuMCwiYWI4X3Bfd2F5X2RlbGF5IjoxLjAsImFiOF9wX3dheV9zZWxlY3QiOjEuMCwiYWI4X3dheTEiOjAuMCwiYWI4X3dheTIiOjAuMCwiYWI4X3dheTMiOjAuMCwiYWI4X3dheTQiOjAuMCwiYWI4X3dheTUiOjAuMCwiYWI4X3dheV9kZWxheSI6MS4wLCJhYjhfd2F5X3NlbGVjdCI6MS4wLCJhYjhfeWF3X2wiOjAuMCwiYWI4X3lhd19yIjowLjAsImFiOF95YXdfc2VucyI6NTAuMCwiYWI4X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9ib2R5eWF3IjoiT2ZmIiwiYWI5X2RlZl9hYSI6ZmFsc2UsImFiOV9kZWZfcGl0Y2giOjAuMCwiYWI5X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjlfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjlfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjlfZGVsYXlfdHlwZV90IjoxLjAsImFiOV9mcmVlc3RhbmQiOiJPZmYiLCJhYjlfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOV9qaXR0ZXJfY2VudGVyIjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI5X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOV9sYnlfbCI6NjAuMCwiYWI5X2xieV9yIjo2MC4wLCJhYjlfb3B0aW9ucyI6WyJ+Il0sImFiOV9wX3dheTEiOjAuMCwiYWI5X3Bfd2F5MiI6MC4wLCJhYjlfcF93YXkzIjowLjAsImFiOV9wX3dheTQiOjAuMCwiYWI5X3Bfd2F5NSI6MC4wLCJhYjlfcF93YXlfZGVsYXkiOjEuMCwiYWI5X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjlfd2F5MSI6MC4wLCJhYjlfd2F5MiI6MC4wLCJhYjlfd2F5MyI6MC4wLCJhYjlfd2F5NCI6MC4wLCJhYjlfd2F5NSI6MC4wLCJhYjlfd2F5X2RlbGF5IjoxLjAsImFiOV93YXlfc2VsZWN0IjoxLjAsImFiOV95YXdfbCI6MC4wLCJhYjlfeWF3X3IiOjAuMCwiYWI5X3lhd19zZW5zIjo1MC4wLCJhYjlfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZW5hYmxlIjp0cnVlLCJhYl9waGFzZSI6My4wLCJib2R5eWF3IjoiRGVmYXVsdCIsImRlZl9hYSI6dHJ1ZSwiZGVmX3BpdGNoIjoyLjAsImRlZl9waXRjaF90eXBlIjoiVXAiLCJkZWZfdHlwZSI6Ik9mZiIsImRlZl95YXdfdHlwZSI6IlNpZGUtV2F5cyIsImRlbGF5X3R5cGUiOiJUaWNrcyIsImRlbGF5X3R5cGVfbXMiOjEuMCwiZGVsYXlfdHlwZV90IjoxLjAsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicF93YXkxIjowLjAsInBfd2F5MiI6MC4wLCJwX3dheTMiOjAuMCwicF93YXk0IjowLjAsInBfd2F5NSI6MC4wLCJwX3dheV9kZWxheSI6MS4wLCJwX3dheV9zZWxlY3QiOjEuMCwid2F5MSI6MC4wLCJ3YXkyIjowLjAsIndheTMiOjAuMCwid2F5NCI6MC4wLCJ3YXk1IjowLjAsIndheV9kZWxheSI6MS4wLCJ3YXlfc2VsZWN0IjoxLjAsInlhd19sIjotMzAuMCwieWF3X3IiOjM1LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWIxMF9ib2R5eWF3IjoiT2ZmIiwiYWIxMF9kZWZfYWEiOmZhbHNlLCJhYjEwX2RlZl9waXRjaCI6MC4wLCJhYjEwX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMTBfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIxMF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxMF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjEwX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIxMF9kZWxheV90eXBlX3QiOjEuMCwiYWIxMF9mcmVlc3RhbmQiOiJPZmYiLCJhYjEwX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjEwX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxMF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxMF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMTBfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxMF9sYnlfbCI6NjAuMCwiYWIxMF9sYnlfciI6NjAuMCwiYWIxMF9vcHRpb25zIjpbIn4iXSwiYWIxMF9wX3dheTEiOjAuMCwiYWIxMF9wX3dheTIiOjAuMCwiYWIxMF9wX3dheTMiOjAuMCwiYWIxMF9wX3dheTQiOjAuMCwiYWIxMF9wX3dheTUiOjAuMCwiYWIxMF9wX3dheV9kZWxheSI6MS4wLCJhYjEwX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjEwX3dheTEiOjAuMCwiYWIxMF93YXkyIjowLjAsImFiMTBfd2F5MyI6MC4wLCJhYjEwX3dheTQiOjAuMCwiYWIxMF93YXk1IjowLjAsImFiMTBfd2F5X2RlbGF5IjoxLjAsImFiMTBfd2F5X3NlbGVjdCI6MS4wLCJhYjEwX3lhd19sIjowLjAsImFiMTBfeWF3X3IiOjAuMCwiYWIxMF95YXdfc2VucyI6NTAuMCwiYWIxMF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjFfYm9keXlhdyI6IkRlZmF1bHQiLCJhYjFfZGVmX2FhIjpmYWxzZSwiYWIxX2RlZl9waXRjaCI6MC4wLCJhYjFfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxX2RlZl90eXBlIjoiT24gUGVlayIsImFiMV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMV9kZWxheV90eXBlX21zIjoxLjAsImFiMV9kZWxheV90eXBlX3QiOjUuMCwiYWIxX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjFfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjFfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxX2xieV9sIjo2MC4wLCJhYjFfbGJ5X3IiOjYwLjAsImFiMV9vcHRpb25zIjpbIn4iXSwiYWIxX3Bfd2F5MSI6MC4wLCJhYjFfcF93YXkyIjowLjAsImFiMV9wX3dheTMiOjAuMCwiYWIxX3Bfd2F5NCI6MC4wLCJhYjFfcF93YXk1IjowLjAsImFiMV9wX3dheV9kZWxheSI6MS4wLCJhYjFfcF93YXlfc2VsZWN0IjoxLjAsImFiMV93YXkxIjowLjAsImFiMV93YXkyIjowLjAsImFiMV93YXkzIjowLjAsImFiMV93YXk0IjowLjAsImFiMV93YXk1IjowLjAsImFiMV93YXlfZGVsYXkiOjEuMCwiYWIxX3dheV9zZWxlY3QiOjEuMCwiYWIxX3lhd19sIjotMzMuMCwiYWIxX3lhd19yIjo0MC4wLCJhYjFfeWF3X3NlbnMiOjUwLjAsImFiMV95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImFiMl9ib2R5eWF3IjoiT2ZmIiwiYWIyX2RlZl9hYSI6ZmFsc2UsImFiMl9kZWZfcGl0Y2giOjAuMCwiYWIyX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjJfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjJfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjJfZGVsYXlfdHlwZV90IjoxLjAsImFiMl9mcmVlc3RhbmQiOiJPZmYiLCJhYjJfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMl9qaXR0ZXJfY2VudGVyIjowLjAsImFiMl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIyX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIyX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMl9sYnlfbCI6NjAuMCwiYWIyX2xieV9yIjo2MC4wLCJhYjJfb3B0aW9ucyI6WyJ+Il0sImFiMl9wX3dheTEiOjAuMCwiYWIyX3Bfd2F5MiI6MC4wLCJhYjJfcF93YXkzIjowLjAsImFiMl9wX3dheTQiOjAuMCwiYWIyX3Bfd2F5NSI6MC4wLCJhYjJfcF93YXlfZGVsYXkiOjEuMCwiYWIyX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjJfd2F5MSI6MC4wLCJhYjJfd2F5MiI6MC4wLCJhYjJfd2F5MyI6MC4wLCJhYjJfd2F5NCI6MC4wLCJhYjJfd2F5NSI6MC4wLCJhYjJfd2F5X2RlbGF5IjoxLjAsImFiMl93YXlfc2VsZWN0IjoxLjAsImFiMl95YXdfbCI6MC4wLCJhYjJfeWF3X3IiOjAuMCwiYWIyX3lhd19zZW5zIjo1MC4wLCJhYjJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIzX2JvZHl5YXciOiJPZmYiLCJhYjNfZGVmX2FhIjpmYWxzZSwiYWIzX2RlZl9waXRjaCI6MC4wLCJhYjNfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIzX2RlZl90eXBlIjoiT24gUGVlayIsImFiM19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIzX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiM19kZWxheV90eXBlX21zIjoxLjAsImFiM19kZWxheV90eXBlX3QiOjEuMCwiYWIzX2ZyZWVzdGFuZCI6Ik9mZiIsImFiM19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIzX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIzX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjNfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIzX2xieV9sIjo2MC4wLCJhYjNfbGJ5X3IiOjYwLjAsImFiM19vcHRpb25zIjpbIn4iXSwiYWIzX3Bfd2F5MSI6MC4wLCJhYjNfcF93YXkyIjowLjAsImFiM19wX3dheTMiOjAuMCwiYWIzX3Bfd2F5NCI6MC4wLCJhYjNfcF93YXk1IjowLjAsImFiM19wX3dheV9kZWxheSI6MS4wLCJhYjNfcF93YXlfc2VsZWN0IjoxLjAsImFiM193YXkxIjowLjAsImFiM193YXkyIjowLjAsImFiM193YXkzIjowLjAsImFiM193YXk0IjowLjAsImFiM193YXk1IjowLjAsImFiM193YXlfZGVsYXkiOjEuMCwiYWIzX3dheV9zZWxlY3QiOjEuMCwiYWIzX3lhd19sIjowLjAsImFiM195YXdfciI6MC4wLCJhYjNfeWF3X3NlbnMiOjUwLjAsImFiM195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjRfYm9keXlhdyI6Ik9mZiIsImFiNF9kZWZfYWEiOmZhbHNlLCJhYjRfZGVmX3BpdGNoIjowLjAsImFiNF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjRfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI0X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjRfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI0X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI0X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjRfZnJlZXN0YW5kIjoiT2ZmIiwiYWI0X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjRfaml0dGVyX2NlbnRlciI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjRfbGJ5X2wiOjYwLjAsImFiNF9sYnlfciI6NjAuMCwiYWI0X29wdGlvbnMiOlsifiJdLCJhYjRfcF93YXkxIjowLjAsImFiNF9wX3dheTIiOjAuMCwiYWI0X3Bfd2F5MyI6MC4wLCJhYjRfcF93YXk0IjowLjAsImFiNF9wX3dheTUiOjAuMCwiYWI0X3Bfd2F5X2RlbGF5IjoxLjAsImFiNF9wX3dheV9zZWxlY3QiOjEuMCwiYWI0X3dheTEiOjAuMCwiYWI0X3dheTIiOjAuMCwiYWI0X3dheTMiOjAuMCwiYWI0X3dheTQiOjAuMCwiYWI0X3dheTUiOjAuMCwiYWI0X3dheV9kZWxheSI6MS4wLCJhYjRfd2F5X3NlbGVjdCI6MS4wLCJhYjRfeWF3X2wiOjAuMCwiYWI0X3lhd19yIjowLjAsImFiNF95YXdfc2VucyI6NTAuMCwiYWI0X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNV9ib2R5eWF3IjoiT2ZmIiwiYWI1X2RlZl9hYSI6ZmFsc2UsImFiNV9kZWZfcGl0Y2giOjAuMCwiYWI1X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjVfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjVfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjVfZGVsYXlfdHlwZV90IjoxLjAsImFiNV9mcmVlc3RhbmQiOiJPZmYiLCJhYjVfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNV9qaXR0ZXJfY2VudGVyIjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI1X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI1X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNV9sYnlfbCI6NjAuMCwiYWI1X2xieV9yIjo2MC4wLCJhYjVfb3B0aW9ucyI6WyJ+Il0sImFiNV9wX3dheTEiOjAuMCwiYWI1X3Bfd2F5MiI6MC4wLCJhYjVfcF93YXkzIjowLjAsImFiNV9wX3dheTQiOjAuMCwiYWI1X3Bfd2F5NSI6MC4wLCJhYjVfcF93YXlfZGVsYXkiOjEuMCwiYWI1X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjVfd2F5MSI6MC4wLCJhYjVfd2F5MiI6MC4wLCJhYjVfd2F5MyI6MC4wLCJhYjVfd2F5NCI6MC4wLCJhYjVfd2F5NSI6MC4wLCJhYjVfd2F5X2RlbGF5IjoxLjAsImFiNV93YXlfc2VsZWN0IjoxLjAsImFiNV95YXdfbCI6MC4wLCJhYjVfeWF3X3IiOjAuMCwiYWI1X3lhd19zZW5zIjo1MC4wLCJhYjVfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI2X2JvZHl5YXciOiJPZmYiLCJhYjZfZGVmX2FhIjpmYWxzZSwiYWI2X2RlZl9waXRjaCI6MC4wLCJhYjZfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI2X2RlZl90eXBlIjoiT24gUGVlayIsImFiNl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI2X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNl9kZWxheV90eXBlX21zIjoxLjAsImFiNl9kZWxheV90eXBlX3QiOjEuMCwiYWI2X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI2X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjZfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjZfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI2X2xieV9sIjo2MC4wLCJhYjZfbGJ5X3IiOjYwLjAsImFiNl9vcHRpb25zIjpbIn4iXSwiYWI2X3Bfd2F5MSI6MC4wLCJhYjZfcF93YXkyIjowLjAsImFiNl9wX3dheTMiOjAuMCwiYWI2X3Bfd2F5NCI6MC4wLCJhYjZfcF93YXk1IjowLjAsImFiNl9wX3dheV9kZWxheSI6MS4wLCJhYjZfcF93YXlfc2VsZWN0IjoxLjAsImFiNl93YXkxIjowLjAsImFiNl93YXkyIjowLjAsImFiNl93YXkzIjowLjAsImFiNl93YXk0IjowLjAsImFiNl93YXk1IjowLjAsImFiNl93YXlfZGVsYXkiOjEuMCwiYWI2X3dheV9zZWxlY3QiOjEuMCwiYWI2X3lhd19sIjowLjAsImFiNl95YXdfciI6MC4wLCJhYjZfeWF3X3NlbnMiOjUwLjAsImFiNl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjdfYm9keXlhdyI6Ik9mZiIsImFiN19kZWZfYWEiOmZhbHNlLCJhYjdfZGVmX3BpdGNoIjowLjAsImFiN19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjdfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI3X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjdfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI3X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI3X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjdfZnJlZXN0YW5kIjoiT2ZmIiwiYWI3X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjdfaml0dGVyX2NlbnRlciI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiN19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiN19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjdfbGJ5X2wiOjYwLjAsImFiN19sYnlfciI6NjAuMCwiYWI3X29wdGlvbnMiOlsifiJdLCJhYjdfcF93YXkxIjowLjAsImFiN19wX3dheTIiOjAuMCwiYWI3X3Bfd2F5MyI6MC4wLCJhYjdfcF93YXk0IjowLjAsImFiN19wX3dheTUiOjAuMCwiYWI3X3Bfd2F5X2RlbGF5IjoxLjAsImFiN19wX3dheV9zZWxlY3QiOjEuMCwiYWI3X3dheTEiOjAuMCwiYWI3X3dheTIiOjAuMCwiYWI3X3dheTMiOjAuMCwiYWI3X3dheTQiOjAuMCwiYWI3X3dheTUiOjAuMCwiYWI3X3dheV9kZWxheSI6MS4wLCJhYjdfd2F5X3NlbGVjdCI6MS4wLCJhYjdfeWF3X2wiOjAuMCwiYWI3X3lhd19yIjowLjAsImFiN195YXdfc2VucyI6NTAuMCwiYWI3X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOF9ib2R5eWF3IjoiT2ZmIiwiYWI4X2RlZl9hYSI6ZmFsc2UsImFiOF9kZWZfcGl0Y2giOjAuMCwiYWI4X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjhfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjhfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjhfZGVsYXlfdHlwZV90IjoxLjAsImFiOF9mcmVlc3RhbmQiOiJPZmYiLCJhYjhfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOF9qaXR0ZXJfY2VudGVyIjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI4X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI4X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOF9sYnlfbCI6NjAuMCwiYWI4X2xieV9yIjo2MC4wLCJhYjhfb3B0aW9ucyI6WyJ+Il0sImFiOF9wX3dheTEiOjAuMCwiYWI4X3Bfd2F5MiI6MC4wLCJhYjhfcF93YXkzIjowLjAsImFiOF9wX3dheTQiOjAuMCwiYWI4X3Bfd2F5NSI6MC4wLCJhYjhfcF93YXlfZGVsYXkiOjEuMCwiYWI4X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjhfd2F5MSI6MC4wLCJhYjhfd2F5MiI6MC4wLCJhYjhfd2F5MyI6MC4wLCJhYjhfd2F5NCI6MC4wLCJhYjhfd2F5NSI6MC4wLCJhYjhfd2F5X2RlbGF5IjoxLjAsImFiOF93YXlfc2VsZWN0IjoxLjAsImFiOF95YXdfbCI6MC4wLCJhYjhfeWF3X3IiOjAuMCwiYWI4X3lhd19zZW5zIjo1MC4wLCJhYjhfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI5X2JvZHl5YXciOiJPZmYiLCJhYjlfZGVmX2FhIjpmYWxzZSwiYWI5X2RlZl9waXRjaCI6MC4wLCJhYjlfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI5X2RlZl90eXBlIjoiT24gUGVlayIsImFiOV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI5X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiOV9kZWxheV90eXBlX21zIjoxLjAsImFiOV9kZWxheV90eXBlX3QiOjEuMCwiYWI5X2ZyZWVzdGFuZCI6Ik9mZiIsImFiOV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI5X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjlfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjlfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI5X2xieV9sIjo2MC4wLCJhYjlfbGJ5X3IiOjYwLjAsImFiOV9vcHRpb25zIjpbIn4iXSwiYWI5X3Bfd2F5MSI6MC4wLCJhYjlfcF93YXkyIjowLjAsImFiOV9wX3dheTMiOjAuMCwiYWI5X3Bfd2F5NCI6MC4wLCJhYjlfcF93YXk1IjowLjAsImFiOV9wX3dheV9kZWxheSI6MS4wLCJhYjlfcF93YXlfc2VsZWN0IjoxLjAsImFiOV93YXkxIjowLjAsImFiOV93YXkyIjowLjAsImFiOV93YXkzIjowLjAsImFiOV93YXk0IjowLjAsImFiOV93YXk1IjowLjAsImFiOV93YXlfZGVsYXkiOjEuMCwiYWI5X3dheV9zZWxlY3QiOjEuMCwiYWI5X3lhd19sIjowLjAsImFiOV95YXdfciI6MC4wLCJhYjlfeWF3X3NlbnMiOjUwLjAsImFiOV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9lbmFibGUiOnRydWUsImFiX3BoYXNlIjozLjAsImJvZHl5YXciOiJEZWZhdWx0IiwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiVGlja3MiLCJkZWxheV90eXBlX21zIjoxLjAsImRlbGF5X3R5cGVfdCI6My4wLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInBfd2F5MSI6MC4wLCJwX3dheTIiOjAuMCwicF93YXkzIjowLjAsInBfd2F5NCI6MC4wLCJwX3dheTUiOjAuMCwicF93YXlfZGVsYXkiOjEuMCwicF93YXlfc2VsZWN0IjoxLjAsIndheTEiOjAuMCwid2F5MiI6MC4wLCJ3YXkzIjowLjAsIndheTQiOjAuMCwid2F5NSI6MC4wLCJ3YXlfZGVsYXkiOjEuMCwid2F5X3NlbGVjdCI6MS4wLCJ5YXdfbCI6LTMwLjAsInlhd19yIjo0MC4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiMTBfYm9keXlhdyI6Ik9mZiIsImFiMTBfZGVmX2FhIjpmYWxzZSwiYWIxMF9kZWZfcGl0Y2giOjAuMCwiYWIxMF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjEwX2RlZl90eXBlIjoiT24gUGVlayIsImFiMTBfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMTBfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIxMF9kZWxheV90eXBlX21zIjoxLjAsImFiMTBfZGVsYXlfdHlwZV90IjoxLjAsImFiMTBfZnJlZXN0YW5kIjoiT2ZmIiwiYWIxMF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxMF9qaXR0ZXJfY2VudGVyIjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjEwX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMTBfbGJ5X2wiOjYwLjAsImFiMTBfbGJ5X3IiOjYwLjAsImFiMTBfb3B0aW9ucyI6WyJ+Il0sImFiMTBfcF93YXkxIjowLjAsImFiMTBfcF93YXkyIjowLjAsImFiMTBfcF93YXkzIjowLjAsImFiMTBfcF93YXk0IjowLjAsImFiMTBfcF93YXk1IjowLjAsImFiMTBfcF93YXlfZGVsYXkiOjEuMCwiYWIxMF9wX3dheV9zZWxlY3QiOjEuMCwiYWIxMF93YXkxIjowLjAsImFiMTBfd2F5MiI6MC4wLCJhYjEwX3dheTMiOjAuMCwiYWIxMF93YXk0IjowLjAsImFiMTBfd2F5NSI6MC4wLCJhYjEwX3dheV9kZWxheSI6MS4wLCJhYjEwX3dheV9zZWxlY3QiOjEuMCwiYWIxMF95YXdfbCI6MC4wLCJhYjEwX3lhd19yIjowLjAsImFiMTBfeWF3X3NlbnMiOjUwLjAsImFiMTBfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2JvZHl5YXciOiJPZmYiLCJhYjFfZGVmX2FhIjpmYWxzZSwiYWIxX2RlZl9waXRjaCI6MC4wLCJhYjFfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxX2RlZl90eXBlIjoiT24gUGVlayIsImFiMV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMV9kZWxheV90eXBlX21zIjoxLjAsImFiMV9kZWxheV90eXBlX3QiOjEuMCwiYWIxX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjFfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjFfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxX2xieV9sIjo2MC4wLCJhYjFfbGJ5X3IiOjYwLjAsImFiMV9vcHRpb25zIjpbIn4iXSwiYWIxX3Bfd2F5MSI6MC4wLCJhYjFfcF93YXkyIjowLjAsImFiMV9wX3dheTMiOjAuMCwiYWIxX3Bfd2F5NCI6MC4wLCJhYjFfcF93YXk1IjowLjAsImFiMV9wX3dheV9kZWxheSI6MS4wLCJhYjFfcF93YXlfc2VsZWN0IjoxLjAsImFiMV93YXkxIjowLjAsImFiMV93YXkyIjowLjAsImFiMV93YXkzIjowLjAsImFiMV93YXk0IjowLjAsImFiMV93YXk1IjowLjAsImFiMV93YXlfZGVsYXkiOjEuMCwiYWIxX3dheV9zZWxlY3QiOjEuMCwiYWIxX3lhd19sIjowLjAsImFiMV95YXdfciI6MC4wLCJhYjFfeWF3X3NlbnMiOjUwLjAsImFiMV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfYm9keXlhdyI6Ik9mZiIsImFiMl9kZWZfYWEiOmZhbHNlLCJhYjJfZGVmX3BpdGNoIjowLjAsImFiMl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIyX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIyX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIyX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjJfZnJlZXN0YW5kIjoiT2ZmIiwiYWIyX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjJfaml0dGVyX2NlbnRlciI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjJfbGJ5X2wiOjYwLjAsImFiMl9sYnlfciI6NjAuMCwiYWIyX29wdGlvbnMiOlsifiJdLCJhYjJfcF93YXkxIjowLjAsImFiMl9wX3dheTIiOjAuMCwiYWIyX3Bfd2F5MyI6MC4wLCJhYjJfcF93YXk0IjowLjAsImFiMl9wX3dheTUiOjAuMCwiYWIyX3Bfd2F5X2RlbGF5IjoxLjAsImFiMl9wX3dheV9zZWxlY3QiOjEuMCwiYWIyX3dheTEiOjAuMCwiYWIyX3dheTIiOjAuMCwiYWIyX3dheTMiOjAuMCwiYWIyX3dheTQiOjAuMCwiYWIyX3dheTUiOjAuMCwiYWIyX3dheV9kZWxheSI6MS4wLCJhYjJfd2F5X3NlbGVjdCI6MS4wLCJhYjJfeWF3X2wiOjAuMCwiYWIyX3lhd19yIjowLjAsImFiMl95YXdfc2VucyI6NTAuMCwiYWIyX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19ib2R5eWF3IjoiT2ZmIiwiYWIzX2RlZl9hYSI6ZmFsc2UsImFiM19kZWZfcGl0Y2giOjAuMCwiYWIzX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiM19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjNfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19kZWxheV90eXBlIjoiVGlja3MiLCJhYjNfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjNfZGVsYXlfdHlwZV90IjoxLjAsImFiM19mcmVlc3RhbmQiOiJPZmYiLCJhYjNfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiM19qaXR0ZXJfY2VudGVyIjowLjAsImFiM19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIzX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIzX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiM19sYnlfbCI6NjAuMCwiYWIzX2xieV9yIjo2MC4wLCJhYjNfb3B0aW9ucyI6WyJ+Il0sImFiM19wX3dheTEiOjAuMCwiYWIzX3Bfd2F5MiI6MC4wLCJhYjNfcF93YXkzIjowLjAsImFiM19wX3dheTQiOjAuMCwiYWIzX3Bfd2F5NSI6MC4wLCJhYjNfcF93YXlfZGVsYXkiOjEuMCwiYWIzX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjNfd2F5MSI6MC4wLCJhYjNfd2F5MiI6MC4wLCJhYjNfd2F5MyI6MC4wLCJhYjNfd2F5NCI6MC4wLCJhYjNfd2F5NSI6MC4wLCJhYjNfd2F5X2RlbGF5IjoxLjAsImFiM193YXlfc2VsZWN0IjoxLjAsImFiM195YXdfbCI6MC4wLCJhYjNfeWF3X3IiOjAuMCwiYWIzX3lhd19zZW5zIjo1MC4wLCJhYjNfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2JvZHl5YXciOiJPZmYiLCJhYjRfZGVmX2FhIjpmYWxzZSwiYWI0X2RlZl9waXRjaCI6MC4wLCJhYjRfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI0X2RlZl90eXBlIjoiT24gUGVlayIsImFiNF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNF9kZWxheV90eXBlX21zIjoxLjAsImFiNF9kZWxheV90eXBlX3QiOjEuMCwiYWI0X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI0X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjRfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI0X2xieV9sIjo2MC4wLCJhYjRfbGJ5X3IiOjYwLjAsImFiNF9vcHRpb25zIjpbIn4iXSwiYWI0X3Bfd2F5MSI6MC4wLCJhYjRfcF93YXkyIjowLjAsImFiNF9wX3dheTMiOjAuMCwiYWI0X3Bfd2F5NCI6MC4wLCJhYjRfcF93YXk1IjowLjAsImFiNF9wX3dheV9kZWxheSI6MS4wLCJhYjRfcF93YXlfc2VsZWN0IjoxLjAsImFiNF93YXkxIjowLjAsImFiNF93YXkyIjowLjAsImFiNF93YXkzIjowLjAsImFiNF93YXk0IjowLjAsImFiNF93YXk1IjowLjAsImFiNF93YXlfZGVsYXkiOjEuMCwiYWI0X3dheV9zZWxlY3QiOjEuMCwiYWI0X3lhd19sIjowLjAsImFiNF95YXdfciI6MC4wLCJhYjRfeWF3X3NlbnMiOjUwLjAsImFiNF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfYm9keXlhdyI6Ik9mZiIsImFiNV9kZWZfYWEiOmZhbHNlLCJhYjVfZGVmX3BpdGNoIjowLjAsImFiNV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjVfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI1X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI1X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI1X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjVfZnJlZXN0YW5kIjoiT2ZmIiwiYWI1X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjVfaml0dGVyX2NlbnRlciI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjVfbGJ5X2wiOjYwLjAsImFiNV9sYnlfciI6NjAuMCwiYWI1X29wdGlvbnMiOlsifiJdLCJhYjVfcF93YXkxIjowLjAsImFiNV9wX3dheTIiOjAuMCwiYWI1X3Bfd2F5MyI6MC4wLCJhYjVfcF93YXk0IjowLjAsImFiNV9wX3dheTUiOjAuMCwiYWI1X3Bfd2F5X2RlbGF5IjoxLjAsImFiNV9wX3dheV9zZWxlY3QiOjEuMCwiYWI1X3dheTEiOjAuMCwiYWI1X3dheTIiOjAuMCwiYWI1X3dheTMiOjAuMCwiYWI1X3dheTQiOjAuMCwiYWI1X3dheTUiOjAuMCwiYWI1X3dheV9kZWxheSI6MS4wLCJhYjVfd2F5X3NlbGVjdCI6MS4wLCJhYjVfeWF3X2wiOjAuMCwiYWI1X3lhd19yIjowLjAsImFiNV95YXdfc2VucyI6NTAuMCwiYWI1X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9ib2R5eWF3IjoiT2ZmIiwiYWI2X2RlZl9hYSI6ZmFsc2UsImFiNl9kZWZfcGl0Y2giOjAuMCwiYWI2X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjZfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjZfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjZfZGVsYXlfdHlwZV90IjoxLjAsImFiNl9mcmVlc3RhbmQiOiJPZmYiLCJhYjZfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNl9qaXR0ZXJfY2VudGVyIjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI2X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNl9sYnlfbCI6NjAuMCwiYWI2X2xieV9yIjo2MC4wLCJhYjZfb3B0aW9ucyI6WyJ+Il0sImFiNl9wX3dheTEiOjAuMCwiYWI2X3Bfd2F5MiI6MC4wLCJhYjZfcF93YXkzIjowLjAsImFiNl9wX3dheTQiOjAuMCwiYWI2X3Bfd2F5NSI6MC4wLCJhYjZfcF93YXlfZGVsYXkiOjEuMCwiYWI2X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjZfd2F5MSI6MC4wLCJhYjZfd2F5MiI6MC4wLCJhYjZfd2F5MyI6MC4wLCJhYjZfd2F5NCI6MC4wLCJhYjZfd2F5NSI6MC4wLCJhYjZfd2F5X2RlbGF5IjoxLjAsImFiNl93YXlfc2VsZWN0IjoxLjAsImFiNl95YXdfbCI6MC4wLCJhYjZfeWF3X3IiOjAuMCwiYWI2X3lhd19zZW5zIjo1MC4wLCJhYjZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2JvZHl5YXciOiJPZmYiLCJhYjdfZGVmX2FhIjpmYWxzZSwiYWI3X2RlZl9waXRjaCI6MC4wLCJhYjdfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI3X2RlZl90eXBlIjoiT24gUGVlayIsImFiN19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiN19kZWxheV90eXBlX21zIjoxLjAsImFiN19kZWxheV90eXBlX3QiOjEuMCwiYWI3X2ZyZWVzdGFuZCI6Ik9mZiIsImFiN19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI3X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjdfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI3X2xieV9sIjo2MC4wLCJhYjdfbGJ5X3IiOjYwLjAsImFiN19vcHRpb25zIjpbIn4iXSwiYWI3X3Bfd2F5MSI6MC4wLCJhYjdfcF93YXkyIjowLjAsImFiN19wX3dheTMiOjAuMCwiYWI3X3Bfd2F5NCI6MC4wLCJhYjdfcF93YXk1IjowLjAsImFiN19wX3dheV9kZWxheSI6MS4wLCJhYjdfcF93YXlfc2VsZWN0IjoxLjAsImFiN193YXkxIjowLjAsImFiN193YXkyIjowLjAsImFiN193YXkzIjowLjAsImFiN193YXk0IjowLjAsImFiN193YXk1IjowLjAsImFiN193YXlfZGVsYXkiOjEuMCwiYWI3X3dheV9zZWxlY3QiOjEuMCwiYWI3X3lhd19sIjowLjAsImFiN195YXdfciI6MC4wLCJhYjdfeWF3X3NlbnMiOjUwLjAsImFiN195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfYm9keXlhdyI6Ik9mZiIsImFiOF9kZWZfYWEiOmZhbHNlLCJhYjhfZGVmX3BpdGNoIjowLjAsImFiOF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjhfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI4X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI4X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI4X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjhfZnJlZXN0YW5kIjoiT2ZmIiwiYWI4X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjhfaml0dGVyX2NlbnRlciI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjhfbGJ5X2wiOjYwLjAsImFiOF9sYnlfciI6NjAuMCwiYWI4X29wdGlvbnMiOlsifiJdLCJhYjhfcF93YXkxIjowLjAsImFiOF9wX3dheTIiOjAuMCwiYWI4X3Bfd2F5MyI6MC4wLCJhYjhfcF93YXk0IjowLjAsImFiOF9wX3dheTUiOjAuMCwiYWI4X3Bfd2F5X2RlbGF5IjoxLjAsImFiOF9wX3dheV9zZWxlY3QiOjEuMCwiYWI4X3dheTEiOjAuMCwiYWI4X3dheTIiOjAuMCwiYWI4X3dheTMiOjAuMCwiYWI4X3dheTQiOjAuMCwiYWI4X3dheTUiOjAuMCwiYWI4X3dheV9kZWxheSI6MS4wLCJhYjhfd2F5X3NlbGVjdCI6MS4wLCJhYjhfeWF3X2wiOjAuMCwiYWI4X3lhd19yIjowLjAsImFiOF95YXdfc2VucyI6NTAuMCwiYWI4X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9ib2R5eWF3IjoiT2ZmIiwiYWI5X2RlZl9hYSI6ZmFsc2UsImFiOV9kZWZfcGl0Y2giOjAuMCwiYWI5X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjlfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjlfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjlfZGVsYXlfdHlwZV90IjoxLjAsImFiOV9mcmVlc3RhbmQiOiJPZmYiLCJhYjlfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOV9qaXR0ZXJfY2VudGVyIjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI5X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOV9sYnlfbCI6NjAuMCwiYWI5X2xieV9yIjo2MC4wLCJhYjlfb3B0aW9ucyI6WyJ+Il0sImFiOV9wX3dheTEiOjAuMCwiYWI5X3Bfd2F5MiI6MC4wLCJhYjlfcF93YXkzIjowLjAsImFiOV9wX3dheTQiOjAuMCwiYWI5X3Bfd2F5NSI6MC4wLCJhYjlfcF93YXlfZGVsYXkiOjEuMCwiYWI5X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjlfd2F5MSI6MC4wLCJhYjlfd2F5MiI6MC4wLCJhYjlfd2F5MyI6MC4wLCJhYjlfd2F5NCI6MC4wLCJhYjlfd2F5NSI6MC4wLCJhYjlfd2F5X2RlbGF5IjoxLjAsImFiOV93YXlfc2VsZWN0IjoxLjAsImFiOV95YXdfbCI6MC4wLCJhYjlfeWF3X3IiOjAuMCwiYWI5X3lhd19zZW5zIjo1MC4wLCJhYjlfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfcGhhc2UiOjEuMCwiYm9keXlhdyI6IkRlZmF1bHQiLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IlRpY2tzIiwiZGVsYXlfdHlwZV9tcyI6MS4wLCJkZWxheV90eXBlX3QiOjEuMCwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkNlbnRlciIsImppdHRlcl9jZW50ZXIiOi01MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJwX3dheTEiOjAuMCwicF93YXkyIjowLjAsInBfd2F5MyI6MC4wLCJwX3dheTQiOjAuMCwicF93YXk1IjowLjAsInBfd2F5X2RlbGF5IjoxLjAsInBfd2F5X3NlbGVjdCI6MS4wLCJ3YXkxIjowLjAsIndheTIiOjAuMCwid2F5MyI6MC4wLCJ3YXk0IjowLjAsIndheTUiOjAuMCwid2F5X2RlbGF5IjoxLjAsIndheV9zZWxlY3QiOjEuMCwieWF3X2wiOjAuMCwieWF3X3IiOjEwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiMTBfYm9keXlhdyI6Ik9mZiIsImFiMTBfZGVmX2FhIjpmYWxzZSwiYWIxMF9kZWZfcGl0Y2giOjAuMCwiYWIxMF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjEwX2RlZl90eXBlIjoiT24gUGVlayIsImFiMTBfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMTBfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIxMF9kZWxheV90eXBlX21zIjoxLjAsImFiMTBfZGVsYXlfdHlwZV90IjoxLjAsImFiMTBfZnJlZXN0YW5kIjoiT2ZmIiwiYWIxMF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxMF9qaXR0ZXJfY2VudGVyIjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMTBfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjEwX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMTBfbGJ5X2wiOjYwLjAsImFiMTBfbGJ5X3IiOjYwLjAsImFiMTBfb3B0aW9ucyI6WyJ+Il0sImFiMTBfcF93YXkxIjowLjAsImFiMTBfcF93YXkyIjowLjAsImFiMTBfcF93YXkzIjowLjAsImFiMTBfcF93YXk0IjowLjAsImFiMTBfcF93YXk1IjowLjAsImFiMTBfcF93YXlfZGVsYXkiOjEuMCwiYWIxMF9wX3dheV9zZWxlY3QiOjEuMCwiYWIxMF93YXkxIjowLjAsImFiMTBfd2F5MiI6MC4wLCJhYjEwX3dheTMiOjAuMCwiYWIxMF93YXk0IjowLjAsImFiMTBfd2F5NSI6MC4wLCJhYjEwX3dheV9kZWxheSI6MS4wLCJhYjEwX3dheV9zZWxlY3QiOjEuMCwiYWIxMF95YXdfbCI6MC4wLCJhYjEwX3lhd19yIjowLjAsImFiMTBfeWF3X3NlbnMiOjUwLjAsImFiMTBfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2JvZHl5YXciOiJPZmYiLCJhYjFfZGVmX2FhIjpmYWxzZSwiYWIxX2RlZl9waXRjaCI6MC4wLCJhYjFfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxX2RlZl90eXBlIjoiT24gUGVlayIsImFiMV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMV9kZWxheV90eXBlX21zIjoxLjAsImFiMV9kZWxheV90eXBlX3QiOjEuMCwiYWIxX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjFfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjFfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxX2xieV9sIjo2MC4wLCJhYjFfbGJ5X3IiOjYwLjAsImFiMV9vcHRpb25zIjpbIn4iXSwiYWIxX3Bfd2F5MSI6MC4wLCJhYjFfcF93YXkyIjowLjAsImFiMV9wX3dheTMiOjAuMCwiYWIxX3Bfd2F5NCI6MC4wLCJhYjFfcF93YXk1IjowLjAsImFiMV9wX3dheV9kZWxheSI6MS4wLCJhYjFfcF93YXlfc2VsZWN0IjoxLjAsImFiMV93YXkxIjowLjAsImFiMV93YXkyIjowLjAsImFiMV93YXkzIjowLjAsImFiMV93YXk0IjowLjAsImFiMV93YXk1IjowLjAsImFiMV93YXlfZGVsYXkiOjEuMCwiYWIxX3dheV9zZWxlY3QiOjEuMCwiYWIxX3lhd19sIjowLjAsImFiMV95YXdfciI6MC4wLCJhYjFfeWF3X3NlbnMiOjUwLjAsImFiMV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfYm9keXlhdyI6Ik9mZiIsImFiMl9kZWZfYWEiOmZhbHNlLCJhYjJfZGVmX3BpdGNoIjowLjAsImFiMl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIyX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIyX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIyX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjJfZnJlZXN0YW5kIjoiT2ZmIiwiYWIyX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjJfaml0dGVyX2NlbnRlciI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjJfbGJ5X2wiOjYwLjAsImFiMl9sYnlfciI6NjAuMCwiYWIyX29wdGlvbnMiOlsifiJdLCJhYjJfcF93YXkxIjowLjAsImFiMl9wX3dheTIiOjAuMCwiYWIyX3Bfd2F5MyI6MC4wLCJhYjJfcF93YXk0IjowLjAsImFiMl9wX3dheTUiOjAuMCwiYWIyX3Bfd2F5X2RlbGF5IjoxLjAsImFiMl9wX3dheV9zZWxlY3QiOjEuMCwiYWIyX3dheTEiOjAuMCwiYWIyX3dheTIiOjAuMCwiYWIyX3dheTMiOjAuMCwiYWIyX3dheTQiOjAuMCwiYWIyX3dheTUiOjAuMCwiYWIyX3dheV9kZWxheSI6MS4wLCJhYjJfd2F5X3NlbGVjdCI6MS4wLCJhYjJfeWF3X2wiOjAuMCwiYWIyX3lhd19yIjowLjAsImFiMl95YXdfc2VucyI6NTAuMCwiYWIyX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19ib2R5eWF3IjoiT2ZmIiwiYWIzX2RlZl9hYSI6ZmFsc2UsImFiM19kZWZfcGl0Y2giOjAuMCwiYWIzX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiM19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjNfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19kZWxheV90eXBlIjoiVGlja3MiLCJhYjNfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjNfZGVsYXlfdHlwZV90IjoxLjAsImFiM19mcmVlc3RhbmQiOiJPZmYiLCJhYjNfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiM19qaXR0ZXJfY2VudGVyIjowLjAsImFiM19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIzX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIzX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiM19sYnlfbCI6NjAuMCwiYWIzX2xieV9yIjo2MC4wLCJhYjNfb3B0aW9ucyI6WyJ+Il0sImFiM19wX3dheTEiOjAuMCwiYWIzX3Bfd2F5MiI6MC4wLCJhYjNfcF93YXkzIjowLjAsImFiM19wX3dheTQiOjAuMCwiYWIzX3Bfd2F5NSI6MC4wLCJhYjNfcF93YXlfZGVsYXkiOjEuMCwiYWIzX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjNfd2F5MSI6MC4wLCJhYjNfd2F5MiI6MC4wLCJhYjNfd2F5MyI6MC4wLCJhYjNfd2F5NCI6MC4wLCJhYjNfd2F5NSI6MC4wLCJhYjNfd2F5X2RlbGF5IjoxLjAsImFiM193YXlfc2VsZWN0IjoxLjAsImFiM195YXdfbCI6MC4wLCJhYjNfeWF3X3IiOjAuMCwiYWIzX3lhd19zZW5zIjo1MC4wLCJhYjNfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2JvZHl5YXciOiJPZmYiLCJhYjRfZGVmX2FhIjpmYWxzZSwiYWI0X2RlZl9waXRjaCI6MC4wLCJhYjRfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI0X2RlZl90eXBlIjoiT24gUGVlayIsImFiNF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI0X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNF9kZWxheV90eXBlX21zIjoxLjAsImFiNF9kZWxheV90eXBlX3QiOjEuMCwiYWI0X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI0X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjRfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjRfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI0X2xieV9sIjo2MC4wLCJhYjRfbGJ5X3IiOjYwLjAsImFiNF9vcHRpb25zIjpbIn4iXSwiYWI0X3Bfd2F5MSI6MC4wLCJhYjRfcF93YXkyIjowLjAsImFiNF9wX3dheTMiOjAuMCwiYWI0X3Bfd2F5NCI6MC4wLCJhYjRfcF93YXk1IjowLjAsImFiNF9wX3dheV9kZWxheSI6MS4wLCJhYjRfcF93YXlfc2VsZWN0IjoxLjAsImFiNF93YXkxIjowLjAsImFiNF93YXkyIjowLjAsImFiNF93YXkzIjowLjAsImFiNF93YXk0IjowLjAsImFiNF93YXk1IjowLjAsImFiNF93YXlfZGVsYXkiOjEuMCwiYWI0X3dheV9zZWxlY3QiOjEuMCwiYWI0X3lhd19sIjowLjAsImFiNF95YXdfciI6MC4wLCJhYjRfeWF3X3NlbnMiOjUwLjAsImFiNF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfYm9keXlhdyI6Ik9mZiIsImFiNV9kZWZfYWEiOmZhbHNlLCJhYjVfZGVmX3BpdGNoIjowLjAsImFiNV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjVfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI1X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjVfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI1X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI1X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjVfZnJlZXN0YW5kIjoiT2ZmIiwiYWI1X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjVfaml0dGVyX2NlbnRlciI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjVfbGJ5X2wiOjYwLjAsImFiNV9sYnlfciI6NjAuMCwiYWI1X29wdGlvbnMiOlsifiJdLCJhYjVfcF93YXkxIjowLjAsImFiNV9wX3dheTIiOjAuMCwiYWI1X3Bfd2F5MyI6MC4wLCJhYjVfcF93YXk0IjowLjAsImFiNV9wX3dheTUiOjAuMCwiYWI1X3Bfd2F5X2RlbGF5IjoxLjAsImFiNV9wX3dheV9zZWxlY3QiOjEuMCwiYWI1X3dheTEiOjAuMCwiYWI1X3dheTIiOjAuMCwiYWI1X3dheTMiOjAuMCwiYWI1X3dheTQiOjAuMCwiYWI1X3dheTUiOjAuMCwiYWI1X3dheV9kZWxheSI6MS4wLCJhYjVfd2F5X3NlbGVjdCI6MS4wLCJhYjVfeWF3X2wiOjAuMCwiYWI1X3lhd19yIjowLjAsImFiNV95YXdfc2VucyI6NTAuMCwiYWI1X3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9ib2R5eWF3IjoiT2ZmIiwiYWI2X2RlZl9hYSI6ZmFsc2UsImFiNl9kZWZfcGl0Y2giOjAuMCwiYWI2X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjZfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNl9kZWxheV90eXBlIjoiVGlja3MiLCJhYjZfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjZfZGVsYXlfdHlwZV90IjoxLjAsImFiNl9mcmVlc3RhbmQiOiJPZmYiLCJhYjZfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNl9qaXR0ZXJfY2VudGVyIjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI2X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI2X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNl9sYnlfbCI6NjAuMCwiYWI2X2xieV9yIjo2MC4wLCJhYjZfb3B0aW9ucyI6WyJ+Il0sImFiNl9wX3dheTEiOjAuMCwiYWI2X3Bfd2F5MiI6MC4wLCJhYjZfcF93YXkzIjowLjAsImFiNl9wX3dheTQiOjAuMCwiYWI2X3Bfd2F5NSI6MC4wLCJhYjZfcF93YXlfZGVsYXkiOjEuMCwiYWI2X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjZfd2F5MSI6MC4wLCJhYjZfd2F5MiI6MC4wLCJhYjZfd2F5MyI6MC4wLCJhYjZfd2F5NCI6MC4wLCJhYjZfd2F5NSI6MC4wLCJhYjZfd2F5X2RlbGF5IjoxLjAsImFiNl93YXlfc2VsZWN0IjoxLjAsImFiNl95YXdfbCI6MC4wLCJhYjZfeWF3X3IiOjAuMCwiYWI2X3lhd19zZW5zIjo1MC4wLCJhYjZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2JvZHl5YXciOiJPZmYiLCJhYjdfZGVmX2FhIjpmYWxzZSwiYWI3X2RlZl9waXRjaCI6MC4wLCJhYjdfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI3X2RlZl90eXBlIjoiT24gUGVlayIsImFiN19kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI3X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiN19kZWxheV90eXBlX21zIjoxLjAsImFiN19kZWxheV90eXBlX3QiOjEuMCwiYWI3X2ZyZWVzdGFuZCI6Ik9mZiIsImFiN19qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI3X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjdfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjdfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI3X2xieV9sIjo2MC4wLCJhYjdfbGJ5X3IiOjYwLjAsImFiN19vcHRpb25zIjpbIn4iXSwiYWI3X3Bfd2F5MSI6MC4wLCJhYjdfcF93YXkyIjowLjAsImFiN19wX3dheTMiOjAuMCwiYWI3X3Bfd2F5NCI6MC4wLCJhYjdfcF93YXk1IjowLjAsImFiN19wX3dheV9kZWxheSI6MS4wLCJhYjdfcF93YXlfc2VsZWN0IjoxLjAsImFiN193YXkxIjowLjAsImFiN193YXkyIjowLjAsImFiN193YXkzIjowLjAsImFiN193YXk0IjowLjAsImFiN193YXk1IjowLjAsImFiN193YXlfZGVsYXkiOjEuMCwiYWI3X3dheV9zZWxlY3QiOjEuMCwiYWI3X3lhd19sIjowLjAsImFiN195YXdfciI6MC4wLCJhYjdfeWF3X3NlbnMiOjUwLjAsImFiN195YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfYm9keXlhdyI6Ik9mZiIsImFiOF9kZWZfYWEiOmZhbHNlLCJhYjhfZGVmX3BpdGNoIjowLjAsImFiOF9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjhfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI4X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjhfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI4X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI4X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjhfZnJlZXN0YW5kIjoiT2ZmIiwiYWI4X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjhfaml0dGVyX2NlbnRlciI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjhfbGJ5X2wiOjYwLjAsImFiOF9sYnlfciI6NjAuMCwiYWI4X29wdGlvbnMiOlsifiJdLCJhYjhfcF93YXkxIjowLjAsImFiOF9wX3dheTIiOjAuMCwiYWI4X3Bfd2F5MyI6MC4wLCJhYjhfcF93YXk0IjowLjAsImFiOF9wX3dheTUiOjAuMCwiYWI4X3Bfd2F5X2RlbGF5IjoxLjAsImFiOF9wX3dheV9zZWxlY3QiOjEuMCwiYWI4X3dheTEiOjAuMCwiYWI4X3dheTIiOjAuMCwiYWI4X3dheTMiOjAuMCwiYWI4X3dheTQiOjAuMCwiYWI4X3dheTUiOjAuMCwiYWI4X3dheV9kZWxheSI6MS4wLCJhYjhfd2F5X3NlbGVjdCI6MS4wLCJhYjhfeWF3X2wiOjAuMCwiYWI4X3lhd19yIjowLjAsImFiOF95YXdfc2VucyI6NTAuMCwiYWI4X3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9ib2R5eWF3IjoiT2ZmIiwiYWI5X2RlZl9hYSI6ZmFsc2UsImFiOV9kZWZfcGl0Y2giOjAuMCwiYWI5X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiOV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjlfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiOV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjlfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjlfZGVsYXlfdHlwZV90IjoxLjAsImFiOV9mcmVlc3RhbmQiOiJPZmYiLCJhYjlfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiOV9qaXR0ZXJfY2VudGVyIjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI5X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI5X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiOV9sYnlfbCI6NjAuMCwiYWI5X2xieV9yIjo2MC4wLCJhYjlfb3B0aW9ucyI6WyJ+Il0sImFiOV9wX3dheTEiOjAuMCwiYWI5X3Bfd2F5MiI6MC4wLCJhYjlfcF93YXkzIjowLjAsImFiOV9wX3dheTQiOjAuMCwiYWI5X3Bfd2F5NSI6MC4wLCJhYjlfcF93YXlfZGVsYXkiOjEuMCwiYWI5X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjlfd2F5MSI6MC4wLCJhYjlfd2F5MiI6MC4wLCJhYjlfd2F5MyI6MC4wLCJhYjlfd2F5NCI6MC4wLCJhYjlfd2F5NSI6MC4wLCJhYjlfd2F5X2RlbGF5IjoxLjAsImFiOV93YXlfc2VsZWN0IjoxLjAsImFiOV95YXdfbCI6MC4wLCJhYjlfeWF3X3IiOjAuMCwiYWI5X3lhd19zZW5zIjo1MC4wLCJhYjlfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfcGhhc2UiOjEuMCwiYm9keXlhdyI6IkRlZmF1bHQiLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IlRpY2tzIiwiZGVsYXlfdHlwZV9tcyI6MS4wLCJkZWxheV90eXBlX3QiOjEuMCwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJwX3dheTEiOjAuMCwicF93YXkyIjowLjAsInBfd2F5MyI6MC4wLCJwX3dheTQiOjAuMCwicF93YXk1IjowLjAsInBfd2F5X2RlbGF5IjoxLjAsInBfd2F5X3NlbGVjdCI6MS4wLCJ3YXkxIjowLjAsIndheTIiOjAuMCwid2F5MyI6MC4wLCJ3YXk0IjowLjAsIndheTUiOjAuMCwid2F5X2RlbGF5IjoxLjAsIndheV9zZWxlY3QiOjEuMCwieWF3X2wiOi0zMC4wLCJ5YXdfciI6MzAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWIxMF9ib2R5eWF3IjoiT2ZmIiwiYWIxMF9kZWZfYWEiOmZhbHNlLCJhYjEwX2RlZl9waXRjaCI6MC4wLCJhYjEwX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMTBfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIxMF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxMF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjEwX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIxMF9kZWxheV90eXBlX3QiOjEuMCwiYWIxMF9mcmVlc3RhbmQiOiJPZmYiLCJhYjEwX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjEwX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxMF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxMF9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMTBfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxMF9sYnlfbCI6NjAuMCwiYWIxMF9sYnlfciI6NjAuMCwiYWIxMF9vcHRpb25zIjpbIn4iXSwiYWIxMF9wX3dheTEiOjAuMCwiYWIxMF9wX3dheTIiOjAuMCwiYWIxMF9wX3dheTMiOjAuMCwiYWIxMF9wX3dheTQiOjAuMCwiYWIxMF9wX3dheTUiOjAuMCwiYWIxMF9wX3dheV9kZWxheSI6MS4wLCJhYjEwX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjEwX3dheTEiOjAuMCwiYWIxMF93YXkyIjowLjAsImFiMTBfd2F5MyI6MC4wLCJhYjEwX3dheTQiOjAuMCwiYWIxMF93YXk1IjowLjAsImFiMTBfd2F5X2RlbGF5IjoxLjAsImFiMTBfd2F5X3NlbGVjdCI6MS4wLCJhYjEwX3lhd19sIjowLjAsImFiMTBfeWF3X3IiOjAuMCwiYWIxMF95YXdfc2VucyI6NTAuMCwiYWIxMF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjFfYm9keXlhdyI6IkRlZmF1bHQiLCJhYjFfZGVmX2FhIjpmYWxzZSwiYWIxX2RlZl9waXRjaCI6MC4wLCJhYjFfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxX2RlZl90eXBlIjoiT24gUGVlayIsImFiMV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIxX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMV9kZWxheV90eXBlX21zIjoxLjAsImFiMV9kZWxheV90eXBlX3QiOjEuMCwiYWIxX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIxX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjFfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjFfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIxX2xieV9sIjo2MC4wLCJhYjFfbGJ5X3IiOjYwLjAsImFiMV9vcHRpb25zIjpbIn4iXSwiYWIxX3Bfd2F5MSI6MC4wLCJhYjFfcF93YXkyIjowLjAsImFiMV9wX3dheTMiOjAuMCwiYWIxX3Bfd2F5NCI6MC4wLCJhYjFfcF93YXk1IjowLjAsImFiMV9wX3dheV9kZWxheSI6MS4wLCJhYjFfcF93YXlfc2VsZWN0IjoxLjAsImFiMV93YXkxIjowLjAsImFiMV93YXkyIjowLjAsImFiMV93YXkzIjowLjAsImFiMV93YXk0IjowLjAsImFiMV93YXk1IjowLjAsImFiMV93YXlfZGVsYXkiOjEuMCwiYWIxX3dheV9zZWxlY3QiOjEuMCwiYWIxX3lhd19sIjotMTcuMCwiYWIxX3lhd19yIjo0Ny4wLCJhYjFfeWF3X3NlbnMiOjUwLjAsImFiMV95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImFiMl9ib2R5eWF3IjoiRGVmYXVsdCIsImFiMl9kZWZfYWEiOmZhbHNlLCJhYjJfZGVmX3BpdGNoIjowLjAsImFiMl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIyX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjJfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIyX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIyX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjJfZnJlZXN0YW5kIjoiT2ZmIiwiYWIyX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjJfaml0dGVyX2NlbnRlciI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiMl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiMl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjJfbGJ5X2wiOjYwLjAsImFiMl9sYnlfciI6NjAuMCwiYWIyX29wdGlvbnMiOlsifiJdLCJhYjJfcF93YXkxIjowLjAsImFiMl9wX3dheTIiOjAuMCwiYWIyX3Bfd2F5MyI6MC4wLCJhYjJfcF93YXk0IjowLjAsImFiMl9wX3dheTUiOjAuMCwiYWIyX3Bfd2F5X2RlbGF5IjoxLjAsImFiMl9wX3dheV9zZWxlY3QiOjEuMCwiYWIyX3dheTEiOjAuMCwiYWIyX3dheTIiOjAuMCwiYWIyX3dheTMiOjAuMCwiYWIyX3dheTQiOjAuMCwiYWIyX3dheTUiOjAuMCwiYWIyX3dheV9kZWxheSI6MS4wLCJhYjJfd2F5X3NlbGVjdCI6MS4wLCJhYjJfeWF3X2wiOi0yMC4wLCJhYjJfeWF3X3IiOjUwLjAsImFiMl95YXdfc2VucyI6NTAuMCwiYWIyX3lhd190eXBlIjoiRGVmYXVsdCIsImFiM19ib2R5eWF3IjoiRGVmYXVsdCIsImFiM19kZWZfYWEiOmZhbHNlLCJhYjNfZGVmX3BpdGNoIjowLjAsImFiM19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjNfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIzX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIzX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIzX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjNfZnJlZXN0YW5kIjoiT2ZmIiwiYWIzX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjNfaml0dGVyX2NlbnRlciI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiM19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiM19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjNfbGJ5X2wiOjYwLjAsImFiM19sYnlfciI6NjAuMCwiYWIzX29wdGlvbnMiOlsifiJdLCJhYjNfcF93YXkxIjowLjAsImFiM19wX3dheTIiOjAuMCwiYWIzX3Bfd2F5MyI6MC4wLCJhYjNfcF93YXk0IjowLjAsImFiM19wX3dheTUiOjAuMCwiYWIzX3Bfd2F5X2RlbGF5IjoxLjAsImFiM19wX3dheV9zZWxlY3QiOjEuMCwiYWIzX3dheTEiOjAuMCwiYWIzX3dheTIiOjAuMCwiYWIzX3dheTMiOjAuMCwiYWIzX3dheTQiOjAuMCwiYWIzX3dheTUiOjAuMCwiYWIzX3dheV9kZWxheSI6MS4wLCJhYjNfd2F5X3NlbGVjdCI6MS4wLCJhYjNfeWF3X2wiOi0xNy4wLCJhYjNfeWF3X3IiOjQ3LjAsImFiM195YXdfc2VucyI6NTAuMCwiYWIzX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9ib2R5eWF3IjoiT2ZmIiwiYWI0X2RlZl9hYSI6ZmFsc2UsImFiNF9kZWZfcGl0Y2giOjAuMCwiYWI0X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjRfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjRfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjRfZGVsYXlfdHlwZV90IjoxLjAsImFiNF9mcmVlc3RhbmQiOiJPZmYiLCJhYjRfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNF9qaXR0ZXJfY2VudGVyIjowLjAsImFiNF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI0X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNF9sYnlfbCI6NjAuMCwiYWI0X2xieV9yIjo2MC4wLCJhYjRfb3B0aW9ucyI6WyJ+Il0sImFiNF9wX3dheTEiOjAuMCwiYWI0X3Bfd2F5MiI6MC4wLCJhYjRfcF93YXkzIjowLjAsImFiNF9wX3dheTQiOjAuMCwiYWI0X3Bfd2F5NSI6MC4wLCJhYjRfcF93YXlfZGVsYXkiOjEuMCwiYWI0X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjRfd2F5MSI6MC4wLCJhYjRfd2F5MiI6MC4wLCJhYjRfd2F5MyI6MC4wLCJhYjRfd2F5NCI6MC4wLCJhYjRfd2F5NSI6MC4wLCJhYjRfd2F5X2RlbGF5IjoxLjAsImFiNF93YXlfc2VsZWN0IjoxLjAsImFiNF95YXdfbCI6MC4wLCJhYjRfeWF3X3IiOjAuMCwiYWI0X3lhd19zZW5zIjo1MC4wLCJhYjRfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2JvZHl5YXciOiJPZmYiLCJhYjVfZGVmX2FhIjpmYWxzZSwiYWI1X2RlZl9waXRjaCI6MC4wLCJhYjVfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI1X2RlZl90eXBlIjoiT24gUGVlayIsImFiNV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNV9kZWxheV90eXBlX21zIjoxLjAsImFiNV9kZWxheV90eXBlX3QiOjEuMCwiYWI1X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI1X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI1X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjVfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI1X2xieV9sIjo2MC4wLCJhYjVfbGJ5X3IiOjYwLjAsImFiNV9vcHRpb25zIjpbIn4iXSwiYWI1X3Bfd2F5MSI6MC4wLCJhYjVfcF93YXkyIjowLjAsImFiNV9wX3dheTMiOjAuMCwiYWI1X3Bfd2F5NCI6MC4wLCJhYjVfcF93YXk1IjowLjAsImFiNV9wX3dheV9kZWxheSI6MS4wLCJhYjVfcF93YXlfc2VsZWN0IjoxLjAsImFiNV93YXkxIjowLjAsImFiNV93YXkyIjowLjAsImFiNV93YXkzIjowLjAsImFiNV93YXk0IjowLjAsImFiNV93YXk1IjowLjAsImFiNV93YXlfZGVsYXkiOjEuMCwiYWI1X3dheV9zZWxlY3QiOjEuMCwiYWI1X3lhd19sIjowLjAsImFiNV95YXdfciI6MC4wLCJhYjVfeWF3X3NlbnMiOjUwLjAsImFiNV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfYm9keXlhdyI6Ik9mZiIsImFiNl9kZWZfYWEiOmZhbHNlLCJhYjZfZGVmX3BpdGNoIjowLjAsImFiNl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjZfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI2X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI2X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI2X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjZfZnJlZXN0YW5kIjoiT2ZmIiwiYWI2X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjZfaml0dGVyX2NlbnRlciI6MC4wLCJhYjZfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjZfbGJ5X2wiOjYwLjAsImFiNl9sYnlfciI6NjAuMCwiYWI2X29wdGlvbnMiOlsifiJdLCJhYjZfcF93YXkxIjowLjAsImFiNl9wX3dheTIiOjAuMCwiYWI2X3Bfd2F5MyI6MC4wLCJhYjZfcF93YXk0IjowLjAsImFiNl9wX3dheTUiOjAuMCwiYWI2X3Bfd2F5X2RlbGF5IjoxLjAsImFiNl9wX3dheV9zZWxlY3QiOjEuMCwiYWI2X3dheTEiOjAuMCwiYWI2X3dheTIiOjAuMCwiYWI2X3dheTMiOjAuMCwiYWI2X3dheTQiOjAuMCwiYWI2X3dheTUiOjAuMCwiYWI2X3dheV9kZWxheSI6MS4wLCJhYjZfd2F5X3NlbGVjdCI6MS4wLCJhYjZfeWF3X2wiOjAuMCwiYWI2X3lhd19yIjowLjAsImFiNl95YXdfc2VucyI6NTAuMCwiYWI2X3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19ib2R5eWF3IjoiT2ZmIiwiYWI3X2RlZl9hYSI6ZmFsc2UsImFiN19kZWZfcGl0Y2giOjAuMCwiYWI3X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiN19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjdfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19kZWxheV90eXBlIjoiVGlja3MiLCJhYjdfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjdfZGVsYXlfdHlwZV90IjoxLjAsImFiN19mcmVlc3RhbmQiOiJPZmYiLCJhYjdfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiN19qaXR0ZXJfY2VudGVyIjowLjAsImFiN19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI3X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiN19sYnlfbCI6NjAuMCwiYWI3X2xieV9yIjo2MC4wLCJhYjdfb3B0aW9ucyI6WyJ+Il0sImFiN19wX3dheTEiOjAuMCwiYWI3X3Bfd2F5MiI6MC4wLCJhYjdfcF93YXkzIjowLjAsImFiN19wX3dheTQiOjAuMCwiYWI3X3Bfd2F5NSI6MC4wLCJhYjdfcF93YXlfZGVsYXkiOjEuMCwiYWI3X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjdfd2F5MSI6MC4wLCJhYjdfd2F5MiI6MC4wLCJhYjdfd2F5MyI6MC4wLCJhYjdfd2F5NCI6MC4wLCJhYjdfd2F5NSI6MC4wLCJhYjdfd2F5X2RlbGF5IjoxLjAsImFiN193YXlfc2VsZWN0IjoxLjAsImFiN195YXdfbCI6MC4wLCJhYjdfeWF3X3IiOjAuMCwiYWI3X3lhd19zZW5zIjo1MC4wLCJhYjdfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2JvZHl5YXciOiJPZmYiLCJhYjhfZGVmX2FhIjpmYWxzZSwiYWI4X2RlZl9waXRjaCI6MC4wLCJhYjhfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI4X2RlZl90eXBlIjoiT24gUGVlayIsImFiOF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiOF9kZWxheV90eXBlX21zIjoxLjAsImFiOF9kZWxheV90eXBlX3QiOjEuMCwiYWI4X2ZyZWVzdGFuZCI6Ik9mZiIsImFiOF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI4X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI4X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjhfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI4X2xieV9sIjo2MC4wLCJhYjhfbGJ5X3IiOjYwLjAsImFiOF9vcHRpb25zIjpbIn4iXSwiYWI4X3Bfd2F5MSI6MC4wLCJhYjhfcF93YXkyIjowLjAsImFiOF9wX3dheTMiOjAuMCwiYWI4X3Bfd2F5NCI6MC4wLCJhYjhfcF93YXk1IjowLjAsImFiOF9wX3dheV9kZWxheSI6MS4wLCJhYjhfcF93YXlfc2VsZWN0IjoxLjAsImFiOF93YXkxIjowLjAsImFiOF93YXkyIjowLjAsImFiOF93YXkzIjowLjAsImFiOF93YXk0IjowLjAsImFiOF93YXk1IjowLjAsImFiOF93YXlfZGVsYXkiOjEuMCwiYWI4X3dheV9zZWxlY3QiOjEuMCwiYWI4X3lhd19sIjowLjAsImFiOF95YXdfciI6MC4wLCJhYjhfeWF3X3NlbnMiOjUwLjAsImFiOF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfYm9keXlhdyI6Ik9mZiIsImFiOV9kZWZfYWEiOmZhbHNlLCJhYjlfZGVmX3BpdGNoIjowLjAsImFiOV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjlfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI5X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI5X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI5X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjlfZnJlZXN0YW5kIjoiT2ZmIiwiYWI5X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjlfaml0dGVyX2NlbnRlciI6MC4wLCJhYjlfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjlfbGJ5X2wiOjYwLjAsImFiOV9sYnlfciI6NjAuMCwiYWI5X29wdGlvbnMiOlsifiJdLCJhYjlfcF93YXkxIjowLjAsImFiOV9wX3dheTIiOjAuMCwiYWI5X3Bfd2F5MyI6MC4wLCJhYjlfcF93YXk0IjowLjAsImFiOV9wX3dheTUiOjAuMCwiYWI5X3Bfd2F5X2RlbGF5IjoxLjAsImFiOV9wX3dheV9zZWxlY3QiOjEuMCwiYWI5X3dheTEiOjAuMCwiYWI5X3dheTIiOjAuMCwiYWI5X3dheTMiOjAuMCwiYWI5X3dheTQiOjAuMCwiYWI5X3dheTUiOjAuMCwiYWI5X3dheV9kZWxheSI6MS4wLCJhYjlfd2F5X3NlbGVjdCI6MS4wLCJhYjlfeWF3X2wiOjAuMCwiYWI5X3lhd19yIjowLjAsImFiOV95YXdfc2VucyI6NTAuMCwiYWI5X3lhd190eXBlIjoiRGVmYXVsdCIsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfcGhhc2UiOjMuMCwiYm9keXlhdyI6IkRlZmF1bHQiLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjIuMCwiZGVmX3BpdGNoX3R5cGUiOiJVcCIsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiU2lkZS1XYXlzIiwiZGVsYXlfdHlwZSI6IlRpY2tzIiwiZGVsYXlfdHlwZV9tcyI6MS4wLCJkZWxheV90eXBlX3QiOjEuMCwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJwX3dheTEiOjAuMCwicF93YXkyIjowLjAsInBfd2F5MyI6MC4wLCJwX3dheTQiOjAuMCwicF93YXk1IjowLjAsInBfd2F5X2RlbGF5IjoxLjAsInBfd2F5X3NlbGVjdCI6MS4wLCJ3YXkxIjowLjAsIndheTIiOjAuMCwid2F5MyI6MC4wLCJ3YXk0IjowLjAsIndheTUiOjAuMCwid2F5X2RlbGF5IjoxLjAsIndheV9zZWxlY3QiOjEuMCwieWF3X2wiOi0xNS4wLCJ5YXdfciI6NDUuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYjEwX2JvZHl5YXciOiJPZmYiLCJhYjEwX2RlZl9hYSI6ZmFsc2UsImFiMTBfZGVmX3BpdGNoIjowLjAsImFiMTBfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxMF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjEwX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjEwX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMTBfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjEwX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjEwX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMTBfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMTBfaml0dGVyX2NlbnRlciI6MC4wLCJhYjEwX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjEwX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxMF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjEwX2xieV9sIjo2MC4wLCJhYjEwX2xieV9yIjo2MC4wLCJhYjEwX29wdGlvbnMiOlsifiJdLCJhYjEwX3Bfd2F5MSI6MC4wLCJhYjEwX3Bfd2F5MiI6MC4wLCJhYjEwX3Bfd2F5MyI6MC4wLCJhYjEwX3Bfd2F5NCI6MC4wLCJhYjEwX3Bfd2F5NSI6MC4wLCJhYjEwX3Bfd2F5X2RlbGF5IjoxLjAsImFiMTBfcF93YXlfc2VsZWN0IjoxLjAsImFiMTBfd2F5MSI6MC4wLCJhYjEwX3dheTIiOjAuMCwiYWIxMF93YXkzIjowLjAsImFiMTBfd2F5NCI6MC4wLCJhYjEwX3dheTUiOjAuMCwiYWIxMF93YXlfZGVsYXkiOjEuMCwiYWIxMF93YXlfc2VsZWN0IjoxLjAsImFiMTBfeWF3X2wiOjAuMCwiYWIxMF95YXdfciI6MC4wLCJhYjEwX3lhd19zZW5zIjo1MC4wLCJhYjEwX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9ib2R5eWF3IjoiT2ZmIiwiYWIxX2RlZl9hYSI6ZmFsc2UsImFiMV9kZWZfcGl0Y2giOjAuMCwiYWIxX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjFfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjFfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjFfZGVsYXlfdHlwZV90IjoxLjAsImFiMV9mcmVlc3RhbmQiOiJPZmYiLCJhYjFfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMV9qaXR0ZXJfY2VudGVyIjowLjAsImFiMV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMV9sYnlfbCI6NjAuMCwiYWIxX2xieV9yIjo2MC4wLCJhYjFfb3B0aW9ucyI6WyJ+Il0sImFiMV9wX3dheTEiOjAuMCwiYWIxX3Bfd2F5MiI6MC4wLCJhYjFfcF93YXkzIjowLjAsImFiMV9wX3dheTQiOjAuMCwiYWIxX3Bfd2F5NSI6MC4wLCJhYjFfcF93YXlfZGVsYXkiOjEuMCwiYWIxX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjFfd2F5MSI6MC4wLCJhYjFfd2F5MiI6MC4wLCJhYjFfd2F5MyI6MC4wLCJhYjFfd2F5NCI6MC4wLCJhYjFfd2F5NSI6MC4wLCJhYjFfd2F5X2RlbGF5IjoxLjAsImFiMV93YXlfc2VsZWN0IjoxLjAsImFiMV95YXdfbCI6MC4wLCJhYjFfeWF3X3IiOjAuMCwiYWIxX3lhd19zZW5zIjo1MC4wLCJhYjFfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2JvZHl5YXciOiJPZmYiLCJhYjJfZGVmX2FhIjpmYWxzZSwiYWIyX2RlZl9waXRjaCI6MC4wLCJhYjJfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIyX2RlZl90eXBlIjoiT24gUGVlayIsImFiMl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMl9kZWxheV90eXBlX21zIjoxLjAsImFiMl9kZWxheV90eXBlX3QiOjEuMCwiYWIyX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIyX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIyX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIyX2xieV9sIjo2MC4wLCJhYjJfbGJ5X3IiOjYwLjAsImFiMl9vcHRpb25zIjpbIn4iXSwiYWIyX3Bfd2F5MSI6MC4wLCJhYjJfcF93YXkyIjowLjAsImFiMl9wX3dheTMiOjAuMCwiYWIyX3Bfd2F5NCI6MC4wLCJhYjJfcF93YXk1IjowLjAsImFiMl9wX3dheV9kZWxheSI6MS4wLCJhYjJfcF93YXlfc2VsZWN0IjoxLjAsImFiMl93YXkxIjowLjAsImFiMl93YXkyIjowLjAsImFiMl93YXkzIjowLjAsImFiMl93YXk0IjowLjAsImFiMl93YXk1IjowLjAsImFiMl93YXlfZGVsYXkiOjEuMCwiYWIyX3dheV9zZWxlY3QiOjEuMCwiYWIyX3lhd19sIjowLjAsImFiMl95YXdfciI6MC4wLCJhYjJfeWF3X3NlbnMiOjUwLjAsImFiMl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfYm9keXlhdyI6Ik9mZiIsImFiM19kZWZfYWEiOmZhbHNlLCJhYjNfZGVmX3BpdGNoIjowLjAsImFiM19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjNfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIzX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIzX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIzX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjNfZnJlZXN0YW5kIjoiT2ZmIiwiYWIzX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjNfaml0dGVyX2NlbnRlciI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiM19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiM19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjNfbGJ5X2wiOjYwLjAsImFiM19sYnlfciI6NjAuMCwiYWIzX29wdGlvbnMiOlsifiJdLCJhYjNfcF93YXkxIjowLjAsImFiM19wX3dheTIiOjAuMCwiYWIzX3Bfd2F5MyI6MC4wLCJhYjNfcF93YXk0IjowLjAsImFiM19wX3dheTUiOjAuMCwiYWIzX3Bfd2F5X2RlbGF5IjoxLjAsImFiM19wX3dheV9zZWxlY3QiOjEuMCwiYWIzX3dheTEiOjAuMCwiYWIzX3dheTIiOjAuMCwiYWIzX3dheTMiOjAuMCwiYWIzX3dheTQiOjAuMCwiYWIzX3dheTUiOjAuMCwiYWIzX3dheV9kZWxheSI6MS4wLCJhYjNfd2F5X3NlbGVjdCI6MS4wLCJhYjNfeWF3X2wiOjAuMCwiYWIzX3lhd19yIjowLjAsImFiM195YXdfc2VucyI6NTAuMCwiYWIzX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9ib2R5eWF3IjoiT2ZmIiwiYWI0X2RlZl9hYSI6ZmFsc2UsImFiNF9kZWZfcGl0Y2giOjAuMCwiYWI0X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjRfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjRfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjRfZGVsYXlfdHlwZV90IjoxLjAsImFiNF9mcmVlc3RhbmQiOiJPZmYiLCJhYjRfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNF9qaXR0ZXJfY2VudGVyIjowLjAsImFiNF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI0X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNF9sYnlfbCI6NjAuMCwiYWI0X2xieV9yIjo2MC4wLCJhYjRfb3B0aW9ucyI6WyJ+Il0sImFiNF9wX3dheTEiOjAuMCwiYWI0X3Bfd2F5MiI6MC4wLCJhYjRfcF93YXkzIjowLjAsImFiNF9wX3dheTQiOjAuMCwiYWI0X3Bfd2F5NSI6MC4wLCJhYjRfcF93YXlfZGVsYXkiOjEuMCwiYWI0X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjRfd2F5MSI6MC4wLCJhYjRfd2F5MiI6MC4wLCJhYjRfd2F5MyI6MC4wLCJhYjRfd2F5NCI6MC4wLCJhYjRfd2F5NSI6MC4wLCJhYjRfd2F5X2RlbGF5IjoxLjAsImFiNF93YXlfc2VsZWN0IjoxLjAsImFiNF95YXdfbCI6MC4wLCJhYjRfeWF3X3IiOjAuMCwiYWI0X3lhd19zZW5zIjo1MC4wLCJhYjRfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2JvZHl5YXciOiJPZmYiLCJhYjVfZGVmX2FhIjpmYWxzZSwiYWI1X2RlZl9waXRjaCI6MC4wLCJhYjVfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI1X2RlZl90eXBlIjoiT24gUGVlayIsImFiNV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNV9kZWxheV90eXBlX21zIjoxLjAsImFiNV9kZWxheV90eXBlX3QiOjEuMCwiYWI1X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI1X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI1X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjVfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI1X2xieV9sIjo2MC4wLCJhYjVfbGJ5X3IiOjYwLjAsImFiNV9vcHRpb25zIjpbIn4iXSwiYWI1X3Bfd2F5MSI6MC4wLCJhYjVfcF93YXkyIjowLjAsImFiNV9wX3dheTMiOjAuMCwiYWI1X3Bfd2F5NCI6MC4wLCJhYjVfcF93YXk1IjowLjAsImFiNV9wX3dheV9kZWxheSI6MS4wLCJhYjVfcF93YXlfc2VsZWN0IjoxLjAsImFiNV93YXkxIjowLjAsImFiNV93YXkyIjowLjAsImFiNV93YXkzIjowLjAsImFiNV93YXk0IjowLjAsImFiNV93YXk1IjowLjAsImFiNV93YXlfZGVsYXkiOjEuMCwiYWI1X3dheV9zZWxlY3QiOjEuMCwiYWI1X3lhd19sIjowLjAsImFiNV95YXdfciI6MC4wLCJhYjVfeWF3X3NlbnMiOjUwLjAsImFiNV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfYm9keXlhdyI6Ik9mZiIsImFiNl9kZWZfYWEiOmZhbHNlLCJhYjZfZGVmX3BpdGNoIjowLjAsImFiNl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjZfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI2X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI2X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI2X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjZfZnJlZXN0YW5kIjoiT2ZmIiwiYWI2X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjZfaml0dGVyX2NlbnRlciI6MC4wLCJhYjZfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjZfbGJ5X2wiOjYwLjAsImFiNl9sYnlfciI6NjAuMCwiYWI2X29wdGlvbnMiOlsifiJdLCJhYjZfcF93YXkxIjowLjAsImFiNl9wX3dheTIiOjAuMCwiYWI2X3Bfd2F5MyI6MC4wLCJhYjZfcF93YXk0IjowLjAsImFiNl9wX3dheTUiOjAuMCwiYWI2X3Bfd2F5X2RlbGF5IjoxLjAsImFiNl9wX3dheV9zZWxlY3QiOjEuMCwiYWI2X3dheTEiOjAuMCwiYWI2X3dheTIiOjAuMCwiYWI2X3dheTMiOjAuMCwiYWI2X3dheTQiOjAuMCwiYWI2X3dheTUiOjAuMCwiYWI2X3dheV9kZWxheSI6MS4wLCJhYjZfd2F5X3NlbGVjdCI6MS4wLCJhYjZfeWF3X2wiOjAuMCwiYWI2X3lhd19yIjowLjAsImFiNl95YXdfc2VucyI6NTAuMCwiYWI2X3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19ib2R5eWF3IjoiT2ZmIiwiYWI3X2RlZl9hYSI6ZmFsc2UsImFiN19kZWZfcGl0Y2giOjAuMCwiYWI3X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiN19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjdfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19kZWxheV90eXBlIjoiVGlja3MiLCJhYjdfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjdfZGVsYXlfdHlwZV90IjoxLjAsImFiN19mcmVlc3RhbmQiOiJPZmYiLCJhYjdfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiN19qaXR0ZXJfY2VudGVyIjowLjAsImFiN19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI3X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiN19sYnlfbCI6NjAuMCwiYWI3X2xieV9yIjo2MC4wLCJhYjdfb3B0aW9ucyI6WyJ+Il0sImFiN19wX3dheTEiOjAuMCwiYWI3X3Bfd2F5MiI6MC4wLCJhYjdfcF93YXkzIjowLjAsImFiN19wX3dheTQiOjAuMCwiYWI3X3Bfd2F5NSI6MC4wLCJhYjdfcF93YXlfZGVsYXkiOjEuMCwiYWI3X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjdfd2F5MSI6MC4wLCJhYjdfd2F5MiI6MC4wLCJhYjdfd2F5MyI6MC4wLCJhYjdfd2F5NCI6MC4wLCJhYjdfd2F5NSI6MC4wLCJhYjdfd2F5X2RlbGF5IjoxLjAsImFiN193YXlfc2VsZWN0IjoxLjAsImFiN195YXdfbCI6MC4wLCJhYjdfeWF3X3IiOjAuMCwiYWI3X3lhd19zZW5zIjo1MC4wLCJhYjdfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2JvZHl5YXciOiJPZmYiLCJhYjhfZGVmX2FhIjpmYWxzZSwiYWI4X2RlZl9waXRjaCI6MC4wLCJhYjhfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI4X2RlZl90eXBlIjoiT24gUGVlayIsImFiOF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiOF9kZWxheV90eXBlX21zIjoxLjAsImFiOF9kZWxheV90eXBlX3QiOjEuMCwiYWI4X2ZyZWVzdGFuZCI6Ik9mZiIsImFiOF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI4X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI4X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjhfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI4X2xieV9sIjo2MC4wLCJhYjhfbGJ5X3IiOjYwLjAsImFiOF9vcHRpb25zIjpbIn4iXSwiYWI4X3Bfd2F5MSI6MC4wLCJhYjhfcF93YXkyIjowLjAsImFiOF9wX3dheTMiOjAuMCwiYWI4X3Bfd2F5NCI6MC4wLCJhYjhfcF93YXk1IjowLjAsImFiOF9wX3dheV9kZWxheSI6MS4wLCJhYjhfcF93YXlfc2VsZWN0IjoxLjAsImFiOF93YXkxIjowLjAsImFiOF93YXkyIjowLjAsImFiOF93YXkzIjowLjAsImFiOF93YXk0IjowLjAsImFiOF93YXk1IjowLjAsImFiOF93YXlfZGVsYXkiOjEuMCwiYWI4X3dheV9zZWxlY3QiOjEuMCwiYWI4X3lhd19sIjowLjAsImFiOF95YXdfciI6MC4wLCJhYjhfeWF3X3NlbnMiOjUwLjAsImFiOF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfYm9keXlhdyI6Ik9mZiIsImFiOV9kZWZfYWEiOmZhbHNlLCJhYjlfZGVmX3BpdGNoIjowLjAsImFiOV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjlfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI5X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI5X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI5X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjlfZnJlZXN0YW5kIjoiT2ZmIiwiYWI5X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjlfaml0dGVyX2NlbnRlciI6MC4wLCJhYjlfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjlfbGJ5X2wiOjYwLjAsImFiOV9sYnlfciI6NjAuMCwiYWI5X29wdGlvbnMiOlsifiJdLCJhYjlfcF93YXkxIjowLjAsImFiOV9wX3dheTIiOjAuMCwiYWI5X3Bfd2F5MyI6MC4wLCJhYjlfcF93YXk0IjowLjAsImFiOV9wX3dheTUiOjAuMCwiYWI5X3Bfd2F5X2RlbGF5IjoxLjAsImFiOV9wX3dheV9zZWxlY3QiOjEuMCwiYWI5X3dheTEiOjAuMCwiYWI5X3dheTIiOjAuMCwiYWI5X3dheTMiOjAuMCwiYWI5X3dheTQiOjAuMCwiYWI5X3dheTUiOjAuMCwiYWI5X3dheV9kZWxheSI6MS4wLCJhYjlfd2F5X3NlbGVjdCI6MS4wLCJhYjlfeWF3X2wiOjAuMCwiYWI5X3lhd19yIjowLjAsImFiOV95YXdfc2VucyI6NTAuMCwiYWI5X3lhd190eXBlIjoiRGVmYXVsdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX3BoYXNlIjoxLjAsImJvZHl5YXciOiJEZWZhdWx0IiwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT2ZmIiwiZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImRlbGF5X3R5cGUiOiJUaWNrcyIsImRlbGF5X3R5cGVfbXMiOjEuMCwiZGVsYXlfdHlwZV90IjoxLjAsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotNzYuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicF93YXkxIjowLjAsInBfd2F5MiI6MC4wLCJwX3dheTMiOjAuMCwicF93YXk0IjowLjAsInBfd2F5NSI6MC4wLCJwX3dheV9kZWxheSI6MS4wLCJwX3dheV9zZWxlY3QiOjEuMCwid2F5MSI6MC4wLCJ3YXkyIjowLjAsIndheTMiOjAuMCwid2F5NCI6MC4wLCJ3YXk1IjowLjAsIndheV9kZWxheSI6MS4wLCJ3YXlfc2VsZWN0IjoxLjAsInlhd19sIjowLjAsInlhd19yIjoxMC4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYjEwX2JvZHl5YXciOiJPZmYiLCJhYjEwX2RlZl9hYSI6ZmFsc2UsImFiMTBfZGVmX3BpdGNoIjowLjAsImFiMTBfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIxMF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjEwX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjEwX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMTBfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjEwX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjEwX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMTBfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMTBfaml0dGVyX2NlbnRlciI6MC4wLCJhYjEwX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjEwX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxMF9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjEwX2xieV9sIjo2MC4wLCJhYjEwX2xieV9yIjo2MC4wLCJhYjEwX29wdGlvbnMiOlsifiJdLCJhYjEwX3Bfd2F5MSI6MC4wLCJhYjEwX3Bfd2F5MiI6MC4wLCJhYjEwX3Bfd2F5MyI6MC4wLCJhYjEwX3Bfd2F5NCI6MC4wLCJhYjEwX3Bfd2F5NSI6MC4wLCJhYjEwX3Bfd2F5X2RlbGF5IjoxLjAsImFiMTBfcF93YXlfc2VsZWN0IjoxLjAsImFiMTBfd2F5MSI6MC4wLCJhYjEwX3dheTIiOjAuMCwiYWIxMF93YXkzIjowLjAsImFiMTBfd2F5NCI6MC4wLCJhYjEwX3dheTUiOjAuMCwiYWIxMF93YXlfZGVsYXkiOjEuMCwiYWIxMF93YXlfc2VsZWN0IjoxLjAsImFiMTBfeWF3X2wiOjAuMCwiYWIxMF95YXdfciI6MC4wLCJhYjEwX3lhd19zZW5zIjo1MC4wLCJhYjEwX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9ib2R5eWF3IjoiT2ZmIiwiYWIxX2RlZl9hYSI6ZmFsc2UsImFiMV9kZWZfcGl0Y2giOjAuMCwiYWIxX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiMV9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjFfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiMV9kZWxheV90eXBlIjoiVGlja3MiLCJhYjFfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjFfZGVsYXlfdHlwZV90IjoxLjAsImFiMV9mcmVlc3RhbmQiOiJPZmYiLCJhYjFfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiMV9qaXR0ZXJfY2VudGVyIjowLjAsImFiMV9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWIxX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWIxX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiMV9sYnlfbCI6NjAuMCwiYWIxX2xieV9yIjo2MC4wLCJhYjFfb3B0aW9ucyI6WyJ+Il0sImFiMV9wX3dheTEiOjAuMCwiYWIxX3Bfd2F5MiI6MC4wLCJhYjFfcF93YXkzIjowLjAsImFiMV9wX3dheTQiOjAuMCwiYWIxX3Bfd2F5NSI6MC4wLCJhYjFfcF93YXlfZGVsYXkiOjEuMCwiYWIxX3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjFfd2F5MSI6MC4wLCJhYjFfd2F5MiI6MC4wLCJhYjFfd2F5MyI6MC4wLCJhYjFfd2F5NCI6MC4wLCJhYjFfd2F5NSI6MC4wLCJhYjFfd2F5X2RlbGF5IjoxLjAsImFiMV93YXlfc2VsZWN0IjoxLjAsImFiMV95YXdfbCI6MC4wLCJhYjFfeWF3X3IiOjAuMCwiYWIxX3lhd19zZW5zIjo1MC4wLCJhYjFfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2JvZHl5YXciOiJPZmYiLCJhYjJfZGVmX2FhIjpmYWxzZSwiYWIyX2RlZl9waXRjaCI6MC4wLCJhYjJfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWIyX2RlZl90eXBlIjoiT24gUGVlayIsImFiMl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWIyX2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiMl9kZWxheV90eXBlX21zIjoxLjAsImFiMl9kZWxheV90eXBlX3QiOjEuMCwiYWIyX2ZyZWVzdGFuZCI6Ik9mZiIsImFiMl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWIyX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWIyX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWIyX2xieV9sIjo2MC4wLCJhYjJfbGJ5X3IiOjYwLjAsImFiMl9vcHRpb25zIjpbIn4iXSwiYWIyX3Bfd2F5MSI6MC4wLCJhYjJfcF93YXkyIjowLjAsImFiMl9wX3dheTMiOjAuMCwiYWIyX3Bfd2F5NCI6MC4wLCJhYjJfcF93YXk1IjowLjAsImFiMl9wX3dheV9kZWxheSI6MS4wLCJhYjJfcF93YXlfc2VsZWN0IjoxLjAsImFiMl93YXkxIjowLjAsImFiMl93YXkyIjowLjAsImFiMl93YXkzIjowLjAsImFiMl93YXk0IjowLjAsImFiMl93YXk1IjowLjAsImFiMl93YXlfZGVsYXkiOjEuMCwiYWIyX3dheV9zZWxlY3QiOjEuMCwiYWIyX3lhd19sIjowLjAsImFiMl95YXdfciI6MC4wLCJhYjJfeWF3X3NlbnMiOjUwLjAsImFiMl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfYm9keXlhdyI6Ik9mZiIsImFiM19kZWZfYWEiOmZhbHNlLCJhYjNfZGVmX3BpdGNoIjowLjAsImFiM19kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjNfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWIzX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjNfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWIzX2RlbGF5X3R5cGVfbXMiOjEuMCwiYWIzX2RlbGF5X3R5cGVfdCI6MS4wLCJhYjNfZnJlZXN0YW5kIjoiT2ZmIiwiYWIzX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjNfaml0dGVyX2NlbnRlciI6MC4wLCJhYjNfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiM19qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiM19qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjNfbGJ5X2wiOjYwLjAsImFiM19sYnlfciI6NjAuMCwiYWIzX29wdGlvbnMiOlsifiJdLCJhYjNfcF93YXkxIjowLjAsImFiM19wX3dheTIiOjAuMCwiYWIzX3Bfd2F5MyI6MC4wLCJhYjNfcF93YXk0IjowLjAsImFiM19wX3dheTUiOjAuMCwiYWIzX3Bfd2F5X2RlbGF5IjoxLjAsImFiM19wX3dheV9zZWxlY3QiOjEuMCwiYWIzX3dheTEiOjAuMCwiYWIzX3dheTIiOjAuMCwiYWIzX3dheTMiOjAuMCwiYWIzX3dheTQiOjAuMCwiYWIzX3dheTUiOjAuMCwiYWIzX3dheV9kZWxheSI6MS4wLCJhYjNfd2F5X3NlbGVjdCI6MS4wLCJhYjNfeWF3X2wiOjAuMCwiYWIzX3lhd19yIjowLjAsImFiM195YXdfc2VucyI6NTAuMCwiYWIzX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9ib2R5eWF3IjoiT2ZmIiwiYWI0X2RlZl9hYSI6ZmFsc2UsImFiNF9kZWZfcGl0Y2giOjAuMCwiYWI0X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiNF9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjRfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiNF9kZWxheV90eXBlIjoiVGlja3MiLCJhYjRfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjRfZGVsYXlfdHlwZV90IjoxLjAsImFiNF9mcmVlc3RhbmQiOiJPZmYiLCJhYjRfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiNF9qaXR0ZXJfY2VudGVyIjowLjAsImFiNF9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI0X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI0X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiNF9sYnlfbCI6NjAuMCwiYWI0X2xieV9yIjo2MC4wLCJhYjRfb3B0aW9ucyI6WyJ+Il0sImFiNF9wX3dheTEiOjAuMCwiYWI0X3Bfd2F5MiI6MC4wLCJhYjRfcF93YXkzIjowLjAsImFiNF9wX3dheTQiOjAuMCwiYWI0X3Bfd2F5NSI6MC4wLCJhYjRfcF93YXlfZGVsYXkiOjEuMCwiYWI0X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjRfd2F5MSI6MC4wLCJhYjRfd2F5MiI6MC4wLCJhYjRfd2F5MyI6MC4wLCJhYjRfd2F5NCI6MC4wLCJhYjRfd2F5NSI6MC4wLCJhYjRfd2F5X2RlbGF5IjoxLjAsImFiNF93YXlfc2VsZWN0IjoxLjAsImFiNF95YXdfbCI6MC4wLCJhYjRfeWF3X3IiOjAuMCwiYWI0X3lhd19zZW5zIjo1MC4wLCJhYjRfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2JvZHl5YXciOiJPZmYiLCJhYjVfZGVmX2FhIjpmYWxzZSwiYWI1X2RlZl9waXRjaCI6MC4wLCJhYjVfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI1X2RlZl90eXBlIjoiT24gUGVlayIsImFiNV9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI1X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiNV9kZWxheV90eXBlX21zIjoxLjAsImFiNV9kZWxheV90eXBlX3QiOjEuMCwiYWI1X2ZyZWVzdGFuZCI6Ik9mZiIsImFiNV9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI1X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI1X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjVfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjVfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI1X2xieV9sIjo2MC4wLCJhYjVfbGJ5X3IiOjYwLjAsImFiNV9vcHRpb25zIjpbIn4iXSwiYWI1X3Bfd2F5MSI6MC4wLCJhYjVfcF93YXkyIjowLjAsImFiNV9wX3dheTMiOjAuMCwiYWI1X3Bfd2F5NCI6MC4wLCJhYjVfcF93YXk1IjowLjAsImFiNV9wX3dheV9kZWxheSI6MS4wLCJhYjVfcF93YXlfc2VsZWN0IjoxLjAsImFiNV93YXkxIjowLjAsImFiNV93YXkyIjowLjAsImFiNV93YXkzIjowLjAsImFiNV93YXk0IjowLjAsImFiNV93YXk1IjowLjAsImFiNV93YXlfZGVsYXkiOjEuMCwiYWI1X3dheV9zZWxlY3QiOjEuMCwiYWI1X3lhd19sIjowLjAsImFiNV95YXdfciI6MC4wLCJhYjVfeWF3X3NlbnMiOjUwLjAsImFiNV95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfYm9keXlhdyI6Ik9mZiIsImFiNl9kZWZfYWEiOmZhbHNlLCJhYjZfZGVmX3BpdGNoIjowLjAsImFiNl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjZfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI2X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjZfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI2X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI2X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjZfZnJlZXN0YW5kIjoiT2ZmIiwiYWI2X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjZfaml0dGVyX2NlbnRlciI6MC4wLCJhYjZfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiNl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiNl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjZfbGJ5X2wiOjYwLjAsImFiNl9sYnlfciI6NjAuMCwiYWI2X29wdGlvbnMiOlsifiJdLCJhYjZfcF93YXkxIjowLjAsImFiNl9wX3dheTIiOjAuMCwiYWI2X3Bfd2F5MyI6MC4wLCJhYjZfcF93YXk0IjowLjAsImFiNl9wX3dheTUiOjAuMCwiYWI2X3Bfd2F5X2RlbGF5IjoxLjAsImFiNl9wX3dheV9zZWxlY3QiOjEuMCwiYWI2X3dheTEiOjAuMCwiYWI2X3dheTIiOjAuMCwiYWI2X3dheTMiOjAuMCwiYWI2X3dheTQiOjAuMCwiYWI2X3dheTUiOjAuMCwiYWI2X3dheV9kZWxheSI6MS4wLCJhYjZfd2F5X3NlbGVjdCI6MS4wLCJhYjZfeWF3X2wiOjAuMCwiYWI2X3lhd19yIjowLjAsImFiNl95YXdfc2VucyI6NTAuMCwiYWI2X3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19ib2R5eWF3IjoiT2ZmIiwiYWI3X2RlZl9hYSI6ZmFsc2UsImFiN19kZWZfcGl0Y2giOjAuMCwiYWI3X2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiN19kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYjdfZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImFiN19kZWxheV90eXBlIjoiVGlja3MiLCJhYjdfZGVsYXlfdHlwZV9tcyI6MS4wLCJhYjdfZGVsYXlfdHlwZV90IjoxLjAsImFiN19mcmVlc3RhbmQiOiJPZmYiLCJhYjdfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiN19qaXR0ZXJfY2VudGVyIjowLjAsImFiN19qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWI3X2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWI3X2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiN19sYnlfbCI6NjAuMCwiYWI3X2xieV9yIjo2MC4wLCJhYjdfb3B0aW9ucyI6WyJ+Il0sImFiN19wX3dheTEiOjAuMCwiYWI3X3Bfd2F5MiI6MC4wLCJhYjdfcF93YXkzIjowLjAsImFiN19wX3dheTQiOjAuMCwiYWI3X3Bfd2F5NSI6MC4wLCJhYjdfcF93YXlfZGVsYXkiOjEuMCwiYWI3X3Bfd2F5X3NlbGVjdCI6MS4wLCJhYjdfd2F5MSI6MC4wLCJhYjdfd2F5MiI6MC4wLCJhYjdfd2F5MyI6MC4wLCJhYjdfd2F5NCI6MC4wLCJhYjdfd2F5NSI6MC4wLCJhYjdfd2F5X2RlbGF5IjoxLjAsImFiN193YXlfc2VsZWN0IjoxLjAsImFiN195YXdfbCI6MC4wLCJhYjdfeWF3X3IiOjAuMCwiYWI3X3lhd19zZW5zIjo1MC4wLCJhYjdfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2JvZHl5YXciOiJPZmYiLCJhYjhfZGVmX2FhIjpmYWxzZSwiYWI4X2RlZl9waXRjaCI6MC4wLCJhYjhfZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiYWI4X2RlZl90eXBlIjoiT24gUGVlayIsImFiOF9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWI4X2RlbGF5X3R5cGUiOiJUaWNrcyIsImFiOF9kZWxheV90eXBlX21zIjoxLjAsImFiOF9kZWxheV90eXBlX3QiOjEuMCwiYWI4X2ZyZWVzdGFuZCI6Ik9mZiIsImFiOF9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWI4X2ppdHRlcl9jZW50ZXIiOjAuMCwiYWI4X2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYjhfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYjhfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWI4X2xieV9sIjo2MC4wLCJhYjhfbGJ5X3IiOjYwLjAsImFiOF9vcHRpb25zIjpbIn4iXSwiYWI4X3Bfd2F5MSI6MC4wLCJhYjhfcF93YXkyIjowLjAsImFiOF9wX3dheTMiOjAuMCwiYWI4X3Bfd2F5NCI6MC4wLCJhYjhfcF93YXk1IjowLjAsImFiOF9wX3dheV9kZWxheSI6MS4wLCJhYjhfcF93YXlfc2VsZWN0IjoxLjAsImFiOF93YXkxIjowLjAsImFiOF93YXkyIjowLjAsImFiOF93YXkzIjowLjAsImFiOF93YXk0IjowLjAsImFiOF93YXk1IjowLjAsImFiOF93YXlfZGVsYXkiOjEuMCwiYWI4X3dheV9zZWxlY3QiOjEuMCwiYWI4X3lhd19sIjowLjAsImFiOF95YXdfciI6MC4wLCJhYjhfeWF3X3NlbnMiOjUwLjAsImFiOF95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfYm9keXlhdyI6Ik9mZiIsImFiOV9kZWZfYWEiOmZhbHNlLCJhYjlfZGVmX3BpdGNoIjowLjAsImFiOV9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYjlfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWI5X2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYjlfZGVsYXlfdHlwZSI6IlRpY2tzIiwiYWI5X2RlbGF5X3R5cGVfbXMiOjEuMCwiYWI5X2RlbGF5X3R5cGVfdCI6MS4wLCJhYjlfZnJlZXN0YW5kIjoiT2ZmIiwiYWI5X2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYjlfaml0dGVyX2NlbnRlciI6MC4wLCJhYjlfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiOV9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiOV9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYjlfbGJ5X2wiOjYwLjAsImFiOV9sYnlfciI6NjAuMCwiYWI5X29wdGlvbnMiOlsifiJdLCJhYjlfcF93YXkxIjowLjAsImFiOV9wX3dheTIiOjAuMCwiYWI5X3Bfd2F5MyI6MC4wLCJhYjlfcF93YXk0IjowLjAsImFiOV9wX3dheTUiOjAuMCwiYWI5X3Bfd2F5X2RlbGF5IjoxLjAsImFiOV9wX3dheV9zZWxlY3QiOjEuMCwiYWI5X3dheTEiOjAuMCwiYWI5X3dheTIiOjAuMCwiYWI5X3dheTMiOjAuMCwiYWI5X3dheTQiOjAuMCwiYWI5X3dheTUiOjAuMCwiYWI5X3dheV9kZWxheSI6MS4wLCJhYjlfd2F5X3NlbGVjdCI6MS4wLCJhYjlfeWF3X2wiOjAuMCwiYWI5X3lhd19yIjowLjAsImFiOV95YXdfc2VucyI6NTAuMCwiYWI5X3lhd190eXBlIjoiRGVmYXVsdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX3BoYXNlIjoxLjAsImJvZHl5YXciOiJEZWZhdWx0IiwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjoyLjAsImRlZl9waXRjaF90eXBlIjoiVXAiLCJkZWZfdHlwZSI6Ik9mZiIsImRlZl95YXdfdHlwZSI6IkN1c3RvbSIsImRlbGF5X3R5cGUiOiJUaWNrcyIsImRlbGF5X3R5cGVfbXMiOjEuMCwiZGVsYXlfdHlwZV90IjoyLjAsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwicF93YXkxIjowLjAsInBfd2F5MiI6MC4wLCJwX3dheTMiOjAuMCwicF93YXk0IjowLjAsInBfd2F5NSI6MC4wLCJwX3dheV9kZWxheSI6MS4wLCJwX3dheV9zZWxlY3QiOjEuMCwid2F5MSI6MC4wLCJ3YXkyIjowLjAsIndheTMiOjAuMCwid2F5NCI6MC4wLCJ3YXk1IjowLjAsIndheV9kZWxheSI6MS4wLCJ3YXlfc2VsZWN0IjoxLjAsInlhd19sIjotMjUuMCwieWF3X3IiOjQzLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9XV0="
cfg_system.save_config = function(id)
    if id == 1 then return end
    local raw = config_cfg:save()
    configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
    db.cfg_spacenightly = configs_db
end

cfg_system.update_values = function(id)
    local name = configs_db.cfg_list[id][1]
    local new_name = name..'\a'..ui.get_style("Link Active"):to_hex()..' - Active'
    for k, v in ipairs(configs_db.cfg_list) do
        configs_db.menu_list[k] = v[1]
    end
    configs_db.menu_list[id] = new_name
end

cfg_system.create_config = function(name)
    if type(name) ~= 'string' then return end
    if name == nil or name == '' or name == ' ' then return end
    for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then common.add_notify('[space.codes]', 'Error: same name!') return end end
    if #configs_db.cfg_list > 6 then common.add_notify('[space.codes]', ':(') return end
    local completed = {name, ''}
    table.insert(configs_db.cfg_list, completed)
    table.insert(configs_db.menu_list, name)
    db.cfg_spacenightly = configs_db
end

cfg_system.remove_config = function(id)
    if id == 1 then return end
    local item = configs_db.cfg_list[id][1]
    for i=#configs_db.cfg_list, 1, -1 do if configs_db.cfg_list[i][1] == item then table.remove(configs_db.cfg_list, i) table.remove(configs_db.menu_list, i) end end
    db.cfg_spacenightly = configs_db
end

cfg_system.load_config = function(id)
    if configs_db.cfg_list[id][2] == nil or configs_db.cfg_list[id][2] == '' then print(string.format('Error[data_base[%s]]', id)) return end
    if id > #configs_db.cfg_list then print(string.format('Error[data_base[%s]]', id)) return end
        config_cfg:load(json.parse(base64.decode(configs_db.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
end
configs = {
    cfg_selector = tabs.main1:list('', configs_db.menu_list),
    name = tabs.main1:input(ui.get_icon('input-text')..'  Config Name', 'New Config'),
    
    create = tabs.main1:button(ui.get_icon('layer-plus').."\v  Create config    ", function()
        cfg_system.create_config(configs.name:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true),
    
    remove  = tabs.main1:button(ui.get_icon('trash-xmark').."\v  Remove config ", function()
        cfg_system.remove_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true),
    
    save = tabs.main1:button(ui.get_icon('floppy-disk').."\v  Save config         ", function()
        cfg_system.save_config(configs.cfg_selector:get())
    end, true),
    load = tabs.main1:button(ui.get_icon('check').."\v  Load config       ", function()
        cfg_system.update_values(configs.cfg_selector:get())
        cfg_system.load_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true),
    
    import = tabs.main1:button(ui.get_icon('download').."\v  Import config    ", function()
        config_cfg:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true),
    
    export = tabs.main1:button(ui.get_icon('share-nodes').."\v  Export config    ", function()
        clipboard.set(base64.encode(json.stringify(config_cfg:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true)
}

events['shutdown']:set(function ()
    db.cfg_spacenightly = configs_db
end)