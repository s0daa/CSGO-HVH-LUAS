-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

--      Aversion ☆ Neverlose
--     Askard & lordmouse. 2024

-- #region : References
files.create_folder("aversion")
local ffi = require("ffi")
ffi.cdef[[
    bool URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
]]

local file = {}
file.urlmon = ffi.load('UrlMon')
file.wininet = ffi.load('WinInet')
file.download_file_from_url = function(from, to)
file.wininet.DeleteUrlCacheEntryA(from)
file.urlmon.URLDownloadToFileA(nil, from, to, 0, 0)
end

for i = 1, 2 do
    local read = files.read("aversion\\Lora.ttf")
    if read == nil then 
        file.download_file_from_url('https://cdn.discordapp.com/attachments/1263223913123545190/1283834209852457061/Lora.ttf?ex=66e46f48&is=66e31dc8&hm=9167a5d878a1591a31cf74b4e3601943e9e8b8b703fbec68ed1b8527495dcacc&', "aversion\\Lora.ttf") 
    end

    if read == true then 
        file.wininet.DeleteUrlCacheEntryA('aversion\\Lora.ttf') 
    end
end
local drag_system = require("neverlose/drag_system")
local pui = require("neverlose/pui")
local style = ui.get_style "Link Active"
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local style_hex = style:to_hex()
local aversion, anti_aim, menu = {}, {}, {}
local tables = {}
local engine_client = ffi.cast(ffi.typeof('void***'), utils.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])
tables.distribute = function (t, r, k) local result = {} for i, v in ipairs(t) do local n = k and v[k] or i result[n] = r == nil and i or v[r] end return result end

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
    extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    force_baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    force_safety = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    dormant_aim = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot") 
}

HEXtoRGB = {
    r = function (hex)
        hex = string.gsub(hex, "^#", "")
    
        r = tonumber(string.sub(hex, 1, 2), 16)
        return r
    end,
    g = function (hex)
        hex = string.gsub(hex, "^#", "")
    
        g = tonumber(string.sub(hex, 3, 4), 16)
        return g
    end,
    b = function (hex)
        hex = string.gsub(hex, "^#", "")
    
        b = tonumber(string.sub(hex, 5, 6), 16)
        return b
    end
}

local messages = {}

local function custom_print(text)
    table.insert(messages, {text = text, start_time = globals.realtime})
end

local function render_print_text()
    local text_duration = 3  -- длительность отображения текста (в секундах)
    local fade_duration = 1   -- длительность анимации исчезновения текста (в секундах)

    for i, message in ipairs(messages) do
        local elapsed_time = globals.realtime - message.start_time

        if elapsed_time > text_duration + fade_duration then
            table.remove(messages, i)
        else
            local alpha = 255
            if elapsed_time > text_duration then
                alpha = 255 - ((elapsed_time - text_duration) / fade_duration * 255)
            end

            render.text(1, vector(5, 5 + (i - 1) * 15), color(255, 255, 255, alpha), nil, message.text)
        end
    end
end
-- #endregion

pui.sidebar("aversion \a6C6C6CFF• \v\f<brackets-curly>", "\f<gem>")

-- #region - Aversion
local script = {
    name = "Aversion",
	version = "Beta",
	user = {
		name = common.get_username(),
	},
    socials = {
        discord = "https://discord.gg/6paE3cS6E5",
        youtube = "https://youtube.com/@lordmouse",
        forms = "",
        github = "https://github.com/impess"
    }
}
-- #endregion

-- #region : UI

local tabs = {
    config = pui.create("\f<eye>", "\f<gear> » Config", 2),
    main1 = pui.create("\f<eye>", "", 1),
    links = pui.create("\f<eye>", "\f<rss> » Links ", 2),
    antiselect = pui.create("\f<eye-low-vision>", "\f<ballot-check> » Condition     ", 1),
    antisel = pui.create("\f<eye-low-vision>", "\f<star> » Select     ", 1),
    anti1 = pui.create("\f<eye-low-vision>", "\f<star> » Main     ", 1),
    configs = pui.create("\f<eye-low-vision>", "\f<layer-plus> »  Config System     ", 2),
    anti2 = pui.create("\f<eye-low-vision>", "\f<sliders> » Builder ", 2),
    antid = pui.create("\f<eye-low-vision>", "\f<eye-low-vision> » Defensive   ", 1),
    antib = pui.create("\f<eye-low-vision>", "\f<sliders-up> » Anti-Bruteforce   ", 1),
    logic = pui.create("\f<eye-low-vision>", "\f<diagram-venn> » Logic", 2),
    misc = pui.create("\f<eye-evil>", "", 1),
    misc2 = pui.create("\f<eye-evil>", "\f<gear> » Misc ", 2),
    mod = pui.create("\f<eye-evil>", "\f<star> » Modifications ", 2),
    visuals_2 = pui.create("\f<eye-evil>", "\f<rocket> » Visuals  ", 1),
    ragest = pui.create("\f<eye-evil>", "\f<rocket> » Rage  ", 2),
    widgets = pui.create("\f<eye-evil>", "\f<eye> » Widgets", 2),
    visuals = pui.create("\f<eye-evil>", "\f<cube> » Indicators", 1),
    inter = pui.create("\f<eye-evil>", "\f<rocket> » Interface ", 2),
}

anti_aim.states = {
    {"global", "Global", "G"}, -- как использовать: tables.distribute(anti_aim.states, 1) будет принтить "global", 2 - "Global", 3 - "G"
    {"stand", "Standing", "S"}, 
    {"run", "Running", "R"},
    {"walk", "Walking", "W"},
    {"crouch", "Ducking", "C"},   
    {"air", "Air", "A"}, 
    {"airduck", "Air Crouch", "A+C"}, 
    {"fakelag", "Fake Lag", "FL"},
    {"manual", "Manual", "ML"},
}

local enums = {
    logic = {
        states = tables.distribute(anti_aim.states, nil, 1),
    },
    states = tables.distribute(anti_aim.states, nil, 1),
    name_states = tables.distribute(anti_aim.states, 2),
    short_states = tables.distribute(anti_aim.states, 3),
}

menu.info = {
    script = {
        welcome = tabs.main1:label(" »   Welcome, \v" .. script.user.name),
        version = tabs.main1:label(" »   Version - \v" .. script.version),
    },
    ad = {
        discord = tabs.links:button("          \f<discord>          ",function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(script.socials.discord)
        end, true),
        github = tabs.links:button("          \f<github>          ",function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(script.socials.github)
        end, true),
        youtube = tabs.links:button("         \f<youtube>          ",function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(script.socials.youtube)
        end, true),
        advert = tabs.main1:label("With our script you make your opponents admire you for our technology. \n\v© 2024 Aversion")
    }
}

menu.antiaim = {
    select = {
        select_tab = tabs.antisel:list("", {"Main", "Builder", "Logical"})
    },
    condition = {
        condition = tabs.anti2:combo("Condition", enums.name_states),
    },
    main = {
        custom_yaw_base = tabs.anti1:combo("\v\f<caret-right>\r  Yaw Base", {"Backward", "At Target", "Forward", "Left", "Right"}),
        freestand = tabs.anti1:switch("\v\f<caret-right>\r  Freestanding"),
        anims = tabs.anti1:switch("\v\f<caret-right>\r  Animation Breaker"),
    },
    additions = {
        additions = tabs.anti1:selectable("\v\f<caret-right>\r  Additions", {"Shit AA On Warmup", "Anti-Backstab"}),
    },
    logic = {
        enable = tabs.logic:switch("\v\f<xmarks-lines>\r  Enable [W.I.P]")
    }
}

freestand_create = menu.antiaim.main.freestand:create()
anims_create = menu.antiaim.main.anims:create()
menu.antiaim.second = {
    main = {
        staticfrees = freestand_create:listable("Disablers", {"Jitter", "Defensive"}),
    },
    breaker = {
        groundbreaker = anims_create:combo("Ground", {"Off", "Jitter", "MoonWalk"}),
        airbreaker = anims_create:combo("Air", {"Off", "Static Legs In Air", "MoonWalk"}),
        othbreaker = anims_create:selectable("Addons", {"Pitch 0 On Land", "Move Lean", "Jitter Head"})
    }
}

menu.rage = {
    main = {
        unlocklatency = tabs.ragest:switch("\v\f<cube>  \rFake latency unlock"),
    },
    adaptivehit = tabs.ragest:switch("\v\f<transporter-1> \rAdjust hitchance in air", false, function(gear)
        return {
            multisel = gear:selectable("Weapon", {"Scout", "R8", "AutoSnipers"}),
            scout = gear:slider("Scout", 0, 100, 45, 1, "%"),
            r8 = gear:slider("R8", 0, 100, 50, 1, "%"),
            scar = gear:slider("Scar", 0, 100, 30, 1, "%"),
        }
    end),
}

menu.visual = {
    list = tabs.misc:list("", {" Rage", " Visual", " Misc", " Features"}),
    indicators = {
        color = tabs.widgets:color_picker("Color", color()),
        cross = tabs.visuals:switch("\v\f<crosshairs-simple> \rCrosshair Indicators", false, function(gear)
            return {
                offset = gear:slider("Y Offset", 0, 200, 0),
            }
        end),
        manual = tabs.visuals:switch("\v\f<arrows-spin> \rManuals", false, function(gear)
            return {
                style = gear:combo("Style", "V1", "V2")
            }
        end),
        velocity_indicator_enable = tabs.widgets:switch("\v\f<triangle-exclamation>  \rSlowed Down Indicator")
    },
    other = {
        logs = tabs.widgets:switch("\v\f<blog>   \rRagebot logs", false, function(gear)
            return {
                settings = gear:listable("", {"Console", "Event", "Screen"}),
            }
        end, "‼ This function take the color from your menu style."),
        scope = tabs.visuals:switch("\v\f<crosshairs> \rCustom Scope", false, function(gear)
            return {
                inverted = gear:switch("Invert scope lines", false),
                length = gear:slider("Scope length", 5, 200, 55),
                offset = gear:slider("Scope offset", 1, 50, 11),
                color = gear:color_picker("Scope Сolor",color(255,255))
            }
        end),
        mindmg = tabs.visuals:switch("\v\f<eye> \rMin DMG Indicator"),
    },
    vgui = tabs.widgets:switch("\v\f<square-terminal>  \rVGUI", false, function(gear)
        return{
            vguicol = gear:color_picker("Color", color(255, 255))
        }
    end),
}

menu.misc = {
    first = {
        viewmodel = tabs.misc2:switch("\v\f<hands-holding>\r  Viewmodel"),
        clantag = tabs.misc2:switch("\v\f<tag>\r   Clantag"),
        aspect = tabs.misc2:switch("\v\f<eye>\r  Aspect ratio"),
    },

    dva = {
        no_fall_damage = tabs.mod:switch("\v\f<person-falling>\r    No Fall Damage"),
        fast_ladder = tabs.mod:switch("\v\f<water-ladder>\r   Fast Ladder"),
        nade_fix = tabs.mod:switch("\v\f<bomb>\r   Nade Fix"),
        avoidcol = tabs.mod:switch("\v\f<person-walking-arrow-loop-left>\r  Avoid Collision", false, function(gear)
            return {
                dist = gear:slider("Radius", 0, 10, 0)
            }
        end),
    },
}

viewmodel_ref = menu.misc.first.viewmodel:create()
aspectratio_ref = menu.misc.first.aspect:create()
menu.misc.second = {
    viewmodel = {
        fov = viewmodel_ref:slider("FOV", -100, 100, 68),
        x = viewmodel_ref:slider("X", -100, 100, 2.5),
        y = viewmodel_ref:slider("Y", -10, 10, 0),
        z = viewmodel_ref:slider("Z", -10, 10, -1.5),
        default = viewmodel_ref:button("Default", function()
            menu.misc.second.viewmodel.fov:set(68)
            menu.misc.second.viewmodel.x:set(2.5)
            menu.misc.second.viewmodel.y:set(0)
            menu.misc.second.viewmodel.z:set(-1.5)
            cvar.viewmodel_fov:int(68)
            cvar.viewmodel_offset_x:float(2.5)
            cvar.viewmodel_offset_y:float(0)
            cvar.viewmodel_offset_z:float(-1.5)
        end, true),
        preset = viewmodel_ref:button("Preset", function()
            menu.misc.second.viewmodel.fov:set(70)
            menu.misc.second.viewmodel.x:set(1)
            menu.misc.second.viewmodel.y:set(-8)
            menu.misc.second.viewmodel.z:set(-1)
        end, true)
        -- switchknife = viewmodel_ref:switch("Switch knife on hand"),
    },
    
    ratio = {
        value = aspectratio_ref:slider("Value", 0, 200, 0)
    }
}

local ratios = {
    ["16:10"] = 160,
    ["16:9"] = 180,
    ["5:4"] = 125,
    ["4:3"] = 133,
    ["3:2"] = 150
}

for ratio, value in pairs(ratios) do
    aspectratio_ref:button(" " .. ratio .. " ", function()
        menu.misc.second.ratio.value:set(value)
    end, true):depend(menu.misc.first.aspect)
end

-- #endregion

local hide_func = function (value)
    value = not value
    ref.enable:disabled(value) 
    ref.pitch:disabled(value)
    ref.yaw:disabled(value)
    ref.yawmod:disabled(value)
    ref.bodyyaw:disabled(value)
    ref.freestand:disabled(value)
    ref.extended_angles:disabled(value)
end

