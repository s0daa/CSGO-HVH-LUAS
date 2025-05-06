local try_require = function (module, msg) local success, result = pcall(require, module) if success then return result else return error(msg) end end
local ffi = try_require('ffi', '~ Failed to require FFI, please make sure Allow unsafe scripts is enabled!')
local pui = try_require("gamesense/pui", '~ Failed to Load Interfaces: https://gamesense.pub/forums/viewtopic.php?id=41761')
local http = try_require('gamesense/http', '~ Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619')
local base64 = try_require('gamesense/base64', '~ Module base64 not found')
local clipboard = try_require('gamesense/clipboard', '~ Download clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678')
local vector = try_require('vector', '~ Missing vector')
local c_entity = try_require('gamesense/entity', '~ Download entity library: https://gamesense.pub/forums/viewtopic.php?id=27529')
local json = try_require('json', '~ Missing Json')
local gif_decoder = try_require('gamesense/gif_decoder', '~ Download gif decoder library: https://gamesense.pub/forums/viewtopic.php?id=')
local antiaim_funcs = try_require('gamesense/antiaim_funcs', '~ Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665')
local images = try_require('gamesense/images', '~ Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917')

local data = database.read("load") or {}
data.load_count = (data.load_count or 0) + 1
client.set_event_callback("shutdown", function()
database.write("load", data)
end)

local is_lua_loaded = false

local function hhh(arg_1)
    local xxx2 = {}

    for xxx3, xxx4 in next, arg_1 do
        xxx2[xxx3] = xxx4
    end

    return xxx2
end

local folder = "kittyhook"
local cute = vtable_bind
local hey = hhh(string)
local hey2 = hhh(require("ffi"))
local hey3 = defer

local nya = {}
local nya2 = "filesystem_stdio.dll"
local nya3 = "VFileSystem017"
local meow = cute(nya2, nya3, 11, "void (__thiscall*)(void*, const char*, const char*, int)")
local meow2 = cute(nya2, nya3, 12, "bool (__thiscall*)(void*, const char*, const char*)")
local meow3 = cute(nya2, nya3, 1, "int (__thiscall*)(void*, void const*, int, void*)")
local cutie1 = cute(nya2, nya3, 2, "void* (__thiscall*)(void*, const char*, const char*, const char*)")
local cutie2 = cute(nya2, nya3, 3, "void (__thiscall*)(void*, void*)")
local cutie3 = cute("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")

nya.game_directory = hey.sub(hey2.string(cutie3()), 1, -5)

meow(nya.game_directory, "ROOT_PATH", 0)
hey3(function()
    meow2(nya.game_directory, "ROOT_PATH")
end)

nya.create_directory = cute(nya2, nya3, 22, "void (__thiscall*)(void*, const char*, const char*)")
nya.create_directory(folder, "ROOT_PATH")

function download_file(link, path)
    http.get(link, function(success, response)
        if not success or response.status ~= 200 then
            client.error_log(string.format("Could not retrieve asset \"%s\" from server. Error code: %d", path, response.status))
            return
        end
    
        writefile(path, response.body)
    end)
end

function nya.write(arg_2, arg_3)

local eee = cutie1(arg_2, "wb", "ROOT_PATH")

    meow3(arg_3, #arg_3, arg_2)
    cutie2(eee)
end

local x_ind, y_ind = client.screen_size()

calculateGradien = function(color1, color2, text, speed)

    local output = ''
    
    local curtime = globals.curtime()
    
    for idx = 0, #text - 1 do  
        local x = idx * 10
        local wave = math.cos(8 * speed * curtime + x / 30)
    
        -- Интерполяция цвета
        local r = lerp(color1[1], color2[1], clamp(wave, 0, 1))
        local g = lerp(color1[2], color2[2], clamp(wave, 0, 1))
        local b = lerp(color1[3], color2[3], clamp(wave, 0, 1))
        local a = color1[4] 
    
        -- Формируем цвет в HEX формате
        local color = ('\a%02x%02x%02x%02x'):format(r, g, b, a)
        
        output = output .. color .. text:sub(idx + 1, idx + 1) -- Индекс + 1 для Lua
    end
    
    return output
end



local lua_group = pui.group("aa", "anti-aimbot angles")
local config_group = pui.group("aa", "anti-aimbot angles")
local defensive_group = pui.group("aa", "fake lag")
local other_group = pui.group("aa", "other")
pui.accent = "9FF7B3AE"

local antiaim_cond = {"Global\r", "Standing\r", "Walking\r", "Running\r", "Air\r", "Air+\r", "Duck\r", "Duck+Move\r"}
local short_cond = {
    "\aFFC0CBFFGlobal  \r＞ \r",
    "\aFFC0CBFFStandinging  \r＞ \r",
    "\aFFC0CBFFWalking  \r＞ \r",
    "\aFFC0CBFFRunning  \r＞ \r",
    "\aFFC0CBFFAir  \r＞ \r",
    "\aFFC0CBFFAir+C  \r＞ \r",
    "\aFFC0CBFFDuck  \r＞ \r",
    "\aFFC0CBFFDuck+Move  \r＞ \r"
}

local ref = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    roll = {ui.reference("AA", "Anti-aimbot angles", "Roll")},
    clantag = ui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
    fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
    fakelag_enable = ui.reference("AA", "Fake lag", "Enabled"),
    fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
    fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
    other_slowmotion = ui.reference("AA", "Other", "Slow motion"),
    other_legmovement = ui.reference("AA", "Other", "Leg movement"),
    other_osaa = ui.reference("AA", "Other", "On shot anti-aim"),
    other_fkpeek = ui.reference("AA", "Other", "Fake peek"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
    rage = {ui.reference("RAGE", "Aimbot", "Enabled")},
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    autopeek = {ui.reference("RAGE", "Other", "Quick peek assist")}
}

local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
local js = panorama.open()
local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI =
    js.MyPersonaAPI,
    js.LobbyAPI,
    js.PartyListAPI,
    js.SteamOverlayAPI 

local lua_menu = {
    main = {
        enable = lua_group:label("kittens"),
        main_color = lua_group:color_picker(" ", 255, 255, 255),
        labl = lua_group:label("\n"),
        tab = lua_group:combobox(
            "\aFFC0CBFFkittens ~ \aFFFFFFFF category \aFFFFFF2F [debug]",
            {"anti-aim", "visuals", "misc", "configuration"}
        )
    },
    antiaim = {
        lines14 = lua_group:label("\aFFC0CBFF"),
        lines13 = lua_group:label("\aFFC0CBFFkittens ~ \aFFFFFFFFanti-aimbot"),
        tab = lua_group:combobox("anti-aim system", {"main", "builder"}),
        yaw_base = lua_group:combobox("\v\ryaw base", {"local view", "at targets"}),
        addons = lua_group:multiselect("\v\rhelpers", {"warmup aa", "avoid backstab", "safe function"}),
        safe_head = lua_group:multiselect("\v\rSelection", {"air+c knife", "air+c taser", "high distance"}),
        yaw_direction = lua_group:multiselect("\v\roverride", {"freestanding", "manual"}),
        key_freestand = lua_group:hotkey("\v\rfreestanding"),
        freestand_type = lua_group:combobox("\v\rfreestand addons", {"default", "static", "jitter"}),
        manual_type = lua_group:combobox("\v\rmanual addons", {"default", "static", "jitter"}),
        key_left = lua_group:hotkey("\v\rmanual Left"),
        key_right = lua_group:hotkey("\v\rmanual Right"),
        key_forward = lua_group:hotkey("\v\rmanual Forward"),
        condition = lua_group:combobox("Conditions", antiaim_cond),
    },
    misc = {
        lines15 = lua_group:label("\aFFC0CBFF"),
        lines16 = lua_group:label("\aFFC0CBFF"),
        lines11 = lua_group:label("\aFFC0CBFFkittens ~ \aFFFFFFFFmiscellaneous"),
        lines12 = lua_group:label("\aFFC0CBFFkittens ~ \aFFFFFFFFvisuals"),
        cross_ind = lua_group:checkbox("\v\r~ crosshair indicators", {255, 255, 255}),
        cross_ind_type = lua_group:combobox("~  \v\rindicator style", {"kittyhook", "ideal yaw"}),
        arrows = lua_group:checkbox("~ \v\rarrows", {255, 255, 255}),
        spammers = lua_group:multiselect("\v\r~ spammers", {"shit talking"}),
        quick_switch = lua_group:checkbox("\v\r~ quick switch"),
        fast_ladder = lua_group:checkbox("\v\r~ fast ladder"),
        log1 = lua_group:checkbox("~ \v\raimbot "),
        log = lua_group:color_picker(" ", 255, 255, 255),
        watermark = lua_group:checkbox("~ \v\rbranded watermark", {255, 255, 255}),
        multibox4 = lua_group:multiselect("~ type", {"console", "screen", "statistic"}),
        watermark_type = lua_group:combobox("~ watermark position", {"Left", "Right", "Bottom"}),
        screen_type = lua_group:combobox("  \v\r~ log style", {"default"}),
        animation = lua_group:checkbox("\v\r~ animation breakers"),
        animation_ground = lua_group:combobox("~  \v\rground", {"static", "jitter", "randomize"}),
        animation_value = lua_group:slider("~  \v\rvalue", 0, 10, 5),
        animation_air = lua_group:combobox("~  \v\rair", {"off", "static", "randomize"}),
        resolver_enabled = defensive_group:checkbox("~ \aFFFFFFFFKitty\aFFC0CBFFSolver"),
        esp_flags = defensive_group:checkbox("~ ESP flags"),
        esp_flags_color = defensive_group:color_picker(" ", 255, 255, 255, 255),
        multibox = defensive_group:multiselect("Force body aim", {"HP lower than X"}),
        health = defensive_group:slider("\aFFFFFFFF~" .. " \aFFC0CBFFHP", 0, 100, 50, true),
        multibox2 = defensive_group:multiselect("Force safe point", {"HP lower than X", "after X misses"}),
        health2 = defensive_group:slider("\aFFFFFFFF~" .. " \aFFC0CBFFHP", 0, 100, 50, true),
        missed = defensive_group:slider("\aFFFFFFFF~" .. " \aFFC0CBFFMissed", 0, 10, 0, true),
        invis = defensive_group:label("\n"),
    },
    
    config = {
        lines19 = lua_group:label("\aFFC0CBFF"),
        lines21 = lua_group:label("\aFFC0CBFF Kittyhook ~ \aFFFFFFFFconfigurations"),
        buttom_import = config_group:button(
            "\aFFC0CBFF Kittyhook ~ \aFFFFFFFFimport",
            function()
                client.color_log(255, 226, 243, "kittyhook ~ successfully imported")
                config.import()
            end
        ),
        buttom_export = config_group:button(
            "\aFFC0CBFF Kittyhook ~ \aFFFFFFFFexport",
            function()
                client.color_log(255, 226, 243, "kittyhook ~ successfully exported to clipboard!")
                config.export()
            end
        ),
        buttom_default = config_group:button(
            "  \aFFC0CBFF Kittyhook ~ \aFFFFFFFFlive preset",
            function()
                config.import(
                    "W3sibWFpbiI6eyJtYWluX2NvbG9yIjoiI0M1QkRGOUZGIiwidGFiIjoiY29uZmlndXJhdGlvbiJ9LCJhbnRpYWltIjp7InRhYiI6Im1haW4iLCJhZGRvbnMiOlsid2FybXVwIGFhIiwiYXZvaWQgYmFja3N0YWIiLCJ+Il0sInlhd19kaXJlY3Rpb24iOlsiZnJlZXN0YW5kaW5nIiwifiJdLCJrZXlfZm9yd2FyZCI6WzEsMCwifiJdLCJrZXlfbGVmdCI6WzEsOTAsIn4iXSwiY29uZGl0aW9uIjoiUnVubmluZ1xyIiwia2V5X3JpZ2h0IjpbMSw4OCwifiJdLCJtYW51YWxfdHlwZSI6ImRlZmF1bHQiLCJ5YXdfYmFzZSI6ImF0IHRhcmdldHMiLCJrZXlfZnJlZXN0YW5kIjpbMSwxOCwifiJdLCJmcmVlc3RhbmRfdHlwZSI6ImppdHRlciIsInNhZmVfaGVhZCI6WyJ+Il19LCJtaXNjIjp7ImxvZyI6dHJ1ZSwibXVsdGlib3g0IjpbImNvbnNvbGUiLCJzY3JlZW4iLCJ+Il0sImNyb3NzX2luZCI6dHJ1ZSwiYW5pbWF0aW9uIjpmYWxzZSwid2F0ZXJtYXJrIjp0cnVlLCJjcm9zc19pbmRfdHlwZSI6ImtpdHR5aG9vayIsInJlc29sdmVyX2VuYWJsZWQiOnRydWUsImFuaW1hdGlvbl9icmVha2VyX2F1dG9wZWVrIjp0cnVlLCJsb2dfYyI6IiNDNUJERjlGRiIsIndhdGVybWFya190eXBlIjoiQm90dG9tIiwiYW5pbWF0aW9uX2FpciI6InN0YXRpYyIsImFycm93cyI6ZmFsc2UsImFycm93c19jIjoiI0ZGRkZGRkZGIiwiYW5pbWF0aW9uX2dyb3VuZCI6ImppdHRlciIsImZhc3RfbGFkZGVyIjp0cnVlLCJtdWx0aWJveCI6WyJ+Il0sIndhdGVybWFya19jIjoiI0NBOTVDMUZGIiwic3BhbW1lcnMiOlsic2hpdCB0YWxraW5nIiwifiJdLCJtdWx0aWJveDIiOlsiSFAgbG93ZXIgdGhhbiIsImFmdGVyIFggbWlzc2VzIiwifiJdLCJoZWFsdGgyIjoyMSwiaGVhbHRoIjoyMSwiYW5pbWF0aW9uX3ZhbHVlIjo0LCJjcm9zc19pbmRfYyI6IiNDNUJERjlGRiIsInNjcmVlbl90eXBlIjoiZGVmYXVsdCIsIm1pc3NlZCI6MiwicXVpY2tfc3dpdGNoIjp0cnVlfX0sW3siZW5hYmxlIjpmYWxzZSwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjQsInlhd19vZmZzZXQiOmZhbHNlLCJ5YXdfZGVsYXlfcmFuZG9tIjowLCJ5YXdfbHIiOmZhbHNlLCJib2R5X3NsaWRlciI6MCwieWF3X2xlZnQiOjAsInlhd19yYW5kb20iOjAsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwieWF3X29mZnNldF9zbGlkZXIiOjB9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwieWF3X29mZnNldCI6ZmFsc2UsInlhd19kZWxheV9yYW5kb20iOjAsInlhd19sciI6dHJ1ZSwiYm9keV9zbGlkZXIiOi01NCwieWF3X2xlZnQiOi0xMiwieWF3X3JhbmRvbSI6MCwibW9kX2RtIjoyMSwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MzQsInlhd19vZmZzZXRfc2xpZGVyIjo1Mn0seyJlbmFibGUiOnRydWUsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5Ijo1LCJ5YXdfb2Zmc2V0IjpmYWxzZSwieWF3X2RlbGF5X3JhbmRvbSI6MCwieWF3X2xyIjp0cnVlLCJib2R5X3NsaWRlciI6MSwieWF3X2xlZnQiOi0xOSwieWF3X3JhbmRvbSI6MTQsIm1vZF9kbSI6NDYsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjQzLCJ5YXdfb2Zmc2V0X3NsaWRlciI6MH0seyJlbmFibGUiOnRydWUsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5IjoyLCJ5YXdfb2Zmc2V0IjpmYWxzZSwieWF3X2RlbGF5X3JhbmRvbSI6MSwieWF3X2xyIjp0cnVlLCJib2R5X3NsaWRlciI6LTE4MCwieWF3X2xlZnQiOi0xNCwieWF3X3JhbmRvbSI6MCwibW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwieWF3X3JpZ2h0IjozNywieWF3X29mZnNldF9zbGlkZXIiOjB9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6MSwieWF3X29mZnNldCI6ZmFsc2UsInlhd19kZWxheV9yYW5kb20iOjIsInlhd19sciI6dHJ1ZSwiYm9keV9zbGlkZXIiOjEsInlhd19sZWZ0IjotMTYsInlhd19yYW5kb20iOjAsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MjMsInlhd19vZmZzZXRfc2xpZGVyIjowfSx7ImVuYWJsZSI6dHJ1ZSwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjEsInlhd19vZmZzZXQiOmZhbHNlLCJ5YXdfZGVsYXlfcmFuZG9tIjoxLCJ5YXdfbHIiOnRydWUsImJvZHlfc2xpZGVyIjotMTgwLCJ5YXdfbGVmdCI6LTI1LCJ5YXdfcmFuZG9tIjowLCJtb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjMwLCJ5YXdfb2Zmc2V0X3NsaWRlciI6MH0seyJlbmFibGUiOnRydWUsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5IjoxLCJ5YXdfb2Zmc2V0IjpmYWxzZSwieWF3X2RlbGF5X3JhbmRvbSI6MCwieWF3X2xyIjp0cnVlLCJib2R5X3NsaWRlciI6NSwieWF3X2xlZnQiOi0xOSwieWF3X3JhbmRvbSI6MCwibW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwieWF3X3JpZ2h0IjozNCwieWF3X29mZnNldF9zbGlkZXIiOjB9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6MCwieWF3X29mZnNldCI6ZmFsc2UsInlhd19kZWxheV9yYW5kb20iOjMsInlhd19sciI6dHJ1ZSwiYm9keV9zbGlkZXIiOi0xNTYsInlhd19sZWZ0IjotMTksInlhd19yYW5kb20iOjAsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MjUsInlhd19vZmZzZXRfc2xpZGVyIjowfV1d"
                )
                client.color_log(255, 226, 243, "kittyhook ~ successfully imported default config!")
            end)
    },  
    statistic = {
        buttonsd = other_group:button(
            "join us: \aE899AFFFbut better in me :3",
            function()
                SteamOverlayAPI.OpenExternalBrowserURL("https://www.pornhub.com/video/search?search=tranny&page=3")
            end
            )  
        },
    }

local antiaim_builder2 = {}

for i = 1, #antiaim_cond do
    antiaim_builder2[i] = {
        enable2 = lua_group:checkbox("Enable ~ " .. antiaim_cond[i]),
        yaw_offset = lua_group:checkbox(short_cond[i] .. "Yaw Offset"),
        yaw_offset_slider  = lua_group:slider(short_cond[i] .. "Offset", -180, 180, 0, true, "°", 1),
        yaw_lr = lua_group:checkbox(short_cond[i] .. "Yaw ~ \aFFFFFF2F[L/R]"),
        delay = lua_group:checkbox(short_cond[i] .. " Delay"),
        yaw_left2 = lua_group:slider(short_cond[i] .. " Yaw Left", -180, 180, 0, true, "°", 1),
        yaw_right2 = lua_group:slider(short_cond[i] .. " Yaw Right", -180, 180, 0, true, "°", 1),
        mod_type2 = lua_group:combobox(short_cond[i] .. " Jitter Type", {"Off", "Offset", "Center", "Random", "Skitter"}),
        mod_dm2 = lua_group:slider(short_cond[i] .. " Jitter Amount", -180, 180, 0, true, "°", 1),
        body_yaw_type2 = lua_group:combobox(short_cond[i] .. " Body Yaw", {"Off", "Opposite", "Jitter", "Static"}),
        body_slider2 = lua_group:slider(short_cond[i] .. " Body Yaw Amount", -180, 180, 0, true, "°", 1),
        yaw_delay2 = lua_group:slider(short_cond[i] .. " Delay Ticks", 0, 10, 0, true, "t", 1),
        yaw_delay_random2 = lua_group:slider(short_cond[i] .. "Delay Randomize Ticks",  0, 10, 0, true, "t", 1),
        yaw_random2 = lua_group:slider(short_cond[i] .. " Randomization", 0, 100, 0, true, "%", 1),
    }
end

local aa_tab = {lua_menu.main.tab, "anti-aim"}
local misc_tab = {lua_menu.main.tab, "misc"}
local visual_tab = {lua_menu.main.tab, "visuals"}
local config_tab = {lua_menu.main.tab, "configuration"}
local aa_builder = {lua_menu.antiaim.tab, "builder"}
local aa_main = {lua_menu.antiaim.tab, "main"}

lua_menu.antiaim.tab:depend(aa_tab)
lua_menu.antiaim.lines13:depend(aa_tab)
lua_menu.antiaim.lines14:depend(aa_tab)
lua_menu.antiaim.addons:depend(aa_tab, aa_main)
lua_menu.antiaim.safe_head:depend(aa_tab, {lua_menu.antiaim.addons, "safe function"}, aa_main)
lua_menu.antiaim.yaw_base:depend(aa_tab, aa_main)
lua_menu.antiaim.condition:depend(aa_tab, aa_builder)
lua_menu.antiaim.yaw_direction:depend(aa_tab, aa_main)
lua_menu.antiaim.freestand_type:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "freestanding"}, aa_builder)
lua_menu.antiaim.manual_type:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "manual"}, aa_builder)
lua_menu.antiaim.key_freestand:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "freestanding"}, aa_main)
lua_menu.antiaim.key_left:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "manual"}, aa_main)
lua_menu.antiaim.key_right:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "manual"}, aa_main)
lua_menu.antiaim.key_forward:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "manual"}, aa_main)
lua_menu.misc.cross_ind:depend(visual_tab)
lua_menu.misc.cross_ind_type:depend(visual_tab, {lua_menu.misc.cross_ind, true})
lua_menu.misc.watermark:depend(visual_tab)

