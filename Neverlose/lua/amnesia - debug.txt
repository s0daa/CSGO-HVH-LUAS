_DEBUG = true
local gradient = require("neverlose/gradient")
local base64 = require("neverlose/base64")
local pui = require("neverlose/pui")
local clipboard = require("neverlose/clipboard")
local ease = require("neverlose/easing")
local callbacks = {}
local file = require("neverlose/file")

function theme_color()
    return "\aBA90C0FF"
end

local default_config = {author = {"admin"},date = {"14/05 16:14"},n = {"default"},cfg = {"W1t0cnVlXSx7ImJ1aWxkZXJfZWxlbWVudHMiOnsiYWlyIjp7ImFhX3NwZWVkIjo4LjAsImJvZHlfeWF3IjpmYWxzZSwiZW5hYmxlIjpmYWxzZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaml0dGVyIjoiZGlzYWJsZWQiLCJ5YXdfY2VudGVyIjowLjAsInlhd19qaXR0ZXJfb3ZyIjowLjAsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoic3RhdGljIiwieWF3X3JpZ2h0IjowLjB9LCJhaXIgY3JvdWNoIjp7ImFhX3NwZWVkIjo4LjAsImJvZHlfeWF3IjpmYWxzZSwiZW5hYmxlIjpmYWxzZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaml0dGVyIjoiZGlzYWJsZWQiLCJ5YXdfY2VudGVyIjowLjAsInlhd19qaXR0ZXJfb3ZyIjowLjAsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoic3RhdGljIiwieWF3X3JpZ2h0IjowLjB9LCJjcm91Y2giOnsiYWFfc3BlZWQiOjguMCwiYm9keV95YXciOmZhbHNlLCJlbmFibGUiOmZhbHNlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJqaXR0ZXIiOiJkaXNhYmxlZCIsInlhd19jZW50ZXIiOjAuMCwieWF3X2ppdHRlcl9vdnIiOjAuMCwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJzdGF0aWMiLCJ5YXdfcmlnaHQiOjAuMH0sImNyb3VjaCBtb3ZpbmciOnsiYWFfc3BlZWQiOjguMCwiYm9keV95YXciOmZhbHNlLCJlbmFibGUiOmZhbHNlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJqaXR0ZXIiOiJkaXNhYmxlZCIsInlhd19jZW50ZXIiOjAuMCwieWF3X2ppdHRlcl9vdnIiOjAuMCwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJzdGF0aWMiLCJ5YXdfcmlnaHQiOjAuMH0sInJ1biI6eyJhYV9zcGVlZCI6OC4wLCJib2R5X3lhdyI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaml0dGVyIjoiZGlzYWJsZWQiLCJ5YXdfY2VudGVyIjo5Ny4wLCJ5YXdfaml0dGVyX292ciI6MC4wLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6InN0YXRpYyIsInlhd19yaWdodCI6MC4wfSwic2xvdyI6eyJhYV9zcGVlZCI6OC4wLCJib2R5X3lhdyI6ZmFsc2UsImVuYWJsZSI6dHJ1ZSwiZmFrZV9vcHRpb25zIjpbIn4iXSwiaml0dGVyIjoiZGlzYWJsZWQiLCJ5YXdfY2VudGVyIjotOTcuMCwieWF3X2ppdHRlcl9vdnIiOjAuMCwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJzdGF0aWMiLCJ5YXdfcmlnaHQiOjAuMH0sInN0YW5kIjp7ImFhX3NwZWVkIjo4LjAsImJvZHlfeWF3IjpmYWxzZSwiZW5hYmxlIjp0cnVlLCJmYWtlX29wdGlvbnMiOlsifiJdLCJqaXR0ZXIiOiJkaXNhYmxlZCIsInlhd19jZW50ZXIiOi05Ny4wLCJ5YXdfaml0dGVyX292ciI6MC4wLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6InN0YXRpYyIsInlhd19yaWdodCI6MC4wfX0sInN0YXRlX2xpc3QiOjMuMH0seyJkaXNhYmxlX29uX25hZGUiOlsifiJdLCJmc19zdGF0aWMiOlsifiJdLCJtYW51YWxfYWFfc3RhdGUiOiItIiwibWFudWFsX2FhX3N0YXRpYyI6WyJ+Il0sIm1pc2NfdCI6eyJmYXN0X2ZhbGwiOmZhbHNlLCJmYXN0X2xhZGRlciI6ZmFsc2UsImxhZGRlcl95YXdfY2hlY2tib3giOmZhbHNlLCJsYWRkZXJfeWF3X3NsaWRlciI6MC4wLCJuYWRlX2JpbmQiOmZhbHNlLCJuYWRlX3NsaWRlciI6MTAuMCwibmFkZV9zd2FwIjpmYWxzZSwib3B0aW9ucyI6WyJ+Il0sInNtb2tlX3dhcm4iOmZhbHNlLCJ0ZWxlcG9ydF9vbl9oaXQiOmZhbHNlLCJ3X2FjY2VudCI6IiNGRkZGRkZGRiIsIndfYmdjbHIiOiIjRkZGRkZGRkYiLCJ3aW5nbWFuX2hlbHAiOmZhbHNlfSwicHJlc2V0c19saXN0IjoxLjAsInNlbGVjdF9leHRyYSI6MS4wLCJzZWxlY3RfdGV4dF9hayI6ZmFsc2UsInNlbGVjdF90ZXh0X2RmIjpmYWxzZSwic2VsZWN0X3RleHRfZnMiOmZhbHNlLCJzZWxlY3RfdGV4dF9tYW51YWwiOmZhbHNlLCJ2aXN1YWxzIjp7ImVuYWJsZV9pbmRzIjpmYWxzZX19XQ=="}}

files.create_folder("csgo/amnesia")
if(files.read('csgo/amnesia/cfg.txt') == nil) then
    files.write('csgo/amnesia/cfg.txt', json.stringify(default_config))
end

local config_data = json.parse(files.read('csgo/amnesia/cfg.txt'))

local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)
        if not s then
            local retmessage = "safe call failed [" .. name .. "] -> " .. ret
            if report then
                print(retmessage)
            end
            return false, retmessage
        else
            return ret, s
        end
    end
end

callbacks.register = function(event, name, fn)
    events[event]:set(safecall(name, event ~= "shutdown", fn))
end

local references={
    doubletap=ui.find("aimbot","ragebot","main","double tap"),
    hideshots=ui.find("Aimbot","Ragebot","Main","Hide Shots"),
    fakeduck=ui.find("Aimbot","Anti Aim","Misc","Fake Duck"),
    delayshot=ui.find("Aimbot", "Ragebot", "Selection", "Global", "Min. Damage", "Delay Shot"),
    pitch=ui.find("Aimbot","Anti Aim","Angles","Pitch"),
    offset=ui.find("Aimbot","Anti Aim","Angles","Yaw","Offset"),
    yaw=ui.find("Aimbot","Anti Aim","Angles","Yaw"),
    modifier=ui.find("Aimbot","Anti Aim","Angles","Yaw Modifier"),
    moffset=ui.find("Aimbot","Anti Aim","Angles","Yaw Modifier","Offset"),
    limit1=ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Left Limit"),
    limit2=ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Right Limit"),
    freestand=ui.find("Aimbot","Anti Aim","Angles","Freestanding"),
    antistab=ui.find("Aimbot","Anti Aim","Angles","Yaw","Avoid Backstab"),
    bodyyaw=ui.find("Aimbot","Anti Aim","Angles","Body Yaw"),
    roll=ui.find("Aimbot","Anti Aim","Angles","Extended Angles"),
    rollval=ui.find("Aimbot","Anti Aim","Angles","Extended Angles","Extended Roll"),
    airstrafe=ui.find("Miscellaneous","Main","Movement","Air Strafe"),
    legmov=ui.find("Aimbot","Anti Aim","Misc","Leg Movement"),
    slowwalk=ui.find("Aimbot","Anti Aim","Misc","Slow Walk"),
    lagoptions=ui.find("Aimbot","Ragebot","Main","Double Tap","Lag Options"),
    fakelag=ui.find("Aimbot","Anti Aim","Fake Lag","Limit"),
    asoptions=ui.find("Aimbot","Ragebot","Accuracy","Auto Stop","Options"),
    asdtoptions=ui.find("Aimbot","Ragebot","Accuracy","Auto Stop","Double Tap")
}

events.render:set(function(ctx)
    local hello = ui.get_style("Link Active")

    local gradient_animation = gradient.text_animate("amnesia.lol", -1, {
        hello, 
        color(186,144,192)
    })
    
    ui.sidebar(gradient_animation:get_animated_text(), "🦽")
    gradient_animation:animate()
end)

local function color_as_string(r, g, b, a)
    return ("\a%02X%02X%02X%02X"):format(r, g, b, a)
end

