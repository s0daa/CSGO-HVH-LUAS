local ffi = require("ffi")
local c_entity = require("gamesense/entity")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local websocket = require("gamesense/websockets")
local vector = require("vector")
local c_entity = require('gamesense/entity')
local json = require("json")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local discord = require "gamesense/discord_webhooks"

client.delay_call(1, function()
client.color_log(255, 226, 243, "~ welcome to gloriosa.")
client.delay_call(3, function()
client.color_log(255, 226, 243, "~ have a good time !")
end)
end)


            local data = database.read("load") or {}
            data.load_count = (data.load_count or 0) + 1
            client.set_event_callback("shutdown", function()
            database.write("load", data)
            end)



                local x_ind, y_ind = client.screen_size()

                local lua_group = pui.group("aa", "anti-aimbot angles")
                local config_group = pui.group("aa", "anti-aimbot angles")
                local defensive_group = pui.group("aa", "fake lag")
                local other_group = pui.group("aa", "other")
                pui.accent = "9FCA2BFF"

                local antiaim_cond = { 'Global\r', 'Standing\r', 'Walking\r', 'Running\r' , 'Air\r', 'Air+\r', 'Duck\r', 'Duck+Move\r' }
                local short_cond = { '\aFFC0CBFFGlobal  \r＞ \r', '\aFFC0CBFFStandinging  \r＞ \r', '\aFFC0CBFFWalking  \r＞ \r', '\aFFC0CBFFRunning  \r＞ \r' ,'\aFFC0CBFFAir  \r＞ \r', '\aFFC0CBFFAir+C  \r＞ \r', '\aFFC0CBFFDuck  \r＞ \r', '\aFFC0CBFFDuck+Move  \r＞ \r' }

                local ref = {
                    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
                    yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
                    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
                    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
                    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
                    forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
                    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
                    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
                    clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),

                    fakelag_amount = ui.reference('AA', 'Fake lag', 'Amount'),
                    fakelag_enable = ui.reference('AA', 'Fake lag', 'Enabled'),
                    fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
                    fakelag_variance = ui.reference('AA', 'Fake lag', 'Variance'),

                    other_slowmotion = ui.reference('AA', 'Other', 'Slow motion'),
                    other_legmovement = ui.reference('AA', 'Other', 'Leg movement'),
                    other_osaa = ui.reference('AA', 'Other', 'On shot anti-aim'),
                    other_fkpeek = ui.reference('AA', 'Other', 'Fake peek'),


                    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
                    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
                    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
                    yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
                    bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
                    freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
                    slow = { ui.reference('AA', 'Other', 'Slow motion') },
                    os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
                    slow = { ui.reference('AA', 'Other', 'Slow motion') },
                    dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
                    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
                }

                local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
                local js = panorama.open()
                local MyPersonaAPI, LobbyAPI, PartyListAPI, SteamOverlayAPI = js.MyPersonaAPI, js.LobbyAPI, js.PartyListAPI, js.SteamOverlayAPI


                local lua_menu = {
                    main = {
                        enable = lua_group:label("gloriosa"),
                        labl = lua_group:label("\n"),       
                        tab = lua_group:combobox('gloriosa ~ \aFFC0CBFFrenew', {"anti-aim", "visuals", "misc", "configuration"}),
                    },
                    antiaim = {
					lines14 = lua_group:label("\a808080FF"),
					lines13 = lua_group:label("\aFFC0CBFF[gloriosa] \affffffffanti-aims"),
                        tab = lua_group:combobox("anti-aim system", {"main", "builder"}),
                        yaw_base = lua_group:combobox("\v\rYaw Base", {"Local view", "At targets"}),
                        addons = lua_group:multiselect('\v\rHelpers', {'Warmup AA [cringe]', 'Avoid Backstab', 'Safe function'}),
                        safe_head = lua_group:multiselect('\v\rSelection', {'Air+C Knife', 'Air+C Zeus', 'High Distance'}),
                        yaw_direction = lua_group:multiselect('\v\rOverride', {'Freestanding', 'Manual'}),
                        key_freestand = lua_group:hotkey('\v\rFreestanding'),
                        key_left = lua_group:hotkey('\v\rManual Left'),
                        key_right = lua_group:hotkey('\v\rManual Right'),
                        key_forward = lua_group:hotkey('\v\rManual Forward'),
                        condition = lua_group:combobox('Conditions', antiaim_cond),
                    },
                    misc = {
					    lines15 = lua_group:label("\a808080FF"),
						lines16 = lua_group:label("\a808080FF"),
					    lines11 = lua_group:label("\aFFC0CBFF[gloriosa] \affffffffmisc"),
						lines12 = lua_group:label("\aFFC0CBFF[gloriosa] \affffffffvisuals"),
                        cross_ind = lua_group:checkbox("\v\r~ crosshair indicators", {255, 255, 255}),
                        cross_ind_type = lua_group:combobox("~  \v\rindicator style", {"old", "pixelized"}),
                        cross_color = lua_group:checkbox("~  \v\rcondition color", {89, 174, 255}),
                        key_color = lua_group:checkbox("~  \v\rkeybinds Color", {255, 255, 255}),
                        defensive_window = lua_group:checkbox("\v\r~ defensive indicator", {255, 255, 255}),
                        velocity_window = lua_group:checkbox("\v\r~ velocity indicator"),
                        velocity_style_color = lua_group:checkbox("~  \v\rvelocity color Color", {255, 255, 255}),
                        spammers = lua_group:multiselect("\v\r~ spammers", {"shit talking"}),
                        fast_ladder = lua_group:checkbox("\v\r~ fast ladder"),
                        log = lua_group:checkbox("\v\r~ aimbot logs { console }"),
                        screen_type = lua_group:combobox("  \v\r~ log style", {"default"}),
                        animation = lua_group:checkbox("\v\r~ animation breakers"),
                        animation_ground = lua_group:combobox("~  \v\rground", {"static", "jitter", "randomize"}),
                        animation_value = lua_group:slider("~  \v\rvalue", 0, 10, 5),
                        animation_air = lua_group:combobox("~  \v\rair", {"off", "static", "randomize"}),
                        resolver = defensive_group:checkbox("~ \affffffffresolver { experimental }"),
                        resolver_type = defensive_group:combobox("type", {"disabled", "jitter / defensive"}),
                        invis = defensive_group:label("\n"),
                        warning = defensive_group:label("\aFFC0CBFF ! using our custom resolver does not guarantee a strong improvement !"),
                        gamesenseold = lua_group:checkbox("\v\r~ gamesense indicators { old }"),
                        

                    },
                    config = {
						lines19 = lua_group:label("\a808080FF"),
					    lines21 = lua_group:label("\afa5757FF gloriosa ~ \aFFFFFFFFconfigurations"),
                        buttom_import = config_group:button("\afa5757FF gloriosa ~ \aFFFFFFFFimport", function() 
						client.color_log(255, 226, 243, "gloriosa ~ successfully imported to aa builder!")
                            config.import()
                        end),
        
                        buttom_export = config_group:button("\afa5757FF gloriosa ~ \aFFFFFFFFexport", function() 
						client.color_log(255, 226, 243, "gloriosa ~ successfully exported to clipboard!")
                            config.export()
                        end),
        
                        buttom_default = config_group:button("\afa5757FF gloriosa ~ \aFFFFFFFFlive preset", function() 
                            config.import("W251bGwsW3siZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJib2R5X3NsaWRlciI6MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOmZhbHNlLCJmb3JjZV9kZWYiOmZhbHNlLCJ5YXdfZGVsYXkiOjQsImRlZl9ib2R5X3lhd190eXBlIjoiT2ZmIiwicGl0Y2hfdmFsdWUiOjAsImRlZl9tb2RfdHlwZSI6Ik9mZiIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjowLCJkZWZfbW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjowLCJtb2RfZG0iOjAsInlhd19sZWZ0IjowLCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVsYXkiLCJtb2RfdHlwZSI6Ik9mZiIsImRlZl95YXdfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsImJvZHlfc2xpZGVyIjoxLCJ5YXdfcmFuZG9tIjo0OCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOmZhbHNlLCJmb3JjZV9kZWYiOnRydWUsInlhd19kZWxheSI6NCwiZGVmX2JvZHlfeWF3X3R5cGUiOiJPZmYiLCJwaXRjaF92YWx1ZSI6MCwiZGVmX21vZF90eXBlIjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJkZWZfYm9keV9zbGlkZXIiOjAsImRlZl9tb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjM3LCJtb2RfZG0iOjAsInlhd19sZWZ0IjotMzUsImRlZmVuc2l2ZV90eXBlIjoiRGVmYXVsdCIsImRlZmVuc2l2ZV95YXciOiJPZmYifSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWxheSIsIm1vZF90eXBlIjoiT2ZmIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwiYm9keV9zbGlkZXIiOjEsInlhd19yYW5kb20iOjUwLCJwZWVrX2RlZiI6ZmFsc2UsImRlZmVuc2l2ZSI6ZmFsc2UsImZvcmNlX2RlZiI6ZmFsc2UsInlhd19kZWxheSI6NSwiZGVmX2JvZHlfeWF3X3R5cGUiOiJPZmYiLCJwaXRjaF92YWx1ZSI6MCwiZGVmX21vZF90eXBlIjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJkZWZfYm9keV9zbGlkZXIiOjAsImRlZl9tb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjQxLCJtb2RfZG0iOjQ2LCJ5YXdfbGVmdCI6LTQzLCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiT2ZmIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwiYm9keV9zbGlkZXIiOjEsInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjpmYWxzZSwiZm9yY2VfZGVmIjpmYWxzZSwieWF3X2RlbGF5Ijo0LCJkZWZfYm9keV95YXdfdHlwZSI6Ik9mZiIsInBpdGNoX3ZhbHVlIjowLCJkZWZfbW9kX3R5cGUiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsImRlZl9ib2R5X3NsaWRlciI6MCwiZGVmX21vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MzcsIm1vZF9kbSI6MCwieWF3X2xlZnQiOi00MywiZGVmZW5zaXZlX3R5cGUiOiJEZWZhdWx0IiwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlbGF5IiwibW9kX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJib2R5X3NsaWRlciI6MSwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOmZhbHNlLCJmb3JjZV9kZWYiOnRydWUsInlhd19kZWxheSI6MywiZGVmX2JvZHlfeWF3X3R5cGUiOiJPZmYiLCJwaXRjaF92YWx1ZSI6MCwiZGVmX21vZF90eXBlIjoiT2ZmIiwieWF3X3ZhbHVlIjowLCJkZWZfYm9keV9zbGlkZXIiOjAsImRlZl9tb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjM3LCJtb2RfZG0iOjAsInlhd19sZWZ0IjotMzAsImRlZmVuc2l2ZV90eXBlIjoiRGVmYXVsdCIsImRlZmVuc2l2ZV95YXciOiJPZmYifSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWxheSIsIm1vZF90eXBlIjoiT2ZmIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwiYm9keV9zbGlkZXIiOjAsInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjpmYWxzZSwiZm9yY2VfZGVmIjp0cnVlLCJ5YXdfZGVsYXkiOjMsImRlZl9ib2R5X3lhd190eXBlIjoiT2ZmIiwicGl0Y2hfdmFsdWUiOjAsImRlZl9tb2RfdHlwZSI6Ik9mZiIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjowLCJkZWZfbW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwieWF3X3JpZ2h0IjozMiwibW9kX2RtIjowLCJ5YXdfbGVmdCI6LTM1LCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVsYXkiLCJtb2RfdHlwZSI6Ik9mZiIsImRlZl95YXdfdmFsdWUiOjAsImRlZmVuc2l2ZV9waXRjaCI6IkN1c3RvbSIsImJvZHlfc2xpZGVyIjoxLCJ5YXdfcmFuZG9tIjowLCJwZWVrX2RlZiI6ZmFsc2UsImRlZmVuc2l2ZSI6dHJ1ZSwiZm9yY2VfZGVmIjp0cnVlLCJ5YXdfZGVsYXkiOjQsImRlZl9ib2R5X3lhd190eXBlIjoiT2ZmIiwicGl0Y2hfdmFsdWUiOjg5LCJkZWZfbW9kX3R5cGUiOiJPZmYiLCJ5YXdfdmFsdWUiOi0xODAsImRlZl9ib2R5X3NsaWRlciI6MCwiZGVmX21vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MjYsIm1vZF9kbSI6MCwieWF3X2xlZnQiOi0yNCwiZGVmZW5zaXZlX3R5cGUiOiJEZWZhdWx0IiwiZGVmZW5zaXZlX3lhdyI6IlNwaW4ifSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWxheSIsIm1vZF90eXBlIjoiT2ZmIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwiYm9keV9zbGlkZXIiOjEsInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjpmYWxzZSwiZm9yY2VfZGVmIjp0cnVlLCJ5YXdfZGVsYXkiOjUsImRlZl9ib2R5X3lhd190eXBlIjoiT2ZmIiwicGl0Y2hfdmFsdWUiOjAsImRlZl9tb2RfdHlwZSI6Ik9mZiIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjowLCJkZWZfbW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwieWF3X3JpZ2h0IjozMCwibW9kX2RtIjowLCJ5YXdfbGVmdCI6LTMwLCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn1dXQ==")
							client.color_log(255, 226, 243, "gloriosa ~ successfully imported default config!")
                        end),
                    },
                    statistic = {
                        profile = other_group:label("profile"),
                        lines1 = other_group:label("\a808080FF───────────────────"),
                        loaded = other_group:label("\aFFFFFFFFusername - \aFFC0CBFF" .. steamname),
                        playtime = other_group:label("\aFFFFFFFFbuild - \afa5757FFkitty"),
						loaded_label = other_group:label("\aFFFFFFFFloaded times \aFFC0CBFF"..data.load_count..""),
                        invisible = other_group:label("\n"),
                        buttonsd = other_group:button("join us: \afa5757FFgloriosa", function() SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/scriptleaks") end),
                    }
                }

                local antiaim_system = {}

                for i=1, #antiaim_cond do
                    antiaim_system[i] = {
                        label = lua_group:label('\n'),
                        enable = lua_group:checkbox('Enable ~ '..antiaim_cond[i]),
                        yaw_type = lua_group:combobox(short_cond[i]..' Yaw Type', {"Default", "Delay"}),
                        yaw_delay = lua_group:slider(short_cond[i]..' Delay Ticks', 1, 10, 4, true, 't', 1),
                        yaw_left = lua_group:slider(short_cond[i]..' Yaw Left', -180, 180, 0, true, '°', 1),
                        yaw_right = lua_group:slider(short_cond[i]..' Yaw Right', -180, 180, 0, true, '°', 1),
                        yaw_random = lua_group:slider(short_cond[i]..' Randomization', 0, 100, 0, true, '%', 1),
                        mod_type = lua_group:combobox(short_cond[i]..' Jitter Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
                        mod_dm = lua_group:slider(short_cond[i]..' Jitter Amount', -180, 180, 0, true, '°', 1),
                        body_yaw_type = lua_group:combobox(short_cond[i]..' Body Yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
                        body_slider = lua_group:slider(short_cond[i]..' Body Yaw Amount', -180, 180, 0, true, '°', 1),
                        force_def = defensive_group:checkbox(short_cond[i]..' Force Defensive'),
                        peek_def = defensive_group:checkbox(short_cond[i]..' Defensive Peek'),
                        defensive = defensive_group:checkbox(short_cond[i]..' Defensive options'),
                        defensive_type = defensive_group:combobox(short_cond[i]..' Defensive Type', {'Default', 'Builder'}),

                        defensive_yaw = defensive_group:combobox(short_cond[i]..' Defensive Yaw', {'Off', 'Spin', 'G-Ways', 'Random'}),

                        yaw_value = defensive_group:slider(short_cond[i]..' Yaw Value', -180, 180, 0, true, '°', 1),
                        def_yaw_value = defensive_group:slider(short_cond[i]..'  Yaw Value', -180, 180, 0, true, '°', 1),
                        def_mod_type = defensive_group:combobox(short_cond[i]..'  Jitter Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
                        def_mod_dm = defensive_group:slider(short_cond[i]..'  Jitter Amount', -180, 180, 0, true, '°', 1),
                        def_body_yaw_type = defensive_group:combobox(short_cond[i]..'  Body Yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
                        def_body_slider = defensive_group:slider(short_cond[i]..'  Body Yaw Amount', -180, 180, 0, true, '°', 1),

                        defensive_pitch = defensive_group:combobox(short_cond[i]..' Defensive Pitch', {'Off', 'Custom', 'G-Ways', 'Random'}),
                        pitch_value = defensive_group:slider(short_cond[i]..' Pitch Value', -89, 89, 0, true, '°', 1)
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
                lua_menu.antiaim.safe_head:depend(aa_tab, {lua_menu.antiaim.addons, "Safe function"}, aa_main)
                lua_menu.antiaim.yaw_base:depend(aa_tab, aa_main)
                lua_menu.antiaim.condition:depend(aa_tab, aa_builder)
                lua_menu.antiaim.yaw_direction:depend(aa_tab, aa_main)
                lua_menu.antiaim.key_freestand:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Freestanding"}, aa_main)
                lua_menu.antiaim.key_left:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_main)
                lua_menu.antiaim.key_right:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_main)
                lua_menu.antiaim.key_forward:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_main)
                lua_menu.misc.cross_ind:depend(visual_tab)
                lua_menu.misc.cross_ind_type:depend(visual_tab, {lua_menu.misc.cross_ind, true})

                lua_menu.misc.lines11:depend(misc_tab)
				lua_menu.misc.lines12:depend(visual_tab)
				lua_menu.misc.lines15:depend(visual_tab)
				lua_menu.misc.lines16:depend(misc_tab)
				lua_menu.config.lines21:depend(config_tab)
                lua_menu.misc.defensive_window:depend(visual_tab)
                lua_menu.misc.velocity_window:depend(visual_tab)
                lua_menu.misc.velocity_style_color:depend(visual_tab, {lua_menu.misc.velocity_window, true})
                lua_menu.misc.cross_color:depend(visual_tab, {lua_menu.misc.cross_ind, true})
                lua_menu.misc.key_color:depend(visual_tab, {lua_menu.misc.cross_ind, true})
                lua_menu.misc.log:depend(visual_tab)
                lua_menu.misc.screen_type:depend(visual_tab, {lua_menu.misc.log, true}, {lua_menu.misc.log, "aimbot logs { console }"})
                lua_menu.misc.fast_ladder:depend(misc_tab)
                lua_menu.misc.animation:depend(misc_tab)
                lua_menu.misc.invis:depend(misc_tab)
                lua_menu.misc.warning:depend(misc_tab, {lua_menu.misc.resolver, true})
                lua_menu.config.buttom_default:depend(config_tab)
                lua_menu.config.buttom_export:depend(config_tab)
                lua_menu.config.buttom_import:depend(config_tab)
                lua_menu.misc.animation_ground:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.animation_value:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.animation_air:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.resolver:depend(misc_tab)
                lua_menu.misc.resolver_type:depend(misc_tab, {lua_menu.misc.resolver, true})
                lua_menu.misc.spammers:depend(misc_tab)
                lua_menu.misc.gamesenseold:depend(misc_tab)

                for i=1, #antiaim_cond do 
                    local cond_check = {lua_menu.antiaim.condition, function() return (i ~= 1) end}
                    local tab_cond = {lua_menu.antiaim.condition, antiaim_cond[i]}
                    local cnd_en = {antiaim_system[i].enable, function() if (i == 1) then return true else return antiaim_system[i].enable:get() end end}
                    local aa_tab = {lua_menu.main.tab, "Anti-Aim"}
                    local jit_ch = {antiaim_system[i].mod_type, function() return antiaim_system[i].mod_type:get() ~= "Off" end}
                    local def_jit_ch = {antiaim_system[i].def_mod_type, function() return antiaim_system[i].def_mod_type:get() ~= "Off" end}
                    local def_ch = {antiaim_system[i].defensive, true}
                    local body_ch = {antiaim_system[i].body_yaw_type, function() return antiaim_system[i].body_yaw_type:get() ~= "Off" end}
                    local def_body_ch = {antiaim_system[i].def_body_yaw_type, function() return antiaim_system[i].def_body_yaw_type:get() ~= "Off" end}
                    local delay_ch = {antiaim_system[i].yaw_type, "Delay"}
                    local yaw_ch = {antiaim_system[i].defensive_yaw, "Spin"}
                    local def_yaw_ch = {antiaim_system[i].defensive_type, "Builder"}

                    local def_def = {antiaim_system[i].defensive_type, "Default"}
                    local def_build = {antiaim_system[i].defensive_type, "Builder"}
                    local pitch_ch = {antiaim_system[i].defensive_pitch, "Custom"}
                    antiaim_system[i].label:depend(tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].enable:depend(cond_check, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_delay:depend(cnd_en, tab_cond, aa_tab, delay_ch, aa_builder)
                    antiaim_system[i].yaw_left:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_right:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_random:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].mod_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)

                    antiaim_system[i].mod_dm:depend(cnd_en, tab_cond, aa_tab, jit_ch, aa_builder)
                    antiaim_system[i].body_yaw_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].body_slider:depend(cnd_en, tab_cond, aa_tab, body_ch, aa_builder)

                    antiaim_system[i].force_def:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].peek_def:depend(cnd_en, tab_cond, aa_tab, {antiaim_system[i].force_def, false}, aa_builder)
                    antiaim_system[i].defensive:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].defensive_type:depend(cnd_en, tab_cond, aa_tab, def_ch, aa_builder)
                    antiaim_system[i].defensive_yaw:depend(cnd_en, tab_cond, aa_tab, def_ch, def_def, aa_builder)
                    antiaim_system[i].def_yaw_value:depend(cnd_en, tab_cond, aa_tab, def_ch, def_yaw_ch, aa_builder)
                    antiaim_system[i].yaw_value:depend(cnd_en, tab_cond, aa_tab, def_ch, yaw_ch, def_def, aa_builder)
                    antiaim_system[i].def_mod_type:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, aa_builder)
                    antiaim_system[i].def_mod_dm:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, def_jit_ch, aa_builder)
                    antiaim_system[i].def_body_yaw_type:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, aa_builder)
                    antiaim_system[i].def_body_slider:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, def_body_ch, aa_builder)
                    antiaim_system[i].defensive_pitch:depend(cnd_en, tab_cond, aa_tab, def_ch, aa_builder)
                    antiaim_system[i].pitch_value:depend(cnd_en, tab_cond, aa_tab, def_ch, pitch_ch, aa_builder)
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

                local last_sim_time = 0
                local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

                function is_defensive_active(lp)
                    if globals.chokedcommands() > 1 then return false end
                    if lp == nil or not entity.is_alive(lp) then return end
                    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
                    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
                    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
                    if delta > 0 then
                        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
                    end
                    return last_sim_time > globals.tickcount()
                end

                function is_defensive_resolver(lp)
                    if lp == nil or not entity.is_alive(lp) then return end
                    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
                    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
                    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
                    if delta > 0 then
                        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
                    end
                    return last_sim_time > globals.tickcount()
                end

                local id = 1   
                local function player_state(cmd)
                    local lp = entity.get_local_player()
                    if lp == nil then return end

                    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
                    local groundcheck = bit.band(flags, 1) == 1
                    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
                    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
                    local duckcheck = ducked or ui.get(ref.fakeduck)
                    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

                    if jumpcheck and duckcheck then return "Air+C"
                    elseif jumpcheck then return "Air"
                    elseif duckcheck and velocity > 10 then return "Duck-Moving"
                    elseif duckcheck and velocity < 10 then return "Duck"
                    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
                    elseif groundcheck and velocity > 5 then return "Moving"
                    elseif groundcheck and velocity < 5 then return "Standing"
                    else return "Global" end
                end

                local yaw_direction = 0
                local last_press_t_dir = 0

                local run_direction = function()
                    ui.set(ref.freestand[1], lua_menu.antiaim.yaw_direction:get("Freestanding"))
                    ui.set(ref.freestand[2], lua_menu.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

                    if yaw_direction ~= 0 then
                        ui.set(ref.freestand[1], false)
                    end

                    if lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == 90 and 0 or 90
                        last_press_t_dir = globals.curtime()
                    elseif lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == -90 and 0 or -90
                        last_press_t_dir = globals.curtime()
                    elseif lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_forward:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == 180 and 0 or 180
                        last_press_t_dir = globals.curtime()
                    elseif last_press_t_dir > globals.curtime() then
                        last_press_t_dir = globals.curtime()
                    end
                end

                anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
                    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
                end

                local function is_vulnerable()
                    for _, v in ipairs(entity.get_players(true)) do
                        local flags = (entity.get_esp_data(v)).flags
                        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                            return true
                        end
                    end
                    return false
                end

                local function safe_func()
                    ui.set(ref.yawjitter[1], "Off")
                    ui.set(ref.yaw[1], '180')
                    ui.set(ref.bodyyaw[1], "Static")
                    ui.set(ref.bodyyaw[2], 1)
                    ui.set(ref.yaw[2], 14)
                    ui.set(ref.pitch[2], 89)
                end

                local current_tickcount = 0
                local to_jitter = false
                local to_defensive = true
                local first_execution = true
                local yaw_amount = 0

                local function defensive_peek()
                    to_defensive = false
                end

                local function defensive_disabler()
                    to_defensive = true
                end

                local function aa_setup(cmd)
                   
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    if player_state(cmd) == "Duck-Moving" and antiaim_system[8].enable:get() then id = 8
                    elseif player_state(cmd) == "Duck" and antiaim_system[7].enable:get() then id = 7
                    elseif player_state(cmd) == "Air+C" and antiaim_system[6].enable:get() then id = 6
                    elseif player_state(cmd) == "Air" and antiaim_system[5].enable:get() then id = 5
                    elseif player_state(cmd) == "Moving" and antiaim_system[4].enable:get() then id = 4
                    elseif player_state(cmd) == "Walking" and antiaim_system[3].enable:get() then id = 3
                    elseif player_state(cmd) == "Standing" and antiaim_system[2].enable:get() then id = 2
                    else id = 1 end

                    ui.set(ref.roll[1], 0)

                    run_direction()

                    if globals.tickcount() > current_tickcount + antiaim_system[id].yaw_delay:get() then
                        if cmd.chokedcommands == 0 then
                            to_jitter = not to_jitter
                            current_tickcount = globals.tickcount()
                        end
                    elseif globals.tickcount() <  current_tickcount then
                        current_tickcount = globals.tickcount()
                    end


                    if is_vulnerable() then
                        if first_execution then
                            first_execution = false
                            to_defensive = true
                            client.set_event_callback("setup_command", defensive_disabler)
                        end
                        if globals.tickcount() % 10 == 9 then
                            defensive_peek()
                            client.unset_event_callback("setup_command", defensive_disabler)
                        end
                    else
                        first_execution = true
                        to_defensive = false
                    end

                    ui.set(ref.fsbodyyaw, false)
                    ui.set(ref.pitch[1], "Custom")
                    ui.set(ref.yawbase, lua_menu.antiaim.yaw_base:get())

                    local selected_builder_def = antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Builder" and is_defensive_active(lp)

                    if selected_builder_def then
                        ui.set(ref.yawjitter[1], antiaim_system[id].def_mod_type:get())
                        ui.set(ref.yawjitter[2], antiaim_system[id].def_mod_dm:get())
                        ui.set(ref.bodyyaw[1], antiaim_system[id].def_body_yaw_type:get())
                        ui.set(ref.bodyyaw[2], antiaim_system[id].def_body_slider:get())
                        yaw_amount = yaw_direction == 0 and antiaim_system[id].def_yaw_value:get() or yaw_direction
                    else
                        ui.set(ref.yawjitter[1], antiaim_system[id].mod_type:get())
                        ui.set(ref.yawjitter[2], antiaim_system[id].mod_dm:get())
                        if antiaim_system[id].yaw_type:get() == "Delay" then
                            ui.set(ref.bodyyaw[1], "Static")
                            ui.set(ref.bodyyaw[2], to_jitter and 1 or -1)
                        else
                            ui.set(ref.bodyyaw[1], antiaim_system[id].body_yaw_type:get())
                            ui.set(ref.bodyyaw[2], antiaim_system[id].body_slider:get())
                        end
                    end

                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Default" and antiaim_system[id].defensive_yaw:get() == "Spin" then
                        ui.set(ref.yaw[1], 'Spin')
                    else
                        ui.set(ref.yaw[1], '180')
                    end
                    
                   cmd.force_defensive = antiaim_system[id].force_def:get() or antiaim_system[id].peek_def:get() and to_defensive

                    local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
                    local desync_side = desync_type > 0

                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Default" then
                        if antiaim_system[id].defensive_yaw:get() == "Spin" then
                            yaw_amount = antiaim_system[id].yaw_value:get()
                        elseif antiaim_system[id].defensive_yaw:get() == "G-Ways" then
                            yaw_amount = desync_side and 90 or -90
                        elseif antiaim_system[id].defensive_yaw:get() == "Random" then
                            yaw_amount = math.random(-180, 180)
                        else
                            yaw_amount = desync_side and randomize_value(antiaim_system[id].yaw_left:get(), antiaim_system[id].yaw_random:get()) or randomize_value(antiaim_system[id].yaw_right:get(), antiaim_system[id].yaw_random:get())
                        end
                    elseif not selected_builder_def then
                        yaw_amount = desync_side and randomize_value(antiaim_system[id].yaw_left:get(), antiaim_system[id].yaw_random:get()) or randomize_value(antiaim_system[id].yaw_right:get(), antiaim_system[id].yaw_random:get())
                        ui.set(ref.pitch[2], 89)
                    end


                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() then
                        if antiaim_system[id].defensive_pitch:get() == "Custom" then
                            ui.set(ref.pitch[2], antiaim_system[id].pitch_value:get())
                        elseif antiaim_system[id].defensive_pitch:get() == "G-Ways" then
                            ui.set(ref.pitch[2], desync_side and 49 or -49)
                        elseif antiaim_system[id].defensive_pitch:get() == "Random" then
                            ui.set(ref.pitch[2], math.random(-89, 89))
                        else
                            ui.set(ref.pitch[2], 89)
                        end
                    end

                    ui.set(ref.yaw[2], yaw_direction == 0 and yaw_amount or yaw_direction)
                  
                    local players = entity.get_players(true)
                    if lua_menu.antiaim.addons:get("Warmup AA [cringe]") then
                        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
                            ui.set(ref.yaw[2], math.random(-180, 180))
                            ui.set(ref.yawjitter[2], math.random(-180, 180))
                            ui.set(ref.bodyyaw[2], math.random(-180, 180))
                            ui.set(ref.pitch[1], "Custom")
                            ui.set(ref.pitch[2], math.random(-89, 89)) 
                        end
                    end

                    local threat = client.current_threat()
                    local lp_weapon = entity.get_player_weapon(lp)
                    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
                    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7

                    if lua_menu.antiaim.addons:get("Safe function") then
                        if lp_weapon ~= nil then
                            if lua_menu.antiaim.safe_head:get("Air+C Knife") then
                                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CKnife" then
                                    safe_func()
                                end
                            end
                            if lua_menu.antiaim.safe_head:get("Air+C Zeus") then
                                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CWeaponTaser" then
                                    safe_func()
                                end
                            end
                            if lua_menu.antiaim.safe_head:get("High Distance") then
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
                                
                    if lua_menu.antiaim.addons:get("Avoid Backstab") then
                        for i=1, #players do
                            if players == nil then return end
                            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
                            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
                            weapon = entity.get_player_weapon(players[i])
                            if weapon == nil then return end
                            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                                ui.set(ref.yaw[2], 180)
                                ui.set(ref.yawbase, "At targets")
                            end
                        end
                    end
                end

                --gs old

                local lastmiss = 0
                local function GetClosestPoint(A, B, P)
                    a_to_p = { P[1] - A[1], P[2] - A[2] }
                    a_to_b = { B[1] - A[1], B[2] - A[2] }
                
                    atb2 = a_to_b[1]^2 + a_to_b[2]^2
                
                    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
                    t = atp_dot_atb / atb2
                    
                    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
                end
             
                client.set_event_callback("bullet_impact", function(e)                  
                    if not entity.is_alive(entity.get_local_player()) then return end
                    local ent = client.userid_to_entindex(e.userid)
                    if ent ~= client.current_threat() then return end
                    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end
                
                    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
                    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
                    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
                    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
                    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
                    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
                    if math.abs(delta_2d) <= 60 and globals.curtime() - lastmiss > 0.015 then
                        lastmiss = globals.curtime()
                        if lua_menu.misc.log:get("aimbot logs { console }") then
                            renderer.log(entity.get_player_name(ent).." shot at you")
                        end
                    end
                end)

                local function anim_breaker()
                    local lp = entity.get_local_player()
                    if not lp then return end
                    if not entity.is_alive(lp) then return end

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
                        entity.set_prop(lp, "m_flPoseParameter", lua_menu.misc.animation_value:get()/10, 0)
                    elseif lua_menu.misc.animation_ground:get() == "jitter" then
                        entity.set_prop(lp, "m_flPoseParameter", globals.tickcount() %4 > 1 and lua_menu.misc.animation_value:get()/10 or 0, 0)
                    else
                        entity.set_prop(lp, "m_flPoseParameter", math.random(lua_menu.misc.animation_value:get(), 10)/10, 0)
                    end
                    
                    if lua_menu.misc.animation_air:get() == "static" then
                        entity.set_prop(lp, "m_flPoseParameter", 1, 6)
                    elseif lua_menu.misc.animation_air:get() == "randomize" then
                        entity.set_prop(lp, "m_flPoseParameter", math.random(0, 10)/10, 6)
                    end
                end

                local function auto_tp(cmd)
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local jumpcheck = bit.band(flags, 1) == 0
                    if is_vulnerable() and jumpcheck then
                        cmd.force_defensive = true
                        cmd.discharge_pending = true
                    end
                end

                local screen = {client.screen_size()}
                local center = {screen[1]/2, screen[2]/2} 

                math.lerp = function(name, value, speed)
                    return name + (value - name) * globals.absoluteframetime() * speed
                end

                local logs = {}
                local function ragebot_logs()
                    local offset, x, y = 0, screen[1] / 2, screen[2] / 1.4
                    for idx, data in ipairs(logs) do
                        if (((globals.curtime()/2) * 2.0) - data[3]) < 4.0 and not (#logs > 5 and idx < #logs - 5) then
                            data[2] = math.lerp(data[2], 255, 10)
                        else
                            data[2] = math.lerp(data[2], 0, 10)
                        end
                        offset = offset - 40 * (data[2] / 255)

                        text_size_x, text_sise_y = renderer.measure_text("", data[1])
                        if lua_menu.misc.screen_type:get() == "Default" then
                            renderer.rectangle(x - 7 - text_size_x / 2, y - offset-8, text_size_x + 13, 26, 0, 0, 0, (data[2] / 255) * 150)
                            renderer.rectangle(x - 6 - text_size_x / 2, y - offset-7, text_size_x + 11, 24, 50, 50, 50, (data[2] / 255) * 255)
                            renderer.rectangle(x - 4 - text_size_x / 2, y - offset-4, text_size_x + 7, 18, 80, 80, 80, (data[2] / 255) * 255)
                            renderer.rectangle(x - 3 - text_size_x / 2, y - offset-3, text_size_x + 5, 16, 20, 20, 20, (data[2] / 255) * 200)
                            renderer.gradient(x - 3 - text_size_x / 2, y - offset-3, text_size_x/2+3, 1, 78,169,249, (data[2] / 255) * 255, 254,86,217, (data[2] / 255) * 255, true)
                            renderer.gradient(x - 3, y - offset-3, text_size_x/2+5, 1, 254,86,217, (data[2] / 255) * 255, 214,255,108, (data[2] / 255) * 255, true)
                        else
                            renderer.rectangle(x - 7 - text_size_x / 2, y - offset-5, text_size_x + 13, 2, 145, 90, 150, data[2])
                            renderer.rectangle(x - 7 - text_size_x / 2, y - offset-5, text_size_x + 13, 20, 0, 0, 0, (data[2] / 255) * 50)
                        end
                        renderer.text(x - 1 - text_size_x / 2, y - offset, 255, 255, 255, data[2], "", 0, data[1])
                        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
                    end
                end

                renderer.log = function(text)
                    table.insert(logs, { text, 0, ((globals.curtime() / 2) * 2.0)})
                end

                local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

                local function aim_hit(e)
                    if not lua_menu.misc.log:get() then return end
                    local group = hitgroup_names[e.hitgroup + 1] or '?'
                    if lua_menu.misc.log:get("aimbot logs { console }") then
                        print(string.format('registration %s in the %s for %d damage', string.lower(entity.get_player_name(e.target)), group, e.damage))
                    end
                end
                client.set_event_callback('aim_hit', aim_hit)

                local function aim_miss(e)
                    if not lua_menu.misc.log:get() then return end
                    local group = hitgroup_names[e.hitgroup + 1] or '?'
                    if lua_menu.misc.log:get("aimbot logs { console }") then
                        print(string.format('missed %s in the %s due to %s', string.lower(entity.get_player_name(e.target)), group, e.reason))
                    end
                end
                client.set_event_callback('aim_miss', aim_miss)

                local rgba_to_hex = function(b, c, d, e)
                    return string.format('%02x%02x%02x%02x', b, c, d, e)
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
                    local final_text = ''
                    local curtime = globals.curtime()
                    for i = 0, #text do
                        local x = i * 10  
                        local wave = math.cos(8 * speed * curtime + x / 30)
                        local color = rgba_to_hex(
                            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
                            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
                            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
                            color1.a
                        ) 
                        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
                    end
                    
                    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flag, nil, final_text)
                end

                local function doubletap_charged()
                    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end
                    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
                    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
                    if weapon == nil then return false end
                    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
                    local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
                    if checkcheck == nil then return end
                    local next_primary_attack = checkcheck + 0.01
                    if next_attack == nil or next_primary_attack == nil then return false end
                    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
                end

                local scoped_space = 0
                local main_font = "c-b"
                local key_font = "c"

                local function screen_indicator()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local ind_size = renderer.measure_text("cb", "gloriosa")
                    local scpd = entity.get_prop(lp, "m_bIsScoped") == 1
                    scoped_space = math.lerp(scoped_space, scpd and 50 or 0, 20)
                    local condition = "share"
                    if id == 1 then condition = "share" or string.upper("share")
                    elseif id == 2 then condition = "stand" or string.upper("stand")
                    elseif id == 3 then condition = "walk" or string.upper("walk")
                    elseif id == 4 then condition = "run" or string.upper("run")
                    elseif id == 5 then condition = "air" or string.upper("air")
                    elseif id == 6 then condition = "air" or string.upper("air")
                    elseif id == 7 then condition = "duck" or string.upper("duck")
                    elseif id == 8 then condition = "duck" or string.upper("duck") end
                    local spaceind = 10


                    if lua_menu.misc.cross_ind_type:get() == "pixelized" then
                        main_font = "-p"
                        key_font = "-p"
                    elseif lua_menu.misc.cross_ind_type:get() == "old" then
                        main_font = "p"
                        key_font = "p"
                    else
                        main_font = "c-d"
                        key_font = "c-d"
                    end

                    local new_check = lua_menu.misc.cross_ind_type:get() == "pixelized"

                    lua_menu.misc.cross_color:override(true)
                    lua_menu.misc.key_color:override(true)
                    local r1, g1, b1, a1 = lua_menu.misc.cross_ind:get_color()
                    local r2, g2, b2, a2 = lua_menu.misc.cross_color:get_color()
                    local r3, g3, b3, a3 = lua_menu.misc.key_color:get_color()
                    local r, g, b, a = 255, 255, 255, 255
                    text_fade_animation(center[1] + scoped_space, center[2] + 30, -1, {r=r1, g=g1, b=b1, a=255}, {r=r2, g=g2, b=b2, a=255}, new_check and string.upper("gloriosa") or "gloriosa", main_font)
                    renderer.text(center[1] + scoped_space, center[2] + 40, r2, g2, b2, 255, main_font, 0, new_check and string.upper(condition) or (condition))

                    if ui.get(ref.forcebaim)then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), 255, 102, 117, 255, key_font, 0, new_check and string.upper"BODY" or "body")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.os[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, 255, key_font, 0, new_check and string.upper"OSAA" or"osaa")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.minimum_damage_override[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, 255, key_font, 0, new_check and string.upper"DMG" or"dmg")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                        if doubletap_charged() then
                            renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, a, key_font, 0, new_check and string.upper"DT" or "dt")
                        else
                            renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), 255, 0, 0, 255, key_font, 0, new_check and string.upper"DT" or "dt")
                        end
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.freestand[1]) and ui.get(ref.freestand[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, a, key_font, 0, new_check and string.upper"FS" or "fs")
                        spaceind = spaceind + 10
                    end
                end
               


                local defensive_alpha = 0
                local defensive_amount = 0
                local velocity_alpha = 0
                local velocity_amount = 0

                --lua_menu.misc.velocity_style
                --lua_menu.misc.defensive_style

                local function velocity_ind()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local vel_mod = entity.get_prop(lp, 'm_flVelocityModifier')
                    lua_menu.misc.velocity_style_color:override(true)
                    local r, g, b, a =  lua_menu.misc.velocity_style_color:get_color()
                    if not ui.is_menu_open() then
                        velocity_alpha = math.lerp(velocity_alpha, vel_mod < 1 and 255 or 0, 10)
                        velocity_amount = math.lerp(velocity_amount, vel_mod, 10)
                    else
                        velocity_alpha = math.lerp(velocity_alpha, 255, 10)
                        velocity_amount = globals.tickcount() % 50/100 * 2
                    end

                    renderer.text(center[1], screen[2] / 3 - 10, 255, 255, 255, velocity_alpha, "c", 0, "velocity indicator")
                    if lua_menu.misc.velocity_window:get() == "" then
                        renderer.rectangle(center[1]-50, screen[2] / 3, 100, 5, 0,0,0, velocity_alpha)
                        renderer.rectangle(center[1]-49, screen[2] / 3+1, (100*velocity_amount)-1, 3, r, g, b, velocity_alpha)
                    else
                        renderer.gradient(screen[1]/2 - (50 *velocity_amount), screen[2] / 3, 1 + 50*velocity_amount, 2, r, g, b, velocity_alpha/3, r, g, b, velocity_alpha, true)
                        renderer.gradient(screen[1]/2, screen[2] / 3, 50*velocity_amount, 2, r, g, b, velocity_alpha, r, g, b, velocity_alpha/3, true)
                    end
                end

                local function defensive_ind()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local charged = doubletap_charged()
                    local active = is_defensive_active(lp)
                    local r, g, b, a = lua_menu.misc.defensive_window:get_color()
                    if not ui.is_menu_open() then
                        if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) and not ui.get(ref.fakeduck) then
                            if charged and active then
                                defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                                defensive_amount = math.lerp(defensive_amount, 1, 10)
                            elseif charged and not active then
                                defensive_alpha = math.lerp(defensive_alpha, 0, 10)
                                defensive_amount = math.lerp(defensive_amount, 0.5, 10)
                            else
                                defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                                defensive_amount = math.lerp(defensive_amount, 0, 10)
                            end
                        else
                            defensive_alpha = math.lerp(defensive_alpha, 0, 10)
                            defensive_amount = math.lerp(defensive_amount, 0, 10)
                        end
                    else
                        defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                        defensive_amount = globals.tickcount() % 50/100 * 2
                    end

                    renderer.text(center[1], screen[2] / 4 - 10, 255, 255, 255, defensive_alpha, "c", 0, "defensive indicator")
                    if lua_menu.misc.defensive_window:get() == "defensive indicator" then
                        renderer.rectangle(center[1]-50, screen[2] / 4, 10, 5, 0,0,0, defensive_alpha)
                        renderer.rectangle(center[1]-50, screen[2] / 4+1, (100*defensive_amount)-1, 3, r, g, b, defensive_alpha)
                    else
                        renderer.gradient(screen[1]/2 - (50 *defensive_amount), screen[2] / 4, 1 + 50*defensive_amount, 2, r, g, b, defensive_alpha/3, r, g, b, defensive_alpha, true)
                        renderer.gradient(screen[1]/2, screen[2] / 4, 50*defensive_amount, 2, r, g, b, defensive_alpha, r, g, b, defensive_alpha/3, true)
                    end
                end


                local function fastladder(e)
                    local local_player = entity.get_local_player()
                    local pitch, yaw = client.camera_angles()
                    if entity.get_prop(local_player, "m_MoveType") == 9 then
                        e.yaw = math.floor(e.yaw+0.5)
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
				

                local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

                math.clamp = function (x, a, b)
                    if a > x then return a
                    elseif b < x then return b
                    else return x end
                end

                local expres = {}

                expres.get_prev_simtime = function(ent)
                    local ent_ptr = native_GetClientEntity(ent)    
                    if ent_ptr ~= nil then 
                        return ffi.cast('float*', ffi.cast('uintptr_t', ent_ptr) + 0x26C)[0] 
                    end
                end

                expres.restore = function()
                    for i = 1, 64 do
                        plist.set(i, "Force body yaw", false)
                    end
                end

                expres.body_yaw, expres.eye_angles = {}, {}

                expres.get_max_desync = function (animstate)
                    local speedfactor = math.clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
                    local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

                    local duck_amount = animstate.duck_amount
                    if duck_amount > 0 then
                        avg_speedfactor = avg_speedfactor + (duck_amount * speedfactor * (0.5 - avg_speedfactor))
                    end

                    return math.clamp(avg_speedfactor, .5, 1)
                end

                expres.handle = function(current_threat)
                    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then 
                        expres.restore()
                        return 
                    end

                    if expres.body_yaw[current_threat] == nil then 
                        expres.body_yaw[current_threat], expres.eye_angles[current_threat] = {}, {}
                    end

                    local simtime = toticks(entity.get_prop(current_threat, 'm_flSimulationTime'))
                    local prev_simtime = toticks(expres.get_prev_simtime(current_threat))
                    expres.body_yaw[current_threat][simtime] = entity.get_prop(current_threat, 'm_flPoseParameter', 11) * 120 - 60
                    expres.eye_angles[current_threat][simtime] = select(2, entity.get_prop(current_threat, "m_angEyeAngles"))

                    if expres.body_yaw[current_threat][prev_simtime] ~= nil then
                        local ent = c_entity.new(current_threat)
                        local animstate = ent:get_anim_state()
                        local max_desync = expres.get_max_desync(animstate)
                        local Pitch = entity.get_prop(current_threat, "m_angEyeAngles[0]")
                        local pitch_e = Pitch > -30 and Pitch < 49
                        local curr_side = globals.tickcount() % 4 > 1 and 1 or - 1

                        if lua_menu.misc.resolver_type:get() == "Jitter / Defensive" then
                            local should_correct = (simtime - prev_simtime >= 1) and math.abs(max_desync) < 45 and expres.body_yaw[current_threat][prev_simtime] ~= 0
                            if should_correct then
                                local value = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25
                                plist.set(current_threat, 'Force body yaw', true)  
                                plist.set(current_threat, 'Force body yaw value', value)
                            else
                                plist.set(current_threat, 'Force body yaw', false)  
                            end
                        elseif lua_menu.misc.resolver_type:get() == "Experimental" then
                            if pitch_e then
                                value_body = 0
                            else
                                value_body = curr_side * (max_desync * math.random(0, 58))
                            end
                            plist.set(current_threat, 'Force body yaw', true)  
                            plist.set(current_threat, 'Force body yaw value', value_body) 
                        else
                            if not is_defensive_resolver(current_threat) then return end
                            if pitch_e then
                                value_body = 0
                            else
                                value_body = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25
                            end
                            plist.set(current_threat, 'Force body yaw', true)  
                            plist.set(current_threat, 'Force body yaw value', value_body) 
                        end

                    end
                    plist.set(current_threat, 'Correction active', true)
                end

                local function resolver_update()
                    local lp = entity.get_local_player()
                    if not lp then return end
                    local entities = entity.get_players(true)
                    if not entities then return end

                    for i = 1, #entities do
                        local target = entities[i]
                        if not target then return end
                        if not entity.is_alive(target) then return end
                        expres.handle(target)
                    end
                end

                local phrases = {
                    'мне кажется ты въебал все что мог',
                    'ты че пидрила упала от меня',
                    'черкаш ебливый по кд падаешь',
                    '$$ ＧＬＯＲＩＯＳＡ $$',
                    'С Н О В А В Ы Ш Е Л П О Б Е Д И Т Е Л Е М',
                    'САКАЙ МОЮ ХУЯКУ, ПОКА Я ТЕБЯ ЕБУ С gloriosa [GAMESENSE]',
                    '$$$ ＧＬＯＲＩＯＳＡ ＦＯＲ ＰＲＥＭＩＵＭ $$$',
                    '1 ТЕБЕ ПИДРИЛА',
                    'ＢＥ ＩＮＶＩＮＣＩＢＬＥ ＷＩＴＨ ＧＬＯＲＩＯＳＡ',
                    'Ｉ ＡＭ ＫＩＮＧ ＡＭＯＮＧ ＹＯＵ ＭＯＮＫＥＹＳ ♕',
                    
                }

                local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

                local function on_player_death(e)
                    if not lua_menu.misc.spammers:get("Shit talking") then return end
                    if not lua_menu.main.enable:get() then return end

                    local victim_userid, attacker_userid = e.userid, e.attacker
                    if victim_userid == nil or attacker_userid == nil then
                        return
                    end

                    local victim_entindex = userid_to_entindex(victim_userid)
                    local attacker_entindex = userid_to_entindex(attacker_userid)

                    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
                        client.delay_call(2, function() console_cmd("say ", phrases[math.random(1, #phrases)]) end)
                    end
                end
                client.set_event_callback("player_death", on_player_death)

                local config_items = {menu, antiaim_system}

                local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
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
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
                    }

                
                    label_text = string.format("a s p h\aFFC0CBFF i x y a \afa5757FF[kitty]", rgba_to_hex(unpack(aA[1])), rgba_to_hex(unpack(aA[2])), rgba_to_hex(unpack(aA[3])), rgba_to_hex(unpack(aA[4])), rgba_to_hex(unpack(aA[5])), rgba_to_hex(unpack(aA[6])), rgba_to_hex(unpack(aA[7])))
                    lua_menu.main.enable:set(label_text)
    
                end

                client.set_event_callback("setup_command", function(cmd)
                    if not lua_menu.main.enable:get() then return end
                    aa_setup(cmd)
                    if lua_menu.misc.fast_ladder:get() then
                        fastladder(cmd)
                    end
                    if lua_menu.misc.resolver:get() then
                        resolver_update()
                    end
                end)

local refs = {
    slowmotion = ui.reference("AA", "Other", "Slow motion"),
    OSAAA = ui.reference("AA", "Other", "On shot anti-aim"),
    Legmoves = ui.reference("AA", "Other", "Leg movement"),
    legit = ui.reference("LEGIT", "Aimbot", "Enabled"),
    minimum_damage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") },
    fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
    minimum_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
    hitChance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    safePoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    forceBaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    dtLimit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    quickPeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    yawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    flLimit = ui.reference("AA", "Fake lag", "Limit"),
    flamount = ui.reference("AA", "Fake lag", "Amount"),
    flenabled = ui.reference("AA", "Fake lag", "Enabled"),
    flVariance = ui.reference("AA", "Fake lag", "Variance"),
    AAfake = ui.reference("AA", "Other", "Fake peek"),
    fsBodyYaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    yawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    bodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    freeStand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    slow = {ui.reference("AA", "Other", "Slow motion")},
    fakeLag = {ui.reference("AA", "Fake lag", "Limit")},
    legMovement = ui.reference("AA", "Other", "Leg movement"),
    indicators = {ui.reference("VISUALS", "Other ESP", "Feature indicators")},
    ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
}

local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}
local indicators_table = {}

local zalupa = function(indicator)
    indicators_table[#indicators_table + 1] = indicator
end

client.set_event_callback("paint", function()
    local local_player = entity.get_local_player()
    if local_player == nil or entity.is_alive(local_player) == false then return end
    local sizeX, sizeY = client.screen_size()
    local weapon = entity.get_player_weapon(local_player)
    local bodyYaw = entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60
    local side = bodyYaw > 0 and 1 or -1
    local state = "MOVING"
    local fake = math.floor(antiaim_funcs.get_desync(1))
    
    -- draw indicators
    if lua_menu.misc.gamesenseold:get("GameSense Indicators [old]") then
    local dpi = ui.get(ui.reference("MISC", "Settings", "DPI scale")):gsub('%%', '') - 100
    local globalFlag = "cd-"
    local globalMoveY = 0
    local indX, indY = renderer.measure_text(globalFlag, "DT")
    local yDefault = 16
    local indCount = 0
    indY = globalFlag == "cd-" and indY - 3 or indY - 2

    local nextAttack = entity.get_prop(local_player, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(local_player), "m_flNextPrimaryAttack")
    local dtActive = false
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end
    local isCharged = dtActive
    local isFs = ui.get(refs.freeStand[2])
    local isBa = ui.get(refs.forceBaim)
    local isSp = ui.get(refs.safePoint)
    local isQp = ui.get(refs.quickPeek[2])
    local isSlow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    local isOs = ui.get(refs.os[1]) and ui.get(refs.os[2])
    local isFd = ui.get(refs.fakeDuck)
    local isDt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])


    

    local h = select(2, client.screen_size())
    local starting = h - 422

    for index, indicator in pairs(indicators_table) do index = index - 1
        local width, height = renderer.measure_text('d+', indicator.text)
        local offset = index * (height - 8)

        local y = starting + offset

        renderer.text(10, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
    end
end

    indicators_table = {}
end)
-- @region INDICATORS end
client.set_event_callback('indicator', zalupa)

-- @region UI_CALLBACKS start

                client.set_event_callback('pre_render', function()
                    if not lua_menu.main.enable:get() then return end
                    if lua_menu.misc.animation:get() then
                        anim_breaker()
                    end
                end)

                client.set_event_callback('paint_ui', function()
                    hide_original_menu(false)
                    update_menu()
                end)

                client.set_event_callback('paint', function()
                    if not lua_menu.main.enable:get() then return end
                    if not entity.is_alive(entity.get_local_player()) then return end
                    if lua_menu.misc.cross_ind:get() then
                        screen_indicator()
                    end
                    if lua_menu.misc.velocity_window:get() then
                        velocity_ind()
                    end
                    if lua_menu.misc.defensive_window:get() then
                        defensive_ind()
                    end
                    ragebot_logs()

                end)

                lua_menu.misc.resolver:set_callback(function(self)
                    if not self:get() then
                        expres.restore()
                    end
                end, true)

                client.set_event_callback('shutdown', function()
                    hide_original_menu(true)
                    expres.restore()
                end)

                client.set_event_callback('round_prestart', function()
                    logs = {}
                    if lua_menu.misc.log:get("aimbot logs { console }") then
                        renderer.log("Anti-Aim Data Resetted")
                    end
                end)
				
				local http = require 'gamesense/http'
local images = require 'gamesense/images'
local callback = client.set_event_callback
local render = renderer
local screen_x, screen_y = client.screen_size()

render.round_rect = function(x, y, w, h, r, g, b, a, radius)
    y = y + radius;
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    };

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    };

    for _, data in next, data_circle do
        render.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25);
    end;

    for _, data in next, data do
        render.rectangle(data[1], data[2], data[3], data[4], r, g, b, a);
    end;
