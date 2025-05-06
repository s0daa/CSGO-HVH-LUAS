--[[
    stay og at og leaks fucking morons
]]

_DEBUG = true

local pui = require("neverlose/pui")
local gradient = require("neverlose/gradient")
local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")
local file = require("neverlose/file")

local date = "05.04.2023"

function theme_color()
    return "\a" .. ui.get_style("Link Active"):to_hex()
end

local default_config = {author = {"apathy team"},date = {"-"},n = {"Default"},cfg = {network.get("https://pastebin.com/raw/zgGD8WuP")}}

files.create_folder("csgo/Apathy")
if(files.read('csgo/Apathy/cfgdata.txt') == nil) then
    files.write('csgo/Apathy/cfgdata.txt', json.stringify(default_config))
end

local config_data = json.parse(files.read('csgo/Apathy/cfgdata.txt'))

local lua = {
    weapons = {"Global", "Pistols", "AWP", "SSG-08", "AK-47", "AutoSnipers", "Snipers", "Rifles", "SMGs", "Shotguns", "Machineguns", "M4A1/M4A4", "Desert Eagle", "R8 Revolver", "AUG/SG 553", "Taser"},
    weapons_can_scope = {"SSG-08", "AWP", "AutoSnipers", "Snipers"},
    conditions = {"Global", "Standing", "Moving", "Slow-walking", "Jumping", "Jump-crouching", "T-crouching", "CT-crouching"},
    conditions_non_g = {"Standing", "Moving", "Slow-walking", "Jumping", "Jump-crouching", "T-crouching", "CT-crouching"},
    logs = {},
    hitgroup_mass = {'generic','head', 'chest', 'stomach','left arm', 'right arm','left leg', 'right leg','neck', 'generic', 'gear'},
}

local icons = {
    home = ui.get_icon("landmark"),
    aa = ui.get_icon("ufo"),
    left = ui.get_icon("left"),
    right = ui.get_icon("right"),
    back = ui.get_icon("down"),
    up = ui.get_icon("up"),
    auto = ui.get_icon("bolt-auto"),
    enable = ui.get_icon("fire"),
    all = ui.get_icon("up-down-left-right"),
    list = ui.get_icon("list"),
    bricks = ui.get_icon("block-brick"),
    microchip = ui.get_icon("microchip"),
    spinner = ui.get_icon("spinner"),
    crosshair = ui.get_icon("crosshairs"),
    palette = ui.get_icon("palette"),
    gear = ui.get_icon("gear"),
    gears = ui.get_icon("gears"),
    fall = ui.get_icon("person-falling-burst"),
    fast_fall = ui.get_icon("person-falling"),
    avoid = ui.get_icon("person-arrow-up-from-line"),
    notify = ui.get_icon("envelope"),
    to_wall = ui.get_icon("person-arrow-down-to-line"),
    jump = ui.get_icon("person-ski-jumping"),
    no_scope = ui.get_icon("location-crosshairs-slash"),
    updown = ui.get_icon("up-down"),
    leftright = ui.get_icon("left-right"),
    cup = ui.get_icon("caret-up"),
    people_arrows = ui.get_icon("people-arrows"),
    freestand = ui.get_icon("eye-slash"),
    facehide = ui.get_icon("face-hand-peeking"),
    bars = ui.get_icon("bars"),
    mark = ui.get_icon("markdown"),
    keybinds = ui.get_icon("keyboard"),
    telescope = ui.get_icon("telescope"),
    object = ui.get_icon("object-group"),
    ugear = ui.get_icon("user-gear"),
    cloud = ui.get_icon("cloud"),
    danger = ui.get_icon("circle-exclamation"),
    desync_arrows = ui.get_icon("arrows-turn-to-dots"),
    width = ui.get_icon("text-width"),
    gun = ui.get_icon("gun"),
    bg = ui.get_icon("ban-bug"),
    dmg = ui.get_icon("arrow-down-9-1"),
    flag = ui.get_icon("flag"),
    marker = ui.get_icon("marker"),
}

ui.sidebar(theme_color() .. "apathyaw", theme_color() .. ui.get_icon("wheelchair-move"))

local tabs = {
    info = {
        home = pui.create(theme_color() .. icons.home, theme_color() .. "HOME"),
        cfg = pui.create(theme_color() .. icons.home, theme_color() .. "CONFIGS"),
        logo = pui.create(theme_color() .. icons.home, theme_color() .. "LOGO"),
        recs = pui.create(theme_color() .. icons.home, theme_color() .. "RECOMENDATIONS"),
    },
    misc = {
        ragebot = pui.create(theme_color() .. icons.gear, theme_color() .. "RAGEBOT"),
        interface = pui.create(theme_color() .. icons.gear, theme_color() .. "INTERFACE"),
        misc = pui.create(theme_color() .. icons.gear, theme_color() .. "MISCELLANEOUS"),
        mods = pui.create(theme_color() .. icons.gear, theme_color() .. "MODIFICATIONS")
    },
    aa = {
        main = pui.create(theme_color() .. icons.aa, theme_color() .. "MAIN"),
        settings = pui.create(theme_color() .. icons.aa, theme_color() .. "BUILDER"),
        defensive = pui.create(theme_color() .. icons.aa, theme_color() .. "DEFENSIVE"),
        misc = pui.create(theme_color() .. icons.aa, theme_color() .. "MISC"),
        configs = pui.create(theme_color() .. icons.aa, theme_color() .. "CONFIGS"),
    },
}

local menu = {
    info = {
        l1 = tabs.info.home:label("Welcome to Apathyaw, " ..  gradient.text(common.get_username(), false, {ui.get_style("Link Active"), color(ui.get_style("Link Active").r * 2, ui.get_style("Link Active").g, ui.get_style("Link Active").b * 2, ui.get_style("Link Active").a / 2.5)}) .. "\aDEFAULT!"),
        l2 = tabs.info.home:label("Update: " .. theme_color() .. date),
        l3 = tabs.info.home:label("Recomendations:"),
        bt1 = tabs.info.home:button("   Config   ", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
        end, true),
        bt2 = tabs.info.home:button("  Discord  ", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
        end, true),
        how_to_get_role = tabs.info.home:label("1. Join to discord \n2. Open the ticket \n3. Send screen with lua and your nickname"),
        logo = tabs.info.logo:texture(render.load_image(network.get("https://cdn.discordapp.com/attachments/795288743509622846/1090326848791138304/ssssssas.gif"), vector(500, 500)), vector(265, 265), ui.get_style("Link Active"), 'f'),
    },
    aaf = {
        enabled = tabs.aa.main:switch(theme_color() .. icons.enable .. "\aDEFAULT  Enabled"),
        freestand = tabs.aa.main:switch(theme_color() .. icons.auto .. "\aDEFAULT  Freestand", false, "", function(gear)
            return {
                disablers = gear:selectable("Disable on:", lua.conditions_non_g),
                manual = gear:switch("Disable on Manual"),
            }
        end),
        yaw_base = tabs.aa.main:combo(theme_color() .. icons.all .. "\aDEFAULT  Manual base", {
            icons.back .. " Backward", 
            icons.left .. " Left", 
            icons.right .. " Right", 
            icons.up .. " Forward", 
            icons.back .. " At Target"}),
    },
    tb = tabs.aa.main:list(theme_color() .. icons.list .. "\aDEFAULT Current tab", {
        theme_color() .. icons.bricks .. "\aDEFAULT    Builder",
        theme_color() .. icons.microchip .. "\aDEFAULT   Miscellaneous",
        theme_color() .. icons.gears .. "\aDEFAULT  Configs",
    }),
    aa = {
        cond = tabs.aa.settings:combo("", lua.conditions),
        anti_brute_reset = tabs.aa.settings:slider("Reset time", 1, 60, 6, 1, function(self)
            return self .. "s"
        end),
        err_oru = tabs.aa.settings:label("Activate this condition in Builder"),
        max_phase = {},
        builder = {},
        ab_builder = {},
        defensive = {
            cond = tabs.aa.defensive:selectable("Works on", lua.conditions_non_g, "", function(gear)
                return {
                    sens = gear:slider("Sensitivity", 0, 100, 75, 1, function(self)
                        return self .. "%"
                    end)
                }
            end),
            pitch = tabs.aa.defensive:combo(theme_color() .. icons.updown .. "\aDEFAULT     Pitch", {"Disabled", "Down", "Fake Up", "Fake Down", "Jitter"}, 0, function(gear)
                return {
                    pitches = gear:selectable("", {"Disabled", "Down", "Fake Up", "Fake Down"}),
                }
            end),
            yaw_mod = tabs.aa.defensive:combo(theme_color() .. icons.leftright .. "\aDEFAULT   Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way", "Hidden"}, 0, function(gear)
                return {
                    custom_ways = gear:switch("Custom ways"),
                    modifier_degree = tabs.aa.defensive:slider(theme_color() .. icons.cup .. "\aDEFAULT    Modiifer degree", -180, 180, 0),
                    first_degree = gear:slider("First degree", -180, 180, 0),
                    second_degree = gear:slider("Second degree", -180, 180, 0),
                    third_degree = gear:slider("Third degree", -180, 180, 0),
                    fourth_degree = gear:slider("Fourth degree", -180, 180, 0),
                    fifth_degree = gear:slider("Fifth degree", -180, 180, 0),
                }
            end),
            yaw_add_left = tabs.aa.defensive:slider("Yaw add left", -180, 180, 0),
            yaw_add_right = tabs.aa.defensive:slider("Yaw add right", -180, 180, 0),
        },
        break_lc = tabs.aa.misc:selectable("Break LC", lua.conditions_non_g),
        static_if = tabs.aa.misc:selectable("Static if", {"Warmup", "Manual", "Fake-lag", "Freestand"}),
        fast_ladder = tabs.aa.misc:switch("Fast ladder", false, "", function(gear) 
            return {
                options = gear:selectable("Work on", {"Ascending", "Descending"}),
                ladder_yaw_checkbox = gear:switch("Ladder yaw"),
                ladder_yaw_slider = gear:slider("", -180, 180, 0),
            }
        end),
        bomb_e_fix = tabs.aa.misc:switch("Bombsite e fix"),
    },
    config_system = {
        cfg_list = tabs.aa.configs:list("", config_data.n),
        cfg_info = tabs.aa.configs:label("Author: " .. theme_color() .. "\n" .. "Config update: " .. theme_color()),
        cfg_name = tabs.aa.configs:input("Config name", ""),
        load_cfg = tabs.aa.configs:button(theme_color() .. ui.get_icon("file-arrow-up") .. "\aDEFAULT Load", function()
            f_load_cfg()
        end, true),
        create_cfg = tabs.aa.configs:button(theme_color() .. ui.get_icon("plus") .. "\aDEFAULT Create", function()
            f_create_cfg()
        end, true),
        save_cfg = tabs.aa.configs:button(theme_color() .. ui.get_icon("floppy-disk") .. "\aDEFAULT Save", function()
            f_save_cfg()
        end, true),
        delete_cfg = tabs.aa.configs:button(theme_color() .. ui.get_icon("trash") .. "\aDEFAULT Delete", function()
            f_remove_cfg()
        end, true),
        cfg_import = tabs.aa.configs:button(theme_color() .. ui.get_icon("file-import") .. "\aDEFAULT Import Config", function()
            f_import_cfg()
        end, true),
        cfg_export = tabs.aa.configs:button(theme_color() .. ui.get_icon("file-export") .. "\aDEFAULT Export Config", function()
            f_export_cfg()
        end, true),
    },
    rage = {
        no_fall_damage = tabs.misc.ragebot:switch(theme_color() .. icons.fall .. "\aDEFAULT  No fall damage", false, "", function(gear)
            return {
                draw_ind = gear:switch("Indicator"),
                always_on = gear:switch("Always On"),
                color = gear:color_picker("Accent Color", ui.get_style("Link Active")),
                x = gear:slider("X", -150, 150, 0),
                y = gear:slider("Y", -150, 150, 0),
                font = gear:combo("Font", {"Default", "Small", "Console", "Bold"}),
            }
        end),
        avoid_collisions = tabs.misc.ragebot:switch(theme_color() .. icons.avoid .. "\aDEFAULT  Avoid collisions", false, "", function(gear)
            return {
                distance = gear:slider("Distance", 5, 20, 15),
            }
        end),
        exploits_discharge = tabs.misc.ragebot:switch(theme_color() .. icons.to_wall .. "\aDEFAULT  Exploit discharge", false, "", function(gear)
            return {
                sens = gear:slider("Sensitivity", 0, 100, 75, 1, function(self)
                    return self .."%"
                end),
            }
        end),
        in_air_hitchance = tabs.misc.ragebot:switch(theme_color() .. icons.jump .. "\aDEFAULT   In air hitchance", false, "", function(gear)
            return {
                weapons = gear:selectable("Works with", lua.weapons),
                hitchance = gear:slider("Hitchance", 0, 100, 45),
            }
        end),
        no_scope_hitchance = tabs.misc.ragebot:switch(theme_color() .. icons.no_scope .. "\aDEFAULT  No scope hitchance", false, "", function(gear)
            return {
                weapons = gear:selectable("Works with", lua.weapons_can_scope),
                hitchance = gear:slider("Hitchance", 0, 100, 45),
            }
        end),
        fast_fall = tabs.misc.ragebot:switch(theme_color() .. icons.fast_fall .. "\aDEFAULT    Fast fall"),
    },
    visuals = {
        lua_indicators = tabs.misc.interface:switch(theme_color() .. icons.list .. "\aDEFAULT   Lua indicators", false, "", function(gear)
            return {
                show = gear:selectable("Show", {"Clouds", "Logo", "Desync", "Condition", "Binds"}),
                first_color = gear:color_picker("First color"),
                second_color = gear:color_picker("Second color"),
                logo_type = gear:combo("Logo Style", {"Static", "Invert", "Gradient"}),
                adjustments = gear:selectable("Adjustments", {"DPI scale", "Scope turn-off"}),
            }
        end),
        left_indicators = tabs.misc.interface:switch(theme_color() .. icons.bars .. "\aDEFAULT   Left indicators", false, ""),
        watermark = tabs.misc.interface:switch(theme_color() .. icons.mark .. "\aDEFAULT  Watermark", false, "", function(gear)
            return {
                show = gear:selectable("Watermark show", {"Cheat name", "Lua name", "Nickname", "FPS", "Ping", "Tickrate", "Build", "User text", "Time"}),
                posi = gear:combo("Position", "Right-Up", "Bottom", "Left-Up"),
                cheat_name = gear:input("Cheat name", "neverlose.cc"),
                nick = gear:combo("Username", {"From cheat", "From box"}),
                nickname = gear:input("", "ублюдок123"),
                user_text = gear:input("", "NEVERSENSE V3.5 [naghtli debyk]"),
            }
        end),
        keybinds = tabs.misc.interface:switch(theme_color() .. icons.keybinds .. "\aDEFAULT   Keybinds", false, "", function(gear)
            return {
                x = gear:slider("x", 0, render.screen_size().x, 300),
                y = gear:slider("y", 0, render.screen_size().y, 300),
            }
        end),
        spectators = tabs.misc.interface:switch(theme_color() .. icons.telescope .. "\aDEFAULT  Spectators"),
        interface_design = tabs.misc.interface:label(theme_color() .. icons.object .. "\aDEFAULT  Design", "", function(gear)
            return {
                accent_color = gear:color_picker("Accent color", ui.get_style("Link Active")),
                glow = gear:slider("Glow strength", 0, 100, 0, 1, function(self) 
                    if(self > 0) then
                        return self  .. "%" 
                    else
                        return "Off"
                    end
                end),
                enable_color = gear:switch("Custom glow color"),
                glow_color = gear:color_picker("Glow color", ui.get_style("Link Active")),
            }
        end),
    },
    mods = {
        aspect_ratio = tabs.misc.mods:switch(theme_color() .. icons.width .. "\aDEFAULT    Aspect ratio", false, "", function(gear)
            return {
                val = gear:slider("Value", 0, 200, 0, 0.01),
                first = gear:button("16:9", function() aspect_ratio(16, 9) end, true),
                second = gear:button("16:10", function() aspect_ratio(16, 10) end, true),
                third = gear:button("3:2", function() aspect_ratio(3, 2) end, true),
                fourth = gear:button("4:3", function() aspect_ratio(4, 3) end, true),
                fifth = gear:button("5:3", function() aspect_ratio(5, 3) end, true),
                sixth = gear:button("5:4", function() aspect_ratio(5, 4) end, true),
            }
        end),
        viewmodel = tabs.misc.mods:switch(theme_color() .. icons.gun .. "\aDEFAULT   Custom viewmodel", false, "", function(gear)
            return {
                viewmodel_fov = gear:slider("Fov", -50, 50, 0, ""),
                viewmodel_x = gear:slider("X", -30, 30, 0, 1),
                viewmodel_y = gear:slider("Y", -50, 50, 0, 1),
                viewmodel_z = gear:slider("Z", -50, 50, 0, 1),
            }
        end),
        lagcomp = tabs.misc.mods:switch(theme_color() .. icons.bg .. "\aDEFAULT    Lagcomp debug box"),
        hitmarker = tabs.misc.mods:switch(theme_color() .. icons.marker .. "\aDEFAULT    Hitmarker"),
    },
    misc = {
        logs = tabs.misc.misc:switch(theme_color() .. icons.notify .. "\aDEFAULT   Logs", false, "", function(gear)
            return {
                output = gear:selectable("Output", {"Console", "Up of screen", "Screen"}),
                events = gear:selectable("Events", {"Hits", "Misses", "Anti-bruteforce", "Buys"}),
                hit_color = gear:color_picker("Hit color", color(151,200,60,255)),
                miss_color = gear:color_picker("Miss color", color(237, 15, 15, 255)),
                misc_color = gear:color_picker("Misc color", color(255, 255, 255, 255)),
                log_preview = gear:switch("Preview logs"),
                glow = gear:slider("Glow strength", 0, 100, 0, 1, function(self) 
                    if(self > 0) then
                        return self  .. "%" 
                    else
                        return "Off"
                    end
                end),
                enable_color = gear:switch("Custom glow color"),
                glow_color = gear:color_picker("Glow color", ui.get_style("Link Active")),
            }
        end),
        better_scope = tabs.misc.misc:switch(theme_color() .. icons.crosshair .. "\aDEFAULT  Better scope overlay", false, "", function(gear)
            return {
                pos = gear:slider("Pos", 0, 500, 15),
                offset = gear:slider("Offset", 0, 750, 35),
                adjustments = gear:selectable("Options", {"Invert", "Animations", "Glow"}),
                color = gear:color_picker("Accent Color", color(255,255,255,255)),
                glow = gear:slider("Glow strength", 0, 100, 0, 1, function(self) 
                    if(self > 0) then
                        return self  .. "%" 
                    else
                        return "Off"
                    end
                end),
                enable_color = gear:switch("Custom glow color"),
                glow_color = gear:color_picker("Glow color", ui.get_style("Link Active")),
            }
        end),
        manual_arrows = tabs.misc.misc:switch(theme_color() .. icons.desync_arrows .. "\aDEFAULT   Manual arrows", false, "", function(gear)
            return {
                style = gear:combo("Style", {"Teamskeet", "Ideal Yaw"}),
                desync_color = gear:color_picker("Desync color", color(67, 161, 255)),
                manual_color = gear:color_picker("Manual color", color(182,247,66,255)),
                accent_color = gear:color_picker("Accent color", color(255,255,255,255)),
                reverse = gear:switch("Reverse"),
                dynamic = gear:slider("Dynamic", 0, 20, 0),
            }
        end),
        damage = tabs.misc.misc:switch(theme_color() .. icons.dmg .. "\aDEFAULT   Damage Indicator", false, "", function(gear)
            return {
                x = gear:slider("X", -400, 400, 0),
                y = gear:slider("Y", -400, 400, 0),
                color = gear:color_picker("Accent Color", color(255,255,255,255)),
                font = gear:combo("Font", {"Default", "Small", "Console", "Bold"}),
            }
        end),
        taskbar = tabs.misc.misc:switch(theme_color() .. icons.flag .. "\aDEFAULT   Icon flash"),
    },
}

