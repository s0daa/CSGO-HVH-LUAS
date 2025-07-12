local v0 = nil;
v0 = {
    data = {}
};
v0.listen = function(v1)
    -- upvalues: v0 (ref)
    if v0.data[v1] then
        return print(string.format("Already listening for %s.", v1));
    else
        v0.data[v1] = common.get_timestamp();
        return;
    end;
end;
v0.finish = function(v2)
    -- upvalues: v0 (ref)
    if not v0.data[v2] then
        return print(string.format("Failed to finish %s benchmark.\nReason: Event doesn't exist.", v2));
    else
        print(string.format("%s took %f ms.", v2, common.get_timestamp() - v0.data[v2]));
        v0.data[v2] = nil;
        return;
    end;
end;
v0.listener = function(v3, v4, ...)
    local v5 = common.get_timestamp();
    local v6 = {
        v4(...)
    };
    print(string.format("%s took %f ms.", v3, common.get_timestamp() - v5));
    return unpack(v6);
end;
local l_puiwka_0 = require("neverlose/puiwka");
local l_handler_0 = require("neverlose/aa_handler");
local v9 = require("neverlose/sec-base64");
local _ = require("neverlose/memory");
local l_md5_0 = require("neverlose/md5");
local _ = require("neverlose/inspect");
local v24 = (function()
    return {
        data = {}, 
        new_frame = function(v13, v14)
            for _, v16 in pairs(v13.data) do
                if v14 - v16.last_tick >= v16.speed then
                    v16.flicked = not v16.flicked;
                    v16.last_tick = v14;
                end;
            end;
        end, 
        flick = function(v17, v18, v19, v20, v21)
            local v22 = math.min(v19, v20);
            local v23 = math.max(v19, v20);
            if not v17.data[v18] then
                v17.data[v18] = {
                    last_tick = 0, 
                    flicked = false, 
                    speed = v21
                };
            end;
            if v17.data[v18].speed ~= v21 then
                v17.data[v18].speed = v21;
            end;
            return v17.data[v18].flicked and v23 or v22;
        end
    };
end)();
local v50 = (function()
    return {
        data = {}, 
        new_frame = function(v25, v26)
            for _, v28 in pairs(v25.data) do
                if v26 - v28.last_tick >= v28.speed then
                    for _ = 1, v28.times do
                        if v28.forward or v28.spin then
                            if v28.value < v28.max then
                                v28.value = v28.value + 1;
                            elseif v28.spin then
                                v28.value = v28.min;
                            else
                                v28.forward = false;
                            end;
                        elseif v28.value > v28.min then
                            v28.value = v28.value - 1;
                        else
                            v28.forward = true;
                        end;
                    end;
                    v28.last_tick = v26;
                end;
            end;
        end, 
        sway = function(v30, v31, v32, v33, v34, v35)
            local v36 = math.min(v32, v33);
            local v37 = math.max(v32, v33);
            local v38 = v35 or 1;
            if not v30.data[v31] then
                v30.data[v31] = {
                    last_tick = 0, 
                    forward = true, 
                    value = v36, 
                    min = v36, 
                    max = v37, 
                    speed = v34, 
                    times = v38
                };
            end;
            local v39 = v30.data[v31];
            if v39.min ~= v36 or v39.max ~= v37 then
                v30.data[v31] = {
                    last_tick = 0, 
                    forward = true, 
                    value = v36, 
                    min = v36, 
                    max = v37, 
                    speed = v34, 
                    times = v38
                };
            end;
            if v30.data[v31].speed ~= v34 then
                v30.data[v31].speed = v34;
            end;
            if v30.data[v31].times ~= v38 then
                v30.data[v31].times = v38;
            end;
            return v30.data[v31].value;
        end, 
        spin = function(v40, v41, v42, v43, v44, v45)
            local v46 = math.min(v42, v43);
            local v47 = math.max(v42, v43);
            local v48 = v45 or 1;
            if not v40.data[v41] then
                v40.data[v41] = {
                    forward = true, 
                    last_tick = 0, 
                    spin = true, 
                    value = v46, 
                    min = v46, 
                    max = v47, 
                    speed = v44, 
                    times = v48
                };
            end;
            local v49 = v40.data[v41];
            if v49.min ~= v46 or v49.max ~= v47 then
                v40.data[v41] = {
                    forward = true, 
                    last_tick = 0, 
                    spin = true, 
                    value = v46, 
                    min = v46, 
                    max = v47, 
                    speed = v44, 
                    times = v48
                };
            end;
            if v40.data[v41].speed ~= v44 then
                v40.data[v41].speed = v44;
            end;
            if v40.data[v41].times ~= v48 then
                v40.data[v41].times = v48;
            end;
            return v40.data[v41].value;
        end
    };
end)();
local function v56(v51, v52, v53)
    local l_status_0, l_result_0 = pcall(render.load_font, v51, v52, v53);
    if not l_status_0 then
        print(string.format("xo-yaw.lua -> Failed to load font %s", v51));
        return 1;
    else
        return l_result_0;
    end;
end;
local v57 = {
    label = "xo-yaw", 
    version = "Stable", 
    switch = false, 
    online = 0, 
    menu_alpha = 0, 
    jitter = 0, 
    update_date = "26 December 2024", 
    username = common.get_username(), 
    screen = render.screen_size(), 
    screen_center = render.screen_size() / 2, 
    colors = {
        default = color("FF90D9FF"), 
        white = color(), 
        link_active = color(), 
        warning = color(), 
        idle = color(225, 90)
    }, 
    functions = {
        air_exploit = false, 
        nade_fix = false, 
        randomization = false, 
        hidden_static = false, 
        hidden_aa = false, 
        vanish = false, 
        safe_head = false, 
        backstab = false, 
        legit = false, 
        edge = false
    }, 
    states = {
        [1] = "Global", 
        [2] = "Stand", 
        [3] = "Move", 
        [4] = "Slow Walk", 
        [5] = "Crouch", 
        [6] = "Crouch Move", 
        [7] = "Air", 
        [8] = "Air+", 
        [9] = "Fake Lag", 
        [10] = "Using"
    }, 
    hidden_states = {
        [1] = "Stand", 
        [2] = "Move", 
        [3] = "Slow Walk", 
        [4] = "Crouch", 
        [5] = "Crouch Move", 
        [6] = "Air", 
        [7] = "Air+", 
        [8] = "On Peek"
    }, 
    states_enum = {
        SLOWWALK = 4, 
        MOVE = 3, 
        STAND = 2, 
        GLOBAL = 1, 
        USING = 10, 
        FAKELAG = 9, 
        AIR_CR = 8, 
        AIR = 7, 
        CROUCH_MOVE = 6, 
        CROUCH = 5
    }
};
local v58 = {
    moving = 0, 
    velocity = 0, 
    crouch = false, 
    condition = "", 
    body_yaw = 0, 
    safe_head_yaw = 0, 
    native_inverter = false, 
    velocity_modifier = 0, 
    landing = false, 
    on_ground = false
};
local v59 = {
    max_tickbase = 0, 
    ticks = 0, 
    max = 0
};
local v60 = {
    RAGE = {
        aimbot = {
            hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes"), 
            double_tap = {
                main = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
                options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
            }, 
            hide_shots = {
                main = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
                options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
            }
        }, 
        other = {
            auto_scope = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope"), 
            min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
            hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
            body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
            safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
            dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
            peek_assist = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
        }
    }, 
    AA = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
                base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
                backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
                hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
            }, 
            yaw_modifier = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
            }, 
            body_yaw = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
                inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
                left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
                right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
                options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
                freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            }, 
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
            extended_angles = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
                pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
                roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
            }
        }, 
        fake_lag = {
            main = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
            variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
        }, 
        other = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    VISUALS = {
        scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
        thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson"), 
        hitmarker = ui.find("Visuals", "World", "Other", "Hit Marker"), 
        fov = ui.find("Visuals", "World", "Main", "Field of View")
    }, 
    MISC = {
        clantag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
        windows = ui.find("Miscellaneous", "Main", "Other", "Windows"), 
        log_events = ui.find("Miscellaneous", "Main", "Other", "Log Events"), 
        fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        air_duck = ui.find("Miscellaneous", "Main", "Movement", "Air Duck"), 
        weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
    }
};
local v71 = (function()
    local v61 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
    local v62 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
    local v63 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
    local function v65(...)
        -- upvalues: v62 (ref)
        local v64 = tostring(table.concat({
            ...
        }));
        v62(v64, string.len(v64));
    end;
    local function v70()
        -- upvalues: v61 (ref), v63 (ref)
        local v66 = v61();
        if v66 > 0 then
            local v67 = ffi.typeof("char[?]")(v66);
            v63(0, v67, v66);
            local v68 = ffi.string(v67, v66 - 1);
            local v69 = nil;
            v69 = v68:find("_xoyaw");
            if v69 then
                v68 = v68:sub(1, v69);
            end;
            return v68;
        else
            return;
        end;
    end;
    return {
        set = v65, 
        get = v70
    };
end)();
local v72 = nil;
v72 = {
    DEV_MODE = not _IS_MARKET
};
local v73 = nil;
v73 = {};
local v74 = "99w2HabpkgfgUY";
local v75 = "https://xo-back.sokirkoyaw.ru/reports";
local function v78(v76, v77)
    -- upvalues: l_md5_0 (ref)
    return l_md5_0.sumhexa(string.format("reports-%s%s", v76, v77));
end;
local v79 = {};
do
    local l_v74_0, l_v75_0, l_v78_0, l_v79_0 = v74, v75, v78, v79;
    v73.send = function(v84, v85, v86)
        -- upvalues: l_v79_0 (ref), l_v78_0 (ref), l_v74_0 (ref), l_v75_0 (ref)
        if l_v79_0[v86] then
            return false;
        else
            l_v79_0[v86] = true;
            local v87 = l_v78_0(v84, l_v74_0);
            network.post(l_v75_0, {
                username = v84, 
                signature = v87, 
                report = v85
            }, {
                ["Content-Type"] = "application/json"
            }, function(...)

            end);
            return;
        end;
    end;
    v73.markup = function(v88, v89, v90)
        return ("\n\nUsername: <b>%s</b>\nCallback: <b>%s</b> (%s)\n\nError:\n<code>%s</code>"):format(common.get_username(), v88, v89, v90);
    end;
end;
v74 = {};
do
    local l_v73_0, l_v74_1, l_v75_1, l_v78_1, l_v79_1 = v73, v74, v75, v78, v79;
    l_v75_1 = function(v96)
        -- upvalues: l_v74_1 (ref)
        if l_v74_1[v96] == nil then
            l_v74_1[v96] = {};
            events[v96]:set(function(_)
                -- upvalues: l_v74_1 (ref), v96 (ref)
                local v98 = l_v74_1[v96];
                v98.local_player = entity.get_local_player();
                v98.is_valid = v98.local_player ~= nil and v98.local_player:is_alive();
            end);
            return l_v74_1[v96];
        else
            return l_v74_1[v96];
        end;
    end;
    l_v78_1 = {
        __index = function(v99, v100)
            -- upvalues: l_v75_1 (ref), v72 (ref), l_v73_0 (ref)
            local v101 = events[v100];
            return {
                set = function(_, v103)
                    -- upvalues: l_v75_1 (ref), v100 (ref), v72 (ref), l_v73_0 (ref), v99 (ref), v101 (ref)
                    local v104 = l_v75_1(v100);
                    local v105 = nil;
                    v105 = not v72.DEV_MODE and function(v106)
                        -- upvalues: v103 (ref), v104 (ref), l_v73_0 (ref), v99 (ref), v100 (ref)
                        local v107 = nil;
                        local v108 = nil;
                        if v106 == nil then
                            local l_status_1, l_result_1 = pcall(v103, v104.local_player, v104.is_valid);
                            v108 = l_result_1;
                            v107 = l_status_1;
                        else
                            local l_status_2, l_result_2 = pcall(v103, v106, v104.local_player, v104.is_valid);
                            v108 = l_result_2;
                            v107 = l_status_2;
                        end;
                        if not v107 then
                            return l_v73_0.send(common.get_username(), l_v73_0.markup(v99.name, v100, v108), v99.name);
                        else
                            return v108;
                        end;
                    end or function(v113)
                        -- upvalues: v103 (ref), v104 (ref)
                        if v113 == nil then
                            return v103(v104.local_player, v104.is_valid);
                        else
                            return v103(v113, v104.local_player, v104.is_valid);
                        end;
                    end;
                    v101:set(v105);
                end
            };
        end, 
        __tostring = function(v114)
            return "callback instance(" .. v114.name .. ")";
        end
    };
    l_v79_1 = {};
    local function v116(v115)
        -- upvalues: l_v79_1 (ref), l_v78_1 (ref)
        if l_v79_1[v115] == nil then
            l_v79_1[v115] = setmetatable({
                name = v115
            }, l_v78_1);
        end;
        return l_v79_1[v115];
    end;
    local v119 = {
        __index = function(_, v118)
            -- upvalues: v116 (ref)
            return v116(v118);
        end
    };
    v72 = setmetatable(v72, v119);
end;
v73 = nil;
v73 = {};
v74 = utils.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
v75 = function(v120, v121, v122, v123, v124)
    local v125 = v120(v123, v121, v122 - v121, v124);
    if type(v125) == "number" then
        if math.abs(v122 - v125) <= 0.01 then
            return v122;
        else
            local v126 = v125 % 1;
            if v126 < 0.001 then
                return math.floor(v125);
            elseif v126 > 0.999 then
                return math.ceil(v125);
            end;
        end;
    end;
    return v125;
end;
v78 = {};
do
    local l_v74_2, l_v75_2, l_v78_2 = v74, v75, v78;
    v79 = function(v130, v131, v132, v133)
        -- upvalues: l_v74_2 (ref), l_v75_2 (ref)
        local v134 = type(v130.value);
        local v135 = type(v132);
        if v135 == "boolean" then
            v132 = v132 and 1 or 0;
            v135 = "number";
        end;
        assert(v134 == v135, string.format("type mismatch, expected %s (received %s)", v134, v135));
        if v132 ~= v130.to then
            v130.clock = 0;
            v130.from = v130.value;
            v130.to = v132;
        end;
        local v136 = globals.frametime / l_v74_2();
        local v137 = v131 or 0.15;
        if v130.clock == v137 then
            return v132;
        elseif v136 <= 0 and v137 <= v136 then
            v130.clock = 0;
            v130.from = v132;
            v130.to = v132;
            v130.value = v132;
            return v132;
        else
            v130.clock = math.min(v130.clock + v136, v137);
            v130.value = l_v75_2(v133 or v130.easings, v130.from, v130.to, v130.clock, v137);
            return v130.value;
        end;
    end;
    l_v78_2.__metatable = false;
    l_v78_2.__call = v79;
    l_v78_2.__index = l_v78_2;
    v73.new = function(_, v139, v140)
        -- upvalues: l_v78_2 (ref)
        if type(v139) == "boolean" then
            v139 = v139 and 1 or 0;
        end;
        local v145 = {
            clock = 0, 
            value = not v139 and 0 or v139, 
            easings = v140 or function(v141, v142, v143, v144)
                return v143 * v141 / v144 + v142;
            end
        };
        return setmetatable(v145, l_v78_2);
    end;
end;
v74 = nil;
v74 = {};
v75 = {};
v78 = "";
v79 = false;
local v146 = vector();
local v147 = false;
local v148 = false;
local v149 = false;
local v150 = v57.screen_center.x + 20;
local v151 = v57.screen_center.x - 20;
local v152 = nil;
local v153 = ui.create("...");
do
    local l_v75_3, l_v78_3, l_v79_2, l_v146_0, l_v147_0, l_v148_0, l_v149_0, l_v150_0, l_v151_0, l_v152_0, l_v153_0 = v75, v78, v79, v146, v147, v148, v149, v150, v151, v152, v153;
    v74.add = function(v165, v166, v167)
        -- upvalues: l_v75_3 (ref), l_v153_0 (ref), v57 (ref), l_v147_0 (ref), l_v146_0 (ref), l_v149_0 (ref), l_v79_2 (ref), l_v78_3 (ref), l_v148_0 (ref), l_v151_0 (ref), l_v150_0 (ref)
        l_v75_3[v165] = {
            is_in_b = false, 
            is_rmb_pressed = false, 
            dragging = false, 
            id = v165, 
            menu = {
                x = l_v153_0:slider(v165 .. "_x", 0, v57.screen.x, v166.x), 
                y = l_v153_0:slider(v165 .. "_y", 0, v57.screen.y, v166.y)
            }, 
            position = v166, 
            size = v167, 
            max = v57.screen - v167, 
            drag = vector(), 
            process = function(v168)
                -- upvalues: l_v147_0 (ref), l_v146_0 (ref), l_v149_0 (ref), l_v79_2 (ref), l_v78_3 (ref), v165 (ref), l_v148_0 (ref), l_v151_0 (ref), l_v150_0 (ref), v57 (ref)
                if not l_v147_0 then
                    return v168;
                else
                    local l_position_0 = v168.position;
                    local v170 = v168.position + v168.size;
                    local v171 = l_v146_0.x >= l_position_0.x and l_v146_0.y >= l_position_0.y and l_v146_0.x <= v170.x and l_v146_0.y <= v170.y;
                    v168.is_rmb_pressed = v171 and l_v149_0;
                    v168.is_in_b = v171;
                    if v171 or v168.dragging then
                        l_v79_2 = true;
                    end;
                    if (v171 or v168.dragging) and (l_v78_3 == "" or l_v78_3 == v165) and l_v148_0 then
                        l_v78_3 = v165;
                        if not v168.dragging then
                            v168.dragging = true;
                            v168.drag = l_v146_0 - l_position_0;
                        else
                            v168.position = l_v146_0 - v168.drag;
                        end;
                    elseif not l_v148_0 then
                        l_v78_3 = "";
                        v168.dragging = false;
                        v168.drag = vector(0, 0);
                    end;
                    v168.position = vector(math.clamp(v168.position.x, 0, v168.max.x), math.clamp(v168.position.y, 0, v168.max.y));
                    v168.menu.x:set(v168.position.x);
                    v168.menu.y:set(v168.position.y);
                    return v168;
                end;
            end
        };
        if l_v75_3[v165].menu.x:get() ~= v166.x then
            l_v75_3[v165].position = vector(l_v75_3[v165].menu.x:get(), l_v75_3[v165].menu.y:get());
        end;
        l_v75_3[v165].menu.x:visibility(false);
        l_v75_3[v165].menu.y:visibility(false);
        return l_v75_3[v165];
    end;
    v72.Containers.render:set(function()
        -- upvalues: l_v152_0 (ref), l_v79_2 (ref), l_v147_0 (ref), v57 (ref), l_v146_0 (ref), l_v148_0 (ref), l_v149_0 (ref)
        l_v152_0 = nil;
        l_v79_2 = false;
        l_v147_0 = v57.menu_alpha > 0;
        if l_v147_0 then
            l_v146_0 = ui.get_mouse_position();
            l_v148_0 = common.is_button_down(1);
            l_v149_0 = common.is_button_down(2);
            if l_v149_0 then
                l_v148_0 = false;
            end;
        end;
    end);
    v72.Containers.mouse_input:set(function()
        -- upvalues: l_v79_2 (ref)
        return not l_v79_2;
    end);
end;
v75 = function(v172, v173)
    local v174 = globals.realtime * (v173 or 1) % math.pi;
    local v175 = math.sin(v174 + (v172 or 0));
    return (math.abs(v175));
end;
v78 = function(v176)
    local v177 = rage.antiaim:get_target();
    if v177 == nil then
        return;
    else
        local v178 = v176:get_origin();
        local v179 = math.normalize_yaw(v177 - 180);
        local v180 = nil;
        local l_huge_0 = math.huge;
        entity.get_players(true, true, function(v182)
            -- upvalues: v178 (ref), v179 (ref), l_huge_0 (ref), v180 (ref)
            local v183 = (v182:get_origin() - v178):angles();
            if math.abs(v183.y - v179) < l_huge_0 then
                v180 = v182;
                l_huge_0 = math.abs(v183.y - v179);
            end;
        end);
        return v180;
    end;
end;
v79 = nil;
table.convert = function(v184)
    if v184 == nil then
        return {};
    else
        local v185 = {};
        for v186 = 1, #v184 do
            v185[v184[v186]] = true;
        end;
        return v185;
    end;