local icons = {
    home = ui.get_icon("house-user"),
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

local tabs = {
    info = {
        logo = pui.create(theme_color() .. icons.home.." Home", theme_color() .. "WELCOME"),
        home = pui.create(theme_color() .. icons.home.." Home", theme_color() .. "HOME"),
        placehold = pui.create(theme_color() .. icons.home.." Home", theme_color() .. " "),
        configs = pui.create(theme_color() .. icons.home.." Home", theme_color() .. "CONFIGS"),
    },
    aa = {
        preset = pui.create(theme_color() .. icons.aa.." Anti-aim", theme_color() .. "PRESETS"),
        extra = pui.create(theme_color() .. icons.aa.." Anti-aim", theme_color() .. "EXTRA"),
        aa_build = pui.create(theme_color() .. icons.aa.." Anti-aim", theme_color() .. "ANTI-AIM"),
        cond = pui.create(theme_color() .. icons.aa.." Anti-aim", theme_color() .. "CONDITIONS"),
    },
    misc = {
        vis = pui.create(theme_color() .. icons.gear.." Extra", theme_color() .. "VISUALS"),
        misc = pui.create(theme_color() .. icons.gear.." Extra", theme_color() .. "MISC"),
    },
}

local aa_lol={delta=0,builder={conditions={"stand","run","slow","crouch","crouch moving","air","air crouch"}},manual_state=0,state="NONE"}

local menu = {
    home = {
        tabs.info.logo:texture(render.load_image(network.get("https://cdn.discordapp.com/attachments/1022219770604572717/1099841351744503838/Untitled-3-moreglow.png"), vector(270, 270)), vector(270, 270), color(255, 255, 255, 255), 'f'),
        tabs.info.home:label("\aFFFFFFFFwelcome \aBA90C0FF"..common.get_username()..'\aFFFFFFFF ~ version \aBA90C0FFnightly'),
        tabs.info.home:label("\aBA90C0FFamnesia\aFFFFFFFF.lol has finally arrived to neverlose. this is the original and only script"),
        tabs.info.home:label("\aFFFFFFFFlast update ~ \aBA90C0FF13.05.2023 21:28"),
        discord_button = tabs.info.home:button(ui.get_icon("house-user").." join amnesia discord!", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@hellboyhvh?sub_confirmation=1")
        end, true),
        tabs.info.home:switch(ui.get_icon("slack").." reveal other amnesia users", true),
    },

    aa_builder = {
        antiaim_condition = tabs.aa.aa_build,
        state_list = tabs.aa.cond:list("anti-aim state",aa_lol.builder.conditions)
    },
    
    vis_c = {},
    
    config_system = {
        cfg_list = tabs.info.configs:list("config system:", config_data.n),
        cfg_info = tabs.info.configs:label("author: " .. theme_color() .. "\n" .. "config update: " .. theme_color()),
        cfg_name = tabs.info.configs:input("config name", ""),
        load_cfg = tabs.info.configs:button(theme_color() .. ui.get_icon("file-arrow-up") .. "\aDEFAULT load", function()
            f_load_cfg()
        end, true),
        create_cfg = tabs.info.configs:button(theme_color() .. ui.get_icon("plus") .. "\aDEFAULT create", function()
            f_create_cfg()
        end, true),
        save_cfg = tabs.info.configs:button(theme_color() .. ui.get_icon("floppy-disk") .. "\aDEFAULT save", function()
            f_save_cfg()
        end, true),
        delete_cfg = tabs.info.configs:button(theme_color() .. ui.get_icon("trash") .. "\aDEFAULT delete", function()
            f_remove_cfg()
        end, true),
        cfg_import = tabs.info.configs:button(theme_color() .. ui.get_icon("file-import") .. "\aDEFAULT import config", function()
            f_import_cfg()
        end, true),
        cfg_export = tabs.info.configs:button(theme_color() .. ui.get_icon("file-export") .. "\aDEFAULT export config", function()
            f_export_cfg()
        end, true),
    },
}

menu.aa_builder.menu_handler = function()
    local element_handling = {}

    for _, v in pairs(aa_lol.builder.conditions) do
        
        element_handling[v] = {}

        element_handling[v].enable = menu.aa_builder.antiaim_condition:switch("enable • \aBA90C0FF"..v)
        element_handling[v].yaw_mode = menu.aa_builder.antiaim_condition:combo("yaw mode\n"..v,{"static", "l • r", "async yaw", "slow yaw", "gravity yaw"})
        element_handling[v].yaw_center = menu.aa_builder.antiaim_condition:slider("yaw°\n"..v,-180,180,0)
        element_handling[v].yaw_left = menu.aa_builder.antiaim_condition:slider("yaw • left°\n"..v,-180,180,0)
        element_handling[v].yaw_right = menu.aa_builder.antiaim_condition:slider("yaw • right°\n"..v,-180,180,0)
        element_handling[v].aa_speed = menu.aa_builder.antiaim_condition:slider("speed°\n"..v,1,14,8)
        element_handling[v].space_1 = menu.aa_builder.antiaim_condition:label("\n")
        element_handling[v].jitter = menu.aa_builder.antiaim_condition:combo("yaw modifer\n"..v,{"disabled","center","offset","gravity","algorithm"})
        element_handling[v].yaw_jitter_ovr = menu.aa_builder.antiaim_condition:slider("jitter°\n"..v,-180,180,0)
        element_handling[v].space_2 = menu.aa_builder.antiaim_condition:label("\n")
        element_handling[v].body_yaw = menu.aa_builder.antiaim_condition:switch("body yaw\n"..v,false)
        element_handling[v].fake_options = menu.aa_builder.antiaim_condition:selectable("fake options\n"..v,{"avoid overlap","jitter","randomize jitter","anti bruteforce"})
    
    end

    menu.aa_builder.builder_elements = element_handling
end

menu.aa_builder.menu_handler()

menu.config_system.cfg_list:update(config_data.n)
menu.config_system.cfg_info.ref:name("author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])

menu.config_system.cfg_list:set_callback(function()
    menu.config_system.cfg_list:update(config_data.n)
    menu.config_system.cfg_info.ref:name("author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
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
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
    files.write('csgo/amnesia/cfg.txt', json.stringify(config_data))
end

function f_load_cfg()
    if(menu.config_system.cfg_list:get() == 1) then
        if(string.find(network.get("https://pastebin.com/raw/zgGD8WuP"), "forbidden")) then
            common.add_notify("CFG", "wait, hosting is unavailable now")
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
    menu.config_system.cfg_info.ref:name("author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
    files.write('csgo/amnesia/cfg.txt', json.stringify(config_data))
end

function f_create_cfg()
    local date_cfg = common.get_date("%m.%d.%Y %H:%M")
    local cfg = base64.encode(json.stringify(pui.save()))
    print(pui.save())
    local author = common.get_username()
    local name = menu.config_system.cfg_name:get()
    if(name ~= " " and not locate(config_data.n, name)) then
        table.insert(config_data.n, name)
        table.insert(config_data.cfg, cfg)
        table.insert(config_data.author, author)
        table.insert(config_data.date, date_cfg)
        files.write('csgo/amnesia/cfg.txt', json.stringify(config_data))
    end
    menu.config_system.cfg_list:update(config_data.n)
    menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get()] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get()])
end

function f_remove_cfg()
    if(menu.config_system.cfg_list:get() ~= 1) then
        table.remove(config_data.n, menu.config_system.cfg_list:get())
        table.remove(config_data.author, menu.config_system.cfg_list:get())
        table.remove(config_data.cfg, menu.config_system.cfg_list:get())
        table.remove(config_data.date, menu.config_system.cfg_list:get())
        files.write('csgo/amnesia/cfg.txt', json.stringify(config_data))
        menu.config_system.cfg_list:update(config_data.n)
        menu.config_system.cfg_info.ref:name("Author: " .. theme_color() .. config_data.author[menu.config_system.cfg_list:get() - 1] .. "\n\aDEFAULT" .. "last update: " .. theme_color() .. config_data.date[menu.config_system.cfg_list:get() - 1])
    end
end

local aa={
    pitch=ui.find("Aimbot","Anti Aim","Angles","Pitch"),
    yaw=ui.find("Aimbot","Anti Aim","Angles","Yaw"),
    base=ui.find("Aimbot","Anti Aim","Angles","Yaw","Base"),
    offset=ui.find("Aimbot","Anti Aim","Angles","Yaw","Offset"),
    backstab=ui.find("Aimbot","Anti Aim","Angles","Yaw","Avoid Backstab"),
    jitter=ui.find("Aimbot","Anti Aim","Angles","Yaw Modifier"),
    jitter_val=ui.find("Aimbot","Anti Aim","Angles","Yaw Modifier","Offset"),
    body_yaw={ui.find("Aimbot","Anti Aim","Angles","Body Yaw"),
    ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Inverter"),
    ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Left Limit"),
    ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Right Limit"),
    ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Options"),
    ui.find("Aimbot","Anti Aim","Angles","Body Yaw","Freestanding")},
    freestand={ui.find("Aimbot","Anti Aim","Angles","Freestanding"),
    ui.find("Aimbot","Anti Aim","Angles","Freestanding","Disable Yaw Modifiers"),
    ui.find("Aimbot","Anti Aim","Angles","Freestanding","Body Freestanding")},
    def=ui.find("Aimbot","Ragebot","Main","Double Tap","Lag Options"),
    slow=ui.find("Aimbot","Anti Aim","Misc","Slow Walk")
}

menu.vis_c.presets_list = tabs.aa.preset:list("preset manager", {"😎 • conditional", "🥳 • hybrid", "🤯 • alpha"}, 3)

menu.vis_c.select_text_manual = tabs.aa.extra:switch("enable ~ \aBA90C0FFmanual aa")
menu.vis_c.manual_aa_state = menu.vis_c.select_text_manual:create():combo("bind ! 'on hold'", {"-", "left", "right", "forward"})
menu.vis_c.manual_aa_static = menu.vis_c.select_text_manual:create():listable("manual aa options", {"static manuals", "freestanding body"}, 2)

menu.vis_c.select_text_fs = tabs.aa.extra:switch("enable ~ \aBA90C0FFfreestanding")
menu.vis_c.fs_static = menu.vis_c.select_text_fs:create():listable("freestand options", "static", "freestanding body")

menu.vis_c.select_text_df = tabs.aa.extra:switch("enable ~ \aBA90C0FFdefensive")
menu.vis_c.disable_on_nade = menu.vis_c.select_text_df:create():listable("defensive options", {"disable on pin pulled", "dynamic speed"}, 2)

menu.vis_c.select_text_ak = tabs.aa.extra:switch("enable ~ \aBA90C0FFanti-knife")

menu.vis_c.select_extra = tabs.aa.extra:list("", { "manual aa", "freestanding", "defensive", "anti-knife" }, 4)

events.render:set(function(ctx)
    
    if menu.vis_c.select_extra:get() == 1 then
        menu.vis_c.select_text_manual:visibility(true)
        menu.vis_c.select_text_fs:visibility(false)
        menu.vis_c.select_text_df:visibility(false)
        menu.vis_c.select_text_ak:visibility(false)
    elseif menu.vis_c.select_extra:get() == 2 then
        menu.vis_c.select_text_fs:visibility(true)
        menu.vis_c.select_text_manual:visibility(false)
        menu.vis_c.select_text_df:visibility(false)
        menu.vis_c.select_text_ak:visibility(false)
    elseif menu.vis_c.select_extra:get() == 3 then
        menu.vis_c.select_text_df:visibility(true)
        menu.vis_c.select_text_manual:visibility(false)
        menu.vis_c.select_text_fs:visibility(false)
        menu.vis_c.select_text_ak:visibility(false)
    else
        menu.vis_c.select_text_ak:visibility(true)
        menu.vis_c.select_text_manual:visibility(false)
        menu.vis_c.select_text_fs:visibility(false)
        menu.vis_c.select_text_df:visibility(false)
    end

end)

events.render:set(function(ctx)

    local show = menu.vis_c.presets_list:get() == 1

    if menu.vis_c.presets_list:get() == 1 then
        menu.vis_c.presets_list:update({"😎 • conditional ✔️", "🥳 • hybrid", "🤯 • alpha"})
    elseif menu.vis_c.presets_list:get() == 2 then
        menu.vis_c.presets_list:update({"😎 • conditional", "🥳 • hybrid ✔️", "🤯 • alpha"})
    else
        menu.vis_c.presets_list:update({"😎 • conditional", "🥳 • hybrid", "🤯 • alpha ✔️"})
    end

    menu.aa_builder.state_list:visibility(show)

    --> custom antiaim
    for _, v in pairs(aa_lol.builder.conditions) do

        local states_list = menu.aa_builder.state_list:get()

        local current_state = "stand"
        if states_list == 1 then
            current_state = "stand"
        elseif states_list == 2 then
            current_state = "run"
        elseif states_list == 3 then
            current_state = "slow"
        elseif states_list == 4 then
            current_state = "crouch"
        elseif states_list == 5 then
            current_state = "crouch moving"
        elseif states_list == 6 then
            current_state = "air"
        elseif states_list == 7 then
            current_state = "air crouch"
        end

        local selected = current_state == v

        local elements = menu.aa_builder.builder_elements[v]

        if show then
            elements.enable:visibility(selected)

            if elements.enable:get() then

                elements.space_2:visibility(selected)
                elements.yaw_mode:visibility(selected)

                if elements.yaw_mode:get() == "static" then
                    elements.yaw_center:visibility(selected)
                    elements.yaw_left:visibility(false)
                    elements.yaw_right:visibility(false)
                else
                    elements.yaw_center:visibility(false)
                    elements.yaw_left:visibility(selected)
                    elements.yaw_right:visibility(selected)
                end

                if elements.yaw_mode:get() == "slow yaw" then
                    elements.aa_speed:visibility(selected)
                else
                    elements.aa_speed:visibility(false)
                end
                
                elements.space_1:visibility(selected)
                
                elements.jitter:visibility(selected)

                if elements.jitter:get() ~= "disabled" then
                    elements.yaw_jitter_ovr:visibility(selected)
                else
                    elements.yaw_jitter_ovr:visibility(false)
                end

                elements.body_yaw:visibility(selected)
                elements.fake_options:visibility(selected)
            else
                elements.space_2:visibility(false)
                elements.yaw_mode:visibility(false)
                elements.yaw_center:visibility(false)
                elements.yaw_left:visibility(false)
                elements.yaw_right:visibility(false)
                elements.space_1:visibility(false)
                elements.jitter:visibility(false)
                elements.yaw_jitter_ovr:visibility(false)
                elements.body_yaw:visibility(false)
                elements.aa_speed:visibility(false)
                elements.fake_options:visibility(false)
            end
        else
            elements.enable:visibility(false)
            elements.space_2:visibility(false)
            elements.yaw_mode:visibility(false)
            elements.yaw_center:visibility(false)
            elements.yaw_left:visibility(false)
            elements.yaw_right:visibility(false)
            elements.space_1:visibility(false)
            elements.aa_speed:visibility(false)
            elements.jitter:visibility(false)
            elements.yaw_jitter_ovr:visibility(false)
            elements.body_yaw:visibility(false)
            elements.fake_options:visibility(false)
        end
    end
end)

local f = string.format;

local function int(x)
    return math.floor(x + 0.5);
end

local function lerp(a, b, weight)
    local delta = b - a;

    if math.abs(delta) < 0.01 then
        return b;
    end

    return a + delta * weight;
end

local notify = {};
local aimbot_logs = {};

local amn_icon = render.load_image(network.get("https://cdn.discordapp.com/attachments/844966073131335713/1084160819497017464/notif_logo.png"))

-- notify
do
    -- private
    local items = {};

    local font = 1;
    local flags = 'cs';

    local thickness = 1;

    local screen = render.screen_size();

    -- public
    function notify:add(text, color, sec)
        sec = sec or 4.0;

        local obj = {};

        obj.text = text;
        obj.time = globals.realtime + sec;
        obj.color = color;
        obj.alpha = 0.0;

        table.insert(items, 1, obj);
    end

    function notify:draw()
        local realtime = globals.realtime;
        local frametime = globals.frametime * 11;

        local position = vector(screen.x * 0.5 + 1, screen.y * 0.863);

        for i = #items, 1, -1 do
            local v = items[i];

            local text = v.text;
            local time = v.time;
            local alpha = v.alpha;

            local clr = v.color;

            if type(clr) == 'function' then
                clr = clr(v);
            end

            if clr == nil then
                clr = color();
            end

            local is_outgoing = time < realtime;

            if is_outgoing or i > 6 then
                v.alpha = lerp(v.alpha, 0.0, frametime);

                if alpha == 0 then
                    table.remove(items, i);
                    goto skip
                end
            else
                v.alpha = lerp(v.alpha, 1.0, frametime);
            end

            local measure = render.measure_text(font, flags, text) + vector(30, 8);
            local middle = measure * 0.5;

            local bg_alpha = clr.a * alpha;
            clr = clr:alpha_modulate(255 * alpha);

            local radius = middle.y + 0.5;

            local hex_version = clr:to_hex()

            render.shadow(position - middle - 3, position + middle + 3, clr,12, 0, 6)
            render.rect(position - middle - 3, position + middle + 3, color(17, bg_alpha), 6);
            render.rect_outline(position - middle - 3, position + middle + 3, clr,1.5, 6);

            render.text(font, position, color(255, clr.a), flags, "\a"..hex_version..ui.get_icon("sparkles").." \aDEFAULT"..text);

            local rect_size = vector((measure.x - radius * 2) * alpha, thickness);

            position.y = position.y + int((measure.y + 13) * alpha);
            ::skip::
        end
    end
end

local glob_clr

local reasons = {};
local gui = {};

    local hitgroups = {
        [0] = 'generic',
        'head',
        'chest',
        'stomach',
        'left arm',
        'right arm',
        'left leg',
        'right leg',
        'neck',
        'generic',
        'gear'
    };

    local wpn2act = {
        ['hegrenade'] = 'naded',
        ['inferno'] = 'burned',
        ['knife'] = 'knifed'
    };

    local tag = '\aBA90C0FFamnesia.lol\aDEFAULT';

    local function console_print(s)
        if not gui.master:get() or not gui.show:get('logs in console') then
            return;
        end

        local text = f('[%s] %s', tag, s);
        text = text:gsub('(\a%x%x%x%x%x%x)%x%x', '%1');

        print_raw(text);
    end

    local function push_notify(text, clr, sec)
        if not gui.master:get() or not gui.show:get('screen logs') then
            return;
        end

        notify:add(text, clr or gui.color:get(), sec);
    end

    -- public
    gui.group = tabs.misc.vis;

    gui.master = gui.group:switch('notifications');
    gui.gear = gui.master:create();

    gui.show = gui.gear:selectable('Show', {'logs in console', 'screen logs', 'bullet detection'});
    gui.color = gui.gear:color_picker('Color');

    local color2 = gui.color:get()

    local hex_version = color2:to_hex()

    glob_clr = hex_version

    function aimbot_logs:aim_ack(e)
        local ent = e.target;
        local reason = e.state;

        if ent == nil then
            return;
        end

        local name = ent:get_name();

        local health = ent.m_iHealth;
        local spread = e.spread;
        local backtrack = e.backtrack;
        local hitchance = e.hitchance;

        local damage = e.damage;
        local wanted_damage = e.wanted_damage;

        local hitgroup = hitgroups[ e.hitgroup ] or '?';
        local wanted_hitgroup = hitgroups[ e.wanted_hitgroup ] or '?';

        local color = gui.color:get()

        local hex_version = color:to_hex()
    
        glob_clr = hex_version

        -- hit
        if reason == nil then
            console_print(f(
                '\a\a'..glob_clr..'registered \aDEFAULTshot at %s\'s %s for \aa\a'..glob_clr..'%d(%d) \aDEFAULTdamage (hp: %d) (aimed: %s) (bt: %s) (spread: %.1f°)',
                name, hitgroup, damage, wanted_damage, health, wanted_hitgroup, backtrack, spread
            ));

            push_notify(f(
                'hit \a'..hex_version..'%s\aDEFAULT\'s %s for \a'..glob_clr..'%d\aDEFAULT(%d) [bt: \a'..glob_clr..'%s \aDEFAULT~ hp: \a'..glob_clr..'%d\aDEFAULT]',
                name:lower(), hitgroup, damage, wanted_damage, backtrack, health
            ));

            return;
        end

        -- miss
        if reason ~= nil then
            local reason_mod = reasons[ reason ];

            if reason_mod ~= nil then
                reason = reason_mod;
            end

            if reason == "prediction error" then
                reason = "pred.error"
            end

            local con = f(
                '\a'..hex_version..'missed \aDEFAULTshot at %s in %s due to \a'..glob_clr..'%s \aDEFAULT(hc: %d%%) (damage: %d)',
                name:lower(), wanted_hitgroup, reason, hitchance, wanted_damage
            );

            local note = f(
                '\a'..hex_version..'missed \aDEFAULTshot in %s in %s due to \a'..glob_clr..'%s\aDEFAULT(%d%%) [damage: \a'..glob_clr..'%d\aDEFAULT',
                name:lower(), wanted_hitgroup, reason, hitchance, wanted_damage
            );

            if spread ~= nil then
                con = f('%s (spread: %.1f)', con, spread);
            end

            note = f('%s%s', note, spread and f('| spread: \a\a'..glob_clr..'%.1f°\aDEFAULT]', spread) or ']');

            console_print(con);
            push_notify(note);

            return;
        end
    end

    function aimbot_logs:player_hurt(e)
        local me = entity.get_local_player();
        local userid = entity.get(e.userid, true);
        local attacker = entity.get(e.attacker, true);

        local color = gui.color:get()

        local hex_version = color:to_hex()
    
        glob_clr = hex_version

        if userid == me or attacker ~= me then
            return;
        end

        local act = wpn2act[ e.weapon ];

        if act == nil then
            return;
        end

        local name = userid:get_name();

        local text = f(
            '%s \a'..glob_clr..'%s \aDEFAULTfor \a'..glob_clr..'%d \aDEFAULTdamage (%d health remaining)',
            act, name:lower(), e.dmg_health, e.health
        );

        console_print(text);
        push_notify(text);
    end

    local bullet_detect = {}

    last_tick_triggered = globals.tickcount

    bullet_detect.bullet_impact = function(e)
        if not gui.master:get() or not gui.show:get('bullet detection') then
            return;
        end

        local color = gui.color:get()

        local hex_version = color:to_hex()

        glob_clr = hex_version

        local player = entity.get_local_player()
        
        if player == nil or not player:is_alive() then
            return
        end

        local userid = entity.get(e.userid, true)

        if userid == nil or not userid:is_alive() or userid:is_dormant() or not userid:is_enemy() then
            return
        end

        if last_tick_triggered == globals.tickcount then return end

        local impact = vector(e.x, e.y, e.z)
        local userid_pos = userid:get_eye_position()
        local player_pos = player:get_eye_position()

        bullet_detect.distance = player_pos:closest_ray_point(userid_pos, impact):dist(player_pos)

        if bullet_detect.distance > 53 then return end

        last_tick_triggered = globals.tickcount

        local text = f('changed \a'..glob_clr..'jitter \aDEFAULTdue to \a'..glob_clr..'bullet\aDEFAULT from \a'..glob_clr..userid:get_name():lower());
        push_notify(text);
    end

    events.bullet_impact:set(function(e)
        bullet_detect.bullet_impact(e)
    end)

    aimbot_logs.gui = gui;

    local text = f('welcome to \a'..glob_clr..'amnesia \aDEFAULT~ \a'..glob_clr..common.get_username());
    push_notify(text);

    
local data = {
    bools = {},
    tables = {},
    ints = {},
    numbers = {}
}

function pairsort(t)  
    local a = {}  
    for n in pairs(t) do    
        a[#a+1] = n  
    end  
    table.sort(a)  
    local i = 0  
    return function()  
        i = i + 1  
        return a[i], t[a[i]]  
    end  
end 

for i, v in pairs(aa_lol.builder.conditions) do
    for _, v in pairsort(menu.aa_builder.builder_elements[v]) do
        if type(v:get()) == "boolean" then
            table.insert(data.bools,v)
        elseif type(v:get()) == "table" then
            table.insert(data.tables,v)
        elseif type(v:get()) == "string" then
            table.insert(data.ints,v)
        else
            table.insert(data.numbers,v)
        end
    end
end

panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@hellboyhvh?sub_confirmation=1")

local function export()      
    local Code = {{},{},{},{},{}}
        for _, bools in pairs(data.bools) do
            table.insert(Code[1], bools:get())
        end
        
        for _, tables in pairs(data.tables) do
            table.insert(Code[2], tables:get())
        end
        
        for _, ints in pairs(data.ints) do
            table.insert(Code[3], ints:get())
        end
        
        for _, numbers in pairs(data.numbers) do
            table.insert(Code[4], numbers:get())
        end

        clipboard.set(base64.encode(json.stringify(Code)))
        
        local text = f('successfully \a'..glob_clr..'exported\aDEFAULT \a'..glob_clr.."settings");
        push_notify(text);
end

local function import()
    for k, v in pairs(json.parse(base64.decode(clipboard.get()))) do
        k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                data[k][k2]:set(v2)
            end
    
            if (k == "tables") then
                data[k][k2]:set(v2)
            end
    
            if (k == "ints") then
                data[k][k2]:set(v2)
            end
                
            if (k == "numbers") then
                data[k][k2]:set(v2)
            end
        end
    end
    local text = f('successfully \a'..glob_clr..'imported \aDEFAULT\a'..glob_clr.."settings");
    push_notify(text);
end

local function defimport()
    for k, v in pairs(json.parse(base64.decode("W1t0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWVdLFtbXSxbXSxbXSxbXSxbXSxbXSxbXV0sWyJkaXNhYmxlZCIsInNsb3cgeWF3IiwiZGlzYWJsZWQiLCJzbG93IHlhdyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJkaXNhYmxlZCIsInNsb3cgeWF3IiwiZGlzYWJsZWQiLCJzbG93IHlhdyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJkaXNhYmxlZCIsInNsb3cgeWF3Il0sWzcuMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsMC4wLC0yNS4wLDQ1LjAsNi4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwwLjAsLTI0LjAsMzkuMCw5LjAsMTc3NTgzLjAsMTc3NTgzLjAsMC4wLDAuMCwtMjkuMCw0OS4wLDcuMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsMTQuMCwtMzEuMCw1OC4wLDcuMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsMC4wLC0yNC4wLDQ2LjAsNy4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwtOS4wLC0yMi4wLDQzLjAsNy4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwwLjAsLTIyLjAsNDMuMF0sW11d"))) do
        k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                data[k][k2]:set(v2)
            end

            if (k == "tables") then
                data[k][k2]:set(v2)
            end

            if (k == "ints") then
                data[k][k2]:set(v2)
            end

            if (k == "numbers") then
                data[k][k2]:set(v2)
            end
        end
    end
    local text = f('successfully \a'..glob_clr..'loaded \aDEFAULT\a'..glob_clr.."*fik's aa*");
    push_notify(text);
end

local function defimport2()
    for k, v in pairs(json.parse(base64.decode("W1t0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWVdLFtbImppdHRlciJdLFtdLFtdLFtdLFtdLFsiaml0dGVyIl0sWyJqaXR0ZXIiXV0sWyJkaXNhYmxlZCIsInN0YXRpYyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJkaXNhYmxlZCIsInNsb3cgeWF3IiwiZGlzYWJsZWQiLCJzbG93IHlhdyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJjZW50ZXIiLCJzdGF0aWMiLCJkaXNhYmxlZCIsImwg4oCiIHIiXSxbOC4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwwLjAsMC4wLDAuMCw4LjAsMTc3NTgzLjAsMTc3NTgzLjAsMC4wLDAuMCwtMjkuMCw0OS4wLDkuMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsMC4wLC0yOS4wLDQ5LjAsOC4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwxNC4wLC0yOC4wLDQ2LjAsOS4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwwLjAsLTE5LjAsNDQuMCw4LjAsMTc3NTgzLjAsMTc3NTgzLjAsMC4wLC05LjAsMC4wLDAuMCw4LjAsMTc3NTgzLjAsMTc3NTgzLjAsMC4wLDAuMCwtMjMuMCw0OS4wXSxbXV0="))) do
        k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                data[k][k2]:set(v2)
            end

            if (k == "tables") then
                data[k][k2]:set(v2)
            end

            if (k == "ints") then
                data[k][k2]:set(v2)
            end

            if (k == "numbers") then
                data[k][k2]:set(v2)
            end
        end
    end
    local text = f('successfully \a'..glob_clr..'loaded \aDEFAULT\a'..glob_clr.."*japan's aa*");
    push_notify(text);
end

local function defimport3()
    for k, v in pairs(json.parse(base64.decode("W1t0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWUsdHJ1ZSx0cnVlLHRydWVdLFtbXSxbXSxbXSxbXSxbXSxbXSxbXV0sWyJkaXNhYmxlZCIsImdyYXZpdHkgeWF3IiwiZGlzYWJsZWQiLCJzbG93IHlhdyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJkaXNhYmxlZCIsImdyYXZpdHkgeWF3IiwiZGlzYWJsZWQiLCJncmF2aXR5IHlhdyIsImRpc2FibGVkIiwic2xvdyB5YXciLCJkaXNhYmxlZCIsInNsb3cgeWF3Il0sWzguMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsMTUuMCwtMTUuMCw0MC4wLDguMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsLTQ1LjAsLTMwLjAsNDUuMCw4LjAsMTc3NTgzLjAsMTc3NTgzLjAsMC4wLC00Mi4wLC0zNS4wLDQwLjAsOC4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwxNC4wLC0zNS4wLDQ1LjAsOC4wLDE3NzU4My4wLDE3NzU4My4wLDAuMCwtMzAuMCwtMjAuMCw0MC4wLDguMCwxNzc1ODMuMCwxNzc1ODMuMCwwLjAsLTQ1LjAsLTIwLjAsMzUuMCw4LjAsMTc3NTgzLjAsMTc3NTgzLjAsNTUuMCw0NS4wLC0xOS4wLDM5LjBdLFtdXQ=="))) do
        k = ({[1] = "bools", [2] = "tables",[3] = "ints",[4] = "numbers"})[k]
        for k2, v2 in pairs(v) do
            if (k == "bools") then
                data[k][k2]:set(v2)
            end

            if (k == "tables") then
                data[k][k2]:set(v2)
            end

            if (k == "ints") then
                data[k][k2]:set(v2)
            end

            if (k == "numbers") then
                data[k][k2]:set(v2)
            end
        end
    end
    local text = f('successfully \a'..glob_clr..'loaded \aDEFAULT\a'..glob_clr.."*cola's aa*");
    push_notify(text);
end

local defimport = tabs.aa.preset:button("fiks anti-aim",defimport, true)	
local defimport2 = tabs.aa.preset:button("cola's anti-aim",defimport2, true)			

local is_invert = false

local inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter")

local timer = 0
local yaw_1 = 0
local yaw_2 = 0
local destination = 0

local states = {
    ground_timer = 0,
    lag_timer = 0
}

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local calc_angle = function(local_pos, enemy_pos)
    local ydelta = local_pos.y - enemy_pos.y
    local xdelta = local_pos.x - enemy_pos.x
    local relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = math.normalize_yaw(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = math.normalize_yaw(relativeyaw + 180)
    end
    return relativeyaw
end

local jitter = true
local desync = true
local counter = 0
local counter = 0

n_cache = {
    nade = 0,
    on_ladder = false,
    holding_nade = false
}

local run_command_check = function()
    local me = entity.get_local_player()
    if me == nil then return end

    n_cache.on_ladder = me.m_MoveType == 9
end

local nade_check = function(weapon, cmd)
    local pin_pulled = weapon.m_bPinPulled
    if pin_pulled ~= nil then
        if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
            local throw_time = weapon.m_fThrowTime
            if throw_time ~= nil and throw_time > 0 and throw_time < globals.curtime then
                return true
            end
        end
    end
    return nil
end

local can_desync = function(cmd, ent, count, vel)
    if aa.freestand[1]:get() then return end

    local weapon = ent:get_player_weapon(false)
    if weapon == nil then return end
    local srv_time = ent.m_nTickBase * globals.tickinterval
    local wpnclass = weapon:get_classname()

    if wpnclass:find("Grenade") == nil and cmd.in_attack == 1 and srv_time > weapon.m_flNextPrimaryAttack - 0.1 then return end

    if nade_check(weapon, cmd) then return end

    local rules = entity.get_game_rules()

    if rules.m_bFreezePeriod then return false end

    if n_cache.on_ladder then return false end
    if cmd.in_use == 1 then return false end

    return true
end

events.createmove_run:set(function()
    run_command_check()
end)

function aa_lol:custom_desync(left, right, fake, cmd)
    cmd.send_packet = false
    local me = entity.get_local_player()
    local local_player_pos = me:get_origin()
    local enemy = entity.get_threat(false)
    local enemy_pos = enemy ~= nil and enemy:get_origin() or vector()
    local yaw = calc_angle(local_player_pos, enemy_pos) + 180

    local widefix = false
    if desync and not jitter and cmd.chokedcommands == 1 then
        counter = 4
    end
    if counter > 0 then
        counter = counter - 1
        widefix = true
    end
    if cmd.choked_commands % 2 == 1 then
        jitter = not jitter
        cmd.yaw = jitter and (yaw - left) or (yaw + right)
    else
        desync = not desync
        if cmd.choked_commands > 1 then
            cmd.yaw = jitter and (yaw - left) or (yaw + right)
        else
            if not widefix then
                cmd.yaw = desync and (yaw - fake) or (yaw + fake)
            else
                cmd.yaw = desync and (yaw + fake) or (yaw - fake)
            end
        end
    end
    cmd.pitch = 89
end

function states:in_air(a)
    if not a then return false end;

    local b=a.m_fFlags

    local c=bit.band(b,1)~=0;

    if c then 
        if self.ground_timer==5 then 
            return false 
        end;
        
        self.ground_timer=self.ground_timer+1 

    else 
        self.ground_timer=0 
    end;
        
    return true 
end

function states:is_moving(ent)
    local velocity = ent.m_vecVelocity
    return math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y) > 2
end

function states:is_crouching(ent)
    local ducked = ent.m_bDucked
    return ducked
end

function states:team_number(ent)
	local team_num =  ent.m_iTeamNum
	return team_num
end

function states:get_state(ent)
    local is_moving = self:is_moving(ent)
    local is_crouching = self:is_crouching(ent)
    local in_air = self:in_air(ent)

    if aa.slow:get() then
        return "slow"
    end

    if in_air then
        if is_crouching then
            return "air crouch"
        end

        return "air"
    end

    if is_crouching and is_moving then
        return "crouch moving"
    end

    if is_crouching then
        return "crouch"
    end

    if is_moving then
        return "run"
    end

    if not is_moving then
        return "stand"
    end

    return "none"
end

local hotkeys = {
	manual_last_pressed = globals.realtime
}

function hotkeys:run()

    aa.freestand[1]:set(menu.vis_c.select_text_fs:get())
    aa.freestand[2]:set(menu.vis_c.fs_static:get(1))
    aa.freestand[3]:set(menu.vis_c.fs_static:get(2))
    aa.backstab:set(menu.vis_c.select_text_ak:get())

	local curtime = globals.realtime

	if hotkeys.manual_last_pressed + 0.2 > curtime then return end

	if menu.vis_c.manual_aa_state:get() == "left" and aa_lol.manual_state ~= 1 then
		aa_lol.manual_state = 1
		hotkeys.manual_last_pressed = curtime
	elseif menu.vis_c.manual_aa_state:get() == "right" and aa_lol.manual_state ~= 2 then
		aa_lol.manual_state = 2
		hotkeys.manual_last_pressed = curtime
	elseif menu.vis_c.manual_aa_state:get() == "forward" and aa_lol.manual_state ~= 3 then
		aa_lol.manual_state = 3
		hotkeys.manual_last_pressed = curtime
	elseif menu.vis_c.manual_aa_state:get() == "left" or menu.vis_c.manual_aa_state:get() == "right" or menu.vis_c.manual_aa_state:get() == "forward" then
		aa_lol.manual_state = 0
		hotkeys.manual_last_pressed = curtime
	end
end

events.createmove:set(hotkeys.run)

local check1, defensive1 = 0, 0

events.createmove_run:set(function()
    local tickbase = entity.get_local_player().m_nTickBase
    defensive1 = math.abs(tickbase - check1)
    check1 = math.max(tickbase, check1 or 0)
end)

local swap = false

local function preset_manager(left, right, jitter_val, jitter_type)
    local lp = entity.get_local_player()
    local lp_bodyyaw = lp.m_flPoseParameter[11] * 120 - 60
    local yaw = 0

    yaw = lp_bodyyaw <= 0 and right or left

    aa.offset:override(yaw)
    aa.base:override("at target")
    aa.jitter:override(jitter_type ~= nil and jitter_type or "center")
    aa.jitter_val:override(jitter_val)
    aa.body_yaw[1]:override(true)
    aa.body_yaw[3]:override(58)
    aa.body_yaw[4]:override(58)
    aa.body_yaw[5]:override("jitter")
    aa.body_yaw[6]:override("Off")
end

local count_ticks = 0

local function antiaim(arg)

    local lp = entity.get_local_player()
    if lp == nil then return end

    if defensive1 % 3 == 1 then
        swap = not swap
    end

    local state = states:get_state(lp)

    states.state = state

    local vel = lp.m_vecVelocity
    local count = globals.tickcount

    local allow_desync = can_desync(arg, lp, count, vel)

    if state == "none" then return end

    local builder = menu.aa_builder.builder_elements[state]

    if aa_lol.manual_state == 1 then
        hotkeys.manual_state = -90
        aa.base:override("local view")
    elseif aa_lol.manual_state == 2 then
        hotkeys.manual_state = 90
        aa.base:override("local view")
    elseif aa_lol.manual_state == 3 then
        hotkeys.manual_state = 180
        aa.base:override("local view")
    else
        aa.base:override("at target")
        hotkeys.manual_state = 0
    end

    local lp_bodyyaw = lp.m_flPoseParameter[11] * 120 - 60
    
    local yaw_left = builder.yaw_left:get()
    local yaw_right = builder.yaw_right:get()

    local jit_a = builder.yaw_jitter_ovr:get()
    --lp_bodyyaw <= 0 and yaw_right or yaw_left

    if globals.choked_commands == 0 then
        count_ticks = count_ticks + 1
    end

    if count_ticks >= 8 then
        count_ticks = 0
    end

    if builder.yaw_mode:get() == "static" then
        yaw = builder.yaw_center:get()
    elseif builder.yaw_mode:get() == "l • r" then
        yaw = lp_bodyyaw <= 0 and yaw_right or yaw_left
    elseif builder.yaw_mode:get() == "slow yaw" then
        if globals.commandack % builder.aa_speed:get() < (builder.aa_speed:get()/2) then
            inverter:override(true)
            if globals.choked_commands == 0 then
                yaw = yaw_left
            end
        else
            inverter:override(false)
            if globals.choked_commands == 0 then
                yaw = yaw_right
            end
        end
    elseif builder.yaw_mode:get() == "gravity yaw" then
        if count_ticks == 0 then
            --right
            inverter:override(false)
            yaw = yaw_right
        elseif count_ticks == 1 then
            --left
            inverter:override(true)
            yaw = yaw_left
        elseif count_ticks == 2 then
            --left
            inverter:override(true)
            yaw = yaw_left
        elseif count_ticks == 3 then
            --left
            inverter:override(true)
            yaw = yaw_left
        elseif count_ticks == 4 then
            --right
            inverter:override(false)
            yaw = yaw_right
        elseif count_ticks == 5 then
            --left
            inverter:override(true)
            yaw = yaw_left
        elseif count_ticks == 6 then
            --right
            inverter:override(false)
            yaw = yaw_right
        elseif count_ticks == 7 then
            --right
            inverter:override(false)
            yaw = yaw_right
        end
    end

    local yaw2 = lp_bodyyaw <= 0 and 28 or -9
    local yaw3 = lp_bodyyaw <= 0 and 9 or -9
    local jitter = jit_a

    local team_num = lp.m_iTeamNum

    local is_fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

    if menu.vis_c.presets_list:get() == 1 then

        local weapon = lp:get_player_weapon(false)
        if weapon == nil then return end
        local wpnclass = weapon:get_classname()

        local tickbasee = lp.m_nTickBase

        if menu.vis_c.select_text_df:get() and state == "air" or state == "air crouch" or state == "crouch moving" or state == "crouch" or state == "stand" then
            if wpnclass:find("Grenade") and menu.vis_c.disable_on_nade:get(1) then
                aa.def:override("Disabled")
            else
                if menu.vis_c.disable_on_nade:get(2) then
                    if tickbasee % 5 ~= 3 then
                        aa.def:override("Always on")
                    else
                        aa.def:override("Disabled")
                    end
                else
                    aa.def:override("Always on")
                end
            end
        else
            aa.def:override("On peek")
        end

        if hotkeys.manual_state ~= 0 and menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override("disabled")
            aa.jitter_val:override(0)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override("disabled")
            aa.body_yaw[6]:override("Off")
        elseif hotkeys.manual_state ~= 0 and not menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override(builder.jitter:get())
            aa.jitter_val:override(jitter)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override(builder.fake_options:get())
            aa.body_yaw[6]:override("Off")
        elseif builder.yaw_mode:get() == "async yaw" and rage.exploit:get() == 1 or references.hideshots:get() and not is_fd then
            aa.base:override("at target")

            if builder.jitter:get() == "gravity" then
                aa.jitter:override("center")
                aa.jitter_val:override(jitter + math.random(0,5) * 1.1)
            else
                aa.jitter:override(builder.jitter:get())
                aa.jitter_val:override(jitter)
            end

            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override(builder.fake_options:get())
            aa.body_yaw[6]:override("Off")

            timer = timer + 1
            
            yaw_1 = builder.yaw_left:get()
            yaw_2 = builder.yaw_right:get()

            if swap then
                inverter:override(true)
                if arg.choked_commands == 0 then
                    aa.offset:override(yaw_1)
                end
            else
                inverter:override(false)
                if arg.choked_commands == 0 then
                    aa.offset:override(yaw_2)
                end
            end
        else
            --fakelag
            aa.offset:override(yaw)
            aa.base:override("at target")
            if builder.jitter:get() == "gravity" then
                aa.jitter:override("offset")
                aa.jitter_val:override(jitter + math.random(0,5) * 1.1)
            else
                aa.jitter:override(builder.jitter:get())
                aa.jitter_val:override(jitter)
            end
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(60)
            aa.body_yaw[4]:override(60)
            aa.body_yaw[5]:override(builder.fake_options:get())
            aa.body_yaw[6]:override("Off")
        end
    elseif menu.vis_c.presets_list:get() == 2 then
        local weapon = lp:get_player_weapon(false)
        if weapon == nil then return end
        local wpnclass = weapon:get_classname()

        local tickbasee = lp.m_nTickBase

        if menu.vis_c.select_text_df:get() and state == "air" or state == "air crouch" or state == "crouch moving" or state == "crouch" or state == "stand" then
            if wpnclass:find("Grenade") and menu.vis_c.disable_on_nade:get(1) then
                aa.def:override("Disabled")
            else
                if menu.vis_c.disable_on_nade:get(2) then
                    if tickbasee % 5 ~= 3 then
                        aa.def:override("Always on")
                    else
                        aa.def:override("Disabled")
                    end
                else
                    aa.def:override("Always on")
                end
            end
        else
            aa.def:override("On peek")
        end

        if hotkeys.manual_state ~= 0 and menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override("disabled")
            aa.jitter_val:override(0)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(60)
            aa.body_yaw[5]:override("disabled")
            aa.body_yaw[6]:override("Off")
        elseif hotkeys.manual_state ~= 0 and not menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override(builder.jitter:get())
            aa.jitter_val:override(jitter)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override(builder.fake_options:get())
            aa.body_yaw[6]:override("Off")
        elseif state == "stand" then
            preset_manager(-10, 29, 0)
        elseif state == "run" then
            preset_manager(-29, 49, 0)
        elseif state == "slow" then
            preset_manager(-29, 49, 0)
        elseif state == "crouch" then
            preset_manager(-19, 44, 0)
        elseif state == "crouch moving" then
            preset_manager(-21, 44, 0)
        elseif state == "air" then
            preset_manager(-19, 44, 0)
        elseif state == "air crouch" then
            preset_manager(-23, 49, 0)
        end
    elseif menu.vis_c.presets_list:get() == 3 then
        local weapon = lp:get_player_weapon(false)
        if weapon == nil then return end
        local wpnclass = weapon:get_classname()

        local tickbasee = lp.m_nTickBase

        if menu.vis_c.select_text_df:get() and state == "air" or state == "air crouch" or state == "crouch moving" or state == "crouch" or state == "stand" then
            if wpnclass:find("Grenade") and disable_on_nade:get(1) then
                aa.def:override("Disabled")
            else
                if disable_on_nade:get(2) then
                    if tickbasee % 5 ~= 3 then
                        aa.def:override("Always on")
                    else
                        aa.def:override("Disabled")
                    end
                else
                    aa.def:override("Always on")
                end
            end
        else
            aa.def:override("On peek")
        end

        if hotkeys.manual_state ~= 0 and menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override("disabled")
            aa.jitter_val:override(0)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override("disabled")
            aa.body_yaw[6]:override("Off")
        elseif hotkeys.manual_state ~= 0 and not menu.vis_c.manual_aa_static:get(1) then
            aa.offset:override(hotkeys.manual_state)
            aa.base:override("local view")
            aa.jitter:override(builder.jitter:get())
            aa.jitter_val:override(jitter)
            aa.body_yaw[1]:override(builder.body_yaw:get())
            aa.body_yaw[3]:override(58)
            aa.body_yaw[4]:override(58)
            aa.body_yaw[5]:override(builder.fake_options:get())
            aa.body_yaw[6]:override("Off")
        elseif state == "stand" then
            preset_manager(-18, 42, -9)
        elseif state == "run" then
            preset_manager(34, 37, math.random(-56, -70), "offset")
        elseif state == "slow" then
            preset_manager(45, 45, math.random(-76, -90), "offset")
        elseif state == "crouch" then
            preset_manager(35, 35, math.random(-60, -75), "offset")
        elseif state == "crouch moving" then
            preset_manager(35, 35, math.random(-60, -75), "offset")
        elseif state == "air" then
            preset_manager(-22, 10, -37)
        elseif state == "air crouch" then
            preset_manager(-5, 40, math.random(-15, -30), "offset")
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

function get_velocity(player)
    if(player == nil) then return end
    local vec = player.m_vecVelocity
    local velocity = vec:length()
    return velocity
end

function extrapolate_pos(x,y,z, ticks, player)
    for i = 1, ticks do
        x = x + player.m_vecVelocity.x * (1 / 64)
        y = y + player.m_vecVelocity.y * (1 / 64)
        z = z + player.m_vecVelocity.z * (1 / 64)
    end
    return vector(x,y,z)
end

function Angle_Vector(angle_x, angle_y)
    local sp, sy, cp, cy = nil
    sp = math.sin(math.rad(angle_x));
    sy = math.sin(math.rad(angle_y));
    cp = math.cos(math.rad(angle_x));
    cy = math.cos(math.rad(angle_y));
    return vector(cp * cy, cp * sy, -sp);
end

events.createmove:set(antiaim)

refs = {fakeduck = ui.find('Aimbot','Anti Aim',"Misc","Fake Duck"),slowwalk = ui.find('Aimbot','Anti Aim',"Misc","Slow Walk"),hitchance = ui.find('Aimbot','Ragebot',"Selection","Hit Chance"),doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),isSafe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),isBody = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),dormant_aim = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")}

local vis = tabs.misc.vis
local misc = tabs.misc.misc

misc:label("\aB6B665FF"..ui.get_icon("brake-warning").." some of these features may not work correctly or effect your experience with neverlose")

menu.vis_c.visuals = {
    enable_inds = vis:switch("enable indicators",false),  
}

menu.vis_c.misc_t = {
    fast_fall = misc:switch(ui.get_icon("person-falling").." fast fall",false), 
    fast_ladder = misc:switch(ui.get_icon("water-ladder").." fast ladder",false),
    --viewmodel_manager = misc:switch(ui.get_icon("camera-viewfinder").." viewmodel manager",false), 
    teleport_on_hit = misc:switch("\aB6B665FF"..ui.get_icon("transporter-3").." teleport helper",false),
    nade_swap = misc:switch("\aB6B665FF"..ui.get_icon("ban-bug").." nade fix [wip]",false),
    wingman_help = misc:switch(ui.get_icon("brake-warning").." wingman helpers",false), 
}

menu.vis_c.misc_t.options = menu.vis_c.misc_t.fast_ladder:create():selectable("work on", {"ascending", "descending"})
menu.vis_c.misc_t.ladder_yaw_checkbox = menu.vis_c.misc_t.fast_ladder:create():switch("ladder yaw")
menu.vis_c.misc_t.ladder_yaw_slider = menu.vis_c.misc_t.fast_ladder:create():slider("", -180, 180, 0)

menu.vis_c.misc_t.smoke_warn = menu.vis_c.misc_t.wingman_help:create():switch("smoke warning")
menu.vis_c.misc_t.defuse_flag = menu.vis_c.misc_t.wingman_help:create():label("defuse kit flag is in esp tab")
menu.vis_c.misc_t.w_accent = menu.vis_c.misc_t.wingman_help:create():color_picker("accent")
menu.vis_c.misc_t.w_bgclr = menu.vis_c.misc_t.wingman_help:create():color_picker("background")

menu.vis_c.misc_t.nade_bind = menu.vis_c.misc_t.nade_swap:create():switch("hover me!", false)
menu.vis_c.misc_t.nade_slider = menu.vis_c.misc_t.nade_swap:create():slider("delay for x ticks", 1, 15, 10)

menu.vis_c.misc_t.nade_bind:tooltip("bind this to the same as your grenade helper bind.")

local nade_timer = 0
local nade_thrown

events.grenade_thrown:set(function(e)
	if not menu.vis_c.misc_t.nade_bind:get() then
		return
	end

	userid, grenade = e.userid, e.weapon

	if entity.get(userid, true) == entity.get_local_player() then
        nade_thrown = true
	end
end)

events.createmove_run:set(function(e)

    local quick_swap = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")

    if nade_thrown then
        nade_timer = nade_timer + 1

        if nade_timer < menu.vis_c.misc_t.nade_slider:get() then
            quick_swap:set("Auto Pistols")
        else
            quick_swap:set("Quick switch", "Auto Pistols")
            nade_timer = 0
            nade_thrown = false
        end
    end
end)

events.createmove_run:set(function(e)

    local lp = entity.get_local_player()

    if(menu.vis_c.misc_t.fast_fall:get()) then
        local vec = lp.m_vecVelocity
        local l_o = lp.m_vecOrigin
        local tracer = utils.trace_line(l_o, vector(l_o.x, l_o.y, l_o.z - 75), nil, nil, 1)

        if(vec.z < -100) then
            if(l_o.z - tracer.end_pos.z <= 55) then
                rage.exploit:force_teleport()
            end
        end
        
    end

    if(menu.vis_c.misc_t.teleport_on_hit:get()) then
        local sens = 87
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
end)

local fonts = {
    calibrib = render.load_font('Calibri', vector(24, 24, 0), 'ba')
}

local inds = vis:list("indicator manager", {"#1"}, 3)

local vis_adits = tabs.misc.vis

local gs_inds = vis_adits:switch("\aDEFAULTg\a9ABF43FFs \aDEFAULTindicators", false)
local aspect_ratio = misc:switch(ui.get_icon("desktop").." aspect ratio manager", false)
local aspect_ratio_val = aspect_ratio:create():slider("aspect ratio",50, 300, 0, 0.01)

local extra_options = menu.vis_c.visuals.enable_inds:create():switch("adaptive in scope",false)

local animation = {data = {}}

animation.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}

        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = animation.lerp(start[color_key], end_pos[color_key], time)
        end

        return color(unpack(color_data))
    end

    return (end_pos - start) * (globals.frametime * time * 175) + start