--Pikaz's code (I asked him)
local raw_hwnd 			= utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B") or error("Invalid signature #1")
local raw_FlashWindow 	= utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7") or error("Invalid signature #2")
local raw_insn_jmp_ecx 	= utils.opcode_scan("gameoverlayrenderer.dll", "FF E1") or error("Invalid signature #3")
local raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74") or error("Invalid signature #4")
local hwnd_ptr 		= ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow 	= ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx 	= ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

local function get_csgo_hwnd()
	return hwnd_ptr[0]
end

local function get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

local function notify_user()
	local csgo_hwnd = get_csgo_hwnd()
	if get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

events.round_start:set(function()
    if(menu.misc.taskbar:get()) then
        notify_user()
    end
end)

function aspect_ratio(first, second)
    menu.mods.aspect_ratio.val:set(math.floor(first / second * 100))
end

menu.misc.manual_arrows.style:depend(menu.misc.manual_arrows)
menu.misc.manual_arrows.desync_color:depend(menu.misc.manual_arrows, {menu.misc.manual_arrows.style, "Teamskeet"})
menu.misc.manual_arrows.manual_color:depend(menu.misc.manual_arrows, {menu.misc.manual_arrows.style, "Teamskeet"})
menu.misc.manual_arrows.accent_color:depend(menu.misc.manual_arrows, {menu.misc.manual_arrows.style, "Ideal Yaw"})
menu.misc.manual_arrows.reverse:depend(menu.misc.manual_arrows)
menu.misc.manual_arrows.dynamic:depend(menu.misc.manual_arrows)

menu.config_system.cfg_list:depend({menu.tb, 3})
menu.config_system.cfg_info:depend({menu.tb, 3})
menu.config_system.cfg_name:depend({menu.tb, 3})
menu.config_system.load_cfg:depend({menu.tb, 3})
menu.config_system.save_cfg:depend({menu.tb, 3})
menu.config_system.create_cfg:depend({menu.tb, 3})
menu.config_system.delete_cfg:depend({menu.tb, 3})
menu.config_system.cfg_import:depend({menu.tb, 3})
menu.config_system.cfg_export:depend({menu.tb, 3})

menu.config_system.cfg_list:update(config_data.n)
menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])

menu.config_system.cfg_list:set_callback(function()
    menu.config_system.cfg_list:update(config_data.n)
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
end)

local function locate( table, value )
    for i = 1, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

function f_export_cfg()
    local date_cfg = common.get_date("%m.%d.%Y %H:%M")
    local config = base64.encode(json.stringify(pui.save()))
    local authors = common.get_username()
    if(menu.config_system.cfg_name:get() ~= "") then
        name = menu.config_system.cfg_name:get()
    else
        name = "config by " .. authors
    end
    local cfg_to_export = {n = name, cfg = config, author = authors, date = date_cfg}
    clipboard.set(json.stringify(cfg_to_export))
end

function f_import_cfg()
    local imported_cfg = json.parse(clipboard.get())
    table.insert(config_data.n, imported_cfg.n)
    table.insert(config_data.cfg, imported_cfg.cfg)
    table.insert(config_data.author, imported_cfg.author)
    table.insert(config_data.date, imported_cfg.date)
    menu.config_system.cfg_list:update(config_data.n)
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
    files.write('csgo/Apathy/cfgdata.txt', json.stringify(config_data))
end

function f_load_cfg()
    if(menu.config_system.cfg_list:get() == 1) then
        if(string.find(network.get("https://pastebin.com/raw/zgGD8WuP"), "Forbidden")) then
            common.add_notify("CFG", "Wait, hosting is unavailable now")
        else
            pui.load(json.parse(base64.decode(network.get("https://pastebin.com/raw/zgGD8WuP"))))
        end
    else
        pui.load(json.parse(base64.decode(config_data.cfg[menu.config_system.cfg_list:get()])))
    end
end

function f_save_cfg()
    config_data.date[menu.config_system.cfg_list:get()] = common.get_date("%m.%d.%Y %H:%M")
    config_data.cfg[menu.config_system.cfg_list:get()] = base64.encode(json.stringify(pui.save()))
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
    files.write('csgo/Apathy/cfgdata.txt', json.stringify(config_data))
end

function f_create_cfg()
    local date_cfg = common.get_date("%m.%d.%Y %H:%M")
    local cfg = base64.encode(json.stringify(pui.save()))
    local author = common.get_username()
    local name = menu.config_system.cfg_name:get()
    if(name ~= "" and not locate(config_data.n, name)) then
        table.insert(config_data.n, name)
        table.insert(config_data.cfg, cfg)
        table.insert(config_data.author, author)
        table.insert(config_data.date, date_cfg)
        files.write('csgo/Apathy/cfgdata.txt', json.stringify(config_data))
    end
    menu.config_system.cfg_list:update(config_data.n)
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
end

function f_remove_cfg()
    if(menu.config_system.cfg_list:get() ~= 1) then
        table.remove(config_data.n, menu.config_system.cfg_list:get())
        table.remove(config_data.author, menu.config_system.cfg_list:get())
        table.remove(config_data.cfg, menu.config_system.cfg_list:get())
        table.remove(config_data.date, menu.config_system.cfg_list:get())
        files.write('csgo/Apathy/cfgdata.txt', json.stringify(config_data))
        menu.config_system.cfg_list:update(config_data.n)
        menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get() - 1] .. "\n\aDEFAULT" .. "Last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get() - 1])
    end
end

menu.visuals.lua_indicators.first_color:depend(menu.visuals.lua_indicators)
menu.visuals.lua_indicators.second_color:depend(menu.visuals.lua_indicators)
menu.visuals.lua_indicators.show:depend(menu.visuals.lua_indicators)
menu.visuals.lua_indicators.logo_type:depend(menu.visuals.lua_indicators, {menu.visuals.lua_indicators.show, function() return menu.visuals.lua_indicators.show:get("Logo") end})
menu.visuals.lua_indicators.adjustments:depend(menu.visuals.lua_indicators, {menu.visuals.lua_indicators.show, function() return #menu.visuals.lua_indicators.show:get() > 0 end})

menu.misc.better_scope.pos:depend(menu.misc.better_scope)
menu.misc.better_scope.offset:depend(menu.misc.better_scope)
menu.misc.better_scope.adjustments:depend(menu.misc.better_scope)
menu.misc.better_scope.color:depend(menu.misc.better_scope)
menu.misc.better_scope.glow:depend(menu.misc.better_scope, {menu.misc.better_scope.adjustments, function() return menu.misc.better_scope.adjustments:get("Glow") end})
menu.misc.better_scope.enable_color:depend(menu.misc.better_scope, {menu.misc.better_scope.adjustments, function() return menu.misc.better_scope.adjustments:get("Glow") end}, {menu.misc.better_scope.glow, function() return menu.misc.better_scope.glow:get() > 0 end})
menu.misc.better_scope.glow_color:depend(menu.misc.better_scope, {menu.misc.better_scope.adjustments, function() return menu.misc.better_scope.adjustments:get("Glow") end}, {menu.misc.better_scope.glow, function() return menu.misc.better_scope.glow:get() > 0 end}, menu.misc.better_scope.enable_color)

menu.visuals.interface_design.enable_color:depend({menu.visuals.interface_design.glow, function() return menu.visuals.interface_design.glow:get() > 0 end})
menu.visuals.interface_design.glow_color:depend({menu.visuals.interface_design.glow, function() return menu.visuals.interface_design.glow:get() > 0 end}, menu.visuals.interface_design.enable_color)

menu.rage.no_fall_damage.draw_ind:depend(menu.rage.no_fall_damage)
menu.rage.no_fall_damage.always_on:depend(menu.rage.no_fall_damage, menu.rage.no_fall_damage.draw_ind)
menu.rage.no_fall_damage.color:depend(menu.rage.no_fall_damage, menu.rage.no_fall_damage.draw_ind)
menu.rage.no_fall_damage.x:depend(menu.rage.no_fall_damage, menu.rage.no_fall_damage.draw_ind)
menu.rage.no_fall_damage.y:depend(menu.rage.no_fall_damage, menu.rage.no_fall_damage.draw_ind)
menu.rage.no_fall_damage.font:depend(menu.rage.no_fall_damage, menu.rage.no_fall_damage.draw_ind)
menu.rage.avoid_collisions.distance:depend(menu.rage.avoid_collisions)

menu.misc.logs.log_preview:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Screen") end})
menu.misc.logs.output:depend(menu.misc.logs)
menu.misc.logs.events:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Console") or menu.misc.logs.output:get("Up of screen") or menu.misc.logs.output:get("Screen") end})
menu.misc.logs.hit_color:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Console") or menu.misc.logs.output:get("Up of screen") or menu.misc.logs.output:get("Screen") end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Hits") end })
menu.misc.logs.miss_color:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Console") or menu.misc.logs.output:get("Up of screen") or menu.misc.logs.output:get("Screen") end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Misses") end })
menu.misc.logs.misc_color:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Console") or menu.misc.logs.output:get("Up of screen") or menu.misc.logs.output:get("Screen") end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Anti-bruteforce") or menu.misc.logs.events:get("Buys") end  })
menu.misc.logs.glow:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Screen") end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Anti-bruteforce") or menu.misc.logs.events:get("Buys") or menu.misc.logs.events:get("Misses") or  menu.misc.logs.events:get("Hits") end })
menu.misc.logs.enable_color:depend(menu.misc.logs, {menu.misc.logs.output, function() return menu.misc.logs.output:get("Screen")  end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Anti-bruteforce") or menu.misc.logs.events:get("Buys") or menu.misc.logs.events:get("Misses") or  menu.misc.logs.events:get("Hits") end}, {menu.misc.logs.glow, function() return menu.misc.logs.glow:get() > 0 end})
menu.misc.logs.glow_color:depend(menu.misc.logs, {menu.misc.logs.output, function()return menu.misc.logs.output:get("Screen") end}, {menu.misc.logs.events, function() return menu.misc.logs.events:get("Anti-bruteforce") or menu.misc.logs.events:get("Buys") or menu.misc.logs.events:get("Misses") or menu.misc.logs.events:get("Hits") end}, {menu.misc.logs.glow, function() return menu.misc.logs.glow:get() > 0 end}, menu.misc.logs.enable_color)
menu.rage.exploits_discharge.sens:depend(menu.rage.exploits_discharge)
menu.rage.in_air_hitchance.weapons:depend(menu.rage.in_air_hitchance)
menu.rage.in_air_hitchance.hitchance:depend(menu.rage.in_air_hitchance, {menu.rage.in_air_hitchance.weapons, function() return #menu.rage.in_air_hitchance.weapons:get() > 0 end})
menu.rage.no_scope_hitchance.weapons:depend(menu.rage.no_scope_hitchance)
menu.rage.no_scope_hitchance.hitchance:depend(menu.rage.no_scope_hitchance, {menu.rage.no_scope_hitchance.weapons, function() return #menu.rage.no_scope_hitchance.weapons:get() > 0 end})

menu.aa.defensive.pitch:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end})
menu.aa.defensive.pitch.pitches:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.pitch, "Jitter"}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end})
menu.aa.defensive.yaw_mod:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end})
menu.aa.defensive.yaw_mod.modifier_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod,
function()
    if(((menu.aa.defensive.yaw_mod:get() == "3-Way" or menu.aa.defensive.yaw_mod:get() == "5-Way") and menu.aa.defensive.yaw_mod.custom_ways:get()) or menu.aa.defensive.yaw_mod:get() == "Hidden" or menu.aa.defensive.yaw_mod:get() == "Disabled") then
        return false
    else
        return true
    end