end;
table.invert = function(v187)
    if v187 == nil then
        return {};
    else
        local v188 = {};
        for v189, v190 in pairs(v187) do
            if v190 then
                v188[#v188 + 1] = v189;
            end;
        end;
        return v188;
    end;
end;
table.contains = function(v191, v192)
    local v193 = false;
    for v194 = 1, #v191 do
        if v191[v194] == v192 then
            v193 = true;
            break;
        end;
    end;
    return v193;
end;
table.tostring = function(v195)
    local v196 = "";
    local v197 = {};
    for v198 in pairs(v195) do
        table.insert(v197, v198);
    end;
    table.sort(v197);
    for v199 = 1, #v197 do
        local v200 = v197[v199];
        local v201 = v195[v200];
        v196 = v196 .. v200 .. tostring(v201);
    end;
    return v196;
end;
string.clamp = function(v202, v203)
    if v203 < v202:len() then
        v202 = v202:sub(0, v203) .. "...";
    end;
    return v202;
end;
string.split = function(v204, v205)
    local v206 = {};
    local v207 = string.format("(.-)%s", v205);
    local v208 = 0;
    local v209, v210, v211 = string.find(v204, v207, 1);
    while v209 do
        if v209 ~= 1 or v211 ~= "" then
            table.insert(v206, v211);
        end;
        v208 = v210 + 1;
        local v212, v213, v214 = string.find(v204, v207, v208);
        v211 = v214;
        v210 = v213;
        v209 = v212;
    end;
    if v208 <= #v204 then
        v211 = v204:sub(v208);
        table.insert(v206, v211);
    end;
    return v206;
end;
string.proper_len = function(v215)
    return #v215:gsub("[\128-\191]", "");
end;
string.wave = function(v216, v217, v218, v219)
    -- upvalues: v75 (ref)
    local v220 = 0;
    local v221 = 1 / (string.proper_len(v216) - 1);
    local v225, v226 = v216:gsub("(.[\128-\191]*)", function(v222)
        -- upvalues: v75 (ref), v220 (ref), v219 (ref), v217 (ref), v218 (ref), v221 (ref)
        local v223 = v75(v220, v219);
        local v224 = v217:lerp(v218, v223);
        v220 = v220 + v221;
        return string.format("\a%s%s", v224:to_hex(), v222), v224;
    end);
    return v225, v226;
end;
v146 = l_puiwka_0.initialize("xo-yaw");
v147 = {};
v148 = nil;
v149 = {
    Home = l_puiwka_0.name("house", "## Home", 0, 5), 
    Global = l_puiwka_0.name("earth-americas", "Global", 0, 5), 
    group_global = l_puiwka_0.name("gears", "## General", 0, 5), 
    tab_selection = l_puiwka_0.name("", "## Selection", 0, 0), 
    Information = l_puiwka_0.name("", "## Information", 0, 0), 
    Configs = l_puiwka_0.name("", "## Configs", 0, 0), 
    Clickable = l_puiwka_0.name("computer-mouse-scrollwheel", "Clickable", 0, 5), 
    Ragebot_Main = l_puiwka_0.name("", "## Main", 0, 0), 
    AAOther_Tab = l_puiwka_0.name("", "## Other", 0, 0), 
    AAAngles_Tab = l_puiwka_0.name("", "## Angles", 0, 0), 
    AADefensive_Tab = l_puiwka_0.name("", "## Defensive", 0, 0), 
    Visuals_Indication = l_puiwka_0.name("", "## Indicate", 0, 0), 
    Visuals_View = l_puiwka_0.name("", "## View", 0, 0), 
    Visuals_InGame = l_puiwka_0.name("", "## In-Game", 0, 0), 
    Misc_Movement = l_puiwka_0.name("", "## Movement", 0, 0), 
    Misc_InGame = l_puiwka_0.name("", "## Shared Features", 0, 0), 
    Misc_Other = l_puiwka_0.name("", "## Modifications", 0, 0), 
    toggle_on = l_puiwka_0.name("toggle-on", "%s", 1, 9), 
    toggle_off = l_puiwka_0.name("toggle-off", "%s", 1, 9), 
    ["Unlock Ping Spike"] = l_puiwka_0.name("satellite-dish", "Unlock Ping", 3, 12), 
    Tweaks = l_puiwka_0.name("wand-magic-sparkles", "Tweaks", 0, 12), 
    ["Automatic Teleport"] = l_puiwka_0.name("user-alien", "Discharge Exploit", 2, 15), 
    ["Baim Lethal"] = l_puiwka_0.name("skull", "Body Aim if Lethal", 2, 13), 
    ["Event Logger"] = l_puiwka_0.name("comment", "Event Logger", 2, 13), 
    ["Fast Switch"] = l_puiwka_0.name("hand-fist", "Quick Switch", 3, 14), 
    ["Break LC"] = l_puiwka_0.name("transporter", "Force Teleport Exploit", 2, 13), 
    ["Manual Yaw4ik"] = l_puiwka_0.name("street-view", "Manual Yaw", 1, 13), 
    ["Safe H"] = l_puiwka_0.name("user-shield", "Safe Head", 1, 9), 
    ["FS Disablers"] = l_puiwka_0.name("toggle-large-off", "FS Disablers", 0, 11), 
    Randomization = l_puiwka_0.name("shuffle", "Randomization", 2, 11), 
    ["Legit AA"] = l_puiwka_0.name("circle-up", "Allow Anti Aim on Use", 2, 11), 
    Edge = l_puiwka_0.name("magnet", "Edge Yaw", 3, 12), 
    Backstab = l_puiwka_0.name("knife-kitchen", "Anti Backstab", 1, 11), 
    ["Vanish Mode"] = l_puiwka_0.name("eye-slash", "Vanish Mode", 0, 9), 
    ["Force Lag"] = l_puiwka_0.name("bolt", "Force Lag", 2, 12), 
    ["Hide Shots Def"] = l_puiwka_0.name("thumbs-up", "Compatible with Hide Shots", 1, 12), 
    ["Build Hidden"] = l_puiwka_0.name("terminal", "Build Hidden", 1, 11), 
    Preset = l_puiwka_0.name("user-pen", "Preset", 0, 10), 
    ["Player State"] = l_puiwka_0.name("person-walking-arrow-loop-left", "Player State", 0, 10), 
    ["Crosshair Indicators"] = l_puiwka_0.name("sliders", "Crosshair Indicators", 0, 10), 
    ["Manual Arrows"] = l_puiwka_0.name("location-arrow", "Manual Arrows", 0, 13), 
    Widgets = l_puiwka_0.name("pen-swirl", "Widgets", 0, 12), 
    GS = l_puiwka_0.name("gallery-thumbnails", "Screen Indicators", 0, 10), 
    Viewmodel = l_puiwka_0.name("hand-sparkles", "Override Viewmodel", 1, 8), 
    ["Animate Zoom"] = l_puiwka_0.name("magnifying-glass", "Animate Scope Zoom", 2, 11), 
    ["Aspect Ratio"] = l_puiwka_0.name("display", "Override Aspect Ratio", 1, 10), 
    ["Custom Scope"] = l_puiwka_0.name("crosshairs-simple", "Better Scope Overlay", 1, 11), 
    ["Hit Marker"] = l_puiwka_0.name("bullseye-arrow", "Hit Marker", 1, 11), 
    ["Grenade Radius"] = l_puiwka_0.name("bomb", "Grenade Radius", 1, 11), 
    ["Fast Ladder"] = l_puiwka_0.name("water-ladder", "Fast Ladder", 1, 11), 
    ["No Fall Damage"] = l_puiwka_0.name("person-falling-burst", "No Fall Damage", 1, 8), 
    ["Unmute Players"] = l_puiwka_0.name("volume-slash", "Unmute Muted Players", 0, 9), 
    ["Taskbar Notify"] = l_puiwka_0.name("triangle-exclamation", "Taskbar Notification", 2, 12), 
    Trashtalk = l_puiwka_0.name("face-angry-horns", "Trashtalk", 1, 10), 
    ["Drop Nades"] = l_puiwka_0.name("bomb", "Drop Nades", 2, 11), 
    ["Custom Console"] = l_puiwka_0.name("square-terminal", "Custom Console Color", 3, 13), 
    Clantag = l_puiwka_0.name("user-tag", "Clan Tag", 0, 9), 
    ["Shared Logo"] = l_puiwka_0.name("sparkles", "Shared Logo", 2, 12), 
    ["Damage Indicator"] = l_puiwka_0.name("hundred-points", "Damage Indicator", 0, 11), 
    ["Animation Breakers"] = l_puiwka_0.name("person-walking", "Animation Breaker", 4, 14), 
    Reset = l_puiwka_0.name("rotate-left", "Reset", 0, 5)
};
for v227, v228 in pairs(v149) do
    ui.localize("en", v227, v228);
end;
v149 = function(v229, v230)
    v229:name(v229:get() and string.format(ui.localize("en", "toggle_on"), " Override " .. v230) or string.format(ui.localize("en", "toggle_off"), " Override " .. v230));
end;
v150 = nil;
v150 = {};
v146:new_group(1, "Home", "Information", function(v231)
    -- upvalues: l_puiwka_0 (ref), v57 (ref)
    v231:label("username")(l_puiwka_0.name("user", string.format("Welcome back, \a{Link Active}%s!", v57.username), 2, 10));
    v231:label("version")(l_puiwka_0.name("tag", string.format("Branch: \a{Link Active}%s", v57.version), 2, 10));
    v231:label("updated")(l_puiwka_0.name("circle-check", string.format("Updated: \a{Link Active}%s \t\t", v57.update_date), 2, 8));
    v231:button("discord_button")(string.format("\a{Link Active}%s  \a{Active Text}Discord", ui.get_icon("discord")), function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/GkJhY44rdB");
    end, true);
    v231:button("discord_verify")(string.format("\a{Link Active}%s  \a{Active Text}Get Discord Token", ui.get_icon("user-check")), nil, true).disabled = true;
    v231:button("products")(string.format("\a{Link Active}%s  \a{Active Text}Products:", ui.get_icon("cart-shopping")), nil, true);
    v231:button("bloom_tool")(string.format("\a{Link Active}%s  \a{Active Text}Bloom.tool", ui.get_icon("handshake")), function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=Jsrk0K");
    end, true);
end);
v146:new_group(2, "Home", "Configs", function(v232)
    -- upvalues: l_puiwka_0 (ref), v146 (ref)
    v232:list("config_list")("## Presets");
    v232:button("load")(l_puiwka_0.name("loader", "Load", 2, 5), nil, true).tooltip = "Loads a choosen config.";
    v232:button("save")(l_puiwka_0.name("floppy-disk", "Save", 2, 5), nil, true).tooltip = "Creates / Overwrites current config.";
    v232:button("remove")(l_puiwka_0.name("trash", "Remove", 2, 5), nil, true).tooltip = "Removes a config.";
    v232:button("cfg_tutorial")(l_puiwka_0.name("file-circle-question", "", 5, 0), nil, true).tooltip = "Tutorial: how to load config (in console)";
    v146:reference("cfg_tutorial"):set_callback(function(v233)
        if v233 then
            utils.console_exec("play ui/beepclear");
            print_raw("\n\a{Link Active}xo-yaw \a808080FF\194\183 \aDEFAULTGet config in your clipboard \n\a{Link Active}xo-yaw \a808080FF\194\183 \aDEFAULTWrite name for config and click save\n\a{Link Active}xo-yaw \a808080FF\194\183 \aDEFAULTClick import");
        end;
    end);
    v232:button("export")(l_puiwka_0.name("file-export", "Export", 2, 5), nil, true).tooltip = "Exports a config.";
    v232:button("import")(l_puiwka_0.name("file-import", "Import", 2, 5), nil, true).tooltip = "Imports a config.";
    v232:button("default")(l_puiwka_0.name("file-check", "Default", 2, 5), nil, true).tooltip = "Loads default config from script author.";
    v232:input("config_name")("## Name");
end);
v151 = nil;
v151 = {
    tabs = {
        [1] = " Ragebot", 
        [2] = "Anti Aim", 
        [3] = "Visuals", 
        [4] = "Misc"
    }, 
    icons = {
        [1] = "crosshairs", 
        [2] = "user-shield", 
        [3] = "paintbrush", 
        [4] = "sparkles"
    }
};
do
    local l_v147_1, l_v149_1, l_v151_1 = v147, v149, v151;
    l_v147_1.general_selection = v146:new_group(1, "group_global", "tab_selection", function(v237)
        -- upvalues: l_v151_1 (ref)
        l_v151_1.tab_list = v237:list("general_tabs")("\n", l_v151_1.tabs);
        l_v151_1.handle_tabs = function()
            -- upvalues: l_v151_1 (ref)
            for v238, v239 in next, l_v151_1.tabs do
                ui.localize("en", v239, string.format("%s %s\t\aDEFAULT%s", l_v151_1.tab_list:get() == v238 and "\a{Link Active}" or "\aDEFAULT", ui.get_icon(l_v151_1.icons[v238]), l_v151_1.tabs[v238]));
            end;
        end;
        l_v151_1.tab_list.saveable = false;
        l_v151_1.tab_list:set_callback(l_v151_1.handle_tabs, true);
    end);
    v152 = nil;
    l_v147_1.rage_main = v146:new_group(2, "group_global", "Ragebot_Main", function(v240)
        -- upvalues: v57 (ref), v60 (ref), v146 (ref)
        v240:selectable("rage_tweaks")("Tweaks", {
            [1] = "Fix Throw Nades", 
            [2] = "Ignore Shift While Air Strafe"
        });
        local _ = nil;
        local v242, v243 = v240:switch("automatic_tp")("Automatic Teleport");
        v243:selectable("automatic_tp_weapons")("Weapons", {
            [1] = "Auto", 
            [2] = "Scout", 
            [3] = "AWP", 
            [4] = "Pistols", 
            [5] = "Taser", 
            [6] = "Knife"
        });
        v243:slider("automatic_tp_delay")("Delay", 1, 6, 2);
        do
            local l_v243_0 = v243;
            v242:set_callback(function(v245)
                -- upvalues: l_v243_0 (ref)
                l_v243_0.visibility = v245:get();
            end, true);
        end;
        v240:switch("baim_lethal")("Baim Lethal");
        v242 = nil;
        local v246;
        v243, v246 = v240:switch("event_logger")("Event Logger");
        local v247 = v246:selectable("event_logger_events")("Events", {
            [1] = "Aimbot Shots", 
            [2] = "Damage Dealt", 
            [3] = "Purchases"
        });
        local _ = v246:selectable("event_logger_draw")("Draw", {
            [1] = "Console", 
            [2] = "Events", 
            [3] = "Custom Notify"
        });
        local v249 = v246:color_picker("event_logger_clr")("Color", v57.colors.default);
        local v250 = v246:color_picker("event_logger_miss_clr")("Miss Color", color(255, 0, 0));
        do
            local l_v243_1, l_v246_0 = v243, v246;
            do
                local l_v247_0, l_v249_0, l_v250_0 = v247, v249, v250;
                local function v259()
                    -- upvalues: l_v243_1 (ref), v60 (ref), l_v247_0 (ref)
                    if l_v243_1:get() then
                        local v256 = table.convert(v60.MISC.log_events:get());
                        for _, v258 in pairs(l_v247_0:get()) do
                            if v258 then
                                v256[v258] = false;
                            end;
                        end;
                        v60.MISC.log_events:override(table.invert(v256));
                    else
                        v60.MISC.log_events:override();
                    end;
                end;
                l_v243_1:set_callback(function(v260)
                    -- upvalues: l_v246_0 (ref), v259 (ref)
                    l_v246_0.visibility = v260:get();
                    v259();
                end, true);
                l_v247_0:set_callback(function(v261)
                    -- upvalues: l_v249_0 (ref), l_v250_0 (ref), v259 (ref)
                    l_v249_0.visibility = #v261:get() ~= 0;
                    l_v250_0.visibility = v261:get("Aimbot Shots");
                    v259();
                end, true);
                v60.MISC.log_events:set_callback(v259, true);
            end;
        end;
        v240:switch("fast_switch")("Fast Switch"):set_callback(function(v262)
            -- upvalues: v60 (ref)
            if v262:get() then
                local v263 = table.convert(v60.MISC.weapon_actions:get());
                v263["Quick Switch"] = false;
                v60.MISC.weapon_actions:override(table.invert(v263));
            else
                v60.MISC.weapon_actions:override();
            end;
        end);
        v240:switch("force_tp")("Break LC");
        v240:slider("ping_spike_unlock")("Unlock Ping Spike", 0, 200, 0, 1, function(v264)
            if v264 == 0 then
                return "Off";
            else
                return v264 .. "ms";
            end;
        end);
        v146:reference("ping_spike_unlock"):set_callback(function(v265)
            -- upvalues: v60 (ref)
            if v265:get() == 0 then
                return v60.MISC.fake_latency:override();
            else
                v60.MISC.fake_latency:override(v265:get());
                return;
            end;
        end);
    end);
    v153 = nil;
    l_v147_1.antiaim_other = v146:new_group(1, "group_global", "AAOther_Tab", function(v266)
        -- upvalues: v60 (ref)
        local _ = nil;
        local v268, v269 = v266:combo("manual_yaw")("Manual Yaw4ik", {
            [1] = "Disabled", 
            [2] = "Forward", 
            [3] = "Backward", 
            [4] = "Left", 
            [5] = "Right"
        });
        v269:switch("manual_yaw_disabler")("Disable Yaw Modifiers", true);
        v269:switch("manual_yaw_body_freestanding")("Body Freestanding");
        v266:selectable("safe_head")("Safe H", {
            [1] = "Stand", 
            [2] = "Crouch", 
            [3] = "Crouch Move", 
            [4] = "Slow Walk", 
            [5] = "Air+", 
            [6] = "Air Knife", 
            [7] = "Air Zeus"
        });
        v266:selectable("freestand_disablers")("FS Disablers", {
            [1] = "Stand", 
            [2] = "Move", 
            [3] = "Slow Walk", 
            [4] = "Crouch", 
            [5] = "Crouch Move", 
            [6] = "Air", 
            [7] = "Air+"
        });
        v268 = nil;
        v269 = nil;
        local v270 = nil;
        local v271 = nil;
        local v272, v273 = v266:switch("randomize_switch")("Randomization");
        v269 = v273;
        v268 = v272;
        v270 = v269:switch("randomize_on_warmup")("On Warmup", true);
        v271 = v269:switch("randomize_on_round_end")("On Round End", true);
        v268:set_callback(function(v274)
            -- upvalues: v270 (ref), v271 (ref)
            v270.visibility = v274:get();
            v271.visibility = v274:get();
        end, true);
        v266:switch("legit_aa")("Legit AA");
        v266:switch("edge_yaw")("Edge");
        v266:switch("anti_backstab")("Backstab"):set_callback(function(v275)
            -- upvalues: v60 (ref)
            v60.AA.angles.yaw.backstab:override(not v275:get());
        end, true);
        v266:switch("vanish_mode")("Vanish Mode");
    end);
    l_v147_1.antiaim_angles = v146:new_group(2, "group_global", "AAAngles_Tab", function(v276)
        -- upvalues: v57 (ref), l_v147_1 (ref), v146 (ref), l_v149_1 (ref), l_v151_1 (ref)
        local v277 = v276:combo("antiaim_type")("Preset", {
            [1] = "Disabled", 
            [2] = "Aggressive", 
            [3] = "Unrivaled", 
            [4] = "Classic", 
            [5] = "Builder"
        });
        local v278 = v276:combo("PlayerState")("Player State", v57.states);
        v277:set_callback(function(v279)
            -- upvalues: v278 (ref)
            v278.visibility = v279:get() == "Builder";
        end, true);
        for _, v281 in ipairs(v57.states) do
            do
                local l_v281_0 = v281;
                l_v147_1[l_v281_0] = v146:new_group(2, "group_global", string.format("## %s Angles", l_v281_0), function(v283)
                    -- upvalues: l_v281_0 (ref), v57 (ref), v276 (ref), l_v149_1 (ref), v146 (ref)
                    if l_v281_0 ~= v57.states[1] then
                        v276:switch("Enabled_" .. l_v281_0)("Override " .. l_v281_0):set_callback(function(v284)
                            -- upvalues: l_v149_1 (ref), l_v281_0 (ref)
                            l_v149_1(v284, l_v281_0);
                        end, true);
                    end;
                    if l_v281_0 ~= v57.states[10] then
                        v283:combo("Pitch_" .. l_v281_0)("Pitch", {
                            [1] = "Disabled", 
                            [2] = "Down", 
                            [3] = "Fake Down", 
                            [4] = "Fake Up"
                        }):set("Down");
                        local _ = nil;
                        local v286, v287 = v283:combo("Yaw_" .. l_v281_0)("Yaw", {
                            [1] = "Disabled", 
                            [2] = "Backward", 
                            [3] = "Static"
                        });
                        v286:set("Backward");
                        v287:combo("YawBase_" .. l_v281_0)("Yaw Base", {
                            [1] = "Local View", 
                            [2] = "At Target"
                        });
                        v287:combo("YawType_" .. l_v281_0)("Yaw Type", {
                            [1] = "180", 
                            [2] = "Left / Right", 
                            [3] = "Flick", 
                            [4] = "Sway", 
                            [5] = "Spin"
                        });
                        v287:slider("YawOffset_" .. l_v281_0)("Offset", -180, 180, 0, 1, "\194\176");
                        v287:slider("YawOffsetLeft_" .. l_v281_0)("Left Offset", -180, 180, 0, 1, "\194\176");
                        v287:slider("YawOffsetRight_" .. l_v281_0)("Right Offset", -180, 180, 0, 1, "\194\176");
                        v287:slider("YawD_" .. l_v281_0)("Delay ## Bebra", 1, 15, 1, 1, function(v288)
                            return v288 .. "t";
                        end);
                        v287:slider("YawD2_" .. l_v281_0)("Second Delay ## Bebra", 0, 15, 0, 1, function(v289)
                            if v289 == 0 then
                                return "Off";
                            else
                                return v289 .. "t";
                            end;
                        end);
                        v287:slider("YawDelay_" .. l_v281_0)("Delay", 1, 64, 5, 1, "t");
                        v287:slider("YawSpeed_" .. l_v281_0)("Speed", 1, 64, 5, 1, "t");
                        v146:reference("YawBase_" .. l_v281_0):set("At Target");
                        local function v291()
                            -- upvalues: v146 (ref), l_v281_0 (ref)
                            local v290 = v146:reference("YawType_" .. l_v281_0):get();
                            v146:reference("YawOffset_" .. l_v281_0).visibility = v290 == "180";
                            v146:reference("YawOffsetLeft_" .. l_v281_0).visibility = v290 ~= "180";
                            v146:reference("YawOffsetRight_" .. l_v281_0).visibility = v290 ~= "180";
                            v146:reference("YawD_" .. l_v281_0).visibility = v290 == "Left / Right";
                            v146:reference("YawD2_" .. l_v281_0).visibility = v290 == "Left / Right";
                            v146:reference("YawDelay_" .. l_v281_0).visibility = v290 == "Flick" or v290 == "Sway";
                            v146:reference("YawSpeed_" .. l_v281_0).visibility = v290 == "Sway" or v290 == "Spin";
                        end;
                        v146:reference("YawD_" .. l_v281_0):set_callback(v291, true);
                        v146:reference("YawType_" .. l_v281_0):set_callback(v291, true);
                    end;
                    local _ = nil;
                    local v293, v294 = v283:combo("YawModifier_" .. l_v281_0)("Yaw Modifier", {
                        [1] = "Disabled", 
                        [2] = "Center", 
                        [3] = "Offset", 
                        [4] = "Random", 
                        [5] = "Spin", 
                        [6] = "3-Way", 
                        [7] = "5-Way"
                    });
                    v294:switch("YawModifierWayType_" .. l_v281_0)("Custom Way Values");
                    for v295 = 1, 5 do
                        v294:slider(string.format("YawModifierOffset_%s_%s", v295, l_v281_0))(string.format("Offset %s", v295 == 1 and "" or v295), -180, 180, 0, 1, "\194\176");
                    end;
                    v294:slider("YawModifierRandomize_" .. l_v281_0)("Randomize", 0, 180, 0, 1, function(v296)
                        if v296 == 0 then
                            return "Off";
                        else
                            return v296 .. "\194\176";
                        end;
                    end);
                    local function v299()
                        -- upvalues: v146 (ref), l_v281_0 (ref)
                        local v297 = v146:reference("YawModifierWayType_" .. l_v281_0):get();
                        local v298 = v146:reference("YawModifier_" .. l_v281_0):get();
                        v146:reference("YawModifierWayType_" .. l_v281_0).visibility = v298 == "5-Way" or v298 == "3-Way";
                        v146:reference("YawModifierOffset_2_" .. l_v281_0).visibility = v297 and (v298 == "5-Way" or v298 == "3-Way");
                        v146:reference("YawModifierOffset_3_" .. l_v281_0).visibility = v297 and (v298 == "5-Way" or v298 == "3-Way");
                        v146:reference("YawModifierOffset_4_" .. l_v281_0).visibility = v297 and v298 == "5-Way";
                        v146:reference("YawModifierOffset_5_" .. l_v281_0).visibility = v297 and v298 == "5-Way";
                    end;
                    v146:reference("YawModifier_" .. l_v281_0):set_callback(v299, true);
                    v146:reference("YawModifierWayType_" .. l_v281_0):set_callback(v299, true);
                    v293 = nil;
                    v294, v299 = v283:switch("BodyYaw_" .. l_v281_0)("Body Yaw");
                    v299:combo("LimitType_" .. l_v281_0)("Limit Type", {
                        [1] = "Default", 
                        [2] = "Flick", 
                        [3] = "Sway"
                    });
                    v299:slider("LeftLimit_" .. l_v281_0)("Left Limit", 0, 58, 58, 1, "\194\176");
                    v299:slider("RightLimit_" .. l_v281_0)("Right Limit", 0, 58, 58, 1, "\194\176");
                    v299:slider("LimitDelay_" .. l_v281_0)("Delay", 1, 64, 5, 1, "t");
                    v299:slider("LimitSpeed_" .. l_v281_0)("Speed", 1, 64, 5, 1, "t");
                    v299:selectable("FakeOptions_" .. l_v281_0)("Options", {
                        [1] = "Avoid Overlap", 
                        [2] = "Jitter", 
                        [3] = "Randomize Jitter", 
                        [4] = "Anti Bruteforce"
                    });
                    v299:combo("Freestanding_" .. l_v281_0)("Freestanding", {
                        [1] = "Off", 
                        [2] = "Peek Fake", 
                        [3] = "Peek Real"
                    });
                    local function v301()
                        -- upvalues: v146 (ref), l_v281_0 (ref)
                        local v300 = v146:reference("LimitType_" .. l_v281_0):get();
                        v146:reference("LimitDelay_" .. l_v281_0).visibility = v300 ~= "Default";
                        v146:reference("LimitSpeed_" .. l_v281_0).visibility = v300 == "Sway";
                    end;
                    v146:reference("LimitType_" .. l_v281_0):set_callback(v301, true);
                    v294 = nil;
                    v299, v301 = v283:switch("ExtendedAngles_" .. l_v281_0)("Extended Angles");
                    v301:slider("ExtendedPitch_" .. l_v281_0)("Pitch", -180, 180, 0, 1, "\194\176");
                    v301:slider("ExtendedRoll_" .. l_v281_0)("Roll", 0, 90, 45, 1, "\194\176");
                end);
                local _ = nil;
                local function v304()
                    -- upvalues: l_v281_0 (ref), v57 (ref), v146 (ref), v278 (ref), v277 (ref), l_v147_1 (ref), l_v151_1 (ref)
                    local v303 = nil;
                    if l_v281_0 ~= v57.states[1] then
                        v303 = v146:reference("Enabled_" .. l_v281_0);
                        v303.visibility = v278:get() == l_v281_0 and v277.reference:get() == "Builder";
                    end;
                    l_v147_1[l_v281_0].visibility = v278:get() == l_v281_0 and l_v151_1.tab_list.reference:get() == 2 and (l_v281_0 == v57.states[1] or v303.get(v303)) and v277.reference:get() == "Builder";
                end;
                if l_v281_0 ~= v57.states[1] then
                    v146:reference("Enabled_" .. l_v281_0):set_callback(v304, true);
                end;
                do
                    local l_v304_0 = v304;
                    v277.reference:set_callback(function(v306)
                        -- upvalues: v278 (ref), l_v304_0 (ref)
                        v278.visibility = v306:get() == "Builder";
                        l_v304_0();
                    end, true);
                    v278:set_callback(l_v304_0, true);
                    l_v151_1.tab_list:set_callback(l_v304_0, true);
                end;
            end;
        end;
    end);
    l_v147_1.defensive_setup = v146:new_group(2, "group_global", "AADefensive_Tab", function(v307)
        -- upvalues: l_v147_1 (ref), v146 (ref), l_v149_1 (ref), l_v151_1 (ref), v57 (ref)
        local v308 = {
            [1] = "Stand", 
            [2] = "Move", 
            [3] = "Slow Walk", 
            [4] = "Crouch", 
            [5] = "Crouch Move", 
            [6] = "Air", 
            [7] = "Air+"
        };
        local v309 = {};
        for v310 = 1, #v308 do
            v309[v310] = v308[v310];
        end;
        table.insert(v309, "On Peek");
        table.insert(v309, "Triggers");
        local _ = nil;
        local v312 = {
            [1] = "Flashed", 
            [2] = "Taking Damage", 
            [3] = "Weapon Not Ready", 
            [4] = "Safe Head", 
            [5] = "Freestanding", 
            [6] = "Manual Yaw"
        };
        local v313, v314 = v307:selectable("hidden_conditions")("Force Lag", v308);
        v314:selectable("hidden_triggers")("Triggers", v312);
        v312 = v307:switch("hidden_hs")("Hide Shots Def");
        v313 = v307:switch("hidden_aa")("Build Hidden");
        v314 = v307:combo("DefPlayerState")("Player State", v309);
        v313:set_callback(function(v315)
            -- upvalues: v314 (ref)
            v314.visibility = v315:get();
        end);
        for _, v317 in ipairs(v309) do
            do
                local l_v317_0 = v317;
                l_v147_1[l_v317_0 .. "defensive"] = v146:new_group(2, "group_global", string.format("## %s Defensive Angles", l_v317_0), function(v319)
                    -- upvalues: v307 (ref), l_v317_0 (ref), l_v149_1 (ref), v146 (ref)
                    v307:switch("DefEnabled_" .. l_v317_0)("Override " .. l_v317_0):set_callback(function(v320)
                        -- upvalues: l_v149_1 (ref), l_v317_0 (ref)
                        l_v149_1(v320, l_v317_0);
                    end, true);
                    if l_v317_0 ~= "Triggers" then
                        local _, _ = v319:combo("DefMode_" .. l_v317_0)("Mode", {
                            [1] = "Default", 
                            [2] = "Flick"
                        });
                        local _ = v319:switch("DefInvertFlick_" .. l_v317_0)("Swap");
                        local v324, v325 = v319:combo("DefPitch_" .. l_v317_0)("Pitch", {
                            [1] = "Default", 
                            [2] = "Static", 
                            [3] = "Jitter", 
                            [4] = "Spin"
                        });
                        v324:set("Default");
                        v325:slider("DefPitchOffset1_" .. l_v317_0)("Offset 1", -89, 89, 0, 1, "\194\176");
                        v325:slider("DefPitchOffset2_" .. l_v317_0)("Offset 2", -89, 89, 0, 1, "\194\176");
                        v325:slider("DefPitchSpeed_" .. l_v317_0)("Speed", 1, 64, 5, 1, "t");
                        v325:slider("DefPitchRandom_" .. l_v317_0)("Randomize", 0, 89, 0, 1, "\194\176");
                        local _, v327 = v319:combo("DefYaw_" .. l_v317_0)("Yaw", {
                            [1] = "Default", 
                            [2] = "Static", 
                            [3] = "Jitter", 
                            [4] = "Spin", 
                            [5] = "3-Way", 
                            [6] = "5-Way"
                        });
                        v327:slider("DefYawOffset_" .. l_v317_0)("Offset", -180, 180, 0, 1, "\194\176");
                        v327:slider("DefYawD_" .. l_v317_0)("Delay", 1, 15, 0, 1, function(v328)
                            return v328 .. "t";
                        end);
                        v327:slider("DefYawSpeed_" .. l_v317_0)("Speed", 1, 64, 5, 1, "t");
                        v327:slider("DefYawRandom_" .. l_v317_0)("Randomize", 0, 180, 0, 1, "\194\176");
                        local function v335()
                            -- upvalues: v146 (ref), l_v317_0 (ref)
                            local v329 = v146:reference("DefMode_" .. l_v317_0):get();
                            local v330 = v146:reference("DefPitch_" .. l_v317_0):get();
                            local v331 = v146:reference("DefYaw_" .. l_v317_0):get();
                            local v332 = v329 == "Default";
                            local v333 = v329 == "Flick";
                            local v334 = v146:reference("DefForceTargetYaw_" .. l_v317_0);
                            if v334 ~= nil then
                                v334.visibility = v332;
                            end;
                            v146:reference("DefInvertFlick_" .. l_v317_0).visibility = v333;
                            v146:reference("DefPitch_" .. l_v317_0).visibility = v332;
                            v146:reference("DefYaw_" .. l_v317_0).visibility = v332;
                            v146:reference("DefPitchOffset1_" .. l_v317_0).visibility = v332 and v330 ~= "Default";
                            v146:reference("DefPitchOffset2_" .. l_v317_0).visibility = v332 and (v330 == "Jitter" or v330 == "Spin");
                            v146:reference("DefPitchSpeed_" .. l_v317_0).visibility = v332 and v330 == "Spin";
                            v146:reference("DefPitchRandom_" .. l_v317_0).visibility = v332 and v330 ~= "Default";
                            v146:reference("DefYawOffset_" .. l_v317_0).visibility = v332 and (v331 == "Static" or not (v331 ~= "Jitter") or v331 == "Spin");
                            v146:reference("DefYawD_" .. l_v317_0).visibility = v332 and v331 == "Jitter";
                            v146:reference("DefYawSpeed_" .. l_v317_0).visibility = v332 and v331 == "Spin";
                            v146:reference("DefYawRandom_" .. l_v317_0).visibility = v332 and (v331 == "Static" or not (v331 ~= "Jitter") or v331 == "Spin");
                        end;
                        v146:reference("DefMode_" .. l_v317_0):set_callback(v335, true);
                        v146:reference("DefPitch_" .. l_v317_0):set_callback(v335, true);
                        v146:reference("DefYaw_" .. l_v317_0):set_callback(v335, true);
                    end;
                    if l_v317_0 ~= "On Peek" then
                        v319:switch("DefForceTargetYaw_" .. l_v317_0)("Force Target Yaw");
                    end;
                end);
                local _ = nil;
                local function v338()
                    -- upvalues: v146 (ref), l_v317_0 (ref), v314 (ref), v313 (ref), l_v147_1 (ref), l_v151_1 (ref), v57 (ref)
                    local v337 = v146:reference("DefEnabled_" .. l_v317_0);
                    v337.visibility = v314:get() == l_v317_0 and v313.reference:get();
                    l_v147_1[l_v317_0 .. "defensive"].visibility = v314:get() == l_v317_0 and l_v151_1.tab_list.reference:get() == 2 and (l_v317_0 == v57.hidden_states or v337:get()) and v313.reference:get();
                end;
                v146:reference("DefEnabled_" .. l_v317_0):set_callback(v338, true);
                do
                    local l_v338_0 = v338;
                    v313.reference:set_callback(function(v340)
                        -- upvalues: v314 (ref), l_v338_0 (ref)
                        v314.visibility = v340:get();
                        l_v338_0();
                    end, true);
                    v314:set_callback(l_v338_0, true);
                    l_v151_1.tab_list:set_callback(l_v338_0, true);
                end;
            end;
        end;
    end);
    local _ = nil;
    l_v147_1.visuals_indication = v146:new_group(2, "group_global", "Visuals_Indication", function(v342)
        -- upvalues: v57 (ref), v60 (ref)
        local _ = nil;
        local v344, v345 = v342:switch("crosshair_indicators")("Crosshair Indicators");
        local v346 = v345:combo("crosshair_indicators_type")("Type", {
            [1] = "Stylish", 
            [2] = "Modern"
        });
        v345:switch("crosshair_indicators_align")("Scope Alignment", true);
        v345:switch("crosshair_indicators_glow")("Shadow Effect");
        v345:color_picker("crosshair_indicators_clr")("Primary Color", v57.colors.default);
        v345:color_picker("crosshair_indicators_clr2")("Secondary Color", v57.colors.white);
        local v347 = v345:slider("crosshair_indicators_anim_speed")("Animation Speed", 1, 100, 25, 0.1, "x");
        do
            local l_v345_0 = v345;
            v344:set_callback(function(v349)
                -- upvalues: l_v345_0 (ref)
                l_v345_0.visibility = v349:get();
            end, true);
            do
                local l_v347_0 = v347;
                v346:set_callback(function(v351)
                    -- upvalues: l_v347_0 (ref)
                    l_v347_0.visibility = v351:get() == "Stylish";
                end, true);
            end;
        end;
        v344 = nil;
        v345 = v342:switch("damage_indicator")("Damage Indicator");
        v346 = v345:color_picker("damage_indicator_clr")();
        v345.tooltip = "You can restore default position by clicking M2 on indicator.";
        do
            local l_v346_0 = v346;
            v345:set_callback(function(v353)
                -- upvalues: l_v346_0 (ref)
                l_v346_0.visibility = v353:get();
            end, true);
        end;
        v345 = nil;
        v346, v347 = v342:switch("manual_arrows")("Manual Arrows");
        v347:color_picker("manual_arrows_clr")("Primary Color", v57.colors.default);
        v347:color_picker("manual_arrows_clr2")("Secondary Color", v57.colors.idle);
        do
            local l_v347_1 = v347;
            v346:set_callback(function(v355)
                -- upvalues: l_v347_1 (ref)
                l_v347_1.visibility = v355:get();
            end, true);
        end;
        v346 = nil;
        local v356;
        v347, v356 = v342:switch("widgets")("Widgets");
        local v357 = v356:selectable("widgets_items")("Items", {
            [1] = "Watermark", 
            [2] = "Keybinds"
        });
        local v358 = v357:color_picker("widgets_clr")(v57.colors.default);
        local v359 = v356:slider("widgets_rounding")("Rounding", 1, 8, 2);
        local v360 = v356:switch("widgets_glow")("Shadow Effect");
        local v361 = v356:input("widgets_name")("Username", v57.username);
        do
            local l_v347_2, l_v356_0 = v347, v356;
            do
                local l_v357_0, l_v358_0, l_v359_0, l_v360_0, l_v361_0 = v357, v358, v359, v360, v361;
                local function v372()
                    -- upvalues: l_v347_2 (ref), v60 (ref), l_v357_0 (ref)
                    local l_status_3, _ = pcall(function()
                        -- upvalues: l_v347_2 (ref), v60 (ref), l_v357_0 (ref)
                        if l_v347_2:get() then
                            local v369 = table.convert(v60.MISC.windows:get());
                            if l_v357_0:get("Watermark") then
                                v369.Watermark = false;
                            end;
                            if l_v357_0:get("Keybinds") then
                                v369.Hotkeys = false;
                            end;
                            v60.MISC.windows:override(table.invert(v369));
                        else
                            v60.MISC.windows:override();
                        end;
                    end);
                    if not l_status_3 then
                        print_raw("failed to override windows");
                    end;
                end;
                l_v357_0:set_callback(function(v373)
                    -- upvalues: v372 (ref), l_v358_0 (ref), l_v359_0 (ref), l_v360_0 (ref), l_v361_0 (ref)
                    v372();
                    local v374 = #v373:get() ~= 0;
                    l_v358_0.visibility = v374;
                    l_v359_0.visibility = v374;
                    l_v360_0.visibility = v374;
                    l_v361_0.visibility = v373:get("Watermark");
                end, true);
                l_v347_2:set_callback(function(v375)
                    -- upvalues: v372 (ref), l_v356_0 (ref)
                    v372();
                    l_v356_0.visibility = v375:get();
                end, true);
                v60.MISC.windows:set_callback(v372, true);
                l_v361_0.saveable = false;
            end;
        end;
        v347 = nil;
        v356, v357 = v342:switch("gamesense")("GS");
        v358 = v357:selectable("gamesense_items")("Features", {
            [1] = "Indicators", 
            [2] = "Net Graph"
        });
        v359 = v357:selectable("gamesense_inds")("Items", {
            [1] = "Bomb", 
            [2] = "Ping Spike", 
            [3] = "Double Tap", 
            [4] = "Hide Shots", 
            [5] = "Body Aim", 
            [6] = "Safe Points", 
            [7] = "Fake Duck", 
            [8] = "Freestanding", 
            [9] = "Minimum Damage", 
            [10] = "Hit Chance", 
            [11] = "Edge Yaw", 
            [12] = "Dormant Aimbot", 
            [13] = "Aimbot Shots"
        });
        v356:set_callback(function(v376)
            -- upvalues: v357 (ref)
            v357.visibility = v376:get();
        end, true);
        do
            local l_v359_1 = v359;
            v358:set_callback(function(v378)
                -- upvalues: l_v359_1 (ref)
                l_v359_1.visibility = v378:get("Indicators");
            end, true);
        end;
    end);
    l_v147_1.visuals_view = v146:new_group(1, "group_global", "Visuals_View", function(v379)
        -- upvalues: v57 (ref)
        local v380 = nil;
        v380 = {
            fov = tonumber(cvar.viewmodel_fov:string()) or 68, 
            x = tonumber(cvar.viewmodel_offset_x:string()) or 1, 
            y = tonumber(cvar.viewmodel_offset_y:string()) or -2, 
            z = tonumber(cvar.viewmodel_offset_z:string()) or -1.5
        };
        local v381, v382 = v379:switch("viewmodel")("Viewmodel");
        v382:slider("viewmodel_fov")("Field of View", -1800, 1800, v380.fov * 10, 0.1);
        v382:slider("viewmodel_x")("Offset X", -1800, 1800, v380.x * 10, 0.1);
        v382:slider("viewmodel_y")("Offset Y", -1800, 1800, v380.y * 10, 0.1);
        v382:slider("viewmodel_z")("Offset Z", -1800, 1800, v380.z * 10, 0.1);
        v382:switch("viewmodel_sleeve")("Remove Sleeve");
        v382:switch("viewmodel_flip")("Flip Knife Hand");
        v382:button("viewmodel_reset")("Reset", nil, true).tooltip = "Resets viewmodel values to default";
        do
            local l_v382_0 = v382;
            v381:set_callback(function(v384)
                -- upvalues: l_v382_0 (ref)
                l_v382_0.visibility = v384:get();
            end, true);
        end;
        v381 = nil;
        v382 = {
            [1] = "16:9", 
            [2] = "16:10", 
            [3] = "3:2", 
            [4] = "4:3", 
            [5] = "5:4"
        };
        local v385 = {};
        for v386 = 1, #v382 do
            local v387 = v382[v386];
            local v388, v389 = v387:match("(%d*):(%d*)");
            v385[math.floor(v388 / v389 * 100)] = v387;
        end;
        local v390, v391 = v379:switch("aspect_ratio")("Aspect Ratio");
        do
            local l_v385_0, l_v391_0 = v385, v391;
            local v395 = l_v391_0:slider("aspect_ratio_value")("", 0, 300, math.floor(v57.screen.x / v57.screen.y * 100), 0.01, function(v394)
                -- upvalues: l_v385_0 (ref)
                if v394 == 0 then
                    return "Off";
                else
                    return l_v385_0[v394] or string.format("%.2f", v394 * 0.01);
                end;
            end);
            do
                local l_v395_0 = v395;
                for v397 = 1, #v382 do
                    local v398 = v382[v397];
                    local v399, v400 = v398:match("(%d*):(%d*)");
                    local v401 = math.floor(v399 / v400 * 100);
                    do
                        local l_v401_0 = v401;
                        l_v391_0:button(string.format("AspectRatioBtn%s", v397))((" %s "):format(v398), function()
                            -- upvalues: l_v395_0 (ref), l_v401_0 (ref)
                            l_v395_0:set(l_v401_0);
                        end, true);
                    end;
                end;
            end;
            v390:set_callback(function(v403)
                -- upvalues: l_v391_0 (ref)
                l_v391_0.visibility = v403:get();
            end, true);
        end;
        v379:switch("animate_zoom")("Animate Zoom");
        v382 = nil;
        v385, v390 = v379:switch("anim_breaker")("Animation Breakers");
        v390:combo("anim_breaker_ground")("Leg Movement", {
            [1] = "Disabled", 
            [2] = "Frozen", 
            [3] = "Walking", 
            [4] = "Sliding", 
            [5] = "Jitter"
        });
        v390:combo("anim_breaker_air")("In Air", {
            [1] = "Disabled", 
            [2] = "Frozen", 
            [3] = "Walking"
        });
        v390:switch("anim_breaker_pitch")("Zero Pitch on Land");
        v390:switch("anim_breaker_slowwalk")("Sliding Slow Walk");
        v390:switch("anim_breaker_crouch")("Sliding Crouch");
        v385:set_callback(function(v404)
            -- upvalues: v390 (ref)
            v390.visibility = v404:get();
        end, true);
    end);
    l_v147_1.visuals_ingame = v146:new_group(2, "group_global", "Visuals_InGame", function(v405)
        -- upvalues: v57 (ref), v60 (ref)
        local _ = nil;
        local v407, v408 = v405:switch("custom_scope")("Custom Scope");
        local v409 = v408:switch("custom_scope_invert")("Color");
        v409.tooltip = "If switch is enabled, colors would be inverted.";
        v409:color_picker("custom_scope_clr")(v57.colors.default);
        v408:slider("custom_scope_size")("Size", 1, 500, 100);
        v408:slider("custom_scope_gap")("Gap", 1, 500, 10);
        do
            local l_v407_0, l_v408_0 = v407, v408;
            v409 = function()
                -- upvalues: l_v408_0 (ref), l_v407_0 (ref), v60 (ref)
                l_v408_0.visibility = l_v407_0:get();
                if l_v407_0:get() then
                    v60.VISUALS.scope_overlay:override("Remove All");
                else
                    v60.VISUALS.scope_overlay:override();
                end;
            end;
            l_v407_0:set_callback(v409, true);
            v60.VISUALS.scope_overlay:set_callback(v409, true);
        end;
        v407 = nil;
        v408, v409 = v405:switch("hit_marker")("Hit Marker");
        local v412 = nil;
        local v413 = v409:switch("kibit_marker")("Kibit Marker");
        local v414 = v413:color_picker("kibit_marker_clr")();
        do
            local l_v414_0 = v414;
            v413:set_callback(function(v416)
                -- upvalues: l_v414_0 (ref)
                l_v414_0.visibility = v416:get();
            end, true);
        end;
        v413 = nil;
        v414 = v409:switch("damage_marker")("Damage Marker");
        local v417 = v414:color_picker("damage_marker_clr")(v57.colors.default);
        do
            local l_v417_0 = v417;
            v414:set_callback(function(v419)
                -- upvalues: l_v417_0 (ref)
                l_v417_0.visibility = v419:get();
            end, true);
        end;
        do
            local l_v409_0 = v409;
            v408:set_callback(function(v421)
                -- upvalues: v60 (ref), l_v409_0 (ref)
                if v421:get() then
                    v60.VISUALS.hitmarker:override(false);
                else
                    v60.VISUALS.hitmarker:override();
                end;
                l_v409_0.visibility = v421:get();
            end, true);
        end;
        v408 = nil;
        v409, v412 = v405:switch("grenade_radius")("Grenade Radius");
        v412:selectable("grenade_radius_timer")("Timer", {
            [1] = "Bar", 
            [2] = "Text"
        });
        v413 = v412:switch("smoke_radius")("Smoke Radius");
        v414 = v413:color_picker("smoke_radius_clr")();
        do
            local l_v414_1 = v414;
            v413:set_callback(function(v423)
                -- upvalues: l_v414_1 (ref)
                l_v414_1.visibility = v423:get();
            end, true);
        end;
        v414 = v412:switch("molotov_radius")("Molotov Radius");
        v417 = v414:color_picker("molotov_radius_clr")();
        do
            local l_v417_1 = v417;
            v414:set_callback(function(v425)
                -- upvalues: l_v417_1 (ref)
                l_v417_1.visibility = v425:get();
            end, true);
        end;
        v412:switch("molotov_safety")("Molotov Safety");
        v409:set_callback(function(v426)
            -- upvalues: v412 (ref)
            v412.visibility = v426:get();
        end, true);
    end);
    local _ = nil;
    l_v147_1.misc_movement = v146:new_group(1, "group_global", "Misc_Movement", function(v428)
        v428:switch("fast_ladder")("Fast Ladder").tooltip = "Increases your climb speed on ladders.";
        v428:switch("no_fall_damage")("No Fall Damage").tooltip = "Attempts to prevent damage from falling.";
    end);
    l_v147_1.misc_other = v146:new_group(2, "group_global", "Misc_Other", function(v429)
        v429:switch("unmute_players")("Unmute Players").tooltip = "Automatically unmutes muted players.";
        v429:switch("taskbar_notify")("Taskbar Notify").tooltip = "Flashes icon in taskbar, when round starts.";
        local _ = nil;
        local v431 = v429:switch("custom_console")("Custom Console");
        local v432 = v431:color_picker("custom_console_clr")();
        do
            local l_v432_0 = v432;
            v431:set_callback(function(v434)
                -- upvalues: l_v432_0 (ref)
                l_v432_0.visibility = v434:get();
            end, true);
        end;
        v431 = nil;
        local v435;
        v432, v435 = v429:switch("trashtalk")("Trashtalk");
        v435:switch("trashtalk_revenge")("Revenge");
        do
            local l_v435_0 = v435;
            v432:set_callback(function(v437)
                -- upvalues: l_v435_0 (ref)
                l_v435_0.visibility = v437:get();
            end, true);
        end;
        v429:switch("drop_nades")("Drop Nades").tooltip = string.format("Very useful function for fast drop nades (for 2v2/3v3/5v5 games) \n\affff00ff%s You should bind this function", ui.get_icon("circle-exclamation"));
    end);
    l_v147_1.misc_ingame = v146:new_group(2, "group_global", "Misc_InGame", function(v438)
        -- upvalues: v60 (ref)
        local _ = nil;
        local v440, v441 = v438:switch("clantag")("Clantag");
        local v442 = v441:combo("clantag_type")("Type", {
            [1] = "Script", 
            [2] = "Custom"
        });
        local v443 = v441:input("clantag_input")("Tag", "xo-yaw.lua");
        do
            local l_v442_0, l_v443_0 = v442, v443;
            local function v446()
                -- upvalues: v440 (ref), v60 (ref), l_v442_0 (ref), l_v443_0 (ref)
                if v440:get() then
                    v60.MISC.clantag:override(false);
                    if l_v442_0:get() == "Custom" and l_v443_0:get() == "" then
                        common.set_clan_tag("");
                        v60.MISC.clantag:override();
                        return;
                    else
                        return;
                    end;
                else
                    utils.execute_after(0.1, function()
                        common.set_clan_tag("");
                    end);
                    v60.MISC.clantag:override();
                    return;
                end;
            end;
            v440.tooltip = "Animated & Synchronized clantag spammer.";
            l_v442_0:set_callback(function(v447)
                -- upvalues: l_v443_0 (ref), v446 (ref)
                l_v443_0.visibility = v447:get() == "Custom";
                v446();
            end, true);
            v440:set_callback(function(v448)
                -- upvalues: v441 (ref), v446 (ref)
                v441.visibility = v448:get();
                v446();
            end, true);
            l_v443_0:set_callback(v446, true);
            v60.MISC.clantag:set_callback(v446, true);
        end;
    end);
    local _ = nil;
    local v450 = nil;
    local v451 = nil;
    local v452 = 11111;
    do
        local l_v450_0, l_v451_0, l_v452_0 = v450, v451, v452;
        v72["Menu Colors"].render:set(function()
            -- upvalues: v57 (ref), v75 (ref), l_v450_0 (ref), l_v451_0 (ref), l_v452_0 (ref)
            v57.menu_alpha = ui.get_alpha();
            if v57.menu_alpha ~= 1 then
                return;
            else
                local v456 = ui.get_style();
                local v457 = v456["Link Active"];
                local _ = v456["Active Text"];
                local v459 = "";
                local v460 = nil;
                local v461 = "xo-yaw.lua";
                local v462 = #v461 + 1;
                for v463 = 1, v462 do
                    local v464 = v461:sub(v463, v463);
                    local v465 = (v463 - 1) / v462;
                    local v466 = v75(v465 * 1.5, -2);
                    local v467 = v457:lerp(v456["Text Preview"], v466);
                    if v463 == 1 then
                        v460 = v467;
                    end;
                    v459 = v459 .. string.format("\a%s%s", v467:to_hex(), v464);
                end;
                ui.sidebar(v459, string.format("\a%s%s", v460.to_hex(v460), ui.get_icon("servicestack")));
                local v468 = v456["Link Active"]:to_hex();
                local v469 = v456["Active Text"]:to_hex();
                if v468 ~= l_v450_0 or v469 ~= l_v451_0 or v57.online ~= l_v452_0 then
                    v57.colors.link_active = v456["Link Active"];
                    l_v450_0 = v468;
                    l_v451_0 = v469;
                    l_v452_0 = v57.online;
                end;
                return;
            end;
        end);
    end;
    l_v151_1.tab_list:set_callback(function(v470)
        -- upvalues: l_v147_1 (ref)
        l_v147_1.rage_main.visibility = v470:get() == 1;
        l_v147_1.antiaim_other.visibility = v470:get() == 2;
        l_v147_1.antiaim_angles.visibility = v470:get() == 2;
        l_v147_1.defensive_setup.visibility = v470:get() == 2;
        l_v147_1.visuals_indication.visibility = v470:get() == 3;
        l_v147_1.visuals_view.visibility = v470:get() == 3;
        l_v147_1.visuals_ingame.visibility = v470:get() == 3;
        l_v147_1.misc_movement.visibility = v470:get() == 4;
        l_v147_1.misc_ingame.visibility = v470:get() == 4;
        l_v147_1.misc_other.visibility = v470:get() == 4;
    end, true);
end;
v147 = v146:get_raw();
v148 = nil;
v148 = {
    print = function(v471, v472)
        -- upvalues: v147 (ref)
        local v473 = v472:gsub("(\a%x+)xo%-yaw \a808080FF\194\183 \aDEFAULT", "\aDEFAULT");
        local v474 = table.convert(v147.event_logger_draw);
        if v147.event_logger and v474.Console or v471 then
            print_raw(v472);
        end;
        if v147.event_logger and v474.Events or v471 then
            print_dev(v473);
        end;
    end, 
    format = function(v475, v476)
        -- upvalues: v57 (ref)
        if type(v475) ~= "string" then
            return v475;
        else
            if not v476 then
                v476 = v57.colors.link_active:to_hex();
            else
                v476 = v476:to_hex();
            end;
            return (string.gsub(v475, "[\v\r]", {
                ["\r"] = "\aDEFAULT", 
                ["\v"] = "\a" .. v476
            }));
        end;
    end, 
    extrapolate = function(v477, v478, v479)
        local l_tickinterval_0 = globals.tickinterval;
        local l_m_vecVelocity_0 = v477.m_vecVelocity;
        local v482 = v479:clone();
        v482.x = v482.x + l_m_vecVelocity_0.x * l_tickinterval_0 * v478;
        v482.y = v482.y + l_m_vecVelocity_0.y * l_tickinterval_0 * v478;
        if not v477.m_hGroundEntity then
            v482.z = v482.z + l_m_vecVelocity_0.z * l_tickinterval_0 * v478 - cvar.sv_gravity:float() * l_tickinterval_0;
        end;
        return utils.trace_hull(v479, v482, v477.m_vecMins, v477.m_vecMaxs, v477).end_pos:clone();
    end, 
    get_list_text = function(v483)
        return v483:list()[v483:get()];
    end, 
    get_list_index = function(v484, v485)
        local v486 = v484:list();
        local v487 = nil;
        for v488, v489 in pairs(v486) do
            if v485 == v489 or v485 == v489:sub(5, -1) then
                v487 = v488;
                break;
            end;
        end;
        return v487;
    end
};
v149 = nil;
events.grenade_thrown:set(function(v490)
    -- upvalues: v147 (ref)
    if not v147.fast_switch then
        return;
    elseif entity.get_local_player() ~= entity.get(v490.userid, true) then
        return;
    else
        utils.console_exec("slot3; slot2; slot1");
        return;
    end;
end);
events.weapon_fire:set(function(v491)
    -- upvalues: v147 (ref)
    if not v147.fast_switch then
        return;
    elseif v491.weapon ~= "weapon_taser" then
        return;
    elseif entity.get_local_player() ~= entity.get(v491.userid, true) then
        return;
    else
        utils.console_exec("slot3; slot2; slot1");
        return;
    end;
end);
v150 = nil;
v150 = {
    data = {}
};
v151 = function(v492, v493, v494, v495)
    return -v494 * math.cos(v492 / v495 * (math.pi / 2)) + v494 + v493;
end;
do
    local l_v151_2 = v151;
    v150.add = function(v497, v498, v499)
        -- upvalues: v150 (ref), v73 (ref), l_v151_2 (ref)
        v150.data[#v150.data + 1] = {
            offset = 0, 
            text = v498, 
            time = globals.realtime + v497, 
            anim = v73:new(0.1, l_v151_2), 
            color = v499
        };
    end;
    v72["Hitlog Render"].render:set(function(_, _)
        -- upvalues: v147 (ref), v146 (ref), v57 (ref), v150 (ref)
        if not v147.event_logger or not v146:reference("event_logger_draw"):get("Custom Notify") then
            return;
        else
            local v502 = v57.screen:clone();
            v502.x = v502.x * 0.5;
            v502.y = v502.y - 340;
            local v503 = 0;
            local v504 = 0;
            for v505 = #v150.data, 1, -1 do
                local v506 = v150.data[v505];
                if v506 ~= nil then
                    local v507 = v506.time - globals.realtime;
                    local v508 = v506.anim(0.15, v507 > 0);
                    if v508 < 0.1 then
                        table.remove(v150.data, v505);
                    else
                        if v506.offset ~= v503 then
                            v506.offset = math.clamp(v506.offset < v503 and v506.offset + 200 * globals.frametime or v503, 0, v503);
                        end;
                        local v509 = render.measure_text(1, nil, v506.text);
                        local v510 = v509.x * v508;
                        if v504 < v509.y then
                            v504 = v509.y;
                        end;
                        local v511 = v502:clone();
                        v511.x = v511.x - v510 * 0.5;
                        v511.y = v511.y + v506.offset;
                        local v512 = vector(v510, v509.y + 1);
                        if v508 ~= 0 then
                            render.push_clip_rect(v511, v511 + v512);
                            render.shadow(vector(v511.x, v511.y + 7), vector(v511.x + v509.x, v511.y + 7), v506.color:alpha_modulate(v508 * 0.8, true), 20);
                            render.text(1, v511, v57.colors.white:alpha_modulate(v508, true), nil, v506.text);
                            render.pop_clip_rect();
                            v503 = v503 + v504 + 2;
                        end;
                    end;
                end;
            end;
            for v513 = 1, #v150.data do
                if #v150.data - v513 > 7 then
                    v150.data[v513].time = 0;
                end;
            end;
            return;
        end;
    end);
end;
v151 = nil;
v152 = v73:new(v60.VISUALS.fov:get());
do
    local l_v152_1 = v152;
    v72["Animate Zoom"].override_view:set(function(v515, _, v517)
        -- upvalues: v147 (ref), l_v152_1 (ref)
        if not v147.animate_zoom or not v517 then
            return;
        else
            v515.fov = l_v152_1(0.12, v515.fov);
            return;
        end;
    end);
end;
v152 = nil;
v152 = {};
v153 = false;
local v518 = nil;
local v519 = nil;
local v520 = nil;
local l_cl_righthand_0 = cvar.cl_righthand;
local v522 = tonumber(l_cl_righthand_0:string()) or 1;
local v523 = false;
local function v524()
    cvar.viewmodel_fov:float(tonumber(cvar.viewmodel_fov:string()));
    cvar.viewmodel_offset_x:float(tonumber(cvar.viewmodel_offset_x:string()));
    cvar.viewmodel_offset_y:float(tonumber(cvar.viewmodel_offset_y:string()));
    cvar.viewmodel_offset_z:float(tonumber(cvar.viewmodel_offset_z:string()));
end;
do
    local l_v153_1, l_v518_0, l_v520_0, l_l_cl_righthand_0_0, l_v522_0, l_v523_0, l_v524_0 = v153, v518, v520, l_cl_righthand_0, v522, v523, v524;
    local function v532()
        -- upvalues: v147 (ref), l_v524_0 (ref)
        if v147.viewmodel then
            cvar.viewmodel_fov:float(v147.viewmodel_fov * 0.1, true);
            cvar.viewmodel_offset_x:float(v147.viewmodel_x * 0.1, true);
            cvar.viewmodel_offset_y:float(v147.viewmodel_y * 0.1, true);
            cvar.viewmodel_offset_z:float(v147.viewmodel_z * 0.1, true);
        else
            l_v524_0();
        end;
    end;
    local function v535()
        -- upvalues: v146 (ref), v532 (ref)
        for _, v534 in ipairs({
            [1] = "viewmodel", 
            [2] = "viewmodel_fov", 
            [3] = "viewmodel_x", 
            [4] = "viewmodel_y", 
            [5] = "viewmodel_z"
        }) do
            v146:reference(v534):set_callback(v532, true);
        end;
        v146:reference("viewmodel_reset"):set_callback(function()
            -- upvalues: v146 (ref)
            v146:reference("viewmodel_fov"):set(tonumber(cvar.viewmodel_fov:string()) * 10);
            v146:reference("viewmodel_x"):set(tonumber(cvar.viewmodel_offset_x:string()) * 10);
            v146:reference("viewmodel_y"):set(tonumber(cvar.viewmodel_offset_y:string()) * 10);
            v146:reference("viewmodel_z"):set(tonumber(cvar.viewmodel_offset_z:string()) * 10);
        end);
    end;
    local function v539(v536)
        -- upvalues: l_v153_1 (ref)
        if l_v153_1 == v536 then
            return;
        else
            l_v153_1 = v536;
            for _, v538 in ipairs(materials.get_materials("sleeve")) do
                if v538:is_valid() then
                    v538:var_flag(2, v536);
                end;
            end;
            return;
        end;
    end;
    local function v541(v540)
        -- upvalues: v147 (ref), l_v522_0 (ref)
        if v540 and v147.viewmodel_flip then
            cvar.cl_righthand:int(l_v522_0 == 0 and 1 or 0, true);
        else
            cvar.cl_righthand:int(l_v522_0, true);
        end;
    end;
    v72.Viewmodel.pre_render:set(function(v542, v543)
        -- upvalues: v147 (ref), l_v523_0 (ref), l_v522_0 (ref), v539 (ref), l_v518_0 (ref), v541 (ref), l_l_cl_righthand_0_0 (ref), l_v520_0 (ref)
        if not v147.viewmodel or not v543 then
            if not l_v523_0 then
                cvar.cl_righthand:int(l_v522_0, true);
                l_v523_0 = true;
            end;
            v539(false);
            return;
        else
            l_v523_0 = false;
            local v544 = v542:get_player_weapon();
            if not v544 then
                return;
            else
                local v545 = v544:get_classname() == "CKnife";
                if v544 ~= l_v518_0 then
                    v541(v545);
                    l_v518_0 = v544;
                elseif not v545 then
                    l_v522_0 = tonumber(l_l_cl_righthand_0_0:string()) or 1;
                end;
                l_v520_0 = v545;
                v539(v147.viewmodel_sleeve);
                return;
            end;
        end;
    end);
    v72.Viewmodel.shutdown:set(function()
        -- upvalues: l_v522_0 (ref), l_v524_0 (ref), v539 (ref)
        cvar.cl_righthand:int(l_v522_0, true);
        l_v524_0();
        v539(false);
    end);
    v535();
end;
v153 = nil;
v518 = false;
v519 = cvar.r_aspectratio:float() or 0;
do
    local l_v518_1, l_v519_0, l_v520_1 = v518, v519, v520;
    l_v520_1 = function()
        -- upvalues: l_v518_1 (ref), l_v519_0 (ref)
        if l_v518_1 then
            cvar.r_aspectratio:float(l_v519_0);
            l_v518_1 = false;
        end;
    end;
    l_cl_righthand_0 = function()
        -- upvalues: v147 (ref), l_v519_0 (ref), l_v518_1 (ref), l_v520_1 (ref)
        local v549 = v147.aspect_ratio and v147.aspect_ratio_value / 100 or l_v519_0;
        cvar.r_aspectratio:float(v549);
        if v549 == 0 then
            l_v518_1 = true;
            l_v520_1();
        else
            l_v518_1 = v549 ~= 0;
        end;
    end;
    v146:reference("aspect_ratio"):set_callback(l_cl_righthand_0, true);
    v146:reference("aspect_ratio_value"):set_callback(l_cl_righthand_0, true);
    v72["Aspect Ratio"].shutdown:set(l_v520_1);
end;
v518 = nil;
v519 = "\t";
v520 = "\t";
do
    local l_v519_1, l_v520_2, l_l_cl_righthand_0_1, l_v522_1, l_v523_1 = v519, v520, l_cl_righthand_0, v522, v523;
    l_l_cl_righthand_0_1 = function(v555)
        -- upvalues: l_v519_1 (ref), l_v520_2 (ref)
        local v556 = {};
        local v557 = #v555;
        if v557 < 2 then
            table.insert(v556, v555);
            return v556;
        else
            for _ = 1, 8 do
                table.insert(v556, string.format("%s%s%s", l_v519_1, v555, l_v520_2));
            end;
            for v559 = 1, v557 do
                local v560 = v555:sub(v559, v557);
                table.insert(v556, string.format("%s%s%s", l_v519_1, v560, l_v520_2));
            end;
            table.insert(v556, string.format("%s%s", l_v519_1, l_v520_2));
            for v561 = math.min(2, v557), v557 do
                local v562 = v555:sub(1, v561);
                table.insert(v556, string.format("%s%s%s", l_v519_1, v562, l_v520_2));
            end;
            for _ = 1, 4 do
                table.insert(v556, string.format("%s%s%s", l_v519_1, v555, l_v520_2));
            end;
            return v556;
        end;
    end;
    l_v522_1 = -1;
    l_v523_1 = nil;
    v524 = function()
        -- upvalues: v147 (ref), l_v523_1 (ref), l_l_cl_righthand_0_1 (ref)
        if v147.clantag_type == "Script" then
            l_v523_1 = l_l_cl_righthand_0_1("xo-yaw.lua");
        else
            l_v523_1 = l_l_cl_righthand_0_1(v147.clantag_input);
        end;
    end;
    v146:reference("clantag_type"):set_callback(v524, true);
    v146:reference("clantag_input"):set_callback(v524);
    v72.Clantag.net_update_end:set(function(v564, _)
        -- upvalues: v147 (ref), l_v523_1 (ref), l_v522_1 (ref)
        if not v147.clantag then
            return;
        elseif v564 == nil or v564.m_iTeamNum == 0 then
            return;
        else
            local v566 = utils.net_channel();
            if v566 == nil then
                return;
            else
                local v567 = v566.latency[0] / globals.tickinterval;
                local v568 = globals.tickcount + v567;
                local v569 = math.floor(v568 * 0.0625) % #l_v523_1 + 1;
                if v569 == l_v522_1 then
                    return;
                else
                    l_v522_1 = v569;
                    common.set_clan_tag(l_v523_1[v569] or "");
                    return;
                end;
            end;
        end;
    end);
    v72.Clantag.shutdown:set(function()
        common.set_clan_tag("");
    end);
end;
v519 = nil;
v72["No Fall Damage"].createmove:set(function(v570, v571, v572)
    -- upvalues: v147 (ref)
    if not v147.no_fall_damage or not v572 then
        return;
    else
        local v573 = v571:get_origin();
        if v573 == nil then
            return;
        else
            local v574 = utils.trace_line(v573, vector(v573.x, v573.y, v573.z - 500), nil, nil, 1);
            if not v574.end_pos then
                return;
            else
                if v573.z - v574.end_pos.z <= 70 and v573.z - v574.end_pos.z >= 12 and bit.band(v571.m_fFlags, 1) == 0 and v571.m_vecVelocity.z < -450 then
                    v570.in_duck = true;
                end;
                return;
            end;
        end;
    end;
end);
v520 = nil;
ffi.cdef("        typedef long* hwnd;\n        typedef const char* lpcstr;\n\n        hwnd FindWindowA(lpcstr lpClassName, lpcstr lpWindowName);\n        bool FlashWindow(hwnd hWnd, bool bInvert);\n    ");
l_cl_righthand_0 = ffi.C.FindWindowA("Valve001", nil);
if not l_cl_righthand_0 then
    error("Window not found!");
end;
do
    local l_l_cl_righthand_0_2 = l_cl_righthand_0;
    v522 = function()
        -- upvalues: v147 (ref), l_l_cl_righthand_0_2 (ref)
        if not v147.taskbar_notify then
            return;
        else
            local v576 = entity.get_game_rules();
            if not v576 then
                return;
            elseif v576.m_bIsValveDS then
                return;
            else
                ffi.C.FlashWindow(l_l_cl_righthand_0_2, false);
                return;
            end;
        end;
    end;
    v72["Taskbar Notification"].round_start:set(v522);
end;
l_cl_righthand_0 = nil;
v522 = utils.get_vfunc("client.dll", "GameClientExports001", 3, "void(__thiscall*)(void*, int)");
do
    local l_v522_2 = v522;
    v523 = function()
        -- upvalues: v147 (ref), l_v522_2 (ref)
        if not v147.unmute_players then
            return;
        else
            for _, v579 in pairs(entity.get_players()) do
                if v579 ~= nil then
                    l_v522_2(v579:get_index());
                end;
            end;
            return;
        end;
    end;
    v146:reference("unmute_players"):set_callback(v523, true);
    v72["Unmute Players"].player_connect_full:set(v523);
end;
v522 = nil;
v523 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
v524 = false;
local v580 = color();
local function v584(v581)
    -- upvalues: v57 (ref)
    if not v581 then
        v581 = v57.colors.white;
    end;
    materials.get_materials("vgui/hud/800", false, function(v582)
        -- upvalues: v581 (ref)
        v582:color_modulate(v581);
        v582:alpha_modulate(v581.a / 255);
    end);
    materials.get_materials("vgui_white", false, function(v583)
        -- upvalues: v581 (ref)
        v583:color_modulate(v581);
        v583:alpha_modulate(v581.a / 255);
    end);
end;
do
    local l_v523_2, l_v524_1, l_v580_0, l_v584_0 = v523, v524, v580, v584;
    v72["Console Color"].pre_render:set(function()
        -- upvalues: v147 (ref), l_v524_1 (ref), l_v584_0 (ref), l_v580_0 (ref), l_v523_2 (ref)
        if not v147.custom_console then
            if l_v524_1 then
                l_v524_1 = false;
                l_v584_0();
            end;
            return;
        else
            local l_custom_console_clr_0 = v147.custom_console_clr;
            if l_custom_console_clr_0 ~= l_v580_0 then
                l_v524_1 = not l_v523_2();
                l_v584_0(l_custom_console_clr_0);
                l_v580_0 = l_custom_console_clr_0;
            end;
            if l_v523_2() then
                if not l_v524_1 then
                    l_v524_1 = true;
                    l_v584_0(l_custom_console_clr_0);
                end;
            elseif l_v524_1 then
                l_v524_1 = false;
                l_v584_0();
            end;
            return;
        end;
    end);
    events.shutdown:set(l_v584_0);
end;
v523 = nil;
v524 = {};
v580 = {
    [1] = "weapon_molotov", 
    [2] = "weapon_incgrenade", 
    [3] = "weapon_hegrenade"
};
v584 = {};
for _, v591 in next, v580 do
    v584[v591] = true;
end;
do
    local l_v524_2, l_v584_1 = v524, v584;
    v146:reference("drop_nades"):set_callback(function(v594)
        -- upvalues: l_v524_2 (ref), l_v584_1 (ref)
        if not v594:get() then
            return;
        else
            local v595 = entity.get_local_player();
            if v595 == nil or not v595:is_alive() then
                return;
            elseif #l_v524_2 > 0 then
                return;
            else
                local v596 = 1;
                local v597 = v595:get_player_weapon(true);
                for v598 = 1, #v597 do
                    local v599 = v597[v598];
                    if v599 then
                        local v600 = v599:get_index();
                        local l_console_name_0 = v599:get_weapon_info().console_name;
                        do
                            local l_v600_0, l_l_console_name_0_0 = v600, l_console_name_0;
                            if l_v584_1[l_l_console_name_0_0] then
                                l_v524_2[#l_v524_2 + 1] = function(v604)
                                    -- upvalues: l_v600_0 (ref)
                                    v604.no_choke = true;
                                    v604.send_packet = false;
                                    v604.in_use = 1;
                                    v604.weaponselect = l_v600_0;
                                    v604.view_angles = render.camera_angles();
                                end;
                                l_v524_2[#l_v524_2 + 1] = function(v605)
                                    -- upvalues: l_l_console_name_0_0 (ref)
                                    local v606 = entity.get_local_player();
                                    if v606 == nil or not v606:is_alive() then
                                        return;
                                    else
                                        local v607 = v606:get_player_weapon();
                                        if not v607 then
                                            return;
                                        else
                                            local v608 = v607:get_weapon_info();
                                            if l_l_console_name_0_0 ~= v608.console_name then
                                                return;
                                            else
                                                v605.no_choke = true;
                                                v605.send_packet = false;
                                                v605.in_use = 1;
                                                v605.view_angles = render.camera_angles();
                                                utils.console_exec("drop");
                                                return;
                                            end;
                                        end;
                                    end;
                                end;
                                for _ = 1, 2 do
                                    l_v524_2[#l_v524_2 + 1] = function(v610)
                                        v610.no_choke = true;
                                        v610.send_packet = false;
                                        v610.in_use = 1;
                                        v610.view_angles = render.camera_angles();
                                    end;
                                end;
                                v596 = v596 + 1;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end, false);
    v72["Drop Nades"].createmove:set(function(v611, _, v613)
        -- upvalues: l_v524_2 (ref)
        if not v613 then
            return;
        else
            if v611.choked_commands == 0 and #l_v524_2 > 0 then
                l_v524_2[1](v611);
                table.remove(l_v524_2, 1);
            end;
            return;
        end;
    end);
end;
v524 = nil;
v72["Fast Ladder"].createmove:set(function(v614, v615, v616)
    -- upvalues: v147 (ref)
    if not v147.fast_ladder or not v616 then
        return;
    elseif v615.m_MoveType ~= 9 then
        return;
    else
        local v617 = v615:get_player_weapon();
        if v617 == nil then
            return;
        else
            local l_m_fThrowTime_0 = v617.m_fThrowTime;
            if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 ~= 0 then
                return;
            else
                if v614.forwardmove > 0 then
                    if v614.view_angles.x < 45 then
                        v614.view_angles.x = 89;
                        v614.in_moveright = 1;
                        v614.in_moveleft = 0;
                        v614.in_forward = 0;
                        v614.in_back = 1;
                        if v614.sidemove == 0 then
                            v614.view_angles.y = v614.view_angles.y + 90;
                        end;
                        if v614.sidemove < 0 then
                            v614.view_angles.y = v614.view_angles.y + 150;
                        end;
                        if v614.sidemove > 0 then
                            v614.view_angles.y = v614.view_angles.y + 30;
                        end;
                    end;
                elseif v614.forwardmove < 0 then
                    v614.view_angles.x = 89;
                    v614.in_moveleft = 1;
                    v614.in_moveright = 0;
                    v614.in_forward = 1;
                    v614.in_back = 0;
                    if v614.sidemove == 0 then
                        v614.view_angles.y = v614.view_angles.y + 90;
                    end;
                    if v614.sidemove > 0 then
                        v614.view_angles.y = v614.view_angles.y + 150;
                    end;
                    if v614.sidemove < 0 then
                        v614.view_angles.y = v614.view_angles.y + 30;
                    end;
                end;
                return;
            end;
        end;
    end;
end);
v580 = nil;
v584 = {};
local v619 = 5;
do
    local l_v584_2, l_v619_0 = v584, v619;
    v72["Kibit Marker"].aim_ack:set(function(v622, _, v624)
        -- upvalues: v147 (ref), l_v584_2 (ref), v73 (ref), l_v619_0 (ref)
        if not v147.hit_marker or not v147.kibit_marker or not v624 then
            return;
        else
            l_v584_2[#l_v584_2 + 1] = {
                [1] = v73:new(0.1), 
                [2] = globals.realtime + 3, 
                [3] = v622.aim or vector(), 
                [4] = v147.kibit_marker_clr or color(), 
                [5] = l_v619_0 * render.get_scale(2)
            };
            return;
        end;
    end);
    v72["Kibit Marker"].render:set(function(_, v626)
        -- upvalues: v147 (ref), l_v584_2 (ref)
        if not v147.hit_marker or not v147.kibit_marker or not v626 then
            return;
        else
            for v627, v628 in pairs(l_v584_2) do
                if v628 then
                    local v629 = v628[2] - globals.realtime;
                    local v630 = v628[1](0.2, v629 > 0);
                    if v630 < 0.01 then
                        table.remove(l_v584_2, v627);
                    else
                        local v631 = render.world_to_screen(v628[3]);
                        if v631 ~= nil then
                            local v632 = v628[4]:alpha_modulate(v630, true);
                            local v633 = v628[5];
                            render.rect(v631 - vector(1, v633), v631 + vector(1, v633), v632);
                            render.rect(v631 - vector(v633, 1), v631 + vector(v633, 1), v632);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end);
end;
v584 = nil;
v619 = {};
local v634 = {
    [1] = 0, 
    [2] = 5, 
    [3] = 2, 
    [4] = 13, 
    [5] = 14, 
    [6] = 7, 
    [7] = 8
};
local v635 = v56("Calibri", 12, "adb");
do
    local l_v619_1, l_v634_0, l_v635_0 = v619, v634, v635;
    v72["Damage Marker"].player_hurt:set(function(v639, v640, v641)
        -- upvalues: v147 (ref), l_v634_0 (ref), l_v619_1 (ref), v73 (ref)
        if not v147.hit_marker or not v147.damage_marker or not v641 then
            return;
        else
            local v642 = entity.get(v639.userid, true);
            local v643 = entity.get(v639.attacker, true);
            if v642 == nil or v642 == v640 or v643 == nil or v643 ~= v640 then
                return;
            else
                local v644 = l_v634_0[v639.hitgroup] or 3;
                l_v619_1[#l_v619_1 + 1] = {
                    {
                        v73:new(0.01), 
                        v73:new(0)
                    }, 
                    globals.realtime + 2, 
                    v147.damage_marker_clr or color(), 
                    v639.dmg_health or 0, 
                    v642:get_hitbox_position(v644)
                };
                return;
            end;
        end;
    end);
    v72["Damage Markers"].render:set(function(_, v646)
        -- upvalues: v147 (ref), l_v619_1 (ref), l_v635_0 (ref)
        if not v147.hit_marker or not v147.damage_marker or not v646 then
            return;
        else
            for v647, v648 in pairs(l_v619_1) do
                if v648 ~= nil then
                    local v649 = v648[2] - globals.realtime;
                    local v650 = v648[1][1](0.2, v649 > 0);
                    if v650 < 0.01 then
                        table.remove(l_v619_1, v647);
                    else
                        local v651 = render.world_to_screen(vector(v648[5].x, v648[5].y, v648[5].z + 60 - v649 * 40));
                        if v651 ~= nil then
                            local v652 = v648[1][2](1.5, v648[4]);
                            render.text(l_v635_0, v651, v648[3]:alpha_modulate(v650, true), "s", math.floor(v652));
                        end;
                    end;
                end;
            end;
            return;
        end;
    end);
end;
v619 = nil;
v634 = {
    global = v73:new(), 
    size = v73:new(), 
    inverted = v73:new()
};
v635 = v57.screen_center;
do
    local l_v634_1, l_v635_1 = v634, v635;
    v72["Custom Scope"].render:set(function(v655, v656)
        -- upvalues: l_v634_1 (ref), v147 (ref), l_v635_1 (ref)
        local v657 = l_v634_1.global(0.2, v147.custom_scope and v656);
        if v657 <= 0 then
            return;
        else
            local v658 = v147.custom_scope_clr:alpha_modulate(255 * v657);
            local v659 = l_v634_1.size(0.065, v655 and v655.m_bIsScoped or false);
            local v660 = v147.custom_scope_size * v659 * v657;
            local l_custom_scope_gap_0 = v147.custom_scope_gap;
            if v660 < 0.01 then
                return;
            else
                local v662 = l_v634_1.inverted(0.1, v147.custom_scope_invert);
                local v663 = v658:lerp(v658:alpha_modulate(0), v662);
                local v664 = v658:alpha_modulate(0):lerp(v658, v662);
                render.gradient(vector(l_v635_1.x, l_v635_1.y - l_custom_scope_gap_0), vector(l_v635_1.x + 1, l_v635_1.y - l_custom_scope_gap_0 - v660), v663, v663, v664, v664);
                render.gradient(vector(l_v635_1.x, l_v635_1.y + l_custom_scope_gap_0 + 1), vector(l_v635_1.x + 1, l_v635_1.y + l_custom_scope_gap_0 + v660 + 1), v663, v663, v664, v664);
                render.gradient(vector(l_v635_1.x - l_custom_scope_gap_0, l_v635_1.y), vector(l_v635_1.x - l_custom_scope_gap_0 - v660, l_v635_1.y + 1), v663, v664, v663, v664);
                render.gradient(vector(l_v635_1.x + l_custom_scope_gap_0 + 1, l_v635_1.y), vector(l_v635_1.x + l_custom_scope_gap_0 + v660 + 1, l_v635_1.y + 1), v663, v664, v663, v664);
                return;
            end;
        end;
    end);
end;
v634 = nil;
v635 = v146:reference("rage_tweaks").reference;
local v665 = false;
local v666 = 1;
do
    local l_v665_0, l_v666_0 = v665, v666;
    local function v669()
        -- upvalues: l_v665_0 (ref), v60 (ref)
        if l_v665_0 then
            v60.AA.fake_lag.limit:override();
            l_v665_0 = false;
        end;
    end;
    v72["Ragebot Tweaks"].createmove:set(function(v670, v671, v672)
        -- upvalues: v57 (ref), v147 (ref), v669 (ref), l_v666_0 (ref), v58 (ref), l_v665_0 (ref)
        v57.functions.nade_fix = false;
        if #v147.rage_tweaks == 0 or not v672 then
            return v669();
        else
            local v673 = table.convert(v147.rage_tweaks);
            if v673["Fix Throw Nades"] then
                local v674 = v671:get_player_weapon();
                if v674 ~= nil then
                    local v675 = v674:get_weapon_info();
                    if ({
                        weapon_flashbang = 1, 
                        weapon_smokegrenade = 1, 
                        weapon_hegrenade = 1, 
                        weapon_incgrenade = 1, 
                        weapon_molotov = 1
                    })[v675.console_name] then
                        if v674.m_bPinPulled then
                            l_v666_0 = globals.curtime;
                        end;
                        if v674.m_fThrowTime > 0 then
                            l_v666_0 = globals.curtime;
                        end;
                    end;
                    if globals.curtime - l_v666_0 < 0.33 then
                        v57.functions.nade_fix = true;
                        rage.exploit:allow_defensive(false);
                    end;
                end;
            end;
            if v673["Ignore Shift While Air Strafe"] and not v58.onground and v58.velocity > 30 then
                v670.in_speed = false;
            end;
            l_v665_0 = true;
            return;
        end;
    end);
end;
v635 = nil;
v635 = {
    condition = function(v676, v677)
        -- upvalues: v58 (ref), v60 (ref), v57 (ref)
        if entity.get_local_player() == nil then
            return;
        else
            local v678 = v58.crouch or v60.AA.other.fake_duck:get();
            local l_velocity_0 = v58.velocity;
            if v676 and rage.exploit:get() == 0 and not v60.RAGE.aimbot.double_tap.main:get() and not v60.RAGE.aimbot.hide_shots.main:get() and not v57.functions.legit then
                return v57.states[9];
            elseif not v677 and v57.functions.legit then
                return v57.states[10];
            elseif not v58.onground then
                return v57.states[(not not v678 or v60.MISC.air_duck:get()) and 8 or 7];
            elseif v678 then
                return v57.states[l_velocity_0 > 10 and 6 or 5];
            elseif l_velocity_0 > 10 then
                return v57.states[v60.AA.other.slow_walk:get() and 4 or 3];
            else
                return v57.states[2];
            end;
        end;
    end
};
v665 = nil;
v666 = {
    Right = 90, 
    Left = -90, 
    Backward = 0, 
    Forward = 180
};
local v680 = l_handler_0.new("Manual AA", 6);
do
    local l_v666_1, l_v680_0 = v666, v680;
    v72["Manual Yaw"].createmove:set(function(_, _, v685)
        -- upvalues: v147 (ref), l_v680_0 (ref), l_v666_1 (ref), v60 (ref)
        if v147.manual_yaw == "Disabled" or not v685 then
            return;
        else
            l_v680_0:tick();
            l_v680_0.yaw.main = "Backward";
            l_v680_0.yaw.offset = l_v666_1[v147.manual_yaw];
            l_v680_0.yaw.base = "Local View";
            if v147.manual_yaw_disabler then
                l_v680_0.yaw_modifier.main = "Disabled";
                l_v680_0.body_yaw.options = {};
            end;
            if v147.manual_yaw_body_freestanding then
                local v686 = v60.AA.angles.body_yaw.inverter:get();
                l_v680_0.body_yaw.main = true;
                l_v680_0.body_yaw.inverter = v686;
                l_v680_0.body_yaw.left_limit = 60;
                l_v680_0.body_yaw.right_limit = 60;
                l_v680_0.body_yaw.freestanding = "Peek Fake";
            end;
            l_v680_0.freestanding = false;
            l_v680_0:run();
            return;
        end;
    end);
end;
v666 = nil;
v680 = function(v687, v688)
    local v689 = {};
    local v690 = nil;
    local v691 = v687:get_eye_position() + vector(0, 0, 10);
    for v692 = 18, 360, 18 do
        v692 = math.normalize_yaw(v692);
        local v693 = v691 + vector():angles(0, v692) * 96;
        local v694 = utils.trace_line(v691, v693, v687, 33570827);
        local l_entity_0 = v694.entity;
        if l_entity_0 and l_entity_0:get_classname() == "CWorld" and v694.fraction < 0.35 then
            v689[#v689 + 1] = {
                vecTraceEnd = v694.end_pos, 
                flYaw = v692
            };
        end;
    end;
    table.sort(v689, function(v696, v697)
        return v696.flYaw < v697.flYaw;
    end);
    if #v689 >= 2 then
        v690 = (v691 - v689[1].vecTraceEnd:lerp(v689[#v689].vecTraceEnd, 0.5)):angles();
    end;
    if v690 then
        local l_y_0 = v688.view_angles.y;
        local l_y_1 = v690.y;
        local v700 = math.normalize_yaw(l_y_1 - l_y_0);
        if math.abs(v700) < 90 then
            v700 = 0;
            l_y_0 = math.normalize_yaw(l_y_1 + 180);
        end;
        return math.normalize_yaw(-l_y_0 + l_y_1 + v700 + 180);
    else
        return;
    end;
end;
local v701 = l_handler_0.new("Edge Yaw", 5);
do
    local l_v680_1, l_v701_0 = v680, v701;
    v72["Edge Yaw"].createmove:set(function(v704, v705, v706)
        -- upvalues: v57 (ref), v147 (ref), l_v701_0 (ref), l_v680_1 (ref)
        v57.functions.edge = false;
        if not v147.edge_yaw or not v706 then
            return;
        else
            l_v701_0:tick();
            local v707 = l_v680_1(v705, v704);
            if v707 and not v57.functions.legit then
                l_v701_0.yaw.main = "Backward";
                l_v701_0.yaw.base = "Local View";
                l_v701_0.yaw.offset = v707;
                v57.functions.edge = true;
            end;
            l_v701_0:run();
            return;
        end;
    end);
end;
v680 = nil;
v701 = l_handler_0.new("FS disablers", 34);
do
    local l_v701_1 = v701;
    v72["FS DIsablers"].createmove:set(function(_, _, v711)
        -- upvalues: v147 (ref), v635 (ref), v60 (ref), l_v701_1 (ref)
        if #v147.freestand_disablers == 0 or not v711 then
            return;
        else
            local v712 = false;
            local v713 = v635.condition(false);
            for _, v715 in pairs(v147.freestand_disablers) do
                if v715 == v713 then
                    v712 = true;
                    break;
                end;
            end;
            if not v712 or not v60.AA.angles.freestanding:get() then
                return;
            else
                l_v701_1:tick();
                l_v701_1.freestanding = false;
                l_v701_1:run();
                return;
            end;
        end;
    end);
end;
v701 = nil;
local function v720(v716, v717)
    for _, v719 in pairs(v717) do
        if v716:dist((v719:get_origin())) < 128 then
            return true;
        end;
    end;
    return false;
end;
local v721 = {
    [1] = "CHostage", 
    [2] = "CPlantedC4"
};
local v722 = -1;
local v723 = l_handler_0.new("Legit AA", 8);
do
    local l_v720_0, l_v721_0, l_v722_0, l_v723_0 = v720, v721, v722, v723;
    v72["Legit AA"].createmove:set(function(v728, v729, v730)
        -- upvalues: v57 (ref), v147 (ref), l_v722_0 (ref), l_v721_0 (ref), l_v720_0 (ref), l_v723_0 (ref)
        v57.functions.legit = false;
        if not v147.legit_aa or not v730 then
            return;
        elseif not v728.in_use then
            l_v722_0 = -1;
            return;
        else
            local v731 = v729:get_player_weapon();
            if v731 == nil then
                return;
            elseif v731:get_classname() == "CC4" then
                return;
            else
                local v732 = v729:get_origin();
                for v733 = 1, #l_v721_0 do
                    if l_v720_0(v732, entity.get_entities(l_v721_0[v733], false)) then
                        return;
                    end;
                end;
                if l_v722_0 == -1 then
                    l_v722_0 = globals.tickcount + 1;
                end;
                v728.in_use = l_v722_0 > globals.tickcount;
                l_v723_0:tick();
                l_v723_0.pitch = "Disabled";
                l_v723_0.yaw.main = "Backward";
                l_v723_0.yaw.base = "Local View";
                l_v723_0.yaw.offset = 180;
                l_v723_0.body_yaw.main = true;
                l_v723_0.freestanding = false;
                v57.functions.legit = true;
                l_v723_0:run();
                return;
            end;
        end;
    end);
end;
v720 = nil;
v721 = l_handler_0.new("Vanish Anti Aim", 9);
v722 = function(v734)
    return v734[0];
end;
do
    local l_v721_1, l_v722_1, l_v723_1 = v721, v722, v723;
    l_v723_1 = function(v738)
        -- upvalues: l_v722_1 (ref)
        if not pcall(l_v722_1, v738) then
            return false;
        else
            return true;
        end;
    end;
    v72.Vanish.createmove:set(function(_, v740, v741)
        -- upvalues: v57 (ref), v147 (ref), v78 (ref), l_v723_1 (ref), l_v721_1 (ref)
        v57.functions.vanish = false;
        if not v147.vanish_mode or v147.antiaim_type == "Disabled" or v147.manual_yaw ~= "Disabled" or v57.functions.legit or v57.functions.edge or not v741 then
            return;
        else
            local v742 = nil;
            local v743 = nil;
            local v744 = entity.get_threat(true);
            if v744 ~= nil then
                v742 = true;
                v743 = v744;
            else
                v742 = false;
                v743 = v78(v740);
            end;
            if utils.net_channel() == nil or v743 == nil then
                return;
            elseif not l_v723_1(v743) then
                return;
            else
                l_v721_1:tick();
                if v743.is_alive(v743) then
                    local v745 = v743.get_player_weapon(v743);
                    if v745 then
                        local v746 = v745:get_classid();
                        if ({
                            [113] = true, 
                            [96] = true, 
                            [77] = true, 
                            [47] = true, 
                            [156] = true, 
                            [99] = true, 
                            [107] = true, 
                            [268] = true
                        })[v746] or v743.is_dormant(v743) and not v742 then
                            v57.functions.vanish = true;
                        end;
                        if v57.functions.vanish then
                            l_v721_1.yaw.main = "Backward";
                            l_v721_1.yaw.base = "At Target";
                            l_v721_1.yaw.offset = 0;
                            l_v721_1.yaw_modifier.main = "Disabled";
                            l_v721_1.body_yaw.main = true;
                            l_v721_1.body_yaw.options = {
                                [1] = ""
                            };
                            l_v721_1.body_yaw.freestanding = "";
                            l_v721_1.body_yaw.left_limit = 58;
                            l_v721_1.body_yaw.right_limit = 58;
                        end;
                    end;
                end;
                l_v721_1:run();
                return;
            end;
        end;
    end);
end;
v721 = nil;
v721 = {
    on_condition = false, 
    is_air_weapon = false, 
    weapon = false, 
    presets = {
        Stand = {
            [3] = {
                left_limit = 20, 
                offset = 5, 
                inverter = false, 
                right_limit = 20
            }, 
            [2] = {
                left_limit = 20, 
                offset = 0, 
                inverter = false, 
                right_limit = 25
            }
        }, 
        ["Slow Walk"] = {
            [3] = {
                left_limit = 20, 
                offset = 5, 
                inverter = false, 
                right_limit = 20
            }, 
            [2] = {
                left_limit = 20, 
                offset = 0, 
                inverter = false, 
                right_limit = 25
            }
        }, 
        Crouch = {
            [3] = {
                left_limit = 35, 
                offset = -5, 
                inverter = true, 
                right_limit = 60
            }, 
            [2] = {
                left_limit = 20, 
                offset = 17, 
                inverter = false, 
                right_limit = 26
            }
        }, 
        ["Crouch Move"] = {
            [3] = {
                left_limit = 35, 
                offset = -5, 
                inverter = true, 
                right_limit = 60
            }, 
            [2] = {
                left_limit = 20, 
                offset = 17, 
                inverter = false, 
                right_limit = 26
            }
        }, 
        ["Air+"] = {
            [3] = {
                left_limit = 25, 
                offset = 0, 
                inverter = false, 
                right_limit = 25
            }, 
            [2] = {
                left_limit = 25, 
                offset = 0, 
                inverter = false, 
                right_limit = 25
            }
        }, 
        [107] = {
            [3] = {
                left_limit = 58, 
                offset = 0, 
                inverter = true, 
                right_limit = 58
            }, 
            [2] = {
                left_limit = 58, 
                offset = 0, 
                inverter = true, 
                right_limit = 58
            }
        }, 
        [268] = {
            [3] = {
                left_limit = 58, 
                offset = 13, 
                inverter = false, 
                right_limit = 58
            }, 
            [2] = {
                left_limit = 58, 
                offset = 23, 
                inverter = false, 
                right_limit = 58
            }
        }
    }
};
v722 = v146:reference("safe_head").reference;
v723 = l_handler_0.new("Safe Head", 15);
do
    local l_v722_2, l_v723_2 = v722, v723;
    v72["Safe Head"].createmove:set(function(_, v750, _)
        -- upvalues: v57 (ref), v721 (ref), v147 (ref), v635 (ref), l_v722_2 (ref), v78 (ref), l_v723_2 (ref), v58 (ref)
        v57.functions.safe_head = false;
        v721.weapon = false;
        if #v147.safe_head == 0 or v57.functions.legit or v57.functions.edge or v147.manual_yaw ~= "Disabled" or v57.functions.randomization then
            return;
        else
            v721.on_condition = false;
            v721.is_air_weapon = false;
            v721.class_id = 0;
            local v752 = v635.condition(false, true);
            if v752 == "Air" or v752 == "Air+" and not v721.on_condition then
                local v753 = v750:get_player_weapon();
                if v753 then
                    local v754 = v753:get_classid();
                    v721.class_id = v754;
                    if v754 == 107 then
                        v721.on_condition = l_v722_2:get(6);
                    elseif v754 == 268 then
                        v721.on_condition = l_v722_2:get(7);
                    end;
                    v721.is_air_weapon = true;
                end;
            end;
            if not v721.on_condition then
                for _, v756 in pairs(v147.safe_head) do
                    if v752 == v756 then
                        v721.on_condition = true;
                        break;
                    end;
                end;
            end;
            if not v721.on_condition then
                return;
            else
                v57.functions.safe_head = v721.is_air_weapon;
                if not v57.functions.safe_head then
                    local v757 = v750:get_origin();
                    local v758 = v78(v750);
                    local _ = 0;
                    if v758 and v758:is_alive() and not v758:is_dormant() then
                        local v760 = v758:get_origin();
                        if (v721.is_air_weapon and v757.z - 1 or v760.z + 5) < v757.z then
                            v57.functions.safe_head = true;
                        end;
                    end;
                end;
                v721.weapon = v721.is_air_weapon;
                l_v723_2:tick();
                if v57.functions.safe_head then
                    local v761 = v721.is_air_weapon and v721.presets[v721.class_id] or v721.presets[v58.condition];
                    if not v761 then
                        return;
                    else
                        local v762 = v761[v750.m_iTeamNum];
                        if not v762 then
                            return;
                        else
                            l_v723_2.yaw.main = "Backward";
                            l_v723_2.yaw.base = "At Target";
                            l_v723_2.yaw.offset = v762.offset;
                            l_v723_2.yaw_modifier.main = "Disabled";
                            l_v723_2.body_yaw.main = true;
                            l_v723_2.body_yaw.options = "";
                            v58.safe_head_yaw = v762.offset;
                            l_v723_2.body_yaw.left_limit = v762.left_limit;
                            l_v723_2.body_yaw.right_limit = v762.right_limit;
                            rage.antiaim:inverter(v762.inverter);
                        end;
                    end;
                end;
                l_v723_2:run();
                return;
            end;
        end;
    end);
end;
v722 = nil;
v722 = {
    tp = 1, 
    cvar = cvar.sv_maxusrcmdprocessticks
};
v723 = false;
v722.orig_value = tonumber(v722.cvar:string());
v722.last_tick = globals.tickcount;
do
    local l_v723_3 = v723;
    v722.backups = function()
        -- upvalues: l_v723_3 (ref), v60 (ref), v722 (ref)
        if l_v723_3 then
            v60.AA.fake_lag.limit:override();
            v60.AA.other.fake_duck:override();
            v60.AA.fake_lag.variability:override();
            v60.RAGE.aimbot.double_tap.options:override();
            v722.cvar:int(v722.orig_value);
            l_v723_3 = false;
        end;
    end;
    v72["Exploit TP"].createmove:set(function(_, _, v766)
        -- upvalues: v147 (ref), v722 (ref), l_v723_3 (ref), v57 (ref), v58 (ref), v60 (ref)
        if not v147.force_tp or not v766 then
            return v722.backups();
        else
            l_v723_3 = true;
            v57.functions.air_exploit = false;
            if not v58.onground then
                v60.AA.fake_lag.limit:override(17);
                v60.AA.fake_lag.variability:override(0);
                v60.RAGE.aimbot.double_tap.options:override("On Peek");
                if globals.tickcount % 2 == 1 then
                    v722.cvar:int(16);
                    v722.tp = v722.tp + 1;
                    v60.AA.other.fake_duck:override(true);
                end;
                if v722.tp > 2 then
                    v722.cvar:int(19);
                    v722.tp = 1;
                    v60.AA.other.fake_duck:override();
                end;
                v57.functions.air_exploit = true;
            else
                v722.backups();
            end;
            return;
        end;
    end);
end;
v723 = nil;
local v767 = l_handler_0.new("Conditional AA", 1);
local v768 = 1;
local v769 = nil;
local v770 = -1;
local v771 = 0;
local v772 = 0;
local v773 = false;
local v774 = 0;
local v775 = false;
do
    local l_v767_0, l_v768_0, l_v773_0, l_v774_0, l_v775_0 = v767, v768, v773, v774, v775;
    v72["Conditional AA"].createmove:set(function(v781, _, v783)
        -- upvalues: v147 (ref), v58 (ref), v57 (ref), l_v773_0 (ref), l_v774_0 (ref), l_v775_0 (ref), v24 (ref), v50 (ref), l_v768_0 (ref), l_v767_0 (ref)
        if v147.antiaim_type ~= "Builder" or not v783 then
            return;
        else
            local l_condition_0 = v58.condition;
            if not v147["Enabled_" .. l_condition_0] then
                l_condition_0 = "Global";
            end;
            local v785 = v147["YawOffset_" .. l_condition_0];
            local v786 = v147["YawType_" .. l_condition_0];
            local v787 = v147["YawModifier_" .. l_condition_0];
            local v788 = v147["YawModifierOffset_1_" .. l_condition_0];
            local v789 = v147["YawModifierRandomize_" .. l_condition_0];
            local v790 = rage.antiaim:inverter();
            local v791 = v147["LimitType_" .. l_condition_0];
            local v792 = v147["LeftLimit_" .. l_condition_0];
            local v793 = v147["RightLimit_" .. l_condition_0];
            local v794 = v147["FakeOptions_" .. l_condition_0];
            local v795 = 0;
            local v796 = v147["YawD_" .. l_condition_0];
            local v797 = v147["YawD2_" .. l_condition_0];
            if v796 ~= nil and v796 > 0 then
                v795 = v796;
                if v797 ~= nil and v797 > 0 then
                    v795 = utils.random_int(v796, v797);
                end;
            end;
            if not v57.functions.vanish and table.contains(v794, "Jitter") then
                if v781.choked_commands == 0 then
                    l_v773_0 = not l_v773_0;
                end;
                v790 = l_v773_0;
                v796 = {};
                for v798 = 1, #v794 do
                    local v799 = v794[v798];
                    if v799 ~= "Jitter" then
                        table.insert(v796, v799);
                    end;
                end;
                v794 = v796;
            end;
            if v786 ~= "180" and not v57.functions.safe_head and not v57.functions.vanish and not v57.functions.hidden_static then
                if v786 == "Left / Right" then
                    if v795 > 0 and rage.exploit:get() == 1 then
                        if v781.choked_commands == 0 then
                            l_v774_0 = l_v774_0 + 1;
                            if v795 <= l_v774_0 then
                                l_v774_0 = 0;
                                l_v775_0 = not l_v775_0;
                            end;
                        end;
                        v790 = l_v775_0;
                        v796 = {};
                        for v800 = 1, #v794 do
                            local v801 = v794[v800];
                            if v801 ~= "Jitter" then
                                table.insert(v796, v801);
                            end;
                        end;
                        v794 = v796;
                    end;
                    v785 = v790 and v147["YawOffsetLeft_" .. l_condition_0] or v147["YawOffsetRight_" .. l_condition_0];
                end;
                if v786 == "Flick" then
                    v785 = v24:flick(v58.condition, v147["YawOffsetLeft_" .. l_condition_0], v147["YawOffsetRight_" .. l_condition_0], v147["YawDelay_" .. l_condition_0]);
                end;
                if v786 == "Sway" then
                    v785 = v50:sway(v58.condition, v147["YawOffsetLeft_" .. l_condition_0], v147["YawOffsetRight_" .. l_condition_0], v147["YawDelay_" .. l_condition_0], v147["YawSpeed_" .. l_condition_0]);
                end;
                if v786 == "Spin" then
                    v785 = v50:spin(v58.condition, v147["YawOffsetLeft_" .. l_condition_0], v147["YawOffsetRight_" .. l_condition_0], 1, v147["YawSpeed_" .. l_condition_0]);
                end;
            end;
            if v789 ~= 0 then
                if v788 > 0 then
                    v788 = utils.random_int(math.clamp(v788 - v789, -180, 180), math.clamp(v788 + v789, -180, 180));
                else
                    v788 = utils.random_int(math.clamp(v788 + v789, -180, 180), math.clamp(v788 - v789, -180, 180));
                end;
            end;
            if v787 == "Offset" then
                if not v790 or not v788 then
                    v796 = 0;
                else
                    v796 = v788;
                end;
                v785 = v785 + v796;
                v787 = "Disabled";
                v788 = 0;
            end;
            if v787 == "Center" then
                if not v790 or not v788 then
                    v796 = -v788;
                else
                    v796 = v788;
                end;
                v785 = v785 + v796 * 0.5;
                v787 = "Disabled";
                v788 = 0;
            end;
            if v787 == "3-Way" or v787 == "5-Way" then
                if v781.choked_commands == 0 then
                    l_v768_0 = l_v768_0 + 1;
                    if l_v768_0 > (v787 == "3-Way" and 3 or 5) then
                        l_v768_0 = 1;
                    end;
                end;
                if v147["YawModifierWayType_" .. l_condition_0] then
                    v785 = v785 + v147["YawModifierOffset_" .. l_v768_0 .. "_" .. l_condition_0];
                    v787 = "Disabled";
                    v788 = 0;
                end;
            end;
            if v791 == "Flick" then
                v792 = v24:flick(string.format("LFlick %s", v58.condition), v792, v793, v147["LimitDelay_" .. l_condition_0]);
                v793 = v24:flick(string.format("RFlick %s", v58.condition), v792, v793, v147["LimitDelay_" .. l_condition_0]);
            elseif v791 == "Sway" then
                v792 = v50:sway(string.format("LSway %s", v58.condition), v792, v793, v147["LimitDelay_" .. l_condition_0], v147["LimitSpeed_" .. l_condition_0]);
                v793 = v50:sway(string.format("RSway %s", v58.condition), v792, v793, v147["LimitDelay_" .. l_condition_0], v147["LimitSpeed_" .. l_condition_0]);
            end;
            l_v767_0:tick();
            l_v767_0.enabled = true;
            l_v767_0.pitch = v57.functions.legit and "Disabled" or v147["Pitch_" .. l_condition_0];
            l_v767_0.yaw.main = v147["Yaw_" .. l_condition_0];
            l_v767_0.yaw.base = v147["YawBase_" .. l_condition_0];
            l_v767_0.yaw.offset = v785;
            l_v767_0.yaw_modifier.main = v787;
            l_v767_0.yaw_modifier.offset = v788;
            l_v767_0.body_yaw.main = v147["BodyYaw_" .. l_condition_0];
            l_v767_0.body_yaw.inverter = v790;
            l_v767_0.body_yaw.left_limit = v792;
            l_v767_0.body_yaw.right_limit = v793;
            l_v767_0.body_yaw.options = v794;
            l_v767_0.body_yaw.freestanding = v147["Freestanding_" .. l_condition_0];
            l_v767_0.extended_angles.main = v147["ExtendedAngles_" .. l_condition_0];
            l_v767_0.extended_angles.pitch = v147["ExtendedPitch_" .. l_condition_0];
            l_v767_0.extended_angles.roll = v147["ExtendedRoll_" .. l_condition_0];
            l_v767_0:run();
            return;
        end;
    end);
end;
v767 = nil;
v767 = {};
v768 = 1;
v769 = nil;
v770 = -1;
v771 = 0;
v772 = 0;
v767.Aggressive = {
    [v57.states[v57.states_enum.STAND]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 8, 
        yaw_mod_randomize = 500, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 3, 
        left_offset = {
            [1] = -19, 
            [2] = -23
        }, 
        right_offset = {
            [1] = 36, 
            [2] = 45
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.MOVE]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 220, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 4, 
        left_offset = {
            [1] = -24, 
            [2] = -27
        }, 
        right_offset = {
            [1] = 36, 
            [2] = 39
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.SLOWWALK]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 6, 
        yaw_mod_randomize = 50, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 3, 
        left_offset = {
            [1] = -26, 
            [2] = -32
        }, 
        right_offset = {
            [1] = 40, 
            [2] = 47
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH]] = {
        left_limit = 58, 
        yaw_mod = "3-Way", 
        limit_type = "Default", 
        yaw_mod_randomize = 0, 
        yaw_type = "Left / Right", 
        yaw_mod_deg = 15, 
        right_limit = 58, 
        left_offset = {
            [1] = -25, 
            [2] = -30
        }, 
        right_offset = {
            [1] = 40, 
            [2] = 46
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH_MOVE]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 14, 
        yaw_mod_randomize = 200, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 4, 
        left_offset = {
            [1] = -25, 
            [2] = -27
        }, 
        right_offset = {
            [1] = 37, 
            [2] = 40
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 6, 
        yaw_mod_randomize = 200, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 3, 
        left_offset = {
            [1] = -24, 
            [2] = -26
        }, 
        right_offset = {
            [1] = 26, 
            [2] = 30
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR_CR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 7, 
        yaw_mod_randomize = 200, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 2, 
        left_offset = {
            [1] = -17, 
            [2] = -20
        }, 
        right_offset = {
            [1] = 37, 
            [2] = 42
        }, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.USING]] = {
        left_offset = 1, 
        right_offset = 1, 
        yaw_type = "180", 
        yaw_offset = 180
    }
};
v767.Classic = {
    [v57.states[v57.states_enum.STAND]] = {
        yaw_mod_deg = 5, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 200, 
        left_offset = -23, 
        right_offset = 33, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.MOVE]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 50, 
        left_offset = -30, 
        right_offset = 30, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.SLOWWALK]] = {
        yaw_mod_deg = -15, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 20, 
        left_offset = -29, 
        right_offset = 43, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH]] = {
        yaw_mod_deg = 15, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 50, 
        left_offset = -29, 
        right_offset = 49, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH_MOVE]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 30, 
        left_offset = -18, 
        right_offset = 43, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 10, 
        left_offset = -25, 
        right_offset = 39, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR_CR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 25, 
        left_offset = -17, 
        right_offset = 37, 
        yaw_type = "Left / Right", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.USING]] = {
        left_offset = 1, 
        right_offset = 1, 
        yaw_type = "180", 
        yaw_offset = 180
    }
};
v767.Unrivaled = {
    [v57.states[v57.states_enum.STAND]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 50, 
        left_offset = -23, 
        right_offset = 38, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.MOVE]] = {
        yaw_mod_deg = -15, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 20, 
        left_offset = -26, 
        right_offset = 33, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.SLOWWALK]] = {
        yaw_mod_deg = -15, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 5, 
        yaw_mod_randomize = 20, 
        left_offset = -23, 
        right_offset = 43, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        right_limit = 58, 
        limit_delay = 58, 
        yaw_delay = 4, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH]] = {
        yaw_mod_deg = 15, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 50, 
        left_offset = -29, 
        right_offset = 49, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.CROUCH_MOVE]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 40, 
        left_offset = -19, 
        right_offset = 42, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        yaw_delay_second = 3, 
        yaw_mod_randomize = 10, 
        left_offset = -14, 
        right_offset = 39, 
        yaw_type = "Left / Right", 
        limit_type = "Default", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.AIR_CR]] = {
        yaw_mod_deg = 0, 
        yaw_mod = "Disabled", 
        limit_type = "Default", 
        yaw_mod_randomize = 30, 
        left_offset = -17, 
        right_offset = 38, 
        yaw_type = "Left / Right", 
        left_limit = 58, 
        right_limit = 58, 
        yaw_delay = 1, 
        fake_options = {
            [1] = "Jitter"
        }
    }, 
    [v57.states[v57.states_enum.USING]] = {
        left_offset = 1, 
        right_offset = 1, 
        yaw_type = "180", 
        yaw_offset = 180
    }
};
v773 = l_handler_0.new("Presets", 2);
v774 = false;
v775 = 0;
local v802 = false;
do
    local l_v768_1, l_v773_1, l_v774_1, l_v775_1, l_v802_0 = v768, v773, v774, v775, v802;
    v72.Presets.createmove:set(function(v808, _, v810)
        -- upvalues: v147 (ref), v767 (ref), v635 (ref), v57 (ref), l_v774_1 (ref), l_v775_1 (ref), l_v802_0 (ref), v24 (ref), v58 (ref), v50 (ref), l_v768_1 (ref), l_v773_1 (ref)
        local l_antiaim_type_0 = v147.antiaim_type;
        if l_antiaim_type_0 ~= "Aggressive" and l_antiaim_type_0 ~= "Classic" and l_antiaim_type_0 ~= "Unrivaled" or not v810 then
            return;
        else
            local v812 = v767[l_antiaim_type_0];
            local v813 = v635.condition(v812["Fake Lag"] ~= nil);
            if v813 == nil or v813 == "" then
                return;
            else
                local v814 = v812[v813];
                local v815 = v814.yaw_offset or 0;
                local v816 = v814.yaw_type or "180";
                local v817 = v814.yaw_mod or "Disabled";
                local v818 = v814.yaw_mod_deg or 0;
                local l_yaw_mod_randomize_0 = v814.yaw_mod_randomize;
                local l_inverter_0 = v814.inverter;
                local l_limit_type_0 = v814.limit_type;
                local v822 = v814.left_limit or 58;
                local v823 = v814.right_limit or 58;
                local l_fake_options_0 = v814.fake_options;
                local v825 = type(v814.left_offset) == "table" and utils.random_int(v814.left_offset[1], v814.left_offset[2]) or v814.left_offset;
                local v826 = type(v814.right_offset) == "table" and utils.random_int(v814.right_offset[1], v814.right_offset[2]) or v814.right_offset;
                local v827 = v814.yaw_delay_second ~= nil and utils.random_int(v814.yaw_delay, v814.yaw_delay_second) or v814.yaw_delay;
                if l_inverter_0 == nil then
                    l_inverter_0 = rage.antiaim:inverter();
                end;
                if not v57.functions.vanish and l_fake_options_0 ~= nil and table.contains(l_fake_options_0, "Jitter") then
                    if v808.choked_commands == 0 then
                        l_v774_1 = not l_v774_1;
                    end;
                    l_inverter_0 = l_v774_1;
                    local v828 = {};
                    for v829 = 1, #l_fake_options_0 do
                        local v830 = l_fake_options_0[v829];
                        if v830 ~= "Jitter" then
                            table.insert(v828, v830);
                        end;
                    end;
                    l_fake_options_0 = v828;
                end;
                if v816 ~= "180" and not v57.functions.safe_head and not v57.functions.vanish and not v57.functions.hidden_static then
                    if v816 == "Left / Right" then
                        if v827 ~= nil and rage.exploit:get() == 1 then
                            if v808.choked_commands == 0 then
                                l_v775_1 = l_v775_1 + 1;
                                if v827 <= l_v775_1 then
                                    l_v775_1 = 0;
                                    l_v802_0 = not l_v802_0;
                                end;
                            end;
                            l_inverter_0 = l_v802_0;
                            local v831 = {};
                            for v832 = 1, #l_fake_options_0 do
                                local v833 = l_fake_options_0[v832];
                                if v833 ~= "Jitter" then
                                    table.insert(v831, v833);
                                end;
                            end;
                            l_fake_options_0 = v831;
                        end;
                        v815 = l_inverter_0 and v825 or v826;
                    end;
                    if v816 == "Flick" then
                        v815 = v24:flick(v58.condition, v825, v826, v814.yaw_delay);
                    end;
                    if v816 == "Sway" then
                        v815 = v50:sway(v58.condition, v825, v826, v814.yaw_delay, v814.yaw_speed);
                    end;
                    if v816 == "Spin" then
                        v815 = v50:spin(v58.condition, v825, v826, 1, v814.yaw_speed);
                    end;
                end;
                if l_yaw_mod_randomize_0 ~= nil then
                    if v818 > 0 then
                        v818 = utils.random_int(math.clamp(v818 - l_yaw_mod_randomize_0, -180, 180), math.clamp(v818 + l_yaw_mod_randomize_0, -180, 180));
                    else
                        v818 = utils.random_int(math.clamp(v818 + l_yaw_mod_randomize_0, -180, 180), math.clamp(v818 - l_yaw_mod_randomize_0, -180, 180));
                    end;
                end;
                if v817 == "Offset" then
                    local v834;
                    if not l_inverter_0 or not v818 then
                        v834 = 0;
                    else
                        v834 = v818;
                    end;
                    v815 = v815 + v834;
                    v817 = "Disabled";
                    v818 = 0;
                end;
                if v817 == "Center" then
                    local v835;
                    if not l_inverter_0 or not v818 then
                        v835 = -v818;
                    else
                        v835 = v818;
                    end;
                    v815 = v815 + v835 * 0.5;
                    v817 = "Disabled";
                    v818 = 0;
                end;
                if v817 == "3-Way" or v817 == "5-Way" then
                    if v808.choked_commands == 0 then
                        l_v768_1 = l_v768_1 + 1;
                        if l_v768_1 > (v817 == "3-Way" and 3 or 5) then
                            l_v768_1 = 1;
                        end;
                    end;
                    if v814.custom_way_modifier ~= nil then
                        v815 = v814.yaw_ways[l_v768_1];
                        v817 = "Disabled";
                        v818 = 0;
                    end;
                end;
                if l_limit_type_0 ~= nil then
                    if l_limit_type_0 == "Flick" then
                        v822 = v24:flick(string.format("LFlick %s", v58.condition), v822, v823, v814.limit_delay);
                        v823 = v24:flick(string.format("RFlick %s", v58.condition), v822, v823, v814.limit_delay);
                    elseif l_limit_type_0 == "Sway" then
                        v822 = v50:sway(string.format("LSway %s", v58.condition), v822, v823, v814.limit_delay, v814.limit_speed);
                        v823 = v50:sway(string.format("RSway %s", v58.condition), v822, v823, v814.limit_delay, v814.limit_speed);
                    end;
                end;
                l_v773_1:tick();
                l_v773_1.enabled = true;
                l_v773_1.pitch = v57.functions.legit and "Disabled" or "Down";
                l_v773_1.yaw.main = "Backward";
                l_v773_1.yaw.base = "At Target";
                l_v773_1.yaw.offset = v815;
                l_v773_1.yaw_modifier.main = v817;
                l_v773_1.yaw_modifier.offset = v818;
                l_v773_1.body_yaw.main = v814.body_yaw or true;
                l_v773_1.body_yaw.inverter = l_inverter_0;
                l_v773_1.body_yaw.left_limit = v822;
                l_v773_1.body_yaw.right_limit = v823;
                l_v773_1.body_yaw.options = l_fake_options_0;
                l_v773_1.body_yaw.freestanding = v814.freestanding or "Off";
                l_v773_1:run();
                return;
            end;
        end;
    end);