end

animation.new = function(name, value, time)
    if animation.data[name] == nil then
        animation.data[name] = value
    end

    animation.data[name] = animation.lerp(animation.data[name], value, time)

    return animation.data[name]
end

local aspect = {}

aspect.cvar = cvar.r_aspectratio
aspect.cvar_float_raw = aspect.cvar.float

local function handle_aspect(init)

    local desired_value = animation.new("aspect_ratio", aspect_ratio_val:get() / 100, 0.1)

    if aspect_ratio_val:get() == 50 then
        desired_value = 0
    end

    if not aspect_ratio:get() then
        desired_value = 0
    end

    local actual_value = aspect.cvar_float_raw(aspect.cvar)

    if desired_value ~= actual_value then
        aspect.cvar_float_raw(aspect.cvar, desired_value)
    end
end

aspect_ratio_destroy = function()
    aspect_ratio.cvar_float_raw(aspect.cvar, 0)
end

aspect_ratio_ratios = {
    [177] = "16:9",
    [161] = "16:10",
    [150] = "3:2",
    [133] = "4:3",
    [125] = "5:4",
}

local itter = 0
for k, v in pairs(aspect_ratio_ratios) do
    itter = itter + 1
    local but = aspect_ratio:create():button(v, function()
        aspect_ratio_val:set(k)
    end)
