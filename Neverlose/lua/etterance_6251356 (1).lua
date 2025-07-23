-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local MTools = require("neverlose/mtools")
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local pui = require("neverlose/pui")

local style = ui.get_style "Button"
local style_hex = style:to_hex()

local gradient_animation = gradient.text_animate(" ~ debug", -0.57, {
    color(100, 100, 100),
    color(150, 150, 150)
})
local gradient_animation1 = gradient.text_animate("Etterance", 0.5, {
    color(100, 100, 100),
    color(150, 150, 150)
})
local icon = "\a" .. color(100, 100, 100, 255):to_hex() .. ui.get_icon("comet")
ui.sidebar(gradient_animation1:get_animated_text()..gradient_animation:get_animated_text(), icon)

local tabs = {
    main2 = pui.create(" 🏠 ", ui.get_icon('comet').." Main ", 1),
    main = pui.create(" 🏠 ", ui.get_icon('rss').." Recomendations ", 2),
    main1 = pui.create(" 🏠 ", ui.get_icon('gear').." Configs ", 2),
    turn = pui.create(" 🛡️ ", ui.get_icon('ballot-check').."  Switcher     ", 1),
    antiselect = pui.create(" 🛡️ ", ui.get_icon('ballot-check').."  Condition     ", 1),
    anti1 = pui.create(" 🛡️ ", ui.get_icon('star').."  Main     ", 1),
    antisel = pui.create(" 🛡️ ", ui.get_icon('star').."  Select     ", 2),
    configs = pui.create(" 🛡️ ", ui.get_icon('layer-plus').."  Config System     ", 2),
    anti2 = pui.create(" 🛡️ ", ui.get_icon('sliders').." Builder ", 2),
    antid = pui.create(" 🛡️ ", ui.get_icon('shield').."  Defensive   ", 1),
    antib = pui.create(" 🛡️ ", ui.get_icon('sliders-up').."  Anti~Bruteforce   ", 1),
    misc = pui.create(" ⚙️ ", ui.get_icon('star').." Misc ", 1),
    mod = pui.create(" ⚙️ ", ui.get_icon('star').." Modifications ", 1),
    visuals = pui.create(" ⚙️ ", ui.get_icon('rocket').." Visuals ", 2),
    inter = pui.create(" ⚙️ ", ui.get_icon('rocket').." Interface ", 2),
}

tabs.main2:label(" »   Welcome, \bFFFFFFFF\b"..style_hex.."["..common.get_username().."]")
tabs.main2:label(" »   Author - \bFFFFFFFF\b"..style_hex.."[blameless1337]")
tabs.main2:label(" »   Stay with us -  \bFFFFFFFF\b"..style_hex.."[Etterance.tech]")
tabs.main2:label(" »   Version - \bFFFFFFFF\b"..style_hex.."[debug]")

tabs.main:button("         \a7E92FFFF"..ui.get_icon('discord').."         ",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/JENgqECxRX")
end, true) 

tabs.main:button("         \aFF1D1DFF"..ui.get_icon('youtube').."         ",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/c/blameless")
end, true) 

tabs.main:button("          \a7E92FFFF"..ui.get_icon('gear').."          ",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=awr33Z")
end, true) 

