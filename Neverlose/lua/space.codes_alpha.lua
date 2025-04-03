local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local MTools = require("neverlose/mtools")
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local vmt_hook = require("neverlose/vmt_hook")
local pui = require("neverlose/pui")
local renderer = require "neverlose/side_indicator"

local tabs = {
    main2 = pui.create("\f<stars>", "\f<stars> Main ", 1),
    main = pui.create("\f<stars>", "\f<rss> Recomendations ", 1),
    main1 = pui.create("\f<stars>", "\f<layer-plus> Configs ", 2),
    anti1 = pui.create("\f<user-shield>", "\f<gear>     Enable     ", 1),
    antis = pui.create("\f<user-shield>", "\f<star>     Main     ", 1),
    antic = pui.create("\f<user-shield>", "\f<star>     Condition     ", 2),
    anti2 = pui.create("\f<user-shield>", "\f<sliders-up>  Builder   ", 2),
    configs = pui.create("\f<user-shield>", "\f<layer-plus>  Config System     ", 1),
    misc = pui.create("\f<gears>", "\f<gear> Misc ", 1),
    mod = pui.create("\f<gears>", "\f<gear> Modification ", 2),
    visuals = pui.create("\f<gears>", "\f<stars> Visuals ", 2),
}

local style = ui.get_style "Button"
local style_hex = style:to_hex()
tabs.main2:label(" »   Welcome, \b"..style_hex.."\bFFFFFFFF["..common.get_username().."]")
tabs.main2:label(" »   Author - \b"..style_hex.."\bFFFFFFFF[NN]")
tabs.main2:label("\bFFFFFFFF\b"..style_hex.."[ »   Space.codes ~ alpha]")
tabs.main2:label("\bFFFFFFFF\b"..style_hex.."[ »   Latest Update - 99.99.9009]")