lua_menu.main.main_color:depend(aa_tab, {lua_menu.main.tab, "anti-aim"}, {lua_menu.antiaim.tab, "main"})

lua_menu.misc.lines11:depend(misc_tab)
lua_menu.misc.lines12:depend(visual_tab)
lua_menu.misc.lines15:depend(visual_tab)
lua_menu.misc.lines16:depend(misc_tab)
lua_menu.config.lines21:depend(config_tab)
lua_menu.misc.multibox4:depend(visual_tab, {lua_menu.misc.log1, true})
lua_menu.misc.log1:depend(visual_tab)
lua_menu.misc.screen_type:depend(visual_tab, {lua_menu.misc.log1, true}, {lua_menu.misc.log1, "aimbot logs"})
lua_menu.misc.log:depend(visual_tab, {lua_menu.misc.log1, true})
lua_menu.misc.fast_ladder:depend(misc_tab)
lua_menu.misc.animation:depend(misc_tab)
lua_menu.misc.invis:depend(misc_tab)
lua_menu.config.buttom_default:depend(config_tab)
lua_menu.config.buttom_export:depend(config_tab)
lua_menu.config.buttom_import:depend(config_tab)
lua_menu.statistic.buttonsd:depend(aa_main, {lua_menu.main.tab, "anti-aim"})
lua_menu.misc.animation_ground:depend(misc_tab, {lua_menu.misc.animation, true})
lua_menu.misc.animation_value:depend(misc_tab, {lua_menu.misc.animation, true})
lua_menu.misc.animation_air:depend(misc_tab, {lua_menu.misc.animation, true})
lua_menu.misc.resolver_enabled:depend(misc_tab)
lua_menu.misc.health:depend(misc_tab, {lua_menu.misc.resolver_enabled, true}, {lua_menu.misc.multibox, "HP lower than X"})
lua_menu.misc.health2:depend(misc_tab, {lua_menu.misc.resolver_enabled, true},{lua_menu.misc.multibox2, "HP lower than X"})
lua_menu.misc.missed:depend(misc_tab, {lua_menu.misc.resolver_enabled, true}, {lua_menu.misc.multibox2, "after X misses"})
lua_menu.misc.multibox:depend(misc_tab, {lua_menu.misc.resolver_enabled, true})
lua_menu.misc.multibox2:depend(misc_tab, {lua_menu.misc.resolver_enabled, true})
lua_menu.misc.spammers:depend(misc_tab)
lua_menu.misc.arrows:depend(visual_tab)
lua_menu.misc.watermark_type:depend(visual_tab, {lua_menu.misc.watermark, true})
lua_menu.misc.quick_switch:depend(misc_tab)
lua_menu.misc.esp_flags:depend(misc_tab, {lua_menu.misc.resolver_enabled, true})
lua_menu.misc.esp_flags_color:depend(misc_tab, {lua_menu.misc.esp_flags, true}, {lua_menu.misc.resolver_enabled, true})

for i = 1, #antiaim_cond do
    local cond_check = {lua_menu.antiaim.condition, function() return (i ~= 1) end}
    local tab_cond = {lua_menu.antiaim.condition, antiaim_cond[i]}
    local cnd_en = {antiaim_builder2[i].enable2, function()if (i == 1) then return true else return antiaim_builder2[i].enable2:get() end end}
    local aa_tab = {lua_menu.main.tab, "anti-aim"}
    local yaw_ch =  {antiaim_builder2[i].yaw_offset, true}
    local yaw_ch2 =  {antiaim_builder2[i].yaw_offset, false}
    local yaw_ch_lr = {antiaim_builder2[i].yaw_lr, true}
    local yaw_ch_lr2 = {antiaim_builder2[i].yaw_lr, false}
    local jit_ch = {antiaim_builder2[i].mod_type2, function() return antiaim_builder2[i].mod_type2:get() ~= "Off" end}
    local body_ch = {antiaim_builder2[i].body_yaw_type2, function() return antiaim_builder2[i].body_yaw_type2:get() ~= "Off" end}
    local delay_ch = {antiaim_builder2[i].delay, true}
    antiaim_builder2[i].enable2:depend(cond_check, tab_cond, aa_tab, aa_builder)
    antiaim_builder2[i].yaw_random2:depend(cnd_en, tab_cond, aa_tab, aa_builder)
    antiaim_builder2[i].mod_type2:depend(cnd_en, tab_cond, aa_tab, aa_builder)

    antiaim_builder2[i].yaw_offset:depend(cnd_en, tab_cond, aa_tab, aa_builder)
    antiaim_builder2[i].yaw_offset_slider:depend(cnd_en, tab_cond, yaw_ch, aa_tab, aa_builder)
    antiaim_builder2[i].yaw_lr:depend(cnd_en, tab_cond, aa_tab, aa_builder)
    antiaim_builder2[i].yaw_left2:depend(cnd_en, tab_cond, aa_tab, yaw_ch_lr, aa_builder)
    antiaim_builder2[i].yaw_right2:depend(cnd_en, tab_cond, aa_tab, yaw_ch_lr, aa_builder)
    antiaim_builder2[i].mod_dm2:depend(cnd_en, tab_cond, aa_tab, jit_ch, aa_builder)
    antiaim_builder2[i].body_yaw_type2:depend(cnd_en, tab_cond, aa_tab, aa_builder)
    antiaim_builder2[i].body_slider2:depend(cnd_en, tab_cond, aa_tab, body_ch, aa_builder)
    antiaim_builder2[i].yaw_delay2:depend(cnd_en, tab_cond, aa_tab, delay_ch, aa_builder)
    antiaim_builder2[i].yaw_delay_random2:depend(cnd_en, tab_cond, aa_tab, delay_ch, aa_builder)
    antiaim_builder2[i].delay:depend(cnd_en, tab_cond, aa_tab, aa_builder)

    
    antiaim_builder2[i].yaw_left2:depend(cnd_en, tab_cond, aa_tab, yaw_ch2, aa_builder)
    antiaim_builder2[i].yaw_right2:depend(cnd_en, tab_cond, aa_tab, yaw_ch2, aa_builder) 
    antiaim_builder2[i].yaw_lr:depend(cnd_en, tab_cond, aa_tab, yaw_ch2, aa_builder)
    antiaim_builder2[i].yaw_offset:depend(cnd_en, tab_cond, aa_tab, yaw_ch_lr2, aa_builder)
    antiaim_builder2[i].yaw_offset_slider:depend(cnd_en, tab_cond, yaw_ch_lr2, aa_tab, aa_builder)  