local cond_aa = {"\vGlobal", "\vStanding", "\vRunning", "\vWalking", "\vDucking", "\vAir", "\vAir+C", "\vFake~Lag"}
local cnd_aa = {"\vG", "\vS", "\vR", "\vW", "\vD", "\vA", "\vA+C", "\vF"}
local main_aa = {}
main_aa.enable_list = tabs.turn:list("", {"\v"..ui.get_icon('caret-right').."\r Disa\vbled", "\v"..ui.get_icon('caret-right').."\r Ena\vbled"})
main_aa.select_tab = tabs.antisel:list("", {"\v"..ui.get_icon('caret-right').."\r Ma\vin", "\v"..ui.get_icon('caret-right').."\r Bu\vilder"}):depend({main_aa.enable_list, 2})
main_aa.condition = tabs.anti2:combo("\b"..style_hex.."\bFFFFFFFF[Condition]", cond_aa):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 2})
main_aa.pitch_set = tabs.anti1:combo("Pi\b"..style_hex.."\bFFFFFFFF[tch]", {'Disabled', 'Down', 'Fake Down', 'Fake Up'}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.custom_yaw_base = tabs.anti1:combo("Yaw \b"..style_hex.."\bFFFFFFFF[Base]", {"Backward", "At Target", "Forward", "Left", "Right"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.freestand = tabs.anti1:switch("Frees\b"..style_hex.."\bFFFFFFFF[tanding]"):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.freestand_create = main_aa.freestand:create()
main_aa.staticfrees = main_aa.freestand_create:listable("Disablers", {"Jitter", "Defensive"})
main_aa.anims = tabs.anti1:switch("\b"..style_hex.."\bFFFFFFFF[Animation Breaker]"):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.anims_create = main_aa.anims:create()
main_aa.groundbreaker = main_aa.anims_create:combo("Ground", {"Off", "Follow Direction", "Jitter", "Jitter Slide", "MoonWalk"}):depend(main_aa.anims)
main_aa.airbreaker = main_aa.anims_create:combo("Air", {"Off", "Static Legs In Air", "MoonWalk"}):depend(main_aa.anims)
main_aa.othbreaker = main_aa.anims_create:selectable("Addons", {"Pitch 0 On Land", "Move Lean", "Jitter Head"}):depend(main_aa.anims)
main_aa.legs_jit = main_aa.anims_create:slider("Jitter Legs", 0, 100, 80):depend(main_aa.anims, {main_aa.groundbreaker, "Jitter"})
main_aa.wpn_select = tabs.anti1:selectable("Safe Head In Air", {"Knife", "Zeus", "Grenade", "Scout", "Awp"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.additions = tabs.anti1:selectable("Additions", {"Shit AA On Warmup", "Anti~Backstab"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})

local other_visual = {}

local abshots = 0
other_visual.panel_enable = tabs.visuals:switch(ui.get_icon('square-info').."   InfoPanel")
other_visual.panel_create = other_visual.panel_enable:create()
other_visual.panel_create:button(ui.get_icon("gun").." Clear Anti~Bruteforce Data "..ui.get_icon("gun"),function()
    abshots = 0
end, true):depend(other_visual.panel_enable)
other_visual.enablelogs = tabs.visuals:switch(ui.get_icon('blog').."   Ragebot logs")
other_visual.logs_ref = other_visual.enablelogs:create()
other_visual.printconsole = other_visual.logs_ref:listable("", {"Console", "Event", "Screen"}):depend(other_visual.enablelogs)
other_visual.emoji_check = other_visual.logs_ref:switch("Emoji", true):depend(other_visual.enablelogs, {other_visual.printconsole, 3})

other_visual.ScopeCustom = tabs.visuals:switch(ui.get_icon('crosshairs').."   Custom Scope")
other_visual.scopegroup = other_visual.ScopeCustom:create()
other_visual.Scopeinverted = other_visual.scopegroup:switch("Invert scope lines", false):depend(other_visual.ScopeCustom)
other_visual.Scopelength = other_visual.scopegroup:slider("Scope length", 5, 200, 55):depend(other_visual.ScopeCustom)
other_visual.Scopeoffset = other_visual.scopegroup:slider("Scope offset", 1, 50, 11):depend(other_visual.ScopeCustom)
other_visual.grenade_radius = tabs.visuals:switch("\f<circle-dashed>   Grenade Radius")
other_visual.grenade_radius_create = other_visual.grenade_radius:create()
other_visual.grenade_select = other_visual.grenade_radius_create:listable("", {"Smoke", "Molotov"}):depend(other_visual.grenade_radius)
other_visual.molotov_color = other_visual.grenade_radius_create:color_picker("Team Molotov Color", color(116, 192, 41, 255)):depend(other_visual.grenade_radius, {other_visual.grenade_select, 2})
other_visual.enemy_molotov_color = other_visual.grenade_radius_create:color_picker("Enemy Molotov Color", color(255, 63, 63, 190)):depend(other_visual.grenade_radius, {other_visual.grenade_select, 2})
other_visual.smoke_color = other_visual.grenade_radius_create:color_picker("Smoke Color", color(61, 147, 250, 180)):depend(other_visual.grenade_radius, {other_visual.grenade_select, 1})
other_visual.MinDMG = tabs.visuals:switch(ui.get_icon('eye').."   Min DMG Indicator")
other_visual.mindmggroup = other_visual.MinDMG:create()

other_visual.velocity_indicator_enable = tabs.inter:switch(ui.get_icon('triangle-exclamation').."   Slowed Down Indicator")
other_visual.velocity_indicator_gear = other_visual.velocity_indicator_enable:create()
other_visual.defensive_indicator_enable = tabs.inter:switch(ui.get_icon('brain').."   Defensive Manager")
other_visual.defensive_indicator_gear = other_visual.defensive_indicator_enable:create()
other_visual.Indicators = tabs.inter:switch(ui.get_icon('comet').."   Crosshair Indicator")
other_visual.indgroup = other_visual.Indicators:create()
other_visual.arrows = tabs.inter:switch(ui.get_icon('arrows-left-right-to-line').."   Manual Arrows")
other_visual.arrgroup = other_visual.arrows:create()
other_visual.arroffset = other_visual.arrgroup:slider("Arrows Offset", 15, 100, 50):depend(other_visual.arrows)
other_visual.custom_console = tabs.inter:switch("\f<rectangle-terminal>    Coming Soon")
other_visual.Widgets = tabs.inter:switch(ui.get_icon('palette').."   Solus UI")
other_visual.Widgetsgroup = other_visual.Widgets:create()
other_visual.solus_widgets = other_visual.Widgetsgroup:listable("", {"Watermark", "Keybinds", "Spectator list"}):depend(other_visual.Widgets)
other_visual.sol_emoji = other_visual.Widgetsgroup:switch("Emoji", true):depend(other_visual.Widgets)
other_visual.solus_type = other_visual.Widgetsgroup:list("", {"Default", "Modern", "Sense"}):depend(other_visual.Widgets)
other_visual.custom_name = other_visual.Widgetsgroup:input("Username", ""..common.get_username()..""):depend(other_visual.Widgets)


local misc_lua = {}
misc_lua.clantag = tabs.misc:switch(ui.get_icon('tag').."   Clantag")
misc_lua.viewmodel_switch = tabs.misc:switch(ui.get_icon('hands-holding').."  Viewmodel")
misc_lua.aspect_ratio_switch = tabs.misc:switch(ui.get_icon('eye').."  Aspect ratio")
misc_lua.viewmodel_ref = misc_lua.viewmodel_switch:create()
misc_lua.viewmodel_fov = misc_lua.viewmodel_ref:slider("FOV", -100, 100, 68):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_x = misc_lua.viewmodel_ref:slider("X", -10, 10, 2.5):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_y = misc_lua.viewmodel_ref:slider("Y", -10, 10, 0):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_z = misc_lua.viewmodel_ref:slider("Z", -10, 10, -1.5):depend(misc_lua.viewmodel_switch)
misc_lua.aspectratio_ref = misc_lua.aspect_ratio_switch:create()
misc_lua.aspect_ratio_slider = misc_lua.aspectratio_ref:slider("Value", 0, 200, 0):depend(misc_lua.aspect_ratio_switch)
misc_lua.round_notify = tabs.misc:switch(ui.get_icon('bell').."   Round Start Notify")
misc_lua.teleport = tabs.misc:switch("\f<transporter-1>  Auto Teleport In Air")
misc_lua.teleport_create = misc_lua.teleport:create()
misc_lua.teleport_wpn = misc_lua.teleport_create:selectable("Weapon", {"Taser", "Knife", "Scout", "AWP", "Shotgun", "Pistols"}):depend(misc_lua.teleport)

misc_lua.air_switch = tabs.mod:switch("\f<person-falling>    Custom Hitchance In Air")
misc_lua.air_switch_create = misc_lua.air_switch:create()
misc_lua.air_select = misc_lua.air_switch_create:selectable("Weapon", {"Scout", "R8", "Pistols"}):depend(misc_lua.air_switch)
misc_lua.air_scout = misc_lua.air_switch_create:slider("Scout HC", 0, 100, 89):depend(misc_lua.air_switch, {misc_lua.air_select, "Scout"})
misc_lua.air_awp = misc_lua.air_switch_create:slider("R8 HC", 0, 100, 89):depend(misc_lua.air_switch, {misc_lua.air_select, "R8"})
misc_lua.air_pistols = misc_lua.air_switch_create:slider("Pistols HC", 0, 100, 89):depend(misc_lua.air_switch, {misc_lua.air_select, "Pistols"})
misc_lua.no_fall_damage = tabs.mod:switch("\f<person-falling>    No Fall Damage")
misc_lua.avoid_colision = tabs.mod:switch(ui.get_icon('person-walking-arrow-loop-left').."  Avoid Collision")
misc_lua.avoid_create = misc_lua.avoid_colision:create()
misc_lua.avoid_distance = misc_lua.avoid_create:slider("Distance", 35, 100, 45):depend(misc_lua.avoid_colision)
misc_lua.fast_ladder = tabs.mod:switch(ui.get_icon('water-ladder').."   Fast Ladder")
misc_lua.fps_boost = tabs.mod:switch(ui.get_icon('chart-line').."  Fps Boost")
misc_lua.nade_fix = tabs.mod:switch(ui.get_icon('bomb').."   Nade Fix")

misc_lua.aspectratio_ref:button(" 5:4 ", function()
    misc_lua.aspect_ratio_slider:set(125)
end, true):depend(misc_lua.aspect_ratio_switch)
misc_lua.aspectratio_ref:button(" 4:3 ", function()
    misc_lua.aspect_ratio_slider:set(133)
end, true):depend(misc_lua.aspect_ratio_switch)
misc_lua.aspectratio_ref:button(" 3:2 ", function()
    misc_lua.aspect_ratio_slider:set(150)
end, true):depend(misc_lua.aspect_ratio_switch)
misc_lua.aspectratio_ref:button(" 16:10 ", function()
    misc_lua.aspect_ratio_slider:set(160)
end, true):depend(misc_lua.aspect_ratio_switch)
misc_lua.aspectratio_ref:button(" 16:9 ", function()
    misc_lua.aspect_ratio_slider:set(180)
end, true):depend(misc_lua.aspect_ratio_switch)

local colors_lua = {}
colors_lua.Indicatorscolor = other_visual.indgroup:color_picker("First color", color(100, 100, 100)):depend(other_visual.Indicators)
colors_lua.Indicatorscolortwo = other_visual.indgroup:color_picker("Second color", color(150, 150, 150)):depend(other_visual.Indicators)
colors_lua.Indicatorscolorthird = other_visual.indgroup:color_picker("Third color", color(255, 255, 255)):depend(other_visual.Indicators)
colors_lua.arrowscolor = other_visual.arrgroup:color_picker("Arrows Color", color(150, 150, 150)):depend(other_visual.arrows)
colors_lua.arrowscolor2 = other_visual.arrgroup:color_picker("Active Arrows Color", color(255, 255, 255)):depend(other_visual.arrows)
colors_lua.velocity_indicator_color_1 = other_visual.velocity_indicator_gear:color_picker("Main", color(255, 255, 255)):depend(other_visual.velocity_indicator_enable)
colors_lua.velocity_indicator_color_2 = other_visual.velocity_indicator_gear:color_picker("Second", color(0, 0, 0)):depend(other_visual.velocity_indicator_enable)
colors_lua.defensive_indicator_color_1 = other_visual.defensive_indicator_gear:color_picker("Main", color(255, 255, 255)):depend(other_visual.defensive_indicator_enable)
colors_lua.defensive_indicator_color_2 = other_visual.defensive_indicator_gear:color_picker("Second", color(0, 0, 0)):depend(other_visual.defensive_indicator_enable)
colors_lua.scopecol = other_visual.scopegroup:color_picker("Scope Сolor",color(255,255)):depend(other_visual.ScopeCustom)
colors_lua.log_color = other_visual.logs_ref:color_picker("Glow"):depend(other_visual.enablelogs, {other_visual.printconsole, 3})
colors_lua.text_col = other_visual.Widgetsgroup:color_picker("Text color", color(140, 144, 240)):depend(other_visual.Widgets)
colors_lua.shadow_col = other_visual.Widgetsgroup:color_picker("Glow color", color(120, 162, 255, 255)):depend(other_visual.Widgets)
colors_lua.panel_color1 = other_visual.panel_create:color_picker("Header Text Color", color(100, 100, 100)):depend(other_visual.panel_enable)
colors_lua.panel_color4 = other_visual.panel_create:color_picker("Line Color", color(255, 255, 255)):depend(other_visual.panel_enable)

---antiaim base
local ref = {
    enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
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
    lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hsopt = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    disableyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    bodyfrees = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    removesc = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    hc = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
}
aa_condition = {}
for z, x in pairs(cond_aa) do
    aa_condition[z] = {}
    aa_condition[z].enable = tabs.anti2:switch("❕ Override "..cond_aa[z].."\r Condition")
    aa_condition[z].yaw_type = tabs.anti2:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Default", "Delay Switch"})
    aa_condition[z].delay_ticks = tabs.anti2:slider(cnd_aa[z].."\r 🞄 Delay 🞄 Ticks", 1, 30, 0, 1, "°")
    aa_condition[z].yaw_l = tabs.anti2:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Left", -180, 180, 0, 1, "°")
    aa_condition[z].yaw_r = tabs.anti2:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Right", -180, 180, 0, 1, "°")
    aa_condition[z].jit_type = tabs.anti2:combo(cnd_aa[z].."\r 🞄 Jitter Type", ref.yawmod:list())
    aa_condition[z].jitter_center = tabs.anti2:slider(cnd_aa[z].."\r 🞄 Amount", -180, 180, 0, 1, "°")
    aa_condition[z].bodyyaw = tabs.anti2:switch(cnd_aa[z].."\r 🞄 Body Yaw")
    aa_condition[z].bodyyaw_create = aa_condition[z].bodyyaw:create()
    aa_condition[z].options = aa_condition[z].bodyyaw_create:selectable(cnd_aa[z].."\r 🞄 Options", ref.options:list())
    aa_condition[z].lby_l = aa_condition[z].bodyyaw_create:slider(cnd_aa[z].."\r 🞄 Desync Left", 0, 60, 60, 1, "°")
    aa_condition[z].lby_r = aa_condition[z].bodyyaw_create:slider(cnd_aa[z].."\r 🞄 Desync Right", 0, 60, 60, 1, "°")
    aa_condition[z].def_type = tabs.anti2:combo(cnd_aa[z].."\r 🞄 Defensive", {"On Peek", "Always On", "Only On DT"})
    aa_condition[z].def_aa = tabs.antid:switch(cnd_aa[z].."\r 🞄 Enable Defensive AA")
    aa_condition[z].def_yaw_type = tabs.antid:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "X-Way", "Custom"})
    aa_condition[z].def_yaw_create = aa_condition[z].def_yaw_type:create()
    aa_condition[z].def_side = aa_condition[z].def_yaw_create:slider("Side-Way Angle", 0, 180, 90)
    aa_condition[z].def_min = aa_condition[z].def_yaw_create:slider("Random Minimum", -50, 50, 20)
    aa_condition[z].def_max = aa_condition[z].def_yaw_create:slider("Random Maximum", -50, 50, 20)
    aa_condition[z].def_sens = aa_condition[z].def_yaw_create:slider("Sensitivity", 0, 100, 50)
    aa_condition[z].def_1way = aa_condition[z].def_yaw_create:slider("1 Way", -180, 180, 30)
    aa_condition[z].def_2way = aa_condition[z].def_yaw_create:slider("2 Way", -180, 180, 0)
    aa_condition[z].def_3way = aa_condition[z].def_yaw_create:slider("3 Way", -180, 180, -30)
    aa_condition[z].def_pitch_type = tabs.antid:combo(cnd_aa[z].."\r 🞄 Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})
    aa_condition[z].def_pitch_create = aa_condition[z].def_pitch_type:create()
    aa_condition[z].def_pitch = aa_condition[z].def_pitch_create:slider(cnd_aa[z].."\r 🞄 Amount", -89, 89, 0, 1, "°")
    aa_condition[z].ab_enable = tabs.antib:switch(cnd_aa[z].."\r 🞄 \b"..style_hex.."\bFFFFFFFF[Anti~Bruteforce]")
    
    aa_condition[z].ab_phases = tabs.antib:slider("Phases", 1, 3, 1)
    aa_condition[z].ab_phases:visibility(false)
    aa_condition[z].add_phases = tabs.antib:button(ui.get_icon('plus').."       Add Phase       "..ui.get_icon('plus'),function()
        aa_condition[z].ab_phases:set(aa_condition[z].ab_phases:get() + 1)
    end, true) 

    aa_condition[z].rem_phases = tabs.antib:button(ui.get_icon('minus').."  Remove Phase  "..ui.get_icon('minus'),function()
        aa_condition[z].ab_phases:set(aa_condition[z].ab_phases:get() - 1)
    end, true) 

    aa_condition[z].ab_phase1 = tabs.antib:label(cnd_aa[z].."\r 🞄 Phase 1")
    aa_condition[z].ab_create1 = aa_condition[z].ab_phase1:create()
    aa_condition[z].ab_select1 = aa_condition[z].ab_create1:selectable("", {"Yaw", "Desync", "Defensive"})
    aa_condition[z].ab_yaw_type1 = aa_condition[z].ab_create1:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Default", "Delay Switch"})
    aa_condition[z].ab_delay_ticks1 = aa_condition[z].ab_create1:slider(cnd_aa[z].."\r 🞄 Delay 🞄 Ticks", 1, 30, 0, 1, "°")
    aa_condition[z].ab_yaw_l1 = aa_condition[z].ab_create1:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Left", -180, 180, 0, 1, "°")
    aa_condition[z].ab_yaw_r1 = aa_condition[z].ab_create1:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Right", -180, 180, 0, 1, "°")
    aa_condition[z].ab_lby_l1 = aa_condition[z].ab_create1:slider(cnd_aa[z].."\r 🞄 Desync Left", 0, 60, 60, 1, "°")
    aa_condition[z].ab_lby_r1 = aa_condition[z].ab_create1:slider(cnd_aa[z].."\r 🞄 Desync Right", 0, 60, 60, 1, "°")
    aa_condition[z].ab_def_type1 = aa_condition[z].ab_create1:combo(cnd_aa[z].."\r 🞄 Defensive", {"On Peek", "Always On", "Only On DT"})
    aa_condition[z].ab_def_yaw_type1 = aa_condition[z].ab_create1:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "X-Way", "Custom"})
    aa_condition[z].ab_def_pitch_type1 = aa_condition[z].ab_create1:combo(cnd_aa[z].."\r 🞄 Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})

    aa_condition[z].ab_phase2 = tabs.antib:label(cnd_aa[z].."\r 🞄 Phase 2")
    aa_condition[z].ab_create2 = aa_condition[z].ab_phase2:create()
    aa_condition[z].ab_select2 = aa_condition[z].ab_create2:selectable("", {"Yaw", "Desync", "Defensive"})
    aa_condition[z].ab_yaw_type2 = aa_condition[z].ab_create2:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Default", "Delay Switch"})
    aa_condition[z].ab_delay_ticks2 = aa_condition[z].ab_create2:slider(cnd_aa[z].."\r 🞄 Delay 🞄 Ticks", 1, 30, 0, 1, "°")
    aa_condition[z].ab_yaw_l2 = aa_condition[z].ab_create2:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Left", -180, 180, 0, 1, "°")
    aa_condition[z].ab_yaw_r2 = aa_condition[z].ab_create2:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Right", -180, 180, 0, 1, "°")
    aa_condition[z].ab_lby_l2 = aa_condition[z].ab_create2:slider(cnd_aa[z].."\r 🞄 Desync Left", 0, 60, 60, 1, "°")
    aa_condition[z].ab_lby_r2 = aa_condition[z].ab_create2:slider(cnd_aa[z].."\r 🞄 Desync Right", 0, 60, 60, 1, "°")
    aa_condition[z].ab_def_type2 = aa_condition[z].ab_create2:combo(cnd_aa[z].."\r 🞄 Defensive", {"On Peek", "Always On", "Only On DT"})
    aa_condition[z].ab_def_yaw_type2 = aa_condition[z].ab_create2:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "X-Way", "Custom"})
    aa_condition[z].ab_def_pitch_type2 = aa_condition[z].ab_create2:combo(cnd_aa[z].."\r 🞄 Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})

    aa_condition[z].ab_phase3 = tabs.antib:label(cnd_aa[z].."\r 🞄 Phase 3")
    aa_condition[z].ab_create3 = aa_condition[z].ab_phase3:create()
    aa_condition[z].ab_select3 = aa_condition[z].ab_create3:selectable("", {"Yaw", "Desync", "Defensive"})
    aa_condition[z].ab_yaw_type3 = aa_condition[z].ab_create3:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Default", "Delay Switch"})
    aa_condition[z].ab_delay_ticks3 = aa_condition[z].ab_create3:slider(cnd_aa[z].."\r 🞄 Delay 🞄 Ticks", 1, 30, 0, 1, "°")
    aa_condition[z].ab_yaw_l3 = aa_condition[z].ab_create3:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Left", -180, 180, 0, 1, "°")
    aa_condition[z].ab_yaw_r3 = aa_condition[z].ab_create3:slider(cnd_aa[z].."\r 🞄 Yaw 🞄 Right", -180, 180, 0, 1, "°")
    aa_condition[z].ab_lby_l3 = aa_condition[z].ab_create3:slider(cnd_aa[z].."\r 🞄 Desync Left", 0, 60, 60, 1, "°")
    aa_condition[z].ab_lby_r3 = aa_condition[z].ab_create3:slider(cnd_aa[z].."\r 🞄 Desync Right", 0, 60, 60, 1, "°")
    aa_condition[z].ab_def_type3 = aa_condition[z].ab_create3:combo(cnd_aa[z].."\r 🞄 Defensive", {"On Peek", "Always On", "Only On DT"})
    aa_condition[z].ab_def_yaw_type3 = aa_condition[z].ab_create3:combo(cnd_aa[z].."\r 🞄 Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "X-Way", "Custom"})
    aa_condition[z].ab_def_pitch_type3 = aa_condition[z].ab_create3:combo(cnd_aa[z].."\r 🞄 Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})
end

----config manager
local config_cfg = pui.setup({aa_condition}, true)
local cfg_system = { }
configs_db = db.configs_debug or { }
configs_db.cfg_list = configs_db.cfg_list or {{'Default', 'W1t7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo4LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjUxLjAsImFiX2xieV9sMiI6NTEuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjUyLjAsImFiX2xieV9yMiI6NDIuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMzQuMCwiYWJfeWF3X2wyIjotMzMuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MzguMCwiYWJfeWF3X3IyIjozNy4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU4LjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTM0LjAsInlhd19yIjozOS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjYuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOnRydWUsImFiX2xieV9sMSI6NDguMCwiYWJfbGJ5X2wyIjo0Mi4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NTAuMCwiYWJfbGJ5X3IyIjo0Ni4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6Mi4wLCJhYl9zZWxlY3QxIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MiI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOi0zMC4wLCJhYl95YXdfbDIiOi0yNy4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjo0MS4wLCJhYl95YXdfcjIiOjM4LjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTIiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjozLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1Ny4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6NDEuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOnRydWUsImRlZl9waXRjaCI6LTYyLjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo1OC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IlNpZGUtV2F5IiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU4LjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTE5LjAsInlhd19yIjozOS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjcuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOnRydWUsImFiX2xieV9sMSI6NDYuMCwiYWJfbGJ5X2wyIjo0OS4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NDAuMCwiYWJfbGJ5X3IyIjo0NC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6Mi4wLCJhYl9zZWxlY3QxIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MiI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOi0yMC4wLCJhYl95YXdfbDIiOi0yMC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjo0Mi4wLCJhYl95YXdfcjIiOjQwLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTIiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU3LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xOS4wLCJ5YXdfciI6NDQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotMTkuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In1dXQ=='}}
configs_db.menu_list = configs_db.menu_list or {'Default'}

configs_db.cfg_list[1][2] = "W1t7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo4LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjUxLjAsImFiX2xieV9sMiI6NTEuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjUyLjAsImFiX2xieV9yMiI6NDIuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMzQuMCwiYWJfeWF3X2wyIjotMzMuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MzguMCwiYWJfeWF3X3IyIjozNy4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU4LjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTM0LjAsInlhd19yIjozOS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjYuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOnRydWUsImFiX2xieV9sMSI6NDguMCwiYWJfbGJ5X2wyIjo0Mi4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NTAuMCwiYWJfbGJ5X3IyIjo0Ni4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6Mi4wLCJhYl9zZWxlY3QxIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MiI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOi0zMC4wLCJhYl95YXdfbDIiOi0yNy4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjo0MS4wLCJhYl95YXdfcjIiOjM4LjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTIiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjozLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1Ny4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6NDEuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOnRydWUsImRlZl9waXRjaCI6LTYyLjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo1OC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IlNpZGUtV2F5IiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU4LjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTE5LjAsInlhd19yIjozOS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjcuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOnRydWUsImFiX2xieV9sMSI6NDYuMCwiYWJfbGJ5X2wyIjo0OS4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NDAuMCwiYWJfbGJ5X3IyIjo0NC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6Mi4wLCJhYl9zZWxlY3QxIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MiI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOi0yMC4wLCJhYl95YXdfbDIiOi0yMC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjo0Mi4wLCJhYl95YXdfcjIiOjQwLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTIiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU3LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xOS4wLCJ5YXdfciI6NDQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotMTkuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In1dXQ=="
cfg_system.save_config = function(id)
    if id == 1 then return end
    local raw = config_cfg:save()
    configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
    db.configs_debug = configs_db
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
    for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then common.add_notify('[Etterance.Tech]', 'Change Name') return end end
    if #configs_db.cfg_list > 6 then common.add_notify('[Etterance.Tech]', 'Too Much Configs') return end
    local completed = {name, ''}
    table.insert(configs_db.cfg_list, completed)
    table.insert(configs_db.menu_list, name)
    db.configs_debug = configs_db
end

cfg_system.remove_config = function(id)
    if id == 1 then return end
    local item = configs_db.cfg_list[id][1]
    for i=#configs_db.cfg_list, 1, -1 do if configs_db.cfg_list[i][1] == item then table.remove(configs_db.cfg_list, i) table.remove(configs_db.menu_list, i) end end
    db.configs_debug = configs_db
end

cfg_system.load_config = function(id)
    if configs_db.cfg_list[id][2] == nil or configs_db.cfg_list[id][2] == '' then print(string.format('Error[data_base[%s]]', id)) return end
    if id > #configs_db.cfg_list then print(string.format('Error[data_base[%s]]', id)) return end
        config_cfg:load(json.parse(base64.decode(configs_db.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
end
configs = {
    cfg_selector = tabs.configs:list('', configs_db.menu_list):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    name = tabs.configs:input(ui.get_icon('input-text')..'  Config Name', 'Delay Jitter'):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    
    create = tabs.configs:button(ui.get_icon('layer-plus').."\a"..style_hex.." Create", function()
        cfg_system.create_config(configs.name:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    
    remove  = tabs.configs:button(ui.get_icon('trash-xmark').."\a"..style_hex..' Remove', function()
        cfg_system.remove_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    
    save = tabs.configs:button(ui.get_icon('floppy-disk').."\a"..style_hex..' Save', function()
        cfg_system.save_config(configs.cfg_selector:get())
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    load = tabs.configs:button(ui.get_icon('check').."\a"..style_hex..' Load', function()
        cfg_system.update_values(configs.cfg_selector:get())
        cfg_system.load_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    
    import = tabs.configs:button(ui.get_icon('download').."\b"..style_hex..'\bFFFFFFFF[  Import Config    ]', function()
        config_cfg:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1}),
    
    export = tabs.configs:button(ui.get_icon('share-nodes').."\b"..style_hex..'\bFFFFFFFF[    Export Config    ]', function()
        clipboard.set(base64.encode(json.stringify(config_cfg:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
}


---end
local id = 0
local ab_cond = 0
local currentphase = 0
ab_check = false
abtime = globals.realtime
antibrute_time_last = globals.realtime
events.bullet_impact:set(function(e)
    if entity.get_local_player() == nil or not entity.get_local_player():is_alive() then return end
    if not main_aa.enable_list:get() == 2 then return end
    local player = entity.get(e.userid, true)
    if not player:is_enemy() then return end
    playerb = entity.get_local_player()
    if entity.get_threat(true) == nil then return end
    local s_pos = vector(e.x, e.y, e.z)
    local enemy_angles = (s_pos - player:get_hitbox_position(0)):angles()
    local angles = ((playerb:get_hitbox_position(3) - player:get_hitbox_position(0)):angles() - enemy_angles)
    angles.y = math.clamp(angles.y, -180, 180)
    local fov = math.sqrt(angles.y*angles.y + angles.x*angles.x)
    if fov < 10 and antibrute_time_last + 0.1 < globals.realtime then
        ab_cond = id
        abshots = abshots + 1
        abtime = globals.realtime
        antibrute_time_last = globals.realtime + 0.1
        currentphase = currentphase + 1
        if currentphase > aa_condition[id].ab_phases:get() then
            currentphase = 1
        end
        if ab_check == true and other_visual.printconsole:get(3) then
            render.log("🪐 Anti~Bruteforce Angle Switched due to \a8FB9FFFF"..player:get_name().."\aFFFFFFFF shot. Phase: "..currentphase.." 🪐")
        end
    end
end)


local anti_aim = {}
pitch_ads = 0
yawadd = 0
yaw_ads = 0
ground_ticks, end_time = 1, 0
anti_aim.in_air = function()
    if not entity.get_local_player() == nil then return end
    if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime + 1
    end
    return ground_ticks > 1 and end_time > globals.curtime
end

anti_aim.get_player_state = function()
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    anti_aim.in_air()
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = end_time > (globals.curtime + 0.9)
    crouch = local_player.m_flDuckAmount > 0.7 or ref.fd:get()
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5
    if jump and crouch then return "AEROBIC+C" end
    if jump then return "AEROBIC" end
    if crouch then return "DUCKING" end
    if on_ground and ref.slow:get() and move then return "WALKING" end
    if on_ground and not move then return "STANDING" end
    if on_ground and move then return "RUNNING" end
end

anti_aim.ind_state = function()
    local_player = entity.get_local_player()
    if not local_player then return "Not connected" end
    anti_aim.in_air()
    on_ground = bit.band(local_player.m_fFlags, 1) == 1
    jump = end_time > (globals.curtime + 0.7)
    crouch = local_player.m_flDuckAmount > 0.7 or ref.fd:get()
    vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5
    if jump and crouch then return "AEROBIC+C" end
    if jump then return "AEROBIC" end
    if crouch then return "DUCKING" end
    if on_ground and ref.slow:get() and move then return "WALKING" end
    if on_ground and not move then return "STANDING" end
    if on_ground and move then return "RUNNING" end
end
anti_aim.antiaim_setup = function(cmd)
    ref.enable:override(main_aa.enable_list:get() == 2)
    if not main_aa.enable_list:get() == 2 then return end
    local_player = entity.get_local_player()
    if aa_condition[2].enable:get() and anti_aim.get_player_state() == "STANDING" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 2
    elseif aa_condition[3].enable:get() and anti_aim.get_player_state() == "RUNNING" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 3
    elseif aa_condition[4].enable:get() and anti_aim.get_player_state() == "WALKING" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 4
    elseif aa_condition[5].enable:get() and anti_aim.get_player_state() == "DUCKING" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 5
    elseif aa_condition[6].enable:get() and anti_aim.get_player_state() == "AEROBIC" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 6
    elseif aa_condition[7].enable:get() and anti_aim.get_player_state() == "AEROBIC+C" and not (aa_condition[8].enable:get() and rage.exploit:get() < 0.9) then id = 7 
    elseif aa_condition[8].enable:get() and rage.exploit:get() < 0.9 then id = 8
    else
        id = 1
    end

    if aa_condition[id].ab_enable:get() then
        ab_check = true
    else
        ab_check = false
    end

    if (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Yaw") and currentphase == 1 then
        yaw_type = aa_condition[id].ab_yaw_type1:get()
        yaw_tick = aa_condition[id].ab_delay_ticks1:get()
        yaw_left = aa_condition[id].ab_yaw_l1:get()
        yaw_right = aa_condition[id].ab_yaw_r1:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Yaw") and currentphase == 2 then
        yaw_type = aa_condition[id].ab_yaw_type2:get()
        yaw_tick = aa_condition[id].ab_delay_ticks2:get()
        yaw_left = aa_condition[id].ab_yaw_l2:get()
        yaw_right = aa_condition[id].ab_yaw_r2:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Yaw") and currentphase == 3 then
        yaw_type = aa_condition[id].ab_yaw_type3:get()
        yaw_tick = aa_condition[id].ab_delay_ticks3:get()
        yaw_left = aa_condition[id].ab_yaw_l3:get()
        yaw_right = aa_condition[id].ab_yaw_r3:get()
    else
        yaw_type = aa_condition[id].yaw_type:get()
        yaw_tick = aa_condition[id].delay_ticks:get()
        yaw_left = aa_condition[id].yaw_l:get()
        yaw_right = aa_condition[id].yaw_r:get()
    end 

    if (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Desync") and currentphase == 1 then
        desync_left = aa_condition[id].ab_lby_l1:get()
        desync_right = aa_condition[id].ab_lby_r1:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Desync") and currentphase == 2 then
        desync_left = aa_condition[id].ab_lby_l2:get()
        desync_right = aa_condition[id].ab_lby_r2:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Desync") and currentphase == 3 then
        desync_left = aa_condition[id].ab_lby_l3:get()
        desync_right = aa_condition[id].ab_lby_r3:get()
    else
        desync_left = aa_condition[id].lby_l:get()
        desync_right = aa_condition[id].lby_r:get()
    end

    if (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select1:get("Defensive") and currentphase == 1 then
        def_type = aa_condition[id].ab_def_type1:get()
        def_yaw_type = aa_condition[id].ab_def_yaw_type1:get()
        def_pitch_type = aa_condition[id].ab_def_pitch_type1:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select2:get("Defensive") and currentphase == 2 then
        def_type = aa_condition[id].ab_def_type2:get()
        def_yaw_type = aa_condition[id].ab_def_yaw_type2:get()
        def_pitch_type = aa_condition[id].ab_def_pitch_type2:get()
    elseif (ab_cond == id) and (ab_check == true and abtime + 2 > globals.realtime) and aa_condition[id].ab_select3:get("Defensive") and currentphase == 3 then
        def_type = aa_condition[id].ab_def_type3:get()
        def_yaw_type = aa_condition[id].ab_def_yaw_type3:get()
        def_pitch_type = aa_condition[id].ab_def_pitch_type3:get()
    else
        def_type = aa_condition[id].def_type:get()
        def_yaw_type = aa_condition[id].def_yaw_type:get()
        def_pitch_type = aa_condition[id].def_pitch_type:get()
    end

    ref.hidden:override(aa_condition[id].def_aa:get())

    if def_type == "On Peek" then
        ref.lag:override("On Peek")
        ref.hsopt:override("Favor Fire Rate")
    elseif def_type == "Always On" then
        ref.lag:override("Always On")
        ref.hsopt:override("Break LC")
    else
        ref.lag:override("Always On")
        ref.hsopt:override("Favor Fire Rate")
    end
    if aa_condition[id].def_aa:get() then

        if def_yaw_type == "Side-Way" then
            rage.antiaim:override_hidden_yaw_offset(rage.antiaim:inverter() and aa_condition[id].def_side:get() or -aa_condition[id].def_side:get())
        elseif def_yaw_type == "Random Way" then
            randomise = math.random(aa_condition[id].def_min:get(), aa_condition[id].def_max:get())
            rage.antiaim:override_hidden_yaw_offset(rage.antiaim:inverter() and (aa_condition[id].def_side:get()+randomise) or -(aa_condition[id].def_side:get()+randomise))
        elseif aa_condition[id].def_yaw_type:get() == "180Z" then
            if yawadd >= 180 then
                yawadd = 0
            else
                yawadd = yawadd +10
            end
            rage.antiaim:override_hidden_yaw_offset(rage.antiaim:inverter() and yawadd or yawadd * -1)
        elseif def_yaw_type == "X-Way" then
            if globals.tickcount % 3 == 0 then
                rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_1way:get())
            elseif globals.tickcount % 3 == 1 then
                rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_2way:get())
            elseif globals.tickcount % 3 == 2 then
                rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_3way:get())
            end
        elseif def_yaw_type == "Custom" then
            if yaw_ads <= 179 then
                yaw_ads = yaw_ads + aa_condition[id].def_sens:get()
            else
                yaw_ads = -yaw_ads + aa_condition[id].def_sens:get()
            end
            rage.antiaim:override_hidden_yaw_offset(yaw_ads)
        elseif def_yaw_type == "Off" then
            rage.antiaim:override_hidden_yaw_offset(ref.yawoffset:get())
        end

        if def_pitch_type == "Random" then
            rage.antiaim:override_hidden_pitch(math.random(-89, 89)) 
        elseif def_pitch_type == "Progressive" then
            if pitch_ads <= 81 then
                pitch_ads = pitch_ads + 8
            else
                pitch_ads = (-pitch_ads) + 8
            end
            rage.antiaim:override_hidden_pitch(-pitch_ads)
        elseif def_pitch_type == "Custom" then
            rage.antiaim:override_hidden_pitch(aa_condition[id].def_pitch:get())
        elseif def_pitch_type == "Default" then
            if cmd.command_number % 22>11 then
                rage.antiaim:override_hidden_pitch(-89)
            end
        elseif def_pitch_type == "Switch Way" then
            if globals.tickcount % 3 == 0 then
                rage.antiaim:override_hidden_pitch(-89)
            elseif globals.tickcount % 3 == 1 then
                rage.antiaim:override_hidden_pitch(-45)
            elseif globals.tickcount % 3 == 2 then
                rage.antiaim:override_hidden_pitch(0)
            end
        elseif def_pitch_type == "Alternative" then
            switch_def = globals.server_tick % 18
            if switch_def < 6 then
                rage.antiaim:override_hidden_pitch(rage.antiaim:inverter() and -49 or 49)
            elseif switch_def > 6 and switch_def < 12 then
                rage.antiaim:override_hidden_pitch(0)
            elseif switch_def > 12 and switch_def < 18 then
                rage.antiaim:override_hidden_pitch(rage.antiaim:inverter() and 49 or -49)
            end
           --second
           --random_check = math.random(1, 2)
           --if random_check == 1 then
            --switch_def = globals.server_tick % -22
           --else
            --switch_def = globals.server_tick % 22
           --end
           --rage.antiaim:override_hidden_pitch(rage.antiaim:inverter() and -switch_def*2 or switch_def*2)
        end

    end
	ref.yawoff:override(aa_condition[id].jitter_center:get())
    ref.pitch:override(main_aa.pitch_set:get())
    ref.yawmod:override(aa_condition[id].jit_type:get())
    ref.yaw:override("Backward")
    ref.bodyyaw:override(aa_condition[id].bodyyaw:get())
    ref.options:override(aa_condition[id].options:get())
    ref.freestanding:override("Off")
    ref.right_limit:override(desync_right)
    ref.left_limit:override(desync_left)

    lp_bodyyaw = rage.antiaim:inverter()
    yaw_add_l = yaw_left
    yaw_add_r = yaw_right
    yaw_d = lp_bodyyaw and yaw_add_l or yaw_add_r

    if yaw_type == "Default" then
        ref.yawoffset:override(yaw_d)
        ref.inverter:override(false)
    else    
        ticks = yaw_tick/2
        switch = (globals.server_tick %(8+ticks) > 4+ticks/2)
        if cmd.send_packet == true and cmd.choked_commands < 1 then
            ref.yawoffset:override(switch and yaw_add_l or yaw_add_r)
            ref.inverter:override(switch)
        end
    end
    
    selected = local_player:get_player_weapon()
    if selected == nil then return end
    weapon = selected:get_classname()
    safe_check = false
    if main_aa.wpn_select:get("Knife") and string.match(weapon, "Knife") then safe_check = true end
    if main_aa.wpn_select:get("Zeus") and string.match(weapon, "Taser") then safe_check = true end
    if main_aa.wpn_select:get("Grenade") and string.match(weapon, "Grenade") then safe_check = true end
    if main_aa.wpn_select:get("AWP") and string.match(weapon, "AWP") then safe_check = true end
    if main_aa.wpn_select:get("Scout") and string.match(weapon, "SSG08") then safe_check = true end
    if (jump and safe_check == true) then
        ref.yawoff:override(0)
        ref.options:override("")
        ref.inverter:override(true)
        if string.match(weapon, "Knife") then
            ref.yawoffset:override(-15)
        else
            ref.yawoffset:override(-2)
        end
        ref.hidden:override(false)
    end

    ref.freestand:override(main_aa.freestand:get())
    if main_aa.freestand:get() then 
        if main_aa.staticfrees:get(2) then
            ref.hidden:override(false)
        end
        ref.disableyaw:override(main_aa.staticfrees:get(1))
        ref.bodyfrees:override(main_aa.staticfrees:get(1))
        if main_aa.staticfrees:get(1) then
            ref.yawoffset:override(0)
            ref.yawoff:override(0)
            ref.options:override("")
            ref.inverter:override(false)
        end
    end
    if main_aa.custom_yaw_base:get() == "At Target" then
        ref.yawbase:override("At Target")
    elseif main_aa.custom_yaw_base:get() == "Backward" then
        ref.yawbase:override("Local View")
    elseif main_aa.custom_yaw_base:get() == "Left" then
        ref.freestand:override(false)
        ref.yawoffset:override(-85)
        ref.yawoff:override(0)
        ref.options:override("")
        ref.yawbase:override("Local View")
    elseif main_aa.custom_yaw_base:get() == "Right" then
        ref.freestand:override(false)
        ref.yawoffset:override(85)
        ref.yawoff:override(0)
        ref.options:override("")
        ref.yawbase:override("Local View")
    elseif main_aa.custom_yaw_base:get() == "Forward" then
        ref.yawoffset:override(180)
        ref.yawoff:override(0)
        ref.yawbase:override("Local View")
    end
    ref.backstab:override(main_aa.additions:get("Anti~Backstab"))
    if (main_aa.additions:get("Shit AA On Warmup") and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
        ref.right_limit:override(math.random(0, 30))
        ref.left_limit:override(math.random(0, 30))
        ref.yawoff:override(math.random(-90, 90))
    end
end
for z, x in pairs(cond_aa) do
    enaa = {aa_condition[z].enable, function() if(z == 1) then return true else return aa_condition[z].enable:get() end end}
    need_select = {main_aa.condition, cond_aa[z]}
    tab_sel = {main_aa.select_tab, 2}
    aa_condition[z].enable:depend(main_aa.enable_aa, need_select, tab_sel, {main_aa.condition, function() return (z ~= 1) end})
    aa_condition[z].yaw_type:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].delay_ticks:depend(enaa, {main_aa.enable_list, 2}, tab_sel, {aa_condition[z].yaw_type, "Delay Switch"}, need_select)
    aa_condition[z].yaw_l:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].yaw_r:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].jit_type:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].jitter_center:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select, {aa_condition[z].jit_type, function() if aa_condition[z].jit_type:get() == "Disabled" then return false else return true end end})
    aa_condition[z].bodyyaw:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].lby_l:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].bodyyaw, tab_sel, need_select)
    aa_condition[z].lby_r:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].bodyyaw, tab_sel, need_select)
    aa_condition[z].options:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].bodyyaw, tab_sel, need_select)
    aa_condition[z].def_aa:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].def_type:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].def_yaw_type:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select)
    aa_condition[z].def_sens:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, "Custom"})
    aa_condition[z].def_side:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" or aa_condition[z].def_yaw_type:get() == "Side-Way" then return true else return false end end})

    aa_condition[z].def_min:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" then return true else return false end end})
    aa_condition[z].def_max:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" then return true else return false end end})

    aa_condition[z].def_1way:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_2way:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_3way:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_pitch_type:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select)
    aa_condition[z].def_pitch:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].def_aa, tab_sel, need_select, {aa_condition[z].def_pitch_type, "Custom"})

    
    aa_condition[z].ab_enable:depend(enaa, {main_aa.enable_list, 2}, tab_sel, need_select)
    aa_condition[z].add_phases:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)
    aa_condition[z].rem_phases:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)

    aa_condition[z].ab_phase1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)
    aa_condition[z].ab_select1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)
    aa_condition[z].ab_yaw_type1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_delay_ticks1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Yaw"}, {aa_condition[z].ab_yaw_type1, "Delay Switch"})
    aa_condition[z].ab_yaw_l1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_yaw_r1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_lby_l1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Desync"})
    aa_condition[z].ab_lby_r1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Desync"})
    aa_condition[z].ab_def_type1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Defensive"})
    aa_condition[z].ab_def_yaw_type1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Defensive"})
    aa_condition[z].ab_def_pitch_type1:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select1, "Defensive"})


    aa_condition[z].ab_phase2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_phases, function() if aa_condition[z].ab_phases:get() > 1 then return true else return false end end})
    aa_condition[z].ab_select2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)
    aa_condition[z].ab_yaw_type2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_delay_ticks2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Yaw"}, {aa_condition[z].ab_yaw_type2, "Delay Switch"})
    aa_condition[z].ab_yaw_l2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_yaw_r2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_lby_l2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Desync"})
    aa_condition[z].ab_lby_r2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Desync"})
    aa_condition[z].ab_def_type2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Defensive"})
    aa_condition[z].ab_def_yaw_type2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Defensive"})
    aa_condition[z].ab_def_pitch_type2:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select2, "Defensive"})

    aa_condition[z].ab_phase3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_phases, function() if aa_condition[z].ab_phases:get() > 2 then return true else return false end end})
    aa_condition[z].ab_select3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select)
    aa_condition[z].ab_yaw_type3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_delay_ticks3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Yaw"}, {aa_condition[z].ab_yaw_type3, "Delay Switch"})
    aa_condition[z].ab_yaw_l3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_yaw_r3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_lby_l3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Desync"})
    aa_condition[z].ab_lby_r3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Desync"})
    aa_condition[z].ab_def_type3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Defensive"})
    aa_condition[z].ab_def_yaw_type3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Defensive"})
    aa_condition[z].ab_def_pitch_type3:depend(enaa, {main_aa.enable_list, 2}, aa_condition[z].ab_enable, tab_sel, need_select, {aa_condition[z].ab_select3, "Defensive"})