end
}, {menu.aa.defensive.yaw_mod.custom_ways, function() return true end})
menu.aa.defensive.yaw_add_left:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end})
menu.aa.defensive.yaw_add_right:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end})
menu.aa.defensive.yaw_mod.first_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, function() if(menu.aa.defensive.yaw_mod:get() == "3-Way" or menu.aa.defensive.yaw_mod:get() == "5-Way") then return true else return false end end}, menu.aa.defensive.yaw_mod.custom_ways)
menu.aa.defensive.yaw_mod.second_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, function() if(menu.aa.defensive.yaw_mod:get() == "3-Way" or menu.aa.defensive.yaw_mod:get() == "5-Way") then return true else return false end end}, menu.aa.defensive.yaw_mod.custom_ways)
menu.aa.defensive.yaw_mod.third_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, function() if(menu.aa.defensive.yaw_mod:get() == "3-Way" or menu.aa.defensive.yaw_mod:get() == "5-Way") then return true else return false end end}, menu.aa.defensive.yaw_mod.custom_ways)
menu.aa.defensive.yaw_mod.fourth_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, "5-Way"}, menu.aa.defensive.yaw_mod.custom_ways)
menu.aa.defensive.yaw_mod.fifth_degree:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, "5-Way"}, menu.aa.defensive.yaw_mod.custom_ways)
menu.aa.defensive.yaw_mod.custom_ways:depend(menu.aaf.enabled, {menu.tb, 1}, {menu.aa.defensive.cond, function() return #menu.aa.defensive.cond:get() > 0 end}, {menu.aa.defensive.yaw_mod, function() if(menu.aa.defensive.yaw_mod:get() == "3-Way" or menu.aa.defensive.yaw_mod:get() == "5-Way") then return true else return false end end})

menu.aa.break_lc:depend(menu.aaf.enabled, {menu.tb, 2})
menu.aa.static_if:depend(menu.aaf.enabled, {menu.tb, 2})
menu.aa.fast_ladder:depend(menu.aaf.enabled, {menu.tb, 2})
menu.aa.bomb_e_fix:depend(menu.aaf.enabled, {menu.tb, 2})
menu.aa.anti_brute_reset:depend(menu.aaf.enabled, {menu.tb, 2})

menu.aaf.freestand:depend(menu.aaf.enabled)
menu.aaf.yaw_base:depend(menu.aaf.enabled)
menu.tb:depend(menu.aaf.enabled)
menu.aa.defensive.cond:depend(menu.aaf.enabled, {menu.tb, 1})
menu.aa.cond:depend(menu.aaf.enabled, {menu.tb, function() if(menu.tb:get() == 1 or menu.tb:get() == 2) then return true else return false end end})

menu.visuals.watermark.show:depend(menu.visuals.watermark)
menu.visuals.watermark.cheat_name:depend(menu.visuals.watermark, {menu.visuals.watermark.show, function() return menu.visuals.watermark.show:get("Cheat name") end})
menu.visuals.watermark.nick:depend(menu.visuals.watermark, {menu.visuals.watermark.show, function() return menu.visuals.watermark.show:get("Nickname") end})
menu.visuals.watermark.nickname:depend(menu.visuals.watermark, {menu.visuals.watermark.show, function() return menu.visuals.watermark.show:get("Nickname") end}, {menu.visuals.watermark.nick, "From box"})
menu.visuals.watermark.user_text:depend(menu.visuals.watermark, {menu.visuals.watermark.show, function() return menu.visuals.watermark.show:get("User text") end})

menu.visuals.keybinds.x:visibility(false)
menu.visuals.keybinds.y:visibility(false)

for i = 1, #lua.conditions do
    menu.aa.builder[i] = {
        enabled = tabs.aa.settings:switch(theme_color() .. icons.enable .. "\aDEFAULT   Enable " .. string.lower(lua.conditions[i]) .. " anti-aim"),
        pitch = tabs.aa.settings:combo(theme_color() .. icons.updown .. "\aDEFAULT     Pitch", {"Disabled", "Down", "Fake Up", "Fake Down"}),
        yaw_mod = tabs.aa.settings:combo(theme_color() .. icons.leftright .. "\aDEFAULT   Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, 0, function(gear)
            return {
                modifier_degree = tabs.aa.settings:slider(theme_color() .. icons.cup .. "\aDEFAULT    Modiifer degree", -180, 180, 0),
                custom_ways = gear:switch("Custom ways"),
                first_degree = gear:slider("First degree", -180, 180, 0),
                second_degree = gear:slider("Second degree", -180, 180, 0),
                third_degree = gear:slider("Third degree", -180, 180, 0),
                fourth_degree = gear:slider("Fourth degree", -180, 180, 0),
                fifth_degree = gear:slider("Fifth degree", -180, 180, 0),
            }
        end),
        yaw_add_left = tabs.aa.settings:slider(theme_color() .. icons.left .. "\aDEFAULT    Yaw add left", -180, 180, 0),
        yaw_add_right = tabs.aa.settings:slider(theme_color() .. icons.right .. "\aDEFAULT    Yaw add right", -180, 180, 0),
        fake_options = tabs.aa.settings:selectable(theme_color() .. icons.people_arrows .. "\aDEFAULT   Fake options", {"Jitter", "Randomize jitter"}, 0, ""),
        left_limit = tabs.aa.settings:slider(theme_color() .. icons.cup .. "\aDEFAULT     Left limit", 0, 60, 0, ""),
        right_limit = tabs.aa.settings:slider(theme_color() .. icons.cup .. "\aDEFAULT     Right limit", 0, 60, 0, ""),
    }
    menu.aa.max_phase[i] = {
        enabled = tabs.aa.settings:switch("Enable " .. string.lower(lua.conditions[i]) .. " anti-bruteforce"),
        max = tabs.aa.settings:slider("Max phase", 2, 10, 2),
    }
    for k = 1, 10 do
        if(menu.aa.ab_builder[i] == nil) then
            menu.aa.ab_builder[i] = {}
        end
        menu.aa.ab_builder[i][k] = tabs.aa.settings:slider("phase #" .. k .. " + adding -", -180, 180, 0)
    end
end

local cond_to_num = {
    ["Global"] = 1,
    ["Standing"] = 2,
    ["Moving"] = 3,
    ["Slow-walking"] =  4,
    ["Jumping"] = 5,
    ["Jump-crouching"] = 6,
    ["T-crouching"] = 7,
    ["CT-crouching"] = 8,
}

menu.aa.err_oru:depend(menu.aaf.enabled, {menu.tb, 2}, {menu.aa.cond, function()
    if(menu.aa.cond:get() == "Global") then
        return false
    else
        if(menu.aa.builder[cond_to_num[menu.aa.cond:get()]].enabled:get()) then
            return false
        else
            return true
        end
    end
end})

for i = 1, #lua.conditions do
    local enable = menu.aaf.enabled
    local tb = {menu.tb, 1}
    local abtb = {menu.tb, 2}
    local cond = {menu.aa.cond, lua.conditions[i]}
    local yaw_mod = menu.aa.builder[i].yaw_mod
    local condea = menu.aa.builder[i].enabled
    local ea = {condea, function() if(i == 1) then return true else return condea:get() end end}
    menu.aa.builder[i].enabled:depend(enable, tb, cond, {menu.aa.cond, function()
        return (i ~= 1)
    end})
    menu.aa.builder[i].pitch:depend(enable, tb, cond, ea)
    yaw_mod:depend(enable, tb, cond, ea)
    yaw_mod.modifier_degree:depend(enable, tb, cond, {yaw_mod.custom_ways, function() return true end}, {yaw_mod, function()
        if(yaw_mod:get() == "3-Way" or yaw_mod:get() == "5-Way" or yaw_mod:get() == "Disabled") then
            if(yaw_mod:get() == "Disabled") then
                return false
            else
                if(yaw_mod.custom_ways:get()) then
                    return false
                else
                    return true
                end
            end
        else
            return true
        end
    end}, ea)
    yaw_mod.custom_ways:depend(enable, tb, cond, {yaw_mod, function() if(yaw_mod:get() == "3-Way" or yaw_mod:get() == "5-Way") then return true else return false end end}, ea)
    yaw_mod.first_degree:depend(enable, tb, cond, yaw_mod.custom_ways, {yaw_mod, function() if(yaw_mod:get() == "3-Way" or yaw_mod:get() == "5-Way") then return true else return false end end}, ea)
    yaw_mod.second_degree:depend(enable, tb, cond, yaw_mod.custom_ways, {yaw_mod, function() if(yaw_mod:get() == "3-Way" or yaw_mod:get() == "5-Way") then return true else return false end end}, ea)
    yaw_mod.third_degree:depend(enable, tb, cond, yaw_mod.custom_ways, {yaw_mod, function() if(yaw_mod:get() == "3-Way" or yaw_mod:get() == "5-Way") then return true else return false end end}, ea)
    yaw_mod.fourth_degree:depend(enable, tb, cond, yaw_mod.custom_ways, {yaw_mod, "5-Way"}, ea)
    yaw_mod.fifth_degree:depend(enable, tb, cond, yaw_mod.custom_ways, {yaw_mod, "5-Way"}, ea)
    menu.aa.builder[i].yaw_add_left:depend(enable, tb, cond, ea)
    menu.aa.builder[i].yaw_add_right:depend(enable, tb, cond, ea)
    menu.aa.builder[i].fake_options:depend(enable, tb, cond, ea)
    menu.aa.builder[i].left_limit:depend(enable, tb, cond, ea)
    menu.aa.builder[i].right_limit:depend(enable, tb, cond, ea)
    menu.aa.max_phase[i].enabled:depend(enable, abtb, cond, ea)
    menu.aa.max_phase[i].max:depend(enable, abtb, cond, menu.aa.max_phase[i].enabled, ea)
    for k = 1, 10 do
        menu.aa.ab_builder[i][k]:depend(enable, abtb, cond, menu.aa.max_phase[i].enabled, {menu.aa.max_phase[i].max, function() return menu.aa.max_phase[i].max:get() >= k end}, ea)
    end
end

local ram = {
    jitter_move = false,
    anti_bruteforce = {
        tickcounts = {},
        realtime = {},
    },
    logs = {},
    in_bombzone = false,
    prev_simulation_time = 0,
    defensive = {},
    jit_yaw = 0,
    yaw_add = 0,
    set_lby = false,
    jitter = false,
    jit_add = 0,
    fix_tp = rage.exploit:get(),
}

local function time_to_ticks(val)
    return math.floor(0.5 + (val / globals.tickinterval))
end

function sim_diff()
    local current_simulation_time = time_to_ticks(entity.get_local_player().m_flSimulationTime)
    local diff = current_simulation_time - ram.prev_simulation_time
    ram.prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

function anti_brute(event)
    local player_which_shotting = entity.get(event.userid, true)
    local lp = entity.get_local_player()
    if(player_which_shotting == nil or player_which_shotting == lp or lp == nil or lp.m_iHealth <= 0 or player_which_shotting.m_iTeamNum == lp.m_iTeamNum) then return end
    local spos = player_which_shotting.m_vecOrigin
    local epos = vector(event.x, event.y, event.z)
    local lpos = vector(lp.m_vecOrigin.x, lp.m_vecOrigin.y, lp.m_vecOrigin.z + 60)
    local closray = lpos:closest_ray_point(spos, epos)
    local dist = lpos:dist(closray)
    if(dist < 75) then
        if(ram.anti_bruteforce.tickcounts[globals.tickcount] == nil) then
            table.insert(ram.anti_bruteforce.tickcounts, 1, {[globals.tickcount] = player_which_shotting})
            table.insert(ram.anti_bruteforce.realtime, 1, globals.realtime)
        end
    end
end

function enter_bombzone(event)
    if(entity.get(event.userid, true) == entity.get_local_player() and event.hasbomb) then
        ram.in_bombzone = true
    end
end

function exit_bombzone(event)
    if(entity.get(event.userid, true) == entity.get_local_player()) then
        ram.in_bombzone = false
    end
end

function fix_bomb_site_e(cmd)
    local camera_angles = render.camera_angles()
    local camera_position = render.camera_position()
    local direction = vector():angles(camera_angles)
    local entities = entity.get_entities()
    local dist, orig_dist = math.huge, math.huge
    local lp = entity.get_local_player()
    if(lp ~= nil) then
        for i = 1, #entities do
            if(entities[i]:get_classname() == "CPropDoorRotating" or (entities[i]:is_weapon() and entities[i]:get_weapon_owner() ~= entity.get_local_player()) and entities[i]:is_visible()) then
                if(entities[i]:get_classname() == "CPropDoorRotating") then
                    ent_pos = vector(entities[i]:get_origin().x, entities[i]:get_origin().y, entities[i]:get_origin().z + 50)
                else
                    ent_pos = entities[i]:get_origin()
                end
                local lpor = lp:get_origin()
                local ray_dist = ent_pos:dist_to_ray(camera_position, direction)
                if(ray_dist < dist) then
                    orig_dist = lpor:dist(ent_pos)
                    dist = ray_dist
                end
            end
        end
        if((ram.in_bombzone or dist > 45 or orig_dist > 105) and lp.m_iTeamNum == 2) then
            cmd.in_use = false
            return true
        else
            return false
        end
    else
        return false
    end
end

function get_velocity(player)
    if(player == nil) then return end
    local vec = player.m_vecVelocity
    local velocity = vec:length()
    return velocity
end

local function in_crouching(player)
    local flags = player.m_fFlags

    if bit.band(flags, 4) == 4 then
        return true
    end

    return false
end

local function in_air(player)
    local flags = player.m_fFlags

    if bit.band(flags, 1) == 0 then
        return true
    end

    return false
end

function cond_trig()
    local n = 1
    local c = ""
    local lp = entity.get_local_player()
    if(lp ~= nil and lp.m_iHealth > 0) then
        local fake_duck = ui.find("aimbot", "anti aim", "misc", "fake duck"):get()
        local slowwalking = ui.find("aimbot", "anti aim", "misc", "slow walk"):get()
        local crouch = in_crouching(lp)
        local standing = get_velocity(lp) < 3 and not (slowwalking or in_air(lp) or crouch or fake_duck)
        local moving = get_velocity(lp) >= 3 and not (slowwalking or in_air(lp) or crouch or fake_duck)
        local air = in_air(lp) and not (slowwalking or crouch)
        local crouch_air = in_air(lp) and crouch and not (slowwalking)
        local t_crouch = (crouch or fake_duck) and not (slowwalking or air or crouch_air) and lp.m_iTeamNum == 2
        local ct_crouch = (crouch or fake_duck) and not (slowwalking or air or crouch_air) and lp.m_iTeamNum == 3
        local work = {standing, moving, slowwalking, air, crouch_air, t_crouch, ct_crouch}
        for i = 1, #work do
            if(work[i]) then
                n = i + 1
                c = lua.conditions_non_g[i]
            end
        end
    end
    return {n, c}
end

function fs_dis()
    if((menu.aaf.freestand.manual:get() and menu.aaf.yaw_base:get() ~= icons.back .. " At Target") or menu.aaf.freestand.disablers:get(cond_trig()[2])) then
        return true
    else
        return false
    end
end

function force_static()

    if(menu.aa.static_if:get("Warmup") and entity.get_game_rules().m_bWarmupPeriod) then
        return true
    elseif(menu.aa.static_if:get("Manual") and menu.aaf.yaw_base:get() ~= icons.back .. " At Target") then
        return true
    elseif(menu.aa.static_if:get("Fake-lag") and rage.exploit:get() == 0) then
        return true
    elseif(menu.aa.static_if:get("Freestand") and menu.aaf.freestand:get() and rage.antiaim:get_target(true) ~= nil and not fs_dis()) then
        return true
    else
        return false
    end
end

local ref = {
    fake_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    sw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_mod_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    free_body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    yaw_mod_free = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    desync_freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    aaos = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    hidden_cvars = ui.find("Miscellaneous", "Main", "Other", "Unlock Hidden Cvars"),
    air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    scope_type = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    ping_spike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    fl_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    dtlim = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
}

function get_target()
	-- All vectors are 3D, even the ones you'd expect to be 2D
	local screen_center = render.screen_size() * 0.5

	local local_player = entity.get_local_player()
	if not local_player or not local_player:is_alive() then
		return
	end

	local camera_position = render.camera_position()

	-- Even angles are 3D vectors
	-- x is pitch, y is yaw, z is roll
	local camera_angles = vector(0, render.camera_angles().y)

	-- Let's convert it to a forward vector though
	local direction = vector():angles(camera_angles)

	local closest_distance, closest_enemy = math.huge
	for _, enemy in ipairs(entity.get_players(true, true)) do
        if(enemy == nil or enemy.m_iHealth <= 0) then goto skip end
		local head_position = enemy:get_hitbox_position(1)
        

		local ray_distance = head_position:dist_to_ray(
			camera_position, direction
		)
		
		if ray_distance < closest_distance then
			closest_distance = ray_distance
			closest_enemy = enemy
		end
        ::skip::
	end

	if not closest_enemy then
		return
	end
    return closest_enemy
end

function calc_angle(src, dst)
    local vecdelta = vector(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = vector(math.atan2(-vecdelta.z, vecdelta:length2d()) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end

function Angle_Vector(angle_x, angle_y)
    local sp, sy, cp, cy = nil
    sp = math.sin(math.rad(angle_x));
    sy = math.sin(math.rad(angle_y));
    cp = math.cos(math.rad(angle_x));
    cy = math.cos(math.rad(angle_y));
    return vector(cp * cy, cp * sy, -sp);
end

function yaw_base_degree()
    if(menu.aaf.yaw_base:get() == icons.back .. " At Target") then
        ref.base:override("Local View")
        if(get_target() ~= nil and get_target().m_vecOrigin ~= nil and not (not fs_dis() and rage.antiaim:get_target(true) ~= nil and menu.aaf.freestand:get())) then
            yaw = calc_angle(entity.get_local_player().m_vecOrigin, get_target().m_vecOrigin).y - render.camera_angles().y
        else
            yaw = 0
        end
        ref.freestanding:override(false)
    elseif(menu.aaf.yaw_base:get() == icons.back .. " Backward") then
        ref.base:override("Local View")
        yaw = 0
        ref.freestanding:override(false)
    elseif(menu.aaf.yaw_base:get() == icons.left .. " Left") then
        ref.base:override("Local View")
        yaw = -90
        ref.freestanding:override(false)
    elseif(menu.aaf.yaw_base:get() == icons.right .. " Right") then
        ref.base:override("Local View")
        yaw = 90
        ref.freestanding:override(false)
    elseif(menu.aaf.yaw_base:get() == icons.up .. " Forward") then
        ref.base:override("Local View")
        yaw = 180
        ref.freestanding:override(false)
    elseif(menu.aaf.freestand:get() and force_static() and not fs_dis()) then
        ref.base:override("At Target")
        yaw = 0
        ref.freestanding:override(true)
    else
        ref.base:override("Local View")
        yaw = 0
        ref.freestanding:override(false)
    end
    return yaw
end

local n = 1
local ab_csa = 0

function ab_value()
    n = menu.aa.builder[cond_trig()[1]].enabled:get() and cond_trig()[1] or 1
    local shots = #ram.anti_bruteforce.tickcounts
    local max_ph = menu.aa.max_phase[n].max:get()
    local phase_n = shots - max_ph * (math.floor(shots / max_ph)) + 1
    local val = menu.aa.ab_builder[n][phase_n]:get()
    if(menu.misc.logs:get() and menu.misc.logs.events:get("Anti-bruteforce") and menu.aa.max_phase[n].enabled:get()) then
        local ac = "\a" .. menu.misc.logs.misc_color:get():to_hex():sub(1, 6)
        if(ab_csa ~= shots) then
            ab_csa = shots
            if(menu.misc.logs.output:get("Console")) then
                print_raw(ac .. "[+] Switched Anti-bruteforce phase due to enemy shot [" .. phase_n .. "]")
            end
            if(menu.misc.logs.output:get("Up of screen")) then
                print_dev("[+] Switched Anti-bruteforce phase due to enemy shot [" .. phase_n .. "]")
            end
            if(menu.misc.logs.output:get("Screen")) then
                table.insert(lua.logs, 1, {t = "Misc", n = "Switched Anti-bruteforce phase due to enemy shot [" .. ac .."FF" .. phase_n .. "\aDEFAULT]", alpha = 0, time = globals.realtime})
            end
        end
    end
    if(#ram.anti_bruteforce.realtime == 0 or globals.realtime - ram.anti_bruteforce.realtime[#ram.anti_bruteforce.realtime] > menu.aa.anti_brute_reset:get() or not menu.aa.max_phase[n].enabled:get()) then
        return 0
    else
        return val
    end
end

function fast_ladder(cmd)
    if(menu.aa.fast_ladder:get()) then
        local local_player = entity.get_local_player()
        local pitch, yaw = render.camera_angles().x, render.camera_angles().y
        if local_player.m_MoveType == 9 then
            cmd.view_angles.y = math.floor(cmd.view_angles.y+0.5)
            cmd.roll = 0
            if menu.aa.fast_ladder.ladder_yaw_checkbox:get() then
                if cmd.forwardmove == 0 then
                    cmd.pitch = 89
                    cmd.view_angles.y = cmd.view_angles.y + menu.aa.fast_ladder.ladder_yaw_slider:get()
                    if math.abs(menu.aa.fast_ladder.ladder_yaw_slider:get()) > 0 and math.abs(menu.aa.fast_ladder.ladder_yaw_slider:get()) < 180 and cmd.sidemove ~= 0 then
                        cmd.view_angles.y = cmd.view_angles.y - menu.aa.fast_ladder.ladder_yaw_slider:get()
                    end
                    if math.abs(menu.aa.fast_ladder.ladder_yaw_slider:get()) == 180 then
                        if cmd.sidemove < 0 then
                            cmd.in_moveleft = 0
                            cmd.in_moveright = 1
                        end
                        if cmd.sidemove > 0 then
                            cmd.in_moveleft = 1
                            cmd.in_moveright = 0
                        end
                    end
                end
            end
    
            if (menu.aa.fast_ladder.options:get("Ascending")) then
                if cmd.forwardmove > 0 then
                    if pitch < 45 then
                        cmd.view_angles.x = 89
                        cmd.in_moveright = 1
                        cmd.in_moveleft = 0
                        cmd.in_forward = 0
                        cmd.in_back = 1
                        if cmd.sidemove == 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 90
                        end
                        if cmd.sidemove < 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 150
                        end
                        if cmd.sidemove > 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 30
                        end
                    end 
                end
            end
            if (menu.aa.fast_ladder.options:get("Descending")) then
                if cmd.forwardmove < 0 then
                    cmd.view_angles.x = 89
                    cmd.in_moveleft = 1
                    cmd.in_moveright = 0
                    cmd.in_forward = 1
                    cmd.in_back = 0
                    if cmd.sidemove == 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 90
                    end
                    if cmd.sidemove > 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 150
                    end
                    if cmd.sidemove < 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 30
                    end
                end
            end
        end
    end
end

local lshot = {}
local hm = {}

function aim_ack_no_chole(e)
    table.insert(lshot, globals.realtime)
    table.insert(hm, {vec = e.aim, t = globals.realtime, alpha = 0})
end

events.aim_ack:set(aim_ack_no_chole)

function anti_aim(cmd)
    if(menu.aaf.enabled:get()) then
        local lp = entity.get_local_player()
        local standing = get_velocity(lp) < 3
        local lw = lp:get_player_weapon()
        if(lw ~= nil) then
            lw_index = lw:get_weapon_index()
        end
        if(lw_index ~= nil and lw_index == 64) then
            ref.dtlim:override(2)
        else
            ref.dtlim:override(ref.dtlim:get())
        end
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):override("Static")

        fast_ladder(cmd)
        if(menu.aa.break_lc:get(cond_trig()[2])) then
            ref.lag_options:override("Always On")
        else
            ref.lag_options:override(ref.lag_options:get())
        end
        if(globals.choked_commands == 0) then
            ram.jitter = not ram.jitter
            inverted = entity.get_local_player().m_flPoseParameter[11] * 120 - 60 > 0
        else
            if(inverted == nil) then
                inverted = false
            else
                inverted = inverted
            end
        end
        ref.body_yaw:override(false)
        n = menu.aa.builder[cond_trig()[1]].enabled:get() and cond_trig()[1] or 1
        if(sim_diff() < menu.aa.defensive.cond.sens:get() / 100 * -1 and ref.dt:get()) then
            table.insert(ram.defensive, globals.realtime)
        end 
        if(menu.aa.bomb_e_fix:get() and fix_bomb_site_e(cmd) and common.is_button_down(0x45) and lp.m_iTeamNum == 2) then
            ref.pitch:set("Disabled")
            ref.yaw_mod_degree:set(0)
            ref.yaw_mod:set("Disabled")
            ref.offset:override(180)
            ref.left_limit:set(0)
            ref.right_limit:set(0)
            ref.fake_options:set("")
            ram.jit_yaw = 0
            ram.yaw_add = 0
        elseif(force_static()) then
            ref.pitch:set("Down")
            ref.yaw_mod:set("Disabled")
            ref.yaw_mod_degree:set(0)
            ref.offset:override(yaw_base_degree())
            ref.left_limit:set(60)
            ref.right_limit:set(60)
            ref.fake_options:override("")
            ram.jit_yaw = 0
            ram.yaw_add = 0
        elseif(#ram.defensive > 0 and globals.realtime - ram.defensive[#ram.defensive] < 1 / 64 * (101 - menu.aa.defensive.cond.sens:get()) / 10 and menu.aa.defensive.cond:get(cond_trig()[2])) then
            local dtab = menu.aa.defensive
            ram.yaw_add = inverted and dtab.yaw_add_left:get() or dtab.yaw_add_right:get()
            if not ((dtab.yaw_mod:get() == "3-Way" or dtab.yaw_mod:get() == "5-Way") and dtab.yaw_mod.custom_ways:get() or dtab.yaw_mod:get() == "Hidden") then
                ref.hidden:set(false)
                if(dtab.yaw_mod:get() == "Disabled") then
                    ram.jit_yaw = 0
                elseif(dtab.yaw_mod:get() == "Center") then
                    ram.jit_yaw = ram.jitter and dtab.yaw_mod.modifier_degree:get() / -2 or dtab.yaw_mod.modifier_degree:get() / 2
                elseif(dtab.yaw_mod:get() == "Offset") then
                    ram.jit_yaw = ram.jitter and dtab.yaw_mod.modifier_degree:get() or 0
                elseif(dtab.yaw_mod:get() == "Random") then
                    if(dtab.yaw_mod.modifier_degree:get() >= 0) then
                        ram.jit_yaw = math.random(0, math.abs(dtab.yaw_mod.modifier_degree:get())) - math.abs(dtab.yaw_mod.modifier_degree:get()) / 2
                    else
                        ram.jit_yaw = (math.random(0, math.abs(dtab.yaw_mod.modifier_degree:get())) - math.abs(dtab.yaw_mod.modifier_degree:get()) / 2) * -1
                    end
                elseif(dtab.yaw_mod:get() == "Spin") then
                    if(dtab.yaw_mod.modifier_degree:get() >= 0) then
                        mult = 1
                    else
                        mult = -1
                    end
                    if(ram.jit_yaw < math.abs(dtab.yaw_mod.modifier_degree:get())) then
                        ram.jit_yaw = ram.jit_yaw + 3
                    else
                        ram.jit_yaw = math.abs(dtab.yaw_mod.modifier_degree:get()) * -1 / 2
                    end
                elseif(dtab.yaw_mod:get() == "3-Way") then
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / -2
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / 2 - 10
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / 2
                    end
                elseif(dtab.yaw_mod:get() == "5-Way") then
                    ref.hidden:set(false)
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / -2
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / -2.5
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / 2.5
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / 2 - 10
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = dtab.yaw_mod.modifier_degree:get() / 2
                    end
                end
                ref.yaw_mod:set("Disabled")
                ref.yaw_mod_degree:set(0)
            else
                ref.yaw_mod:set("Disabled")
                ref.yaw_mod_degree:set(0)
                if(dtab.yaw_mod:get() == "3-Way") then
                    ref.hidden:set(false)
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = dtab.yaw_mod.first_degree:get()
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = dtab.yaw_mod.second_degree:get()
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = dtab.yaw_mod.third_degree:get()
                    end
                elseif(dtab.yaw_mod:get() == "5-Way") then
                    ref.hidden:set(false)
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = dtab.yaw_mod.first_degree:get()
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = dtab.yaw_mod.second_degree:get()
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = dtab.yaw_mod.third_degree:get()
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = dtab.yaw_mod.fourth_degree:get()
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = dtab.yaw_mod.fifth_degree:get()
                    end
                else
                    ref.hidden:set(true)
                end
            end
            if(dtab.pitch:get() ~= "Jitter") then
                ref.pitch:set(dtab.pitch:get())
            else
                pitchs = {"Disabled", "Down", "Fake Up", "Fake Down"}
                if(#dtab.pitch.pitches:get() ~= 0) then
                    ref.pitch:set(dtab.pitch.pitches:get()[math.random(1,#dtab.pitch.pitches:get())])
                else
                    ref.pitch:set(pitchs[math.random(1, #pitchs)])
                end
            end
        else
            local tab = menu.aa.builder[n]
            ref.left_limit:set(tab.left_limit:get())
            ref.right_limit:set(tab.right_limit:get())
            ref.hidden:set(false)
            ref.fake_options:set(tab.fake_options:get())
            ram.yaw_add = inverted and tab.yaw_add_left:get() - ab_value() / 2 or tab.yaw_add_right:get() + ab_value() / 2
            ref.pitch:set(tab.pitch:get())
         --   ref.offset:set(ram.jit_yaw + yaw_base_degree() + ram.yaw_add)
            if not ((tab.yaw_mod:get() == "3-Way" or tab.yaw_mod:get() == "5-Way") and tab.yaw_mod.custom_ways:get()) then
                if(tab.yaw_mod:get() == "Disabled") then
                    ram.jit_yaw = 0
                elseif(tab.yaw_mod:get() == "Center") then
                    ram.jit_yaw = ram.jitter and (tab.yaw_mod.modifier_degree:get() + ab_value() / 2) / -2 or (tab.yaw_mod.modifier_degree:get() + ab_value() / 2) / 2
                elseif(tab.yaw_mod:get() == "Offset") then
                    ram.jit_yaw = ram.jitter and (tab.yaw_mod.modifier_degree:get() + ab_value()) or ab_value() * -1
                elseif(tab.yaw_mod:get() == "Random") then
                    ram.jit_yaw = math.random(0, tab.yaw_mod.modifier_degree:get() + ab_value()) - (tab.yaw_mod.modifier_degree:get() + ab_value()) / 2
                elseif(tab.yaw_mod:get() == "Spin") then
                    if(tab.yaw_mod.modifier_degree:get() >= 0) then
                        mult = 1
                    else
                        mult = -1
                    end
                    if(mult == 1) then
                        if(ram.jit_yaw < math.abs(tab.yaw_mod.modifier_degree:get() + ab_value())) then
                            ram.jit_yaw = ram.jit_yaw + 3
                        else
                            ram.jit_yaw = math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) * -1 / 2
                        end
                    else
                        if(ram.jit_yaw > math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) * -1) then
                            ram.jit_yaw = ram.jit_yaw - 3
                        else
                            ram.jit_yaw = math.abs(tab.yaw_mod.modifier_degree:get() + ab_value()) / 2
                        end
                    end
                elseif(tab.yaw_mod:get() == "3-Way") then
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2 - ab_value()
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value() - 10
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value()
                    end
                elseif(tab.yaw_mod:get() == "5-Way") then
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2 - ab_value()
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / -2.5 - ab_value() / 2
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2.5
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 - 10 + ab_value() / 2
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = tab.yaw_mod.modifier_degree:get() / 2 + ab_value()
                    end
                end
                ref.yaw_mod:set("Disabled")
                ref.yaw_mod_degree:set(0)
            else
                ref.yaw_mod:set("Disabled")
                ref.yaw_mod_degree:set(0)
                if(tab.yaw_mod:get() == "3-Way") then
                    if(globals.tickcount % 3 == 2) then
                        ram.jit_yaw = tab.yaw_mod.first_degree:get() - ab_value()
                    elseif(globals.tickcount % 3 == 1) then
                        ram.jit_yaw = tab.yaw_mod.second_degree:get()
                    elseif(globals.tickcount % 3 == 0) then
                        ram.jit_yaw = tab.yaw_mod.third_degree:get() + ab_value()
                    end
                elseif(tab.yaw_mod:get() == "5-Way") then
                    if(globals.tickcount % 5 == 4) then
                        ram.jit_yaw = tab.yaw_mod.first_degree:get() - ab_value()
                    elseif(globals.tickcount % 5 == 3) then
                        ram.jit_yaw = tab.yaw_mod.second_degree:get() - ab_value() / 2
                    elseif(globals.tickcount % 5 == 2) then
                        ram.jit_yaw = tab.yaw_mod.third_degree:get()
                    elseif(globals.tickcount % 5 == 1) then
                        ram.jit_yaw = tab.yaw_mod.fourth_degree:get() + ab_value() / 2
                    elseif(globals.tickcount % 5 == 0) then
                        ram.jit_yaw = tab.yaw_mod.fifth_degree:get() + ab_value()
                    end
                end
            end
        end
        if not (ref.dt:get() and rage.exploit:get() ~= 1) then
            if(ram.fix_tp == rage.exploit:get()) then
                if not (#lshot > 0 and globals.realtime - lshot[#lshot] <= 1 / 64 * 14) then
                    lshot = {}
                    if(rage.exploit:get() > 0) then
                        if(globals.choked_commands == 0) then
                            cmd.send_packet = false
                        end
                    elseif(standing) then
                        if(globals.choked_commands < 3) then
                            cmd.send_packet = false
                        end
                    else
                        if(globals.choked_commands < ref.fl_limit:get()) then
                            cmd.send_packet = false
                        end
                    end
                end
                if(menu.aa.builder[n].fake_options:get("Jitter")) then
                    if(menu.aa.builder[n].fake_options:get("Randomize Jitter")) then
                        if(math.random(0, 10) > 5) then 
                            side = ram.jitter and -1 or 1
                        end
                    else
                        side = ram.jitter and -1 or 1
                    end
                else
                    side = ref.inverter:get() and 1 or -1
                end
            else
                ram.fix_tp = rage.exploit:get()
                cmd.send_packet = true
            end
        end
        if(force_static()) then
            orig_desync = 0
            desync_value = 0
            multipl = 1
        else
            orig_desync = rage.antiaim:inverter() and ref.right_limit:get() or ref.left_limit:get()
            desync_value = rage.antiaim:inverter() and (ref.right_limit:get() / 2 + 30) or (ref.left_limit:get() / 2 + 30)
            multipl = rage.antiaim:inverter() and ref.right_limit:get() / 60 or ref.left_limit:get() / 60
        end
        model_add = render.camera_angles().y
        if(rage.antiaim:get_target(true) ~= nil and menu.aaf.freestand:get() and not fs_dis()) then
            fr_val = rage.antiaim:get_target(true)
        else
            fr_val = 180 + model_add
        end
        if(menu.aa.bomb_e_fix:get() and fix_bomb_site_e(cmd) and common.is_button_down(0x45) and lp.m_iTeamNum == 2) then
            ref.offset:override(model_add)
        else
            if(standing and not (cmd.in_moveleft or cmd.in_moveright or cmd.in_forward or cmd.in_back or cmd.in_left or cmd.in_right) and not ui.find("aimbot", "anti aim", "misc", "fake duck"):get()) then
                cmd.sidemove = ram.jitter_move and 1.1 or -1.1
                ram.jitter_move = not ram.jitter_move
            end
            if(menu.aa.builder[n].fake_options:get("Jitter")) then
                if not (cmd.send_packet) then
                    ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + orig_desync * 2 * side + fr_val))
                else
                    ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            elseif(standing) then
                if not (cmd.send_packet) then
                    ram.set_lby = not ram.set_lby
                    if(ram.set_lby) then
                        ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + desync_value * 2 * side + fr_val))
                    else
                        ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add - (120 - desync_value * 2) * side + fr_val))
                    end
                else
                    ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            else
                if not (cmd.send_packet) then
                    ram.set_lby = not ram.set_lby
                    if(ram.set_lby) then
                        ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + orig_desync * 2 * side + fr_val))
                    else
                        ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add - 5 * side + fr_val))
                    end
                else
                    ref.offset:override(math.normalize_yaw(ram.jit_yaw + yaw_base_degree() + ram.yaw_add + fr_val))
                end
            end
        end
    end
end

function get_ragebot_target()
    local local_player = entity.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local best, best_enemy = math.huge
    for _, enemy in ipairs(entity.get_players(true)) do
        local body_position = enemy:get_hitbox_position(2)
        local damage_to_enemy = utils.trace_bullet(local_player, local_player:get_hitbox_position(2), body_position)
        if(enemy.m_iHealth <= 0 or damage_to_enemy <= 0) then goto skip end
        
        if damage_to_enemy < best then
            best = damage_to_enemy
            best_enemy = enemy
        end

        ::skip::
    end
    if not best_enemy then
        return
    else
        return best_enemy
    end
end
-- O.G L.E.A.K.S
local function math_hundred_floor(value)
    return (math.floor(value * 100) / 100)
end

local function main_anim(tog, val, max_v, speed, anim, add_one)
    if(add_one == nil or add_one == false) then
        adding = 0
    else
        adding = 5
    end
    local wanted_frametime = 144
    local current_frametime = 1 / globals.frametime
    local percent = wanted_frametime / current_frametime
    if(anim == nil or anim == true) then
        if(speed == nil) then
            speed = 0.2
        end
        if(tog) then
            if(val ~= max_v) then
                val = val + (max_v + adding - val) * speed * percent
            else
                val = max_v
            end
        else
            if(val > 0) then
                val = val - val * speed * percent
            else
                val = 0
            end
        end
    else
        val = tog and max_v or 0
    end
    return math_hundred_floor(val)
end

function extrapolate_pos(x,y,z, ticks, player)
    for i = 1, ticks do
        x = x + player.m_vecVelocity.x * (1 / 64)
        y = y + player.m_vecVelocity.y * (1 / 64)
        z = z + player.m_vecVelocity.z * (1 / 64)
    end
    return vector(x,y,z)
end
-- O.G L.E.A.K.S
function ragebot(cmd)
    local lp = entity.get_local_player()
    local rtab = menu.rage
    if(rtab.no_fall_damage:get()) then
        local vec = lp.m_vecVelocity
        local l_o = lp.m_vecOrigin
        local tracer = utils.trace_line(l_o, vector(l_o.x, l_o.y, l_o.z - 500), nil, nil, 1)
        if(l_o.z - tracer.end_pos.z <= 70 and l_o.z - tracer.end_pos.z >= 12 and in_air(lp) and vec.z < -450) then
            cmd.in_duck = true
        end
    end
    if(rtab.avoid_collisions:get()) then
        local dm = rtab.avoid_collisions.distance:get()
        local camera_angles = render.camera_angles()
        local yaw = camera_angles.y
        local l = lp.m_vecOrigin
        local min = math.huge
        local val = math.huge
        for i = 1, 180 do
            local dir_x, dir_y, dir_z = Angle_Vector(0, (yaw + i - 90)).x, Angle_Vector(0, (yaw + i - 90)).y, Angle_Vector(0, (yaw)).z
            local end_x, end_y, end_z = l.x + dir_x * 70, l.y + dir_y * 70, l.z + 60
            local tracer = utils.trace_line(l, vector(end_x, end_y, end_z), nil, nil, 1)
            if(l:dist(tracer.end_pos) < min) then
                min = l:dist(tracer.end_pos)
                val = i
            end
        end
        if(min < 25 + dm and cmd.in_jump and not (cmd.in_moveright or cmd.in_moveleft or cmd.in_back)) then
            forward_velo = math.abs(get_velocity(lp) * math.cos(math.rad(val)))
            if(math.abs(val-90) < 40) then
                side_velo = get_velocity(lp) * math.sin(math.rad(val)) * (25 + dm - min) / 15
            else
                side_velo = get_velocity(lp) * math.sin(math.rad(val))
            end
            cmd.forwardmove = forward_velo
            if(val >= 90) then
                cmd.sidemove = side_velo
            else
                cmd.sidemove = side_velo * -1
            end
        end
    end
    if(rtab.exploits_discharge:get()) then
        local sens = rtab.exploits_discharge.sens:get()
        local target = get_ragebot_target()
        if(target ~= nil) then
            local lpos = lp:get_hitbox_position(2)
            local target_pos = target:get_hitbox_position(2)
            local target_extrapolation = extrapolate_pos(target_pos.x, target_pos.y, target_pos.z, 6 * (100 - sens / 2) / 100, target)
            local lp_extrapolation = extrapolate_pos(lpos.x, lpos.y, lpos.z, 14 * (100 - sens / 2) / 100, lp)
            local target_extra_pos = vector(target_extrapolation.x, target_extrapolation.y,target_pos.z)
            local lp_extra_pos = vector(lp_extrapolation.x, lp_extrapolation.y, lpos.z)

            local tracer1 = utils.trace_bullet(get_ragebot_target(), target_extra_pos, lpos)
            local tracer2 = utils.trace_bullet(get_ragebot_target(), target_extra_pos, lp_extra_pos)
            if(sens < 50) then
                if(tracer1 > 0) then
                    rage.exploit:force_teleport()
                end
            else
                if(sens < 60) then
                    if(tracer1 > tracer2) then
                        rage.exploit:force_teleport()
                    end
                else
                    if(tracer1 > tracer2 and tracer2 <= 0) then
                        rage.exploit:force_teleport()
                    end
                end
            end
        end
    end
    if(rtab.in_air_hitchance:get()) then
        local ws = rtab.in_air_hitchance.weapons:get()
        for i = 1, #ws do
            if(in_air(lp)) then
                local path = ui.find("Aimbot", "Ragebot", "Selection", ws[i], "Hit Chance")
                path:override(rtab.in_air_hitchance.hitchance:get())
            else
                for k = 1, #lua.weapons do
                    local path = ui.find("Aimbot", "Ragebot", "Selection", lua.weapons[k], "Hit Chance")
                    path:override(path:get())
                end
            end
        end
    end
    if(rtab.no_scope_hitchance and not (rtab.in_air_hitchance:get() and in_air(lp))) then
        local ws = rtab.no_scope_hitchance.weapons:get()
        for i = 1, #ws do
            if(lp.m_bIsScoped) then
                for k = 1, #lua.weapons do
                    local path = ui.find("Aimbot", "Ragebot", "Selection", lua.weapons[k], "Hit Chance")
                    path:override(path:get())
                end
            else
                local path = ui.find("Aimbot", "Ragebot", "Selection", ws[i], "Hit Chance")
                path:override(rtab.no_scope_hitchance.hitchance:get())
            end
        end
    end
    if(rtab.fast_fall:get()) then
        local vec = lp.m_vecVelocity
        local l_o = lp.m_vecOrigin
        local tracer = utils.trace_line(l_o, vector(l_o.x, l_o.y, l_o.z - 75), nil, nil, 1)
        if(vec.z < -100) then
            if(l_o.z - tracer.end_pos.z <= 55) then
                rage.exploit:force_teleport()
            end
        end
    end
    if(menu.mods.aspect_ratio:get()) then
        if(ref.hidden_cvars:get_override() ~= true) then
            ref.hidden_cvars:override(true)
        end
        if(cvar.r_aspectratio:float() ~= menu.mods.aspect_ratio.val:get() / 100) then
            cvar.r_aspectratio:float(menu.mods.aspect_ratio.val:get() / 100)
        end
    else
        cvar.r_aspectratio:float(0)
    end
    if(menu.mods.viewmodel:get()) then
        if(cvar.viewmodel_fov:int() ~= menu.mods.viewmodel.viewmodel_fov:get() + 68) then
            cvar.viewmodel_fov:int(menu.mods.viewmodel.viewmodel_fov:get() + 68, true) 
        end
        if(cvar.viewmodel_offset_x:float() ~= menu.mods.viewmodel.viewmodel_x:get() + 1) then
            cvar.viewmodel_offset_x:float(menu.mods.viewmodel.viewmodel_x:get() + 1, true) 
        end
        if(cvar.viewmodel_offset_y:float() ~= menu.mods.viewmodel.viewmodel_y:get() + 1) then
            cvar.viewmodel_offset_y:float(menu.mods.viewmodel.viewmodel_y:get() + 1, true) 
        end
        if(cvar.viewmodel_offset_z:float() ~= menu.mods.viewmodel.viewmodel_z:get() / 2 - 1) then
            cvar.viewmodel_offset_z:float(-1 + menu.mods.viewmodel.viewmodel_z:get() / 2, true) 
        end
    else 
        cvar.viewmodel_fov:int(68) 
        cvar.viewmodel_offset_x:int(1) 
        cvar.viewmodel_offset_y:int(1) 
        cvar.viewmodel_offset_z:int(-1) 
    end
end
-- O.G L.E.A.K.S
function render_ragebot()
    -- O.G L.E.A.K.S
    if(menu.rage.no_fall_damage:get() and entity.get_local_player() ~= nil and entity.get_local_player().m_iHealth > 0) then
        local path = menu.rage.no_fall_damage

        if(path.draw_ind:get()) then
            if(path.font:get() == "Default") then
                f = 1
            elseif(path.font:get() == "Small") then
                f = 2
            elseif(path.font:get() == "Console") then
                f = 3
            elseif(path.font:get() == "Bold") then
                f = 4
            else
                f = 1
            end
            local lp = entity.get_local_player()
            local vec = lp.m_vecVelocity
            local l_o = lp.m_vecOrigin
            local tracer = utils.trace_line(l_o, vector(l_o.x, l_o.y, l_o.z - 500), nil, nil, 1)
            if(l_o.z - tracer.end_pos.z <= 45 and l_o.z - tracer.end_pos.z >= 12 and in_air(lp) and vec.z < -450) then
                render.text(f, vector(render.screen_size().x / 2 + path.x:get(), render.screen_size().y / 2 + path.y:get()), path.color:get(), nil, "DANGEROUS!!! CONTROLLING")
            elseif(path.always_on:get()) then
                render.text(f, vector(render.screen_size().x / 2 + path.x:get(), render.screen_size().y / 2 + path.y:get()), path.color:get(), nil, "NO FALL DAMAGE")
            end
        end
    end
    if(menu.mods.hitmarker:get()) then
        for i, h in ipairs(hm) do
            if(globals.realtime - h.t < 1) then
                h.alpha = main_anim(true, h.alpha, 255, 0.05)
            elseif(globals.realtime - h.t > 3) then
                h.alpha = main_anim(false, h.alpha, 255, 0.05)
                if(h.alpha == 0) then
                    table.remove(hm, i)
                end
            end
            render.text(1, render.world_to_screen(h.vec), color(255,255,255,h.alpha), "c", "+")
        end
    end
end
-- O.G L.E.A.K.S
local renderer = {
    rectangle = function(x, y, w, h, r, g, b, a)
        render.rect(vector(x, y), vector(x + w, y + h), color(r,g,b,a))
    end,
    circle = function(x, y, r, g, b, a, radius, deg, perc)
        render.circle(vector(x, y), color(r,g,b,a), radius, deg, perc)
    end,
    circle_outline = function(x, y, r, g, b, a, radius, start, perc, thickness)
        render.circle_outline(vector(x, y), color(r,g,b,a), radius, start, perc, thickness)
    end,
    gradient = function(x, y, w, h, r1, g1, b1, a1, r2, g2, b2, a2, ltr)
        if(ltr) then
            render.gradient(vector(x, y), vector(x + w, y + h), color(r1, g1, b1, a1), color(r2, g2, b2, a2), color(r1, g1, b1, a1), color(r2, g2, b2, a2))
        else
            render.gradient(vector(x, y), vector(x + w, y + h), color(r1, g1, b1, a1), color(r1, g1, b1, a1), color(r2, g2, b2, a2), color(r2, g2, b2, a2))
        end
    end
}
-- O.G L.E.A.K.S
local solus_render = (function()
    local solus_m = {}
    local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
        render.rect(vector(x + 1, y + 1), vector(x + w - 1, y + h - 1), color(r,g,b,a), radius)
    end
    local rounding = 4
    local n = 45
    local o = 20
    local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, 270, 0.25, 1)
        renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, a / 2, false)
        renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, a, r, g, b, a / 2, false)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a / 2, radius, 90, 0.25, 1)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a / 2, radius, 0, 0.25, 1)
        renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, a / 2)
    end
    solus_m.container = function(x, y, w, h, r, g, b, a, alpha)
        render.rect(vector(x + 1, y + 1), vector(x + w - 1, y + h - 1), color(17,17,17,alpha), rounding)
        FadedRoundedRect(x, y, w, h, rounding, r, g, b, a)
    end
    return solus_m