end

local function visible_menu(state)
    if lua_menu.main.tab:get() == "anti-aim" and lua_menu.antiaim.tab:get() == "builder" then
        ui.set_visible(ref.fakelag_amount, true)
        ui.set_visible(ref.fakelag_enable, true)
        ui.set_visible(ref.fakelag_limit, true)
        ui.set_visible(ref.other_fkpeek, true)
        ui.set_visible(ref.other_legmovement, true)
        ui.set_visible(ref.other_slowmotion, true)
        ui.set_visible(ref.other_osaa, true)
        ui.set_visible(ref.fakelag_variance, true)
    elseif lua_menu.main.tab:get() == "misc" then
        ui.set_visible(ref.fakelag_amount, false)
        ui.set_visible(ref.fakelag_enable, false)
        ui.set_visible(ref.fakelag_limit, false)
        ui.set_visible(ref.other_fkpeek, false)
        ui.set_visible(ref.other_legmovement, false)
        ui.set_visible(ref.other_slowmotion, false)
        ui.set_visible(ref.other_osaa, false)
        ui.set_visible(ref.fakelag_variance, false)
    end
    
end

local function hide_original_menu(state)
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.fakelag_amount, false)
    ui.set_visible(ref.fakelag_enable, false)
    ui.set_visible(ref.fakelag_limit, false)
    ui.set_visible(ref.other_fkpeek, false)
    ui.set_visible(ref.other_legmovement, false)
    ui.set_visible(ref.other_slowmotion, false)
    ui.set_visible(ref.other_osaa, false)
    ui.set_visible(ref.fakelag_variance, false)
    ui.set_visible(ref.pitch[1], state)
    ui.set_visible(ref.pitch[2], state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
    ui.set_visible(ref.roll[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
end

local function randomize_value(original_value, percent)
    local min_range = original_value - (original_value * percent / 100)
    local max_range = original_value + (original_value * percent / 100)
    return math.random(min_range, max_range)
end

local id = 1
local function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then
        return
    end

    local vecvelocity = {entity.get_prop(lp, "m_vecVelocity")}
    local flags = entity.get_prop(lp, "m_fFlags")
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local groundcheck = bit.band(flags, 1) == 1
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, "m_flDuckAmount") > 0.7
    local duckcheck = ducked or ui.get(ref.fakeduck)
    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if jumpcheck and duckcheck then
        return "Air+C"
    elseif jumpcheck then
        return "Air"
    elseif duckcheck and velocity > 10 then
        return "Duck-Moving"
    elseif duckcheck and velocity < 10 then
        return "Duck"
    elseif groundcheck and slowwalk_key and velocity > 10 then
        return "Walking"
    elseif groundcheck and velocity > 5 then
        return "Moving"
    elseif groundcheck and velocity < 5 then
        return "Standing"
    else
        return "Global"
    end

end
local yaw_direction = 0 
local last_press_t_dir = 0
local run_direction = function()

    ui.set(ref.freestand[1], lua_menu.antiaim.yaw_direction:get("freestanding"))
    ui.set(ref.freestand[2], lua_menu.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

    if yaw_direction ~= 0 then
        ui.set(ref.freestand[1], false)
    end

    if lua_menu.antiaim.yaw_direction:get("manual") and lua_menu.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
        yaw_direction = yaw_direction == 90 and 0 or 90
        last_press_t_dir = globals.curtime()
    elseif lua_menu.antiaim.yaw_direction:get("manual") and lua_menu.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
        yaw_direction = yaw_direction == -90 and 0 or -90 
        last_press_t_dir = globals.curtime()
    elseif lua_menu.antiaim.yaw_direction:get("manual") and lua_menu.antiaim.key_forward:get() and last_press_t_dir + 0.2 < globals.curtime() then
        yaw_direction = yaw_direction == 180 and 0 or 180
        last_press_t_dir = globals.curtime()
    elseif last_press_t_dir > globals.curtime() then
        last_press_t_dir = globals.curtime()
    end
    if not lua_menu.antiaim.yaw_direction:get("manual") then
        yaw_direction = 0 
        last_press_t_dir = 0
    end
end

local arrow_alpha = 0
local fade_in_speed = 600
local fade_out_speed = 1000

local function updatearrows()
    if yaw_direction == -90 or yaw_direction == 90 then
        arrow_alpha = math.min(255, arrow_alpha + (globals.frametime() * (fade_in_speed)))  
    else
        arrow_alpha = math.max(50, arrow_alpha - (globals.frametime() * (fade_out_speed )))
    end
end

local scoped_space = 0
local screen_width, screen_height = client.screen_size()
local function arrows()
    local arrows1, arrows2, arrows3, arrows4 = lua_menu.misc.arrows:get_color()
    local arrows_alpha = math.max(math.min(arrow_alpha, 255), 0)
    local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1
    scoped_space = math.lerp(scoped_space, scoped and 15 or 0, 5)
    if yaw_direction == -90 then
        renderer.text((screen_width / 2) - 55, ((screen_height/2) - 2) - scoped_space, arrows1, arrows2, arrows3, arrow_alpha , "c+d", 0, string.upper"<")
    end
    if yaw_direction == 90 then
        renderer.text((screen_width / 2) + 55, ((screen_height/2) - 2) - scoped_space, arrows1, arrows2, arrows3, arrows_alpha, "c+d", 0, string.upper">")
    end
end

client.set_event_callback('grenade_thrown', function(e)
    if not is_lua_loaded then return end

    if lua_menu.misc.quick_switch:get() then
        local lp = entity.get_local_player();
        local userid = client.userid_to_entindex(e.userid);
    
        if userid ~= lp then
        return
        end
    
        client.exec('slot3; slot2; slot1');
    end
end);

client.set_event_callback('weapon_fire', function(e)
    if not is_lua_loaded then return end
    if lua_menu.misc.quick_switch:get() then
        if e.weapon ~= 'weapon_taser' then
        return
        end

        local lp = entity.get_local_player();
        local userid = client.userid_to_entindex(e.userid);

        if userid ~= lp then
        return
        end
    
        client.exec('slot3; slot2; slot1');
    end
end);

anti_knife_dist = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

local function safe_func()
    ui.set(ref.yawjitter[1], "Off")
    ui.set(ref.yaw[1], "180")
    ui.set(ref.bodyyaw[1], "Static")
    ui.set(ref.bodyyaw[2], 0)
    ui.set(ref.yaw[2], 14)
    ui.set(ref.pitch[2], 89)
end

local current_tickcount = 0
local to_jitter = false
local yaw_amount = 0

local function aa_setup(cmd)
    local lp = entity.get_local_player()
    if lp == nil then
        return
    end
    if player_state(cmd) == "Duck-Moving" and antiaim_builder2[8].enable2:get() then
        id = 8
    elseif player_state(cmd) == "Duck" and antiaim_builder2[7].enable2:get() then
        id = 7
    elseif player_state(cmd) == "Air+C" and antiaim_builder2[6].enable2:get() then
        id = 6
    elseif player_state(cmd) == "Air" and antiaim_builder2[5].enable2:get() then
        id = 5
    elseif player_state(cmd) == "Moving" and antiaim_builder2[4].enable2:get() then
        id = 4
    elseif player_state(cmd) == "Walking" and antiaim_builder2[3].enable2:get() then
        id = 3
    elseif player_state(cmd) == "Standing" and antiaim_builder2[2].enable2:get() then
        id = 2
    else
        id = 1
    end

    ui.set(ref.roll[1], 0)

    run_direction()

    local delay_time = antiaim_builder2[id].yaw_delay2:get()
    local random_delay = antiaim_builder2[id].yaw_delay_random2:get() 
    local random_variation = 0


    if globals.tickcount() > current_tickcount + delay_time and random_variation == math.random(random_variation, random_delay) then
        if cmd.chokedcommands == 0 then
            to_jitter = not to_jitter 
            current_tickcount = globals.tickcount()
        end
    end
        
    if globals.tickcount() < current_tickcount then
        current_tickcount = globals.tickcount()
    end

    ui.set(ref.fsbodyyaw, false)
    ui.set(ref.pitch[1], "Default")
    ui.set(ref.yawbase, lua_menu.antiaim.yaw_base:get())
    ui.set(ref.yaw[1], "180")


    ui.set(ref.yawjitter[1], antiaim_builder2[id].mod_type2:get())
    ui.set(ref.yawjitter[2], antiaim_builder2[id].mod_dm2:get())
    if antiaim_builder2[id].yaw_delay2:get() then
        ui.set(ref.bodyyaw[1], "Static")
        ui.set(ref.bodyyaw[2], to_jitter and 1 or -1)
    else
        ui.set(ref.bodyyaw[1], antiaim_builder2[id].body_yaw_type2:get())
        ui.set(ref.bodyyaw[2], antiaim_builder2[id].body_slider2:get())
    end
    local desync_type = entity.get_prop(lp, "m_flPoseParameter", 11) * 120 - 60
    local desync_side = desync_type > 0
    if antiaim_builder2[id].yaw_lr:get() then
        yaw_amount = desync_side and randomize_value(antiaim_builder2[id].yaw_left2:get(), antiaim_builder2[id].yaw_random2:get()) or randomize_value(antiaim_builder2[id].yaw_right2:get(), antiaim_builder2[id].yaw_random2:get())
    else
        yaw_amount = 0
    end

    ui.set(ref.yaw[2], yaw_direction == 0 and yaw_amount or yaw_direction)
    if antiaim_builder2[id].yaw_offset:get() then
        ui.set(ref.yaw[1], "180")
        ui.set(ref.yaw[2], antiaim_builder2[id].yaw_offset_slider:get())
    end


  
    local players = entity.get_players(true)
    if lua_menu.antiaim.addons:get("warmup aa") then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[1], "Spin")
            ui.set(ref.yaw[2], 55)
            ui.set(ref.yawjitter[1],"Off")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], 0)
        end
    end

    if lua_menu.antiaim.manual_type:get() == "static" and entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 0 then
        if yaw_direction > 1 or yaw_direction < -1  then
            ui.set(ref.yawjitter[1],"Off" )
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[1], "Opposite")
            ui.set(ref.bodyyaw[2], 0)
        end
    elseif lua_menu.antiaim.manual_type:get() == "jitter" then
        if yaw_direction > 1 or yaw_direction < -1  then
            ui.set(ref.yawjitter[1],"Center" )
            ui.set(ref.yawjitter[2], 35)
            ui.set(ref.bodyyaw[1], "Jitter")
            ui.set(ref.bodyyaw[2], -1) 
        end
    end
    if lua_menu.antiaim.key_freestand:get() and entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 0 and yaw_direction == 0 then
        if lua_menu.antiaim.freestand_type:get() == "static" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 5)
            ui.set(ref.yawjitter[1],"Off" )
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.bodyyaw[1], "Off")
            ui.set(ref.bodyyaw[2], 0) 
        elseif lua_menu.antiaim.freestand_type:get() == "jitter" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], 10)
            ui.set(ref.yawjitter[1],"Center" )
            ui.set(ref.yawjitter[2], 35)
            ui.set(ref.bodyyaw[1], "Jitter")
            ui.set(ref.bodyyaw[2], -1) 
        end
    end
    
    local threat = client.current_threat()

    local lp_weapon = entity.get_player_weapon(lp)
    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
    local flags = entity.get_prop(lp, "m_fFlags")
    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    local ducked = entity.get_prop(lp, "m_flDuckAmount") > 0.7

    if lua_menu.antiaim.addons:get("safe function") then
        if lp_weapon ~= nil then
            if lua_menu.antiaim.safe_head:get("air+c knife") then
                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CKnife" then
                    safe_func()
                end
            end
            if lua_menu.antiaim.safe_head:get("air+c taser") then
                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CWeaponTaser" then
                    safe_func()
                end
            end
            if lua_menu.antiaim.safe_head:get("high distance") then
                if threat ~= nil then
                    threat_x, threat_y, threat_z = entity.get_prop(threat, "m_vecOrigin")
                    threat_dist = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, threat_x, threat_y, threat_z)
                    if threat_dist > 900 then
                        safe_func()
                    end
                end
            end
        end
    end

    if lua_menu.antiaim.addons:get("avoid backstab") then
        for i = 1, #players do
            if players == nil then
                return
            end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then
                return
            end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 350 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end  