end
---end

---Anim Breaker
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
local animslsg = nil
local anmsupd = function(lp)
    lp = entity.get_local_player()
    if lp == nil then return end
    if not lp:is_alive() then return end
    if lp:get_index() == nil then return end
    animslsg = get_entity_address(lp:get_index())
    move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
    jump = bit.band(lp.m_fFlags, 1) == 0
    if main_aa.groundbreaker:get() == "Follow Direction" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        lp.m_flPoseParameter[0] = 1
        ref.legs:override("Sliding")
    end
    if main_aa.groundbreaker:get() == "Jitter Slide" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        lp.m_flPoseParameter[0] = math.random(0, 10)/10
        ref.legs:override("Sliding")
    end
    if main_aa.groundbreaker:get() == "Jitter" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        lp.m_flPoseParameter[0] = globals.tickcount %4 > 1 and main_aa.legs_jit:get()/100 or 1
        ref.legs:override("Sliding")
    end
    if main_aa.airbreaker:get() == "Static Legs In Air" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        lp.m_flPoseParameter[6] = 1
    end
    if main_aa.groundbreaker:get() == "MoonWalk" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        lp.m_flPoseParameter[7] = 1
        ref.legs:override("Walking")
    end
    if main_aa.othbreaker:get("Pitch 0 On Land") and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        if anti_aim.in_air() then
            lp.m_flPoseParameter[12] = 0.5
        end
    end
    if main_aa.othbreaker:get("Jitter Head") and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        if anti_aim.get_player_state() == "DUCKING" then return end
        lp.m_flPoseParameter[10] = globals.tickcount %4 > 1 and 0.5 or 1
    end
    if main_aa.airbreaker:get() == "MoonWalk" and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        if jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        end
    end
    if main_aa.othbreaker:get("Move Lean") and main_aa.enable_list:get() == 2 and main_aa.anims:get() then
        if move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = 1
        end
    end