end

local toggle_inds = false

events.render:set(function(ctx)
    if menu.vis_c.visuals.enable_inds:get() then
        toggle_inds = true
        inds:visibility(true)
        extra_options:visibility(false)
    else
        toggle_inds = false
        inds:visibility(false)
        extra_options:visibility(false)
    end
end)

gs_settings = gs_inds:create()
local gs_enabled = gs_settings:selectable("Indicators", {"Doubletap", "Hideshots", "Fake Ping", "Damage", "Hitchance", "Body Aim", "Safepoint", "Fakeduck", "Dormant Aimbot", "Freestand", "Velocity Warning", "Aimbot Stats"})

gs_inds:set(false)

render_inds = function(r, g, b, a, string, ay)
    if (string == nil or string == '' or string == ' ') then return end
    render.gradient(vector(13, render.screen_size().y - 350 - ay * 37), vector(13 + (render.measure_text(fonts.calibrib, '', string).x / 2), (render.screen_size().y - 345 - ay * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)
    render.gradient(vector(13 + (render.measure_text(fonts.calibrib, '', string).x), render.screen_size().y - 350 - ay * 37), vector(13 + (render.measure_text(fonts.calibrib, '', string).x / 2), (render.screen_size().y - 345 - ay * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)
    render.text(fonts.calibrib, vector(20, (render.screen_size().y - 343) - ay * 37), color(0, 0, 0, 150), '', string)
    render.text(fonts.calibrib, vector(19, (render.screen_size().y - 344) - ay * 37), color(r, g, b, a), '', string)
end

local shots = {hits = 0, misses = 0, all_shots = 0}
indicators = function ()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() or lp.m_iHealth < 0 then return end
    if not gs_inds:get() then return end
    total_hits = math.floor((shots.hits / shots.all_shots) * 100)
    r_th = 0
    if tostring(total_hits) == "nan" then r_th = 0 else r_th = total_hits end
    local mdmg = false
    local isHc = false
    local binds = ui.get_binds()
    for i = 1, #binds do
        local bind = binds[i]
        if bind.name == 'Minimum Damage' and bind.active then
            mdmg = true
        end
        if bind.name == 'Hit Chance' and bind.active then
            isHc = true
        end
    end

    local player_resource = lp:get_resource()
    local ay_s = 0
    local ping = player_resource['m_iPing']
    local delta = (math.abs(ping % 360)) / (refs.fake_latency:get() / 4)
    local aga = math.abs(ping % 360)
    local damagik = refs.damage:get()
    if damagik == 0 then damagik = "Auto" else damagik = refs.damage:get() end        
    if delta > 1 then delta = 1 end

    local modifier_vel = lp.m_flVelocityModifier + 0.01

    if gs_enabled:get("Aimbot Stats") then
        ay_s = animation.new(('aimstat_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, shots.hits .. " / " .. shots.misses .. " (" .. r_th .. "%)", ay_s)
        ay_s = ay_s + 1
    end 

    if gs_enabled:get("Velocity Warning") and modifier_vel ~= 1.01 then
        ay_s = animation.new(('velocity_gs'), ay_s, 0.1)
        render_inds(124 * 2 - 124 * modifier_vel, 195 * modifier_vel, 13, 255, "SLOW", ay_s)
        ay_s = ay_s + 1
    end

    if refs.hideshots:get() and gs_enabled:get("Hideshots") then
        ay_s = animation.new(('onshot_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'OSAA', ay_s)
        ay_s = ay_s + 1
    end

    if mdmg and gs_enabled:get("Damage") then
        ay_s = animation.new(('dmg_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'DMG: ' .. damagik, ay_s)
        ay_s = ay_s + 1
    end

    if isHc and gs_enabled:get("Hitchance") then
        ay_s = animation.new(('hc_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'HC: ' .. refs.hitchance:get(), ay_s)
        ay_s = ay_s + 1
    end

    if refs.fake_latency:get() > 0 and gs_enabled:get("Fake Ping") then
        ay_s = animation.new(('ping_gs'), ay_s, 0.1)
        if aga < 100 then
            render_inds(255, 0, 0, 255, 'PING', ay_s)
        elseif aga > 100 and aga < 150 then
            render_inds(225, 225, 0, 255, 'PING', ay_s)
        elseif aga > 149 then
            render_inds(132, 196, 20, 255, 'PING', ay_s)
        end
        ay_s = ay_s + 1
    end

    if refs.fakeduck:get() and gs_enabled:get("Fakeduck") then
        ay_s = animation.new(('fd_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'DUCK', ay_s)
        ay_s = ay_s + 1
    end

    if refs.isSafe:get() == 'Force' and gs_enabled:get("Safepoint") then
        ay_s = animation.new(('sp_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'SAFE', ay_s)
        ay_s = ay_s + 1
    end

    if refs.isBody:get() == 'Force' and gs_enabled:get("Body Aim") then
        ay_s = animation.new(('ba_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'BODY', ay_s)
        ay_s = ay_s + 1
    end

    if refs.freestanding:get() and gs_enabled:get("Freestand") then
        ay_s = animation.new(('fs_gs'), ay_s, 0.1)
        render_inds(200, 200, 200, 255, 'FS', ay_s)
        ay_s = ay_s + 1
    end

    if refs.doubletap:get() and gs_enabled:get("Doubletap") then
        ay_s = animation.new(('dt_gs'), ay_s, 0.1)
        if (rage.exploit:get() == 1) then
            render_inds(200, 200, 200, 255, 'DT', ay_s)
        else
            render_inds(255, 0, 50, 255, 'DT', ay_s)
        end
        ay_s = ay_s + 1
    end

    if refs.dormant_aim:get() and gs_enabled:get("Dormant Aimbot") then
        ay_s = animation.new(('da_gs'), ay_s, 0.1)
        render_inds(132, 196, 20, 255, 'DA', ay_s)
        ay_s = ay_s + 1
    end
end

events.render:set(indicators)

events.aim_ack:set(function(event)
	local result = event.state
	local target = entity.get(event.target)
	if target == nil then return end
	if result == nil then
		shots.hits = shots.hits + 1
        shots.all_shots = shots.all_shots + 1
	else
		shots.misses = shots.misses + 1
        shots.all_shots = shots.all_shots + 1
	end
end)

events.cs_game_disconnected:set(function()
    shots.misses = 0
    shots.hits = 0
    shots.all_shots = 0
end)

events.nextlevel_changed:set(function()
    shots.misses = 0
    shots.hits = 0
    shots.all_shots = 0
end)

events.cs_win_panel_match:set(function()
    shots.misses = 0
    shots.hits = 0
    shots.all_shots = 0
end)

events.shutdown:set(function()
    shots.misses = 0
    shots.hits = 0
    shots.all_shots = 0
end)

clamp = function (val, min, max)
    return math.max(math.min(val, max), min)
end

lerp=function(a,b,c)c=clamp(c,0.01,1)if type(a)=='table'then local d={0,0,0,0}for e in ipairs(a)do d[e]=lerp(a[e],b[e],c)end;return d end;local f=b-a;if math.abs(f)<0.001 then return b end;return a+f*c end

local visuals = {
    indicators = {
        charge = 0,
        charge_col = { r = 255, g = 255, b = 255, a = 255 },
    },
    size = 0,
}

local amnesia_lerp = 0
local speed_mod = true

local function fade_col(col1, col2, speed)
    local r = math.floor(col1.r + (col2.r - col1.r) * speed)
    local g = math.floor(col1.g + (col2.g - col1.g) * speed)
    local b = math.floor(col1.b + (col2.b - col1.b) * speed)
    local a = math.floor(col1.a + (col2.a - col1.a) * speed)

    return { r = r, g = g, b = b, a = a }
end

local function to_hex(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end 

local charge = false
local dash_pos = 0
local dash_pos2 = 0
local dt_size = 0

local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end

local value = gram_create(0,6)

local function round(number, decimals)
	local power = 10^decimals
	return math.floor(number * power) / power
end

local ind_alias = "Kit"

local defuse_flag = esp.enemy:new_text("Defuse kit", "DEF FLAG", function(player)
    local has_defuse = player.m_bHasDefuser
    if not has_defuse then
        return
    end
    return ind_alias
end)

local group_ref = defuse_flag:create()

local slider_ref = group_ref:combo("Alias", "KIT", "DEFUSE")

slider_ref:set_callback(function(slider_ref)
    ind_alias = slider_ref:get()
end, true)

events.render:set(function(ctx)

    local lp = entity.get_local_player()

    if not globals.is_in_game then
        return
    end

    local screen = render.screen_size()

    local hello = ui.get_style("Link Active")
    local hello2 = ui.get_style("Active Text")

    local accent = menu.vis_c.misc_t.w_accent:get()
    local bgclr = menu.vis_c.misc_t.w_bgclr:get()
    local hex_accent = menu.vis_c.misc_t.w_accent:get():to_hex()

    local position = vector(screen.x * 0.5 + 1, screen.y * 0.090)

    local game_rule = entity.get_game_rules()

    local low_health = 20

    local start_time = game_rule.m_fRoundStartTime
	local round_time = game_rule.m_iRoundTime
	local round_calc = round((start_time+round_time-globals.curtime+1), 0)

    local text = " \aDEFAULTyou can \aB4FFB7FFsafely \aDEFAULTpre-smoke now! ["..round_calc.."]"
    
    local text_def = " \aDEFAULTenemy has \aFF0000EFdefuse.kit \aDEFAULTtell your teammate!"

    local measure = render.measure_text(1, "cs", text) + vector(30, 8)
    local measure2 = render.measure_text(1, "cs", text_def) + vector(30, 8)
    local middle = measure * 0.5;
    local middle2 = measure2 * 0.5;
    
    if menu.vis_c.misc_t.smoke_warn:get() and menu.vis_c.misc_t.wingman_help:get() then
        if (round_calc < 1 or round_calc > 15) then
        else
            render.shadow(position - middle - 3, position + middle + 3, accent,12, 0, 6)
            render.rect(position - middle - 3, position + middle + 3, bgclr, 6)
            render.rect_outline(position - middle - 3, position + middle + 3, accent,1.5, 6)
            render.text(1, position, hello2, "cs", "\a"..hex_accent..""..ui.get_icon("brake-warning")..text)
        end
    end

    if inds:get() == 1 and toggle_inds then
        
        local lp = entity.get_local_player()
        if lp == nil then return end
        if not lp:is_alive() then return end

        local is_moving = states:is_moving(lp)
        local is_crouching = states:is_crouching(lp)
        local in_air = states:in_air(lp)

        local state

        if aa.slow:get() then
            state = "SLOWWALK"
        elseif in_air and is_crouching then
            state = "AIR CROUCH"
        elseif in_air then
            state = "IN AIR"
        elseif is_crouching then
            state = "CROUCHING"
        elseif is_moving then
            state = "RUNNING"
        else
            state = "STANDING"
        end

        local screen_size = render.screen_size()

        local ind_height = 20

        local pos = { x = screen_size.x / 2, y = screen_size.y / 2 + ind_height }

        local frametime = globals.frametime

        local r, g, b, a = 255,0,0,255

        if rage.exploit:get() == 1 then
            charge = true
        end

        local dt_text = ""

        local dt_color = {r = 255, g = 255, b = 255, a= 255}

        local fd_on = references.fakeduck:get()

        if rage.exploit:get() == 1 then
            dt_text = "READY"
            dt_color = {r = 160, g = 235, b = 136, a= 255}
            dt_size = lerp(dt_size, 50, globals.frametime * 5)
        --elseif globals.tickcount() <= data.defensive_active_until then
        --    dt_text = "ACTIVE"
        --   dt_color = {r = 135, g = 189, b = 255, a= 255}
        --   dt_size = lerp(dt_size, 60, globals.frametime() * 5)
        elseif fd_on then
            dt_text = "BLOCKED"
            dt_color = {r = 255, g = 0, b = 0, a= 255}
            dt_size = lerp(dt_size, 90, globals.frametime * 5)
        else
            dt_text = "CHARGING"
            dt_color = {r = 255, g = 0, b = 0, a= 255}
            dt_size = lerp(dt_size, 90, globals.frametime * 5)
        end

        --local charge = data.tickbase.shifting ~= 0

        visuals.indicators.charge_col = fade_col(visuals.indicators.charge_col, dt_color, globals.frametime * 9)

        local col = {
            on = { r = r, g = g, b = b, a = 255 },
            off = { r = 255, g = 255, b = 255, a = 100 },
            main = { r = r, g = g, b = b, a = 255 },
        }

        local hex = {
            on = "\a" .. to_hex(col.on.r, col.on.g, col.on.b, col.on.a),
            off = "\a" .. to_hex(col.off.r, col.off.g, col.off.b, col.off.a),
            charge = "\a" .. to_hex(visuals.indicators.charge_col.r, visuals.indicators.charge_col.g, visuals.indicators.charge_col.b, visuals.indicators.charge_col.a),
        }

        local offset = { x = 0, y = 0 }

        local scoped = lp.m_bIsScoped

        local doubletap = references.doubletap:get()

        local hideshots = references.hideshots:get()

        local scope_fraction = ease.quad_in_out(amnesia_lerp, 0, 1, 1)
        amnesia_lerp = clamp(amnesia_lerp + (scoped and globals.frametime * 4.5 or -globals.frametime * 4.5), 0, 1)

        local text = "AMNESIA YAW"

        local ind_offset = 0

        local text_size = render.measure_text(2, "-", text)

        local state_size = render.measure_text(2, "-", state:upper())

        local scope_text = math.floor(-(text_size.x / 2) * (1 - scope_fraction) + 2 * scope_fraction)
        local scope_text2 = math.floor(-(state_size.x / 2 - 1) * (1 - scope_fraction) + 2 * scope_fraction)
        
        dash_pos = ease.quad_out(globals.frametime, dash_pos, (scope_text2 - 4.9) - dash_pos, 0.10)
        dash_pos2 = ease.quad_out(globals.frametime, dash_pos2, (scope_text2 + state_size.x - 0.7) - dash_pos2, 0.10)

        render.text(2, vector(pos.x + scope_text, pos.y), color(255, 255), nil, text)

        render.text(2, vector(pos.x + dash_pos, pos.y + 10), color(255, 255), nil, "")

        render.text(2, vector(pos.x + dash_pos2, pos.y + 10), color(255, 255, 255, 255), nil, "")

        render.text(2, vector(pos.x + scope_text2, pos.y + 10), color(255, 255, 255, 255), nil, ("%s"):format((state:upper())))

        local modifier = lp.m_flVelocityModifier
        if modifier == 1 then
            speed_mod = false
        else
            speed_mod = true
        end

        local items = {
            [1] = { active = references.doubletap:get(), text = 'DT '..hex.charge..""..dt_text, color = { r = 255, g = 255, b = 255, a = 255 } },
            [2] = { active = references.hideshots:get(), text = 'HIDESHOTS', color = { r = 255, g = 255, b = 255, a = 255 } },
            [3] = { active = aa.freestand[1]:get(), text = 'FREESTAND', color = { r = 255, g = 255, b = 255, a = 255 } },
            [4] = { active = speed_mod, text = 'SLOW: '..math.floor(modifier*100).."%", color = { r = 255, g = 255, b = 255, a = 255 } },
            [5] = { active = references.fakeduck:get(), text = 'DUCK', color = { r = 255, g = 255, b = 255, a = 255 } }
        }

        for i, bind in ipairs(items) do
            local text_size = render.measure_text(2, "-",bind.text)

            local speed = globals.frametime * 10
            local alpha = ease.quad_in_out(value[i], 0, 1, 1)
            value[i] = clamp(value[i] + (bind.active and speed or -speed), 0, 1)

            local adaptive_pos = (math.floor(text_size.x / 2) * scope_fraction) + 2 * scope_fraction

            if alpha <= 0 then
                goto skip
            end

            visuals.indicators.charge_col.a = bind.color.a * alpha

            render.text(2, vector(pos.x + 1 + adaptive_pos, pos.y + ind_offset + 26), color(bind.color.r, bind.color.g, bind.color.b, bind.color.a * alpha), "c", bind.text)
            
            ind_offset = ind_offset + 10 * alpha
            test_pos_y = ind_offset
            ::skip::
        end
    end
end)

callbacks.register("render", "aspect_ratio", handle_aspect)
callbacks.register("shutdown", "aspect_ratio", aspect_ratio_destroy)

events.aim_ack:set(function(e)
    aimbot_logs:aim_ack(e);
end);

events.player_hurt:set(function(e)
    aimbot_logs:player_hurt(e);
end);

events.render:set(function()
    notify:draw();
end);

pui.setup({menu.home, menu.aa_builder, menu.vis_c})

