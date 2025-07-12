local l_mui_0 = require("neverlose/mui");
local l_liberia_0 = require("neverlose/liberia");
local l_smooth_0 = require("neverlose/smooth");
local l_clipboard_0 = require("neverlose/clipboard");
local l_lambotruck_0 = require("neverlose/lambotruck");
local l_system_0 = require("neverlose/dragging_system");
local l_monylinear_0 = require("neverlose/monylinear");
require("neverlose/extended_events");
local l_print_0 = require("neverlose/print");
l_print_0({
    inspect = true, 
    prefix = l_mui_0.header("!h<FF8080FF>[serenity.lua]!d ")
});
files.create_folder("nl\\Serenity");
if not pcall(function()
    -- upvalues: l_liberia_0 (ref)
    l_liberia_0.file_system.download_file("https://vh488226.eurodir.ru/serenity/Logo.png", "nl\\Serenity\\LogoFull.png", 5);
    l_liberia_0.file_system.download_file("https://vh488226.eurodir.ru/serenity/Logo_Small.png", "nl\\Serenity\\LogoSmall.png", 5);
    l_liberia_0.file_system.download_file("https://vh488226.eurodir.ru/serenity/Branch.png", "nl\\Serenity\\Branch.png", 5);
    l_liberia_0.file_system.download_file("https://vh488226.eurodir.ru/serenity/Leaflet.png", "nl\\Serenity\\Leaflet.png", 5);
    render.load_image_from_file("nl\\Serenity\\LogoFull.png", vector(1024, 1024));
end) then
    local v8 = render.load_font("Calibri", 12, "abod");
    cvar.clear:call();
    print_raw("\n");
    l_print_0("An unexpected error occurred while downloading the necessary components.");
    l_print_0("To correct this error, follow the instructions below:");
    l_print_0(" 1. Download the 'rar' archive with the necessary components from Discord:");
    l_print_0("     \aFF8080FFhttps://cdn.discordapp.com/attachments/1168745920473595925/1168745950123151370/Serenity.rar\aDEFAULT");
    l_print_0(" 2. Extract all images from the archive to the following directory: '...\\Counter-Strike Global Offensive\\nl\\Serenity'.");
    l_print_0(" 3. Restart the script.");
    l_print_0(" note: If this still does not work, join our discord and open a ticket and we will send you the required files.");
    print_raw("\n");
    events.render(function()
        -- upvalues: v8 (ref)
        for v9 = 1, 10 do
            render.text(v8, vector(5, 5 + 14 * (v9 - 1)), color(), nil, "\aFF8080FF[serenity.lua]\aDEFAULT | \aB90000FFfailed to load file\aDEFAULT | An unexpected error occurred while downloading the necessary components. Please open the game console.");
        end;
    end);
    return;