-- #region : Anti-aim
aa_condition = {}
for z, x in pairs(enums.name_states) do
    aa_condition[z] = {}
    aa_condition[z].logic_enabled = tabs.anti2:label("Disable \vLogic\r Anti-Aim!")
    aa_condition[z].enable = tabs.anti2:switch("❕ Override \v"..enums.name_states[z].."\r Condition")
    aa_condition[z].yaw_type = tabs.anti2:combo("\v" .. enums.short_states[z].."\r → Yaw Type", {"Default", "Delay Switch"})
    aa_condition[z].delay_ticks = tabs.anti2:slider("\v" .. enums.short_states[z].."\r → Delay \rTicks", 1, 30, 0, 1, "t")
    aa_condition[z].yaw_l = tabs.anti2:slider("\v" .. enums.short_states[z].."\r → Yaw \rLeft", -180, 180, 0, 1, "°")
    aa_condition[z].yaw_r = tabs.anti2:slider("\v" .. enums.short_states[z].."\r → Yaw \rRight", -180, 180, 0, 1, "°")
    aa_condition[z].jit_type = tabs.anti2:combo("\v" .. enums.short_states[z].."\r → Jitter \rType", ref.yawmod:list())
    aa_condition[z].jitter_center = tabs.anti2:slider("\v" .. enums.short_states[z].."\r → Amount", -180, 180, 0, 1, "°")
    aa_condition[z].bodyyaw = tabs.anti2:switch("\v" .. enums.short_states[z].."\r → Body Yaw")
    
    local bodyyaw_group = aa_condition[z].bodyyaw:create()
    aa_condition[z].options = bodyyaw_group:selectable(enums.short_states[z].."\rOptions", ref.options:list())
    aa_condition[z].lby_l = bodyyaw_group:slider("\v" .. enums.short_states[z].."\r → Desync \rLeft", 0, 60, 60, 1, "°")
    aa_condition[z].lby_r = bodyyaw_group:slider("\v" .. enums.short_states[z].."\r → Desync \rRight", 0, 60, 60, 1, "°")

    aa_condition[z].def_type = tabs.anti2:combo("\v" .. enums.short_states[z].."\r → Defensive", {"On Peek", "Always On", "Only On DT"})
    aa_condition[z].def_aa = tabs.antid:switch("\v" .. enums.short_states[z].."\r → Enable Defensive AA")
    aa_condition[z].def_yaw_type = tabs.antid:combo("\v" .. enums.short_states[z].."\r → Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "Spin", "X-Way", "Custom"})
    aa_condition[z].def_yaw_create = aa_condition[z].def_yaw_type:create()

    aa_condition[z].def_side = aa_condition[z].def_yaw_create:slider("Degree", -180, 180, 0, 1, "°")
    aa_condition[z].def_min = aa_condition[z].def_yaw_create:slider("Random Minimum", -50, 50, 20)
    aa_condition[z].def_max = aa_condition[z].def_yaw_create:slider("Random Maximum", -50, 50, 20)
    aa_condition[z].def_sens = aa_condition[z].def_yaw_create:slider("Sensitivity", 0, 100, 50)
    aa_condition[z].def_xway = aa_condition[z].def_yaw_create:slider("Ways", 2, 7, 2)
    for i = 1, 7 do
        aa_condition[z]["def_" .. i .. "way"] = aa_condition[z].def_yaw_create:slider(i .. " Degree", -180, 180, 0, 1, "°")
    end
    aa_condition[z].def_pitch_type = tabs.antid:combo("\v" .. enums.short_states[z].."\r → Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})
    
    aa_condition[z].def_pitch_create = aa_condition[z].def_pitch_type:create()
    aa_condition[z].def_pitch = aa_condition[z].def_pitch_create:slider("\v" .. enums.short_states[z].."\r → Amount", -89, 89, 0, 1, "°")

    aa_condition[z].ab_enable = tabs.antib:switch("\v" .. enums.short_states[z].."\r → Anti-Bruteforce")
    aa_condition[z].ab_phases = tabs.antib:slider("Phases", 1, 3, 1)
    aa_condition[z].ab_phases:visibility(false)
    aa_condition[z].add_phases = tabs.antib:button(ui.get_icon('plus').."       Add Phase       "..ui.get_icon('plus'),function()
        aa_condition[z].ab_phases:set(aa_condition[z].ab_phases:get() + 1)
    end, true) 

    aa_condition[z].rem_phases = tabs.antib:button(ui.get_icon('minus').."  Remove Phase  "..ui.get_icon('minus'),function()
        aa_condition[z].ab_phases:set(aa_condition[z].ab_phases:get() - 1)
    end, true) 

    for i = 1, 3 do
        local phase_label = tabs.antib:label(enums.short_states[z].."\r → Phase " .. i)
        local phase_group = phase_label:create()

        aa_condition[z]["ab_phase" .. i] = phase_label
        aa_condition[z]["ab_create" .. i] = phase_group
        aa_condition[z]["ab_select" .. i] = phase_group:selectable("", {"Yaw", "Desync", "Defensive"})
        aa_condition[z]["ab_yaw_type" .. i] = phase_group:combo(enums.short_states[z].."\r → Yaw Type", {"Default", "Delay Switch"})
        aa_condition[z]["ab_delay_ticks" .. i] = phase_group:slider(enums.short_states[z].."\r → Delay Ticks", 1, 30, 0, 1, "°")
        aa_condition[z]["ab_yaw_l" .. i] = phase_group:slider(enums.short_states[z].."\r → Yaw Left", -180, 180, 0, 1, "°")
        aa_condition[z]["ab_yaw_r" .. i] = phase_group:slider(enums.short_states[z].."\r → Yaw Right", -180, 180, 0, 1, "°")
        aa_condition[z]["ab_lby_l" .. i] = phase_group:slider(enums.short_states[z].."\r → Desync Left", 0, 60, 60, 1, "°")
        aa_condition[z]["ab_lby_r" .. i] = phase_group:slider(enums.short_states[z].."\r → Desync Right", 0, 60, 60, 1, "°")
        aa_condition[z]["ab_def_type" .. i] = phase_group:combo(enums.short_states[z].."\r → Defensive", {"On Peek", "Always On", "Only On DT"})
        aa_condition[z]["ab_def_yaw_type" .. i] = phase_group:combo(enums.short_states[z].."\r → Yaw Type", {"Off", "Default", "Side-Way", "Random Way", "180Z", "Spin", "X-Way", "Custom"})
        aa_condition[z]["ab_def_pitch_type" .. i] = phase_group:combo(enums.short_states[z].."\r → Pitch Type", {"Off", "Default", "Custom", "Random", "Progressive", "Switch Way", "Alternative"})
    end
end
----config manager
local config_cfg = pui.setup({aa_condition}, true)
local cfg_system = { }
configs_db = db.configs_debug or { }
configs_db.cfg_list = configs_db.cfg_list or {{'Default', 'W1t7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo4LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjUxLjAsImFiX2xieV9sMiI6NTEuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjUyLjAsImFiX2xieV9yMiI6NDIuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMzQuMCwiYWJfeWF3X2wyIjotMzMuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MzguMCwiYWJfeWF3X3IyIjozNy4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjowLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjowLjAsImRlZl80d2F5IjowLjAsImRlZl81d2F5IjowLjAsImRlZl82d2F5IjowLjAsImRlZl83d2F5IjowLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6LTIwLjAsImRlZl9taW4iOi01MC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJBbHRlcm5hdGl2ZSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiIxODBaIiwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6MzQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotNzMuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIkFudGkgQnJ1dGVmb3JjZSIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6Ni4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfbGJ5X2wxIjo0OC4wLCJhYl9sYnlfbDIiOjQyLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo1MC4wLCJhYl9sYnlfcjIiOjQ2LjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoyLjAsImFiX3NlbGVjdDEiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QyIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6LTMwLjAsImFiX3lhd19sMiI6LTI3LjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjQxLjAsImFiX3lhd19yMiI6MzguMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMiI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxOC4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo1OC4wLCJsYnlfciI6NTcuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzYuMCwieWF3X3IiOjQxLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6ZmFsc2UsImRlZl8xd2F5IjowLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjowLjAsImRlZl80d2F5IjowLjAsImRlZl81d2F5IjowLjAsImRlZl82d2F5IjowLjAsImRlZl83d2F5IjowLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3h3YXkiOjIuMCwiZGVmX3lhd190eXBlIjoiT2ZmIiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOjAuMCwiZGVmXzR3YXkiOjAuMCwiZGVmXzV3YXkiOjAuMCwiZGVmXzZ3YXkiOjAuMCwiZGVmXzd3YXkiOjAuMCwiZGVmX2FhIjp0cnVlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOi02Mi4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6NTguMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiJTaWRlLVdheSIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xOS4wLCJ5YXdfciI6MzkuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOjAuMCwiZGVmXzR3YXkiOjAuMCwiZGVmXzV3YXkiOjAuMCwiZGVmXzZ3YXkiOjAuMCwiZGVmXzd3YXkiOjAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo3LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjQ2LjAsImFiX2xieV9sMiI6NDkuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjQwLjAsImFiX2xieV9yMiI6NDQuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMjAuMCwiYWJfeWF3X2wyIjotMjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6NDIuMCwiYWJfeWF3X3IyIjo0MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjotMTgwLjAsImRlZl8yd2F5IjoxODAuMCwiZGVmXzN3YXkiOi05My4wLCJkZWZfNHdheSI6OTMuMCwiZGVmXzV3YXkiOi02MC4wLCJkZWZfNndheSI6NjAuMCwiZGVmXzd3YXkiOi00NC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjowLjAsImRlZl9taW4iOjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjEwMC4wLCJkZWZfc2lkZSI6MjAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Ny4wLCJkZWZfeWF3X3R5cGUiOiJYLVdheSIsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU3LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0yMS4wLCJ5YXdfciI6NDQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiIzLVdheSIsImppdHRlcl9jZW50ZXIiOjI5LjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOnRydWUsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo2MC4wLCJkZWZfc2lkZSI6MTgwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6IlNpZGUtV2F5IiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifV1d'}}
configs_db.menu_list = configs_db.menu_list or {'Default'}

configs_db.cfg_list[1][2] = "W1t7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo4LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjUxLjAsImFiX2xieV9sMiI6NTEuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjUyLjAsImFiX2xieV9yMiI6NDIuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMzQuMCwiYWJfeWF3X2wyIjotMzMuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MzguMCwiYWJfeWF3X3IyIjozNy4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjowLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjowLjAsImRlZl80d2F5IjowLjAsImRlZl81d2F5IjowLjAsImRlZl82d2F5IjowLjAsImRlZl83d2F5IjowLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6LTIwLjAsImRlZl9taW4iOi01MC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJBbHRlcm5hdGl2ZSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiIxODBaIiwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0zMC4wLCJ5YXdfciI6MzQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjotNzMuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIkFudGkgQnJ1dGVmb3JjZSIsIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6Ni4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfbGJ5X2wxIjo0OC4wLCJhYl9sYnlfbDIiOjQyLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo1MC4wLCJhYl9sYnlfcjIiOjQ2LjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoyLjAsImFiX3NlbGVjdDEiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QyIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6LTMwLjAsImFiX3lhd19sMiI6LTI3LjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjQxLjAsImFiX3lhd19yMiI6MzguMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMiI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxOC4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo1OC4wLCJsYnlfciI6NTcuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzYuMCwieWF3X3IiOjQxLjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6ZmFsc2UsImRlZl8xd2F5IjowLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjowLjAsImRlZl80d2F5IjowLjAsImRlZl81d2F5IjowLjAsImRlZl82d2F5IjowLjAsImRlZl83d2F5IjowLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3h3YXkiOjIuMCwiZGVmX3lhd190eXBlIjoiT2ZmIiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOjAuMCwiZGVmXzR3YXkiOjAuMCwiZGVmXzV3YXkiOjAuMCwiZGVmXzZ3YXkiOjAuMCwiZGVmXzd3YXkiOjAuMCwiZGVmX2FhIjp0cnVlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOi02Mi4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6NTguMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiJTaWRlLVdheSIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU4LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0xOS4wLCJ5YXdfciI6MzkuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3IjpmYWxzZSwiZGVmXzF3YXkiOjAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOjAuMCwiZGVmXzR3YXkiOjAuMCwiZGVmXzV3YXkiOjAuMCwiZGVmXzZ3YXkiOjAuMCwiZGVmXzd3YXkiOjAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeHdheSI6Mi4wLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOmZhbHNlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo3LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjQ2LjAsImFiX2xieV9sMiI6NDkuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjQwLjAsImFiX2xieV9yMiI6NDQuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMjAuMCwiYWJfeWF3X2wyIjotMjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6NDIuMCwiYWJfeWF3X3IyIjo0MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjotMTgwLjAsImRlZl8yd2F5IjoxODAuMCwiZGVmXzN3YXkiOi05My4wLCJkZWZfNHdheSI6OTMuMCwiZGVmXzV3YXkiOi02MC4wLCJkZWZfNndheSI6NjAuMCwiZGVmXzd3YXkiOi00NC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjowLjAsImRlZl9taW4iOjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiQ3VzdG9tIiwiZGVmX3NlbnMiOjEwMC4wLCJkZWZfc2lkZSI6MjAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeHdheSI6Ny4wLCJkZWZfeWF3X3R5cGUiOiJYLVdheSIsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjU3LjAsImxieV9yIjo1OC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOi0yMS4wLCJ5YXdfciI6NDQuMCwieWF3X3R5cGUiOiJEZWxheSBTd2l0Y2gifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6MS4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NjAuMCwiYWJfbGJ5X2wyIjo2MC4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NjAuMCwiYWJfbGJ5X3IyIjo2MC4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIn4iXSwiYWJfc2VsZWN0MiI6WyJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOjAuMCwiYWJfeWF3X2wyIjowLjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjAuMCwiYWJfeWF3X3IyIjowLjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUyIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiIzLVdheSIsImppdHRlcl9jZW50ZXIiOjI5LjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6MC4wLCJkZWZfNHdheSI6MC4wLCJkZWZfNXdheSI6MC4wLCJkZWZfNndheSI6MC4wLCJkZWZfN3dheSI6MC4wLCJkZWZfYWEiOnRydWUsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6IkN1c3RvbSIsImRlZl9zZW5zIjo2MC4wLCJkZWZfc2lkZSI6MTgwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl94d2F5IjoyLjAsImRlZl95YXdfdHlwZSI6IlNpZGUtV2F5IiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MC4wLCJ5YXdfciI6MC4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifV1d"
cfg_system.save_config = function(id)
    if id == 1 then return end
    local raw = config_cfg:save()
    configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
    cvar.play:call("ambient\\tones\\elev1")
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
    for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then common.add_notify('[Aversion]', 'Change Name') return end end
    if #configs_db.cfg_list > 6 then common.add_notify('[Aversion]', 'Too Much Configs') return end
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
    cfg_selector = tabs.configs:list('', configs_db.menu_list):depend({menu.antiaim.select.select_tab, 1}),
    name = tabs.configs:input(ui.get_icon('input-text')..'  Config Name', ''):depend({menu.antiaim.select.select_tab, 1}),
    
    create = tabs.configs:button("\f<layer-plus>\v Create", function()
        cfg_system.create_config(configs.name:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend( {menu.antiaim.select.select_tab, 1}),
    
    remove  = tabs.configs:button("       \f<trash-xmark>       ", function()
        cfg_system.remove_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend( {menu.antiaim.select.select_tab, 1}),
    
    save = tabs.configs:button("       \f<floppy-disk>       ", function()
        cfg_system.save_config(configs.cfg_selector:get())
    end, true):depend( {menu.antiaim.select.select_tab, 1}),
    load = tabs.configs:button("\f<check>\v Load", function()
        cfg_system.update_values(configs.cfg_selector:get())
        cfg_system.load_config(configs.cfg_selector:get())
        configs.cfg_selector:update(configs_db.menu_list)
    end, true):depend( {menu.antiaim.select.select_tab, 1}),
    
    import = tabs.configs:button("\f<download>\v    Import Config   ", function()
        config_cfg:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true):depend( {menu.antiaim.select.select_tab, 1}),
    
    export = tabs.configs:button("\f<share-nodes>\v     Export Config  ", function()
        clipboard.set(base64.encode(json.stringify(config_cfg:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true):depend( {menu.antiaim.select.select_tab, 1})
}

local id = 0
local ab_cond = 0
local currentphase = 0
ab_check = false
abtime = globals.realtime
antibrute_time_last = globals.realtime
events.bullet_impact:set(function(e)
    if entity.get_local_player() == nil or not entity.get_local_player():is_alive() then 
        return 
    end

    if menu.antiaim.logic.enable:get() then 
        return 
    end

    local player = entity.get(e.userid, true)
    if not player:is_enemy() then 
        return 
    end

    playerb = entity.get_local_player()
    if entity.get_threat(true) == nil then 
        return 
    end

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
        if ab_check == true and menu.visual.other.logs.settings:get(2) then
            custom_print(("ab angle switched due to %s / phase: %s"):format(player:get_name():lower(), currentphase))
        end
        if ab_check == true and menu.visual.other.logs.settings:get(1) then
            print(("ab angle switched due to %s / phase: %s"):format(player:get_name():lower(), currentphase))
        end
    end
end)

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

anti_aim.get_player_state = function(ent)
    if not ent then 
        return "Not connected" 
    end

    anti_aim.in_air()

    on_ground = bit.band(ent.m_fFlags, 1) == 1
    jump = end_time > (globals.curtime + 0.9)
    crouch = ent.m_flDuckAmount > 0.7 or ref.fd:get()
    vx, vy, vz = ent.m_vecVelocity.x, ent.m_vecVelocity.y, ent.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5
    if menu.antiaim.main.custom_yaw_base:get() == "Left" or menu.antiaim.main.custom_yaw_base:get() == "Right" or  menu.antiaim.main.custom_yaw_base:get() == "Forward" then
        return enums.states.manual
    end
    if aa_condition[8].enable:get() and rage.exploit:get() < 0.9 then
        return enums.states.fakelag
    end
    if aa_condition[7].enable:get() and jump and crouch then 
        return enums.states.airduck 
    end
    if aa_condition[6].enable:get() and jump then 
        return enums.states.air 
    end
    if aa_condition[5].enable:get() and crouch then 
        return enums.states.crouch
    end
    if aa_condition[4].enable:get() and on_ground and ref.slow:get() and move then 
        return enums.states.walk
    end
    if aa_condition[3].enable:get() and on_ground and move and not ref.slow:get() then 
        return enums.states.run
    end
    if aa_condition[2].enable:get() and on_ground and not move then 
        return enums.states.stand 
    end
    if not aa_condition[2].enable:get() or not aa_condition[3].enable:get() or not  aa_condition[4].enable:get() or not aa_condition[5].enable:get() or not aa_condition[6].enable:get() or not aa_condition[7].enable:get() or not aa_condition[8].enable:get() then
        return enums.states.global
    end
end

anti_aim.get_player_state_logic = function(ent)
    if not ent then 
        return "Not connected" 
    end

    anti_aim.in_air()

    on_ground = bit.band(ent.m_fFlags, 1) == 1
    jump = end_time > (globals.curtime + 0.9)
    crouch = ent.m_flDuckAmount > 0.7 or ref.fd:get()
    vx, vy, vz = ent.m_vecVelocity.x, ent.m_vecVelocity.y, ent.m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5
    if menu.antiaim.main.custom_yaw_base:get() == "Left" or menu.antiaim.main.custom_yaw_base:get() == "Right" or  menu.antiaim.main.custom_yaw_base:get() == "Forward" then
        return enums.logic.states.manual
    end
    if rage.exploit:get() < 0.9 then
        return enums.logic.states.fakelag
    end
    if jump and crouch then 
        return enums.logic.states.airduck 
    end
    if jump then 
        return enums.logic.states.air 
    end
    if crouch then 
        return enums.logic.states.crouch
    end
    if on_ground and ref.slow:get() and move then 
        return enums.logic.states.walk
    end
    if on_ground and move and not ref.slow:get() then 
        return enums.logic.states.run
    end
    if on_ground and not move then 
        return enums.logic.states.stand 
    end
end

local get_side_help = false
anti_aim.get_side = function(delay, lp)
    if delay == nil or delay == 0 then
        return (entity.get_local_player().m_flPoseParameter[11] * 120 - 60) > 0
    else
        if globals.tickcount % delay == 0 then
            get_side_help = not get_side_help
        end
        return get_side_help
    end
end

anti_aim.side = "none"
anti_aim.antiaim_setup = function(cmd)
    if menu.antiaim.logic.enable:get() then return end
    local_player = entity.get_local_player()
    id = anti_aim.get_player_state(local_player)

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

    ref.pitch:set("Down")
    ref.yaw:set("Backward")
    ref.yawmod:set(aa_condition[id].jit_type:get())
    ref.yawoff:override(aa_condition[id].jitter_center:get())
    ref.bodyyaw:set(aa_condition[id].bodyyaw:get())
    ref.options:set(aa_condition[id].options:get())
    ref.freestanding:set("Off")
    ref.left_limit:set(desync_left)
    ref.right_limit:set(desync_right)

    lp_bodyyaw = rage.antiaim:inverter()
    yaw_add_l = yaw_left
    yaw_add_r = yaw_right
    yaw_d = lp_bodyyaw and yaw_add_l or yaw_add_r
    -- tick_var = globals.tickcount
    
    -- if globals.tickcount -  >tick_var 0 and cmd.chokedcommands == 0 then
    --     chokereversed = not chokereversed
    -- end

    if yaw_type == "Default" then
        ref.yawoffset:set(yaw_d)
        ref.inverter:set(false)
    else
        -- ref.yawoffset:set(chokerev(yaw_left, yaw_right))     
        ticks = yaw_tick/2
        switch = (globals.server_tick %(8+ticks) > 4+ticks/2)
        if cmd.send_packet == true and cmd.choked_commands < 1 then
            ref.yawoffset:set(switch and yaw_add_l or yaw_add_r)
            ref.inverter:set(switch)
        end
    end

    ref.hidden:set(aa_condition[id].def_aa:get())

    if def_type == "On Peek" then
        ref.lag:override("On Peek")
        ref.hsopt:override("Favor Fire Rate")
    elseif def_type == "Always On" then
        ref.lag:override("Always On")
        ref.hsopt:override("Break LC")
    elseif def_type == "Only On DT" then
        ref.lag:override("Always On")
        ref.hsopt:override("Favor Fire Rate")
    end

    anti_aim.side = anti_aim.get_side(0, lp)
    anti_aim.side = anti_aim.side and "right" or "left"

    if aa_condition[id].def_aa:get() then
        if def_yaw_type == "Side-Way" then
            if anti_aim.side == "left" then 
                rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_side:get())
            elseif anti_aim.side == "right" then
                rage.antiaim:override_hidden_yaw_offset(-aa_condition[id].def_side:get())
            elseif anti_aim.side == "none" then
                rage.antiaim:override_hidden_yaw_offset(0)
            end
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
        elseif aa_condition[id].def_yaw_type:get() == "Spin" then
            if yawadd >= 180 then
                yawadd = -180
            else
                yawadd = yawadd + aa_condition[id].def_side:get()
            end
            rage.antiaim:override_hidden_yaw_offset(yawadd)
        elseif def_yaw_type == "X-Way" then
            local xway = aa_condition[id].def_xway:get()

            if xway >= 1 and xway <= 7 then
                local tick_offset = xway+1
            
                if globals.tickcount % tick_offset == 0 and xway >= 1 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_1way:get())
                elseif globals.tickcount % tick_offset == 1 and xway >= 2 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_2way:get())
                elseif globals.tickcount % tick_offset == 2 and xway >= 3 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_3way:get())
                elseif globals.tickcount % tick_offset == 3 and xway >= 4 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_4way:get())
                elseif globals.tickcount % tick_offset == 4 and xway >= 5 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_5way:get())
                elseif globals.tickcount % tick_offset == 5 and xway >= 6 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_6way:get())
                elseif globals.tickcount % tick_offset == 6 and xway >= 7 then
                    rage.antiaim:override_hidden_yaw_offset(aa_condition[id].def_7way:get())
                end
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
        end
    end