end

local shots = {
    hit = {},
    missed = { 0, 0, 0, 0, 0 },
    total = 0
}
local hitgroups = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "unknown", "gear" }

client.set_event_callback("aim_hit", function(shot)
    table.insert(shots.hit, {
        entity.get_player_name(shot.target),
        shot.hit_chance,
        shot.damage,
        hitgroups[shot.hitgroup + 1] or "unknown"
    })
end)
client.set_event_callback("aim_miss", function(shot)
    if shot.reason == "spread" then shots.missed[1] = shots.missed[1] + 1 end;if shot.reason == "prediction error" then shots.missed[2] = shots.missed[2] + 1 end;if shot.reason == "death" then shots.missed[3] = shots.missed[3] + 1 end;if shot.reason == "?" then shots.missed[4] = shots.missed[4] + 1 end
end)

client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        shots.missed[1] = 0;shots.missed[2] = 0;shots.missed[3] = 0;shots.missed[4] = 0
        for k in pairs(shots.hit) do shots.hit[k] = nil end
    end
end)

local function anim_breaker()
    local lp = entity.get_local_player()
    if not lp then
        return
    end
    if not entity.is_alive(lp) then
        return
    end

    local self_index = c_entity.new(lp)
    local self_anim_state = self_index:get_anim_state()
    if not self_anim_state then
        return
    end

    local self_anim_overlay = self_index:get_anim_overlay(12)
    if not self_anim_overlay then
        return
    end
    local x_velocity = entity.get_prop(lp, "m_vecVelocity[0]")
    if math.abs(x_velocity) >= 3 then
        self_anim_overlay.weight = 1
    end

    if lua_menu.misc.animation_ground:get() == "static" then
        entity.set_prop(lp, "m_flPoseParameter", lua_menu.misc.animation_value:get() / 10, 0)
    elseif lua_menu.misc.animation_ground:get() == "jitter" then
        entity.set_prop(
            lp,
            "m_flPoseParameter",
            globals.tickcount() % 4 > 1 and lua_menu.misc.animation_value:get() / 10 or 0,
            0
        )
    else
        entity.set_prop(lp, "m_flPoseParameter", math.random(lua_menu.misc.animation_value:get(), 10) / 10, 0)
    end

    if lua_menu.misc.animation_air:get() == "static" then
        entity.set_prop(lp, "m_flPoseParameter", 1, 6)
    elseif lua_menu.misc.animation_air:get() == "randomize" then
        entity.set_prop(lp, "m_flPoseParameter", math.random(0, 10) / 10, 6)
    end
end

local screen = {client.screen_size()}
local center = {screen[1] / 2, screen[2] / 2}

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.absoluteframetime() * speed
end

local logs = {}
local function ragebot_logs()
    local offset, x, y = 0, screen[1] / 2, screen[2] / 1.4
    for idx, data in ipairs(logs) do
        if (((globals.curtime() / 2) * 2.0) - data[3]) < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 10)
        else
            data[2] = math.lerp(data[2], 0, 10)
        end
        offset = offset - 40 * (data[2] / 255)

        text_size_x, text_sise_y = renderer.measure_text("", data[1])
        if lua_menu.misc.screen_type:get() == "Default" then
            renderer.rectangle(
                x - 7 - text_size_x / 2,
                y - offset - 8,
                text_size_x + 13,
                26,
                0,
                0,
                0,
                (data[2] / 255) * 150
            )
            renderer.rectangle(
                x - 6 - text_size_x / 2,
                y - offset - 7,
                text_size_x + 11,
                24,
                50,
                50,
                50,
                (data[2] / 255) * 255
            )
            renderer.rectangle(
                x - 4 - text_size_x / 2,
                y - offset - 4,
                text_size_x + 7,
                18,
                80,
                80,
                80,
                (data[2] / 255) * 255
            )
            renderer.rectangle(
                x - 3 - text_size_x / 2,
                y - offset - 3,
                text_size_x + 5,
                16,
                20,
                20,
                20,
                (data[2] / 255) * 200
            )
            renderer.gradient(
                x - 3 - text_size_x / 2,
                y - offset - 3,
                text_size_x / 2 + 3,
                1,
                78,
                169,
                249,
                (data[2] / 255) * 255,
                254,
                86,
                217,
                (data[2] / 255) * 255,
                true
            )
            renderer.gradient(
                x - 3,
                y - offset - 3,
                text_size_x / 2 + 5,
                1,
                254,
                86,
                217,
                (data[2] / 255) * 255,
                214,
                255,
                108,
                (data[2] / 255) * 255,
                true
            )
        else
            renderer.rectangle(x - 7 - text_size_x / 2, y - offset - 5, text_size_x + 13, 2, 145, 90, 150, data[2])
            renderer.rectangle(
                x - 7 - text_size_x / 2,
                y - offset - 5,
                text_size_x + 13,
                20,
                0,
                0,
                0,
                (data[2] / 255) * 50
            )
        end
        renderer.text(x - 1 - text_size_x / 2, y - offset, 255, 255, 255, data[2], "", 0, data[1])
        if data[2] < 0.1 or not entity.get_local_player() then
            table.remove(logs, idx)
        end
    end
end

renderer.log = function(text)
    table.insert(logs, {text, 0, ((globals.curtime() / 2) * 2.0)})
end

local notify =
    (function()
    local b = vector
    local c = function(d, b, c)
        return d + (b - d) * c
    end
    local e = function()
        return b(client.screen_size())
    end
    local f = function(d, ...)
        local c = {...}
        local c = table.concat(c, "")
        return b(renderer.measure_text(d, c))
    end
    local g = {notifications = {bottom = {}}, max = {bottom = 6}}
    g.__index = g
    g.new_bottom = function(h, i, j, ...)
        table.insert(
            g.notifications.bottom,
            {
                started = false,
                instance = setmetatable(
                    {
                        active = false,
                        timeout = 5,
                        color = {["r"] = h, ["g"] = i, ["b"] = j, a = 0},
                        x = e().x / 2,
                        y = e().y,
                        text = ...
                    },
                    g
                )
            }
        )
    end
    function g:handler()
        local d = 0
        local b = 0
        for d, b in pairs(g.notifications.bottom) do
            if not b.instance.active and b.started then
                table.remove(g.notifications.bottom, d)
            end
        end
        for d = 1, #g.notifications.bottom do
            if g.notifications.bottom[d].instance.active then
                b = b + 1
            end
        end
        for c, e in pairs(g.notifications.bottom) do
            if c > g.max.bottom then
                return
            end
            if e.instance.active then
                e.instance:render_bottom(d, b)
                d = d + 1
            end
            if not e.started then
                e.instance:start()
                e.started = true
            end
        end
    end
    function g:start()
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end
    function g:get_text()
        local d = ""
        for b, b in pairs(self.text) do
            local c = f("", b[1])
            local c, e, f = 255, 255, 255
            if b[2] then
                c, e, f = 99, 199, 99
            end
            d = d .. ("\a%02x%02x%02x%02x%s"):format(c, e, f, self.color.a, b[1])
        end
        return d
    end
    local k =
        (function()
        local d = {}
        d.rec = function(d, b, c, e, f, g, k, l, m)
            m = math.min(d / 2, b / 2, m)
            renderer.rectangle(d, b + m, c, e - m * 2, f, g, k, l)
            renderer.rectangle(d + m, b, c - m * 2, m, f, g, k, l)
            renderer.rectangle(d + m, b + e - m, c - m * 2, m, f, g, k, l)
            renderer.circle(d + m, b + m, f, g, k, l, m, 180, .25)
            renderer.circle(d - m + c, b + m, f, g, k, l, m, 90, .25)
            renderer.circle(d - m + c, b - m + e, f, g, k, l, m, 0, .25)
            renderer.circle(d + m, b - m + e, f, g, k, l, m, -90, .25)
        end
        d.rec_outline = function(d, b, c, e, f, g, k, l, m, n)
            m = math.min(c / 2, e / 2, m)
            if m == 1 then
                renderer.rectangle(d, b, c, n, f, g, k, l)
                renderer.rectangle(d, b + e - n, c, n, f, g, k, l)
            else
                renderer.rectangle(d + m, b, c - m * 2, n, f, g, k, l)
                renderer.rectangle(d + m, b + e - n, c - m * 2, n, f, g, k, l)
                renderer.rectangle(d, b + m, n, e - m * 2, f, g, k, l)
                renderer.rectangle(d + c - n, b + m, n, e - m * 2, f, g, k, l)
                renderer.circle_outline(d + m, b + m, f, g, k, l, m, 180, .25, n)
                renderer.circle_outline(d + m, b + e - m, f, g, k, l, m, 90, .25, n)
                renderer.circle_outline(d + c - m, b + m, f, g, k, l, m, -90, .25, n)
                renderer.circle_outline(d + c - m, b + e - m, f, g, k, l, m, 0, .25, n)
            end
        end
        d.glow_module_notify = function(b, c, e, f, g, k, l, m, n, o, p, q, r, s, s)
            local t = 1
            local u = 1
            if s then
                d.rec(b, c, e, f, l, m, n, o, k)
            end
            for l = 0, g do
                local m = o / 2 * (l / g) ^ 3
                d.rec_outline(
                    b + (l - g - u) * t,
                    c + (l - g - u) * t,
                    e - (l - g - u) * t * 2,
                    f - (l - g - u) * t * 2,
                    p,
                    q,
                    r,
                    m / 1.5,
                    k + t * (g - l + u),
                    t
                )
            end
        end
        return d
    end)()
    function g:render_bottom(g, l)
        local notify1, notify2, notify3, notify4 = lua_menu.misc.log:get()
        local e = e()
        local m = 6
        local n = "     " .. self:get_text()
        local f = f("", n)
        local o = 8
        local p = 5
        local q = 0 + m + f.x
        local q, r = q + p * 2, 12 + 10 + 1
        local s, t = self.x - q / 2, math.ceil(self.y - 40 + .4)
        local u = globals.frametime()
        if globals.realtime() < self.delay then
            self.y = c(self.y, e.y - 45 - (l - g) * r * 1.4, u * 7)
            self.color.a = c(self.color.a, 255, u * 2)
        else
            self.y = c(self.y, self.y - 10, u * 15)
            self.color.a = c(self.color.a, 0, u * 20)
            if self.color.a <= 1 then
                self.active = false
            end
        end
        local c, e, g, l = self.color.r, self.color.g, self.color.b, self.color.a
        k.glow_module_notify(s, t, q, r, 9, o, 25, 25, 25, l, notify1, notify2, notify3, l, true)
        local k = p + 2
        k = k + 0 + m
        renderer.text(s + k, t + r / 2 - f.y / 2, notify1, notify2, notify3, l, "b", nil, "✨")
        renderer.text(s + k, t + r / 2 - f.y / 2, notify1, notify2, notify3, l, "", nil, n)
    end
    client.set_event_callback("paint_ui",function()
        if not is_lua_loaded then return end
        g:handler()
    end)
    return g
end)()
local notifications = {}

local function push_notify(text)
    local notify1, notify2, notify3, notify4 = lua_menu.misc.log:get()
    if lua_menu.misc.multibox4:get("screen") == true then
        notify.new_bottom(notify1, notify2, notify3, {{text}})
    else
        table.insert(
            notifications,
            1,
            {
                text = text,
                alpha = 255,
                spacer = 0,
                lifetime = client.timestamp() + (10.0 * 100)
            }
        )
    end
end

push_notify()

client.exec("clear")
client.delay_call(
    3,
    function()
        is_lua_loaded = true
    end)
client.delay_call(
    3.6,
    function()
        notify.new_bottom(233, 175, 255, {{"~ Loaded Successfully! "}, {"   ", true}})
        client.delay_call(
            4.3,
            function()
                notify.new_bottom(233, 175, 255, {{"~ Welcome to Kittyhook <3 "}, {"   ", true}})
            end
        )
    end
)

local shot_logger = {}

shot_logger.add = function(...)
    args = { ... }
    len = #args
    for i = 1, len do
        arg = args[i]
        r, g, b = unpack(arg)

        msg = {}

        if #arg == 3 then
            table.insert(msg, " ")
        else
            for i = 4, #arg do
                table.insert(msg, arg[i])
            end
        end
        msg = table.concat(msg)

        if len > i then
            msg = msg .. "\0"
        end

        client.color_log(r, g, b, msg)
    end
end