end
events.post_update_clientside_animation:set(anmsupd)
-- VISUALS

local function mouse_check(first, second)
    if ui.get_alpha() < 1 then return false end
    local pos = ui.get_mouse_position()
    return pos.x >= first.x and pos.x <= second.x and pos.y >= first.y and pos.y <= second.y 
end
local checktime_last = globals.realtime
local other_call = {}

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end

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

other_call.nade_radius = function()
    local lp = entity.get_local_player()
    if not lp then return end
    lp_orig = lp:get_origin()

    if other_visual.grenade_select:get(2) then
        local molotov_entity = entity.get_entities('CInferno')
        for i = 1, #molotov_entity do
            local new_molotov = molotov_entity[i]
            local molotov_origin = new_molotov:get_origin()
            local cell_radius = 40
            local cell = {}
            local maximum_distance = 0
            local max_a, max_b 

            local old_molotov = molotov_entity[i]
            local onwer = new_molotov.m_hOwnerEntity
            if onwer == nil then
                color_mol = other_visual.enemy_molotov_color:get()
            else
                onwerteam = onwer.m_iTeamNum
                lpteam = lp.m_iTeamNum
                if onwerteam  == lpteam then
                    color_mol = other_visual.molotov_color:get()
                else
                    color_mol = other_visual.enemy_molotov_color:get()
                end
            end
            check_dist = lp_orig:dist(molotov_origin) < 570
            for i = 1, 64 do
                if old_molotov.m_bFireIsBurning[i] == true and check_dist then
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
                render.circle_3d_outline(center, color(other_visual.molotov_color:get().r, other_visual.molotov_color:get().g, other_visual.molotov_color:get().b, 255), maximum_distance / 2 + cell_radius, 0,1,1)  
            end
        end
    end

    if other_visual.grenade_select:get(1) then
        local tickcount = globals.tickcount
        local tickinterval = globals.tickinterval
        local Smokes = entity.get_entities('CSmokeGrenadeProjectile')
        for i=1, #Smokes do
            local grenade = Smokes[i]
            grenade_orig = grenade:get_origin()
            if lp_orig:dist(grenade_orig) > 1000 then goto skip end
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
                            local r, g, b, a = other_visual.smoke_color:get().r, other_visual.smoke_color:get().g, other_visual.smoke_color:get().b, other_visual.smoke_color:get().a
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
            ::skip::
        end
    end
end


function lerpx(time,a,b) return a * (1-time) + b * time end
function window(x, y, w, h, name, alpha) 
    local me = entity.get_local_player()
    if not me then return end
	local name_size = render.measure_text(1, "", name) 
    local r2, g2, b2 = colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b
    local r3, g3, b3, a3 = colors_lua.shadow_col:get().r, colors_lua.shadow_col:get().g, colors_lua.shadow_col:get().b, colors_lua.shadow_col:get().a
    if other_visual.solus_type:get() == 2 then
        render.shadow(vector(x, y-1), vector(x + w + 3, y + 19), color(r3, g3, b3, alpha*(a3/255)), 30, 0, 2)
        render.rect(vector(x, y-1), vector(x + w + 3, y + 19), color(29, 29, 29, alpha/1.5), 2)
        render.text(1, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
        render.gradient(vector(x-2, y-1), vector(x + 1, y + 19), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), 3)
        render.gradient(vector(x+w+2, y-1), vector(x + 5+w, y + 19), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), color(r2, g2, b2, alpha), 3)
    elseif other_visual.solus_type:get() == 1 then
        render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r2, g2, b2, alpha), 4)
        render.shadow(vector(x, y), vector(x + w + 3, y + 2), color(r2, g2, b2, alpha), 30, 0, 2)
        render.rect(vector(x, y + 2), vector(x + w + 3, y + 19), color(0, 0, 0, alpha/4), 0)
        render.text(1, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    else
        render.rect(vector(x-5, y - 4), vector(x + w + 7, y + 21), color(40,40,40, alpha), 0)
        render.rect_outline(vector(x-4, y - 3), vector(x + w + 6, y + 20), color(0, 0, 0, alpha/2), 0)
        render.rect(vector(x, y + 1), vector(x + w + 3, y + 17), color(20,20,20, alpha), 0) -- /1.5
        render.rect_outline(vector(x-1, y), vector(x + w + 3, y + 18), color(60,60,60, alpha), 0)
        render.gradient(vector(x, y + 1), vector(x + (w/2), y + 2), color(78,169,249,alpha), color(254,86,217,alpha), color(78,169,249,alpha), color(254,86,217,alpha))
        render.gradient(vector(x + (w/2), y + 1), vector(x + w+2, y + 2), color(254,86,217,alpha), color(214,255,108,alpha), color(254,86,217,alpha), color(214,255,108,alpha))
        render.text(1, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y+1 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
    end
end

local x_x, y_y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec = render.screen_size().x, render.screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1

local pos_x = other_visual.Widgetsgroup:slider("posx", 0, x_x, 200)
local pos_y = other_visual.Widgetsgroup:slider("posy", 0, y_y, 200)
local pos_x1 = other_visual.Widgetsgroup:slider("posx1", 0, x_x, 300)
local pos_y1 = other_visual.Widgetsgroup:slider("posy1", 0, y_y, 300)
pos_x:visibility(false)
pos_y:visibility(false)
pos_x1:visibility(false)
pos_y1:visibility(false)
local function watermark_func()
    local actual_time = ""
    local latency_text = ""
    local nexttext = ""
    actual_time = common.get_date("%H:%M")
    if not globals.is_in_game then
        latency_text = ''
    else
        latency_text = ' | '..MTools.Client.GetPing().."ms"
    end
    solushex = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, 255):to_hex()
    if other_visual.sol_emoji:get() then
        nexttext = ('🪐ette\a'..solushex..'rance🪐 \aFFFFFFFF| '..other_visual.custom_name:get()..latency_text.." | "..actual_time.." ")
    else
        nexttext = ('ette\a'..solushex..'rance \aFFFFFFFF| '..other_visual.custom_name:get()..latency_text.." | "..actual_time.." ")
    end
    local text_size = render.measure_text(1, "", nexttext).x
    window(x_x - text_size-19, 10, text_size + 4, 16, nexttext, 255)
end
local new_drag_object = drag_system.register({pos_x, pos_y}, vector(120, 60), "Test", function(self)
    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local active_binds = {}
    local binds = ui.get_binds()
    solushex = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, 255):to_hex()
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
        render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
        add_y = add_y + 16 * data_k[bind.name].alpha_k/255
        local width_k = bind_state_size.x + bind_name_size.x + 18
        if width_k > 130-11 then
            if width_k > max_width then
                max_width = width_k
            end
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
        if other_visual.sol_emoji:get() then
            window(self.position.x, self.position.y, width_ka, 16, "🪐key\a"..solushex.."binds🪐", alphabinds)
        else
            window(self.position.x, self.position.y, width_ka, 16, "key\a"..solushex.."binds", alphabinds)
        end
    end
end)

local new_drag_object1 = drag_system.register({pos_x1, pos_y1}, vector(120, 60), "Test2", function(self)
    local width_spec = 120
    if width_spec > 160-11 then
        if width_spec > max_width then
            max_width = width_spec
        end
    end
    solushex = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, 255):to_hex()
    if ui.get_alpha() > 0.3 then
        if other_visual.sol_emoji:get() then
            window(self.position.x, self.position.y, width_spec, 16, '🪐spec\a'..solushex..'tators🪐', 255)
        else
            window(self.position.x, self.position.y, width_spec, 16, 'spec\a'..solushex..'tators', 255)
        end
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
        render.text(1, vector(self.position.x + 10, self.position.y + 5 + (idx*15)), color(), 'u', name_sub)
        ::skip::
    end
    if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
        if other_visual.sol_emoji:get() then
            window(self.position.x, self.position.y, width_spec, 16, '🪐spec\a'..solushex..'tators🪐', 255)
        else
            window(self.position.x, self.position.y, width_spec, 16, 'spec\a'..solushex..'tators', 255)
        end
    end
end)