end)()

function render_box(x, y, w, h, alpha)
    local design = menu.visuals.interface_design
    local ac = design.accent_color:get()
    local gs = design.glow:get()
    local ec = design.enable_color:get()
    local gc = design.glow_color:get()
    if(alpha ~= nil) then
        mult = alpha
    else
        mult = 255
    end
    if(ec) then
        gcc = gc
    else
        gcc = ac
    end
    if(gs > 0) then
        render.shadow(vector(x, y), vector(x + w - 2, y + h - 1), color(gcc.r, gcc.g, gcc.b, gs * 2.55 * mult / 255), nil, gs / 100, 4)
    end
    solus_render.container(x, y, w, h, ac.r, ac.g, ac.b, mult, ac.a * mult / 255)
end
-- O.G L.E.A.K.S
calibri = render.load_font('calibri', 22, 'ab')

local function render_indicator(vectoring, colors, text)
    render.gradient(vector(15, vectoring.y - 6), vector(15 + render.measure_text(calibri, nil, text).x / 2, vectoring.y + 25), color(0,0,0,0), color(0,0,0,colors.a / 255 * 80), color(0,0,0,0), color(0,0,0,colors.a / 255 * 80))
    render.gradient(vector(15 + render.measure_text(calibri, nil, text).x / 2, vectoring.y - 6), vector(20 + render.measure_text(calibri, nil, text).x, vectoring.y + 25), color(0,0,0,colors.a / 255 * 80), color(0,0,0,0), color(0,0,0,colors.a / 255 * 80), color(0,0,0,0))
    render.text(calibri, vector(vectoring.x, vectoring.y + 1), color(17,17,17,colors.a), nil, text)
    render.text(calibri, vectoring, colors, nil, text)