end;
v768 = nil;
v769 = l_handler_0.new("Hidden", 7);
v770 = false;
do
    local l_v769_0, l_v770_0, l_v771_0, l_v772_0, l_v773_2, l_v774_2, l_v775_2, l_v802_1 = v769, v770, v771, v772, v773, v774, v775, v802;
    l_v771_0 = function()
        -- upvalues: l_v770_0 (ref), v60 (ref)
        if l_v770_0 then
            v60.RAGE.aimbot.double_tap.options:override();
            v60.RAGE.aimbot.hide_shots.options:override();
            l_v770_0 = false;
        end;
    end;
    l_v772_0 = v146:reference("hidden_conditions").reference;
    l_v773_2 = v146:reference("hidden_triggers").reference;
    l_v774_2 = utils.get_netvar_offset("DT_CSPlayer", "m_flFlashDuration") - 16;
    l_v775_2 = function(v844)
        return globals.curtime - v844 * globals.tickinterval;
    end;
    l_v802_1 = function(v845)
        -- upvalues: l_v774_2 (ref)
        return ffi.cast("float*", ffi.cast("uint32_t", v845[0]) + l_v774_2)[0];
    end;
    local function v848(v846, v847)
        return v846 % (v847 + 1) / v847;
    end;
    local function v854(v849, v850)
        -- upvalues: v147 (ref), v57 (ref), v848 (ref)
        if v850 == "Static" then
            return v147["DefPitchOffset1_" .. v849];
        elseif v850 == "Jitter" then
            return bit.band(v57.jitter, 1) == 0 and v147["DefPitchOffset1_" .. v849] or v147["DefPitchOffset2_" .. v849];
        elseif v850 == "Spin" then
            local v851 = v147["DefPitchOffset1_" .. v849];
            local v852 = v147["DefPitchOffset2_" .. v849];
            local v853 = v147["DefPitchSpeed_" .. v849];
            return v851 + v848(v57.jitter, v853) * (v852 - v851);
        else
            return 0;
        end;
    end;
    local function v863(v855, v856)
        -- upvalues: v147 (ref), v57 (ref), v848 (ref)
        if v856 == "Static" then
            return v147["DefYawOffset_" .. v855];
        elseif v856 == "Jitter" then
            local v857 = v147["DefYawOffset_" .. v855];
            local v858 = v147["DefYawD_" .. v855];
            if v858 > 1 then
                return v57.jitter % (v858 * 2) < v858 and v857 or -v857;
            else
                return bit.band(v57.jitter, 1) == 0 and v857 or -v857;
            end;
        elseif v856 == "Spin" then
            local v859 = v147["DefYawOffset_" .. v855];
            local v860 = v147["DefYawSpeed_" .. v855];
            return v859 * 2 * v848(v57.jitter, v860 + 1);
        elseif v856 == "3-Way" then
            local v861 = {
                [1] = 90, 
                [2] = 180, 
                [3] = -90
            };
            return v861[v57.jitter % #v861 + 1] + utils.random_float(-15, 15);
        elseif v856 == "5-Way" then
            local v862 = {
                [1] = 90, 
                [2] = 135, 
                [3] = 180, 
                [4] = 225, 
                [5] = 270
            };
            return v862[v57.jitter % #v862 + 1] + utils.random_float(-15, 15);
        else
            return 0;
        end;
    end;
    local function v866(v864, v865)
        -- upvalues: l_v775_2 (ref)
        if v864 == nil or v865 == nil then
            return false;
        elseif l_v775_2(16) < v864.m_flNextAttack then
            return false;
        elseif l_v775_2(0) < v865.m_flNextPrimaryAttack then
            return false;
        else
            return true;
        end;
    end;
    local function v870(v867)
        -- upvalues: l_v773_2 (ref), l_v802_1 (ref), v866 (ref), v60 (ref), v57 (ref), v147 (ref)
        local v868 = v867:get_player_weapon();
        local v869 = v867:get_anim_overlay(10);
        if l_v773_2:get("Flashed") and l_v802_1(v867) > 0 then
            return "Flashed";
        elseif l_v773_2:get("Taking Damage") and v869.cycle < 0.99 then
            return "Taking Damage";
        elseif l_v773_2:get("Weapon Not Ready") and not v866(v867, v868) and not v60.RAGE.other.peek_assist:get() then
            return "Weapon Not Ready";
        elseif l_v773_2:get("Freestanding") and v60.AA.angles.freestanding:get() and rage.antiaim:get_target(true) then
            return "Freestanding";
        elseif l_v773_2:get("Safe Head") and v57.functions.safe_head then
            return "Safe Head";
        elseif l_v773_2:get("Manual Yaw") and v147.manual_yaw ~= "Disabled" then
            return "Manual Yaw";
        else
            return nil;
        end;
    end;
    local function v874(v871, v872)
        -- upvalues: v870 (ref), l_v772_0 (ref)
        local v873 = v870(v871);
        if v873 ~= nil then
            return "Triggers", v873;
        elseif not l_v772_0:get(v872) then
            return nil, nil;
        else
            return v872, nil;
        end;
    end;
    local function v880(v875, v876, v877)
        -- upvalues: v147 (ref), v59 (ref), l_v769_0 (ref), v57 (ref)
        if v877 == "On Peek" then
            return;
        elseif not v147["DefForceTargetYaw_" .. v877] then
            return;
        elseif v59.ticks == 0 then
            return;
        else
            local v878 = v876:get_player_weapon();
            if v878 == nil then
                return;
            elseif v878:get_weapon_index() == 64 then
                return;
            else
                local v879 = false;
                if v877 ~= "Triggers" then
                    l_v769_0.yaw.main = "Backward";
                    l_v769_0.yaw.base = "At Target";
                    l_v769_0.yaw.offset = 0;
                    l_v769_0.yaw_modifier.main = "Disabled";
                    l_v769_0.yaw_modifier.offset = 0;
                end;
                l_v769_0.body_yaw.main = true;
                l_v769_0.body_yaw.left_limit = 58;
                l_v769_0.body_yaw.right_limit = 58;
                if v875.choked_commands == 0 then
                    v879 = not v879;
                end;
                rage.antiaim:inverter(v879);
                l_v769_0.body_yaw.options = {
                    [1] = ""
                };
                l_v769_0.body_yaw.freestanding = "Off";
                v57.functions.hidden_static = true;
                return;
            end;
        end;
    end;
    local function v887(v881, v882, v883)
        -- upvalues: v848 (ref), v57 (ref), v880 (ref)
        local v884 = 360 * v848(v57.jitter, 10);
        local v885 = utils.random_int(170, 180);
        local _ = utils.random_int(-90, 90);
        if v883 == "Flashed" or v883 == "Taking Damage" then
            rage.antiaim:override_hidden_pitch(-45);
            rage.antiaim:override_hidden_yaw_offset(v884);
            return;
        elseif v883 == "Weapon Not Ready" then
            rage.antiaim:override_hidden_pitch(-45);
            rage.antiaim:override_hidden_yaw_offset(180);
            return;
        elseif v883 == "Safe Head" then
            rage.antiaim:override_hidden_pitch(7);
            rage.antiaim:override_hidden_yaw_offset(v885);
            return;
        elseif v883 == "Manual Yaw" then
            v880(v881, v882, "Triggers");
            rage.antiaim:override_hidden_pitch(-20);
            rage.antiaim:override_hidden_yaw_offset(v885);
            return;
        elseif v883 == "Freestanding" then
            v880(v881, v882, "Triggers");
            rage.antiaim:override_hidden_pitch(-20);
            rage.antiaim:override_hidden_yaw_offset(v885);
            return;
        else
            return;
        end;
    end;
    local function v892(v888)
        -- upvalues: v147 (ref), v854 (ref)
        local v889 = v147["DefPitch_" .. v888];
        if v889 == "Default" then
            return;
        else
            local v890 = v854(v888, v889);
            local v891 = v147["DefPitchRandom_" .. v888];
            v890 = v890 + utils.random_int(-v891, v891);
            rage.antiaim:override_hidden_pitch(math.clamp(v890, -89, 89));
            return;
        end;
    end;
    local function v897(v893)
        -- upvalues: v147 (ref), v863 (ref)
        local v894 = v147["DefYaw_" .. v893];
        if v894 == "Default" then
            return;
        else
            local v895 = v863(v893, v894);
            local v896 = v147["DefYawRandom_" .. v893];
            v895 = v895 + utils.random_int(-v896, v896);
            rage.antiaim:override_hidden_yaw_offset(math.normalize_yaw(-v895, -180, 180));
            return;
        end;
    end;
    local function v901(v898, v899)
        -- upvalues: v147 (ref), l_v769_0 (ref), v50 (ref)
        if rage.exploit:get() ~= 1 then
            return;
        else
            local v900 = v147["DefInvertFlick_" .. v899];
            if v899 ~= "On Peek" then
                l_v769_0.yaw.main = "Backward";
                l_v769_0.yaw.base = "At Target";
                l_v769_0.yaw.offset = v900 and -16 or 15;
                l_v769_0.yaw_modifier.main = "Disabled";
                l_v769_0.yaw_modifier.offset = 0;
                l_v769_0.body_yaw.main = true;
                l_v769_0.body_yaw.inverter = v900;
                l_v769_0.body_yaw.left_limit = 60;
                l_v769_0.body_yaw.right_limit = 60;
                l_v769_0.body_yaw.options = {
                    [1] = ""
                };
                l_v769_0.body_yaw.freestanding = "Off";
                v898.force_defensive = v50:spin(0, 64, 1, 1) > 63;
            end;
            rage.antiaim:override_hidden_pitch(0);
            rage.antiaim:override_hidden_yaw_offset(v900 and 111 or -111);
            return;
        end;
    end;
    local function v907(v902, v903, v904, v905)
        -- upvalues: v147 (ref), l_v769_0 (ref), v887 (ref), v880 (ref), v892 (ref), v897 (ref), v901 (ref)
        local v906 = v147["DefMode_" .. v904];
        l_v769_0.yaw.hidden = true;
        if v904 == "Triggers" then
            v887(v902, v903, v905);
            if v905 == "Manual Yaw" or v905 == "Freestanding" then
                return;
            else
                v880(v902, v903, v904);
            end;
        elseif v906 == "Default" then
            v880(v902, v903, v904);
            v892(v904);
            v897(v904);
        elseif v906 == "Flick" then
            v901(v902, v904);
        end;
    end;
    v72.HihiHaha.createmove:set(function(v908, v909, v910)
        -- upvalues: v57 (ref), l_v769_0 (ref), v60 (ref), v147 (ref), l_v771_0 (ref), v58 (ref), v874 (ref), l_v770_0 (ref), v907 (ref)
        v57.functions.hidden_aa = false;
        v57.functions.hidden_static = false;
        local v911 = entity.get_game_rules();
        local v912 = v910 and not v57.functions.vanish;
        l_v769_0:tick();
        if rage.exploit:get() > 0 then
            local v913 = v60.RAGE.aimbot.double_tap.main:get();
            local v914 = v60.RAGE.aimbot.hide_shots.main:get();
            if not v147.hidden_hs and v914 and not v913 then
                v912 = false;
            end;
        else
            v912 = false;
        end;
        if v57.functions.air_exploit or v57.functions.edge or v57.functions.backstab then
            v912 = false;
        end;
        if v911 ~= nil and v911.m_bFreezePeriod then
            v912 = false;
        end;
        if not v912 then
            l_v769_0.yaw.hidden = false;
            l_v771_0();
            return;
        else
            local l_condition_1 = v58.condition;
            local v916 = nil;
            local v917 = false;
            local v918, v919 = v874(v909, l_condition_1);
            if v918 == nil then
                if v147["DefEnabled_" .. "On Peek"] then
                    v916 = "On Peek";
                    v917 = false;
                end;
            else
                if v147["DefEnabled_" .. l_condition_1] and v147["DefMode_" .. l_condition_1] == "Flick" then
                    v916 = l_condition_1;
                elseif v147["DefEnabled_" .. v918] then
                    v916 = v918;
                end;
                v917 = true;
            end;
            if v917 then
                v60.RAGE.aimbot.double_tap.options:override("Always On");
                v60.RAGE.aimbot.hide_shots.options:override("Break LC");
                l_v770_0 = true;
            else
                l_v771_0();
            end;
            if not v147.hidden_aa or v916 == nil then
                l_v769_0.yaw.hidden = false;
                return;
            else
                v907(v908, v909, v916, v919);
                l_v769_0:run();
                return;
            end;
        end;
    end);
end;
v769 = nil;
v770 = l_handler_0.new("Randomization", 10);
do
    local l_v770_1 = v770;
    v72.Randomization.createmove:set(function(v921, _, v923)
        -- upvalues: v57 (ref), v147 (ref), l_v770_1 (ref), v50 (ref)
        v57.functions.randomization = false;
        if not v147.randomize_switch or v147.manual_yaw ~= "Disabled" or v57.functions.legit or not v923 then
            return;
        else
            local _ = false;
            local v925 = entity.get_game_rules();
            if v925 == nil then
                return;
            else
                l_v770_1:tick();
                if v147.randomize_on_round_end and globals.curtime < v925.m_flRestartRoundTime then
                    local v926 = true;
                    do
                        local l_v926_0 = v926;
                        entity.get_players(true, true, function(v928)
                            -- upvalues: l_v926_0 (ref)
                            if v928:is_alive() then
                                l_v926_0 = false;
                            end;
                        end);
                        if l_v926_0 then
                            v57.functions.randomization = true;
                        end;
                    end;
                end;
                if v147.randomize_on_warmup and v925.m_bWarmupPeriod then
                    v57.functions.randomization = true;
                end;
                if v57.functions.randomization then
                    l_v770_1.pitch = "Disabled";
                    l_v770_1.yaw.main = "Backward";
                    l_v770_1.yaw.offset = -v50:spin("Salam", -180, 180, 1, 5);
                    l_v770_1.yaw.base = "At Target";
                    l_v770_1.yaw_modifier.main = "Disabled";
                    l_v770_1.yaw_modifier.offset = 0;
                    l_v770_1.body_yaw.main = false;
                    l_v770_1.body_yaw.left_limit = 58;
                    l_v770_1.body_yaw.right_limit = 58;
                    l_v770_1.body_yaw.options = {
                        [1] = ""
                    };
                    l_v770_1.body_yaw.freestanding = "";
                    rage.exploit:allow_defensive(false);
                    v921.no_choke = true;
                end;
                l_v770_1:run();
                return;
            end;
        end;
    end);
end;
v770 = nil;
v771 = l_handler_0.new("Anti backstab", 24);
do
    local l_v771_1, l_v772_1 = v771, v772;
    l_v772_1 = function(v931)
        -- upvalues: l_v771_1 (ref), v57 (ref)
        local v932 = {
            distance = 300
        };
        local v933 = v931:get_eye_position();
        local v934 = entity.get_players(true);
        for _, v936 in pairs(v934) do
            local v937 = v936:get_player_weapon();
            if v937 then
                local v938 = v937:get_classname();
                if v938 and v938 == "CKnife" then
                    local v939 = v933:dist((v936:get_origin()));
                    if v932.distance >= v939 then
                        v932.ent = v936;
                        v932.distance = v939;
                    end;
                end;
            end;
        end;
        if not v932.ent then
            return;
        else
            local v940 = (v933 - v932.ent:get_origin()):angles();
            local v941 = render.camera_angles();
            local v942 = math.normalize_yaw(v940.y - v941.y);
            l_v771_1:tick();
            l_v771_1.yaw.base = "Local View";
            l_v771_1.yaw.offset = v942;
            l_v771_1:run();
            v57.functions.backstab = true;
            return;
        end;
    end;
    v72["Anti Backstab"].createmove:set(function(_, v944, v945)
        -- upvalues: v57 (ref), v147 (ref), l_v772_1 (ref)
        v57.functions.backstab = false;
        if not v147.anti_backstab or v57.functions.edge or v57.functions.legit or not v945 then
            return;
        else
            l_v772_1(v944);
            return;
        end;
    end);
end;
v771 = nil;
v772 = {
    head = {
        [1] = "\208\186\208\176\208\186\208\190\208\185 \208\182\208\181 \209\130\209\139 \209\133\209\131\208\181\208\178\209\139\208\185 / \209\129\209\130\208\176\209\130\208\184\208\186 \208\189\209\139\208\189\209\135\208\181 \208\189\208\181 \208\178 \208\188\208\190\208\180\208\181", 
        [2] = "\208\186\209\131\208\183\209\143", 
        [3] = "\208\186\208\176\208\186 \208\182\208\181 \209\130\209\139 \209\129\208\190\209\135\208\189\208\190 \208\190\209\130\208\187\208\181\209\130\208\181\208\187 / \209\129 \208\187\209\131\208\176\209\129\208\181\208\189\209\129\208\190\208\188 \208\184\208\179\209\128\208\176\208\181\209\136\209\140 \209\135\209\130\208\190 \208\187\208\184?", 
        [4] = "1 / \209\130\208\190\208\187\209\140\208\186\208\190 \208\191\208\190\208\191\209\128\208\190\208\177\209\131\208\185 \208\190\208\191\209\128\208\176\208\178\208\180\208\176\209\130\209\140\209\129\209\143 / \209\131\208\177\208\190\208\179\208\190\208\181 \209\135\208\188\208\190", 
        [5] = "\209\130\208\181\208\177\209\143 \209\130\208\190\208\187\209\140\208\186\208\190 \209\135\209\130\208\190 \209\129\209\131\208\185\208\180\209\131\209\129 \208\190\208\177\208\190\209\129\209\129\208\176\208\187 / \209\130\208\178\208\190\208\184 \208\180\208\181\208\185\209\129\209\130\208\178\208\184\209\143?", 
        [6] = "S[[DF[F[FS[SDF[DS[FSD[FDS[F[F[F[F / stupid skeetless", 
        [7] = "1 / \208\189\208\176\208\180\208\181\209\142\209\129\209\140 \209\130\208\181\208\191\208\181\209\128\209\140 \209\130\209\139 \208\191\208\190\208\183\208\189\208\176\208\187 \209\135\209\130\208\190 \209\130\208\176\208\186\208\190\208\181 \208\191\208\181\208\189\208\184\209\130\209\140", 
        [8] = "1 / sleep dog", 
        [9] = "1 / ahahahahahahahah", 
        [10] = "\208\189\208\181 \209\131\209\129\209\130\208\176\208\187 \208\191\208\190\208\183\208\190\209\128\208\184\209\130\209\140\209\129\209\143 \208\190\208\177\208\188\209\131\208\180\208\190\208\186? / \208\187\208\184\208\178\208\189\208\184 \209\131\208\182\208\181 \208\189\208\176\209\133\209\131\208\185", 
        [11] = "\208\188\208\188\208\188 \208\189\208\176\208\184\208\178\208\189\209\139\208\185 / 1 \209\133\209\131\208\181\209\129\208\190\209\129", 
        [12] = "\209\135\208\181 \209\130\209\139 \209\130\208\176\208\188 \209\135\208\176\208\178\208\186\208\176\208\181\209\136\209\140 \208\191\208\184\208\183\208\180\208\190\208\185 / \209\129\208\184\208\180\208\184 \208\188\208\190\208\187\209\135\208\176", 
        [13] = "\209\135\208\181\209\130\208\186\208\190 \208\178 \208\182\208\177\208\176\208\189 / \208\191\209\128\209\143\208\188\208\190 \208\186\208\176\208\186 \208\178 \209\130\208\178\208\190\209\142 \208\188\208\176\209\130\209\140 \208\184\208\183 \208\180\209\128\208\190\208\177\208\190\208\178\208\184\208\186\208\176", 
        [14] = "\208\145\208\144\208\156", 
        [15] = "L / kys", 
        [16] = "u think im lucky?? / just xo-yaw", 
        [17] = "\208\180\208\190\208\177\209\128\209\139\208\185 \208\178\208\181\209\135\208\181\209\128", 
        [18] = "\208\189\208\190\209\128\208\188\208\176\209\129 \209\143 \209\130\208\181\208\177\209\143 \209\136\208\187\209\145\208\191\208\189\209\131\208\187 / \209\129\209\128\208\176\208\183\209\131 \208\178\208\184\208\180\208\189\208\190 \209\135\209\131\208\178\208\176\209\135\208\181\208\187\208\176 \209\129 \208\176\209\129\208\184\208\180\208\190\208\188 / \209\130\208\190\208\187\209\140\208\186\208\190 \209\141\209\130\209\131 \209\133\209\131\208\185\208\189\209\142 \209\130\208\176\208\191\208\189\209\131\209\130\209\140 \208\188\208\190\208\182\208\189\208\190", 
        [19] = "\209\129\208\190\209\129\208\184 \209\131\208\181\208\177\208\176\208\189\208\181\209\134 / \208\189\208\181 \209\135\209\131\208\178\209\129\209\130\208\178\209\131\209\142 \209\130\208\181\208\177\209\143 \208\176\208\177\209\129\208\190\208\187\209\142\209\130\208\189\208\190", 
        [20] = "1 / \208\187\208\190\208\178\208\184 \208\191\208\190 \209\136\208\187\209\143\208\191\208\181", 
        [21] = "1 / \208\191\209\128\209\143\208\188 \208\186\208\176\208\186 \208\178 \209\130\208\184\209\128\208\181 "
    }, 
    body = {
        [1] = "\209\143 \209\130\208\178\208\190\208\181\208\185 \208\188\208\176\208\188\208\181 \209\130\208\176\209\128\208\176\208\186\208\176\208\189\208\190\208\178 \208\178 \208\182\208\190\208\191\209\131 \208\191\208\184\209\133\208\176\208\187 / \208\182\208\184\208\178\208\190\209\130\208\189\208\190\208\181 \208\181\208\177\208\176\208\189\208\190\208\181", 
        [2] = "\208\165\208\144 \208\167\208\156\208\158 \208\151\208\144\208\166\208\149\208\157\208\152 \208\144\208\153\208\148\208\152\208\168\208\157\208\152\208\154 / market.neverlose.cc/xo-yaw", 
        [3] = "u mad? / i just broke lagcomp", 
        [4] = "\209\143 \208\189\208\181 \208\191\209\128\208\190\208\182\208\184\208\188\208\176\208\187 \208\177\208\190\208\180\208\184 / \209\131 \208\188\208\181\208\189\209\143 \209\135\208\184\209\130 \208\191\209\128\208\181\208\186\209\128\208\176\209\129\208\189\209\139\208\185", 
        [5] = "FEEL THE XO-YAW / \209\135\208\188\208\190 \208\181\208\177\208\176\208\189\208\190\208\181", 
        [6] = "\208\186\208\176\208\186 \208\182\208\181 \209\143 \209\130\208\181\208\177\209\143 \208\190\208\177\208\190\209\129\209\129\208\176\208\187 / \208\189\208\181\208\188\208\190\209\137 \209\129\209\129\208\176\208\189\209\139\208\185", 
        [7] = "? / what you do dog?", 
        [8] = "\208\189\208\184\209\137\208\176\209\143 \209\133\209\131\208\185\208\189\209\143 / \208\186\209\131\208\180\208\176 \209\130\209\139 \208\191\208\190\208\191\208\190\208\187\208\183\208\187\208\176", 
        [9] = "\209\129\208\186\209\131\208\187\208\184 \209\135\208\188\208\190 \208\178 \209\133\209\131\208\185 \208\191\208\176\208\191\208\181", 
        [10] = "\208\188\208\188\208\188 \208\189\208\176\208\184\208\178\208\189\209\139\208\185 / 1 \209\133\209\131\208\181\209\129\208\190\209\129", 
        [11] = "\209\130\209\139 \209\135\208\184\209\130\208\176\208\181\209\136\209\140\209\129\209\143 \208\186\208\176\208\186 \208\186\208\189\208\184\208\179\208\176 / \209\129\208\187\208\184\209\136\208\186\208\190\208\188 \209\133\209\131\208\181\208\178\209\139\208\185 \208\180\208\187\209\143 \208\188\208\181\208\189\209\143", 
        [12] = "\208\181\208\177\209\131\209\135\208\176\209\143 \208\186\208\176\208\187\208\181\208\186\208\176 / \208\178 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\184\208\185 \209\128\208\176\208\183 \208\177\209\131\208\180\208\181\209\136\209\140 \209\131\208\188\208\189\208\181\208\181", 
        [13] = "\209\129\209\139\208\189 \208\179\208\190\208\178\208\189\208\176 / \209\129\208\189\208\190\208\178\208\176 \209\129\208\190\208\178\208\181\209\128\209\136\208\184\208\187 \208\190\209\136\208\184\208\177\208\186\209\131", 
        [14] = "\209\135\208\181 \209\136\208\189\209\139\209\128\209\140 \208\181\208\177\208\176\208\189\209\139\208\185 / \208\189\208\184\209\135\208\181 \208\189\208\181 \208\191\208\181\209\128\208\181\208\191\209\131\209\130\208\176\208\187?", 
        [15] = "\208\184 \209\135\209\130\208\190 \209\130\209\139 \209\129\208\181\208\185\209\135\208\176\209\129 \209\129\208\180\208\181\208\187\208\176\208\187 / \209\130\209\139 \209\129\208\181\209\128\209\140\208\181\208\183\208\189\208\190 \208\189\208\176\208\180\208\181\208\181\208\187\209\129\209\143 \209\135\209\130\208\190 \209\130\209\139 \209\129\208\188\208\190\208\182\208\181\209\136\209\140 \208\188\208\181\208\189\209\143 \209\131\208\177\208\184\209\130\209\140?", 
        [16] = "\208\191\209\128\209\143\208\188\208\190 \208\178 \208\191\209\131\208\183\208\190 / \208\186\208\176\208\186 \208\184 \209\133\208\190\209\130\208\181\208\187"
    }, 
    taser = {
        [1] = "\209\129\208\179\208\190\209\128\208\181\208\187 \208\191\208\184\208\180\208\190\209\128\208\176\209\129 \208\181\208\177\208\176\208\189\209\139\208\185", 
        [2] = "\208\188\208\188\208\188 \208\189\208\176\208\184\208\178\208\189\209\139\208\185 / 1 \209\133\209\131\208\181\209\129\208\190\209\129", 
        [3] = "\209\136\208\187\209\142\209\133\208\176 \208\189\208\176 \208\183\208\181\208\178\209\129\208\181", 
        [4] = "a12 / f12", 
        [5] = "yt bot", 
        [6] = "\208\187\208\190\208\178\208\184 \209\141\208\187\208\181\208\186\209\130\209\128\208\184\209\135\208\181\209\129\208\186\208\184\208\185 \208\191\209\128\208\184\208\178\208\181\209\130 / \208\180\208\190\208\187\208\177\208\176\208\181\208\177"
    }, 
    inferno = {
        [1] = "\209\129\208\179\208\190\209\128\208\181\208\187 \208\191\208\184\208\180\208\190\209\128\208\176\209\129 \208\181\208\177\208\176\208\189\209\139\208\185", 
        [2] = "\209\135\208\181 \209\129\208\188\208\190\208\186 \209\130\209\143\208\182\208\181\208\187\208\190 \208\186\208\184\208\189\209\131\209\130\209\140 \208\180\208\190\208\187\208\177\208\176\208\181\208\177?", 
        [3] = "\208\179\208\190\209\128\208\184 \208\178 \208\176\208\180\209\131", 
        [4] = "\208\189\208\184\209\133\209\131\209\143 \209\143 \209\130\208\181\208\177\209\143 \208\183\208\176\208\182\208\176\209\128\208\184\208\187 \209\131\208\177\208\187\209\142\208\180\208\186\208\176", 
        [5] = "F]DFDSFSD]F[DSFSDFS] / FIRE IN THE HELL"
    }, 
    hegrenade = {
        [1] = "\208\178\208\183\208\190\209\128\208\178\208\176\208\189 \209\133\209\131\208\185\209\129\208\190\209\129", 
        [2] = "allah akbar \209\133\209\131\208\185\209\129\208\190\209\129", 
        [3] = "\208\187\208\181\209\130\208\184 \208\190\208\177\209\128\208\176\209\130\208\189\208\190 \208\186 \208\188\208\176\209\130\208\181\209\128\208\184 / \208\181\208\177\208\176\208\189\208\176\209\130", 
        [4] = "\208\176\208\187\208\187\208\176\209\133 \208\176\208\186\208\177\208\176\209\128 / \208\189\208\190 \208\187\208\190\208\186\208\176\208\187\209\140\208\189\208\190", 
        [5] = "\208\177\208\176\209\133\208\189\209\131\208\187\208\190 \208\186\208\176\208\186 \208\189\208\176\208\180\208\190 / \208\186\209\128\208\190\208\178\209\140 \208\180\208\176 \208\186\208\184\209\136\208\186\208\184"
    }, 
    death = {
        [1] = "\209\135\209\130\208\190 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187 / \208\177\208\181\208\183\208\188\208\190\208\183\208\179\208\187\209\139\208\185", 
        [2] = "\208\189\208\181 \208\191\208\190\208\178\208\181\208\183\208\187\208\190", 
        [3] = "\208\189\209\131 \209\132\209\131 / \209\135\209\130\208\190 \209\130\209\139 \208\180\208\181\208\187\208\176\208\181\209\136\209\140", 
        [4] = "only luck in this game", 
        [5] = "\209\133\209\131\209\143 \208\188\208\181\208\189\209\143 \208\191\208\184\208\189\208\179\208\176\208\189\209\131\208\187\208\190 \208\182\208\190\209\129\208\186\208\190", 
        [6] = "\208\157\208\149\208\162 / \208\158\208\157\208\158 \208\150\208\149 \208\159\208\149\208\160\208\149\208\159\208\152\208\154\208\144\208\149\208\162", 
        [7] = "\209\135\208\188\208\190 \208\181\208\177\208\176\208\189\208\190\208\181 / 5\209\1335 \208\189\208\176 2\208\186 \208\181\208\178\209\128\208\190 \209\129\208\187\208\181\209\130\208\176\208\181\208\188 \209\129\209\129\208\176\208\189\209\139\208\185 \208\188\209\131\209\129\208\190\209\128?", 
        [8] = "\208\189\209\131 \208\190\209\130\208\187\208\184\209\135\208\189\208\190 / \208\190\208\191\209\143\209\130\209\140 \208\178 \208\180\208\181\208\183 \208\188\208\184\209\129\209\129\208\189\209\131\208\187", 
        [9] = "\209\129\208\181\209\128\208\178\208\181\209\128 \208\186\208\190\208\191\208\181\208\181\209\135\208\189\209\139\208\185 / \208\189\209\131 \208\183\208\176\209\130\208\190 \209\131 \208\191\208\184\208\180\208\190\209\128\208\176\209\129\208\176 \209\130\209\131\209\130 \209\129\209\130\209\128\208\181\208\187\209\143\208\181\209\130", 
        [10] = "F][SD[]FSD][FD[]FSD[]] / \209\133\209\131\208\181\209\129\208\190\209\129\209\131 \208\190\208\191\209\143\209\130\209\140 \208\191\208\190\208\178\208\181\208\183\208\187\208\190", 
        [11] = "\209\132\209\131 / \209\131\208\177\208\187\209\142\208\180\208\190\208\186 \209\135\209\130\208\190 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187 \208\178 \208\190\209\135\208\181\209\128\208\181\208\180\208\189\208\190\208\185 \209\128\208\176\208\183", 
        [12] = "\208\181\208\177\208\176\208\189\209\139\208\185 \209\129\208\190\209\135\208\189\208\184\208\186 / \208\189\209\131 \208\189\208\184\209\135\208\181 \208\178 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\181\208\188 \209\128\208\176\209\131\208\189\208\180\208\181 \208\178 \208\191\208\184\209\129\209\140\208\186\209\131 \208\180\209\131\208\189\208\181\209\136\209\140", 
        [13] = "\209\130\208\176\208\186 \208\180\208\181\209\128\208\182\208\176\209\130\209\140 / \209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184 \208\181\208\177\208\176\208\189\209\139\208\185", 
        [14] = "\208\189\208\176 \208\191\208\190\208\180\208\191\208\184\208\186\208\181 / \208\184\208\180\208\184 \208\189\208\176\209\133\209\131\208\185"
    }
};
v773 = nil;
v774 = false;
do
    local l_v772_2, l_v773_3, l_v774_3, l_v775_3, l_v802_2 = v772, v773, v774, v775, v802;
    l_v775_3 = function(v951)
        -- upvalues: l_v772_2 (ref), l_v773_3 (ref)
        local v952 = l_v772_2[v951];
        if not v952 then
            return nil;
        else
            local v953 = #v952;
            if v953 == 0 then
                return nil;
            else
                local v954 = nil;
                local v955 = 0;
                while v955 < v953 do
                    v954 = v952[utils.random_int(1, v953)];
                    if v954 ~= l_v773_3 then
                        l_v773_3 = v954;
                        break;
                    else
                        v955 = v955 + 1;
                    end;
                end;
                local v956;
                if v954 then
                    v956 = string.split(v954, " / ");
                else
                    v956 = v954;
                end;
                return v956;
            end;
        end;
    end;
    l_v802_2 = function(v957)
        -- upvalues: l_v774_3 (ref)
        l_v774_3 = true;
        local v958 = 0;
        for _, v960 in ipairs(v957) do
            v958 = v958 + string.proper_len(v960) / 7;
            do
                local l_v960_0 = v960;
                utils.execute_after(v958, function()
                    -- upvalues: l_v960_0 (ref)
                    utils.console_exec("say " .. l_v960_0);
                end);
            end;
        end;
        utils.execute_after(v958, function()
            -- upvalues: l_v774_3 (ref)
            l_v774_3 = false;
        end);
    end;
    v72.Trashtalk.player_death:set(function(v962, v963, _)
        -- upvalues: v147 (ref), l_v774_3 (ref), l_v772_2 (ref), l_v775_3 (ref), l_v802_2 (ref)
        if not v147.trashtalk or l_v774_3 then
            return;
        else
            local v965 = entity.get_game_rules();
            if not v965 or v965.m_bWarmupPeriod then
                return;
            else
                local v966 = entity.get(v962.userid, true);
                local v967 = entity.get(v962.attacker, true);
                if not v966 or not v967 then
                    return;
                else
                    local v968 = nil;
                    if v147.trashtalk_revenge then
                        if v966 == v963 and v967:is_enemy() then
                            killer_index = v967:get_index();
                        end;
                        if v966:get_index() == killer_index then
                            utils.execute_after(0.4, utils.console_exec, "say 1");
                            killer_index = nil;
                        end;
                    end;
                    if v967 == v963 and v966:is_enemy() then
                        v968 = v962.headshot and "head" or "body";
                        if l_v772_2[v962.weapon] ~= nil then
                            v968 = v962.weapon;
                        end;
                    end;
                    if v966 == v963 and v967:is_enemy() then
                        v968 = "death";
                    end;
                    if not v968 then
                        return;
                    else
                        local v969 = l_v775_3(v968);
                        if not v969 then
                            return;
                        else
                            l_v802_2(v969);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end);
    v72.Trashtalk.round_start:set(function()
        -- upvalues: l_v773_3 (ref)
        killer_index = nil;
        l_v773_3 = nil;
    end);
end;
v772 = nil;
v773 = {
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
v774 = {
    knife = "Knifed ", 
    hegrenade = "Naded ", 
    inferno = "Burned "
};
do
    local l_v773_4, l_v774_4 = v773, v774;
    v72["Event Logs"].player_hurt:set(function(v972, v973, _)
        -- upvalues: v147 (ref), l_v774_4 (ref), v57 (ref), v150 (ref), v148 (ref)
        if not v147.event_logger or not table.contains(v147.event_logger_events, "Damage Dealt") then
            return;
        else
            local v975 = entity.get(v972.userid, true);
            local v976 = entity.get(v972.attacker, true);
            if v975 == nil or v975 == v973 or v976 ~= v973 then
                return;
            elseif not l_v774_4[v972.weapon] then
                return;
            else
                local l_event_logger_clr_0 = v147.event_logger_clr;
                l_event_logger_clr_0.a = 255;
                local v978 = {
                    [1] = nil, 
                    [2] = nil, 
                    [3] = nil, 
                    [4] = "for ", 
                    [5] = nil, 
                    [6] = "damage (", 
                    [7] = nil, 
                    [8] = "remaining)", 
                    [1] = string.format("\v%s \a808080FF\194\183 \aDEFAULT", v57.label), 
                    [2] = string.format("%s", l_v774_4[v972.weapon]), 
                    [3] = string.format("\v%s\r ", v975:get_name() or "unknown"), 
                    [5] = string.format("\v%d\r ", v972.dmg_health or 0), 
                    [7] = string.format("\v%d\r ", v972.health or 0)
                };
                v150.add(5, string.format("\a%s%s \aDEFAULT%s\a%s%s\aDEFAULT for \a%s%d \aDEFAULTdamage", l_event_logger_clr_0:to_hex(), ui.get_icon("check"), l_v774_4[v972.weapon], l_event_logger_clr_0:to_hex(), v975:get_name(), l_event_logger_clr_0:to_hex(), v972.dmg_health), l_event_logger_clr_0);
                v148.print(false, v148.format(table.concat(v978, ""), l_event_logger_clr_0));
                return;
            end;
        end;
    end);
    v72["Event Logs"].item_purchase:set(function(v979, _, _)
        -- upvalues: v147 (ref), v57 (ref), v150 (ref), v148 (ref)
        if not v147.event_logger or not table.contains(v147.event_logger_events, "Purchases") then
            return;
        else
            local l_weapon_0 = v979.weapon;
            if l_weapon_0 == nil or l_weapon_0 == "weapon_unknown" then
                return;
            else
                local v983 = entity.get(v979.userid, true);
                if v983 == nil or not v983:is_enemy() then
                    return;
                else
                    local l_event_logger_clr_1 = v147.event_logger_clr;
                    l_event_logger_clr_1.a = 255;
                    l_weapon_0 = l_weapon_0:gsub("weapon_", ""):gsub("item_", "");
                    local v985 = {
                        nil, 
                        nil, 
                        "bought ", 
                        [1] = string.format("\v%s \a808080FF\194\183 \aDEFAULT", v57.label), 
                        [2] = string.format("\v%s\r ", v983:get_name() or "unknown"), 
                        string.format("\v%s", l_weapon_0)
                    };
                    v150.add(5, string.format("\a%s%s %s \aDEFAULTbought \a%s%s", l_event_logger_clr_1:to_hex(), ui.get_icon("cart-shopping"), v983:get_name(), l_event_logger_clr_1:to_hex(), l_weapon_0), l_event_logger_clr_1);
                    v148.print(false, v148.format(table.concat(v985, ""), l_event_logger_clr_1));
                    return;
                end;
            end;
        end;
    end);
    v72["Event Logs"].aim_ack:set(function(v986, _)
        -- upvalues: v147 (ref), v57 (ref), l_v773_4 (ref), v150 (ref), v148 (ref)
        if not v147.event_logger or not table.contains(v147.event_logger_events, "Aimbot Shots") then
            return;
        else
            local l_target_0 = v986.target;
            if l_target_0 == nil then
                return;
            elseif v986.state then
                if v986.state == "correction" then
                    v986.state = "resolver";
                end;
                local l_event_logger_miss_clr_0 = v147.event_logger_miss_clr;
                l_event_logger_miss_clr_0.a = 255;
                local v990 = {
                    [1] = nil, 
                    [2] = "Missed ", 
                    [3] = nil, 
                    [4] = "'s ", 
                    [5] = nil, 
                    [6] = "(", 
                    [7] = nil, 
                    [8] = ") ", 
                    [9] = "due to ", 
                    [10] = nil, 
                    [11] = "(", 
                    [12] = nil, 
                    [13] = ") (", 
                    [14] = nil, 
                    [15] = "\194\176, bt: ", 
                    [16] = nil, 
                    [17] = ")", 
                    [1] = string.format("\v%s \a808080FF\194\183 \aDEFAULT", v57.label), 
                    [3] = string.format("\v%s\r", l_target_0:get_name() or "unknown"), 
                    [5] = string.format("\v%s\r", l_v773_4[v986.wanted_hitgroup] or "generic"), 
                    [7] = string.format("\v%d\r", v986.wanted_damage or 0), 
                    [10] = string.format("\v%s\r ", v986.state), 
                    [12] = string.format("\v%d%%\r", v986.hitchance or 0), 
                    [14] = string.format("\v%.2f\r", v986.spread or 0), 
                    [16] = string.format("\v%d\r", v986.backtrack or 0)
                };
                v150.add(5, string.format("\a%s%s \aDEFAULTMissed at \a%s%s\aDEFAULT due to \a%s%s", l_event_logger_miss_clr_0:to_hex(), ui.get_icon("xmark"), l_event_logger_miss_clr_0:to_hex(), l_target_0:get_name(), l_event_logger_miss_clr_0:to_hex(), v986.state), l_event_logger_miss_clr_0);
                v148.print(false, v148.format(table.concat(v990, ""), l_event_logger_miss_clr_0));
                return;
            else
                local v991 = v986.wanted_damage - v986.damage > 0;
                local v992 = v986.hitgroup ~= v986.wanted_hitgroup;
                local l_event_logger_clr_2 = v147.event_logger_clr;
                l_event_logger_clr_2.a = 255;
                local v994 = {
                    [1] = nil, 
                    [2] = "Hit ", 
                    [3] = nil, 
                    [4] = "'s ", 
                    [5] = nil, 
                    [6] = "for ", 
                    [7] = nil, 
                    [8] = nil, 
                    [9] = nil, 
                    [10] = nil, 
                    [11] = nil, 
                    [12] = nil, 
                    [13] = nil, 
                    [14] = "(", 
                    [15] = nil, 
                    [16] = ") ", 
                    [17] = "(", 
                    [18] = nil, 
                    [19] = "\194\176, bt: ", 
                    [20] = nil, 
                    [21] = ")", 
                    [1] = string.format("\v%s \a808080FF\194\183 \aDEFAULT", v57.label), 
                    [3] = string.format("\v%s\r", l_target_0:get_name()), 
                    [5] = string.format("\v%s\r ", l_v773_4[v986.hitgroup] or "generic"), 
                    [7] = string.format("\v%d\r", v986.damage or 0), 
                    [8] = v991 and "(" or "", 
                    [9] = v991 and string.format("\v%d\r", v986.wanted_damage or 0) or "", 
                    [10] = v991 and ") damage " or " damage ", 
                    [11] = v992 and "(aimed:" or "", 
                    [12] = v992 and string.format("\v%s\r", l_v773_4[v986.wanted_hitgroup]) or "", 
                    [13] = v992 and ")" or "", 
                    [15] = string.format("\v%d%%\r", v986.hitchance or 0), 
                    [18] = string.format("\v%.2f\r", v986.spread or 0), 
                    [20] = string.format("\v%d\r", v986.backtrack or 0)
                };
                v150.add(5, string.format("\a%s%s \aDEFAULTHit \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT for \a%s%d \aDEFAULTdamage", l_event_logger_clr_2:to_hex(), ui.get_icon("check"), l_event_logger_clr_2:to_hex(), l_target_0:get_name(), l_event_logger_clr_2:to_hex(), l_v773_4[v986.hitgroup], l_event_logger_clr_2:to_hex(), v986.damage), l_event_logger_clr_2);
                v148.print(false, v148.format(table.concat(v994, ""), l_event_logger_clr_2));
                return;
            end;
        end;
    end);
end;
v773 = nil;
v774 = {};
v775 = 16;
v802 = {
    stomach = 2
};
local function v995()
    -- upvalues: v60 (ref)
    v60.RAGE.aimbot.hitboxes:override();
end;
local function v1007(v996, v997, v998)
    local l_tickinterval_1 = globals.tickinterval;
    local v1000 = cvar.sv_gravity:float() * l_tickinterval_1;
    local v1001 = cvar.sv_jump_impulse:float() * l_tickinterval_1;
    local l_v997_0 = v997;
    local l_v997_1 = v997;
    local l_m_vecVelocity_1 = v996.m_vecVelocity;
    local v1005 = l_m_vecVelocity_1.z > 0 and -v1000 or v1001;
    for _ = 1, v998 do
        l_v997_1 = l_v997_0;
        l_v997_0 = vector(l_v997_0.x + l_m_vecVelocity_1.x * l_tickinterval_1, l_v997_0.y + l_m_vecVelocity_1.y * l_tickinterval_1, l_v997_0.z + (l_m_vecVelocity_1.z + v1005) * l_tickinterval_1);
        if utils.trace_line(l_v997_1, l_v997_0, v996).fraction <= 0.99 then
            return l_v997_1;
        end;
    end;
    return l_v997_0;
end;
do
    local l_v774_5, l_v775_4, l_v802_3, l_v995_0, l_v1007_0 = v774, v775, v802, v995, v1007;
    local function v1043(v1013)
        -- upvalues: l_v774_5 (ref), v60 (ref), l_v1007_0 (ref), l_v775_4 (ref), l_v802_3 (ref)
        l_v774_5 = {};
        local v1014 = entity.get_local_player();
        if v1014 == nil or not v1014:is_alive() then
            return;
        else
            local v1015 = v1014:get_player_weapon();
            if v1015 == nil then
                return;
            else
                local l_m_iClip1_0 = v1015.m_iClip1;
                local v1017 = v1015:get_weapon_info();
                if l_m_iClip1_0 == -1 or v1017 == nil then
                    return;
                else
                    local v1018 = l_m_iClip1_0 >= 2 and 1 / v1017.cycle_time > 2;
                    local v1019 = 1;
                    if v60.RAGE.aimbot.double_tap.main:get() and rage.exploit:get() == 1 and v1018 then
                        v1019 = 2;
                    end;
                    local v1020 = {
                        [1] = v1014
                    };
                    for _, v1022 in pairs(entity.get_players()) do
                        if not v1022:is_enemy() then
                            table.insert(v1020, v1022);
                        end;
                    end;
                    local v1023 = v1014:get_origin();
                    entity.get_players(true, false, function(v1024)
                        -- upvalues: v1023 (ref), v1017 (ref), v1019 (ref), l_v774_5 (ref)
                        if not v1024:is_alive() then
                            return;
                        elseif v1024:is_dormant() then
                            return;
                        else
                            local v1025 = v1024:get_resource();
                            if not v1025 then
                                return;
                            else
                                local l_m_iArmor_0 = v1025.m_iArmor;
                                local l_m_iHealth_0 = v1024.m_iHealth;
                                local v1028 = (v1023 - v1024:get_eye_position()):length();
                                local v1029 = v1017.damage * 1.25 * math.pow(v1017.range_modifier, v1028 * 0.002);
                                if l_m_iArmor_0 > 0 then
                                    v1029 = v1029 * v1017.armor_ratio * 0.5;
                                end;
                                if l_m_iHealth_0 <= math.ceil(v1029) * v1019 then
                                    l_v774_5[v1024:get_index()] = true;
                                end;
                                return;
                            end;
                        end;
                    end);
                    return ((function(v1030)
                        -- upvalues: v1014 (ref), l_v1007_0 (ref), l_v775_4 (ref), l_v802_3 (ref), v1020 (ref), v1019 (ref)
                        if not v1030 or not v1030:is_alive() then
                            return;
                        else
                            local v1031 = v1014:get_eye_position();
                            local l_m_iHealth_1 = v1030.m_iHealth;
                            local v1033 = l_v1007_0(v1014, v1031, l_v775_4);
                            local v1034 = 0;
                            for _, v1036 in pairs(l_v802_3) do
                                local v1037 = v1030:get_hitbox_position(v1036);
                                local v1038 = l_v1007_0(v1030, v1037, l_v775_4);
                                local v1039 = utils.trace_bullet(v1014, v1031, v1037, v1020);
                                if v1034 < v1039 then
                                    v1034 = v1039;
                                end;
                                local v1040 = utils.trace_bullet(v1014, v1031, v1038, v1020);
                                if v1034 < v1040 then
                                    v1034 = v1040;
                                end;
                                local v1041 = utils.trace_bullet(v1014, v1033, v1037, v1020);
                                if v1034 < v1041 then
                                    v1034 = v1041;
                                end;
                                local v1042 = utils.trace_bullet(v1014, v1033, v1038, v1020);
                                if v1034 < v1042 then
                                    v1034 = v1042;
                                end;
                            end;
                            if l_m_iHealth_1 <= v1034 * v1019 then
                                return math.ceil(v1034 - 0.5);
                            else
                                return;
                            end;
                        end;
                    end)(v1013));
                end;
            end;
        end;
    end;
    local function v1046()
        -- upvalues: v1043 (ref), v60 (ref)
        local v1044 = entity.get_threat();
        local v1045 = v1043(v1044);
        if v1044 == nil or v1044:is_dormant() or not v1045 or v1045 == 0 then
            return;
        else
            v60.RAGE.aimbot.hitboxes:override("Stomach");
            return true;
        end;
    end;
    v72["Lethal Baim"].net_update_end:set(function(_, v1048)
        -- upvalues: v147 (ref), l_v995_0 (ref), v1046 (ref)
        if not v147.baim_lethal or not v1048 then
            l_v995_0();
            return;
        elseif not v1046() then
            return l_v995_0();
        else
            return;
        end;
    end);
    esp.enemy:new_text(string.format("(%s) Baimable", v57.label:upper()), "BAIM", function(v1049)
        -- upvalues: l_v774_5 (ref)
        if l_v774_5[v1049:get_index()] then
            return "BAIM";
        else
            return;
        end;
    end);
end;
v774 = nil;
v775 = {
    ["Auto Snipers"] = {
        [1] = 38, 
        [2] = 11
    }, 
    Pistols = {
        [1] = 4, 
        [2] = 63, 
        [3] = 36, 
        [4] = 3, 
        [5] = 1, 
        [6] = 64, 
        [7] = 2, 
        [8] = 30, 
        [9] = 61, 
        [10] = 32
    }, 
    Scout = {
        [1] = 40
    }, 
    AWP = {
        [1] = 9
    }, 
    Taser = {
        [1] = 31
    }
};
v802 = cvar.sv_gravity;
v995 = 0;
v1007 = 0;
do
    local l_v775_5, l_v995_1, l_v1007_1 = v775, v995, v1007;
    v72["Automatic Teleport"].createmove:set(function(_, v1054, v1055)
        -- upvalues: v147 (ref), v58 (ref), l_v775_5 (ref), v148 (ref), l_v995_1 (ref), l_v1007_1 (ref)
        if not v147.automatic_tp or #v147.automatic_tp_weapons == 0 or not v1055 then
            return rage.exploit:allow_charge(true);
        elseif v58.onground or v58.velocity < 100 then
            return;
        elseif rage.exploit:get() ~= 1 then
            return;
        else
            local v1056 = entity.get_threat();
            if v1056 == nil then
                return;
            else
                local v1057 = v1054:get_player_weapon();
                if v1057 == nil then
                    return;
                else
                    local v1058 = v1057:get_weapon_index();
                    local v1059 = false;
                    local v1060 = false;
                    for _, v1062 in ipairs(v147.automatic_tp_weapons) do
                        local v1063 = l_v775_5[v1062];
                        if v1063 then
                            for _, v1065 in ipairs(v1063) do
                                if v1065 == v1058 then
                                    v1059 = true;
                                    break;
                                end;
                            end;
                        elseif v1062 == "Knife" then
                            v1060 = true;
                        end;
                    end;
                    if not v1059 and v1060 and v1057:get_classid() == 107 then
                        v1059 = true;
                    end;
                    if not v1059 then
                        return;
                    else
                        local v1066 = v1056:get_resource();
                        if not v1066 then
                            return;
                        else
                            local l_m_iPing_0 = v1066.m_iPing;
                            local v1068 = math.max(5, to_ticks(l_m_iPing_0 * (l_m_iPing_0 <= 10 and 2 or 1.75) / 1000));
                            local v1069 = v1056:get_hitbox_position(4);
                            local v1070 = v1054:get_hitbox_position(4);
                            local v1071, v1072 = utils.trace_bullet(v1056, v1069, v148.extrapolate(v1054, v1068, v1070));
                            local v1073;
                            if not v1071 or v1071 <= 0 then
                                v1073 = false;
                            elseif not v1072.entity or v1072.entity:get_classname() == "CWorld" then
                                v1073 = false;
                            else
                                v1073 = true;
                            end;
                            if v1073 and l_v995_1 < globals.realtime then
                                if l_v1007_1 == v147.automatic_tp_delay then
                                    l_v995_1 = globals.realtime + 0.5;
                                    rage.exploit:force_teleport();
                                    rage.exploit:allow_charge(false);
                                    l_v1007_1 = 0;
                                end;
                                l_v1007_1 = l_v1007_1 + 1;
                            else
                                rage.exploit:allow_charge(true);
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end);
end;
v775 = nil;
v775 = {};
v802 = {};
do
    local l_v802_4 = v802;
    v775.get = function(v1075)
        -- upvalues: l_v802_4 (ref)
        local v1076 = l_v802_4[v1075];
        return v1076 ~= nil and v1076.active;
    end;
    v775.is_any_active = false;
    v72["Update Hotkeys"].render:set(function()
        -- upvalues: l_v802_4 (ref), v775 (ref)
        l_v802_4 = {};
        v775.is_any_active = false;
        local v1077 = ui.get_binds();
        for v1078 = 1, #v1077 do
            local v1079 = v1077[v1078];
            if v1079.active then
                v775.is_any_active = true;
            end;
            l_v802_4[v1079.name] = v1079;
        end;
    end);
end;
v802 = nil;
v802 = {
    alpha = v73:new(), 
    allign = v73:new(), 
    state = v73:new(), 
    glow = v73:new(), 
    blind = v73:new(), 
    modern = v73:new(), 
    stylish = v73:new()
};
v995 = {
    [1] = {
        get_text = function()
            -- upvalues: v58 (ref)
            return math.floor(v58.velocity_modifier * 100) .. "%";
        end, 
        condition = function()
            -- upvalues: v58 (ref)
            return v58.velocity_modifier ~= 1;
        end, 
        anim = v73:new()
    }, 
    [2] = {
        text = "PING", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.MISC.fake_latency:get() ~= 0;
        end, 
        anim = v73:new()
    }, 
    [3] = {
        text = "DT", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.aimbot.double_tap.main:get();
        end, 
        color = function()
            -- upvalues: v57 (ref)
            return color(255, 25, 25):lerp(v57.colors.white, rage.exploit:get());
        end, 
        anim = v73:new()
    }, 
    [4] = {
        text = "OS", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.aimbot.hide_shots.main:get();
        end, 
        anim = v73:new()
    }, 
    [5] = {
        text = "FS", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.AA.angles.freestanding:get();
        end, 
        anim = v73:new()
    }, 
    [6] = {
        text = "DMG", 
        condition = function()
            -- upvalues: v775 (ref)
            return v775.get("Min. Damage");
        end, 
        anim = v73:new()
    }, 
    [7] = {
        text = "HC", 
        condition = function()
            -- upvalues: v775 (ref)
            return v775.get("Hit Chance");
        end, 
        anim = v73:new()
    }, 
    [8] = {
        text = "BAIM", 
        condition = function()
            -- upvalues: v60 (ref)
            local v1080 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers"):get();
            return v60.RAGE.other.body_aim:get() == "Force" and #v1080 == 0;
        end, 
        anim = v73:new()
    }, 
    [9] = {
        text = "SAFE", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.other.safe_point:get() == "Force";
        end, 
        anim = v73:new()
    }, 
    [10] = {
        text = "DUCK", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.AA.other.fake_duck:get();
        end, 
        anim = v73:new()
    }
};
v1007 = {
    [1] = {
        get_text = function()
            -- upvalues: v58 (ref)
            return string.format("velocity: %d%%", math.floor(v58.velocity_modifier * 100));
        end, 
        condition = function()
            -- upvalues: v58 (ref)
            return v58.velocity_modifier ~= 1;
        end, 
        anim = v73:new()
    }, 
    [2] = {
        text = "safe", 
        condition = function()
            -- upvalues: v57 (ref)
            return v57.functions.safe_head;
        end, 
        anim = v73:new()
    }, 
    [3] = {
        text = "spike", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.MISC.fake_latency:get() ~= 0;
        end, 
        anim = v73:new()
    }, 
    [4] = {
        text = "doubletap", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.aimbot.double_tap.main:get();
        end, 
        color = function()
            -- upvalues: v57 (ref)
            return color(255, 25, 25):lerp(v57.colors.white, rage.exploit:get());
        end, 
        anim = v73:new()
    }, 
    [5] = {
        text = "onshot", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.aimbot.hide_shots.main:get();
        end, 
        anim = v73:new()
    }, 
    [6] = {
        text = "freestand", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.AA.angles.freestanding:get();
        end, 
        anim = v73:new()
    }, 
    [7] = {
        text = "damage", 
        condition = function()
            -- upvalues: v775 (ref)
            return v775.get("Min. Damage");
        end, 
        anim = v73:new()
    }, 
    [8] = {
        text = "hitchance", 
        condition = function()
            -- upvalues: v775 (ref)
            return v775.get("Hit Chance");
        end, 
        anim = v73:new()
    }, 
    [9] = {
        text = "bodyaim", 
        condition = function()
            -- upvalues: v60 (ref)
            local v1081 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers"):get();
            return v60.RAGE.other.body_aim:get() == "Force" and #v1081 == 0;
        end, 
        anim = v73:new()
    }, 
    [10] = {
        text = "safepoint", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.RAGE.other.safe_point:get() == "Force";
        end, 
        anim = v73:new()
    }, 
    [11] = {
        text = "duck", 
        condition = function()
            -- upvalues: v60 (ref)
            return v60.AA.other.fake_duck:get();
        end, 
        anim = v73:new()
    }
};
local v1082 = v56("Tahoma", vector(11, 10.5), "abd");
do
    local l_v995_2, l_v1007_2, l_v1082_0 = v995, v1007, v1082;
    local function v1109(v1086, v1087)
        -- upvalues: v802 (ref), v147 (ref), v57 (ref), v58 (ref), l_v995_2 (ref)
        if v1087 <= 0 then
            return;
        else
            local v1088 = math.max(0.2, math.abs(math.sin(globals.realtime * 2.5)));
            local v1089 = v802.allign(0.1, not v1086 or not v1086.m_bIsScoped or not v147.crosshair_indicators_align);
            local v1090 = 1;
            local v1091 = v1086 and v1086:get_player_weapon() or false;
            if v1091 then
                local v1092 = v1091:get_weapon_info();
                v1090 = v802.blind(0.075, v1092.weapon_type == 9 and 0.3 or 1);
            end;
            v1091 = v57.colors.white:alpha_modulate(v1087 * v1090, true);
            local v1093 = v147.crosshair_indicators_clr2:alpha_modulate(255 * v1087 * v1090);
            local v1094 = v147.crosshair_indicators_clr:alpha_modulate(255 * v1087 * v1088 * v1090);
            local v1095 = render.screen_size();
            v1095.x = v1095.x * 0.5 + (1 - v1089);
            v1095.y = v1095.y * 0.5 + 20;
            local v1096 = string.format("%s \a%s%s", "XO-YAW", v1094:to_hex(), v57.version:upper());
            local v1097 = render.measure_text(2, "s", v1096);
            local v1098 = v1095:clone();
            v1098.x = v1098.x - v1097.x * 0.5 * v1089;
            local v1099 = v802.glow(0.2, v147.crosshair_indicators_glow);
            if v1099 > 0.01 then
                render.shadow(vector(v1098.x + 2, v1098.y + 7), vector(v1098.x + v1097.x - 4, v1098.y + 7), v1094:alpha_modulate(v1099, true), 20, 0, 0);
            end;
            render.text(2, v1098, v1091, "s", v1096);
            v1095.y = v1095.y + (v1097.y - 4);
            v1097 = string.upper(v57.functions.safe_head and "SAFE" or v58.condition);
            v1098 = render.measure_text(2, "s", v1097);
            v1099 = v802.state(0.1, v1098.x);
            if v1098.x < v1099 then
                v1099 = v1098.x;
            end;
            local v1100 = v1095:clone();
            v1100.x = v1100.x - v1099 * 0.5 * v1089;
            local v1101 = vector(v1099, v1098.y);
            render.push_clip_rect(v1100, v1100 + v1101);
            render.text(2, v1100, v1093, "s", v1097);
            render.pop_clip_rect();
            v1095.y = v1095.y + (v1098.y - 4);
            v1098 = 0;
            for _, v1103 in pairs(l_v995_2) do
                local v1104 = v1103.anim(0.1, v1103.condition());
                if v1104 > 0.01 then
                    local v1105 = v1103.text or v1103.get_text();
                    local v1106 = v1103.color and v1103.color() or v57.colors.white;
                    local v1107 = render.measure_text(2, "s", v1105);
                    local v1108 = v1095:clone();
                    v1108.x = v1108.x - v1107.x * 0.5 * v1089;
                    v1108.y = v1108.y + v1098;
                    render.text(2, v1108, v1106:alpha_modulate(v1087 * v1104 * v1090, true), "s", v1105);
                    v1098 = v1098 + (v1107.y - 4) * v1104;
                end;
            end;
            return;
        end;
    end;
    local function v1132(v1110, v1111)
        -- upvalues: v802 (ref), v147 (ref), l_v1082_0 (ref), v75 (ref), l_v1007_2 (ref), v57 (ref)
        if v1111 <= 0 then
            return;
        else
            local v1112 = v802.allign(0.1, not v1110 or not v1110.m_bIsScoped or not v147.crosshair_indicators_align);
            local v1113 = 1;
            local v1114 = v1110 and v1110:get_player_weapon() or false;
            if v1114 then
                local v1115 = v1114:get_weapon_info();
                v1113 = v802.blind(0.075, v1115.weapon_type == 9 and 0.3 or 1);
            end;
            v1114 = v147.crosshair_indicators_clr:alpha_modulate(255 * v1111 * v1113);
            local v1116 = v147.crosshair_indicators_clr2:alpha_modulate(255 * v1111 * v1113);
            local v1117 = render.screen_size();
            v1117.x = v1117.x * 0.5 + (1 - v1112);
            v1117.y = v1117.y * 0.5 + 20;
            local v1118 = "XO-YAW";
            v1118 = string.wave("xo-yaw.lua\194\176", v1114, v1116, v147.crosshair_indicators_anim_speed / 10);
            local v1119 = render.measure_text(l_v1082_0, "s", v1118);
            local v1120 = v1117:clone();
            v1120.x = v1120.x - v1119.x * 0.5 * v1112;
            local v1121 = v802.glow(0.2, v147.crosshair_indicators_glow);
            if v1121 > 0.01 then
                local v1122 = v1114:lerp(v1116, v75(0.5, v147.crosshair_indicators_anim_speed / 10));
                render.shadow(vector(v1120.x + 2, v1120.y + 7), vector(v1120.x + v1119.x - 4, v1120.y + 7), v1122:alpha_modulate(v1121 * v1111, true), 20, 0, 0);
            end;
            render.text(l_v1082_0, v1120, v1114, "s", v1118);
            v1117.y = v1117.y + v1119.y * 0.9;
            v1119 = 0;
            for _, v1124 in pairs(l_v1007_2) do
                local v1125 = v1124.anim(0.15, v1124.condition());
                if v1125 > 0.01 then
                    local v1126 = v1124.text or v1124.get_text();
                    local v1127 = v1124.color and v1124.color() or v57.colors.white;
                    local v1128 = render.measure_text(1, "s", v1126);
                    local v1129 = v1128.x * v1125;
                    local v1130 = v1117:clone();
                    v1130.x = v1130.x - v1129 * 0.5 * v1112;
                    v1130.y = v1130.y + v1119;
                    local v1131 = vector(v1129, v1128.y);
                    render.push_clip_rect(v1130, v1130 + v1131);
                    render.text(1, v1130, v1127:alpha_modulate(v1111 * v1125 * v1113, true), "s", v1126);
                    render.pop_clip_rect();
                    v1119 = v1119 + (v1128.y - 2) * v1125;
                end;
            end;
            return;
        end;
    end;
    v72["Crosshair Indicators"].render:set(function(v1133, v1134)
        -- upvalues: v802 (ref), v147 (ref), v1109 (ref), v1132 (ref)
        local v1135 = v802.alpha(0.2, v147.crosshair_indicators and v1134);
        if v1135 <= 0 then
            return;
        else
            local l_crosshair_indicators_type_0 = v147.crosshair_indicators_type;
            local v1137 = v802.modern(0.2, l_crosshair_indicators_type_0 == "Modern");
            if v1137 > 0.01 then
                v1109(v1133, v1135 * v1137);
            end;
            local v1138 = v802.stylish(0.2, l_crosshair_indicators_type_0 == "Stylish");
            if v1138 > 0.01 then
                v1132(v1133, v1135 * v1138);
            end;
            return;
        end;
    end);
end;
v995 = nil;
v995 = {
    alpha = v73:new(), 
    scope = v73:new(), 
    right = v73:new(), 
    left = v73:new()
};
v1007 = v56("Tahoma", 25, "ab");
do
    local l_v1007_3 = v1007;
    v72["Manual Arrows"].render:set(function(v1140, v1141)
        -- upvalues: v995 (ref), v147 (ref), l_v1007_3 (ref), v57 (ref)
        local v1142 = v995.alpha(0.2, v147.manual_arrows and v1141);
        if v1142 <= 0 then
            return;
        else
            local v1143 = v995.scope(0.075, v1140 and not v1140.m_bIsScoped or false);
            if v1143 <= 0 then
                return;
            else
                local v1144 = v147.manual_arrows_clr:alpha_modulate(255);
                local l_manual_arrows_clr2_0 = v147.manual_arrows_clr2;
                local v1146 = l_manual_arrows_clr2_0:lerp(v1144, v995.left(0.2, v147.manual_yaw == "Left"));
                local v1147 = l_manual_arrows_clr2_0:lerp(v1144, v995.right(0.2, v147.manual_yaw == "Right"));
                render.text(l_v1007_3, vector(v57.screen_center.x - 53, v57.screen_center.y - 12), v1146:alpha_modulate(v1142 * v1143, true), "b", "\226\128\185");
                render.text(l_v1007_3, vector(v57.screen_center.x + 43, v57.screen_center.y - 12), v1147:alpha_modulate(v1142 * v1143, true), "b", "\226\128\186");
                return;
            end;
        end;
    end);
end;
v1007 = nil;
v1007 = {
    alpha = v73:new(), 
    number = v73:new()
};
v1082 = v74.add("Damage Indicator", vector(v57.screen_center.x + 5, v57.screen_center.y - 22), vector(20, 20));
do
    local l_v1082_1 = v1082;
    v72["Damage Indicator"].render:set(function(_, v1150)
        -- upvalues: v1007 (ref), v147 (ref), l_v1082_1 (ref), v57 (ref), v60 (ref)
        local v1151 = v1007.alpha(0.2, v147.damage_indicator and v1150);
        if v1151 <= 0 then
            return;
        else
            l_v1082_1:process();
            if l_v1082_1.is_in_b and l_v1082_1.is_rmb_pressed and v57.menu_alpha > 0 then
                l_v1082_1.position = vector(v57.screen_center.x + 5, v57.screen_center.y - 22);
            end;
            local v1152 = v60.RAGE.other.min_damage:get();
            local v1153 = v1007.number(0.045, v1152);
            local v1154 = v1153 == 0 and "AUTO" or math.floor(v1153);
            if v57.menu_alpha > 0.01 then
                v1154 = "DMG";
                local v1155 = render.measure_text(2, "s", v1154);
                render.rect_outline(l_v1082_1.position, l_v1082_1.position + l_v1082_1.size, v57.colors.white:alpha_modulate(v1151 * v57.menu_alpha, true), 1, 3);
                l_v1082_1.size = v1155 + 5;
            end;
            render.text(2, vector(l_v1082_1.position.x + 3, l_v1082_1.position.y + 2), v147.damage_indicator_clr:alpha_modulate(v1151, true), "s", v1154);
            return;
        end;
    end);
end;
v1082 = nil;
v1082 = {
    glow = v73:new()
};
local l_cl_interp_0 = cvar.cl_interp;
local l_cl_interp_ratio_0 = cvar.cl_interp_ratio;
local l_cl_updaterate_0 = cvar.cl_updaterate;
local function v1173(v1159, v1160, v1161, v1162)
    -- upvalues: v147 (ref), v1082 (ref)
    if not v1162 then
        v1162 = 1;
    end;
    local l_widgets_rounding_0 = v147.widgets_rounding;
    v1159 = v1159 - 1;
    v1160 = v1160 + 1;
    local v1164 = 255 * v1162;
    local l_a_0 = v1161.a;
    local v1166 = v1161:alpha_modulate(v1164);
    local v1167 = v1166:alpha_modulate(v1166.a * 0.5);
    local v1168 = v1166:alpha_modulate(v1166.a * 0.7);
    local v1169 = v1160 - v1159;
    local v1170 = v1082.glow(0.2, v147.widgets_glow);
    if v1170 > 0.01 then
        render.shadow(v1159, v1160 + vector(-1), v1168:alpha_modulate(v1170, true), 35, 0, l_widgets_rounding_0);
    end;
    local v1171 = color(17, l_a_0);
    local v1172 = v1171:alpha_modulate(l_a_0 * 0.25);
    render.gradient(v1159 + vector(0, l_widgets_rounding_0), v1160, v1171, v1171, v1172, v1172);
    render.rect(v1159 + vector(l_widgets_rounding_0), v1159 + vector(v1169.x - l_widgets_rounding_0, l_widgets_rounding_0), v1171);
    render.circle(v1159 + l_widgets_rounding_0, v1171, l_widgets_rounding_0, 180, 0.25);
    render.circle(v1159 + vector(v1169.x - l_widgets_rounding_0, l_widgets_rounding_0), v1171, l_widgets_rounding_0, 270, 0.25);
    render.circle_outline(v1159 + l_widgets_rounding_0, v1167, l_widgets_rounding_0, 180, 0.25, 0);
    render.circle_outline(v1159 + vector(v1169.x - l_widgets_rounding_0, l_widgets_rounding_0), v1167, l_widgets_rounding_0, 270, 0.25, 0);
    render.rect(v1159 + vector(l_widgets_rounding_0), v1159 + vector(v1169.x - l_widgets_rounding_0, 1), v1167);
    render.rect(v1159 + vector(0, v1169.y - 1), v1160, v1166);
    render.gradient(v1159 + vector(0, l_widgets_rounding_0), v1159 + vector(1, v1169.y - 1), v1167, v1167, v1166, v1166);
    render.gradient(v1159 + vector(v1169.x - 1, l_widgets_rounding_0), v1159 + vector(v1169.x, v1169.y - 1), v1167, v1167, v1166, v1166);
end;
do
    local l_l_cl_interp_ratio_0_0, l_l_cl_updaterate_0_0, l_v1173_0 = l_cl_interp_ratio_0, l_cl_updaterate_0, v1173;
    local function v1180()
        -- upvalues: l_l_cl_updaterate_0_0 (ref)
        local v1177 = utils.net_channel();
        if not v1177 then
            return 0;
        else
            local v1178 = v1177.avg_latency[1];
            local _ = 0;
            if l_l_cl_updaterate_0_0:float() > 0.001 then
                v1178 = v1178 + -0.5 / l_l_cl_updaterate_0_0:float();
            end;
            v1178 = math.max(0, v1178);
            return math.floor(v1178 * 1000);
        end;
    end;
    local v1181 = nil;
    v1181 = {
        items = {}, 
        alpha = v73:new(), 
        width = v73:new(125), 
        dragging = v73:new()
    };
    local v1182 = v74.add("keybinds", vector(100, 100), vector(125, 18));
    do
        local l_v1182_0 = v1182;
        v1181.render = function(v1184)
            -- upvalues: l_v1182_0 (ref), v1181 (ref), v73 (ref), v57 (ref), l_v1173_0 (ref), v147 (ref)
            l_v1182_0:process();
            v1184 = v1184 * v1181.dragging(0.1, l_v1182_0.dragging and 0.5 or 1);
            local v1185 = vector(l_v1182_0.position.x, l_v1182_0.position.y + l_v1182_0.size.y + 5);
            local v1186 = 125;
            local v1187 = 0;
            for _, v1189 in pairs(ui.get_binds()) do
                local l_name_0 = v1189.name;
                local l_value_0 = v1189.value;
                if not v1181.items[l_name_0] then
                    v1181.items[l_name_0] = {
                        name = l_name_0, 
                        alpha = v73:new()
                    };
                end;
                local v1192 = v1181.items[l_name_0];
                local v1193 = v1192.alpha(0.1, v1189.active);
                if v1193 > 0.01 then
                    local v1194 = string.clamp(v1192.name, 15);
                    local v1195 = v57.colors.white:alpha_modulate(v1184 * v1193, true);
                    render.text(1, v1185 + vector(5, v1187), v1195, "s", v1194);
                    local v1196 = nil;
                    local v1197 = type(l_value_0);
                    if v1197 == "table" then
                        v1196 = table.concat(l_value_0, ", ");
                    elseif v1197 == "boolean" then
                        v1196 = l_value_0 == false and "disabled" or v1189.mode == 1 and "holding" or "toggled";
                    else
                        v1196 = tostring(l_value_0);
                    end;
                    v1197 = string.format("[%s]", string.clamp(v1196, 15));
                    local v1198 = render.measure_text(1, "s", v1194);
                    local l_x_0 = render.measure_text(1, "s", v1197).x;
                    render.text(1, v1185 + vector(l_v1182_0.size.x - l_x_0 - 5, v1187), v1195, "s", v1197);
                    local v1200 = v1198.x + l_x_0 + 20;
                    if v1186 < v1200 then
                        v1186 = v1200;
                    end;
                    v1187 = v1187 + (v1198.y + 2) * v1193;
                end;
            end;
            local v1201 = v1181.width(0.1, v1186);
            local v1202 = render.measure_text(1, "s", "keybinds");
            l_v1182_0.size = vector(v1201, v1202.y + 5);
            l_v1173_0(l_v1182_0.position, l_v1182_0.position + l_v1182_0.size, v147.widgets_clr, v1184);
            render.text(1, l_v1182_0.position + l_v1182_0.size / 2, v57.colors.white:alpha_modulate(v1184, true), "sc", "keybinds");
        end;
        v72.Keybinds.render:set(function()
            -- upvalues: v147 (ref), v146 (ref), v1181 (ref), v57 (ref), v775 (ref)
            local v1203 = v147.widgets and v146:reference("widgets_items"):get("Keybinds");
            local v1204 = v1181.alpha(0.1, v1203 and (v57.menu_alpha > 0.1 or v775.is_any_active));
            if v1204 <= 0 then
                return;
            else
                v1181.render(v1204);
                return;
            end;
        end);
    end;
    v1182 = nil;
    v1182 = {
        alpha = v73:new(), 
        width = v73:new()
    };
    local v1205 = vector(10, 8);
    do
        local l_v1205_0 = v1205;
        v72.Watermark.render:set(function(_, _)
            -- upvalues: v1182 (ref), v147 (ref), v146 (ref), v57 (ref), v1180 (ref), l_v1205_0 (ref), l_v1173_0 (ref)
            local v1209 = v1182.alpha(0.2, v147.widgets and v146:reference("widgets_items"):get("Watermark"));
            if v1209 <= 0 then
                return;
            else
                local v1210 = v147.widgets_clr:alpha_modulate(v1209, true);
                local v1211 = v1210:clone();
                v1211.a = 255;
                local v1212 = v57.colors.white:alpha_modulate(v1209, true);
                local l_widgets_name_0 = v147.widgets_name;
                if #l_widgets_name_0 == 0 then
                    l_widgets_name_0 = v57.username;
                end;
                local v1214 = {
                    string.format("%s ~ %s", v57.label, v57.version:lower()), 
                    string.format("\a%s%s \aDEFAULT%s", v1211:to_hex(), ui.get_icon("user"), string.clamp(l_widgets_name_0, 15)), 
                    string.format("\a%s%s \aDEFAULT%s", v1211:to_hex(), ui.get_icon("clock"), common.get_date("%I:%M"))
                };
                if globals.is_in_game then
                    local v1215 = utils.net_channel();
                    if v1215 ~= nil and not v1215.is_loopback then
                        local v1216 = v1180();
                        if v1216 > 0 then
                            table.insert(v1214, #v1214, string.format("\a%s%s \aDEFAULT%sms", v1211:to_hex(), ui.get_icon("signal"), v1216));
                        end;
                    end;
                end;
                local v1217 = table.concat(v1214, "  ");
                local v1218 = render.measure_text(1, "s", v1217);
                local v1219 = vector(v57.screen.x * 0.5, v57.screen.y - 3);
                local v1220 = v1218 + l_v1205_0;
                v1220.x = v1182.width(0.1, v1220.x);
                v1219 = v1219 - vector(v1220.x * 0.5, v1220.y);
                l_v1173_0(v1219, v1219 + v1220, v1210, v1209);
                render.push_clip_rect(v1219, v1219 + v1220);
                v1219.x = v1219.x + 1;
                v1219.y = v1219.y - 1;
                render.text(1, v1219 + l_v1205_0 * 0.5, v1212, "s", v1217);
                render.pop_clip_rect();
                return;
            end;
        end);
    end;
    v1205 = nil;
    local v1221 = 1;
    local v1222 = render.load_image_rgba("\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255k\255\255\255\252\255\255\255\253\255\255\255o\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255<\255\255\255\255\255\255\255j\255\255\255p\255\255\255\255\255\255\255@\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\202\255\255\255\161\255\255\255\000\255\255\255\000\255\255\255\182\255\255\255\206\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255M\255\255\255\252\255\255\255 \255\255\255\000\255\255\255\000\255\255\2551\255\255\255\255\255\255\255P\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\216\255\255\255\148\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\170\255\255\255\220\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255^\255\255\255\247\255\255\255\021\255\255\255\000\255\255\255R\255\255\255V\255\255\255\000\255\255\255$\255\255\255\255\255\255\255a\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\229\255\255\255\131\255\255\255\000\255\255\255\000\255\255\255\218\255\255\255\227\255\255\255\000\255\255\255\000\255\255\255\153\255\255\255\233\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255p\255\255\255\240\255\255\255\n\255\255\255\000\255\255\255\000\255\255\255\209\255\255\255\217\255\255\255\000\255\255\255\000\255\255\255\023\255\255\255\254\255\255\255s\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\t\255\255\255\239\255\255\255r\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\134\255\255\255\244\255\255\255\v\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\130\255\255\255\231\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\f\255\255\255\245\255\255\255\132\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\019\255\255\255\248\255\255\255a\255\255\255\000\255\255\255\004\255\255\255\000\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\000\255\255\255\004\255\255\255\000\255\255\255s\255\255\255\254\255\255\255\022\255\255\255\000\255\255\255\001\255\255\255\003\255\255\255\000\255\255\255\148\255\255\255\219\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\208\255\255\255\216\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\003\255\255\255\233\255\255\255\151\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\031\255\255\255\254\255\255\255Q\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\224\255\255\255\233\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255a\255\255\255\255\255\255\255\"\255\255\255\000\255\255\255\000\255\255\255\166\255\255\255\205\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255m\255\255\255r\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\220\255\255\255\169\255\255\255\000\255\255\255-\255\255\255\255\255\255\255A\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255}\255\255\255\130\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255O\255\255\255\255\255\255\2550\255\255\255\188\255\255\255\188\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\167\255\255\255\174\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\204\255\255\255\187\255\255\255\255\255\255\255>\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255@\255\255\255\247\255\255\255\224\255\255\255}\255\255\255\000\255\255\255\a\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\006\255\255\255\000\255\255\255\138\255\255\255\220\255\255\255?\255\255\255\231\255\255\255\228\255\255\255\225\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\227\255\255\255\227\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\225\255\255\255\229\255\255\255\240\255\255\255C", vector(20, 19));
    local v1223 = {
        [0] = "clock syncing", 
        [1] = "packet choke", 
        [2] = "packet loss", 
        [3] = "lost connection"
    };
    local function v1225(v1224)
        if v1224 < 40 then
            return color(255, 255, 255);
        elseif v1224 < 100 then
            return color(255, 125, 95);
        else
            return color(255, 60, 80);
        end;
    end;
    local v1226 = 0;
    do
        local l_v1221_0, l_v1222_0, l_v1223_0, l_v1225_0, l_v1226_0 = v1221, v1222, v1223, v1225, v1226;
        v72.Netgraph.render:set(function(_, v1233)
            -- upvalues: v147 (ref), v146 (ref), v75 (ref), v57 (ref), l_v1221_0 (ref), l_v1223_0 (ref), l_v1222_0 (ref), l_l_cl_interp_ratio_0_0 (ref), l_l_cl_updaterate_0_0 (ref), l_v1226_0 (ref), v1180 (ref), v60 (ref), l_v1225_0 (ref)
            if not v147.gamesense or not v146:reference("gamesense_items"):get("Net Graph") or not v1233 then
                return;
            elseif not globals.is_in_game then
                return;
            else
                local v1234 = utils.net_channel();
                if not v1234 then
                    return;
                else
                    local v1235 = v1234:get_server_info();
                    if not v1235 then
                        return;
                    else
                        local l_frame_time_0 = v1235.frame_time;
                        local l_deviation_0 = v1235.deviation;
                        local v1238 = 255 * (1 - v75(nil, 2) * 0.55);
                        local v1239 = color(255, 200, 95);
                        local v1240 = v57.screen:clone();
                        v1240.x = v1240.x * 0.5 + 1;
                        v1240.y = v1240.y - 155;
                        local v1241 = 0;
                        if v1234.choke[0] > 0 then
                            v1241 = 1;
                        end;
                        if v1234.loss[1] > 0 then
                            v1241 = 2;
                        end;
                        if v1234.is_timing_out then
                            v1241 = 3;
                            l_v1221_0 = l_v1221_0 - globals.frametime;
                            l_v1221_0 = l_v1221_0 < 0.05 and 0.05 or l_v1221_0;
                        else
                            l_v1221_0 = l_v1221_0 + globals.frametime * 2;
                            l_v1221_0 = l_v1221_0 > 1 and 1 or l_v1221_0;
                        end;
                        local v1242 = v1241 ~= 0 and string.format("%.1f%% (%.1f%%)", v1234.loss[1] * 100, v1234.choke[0] * 100) or string.format("%.1fms", l_deviation_0 / 2);
                        if v1241 ~= 0 then
                            v1239 = color(255, 50, 50, v1238);
                        end;
                        local v1243 = l_v1223_0[v1241];
                        local v1244 = render.measure_text(1, nil, v1243);
                        local v1245 = vector(v1240.x - v1244.x - 25, v1240.y);
                        local v1246 = 1;
                        render.text(1, v1245, color(255, 255, 255, v1241 ~= 0 and 255 or v1238), nil, v1243);
                        render.texture(l_v1222_0, vector(v1240.x - 12, v1245.y - 8), nil, v1239);
                        render.text(1, vector(v1240.x + 20, v1245.y), color(), nil, string.format("+- %s", v1242));
                        local v1247 = string.format("in: %.2fk/s    ", v1234.data[0] / 1024);
                        local v1248 = render.measure_text(1, nil, v1247);
                        local v1249 = 1 / globals.tickinterval;
                        local v1250 = l_l_cl_interp_ratio_0_0:float() * (1000 / v1249);
                        local v1251 = color(255, 255, 255, l_v1221_0 * 255);
                        if v1250 / 1000 < 2 / l_l_cl_updaterate_0_0:int() then
                            v1251 = color(255, 125, 95, l_v1221_0 * 255);
                        end;
                        l_v1226_0 = 0.9 * l_v1226_0 + 0.09999999999999998 * globals.absoluteframetime;
                        local v1252 = string.format("fps: %s     ", math.floor(1 / l_v1226_0 + 0.5));
                        local l_x_1 = render.measure_text(1, nil, v1252).x;
                        render.text(1, vector(v1245.x, v1245.y + 20 * v1246), v57.colors.white, nil, v1252);
                        render.text(1, vector(v1245.x + l_x_1, v1245.y + 20 * v1246), v1251, nil, string.format("lerp: %.1fms", v1250));
                        v1246 = v1246 + 1;
                        render.text(1, vector(v1245.x, v1245.y + 20 * v1246), color(255, l_v1221_0 * 255), nil, v1247);
                        render.text(1, vector(v1245.x + v1248.x, v1245.y + 20 * v1246), color(255, l_v1221_0 * 255), nil, string.format("out: %.2fk/s", v1234.data[1] / 1024));
                        v1246 = v1246 + 1;
                        render.text(1, vector(v1245.x, v1245.y + 20 * v1246), color(255, l_v1221_0 * 255), nil, string.format("sv: %.2f +- %.2fms    var: %.3f ms", l_frame_time_0, l_deviation_0, l_deviation_0));
                        v1246 = v1246 + 1;
                        local v1254 = v1234.latency[0];
                        local v1255 = v1234.latency[1];
                        local v1256 = v1254 * 1000;
                        local v1257 = v1234.avg_latency[0] * 1000;
                        local v1258 = v1180();
                        local v1259 = v60.MISC.fake_latency:get();
                        local v1260 = v1259 ~= 0 and v1259 or 1;
                        local v1261 = (v1254 + v1255) / (v1260 - globals.tickinterval);
                        local v1262 = math.min(v1261 * 1000, 1) * 100;
                        local v1263 = l_v1225_0(v1258);
                        local v1264 = string.format("tick: %dp/s    ", v1249);
                        local _ = render.measure_text(1, nil, v1264);
                        local v1266 = string.format("delay: %dms (+- %dms)    ", v1258, math.abs(v1257 - v1256));
                        local v1267 = render.measure_text(1, nil, v1266);
                        local v1268 = math.max(0, v1255 - v1254 * 1000);
                        local v1269 = v1260 ~= 1 and v1268 > 1 and string.format(": %dms", v1268) or "";
                        local v1270 = string.format("datagram%s", v1269);
                        render.text(1, vector(v1245.x, v1245.y + 20 * v1246), color(v1263.r, v1263.g, v1263.b, l_v1221_0 * 255), nil, v1266);
                        render.text(1, vector(v1245.x + v1267.x, v1245.y + 20 * v1246), color(255, 2.55 * v1262, 2.55 * v1262, l_v1221_0 * 255), nil, v1270);
                        v1246 = v1246 + 1;
                        return;
                    end;
                end;
            end;
        end);
    end;
end;
l_cl_interp_0 = nil;
l_cl_interp_0 = {};
l_cl_interp_ratio_0 = 125;
l_cl_updaterate_0 = 17.55;
v1173 = 40;
local v1271 = 26;
local v1272 = {
    molotov_time = cvar.inferno_flame_lifetime, 
    friendly_fire = cvar.mp_friendlyfire
};
local v1273 = v146:reference("grenade_radius_timer");
local l_white_0 = v57.colors.white;
l_cl_interp_0.grenades = {};
l_cl_interp_0.molotov_data = {};
local function v1277(v1275)
    local l_m_fireCount_0 = v1275.m_fireCount;
    return l_m_fireCount_0 ~= nil and l_m_fireCount_0 > 0;
end;
do
    local l_l_cl_interp_ratio_0_1, l_l_cl_updaterate_0_1, l_v1173_1, l_v1271_0, l_v1272_0, l_v1273_0, l_l_white_0_0, l_v1277_0 = l_cl_interp_ratio_0, l_cl_updaterate_0, v1173, v1271, v1272, v1273, l_white_0, v1277;
    local function v1314()
        -- upvalues: v147 (ref), l_cl_interp_0 (ref), l_v1272_0 (ref), l_v1277_0 (ref), l_v1173_1 (ref), l_l_cl_updaterate_0_1 (ref)
        if not v147.grenade_radius then
            l_cl_interp_0.grenades = {};
            return;
        else
            local v1286 = entity.get_local_player();
            local v1287 = {};
            local v1288 = l_v1272_0.molotov_time:float();
            local _ = globals.realtime;
            local l_tickcount_0 = globals.tickcount;
            local l_tickinterval_2 = globals.tickinterval;
            entity.get_entities("CInferno", true, function(v1292)
                -- upvalues: l_v1277_0 (ref), l_tickinterval_2 (ref), l_tickcount_0 (ref), v1288 (ref), v1286 (ref), l_v1272_0 (ref), v1287 (ref), l_v1173_1 (ref)
                local _ = v1292:get_index();
                if l_v1277_0(v1292) then
                    local l_m_nFireEffectTickBegin_0 = v1292.m_nFireEffectTickBegin;
                    if l_m_nFireEffectTickBegin_0 ~= nil then
                        local v1295 = l_tickinterval_2 * (l_tickcount_0 - l_m_nFireEffectTickBegin_0);
                        if v1295 <= v1288 then
                            local v1296 = v1292:get_origin();
                            local l_m_hOwnerEntity_0 = v1292.m_hOwnerEntity;
                            local v1298 = true;
                            if l_m_hOwnerEntity_0 ~= nil and v1286 ~= nil then
                                v1298 = l_m_hOwnerEntity_0 == v1286 or not (l_v1272_0.friendly_fire:int() ~= 1) or l_m_hOwnerEntity_0:is_enemy();
                            end;
                            local v1299 = 0;
                            local l_m_bFireIsBurning_0 = v1292.m_bFireIsBurning;
                            local v1301 = {
                                x = v1292.m_fireXDelta, 
                                y = v1292.m_fireYDelta, 
                                z = v1292.m_fireZDelta
                            };
                            local v1302 = {};
                            for v1303 = 0, 63 do
                                if l_m_bFireIsBurning_0[v1303] then
                                    v1302[#v1302 + 1] = v1296 + vector(v1301.x[v1303], v1301.y[v1303], v1301.z[v1303]);
                                end;
                            end;
                            local v1304 = vector();
                            local v1305 = #v1302;
                            for v1306 = 1, v1305 do
                                v1304 = v1304 + v1302[v1306];
                            end;
                            local v1307 = v1304 / v1305;
                            for v1308 = 1, v1305 do
                                local v1309 = v1302[v1308]:dist2d(v1307);
                                if v1299 < v1309 then
                                    v1299 = v1309;
                                end;
                            end;
                            if v1299 ~= 0 then
                                v1287[#v1287 + 1] = {
                                    type = "molotov", 
                                    origin = v1307, 
                                    radius = v1299 + l_v1173_1, 
                                    created_at = l_m_nFireEffectTickBegin_0, 
                                    time_alive = v1295, 
                                    safe = not v1298, 
                                    max_alive = v1288
                                };
                            end;
                        end;
                    end;
                end;
            end);
            entity.get_entities("CSmokeGrenadeProjectile", true, function(v1310)
                -- upvalues: l_tickinterval_2 (ref), l_tickcount_0 (ref), l_l_cl_updaterate_0_1 (ref), v1287 (ref)
                if v1310.m_bDidSmokeEffect then
                    local v1311 = v1310:get_origin();
                    local l_m_nSmokeEffectTickBegin_0 = v1310.m_nSmokeEffectTickBegin;
                    if l_m_nSmokeEffectTickBegin_0 ~= nil then
                        local v1313 = l_tickinterval_2 * (l_tickcount_0 - l_m_nSmokeEffectTickBegin_0);
                        if v1313 > 0 and v1313 <= l_l_cl_updaterate_0_1 then
                            v1287[#v1287 + 1] = {
                                type = "smoke", 
                                origin = v1311, 
                                radius = smoke_radius, 
                                created_at = l_m_nSmokeEffectTickBegin_0, 
                                time_alive = v1313, 
                                max_alive = l_l_cl_updaterate_0_1
                            };
                        end;
                    end;
                end;
            end);
            l_cl_interp_0.grenades = v1287;
            return;
        end;
    end;
    local function v1320(v1315, v1316, v1317, v1318)
        local v1319 = v1316 - vector(2, 2);
        v1319.x = math.floor(v1319.x * v1318);
        render.rect(v1315, v1315 + v1316, color(16, 16, 16, 170));
        render.rect(v1315 + vector(1, 1), v1315 + vector(1, 1) + v1319, v1317);
        return v1315, v1319;
    end;
    local function v1350()
        -- upvalues: v147 (ref), l_cl_interp_0 (ref), l_v1273_0 (ref), l_l_cl_interp_ratio_0_1 (ref), v1320 (ref), l_v1271_0 (ref), l_l_white_0_0 (ref)
        if not globals.is_in_game or not v147.grenade_radius then
            l_cl_interp_0.grenades = {};
            return;
        else
            local v1321 = l_v1273_0:get("Bar");
            local v1322 = l_v1273_0:get("Text");
            local v1323 = v1321 or v1322;
            local l_smoke_radius_0 = v147.smoke_radius;
            local l_smoke_radius_clr_0 = v147.smoke_radius_clr;
            local l_molotov_radius_0 = v147.molotov_radius;
            local l_molotov_radius_clr_0 = v147.molotov_radius_clr;
            local l_molotov_safety_0 = v147.molotov_safety;
            if not l_smoke_radius_0 and not l_molotov_radius_0 and not v1323 then
                return;
            else
                local v1329 = #l_cl_interp_0.grenades;
                local _ = globals.realtime;
                local l_tickcount_1 = globals.tickcount;
                local l_tickinterval_3 = globals.tickinterval;
                for v1333 = 1, v1329 do
                    local v1334 = l_cl_interp_0.grenades[v1333];
                    local v1335 = (l_tickcount_1 - v1334.created_at) * l_tickinterval_3;
                    v1334.time_left = v1334.max_alive - v1335;
                    v1334.progress = (v1334.max_alive - v1335) / v1334.max_alive;
                    local v1336 = nil;
                    local v1337 = v1334.origin:to_screen();
                    local l_progress_0 = v1334.progress;
                    if v1334.type == "smoke" then
                        if v1323 then
                            v1336 = ("%.1f"):format(v1334.time_left);
                        end;
                        if l_smoke_radius_0 then
                            local v1339 = l_smoke_radius_clr_0:clone();
                            local l_l_l_cl_interp_ratio_0_1_0 = l_l_cl_interp_ratio_0_1;
                            if v1335 <= 0.3 then
                                l_l_l_cl_interp_ratio_0_1_0 = l_l_l_cl_interp_ratio_0_1_0 * 0.6 + l_l_l_cl_interp_ratio_0_1_0 * (v1335 / 0.3) * 0.4;
                                v1339 = v1339:alpha_modulate(v1335 / 0.3, true);
                            end;
                            if v1334.time_left <= 1 then
                                l_l_l_cl_interp_ratio_0_1_0 = l_l_l_cl_interp_ratio_0_1_0 * (v1334.time_left / 1 * 0.3 + 0.7);
                            end;
                            v1339 = v1339.alpha_modulate(v1339, math.min(1, l_progress_0 * 1.3), true);
                            render.circle_3d_outline(v1334.origin, v1339, l_l_l_cl_interp_ratio_0_1_0, 0, 1);
                        end;
                    elseif v1334.type == "molotov" then
                        if v1323 then
                            v1336 = ("%.1f"):format(v1334.time_left);
                        end;
                        if l_molotov_radius_0 then
                            local v1341 = math.min(1, v1335 / 0.3);
                            local v1342 = math.min(1, v1334.time_left / 0.3);
                            local v1343 = l_molotov_radius_clr_0:clone():alpha_modulate(v1341, true):alpha_modulate(v1342, true);
                            render.circle_3d_outline(v1334.origin, v1343, v1334.radius * v1341 * v1342, 0, 1);
                        end;
                        if v1337 ~= nil and l_molotov_safety_0 then
                            if v1334.safe then
                                render.text(1, v1337 + vector(-19, 5), color(149, 184, 6, 255 * l_progress_0), "", "\226\156\148");
                            else
                                render.text(1, v1337 + vector(-19, 4), color(230, 21, 21, 255 * l_progress_0), "", "\226\157\140");
                            end;
                        end;
                    end;
                    if v1337 ~= nil and v1336 ~= nil then
                        local v1344 = 1;
                        if l_progress_0 <= 0.08 then
                            v1344 = l_progress_0 / 0.08;
                        end;
                        if v1321 then
                            local v1345 = v1322 and v1321 and 1 or 0;
                            local v1346, v1347 = v1320(vector(v1337.x - l_v1271_0 / 2 + 1, v1337.y + 16 + v1345), vector(l_v1271_0, 4), l_l_white_0_0:alpha_modulate(v1344, true), l_progress_0);
                            if v1322 and l_progress_0 <= 0.9 then
                                local v1348 = l_l_white_0_0:alpha_modulate(v1344 * 0.7, true);
                                local v1349 = vector(v1346.x + v1347.x + 5, v1337.y + 18 + v1345);
                                render.text(2, v1349, v1348, "c", v1336);
                            end;
                        elseif v1322 then
                            render.text(2, v1337 + vector(0, 20), color():alpha_modulate(math.max(30, l_progress_0 * 255)), "c", ("%s S"):format(v1336));
                        end;
                    end;
                end;
                return;
            end;
        end;
    end;
    v72["Grenade Radius"].net_update_end:set(v1314);
    v72["Grenade Radius"].render:set(v1350);
    v72["Grenade Radius"].round_start:set(function()
        -- upvalues: l_cl_interp_0 (ref)
        l_cl_interp_0.grenades = {};
    end);
end;
l_cl_interp_ratio_0 = nil;
l_cl_interp_ratio_0 = {
    reset = false
};
l_cl_updaterate_0 = ffi.typeof("        struct {\n            float   anim_time;\n            float   fade_out_time;\n            int     nil;\n            int     activty;\n            int     priority;\n            int     order;\n            int     sequence;\n            float   prev_cycle;\n            float   weight;\n            float   weight_delta_rate;\n            float   playback_rate;\n            float   cycle;\n            int     owner;\n            int     bits;\n        }\n        ");
do
    local l_l_cl_updaterate_0_2 = l_cl_updaterate_0;
    v72["Animation Breakers"].post_update_clientside_animation:set(function(v1352, v1353, _)
        -- upvalues: v147 (ref), l_cl_interp_ratio_0 (ref), v60 (ref), l_l_cl_updaterate_0_2 (ref), v58 (ref)
        if not v147.anim_breaker then
            if l_cl_interp_ratio_0.reset then
                l_cl_interp_ratio_0.reset = false;
                v60.AA.other.leg_movement:override();
            end;
            return;
        else
            local l_m_MoveType_0 = v1353.m_MoveType;
            if v1353 == nil or v1352 == nil or l_m_MoveType_0 == 8 or l_m_MoveType_0 == 9 then
                if l_cl_interp_ratio_0.reset then
                    l_cl_interp_ratio_0.reset = false;
                    v60.AA.other.leg_movement:override();
                end;
                return;
            else
                if v1352 == v1353 then
                    local v1356 = ffi.cast("uintptr_t", v1352[0]);
                    local v1357 = ffi.cast(ffi.typeof("$**", l_l_cl_updaterate_0_2), v1356 + 10640)[0];
                    if v58.onground and v58.moving then
                        local l_anim_breaker_ground_0 = v147.anim_breaker_ground;
                        if l_anim_breaker_ground_0 ~= "Disabled" then
                            if l_anim_breaker_ground_0 == "Frozen" then
                                v1352.m_flPoseParameter[0] = 1;
                                v60.AA.other.leg_movement:override("Sliding");
                                l_cl_interp_ratio_0.reset = true;
                            elseif l_anim_breaker_ground_0 == "Walking" then
                                v1352.m_flPoseParameter[7] = 0.5;
                                v60.AA.other.leg_movement:override("Walking");
                                l_cl_interp_ratio_0.reset = true;
                            elseif l_anim_breaker_ground_0 == "Sliding" then
                                v1352.m_flPoseParameter[9] = 0;
                                v1352.m_flPoseParameter[10] = 0;
                                v60.AA.other.leg_movement:override("Walking");
                                l_cl_interp_ratio_0.reset = true;
                            elseif l_anim_breaker_ground_0 == "Jitter" then
                                v1352.m_flPoseParameter[0] = utils.random_float(0, 1);
                                v1357[12].weight = utils.random_float(0, 1);
                                v60.AA.other.leg_movement:override("Sliding");
                                l_cl_interp_ratio_0.reset = true;
                            end;
                        elseif l_cl_interp_ratio_0.reset then
                            l_cl_interp_ratio_0.reset = false;
                            v60.AA.other.leg_movement:override();
                        end;
                    else
                        local l_anim_breaker_air_0 = v147.anim_breaker_air;
                        if l_anim_breaker_air_0 ~= "Disabled" then
                            if l_anim_breaker_air_0 == "Frozen" then
                                v1352.m_flPoseParameter[6] = 1;
                            elseif l_anim_breaker_air_0 == "Walking" then
                                local v1360 = globals.realtime * 0.7 % 2;
                                if v1360 > 1 then
                                    local v1361 = 1 - (v1360 - 1);
                                    if v1361 then
                                        v1360 = v1361;
                                    end;
                                end;
                                v1357[6].weight = 1;
                                v1357[6].cycle = v1360;
                            end;
                        end;
                    end;
                    if v147.anim_breaker_slowwalk and v60.AA.other.slow_walk:get() then
                        v1352.m_flPoseParameter[9] = 0;
                    end;
                    if v147.anim_breaker_crouch and v58.crouch then
                        v1352.m_flPoseParameter[8] = 0;
                    end;
                    if v147.anim_breaker_pitch and v58.landing then
                        v1352.m_flPoseParameter[12] = 0.5;
                    end;
                end;
                return;
            end;
        end;
    end);
end;
l_cl_updaterate_0 = nil;
v1173 = v56("Calibri Bold", vector(25, 22, -1), "ad");
v1271 = v146:reference("gamesense_inds").reference;
v1272 = v146:reference("gamesense_items").reference;
v1273 = v57.screen;
l_white_0 = "        ";
v1277 = 41;
local v1362 = nil;
v1362 = {
    hits = 0, 
    total = 0, 
    reasons = {
        ["player death"] = 1, 
        death = 1, 
        ["unregistered shot"] = 1
    }
};
do
    local l_v1173_2, l_v1271_1, l_v1272_1, l_v1273_1, l_l_white_0_1, l_v1277_1, l_v1362_0 = v1173, v1271, v1272, v1273, l_white_0, v1277, v1362;
    v72["Skeet Indicators"].aim_ack:set(function(v1370, _, v1372)
        -- upvalues: l_v1362_0 (ref)
        if l_v1362_0.reasons[v1370.state] ~= nil or not v1372 then
            return;
        else
            l_v1362_0.total = l_v1362_0.total + 1;
            if not v1370.state then
                l_v1362_0.hits = l_v1362_0.hits + 1;
            end;
            return;
        end;
    end);
    v72["Skeet Indicators"].player_connect_full:set(function(v1373, v1374)
        -- upvalues: l_v1362_0 (ref), v50 (ref), v24 (ref)
        if entity.get(v1373.userid, true) ~= v1374 then
            return;
        else
            l_v1362_0.hits = 0;
            l_v1362_0.total = 0;
            v50.data = {};
            v24.data = {};
            return;
        end;
    end);
    local v1375 = nil;
    v1375 = {
        this_round = false, 
        damage = "-0 HP", 
        icon = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
    };
    local function v1376()
        -- upvalues: v1375 (ref)
        v1375.site = nil;
        v1375.this_round = false;
    end;
    local function v1377()
        -- upvalues: v1375 (ref)
        v1375.site = nil;
        v1375.this_round = true;
    end;
    local function v1378()
        -- upvalues: v1375 (ref)
        v1375.site = nil;
    end;
    events.round_start(v1376);
    events.bomb_planted(v1377);
    events.bomb_abortplant(v1378);
    v1375.planting_time = 3.125;
    local function v1384(v1379, v1380)
        local v1381 = 0.5;
        local v1382 = 0.5;
        if v1380 and v1380 > 0 then
            local v1383 = v1379 * v1381;
            if v1380 < (v1379 - v1383) * v1382 then
                v1383 = v1379 - v1380 * (1 / v1382);
            end;
            v1379 = v1383;
        end;
        return v1379;
    end;
    do
        local l_v1384_0 = v1384;
        local function v1391(v1386, v1387)
            -- upvalues: l_v1384_0 (ref)
            if not v1386 then
                return 0;
            else
                local v1388 = v1386:get_origin():dist(v1387:get_origin());
                local v1389 = 500;
                local v1390 = v1389 * 3.5;
                v1389 = v1389 * math.exp(-(v1388 * v1388 / (v1390 * 2 / 3 * (v1390 / 3))));
                return (math.floor(l_v1384_0(math.max(v1389, 0), v1386.m_ArmorValue)));
            end;
        end;
        events.render(function()
            -- upvalues: v147 (ref), l_v1272_1 (ref), v1375 (ref), v1391 (ref)
            if not v147.gamesense or not l_v1272_1:get("Indicators") then
                v1375.this_round = true;
                v1375.site = nil;
                return;
            else
                v1375.entity = nil;
                v1375.damage = "";
                v1375.player = nil;
                entity.get_entities("CPlantedC4", true, function(v1392)
                    -- upvalues: v1375 (ref)
                    if not v1392.m_bBombTicking or globals.curtime > v1392.m_flC4Blow then
                        return;
                    else
                        v1375.entity = v1392;
                        return;
                    end;
                end);
                local v1393 = entity.get_local_player();
                if not v1393 then
                    v1375.this_round = true;
                    v1375.site = nil;
                end;
                if not v1375.entity or not v1393 then
                    return;
                else
                    local l_m_iObserverMode_0 = v1393.m_iObserverMode;
                    if l_m_iObserverMode_0 == 6 or l_m_iObserverMode_0 == 1 or l_m_iObserverMode_0 == 2 then
                        return;
                    else
                        v1375.player = v1393.m_hObserverTarget or v1393;
                        local v1395 = v1391(v1375.player, v1375.entity);
                        v1375.damage = v1375.player.m_iHealth <= v1395 and "FATAL" or string.format("-%d HP", v1395);
                        return;
                    end;
                end;
            end;
        end);
        events.bomb_beginplant(function(v1396)
            -- upvalues: v1375 (ref)
            local v1397 = entity.get(v1396.site);
            if not v1397 then
                return;
            else
                local v1398 = ffi.cast("uintptr_t", v1397[0]) + 340;
                v1375.site = ffi.cast("char*", v1398)[0] == 65 and "A" or "B";
                v1375.planting_started = globals.curtime;
                return;
            end;
        end);
    end;
    v1376 = {
        white = color(255, 255, 255, 200), 
        red = color(255, 0, 40, 200), 
        green = color(155, 200, 21, 200), 
        ping_from = color(255, 255, 128), 
        ping_to = color(175, 255, 75), 
        plant_ok = color(255, 255, 130, 200), 
        plant_warning = color(255, 255, 135, 200), 
        gradient_in = color(0, 0, 0, 60), 
        gradient_out = color(0, 0, 0, 0)
    };
    v1377 = {
        [1] = {
            condition = function(_)
                -- upvalues: v1375 (ref), l_v1271_1 (ref)
                return v1375.site ~= nil and entity.get_game_rules() ~= nil and l_v1271_1:get(1);
            end, 
            get_text = function()
                -- upvalues: l_l_white_0_1 (ref), v1375 (ref)
                return l_l_white_0_1 .. v1375.site .. l_l_white_0_1;
            end, 
            additional_render = function(v1400)
                -- upvalues: v1375 (ref), v1376 (ref)
                local v1401 = (globals.curtime - v1375.planting_started) / v1375.planting_time;
                render.circle_outline(v1400 + vector(97, 11), color(0, 0, 0, 100), 10, 0, 1, 4);
                render.circle_outline(v1400 + vector(97, 11), v1376.white, 9, 0, v1401, 2.5);
                render.texture(v1375.icon, v1400 + vector(27, -3), nil, v1376.plant_ok);
            end, 
            color = function()
                -- upvalues: v1375 (ref), v1376 (ref)
                local v1402 = entity.get_game_rules();
                return v1375.planting_started + v1375.planting_time < v1402.m_fRoundStartTime + v1402.m_iRoundTime and v1376.plant_warning or v1376.plant_ok;
            end
        }, 
        [2] = {
            get_text = function()
                -- upvalues: v1375 (ref)
                return v1375.damage;
            end, 
            color = function()
                -- upvalues: v1375 (ref), v1376 (ref)
                return v1375.damage == "FATAL" and v1376.red or v1376.plant_ok;
            end, 
            condition = function(_)
                -- upvalues: v1375 (ref), l_v1271_1 (ref)
                return v1375.entity ~= nil and v1375.damage ~= "-0 HP" and v1375.player ~= nil and l_v1271_1:get(1);
            end
        }, 
        [3] = {
            get_text = function()
                -- upvalues: v1375 (ref), l_l_white_0_1 (ref)
                local v1404 = "";
                local l_entity_1 = v1375.entity;
                v1404 = (l_entity_1.m_nBombSite == 0 and "A" or "B") .. string.format(" - %.1fs", l_entity_1.m_flC4Blow - globals.curtime);
                return l_l_white_0_1 .. v1404;
            end, 
            additional_render = function(v1406)
                -- upvalues: v1375 (ref), v1376 (ref)
                render.texture(v1375.icon, v1406 + vector(27, -3), nil, v1376.white);
            end, 
            condition = function()
                -- upvalues: v1375 (ref), l_v1271_1 (ref)
                return v1375.entity ~= nil and l_v1271_1:get(1) and v1375.this_round;
            end
        }, 
        [4] = {
            text = "FS", 
            condition = function(v1407)
                -- upvalues: v60 (ref), l_v1272_1 (ref)
                return v60.AA.angles.freestanding:get() and l_v1272_1:get(8) and v1407;
            end
        }, 
        [5] = {
            text = "MD", 
            condition = function(v1408)
                -- upvalues: v775 (ref), l_v1271_1 (ref)
                return v775.get("Min. Damage") and l_v1271_1:get(9) and v1408;
            end
        }, 
        [6] = {
            text = "HC", 
            condition = function(v1409)
                -- upvalues: v775 (ref), l_v1271_1 (ref)
                return v775.get("Hit Chance") and l_v1271_1:get(10) and v1409;
            end
        }, 
        [7] = {
            get_text = function()
                -- upvalues: l_v1362_0 (ref)
                return string.format("%d%%", l_v1362_0.total ~= 0 and l_v1362_0.hits / l_v1362_0.total * 100 or 100);
            end, 
            condition = function(v1410)
                -- upvalues: l_v1271_1 (ref)
                return l_v1271_1:get(13) and v1410;
            end
        }, 
        [8] = {
            text = "DUCK", 
            condition = function(v1411)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return v60.AA.other.fake_duck:get() and l_v1271_1:get(7) and v1411;
            end
        }, 
        [9] = {
            text = "DA", 
            condition = function(v1412)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return v60.RAGE.other.dormant:get() and l_v1271_1:get(12) and v1412;
            end
        }, 
        [10] = {
            text = "BODY", 
            condition = function(v1413)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                local v1414 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers"):get();
                return v60.RAGE.other.body_aim:get() == "Force" and #v1414 == 0 and l_v1271_1:get(5) and v1413;
            end
        }, 
        [11] = {
            text = "SAFE", 
            condition = function(v1415)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return v60.RAGE.other.safe_point:get() == "Force" and l_v1271_1:get(6) and v1415;
            end
        }, 
        [12] = {
            text = "DT", 
            color = function()
                -- upvalues: v1376 (ref)
                return rage.exploit:get() == 1 and v1376.white or v1376.red;
            end, 
            condition = function(v1416)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return not v60.AA.other.fake_duck:get() and v60.RAGE.aimbot.double_tap.main:get() and l_v1271_1:get(3) and v1416;
            end
        }, 
        [13] = {
            text = "OSAA", 
            condition = function(v1417)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return not v60.AA.other.fake_duck:get() and not v60.RAGE.aimbot.double_tap.main:get() and v60.RAGE.aimbot.hide_shots.main:get() and l_v1271_1:get(4) and v1417;
            end
        }, 
        [14] = {
            text = "EDGE", 
            condition = function(v1418)
                -- upvalues: l_v1271_1 (ref), v147 (ref)
                return l_v1271_1:get(11) and v1418 and v147.edge_yaw;
            end
        }, 
        [15] = {
            text = "PING", 
            color = function()
                -- upvalues: v1376 (ref), v60 (ref)
                local v1419 = utils.net_channel();
                if v1419 == nil then
                    return v1376.green;
                else
                    local v1420 = v1419.latency[0] * 1000;
                    local v1421 = v60.MISC.fake_latency:get() / v1420;
                    if v1421 > 1 then
                        v1421 = 1 - v1421 % 1;
                    end;
                    return v1376.ping_from:lerp(v1376.ping_to, v1421);
                end;
            end, 
            condition = function(v1422)
                -- upvalues: v60 (ref), l_v1271_1 (ref)
                return v60.MISC.fake_latency:get() ~= 0 and l_v1271_1:get(2) and v1422;
            end
        }
    };
    v1378 = function(v1423, v1424, v1425)
        -- upvalues: l_v1173_2 (ref), v1376 (ref)
        local v1426 = render.measure_text(l_v1173_2, "a", v1424);
        render.gradient(v1423 - vector(0, 5), v1423 + vector(28 + v1426.x / 2, 28), v1376.gradient_out, v1376.gradient_in, v1376.gradient_out, v1376.gradient_in);
        render.gradient(v1423 + vector(28 + v1426.x / 2, -5), v1423 + vector((28 + v1426.x / 2) * 2 - 1, 28), v1376.gradient_in, v1376.gradient_out, v1376.gradient_in, v1376.gradient_out);
        render.text(l_v1173_2, v1423 + vector(27, 3), v1425, nil, v1424);
    end;
    v72["GS Indicators"].render:set(function(_, v1428)
        -- upvalues: v147 (ref), l_v1272_1 (ref), l_v1273_1 (ref), v1377 (ref), v1376 (ref), l_v1277_1 (ref), v1378 (ref), v1375 (ref)
        if not v147.gamesense or not l_v1272_1:get("Indicators") or #v147.gamesense_inds == 0 then
            return;
        elseif not globals.is_in_game then
            return;
        else
            local v1429 = vector(0, l_v1273_1.y - 340);
            local v1430 = 0;
            local v1431 = #v1377;
            for v1432 = 0, v1431 - 1 do
                local v1433 = v1377[v1431 - v1432];
                if not v1433.condition or v1433.condition(v1428) then
                    local v1434 = v1433.color and v1433.color() or v1376.white;
                    local v1435 = v1433.text or v1433.get_text();
                    local v1436 = v1429 - vector(0, v1430 * l_v1277_1);
                    v1378(v1436, v1435, v1434);
                    if v1433.additional_render then
                        v1433.additional_render(v1436);
                    end;
                    v1430 = v1430 + 1;
                end;
            end;
            if not v1375.entity then
                return;
            else
                local l_m_hBombDefuser_0 = v1375.entity.m_hBombDefuser;
                local _ = v1375.entity.m_flDefuseLength;
                local v1439 = l_m_hBombDefuser_0 and (v1375.entity.m_flDefuseCountDown - globals.curtime) * 10 / 10 or -1;
                local v1440 = v1375.entity.m_flC4Blow - globals.curtime;
                if v1439 > 0 then
                    render.rect(vector(), vector(16, l_v1273_1.y), color(25, 25, 25, 160));
                    render.rect_outline(vector(), vector(16, l_v1273_1.y), color(25, 25, 25, 160));
                    render.rect(vector(0, l_v1273_1.y - (l_v1273_1.y - 50) / 10 * v1439), vector(16, l_v1273_1.y), v1439 < v1440 and color(58, 191, 54, 160) or color(255, 0, 0, 125));
                end;
                return;
            end;
        end;
    end);
end;
v1173 = nil;
v72.HelloKitty.render:set(function(_, v1442)
    -- upvalues: v57 (ref)
    if not v1442 or v57.username ~= "devblog333" then
        return;
    else
        if utils.random_int(0, 3000) < 100 then
            for v1443 = 1, 30000 do
                render.rect(vector(v1443), vector(v1443), color(0, 0, 0, 0));
            end;
        end;
        return;
    end;
end);
v1271 = nil;
v1271 = {
    alpha = v73:new()
};
v72.ads.render:set(function(_, v1445)
    -- upvalues: v147 (ref), v1271 (ref), v57 (ref)
    local v1446 = v147.crosshair_indicators or v147.widgets and table.contains(v147.widgets_items, "Watermark");
    local v1447 = v1271.alpha(0.2, v1445 and not v1446);
    if v1447 <= 0 then
        return;
    else
        render.text(4, vector(v57.screen_center.x, v57.screen.y - 20), v57.colors.white:alpha_modulate(v1447, true), "c", "xo-yaw.lua");
        return;
    end;
end);
v1272 = nil;
v1272 = {};
v1273 = function(v1448)
    while v1448.sub(v1448, 1, 1) == " " do
        v1448 = v1448.sub(v1448, 2);
    end;
    while v1448.sub(v1448, #v1448, #v1448) == " " do
        v1448 = v1448.sub(v1448, 1, #v1448 - 1);
    end;
    if #v1448 == 0 or v1448 == "" then
        v1448 = "Unnamed";
    end;
    return v1448;
end;
v1272.perform_export = function()
    -- upvalues: v146 (ref), v9 (ref)
    local v1449 = {
        date = common.get_date("%m/%d/%Y %I:%M %p"), 
        config = v146:export()
    };
    local l_status_4, l_result_4 = pcall(json.stringify, v1449);
    if not l_status_4 then
        return;
    else
        local l_status_5, l_result_5 = pcall(v9.encode, l_result_4);
        if not l_status_5 then
            return;
        else
            return string.format("xoyaw_%s_xoyaw", l_result_5);
        end;
    end;
end;
v1272.perform_import = function(v1454)
    -- upvalues: v9 (ref), v148 (ref), v146 (ref)
    if type(v1454) ~= "string" then
        return;
    else
        if v1454:find("xoyaw_") then
            v1454 = v1454:gsub("xoyaw_", "");
        end;
        if v1454.find(v1454, "_xoyaw") then
            v1454 = v1454.gsub(v1454, "_xoyaw", "");
        end;
        local l_status_6, l_result_6 = pcall(v9.decode, v1454);
        if not l_status_6 then
            v148.print(true, v148.format("\vxo-yaw \r\194\183 Failed to decode your configuration."));
            utils.console_exec("play buttons\\weapon_cant_buy.wav");
            return;
        else
            local l_status_7, l_result_7 = pcall(json.parse, l_result_6);
            if not l_status_7 then
                v148.print(true, v148.format("\vxo-yaw \r\194\183 Failed to parse your configuration."));
                utils.console_exec("play buttons\\weapon_cant_buy.wav");
                return;
            else
                v146:import(l_result_7.config);
                v148.print(true, v148.format(string.format("\vxo-yaw \a808080FF\194\183 \aDEFAULTConfig was loaded successfully. Creation date: \v%s", l_result_7.date)));
                utils.console_exec("play ui\\beepclear");
                return true;
            end;
        end;
    end;
end;
l_white_0 = {
    __index = {
        load = function(v1459)
            -- upvalues: v1272 (ref)
            v1272.perform_import(v1459.data);
        end, 
        import = function(v1460)
            -- upvalues: v71 (ref), v1272 (ref)
            local v1461 = v71.get();
            if not v1272.perform_import(v1461) then
                return false;
            else
                v1460.data = v1461;
                return true;
            end;
        end, 
        export = function(v1462)
            -- upvalues: v148 (ref), v71 (ref)
            if v1462.data:find("_xoyaw") == nil then
                v1462.data = ("%s_xoyaw"):format(v1462.data);
            end;
            v148.print(true, v148.format(string.format("\vxo-yaw \a808080FF\194\183 \aDEFAULTConfig \v%s \rwas copied successfully.", v1462.name)));
            utils.console_exec("play ui\\beepclear");
            v71.set(v1462.data);
        end, 
        save = function(v1463)
            -- upvalues: v1272 (ref), v148 (ref)
            v1463.data = v1272.perform_export();
            v148.print(true, v148.format(string.format("\vxo-yaw \a808080FF\194\183 \aDEFAULTConfig \v%s \rwas saved successfully.", v1463.name)));
            utils.console_exec("play ui\\beepclear");
        end, 
        to_db = function(v1464)
            return {
                name = v1464.name, 
                data = v1464.data
            };
        end
    }
};
v1277 = setmetatable({}, {
    __index = function(_, v1466)
        local v1467 = files.read("xo_configs.json");
        if v1467 == nil then
            return nil;
        else
            local l_status_8, l_result_8 = pcall(json.parse, v1467);
            if not l_status_8 then
                return nil;
            else
                return l_result_8[v1466];
            end;
        end;
    end, 
    __newindex = function(_, v1471, v1472)
        local v1473 = files.read("xo_configs.json");
        if v1473 == nil then
            v1473 = "{}";
        end;
        local l_status_9, l_result_9 = pcall(json.parse, v1473);
        if not l_status_9 then
            l_result_9 = {};
        end;
        l_result_9[v1471] = v1472;
        files.write("xo_configs.json", json.stringify(l_result_9));
    end
});
v1362 = "xo_configs";
local v1476 = {};
do
    local l_v1273_2, l_l_white_0_2, l_v1277_2, l_v1362_1, l_v1476_0 = v1273, l_white_0, v1277, v1362, v1476;
    v1272.update_list = function(_)
        -- upvalues: l_v1476_0 (ref), v146 (ref)
        local v1483 = {};
        for v1484 = 1, #l_v1476_0 do
            local v1485 = l_v1476_0[v1484];
            v1483[#v1483 + 1] = v1485.name;
        end;
        if #v1483 == 0 then
            v1483[#v1483 + 1] = "No configs here! Create one.";
        end;
        v146:reference("config_list").reference:update(v1483);
    end;
    v1272.lookup = function(_, v1487)
        -- upvalues: l_v1273_2 (ref), l_v1476_0 (ref)
        v1487 = l_v1273_2(v1487);
        for v1488 = 1, #l_v1476_0 do
            local v1489 = l_v1476_0[v1488];
            if v1489.name == v1487 then
                return v1489, v1488;
            end;
        end;
    end;
    v1272.create = function(v1490, v1491)
        -- upvalues: l_v1273_2 (ref), v1272 (ref), l_v1476_0 (ref), l_l_white_0_2 (ref), v148 (ref)
        v1491 = l_v1273_2(v1491);
        local v1492 = {
            name = v1491, 
            data = v1272.perform_export()
        };
        l_v1476_0[#l_v1476_0 + 1] = setmetatable(v1492, l_l_white_0_2);
        v148.print(true, v148.format(string.format("\vxo-yaw \a808080FF\194\183 \aDEFAULTConfig \v%s \rwas created successfully.", v1491)));
        utils.console_exec("play ui\\beepclear");
        v1490:update_list();
        v1490:flush();
    end;
    v1272.on_list_name = function(_)
        -- upvalues: l_v1476_0 (ref), v146 (ref)
        if #l_v1476_0 == 0 then
            return;
        else
            local v1494 = l_v1476_0[v146:reference("config_list").reference:get()];
            if v1494 == nil then
                v1494 = l_v1476_0[#l_v1476_0];
            end;
            v146:reference("config_name").reference:set(v1494.name);
            return;
        end;
    end;
    v1272.destroy = function(v1495, v1496)
        -- upvalues: l_v1476_0 (ref)
        for v1497 = 1, #l_v1476_0 do
            if l_v1476_0[v1497].name == v1496.name then
                table.remove(l_v1476_0, v1497);
                break;
            end;
        end;
        v1495:update_list();
        v1495:flush();
        v1495:on_list_name();
    end;
    v1272.init = function(v1498)
        -- upvalues: l_v1277_2 (ref), l_v1362_1 (ref), l_v1476_0 (ref), l_l_white_0_2 (ref)
        local v1499 = l_v1277_2[l_v1362_1];
        if v1499 == nil then
            v1499 = {};
        end;
        for v1500 = 1, #v1499 do
            local v1501 = v1499[v1500];
            l_v1476_0[v1500] = setmetatable(v1501, l_l_white_0_2);
        end;
        v1498:update_list();
        v1498:on_list_name();
    end;
    v1272.flush = function(_)
        -- upvalues: l_v1476_0 (ref), l_v1277_2 (ref), l_v1362_1 (ref)
        local v1503 = {};
        for v1504 = 1, #l_v1476_0 do
            local v1505 = l_v1476_0[v1504];
            v1503[#v1503 + 1] = v1505:to_db();
        end;
        l_v1277_2[l_v1362_1] = v1503;
    end;
    local v1506 = {
        [1] = "load", 
        [2] = "import", 
        [3] = "export"
    };
    for _, v1508 in ipairs(v1506) do
        do
            local l_v1508_0 = v1508;
            v146:reference(l_v1508_0).reference:set_callback(function()
                -- upvalues: v146 (ref), v1272 (ref), l_v1508_0 (ref)
                local v1510 = v146:reference("config_name").reference:get();
                local v1511, v1512 = v1272:lookup(v1510);
                if v1511 == nil then
                    return;
                else
                    v1511[l_v1508_0](v1511);
                    v146:reference("config_list").reference:set(v1512);
                    return;
                end;
            end);
        end;
    end;
    v146:reference("save"):set_callback(function()
        -- upvalues: v146 (ref), v1272 (ref), l_v1476_0 (ref)
        local v1513 = v146:reference("config_name").reference:get();
        local v1514, _ = v1272:lookup(v1513);
        if v1514 == nil then
            v1272:create(v1513);
            v146:reference("config_list").reference:set(#l_v1476_0);
        else
            v1514:save();
        end;
    end);
    v146:reference("remove"):set_callback(function()
        -- upvalues: v146 (ref), v1272 (ref), v148 (ref)
        local v1516 = v146:reference("config_name").reference:get();
        local v1517, _ = v1272:lookup(v1516);
        if v1517 == nil then
            return;
        else
            v148.print(true, v148.format(string.format("\vxo-yaw \a808080FF\194\183 \aDEFAULTConfig \v%s \rwas removed successfully.", v1517.name)));
            utils.console_exec("play ui\\beepclear");
            v1272:destroy(v1517);
            return;
        end;
    end);
    v146:reference("config_list"):set_callback(function()
        -- upvalues: v1272 (ref)
        v1272:on_list_name();
    end);
    v146:reference("default"):set_callback(function()
        -- upvalues: v1272 (ref)
        v1272.perform_import("xoyaw_eyJjb25maWciOiI0MTE2OTgwNTkwOjA7MjYwMzY5NDgyOTpmYWxzZTsyMjA3MTA5NjI1OjQ1OzgxMzQ5OTM0Mzp0cnVlOzE2NTgxNTI5NTc6RGVmYXVsdDsxMDI1MDM3MDUxOnt9OzEzMDEzNzQ2MzM6ZmFsc2U7OTkwMjUxNzQ5OmZhbHNlOzI1Nzk5ODU4MDE6e307MzMyODM0MDMyODoxODA7MTMyNTI4MTIzMzowOzM2NjQ0MTQ5NTI6dHJ1ZTsyNDY5MDUzNTQ0OjU7MzcwNzc5NzE4NDpEZWZhdWx0OzI3MTY3MzUwMzQ6dHJ1ZTszODA3NTYxMTY2OjU7NTMwMTQ1OTUxOkRlZmF1bHQ7MjA0NjYwMTczNTowOzQyNDg4MzkxODI6ZmFsc2U7MjAzOTkzNjk1NzowOzE1OTIyMTY3NDowOzE4NDk3MjQxNTI6NTsxNDg1OTk2NDE6MDsyMjQ4NTcxODM4OkJhY2t3YXJkOzI2MzA0OTUzMjc6NTszNTAwODkzNzAzOjA7NDExNDE2NjM2ODp0cnVlOzIzODMzMjE5MTQ6ZmFsc2U7MTUwMDQ4ODM2OnRydWU7Mzc0ODA5NTI2Njo1OzM2ODE1ODE4Mzg6NTg7MzQ4OTc1NjU0Mzp0cnVlOzEzODc2ODg0NDowOzI2MjQxNTc5MjY6RGVmYXVsdDs0MDQ3MjE2NDY0OjQ1OzU3ODcwMDA1NDpGRjkwRDlGRjsyNTc1ODM4NTY3OjA7NDQ0ODQxODYwOnRydWU7MTg0MDkzNTU4MzpEb3duOzQ0Nzg1NjIyMDoxODA7MjI1NDk5MjYzNzp7fTsyNjE1NjU5MTk6LTQ1OzIyNzE3NTc5NDc6MDsxMjE1NzcwMDAxOlN0YXRpYzsyMDc2NzAxNjI4OlNwaW47NzQxNTc2MTg0OkF0IFRhcmdldDsyMDA2MTAwMDk1OntDb25zb2xlLEV2ZW50c307MzY2NjQyMzA0MDowOzI4NDgxNjAwNDU6ZmFsc2U7MzU5MTAyMTc0NDpEaXNhYmxlZDsyMDU2MTgwOTAzOkJhY2t3YXJkOzE4MTA4NDI5NDg6MDs0MDEyOTA1NDYwOmZhbHNlOzI4MTAzNjg1NDE6MDszMzA0NjMwNjEyOmZhbHNlOzEzODQ0MjM4NjQ6NTg7MzM4OTg1OTM4OmZhbHNlOzcyNjY5MjUwNzpVbnJpdmFsZWQ7MjA3MDYwMTMwNzo1OzMyNTUwMjkwMjY6dHJ1ZTsxMjAyMDk1NjU1OkRpc2FibGVkOzM2NjgwNzc0MjU6MDs0MzkzNzAzNTI6NTg7MjY5NDUzOTAyMjowOzE2OTc0MDkwNDM6MDs0MTI0ODc5ODM6dHJ1ZTsxMjY1MjQ5OTk4OmZhbHNlOzM0MzI5MTcwNDc6NTs1MTExNTI2MzpmYWxzZTsyMDU4MDMyNzM5OnRydWU7MzQ0NjYzMzY1NDpmYWxzZTsxMTAwNjA4NzI3OjA7MTY2NDMzNzcyNDpFMUUxRTE1QTsxNTcxMDU5MTQ4OjA7MjM5NjExMTgwNDpmYWxzZTszNDcyNTE0MzA0OjA7MjgzNzkxMzYyNjpmYWxzZTsyMTIxMTExNzI0OkRvd247MjM3MDM3NzMwNTp7fTszMjQyOTY5Njc3OjU7NDA2NzU1NjQxNzpmYWxzZTszNjEyMDQ5NTAzOmZhbHNlOzQwODI3OTc5MDg6MTgwOzExNTUxNTQwNDE6NTsxNjAyODIxMzg2OntCb21iLFBpbmcgU3Bpa2UsRG91YmxlIFRhcCxIaWRlIFNob3RzLEJvZHkgQWltLFNhZmUgUG9pbnRzLEZha2UgRHVjayxGcmVlc3RhbmRpbmcsTWluaW11bSBEYW1hZ2UsSGl0IENoYW5jZSxFZGdlIFlhdyxEb3JtYW50IEFpbWJvdCxBaW1ib3QgU2hvdHN9OzIyNjUzNDU3NzE6ZmFsc2U7MTA4MDEyNzA3MjpGRjAwMDBGRjszMzc0MjA1Nzk6MDszMDcyOTkwNzkxOmZhbHNlOzMzNDUxNTYwNTY6MTs2MDk1ODA1Nzo1OzI1ODE3MjkwMjc6dHJ1ZTs4NTg3ODQzMjY6U3RhdGljOzEzNDcwNTE3ODowOzI0Nzk0OTQ3OTQ6NTg7MTY5MTAxOTg3OTpEb3duOzcxMTA3NjUzMjpGRjkwRDlGRjsyNzg1OTMyMjYzOmZhbHNlOzE0ODg2MjExNjI6MDszMDE1MTM3NDU6MDszMDE0Njg0OTE3OjE7MTkyNjc5MDkzMTpCYWNrd2FyZDsxMDI5Njc5MDQzOjQ1OzI1MDU1NjI2Njk6ZmFsc2U7MzM5NzYyNzcyMzowOzM3NDE4NzUwMDU6RGlzYWJsZWQ7Mzg0MjE0NjcwMDp0cnVlOzIyMzg2MzA4NDc6OTA7MzI1MTM4MTQzOnRydWU7MTQ0MzcyODc2Nzo1OzEyNzQ1ODkwNzI6ZmFsc2U7NDE4ODE2Mzc3NjpmYWxzZTs3MjM5MjY0MjM6Sml0dGVyOzI0ODk4NzAyNjA6NTs0NzM0NTU6MTs0MjY4NDM2NjUyOntTbG93IFdhbGssQ3JvdWNoLENyb3VjaCBNb3ZlLEFpcixBaXIrfTszMjM5MTg2MDE5OjU7NDI5MTIyNDEyNTowOzM5OTA2OTE4MDc6RGlzYWJsZWQ7NDcwODI0ODAzOkRlZmF1bHQ7MTkzOTYxNDkyNzpEaXNhYmxlZDsyOTUzNTAzODc0OjEwOzIzNDIxMTc3NTY6MDszMzUzNzk1MzczOjA7MzYzNzA0OTEwNDo1ODs0MjgwMzMwOTI5OjA7Mzk3Mzc3NTU1NTpBdCBUYXJnZXQ7MzQwMzM2NjkwMjoxOzE2MDU2MjI4MzU6RGVmYXVsdDszNjcxMzYyNzI5OjA7MTMzODE1OTY5NjpmYWxzZTs4OTEyNTU3NzA6NTs0MTUwMjUzNjM5OlN0eWxpc2g7MjU4OTQ5MDA1NzowOzI1ODcyNzk5OTY6QmFja3dhcmQ7MTUzNTk2ODE4NTotMzA7MjA5MDMxOTc1ODoxMDs0MTA0NzQ4MjMxOjA7Mzk3MDQ2NDc1MDowOzI5NjUzNjQyMDo1ODsxOTIxMzA1MzgyOk9mZjsyODAzMzU4NDM0OjA7MjE0ODgxNjQ4OmZhbHNlOzI4NzgzNzY4NjU6NTszNzIzNzEzMjY2OjA7MjY4NjYzNzMyODowOzI5NzAyODE0OTM6MTA7NDE2ODEyNDc1Njp7fTsxMjIwNjA1MTk0OkZsaWNrOzIxMzc5MDM3NTQ6dHJ1ZTs5OTE2MDkwOTE6MDszMzQ3NjA4MTQ6e307MzEyMTM0MDA2NzpmYWxzZTsyOTY2NjU1ODY1OjYwMDsyOTgyMzEzMjAyOmZhbHNlOzMyNjg3MTQ5Mjk6NTg7MzQ1NjQwNzM4Nzo1OzQ5NjUxOTY2OmZhbHNlOzM3MDU0MjM3MTpKaXR0ZXI7Mzc2OTQxNTU2OmZhbHNlOzIwOTU3Njc5MDc6MDs0MTMxNDEzODc6RkZGRkZGRkY7OTAyNjQ3MDA3OkRpc2FibGVkOzIzNTA2MzE5NzpEZWZhdWx0OzQyMzM0NTgzMDE6MDsxOTI1NDc4MDY5OlN0YXRpYzsyMDA5NzQ0NzQwOjE7MzU1ODYzNzk4NToxODA7MjA2NTMyNjQ2ODo1OzIwMTYyODA0MDI6MDsxMTA0MzA0NzI3OmZhbHNlOzM3OTI0NDc3MDM6NTg7MzcyMTk4MjMwODo1Ozk3NDk5MjUwNzoxNzc7MTQ1OTkyODI1OTowOzI5Nzg1NTA1MzE6ZmFsc2U7MzE1NzM2OTMzOjU4OzI4NDAwOTM3MTQ6T2ZmOzE0MTU4NzgyNTk6e0ZsYXNoZWQsVGFraW5nIERhbWFnZSxXZWFwb24gTm90IFJlYWR5LFNhZmUgSGVhZH07Mjc3MzQ3NDcxNToxODA7MTAzNDE1MjU2NDpmYWxzZTsxMTI0NjE1OTM3OkF0IFRhcmdldDsxNjUyNTY5MDQ2OnRydWU7Mjg1NTQ5MzM5NTpmYWxzZTs0MjA4NDQxOTY0OjA7MTEzOTIwODYxMjp0cnVlOzIwNTAzODQzMjo1OzEwNDAxODA4MDU6MDsyNzcxMjUwMDA1OjA7MTA1NDc3Nzc1OkRlZmF1bHQ7Mjc4MzA3NjMzNDpmYWxzZTsxNjMxMDA2NjY4OmZhbHNlOzcwODU2MTkwMTpmYWxzZTsyNTUxNDk5MDY1OjA7MzgxMDIyOTk1ODp7fTsyMzUyMTgxMjU2OjA7MjkwNjAyNzcyMDoxOzI3NTQ5Mzg4ODE6MDs2NzIwOTU5NDg6MDs1MjU0MzYyOTI6MDsxMjI1MDMzMTgyOmZhbHNlOzM1MTUzMzIyOTk6MjszMzUxMjAzNjk0OkRvd247MTE5NzQ3MDExMjowOzcxMDU4MTQyMTowOzM0ODg3MTExNDoxOzI4MDQ4NDg3MjA6ZmFsc2U7MTY1MTgyMzUxNDpBdCBUYXJnZXQ7MjgxMTUzNzg1NzpGRjAwMDBGRjszODQzODYwMzE2OjE4MDsxOTA2MjY3MjU1OjA7MTkzNjAwODgyOjA7MTg3MzI2MTgxNDowOzM3OTAwNjkzMTg6MTgwOzQyOTA3MzcyMjM6dHJ1ZTszMTQwMjQzNzEzOjA7Mjk0OTY2Njk4MDowOzMyNjU2MDkwNTk6ZmFsc2U7MzU3NDQ3OTY0MDpEZWZhdWx0OzQwNTYxNzU4ODU6MDsyODE5MjMxMzUyOjA7MTg5NzI1OTg2OmZhbHNlOzk2MTAwODk5Nzo1OzMxODc5OTQxNDI6RG93bjsyMTkwMjIzNTIzOjA7MjI2NTQwODE3ODo1OzIxMzY4MTQwNDk6NTg7Njk1NDQ1Njg5OnRydWU7MjU0MDc4Nzg6NTA7Mzg3NzI1OTczMToxODA7MTUyODEwMDU2MjowOzEwMjg1NTYzMTg6MDszMjIzNTUwNDA4OkRlZmF1bHQ7NDA0OTM4MDE3ODowOzQxMjM4NDMyMjY6MzM7MjcyNjA1MzAyNzowOzI3OTQ5MTEwNTE6NTg7OTYzOTc4Nzc4OjU7MTE3NDQ4MTQxMjpEZWZhdWx0OzE3NTExMTMyNzI6ZmFsc2U7MjAwMjI5NzI3Mjo1MzUzNTM4RjszOTcwODIzMzczOnRydWU7MTg3NTg2ODQyNTowOzMwMzYzODM0NTM6ZmFsc2U7MTgyOTE3NDAzNDpEZWZhdWx0OzI4NTc5MTk4NTg6QXQgVGFyZ2V0OzI3Nzc0NjE1OTU6QmFja3dhcmQ7MzM4NTQ4NTU3ODpmYWxzZTs1NDk5ODYwMzk6ZmFsc2U7MjE0NzM4NDIzNTowOzM0MzA0Njc5OTI6RGVmYXVsdDszODM4MTIyMTA1OnRydWU7MjE4OTgyNDM0NDowOzE5OTM1NjEwMzQ6MTs0MDI2MDQ3MDUxOjU4OzU2MjU5OTQ0MDpEZWZhdWx0OzE1MDg1MDkwMjI6Sml0dGVyOzE5NDc5MjY3NjQ6RGlzYWJsZWQ7MzgzNDQ0NTAyMjp0cnVlOzc3NTUyNTEyNjoxOzIxMzkxMDcyNzM6NDU7OTI4OTE4NjI2OjA7MjQ0NDM5MTU2MjowOzQxMTU3MDU1MDo1OzMzNzA0MjQ5NDA6T2ZmOzI5MTk5NDg2MzY6LTEwOzM2ODA0OTQxODg6ZmFsc2U7ODc1MDgxNDQ3OjE7MjgxNTY1Mzk4OjA7MTg1MTU0OTE3NzoyMTszNjkwOTgzMTc6ZmFsc2U7MzY4MDA0NDc2OTo1OzI5MzcwMTIxOTc6ZmFsc2U7MzA1NzkwMTU4NTo1OzI4OTcxMTI4MjQ6NTg7MjY2ODYxOTg1OjA7MTU5MTkzMzAxNzowOzE4MzI3MjcxMDg6QmFja3dhcmQ7MTkyODM1NTcxMTpmYWxzZTsyODgyMjM3NDk5OjA7Mjg3MzE4MjQ5NjoxOzIwNjEwMTUxNDA6QmFja3dhcmQ7MjU3MDI0NjAxMTo3OzIyMjA1Mjc5ODk6RGlzYWJsZWQ7MzU1NjE4MzI5MzpEZWZhdWx0OzIwNDgyODQwNjk6dHJ1ZTszOTYyNjI2MjYwOjA7NTQ0MzI0MjU0OjU7Mzk0ODkwNDk4MjowOzc1NzIyMDQ6ZmFsc2U7MTkxMjE1NTc0NDo1OzIwNjg3MjE3NDE6U3RhdGljOzI3NDgyMTc0NjA6dHJ1ZTs0MjA3NTYzNDE2OjQ1Ozk5MTE5MTg4OTp0cnVlOzI4ODQ1NTI1NTA6MDszNTI5MDc0MDQ1OkZGOTBEOUZGOzExMDU0MjE4OTE6T2ZmOzE2NTI1NDM5Mzc6MTA7NDExNzc2NjI0NjpEaXNhYmxlZDsyNTY0NTA1NTI0OjE7MTA1NjIyMzk5MzoyOzQzODU5NTg5MjpmYWxzZTsyMzczMjA4NDcwOjU7MTIxNDE2MDMxMzpmYWxzZTs2NDk2MzEzMzE6NDU7NTExMjg3MDI1OnRydWU7MTE5MTI4NTkxOjA7ODc3NDAyMjgxOjA7NjE3MzY2Njc6MTAwOzE4NzUwOTM2NzE6MDszNTYxODY5NzA0Oi04OTsyNzc4NTczMzIzOjE4MDs0MDkzMDY2OTc0OkRpc2FibGVkOzUzMDg3Mzk0NzoxMDsyMTI5MTUxNTkwOnt9OzEwODIyMzI2MzM6dHJ1ZTszOTQwMDU4MjQxOjU7NDE2NDc1MDIzODowOzExNDc1Mzk3NzI6ZmFsc2U7NDE0NjI3MDQ4MjpPbiBQZWVrOzI3NTI1NzQ1NjU6NTszNzM3MjQ0NzAwOjA7MTM5MjIxMDc0OkRlZmF1bHQ7MjkwNjUzNTM5Mzo1OzQwMzY1OTI2Nzp7Q3JvdWNoLENyb3VjaCBNb3ZlLEFpciBLbmlmZSxBaXIgWmV1c307MzA2NzQxMjc5NjowOzc2ODE3NDI2NDowOzQxNTMwMTMyMDA6MTs0MjUwODY3MjAxOnRydWU7MTUxMTU1ODA6RnJvemVuOzI5MTY4MDQxMjU6NDU7NDEwNDI3NjkzMzowOzE2MjU0MzcyMzU6NTg7MTMyMzc1NDk4OjA7NjcxNzM1NTE1OjE7MTAxOTg4MDI2NTpPZmY7MzQ5NjQ1NzQ0ODpTcGluOzIwMDMyMTk4ODk6RGVmYXVsdDsxODc2ODkyMjYzOkRlZmF1bHQ7MjUwODI2OTQ5OTpmYWxzZTszMzM1MjY5Nzg4OmZhbHNlOzk5MDc0MjQzMDo1OzI0NjczMzc5NTk6MTszNjQ2MDA2OTI3OnRydWU7MjY1OTk3MzAxNjp0cnVlOzE2MzYzNzUwNTY6MDsxMzA0OTIwNzU4OnRydWU7MjI4NDM5MjIwOTo1OzQ4NTY2NTc5NDp0cnVlOzE4MjI4MTQ2NzI6T2ZmOzI3ODIyMzcwMzA6RkY5MEQ5RkY7Mzc3ODY0MTcyNTowMEFGRkZGRjs2MTM0MTA4MDowOzQxNTE5MjQyNTQ6e307MzA3Mjk2OTExOTpEb3duOzIzMTMyNzY0MjM6RkY5MEQ5RkY7MTIzNjUzNzk5NTo1ODsyOTcxMTQxNzc3Ont9OzUxMzU5MTA4NjpEaXNhYmxlZDsyNTgxODkzMjUxOjA7MTk1NjI5NDk2ODowOzIwNTE1NzE0ODM6NTsyMTkyNjAzMTU3Ont9OzM2MzI5MTU2OTY6RG93bjsyMjE0MjE3NDM3OjA7MTcxNDI1ODYwNzowOzE0OTMwODcyMjk6RG93bjsxOTk5OTkwMDk2OjQ7NDY4MzkxNzU4OjA7MTk4NDQ4MTIwNTowOzI4NDIyNDE5MTU6MDs5OTMwMDYwNTU6dHJ1ZTsyMjkwMjE5MTg3OjE4MDsxODY2NTk1Mjc4OjA7Mjg1ODI3MTk0OjA7MTYxMjkwNDcyOjE4MDsxMDg5Njg3NzEyOkJhY2t3YXJkOzEwMzA2OTgwNjg6MDsxODEwODU2MDU4OjU4OzM1MTI0MjM3MTY6MDs0MTM5ODI5MTI2OjA7MTA5NjU5MTU0MDowOzU2NjQ0MzAxNjpmYWxzZTs0MTc1Njg3OTM5OjA7MjY3MzA4MDM5MzpTcGluOzE2ODA0NDY6NTsxODc5OTQxNTQwOjA7MzkxNjUyMDAyNjp0cnVlOzMwNTM1ODU2NTA6MDsxMjIzNjIxMzIwOntBaW1ib3QgU2hvdHMsRGFtYWdlIERlYWx0LFB1cmNoYXNlc307MzY0MDc0NjUwOTowOzIxMjEyMTMyMzI6MDsxMzA0NzY1MjI3OjA7NDE4NDc1ODI1NDpGRjkwRDlGRjszNzczMzM0Njc0OjQ1OzQ0Nzk0OTM3NDpEZWZhdWx0OzE3OTc4ODg2Mzk6ZmFsc2U7MTc5OTgxNzgzMzpmYWxzZTszNDM4OTUxNzkzOjA7MzA1MzE1NTA5MzpHbG9iYWw7MjcwNzM1MjA0ODo1OzY1ODUxNjc3OTpEZWZhdWx0OzI0ODU2MDI5MjU6MDsxNTY0OTg0MzkwOjA7MTI4NjY0MDAyOTpPZmY7NTMzNDY5MjM6NTszMzcyMjE0ODE0OjU7MTA4Nzg4MjYxNzpPZmY7MTc3NTAwMTczNTp0cnVlOzExMDcxMDgyNzE6MDszNjE0NzYyMTI5OjA7MjI1ODYzNjA4MjpmYWxzZTszNjcxOTA2Nzc4OnRydWU7MjI1MjczMzg4MzpBdCBUYXJnZXQ7MzE1OTYxNTc0MDp0cnVlOzE0NTcxNTUzOTk6NTszNjcyNjQ4MzY6NTg7MjI4OTgyMTMxOi04OTsxODAxOTU3MTE0OjA7MzU3Njg1MTY5MDpGRkZGRkZGRjsyNjQ4NjM3MDA5OmZhbHNlOzEyMDgxMzkzMjE6MDs0MTExNzk0NjUwOjEzOzEyNjExMDcwOTI6NTsxOTQzNDA5NDA2OjA7MzkzNDE3ODY3Nzo1OzE3NDkwNzc3MTowOzgzOTUzNjk4NjowOzM4MzgxMDQ1Mjc6e307Mzk5NTQxNzMyMzpmYWxzZTszMDUzMDI1NDg3OjE7MTYwMDUxOTIwNDpTY3JpcHQ7NDAxMTM1NzY2NzpPZmY7NDE5MTQ4Nzc5OkRlZmF1bHQ7MjE4MzYyOTU5NTpBdCBUYXJnZXQ7NzY5OTEyOTY5OmZhbHNlOzM4OTQ5MjM0MzA6NDU7MjI3NzA2MTg1MDo1OzM1ODY4MjMzMzQ6MDsyODE4NzgyMzEyOmZhbHNlOzEzMTE5NTY0OTY6MDsxNjk2NTE5MzE3OjU7NDE4MjI1NjkzNzowOzQyMTgyMzkzMzI6dHJ1ZTszNTY4NjcyMDM1OjA7MjQyODA0OTk1ODowOzEwMzgxOTM2OTE6NTs2MDM3NjIzMDpmYWxzZTsyMDYzNzIzNDY3OmZhbHNlOzI3OTI5Njg2NzI6NTg7MzI5NTE1NDM3OjU7NjMxMTY2NTk4OjA7MzcwNDA4NDYwNjowOzc3Mzg0OTUyNTpEb3duOzczOTQ2NzQzMjp7SW5kaWNhdG9yc307ODg4MDI1Mjc0Ont9OzMxNDQyMTU0NDA6MDs2ODE1MzYxODA6NTsxOTk3MDUwOTY0OmZhbHNlOzE3NzQ2MDUzOTQ6MDsyNzY1MzY2MTkzOnt9OzE4OTc0Mzk2ODp4by15YXcubHVhOzM5OTg4ODIyMjI6U3BpbjsxMjYwODY1NDI1OkF0IFRhcmdldDsyOTg1MzkzMDAyOmZhbHNlOzE0NzM2MTkwMjk6NTg7MzA1Mjk3MTM5MjpEZWZhdWx0OzM0Mjc0MTk3NzA6MDsyNTUyMTU4NDgzOmZhbHNlOzQxNjc0MTE5MDc6MDszNDU0OTQ1ODIwOjU7MzczODY3OTk1NzpEZWZhdWx0OzQyNDE5ODg0NDowOzM4NTMzODYyOTY6dHJ1ZTszMTY3MTYwOTM5OmZhbHNlOzIwMzkxMzA5ODA6MDsyMzgxNTc4NzEzOjA7MjM5OTIwMzowOzQwMzYyNjg5MDE6MDsxMjk5ODU5NDM2OjQ1OzEyNDM2NzU5OTA6ZmFsc2U7MTUzODAxOTIxNDo1OzI2NjUwMjY3NDk6NTsxMTUwOTUyNTY5OnRydWU7Mjc1NTQ0NDQ0OTowOzE5NjI2NTcwNjc6dHJ1ZTszMTY2MDMwMDc2Oi01MDsxMjgyNjIzMDA0OjEyMDsxOTQ4NDUxMjUzOjE7MTk2MzU1MTg5Mzp0cnVlOzE3Mzk1NDA0OTM6ZmFsc2U7MTE1Mjg3NzY4MjpmYWxzZTszNTQxMTQ4MTg4OkF0IFRhcmdldDsxOTcwNzIyMTQ6ZmFsc2U7NDA2MDM0NzA0MDp7fTsxMTkwNzYzMDg4OjU7MTI1NDQ4OTUzODpmYWxzZTszNjYxODIxNTk5OjU4OzQ5MDY1MTkyODpPZmY7MzU4NTM0NTc1OjA7MjQzOTc5NjEzNTowOzI1NTMwODExMjk6MDsyMjI2NDA5MzAwOkZGRkZGRkZGOzIwODg4OTI5ODg6RGVmYXVsdDs0OTU3MDEzMTo1OzI4NjE1MTc0MTY6ZmFsc2U7MTgxNjA0ODAzMToxODA7MzMyMjYxMTY3NDpmYWxzZTsyMTE1NTg1MzM3OkJhY2t3YXJkOyIsImRhdGUiOiIxMi8yNi8yMDI0IDAyOjA5IFBNIn0=_xoyaw");
    end);
    v1272:init();
    events.shutdown:set(function()
        -- upvalues: v1272 (ref)
        v1272:flush();
    end);
end;
v72["Defensive Detect"].createmove:set(function(_, v1520, v1521)
    -- upvalues: v59 (ref)
    if not v1521 then
        return;
    else
        local l_m_nTickBase_0 = v1520.m_nTickBase;
        if math.abs(l_m_nTickBase_0 - v59.max_tickbase) > 64 then
            v59.max_tickbase = 0;
        end;
        local v1523 = 0;
        if v59.max_tickbase < l_m_nTickBase_0 then
            v59.max_tickbase = l_m_nTickBase_0;
        elseif l_m_nTickBase_0 < v59.max_tickbase then
            v1523 = math.min(14, math.max(0, v59.max_tickbase - l_m_nTickBase_0 - 1));
        end;
        if v1523 > 0 then
            if v59.max == 0 then
                v59.max = v1523;
            end;
            v59.ticks = v1523;
        else
            v59.max = 0;
            v59.ticks = 0;
        end;
        return;
    end;
end);
v72["Player Information"].createmove:set(function(v1524, v1525, v1526)
    -- upvalues: v58 (ref), l_handler_0 (ref), v635 (ref), v147 (ref), v24 (ref), v50 (ref), v57 (ref)
    if not v1526 then
        return;
    else
        local v1527 = v1525:get_anim_state();
        v58.crouch = v1525.m_flDuckAmount > 0.89;
        v58.velocity = v1527.velocity_length_xy;
        v58.moving = v58.velocity > 5;
        v58.onground = v1527.on_ground and not v1527.landed_on_ground_this_frame;
        v58.landing = v1527.landing and v58.onground;
        local v1528 = 1;
        local l_m_flStamina_0 = v1525.m_flStamina;
        if l_m_flStamina_0 > 0 and v58.onground then
            local v1530 = math.clamp(1 - l_m_flStamina_0 / 100, 0, 1);
            v1528 = v1530 * v1530;
        end;
        v58.velocity_modifier = v1525.m_flVelocityModifier * v1528;
        v58.safe_head_yaw = 0;
        l_handler_0.on_createmove();
        v58.condition = v635.condition(v147["Enabled_Fake Lag"]);
        if v58.condition == "Fake Lag" or v1524.choked_commands == 0 then
            v24:new_frame(globals.tickcount);
            v50:new_frame(globals.tickcount);
            v57.jitter = v57.jitter + 1;
            v58.body_yaw = math.normalize_yaw(v1527.eye_yaw - v1527.abs_yaw);
        end;
        return;
    end;
end);
v72["Reset Overrides"].render:set(function()
    -- upvalues: v60 (ref)
    for _, v1532 in pairs(v60.AA.angles) do
        if v1532.type then
            v1532:override();
        else
            for _, v1534 in pairs(v1532) do
                v1534:override();
            end;
        end;
    end;
end);