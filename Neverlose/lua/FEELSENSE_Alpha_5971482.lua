-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local MTools = require("neverlose/mtools")
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local pui = require("neverlose/pui")

local style = ui.get_style "Button"
local style_hex = style:to_hex()


local Feelsense_sense = gradient.text_animate("S E N S E", -1, {
    color(200, 200, 200, 240),
    color(150, 150, 150, 200),
    color(100, 100, 100, 160),
})

local newsense = gradient.text_animate("sense", -0.7, {
    color(200, 200, 200, 240),
    color(150, 150, 150, 200),
    color(100, 100, 100, 160),
})

ui.sidebar("\vFEEL "..Feelsense_sense:get_animated_text(), ui.get_icon("moon-stars"))

local tabs = {
    main2 = pui.create(" ⋆｡° ✮ ", ui.get_icon('moon-stars').." Main ", 1),
    main = pui.create(" ⋆｡° ✮ ", ui.get_icon('rss').." Recomendations ", 2),
    main1 = pui.create(" ⋆｡° ✮ ", ui.get_icon('gear').." Configs ", 2),
    turn = pui.create(" ♡ ", ui.get_icon('ballot-check').."  Switcher     ", 1),
    antiselect = pui.create(" ♡ ", ui.get_icon('ballot-check').."  Condition     ", 1),
    anti1 = pui.create(" ♡ ", ui.get_icon('star').."  Main     ", 1),
    antisel = pui.create(" ♡ ", ui.get_icon('star').."  Select     ", 2),
    configs = pui.create(" ♡ ", ui.get_icon('layer-plus').."  Config System     ", 2),
    anti2 = pui.create(" ♡ ", ui.get_icon('sliders').." Builder ", 2),
    antid = pui.create(" ♡ ", ui.get_icon('shield').."  Defensive   ", 1),
    antib = pui.create(" ♡ ", ui.get_icon('sliders-up').."  Anti~Bruteforce   ", 1),
    misc = pui.create(" ⋆ ˚｡⋆⋆ ˚｡⋆ ", ui.get_icon('star').." Misc ", 1),
    mod = pui.create(" ⋆ ˚｡⋆⋆ ˚｡⋆ ", ui.get_icon('star').." Modifications ", 1),
    visuals = pui.create(" ⋆ ˚｡⋆⋆ ˚｡⋆ ", ui.get_icon('rocket').." Visuals ", 2),
    inter = pui.create(" ⋆ ˚｡⋆⋆ ˚｡⋆ ", ui.get_icon('rocket').." Interface ", 2),
}

tabs.main2:label(" »   Welcome, \bFFFFFFFF\b"..style_hex.."["..common.get_username().."]")
tabs.main2:label(" »   Author - \bFFFFFFFF\b"..style_hex.."[who?]")
tabs.main2:label(" »   Stay with us -  \bFFFFFFFF\b"..style_hex.."[feelsense]")
tabs.main2:label(" »   Version - \bFFFFFFFF\b"..style_hex.."[alpha]")