end

local hvis = {
    skeet_alpha = {},
    watermark = {
        x = 0,
    },
    scope = {
        scoped = false,
        scope = 0,
        first_alpha = 0,
        second_alpha = 0,
    },
    central = {
        clouds_x = 0,
        logo_x = 0,
        el_a = {0,0,0,0,0},
        cond_x = {},
        binds_a = {},
        binds_x = {},
        scope_alpha = 0,
    },
    invert = false,
    binds = {
        alpha = {},
        w = 35,
        drug = false,
        drugging = false,
        add_x_m = 0,
        add_y_m = 0,
        alphab = 0,
    },
    preview_logs = 0,
}

verdanaar = render.load_font('verdana', 15, 'abd')

function visuals()
    local design = menu.visuals.interface_design
    local lp = entity.get_local_player()
    if((lp == nil or lp.m_iHealth <= 0) and ui.get_alpha() == 0) then
        return
    end
    
    if(lp ~= nil and lp.m_iHealth > 0) then
        hvis.scope.scoped = lp.m_bIsScoped
    else
        hvis.scope.scoped = false
    end
    hvis.scope.scope = main_anim(menu.misc.better_scope:get() and hvis.scope.scoped, hvis.scope.scope, 255, 0.12, menu.misc.better_scope.adjustments:get("Animations"))
    if(menu.visuals.left_indicators:get()) then
        local x = 15
        local y = render.screen_size().y - 1080 / 4
        local add_y = 0
        local binds = ui.get_binds()
        for i = 1, #binds do
            local u = #binds - i + 1
            local bu = binds[u]
            if(hvis.skeet_alpha[bu.name] == nil) then
                hvis.skeet_alpha[bu.name] = 0
            end
            hvis.skeet_alpha[bu.name] = main_anim(bu.active, hvis.skeet_alpha[bu.name], 255, 0.37, nil)
            if(bu.reference:name() == "Double Tap") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,rage.exploit:get() * 215,rage.exploit:get() * 215,hvis.skeet_alpha[bu.name]), "DT")
            elseif(bu.reference:name() == "Min. Damage") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), "Damage: " .. bu.value)
            elseif(bu.reference:name() == "Hit Chance") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(230,230,40,hvis.skeet_alpha[bu.name]), "HITCHANCE OVERRIDE")
            elseif(bu.reference:name() == "Hide Shots") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), "OSAA")
            elseif(bu.reference:name() == theme_color() .. icons.all .. "\aDEFAULT  Manual base") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), string.upper(bu.name) .. ": " .. bu.value)
            elseif(bu.reference:name() == "Fake Duck") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), "DUCK")
            elseif(bu.reference:name() == "Body Aim") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), "BODY")
            elseif(bu.reference:name() == "Dormant Aimbot") then
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), "DA")
            else
                render_indicator(vector(hvis.skeet_alpha[bu.name] / 255 * 15, y - add_y), color(215,215,215,hvis.skeet_alpha[bu.name]), string.upper(bu.name))
            end
            add_y = add_y + 37 * hvis.skeet_alpha[bu.name] / 255
        end
    end
    if(menu.visuals.watermark:get()) then
        local path = menu.visuals.watermark
        local mass = {}
        if(path.show:get("Cheat name")) then
            c_n = path.cheat_name:get()
            table.insert(mass, c_n)
        end
        if(path.show:get("Lua name")) then
            table.insert(mass, "🌥 apathyaw")
        end
        if(path.show:get("Nickname")) then
            if(path.nick:get() == "From cheat") then
                ni =  common.get_username()
            else
                ni = path.nickname:get()
            end
            table.insert(mass, "💀 " .. ni)
        end
        if(path.show:get("FPS")) then
            fps = math.floor(1 / globals.frametime)
            table.insert(mass, "💨 " .. fps)
        end
        if(path.show:get("Ping")) then
            ping = globals.is_connected and math.floor(utils.net_channel().latency[1] * 1000) or 0
            table.insert(mass, "📶 " .. ping)
        end
        if(path.show:get("Tickrate")) then
            tick = 1 / globals.tickinterval
            table.insert(mass, "tick: " .. tick)
        end
        if(path.show:get("Build")) then
            table.insert(mass, "[debug]")
        end
        if(path.show:get("User text")) then
            user_text = path.user_text:get()
            table.insert(mass, user_text)
        end
        if(path.show:get("Time")) then
            time = common.get_date("%H:%M")
            table.insert(mass, "🕘 " .. time)
        end
        local add_x = 0
        local add_x_2 = 0
        for i = 1, #mass do
            if(string.find(mass[#mass - i + 1], "💨")) then
                add_x = add_x + render.measure_text(1, nil, "💨 000").x + 10
            else
                add_x = add_x + render.measure_text(1, nil, mass[#mass - i + 1]).x + 10
            end
        end
        hvis.watermark.x = main_anim(true, hvis.watermark.x, add_x, 0.05, nil)
        if(path.posi:get() == "Right-Up") then
            render_box(render.screen_size().x - hvis.watermark.x - 18, 14, hvis.watermark.x, 20)
            for i = 1, #mass do
                render.text(1, vector(render.screen_size().x - hvis.watermark.x + add_x_2 - 12, 18), color(255,255,255,255), nil, mass[i])
                if(string.find(mass[i], "💨")) then
                    add_x_2 = add_x_2 + render.measure_text(1, nil, "💨 000").x + 10
                else
                    add_x_2 = add_x_2 + render.measure_text(1, nil, mass[i]).x + 10
                end
            end
        elseif(path.posi:get() == "Bottom") then
            render_box(render.screen_size().x / 2 - hvis.watermark.x / 2 - 16, render.screen_size().y - 23, hvis.watermark.x, 20)
            for i = 1, #mass do
                render.text(1, vector(render.screen_size().x / 2 - hvis.watermark.x / 2 + add_x_2 - 12, render.screen_size().y - 20), color(255,255,255,255), nil, mass[i])
                if(string.find(mass[i], "💨")) then
                    add_x_2 = add_x_2 + render.measure_text(1, nil, "💨 000").x + 10
                else
                    add_x_2 = add_x_2 + render.measure_text(1, nil, mass[i]).x + 10
                end
            end
        elseif(path.posi:get() == "Left-Up") then
            render_box(14, 14, hvis.watermark.x + 4, 20)
            for i = 1, #mass do
                render.text(1, vector(20 + add_x_2, 18), color(255,255,255,255), nil, mass[i])
                if(string.find(mass[i], "💨")) then
                    add_x_2 = add_x_2 + render.measure_text(1, nil, "💨 000").x + 10
                else
                    add_x_2 = add_x_2 + render.measure_text(1, nil, mass[i]).x + 10
                end
            end
        end
    end
    if(hvis.scope.scope > 0) then
        local path = menu.misc.better_scope
        local pos = path.pos:get()
        local offset = path.offset:get()
        local accent_color = path.color:get()
        local s_c = render.screen_size()
        local gs = path.glow:get()
        local gc = path.glow_color:get()
        hvis.scope.first_alpha = main_anim(path.adjustments:get("Invert"), hvis.scope.first_alpha, 255, 0.04, nil, true)
        hvis.scope.second_alpha = main_anim(not path.adjustments:get("Invert"), hvis.scope.second_alpha, 255, 0.04, nil, true)
        first_color = color(accent_color.r, accent_color.g, accent_color.b, accent_color.a * hvis.scope.scope / 255 * hvis.scope.first_alpha / 255)
        second_color = color(accent_color.r, accent_color.g, accent_color.b, accent_color.a * hvis.scope.scope / 255 * hvis.scope.second_alpha / 255)
        if(path.adjustments:get("Glow")) then
            if(path.enable_color:get()) then
                g_color = color(gc.r, gc.g, gc.b, gs * 2.55 * hvis.scope.scope / 255)
            else
                g_color = color(accent_color.r, accent_color.g, accent_color.b, gs * 2.55 * hvis.scope.scope / 255)
            end
            render.shadow(vector(s_c.x / 2 + pos * hvis.scope.scope / 255, s_c.y / 2), vector(s_c.x / 2 + pos + offset * hvis.scope.scope / 255, s_c.y / 2), g_color, nil, nil, 0)
            render.shadow(vector(s_c.x / 2 - offset * hvis.scope.scope / 255 - pos + 2, s_c.y / 2), vector(s_c.x / 2 - pos * hvis.scope.scope / 255 + 2, s_c.y / 2), g_color, nil, nil, 0)

            render.shadow(vector(s_c.x / 2, s_c.y / 2 - offset * hvis.scope.scope / 255 - pos + 2), vector(s_c.x / 2, s_c.y / 2 - pos * hvis.scope.scope / 255 + 2), g_color, nil, nil, 0)
            render.shadow(vector(s_c.x / 2, s_c.y / 2 + pos * hvis.scope.scope / 255), vector(s_c.x / 2, s_c.y / 2 + offset * hvis.scope.scope / 255 + pos), g_color, nil, nil, 0)
        end
        render.gradient(vector(s_c.x / 2 + pos * hvis.scope.scope / 255, s_c.y / 2), vector(s_c.x / 2 + pos + offset * hvis.scope.scope / 255, s_c.y / 2 + 1), second_color, first_color, second_color, first_color)
        render.gradient(vector(s_c.x / 2 - pos * hvis.scope.scope / 255 + 2, s_c.y / 2), vector(s_c.x / 2 - offset * hvis.scope.scope / 255 - pos + 2, s_c.y / 2 + 1), second_color, first_color, second_color, first_color)

        render.gradient(vector(s_c.x / 2, s_c.y / 2 - pos * hvis.scope.scope / 255 + 2), vector(s_c.x / 2 + 1, s_c.y / 2 - offset * hvis.scope.scope / 255 - pos + 2), second_color, second_color, first_color, first_color)
        render.gradient(vector(s_c.x / 2, s_c.y / 2 + pos * hvis.scope.scope / 255), vector(s_c.x / 2 + 1, s_c.y / 2 + offset * hvis.scope.scope / 255 + pos), second_color, second_color, first_color, first_color)
    end
    if(menu.misc.better_scope:get()) then
        if(ref.scope_type:get_override() ~= "Remove All") then
            ref.scope_type:override("Remove All")
        end
    else
        if(ref.scope_type:get_override() ~= ref.scope_type:get()) then
            ref.scope_type:override(ref.scope_type:get())
        end
    end
    if(menu.visuals.lua_indicators:get()) then
        local path = menu.visuals.lua_indicators
        local show = path.show:get()
        local x = render.screen_size().x / 2
        local y = render.screen_size().y / 2 + 50
        local f_c = path.first_color:get()
        local s_c = path.second_color:get()
        local add_y = 0
        local f = nil
        if(path.adjustments:get("DPI scale")) then
            f = "s"
        else
            f = ""
        end
        if(path.adjustments:get("Scope turn-off")) then
            hvis.central.scope_alpha = main_anim(not hvis.scope.scoped, hvis.central.scope_alpha, 255, 0.05, nil, true)
        else
            hvis.central.scope_alpha = main_anim(true, hvis.central.scope_alpha, 255, 0.05, nil, true)
        end
        hvis.central.clouds_x = main_anim(hvis.scope.scoped, hvis.central.clouds_x, render.measure_text(1, nil, "☀️🌤").x / 2 + 2, 0.07, nil)
        hvis.central.logo_x = main_anim(hvis.scope.scoped, hvis.central.logo_x, render.measure_text(2, nil, "APATHYAW").x / 2 + 5, 0.07, nil)
        hvis.central.el_a[1] = main_anim(path.show:get("Clouds"), hvis.central.el_a[1], 255, 0.05, nil, true)
        hvis.central.el_a[2] = main_anim(path.show:get("Logo"), hvis.central.el_a[2], 255, 0.05, nil, true)
        hvis.central.el_a[5] = main_anim(path.show:get("Desync"), hvis.central.el_a[5], 255, 0.05, nil, true)
        hvis.central.el_a[3] = main_anim(path.show:get("Condition"), hvis.central.el_a[3], 255, 0.05, nil, true)
        hvis.central.el_a[4] = main_anim(path.show:get("Binds"), hvis.central.el_a[4], 255, 0.05, nil, true)
        if(hvis.central.el_a[1] > 0) then
            render.text(1, vector(x + hvis.central.clouds_x, y), color(255,255,255,hvis.central.el_a[1] * hvis.central.scope_alpha / 255), "c", "☀️🌤")
            render.text(1, vector(x + hvis.central.clouds_x * 2, y + 10), color(255,255,255,hvis.central.el_a[1] * hvis.central.scope_alpha / 255), "c", "🌥☁️🌦🌧")
        end
        add_y = add_y + 20 * hvis.central.el_a[1] / 255
        for i = 1, #lua.conditions do
            if(hvis.central.cond_x[i] == nil) then
                hvis.central.cond_x[i] = 0
            end
            hvis.central.cond_x[i] = main_anim(hvis.scope.scoped, hvis.central.cond_x[i], render.measure_text(2, f, string.upper(lua.conditions[i])).x / 2 + 5, 0.07, nil)
        end
        if(hvis.central.el_a[2] > 0) then
            if(path.logo_type:get() == "Static") then
                render.text(2, vector(x + hvis.central.logo_x, y + add_y), color(255,255,255,hvis.central.el_a[2] * hvis.central.scope_alpha / 255), "c" .. f, gradient.text("APATHYAW", nil, {f_c, s_c}))
            elseif(path.logo_type:get() == "Invert") then
                if(rage.antiaim:inverter()) then
                    render.text(2, vector(x + hvis.central.logo_x, y + add_y), color(255,255,255,hvis.central.el_a[2] * hvis.central.scope_alpha / 255), "c" .. f, "\a" .. s_c:to_hex() .. "APATH\a" .. f_c:to_hex() .. "YAW")
                else
                    render.text(2, vector(x + hvis.central.logo_x, y + add_y), color(255,255,255,hvis.central.el_a[2] * hvis.central.scope_alpha / 255), "c" .. f, "\a" .. f_c:to_hex() .. "APATH\a" .. s_c:to_hex() .. "YAW")
                end
            elseif(path.logo_type:get() == "Gradient") then
                apathyaw = gradient.text_animate("APATHYAW", -1.5, {f_c, s_c})
                apathyaw:animate()
                render.text(2, vector(x + hvis.central.logo_x, y + add_y), color(255,255,255,hvis.central.el_a[2] * hvis.central.scope_alpha / 255), "c" .. f, apathyaw:get_animated_text())
            end
        end
        add_y = add_y + (render.measure_text(2, nil, "A").y - 4) * hvis.central.el_a[2] / 255
        if(hvis.central.el_a[5] > 0) then
            render.rect(vector(x - render.measure_text(2, nil, "APATHYAW").x / 2 + hvis.central.logo_x, y + add_y - 3), vector(x + render.measure_text(2, nil, "APATHYAW").x / 2 - 1 + hvis.central.logo_x, y + add_y + 2), color(0,0,0,255))
            if(rage.antiaim:inverter()) then
                render.rect(vector(x + hvis.central.logo_x, y + add_y - 2), vector(x + render.measure_text(2, nil, "APATHYAW").x / 2 - 2 + hvis.central.logo_x, y + add_y + 1), s_c)
            else
                render.rect(vector(x - render.measure_text(2, nil, "APATHYAW").x / 2 + 1 + hvis.central.logo_x, y + add_y - 2), vector(x + hvis.central.logo_x, y + add_y + 1), s_c)
            end
        end
        add_y = add_y + 6 * hvis.central.el_a[5] / 255
        if(hvis.central.el_a[3] > 0) then
            render.text(2, vector(x + hvis.central.cond_x[n], y + add_y), color(255,255,255,hvis.central.el_a[3] * hvis.central.scope_alpha / 255), "c" .. f, string.upper(lua.conditions[n]))
        end
        add_y = add_y + (render.measure_text(2, f, string.upper(lua.conditions[n])).y - 4) * hvis.central.el_a[3] / 255
        if(hvis.central.el_a[4] > 0) then
            local binds = ui.get_binds()
            local all_binds = {"Double Tap", "Hide Shots", "Body Aim", "Min. Damage"}
            local bindsn = {
                ["Double Tap"] = "DT",
                ["Hide Shots"] = "OS",
                ["Body Aim"] = "BODY",
                ["Min. Damage"] = "DMG"
            }
            for i = 1, #all_binds do
                if(hvis.central.binds_x[all_binds[i]] == nil) then
                    hvis.central.binds_x[all_binds[i]] = 0
                end
                hvis.central.binds_x[all_binds[i]] = main_anim(hvis.scope.scoped, hvis.central.binds_x[all_binds[i]], render.measure_text(2, f, bindsn[all_binds[i]]).x / 2 + 5, 0.05, nil)
            end
            for i = 1, #binds do
                local bn = binds[#binds - i + 1].reference:name()
                if(bindsn[bn] ~= nil)  then
                    if(hvis.central.binds_a[bn] == nil) then
                        hvis.central.binds_a[bn] = 0
                    end
                    hvis.central.binds_a[bn] = main_anim(binds[#binds - i + 1].active, hvis.central.binds_a[bn], 255, 0.2, nil)
                    if(bn == "Double Tap") then
                        render.text(2, vector(x + hvis.central.binds_x[bn], y + add_y), color(255 - rage.exploit:get() * 255,rage.exploit:get() * 255,0,hvis.central.binds_a[bn] * hvis.central.scope_alpha / 255), "c" .. f, bindsn[bn])
                    else
                        render.text(2, vector(x + hvis.central.binds_x[bn], y + add_y), color(255,255,255,hvis.central.binds_a[bn] * hvis.central.scope_alpha / 255), "c" .. f, bindsn[bn])
                    end
                    add_y = add_y + (render.measure_text(2, f, bindsn[bn]).y - 4 ) * hvis.central.binds_a[bn] / 255
                end
            end
        end
    end
    if(menu.visuals.keybinds:get()) then
        local binds = ui.get_binds()
        local x = menu.visuals.keybinds.x:get()
        local y = menu.visuals.keybinds.y:get()
        local adx = 30
        local w = render.measure_text(1, nil, icons.keybinds .. " keybinds").x + 10
        local h = 18
        local add_y = 0
        local mode = {"[holding]", "[toggled]"}
        local other_add_y = 0
        local mpos = ui.get_mouse_position()
        hvis.binds.alphab = main_anim(#binds > 0 or ui.get_alpha() ~= 0, hvis.binds.alphab, 255, 0.1)
        for i = 1, #binds do
            local bu = binds[#binds - i + 1]
            local biname = bu.name
            for _, ic in pairs(icons) do
                if(string.find(biname, ic)) then
                    biname = biname:gsub(ic, "")
                    if(string.find(biname, theme_color() .. "\aDEFAULT")) then
                        biname = biname:gsub(theme_color() .. "\aDEFAULT", "")
                    end
                    local lval = 0
                    for k = 1, 5 do
                        if(biname:sub(k - 1, k - 1) == " ") then
                            if(k - 1 >= lval) then
                                lval = k - 1
                            end
                        end
                    end
                    biname = biname:sub(lval + 1, string.len(biname))     
                end        
            end
            if(type(bu.value) ~= "boolean") then
                if(type(bu.value) ~= "table") then
                    add_val = "[" .. bu.value .. "]"
                else
                    add_val = json.stringify(bu.value)
                end
            else
                add_val = mode[bu.mode]
            end
            if(render.measure_text(1, nil, biname).x + render.measure_text(1, nil, add_val).x + adx > w) then
                w = render.measure_text(1, nil, biname).x + render.measure_text(1, nil, add_val).x + adx
            end
        end
        hvis.binds.w = main_anim(true, hvis.binds.w, w, 0.1)
        for i = 1, #binds do
            local bu = binds[#binds - i + 1]
            local biname = bu.name
            for _, ic in pairs(icons) do
                if(string.find(biname, ic)) then
                    biname = biname:gsub(ic, "")
                    if(string.find(biname, theme_color() .. "\aDEFAULT")) then
                        biname = biname:gsub(theme_color() .. "\aDEFAULT", "")
                    end
                    local lval = 0
                    for k = 1, 5 do
                        if(biname:sub(k - 1, k - 1) == " ") then
                            if(k - 1 >= lval) then
                                lval = k - 1
                            end
                        end
                    end
                    biname = biname:sub(lval + 1, string.len(biname))     
                end        
            end
            if(hvis.binds.alpha[bu.name] == nil) then
                hvis.binds.alpha[bu.name] = 0
            end
            if(type(bu.value) ~= "boolean") then
                if(type(bu.value) ~= "table") then
                    add_val = "[" .. bu.value .. "]"
                else
                    add_val = json.stringify(bu.value)
                end
            else
                add_val = mode[bu.mode]
            end
            local lenb = string.len(biname)
            hvis.binds.alpha[bu.name] = main_anim(bu.active, hvis.binds.alpha[bu.name], 255, 0.15, nil)
            render.text(1, vector(x + 2, y + 20 + add_y), color(255,255,255,hvis.binds.alpha[bu.name]), nil, biname:sub(math.floor(lenb - hvis.binds.alpha[bu.name] / 255 * lenb), lenb))
            local len = string.len(add_val)
            if(len > 1) then
                render.text(1, vector(x - 2 + hvis.binds.w, y + 20 + add_y), color(255,255,255,hvis.binds.alpha[bu.name] * hvis.binds.alphab / 255), "r", add_val:sub(math.floor(len - hvis.binds.alpha[bu.name] / 255 * len), len))
            else
                render.text(1, vector(x - 2 + hvis.binds.w, y + 20 + add_y), color(255,255,255,hvis.binds.alpha[bu.name] * hvis.binds.alphab / 255), "r", add_val)
            end
            add_y = add_y + render.measure_text(1, nil, "Double Tap").y * hvis.binds.alpha[bu.name] / 255
        end
        render_box(x, y, hvis.binds.w, h, hvis.binds.alphab)   
        render.text(1, vector(x + hvis.binds.w / 2, y + h / 2), color(255,255,255,hvis.binds.alphab), "c", icons.keybinds .. " keybinds")
        if(ui.get_alpha() == 1) then
            if(common.is_button_down(0x01)) then
                if(mpos.x > x and mpos.x < x + hvis.binds.w and mpos.y > y - 5 and mpos.y < y + 24) then
                    hvis.binds.drugging = true
                end
            else
                hvis.binds.drugging = false
            end
        else
            hvis.binds.drugging = false
        end
        if(hvis.binds.drug ~= hvis.binds.drugging) then
            hvis.binds.add_x_m = mpos.x - x
            hvis.binds.add_y_m = mpos.y - y
            hvis.binds.drug = hvis.binds.drugging
        end
        if(hvis.binds.drugging) then
            menu.visuals.keybinds.x:set(mpos.x - hvis.binds.add_x_m)
            menu.visuals.keybinds.y:set(mpos.y - hvis.binds.add_y_m)
        end
    end
    if(menu.visuals.spectators:get()) then
        local add_y = 0
        if(entity.get_local_player() ~= nil) then
            local l_specs = entity.get_local_player():get_spectators()
            if(l_specs ~= nil and #l_specs > 0) then
                for i = 1, #entity.get_local_player():get_spectators() do
                    add_y = add_y + render.measure_text(1, nil, entity.get_local_player():get_spectators()[i]).y + 2
                    render.text(1, vector(render.screen_size().x - 5, add_y), color(255,255,255,255), "r", l_specs[i]:get_name())
                end
            end
        end
    end
    if(menu.misc.manual_arrows:get()) then
        local x, y = render.screen_size().x / 2, render.screen_size().y / 2
        local desync_color = menu.misc.manual_arrows.desync_color:get()
        local manual_color = menu.misc.manual_arrows.manual_color:get()
        local rev = menu.misc.manual_arrows.reverse:get()
        if(menu.misc.manual_arrows.dynamic:get() > 0 and lp ~= nil) then
            add_x = rev and -54 + get_velocity(lp) / 60 * menu.misc.manual_arrows.dynamic:get() or 45 + get_velocity(lp) / 60 * menu.misc.manual_arrows.dynamic:get()
        else
            add_x = rev and -54 or 45
        end
        local ac = menu.misc.manual_arrows.accent_color:get()
        if(menu.misc.manual_arrows.style:get() == "Teamskeet") then
            render.poly(color(0,0,0,100), vector(x + add_x + 1, y - 8), vector(x + add_x + 12, y), vector(x + add_x + 1, y + 8))
            render.rect(vector(x + add_x - 2, y - 8), vector(x + add_x, y + 8), color(0,0,0,100))
    
            render.poly(color(0,0,0,100), vector(x - add_x, y - 8), vector(x - add_x - 11, y), vector(x - add_x, y + 8))
            render.rect(vector(x - add_x + 1, y - 8), vector(x - add_x + 3, y + 8), color(0,0,0,100))
            if(rage.antiaim:inverter()) then
                render.rect(vector(x - add_x + 1, y - 8), vector(x - add_x + 3, y + 8), desync_color)
            else
                render.rect(vector(x + add_x - 2, y - 8), vector(x + add_x, y + 8), desync_color)
            end
            if(rev) then
                if(menu.aaf.yaw_base:get() == icons.right .. " Right") then
                    render.poly(manual_color, vector(x - add_x, y - 8), vector(x - add_x - 11, y), vector(x - add_x, y + 8))
                elseif(menu.aaf.yaw_base:get() == icons.left .. " Left") then
                    render.poly(manual_color, vector(x + add_x + 1, y - 8), vector(x + add_x + 12, y), vector(x + add_x + 1, y + 8))
                end
            else
                if(menu.aaf.yaw_base:get() == icons.left .. " Left") then
                    render.poly(manual_color, vector(x - add_x, y - 8), vector(x - add_x - 11, y), vector(x - add_x, y + 8))
                elseif(menu.aaf.yaw_base:get() == icons.right .. " Right") then
                    render.poly(manual_color, vector(x + add_x + 1, y - 8), vector(x + add_x + 12, y), vector(x + add_x + 1, y + 8))
                end
            end     
        else
            render.text(verdanaar, vector(x + add_x, y), color(100,100,100,200), "c", ">")
            render.text(verdanaar, vector(x - add_x + 2, y), color(100,100,100,200), "c", "<")
            if(rev) then
                if(menu.aaf.yaw_base:get() == icons.right .. " Right") then
                    render.text(verdanaar, vector(x - add_x + 2, y), ac, "c", "<")
                elseif(menu.aaf.yaw_base:get() == icons.left .. " Left") then
                    render.text(verdanaar, vector(x + add_x, y), ac, "c", ">")
                end
            else
                if(menu.aaf.yaw_base:get() == icons.left .. " Left") then
                    render.text(verdanaar, vector(x - add_x + 2, y), ac, "c", "<")
                elseif(menu.aaf.yaw_base:get() == icons.right .. " Right") then
                    render.text(verdanaar, vector(x + add_x, y), ac, "c", ">")
                end
            end     
        end
    end
    if(menu.misc.damage:get()) then
        local binds = ui.get_binds()
        local x = render.screen_size().x / 2 + menu.misc.damage.x:get()
        local y = render.screen_size().y / 2 + menu.misc.damage.y:get()
        if(menu.misc.damage.font:get() == "Default") then
            f = 1
        elseif(menu.misc.damage.font:get() == "Small") then
            f = 2
        elseif(menu.misc.damage.font:get() == "Console") then
            f = 3
        elseif(menu.misc.damage.font:get() == "Bold") then
            f = 4
        end
        for i = 1, #binds do
            if(binds[i].reference:name() == "Min. Damage" and binds[i].active) then
                render.text(f, vector(x, y), menu.misc.damage.color:get(), nil, binds[i].value)
            end
        end
    end
end

local lc_mass = {}
local render_lc_mass = {}

function on_die()
    lc_mass = {}
    render_lc_mass = {}
end

events.player_death:set(on_die)

function lagcomp()
    if(menu.mods.lagcomp:get()) then
        local entes = entity.get_players()
        local lp = entity.get_local_player()
        if(lp == nil or lp.m_iHealth <= 0) then return end
        if(#lc_mass ~= #entes) then
            render_lc_mass = {}
        end
        for i, ents in ipairs(entes) do
            if(ents == nil or ents.m_iTeamNum == lp.m_iTeamNum or ents:is_dormant()) then goto skip end
            if(lc_mass.ents == nil or ents.m_iHealth <= 0) then
                lc_mass.ents = {}
            end
            if(ents ~= nil) then
                table.insert(lc_mass.ents, ents.m_flSimulationTime)
                if(#lc_mass.ents > 38) then
                    table.remove(lc_mass.ents, 1)
                end
                if(lc_mass.ents ~= nil) then
                    local count = 1
                    for i = 1, 38 do
                        if(lc_mass.ents[#lc_mass.ents] == lc_mass.ents[#lc_mass.ents - i]) then
                            count = i
                        end
                    end
                    if(lc_mass.ents[#lc_mass.ents] ~= lc_mass.ents[#lc_mass.ents - 24]) then
                        count = 1
                    end
                    if(count >= 24) then
                        table.insert(render_lc_mass, {ents, globals.realtime})
                    end
                end
            end
            ::skip::
        end
        for i = 1, #render_lc_mass do
            if(render_lc_mass[i] ~= nil and render_lc_mass[i][1] ~= nil and render_lc_mass[i][2] ~= nil) then
                local epos = render_lc_mass[i][1].m_vecOrigin
                if(globals.realtime - render_lc_mass[i][2] <= 1 / 64 * 14) then
                    render.line(render.world_to_screen(epos), render.world_to_screen(extrapolate_pos(epos.x - 15, epos.y - 15, epos.z, 14, render_lc_mass[i][1])), color(47, 117, 221,255))
                    local cords = extrapolate_pos(epos.x, epos.y, epos.z, 14, render_lc_mass[i][1])
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z)), render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z)), render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z)), render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z)), render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z)), color(47, 117, 221,255))
    
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z + 70)), render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z + 70)), render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z + 70)), render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z + 70)), render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z + 70)), color(47, 117, 221,255))
    
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z)), render.world_to_screen(vector(cords.x - 15, cords.y - 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z)), render.world_to_screen(vector(cords.x - 15, cords.y + 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z)), render.world_to_screen(vector(cords.x + 15, cords.y - 15, cords.z + 70)), color(47, 117, 221,255))
                    render.line(render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z)), render.world_to_screen(vector(cords.x + 15, cords.y + 15, cords.z + 70)), color(47, 117, 221,255))
                end
            end
        end
    else
        lc_mass = {}
        render_lc_mass = {}
    end