--velocity
local renders = {}
local main = {}
vel_x = other_visual.mindmggroup:slider("x_vel", 1, render.screen_size().x, render.screen_size().x/2-90)
vel_y = other_visual.mindmggroup:slider("y_vel", 1, render.screen_size().y, render.screen_size().y/2-250)
vel_x:visibility(false)
vel_y:visibility(false)
main.size = 0
main.vel_alpha = 0
main.textPvel_alpha = 0
local function windows_def(x, y, size, sizey, long, text, color1, color2, alpha)
    render.shadow(vector(x+15, y+23), vector(x+175, y+26), color(255, 255, 255, alpha), 30, 0, 0)
    render.rect(vector(x+15, y+23), vector(x+15 + long, y+25), color1, 0)
    render.rect_outline(vector(x+15, y+22), vector(x+175, y+26), color2, 1, 0)
    render.text(1, vector(x+50, y +5), color1, nil, text)
    render.rect_outline(vector(x, y), vector(x + size, y + sizey), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end

local velocity_ind = drag_system.register({vel_x, vel_y}, vector(190, 30), "Velocity", function(self)
    vel_mod = entity.get_local_player().m_flVelocityModifier  
    if ui.get_alpha() > 0 or vel_mod < 1 then
        main.vel_alpha = math.lerp(main.vel_alpha, 1, 12)
    else
        main.vel_alpha = math.lerp(main.vel_alpha, 0, 12)
    end
    main.size = vel_mod * 160 == 160 and math.lerp(vel_mod * 160, main.size, 4) or math.lerp(main.size, vel_mod * 160, 4)
    gc1, gc2 = colors_lua.velocity_indicator_color_1:get(), colors_lua.velocity_indicator_color_2:get()
    color1, color2 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main.vel_alpha * 255))
    windows_def(self.position.x, self.position.y, self.size.x, self.size.y, main.size, "Slowed Down: " ..math.floor(vel_mod * 100).." %", color1, color2, math.floor(main.vel_alpha * 255))
    if mouse_check(vector(vel_x:get(), vel_y:get()), vector(vel_x:get() + self.size.x, vel_y:get() + self.size.y)) then
        render.text(1, vector(self.position.x+25, self.position.y - 15), color(255, 255, 255, 255*main.textPvel_alpha), nil, "Click Right Mouse To Centering")
        main.textPvel_alpha = math.lerp(main.textPvel_alpha, 1, 12)
        if common.is_button_down(0x02) then
            vel_x:set(render.screen_size().x/2-90)
            self.position.x = render.screen_size().x/2-90
        end
    elseif main.textPvel_alpha ~= 0 then
        main.textPvel_alpha = 0
    end
end)

local main_def = {}
def_x = other_visual.mindmggroup:slider("x_def", 1, render.screen_size().x, render.screen_size().x/2-90)
def_y = other_visual.mindmggroup:slider("y_def", 1, render.screen_size().x, render.screen_size().y/2-300)
def_x:visibility(false)
def_y:visibility(false)
main_def.size = 0
main_def.vel_alpha = 0
main.text_alpha = 0
local def_man = drag_system.register({def_x, def_y}, vector(190, 30), "Defensive", function(self)
    vel_mod = rage.exploit:get()
    if ui.get_alpha() > 0 or vel_mod < 1 and ref.dt:get() and not ref.fd:get() then
        main_def.vel_alpha = math.lerp(main_def.vel_alpha, 1, 12)
    else
        main_def.vel_alpha = math.lerp(main_def.vel_alpha, 0, 12)
    end
    main_def.size = vel_mod * 160 == 160 and math.lerp(vel_mod * 160, main_def.size, 4) or math.lerp(main_def.size, vel_mod * 160, 4)
    gc1, gc2 = colors_lua.defensive_indicator_color_1:get(), colors_lua.defensive_indicator_color_2:get()
    color1, color2 = color(gc1.r, gc1.g, gc1.b, math.floor(main_def.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main_def.vel_alpha * 255))
    windows_def(self.position.x, self.position.y, self.size.x, self.size.y, main_def.size, "  Defensive: " ..math.floor(vel_mod * 100).." %", color1, color2, math.floor(main_def.vel_alpha * 255))
    if mouse_check(vector(def_x:get(), def_y:get()), vector(def_x:get() + self.size.x, def_y:get() + self.size.y)) then
        render.text(1, vector(self.position.x+25, self.position.y - 15), color(255, 255, 255, 255*main.text_alpha), nil, "Click Right Mouse To Centering")
        main.text_alpha = math.lerp(main.text_alpha, 1, 12)
        if common.is_button_down(0x02) then
            vel_x:set(render.screen_size().x/2-90)
            self.position.x = render.screen_size().x/2-90
        end
    elseif main.text_alpha ~= 0 then
        main.text_alpha = 0
    end
end)

local font = {
    pixel1 = render.load_font("Verdana", 21, "ab")
}
local screen_size = render.screen_size()
username, screen_center = common.get_username(), screen_size * 0.5
infopanel_x = tabs.visuals:slider("x_pan", 1, screen_size.x, screen_center.x*2-130)
infopanel_y = tabs.visuals:slider("y_pan", 1, screen_size.y, 35)
infopanel_x:visibility(false)
infopanel_y:visibility(false)

local info_font = tabs.visuals:slider("pan font", 1, 5, 1)
info_font:visibility(false)
font_info = info_font:get()
info_font:set_callback(function()
    font_info = info_font:get()
end)

local pan_type = tabs.visuals:slider("pan type", 1, 5, 1)
pan_type:visibility(false)
type_pan = pan_type:get()
pan_type:set_callback(function()
    type_pan = pan_type:get()
end)

local info_alpha = 0
local etterance_water = gradient.text_animate("etterance 🞄 debug", -1, {
    color(255, 255, 255),
    color(170, 170, 170),
    color(255, 255, 255),
})
local function stringupinfo(text)
    if font_info == 2 then
        text = string.gsub(text, " ", "   ")
    end
    if font_info == 2 then return 
        string.upper(text)
    else return
        text
    end 
end

other_call.Infopanel = drag_system.register({infopanel_x, infopanel_y}, vector(100, 15), "Infopanel", function(self)
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    if type_pan == 1 then
        render.text(font_info, vector(self.position.x+5, self.position.y), color(), "aob", stringupinfo(etterance_water:get_animated_text()))
    else
        etterance_sense = gradient.text_animate("R A N C E", -1, {
            color(125, 125, 125),
            color(170, 170, 170),
            color(255, 255, 255),
        })
        render.text(font_info, vector(self.position.x+5, self.position.y), color(), "aob", "E T T E "..etterance_sense:get_animated_text())
        etterance_sense:animate()
    end
    if mouse_check(vector(infopanel_x:get(), infopanel_y:get()), vector(infopanel_x:get() + self.size.x, infopanel_y:get() + self.size.y)) then
        render.text(font_info, vector(self.position.x-40, self.position.y+25), color(255, 255, 255, 255*info_alpha), "aob", "Click Middle Mouse To Change Font")
        render.text(font_info, vector(self.position.x-45, self.position.y+35), color(255, 255, 255, 255*info_alpha), "aob", "Click Right Mouse To Default Position")
        render.text(font_info, vector(self.position.x-35, self.position.y+15), color(255, 255, 255, 255*info_alpha), "aob", "Click Left CTRL For Change Style")
        info_alpha = math.lerp(info_alpha, 1, 12)
        if common.is_button_down(0x02) then
            infopanel_x:set(screen_center.x*2-130)
            infopanel_y:set(35)
            self.position.x = screen_center.x*2-130
            self.position.y = 35
        end
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            info_font:set(info_font:get() + 1)
            if info_font:get() > 4 then
                info_font:set(1)
            end
        end
        if common.is_button_down(0xA2) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            pan_type:set(pan_type:get()+1)
            if pan_type:get() > 2 then
                pan_type:set(1)
            end
        end
    elseif info_alpha ~= 0 then
        info_alpha = 0
    end
end)


panel_x = tabs.visuals:slider("x_panel", 1, screen_size.x, 10)
panel_y = tabs.visuals:slider("y_panel", 1, screen_size.y, screen_center.y+10)
panel_x:visibility(false)
panel_y:visibility(false)
local threat = nil
local alpha_panel = 0
local font_check = tabs.visuals:slider("font panel", 1, 5, 1)
font_check:visibility(false)
font_pan = font_check:get()
font_check:set_callback(function()
    font_pan = font_check:get()
end)
local function stringuppanel(text)
    if font_pan == 2 then
        text = string.gsub(text, " ", "   ")
    end
    if font_pan == 2 then return 
        string.upper(text)
    else return
        text
    end 
end

other_call.panel = drag_system.register({panel_x, panel_y}, vector(150, 65), "panel", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    if entity.get_threat() == nil then
        threat = "nil"
    else
        threat = entity.get_threat():get_name()
    end
    if entity.get_threat() == nil or entity.get_threat():is_bot() then
        desync = ""
    else
        desync = " "..math.floor(math.normalize_yaw(entity.get_threat():get_anim_state().eye_yaw - entity.get_threat():get_anim_state().abs_yaw)).."°"
    end
    render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    water_size = render.measure_text(font_pan, "aob", stringuppanel("> Etterance.Tech 🞄 debug"))
    icol = colors_lua.panel_color4:get()
    render.text(font_pan, vector(self.position.x+5, self.position.y), colors_lua.panel_color1:get(), "aob", stringuppanel("> Etterance.Tech 🞄 debug"))
    render.gradient(vector(self.position.x+5+water_size.x/2, self.position.y+water_size.y+1), vector(self.position.x+5+water_size.x, self.position.y+water_size.y+3), color(icol.r, icol.g, icol.b, 255), color(icol.r, icol.g, icol.b, 0), color(icol.r, icol.g, icol.b, 255), color(icol.r, icol.g, icol.b, 0))
    render.gradient(vector(self.position.x+5, self.position.y+water_size.y+1), vector(self.position.x+5+water_size.x/2, self.position.y+water_size.y+3), color(icol.r, icol.g, icol.b, 0), color(icol.r, icol.g, icol.b, 255), color(icol.r, icol.g, icol.b, 0), color(icol.r, icol.g, icol.b, 255))
    render.text(font_pan, vector(self.position.x+5, self.position.y+water_size.y+3), color(), "aob", stringuppanel("> Anti-Bruteforce Shots: "..abshots))
    render.text(font_pan, vector(self.position.x+5, self.position.y+water_size.y*2+3), color(), "aob", stringuppanel("> State Info: "..string.lower(anti_aim.ind_state())))
    render.text(font_pan, vector(self.position.x+5, self.position.y+water_size.y*3+3), color(), "aob", stringuppanel("> Anti-Aim Info: "..(rage.antiaim:inverter() and "-" or " ")..math.floor(rage.antiaim:get_max_desync())))
    render.text(font_pan, vector(self.position.x+5, self.position.y+water_size.y*4+3), color(), "aob", stringuppanel("> Aim-Bot Target: "..threat..desync))
    if mouse_check(vector(panel_x:get(), panel_y:get()), vector(panel_x:get() + self.size.x, panel_y:get() + self.size.y)) then
        render.text(font_pan, vector(self.position.x+5, self.position.y-15), color(255, 255, 255, 255*alpha_panel), "aob", stringuppanel("Click Right Mouse To Default Position"))
        render.text(font_pan, vector(self.position.x+5, self.position.y-25), color(255, 255, 255, 255*alpha_panel), "aob", stringuppanel("Click Middle Mouse To Change Font"))
        alpha_panel = math.lerp(alpha_panel, 1, 12)
        if common.is_button_down(0x02) then
            panel_x:set(10)
            self.position.x = 10
        end
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            font_check:set(font_check:get() + 1)
            if font_check:get() > 4 then
                font_check:set(1)
            end
        end
    elseif alpha_panel ~= 0 then
        alpha_panel = 0
    end
end)

dmg_x = other_visual.mindmggroup:slider("x_dmg", 1, screen_size.x, screen_center.x + 10)
dmg_y = other_visual.mindmggroup:slider("y_dmg", 1, screen_size.y, screen_center.y - 25)
dmg_x:visibility(false)
dmg_y:visibility(false)
local font_dmg = other_visual.mindmggroup:slider("dmg font", 1, 5, 1)
font_dmg:visibility(false)
dmg_font = font_dmg:get()
font_dmg:set_callback(function()
    dmg_font = font_dmg:get()
end)
other_call.Mnmmdmg = drag_system.register({dmg_x, dmg_y}, vector(20, 20), "Mindmg", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
	render.text(dmg_font, vector(self.position.x + 11, self.position.y + 10), color(), "cbd", ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    if mouse_check(vector(dmg_x:get(), dmg_y:get()), vector(dmg_x:get() + self.size.x, dmg_y:get() + self.size.y)) then
        render.text(dmg_font, vector(self.position.x + 11, self.position.y - 15), color(255, 255, 255, 255*alpha_damage), "cbd", "Click Middle Mouse For Change Font")
        render.text(dmg_font, vector(self.position.x + 11, self.position.y - 28), color(255, 255, 255, 255*alpha_damage), "cbd", "Click Right Mouse For Default Position")
        alpha_damage = math.lerp(alpha_damage, 1, 12)
        if common.is_button_down(0x02) then
            dmg_x:set(screen_center.x + 10)
            dmg_y:set(screen_center.y - 25)
            self.position.x = screen_center.x + 10
            self.position.y = screen_center.y - 25
        end
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            font_dmg:set(font_dmg:get() + 1)
            if font_dmg:get() > 4 then
                font_dmg:set(1)
            end
        end
    elseif alpha_damage ~= 0 then
        alpha_damage = 0
    end
end)

math.pulse = function()
    return math.clamp((math.floor(math.sin(globals.curtime * 2) * 220 + 221)) / 900 * 6.92, 0, 1) * 235 + 20
end
local ind_alpha = 0
local ind_font = other_visual.mindmggroup:slider("ind font", 1, 5, 2)
ind_font:visibility(false)
font_ind = ind_font:get()
ind_font:set_callback(function()
    font_ind = ind_font:get()
end)
local function stringup(text)
    if font_ind == 2 then return
        string.upper(text)
    else return
        string.lower(text)
    end 
end
local ind_style = other_visual.mindmggroup:slider("ind style", 1, 3, 1)
ind_style:visibility(false)
style_ind = ind_style:get()
ind_style:set_callback(function()
    style_ind = ind_style:get()
end)

function other_call.indrndr()
    local local_player = entity.get_local_player()
	local is_scoped = local_player.m_bIsScoped
	local active_binds = ui.get_binds()
	local DTRecharge = rage.exploit:get()
	MTools.Animation:Register("Indicators");
	MTools.Animation:Update("Indicators", 6);
	etterance_TEXT = MTools.Animation:Lerp("Indicators", "etterance.tech", (is_scoped), vector(screen_center.x, screen_center.y), vector(screen_center.x + 40, screen_center.y), 30);
	local etteranceDEV = gradient.text_animate("ETTERANCE", -1, {
		colors_lua.Indicatorscolor:get(), 
		colors_lua.Indicatorscolortwo:get(),
        colors_lua.Indicatorscolorthird:get(),
	})
    local etteranceDEV2 = gradient.text_animate("ETTERANCE.TECH", -1, {
		colors_lua.Indicatorscolor:get(), 
		colors_lua.Indicatorscolortwo:get(),
        colors_lua.Indicatorscolorthird:get(),
	})
    if style_ind == 1 then
        render.shadow(vector(etterance_TEXT.x - 21, screen_center.y + 40), vector(etterance_TEXT.x + 19, screen_center.y + 40), color(255, 255, 255, 255), 20, 0, 0)
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 30), color(colors_lua.Indicatorscolortwo:get().r, colors_lua.Indicatorscolortwo:get().g, colors_lua.Indicatorscolortwo:get().b, math.pulse()), "c", stringup("DEBUG"))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 40), color(), "c", stringup(etteranceDEV:get_animated_text()))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 49), colors_lua.Indicatorscolortwo:get(), "c", stringup(anti_aim.ind_state()))
        etteranceDEV:animate()
    else
        size_c_ind = render.measure_text(font_ind, "c", stringup("ETTERANCE.TECH"))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 33), color(255,0,255), "c", stringup(etteranceDEV2:get_animated_text()))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 23), color(colors_lua.Indicatorscolortwo:get().r, colors_lua.Indicatorscolortwo:get().g, colors_lua.Indicatorscolortwo:get().b, math.pulse()), "c", stringup("DEBUG"))
        render.rect(vector(etterance_TEXT.x - size_c_ind.x/2, screen_center.y + 39), vector(etterance_TEXT.x + size_c_ind.x/2, screen_center.y + 45), color(0))
        render.gradient(vector(etterance_TEXT.x - size_c_ind.x/2+1, screen_center.y + 40), vector(etterance_TEXT.x - size_c_ind.x/2+rage.antiaim:get_max_desync(), screen_center.y + 44), colors_lua.Indicatorscolortwo:get(), color(0), colors_lua.Indicatorscolortwo:get(), color(0))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y + 50), colors_lua.Indicatorscolortwo:get(), "c", stringup(anti_aim.ind_state()))
        etteranceDEV2:animate()
    end
    ind_size = render.measure_text(font_ind, "aob", stringup("  ETTERANCE  "))
    render.rect_outline(vector(etterance_TEXT.x-ind_size.x/2-10, etterance_TEXT.y+15), vector(etterance_TEXT.x + ind_size.x/2+10, etterance_TEXT.y + 75), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    if mouse_check(vector(etterance_TEXT.x-ind_size.x/2-10, etterance_TEXT.y+15), vector(etterance_TEXT.x + ind_size.x/2+10, etterance_TEXT.y + 75)) then
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+10), color(255, 255, 255, 255*ind_alpha), "c", stringup("Click Middle Mouse To Change Font"))
        render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+20), color(255, 255, 255, 255*ind_alpha), "c", stringup("Click Left Mouse To Change Style"))
        ind_alpha = math.lerp(ind_alpha, 1, 12)
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            ind_font:set(ind_font:get() + 1)
            if ind_font:get() > 4 then
                ind_font:set(1)
            end
        end
        if common.is_button_down(0x01) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            ind_style:set(ind_style:get() + 1)
            if ind_style:get() > 2 then
                ind_style:set(1)
            end
        end
    elseif ind_alpha ~= 0 then
        ind_alpha = 0
    end
	indicator_spacing = 2
    local size_ind = render.measure_text(font_ind, "c", stringup("HS"))
	indicator_spacing = 2
    if ref.dt:get() then
		render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27 + indicator_spacing+30), color(255,DTRecharge*255,DTRecharge*255,255), "c", stringup("RAPID"))
        indicator_spacing = indicator_spacing + 10
	end
    if ref.hideshots:get() then
		render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27 + indicator_spacing+30), color(), "c", stringup("OSAA"))
        indicator_spacing = indicator_spacing + 10
	end
	for i in pairs(active_binds) do
		if active_binds[i].name == "Min. Damage" then
			if active_binds[i].active then
				render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27+indicator_spacing+30), color(), "c", stringup("DMG"))
                indicator_spacing = indicator_spacing + 10
			end
		end
        if active_binds[i].name == "Safe Points" then
			if active_binds[i].active then
				render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27 + indicator_spacing+30), color(), "c", stringup("SP"))
                indicator_spacing = indicator_spacing + 10
			end
		end
        if active_binds[i].name == "Body Aim" then
			if active_binds[i].active then
				render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27 + indicator_spacing+30), color(), "c", stringup("BA"))
                indicator_spacing = indicator_spacing + 10
			end
		end
        if active_binds[i].name == "Hit Chance" then
			if active_binds[i].active then
				render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+57 + indicator_spacing), color(), "c", stringup("HC"))
                indicator_spacing = indicator_spacing + 10
			end
		end
	end
	if main_aa.freestand:get() then
		render.text(font_ind, vector(etterance_TEXT.x, screen_center.y+27 + indicator_spacing+30), color(), "c", stringup("FS"))
        indicator_spacing = indicator_spacing + 10
	end