shot_logger.bullet_impacts = {}
shot_logger.bullet_impact = function(e)
	local tick = globals.tickcount()
	local me = entity.get_local_player()
	local user = client.userid_to_entindex(e.userid)
	
	if user ~= me then
		return
	end

	if #shot_logger.bullet_impacts > 150 then
		shot_logger.bullet_impacts = { }
	end

	shot_logger.bullet_impacts[#shot_logger.bullet_impacts+1] = {
		tick = tick,
		eye = vector(client.eye_position()),
		shot = vector(e.x, e.y, e.z)
	}
end

shot_logger.get_inaccuracy_tick = function(pre_data, tick)
	local spread_angle = -1
	for k, impact in pairs(shot_logger.bullet_impacts) do
		if impact.tick == tick then
			local aim, shot = 
				(pre_data.eye-pre_data.shot_pos):angles(),
				(pre_data.eye-impact.shot):angles()

				spread_angle = vector(aim-shot):length2d()
			break
		end
	end

	return spread_angle
end

shot_logger.get_safety = function(aim_data, target)
	local has_been_boosted = aim_data.boosted
	local plist_safety = plist.get(target, 'Override safe point')
	local ui_safety = { ui.get(ref.safepoint), ui.get(ref.safepoint) or plist_safety == 'On' }

	if not has_been_boosted then
		return -1
	end

	if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
		return 0
	end

	return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
end

shot_logger.generate_flags = function(pre_data)
	return {
		pre_data.self_choke > 1 and 1 or 0,
		pre_data.velocity_modifier < 1.00 and 1 or 0,
		pre_data.flags.boosted and 1 or 0
	}
end

shot_logger.hitboxes = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
shot_logger.on_aim_fire = function(e)
	local p_ent = e.target
	local me = entity.get_local_player()

	shot_logger[e.id] = {
		original = e,
		dropped_packets = { },

		handle_time = globals.realtime(),
		self_choke = globals.chokedcommands(),

		flags = {
			boosted = e.boosted
		},

		feet_yaw = entity.get_prop(p_ent, 'm_flPoseParameter', 11)*120-60,
		correction = plist.get(p_ent, 'Correction active'),

		safety = shot_logger.get_safety(e, p_ent),
		shot_pos = vector(e.x, e.y, e.z),
		eye = vector(client.eye_position()),
		view = vector(client.camera_angles()),

		velocity_modifier = entity.get_prop(me, 'm_flVelocityModifier'),
		total_hits = entity.get_prop(me, 'm_totalHitsOnServer'),

		history = globals.tickcount() - e.tick
	}
end
shot_logger.on_aim_hit = function(e)
	if not ((lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("console"))) then
		return
	end

	if shot_logger[e.id] == nil then
		return 
	end

	local info = 
	{
		type = math.max(0, entity.get_prop(e.target, 'm_iHealth')) > 0,
		prefix = { lua_menu.misc.log:get() },
		hit = { lua_menu.misc.log:get() },
		name = entity.get_player_name(e.target),
		hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
		flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
		aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
		aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
		hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
		spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
		correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
	}

    if lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("screen") then
        push_notify("Hit " .. info.name .. "'s " .. info.hitgroup .. " for " .. e.damage .. "   ")
    end

	shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], 'kittyhook'}, 
					{ 134, 134, 134, ' ' }, 
					{ 255, 255, 255, info.type and 'Damaged ' or 'Killed ' }, 
					{ info.hit[1], info.hit[2], info.hit[3],  info.name }, 
					{ 255, 255, 255, ' in the ' }, 
					{ info.hit[1], info.hit[2], info.hit[3], info.hitgroup }, 
					{ 255, 255, 255, info.hitgroup ~= info.aimed_hitgroup and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], (info.hitgroup ~= info.aimed_hitgroup and info.aimed_hitgroup) or '' },
					{ 255, 255, 255, info.hitgroup ~= info.aimed_hitgroup and ')' or ''},
					{ 255, 255, 255, ' for ' or '' },
					{ info.hit[1], info.hit[2], info.hit[3], e.damage or '' },
					{ 255, 255, 255, e.damage ~= shot_logger[e.id].original.damage and ' (' or ''},
					{ info.hit[1], info.hit[2], info.hit[3], (e.damage ~= shot_logger[e.id].original.damage and shot_logger[e.id].original.damage) or '' },
					{ 255, 255, 255, e.damage ~= shot_logger[e.id].original.damage and ')' or ''},
					{ 255, 255, 255, ' damage' or '' },
					{ 255, 255, 255, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance }, { 255, 255, 255, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
					{ 255, 255, 255, ' | bt: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history },
					{ 255, 255, 255, ')' })
end

shot_logger.on_aim_miss = function(e)
	if not (lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("console")) then
		return
	end

	local me = entity.get_local_player()
	local info = 
	{
		prefix = { lua_menu.misc.log:get() },
		hit = { lua_menu.misc.log:get() },
		name = entity.get_player_name(e.target),
		hitgroup = shot_logger.hitboxes[e.hitgroup + 1] or '?',
		flags = string.format('%s', table.concat(shot_logger.generate_flags(shot_logger[e.id]))),
		aimed_hitgroup = shot_logger.hitboxes[shot_logger[e.id].original.hitgroup + 1] or '?',
		aimed_hitchance = string.format('%d%%', math.floor(shot_logger[e.id].original.hit_chance + 0.5)),
		hp = math.max(0, entity.get_prop(e.target, 'm_iHealth')),
		reason = e.reason,
		spread_angle = string.format('%.2f°', shot_logger.get_inaccuracy_tick(shot_logger[e.id], globals.tickcount())),
		correction = string.format('%d:%d°', shot_logger[e.id].correction and 1 or 0, (shot_logger[e.id].feet_yaw < 10 and shot_logger[e.id].feet_yaw > -10) and 0 or shot_logger[e.id].feet_yaw)
	}

    if lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("screen") then
        push_notify("Missed " .. info.name .. "'s " .. info.hitgroup .. " due to " .. info.reason .. "   ")
    end

    if info.reason == '?' then
        info.reason = 'unknown';

        if shot_logger[e.id].total_hits ~= entity.get_prop(me, 'm_totalHitsOnServer') then
            info.reason = 'damage rejection';
        end
    end

	shot_logger.add({ info.prefix[1], info.prefix[2], info.prefix[3], 'kittyhook'}, 
					{ 134, 134, 134, ' ' }, 
					{ 255, 255, 255, 'Missed shot at ' }, 
					{ info.hit[1], info.hit[2], info.hit[3],  info.name }, 
					{ 255, 255, 255, ' in the ' }, 
					{ info.hit[1], info.hit[2], info.hit[3], info.hitgroup }, 
					{ 255, 255, 255, ' due to '},
					{ info.hit[1], info.hit[2], info.hit[3], info.reason },
					{ 255, 255, 255, ' (hc: ' }, { info.hit[1], info.hit[2], info.hit[3], info.aimed_hitchance }, { 255, 255, 255, ' | safety: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].safety },
					{ 255, 255, 255, ' | bt: ' }, { info.hit[1], info.hit[2], info.hit[3], shot_logger[e.id].history },
					{ 255, 255, 255, ')' })
end

client.set_event_callback('aim_fire', shot_logger.on_aim_fire)
client.set_event_callback('aim_miss', shot_logger.on_aim_miss)
client.set_event_callback('aim_hit', shot_logger.on_aim_hit)
client.set_event_callback('bullet_impact', shot_logger.bullet_impact)

local rgba_to_hex = function(b, c, d, e)
    return string.format("%02x%02x%02x%02x", b, c, d, e)
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

local function text_fade_animation(x, y, speed, color1, color2, text, flag)
    local final_text = ""
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10
        local wave = math.cos(8 * speed * curtime + x / 30)
        local color =
            rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        )
        final_text = final_text .. "\a" .. color .. text:sub(i, i)
    end

    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flag, nil, final_text)
end

local function doubletap_charged()
    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then
        return false
    end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then
        return
    end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then
        return false
    end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
    local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
    if checkcheck == nil then
        return
    end
    local next_primary_attack = checkcheck + 0.01
    if next_attack == nil or next_primary_attack == nil then
        return false
    end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end

local scoped_space = 0

local function indicators_new()

    local lp = entity.get_local_player()
    if lp == nil then
        return
    end

    local r1, g1, b1, a1 = lua_menu.misc.cross_ind:get_color()
    
    local scpd = entity.get_prop(lp, "m_bIsScoped") == 1
    scoped_space = math.lerp(scoped_space, scpd and 25 or 0, 20)

    if ui.get(ref.dt[1]) and ui.get(ref.dt[2])  then
        dt_on  = 10
    else
        dt_on = 0
    end

    if ui.get(ref.os[2]) then
        oson = 10
    else
        oson = 0
    end
  
    text_fade_animation(center[1] - 11 + scoped_space, center[2] + 30, -0.4, {r = 255, g = 255, b = 255, a = 255}, {r = 255, g = 255, b = 255, a = 255}, "kitty", "cd")
    text_fade_animation(center[1] + 11 + scoped_space, center[2] + 30, -0.4, {r = 255, g = 255, b = 255, a = 255}, {r = r1, g = g1, b = b1, a = a1}, "hook", "cd")
    if id == 1 then
        renderer.text(center[1] + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "sharing")
    elseif id == 2 then
        renderer.text(center[1] + 1 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "standing")
    elseif id == 3 then
        renderer.text(center[1] + 2 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "walking")
    elseif id == 4 then
        renderer.text(center[1] + 1 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "running")
    elseif id == 5 then
        renderer.text(center[1] + 1 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "aerobic")
    elseif id == 6 then
        renderer.text(center[1] + 2 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "aerobic+")
    elseif id == 7 then
        renderer.text(center[1] + 1 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "ducking")
    elseif id == 8 then
        renderer.text(center[1] + 2 + scoped_space, center[2] + 40, 255, 255, 255, 255, "cd", 0, "ducking+")
    end
    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
        if doubletap_charged() then
            renderer.text(center[1] + scoped_space, center[2] + 50, 255, 255, 255, 255, "cd", 0, "dt")
        else
            renderer.text(center[1] + scoped_space, center[2] + 50, 255, 0, 0, 255, "cd", 0, "dt")
        end
    end
    if ui.get(ref.os[2]) then
        renderer.text(center[1] + scoped_space, center[2] + 50 + dt_on, 255, 255, 255, 255, "cd", 0, "hide")
    end
    if ui.get(ref.fakeduck) then
        renderer.text(center[1] + scoped_space, center[2] + 50 + dt_on + oson, 255, 255, 255, 255, "cd", 0, "duck")
    end
end
local function indicators_idealyaw()
    
    
    local lp = entity.get_local_player()
    if lp == nil then
        return
    end
    
    local scpd = entity.get_prop(lp, "m_bIsScoped") == 1
    scoped_space = math.lerp(scoped_space, scpd and 33 or 0, 20)

    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) or ui.get(ref.os[2]) then
        dton  = 10
    else
        dton = 0
    end

    if id == 2 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "IDEAL YAW")
    elseif id == 4 then
        renderer.text(center[1] - 1 +  scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "JITTER WALK")
    elseif id == 3 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "NORMAL YAW")
    elseif id == 5 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "IDEAL YAW")
    elseif id == 6 then 
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "IDEAL YAW")
    elseif id == 7 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "IDEAL YAW")
    elseif id == 8 then 
        renderer.text(center[1] - 1 + scoped_space, center[2] + 30, 220, 135, 49, 255, "cd", 0, "IDEAL YAW")
    end
    if yaw_direction == -90 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 40, 209, 139, 230, 255, "cd", 0, "LEFT")
    elseif yaw_direction == 90 then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 40, 209, 139, 230, 255, "cd", 0, "RIGHT")
    elseif ui.get(ref.freestand[1]) and ui.get(ref.freestand[2]) then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 40, 209, 139, 230, 255, "cd", 0, "FREESTAND")
    else
        renderer.text(center[1] - 1 + scoped_space, center[2] + 40, 209, 139, 230, 255, "cd", 0, "DYNAMIC")
    end
    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
        if doubletap_charged() then
            renderer.text(center[1] - 2 + scoped_space, center[2] + 50, 170, 204, 0, 255, "cd", 0, "DT")
        else
            renderer.text(center[1] - 2 + scoped_space, center[2] + 50, 255, 0, 0, 255, "cd", 0, "DT")
        end
    end

    if ui.get(ref.os[2]) and not ui.get(ref.dt[2]) then
        renderer.text(center[1] - 1 + scoped_space, center[2] + 50, 170, 204, 0, 255, "cd", 0, "ONSHOT")
    end
    if ui.get(ref.minimum_damage_override[2]) then 
        renderer.text(center[1] - 1 + scoped_space, center[2] + 50 + dton, 255, 255, 255, 255, "cd", 0, "DMG") 
    end 
    text_fade_animation(x_ind/2, y_ind-20, -0.4, {r=255, g=255, b=255, a=255}, {r=255, g=255, b=255, a=0}, "kittyhook", "cdc")
end