end

function on_shot(e)
    if(menu.misc.logs:get()) then
        if(e.state == nil and menu.misc.logs.events:get("Hits")) then
            local ac = "\a" .. menu.misc.logs.hit_color:get():to_hex():sub(1, 6)
            local hitbox = lua.hitgroup_mass[e.hitgroup + 1]
            text = "\aFFFFFFRegistered shot in " .. ac .. e.target:get_name() .. "'s " .. hitbox .. "\aFFFFFF for " .. ac .. e.damage .. "\aFFFFFF (" .. ac .. e.target.m_iHealth .. " hp remaining\aFFFFFF) (" .. ac .. e.wanted_damage .. "\aFFFFFF) [hitchance: " .. e.hitchance .. " | backtrack: " .. e.backtrack .. "]"
            nc = "Registered shot in " .. e.target:get_name() .. "'s " .. hitbox .. " for " .. e.damage .. " (" .. e.target.m_iHealth .. " hp remaining) (" .. e.wanted_damage .. ") [hitchance: " .. e.hitchance .. " | backtrack: " .. e.backtrack .. "]"
            if(menu.misc.logs.output:get("Console")) then
                print_raw(ac .. "[Apathyaw] " ..  text)
            end
            if(menu.misc.logs.output:get("Up of screen")) then
                print_dev(nc)
            end
            if(menu.misc.logs.output:get("Screen")) then
                table.insert(lua.logs, 1, {t = "Hit", n = "Hit " .. ac .. "FF" .. e.target:get_name() .. "\aDEFAULT for " .. ac .. "FF" .. e.damage .. " damage \aDEFAULT(" .. ac .. "FF" .. e.target.m_iHealth .. " hp remaining\aDEFAULT)", alpha = 0, time = globals.realtime})
            end
        end
        if(e.state ~= nil and menu.misc.logs.events:get("Misses")) then
            local ac = "\a" .. menu.misc.logs.miss_color:get():to_hex():sub(1, 6)
            local hitbox = lua.hitgroup_mass[e.wanted_hitgroup + 1]
            if(e.state == "correction") then
                reas = "resolver"
            elseif(e.state == "misprediction") then
                reas = "jitter resolver"
            else
                reas = e.state
            end
            text = "\aFFFFFFMissed shot in " .. ac .. e.target:get_name() .. "'s " .. hitbox .. "\aFFFFFF due to " .. ac .. reas ..  "\aFFFFFF [wanted damage: " .. e.wanted_damage .. " | backtrack: " .. e.backtrack .. " | hitchance: " .. e.hitchance .. "]"
            nc = "Missed shot in " .. e.target:get_name() .. "'s " .. hitbox .. " due to " .. reas .. " [wanted damage: " .. e.wanted_damage .. " | backtrack: " .. e.backtrack .. " | hitchance: " .. e.hitchance .. "]"
            if(menu.misc.logs.output:get("Console")) then
                print_raw(ac .. "[Apathyaw] " ..  text)
            end
            if(menu.misc.logs.output:get("Up of screen")) then
                print_dev(nc)
            end
            if(menu.misc.logs.output:get("Screen")) then
                table.insert(lua.logs, 1, {t = "Miss", n = "Missed shot due to " .. ac .. "FF" .. reas, alpha = 0, time = globals.realtime})
            end
        end
    end