end

local crosshair = {
    scope = 0
}
local spread_sex = 0
local spread_again = 0

local type_arr = other_visual.mindmggroup:slider("arr style", 1, 3, 1)

type_arr:visibility(false)
style_arr = type_arr:get()
type_arr:set_callback(function()
    style_arr = type_arr:get()
end)

local arr_type = other_visual.mindmggroup:slider("arrtype", 1, 3, 1)

arr_type:visibility(false)
arr_arr = arr_type:get()
arr_type:set_callback(function()
    arr_arr = arr_type:get()
end)

local arr_alpha = 0
function other_call.arrws()
    local lp = entity.get_local_player()
    MTools.Animation:Register("scope");
	MTools.Animation:Update("scope", 6);
	crosshair.scope = MTools.Animation:Lerp("scope", "scoping", (lp.m_bIsScoped), vector(screen_center.x, screen_center.y), vector(screen_center.x, screen_center.y-20), 30);
    local weapon = lp:get_player_weapon()
    if weapon == nil then return end
    spread_again = math.lerp(spread_again, tonumber(weapon:get_inaccuracy()), 20)
    if style_arr == 0 then
        if arr_arr == 1 then
            spread_sex = other_visual.arroffset:get() * (1+spread_again)
        else
            spread_sex = other_visual.arroffset:get()
        end
    else
        if arr_arr == 1 then
            spread_sex = 100 * (1+spread_again)
        else
            spread_sex = 100
        end
    end
    render.rect_outline(vector(crosshair.scope.x-spread_sex-7, crosshair.scope.y-15), vector(crosshair.scope.x+spread_sex+7, crosshair.scope.y+15), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    if style_arr == 1 then
        render.text(font.pixel1, vector(crosshair.scope.x-spread_sex+1, crosshair.scope.y-1), main_aa.custom_yaw_base:get() == "Left" and colors_lua.arrowscolor2:get() or colors_lua.arrowscolor:get(), "c", "<")
        render.text(font.pixel1, vector(crosshair.scope.x+spread_sex, crosshair.scope.y-1), main_aa.custom_yaw_base:get() == "Right" and colors_lua.arrowscolor2:get() or colors_lua.arrowscolor:get(), "c", ">")
    else
        render.poly(main_aa.custom_yaw_base:get() == "Left" and colors_lua.arrowscolor:get() or color(35, 35, 35, 150), vector(crosshair.scope.x+55-spread_sex, crosshair.scope.y), vector(crosshair.scope.x+42-spread_sex, crosshair.scope.y-9), vector(crosshair.scope.x+42-spread_sex, crosshair.scope.y+9))
        render.poly(main_aa.custom_yaw_base:get() == "Right" and colors_lua.arrowscolor:get() or color(35, 35, 35, 150), vector(crosshair.scope.x-55+spread_sex, crosshair.scope.y), vector(crosshair.scope.x-42+spread_sex, crosshair.scope.y-9), vector(crosshair.scope.x-42+spread_sex, crosshair.scope.y+9))   
        render.rect(vector(crosshair.scope.x+38-spread_sex, crosshair.scope.y-9), vector(crosshair.scope.x+40-spread_sex, crosshair.scope.y+9), rage.antiaim:inverter() == true and colors_lua.arrowscolor:get() or color(35, 35, 35, 120))
        render.rect(vector(crosshair.scope.x-40+spread_sex, crosshair.scope.y-9), vector(crosshair.scope.x-38+spread_sex, crosshair.scope.y+9), rage.antiaim:inverter() == false and colors_lua.arrowscolor:get() or color(35, 35, 35, 120))
    end

    if mouse_check(vector(crosshair.scope.x-spread_sex, crosshair.scope.y-15), vector(crosshair.scope.x+spread_sex, crosshair.scope.y+15)) then
        render.text(1, vector(crosshair.scope.x, crosshair.scope.y+20), color(255, 255, 255, 255*arr_alpha), "c", "Click Middle Mouse To Change Style")
        render.text(1, vector(crosshair.scope.x, crosshair.scope.y+30), color(255, 255, 255, 255*arr_alpha), "c", "Click Left Mouse To Change Type")
        arr_alpha = math.lerp(arr_alpha, 1, 12)
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            type_arr:set(type_arr:get()+1)
            if type_arr:get() > 2 then
                type_arr:set(1)
            end
        end
        if common.is_button_down(0x01) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            arr_type:set(arr_type:get()+1)
            if arr_type:get() > 2 then
                arr_type:set(1)
            end
        end
    elseif arr_alpha ~= 0 then
        arr_alpha = 0
    end

end

-- MISC
function other_call.customscope()
    local x = screen_center.x
    local y = screen_center.y
    local Player = entity.get_local_player()
    local Scope = Player.m_bIsScoped
    local r = math.floor(colors_lua.scopecol:get().r*120)
    local g = math.floor(colors_lua.scopecol:get().g*120)
    local b = math.floor(colors_lua.scopecol:get().b*120)
    local col = colors_lua.scopecol:get()
    local color = color(col.r, col.g, col.b, 1)
    local FirstCol = (function(a,s) if not other_visual.Scopeinverted:get() then return s else return a end end)(col, color)
    local SecondCol = (function(a,s) if not other_visual.Scopeinverted:get() then return a else return s end end)(col, color)
    if Scope then 
        render.gradient(vector(x, y + (other_visual.Scopeoffset:get()-1)+1), vector(x + 1, y + other_visual.Scopelength:get() + (other_visual.Scopeoffset:get()-1)+1), SecondCol, SecondCol, FirstCol, FirstCol)
        render.gradient(vector((x+1 + (other_visual.Scopelength:get())) + (other_visual.Scopeoffset:get()-1), y), vector(x+1 + (other_visual.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
        render.gradient(vector(x, y - (other_visual.Scopeoffset:get()-1) - other_visual.Scopelength:get()), vector(x + 1, y - (other_visual.Scopeoffset:get()-1)), FirstCol, FirstCol, SecondCol, SecondCol)
        render.gradient(vector((x - other_visual.Scopelength:get()) - (other_visual.Scopeoffset:get()-1), y), vector(x - (other_visual.Scopeoffset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
    end
end

clan_anim = function(text, indices) if not globals.is_connected then return end local text_anim = '               ' .. text .. '                      '  local tickinterval = globals.tickinterval local tickcount = globals.tickcount + math.floor(utils.net_channel().avg_latency[0]+0.22 / globals.tickinterval + 0.5) local i = tickcount / math.floor(0.3 / globals.tickinterval + 0.5) i = math.floor(i % #indices) i = indices[i+1]+1 return string.sub(text_anim, i, i+15) end
other_call.clantag = function()
	if not globals.is_connected then return end
	if misc_lua.clantag:get() then
		if local_player ~= nil and globals.is_connected and globals.choked_commands then
			clan_tag = clan_anim('etterance.tech', {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0})
			if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
				clan_tag = clan_anim('etterance.tech', {12})
				common.set_clan_tag(clan_tag)
			elseif clan_tag ~= clan_tag_prev then
				common.set_clan_tag(clan_tag)
			end
			clan_tag_prev = clan_tag
		end
		enabled_prev = false
	elseif not misc_lua.clantag:get() and enabled_prev == false then
        common.set_clan_tag('')
        enabled_prev = true
	end
end

function other_call.nade_fixer(cmd)
    local player = entity.get_local_player()
    rage.exploit:allow_defensive(true)
    local selected = player:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    trw_time = selected.m_fThrowTime
    if (trw_time ~= nil and trw_time ~= 0) then
        if string.match(wpn, "Grenade") then
            rage.exploit:allow_defensive(false)
            cmd.no_choke = true
        end
    end
end


function other_call.no_fall_damage(cmd)
    local lp = entity.get_local_player()
    local origin = lp:get_origin()
    if lp.m_vecVelocity.z <= -500 then
        if utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 15)).fraction ~= 1 then
            cmd.in_duck = 0
        elseif utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 50)).fraction ~= 1 then
            cmd.in_duck = 1
        end
    end    
end

function other_call.discharge_exp()
    local tp_check = false
    local local_player = entity.get_local_player()
    local jump = bit.band(local_player.m_fFlags, 1) == 0 and math.sqrt(local_player.m_vecVelocity.x ^ 2 + local_player.m_vecVelocity.y ^ 2) > 150
    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    if misc_lua.teleport_wpn:get("AWP") and string.match(weapon, "AWP") then tp_check = true end
    if misc_lua.teleport_wpn:get("Scout") and string.match(weapon, "SSG08") then tp_check = true end
    if misc_lua.teleport_wpn:get("Knife") and string.match(weapon, "Knife") then tp_check = true end
    if misc_lua.teleport_wpn:get("Taser") and string.match(weapon, "Taser") then tp_check = true end
    if misc_lua.teleport_wpn:get("Shotgun") and (string.match(weapon, "Mag7") or string.match(weapon, "Sawedoff") or string.match(weapon, "NOVA") or string.match(weapon, "XM1014")) then tp_check = true end
    if misc_lua.teleport_wpn:get("Pistols") and (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "DEagle") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000")) then tp_check = true end
    if misc_lua.teleport:get() and jump then
        if (tp_check == true and entity.get_threat(true) ~= nil) then
            rage.exploit:force_teleport()
            tp_check = false
        end
    end
end


function other_call.fastladder(cmd)
    local lp = entity.get_local_player()
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

function other_call.sin_vec(x, y)
    sin_x = math.sin(math.rad(x))
    cos_x = math.cos(math.rad(x))
    sin_y = math.sin(math.rad(y))
    cos_y = math.cos(math.rad(y))
    return vector(cos_x * cos_y, cos_x * sin_y, -sin_x);
end
function other_call.avoid_colision(cmd)
    local lp = entity.get_local_player()
    local minimum, value = math.huge, math.huge
    for z = 1, 180 do
        local line_trace = utils.trace_line(lp.m_vecOrigin, vector(lp.m_vecOrigin.x + other_call.sin_vec(0, (render.camera_angles().y + z - 90)).x * 70, lp.m_vecOrigin.y + other_call.sin_vec(0, (render.camera_angles().y + z - 90)).y * 70, lp.m_vecOrigin.z + 60), nil, nil, 1)
        if(lp.m_vecOrigin:dist(line_trace.end_pos) < minimum) then
            minimum = lp.m_vecOrigin:dist(line_trace.end_pos)
            value = z
        end
    end
    if minimum < misc_lua.avoid_distance:get() and cmd.in_jump and not (cmd.in_back or cmd.in_moveleft or cmd.in_moveright) then
        if(value >= 90) then
            cmd.sidemove = lp.m_vecVelocity:length() * math.sin(math.rad(value))
        else
            cmd.sidemove = (lp.m_vecVelocity:length() * math.sin(math.rad(value))) * -1
        end
        cmd.forwardmove = math.abs(lp.m_vecVelocity:length() * math.cos(math.rad(value)))
    end
end

function other_call.air_hc()
    ref.hc:override()
    if not misc_lua.air_switch:get() then return end
    local local_player = entity.get_local_player()
    local jump = bit.band(local_player.m_fFlags, 1) == 0
    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    r8_check = false
    if string.match(weapon, "DEagle") then r8_check = true end
    pistols_check = false
    if (string.match(weapon, "Glock") or string.match(weapon, "P250") or string.match(weapon, "FiveSeven") or string.match(weapon, "Elite") or string.match(weapon, "Tec9") or string.match(weapon, "HKP2000")) then pistols_check = true end
    scout_check = false
    if string.match(weapon, "SSG08") then scout_check = true end
    if jump  and (misc_lua.air_select:get("Scout") and scout_check == true) then
        ref.hc:override(misc_lua.air_scout:get())
    end
    if jump and (misc_lua.air_select:get("R8") and r8_check == true) then
        ref.hc:override(misc_lua.air_awp:get())
    end
    if jump and (misc_lua.air_select:get("Pistols") and pistols_check == true) then
        ref.hc:override(misc_lua.air_pistols:get())
    end
end

view_fov = misc_lua.viewmodel_fov:get()
view_x = misc_lua.viewmodel_x:get()
view_y = misc_lua.viewmodel_y:get()
view_z = misc_lua.viewmodel_z:get()

if misc_lua.viewmodel_switch:get() then
    cvar.viewmodel_fov:int(view_fov, true)
    cvar.viewmodel_offset_x:float(view_x, true)
    cvar.viewmodel_offset_y:float(view_y, true)
    cvar.viewmodel_offset_z:float(view_z, true)
end

misc_lua.viewmodel_fov:set_callback(function()
    if not misc_lua.viewmodel_switch:get() then return end
	cvar.viewmodel_fov:int(misc_lua.viewmodel_fov:get(), true)
    view_fov = misc_lua.viewmodel_fov:get()
end)

misc_lua.viewmodel_x:set_callback(function()
    if not misc_lua.viewmodel_switch:get() then return end
	cvar.viewmodel_offset_x:float(misc_lua.viewmodel_x:get(), true)
    view_x = misc_lua.viewmodel_x:get()
end)

misc_lua.viewmodel_y:set_callback(function()
    if not misc_lua.viewmodel_switch:get() then return end
	cvar.viewmodel_offset_y:float(misc_lua.viewmodel_y:get(), true)
    view_y = misc_lua.viewmodel_y:get()
end)

misc_lua.viewmodel_z:set_callback(function()
    if not misc_lua.viewmodel_switch:get() then return end
	cvar.viewmodel_offset_z:float(misc_lua.viewmodel_z:get(), true)
    view_z = misc_lua.viewmodel_z:get()
end)

misc_lua.viewmodel_switch:set_callback(function()
    if not misc_lua.viewmodel_switch:get() then
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    else
        cvar.viewmodel_fov:int(view_fov, true)
        cvar.viewmodel_offset_x:float(view_x, true)
        cvar.viewmodel_offset_y:float(view_y, true)
        cvar.viewmodel_offset_z:float(view_z, true)
    end
end)

testing = misc_lua.aspect_ratio_slider:get()/100

misc_lua.aspect_ratio_slider:set_callback(function()
    if not misc_lua.aspect_ratio_switch:get() then return end
    testing = misc_lua.aspect_ratio_slider:get()/100
    cvar.r_aspectratio:float(testing)
end)
if misc_lua.aspect_ratio_switch:get() then
    cvar.r_aspectratio:float(testing)
end
misc_lua.aspect_ratio_switch:set_callback(function()
    if misc_lua.aspect_ratio_switch:get() then
        cvar.r_aspectratio:float(testing)
    else
        cvar.r_aspectratio:float(0)
    end
end)

function other_call.fpsboost(check)
    cvar.r_shadows:int(check and 1 or 0)
    cvar.cl_csm_static_prop_shadows:int(check and 1 or 0)
    cvar.cl_csm_shadows:int(check and 1 or 0)
    cvar.cl_csm_world_shadows:int(check and 1 or 0)
    cvar.cl_foot_contact_shadows:int(check and 1 or 0)
    cvar.cl_csm_viewmodel_shadows:int(check and 1 or 0)
    cvar.cl_csm_rope_shadows:int(check and 1 or 0)
    cvar.cl_csm_sprite_shadows:int(check and 1 or 0)
    cvar.r_dynamic:int(check and 1 or 0)
    cvar.cl_autohelp:int(check and 1 or 0)
    cvar.r_eyesize:int(check and 1 or 0)
    cvar.r_eyeshift_z:int(check and 1 or 0)
    cvar.r_eyeshift_y:int(check and 1 or 0)
    cvar.r_eyeshift_x:int(check and 1 or 0)
    cvar.r_eyemove:int(check and 1 or 0)
    cvar.r_eyegloss:int(check and 1 or 0)
    cvar.r_drawtracers_firstperson:int(check and 1 or 0)
    cvar.r_drawtracers:int(check and 1 or 0)
    cvar.fog_enable_water_fog:int(check and 1 or 0)
    cvar.mat_postprocess_enable:int(check and 1 or 0)
    cvar.cl_disablefreezecam:int(check and 1 or 0)
    cvar.cl_freezecampanel_position_dynamic:int(check and 1 or 0)
    cvar.r_drawdecals:int(check and 1 or 0)
    cvar.muzzleflash_light:int(check and 1 or 0)
    cvar.r_drawropes:int(check and 1 or 00)
    cvar.r_drawsprites:int(check and 1 or 0)
    cvar.cl_disablehtmlmotd:int(check and 1 or 0)
    cvar.cl_freezecameffects_showholiday:int(check and 1 or 0)
    cvar.cl_bob_lower_amt:int(check and 1 or 0)
    cvar.cl_detail_multiplier:int(check and 1 or 0)
    cvar.mat_drawwater:int(check and 1 or 0) 
    cvar.func_break_max_pieces:int(check and 1 or 0)
    cvar.cl_threaded_bone_setup:int(check and 1 or 0)
end

misc_lua.fps_boost:set_callback(function()
    other_call.fpsboost(not misc_lua.fps_boost:get())
end)

other_call.fpsboost(not misc_lua.fps_boost:get())

local task = {}
task.hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")
task.hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", task.hwnd) + 2)[0])[0] + 2)
task.overlay = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1")
task.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", task.overlay)
task.Window = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")
task.GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", task.Window) + 2)[0])[0]
task.FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")
task.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", task.FlashWindow)
notify_round = function()
    if task.insn_jmp_ecx(task.GetForegroundWindow) ~= task.hwnd_ptr[0] then
        task.flash_window(task.hwnd_ptr[0], 1)
    end
end

font_log = ind_font:get()
local function stringuplog(text)
    if font_log == 2 then
        text = string.gsub(text, " ", "    ")
    end
    if font_log == 2 then return 
        string.upper(text)
    else return
        text
    end 
end
log_x = other_visual.mindmggroup:slider("x_log", 1, screen_size.x, screen_center.x-150)
log_y = other_visual.mindmggroup:slider("y_log", 1, screen_size.y, screen_center.y+200)
log_x:visibility(false)
log_y:visibility(false)
log_font = other_visual.mindmggroup:slider("log_font", 1, 5)
log_font:visibility(false)
font_log = log_font:get()
log_font:set_callback(function()
    font_log = log_font:get()
end)

log_style = other_visual.mindmggroup:slider("log_style", 1, 5)
style_log = log_style:get()
log_style:visibility(false)
log_font:set_callback(function()
    style_log = log_style:get()
end)

log_alpha = 0

local logs = {}
other_call.logs_func = drag_system.register({log_x, log_y}, vector(320, 130), "Aye Log", function(self)
    local offset = 0
    x = self.position.x+151
    y = self.position.y-10
    local anim_text = gradient.text_animate("ET", 0.7, {color(60, 60, 60), color(78,169,249)})
    anim_text:animate()
    if log_style:get() == 4 then
        log_et_text = "["..anim_text:get_animated_text().."\aFFFFFFFF] "
    else
        log_et_text = ""
    end
    for idx, data in ipairs(logs) do
        if globals.curtime - data[3] < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 10)
        else
            data[2] = math.lerp(data[2], 0, 10)
        end
        if log_style:get() == 1 then
            offset = offset - 20 * (data[2] / 255)
        else
            offset = offset - 40 * (data[2] / 255)
        end
        if not other_visual.emoji_check:get() then
            data[1] = string.gsub(data[1], "🪐", "")
            data[1] = string.gsub(data[1], "🚨", "")
            data[1] = string.gsub(data[1], "💣", "")
            data[1] = string.gsub(data[1], "🔥", "")
        end
        text_size = render.measure_text(font_log, s, stringuplog(log_et_text..data[1]))
        if ui.get_alpha() == 0 then
            if log_style:get() == 1 then
                render.shadow(vector(x+13 - text_size.x / 2, y - offset+text_size.y-5), vector(x + 3 + text_size.x / 2, y - offset+text_size.y-5), color(colors_lua.log_color:get().r, colors_lua.log_color:get().g, colors_lua.log_color:get().b, (data[2] / 255)*colors_lua.log_color:get().a), 35, -1, 0)
            elseif log_style:get() == 2 then
                grad_col = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, data[2])
                glow_col = color(colors_lua.shadow_col:get().r, colors_lua.shadow_col:get().g, colors_lua.shadow_col:get().b, (data[2]/255)*colors_lua.shadow_col:get().a)
                render.shadow(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+8), vector(x+13 + text_size.x / 2, y - offset+text_size.y+5), glow_col, 30, 0, 2)
                render.rect(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+8), vector(x+13 + text_size.x / 2, y - offset+text_size.y+5), color(29, 29, 29, data[2]/1.5), 0)
                render.gradient(vector(x + 2 - text_size.x / 2, y - offset - text_size.y+8), vector(x + 5 - text_size.x / 2, y - offset+text_size.y+5), grad_col, grad_col, grad_col, grad_col, 3)
                render.gradient(vector(x+13 + text_size.x / 2, y - offset - text_size.y+8), vector(x+16 + text_size.x / 2, y - offset+text_size.y+5), grad_col, grad_col, grad_col, grad_col, 3)
            elseif log_style:get() == 3 then
                grad_col = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, data[2])
                render.rect(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+6), vector(x+13 + text_size.x / 2, y - offset - text_size.y+8), grad_col)
                render.shadow(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+6), vector(x+13 + text_size.x / 2, y - offset - text_size.y+8), grad_col, 30, 0, 2)
                render.rect(vector(x + 5 - text_size.x / 2, y - offset - text_size.y+8), vector(x+13 + text_size.x / 2, y - offset+text_size.y+5), color(29, 29, 29, data[2]/3))
            else

            render.rect(vector(x + 2 - text_size.x / 2, y - 1 - offset - text_size.y/2), vector(x + text_size.x/2 + 15, y + 31 - offset - text_size.y), color(40,40,40, data[2]), 0)
            render.rect_outline(vector(x + 3 - text_size.x / 2, y - offset - text_size.y/2), vector(x + 14+ text_size.x/2, y + 30 - offset - text_size.y), color(0, 0, 0, data[2]/2), 0)
            render.rect(vector(x+7-text_size.x / 2, y - offset - text_size.y/2+4), vector(x + text_size.x/2 + 11, y + 26 - offset - text_size.y), color(20,20,20, data[2]), 0)
            render.rect_outline(vector(x+6- text_size.x / 2, y - offset - text_size.y/2+3), vector(x + text_size.x/2 + 11, y + 27 - offset - text_size.y), color(60,60,60, data[2]), 0)
            render.gradient(vector(x+7 - text_size.x/2, y - offset - text_size.y/2+4), vector(x+8, y - offset - text_size.y/2+5), color(78,169,249,data[2]), color(254,86,217,data[2]), color(78,169,249,data[2]), color(254,86,217,data[2]))
            render.gradient(vector(x+8, y - offset - text_size.y/2+4), vector(x + text_size.x/2+10, y - offset - text_size.y/2+5), color(254,86,217,data[2]), color(214,255,108,data[2]), color(254,86,217,data[2]), color(214,255,108,data[2]))

            end
            render.text(font_log, vector(x + 9 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", stringuplog(log_et_text..data[1]))
        end
        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
    if ui.get_alpha() > 0 and other_visual.printconsole:get(3) then
        render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
        if other_visual.emoji_check:get() then
            text_size1 = render.measure_text(font_log, "od", stringuplog(log_et_text.."🪐Hit \a8FB9FFFFblameless's \aFFFFFFFFstomach for \aA1FF8FFF108\aFFFFFFFF (108) bt: \aA1FF8FFF10 \aFFFFFFFF| hp: \aA1FF8FFF0\aFFFFFFFF🪐"))
        else
            text_size1 = render.measure_text(font_log, "od", stringuplog(log_et_text.."Hit \a8FB9FFFFblameless's \aFFFFFFFFstomach for \aA1FF8FFF108\aFFFFFFFF (108) bt: \aA1FF8FFF10 \aFFFFFFFF| hp: \aA1FF8FFF0\aFFFFFFFF"))
        end
        if log_style:get() == 1 then
            render.shadow(vector(x+13 - text_size1.x / 2, y +20+text_size1.y-5), vector(x + 3 + text_size1.x / 2, y +20+text_size1.y-5), color(colors_lua.log_color:get().r, colors_lua.log_color:get().g, colors_lua.log_color:get().b, colors_lua.log_color:get().a*ui.get_alpha()), 35, -1, 0)
        elseif log_style:get() == 2 then
            grad_col = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, 255*ui.get_alpha())
            glow_col = color(colors_lua.shadow_col:get().r, colors_lua.shadow_col:get().g, colors_lua.shadow_col:get().b, ui.get_alpha()*colors_lua.shadow_col:get().a)
            render.shadow(vector(x + 5 -  text_size1.x / 2, y + 20 -  text_size1.y+8), vector(x+13 +  text_size1.x / 2, y + 20+ text_size1.y+5), glow_col, 30, 0, 2)
            render.rect(vector(x + 5 -  text_size1.x / 2, y + 20 -  text_size1.y+8), vector(x+13 +  text_size1.x / 2, y + 20+ text_size1.y+5), color(29, 29, 29, (255/1.5)*ui.get_alpha()), 0)
            render.gradient(vector(x + 2 -  text_size1.x / 2, y + 20 -  text_size1.y+8), vector(x + 5 -  text_size1.x / 2, y + 20+ text_size1.y+5), grad_col, grad_col, grad_col, grad_col, 3)
            render.gradient(vector(x+13 +  text_size1.x / 2, y + 20 -  text_size1.y+8), vector(x+16 +  text_size1.x / 2, y + 20+ text_size1.y+5), grad_col, grad_col, grad_col, grad_col, 3)
        elseif log_style:get() == 3 then
            grad_col = color(colors_lua.text_col:get().r, colors_lua.text_col:get().g, colors_lua.text_col:get().b, 255*ui.get_alpha())
            render.rect(vector(x + 5 - text_size1.x / 2, y +20 - text_size1.y+6), vector(x+13 + text_size1.x / 2, y +20 - text_size1.y+8), grad_col)
            render.shadow(vector(x + 5 - text_size1.x / 2, y +20 - text_size1.y+6), vector(x+13 + text_size1.x / 2, y +20 - text_size1.y+8), grad_col, 30, 0, 2)
            render.rect(vector(x + 5 - text_size1.x / 2, y +20 - text_size1.y+8), vector(x+13 + text_size1.x / 2, y +20+text_size1.y+5), color(29, 29, 29, (255*ui.get_alpha()/3)))
        else
            render.rect(vector(x + 2 - text_size1.x / 2, y +13), vector(x + text_size1.x/2 + 14, y + 38), color(40,40,40, 255*ui.get_alpha()), 0)
            render.rect_outline(vector(x + 3 - text_size1.x / 2, y - 6+20), vector(x + 7+ text_size1.x/2 + 6, y + 37), color(0, 0, 0, (255/2*ui.get_alpha())), 0)
            render.rect(vector(x+7-text_size1.x / 2, y + 18), vector(x + text_size1.x/2 + 10, y + 34), color(20,20,20, 255*ui.get_alpha()), 0)
            render.rect_outline(vector(x+6- text_size1.x / 2, y+17), vector(x + text_size1.x/2 + 10, y + 35), color(60,60,60, 255*ui.get_alpha()), 0)
            render.gradient(vector(x+7- text_size1.x / 2, y + 18), vector(x + 7+(text_size1.x/4), y + 19), color(78,169,249,255*ui.get_alpha()), color(254,86,217,255*ui.get_alpha()), color(78,169,249,255*ui.get_alpha()), color(254,86,217,255*ui.get_alpha()))
            render.gradient(vector(x+7, y + 18), vector(x + text_size1.x/2+9, y + 19), color(254,86,217,255*ui.get_alpha()), color(214,255,108,255*ui.get_alpha()), color(254,86,217,255*ui.get_alpha()), color(214,255,108,255*ui.get_alpha()))
        end
        if other_visual.emoji_check:get() then
            render.text(font_log, vector(x + 9 - text_size1.x / 2, y + 20), color(255, 255, 255, 255*ui.get_alpha()), "od", stringuplog(log_et_text.."🪐Hit \a8FB9FFFFblameless's \aFFFFFFFFstomach for \aA1FF8FFF108\aFFFFFFFF (108) bt: \aA1FF8FFF10 \aFFFFFFFF| hp: \aA1FF8FFF0\aFFFFFFFF🪐"))
        else
            render.text(font_log, vector(x + 9 - text_size1.x / 2, y + 20), color(255, 255, 255, 255*ui.get_alpha()), "od", stringuplog(log_et_text.."Hit \a8FB9FFFFblameless's \aFFFFFFFFstomach for \aA1FF8FFF108\aFFFFFFFF (108) bt: \aA1FF8FFF10 \aFFFFFFFF| hp: \aA1FF8FFF0\aFFFFFFFF"))
        end
    end
    if mouse_check(vector(log_x:get(), log_y:get()), vector(log_x:get() + self.size.x, log_y:get() + self.size.y)) then
        render.text(font_log, vector(self.position.x + 11, self.position.y - 15), color(255, 255, 255, 255*log_alpha), "od", stringuplog("Click Middle Mouse For Change Font"))
        render.text(font_log, vector(self.position.x + 11, self.position.y - 25), color(255, 255, 255, 255*log_alpha), "od", stringuplog("Click Left CTRL For Change Style"))
        render.text(font_log, vector(self.position.x + 11, self.position.y - 35), color(255, 255, 255, 255*log_alpha), "od", stringuplog("Click Right Mouse For Centering"))
        log_alpha = math.lerp(log_alpha, 1, 12)
        if common.is_button_down(0x02) then
            log_x:set(screen_center.x-160)
            self.position.x = screen_center.x-160
        end
        if common.is_button_down(0x04) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            log_font:set(log_font:get()+1)
            if log_font:get() > 4 then
                log_font:set(1)
            end
        end
        if common.is_button_down(0xA2) and checktime_last + 0.1 < globals.realtime then
            checktime_last = globals.realtime + 0.1
            log_style:set(log_style:get()+1)
            if log_style:get() > 4 then
                log_style:set(1)
            end
        end
    elseif log_alpha ~= 0 then
        log_alpha = 0
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end

render.log("🪐Welcome to Etterance!🪐")

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

    if state == nil then
        if not globals.is_connected and not globals.is_in_game then return false end
        if other_visual.printconsole:get(3) then
            render.log(("🪐Hit \a8FB9FFFF%s \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF🪐"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if other_visual.printconsole:get(2) then
            print_dev(("\a4562FFFF[etterance] » \aA0FB87AARegistered \aD5D5D5AAshot at %s %s for \aA0FB87AA%d("..string.format("%.f", wanted_damage)..") \aD5D5D5AAdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if other_visual.printconsole:get(1) then
            print_raw(("\a4562FFFF[etterance] » \aA0FB87AARegistered \aD5D5D5AAshot at %s %s for \aA0FB87AA%d("..string.format("%.f", wanted_damage)..") \aD5D5D5AAdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
    end
    if state ~= nil then
        if other_visual.printconsole:get(3) then
            render.log(('🚨Missed \a8FB9FFFF%s \aFFFFFFFF%s due to \aE94B4BFF'..state..' \aFFFFFFFFbt: '..bt..' | dmg: '..string.format("%.f", wanted_damage)..'🚨'):format(target:get_name(), wanted_hitgroup, state1))
        end
        if other_visual.printconsole:get(2) then
            print_dev(('\a4562FFAA[etterance] » \aE94B4BAAMissed \aFFFFFFAAshot in %s in the %s due to \aE94B4BAA'..state..' \aFFFFFFAA(hc: '..string.format("%.f", hitchance)..') (dmg: '..string.format("%.f", wanted_damage)..') (bt: '..bt..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
        if other_visual.printconsole:get(1) then
            print_raw(('\a4562FFAA[etterance] » \aE94B4BAAMissed \aFFFFFFAAshot in %s in the %s due to \aE94B4BAA'..state..' \aFFFFFFAA(hc: '..string.format("%.f", hitchance)..') (dmg: '..string.format("%.f", wanted_damage)..') (bt: '..bt..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
    end
end)

events.player_hurt:set(function(e)
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
            if other_visual.printconsole:get(1) then
                print_raw(('\a4562FFAA[etterance] \aD5D5D5AA'..type_hit..' %s for \aA0FB87AA%d damage \aFFFFFFAA(%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if other_visual.printconsole:get(2) then
                print_dev(('\a4562FFAA[etterance] \aD5D5D5AA'..type_hit..' %s for \aA0FB87AA%d damage \aFFFFFFAA(%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if other_visual.printconsole:get(3) then
                if type_hit ~= "Burned" then
                    render.log(("💣"..type_hit..' %s for %d damage💣'):format(user:get_name(), e.dmg_health))
                else
                    render.log(("🔥"..type_hit..' %s for %d damage🔥'):format(user:get_name(), e.dmg_health))
                end
            end
        end
    end
end)

events.round_start:set(function()
    currentphase = 1
    if misc_lua.round_notify:get() then
        notify_round()
    end
    if other_visual.printconsole:get(3) then
        render.log("🪐Reset anti-aim data due to new round start. Phase: "..currentphase..". 🪐")
    end
end)

events.render:set(function()
    other_call.clantag()
    other_call.Infopanel:update()
    if other_visual.ScopeCustom:get() then
        ref.removesc:override("Remove all")
    else
        ref.removesc:override()
    end
    if other_visual.solus_widgets:get(1) and other_visual.Widgets:get() then
        watermark_func()
    end
    if other_visual.solus_widgets:get(2) and other_visual.Widgets:get() then
        new_drag_object:update()
    end
    if other_visual.solus_widgets:get(3) and other_visual.Widgets:get() then
        new_drag_object1:update()
    end
    if other_visual.grenade_radius:get() then
        other_call.nade_radius()
    end
    if other_visual.enablelogs:get() then
        other_call.logs_func:update()
    end
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    if other_visual.panel_enable:get() then
        other_call.panel:update()
    end
    if other_visual.Indicators:get() then
		other_call.indrndr()
	end
	if other_visual.MinDMG:get() then
		other_call.Mnmmdmg:update()
	end
    if other_visual.arrows:get() then
        other_call.arrws()
    end
    if other_visual.ScopeCustom:get() then
        other_call.customscope()
    end
    if other_visual.velocity_indicator_enable:get() then
        velocity_ind:update()
    end
    if other_visual.defensive_indicator_enable:get() then
        def_man:update()
    end
end)

events.createmove:set(function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    other_call.air_hc()
    anti_aim.antiaim_setup(cmd)
    if misc_lua.fast_ladder:get() then
        other_call.fastladder(cmd)
    end
    if misc_lua.no_fall_damage:get() then
        other_call.no_fall_damage(cmd)
    end
    if misc_lua.nade_fix:get() then
        other_call.nade_fixer(cmd)
    end
    if misc_lua.teleport:get() then
        other_call.discharge_exp()
    end
    if misc_lua.avoid_colision:get() then
        other_call.avoid_colision(cmd)
    end
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
    cvar.r_aspectratio:float(0)
    common.set_clan_tag('')
    db.configs_debug = configs_db
end)

events.mouse_input:set(function()
    return not (ui.get_alpha() > 0)
end) 

local config_all = pui.setup({main_aa, other_visual, misc_lua, colors_lua, aa_condition}, true)

tabs.main1:button(ui.get_icon('share-nodes').."\a"..style_hex.."   Export Config  ", function()
    clipboard.set(base64.encode(json.stringify(config_all:save())))
    cvar.play:call("ambient\\tones\\elev1")
end, true)
tabs.main1:button(ui.get_icon('download').."\a"..style_hex.."    Import Config   ", function()
    config_all:load(json.parse(base64.decode(clipboard.get())))
    cvar.play:call("ambient\\tones\\elev1")
end, true)

tabs.main1:button(ui.get_icon('check').."\a"..style_hex.."                        Default Config                         ", function()
    config_all:load(json.parse(base64.decode("W3siYWRkaXRpb25zIjpbIlNoaXQgQUEgT24gV2FybXVwIiwiQW50aX5CYWNrc3RhYiIsIn4iXSwiYWlyYnJlYWtlciI6Ik9mZiIsImFuaW1zIjpmYWxzZSwiY29uZGl0aW9uIjoiXHUwMDA3MDJBOEY0RkZHbG9iYWwiLCJjdXN0b21feWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJlbmFibGVfbGlzdCI6Mi4wLCJmcmVlc3RhbmQiOmZhbHNlLCJncm91bmRicmVha2VyIjoiT2ZmIiwibGVnc19qaXQiOjgwLjAsIm90aGJyZWFrZXIiOlsifiJdLCJwaXRjaF9zZXQiOiJEb3duIiwic2VsZWN0X3RhYiI6MS4wLCJzdGF0aWNmcmVlcyI6WyJ+Il0sIndwbl9zZWxlY3QiOlsifiJdfSx7IkluZGljYXRvcnMiOmZhbHNlLCJNaW5ETUciOnRydWUsIlNjb3BlQ3VzdG9tIjpmYWxzZSwiU2NvcGVpbnZlcnRlZCI6ZmFsc2UsIlNjb3BlbGVuZ3RoIjo1NS4wLCJTY29wZW9mZnNldCI6MTEuMCwiV2lkZ2V0cyI6dHJ1ZSwiYXJyb2Zmc2V0Ijo1MC4wLCJhcnJvd3MiOnRydWUsImN1c3RvbV9jb25zb2xlIjpmYWxzZSwiY3VzdG9tX25hbWUiOiJ5b3VuZ3NrZWV0IiwiZGVmZW5zaXZlX2luZGljYXRvcl9lbmFibGUiOmZhbHNlLCJlbW9qaV9jaGVjayI6ZmFsc2UsImVuYWJsZWxvZ3MiOnRydWUsImVuZW15X21vbG90b3ZfY29sb3IiOiIjRkYzRjNGQkUiLCJncmVuYWRlX3JhZGl1cyI6ZmFsc2UsImdyZW5hZGVfc2VsZWN0IjpbIn4iXSwibW9sb3Rvdl9jb2xvciI6IiM3NEMwMjlGRiIsInBhbmVsX2VuYWJsZSI6ZmFsc2UsInByaW50Y29uc29sZSI6WzEuMCwzLjAsIn4iXSwic21va2VfY29sb3IiOiIjM0Q5M0ZBQjQiLCJzb2xfZW1vamkiOmZhbHNlLCJzb2x1c190eXBlIjo4LjAsInNvbHVzX3dpZGdldHMiOlsxLjAsMi4wLDMuMCwifiJdLCJ2ZWxvY2l0eV9pbmRpY2F0b3JfZW5hYmxlIjpmYWxzZX0seyJhaXJfYXdwIjo4OS4wLCJhaXJfcGlzdG9scyI6ODkuMCwiYWlyX3Njb3V0Ijo0NS4wLCJhaXJfc2VsZWN0IjpbIlNjb3V0IiwifiJdLCJhaXJfc3dpdGNoIjp0cnVlLCJhc3BlY3RfcmF0aW9fc2xpZGVyIjoxMzMuMCwiYXNwZWN0X3JhdGlvX3N3aXRjaCI6dHJ1ZSwiYXZvaWRfY29saXNpb24iOmZhbHNlLCJhdm9pZF9kaXN0YW5jZSI6NDUuMCwiY2xhbnRhZyI6ZmFsc2UsImZhc3RfbGFkZGVyIjp0cnVlLCJmcHNfYm9vc3QiOnRydWUsIm5hZGVfZml4Ijp0cnVlLCJub19mYWxsX2RhbWFnZSI6dHJ1ZSwicm91bmRfbm90aWZ5IjpmYWxzZSwidGVsZXBvcnQiOmZhbHNlLCJ0ZWxlcG9ydF93cG4iOlsifiJdLCJ2aWV3bW9kZWxfZm92Ijo2OC4wLCJ2aWV3bW9kZWxfc3dpdGNoIjpmYWxzZSwidmlld21vZGVsX3giOjIuMCwidmlld21vZGVsX3kiOjAuMCwidmlld21vZGVsX3oiOi0xLjB9LHsiSW5kaWNhdG9yc2NvbG9yIjoiIzY0NjQ2NEZGIiwiSW5kaWNhdG9yc2NvbG9ydGhpcmQiOiIjRkZGRkZGRkYiLCJJbmRpY2F0b3JzY29sb3J0d28iOiIjOTY5Njk2RkYiLCJhcnJvd3Njb2xvciI6IiM5Njk2OTZGRiIsImFycm93c2NvbG9yMiI6IiNGRkZGRkZGRiIsImRlZmVuc2l2ZV9pbmRpY2F0b3JfY29sb3JfMSI6IiNGRkZGRkZGRiIsImRlZmVuc2l2ZV9pbmRpY2F0b3JfY29sb3JfMiI6IiMwMDAwMDBGRiIsImxvZ19jb2xvciI6IiNGRkZGRkZGRiIsInBhbmVsX2NvbG9yMSI6IiM2NDY0NjRGRiIsInBhbmVsX2NvbG9yNCI6IiNGRkZGRkZGRiIsInNjb3BlY29sIjoiI0ZGRkZGRkZGIiwic2hhZG93X2NvbCI6IiM3OEEyRkZGRiIsInRleHRfY29sIjoiIzhDOTBGMEZGIiwidmVsb2NpdHlfaW5kaWNhdG9yX2NvbG9yXzEiOiIjRkZGRkZGRkYiLCJ2ZWxvY2l0eV9pbmRpY2F0b3JfY29sb3JfMiI6IiMwMDAwMDBGRiJ9LFt7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfbGJ5X2wxIjo0Mi4wLCJhYl9sYnlfbDIiOjQ0LjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo1Ny4wLCJhYl9sYnlfcjIiOjUxLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoyLjAsImFiX3NlbGVjdDEiOlsiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QyIjpbIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJSYW5kb20gV2F5IiwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6MzAuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOnRydWUsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOi0yMC4wLCJkZWZfcGl0Y2giOi00OS4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6NTQuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJSYW5kb20gV2F5IiwiZGVsYXlfdGlja3MiOjYuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTMwLjAsInlhd19yIjozMC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6LTIwLjAsImRlZl9waXRjaCI6LTQ5LjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo3NS4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IlJhbmRvbSBXYXkiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIiwifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOnRydWUsImRlZl9tYXgiOjMxLjAsImRlZl9taW4iOi0zMS4wLCJkZWZfcGl0Y2giOi00OS4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6NzAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJSYW5kb20gV2F5IiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IlJhbmRvbSIsImppdHRlcl9jZW50ZXIiOi0xNC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciIsIn4iXSwieWF3X2wiOi04LjAsInlhd19yIjoxOS4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifV1d")))
    cvar.play:call("ambient\\tones\\elev1")
end, true)