local function fastladder(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw + 0.5)
        e.roll = 0
        if e.forwardmove == 0 then
            if e.sidemove ~= 0 then
                e.pitch = 89
                e.yaw = e.yaw + 180
                if e.sidemove < 0 then
                    e.in_moveleft = 0
                    e.in_moveright = 1
                end
                if e.sidemove > 0 then
                    e.in_moveleft = 1
                    e.in_moveright = 0
                end
            end
        end
        if e.forwardmove > 0 then
            if pitch < 45 then
                e.pitch = 89
                e.in_moveright = 1
                e.in_moveleft = 0
                e.in_forward = 0
                e.in_back = 1
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
        if e.forwardmove < 0 then
            e.pitch = 89
            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0
            if e.sidemove == 0 then
                e.yaw = e.yaw + 90
            end
            if e.sidemove > 0 then
                e.yaw = e.yaw + 150
            end
            if e.sidemove < 0 then
                e.yaw = e.yaw + 30
            end
        end
    end
end

local refs = {
    rage_cb = {ui.reference("RAGE", "Aimbot", "Enabled")},
    os = {ui.reference("aa", "other", "On shot anti-aim")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
}

local vars = {
    os_charged = false,
    dt_charged = false
}

client.set_event_callback(
    "setup_command",
    function(cmd)
        if not is_lua_loaded then return end

        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase") - globals.tickcount()
        local os_ref = ui.get(refs.os[1]) and ui.get(refs.os[2]) and not ui.get(refs.fake_duck)
        local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2]) and not ui.get(refs.fake_duck)
        local active_weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")

        if active_weapon == nil then
            return
        end

        local weapon_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")

        if weapon_idx == nil or weapon_idx == 64 then
            return
        end

        local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")

        if LastShot == nil then
            return
        end

        local single_fire_weapon =
            weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or
            weapon_idx == 35
        local value = single_fire_weapon and 0 or 0.50
        local in_attack = globals.curtime() - LastShot <= value

        if tickbase > 0 and os_ref then
            if in_attack then
                ui.set(refs.rage_cb[2], "Always on")
            else
                ui.set(refs.rage_cb[2], "On hotkey")
            end
        elseif tickbase > 0 and doubletap_ref then
            if in_attack then
                ui.set(refs.rage_cb[2], "Always on")
            else
                ui.set(refs.rage_cb[2], "On hotkey")
            end
        else
            ui.set(refs.rage_cb[2], "Always on")
        end
    end
)
function Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

local function NormalizeAngle(angle)
    if angle == nil then
        return 0
    end
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end
local function AngleDifference(dest_angle, src_angle)
    local delta = math.fmod(dest_angle - src_angle, 360)
    if dest_angle > src_angle then
        if delta >= 180 then
            delta = delta - 360
        end
    else
        if delta <= -180 then
            delta = delta + 360
        end
    end
    return delta
end

local function DegToRad(Deg)
    return Deg * (math.pi / 180)
end
local function RadToDeg(Rad)
    return Rad * (180 / math.pi)
end

local VTable = {
    Entry = function(instance, index, type)
        return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
    end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...)
            return fnptr(instance, ...)
        end
    end
}

local animstate_t =
    ffi.typeof "struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **"
local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local GetAnimState = function(ent)
    if not ent then
        return false
    end
    local Address = type(ent) == "cdata" and ent or NativeGetClientEntity(ent)
    if not Address or Address == ffi.NULL then
        return false
    end
    local AddressVtable = ffi.cast("void***", Address)
    return ffi.cast(animstate_t, ffi.cast("char*", AddressVtable) + 0x9960)[0]
end

local GetSimulationTime = function(ent)
    local pointer = NativeGetClientEntity(ent)
    if pointer then
        return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0]
    else
        return 0
    end
end

local GetMaxDesync = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then
        return 0
    end
    local speedfactor = Clamp(Animstate.feet_speed_forwards_or_sideways, 0, 1)
    local avg_speedfactor = (Animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = Animstate.duck_amount
    if duck_amount > 0 then
        avg_speedfactor = avg_speedfactor + ((duck_amount * speedfactor) * (0.5 - avg_speedfactor))
    end
    return Clamp(avg_speedfactor, .5, 1) 
end

local IsPlayerAnimating = function(player)
    local CurrentSimulationTime, RecordSimulationTime = GetSimulationTime(player)
    CurrentSimulationTime, RecordSimulationTime = toticks(CurrentSimulationTime), toticks(RecordSimulationTime)
    return toticks(CurrentSimulationTime) ~= nil and toticks(RecordSimulationTime) ~= nil
end

local GetChokedPackets = function(player)
    if not IsPlayerAnimating(player) then
        return 0
    end
    local CurrentSimulationTime, PreviousSimulationTime = GetSimulationTime(player)
    local SimulationTimeDifference = globals.curtime() - CurrentSimulationTime
    local ChokedCommands =
        Clamp(
        toticks(math.max(0.0, SimulationTimeDifference - client.latency())),
        0,
        cvar.sv_maxusrcmdprocessticks:get_string() - 2
    )
    return ChokedCommands
end

function RebuildServerYaw(player)
    local Animstate = GetAnimState(player)
    if not Animstate then
        return 0
    end

    local m_flGoalFeetYaw = Animstate.goal_feet_yaw
    local eye_feet_delta = AngleDifference(Animstate.eye_angles_y, Animstate.goal_feet_yaw)
    local flRunningSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)

    local flYawModifier = (((Animstate.stop_to_full_running_fraction * -0.3) - 0.2) * flRunningSpeed) + 1.0
    if Animstate.duck_amount > 0.0 then
        local flDuckingSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
        flYawModifier = flYawModifier + ((Animstate.duck_amount * flDuckingSpeed) * (0.5 - flYawModifier))
    end

    local flMaxYawModifier = flYawModifier * Animstate.max_yaw
    local flMinYawModifier = flYawModifier * Animstate.min_yaw

    if eye_feet_delta <= flMaxYawModifier then
        if flMinYawModifier > eye_feet_delta then
            m_flGoalFeetYaw = math.abs(flMinYawModifier) + Animstate.eye_angles_y
        end
    else
        m_flGoalFeetYaw = Animstate.eye_angles_y - math.abs(flMaxYawModifier)
    end

    return NormalizeAngle(m_flGoalFeetYaw)
end

local JitterBuffer = 6
local Resolver = {
    Jitter = {Jittering = false, JitterTicks = 0, StaticTicks = 0, YawCache = {}, JitterCache = 0, Difference = 0},
    Main = {Mode = 0, Side = 0, Angles = 0}
}

local Cache = {}

local CDetectJitter = function(player)
    local Data = Resolver.Jitter
    local EyeAnglesY = entity.get_prop(player, "m_angEyeAngles")
    Data.YawCache[Data.JitterCache % JitterBuffer] = EyeAnglesY
    if Data.JitterCache >= JitterBuffer + 1 then
        Data.JitterCache = 0
    else
        Data.JitterCache = Data.JitterCache + 1
    end
    for i = 0, JitterBuffer, 1 do
        if i < JitterBuffer then
            local Difference =
                (Data.YawCache[i - Data.JitterCache % JitterBuffer] ~= nil and
                Data.YawCache[Data.JitterCache % JitterBuffer] ~= nil) and
                math.abs(
                    Data.YawCache[i - Data.JitterCache % JitterBuffer] - Data.YawCache[Data.JitterCache % JitterBuffer]
                ) or
                0
            if Difference ~= nil and Difference ~= 0.0 then
                NormalizeAngle(Difference)
                Data.Jittering = Difference >= (48.0 * GetMaxDesync(player)) and true or false
                Data.Difference = Difference
            end
        end
    end
end

local CProcessImpact = function(player)
    return Resolver.Jitter.Jittering and 1 or 0
end