end
for z, x in pairs(enums.name_states) do
    enaa = {aa_condition[z].enable, function() if(z == 1) then return true else return aa_condition[z].enable:get() end end}
    manuals = {aa_condition[z].enable, function() if(z == 9) then return false else return true end end}
    fakelags = {aa_condition[z].enable, function() if(z == 8) then return false else return true end end}
    logic, logic2 = {menu.antiaim.logic.enable, function() if not menu.antiaim.logic.enable:get() then return false else return true end end}, {menu.antiaim.logic.enable, function() if menu.antiaim.logic.enable:get() then return false else return true end end}
    need_select = {menu.antiaim.condition.condition, enums.name_states[z]}
    tab_sel = {menu.antiaim.select.select_tab, 2}
    aa_condition[z].logic_enabled:depend(enaa,   tab_sel, need_select, logic)
    aa_condition[z].enable:depend(menu.antiaim.enable_aa,   tab_sel, need_select, {menu.antiaim.condition.condition, function() return (z ~= 1) end}, logic2)
    aa_condition[z].yaw_type:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].delay_ticks:depend(enaa,   tab_sel, {aa_condition[z].yaw_type, "Delay Switch"}, need_select, manuals, logic2)
    aa_condition[z].yaw_l:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].yaw_r:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].jit_type:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].jitter_center:depend(enaa,   tab_sel, need_select, manuals, logic2, {aa_condition[z].jit_type, function() if aa_condition[z].jit_type:get() == "Disabled" then return false else return true end end})
    aa_condition[z].bodyyaw:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].lby_l:depend(enaa,   aa_condition[z].bodyyaw, tab_sel, need_select, manuals, logic2)
    aa_condition[z].lby_r:depend(enaa,   aa_condition[z].bodyyaw, tab_sel, need_select, manuals, logic2)
    aa_condition[z].options:depend(enaa,   aa_condition[z].bodyyaw, tab_sel, need_select, manuals, logic2)
    aa_condition[z].def_aa:depend(enaa,   tab_sel, need_select, fakelags, logic2)
    aa_condition[z].def_type:depend(enaa,   tab_sel, need_select, fakelags, logic2)
    aa_condition[z].def_yaw_type:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2)
    aa_condition[z].def_sens:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, {aa_condition[z].def_yaw_type, "Custom"}, logic2)
    aa_condition[z].def_side:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" or aa_condition[z].def_yaw_type:get() == "Side-Way" or aa_condition[z].def_yaw_type:get() == "Spin" then return true else return false end end})

    aa_condition[z].def_min:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" then return true else return false end end})
    aa_condition[z].def_max:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, function() if aa_condition[z].def_yaw_type:get() == "Random Way" then return true else return false end end})

    aa_condition[z].def_xway:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_1way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_2way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"})
    aa_condition[z].def_3way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"}, {aa_condition[z].def_xway, function() if aa_condition[z].def_xway:get() >= 3 then return true else return false end end})
    aa_condition[z].def_4way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"}, {aa_condition[z].def_xway, function() if aa_condition[z].def_xway:get() >= 4 then return true else return false end end})
    aa_condition[z].def_5way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"}, {aa_condition[z].def_xway, function() if aa_condition[z].def_xway:get() >= 5 then return true else return false end end})
    aa_condition[z].def_6way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"}, {aa_condition[z].def_xway, function() if aa_condition[z].def_xway:get() >= 6 then return true else return false end end})
    aa_condition[z].def_7way:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2, {aa_condition[z].def_yaw_type, "X-Way"}, {aa_condition[z].def_xway, function() if aa_condition[z].def_xway:get() >= 7 then return true else return false end end})
    aa_condition[z].def_pitch_type:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, logic2)
    aa_condition[z].def_pitch:depend(enaa,   aa_condition[z].def_aa, tab_sel, need_select, fakelags, {aa_condition[z].def_pitch_type, "Custom"}, logic2)

    
    aa_condition[z].ab_enable:depend(enaa,   tab_sel, need_select, manuals, logic2)
    aa_condition[z].add_phases:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)
    aa_condition[z].rem_phases:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)

    aa_condition[z].ab_phase1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)
    aa_condition[z].ab_select1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)
    aa_condition[z].ab_yaw_type1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_delay_ticks1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Yaw"}, {aa_condition[z].ab_yaw_type1, "Delay Switch"})
    aa_condition[z].ab_yaw_l1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_yaw_r1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Yaw"})
    aa_condition[z].ab_lby_l1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Desync"})
    aa_condition[z].ab_lby_r1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Desync"})
    aa_condition[z].ab_def_type1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Defensive"})
    aa_condition[z].ab_def_yaw_type1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Defensive"})
    aa_condition[z].ab_def_pitch_type1:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select1, "Defensive"})


    aa_condition[z].ab_phase2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_phases, function() if aa_condition[z].ab_phases:get() > 1 then return true else return false end end})
    aa_condition[z].ab_select2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)
    aa_condition[z].ab_yaw_type2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_delay_ticks2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Yaw"}, {aa_condition[z].ab_yaw_type2, "Delay Switch"})
    aa_condition[z].ab_yaw_l2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_yaw_r2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Yaw"})
    aa_condition[z].ab_lby_l2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Desync"})
    aa_condition[z].ab_lby_r2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Desync"})
    aa_condition[z].ab_def_type2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Defensive"})
    aa_condition[z].ab_def_yaw_type2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Defensive"})
    aa_condition[z].ab_def_pitch_type2:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select2, "Defensive"})

    aa_condition[z].ab_phase3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_phases, function() if aa_condition[z].ab_phases:get() > 2 then return true else return false end end})
    aa_condition[z].ab_select3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2)
    aa_condition[z].ab_yaw_type3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_delay_ticks3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Yaw"}, {aa_condition[z].ab_yaw_type3, "Delay Switch"})
    aa_condition[z].ab_yaw_l3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_yaw_r3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Yaw"})
    aa_condition[z].ab_lby_l3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Desync"})
    aa_condition[z].ab_lby_r3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Desync"})
    aa_condition[z].ab_def_type3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Defensive"})
    aa_condition[z].ab_def_yaw_type3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Defensive"})
    aa_condition[z].ab_def_pitch_type3:depend(enaa,   aa_condition[z].ab_enable, tab_sel, need_select, manuals, logic2, {aa_condition[z].ab_select3, "Defensive"})