end

function on_buy(e)
    if(menu.misc.logs:get() and menu.misc.logs.events:get("Buys")) then
        local player = entity.get(e.userid, true)
        if(player == nil or player == entity.get_local_player()) then return end
        local ac = "\a" .. menu.misc.logs.misc_color:get():to_hex():sub(1, 6)
        if(menu.misc.logs.output:get("Console")) then
            print_raw(ac .. player:get_name() .. " bought " .. e.weapon)
        end
        if(menu.misc.logs.output:get("Up of screen")) then
            print_dev(player:get_name() .. " bought " .. e.weapon)
        end
    end
end

function render_logs()
    local add_y = 0
    hvis.preview_logs = main_anim(#lua.logs == 0 and menu.misc.logs:get() and menu.misc.logs.log_preview:get() and menu.misc.logs.output:get("Screen") and ui.get_alpha() > 0 and menu.misc.logs.output:get("Screen"), hvis.preview_logs, 255, 0.2)
    if(menu.misc.logs:get() and menu.misc.logs.output:get("Screen")) then
        local x = render.screen_size().x / 2
        local y = render.screen_size().y / 2 + render.screen_size().y / 3.6
        for i, logs in ipairs(lua.logs) do
            if(globals.realtime - logs.time < 1) then
                logs.alpha = main_anim(true, logs.alpha, 255, 0.1)
            end
            if(globals.realtime - logs.time > 3) then
                logs.alpha = main_anim(false, logs.alpha, 255, 0.1)
                if(logs.alpha == 0) then
                    table.remove(lua.logs, i)
                end
            end
            if(menu.misc.logs.enable_color:get()) then
                g_c = menu.misc.logs.glow_color:get()
            else
                if(logs.t == "Miss") then
                    g_c = menu.misc.logs.miss_color:get()
                elseif(logs.t == "Hit") then
                    g_c = menu.misc.logs.hit_color:get()
                elseif(logs.t == "Misc") then
                    g_c = menu.misc.logs.misc_color:get()
                end
            end
            local size = render.measure_text(1, nil, logs.n).x
            render.shadow(vector(x - size / 2, y + add_y), vector(x + size / 2, y + add_y), color(g_c.r, g_c.g, g_c.b, menu.misc.logs.glow:get() * 2.55 * logs.alpha / 255))
            render.text(1, vector(x, y + add_y), color(255,255,255,logs.alpha), "c", logs.n)
            add_y = add_y + 14 * logs.alpha / 255
            if(#lua.logs > 8) then
                lua.logs[#lua.logs].alpha = main_anim(false, lua.logs[#lua.logs].alpha, 0, 0.1, nil)
                if(math.floor(lua.logs[#lua.logs].alpha) <= 0.1) then
                    table.remove(lua.logs, #lua.logs)
                end
            end
        end
    end
    if(hvis.preview_logs > 0) then
        local x = render.screen_size().x / 2
        local y = render.screen_size().y / 2 + render.screen_size().y / 3.6
        local addp = 0
        if(menu.misc.logs.enable_color:get()) then
            miss_c = menu.misc.logs.glow_color:get()
            hit_c = menu.misc.logs.glow_color:get()
            misc_c = menu.misc.logs.glow_color:get()
        else
            miss_c = menu.misc.logs.miss_color:get()
            hit_c = menu.misc.logs.hit_color:get()
            misc_c = menu.misc.logs.misc_color:get()
        end
        if(menu.misc.logs.events:get("Hits")) then
            local ac = "\a" .. menu.misc.logs.hit_color:get():to_hex():sub(1, 6)
            local n = "Hit " .. ac .. "FF" .. "конвульсив еблан" .. "\aDEFAULT for " .. ac .. "FF" .. "55" .. " damage \aDEFAULT(" .. ac .. "FF" .. "45" .. " hp remaining\aDEFAULT)"
            local size = render.measure_text(1, nil, n).x
            render.shadow(vector(x - size / 2, y + addp), vector(x + size / 2, y + addp), color(hit_c.r, hit_c.g, hit_c.b, menu.misc.logs.glow:get() * 2.55 * hvis.preview_logs / 255))
            render.text(1, vector(x, y + addp), color(255,255,255,hvis.preview_logs), "c", n)
            addp = addp + 14
        end
        if(menu.misc.logs.events:get("Misses")) then
            local ac = "\a" .. menu.misc.logs.miss_color:get():to_hex():sub(1, 6)
            local n = "Missed shot due to " .. ac .. "FF" .. "resolver"
            local size = render.measure_text(1, nil, n).x
            render.shadow(vector(x - size / 2, y + addp), vector(x + size / 2, y + addp), color(miss_c.r, miss_c.g, miss_c.b, menu.misc.logs.glow:get() * 2.55 * hvis.preview_logs / 255))
            render.text(1, vector(x, y + addp), color(255,255,255,hvis.preview_logs), "c", n)
            addp = addp + 14
        end
        if(menu.misc.logs.events:get("Anti-bruteforce")) then
            local ac = "\a" .. menu.misc.logs.misc_color:get():to_hex():sub(1, 6)
            local n = ac .. "FF[+] Switched Anti-bruteforce phase due to enemy shot [1]"
            local size = render.measure_text(1, nil, n).x
            render.shadow(vector(x - size / 2, y + addp), vector(x + size / 2, y + addp), color(misc_c.r, misc_c.g, misc_c.b, menu.misc.logs.glow:get() * 2.55 * hvis.preview_logs / 255))
            render.text(1, vector(x, y + addp), color(255,255,255,hvis.preview_logs), "c", n)
            addp = addp + 14
        end
    end
end

function rendering()
    visuals()
    render_ragebot()
    render_logs()
    lagcomp()
end

function createmoving(cmd)
    anti_aim(cmd)
    ragebot(cmd)
end

events.item_purchase:set(on_buy)
events.bullet_impact:set(anti_brute)
events.enter_bombzone:set(enter_bombzone)
events.exit_bombzone:set(exit_bombzone)
events.createmove:set(createmoving)
events.aim_ack:set(on_shot)
events.render:set(rendering)

pui.setup({menu.aaf, menu.aa, menu.mods, menu.visuals, menu.rage, menu.misc})