local CDetectDesyncSide = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then
        return 0
    end
    if Resolver.Jitter.Jittering and GetChokedPackets(player) < 3 then
        Cache.FirstNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 1])
        Cache.SecondNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 2])

        Cache.FirstSinAngle = math.sin(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondSinAngle = math.sin(DegToRad(Cache.SecondNormalizedAngle))

        Cache.FirstCosAngle = math.cos(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondCosAngle = math.cos(DegToRad(Cache.SecondNormalizedAngle))

        Cache.AVGYaw =
            NormalizeAngle(
            RadToDeg(
                math.atan2(
                    (Cache.FirstSinAngle + Cache.SecondSinAngle) / 2.0,
                    (Cache.FirstCosAngle + Cache.SecondCosAngle) / 2.0
                )
            )
        )
        Cache.Difference = NormalizeAngle(Animstate.eye_angles_y - Cache.AVGYaw)
        if Cache.Difference ~= 0.0 then
            Resolver.Main.Side = Cache.Difference > 0.0 and 1 or -1
        else
            Resolver.Main.Side = 0
        end
    end

    return Resolver.Main.Side
end

local miss_count = 0

local function resetResolverData()
    Resolver.Jitter.Jittering = false
    Resolver.Jitter.JitterTicks = 0
    Resolver.Jitter.StaticTicks = 0
    Resolver.Jitter.YawCache = {}
    Resolver.Jitter.JitterCache = 0
    Resolver.Jitter.Difference = 0
    miss_count = 0
end

local function aim_miss(player)
    if not is_lua_loaded then return end
    miss_count = miss_count + 1
end

client.set_event_callback("aim_miss", function(player)
    aim_miss(player)
end)

local function is_baimable(player)
    local lethal = entity.get_prop(player, "m_iHealth")
    local number_lethal = lua_menu.misc.health:get()
    local selected_items = lua_menu.misc.multibox:get()
    local selected_items2 = lua_menu.misc.multibox2:get()

    local hp_lower_selected = false

    if selected_items then
        for _, item in ipairs(selected_items) do
            if item == "HP lower than X" then
                hp_lower_selected = true
                if lethal > 0 and lethal <= number_lethal then
                    plist.set(player, "Override prefer body aim", "Force")
                else
                    plist.set(player, "Override prefer body aim", "-")
                end
            end
        end
    end

    if not hp_lower_selected then
        plist.set(player, "Override prefer body aim", "-")
    end

    local missed_number = lua_menu.misc.missed:get()
    local number_lethal2 = lua_menu.misc.health2:get()
    if selected_items2 then
        for _, item2 in ipairs(selected_items2) do
            if item2 == "HP lower than X" and number_lethal2 then
                if lethal > 0 and lethal <= number_lethal2 then
                    plist.set(player, "Override safe point", "On")
                else
                    plist.set(player, "Override safe point", "-")
                end
            end
        end
    end
    if selected_items2 then
        for _, item2 in ipairs(selected_items2) do
            if item2 == "after X misses" then 
                if miss_count >= missed_number and lethal > 0 then
                    plist.set(player, "Override safe point", "On")
                else
                    plist.set(player, "Override safe point", "-")
                end
            end
        end
    end 
end

client.set_event_callback(
    "player_death",
    function(player)
        if not is_lua_loaded then return end
        miss_count = 0
    end
)


local CResolverInstance = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then
        return
    end
    CProcessImpact(player)
    local ChokedPackets = GetChokedPackets(player)
    local Desync = math.abs(NormalizeAngle(Animstate.eye_angles_y - Animstate.torso_yaw))
    local Velocity = entity.get_prop(player, "m_vecVelocity[0]")
    local IsDucking = Animstate.duck_amount > 0.1
    local Weapon = entity.get_prop(player, "m_hActiveWeapon")
    local WeaponData = entity.get_player_weapon(Weapon)
    local WeaponFireRate = WeaponData and WeaponData.m_flFireRate or 0

    if ChokedPackets > 2 then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 0
    elseif Desync >= 40 and Velocity > 150 then
        Resolver.Main.Angles = Cache.Difference ~= nil and (Cache.Difference * GetMaxDesync(player)) * Resolver.Main.Side or (48.0 * GetMaxDesync(player)) * Resolver.Main.Side
        Resolver.Main.Mode = 1
    elseif Desync >= 20 and IsDucking then
        Resolver.Main.Angles = Cache.Difference ~= nil and (Cache.Difference * GetMaxDesync(player)) * Resolver.Main.Side or (48.0 * GetMaxDesync(player))  
        Resolver.Main.Mode = 1
    elseif WeaponFireRate > 25 and Desync > 20 then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - Animstate.eye_angles_y) * Resolver.Main.Side
        Resolver.Main.Mode = 1
    else 
        if Resolver.Jitter.Jittering then
            Resolver.Main.Angles = Cache.Difference ~= nil and (Cache.Difference * GetMaxDesync(player)) * Resolver.Main.Side or (45.0 * GetMaxDesync(player)) * Resolver.Main.Side
            Resolver.Main.Mode = 1
        else
            Resolver.Main.Angles = 0
            Resolver.Main.Mode = 0
        end
    end
    CDetectJitter(player)
    CDetectDesyncSide(player)
end

client.set_event_callback(
    "net_update_end",
    function()
        if not is_lua_loaded then return end
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then
            resetResolverData()
            Resolver.Main.Mode = 0
            return
        end
        local Players = entity.get_players()
        client.update_player_list()
        for _, idx in ipairs(Players) do
            if entity.is_enemy(idx) and IsPlayerAnimating(idx) and lua_menu.misc.resolver_enabled:get() then
                CResolverInstance(idx)
                plist.set(idx, "Force body yaw value", Resolver.Main.Mode ~= 0 and Resolver.Main.Angles or 0)
                plist.set(idx, "Force body yaw", Resolver.Main.Mode ~= 0)
            else
                plist.set(idx, "Force body yaw", false)
            end
            is_baimable(idx)
            plist.set(idx, "Correction active", true)
        end
    end
)

client.set_event_callback(
    "round_start",
    function()
        if not is_lua_loaded then return end
        resetResolverData()
    end
)


local phrases = {
    "ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.",
    "ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ.",
    "𝕦 𝕘𝕦𝕪𝕤 𝕞𝕒𝕜𝕖 𝕗𝕦𝕟 𝕨𝕙𝕚𝕝𝕖 𝕚 𝕞𝕒𝕜𝕖 𝕨𝕚𝕟𝕤 ♚",
    "𝐻𝒱𝐻 𝐿𝑒𝑔𝑒𝓃𝒹𝑒𝓃 𝟤𝟢𝟤𝟤 𝑅𝐼𝒫 𝐿𝒾𝓁 𝒫𝑒𝑒𝓅 & 𝒳𝓍𝓍𝓉𝑒𝒶𝓃𝒸𝒾𝑜𝓃 & 𝒥𝓊𝒾𝒸𝑒 𝒲𝓇𝓁𝒹",
    "-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ",
    "AWPutin༻︻デ═一",
    "𝕟𝕠 z0rhack 𝕝𝕦𝕒 𝕟𝕠 𝕥𝕒𝕝𝕜𝕚𝕟𝕘 (◣◢)",
    "WELOCME (◣_◢)",
    "𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴",
    "shut up niggers",
    "𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟",
    "𝖞𝖔𝖚 𝖆𝖜𝖆𝖑𝖑 𝖒𝖊 𝖔𝖓𝖈𝖊 𝖎 𝖆𝖜𝖆𝖑𝖑 𝖞𝖔𝖚 𝖙𝖜𝖎𝖈𝖊",
    "♚ 𝙬𝙝𝙚𝙣 𝙣𝙤𝙩 𝙢𝙚 𝙘𝙝𝙚𝙖𝙩𝙚𝙧 , 𝙞 𝙖𝙢 𝙪𝙨𝙚 𝙣𝙞𝙭𝙬𝙖𝙧𝙚 ♚",
    "♛Ａｌｌ Ｆａｍｉｌｙ ｉｎ ｎｏｖｏ♛",
    "𝕚 𝕒𝕞 𝕙𝕧𝕙 𝕨𝕚𝕟𝕟𝕖𝕣 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝟙𝟙 𝕒𝕟𝕕 𝕤𝕙𝕒𝕕𝕠𝕨 𝕕𝕒𝕘𝕘𝕖𝕣𝕤 𝕣𝕦𝕤𝕥 𝕔𝕠𝕒𝕥 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟.",
    "𝕝𝕚𝕗𝕖 𝕚𝕤 𝕒 𝕘𝕒𝕞𝕖, 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤",
    "𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕",
    "𝒯𝒽𝑒 𝓅𝓇𝑜𝒷𝓁𝑒𝓂 𝒾𝓈 𝓉𝒽𝒶𝓉 𝒾 𝑜𝓃𝓁𝓎 𝒾𝓃𝒿𝑒𝒸𝓉 𝒸𝒽𝑒𝒶𝓉𝓈 𝑜𝓃 𝓂𝓎 𝓂𝒶𝒾𝓃 𝓉𝒽𝒶𝓉 𝒽𝒶𝓋𝑒 𝓃𝒶𝓂𝑒𝓈 𝓉𝒽𝒶𝓉 𝓈𝓉𝒶𝓇𝓉 𝓌𝒾𝓉𝒽 𝒩 𝒶𝓃𝒹 𝑒𝓃𝒹 𝓌𝒾𝓉𝒽 𝑜𝓋𝑜𝓁𝒾𝓃𝑒𝒽𝑜𝑜𝓀",
    "(◣◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 🙂 (◣◢)",
    "ｉ ｃａｎｔ ｌｏｓｅ ｏｎ ｏｆｆｉｃｅ ｉｔ ｍｙ ｈｏｍｅ",
    "𝕞𝕒𝕚𝕟 𝕟𝕖𝕨= 𝕔𝕒𝕟 𝕓𝕦𝕪.. 𝕙𝕧𝕙 𝕨𝕚𝕟? 𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕚𝕞 𝕔𝕒𝕟, 𝕚𝕞 𝕝𝕠𝕒𝕕 𝕣𝕒𝕘𝕖 ♕",
    "♛Ａｌｌ   Ｆａｍｉｌｙ   ｉｎ   ｎｏｖｏ♛",
    "u will 𝕣𝕖𝕘𝕣𝕖𝕥 rage vs me when i go on ｌｏｌｚ．ｇｕｒｕ acc.",
    "𝔻𝕠𝕟𝕥 𝕒𝕕𝕕 𝕞𝕖 𝕥𝕠 𝕨𝕒𝕣 𝕠𝕟 𝕞𝕪 𝕤𝕞𝕦𝕣𝕗 (◣◢) 𝕟𝕠𝕧𝕠𝕝𝕚𝕟𝕖 𝕒𝕝𝕨𝕒𝕪𝕤 𝕣𝕖𝕒𝕕𝕪 ♛",
    "♛ 𝓽𝓾𝓻𝓴𝓲𝓼𝓱 𝓽𝓻𝓾𝓼𝓽 𝓯𝓪𝓬𝓽𝓸𝓻 ♛",
    "𝕕𝕦𝕞𝕓 𝕕𝕠𝕘, 𝕪𝕠𝕦 𝕒𝕨𝕒𝕜𝕖 𝕥𝕙𝕖 ᴅʀᴀɢᴏɴ ʜᴠʜ ᴍᴀᴄʜɪɴᴇ, 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝙖𝙘𝙘 𝕒𝕟𝕕 𝚐𝚊𝚖𝚎 ♕",
    "♛ 𝕞𝕪 𝕙𝕧𝕙 𝕥𝕖𝕒𝕞 𝕚𝕤 𝕣𝕖𝕒𝕕𝕪 𝕘𝕠 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟛𝕩𝟛 𝟜𝕩𝟜 𝟝𝕩𝟝 (◣◢)",
    "𝙋𝙤𝙤𝙧 𝙖𝙘𝙘 𝙙𝙤𝙣’𝙩 𝙘𝙤𝙢𝙢𝙚𝙣𝙩 𝙥𝙡𝙚𝙖𝙨𝙚 ♛",
    "𝕥𝕣𝕪 𝕥𝕠 𝕥𝕖𝕤𝕥 𝕞𝕖? (◣◢) 𝕞𝕪 𝕞𝕚𝕕𝕕𝕝𝕖 𝕟𝕒𝕞𝕖 𝕚𝕤 𝕘𝕖𝕟𝕦𝕚𝕟𝕖 𝕡𝕚𝕟 ♛",
    "𝓭𝓸𝓷𝓽 𝓝𝓝",
    "ℕ𝕠 𝕆𝔾 𝕀𝔻? 𝔻𝕠𝕟'𝕥 𝕒𝕕𝕕 𝕞𝕖 𝓷𝓲𝓰𝓰𝓪",
    "𝕚 𝕟𝕠𝕧𝕠 𝕦𝕤𝕖𝕣, 𝕟𝕠 𝕟𝕠𝕧𝕠 𝕟𝕠 𝕥𝕒𝕝𝕜",
    "𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂",
    "𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚",
    "𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣◢)",
    "𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓷𝓸𝓿𝓸𝓵𝓲𝓷𝓮𝓱𝓸𝓸𝓴",
    "-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ",
    "𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖𝕣? 𝕚 𝕘𝕣𝕒𝕓 𝕦𝕣 𝕓𝕒𝕟𝕜 𝕕𝕖𝕥𝕒𝕚𝕝𝕤. ♛",
    "𝔾𝕖𝕥 𝕕𝕖𝕒𝕝𝕥 𝕨𝕚𝕥𝕙 𝕝𝕚𝕥𝕥𝕝𝕖 𝕓𝕠𝕪, 𝕤𝕠 𝕤𝕚𝕞𝕡𝕝𝕖, 𝕕𝕠𝕟'𝕥 𝕖𝕧𝕖𝕣 𝕒𝕡𝕡𝕣𝕠𝕒𝕔𝕙 𝕞𝕖𝕞𝕓𝕖𝕣𝕤 𝕠𝕗 𝕞𝕪 𝕥𝕖𝕒𝕞 𝕝𝕚𝕜𝕖 𝕥𝕙𝕒𝕥 𝕖𝕧𝕖𝕣 𝕒𝕘𝕒𝕚𝕟. ♛",
    "𝕠𝕟𝕖 𝕕𝕒𝕪, 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕓𝕖 𝕗𝕠𝕣𝕘𝕠𝕥. 𝕓𝕦𝕥 𝕟𝕠𝕥 𝕞𝕖. 𝕞𝕪 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕔𝕒𝕡𝕒𝕓𝕚𝕝𝕚𝕥𝕪 𝕨𝕚𝕝𝕝 𝕘𝕠 𝕕𝕠𝕨𝕟 𝕚𝕟 𝕥𝕙𝕖 𝕙𝕚𝕤𝕥𝕠𝕣𝕪 𝕓𝕠𝕠𝕜𝕤 𝕗𝕠𝕣 𝕪𝕠𝕦𝕟𝕘 𝕥𝕠 𝕝𝕖𝕒𝕣𝕟 ♛",
    "𝕪𝕠𝕦 𝕝𝕚𝕤𝕥𝕖𝕟 𝕔𝕒𝕣𝕕𝕚 𝕓? 𝕨𝕖𝕝𝕝, 𝕚 𝕒𝕞 𝕔𝕒𝕣𝕕𝕖𝕣 𝕓, 𝕝𝕚𝕤𝕥𝕖𝕟 𝕞𝕖 𝕕𝕠𝕘 ♛",
    "𝕨𝕙𝕖𝕟 𝕞𝕖 𝕒𝕟𝕕 𝕞𝕪 𝕤𝕥𝕒𝕔𝕜 𝕙𝕚𝕥 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤, 𝕨𝕖𝕝𝕝, 𝕚𝕥 𝕨𝕒𝕤 𝕒 𝕘𝕒𝕟𝕘𝕓𝕒𝕟𝕘…",
    "𝕚𝕥𝕤 𝕒𝕝𝕨𝕒𝕪𝕤 ℕℕ 𝕟𝕖𝕧𝕖𝕣 𝕣𝕖𝕒𝕕𝕪 𝕗𝕠𝕣 𝕥𝕙𝕖 𝕤𝕖𝕞𝕚𝕣𝕒𝕘𝕖 𝕤𝕥𝕣𝕖𝕖𝕥𝕤 (◣︵◢)",
    "𝕄𝕪 𝕙𝕒𝕧𝕖 𝕔𝕙𝕖𝕒𝕥 𝕚𝕥𝕤 𝕟𝕠𝕧𝕠",
    "𝓢𝓤𝓔𝓣𝓐",
    "𝕪𝕠𝕦 𝕡𝕒𝕪 𝕤𝕦𝕓 𝕗𝕠𝕣 𝟚𝟝$? 𝕞𝕪 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕠𝕤𝕥 𝟛$ 𝕒𝕟𝕕 𝕚 𝕠𝕣𝕕𝕖𝕣 𝟛 𝕡𝕚𝕫𝕫𝕒 𝕨𝕙𝕖𝕟 𝕚𝕞 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝕪𝕠𝕦 𝕚𝕟 𝕞𝕞 (◣◢)",
    "𝟛 𝕕𝕒𝕪𝕤 𝕒𝕟𝕕 𝕟𝕠 𝕟𝕚𝕩𝕨𝕒𝕣𝕖 𝕔𝕗𝕘 𝕚𝕞 𝕥𝕙𝕚𝕟𝕜 𝕚𝕤 𝕪𝕠𝕦 𝕤𝕥𝕦𝕡𝕚𝕕?♛",
    "𝕚𝕗 𝕪𝕠𝕦 𝕘𝕣𝕖𝕨 𝕦𝕡 𝕚𝕟 𝕙𝕖𝕝𝕝, 𝕥𝕙𝕖𝕟 𝕠𝕗𝕔 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕘𝕠𝕚𝕟𝕘 𝕥𝕠 𝕤𝕚𝕟 (◣◢)",
    "𝕨𝕙𝕖𝕟 𝕕𝕠𝕘𝕤 𝕕𝕠𝕟𝕥 𝕨𝕒𝕟𝕥 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞𝕤 𝕠𝕟𝕝𝕪 𝕕𝕠 𝕓𝕠𝕕𝕪 𝕒𝕚𝕞𝕤 𝕟𝕠𝕥𝕙𝕚𝕟𝕘 𝕗𝕠𝕣 𝕥𝕖𝕒𝕞 𝕚𝕟 𝟝𝕧𝟝 𝕠𝕟𝕝𝕪 𝕘𝕠 𝕗𝕠𝕣 𝕓𝕒𝕚𝕞𝕤",
    "𝕞𝕒𝕪 𝕘𝕠𝕕 𝕗𝕠𝕣𝕘𝕚𝕧𝕖 𝕪𝕠𝕦 𝕓𝕦𝕥 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕨𝕠𝕟𝕥",
    "ｒｉｃｈ ｍｙ ｍａｉｎ",
    "𝒍𝒂𝒎𝒃𝒐𝒓𝒈𝒊𝒈𝒏𝒊 𝒐𝒘𝒏𝒆𝒓",
    "𝕕𝕠 𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕙𝕒𝕝𝕗 𝕒𝕟𝕘𝕣𝕪 𝕔𝕠𝕟𝕗𝕚𝕘 𝕗𝕠𝕣 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖?",
    "𝙗𝙞𝙜 𝙣𝙖𝙢𝙚𝙧, 𝙞𝙢 𝙩𝙝𝙞𝙣𝙠 𝙮𝙤𝙪 𝙙𝙧𝙤𝙥 𝙮𝙤𝙪𝙧 𝙘𝙧𝙤𝙬𝙣 𝙨𝙤 𝙞𝙢 𝙬𝙚𝙣𝙩 𝙥𝙞𝙩𝙘𝙝𝙙𝙤𝙬𝙣 𝙞𝙣 𝙢𝙢 𝙖𝙣𝙙 𝙥𝙞𝙘𝙠𝙚𝙙 𝙞𝙩 𝙪𝙥, 𝙝𝙚𝙧𝙚 𝙮𝙤𝙪 𝙜𝙤 𝙠𝙞𝙣𝙜 ♛",
    "𝕚𝕕𝕚𝕠𝕥 𝕒𝕝𝕨𝕒𝕪𝕤 𝕒𝕤𝕜 𝕞𝕖, 𝕦𝕚𝕕? 𝕒𝕟𝕕 𝕚𝕞 𝕕𝕠𝕟𝕥 𝕒𝕟𝕤𝕨𝕖𝕣, 𝕚 𝕝𝕖𝕥 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖𝕓𝕠𝕒𝕣𝕕 𝕥𝕒𝕝𝕜♛ (◣◢)"
}

local userid_to_entindex, get_local_player, is_enemy, console_cmd =
    client.userid_to_entindex,
    entity.get_local_player,
    entity.is_enemy,
    client.exec

local function on_player_death(e)
    if not is_lua_loaded then return end

    if not lua_menu.misc.spammers:get("shit talking") then
        return
    end
    if not lua_menu.main.enable:get() then
        return
    end

    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end

    local victim_entindex = userid_to_entindex(victim_userid)
    local attacker_entindex = userid_to_entindex(attacker_userid)

    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
        client.delay_call(
            2,
            function()
                console_cmd("say ", phrases[math.random(1, #phrases)])
            end
        )
    end
end
client.set_event_callback("player_death", on_player_death)

local config_items = {lua_menu, antiaim_builder2}

local package, data, encrypted, decrypted = pui.setup(config_items)
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
    package:load(decrypted)
end

local function update_menu()
    local aA = {
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 80 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 75 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 70 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 65 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 60 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 55 / 30))},
        {200, 200, 200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + 50 / 30))}
    }
    local color_main1, color_main2, color_main3, color_main4 = lua_menu.main.main_color:get() 
    label_text =
        string.format("\aFFFFFFFF       • · . · ✧˚   " .. (calculateGradien({color_main1, color_main2, color_main3, color_main4}, {255, 255, 255, 255}, "KittyHook", -0.5)) .. "\aFFFFFFFF     ˚ ✧ · . · •",   
        rgba_to_hex(unpack(aA[1])),
        rgba_to_hex(unpack(aA[2])),
        rgba_to_hex(unpack(aA[3])),
        rgba_to_hex(unpack(aA[4])),
        rgba_to_hex(unpack(aA[5])),
        rgba_to_hex(unpack(aA[6])),
        rgba_to_hex(unpack(aA[7]))
    )
    lua_menu.main.enable:set(label_text)