end

-- @function: logic anti-aim
local real_yaw, abs_yaw, choked, move_yaw = 0, 0, 0, 0

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

anti_aim.logic = function(cmd)
    if not menu.antiaim.logic.enable:get() then return end
    local lp = entity.get_local_player()

    ref.yawoffset:set(0)
    ref.yawoff:set(0)
    ref.options:set("")
    ref.yawbase:set("At Targets")
    if anti_aim.get_player_state_logic(lp) == enums.logic.states.airduck or anti_aim.get_player_state_logic(lp) == enums.logic.states.crouch or anti_aim.get_player_state_logic(lp) == enums.logic.states.air then
        ref.hidden:set(true)
    else
        ref.hidden:set(false)
    end

    if anti_aim.get_player_state_logic(lp) == enums.logic.states.crouch then
        ref.yawoffset:set(globals.tickcount % 4 > 1 and -22 or 30)
        rage.antiaim:override_hidden_yaw_offset(globals.tickcount % 4 > 1 and -85 or 85)
        rage.antiaim:override_hidden_pitch(-45)
    elseif anti_aim.get_player_state_logic(lp) == enums.logic.states.airduck or anti_aim.get_player_state_logic(lp) == enums.logic.states.air then
        rage.antiaim:override_hidden_pitch(0)
    end

    local anim_state = lp:get_anim_state()
    choked = cmd.choked_commands

    if not anim_state or cmd.choked_commands > 0 then
        return
    end

    real_yaw = anim_state.eye_yaw
    abs_yaw = anim_state.abs_yaw
    move_yaw = cmd.move_yaw

    if anti_aim.get_player_state_logic(lp) == enums.logic.states.air then
        local yaw_change = 33 * math.sin(globals.tickcount * 0.1)
        real_yaw = clamp(real_yaw + yaw_change, -33, 28)
        ref.yawoffset:set(real_yaw)
    end

    local is_exposed = entity.get_threat(true)
    if entity.get_threat(true) == nil then return end

    if is_exposed and anti_aim.get_player_state_logic(lp) == enums.logic.states.run then
        local yaw_change = 40 * math.sin(globals.tickcount * 0.1)
        move_yaw = clamp(move_yaw + yaw_change, -40, 40)
        ref.yawoffset:set(move_yaw)
    elseif is_exposed and anti_aim.get_player_state_logic(lp) == enums.logic.states.airduck then
        -- local yaw_change = 40 * math.sin(globals.tickcount * 0.1)
        real_yaw = globals.tickcount % 4 > 1 and -34 or 44 --clamp(real_yaw + yaw_change, -40, 40)
        ref.yawoffset:set(real_yaw)
    end
end

anti_aim.logic_debug = function()
    if not menu.antiaim.logic.enable:get() then return end
    local ss, py, lp = render.screen_size(), 0, entity.get_local_player()

    local info = {
        {"exploit: ", rage.exploit:get()},
        {"get_max_desync: ", rage.antiaim:get_max_desync() .. "°"},
        {"eye_yaw: ", real_yaw .. "°"},
        {"abs_yaw: ", abs_yaw .. "°"},
        {"choked_commands: ", choked},
        {"move_yaw: ", move_yaw .. "°"}
    }

    for i, data in ipairs(info) do
        render.text(1, vector(ss.x / 24, ss.y / 2 + py), color(), nil, data[1] .. data[2])
        py = py + 12
    end
end

-- @function: additions
anti_aim.additions = function()
    ref.freestand:set(menu.antiaim.main.freestand:get())
    if menu.antiaim.main.freestand:get() then 
        if menu.antiaim.second.main.staticfrees:get(2) then
            ref.hidden:set(false)
        end
        ref.disableyaw:set(menu.antiaim.second.main.staticfrees:get(1))
        ref.bodyfrees:set(menu.antiaim.second.main.staticfrees:get(1))
        if menu.antiaim.second.main.staticfrees:get(1) then
            ref.yawoffset:set(0)
            ref.yawoff:set(0)
            ref.options:set("")
            ref.inverter:set(false)
        end
    end
    if menu.antiaim.main.custom_yaw_base:get() == "At Target" then
        ref.yawbase:set("At Target")
    elseif menu.antiaim.main.custom_yaw_base:get() == "Backward" then
        ref.yawbase:set("Local View")
    elseif menu.antiaim.main.custom_yaw_base:get() == "Left" then
        ref.freestand:set(false)
        ref.yawoffset:set(-80)
        ref.yawoff:set(0)
        ref.options:set("")
        ref.yawbase:set("Local View")
    elseif menu.antiaim.main.custom_yaw_base:get() == "Right" then
        ref.freestand:set(false)
        ref.yawoffset:set(80)
        ref.yawoff:set(0)
        ref.options:set("")
        ref.yawbase:set("Local View")
    elseif menu.antiaim.main.custom_yaw_base:get() == "Forward" then
        ref.yawoffset:set(180)
        ref.yawoff:set(0)
        ref.yawbase:set("Local View")
    end
    ref.backstab:set(menu.antiaim.additions.additions:get("Anti-Backstab"))
    if (menu.antiaim.additions.additions:get("Shit AA On Warmup") and entity.get_game_rules()["m_bWarmupPeriod"] == true) then
        ref.right_limit:set(math.random(0, 30))
        ref.left_limit:set(math.random(0, 30))
        ref.yawoff:set(math.random(-90, 90))
    end
end
----------------------------
-- #endregion

-- #region : Animations
local anim = {data = {}}
anim.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}

        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = anim.lerp(start[color_key], end_pos[color_key], time)
        end

        return color(unpack(color_data))
    end

    return (end_pos - start) * (globals.frametime * time * 175) + start
end

anim.new = function(name, value, time)
    if anim.data[name] == nil then
        anim.data[name] = value
    end

    anim.data[name] = anim.lerp(anim.data[name], value, time)

    return anim.data[name]
end