tabs.main2:button(ui.get_icon('headset').."\bFFFFFFFF\b"..style_hex.."[    Discord Server   ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end, true) 

tabs.main2:button(ui.get_icon('video').."\bFFFFFFFF\b"..style_hex.."[    Discord Server   ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end, true) 

tabs.main2:button(ui.get_icon('gear').."\bFFFFFFFF\b"..style_hex.."[                        BEST LEAKS                          ]",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end, true) 

local function sidebar()
    local gradient_animation = gradient.text_animate(".codes ~ alpha", -0.57, {
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
aa_table.cond_aa = {"\vGlobal", "\vStanding", "\vRunning", "\vSlow-Walk", "\vCrouch", "\vAir", "\vAir+C", "\vFake~Lag", "\vOn Use"}
aa_table.cnd_aa = {"G", "S", "R", "S-W", "C", "A", "A+C", "F", "U"}
aa_table.enable_aa = tabs.anti1:switch("Enable \vAnti~Aim")
aa_table.condition = tabs.antic:combo("", aa_table.cond_aa):depend(aa_table.enable_aa)
aa_table.pitch = tabs.antis:combo("Pitch", reference.pitch:list()):depend(aa_table.enable_aa)
aa_table.yaw_base = tabs.antis:combo("Yaw Base", {"Backward", "At Target", "Forward", "Left", "Right"}):depend(aa_table.enable_aa)
aa_table.yaw_base_create = aa_table.yaw_base:create()
aa_table.yaw_base_disabler = aa_table.yaw_base_create:selectable("Disablers", {"Jitter", "Hidden", "On Freestand"}):depend(aa_table.enable_aa)
aa_table.freestanding = tabs.antis:switch("Freestanding"):depend(aa_table.enable_aa)
aa_table.frees_create = aa_table.freestanding:create()
aa_table.frees_type = aa_table.frees_create:list("", {"Default", "Edge Yaw"}):depend(aa_table.enable_aa)
aa_table.huynya_ne_nuzhnaya = tabs.antis:selectable("FakeDuck Addons", {"Edge Yaw", "Forward"}):depend(aa_table.enable_aa)
aa_table.static_frees = aa_table.frees_create:selectable("Disablers", {"Jitter", "On Manual"}):depend(aa_table.enable_aa)
aa_table.anti_backstab = tabs.antis:switch("Anti~\vBackstab"):depend(aa_table.enable_aa)
aa_table.break_lc = tabs.antis:switch("Break LC In Air"):depend(aa_table.enable_aa)
aa_table.shit_aa = tabs.antis:combo("Warmup \vAnti~Aim", {"Default", "Shit", "Disabled", "Random"}):depend(aa_table.enable_aa)
aa_table.safe_head = tabs.antis:selectable("Safe Head In Air", {"Knife", "Zeus", "Grenade", "Scout", "Awp"}):depend(aa_table.enable_aa)
aa_table.animbreaker = tabs.antis:switch("Animation Breaker"):depend(aa_table.enable_aa)
aa_table.anim_create = aa_table.animbreaker:create()
aa_table.groundbreaker = aa_table.anim_create:combo("Ground", {"Off", "Follow Direction", "Jitter", "MoonWalk"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.airbreaker = aa_table.anim_create:combo("Air", {"Off", "Static Legs", "MoonWalk"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.otherbreaker = aa_table.anim_create:selectable("Other", {"Pitch 0 On Land", "Movement Lean"}):depend(aa_table.enable_aa, aa_table.animbreaker)
aa_table.lean_value = aa_table.anim_create:slider("Lean Value", 0, 100, 1, "°"):depend(aa_table.enable_aa, aa_table.animbreaker, {aa_table.otherbreaker, "Movement Lean"})

local other_table = {}
other_table.clantag = tabs.misc:switch("\f<tag>  Clantag")
other_table.nade_fix = tabs.misc:switch("\f<bomb>  Nade Fix")
other_table.trashtalk = tabs.misc:switch("\f<comment-exclamation>  TrashTalk")
other_table.fast_ladder = tabs.misc:switch("\f<water-ladder>  Fast Ladder")
other_table.viewmodel = tabs.misc:switch("\f<hands-holding>  Viewmodel")
other_table.viewmodel_create = other_table.viewmodel:create()
other_table.viewmodel_fov = other_table.viewmodel_create:slider("FOV", -100, 100, 68):depend(other_table.viewmodel)
other_table.viewmodel_x = other_table.viewmodel_create:slider("X", -10, 10, 2.5):depend(other_table.viewmodel)
other_table.viewmodel_y = other_table.viewmodel_create:slider("Y", -10, 10, 0):depend(other_table.viewmodel)
other_table.viewmodel_z = other_table.viewmodel_create:slider("Z", -10, 10, -1.5):depend(other_table.viewmodel)
other_table.aspect_ratio = tabs.misc:switch("\f<arrows-left-right-to-line>  Aspect Ratio")
other_table.aspect_ratio_create = other_table.aspect_ratio:create()
other_table.aspect_ratio_slider = other_table.aspect_ratio_create:slider("Aspect Ratio", 0, 200, 133):depend(other_table.aspect_ratio)
other_table.logs = tabs.misc:switch("\f<list>  Ragebot logs")
other_table.logs_create = other_table.logs:create()
other_table.check_print = other_table.logs_create:listable("", {"Hit", "Miss", "Anti~Bruteforce"}):depend(other_table.logs)
other_table.printconsole = other_table.logs_create:switch("Print To Console"):depend(other_table.logs)
other_table.shared_icon = tabs.misc:switch("\f<icons>  Shared Icon")
other_table.jumpscout = tabs.misc:switch("\f<person-ski-jumping>  Jumpscout fix")
other_table.no_fall_damage = tabs.misc:switch("\f<person-falling>  No Fall Damage")
other_table.drop_nades = tabs.misc:hotkey("\f<bomb>  Fast Drop Nades")
other_table.teleport = tabs.misc:switch("\f<transporter-1>  Auto Teleport In Air")
other_table.teleport_create = other_table.teleport:create()
other_table.teleport_wpn = other_table.teleport_create:selectable("Weapon", {"Taser", "Knife", "Scout", "AWP", "Shotgun", "Pistols"}):depend(other_table.teleport)
other_table.taskbar = tabs.misc:switch("\f<bell-on>  Taskbar notify on round start")
other_table.fast_dt = tabs.misc:switch("\f<gun>  Faster Doubletap")
other_table.fast_dt_create = other_table.fast_dt:create()
other_table.fast_dt_select = other_table.fast_dt_create:combo("Speed", {"Faster", "Fast", "Instant"}):depend(other_table.fast_dt)

other_table.mute_unmute = tabs.misc:switch("\f<volume-xmark>  Unmute/Mute Players")
other_table.mute_unmute_create = other_table.mute_unmute:create()
other_table.mute_set = other_table.mute_unmute_create:combo("Action", {"Mute", "Unmute"})

other_table.baim_switch = tabs.mod:switch("\f<person-military-rifle>  Baim if enemy lethal")
other_table.baim_switch_create = other_table.baim_switch:create()
other_table.baim_select = other_table.baim_switch_create:selectable("Weapon", {"Scout", "Awp", "R8"}):depend(other_table.baim_switch)
other_table.baim_scout = other_table.baim_switch_create:slider("Scout Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "Scout"})
other_table.baim_awp = other_table.baim_switch_create:slider("Awp Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "Awp"})
other_table.baim_r8 = other_table.baim_switch_create:slider("R8 Dmg", 0, 100, 89):depend(other_table.baim_switch, {other_table.baim_select, "R8"})

other_table.safe_switch = tabs.mod:switch("\f<person-rifle>  Safe if enemy lethal")
other_table.safe_switch_create = other_table.safe_switch:create()
other_table.safe_select = other_table.safe_switch_create:selectable("Weapon", {"Scout", "Awp", "R8"}):depend(other_table.safe_switch)
other_table.safe_scout = other_table.safe_switch_create:slider("Scout Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "Scout"})
other_table.safe_awp = other_table.safe_switch_create:slider("Awp Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "Awp"})
other_table.safe_r8 = other_table.safe_switch_create:slider("R8 Dmg", 0, 100, 89):depend(other_table.safe_switch, {other_table.safe_select, "R8"})

other_table.air_switch = tabs.mod:switch("\f<person-falling>  Air Hitchance")
other_table.air_switch_create = other_table.air_switch:create()
other_table.air_select = other_table.air_switch_create:selectable("Weapon", {"Scout", "R8", "Pistols"}):depend(other_table.air_switch)
other_table.air_scout = other_table.air_switch_create:slider("Scout HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "Scout"})
other_table.air_awp = other_table.air_switch_create:slider("R8 HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "R8"})
other_table.air_pistols = other_table.air_switch_create:slider("Pistols HC", 0, 100, 89):depend(other_table.air_switch, {other_table.air_select, "Pistols"})

other_table.scope_switch = tabs.mod:switch("\f<crosshairs>  No Scope Hitchance")
other_table.scope_switch_create = other_table.scope_switch:create()
other_table.scope_select = other_table.scope_switch_create:selectable("Weapon", {"Scout", "Auto", "Awp"}):depend(other_table.scope_switch)
other_table.scope_scout = other_table.scope_switch_create:slider("Scout HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Scout"})
other_table.scope_auto = other_table.scope_switch_create:slider("Auto HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Auto"})
other_table.scope_awp = other_table.scope_switch_create:slider("Awp HC", 0, 100, 89):depend(other_table.scope_switch, {other_table.scope_select, "Awp"})


local visual_table = {}
visual_table.solus = tabs.visuals:switch("\f<list>  Solus UI")
visual_table.solus_create = visual_table.solus:create()
visual_table.solus_select = visual_table.solus_create:listable("Windows", {"Water\vmark", "Key\vbinds", "Spectator\v List"}):depend(visual_table.solus)
visual_table.solus_type = visual_table.solus_create:list("Watermark Style", {"Default", "Alternative"}):depend(visual_table.solus)
visual_table.soluskey_type = visual_table.solus_create:list("Keybinds Style", {"Default", "Alternative"}):depend(visual_table.solus)
visual_table.solusspec_type = visual_table.solus_create:list("Speclist Style", {"Default", "Alternative"}):depend(visual_table.solus)
visual_table.solus_color = visual_table.solus_create:color_picker("Color", color(163, 146, 255)):depend(visual_table.solus)
visual_table.solus_glow = visual_table.solus_create:switch("Glow"):depend(visual_table.solus)
visual_table.custom_name = visual_table.solus_create:input("Username", ""..common.get_username().."", nil, false):depend(visual_table.solus)

visual_table.grenade_radius = tabs.visuals:switch("\f<circle-dashed>  Grenade Radius")
visual_table.grenade_radius_create = visual_table.grenade_radius:create()
visual_table.grenade_select = visual_table.grenade_radius_create:listable("", {"Smoke", "Molotov"}):depend(visual_table.grenade_radius)
visual_table.molotov_color = visual_table.grenade_radius_create:color_picker("Friendly Molotov Color", color(116, 192, 41, 255)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 2})
visual_table.molotov_color2 = visual_table.grenade_radius_create:color_picker("Enemy Molotov Color", color(255, 63, 63, 255)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 2})
visual_table.smoke_color = visual_table.grenade_radius_create:color_picker("Smoke Color", color(61, 147, 250, 180)):depend(visual_table.grenade_radius, {visual_table.grenade_select, 1})


visual_table.console_color = tabs.visuals:switch("\f<list>  Console Color")
visual_table.console_color_create = visual_table.console_color:create()
visual_table.clr_console = visual_table.console_color_create:color_picker("Color", color(100, 100, 100, 100)):depend(visual_table.console_color)

visual_table.snaplines = tabs.visuals:switch("\f<lines-leaning>  Snaplines")

visual_table.sense_ind = tabs.visuals:switch("\f<list>  \vSense \rIndicators")
visual_table.sense_ind_create = visual_table.sense_ind:create()
visual_table.sense_select = visual_table.sense_ind_create:listable("", {"Aimbot Stats", "Freestanding", "Min. Damage", "DoubleTap", "Hit Chance", "Hideshots", "Dormant",  "Baim", "Duck", "Ping", "Safe"}):depend(visual_table.sense_ind)
visual_table.arrows = tabs.visuals:switch("\f<arrows-left-right>  Manual Arrows")
visual_table.arrows_create = visual_table.arrows:create()
visual_table.arrows_color = visual_table.arrows_create:color_picker("Color", color(134, 126, 255)):depend(visual_table.arrows)
visual_table.scope = tabs.visuals:switch("\f<crosshairs>  Custom Scope")
visual_table.scope_create = visual_table.scope:create()
visual_table.Scopeinverted = visual_table.scope_create:switch("Invert scope lines", false):depend(visual_table.scope)
visual_table.Scopelength = visual_table.scope_create:slider("Scope length", 5, 200, 55):depend(visual_table.scope)
visual_table.Scopeoffset = visual_table.scope_create:slider("Scope offset", 1, 50, 11):depend(visual_table.scope)
visual_table.scope_color = visual_table.scope_create:color_picker("Color", color(255, 255, 255)):depend(visual_table.scope)
visual_table.crosshair = tabs.visuals:switch("\f<star>  Crosshair Indicators")
visual_table.crosshair_create = visual_table.crosshair:create()
visual_table.crosshair_style = visual_table.crosshair_create:list("", {"Default", "Alternative"}):depend(visual_table.crosshair)
visual_table.crosshair_color1 = visual_table.crosshair_create:color_picker("First", color(68, 68, 68)):depend(visual_table.crosshair)
visual_table.crosshair_color2 = visual_table.crosshair_create:color_picker("Second", color(255, 255, 255)):depend(visual_table.crosshair)
visual_table.slowed_down = tabs.visuals:switch("\f<triangle-exclamation>  Slowed down indicator")
visual_table.slowed_down_create = visual_table.slowed_down:create()
visual_table.slowed_down_color = visual_table.slowed_down_create:color_picker("First", color(177, 166, 237)):depend(visual_table.slowed_down)
visual_table.slowed_down_color2 = visual_table.slowed_down_create:color_picker("Second", color(107, 58, 255)):depend(visual_table.slowed_down)
visual_table.slowed_down_color3 = visual_table.slowed_down_create:color_picker("Text Color", color(255, 255, 255)):depend(visual_table.slowed_down)
visual_table.mindmg = tabs.visuals:switch("\f<eye>  Minimum damage indicator")

antiaim_cicle = {}
for z, x in pairs(aa_table.cond_aa) do
    antiaim_cicle[z] = {}
    antiaim_cicle[z].enable = tabs.anti2:switch("Enable " .. aa_table.cond_aa[z])
    antiaim_cicle[z].yaw_type = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch"})
    antiaim_cicle[z].yaw_type_create = antiaim_cicle[z].yaw_type:create()
    antiaim_cicle[z].delay_type = antiaim_cicle[z].yaw_type_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Fast", "Slow"})
    antiaim_cicle[z].yaw_l = tabs.anti2:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].yaw_r = tabs.anti2:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jit_type = tabs.anti2:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].modifier_gear = antiaim_cicle[z].jit_type:create()
    antiaim_cicle[z].jitter_type = antiaim_cicle[z].modifier_gear:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].jitter_center = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jitter_center_left = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].jitter_center_right = antiaim_cicle[z].modifier_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].bodyyaw = tabs.anti2:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw")
    antiaim_cicle[z].bodyyaw_gear = antiaim_cicle[z].bodyyaw:create()
    antiaim_cicle[z].options = antiaim_cicle[z].bodyyaw_gear:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].freestand = antiaim_cicle[z].bodyyaw_gear:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].lby_l = antiaim_cicle[z].bodyyaw_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].lby_r = antiaim_cicle[z].bodyyaw_gear:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].def_aa = tabs.anti2:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].def_create = antiaim_cicle[z].def_aa:create()
    antiaim_cicle[z].def_type = antiaim_cicle[z].def_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"On Peek", "Always On", "Visible Only", "Hittable"})
    antiaim_cicle[z].def_yaw_type = antiaim_cicle[z].def_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Custom", "Spin", "180Z"})
    antiaim_cicle[z].yaw_sens = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].def_pitch_type = antiaim_cicle[z].def_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom"})
    antiaim_cicle[z].def_pitch = antiaim_cicle[z].def_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")

    antiaim_cicle[z].ab_enable = tabs.anti2:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFAnti~Bruteforce")
    antiaim_cicle[z].ab_label = tabs.anti2:label("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPhase: 1")
    antiaim_cicle[z].ab_create = antiaim_cicle[z].ab_label:create()

    antiaim_cicle[z].ab_yaw_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Type", {"Default", "Delay Switch"})
    antiaim_cicle[z].ab_delay_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDelay Type", {"Fast", "Slow"})
    antiaim_cicle[z].ab_yaw_l = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Left", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab_yaw_r = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw Right", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab_jit_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFModifier", reference.yawmod:list())
    antiaim_cicle[z].ab_jitter_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"Default", "L&R"})
    antiaim_cicle[z].ab_jitter_center = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Amount°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab_jitter_center_left = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Left°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab_jitter_center_right = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFF Right°", -180, 180, 0, 1, "°")
    antiaim_cicle[z].ab_bodyyaw = antiaim_cicle[z].ab_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFBody Yaw")
    antiaim_cicle[z].ab_options = antiaim_cicle[z].ab_create:selectable("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFOptions", reference.options:list())
    antiaim_cicle[z].ab_freestand = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFFreestanding", reference.freestanding:list())
    antiaim_cicle[z].ab_lby_l = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Left", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab_lby_r = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFDesync Right", 0, 60, 60, 1, "°")
    antiaim_cicle[z].ab_def_aa = antiaim_cicle[z].ab_create:switch("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFEnable Defensive AA")
    antiaim_cicle[z].ab_def_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFType", {"On Peek", "Always On", "Visible Only", "Hittable"})
    antiaim_cicle[z].ab_def_yaw_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFYaw", {"Default", "Custom", "Spin", "180Z"})
    antiaim_cicle[z].ab_yaw_sens = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFSensitivity", 10, 100, 50, 1, "°")
    antiaim_cicle[z].ab_def_pitch_type = antiaim_cicle[z].ab_create:combo("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", {"Zero", "Down", "Up", "Random", "Custom"})
    antiaim_cicle[z].ab_def_pitch = antiaim_cicle[z].ab_create:slider("\v"..aa_table.cnd_aa[z].." ~ \aFFFFFFFFPitch", -89, 89, 0, 1, "°")
