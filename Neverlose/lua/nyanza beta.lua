local l_pui_0 = require("neverlose/pui");
l_pui_0.colors.warn = color("#BABD5B");
local _ = require("neverlose/wapi");
local l_base64_0 = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local _ = {};
ffi.cdef("    typedef struct {\n        char pad_0000[20];\n        int m_nOrder;\n        int m_nSequence;\n        float m_flPrevCycle;\n        float m_flWeight;\n        float m_flWeightDeltaRate;\n        float m_flPlaybackRate;\n        float m_flCycle;\n        void* m_pOwner;\n        char pad_0038[4];\n    } CAnimationLayer;\n");
local v707 = new_class():struct("references")({
    rage = {
        main = {
            dt = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
            dt_lag = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
            hs_lag = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
            hs = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots")
        }
    }, 
    antiaim = {
        enabled = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        angles = {
            pitch = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            extract_yaw = {
                yaw = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw"), 
                offset = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw", "Offset"), 
                base = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw", "Base"), 
                snap = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw", "Hidden"), 
                avoid_backstab = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw", "Avoid Backstab"), 
                roll = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Extended Angles")
            }, 
            extract_modifier = {
                mode = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw Modifier"), 
                offset = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "yaw Modifier", "Offset")
            }, 
            extract_desync = {
                switch = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body yaw"), 
                left_limit = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "left Limit"), 
                right_limit = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "right Limit"), 
                tweaks = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "Options"), 
                inverter = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
                freestanding = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            }, 
            extract_freestanding = {
                switch = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
                disable_jitter = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable yaw Modifiers"), 
                body = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            }
        }, 
        misc = {
            fake_duck = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            slidewalk_directory = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    visuals = {
        world = {
            main = {
                zoom_scope = l_pui_0.find("Visuals", "World", "Main", "Override Zoom"), 
                scope_overlay = l_pui_0.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
            }
        }
    }, 
    misc = {
        main = {
            other = {
                ping_spike = l_pui_0.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
}):struct("localplayer")({
    flags = 0, 
    pre_predict_command = function(v5, v6)
        v5.flags = entity.get_local_player().m_fFlags;
        v5.is_in_air = v6.in_jump or bit.band(v5.flags, bit.lshift(1, 0)) == 0;
    end, 
    is_in_duck = function(_, v8)
        local l_m_fFlags_0 = v8.m_fFlags;
        return bit.band(l_m_fFlags_0, 4) == 4;
    end, 
    side = function(_)
        local v11 = entity.get_local_player();
        if not v11 or not v11:is_alive() then
            return;
        else
            return v11.m_flPoseParameter[11] * 120 - 60 > 0;
        end;
    end, 
    state = function(v12, _)
        local v14 = entity.get_local_player();
        if not v14 or not v14:is_alive() then
            return;
        else
            local v15 = v14.m_vecVelocity:length();
            local v16 = v14.m_iTeamNum == 2 and 1 or 2;
            local v17 = 1;
            if v12.is_in_air then
                v17 = v12:is_in_duck(v14) and 7 or 6;
            elseif v15 > 3 then
                v17 = v12:is_in_duck(v14) and 5 or v12.references.antiaim.misc.slow_walk:get() and 3 or 2;
            else
                v17 = v12:is_in_duck(v14) and 4 or 1;
            end;
            if v12.antiaim.elements.freestanding:get() and v12.antiaim.elements.freestanding_allowed:get() then
                v17 = 8;
            end;
            return v17, v16;
        end;
    end, 
    disabler_state = function(v18, _)
        local v20 = entity.get_local_player();
        if not v20 or not v20:is_alive() then
            return;
        else
            local v21 = v20.m_vecVelocity:length();
            local v22 = 1;
            if v18.is_in_air then
                v22 = v18:is_in_duck(v20) and 7 or 6;
            elseif v21 > 3 then
                v22 = v18:is_in_duck(v20) and 5 or v18.references.antiaim.misc.slow_walk:get() and 3 or 2;
            else
                v22 = v18:is_in_duck(v20) and 4 or 1;
            end;
            return v22;
        end;
    end, 
    init = function(v23)
        local function v25(v24)
            -- upvalues: v23 (ref)
            v23:pre_predict_command(v24);
        end;
        events.createmove(v25);
    end
}):struct("home")({
    init = function(v26)
        -- upvalues: l_pui_0 (ref)
        v26.groups = {
            main = l_pui_0.create("\v\239\138\189", " ", 1), 
            info = l_pui_0.create("\v\239\138\189", "Information", 2), 
            discord = l_pui_0.create("\v\239\138\189", ""), 
            products = l_pui_0.create("\v\239\138\189", "Our Products"), 
            presets = l_pui_0.create("\v\239\138\189", "Presets"), 
            watermark = l_pui_0.create("\v\239\138\189", "Watermark")
        };
        v26.elements = {
            warning = v26.groups.main:label("\a[warn]\239\129\177   \rThe script is a work in progress and some features may not work as intended."), 
            about = v26.groups.main:list("", "\v\239\128\135       \r" .. common.get_username(), "\v\239\130\133     \rOther"), 
            report_bugs = v26.groups.discord:label("\239\134\136  Report Bugs"), 
            join_discord = v26.groups.discord:button("\v\239\142\146 \rDiscord Server", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/BfV7xXxFNS");
            end, true), 
            progress_version_bar = v26.groups.info:slider("\v\238\132\186   \rVersions", 1, 60, 1, nil, function(v27)
                local v28 = {};
                for v29 = 1, 60 do
                    if v29 <= 23 then
                        v28[v29] = string.format("V%03d", v29);
                    elseif v29 <= 47 then
                        v28[v29] = string.format("V%03dB", v29);
                    elseif v29 >= 48 then
                        v28[v29] = string.format("V%03dARC", v29);
                    end;
                end;
                return v28[v27];
            end), 
            config_name = v26.groups.info:label("\v\238\136\145  \rConfig Name: \v" .. common.get_config_name()), 
            active_scripts = v26.groups.info:list("\v\239\160\168    \rLoaded Scripts", common.get_active_scripts()), 
            configs = v26.groups.products:label("Configs"), 
            config_button = v26.groups.products:button("Rxdxyxz", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=tDOIP4");
            end, true), 
            scripts = v26.groups.products:label("Scripts"), 
            script_button_nyanza = v26.groups.products:button("Nyanza", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=s9V6D3");
            end, true), 
            script_button_nyanza_beta = v26.groups.products:button("Nyanza Beta", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=nmPxrV");
            end, true), 
            watermark_gear = v26.groups.watermark:label("\v\238\134\149  \rOptions"), 
            watermark_options = {}
        };
        v26.elements.preset_buttons = {};
        v26.elements.preset_list = v26.groups.presets:list("", {});
        v26.elements.preset_input = v26.groups.presets:input("", "my new p fig!");
        v26.elements.preset_buttons.create = v26.groups.presets:button("\v\239\153\158", nil, true, "Create");
        v26.elements.preset_buttons.load = v26.groups.presets:button("\v\239\136\133", nil, true, "Load");
        v26.elements.preset_buttons.import = v26.groups.presets:button("\v\239\149\175", nil, true, "Import");
        v26.elements.preset_buttons.export = v26.groups.presets:button("\v\239\149\174", nil, true, "Export");
        v26.elements.preset_buttons.save = v26.groups.presets:button("\a4CAF50FF\239\131\135", nil, true, "Save");
        v26.elements.preset_buttons.delete = v26.groups.presets:button("               \aF44336FF\239\139\173                 ", nil, false, "Delete");
        local v30 = v26.elements.watermark_gear:create();
        v26.elements.watermark_options = {
            master = v30:slider("Master Gear", 0, 2, 0), 
            pos_x = v30:slider("x", 0, render.screen_size().x, render.screen_size().x / 2), 
            pos_y = v30:slider("y", 0, render.screen_size().y, render.screen_size().y - 20), 
            separator_back = v30:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
            font = v30:combo("\v\226\128\162  \rFont", "Default", "Pixel", "Console", "Bold"), 
            font_name = v30:input("    \v\226\164\183  \rName", "Segoe UI"), 
            font_size = v30:slider("    \v\226\164\183  \rSize", 10, 30, 15, nil, "px"), 
            label = v30:input("\v\226\128\162  \rLabel", "snapshot"), 
            button = v30:button("\v\238\136\134  \rPrint the Instruction to the Console", function(_)
                cvar.clear:call();
                print_raw("\239\130\133 Commands:\n    pre= \226\128\148 Set prefix text\n    m= \226\128\148 Main text\n    post= \226\128\148 Set postfix text\n\nExample: pre=N Y A m= S E N S E  post= [BETA]\n\nIcon Commands (FontAwesome icons):\n    icon_pre= \226\128\148 Icon before prefix\n    icon_post= \226\128\148 Icon after postfix\n\nExample: pre=D E S icon_pre=moon-stars m= Y N C post= icon_post=sparkles\nExample #2 (Icon and Text): pre= icon_pre=star m=DESYNC\n\nImportant:\n1. Commands must be in this order: pre > icon_pre > m > post > icon_post\n2. You can use just text without commands: NYANZA.MEOW or desync.max\n3. Find icons at: fontawesome.com/icons or click the button in Options.");
            end, true), 
            icons_button = v30:button("      \v\239\138\180 \rIcons      ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://fontawesome.com/search?ip=classic&s=solid&o=r");
            end, true), 
            reset_button = v30:button("      \aF44336FF\239\128\145 Reset Position      ", function()
                -- upvalues: v26 (ref)
                v26.elements.watermark_options.pos_x:set(render.screen_size().x / 2);
                v26.elements.watermark_options.pos_y:set(render.screen_size().y - 20);
            end, true), 
            back_button = v30:button("\v\239\129\162  \rBack", function()
                -- upvalues: v26 (ref)
                cvar.play:call("ui\\csgo_ui_contract_type1");
                v26.elements.watermark_options.master:set(0);
            end, true), 
            separator_etc = v30:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
            main_accent = v30:color_picker("\v\226\128\162  \rMain Accent", color(255, 255, 255, 255)), 
            prefix_accent = v30:color_picker("    \v\226\164\183  \rPrefix", color(150, 200, 60, 255)), 
            postfix_accent = v30:color_picker("    \v\226\164\183  \rPostfix", color(235, 97, 97, 255)), 
            colors_button = v30:button("\v\239\148\191  \rColors", function()
                -- upvalues: v26 (ref)
                cvar.play:call("ui\\csgo_ui_contract_type1");
                v26.elements.watermark_options.master:set(2);
            end, true), 
            gradient_button = v30:button("\v\239\151\131  \rGradient", function()
                -- upvalues: v26 (ref)
                cvar.play:call("ui\\csgo_ui_contract_type1");
                v26.elements.watermark_options.master:set(1);
            end, true), 
            gradient_switch = v30:switch("\v\226\128\162  \rRun Animation"), 
            gradient_saturation = v30:slider("    \v\226\164\183  \rSaturation", 0, 10, 5), 
            gradient_rainbow = v30:switch("            \v\226\164\183  \rRainbow"), 
            gradient_hue = v30:slider("    \v\226\164\183  \rHue", 0, 9, 0, nil, function(v32)
                return ({
                    [1] = "Red", 
                    [2] = "Orange", 
                    [3] = "Salad", 
                    [4] = "Green", 
                    [5] = "Cyan", 
                    [6] = "Turquoise", 
                    [7] = "Blue", 
                    [8] = "Indigo", 
                    [9] = "Purple", 
                    [10] = "Pink"
                })[v32 + 1];
            end), 
            gradient_speed = v30:slider("    \v\226\164\183  \rSpeed", 1, 10, 2)
        };
        v26.elements.watermark_options.gradient_switch:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.gradient_saturation:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.watermark_options.master
        }, v26.elements.watermark_options.gradient_switch);
        v26.elements.watermark_options.gradient_rainbow:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.watermark_options.master
        }, {
            [1] = nil, 
            [2] = 1, 
            [3] = 10, 
            [1] = v26.elements.watermark_options.gradient_saturation
        }, v26.elements.watermark_options.gradient_switch);
        v26.elements.watermark_options.gradient_hue:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.watermark_options.master
        }, {
            [1] = nil, 
            [2] = 1, 
            [3] = 10, 
            [1] = v26.elements.watermark_options.gradient_saturation
        }, {
            [1] = nil, 
            [2] = false, 
            [1] = v26.elements.watermark_options.gradient_rainbow
        }, v26.elements.watermark_options.gradient_switch);
        v26.elements.watermark_options.gradient_speed:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.watermark_options.master
        }, v26.elements.watermark_options.gradient_switch);
        v26.elements.watermark_options.font:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.font_name:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        }, {
            [1] = nil, 
            [2] = "Custom", 
            [1] = v26.elements.watermark_options.font
        });
        v26.elements.watermark_options.font_size:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        }, {
            [1] = nil, 
            [2] = "Custom", 
            [1] = v26.elements.watermark_options.font
        });
        v26.elements.watermark_options.master:depend({
            [1] = nil, 
            [2] = 100, 
            [1] = v26.elements.progress_version_bar
        });
        v26.elements.watermark_options.pos_x:depend({
            [1] = nil, 
            [2] = 100, 
            [1] = v26.elements.progress_version_bar
        });
        v26.elements.watermark_options.pos_y:depend({
            [1] = nil, 
            [2] = 100, 
            [1] = v26.elements.progress_version_bar
        });
        v26.elements.watermark_options.separator_back:depend({
            [1] = nil, 
            [2] = 1, 
            [3] = 2, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.back_button:depend({
            [1] = nil, 
            [2] = 1, 
            [3] = 2, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.separator_etc:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.label:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.button:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.icons_button:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.reset_button:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.colors_button:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.gradient_button:depend({
            [1] = nil, 
            [2] = 0, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.main_accent:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.prefix_accent:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.watermark_options.postfix_accent:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.watermark_options.master
        });
        v26.elements.report_bugs:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.join_discord:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.progress_version_bar:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.config_name:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.active_scripts:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.configs:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.config_button:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.scripts:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.script_button_nyanza:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.script_button_nyanza_beta:depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.save:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.load:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.export:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.import:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.delete:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_buttons.create:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_list:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.preset_input:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
        v26.elements.watermark_gear:depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v26.elements.about
        });
    end
}):struct("presets")({
    init = function(v33)
        -- upvalues: l_pui_0 (ref)
        v33.database = db.snapshot555 or {};
        v33.system_presets = {
            l_pui_0.string("\v\226\128\162  \rSnappy  \v\226\156\166"), 
            l_pui_0.string("\v\226\128\162  \rSnappy  [2]  \v\226\156\166  \aFFFFFF40New!\r"), 
            l_pui_0.string("\v\226\128\162  \rDelayed"), 
            l_pui_0.string("\v\226\128\162  \rAggressive")
        };
        v33.separator = l_pui_0.string("\v\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128");
        if not v33.database[l_pui_0.string("\v\226\128\162  \rSnappy  \v\226\156\166")] or #v33.database == 0 then
            v33.database[l_pui_0.string("\v\226\128\162  \rSnappy  \v\226\156\166")] = "W3siYWJvdXQiOjIuMCwiYWN0aXZlX3NjcmlwdHMiOjEuMCwicHJlc2V0X2lucHV0IjoiXHUwMDA3e0xpbmsgQWN0aXZlfeKAoiAgXHUwMDA3REVGQVVMVFNuYXBweSAgXHUwMDA3e0xpbmsgQWN0aXZlfeKcpiIsInByZXNldF9saXN0Ijo2LjAsInByb2dyZXNzX3ZlcnNpb25fYmFyIjoxLjAsIndhdGVybWFya19vcHRpb25zIjp7ImZvbnQiOiJEZWZhdWx0IiwiZm9udF9uYW1lIjoiU2Vnb2UgVUkiLCJmb250X3NpemUiOjE1LjAsImdyYWRpZW50X2h1ZSI6MC4wLCJncmFkaWVudF9yYWluYm93IjpmYWxzZSwiZ3JhZGllbnRfc2F0dXJhdGlvbiI6NS4wLCJncmFkaWVudF9zcGVlZCI6Mi4wLCJncmFkaWVudF9zd2l0Y2giOmZhbHNlLCJsYWJlbCI6InNuYXBzaG90IiwibWFpbl9hY2NlbnQiOiIjRkZGRkZGRkYiLCJtYXN0ZXIiOjAuMCwicG9zX3giOjk2MC4wLCJwb3NfeSI6MTA2MC4wLCJwb3N0Zml4X2FjY2VudCI6IiNFQjYxNjFGRiIsInByZWZpeF9hY2NlbnQiOiIjOTZDODNDRkYifX0seyJkaXNhYmxlX2xjX2dyZW5hZGUiOmZhbHNlLCJmb3JjZV9icmVha19sYyI6WyJcdTAwMDd7TGluayBBY3RpdmV974aDICAgICBcdTAwMDdERUZBVUxUU3RhbmRpbmciLCJcdTAwMDd7TGluayBBY3RpdmV975WUICAgICBcdTAwMDdERUZBVUxUU2xvd2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6LjiAgICBcdTAwMDdERUZBVUxUU25lYWtpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97pWGICAgIFx1MDAwN0RFRkFVTFRBaXIiLCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3uk4EgICBcdTAwMDdERUZBVUxURnJlZXN0YW5kaW5nIiwifiJdLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJmcmVlc3RhbmRpbmdfYWxsb3dlZCI6dHJ1ZSwiaGlkZV9zaG90cyI6IkJyZWFrIExDIiwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwib3B0aW9uc190YWJsZSI6eyJhdm9pZF9iYWNrc3RhYiI6dHJ1ZSwiZmFrZV9sYWciOmZhbHNlLCJmYWtlX2xhZ190eXBlIjoiQWx3YXlzIG9uIiwic2FmZV9oZWFkIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nICBcdTAwMDdCQUJENUJGRisgIFx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nICBcdTAwMDdCQUJENUJGRisgIFx1MDAwN0RFRkFVTFRLbmlmZS9UYXNlciIsIn4iXSwidHdlYWtzIjpbIn4iXSwidHdlYWtzX2xlZnRfb2Zmc2V0IjotMzAuMCwidHdlYWtzX3BpdGNoIjoiRGlzYWJsZWQiLCJ0d2Vha3NfcmFuZ2UiOjE4MC4wLCJ0d2Vha3NfcmlnaHRfb2Zmc2V0IjozMC4wLCJ0d2Vha3Nfc3BlZWQiOjIuMCwidHdlYWtzX3lhd190eXBlIjoiU3BpbiJ9LCJzdGF0ZXMiOjguMCwidGVhbXMiOjIuMCwieWF3X2dlYXIiOjAuMCwifmZyZWVzdGFuZGluZyI6eyJib2R5X2ZzIjp0cnVlfX0sW1t7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NjAuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MTIuMCwiZGVsYXlfNSI6MTIuMCwiZGVsYXlfNiI6MTUuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjotNC4wLCJtb2RpZmllcl8yIjotMzcuMCwibW9kaWZpZXJfMyI6LTQwLjAsIm1vZGlmaWVyXzQiOjUuMCwibW9kaWZpZXJfNSI6MTYuMCwibW9kaWZpZXJfNiI6MzAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjExLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi00NS4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo2LjAsImRlbGF5X3NsaWRlcnMiOjMuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjozLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiUmFuZG9tIiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOi0zLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0xLjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjQuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0IjozNy4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjI4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6My4wLCJkZWxheV80IjoxOC4wLCJkZWxheV81IjoxLjAsImRlbGF5XzYiOjE2LjAsIm1vZGlmaWVyIjoiUmFuZG9tIiwibW9kaWZpZXJfMSI6LTEzLjAsIm1vZGlmaWVyXzIiOjI4LjAsIm1vZGlmaWVyXzMiOjQ5LjAsIm1vZGlmaWVyXzQiOjM1LjAsIm1vZGlmaWVyXzUiOjQzLjAsIm1vZGlmaWVyXzYiOi0yMi4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTMuMCwibWluX29mZnNldF92YWx1ZSI6LTEuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6NC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjMuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjM3LjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6My4wLCJkZWxheV8yIjoxMi4wLCJkZWxheV8zIjoxMS4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEyLjAsImRlbGF5XzYiOjExLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTI5LjAsIm1vZGlmaWVyXzIiOjM0LjAsIm1vZGlmaWVyXzMiOjExLjAsIm1vZGlmaWVyXzQiOi0zMy4wLCJtb2RpZmllcl81IjotMjkuMCwibW9kaWZpZXJfNiI6MzMuMCwibW9kaWZpZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MjEuMCwibWluX29mZnNldF92YWx1ZSI6MzIuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NC4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE1LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjE2LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19XSxbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjQ4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJUaWNrcyIsInR5cGVfcmFuZG9tX3ZhbHVlIjoxNi4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjoxNi4wfSwiZGVsYXlfMSI6MjAuMCwiZGVsYXlfMiI6MTMuMCwiZGVsYXlfMyI6OC4wLCJkZWxheV80IjoxNC4wLCJkZWxheV81IjoxMC4wLCJkZWxheV82IjoxMi4wLCJtb2RpZmllciI6IlJhbmRvbSIsIm1vZGlmaWVyXzEiOi0yMC4wLCJtb2RpZmllcl8yIjotMTMuMCwibW9kaWZpZXJfMyI6LTcuMCwibW9kaWZpZXJfNCI6LTEzLjAsIm1vZGlmaWVyXzUiOjcuMCwibW9kaWZpZXJfNiI6MS4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NDQuMCwibWluX29mZnNldF92YWx1ZSI6LTMzLjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6Ni4wLCJ0eXBlIjoiV2F5cyJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjIuMCwidGlja2Jhc2VfMiI6NS4wLCJ0aWNrYmFzZV8zIjo4LjAsInRpY2tiYXNlXzQiOjIyLjAsInRpY2tiYXNlXzUiOjYuMCwidGlja2Jhc2VfNiI6My4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjYuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6Ni4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Ni4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0Ijo0Mi4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjQ4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJSYW5kb20iLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjE5LjAsImRlbGF5XzIiOjIwLjAsImRlbGF5XzMiOjcuMCwiZGVsYXlfNCI6MTEuMCwiZGVsYXlfNSI6NS4wLCJkZWxheV82IjoxNC4wLCJtb2RpZmllciI6IlJhbmRvbSIsIm1vZGlmaWVyXzEiOi0yMC4wLCJtb2RpZmllcl8yIjotMTMuMCwibW9kaWZpZXJfMyI6LTcuMCwibW9kaWZpZXJfNCI6LTEzLjAsIm1vZGlmaWVyXzUiOjcuMCwibW9kaWZpZXJfNiI6MS4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NDQuMCwibWluX29mZnNldF92YWx1ZSI6LTMzLjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6Ni4wLCJ0eXBlIjoiV2F5cyJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo2LjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjQyLjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjoyMC4wLCJkZWxheV8yIjoxNC4wLCJkZWxheV8zIjozLjAsImRlbGF5XzQiOjguMCwiZGVsYXlfNSI6MTMuMCwiZGVsYXlfNiI6MTkuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjotNDUuMCwibW9kaWZpZXJfMiI6MTEuMCwibW9kaWZpZXJfMyI6LTUuMCwibW9kaWZpZXJfNCI6MTUuMCwibW9kaWZpZXJfNSI6MzYuMCwibW9kaWZpZXJfNiI6LTMzLjAsIm1vZGlmaWVyX29mZnNldCI6My4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQzLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi04LjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjQuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNS4wLCJ0aWNrYmFzZV8zIjoxNS4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNS4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6NC4wLCJkZWxheV90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjAuMCwib2Zmc2V0X3JpZ2h0Ijo0MC4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjUuMCwiZGVsYXlfMiI6MS4wLCJkZWxheV8zIjoxNi4wLCJkZWxheV80Ijo0LjAsImRlbGF5XzUiOjE5LjAsImRlbGF5XzYiOjEzLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTE5LjAsIm1vZGlmaWVyXzIiOjguMCwibW9kaWZpZXJfMyI6NDkuMCwibW9kaWZpZXJfNCI6LTE3LjAsIm1vZGlmaWVyXzUiOi0xOC4wLCJtb2RpZmllcl82IjotMjcuMCwibW9kaWZpZXJfb2Zmc2V0IjozLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NDMuMCwibWluX29mZnNldF92YWx1ZSI6LTguMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NC4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjUuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo0LjAsImRlbGF5X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yMC4wLCJvZmZzZXRfcmlnaHQiOjQwLjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6My4wLCJkZWxheV81IjoxMC4wLCJkZWxheV82Ijo1LjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0Ijo1LjAsIm9mZnNldF9yaWdodCI6Ni4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjI4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjEzLjAsImRlbGF5XzMiOjE4LjAsImRlbGF5XzQiOjYuMCwiZGVsYXlfNSI6MTYuMCwiZGVsYXlfNiI6MTMuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOjIuMCwibW9kaWZpZXJfMiI6LTQzLjAsIm1vZGlmaWVyXzMiOjE1LjAsIm1vZGlmaWVyXzQiOjI1LjAsIm1vZGlmaWVyXzUiOi0zNy4wLCJtb2RpZmllcl82IjotNy4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6OC4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotMTAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6Ni4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjoyMi4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6MS4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6IlJhbmRvbSIsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjUuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjAuMCwib2Zmc2V0X3JpZ2h0IjozNi4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MS4wLCJkZWxheV81Ijo1LjAsImRlbGF5XzYiOjMuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjozMi4wLCJtb2RpZmllcl8yIjotMTQuMCwibW9kaWZpZXJfMyI6LTQ5LjAsIm1vZGlmaWVyXzQiOi01LjAsIm1vZGlmaWVyXzUiOjI2LjAsIm1vZGlmaWVyXzYiOjI3LjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjUuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjAuMCwib2Zmc2V0X3JpZ2h0IjozNi4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRlZmF1bHQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6MTYuMCwiZGVsYXlfMiI6MTIuMCwiZGVsYXlfMyI6Ni4wLCJkZWxheV80IjoxMS4wLCJkZWxheV81Ijo5LjAsImRlbGF5XzYiOjMuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOi0xOC4wLCJtb2RpZmllcl8yIjozMy4wLCJtb2RpZmllcl8zIjotMzIuMCwibW9kaWZpZXJfNCI6MzcuMCwibW9kaWZpZXJfNSI6MTEuMCwibW9kaWZpZXJfNiI6LTQyLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOi00LjAsIm1pbl9vZmZzZXRfdmFsdWUiOjQuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6Ny4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoxNi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6MjAuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19XV0seyJhZGRvbnMiOlsiRGlzYWJsZSBmb290IHNoYWRvd3MiLCJEaXNhYmxlIHVzZSBvcGVucyBidXkgbWVudSIsIkNsZWFyIGNvbnNvbGUgb24gcm91bmQgc3RhcnQiLCJ+Il0sImFsbG93X2xlYW5pbmdfd2hpbGVfc3RhbmRpbmciOmZhbHNlLCJhcnJvd3NfYWNjZW50IjoiI0ZGMDAwMEZGIiwiYXJyb3dzX2ZvbnQiOiJEZWZhdWx0IiwiYXJyb3dzX2ZvcndhcmQiOiJeIiwiYXJyb3dzX2xlZnQiOiI8IiwiYXJyb3dzX3JpZ2h0IjoiPiIsImFzcGVjdHJhdGlvIjp7InNjYWxlIjoxMzMuMH0sImNsYW5fdGFnIjpmYWxzZSwiY3VzdG9tX2Zha2VkdWNrIjp0cnVlLCJjdXN0b21fc2NvcGUiOnRydWUsImRhbWFnZV9pbmRpY2F0b3IiOnRydWUsImVhcnRocXVha2UiOmZhbHNlLCJmYWxsaW5nIjowLjAsImZhc3RfbGFkZGVyIjpmYWxzZSwiZm9yY2VfdGVhbWFpbWJvdCI6ZmFsc2UsImZyZWV6ZXRpbWVfZmFrZWR1Y2siOnRydWUsImhpdG1hcmtlcnMiOlsiU2NyZWVuIDJEIiwiV29ybGQgM0QiLCJ+Il0sImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJsZWFuaW5nIjoxMDAuMCwibG9nX2V2ZW50cyI6eyJkYW1hZ2VfZGVhbHQiOnRydWUsIm1haW5fYWNjZW50IjoiI0ZGRkZGRkZGIiwicHJlZml4Ijoic25hcHNob3QiLCJwcmVmaXhfYWNjZW50IjoiI0ZGRkZGRkZGIiwicHVyY2hhc2VzIjp0cnVlfSwibWFudWFsX2Fycm93cyI6dHJ1ZSwibmlja25hbWUiOiJXaWUgV2lycyBNYWNoZW4iLCJub19mYWxsX2RhbWFnZSI6dHJ1ZSwic2NyZWVuX2NvbG9yIjoiI0ZGRkZGRkZGIiwic2NyZWVuX2R1cmF0aW9uIjo3LjAsInVubG9ja19mYWtlbGF0ZW5jeSI6dHJ1ZSwidmlld21vZGVsIjp7ImF4aXNfeCI6LTQzLjAsImF4aXNfeSI6LTcuMCwiYXhpc196IjotMTEuMCwiZm92Ijo2OC4wLCJsZWZ0X2hhbmQiOmZhbHNlLCJtYWluX2hhbmQiOiJMZWZ0IiwicmlnaHRfaGFuZCI6ZmFsc2V9LCJ3YWxraW5nIjowLjAsIndhbGtpbmdfZGlyIjowLjAsIndhbGtpbmdfZGlyXzIiOjQ5LjAsIndvcmxkX2NvbG9yIjpbIlNpbXBsZSIsIiNGRkZGRkY5QiIsIn4iXSwifmN1c3RvbV9mYWtlZHVjayI6eyJzY2FsZSI6MTUwLjB9LCJ+Y3VzdG9tX3Njb3BlIjp7ImVkZ2VfYWNjZW50IjoiIzAwMDAwMEZGIiwiZ2FwIjoxMC4wLCJtYWluX2FjY2VudCI6IiNGRkZGRkZBMCIsInJvdGF0ZWQiOmZhbHNlLCJzaXplIjoxNTAuMH0sIn5rZWVwX21vZGVsX3RyYW5zcGFyZW5jeSI6eyJzY2FsZSI6MTAuMH19XQ==";
        end;
        if not v33.database[l_pui_0.string("\v\226\128\162  \rSnappy  [2]  \v\226\156\166  \aFFFFFF40New!\r")] or #v33.database == 0 then
            v33.database[l_pui_0.string("\v\226\128\162  \rSnappy  [2]  \v\226\156\166  \aFFFFFF40New!\r")] = "W3siYWJvdXQiOjIuMCwiYWN0aXZlX3NjcmlwdHMiOjEuMCwicHJlc2V0X2lucHV0IjoiXHUwMDA3e0xpbmsgQWN0aXZlfeKAoiAgXHUwMDA3REVGQVVMVFNuYXBweSAgWzJdICBcdTAwMDd7TGluayBBY3RpdmV94pymICBcdTAwMDdGRkZGRkY0ME5ldyFcdTAwMDdERUZBVUxUIiwicHJlc2V0X2xpc3QiOjcuMCwicHJvZ3Jlc3NfdmVyc2lvbl9iYXIiOjEuMCwid2F0ZXJtYXJrX29wdGlvbnMiOnsiZm9udCI6IkRlZmF1bHQiLCJmb250X25hbWUiOiJTZWdvZSBVSSIsImZvbnRfc2l6ZSI6MTUuMCwiZ3JhZGllbnRfaHVlIjowLjAsImdyYWRpZW50X3JhaW5ib3ciOmZhbHNlLCJncmFkaWVudF9zYXR1cmF0aW9uIjowLjAsImdyYWRpZW50X3NwZWVkIjoxLjAsImdyYWRpZW50X3N3aXRjaCI6ZmFsc2UsImxhYmVsIjoibT1kZXN5bmMgcG9zdD0ubWF4IiwibWFpbl9hY2NlbnQiOiIjRkZGRkZGNUUiLCJtYXN0ZXIiOjAuMCwicG9zX3giOjEyODAuMCwicG9zX3kiOjE0MjAuMCwicG9zdGZpeF9hY2NlbnQiOiIjRkZGRkZGRkYiLCJwcmVmaXhfYWNjZW50IjoiI0NCQ0JGNkZGIn19LHsiZGlzYWJsZV9sY19ncmVuYWRlIjpmYWxzZSwiZm9yY2VfYnJlYWtfbGMiOlsiXHUwMDA3e0xpbmsgQWN0aXZlfe+VlCAgICAgXHUwMDA3REVGQVVMVFNsb3dpbmciLCJcdTAwMDd7TGluayBBY3RpdmV974aTICAgXHUwMDA3REVGQVVMVENyb3VjaGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhyAgXHUwMDA3REVGQVVMVEFpciBDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97pOBICAgXHUwMDA3REVGQVVMVEZyZWVzdGFuZGluZyIsIn4iXSwiZnJlZXN0YW5kaW5nIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2FsbG93ZWQiOnRydWUsImhpZGVfc2hvdHMiOiJCcmVhayBMQyIsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsIm9wdGlvbnNfdGFibGUiOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImZha2VfbGFnIjpmYWxzZSwiZmFrZV9sYWdfdHlwZSI6IkFsd2F5cyBvbiIsInNhZmVfaGVhZCI6WyJcdTAwMDd7TGluayBBY3RpdmV974aDICAgICBcdTAwMDdERUZBVUxUU3RhbmRpbmciLCJcdTAwMDd7TGluayBBY3RpdmV974aTICAgXHUwMDA3REVGQVVMVENyb3VjaGluZyAgXHUwMDA3QkFCRDVCRkYrICBcdTAwMDd7TGluayBBY3RpdmV97ouOICBcdTAwMDdERUZBVUxUU25lYWtpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyAgXHUwMDA3QkFCRDVCRkYrICBcdTAwMDdERUZBVUxUS25pZmUvVGFzZXIiLCJ+Il0sInR3ZWFrcyI6WyJ+Il0sInR3ZWFrc19sZWZ0X29mZnNldCI6LTMwLjAsInR3ZWFrc19waXRjaCI6IkRpc2FibGVkIiwidHdlYWtzX3JhbmdlIjoxODAuMCwidHdlYWtzX3JpZ2h0X29mZnNldCI6MzAuMCwidHdlYWtzX3NwZWVkIjo1LjAsInR3ZWFrc195YXdfdHlwZSI6IlNwaW4ifSwic3RhdGVzIjo1LjAsInRlYW1zIjoxLjAsInlhd19nZWFyIjowLjAsIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcyI6ZmFsc2UsImRpc2FibGVycyI6WyJ+Il19LCJ+bWFudWFsX3lhdyI6eyJib2R5X3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sImZyZWVzdGFuZGluZyI6IkRlZmF1bHQiLCJzaWRlIjpmYWxzZX19LFtbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NjAuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIwLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MC4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjowLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOZXZlcmxvc2UiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjMuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwib2Zmc2V0X2xlZnQiOi0xNi4wLCJvZmZzZXRfcmlnaHQiOjMzLjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6MjAuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MTIuMCwiZGVsYXlfNSI6MTIuMCwiZGVsYXlfNiI6MTUuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6LTQwLjAsIm1vZGlmaWVyXzQiOjUuMCwibW9kaWZpZXJfNSI6MTYuMCwibW9kaWZpZXJfNiI6MzAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6NC4wLCJkZWxheV8zIjoxLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJtb2RpZmllcl8xIjotMS4wLCJtb2RpZmllcl8yIjotMy4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOi0zLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0xLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjUuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOZXZlcmxvc2UiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo0LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjMuMCwiZGVsYXlfdHlwZSI6IldheXMiLCJtYXN0ZXIiOjAuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjM3LjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6NC4wLCJkZWxheV8zIjozLjAsImRlbGF5XzQiOjE4LjAsImRlbGF5XzUiOjEuMCwiZGVsYXlfNiI6MTYuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjotMS4wLCJtb2RpZmllcl8yIjotMy4wLCJtb2RpZmllcl8zIjo0OS4wLCJtb2RpZmllcl80IjozNS4wLCJtb2RpZmllcl81Ijo0My4wLCJtb2RpZmllcl82IjotMjIuMCwibW9kaWZpZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTMuMCwibWluX29mZnNldF92YWx1ZSI6LTEuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjQuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0IjozNy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6MjAuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIwLjAsImRlbGF5XzMiOjExLjAsImRlbGF5XzQiOjguMCwiZGVsYXlfNSI6MTIuMCwiZGVsYXlfNiI6MTEuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MTEuMCwibW9kaWZpZXJfNCI6LTMzLjAsIm1vZGlmaWVyXzUiOi0yOS4wLCJtb2RpZmllcl82IjozMy4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE1LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19XSxbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjQ4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjUuMCwiZGVsYXlfMiI6MTAuMCwiZGVsYXlfMyI6OC4wLCJkZWxheV80IjoxNC4wLCJkZWxheV81IjoxMC4wLCJkZWxheV82IjoxMi4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOi0zMy4wLCJtb2RpZmllcl8yIjo0NC4wLCJtb2RpZmllcl8zIjotNy4wLCJtb2RpZmllcl80IjotMTMuMCwibW9kaWZpZXJfNSI6Ny4wLCJtb2RpZmllcl82IjoxLjAsIm1vZGlmaWVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQ0LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0zMy4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo2LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6Mi4wLCJ0aWNrYmFzZV8yIjoyMi4wLCJ0aWNrYmFzZV8zIjo4LjAsInRpY2tiYXNlXzQiOjIyLjAsInRpY2tiYXNlXzUiOjYuMCwidGlja2Jhc2VfNiI6My4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjYuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Ni4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0Ijo0Mi4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjQ4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjUuMCwiZGVsYXlfMiI6MTAuMCwiZGVsYXlfMyI6Ny4wLCJkZWxheV80IjoxMS4wLCJkZWxheV81Ijo1LjAsImRlbGF5XzYiOjE0LjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTMzLjAsIm1vZGlmaWVyXzIiOjQ0LjAsIm1vZGlmaWVyXzMiOi03LjAsIm1vZGlmaWVyXzQiOi0xMy4wLCJtb2RpZmllcl81Ijo3LjAsIm1vZGlmaWVyXzYiOjEuMCwibW9kaWZpZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NDQuMCwibWluX29mZnNldF92YWx1ZSI6LTMzLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjYuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoyLjAsInRpY2tiYXNlXzIiOjIyLjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo2LjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjQyLjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjMuMCwiZGVsYXlfMyI6My4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEzLjAsImRlbGF5XzYiOjE5LjAsIm1vZGlmaWVyIjoiU3BpbiIsIm1vZGlmaWVyXzEiOi01LjAsIm1vZGlmaWVyXzIiOjUuMCwibW9kaWZpZXJfMyI6LTUuMCwibW9kaWZpZXJfNCI6MTUuMCwibW9kaWZpZXJfNSI6MzYuMCwibW9kaWZpZXJfNiI6LTMzLjAsIm1vZGlmaWVyX29mZnNldCI6NS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjUuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NC4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjIuMCwidGlja2Jhc2VfMiI6MjIuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjMuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Ni4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMTUuMCwib2Zmc2V0X3JpZ2h0IjozNS4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6My4wLCJkZWxheV8zIjozLjAsImRlbGF5XzQiOjguMCwiZGVsYXlfNSI6MTMuMCwiZGVsYXlfNiI6MTkuMCwibW9kaWZpZXIiOiJTcGluIiwibW9kaWZpZXJfMSI6LTUuMCwibW9kaWZpZXJfMiI6NS4wLCJtb2RpZmllcl8zIjotNS4wLCJtb2RpZmllcl80IjoxNS4wLCJtb2RpZmllcl81IjozNi4wLCJtb2RpZmllcl82IjotMzMuMCwibW9kaWZpZXJfb2Zmc2V0Ijo1LjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NS4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotNS4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo0LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6Mi4wLCJ0aWNrYmFzZV8yIjoyMi4wLCJ0aWNrYmFzZV8zIjoxNS4wLCJ0aWNrYmFzZV80IjoxNS4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6My4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjUuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo2LjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0xNS4wLCJvZmZzZXRfcmlnaHQiOjM1LjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyMC4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjMuMCwiZGVsYXlfNSI6MTAuMCwiZGVsYXlfNiI6NS4wLCJtb2RpZmllciI6IkRpc2FibGVkIiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiV2F5cyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6LTIyLjAsIm9mZnNldF9yaWdodCI6MzMuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyMC4wLCJkZWxheV8zIjoxOC4wLCJkZWxheV80Ijo2LjAsImRlbGF5XzUiOjE2LjAsImRlbGF5XzYiOjEzLjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MTUuMCwibW9kaWZpZXJfNCI6MjUuMCwibW9kaWZpZXJfNSI6LTM3LjAsIm1vZGlmaWVyXzYiOi03LjAsIm1vZGlmaWVyX29mZnNldCI6LTEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjIuMCwidGlja2Jhc2VfMiI6MjIuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMzMuMCwib2Zmc2V0X3JpZ2h0IjoyNy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6NC4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOi0yLjAsIm1vZGlmaWVyXzIiOjUuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjo1LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0yLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoyLjAsInRpY2tiYXNlXzIiOjIyLjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo0LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTI3LjAsIm9mZnNldF9yaWdodCI6MzguMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyMC4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6IkRpc2FibGVkIiwibW9kaWZpZXJfMSI6LTEuMCwibW9kaWZpZXJfMiI6MS4wLCJtb2RpZmllcl8zIjotNDkuMCwibW9kaWZpZXJfNCI6LTUuMCwibW9kaWZpZXJfNSI6MjYuMCwibW9kaWZpZXJfNiI6MjcuMCwibW9kaWZpZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MS4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotMS4wLCJyYW5kb21pemUiOnRydWUsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOZXZlcmxvc2UiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNS4wLCJ0aWNrYmFzZV81IjoxNS4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0Ijo0MC4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEZWZhdWx0IiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NjAuMCwibGltaXRfbWluIjowLjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxNi4wLCJkZWxheV8yIjo3LjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOjQuMCwibW9kaWZpZXJfMiI6LTQuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTQuMCwibWluX29mZnNldF92YWx1ZSI6NC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6Ny4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoxNi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6MjAuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MjIuMCwib2Zmc2V0X3JpZ2h0IjowLjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEZWZhdWx0IiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NjAuMCwibGltaXRfbWluIjowLjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxNi4wLCJkZWxheV8yIjo3LjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOjQuMCwibW9kaWZpZXJfMiI6LTQuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTQuMCwibWluX29mZnNldF92YWx1ZSI6NC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6Ny4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoxNi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6MjAuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MjIuMCwib2Zmc2V0X3JpZ2h0IjowLjB9fV1dLHsiYWRkb25zIjpbIkRpc2FibGUgZm9vdCBzaGFkb3dzIiwiRGlzYWJsZSB1c2Ugb3BlbnMgYnV5IG1lbnUiLCJDbGVhciBjb25zb2xlIG9uIHJvdW5kIHN0YXJ0IiwifiJdLCJhbGxvd19sZWFuaW5nX3doaWxlX3N0YW5kaW5nIjpmYWxzZSwiYXJyb3dzX2FjY2VudCI6IiNCN0JDRTNFNCIsImFycm93c19mb250IjoiRGVmYXVsdCIsImFycm93c19mb3J3YXJkIjoiXiIsImFycm93c19sZWZ0IjoiPCIsImFycm93c19yaWdodCI6Ij4iLCJhc3BlY3RyYXRpbyI6eyJzY2FsZSI6MTI1LjB9LCJjbGFuX3RhZyI6ZmFsc2UsImN1c3RvbV9mYWtlZHVjayI6dHJ1ZSwiY3VzdG9tX3Njb3BlIjp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJlYXJ0aHF1YWtlIjpmYWxzZSwiZmFsbGluZyI6MC4wLCJmYXN0X2xhZGRlciI6dHJ1ZSwiZm9yY2VfdGVhbWFpbWJvdCI6ZmFsc2UsImZyZWV6ZXRpbWVfZmFrZWR1Y2siOnRydWUsImhpdG1hcmtlcnMiOlsiU2NyZWVuIDJEIiwiV29ybGQgM0QiLCJ+Il0sImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJsZWFuaW5nIjowLjAsImxvZ19ldmVudHMiOnsiZGFtYWdlX2RlYWx0Ijp0cnVlLCJtYWluX2FjY2VudCI6IiNGRkZGRkZGRiIsInByZWZpeCI6Im5wIiwicHJlZml4X2FjY2VudCI6IiNGRkZGRkZGRiIsInB1cmNoYXNlcyI6dHJ1ZX0sIm1hbnVhbF9hcnJvd3MiOnRydWUsIm5pY2tuYW1lIjoiV2llIFdpcnMgTWFjaGVuIiwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInNjcmVlbl9jb2xvciI6IiNGRkZGRkZGRiIsInNjcmVlbl9kdXJhdGlvbiI6Ny4wLCJ1bmxvY2tfZmFrZWxhdGVuY3kiOnRydWUsInZpZXdtb2RlbCI6eyJheGlzX3giOi0yMC4wLCJheGlzX3kiOi0zOC4wLCJheGlzX3oiOjIuMCwiZm92Ijo2Ni4wLCJsZWZ0X2hhbmQiOmZhbHNlLCJtYWluX2hhbmQiOiJMZWZ0IiwicmlnaHRfaGFuZCI6ZmFsc2V9LCJ3YWxraW5nIjowLjAsIndhbGtpbmdfZGlyIjo1MC4wLCJ3YWxraW5nX2Rpcl8yIjowLjAsIndvcmxkX2NvbG9yIjpbIlNpbXBsZSIsIiNGRkZGRkY5QiIsIn4iXSwifmN1c3RvbV9mYWtlZHVjayI6eyJzY2FsZSI6MTUwLjB9LCJ+Y3VzdG9tX3Njb3BlIjp7ImVkZ2VfYWNjZW50IjoiI0ZGRkZGRjAwIiwiZ2FwIjoxMC4wLCJtYWluX2FjY2VudCI6IiNGRkZGRkY4RiIsInJvdGF0ZWQiOmZhbHNlLCJzaXplIjozMDAuMH0sIn5rZWVwX21vZGVsX3RyYW5zcGFyZW5jeSI6eyJzY2FsZSI6MTAuMH19XQ==";
        end;
        if not v33.database[l_pui_0.string("\v\226\128\162  \rDelayed")] or #v33.database == 0 then
            v33.database[l_pui_0.string("\v\226\128\162  \rDelayed")] = "W3siYWJvdXQiOjIuMCwiYWN0aXZlX3NjcmlwdHMiOjEuMCwicHJlc2V0X2lucHV0IjoiXHUwMDA3e0xpbmsgQWN0aXZlfeKAoiAgXHUwMDA3REVGQVVMVERlbGF5ZWQiLCJwcmVzZXRfbGlzdCI6Ni4wLCJwcm9ncmVzc192ZXJzaW9uX2JhciI6NjAuMCwid2F0ZXJtYXJrX29wdGlvbnMiOnsiZm9udCI6IkRlZmF1bHQiLCJmb250X25hbWUiOiJTZWdvZSBVSSIsImZvbnRfc2l6ZSI6MTUuMCwiZ3JhZGllbnRfaHVlIjowLjAsImdyYWRpZW50X3JhaW5ib3ciOmZhbHNlLCJncmFkaWVudF9zYXR1cmF0aW9uIjo1LjAsImdyYWRpZW50X3NwZWVkIjoyLjAsImdyYWRpZW50X3N3aXRjaCI6ZmFsc2UsImxhYmVsIjoiTEVHQUNZLkRFU1lOQyIsIm1haW5fYWNjZW50IjoiI0ZGRkZGRkZGIiwibWFzdGVyIjowLjAsInBvc194Ijo5NjAuMCwicG9zX3kiOjEwNjAuMCwicG9zdGZpeF9hY2NlbnQiOiIjRUI2MTYxRkYiLCJwcmVmaXhfYWNjZW50IjoiIzk2QzgzQ0ZGIn19LHsiZGlzYWJsZV9sY19ncmVuYWRlIjpmYWxzZSwiZm9yY2VfYnJlYWtfbGMiOlsiXHUwMDA3e0xpbmsgQWN0aXZlfe+GgyAgICAgXHUwMDA3REVGQVVMVFN0YW5kaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+cjCAgICBcdTAwMDdERUZBVUxUUnVubmluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97ouOICAgIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYYgICAgXHUwMDA3REVGQVVMVEFpciIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciLCJ+Il0sImZyZWVzdGFuZGluZyI6ZmFsc2UsImZyZWVzdGFuZGluZ19hbGxvd2VkIjp0cnVlLCJoaWRlX3Nob3RzIjoiQnJlYWsgTEMiLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJvcHRpb25zX3RhYmxlIjp7ImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJmYWtlX2xhZyI6ZmFsc2UsImZha2VfbGFnX3R5cGUiOiJBbHdheXMgb24iLCJzYWZlX2hlYWQiOlsiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmcgIFx1MDAwN0JBQkQ1QkZGKyAgXHUwMDA3e0xpbmsgQWN0aXZlfe6LjiAgXHUwMDA3REVGQVVMVFNuZWFraW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhyAgXHUwMDA3REVGQVVMVEFpciBDcm91Y2hpbmcgIFx1MDAwN0JBQkQ1QkZGKyAgXHUwMDA3REVGQVVMVEtuaWZlL1Rhc2VyIiwifiJdLCJ0d2Vha3MiOlsifiJdLCJ0d2Vha3NfbGVmdF9vZmZzZXQiOi0zMC4wLCJ0d2Vha3NfcGl0Y2giOiJEaXNhYmxlZCIsInR3ZWFrc19yYW5nZSI6MTgwLjAsInR3ZWFrc19yaWdodF9vZmZzZXQiOjMwLjAsInR3ZWFrc19zcGVlZCI6Mi4wLCJ0d2Vha3NfeWF3X3R5cGUiOiJTcGluIn0sInN0YXRlcyI6Ny4wLCJ0ZWFtcyI6Mi4wLCJ5YXdfZ2VhciI6Ny4wLCJ+ZnJlZXN0YW5kaW5nIjp7ImJvZHlfZnMiOnRydWV9fSxbW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiVGlja3MiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjoxNS4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MC4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjowLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6Ny4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOmZhbHNlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjYuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Ni4wLCJkZWxheV90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NjAuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjI4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJUaWNrcyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjE1LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MTIuMCwiZGVsYXlfNSI6MTIuMCwiZGVsYXlfNiI6MTUuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjotNC4wLCJtb2RpZmllcl8yIjotMzcuMCwibW9kaWZpZXJfMyI6LTQwLjAsIm1vZGlmaWVyXzQiOjUuMCwibW9kaWZpZXJfNSI6MTYuMCwibW9kaWZpZXJfNiI6MzAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo2LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTE2LjAsIm9mZnNldF9yaWdodCI6MzMuMH19XSxbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjI4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJSYW5kb20iLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6OC4wLCJkZWxheV8yIjoxMi4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxOC4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTMuMCwibWluX29mZnNldF92YWx1ZSI6LTEuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjguMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo0LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiV2F5cyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTI3LjAsIm9mZnNldF9yaWdodCI6MzcuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiUmFuZG9tIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjguMCwiZGVsYXlfMiI6MTIuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MTguMCwiZGVsYXlfNSI6MS4wLCJkZWxheV82IjoxNi4wLCJtb2RpZmllciI6IlJhbmRvbSIsIm1vZGlmaWVyXzEiOi0xMy4wLCJtb2RpZmllcl8yIjoyOC4wLCJtb2RpZmllcl8zIjo0OS4wLCJtb2RpZmllcl80IjozNS4wLCJtb2RpZmllcl81Ijo0My4wLCJtb2RpZmllcl82IjotMjIuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOi0zLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0xLjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6OC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjQuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0IjozNy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NDguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlRpY2tzIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Ni4wLCJkZWxheV8zIjoxNC4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEzLjAsImRlbGF5XzYiOjEwLjAsIm1vZGlmaWVyIjoiNS1XYXkiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjotMTEuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IldheXMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjQ5LjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NDguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlRpY2tzIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Ni4wLCJkZWxheV8zIjoxNC4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEzLjAsImRlbGF5XzYiOjEwLjAsIm1vZGlmaWVyIjoiNS1XYXkiLCJtb2RpZmllcl8xIjotMjkuMCwibW9kaWZpZXJfMiI6MzQuMCwibW9kaWZpZXJfMyI6MTEuMCwibW9kaWZpZXJfNCI6LTMzLjAsIm1vZGlmaWVyXzUiOi0yOS4wLCJtb2RpZmllcl82IjozMy4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjotMTEuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IldheXMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjQ5LjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo0OC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiVGlja3MiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjIwLjAsImRlbGF5XzIiOjEzLjAsImRlbGF5XzMiOjguMCwiZGVsYXlfNCI6MTQuMCwiZGVsYXlfNSI6MTAuMCwiZGVsYXlfNiI6MTIuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjotMjAuMCwibW9kaWZpZXJfMiI6LTEzLjAsIm1vZGlmaWVyXzMiOi03LjAsIm1vZGlmaWVyXzQiOi0xMy4wLCJtb2RpZmllcl81Ijo3LjAsIm1vZGlmaWVyXzYiOjEuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQ0LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0zMy4wLCJyYW5kb21pemUiOnRydWUsInNsaWRlcnMiOjYuMCwidHlwZSI6IldheXMifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoyLjAsInRpY2tiYXNlXzIiOjUuMCwidGlja2Jhc2VfMyI6OC4wLCJ0aWNrYmFzZV80IjoyMi4wLCJ0aWNrYmFzZV81Ijo2LjAsInRpY2tiYXNlXzYiOjMuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjo2LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjEwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTI3LjAsIm9mZnNldF9yaWdodCI6NDIuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo0OC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiUmFuZG9tIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjoxOS4wLCJkZWxheV8yIjoyMC4wLCJkZWxheV8zIjo3LjAsImRlbGF5XzQiOjExLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6MTQuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjotMjAuMCwibW9kaWZpZXJfMiI6LTEzLjAsIm1vZGlmaWVyXzMiOi03LjAsIm1vZGlmaWVyXzQiOi0xMy4wLCJtb2RpZmllcl81Ijo3LjAsIm1vZGlmaWVyXzYiOjEuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQ0LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0zMy4wLCJyYW5kb21pemUiOnRydWUsInNsaWRlcnMiOjYuMCwidHlwZSI6IldheXMifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6Ni4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Ni4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0Ijo0Mi4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OS4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTkuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjoxNi4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjoxNi4wfSwiZGVsYXlfMSI6MjAuMCwiZGVsYXlfMiI6MTQuMCwiZGVsYXlfMyI6My4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEzLjAsImRlbGF5XzYiOjE5LjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTQ1LjAsIm1vZGlmaWVyXzIiOjExLjAsIm1vZGlmaWVyXzMiOi01LjAsIm1vZGlmaWVyXzQiOjE1LjAsIm1vZGlmaWVyXzUiOjM2LjAsIm1vZGlmaWVyXzYiOi0zMy4wLCJtb2RpZmllcl9vZmZzZXQiOjMuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjo0My4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotOC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo0LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjEwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6NS4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjQuMCwiZGVsYXlfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTIwLjAsIm9mZnNldF9yaWdodCI6NDAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjo1LjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MTYuMCwiZGVsYXlfNCI6NC4wLCJkZWxheV81IjoxOS4wLCJkZWxheV82IjoxMy4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOi0xOS4wLCJtb2RpZmllcl8yIjo4LjAsIm1vZGlmaWVyXzMiOjQ5LjAsIm1vZGlmaWVyXzQiOi0xNy4wLCJtb2RpZmllcl81IjotMTguMCwibW9kaWZpZXJfNiI6LTI3LjAsIm1vZGlmaWVyX29mZnNldCI6My4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQzLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi04LjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjQuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNS4wLCJ0aWNrYmFzZV80IjoxNS4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NS4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6NC4wLCJkZWxheV90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjAuMCwib2Zmc2V0X3JpZ2h0Ijo0MC4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OS4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTkuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjMuMCwiZGVsYXlfNSI6MTAuMCwiZGVsYXlfNiI6NS4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6LTEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo2LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6LTE2LjAsIm9mZnNldF9yaWdodCI6MzguMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoxMy4wLCJkZWxheV8zIjoxOC4wLCJkZWxheV80Ijo2LjAsImRlbGF5XzUiOjE2LjAsImRlbGF5XzYiOjEzLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6Mi4wLCJtb2RpZmllcl8yIjotNDMuMCwibW9kaWZpZXJfMyI6MTUuMCwibW9kaWZpZXJfNCI6MjUuMCwibW9kaWZpZXJfNSI6LTM3LjAsIm1vZGlmaWVyXzYiOi03LjAsIm1vZGlmaWVyX29mZnNldCI6LTEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo2LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTE2LjAsIm9mZnNldF9yaWdodCI6MzguMH19XSxbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MS4wLCJkZWxheV81Ijo1LjAsImRlbGF5XzYiOjMuMCwibW9kaWZpZXIiOiJSYW5kb20iLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjo1LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi01LjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik55YW56YSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxNi4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo0LjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yMC4wLCJvZmZzZXRfcmlnaHQiOjM2LjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6MS4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6IlJhbmRvbSIsIm1vZGlmaWVyXzEiOjMyLjAsIm1vZGlmaWVyXzIiOi0xNC4wLCJtb2RpZmllcl8zIjotNDkuMCwibW9kaWZpZXJfNCI6LTUuMCwibW9kaWZpZXJfNSI6MjYuMCwibW9kaWZpZXJfNiI6MjcuMCwibW9kaWZpZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NS4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotNS4wLCJyYW5kb21pemUiOnRydWUsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNS4wLCJ0aWNrYmFzZV81IjoxNS4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MTYuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6NC4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiUmFuZG9tIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjotMjAuMCwib2Zmc2V0X3JpZ2h0IjozNi4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRlZmF1bHQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6MTYuMCwiZGVsYXlfMiI6MTIuMCwiZGVsYXlfMyI6Ni4wLCJkZWxheV80IjoxMS4wLCJkZWxheV81Ijo5LjAsImRlbGF5XzYiOjMuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOi0xOC4wLCJtb2RpZmllcl8yIjozMy4wLCJtb2RpZmllcl8zIjotMzIuMCwibW9kaWZpZXJfNCI6MzcuMCwibW9kaWZpZXJfNSI6MTEuMCwibW9kaWZpZXJfNiI6LTQyLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOi00LjAsIm1pbl9vZmZzZXRfdmFsdWUiOjQuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6dHJ1ZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6Ny4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoxNi4wLCJkZWxheV9zbGlkZXJzIjo1LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6MjAuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19XV0seyJhZGRvbnMiOlsiRGlzYWJsZSBmb290IHNoYWRvd3MiLCJEaXNhYmxlIHVzZSBvcGVucyBidXkgbWVudSIsIk5vIHNsZWV2ZXMiLCJDbGVhciBjb25zb2xlIG9uIHJvdW5kIHN0YXJ0IiwifiJdLCJhbGxvd19sZWFuaW5nX3doaWxlX3N0YW5kaW5nIjpmYWxzZSwiYXJyb3dzX2FjY2VudCI6IiNGRjAwMDBGRiIsImFycm93c19mb250IjoiRGVmYXVsdCIsImFycm93c19mb3J3YXJkIjoiXiIsImFycm93c19sZWZ0IjoiPCIsImFycm93c19yaWdodCI6Ij4iLCJhc3BlY3RyYXRpbyI6eyJzY2FsZSI6MTMzLjB9LCJjbGFuX3RhZyI6ZmFsc2UsImN1c3RvbV9mYWtlZHVjayI6dHJ1ZSwiY3VzdG9tX3Njb3BlIjp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJlYXJ0aHF1YWtlIjpmYWxzZSwiZmFsbGluZyI6MC4wLCJmYXN0X2xhZGRlciI6dHJ1ZSwiZm9yY2VfdGVhbWFpbWJvdCI6ZmFsc2UsImZyZWV6ZXRpbWVfZmFrZWR1Y2siOnRydWUsImhpdG1hcmtlcnMiOlsiU2NyZWVuIDJEIiwiV29ybGQgM0QiLCJ+Il0sImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJsZWFuaW5nIjoxMDAuMCwibG9nX2V2ZW50cyI6eyJkYW1hZ2VfZGVhbHQiOnRydWUsIm1haW5fYWNjZW50IjoiI0ZGRkZGRkZGIiwicHJlZml4Ijoic25hcHNob3QiLCJwcmVmaXhfYWNjZW50IjoiI0ZGRkZGRkZGIiwicHVyY2hhc2VzIjp0cnVlfSwibWFudWFsX2Fycm93cyI6dHJ1ZSwibmlja25hbWUiOiJXaWUgV2lycyBNYWNoZW4iLCJub19mYWxsX2RhbWFnZSI6dHJ1ZSwic2NyZWVuX2NvbG9yIjoiI0ZGRkZGRkZGIiwic2NyZWVuX2R1cmF0aW9uIjo3LjAsInVubG9ja19mYWtlbGF0ZW5jeSI6dHJ1ZSwidmlld21vZGVsIjp7ImF4aXNfeCI6LTQzLjAsImF4aXNfeSI6LTcuMCwiYXhpc196IjotMTEuMCwiZm92Ijo2OC4wLCJsZWZ0X2hhbmQiOmZhbHNlLCJtYWluX2hhbmQiOiJMZWZ0IiwicmlnaHRfaGFuZCI6ZmFsc2V9LCJ3YWxraW5nIjoyLjAsIndhbGtpbmdfZGlyIjowLjAsIndhbGtpbmdfZGlyXzIiOjQ5LjAsIndvcmxkX2NvbG9yIjpbIlNpbXBsZSIsIiNGRkZGRkY5QiIsIn4iXSwifmN1c3RvbV9mYWtlZHVjayI6eyJzY2FsZSI6MTUwLjB9LCJ+Y3VzdG9tX3Njb3BlIjp7ImVkZ2VfYWNjZW50IjoiIzAwMDAwMDAwIiwiZ2FwIjoxMC4wLCJtYWluX2FjY2VudCI6IiNGRkZGRkZGRiIsInJvdGF0ZWQiOnRydWUsInNpemUiOjE1MC4wfSwifmtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp7InNjYWxlIjoxMC4wfX1d";
        end;
        if not v33.database[l_pui_0.string("\v\226\128\162  \rAggressive")] or #v33.database == 0 then
            v33.database[l_pui_0.string("\v\226\128\162  \rAggressive")] = "W3siYWJvdXQiOjIuMCwiYWN0aXZlX3NjcmlwdHMiOjEuMCwicHJlc2V0X2lucHV0IjoiXHUwMDA3e0xpbmsgQWN0aXZlfeKAoiAgXHUwMDA3REVGQVVMVFNuYXBweSAgXHUwMDA3e0xpbmsgQWN0aXZlfeKcpiIsInByZXNldF9saXN0Ijo2LjAsInByb2dyZXNzX3ZlcnNpb25fYmFyIjoxMy4wLCJ3YXRlcm1hcmtfb3B0aW9ucyI6eyJmb250IjoiRGVmYXVsdCIsImZvbnRfbmFtZSI6IlNlZ29lIFVJIiwiZm9udF9zaXplIjoxNS4wLCJncmFkaWVudF9odWUiOjAuMCwiZ3JhZGllbnRfcmFpbmJvdyI6ZmFsc2UsImdyYWRpZW50X3NhdHVyYXRpb24iOjUuMCwiZ3JhZGllbnRfc3BlZWQiOjIuMCwiZ3JhZGllbnRfc3dpdGNoIjpmYWxzZSwibGFiZWwiOiJwcmU9TCBVIEEgbT0gUyBFIE4gUyBFIHBvc3Q9IFtCRVRBXSIsIm1haW5fYWNjZW50IjoiI0ZGRkZGRkZGIiwibWFzdGVyIjowLjAsInBvc194Ijo2OC4wLCJwb3NfeSI6NTQwLjAsInBvc3RmaXhfYWNjZW50IjoiI0VCNjE2MUZGIiwicHJlZml4X2FjY2VudCI6IiM5NkM4M0NGRiJ9fSx7ImRpc2FibGVfbGNfZ3JlbmFkZSI6ZmFsc2UsImZvcmNlX2JyZWFrX2xjIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97ouOICAgIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciLCJ+Il0sImZyZWVzdGFuZGluZyI6ZmFsc2UsImZyZWVzdGFuZGluZ19hbGxvd2VkIjp0cnVlLCJoaWRlX3Nob3RzIjoiRmF2b3IgRmlyZSBSYXRlIiwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwib3B0aW9uc190YWJsZSI6eyJhdm9pZF9iYWNrc3RhYiI6dHJ1ZSwiZmFrZV9sYWciOmZhbHNlLCJmYWtlX2xhZ190eXBlIjoiQWx3YXlzIG9uIiwic2FmZV9oZWFkIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhoMgICAgIFx1MDAwN0RFRkFVTFRTdGFuZGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nICBcdTAwMDdCQUJENUJGRisgIFx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nICBcdTAwMDdCQUJENUJGRisgIFx1MDAwN0RFRkFVTFRLbmlmZS9UYXNlciIsIn4iXSwidHdlYWtzIjpbIn4iXSwidHdlYWtzX2xlZnRfb2Zmc2V0IjotMzAuMCwidHdlYWtzX3BpdGNoIjoiRGlzYWJsZWQiLCJ0d2Vha3NfcmFuZ2UiOjE4MC4wLCJ0d2Vha3NfcmlnaHRfb2Zmc2V0IjozMC4wLCJ0d2Vha3Nfc3BlZWQiOjIuMCwidHdlYWtzX3lhd190eXBlIjoiU3BpbiJ9LCJzdGF0ZXMiOjguMCwidGVhbXMiOjEuMCwieWF3X2dlYXIiOjMuMCwifmZyZWVzdGFuZGluZyI6eyJib2R5X2ZzIjp0cnVlfX0sW1t7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NjAuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MjAuMCwiZGVsYXlfNCI6MTIuMCwiZGVsYXlfNSI6MTIuMCwiZGVsYXlfNiI6MTUuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjotNC4wLCJtb2RpZmllcl8yIjotMzcuMCwibW9kaWZpZXJfMyI6LTQwLjAsIm1vZGlmaWVyXzQiOjUuMCwibW9kaWZpZXJfNSI6MTYuMCwibW9kaWZpZXJfNiI6MzAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTUuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMTYuMCwib2Zmc2V0X3JpZ2h0IjozMy4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NTguMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjozLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTMuMCwibWluX29mZnNldF92YWx1ZSI6LTEuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6NS4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE1LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjQuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjotMjcuMCwib2Zmc2V0X3JpZ2h0IjozNy4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjI4LjAsImxpbWl0X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6My4wLCJkZWxheV80IjoxOC4wLCJkZWxheV81IjoxLjAsImRlbGF5XzYiOjE2LjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTEzLjAsIm1vZGlmaWVyXzIiOjI4LjAsIm1vZGlmaWVyXzMiOjQ5LjAsIm1vZGlmaWVyXzQiOjM1LjAsIm1vZGlmaWVyXzUiOjQzLjAsIm1vZGlmaWVyXzYiOi0yMi4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjotMy4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotMS4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6NC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjMuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjM3LjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJPZmZzZXQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOjEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6My4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJvZmZzZXRfbGVmdCI6MC4wLCJvZmZzZXRfcmlnaHQiOjAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6My4wLCJkZWxheV8yIjoxMi4wLCJkZWxheV8zIjoxMS4wLCJkZWxheV80Ijo4LjAsImRlbGF5XzUiOjEyLjAsImRlbGF5XzYiOjExLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTI5LjAsIm1vZGlmaWVyXzIiOjM0LjAsIm1vZGlmaWVyXzMiOjExLjAsIm1vZGlmaWVyXzQiOi0zMy4wLCJtb2RpZmllcl81IjotMjkuMCwibW9kaWZpZXJfNiI6MzMuMCwibW9kaWZpZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MC4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjowLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOZXZlcmxvc2UiLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNS4wLCJ0aWNrYmFzZV81IjoxNS4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjMuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjAuMCwib2Zmc2V0X2xlZnQiOjAuMCwib2Zmc2V0X3JpZ2h0IjowLjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo0OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjoyMC4wLCJkZWxheV8yIjoxMy4wLCJkZWxheV8zIjo4LjAsImRlbGF5XzQiOjE0LjAsImRlbGF5XzUiOjEwLjAsImRlbGF5XzYiOjEyLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTIwLjAsIm1vZGlmaWVyXzIiOi0xMy4wLCJtb2RpZmllcl8zIjotNy4wLCJtb2RpZmllcl80IjotMTMuMCwibW9kaWZpZXJfNSI6Ny4wLCJtb2RpZmllcl82IjoxLjAsIm1vZGlmaWVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQ0LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0zMy4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo2LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6Mi4wLCJ0aWNrYmFzZV8yIjo1LjAsInRpY2tiYXNlXzMiOjguMCwidGlja2Jhc2VfNCI6MjIuMCwidGlja2Jhc2VfNSI6Ni4wLCJ0aWNrYmFzZV82IjozLjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6Ni4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo2LjAsImRlbGF5X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yNy4wLCJvZmZzZXRfcmlnaHQiOjQyLjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo1OS4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NDguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NTkuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjoxNi4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjoxNi4wfSwiZGVsYXlfMSI6MTkuMCwiZGVsYXlfMiI6MjAuMCwiZGVsYXlfMyI6Ny4wLCJkZWxheV80IjoxMS4wLCJkZWxheV81Ijo1LjAsImRlbGF5XzYiOjE0LjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6LTIwLjAsIm1vZGlmaWVyXzIiOi0xMy4wLCJtb2RpZmllcl8zIjotNy4wLCJtb2RpZmllcl80IjotMTMuMCwibW9kaWZpZXJfNSI6Ny4wLCJtb2RpZmllcl82IjoxLjAsIm1vZGlmaWVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjQ0LjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0zMy4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo2LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjEwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjYuMCwiZGVsYXlfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTI3LjAsIm9mZnNldF9yaWdodCI6NDIuMH19XSxbeyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGlzYWJsZWQiLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6dHJ1ZSwibGVmdF9saW1pdCI6NTkuMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU5LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6MTYuMCwidHlwZV90aWNrc192YWx1ZSI6MTYuMH0sImRlbGF5XzEiOjIwLjAsImRlbGF5XzIiOjE0LjAsImRlbGF5XzMiOjMuMCwiZGVsYXlfNCI6OC4wLCJkZWxheV81IjoxMy4wLCJkZWxheV82IjoxOS4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOi00NS4wLCJtb2RpZmllcl8yIjoxMS4wLCJtb2RpZmllcl8zIjotNS4wLCJtb2RpZmllcl80IjoxNS4wLCJtb2RpZmllcl81IjozNi4wLCJtb2RpZmllcl82IjotMzMuMCwibW9kaWZpZXJfb2Zmc2V0IjozLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6NS4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjotNS4wLCJyYW5kb21pemUiOnRydWUsInNsaWRlcnMiOjQuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOeWFuemEiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNS4wLCJ0aWNrYmFzZV8zIjoxNS4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNS4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoyLjAsInRpY2tiYXNlX3JuZG1fMiI6MjIuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjEwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjUuMCwiZGVsYXlfc2xpZGVycyI6NS4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjQuMCwiZGVsYXlfdHlwZSI6IlJhbmRvbSIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTIwLjAsIm9mZnNldF9yaWdodCI6NDAuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU5LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo1OS4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjE2LjAsInR5cGVfdGlja3NfdmFsdWUiOjE2LjB9LCJkZWxheV8xIjo1LjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MTYuMCwiZGVsYXlfNCI6NC4wLCJkZWxheV81IjoxOS4wLCJkZWxheV82IjoxMy4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOi0xOS4wLCJtb2RpZmllcl8yIjo4LjAsIm1vZGlmaWVyXzMiOjQ5LjAsIm1vZGlmaWVyXzQiOi0xNy4wLCJtb2RpZmllcl81IjotMTguMCwibW9kaWZpZXJfNiI6LTI3LjAsIm1vZGlmaWVyX29mZnNldCI6My4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjUuMCwibWluX29mZnNldF92YWx1ZSI6LTUuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjo0LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTnlhbnphIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6Mi4wLCJ0aWNrYmFzZV9ybmRtXzIiOjIyLjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOmZhbHNlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoxMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjo1LjAsImRlbGF5X3NsaWRlcnMiOjUuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjo0LjAsImRlbGF5X3R5cGUiOiJSYW5kb20iLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yMC4wLCJvZmZzZXRfcmlnaHQiOjQwLjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjoyOC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6My4wLCJkZWxheV81IjoxMC4wLCJkZWxheV82Ijo1LjAsIm1vZGlmaWVyIjoiRGlzYWJsZWQiLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9vZmZzZXQiOi0xLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6MC4wLCJtaW5fb2Zmc2V0X3ZhbHVlIjowLjAsInJhbmRvbWl6ZSI6ZmFsc2UsInNsaWRlcnMiOjMuMCwidHlwZSI6IkRlZmF1bHQifSwidGlja2Jhc2UiOiJOZXZlcmxvc2UiLCJ0aWNrYmFzZV8xIjoxNS4wLCJ0aWNrYmFzZV8yIjoxNS4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNS4wLCJ0aWNrYmFzZV9jaG9rZSI6MTYuMCwidGlja2Jhc2VfcmFuZG9taXplIjp0cnVlLCJ0aWNrYmFzZV9ybmRtIjoxNS4wLCJ0aWNrYmFzZV9ybmRtXzIiOjE2LjAsInRpY2tiYXNlX3JuZG1fdHlwZSI6IkRlZmF1bHQiLCJ0aWNrYmFzZV9zbGlkZXJzIjozLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X29wdGlvbnNfZXgiOnsiZGVsYXkiOnRydWUsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IldheXMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOjUuMCwib2Zmc2V0X3JpZ2h0Ijo2LjB9fSx7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6MjguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MC4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6MTMuMCwiZGVsYXlfMyI6MTguMCwiZGVsYXlfNCI6Ni4wLCJkZWxheV81IjoxNi4wLCJkZWxheV82IjoxMy4wLCJtb2RpZmllciI6IkRpc2FibGVkIiwibW9kaWZpZXJfMSI6Mi4wLCJtb2RpZmllcl8yIjotNDMuMCwibW9kaWZpZXJfMyI6MTUuMCwibW9kaWZpZXJfNCI6MjUuMCwibW9kaWZpZXJfNSI6LTM3LjAsIm1vZGlmaWVyXzYiOi03LjAsIm1vZGlmaWVyX29mZnNldCI6LTEuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjowLjAsIm1pbl9vZmZzZXRfdmFsdWUiOjAuMCwicmFuZG9taXplIjpmYWxzZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE1LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE1LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjIuMCwidGlja2Jhc2Vfcm5kbV8yIjoyMi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjoyMC4wLCJkZWxheV9taW5pbXVtX3ZhbHVlIjoyLjAsImRlbGF5X3NsaWRlcnMiOjYuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyLjAsImRlbGF5X3R5cGUiOiJXYXlzIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0Ijo1LjAsIm9mZnNldF9yaWdodCI6Ni4wfX1dLFt7ImJvZHkiOnRydWUsImJvZHlfb3B0aW9ucyI6eyJmcmVlc3RhbmRpbmciOiJEaXNhYmxlZCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjp0cnVlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsaW1pdF9tYXgiOjU4LjAsImxpbWl0X21pbiI6NTguMCwibGltaXRfdHlwZSI6IlN0YXRpYyIsIm1hc3RlciI6MS4wLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IlN0YXRpYyIsInR5cGVfcmFuZG9tX3ZhbHVlIjo0LjAsInR5cGVfdGlja3NfdmFsdWUiOjQuMH0sImRlbGF5XzEiOjEuMCwiZGVsYXlfMiI6MS4wLCJkZWxheV8zIjoyMC4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjUuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6Ik9mZnNldCIsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjEuMCwibWluX29mZnNldF92YWx1ZSI6LTEuMCwicmFuZG9taXplIjp0cnVlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTUuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjo2LjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiV2F5cyIsIm1hc3RlciI6MS4wLCJvZmZzZXRfbGVmdCI6LTIwLjAsIm9mZnNldF9yaWdodCI6MzYuMH19LHsiYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjYwLjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoxLjAsImRlbGF5XzMiOjIwLjAsImRlbGF5XzQiOjEuMCwiZGVsYXlfNSI6NS4wLCJkZWxheV82IjozLjAsIm1vZGlmaWVyIjoiT2Zmc2V0IiwibW9kaWZpZXJfMSI6MzIuMCwibW9kaWZpZXJfMiI6LTE0LjAsIm1vZGlmaWVyXzMiOi00OS4wLCJtb2RpZmllcl80IjotNS4wLCJtb2RpZmllcl81IjoyNi4wLCJtb2RpZmllcl82IjoyNy4wLCJtb2RpZmllcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfb3B0aW9ucyI6eyJtYXhfb2Zmc2V0X3ZhbHVlIjoxLjAsIm1pbl9vZmZzZXRfdmFsdWUiOi0xLjAsInJhbmRvbWl6ZSI6dHJ1ZSwic2xpZGVycyI6My4wLCJ0eXBlIjoiRGVmYXVsdCJ9LCJ0aWNrYmFzZSI6Ik5ldmVybG9zZSIsInRpY2tiYXNlXzEiOjE1LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE1LjAsInRpY2tiYXNlXzUiOjE1LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tiYXNlX2Nob2tlIjoxNi4wLCJ0aWNrYmFzZV9yYW5kb21pemUiOnRydWUsInRpY2tiYXNlX3JuZG0iOjE1LjAsInRpY2tiYXNlX3JuZG1fMiI6MTYuMCwidGlja2Jhc2Vfcm5kbV90eXBlIjoiRGVmYXVsdCIsInRpY2tiYXNlX3NsaWRlcnMiOjMuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfb3B0aW9uc19leCI6eyJkZWxheSI6ZmFsc2UsImRlbGF5X21heGltdW1fdmFsdWUiOjIwLjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjIuMCwiZGVsYXlfc2xpZGVycyI6Ni4wLCJkZWxheV9zdGF0aWNfdmFsdWUiOjIuMCwiZGVsYXlfdHlwZSI6IldheXMiLCJtYXN0ZXIiOjEuMCwib2Zmc2V0X2xlZnQiOi0yMC4wLCJvZmZzZXRfcmlnaHQiOjM2LjB9fV0sW3siYm9keSI6dHJ1ZSwiYm9keV9vcHRpb25zIjp7ImZyZWVzdGFuZGluZyI6IkRpc2FibGVkIiwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOnRydWUsImxlZnRfbGltaXQiOjU4LjAsImxpbWl0X21heCI6NTguMCwibGltaXRfbWluIjo1OC4wLCJsaW1pdF90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiU3RhdGljIiwidHlwZV9yYW5kb21fdmFsdWUiOjQuMCwidHlwZV90aWNrc192YWx1ZSI6NC4wfSwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwibW9kaWZpZXIiOiJEaXNhYmxlZCIsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9vcHRpb25zIjp7Im1heF9vZmZzZXRfdmFsdWUiOjAuMCwibWluX29mZnNldF92YWx1ZSI6MC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjozLjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTUuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5IjpmYWxzZSwiZGVsYXlfbWF4aW11bV92YWx1ZSI6MjAuMCwiZGVsYXlfbWluaW11bV92YWx1ZSI6Mi4wLCJkZWxheV9zbGlkZXJzIjozLjAsImRlbGF5X3N0YXRpY192YWx1ZSI6Mi4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjowLjAsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfX0seyJib2R5Ijp0cnVlLCJib2R5X29wdGlvbnMiOnsiZnJlZXN0YW5kaW5nIjoiRGVmYXVsdCIsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NTguMCwibGltaXRfbWF4Ijo1OC4wLCJsaW1pdF9taW4iOjU4LjAsImxpbWl0X3R5cGUiOiJTdGF0aWMiLCJtYXN0ZXIiOjEuMCwicmlnaHRfbGltaXQiOjU4LjAsInR5cGUiOiJTdGF0aWMiLCJ0eXBlX3JhbmRvbV92YWx1ZSI6NC4wLCJ0eXBlX3RpY2tzX3ZhbHVlIjo0LjB9LCJkZWxheV8xIjoxNi4wLCJkZWxheV8yIjoxMi4wLCJkZWxheV8zIjo2LjAsImRlbGF5XzQiOjExLjAsImRlbGF5XzUiOjkuMCwiZGVsYXlfNiI6My4wLCJtb2RpZmllciI6IkRpc2FibGVkIiwibW9kaWZpZXJfMSI6LTE4LjAsIm1vZGlmaWVyXzIiOjMzLjAsIm1vZGlmaWVyXzMiOi0zMi4wLCJtb2RpZmllcl80IjozNy4wLCJtb2RpZmllcl81IjoxMS4wLCJtb2RpZmllcl82IjotNDIuMCwibW9kaWZpZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX29wdGlvbnMiOnsibWF4X29mZnNldF92YWx1ZSI6LTQuMCwibWluX29mZnNldF92YWx1ZSI6NC4wLCJyYW5kb21pemUiOmZhbHNlLCJzbGlkZXJzIjo1LjAsInR5cGUiOiJEZWZhdWx0In0sInRpY2tiYXNlIjoiTmV2ZXJsb3NlIiwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTUuMCwidGlja2Jhc2VfNCI6MTUuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTUuMCwidGlja2Jhc2VfY2hva2UiOjE2LjAsInRpY2tiYXNlX3JhbmRvbWl6ZSI6dHJ1ZSwidGlja2Jhc2Vfcm5kbSI6MTUuMCwidGlja2Jhc2Vfcm5kbV8yIjoxNi4wLCJ0aWNrYmFzZV9ybmRtX3R5cGUiOiJEZWZhdWx0IiwidGlja2Jhc2Vfc2xpZGVycyI6My4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19vcHRpb25zX2V4Ijp7ImRlbGF5Ijp0cnVlLCJkZWxheV9tYXhpbXVtX3ZhbHVlIjo3LjAsImRlbGF5X21pbmltdW1fdmFsdWUiOjE2LjAsImRlbGF5X3NsaWRlcnMiOjUuMCwiZGVsYXlfc3RhdGljX3ZhbHVlIjoyMC4wLCJkZWxheV90eXBlIjoiU3RhdGljIiwibWFzdGVyIjoxLjAsIm9mZnNldF9sZWZ0IjowLjAsIm9mZnNldF9yaWdodCI6MC4wfX1dXSx7ImFkZG9ucyI6WyJEaXNhYmxlIGZvb3Qgc2hhZG93cyIsIkRpc2FibGUgdXNlIG9wZW5zIGJ1eSBtZW51IiwiQ2xlYXIgY29uc29sZSBvbiByb3VuZCBzdGFydCIsIn4iXSwiYWxsb3dfbGVhbmluZ193aGlsZV9zdGFuZGluZyI6ZmFsc2UsImFycm93c19hY2NlbnQiOiIjRkYwMDAwRkYiLCJhcnJvd3NfZm9udCI6IkRlZmF1bHQiLCJhcnJvd3NfZm9yd2FyZCI6Il4iLCJhcnJvd3NfbGVmdCI6IjwiLCJhcnJvd3NfcmlnaHQiOiI+IiwiYXNwZWN0cmF0aW8iOnsic2NhbGUiOjEzMy4wfSwiY2xhbl90YWciOmZhbHNlLCJjdXN0b21fZmFrZWR1Y2siOnRydWUsImN1c3RvbV9zY29wZSI6dHJ1ZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZWFydGhxdWFrZSI6ZmFsc2UsImZhbGxpbmciOjAuMCwiZmFzdF9sYWRkZXIiOmZhbHNlLCJmb3JjZV90ZWFtYWltYm90IjpmYWxzZSwiZnJlZXpldGltZV9mYWtlZHVjayI6dHJ1ZSwiaGl0bWFya2VycyI6WyJTY3JlZW4gMkQiLCJXb3JsZCAzRCIsIn4iXSwia2VlcF9tb2RlbF90cmFuc3BhcmVuY3kiOnRydWUsImxlYW5pbmciOjEwMC4wLCJsb2dfZXZlbnRzIjp7ImRhbWFnZV9kZWFsdCI6dHJ1ZSwibWFpbl9hY2NlbnQiOiIjRkZGRkZGRkYiLCJwcmVmaXgiOiJzbmFwc2hvdCIsInByZWZpeF9hY2NlbnQiOiIjRkZGRkZGRkYiLCJwdXJjaGFzZXMiOnRydWV9LCJtYW51YWxfYXJyb3dzIjp0cnVlLCJuaWNrbmFtZSI6IldpZSBXaXJzIE1hY2hlbiIsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlLCJzY3JlZW5fY29sb3IiOiIjRkZGRkZGRkYiLCJzY3JlZW5fZHVyYXRpb24iOjcuMCwidW5sb2NrX2Zha2VsYXRlbmN5Ijp0cnVlLCJ2aWV3bW9kZWwiOnsiYXhpc194IjotNDMuMCwiYXhpc195IjotNy4wLCJheGlzX3oiOi0xMS4wLCJmb3YiOjY4LjAsImxlZnRfaGFuZCI6ZmFsc2UsIm1haW5faGFuZCI6IkxlZnQiLCJyaWdodF9oYW5kIjpmYWxzZX0sIndhbGtpbmciOjAuMCwid2Fsa2luZ19kaXIiOjAuMCwid2Fsa2luZ19kaXJfMiI6NDkuMCwid29ybGRfY29sb3IiOlsiU2ltcGxlIiwiI0ZGRkZGRjlCIiwifiJdLCJ+Y3VzdG9tX2Zha2VkdWNrIjp7InNjYWxlIjoxNTAuMH0sIn5jdXN0b21fc2NvcGUiOnsiZWRnZV9hY2NlbnQiOiIjMDAwMDAwRkYiLCJnYXAiOjEwLjAsIm1haW5fYWNjZW50IjoiI0ZGRkZGRkEwIiwicm90YXRlZCI6ZmFsc2UsInNpemUiOjE1MC4wfSwifmtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp7InNjYWxlIjoxMC4wfX1d";
        end;
        v33.home.elements.preset_input:set("");
        v33:update();
        v33.home.elements.preset_buttons.save:set_callback(function()
            -- upvalues: v33 (ref)
            v33:save();
        end);
        v33.home.elements.preset_buttons.load:set_callback(function()
            -- upvalues: v33 (ref)
            v33:load();
        end);
        v33.home.elements.preset_buttons.delete:set_callback(function()
            -- upvalues: v33 (ref)
            v33:delete();
        end);
        v33.home.elements.preset_buttons.export:set_callback(function()
            -- upvalues: v33 (ref)
            v33:export();
        end);
        v33.home.elements.preset_buttons.import:set_callback(function()
            -- upvalues: v33 (ref)
            v33:import();
        end);
        v33.home.elements.preset_buttons.create:set_callback(function()
            -- upvalues: v33 (ref)
            v33:create();
        end);
        v33.home.elements.preset_list:set_callback(function(v34)
            v34:update();
            local v35 = v34:get();
            local _ = v34:list()[v35];
        end);
    end, 
    update = function(v37)
        local v38 = {};
        for _, v40 in ipairs(v37.system_presets) do
            v38[v40] = v40;
        end;
        for v41, _ in pairs(v37.database) do
            if not v38[v41] then
                v38[v41] = v41;
            end;
        end;
        local v43 = {};
        for v44 in pairs(v38) do
            table.insert(v43, v44);
        end;
        table.sort(v43);
        local v45 = {};
        for _, v47 in ipairs(v37.system_presets) do
            table.insert(v45, v47);
        end;
        table.insert(v45, v37.separator);
        for _, v49 in ipairs(v43) do
            if not v37:is_system_preset(v49) then
                table.insert(v45, v49);
            end;
        end;
        v37.home.elements.preset_list:update(v45);
    end, 
    is_system_preset = function(v50, v51)
        for _, v53 in ipairs(v50.system_presets) do
            if v51 == v53 then
                return true;
            end;
        end;
        return false;
    end, 
    is_separator = function(v54, v55)
        return v55 == v54.separator;
    end, 
    save = function(v56)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v57 = v56.home.elements.preset_list:get();
        local v58 = v56.home.elements.preset_list:list()[v57];
        if v56:is_separator(v58) then
            common.add_event("Cannot save a separator", "triangle-exclamation");
            return;
        elseif not v58 or v58 == "" then
            common.add_event("Invalid preset name", "triangle-exclamation");
            return;
        else
            for _, v60 in ipairs(v56.system_presets) do
                if v58 == v60 then
                    common.add_event("Failed: System preset", "triangle-exclamation");
                    return;
                end;
            end;
            if not v56.database[v58] then
                common.add_event("Preset doesnt exist", "triangle-exclamation");
                return;
            else
                local v61 = l_pui_0.setup({
                    [1] = v56.home.elements, 
                    [2] = v56.antiaim.elements, 
                    [3] = v56.antiaim.data, 
                    [4] = v56.other.elements
                }, true);
                local v62 = l_base64_0.encode(json.stringify(v61:save()));
                v56.database[v58] = v62;
                common.add_event("Preset saved successfully", "gear");
                v56:update();
                return;
            end;
        end;
    end, 
    load = function(v63)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v64 = v63.home.elements.preset_list:get();
        local v65 = v63.home.elements.preset_list:list()[v64];
        if v63:is_separator(v65) then
            common.add_event("Cannot load a separator", "triangle-exclamation");
            return;
        elseif not v65 or not v63.database[v65] then
            common.add_event("Failed to load", "triangle-exclamation");
            return;
        else
            l_pui_0.setup({
                [1] = v63.home.elements, 
                [2] = v63.antiaim.elements, 
                [3] = v63.antiaim.data, 
                [4] = v63.other.elements
            }, true):load((json.parse(l_base64_0.decode(v63.database[v65]))));
            v63.home.elements.preset_input:set(v65);
            common.add_event("Preset loaded successfully", "gear");
            return;
        end;
    end, 
    delete = function(v66)
        local v67 = v66.home.elements.preset_list:get();
        local v68 = v66.home.elements.preset_list:list()[v67];
        if v66:is_separator(v68) then
            common.add_event("Cannot delete a separator", "triangle-exclamation");
            return;
        elseif not v68 or v68 == "" then
            common.add_event("Invalid name", "triangle-exclamation");
            return;
        else
            for _, v70 in ipairs(v66.system_presets) do
                if v68 == v70 then
                    common.add_event("Failed: System preset", "triangle-exclamation");
                    return;
                end;
            end;
            if not v66.database[v68] then
                common.add_event("Preset doesnt exist", "triangle-exclamation");
                return;
            else
                v66.database[v68] = nil;
                common.add_event("Preset has been deleted", "gear");
                v66:update();
                return;
            end;
        end;
    end, 
    export = function(v71)
        -- upvalues: l_clipboard_0 (ref)
        local v72 = v71.home.elements.preset_list:get();
        local v73 = v71.home.elements.preset_list:list()[v72];
        if v71:is_separator(v73) then
            common.add_event("Cannot export a separator", "triangle-exclamation");
            return;
        elseif not v73 or not v71.database[v73] then
            common.add_event("Preset doesnt exist", "triangle-exclamation");
            return;
        else
            l_clipboard_0.set(v71.database[v73]);
            common.add_event("Preset has been exported to clipboard", "gear");
            return;
        end;
    end, 
    import = function(v74)
        -- upvalues: l_clipboard_0 (ref)
        if l_clipboard_0.get() == nil then
            common.add_event("Clipboard is empty", "triangle-exclamation");
            return;
        else
            local v75 = v74.home.elements.preset_list:get();
            local v76 = v74.home.elements.preset_list:list()[v75];
            if v74:is_separator(v76) then
                common.add_event("Cannot import to a separator", "triangle-exclamation");
                return;
            else
                for _, v78 in ipairs(v74.system_presets) do
                    if v76 == v78 then
                        common.add_event("Failed: System preset", "triangle-exclamation");
                        return;
                    end;
                end;
                v74.database[v76] = l_clipboard_0.get();
                common.add_event("Imported successfully", "gear");
                v74:update();
                return;
            end;
        end;
    end, 
    create = function(v79)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v80 = v79.home.elements.preset_input:get();
        if v80 == "" then
            common.add_event("Invalid name", "triangle-exclamation");
            return;
        else
            local v81 = l_pui_0.setup({
                [1] = v79.home.elements, 
                [2] = v79.antiaim.elements, 
                [3] = v79.antiaim.data, 
                [4] = v79.other.elements
            }, true);
            v79.database[v80] = l_base64_0.encode(json.stringify(v81:save()));
            common.add_event("Preset has been created", "gear");
            v79:update();
            return;
        end;
    end, 
    render = function(v82)
        local v83 = v82.home.elements.preset_list:list()[v82.home.elements.preset_list:get()];
        local v84 = {};
        for _, v86 in ipairs(v82.system_presets) do
            v84[v86] = true;
        end;
        local v87 = v84[v83];
        local v88 = v83 == v82.separator;
        local v89 = v87 or v88;
        local l_v88_0 = v88;
        local l_preset_buttons_0 = v82.home.elements.preset_buttons;
        l_preset_buttons_0.save:disabled(v89);
        l_preset_buttons_0.delete:disabled(v89);
        l_preset_buttons_0.import:disabled(v89);
        l_preset_buttons_0.export:disabled(v89);
        l_preset_buttons_0.load:disabled(l_v88_0);
    end, 
    event_manager = function(v92)
        local function v93()
            -- upvalues: v92 (ref)
            v92:render();
        end;
        local function v94()
            -- upvalues: v92 (ref)
            db.snapshot555 = v92.database;
        end;
        events.render(v93);
        events.shutdown(v94);
    end
}):struct("antiaim")({
    init = function(v95)
        -- upvalues: l_pui_0 (ref)
        v95.groups = {
            states = l_pui_0.create("\v\238\147\162", " ", 1), 
            builder = l_pui_0.create("\v\238\147\162", "builder", 2), 
            options = l_pui_0.create("\v\238\147\162", ""), 
            snap_builder = l_pui_0.create("\v\238\147\162", "snap builder")
        };
        v95.e_teams = {
            [1] = "\v\226\128\162  \rTerrorists", 
            [2] = "\v\226\128\162  \rCounter-Terrorists"
        };
        v95.e_states = {
            [1] = "\v\239\134\131     \rStanding", 
            [2] = "\v\239\156\140    \rRunning", 
            [3] = "\v\239\149\148     \rSlowing", 
            [4] = "\v\239\134\147   \rCrouching", 
            [5] = "\v\238\139\142    \rSneaking", 
            [6] = "\v\238\149\134    \rAir", 
            [7] = "\v\238\149\135  \rAir Crouching", 
            [8] = "\v\238\147\129   \rFreestanding"
        };
        v95.elements = {
            teams = v95.groups.states:list("\v\239\131\128  \rSelect the state you want to configure.", v95.e_teams), 
            states = v95.groups.states:list("", v95.e_states), 
            force_break_lc = v95.groups.snap_builder:selectable("\a[warn]\226\128\162  \rForce Break LC", v95.e_states), 
            hide_shots = v95.groups.snap_builder:combo("    \a[warn]\226\164\183  \rHide Shots  \a[warn]\239\146\142", "Favor Fire Rate", "Favor Fake Lag", "Break LC"), 
            options_gear = v95.groups.options:label("\v\226\128\162  \rOptions  \v\239\134\178"), 
            options_table = {}
        };
        local v96 = v95.elements.options_gear:create();
        v95.elements.options_table = {
            avoid_backstab = v96:switch("\v\226\128\162  \rAvoid Backstab  \v\239\155\181"), 
            fake_lag = v96:switch("\v\226\128\162  \rFluctuate Fake Lag  \v\239\131\133"), 
            fake_lag_type = v96:combo("    \v\226\164\183  \rType", "Always on", "R8 Revolver"), 
            safe_head = v96:selectable("\v\226\128\162  \rSafe Head  \v\238\141\186", "\v\239\134\131     \rStanding", "\v\239\134\147   \rCrouching  \a[warn]+  \v\238\139\142  \rSneaking", "\v\238\149\135  \rAir Crouching  \a[warn]+  \rKnife/Taser"), 
            tweaks = v96:selectable("\v\226\128\162  \rTweaks  \v\239\128\147", "Warmup", "No Enemies"), 
            tweaks_pitch = v96:combo("    \v\226\164\183  \rPitch", "Disabled", "Down"), 
            tweaks_yaw_type = v96:combo("    \v\226\164\183  \rYaw", "Spin", "Distortion", "L&R"), 
            tweaks_range = v96:slider("            \v\226\164\183  \rRange", 1, 180, 180, nil, "\194\176"), 
            tweaks_speed = v96:slider("            \v\226\164\183  \rSpeed", 1, 10, 2, nil, "t"), 
            tweaks_left_offset = v96:slider("            \v\226\164\183  \rLeft", -180, 180, -30, nil, "\194\176"), 
            tweaks_right_offset = v96:slider("            \v\226\164\183  \rRight", -180, 180, 30, nil, "\194\176")
        };
        v95.elements.disable_lc_grenade = v95.elements.force_break_lc:create():switch("\v\226\164\183  \rDisable on Grenade");
        v95.elements.options_table.tweaks_pitch:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        });
        v95.elements.options_table.tweaks_yaw_type:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        });
        v95.elements.options_table.tweaks_range:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [3] = true, 
            [1] = v95.elements.options_table.tweaks_yaw_type
        });
        v95.elements.options_table.tweaks_speed:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [3] = true, 
            [1] = v95.elements.options_table.tweaks_yaw_type
        });
        v95.elements.options_table.tweaks_left_offset:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [1] = v95.elements.options_table.tweaks_yaw_type
        });
        v95.elements.options_table.tweaks_right_offset:depend({
            [1] = nil, 
            [2] = "Warmup", 
            [3] = "No Enemies", 
            [1] = v95.elements.options_table.tweaks
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [1] = v95.elements.options_table.tweaks_yaw_type
        });
        v95.elements.options_table.fake_lag_type:depend(v95.elements.options_table.fake_lag);
        local l_builder_0 = v95.groups.builder;
        v95.elements.freestanding_allowed = v95.groups.builder:switch("\v\226\128\162  \rAllow  \v\238\147\129");
        v95.data = {};
        for v98, _ in ipairs(v95.e_states) do
            v95.data[v98] = {};
            do
                local l_v98_0 = v98;
                for v101, _ in ipairs(v95.e_teams) do
                    local l_states_0 = v95.elements.states;
                    local l_teams_0 = v95.elements.teams;
                    v95.data[l_v98_0][v101] = {
                        yaw_mode = l_builder_0:slider("\v\226\128\162  \rMode  \v\239\151\189", 1, 2, 1, nil, function(v105)
                            return ({
                                [1] = "1-Way", 
                                [2] = "2-Way"
                            })[v105];
                        end):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = v101
                        }), 
                        yaw_offset = l_builder_0:slider("    \v\226\164\183  \rOffset", -180, 180, 0, nil, "\194\176"), 
                        modifier = l_builder_0:combo("\v\226\128\162  \rJitter  \v\239\151\189", "Disabled", "Offset", "Center", "Random", "Spin", "3-Way", "5-Way"):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = v101
                        }), 
                        modifier_offset = l_builder_0:slider("    \v\226\164\183  \rOffset", -180, 180, 0, nil, "\194\176"), 
                        body = l_builder_0:switch("\v\226\128\162  \rDesync  \v\239\151\189"):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = v101
                        })
                    };
                    local v106 = v95.data[l_v98_0][v101].modifier:create();
                    v95.data[l_v98_0][v101].modifier_options = {
                        randomize = v106:switch("\v\226\128\162  \rRandomize"), 
                        type = v106:combo("\v\226\128\162  \rType", "Default", "Ways"), 
                        min_offset_value = v106:slider("    \v\226\164\183  \r[1]", -180, 180, 0, nil, "\194\176"), 
                        max_offset_value = v106:slider("    \v\226\164\183  \r[2]", -180, 180, 0, nil, "\194\176"), 
                        sliders = v106:slider("\v\226\128\162  \rSliders", 3, 6, 3)
                    };
                    do
                        local l_v101_0 = v101;
                        for v108 = 1, 6 do
                            do
                                local l_v108_0 = v108;
                                local v110 = v106:slider("    \v\226\164\183  \r[" .. l_v108_0 .. "]", -180, 180, 0, nil, " \238\136\185"):depend({
                                    [1] = l_states_0, 
                                    [2] = l_v98_0
                                }, {
                                    [1] = l_teams_0, 
                                    [2] = l_v101_0
                                }, {
                                    [1] = nil, 
                                    [2] = "Disabled", 
                                    [3] = true, 
                                    [1] = v95.data[l_v98_0][l_v101_0].modifier
                                }, {
                                    [1] = nil, 
                                    [2] = "Ways", 
                                    [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                                }, {
                                    [1] = v95.data[l_v98_0][l_v101_0].modifier_options.sliders, 
                                    [2] = function()
                                        -- upvalues: l_v108_0 (ref), v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                        return l_v108_0 <= v95.data[l_v98_0][l_v101_0].modifier_options.sliders:get();
                                    end
                                }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                                v95.data[l_v98_0][l_v101_0]["modifier_" .. l_v108_0] = v110;
                            end;
                        end;
                        v95.data[l_v98_0][l_v101_0].modifier_reset = v106:button("\aF44336FF\239\128\145 Reset", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v111 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["modifier_" .. v111]:set(0);
                                v95.data[l_v98_0][l_v101_0].modifier_options.sliders:set(3);
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].modifier_randomize = v106:button("\v\239\129\180 \rRandomize", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v112 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["modifier_" .. v112]:set(math.random(-50, 50));
                                v95.data[l_v98_0][l_v101_0].modifier_options.sliders:set(math.random(3, 6));
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].modifier_randomize2 = v106:button("\v\239\129\180 \rRandomize", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            v95.data[l_v98_0][l_v101_0].modifier_options.min_offset_value:set(math.random(-50, 50));
                            v95.data[l_v98_0][l_v101_0].modifier_options.max_offset_value:set(math.random(-50, 50));
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        local v113 = v95.data[l_v98_0][l_v101_0].body:create();
                        v95.data[l_v98_0][l_v101_0].body_options = {
                            separator = v113:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
                            back_button = v113:button("\v\239\129\162  \rBack", function()
                                -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                cvar.play:call("ui\\csgo_ui_contract_type1");
                                v95.data[l_v98_0][l_v101_0].body_options.master:set(0);
                            end, true), 
                            inverter = v113:switch("\v\226\128\162  \rSide"), 
                            jitter = v113:switch("\v\226\128\162  \rJitter"), 
                            freestanding = v113:combo("\v\226\128\162  \rFreestanding", "Disabled", "Default", "Reversed"), 
                            type = v113:combo("\v\226\128\162  \rType", "Static", "Ticks", "Random"), 
                            type_ticks_value = v113:slider("    \v\226\164\183  \rValue", 3, 16, 4, nil, "t"), 
                            type_random_value = v113:slider("    \v\226\164\183  \rValue", 4, 16, 4), 
                            limit_type = v113:combo("\v\226\128\162  \rLimit Type", "Static", "Random"), 
                            left_limit = v113:slider("    \v\226\164\183  \rLeft", 0, 60, 58, nil, "\194\176"), 
                            right_limit = v113:slider("    \v\226\164\183  \rRight", 0, 60, 58, nil, "\194\176"), 
                            limit_min = v113:slider("    \v\226\164\183  \r[1]", 0, 60, 58, nil, "\194\176"), 
                            limit_max = v113:slider("    \v\226\164\183  \r[2]", 0, 60, 58, nil, "\194\176"), 
                            master = v113:slider("Master", 0, 2, 0), 
                            separator_2 = v113:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
                            body_button = v113:button("\v\239\130\133  \rOther", function()
                                -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                cvar.play:call("ui\\csgo_ui_contract_type1");
                                v95.data[l_v98_0][l_v101_0].body_options.master:set(1);
                            end, true)
                        };
                        local v114 = v95.data[l_v98_0][l_v101_0].yaw_mode:create();
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex = {
                            offset_left = v114:slider("\v\226\128\162  \rLeft Offset", -180, 180, 0, nil, "\194\176"), 
                            offset_right = v114:slider("\v\226\128\162  \rRight Offset", -180, 180, 0, nil, "\194\176"), 
                            master = v114:slider("Master", 0, 2, 0), 
                            separator = v114:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
                            back_button = v114:button("\v\239\129\162  \rBack", function()
                                -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                cvar.play:call("ui\\csgo_ui_contract_type1");
                                v95.data[l_v98_0][l_v101_0].yaw_options_ex.master:set(0);
                            end, true), 
                            separator_2 = v114:label("\r\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128"), 
                            delay_button = v114:button("\v\238\144\155  \rDelay", function()
                                -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                cvar.play:call("ui\\csgo_ui_contract_type1");
                                v95.data[l_v98_0][l_v101_0].yaw_options_ex.master:set(1);
                            end, true), 
                            delay = v114:switch("\v\226\128\162  \rApply"), 
                            delay_type = v114:combo("\v\226\128\162  \rType", "Static", "Random", "Ways"), 
                            delay_static_value = v114:slider("    \v\226\164\183  \rTiming", 2, 20, 2, nil, " \238\136\185"), 
                            delay_minimum_value = v114:slider("    \v\226\164\183  \r[1]", 2, 20, 2, nil, " \238\136\185"), 
                            delay_maximum_value = v114:slider("    \v\226\164\183  \r[2]", 2, 20, 20, nil, " \238\136\185"), 
                            delay_sliders = v114:slider("\v\226\128\162  \rSliders", 3, 6, 3)
                        };
                        for v115 = 1, 6 do
                            do
                                local l_v115_0 = v115;
                                local v117 = v114:slider("    \v\226\164\183  \r[" .. l_v115_0 .. "]", 1, 20, 2, nil, " \238\136\185"):depend({
                                    [1] = l_states_0, 
                                    [2] = l_v98_0
                                }, {
                                    [1] = l_teams_0, 
                                    [2] = l_v101_0
                                }, {
                                    [1] = nil, 
                                    [2] = 2, 
                                    [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                                }, {
                                    [1] = nil, 
                                    [2] = 1, 
                                    [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                                }, {
                                    [1] = nil, 
                                    [2] = "Ways", 
                                    [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                                }, {
                                    [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_sliders, 
                                    [2] = function()
                                        -- upvalues: l_v115_0 (ref), v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                        return l_v115_0 <= v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_sliders:get();
                                    end
                                }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                                v95.data[l_v98_0][l_v101_0]["delay_" .. l_v115_0] = v117;
                            end;
                        end;
                        v95.data[l_v98_0][l_v101_0].delay_reset = v114:button("\aF44336FF\239\128\145 Reset", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v118 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["delay_" .. v118]:set(2);
                                v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_sliders:set(3);
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].delay_randomize = v114:button("\v\239\129\180 \rRandomize", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v119 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["delay_" .. v119]:set(math.random(1, 20));
                                v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_sliders:set(math.random(3, 6));
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].delay_randomize2 = v114:button("\v\239\129\180 \rRandomize", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_minimum_value:set(math.random(2, 20));
                            v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_maximum_value:set(math.random(2, 20));
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].forward_state = l_builder_0:button("          \rForward to the opposite side  \v\239\133\141          ", function()
                            -- upvalues: l_v101_0 (ref), v95 (ref), l_v98_0 (ref)
                            local v120 = l_v101_0 == 1 and 2 or 1;
                            local v121 = {
                                [1] = "yaw_mode", 
                                [2] = "yaw_offset", 
                                [3] = "modifier", 
                                [4] = "modifier_offset", 
                                [5] = "body"
                            };
                            local v122 = {
                                yaw_options_ex = {
                                    [1] = "offset_left", 
                                    [2] = "offset_right", 
                                    [3] = "delay", 
                                    [4] = "delay_type", 
                                    [5] = "delay_static_value", 
                                    [6] = "delay_minimum_value", 
                                    [7] = "delay_maximum_value", 
                                    [8] = "delay_sliders", 
                                    [9] = "master"
                                }, 
                                modifier_options = {
                                    [1] = "randomize", 
                                    [2] = "type", 
                                    [3] = "min_offset_value", 
                                    [4] = "max_offset_value", 
                                    [5] = "sliders"
                                }, 
                                body_options = {
                                    [1] = "inverter", 
                                    [2] = "jitter", 
                                    [3] = "freestanding", 
                                    [4] = "type", 
                                    [5] = "type_ticks_value", 
                                    [6] = "type_random_value", 
                                    [7] = "limit_type", 
                                    [8] = "left_limit", 
                                    [9] = "right_limit", 
                                    [10] = "limit_min", 
                                    [11] = "limit_max", 
                                    [12] = "master"
                                }
                            };
                            local v123 = {};
                            for v124 = 1, 6 do
                                table.insert(v123, "modifier_" .. v124);
                                table.insert(v123, "delay_" .. v124);
                            end;
                            for _, v126 in ipairs(v121) do
                                local v127 = v95.data[l_v98_0][l_v101_0][v126];
                                local v128 = v95.data[l_v98_0][v120][v126];
                                if v127 and v128 then
                                    v128:set(v127:get());
                                end;
                            end;
                            for v129, v130 in pairs(v122) do
                                for _, v132 in ipairs(v130) do
                                    local v133 = v95.data[l_v98_0][l_v101_0][v129];
                                    local v134 = v95.data[l_v98_0][v120][v129];
                                    if v133 and v134 and v133[v132] and v134[v132] then
                                        v134[v132]:set(v133[v132]:get());
                                    end;
                                end;
                            end;
                            for _, v136 in ipairs(v123) do
                                local v137 = v95.data[l_v98_0][l_v101_0][v136];
                                local v138 = v95.data[l_v98_0][v120][v136];
                                if v137 and v138 then
                                    v138:set(v137:get());
                                end;
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase = v95.groups.snap_builder:combo("\a[warn]\226\128\162  \rTickbase  \a[warn]\226\165\130", "Neverlose", "Nyanza"):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_randomize = v95.data[l_v98_0][l_v101_0].tickbase:create():switch("\a[warn]\226\128\162  \rRandomize", true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_choke = v95.data[l_v98_0][l_v101_0].tickbase:create():slider("    \a[warn]\226\164\183  \rChoke", 2, 22, 16, nil, function(v139)
                            return ({
                                [1] = nil, 
                                [2] = "Sharp", 
                                [16] = "Default", 
                                [22] = "Smooth"
                            })[v139] or v139 .. "t";
                        end):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = false, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_rndm_type = v95.data[l_v98_0][l_v101_0].tickbase:create():combo("    \a[warn]\226\164\183  \rType", "Default", "Ways"):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_rndm = v95.data[l_v98_0][l_v101_0].tickbase:create():slider("        \a[warn]\226\164\183  \rChoke [1]", 2, 22, 15, nil, function(v140)
                            return ({
                                [1] = nil, 
                                [2] = "Sharp", 
                                [22] = "Smooth", 
                                [15] = "Default"
                            })[v140] or v140 .. "t";
                        end):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_rndm_2 = v95.data[l_v98_0][l_v101_0].tickbase:create():slider("        \a[warn]\226\164\183  \rChoke [2]", 2, 22, 16, nil, function(v141)
                            return ({
                                [1] = nil, 
                                [2] = "Sharp", 
                                [16] = "Default", 
                                [22] = "Smooth"
                            })[v141] or v141 .. "t";
                        end):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_sliders = v95.data[l_v98_0][l_v101_0].tickbase:create():slider("        \a[warn]\226\164\183  \rSliders", 3, 6, 3):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                        });
                        for v142 = 1, 6 do
                            do
                                local l_v142_0 = v142;
                                local v144 = v95.data[l_v98_0][l_v101_0].tickbase:create():slider("                    \a[warn]\226\164\183  \r[" .. l_v142_0 .. "]", 2, 22, math.random(15, 16), nil, " \238\136\185"):depend({
                                    [1] = l_states_0, 
                                    [2] = l_v98_0
                                }, {
                                    [1] = l_teams_0, 
                                    [2] = l_v101_0
                                }, {
                                    [1] = nil, 
                                    [2] = "Nyanza", 
                                    [1] = v95.data[l_v98_0][l_v101_0].tickbase
                                }, {
                                    [1] = nil, 
                                    [2] = true, 
                                    [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                                }, {
                                    [1] = nil, 
                                    [2] = "Ways", 
                                    [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                                }, {
                                    [1] = v95.data[l_v98_0][l_v101_0].tickbase_sliders, 
                                    [2] = function()
                                        -- upvalues: l_v142_0 (ref), v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                                        return l_v142_0 <= v95.data[l_v98_0][l_v101_0].tickbase_sliders:get();
                                    end
                                });
                                v95.data[l_v98_0][l_v101_0]["tickbase_" .. l_v142_0] = v144;
                            end;
                        end;
                        v95.data[l_v98_0][l_v101_0].tickbase_reset = v95.data[l_v98_0][l_v101_0].tickbase:create():button("\aF44336FF\239\128\145 Reset", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v145 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["tickbase_" .. v145]:set(math.random(2, 22));
                                v95.data[l_v98_0][l_v101_0].tickbase_sliders:set(3);
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                        });
                        v95.data[l_v98_0][l_v101_0].tickbase_randomize_x = v95.data[l_v98_0][l_v101_0].tickbase:create():button("\a[warn]\239\129\180 \rRandomize", function()
                            -- upvalues: v95 (ref), l_v98_0 (ref), l_v101_0 (ref)
                            for v146 = 1, 6 do
                                v95.data[l_v98_0][l_v101_0]["tickbase_" .. v146]:set(math.random(1, 20));
                                v95.data[l_v98_0][l_v101_0].tickbase_sliders:set(math.random(3, 6));
                            end;
                        end, true):depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Nyanza", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_randomize
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].tickbase_rndm_type
                        });
                        v95.data[l_v98_0][l_v101_0].modifier_options.sliders:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].modifier_options.randomize:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        });
                        v95.data[l_v98_0][l_v101_0].modifier_options.type:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].modifier_offset:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = false, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.randomize
                        });
                        v95.data[l_v98_0][l_v101_0].modifier_options.min_offset_value:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].modifier_options.max_offset_value:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = "Disabled", 
                            [3] = true, 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier
                        }, {
                            [1] = nil, 
                            [2] = "Default", 
                            [1] = v95.data[l_v98_0][l_v101_0].modifier_options.type
                        }, v95.data[l_v98_0][l_v101_0].modifier_options.randomize);
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.offset_left:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.offset_right:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.separator:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.back_button:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.separator_2:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_button:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_static_value:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Static", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_minimum_value:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_maximum_value:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_sliders:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.master
                        }, {
                            [1] = nil, 
                            [2] = "Ways", 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay_type
                        }, v95.data[l_v98_0][l_v101_0].yaw_options_ex.delay);
                        v95.data[l_v98_0][l_v101_0].body_options.type:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.type_ticks_value:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Ticks", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.type_random_value:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.freestanding:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.limit_type:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.left_limit:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Static", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.limit_type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.right_limit:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Static", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.limit_type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.limit_min:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.limit_type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.limit_max:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, {
                            [1] = nil, 
                            [2] = "Random", 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.limit_type
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.jitter:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.inverter:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.separator:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.back_button:depend({
                            [1] = nil, 
                            [2] = 1, 
                            [3] = 2, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.separator_2:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.body_button:depend({
                            [1] = nil, 
                            [2] = 0, 
                            [1] = v95.data[l_v98_0][l_v101_0].body_options.master
                        }, v95.data[l_v98_0][l_v101_0].body);
                        v95.data[l_v98_0][l_v101_0].body_options.master:depend({
                            [1] = nil, 
                            [2] = 100, 
                            [1] = v95.home.elements.progress_version_bar
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_offset:depend({
                            [1] = l_states_0, 
                            [2] = l_v98_0
                        }, {
                            [1] = l_teams_0, 
                            [2] = l_v101_0
                        }, {
                            [1] = nil, 
                            [2] = 1, 
                            [1] = v95.data[l_v98_0][l_v101_0].yaw_mode
                        });
                        v95.data[l_v98_0][l_v101_0].yaw_options_ex.master:depend({
                            [1] = nil, 
                            [2] = 100, 
                            [1] = v95.home.elements.progress_version_bar
                        });
                        v95.elements.freestanding_allowed:depend({
                            [1] = nil, 
                            [2] = 8, 
                            [1] = l_states_0
                        });
                    end;
                end;
            end;
        end;
        v95.elements.manual_yaw = v95.groups.options:combo("\v\226\128\162  \rManuals  \v\239\129\185", {
            [1] = "Disabled", 
            [2] = "Left", 
            [3] = "Right", 
            [4] = "Forward"
        }, function(v147)
            -- upvalues: l_pui_0 (ref)
            return {
                body_tweaks = v147:selectable("\v\226\128\162  \rBody", l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"):list()), 
                freestanding = v147:combo("\v\226\128\162  \rFreestanding", "Disabled", "Default", "Reversed"), 
                side = v147:switch("\v\226\128\162  \rSide")
            };
        end, "");
        v95.elements.freestanding = v95.groups.options:switch("\v\226\128\162  \rFreestanding  \v\238\147\129", false, function(v148)
            return {
                body_fs = v148:switch("\v\226\164\183  \rBody Freestanding", true), 
                disablers = v148:listable("\v\226\128\162  \rDisablers  \v\239\131\128", {
                    [1] = "\v\239\134\131     \rStanding", 
                    [2] = "\v\239\156\140    \rRunning", 
                    [3] = "\v\239\149\148     \rSlowing", 
                    [4] = "\v\239\134\147   \rCrouching", 
                    [5] = "\v\238\139\142    \rSneaking", 
                    [6] = "\v\238\149\134    \rAir", 
                    [7] = "\v\238\149\135  \rAir Crouching"
                })
            };
        end, "");
    end
}):struct("other")({
    init = function(v149)
        -- upvalues: l_pui_0 (ref)
        v149.groups = {
            animations_movement = l_pui_0.create("\v\239\139\155", "Player Animations"), 
            visuals = l_pui_0.create("\v\239\139\155", "Visuals", 2), 
            aimbot = l_pui_0.create("\v\239\139\155", "Aimbot"), 
            other_visuals = l_pui_0.create("\v\239\139\155", ""), 
            other = l_pui_0.create("\v\239\139\155", "Other"), 
            movement = l_pui_0.create("\v\239\139\155", "Movement")
        };
        v149.elements = {
            leaning = v149.groups.animations_movement:slider("\v\239\134\131   \rLeaning", 0, 100, 0, 0.01, function(v150)
                if v150 == 0 then
                    return "Default";
                elseif v150 == 35 then
                    return "Small";
                elseif v150 == 50 then
                    return "Medium";
                elseif v150 == 75 then
                    return "High";
                elseif v150 == 100 then
                    return "Extreme";
                else
                    return v150 .. "%";
                end;
            end), 
            falling = v149.groups.animations_movement:slider("\v\238\149\134  \rFalling", 0, 10, 0, 0.1, function(v151)
                if v151 == 0 then
                    return "Default";
                elseif v151 == 5 then
                    return "Force";
                elseif v151 == 10 then
                    return "Maximum";
                else
                    return v151 .. "x";
                end;
            end), 
            walking = v149.groups.animations_movement:slider("\v\239\149\148   \rWalking", 0, 2, 0, nil, function(v152)
                if v152 == 0 then
                    return "Default";
                elseif v152 == 1 then
                    return "Force";
                elseif v152 == 2 then
                    return "Jitter";
                else
                    return nil;
                end;
            end), 
            no_fall_damage = v149.groups.movement:switch("\v\238\149\135   \rNo Fall Damage"), 
            fast_ladder = v149.groups.movement:switch("\v\239\151\133    \rFast Ladder"), 
            unlock_fakelatency = v149.groups.aimbot:switch("\v\239\163\157   \rUnlock Fake Latency"), 
            force_teamaimbot = v149.groups.aimbot:switch("\v\239\129\173    \rForce Teammate Aimbot"), 
            freezetime_fakeduck = v149.groups.aimbot:switch("\v\239\155\152    \rFreezetime Fakeduck"), 
            custom_fakeduck = v149.groups.aimbot:switch("\v\238\146\150  \rCustom Fakeduck Speed", false, function(v153)
                return {
                    scale = v153:slider("\v\226\164\183  \rScale", 15, 150, 150, nil, function(v154)
                        if v154 == 15 then
                            return "Slow";
                        elseif v154 == 80 then
                            return "Default";
                        elseif v154 == 150 then
                            return "Fast";
                        else
                            return nil;
                        end;
                    end)
                };
            end), 
            aspectratio = v149.groups.visuals:label("\v\238\134\181  \rAspect Ratio", function(v155)
                return {
                    scale = v155:slider("\v\226\164\183  \rValue", 50, 300, 177, 0.01, function(v156)
                        if v156 == 177 then
                            return "16:9";
                        elseif v156 == 161 then
                            return "16:10";
                        elseif v156 == 150 then
                            return "3:2";
                        elseif v156 == 133 then
                            return "4:3";
                        elseif v156 == 125 then
                            return "5:4";
                        else
                            return nil;
                        end;
                    end)
                };
            end), 
            viewmodel = v149.groups.visuals:label("\v\238\149\142  \rViewmodel", function(v157)
                return {
                    fov = v157:slider("\v\226\128\162  \rField of View", -100, 100, 68, 1), 
                    axis_x = v157:slider("    \v\226\164\183  \rX Axis", -150, 150, 0, 0.1), 
                    axis_y = v157:slider("    \v\226\164\183  \rY Axis", -150, 150, 0, 0.1), 
                    axis_z = v157:slider("    \v\226\164\183  \rZ Axis", -150, 150, 0, 0.1), 
                    main_hand = v157:combo("\v\226\128\162  \rMain Hand", "Left", "Right"), 
                    left_hand = v157:switch("    \v\226\164\183  \rKnife Left Hand"), 
                    right_hand = v157:switch("    \v\226\164\183  \rKnife Right Hand")
                };
            end), 
            manual_arrows = v149.groups.visuals:switch("\v\239\129\185 \rManual Arrows"), 
            keep_model_transparency = v149.groups.visuals:switch("\v\238\145\191   \rKeep Model Transparency", false, function(v158)
                return {
                    scale = v158:slider("\v\226\164\183  \rFade Duration", 1, 20, 10, nil, function(v159)
                        return v159 == 1 and "Smooth" or v159 == 10 and "GS" or v159 == 20 and "Default";
                    end)
                };
            end, ""), 
            debug_text = v149.groups.visuals:switch("\v\239\159\185   \rDebug Text", false, function(v160)
                return {
                    font = v160:combo("Font", "Default", "Console", "Bold")
                };
            end):disabled(true), 
            log_events = v149.groups.other:label("\v\238\145\178   \rLog Events", function(v161)
                return {
                    damage_dealt = v161:switch("\v\226\128\162  \rDamage Dealt"), 
                    purchases = v161:switch("\v\226\128\162  \rPurchases"), 
                    prefix = v161:input("    \v\226\164\183  \rPrefix", "snapshot"), 
                    button = v161:button("\v\238\136\134  \rPrint the Instruction to the Console", function(_)
                        cvar.clear:call();
                        print_raw("\239\130\133 Commands:\n    p= \226\128\148 Set custom prefix\n    nh \226\128\148 Disable color\n    b=( ) \226\128\148 Use round brackets\n    nb \226\128\148 Remove brackets\n    np \226\128\148 Disable prefix\n\nExample: p=logger nh b=<>");
                    end, true), 
                    main_accent = v161:color_picker("\v\226\128\162  \rMain Accent", color(255, 255, 255, 255)), 
                    prefix_accent = v161:color_picker("    \v\226\164\183  \rPrefix", color(255, 255, 255, 255))
                };
            end), 
            clan_tag = v149.groups.other:switch("\v\239\159\170   \rClan Tag Spammer"), 
            custom_scope = v149.groups.visuals:switch("\v\239\129\155   \rCustom Scope Overlay", false, function(v163)
                return {
                    rotated = v163:switch(" \v\226\128\162  \rRotated"), 
                    size = v163:slider("    \v\226\164\183  \rSize", 10, 300, 200), 
                    gap = v163:slider("    \v\226\164\183  \rGap", 1, 300, 10), 
                    main_accent = v163:color_picker("\v\226\128\162  \rMain Accent", color(255, 255, 255, 160)), 
                    edge_accent = v163:color_picker("    \v\226\164\183  \rEdge", color(0, 0, 0, 0))
                };
            end), 
            damage_indicator = v149.groups.visuals:switch("\v\239\155\130  \rDamage Override Indicator"), 
            hitmarkers = v149.groups.visuals:selectable("\v\239\153\136   \rHitmarkers", "Screen 2D", "World 3D"), 
            addons = v149.groups.visuals:selectable("\v\239\151\189   \rAddons", "Disable foot shadows", "Disable use opens buy menu", "No sleeves", "Legacy desync", "Clientside nickname", "Clear console on round start")
        };
        v149.elements.screen_color = v149.elements.hitmarkers:create():color_picker("\v\226\128\162  \r2D Color", color(255, 255, 255, 255));
        v149.elements.screen_duration = v149.elements.hitmarkers:create():slider("    \v\226\164\183  \rDuration", 1, 10, 1, nil, function(v164)
            return v164 == 1 and "Default";
        end);
        v149.elements.world_color = v149.elements.hitmarkers:create():color_picker("\v\226\128\162  \r3D Color", {
            Simple = {
                color(255, 0, 0, 155)
            }, 
            Double = {
                color(0, 255, 255, 255), 
                color(0, 255, 0, 255)
            }
        });
        v149.elements.walking_dir = v149.elements.walking:create():slider("\v\226\164\183  \rLeft Leg", 0, 100, 50, nil, function(v165)
            if v165 == 50 then
                return "Default";
            else
                return nil;
            end;
        end):depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v149.elements.walking
        });
        v149.elements.walking_dir_2 = v149.elements.walking:create():slider("\v\226\164\183  \rRight leg", 0, 100, 0, nil, function(v166)
            if v166 == 0 then
                return "Default";
            else
                return nil;
            end;
        end):depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v149.elements.walking
        });
        v149.elements.custom_fakeduck.scale:depend(v149.elements.custom_fakeduck);
        v149.elements.screen_color:depend({
            [1] = nil, 
            [2] = "Screen 2D", 
            [1] = v149.elements.hitmarkers
        });
        v149.elements.screen_duration:depend({
            [1] = nil, 
            [2] = "Screen 2D", 
            [1] = v149.elements.hitmarkers
        });
        v149.elements.world_color:depend({
            [1] = nil, 
            [2] = "World 3D", 
            [1] = v149.elements.hitmarkers
        });
        v149.elements.custom_scope.rotated:depend(v149.elements.custom_scope);
        v149.elements.custom_scope.size:depend(v149.elements.custom_scope);
        v149.elements.custom_scope.gap:depend(v149.elements.custom_scope);
        v149.elements.custom_scope.main_accent:depend(v149.elements.custom_scope);
        v149.elements.custom_scope.edge_accent:depend(v149.elements.custom_scope);
        v149.elements.nickname = v149.elements.addons:create():input("\v\226\164\183  \rNickname", "Wie Wirs Machen"):depend({
            [1] = nil, 
            [2] = "Clientside nickname", 
            [1] = v149.elements.addons
        });
        v149.elements.allow_leaning_while_standing = v149.elements.leaning:create():switch("\v\226\164\183  \rAllow Standing Leaning");
        v149.elements.earthquake = v149.elements.leaning:create():switch("\v\226\164\183  \rEarthquake");
        v149.elements.keep_model_transparency.scale:depend(v149.elements.keep_model_transparency);
        v149.elements.arrows_accent = v149.elements.manual_arrows:create():color_picker("\v\226\128\162  \rAccent", color(255, 0, 0, 255)):depend(v149.elements.manual_arrows);
        v149.elements.arrows_font = v149.elements.manual_arrows:create():combo("    \v\226\164\183  \rFont", "Default", "Pixel", "Console", "Bold"):depend(v149.elements.manual_arrows);
        v149.elements.arrows_forward = v149.elements.manual_arrows:create():input("\v\226\128\162  \rForward", "^"):depend(v149.elements.manual_arrows);
        v149.elements.arrows_left = v149.elements.manual_arrows:create():input("\v\226\128\162  \rLeft", "<"):depend(v149.elements.manual_arrows);
        v149.elements.arrows_right = v149.elements.manual_arrows:create():input("\v\226\128\162  \rRight", ">"):depend(v149.elements.manual_arrows);
        v149.elements.allow_leaning_while_standing:depend({
            [1] = nil, 
            [2] = false, 
            [1] = v149.elements.earthquake
        });
        v149.elements.viewmodel.left_hand:depend({
            [1] = nil, 
            [2] = "Right", 
            [1] = v149.elements.viewmodel.main_hand
        });
        v149.elements.viewmodel.right_hand:depend({
            [1] = nil, 
            [2] = "Left", 
            [1] = v149.elements.viewmodel.main_hand
        });
        v149.aspect_ratio_ratios = {
            [161] = "  16:10  ", 
            [177] = "  16:9  ", 
            [125] = "  5:4  ", 
            [150] = "  3:2  ", 
            [133] = "  4:3  "
        };
        v149.itter = 0;
        for v167, v168 in pairs(v149.aspect_ratio_ratios) do
            v149.itter = v149.itter + 1;
            do
                local l_v167_0 = v167;
                v149.but = v149.elements.aspectratio:create():button(v168, function()
                    -- upvalues: v149 (ref), l_v167_0 (ref)
                    v149.other.elements.aspectratio.scale:set(l_v167_0);
                end);
            end;
        end;
    end
}):struct("tweaks")({
    fs_ref = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    get_aimbot_targets = function(_)
        local v171 = {};
        local v172 = entity.get_player_resource();
        for v173 = 1, globals.max_players do
            local v174 = entity.get(v173);
            if v174 ~= nil and v172.m_bConnected[v173] and v174:is_enemy() and v174:is_alive() then
                table.insert(v171, v174);
            end;
        end;
        return v171;
    end, 
    should_activate = function(_, v176, v177, v178)
        if v176 == 1 then
            return v177;
        elseif v176 == 2 then
            return #v178 == 0;
        else
            return false;
        end;
    end, 
    calculate_offset = function(_, v180, v181, v182, v183, v184)
        if v180 == "Spin" then
            return -math.fmod(globals.curtime * (v181 * 360), v182 * 2) + v182;
        elseif v180 == "Distortion" then
            return math.sin(globals.curtime * v181) * v182;
        else
            return globals.realtime % 0.2 >= 0.1 and v183 or v184;
        end;
    end, 
    createmove = function(v185, _)
        local v187 = entity.get_local_player();
        if not v187 or not v187:is_alive() then
            return;
        else
            local v188 = v185.antiaim.elements.options_table.tweaks:get() or {};
            local l_m_bWarmupPeriod_0 = entity.get_game_rules().m_bWarmupPeriod;
            local v190 = v185:get_aimbot_targets();
            local v191 = false;
            for _, v193 in ipairs(v188) do
                if v193 == "Warmup" then
                    if not v191 then
                        v191 = l_m_bWarmupPeriod_0;
                    end;
                elseif v193 == "No Enemies" and not v191 then
                    if #v190 ~= 0 then
                        v191 = false;
                    else
                        v191 = true;
                    end;
                end;
            end;
            if v191 then
                local v194 = v185.antiaim.elements.options_table.tweaks_pitch:get();
                v185.references.antiaim.angles.pitch:override(v194);
                local v195 = v185:calculate_offset(v185.antiaim.elements.options_table.tweaks_yaw_type:get(), v185.antiaim.elements.options_table.tweaks_speed:get(), v185.antiaim.elements.options_table.tweaks_range:get(), v185.antiaim.elements.options_table.tweaks_left_offset:get(), (v185.antiaim.elements.options_table.tweaks_right_offset:get()));
                v185.references.antiaim.angles.extract_yaw.offset:override(v195);
                v185.references.antiaim.angles.extract_desync.switch:override(false);
                v185.fs_ref:override(false);
            end;
            return;
        end;
    end, 
    init = function(v196)
        local function v198(v197)
            -- upvalues: v196 (ref)
            v196:createmove(v197);
        end;
        local function v200(v199)
            -- upvalues: v198 (ref)
            events.createmove(v198, v199);
        end;
        local _ = nil;
        local function v204(v202)
            -- upvalues: v200 (ref)
            local v203 = #v202:get() > 0;
            v200(v203);
        end;
        local l_tweaks_0 = v196.antiaim.elements.options_table.tweaks;
        l_tweaks_0:set_callback(v204, true);
        v204(l_tweaks_0);
    end
}):struct("fake_lag")({
    fake_lag_ticks = 16, 
    choked_ticks = -1, 
    fake_lag_ref = l_pui_0.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
    hs_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    dt_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    fd_ref = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    createmove = function(v206, v207)
        local v208 = entity.get_local_player();
        if not v208 or not v208:is_alive() then
            return;
        else
            local v209 = v208:get_player_weapon();
            if not v209 or v209 == nil then
                return;
            else
                local v210 = v209:get_classname() == "CDEagle";
                local v211 = entity.get_game_rules().m_bFreezePeriod == true;
                if v208.m_iShotsFired > 0 or v206.dt_ref:get() or v206.hs_ref:get() or v206.fd_ref:get() or v211 then
                    v206.fake_lag_ref:override();
                    return;
                else
                    if v206.antiaim.elements.options_table.fake_lag_type:get() == "Always on" then
                        if v206.choked_ticks < v206.fake_lag_ticks then
                            v207.send_packet = false;
                        else
                            v207.send_packet = true;
                            v206.choked_ticks = -1;
                        end;
                        v206.choked_ticks = v206.choked_ticks + 1;
                        v206.fake_lag_ref:override(false);
                    elseif v210 then
                        if v206.choked_ticks < v206.fake_lag_ticks then
                            v207.send_packet = false;
                        else
                            v207.send_packet = true;
                            v206.choked_ticks = -1;
                        end;
                        v206.choked_ticks = v206.choked_ticks + 1;
                        v206.fake_lag_ref:override(false);
                    else
                        v206.fake_lag_ref:override(true);
                    end;
                    return;
                end;
            end;
        end;
    end, 
    init = function(v212)
        local function v214(v213)
            -- upvalues: v212 (ref)
            v212:createmove(v213);
        end;
        local function v216(v215)
            -- upvalues: v214 (ref)
            events.createmove(v214, v215);
        end;
        local _ = nil;
        local function v219(v218)
            -- upvalues: v216 (ref), v212 (ref)
            v216(v218:get());
            v212.fake_lag_ref:override();
        end;
        v212.antiaim.elements.options_table.fake_lag:set_callback(v219, true);
    end
}):struct("manual_arrows")({
    padding = 40, 
    color_disabled = color(0, 0, 0, 127), 
    render = function(v220)
        local v221 = entity.get_local_player();
        if not v221 or not v221:is_alive() then
            return;
        else
            local v222 = v220.antiaim.elements.manual_yaw:get();
            local v223 = v220.other.elements.arrows_accent:get() or color(255, 255, 255, 255);
            local v224 = ({
                Console = 3, 
                Pixel = 2, 
                Default = 1, 
                Bold = 4
            })[v220.other.elements.arrows_font:get()] or "Custom";
            local v225 = render.screen_size();
            local v226 = vector(v225.x * 0.5, v225.y * 0.5);
            local v227, v228, v229 = v223:to_hsv();
            local v230 = math.abs(math.sin(globals.realtime * 2));
            local v231 = color():as_hsv(v227, v228, v229 * (0.5 + 0.5 * v230));
            local v232 = nil;
            local v233 = nil;
            if v222 == "Left" then
                v232 = v220.other.elements.arrows_left:get();
                local v234 = render.measure_text(v224, "", v232);
                v233 = vector(v226.x - v220.padding - v234.x, v226.y - v234.y * 0.5);
            elseif v222 == "Right" then
                v232 = v220.other.elements.arrows_right:get();
                local v235 = render.measure_text(v224, "", v232);
                v233 = vector(v226.x + v220.padding, v226.y - v235.y * 0.5);
            elseif v222 == "Forward" then
                v232 = v220.other.elements.arrows_forward:get();
                local v236 = render.measure_text(v224, "", v232);
                v233 = vector(v226.x - v236.x * 0.5, v226.y - v220.padding - v236.y);
            else
                return;
            end;
            render.text(v224, v233, v231, "", v232);
            return;
        end;
    end, 
    init = function(v237)
        local function v238()
            -- upvalues: v237 (ref)
            v237:render();
        end;
        local function v240(v239)
            -- upvalues: v238 (ref)
            events.render(v238, v239);
        end;
        local _ = nil;
        local function v243(v242)
            -- upvalues: v240 (ref)
            v240(v242:get());
        end;
        v237.other.elements.manual_arrows:set_callback(v243, true);
    end
}):struct("safe_head")({
    height = function(_)
        local v245 = entity.get_local_player();
        local v246 = entity.get_threat(false);
        local v247 = v246 ~= nil and v246:get_origin() or vector();
        return v245:get_origin().z - 35 > v247.z + 0;
    end, 
    check = function(v248)
        if v248.antiaim.elements.manual_yaw:get() ~= "Disabled" or v248.antiaim.elements.freestanding:get() then
            return;
        else
            local v249 = entity.get_local_player();
            if not v249 or not v249:is_alive() then
                return;
            elseif entity.get_threat(true) == nil then
                return;
            else
                local v250 = v249:get_player_weapon();
                if v250 == nil then
                    return;
                else
                    local v251 = v250:get_classname();
                    if v248.antiaim.elements.options_table.safe_head:get(1) and v248:height() and v248.localplayer:state() == 1 or v248.antiaim.elements.options_table.safe_head:get(2) and v248:height() and (v248.localplayer:state() == 4 or v248.localplayer:state() == 5) or v248.antiaim.elements.options_table.safe_head:get(3) and v248.localplayer:state() == 7 and (v251 == "CKnife" or v251 == "CWeaponTaser") then
                        v248.references.antiaim.angles.extract_yaw.offset:override(4);
                        v248.references.antiaim.angles.extract_modifier.offset:override(0);
                        v248.references.antiaim.angles.extract_desync.switch:override(true);
                        v248.references.antiaim.angles.extract_desync.left_limit:override(0);
                        v248.references.antiaim.angles.extract_desync.right_limit:override(0);
                    end;
                    return;
                end;
            end;
        end;
    end, 
    init = function(v252)
        local function v253()
            -- upvalues: v252 (ref)
            v252:check();
        end;
        events.createmove(v253);
    end
}):struct("log_events")({
    aim_fire = 0, 
    logs_ref = l_pui_0.find("Miscellaneous", "Main", "Other", "Log Events"), 
    nade_type = {
        knife = "Knifed", 
        inferno = "Burned", 
        hegrenade = "Naded"
    }, 
    console_print = function(v254, v255)
        local _ = v254.other.elements.log_events.main_accent:get();
        local v257 = v254.other.elements.log_events.prefix_accent:get():to_hex();
        local v258 = v254.other.elements.log_events.prefix:get();
        local v259 = {};
        local v260 = {};
        for v261 in v258:gmatch("%S+") do
            if v261 == "nh" then
                v259.use_hex = false;
            elseif v261 == "nb" then
                v259.use_brackets = false;
            elseif v261 == "np" then
                v259.use_prefix = false;
            elseif v261:match("p=") then
                v259.custom_prefix = v261:match("p=(.+)");
            elseif v261:match("b=") then
                v259.bracket_type = v261:match("b=(.+)");
            else
                table.insert(v260, v261);
            end;
        end;
        if not v259.custom_prefix and #v260 > 0 then
            v259.custom_prefix = table.concat(v260, " ");
        end;
        local v262 = {
            use_prefix = true, 
            use_brackets = true, 
            bracket_type = "[]", 
            use_hex = true, 
            custom_prefix = "Nyanza"
        };
        for v263, v264 in pairs(v262) do
            if v259[v263] == nil then
                v259[v263] = v264;
            end;
        end;
        local v265 = "";
        if v259.use_prefix then
            local l_custom_prefix_0 = v259.custom_prefix;
            if v259.use_hex then
                l_custom_prefix_0 = "\a" .. v257 .. l_custom_prefix_0 .. "\aDEFAULT";
            end;
            if v259.use_brackets then
                v265 = v259.bracket_type:sub(1, 1) .. l_custom_prefix_0 .. v259.bracket_type:sub(2, 2);
            else
                v265 = l_custom_prefix_0;
            end;
        end;
        if v265 ~= "" then
            print_raw(string.format("%s %s", v265, v255));
            print_dev(string.format("%s %s", v265, v255));
        else
            print_raw(v255);
            print_dev(v255);
        end;
    end, 
    on_aim_fire = function(v267, _)
        v267.aim_fire = globals.server_tick;
    end, 
    aim_ack = function(v269, v270)
        local v271 = math.max(globals.server_tick - v269.aim_fire - 1, 0);
        local l_target_0 = v270.target;
        local v273 = {
            [0] = "generic", 
            [1] = "head", 
            [2] = "chest", 
            [3] = "stomach", 
            [4] = "left arm", 
            [5] = "right arm", 
            [6] = "left leg", 
            [7] = "right leg", 
            [8] = "neck", 
            [9] = "generic", 
            [10] = "gear"
        };
        local l_state_0 = v270.state;
        local v275 = l_target_0:get_name();
        local l_m_iHealth_0 = l_target_0.m_iHealth;
        local _ = v270.spread;
        local l_backtrack_0 = v270.backtrack;
        local l_hitchance_0 = v270.hitchance;
        local l_damage_0 = v270.damage;
        local l_wanted_damage_0 = v270.wanted_damage;
        local v282 = v273[v270.hitgroup] or "body";
        local v283 = v273[v270.wanted_hitgroup] or "body";
        local v284 = v269.other.elements.log_events.main_accent:get():to_hex();
        if not l_target_0 then
            return;
        else
            if l_state_0 == "correction" or l_state_0 == "backtrack failure" then
                l_state_0 = "?";
            end;
            if not l_state_0 then
                v269:console_print(string.format("Hit \a%s%s%s \aDEFAULTin the \a%s%s\aDEFAULT%s for \a%s%d\aDEFAULT%s damage (hc: \a%s%d%%\aDEFAULT \a898989FF\194\183\aDEFAULT bt: \a%s%st\aDEFAULT)%s", v284, v275, l_m_iHealth_0 ~= 0 and string.format("\aDEFAULT(\aC6CBD1FF%shp\aDEFAULT)", l_m_iHealth_0) or "", v284, v282, v283 ~= v282 and string.format("(\aC6CBD1FF%s\aDEFAULT)", v283) or "", v284, l_damage_0, l_wanted_damage_0 ~= l_damage_0 and string.format("(\aC6CBD1FF%d\aDEFAULT)", l_wanted_damage_0) or "", v284, l_hitchance_0, v284, l_backtrack_0, v271 ~= 0 and string.format(" \aDEFAULT(delay=\a%s%.0fms\aDEFAULT)", v284, to_time(v271) * 1000) or ""));
            else
                v269:console_print(string.format("\aC6CBD1FFMissed \a%s%s\aDEFAULT's \a%s%s \aDEFAULTdue to \a%s%s\aDEFAULT (hc: \a%s%d%% \a898989FF\194\183\aDEFAULT bt: \a%s%dt\aDEFAULT) (damage: \a%s%shp\aDEFAULT)", v284, v275, v284, v283, v284, l_state_0, v284, l_hitchance_0, v284, l_backtrack_0, v284, l_wanted_damage_0));
            end;
            return;
        end;
    end, 
    player_hurt = function(v285, v286)
        local v287 = entity.get_local_player();
        local v288 = entity.get(v286.userid, true);
        local v289 = entity.get(v286.attacker, true);
        local v290 = v285.other.elements.log_events.main_accent:get():to_hex();
        if v288 == v287 or v289 ~= v287 or v285.nade_type[v286.weapon] == nil then
            return;
        else
            v285:console_print(string.format("\aC6CBD1FF%s \a%s%s%s \aDEFAULTfor \a" .. v290 .. "%s \aDEFAULTdamage", v285.nade_type[v286.weapon], v290, v288:get_name(), v286.health > 0 and string.format("\aDEFAULT(\aC6CBD1FF%shp\aDEFAULT)", v286.health) or "", v286.dmg_health));
            return;
        end;
    end, 
    item_purchase = function(v291, v292)
        local v293 = entity.get(v292.userid, true);
        local v294 = v291.other.elements.log_events.main_accent:get():to_hex();
        if v293 == nil or not v293:is_enemy() then
            return;
        else
            local l_weapon_0 = v292.weapon;
            if l_weapon_0 == "weapon_unknown" then
                return;
            else
                local v296 = {
                    weapon_p250 = "P250", 
                    weapon_knife = "Ct Knife", 
                    weapon_tec9 = "Tec-9", 
                    weapon_negev = "Negev", 
                    weapon_cz75a = "Cz75-auto", 
                    weapon_m249 = "M249", 
                    weapon_deagle = "Desert Eagle", 
                    weapon_scar20 = "Scar-20", 
                    weapon_revolver = "R8 Revolver", 
                    weapon_c4 = "C4", 
                    weapon_tablet = "Tablet", 
                    weapon_healthshot = "Medi-Shot", 
                    weapon_bumpmine = "Bump Mine", 
                    weapon_breachcharge = "Breach Charge", 
                    weapon_taser = "Zeus X27", 
                    weapon_snowball = "Snowball", 
                    weapon_hammer = "Hammer", 
                    weapon_spanner = "Wrench", 
                    weapon_axe = "Axe", 
                    weapon_fists = "Fists", 
                    weapon_knife_ursus = "Ursus Knife", 
                    weapon_knife_gypsy_jackknife = "Navaja Knife", 
                    weapon_knife_stiletto = "Stiletto Knife", 
                    weapon_knife_widowmaker = "Talon Knife", 
                    weapon_ump45 = "Ump-45", 
                    weapon_knife_survival_bowie = "Bowie Knife", 
                    weapon_mp7 = "Mp7", 
                    weapon_knife_push = "Shadow Daggers", 
                    weapon_mac10 = "Mac-10", 
                    weapon_knife_falchion = "Falchion Knife", 
                    weapon_mag7 = "Mag-7", 
                    weapon_knife_butterfly = "Butterfly Knife", 
                    weapon_sawedoff = "Sawed-Off", 
                    weapon_knife_tactical = "Huntsman Knife", 
                    weapon_xm1014 = "Xm1014", 
                    weapon_knife_gut = "Gut Knife", 
                    weapon_nova = "Nova", 
                    weapon_knife_flip = "Flip Knife", 
                    weapon_fiveseven = "Five-Seven", 
                    weapon_knife_karambit = "Karambit", 
                    weapon_hkp2000 = "P2000", 
                    weapon_knife_m9_bayonet = "M9 Bayonet", 
                    weapon_usp_silencer = "Usp-s", 
                    weapon_bayonet = "Bayonet", 
                    weapon_shield = "Ballistic Shield", 
                    weapon_knife_ghost = "Spectral Shiv", 
                    weapon_knifegg = "Golden Knife", 
                    weapon_knife_t = "T Knife", 
                    weapon_elite = "Dual Berettas", 
                    weapon_glock = "Glock-18", 
                    weapon_diversion = "Diversion Device", 
                    weapon_tagrenade = "Tag", 
                    weapon_incgrenade = "Molotov", 
                    weapon_g3sg1 = "G3sg1", 
                    weapon_molotov = "Molotov", 
                    weapon_awp = "Awp", 
                    weapon_smokegrenade = "Smoke", 
                    weapon_ssg08 = "Ssg 08", 
                    weapon_flashbang = "Flashbang", 
                    weapon_aug = "Aug", 
                    weapon_decoy = "Decoy", 
                    weapon_m4a4 = "M4a4", 
                    weapon_hegrenade = "HE", 
                    weapon_m4a1_silencer = "M4a1-s", 
                    item_heavyassaultsuit = "Heavy Assault Suit", 
                    weapon_famas = "Famas", 
                    item_cutters = "Rescue Kit", 
                    weapon_sg556 = "Sg 553", 
                    item_defuser = "Defuse Kit", 
                    weapon_ak47 = "Ak-47", 
                    item_kevlar = "Kevlar", 
                    weapon_galilar = "Galil Ar", 
                    item_assaultsuit = "Kevlar + Helmet", 
                    weapon_mp5sd = "Mp5-SD", 
                    weapon_mp9 = "Mp9", 
                    weapon_bizon = "PP-Bizon", 
                    weapon_p90 = "P90"
                };
                local function v298(v297)
                    -- upvalues: v296 (ref)
                    return v296[v297] or v297:gsub("^weapon_", ""):gsub("^item_", ""):gsub("_", " "):gsub(" ar$", ""):gsub(" m4a1", "m4a1");
                end;
                local v299 = v293:get_name();
                v291:console_print(string.format("\a%s%s \aDEFAULTbought \a%s%s\aDEFAULT", v294, v299, v294, v298(l_weapon_0)));
                return;
            end;
        end;
    end, 
    init = function(v300)
        v300.logs_ref:override("");
        local function v301()
            -- upvalues: v300 (ref)
            v300:on_aim_fire();
        end;
        local function v303(v302)
            -- upvalues: v300 (ref)
            v300:aim_ack(v302);
        end;
        local function v305(v304)
            -- upvalues: v300 (ref)
            v300:player_hurt(v304);
        end;
        local function v307(v306)
            -- upvalues: v300 (ref)
            v300:item_purchase(v306);
        end;
        local function v309(v308)
            -- upvalues: v301 (ref), v303 (ref), v305 (ref)
            events.aim_fire(v301, v308);
            events.aim_ack(v303, v308);
            events.player_hurt(v305, v308);
        end;
        local function v311(v310)
            -- upvalues: v307 (ref)
            events.item_purchase(v307, v310);
        end;
        local _ = nil;
        local function v314(v313)
            -- upvalues: v309 (ref)
            v309(v313:get());
        end;
        local function v316(v315)
            -- upvalues: v311 (ref)
            v311(v315:get());
        end;
        v300.other.elements.log_events.damage_dealt:set_callback(v314, true);
        v300.other.elements.log_events.purchases:set_callback(v316, true);
    end
}):struct("clantag")({
    speed = 4, 
    step = 1, 
    ref = l_pui_0.find("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
    list = {
        [1] = "5", 
        [2] = "55", 
        [3] = "5 55", 
        [4] = "5 5 5", 
        [5] = "55 5", 
        [6] = "555", 
        [7] = "555", 
        [8] = "55", 
        [9] = "5", 
        [10] = "", 
        [11] = "ko", 
        [12] = "kop", 
        [13] = "kopf", 
        [14] = "kopfs", 
        [15] = "kopfsc", 
        [16] = "kopfsch", 
        [17] = "kopfschu", 
        [18] = "kopfschuss", 
        [19] = "kopfschuss", 
        [20] = "kopfschuss", 
        [21] = "kopfschuss", 
        [22] = "kopfschuss", 
        [23] = "kopfschuss", 
        [24] = "kopfschuss", 
        [25] = "kopfschuss", 
        [26] = "kopfschuss", 
        [27] = "kopfschuss", 
        [28] = "kopfschuss", 
        [29] = "kopfschuss", 
        [30] = "pfschuss", 
        [31] = "fschuss", 
        [32] = "schuss", 
        [33] = "chuss", 
        [34] = "uss", 
        [35] = "ss", 
        [36] = ""
    }, 
    run = function(v317)
        local function v319()
            -- upvalues: v317 (ref)
            local v318 = math.floor(globals.curtime * v317.speed + 0.5) % #v317.list + 1;
            if v318 == v317.step then
                return;
            else
                v317.step = v318;
                v317.ref:override(false);
                common.set_clan_tag(v317.list[v318]);
                return;
            end;
        end;
        v317.other.elements.clan_tag:set_callback(function(v320)
            -- upvalues: v319 (ref)
            if v320:get() then
                events.net_update_end:set(v319);
            else
                events.net_update_end:unset(v319);
                common.set_clan_tag("");
            end;
        end, true);
        events.shutdown:set(function()
            -- upvalues: v317 (ref)
            common.set_clan_tag("");
            v317.ref:override();
        end);
    end
}):struct("fast_ladder")({
    createmove = function(_, v322)
        local v323 = entity.get_local_player();
        if not v323 or not v323:is_alive() then
            return;
        elseif v323.m_MoveType ~= 9 then
            return;
        else
            local _ = render.camera_angles();
            v322.view_angles.y = math.floor(0.5 + v322.view_angles.y);
            v322.view_angles.z = 0;
            if v322.forwardmove > 0 then
                v322.view_angles.x = 89;
                v322.in_moveright = 1;
                v322.in_moveleft = 0;
                v322.in_forward = 0;
                v322.in_back = 1;
                if v322.sidemove == 0 then
                    v322.view_angles.y = v322.view_angles.y + 90;
                end;
                if v322.sidemove < 0 then
                    v322.view_angles.y = v322.view_angles.y + 150;
                end;
                if v322.sidemove > 0 then
                    v322.view_angles.y = v322.view_angles.y + 30;
                end;
            elseif v322.forwardmove < 0 then
                v322.view_angles.x = 89;
                v322.in_moveleft = 1;
                v322.in_moveright = 0;
                v322.in_forward = 1;
                v322.in_back = 0;
                if v322.sidemove == 0 then
                    v322.view_angles.y = v322.view_angles.y + 90;
                end;
                if v322.sidemove > 0 then
                    v322.view_angles.y = v322.view_angles.y + 150;
                end;
                if v322.sidemove < 0 then
                    v322.view_angles.y = v322.view_angles.y + 30;
                end;
            end;
            return;
        end;
    end, 
    init = function(v325)
        local function v327(v326)
            -- upvalues: v325 (ref)
            v325:createmove(v326);
        end;
        local function v329(v328)
            -- upvalues: v327 (ref)
            events.createmove(v327, v328);
        end;
        local _ = nil;
        local function v332(v331)
            -- upvalues: v329 (ref)
            v329(v331:get());
        end;
        v325.other.elements.fast_ladder:set_callback(v332, true);
    end
}):struct("no_fall_damage")({
    should_jump = false, 
    last_no_fall_damage_state = false, 
    no_fall_damage = false, 
    trace = function(_, v334)
        local v335 = entity.get_local_player();
        return utils.trace_line(v335:get_origin(), v335:get_origin() + vector(0, 0, -v334), v335).fraction < 1;
    end, 
    createmove = function(v336, v337)
        local v338 = entity.get_local_player();
        if not v338 or not v338:is_alive() then
            return;
        else
            v336.velocity_z = v338.m_vecVelocity.z;
            if v336.velocity_z > -400 then
                return;
            else
                v336.new_state = v336.velocity_z < -400 and not v336:trace(15);
                if v336.new_state ~= v336.last_no_fall_damage_state then
                    v336.no_fall_damage = v336.new_state;
                    v336.last_no_fall_damage_state = v336.new_state;
                end;
                if v336.velocity_z < -600 then
                    v337.in_duck = v336.no_fall_damage and 1 or 0;
                end;
                return;
            end;
        end;
    end, 
    init = function(v339)
        local function v341(v340)
            -- upvalues: v339 (ref)
            v339:createmove(v340);
        end;
        local function v343(v342)
            -- upvalues: v341 (ref)
            events.createmove(v341, v342);
        end;
        local _ = nil;
        local function v346(v345)
            -- upvalues: v343 (ref)
            v343(v345:get());
        end;
        v339.other.elements.no_fall_damage:set_callback(v346, true);
    end
}):struct("force_break_lc")({
    lag_option_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    hide_shots_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    update = function(v347, v348)
        local v349 = entity.get_local_player();
        if not v349 or not v349:is_alive() then
            return;
        else
            local v350 = v349:get_player_weapon();
            if v350 == nil then
                return;
            else
                local v351 = v350 and v350:get_classname();
                if v347.antiaim.elements.disable_lc_grenade:get() and v351:find("Grenade") then
                    v347.lag_option_ref:override("On Peek");
                    v347.hide_shots_ref:set("Favor Fire Rate");
                    return;
                else
                    v347.hide_shots_ref:override(v347.antiaim.elements.hide_shots:get());
                    local v352, v353 = v347.localplayer:state(v348);
                    local v354 = {};
                    if v347.antiaim.elements.force_break_lc:get(v352) then
                        v347.lag_option_ref:override("Always on");
                        if v347.antiaim.data[v352][v353].tickbase:get() ~= "Neverlose" then
                            if v347.antiaim.data[v352][v353].tickbase_randomize:get() then
                                if v347.antiaim.data[v352][v353].tickbase_rndm_type:get() == "Default" then
                                    v348.force_defensive = v348.command_number % math.random(v347.antiaim.data[v352][v353].tickbase_rndm:get(), v347.antiaim.data[v352][v353].tickbase_rndm_2:get()) == 0;
                                else
                                    for v355 = 1, v347.antiaim.data[v352][v353].tickbase_sliders:get() do
                                        table.insert(v354, v347.antiaim.data[v352][v353]["tickbase_" .. v355]:get());
                                    end;
                                    local v356 = math.random(1, v347.antiaim.data[v352][v353].tickbase_sliders:get());
                                    v348.force_defensive = v348.command_number % v354[v356] == 0;
                                end;
                            else
                                v348.force_defensive = v348.command_number % v347.antiaim.data[v352][v353].tickbase_choke:get() == 0;
                            end;
                        end;
                    else
                        v347.lag_option_ref:override("On Peek");
                    end;
                    return;
                end;
            end;
        end;
    end, 
    init = function(v357)
        local function v359(v358)
            -- upvalues: v357 (ref)
            v357:update(v358);
        end;
        events.createmove(v359);
    end
}):struct("player_animations")({
    walk_directory_ref = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    update = function(v360)
        local v361 = entity.get_local_player();
        if not v361 or not v361:is_alive() then
            return;
        else
            v360.leaning_layer = ffi.cast("CAnimationLayer**", ffi.cast("uintptr_t", v361[0]) + 10640)[0][12];
            v360.velocity = v361.m_vecVelocity:length();
            v360.left_direction = v360.other.elements.walking_dir:get();
            v360.right_direction = v360.other.elements.walking_dir_2:get();
            v360.tick_factor = 1 / (globals.tickcount % 8 >= 4 and 200 or 400);
            v360.apply = globals.tickcount % 4 >= 2 and v360.left_direction or v360.right_direction;
            if v360.other.elements.leaning:get() ~= 0 then
                if not v360.other.elements.earthquake:get() then
                    if v360.other.elements.allow_leaning_while_standing:get() then
                        v360.leaning_layer.m_flWeight = v360.other.elements.leaning:get() / 100;
                    elseif not v360.other.elements.allow_leaning_while_standing:get() and v360.velocity > 3 then
                        v360.leaning_layer.m_flWeight = v360.other.elements.leaning:get() / 100;
                    end;
                else
                    v360.leaning_layer.m_flWeight = math.random(0, 10) / 10;
                end;
            end;
            if v360.other.elements.falling:get() ~= 0 then
                v361.m_flPoseParameter[6] = v360.other.elements.falling:get() / 10;
            end;
            if v360.other.elements.walking:get() == 1 then
                v360.walk_directory_ref:override("Walking");
                v361.m_flPoseParameter[7] = 0;
            elseif v360.other.elements.walking:get() == 2 then
                v360.walk_directory_ref:override("Sliding");
                v361.m_flPoseParameter[0] = v360.apply * v360.tick_factor;
                v361.m_flPoseParameter[7] = v360.apply * v360.tick_factor;
            else
                v360.walk_directory_ref:override();
            end;
            return;
        end;
    end, 
    init = function(v362)
        local function v363()
            -- upvalues: v362 (ref)
            v362:update();
        end;
        events.post_update_clientside_animation(v363);
    end
}):struct("freezetime_fakeduck")({
    cnt = 0, 
    ready = false, 
    fakeduck_ref = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    dt_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hs_ref = l_pui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    createmove = function(v364, v365)
        local v366 = entity.get_local_player();
        if not v366 or not v366:is_alive() then
            return;
        else
            local v367 = entity.get_game_rules();
            if not v367.m_bFreezePeriod == true then
                v364.dt_ref:override();
                v364.hs_ref:override();
                return;
            else
                if v367.m_bFreezePeriod == true and v364.fakeduck_ref:get() then
                    v364.dt_ref:override(false);
                    v364.hs_ref:override(false);
                    v365.send_packet = false;
                    should = false;
                    if v364.cnt % 14 == 0 then
                        v364.ready = true;
                    elseif v364.cnt % 14 == 6 then
                        v365.send_packet = true;
                    elseif v364.cnt % 14 == 7 then
                        v364.ready = false;
                    end;
                    if v364.ready then
                        v365.in_duck = true;
                    else
                        v365.in_duck = false;
                    end;
                    v364.cnt = v364.cnt + 1;
                else
                    v364.dt_ref:override();
                    v364.hs_ref:override();
                    v364.ready = false;
                    v364.cnt = 0;
                    should = true;
                end;
                return;
            end;
        end;
    end, 
    override_view = function(v368, v369)
        local v370 = entity.get_local_player();
        if not v370 or not v370:is_alive() then
            return;
        else
            local v371 = entity.get_game_rules();
            if not v371.m_bFreezePeriod == true then
                return;
            else
                if v371.m_bFreezePeriod == true and v368.fakeduck_ref:get() then
                    v369.camera.z = v370:get_origin().z + 64;
                end;
                return;
            end;
        end;
    end, 
    init = function(v372)
        local function v374(v373)
            -- upvalues: v372 (ref)
            v372:createmove(v373);
        end;
        local function v376(v375)
            -- upvalues: v372 (ref)
            v372:override_view(v375);
        end;
        local function v378(v377)
            -- upvalues: v374 (ref), v376 (ref)
            events.createmove(v374, v377);
            events.override_view(v376, v377);
        end;
        local _ = nil;
        local function v381(v380)
            -- upvalues: v378 (ref)
            v378(v380:get());
        end;
        v372.other.elements.freezetime_fakeduck:set_callback(v381, true);
    end
}):struct("fakeduck_speed")({
    fakeduck_ref = l_pui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    createmove_run = function(v382, v383)
        if not v382.fakeduck_ref:get() then
            return;
        else
            local v384 = entity.get_local_player();
            if not v384 or not v384:is_alive() then
                return;
            else
                local l_m_vecVelocity_0 = v384.m_vecVelocity;
                if math.abs(l_m_vecVelocity_0.y) > 10 or math.abs(l_m_vecVelocity_0.x) > 10 then
                    local v386 = vector(v383.forwardmove, v383.sidemove);
                    if v386:length() > 0 then
                        v386:normalize();
                        local v387 = v382.other.elements.custom_fakeduck.scale:get();
                        v383.forwardmove = v386.x * v387;
                        v383.sidemove = v386.y * v387;
                    end;
                end;
                return;
            end;
        end;
    end, 
    init = function(v388)
        local function v390(v389)
            -- upvalues: v388 (ref)
            v388:createmove_run(v389);
        end;
        local function v392(v391)
            -- upvalues: v390 (ref)
            events.createmove_run(v390, v391);
        end;
        local _ = nil;
        local function v395(v394)
            -- upvalues: v392 (ref)
            v392(v394:get());
        end;
        v388.other.elements.custom_fakeduck:set_callback(v395, true);
    end
}):struct("hitmarkers")({
    hit_wait_time = 0.25, 
    hit_fade_time = 0.25, 
    fade_duration = 1, 
    is_hit = false, 
    hit_markers = {}, 
    init = function(v396)
        local function v397()
            -- upvalues: v396 (ref)
            v396:draw_hit_markers();
            v396:draw_hit_indicator();
        end;
        local function v398()
            -- upvalues: v396 (ref)
            v396.is_hit = false;
            v396.fade_duration = 1;
            v396.hit_fade_time = 0.25;
            v396.hit_wait_time = 0.25;
            v396.hit_markers = {};
        end;
        local function v400(v399)
            -- upvalues: v396 (ref)
            v396:handle_player_spawn(v399);
        end;
        local function v402(v401)
            -- upvalues: v396 (ref)
            v396:handle_shot_fired(v401);
        end;
        local function v404(v403)
            -- upvalues: v396 (ref)
            v396:handle_player_hit(v403);
        end;
        events.render(v397);
        events.round_start(v398);
        events.player_spawned(v400);
        events.aim_ack(v402);
        events.player_hurt(v404);
    end, 
    handle_player_hit = function(v405, v406)
        if entity.get_local_player() == entity.get(v406.attacker, true) then
            v405.is_hit = true;
            v405.hit_fade_time = 0.25;
            v405.hit_wait_time = 0.25;
            v405.fade_duration = v405.other.elements.screen_duration:get();
        end;
    end, 
    handle_player_spawn = function(v407, v408)
        if entity.get_local_player() == entity.get(v408.userid, true) then
            v407.hit_fade_time = 0.25;
            v407.hit_wait_time = 0.5;
            v407.fade_duration = 1;
            v407.is_hit = false;
            v407.hit_markers = {};
        end;
    end, 
    draw_hit_indicator = function(v409)
        if not v409.other.elements.hitmarkers:get(1) then
            return;
        elseif not globals.is_in_game then
            return;
        elseif not v409.is_hit then
            return;
        else
            v409.hit_wait_time = v409.hit_wait_time - globals.frametime;
            if v409.hit_wait_time <= 0 then
                v409.fade_duration = v409.fade_duration - globals.frametime / v409.hit_fade_time;
            end;
            local v410 = render.screen_size();
            local v411 = v410.x / 2;
            local v412 = v410.y / 2;
            local v413 = v409.other.elements.screen_color:get() * v409.fade_duration;
            for _, v415 in pairs({
                [1] = {
                    [1] = 5, 
                    [2] = 5, 
                    [3] = 10, 
                    [4] = 10
                }, 
                [2] = {
                    [1] = -5, 
                    [2] = 5, 
                    [3] = -10, 
                    [4] = 10
                }, 
                [3] = {
                    [1] = -5, 
                    [2] = -5, 
                    [3] = -10, 
                    [4] = -10
                }, 
                [4] = {
                    [1] = 5, 
                    [2] = -5, 
                    [3] = 10, 
                    [4] = -10
                }
            }) do
                render.line(vector(v411 + v415[1], v412 + v415[2]), vector(v411 + v415[3], v412 + v415[4]), v413);
            end;
            return;
        end;
    end, 
    draw_hit_markers = function(v416)
        if not v416.other.elements.hitmarkers:get(2) then
            return;
        else
            local v417, v418 = v416.other.elements.world_color:get();
            for v419, v420 in pairs(v416.hit_markers) do
                if v420.fade_time <= 0 then
                    v416.hit_markers[v419] = nil;
                else
                    v420.wait_time = v420.wait_time - globals.frametime;
                    if v420.wait_time <= 0 then
                        v420.fade_time = v420.fade_time - globals.frametime / v416.hit_fade_time;
                    end;
                    if v420.position and not v420.reason then
                        local v421 = render.world_to_screen(v420.position);
                        if v421 then
                            local v422 = nil;
                            local v423 = nil;
                            if v417 == "Double" then
                                v422 = v418[1];
                                v423 = v418[2];
                            else
                                local v424 = v416.other.elements.world_color:get("Simple")[1];
                                v422 = v424;
                                v423 = v424;
                            end;
                            render.rect(vector(v421.x - 1, v421.y - 5), vector(v421.x + 1, v421.y + 5), color(v423.r, v423.g, v423.b, (v423.a or 255) * v420.fade_time), 0, true);
                            render.rect(vector(v421.x - 5, v421.y - 1), vector(v421.x + 5, v421.y + 1), color(v422.r, v422.g, v422.b, (v422.a or 255) * v420.fade_time), 0, true);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end, 
    handle_shot_fired = function(v425, v426)
        v425.hit_markers[v426.id] = {
            fade_time = 1, 
            position = v426.aim, 
            wait_time = v425.hit_wait_time, 
            reason = v426.state
        };
    end
}):struct("keep_transparency")({
    transparency = 255, 
    handler = function(v427, v428)
        local v429 = entity.get_local_player();
        if not v429 or not v429:is_alive() then
            return v428;
        elseif not v427.other.elements.keep_model_transparency:get() then
            v427.transparency = 255;
            return v428;
        else
            local v430 = v429:get_player_weapon();
            if not v430 then
                return v428;
            else
                local v431 = v430:get_classname() or "";
                if v431:find("Grenade") or v431:find("Flashbang") then
                    return v428;
                else
                    local v432 = v427.other.elements.keep_model_transparency.scale:get();
                    local v433 = v429.m_bIsScoped or v429.m_bResumeZoom;
                    if v433 and v427.transparency > 60 then
                        v427.transparency = v427.transparency - v432;
                        if v427.transparency < 60 then
                            v427.transparency = 60;
                        end;
                    elseif not v433 and v427.transparency < 255 then
                        v427.transparency = v427.transparency + v432;
                        if v427.transparency > 255 then
                            v427.transparency = 255;
                        end;
                    end;
                    return v427.transparency;
                end;
            end;
        end;
    end, 
    init = function(v434)
        events.localplayer_transparency(function(v435)
            -- upvalues: v434 (ref)
            return v434:handler(v435);
        end);
    end
}):struct("scope_overlay")({
    animation_speed = 16, 
    animated_size = 0, 
    animated_gap = 0, 
    overlay_ref = l_pui_0.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    lerp = function(_, v437, v438, v439)
        return v437 + (v438 - v437) * math.min(v439, 1);
    end, 
    render = function(v440)
        v440.overlay_ref:override("Remove All");
        v440.enabled = v440.other.elements.custom_scope:get();
        v440.rotated = v440.other.elements.custom_scope.rotated:get();
        v440.size = v440.other.elements.custom_scope.size:get();
        v440.gap = v440.other.elements.custom_scope.gap:get();
        v440.color = {
            main = v440.other.elements.custom_scope.main_accent:get(), 
            edge = v440.other.elements.custom_scope.edge_accent:get()
        };
        local v441 = globals.frametime * v440.animation_speed;
        v440.animated_gap = v440:lerp(v440.animated_gap, v440.gap, v441);
        v440.animated_size = v440:lerp(v440.animated_size, v440.size, v441);
        if not v440.enabled then
            return v440.overlay_ref:override();
        else
            local v442 = entity.get_local_player();
            if not v442 or not v442:is_alive() or not v442.m_bIsScoped then
                return;
            else
                local v443 = render.screen_size();
                local v444 = vector(math.floor(v443.x / 2 + 0.5), math.floor(v443.y / 2 + 0.5));
                local v445 = 1;
                if v440.rotated then
                    render.push_rotation(45, render.screen_size() / 2 + 1);
                end;
                render.gradient(vector(v444.x, v444.y - v440.animated_gap - v440.animated_size), vector(v444.x + v445, v444.y - v440.animated_gap), v440.color.edge, v440.color.edge, v440.color.main, v440.color.main);
                render.gradient(vector(v444.x, v444.y + v440.animated_gap + 1), vector(v444.x + v445, v444.y + v440.animated_gap + v440.animated_size), v440.color.main, v440.color.main, v440.color.edge, v440.color.edge);
                render.gradient(vector(v444.x - v440.animated_gap - v440.animated_size, v444.y), vector(v444.x - v440.animated_gap, v444.y + v445), v440.color.edge, v440.color.main, v440.color.edge, v440.color.main);
                render.gradient(vector(v444.x + v440.animated_gap + 1, v444.y), vector(v444.x + v440.animated_gap + v440.animated_size, v444.y + v445), v440.color.main, v440.color.edge, v440.color.main, v440.color.edge);
                if v440.rotated then
                    render.pop_rotation();
                end;
                return;
            end;
        end;
    end, 
    init = function(v446)
        local function v447()
            -- upvalues: v446 (ref)
            v446:render();
        end;
        local function v448()
            -- upvalues: v446 (ref)
            v446.overlay_ref:override();
        end;
        local function v450(v449)
            -- upvalues: v446 (ref), v447 (ref), v448 (ref)
            v446.overlay_ref:override(v449 and "Remove All" or "Remove Overlay");
            events.render(v447, v449);
            events.shutdown(v448, v449);
        end;
        local _ = nil;
        local function v453(v452)
            -- upvalues: v450 (ref)
            v450(v452:get());
        end;
        v446.other.elements.custom_scope:set_callback(v453, true);
    end
}):struct("damage_indicator")({
    ref_dmg_override = l_pui_0.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    render = function(_)
        -- upvalues: l_pui_0 (ref)
        local v455 = render.screen_size();
        local v456 = entity.get_local_player();
        if not v456 or not v456:is_alive() then
            return;
        else
            for _, v458 in pairs(l_pui_0.get_binds()) do
                if v458.name == "Min. Damage" and v458.active then
                    render.text(1, vector(v455.x / 2 + 4, v455.y / 2 - 15), color(), "", v458.value);
                    break;
                end;
            end;
            return;
        end;
    end, 
    init = function(v459)
        local function v460()
            -- upvalues: v459 (ref)
            v459:render();
        end;
        local function v462(v461)
            -- upvalues: v460 (ref)
            events.render(v460, v461);
        end;
        local _ = nil;
        local function v465(v464)
            -- upvalues: v462 (ref)
            v462(v464:get());
        end;
        v459.other.elements.damage_indicator:set_callback(v465, true);
    end
}):struct("addons")({
    maxunlag = cvar.sv_maxunlag, 
    teammates_enemies = cvar.mp_teammates_are_enemies, 
    foot_shadows = cvar.cl_foot_contact_shadows, 
    use_buy = cvar.cl_use_opens_buy_menu, 
    legacy_desync = cvar.sv_legacy_desync, 
    clear = cvar.clear, 
    native_BaseLocalClient_base = ffi.cast("uintptr_t**", utils.opcode_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1)), 
    apply_values = function(v466)
        local v467 = entity.get_local_player();
        if not v467 or not v467:is_alive() then
            return;
        else
            if v466.other.elements.unlock_fakelatency:get() then
                v466.maxunlag:float(0.4);
            else
                v466.maxunlag:float(0.2);
            end;
            if v466.other.elements.force_teamaimbot:get() then
                v466.teammates_enemies:int(1);
            else
                v466.teammates_enemies:int(0);
            end;
            if v466.other.elements.addons:get(1) then
                v466.foot_shadows:int(0);
            else
                v466.foot_shadows:int(1);
            end;
            if v466.other.elements.addons:get(2) then
                v466.use_buy:int(0);
            else
                v466.use_buy:int(1);
            end;
            if v466.other.elements.addons:get(4) then
                v466.legacy_desync:int(v467.m_iShotsFired > 0 and 0 or 1);
            else
                v466.legacy_desync:int(0);
            end;
            return;
        end;
    end, 
    round_start = function(v468)
        if v468.other.elements.addons:get(6) then
            v468.clear:call();
        end;
    end, 
    draw_model = function(v469, v470)
        if entity.get_local_player() and v469.other.elements.addons:get(3) then
            return not v470.name:find("sleeve");
        else
            return true;
        end;
    end, 
    clientside_nickname = function(v471)
        v471.player_info_t = ffi.typeof("                struct {\n                    int64_t         unknown;\n                    int64_t         steamID64;\n                    char            szName[128];\n                    int             userId;\n                    char            szSteamID[20];\n                    char            pad_0x00A8[0x10];\n                    unsigned long   iSteamID;\n                    char            szFriendsName[128];\n                    bool            fakeplayer;\n                    bool            ishltv;\n                    unsigned int    customfiles[4];\n                    unsigned char   filesdownloaded;\n                }\n            ");
        v471.native_GetStringUserData = utils.get_vfunc(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", v471.player_info_t));
        v471.previous_name = nil;
        v471.apply_nickname = function(v472)
            -- upvalues: v471 (ref)
            local v473 = entity.get_local_player();
            if not v473 or not v473:is_alive() then
                return;
            else
                v471.native_BaseLocalClient = v471.native_BaseLocalClient_base[0][0];
                if not v471.native_BaseLocalClient then
                    return;
                else
                    v471.native_UserInfoTable = ffi.cast("void***", v471.native_BaseLocalClient + 21184)[0];
                    if not v471.native_UserInfoTable then
                        return;
                    else
                        v471.data = v471.native_GetStringUserData(v471.native_UserInfoTable, v473:get_index() - 1, nil);
                        if not v471.data then
                            return;
                        else
                            v471.this_name = ffi.string(v471.data[0].szName);
                            if v472 ~= v471.this_name and v471.previous_name == nil then
                                v471.previous_name = v471.this_name;
                            end;
                            ffi.copy(v471.data[0].szName, v472, #v472 + 1);
                            return;
                        end;
                    end;
                end;
            end;
        end;
        v471.was_applied = false;
        v471.callback = function()
            -- upvalues: v471 (ref)
            v471.chosen_nick = v471.other.elements.nickname:get():sub(0, 32);
            v471.other.elements.nickname:set(v471.chosen_nick);
            if not v471.other.elements.addons:get(5) or #v471.chosen_nick == 0 then
                if v471.was_applied then
                    v471.was_applied = false;
                    v471.apply_nickname(v471.previous_name or panorama.MyPersonaAPI.GetName());
                    previous_name = nil;
                end;
                return;
            else
                v471.was_applied = true;
                v471.apply_nickname(v471.chosen_nick);
                return;
            end;
        end;
        v471.other.elements.addons:set_callback(v471.callback);
    end, 
    init = function(v474)
        local function v475()
            -- upvalues: v474 (ref)
            v474:round_start();
        end;
        local function v476()
            -- upvalues: v474 (ref)
            v474:apply_values();
        end;
        local function v477()
            -- upvalues: v474 (ref)
            v474.maxunlag:float(0.2);
            v474.teammates_enemies:int(0);
            v474.foot_shadows:int(1);
            v474.use_buy:int(1);
            v474.legacy_desync:int(0);
            v474.apply_nickname(panorama.MyPersonaAPI.GetName());
        end;
        v474:clientside_nickname();
        events.net_update_start(function()
            -- upvalues: v474 (ref)
            v474.callback();
        end);
        events.net_update_end(function()
            -- upvalues: v474 (ref)
            v474.callback();
        end);
        events.draw_model:set(function(v478)
            -- upvalues: v474 (ref)
            return v474:draw_model(v478);
        end);
        events.round_start(v475);
        events.render(v476);
        events.shutdown(v477);
    end
}):struct("viewmodel")({
    target_fov = 68, 
    lerp_speed = 0.05, 
    current_z = 68, 
    current_y = 68, 
    current_x = 68, 
    current_fov = 68, 
    target_z = 0, 
    target_y = 0, 
    target_x = 0, 
    cvar_fov = cvar.viewmodel_fov, 
    cvar_axis_x = cvar.viewmodel_offset_x, 
    cvar_axis_y = cvar.viewmodel_offset_y, 
    cvar_axis_z = cvar.viewmodel_offset_z, 
    raw_hand = cvar.cl_righthand:int(), 
    lerp = function(_, v480, v481, v482)
        return v480 + (v481 - v480) * v482;
    end, 
    update = function(v483)
        v483.target_fov = v483.other.elements.viewmodel.fov:get();
        v483.target_x = v483.other.elements.viewmodel.axis_x:get() / 10;
        v483.target_y = v483.other.elements.viewmodel.axis_y:get() / 10;
        v483.target_z = v483.other.elements.viewmodel.axis_z:get() / 10;
    end, 
    apply_value = function(v484)
        local _ = entity.get_local_player();
        v484.current_fov = v484:lerp(v484.current_fov, v484.target_fov, v484.lerp_speed);
        v484.current_x = v484:lerp(v484.current_x, v484.target_x, v484.lerp_speed);
        v484.current_y = v484:lerp(v484.current_y, v484.target_y, v484.lerp_speed);
        v484.current_z = v484:lerp(v484.current_z, v484.target_z, v484.lerp_speed);
        v484.cvar_fov:float(v484.current_fov, true);
        v484.cvar_axis_x:float(v484.current_x, true);
        v484.cvar_axis_y:float(v484.current_y, true);
        v484.cvar_axis_z:float(v484.current_z, true);
    end, 
    apply_hand = function(v486)
        local v487 = entity.get_local_player();
        if not v487 or not v487:is_alive() then
            return;
        else
            local v488 = v486.other.elements.viewmodel.main_hand:get();
            local v489 = v487:get_player_weapon();
            if not v489 or v489 == nil then
                return;
            else
                local v490 = v489:get_classname() == "CKnife";
                local l_cl_righthand_0 = cvar.cl_righthand;
                local l_l_cl_righthand_0_0 = l_cl_righthand_0;
                l_cl_righthand_0 = l_cl_righthand_0.int;
                local v493;
                if v490 then
                    v493 = v488 == "Right" and v486.other.elements.viewmodel.left_hand:get() and 0 or v488 == "Left" and v486.other.elements.viewmodel.right_hand:get() and 1 or v488 == "Right" and 1 or 0;
                else
                    v493 = v488 == "Right" and 1 or 0;
                end;
                l_cl_righthand_0(l_l_cl_righthand_0_0, v493);
                return;
            end;
        end;
    end, 
    init = function(v494)
        local function v495()
            -- upvalues: v494 (ref)
            v494:update();
            v494:apply_value();
            v494:apply_hand();
        end;
        events.render(v495);
    end
}):struct("aspectratio")({
    target_value = 100, 
    current_value = 100, 
    lerp_speed = 0.05, 
    cvar_aspectratio = cvar.r_aspectratio, 
    lerp = function(_, v497, v498, v499)
        return v497 + (v498 - v497) * v499;
    end, 
    update = function(v500)
        v500.target_value = v500.other.elements.aspectratio.scale:get();
    end, 
    apply_value = function(v501)
        v501.current_value = v501:lerp(v501.current_value, v501.target_value, v501.lerp_speed);
        v501.cvar_aspectratio:float(v501.current_value / 100);
    end, 
    init = function(v502)
        local function v503()
            -- upvalues: v502 (ref)
            v502:update();
            v502:apply_value();
        end;
        local function v504()
            -- upvalues: v502 (ref)
            v502.cvar_aspectratio:float(0);
        end;
        events.render(v503);
        events.shutdown(v504);
    end
}):struct("antiaim_data")({
    last_flick_at = 0, 
    flicker = false, 
    packets = 0, 
    freestanding_ref = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    freestanding_fs_ref = l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
    delay_method = static, 
    update = function(v505)
        -- upvalues: l_pui_0 (ref)
        local v506 = entity.get_local_player();
        if not v506 or not v506:is_alive() then
            return;
        else
            local l_antiaim_0 = v505.references.antiaim;
            local l_angles_0 = l_antiaim_0.angles;
            local l_extract_yaw_0 = l_angles_0.extract_yaw;
            local l_extract_desync_0 = l_angles_0.extract_desync;
            local l_extract_modifier_0 = l_angles_0.extract_modifier;
            l_antiaim_0.enabled:override(true);
            l_extract_yaw_0.roll:override(false);
            l_extract_yaw_0.yaw:override("Backward");
            l_angles_0.pitch:override("Down");
            l_extract_yaw_0.base:override("At Target");
            l_extract_yaw_0.snap:override(false);
            local _ = nil;
            local function v514(v513)
                -- upvalues: l_pui_0 (ref)
                l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override(v513:get());
            end;
            v505.antiaim.elements.options_table.avoid_backstab:set_callback(v514, true);
            local v515;
            v514, v515 = v505.localplayer:state(cmd);
            local v516 = v505.localplayer:disabler_state(cmd);
            local v517 = v505.antiaim.data[v514] and v505.antiaim.data[v514][v515];
            if not v517 then
                return;
            else
                local v518 = v505.localplayer:side();
                local v519 = 0;
                if globals.choked_commands == 0 then
                    v505.packets = v505.packets + 1;
                    local v520 = v517.yaw_options_ex.delay_type:get();
                    local l_yaw_options_ex_0 = v517.yaw_options_ex;
                    if v520 == "Static" then
                        v505.delay_method = l_yaw_options_ex_0.delay_static_value:get();
                    elseif v520 == "Random" then
                        v505.delay_method = math.random(l_yaw_options_ex_0.delay_minimum_value:get(), l_yaw_options_ex_0.delay_maximum_value:get());
                    else
                        local v522 = l_yaw_options_ex_0.delay_sliders:get();
                        v505.delay_method = v517["delay_" .. math.random(1, v522)]:get();
                    end;
                    if v505.packets - v505.last_flick_at >= v505.delay_method then
                        v505.flicker = not v505.flicker;
                        v505.last_flick_at = v505.packets;
                    end;
                end;
                if v517.yaw_mode:get() == 2 then
                    if v517.yaw_options_ex.delay:get() then
                        v519 = v505.flicker and v517.yaw_options_ex.offset_left:get() or v517.yaw_options_ex.offset_right:get();
                        rage.antiaim:inverter(v505.flicker);
                    else
                        v519 = v518 and v517.yaw_options_ex.offset_left:get() or v517.yaw_options_ex.offset_right:get();
                    end;
                else
                    v519 = v517.yaw_offset:get();
                end;
                l_extract_yaw_0.offset:override(v519);
                local l_modifier_options_0 = v517.modifier_options;
                local v524 = l_modifier_options_0.randomize:get();
                l_extract_modifier_0.mode:override(v517.modifier:get());
                local v525 = v517.modifier_offset:get();
                if v524 then
                    if l_modifier_options_0.type:get() == "Default" then
                        v525 = math.random(l_modifier_options_0.min_offset_value:get(), l_modifier_options_0.max_offset_value:get());
                    else
                        local v526 = l_modifier_options_0.sliders:get();
                        if v526 > 0 then
                            v525 = v517["modifier_" .. math.random(1, v526)]:get();
                        end;
                    end;
                end;
                l_extract_modifier_0.offset:override(v525);
                local v527 = v517.body:get();
                local l_body_options_0 = v517.body_options;
                local v529 = l_body_options_0.limit_type:get();
                l_extract_desync_0.inverter:override(v527 and l_body_options_0.inverter:get() or false);
                l_extract_desync_0.tweaks:override(v527 and l_body_options_0.jitter:get() and "Jitter" or "");
                local v530 = false;
                local v531 = "Off";
                if v527 then
                    local v532 = l_body_options_0.type:get();
                    local v533 = l_body_options_0.type_ticks_value:get();
                    local v534 = l_body_options_0.type_random_value:get();
                    v530 = v532 == "Static" and v527 or v532 == "Ticks" and not (globals.tickcount % v533 <= 1) or utils.random_int(0, v534) == v534;
                    v531 = ({
                        Default = "Peek Fake", 
                        Reversed = "Peek Real"
                    })[l_body_options_0.freestanding:get()] or "Off";
                    local v535 = l_body_options_0.limit_min:get();
                    local v536 = l_body_options_0.limit_max:get();
                    local v537 = l_body_options_0.left_limit:get();
                    local v538 = l_body_options_0.right_limit:get();
                    l_extract_desync_0.left_limit:override(v529 == "Static" and v537 or math.random(v535, v536));
                    l_extract_desync_0.right_limit:override(v529 == "Static" and v538 or math.random(v535, v536));
                end;
                l_extract_desync_0.switch:override(v530);
                l_extract_desync_0.freestanding:override(v531);
                local v539 = v505.antiaim.elements.freestanding:get();
                local v540 = v505.antiaim.elements.freestanding.disablers:get(v516);
                if v539 and not v540 then
                    v505.freestanding_fs_ref:set(v505.antiaim.elements.freestanding.body_fs:get());
                    v505.freestanding_ref:set(true);
                else
                    v505.freestanding_ref:set(false);
                end;
                local v541 = v505.antiaim.elements.manual_yaw:get();
                if v541 ~= "Off" then
                    local v542 = {
                        Forward = 180, 
                        Right = 90, 
                        Left = -90
                    };
                    if v542[v541] then
                        local v543 = ({
                            Default = "Peek Fake", 
                            Reversed = "Peek Real"
                        })[v505.antiaim.elements.manual_yaw.freestanding:get()] or "Off";
                        local l_manual_yaw_0 = v505.antiaim.elements.manual_yaw;
                        l_extract_yaw_0.offset:override(v542[v541]);
                        l_extract_modifier_0.offset:override(0);
                        v505.freestanding_ref:override(false);
                        l_extract_yaw_0.base:override("Local View");
                        l_extract_desync_0.tweaks:override(l_manual_yaw_0.body_tweaks:get());
                        l_extract_desync_0.switch:override(true);
                        l_extract_desync_0.freestanding:override(v543);
                        l_pui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"):override(l_manual_yaw_0.side:get());
                    end;
                end;
                return;
            end;
        end;
    end, 
    init = function(v545)
        events.createmove(function()
            -- upvalues: v545 (ref)
            v545:update(cmd);
        end);
    end
}):struct("watermark")({
    setup = function(v546)
        v546.position = vector(0, 0);
        v546.dragging = false;
        v546.drag_offset = vector(0, 0);
        v546.drag_start_time = globals.realtime;
    end, 
    calculate_pulse = function(_, v548, v549)
        return math.abs(math.sin(globals.realtime * v549 % math.pi + v548));
    end, 
    on_mouse_input = function(v550)
        return not v550.dragging;
    end, 
    update_watermark_position = function(v551, v552, v553, v554)
        local v555 = v554.x / 2;
        local v556 = v554.y / 2;
        local v557 = 10;
        local v558 = vector(v552.x - v551.drag_offset.x, v552.y - v551.drag_offset.y);
        if math.abs(v558.x - v555) < v557 then
            v558.x = v555;
        end;
        if math.abs(v558.y - v556) < v557 then
            v558.y = v556;
        end;
        v558.x = math.max(v553.x / 2, math.min(v554.x - v553.x / 2, v558.x));
        v558.y = math.max(v553.y / 2, math.min(v554.y - v553.y / 2, v558.y));
        v551.home.elements.watermark_options.pos_x:set(v558.x);
        v551.home.elements.watermark_options.pos_y:set(v558.y);
        v551.position = v558;
    end, 
    parse_watermark_text = function(_, v560)
        -- upvalues: l_pui_0 (ref)
        local v561 = {
            postfix_icon = "", 
            prefix_icon = "", 
            postfix = "", 
            text = "", 
            prefix = ""
        };
        local v562, v563 = v560:find("icon_pre=");
        if v562 then
            local v564 = math.min(v560:find("pre=", v563 + 1) or math.huge, v560:find("m=", v563 + 1) or math.huge, v560:find("post=", v563 + 1) or math.huge, v560:find("icon_post=", v563 + 1) or math.huge);
            if v564 ~= math.huge then
                v561.prefix_icon = l_pui_0.get_icon(v560:sub(v563 + 1, v564 - 1):gsub("%s+$", ""));
            else
                v561.prefix_icon = l_pui_0.get_icon(v560:sub(v563 + 1));
            end;
        end;
        local v565, v566 = v560:find("icon_post=");
        if v565 then
            local v567 = math.min(v560:find("pre=", v566 + 1) or math.huge, v560:find("m=", v566 + 1) or math.huge, v560:find("post=", v566 + 1) or math.huge, v560:find("icon_pre=", v566 + 1) or math.huge);
            if v567 ~= math.huge then
                v561.postfix_icon = l_pui_0.get_icon(v560:sub(v566 + 1, v567 - 1):gsub("%s+$", ""));
            else
                v561.postfix_icon = l_pui_0.get_icon(v560:sub(v566 + 1));
            end;
        end;
        local v568, v569 = v560:find("pre=");
        if v568 then
            local v570 = math.min(v560:find("m=", v569 + 1) or math.huge, v560:find("post=", v569 + 1) or math.huge, v560:find("icon_pre=", v569 + 1) or math.huge, v560:find("icon_post=", v569 + 1) or math.huge);
            if v570 ~= math.huge then
                v561.prefix = v560:sub(v569 + 1, v570 - 1):gsub("%s+$", "");
            else
                v561.prefix = v560:sub(v569 + 1);
            end;
        end;
        local v571, v572 = v560:find("m=");
        if v571 then
            local v573 = math.min(v560:find("pre=", v572 + 1) or math.huge, v560:find("post=", v572 + 1) or math.huge, v560:find("icon_pre=", v572 + 1) or math.huge, v560:find("icon_post=", v572 + 1) or math.huge);
            if v573 ~= math.huge then
                v561.text = v560:sub(v572 + 1, v573 - 1):gsub("%s+$", "");
            else
                v561.text = v560:sub(v572 + 1);
            end;
        end;
        local v574, v575 = v560:find("post=");
        if v574 then
            local v576 = math.min(v560:find("pre=", v575 + 1) or math.huge, v560:find("m=", v575 + 1) or math.huge, v560:find("icon_pre=", v575 + 1) or math.huge, v560:find("icon_post=", v575 + 1) or math.huge);
            if v576 ~= math.huge then
                v561.postfix = v560:sub(v575 + 1, v576 - 1):gsub("%s+$", "");
            else
                v561.postfix = v560:sub(v575 + 1);
            end;
        end;
        if not v568 and not v574 and not v571 and not v562 and not v565 then
            v561.text = v560;
        end;
        return v561;
    end, 
    render_gradient_text_with_parts = function(v577, v578, v579, v580, v581, v582, v583, v584, v585, v586, v587, v588, v589, v590, v591)
        local v592 = {};
        if v583 ~= "" then
            table.insert(v592, string.format("\a%s%s ", v589:to_hex(), v583));
        end;
        if v580 ~= "" then
            table.insert(v592, string.format("\a%s%s", v589:to_hex(), v580));
        end;
        local v593 = #v581;
        local _, _, v596 = color(255, 255, 255, 255):to_hsv();
        for v597 = 1, v593 do
            local v598 = v581:sub(v597, v597);
            local v599 = v577:calculate_pulse((v597 - 1) / v593 * 2, v585);
            local v600 = 0.5;
            local v601 = v586 == 1 and (v597 - 1) / v593 or v587 / 10;
            local v602 = v588 / 10;
            local v603 = color():as_hsv(v601, v602, v596 * (v600 + (1 - v600) * (1 - v599))):to_hex();
            table.insert(v592, string.format("\a%s%s", v603, v598));
        end;
        if v582 ~= "" then
            table.insert(v592, string.format("\a%s%s", v590:to_hex(), v582));
        end;
        if v584 ~= "" then
            table.insert(v592, string.format(" \a%s%s", v590:to_hex(), v584));
        end;
        local v604 = table.concat(v592);
        render.text(v578, v579, color(), v591, v604);
    end, 
    render_colored_text = function(_, v606, v607, v608, v609, v610, v611, v612, v613, v614, v615, v616)
        local v617 = {};
        if v611 ~= "" then
            table.insert(v617, string.format("\a%s%s ", v613:to_hex(), v611));
        end;
        if v608 ~= "" then
            table.insert(v617, string.format("\a%s%s", v613:to_hex(), v608));
        end;
        table.insert(v617, string.format("\a%s%s", v614:to_hex(), v609));
        if v610 ~= "" then
            table.insert(v617, string.format("\a%s%s", v615:to_hex(), v610));
        end;
        if v612 ~= "" then
            table.insert(v617, string.format(" \a%s%s", v615:to_hex(), v612));
        end;
        local v618 = table.concat(v617);
        render.text(v606, v607, v614, v616, v618);
    end, 
    is_point_in_rect = function(_, v620, v621)
        return v620.x >= v621.x1 and v620.x <= v621.x2 and v620.y >= v621.y1 and v620.y <= v621.y2;
    end, 
    render_center_lines = function(_, v623, v624, v625)
        local v626 = v623.x / 2;
        local v627 = v623.y / 2;
        local v628 = math.abs(v624.x - v626);
        local v629 = math.abs(v624.y - v627);
        local v630 = 100;
        local v631 = math.max(0, 255 - v628 / v630 * 255);
        local v632 = math.max(0, 255 - v629 / v630 * 255);
        local v633 = color(255, 255, 255, v631);
        local v634 = color(255, 255, 255, v632);
        if v629 < v630 then
            render.line(vector(v624.x - v625.x / 2, v627), vector(v624.x + v625.x / 2, v627), v634);
        end;
        if v628 < v630 then
            render.line(vector(v626, v624.y - v625.y / 2), vector(v626, v624.y + v625.y / 2), v633);
        end;
    end, 
    render = function(v635)
        -- upvalues: l_pui_0 (ref)
        if not globals.is_in_game or v635.home.elements.watermark_options.label:get() == "" then
            return;
        else
            local v636 = v635:parse_watermark_text((v635.home.elements.watermark_options.label:get()));
            local l_prefix_0 = v636.prefix;
            local l_text_0 = v636.text;
            local l_postfix_0 = v636.postfix;
            local l_prefix_icon_0 = v636.prefix_icon;
            local l_postfix_icon_0 = v636.postfix_icon;
            local v642 = ({
                Console = 3, 
                Pixel = 2, 
                Default = 1, 
                Bold = 4
            })[v635.home.elements.watermark_options.font:get()] or "Custom";
            local v643 = "c";
            local v644 = v635.home.elements.watermark_options.main_accent:get();
            local v645 = v635.home.elements.watermark_options.prefix_accent:get();
            local v646 = v635.home.elements.watermark_options.postfix_accent:get();
            local v647 = render.screen_size();
            if v642 == 2 then
                l_text_0 = l_text_0:upper();
                if l_prefix_0 ~= "" then
                    l_prefix_0 = l_prefix_0:upper();
                end;
                if l_postfix_0 ~= "" then
                    l_postfix_0 = l_postfix_0:upper();
                end;
            end;
            v635.position = vector(v635.home.elements.watermark_options.pos_x:get(), v635.home.elements.watermark_options.pos_y:get());
            local v648 = l_prefix_icon_0 ~= "" and l_prefix_icon_0 .. " " or "";
            local v649;
            if l_prefix_0 == "" or not l_prefix_0 then
                v649 = "";
            else
                v649 = l_prefix_0;
            end;
            local l_l_text_0_0 = l_text_0;
            local v651;
            if l_postfix_0 == "" or not l_postfix_0 then
                v651 = "";
            else
                v651 = l_postfix_0;
            end;
            v648 = v648 .. v649 .. l_l_text_0_0 .. v651 .. (l_postfix_icon_0 ~= "" and " " .. l_postfix_icon_0 or "");
            v649 = l_pui_0.get_mouse_position();
            l_l_text_0_0 = render.measure_text(v642, v643, v648);
            local v652 = v635:is_point_in_rect(v649, {
                x1 = v635.position.x - l_l_text_0_0.x / 2, 
                y1 = v635.position.y - l_l_text_0_0.y / 2, 
                x2 = v635.position.x + l_l_text_0_0.x / 2, 
                y2 = v635.position.y + l_l_text_0_0.y / 2
            });
            local v653 = l_pui_0.get_alpha() > 0;
            if common.is_button_down(1) then
                if v652 and not v635.dragging and v653 then
                    v635.dragging = true;
                    v635.drag_offset = vector(v649.x - v635.position.x, v649.y - v635.position.y);
                end;
            elseif v635.dragging and common.is_button_released(1) then
                v635.dragging = false;
            end;
            if v635.dragging and v653 then
                v635:render_center_lines(v647, v635.position, l_l_text_0_0);
                v635:update_watermark_position(v649, l_l_text_0_0, v647);
            end;
            if v635.home.elements.watermark_options.gradient_switch:get() then
                v635:render_gradient_text_with_parts(v642, v635.position, l_prefix_0, l_text_0, l_postfix_0, l_prefix_icon_0, l_postfix_icon_0, v635.home.elements.watermark_options.gradient_speed:get(), v635.home.elements.watermark_options.gradient_rainbow:get() == true and 1 or 0, v635.home.elements.watermark_options.gradient_hue:get(), v635.home.elements.watermark_options.gradient_saturation:get(), v645, v646, v643);
            else
                v635:render_colored_text(v642, v635.position, l_prefix_0, l_text_0, l_postfix_0, l_prefix_icon_0, l_postfix_icon_0, v645, v644, v646, v643);
            end;
            return;
        end;
    end, 
    init = function(v654)
        local function v655()
            -- upvalues: v654 (ref)
            v654:on_mouse_input();
        end;
        local function v656()
            -- upvalues: v654 (ref)
            v654:render();
        end;
        events.mouse_input(v655);
        events.render(v656);
    end
}):struct("sidebar")({
    setup = function(v657)
        v657.script_name = "Nyanza Beta";
        v657.script_icon = "paw";
        v657.text_length = #v657.script_name;
        v657.start_time = globals.realtime;
        v657.icon_fade_duration = 1;
        v657.wave_delay = 0.3;
        v657.wave_duration = 1.5;
        v657.char_spawn_duration = 0.1;
        v657.gradient_fade_duration = 1.5;
    end, 
    pulse = function(_, v659, v660)
        return math.abs(math.sin(globals.realtime * (v660 or 1) + (v659 or 0)));
    end, 
    render = function(v661)
        -- upvalues: l_pui_0 (ref)
        if l_pui_0.get_alpha() <= 0 then
            return;
        else
            local _ = math.sin(globals.curtime) * 25;
            local v663 = math.sin(globals.curtime) * 100;
            v661.home.elements.progress_version_bar:set(v663);
            local v664 = globals.realtime - v661.start_time;
            local v665, v666, v667 = l_pui_0.get_style("Link Active"):to_hsv();
            local v668 = l_pui_0.get_style("Active Text");
            local v669 = v664 < v661.icon_fade_duration;
            local v670 = v661.icon_fade_duration <= v664 and v664 < v661.icon_fade_duration + v661.wave_delay;
            local v671 = v661.icon_fade_duration + v661.wave_delay <= v664 and v664 < v661.icon_fade_duration + v661.wave_delay + v661.wave_duration;
            local v672 = v661.icon_fade_duration + v661.wave_delay + v661.wave_duration <= v664 and v664 < v661.icon_fade_duration + v661.wave_delay + v661.wave_duration + v661.gradient_fade_duration;
            local v673 = v661.icon_fade_duration + v661.wave_delay + v661.wave_duration + v661.gradient_fade_duration <= v664;
            local v674 = v669 and v664 / v661.icon_fade_duration or 1;
            local v675 = v671 and (v664 - v661.icon_fade_duration - v661.wave_delay) / v661.wave_duration or 0;
            local v676 = v672 and (v664 - v661.icon_fade_duration - v661.wave_delay - v661.wave_duration) / v661.gradient_fade_duration or v673 and 1 or 0;
            local v677 = "";
            local v678 = {};
            for v679 = 1, v661.text_length do
                local v680 = v679 / v661.text_length;
                local _ = (v679 - 1) * v661.char_spawn_duration;
                if v671 then
                    v678[v679] = v680 - 0.05 <= v675 and v675 <= v680 + 0.05;
                else
                    v678[v679] = true;
                end;
            end;
            for v682 = 1, v661.text_length do
                local v683 = v661.script_name:sub(v682, v682);
                local _ = v682 / v661.text_length;
                local v685 = 0;
                if v671 then
                    local v686 = (v682 - 1) * v661.char_spawn_duration / v661.wave_duration;
                    local v687 = v686 + v661.char_spawn_duration * 2 / v661.wave_duration;
                    if v686 <= v675 and v675 <= v687 then
                        v685 = (v675 - v686) / (v687 - v686);
                    elseif v687 < v675 then
                        v685 = 1;
                    end;
                elseif v672 or v673 then
                    v685 = 1;
                end;
                local l_v668_0 = v668;
                if (v672 or v673) and v685 > 0 then
                    local v689 = 0.5 + 0.5 * v661:pulse((v682 - 1) / v661.text_length * 2, 2);
                    local v690 = color():as_hsv(v665, v666, v667 * v689);
                    local v691, v692, v693 = v668:unpack();
                    local v694, v695, v696 = v690:unpack();
                    l_v668_0 = color(v691 + (v694 - v691) * v676, v692 + (v695 - v692) * v676, v693 + (v696 - v693) * v676);
                end;
                l_v668_0 = color(l_v668_0.r, l_v668_0.g, l_v668_0.b, l_v668_0.a * v685);
                v677 = v677 .. string.format("\a%s%s", l_v668_0:to_hex(), v683);
            end;
            local v697 = v668:clone();
            if v669 then
                v697 = color(v697.r, v697.g, v697.b, v697.a * v674);
            elseif v670 then
                v697 = v668;
            elseif v671 or v672 or v673 then
                local v698 = color():as_hsv(v665, v666, v667 * 0.8);
                local v699, v700, v701 = v668:unpack();
                local v702, v703, v704 = v698:unpack();
                v697 = color(v699 + (v702 - v699) * v676, v700 + (v703 - v700) * v676, v701 + (v704 - v701) * v676);
            end;
            l_pui_0.sidebar(v677, string.format("\a%s%s", v697.to_hex(v697), l_pui_0.get_icon(v661.script_icon)));
            return;
        end;
    end, 
    init = function(v705)
        v705:setup();
        local function v706()
            -- upvalues: v705 (ref)
            v705:render();
        end;
        events.render(v706);
    end
});
v707.home:init();
v707.antiaim:init();
v707.other:init();
v707.localplayer:init();
v707.antiaim_data:init();
v707.tweaks:init();
v707.fake_lag:init();
v707.manual_arrows:init();
v707.safe_head:init();
v707.presets:init();
v707.presets:event_manager();
v707.log_events:init();
v707.fast_ladder:init();
v707.no_fall_damage:init();
v707.force_break_lc:init();
v707.player_animations:init();
v707.freezetime_fakeduck:init();
v707.fakeduck_speed:init();
v707.hitmarkers:init();
v707.keep_transparency:init();
v707.scope_overlay:init();
v707.damage_indicator:init();
v707.addons:init();
v707.viewmodel:init();
v707.aspectratio:init();
v707.watermark:init();
v707.sidebar:init();
v707.clantag:run();