local tween=(function()local a={}local b,c,d,e,f,g,h=math.pow,math.sin,math.cos,math.pi,math.sqrt,math.abs,math.asin;local function i(j,k,l,m)return l*j/m+k end;local function n(j,k,l,m)return l*b(j/m,2)+k end;local function o(j,k,l,m)j=j/m;return-l*j*(j-2)+k end;local function p(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,2)+k end;return-l/2*((j-1)*(j-3)-1)+k end;local function q(j,k,l,m)if j<m/2 then return o(j*2,k,l/2,m)end;return n(j*2-m,k+l/2,l/2,m)end;local function r(j,k,l,m)return l*b(j/m,3)+k end;local function s(j,k,l,m)return l*(b(j/m-1,3)+1)+k end;local function t(j,k,l,m)j=j/m*2;if j<1 then return l/2*j*j*j+k end;j=j-2;return l/2*(j*j*j+2)+k end;local function u(j,k,l,m)if j<m/2 then return s(j*2,k,l/2,m)end;return r(j*2-m,k+l/2,l/2,m)end;local function v(j,k,l,m)return l*b(j/m,4)+k end;local function w(j,k,l,m)return-l*(b(j/m-1,4)-1)+k end;local function x(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,4)+k end;return-l/2*(b(j-2,4)-2)+k end;local function y(j,k,l,m)if j<m/2 then return w(j*2,k,l/2,m)end;return v(j*2-m,k+l/2,l/2,m)end;local function z(j,k,l,m)return l*b(j/m,5)+k end;local function A(j,k,l,m)return l*(b(j/m-1,5)+1)+k end;local function B(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,5)+k end;return l/2*(b(j-2,5)+2)+k end;local function C(j,k,l,m)if j<m/2 then return A(j*2,k,l/2,m)end;return z(j*2-m,k+l/2,l/2,m)end;local function D(j,k,l,m)return-l*d(j/m*e/2)+l+k end;local function E(j,k,l,m)return l*c(j/m*e/2)+k end;local function F(j,k,l,m)return-l/2*(d(e*j/m)-1)+k end;local function G(j,k,l,m)if j<m/2 then return E(j*2,k,l/2,m)end;return D(j*2-m,k+l/2,l/2,m)end;local function H(j,k,l,m)if j==0 then return k end;return l*b(2,10*(j/m-1))+k-l*0.001 end;local function I(j,k,l,m)if j==m then return k+l end;return l*1.001*(-b(2,-10*j/m)+1)+k end;local function J(j,k,l,m)if j==0 then return k end;if j==m then return k+l end;j=j/m*2;if j<1 then return l/2*b(2,10*(j-1))+k-l*0.0005 end;return l/2*1.0005*(-b(2,-10*(j-1))+2)+k end;local function K(j,k,l,m)if j<m/2 then return I(j*2,k,l/2,m)end;return H(j*2-m,k+l/2,l/2,m)end;local function L(j,k,l,m)return-l*(f(1-b(j/m,2))-1)+k end;local function M(j,k,l,m)return l*f(1-b(j/m-1,2))+k end;local function N(j,k,l,m)j=j/m*2;if j<1 then return-l/2*(f(1-j*j)-1)+k end;j=j-2;return l/2*(f(1-j*j)+1)+k end;local function O(j,k,l,m)if j<m/2 then return M(j*2,k,l/2,m)end;return L(j*2-m,k+l/2,l/2,m)end;local function P(Q,R,l,m)Q,R=Q or m*0.3,R or 0;if R<g(l)then return Q,l,Q/4 end;return Q,R,Q/(2*e)*h(l/R)end;local function S(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;return-(R*b(2,10*j)*c((j*m-T)*2*e/Q))+k end;local function U(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)return R*b(2,-10*j)*c((j*m-T)*2*e/Q)+l+k end;local function V(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m*2;if j==2 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;if j<0 then return-0.5*R*b(2,10*j)*c((j*m-T)*2*e/Q)+k end;return R*b(2,-10*j)*c((j*m-T)*2*e/Q)*0.5+l+k end;local function W(j,k,l,m,R,Q)if j<m/2 then return U(j*2,k,l/2,m,R,Q)end;return S(j*2-m,k+l/2,l/2,m,R,Q)end;local function X(j,k,l,m,T)T=T or 1.70158;j=j/m;return l*j*j*((T+1)*j-T)+k end;local function Y(j,k,l,m,T)T=T or 1.70158;j=j/m-1;return l*(j*j*((T+1)*j+T)+1)+k end;local function Z(j,k,l,m,T)T=(T or 1.70158)*1.525;j=j/m*2;if j<1 then return l/2*j*j*((T+1)*j-T)+k end;j=j-2;return l/2*(j*j*((T+1)*j+T)+2)+k end;local function _(j,k,l,m,T)if j<m/2 then return Y(j*2,k,l/2,m,T)end;return X(j*2-m,k+l/2,l/2,m,T)end;local function a0(j,k,l,m)j=j/m;if j<1/2.75 then return l*7.5625*j*j+k end;if j<2/2.75 then j=j-1.5/2.75;return l*(7.5625*j*j+0.75)+k elseif j<2.5/2.75 then j=j-2.25/2.75;return l*(7.5625*j*j+0.9375)+k end;j=j-2.625/2.75;return l*(7.5625*j*j+0.984375)+k end;local function a1(j,k,l,m)return l-a0(m-j,0,l,m)+k end;local function a2(j,k,l,m)if j<m/2 then return a1(j*2,0,l,m)*0.5+k end;return a0(j*2-m,0,l,m)*0.5+l*.5+k end;local function a3(j,k,l,m)if j<m/2 then return a0(j*2,k,l/2,m)end;return a1(j*2-m,k+l/2,l/2,m)end;a.easing={linear=i,inQuad=n,outQuad=o,inOutQuad=p,outInQuad=q,inCubic=r,outCubic=s,inOutCubic=t,outInCubic=u,inQuart=v,outQuart=w,inOutQuart=x,outInQuart=y,inQuint=z,outQuint=A,inOutQuint=B,outInQuint=C,inSine=D,outSine=E,inOutSine=F,outInSine=G,inExpo=H,outExpo=I,inOutExpo=J,outInExpo=K,inCirc=L,outCirc=M,inOutCirc=N,outInCirc=O,inElastic=S,outElastic=U,inOutElastic=V,outInElastic=W,inBack=X,outBack=Y,inOutBack=Z,outInBack=_,inBounce=a1,outBounce=a0,inOutBounce=a2,outInBounce=a3}local function a4(a5,a6,a7)a7=a7 or a6;local a8=getmetatable(a6)if a8 and getmetatable(a5)==nil then setmetatable(a5,a8)end;for a9,aa in pairs(a6)do if type(aa)=="table"then a5[a9]=a4({},aa,a7[a9])else a5[a9]=a7[a9]end end;return a5 end;local function ab(ac,ad,ae)ae=ae or{}local af,ag;for a9,ah in pairs(ad)do af,ag=type(ah),a4({},ae)table.insert(ag,tostring(a9))if af=="number"then assert(type(ac[a9])=="number","Parameter '"..table.concat(ag,"/").."' is missing from subject or isn't a number")elseif af=="table"then ab(ac[a9],ah,ag)else assert(af=="number","Parameter '"..table.concat(ag,"/").."' must be a number or table of numbers")end end end;local function ai(aj,ac,ad,ak)assert(type(aj)=="number"and aj>0,"duration must be a positive number. Was "..tostring(aj))local al=type(ac)assert(al=="table"or al=="userdata","subject must be a table or userdata. Was "..tostring(ac))assert(type(ad)=="table","target must be a table. Was "..tostring(ad))assert(type(ak)=="function","easing must be a function. Was "..tostring(ak))ab(ac,ad)end;local function am(ak)ak=ak or"linear"if type(ak)=="string"then local an=ak;ak=a.easing[an]if type(ak)~="function"then error("The easing function name '"..an.."' is invalid")end end;return ak end;local function ao(ac,ad,ap,aq,aj,ak)local j,k,l,m;for a9,aa in pairs(ad)do if type(aa)=="table"then ao(ac[a9],aa,ap[a9],aq,aj,ak)else j,k,l,m=aq,ap[a9],aa-ap[a9],aj;ac[a9]=ak(j,k,l,m)end end end;local ar={}local as={__index=ar}function ar:set(aq)assert(type(aq)=="number","clock must be a positive number or 0")self.initial=self.initial or a4({},self.target,self.subject)self.clock=aq;if self.clock<=0 then self.clock=0;a4(self.subject,self.initial)elseif self.clock>=self.duration then self.clock=self.duration;a4(self.subject,self.target)else ao(self.subject,self.target,self.initial,self.clock,self.duration,self.easing)end;return self.clock>=self.duration end;function ar:reset()return self:set(0)end;function ar:update(at)assert(type(at)=="number","dt must be a number")return self:set(self.clock+at)end;function a.new(aj,ac,ad,ak)ak=am(ak)ai(aj,ac,ad,ak)return setmetatable({duration=aj,subject=ac,target=ad,easing=ak,clock=0},as)end;return a end)()

local tween_table = {}
local tween_data = {
    manual = 0,
    aversion = 0,
    state = 0,
    line = 0,
    scope = 0
}
-- как использовать : tween.new(1, tween_data, {fake_amount = math.abs(vars.fake_amount)}, "linear") local fake_amount = tween_data.fake_amount
-- tween.new(скорость, дата, то что анимировать, тип анимации)
-- типы анимаций: linear,inQuad,outQuad,inOutQuad,outInQuad,inCubic,outCubic,inOutCubic,outInCubic,inQuart,outQuart,inOutQuart,outInQuart,inQuint,outQuint,inOutQuint,outInQuint,inSine,outSine,inOutSine,outInSine,inExpo,outExpo,inOutExpo,outInExpo,inCirc,outCirc,inOutCirc,outInCirc,inElastic,outElastic,inOutElastic,outInElastic,inBack,outBack,inOutBack,outInBack,inBounce,outBounce,inOutBounce,outInBounce

lerpik = function(start, vend, time)
    return start + (vend - start) * (globals.frametime * time * 175)
end

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end

local breathe = function(offset, multiplier)
    local m_speed = globals.realtime * (multiplier or 1.0);
    local m_factor = m_speed % math.pi;
  
    local m_sin = math.sin(m_factor + (offset or 0));
    local m_abs = math.abs(m_sin);
  
    return m_abs
end
-- #endregion

-- #region : Rage
---------------------
--PingSpike
menu.rage.main.unlocklatency:set_callback(function()
    if menu.rage.main.unlocklatency:get() then
        cvar.sv_maxunlag:float(0.4)
    else
        cvar.sv_maxunlag:float(0.2)
    end
end, true)

function aversion.sin_vec(x, y)
    sin_x = math.sin(math.rad(x))
    cos_x = math.cos(math.rad(x))
    sin_y = math.sin(math.rad(y))
    cos_y = math.cos(math.rad(y))
    return vector(cos_x * cos_y, cos_x * sin_y, -sin_x);
end

function aversion.air_hit()
    ref.hc:override()
    if not menu.rage.adaptivehit:get() then return end
    local local_player = entity.get_local_player()
    local jump = bit.band(local_player.m_fFlags, 1) == 0
    local selected = local_player:get_player_weapon()
    if selected == nil then return end
    local weapon = selected:get_classname()
    r8_check = false
    if string.match(weapon, "Deagle") then r8_check = true end
    scout_check = false
    if string.match(weapon, "SSG08") then scout_check = true end
    scar_check = false
    if string.match(weapon, "SCAR20") then scar_check = true end
    if jump  and (menu.rage.adaptivehit.multisel:get("Scout") and scout_check == true) then
        ref.hc:override(menu.rage.adaptivehit.scout:get())
    end
    if jump and (menu.rage.adaptivehit.multisel:get("R8") and r8_check == true) then
        ref.hc:override(menu.rage.adaptivehit.r8:get())
    end
    if jump and (menu.rage.adaptivehit.multisel:get("AutoSnipers") and scar_check == true) then
        ref.hc:override(menu.rage.adaptivehit.Scar:get())
    end
end

---------------------


-- #endregion

-- #region : Visual
local function mouse_check(first, second)
    if ui.get_alpha() < 1 then return false end
    local pos = ui.get_mouse_position()
    return pos.x >= first.x and pos.x <= second.x and pos.y >= first.y and pos.y <= second.y 
end

-- @function: Crosshair indicators
local elegant_font, elegant_font2 = render.load_font("aversion\\Lora.ttf", 14, "adi"), render.load_font("aversion\\Lora.ttf", 11, "ad")
local container = {
    cross_indicators_1 = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(2, vector((render.screen_size().x / 2) + add_x, (render.screen_size().y / 2) + 20 + menu.visual.indicators.cross.offset:get() + add_y), color(r, g, b, a), 'c', string)
    end,

    cross_indicators_2 = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(1, vector((render.screen_size().x / 2) + add_x, (render.screen_size().y / 2) + 20 + menu.visual.indicators.cross.offset:get() + add_y), color(r, g, b, a), 'c', string)
    end,

    cross_indicators_3 = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(elegant_font, vector((render.screen_size().x / 2) + add_x, (render.screen_size().y / 2) + 20 + menu.visual.indicators.cross.offset:get() + add_y), color(r, g, b, a), 'c', string)
    end
}

local animate_scoped = 0
aversion.cross_indicators = function()
    local lp = entity.get_local_player()

    if lp == nil or not lp:is_alive() then 
        return 
    end

    local weapon = lp:get_player_weapon()

    if weapon == nil then
        return
    end

    local x, y = render.screen_size().x, render.screen_size().y

    local py = 0
    local is_scoped = lp['m_bIsScoped']

    if is_scoped then
        if animate_scoped < 1 then
            animate_scoped = lerpik(animate_scoped, 1 + 0.1, 0.023)
        else
            animate_scoped = 1
        end
    else
        animate_scoped = lerpik(animate_scoped, 0, 0.023)
    end

    local col = menu.visual.indicators.color:get()
    local weapon_class = lp:get_player_weapon():get_classname()
    grenade_alpha = anim.new("a_a", (weapon_class == "CHEGrenade" or weapon_class == "CIncendiaryGrenade" or weapon_class == "CMolotovGrenade" or weapon_class == "CSmokeGrenade") and 70 or 255, 0.057)

    -- name & version
    tween_table.aversion = tween.new(0.2, tween_data, {aversion = is_scoped and 46 or 0}, "linear")
    local aversion = tween_data.aversion
    local pulse = anim.new('pulse', globals.tickcount % 20 > 2 and 255 or 100, 0.078);
    container.cross_indicators_3(script.name:lower(), 255, 255, 255, grenade_alpha, - 12 + aversion, py, true)
    container.cross_indicators_3(script.version:lower(), col.r, col.g, col.b, math.max(breathe(0, 2.0), 0.2)*grenade_alpha, (render.measure_text(1, 'c', script.name:lower()).x / 2) + 3 + aversion, py, true)
    py = py + 12

    -- states
    local states = {}

    if menu.antiaim.logic.enable:get() then
        states = {
            {enums.name_states[anti_aim.get_player_state_logic(lp)]:lower(), render.measure_text(elegant_font2, "c", enums.name_states[anti_aim.get_player_state_logic(entity.get_local_player())]:lower()).x},
        }
    else
        states = {
            {enums.name_states[anti_aim.get_player_state(lp)]:lower(), render.measure_text(elegant_font2, "c", enums.name_states[anti_aim.get_player_state(entity.get_local_player())]:lower()).x},
        }
    end
    
    for i, data in ipairs(states) do
        tween_table.state = tween.new(0.2, tween_data, {state = is_scoped and data[2] / 2 + 11 or 0}, "linear")
        local state = tween_data.state

        render.text(elegant_font2, vector((render.screen_size().x / 2) + 1 + state, (render.screen_size().y / 2) + 21 + menu.visual.indicators.cross.offset:get() + py), color(255, 255, 255, grenade_alpha), 'c', data[1])
        py = py + 12
    end

    -- line
    tween_table.line = tween.new(0.2, tween_data, {line = is_scoped and 27 or 0}, "linear")
    local line = tween_data.line
    render.gradient(vector(x / 2 - 15 + line, y / 2 + 18 + menu.visual.indicators.cross.offset:get() + py), vector(x / 2 + 3 + line, y / 2 + 20 + menu.visual.indicators.cross.offset:get() + py), color(col.r, col.g, col.b, 0), color(col.r, col.g, col.b, 255), color(col.r, col.g, col.b, 0), color(col.r, col.g, col.b, 255))
    render.gradient(vector(x / 2 + 3 + line, y / 2 + 18 + menu.visual.indicators.cross.offset:get() + py), vector(x / 2 + 15 + line, y / 2 + 20 + menu.visual.indicators.cross.offset:get() + py), color(col.r, col.g, col.b, 255), color(col.r, col.g, col.b, 0), color(col.r, col.g, col.b, 255), color(col.r, col.g, col.b, 0))
    py = py + 12

    -- keybinds
    local col_dt = anim.new("dt_col", rage.exploit:get() == 1 and color(132,210,16) or color(255,75,75), 0.1);
    local keybinds = {
        {
            text = "ping",
            color = {143, 194, 21},
            bool = ref.fake_latency:get() > 0,
            measure = render.measure_text(elegant_font2, "", "ping").x
        },
        {
            text = "da",
            color = {255, 255, 255},
            bool = ref.dormant_aim:get(),
            measure = render.measure_text(elegant_font2, "", "da").x
        },
        {
            text = "dt",
            color = {col_dt.r, col_dt.g, col_dt.b},
            bool = ref.dt:get(),
            measure = render.measure_text(elegant_font2, "", "dt").x
        },
        {
            text = "osaa",
            color = {255, 255, 255},
            bool = ref.hideshots:get(),
            measure = render.measure_text(elegant_font2, "", "osaa").x
        },
        {
            text = "fs",
            color = {255,255,255},
            bool = ref.freestand:get(),
            measure = render.measure_text(elegant_font2, "", "fs").x
        },
        {
            text = "body",
            color = {255, 35, 35},
            bool = ref.force_baim:get() == 'Force',
            measure = render.measure_text(elegant_font2, "", "body").x
        },
        {
            text = "safe",
            color = {255, 230, 119},
            bool = ref.force_safety:get() == 'Force',
            measure = render.measure_text(elegant_font2, "", "safe").x
        }
    }

    for _, indicator in ipairs(keybinds) do
        local alpha = anim.new('alpha_'..indicator.text:lower(), (menu.visual.indicators.cross:get() and indicator.bool) and 1 or 0, 0.02);
        local anim = string.format('%.0f', anim.new('anim_'..indicator.text:lower(), (indicator.bool and menu.visual.indicators.cross:get()) and 13 or 0, 0.092));
        render.text(elegant_font2, vector((x / 2) + 1 + (indicator.measure / 2 + 12) * animate_scoped, (y / 2) + 17 + menu.visual.indicators.cross.offset:get() + py), color(indicator.color[1], indicator.color[2], indicator.color[3], grenade_alpha*alpha), "c", indicator.text:lower())
        py = py + anim
    end
end
----------------------------
--- @function: manual arrows
local font = render.load_font("Verdana", 20, "ad")
aversion.manual_indication = function()
    local lp = entity.get_local_player()
    if not  menu.visual.indicators.manual:get() then return end
    if lp == nil or not lp:is_alive() then return end
    if globals.is_connected == false or globals.is_in_game == nil then return end
    local x, y = render.screen_size().x, render.screen_size().y
    
    local r, g, b = menu.visual.indicators.color:get().r, menu.visual.indicators.color:get().g, menu.visual.indicators.color:get().b

    tween_table.manual = tween.new(0.3, tween_data, {manual = lp['m_bIsScoped'] and 40 or 185}, "linear")
    local manual = tween_data.manual

    if menu.visual.indicators.manual.style:get() == "V1" then
        if menu.antiaim.main.custom_yaw_base:get() == "Left" then
            render.poly(menu.antiaim.main.custom_yaw_base:get() == "Left" and color(r,g,b,manual) or color(35, 35, 35, manual), vector(x / 2 - 55, y / 2 - 2 + 2), vector(x / 2 - 42, y / 2 - 2 - 7), vector(x / 2 - 42, y / 2 - 2 + 11))
            render.poly(menu.antiaim.main.custom_yaw_base:get() == "Right" and color(r,g,b,a) or color(35, 35, 35, manual), vector(x / 2 + 55, y / 2 - 2 + 2), vector(x / 2 + 42, y / 2 - 2 - 7), vector(x / 2 + 42, y / 2 - 2 + 11))
        elseif menu.antiaim.main.custom_yaw_base:get() == "Right" then
            render.poly(menu.antiaim.main.custom_yaw_base:get() == "Left" and color(r,g,b,a) or color(35, 35, 35, manual), vector(x / 2 - 55, y / 2 - 2 + 2), vector(x / 2 - 42, y / 2 - 2 - 7), vector(x / 2 - 42, y / 2 - 2 + 11))    
            render.poly(menu.antiaim.main.custom_yaw_base:get() == "Right" and color(r,g,b,manual) or color(35, 35, 35, manual), vector(x / 2 + 55, y / 2 - 2 + 2), vector(x / 2 + 42, y / 2 - 2 - 7), vector(x / 2 + 42, y / 2 - 2 + 11))
        end 
    end

    if menu.visual.indicators.manual.style:get() == "V2" then
        if menu.antiaim.main.custom_yaw_base:get() == "Left" then
            local text_width = render.measure_text(font, "⮜").x
            render.text(font, vector(x / 2 - text_width / 2 - 50, y / 2), color(r, g, b, manual) or color(35, 35, 35, manual), "bc+", "⮜")
            render.text(font, vector(x / 2 + text_width / 2 + 49, y / 2), color(255, manual) or color(35, 35, 35, manual), "bc+", "⮞")
        elseif menu.antiaim.main.custom_yaw_base:get() == "Right" then
            local text_width = render.measure_text(font, "⮞").x
            render.text(font, vector(x / 2 + text_width / 2 + 49, y / 2), color(r, g, b, manual) or color(35, 35, 35, manual), "bc+", "⮞")
            render.text(font, vector(x / 2 - text_width / 2 - 50, y / 2), color(255, manual) or color(35, 35, 35, manual), "bc+", "⮜")
        end
    end
end
----------------------------
--console
function paint_c(fn)
    table.foreach(materials.get_materials("vgui/hud/800"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)
    
    table.foreach(materials.get_materials("vgui_white"), function(clr, console)
        console:color_modulate(fn)
        console:alpha_modulate(fn.a / 255)
    end)
end

cvar.toggleconsole:set_callback(function()
    if not menu.visual.vgui:get() then
        return
    end

    paint_c(color())

    if not console_is_visible(engine_client) then
        paint_c(menu.visual.vgui.vguicol:get())
    end
end)

menu.visual.vgui:set_callback(function(self)
    if not menu.visual.vgui:get() then
        return
    end
    
    paint_c(color())

    if console_is_visible(engine_client) then
        paint_c(menu.visual.vgui.vguicol:get())
    end
end)

menu.visual.vgui:set_callback(function(self)
    if not self:get() then
        paint_c(color())
    else
        paint_c(menu.visual.vgui.vguicol:get())
    end
end, true)

--console end
----------------------------
-- @function: watermark
local animated_text = ""
local text_to_animate = script.name .. " " .. script.version .. " | " .. script.user.name
local current_index = 1
local interval = 0.1
local last_update = 0
local direction = 1

local function animateText()
    if menu.visual.indicators.cross:get() then return end

    if direction == 1 then
        if current_index <= #text_to_animate then
            animated_text = string.sub(text_to_animate, 1, current_index)
            current_index = current_index + 1
        else
            direction = -1
            current_index = current_index - 2
        end
    else
        if current_index >= 1 then
            animated_text = string.sub(text_to_animate, 1, current_index)
            current_index = current_index - 1
        else
            direction = 1
            current_index = current_index + 2
        end
    end
end

aversion.watermark = function()
    local x, y = render.screen_size().x, render.screen_size().y
    local measure = render.measure_text(1, "c", animated_text).x
    render.text(1, vector(x / 2 + (measure / 2 - 60), y - 15), color(255, 255, 255, 255), "c", animated_text)

    local current_time = globals.realtime
    local delta_time = current_time - last_update

    if delta_time >= interval then
        animateText()
        last_update = current_time
    end
end
----------------------------
-- @function: slowed down indicator
local screen_size = render.screen_size()
local screen_center = screen_size * 0.5
local main = {}
local vel_x = tabs.visuals_2:slider("x_vel", 1, screen_size.x, screen_size.x/2-75):visibility(false)
local vel_y = tabs.visuals_2:slider("y_vel", 1, screen_size.y, screen_size.y/2-250):visibility(false)

main.size = 0
main.vel_alpha = 0
main.text_vel_alpha = 0
local function windows_def(x, y, size, sizey, long, text, color1, color2, alpha)
    render.rect(vector(x+15, y+33), vector(x+135, y+39), color(0, alpha - 160), 1)
    render.rect(vector(x+15, y+33), vector(x+15 + long, y+39), color1)
    render.rect_outline(vector(x+15, y+32), vector(x+135, y+40), color2, 1)
    render.text(font, vector(x+15, y+11), color1, nil, ui.get_icon("person-running"))
    render.text(1, vector(x+36, y+17), color1, nil, text)
    render.rect_outline(vector(x, y), vector(x + size, y + sizey), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end

local velocity_ind = drag_system.register({vel_x, vel_y}, vector(150, 50), "Velocity", function(self)
    vel_mod = entity.get_local_player().m_flVelocityModifier  
    if ui.get_alpha() > 0 or vel_mod < 1 then
        main.vel_alpha = math.lerp(main.vel_alpha, 1, 12)
    else
        main.vel_alpha = math.lerp(main.vel_alpha, 0, 12)
    end
    main.size = vel_mod * 120 == 120 and math.lerp(vel_mod * 120, main.size, 4) or math.lerp(main.size, vel_mod * 120, 4)
    gc1 = menu.visual.indicators.color:get()
    color1, color2 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(40, 40, 40, math.floor(main.vel_alpha * 255))
    windows_def(self.position.x, self.position.y, self.size.x, self.size.y, main.size, "Slowed down: " ..math.floor(vel_mod * 100).."%", color1, color2, math.floor(main.vel_alpha * 255))
    if mouse_check(vector(vel_x:get(), vel_y:get()), vector(vel_x:get() + self.size.x, vel_y:get() + self.size.y)) then
        render.text(1, vector(self.position.x-9, self.position.y - 15), color(255, 255, 255, 255*main.text_vel_alpha), nil, "Press RMB to center the indicator")
        main.text_vel_alpha = math.lerp(main.text_vel_alpha, 1, 12)
        if common.is_button_down(0x02) then
            vel_x:set(render.screen_size().x/2-74)
            self.position.x = render.screen_size().x/2-74
        end
    elseif main.text_vel_alpha ~= 0 then
        main.text_vel_alpha = 0
    end
end)
----------------------------
-- @function: minimum damage indicator
dmg_x = tabs.visuals_2:slider("x_dmg", 1, screen_size.x, screen_center.x + 10):visibility(false)
dmg_y = tabs.visuals_2:slider("y_dmg", 1, screen_size.y, screen_center.y - 25):visibility(false)

aversion.Mnmmdmg = drag_system.register({dmg_x, dmg_y}, vector(20, 20), "Mindmg", function(self)
    if not entity.get_local_player() then return end
    if not entity.get_local_player():is_alive() then return end
    
	render.text(1, vector(self.position.x + 2, self.position.y + 4), color(), nil, ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get())
	render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + self.size.x, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
end)
----------------------------
-- @function: custom scope
function aversion.customscope()
    local x = screen_center.x
    local y = screen_center.y
    local Player = entity.get_local_player()
    local Scope = Player.m_bIsScoped
    local r = math.floor(menu.visual.indicators.color:get().r*120)
    local g = math.floor(menu.visual.indicators.color:get().g*120)
    local b = math.floor(menu.visual.indicators.color:get().b*120)
    local col = menu.visual.indicators.color:get()
    local color = color(col.r, col.g, col.b, 1)
    local FirstCol = (function(a,s) if not menu.visual.other.scope.inverted:get() then return s else return a end end)(col, color)
    local SecondCol = (function(a,s) if not menu.visual.other.scope.inverted:get() then return a else return s end end)(col, color)
    if Scope then 
        render.gradient(vector(x, y + (menu.visual.other.scope.offset:get()-1)+1), vector(x + 1, y + menu.visual.other.scope.length:get() + (menu.visual.other.scope.offset:get()-1)+1), SecondCol, SecondCol, FirstCol, FirstCol)
        render.gradient(vector((x+1 + (menu.visual.other.scope.length:get())) + (menu.visual.other.scope.offset:get()-1), y), vector(x+1 + (menu.visual.other.scope.offset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
        render.gradient(vector(x, y - (menu.visual.other.scope.offset:get()-1) - menu.visual.other.scope.length:get()), vector(x + 1, y - (menu.visual.other.scope.offset:get()-1)), FirstCol, FirstCol, SecondCol, SecondCol)
        render.gradient(vector((x - menu.visual.other.scope.length:get()) - (menu.visual.other.scope.offset:get()-1), y), vector(x - (menu.visual.other.scope.offset:get()-1), y + 1), FirstCol, SecondCol, FirstCol, SecondCol)
    end
end
----------------------------
-- @function: logs
log_x = tabs.visuals_2:slider("x_log", 1, screen_size.x, screen_center.x-150):visibility(false)
log_y = tabs.visuals_2:slider("y_log", 1, screen_size.y, screen_center.y+200):visibility(false)

local logs = {}
aversion.logs_func = drag_system.register({log_x, log_y}, vector(320, 130), "logs", function(self)
    local offset = 0
    x = screen_center.x - 10
    y = screen_center.y + 250

    for idx, data in ipairs(logs) do
        if globals.curtime - data[3] < 4.0 and not (#logs > 3 and idx < #logs - 3) then
            data[2] = math.lerp(data[2], 155, 12)
        else
            data[2] = math.lerp(data[2], 0, 12)
        end

        offset = offset - 40 * (data[2] / 195)

        text_size = render.measure_text(1, s, data[1])
        second_text_size = render.measure_text(4, s, ui.get_icon("fire-flame-curved"))
        render.rect(vector(x - 7 - second_text_size.x / 2 - text_size.x / 2, y - offset - text_size.y/2), vector(x - 12 + second_text_size.x/2 - text_size.x / 2, y + 30 - offset - text_size.y), color(HEXtoRGB.r(style_hex), HEXtoRGB.g(style_hex), HEXtoRGB.b(style_hex), data[2]))
        render.rect(vector(x - 5 - second_text_size.x / 2 - text_size.x / 2, y - offset - text_size.y/2), vector(x + 9 + second_text_size.x/2 - text_size.x / 2, y + 30 - offset - text_size.y), color(0, 0, 0, data[2]))
        render.text(font, vector(x - 1 - second_text_size.x / 2 - text_size.x / 2, y - 4 - offset), color(HEXtoRGB.r(style_hex), HEXtoRGB.g(style_hex), HEXtoRGB.b(style_hex), (data[2] / 255) * 255), "odb", ui.get_icon("fire-flame-curved"))
        render.rect(vector(x + 18 - second_text_size.x / 2 - text_size.x / 2, y - offset - text_size.y/2), vector(x + 35 + text_size.x/2, y + 30 - offset - text_size.y), color(0, 0, 0, data[2]))
        render.text(1, vector(x + 26 - text_size.x / 2, y - offset), color(255, 255, 255, (data[2] / 255) * 255), "od", data[1])
        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end

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
    local hitcol = "\a" .. style_hex
    local misscol = "\a945555FF"
    local col = "\aFFFFFFFF"

    if state == nil then
        if not globals.is_connected and not globals.is_in_game then return false end
        if menu.visual.other.logs.settings:get(3) then
            render.log(("Hit %s's %s for %s(%s) / %st"):format(target:get_name():lower(), hitgroup, e.damage, wanted_damage, bt))
        end
        if menu.visual.other.logs.settings:get(2) then
            custom_print(("Hit %s%s's%s %s for %s%s(%s)%s / %st"):format(hitcol, target:get_name():lower(), col, hitgroup, hitcol, e.damage, wanted_damage, col, bt))
        end
        if menu.visual.other.logs.settings:get(1) then
            print(("Hit %s%s's%s %s for %s%s(%s)%s / %st"):format(hitcol, target:get_name():lower(), col, hitgroup, hitcol, e.damage, wanted_damage, col, bt))
        end
    end
    if state ~= nil then
        if menu.visual.other.logs.settings:get(3) then
            render.log(("Missed %s's %s due to %s(%s%%) / %st"):format(target:get_name():lower(), wanted_hitgroup, state, hitchance, bt))
        end
        if menu.visual.other.logs.settings:get(2) then
            custom_print(("Missed %s%s's%s %s due to %s%s(%s%%)%s / %st"):format(misscol, target:get_name():lower(), col, wanted_hitgroup, misscol, state, hitchance, col, bt))
        end
        if menu.visual.other.logs.settings:get(1) then
            print(("Missed %s%s's%s %s due to %s%s(%s%%)%s / %st"):format(misscol, target:get_name():lower(), col, wanted_hitgroup, misscol, state, hitchance, col, bt))
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
            if menu.visual.other.logs.settings:get(1) then
                print(('%s \a%s%s\aFFFFFFFF for \a%s%d'):format(type_hit:lower(), style_hex, user:get_name():lower(), style_hex, e.dmg_health))
            end
            if menu.visual.other.logs.settings:get(2) then
                print_dev(('%s \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF'):format(type_hit:lower(), style_hex, user:get_name():lower(), style_hex, e.dmg_health))
            end
        end
    end
end)

events.round_start:set(function()
    currentphase = 1
    -- if menu.visual.other.logs.settings:get(3) then
    --     render.log("Reset anti-aim data due to new round start. Phase: "..currentphase)
    -- end
end)

----------------------------
-- @function: animation breaker
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
    if not lp or not lp:is_alive() or not lp:get_index() then return end

    animslsg = get_entity_address(lp:get_index())
    local move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
    local jump = bit.band(lp.m_fFlags, 1) == 0
    local aa, main = menu.antiaim.second.breaker, menu.antiaim.main

    if main.anims:get() then
        if aa.groundbreaker:get() == "Jitter" then
            lp.m_flPoseParameter[0] = math.random(0, 10) / 10
            ref.legs:set("Sliding")
        end
        if aa.airbreaker:get() == "Static Legs In Air"  then
            lp.m_flPoseParameter[6] = 1
        end
        if aa.groundbreaker:get() == "MoonWalk" then
            lp.m_flPoseParameter[7] = 1
            ref.legs:set("Walking")
        end
        if aa.othbreaker:get("Pitch 0 On Land") then
            if anti_aim.in_air() then
                lp.m_flPoseParameter[12] = 0.5
            end
        end
        if aa.othbreaker:get("Jitter Head")  then
            if anti_aim.get_player_state(lp) == enums.states.crouch then return end
            lp.m_flPoseParameter[10] = globals.tickcount % 4 > 1 and 0.5 or 1
        end
        if aa.airbreaker:get() == "MoonWalk" and jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        end
        if aa.othbreaker:get("Move Lean") and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = 1
        end
    end
end
events.post_update_clientside_animation:set(anmsupd)
----------------------------
-- #endregion

----------------------------
-- #region : Misc
clan_anim = function(text, indices) if not globals.is_connected then return end local text_anim = '               ' .. text .. '                      '  local tickinterval = globals.tickinterval local tickcount = globals.tickcount + math.floor(utils.net_channel().avg_latency[0]+0.22 / globals.tickinterval + 0.5) local i = tickcount / math.floor(0.3 / globals.tickinterval + 0.5) i = math.floor(i % #indices) i = indices[i+1]+1 return string.sub(text_anim, i, i+15) end
aversion.clantag = function()
	if not globals.is_connected then return end
	if menu.misc.first.clantag:get() then
		if local_player ~= nil and globals.is_connected and globals.choked_commands then
			clan_tag = clan_anim('Aversion', {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0})
			if entity.get_game_rules()['m_gamePhase'] == 5 or entity.get_game_rules()['m_gamePhase'] == 4 then
				clan_tag = clan_anim('Aversion', {12})
				common.set_clan_tag(clan_tag)
			elseif clan_tag ~= clan_tag_prev then
				common.set_clan_tag(clan_tag)
			end
			clan_tag_prev = clan_tag
		end
		enabled_prev = false
	elseif not menu.misc.first.clantag:get() and enabled_prev == false then
        common.set_clan_tag('')
        enabled_prev = true
	end
end

function aversion.nade_fixer(cmd)
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

function aversion.no_fall_damage(cmd)
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

function aversion.fastladder(cmd)
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

function aversion.avoid(cmd)
    local lp = entity.get_local_player()
    local minimum, value = math.huge, math.huge
    for z = 1, 180 do
        local line_trace = utils.trace_line(lp.m_vecOrigin, vector(lp.m_vecOrigin.x + aversion.sin_vec(0, (render.camera_angles().y + z - 90)).x * 70, lp.m_vecOrigin.y + aversion.sin_vec(0, (render.camera_angles().y + z - 90)).y * 70, lp.m_vecOrigin.z + 60), nil, nil, 1)
        if(lp.m_vecOrigin:dist(line_trace.end_pos) < minimum) then
            minimum = lp.m_vecOrigin:dist(line_trace.end_pos)
            value = z
        end
    end
    if minimum < menu.misc.dva.avoidcol.dist:get() * 10 and jump and not (cmd.in_back or cmd.in_moveleft or cmd.in_moveright) then
        if(value >= 90) then
            cmd.sidemove = lp.m_vecVelocity:length() * math.sin(math.rad(value))
        else
            cmd.sidemove = (lp.m_vecVelocity:length() * math.sin(math.rad(value))) * -1
        end
        cmd.forwardmove = math.abs(lp.m_vecVelocity:length() * math.cos(math.rad(value)))
    end
end
-- #endregion
----------------------------
local view_fov, view_x, view_y, view_z, testing = menu.misc.second.viewmodel.fov:get(), menu.misc.second.viewmodel.x:get(), menu.misc.second.viewmodel.y:get(), menu.misc.second.viewmodel.z:get(), menu.misc.second.ratio.value:get()/100

if menu.misc.first.viewmodel:get() then
    cvar.viewmodel_fov:int(view_fov, true)
    cvar.viewmodel_offset_x:float(view_x, true)
    cvar.viewmodel_offset_y:float(view_y, true)
    cvar.viewmodel_offset_z:float(view_z, true)
end

menu.misc.second.viewmodel.fov:set_callback(function()
    if not menu.misc.first.viewmodel:get() then return end
	cvar.viewmodel_fov:int(menu.misc.second.viewmodel.fov:get(), true)
    view_fov = menu.misc.second.viewmodel.fov:get()
end)

menu.misc.second.viewmodel.x:set_callback(function()
    if not menu.misc.first.viewmodel:get() then return end
	cvar.viewmodel_offset_x:float(menu.misc.second.viewmodel.x:get(), true)
    view_x = menu.misc.second.viewmodel.x:get()
end)

menu.misc.second.viewmodel.y:set_callback(function()
    if not menu.misc.first.viewmodel:get() then return end
	cvar.viewmodel_offset_y:float(menu.misc.second.viewmodel.y:get(), true)
    menu.misc.second.viewmodel.y:get()
end)

menu.misc.second.viewmodel.z:set_callback(function()
    if not menu.misc.first.viewmodel:get() then return end
	cvar.viewmodel_offset_z:float(menu.misc.second.viewmodel.z:get(), true)
    view_z = menu.misc.second.viewmodel.z:get()
end)

menu.misc.first.viewmodel:set_callback(function()
    if not menu.misc.first.viewmodel:get() then
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

menu.misc.second.ratio.value:set_callback(function()
    if not menu.misc.first.aspect:get() then return end
    testing = menu.misc.second.ratio.value:get()/100
    cvar.r_aspectratio:float(testing)
end)
if menu.misc.first.aspect:get() then
    cvar.r_aspectratio:float(testing)
end
menu.misc.first.aspect:set_callback(function()
    if menu.misc.first.aspect:get() then
        cvar.r_aspectratio:float(testing)
    else
        cvar.r_aspectratio:float(0)
    end
end)

events.render:set(function()
    for _, t in pairs(tween_table) do
        t:update(globals.frametime)
    end

    aversion.clantag()
    anti_aim.logic_debug()
    if menu.visual.other.scope:get() then
        ref.removesc:override("Remove all")
    else
        ref.removesc:override()
    end
    if menu.visual.other.logs:get() and menu.visual.other.logs.settings:get(3) then
        aversion.logs_func:update()
    end

    if menu.visual.other.logs:get() and menu.visual.other.logs.settings:get(2) then
        render_print_text()
    end
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
	if menu.visual.other.mindmg:get() then
		aversion.Mnmmdmg:update()
	end
    -- if menu.misc.first.viewmodel:get() then
    --     menu.misc.second.viewmodel.switchknife:update()
    -- end
    if menu.visual.other.scope:get() then
        aversion.customscope()
    end
    if menu.visual.indicators.velocity_indicator_enable:get() then
        velocity_ind:update()
    end
    if menu.visual.indicators.cross:get() then
        aversion.cross_indicators()
    elseif not menu.visual.indicators.cross:get() then
        aversion.watermark()
    end
    if menu.visual.indicators.manual:get() then
        aversion.manual_indication()
    end
end)

events.createmove:set(function (cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    if not lp:is_alive() then return end
    aversion.air_hit()
    anti_aim.antiaim_setup(cmd)
    anti_aim.logic(cmd)
    anti_aim.additions()
    if menu.misc.dva.fast_ladder:get() then
        aversion.fastladder(cmd)
    end
    if menu.misc.dva.no_fall_damage:get() then
        aversion.no_fall_damage(cmd)
    end
    if menu.misc.dva.nade_fix:get() then
        aversion.nade_fixer(cmd)
    end
    if menu.misc.dva.avoidcol:get() then
        aversion.avoid(cmd)
    end
end)

events.mouse_input:set(function ()
    return not (ui.get_alpha() > 0)
end) 

events.shutdown:set(function ()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
    cvar.r_aspectratio:float(0)
    cvar.cl_righthand:int(1)
    common.set_clan_tag('')
    db.configs_debug = configs_db
end)

events.render:set(function ()
    if ui.get_alpha() > 0.1 then
        hide_func(false)
    end
end)

events.shutdown:set(function ()
    hide_func(true)
end)

local function set_tab_callback(menu, options)
    menu:set_callback(function(self)
        local num = self:get()
        local name = {}
        for i, option in ipairs(options) do
            name[i] = (num == i and "\a" .. style_hex .. ui.get_icon('caret-right') .. '\aFFFFFFFF  ' or '') .. option
        end
        self:update(name)
    end)
end

set_tab_callback(menu.antiaim.select.select_tab, {"Main", "Builder", "Logical"})
set_tab_callback(menu.visual.list, {"Rage","Visual", "Misc", "Features"})

local dependencies = {
    {menu = menu.antiaim.condition.condition,  depend = {{menu.antiaim.select.select_tab, 2}}},
    {menu = menu.visual.vgui,                  depend = {{menu.visual.list, 2}}},
    {menu = menu.antiaim.main,                 depend = {{menu.antiaim.select.select_tab, 1}}},
    {menu = menu.antiaim.additions,            depend = {{menu.antiaim.select.select_tab, 1}}},
    {menu = menu.rage.main,                    depend = {{menu.visual.list, 1}}},
    {menu = menu.rage.adaptivehit,             depend = {{menu.visual.list, 1}}},
    {menu = menu.rage.adaptivehit.multisel,    depend = {menu.rage.adaptivehit}},
    {menu = menu.rage.adaptivehit.scout,       depend = {menu.rage.adaptivehit, {menu.rage.adaptivehit.multisel, "Scout"}}},
    {menu = menu.rage.adaptivehit.r8,          depend = {menu.rage.adaptivehit, {menu.rage.adaptivehit.multisel, "R8"}}},
    {menu = menu.rage.adaptivehit.scar,        depend = {menu.rage.adaptivehit, {menu.rage.adaptivehit.multisel, "AutoSnipers"}}},
    {menu = menu.visual.vgui.vguicol,          depend = {menu.visual.vgui}},
    {menu = menu.antiaim.second.breaker,       depend = {menu.antiaim.main.anims}},
    {menu = menu.antiaim.logic,                depend = {{menu.antiaim.select.select_tab, 3}}},
    {menu = menu.visual.other,                 depend = {{menu.visual.list, 2}}},
    {menu = menu.misc.dva.avoidcol.dist,       depend = {menu.misc.dva.avoidcol}},
    {menu = menu.visual.indicators,            depend = {{menu.visual.list, 2}}},
    {menu = menu.visual.indicators.cross.offset,depend = {menu.visual.indicators.cross}},
    {menu = menu.visual.indicators.manual.style,depend = {menu.visual.indicators.manual}},
    {menu = menu.visual.other.logs.settings,   depend = {menu.visual.other.logs}},
    {menu = menu.visual.other.scope.inverted,  depend = {menu.visual.other.scope}},
    {menu = menu.visual.other.scope.color,     depend = {menu.visual.other.scope}},
    {menu = menu.visual.other.scope.length,    depend = {menu.visual.other.scope}},
    {menu = menu.visual.other.scope.offset,    depend = {menu.visual.other.scope}},
    {menu = menu.misc.first,                   depend = {{menu.visual.list, 3}}},
    {menu = menu.misc.dva,                     depend = {{menu.visual.list, 4}}},
    {menu = menu.misc.second.viewmodel,        depend = {menu.misc.first.viewmodel, {menu.visual.list, 3}}},
    {menu = menu.misc.second.ratio,            depend = {menu.misc.first.aspect, {menu.visual.list, 3}}},
}

for _, dep in ipairs(dependencies) do
    pui.traverse(dep.menu, function(ref, path)
        ref:depend(unpack(dep.depend))
    end)
end

-- menu.misc.second.viewmodel.switchknife:set_callback(switchKnifeHandler)
------------------------------------------------------------------------------
-- #region global config
local config_all = pui.setup({menu.antiaim, menu.antiaim.second, menu.visual, menu.rage, menu.misc, menu.misc.second, aa_condition}, true)

menu.visual.configexp = tabs.config:button(ui.get_icon('share-nodes').."\v   Export Config  ", function()
    clipboard.set(base64.encode(json.stringify(config_all:save())))
    cvar.play:call("ambient\\tones\\elev1")
end, true)
menu.visual.configimp = tabs.config:button(ui.get_icon('download').."\v    Import Config   ", function()
    config_all:load(json.parse(base64.decode(clipboard.get())))
    cvar.play:call("ambient\\tones\\elev1")
end, true)

menu.visual.configdef = tabs.config:button(ui.get_icon('check').."\v                        Default Config                         ", function()
    config_all:load(json.parse(base64.decode("W3siYWRkaXRpb25zIjp7ImFkZGl0aW9ucyI6WyJ+Il0sIndwbl9zZWxlY3QiOlsifiJdfSwiY29uZGl0aW9uIjp7ImNvbmRpdGlvbiI6Ik1hbnVhbCJ9LCJlbmFibGVfbGlzdCI6Mi4wLCJtYWluIjp7ImFuaW1zIjp0cnVlLCJjdXN0b21feWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJmcmVlc3RhbmQiOmZhbHNlfSwic2Vjb25kIjp7ImJyZWFrZXIiOnsiYWlyYnJlYWtlciI6IlN0YXRpYyBMZWdzIEluIEFpciIsImdyb3VuZGJyZWFrZXIiOiJKaXR0ZXIiLCJsZWdzX2ppdCI6ODAuMCwib3RoYnJlYWtlciI6WyJ+Il19LCJtYWluIjp7InN0YXRpY2ZyZWVzIjpbIn4iXX19LCJzZWxlY3QiOnsic2VsZWN0X3RhYiI6Mi4wfX0seyJicmVha2VyIjp7ImFpcmJyZWFrZXIiOiJTdGF0aWMgTGVncyBJbiBBaXIiLCJncm91bmRicmVha2VyIjoiSml0dGVyIiwibGVnc19qaXQiOjgwLjAsIm90aGJyZWFrZXIiOlsifiJdfSwibWFpbiI6eyJzdGF0aWNmcmVlcyI6WyJ+Il19fSx7ImluZGljYXRvcnMiOnsiY3Jvc3NfaW5kaWNhdG9ycyI6dHJ1ZSwidmVsb2NpdHlfaW5kaWNhdG9yX2VuYWJsZSI6dHJ1ZX0sImxpc3QiOjEuMCwib3RoZXIiOnsiZW5hYmxlbG9ncyI6dHJ1ZSwibWluZG1nIjp0cnVlLCJzY29wZWN1c3RvbSI6dHJ1ZX0sInNlY29uZCI6eyJpbmRpY2F0b3JzIjp7ImNyb3NzX2luZF9jb2xvciI6IiNCRUQ0RkZGRiIsImNyb3NzX2luZF9vZmZzZXQiOjE1LjB9LCJsb2dzIjp7InNldHRpbmdzIjpbMS4wLDIuMCwzLjAsIn4iXX0sInNjb3BlIjp7ImNvbG9yIjoiI0ZGRkZGRkZGIiwiaW52ZXJ0ZWQiOmZhbHNlLCJsZW5ndGgiOjU1LjAsIm9mZnNldCI6MTEuMH0sInZlbG9jaXR5Ijp7ImNvbG9yXzEiOiIjRkZGRkZGRkYiLCJjb2xvcl8yIjoiIzc4Nzg3OEZGIn19fSx7ImluZGljYXRvcnMiOnsiY3Jvc3NfaW5kX2NvbG9yIjoiI0JFRDRGRkZGIiwiY3Jvc3NfaW5kX29mZnNldCI6MTUuMH0sImxvZ3MiOnsic2V0dGluZ3MiOlsxLjAsMi4wLDMuMCwifiJdfSwic2NvcGUiOnsiY29sb3IiOiIjRkZGRkZGRkYiLCJpbnZlcnRlZCI6ZmFsc2UsImxlbmd0aCI6NTUuMCwib2Zmc2V0IjoxMS4wfSwidmVsb2NpdHkiOnsiY29sb3JfMSI6IiNGRkZGRkZGRiIsImNvbG9yXzIiOiIjNzg3ODc4RkYifX0seyJkdmEiOnsiZmFzdF9sYWRkZXIiOnRydWUsIm5hZGVfZml4Ijp0cnVlLCJub19mYWxsX2RhbWFnZSI6dHJ1ZX0sImZpcnN0Ijp7ImFzcGVjdCI6dHJ1ZSwiY2xhbnRhZyI6dHJ1ZSwidmlld21vZGVsIjp0cnVlfSwic2Vjb25kIjp7InJhdGlvIjp7InZhbHVlIjoxNTAuMH0sInZpZXdtb2RlbCI6eyJmb3YiOjY0LjAsInN3aXRjaGtuaWZlIjp0cnVlLCJ4IjotMi4wLCJ5IjotNC4wLCJ6IjotMy4wfX19LHsicmF0aW8iOnsidmFsdWUiOjE1MC4wfSwidmlld21vZGVsIjp7ImZvdiI6NjQuMCwic3dpdGNoa25pZmUiOnRydWUsIngiOi0yLjAsInkiOi00LjAsInoiOi0zLjB9fSxbeyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6OC4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6ZmFsc2UsImFiX2xieV9sMSI6NTEuMCwiYWJfbGJ5X2wyIjo1MS4wLCJhYl9sYnlfbDMiOjYwLjAsImFiX2xieV9yMSI6NTIuMCwiYWJfbGJ5X3IyIjo0Mi4wLCJhYl9sYnlfcjMiOjYwLjAsImFiX3BoYXNlcyI6MS4wLCJhYl9zZWxlY3QxIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MiI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDMiOlsifiJdLCJhYl95YXdfbDEiOi0zNC4wLCJhYl95YXdfbDIiOi0zMy4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjozOC4wLCJhYl95YXdfcjIiOjM3LjAsImFiX3lhd19yMyI6MC4wLCJhYl95YXdfdHlwZTEiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTIiOiJEZWxheSBTd2l0Y2giLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6IkFsd2F5cyBPbiIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo1OC4wLCJsYnlfciI6NTguMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMzQuMCwieWF3X3IiOjM5LjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6ZmFsc2UsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3lhd190eXBlIjoiT2ZmIiwiZGVsYXlfdGlja3MiOjEuMCwiZW5hYmxlIjpmYWxzZSwiaml0X3R5cGUiOiJEaXNhYmxlZCIsImppdHRlcl9jZW50ZXIiOjAuMCwibGJ5X2wiOjYwLjAsImxieV9yIjo2MC4wLCJvcHRpb25zIjpbIn4iXSwieWF3X2wiOjAuMCwieWF3X3IiOjAuMCwieWF3X3R5cGUiOiJEZWZhdWx0In0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX2RlZl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMyI6Ik9mZiIsImFiX2RlbGF5X3RpY2tzMSI6Ni4wLCJhYl9kZWxheV90aWNrczIiOjEuMCwiYWJfZGVsYXlfdGlja3MzIjoxLjAsImFiX2VuYWJsZSI6dHJ1ZSwiYWJfbGJ5X2wxIjo0OC4wLCJhYl9sYnlfbDIiOjQyLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo1MC4wLCJhYl9sYnlfcjIiOjQ2LjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoyLjAsImFiX3NlbGVjdDEiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QyIjpbIllhdyIsIkRlc3luYyIsIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6LTMwLjAsImFiX3lhd19sMiI6LTI3LjAsImFiX3lhd19sMyI6MC4wLCJhYl95YXdfcjEiOjQxLjAsImFiX3lhd19yMiI6MzguMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMiI6IkRlbGF5IFN3aXRjaCIsImFiX3lhd190eXBlMyI6IkRlZmF1bHQiLCJib2R5eWF3Ijp0cnVlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiT2ZmIiwiZGVsYXlfdGlja3MiOjMuMCwiZW5hYmxlIjp0cnVlLCJqaXRfdHlwZSI6IkRpc2FibGVkIiwiaml0dGVyX2NlbnRlciI6MC4wLCJsYnlfbCI6NTguMCwibGJ5X3IiOjU3LjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6LTMwLjAsInlhd19yIjo0MS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJPbiBQZWVrIiwiZGVmX3lhd190eXBlIjoiT2ZmIiwiZGVsYXlfdGlja3MiOjMwLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjo2My4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsiQW50aSBCcnV0ZWZvcmNlIiwifiJdLCJ5YXdfbCI6LTE1LjAsInlhd19yIjoxNS4wLCJ5YXdfdHlwZSI6IkRlbGF5IFN3aXRjaCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6dHJ1ZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjotNjIuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjU4LjAsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiU2lkZS1XYXkiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo1OC4wLCJsYnlfciI6NTguMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMTkuMCwieWF3X3IiOjM5LjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjp0cnVlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjQuMCwiZGVmX3BpdGNoX3R5cGUiOiJDdXN0b20iLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiQWx3YXlzIE9uIiwiZGVmX3lhd190eXBlIjoiRGVmYXVsdCIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6dHJ1ZSwiaml0X3R5cGUiOiJDZW50ZXIiLCJqaXR0ZXJfY2VudGVyIjozMC4wLCJsYnlfbCI6NjAuMCwibGJ5X3IiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJ5YXdfbCI6MTEuMCwieWF3X3IiOi0xMS4wLCJ5YXdfdHlwZSI6IkRlZmF1bHQifSx7ImFiX2RlZl9waXRjaF90eXBlMSI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMiI6Ik9mZiIsImFiX2RlZl9waXRjaF90eXBlMyI6Ik9mZiIsImFiX2RlZl90eXBlMSI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTIiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUzIjoiT24gUGVlayIsImFiX2RlZl95YXdfdHlwZTEiOiJEZWZhdWx0IiwiYWJfZGVmX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjo3LjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjp0cnVlLCJhYl9sYnlfbDEiOjQ2LjAsImFiX2xieV9sMiI6NDkuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjQwLjAsImFiX2xieV9yMiI6NDQuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjIuMCwiYWJfc2VsZWN0MSI6WyJZYXciLCJEZXN5bmMiLCJ+Il0sImFiX3NlbGVjdDIiOlsiWWF3IiwiRGVzeW5jIiwifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjotMjAuMCwiYWJfeWF3X2wyIjotMjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6NDIuMCwiYWJfeWF3X3IyIjo0MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUyIjoiRGVsYXkgU3dpdGNoIiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOnRydWUsImRlZl8xd2F5IjozMC4wLCJkZWZfMndheSI6MC4wLCJkZWZfM3dheSI6LTMwLjAsImRlZl9hYSI6ZmFsc2UsImRlZl9tYXgiOjIwLjAsImRlZl9taW4iOjIwLjAsImRlZl9waXRjaCI6MC4wLCJkZWZfcGl0Y2hfdHlwZSI6Ik9mZiIsImRlZl9zZW5zIjo1MC4wLCJkZWZfc2lkZSI6OTAuMCwiZGVmX3R5cGUiOiJBbHdheXMgT24iLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo1Ny4wLCJsYnlfciI6NTguMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjotMTkuMCwieWF3X3IiOjQ0LjAsInlhd190eXBlIjoiRGVsYXkgU3dpdGNoIn0seyJhYl9kZWZfcGl0Y2hfdHlwZTEiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTIiOiJPZmYiLCJhYl9kZWZfcGl0Y2hfdHlwZTMiOiJPZmYiLCJhYl9kZWZfdHlwZTEiOiJPbiBQZWVrIiwiYWJfZGVmX3R5cGUyIjoiT24gUGVlayIsImFiX2RlZl90eXBlMyI6Ik9uIFBlZWsiLCJhYl9kZWZfeWF3X3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3lhd190eXBlMiI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTMiOiJPZmYiLCJhYl9kZWxheV90aWNrczEiOjEuMCwiYWJfZGVsYXlfdGlja3MyIjoxLjAsImFiX2RlbGF5X3RpY2tzMyI6MS4wLCJhYl9lbmFibGUiOmZhbHNlLCJhYl9sYnlfbDEiOjYwLjAsImFiX2xieV9sMiI6NjAuMCwiYWJfbGJ5X2wzIjo2MC4wLCJhYl9sYnlfcjEiOjYwLjAsImFiX2xieV9yMiI6NjAuMCwiYWJfbGJ5X3IzIjo2MC4wLCJhYl9waGFzZXMiOjEuMCwiYWJfc2VsZWN0MSI6WyJ+Il0sImFiX3NlbGVjdDIiOlsifiJdLCJhYl9zZWxlY3QzIjpbIn4iXSwiYWJfeWF3X2wxIjowLjAsImFiX3lhd19sMiI6MC4wLCJhYl95YXdfbDMiOjAuMCwiYWJfeWF3X3IxIjowLjAsImFiX3lhd19yMiI6MC4wLCJhYl95YXdfcjMiOjAuMCwiYWJfeWF3X3R5cGUxIjoiRGVmYXVsdCIsImFiX3lhd190eXBlMiI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTMiOiJEZWZhdWx0IiwiYm9keXlhdyI6dHJ1ZSwiZGVmXzF3YXkiOjMwLjAsImRlZl8yd2F5IjowLjAsImRlZl8zd2F5IjotMzAuMCwiZGVmX2FhIjpmYWxzZSwiZGVmX21heCI6MjAuMCwiZGVmX21pbiI6MjAuMCwiZGVmX3BpdGNoIjowLjAsImRlZl9waXRjaF90eXBlIjoiT2ZmIiwiZGVmX3NlbnMiOjUwLjAsImRlZl9zaWRlIjo5MC4wLCJkZWZfdHlwZSI6Ik9uIFBlZWsiLCJkZWZfeWF3X3R5cGUiOiJPZmYiLCJkZWxheV90aWNrcyI6MS4wLCJlbmFibGUiOnRydWUsImppdF90eXBlIjoiQ2VudGVyIiwiaml0dGVyX2NlbnRlciI6LTE5LjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9LHsiYWJfZGVmX3BpdGNoX3R5cGUxIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUyIjoiT2ZmIiwiYWJfZGVmX3BpdGNoX3R5cGUzIjoiT2ZmIiwiYWJfZGVmX3R5cGUxIjoiT24gUGVlayIsImFiX2RlZl90eXBlMiI6Ik9uIFBlZWsiLCJhYl9kZWZfdHlwZTMiOiJPbiBQZWVrIiwiYWJfZGVmX3lhd190eXBlMSI6Ik9mZiIsImFiX2RlZl95YXdfdHlwZTIiOiJPZmYiLCJhYl9kZWZfeWF3X3R5cGUzIjoiT2ZmIiwiYWJfZGVsYXlfdGlja3MxIjoxLjAsImFiX2RlbGF5X3RpY2tzMiI6MS4wLCJhYl9kZWxheV90aWNrczMiOjEuMCwiYWJfZW5hYmxlIjpmYWxzZSwiYWJfbGJ5X2wxIjo2MC4wLCJhYl9sYnlfbDIiOjYwLjAsImFiX2xieV9sMyI6NjAuMCwiYWJfbGJ5X3IxIjo2MC4wLCJhYl9sYnlfcjIiOjYwLjAsImFiX2xieV9yMyI6NjAuMCwiYWJfcGhhc2VzIjoxLjAsImFiX3NlbGVjdDEiOlsifiJdLCJhYl9zZWxlY3QyIjpbIn4iXSwiYWJfc2VsZWN0MyI6WyJ+Il0sImFiX3lhd19sMSI6MC4wLCJhYl95YXdfbDIiOjAuMCwiYWJfeWF3X2wzIjowLjAsImFiX3lhd19yMSI6MC4wLCJhYl95YXdfcjIiOjAuMCwiYWJfeWF3X3IzIjowLjAsImFiX3lhd190eXBlMSI6IkRlZmF1bHQiLCJhYl95YXdfdHlwZTIiOiJEZWZhdWx0IiwiYWJfeWF3X3R5cGUzIjoiRGVmYXVsdCIsImJvZHl5YXciOmZhbHNlLCJkZWZfMXdheSI6MzAuMCwiZGVmXzJ3YXkiOjAuMCwiZGVmXzN3YXkiOi0zMC4wLCJkZWZfYWEiOmZhbHNlLCJkZWZfbWF4IjoyMC4wLCJkZWZfbWluIjoyMC4wLCJkZWZfcGl0Y2giOjAuMCwiZGVmX3BpdGNoX3R5cGUiOiJPZmYiLCJkZWZfc2VucyI6NTAuMCwiZGVmX3NpZGUiOjkwLjAsImRlZl90eXBlIjoiT24gUGVlayIsImRlZl95YXdfdHlwZSI6Ik9mZiIsImRlbGF5X3RpY2tzIjoxLjAsImVuYWJsZSI6ZmFsc2UsImppdF90eXBlIjoiRGlzYWJsZWQiLCJqaXR0ZXJfY2VudGVyIjowLjAsImxieV9sIjo2MC4wLCJsYnlfciI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInlhd19sIjowLjAsInlhd19yIjowLjAsInlhd190eXBlIjoiRGVmYXVsdCJ9XV0=")))
    cvar.play:call("ambient\\tones\\elev1")
end, true)
-- #region end
------------------------------------------------------------------------------