tabs.main:button("         \a7E92FFFF"..ui.get_icon('discord').."         ",function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.com/invite/yUEv7KeCFv")
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
main_aa.enable_list = tabs.turn:list("", {"\v"..ui.get_icon('caret-right').."\r Disabled", "\v"..ui.get_icon('caret-right').."\r Enabled"})
main_aa.select_tab = tabs.antisel:list("", {"\v"..ui.get_icon('caret-right').."\r Main", "\v"..ui.get_icon('caret-right').."\r Builder"}):depend({main_aa.enable_list, 2})
main_aa.condition = tabs.anti2:combo("Condition", cond_aa):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 2})
main_aa.pitch_set = tabs.anti1:combo("\v"..ui.get_icon('caret-right').."\r  Pitch", {'Disabled', 'Down', 'Fake Down', 'Fake Up'}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.custom_yaw_base = tabs.anti1:combo("\v"..ui.get_icon('caret-right').."\r  Yaw Base", {"Backward", "At Target", "Forward", "Left", "Right"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.freestand = tabs.anti1:switch("\v"..ui.get_icon('caret-right').."\r  Freestanding"):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.freestand_create = main_aa.freestand:create()
main_aa.staticfrees = main_aa.freestand_create:listable("Disablers", {"Jitter", "Defensive"})
main_aa.anims = tabs.anti1:switch("\v"..ui.get_icon('caret-right').."\r  Animation Breaker"):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.anims_create = main_aa.anims:create()
main_aa.groundbreaker = main_aa.anims_create:combo("Ground", {"Off", "Follow Direction", "Jitter", "Jitter Slide", "MoonWalk"}):depend(main_aa.anims)
main_aa.airbreaker = main_aa.anims_create:combo("Air", {"Off", "Static Legs In Air", "MoonWalk"}):depend(main_aa.anims)
main_aa.othbreaker = main_aa.anims_create:selectable("Addons", {"Pitch 0 On Land", "Move Lean", "Jitter Head"}):depend(main_aa.anims)
main_aa.legs_jit = main_aa.anims_create:slider("Jitter Legs", 0, 100, 80):depend(main_aa.anims, {main_aa.groundbreaker, "Jitter"})
main_aa.wpn_select = tabs.anti1:selectable("\v"..ui.get_icon('caret-right').."\r  Safe Head In Air", {"Knife", "Zeus", "Grenade", "Scout", "Awp"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})
main_aa.additions = tabs.anti1:selectable("\v"..ui.get_icon('caret-right').."\r  Additions", {"Shit AA On Warmup", "Anti~Backstab"}):depend({main_aa.enable_list, 2}, {main_aa.select_tab, 1})

local other_visual = {}
local misc_lua = {}
other_visual.enablelogs = tabs.visuals:switch(ui.get_icon('blog').."   Ragebot logs")
other_visual.logs_ref = other_visual.enablelogs:create()
other_visual.printconsole = other_visual.logs_ref:listable("", {"Console", "Event", "Screen"}):depend(other_visual.enablelogs)

other_visual.ScopeCustom = tabs.visuals:switch(ui.get_icon('crosshairs').."   Custom Scope")
other_visual.scopegroup = other_visual.ScopeCustom:create()
other_visual.Scopeinverted = other_visual.scopegroup:switch("Invert scope lines", false):depend(other_visual.ScopeCustom)
other_visual.Scopelength = other_visual.scopegroup:slider("Scope length", 5, 200, 55):depend(other_visual.ScopeCustom)
other_visual.Scopeoffset = other_visual.scopegroup:slider("Scope offset", 1, 50, 11):depend(other_visual.ScopeCustom)

other_visual.MinDMG = tabs.visuals:switch(ui.get_icon('eye').."   Min DMG Indicator")
other_visual.mindmggroup = other_visual.MinDMG:create()

other_visual.velocity_indicator_enable = tabs.inter:switch(ui.get_icon('triangle-exclamation').."   Slowed Down Indicator")
other_visual.velocity_indicator_gear = other_visual.velocity_indicator_enable:create()

misc_lua.viewmodel_switch = tabs.inter:switch(ui.get_icon('hands-holding').."  Viewmodel")
misc_lua.viewmodel_ref = misc_lua.viewmodel_switch:create()
misc_lua.viewmodel_fov = misc_lua.viewmodel_ref:slider("FOV", -100, 100, 68):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_x = misc_lua.viewmodel_ref:slider("X", -10, 10, 2.5):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_y = misc_lua.viewmodel_ref:slider("Y", -10, 10, 0):depend(misc_lua.viewmodel_switch)
misc_lua.viewmodel_z = misc_lua.viewmodel_ref:slider("Z", -10, 10, -1.5):depend(misc_lua.viewmodel_switch)

other_visual.Widgets = tabs.inter:switch(ui.get_icon('palette').."   Solus UI")
other_visual.Widgetsgroup = other_visual.Widgets:create()
other_visual.solus_widgets = other_visual.Widgetsgroup:listable("", {"Watermark", "Keybinds", "Spectator list"}):depend(other_visual.Widgets)
other_visual.custom_name = other_visual.Widgetsgroup:input("Username", ""..common.get_username()..""):depend(other_visual.Widgets)

misc_lua.clantag = tabs.misc:switch(ui.get_icon('tag').."   Clantag")
misc_lua.fps_boost = tabs.misc:switch(ui.get_icon('chart-line').."  Fps Boost")
misc_lua.aspect_ratio_switch = tabs.misc:switch(ui.get_icon('eye').."  Aspect ratio")
misc_lua.aspectratio_ref = misc_lua.aspect_ratio_switch:create()
misc_lua.aspect_ratio_slider = misc_lua.aspectratio_ref:slider("Value", 0, 200, 0):depend(misc_lua.aspect_ratio_switch)

misc_lua.no_fall_damage = tabs.mod:switch("\f<person-falling>    No Fall Damage")
misc_lua.fast_ladder = tabs.mod:switch(ui.get_icon('water-ladder').."   Fast Ladder")
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
colors_lua.velocity_indicator_color_1 = other_visual.velocity_indicator_gear:color_picker("Main", color(255, 255, 255)):depend(other_visual.velocity_indicator_enable)
colors_lua.velocity_indicator_color_2 = other_visual.velocity_indicator_gear:color_picker("Second", color(120, 120, 120)):depend(other_visual.velocity_indicator_enable)
colors_lua.scopecol = other_visual.scopegroup:color_picker("Scope Сolor",color(255,255)):depend(other_visual.ScopeCustom)

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
    aa_condition[z].ab_enable = tabs.antib:switch(cnd_aa[z].."\r 🞄 Anti~Bruteforce")
    
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
    for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then common.add_notify('[Feelsense]', 'Change Name') return end end
    if #configs_db.cfg_list > 6 then common.add_notify('[Feelsense]', 'Too Much Configs') return end
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
        abtime = globals.realtime
        antibrute_time_last = globals.realtime + 0.1
        currentphase = currentphase + 1
        if currentphase > aa_condition[id].ab_phases:get() then
            currentphase = 1
        end
        if ab_check == true and other_visual.printconsole:get(3) then
            render.log("Anti~Bruteforce Angle Switched due to \a777777FF"..player:get_name().."\aFFFFFFFF shot. Phase: "..currentphase)
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
        lp.m_flPoseParameter[globals.tickcount %4 > 1 and 0.5 or 1] = math.random(0, 10)/10
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

local other_call = {}

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end


function lerpx(time,a,b) return a * (1-time) + b * time end
function window(x, y, w, h, name, alpha) 
    local me = entity.get_local_player()
    if not me then return end
	local name_size = render.measure_text(1, "", name) 
    render.rect(vector(x-5, y-1), vector(x + w + 7, y + 19), color(20,20,20, alpha), 4)
    render.shadow(vector(x-5, y-1), vector(x + w + 7, y + 19), color(255,255,255, alpha), 20, 0, 4)
    render.text(1, vector(x+3 + w / 2 + 1 - name_size.x / 2,	y + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
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
    newsense:animate()
    if not globals.is_in_game then
        latency_text = ''
    else
        latency_text = ' | '..MTools.Client.GetPing().."ms"
    end
    nexttext = (ui.get_icon("moon-stars")..' feel'..newsense:get_animated_text()..'\aFFFFFFFF | '..other_visual.custom_name:get()..latency_text.." | "..actual_time.." ")
    local text_size = render.measure_text(1, "", nexttext).x
    window(x_x - text_size-19, 10, text_size + 4, 16, nexttext, 255)
end
local new_drag_object = drag_system.register({pos_x, pos_y}, vector(120, 60), "Test", function(self)
    local max_width = 0
    local frametime = globals.frametime * 16
    local add_y = 0
    local active_binds = {}
    local binds = ui.get_binds()
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
        window(self.position.x, self.position.y, width_ka, 16, ui.get_icon("moon-stars").."  keybinds", alphabinds)
    end
end)

local new_drag_object1 = drag_system.register({pos_x1, pos_y1}, vector(120, 60), "Test2", function(self)
    local width_spec = 120
    if width_spec > 160-11 then
        if width_spec > max_width then
            max_width = width_spec
        end
    end
    if ui.get_alpha() > 0.3 then
        window(self.position.x, self.position.y, width_spec, 16, ui.get_icon("moon-stars")..'  spectators', 255)
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
        window(self.position.x, self.position.y, width_spec, 16, ui.get_icon("moon-stars")..'  spectators', 255)
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
local function windows_def(x, y, size, sizey, long, text, color1, color2, alpha)
    render.shadow(vector(x+15, y+23), vector(x+135, y+26), color(255, 255, 255, alpha), 30, 0, 0)
    render.rect(vector(x+15, y+23), vector(x+15 + long, y+26), color1, 3)
    render.rect_outline(vector(x+15, y+22), vector(x+135, y+27), color2, 1, 3)
    render.text(1, vector(x+26, y +5), color1, nil, text)
    render.rect_outline(vector(x, y), vector(x + size, y + sizey), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end

local velocity_ind = drag_system.register({vel_x, vel_y}, vector(150, 30), "Velocity", function(self)
    vel_mod = entity.get_local_player().m_flVelocityModifier  
    if ui.get_alpha() > 0 or vel_mod < 1 then
        main.vel_alpha = math.lerp(main.vel_alpha, 1, 12)
    else
        main.vel_alpha = math.lerp(main.vel_alpha, 0, 12)
    end
    main.size = vel_mod * 120 == 120 and math.lerp(vel_mod * 120, main.size, 4) or math.lerp(main.size, vel_mod * 120, 4)
    gc1, gc2 = colors_lua.velocity_indicator_color_1:get(), colors_lua.velocity_indicator_color_2:get()
    color1, color2 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main.vel_alpha * 255))
    windows_def(self.position.x, self.position.y, self.size.x, self.size.y, main.size, ui.get_icon("moon-stars").." \aBDBDBDFFSlowed : " ..math.floor(vel_mod * 100).." % \aFFFFFFFF"..ui.get_icon("moon-stars"), color1, color2, math.floor(main.vel_alpha * 255))
end)

local screen_size = render.screen_size()
username, screen_center = common.get_username(), screen_size * 0.5
infopanel_x = tabs.visuals:slider("x_pan", 1, screen_size.x, 30)
infopanel_y = tabs.visuals:slider("y_pan", 1, screen_size.y, screen_center.y)
infopanel_x:visibility(false)
infopanel_y:visibility(false)

other_call.Infopanel = drag_system.register({infopanel_x, infopanel_y}, vector(140, 15), "Infopanel", function(self)
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    render.text(1, vector(self.position.x+5, self.position.y), color(), "aob", "\aC8C8C8FFF E E L "..Feelsense_sense:get_animated_text().." \aD54545FF[ALPHA]")
    Feelsense_sense:animate()
end)

dmg_x = other_visual.mindmggroup:slider("x_dmg", 1, screen_size.x, screen_center.x + 10)
dmg_y = other_visual.mindmggroup:slider("y_dmg", 1, screen_size.y, screen_center.y - 25)
dmg_x:visibility(false)
dmg_y:visibility(false)

other_call.Mnmmdmg = drag_system.register({dmg_x, dmg_y}, vector(20, 20), "Mindmg", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
	render.text(1, vector(self.position.x + 11, self.position.y + 10), color(), "cbd", ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end)

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
			clan_tag = clan_anim('Feelsense', {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0})
			if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
				clan_tag = clan_anim('Feelsense', {12})
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
    ref.lag:override()
    local player = entity.get_local_player()
    local selected = player:get_player_weapon()
    if selected == nil then return end
    local wpn = selected:get_classname()
    trw_time = selected.m_fThrowTime
    if (trw_time ~= nil and trw_time ~= 0) then
        if string.match(wpn, "Grenade") then
            ref.lag:override("Disabled")
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

log_x = other_visual.mindmggroup:slider("x_log", 1, screen_size.x, screen_center.x-150)
log_y = other_visual.mindmggroup:slider("y_log", 1, screen_size.y, screen_center.y+200)
log_x:visibility(false)
log_y:visibility(false)
local logs = {}
other_call.logs_func = drag_system.register({log_x, log_y}, vector(320, 130), "Aye Log", function(self)
    local offset = 0
    x = screen_center.x - 10
    y = screen_center.y + 150

    for idx, data in ipairs(logs) do
        if globals.curtime - data[3] < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 10)
        else
            data[2] = math.lerp(data[2], 0, 10)
        end

        offset = offset - 40 * (data[2] / 255)

        text_size = render.measure_text(1, s, ui.get_icon("moon-stars").." "..data[1])
        render.rect(vector(x - 3 - text_size.x / 2, y - offset - text_size.y/2), vector(x + 17+ text_size.x/2, y + 30 - offset - text_size.y), color(20, 20, 20, data[2]), 4)
        render.shadow(vector(x - 3 - text_size.x / 2, y - offset - text_size.y/2), vector(x + 17+ text_size.x/2, y + 30 - offset - text_size.y), color(255, 255, 255, data[2]), 20, 0, 4)
        render.text(4, vector(x + 6 -text_size.x / 2, y - offset-1), color(255, 255, 255, (data[2] / 255) * 255), "od", ui.get_icon("moon-stars"))
        render.text(1, vector(x + 24 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", data[1])
        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end

render.log("Welcome to FeelSense!")

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
            render.log(("Hit \a777777FF%s \aFFFFFFFF%s for \a777777FF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") bt: \a777777FF%s \aFFFFFFFF| hp: \a777777FF"..health.."\aFFFFFFFF"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if other_visual.printconsole:get(2) then
            print_dev(("\a4562FFFF[Feelsense] » \aA0FB87AARegistered \aD5D5D5AAshot at %s %s for \aA0FB87AA%d("..string.format("%.f", wanted_damage)..") \aD5D5D5AAdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
        if other_visual.printconsole:get(1) then
            print_raw(("\a4562FFFF[Feelsense] » \aA0FB87AARegistered \aD5D5D5AAshot at %s %s for \aA0FB87AA%d("..string.format("%.f", wanted_damage)..") \aD5D5D5AAdamage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
        end
    end
    if state ~= nil then
        if other_visual.printconsole:get(3) then
            render.log(('Missed \a777777FF%s \aFFFFFFFF%s due to \aE94B4BFF'..state..' \aFFFFFFFFbt: '..bt..' | dmg: '..string.format("%.f", wanted_damage)):format(target:get_name(), wanted_hitgroup, state1))
        end
        if other_visual.printconsole:get(2) then
            print_dev(('\a4562FFAA[Feelsense] » \aE94B4BAAMissed \aFFFFFFAAshot in %s in the %s due to \aE94B4BAA'..state..' \aFFFFFFAA(hc: '..string.format("%.f", hitchance)..') (dmg: '..string.format("%.f", wanted_damage)..') (bt: '..bt..')'):format(target:get_name(), wanted_hitgroup, state1))
        end
        if other_visual.printconsole:get(1) then
            print_raw(('\a4562FFAA[Feelsense] » \aE94B4BAAMissed \aFFFFFFAAshot in %s in the %s due to \aE94B4BAA'..state..' \aFFFFFFAA(hc: '..string.format("%.f", hitchance)..') (dmg: '..string.format("%.f", wanted_damage)..') (bt: '..bt..')'):format(target:get_name(), wanted_hitgroup, state1))
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
                print_raw(('\a4562FFAA[Feelsense] \aD5D5D5AA'..type_hit..' %s for \aA0FB87AA%d damage \aFFFFFFAA(%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if other_visual.printconsole:get(2) then
                print_dev(('\a4562FFAA[Feelsense] \aD5D5D5AA'..type_hit..' %s for \aA0FB87AA%d damage \aFFFFFFAA(%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
            end
            if other_visual.printconsole:get(3) then
                if type_hit ~= "Burned" then
                    render.log((""..type_hit..' %s for %d damage'):format(user:get_name(), e.dmg_health))
                else
                    render.log((""..type_hit..' %s for %d damage'):format(user:get_name(), e.dmg_health))
                end
            end
        end
    end
end)

events.round_start:set(function()
    currentphase = 1
    if other_visual.printconsole:get(3) then
        render.log("Reset anti-aim data due to new round start. Phase: "..currentphase)
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
    if other_visual.enablelogs:get() then
        other_call.logs_func:update()
    end
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
	if other_visual.MinDMG:get() then
		other_call.Mnmmdmg:update()
	end
    if other_visual.ScopeCustom:get() then
        other_call.customscope()
    end
    if other_visual.velocity_indicator_enable:get() then
        velocity_ind:update()
    end
end)

events.createmove:set(function(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
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
    config_all:load(json.parse(base64.decode("W3siYWRkaXRpb25zIjpbIlNoaXQgQUEgT24gV2FybXVwIiwiQW50aX5CYWNrc3RhYiIsIn4iXSwiYWlyYnJlYWtlciI6Ik9mZiIsImFuaW1zIjpmYWxzZSwiY29uZGl0aW9uIjoiXHUwMDA3e0xpbmsgQWN0aXZlfUdsb2JhbCIsImN1c3RvbV95YXdfYmFzZSI6IkF0IFRhcmdldCIsImVuYWJsZV9saXN0IjoyLjAsImZyZWVzdGFuZCI6ZmFsc2UsImdyb3VuZGJyZWFrZXIiOiJPZmYiLCJsZWdzX2ppdCI6ODAuMCwib3RoYnJlYWtlciI6WyJ+Il0sInBpdGNoX3NldCI6IkRvd24iLCJzZWxlY3RfdGFiIjoyLjAsInN0YXRpY2ZyZWVzIjpbIn4iXSwid3BuX3NlbGVjdCI6WyJ+Il19LHsiTWluRE1HIjp0cnVlLCJTY29wZUN1c3RvbSI6dHJ1ZSwiU2NvcGVpbnZlcnRlZCI6ZmFsc2UsIlNjb3BlbGVuZ3RoIjoxMzMuMCwiU2NvcGVvZmZzZXQiOjQuMCwiV2lkZ2V0cyI6dHJ1ZSwiY3VzdG9tX25hbWUiOiJnYW1lc2Vuc2UiLCJlbmFibGVsb2dzIjp0cnVlLCJwcmludGNvbnNvbGUiOlsxLjAsMy4wLCJ+Il0sInNvbHVzX3dpZGdldHMiOlsxLjAsMi4wLDMuMCwifiJdLCJ2ZWxvY2l0eV9pbmRpY2F0b3JfZW5hYmxlIjp0cnVlfSx7ImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJhc3BlY3RfcmF0aW9fc3dpdGNoIjp0cnVlLCJjbGFudGFnIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImZwc19ib29zdCI6dHJ1ZSwibmFkZV9maXgiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlLCJ2aWV3bW9kZWxfZm92Ijo2OC4wLCJ2aWV3bW9kZWxfc3dpdGNoIjpmYWxzZSwidmlld21vZGVsX3giOjIuMCwidmlld21vZGVsX3kiOjAuMCwidmlld21vZGVsX3oiOi0xLjB9LHsic2NvcGVjb2wiOiIjRkZGRkZGOTIiLCJ2ZWxvY2l0eV9pbmRpY2F0b3JfY29sb3JfMSI6IiNGRkZGRkZGRiIsInZlbG9jaXR5X2luZGljYXRvcl9jb2xvcl8yIjoiIzAwMDAwMEZGIn0sW3siYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjQyLjAsImFiX2xieV9sMiI6NDQuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjU3LjAsImFiX2xieV9yMiI6NTEuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjp0cnVlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6IlJhbmRvbSBXYXkiLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTMwLjAsInlhd19yIjozMC4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6LTIwLjAsImRlZl9waXRjaCI6LTg5LjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo1NC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IlJhbmRvbSBXYXkiLCJkZWxheV90aWNrcyI6Ni4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjotMTkuMCwieWF3X3IiOjM5LjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6LTIwLjAsImRlZl9waXRjaCI6LTg5LjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo3NS4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6IlJhbmRvbSBXYXkiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjotMi4wLCJ5YXdfciI6Ny4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiQWx3YXlzIE9uIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjUxLjAsImFiX2xieV9sMiI6NDMuMCwiYWJfbGJ5X2wzIjozMC4wLCJhYl9sYnlfcjEiOjUwLjAsImFiX2xieV9yMiI6NDEuMCwiYWJfbGJ5X3IzIjozMC4wLCJhYl9waGFzZXMiOjMuMCwiYWJfc2VsZWN0MSI6WyJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIkRlc3luYyIsIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjp0cnVlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjotMjAuMCwiZGVmX3BpdGNoIjotODkuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjcwLjAsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiUmFuZG9tIFdheSIsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOi01OC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU2LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJ5YXdfbCI6NC4wLCJ5YXdfciI6MTMuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiQ2VudGVyIiwiaml0dGVyX2NlbnRlciI6LTI4LjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9XV0=")))
    cvar.play:call("ambient\\tones\\elev1")
end, true)