end

local ab_enabler_check = false

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
            if other_table.check_print:get(3) then
                render.log("Anti~Bruteforce Switched Due To \a74FF34FF"..player:get_name().." \aFFFFFFFFShot")
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


local function aa_setup(cmd)
    reference.enable:set(aa_table.enable_aa:get())
    if not aa_table.enable_aa:get() then return end
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = bit.band(local_player.m_fFlags, 1) == 0
    crouch = local_player.m_flDuckAmount > 0.5
    vx, vy = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y
    move = math.sqrt(vx ^ 2 + vy ^ 2) > 5
    if antiaim_cicle[2].enable:get() and current_state() == "Standing" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 2
    elseif antiaim_cicle[3].enable:get() and current_state() == "Running" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 3
    elseif antiaim_cicle[4].enable:get() and current_state() == "Walking" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 4
    elseif antiaim_cicle[5].enable:get() and current_state() == "Ducking" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 5
    elseif antiaim_cicle[6].enable:get() and current_state() == "Air" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 6
    elseif antiaim_cicle[7].enable:get() and current_state() == "Air+C" and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and not (antiaim_cicle[8].enable:get() and rage.exploit:get() < 0.9) then id = 7
    elseif antiaim_cicle[8].enable:get() and (rage.exploit:get() < 0.9) and not (antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32) and rage.exploit:get() < 0.9 then id = 8 --fl
    elseif antiaim_cicle[9].enable:get() and bit.band(cmd.buttons, 32) == 32 then id = 9
    else
        id = 1
    end
    if antiaim_cicle[id].ab_enable:get() then
        ab_enabler_check = true
    else
        ab_enabler_check = false
    end
    
    if (time_antibrute + 2 > globals.realtime and ab_enabler_check == true) then
        hidden = antiaim_cicle[id].ab_def_aa:get()
        def_type = antiaim_cicle[id].ab_def_yaw_type:get()
        def_sens = antiaim_cicle[id].ab_yaw_sens:get()
        def_pitch_type = antiaim_cicle[id].ab_def_pitch_type:get()
        trigger_type = antiaim_cicle[id].ab_def_type:get()
        def_pitch = antiaim_cicle[id].ab_def_pitch:get()
        jit_type = antiaim_cicle[id].ab_jit_type:get()
        jitter_type = antiaim_cicle[id].ab_jitter_type:get()
        center_l = antiaim_cicle[id].ab_jitter_center_left:get()
        center_r = antiaim_cicle[id].ab_jitter_center_right:get()
        center = antiaim_cicle[id].ab_jitter_center:get()
        body_yaw = antiaim_cicle[id].ab_bodyyaw:get()
        options = antiaim_cicle[id].ab_options:get()
        freestand = antiaim_cicle[id].ab_freestand:get()
        lby_r = antiaim_cicle[id].ab_lby_r:get()
        lby_l = antiaim_cicle[id].ab_lby_l:get()
        yaw_type = antiaim_cicle[id].ab_yaw_type:get()
        yaw_l = antiaim_cicle[id].ab_yaw_l:get()
        yaw_r = antiaim_cicle[id].ab_yaw_r:get()
        delay_type = antiaim_cicle[id].ab_delay_type:get()
    else
        hidden = antiaim_cicle[id].def_aa:get()
        def_type = antiaim_cicle[id].def_yaw_type:get()
        def_sens = antiaim_cicle[id].yaw_sens:get()
        def_pitch_type = antiaim_cicle[id].def_pitch_type:get()
        trigger_type = antiaim_cicle[id].def_type:get()
        def_pitch = antiaim_cicle[id].def_pitch:get()
        jit_type = antiaim_cicle[id].jit_type:get()
        jitter_type = antiaim_cicle[id].jitter_type:get()
        center_l = antiaim_cicle[id].jitter_center_left:get()
        center_r = antiaim_cicle[id].jitter_center_right:get()
        center = antiaim_cicle[id].jitter_center:get()
        body_yaw = antiaim_cicle[id].bodyyaw:get()
        options = antiaim_cicle[id].options:get()
        freestand = antiaim_cicle[id].freestand:get()
        lby_r = antiaim_cicle[id].lby_r:get()
        lby_l = antiaim_cicle[id].lby_l:get()
        yaw_type = antiaim_cicle[id].yaw_type:get()
        yaw_l = antiaim_cicle[id].yaw_l:get()
        yaw_r = antiaim_cicle[id].yaw_r:get()
        delay_type = antiaim_cicle[id].delay_type:get()
    end

    reference.hidden:override(hidden)
    if hidden then
        ---yaw
        if def_type == "Custom" then
            if yaw_adds <= 179 then
                yaw_adds = yaw_adds +def_sens
            else
                yaw_adds = -(yaw_adds+180)+def_sens
            end
            def_amount = yaw_adds
        elseif def_type == "180Z" then
            if spin_adds >= 180 then
                spin_adds = 0
            else
                spin_adds = spin_adds +10
            end
            def_amount = rage.antiaim:inverter() and spin_adds or spin_adds * -1
        elseif def_type == "Spin" then
            if sto_adds <= 179 then
                sto_adds = sto_adds +5
            else
                sto_adds = -(sto_adds+180)+5
            end
            def_amount = sto_adds
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
        else
            pitch_amount = def_pitch
        end
        --end
        if def_type ~= "Default" then
            rage.antiaim:override_hidden_yaw_offset(def_amount)
        end

        rage.antiaim:override_hidden_pitch(pitch_amount) 
        if trigger_type == "On Peek" then
            reference.lag:override("On Peek")
        elseif trigger_type == "Always On" then
            reference.lag:override("Always On")
            reference.hsopt:override("Break LC")
        elseif (trigger_type == "Hittable" and entity.get_threat(true) ~= nil) then
            reference.lag:override("Always On")
            reference.hsopt:override("Break LC")
        else
            reference.lag:override()
            reference.hsopt:override()
        end  
    else
        reference.lag:override()
        reference.hsopt:override()
    end
    if aa_table.break_lc:get() and jump then
        reference.lag:override("Always On")
    end
    if jitter_type == "L&R" then
	    reference.yawoff:override(rage.antiaim:inverter() and center_l or center_r)
    else
        reference.yawoff:override(center)
    end
    reference.yawmod:override(jit_type)
    reference.yaw:override("Backward")
    reference.bodyyaw:override(body_yaw)
    reference.options:override(options)
    reference.freestanding:override(freestand)
    reference.right_limit:override(lby_r)
    reference.left_limit:override(lby_l)
    if yaw_type == "Default" then
        reference.yawoffset:override(rage.antiaim:inverter() and yaw_l or yaw_r)
        reference.inverter:override(false)
    else        
        if cmd.choked_commands == 0 then
            tick_switch = tick_switch + 1
        end
        if delay_type == "Fast" then
            speed_tick = 2
        else
            speed_tick = 3
        end
        if tick_switch == speed_tick then
            reference.yawoffset:override(yaw_l)
            reference.inverter:override(true)
        end
        if tick_switch >= speed_tick*2 then
            reference.yawoffset:override(yaw_r)
            reference.inverter:override(false)
            tick_switch = 0
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
            reference.hidden:set(false)
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
            if aa_table.yaw_base_disabler:get("Hidden") then
                reference.hidden:override(false)
            end
            reference.yawbase:override("Local View")
        elseif aa_table.yaw_base:get() == "Right" then
            reference.yawoffset:override(85)
            if aa_table.yaw_base_disabler:get("Jitter") then
                reference.yawoff:override(0)
                reference.options:override("")
            end
            if aa_table.yaw_base_disabler:get("Hidden") then
                reference.hidden:override(false)
            end
            reference.yawbase:override("Local View")
        end
    end
    if id == 9 then
        legit_func(cmd)
        reference.yawbase:override("Local View")
        reference.pitch:override("Disabled")
    end

    if aa_table.huynya_ne_nuzhnaya:get("Edge Yaw") and reference.fd:get() then
        reference.yawoffset:set(edge_yaw_func())
        reference.yawbase:override("Local View")
        reference.disableyaw:set(true)
        reference.bodyfrees:set(true)
        reference.options:set("")
        reference.inverter:set(false)
        reference.yawoff:set(0)
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
        lp.m_flPoseParameter[0] = globals.tickcount%4 > 1 and 0.5 or 1
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
    antiaim_cicle[z].yaw_l:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].yaw_r:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].jit_type:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].jitter_type:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "Default"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center_left:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "L&R"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].jitter_center_right:depend(aa_table.enable_aa, enaa, need_select, {antiaim_cicle[z].jitter_type, "L&R"}, {antiaim_cicle[z].jit_type, function() if antiaim_cicle[z].jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].bodyyaw:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].lby_l:depend(aa_table.enable_aa, antiaim_cicle[z].bodyyaw, enaa, need_select)
    antiaim_cicle[z].lby_r:depend(aa_table.enable_aa, antiaim_cicle[z].bodyyaw, enaa, need_select)
    antiaim_cicle[z].options:depend(aa_table.enable_aa, antiaim_cicle[z].bodyyaw, enaa, need_select)
    antiaim_cicle[z].freestand:depend(aa_table.enable_aa, antiaim_cicle[z].bodyyaw, enaa, need_select)
    antiaim_cicle[z].def_aa:depend(aa_table.enable_aa, enaa, need_select)
    antiaim_cicle[z].def_type:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select)
    antiaim_cicle[z].def_pitch_type:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select)
    antiaim_cicle[z].def_pitch:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, {antiaim_cicle[z].def_pitch_type, "Custom"}, enaa, need_select)
    antiaim_cicle[z].def_yaw_type:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select)
    antiaim_cicle[z].yaw_sens:depend(aa_table.enable_aa, antiaim_cicle[z].def_aa, enaa, need_select, {antiaim_cicle[z].def_yaw_type, "Custom"})
    antiaim_cicle[z].ab_enable:depend(aa_table.enable_aa, enaa, need_select)
    ab_check = antiaim_cicle[z].ab_enable
    antiaim_cicle[z].ab_label:depend(aa_table.enable_aa, ab_check, enaa, need_select)

    antiaim_cicle[z].ab_yaw_type:depend(aa_table.enable_aa, ab_check, need_select, enaa)
    antiaim_cicle[z].ab_delay_type:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_yaw_type, function() if antiaim_cicle[z].ab_yaw_type:get() == "Default" then return false else return true end end})
    antiaim_cicle[z].ab_yaw_l:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab_yaw_r:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab_jit_type:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab_jitter_type:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_jit_type, function() if antiaim_cicle[z].ab_jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].ab_jitter_center:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_jitter_type, "Default"}, {antiaim_cicle[z].ab_jit_type, function() if antiaim_cicle[z].ab_jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].ab_jitter_center_left:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_jitter_type, "L&R"}, {antiaim_cicle[z].ab_jit_type, function() if antiaim_cicle[z].ab_jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].ab_jitter_center_right:depend(aa_table.enable_aa, ab_check, enaa, need_select, {antiaim_cicle[z].ab_jitter_type, "L&R"}, {antiaim_cicle[z].ab_jit_type, function() if antiaim_cicle[z].ab_jit_type:get() == "Disabled" then return false else return true end end})
    antiaim_cicle[z].ab_bodyyaw:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab_lby_l:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_bodyyaw, enaa, need_select)
    antiaim_cicle[z].ab_lby_r:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_bodyyaw, enaa, need_select)
    antiaim_cicle[z].ab_options:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_bodyyaw, enaa, need_select)
    antiaim_cicle[z].ab_freestand:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_bodyyaw, enaa, need_select)
    antiaim_cicle[z].ab_def_aa:depend(aa_table.enable_aa, ab_check, enaa, need_select)
    antiaim_cicle[z].ab_def_type:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_def_aa, enaa, need_select)
    antiaim_cicle[z].ab_def_yaw_type:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_def_aa, enaa, need_select)
    antiaim_cicle[z].ab_yaw_sens:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_def_aa, enaa, need_select, {antiaim_cicle[z].ab_def_yaw_type, "Custom"})
    antiaim_cicle[z].ab_def_pitch_type:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_def_aa, enaa, need_select)
    antiaim_cicle[z].ab_def_pitch:depend(aa_table.enable_aa, ab_check, antiaim_cicle[z].ab_def_aa, {antiaim_cicle[z].ab_def_pitch_type, "Custom"}, enaa, need_select)
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
    if visual_table.crosshair_style:get() == 1 then
        render.shadow(vector(space_lerp.x-15, screen_center.y + 40), vector(space_lerp.x+3, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.shadow(vector(space_lerp.x +8, screen_center.y + 40), vector(space_lerp.x + 15, screen_center.y + 40), color(255, 255, 255, math.pulse()), 20, 0, 0)
        render.text(2, vector(space_lerp.x-6, screen_center.y + 40), color(), "c", cross_gradient:get_animated_text())
        render.text(2, vector(space_lerp.x+14, screen_center.y + 40), color(visual_table.crosshair_color2:get().r, visual_table.crosshair_color2:get().g, visual_table.crosshair_color2:get().b, math.pulse()), "c", "ALPHA")
    else
        render.shadow(vector(space_lerp.x-22, screen_center.y + 40), vector(space_lerp.x+22, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.text(2, vector(space_lerp.x+2, screen_center.y + 40), color(), "c", cross_gradient2:get_animated_text())
        render.text(2, vector(space_lerp.x+2, screen_center.y + 30), color(visual_table.crosshair_color2:get().r, visual_table.crosshair_color2:get().g, visual_table.crosshair_color2:get().b, math.pulse()), "c", "ALPHA")
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
end

local function xueten()
   render.text(1, vector(screen_size.x-100, 39), color(255), nil, "discord.gg/\a8787FFFFsxc")
   render.shadow(vector(screen_size.x-100, 45), vector(screen_size.x-32, 45), color(255, 255, 255, 255), 20, 0, 0)
   render.text(1, vector(screen_size.x-93, 51), color(255), nil, "just_spacex")
end


damage_x = tabs.visuals:slider("dmg_x", 1, screen_size.x, screen_center.x + 10)
damage_y = tabs.visuals:slider("dmg_y", 1, screen_size.y, screen_center.y - 25)
damage_x:visibility(false)
damage_y:visibility(false)
local mindmg_drag = drag_system.register({damage_x, damage_y}, vector(20, 20), "MinDMG", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
	render.text(1, vector(self.position.x + 11, self.position.y + 10), color(), "cbd", ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
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
        render.shadow(vector(self.position.x+15, self.position.y+13), vector(self.position.x+175, self.position.y+29), color(255, 255, 255, math.floor(main.vel_alpha * 155)), 25, 0, 4)
        render.rect(vector(self.position.x+15, self.position.y+12), vector(self.position.x+175, self.position.y+30), color(50, 50, 50, math.floor(main.vel_alpha * 150)), 4)
        render.gradient(vector(self.position.x+15, self.position.y+13), vector(self.position.x+15 + main.size, self.position.y+29), gradient2, gradient1, gradient2, gradient1, 4)
        render.rect_outline(vector(self.position.x+15, self.position.y+12), vector(self.position.x+175, self.position.y+30), gradient2, 1, 4)
        render.text(1, vector(self.position.x+45, self.position.y+14), gradient3, nil, "Slowed Down: " ..math.floor(vel_mod * 100).." %")
        render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    end
end)

local function ts_arrows()
    local lp = entity.get_local_player()
    if (lp == nil or not lp:is_alive()) then return end
    MTools.Animation:Register("scope");
	MTools.Animation:Update("scope", 6);
	local scope = MTools.Animation:Lerp("scope", "scoping", (lp.m_bIsScoped), vector(screen_center.x, screen_center.y), vector(screen_center.x, screen_center.y-20), 30);
    render.poly(aa_table.yaw_base:get() == "Right" and visual_table.arrows_color:get() or color(35, 35, 35, 150), vector(scope.x+55, scope.y), vector(scope.x+42, scope.y-9), vector(scope.x+42, scope.y+9))
    render.poly(aa_table.yaw_base:get() == "Left" and visual_table.arrows_color:get() or color(35, 35, 35, 150), vector(scope.x-55, scope.y), vector(scope.x-42, scope.y-9), vector(scope.x-42, scope.y+9))   
    render.rect(vector(scope.x+38, scope.y-9), vector(scope.x+40, scope.y+9), rage.antiaim:inverter() == true and visual_table.arrows_color:get() or color(35, 35, 35, 120))
    render.rect(vector(scope.x-40, scope.y-9), vector(scope.x-38, scope.y+9), rage.antiaim:inverter() == false and visual_table.arrows_color:get() or color(35, 35, 35, 120))
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
            render.gradient(vector(x, y + (visual_table.Scopeoffset:get()-1)+1), vector(x + 1, y + visual_table.Scopelength:get() + (visual_table.Scopeoffset:get()-1)+1), SecondCol, SecondCol, FirstCol, FirstCol)
            render.gradient(vector((x+1 + (visual_table.Scopelength:get())) + (visual_table.Scopeoffset:get()-1), y), vector(x+1 + (visual_table.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
            render.gradient(vector(x, y - (visual_table.Scopeoffset:get()-1) - visual_table.Scopelength:get()), vector(x + 1, y - (visual_table.Scopeoffset:get()-1)), FirstCol, FirstCol, SecondCol, SecondCol)
            render.gradient(vector((x - visual_table.Scopelength:get()) - (visual_table.Scopeoffset:get()-1), y), vector(x - (visual_table.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
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
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
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
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
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
    else
        render.rect(vector(x, y), vector(x + w + 3, y + 20), color(0, 0, 0, alpha/2), 4)
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
pos_x:visibility(false)
pos_y:visibility(false)
pos_x1:visibility(false)
pos_y1:visibility(false)
local function render_watermark()
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
        window(x - text_size-19, 10, text_size + 4, 16, nexttext, 255)
    end
end
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


local logs = {}
local function ragebot_logs()
    local offset, x, y = 0, screen_size.x / 2, screen_size.y / 1.4
    for idx, data in ipairs(logs) do
        if globals.curtime - data[3] < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 4)
        else
            data[2] = math.lerp(data[2], 0, 4)
        end
        offset = offset - 20 * (data[2] / 255)
        text_size = render.measure_text(1, s, data[1])
        render.shadow(vector(x+13 - text_size.x / 2, y - offset+text_size.y-5), vector(x + 3 + text_size.x / 2, y - offset+text_size.y-5), color(255, 255, 255, data[2]), 35, -1, 0)
        render.text(1, vector(x + 9 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", data[1])
        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
end

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end
render.log("Stay With OG LEAKS FOR THE BEST LEAKS - IF NO THEN FUCK YOU :)")


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
        if cmd.sidemove == 0 then
            cmd.view_angles.y = cmd.view_angles.y + 45
        end
        if cmd.sidemove < 0 and cmd.in_forward then
            cmd.view_angles.y = cmd.view_angles.y + 90
        end
        if cmd.sidemove > 0 and cmd.in_back then
            cmd.view_angles.y = cmd.view_angles.y + 90
        end
        cmd.in_moveleft = cmd.in_back
        cmd.in_moveright = cmd.in_forward
        if cmd.view_angles.x < 0 then
            cmd.view_angles.x = -45
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
    rage.exploit:allow_defensive(true)
    local selected = lp:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    if string.match(wpn, "Grenade") then
        rage.exploit:allow_defensive(false)
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
    if other_table.teleport_wpn:get("Scout") and string.match(weapon, "SSG08") then tp_check = true end
    if other_table.teleport_wpn:get("Knife") and string.match(weapon, "Knife") then tp_check = true end
    if other_table.teleport_wpn:get("Taser") and string.match(weapon, "Taser") then tp_check = true end
    if other_table.teleport_wpn:get("Shotgun") and (string.match(weapon, "Mag7") or string.match(weapon, "Sawedoff") or string.match(weapon, "NOVA") or string.match(weapon, "XM1014")) then tp_check = true end
    if other_table.teleport_wpn:get("Pistols") and (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "DEagle") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000")) then tp_check = true end
    if other_table.teleport:get() and jump then
        if (tp_check == true and entity.get_threat(true) ~= nil) then
            rage.exploit:force_teleport()
            tp_check = false
            utils.execute_after(0.25, function()
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
		render.line(player_origin_screen, origin_screen, color(255, 255, 255, 255))
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
    if (jump and other_table.air_switch:get()) then
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
    if (other_table.scope_switch:get() and not scoped and ground) then
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

clan_anim = function(text, indices) if not globals.is_connected then return end local text_anim = '               ' .. text .. '                      '  local tickinterval = globals.tickinterval local tickcount = globals.tickcount + math.floor(utils.net_channel().avg_latency[0]+0.22 / globals.tickinterval + 0.5) local i = tickcount / math.floor(0.3 / globals.tickinterval + 0.5) i = math.floor(i % #indices) i = indices[i+1]+1 return string.sub(text_anim, i, i+15) end
local function clantag()
	if not globals.is_connected then return end
	if other_table.clantag:get() then
		if local_player ~= nil and globals.is_connected and globals.choked_commands then
			clan_tag = clan_anim('space.codes', {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
			if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
				clan_tag = clan_anim('space.codes', {12})
				common.set_clan_tag(clan_tag)
			elseif clan_tag ~= clan_tag_prev then
				common.set_clan_tag(clan_tag)
			end
			clan_tag_prev = clan_tag
		end
		enabled_prev = false
	elseif not other_table.clantag:get() and enabled_prev == false then
        common.set_clan_tag('')
        enabled_prev = true
	end
end

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
        cvar.sv_maxusrcmdprocessticks:float(other_table.fast_dt_select:get() == "Faster" and 15 or other_table.fast_dt_select:get() == "Fast" and 16 or other_table.fast_dt_select:get() == "Instant" and 18)
    else
        cvar.sv_maxusrcmdprocessticks:float(14)
    end
    aspect_value = math.lerp(aspect_value, other_table.aspect_ratio_slider:get()/100, 10)
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
    xueten()
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
            render_watermark()
        end
        if visual_table.solus_select:get(2) then
            new_drag_object:update()
        end
        if visual_table.solus_select:get(3) then
            new_drag_object1:update()
        end
    end
    if other_table.logs:get() then
        ragebot_logs()
    end
    clantag()
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
    check_console()
    if visual_table.snaplines:get() then
        snapline_func()
    end
end)

events.createmove:set(function(cmd)
    aa_setup(cmd)
    if other_table.fast_ladder:get() then
        fastladder(cmd)
    end
    if other_table.nade_fix:get() then
        fix_nade()
    end
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
end)

other_table.shared_icon:set_callback(function(self)
    local lp = entity.get_local_player()
    if lp == nil then return end
    if self:get() then
        lp:set_icon("https://media.discordapp.net/attachments/1112432776122216569/1124763774952415323/ALPHA.png?width=140&height=140")
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
    buffer:write_bits(0x1678, 16)
end)

events.round_start:set(function()
    events.voice_message:call(function(buffer)
        buffer:write_bits(0x1678, 16)
    end)
    if other_table.taskbar:get() then
        notify_round()
    end
    if other_table.check_print:get(3) then
        render.log("Anti~Bruteforce Angle Switched Due To New Round Start")
    end
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
        if other_table.check_print:get(1) then
            render.log(("Hit \a8FB9FFFF%s's \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if (other_table.printconsole:get() and other_table.check_print:get(1)) then
            print_raw(("» space.codes \a52B140[+] Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
    end
    if state ~= nil then
        if not other_table.logs:get() then return end
        if (other_table.check_print:get(2)) then
            render.log(('Missed \a8FB9FFFF%s \aFFFFFFFFin the %s due to \aFF3939FF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (bt: '..string.format("%.f", bt)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
        if (other_table.printconsole:get() and other_table.check_print:get(2)) then
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
            if (other_table.printconsole:get() and other_table.check_print:get(1)) then
                print_raw(('\a4562FF[space.codes] \aD5D5D5'..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if (other_table.check_print:get(1)) then
                render.log((type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
        end
    end
end)


---@Config System
local config_cfg = pui.setup({aa_table, other_table, visual_table, antiaim_cicle}, true)
local cfg_system = { }
configs_db = db.cfg_spacealpha or { }
configs_db.cfg_list = configs_db.cfg_list or {{'Default', 'W3siYWlyYnJlYWtlciI6IlN0YXRpYyBMZWdzIiwiYW5pbWJyZWFrZXIiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWUsImJyZWFrX2xjIjp0cnVlLCJjb25kaXRpb24iOiJcdTAwMDc0RjdDRkZGRkNyb3VjaCIsImVuYWJsZV9hYSI6dHJ1ZSwiZnJlZXNfdHlwZSI6MS4wLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJncm91bmRicmVha2VyIjoiSml0dGVyIiwiaHV5bnlhX25lX251emhuYXlhIjpbIn4iXSwibGVhbl92YWx1ZSI6MTAwLjAsIm90aGVyYnJlYWtlciI6WyJNb3ZlbWVudCBMZWFuIiwifiJdLCJwaXRjaCI6IkRvd24iLCJzYWZlX2hlYWQiOlsiS25pZmUiLCJ+Il0sInNoaXRfYWEiOiJTaGl0Iiwic3RhdGljX2ZyZWVzIjpbIk9uIE1hbnVhbCIsIn4iXSwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfYmFzZV9kaXNhYmxlciI6WyJIaWRkZW4iLCJ+Il19LHsiYWlyX2F3cCI6MjAuMCwiYWlyX3Bpc3RvbHMiOjg5LjAsImFpcl9zY291dCI6NDAuMCwiYWlyX3NlbGVjdCI6WyJTY291dCIsIlI4IiwifiJdLCJhaXJfc3dpdGNoIjp0cnVlLCJhc3BlY3RfcmF0aW8iOnRydWUsImFzcGVjdF9yYXRpb19zbGlkZXIiOjExNy4wLCJiYWltX2F3cCI6ODkuMCwiYmFpbV9yOCI6ODkuMCwiYmFpbV9zY291dCI6NzQuMCwiYmFpbV9zZWxlY3QiOlsiU2NvdXQiLCJ+Il0sImJhaW1fc3dpdGNoIjpmYWxzZSwiY2hlY2tfcHJpbnQiOlsxLjAsMi4wLDMuMCwifiJdLCJjbGFudGFnIjpmYWxzZSwiZHJvcF9uYWRlcyI6MC4wLCJmYXN0X2R0Ijp0cnVlLCJmYXN0X2R0X3NlbGVjdCI6IkZhc3QiLCJmYXN0X2xhZGRlciI6dHJ1ZSwianVtcHNjb3V0Ijp0cnVlLCJsb2dzIjp0cnVlLCJtdXRlX3NldCI6Ik11dGUiLCJtdXRlX3VubXV0ZSI6ZmFsc2UsIm5hZGVfZml4IjpmYWxzZSwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInByaW50Y29uc29sZSI6dHJ1ZSwic2FmZV9hd3AiOjg5LjAsInNhZmVfcjgiOjg5LjAsInNhZmVfc2NvdXQiOjc0LjAsInNhZmVfc2VsZWN0IjpbIlNjb3V0IiwifiJdLCJzYWZlX3N3aXRjaCI6ZmFsc2UsInNjb3BlX2F1dG8iOjg5LjAsInNjb3BlX2F3cCI6ODkuMCwic2NvcGVfc2NvdXQiOjg5LjAsInNjb3BlX3NlbGVjdCI6WyJ+Il0sInNjb3BlX3N3aXRjaCI6ZmFsc2UsInRhc2tiYXIiOnRydWUsInRlbGVwb3J0IjpmYWxzZSwidGVsZXBvcnRfd3BuIjpbIktuaWZlIiwiU2NvdXQiLCJBV1AiLCJ+Il0sInRyYXNodGFsayI6ZmFsc2UsInZpZXdtb2RlbCI6dHJ1ZSwidmlld21vZGVsX2ZvdiI6NDAuMCwidmlld21vZGVsX3giOjIuMCwidmlld21vZGVsX3kiOjEuMCwidmlld21vZGVsX3oiOjMuMH0seyJTY29wZWludmVydGVkIjpmYWxzZSwiU2NvcGVsZW5ndGgiOjc1LjAsIlNjb3Blb2Zmc2V0Ijo1LjAsImFycm93cyI6dHJ1ZSwiYXJyb3dzX2NvbG9yIjoiIzM1OERGRkZGIiwiY2xyX2NvbnNvbGUiOiIjNjQ2NDY0NjQiLCJjb25zb2xlX2NvbG9yIjpmYWxzZSwiY3Jvc3NoYWlyIjp0cnVlLCJjcm9zc2hhaXJfY29sb3IxIjoiIzAwQTdGRkZGIiwiY3Jvc3NoYWlyX2NvbG9yMiI6IiMzNUMwRkZGRiIsImNyb3NzaGFpcl9zdHlsZSI6Mi4wLCJncmVuYWRlX3JhZGl1cyI6dHJ1ZSwiZ3JlbmFkZV9zZWxlY3QiOlsxLjAsMi4wLCJ+Il0sIm1pbmRtZyI6dHJ1ZSwibW9sb3Rvdl9jb2xvciI6IiNGRkRGMDBCRSIsInNjb3BlIjp0cnVlLCJzY29wZV9jb2xvciI6IiNGRkZGRkZGRiIsInNlbnNlX2luZCI6ZmFsc2UsInNlbnNlX3NlbGVjdCI6WzEuMCwyLjAsMy4wLDQuMCw1LjAsNi4wLDcuMCw4LjAsOS4wLDEwLjAsMTEuMCwifiJdLCJzbG93ZWRfZG93biI6dHJ1ZSwic2xvd2VkX2Rvd25fY29sb3IiOiIjMkYyRjJGRkYiLCJzbG93ZWRfZG93bl9jb2xvcjIiOiIjOUE2NUZGNDIiLCJzbG93ZWRfZG93bl9jb2xvcjMiOiIjRkZGRkZGRkYiLCJzbW9rZV9jb2xvciI6IiM3QzdDN0NCNCIsInNuYXBsaW5lcyI6dHJ1ZSwic29sdXMiOnRydWUsInNvbHVzX2NvbG9yIjoiIzM1QzBGRkZGIiwic29sdXNfZ2xvdyI6dHJ1ZSwic29sdXNfc2VsZWN0IjpbMi4wLCJ+Il0sInNvbHVzX3R5cGUiOjIuMCwic29sdXNrZXlfdHlwZSI6Mi4wLCJzb2x1c3NwZWNfdHlwZSI6Mi4wfSxbeyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6ZmFsc2UsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzMuMCwiYWJfeWF3X3IiOjQwLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiMy1XYXkiLCJqaXR0ZXJfY2VudGVyIjo0MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MTcuMCwieWF3X3IiOjE3LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzMuMCwiYWJfeWF3X3IiOjM4LjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjM1LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6dHJ1ZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiU2xvdyIsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfZnJlZXN0YW5kIjoiT2ZmIiwiYWJfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWJfbGJ5X2wiOjYwLjAsImFiX2xieV9yIjo2MC4wLCJhYl9vcHRpb25zIjpbIn4iXSwiYWJfeWF3X2wiOi0zNS4wLCJhYl95YXdfciI6NDUuMCwiYWJfeWF3X3NlbnMiOjUwLjAsImFiX3lhd190eXBlIjoiRGVsYXkgU3dpdGNoIiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiU2xvdyIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6NDAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjQuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IjE4MFoiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOi0xODAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOi0xNS4wLCJ5YXdfciI6MzUuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjp0cnVlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjMwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6dHJ1ZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjo0LjAsImFiX2RlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiYWJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlIjoiQ3VzdG9tIiwiYWJfZGVsYXlfdHlwZSI6IlNsb3ciLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMjAuMCwiYWJfeWF3X3IiOjUwLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6Mi4wLCJkZWZfcGl0Y2hfdHlwZSI6IlVwIiwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJDdXN0b20iLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xNy4wLCJ5YXdfciI6NDcuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImRlbGF5X3R5cGUiOiJGYXN0IiwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkNlbnRlciIsImppdHRlcl9jZW50ZXIiOi03Ni4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJ5YXdfbCI6MTAuMCwieWF3X3IiOjAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6ZmFsc2UsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjoxODAuMCwieWF3X3IiOjE4MC4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In1dXQ=='}}
configs_db.menu_list = configs_db.menu_list or {'Default'}

configs_db.cfg_list[1][2] = "W3siYWlyYnJlYWtlciI6IlN0YXRpYyBMZWdzIiwiYW5pbWJyZWFrZXIiOnRydWUsImFudGlfYmFja3N0YWIiOnRydWUsImJyZWFrX2xjIjp0cnVlLCJjb25kaXRpb24iOiJcdTAwMDc0RjdDRkZGRkNyb3VjaCIsImVuYWJsZV9hYSI6dHJ1ZSwiZnJlZXNfdHlwZSI6MS4wLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJncm91bmRicmVha2VyIjoiSml0dGVyIiwiaHV5bnlhX25lX251emhuYXlhIjpbIn4iXSwibGVhbl92YWx1ZSI6MTAwLjAsIm90aGVyYnJlYWtlciI6WyJNb3ZlbWVudCBMZWFuIiwifiJdLCJwaXRjaCI6IkRvd24iLCJzYWZlX2hlYWQiOlsiS25pZmUiLCJ+Il0sInNoaXRfYWEiOiJTaGl0Iiwic3RhdGljX2ZyZWVzIjpbIk9uIE1hbnVhbCIsIn4iXSwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfYmFzZV9kaXNhYmxlciI6WyJIaWRkZW4iLCJ+Il19LHsiYWlyX2F3cCI6MjAuMCwiYWlyX3Bpc3RvbHMiOjg5LjAsImFpcl9zY291dCI6NDAuMCwiYWlyX3NlbGVjdCI6WyJTY291dCIsIlI4IiwifiJdLCJhaXJfc3dpdGNoIjp0cnVlLCJhc3BlY3RfcmF0aW8iOnRydWUsImFzcGVjdF9yYXRpb19zbGlkZXIiOjExNy4wLCJiYWltX2F3cCI6ODkuMCwiYmFpbV9yOCI6ODkuMCwiYmFpbV9zY291dCI6NzQuMCwiYmFpbV9zZWxlY3QiOlsiU2NvdXQiLCJ+Il0sImJhaW1fc3dpdGNoIjpmYWxzZSwiY2hlY2tfcHJpbnQiOlsxLjAsMi4wLDMuMCwifiJdLCJjbGFudGFnIjpmYWxzZSwiZHJvcF9uYWRlcyI6MC4wLCJmYXN0X2R0Ijp0cnVlLCJmYXN0X2R0X3NlbGVjdCI6IkZhc3QiLCJmYXN0X2xhZGRlciI6dHJ1ZSwianVtcHNjb3V0Ijp0cnVlLCJsb2dzIjp0cnVlLCJtdXRlX3NldCI6Ik11dGUiLCJtdXRlX3VubXV0ZSI6ZmFsc2UsIm5hZGVfZml4IjpmYWxzZSwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInByaW50Y29uc29sZSI6dHJ1ZSwic2FmZV9hd3AiOjg5LjAsInNhZmVfcjgiOjg5LjAsInNhZmVfc2NvdXQiOjc0LjAsInNhZmVfc2VsZWN0IjpbIlNjb3V0IiwifiJdLCJzYWZlX3N3aXRjaCI6ZmFsc2UsInNjb3BlX2F1dG8iOjg5LjAsInNjb3BlX2F3cCI6ODkuMCwic2NvcGVfc2NvdXQiOjg5LjAsInNjb3BlX3NlbGVjdCI6WyJ+Il0sInNjb3BlX3N3aXRjaCI6ZmFsc2UsInRhc2tiYXIiOnRydWUsInRlbGVwb3J0IjpmYWxzZSwidGVsZXBvcnRfd3BuIjpbIktuaWZlIiwiU2NvdXQiLCJBV1AiLCJ+Il0sInRyYXNodGFsayI6ZmFsc2UsInZpZXdtb2RlbCI6dHJ1ZSwidmlld21vZGVsX2ZvdiI6NDAuMCwidmlld21vZGVsX3giOjIuMCwidmlld21vZGVsX3kiOjEuMCwidmlld21vZGVsX3oiOjMuMH0seyJTY29wZWludmVydGVkIjpmYWxzZSwiU2NvcGVsZW5ndGgiOjc1LjAsIlNjb3Blb2Zmc2V0Ijo1LjAsImFycm93cyI6dHJ1ZSwiYXJyb3dzX2NvbG9yIjoiIzM1OERGRkZGIiwiY2xyX2NvbnNvbGUiOiIjNjQ2NDY0NjQiLCJjb25zb2xlX2NvbG9yIjpmYWxzZSwiY3Jvc3NoYWlyIjp0cnVlLCJjcm9zc2hhaXJfY29sb3IxIjoiIzAwQTdGRkZGIiwiY3Jvc3NoYWlyX2NvbG9yMiI6IiMzNUMwRkZGRiIsImNyb3NzaGFpcl9zdHlsZSI6Mi4wLCJncmVuYWRlX3JhZGl1cyI6dHJ1ZSwiZ3JlbmFkZV9zZWxlY3QiOlsxLjAsMi4wLCJ+Il0sIm1pbmRtZyI6dHJ1ZSwibW9sb3Rvdl9jb2xvciI6IiNGRkRGMDBCRSIsInNjb3BlIjp0cnVlLCJzY29wZV9jb2xvciI6IiNGRkZGRkZGRiIsInNlbnNlX2luZCI6ZmFsc2UsInNlbnNlX3NlbGVjdCI6WzEuMCwyLjAsMy4wLDQuMCw1LjAsNi4wLDcuMCw4LjAsOS4wLDEwLjAsMTEuMCwifiJdLCJzbG93ZWRfZG93biI6dHJ1ZSwic2xvd2VkX2Rvd25fY29sb3IiOiIjMkYyRjJGRkYiLCJzbG93ZWRfZG93bl9jb2xvcjIiOiIjOUE2NUZGNDIiLCJzbG93ZWRfZG93bl9jb2xvcjMiOiIjRkZGRkZGRkYiLCJzbW9rZV9jb2xvciI6IiM3QzdDN0NCNCIsInNuYXBsaW5lcyI6dHJ1ZSwic29sdXMiOnRydWUsInNvbHVzX2NvbG9yIjoiIzM1QzBGRkZGIiwic29sdXNfZ2xvdyI6dHJ1ZSwic29sdXNfc2VsZWN0IjpbMi4wLCJ+Il0sInNvbHVzX3R5cGUiOjIuMCwic29sdXNrZXlfdHlwZSI6Mi4wLCJzb2x1c3NwZWNfdHlwZSI6Mi4wfSxbeyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6ZmFsc2UsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzMuMCwiYWJfeWF3X3IiOjQwLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiMy1XYXkiLCJqaXR0ZXJfY2VudGVyIjo0MC4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MTcuMCwieWF3X3IiOjE3LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2JvZHl5YXciOnRydWUsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMzMuMCwiYWJfeWF3X3IiOjM4LjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjM1LjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6dHJ1ZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiU2xvdyIsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfZnJlZXN0YW5kIjoiT2ZmIiwiYWJfaml0X3R5cGUiOiJEaXNhYmxlZCIsImFiX2ppdHRlcl9jZW50ZXIiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImFiX2ppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiYWJfaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwiYWJfbGJ5X2wiOjYwLjAsImFiX2xieV9yIjo2MC4wLCJhYl9vcHRpb25zIjpbIn4iXSwiYWJfeWF3X2wiOi0zNS4wLCJhYl95YXdfciI6NDUuMCwiYWJfeWF3X3NlbnMiOjUwLjAsImFiX3lhd190eXBlIjoiRGVsYXkgU3dpdGNoIiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiU2xvdyIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6NDAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjQuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IjE4MFoiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOi0xODAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOi0xNS4wLCJ5YXdfciI6MzUuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjp0cnVlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiZGVsYXlfdHlwZSI6IkZhc3QiLCJlbmFibGUiOnRydWUsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzAuMCwieWF3X3IiOjMwLjAsInlhd19zZW5zIjo1MC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfYm9keXlhdyI6dHJ1ZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjo0LjAsImFiX2RlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiYWJfZGVmX3R5cGUiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlIjoiQ3VzdG9tIiwiYWJfZGVsYXlfdHlwZSI6IlNsb3ciLCJhYl9lbmFibGUiOnRydWUsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjotMjAuMCwiYWJfeWF3X3IiOjUwLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCIsImJvZHl5YXciOnRydWUsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6Mi4wLCJkZWZfcGl0Y2hfdHlwZSI6IlVwIiwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJDdXN0b20iLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6dHJ1ZSwiZnJlZXN0YW5kIjoiT2ZmIiwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwiaml0dGVyX2NlbnRlcl9sZWZ0IjowLjAsImppdHRlcl9jZW50ZXJfcmlnaHQiOjAuMCwiaml0dGVyX3R5cGUiOiJEZWZhdWx0IiwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xNy4wLCJ5YXdfciI6NDcuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9ib2R5eWF3IjpmYWxzZSwiYWJfZGVmX2FhIjpmYWxzZSwiYWJfZGVmX3BpdGNoIjowLjAsImFiX2RlZl9waXRjaF90eXBlIjoiWmVybyIsImFiX2RlZl90eXBlIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJhYl9kZWxheV90eXBlIjoiRmFzdCIsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2ZyZWVzdGFuZCI6Ik9mZiIsImFiX2ppdF90eXBlIjoiRGlzYWJsZWQiLCJhYl9qaXR0ZXJfY2VudGVyIjowLjAsImFiX2ppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImFiX2ppdHRlcl90eXBlIjoiRGVmYXVsdCIsImFiX2xieV9sIjo2MC4wLCJhYl9sYnlfciI6NjAuMCwiYWJfb3B0aW9ucyI6WyJ+Il0sImFiX3lhd19sIjowLjAsImFiX3lhd19yIjowLjAsImFiX3lhd19zZW5zIjo1MC4wLCJhYl95YXdfdHlwZSI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJaZXJvIiwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImRlbGF5X3R5cGUiOiJGYXN0IiwiZW5hYmxlIjp0cnVlLCJmcmVlc3RhbmQiOiJPZmYiLCJqaXRfdHlwZSI6IkNlbnRlciIsImppdHRlcl9jZW50ZXIiOi03Ni4wLCJqaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJqaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJ5YXdfbCI6MTAuMCwieWF3X3IiOjAuMCwieWF3X3NlbnMiOjUwLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfYm9keXlhdyI6ZmFsc2UsImFiX2RlZl9hYSI6ZmFsc2UsImFiX2RlZl9waXRjaCI6MC4wLCJhYl9kZWZfcGl0Y2hfdHlwZSI6Ilplcm8iLCJhYl9kZWZfdHlwZSI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYWJfZGVsYXlfdHlwZSI6IkZhc3QiLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9mcmVlc3RhbmQiOiJPZmYiLCJhYl9qaXRfdHlwZSI6IkRpc2FibGVkIiwiYWJfaml0dGVyX2NlbnRlciI6MC4wLCJhYl9qaXR0ZXJfY2VudGVyX2xlZnQiOjAuMCwiYWJfaml0dGVyX2NlbnRlcl9yaWdodCI6MC4wLCJhYl9qaXR0ZXJfdHlwZSI6IkRlZmF1bHQiLCJhYl9sYnlfbCI6NjAuMCwiYWJfbGJ5X3IiOjYwLjAsImFiX29wdGlvbnMiOlsifiJdLCJhYl95YXdfbCI6MC4wLCJhYl95YXdfciI6MC4wLCJhYl95YXdfc2VucyI6NTAuMCwiYWJfeWF3X3R5cGUiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiWmVybyIsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IkRlZmF1bHQiLCJkZWxheV90eXBlIjoiRmFzdCIsImVuYWJsZSI6ZmFsc2UsImZyZWVzdGFuZCI6Ik9mZiIsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImppdHRlcl9jZW50ZXJfbGVmdCI6MC4wLCJqaXR0ZXJfY2VudGVyX3JpZ2h0IjowLjAsImppdHRlcl90eXBlIjoiRGVmYXVsdCIsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjoxODAuMCwieWF3X3IiOjE4MC4wLCJ5YXdfc2VucyI6NTAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In1dXQ=="
cfg_system.save_config = function(id)
    if id == 1 then return end
    local raw = config_cfg:save()
    configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
    db.cfg_spacealpha = configs_db
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
    db.cfg_spacealpha = configs_db
end

cfg_system.remove_config = function(id)
    if id == 1 then return end
    local item = configs_db.cfg_list[id][1]
    for i=#configs_db.cfg_list, 1, -1 do if configs_db.cfg_list[i][1] == item then table.remove(configs_db.cfg_list, i) table.remove(configs_db.menu_list, i) end end
    db.cfg_spacealpha = configs_db
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
    db.cfg_spacealpha = configs_db
end)