end;

local downloadfile = function()
	http.get(string.format('https://flagcdn.com/w160/%s.png', panorama.open().MyPersonaAPI.GetMyCountryCode():lower()), function(success, response)
		if not success or response.status ~= 200 then
            return;
		end;

        writefile('flag_'..panorama.open().MyPersonaAPI.GetMyCountryCode():lower()..'.png', response.body);
	end);
end;
downloadfile();

local hex_label = function(rgb)
    local hexadecimal= '\a';
    
    for key, value in pairs(rgb) do
        local hex = '';

        while value > 0 do
            local index = math.fmod(value, 16) + 1;
            value = math.floor(value/16);
            hex = ('0123456789ABCDEF'):sub(index, index) .. hex;
        end

        if #hex == 0 then 
            hex= '00';
        elseif #hex == 1 then 
            hex= '0' .. hex;
        end;

        hexadecimal = hexadecimal .. hex;
    end;
    
    return hexadecimal;
end;

local watermark = function ()
    local colors = hex_label({100, 55, 215, 255});

    render.round_rect(9, screen_y / 2 - 78, 102, 20, 100, 55, 215, 255, 10);
    render.round_rect(10, screen_y / 2 - 90, 100, 30, 11, 11, 11, 255, 10);

    for i = 1, 3 do
        render.triangle(-3 + 25 * i, screen_y / 2 - 87, 21 + 25 * i, screen_y / 2 - 83, 11 + 25 * i, screen_y / 2 - 78, 55, 55, 55, 255);
        render.triangle(2 + 25 * i, screen_y / 2 - 77, 26 + 25 * i, screen_y / 2 - 73, 14 + 25 * i, screen_y / 2 - 68, 55, 55, 55, 255);
    end;

    local flag = images.load_png(readfile('flag_'..panorama.open().MyPersonaAPI.GetMyCountryCode():lower()..'.png'));
    flag:draw(20, screen_y / 2 - 82, 25, 16.5, 255,255,255,255);

    local text_size = render.measure_text('-', 'gloriosa');
    render.text(12 - text_size + 70, screen_y / 2 - 85, 215, 215, 215, 255, '-', nil, 'gloriosa'..colors..' LUA');
    render.text(12 - text_size + 70, screen_y / 2 - 75, 215, 215, 215, 255, '-', nil, '[NIGHTLY]');
end;

callback('paint_ui', watermark);