else
    local v10 = render.load_image_from_file("nl\\Serenity\\LogoFull.png", vector(1024, 1024));
    local l_serenity_recode_0 = db.serenity_recode;
    if not l_serenity_recode_0 then
        db.serenity_recode = {
            configs = {}
        };
        l_serenity_recode_0 = db.serenity_recode;
    end;
    local v29 = {
        username = common.get_username(), 
        screen = render.screen_size(), 
        update = "31.10.2023", 
        build = "Live", 
        conditions = {
            [1] = "Global / N", 
            [2] = "Global / CT", 
            [3] = "Global / T", 
            [4] = "Standing / N", 
            [5] = "Standing / CT", 
            [6] = "Standing / T", 
            [7] = "Moving / N", 
            [8] = "Moving / CT", 
            [9] = "Moving / T", 
            [10] = "Slow Move / N", 
            [11] = "Slow Move / CT", 
            [12] = "Slow Move / T", 
            [13] = "Crouch / N", 
            [14] = "Crouch / CT", 
            [15] = "Crouch / T", 
            [16] = "Crouch Move / N", 
            [17] = "Crouch Move / CT", 
            [18] = "Crouch Move / T", 
            [19] = "In Air / N", 
            [20] = "In Air / CT", 
            [21] = "In Air / T", 
            [22] = "Air Crouch / N", 
            [23] = "Air Crouch / CT", 
            [24] = "Air Crouch / T"
        }, 
        default_cvars = {
            viewmodel = {
                FOV = cvar.viewmodel_fov:float(), 
                x = cvar.viewmodel_offset_x:float(), 
                y = cvar.viewmodel_offset_y:float(), 
                z = cvar.viewmodel_offset_z:float()
            }, 
            aspectratio = cvar.r_aspectratio:float()
        }, 
        aspect_ratio = {
            [1] = {
                [1] = 16, 
                [2] = 9
            }, 
            [2] = {
                [1] = 16, 
                [2] = 10
            }, 
            [3] = {
                [1] = 4, 
                [2] = 3
            }, 
            [4] = {
                [1] = 2, 
                [2] = 3
            }
        }, 
        center = function(v12, v13)
            if not v13 then
                v13 = 10;
            end;
            return string.rep(" ", math.floor(v13 * 0.5)) .. v12 .. string.rep(" ", math.ceil(v13 * 0.5));
        end, 
        split = function(v14, v15)
            if not v15 then
                v15 = "%s";
            end;
            local v16 = {};
            for v17 in string.gmatch(v14, "([^" .. v15 .. "]+)") do
                table.insert(v16, v17);
            end;
            return v16;
        end, 
        percentage = function(v18, v19, v20)
            local v21 = v19.r * v18 + v20.r * (1 - v18);
            local v22 = v19.g * v18 + v20.g * (1 - v18);
            local v23 = v19.b * v18 + v20.b * (1 - v18);
            return color(v21, v22, v23, 255);
        end, 
        vector2angle = function(v24)
            local v25 = 0;
            local v26 = 0;
            local v27 = 0;
            if v24.y == 0 and v24.x == 0 then
                v26 = 0;
                if v24.z > 0 then
                    Pitch = 270;
                else
                    Pitch = 90;
                end;
            else
                v26 = math.atan2(v24.y, v24.x) * 180 / math.pi;
                if v26 < 0 then
                    v26 = v26 + 360;
                end;
                v25 = math.sqrt(v24.x * v24.x + v24.y * v24.y);
                v27 = math.atan2(-v24.z, v25) * 180 / math.pi;
                if v27 < 0 then
                    v27 = v27 + 360;
                end;
            end;
            return vector(v27, v26, 0);
        end, 
        deg2rad = function(v28)
            return v28 * (math.pi / 180);
        end
    };
    v29.angle2vector = function(v30)
        -- upvalues: v29 (ref)
        local v31 = vector(0, 0, 0);
        local v32 = math.cos(v29.deg2rad(v30.x));
        local v33 = math.sin(v29.deg2rad(v30.x));
        local v34 = math.cos(v29.deg2rad(v30.y));
        local v35 = math.sin(v29.deg2rad(v30.y));
        local _ = math.cos(v29.deg2rad(v30.z));
        local _ = math.sin(v29.deg2rad(v30.z));
        v31.x = v32 * v34;
        v31.y = v32 * v35;
        v31.z = -v33;
        return v31;
    end;
    v29.get_edge = function(v38, v39, v40)
        -- upvalues: v29 (ref)
        local v41 = {};
        local v42 = render.camera_angles();
        local v43 = v42 or vector(0, 0, 0);
        local v44 = {
            yaw = v40 and v40[1] or 180, 
            step = v40 and v40[2] or 10
        };
        for v45 = v42.y - v44.yaw, v42.y + v44.yaw, v44.step do
            v45 = math.normalize_yaw(v45);
            local v46 = vector(0, v45, 0);
            local v47 = v38 + v29.angle2vector(v46) * 64;
            local v48 = utils.trace_line(v38, v47, lp, 33570827, 0);
            if v48.entity and (v48.entity:get_classname() == "CWorld" or v48.entity:get_classname() == "CBaseDoor") and v48.fraction <= v39 then
                v41[#v41 + 1] = {
                    vec_trace_end = v48.end_pos, 
                    yaw_o = v45, 
                    fract = v48.fraction
                };
            end;
        end;
        table.sort(v41, function(v49, v50)
            return v49.yaw_o < v50.yaw_o;
        end);
        local v51 = nil;
        if #v41 >= 2 then
            local v52 = v41[1].vec_trace_end:lerp(v41[#v41].vec_trace_end, 0.5);
            v51 = v29.vector2angle(v38 - v52);
        end;
        return v41, v42, v43, v51;
    end;
    v29.calc_angle = function(v53, v54)
        local v55 = vector(0, 0, 0);
        local v56 = vector(v53.x - v54.x, v53.y - v54.y, v53.z - v54.z);
        local v57 = math.sqrt(v56.x * v56.x + v56.y * v56.y);
        v55.x = math.atan(v56.z / v57) * (180 / math.pi);
        v55.y = math.atan(v56.y / v56.x) * (180 / math.pi);
        v55.z = 0;
        if v56.x >= 0 then
            v55.y = v55.y + 180;
        end;
        return v55;
    end;
    v29.to_console = function(v58)
        -- upvalues: l_mui_0 (ref)
        return l_mui_0.header(v58);
    end;
    local v59 = {
        lp = {}
    };
    v59.lp.self = entity.get_local_player();
    v59.lp.team = {
        name = "N", 
        index = -1
    };
    v59.lp.ping = {
        real = 0, 
        incoming = 0
    };
    v59.gears = {};
    local v60 = {
        rage_bot = {
            Enabled = {
                dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
            }, 
            ["Peek Assist"] = {
                self = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
                retreat = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode")
            }, 
            ["Double Tap"] = {
                self = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
                options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
            }, 
            ["Hide Shots"] = {
                self = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
                options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
            }, 
            ["Safe Points"] = {
                self = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
            }, 
            ["Body Aim"] = {
                self = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
            }
        }, 
        anti_aim = {
            ["Fake Lag"] = {
                self = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
                limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
                variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
            }, 
            Misc = {
                ["Fake Duck"] = {
                    self = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
                }
            }
        }, 
        world = {
            ["Override Zoom"] = {
                overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
            }
        }, 
        main = {
            ["Fake Latency"] = {
                self = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }, 
            Other = {
                weapon_action = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
            }
        }
    };
    local v61 = {
        tabs = {
            home = {
                logotype = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n1", 1), 
                selected = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n2", 2), 
                informations = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n3", 2), 
                informations_2 = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n3.5", 1), 
                recommendations = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n4", 2), 
                configurations = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n5", 1), 
                configurations_2 = l_mui_0.create("!h<{Link Active}>!i<house>!d", "\n5.5", 2)
            }, 
            ["anti aim"] = {
                settings = l_mui_0.create("!h<{Link Active}>!i<rotate>!d", "\n1", 1), 
                settings_2 = l_mui_0.create("!h<{Link Active}>!i<rotate>!d", "\n1.33", 1), 
                settings_3 = l_mui_0.create("!h<{Link Active}>!i<rotate>!d", "\n1.66", 1), 
                builder = l_mui_0.create("!h<{Link Active}>!i<rotate>!d", "\n2", 2)
            }, 
            settings = {
                select = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nSelect", 1), 
                misc_3 = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nMisc 3", 2), 
                visuals = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nVisuals 1", 2), 
                visuals_2 = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nVisuals 2", 1), 
                misc = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nMisc 1", 2), 
                misc_2 = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nMisc 2", 1), 
                misc_4 = l_mui_0.create("!h<{Link Active}>!i<gear>!d", "\nMisc 4", 1)
            }
        }
    };
    v61.home = {
        logo = l_mui_0.texture(v61.tabs.home.logotype, v10, vector(270, 288), ui.get_style("Link Active")), 
        select = l_mui_0.table(v61.tabs.home.selected, "\n", {
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Informations"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Recommendations"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Configurations")
        }), 
        username = l_mui_0.text(v61.tabs.home.informations, ("!h<!s<Link Active>>!i<user>!d  Username: !h<!s<Link Active>>%s!d"):format(v29.username)), 
        last_update = l_mui_0.text(v61.tabs.home.informations, ("!h<!s<Link Active>>!i<clock>!d  Last Update: !h<!s<Link Active>>%s!d"):format(v29.update)), 
        current_build = l_mui_0.text(v61.tabs.home.informations, ("!h<!s<Link Active>>!i<block-brick>!d  Current Build: !h<!s<Link Active>>%s!d"):format(v29.build)), 
        sidebar = l_mui_0.combo(v61.tabs.home.informations_2, "!h<!s<Link Active>>!i<bars>!d  Sidebar Style", {
            [1] = "Modern", 
            [2] = "Twinkle", 
            [3] = "Default", 
            [4] = "Static"
        }), 
        discord = l_mui_0.button(v61.tabs.home.recommendations, ("!mt<1>!h<!s<Link Active>>!i<discord>!d%s!d"):format(v29.center("Discord", 10)), true, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/V9KZZvMqzs");
        end), 
        youTube = l_mui_0.button(v61.tabs.home.recommendations, ("!mt<1>!h<!s<Link Active>>!i<youtube>!d%s!d"):format(v29.center("YouTube", 17)), true, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@murfs");
        end), 
        config = l_mui_0.button(v61.tabs.home.recommendations, ("!mt<1>!h<!s<Link Active>>!i<link>!d%s!d"):format(v29.center("Config", 12)), true, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/?page=0&search=author:murfyy&sort=drec0&type=0&filter=0");
        end), 
        version = l_mui_0.button(v61.tabs.home.recommendations, ("!mt<1>!h<!s<Link Active>>!i<cart-shopping>!d%s!d"):format(v29.center("Marketplace", 10)), true, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/?page=0&search=author:%20murfyy&sort=drec0&type=2&filter=0");
        end), 
        name = l_mui_0.text_box(v61.tabs.home.configurations, "", ""), 
        save = l_mui_0.button(v61.tabs.home.configurations, v29.center("!h<!s<Link Active>>!i<upload>!d  Save", 10), true), 
        export = l_mui_0.button(v61.tabs.home.configurations, v29.center("!h<!s<Link Active>>!i<file-export>!d  Export", 4), true), 
        import = l_mui_0.button(v61.tabs.home.configurations, v29.center("!h<!s<Link Active>>!i<file-import>!d  Import", 3), true), 
        list = l_mui_0.table(v61.tabs.home.configurations_2, "", {
            [1] = "~"
        }), 
        load = l_mui_0.button(v61.tabs.home.configurations_2, v29.center("!h<!s<Link Active>>!i<download>!d  Load", 22), true), 
        remove = l_mui_0.button(v61.tabs.home.configurations_2, v29.center("!h<!s<Link Active>>!i<trash>!d  Remove", 19), true)
    };
    v61["anti aim"] = {
        type = l_mui_0.table(v61.tabs["anti aim"].settings, "\n", {
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Disabled"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Normal"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Teams")
        }), 
        manual = l_mui_0.combo(v61.tabs["anti aim"].settings_2, "Manual Yaw", {
            [1] = "Disabled", 
            [2] = "At Target", 
            [3] = "Backward", 
            [4] = "Forward", 
            [5] = "Left", 
            [6] = "Right"
        }, function(v62)
            -- upvalues: l_mui_0 (ref)
            return {
                static = l_mui_0.switch(v62, "Static Manual", false), 
                magnet = l_mui_0.hotkey(v62, "Magnetize", 0)
            };
        end), 
        tweaks = l_mui_0.multi_combo(v61.tabs["anti aim"].settings_2, "Tweaks", {
            [1] = "AA on Use", 
            [2] = "Edge Yaw", 
            [3] = "Avoid Backstab", 
            [4] = "Fast Ladder", 
            [5] = "Auto Teleport"
        }, function(v63)
            -- upvalues: l_mui_0 (ref)
            return {
                edge_yaw = l_mui_0.combo(v63, "Edge Yaw", {
                    [1] = "Always On", 
                    [2] = "On Fake Duck"
                }), 
                weapon = l_mui_0.multi_combo(v63, "[TP] Weapon", {
                    [1] = "Pistols", 
                    [2] = "Auto Snipers", 
                    [3] = "AWP", 
                    [4] = "SSG-08", 
                    [5] = "Heavy Pistols", 
                    [6] = "Knife / Taser"
                }), 
                delay = l_mui_0.slider(v63, "[TP] Delay", 0, 0, 24, 1, nil, function(v64)
                    if v64 == 0 then
                        return "Off";
                    else
                        return ("%st"):format(v64);
                    end;
                end), 
                in_air = l_mui_0.switch(v63, "[TP] Only in Air", false)
            };
        end), 
        safe = l_mui_0.multi_combo(v61.tabs["anti aim"].settings_2, "Safe Head", {
            [1] = "Knife & Air Crouch", 
            [2] = "Enemy Below"
        }), 
        freestanding = l_mui_0.switch(v61.tabs["anti aim"].settings_2, "Freestanding", false, function(v65)
            -- upvalues: l_mui_0 (ref)
            return {
                disablers = l_mui_0.multi_combo(v65, "Disablers", {
                    [1] = "Manual", 
                    [2] = "Standing", 
                    [3] = "Moving", 
                    [4] = "Slow Move", 
                    [5] = "Crouch", 
                    [6] = "In Air"
                }), 
                DYM = l_mui_0.switch(v65, "Disabled Yaw Modifier", false), 
                BF = l_mui_0.switch(v65, "Body Freestanding", false)
            };
        end), 
        animations = l_mui_0.switch(v61.tabs["anti aim"].settings_2, "\aDE9B37FFAnim. Breakers", false, function(v66)
            -- upvalues: l_mui_0 (ref)
            return {
                select = l_mui_0.multi_combo(v66, "Select", {
                    [1] = "0 Pitch on Land", 
                    [2] = "Legs on Landing", 
                    [3] = "Legs in Air", 
                    [4] = "Body Lean"
                }), 
                landing = l_mui_0.combo(v66, "Legs on Landing", {
                    [1] = "Static", 
                    [2] = "Backward", 
                    [3] = "Switch", 
                    [4] = "Shivering", 
                    [5] = "Moonwalk"
                }), 
                air = l_mui_0.combo(v66, "Legs in Air", {
                    [1] = "Static", 
                    [2] = "Moonwalk"
                }), 
                lean = l_mui_0.slider(v66, "Body Lean", 0, 0, 100, 1, nil, function(v67)
                    if v67 == 0 then
                        return "Off";
                    else
                        return ("%s%%"):format(v67);
                    end;
                end)
            };
        end), 
        export = l_mui_0.button(v61.tabs["anti aim"].settings_3, ("!mt<1>!h<!s<Link Active>>!i<file-export>!d%s!d"):format(v29.center("Export", 18)), true), 
        import = l_mui_0.button(v61.tabs["anti aim"].settings_3, ("!mt<1>!h<!s<Link Active>>!i<file-import>!d%s!d"):format(v29.center("Import", 18)), true), 
        send = l_mui_0.button(v61.tabs["anti aim"].settings_3, ("  !h<!s<Link Active>>!i<share-nodes>!d%s!d"):format(v29.center("Copy Condition to Opposing Team", 10)), true), 
        condition = l_mui_0.combo(v61.tabs["anti aim"].builder, "Condition", {
            [1] = "Global", 
            [2] = "Standing", 
            [3] = "Moving", 
            [4] = "Slow Move", 
            [5] = "Crouch", 
            [6] = "Crouch Move", 
            [7] = "In Air", 
            [8] = "Air Crouch"
        }), 
        team = l_mui_0.combo(v61.tabs["anti aim"].builder, "Team", {
            [1] = "Counter-Terrorists", 
            [2] = "Terrorists"
        })
    };
    v61.settings = {
        indicators = l_mui_0.switch(v61.tabs.settings.visuals_2, "Crosshair Indicators", false, function(v68)
            -- upvalues: l_mui_0 (ref)
            return {
                style = l_mui_0.combo(v68, "Style", {
                    [1] = "Modern", 
                    [2] = "Previous "
                }), 
                display = l_mui_0.multi_combo(v68, "Display", {
                    [1] = "Version", 
                    [2] = "Condition", 
                    [3] = "Binds"
                }), 
                binds = l_mui_0.multi_combo(v68, "Binds", {
                    [1] = "Double Tap", 
                    [2] = "Hide Shots", 
                    [3] = "Fake Duck", 
                    [4] = "Body Aim", 
                    [5] = "Freestanding"
                }), 
                additions = l_mui_0.multi_combo(v68, "Additions", {
                    [1] = "To Scope", 
                    [2] = "Header Glow"
                }), 
                colors = l_mui_0.color_edit(v68, "Colors", {
                    Header = {
                        color(255, 255, 255, 255), 
                        color(255, 255, 255, 255)
                    }, 
                    Condition = {
                        color(255, 255, 255, 255), 
                        color(255, 255, 255, 255)
                    }
                }), 
                revitalize = l_mui_0.switch(v68, "Revitalize", false)
            };
        end), 
        watermark = l_mui_0.combo(v61.tabs.settings.visuals_2, "Watermark", {
            [1] = "Simple", 
            [2] = "Serenity", 
            [3] = "Emoji", 
            [4] = "Anime"
        }, function(v69)
            -- upvalues: l_mui_0 (ref)
            return {
                position = l_mui_0.combo(v69, "Position", {
                    [1] = "Below", 
                    [2] = "Left", 
                    [3] = "Right"
                }), 
                type = l_mui_0.combo(v69, "Type", {
                    [1] = "Full", 
                    [2] = "Only Logo", 
                    [3] = "Only Text"
                }), 
                color = l_mui_0.color_edit(v69, "color", color(210, 166, 255, 255))
            };
        end), 
        damage = l_mui_0.switch(v61.tabs.settings.visuals_2, "Minimum Damage", false, function(v70)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                color = l_mui_0.color_edit(v70, "Color", color(255, 255, 255, 255)), 
                show = l_mui_0.switch(v70, "Display if Active", false), 
                x = l_mui_0.slider(v70, "damage x", v29.screen.x * 0.5, 0, v29.screen.x, 1), 
                y = l_mui_0.slider(v70, "damage y", v29.screen.y * 0.5 - 11, 0, v29.screen.y, 1)
            };
        end), 
        arrows = l_mui_0.switch(v61.tabs.settings.visuals_2, "Manual Arrows", false, function(v71)
            -- upvalues: l_mui_0 (ref)
            return {
                style = l_mui_0.combo(v71, "Style", {
                    [1] = "Teamskeet", 
                    [2] = "Simple"
                }), 
                display = l_mui_0.combo(v71, "Display", {
                    [1] = "Always On", 
                    [2] = "Only on Manual"
                }), 
                offset = l_mui_0.slider(v71, "Offset", 50, 15, 100, 1), 
                color = l_mui_0.color_edit(v71, "Color", color(255, 255, 255, 255)), 
                colors = l_mui_0.color_edit(v71, "Colors", {
                    Manual = {
                        color(255, 255, 255, 255)
                    }, 
                    Inveted = {
                        color(255, 255, 255, 255)
                    }
                })
            };
        end), 
        widgets = l_mui_0.switch(v61.tabs.settings.visuals_2, "Screen Widgets", false, function(v72)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                display = l_mui_0.multi_combo(v72, "Displays", {
                    [1] = "Watermark", 
                    [2] = "Keybinds", 
                    [3] = "Spectators", 
                    [4] = "Velocity Warning", 
                    [5] = "Defensive Indicator"
                }), 
                style = l_mui_0.combo(v72, "Style", {
                    [1] = "Default", 
                    [2] = "Modern", 
                    [3] = "Simple"
                }), 
                color = l_mui_0.color_edit(v72, "Accent", color(255, 255, 255, 255)), 
                background = l_mui_0.color_edit(v72, "Background", color(20, 20, 20, 196)), 
                x_w = l_mui_0.slider(v72, "Watermark X", 0, 0, v29.screen.x, 1), 
                y_w = l_mui_0.slider(v72, "Watermark Y", 0, 0, v29.screen.y, 1), 
                x_k = l_mui_0.slider(v72, "Keybinds X", 5, 0, v29.screen.x, 1), 
                y_k = l_mui_0.slider(v72, "Keybinds Y", v29.screen.y * 0.5 + 5, 0, v29.screen.y, 1), 
                x_s = l_mui_0.slider(v72, "Spectators X", 110, 0, v29.screen.x, 1), 
                y_s = l_mui_0.slider(v72, "Spectators Y", v29.screen.y * 0.5 + 5, 0, v29.screen.y, 1), 
                x_v = l_mui_0.slider(v72, "Velocity Warning X", v29.screen.x * 0.5 - 75, 0, v29.screen.x, 1), 
                y_v = l_mui_0.slider(v72, "Velocity Warning Y", v29.screen.y * 0.25 + 150, 0, v29.screen.y, 1), 
                x_d = l_mui_0.slider(v72, "Defensive Indicator X", v29.screen.x * 0.5 - 75, 0, v29.screen.x, 1), 
                y_d = l_mui_0.slider(v72, "Defensive Indicator Y", v29.screen.y * 0.25, 0, v29.screen.y, 1)
            };
        end), 
        skeet = l_mui_0.switch(v61.tabs.settings.misc_4, "!h<95B806FF>$500!d Indicators", false, function(v73)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                display = l_mui_0.multi_combo(v73, "Display", {
                    [1] = "Hit Chance", 
                    [2] = "Aimbot Stats", 
                    [3] = "Fake Latency", 
                    [4] = "Double Tap", 
                    [5] = "Hide Shots", 
                    [6] = "Dormant Aimbot", 
                    [7] = "Fake Duck", 
                    [8] = "Safe Points", 
                    [9] = "Body Aim", 
                    [10] = "Minimum Damage", 
                    [11] = "Freestanding", 
                    [12] = "Bomb Info", 
                    [13] = "Defusing"
                }), 
                spectators = l_mui_0.switch(v73, "Spectators", false), 
                offset = l_mui_0.slider(v73, "Spec. Offset", 0, 0, v29.screen.y * 0.25, 1)
            };
        end), 
        logs = l_mui_0.switch(v61.tabs.settings.visuals, "Aimbot Logs", false, function(v74)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                select = l_mui_0.multi_combo(v74, "Select", {
                    [1] = "Screen", 
                    [2] = "Console", 
                    [3] = "Top Left"
                }), 
                extended = l_mui_0.multi_combo(v74, "Informative", {
                    [1] = "Console", 
                    [2] = "Top Left"
                }), 
                style = l_mui_0.combo(v74, "Style", {
                    [1] = "Default", 
                    [2] = "Gamesense", 
                    [3] = "Modern"
                }), 
                offset = l_mui_0.slider(v74, "Offset", 0, -(v29.screen.x * 0.25), v29.screen.x * 0.25, 1), 
                colors = l_mui_0.color_edit(v74, "Colors", {
                    ["\aFFFFFF003\aDEFAULTHit"] = {
                        color(135, 178, 14, 255)
                    }, 
                    ["\aFFFFFF002\aDEFAULTMiss"] = {
                        color(238, 19, 20, 255)
                    }, 
                    ["\aFFFFFF001\aDEFAULTGlow"] = {
                        color(255, 255, 255, 125)
                    }
                })
            };
        end), 
        no_fall = l_mui_0.switch(v61.tabs.settings.visuals, "No Fall Damage", false), 
        drop_grenades = l_mui_0.switch(v61.tabs.settings.visuals, "Drop Grenades", false, function(v75)
            -- upvalues: l_mui_0 (ref)
            return {
                bind = l_mui_0.hotkey(v75, "Bind", 0), 
                discard = l_mui_0.multi_combo(v75, "Drop", {
                    [1] = "High Explosive", 
                    [2] = "Molotov", 
                    [3] = "Smoke", 
                    [4] = "Flashbang"
                })
            };
        end), 
        clantag = l_mui_0.switch(v61.tabs.settings.misc_2, "Clantag", false), 
        trashtalk = l_mui_0.switch(v61.tabs.settings.misc_2, "Trashtalk", false, function(v76)
            -- upvalues: l_mui_0 (ref)
            return {
                language = l_mui_0.combo(v76, "Language", {
                    [1] = "English", 
                    [2] = "Russian"
                }), 
                delay = l_mui_0.slider(v76, "Delay", 0, 0, 99, 0.1, nil, function(v77)
                    if v77 == 0 then
                        return "Rand";
                    else
                        return ("%ss"):format(v77 * 0.1);
                    end;
                end)
            };
        end), 
        scope = l_mui_0.switch(v61.tabs.settings.misc_2, "Custom Scope", false, function(v78)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                start = l_mui_0.slider(v78, "Start", 8, 0, v29.screen.x * 0.25, 1), 
                length = l_mui_0.slider(v78, "Length", 128, 4, v29.screen.x * 0.5, 1), 
                hidden = l_mui_0.multi_combo(v78, "Hidden", {
                    [1] = "Up", 
                    [2] = "Down", 
                    [3] = "Left", 
                    [4] = "Right"
                }), 
                inverter = l_mui_0.switch(v78, "Inverter", false), 
                color = l_mui_0.color_edit(v78, "Color", color(255, 255, 255, 255))
            };
        end), 
        nade_fix = l_mui_0.switch(v61.tabs.settings.misc, "!h<DE9B37FF>Nade Fix!d", false, function(v79)
            -- upvalues: l_mui_0 (ref)
            return {
                on = l_mui_0.multi_combo(v79, "Turn On", {
                    [1] = "Lag Options", 
                    [2] = "Quick Switch"
                })
            };
        end), 
        aspect_ratio = l_mui_0.switch(v61.tabs.settings.misc, "Aspect Ratio", false, function(v80)
            -- upvalues: v59 (ref), l_mui_0 (ref), v29 (ref)
            v59.gears.aspect_ratio = v80;
            return {
                offset = l_mui_0.slider(v80, "Offset", v29.default_cvars.aspectratio * 100, 0, 300, 0.01, nil, function(v81)
                    -- upvalues: v29 (ref)
                    v81 = v81 / 100;
                    for _, v83 in pairs(v29.aspect_ratio) do
                        if v81 == tonumber(("%.2f"):format(v83[1] / v83[2])) then
                            return ("%s:%s"):format(v83[1], v83[2]);
                        end;
                    end;
                end)
            };
        end), 
        viewmodel_changer = l_mui_0.switch(v61.tabs.settings.misc, "Viewmodel Changer", false, function(v84)
            -- upvalues: l_mui_0 (ref), v29 (ref)
            return {
                FOV = l_mui_0.slider(v84, "FOV", v29.default_cvars.viewmodel.FOV * 10, -1000, 1000, 0.1), 
                x = l_mui_0.slider(v84, "X", v29.default_cvars.viewmodel.x * 10, -1500, 1500, 0.1), 
                y = l_mui_0.slider(v84, "Y", v29.default_cvars.viewmodel.y * 10, -1500, 1500, 0.1), 
                z = l_mui_0.slider(v84, "Z", v29.default_cvars.viewmodel.z * 10, -1500, 1500, 0.1), 
                reset = l_mui_0.button(v84, v29.center("!h<DE9B37FF>!i<broom>!d  Reset Settings", 33), true)
            };
        end), 
        auto_m_unm = l_mui_0.switch(v61.tabs.settings.misc, "Auto Mute / Unmute", false, function(v85)
            -- upvalues: l_mui_0 (ref)
            return {
                mode = l_mui_0.combo(v85, "Mode", {
                    [1] = "Mute", 
                    [2] = "Unmute"
                })
            };
        end), 
        radius = l_mui_0.switch(v61.tabs.settings.misc, "Grenade Radius", false, function(v86)
            -- upvalues: l_mui_0 (ref)
            return {
                display = l_mui_0.multi_combo(v86, "Display", {
                    [1] = "Smoke", 
                    [2] = "Molotov"
                }), 
                color_se = l_mui_0.color_edit(v86, "Smoke", color(128, 128, 255, 128)), 
                color_ev = l_mui_0.color_edit(v86, "Enemy Molotov", color(255, 128, 128, 255)), 
                color_tv = l_mui_0.color_edit(v86, "Teammate's Molotov", color(128, 255, 128, 255))
            };
        end)
    };
    local v87 = {
        widgets = v61.settings.widgets[0], 
        damage = v61.settings.damage[0], 
        aspect_ratio = v59.gears.aspect_ratio
    };
    v87.widgets.x_w:visibility(false);
    v87.widgets.y_w:visibility(false);
    v87.widgets.x_k:visibility(false);
    v87.widgets.y_k:visibility(false);
    v87.widgets.x_s:visibility(false);
    v87.widgets.y_s:visibility(false);
    v87.widgets.x_v:visibility(false);
    v87.widgets.y_v:visibility(false);
    v87.widgets.x_d:visibility(false);
    v87.widgets.y_d:visibility(false);
    v87.damage.x:visibility(false);
    v87.damage.y:visibility(false);
    for _, v89 in pairs(v29.aspect_ratio) do
        local v90 = ("%s:%s"):format(v89[1], v89[2]);
        v61.settings.aspect_ratio[0][v90] = l_mui_0.button(v87.aspect_ratio, (not (v90 ~= "4:3") or v90 == "8:11") and (" %s "):format(v90) or v90 == "2:3" and ("  %s  "):format(v90) or v90 or v90, true);
        do
            local l_v89_0 = v89;
            v61.settings.aspect_ratio[0][v90]:set_callback(function()
                -- upvalues: v61 (ref), l_v89_0 (ref)
                v61.settings.aspect_ratio[0].offset:set(l_v89_0[1] / l_v89_0[2] * 100);
            end);
        end;
    end;
    get_team = function(v92)
        -- upvalues: v29 (ref), v61 (ref)
        if v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] == "Normal" then
            return ("%s / N"):format(v92);
        else
            return ("%s / %s"):format(v92, v61["anti aim"].team:get() == "Counter-Terrorists" and "CT" or "T");
        end;
    end;
    for v93 = 1, #v29.conditions do
        local v94 = v29.conditions[v93];
        local v95 = string.rep("", v93);
        v61["anti aim"][("%s / %s"):format(v94, "enable")] = l_mui_0.switch(v61.tabs["anti aim"].builder, ("%s%s"):format("Enable", v95), false);
        v61["anti aim"][("%s / %s"):format(v94, "pitch")] = l_mui_0.combo(v61.tabs["anti aim"].builder, ("%s%s"):format("Pitch", v95), {
            [1] = "Disabled", 
            [2] = "Down", 
            [3] = "Fake Up", 
            [4] = "Fake Down"
        });
        v61["anti aim"][("%s / %s"):format(v94, "yaw")] = l_mui_0.combo(v61.tabs["anti aim"].builder, ("%s%s"):format("Yaw", v95), {
            [1] = "Disabled", 
            [2] = "Backward", 
            [3] = "Static", 
            [4] = "3-Way", 
            [5] = "5-Way"
        }, function(v96)
            -- upvalues: l_mui_0 (ref)
            return {
                mode = l_mui_0.combo(v96, "Mode", {
                    [1] = "Static", 
                    [2] = "L & R"
                }), 
                offset = l_mui_0.slider(v96, "Offset", 0, -180, 180, 1, nil, "\194\176"), 
                offset_l = l_mui_0.slider(v96, "Offset Left", 0, -180, 180, 1, nil, "\194\176"), 
                offset_r = l_mui_0.slider(v96, "Offset Right", 0, -180, 180, 1, nil, "\194\176")
            };
        end);
        v61["anti aim"][("%s / %s"):format(v94, "yaw_modifier")] = l_mui_0.combo(v61.tabs["anti aim"].builder, ("%s%s"):format("Yaw Modifier", v95), {
            [1] = "Disabled", 
            [2] = "Center", 
            [3] = "Progressive", 
            [4] = "Delay", 
            [5] = "Offset", 
            [6] = "Random", 
            [7] = "Spin", 
            [8] = "3-Way", 
            [9] = "5-Way"
        }, function(v97)
            -- upvalues: l_mui_0 (ref)
            return {
                mode = l_mui_0.combo(v97, "Mode", {
                    [1] = "Static", 
                    [2] = "L & R"
                }), 
                tick = l_mui_0.slider(v97, "Delay Tick", 1, 1, 16, 1, nil, function(v98)
                    return ("%st"):format(v98);
                end), 
                offset = l_mui_0.slider(v97, "Offset", 0, -180, 180, 1), 
                offset_l = l_mui_0.slider(v97, "Offset Left", 0, -180, 180, 1), 
                offset_r = l_mui_0.slider(v97, "Offset Right", 0, -180, 180, 1)
            };
        end);
        v61["anti aim"][("%s / %s"):format(v94, "body_yaw")] = l_mui_0.switch(v61.tabs["anti aim"].builder, ("%s%s"):format("Body Yaw", v95), false, function(v99)
            -- upvalues: l_mui_0 (ref)
            return {
                mode = l_mui_0.combo(v99, "Mode", {
                    [1] = "Default", 
                    [2] = "Automatic"
                }), 
                limit_l = l_mui_0.slider(v99, "Limit Left", 60, -60, 60, 1, nil, "\194\176"), 
                limit_r = l_mui_0.slider(v99, "Limit Right", 60, -60, 60, 1, nil, "\194\176"), 
                options = l_mui_0.multi_combo(v99, "Options", {
                    [1] = "Avoid Overlap", 
                    [2] = "Jitter", 
                    [3] = "Randomize Jitter", 
                    [4] = "Anti Bruteforce"
                }), 
                delay = l_mui_0.slider(v99, "Jitter Delay", 0, 0, 100, 1, nil, function(v100)
                    if v100 == 0 then
                        return "NL";
                    else
                        return ("%s%%"):format(v100);
                    end;
                end), 
                freestanding = l_mui_0.combo(v99, "Freestanding", {
                    [1] = "Off", 
                    [2] = "Peek Fake", 
                    [3] = "Peek Real"
                })
            };
        end);
        v61["anti aim"][("%s / %s"):format(v94, "defensive_aa")] = l_mui_0.switch(v61.tabs["anti aim"].builder, ("%s%s"):format("!h<DE9B37FF>Defensive Options", v95), false, function(v101)
            -- upvalues: l_mui_0 (ref)
            return {
                lc = l_mui_0.combo(v101, "Lag Options", {
                    [1] = "Disabled", 
                    [2] = "Always On", 
                    [3] = "On Peek"
                }), 
                pitch = l_mui_0.combo(v101, "Pitch", {
                    [1] = "Disabled", 
                    [2] = "Offset", 
                    [3] = "Switch", 
                    [4] = "Random", 
                    [5] = "Automatic"
                }), 
                pitch_offset = l_mui_0.slider(v101, "Pitch Offset", 0, -90, 90, 1), 
                pitch_offset_1 = l_mui_0.slider(v101, "Pitch Offset #1", 0, -90, 90, 1), 
                pitch_offset_2 = l_mui_0.slider(v101, "Pitch Offset #2", 0, -90, 90, 1), 
                yaw = l_mui_0.combo(v101, "Yaw", {
                    [1] = "Disabled", 
                    [2] = "Neverlose", 
                    [3] = "Offset", 
                    [4] = "Spin", 
                    [5] = "Switch", 
                    [6] = "Random", 
                    [7] = "3-Way", 
                    [8] = "5-Way"
                }), 
                yaw_offset = l_mui_0.slider(v101, "Yaw Offset", 0, -180, 180, 1, nil, "\194\176"), 
                yaw_offset_1 = l_mui_0.slider(v101, "Yaw Offset #1", 0, -180, 180, 1, nil, "\194\176"), 
                yaw_offset_2 = l_mui_0.slider(v101, "Yaw Offset #2", 0, -180, 180, 1, nil, "\194\176"), 
                yaw_speed = l_mui_0.slider(v101, "Yaw Speed", 0, 0, 100, 1, nil, "%")
            };
        end);
        do
            local l_v94_0 = v94;
            v61["anti aim"][("%s / %s"):format(l_v94_0, "enable")]:set_callback(function(v103)
                -- upvalues: l_v94_0 (ref), v61 (ref), v29 (ref)
                local v104 = l_v94_0 == get_team(v61["anti aim"].condition:get()) and v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] ~= "Disabled";
                v61["anti aim"][("%s / %s"):format(l_v94_0, "pitch")]:visibility(v104 and v103:get());
                v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw")]:visibility(v104 and v103:get());
                v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw")]:set_callback(function(v105)
                    -- upvalues: v61 (ref), l_v94_0 (ref), v104 (ref), v103 (ref)
                    local l_gear_0 = v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw")].gear;
                    l_gear_0.mode:visibility(v105:get() ~= "Disabled");
                    l_gear_0.mode:set_callback(function(v107)
                        -- upvalues: l_gear_0 (ref), v105 (ref)
                        l_gear_0.offset:visibility(v105:get() ~= "Disabled" and v107:get() == "Static");
                        l_gear_0.offset_l:visibility(v105:get() ~= "Disabled" and v107:get() ~= "Static");
                        l_gear_0.offset_r:visibility(v105:get() ~= "Disabled" and v107:get() ~= "Static");
                    end, true);
                    v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw_modifier")]:visibility(v104 and v105:get() ~= "Disabled" and v103:get());
                    v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw_modifier")]:set_callback(function(v108)
                        -- upvalues: v61 (ref), l_v94_0 (ref), v105 (ref)
                        local l_gear_1 = v61["anti aim"][("%s / %s"):format(l_v94_0, "yaw_modifier")].gear;
                        l_gear_1.mode:visibility(v105:get() ~= "Disabled" and v108:get() ~= "Disabled" and v108:get() ~= "Delay");
                        l_gear_1.mode:set_callback(function(v110)
                            -- upvalues: l_gear_1 (ref), v105 (ref), v108 (ref)
                            l_gear_1.offset:visibility(v105:get() ~= "Disabled" and v108:get() ~= "Disabled" and v110:get() == "Static" and v108:get() ~= "Delay");
                            l_gear_1.tick:visibility(v105:get() ~= "Disabled" and v108:get() == "Delay");
                            l_gear_1.offset_l:visibility(v105:get() ~= "Disabled" and v108:get() ~= "Disabled" and (not (v110:get() == "Static") or v108:get() == "Delay"));
                            l_gear_1.offset_r:visibility(v105:get() ~= "Disabled" and v108:get() ~= "Disabled" and (not (v110:get() == "Static") or v108:get() == "Delay"));
                        end, true);
                    end, true);
                end, true);
                v61["anti aim"][("%s / %s"):format(l_v94_0, "body_yaw")]:visibility(v104 and v103:get());
                v61["anti aim"][("%s / %s"):format(l_v94_0, "body_yaw")]:set_callback(function(v111)
                    -- upvalues: v61 (ref), l_v94_0 (ref)
                    local l_gear_2 = v61["anti aim"][("%s / %s"):format(l_v94_0, "body_yaw")].gear;
                    l_gear_2.mode:visibility(v111:get());
                    l_gear_2.mode:set_callback(function(v113)
                        -- upvalues: l_gear_2 (ref), v111 (ref)
                        l_gear_2.limit_l:visibility(v111:get() and v113:get() == "Default");
                        l_gear_2.limit_r:visibility(v111:get() and v113:get() == "Default");
                    end, true);
                    l_gear_2.options:visibility(v111:get());
                    l_gear_2.options:set_callback(function(v114)
                        -- upvalues: l_gear_2 (ref), v111 (ref)
                        l_gear_2.delay:visibility(v111:get() and v114:get("Jitter"));
                    end, true);
                    l_gear_2.freestanding:visibility(v111:get());
                end, true);
                v61["anti aim"][("%s / %s"):format(l_v94_0, "defensive_aa")]:visibility(v104 and v103:get());
                v61["anti aim"][("%s / %s"):format(l_v94_0, "defensive_aa")]:set_callback(function(v115)
                    -- upvalues: v61 (ref), l_v94_0 (ref)
                    local l_gear_3 = v61["anti aim"][("%s / %s"):format(l_v94_0, "defensive_aa")].gear;
                    l_gear_3.lc:visibility(v115:get());
                    l_gear_3.pitch:visibility(v115:get());
                    l_gear_3.pitch:set_callback(function(v117)
                        -- upvalues: l_gear_3 (ref), v115 (ref)
                        l_gear_3.pitch_offset:visibility(v115:get() and (v117:get() == "Offset" or v117:get() == "Random"));
                        l_gear_3.pitch_offset_1:visibility(v115:get() and v117:get() == "Switch");
                        l_gear_3.pitch_offset_2:visibility(v115:get() and v117:get() == "Switch");
                    end, true);
                    l_gear_3.yaw:visibility(v115:get());
                    l_gear_3.yaw:set_callback(function(v118)
                        -- upvalues: l_gear_3 (ref), v115 (ref)
                        l_gear_3.yaw_offset:visibility(v115:get() and (v118:get() == "Offset" or not (v118:get() ~= "Random") or not (v118:get() ~= "Spin") or not (v118:get() ~= "3-Way") or v118:get() == "5-Way"));
                        l_gear_3.yaw_offset_1:visibility(v115:get() and v118:get() == "Switch");
                        l_gear_3.yaw_offset_2:visibility(v115:get() and v118:get() == "Switch");
                        l_gear_3.yaw_speed:visibility(v115:get() and v118:get() == "Spin");
                    end, true);
                end, true);
            end, true);
        end;
    end;
    v87 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
    local v135 = {
        encode = function(v119)
            -- upvalues: v87 (ref)
            return (v119:gsub(".", function(v120)
                local v121 = "";
                local v122 = v120:byte();
                for v123 = 8, 1, -1 do
                    v121 = v121 .. (v122 % 2 ^ v123 - v122 % 2 ^ (v123 - 1) > 0 and "1" or "0");
                end;
                return v121;
            end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(v124)
                -- upvalues: v87 (ref)
                if #v124 < 6 then
                    return "";
                else
                    local v125 = 0;
                    for v126 = 1, 6 do
                        v125 = v125 + (v124:sub(v126, v126) == "1" and 2 ^ (6 - v126) or 0);
                    end;
                    return v87:sub(v125 + 1, v125 + 1);
                end;
            end) .. ({
                [1] = "", 
                [2] = "", 
                [3] = ""
            })[#v119 % 3 + 1];
        end, 
        decode = function(v127)
            -- upvalues: v87 (ref)
            return (string.gsub(v127, "[^" .. v87 .. "]", ""):gsub(".", function(v128)
                -- upvalues: v87 (ref)
                if v128 == "" then
                    return "";
                else
                    local v129 = "";
                    local v130 = v87:find(v128) - 1;
                    for v131 = 6, 1, -1 do
                        v129 = v129 .. (v130 % 2 ^ v131 - v130 % 2 ^ (v131 - 1) > 0 and "1" or "0");
                    end;
                    return v129;
                end;
            end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(v132)
                if #v132 ~= 8 then
                    return "";
                else
                    local v133 = 0;
                    for v134 = 1, 8 do
                        v133 = v133 + (v132:sub(v134, v134) == "1" and 2 ^ (8 - v134) or 0);
                    end;
                    return string.char(v133);
                end;
            end));
        end
    };
    local v143 = {
        data = l_serenity_recode_0.configs or {}, 
        list = {
            data = {}, 
            name = {}
        }, 
        defaults = {
            Default = "            W1siY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJJbiBBaXIgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJJbiBBaXIgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIFQgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiSW4gQWlyIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkluIEFpciAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkluIEFpciAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkluIEFpciAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiSW4gQWlyIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiYW5pbWF0aW9ucyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJhbmltYXRpb25zIiwiU3RhdGljIixudWxsLG51bGwsWyJhaXIiLCJhbmltYXRpb25zIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImFuaW1hdGlvbnMiLDAuMCxudWxsLG51bGwsWyJsZWFuIiwiYW5pbWF0aW9ucyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiYW5pbWF0aW9ucyIsW10sbnVsbCxudWxsLFsic2VsZWN0IiwiYW5pbWF0aW9ucyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImFuaW1hdGlvbnMiLCJTdGF0aWMiLG51bGwsbnVsbCxbImxhbmRpbmciLCJhbmltYXRpb25zIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8gZW5hYmxlIix0cnVlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIHBpdGNoIiwiRG93biJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3IiwiQmFja3dhcmQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkFpciBDcm91Y2ggLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3IiwiTCAmIFIiLG51bGwsbnVsbCxbIm1vZGUiLCJBaXIgQ3JvdWNoIC8gTiAvIHlhdyIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3IiwtMjMuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkFpciBDcm91Y2ggLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3Iiw0Ni4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQWlyIENyb3VjaCAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBlbmFibGUiLHRydWVdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBwaXRjaCIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkdsb2JhbCAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkdsb2JhbCAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJHbG9iYWwgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkdsb2JhbCAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkdsb2JhbCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8geWF3X21vZGlmaWVyIiwxLjAsbnVsbCxudWxsLFsidGljayIsIkdsb2JhbCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiR2xvYmFsIC8gTiAvIHlhd19tb2RpZmllciIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gYm9keV95YXciLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJHbG9iYWwgLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBib2R5X3lhdyIsIk9mZiIsbnVsbCxudWxsLFsiZnJlZXN0YW5kaW5nIiwiR2xvYmFsIC8gTiAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9sIiwiR2xvYmFsIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiR2xvYmFsIC8gTiAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9yIiwiR2xvYmFsIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gYm9keV95YXciLFtdLG51bGwsbnVsbCxbIm9wdGlvbnMiLCJHbG9iYWwgLyBOIC8gYm9keV95YXciLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsibGMiLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0IiwiR2xvYmFsIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInlhdyIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzIiLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJHbG9iYWwgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiQWlyIENyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJBaXIgQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJBaXIgQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiQWlyIENyb3VjaCAvIENUIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsW10sbnVsbCxudWxsLFsib3B0aW9ucyIsIkFpciBDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJsYyIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8yIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQWlyIENyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMSIsIkFpciBDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyBlbmFibGUiLHRydWVdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8geWF3IiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkdsb2JhbCAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8geWF3IiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiR2xvYmFsIC8gQ1QgLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiR2xvYmFsIC8gQ1QgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkdsb2JhbCAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8geWF3X21vZGlmaWVyIiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkdsb2JhbCAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiR2xvYmFsIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJHbG9iYWwgLyBDVCAvIHlhd19tb2RpZmllciIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJsYyIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0IiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInlhdyIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8yIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzIiLCJHbG9iYWwgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMSIsIkdsb2JhbCAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZW5hYmxlIixmYWxzZV0sWyJjb21ibyIsImFudGkgYWltIiwiY29uZGl0aW9uIiwiQWlyIENyb3VjaCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJHbG9iYWwgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJHbG9iYWwgLyBUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiR2xvYmFsIC8gVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJHbG9iYWwgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJHbG9iYWwgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJHbG9iYWwgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkdsb2JhbCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiR2xvYmFsIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkdsb2JhbCAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkdsb2JhbCAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkdsb2JhbCAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkdsb2JhbCAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiR2xvYmFsIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbImxpc3QiLCJhbnRpIGFpbSIsInR5cGUiLDIuMF0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gcGl0Y2giLCJEb3duIl0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8geWF3IiwiQmFja3dhcmQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTdGFuZGluZyAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8geWF3IiwiTCAmIFIiLG51bGwsbnVsbCxbIm1vZGUiLCJTdGFuZGluZyAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyB5YXciLC0xNi4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiU3RhbmRpbmcgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIHlhdyIsNDUuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIlN0YW5kaW5nIC8gTiAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIHlhd19tb2RpZmllciIsLTE3LjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiU3RhbmRpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiU3RhbmRpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJTdGFuZGluZyAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJTdGFuZGluZyAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiU3RhbmRpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGJvZHlfeWF3Iix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gYm9keV95YXciLDAuMCxudWxsLG51bGwsWyJkZWxheSIsIlN0YW5kaW5nIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBib2R5X3lhdyIsIk9mZiIsbnVsbCxudWxsLFsiZnJlZXN0YW5kaW5nIiwiU3RhbmRpbmcgLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIlN0YW5kaW5nIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBib2R5X3lhdyIsIkRlZmF1bHQiLG51bGwsbnVsbCxbIm1vZGUiLCJTdGFuZGluZyAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9yIiwiU3RhbmRpbmcgLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGJvZHlfeWF3IixbIkppdHRlciJdLG51bGwsbnVsbCxbIm9wdGlvbnMiLCJTdGFuZGluZyAvIE4gLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJPbiBQZWVrIixudWxsLG51bGwsWyJsYyIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJBdXRvbWF0aWMiLG51bGwsbnVsbCxbInBpdGNoIiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMSIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMiIsIlN0YW5kaW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJTdGFuZGluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTdGFuZGluZyAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJTdGFuZGluZyAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiU3RhbmRpbmcgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJTdGFuZGluZyAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTdGFuZGluZyAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJTdGFuZGluZyAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIlN0YW5kaW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIlN0YW5kaW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiU3RhbmRpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gZW5hYmxlIixmYWxzZV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiU3RhbmRpbmcgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIlN0YW5kaW5nIC8gVCAvIHlhdyIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiU3RhbmRpbmcgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiU3RhbmRpbmcgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJTdGFuZGluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJTdGFuZGluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiU3RhbmRpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJTdGFuZGluZyAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJTdGFuZGluZyAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiU3RhbmRpbmcgLyBUIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIFQgLyBib2R5X3lhdyIsW10sbnVsbCxudWxsLFsib3B0aW9ucyIsIlN0YW5kaW5nIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJsYyIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8yIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiU3RhbmRpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMSIsIlN0YW5kaW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIHBpdGNoIiwiRG93biJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyB5YXciLCJCYWNrd2FyZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJNb3ZpbmcgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyB5YXciLCJMICYgUiIsbnVsbCxudWxsLFsibW9kZSIsIk1vdmluZyAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8geWF3IiwtMTguMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIk1vdmluZyAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIHlhdyIsNDEuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIk1vdmluZyAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIHlhd19tb2RpZmllciIsLTE3LjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiTW92aW5nIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJNb3ZpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiTW92aW5nIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJNb3ZpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJNb3ZpbmcgLyBOIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiTW92aW5nIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIk1vdmluZyAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGJvZHlfeWF3IixbIkppdHRlciJdLG51bGwsbnVsbCxbIm9wdGlvbnMiLCJNb3ZpbmcgLyBOIC8gYm9keV95YXciLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIk9uIFBlZWsiLG51bGwsbnVsbCxbImxjIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwiQXV0b21hdGljIixudWxsLG51bGwsWyJwaXRjaCIsIk1vdmluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsLTIxLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiTW92aW5nIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsibGMiLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJwaXRjaCIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMSIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldCIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19zcGVlZCIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQWlyIENyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJBaXIgQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyBib2R5X3lhdyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkFpciBDcm91Y2ggLyBUIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiQWlyIENyb3VjaCAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQWlyIENyb3VjaCAvIFQgLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQWlyIENyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwxLjAsbnVsbCxudWxsLFsidGljayIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJBaXIgQ3JvdWNoIC8gVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkFpciBDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQWlyIENyb3VjaCAvIFQgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJBaXIgQ3JvdWNoIC8gVCAvIHlhdyIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJBaXIgQ3JvdWNoIC8gVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQWlyIENyb3VjaCAvIFQgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIFQgLyBwaXRjaCIsIkRpc2FibGVkIl0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBUIC8gZW5hYmxlIixmYWxzZV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3IiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3IiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiQWlyIENyb3VjaCAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJBaXIgQ3JvdWNoIC8gQ1QgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIENUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkFsd2F5cyBPbiIsbnVsbCxudWxsLFsibGMiLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJwaXRjaCIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwxODAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0IiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwtMjQuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLDY1LjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzIiLCJBaXIgQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMSIsIkFpciBDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsIk9mZiIsbnVsbCxudWxsLFsiZnJlZXN0YW5kaW5nIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJBaXIgQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkFpciBDcm91Y2ggLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9yIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsWyJKaXR0ZXIiXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQWlyIENyb3VjaCAvIE4gLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwtMTQuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJBaXIgQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJBaXIgQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkFpciBDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkFpciBDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiQWlyIENyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkluIEFpciAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiSW4gQWlyIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gQ1QgLyBib2R5X3lhdyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkdsb2JhbCAvIENUIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIENUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiR2xvYmFsIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiR2xvYmFsIC8gQ1QgLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJjb21ibyIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIHBpdGNoIiwiRGlzYWJsZWQiXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkdsb2JhbCAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkdsb2JhbCAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJHbG9iYWwgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiR2xvYmFsIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJtYW51YWwiLCJBdCBUYXJnZXQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJtYW51YWwiLDAuMCxudWxsLG51bGwsWyJtYWduZXQiLCJtYW51YWwiLCJob3RrZXkiXV0sWyJjb21ibyIsImFudGkgYWltIiwibWFudWFsIixmYWxzZSxudWxsLG51bGwsWyJzdGF0aWMiLCJtYW51YWwiLCJzd2l0Y2giXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8gYm9keV95YXciLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsIk9mZiIsbnVsbCxudWxsLFsiZnJlZXN0YW5kaW5nIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJJbiBBaXIgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIENUIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9yIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBib2R5X3lhdyIsW10sbnVsbCxudWxsLFsib3B0aW9ucyIsIkluIEFpciAvIENUIC8gYm9keV95YXciLCJzZWxlY3RhYmxlIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwic2FmZSIsW11dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJmcmVlc3RhbmRpbmciLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiZnJlZXN0YW5kaW5nIixmYWxzZSxudWxsLG51bGwsWyJCRiIsImZyZWVzdGFuZGluZyIsInN3aXRjaCJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiZnJlZXN0YW5kaW5nIixbXSxudWxsLG51bGwsWyJkaXNhYmxlcnMiLCJmcmVlc3RhbmRpbmciLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJmcmVlc3RhbmRpbmciLGZhbHNlLG51bGwsbnVsbCxbIkRZTSIsImZyZWVzdGFuZGluZyIsInN3aXRjaCJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInR3ZWFrcyIsW11dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwidHdlYWtzIiwiQWx3YXlzIE9uIixudWxsLG51bGwsWyJlZGdlX3lhdyIsInR3ZWFrcyIsImNvbWJvIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwidHdlYWtzIixmYWxzZSxudWxsLG51bGwsWyJpbl9haXIiLCJ0d2Vha3MiLCJzd2l0Y2giXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJ0d2Vha3MiLDAuMCxudWxsLG51bGwsWyJkZWxheSIsInR3ZWFrcyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInR3ZWFrcyIsW10sbnVsbCxudWxsLFsid2VhcG9uIiwidHdlYWtzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nIC8gQ1QgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiU3RhbmRpbmcgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIlN0YW5kaW5nIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIlN0YW5kaW5nIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIlN0YW5kaW5nIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZyAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIlN0YW5kaW5nIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcgLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiU3RhbmRpbmcgLyBDVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIHBpdGNoIiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJNb3ZpbmcgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIk1vdmluZyAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIk1vdmluZyAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJNb3ZpbmcgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJNb3ZpbmcgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIk1vdmluZyAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiTW92aW5nIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBib2R5X3lhdyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIk1vdmluZyAvIENUIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiTW92aW5nIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiTW92aW5nIC8gQ1QgLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMiIsIk1vdmluZyAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiTW92aW5nIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJNb3ZpbmcgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJNb3ZpbmcgLyBUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiTW92aW5nIC8gVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJNb3ZpbmcgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJNb3ZpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJNb3ZpbmcgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIk1vdmluZyAvIFQgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiTW92aW5nIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIk1vdmluZyAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIk1vdmluZyAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIk1vdmluZyAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIk1vdmluZyAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiTW92aW5nIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIk1vdmluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIk1vdmluZyAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJNb3ZpbmcgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiTW92aW5nIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIHBpdGNoIiwiRG93biJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLCJCYWNrd2FyZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTbG93IE1vdmUgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLCJMICYgUiIsbnVsbCxudWxsLFsibW9kZSIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8geWF3IiwtMzAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIHlhdyIsNDIuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIlNsb3cgTW92ZSAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsIlByb2dyZXNzaXZlIl0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsLTE3LjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiU2xvdyBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJTbG93IE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiU2xvdyBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJTbG93IE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJTbG93IE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBib2R5X3lhdyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBib2R5X3lhdyIsMTUuMCxudWxsLG51bGwsWyJkZWxheSIsIlNsb3cgTW92ZSAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJTbG93IE1vdmUgLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJTbG93IE1vdmUgLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBib2R5X3lhdyIsIkRlZmF1bHQiLG51bGwsbnVsbCxbIm1vZGUiLCJTbG93IE1vdmUgLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJTbG93IE1vdmUgLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBib2R5X3lhdyIsWyJKaXR0ZXIiXSxudWxsLG51bGwsWyJvcHRpb25zIiwiU2xvdyBNb3ZlIC8gTiAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIlNsb3cgTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiU2xvdyBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIHBpdGNoIiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTbG93IE1vdmUgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIlNsb3cgTW92ZSAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIlNsb3cgTW92ZSAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJTbG93IE1vdmUgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTbG93IE1vdmUgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIlNsb3cgTW92ZSAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiU2xvdyBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIlNsb3cgTW92ZSAvIENUIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiU2xvdyBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiU2xvdyBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMiIsIlNsb3cgTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiU2xvdyBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTbG93IE1vdmUgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJTbG93IE1vdmUgLyBUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiU2xvdyBNb3ZlIC8gVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJTbG93IE1vdmUgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJTbG93IE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJTbG93IE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIlNsb3cgTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiU2xvdyBNb3ZlIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIlNsb3cgTW92ZSAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIlNsb3cgTW92ZSAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIlNsb3cgTW92ZSAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIlNsb3cgTW92ZSAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiU2xvdyBNb3ZlIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIlNsb3cgTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3cgTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93IE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiU2xvdyBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIHBpdGNoIiwiRG93biJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyB5YXciLCJCYWNrd2FyZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyB5YXciLCJMICYgUiIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBOIC8geWF3IiwtMjUuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIHlhdyIsNDYuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkNyb3VjaCAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsLTE3LjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiQ3JvdWNoIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggLyBOIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBib2R5X3lhdyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBib2R5X3lhdyIsMTguMCxudWxsLG51bGwsWyJkZWxheSIsIkNyb3VjaCAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJDcm91Y2ggLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJDcm91Y2ggLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBib2R5X3lhdyIsIkRlZmF1bHQiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJDcm91Y2ggLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBib2R5X3lhdyIsWyJKaXR0ZXIiXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQ3JvdWNoIC8gTiAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJPbiBQZWVrIixudWxsLG51bGwsWyJsYyIsIkNyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkF1dG9tYXRpYyIsbnVsbCxudWxsLFsicGl0Y2giLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLDE0NS4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsLTI4LjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiQ3JvdWNoIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIHBpdGNoIiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJDcm91Y2ggLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiQ3JvdWNoIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IiwiT2ZmIixudWxsLG51bGwsWyJmcmVlc3RhbmRpbmciLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkNyb3VjaCAvIENUIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X3IiLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQ3JvdWNoIC8gQ1QgLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXQiLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMiIsIkNyb3VjaCAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiQ3JvdWNoIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggLyBUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiQ3JvdWNoIC8gVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJDcm91Y2ggLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJDcm91Y2ggLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCAvIFQgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiQ3JvdWNoIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkNyb3VjaCAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkNyb3VjaCAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCAvIFQgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkNyb3VjaCAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQ3JvdWNoIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkNyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiQ3JvdWNoIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZW5hYmxlIix0cnVlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBwaXRjaCIsIkRvd24iXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXciLCJCYWNrd2FyZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXciLCJMICYgUiIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhdyIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhdyIsLTI1LjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8geWF3Iiw0Ni4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQ3JvdWNoIE1vdmUgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwtMjQuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8geWF3X21vZGlmaWVyIiwxLjAsbnVsbCxudWxsLFsidGljayIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCBNb3ZlIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggTW92ZSAvIE4gLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gYm9keV95YXciLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsMTguMCxudWxsLG51bGwsWyJkZWxheSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsIk9mZiIsbnVsbCxudWxsLFsiZnJlZXN0YW5kaW5nIiwiQ3JvdWNoIE1vdmUgLyBOIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkNyb3VjaCBNb3ZlIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsIkRlZmF1bHQiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsNjAuMCxudWxsLG51bGwsWyJsaW1pdF9yIiwiQ3JvdWNoIE1vdmUgLyBOIC8gYm9keV95YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGJvZHlfeWF3IixbIkppdHRlciJdLG51bGwsbnVsbCxbIm9wdGlvbnMiLCJDcm91Y2ggTW92ZSAvIE4gLyBib2R5X3lhdyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIk9uIFBlZWsiLG51bGwsbnVsbCxbImxjIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkF1dG9tYXRpYyIsbnVsbCxudWxsLFsicGl0Y2giLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwxNDUuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0IiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsLTMxLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3IiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMiIsIkNyb3VjaCBNb3ZlIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJDcm91Y2ggTW92ZSAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBlbmFibGUiLGZhbHNlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXciLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXciLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3IiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIHlhdyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJDcm91Y2ggTW92ZSAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIHlhd19tb2RpZmllciIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGJvZHlfeWF3IixbXSxudWxsLG51bGwsWyJvcHRpb25zIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsZmFsc2VdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbImxjIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzEiLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0IiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0XzIiLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X3NwZWVkIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8xIiwiQ3JvdWNoIE1vdmUgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZW5hYmxlIixmYWxzZV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhdyIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9yIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJDcm91Y2ggTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJDcm91Y2ggTW92ZSAvIFQgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiQ3JvdWNoIE1vdmUgLyBUIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3IiwwLjAsbnVsbCxudWxsLFsiZGVsYXkiLCJDcm91Y2ggTW92ZSAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3IiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3Iiw2MC4wLG51bGwsbnVsbCxbImxpbWl0X2wiLCJDcm91Y2ggTW92ZSAvIFQgLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gYm9keV95YXciLCJEZWZhdWx0IixudWxsLG51bGwsWyJtb2RlIiwiQ3JvdWNoIE1vdmUgLyBUIC8gYm9keV95YXciLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIFQgLyBib2R5X3lhdyIsW10sbnVsbCxudWxsLFsib3B0aW9ucyIsIkNyb3VjaCBNb3ZlIC8gVCAvIGJvZHlfeWF3Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJsYyIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8xIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldF8yIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiQ3JvdWNoIE1vdmUgLyBUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2ggTW92ZSAvIFQgLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXRfMSIsIkNyb3VjaCBNb3ZlIC8gVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIHBpdGNoIiwiRG93biJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyB5YXciLCJCYWNrd2FyZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJJbiBBaXIgLyBOIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyB5YXciLCJMICYgUiIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIE4gLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8geWF3IiwtMjEuMCxudWxsLG51bGwsWyJvZmZzZXRfbCIsIkluIEFpciAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIHlhdyIsNDIuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkluIEFpciAvIE4gLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIHlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIHlhd19tb2RpZmllciIsLTEwLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiSW4gQWlyIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJJbiBBaXIgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyB5YXdfbW9kaWZpZXIiLDEuMCxudWxsLG51bGwsWyJ0aWNrIiwiSW4gQWlyIC8gTiAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJJbiBBaXIgLyBOIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJJbiBBaXIgLyBOIC8geWF3X21vZGlmaWVyIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsMC4wLG51bGwsbnVsbCxbImRlbGF5IiwiSW4gQWlyIC8gTiAvIGJvZHlfeWF3Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gYm9keV95YXciLCJPZmYiLG51bGwsbnVsbCxbImZyZWVzdGFuZGluZyIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfbCIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGJvZHlfeWF3IiwiRGVmYXVsdCIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gYm9keV95YXciLDYwLjAsbnVsbCxudWxsLFsibGltaXRfciIsIkluIEFpciAvIE4gLyBib2R5X3lhdyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGJvZHlfeWF3IixbIkppdHRlciJdLG51bGwsbnVsbCxbIm9wdGlvbnMiLCJJbiBBaXIgLyBOIC8gYm9keV95YXciLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGRlZmVuc2l2ZV9hYSIsIkFsd2F5cyBPbiIsbnVsbCxudWxsLFsibGMiLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsicGl0Y2giLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfb2Zmc2V0IiwiSW4gQWlyIC8gTiAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMSIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9vZmZzZXQiLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwiRGlzYWJsZWQiLG51bGwsbnVsbCxbInlhdyIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gTiAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIE4gLyBkZWZlbnNpdmVfYWEiLDAuMCxudWxsLG51bGwsWyJ5YXdfc3BlZWQiLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzIiLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJJbiBBaXIgLyBOIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGVuYWJsZSIsZmFsc2VdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8gcGl0Y2giLCJEaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8geWF3IiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkluIEFpciAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8geWF3IiwiU3RhdGljIixudWxsLG51bGwsWyJtb2RlIiwiSW4gQWlyIC8gQ1QgLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiSW4gQWlyIC8gQ1QgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkluIEFpciAvIENUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8geWF3X21vZGlmaWVyIiwiRGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkluIEFpciAvIENUIC8geWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8geWF3X21vZGlmaWVyIiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X3IiLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsMS4wLG51bGwsbnVsbCxbInRpY2siLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbIm9mZnNldF9sIiwiSW4gQWlyIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyB5YXdfbW9kaWZpZXIiLCJTdGF0aWMiLG51bGwsbnVsbCxbIm1vZGUiLCJJbiBBaXIgLyBDVCAvIHlhd19tb2RpZmllciIsImNvbWJvIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsInRlYW0iLCJDb3VudGVyLVRlcnJvcmlzdHMiXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJEaXNhYmxlZCIsbnVsbCxudWxsLFsibGMiLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJwaXRjaCIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsieWF3X29mZnNldCIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMSIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldCIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsIkRpc2FibGVkIixudWxsLG51bGwsWyJ5YXciLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19vZmZzZXRfMiIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInlhd19zcGVlZCIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsMC4wLG51bGwsbnVsbCxbInBpdGNoX29mZnNldF8yIiwiSW4gQWlyIC8gQ1QgLyBkZWZlbnNpdmVfYWEiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkluIEFpciAvIENUIC8gZGVmZW5zaXZlX2FhIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfb2Zmc2V0XzEiLCJJbiBBaXIgLyBDVCAvIGRlZmVuc2l2ZV9hYSIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIGVuYWJsZSIsZmFsc2VdLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyBwaXRjaCIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIHlhdyIsIkRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIHlhdyIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsIkluIEFpciAvIFQgLyB5YXciLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiSW4gQWlyIC8gVCAvIHlhdyIsIlN0YXRpYyIsbnVsbCxudWxsLFsibW9kZSIsIkluIEFpciAvIFQgLyB5YXciLCJjb21ibyJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJJbiBBaXIgLyBUIC8geWF3IiwwLjAsbnVsbCxudWxsLFsib2Zmc2V0X2wiLCJJbiBBaXIgLyBUIC8geWF3Iiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIkluIEFpciAvIFQgLyB5YXciLDAuMCxudWxsLG51bGwsWyJvZmZzZXRfciIsIkluIEFpciAvIFQgLyB5YXciLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImNvbGxpc2lvbiIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjb2xsaXNpb24iLDguMCxudWxsLG51bGwsWyJkaXN0YW5jZSIsImNvbGxpc2lvbiIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiaW1wcm92ZW1lbnQiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibGFnX2V4cGxvaXQiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibGFnX2V4cGxvaXQiLDE4LjAsbnVsbCxudWxsLFsidGljayIsImxhZ19leHBsb2l0Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjbGFudGFnIix0cnVlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibG9ncyIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImxvZ3MiLDAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJsb2dzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJsb2dzIixbIkNvbnNvbGUiLCJUb3AgTGVmdCJdLG51bGwsbnVsbCxbImV4dGVuZGVkIiwibG9ncyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImxvZ3MiLCJcdTAwMDdGRkZGRkYwMDNcdTAwMDdERUZBVUxUSGl0Iix7Ilx1MDAwN0ZGRkZGRjAwMVx1MDAwN0RFRkFVTFRHbG93IjpbIkZGRkZGRjdEIl0sIlx1MDAwN0ZGRkZGRjAwMlx1MDAwN0RFRkFVTFRNaXNzIjpbIkVFMTMxNEZGIl0sIlx1MDAwN0ZGRkZGRjAwM1x1MDAwN0RFRkFVTFRIaXQiOlsiODdCMjBFRkYiXX0sWyJjb2xvcnMiLCJsb2dzIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJsb2dzIiwiRGVmYXVsdCIsbnVsbCxudWxsLFsic3R5bGUiLCJsb2dzIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImxvZ3MiLFsiU2NyZWVuIiwiQ29uc29sZSIsIlRvcCBMZWZ0Il0sbnVsbCxudWxsLFsic2VsZWN0IiwibG9ncyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInZpZXdtb2RlbF9jaGFuZ2VyIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInZpZXdtb2RlbF9jaGFuZ2VyIiwyNS4wLG51bGwsbnVsbCxbIngiLCJ2aWV3bW9kZWxfY2hhbmdlciIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwidmlld21vZGVsX2NoYW5nZXIiLDAuMCxudWxsLG51bGwsWyJ5Iiwidmlld21vZGVsX2NoYW5nZXIiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInZpZXdtb2RlbF9jaGFuZ2VyIiwtMTUuMCxudWxsLG51bGwsWyJ6Iiwidmlld21vZGVsX2NoYW5nZXIiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInZpZXdtb2RlbF9jaGFuZ2VyIiw2ODAuMCxudWxsLG51bGwsWyJGT1YiLCJ2aWV3bW9kZWxfY2hhbmdlciIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiYXNwZWN0X3JhdGlvIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImFzcGVjdF9yYXRpbyIsMTMzLjAsbnVsbCxudWxsLFsib2Zmc2V0IiwiYXNwZWN0X3JhdGlvIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJkYW1hZ2UiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwiZGFtYWdlIiwiRkZGRkZGRkYiLG51bGwsbnVsbCxbImNvbG9yIiwiZGFtYWdlIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJkYW1hZ2UiLDUyOS4wLG51bGwsbnVsbCxbInkiLCJkYW1hZ2UiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImRhbWFnZSIsOTYwLjAsbnVsbCxudWxsLFsieCIsImRhbWFnZSIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiZGFtYWdlIixmYWxzZSxudWxsLG51bGwsWyJzaG93IiwiZGFtYWdlIiwic3dpdGNoIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJhdXRvX21fdW5tIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImF1dG9fbV91bm0iLCJNdXRlIixudWxsLG51bGwsWyJtb2RlIiwiYXV0b19tX3VubSIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJzY29wZSIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInNjb3BlIiw1LjAsbnVsbCxudWxsLFsic3RhcnQiLCJzY29wZSIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2NvcGUiLFtdLG51bGwsbnVsbCxbImhpZGRlbiIsInNjb3BlIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2NvcGUiLCI5ODk4OThGRiIsbnVsbCxudWxsLFsiY29sb3IiLCJzY29wZSIsImNvbG9yX3BpY2tlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2NvcGUiLDEyMC4wLG51bGwsbnVsbCxbImxlbmd0aCIsInNjb3BlIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJzY29wZSIsZmFsc2UsbnVsbCxudWxsLFsiaW52ZXJ0ZXIiLCJzY29wZSIsInN3aXRjaCJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwibm9fZmFsbCIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJuYWRlX3ByZWRpY3Rpb24iLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibmFkZV9wcmVkaWN0aW9uIiwiRkZGRkZGRkYiLG51bGwsbnVsbCxbImNvbG9yIiwibmFkZV9wcmVkaWN0aW9uIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJhcnJvd3MiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwiYXJyb3dzIiwiU2ltcGxlIixudWxsLG51bGwsWyJzdHlsZSIsImFycm93cyIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJhcnJvd3MiLCJGRkZGRkZGRiIsbnVsbCxudWxsLFsiY29sb3IiLCJhcnJvd3MiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImFycm93cyIsNTAuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJhcnJvd3MiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImFycm93cyIsIkFsd2F5cyBPbiIsbnVsbCxudWxsLFsiZGlzcGxheSIsImFycm93cyIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJhcnJvd3MiLCJNYW51YWwiLHsiSW52ZXRlZCI6WyJGRkZGRkZGRiJdLCJNYW51YWwiOlsiRkZGRkZGRkYiXX0sWyJjb2xvcnMiLCJhcnJvd3MiLCJjb2xvcl9waWNrZXIiXV0sWyJjb21ibyIsInNldHRpbmdzIiwid2F0ZXJtYXJrIiwiU2ltcGxlIl0sWyJjb21ibyIsInNldHRpbmdzIiwid2F0ZXJtYXJrIiwiRDJBNkZGRkYiLG51bGwsbnVsbCxbImNvbG9yIiwid2F0ZXJtYXJrIiwiY29sb3JfcGlja2VyIl1dLFsiY29tYm8iLCJzZXR0aW5ncyIsIndhdGVybWFyayIsIkZ1bGwiLG51bGwsbnVsbCxbInR5cGUiLCJ3YXRlcm1hcmsiLCJjb21ibyJdXSxbImNvbWJvIiwic2V0dGluZ3MiLCJ3YXRlcm1hcmsiLCJCZWxvdyIsbnVsbCxudWxsLFsicG9zaXRpb24iLCJ3YXRlcm1hcmsiLCJjb21ibyJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiZHJvcF9ncmVuYWRlcyIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJkcm9wX2dyZW5hZGVzIiwwLjAsbnVsbCxudWxsLFsiYmluZCIsImRyb3BfZ3JlbmFkZXMiLCJob3RrZXkiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImRyb3BfZ3JlbmFkZXMiLFtdLG51bGwsbnVsbCxbImRpc2NhcmQiLCJkcm9wX2dyZW5hZGVzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwicmFkaXVzIix0cnVlXSxbInN3aXRjaCIsInNldHRpbmdzIiwicmFkaXVzIiwiMTBGRjEwRkYiLG51bGwsbnVsbCxbImNvbG9yX3R2IiwicmFkaXVzIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJyYWRpdXMiLCIxMDEwRkY4MCIsbnVsbCxudWxsLFsiY29sb3Jfc2UiLCJyYWRpdXMiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInJhZGl1cyIsWyJTbW9rZSIsIk1vbG90b3YiXSxudWxsLG51bGwsWyJkaXNwbGF5IiwicmFkaXVzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwicmFkaXVzIiwiRkYxMDEwRkYiLG51bGwsbnVsbCxbImNvbG9yX2V2IiwicmFkaXVzIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJuYWRlX3dhcm5pbmciLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibmFkZV93YXJuaW5nIiwiRkZGRkZGRkYiLG51bGwsbnVsbCxbImNvbG9yIiwibmFkZV93YXJuaW5nIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJza2VldCIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJza2VldCIsMC4wLG51bGwsbnVsbCxbIm9mZnNldCIsInNrZWV0Iiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJza2VldCIsW10sbnVsbCxudWxsLFsiZGlzcGxheSIsInNrZWV0Iiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2tlZXQiLGZhbHNlLG51bGwsbnVsbCxbInNwZWN0YXRvcnMiLCJza2VldCIsInN3aXRjaCJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwidHJhc2h0YWxrIix0cnVlXSxbInN3aXRjaCIsInNldHRpbmdzIiwidHJhc2h0YWxrIiwxMy4wLG51bGwsbnVsbCxbImRlbGF5IiwidHJhc2h0YWxrIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ0cmFzaHRhbGsiLCJFbmdsaXNoIixudWxsLG51bGwsWyJsYW5ndWFnZSIsInRyYXNodGFsayIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLCJEZWZhdWx0IixudWxsLG51bGwsWyJzdHlsZSIsIndpZGdldHMiLCJjb21ibyJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsODg1LjAsbnVsbCxudWxsLFsieF92Iiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsIjQ4NDg0OEZGIixudWxsLG51bGwsWyJiYWNrZ3JvdW5kIiwid2lkZ2V0cyIsImNvbG9yX3BpY2tlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsMC4wLG51bGwsbnVsbCxbInhfdyIsIndpZGdldHMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLFtdLG51bGwsbnVsbCxbImRpc3BsYXkiLCJ3aWRnZXRzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsMC4wLG51bGwsbnVsbCxbInlfdyIsIndpZGdldHMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLDI3MC4wLG51bGwsbnVsbCxbInlfZCIsIndpZGdldHMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLDUuMCxudWxsLG51bGwsWyJ4X2siLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiw4ODUuMCxudWxsLG51bGwsWyJ4X2QiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiw1NDUuMCxudWxsLG51bGwsWyJ5X2siLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiw0MjAuMCxudWxsLG51bGwsWyJ5X3YiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwxMTAuMCxudWxsLG51bGwsWyJ4X3MiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwiRkZGRkZGRkYiLG51bGwsbnVsbCxbImNvbG9yIiwid2lkZ2V0cyIsImNvbG9yX3BpY2tlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsNTQ1LjAsbnVsbCxudWxsLFsieV9zIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic3VwZXJfdG9zcyIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJzdXBlcl90b3NzIiwiTm90aGluZyIsbnVsbCxudWxsLFsiaWdub3JlIiwic3VwZXJfdG9zcyIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJxdWlja19sYW5kaW5nIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImluZGljYXRvcnMiLHRydWVdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJpbmRpY2F0b3JzIiwiTW9kZXJuIixudWxsLG51bGwsWyJzdHlsZSIsImluZGljYXRvcnMiLCJjb21ibyJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiaW5kaWNhdG9ycyIsWyJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkZha2UgRHVjayIsIkJvZHkgQWltIiwiRnJlZXN0YW5kaW5nIl0sbnVsbCxudWxsLFsiYmluZHMiLCJpbmRpY2F0b3JzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiaW5kaWNhdG9ycyIsWyJUbyBTY29wZSJdLG51bGwsbnVsbCxbImFkZGl0aW9ucyIsImluZGljYXRvcnMiLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJpbmRpY2F0b3JzIix0cnVlLG51bGwsbnVsbCxbInJldml0YWxpemUiLCJpbmRpY2F0b3JzIiwic3dpdGNoIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJpbmRpY2F0b3JzIixbIkJpbmRzIl0sbnVsbCxudWxsLFsiZGlzcGxheSIsImluZGljYXRvcnMiLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJpbmRpY2F0b3JzIiwiSGVhZGVyIix7IkNvbmRpdGlvbiI6WyJGRkZGRkZGRiIsIkZGRkZGRkZGIl0sIkhlYWRlciI6WyJGRkZGRkZGRiIsIkZGRkZGRkZGIl19LFsiY29sb3JzIiwiaW5kaWNhdG9ycyIsImNvbG9yX3BpY2tlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwibmFkZV9maXgiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwibmFkZV9maXgiLFtdLG51bGwsbnVsbCxbIm9uIiwibmFkZV9maXgiLCJzZWxlY3RhYmxlIl1dXQ_serenity\n        "
        }, 
        get = function(v136, v137)
            -- upvalues: l_mui_0 (ref), v61 (ref), v135 (ref), l_clipboard_0 (ref)
            local v138 = l_mui_0.configs.save(v61, v136);
            v138 = v135.encode(json.stringify(v138));
            if v137 then
                l_clipboard_0.set(("%s_serenity"):format(v138));
                return;
            else
                return v138;
            end;
        end, 
        set = function(v139, v140)
            -- upvalues: l_clipboard_0 (ref), v29 (ref), v135 (ref), l_mui_0 (ref), v61 (ref)
            local v141 = v140 and l_clipboard_0.get() or v139;
            v141 = v29.split(v141, "_")[1];
            local v142 = json.parse(v135.decode(v141), true);
            l_mui_0.configs.load(v61, v142);
        end
    };
    v143.save = function()
        -- upvalues: v61 (ref), v143 (ref), l_print_0 (ref), v29 (ref), l_serenity_recode_0 (ref)
        local v144 = v61.home.name:get();
        if v143.defaults[v144] then
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("You cannot perform this action with this configuration.");
            return;
        else
            if string.len(v144) < 1 or string.len(v144) > 128 then
                v144 = v29.username;
            end;
            if pcall(function()
                -- upvalues: v143 (ref), v144 (ref), l_serenity_recode_0 (ref)
                local v145 = v143.get({
                    [1] = "anti aim", 
                    [2] = "settings"
                });
                v143.data[v144] = v145;
                l_serenity_recode_0.configs = v143.data;
                db.serenity_recode = l_serenity_recode_0;
                v143.update();
            end) then
                cvar.play:call("ui/beepclear.wav");
                l_print_0("The configuration was successfully saved.");
            else
                cvar.play:call("ui/weapon_cant_buy.wav");
                l_print_0("The configuration is wrong.");
            end;
            return;
        end;
    end;
    v143.load = function()
        -- upvalues: v61 (ref), v143 (ref), l_print_0 (ref)
        local v146 = v61.home.list:list()[v61.home.list:get()];
        if pcall(function()
            -- upvalues: v143 (ref), v146 (ref)
            v143.set(v143.data[v146]);
        end) then
            cvar.play:call("ui/beepclear.wav");
            l_print_0("The configuration was successfully loaded.");
        else
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("The configuration is wrong.");
        end;
    end;
    v143.update = function()
        -- upvalues: v143 (ref), l_serenity_recode_0 (ref), v61 (ref)
        for v147, v148 in pairs(v143.defaults) do
            v143.data[v147] = v148;
        end;
        v143.list = {
            data = {}, 
            name = {}
        };
        for v149, v150 in pairs(l_serenity_recode_0.configs) do
            v143.list.data[v149] = v150;
            table.insert(v143.list.name, v149);
        end;
        table.sort(v143.list.name);
        v61.home.list:update(v143.list.name);
    end;
    v143.remove = function()
        -- upvalues: v61 (ref), v143 (ref), l_print_0 (ref), l_serenity_recode_0 (ref)
        local v151 = v61.home.list:list()[v61.home.list:get()];
        if v143.defaults[v151] then
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("You cannot perform this action with this configuration.");
            return;
        else
            for v152, _ in pairs(v143.data) do
                if v152 == v151 then
                    v143.data[v152] = nil;
                end;
            end;
            l_serenity_recode_0.configs = v143.data;
            db.serenity_recode = l_serenity_recode_0;
            v143.update();
            cvar.play:call("ui/beepclear.wav");
            l_print_0("The configuration was successfully removed.");
            return;
        end;
    end;
    v143.export = function()
        -- upvalues: v143 (ref), l_print_0 (ref)
        if pcall(function()
            -- upvalues: v143 (ref)
            v143.get({
                [1] = "anti aim", 
                [2] = "settings"
            }, true);
        end) then
            cvar.play:call("ui/beepclear.wav");
            l_print_0("The configuration was successfully saved to the clipboard.");
        else
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("The configuration is wrong.");
        end;
    end;
    v143.export_aa = function()
        -- upvalues: v143 (ref), l_print_0 (ref)
        if pcall(function()
            -- upvalues: v143 (ref)
            v143.get({
                [1] = "anti aim"
            }, true);
        end) then
            cvar.play:call("ui/beepclear.wav");
            l_print_0("The configuration [Anti Aim] was successfully saved to the clipboard.");
        else
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("The configuration is wrong.");
        end;
    end;
    v143.import = function()
        -- upvalues: v143 (ref), l_print_0 (ref)
        if pcall(function()
            -- upvalues: v143 (ref)
            v143.set(nil, true);
        end) then
            cvar.play:call("ui/beepclear.wav");
            l_print_0("The configuration was successfully loaded of clipboard.");
        else
            cvar.play:call("ui/weapon_cant_buy.wav");
            l_print_0("The configuration is wrong.");
        end;
    end;
    v143.update();
    v61["anti aim"].manual[0].magnet:tooltip("Turns the head towards the position where the bind is pressed.");
    v61.home.select:set_callback(function(v154)
        -- upvalues: v61 (ref), v29 (ref)
        local v155 = v154:list();
        for v156 = 1, #v155 do
            do
                local l_v156_0 = v156;
                pcall(function()
                    -- upvalues: v61 (ref), v29 (ref), v155 (ref), l_v156_0 (ref), v154 (ref)
                    v61.tabs.home[v29.split(v155[l_v156_0], "  ")[2]:lower()]:visibility(v155[l_v156_0] == v155[v154:get()]);
                end);
            end;
        end;
        v61.tabs.home.informations_2:visibility(v154:get() == 1);
        v61.tabs.home.configurations_2:visibility(v154:get() == 3);
    end, true);
    v61.home.list:set_callback(function(v158)
        -- upvalues: v143 (ref), v61 (ref)
        local v159 = v158:list()[v158:get()];
        if v143.defaults[v159] then
            v159 = "";
        end;
        v61.home.name:set(v159);
    end);
    v61.home.save:set_callback(function()
        -- upvalues: v143 (ref)
        v143.save();
    end);
    v61.home.load:set_callback(function()
        -- upvalues: v143 (ref)
        v143.load();
    end);
    v61.home.remove:set_callback(function()
        -- upvalues: v143 (ref), v61 (ref)
        v143.remove();
        v61.home.list:set(v61.home.list:get());
    end);
    v61.home.export:set_callback(function()
        -- upvalues: v143 (ref)
        v143.export();
    end);
    v61.home.import:set_callback(function()
        -- upvalues: v143 (ref)
        v143.import();
    end);
    v61["anti aim"].export:set_callback(function()
        -- upvalues: v143 (ref)
        v143.export_aa();
    end);
    v61["anti aim"].import:set_callback(function()
        -- upvalues: v143 (ref)
        v143.import();
    end);
    v61.settings.indicators:set_callback(function(v160)
        -- upvalues: v61 (ref)
        local v161 = v61.settings.indicators[0];
        v161.style:visibility(v160:get());
        v161.display:visibility(v160:get());
        v161.display:set_callback(function(v162)
            -- upvalues: v161 (ref), v160 (ref)
            v161.binds:visibility(v160:get() and v162:get("Binds"));
        end, true);
        v161.additions:visibility(v160:get());
        v161.colors:visibility(v160:get());
        v161.revitalize:visibility(v160:get());
    end, true);
    v61.settings.damage:set_callback(function(v163)
        -- upvalues: v61 (ref)
        local v164 = v61.settings.damage[0];
        v164.color:visibility(v163:get());
        v164.show:visibility(v163:get());
    end, true);
    v61.settings.arrows:set_callback(function(v165)
        -- upvalues: v61 (ref)
        local v166 = v61.settings.arrows[0];
        v166.style:visibility(v165:get());
        v166.display:visibility(v165:get());
        v166.offset:visibility(v165:get());
        v166.style:set_callback(function(v167)
            -- upvalues: v166 (ref), v165 (ref)
            v166.color:visibility(v165:get() and v167:get() == "Simple");
            v166.colors:visibility(v165:get() and v167:get() == "Teamskeet");
        end, true);
    end, true);
    v61.settings.widgets:set_callback(function(v168)
        -- upvalues: v61 (ref)
        local v169 = v61.settings.widgets[0];
        v169.display:visibility(v168:get());
        v169.display:set_callback(function(v170)
            -- upvalues: v169 (ref), v168 (ref)
            local v171 = #v170:get() > 0;
            if #v170:get() == 1 and v170:get("Velocity Warning") then
                v171 = false;
            end;
            v169.color:visibility(v168:get() and v171);
            if #v170:get() == 1 and v170:get("Defensive Indicator") then
                v171 = false;
            elseif #v170:get() == 2 and v170:get("Velocity Warning") and v170:get("Defensive Indicator") then
                v171 = false;
            end;
            v169.style:visibility(v168:get() and v171);
            v169.background:visibility(v168:get() and v171);
        end, true);
    end, true);
    v61.settings.watermark:set_callback(function(v172)
        -- upvalues: v61 (ref)
        local v173 = v61.settings.watermark[0];
        v173.position:visibility(v172:get() == "Serenity" or v172:get() == "Emoji");
        v173.position:set_callback(function(v174)
            -- upvalues: v173 (ref), v172 (ref)
            v173.type:visibility((not (v172:get() ~= "Serenity") or v172:get() == "Emoji") and v174:get() == "Below");
        end, true);
    end, true);
    v61.settings.skeet:set_callback(function(v175)
        -- upvalues: v61 (ref)
        local v176 = v61.settings.skeet[0];
        v176.display:visibility(v175:get());
        v176.spectators:visibility(v175:get());
        v176.spectators:set_callback(function(v177)
            -- upvalues: v176 (ref), v175 (ref)
            v176.offset:visibility(v175:get() and v177:get());
        end, true);
    end, true);
    v61.settings.scope:set_callback(function(v178)
        -- upvalues: v61 (ref), v60 (ref)
        local v179 = v61.settings.scope[0];
        v179.start:visibility(v178:get());
        v179.length:visibility(v178:get());
        v179.hidden:visibility(v178:get());
        v179.inverter:visibility(v178:get());
        v179.color:visibility(v178:get());
        v60.world["Override Zoom"].overlay:override(v178:get() and "Remove All" or nil);
    end, true);
    v61.settings.radius:set_callback(function(v180)
        -- upvalues: v61 (ref)
        local v181 = v61.settings.radius[0];
        v181.display:visibility(v180:get());
        v181.display:set_callback(function(v182)
            -- upvalues: v181 (ref), v180 (ref)
            v181.color_se:visibility(v180:get() and v182:get("Smoke"));
            v181.color_ev:visibility(v180:get() and v182:get("Molotov"));
            v181.color_tv:visibility(v180:get() and v182:get("Molotov"));
        end, true);
    end, true);
    v61.settings.logs:set_callback(function(v183)
        -- upvalues: v61 (ref)
        local v184 = v61.settings.logs[0];
        v184.select:visibility(v183:get());
        v184.select:set_callback(function(v185)
            -- upvalues: v184 (ref), v183 (ref)
            v184.extended:visibility(v183:get() and #v185:get() ~= 0);
            v184.style:visibility(v183:get() and v185:get("Screen"));
            v184.offset:visibility(v183:get() and v185:get("Screen"));
            v184.colors:visibility(v183:get() and #v185:get() ~= 0);
        end, true);
    end, true);
    v61.settings.trashtalk:set_callback(function(v186)
        -- upvalues: v61 (ref)
        local v187 = v61.settings.trashtalk[0];
        v187.language:visibility(v186:get());
        v187.delay:visibility(v186:get());
    end, true);
    v61.settings.no_fall:tooltip("Prevents fall damage.\n\nNote: \aFF2C2CFFIt doesn't work with a 100% chance.");
    v61.settings.nade_fix:tooltip("Corrects errors when your grenades fly upwards or fail to register on the server.");
    v61.settings.nade_fix:set_callback(function(v188)
        -- upvalues: v61 (ref)
        v61.settings.nade_fix[0].on:visibility(v188:get());
    end, true);
    v61["anti aim"].tweaks:set_callback(function(v189)
        -- upvalues: v61 (ref)
        local v190 = v61["anti aim"].tweaks[0];
        v190.weapon:visibility(v189:get("Auto Teleport"));
        v190.weapon:set_callback(function(v191)
            -- upvalues: v190 (ref), v189 (ref)
            v190.edge_yaw:visibility(v189:get("Edge Yaw"));
            v190.delay:visibility(v189:get("Auto Teleport") and #v191:get() > 0);
            v190.in_air:visibility(v189:get("Auto Teleport") and #v191:get() > 0);
        end, true);
    end, true);
    v61.settings.drop_grenades:set_callback(function(v192)
        -- upvalues: v61 (ref)
        local v193 = v61.settings.drop_grenades[0];
        v193.bind:visibility(v192:get());
        v193.bind:set_callback(function(v194)
            -- upvalues: v193 (ref), v192 (ref)
            v193.discard:visibility(v192:get() and v194:key() ~= 0);
        end, true);
    end, true);
    v61.settings.auto_m_unm:set_callback(function(v195)
        -- upvalues: v61 (ref)
        v61.settings.auto_m_unm[0].mode:visibility(v195:get());
    end, true);
    v61["anti aim"].animations:set_callback(function(v196)
        -- upvalues: v61 (ref)
        local v197 = v61["anti aim"].animations[0];
        v197.select:visibility(v196:get());
        v197.select:set_callback(function(v198)
            -- upvalues: v197 (ref), v196 (ref)
            v197.landing:visibility(v196:get() and v198:get("Legs on Landing"));
            v197.air:visibility(v196:get() and v198:get("Legs in Air"));
            v197.lean:visibility(v196:get() and v198:get("Body Lean"));
        end, true);
    end, true);
    v61["anti aim"].condition:set_callback(function(v199)
        -- upvalues: v29 (ref), v61 (ref)
        for v200 = 1, #v29.conditions do
            local v201 = v29.conditions[v200];
            local v202 = v201 == get_team(v199:get()) and v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] ~= "Disabled";
            v61["anti aim"][("%s / %s"):format(v201, "enable")]:visibility(v202);
            if v201 == get_team("Global") then
                v61["anti aim"][("%s / %s"):format(v201, "enable")]:visibility(false);
                v61["anti aim"][("%s / %s"):format(v201, "enable")]:set(true);
            end;
            v61["anti aim"][("%s / %s"):format(v201, "enable")]:set(v61["anti aim"][("%s / %s"):format(v201, "enable")]:get());
        end;
    end, true);
    v61["anti aim"].type:set_callback(function(v203)
        -- upvalues: v29 (ref), v61 (ref)
        local v204 = v29.split(v203:list()[v203:get()], "  ")[2];
        v61["anti aim"].condition:visibility(v204 ~= "Disabled");
        v61["anti aim"].condition:set(v61["anti aim"].condition:get());
        v61["anti aim"].team:set(v61["anti aim"].team:get());
        v61["anti aim"].team:visibility(v204 == "Teams");
        v61["anti aim"].manual:visibility(v204 ~= "Disabled");
        v61["anti aim"].tweaks:visibility(v204 ~= "Disabled");
        v61["anti aim"].safe:visibility(v204 ~= "Disabled");
        v61["anti aim"].freestanding:visibility(v204 ~= "Disabled");
        v61["anti aim"].animations:visibility(v204 ~= "Disabled");
        v61["anti aim"].send:visibility(v204 == "Teams");
    end, true);
    v61["anti aim"].team:set_callback(function(_)
        -- upvalues: v61 (ref)
        v61["anti aim"].condition:set(v61["anti aim"].condition:get());
    end, true);
    v61["anti aim"].send:set_callback(function(_)
        -- upvalues: v61 (ref), l_print_0 (ref)
        local v207 = v61["anti aim"].condition:get();
        local v208 = {
            current = v61["anti aim"].team:get(), 
            opposite = v61["anti aim"].team:get()
        };
        if v208.current == "Counter-Terrorists" then
            v208.current = "CT";
            v208.opposite = "T";
        elseif v208.current == "Terrorists" then
            v208.current = "T";
            v208.opposite = "CT";
        end;
        local v209 = {
            [1] = {
                element = "enable"
            }, 
            [2] = {
                element = "pitch"
            }, 
            [3] = {
                element = "yaw"
            }, 
            [4] = {
                name = "mode", 
                element = "yaw"
            }, 
            [5] = {
                name = "offset", 
                element = "yaw"
            }, 
            [6] = {
                name = "offset_l", 
                element = "yaw"
            }, 
            [7] = {
                name = "offset_r", 
                element = "yaw"
            }, 
            [8] = {
                element = "yaw_modifier"
            }, 
            [9] = {
                name = "mode", 
                element = "yaw_modifier"
            }, 
            [10] = {
                name = "offset", 
                element = "yaw_modifier"
            }, 
            [11] = {
                name = "offset_l", 
                element = "yaw_modifier"
            }, 
            [12] = {
                name = "offset_r", 
                element = "yaw_modifier"
            }, 
            [13] = {
                element = "body_yaw"
            }, 
            [14] = {
                name = "limit_l", 
                element = "body_yaw"
            }, 
            [15] = {
                name = "limit_r", 
                element = "body_yaw"
            }, 
            [16] = {
                name = "options", 
                element = "body_yaw"
            }, 
            [17] = {
                name = "delay", 
                element = "body_yaw"
            }, 
            [18] = {
                name = "freestanding", 
                element = "body_yaw"
            }, 
            [19] = {
                element = "defensive_aa"
            }, 
            [20] = {
                name = "lc", 
                element = "defensive_aa"
            }, 
            [21] = {
                name = "pitch", 
                element = "defensive_aa"
            }, 
            [22] = {
                name = "pitch_offset", 
                element = "defensive_aa"
            }, 
            [23] = {
                name = "pitch_offset_1", 
                element = "defensive_aa"
            }, 
            [24] = {
                name = "pitch_offset_2", 
                element = "defensive_aa"
            }, 
            [25] = {
                name = "yaw", 
                element = "defensive_aa"
            }, 
            [26] = {
                name = "yaw_offset", 
                element = "defensive_aa"
            }, 
            [27] = {
                name = "yaw_offset_1", 
                element = "defensive_aa"
            }, 
            [28] = {
                name = "yaw_offset_2", 
                element = "defensive_aa"
            }
        };
        for v210 = 1, #v209 do
            local v211 = v209[v210];
            if not v211.name then
                v211.value = v61["anti aim"][("%s / %s / %s"):format(v207, v208.current, v211.element)]:get();
            else
                v211.value = v61["anti aim"][("%s / %s / %s"):format(v207, v208.current, v211.element)][0][v211.name]:get();
            end;
        end;
        for v212 = 1, #v209 do
            local v213 = v209[v212];
            if not v213.name then
                v61["anti aim"][("%s / %s / %s"):format(v207, v208.opposite, v213.element)]:set(v213.value);
            else
                v61["anti aim"][("%s / %s / %s"):format(v207, v208.opposite, v213.element)][0][v213.name]:set(v213.value);
            end;
        end;
        cvar.play:call("ui/beepclear.wav");
        l_print_0(("%s condition sent from command %s to command %s"):format(v207, v208.current, v208.opposite));
    end);
    local v214 = {
        main = {
            disabled = false, 
            legit_aa = {
                status = false, 
                timeout = globals.realtime
            }, 
            inverter = {
                yaw_tick = 1, 
                tick = 0, 
                active_tick = false, 
                active = false
            }, 
            converter = {
                SW = "Slow Move", 
                M = "Moving", 
                S = "Standing", 
                G = "Global", 
                C = "Crouch", 
                AC = "Air Crouch", 
                A = "In Air"
            }, 
            freestanding = {
                converter = {
                    ["In Air"] = "air", 
                    Crouch = "crouch", 
                    ["Slow Move"] = "slow_walk", 
                    Moving = "moving", 
                    Standing = "standing"
                }
            }, 
            manuals = {
                Right = 90, 
                Left = -90, 
                Forward = 180, 
                Backward = 0, 
                ["At Target"] = 2006
            }, 
            defensive = {
                delay = 0, 
                yaw_spin = 0, 
                pitch = {
                    Disabled = 12345, 
                    Automatic = 2023, 
                    Offset = 1337, 
                    Switch = -8989, 
                    Random = 2006
                }, 
                yaw = {
                    Neverlose = 12345, 
                    ["3-Way"] = 2020, 
                    Offset = 1337, 
                    Switch = -180180, 
                    ["5-Way"] = 2023, 
                    Spin = 360, 
                    Random = 2006
                }
            }, 
            animations = {
                pitch_on_land = {
                    status = false, 
                    tick = 1, 
                    timeout = 0
                }
            }, 
            auto_teleport = {
                worked = false
            }, 
            magnetize = {
                position = vector(0, 0, 0)
            }
        }, 
        reference = {
            enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = {
                self = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
                base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
                backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
                hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
            }, 
            yaw_modifier = {
                self = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
            }, 
            body_yaw = {
                self = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
                inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
                limit_l = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
                limit_r = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
                options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
                freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            }, 
            freestanding = {
                self = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
                DYM = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
                BF = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            }, 
            fake_lag = {
                limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
            }, 
            misc = {
                leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
                fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
            }
        }
    };
    v214.data = {
        get = function(_, v216, v217, v218)
            -- upvalues: v214 (ref)
            return v214.data.builder(v216, v217, v218);
        end, 
        builder = function(v219, v220, v221)
            -- upvalues: v61 (ref)
            if v221 then
                return v61["anti aim"][("%s / %s"):format(v219, v220)].gear[v221]:get();
            else
                return v61["anti aim"][("%s / %s"):format(v219, v220)]:get();
            end;
        end
    };
    v214.legit_aa = function(v222, v223)
        -- upvalues: v214 (ref)
        v214.main.legit_aa.status = false;
        if not v223.in_use then
            v214.main.legit_aa.timeout = globals.realtime;
            return;
        else
            local v224 = {
                origin = v222:get_origin(), 
                bomb = {
                    distance = 1000, 
                    c4 = entity.get_entities("CPlantedC4")
                }
            };
            if #v224.bomb.c4 > 0 then
                for v225 = 1, #v224.bomb.c4 do
                    local v226 = v224.bomb.c4[v225]:get_origin();
                    local v227 = v224.origin:dist(v226);
                    if v227 < v224.bomb.distance then
                        v224.bomb.distance = v227;
                    end;
                end;
            end;
            v224.hostage = {
                distance = 1000, 
                peoples = entity.get_entities("CHostage")
            };
            if #v224.hostage.peoples > 0 then
                for v228 = 1, #v224.hostage.peoples do
                    local v229 = v224.hostage.peoples[v228]:get_origin();
                    local v230 = v224.origin:dist(v229);
                    if v230 < v224.hostage.distance then
                        v224.hostage.distance = v230;
                    end;
                end;
            end;
            if v224.hostage.distance < 65 and v222.m_iTeamNum ~= 2 then
                return;
            elseif v224.bomb.distance < 65 and v222.m_iTeamNum ~= 2 then
                return;
            elseif v223.in_use and globals.realtime - v214.main.legit_aa.timeout < 0.02 then
                return;
            else
                v223.in_use = false;
                v214.main.legit_aa.status = true;
                return;
            end;
        end;
    end;
    v214.edge_yaw = function(v231, _)
        -- upvalues: v61 (ref), l_liberia_0 (ref), v214 (ref), v29 (ref)
        pcall(function()
            -- upvalues: v61 (ref), l_liberia_0 (ref), v214 (ref), v231 (ref), v29 (ref)
            if v61["anti aim"].tweaks[0].edge_yaw:get("Always On") then
                if l_liberia_0.anti_aim.condition.get_state("air") then
                    return;
                end;
            elseif not v214.reference.misc.fake_duck:get() then
                return;
            end;
            if globals.choked_commands == 0 then
                v214.main.edge_vector = v231:get_eye_position();
            end;
            local _, _, v235, v236 = v29.get_edge(v214.main.edge_vector, 0.5, {
                [1] = 135, 
                [2] = 2
            });
            if v236 then
                local l_y_0 = v235.y;
                local l_y_1 = v236.y;
                local v239 = math.normalize_yaw(l_y_1 - l_y_0);
                if math.abs(v239) < 90 then
                    v239 = 0;
                    l_y_0 = math.normalize_yaw(l_y_1 + 180);
                end;
                local v240 = -l_y_0;
                v240 = math.normalize_yaw(v240 + l_y_1 + 180);
                v240 = math.normalize_yaw(v240 + v239);
                v214.reference.yaw.offset:override(v240);
                v214.reference.freestanding.self:override(false);
                v214.reference.yaw.hidden:override(false);
                v214.reference.yaw.base:override("Local View");
            end;
        end);
    end;
    v214.fast_ladder = function(v241, v242)
        local v243 = render.camera_angles();
        if v241.m_MoveType == 9 then
            if v242.forwardmove > 0 and v243.x < 45 then
                v242.view_angles.x = 89;
                v242.view_angles.y = v242.view_angles.y + 89;
                v242.in_moveright = 1;
                v242.in_moveleft = 0;
                v242.in_forward = 0;
                v242.in_back = 1;
            end;
            if v242.forwardmove < 0 then
                v242.view_angles.x = 89;
                v242.view_angles.y = v242.view_angles.y + 89;
                v242.in_moveright = 0;
                v242.in_moveleft = 1;
                v242.in_forward = 1;
                v242.in_back = 0;
            end;
            if v242.sidemove == 0 then
                v242.move_yaw = v242.move_yaw + 90;
            end;
            if v242.sidemove > 0 then
                v242.move_yaw = v242.move_yaw + 150;
            end;
            if v242.sidemove < 0 then
                v242.move_yaw = v242.move_yaw + 30;
            end;
        end;
    end;
    v214.extrapolate_position = function(v244, v245, v246)
        local l_m_vecVelocity_0 = v246.m_vecVelocity;
        for _ = 1, v245 do
            v244 = v244 + l_m_vecVelocity_0 * globals.tickinterval;
        end;
        return v244;
    end;
    v214.auto_teleport = function(v249)
        -- upvalues: v61 (ref), v214 (ref)
        if not v61["anti aim"].tweaks:get("Auto Teleport") then
            return;
        else
            local v250 = v249:get_player_weapon();
            if not v250 then
                return;
            else
                local l_weapon_type_0 = v250:get_weapon_info().weapon_type;
                local v252 = v250:get_weapon_index();
                local v253 = l_weapon_type_0 == 1;
                local v254 = l_weapon_type_0 == 5;
                local v255 = v252 == 9;
                local v256 = v252 == 40;
                local v257 = v252 == 1 or v252 == 64;
                local v258 = l_weapon_type_0 == 0;
                local v259 = entity.get_players(true, false);
                local v260 = v61["anti aim"].tweaks[0].delay:get();
                local v261 = v214.extrapolate_position(v249:get_hitbox_position(3), v61["anti aim"].tweaks[0].delay:get() * 16, v249);
                if v260 < 1 then
                    v261 = v249:get_hitbox_position(0);
                end;
                for v262, v263 in pairs({
                    [1] = v253, 
                    [2] = v254, 
                    [3] = v255, 
                    [4] = v256, 
                    [5] = v257, 
                    [6] = v258, 
                    [7] = not v253 and not v254 and not v255 and not v256 and not v257 and not v258
                }) do
                    local v264 = v61["anti aim"].tweaks[0].weapon:list()[v262];
                    if v264 then
                        if v61["anti aim"].tweaks[0].in_air:get() and bit.band(v249.m_fFlags, bit.lshift(1, 0)) ~= 0 then
                            return;
                        elseif v61["anti aim"].tweaks[0].weapon:get(v264) and v263 then
                            for v265 = 1, #v259 do
                                local v266 = utils.trace_bullet(v259[v265], v259[v265]:get_hitbox_position(0), v261);
                                if v259[v265]:is_alive() and v259[v265]:is_visible(v261) and v266 > 0 and v259[v265]:is_enemy() then
                                    if not v214.main.auto_teleport.worked then
                                        rage.exploit:force_teleport();
                                        v214.main.auto_teleport.worked = true;
                                    end;
                                else
                                    v214.main.auto_teleport.worked = false;
                                end;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
    v214.magnetize = function(v267, v268)
        -- upvalues: v61 (ref), v214 (ref), v29 (ref)
        local v269 = v267:get_origin();
        if v61["anti aim"].manual[0].magnet:get() then
            if v214.main.magnetize.position == vector(0, 0, 0) then
                v214.main.magnetize.position = v269;
            end;
        else
            v214.main.magnetize.position = vector(0, 0, 0);
        end;
        if v214.main.magnetize.position == vector(0, 0, 0) or v214.main.magnetize.position:dist(v269) < 2 then
            return;
        else
            local v270 = v267:get_eye_position();
            local v271 = v29.calc_angle(v270, v214.main.magnetize.position);
            if v271.y > -360 and v271.y < 360 then
                v214.reference.yaw.self:override("Backward");
                v214.reference.yaw.base:override("Local View");
                if v61["anti aim"].manual[0].static:get() then
                    v214.reference.yaw.hidden:override(false);
                    v214.reference.yaw_modifier.self:override("Disabled");
                    v214.reference.body_yaw.inverter:override(false);
                    v214.reference.body_yaw.options:override({});
                end;
                v214.reference.freestanding.self:override(false);
                v268.view_angles.y = 180 + v271.y;
            end;
            return;
        end;
    end;
    v214.animations = function(v272, v273)
        -- upvalues: v214 (ref), v61 (ref), l_lambotruck_0 (ref), l_liberia_0 (ref)
        v214.reference.misc.leg_movement:override(nil);
        if not v61["anti aim"].animations:get() or #v61["anti aim"].animations[0].select:get() == 0 then
            return;
        else
            local v274 = math.abs(v272.m_vecVelocity:length() - 1);
            local v275 = {
                [6] = l_lambotruck_0.animation.overlay(v273, 6), 
                [7] = l_lambotruck_0.animation.overlay(v273, 7), 
                [12] = l_lambotruck_0.animation.overlay(v273, 12)
            };
            if not v275[6] or not v275[12] then
                return;
            else
                if v61["anti aim"].animations[0].select:get("0 Pitch on Land") then
                    if not l_liberia_0.anti_aim.condition.get_state("air") then
                        v214.main.animations.pitch_on_land.tick = v214.main.animations.pitch_on_land.tick + 1;
                    else
                        v214.main.animations.pitch_on_land.tick = 1;
                        v214.main.animations.pitch_on_land.timeout = globals.realtime + 1;
                        v214.main.animations.pitch_on_land.status = true;
                    end;
                    if v214.main.animations.pitch_on_land.timeout + 0.5 <= globals.realtime then
                        v214.main.animations.pitch_on_land.status = false;
                    end;
                    if v214.main.animations.pitch_on_land.status and v214.main.animations.pitch_on_land.tick > 1 and v214.main.animations.pitch_on_land.timeout > globals.realtime then
                        v272.m_flPoseParameter[12] = 0.5;
                    end;
                end;
                if v61["anti aim"].animations[0].select:get("Legs on Landing") then
                    local v276 = v61["anti aim"].animations[0].landing:get();
                    if v276 == "Static" then
                        v214.reference.misc.leg_movement:override("Sliding");
                        v272.m_flPoseParameter[0] = 0.25;
                    elseif v276 == "Backward" then
                        v214.reference.misc.leg_movement:override("Sliding");
                        v272.m_flPoseParameter[0] = 0.5;
                    elseif v276 == "Switch" then
                        v214.reference.misc.leg_movement:override("Sliding");
                        v272.m_flPoseParameter[0] = globals.tickcount % 4 >= 2 and 0.5 or 1;
                    elseif v276 == "Shivering" then
                        if v274 >= 3 and not l_liberia_0.anti_aim.condition.get_state("air") then
                            v214.reference.misc.leg_movement:override(globals.tickcount % 4 >= 2 and "Sliding" or "Walking");
                            v275[7].m_flWeight = globals.tickcount % 4 >= 2 and 0 or 0.32;
                        end;
                    elseif v276 == "Moonwalk" then
                        v214.reference.misc.leg_movement:override("Walking");
                        v272.m_flPoseParameter[7] = 1;
                        v272.m_flPoseParameter[0] = 0.5;
                    end;
                end;
                if v61["anti aim"].animations[0].select:get("Legs in Air") and l_liberia_0.anti_aim.condition.get_state("air") then
                    local v277 = v61["anti aim"].animations[0].air:get();
                    if v277 == "Static" then
                        v272.m_flPoseParameter[6] = 1;
                        v275[6].m_flWeight = 0;
                    elseif v277 == "Moonwalk" then
                        v214.reference.misc.leg_movement:override("Walking");
                        v272.m_flPoseParameter[7] = 1;
                        v272.m_flPoseParameter[0] = 0.5;
                        v275[6].m_flWeight = 1;
                    end;
                end;
                if v61["anti aim"].animations[0].select:get("Body Lean") and v274 >= 3 then
                    local v278 = v61["anti aim"].animations[0].lean:get();
                    v275[12].m_flWeight = v275[12].m_flWeight * (v278 * 0.05);
                end;
                return;
            end;
        end;
    end;
    v214.builder = function(v279)
        -- upvalues: v29 (ref), v61 (ref), v214 (ref), v59 (ref), l_liberia_0 (ref), l_lambotruck_0 (ref), v60 (ref)
        if v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] == "Disabled" then
            if not v214.main.disabled then
                for _, v281 in pairs(v214.reference) do
                    if type(v281) == "table" then
                        for _, v283 in pairs(v281) do
                            v283:override(nil);
                        end;
                    else
                        v281:override(nil);
                    end;
                end;
                v214.main.inverter.tick = 0;
                v214.main.disabled = true;
            end;
            return;
        else
            v214.main.disabled = false;
            local l_self_0 = v59.lp.self;
            if not l_self_0 or not l_self_0:is_alive() then
                return;
            else
                local v285 = "N";
                if v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] == "Teams" then
                    v285 = v59.lp.team.name;
                end;
                local v286 = l_liberia_0.anti_aim.condition.get({
                    [1] = v61["anti aim"][("%s / %s / %s"):format("Standing", v285, "enable")]:get() and "S" or "", 
                    [2] = v61["anti aim"][("%s / %s / %s"):format("Moving", v285, "enable")]:get() and "M" or "", 
                    [3] = v61["anti aim"][("%s / %s / %s"):format("Slow Move", v285, "enable")]:get() and "SW" or "", 
                    [4] = v61["anti aim"][("%s / %s / %s"):format("Crouch", v285, "enable")]:get() and "C" or "", 
                    [5] = v61["anti aim"][("%s / %s / %s"):format("In Air", v285, "enable")]:get() and "A" or "", 
                    [6] = v61["anti aim"][("%s / %s / %s"):format("Air Crouch", v285, "enable")]:get() and "AC" or ""
                });
                v286 = ("%s / %s"):format(v214.main.converter[v286] or "Global", v285);
                if v61["anti aim"][("%s / %s / %s"):format("Crouch Move", v285, "enable")]:get() and l_liberia_0.anti_aim.condition.get_state("moving") and l_liberia_0.anti_aim.condition.get_state("crouch") then
                    v286 = ("%s / %s"):format("Crouch Move", v285);
                end;
                local l_tweaks_0 = v61["anti aim"].tweaks;
                if globals.choked_commands == 0 then
                    local v288 = v214.data.get(v285, v286, "body_yaw") and not rage.antiaim:inverter() or false;
                    local v289 = math.ceil(0.05 * v214.data.get(v285, v286, "body_yaw", "delay"));
                    if v289 > 0 and l_liberia_0.table.find(v214.data.get(v285, v286, "body_yaw", "options"), "Jitter") ~= 0 then
                        if l_liberia_0.table.find(v214.data.get(v285, v286, "body_yaw", "options"), "Randomize Jitter") ~= 0 then
                            v289 = math.random(1, v289);
                        end;
                        if v289 < v214.main.inverter.tick then
                            v214.main.inverter.active = not v214.main.inverter.active;
                            v214.main.inverter.tick = 0;
                        end;
                        v214.reference.body_yaw.inverter:override(v214.main.inverter.active);
                        v214.main.inverter.tick = v214.main.inverter.tick + 1;
                        v288 = v214.main.inverter.active;
                    else
                        v214.main.inverter.tick = 0;
                    end;
                    v214.reference.enable:override(true);
                    local v290 = v214.data.get(v285, v286, "pitch");
                    v214.reference.pitch:override(v290);
                    local v291 = v214.data.get(v285, v286, "yaw");
                    if v291 == "3-Way" or v291 == "5-Way" then
                        v214.reference.yaw.self:override("Backward");
                    else
                        v214.reference.yaw.self:override(v291);
                    end;
                    local v292 = v214.data.get(v285, v286, "yaw", "mode");
                    if v292 == "Static" then
                        v214.reference.yaw.offset:override(v214.data.get(v285, v286, "yaw", "offset"));
                    elseif v292 == "L & R" then
                        v214.reference.yaw.offset:override(v214.data.get(v285, v286, "yaw", ("offset_%s"):format(v288 and "l" or "r")));
                    end;
                    if v291 == "3-Way" or v291 == "5-Way" then
                        local v293, _ = v291:gsub("-Way", "");
                        local v295 = v214.reference.yaw.offset:get_override();
                        local v296 = {
                            [3] = {
                                [1] = nil, 
                                [2] = 0, 
                                [1] = -v295, 
                                [3] = v295
                            }, 
                            [5] = {
                                [1] = nil, 
                                [2] = nil, 
                                [3] = 0, 
                                [1] = -v295, 
                                [2] = -v295 * 0.5, 
                                [4] = v295 * 0.5, 
                                [5] = v295
                            }
                        };
                        local v297 = l_lambotruck_0.numbers.ways("Way Yaw", v296[tonumber(v293)]);
                        v214.reference.yaw.offset:override(v297);
                    end;
                    local v298 = v214.data.get(v285, v286, "yaw_modifier");
                    if v298 == "3-Way" or v298 == "5-Way" then
                        v214.reference.yaw_modifier.self:override("Center");
                    else
                        v214.reference.yaw_modifier.self:override(v298);
                    end;
                    local v299 = v214.data.get(v285, v286, "yaw_modifier", "mode");
                    if v299 == "Static" then
                        v214.reference.yaw_modifier.offset:override(v214.data.get(v285, v286, "yaw_modifier", "offset"));
                    elseif v299 == "L & R" then
                        v214.reference.yaw_modifier.offset:override(v214.data.get(v285, v286, "yaw_modifier", ("offset_%s"):format(v288 and "l" or "r")));
                    end;
                    if v298 == "3-Way" or v298 == "5-Way" then
                        local v300, _ = v298:gsub("-Way", "");
                        local v302 = v214.reference.yaw_modifier.offset:get_override();
                        local v303 = {
                            [3] = {
                                [1] = nil, 
                                [2] = 0, 
                                [1] = -v302, 
                                [3] = v302
                            }, 
                            [5] = {
                                [1] = nil, 
                                [2] = nil, 
                                [3] = 0, 
                                [1] = -v302, 
                                [2] = -v302 * 0.5, 
                                [4] = v302 * 0.5, 
                                [5] = v302
                            }
                        };
                        local v304 = l_lambotruck_0.numbers.ways("Way Yaw Modifier", v303[tonumber(v300)]);
                        v214.reference.yaw_modifier.offset:override(v304);
                    end;
                    if v298 == "Delay" then
                        v214.reference.yaw.self:override("Backward");
                        v214.reference.yaw_modifier.self:override("Disabled");
                        v214.reference.yaw.offset:override(v214.reference.yaw.offset:get_override() + v214.data.get(v285, v286, "yaw_modifier", ("offset_%s"):format(v214.main.inverter.active_tick and "l" or "r")));
                        v214.main.inverter.yaw_tick = v214.main.inverter.yaw_tick + 1;
                        if v214.main.inverter.yaw_tick > v214.data.get(v285, v286, "yaw_modifier", "tick") then
                            v214.main.inverter.active_tick = not v214.main.inverter.active_tick;
                            v214.main.inverter.yaw_tick = 1;
                        end;
                    end;
                    if v298 == "Progressive" then
                        v214.reference.yaw_modifier.self:override("Center");
                        v214.reference.yaw_modifier.offset:override(globals.realtime * 32 % v214.reference.yaw_modifier.offset:get_override());
                    end;
                    v214.reference.body_yaw.self:override(v214.data.get(v285, v286, "body_yaw"));
                    if v214.data.get(v285, v286, "body_yaw", "mode") == "Default" then
                        v214.reference.body_yaw.limit_l:override(v214.data.get(v285, v286, "body_yaw", "limit_l"));
                        v214.reference.body_yaw.limit_r:override(v214.data.get(v285, v286, "body_yaw", "limit_r"));
                    else
                        local v305 = globals.curtime * (globals.tickcount % 60) % 60;
                        v214.reference.body_yaw.limit_l:override(v305);
                        v214.reference.body_yaw.limit_r:override(v305);
                    end;
                    v214.reference.body_yaw.options:override(v214.data.get(v285, v286, "body_yaw", "options"));
                    v214.reference.body_yaw.freestanding:override(v214.data.get(v285, v286, "body_yaw", "freestanding"));
                    if v289 > 0 then
                        local v306 = v214.data.get(v285, v286, "body_yaw", "options");
                        local v307 = l_liberia_0.table.find(v306, "Jitter");
                        if v307 ~= 0 then
                            table.remove(v306, v307);
                        end;
                        v214.reference.body_yaw.options:override(v306);
                    end;
                end;
                v214.reference.yaw.hidden:override(nil);
                v60.rage_bot["Double Tap"].options:override(nil);
                v60.rage_bot["Hide Shots"].options:override(nil);
                if v214.data.get(v285, v286, "defensive_aa") then
                    local v308 = v214.data.get(v285, v286, "defensive_aa", "lc");
                    v60.rage_bot["Double Tap"].options:override(v308);
                    v60.rage_bot["Hide Shots"].options:override(v308 == "Always On" and "Break LC" or nil);
                    v214.reference.body_yaw.self:override(true);
                    v214.reference.yaw.hidden:override(true);
                    local v309 = v214.data.get(v285, v286, "defensive_aa", "pitch");
                    v309 = v214.main.defensive.pitch[v309] or 0;
                    local v310 = v214.data.get(v285, v286, "defensive_aa", "pitch_offset");
                    if v309 == 1337 then
                        v309 = v310;
                    elseif v309 == -8989 then
                        v309 = globals.tickcount % 4 >= 2 and v214.data.get(v285, v286, "defensive_aa", "pitch_offset_1") or v214.data.get(v285, v286, "defensive_aa", "pitch_offset_2");
                    elseif v309 == 2006 then
                        v309 = math.random(-v310, v310);
                    elseif v309 == 2023 then
                        v309 = -(globals.curtime * 45 % 90);
                    end;
                    if v309 ~= 12345 then
                        v309 = math.clamp(v309, -89, 89);
                        rage.antiaim:override_hidden_pitch(v309);
                    end;
                    local v311 = v214.data.get(v285, v286, "defensive_aa", "yaw");
                    v311 = v214.main.defensive.yaw[v311] or 0;
                    local v312 = v214.data.get(v285, v286, "defensive_aa", "yaw_offset");
                    if v311 == 1337 then
                        v311 = v312;
                    elseif v311 == 360 then
                        v214.main.defensive.yaw_spin = v214.main.defensive.yaw_spin + v312 * (v214.data.get(v285, v286, "defensive_aa", "yaw_speed") / 360);
                        if v214.main.defensive.yaw_spin >= 180 then
                            v214.main.defensive.yaw_spin = -180;
                        elseif v214.main.defensive.yaw_spin <= -180 then
                            v214.main.defensive.yaw_spin = 180;
                        end;
                        v311 = v214.main.defensive.yaw_spin;
                    elseif v311 == -180180 then
                        v311 = globals.tickcount % 4 >= 2 and v214.data.get(v285, v286, "defensive_aa", "yaw_offset_1") or v214.data.get(v285, v286, "defensive_aa", "yaw_offset_2");
                    elseif v311 == 2006 then
                        v311 = math.random(-v312, v312);
                    elseif v311 == 2020 then
                        v311 = l_lambotruck_0.numbers.ways("Defensive / 3-Way", {
                            [1] = nil, 
                            [2] = 0, 
                            [1] = -v312, 
                            [3] = v312
                        });
                    elseif v311 == 2023 then
                        v311 = l_lambotruck_0.numbers.ways("Defensive / 5-Way", {
                            [1] = nil, 
                            [2] = nil, 
                            [3] = 0, 
                            [1] = -v312, 
                            [2] = -v312 * 0.5, 
                            [4] = v312 * 0.5, 
                            [5] = v312
                        });
                    end;
                    if v311 ~= 12345 then
                        v311 = math.clamp(v311, -180, 180);
                        rage.antiaim:override_hidden_yaw_offset(v311);
                    end;
                end;
                local l_safe_0 = v61["anti aim"].safe;
                if #l_safe_0:get() ~= 0 and not v214.main.legit_aa.status then
                    if l_safe_0:get("Knife & Air Crouch") then
                        local v314 = l_self_0:get_player_weapon();
                        if v314 then
                            local v315 = v314:get_weapon_info();
                            if v315 and v315.weapon_name == "weapon_knife" and l_liberia_0.anti_aim.condition.get_state("air_crouch") then
                                v214.reference.yaw.offset:override(0);
                                v214.reference.yaw_modifier.offset:override(0);
                                v214.reference.yaw.hidden:override(false);
                                v214.reference.body_yaw.self:override(false);
                            end;
                        end;
                    end;
                    if l_safe_0:get("Enemy Below") then
                        local v316 = entity.get_threat(true);
                        if v316 then
                            local v317 = {
                                enemy = v316:get_origin(), 
                                lp = l_self_0:get_origin()
                            };
                            if v317.enemy and v317.lp and v317.enemy.z <= v317.lp.z - 90 then
                                v214.reference.yaw.offset:override(0);
                                v214.reference.yaw_modifier.offset:override(0);
                                v214.reference.yaw.hidden:override(false);
                                v214.reference.body_yaw.self:override(false);
                            end;
                        end;
                    end;
                end;
                local v318 = v61["anti aim"].manual:get();
                if v318 ~= "Disabled" and v318 ~= "At Target" then
                    local v319 = v214.main.manuals[v318];
                    v214.reference.freestanding.self:override(false);
                    if v319 then
                        v214.reference.yaw.offset:override(v319);
                        if v318 ~= "Backward" then
                            v214.reference.yaw.hidden:override(false);
                        end;
                        if v61["anti aim"].manual[0].static:get() then
                            v214.reference.yaw_modifier.self:override("Disabled");
                            v214.reference.body_yaw.inverter:override(false);
                            v214.reference.body_yaw.options:override({});
                        end;
                    end;
                end;
                v214.reference.freestanding.self:override(false);
                if v61["anti aim"].freestanding:get() then
                    local v320 = v61["anti aim"].freestanding[0];
                    do
                        local l_v320_0 = v320;
                        local l_status_0, _ = pcall(function()
                            -- upvalues: l_v320_0 (ref), v318 (ref), l_liberia_0 (ref), v214 (ref)
                            local v322 = l_v320_0.disablers:get();
                            local v323 = true;
                            for v324 = 1, #v322 do
                                local v325 = v322[v324];
                                if v325 == "Manual" then
                                    if v318 ~= "Disabled" and v318 ~= "At Target" then
                                        v323 = false;
                                    end;
                                elseif l_liberia_0.anti_aim.condition.get_state(v214.main.freestanding.converter[v325]) then
                                    v323 = false;
                                end;
                            end;
                            v214.reference.freestanding.self:override(v323);
                            v214.reference.freestanding.DYM:override(l_v320_0.DYM:get());
                            v214.reference.freestanding.BF:override(l_v320_0.BF:get());
                        end);
                        if not l_status_0 then
                            v214.reference.freestanding.self:override(true);
                            v214.reference.freestanding.DYM:override(l_v320_0.DYM:get());
                            v214.reference.freestanding.BF:override(l_v320_0.BF:get());
                        end;
                    end;
                end;
                v214.reference.yaw.base:override(v318 == "At Target" and "At Target" or "Local View");
                if l_tweaks_0:get("AA on Use") then
                    v214.legit_aa(l_self_0, v279);
                    if v214.main.legit_aa.status then
                        v214.reference.freestanding.self:override(false);
                        v214.reference.pitch:override("Disabled");
                        v214.reference.yaw.offset:override(180);
                        v214.reference.yaw.hidden:override(false);
                        v214.reference.yaw.base:override("Local View");
                    end;
                end;
                v214.reference.yaw.backstab:override(l_tweaks_0:get("Avoid Backstab"));
                if l_tweaks_0:get("Fast Ladder") then
                    v214.fast_ladder(l_self_0, v279);
                end;
                if l_tweaks_0:get("Edge Yaw") then
                    v214.edge_yaw(l_self_0, v279);
                end;
                if l_tweaks_0:get("Auto Teleport") then
                    v214.auto_teleport(l_self_0);
                end;
                v214.magnetize(l_self_0, v279);
                return;
            end;
        end;
    end;
    pcall(function()
        ffi.cdef("        typedef unsigned long HANDLE;\n        typedef HANDLE HWND;\n        int GetPriorityClass(void* hProcess);\n        int SetPriorityClass(void* hProcess, int dwPriorityClass);\n        void* GetCurrentProcess();\n    ");
    end);
    local l_gradient_0 = render.gradient;
    local l_text_0 = render.text;
    local v337 = {
        is_bind = function(v330)
            for _, v332 in pairs(ui.get_binds()) do
                if v332.reference:name() == v330 and v332.active then
                    return v332;
                end;
            end;
            return false;
        end, 
        get = function(v333)
            if v333:get_override() ~= nil then
                return v333:get_override();
            else
                return v333:get();
            end;
        end, 
        add_spaces = function(v334)
            local v335 = "";
            for v336 = 1, #v334 do
                v335 = v335 .. string.sub(v334, v336, v336) .. " ";
            end;
            return v335;
        end
    };
    v337.crosshair_indicators = {
        converter = {
            SW = "SLOW MOVE", 
            M = "MOVING", 
            S = "STANDING", 
            G = "GLOBAL", 
            C = "CROUCH", 
            AC = "AIR CROUCH", 
            A = "IN AIR"
        }, 
        leaflets = {
            buttons = {
                D = false, 
                A = false
            }, 
            images = {
                branch = render.load_image_from_file("nl\\Serenity\\Branch.png", vector(600, 255)), 
                leaflet = render.load_image_from_file("nl\\Serenity\\Leaflet.png", vector(50, 60))
            }, 
            timeout = globals.realtime, 
            list = {}
        }, 
        executer = function()
            -- upvalues: v59 (ref), l_smooth_0 (ref), v61 (ref), v29 (ref), v337 (ref), l_liberia_0 (ref), l_monylinear_0 (ref), v60 (ref), v214 (ref)
            local l_self_1 = v59.lp.self;
            local v339 = 0;
            if not l_self_1 then
                v339 = l_smooth_0.linear("Serenity", "Crosshair Indicators Alpha", ui.get_alpha() > 0);
            else
                v339 = l_smooth_0.linear("Serenity", "Crosshair Indicators Alpha", l_self_1:is_alive() or ui.get_alpha() > 0);
            end;
            if not v61.settings.indicators:get() then
                v339 = 0;
            end;
            if v339 == 0 then
                return;
            else
                local v340 = 0;
                local v341 = v29.screen.x * 0.5;
                local v342 = v29.screen.y * 0.5;
                local v343 = v61.settings.indicators[0];
                local v344 = v343.style:get();
                local v345 = v343.revitalize:get();
                if v343.additions:get("To Scope") and l_self_1 then
                    v340 = l_smooth_0.linear("Serenity", "Crosshair Indicators Scope", l_self_1.m_bIsScoped);
                end;
                local v346 = {
                    header = ("serenity%s"):format(v343.display:get("Version") and (" %s"):format(v29.build):lower() or ""), 
                    condition = v337.crosshair_indicators.converter[l_liberia_0.anti_aim.condition.get()]
                };
                local v347 = math.sin(math.abs(-math.pi + globals.curtime * 2 % (math.pi * 1))) * 255;
                v346.header = v344 == "Modern" and v346.header:lower() or v337.add_spaces(v346.header:gsub(v29.build:lower(), ""));
                local v348 = {
                    header = l_monylinear_0:Animate(v346.header, {
                        [1] = v343.colors:get("Header")[1], 
                        [2] = v343.colors:get("Header")[2]
                    }, 3), 
                    condition = l_monylinear_0:Animate(v346.condition, {
                        [1] = v343.colors:get("Condition")[1], 
                        [2] = v343.colors:get("Condition")[2]
                    }, 3)
                };
                v348.header = v344 == "Modern" and v348.header:lower() or v348.header:upper() .. (v343.display:get("Version") and ("\a%sLUA"):format(color(255, 255, 255, v347):to_hex()) or "");
                local v349 = {
                    header = render.measure_text(v344 == "Modern" and 4 or 2, nil, v348.header).x * 0.5 + 5, 
                    condition = render.measure_text(2, nil, v344 == "Modern" and v348.condition or ("-%s-"):format(v348.condition or "MENU")).x * 0.5 + 5
                };
                local v350 = v345 and 24 or 16;
                if v343.additions:get("Header Glow") then
                    render.shadow(vector(v341 - v349.header + 5 + (v349.header - (v344 == "Modern" and 1 or 0)) * v340, v342 + v350 + 2), vector(v341 + v349.header - 5 + (v349.header - (v344 == "Modern" and 1 or 0)) * v340, v342 + v350 + 2), v343.colors:get("Header")[1]);
                end;
                if v345 then
                    local v351 = {
                        size = vector(600, 255) * 0.08
                    };
                    render.shadow(vector(v341 - 16 + v351.size.x * 0.5 * v340, v342 + 24), vector(v341 + 16 + v351.size.x * 0.5 * v340, v342 + v350), color("C577A6"));
                    render.texture(v337.crosshair_indicators.leaflets.images.branch, vector(v341 - v351.size.x * 0.5 + v351.size.x * 0.5 * v340, v342 - v351.size.y * 0.5 + v350), v351.size, color(255, 255, 255, 255 * v339));
                    local _ = {};
                    for v353 = 1, #v337.crosshair_indicators.leaflets.list do
                        local v354 = v337.crosshair_indicators.leaflets.list[v353];
                        if v354 then
                            if v354[3] > 255 then
                                v354[4] = true;
                            end;
                            if v354[3] < 0 then
                                v354[5] = true;
                            end;
                            render.texture(v337.crosshair_indicators.leaflets.images.leaflet, vector(v341 + v354[1].x + v354[2].x + v351.size.x * 0.5 * v340, v342 + 12 + v354[1].y + v354[2].y), vector(50, 60) * 0.1, color(255, 255, 255, v354[3] * v339));
                            local v355 = vector(0, 0);
                            if v337.crosshair_indicators.leaflets.buttons.A then
                                v355.x = v355.x + utils.random_float(0, 0.1);
                            end;
                            if v337.crosshair_indicators.leaflets.buttons.D then
                                v355.x = v355.x - utils.random_float(0, 0.1);
                            end;
                            v354[2] = vector(v355.x + v354[2].x, v355.y + (v354[2].y + 0.1));
                            v354[3] = v354[4] and v354[3] - 1.5 or v354[3] + 1.5;
                        end;
                    end;
                    for v356 = 1, #v337.crosshair_indicators.leaflets.list do
                        local v357 = v337.crosshair_indicators.leaflets.list[v356];
                        if not v357 or v357[5] then
                            table.remove(v337.crosshair_indicators.leaflets.list, v356);
                        end;
                    end;
                    if v337.crosshair_indicators.leaflets.timeout < globals.realtime and #v337.crosshair_indicators.leaflets.list < 12 then
                        table.insert(v337.crosshair_indicators.leaflets.list, {
                            [1] = nil, 
                            [2] = nil, 
                            [3] = 0, 
                            [4] = false, 
                            [5] = false, 
                            [1] = vector(utils.random_float(-24, 24), utils.random_float(0, 8)), 
                            [2] = vector(0, 0)
                        });
                        v337.crosshair_indicators.leaflets.timeout = globals.realtime + utils.random_float(0, 0.5);
                    end;
                end;
                render.text(v344 == "Modern" and 4 or 2, vector(v341 + (v349.header - (v344 == "Modern" and 1 or 0)) * v340, v342 + v350), color(255, 255, 255, 255 * v339), "c", v348.header);
                if v343.display:get("Condition") then
                    if v344 == "Modern" then
                        v350 = v350 + 9;
                        render.text(2, vector(v341 + v349.condition * v340, v342 + v350), color(255, 255, 255, 255 * v339), "c", v348.condition);
                    else
                        v350 = v350 + 8;
                        render.text(2, vector(v341 + v349.condition * v340, v342 + v350), color(255, 255, 255, 255 * v339), "c", ("-%s\aDEFAULT-"):format(v348.condition or "MENU"));
                    end;
                else
                    v350 = v350 + 1;
                end;
                local v358 = v343.display:get("Binds");
                local v359 = {
                    references = {
                        [1] = {
                            name = "BA", 
                            show = v344 == "Modern" and "BODY" or "BODY AIM", 
                            active = v358 and v343.binds:get("Hide Shots") and v60.rage_bot["Body Aim"].self:get() == "Force"
                        }, 
                        [2] = {
                            name = "DT", 
                            show = v344 == "Modern" and ("\a%s%s"):format(v29.percentage(rage.exploit:get(), color(64, 255, 64, 255), color(255, 64, 64, 255)):to_hex(), "DT") or "DT " .. ("\a%s%s"):format(v29.percentage(rage.exploit:get(), color(64, 255, 64, 255), color(255, 64, 64, 255)):to_hex(), "RAPID"), 
                            active = v358 and v343.binds:get("Double Tap") and v60.rage_bot["Double Tap"].self:get()
                        }, 
                        [3] = {
                            name = "HS", 
                            show = v344 == "Modern" and "HS" or "HIDE SHOTS", 
                            active = v358 and v343.binds:get("Hide Shots") and v60.rage_bot["Hide Shots"].self:get()
                        }, 
                        [4] = {
                            name = "FD", 
                            show = v344 == "Modern" and "FD" or "DUCK", 
                            active = v358 and v343.binds:get("Fake Duck") and v337.get(v214.reference.misc.fake_duck)
                        }, 
                        [5] = {
                            name = "FS", 
                            show = v344 == "Modern" and "FS" or "FREESTANDING", 
                            active = v358 and v343.binds:get("Freestanding") and v337.get(v214.reference.freestanding.self)
                        }
                    }
                };
                v359.executer = function()
                    -- upvalues: v359 (ref), l_smooth_0 (ref), v350 (ref), v341 (ref), v340 (ref), v342 (ref), v339 (ref)
                    for v360 = 1, #v359.references do
                        local v361 = v359.references[v360];
                        local v362 = l_smooth_0.linear("Serenity", ("Crosshair Indicators Bind %s"):format(v361.name), v361.active);
                        local v363 = render.measure_text(2, nil, v361.show).x * 0.5 + 5;
                        v350 = v350 + 8 * v362;
                        render.text(2, vector(v341 + v363 * v340, v342 + v350), color(255, 255, 255, 255 * v339 * v362), "c", v361.show);
                    end;
                end;
                v359.executer();
                return;
            end;
        end
    };
    v337.minimum_damage = {
        element = l_system_0.register(v61.settings.damage[0].x, v61.settings.damage[0].y, 29, 12, function(v364)
            -- upvalues: v61 (ref), v337 (ref), v59 (ref)
            if not v364.enable then
                return;
            else
                v364.name = "Minimum Damage";
                local l_x_0 = v364.position.x;
                local l_y_2 = v364.position.y;
                local l_x_1 = v364.size.x;
                local l_y_3 = v364.size.y;
                render.rect_outline(vector(l_x_0, l_y_2), vector(l_x_0 + l_x_1, l_y_2 + l_y_3), color(200, 200, 200, 255 * ui.get_alpha()), 1, 2);
                if v61.settings.damage[0].show:get() and v337.is_bind("Min. Damage") == false and ui.get_alpha() < 0.5 then
                    return;
                else
                    local v369 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get();
                    if v369 <= 0 then
                        v369 = "AUTO";
                    end;
                    local v370 = 0;
                    if not v59.lp.self then
                        v370 = ui.get_alpha() > 0 and 1 or 0;
                    else
                        v370 = (not not v59.lp.self:is_alive() or ui.get_alpha() > 0) and 1 or 0;
                    end;
                    render.text(1, vector(l_x_0 + 2, l_y_2 - 1), v61.settings.damage[0].color:get():alpha_modulate(255 * v370), nil, v369);
                    return;
                end;
            end;
        end, 8), 
        executer = function()
            -- upvalues: v337 (ref), v61 (ref), v59 (ref)
            v337.minimum_damage.element.enable = v61.settings.damage:get();
            if not v61.settings.damage:get() then
                return;
            elseif not v59.lp.self and ui.get_alpha() < 0.5 then
                return;
            else
                v337.minimum_damage.element:update();
                return;
            end;
        end
    };
    v337.manual_arrows = {
        font = render.load_font("Calibri", vector(24, 25), "ab"), 
        executer = function()
            -- upvalues: v59 (ref), l_smooth_0 (ref), v61 (ref), v29 (ref), v214 (ref), v337 (ref)
            local l_self_2 = v59.lp.self;
            local v372 = 0;
            if not l_self_2 then
                v372 = l_smooth_0.linear("Serenity", "Manual Arrows Alpha", ui.get_alpha() > 0);
            else
                v372 = l_smooth_0.linear("Serenity", "Manual Arrows Alpha", l_self_2:is_alive() or ui.get_alpha() > 0);
            end;
            if not v61.settings.arrows:get() then
                v372 = 0;
            end;
            if v372 == 0 then
                return;
            else
                local v373 = v29.screen.x * 0.5;
                local v374 = v29.screen.y * 0.5;
                local v375 = v61.settings.arrows[0];
                local v376 = {
                    size = 16, 
                    offset = v375.offset:get(), 
                    style = v375.style:get(), 
                    display = v375.display:get(), 
                    inverted = v214.main.inverter.tick ~= 0 and v214.main.inverter.active or rage.antiaim:inverter(), 
                    teamskeet = {
                        v375.colors:get("Manual")[1]:alpha_modulate(255 * v372), 
                        v375.colors:get("Inveted")[1]:alpha_modulate(255 * v372)
                    }, 
                    press_manual = v375.color:get()
                };
                if v376.style == "Teamskeet" then
                    v373 = v373 + 1;
                    if v376.display == "Always On" or v61["anti aim"].manual:get("Right") then
                        render.poly(v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] ~= "Disabled" and v61["anti aim"].manual:get("Right") and v376.teamskeet[1] or color(20, 20, 20, 180), vector(v373 + v376.offset + v376.size * 0.8, v374), vector(v373 + v376.offset, v374 - v376.size * 0.5), vector(v373 + v376.offset, v374 + v376.size * 0.5));
                    end;
                    render.rect(vector(v373 + v376.offset - 4, v374 - v376.size * 0.5), vector(v373 + v376.offset - 2, v374 + v376.size * 0.5), v376.inverted and v376.teamskeet[2] or color(20, 20, 20, 180));
                    v373 = v373 - 1;
                    if v376.display == "Always On" or v61["anti aim"].manual:get("Left") then
                        render.poly(v29.split(v61["anti aim"].type:list()[v61["anti aim"].type:get()], "  ")[2] ~= "Disabled" and v61["anti aim"].manual:get("Left") and v376.teamskeet[1] or color(20, 20, 20, 180), vector(v373 - v376.offset - v376.size * 0.8, v374), vector(v373 - v376.offset, v374 - v376.size * 0.5), vector(v373 - v376.offset, v374 + v376.size * 0.5));
                    end;
                    render.rect(vector(v373 - v376.offset + 2, v374 - v376.size * 0.5), vector(v373 - v376.offset + 4, v374 + v376.size * 0.5), not v376.inverted and v376.teamskeet[2] or color(20, 20, 20, 180));
                elseif v376.style == "Simple" then
                    local v377 = {
                        right = color(255, 255, 255, 128), 
                        left = color(255, 255, 255, 128)
                    };
                    if v376.display == "Always On" then
                        v377.right = v61["anti aim"].manual:get("Right") and v376.press_manual or v377.right;
                        v377.left = v61["anti aim"].manual:get("Left") and v376.press_manual or v377.left;
                    elseif v376.display == "Only on Manual" then
                        v377.right = v61["anti aim"].manual:get("Right") and v376.press_manual or color(255, 255, 255, 0);
                        v377.left = v61["anti aim"].manual:get("Left") and v376.press_manual or color(255, 255, 255, 0);
                    end;
                    render.text(v337.manual_arrows.font, vector(v373 + v376.offset + 2, v374 + 2), v377.right, "c", ">");
                    render.text(v337.manual_arrows.font, vector(v373 - v376.offset - 2, v374 + 2), v377.left, "c", "<");
                end;
                return;
            end;
        end
    };
    v337.screen_widgets = {
        drawwing = function(v378, v379, v380, v381, v382, v383)
            -- upvalues: v61 (ref)
            local v384 = v61.settings.widgets[0].style:get();
            local v385 = {
                accent = v61.settings.widgets[0].color:get(), 
                background = v61.settings.widgets[0].background:get()
            };
            if v384 == "Default" then
                v379 = v379 + 1;
                v381 = v381 - 1;
                local v386 = v385.background:alpha_modulate(v385.background.a * v383);
                render.rect_outline(vector(v378 - 1, v379 - 1), vector(v378 + v380 + 1, v379 + v381 + 1), v386);
                v386 = (v385.background * 0.5):alpha_modulate(v385.background.a * v383);
                render.rect(vector(v378, v379), vector(v378 + v380, v379 + v381), v386);
                v386 = (v385.background * 0.25):alpha_modulate(v385.background.a * v383);
                render.rect(vector(v378 + 2, v379 + 2), vector(v378 + v380 - 2, v379 + v381 - 2), v386);
            elseif v384 == "Modern" then
                v378 = v378 - 1;
                v380 = v380 + 2;
                local v387 = v385.accent:alpha_modulate(v385.accent.a * v383);
                local v388 = v385.background:alpha_modulate(0);
                render.gradient(vector(v378 - 1, v379 - 1), vector(v378 + v380 + 1, v379 + v381 + 1), v387, v387, v388, v388, 5);
                render.rect(vector(v378, v379), vector(v378 + v380, v379 + v381), v385.background:alpha_modulate(v385.background.a * v383), 5);
            elseif v384 == "Simple" then
                render.shadow(vector(v378, v379), vector(v378 + v380, v379 + v381), v385.accent:alpha_modulate(196 * v383), 32, nil, 5);
                render.rect(vector(v378, v379), vector(v378 + v380, v379 + v381), v385.background:alpha_modulate(v385.background.a * v383), 5);
            end;
            render.text(1, vector(v378 + v380 * 0.5, v379 + v381 * 0.5), color(255, 255, 255, 255 * v383), "c", v382);
        end, 
        spectators = {
            list = {}, 
            get = function(v389, v390)
                if not v390 then
                    v389.list = {};
                    return v389.list;
                else
                    local v391 = {};
                    if v390:is_alive() then
                        v391 = v390:get_spectators();
                    else
                        local l_m_hObserverTarget_0 = v390.m_hObserverTarget;
                        if not l_m_hObserverTarget_0 then
                            v389.list = {};
                            return v389.list;
                        else
                            v391 = l_m_hObserverTarget_0:get_spectators();
                        end;
                    end;
                    if v391 == {} then
                        v389.list = {};
                    end;
                    for v393 = 1, 64 do
                        v389.list[v393] = {
                            active = false, 
                            index = v393
                        };
                    end;
                    if v391 ~= nil then
                        for _, v395 in pairs(v391) do
                            local v396 = v395:get_index();
                            do
                                local l_v395_0 = v395;
                                v389.list[v396] = {
                                    index = v396, 
                                    avatar = l_v395_0:get_steam_avatar(), 
                                    active = (function()
                                        -- upvalues: l_v395_0 (ref), v390 (ref)
                                        if l_v395_0 == v390 then
                                            return false;
                                        else
                                            return true;
                                        end;
                                    end)()
                                };
                            end;
                        end;
                    end;
                    return v389.list;
                end;
            end
        }, 
        velocity_warning = {
            interval = 0, 
            image = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\warning.svg", vector(35, 35)), 
            RGBHB = function(v398, v399, v400)
                if not v399 then
                    v399 = 15;
                end;
                return (v400 and 255 or 125) * (v400 and 1.25 or 2) - (v400 and 64 or 125) * v398, (v400 and 200 or 195) * v398, v399;
            end, 
            remap = function(v401, v402, v403, v404, v405, v406)
                if not v404 then
                    v404 = 0;
                end;
                if not v405 then
                    v405 = 1;
                end;
                local v407 = (v401 - v404) / (v405 - v404);
                if v406 then
                    v407 = math.min(1, math.max(0, PCT));
                end;
                return v402 + (v403 - v402) * v407;
            end
        }, 
        defensive_indicator = {
            offset = 0, 
            time_out = 0, 
            image = render.load_image_from_file("nl\\Serenity\\LogoFull.png", vector(64, 64))
        }, 
        elements = {
            l_system_0.register(v61.settings.widgets[0].x_w, v61.settings.widgets[0].y_w, 100, 20, function(v408)
                -- upvalues: v29 (ref), v61 (ref), v59 (ref), v337 (ref)
                v408.name = "Watermark";
                if not v408.enable then
                    return;
                else
                    local v409 = 0;
                    local v410 = 0;
                    local l_x_2 = v408.size.x;
                    local l_y_4 = v408.size.y;
                    v408.position.x = v29.screen.x - l_x_2 - 5;
                    v408.position.y = 5;
                    v409 = v408.position.x;
                    v410 = v408.position.y;
                    v61.settings.widgets[0].x_w:set(v409);
                    v61.settings.widgets[0].y_w:set(v410);
                    local v413 = v61.settings.widgets[0].color:get():to_hex();
                    local v414 = ("\a%sserenity\aDEFAULT [%s] / %s   \a%s%s\aDEFAULT ms   \a%s%s\aDEFAULT time"):format(v413, v29.build:lower(), v29.username, v413, v59.lp.ping.real, v413, common.get_date("%H:%M"));
                    v337.screen_widgets.drawwing(v409, v410, l_x_2, l_y_4, v414, 1 * (v408.alpha / 255));
                    v408.size.x = render.measure_text(1, nil, v414).x + 7.5;
                    return;
                end;
            end, 8), 
            l_system_0.register(v61.settings.widgets[0].x_k, v61.settings.widgets[0].y_k, 100, 20, function(v415)
                -- upvalues: v61 (ref), v337 (ref), l_smooth_0 (ref)
                v415.name = "Keybinds";
                if not v415.enable then
                    return;
                else
                    local l_x_3 = v415.position.x;
                    local l_y_5 = v415.position.y;
                    local l_x_4 = v415.size.x;
                    local l_y_6 = v415.size.y;
                    if not v415.global_alpha then
                        v415.global_alpha = 0;
                    end;
                    local v420 = v61.settings.widgets[0].style:get();
                    local v421 = v61.settings.widgets[0].color:get():to_hex();
                    v337.screen_widgets.drawwing(l_x_3, l_y_5, l_x_4, l_y_6, ("\a%skeybinds\aDEFAULT"):format(v420 == "Default" and v421 or color(255, 255, 255, 255):to_hex()), v415.global_alpha / 255 * (v415.alpha / 255));
                    if not v415.size_x then
                        v415.size_x = 0;
                    end;
                    v415.size_x = 100;
                    local v422 = {
                        offset = 2, 
                        alpha = ui.get_alpha() * 255, 
                        list = ui.get_binds()
                    };
                    v422.executer = function()
                        -- upvalues: v422 (ref), l_smooth_0 (ref), v415 (ref), l_x_3 (ref), v420 (ref), l_y_5 (ref), l_x_4 (ref)
                        for v423 = 1, #v422.list do
                            local v424 = v422.list[v423];
                            local v425 = l_smooth_0.linear("Serenity", ("Keybinds Alpha %s"):format(v424.reference:name()), v424.active) * (v415.alpha / 255);
                            local v426 = v424.mode == 1 and "holding" or "toggled";
                            if type(v424.value) == "number" then
                                v426 = v424.value;
                            end;
                            v426 = ("[%s]"):format(v426);
                            render.text(1, vector(l_x_3 + (v420 == "Simple" and 2 or 1), l_y_5 + 20 + v422.offset), color(255, 255, 255, 255 * v425), nil, v424.name);
                            render.text(1, vector(l_x_3 + l_x_4 - (v420 == "Simple" and 2 or 1), l_y_5 + 20 + v422.offset), color(255, 255, 255, 255 * v425), "r", v426);
                            v422.offset = v422.offset + 13.5 * v425;
                            local v427 = render.measure_text(1, nil, v424.name).x + render.measure_text(1, nil, v426).x + 12;
                            if v415.size_x < v427 then
                                v415.size_x = v427;
                            end;
                            v422.alpha = v422.alpha + v425 * 255;
                        end;
                    end;
                    v422.executer();
                    v415.global_alpha = v422.alpha > 255 and 255 or v422.alpha;
                    v415.size.x = l_smooth_0.unclamped_lerp(v415.size.x, v415.size_x, 16);
                    return;
                end;
            end, 8), 
            l_system_0.register(v61.settings.widgets[0].x_s, v61.settings.widgets[0].y_s, 100, 20, function(v428)
                -- upvalues: v61 (ref), v337 (ref), v59 (ref), l_smooth_0 (ref)
                v428.name = "Spectators";
                if not v428.enable then
                    return;
                else
                    local l_x_5 = v428.position.x;
                    local l_y_7 = v428.position.y;
                    local l_x_6 = v428.size.x;
                    local l_y_8 = v428.size.y;
                    if not v428.global_alpha then
                        v428.global_alpha = 0;
                    end;
                    local v433 = v61.settings.widgets[0].style:get();
                    local v434 = v61.settings.widgets[0].color:get():to_hex();
                    v337.screen_widgets.drawwing(l_x_5, l_y_7, l_x_6, l_y_8, ("\a%sspectators\aDEFAULT"):format(v433 == "Default" and v434 or color(255, 255, 255, 255):to_hex()), v428.global_alpha / 255 * (v428.alpha / 255));
                    if not v428.size_x then
                        v428.size_x = 0;
                    end;
                    v428.size_x = 100;
                    local v435 = {
                        offset = 2, 
                        alpha = ui.get_alpha() * 255, 
                        list = v337.screen_widgets.spectators:get(v59.lp.self)
                    };
                    v435.executer = function()
                        -- upvalues: v435 (ref), l_smooth_0 (ref), v428 (ref), l_x_5 (ref), v433 (ref), l_y_7 (ref), l_x_6 (ref), v337 (ref)
                        for v436 = 1, #v435.list do
                            local v437 = v435.list[v436];
                            local v438 = entity.get(v437.index);
                            if v438 then
                                local v439 = string.sub(v438:get_name(), 1, 24);
                                local v440 = l_smooth_0.linear("Serenity", ("Spectators Alpha %s"):format(v438:get_name()), v437.active) * (v428.alpha / 255);
                                render.text(1, vector(l_x_5 + (v433 == "Simple" and 2 or 1), l_y_7 + 20 + v435.offset), color(255, 255, 255, 255 * v440), nil, v439);
                                if v437.avatar and v437.avatar.width >= 8 then
                                    render.texture(v437.avatar, vector(l_x_5 + l_x_6 - 10 - (v433 == "Simple" and 2 or 1), l_y_7 + 20 + 2 + v435.offset), vector(10, 10), color(255, 255, 255, 255 * v440), 2);
                                else
                                    render.texture(v337.screen_widgets.spectators.undefined, vector(l_x_5 + l_x_6 - 12 - (v433 == "Simple" and 2 or 1), l_y_7 + 20 + 2 + v435.offset), vector(10, 10), color(255, 255, 255, 255 * v440), 2);
                                end;
                                v435.offset = v435.offset + 13.5 * v440;
                                local v441 = (render.measure_text(1, nil, v439).x + 10 + 12) * v440;
                                if v428.size_x < v441 then
                                    v428.size_x = v441;
                                end;
                                v435.alpha = v435.alpha + v440 * 255;
                            end;
                        end;
                    end;
                    v435.executer();
                    v428.global_alpha = v435.alpha > 255 and 255 or v435.alpha;
                    v428.size.x = l_smooth_0.unclamped_lerp(v428.size.x, v428.size_x, 16);
                    return;
                end;
            end, 8), 
            l_system_0.register(v61.settings.widgets[0].x_v, v61.settings.widgets[0].y_v, 150, 45, function(v442)
                -- upvalues: l_smooth_0 (ref), v29 (ref), v61 (ref), v59 (ref), v337 (ref)
                v442.name = "Velocity Warning";
                if not v442.enable then
                    return;
                else
                    local l_x_7 = v442.position.x;
                    local l_y_9 = v442.position.y;
                    local l_x_8 = v442.size.x;
                    local l_y_10 = v442.size.y;
                    local v447 = ui.get_alpha() * (v442.alpha / 255);
                    render.rect_outline(vector(l_x_7, l_y_9), vector(l_x_7 + l_x_8, l_y_9 + l_y_10), color(255, 255, 255, 255 * v447), 1, 3);
                    local v448 = ui.get_mouse_position();
                    if v447 ~= 0 then
                        local v449 = l_smooth_0.linear("Serenity", "Velocity Warning Mouse Alpha", l_x_7 < v448.x and v448.x < l_x_7 + l_x_8 and l_y_9 < v448.y and v448.y < l_y_9 + l_y_10) * v447;
                        if v449 > 0 then
                            render.text(1, vector(l_x_7, l_y_9 + l_y_10), color(222, 222, 222, 255 * v449), nil, "Press RMB to center align");
                            if common.is_button_down(2) then
                                v442.position.x = v29.screen.x * 0.5 - v442.size.x * 0.5 - 0.5;
                                v61.settings.widgets[0].x_v:set(v442.position.x);
                            end;
                        end;
                    end;
                    l_x_7 = l_x_7 + 5;
                    l_y_9 = l_y_9 + 5;
                    local v450;
                    if v59.lp.self == nil then
                        v450 = v447 >= 0.5 and 0.5 or 1;
                    else
                        v450 = v59.lp.self:is_alive() and v59.lp.self.m_flVelocityModifier or 0.5;
                    end;
                    local v451, v452, v453 = v337.screen_widgets.velocity_warning.RGBHB(v450, 13);
                    local v454 = v337.screen_widgets.velocity_warning.remap(v450, 1, 0, 0.85, 1);
                    v454 = (v447 > 0 and v447 or v454) * v442.lp_alpha * (v442.alpha / 255);
                    v337.screen_widgets.velocity_warning.interval = v337.screen_widgets.velocity_warning.interval + (1 - v450) * 0.7 + 0.3;
                    render.texture(v337.screen_widgets.velocity_warning.image, vector(l_x_7 - 3, l_y_9 - 4), vector(41, 41), color(16, 16, 16, 255 * v454));
                    if v454 > 0.7 then
                        render.rect(vector(l_x_7 + 13, l_y_9 + 11), vector(l_x_7 + 13 + 8, l_y_9 + 11 + 20), color(16, 16, 16, 255 * v454));
                    end;
                    local v455 = math.abs((v337.screen_widgets.velocity_warning.interval * 0.01 % 2 - 1) * 255);
                    render.texture(v337.screen_widgets.velocity_warning.image, vector(l_x_7, l_y_9), vector(35, 35), color(v451, v452, v453, v455 * v454));
                    render.text(1, vector(l_x_7 + 35 + 8, l_y_9 + 3), color(255, 255, 255, 255 * v454), "b", string.format("%s %d%%", "Slowed down", v450 * 100));
                    local v456 = l_x_7 + 35 + 8;
                    local v457 = l_y_9 + 3 + 17;
                    local v458 = 95;
                    local v459 = 12;
                    render.rect_outline(vector(v456, v457), vector(v456 + v458, v457 + v459), color(0, 0, 0, 255 * v454));
                    render.rect(vector(v456 + 1, v457 + 1), vector(v456 + 1 + v458 - 2, v457 + 1 + v459 - 2), color(16, 16, 16, 180 * v454));
                    render.rect(vector(v456 + 1, v457 + 1), vector(v456 + 1 + math.floor((v458 - 2) * v450), v457 + 1 + v459 - 2), color(v451, v452, v453, 180 * v454));
                    return;
                end;
            end, 8), 
            l_system_0.register(v61.settings.widgets[0].x_d, v61.settings.widgets[0].y_d, 150, 65, function(v460)
                -- upvalues: l_smooth_0 (ref), v29 (ref), v61 (ref), v60 (ref), v337 (ref)
                v460.name = "Defensive Indicator";
                if not v460.enable then
                    return;
                else
                    local l_x_9 = v460.position.x;
                    local l_y_11 = v460.position.y;
                    local l_x_10 = v460.size.x;
                    local l_y_12 = v460.size.y;
                    local v465 = ui.get_alpha() * (v460.alpha / 255);
                    render.rect_outline(vector(l_x_9, l_y_11), vector(l_x_9 + l_x_10, l_y_11 + l_y_12), color(255, 255, 255, 255 * v465), 1, 3);
                    local v466 = ui.get_mouse_position();
                    if v465 ~= 0 then
                        local v467 = l_smooth_0.linear("Serenity", "Defensive Indicator Mouse Alpha", l_x_9 < v466.x and v466.x < l_x_9 + l_x_10 and l_y_11 < v466.y and v466.y < l_y_11 + l_y_12) * v465;
                        if v467 > 0 then
                            render.text(1, vector(l_x_9, l_y_11 + l_y_12), color(222, 222, 222, 255 * v467), nil, "Press RMB to center align");
                            if common.is_button_down(2) then
                                v460.position.x = v29.screen.x * 0.5 - v460.size.x * 0.5 - 0.5;
                                v61.settings.widgets[0].x_d:set(v460.position.x);
                            end;
                        end;
                    end;
                    local v468 = false;
                    if v60.rage_bot["Hide Shots"].self:get_override() or v60.rage_bot["Hide Shots"].self:get() then
                        if v60.rage_bot["Hide Shots"].options:get_override() then
                            v468 = v60.rage_bot["Hide Shots"].options:get_override() == "Break LC";
                        else
                            v468 = v60.rage_bot["Hide Shots"].options:get() == "Break LC";
                        end;
                    end;
                    if v60.rage_bot["Double Tap"].self:get_override() or v60.rage_bot["Double Tap"].self:get() then
                        if v60.rage_bot["Double Tap"].options:get_override() then
                            v468 = v60.rage_bot["Double Tap"].options:get_override() == "Always On";
                        else
                            v468 = v60.rage_bot["Double Tap"].options:get() == "Always On";
                        end;
                    end;
                    local v469 = 1;
                    if globals.tickcount % 8 > utils.random_int(2, 7) and v468 then
                        v469 = 3;
                    end;
                    if v469 > 1 then
                        v337.screen_widgets.defensive_indicator.time_out = globals.realtime + 0.24;
                    end;
                    local v470 = (l_smooth_0.linear("Serenity", "Defensive Indicator", v337.screen_widgets.defensive_indicator.time_out > globals.realtime) + v465) * v460.lp_alpha * (v460.alpha / 255);
                    v337.screen_widgets.defensive_indicator.offset = l_smooth_0.lerp(v337.screen_widgets.defensive_indicator.offset, l_x_10 * v469, 32);
                    l_y_11 = l_y_11 + 10;
                    local v471 = v61.settings.widgets[0].color:get();
                    render.texture(v337.screen_widgets.defensive_indicator.image, vector(l_x_9 + l_x_10 * 0.5 - 16 - 2, l_y_11 - 5), vector(32, 32), v471 * color(255, 255, 255, 255 * v470));
                    render.text(1, vector(l_x_9 + l_x_10 * 0.5, l_y_11 + l_y_12 * 0.25 + 15), color(255, 255, 255, 255 * v470), "c", "defensive choking");
                    render.shadow(vector(l_x_9 + l_x_10 * 0.15, l_y_11 + l_y_12 * 0.25 + 25), vector(l_x_9 + l_x_10 - l_x_10 * 0.15, l_y_11 + l_y_12 * 0.25 + 30), v471 * color(255, 255, 255, 255 * v470), 24, nil, 3);
                    render.rect(vector(l_x_9 + v337.screen_widgets.defensive_indicator.offset * 0.15, l_y_11 + l_y_12 * 0.25 + 25), vector(l_x_9 + l_x_10 - v337.screen_widgets.defensive_indicator.offset * 0.15, l_y_11 + l_y_12 * 0.25 + 30), v471 * color(255, 255, 255, 255 * v470), 3);
                    return;
                end;
            end, 8)
        }, 
        executer = function()
            -- upvalues: v59 (ref), v337 (ref), v61 (ref), l_smooth_0 (ref)
            local v472 = 0;
            if not v59.lp.self then
                v472 = ui.get_alpha() > 0 and 1 or 0;
            else
                v472 = (not not v59.lp.self:is_alive() or ui.get_alpha() > 0) and 1 or 0;
            end;
            for v473 = 1, #v337.screen_widgets.elements do
                local v474 = v337.screen_widgets.elements[v473];
                if not v474.alpha then
                    v474.alpha = 0;
                end;
                v474.lp_alpha = v472;
                v474:update();
            end;
            for v475 = 1, #v337.screen_widgets.elements do
                local v476 = v337.screen_widgets.elements[v475];
                if not v476.alpha then
                    v476.alpha = 0;
                end;
                if v61.settings.widgets:get() and v61.settings.widgets[0].display:get(v476.name) then
                    v476.alpha = l_smooth_0.unclamped_lerp(v476.alpha, 255, 12);
                else
                    v476.alpha = l_smooth_0.unclamped_lerp(v476.alpha, 0, 12);
                end;
                v476.enable = v476.alpha ~= 0;
            end;
        end
    };
    v337.watermark = {
        logo_16 = render.load_image_from_file("nl\\Serenity\\LogoSmall.png", vector(32, 32)), 
        always_mark = function()
            -- upvalues: v61 (ref), v29 (ref), v337 (ref)
            if v61.settings.widgets:get() and v61.settings.widgets[0].display:get("Watermark") then
                return;
            elseif not v61.settings.watermark:get("Simple") then
                return;
            else
                local v477 = v61.settings.watermark[0].color:get():alpha_modulate(255);
                local v478 = v477:alpha_modulate(0);
                local v479 = "discord.gg/serenitylua";
                local v480 = render.measure_text(1, nil, v479);
                local v481 = vector(v29.screen.x - v480.x - 10, 15);
                render.gradient(v481 - vector(45, 10), v481 + vector(v480.x + 5, 10), v478, v477, v478, v477, 4);
                render.texture(v337.watermark.logo_16, v481 + vector(v480.x - 17, -7), vector(16, 16), color(16, 16, 16, 255));
                render.texture(v337.watermark.logo_16, v481 + vector(v480.x - 18, -8), vector(16, 16), color(255, 255, 255, 255));
                render.text(1, v481 + vector(v480.x * 0.5 - 22, 0), color(), "c", v479);
                return;
            end;
        end, 
        executer = function()
            -- upvalues: v61 (ref), l_monylinear_0 (ref), v337 (ref), v29 (ref)
            local v482 = v61.settings.watermark[0];
            local v483 = v61.settings.watermark:get();
            local v484 = v482.color:get():alpha_modulate(255);
            if v483 == "Serenity" or v483 == "Emoji" then
                local v485 = v482.position:get();
                local v486 = l_monylinear_0:Animate(v483 == "Emoji" and "\240\159\134\130 \240\159\133\180 \240\159\134\129 \240\159\133\180 \240\159\133\189 \240\159\133\184 \240\159\134\131 \240\159\134\136" or "S E R E N I T Y", {
                    v484, 
                    color(60, 60, 60, 255)
                }, 2);
                if v485 == "Below" then
                    local v487 = v482.type:get();
                    if v487 == "Full" or v487 == "Only Logo" then
                        render.texture(v337.watermark.logo, vector(v29.screen.x * 0.5 - 12.5, v29.screen.y - 50 + (v487 == "Only Logo" and 20 or 0)), vector(25, 25), v484);
                    end;
                    if v487 == "Full" or v487 == "Only Text" then
                        render.text(1, vector(v29.screen.x * 0.5, v29.screen.y - 12.5), v484, "c", ("%s"):format(v486));
                    end;
                else
                    local v488 = render.measure_text(1, nil, v486) * 0.5;
                    if v485 == "Left" then
                        render.text(1, vector(v488.x + 20, v29.screen.y * 0.5 + 10), v484, "c", ("%s"):format(v486));
                    elseif v485 == "Right" then
                        render.text(1, vector(v29.screen.x - v488.x - 20, v29.screen.y * 0.5 + 10), v484, "c", ("%s"):format(v486));
                    end;
                end;
            elseif v483 == "Anime" then
                render.texture(v337.watermark.anime, vector(5, v29.screen.y * 0.5), vector(33.75, 47.8125));
                render.text(2, vector(42, v29.screen.y * 0.5 + 25 - 8), color(255, 255, 255, 255), "l", ("Serenity  \a%s[%s]"):format(v484:to_hex(), v29.build):upper());
                render.text(2, vector(42, v29.screen.y * 0.5 + 25 + 2), color(255, 255, 255, 255), "l", ("User  -  \a%s%s"):format(v484:to_hex(), v29.username):upper());
            end;
        end
    };
    v337.skeet = {
        offset = 0, 
        font = render.load_font("Calibri", vector(24, 23.5), "ab"), 
        bomb = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(64, 64)), 
        planting = {
            self = false, 
            time = 0, 
            site = ""
        }, 
        vars = {
            shots = 0, 
            hits = 0
        }, 
        shadow = function(_, v490, v491, v492)
            -- upvalues: l_gradient_0 (ref)
            local v493 = v492:alpha_modulate(0);
            l_gradient_0(v490 - vector(20), vector(v490.x + v491.x * 0.5, v491.y), v493, v492, v493, v492);
            l_gradient_0(vector(v490.x + v491.x * 0.5, v490.y), v491 + vector(20), v492, v493, v492, v493);
        end, 
        render = function(v494, v495, v496, v497)
            -- upvalues: v29 (ref), l_text_0 (ref)
            local v498 = v497 and (" %s"):format(v495) or v495;
            local v499 = render.measure_text(v494.font, nil, v498);
            local v500 = v497 and 32 or 0;
            v499.x = v500 + v499.x;
            local v501 = vector(25, v29.screen.y / 1.55 - 1 + (v499.y + 16) * v494.offset);
            v494:shadow(v501 - vector(10, 7), v501 + vector(v499.x + 7, v499.y + 2), color(0, 0, 0, 50));
            if v497 then
                render.texture(v494.bomb, v501 - vector(0, 6), vector(32, 32), v496);
            end;
            l_text_0(v494.font, v501 + vector(v500, 0), color(0, 100), nil, v498);
            l_text_0(v494.font, v501 + vector(v500, 1), color(0, 55), nil, v498);
            l_text_0(v494.font, v501 + vector(v500 + 1, 1), color(0, 100), nil, v498);
            l_text_0(v494.font, v501 + vector(v500, 0), v496, nil, v498);
            return vector(v501.x + render.measure_text(v494.font, nil, v498).x, v501.y);
        end, 
        clear_planting_info = function(v502)
            v502.planting.self = false;
            v502.planting.time = 0;
            v502.planting.site = "";
        end, 
        bomb_begin_plant = function(v503, v504)
            local v505 = entity.get_player_resource();
            if not v505 then
                return;
            else
                local v506 = {
                    a = v505.m_bombsiteCenterA, 
                    b = v505.m_bombsiteCenterB
                };
                local v507 = entity.get(v504.site);
                if not v507 then
                    return;
                else
                    local v508 = v507.m_vecMins:lerp(v507.m_vecMaxs, 0.5);
                    if not v508 then
                        return;
                    else
                        local v509 = {
                            a = v508:distsqr(v506.a), 
                            b = v508:distsqr(v506.b)
                        };
                        v503.planting.self = true;
                        v503.planting.time = globals.curtime;
                        v503.planting.site = v509.b > v509.a and "A" or "B";
                        return;
                    end;
                end;
            end;
        end, 
        aim_ack = function(v510, v511)
            v510.vars.shots = v510.vars.shots + 1;
            if not v511.state then
                v510.vars.hits = v510.vars.hits + 1;
            end;
        end, 
        get_spectators = function(v512)
            local v513 = nil;
            if v512:is_alive() then
                v513 = v512:get_spectators();
            else
                local l_m_hObserverTarget_1 = v512.m_hObserverTarget;
                if not l_m_hObserverTarget_1 or not entity.get(l_m_hObserverTarget_1) then
                    return;
                else
                    v513 = l_m_hObserverTarget_1:get_spectators();
                end;
            end;
            return v513;
        end, 
        executer = function(v515)
            -- upvalues: v59 (ref), v61 (ref), v337 (ref), v60 (ref), v29 (ref), v214 (ref)
            local l_self_3 = v59.lp.self;
            if not l_self_3 or not v61.settings.skeet:get() then
                return;
            else
                local v517 = {
                    gear = v61.settings.skeet[0]
                };
                v515.offset = 1;
                if l_self_3:is_alive() or ui.get_alpha() > 0 then
                    local v518 = v337.is_bind("Hit Chance");
                    if v517.gear.display:get("Hit Chance") and v518 then
                        v515:render("HITCHANCE OVR", color(255, 255, 255, 245), false);
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Aimbot Stats") then
                        local v519 = 0;
                        if v515.vars.hits ~= 0 or v515.vars.shots ~= 0 then
                            v519 = v515.vars.hits / v515.vars.shots * 100;
                        end;
                        v515:render(("%i / %i (%.1f)"):format(v515.vars.hits, v515.vars.shots, v519), color(255, 255, 255, 245), false);
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Fake Latency") and (v60.main["Fake Latency"].self:get_override() and v60.main["Fake Latency"].self:get_override() ~= 0 or v60.main["Fake Latency"].self:get() ~= 0) then
                        local l_incoming_0 = v59.lp.ping.incoming;
                        local v521 = color();
                        if l_incoming_0 < 0.5 then
                            v521 = v29.percentage(l_incoming_0 * 2, color(165, 195, 40), color(255, 235, 160));
                        else
                            v521 = v29.percentage((l_incoming_0 - 0.5) * 2, color(170, 235, 15), color(165, 195, 40));
                        end;
                        do
                            local l_v521_0 = v521;
                            pcall(function()
                                -- upvalues: v337 (ref), v515 (ref), l_v521_0 (ref)
                                local _ = v337.is_bind("Fake Latency");
                                v515:render("PING", l_v521_0:alpha_modulate(205), false);
                                v515.offset = v515.offset - 1;
                            end);
                        end;
                    end;
                    if v517.gear.display:get("Double Tap") and not v214.reference.misc.fake_duck:get() and (v60.rage_bot["Double Tap"].self:get_override() or v60.rage_bot["Double Tap"].self:get()) then
                        local v524 = color(255, 255, 255, 205);
                        if rage.exploit:get() ~= 1 then
                            v524 = color(255, 0, 50, 245);
                        end;
                        v515:render("DT", v524, false);
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Hide Shots") and not v214.reference.misc.fake_duck:get() and not v60.rage_bot["Double Tap"].self:get_override() and not v60.rage_bot["Double Tap"].self:get() and (v60.rage_bot["Hide Shots"].self:get_override() or v60.rage_bot["Hide Shots"].self:get()) then
                        v515:render("OSAA", color(255, 255, 255, 205), false);
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Dormant Aimbot") and (v60.rage_bot.Enabled.dormant_aimbot:get_override() or v60.rage_bot.Enabled.dormant_aimbot:get()) then
                        local v525 = color(255, 255, 255, 205);
                        local v526 = entity.get_threat();
                        if v526 and v526:is_dormant() then
                            v525 = color(255, 0, 50, 245);
                        end;
                        v515:render("DA", v525, false);
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Fake Duck") and (v214.reference.misc.fake_duck:get_override() or v214.reference.misc.fake_duck:get()) then
                        v515:render("DUCK", color(255, 255, 255, 205));
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Safe Points") and (v60.rage_bot["Safe Points"].self:get_override() and v60.rage_bot["Safe Points"].self:get_override() == "Force" or v60.rage_bot["Safe Points"].self:get() == "Force") then
                        v515:render("SAFE", color(255, 255, 255, 205));
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Body Aim") and (v60.rage_bot["Body Aim"].self:get_override() and v60.rage_bot["Body Aim"].self:get_override() == "Force" or v60.rage_bot["Body Aim"].self:get() == "Force") then
                        v515:render("BODY", color(255, 255, 255, 205));
                        v515.offset = v515.offset - 1;
                    end;
                    local v527 = v337.is_bind("Min. Damage");
                    if v517.gear.display:get("Minimum Damage") and v527 then
                        v515:render("MD", color(255, 255, 255, 205));
                        v515.offset = v515.offset - 1;
                    end;
                    if v517.gear.display:get("Freestanding") and (v214.reference.freestanding.self:get_override() or v214.reference.freestanding.self:get()) then
                        v515:render("FS", color(255, 255, 255, 205));
                        v515.offset = v515.offset - 1;
                    end;
                end;
                entity.get_entities("CPlantedC4", false, function(v528)
                    -- upvalues: v517 (ref), v29 (ref), l_self_3 (ref), v515 (ref)
                    if not v528 or v528.m_bBombDefused then
                        return;
                    else
                        if v517.gear.display:get("Bomb Info") or v517.gear.display:get("Defusing") then
                            local v529 = v528.m_flC4Blow - globals.curtime;
                            if v529 >= 0 then
                                local v530 = {
                                    timer = 0, 
                                    start = v528.m_hBombDefuser ~= nil, 
                                    length = v528.m_flDefuseLength
                                };
                                v530.timer = v530.start and (v528.m_flDefuseCountDown - globals.curtime) / 1 or -1;
                                if v530.timer > 0 and v517.gear.display:get("Defusing") then
                                    local v531 = v530.timer < v529 and color(40, 140, 50, 200) or color(200, 24, 0, 200);
                                    render.rect(vector(0, 0), vector(20, v29.screen.y), color(5, 5, 5, 200));
                                    render.rect(vector(1, v29.screen.y - (v29.screen.y + 70) / v530.length * v530.timer), vector(19, v29.screen.y), v531);
                                end;
                                local v532 = v528.m_nBombSite == 0 and "A" or "B";
                                local v533 = l_self_3:is_alive() and l_self_3 or l_self_3.m_hObserverTarget;
                                local v534 = v533 and v533.m_iHealth or 0;
                                if v517.gear.display:get("Bomb Info") then
                                    v515:render(("%s - %.1fs"):format(v532, v529), color(255, 255, 255, 205), true);
                                    v515.offset = v515.offset - 1;
                                end;
                                if v533 then
                                    local v535 = v533:get_origin():dist(v528:get_origin());
                                    local v536 = 0;
                                    v536 = 500;
                                    local v537 = v536 * 3.5;
                                    v536 = v536 * math.exp(-(v535 * v535 / (v537 * 2 / 3 * (v537 / 3))));
                                    v536 = math.max(v536, 0);
                                    local v538 = {
                                        bonus = 0.5, 
                                        ratio = 0.5, 
                                        value = v533.m_ArmorValue or 0
                                    };
                                    if v538.value > 0 then
                                        local v539 = v536 * v538.ratio;
                                        if (v536 - v539) * v538.bonus > v538.value then
                                            v539 = v536 - v538.value * (1 / v538.bonus);
                                        end;
                                        v536 = v539;
                                    end;
                                    if v517.gear.display:get("Bomb Info") and v533 then
                                        if v534 < v536 then
                                            v515:render("FATAL", color(255, 0, 50, 245), false);
                                            v515.offset = v515.offset - 1;
                                        elseif v536 > 1 then
                                            v515:render(("-%i HP"):format(v536), color(252, 243, 105, 205), false);
                                            v515.offset = v515.offset - 1;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        return;
                    end;
                end);
                if v515.planting.self and v517.gear.display:get("Bomb Info") then
                    local v540 = v515:render(("%s"):format(v515.planting.site), color(252, 243, 105, 205), true);
                    v515.offset = v515.offset - 1;
                    local v541 = 3.125 - (3.125 + v515.planting.time - globals.curtime);
                    if v541 > 3.125 then
                        v541 = 3.125;
                    end;
                    local l_x_11 = render.measure_text(v515.font, nil, v515.planting_site).x;
                    render.circle_outline(vector(l_x_11 + v540.x + 48.5, v540.y + 9), color(0, 0, 0, 200), 11, 0, 1, 5);
                    render.circle_outline(vector(l_x_11 + v540.x + 48.5, v540.y + 9), color(213, 213, 214, 255), 10, 0, v541 * 0.32114155788, 3);
                    if v541 * 0.32114155788 > 0.99 then
                        v337.skeet:clear_planting_info();
                    end;
                end;
                return;
            end;
        end, 
        spectators = function(v543)
            -- upvalues: v59 (ref), v61 (ref), v29 (ref)
            local l_self_4 = v59.lp.self;
            if not l_self_4 or not v61.settings.skeet:get() or not v61.settings.skeet[0].spectators:get() then
                return;
            else
                local v545 = v543.get_spectators(l_self_4);
                if not v545 then
                    return;
                else
                    local v546 = v61.settings.skeet[0].offset:get();
                    for v547 = 1, #v545 do
                        if v545[v547] and entity.get(v545[v547]) then
                            local v548 = v545[v547]:get_name();
                            if v548 ~= "GOTV" then
                                render.text(1, vector(v29.screen.x - 10, 5 + v546), color(255, 200), "r", v548);
                                v546 = v546 + 20;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end
    };
    v337.custom_scope = {
        executer = function()
            -- upvalues: v59 (ref), v61 (ref), l_smooth_0 (ref), v29 (ref)
            local l_self_5 = v59.lp.self;
            if not l_self_5 or not v61.settings.scope:get() then
                return;
            else
                local v550 = l_smooth_0.linear("Slowed", "Custom Scope", l_self_5.m_bIsScoped and l_self_5:is_alive());
                if v550 == 0 then
                    return;
                else
                    local v551 = v29.screen.x * 0.5;
                    local v552 = v29.screen.y * 0.5;
                    local v553 = {
                        gear = v61.settings.scope[0]
                    };
                    v553.start = v553.gear.start:get();
                    v553.length = v553.gear.length:get() * v550;
                    v553.inverter = v553.gear.inverter:get();
                    v553.hidden = v553.gear.hidden;
                    v553.color_t = v553.gear.color:get();
                    v553.color_n = color(255, 255, 255, 255);
                    local l_a_0 = v553.color_t.a;
                    v553.color_t = v553.color_t:alpha_modulate((v553.inverter and 0 or l_a_0) * v550);
                    v553.color_n = v553.color_t:alpha_modulate((v553.inverter and l_a_0 or 0) * v550);
                    if not v553.hidden:get("Up") then
                        render.gradient(vector(v551, v552 - v553.start + 1), vector(v551 + 1, v552 - v553.start - v553.length - 1), v553.color_t, v553.color_t, v553.color_n, v553.color_n);
                    end;
                    if not v553.hidden:get("Down") then
                        render.gradient(vector(v551, v552 + v553.start), vector(v551 + 1, v552 + v553.start + v553.length), v553.color_t, v553.color_t, v553.color_n, v553.color_n);
                    end;
                    if not v553.hidden:get("Left") then
                        render.gradient(vector(v551 - v553.start - v553.length - 1, v552), vector(v551 - v553.start + 1, v552 + 1), v553.color_n, v553.color_t, v553.color_n, v553.color_t);
                    end;
                    if not v553.hidden:get("Right") then
                        render.gradient(vector(v551 + v553.start, v552), vector(v551 + v553.start + v553.length, v552 + 1), v553.color_t, v553.color_n, v553.color_t, v553.color_n);
                    end;
                    return;
                end;
            end;
        end
    };
    v337.clantag = {
        last = "", 
        multiplier_text = function(v555, v556)
            local v557 = "";
            for _ = 1, v556 do
                v557 = ("%s%s"):format(v557, v555);
            end;
            return v557;
        end, 
        to_tick = function(v559, v560, v561)
            -- upvalues: v337 (ref)
            local v562 = (globals.tickcount + math.floor(v561.avg_latency[0] + 0.22 / globals.tickinterval + 0.5)) / math.floor(0.3 / globals.tickinterval + 0.5);
            v562 = math.floor(v562 % #v560);
            v562 = v560[v562 + 1] + (v562 > 18 and 0.75 or 2);
            return string.sub(("%s%s%s"):format(v337.clantag.multiplier_text(" ", 15), v559, v337.clantag.multiplier_text(" ", 22)), v562, v562 + 15);
        end, 
        executer = function()
            -- upvalues: v61 (ref), v337 (ref)
            if not v61.settings.clantag:get() then
                if v337.clantag.last ~= "" then
                    common.set_clan_tag("");
                    ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"):override(nil);
                    v337.clantag.last = "";
                end;
                return;
            else
                ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"):override(false);
                local v563 = utils.net_channel();
                if not v563 then
                    return;
                else
                    local v564 = v337.clantag.to_tick("serenity", {
                        [1] = 25, 
                        [2] = 24, 
                        [3] = 24, 
                        [4] = 23, 
                        [5] = 22, 
                        [6] = 21, 
                        [7] = 20, 
                        [8] = 19, 
                        [9] = 18, 
                        [10] = 17, 
                        [11] = 16, 
                        [12] = 15, 
                        [13] = 14, 
                        [14] = 13, 
                        [15] = 12, 
                        [16] = 12, 
                        [17] = 12, 
                        [18] = 12, 
                        [19] = 12, 
                        [20] = 12, 
                        [21] = 12, 
                        [22] = 11, 
                        [23] = 10, 
                        [24] = 9, 
                        [25] = 8, 
                        [26] = 7, 
                        [27] = 6, 
                        [28] = 5, 
                        [29] = 4, 
                        [30] = 3, 
                        [31] = 2, 
                        [32] = 1
                    }, v563);
                    local v565 = entity.get_game_rules();
                    if not v565 then
                        return;
                    else
                        if v565.m_gamePhase == 5 or v565.m_gamePhase == 4 then
                            v564 = v337.clantag.to_tick("serenity", {
                                [1] = 12
                            }, v563);
                        end;
                        if v564 ~= v337.clantag.last then
                            common.set_clan_tag(("\226\156\189 %s"):format(v564));
                        end;
                        v337.clantag.last = v564;
                        return;
                    end;
                end;
            end;
        end
    };
    v337.aimbot_logs = {
        image = render.load_image_from_file("nl\\Serenity\\LogoSmall.png", vector(16, 16)), 
        list = {}, 
        hit_groups = {
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
        render = function()
            -- upvalues: v59 (ref), v61 (ref), v337 (ref), v29 (ref), l_smooth_0 (ref)
            if not v59.lp.self or not v61.settings.logs:get() then
                v337.aimbot_logs.list = {};
                return;
            else
                local v566 = v61.settings.logs[0];
                local v567 = v566.style:get();
                local v568 = v566.offset:get();
                local v569 = v29.screen.x * 0.5;
                local v570 = v29.screen.y * 0.75;
                local l_v568_0 = v568;
                local v572 = {};
                for v573 = #v337.aimbot_logs.list, 1, -1 do
                    local v574 = v337.aimbot_logs.list[v573];
                    if globals.curtime - v574.time < 4 and (#v337.aimbot_logs.list <= 7 or v573 >= #v337.aimbot_logs.list - 7) then
                        if v574.offset < 255 then
                            v574.offset = l_smooth_0.unclamped_lerp(v574.offset, 255, 16);
                        end;
                        if v574.position < 255 then
                            v574.position = l_smooth_0.unclamped_lerp(v574.position, 255, 16);
                        end;
                    elseif v574.position > 0 then
                        v574.position = l_smooth_0.unclamped_lerp(v574.position, -1, 16);
                    else
                        table.insert(v572, v573);
                    end;
                    local v575 = v574.position / 255;
                    l_v568_0 = l_v568_0 - v574.offset / 255 * (v567 == "Default" and 35 or 30);
                    local v576 = "";
                    for _, v578 in pairs(v574.object) do
                        local v579 = v578[2];
                        if v578[3] == "damage" then
                            v579 = v574.damage;
                        end;
                        v576 = v576 .. ("\a%02x%02x%02x%02x%s"):format(v578[1].r, v578[1].g, v578[1].b, 255, v579);
                    end;
                    local l_x_12 = render.measure_text(1, nil, v576).x;
                    local v581 = vector(v569, v570 - l_v568_0 - 75);
                    local v582 = v61.settings.logs[0].colors:get("\aFFFFFF001\aDEFAULTGlow")[1];
                    v582.a = v582.a * v575;
                    if v567 == "Default" then
                        render.shadow(v581 - vector(l_x_12 * 0.5 + 15, 0), v581 + vector(l_x_12 * 0.5 + 15, 25), v582, 24, nil, 4);
                        render.rect(v581 - vector(l_x_12 * 0.5 + 15, 0), v581 + vector(l_x_12 * 0.5 + 15, 25), color(16, 16, 16, 192 * v575), 4);
                        render.texture(v337.aimbot_logs.image, v581 + vector(-(l_x_12 * 0.5) + 5 - 14, 4), vector(16, 16), v574.color * color(255, 255, 255, 255 * v575));
                        render.text(1, v581 + vector(10, 12.5), color(255, 255, 255, 255 * v575), "c", v576);
                    elseif v567 == "Gamesense" then
                        l_x_12 = l_x_12 + 6;
                        render.rect(v581 - vector(l_x_12 * 0.5 + 5, 13.5), v581 + vector(l_x_12 * 0.5 + 5, 13.5), color(30, 30, 30, 255 * v575));
                        render.rect(v581 - vector(l_x_12 * 0.5 + 4, 12.5), v581 + vector(l_x_12 * 0.5 + 4, 12.5), color(60, 60, 60, 255 * v575));
                        render.rect(v581 - vector(l_x_12 * 0.5 + 3, 11.5), v581 + vector(l_x_12 * 0.5 + 3, 11.5), color(40, 40, 40, 255 * v575));
                        render.rect(v581 - vector(l_x_12 * 0.5 + 1, 9.5), v581 + vector(l_x_12 * 0.5 + 1, 9.5), color(50, 50, 50, 255 * v575));
                        render.rect(v581 - vector(l_x_12 * 0.5 + 0, 8.5), v581 + vector(l_x_12 * 0.5 + 0, 8.5), color(60, 60, 60, 255 * v575));
                        render.rect(v581 - vector(l_x_12 * 0.5 - 1, 7.5), v581 + vector(l_x_12 * 0.5 - 1, 7.5), color(20, 20, 20, 255 * v575));
                        render.gradient(vector(v569 - l_x_12 * 0.5 + 1, v570 - 8 - l_v568_0 - 75), vector(v569, v570 - 7 - l_v568_0 - 75), color(30, 85, 155, 255 * v575), color(245, 0, 255, 255 * v575), color(30, 85, 155, 255 * v575), color(245, 0, 255, 255 * v575));
                        render.gradient(vector(v569, v570 - 8 - l_v568_0 - 75), vector(v569 + l_x_12 * 0.5 - 1, v570 - 7 - l_v568_0 - 75), color(245, 0, 255, 255 * v575), color(225, 255, 0, 255 * v575), color(245, 0, 255, 255 * v575), color(225, 255, 0, 255 * v575));
                        render.text(1, v581, color(255, 255, 255, 255 * v575), "c", v576);
                    elseif v567 == "Modern" then
                        local v583 = {
                            full = v574.color:alpha_modulate(255 * v575), 
                            ["nil"] = color(16, 16, 16, 0)
                        };
                        render.gradient(v581 - vector(l_x_12 * 0.5 + 5 + 1, 11), v581 + vector(l_x_12 * 0.5 + 5 + 1, 11), v583.full, v583.full, v583["nil"], v583["nil"], 5);
                        render.rect(v581 - vector(l_x_12 * 0.5 + 5, 10), v581 + vector(l_x_12 * 0.5 + 5, 10), v583["nil"]:alpha_modulate(196 * v575), 5);
                        render.text(1, v581, color(255, 255, 255, 255 * v575), "c", v576);
                    end;
                end;
                for v584 = 1, #v572 do
                    table.remove(v337.aimbot_logs.list, v584);
                end;
                return;
            end;
        end, 
        push = function(v585, v586, v587, v588, v589)
            -- upvalues: v337 (ref)
            table.insert(v337.aimbot_logs.list, {
                position = 0, 
                offset = 0, 
                object = v585, 
                userID = v586:get_xuid(), 
                damage = v587, 
                prefix = v588, 
                time = globals.curtime, 
                color = v589 or v589(255, 255, 255, 255), 
                index = utils.random_float(-999999999, 999999999) + utils.random_float(-999999999, 999999999)
            });
        end, 
        fixed = function(v590, v591)
            if not v591 then
                v591 = 1;
            end;
            local l_v590_0 = v590;
            pcall(function()
                -- upvalues: l_v590_0 (ref), v591 (ref), v590 (ref)
                l_v590_0 = string.format("%." .. tonumber(v591) .. "f", v590);
            end);
            return l_v590_0;
        end, 
        aim_ack = function(v593, v594)
            -- upvalues: v59 (ref), v61 (ref), v337 (ref), l_print_0 (ref), v29 (ref)
            local l_self_6 = v59.lp.self;
            if not l_self_6 or not v61.settings.logs:get() then
                return;
            else
                local v596 = v61.settings.logs[0];
                local v597 = {
                    hit = v596.colors:get("\aFFFFFF003\aDEFAULTHit")[1], 
                    miss = v596.colors:get("\aFFFFFF002\aDEFAULTMiss")[1], 
                    other = color(222, 222, 222, 255)
                };
                local v598 = {
                    hit = v597.hit:to_hex(), 
                    miss = v597.miss:to_hex()
                };
                local l_select_0 = v596.select;
                if v594 then
                    local v600 = entity.get(v593.attacker, true);
                    if not v600 then
                        return;
                    else
                        local l_weapon_0 = v593.weapon;
                        local v602 = "";
                        if l_weapon_0 == "hegrenade" then
                            v602 = "Naded";
                        elseif l_weapon_0 == "inferno" then
                            v602 = "Burned";
                        elseif l_weapon_0 == "knife" then
                            v602 = "Knifed";
                        elseif l_weapon_0 == "taser" then
                            v602 = "Zeused";
                        end;
                        if l_self_6 == v600 and v602 ~= "" then
                            local v603 = entity.get(v593.userid, true);
                            if not v603 then
                                return;
                            else
                                local v604 = v603.m_iHealth - v593.dmg_health;
                                if v604 < 0 then
                                    v604 = 0;
                                end;
                                local v605 = v603:get_name():gsub("\n", "");
                                if l_select_0:get("Screen") then
                                    v337.aimbot_logs.push({
                                        [1] = {
                                            v597.other, 
                                            ("%s "):format(v602)
                                        }, 
                                        [2] = {
                                            v597.hit, 
                                            ("%s"):format(v605)
                                        }, 
                                        [3] = {
                                            [1] = nil, 
                                            [2] = " for ", 
                                            [1] = v597.other
                                        }, 
                                        [4] = {
                                            [1] = nil, 
                                            [2] = nil, 
                                            [3] = "damage", 
                                            [1] = v597.hit, 
                                            [2] = ("%s"):format(v593.dmg_health)
                                        }, 
                                        [5] = {
                                            [1] = nil, 
                                            [2] = " damage", 
                                            [1] = v597.other
                                        }
                                    }, v603, v593.dmg_health, v604, v597.hit);
                                end;
                                if l_select_0:get("Console") then
                                    l_print_0(v29.to_console(("%s \a%s%s\aDEFAULT for \a%s%s\aDEFAULT damage (\a%s%s\aDEFAULT health remaining)"):format(v602, v598.hit, v605, v598.hit, v593.dmg_health, v598.hit, v604)));
                                end;
                                if l_select_0:get("Top Left") then
                                    print_dev(v29.to_console(("\a%s[serenity]\aDEFAULT %s \a%s%s\aDEFAULT for \a%s%s\aDEFAULT damage (\a%s%s\aDEFAULT health remaining)"):format(v598.hit, v602, v598.hit, v605, v598.hit, v593.dmg_health, v598.hit, v604)));
                                end;
                            end;
                        end;
                        return;
                    end;
                else
                    local l_target_0 = v593.target;
                    if not l_target_0 then
                        return;
                    else
                        local l_m_iHealth_0 = l_target_0.m_iHealth;
                        local v608 = l_target_0:get_name():gsub("\n", "");
                        local v609 = v337.aimbot_logs.fixed(v593.spread, 2) or "-";
                        local v610 = {
                            damage = v593.wanted_damage, 
                            hitgroup = v337.aimbot_logs.hit_groups[v593.wanted_hitgroup] or "?"
                        };
                        if not v610.damage then
                            v610.damage = "-";
                        end;
                        if not v610.hitgroup then
                            v610.hitgroup = "generic";
                        end;
                        local v615 = (function()
                            -- upvalues: v593 (ref), v597 (ref), v337 (ref)
                            local v611 = "";
                            local v612 = {
                                damage = v593.damage ~= v593.wanted_damage, 
                                hitgroup = v593.hitgroup ~= v593.wanted_hitgroup
                            };
                            local v613 = v597[v593.state and "miss" or "hit"]:to_hex();
                            if v612.damage or v612.hitgroup then
                                v611 = ("%s"):format((function()
                                    -- upvalues: v612 (ref), v593 (ref), v613 (ref), v337 (ref)
                                    local v614 = "";
                                    if v612.damage then
                                        v614 = v593.wanted_damage;
                                    end;
                                    if v612.hitgroup then
                                        v614 = ("\a%s%s \aDEFAULT/ \a%s%s \aDEFAULTdamage"):format(v613, v337.aimbot_logs.hit_groups[v593.wanted_hitgroup], v613, v614);
                                    else
                                        v614 = ("\a%s%s\aDEFAULT"):format(v613, v614);
                                    end;
                                    return v614;
                                end)());
                            else
                                v611 = ("\a%snone\aDEFAULT"):format(v613);
                            end;
                            return v611;
                        end)();
                        if not v593.state then
                            if l_select_0:get("Screen") then
                                v337.aimbot_logs.push({
                                    [1] = {
                                        [1] = nil, 
                                        [2] = "Hit ", 
                                        [1] = v597.hit
                                    }, 
                                    [2] = {
                                        v597.other, 
                                        ("%s's "):format(v608)
                                    }, 
                                    [3] = {
                                        v597.hit, 
                                        ("%s"):format(v337.aimbot_logs.hit_groups[v593.hitgroup])
                                    }, 
                                    [4] = {
                                        [1] = nil, 
                                        [2] = " for ", 
                                        [1] = v597.other
                                    }, 
                                    [5] = {
                                        [1] = nil, 
                                        [2] = nil, 
                                        [3] = "damage", 
                                        [1] = v597.hit, 
                                        [2] = ("%s"):format(v593.damage)
                                    }, 
                                    [6] = {
                                        [1] = nil, 
                                        [2] = " damage (", 
                                        [1] = v597.other
                                    }, 
                                    [7] = {
                                        v597.hit, 
                                        ("%s"):format(l_m_iHealth_0)
                                    }, 
                                    [8] = {
                                        [1] = nil, 
                                        [2] = " health remaining)", 
                                        [1] = v597.other
                                    }
                                }, l_target_0, v593.damage, l_m_iHealth_0, v597.hit);
                            end;
                            if l_select_0:get("Console") then
                                local v616 = "";
                                if v596.extended:get("Console") then
                                    v616 = ("[spread: \a%s%s\aDEFAULT\194\176 | bt: \a%s%s\aDEFAULT t | hc: \a%s%s\aDEFAULT%% | mismatch: %s]"):format(v598.hit, v609, v598.hit, v593.backtrack, v598.hit, v593.hitchance, v615);
                                end;
                                l_print_0(v29.to_console(("Hit \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT for \a%s%s\aDEFAULT damage (\a%s%s\aDEFAULT health remaining) %s"):format(v598.hit, v608, v598.hit, v337.aimbot_logs.hit_groups[v593.hitgroup], v598.hit, v593.damage, v598.hit, l_m_iHealth_0, v616)));
                            end;
                            if l_select_0:get("Top Left") then
                                local v617 = "";
                                if v596.extended:get("Top Left") then
                                    v617 = ("[spread: \a%s%s\aDEFAULT\194\176 | bt: \a%s%s\aDEFAULT t | hc: \a%s%s\aDEFAULT%%]"):format(v598.hit, v609, v598.hit, v593.backtrack, v598.hit, v593.hitchance);
                                end;
                                print_dev(v29.to_console(("\a%s[serenity]\aDEFAULT Hit \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT for \a%s%s\aDEFAULT damage (\a%s%s\aDEFAULT health remaining) %s"):format(v598.hit, v598.hit, v608, v598.hit, v337.aimbot_logs.hit_groups[v593.hitgroup], v598.hit, v593.damage, v598.hit, l_m_iHealth_0, v617)));
                            end;
                        else
                            v593.state = v593.state == "correction" and "resolver" or v593.state;
                            if l_select_0:get("Screen") then
                                v337.aimbot_logs.push({
                                    [1] = {
                                        [1] = nil, 
                                        [2] = "Missed ", 
                                        [1] = v597.miss
                                    }, 
                                    [2] = {
                                        v597.other, 
                                        ("%s's "):format(v608)
                                    }, 
                                    [3] = {
                                        v597.miss, 
                                        ("%s"):format(v610.hitgroup)
                                    }, 
                                    [4] = {
                                        [1] = nil, 
                                        [2] = " due to ", 
                                        [1] = v597.other
                                    }, 
                                    [5] = {
                                        v597.miss, 
                                        ("%s"):format(v593.state)
                                    }
                                }, l_target_0, 0, 0, v597.miss);
                            end;
                            if l_select_0:get("Console") then
                                local v618 = "";
                                if v596.extended:get("Console") then
                                    v618 = ("[spread: \a%s%s\aDEFAULT\194\176 | bt: \a%s%s\aDEFAULT t | hc: \a%s%s\aDEFAULT%% | mismatch: %s]"):format(v598.miss, v609, v598.miss, v593.backtrack, v598.miss, v593.hitchance, v615);
                                end;
                                l_print_0(v29.to_console(("Missed \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT due to \a%s%s\aDEFAULT %s"):format(v598.miss, v608, v598.miss, v610.hitgroup, v598.miss, v593.state, v618)));
                            end;
                            if l_select_0:get("Top Left") then
                                local v619 = "";
                                if v596.extended:get("Top Left") then
                                    v619 = ("[spread: \a%s%s\aDEFAULT\194\176 | bt: \a%s%s\aDEFAULT t | hc: \a%s%s\aDEFAULT%%]"):format(v598.miss, v609, v598.miss, v593.backtrack, v598.miss, v593.hitchance);
                                end;
                                print_dev(v29.to_console(("\a%s[serenity]\aDEFAULT Missed \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT due to \a%s%s\aDEFAULT %s"):format(v598.miss, v598.miss, v608, v598.miss, v610.hitgroup, v598.miss, v593.state, v619)));
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end
    };
    v337.trashtalk = {
        list = {
            English = {
                [1] = {
                    [1] = "1"
                }, 
                [2] = {
                    [1] = "wow u got owned"
                }, 
                [3] = {
                    [1] = "lol"
                }, 
                [4] = {
                    [1] = "nice resolver"
                }, 
                [5] = {
                    [1] = "no serenity? fast die"
                }, 
                [6] = {
                    [1] = "HAHAHAHAH"
                }, 
                [7] = {
                    [1] = "thats a 1"
                }, 
                [8] = {
                    [1] = "cya"
                }, 
                [9] = {
                    [1] = "bad luck"
                }, 
                [10] = {
                    [1] = "ouch"
                }, 
                [11] = {
                    [1] = "iq?"
                }, 
                [12] = {
                    [1] = "wyd?"
                }, 
                [13] = {
                    [1] = "nn"
                }, 
                [14] = {
                    [1] = "wp"
                }, 
                [15] = {
                    [1] = "brain check?"
                }, 
                [16] = {
                    [1] = "are u new?"
                }, 
                [17] = {
                    [1] = "noob cheat"
                }, 
                [18] = {
                    [1] = "uninstall"
                }, 
                [19] = {
                    [1] = "nice config"
                }, 
                [20] = {
                    [1] = "baited"
                }, 
                [21] = {
                    [1] = "where r u going?"
                }, 
                [22] = {
                    [1] = "lost?"
                }, 
                [23] = {
                    [1] = "h$"
                }, 
                [24] = {
                    [1] = "nn down"
                }, 
                [25] = {
                    [1] = "weak dog"
                }, 
                [26] = {
                    [1] = "*DEAD*"
                }, 
                [27] = {
                    [1] = "you got owned"
                }
            }, 
            Russian = {
                [1] = {
                    [1] = "1"
                }, 
                [2] = {
                    [1] = "\208\187\208\190\208\187"
                }, 
                [3] = {
                    [1] = "\208\189\208\190\209\128\208\188 \209\128\208\181\208\183\208\184\208\186)"
                }, 
                [4] = {
                    [1] = "\208\189\208\181\209\130 serenity? \208\177\209\139\209\129\209\130\209\128\208\190 \209\131\208\188\208\181\209\128\208\176\208\181\209\136\209\140)"
                }, 
                [5] = {
                    [1] = "\208\144\208\165\208\144\208\165\208\144\208\165\208\165\208\144"
                }, 
                [6] = {
                    [1] = "\208\189\209\131 \209\130\209\131\209\130 1"
                }, 
                [7] = {
                    [1] = "\208\189\208\181 \208\191\208\190\208\178\208\181\208\183\208\187\208\190"
                }, 
                [8] = {
                    [1] = "\208\190\208\185)"
                }, 
                [9] = {
                    [1] = "\208\189\208\189"
                }, 
                [10] = {
                    [1] = "\209\131 \209\130\208\181\208\177\209\143 \208\188\208\190\208\183\208\179 \208\181\209\129\209\130\209\140?"
                }, 
                [11] = {
                    [1] = "\209\130\209\139 \208\189\209\140\209\142\208\186\208\176\208\188\208\181\209\128?"
                }, 
                [12] = {
                    [1] = "\209\131\208\182\208\176\209\129\208\189\209\139\208\185 \209\131 \209\130\208\181\208\177\209\143 \209\135\208\184\209\130)"
                }, 
                [13] = {
                    [1] = "\209\131\208\180\208\176\208\187\208\184\209\129\209\140"
                }, 
                [14] = {
                    [1] = "\208\189\208\176\208\185\209\129 \208\186\208\190\208\189\209\132\208\184\208\179 \208\176\209\133\208\176\209\133"
                }, 
                [15] = {
                    [1] = "\208\186\209\131\208\180\208\176 \209\130\209\139 \208\177\208\181\208\182\208\184\209\136\209\140?"
                }, 
                [16] = {
                    [1] = "\209\130\209\139 \208\191\208\190\209\130\208\181\209\128\209\143\208\187\209\129\209\143?"
                }, 
                [17] = {
                    [1] = "\208\189\208\189\209\135\208\184\208\186"
                }, 
                [18] = {
                    [1] = "\209\129\208\187\208\176\208\177\209\139\208\185 \208\191\208\181\209\129 \208\176\209\133\208\176\209\133\208\176"
                }, 
                [19] = {
                    [1] = "*\208\163\208\156\208\149\208\160*"
                }
            }
        }, 
        delay_message = function(v620, v621)
            return utils.execute_after(v620, function()
                -- upvalues: v621 (ref)
                utils.console_exec(("say %s"):format(v621));
            end);
        end, 
        executer = function(v622)
            -- upvalues: v59 (ref), v61 (ref), v337 (ref)
            local l_self_7 = v59.lp.self;
            if not l_self_7 or not v61.settings.trashtalk:get() then
                return;
            else
                local v624 = {
                    delay = {
                        self = 1, 
                        this = v61.settings.trashtalk[0].delay:get() * 0.1
                    }, 
                    infos = {
                        victim = entity.get(v622.userid, true), 
                        attacker = entity.get(v622.attacker, true)
                    }
                };
                if v624.delay.this == 0 then
                    v624.delay.this = utils.random_float(0, 2);
                end;
                local v625 = v61.settings.trashtalk[0].language:get();
                if v624.infos.victim ~= v624.infos.attacker and v624.infos.attacker == l_self_7 then
                    local v626 = v337.trashtalk.list[v625][math.random(1, #v337.trashtalk.list[v625])];
                    for v627 = 1, #v626 do
                        local v628 = v626[v627];
                        local v629 = #v626[v627] / 24 * v624.delay.self;
                        v624.delay.this = v624.delay.this + v629;
                        v337.trashtalk.delay_message(v624.delay.this, v628);
                    end;
                end;
                return;
            end;
        end
    };
    v337.viewmodel_changer = {
        set_values = function(v630, v631, v632, v633)
            -- upvalues: v29 (ref)
            local v634 = {
                FOV = v630 or v29.default_cvars.viewmodel.FOV, 
                x = v631 or v29.default_cvars.viewmodel.x, 
                y = v632 or v29.default_cvars.viewmodel.y, 
                z = v633 or v29.default_cvars.viewmodel.z
            };
            cvar.viewmodel_fov:float(v634.FOV, true);
            cvar.viewmodel_offset_x:float(v634.x, true);
            cvar.viewmodel_offset_y:float(v634.y, true);
            cvar.viewmodel_offset_z:float(v634.z, true);
        end, 
        executer = function(v635)
            -- upvalues: v61 (ref), v337 (ref)
            local v636 = v61.settings.viewmodel_changer[0];
            if v635 then
                v337.viewmodel_changer.set_values(v636.FOV:get() * 0.1, v636.x:get() * 0.1, v636.y:get() * 0.1, v636.z:get() * 0.1);
            else
                v337.viewmodel_changer.set_values();
            end;
        end
    };
    v337.aspect_ratio = {
        set_values = function(v637)
            -- upvalues: v29 (ref)
            local v638 = {
                offset = v637 or v29.default_cvars.aspectratio
            };
            cvar.r_aspectratio:float(v638.offset, true);
        end, 
        executer = function(v639)
            -- upvalues: v61 (ref), v337 (ref)
            local v640 = v61.settings.aspect_ratio[0];
            if v639 then
                v337.aspect_ratio.set_values(v640.offset:get() * 0.01);
            else
                v337.aspect_ratio.set_values();
            end;
        end
    };
    v337.nade_throw_fix = {
        executer = function(v641)
            -- upvalues: v59 (ref), v60 (ref), v61 (ref)
            local l_self_8 = v59.lp.self;
            v60.main.Other.weapon_action:override(nil);
            if not l_self_8 or not l_self_8:is_alive() or not v61.settings.nade_fix:get() then
                return;
            else
                local v643 = l_self_8:get_player_weapon();
                if not v643 then
                    return;
                else
                    local l_m_fThrowTime_0 = v643.m_fThrowTime;
                    local l_on_0 = v61.settings.nade_fix[0].on;
                    if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 ~= 0 then
                        if not l_on_0:get("Lag Options") then
                            rage.exploit:allow_defensive(false);
                        end;
                        if not l_on_0:get("Quick Switch") then
                            v60.main.Other.weapon_action:override({});
                        end;
                        return;
                    else
                        if v641.in_attack then
                            local v646 = v643:get_weapon_info();
                            if not v646 then
                                return;
                            elseif v646.weapon_type == 9 then
                                if not l_on_0:get("Lag Options") then
                                    rage.exploit:allow_defensive(false);
                                end;
                                if not l_on_0:get("Quick Switch") then
                                    v60.main.Other.weapon_action:override({});
                                end;
                                return;
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end
    };
    v337.no_fall_damage = {
        pre_render = function()
            -- upvalues: v59 (ref), v337 (ref), v61 (ref)
            local l_self_9 = v59.lp.self;
            v337.no_fall_damage.in_duck = nil;
            if not l_self_9 or not v61.settings.no_fall:get() then
                v337.no_fall_damage.in_duck = nil;
                return;
            elseif not globals.is_connected or not globals.is_in_game then
                return;
            else
                local v648 = l_self_9:get_origin();
                if not v648 then
                    return;
                else
                    if l_self_9.m_vecVelocity.z <= -500 then
                        local l_fraction_0 = utils.trace_line(v648, v648 + vector(0, 0, -256), l_self_9).fraction;
                        if l_fraction_0 <= 0.26 and l_fraction_0 > 0.05 then
                            v337.no_fall_damage.in_duck = true;
                        elseif l_fraction_0 <= 0.04 then
                            v337.no_fall_damage.in_duck = false;
                        end;
                    end;
                    return;
                end;
            end;
        end, 
        createmove = function(v650)
            -- upvalues: v337 (ref)
            if v337.no_fall_damage.in_duck then
                v650.in_duck = v337.no_fall_damage.in_duck;
            end;
        end
    };
    v337.radius = {
        inferno_list = {}, 
        mp_friendlyfire = cvar.mp_friendlyfire:int(), 
        executer = function()
            -- upvalues: v61 (ref), v337 (ref), l_smooth_0 (ref)
            local v651 = entity.get_local_player();
            if not v651 or not v61.settings.radius:get() then
                return;
            else
                local v652 = v61.settings.radius[0];
                local v653 = entity.get_entities("CSmokeGrenadeProjectile");
                local v654 = {
                    tickcount = globals.tickcount, 
                    tickinterval = globals.tickinterval, 
                    realtime = globals.realtime
                };
                local v655 = {};
                local l_inferno_list_0 = v337.radius.inferno_list;
                v337.radius.inferno_list = {};
                v655 = entity.get_entities("CInferno");
                for v657 = 1, #v655 do
                    local v658 = v655[v657];
                    if v658.m_fireCount > 0 then
                        v337.radius.inferno_list[v658] = l_inferno_list_0[v658] ~= nil and l_inferno_list_0[v658] or v654.realtime;
                        table.insert(v653, v658);
                    end;
                end;
                for v659 = 1, #v653 do
                    local v660 = v653[v659];
                    if v660 then
                        local v661 = v660:get_classname();
                        if v661 == "CSmokeGrenadeProjectile" and v652.display:get("Smoke") then
                            local l_m_vecOrigin_0 = v660.m_vecOrigin;
                            if v660.m_bDidSmokeEffect then
                                local l_m_nSmokeEffectTickBegin_0 = v660.m_nSmokeEffectTickBegin;
                                if l_m_nSmokeEffectTickBegin_0 ~= nil then
                                    local v664 = v654.tickinterval * (v654.tickcount - l_m_nSmokeEffectTickBegin_0);
                                    if v664 > 0 and 17.55 - v664 > 0 then
                                        local v665 = 125;
                                        if v664 < 0.3 then
                                            v665 = v665 * 0.6 + v665 * (v664 / 0.3) * 0.4;
                                        end;
                                        local v666 = v660:get_index();
                                        local v667 = l_smooth_0.linear("Serenity", ("Grenade Radius / Smoke / #%s"):format(v666), 17.55 - v664 > 0.2);
                                        local v668 = v652.color_se:get();
                                        v668 = v668:alpha_modulate(v668.a * v667);
                                        render.circle_3d_outline(l_m_vecOrigin_0, v668, v665, 0, 1, 1);
                                    end;
                                end;
                            end;
                        elseif v661 == "CInferno" and v652.display:get("Molotov") then
                            local l_m_vecOrigin_1 = v660.m_vecOrigin;
                            local v670 = {
                                cells = {}, 
                                max_distance = 0, 
                                cell_max_1 = nil, 
                                cell_max_2 = nil
                            };
                            for v671 = 1, 32 do
                                if v660.m_bFireIsBurning[v671] then
                                    table.insert(v670.cells, vector(v660.m_fireXDelta[v671], v660.m_fireYDelta[v671], v660.m_fireZDelta[v671]));
                                end;
                            end;
                            for v672 = 1, #v670.cells do
                                local v673 = v670.cells[v672];
                                for v674 = 1, #v670.cells do
                                    local v675 = v670.cells[v674];
                                    local v676 = v673:dist(v675);
                                    if v670.max_distance < v676 then
                                        v670.max_distance = v676;
                                        v670.cell_max_1 = v673;
                                        v670.cell_max_2 = v675;
                                    end;
                                end;
                            end;
                            if v670.cell_max_1 ~= nil and v670.cell_max_2 ~= nil then
                                local l_m_hOwnerEntity_0 = v660.m_hOwnerEntity;
                                local v678 = v652.color_ev:get();
                                local v679 = false;
                                if l_m_hOwnerEntity_0 and v337.radius.mp_friendlyfire == 0 and l_m_hOwnerEntity_0 ~= v651 and not l_m_hOwnerEntity_0:is_enemy() then
                                    v679 = true;
                                    v678 = v652.color_tv:get();
                                end;
                                local v680 = math.max(0, tonumber(string.format("%.1f", 7.03125 - v654.tickinterval * (v654.tickcount - v660.m_nFireEffectTickBegin))));
                                local v681 = v670.cell_max_1:lerp(v670.cell_max_2, 0.5);
                                local v682 = v660:get_index();
                                local v683 = l_smooth_0.linear("Serenity", ("Grenade Radius / Inferno / #%s"):format(v682), v680 > 0.2);
                                v678 = v678.alpha_modulate(v678, v678.a * v683);
                                render.circle_3d_outline(l_m_vecOrigin_1 + v681, v678, v670.max_distance * 0.5 + 40, 0, 1, 1);
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end
    };
    v337.auto_m_unm = {
        object = {
            mode = "", 
            quantity = 0
        }, 
        executer = function()
            -- upvalues: v61 (ref), v337 (ref)
            if not entity.get_local_player() or not v61.settings.auto_m_unm:get() then
                return;
            else
                local v684 = entity.get_players(false, true);
                local v685 = v61.settings.auto_m_unm[0].mode:get();
                if v337.auto_m_unm.object.quantity ~= #v684 or v337.auto_m_unm.object.mode ~= v685 then
                    for _, v687 in pairs(v684) do
                        local v688 = panorama.MatchStatsAPI.GetPlayerXuid(v687:get_index());
                        if panorama.GameStateAPI.IsSelectedPlayerMuted(v688) ~= (v685 == "Mute") then
                            panorama.GameStateAPI.ToggleMute(v688);
                        end;
                    end;
                    v337.auto_m_unm.object.quantity = #v684;
                    v337.auto_m_unm.object.mode = v685;
                end;
                return;
            end;
        end
    };
    v337.drop_grenades = {
        enable = false, 
        list = {
            weapon_flashbang = "Flashbang", 
            weapon_smokegrenade = "Smoke", 
            weapon_incgrenade = "Molotov", 
            weapon_molotov = "Molotov", 
            weapon_hegrenade = "High Explosive"
        }, 
        executer = function()
            -- upvalues: v61 (ref), v337 (ref)
            local v689 = entity.get_local_player();
            if v689 == nil or not v689:is_alive() or not v61.settings.drop_grenades:get() or not v61.settings.drop_grenades[0].bind:get() then
                v337.drop_grenades.enable = false;
                return;
            elseif v337.drop_grenades.enable then
                return;
            else
                local v690 = v689:get_player_weapon(true);
                if not v690 then
                    return;
                else
                    local v691 = 0.02;
                    utils.console_exec("+use;");
                    for v692 = 1, #v690 do
                        local v693 = v690[v692]:get_weapon_info();
                        do
                            local l_v693_0 = v693;
                            if l_v693_0 and l_v693_0.weapon_type == 9 then
                                local v695 = false;
                                if v61.settings.drop_grenades[0].discard:get(v337.drop_grenades.list[l_v693_0.console_name] or "") then
                                    v695 = true;
                                end;
                                if v695 then
                                    utils.execute_after(v691, function()
                                        -- upvalues: l_v693_0 (ref)
                                        utils.console_exec("use weapon_knife;");
                                        utils.console_exec(("use %s;"):format(l_v693_0.console_name));
                                        utils.console_exec("drop;");
                                    end);
                                end;
                                v691 = v691 + 0.02;
                            end;
                        end;
                    end;
                    utils.execute_after(v691, function()
                        utils.console_exec("-use;");
                    end);
                    v337.drop_grenades.enable = true;
                    return;
                end;
            end;
        end
    };
    pcall(function()
        -- upvalues: v337 (ref)
        network.get("https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg", {}, function(v696)
            -- upvalues: v337 (ref)
            v337.screen_widgets.spectators.undefined = render.load_image(v696, vector(32, 32));
        end);
    end);
    pcall(function()
        -- upvalues: v337 (ref)
        network.get("https://vh488226.eurodir.ru/serenity/LogoFuSm.png", {}, function(v697)
            -- upvalues: v337 (ref)
            v337.screen_widgets.defensive_indicator.image = render.load_image(v697, vector(64, 64));
            v337.watermark.logo = render.load_image(v697, vector(64, 64));
        end);
    end);
    pcall(function()
        -- upvalues: v337 (ref)
        network.get("https://vh488226.eurodir.ru/serenity/Girl.png", {}, function(v698)
            -- upvalues: v337 (ref)
            v337.watermark.anime = render.load_image(v698, vector(28.125, 39.84375));
        end);
    end);
    v61.settings.viewmodel_changer:set_callback(function(v699)
        -- upvalues: v337 (ref), v61 (ref)
        v337.viewmodel_changer.executer(v699:get());
        local v700 = v61.settings.viewmodel_changer[0];
        v700.FOV:visibility(v699:get());
        v700.x:visibility(v699:get());
        v700.y:visibility(v699:get());
        v700.z:visibility(v699:get());
        v700.reset:visibility(v699:get());
    end, true);
    v61.settings.viewmodel_changer[0].FOV:set_callback(function()
        -- upvalues: v337 (ref), v61 (ref)
        v337.viewmodel_changer.executer(v61.settings.viewmodel_changer:get());
    end);
    v61.settings.viewmodel_changer[0].x:set_callback(function()
        -- upvalues: v337 (ref), v61 (ref)
        v337.viewmodel_changer.executer(v61.settings.viewmodel_changer:get());
    end);
    v61.settings.viewmodel_changer[0].y:set_callback(function()
        -- upvalues: v337 (ref), v61 (ref)
        v337.viewmodel_changer.executer(v61.settings.viewmodel_changer:get());
    end);
    v61.settings.viewmodel_changer[0].z:set_callback(function()
        -- upvalues: v337 (ref), v61 (ref)
        v337.viewmodel_changer.executer(v61.settings.viewmodel_changer:get());
    end);
    v61.settings.viewmodel_changer[0].reset:set_callback(function()
        -- upvalues: v61 (ref), v29 (ref)
        v61.settings.viewmodel_changer[0].FOV:set(v29.default_cvars.viewmodel.FOV * 10);
        v61.settings.viewmodel_changer[0].x:set(v29.default_cvars.viewmodel.x * 10);
        v61.settings.viewmodel_changer[0].y:set(v29.default_cvars.viewmodel.y * 10);
        v61.settings.viewmodel_changer[0].z:set(v29.default_cvars.viewmodel.z * 10);
    end, true);
    v61.settings.aspect_ratio:set_callback(function(v701)
        -- upvalues: v337 (ref), v61 (ref), v29 (ref)
        v337.aspect_ratio.executer(v61.settings.aspect_ratio:get());
        local v702 = v61.settings.aspect_ratio[0];
        v702.offset:visibility(v701:get());
        for _, v704 in pairs(v29.aspect_ratio) do
            v702[("%s:%s"):format(v704[1], v704[2])]:visibility(v701:get());
        end;
    end, true);
    v61.settings.aspect_ratio[0].offset:set_callback(function()
        -- upvalues: v337 (ref), v61 (ref)
        v337.aspect_ratio.executer(v61.settings.aspect_ratio:get());
    end);
    local v705 = {
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3), 
        utils.random_float(1, 3)
    };
    events.pre_render(function()
        -- upvalues: v337 (ref)
        v337.no_fall_damage.pre_render();
        v337.drop_grenades.executer();
    end);
    events.render(function()
        -- upvalues: v59 (ref), l_smooth_0 (ref), l_liberia_0 (ref), v337 (ref), v61 (ref), l_monylinear_0 (ref), v705 (ref), v29 (ref), l_mui_0 (ref)
        v59.lp.self = entity.get_local_player();
        if v59.lp.self then
            v59.lp.team.index = v59.lp.self.m_iTeamNum;
            v59.lp.team.name = v59.lp.team.index == 3 and "CT" or v59.lp.team.index == 2 and "T" or "N";
            local v706 = utils.net_channel();
            if v706 then
                v59.lp.ping.real = math.max(0, (math.floor(v706.avg_latency[1] * 1000)));
                v59.lp.ping.incoming = math.min(math.max(0, math.abs((v706.latency[0] + v706.latency[1]) * 1000) / 200), 1);
            end;
        else
            v59.lp.team.index = -1;
            v59.lp.team.name = "N";
            v59.lp.ping.real = 0;
            v59.lp.ping.incoming = 0;
        end;
        l_smooth_0.new("Serenity");
        l_smooth_0.new("Slowed");
        l_smooth_0.update("Serenity", 12);
        l_smooth_0.update("Slowed", 8);
        l_liberia_0.anti_aim.condition.update();
        v337.crosshair_indicators.executer();
        v337.minimum_damage.executer();
        v337.manual_arrows.executer();
        v337.screen_widgets.executer();
        v337.watermark.always_mark();
        v337.watermark.executer();
        v337.skeet:executer();
        v337.skeet:spectators();
        v337.custom_scope.executer();
        v337.aimbot_logs.render();
        v337.radius.executer();
        v337.clantag.executer();
        v337.auto_m_unm.executer();
        if ui.get_alpha() > 0 then
            local v707 = ui.get_style("Link Active");
            local v708 = v707:alpha_modulate(64);
            local v709 = "flower-tulip";
            local v710 = "serenity.lua";
            local v711 = v61.home.sidebar:get();
            if v711 == "Modern" then
                v710 = l_monylinear_0:Animate("\240\159\134\130\240\159\133\180\240\159\134\129\240\159\133\180\240\159\133\189\240\159\133\184\240\159\134\131\240\159\134\136", {
                    [1] = v708, 
                    [2] = v708, 
                    [3] = v708, 
                    [4] = v708, 
                    [5] = v708, 
                    [6] = v708, 
                    [7] = v708, 
                    [8] = v708, 
                    [9] = v707, 
                    [10] = v707, 
                    [11] = v707, 
                    [12] = v707, 
                    [13] = v707, 
                    [14] = v707, 
                    [15] = v707, 
                    [16] = v707
                }, 3, 1.5);
            elseif v711 == "Twinkle" then
                v710 = ("%s%s%s%s%s%s%s%s"):format(l_monylinear_0:Animate("s", {
                    [1] = v708, 
                    [2] = v707
                }, v705[1]), l_monylinear_0:Animate("e", {
                    [1] = v708, 
                    [2] = v707
                }, v705[2]), l_monylinear_0:Animate("r", {
                    [1] = v708, 
                    [2] = v707
                }, v705[3]), l_monylinear_0:Animate("e", {
                    [1] = v708, 
                    [2] = v707
                }, v705[4]), l_monylinear_0:Animate("n", {
                    [1] = v708, 
                    [2] = v707
                }, v705[5]), l_monylinear_0:Animate("i", {
                    [1] = v708, 
                    [2] = v707
                }, v705[6]), l_monylinear_0:Animate("t", {
                    [1] = v708, 
                    [2] = v707
                }, v705[7]), l_monylinear_0:Animate("y", {
                    [1] = v708, 
                    [2] = v707
                }, v705[8]));
                v709 = l_monylinear_0:Animate(ui.get_icon(v709), {
                    [1] = v708, 
                    [2] = v707
                }, 3);
            elseif v711 == "Default" then
                v710 = l_monylinear_0:Animate(("serenity ~ %s"):format(v29.build):lower(), {
                    [1] = v708, 
                    [2] = v707
                }, 3);
            elseif v711 == "Static" then
                v710 = ("\a%sserenity ~ %s"):format(v707:to_hex(), v29.build):lower();
            end;
            l_mui_0.sidebar(v710, v709);
        end;
    end);
    events.createmove(function(v712)
        -- upvalues: v214 (ref), v337 (ref)
        v214.builder(v712);
        v337.nade_throw_fix.executer(v712);
        v337.no_fall_damage.createmove(v712);
        v337.crosshair_indicators.leaflets.buttons = {
            A = bit.band(v712.buttons, 512) == 512, 
            D = bit.band(v712.buttons, 1024) == 1024
        };
    end);
    events.aim_ack(function(v713)
        -- upvalues: v337 (ref)
        v337.skeet:aim_ack(v713);
        v337.aimbot_logs.aim_ack(v713);
    end);
    events.player_hurt(function(v714)
        -- upvalues: v337 (ref)
        v337.aimbot_logs.aim_ack(v714, true);
    end);
    events.player_death(function(v715)
        -- upvalues: v337 (ref)
        v337.trashtalk.executer(v715);
    end);
    events.round_start(function()
        -- upvalues: v337 (ref)
        v337.skeet:clear_planting_info();
    end);
    events.bomb_abortplant(function()
        -- upvalues: v337 (ref)
        v337.skeet:clear_planting_info();
    end);
    events.bomb_defused(function()
        -- upvalues: v337 (ref)
        v337.skeet:clear_planting_info();
    end);
    events.bomb_planted(function()
        -- upvalues: v337 (ref)
        v337.skeet:clear_planting_info();
    end);
    events.bomb_beginplant(function(v716)
        -- upvalues: v337 (ref)
        v337.skeet:bomb_begin_plant(v716);
    end);
    events.post_update_clientside_animation(function(v717)
        -- upvalues: v59 (ref), v214 (ref)
        if v717 ~= v59.lp.self then
            return;
        else
            v214.animations(v717, v717[0]);
            return;
        end;
    end);
    events.style_change(function(_)
        -- upvalues: v61 (ref), l_mui_0 (ref)
        v61.home.logo:set(ui.get_style("Link Active"));
        v61.home.select:update({
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Informations"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Recommendations"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Configurations")
        });
        v61["anti aim"].type:update({
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Disabled"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Normal"), 
            l_mui_0.header("!h<!s<Link Active>>!i<caret-right>!d  Teams")
        });
        for _, v720 in pairs({
            [1] = "home", 
            [2] = "anti aim", 
            [3] = "settings"
        }) do
            local v721 = v61[v720];
            if v721 then
                for _, v723 in pairs(v721) do
                    do
                        local l_v723_0 = v723;
                        pcall(function()
                            -- upvalues: l_v723_0 (ref), l_mui_0 (ref)
                            l_v723_0:name(l_mui_0.header(l_v723_0.default));
                        end);
                    end;
                end;
            end;
        end;
    end);
    events.mouse_input(function()
        -- upvalues: l_system_0 (ref)
        return l_system_0.get_anti_shot();
    end);
    events.shutdown(function()
        -- upvalues: v60 (ref), v337 (ref)
        v60.world["Override Zoom"].overlay:override(nil);
        v337.viewmodel_changer.executer();
        v337.aspect_ratio.executer();
        ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"):override(nil);
        common.set_clan_tag("\000");
        cvar.sv_maxusrcmdprocessticks:int(16);
    end);
    return;
end;