local _ = require("ffi");
local l_pui_0 = require("neverlose/pui");
local l_base64_0 = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local l_smoothy_0 = require("neverlose/smoothy");
local _ = require("neverlose/inspect");
local l_lambotruck_0 = require("neverlose/lambotruck");
utility_lerp = function(v7, v8, v9)
    return v7 + (v8 - v7) * v9;
end;
local v618 = new_class():struct("globals")({
    current_logo = 0, 
    logo_counter = 0, 
    states = {
        [1] = "stand", 
        [2] = "slow walk", 
        [3] = "run", 
        [4] = "duck", 
        [5] = "jump", 
        [6] = "duck jump", 
        [7] = "duck move"
    }, 
    main_states = {
        [1] = "stand", 
        [2] = "slow walk", 
        [3] = "run", 
        [4] = "duck", 
        [5] = "jump", 
        [6] = "duck jump", 
        [7] = "duck move"
    }, 
    addition_options = {
        [1] = "Warmup AA", 
        [2] = "Round end AA", 
        [3] = "Hide Head", 
        [4] = "Avoid Backstab", 
        [5] = "Fluctuate Fakelag"
    }, 
    hidehead_options = {
        [1] = "Standing", 
        [2] = "Crouch", 
        [3] = "Air Crouch Knife", 
        [4] = "Distance", 
        [5] = "Height Advantage", 
        [6] = "Taser In Air"
    }, 
    troll_aa_options = {
        [1] = "Spin", 
        [2] = "Half Spin"
    }, 
    manual_aa_options = {
        [1] = "Off", 
        [2] = "Left", 
        [3] = "Right", 
        [4] = "Forward"
    }
}):struct("ref")({
    antiaim = {
        enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti aim", "Angles", "Pitch"), 
        yaw = ui.find("Aimbot", "Anti aim", "Angles", "Yaw"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        yaw_offset = ui.find("Aimbot", "Anti aim", "Angles", "Yaw", "Offset"), 
        yaw_target = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
        yaw_modifier = ui.find("Aimbot", "Anti aim", "Angles", "Yaw Modifier"), 
        yaw_modifieramount = ui.find("Aimbot", "Anti aim", "Angles", "Yaw Modifier", "Offset"), 
        body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        leftfake = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        rightfake = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
        legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
        legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
    }, 
    rage = {
        dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        dtlag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
        dt_fakelag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"), 
        hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        hs2 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
        fb = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        quickpeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
        fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
        fakelag_enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
        fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
        safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")
    }, 
    visuals = {
        scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
        force_thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson")
    }
}):struct("ui")({
    menu = {
        global = {}, 
        aa = {}, 
        vis = {}, 
        misc = {}, 
        cfg = {}, 
        debug = {}
    }, 
    execute = function(v10)
        -- upvalues: l_pui_0 (ref), l_clipboard_0 (ref)
        local v11 = {
            [1] = {
                [1] = "select", 
                [2] = "\nSELECTION"
            }, 
            [2] = {
                [1] = "select2", 
                [2] = "\nSELECTION2", 
                [3] = 1
            }, 
            [3] = {
                [1] = "user_info", 
                [2] = "\nUSER_INFO", 
                [3] = 1
            }, 
            [4] = {
                [1] = "user_settings", 
                [2] = "\nUSER_SETTINGS", 
                [3] = 1
            }, 
            [5] = {
                [1] = "main", 
                [2] = "\nMAIN", 
                [3] = 2
            }, 
            [6] = {
                [1] = "main2", 
                [2] = "", 
                [3] = 1
            }, 
            [7] = {
                [1] = "builder_state", 
                [2] = "\na", 
                [3] = 1
            }, 
            [8] = {
                [1] = "lagcomp", 
                [2] = "\nlagcomp", 
                [3] = 1
            }, 
            [9] = {
                [1] = "other", 
                [2] = "\nMODE", 
                [3] = 1
            }, 
            [10] = {
                [1] = "addon", 
                [2] = "\nEXTRA", 
                [3] = 1
            }, 
            [11] = {
                [1] = "movement", 
                [2] = "\nMOVEMENT", 
                [3] = 2
            }, 
            [12] = {
                [1] = "builder", 
                [2] = "\nBUILDER", 
                [3] = 2
            }, 
            [13] = {
                [1] = "configs", 
                [2] = "\nCONFIGS"
            }, 
            [14] = {
                [1] = "visuals", 
                [2] = "\nVISUALS", 
                [3] = 2
            }, 
            [15] = {
                [1] = "user_interface", 
                [2] = "\nUSER INTERFACE"
            }, 
            [16] = {
                [1] = "overlays", 
                [2] = "\nOVERLAYS"
            }, 
            [17] = {
                [1] = "info", 
                [2] = "\ninfo"
            }, 
            [18] = {
                [1] = "movement", 
                [2] = "\nMOVEMENT"
            }, 
            [19] = {
                [1] = "ragebot", 
                [2] = "\nRAGE BOT"
            }, 
            [20] = {
                [1] = "common", 
                [2] = "\nCOMMON"
            }
        };
        local v12 = l_pui_0.create("\v\f<house>", v11);
        local v13 = l_pui_0.create("\v\f<diagram-project>", v11);
        local v14 = l_pui_0.create("\v\f<gear>", v11);
        v10.menu.global.username = v12.user_info:label("User");
        v10.menu.global.user_button = v12.user_info:button("\v " .. common.get_username() .. " ", nil, true);
        v10.menu.global.version = v12.user_info:label("Build");
        v10.menu.global.version_button = v12.user_info:button("\vLIVE", nil, true);
        v10.menu.global.update = v12.user_info:label("Updated");
        v10.menu.global.update_button = v12.user_info:button("\v" .. common.get_date("%d/%m/%y - %H:%M %p"), nil, true);
        v10.menu.global.sidebar = v12.user_settings:label("Sidebar");
        local v15 = v10.menu.global.sidebar:create();
        v10.menu.global.sidebar_color = v15:label("Color", color(158, 155, 178, 255));
        v10.menu.global.sidebar_text = v15:input("");
        v10.menu.global.sidebar_speed = v15:slider("Speed", 1, 8, 0, 1);
        v10.menu.global.watermark = v12.user_settings:label("Watermark");
        local v16 = v10.menu.global.watermark:create();
        v10.menu.global.watermark_color = v16:label("Color", color(158, 155, 178, 255));
        v10.menu.global.watermark_style = v16:combo("Watermark styles", {
            [1] = "Gingersense", 
            [2] = "Modern", 
            [3] = "Custom"
        });
        v10.menu.global.watermark_text = v16:input(""):depend({
            [1] = nil, 
            [2] = "Custom", 
            [1] = v10.menu.global.watermark_style
        });
        v10.menu.global.watermark_font = v16:slider("Font", 1, 4, 0, 1, function(v17)
            if v17 == 1 then
                return "Default";
            elseif v17 == 2 then
                return "Pixel";
            elseif v17 == 3 then
                return "Console";
            elseif v17 == 4 then
                return "Bold";
            else
                return;
            end;
        end):depend({
            [1] = nil, 
            [2] = "Custom", 
            [1] = v10.menu.global.watermark_style
        });
        v10.menu.global.watermark_gradient = v16:slider("Gradient", 1, 2, 0, 1, function(v18)
            if v18 == 1 then
                return "Off";
            elseif v18 == 2 then
                return "On";
            else
                return;
            end;
        end):depend({
            [1] = nil, 
            [2] = "Custom", 
            [1] = v10.menu.global.watermark_style
        });
        v10.menu.global.watermark_speed = v16:slider("Speed", 1, 8, 0, 1):depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v10.menu.global.watermark_gradient
        }):depend({
            [1] = nil, 
            [2] = "Custom", 
            [1] = v10.menu.global.watermark_style
        });
        v10.menu.aa.state = v13.builder_state:combo("State \v\f<people-group>", v10.globals.main_states);
        v10.menu.aa.states = {};
        for _, v20 in ipairs(v10.globals.main_states) do
            v10.menu.aa.states[v20] = {};
            local v21 = v10.menu.aa.states[v20];
            v21.yaw_additions = v13.builder:label("\v\226\128\162\r Yaw \a00000000[" .. v20 .. "]");
            local v22 = v21.yaw_additions:create();
            v21.yaw_add = v22:slider("Yaw Left" .. "\n" .. v20, -180, 180, -35, 1);
            v21.yaw_add_r = v22:slider("Yaw Right" .. "\n" .. v20, -180, 180, 35, 1);
            v21.yaw_jitter = v13.builder:combo("     \v\f<turn-down-right>\r  Yaw Jitter\n" .. v20, {
                [1] = "Off", 
                [2] = "Offset", 
                [3] = "Center", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "Gingerbomber"
            });
            local v23 = v21.yaw_jitter:create();
            v21.yaw_jitter_mode = v23:combo("Mode\n" .. v20, {
                [1] = "Default", 
                [2] = "Custom"
            }):depend({
                [1] = nil, 
                [2] = "Offset", 
                [3] = "Center", 
                [4] = "Random", 
                [5] = "Spin", 
                [1] = v21.yaw_jitter
            });
            v21.yaw_jitter_add = v23:slider("Degree\n" .. v20, -180, 180, 0, 1):depend({
                [1] = nil, 
                [2] = "Offset", 
                [3] = "Center", 
                [4] = "Random", 
                [5] = "Spin", 
                [1] = v21.yaw_jitter
            }):depend({
                [1] = nil, 
                [2] = "Default", 
                [1] = v21.yaw_jitter_mode
            });
            v21.yaw_sliders = v23:slider("Sliders\n as" .. v20, 1, 6, 0, 1):depend({
                [1] = nil, 
                [2] = "Custom", 
                [1] = v21.yaw_jitter_mode
            }):depend({
                [1] = nil, 
                [2] = "Offset", 
                [3] = "Center", 
                [4] = "Random", 
                [5] = "Spin", 
                [1] = v21.yaw_jitter
            });
            for v24 = 1, 6 do
                v21["yaw_jitter_slider" .. v24] = v23:slider("" .. v24 .. "\n" .. v20 .. "\n", -180, 180, 50, 1):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 10, 
                    [1] = v21.yaw_sliders, 
                    [2] = v24
                }):depend({
                    [1] = nil, 
                    [2] = "Custom", 
                    [1] = v21.yaw_jitter_mode
                }):depend({
                    [1] = nil, 
                    [2] = "Offset", 
                    [3] = "Center", 
                    [4] = "Random", 
                    [5] = "Spin", 
                    [1] = v21.yaw_jitter
                });
            end;
            v21.yaw_jitter_own1 = v23:slider("Min. offset\n" .. v20, -180, 180, 0, 1):depend({
                [1] = nil, 
                [2] = "Gingerbomber", 
                [1] = v21.yaw_jitter
            });
            v21.yaw_jitter_own2 = v23:slider("Max. offset\n" .. v20, -180, 180, 0, 1):depend({
                [1] = nil, 
                [2] = "Gingerbomber", 
                [1] = v21.yaw_jitter
            });
            v21.aa_extra = v13.builder:label("          \v\f<turn-down-right>\r  Additions \a00000000[" .. v20 .. "]");
            local v25 = v21.aa_extra:create();
            v21.delay = v25:switch("Delay\n" .. v20);
            v21.delay_interaction_type = v25:combo("Interaction type\n" .. v20, {
                [1] = "Createmove", 
                [2] = "Net_update"
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            v21.delay_method = v25:combo("Method\n" .. v20, {
                [1] = "Default", 
                [2] = "Random", 
                [3] = "Custom"
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            v21.switch_delay = v25:slider("Timing\n" .. v20, 1, 23, 0, 1, function(v26)
                return v26 .. "t";
            end):depend({
                [1] = nil, 
                [2] = "Default", 
                [1] = v21.delay_method
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            v21.random_delay_value_1 = v25:slider("Min. Timing\n" .. v20, 1, 23, 0, 1, function(v27)
                return v27 .. "t";
            end):depend({
                [1] = nil, 
                [2] = "Random", 
                [1] = v21.delay_method
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            v21.random_delay_value_2 = v25:slider("Max. Timing\n" .. v20, 1, 23, 0, 1, function(v28)
                return v28 .. "t";
            end):depend({
                [1] = nil, 
                [2] = "Random", 
                [1] = v21.delay_method
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            v21.delay_sliders = v25:slider("Sliders\n as" .. v20, 1, 6, 0, 1):depend({
                [1] = nil, 
                [2] = "Custom", 
                [1] = v21.delay_method
            }):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.delay
            });
            for v29 = 1, 6 do
                v21["switch_delay_sliders" .. v29] = v25:slider("" .. v29 .. "\n" .. v20 .. "\n", 1, 23, 0, 1):depend({
                    [1] = nil, 
                    [2] = nil, 
                    [3] = 10, 
                    [1] = v21.delay_sliders, 
                    [2] = v29
                }):depend({
                    [1] = nil, 
                    [2] = "Custom", 
                    [1] = v21.delay_method
                }):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v21.delay
                });
            end;
            v21.randomization = v25:slider("Randomization" .. "\n" .. v20, 0, 100, 0, 1, function(v30)
                return v30 .. "%";
            end);
            v21.body_yaw = v13.builder:combo("\v\f<turn-down-right>\r Desync\n" .. v20, {
                [1] = "Off", 
                [2] = "Jitter", 
                [3] = "Random", 
                [4] = "Tick"
            });
            local v31 = v21.body_yaw:create();
            v21.body_yaw_ticks = v31:slider("Ticks" .. "\n" .. v20, 0, 22, 12, 1, function(v32)
                return v32 .. "t";
            end):depend({
                [1] = nil, 
                [2] = "Tick", 
                [1] = v21.body_yaw
            });
            v21.fakelimit_l = v31:slider("Left" .. "\n" .. v20, 0, 60, 32, 1);
            v21.fakelimit_r = v31:slider("Right" .. "\n" .. v20, 0, 60, 32, 1);
            v21.defensive_activation_options = v13.lagcomp:selectable("\v\f<triangle-exclamation>\r Break lc" .. "\n" .. v20, "Weapon switch", "Weapon reload", "Always");
            v21.defensive_disable_option = v13.lagcomp:switch("     \v\f<turn-down-right>\r  Dont override LC on Quickpeek" .. "\n" .. v20, false):depend({
                [1] = nil, 
                [2] = "Always", 
                [1] = v21.defensive_activation_options
            });
            v21.antibruteforce_enable = v13.builder:switch("\v\f<user-ninja>\r Anti-Bruteforce \n" .. v20);
            v21.antibruteforce_modifiers = v21.antibruteforce_enable:create():selectable("Modifiers \n" .. v20, "Fake limit", "Delay", "Modifier"):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.antibruteforce_enable
            });
            v21.yaw_headbehindchest = v13.lagcomp:switch("\v\226\128\139\240\159\135\167\226\128\139\226\128\139\240\159\135\170\226\128\139\226\128\139\240\159\135\185\226\128\139\226\128\139\240\159\135\166\226\128\139 \rHead Behind Burger" .. "\n" .. v20, false, "Puts head behind chest when needed to avoid getting resolved");
            v21.cleanrecords = v13.lagcomp:switch("\v\226\128\139\240\159\135\167\226\128\139\226\128\139\240\159\135\170\226\128\139\226\128\139\240\159\135\185\226\128\139\226\128\139\240\159\135\166\226\128\139 \rClear AntiAim Records" .. "\n" .. v20, false);
            v21.cleanrecords_usefakelag = v13.lagcomp:switch("      \v\f<triangle-exclamation>  Choke after defensive" .. "\n" .. v20, false):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.cleanrecords
            });
            v21.cleanrecords_random_flick = v13.lagcomp:switch("      \v\f<triangle-exclamation>  Randomly flick" .. "\n" .. v20, false):depend({
                [1] = nil, 
                [2] = true, 
                [1] = v21.cleanrecords
            });
            for _, v34 in pairs(v21) do
                local v35 = {
                    [1] = {
                        [1] = v10.menu.aa.state, 
                        [2] = v20
                    }
                };
                v34:depend(table.unpack(v35));
            end;
        end;
        v10.menu.aa.options = v13.addon:selectable("\v\f<box>\r Options", table.unpack(v10.globals.addition_options));
        local v36 = v10.menu.aa.options:create();
        v10.menu.aa.troll_aa_options = v36:combo("Troll AA", table.unpack(v10.globals.troll_aa_options)):depend({
            [1] = nil, 
            [2] = "Warmup AA", 
            [3] = "Round end AA", 
            [1] = v10.menu.aa.options
        });
        v10.menu.aa.troll_aa_speed = v36:slider("Speed", 1, 10, 0, 1, function(v37)
            return v37 .. "t";
        end):depend({
            [1] = nil, 
            [2] = "Warmup AA", 
            [3] = "Round end AA", 
            [1] = v10.menu.aa.options
        });
        v36 = v10.menu.aa.options:create();
        v10.menu.aa.hidehead_options = v36:selectable("Hide head", table.unpack(v10.globals.hidehead_options)):depend({
            [1] = nil, 
            [2] = "Hide Head", 
            [1] = v10.menu.aa.options
        });
        v10.menu.aa.freestanding = v13.addon:switch("\v\f<arrows-turn-to-dots>\r Freestanding");
        v36 = v10.menu.aa.freestanding:create();
        v10.menu.aa.freestanding_disablers = v36:selectable("Disable conditions", v10.globals.states):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v10.menu.aa.freestanding
        });
        v10.menu.aa.yawmodifier = v36:selectable("Modifier behavior", {
            [1] = "Force static"
        }):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v10.menu.aa.freestanding
        });
        v10.menu.aa.manual_aa = v13.addon:combo("\v\f<right-left>\r Manual Anti-Aim", v10.globals.manual_aa_options);
        v10.menu.cfg.list = v12.main:list("\nsaved_configs", {});
        v10.menu.cfg.list:set_callback(function()
            -- upvalues: v10 (ref)
            v10.config:select_current_config();
        end);
        v10.menu.cfg.name = v12.main:input("Config name -");
        v10.menu.cfg.save = v12.main:button("Save", function()
            -- upvalues: v10 (ref)
            v10.config:save();
        end, true);
        v10.menu.cfg.load = v12.main:button("Load", function()
            -- upvalues: v10 (ref)
            v10.config:load();
        end, true);
        v10.menu.cfg.delete = v12.main:button("Remove", function()
            -- upvalues: v10 (ref)
            v10.config:delete();
        end, true);
        v10.menu.cfg.export = v12.main:button("Export", function()
            -- upvalues: l_clipboard_0 (ref), v10 (ref)
            l_clipboard_0.set(v10.config:export("config"));
        end, true);
        v10.menu.cfg.import = v12.main:button("Import", function()
            -- upvalues: l_clipboard_0 (ref), v10 (ref)
            local v38 = l_clipboard_0.get();
            if v38 and v38 ~= "" then
                v10.config:import(v38, "config");
            end;
        end, true);
        v10.menu.vis.scope_overlay = v14.overlays:switch("\v\f<gun>\r Custom Scope Overlay");
        v36 = v10.menu.vis.scope_overlay:create();
        v10.menu.vis.scope_overlay_color = v36:label("Color", color(255, 255, 255, 255));
        v10.menu.vis.scope_overlay_line = v36:slider("Line", 0, 200, 50, 1);
        v10.menu.vis.scope_overlay_gap = v36:slider("Gap", 0, 200, 10, 1);
        v10.menu.vis.scope_overlay_rotate = v36:switch("Rotate", false);
        v10.menu.vis.aspect_ratio_enable = v14.visuals:switch("\v\f<image-landscape>\r Aspect Ratio", false);
        local v39 = v10.menu.vis.aspect_ratio_enable:create();
        v10.menu.vis.aspectratio = v39:slider("Aspect Ratio", 0, 200, 0, 0.01);
        v10.menu.vis.extravisual = v14.visuals:label("\v\f<person-rifle>\r Custom Viewmodel");
        local v40 = v10.menu.vis.extravisual:create();
        v10.menu.vis.viewmodel_fov = v40:slider("FOV", 0, 1000, 690, 0.1);
        v10.menu.vis.viewmodel_x = v40:slider("X", -150, 150, 25, 0.1);
        v10.menu.vis.viewmodel_y = v40:slider("Y", -150, 150, 25, 0.1);
        v10.menu.vis.viewmodel_z = v40:slider("Z", -150, 150, 25, 0.1);
        v10.menu.vis.viewmodel_knifehand = v40:switch("Opposite knife hand", false);
        v10.menu.vis.jitter_legs = v14.user_interface:switch("\v\f<person-walking-with-cane>\r Jitter legs", false);
        local v41 = v10.menu.vis.jitter_legs:create();
        v10.menu.vis.jitter_legs_from = v41:slider("From\n", 1, 100, 0, 1, function(v42)
            return v42 / 100 .. "x";
        end):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v10.menu.vis.jitter_legs
        });
        v10.menu.vis.jitter_legs_to = v41:slider("To\n", 1, 100, 0, 1, function(v43)
            return v43 / 100 .. "x";
        end):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v10.menu.vis.jitter_legs
        });
        v10.menu.vis.animations_fall_amount = v14.user_interface:slider("\v\f<person-falling>\r Falling", 1, 100, 50, 1, function(v44)
            return v44 .. "%";
        end);
        v10.menu.vis.animations_lean_amount = v14.user_interface:slider("\v\f<person>\r Leaning", 1, 100, 0, 1, function(v45)
            return v45 .. "%";
        end);
        v10.menu.vis.animations_slide_amount = v14.user_interface:slider("\v\f<person-walking>\r Sliding", 1, 100, 50, 1, function(v46)
            return v46 .. "%";
        end):depend({
            [1] = nil, 
            [2] = false, 
            [1] = v10.menu.vis.jitter_legs
        });
        v10.menu.vis.disable_sleeves = v14.visuals:switch("\v\f<hand>\r Disable Sleeves", false);
        v10.menu.vis.netgraph_enable = v14.visuals:switch("\v\f<wifi>\r Custom Netgraph", false, color(158, 155, 178, 255));
        v10.menu.vis.dmgindicator = v14.overlays:switch("\v\f<claw-marks>\r Minimum Damage Indicator");
        v10.menu.vis.manual_arrows = v14.overlays:switch("\v\f<arrows-to-dot>\r Visualize Manual AA", false, color(255, 0, 0, 255));
        v10.menu.vis.hit_marker = v14.overlays:switch("\v\f<crosshairs-simple>\r Hit Marker [Crosshair]", false, color(255, 255, 255, 255));
        v10.menu.vis.kibit_marker = v14.overlays:switch("\v\f<crosshairs-simple>\r Hit Marker [World]", false);
        v10.menu.vis.gingerindicators = v14.overlays:switch("\v\f<burger>\r Happy Meal Indicators", false);
        v10.menu.misc.fakeduck_label = v14.movement:label("\v\f<duck>\r Fakeduck Modifiers");
        v10.menu.misc.no_fall = v14.movement:switch("\v\f<person-falling>\r No Fall Damage", false);
        local v47 = v10.menu.misc.fakeduck_label:create();
        v10.menu.misc.freezetime_fakeduck = v47:switch("Freezetime Fakeduck", false);
        v10.menu.misc.unlock_fakeduck_speed = v47:switch("Override Fakeduck Speed", false);
        v10.menu.misc.disable_cvars = v14.common:switch("\v\f<layer-group>\r Disable Useless Cvars");
        v10.menu.misc.pingspike = v14.common:label("\v\f<signal-stream>\r Unlock Fake Latency");
        local v48 = v10.menu.misc.pingspike:create();
        v10.menu.misc.extended_ping_amount = v48:slider("Fake Latency", 0, 200, 0, nil);
        v10.menu.misc.fast_ladder = v14.movement:switch("\v\f<water-ladder>\r Fast Ladder", false);
        v10.menu.misc.hitlogs_label = v14.common:label("\v\f<calendar-lines-pen>\r Print Events");
        local v49 = v10.menu.misc.hitlogs_label:create();
        v10.menu.misc.hitlogs = v49:selectable("Appereance", "On screen", "Console", "Center screen");
        v10.menu.misc.hitlog_color = v49:label("", color(161, 135, 153)):depend({
            [1] = nil, 
            [2] = "On screen", 
            [1] = v10.menu.misc.hitlogs
        }):depend({
            [1] = nil, 
            [2] = "On screen", 
            [1] = v10.menu.misc.hitlogs
        });
        v10.menu.misc.extra_notifications = v14.common:label("\v\f<calendar-xmark>\r Notifications");
        local v50 = v10.menu.misc.extra_notifications:create();
        v10.menu.misc.extra_notification_options = v50:selectable("Display", "Anti-Bruteforce");
        v10.menu.misc.killsay = v14.common:label("\v\f<trash>\r Trashtalk");
        local v51 = v10.menu.misc.killsay:create();
        v10.menu.misc.trashtalk_states = v51:selectable("Trashtalk on", "Death", "Kill");
    end, 
    sidebarname = function(v52)
        -- upvalues: l_pui_0 (ref)
        local v53 = {
            [1] = "\240\159\146\128", 
            [2] = "\240\159\152\173", 
            [3] = "\240\159\152\158", 
            [4] = "\240\159\145\191", 
            [5] = "\240\159\171\131"
        };
        local v54 = v52.menu.global.sidebar_color:get_color();
        local l_r_0 = v54.r;
        local l_g_0 = v54.g;
        local l_b_0 = v54.b;
        local l_a_0 = v54.a;
        if v52.globals.current_logo > 5 then
            v52.globals.current_logo = 0;
        end;
        if v52.globals.logo_counter % 125 == 0 then
            v52.globals.current_logo = v52.globals.current_logo + 1;
        end;
        l_pui_0.sidebar(v52.helpers:gradienttext(globals.curtime, v52.menu.global.sidebar_text:get(), l_r_0, l_g_0, l_b_0, l_a_0, 255, 87, 31, 255, v52.menu.global.sidebar_speed:get()), v53[v52.globals.current_logo]);
        v52.globals.logo_counter = v52.globals.logo_counter + 1;
    end
}):struct("config")({
    config_file = "gingersense.txt", 
    storage = {}, 
    default_configs = {
        burger_smasher = "{gingersense:config}:W3sic2lkZWJhcl9jb2xvciI6IiM5RTlCQjJGRiIsInNpZGViYXJfdGV4dCI6IlRSQUpZUsOEIiwid2F0ZXJtYXJrX2NvbG9yIjoiIzRBM0FDMkZGIiwid2F0ZXJtYXJrX2ZvbnQiOjIuMCwid2F0ZXJtYXJrX2dyYWRpZW50IjoyLjAsIndhdGVybWFya19zdHlsZSI6IkN1c3RvbSIsIndhdGVybWFya190ZXh0Ijoi0LLRgdC1INGA0YPRgdGB0LrQuNC1INGD0LzRgNGD0YIg0LzRg9GH0LjRgtC10LvRjNC90L7QuSDRgdC80LXRgNGC0YzRjiJ9LHsiZnJlZXN0YW5kaW5nIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2Rpc2FibGVycyI6WyJ+Il0sImhpZGVoZWFkX29wdGlvbnMiOlsifiJdLCJtYW51YWxfYWEiOiJPZmYiLCJvcHRpb25zIjpbIldhcm11cCBBQSIsIlJvdW5kIGVuZCBBQSIsIkF2b2lkIEJhY2tzdGFiIiwifiJdLCJzdGF0ZSI6InJ1biIsInN0YXRlcyI6eyJkdWNrIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsiQWx3YXlzIiwifiJdLCJkZWxheSI6dHJ1ZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6Ik5ldF91cGRhdGUiLCJkZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiZGVsYXlfc2xpZGVycyI6MS4wLCJmYWtlbGltaXRfbCI6NjAuMCwiZmFrZWxpbWl0X3IiOjYwLjAsInJhbmRvbV9kZWxheV92YWx1ZV8xIjo0LjAsInJhbmRvbV9kZWxheV92YWx1ZV8yIjo0LjAsInJhbmRvbWl6YXRpb24iOjIwLjAsInN3aXRjaF9kZWxheSI6NC4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotNDQuMCwieWF3X2FkZF9yIjoyOC4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6IkdpbmdlcmJvbWJlciIsInlhd19qaXR0ZXJfYWRkIjozMC4wLCJ5YXdfaml0dGVyX21vZGUiOiJDdXN0b20iLCJ5YXdfaml0dGVyX293bjEiOjM2LjAsInlhd19qaXR0ZXJfb3duMiI6LTI2LjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NzguMCwieWF3X2ppdHRlcl9zbGlkZXIyIjozNS4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoyLjB9LCJkdWNrIGp1bXAiOnsiYW50aWJydXRlZm9yY2VfZW5hYmxlIjp0cnVlLCJhbnRpYnJ1dGVmb3JjZV9tb2RpZmllcnMiOlsiRmFrZSBsaW1pdCIsIkRlbGF5IiwiTW9kaWZpZXIiLCJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsiQWx3YXlzIiwifiJdLCJkZWxheSI6dHJ1ZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6IkNyZWF0ZW1vdmUiLCJkZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiZGVsYXlfc2xpZGVycyI6MS4wLCJmYWtlbGltaXRfbCI6NjAuMCwiZmFrZWxpbWl0X3IiOjYwLjAsInJhbmRvbV9kZWxheV92YWx1ZV8xIjo1LjAsInJhbmRvbV9kZWxheV92YWx1ZV8yIjo4LjAsInJhbmRvbWl6YXRpb24iOjEwLjAsInN3aXRjaF9kZWxheSI6Ni4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotMjcuMCwieWF3X2FkZF9yIjozNS4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0Ijp0cnVlLCJ5YXdfaml0dGVyIjoiR2luZ2VyYm9tYmVyIiwieWF3X2ppdHRlcl9hZGQiOi0zLjAsInlhd19qaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfaml0dGVyX293bjEiOi0zNi4wLCJ5YXdfaml0dGVyX293bjIiOjMwLjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIyIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoxLjB9LCJkdWNrIG1vdmUiOnsiYW50aWJydXRlZm9yY2VfZW5hYmxlIjpmYWxzZSwiYW50aWJydXRlZm9yY2VfbW9kaWZpZXJzIjpbIn4iXSwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd190aWNrcyI6MTIuMCwiY2xlYW5yZWNvcmRzIjpmYWxzZSwiY2xlYW5yZWNvcmRzX3JhbmRvbV9mbGljayI6ZmFsc2UsImNsZWFucmVjb3Jkc191c2VmYWtlbGFnIjpmYWxzZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJ+Il0sImRlbGF5Ijp0cnVlLCJkZWxheV9pbnRlcmFjdGlvbl90eXBlIjoiQ3JlYXRlbW92ZSIsImRlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJkZWxheV9zbGlkZXJzIjoxLjAsImZha2VsaW1pdF9sIjo2MC4wLCJmYWtlbGltaXRfciI6NjAuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzEiOjEuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzIiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wLCJzd2l0Y2hfZGVsYXkiOjQuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMxIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMiI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczMiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM0IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczYiOjEuMCwieWF3X2FkZCI6LTMyLjAsInlhd19hZGRfciI6NDEuMCwieWF3X2hlYWRiZWhpbmRjaGVzdCI6ZmFsc2UsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfaml0dGVyX2FkZCI6LTguMCwieWF3X2ppdHRlcl9tb2RlIjoiRGVmYXVsdCIsInlhd19qaXR0ZXJfb3duMSI6LTI1LjAsInlhd19qaXR0ZXJfb3duMiI6MzAuMCwieWF3X2ppdHRlcl9zbGlkZXIxIjotMTkuMCwieWF3X2ppdHRlcl9zbGlkZXIyIjo0MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoyLjB9LCJqdW1wIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6dHJ1ZSwiY2xlYW5yZWNvcmRzX3JhbmRvbV9mbGljayI6ZmFsc2UsImNsZWFucmVjb3Jkc191c2VmYWtlbGFnIjpmYWxzZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJBbHdheXMiLCJ+Il0sImRlbGF5Ijp0cnVlLCJkZWxheV9pbnRlcmFjdGlvbl90eXBlIjoiTmV0X3VwZGF0ZSIsImRlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJkZWxheV9zbGlkZXJzIjoxLjAsImZha2VsaW1pdF9sIjo2MC4wLCJmYWtlbGltaXRfciI6NjAuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzEiOjEuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzIiOjEuMCwicmFuZG9taXphdGlvbiI6Ny4wLCJzd2l0Y2hfZGVsYXkiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMxIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMiI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczMiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM0IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczYiOjEuMCwieWF3X2FkZCI6LTEzLjAsInlhd19hZGRfciI6MjguMCwieWF3X2hlYWRiZWhpbmRjaGVzdCI6ZmFsc2UsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfaml0dGVyX2FkZCI6LTcuMCwieWF3X2ppdHRlcl9tb2RlIjoiRGVmYXVsdCIsInlhd19qaXR0ZXJfb3duMSI6MC4wLCJ5YXdfaml0dGVyX293bjIiOjAuMCwieWF3X2ppdHRlcl9zbGlkZXIxIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjIiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMyI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI0Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjUiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNiI6NTAuMCwieWF3X3NsaWRlcnMiOjEuMH0sInJ1biI6eyJhbnRpYnJ1dGVmb3JjZV9lbmFibGUiOnRydWUsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJGYWtlIGxpbWl0IiwiRGVsYXkiLCJNb2RpZmllciIsIn4iXSwiYm9keV95YXciOiJKaXR0ZXIiLCJib2R5X3lhd190aWNrcyI6MTIuMCwiY2xlYW5yZWNvcmRzIjpmYWxzZSwiY2xlYW5yZWNvcmRzX3JhbmRvbV9mbGljayI6ZmFsc2UsImNsZWFucmVjb3Jkc191c2VmYWtlbGFnIjpmYWxzZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJ+Il0sImRlbGF5Ijp0cnVlLCJkZWxheV9pbnRlcmFjdGlvbl90eXBlIjoiQ3JlYXRlbW92ZSIsImRlbGF5X21ldGhvZCI6IlJhbmRvbSIsImRlbGF5X3NsaWRlcnMiOjEuMCwiZmFrZWxpbWl0X2wiOjYwLjAsImZha2VsaW1pdF9yIjo2MC4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMSI6Ni4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMiI6Ni4wLCJyYW5kb21pemF0aW9uIjo5LjAsInN3aXRjaF9kZWxheSI6NC4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotMzEuMCwieWF3X2FkZF9yIjozMS4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6IkdpbmdlcmJvbWJlciIsInlhd19qaXR0ZXJfYWRkIjozNi4wLCJ5YXdfaml0dGVyX21vZGUiOiJEZWZhdWx0IiwieWF3X2ppdHRlcl9vd24xIjoyLjAsInlhd19qaXR0ZXJfb3duMiI6LTE3LjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIyIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoxLjB9LCJzbG93IHdhbGsiOnsiYW50aWJydXRlZm9yY2VfZW5hYmxlIjpmYWxzZSwiYW50aWJydXRlZm9yY2VfbW9kaWZpZXJzIjpbIn4iXSwiYm9keV95YXciOiJPZmYiLCJib2R5X3lhd190aWNrcyI6MTIuMCwiY2xlYW5yZWNvcmRzIjpmYWxzZSwiY2xlYW5yZWNvcmRzX3JhbmRvbV9mbGljayI6ZmFsc2UsImNsZWFucmVjb3Jkc191c2VmYWtlbGFnIjpmYWxzZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJ+Il0sImRlbGF5IjpmYWxzZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6IkNyZWF0ZW1vdmUiLCJkZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiZGVsYXlfc2xpZGVycyI6MS4wLCJmYWtlbGltaXRfbCI6MzIuMCwiZmFrZWxpbWl0X3IiOjMyLjAsInJhbmRvbV9kZWxheV92YWx1ZV8xIjoxLjAsInJhbmRvbV9kZWxheV92YWx1ZV8yIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMCwic3dpdGNoX2RlbGF5IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczIiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMzIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNCI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczUiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM2IjoxLjAsInlhd19hZGQiOi0zNS4wLCJ5YXdfYWRkX3IiOjM1LjAsInlhd19oZWFkYmVoaW5kY2hlc3QiOmZhbHNlLCJ5YXdfaml0dGVyIjoiT2ZmIiwieWF3X2ppdHRlcl9hZGQiOjAuMCwieWF3X2ppdHRlcl9tb2RlIjoiRGVmYXVsdCIsInlhd19qaXR0ZXJfb3duMSI6MC4wLCJ5YXdfaml0dGVyX293bjIiOjAuMCwieWF3X2ppdHRlcl9zbGlkZXIxIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjIiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMyI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI0Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjUiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNiI6NTAuMCwieWF3X3NsaWRlcnMiOjEuMH0sInN0YW5kIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6dHJ1ZSwiY2xlYW5yZWNvcmRzX3JhbmRvbV9mbGljayI6ZmFsc2UsImNsZWFucmVjb3Jkc191c2VmYWtlbGFnIjpmYWxzZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJ+Il0sImRlbGF5Ijp0cnVlLCJkZWxheV9pbnRlcmFjdGlvbl90eXBlIjoiTmV0X3VwZGF0ZSIsImRlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJkZWxheV9zbGlkZXJzIjoxLjAsImZha2VsaW1pdF9sIjo2MC4wLCJmYWtlbGltaXRfciI6NjAuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzEiOjEuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzIiOjEuMCwicmFuZG9taXphdGlvbiI6MC4wLCJzd2l0Y2hfZGVsYXkiOjUuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMxIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMiI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczMiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM0IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczYiOjEuMCwieWF3X2FkZCI6LTI0LjAsInlhd19hZGRfciI6NDEuMCwieWF3X2hlYWRiZWhpbmRjaGVzdCI6ZmFsc2UsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfaml0dGVyX2FkZCI6MC4wLCJ5YXdfaml0dGVyX21vZGUiOiJEZWZhdWx0IiwieWF3X2ppdHRlcl9vd24xIjowLjAsInlhd19qaXR0ZXJfb3duMiI6MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjEiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMiI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIzIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjQiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI2Ijo1MC4wLCJ5YXdfc2xpZGVycyI6MS4wfX0sInRyb2xsX2FhX29wdGlvbnMiOiJTcGluIiwidHJvbGxfYWFfc3BlZWQiOjUuMCwieWF3bW9kaWZpZXIiOlsiRm9yY2Ugc3RhdGljIiwifiJdfSx7ImRpc2FibGVfY3ZhcnMiOnRydWUsImV4dGVuZGVkX3BpbmdfYW1vdW50IjowLjAsImV4dHJhX25vdGlmaWNhdGlvbl9vcHRpb25zIjpbIkFudGktYnJ1dGVmb3JjZSIsIn4iXSwiZmFzdF9sYWRkZXIiOnRydWUsImZyZWV6ZXRpbWVfZmFrZWR1Y2siOnRydWUsImhpdGxvZ19jb2xvciI6IiNDQkIxQzNGRiIsImhpdGxvZ3MiOlsiT24gc2NyZWVuIiwiQ29uc29sZSIsIkNlbnRlciBzY3JlZW4iLCJ+Il0sIm5vX2ZhbGwiOmZhbHNlLCJ0cmFzaHRhbGtfc3RhdGVzIjpbIn4iXSwidW5sb2NrX2Zha2VkdWNrX3NwZWVkIjpmYWxzZX0seyIqaGl0X21hcmtlciI6IiNCM0IzQjNGRiIsIiptYW51YWxfYXJyb3dzIjoiIzc0NkZCRUZGIiwiKm5ldGdyYXBoX2VuYWJsZSI6IiM5RTlCQjJGRiIsImFuaW1hdGlvbnNfZmFsbF9hbW91bnQiOjEuMCwiYW5pbWF0aW9uc19sZWFuX2Ftb3VudCI6MS4wLCJhbmltYXRpb25zX3NsaWRlX2Ftb3VudCI6MS4wLCJhc3BlY3RfcmF0aW9fZW5hYmxlIjp0cnVlLCJhc3BlY3RyYXRpbyI6MTMwLjAsImRpc2FibGVfc2xlZXZlcyI6dHJ1ZSwiZG1naW5kaWNhdG9yIjpmYWxzZSwiZ2luZ2VyaW5kaWNhdG9ycyI6ZmFsc2UsImhpdF9tYXJrZXIiOnRydWUsImppdHRlcl9sZWdzIjp0cnVlLCJqaXR0ZXJfbGVnc19mcm9tIjoxLjAsImppdHRlcl9sZWdzX3RvIjo3My4wLCJraWJpdF9tYXJrZXIiOnRydWUsIm1hbnVhbF9hcnJvd3MiOnRydWUsIm5ldGdyYXBoX2VuYWJsZSI6dHJ1ZSwic2NvcGVfb3ZlcmxheSI6dHJ1ZSwic2NvcGVfb3ZlcmxheV9jb2xvciI6IiM4NTg1ODVGRiIsInNjb3BlX292ZXJsYXlfZ2FwIjo2OS4wLCJzY29wZV9vdmVybGF5X2xpbmUiOjE3LjAsInNjb3BlX292ZXJsYXlfcm90YXRlIjp0cnVlLCJ2aWV3bW9kZWxfZm92Ijo2OTcuMCwidmlld21vZGVsX2tuaWZlaGFuZCI6ZmFsc2UsInZpZXdtb2RlbF94IjoxMC4wLCJ2aWV3bW9kZWxfeSI6OS4wLCJ2aWV3bW9kZWxfeiI6MjMuMH1d", 
        DEFAULT_pirex = "{gingersense:config}:W3sic2lkZWJhcl9jb2xvciI6IiM5RTlCQjJGRiIsInNpZGViYXJfc3BlZWQiOjEuMCwic2lkZWJhcl90ZXh0IjoiZzFOZ+KCrFIkZU4kRSIsIndhdGVybWFya19jb2xvciI6IiNBMjlGQjZGRiIsIndhdGVybWFya19mb250IjozLjAsIndhdGVybWFya19ncmFkaWVudCI6Mi4wLCJ3YXRlcm1hcmtfc3BlZWQiOjEuMCwid2F0ZXJtYXJrX3N0eWxlIjoiQ3VzdG9tIiwid2F0ZXJtYXJrX3RleHQiOiJnMU5n4oKsUiRlTiRFIPCfmIggTkVXIEVSQSRfJCJ9LHsiZnJlZXN0YW5kaW5nIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2Rpc2FibGVycyI6WyJ+Il0sImhpZGVoZWFkX29wdGlvbnMiOlsifiJdLCJtYW51YWxfYWEiOiJPZmYiLCJvcHRpb25zIjpbIkF2b2lkIEJhY2tzdGFiIiwifiJdLCJzdGF0ZSI6ImR1Y2sganVtcCIsInN0YXRlcyI6eyJkdWNrIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsiQWx3YXlzIiwifiJdLCJkZWZlbnNpdmVfZGlzYWJsZV9vcHRpb24iOmZhbHNlLCJkZWxheSI6dHJ1ZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6Ik5ldF91cGRhdGUiLCJkZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiZGVsYXlfc2xpZGVycyI6MS4wLCJmYWtlbGltaXRfbCI6NjAuMCwiZmFrZWxpbWl0X3IiOjYwLjAsInJhbmRvbV9kZWxheV92YWx1ZV8xIjo0LjAsInJhbmRvbV9kZWxheV92YWx1ZV8yIjo0LjAsInJhbmRvbWl6YXRpb24iOjIwLjAsInN3aXRjaF9kZWxheSI6NC4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotNDQuMCwieWF3X2FkZF9yIjoyOC4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6IkdpbmdlcmJvbWJlciIsInlhd19qaXR0ZXJfYWRkIjozMC4wLCJ5YXdfaml0dGVyX21vZGUiOiJDdXN0b20iLCJ5YXdfaml0dGVyX293bjEiOjM2LjAsInlhd19qaXR0ZXJfb3duMiI6LTI2LjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NzguMCwieWF3X2ppdHRlcl9zbGlkZXIyIjozNS4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoyLjB9LCJkdWNrIGp1bXAiOnsiYW50aWJydXRlZm9yY2VfZW5hYmxlIjp0cnVlLCJhbnRpYnJ1dGVmb3JjZV9tb2RpZmllcnMiOlsiRmFrZSBsaW1pdCIsIkRlbGF5IiwiTW9kaWZpZXIiLCJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6dHJ1ZSwiZGVmZW5zaXZlX2FjdGl2YXRpb25fb3B0aW9ucyI6WyJBbHdheXMiLCJ+Il0sImRlZmVuc2l2ZV9kaXNhYmxlX29wdGlvbiI6dHJ1ZSwiZGVsYXkiOnRydWUsImRlbGF5X2ludGVyYWN0aW9uX3R5cGUiOiJDcmVhdGVtb3ZlIiwiZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImRlbGF5X3NsaWRlcnMiOjEuMCwiZmFrZWxpbWl0X2wiOjYwLjAsImZha2VsaW1pdF9yIjo2MC4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMSI6NS4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMiI6OC4wLCJyYW5kb21pemF0aW9uIjoxMC4wLCJzd2l0Y2hfZGVsYXkiOjYuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMxIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMiI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczMiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM0IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczYiOjEuMCwieWF3X2FkZCI6LTI3LjAsInlhd19hZGRfciI6MzUuMCwieWF3X2hlYWRiZWhpbmRjaGVzdCI6dHJ1ZSwieWF3X2ppdHRlciI6IkdpbmdlcmJvbWJlciIsInlhd19qaXR0ZXJfYWRkIjotMy4wLCJ5YXdfaml0dGVyX21vZGUiOiJEZWZhdWx0IiwieWF3X2ppdHRlcl9vd24xIjotMzYuMCwieWF3X2ppdHRlcl9vd24yIjozMC4wLCJ5YXdfaml0dGVyX3NsaWRlcjEiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMiI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIzIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjQiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI2Ijo1MC4wLCJ5YXdfc2xpZGVycyI6MS4wfSwiZHVjayBtb3ZlIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsifiJdLCJkZWZlbnNpdmVfZGlzYWJsZV9vcHRpb24iOmZhbHNlLCJkZWxheSI6dHJ1ZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6IkNyZWF0ZW1vdmUiLCJkZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiZGVsYXlfc2xpZGVycyI6MS4wLCJmYWtlbGltaXRfbCI6NjAuMCwiZmFrZWxpbWl0X3IiOjYwLjAsInJhbmRvbV9kZWxheV92YWx1ZV8xIjoxLjAsInJhbmRvbV9kZWxheV92YWx1ZV8yIjoxLjAsInJhbmRvbWl6YXRpb24iOjAuMCwic3dpdGNoX2RlbGF5Ijo0LjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczIiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMzIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNCI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczUiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM2IjoxLjAsInlhd19hZGQiOi0zMi4wLCJ5YXdfYWRkX3IiOjQxLjAsInlhd19oZWFkYmVoaW5kY2hlc3QiOmZhbHNlLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X2ppdHRlcl9hZGQiOi04LjAsInlhd19qaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfaml0dGVyX293bjEiOi0yNS4wLCJ5YXdfaml0dGVyX293bjIiOjMwLjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6LTE5LjAsInlhd19qaXR0ZXJfc2xpZGVyMiI6NDAuMCwieWF3X2ppdHRlcl9zbGlkZXIzIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjQiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI2Ijo1MC4wLCJ5YXdfc2xpZGVycyI6Mi4wfSwianVtcCI6eyJhbnRpYnJ1dGVmb3JjZV9lbmFibGUiOmZhbHNlLCJhbnRpYnJ1dGVmb3JjZV9tb2RpZmllcnMiOlsifiJdLCJib2R5X3lhdyI6IkppdHRlciIsImJvZHlfeWF3X3RpY2tzIjoxMi4wLCJjbGVhbnJlY29yZHMiOmZhbHNlLCJjbGVhbnJlY29yZHNfcmFuZG9tX2ZsaWNrIjpmYWxzZSwiY2xlYW5yZWNvcmRzX3VzZWZha2VsYWciOmZhbHNlLCJkZWZlbnNpdmVfYWN0aXZhdGlvbl9vcHRpb25zIjpbIkFsd2F5cyIsIn4iXSwiZGVmZW5zaXZlX2Rpc2FibGVfb3B0aW9uIjpmYWxzZSwiZGVsYXkiOnRydWUsImRlbGF5X2ludGVyYWN0aW9uX3R5cGUiOiJOZXRfdXBkYXRlIiwiZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImRlbGF5X3NsaWRlcnMiOjEuMCwiZmFrZWxpbWl0X2wiOjYwLjAsImZha2VsaW1pdF9yIjo2MC4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMSI6MS4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMiI6MS4wLCJyYW5kb21pemF0aW9uIjo3LjAsInN3aXRjaF9kZWxheSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotMTMuMCwieWF3X2FkZF9yIjoyOC4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19qaXR0ZXJfYWRkIjotNy4wLCJ5YXdfaml0dGVyX21vZGUiOiJEZWZhdWx0IiwieWF3X2ppdHRlcl9vd24xIjowLjAsInlhd19qaXR0ZXJfb3duMiI6MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjEiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMiI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIzIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjQiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI2Ijo1MC4wLCJ5YXdfc2xpZGVycyI6MS4wfSwicnVuIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiSml0dGVyIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsiQWx3YXlzIiwifiJdLCJkZWZlbnNpdmVfZGlzYWJsZV9vcHRpb24iOmZhbHNlLCJkZWxheSI6dHJ1ZSwiZGVsYXlfaW50ZXJhY3Rpb25fdHlwZSI6IkNyZWF0ZW1vdmUiLCJkZWxheV9tZXRob2QiOiJSYW5kb20iLCJkZWxheV9zbGlkZXJzIjoxLjAsImZha2VsaW1pdF9sIjo2MC4wLCJmYWtlbGltaXRfciI6NjAuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzEiOjYuMCwicmFuZG9tX2RlbGF5X3ZhbHVlXzIiOjYuMCwicmFuZG9taXphdGlvbiI6OS4wLCJzd2l0Y2hfZGVsYXkiOjQuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMxIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMiI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczMiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM0IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczYiOjEuMCwieWF3X2FkZCI6LTMxLjAsInlhd19hZGRfciI6MzEuMCwieWF3X2hlYWRiZWhpbmRjaGVzdCI6ZmFsc2UsInlhd19qaXR0ZXIiOiJHaW5nZXJib21iZXIiLCJ5YXdfaml0dGVyX2FkZCI6MzYuMCwieWF3X2ppdHRlcl9tb2RlIjoiRGVmYXVsdCIsInlhd19qaXR0ZXJfb3duMSI6Mi4wLCJ5YXdfaml0dGVyX293bjIiOi0xNy4wLCJ5YXdfaml0dGVyX3NsaWRlcjEiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyMiI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIzIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjQiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI2Ijo1MC4wLCJ5YXdfc2xpZGVycyI6MS4wfSwic2xvdyB3YWxrIjp7ImFudGlicnV0ZWZvcmNlX2VuYWJsZSI6ZmFsc2UsImFudGlicnV0ZWZvcmNlX21vZGlmaWVycyI6WyJ+Il0sImJvZHlfeWF3IjoiT2ZmIiwiYm9keV95YXdfdGlja3MiOjEyLjAsImNsZWFucmVjb3JkcyI6ZmFsc2UsImNsZWFucmVjb3Jkc19yYW5kb21fZmxpY2siOmZhbHNlLCJjbGVhbnJlY29yZHNfdXNlZmFrZWxhZyI6ZmFsc2UsImRlZmVuc2l2ZV9hY3RpdmF0aW9uX29wdGlvbnMiOlsifiJdLCJkZWZlbnNpdmVfZGlzYWJsZV9vcHRpb24iOmZhbHNlLCJkZWxheSI6ZmFsc2UsImRlbGF5X2ludGVyYWN0aW9uX3R5cGUiOiJDcmVhdGVtb3ZlIiwiZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImRlbGF5X3NsaWRlcnMiOjEuMCwiZmFrZWxpbWl0X2wiOjMyLjAsImZha2VsaW1pdF9yIjozMi4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMSI6MS4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMiI6MS4wLCJyYW5kb21pemF0aW9uIjowLjAsInN3aXRjaF9kZWxheSI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotMzUuMCwieWF3X2FkZF9yIjozNS4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19qaXR0ZXJfYWRkIjowLjAsInlhd19qaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfaml0dGVyX293bjEiOjAuMCwieWF3X2ppdHRlcl9vd24yIjowLjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIyIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoxLjB9LCJzdGFuZCI6eyJhbnRpYnJ1dGVmb3JjZV9lbmFibGUiOmZhbHNlLCJhbnRpYnJ1dGVmb3JjZV9tb2RpZmllcnMiOlsifiJdLCJib2R5X3lhdyI6IkppdHRlciIsImJvZHlfeWF3X3RpY2tzIjoxMi4wLCJjbGVhbnJlY29yZHMiOmZhbHNlLCJjbGVhbnJlY29yZHNfcmFuZG9tX2ZsaWNrIjpmYWxzZSwiY2xlYW5yZWNvcmRzX3VzZWZha2VsYWciOmZhbHNlLCJkZWZlbnNpdmVfYWN0aXZhdGlvbl9vcHRpb25zIjpbIn4iXSwiZGVmZW5zaXZlX2Rpc2FibGVfb3B0aW9uIjpmYWxzZSwiZGVsYXkiOnRydWUsImRlbGF5X2ludGVyYWN0aW9uX3R5cGUiOiJOZXRfdXBkYXRlIiwiZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImRlbGF5X3NsaWRlcnMiOjEuMCwiZmFrZWxpbWl0X2wiOjYwLjAsImZha2VsaW1pdF9yIjo2MC4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMSI6MS4wLCJyYW5kb21fZGVsYXlfdmFsdWVfMiI6MS4wLCJyYW5kb21pemF0aW9uIjowLjAsInN3aXRjaF9kZWxheSI6NS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczEiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnMyIjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzMyI6MS4wLCJzd2l0Y2hfZGVsYXlfc2xpZGVyczQiOjEuMCwic3dpdGNoX2RlbGF5X3NsaWRlcnM1IjoxLjAsInN3aXRjaF9kZWxheV9zbGlkZXJzNiI6MS4wLCJ5YXdfYWRkIjotMjQuMCwieWF3X2FkZF9yIjo0MS4wLCJ5YXdfaGVhZGJlaGluZGNoZXN0IjpmYWxzZSwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19qaXR0ZXJfYWRkIjowLjAsInlhd19qaXR0ZXJfbW9kZSI6IkRlZmF1bHQiLCJ5YXdfaml0dGVyX293bjEiOjAuMCwieWF3X2ppdHRlcl9vd24yIjowLjAsInlhd19qaXR0ZXJfc2xpZGVyMSI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXIyIjo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjMiOjUwLjAsInlhd19qaXR0ZXJfc2xpZGVyNCI6NTAuMCwieWF3X2ppdHRlcl9zbGlkZXI1Ijo1MC4wLCJ5YXdfaml0dGVyX3NsaWRlcjYiOjUwLjAsInlhd19zbGlkZXJzIjoxLjB9fSwidHJvbGxfYWFfb3B0aW9ucyI6IkhhbGYgU3BpbiIsInRyb2xsX2FhX3NwZWVkIjoyLjAsInlhd21vZGlmaWVyIjpbIkZvcmNlIHN0YXRpYyIsIn4iXX0seyJkaXNhYmxlX2N2YXJzIjp0cnVlLCJleHRlbmRlZF9waW5nX2Ftb3VudCI6NzIuMCwiZXh0cmFfbm90aWZpY2F0aW9uX29wdGlvbnMiOlsifiJdLCJmYXN0X2xhZGRlciI6dHJ1ZSwiZnJlZXpldGltZV9mYWtlZHVjayI6dHJ1ZSwiaGl0bG9nX2NvbG9yIjoiI0NCQjFDM0ZGIiwiaGl0bG9ncyI6WyJPbiBzY3JlZW4iLCJDb25zb2xlIiwifiJdLCJub19mYWxsIjp0cnVlLCJ0cmFzaHRhbGtfc3RhdGVzIjpbIkRlYXRoIiwiS2lsbCIsIn4iXSwidW5sb2NrX2Zha2VkdWNrX3NwZWVkIjp0cnVlfSx7IipoaXRfbWFya2VyIjoiIzgwODA4MEZGIiwiKm1hbnVhbF9hcnJvd3MiOiIjODY3Q0U3RkYiLCIqbmV0Z3JhcGhfZW5hYmxlIjoiIzlFOUJCMkZGIiwiYW5pbWF0aW9uc19mYWxsX2Ftb3VudCI6MS4wLCJhbmltYXRpb25zX2xlYW5fYW1vdW50Ijo1MC4wLCJhbmltYXRpb25zX3NsaWRlX2Ftb3VudCI6MS4wLCJhc3BlY3RfcmF0aW9fZW5hYmxlIjp0cnVlLCJhc3BlY3RyYXRpbyI6MTQwLjAsImRpc2FibGVfc2xlZXZlcyI6dHJ1ZSwiZG1naW5kaWNhdG9yIjp0cnVlLCJnaW5nZXJpbmRpY2F0b3JzIjp0cnVlLCJoaXRfbWFya2VyIjp0cnVlLCJqaXR0ZXJfbGVncyI6dHJ1ZSwiaml0dGVyX2xlZ3NfZnJvbSI6MzEuMCwiaml0dGVyX2xlZ3NfdG8iOjEuMCwia2liaXRfbWFya2VyIjp0cnVlLCJtYW51YWxfYXJyb3dzIjp0cnVlLCJuZXRncmFwaF9lbmFibGUiOmZhbHNlLCJzY29wZV9vdmVybGF5Ijp0cnVlLCJzY29wZV9vdmVybGF5X2NvbG9yIjoiI0JGQkJDRkFGIiwic2NvcGVfb3ZlcmxheV9nYXAiOjkuMCwic2NvcGVfb3ZlcmxheV9saW5lIjoxOS4wLCJzY29wZV9vdmVybGF5X3JvdGF0ZSI6ZmFsc2UsInZpZXdtb2RlbF9mb3YiOjY5My4wLCJ2aWV3bW9kZWxfa25pZmVoYW5kIjpmYWxzZSwidmlld21vZGVsX3giOjkuMCwidmlld21vZGVsX3kiOjE1LjAsInZpZXdtb2RlbF96IjoxMy4wfV0="
    }, 
    display_name_map = {}, 
    persist_data = function(_, v60, v61)
        if not v61 or type(v60) ~= "string" then
            return false;
        else
            return files.write(v60, json.stringify(v61));
        end;
    end, 
    retrieve_data = function(_, v63)
        local v64 = files.read(v63);
        return v64 and json.parse(v64) or {};
    end, 
    select_current_config = function(v65)
        local v66 = v65.ui.menu.cfg.list();
        local v67 = 1;
        for v68 in pairs(v65.default_configs) do
            if v66 == v67 or v66 == 0 then
                return v65.ui.menu.cfg.name(v68);
            else
                v67 = v67 + 1;
            end;
        end;
        if next(v65.storage) ~= nil then
            if v66 == v67 then
                return nil;
            else
                v67 = v67 + 1;
            end;
        end;
        for v69 in pairs(v65.storage) do
            if v66 == v67 then
                return v65.ui.menu.cfg.name(v69);
            else
                v67 = v67 + 1;
            end;
        end;
        return nil;
    end, 
    refresh_ui = function(v70)
        local v71 = {};
        v70.display_name_map = {};
        for v72 in pairs(v70.default_configs) do
            local v73 = "\a" .. ui.get_style()["Link Active"]:to_hex() .. "\226\128\162  \aDEFAULT" .. v72;
            table.insert(v71, v73);
            v70.display_name_map[v73] = v72;
        end;
        if next(v70.storage) ~= nil then
            table.insert(v71, "---------------------");
        end;
        for v74 in pairs(v70.storage) do
            table.insert(v71, v74);
            v70.display_name_map[v74] = v74;
        end;
        v70.ui.menu.cfg.list:update(v71);
        v70:persist_data(v70.config_file, v70.storage);
        v70:select_current_config();
        return v70;
    end, 
    initialize = function(v75)
        v75.storage = v75:retrieve_data(v75.config_file) or {};
        v75:refresh_ui();
        return v75;
    end, 
    encode = function(_, v77)
        -- upvalues: l_base64_0 (ref)
        return l_base64_0.encode(json.stringify(v77));
    end, 
    decode = function(_, v79)
        -- upvalues: l_base64_0 (ref)
        return json.parse(l_base64_0.decode(v79));
    end, 
    export_config = function(v80)
        -- upvalues: l_pui_0 (ref)
        return v80:encode((l_pui_0.setup({
            [1] = v80.ui.menu.global, 
            [2] = v80.ui.menu.aa, 
            [3] = v80.ui.menu.misc, 
            [4] = v80.ui.menu.vis
        }, true):save()));
    end, 
    export = function(v81, v82, ...)
        local v83 = "export_" .. v82;
        if not v81[v83] then
            v81.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Invalid export type");
            return nil, "Invalid export type";
        else
            local l_status_0, l_result_0 = pcall(v81[v83], v81, ...);
            if not l_status_0 then
                v81.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Export error");
                print("Export error:", l_result_0);
                return nil;
            else
                v81.helpers:add_notification("\a7583e0ff" .. ui.get_icon("floppy-disk") .. "\affffffff | Config successfully exported");
                return "{gingersense:" .. v82 .. "}:" .. l_result_0;
            end;
        end;
    end, 
    import_config = function(v86, v87)
        -- upvalues: l_pui_0 (ref)
        local v88 = v86:decode(v87);
        l_pui_0.setup({
            [1] = v86.ui.menu.global, 
            [2] = v86.ui.menu.aa, 
            [3] = v86.ui.menu.misc, 
            [4] = v86.ui.menu.vis
        }, true):load(v88);
    end, 
    validate_import = function(_, v90, v91)
        local v92 = v90:match("{gingersense:(.+)}");
        return v92 and v92 == v91;
    end, 
    import = function(v93, v94, v95, ...)
        if not v93:validate_import(v94, v95) then
            v93.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | This is not valid gingersense data. 1");
            return error("This is not valid gingersense data. 1");
        else
            local v96 = v94:gsub("{gingersense:" .. v95 .. "}:", "");
            local v97 = "import_" .. v95;
            local l_status_1, l_result_1 = pcall(v93[v97], v93, v96, ...);
            if not l_status_1 then
                print(l_result_1);
                v93.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | This is not valid gingersense data. 2");
                return error("This is not valid gingersense data. 2");
            else
                v93.helpers:add_notification("\a7583e0ff" .. ui.get_icon("floppy-disk") .. "\affffffff | Config successfully imported");
                return true;
            end;
        end;
    end, 
    save = function(v100)
        local v101 = v100.ui.menu.cfg.name();
        if not v101:match("%w") then
            v100.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Invalid config name");
            return print("Invalid config name");
        elseif v100.default_configs[v101] then
            v100.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Cannot overwrite default configs");
            return print("Cannot overwrite default config: " .. v101);
        else
            local v102 = v100:export("config");
            v100.storage[v101] = v102;
            v100:refresh_ui();
            v100.helpers:add_notification("\a7583e0ff" .. ui.get_icon("floppy-disk") .. "\affffffff | Config successfully saved");
            return true;
        end;
    end, 
    load = function(v103)
        local v104 = v103.ui.menu.cfg.name();
        local v105 = v103.storage[v104] or v103.default_configs[v104];
        if not v105 then
            v103.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Invalid config name");
            return print("Invalid config name");
        else
            return v103:import(v105, "config");
        end;
    end, 
    delete = function(v106)
        local v107 = v106.ui.menu.cfg.name();
        if v106.default_configs[v107] then
            v106.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Cannot delete default configs");
            return print("Cannot delete default config: " .. v107);
        elseif not v106.storage[v107] then
            v106.helpers:add_notification("\aff9494ff" .. ui.get_icon("xmark") .. "\affffffff | Invalid config name");
            return print("Invalid config name");
        else
            v106.helpers:add_notification("\a7583e0ff" .. ui.get_icon("xmark") .. "\affffffff | Config successfully removed");
            v106.storage[v107] = nil;
            v106:refresh_ui();
            return true;
        end;
    end
}):struct("helpers")({
    distance = 0, 
    tick_work = 0, 
    last_message_time = 0, 
    active_messages = {}, 
    contains = function(_, v109, v110)
        for _, v112 in pairs(v109) do
            if v112 == v110 then
                return true;
            end;
        end;
        return false;
    end, 
    easeInOut = function(_, v114)
        return v114 > 0.5 and 4 * (v114 - 1) ^ 3 + 1 or 4 * v114 ^ 3;
    end, 
    clamp = function(_, v116, v117, v118)
        if v118 < v117 then
            local l_v118_0 = v118;
            v118 = v117;
            v117 = l_v118_0;
        end;
        return math.max(v117, math.min(v118, v116));
    end, 
    in_air = function(_, v121)
        return bit.band(v121.m_fFlags, 1) == 0;
    end, 
    in_duck = function(_, v123)
        return bit.band(v123.m_fFlags, 4) == 4;
    end, 
    get_state = function(v124)
        local v125 = entity.get_local_player();
        local _ = v125.m_fFlags;
        local v127 = v125.m_vecVelocity:length2d();
        local v128 = v124:in_duck(v125) or v124.ref.rage.fd:get();
        if v124:in_air(v125) or v124.antiaim.state.air then
            return v128 and "duck jump" or "jump";
        elseif v127 > 3 and v128 then
            return "duck move";
        elseif v124.ref.antiaim.slowwalk:get() then
            return "slow walk";
        elseif v128 then
            return "duck";
        else
            return v127 > 1.5 and "run" or "stand";
        end;
    end, 
    u8 = function(_, v130)
        local v131 = {};
        local v132 = 0;
        for v133 in string.gmatch(v130, ".[\128-\191]*") do
            v132 = v132 + 1;
            v131[v132] = v133;
        end;
        return v131, v132;
    end, 
    gradienttext = function(v134, _, v136, v137, v138, v139, v140, v141, v142, v143, v144, v145)
        local v146 = "";
        local v147 = globals.realtime * v145 % 2 - 1;
        local v148, v149 = v134:u8(v136);
        for v150 = 1, v149 do
            local v151 = v148[v150];
            local v152 = (v150 - 1) / v149;
            local l_v137_0 = v137;
            local l_v138_0 = v138;
            local l_v139_0 = v139;
            local l_v140_0 = v140;
            local v157 = v152 - v147;
            if v157 >= 0 and v157 <= 1.4 then
                if v157 > 0.7 then
                    v157 = 1.4 - v157;
                end;
                local v158 = v141 - v137;
                local v159 = v142 - v138;
                local v160 = v143 - v139;
                local v161 = v144 - v140;
                l_v137_0 = l_v137_0 + v158 * v157 / 0.8;
                l_v138_0 = l_v138_0 + v159 * v157 / 0.8;
                l_v139_0 = l_v139_0 + v160 * v157 / 0.8;
                l_v140_0 = l_v140_0 + v161 * v157 / 0.8;
            end;
            v146 = v146 .. "\a" .. color(l_v137_0, l_v138_0, l_v139_0, l_v140_0):to_hex() .. v151;
        end;
        return v146;
    end, 
    get_charge = function(_)
        local v163 = entity.get_local_player();
        return globals.tickcount - v163.m_flSimulationTime / globals.tickinterval;
    end, 
    normalize = function(_, v165)
        v165 = (v165 % 360 + 360) % 360;
        return v165 > 180 and v165 - 360 or v165;
    end, 
    vec_closest_point_on_ray = function(_, v167, v168, v169)
        local v170 = v167 - v168;
        local v171 = v169 - v168;
        local v172 = #v171;
        v171.x = v171.x / v172;
        v171.y = v171.y / v172;
        v171.z = v171.z / v172;
        local v173 = v171.x * v170.x + v171.y * v170.y + v171.z * v170.z;
        if v173 < 0 then
            return v168;
        elseif v172 < v173 then
            return v169;
        else
            return vector(v168.x + v171.x * v173, v168.y + v171.y * v173, v168.z + v171.z * v173);
        end;
    end, 
    bullet_impact = function(v174, v175, v176, v177)
        v174.distance = v174:vec_closest_point_on_ray(v175, v176, v177):dist(v175);
        if v174.distance > 55 then
            return;
        else
            v174.tick_work = globals.tickcount;
            return;
        end;
    end, 
    add_notification = function(v178, v179)
        if #v178.active_messages >= 5 then
            table.remove(v178.active_messages, 1);
        end;
        table.insert(v178.active_messages, {
            text = v179, 
            start_time = globals.realtime, 
            expire_time = globals.realtime + 5
        });
        v178.last_message_time = globals.realtime;
    end, 
    extract_hex_colors = function(_, v181)
        local v182 = {};
        local v183 = 1;
        local v184 = "FFFFFF";
        for v185, v186, v187 in v181:gmatch("()%\a([A-Fa-f0-9]+)()") do
            if v186:upper() ~= "FFFFFFFF" then
                if v183 < v185 then
                    table.insert(v182, {
                        color = v184, 
                        text = v181:sub(v183, v185 - 1)
                    });
                end;
                v184 = v186;
                v183 = v187;
            end;
        end;
        if v183 <= #v181 then
            table.insert(v182, {
                color = v184, 
                text = v181:sub(v183)
            });
        end;
        return v182;
    end, 
    render_notifications = function(v188)
        if not globals.is_in_game or #v188.active_messages == 0 then
            return;
        else
            local l_realtime_0 = globals.realtime;
            local v190 = render.screen_size();
            local v191 = v190.x / 2;
            local v192 = v190.y / 1.2 - #v188.active_messages * 10;
            for v193 = #v188.active_messages, 1, -1 do
                if v188.active_messages[v193].expire_time < l_realtime_0 then
                    table.remove(v188.active_messages, v193);
                end;
            end;
            for v194, v195 in ipairs(v188.active_messages) do
                local v196 = 0.5;
                local v197 = 1;
                local v198 = l_realtime_0 - v195.start_time;
                local v199 = v195.expire_time - l_realtime_0;
                local l_text_0 = v195.text;
                local l_x_0 = render.measure_text(3, "c", l_text_0).x;
                local l_l_x_0_0 = l_x_0;
                local v203 = 255;
                local v204 = 0;
                if v198 < v196 then
                    local v205 = v198 / v196;
                    local v206 = 1 - (1 - v205) * (1 - v205);
                    v203 = math.floor(255 * v206);
                    v204 = (1 - v206) * 10;
                elseif v199 < v197 then
                    local v207 = v199 / v197;
                    local v208 = v207 * v207;
                    v203 = math.floor(255 * v208);
                    v204 = (1 - v208) * 10;
                end;
                if v198 < v196 then
                    local v209 = v198 / v196;
                    l_l_x_0_0 = l_x_0 * (1 - (1 - v209) * (1 - v209));
                elseif v199 < v197 then
                    local v210 = v199 / v197;
                    l_l_x_0_0 = l_x_0 * (v210 * v210);
                end;
                local v211 = v192 + (v194 - 1) * 34 + v204;
                local v212 = v191 - l_l_x_0_0 / 2 - 6;
                local v213 = v191 + l_l_x_0_0 / 2 + 6;
                local v214 = v188:extract_hex_colors(v195.text);
                local v215 = 6;
                local v216 = color(v214[1].color);
                local v217 = color(v216.r, v216.g, v216.b, v216.a * (v203 / 255));
                local v218 = 1;
                render.rect(vector(v212 + 1, v211 - 10), vector(v213 - 1, v211 + 13), color(29, 22, 41, 250 * (v203 / 255)), 6, true);
                render.line(vector(v212, v211 - 5), vector(v212, v211 + 9), v217);
                render.line(vector(v213 - 1, v211 - 5), vector(v213 - 1, v211 + 9), v217);
                render.circle_outline(vector(v212 + v215, v211 - 11 + v215), v217, v215, 180, 0.25, v218);
                render.circle_outline(vector(v213 - v215, v211 - 11 + v215), v217, v215, 270, 0.25, v218);
                render.circle_outline(vector(v213 - v215, v211 + 14 - v215), v217, v215, 0, 0.25, v218);
                render.circle_outline(vector(v212 + v215, v211 + 14 - v215), v217, v215, 90, 0.25, v218);
                local v219 = 1;
                if v198 < v196 then
                    local v220 = v198 / v196;
                    v219 = 1 - (1 - v220) * (1 - v220 * 0.95);
                elseif v199 < v197 then
                    local v221 = v199 / v197;
                    v219 = v221 * v221;
                end;
                local v222 = l_x_0 * v219;
                local v223 = v191 - v222 / 2;
                local v224 = v191 + v222 / 2;
                local v225 = v211 - 12;
                local v226 = v211 + 16;
                render.push_clip_rect(vector(v223, v225), vector(v224, v226));
                render.text(3, vector(v191, v211 + 1), color(255, 255, 255, v203), "c", l_text_0);
                render.pop_clip_rect();
            end;
            return;
        end;
    end
}):struct("antiaim")({
    constants = {
        states = {
            [1] = "global", 
            [2] = "stand", 
            [3] = "move", 
            [4] = "slow", 
            [5] = "air", 
            [6] = "duck", 
            [7] = "duck move", 
            [8] = "duck jump"
        }, 
        yaw_options = {
            Spin = 4, 
            Center = 2, 
            Random = 3, 
            Gingerbomber = 5, 
            Offset = 1
        }, 
        body_yaw_options = {
            Jitter = 2, 
            Off = 1, 
            Random = 3, 
            Tick = 4
        }, 
        manual_options = {
            Left = 1, 
            Forward = 3, 
            Right = 2
        }, 
        random_buffer = {}, 
        sin_cache = {}
    }, 
    state = {
        body_yaw_false_ticks = 0, 
        defensive_switch = false, 
        body_yaw_switch = false, 
        body_yaw_side = 0, 
        side = 0, 
        body_yaw_switch_delay = 0, 
        modifier_switch_delay = 0, 
        hold_delay = 0, 
        hold_time = 0, 
        switch_delay = 0, 
        air = false, 
        defensive_after = 0, 
        defensive_state = false, 
        activation_delay = 0, 
        current_safe_yaw = 0, 
        yaw_hold_ticks = 0, 
        current_slider = 1, 
        counter = 0, 
        round_ended = false, 
        last_rand = 0, 
        inverter_override_ticks = 0, 
        ab = {
            bruted_last_time = 0, 
            should_swap = {}, 
            time = {}, 
            jitteralgo = {}, 
            fakelimit = {}, 
            delay = {}
        }
    }, 
    init = function(v227)
        for v228 = 0, 3600 do
            v227.constants.sin_cache[v228] = math.sin(v228 * 0.1);
        end;
        for v229 = 1, 100 do
            v227.constants.random_buffer[v229] = math.random(-60, 60);
        end;
        return v227;
    end, 
    run = function(v230, v231)
        v230:apply_anti_aim(v231, (v230:get_aa_settings()));
    end, 
    get_aa_settings = function(v232)
        return v232:parse_settings(v232.ui.menu.aa.states);
    end, 
    reset_antibruteforce = function(v233)
        v233.state.ab.bruted_last_time = 0;
        v233.state.ab.time = {};
        v233.state.ab.jitteralgo = {};
        v233.state.ab.delay = {};
        v233.state.ab.fakelimit = {};
        v233.state.ab.should_swap = {};
    end, 
    shot_detection = function(v234, v235)
        if tick_work == globals.tickcount then
            return;
        elseif not globals.is_connected then
            return;
        elseif not entity.get_local_player():is_alive() then
            return;
        elseif not entity.get(v235.userid, true) then
            return;
        elseif not v235.userid then
            return;
        elseif entity.get(v235.userid, true):is_alive() == false then
            return;
        elseif entity.get(v235.userid, true):is_dormant() then
            return;
        elseif not entity.get(v235.userid, true):is_enemy() then
            return;
        else
            if math.abs(v234.state.ab.bruted_last_time - globals.curtime) > 0.25 then
                local v236 = vector(v235.x, v235.y, v235.z);
                local v237 = entity.get(v235.userid, true):get_eye_position();
                local v238 = entity.get_local_player():get_eye_position();
                local _ = v234.helpers:bullet_impact(v238, v237, v236);
                local v240 = entity.get(v235.userid, true);
                if v234.helpers.distance < 70 then
                    v234.state.ab.bruted_last_time = globals.curtime;
                    v234.state.ab.time[v240] = globals.curtime + 5;
                    v234.state.ab.jitteralgo[v240] = math.random(-6, 4);
                    v234.state.ab.delay[v240] = math.random(-2, 4);
                    v234.state.ab.fakelimit[v240] = math.random(10, 60);
                    v234.state.ab.should_swap[v240] = true;
                    if v234.helpers:contains(v234.ui.menu.misc.extra_notification_options:get(), "Anti-Bruteforce") then
                        v234.helpers:add_notification("\a7583e0ff" .. ui.get_icon("head-side-cough") .. "\affffffff | Anti-Bruteforce updated by ['\a7583e0ff" .. v240:get_name() .. "\affffffff's] shot [\a7583e0ff" .. v234.state.ab.jitteralgo[v240] .. "\affffffff;\a7583e0ff" .. v234.state.ab.fakelimit[v240] .. "\affffffff\194\176;\a7583e0ff" .. v234.state.ab.delay[v240] .. "\afffffffft]");
                    end;
                end;
            end;
            return;
        end;
    end, 
    parse_settings = function(v241, v242)
        local v243 = v241.helpers:get_state();
        local v244 = v241.settings_cache or {};
        v241.settings_cache = v244;
        if type(v242) == "string" then
            return json.parse(v242)[v243];
        else
            for v245 in pairs(v244) do
                v244[v245] = nil;
            end;
            for v246, v247 in pairs(v242[v243]) do
                v244[v246] = v247:get();
            end;
            return v244;
        end;
    end, 
    apply_anti_aim = function(v248, v249, v250)
        local v251 = entity.get_local_player();
        if not v251:is_alive() or not globals.is_in_game then
            v248.state.defensive_after = 0;
            return;
        else
            v248.state.air = v249.in_jump;
            if v248:handle_special_modes(v250) then
                return;
            else
                v248:handle_side_switching(v249, v250);
                local v252, v253 = v248:calculate_offsets(v250);
                local v254, v255, v256 = v248:handle_head_protection(v250, v251, v252, v253);
                if not v256 then
                    v248:apply_basic_settings();
                    v248.ref.antiaim.leftfake:override(v255);
                    v248.ref.antiaim.rightfake:override(v255);
                end;
                local v257 = v248.constants.body_yaw_options[v250.body_yaw] or 1;
                if v257 == 1 then
                    v248.ref.antiaim.inverter:override(v248.state.side == 0);
                    v248.ref.antiaim.body_yaw:override(false);
                elseif v257 == 2 then
                    rage.antiaim:inverter(v248.state.side == 0);
                    v248.ref.antiaim.body_yaw:override(true);
                elseif v257 == 4 then
                    v248.ref.antiaim.inverter:override(v248.state.side == 0);
                    v248.ref.antiaim.body_yaw:override(v248.state.body_yaw_false_ticks % v250.body_yaw_ticks ~= 1);
                else
                    rage.antiaim:inverter(v249.command_number % math.random(3, 7) == 0);
                    v248.ref.antiaim.body_yaw:override(true);
                end;
                if v250.antibruteforce_enable and math.abs(v248.state.ab.bruted_last_time - globals.curtime) > 0.25 then
                    for v258, v259 in next, v248.state.ab.should_swap do
                        if v259 and v248.state.ab.time[v258] - globals.curtime >= 0 then
                            if v248.helpers:contains(v250.antibruteforce_modifiers, "Modifier") then
                                v254 = v254 + v248.state.ab.jitteralgo[v258];
                            end;
                            if v248.helpers:contains(v250.antibruteforce_modifiers, "Fake limit") then
                                v255 = v248.state.ab.fakelimit[v258];
                                break;
                            else
                                break;
                            end;
                        end;
                    end;
                end;
                v248.ref.antiaim.body_yaw_options:override({});
                v248.ref.antiaim.yaw_offset:override(v254);
                v248.ref.antiaim.leftfake:override(v255);
                v248.ref.antiaim.rightfake:override(v255);
                v248:handle_fluctuate_fakelag();
                v248:handle_freestanding();
                v248:handle_manual_aa();
                local v260 = v251:get_player_weapon();
                local v261 = "";
                if v260 ~= nil then
                    v261 = v260:get_classname();
                end;
                if v248.helpers:contains(v250.defensive_activation_options, "Weapon switch") and v251.m_flNextAttack > globals.curtime then
                    v248.ref.rage.dtlag:override("always on");
                end;
                if v248.helpers:contains(v250.defensive_activation_options, "Weapon reload") and v260:get_weapon_reload() ~= -1 then
                    v248.ref.rage.dtlag:override("always on");
                end;
                if v248.helpers:contains(v250.defensive_activation_options, "Always") and (not v250.defensive_disable_option or not v248.ref.rage.quickpeek:get()) then
                    v248.ref.rage.dtlag:override("always on");
                end;
                return;
            end;
        end;
    end, 
    handle_side_switching = function(v262, _, v264)
        local v265 = 0;
        if globals.choked_commands ~= 0 then
            return;
        elseif v264.delay ~= true then
            v262.state.side = 1 - v262.state.side;
            return;
        elseif v264.delay_interaction_type == "Net_update" and globals.choked_commands ~= math.random(0, 1) then
            return;
        else
            v262.state.switch_delay = v262.state.switch_delay + 1;
            if v262.helpers:contains(v264.antibruteforce_modifiers, "Delay") and v264.antibruteforce_enable and math.abs(v262.state.ab.bruted_last_time - globals.curtime) > 0.25 then
                for v266, v267 in next, v262.state.ab.should_swap do
                    if v267 and v262.state.ab.time[v266] - globals.curtime >= 0 then
                        v265 = v262.state.ab.delay[v266];
                        break;
                    end;
                end;
                if v264.switch_delay <= 2 then
                    v265 = math.abs(v265);
                end;
            end;
            if v264.delay_method == "Random" then
                if v262.state.switch_delay >= math.random(v264.random_delay_value_1, v264.random_delay_value_2) + v265 then
                    v262.state.switch_delay = 0;
                    v262.state.side = 1 - v262.state.side;
                end;
            elseif v264.delay_method == "Custom" then
                if not v262.current_slider then
                    v262.current_slider = 1;
                end;
                local v268 = tonumber(v264["switch_delay_sliders" .. tostring(v262.current_slider)]) or 1;
                v268 = math.max(v268, 1);
                if v262.state.switch_delay >= v268 + v265 then
                    v262.state.switch_delay = 0;
                    v262.state.side = v262.state.side == 1 and 0 or 1;
                    v262.current_slider = v262.current_slider + 1;
                    if v262.current_slider > v264.delay_sliders then
                        v262.current_slider = 1;
                    end;
                end;
            elseif v262.state.switch_delay >= v264.switch_delay + v265 then
                v262.state.switch_delay = 0;
                v262.state.side = 1 - v262.state.side;
            end;
            return;
        end;
    end, 
    calculate_offsets = function(v269, v270)
        local v271 = 0;
        local v272 = 0;
        local v273 = v269.constants.yaw_options[v270.yaw_jitter] or 0;
        local l_yaw_jitter_add_0 = v270.yaw_jitter_add;
        if v270.yaw_jitter_mode == "Custom" then
            if globals.choked_commands == 0 then
                v269.state.modifier_switch_delay = v269.state.modifier_switch_delay + 1;
            end;
            if not v269.current_slider then
                v269.current_slider = 1;
            end;
            local v275 = tonumber(v270["yaw_jitter_slider" .. tostring(v269.current_slider)]) or 1;
            if math.max(v275, 1) <= v269.state.modifier_switch_delay then
                v269.current_slider = v269.current_slider + 1;
                if v269.current_slider > v270.yaw_sliders then
                    v269.current_slider = 1;
                end;
            end;
            if v269.current_slider == v270.yaw_sliders then
                l_yaw_jitter_add_0 = math.random(v270["yaw_jitter_slider" .. v269.current_slider], v270["yaw_jitter_slider" .. 1]);
            else
                l_yaw_jitter_add_0 = math.random(v270["yaw_jitter_slider" .. v269.current_slider], v270["yaw_jitter_slider" .. v269.current_slider + 1]);
            end;
        end;
        local v276 = utils.random_int(0, v270.randomization);
        v271 = v271 + (v269.state.side == 0 and v270.yaw_add + v276 or v270.yaw_add_r + v276);
        if v273 == 1 then
            v269.ref.antiaim.yaw_modifier:override("disabled");
            v269.ref.antiaim.yaw_modifieramount:override(0);
            local v277;
            if v269.state.side ~= 1 or not l_yaw_jitter_add_0 then
                v277 = 0;
            else
                v277 = l_yaw_jitter_add_0;
            end;
            v271 = v271 + v277;
        elseif v273 == 2 then
            v269.ref.antiaim.yaw_modifier:override("disabled");
            v269.ref.antiaim.yaw_modifieramount:override(0);
            v271 = v271 + (v269.state.side == 1 and l_yaw_jitter_add_0 / 2 or -l_yaw_jitter_add_0 / 2);
        elseif v273 == 3 then
            v269.ref.antiaim.yaw_modifier:override("disabled");
            v269.ref.antiaim.yaw_modifieramount:override(0);
            local v278 = math.random(0, l_yaw_jitter_add_0) - l_yaw_jitter_add_0 / 1.5;
            v271 = v271 + v278;
            v269.state.last_rand = v278;
        elseif v273 == 4 then
            v269.ref.antiaim.yaw_modifier:override("spin");
            v269.ref.antiaim.yaw_modifieramount:override(l_yaw_jitter_add_0);
        elseif v273 == 5 then
            local l_yaw_modifier_0 = v269.ref.antiaim.yaw_modifier;
            local l_l_yaw_modifier_0_0 = l_yaw_modifier_0;
            l_yaw_modifier_0 = l_yaw_modifier_0.override;
            local v281;
            if v269.state.counter % math.random(3, 4) == 0 then
                v281 = math.random(0, 6) == 0 and "5-way" or "random";
            else
                v281 = "3-way";
            end;
            l_yaw_modifier_0(l_l_yaw_modifier_0_0, v281);
            v269.ref.antiaim.yaw_modifieramount:override(utils.random_int(v270.yaw_jitter_own1, v270.yaw_jitter_own2));
        else
            v269.ref.antiaim.yaw_modifier:override("disabled");
            v269.ref.antiaim.yaw_modifieramount:override(0);
        end;
        v272 = v269.state.side == 0 and v270.fakelimit_l or v270.fakelimit_r;
        if v269.defensive.defensive > 0 then
            v269.state.defensive_state = true;
        end;
        if v269.state.defensive_state and v269.defensive.defensive < 1 and entity.get_threat(true) ~= nil then
            local v282 = globals.tickcount % 7 + 11;
            v269.state.defensive_after = globals.tickcount + v282;
        end;
        if v269.state.defensive_after >= globals.tickcount and v270.cleanrecords then
            local v283 = math.random(-9, 12);
            if v270.cleanrecords_random_flick then
                v283 = globals.tickcount % math.random(15, 16) == 1 and math.random(60, 72) or math.random(-9, 12);
            end;
            v271 = v271 + v283;
            local v284 = entity.get_local_player():get_player_weapon();
            if v270.cleanrecords_usefakelag and v284.m_flNextPrimaryAttack <= globals.curtime then
                v269.ref.rage.dt_fakelag:override(math.random(1, 2));
            end;
            v269.state.defensive_state = false;
        end;
        if globals.choked_commands == 0 then
            v269.state.counter = v269.state.counter + 1;
            v269.state.body_yaw_false_ticks = v269.state.body_yaw_false_ticks + 1;
        end;
        return v271, v272;
    end, 
    apply_basic_settings = function(v285)
        v285.ref.antiaim.enable:override(true);
        v285.ref.antiaim.pitch:override("down");
        v285.ref.antiaim.yaw_target:override("At Target");
        v285.ref.antiaim.yaw:override("Backward");
        v285.ref.antiaim.avoid_backstab:override(v285.helpers:contains(v285.ui.menu.aa.options:get(), "Avoid Backstab"));
    end, 
    handle_head_protection = function(v286, v287, v288, v289, v290)
        if not v287.yaw_headbehindchest or globals.choked_commands >= 3 then
            return v289, v290, false;
        else
            if not v286.state.yaw_hold_ticks then
                v286.state.yaw_hold_ticks = 0;
                v286.state.current_safe_yaw = 0;
                v286.state.activation_delay = 6 + globals.tickcount % 3;
            end;
            local v291 = entity.get_threat(true);
            local v292 = v291 ~= nil;
            local v293 = false;
            if v291 then
                local v294 = v291:get_player_weapon();
                if v294 then
                    v293 = (v294.m_flNextPrimaryAttack or 0) <= globals.curtime + 0.2;
                end;
            end;
            local v295 = (v288.m_flNextAttack or 0) <= globals.curtime;
            local v296 = false;
            if v286.state.activation_delay <= 0 and (v292 or v293) and v295 then
                v296 = true;
                if v286.state.yaw_hold_ticks > 0 then
                    v289 = v286.state.current_safe_yaw;
                    v286.state.yaw_hold_ticks = v286.state.yaw_hold_ticks - 1;
                else
                    local v297 = v288.m_vecVelocity:length2d();
                    local v298 = globals.tickcount % 100 + 1;
                    local v299 = v286.constants.random_buffer[v298] % 11 - 4;
                    v289 = v297 > 5 and v299 or 3 + globals.tickcount % 3;
                    v286.state.current_safe_yaw = v289;
                    v286.state.yaw_hold_ticks = 1 + globals.tickcount % 2;
                    v290 = math.max(v297, 60);
                    v286.ref.antiaim.inverter:override(true);
                    v286.ref.antiaim.body_yaw:override(globals.tickcount % 2 == 0);
                    v286.ref.antiaim.yaw_modifier:override("off");
                    v286.ref.antiaim.yaw_modifieramount:override(0);
                    v286.state.activation_delay = 6 + math.random(1, 9);
                end;
            else
                v286.state.activation_delay = v286.state.activation_delay - 1;
            end;
            return v289, v290, v296;
        end;
    end, 
    handle_special_modes = function(v300, _)
        local v302 = entity.get_local_player();
        if not v302 then
            return;
        else
            if v300.helpers:contains(v300.ui.menu.aa.options:get(), "Warmup AA") then
                local v303 = entity.get_game_rules();
                if v303 and v303.m_bWarmupPeriod then
                    v300.ref.antiaim.pitch:override("Disabled");
                    local _ = 0;
                    local v305 = 0;
                    if v300.ui.menu.aa.troll_aa_options:get() == "Half Spin" then
                        v305 = math.sin(globals.tickcount * (v300.ui.menu.aa.troll_aa_speed:get() / 10)) * 135;
                    else
                        v305 = globals.tickcount * 2 ^ v300.ui.menu.aa.troll_aa_speed:get() % 360;
                    end;
                    v300.ref.antiaim.yaw_offset:override(v305);
                    v300.ref.antiaim.leftfake:override(0);
                    v300.ref.antiaim.rightfake:override(0);
                    v300.ref.antiaim.body_yaw:override(false);
                    v300.ref.antiaim.inverter:override(false);
                    v300.ref.antiaim.hidden:override(false);
                    v300.ref.antiaim.yaw_modifier:override("Offset");
                    v300.ref.antiaim.yaw_modifieramount:override(0);
                    return true;
                end;
            end;
            if v300.state.round_ended and not entity.get_threat(true) and v300.helpers:contains(v300.ui.menu.aa.options:get(), "Round end AA") then
                v300.ref.antiaim.pitch:override("Disabled");
                local _ = 0;
                local v307 = 0;
                if v300.ui.menu.aa.troll_aa_options:get() == "Half Spin" then
                    v307 = math.sin(globals.tickcount * (v300.ui.menu.aa.troll_aa_speed:get() / 10)) * 135;
                else
                    v307 = globals.tickcount * 2 ^ v300.ui.menu.aa.troll_aa_speed:get() % 360;
                end;
                v300.ref.antiaim.yaw_offset:override(v307);
                v300.ref.antiaim.leftfake:override(0);
                v300.ref.antiaim.rightfake:override(0);
                v300.ref.antiaim.inverter:override(false);
                v300.ref.antiaim.hidden:override(false);
                v300.ref.antiaim.body_yaw:override(false);
                v300.ref.antiaim.yaw_modifier:override("Offset");
                v300.ref.antiaim.yaw_modifieramount:override(0);
                return true;
            else
                if v300.helpers:contains(v300.ui.menu.aa.options:get(), "Hide Head") then
                    local v308 = v300.helpers:get_state();
                    local v309 = v302:get_player_weapon();
                    local v310 = v309 and v309:get_classname() or "";
                    local v311 = entity.get_threat();
                    local v312 = v302:get_origin() or {};
                    local v313 = false;
                    local v314 = false;
                    if v311 then
                        local v315 = v311:get_origin();
                        v313 = v315.z - v312.z < -60;
                        v314 = v315.x - v312.x < -1500;
                    end;
                    local v316 = v300.ui.menu.aa.hidehead_options:get();
                    local _ = v300.helpers.contains;
                    local v318;
                    if v300.helpers:contains(v316, "Standing") then
                        v318 = string.find(v308, "stand");
                        if v318 then
                            goto label0;
                        end;
                    end;
                    if (not v300.helpers:contains(v316, "Crouch") or v308 ~= "duck") and (not v300.helpers:contains(v316, "Air Crouch Knife") or v308 ~= "duck jump" or v310 ~= "CKnife") and (not v300.helpers:contains(v316, "Taser In Air") or not string.find(v308, "jump") or v310 ~= "CWeaponTaser") then
                        if not v300.helpers:contains(v316, "Height Advantage") or not v313 then
                            v318 = v300.helpers:contains(v316, "Distance") and v314;
                        else
                            v318 = v313;
                        end;
                    else
                        v318 = true;
                    end;
                    ::label0::;
                    if v318 then
                        v300.ref.antiaim.yaw_offset:override(5);
                        v300.ref.antiaim.yaw_modifier:override("Offset");
                        v300.ref.antiaim.yaw_modifieramount:override(0);
                        v300.ref.antiaim.leftfake:override(0);
                        v300.ref.antiaim.rightfake:override(0);
                        v300.ref.antiaim.inverter:override(false);
                        v300.ref.antiaim.hidden:override(false);
                        return true;
                    end;
                end;
                return false;
            end;
        end;
    end, 
    handle_freestanding = function(v319)
        local v320 = v319.helpers:get_state();
        if v319.ui.menu.aa.freestanding:get() and not v319.helpers:contains(v319.ui.menu.aa.freestanding_disablers:get(), v320) then
            v319.ref.antiaim.freestanding:override(true);
            if v319.helpers:contains(v319.ui.menu.aa.yawmodifier:get(), "Force static") then
                v319.ref.antiaim.yaw_offset:override(5);
                v319.ref.antiaim.yaw_modifier:override("Offset");
                v319.ref.antiaim.yaw_modifieramount:override(0);
                v319.ref.antiaim.leftfake:override(0);
                v319.ref.antiaim.rightfake:override(0);
                v319.ref.antiaim.inverter:override(false);
                v319.ref.antiaim.hidden:override(false);
            end;
        else
            v319.ref.antiaim.freestanding:override(false);
        end;
    end, 
    handle_manual_aa = function(v321)
        local v322 = v321.ui.menu.aa.manual_aa:get();
        local v323 = v321.constants.manual_options[v322] or 0;
        if v323 == 1 then
            v321.ref.antiaim.yaw_offset:override(-90);
            v321.ref.antiaim.freestanding:override(false);
            v321.ref.antiaim.yaw_target:override("Local view");
        elseif v323 == 2 then
            v321.ref.antiaim.yaw_offset:override(90);
            v321.ref.antiaim.freestanding:override(false);
            v321.ref.antiaim.yaw_target:override("Local view");
        elseif v323 == 3 then
            v321.ref.antiaim.yaw_offset:override(180);
            v321.ref.antiaim.freestanding:override(false);
            v321.ref.antiaim.yaw_target:override("Local view");
        end;
    end, 
    handle_fluctuate_fakelag = function(v324)
        if v324.helpers:contains(v324.ui.menu.aa.options:get(), "Fluctuate Fakelag") and not v324.ref.rage.fd:get() then
            local v325 = 5 + globals.tickcount % 11;
            v324.ref.rage.fakelag:override(globals.tickcount % v325 == 0 and 1 or 14);
        else
            v324.ref.rage.fakelag:override();
        end;
    end
}):struct("defensive")({
    defensive = 0, 
    cmd = 0, 
    max_tickbase = 0, 
    on_createmove = function(v326, _)
        local l_m_nTickBase_0 = entity.get_local_player().m_nTickBase;
        if math.abs(l_m_nTickBase_0 - v326.max_tickbase) > 64 then
            v326.max_tickbase = 0;
        end;
        local v329 = 0;
        if v326.max_tickbase < l_m_nTickBase_0 then
            v326.max_tickbase = l_m_nTickBase_0;
        elseif l_m_nTickBase_0 < v326.max_tickbase then
            v329 = math.min(14, math.max(0, v326.max_tickbase - l_m_nTickBase_0 - 1));
        end;
        v326.defensive = v329;
    end
}):struct("mindmg")({
    windows = {
        mouse = {
            down = false, 
            down_duration = 0, 
            clicked = false, 
            pos = vector(), 
            pos_prev = vector(), 
            delta = vector(), 
            clicked_pos = vector()
        }, 
        damage_window = {
            dragging = false, 
            alpha = 0, 
            pos = vector(render.screen_size().x / 2 + 30, render.screen_size().y / 2 - 40), 
            size = vector(), 
            padding = vector(4, 4)
        }
    }, 
    update_mouse = function(v330)
        local l_frametime_0 = globals.frametime;
        local v332 = ui.get_mouse_position();
        local v333 = common.is_button_down(1);
        local l_mouse_0 = v330.windows.mouse;
        l_mouse_0.pos_prev = l_mouse_0.pos;
        l_mouse_0.pos = v332;
        l_mouse_0.delta = l_mouse_0.pos - l_mouse_0.pos_prev;
        l_mouse_0.down = v333;
        l_mouse_0.clicked = v333 and l_mouse_0.down_duration < 0;
        local v335;
        if v333 then
            if l_mouse_0.down_duration < 0 then
                v335 = 0;
                goto label1 --[[  true, true  ]];
            else
                v335 = l_mouse_0.down_duration + l_frametime_0;
                if v335 then
                    goto label1;
                end;
            end;
        end;
        v335 = -1;
        ::label1::;
        l_mouse_0.down_duration = v335;
        if l_mouse_0.clicked then
            l_mouse_0.clicked_pos = l_mouse_0.pos;
        end;
    end, 
    update_dragging = function(v336)
        local l_damage_window_0 = v336.windows.damage_window;
        local l_mouse_1 = v336.windows.mouse;
        v336:update_mouse();
        if ui.get_alpha() > 0 then
            local v339 = l_mouse_1.pos.x >= l_damage_window_0.pos.x and l_mouse_1.pos.x <= l_damage_window_0.pos.x + l_damage_window_0.size.x and l_mouse_1.pos.y >= l_damage_window_0.pos.y and l_mouse_1.pos.y <= l_damage_window_0.pos.y + l_damage_window_0.size.y;
            if l_mouse_1.clicked and v339 then
                l_damage_window_0.dragging = true;
                v336.drag_offset = l_mouse_1.pos - l_damage_window_0.pos;
            end;
            if l_mouse_1.down and l_damage_window_0.dragging then
                l_damage_window_0.pos = l_mouse_1.pos - v336.drag_offset;
                local v340 = render.screen_size();
                l_damage_window_0.pos.x = math.clamp(l_damage_window_0.pos.x, 0, v340.x - l_damage_window_0.size.x);
                l_damage_window_0.pos.y = math.clamp(l_damage_window_0.pos.y, 0, v340.y - l_damage_window_0.size.y);
            end;
            if not l_mouse_1.down then
                l_damage_window_0.dragging = false;
            end;
        end;
        if not l_damage_window_0.dragging then
            v336:save_damage_window_position();
        end;
    end, 
    render_damage_indicator = function(v341)
        local v342 = entity.get_local_player();
        if not v342 or not v342:is_alive() then
            return;
        elseif not v341.ui.menu.vis.dmgindicator:get() then
            return;
        else
            local l_font_0 = font;
            local v344 = l_font_0 == "Small" and 2 or l_font_0 == "Bold" and 4 or 1;
            local v345 = tostring(v341.ref.rage.dmg:get());
            local v346 = render.measure_text(v344, "s", v345) + v341.windows.damage_window.padding * 2 + vector(1, 0);
            v341.windows.damage_window.size = v346;
            v341:update_dragging();
            local v347;
            if ui.get_alpha() > 0 then
                v347 = v341.windows.damage_window.dragging and 0.5 or 1;
            else
                v347 = 0;
            end;
            v341.windows.damage_window.alpha = utility_lerp(v341.windows.damage_window.alpha, v347, 0.05);
            local l_pos_0 = v341.windows.damage_window.pos;
            local v349 = l_pos_0 + v346 * 0.5 + vector(1, 0);
            local v350 = color(200, 200, 200, 228 * v341.windows.damage_window.alpha);
            render.rect_outline(l_pos_0, l_pos_0 + v346, v350, 1, 4);
            local v351 = color(200, 200, 200, 228);
            render.text(v344, v349, v351, "cs", v345);
            return;
        end;
    end, 
    save_damage_window_position = function(v352)
        local l_damage_window_1 = v352.windows.damage_window;
        local v354 = {
            x = l_damage_window_1.pos.x, 
            y = l_damage_window_1.pos.y
        };
        local v355 = json.stringify(v354);
        files.write("gingersense_pos.txt", v355);
    end, 
    load_damage_window_position = function(v356)
        local v357 = files.read("gingersense_pos.txt");
        if v357 then
            local v358 = json.parse(v357);
            if v358 and v358.x and v358.y then
                v356.windows.damage_window.pos = vector(v358.x, v358.y);
            end;
        end;
    end, 
    setup = function(v359)
        v359:load_damage_window_position();
        local v360 = files.read("gingersense_pos.txt");
        if v360 == nil then
            v359.configs = {};
            return;
        else
            v359.configs = json.parse(v360);
            v359:save_damage_window_position();
            return;
        end;
    end
}):struct("visuals")({
    has_knife = false, 
    avg_fps = 0, 
    variance = 0, 
    frametimes_index = 0, 
    alpha_smoother = l_smoothy_0.new(0), 
    frametimes = {}, 
    font2 = render.load_font("museo500", 24, "ad"), 
    font = render.load_font("C:\\Windows\\Fonts\\calibrib.ttf", vector(25, 23.5, 0), "a"), 
    render_indicator = function(v361, v362, v363, v364, v365)
        local v366 = v362.x / v362.x + 10;
        local v367 = v362.y / 2 + v365 * 35;
        local v368 = render.measure_text(v361.font, "c", v364);
        local v369 = v368.x + 10;
        local v370 = v368.y + 10;
        local v371 = vector(v366, v367);
        local _ = vector(v366 + v369, v367 * 1.01);
        local _ = vector(v366 + v369 * 0.9, v367);
        local _ = vector(v366, v367 + v370);
        local v375 = vector(v366 + v369, v367 + v370);
        local _ = vector(v366 + v369 * 0.6, v367);
        render.gradient(v371, v375, color(0, 0, 0, 0), color(0, 0, 0, 0), color(0, 0, 0, 30), color(0, 0, 0, 30));
        local v377 = v366 + 6 + v368.x;
        local v378 = v367 + (v370 - v368.y) / 1.9;
        render.text(v361.font, vector(v377, v378), v363, "r", v364);
    end, 
    scope_overlay = function(v379)
        if v379.ui.menu.vis.scope_overlay:get() then
            local v380 = v379.ui.menu.vis.scope_overlay_color:get_color();
            local v381 = entity.get_local_player();
            if not v381 or not v381:is_alive() then
                return;
            elseif not v381.m_bIsScoped then
                return;
            else
                local v382 = v379.alpha_smoother(0.05, v381.m_bIsScoped);
                if v382 == 0 then
                    return;
                else
                    local v383 = v379.ui.menu.vis.scope_overlay_gap:get();
                    if v379.ui.menu.vis.scope_overlay_rotate:get() then
                        v383 = math.max(v383, 20);
                    end;
                    local v384 = v379.ui.menu.vis.scope_overlay_line:get() * 5;
                    local l_v383_0 = v383;
                    local v386 = render.screen_size();
                    local v387 = v386 * 0.5;
                    local v388 = math.floor(v384 * v386.y / 1080);
                    local v389 = math.floor(l_v383_0 * v386.y / 1080);
                    local v390 = v380:clone();
                    local v391 = v380:clone();
                    v390.a = v390.a * v382;
                    v391.a = 0;
                    if v379.ui.menu.vis.scope_overlay_rotate:get() then
                        render.push_rotation(45);
                    end;
                    render.gradient(vector(v387.x, v387.y - v389 + 1), vector(v387.x + 1, v387.y - (v388 - v389)), v390, v390, v391, v391);
                    render.gradient(vector(v387.x, v387.y + v389), vector(v387.x + 1, v387.y + (v388 - v389)), v390, v390, v391, v391);
                    render.gradient(vector(v387.x - v389 + 1, v387.y), vector(v387.x - (v388 - v389), v387.y + 1), v390, v391, v390, v391);
                    render.gradient(vector(v387.x + v389, v387.y), vector(v387.x + (v388 - v389), v387.y + 1), v390, v391, v390, v391);
                    if v379.ui.menu.vis.scope_overlay_rotate:get() then
                        render.pop_rotation();
                    end;
                end;
            end;
        end;
    end, 
    aspectratio_viewmodel = function(v392)
        cvar.sv_competitive_minspec:int(0);
        cvar.viewmodel_fov:float(v392.ui.menu.vis.viewmodel_fov:get() * 0.1);
        cvar.viewmodel_offset_x:float(v392.ui.menu.vis.viewmodel_x:get() * 0.1);
        cvar.viewmodel_offset_y:float(v392.ui.menu.vis.viewmodel_y:get() * 0.1);
        cvar.viewmodel_offset_z:float(v392.ui.menu.vis.viewmodel_z:get() * 0.1);
        cvar.r_aspectratio:float(v392.ui.menu.vis.aspectratio:get() * 0.01);
        if v392.ui.menu.misc.disable_cvars:get() then
            cvar.cl_disable_ragdolls:int(1, true);
            cvar.dsp_slow_cpu:int(1, true);
            cvar.mat_disable_bloom:int(1, true);
            cvar.r_drawparticles:int(1, true);
            cvar.func_break_max_pieces:int(0, true);
            cvar.mat_queue_mode:int(2, true);
            cvar.muzzleflash_light:int(0, true);
            cvar.mat_hdr_enabled:int(0, true);
            cvar.r_eyemove:int(0, true);
            cvar.r_eyegloss:int(0, true);
            cvar.fps_max:int(0, true);
            cvar.r_shadows:float(0, true);
            cvar.cl_foot_contact_shadows:int(0);
        end;
        if v392.ui.menu.vis.viewmodel_knifehand:get() then
            local v393 = entity.get_local_player();
            if v393 == nil then
                return;
            else
                local v394 = v393:get_player_weapon();
                if v394 == nil then
                    return;
                else
                    local v395 = v394:get_weapon_info();
                    if v395 == nil then
                        return;
                    elseif v395.weapon_type == 0 then
                        if not v392.has_knife then
                            v392.original_hand_value = cvar.cl_righthand:int();
                            cvar.cl_righthand:int(1 - v392.original_hand_value);
                            v392.has_knife = true;
                        end;
                    elseif v392.has_knife then
                        if v392.original_hand_value ~= nil then
                            cvar.cl_righthand:int(v392.original_hand_value);
                        end;
                        v392.has_knife = false;
                        v392.original_hand_value = nil;
                    end;
                end;
            end;
        end;
    end, 
    net_graph = function(v396)
        local v397 = render.screen_size();
        if v396.ui.menu.vis.manual_arrows:get() then
            local v398 = v396.ui.menu.vis.manual_arrows:get_color();
            if v396.ui.menu.aa.manual_aa:get() == "Left" then
                render.text(v396.font2, vector(v397.x / 2 - 40, v397.y / 2 - 13), color(v398.r, v398.g, v398.b, v398.a * math.abs(math.cos(globals.curtime * 2))), "r", "\226\174\156");
            elseif v396.ui.menu.aa.manual_aa:get() == "Right" then
                render.text(v396.font2, vector(v397.x / 2 + 40, v397.y / 2 - 13), color(v398.r, v398.g, v398.b, v398.a * math.abs(math.cos(globals.curtime * 2))), "l", "\226\174\158");
            end;
        end;
        if globals.is_in_game and v396.ui.menu.vis.netgraph_enable:get() then
            local v399 = 64;
            local v400 = 0.5;
            local l_deviation_0 = utils.net_channel():get_server_info().deviation;
            local l_frame_time_0 = utils.net_channel():get_server_info().frame_time;
            local l_absoluteframetime_0 = globals.absoluteframetime;
            if l_absoluteframetime_0 > 0 then
                v396.frametimes[v396.frametimes_index] = l_absoluteframetime_0;
                v396.frametimes_index = v396.frametimes_index + 1;
                if v399 <= v396.frametimes_index then
                    v396.frametimes_index = 0;
                end;
            end;
            local v404 = 0;
            local v405 = 0;
            local l_frametimes_index_0 = v396.frametimes_index;
            local v407 = nil;
            variance = 0;
            for _ = 0, v399 - 1 do
                l_frametimes_index_0 = l_frametimes_index_0 - 1;
                if l_frametimes_index_0 < 0 then
                    l_frametimes_index_0 = v399 - 1;
                end;
                l_absoluteframetime_0 = v396.frametimes[l_frametimes_index_0] or 0;
                if l_absoluteframetime_0 ~= 0 then
                    v404 = v404 + l_absoluteframetime_0;
                    v405 = v405 + 1;
                    if v407 then
                        variance = math.max(variance, math.abs(l_absoluteframetime_0 - v407));
                    end;
                    v407 = l_absoluteframetime_0;
                    if v400 <= v404 then
                        break;
                    end;
                else
                    break;
                end;
            end;
            if v405 == 0 then
                return 0;
            else
                v404 = v404 / v405;
                local v409 = math.floor(1 / v404) + 0.5;
                if math.abs(v409 - v396.avg_fps) > 5 then
                    v396.avg_fps = v409;
                else
                    v409 = v396.avg_fps;
                end;
                local l_v409_0 = v409;
                local v411 = math.floor(math.min(1000, utils.net_channel().latency[1] * 1000));
                local v412 = v396.ui.menu.vis.netgraph_enable:get_color();
                render.text(1, vector(v397.x / 2 * 1.4, v397.y / 2 * 1.83), v412, "l", string.format("fps:  %d", l_v409_0));
                render.text(1, vector(v397.x / 2 * 1.4 + 60, v397.y / 2 * 1.83), v412, "l", string.format("var:  %.1f", l_deviation_0));
                render.text(1, vector(v397.x / 2 * 1.4 + 120, v397.y / 2 * 1.83), v412, "l", string.format("ping:  %d ms", v411));
                render.text(1, vector(v397.x / 2 * 1.4, v397.y / 2 * 1.83 + 15), v412, "l", "loss:  " .. utils.net_channel().loss[1] .. "%");
                render.text(1, vector(v397.x / 2 * 1.4 + 60, v397.y / 2 * 1.83 + 15), v412, "l", "choke:  " .. math.floor(utils.net_channel().choke[1]) .. "%");
                render.text(1, vector(v397.x / 2 * 1.369, v397.y / 2 * 1.83) + 30, v412, "l", string.format("sv: %.2f +- %.2fms    var: %.3f ms", l_frame_time_0, l_deviation_0, l_deviation_0));
            end;
        end;
    end
}):struct("watermark")({
    windows = {
        watermark = {
            dragging = false, 
            alpha = 0, 
            snap_threshold = 30, 
            pos = vector(render.screen_size().x / 2, render.screen_size().y * 0.98), 
            size = vector(), 
            padding = vector(4, 4)
        }, 
        mouse = {
            down = false, 
            down_duration = 0, 
            clicked = false, 
            pos = vector(), 
            pos_prev = vector(), 
            delta = vector(), 
            clicked_pos = vector()
        }
    }, 
    update_mouse = function(v413)
        local l_frametime_1 = globals.frametime;
        local v415 = ui.get_mouse_position();
        local v416 = common.is_button_down(1);
        local l_mouse_2 = v413.windows.mouse;
        l_mouse_2.pos_prev = l_mouse_2.pos;
        l_mouse_2.pos = v415;
        l_mouse_2.delta = l_mouse_2.pos - l_mouse_2.pos_prev;
        l_mouse_2.down = v416;
        l_mouse_2.clicked = v416 and l_mouse_2.down_duration < 0;
        local v418;
        if v416 then
            if l_mouse_2.down_duration < 0 then
                v418 = 0;
                goto label2 --[[  true, true  ]];
            else
                v418 = l_mouse_2.down_duration + l_frametime_1;
                if v418 then
                    goto label2;
                end;
            end;
        end;
        v418 = -1;
        ::label2::;
        l_mouse_2.down_duration = v418;
        if l_mouse_2.clicked then
            l_mouse_2.clicked_pos = l_mouse_2.pos;
        end;
    end, 
    update_watermark_dragging = function(v419)
        local l_watermark_0 = v419.windows.watermark;
        local l_mouse_3 = v419.windows.mouse;
        local v422 = render.screen_size();
        v419:update_mouse();
        if ui.get_alpha() > 0 then
            local v423 = v419.ui.menu.global.watermark_text:get();
            l_watermark_0.size = render.measure_text(v419.ui.menu.global.watermark_font:get(), nil, v423) + l_watermark_0.padding * 2;
            local v424 = l_mouse_3.pos.x >= l_watermark_0.pos.x - l_watermark_0.size.x / 2 and l_mouse_3.pos.x <= l_watermark_0.pos.x + l_watermark_0.size.x / 2 and l_mouse_3.pos.y >= l_watermark_0.pos.y - l_watermark_0.size.y / 2 and l_mouse_3.pos.y <= l_watermark_0.pos.y + l_watermark_0.size.y / 2;
            if l_mouse_3.clicked and v424 then
                l_watermark_0.dragging = true;
                v419.drag_offset = l_mouse_3.pos - l_watermark_0.pos;
            end;
            if l_mouse_3.down and l_watermark_0.dragging then
                l_watermark_0.pos = l_mouse_3.pos - v419.drag_offset;
                local v425 = {
                    center = vector(v422.x / 2, v422.y * 0.98), 
                    left = vector(10 + l_watermark_0.size.x / 2, v422.y / 2), 
                    right = vector(v422.x - 10 - l_watermark_0.size.x / 2, v422.y / 2)
                };
                local v426 = nil;
                local l_snap_threshold_0 = l_watermark_0.snap_threshold;
                for _, v429 in pairs(v425) do
                    local v430 = (l_watermark_0.pos - v429):length();
                    if v430 < l_snap_threshold_0 then
                        l_snap_threshold_0 = v430;
                        v426 = v429;
                    end;
                end;
                if v426 then
                    l_watermark_0.pos = v426;
                else
                    l_watermark_0.pos.x = math.clamp(l_watermark_0.pos.x, l_watermark_0.size.x / 2, v422.x - l_watermark_0.size.x / 2);
                    l_watermark_0.pos.y = math.clamp(l_watermark_0.pos.y, l_watermark_0.size.y / 2, v422.y - l_watermark_0.size.y / 2);
                end;
            end;
            if not l_mouse_3.down then
                l_watermark_0.dragging = false;
                v419:save_watermark_position();
            end;
        end;
    end, 
    save_watermark_position = function(v431)
        local l_watermark_1 = v431.windows.watermark;
        local v433 = render.screen_size();
        local v434 = {
            center = vector(v433.x / 2, v433.y * 0.98), 
            left = vector(10 + l_watermark_1.size.x / 2, v433.y / 2), 
            right = vector(v433.x - 10 - l_watermark_1.size.x / 2, v433.y / 2)
        };
        local v435 = nil;
        local l_huge_0 = math.huge;
        for v437, v438 in pairs(v434) do
            local v439 = (l_watermark_1.pos - v438):length();
            if v439 < l_huge_0 then
                l_huge_0 = v439;
                v435 = v437;
            end;
        end;
        if l_huge_0 < l_watermark_1.snap_threshold then
            local v440 = {
                preset = v435
            };
            local v441 = json.stringify(v440);
            files.write("watermark_pos.txt", v441);
        else
            local v442 = {
                x = l_watermark_1.pos.x, 
                y = l_watermark_1.pos.y
            };
            local v443 = json.stringify(v442);
            files.write("watermark_pos.txt", v443);
        end;
    end, 
    get_watermark_size = function(v444)
        local v445 = v444.ui.menu.global.watermark_text:get();
        local v446 = v444.ui.menu.global.watermark_font:get();
        return render.measure_text(v446, nil, v445) + v444.windows.watermark.padding * 2;
    end, 
    load_watermark_position = function(v447)
        local v448 = files.read("watermark_pos.txt");
        if v448 then
            local v449 = json.parse(v448);
            if v449 then
                local v450 = render.screen_size();
                local l_watermark_2 = v447.windows.watermark;
                l_watermark_2.size = v447:get_watermark_size();
                if v449.preset then
                    if v449.preset == "center" then
                        l_watermark_2.pos = vector(v450.x / 2, v450.y * 0.98);
                    elseif v449.preset == "left" then
                        l_watermark_2.pos = vector(10 + l_watermark_2.size.x / 2, v450.y / 2);
                    elseif v449.preset == "right" then
                        l_watermark_2.pos = vector(v450.x - 10 - l_watermark_2.size.x / 2, v450.y / 2);
                    end;
                elseif v449.x and v449.y then
                    l_watermark_2.pos = vector(v449.x, v449.y);
                end;
            end;
        end;
    end, 
    render_watermark = function(v452)
        if not v452.ui.menu.global.watermark:get() then
            return;
        else
            v452:update_watermark_dragging();
            local l_watermark_3 = v452.windows.watermark;
            local v454 = render.screen_size();
            local v455;
            if ui.get_alpha() > 0 then
                v455 = l_watermark_3.dragging and 0.5 or 1;
            else
                v455 = 1;
            end;
            l_watermark_3.alpha = utility_lerp(l_watermark_3.alpha, v455, 0.05);
            local v456 = v452.ui.menu.global.watermark_text:get();
            l_watermark_3.size = render.measure_text(v452.ui.menu.global.watermark_font:get(), nil, v456) + l_watermark_3.padding * 2;
            local v457 = "c";
            local v458 = {
                center = vector(v454.x / 2, v454.y * 0.98), 
                left = vector(10 + l_watermark_3.size.x / 2, v454.y / 2), 
                right = vector(v454.x - 10 - l_watermark_3.size.x / 2, v454.y / 2)
            };
            local v459 = nil;
            local l_snap_threshold_1 = l_watermark_3.snap_threshold;
            for v461, v462 in pairs(v458) do
                local v463 = (l_watermark_3.pos - v462):length();
                if v463 < l_snap_threshold_1 then
                    l_snap_threshold_1 = v463;
                    v459 = v461;
                end;
            end;
            local v464 = v452.ui.menu.global.watermark_color:get_color();
            local l_r_1 = v464.r;
            local l_g_1 = v464.g;
            local l_b_1 = v464.b;
            local l_a_1 = v464.a;
            if v452.ui.menu.global.watermark_style:get() == "Custom" then
                if v452.ui.menu.global.watermark_gradient:get() == 2 then
                    render.text(v452.ui.menu.global.watermark_font:get(), l_watermark_3.pos, color(255, 255, 255, 255 * l_watermark_3.alpha), v457, v452.helpers:gradienttext(globals.curtime, v456, l_r_1, l_g_1, l_b_1, l_a_1, 255, 255, 255, 255, v452.ui.menu.global.watermark_speed:get()));
                else
                    render.text(v452.ui.menu.global.watermark_font:get(), l_watermark_3.pos, color(l_r_1, l_g_1, l_b_1, l_a_1 * l_watermark_3.alpha), v457, v456);
                end;
            elseif v452.ui.menu.global.watermark_style:get() == "Gingersense" then
                render.text(1, l_watermark_3.pos, color(222, 107, 62, 205 * l_watermark_3.alpha), v457, "G I N G E R " .. v452.helpers:gradienttext(globals.curtime, "S E N S E", l_r_1, l_g_1, l_b_1, l_a_1, 112, 112, 112, 205, 1) .. " \ac44545ff[LIVE]");
            else
                render.text(3, l_watermark_3.pos, color(l_r_1, l_g_1, l_b_1, l_a_1 * l_watermark_3.alpha), v457, "GINGER" .. v452.helpers:gradienttext(globals.curtime, "SENSE", 205, 205, 205, 205, 112, 112, 112, 205, 1) .. " \ac44545ff[LIVE]");
            end;
            if l_watermark_3.dragging or ui.get_alpha() > 0 then
                render.rect_outline(l_watermark_3.pos - vector(l_watermark_3.size.x / 2, l_watermark_3.size.y / 2), l_watermark_3.pos + vector(l_watermark_3.size.x / 2, l_watermark_3.size.y / 2), color(200, 200, 200, 100 * l_watermark_3.alpha), 1, 4);
                if l_watermark_3.dragging then
                    for _, v470 in pairs(v458) do
                        local v471 = (l_watermark_3.pos - v470):length() < l_watermark_3.snap_threshold and color(100, 255, 100, 150) or color(200, 200, 200, 50);
                        render.rect_outline(v470 - vector(l_watermark_3.size.x / 2, l_watermark_3.size.y / 2), v470 + vector(l_watermark_3.size.x / 2, l_watermark_3.size.y / 2), v471, 1, 4);
                    end;
                end;
            end;
            return;
        end;
    end, 
    setup = function(v472)
        v472.windows.watermark.size = v472:get_watermark_size();
        v472:load_watermark_position();
    end
}):struct("hitmarker")({
    duration = 0, 
    draw = function(v473)
        if not globals.is_in_game or v473.duration <= 0 or v473.ui.menu.vis.hit_marker:get() == false then
            return;
        else
            local v474 = 1;
            if v473.duration < 0.25 then
                v474 = v473.duration * 4;
            end;
            local v475 = v473.ui.menu.vis.hit_marker:get_color();
            local v476 = render.screen_size() * 0.5;
            local v477 = 10;
            local v478 = 5;
            render.line(vector(v476.x - v477, v476.y - v477), vector(v476.x - v478, v476.y - v478), color(v475.r, v475.g, v475.b, v475.a * v474));
            render.line(vector(v476.x + v477, v476.y - v477), vector(v476.x + v478, v476.y - v478), color(v475.r, v475.g, v475.b, v475.a * v474));
            render.line(vector(v476.x + v477, v476.y + v477), vector(v476.x + v478, v476.y + v478), color(v475.r, v475.g, v475.b, v475.a * v474));
            render.line(vector(v476.x - v477, v476.y + v477), vector(v476.x - v478, v476.y + v478), color(v475.r, v475.g, v475.b, v475.a * v474));
            v473.duration = math.max(v473.duration - globals.frametime, 0);
            return;
        end;
    end, 
    process_hurt_event = function(v479, v480)
        local v481 = entity.get_local_player();
        local v482 = entity.get(v480.userid, true);
        local v483 = entity.get(v480.attacker, true);
        if v482 == v481 or v483 ~= v481 then
            return;
        else
            v479.duration = 0.5;
            return;
        end;
    end
}):struct("misc")({
    ladder_status = false, 
    current_tick = 0, 
    freezetime_fakeduck = function(v484, v485)
        local l_m_bFreezePeriod_0 = entity.get_game_rules().m_bFreezePeriod;
        if entity.get_local_player() == nil then
            return;
        else
            if l_m_bFreezePeriod_0 and v484.ref.rage.fd:get() and v484.ui.menu.misc.freezetime_fakeduck:get() then
                if v484.ref.rage.dt:get() then
                    v484.ref.rage.dt:override(false);
                else
                    v484.ref.rage.dt:override();
                end;
                if v484.ref.rage.hs:get() then
                    v484.ref.rage.hs:override(false);
                else
                    v484.ref.rage.hs:override();
                end;
                if globals.choked_commands >= 7 then
                    v485.send_packet = false;
                    v485.in_duck = true;
                else
                    v485.send_packet = false;
                    v485.in_duck = false;
                end;
            else
                v484.ref.rage.hs:override();
                v484.ref.rage.dt:override();
            end;
            return;
        end;
    end, 
    trace_fall = function(_, v488, v489)
        local v490 = math.pi * 2;
        local v491 = v490 / 8;
        if entity.get_local_player() ~= nil then
            local v492 = entity.get_local_player():get_origin();
            for v493 = 0, v490, v491 do
                local v494 = math.sin(v493);
                local v495 = math.cos(v493);
                local v496 = v492.x + v495 * 10;
                local v497 = v492.y + v494 * 10;
                local v498 = vector(v496, v497, v492.z);
                local v499 = v498:clone();
                v499.z = v499.z - v489;
                if utils.trace_line(v498, v499, v488).fraction ~= 1 then
                    return true;
                end;
            end;
        end;
        return false;
    end, 
    no_fall_damage = function(v500, v501)
        local v502 = entity.get_local_player();
        if v500.ui.menu.misc.no_fall:get() then
            if v502 == nil then
                return;
            elseif v502.m_vecVelocity.z >= -500 then
                state = false;
                return;
            else
                if v500:trace_fall(v502, 15) then
                    state = false;
                elseif v500:trace_fall(v502, 75) then
                    state = true;
                end;
                v501.in_duck = state;
            end;
        end;
    end, 
    unlock_fakeduck_speed = function(v503, v504)
        if not v503.ui.menu.misc.unlock_fakeduck_speed:get() then
            return;
        elseif v503.ref.rage.fd:get() == false then
            return;
        else
            local v505 = entity.get_local_player();
            if v505 == nil then
                return;
            else
                local v506 = vector(v504.forwardmove, v504.sidemove);
                v506:normalize();
                if math.abs(v505.m_vecVelocity.y) > 10 then
                    local v507 = 150;
                    v504.forwardmove = v506.x * v507;
                    v504.sidemove = v506.y * v507;
                end;
                return;
            end;
        end;
    end, 
    animations = function(v508)
        -- upvalues: l_lambotruck_0 (ref)
        local v509 = entity.get_local_player();
        if v509 == nil then
            return;
        else
            v509.m_flPoseParameter[6] = v508.ui.menu.vis.animations_fall_amount:get() / 100;
            v509.m_flPoseParameter[0] = v508.ui.menu.vis.animations_slide_amount:get() / 40;
            if v508.ui.menu.vis.jitter_legs:get() then
                v509.m_flPoseParameter[0] = globals.tickcount % math.random(4, 16) >= 2 and v508.ui.menu.vis.jitter_legs_from:get() or v508.ui.menu.vis.jitter_legs_to:get() * 3 / (globals.tickcount % 8 >= 1 and 400 or 100);
                v508.ref.antiaim.legs:override(math.random(0, 7) == 0 and "walking" or "sliding");
            else
                v508.ref.antiaim.legs:override();
            end;
            l_lambotruck_0.animation.overlay(v509[0], 12).m_flWeight = v508.ui.menu.vis.animations_lean_amount:get() / 100;
            return;
        end;
    end, 
    fake_latency = function(v510, _)
        local v512 = entity.get_local_player();
        local l_sv_maxunlag_0 = cvar.sv_maxunlag;
        local l_ping_0 = v510.ref.rage.ping;
        if v510.ui.menu.misc.extended_ping_amount:get() > 0 then
            if v512 == nil then
                return;
            else
                l_ping_0:override((v510.ui.menu.misc.extended_ping_amount:get()));
                l_sv_maxunlag_0:float(0.4, true);
            end;
        else
            l_ping_0:override(nil);
            l_sv_maxunlag_0:float(tonumber(l_sv_maxunlag_0:string()), true);
        end;
    end, 
    fast_ladder = function(v515, v516)
        local v517 = entity.get_local_player();
        if (v517.m_MoveType == 9 and common.is_button_down(87) or v515.misc.ladder_status) and v515.ui.menu.misc.fast_ladder:get() then
            v516.view_angles.y = math.floor(v516.view_angles.y + 0.5);
            v516.roll = 0;
            if v516.view_angles.x < 45 then
                v516.view_angles.x = 89;
                v516.in_moveright = 1;
                v516.in_moveleft = 0;
                v516.in_forward = 0;
                v516.in_back = 1;
                if v516.sidemove == 0 then
                    v516.view_angles.y = v516.view_angles.y + 90;
                elseif v516.sidemove < 0 then
                    v516.view_angles.y = v516.view_angles.y + 150;
                elseif v516.sidemove > 0 then
                    v516.view_angles.y = v516.view_angles.y + 30;
                end;
            end;
        elseif (v517.m_MoveType == 9 and common.is_button_down(83) or v515.misc.ladder_status) and v515.ui.menu.misc.fast_ladder:get() then
            v516.view_angles.y = math.floor(v516.view_angles.y + 0.5);
            v516.roll = 0;
            if v516.view_angles.x < 45 then
                v516.view_angles.x = 89;
                v516.in_moveright = 0;
                v516.in_moveleft = 1;
                v516.in_forward = 1;
                v516.in_back = 0;
                if v516.sidemove == 0 then
                    v516.view_angles.y = v516.view_angles.y + 90;
                elseif v516.sidemove < 0 then
                    v516.view_angles.y = v516.view_angles.y + 150;
                elseif v516.sidemove > 0 then
                    v516.view_angles.y = v516.view_angles.y + 30;
                end;
            end;
        end;
    end
}):struct("killsay")({
    words = {
        [1] = "hhhhhh k1d u lost? by donpuchat", 
        [2] = "umed? by CL", 
        [3] = "stay shit skid, by nex", 
        [4] = "l2p bot, by saddam", 
        [5] = "stay mad b0t, by valar $", 
        [6] = "nice iq kid? by kacperek", 
        [7] = "50 wr kid owned by nublain $_$", 
        [8] = "retard owned by pufarino boss", 
        [9] = "hhhhh, by stefanBOMBA", 
        [10] = "hhhhh clueless, by w1shenz", 
        [11] = "nice try d0g, owned by protton $$$", 
        [12] = "free win for me, by ruod $$", 
        [13] = "I have got only lucky twice or something but you was so fucking fat and lucky", 
        [14] = "What is blud yapping about", 
        [15] = "shut up random", 
        [16] = "U are my weak parvo puppy do not speak up", 
        [17] = "dont speka", 
        [18] = "YOU ARE AN BOT DONT FORGET", 
        [19] = "ben1m you have an ego for absolutely nothing its so funny", 
        [20] = "u all guys are so bed pls no talk", 
        [21] = "you talk like youre the best player its hilarious", 
        [22] = "What kind of ego do you have to try to even speak to thy Swedish goddess kind sir", 
        [23] = "wypierdalaj", 
        [24] = "vanino x xalegioner", 
        [25] = "im 80 and i cant do nothink on boiler", 
        [26] = "@what. that\226\128\153s ur girls fucking nolifer", 
        [27] = "Idc I\226\128\153m Russian in god and I\226\128\153m king \240\159\145\145 and I\226\128\153m imperator and alah bless me@", 
        [28] = "We all know that youre a faggot with a virgin mustache like a cockroach", 
        [29] = "10 cent and I say you", 
        [30] = "Why say my name? Little fanboy with dick in ass", 
        [31] = "u think i record against 20 wr bots?", 
        [32] = "boring talk w loser", 
        [33] = "ur mother pornostar", 
        [34] = "only slime betwen legs my gf", 
        [35] = "stop talking vicos undercover", 
        [36] = "and we still remember about ur dick size", 
        [37] = "you forgot how kacperek made u on hvh", 
        [38] = "I win you 192838373 time on bank 1v1 2v2 and u win once when I troll or play W lay", 
        [39] = "Even vanino better than you", 
        [40] = "But this polish faggot don\226\128\153t know how play ice"
    }, 
    death_words = {
        [1] = "hhhhh free?", 
        [2] = "50\226\130\172 PC?", 
        [3] = "my grandma plays better", 
        [4] = "im afk bot", 
        [5] = "clueless player", 
        [6] = "random luck, congrats", 
        [7] = "im playing with monitor off", 
        [8] = "even vanino has better aim", 
        [9] = "0 iq play", 
        [10] = "u paid for that kill?", 
        [11] = "im trolling, u still bad", 
        [12] = "enjoy win vs bot", 
        [13] = "im lagging, noob", 
        [14] = "ur aim is like my 5yo cousin", 
        [15] = "i let u win, np", 
        [16] = "im playing with feet", 
        [17] = "ur so bad it\226\128\153s funny", 
        [18] = "enjoy silver rank", 
        [19] = "i was texting, u still almost lost", 
        [20] = "even my dog plays better", 
        [21] = "im not even trying", 
        [22] = "ur crosshair placement is tragic", 
        [23] = "free kill for bot", 
        [24] = "u got lucky, relax", 
        [25] = "enjoy ur 1 win of the day", 
        [26] = "i was alt-tabbed, chill", 
        [27] = "ur movement is like a drunk zombie", 
        [28] = "my cat stepped on keyboard, u still almost lost"
    }, 
    trashtalk = function(v518, v519)
        local v520 = entity.get_local_player();
        if v518.helpers:contains(v518.ui.menu.misc.trashtalk_states:get(), "Kill") then
            if v519.userid == v519.attacker then
                return;
            elseif v520 == entity.get(v519.attacker, true) then
                utils.execute_after(math.random(0, 0), function()
                    -- upvalues: v518 (ref)
                    utils.console_exec("say \"" .. v518.words[math.random(1, #v518.words)] .. "\"");
                end);
            end;
        end;
    end, 
    death_say = function(v521, v522)
        local v523 = entity.get_local_player();
        if v521.helpers:contains(v521.ui.menu.misc.trashtalk_states:get(), "Death") and entity.get(v522.userid, true) == v523 then
            utils.execute_after(math.random(0, 0), function()
                -- upvalues: v521 (ref)
                utils.console_exec("say \"" .. v521.words[math.random(1, #v521.death_words)] .. "\"");
            end);
        end;
    end
}):struct("hitlogs")({
    hitgroup_str = {
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
    }, 
    main = function(v524, v525)
        local _ = entity.get_local_player();
        local v527 = entity.get(v525.target);
        local l_damage_0 = v525.damage;
        local l_wanted_damage_0 = v525.wanted_damage;
        local v530 = v524.hitgroup_str[v525.wanted_hitgroup];
        local l_hitchance_0 = v525.hitchance;
        local l_state_0 = v525.state;
        local l_backtrack_0 = v525.backtrack;
        if not v527 then
            return;
        else
            local l_m_iHealth_0 = v527.m_iHealth;
            local v535 = v524.hitgroup_str[v525.hitgroup];
            local v536 = v524.ui.menu.misc.hitlog_color:get_color():to_hex();
            local v537 = "d65151ff";
            if l_state_0 == nil then
                local v538 = string.format("\a9994ffff" .. ui.get_icon("crosshairs") .. "\affffffff | Hit \a9994ffff%s\affffffff in the \a9994ffff%s\affffffff for \a9994ffff%d\affffffff(%.f) damage (hp: \a9994ffff%d\affffffff) (bt: \a9994ffff%s\affffffff)", v527:get_name(), v535, l_damage_0, l_wanted_damage_0, l_m_iHealth_0, l_backtrack_0);
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "On screen") then
                    print_dev(("\affffffff[\a" .. v536 .. "gingersense\affffffff] Hit \a" .. v536 .. "%s\affffffff's \a" .. v536 .. "%s\affffffff for \a" .. v536 .. "%d\affffffff(%.f) damage (hp: %d) (bt: \a" .. v536 .. "%s\affffffff)"):format(v527:get_name(), v535, l_damage_0, l_wanted_damage_0, l_m_iHealth_0, l_backtrack_0));
                end;
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "Console") then
                    print_raw(("\affffffff[\a" .. v536 .. "gingersense\affffffff] Hit \a" .. v536 .. "%s\affffffff's \a" .. v536 .. "%s\affffffff for \a" .. v536 .. "%d\affffffff(%.f) damage (hp: %d) (bt: \a" .. v536 .. "%s\affffffff)"):format(v527:get_name(), v535, l_damage_0, l_wanted_damage_0, l_m_iHealth_0, l_backtrack_0));
                end;
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "Center screen") then
                    v524.helpers:add_notification(v538);
                end;
            else
                local v539 = string.format("\aff9494ff" .. ui.get_icon("circle-xmark") .. "\affffffff | Missed \aff9494ff%s\affffffff in the \aff9494ff%s\affffffff due to \aff9494ff%s\affffffff (hc: \aff9494ff%.f\affffffff) (damage: \aff9494ff%.f\affffffff) (bt: \aff9494ff%.f\affffffff)", v527:get_name(), v530, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0);
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "On screen") then
                    print_dev(("\affffffff[\a" .. v537 .. "gingersense\affffffff] Missed \a" .. v537 .. "%s\affffffff's \a" .. v537 .. "%s\affffffff due to \a" .. v537 .. "%s\affffffff (hc: \a" .. v537 .. "%.f\affffffff) (damage: \a" .. v537 .. "%.f\affffffff) (bt: \a" .. v537 .. "%.f\affffffff)"):format(v527:get_name(), v530, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0));
                end;
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "Console") then
                    print_raw(("\affffffff[\a" .. v537 .. "gingersense\affffffff] Missed \a" .. v537 .. "%s\affffffff's \a" .. v537 .. "%s\affffffff due to \a" .. v537 .. "%s\affffffff (hc: \a" .. v537 .. "%.f\affffffff) (damage: \a" .. v537 .. "%.f\affffffff) (bt: \a" .. v537 .. "%.f\affffffff)"):format(v527:get_name(), v530, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0));
                end;
                if v524.helpers:contains(v524.ui.menu.misc.hitlogs:get(), "Center screen") then
                    v524.helpers:add_notification(v539);
                end;
            end;
            return;
        end;
    end, 
    on_item_purchase = function(v540, v541)
        local v542 = entity.get(v541.userid, true);
        if not v542:is_enemy() then
            return;
        else
            local v543 = v542:get_name();
            local l_weapon_0 = v541.weapon;
            local v545 = v540.ui.menu.misc.hitlog_color:get_color():to_hex();
            if l_weapon_0 == "weapon_unknown" then
                l_weapon_0 = "weapon_revolver";
            end;
            if v540.helpers:contains(v540.ui.menu.misc.hitlogs:get(), "On screen") then
                print_dev(string.format("\affffffff[\a" .. v545 .. "gingersense\affffffff] \a" .. v545 .. "%s\a" .. "\affffffff bought \a" .. v545 .. "%s", v543, l_weapon_0));
            end;
            if v540.helpers:contains(v540.ui.menu.misc.hitlogs:get(), "Console") then
                print_raw(string.format("\affffffff[\a" .. v545 .. "gingersense\affffffff] \a" .. v545 .. "%s\a" .. "\affffffff bought \a" .. v545 .. "%s", v543, l_weapon_0));
            end;
            return;
        end;
    end
}):struct("cross_marker")({
    markers = {}, 
    draw_marker = function(_, v547, v548, v549, v550, v551)
        local v552 = render.world_to_screen(v547);
        if not v552 then
            return;
        else
            local v553 = v550 * 0.5;
            local v554 = v549 + v553;
            local v555 = vector(v552.x - v553, v552.y - v554);
            local v556 = vector(v552.x + v553, v552.y + v554);
            local v557 = vector(v552.x - v554, v552.y - v553);
            local v558 = vector(v552.x + v554, v552.y + v553);
            local v559 = v548.Vertical:clone();
            local v560 = v548.Horizontal:clone();
            v559.a = v559.a * v551;
            v560.a = v560.a * v551;
            render.rect(v555, v556, v559);
            render.rect(v557, v558, v560);
            return;
        end;
    end, 
    update_markers = function(v561)
        local l_realtime_1 = globals.realtime;
        for v563 = #v561.markers, 1, -1 do
            if v561.markers[v563].expire_time < l_realtime_1 then
                table.remove(v561.markers, v563);
            end;
        end;
    end, 
    render = function(v564)
        if not globals.is_in_game or not v564.ui.menu.vis.kibit_marker:get() then
            return;
        else
            local v565 = {
                thickness = 2, 
                size = 4, 
                colors = {
                    Vertical = color(0, 255, 0, 255), 
                    Horizontal = color(0, 255, 255, 255)
                }
            };
            v564:update_markers();
            for _, v567 in ipairs(v564.markers) do
                local v568 = v567.expire_time - globals.realtime;
                local v569 = v568 < 0.7 and v568 / 0.7 or 1;
                v564:draw_marker(v567.position, v565.colors, v565.size, v565.thickness, v569);
            end;
            return;
        end;
    end, 
    add_marker = function(v570, v571)
        table.insert(v570.markers, {
            position = v571.aim, 
            expire_time = globals.realtime + 3
        });
    end, 
    clear_markers = function(v572)
        v572.markers = {};
    end
}):struct("skeetinds")({
    lookup = {}, 
    update = function(v573)
        local v574 = ui.get_binds();
        for v575 in pairs(v573.lookup) do
            v573.lookup[v575] = nil;
        end;
        for v576 = 1, #v574 do
            local v577 = v574[v576];
            local v578 = v577.reference:id();
            v573.lookup[v578] = v577;
        end;
    end, 
    get = function(v579, v580)
        if v580 == nil then
            return nil;
        else
            return v579.lookup[v580:id()];
        end;
    end, 
    setup = function(v581)
        v581.font = render.load_font("C:\\Windows\\Fonts\\calibrib.ttf", vector(25, 23.5, 0), "a");
        v581.bomb_icon = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\bomb_c4.svg", vector(32, 32));
        v581.draw_queue = {};
    end, 
    clear_queue = function(v582)
        for v583 = 1, #v582.draw_queue do
            v582.draw_queue[v583] = nil;
        end;
    end, 
    add_indicator = function(v584, v585, v586, v587, v588)
        local v589 = render.measure_text(v584.font, nil, v586);
        local v590 = render.screen_size();
        v589.y = v589.y + 8;
        local v591 = next(v584.draw_queue) == nil and v590.y - (v590.y - 380) / 2 or v584.draw_queue[#v584.draw_queue].offset - 8 - v589.y;
        table.insert(v584.draw_queue, {
            text = v586, 
            color = v585, 
            offset = v591, 
            text_size = v589, 
            progress = v587, 
            icon = v588
        });
    end, 
    draw_shadow = function(_, v593, v594)
        local v595 = (v593 + v594) / 2;
        local v596 = color(0, 0, 0, 0);
        local v597 = color(0, 0, 0, 50);
        render.gradient(v593, vector(v595.x, v594.y), v596, v597, v596, v597);
        render.gradient(v594, vector(v595.x, v593.y), v596, v597, v596, v597);
    end, 
    draw_indicators = function(v598)
        for v599 = 1, #v598.draw_queue do
            local v600 = v598.draw_queue[v599];
            local v601 = vector(3, v600.offset);
            local v602 = v601 + vector(24, 4);
            v598:draw_shadow(v601, v601 + v600.text_size + vector(50, 0));
            if v600.icon then
                render.texture(v598.bomb_icon, v601 + vector(24, (v600.text_size.y - 29) / 2), vector(32, 29), v600.color);
                v602.x = v602.x + 37;
            end;
            render.text(v598.font, v602, v600.color, nil, v600.text);
            if v600.progress then
                local v603 = v602 + vector(v600.text_size.x + 15, v600.text_size.y / 2 - 5);
                render.circle_outline(v603, color(0, 0, 0, 255), 10, 0, 1, 5);
                render.circle_outline(v603, color(255, 255, 255, 200), 10, 0, v600.progress, 3);
            end;
        end;
    end, 
    update_indicators = function(v604, _)
        local v606 = entity.get_local_player();
        if not v606 or not v606:is_alive() then
            return;
        else
            local v607 = v604:get(v604.ref.rage.dmg);
            local v608 = v604:get(v604.ref.rage.hitchance);
            if v604.ref.rage.dormant_aimbot:get_override() or v604.ref.rage.dormant_aimbot:get() then
                v604:add_indicator(color(255, 255, 255, 200), "DA");
            end;
            if v604.ref.rage.dt:get() and not v604.ref.rage.fd:get() then
                v604:add_indicator(rage.exploit:get() == 1 and color(255, 255, 255, 200) or color(255, 0, 50, 200), "DT");
            end;
            if v604.ref.rage.hs:get() and not v604.ref.rage.fd:get() and not v604.ref.rage.dt:get() then
                v604:add_indicator(color(255, 255, 255, 200), "OSAA");
            end;
            if v604.ref.rage.fd:get() then
                v604:add_indicator(color(255, 255, 255, 200), "DUCK");
            end;
            if v604.ref.antiaim.freestanding:get() or v604.ref.antiaim.freestanding:get_override() then
                v604:add_indicator(color(255, 255, 255, 200), "FS");
            end;
            if v604.ref.rage.fb:get() == "Force" then
                v604:add_indicator(color(255, 255, 255, 200), "BAIM");
            end;
            if v604.ref.rage.safe_point:get() == "Force" then
                v604:add_indicator(color(255, 255, 255, 200), "SAFE");
            end;
            if v607 ~= nil and v607.active then
                v604:add_indicator(color(255, 255, 255, 200), "DMG");
            end;
            if v608 ~= nil and v608.active then
                v604:add_indicator(color(255, 255, 255, 200), "H1TCHANCE");
            end;
            if v604.ref.rage.ping:get() > 0 or v604.ref.rage.ping:get_override() then
                local v609 = utils.net_channel();
                if v609 then
                    local v610 = math.clamp(v609.latency[0] + v609.latency[1], 0.001, 0.2);
                    local v611 = math.clamp(v604.ref.rage.ping:get() * 0.001 + v609.avg_latency[1], 0.001, 0.2);
                    local v612 = math.clamp(v610 / v611, 0, 1);
                    v604:add_indicator(v612 < 0.5 and color(250, 234, 232):lerp(color(213, 197, 84), v612 * 2) or color(213, 197, 84):lerp(color(143, 194, 21), (v612 - 0.5) * 2), "PING");
                end;
            end;
            local v613 = entity.get_game_rules();
            if v613 and v613.m_bBombPlanted then
                local v614 = entity.get_entities("CPlantedC4")[1];
                if v614 and v614.m_bBombTicking and not v614.m_bBombDefused then
                    local v615 = v614.m_flC4Blow - globals.curtime;
                    if v615 > 0 then
                        v604:add_indicator(color(255, 255, 255, 200), string.format("%s - %.1fs", v614.m_nBombSite == 1 and "B" or "A", v615), nil, true);
                    end;
                end;
            end;
            return;
        end;
    end, 
    on_paint = function(v616, v617)
        if not globals.is_in_game or not v616.ui.menu.vis.gingerindicators:get() then
            return;
        else
            v616:clear_queue();
            v616:update_indicators(v617);
            v616:draw_indicators();
            return;
        end;
    end
});
for _, v630 in ipairs({
    [1] = {
        [1] = "load", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.ui:execute();
            v618.config:initialize();
            v618.antiaim:init();
            v618.mindmg:setup();
            v618.skeetinds:setup();
            v618.watermark:setup();
            v618.helpers:add_notification("\ac96826ff" .. ui.get_icon("burger") .. " \affffffff| Welcome ['\ac96826ff" .. common.get_username() .. "\affffffff'] build \ac96826fflive");
            if v618.ui.menu.global.watermark_text:get() == "" then
                v618.ui.menu.global.watermark_text:set("gingersense");
            end;
            if v618.ui.menu.global.sidebar_text:get() == "" then
                v618.ui.menu.global.sidebar_text:set("gingersense");
            end;
        end
    }, 
    [2] = {
        [1] = "post_update_clientside_animation", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.misc:animations();
        end
    }, 
    [3] = {
        [1] = "item_purchase", 
        [2] = function(v619)
            -- upvalues: v618 (ref)
            v618.hitlogs:on_item_purchase(v619);
        end
    }, 
    [4] = {
        [1] = "aim_ack", 
        [2] = function(v620)
            -- upvalues: v618 (ref)
            v618.hitlogs:main(v620);
            v618.cross_marker:add_marker(v620);
        end
    }, 
    [5] = {
        [1] = "render", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.skeetinds:update();
            v618.visuals:scope_overlay();
            v618.visuals:aspectratio_viewmodel();
            v618.visuals:net_graph();
            v618.watermark:render_watermark();
            v618.mindmg:render_damage_indicator();
            v618.helpers:render_notifications();
            v618.hitmarker:draw();
            v618.cross_marker:render();
            v618.skeetinds:on_paint();
            if ui.get_alpha() > 0 then
                v618.ui:sidebarname();
            end;
        end
    }, 
    [6] = {
        [1] = "player_death", 
        [2] = function(v621)
            -- upvalues: v618 (ref)
            v618.killsay:trashtalk(v621);
            v618.killsay:death_say(v621);
        end
    }, 
    [7] = {
        [1] = "player_hurt", 
        [2] = function(v622)
            -- upvalues: v618 (ref)
            v618.hitmarker:process_hurt_event(v622);
        end
    }, 
    [8] = {
        [1] = "level_init", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.antiaim.state.defensive_after = false;
            v618.antiaim.state.defensive_after = 0;
            v618.antiaim.state.round_ended = false;
            if v618.helpers:contains(v618.ui.menu.misc.extra_notification_options:get(), "Anti-Bruteforce") then
                v618.helpers:add_notification("\a7583e0ff" .. ui.get_icon("power-off") .. "\affffffff | Anti-Bruteforce resetted due to ['\a7583e0fflevel init\affffffff']");
            end;
            v618.antiaim:reset_antibruteforce();
        end
    }, 
    [9] = {
        [1] = "draw_model", 
        [2] = function(v623)
            -- upvalues: v618 (ref)
            local v624 = entity.get_local_player();
            if not v624 or not v624:is_alive() or not v618.ui.menu.vis.disable_sleeves:get() then
                return;
            else
                return not v623.name:find("sleeve");
            end;
        end
    }, 
    [10] = {
        [1] = "bullet_impact", 
        [2] = function(v625)
            -- upvalues: v618 (ref)
            v618.antiaim:shot_detection(v625);
        end
    }, 
    [11] = {
        [1] = "createmove", 
        [2] = function(v626)
            -- upvalues: v618 (ref)
            v618.ref.rage.dt:override();
            v618.ref.rage.hs:override();
            v618.ref.rage.dt_fakelag:override();
            v618.ref.rage.dtlag:override();
            v618.defensive:on_createmove(v626);
            v618.antiaim:run(v626);
            v618.misc:no_fall_damage(v626);
            v618.misc:freezetime_fakeduck(v626);
            v618.misc:fake_latency(v626);
            v618.misc:fast_ladder(v626);
        end
    }, 
    [12] = {
        [1] = "createmove_run", 
        [2] = function(v627)
            -- upvalues: v618 (ref)
            v618.misc:unlock_fakeduck_speed(v627);
            local v628 = entity.get_local_player();
            if v628:is_alive() then
                if v628.m_MoveType == 9 and common.is_button_down(87) then
                    v618.misc.ladder_status = true;
                else
                    v618.misc.ladder_status = false;
                end;
            else
                v618.misc.ladder_status = false;
            end;
        end
    }, 
    [13] = {
        [1] = "round_end", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.antiaim.state.round_ended = true;
            v618.antiaim.state.defensive_after = 0;
            if v618.helpers:contains(v618.ui.menu.misc.extra_notification_options:get(), "Anti-Bruteforce") then
                v618.helpers:add_notification("\a7583e0ff" .. ui.get_icon("power-off") .. "\affffffff | Anti-Bruteforce resetted due to ['\a7583e0ffround end\affffffff']");
            end;
            v618.antiaim:reset_antibruteforce();
        end
    }, 
    [14] = {
        [1] = "round_start", 
        [2] = function()
            -- upvalues: v618 (ref)
            v618.antiaim.state.round_ended = false;
            v618.antiaim.state.defensive_after = 0;
            v618.antiaim:reset_antibruteforce();
        end
    }
}) do
    if v630[1] == "load" then
        v630[2]();
    else
        events[v630[1]]:set(v630[2]);
    end;
end;