end


client.set_event_callback(
    "setup_command",
    function(cmd, me)
        if not is_lua_loaded then return end

        if not lua_menu.main.enable:get() then
            return
        end
        aa_setup(cmd)
        if lua_menu.misc.fast_ladder:get() then
            fastladder(cmd)
        end
    end
)

local entity_get_prop,
    entity_get_local_player,
    entity_is_alive,
    entity_get_player_weapon,
    entity_get_classname,
    entity_get_origin,
    globals_frametime,
    client_screen_size,
    globals_framecount,
    is_menu_open,
    menu_mouse_position,
    client_key_state,
    table_insert,
    entity_get_steam64,
    render_circle_outline,
    entity_get_all,
    globals_tickinterval,
    client_set_clantag =
    entity.get_prop,
    entity.get_local_player,
    entity.is_alive,
    entity.get_player_weapon,
    entity.get_classname,
    entity.get_origin,
    globals.frametime,
    client.screen_size,
    globals.framecount,
    ui.is_menu_open,
    ui.mouse_position,
    client.key_state,
    table.insert,
    entity.get_steam64,
    renderer.circle_outline,
    entity.get_all,
    globals.tickinterval,
    client.set_clan_tag


client.set_event_callback(
    "pre_render",
    function()
        if not is_lua_loaded then return end

        if not lua_menu.main.enable:get() then
            return
        end
        if lua_menu.misc.animation:get() then
            anim_breaker()
        end
    end
)



local ui = try_require("gamesense/swift_ui", "~ Try donwload swift_ui: https://gamesense.pub/forums/viewtopic.php?id=28453");

local nekoha3 = readfile("kittyhook/sticker2.png")

if not nekoha3 then
    http.get("https://i.ibb.co/xXHP0wx/sticker2.png", function (success, raw)
        if success and string.sub(raw.body, 2, 4) == "PNG" then
            writefile("kittyhook/sticker2.png", raw.body)
        elseif not success or response.status ~= 150 then
            print("~ Missing Nekoha Watermark Picture")
            print("~ Please reload script, if problem still exist dm to support")
        end
    end)
end


local nekoha2 = readfile("kittyhook/3.gif")

if nekoha2 then
    loaded = true
end

if not nekoha2 then
    download_file("https://i.ibb.co/YprQjt3/3.gif", "kittyhook/3.gif")
end

local start_time = globals.realtime()

client.delay_call(3, function()
    if not is_lua_loaded then return end
    nekoha2 = gif_decoder.load_gif(readfile("kittyhook/3.gif"))
    function DrawImage()
        if ui.is_menu_open() then 
            local mx, my = ui.menu_position()
            local mw, mh = ui.menu_size()
            nekoha2:draw(globals.realtime() - start_time, mx + mw - nekoha2.width, my - nekoha2.height, nekoha2.width, nekoha2.height, 255, 255, 255, 255)
        end
    end
    client.set_event_callback("paint_ui",function()
        if not is_lua_loaded then return end
        hide_original_menu(false)
        visible_menu()
        update_menu()
        DrawImage()
    end)
end)

local anyerror = false

local function  watermark_type1()
        local branded1, branded2, branded3, branded4 = lua_menu.misc.watermark:get_color()
        local width, height = client.screen_size()
        text_fade_animation(20, height/2, -0.7, {r = branded1, g = branded2, b = branded3, a = branded4}, {r = 255, g = 255, b = 255, a = 255},"            K I T T Y H O O K", "cd")
        text_fade_animation(28, height/2 + 13, -0.65, {r = 255, g = 255, b = 255, a = 255}, {r = 125, g = 125, b = 125, a = 255}, "     DEBUG", "cd")
    if nekoha3 then
        local logo2 = renderer.load_png(readfile("kittyhook/sticker2.png"), 1, 1)
        renderer.texture(logo2, (77), (height/2 + 527) - 546, 50, 47, 255, 255, 255, 255, "f")
    elseif not anyerror then
        print("~ Failed to Load Nekoha Watermark Picture")
        print("~ Please Try to Delete Kittyhook Folder in csgo, if problem still exist dm to support")
        anyerror = true
    end
end

local function watermark_type2()
    local branded1, branded2, branded3, branded4 = lua_menu.misc.watermark:get_color()
    local width, height = client.screen_size()
    text_fade_animation((width - 60), (height/2), -0.7, {r = branded1, g = branded2, b = branded3, a = branded4}, {r = 255, g = 255, b = 255, a = 255}, "            K I T T Y H O O K", "cd")
    text_fade_animation((width - 51), (height/2) + 13, -0.65, {r = 255, g = 255, b = 255, a = 255}, {r = 125, g = 125, b = 125, a = 255}, "     DEBUG", "cd")
    if nekoha3 then
        local logo2 = renderer.load_png(readfile("kittyhook/sticker2.png"), 1, 1)
        renderer.texture(logo2, (width) - 127, (height/2) - 18, 50, 47, 255, 255, 255, 255, "f")
    elseif not anyerror then
        print("~ Failed to Load Nekoha Watermark Picture")
        print("~ Please Try to Delete Kittyhook Folder in csgo, if problem still exist dm to support")
        anyerror = true
    end
end

local function watermark_type3()
    local branded1, branded2, branded3, branded4 = lua_menu.misc.watermark:get_color()
    text_fade_animation((x_ind/2) - 15, (screen_height) - 20, -0.7, {r = branded1, g = branded2, b = branded3, a = branded4}, {r = 255, g = 255, b = 255, a = 255}, "            K I T T Y H O O K", "cd")
    text_fade_animation((x_ind/2) - 6, (screen_height) - 8, -0.65, {r = 255, g = 255, b = 255, a = 255}, {r = 125, g = 125, b = 125, a = 255}, "     DEBUG", "cd")  
end


lua_menu.misc.watermark:depend(visual_tab, {lua_menu.misc.cross_ind, false})
lua_menu.misc.watermark_type:depend(visual_tab, {lua_menu.misc.cross_ind, false})
local function ind()
    local esp1, esp2, esp3, esp4 = lua_menu.misc.esp_flags_color:get()
    local players = entity.get_players(true)
    for i = 1, #players do
        local player_index = players[i]
        local x1, y1, x2, y2, mult = entity.get_bounding_box(player_index)
        if plist.get(player_index, "Override prefer body aim") == "Force" then
            baim = 15
        else
            baim = 0
        end
        if plist.get(player_index, "Override safe point") == "On" then
            safe = 15
        else
            safe = 0
        end
        if x1 ~= nil and mult > 0 then
            y1 = y1 - 17
            x1 = x1 + ((x2 - x1) / 2)
            if y1 ~= nil then
                if plist.get(player_index, "Override prefer body aim") == "Force" then
                    renderer.text(x1 - safe, y1, esp1, esp2, esp3, esp4, "cd", 0, "BAIM")
                end
                if plist.get(player_index, "Override prefer body aim") == "Force" and plist.get(player_index, "Override safe point") == "On" then
                    renderer.text(x1, y1, 255, 255, 255, 255, "cd", 0, " + ")
                end
                if plist.get(player_index, "Override safe point") == "On" then
                    renderer.text(x1 + baim, y1, esp1, esp2, esp3, esp4, "cd", 0, "SAFE")
                end
            end
        end
    end  
end

client.set_event_callback("paint", function()
    if not is_lua_loaded then return end

    if not lua_menu.main.enable:get() then
        return
    end

    if not entity.is_alive(entity.get_local_player()) then
        return
    end
    if lua_menu.misc.cross_ind:get() then
        if lua_menu.misc.cross_ind_type:get() == "kittyhook" then
            indicators_new()
        end
        if lua_menu.misc.cross_ind_type:get() == "ideal yaw" then
            indicators_idealyaw()
        end
    elseif lua_menu.misc.watermark:get() then
        if lua_menu.misc.watermark_type:get() == "Left" then
            watermark_type1()
        elseif lua_menu.misc.watermark_type:get() == "Right" then
            watermark_type2()
        elseif lua_menu.misc.watermark_type:get() == "Bottom" then
            watermark_type3()
        end
    end
    if not lua_menu.misc.cross_ind:get() and not lua_menu.misc.watermark:get() then
        text_fade_animation(x_ind/2, y_ind-20, -0.4, {r=255, g=255, b=255, a=255}, {r=255, g=255, b=255, a=0}, "kittyhook", "cdc")
    end
    if lua_menu.misc.arrows:get() then
        arrows()
    end
    updatearrows()
    ragebot_logs()
    if lua_menu.misc.esp_flags:get() and lua_menu.misc.resolver_enabled:get() then
        ind() 
    end
    if lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("statistic") then
        shots.missed[5] = shots.missed[1] + shots.missed[2] + shots.missed[4]
        renderer.indicator(255, 255, 255, 200, string.format("%d / %d (%s)", #shots.hit, shots.missed[5], #shots.hit+shots.missed[5] ~= 0 and string.format("%.1f%%", (#shots.hit/(#shots.hit+shots.missed[5]))*100) or "0%"))
    end
end) 
  
client.set_event_callback(
    "shutdown",
    function()
        hide_original_menu(true)
        visible_menu()
    end
)

client.set_event_callback(
    "round_prestart",
    function()
        if not is_lua_loaded then return end
        logs = {}
        if lua_menu.misc.log1:get() and lua_menu.misc.multibox4:get("screen") then
            push_notify("Anti-Aim Data Resetted" .. "   ")
        end
    end
)

local http = require "gamesense/http"
local callback = client.set_event_callback
local render = renderer
local screen_x, screen_y = client.screen_size()

render.round_rect = function(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0}
    }

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2}
    }

    for _, data in next, data_circle do
        render.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in next, data do
        render.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

