local l_format_0 = string.format;
local l_concat_0 = table.concat;
local l_math_0 = math;
local l_table_0 = table;
local l_utils_0 = utils;
local l_common_0 = common;
local l_vector_0 = vector;
local l_color_0 = color;
local v8 = nil;
local v9 = nil;
local v10 = nil;
local v11 = nil;
local v12 = nil;
v8 = require("neverlose/pui");
v9 = require("neverlose/clipboard");
v10 = require("neverlose/base64");
v11 = require("neverlose/md5");
if not _IS_MARKET then
    v12 = require("neverlose/inspect");
end;
l_table_0.contains = function(v13, v14)
    local v15 = false;
    for v16 = 1, #v13 do
        if v13[v16] == v14 then
            v15 = true;
            break;
        end;
    end;
    return v15;
end;
l_table_0.convert = function(v17)
    if v17 == nil then
        return {};
    else
        local v18 = {};
        for v19 = 1, #v17 do
            v18[v17[v19]] = true;
        end;
        return v18;
    end;
end;
l_math_0.normalize_yaw = function(v20)
    return (v20 + 180) % -360 + 180;
end;
l_math_0.breathe = function(v21, v22)
    -- upvalues: l_math_0 (ref)
    if not v21 then
        v21 = 0;
    end;
    if not v22 then
        v22 = 1;
    end;
    local v23 = globals.realtime * v22;
    local v24 = l_math_0.sin(v23 + v21);
    return l_math_0.abs(v24);
end;
string.length = function(v25)
    return 1 / (#string.gsub(v25, "[\128-\191]", "") - 1);
end;
string.fade = function(v26, v27, v28, v29)
    -- upvalues: l_math_0 (ref), l_format_0 (ref)
    local v30 = 0;
    local v31 = string.length(v26);
    return (string.gsub(v26, "(.[\128-\191]*)", function(v32)
        -- upvalues: l_math_0 (ref), v30 (ref), v29 (ref), v27 (ref), v28 (ref), v31 (ref), l_format_0 (ref)
        local v33 = l_math_0.breathe(v30, v29);
        local v34 = v27:lerp(v28, v33);
        v30 = v30 + v31;
        return l_format_0("\a%s%s", v34:to_hex(), v32);
    end));
end;
local function v42(v35, v36)
    -- upvalues: l_table_0 (ref), v11 (ref)
    local v37 = {};
    for v38 in next, v35 do
        l_table_0.insert(v37, v38);
    end;
    l_table_0.sort(v37);
    local v39 = "";
    for _, v41 in ipairs(v37) do
        v39 = v39 .. v41 .. tostring(v35[v41]);
    end;
    v39 = v39 .. v36;
    return v11.sumhexa(v39);
end;
local v43 = db.electus or {};
local v44 = nil;
v44 = {
    title = "Electus", 
    build = "Stable", 
    update = "Dec 13 2023", 
    user = l_common_0.get_username(), 
    screen = render.screen_size()
};
v44.title_log = l_format_0("\v%s \r~ ", string.lower(v44.title));
v44.screen_center = v44.screen * 0.5;
v44.functions = {
    manuals = false, 
    safe_head = false
};
local v45 = nil;
v45 = {
    rage = {
        main = {
            dormant = v8.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
            dt = v8.find("Aimbot", "Ragebot", "Main", "Double Tap", {
                options = "Lag Options"
            }), 
            hide = v8.find("Aimbot", "Ragebot", "Main", "Hide Shots", {
                options = "Options"
            })
        }, 
        selection = {
            hitchance = v8.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
            mindamage = v8.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
        }, 
        safety = {
            body = v8.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
            safe = v8.find("Aimbot", "Ragebot", "Safety", "Safe Points")
        }
    }, 
    aa = {
        angles = {
            enabled = v8.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = v8.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = {
                self = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
                base = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
                offset = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
                hidden = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
            }, 
            yaw_modifier = {
                self = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
                offset = v8.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
            }, 
            body_yaw = {
                self = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
                inverter = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
                left = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
                right = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
                options = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
                freestanding = v8.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            }, 
            freestanding = v8.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
        }, 
        fakelag = {
            self = v8.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = v8.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
        }, 
        misc = {
            fakeduck = v8.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slowwalk = v8.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            legmovement = v8.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    visuals = {
        main = {
            thirdperson = v8.find("Visuals", "World", "Main", "Force Thirdperson")
        }
    }, 
    misc = {
        movement = {
            airduck = v8.find("Miscellaneous", "Main", "Movement", "Air Duck")
        }, 
        ingame = {
            clantag = v8.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
        }, 
        other = {
            windows = v8.find("Miscellaneous", "Main", "Other", "Windows"), 
            logevents = v8.find("Miscellaneous", "Main", "Other", "Log Events")
        }
    }
};
local v46 = nil;
v46 = {};
local v47 = nil;
v47 = {
    data = {}
};
do
    local l_v47_0 = v47;
    l_v47_0.send = function(_, v50, v51)
        -- upvalues: l_v47_0 (ref), v44 (ref), v42 (ref)
        if l_v47_0.data[v51] then
            return;
        else
            l_v47_0.data[v51] = true;
            local v52 = {
                username = v44.user, 
                report = v50
            };
            v52.signature = v42(v52, "lazymind228");
            local v53 = {
                ["Content-Type"] = "application/json"
            };
            network.post("https://electus.mishkat.cloud/reports", v52, v53, function(...)
                return ...;
            end);
            return;
        end;
    end;
    l_v47_0.markup = function(v54, v55, v56)
        -- upvalues: l_format_0 (ref), v44 (ref), l_table_0 (ref), l_common_0 (ref)
        return l_format_0("\n\nUsername: <b>%s</b>\nCallback: <b>%s</b> (%s)\n\n<b>Error:</b>\n<code>%s</code>\n\n<b>Loaded Scripts:</b>\n%s", v44.user, v54, v55, v56, l_table_0.concat(l_common_0.get_active_scripts(), "\n"));
    end;
    local v57 = {};
    local function v61(v58)
        -- upvalues: v57 (ref)
        if v57[v58] == nil then
            v57[v58] = {};
            events[v58]:set(function(_)
                -- upvalues: v57 (ref), v58 (ref)
                local v60 = v57[v58];
                v60.local_player = entity.get_local_player();
                v60.is_valid = v60.local_player ~= nil and v60.local_player:is_alive();
            end);
            return v57[v58];
        else
            return v57[v58];
        end;
    end;
    local v78 = {
        __index = function(v62, v63)
            -- upvalues: v61 (ref), l_v47_0 (ref), v44 (ref)
            local v64 = events[v63];
            return {
                set = function(_, v66)
                    -- upvalues: v61 (ref), v63 (ref), l_v47_0 (ref), v44 (ref), v62 (ref), v64 (ref)
                    local v67 = v61(v63);
                    local v68 = nil;
                    v68 = _IS_MARKET and function(v69)
                        -- upvalues: v66 (ref), v67 (ref), l_v47_0 (ref), v44 (ref), v62 (ref), v63 (ref)
                        local v70 = nil;
                        local v71 = nil;
                        if v69 == nil then
                            local l_status_0, l_result_0 = pcall(v66, v67.local_player, v67.is_valid);
                            v71 = l_result_0;
                            v70 = l_status_0;
                        else
                            local l_status_1, l_result_1 = pcall(v66, v69, v67.local_player, v67.is_valid);
                            v71 = l_result_1;
                            v70 = l_status_1;
                        end;
                        if not v70 then
                            return l_v47_0.send(v44.user, l_v47_0.markup(v62.name, v63, v71), v62.name);
                        else
                            return v71;
                        end;
                    end or function(v76)
                        -- upvalues: v66 (ref), v67 (ref)
                        if v76 == nil then
                            return v66(v67.local_player, v67.is_valid);
                        else
                            return v66(v76, v67.local_player, v67.is_valid);
                        end;
                    end;
                    v64:set(v68);
                end
            };
        end, 
        __tostring = function(v77)
            return v77.name;
        end
    };
    local v79 = {};
    local function v81(v80)
        -- upvalues: v79 (ref), v78 (ref)
        if v79[v80] == nil then
            v79[v80] = setmetatable({
                name = v80
            }, v78);
        end;
        return v79[v80];
    end;
    setmetatable(v46, {
        __index = function(_, v83)
            -- upvalues: v81 (ref)
            return v81(v83);
        end
    });
end;
v47 = nil;
v47 = {};
local v84 = {};
local v85 = {};
local v86 = {};
local v87 = {};
local v88 = -1;
local l_angles_0 = v45.aa.angles;
for v90, v91 in next, l_angles_0 do
    local v92 = v91.type == nil;
    v86[v90] = v92;
    if v92 then
        v85[v90] = {};
        for v93, _ in next, v91 do
            v85[v90][v93] = {
                [1] = 0, 
                [2] = -1
            };
        end;
    else
        v85[v90] = {
            [1] = 0, 
            [2] = -1
        };
    end;
end;
do
    local l_v84_0, l_v85_0, l_v86_0, l_v87_0, l_v88_0, l_l_angles_0_0 = v84, v85, v86, v87, v88, l_angles_0;
    local v108 = {
        run = function(v101)
            -- upvalues: l_v88_0 (ref), l_math_0 (ref), l_v85_0 (ref), l_v86_0 (ref)
            l_v88_0 = l_math_0.max(v101.layer, l_v88_0);
            for v102, v103 in next, v101.overrides do
                local v104 = l_v85_0[v102];
                if l_v86_0[v102] then
                    for v105, v106 in next, v103 do
                        if v105 ~= "__mt" and v104[v105][2] <= v101.layer then
                            v104[v105][1] = v106;
                            v104[v105][2] = v101.layer;
                        end;
                    end;
                else
                    v104[1] = v103;
                    v104[2] = v101.layer;
                end;
            end;
        end, 
        tick = function(v107)
            v107.overrides = {};
        end
    };
    local v117 = {
        __newindex = function(v109, v110, v111)
            -- upvalues: l_v86_0 (ref)
            if l_v86_0[v110] ~= nil then
                if not l_v86_0[v110] then
                    v109.overrides[v110] = v111;
                end;
            else
                print("[Anti Aim] Failed to index", v110);
            end;
        end, 
        __index = function(v112, v113)
            -- upvalues: v108 (ref), l_v86_0 (ref)
            if v108[v113] then
                return v108[v113];
            else
                if l_v86_0[v113] ~= nil then
                    if l_v86_0[v113] then
                        if v112.overrides[v113] == nil then
                            v112.overrides[v113] = {};
                            v112.overrides[v113].__mt = setmetatable({}, {
                                __newindex = function(_, v115, v116)
                                    -- upvalues: v112 (ref), v113 (ref)
                                    v112.overrides[v113][v115] = v116;
                                end
                            });
                        end;
                        return v112.overrides[v113].__mt;
                    end;
                else
                    print("[Anti Aim] Failed to index", v113);
                end;
                return;
            end;
        end
    };
    v47.new = function(v118, v119)
        -- upvalues: l_v84_0 (ref), l_format_0 (ref), l_v87_0 (ref), v117 (ref)
        assert(l_v84_0[v118] == nil, l_format_0("Layer '%s' already exist.", v118));
        assert(l_v87_0[v119] == nil, l_format_0("Priority %d already taken by another layer.", v119));
        l_v87_0[v119] = true;
        l_v84_0[v118] = {
            name = v118, 
            layer = v119, 
            overrides = {}
        };
        return setmetatable(l_v84_0[v118], v117);
    end;
    v47.createmove = function()
        -- upvalues: l_l_angles_0_0 (ref), l_v85_0 (ref), l_v86_0 (ref), l_v88_0 (ref)
        for _, v121 in next, l_l_angles_0_0 do
            if not v121.type then
                for _, v123 in next, v121 do
                    v123:override();
                end;
            else
                v121:override();
            end;
        end;
        for v124, v125 in next, l_v85_0 do
            if l_v86_0[v124] then
                for v126, v127 in next, v125 do
                    if v127[2] ~= -1 then
                        l_l_angles_0_0[v124][v126]:override(v127[1]);
                        v127[2] = -1;
                    else
                        l_l_angles_0_0[v124][v126]:override();
                    end;
                end;
            elseif v125[2] ~= -1 then
                l_l_angles_0_0[v124]:override(v125[1]);
                v125[2] = -1;
            else
                l_l_angles_0_0[v124]:override();
            end;
        end;
        l_v88_0 = -1;
    end;
end;
v84 = nil;
v84 = {
    condition = "Stand", 
    in_duck = false, 
    on_ground = false, 
    moving = false, 
    command = -1, 
    packets = 0, 
    teams = {
        [1] = "CT", 
        [2] = "T"
    }, 
    team = {
        [3] = "CT", 
        [2] = "T"
    }, 
    conditions = {
        [1] = "Global", 
        [2] = "Stand", 
        [3] = "Move", 
        [4] = "Slow Walk", 
        [5] = "Air", 
        [6] = "Air Crouch", 
        [7] = "Crouch", 
        [8] = "Move Crouch", 
        [9] = "Fake Lag"
    }
};
v84.createmove = function(v128, v129, _)
    -- upvalues: v84 (ref)
    local v131 = v129:get_anim_state();
    if v131 == nil then
        return;
    else
        if v128.choked_commands == 0 then
            v84.packets = v84.packets + 1;
            v84.command = v84.command * -1;
        end;
        v84.moving = v131.velocity_length_xy > 5;
        v84.on_ground = v131.on_ground and not v131.landed_on_ground_this_frame;
        v84.in_duck = v129.m_flDuckAmount > 0.89;
        return;
    end;
end;
v85 = v84.conditions;
do
    local l_v85_1 = v85;
    v84.get_condition = function(v133)
        -- upvalues: v84 (ref), v45 (ref), l_v85_1 (ref)
        local v134 = v84.in_duck or v45.aa.misc.fakeduck.value;
        if not (v45.rage.main.dt.value or v45.rage.main.hide.value) and not v133 then
            return l_v85_1[9];
        elseif not v84.on_ground then
            return l_v85_1[(not not v134 or v45.misc.movement.airduck.value) and 6 or 5];
        elseif v134 then
            return l_v85_1[v84.moving and 8 or 7];
        elseif v84.moving then
            return l_v85_1[v45.aa.misc.slowwalk.value and 4 or 3];
        else
            return l_v85_1[2];
        end;
    end;
end;
v85 = nil;
v85 = {
    white = l_color_0(), 
    accent = l_color_0("f9b9b7"), 
    watermark = l_color_0(55, 55, 55)
};
v86 = nil;
v86 = {};
v87 = l_utils_0.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
v88 = function(v135, v136, v137, v138, v139)
    -- upvalues: l_math_0 (ref)
    local v140 = v135(v138, v136, v137 - v136, v139);
    if type(v140) == "number" then
        if l_math_0.abs(v137 - v140) <= 0.01 then
            return v137;
        else
            local v141 = v140 % 1;
            if v141 < 0.001 then
                return l_math_0.floor(v140);
            elseif v141 > 0.999 then
                return l_math_0.ceil(v140);
            end;
        end;
    end;
    return v140;
end;
l_angles_0 = {};
do
    local l_v87_1, l_v88_1, l_l_angles_0_1 = v87, v88, l_angles_0;
    local function v153(v145, v146, v147, v148)
        -- upvalues: l_v87_1 (ref), l_math_0 (ref), l_v88_1 (ref)
        local v149 = type(v145.value);
        local v150 = type(v147);
        if v150 == "boolean" then
            v147 = v147 and 1 or 0;
            v150 = "number";
        end;
        assert(v149 == v150, string.format("type mismatch, expected %s (received %s)", v149, v150));
        if v147 ~= v145.to then
            v145.clock = 0;
            v145.from = v145.value;
            v145.to = v147;
        end;
        local v151 = globals.frametime / l_v87_1();
        local v152 = v146 or 0.15;
        if v145.clock == v152 then
            return v147;
        elseif v151 <= 0 and v152 <= v151 then
            v145.clock = 0;
            v145.from = v147;
            v145.to = v147;
            v145.value = v147;
            return v147;
        else
            v145.clock = l_math_0.min(v145.clock + v151, v152);
            v145.value = l_v88_1(v148 or v145.easings, v145.from, v145.to, v145.clock, v152);
            return v145.value;
        end;
    end;
    l_l_angles_0_1.__metatable = false;
    l_l_angles_0_1.__call = v153;
    l_l_angles_0_1.__index = l_l_angles_0_1;
    v86.new = function(v154, v155)
        -- upvalues: l_l_angles_0_1 (ref)
        if type(v154) == "boolean" then
            v154 = v154 and 1 or 0;
        end;
        local v160 = {
            clock = 0, 
            value = not v154 and 0 or v154, 
            easings = v155 or function(v156, v157, v158, v159)
                return v158 * v156 / v159 + v157;
            end
        };
        return setmetatable(v160, l_l_angles_0_1);
    end;
end;
v87 = nil;
v87 = {};
v88 = nil;
v87.home = {};
l_angles_0 = v8.create("\v\f<house>  \rHome", {
    [1] = {
        [1] = "info", 
        [2] = "Info", 
        [3] = 1
    }, 
    [2] = {
        [1] = "buttons", 
        [2] = "Social", 
        [3] = 1
    }, 
    [3] = {
        [1] = "configs", 
        [2] = "Configs", 
        [3] = 2
    }
});
local v161 = nil;
v87.info = {};
v87.info.user = l_angles_0.info:label(l_format_0("\v\f<user>\t\rUser: \v%s", v44.user));
v87.info.update = l_angles_0.info:label(l_format_0("\v\f<pen-to-square>\t\rLast Update: \v%s", v44.update));
local v162 = nil;
v87.buttons = {};
v87.buttons.discord = l_angles_0.buttons:button("\v\f<discord>  \rDiscord", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/AE2xMDSbWN");
end, true);
v87.buttons.verify = l_angles_0.buttons:button("\v\f<badge-check>  \rVerification", nil, true);
v87.buttons.verify:set_callback(function(v163)
    -- upvalues: v44 (ref), v42 (ref), v9 (ref)
    v163:disabled(true);
    local v164 = {
        branch = "Stable", 
        username = v44.user
    };
    v164.signature = v42(v164, "brandog");
    local v165 = {
        ["Content-Type"] = "application/json"
    };
    network.post("https://electus.mishkat.cloud/verify", v164, v165, function(v166)
        -- upvalues: v9 (ref), v163 (ref)
        if v166 == nil or #v166 == 0 then
            return;
        else
            local l_status_2, l_result_2 = pcall(json.parse, v166);
            if not l_status_2 then
                return;
            elseif not l_result_2.success then
                return print("Something went wrong with verification, error: \aFF0000FF", l_result_2.error);
            else
                print("Your verification code is ready, and copied to your clipboard: \a{Link Active}", l_result_2.code);
                cvar.play:call("buttons\\bell1");
                v9.set(l_result_2.code);
                v163:disabled(false);
                return;
            end;
        end;
    end);
end);
local v169 = nil;
v87.configs = {};
v87.configs.export = l_angles_0.configs:button("\v\f<download>  \rExport", nil, true);
v87.configs.import = l_angles_0.configs:button("\v\f<upload>  \rImport", nil, true);
v87.configs.default = l_angles_0.configs:button("\v\f<file-check>  \rDefault", nil, true);
l_angles_0 = nil;
v161 = v8.create("\v\f<screwdriver-wrench>  \rMain", {
    [1] = {
        [1] = "rage", 
        [2] = "Ragebot", 
        [3] = 1
    }, 
    [2] = {
        [1] = "visuals", 
        [2] = "Visuals", 
        [3] = 2
    }, 
    [3] = {
        [1] = "view", 
        [2] = "Viewmodel", 
        [3] = 2
    }
});
v162 = nil;
v87.rage = {};
v87.rage.logs = v161.rage:switch("Aimbot Logs", false, "", function(v170)
    -- upvalues: v85 (ref)
    local v171 = {
        events = v170:selectable("Events", {
            [1] = "Aimbot Logs", 
            [2] = "Damage Dealt"
        }), 
        output = v170:selectable("Output", {
            [1] = "Console", 
            [2] = "Events"
        }), 
        hit = v170:color_picker("Hit Color", v85.accent), 
        miss = v170:color_picker("Miss Color")
    };
    v171.hit:depend({
        [1] = nil, 
        [2] = true, 
        [1] = v171.events
    });
    v171.miss:depend({
        [1] = nil, 
        [2] = "Aimbot Logs", 
        [1] = v171.events
    });
    return v171, true;
end);
v169 = nil;
v87.visuals = {};
v87.visuals.indicators = v161.visuals:switch("Crosshair Indicators", false, "", {
    [1] = nil, 
    [2] = true, 
    [1] = v85.accent
});
v87.visuals.watermark = v161.visuals:combo("Watermark", {
    [1] = "Bottom", 
    [2] = "Left", 
    [3] = "Right"
}, "", {
    [1] = v85.accent
});
local v172 = nil;
v87.view = {};
v87.view.viewmodel = v161.view:switch("Override Viewmodel", false, "", function(v173)
    local v174 = {
        fov = v173:slider("FOV", -1800, 1800, tonumber(cvar.viewmodel_fov:string()) * 10, 0.1), 
        x = v173:slider("Offset X", -1800, 1800, tonumber(cvar.viewmodel_offset_x:string()) * 10, 0.1), 
        y = v173:slider("Offset Y", -1800, 1800, tonumber(cvar.viewmodel_offset_y:string()) * 10, 0.1), 
        z = v173:slider("Offset Z", -1800, 1800, tonumber(cvar.viewmodel_offset_z:string()) * 10, 0.1), 
        reset = v173:button("Reset", nil, true)
    };
    v174.reset:set_callback(function(_)
        -- upvalues: v174 (ref)
        for v176, v177 in next, v174 do
            if v176 ~= "reset" then
                v177:reset();
            end;
        end;
    end);
    return v174, true;
end);
v87.view.aspect = v161.view:switch("Override Aspect Ratio", false, "", function(v178)
    return {
        ratio = v178:slider("Ratio", 49, 180, cvar.r_aspectratio:float(), 0.01, function(v179)
            if v179 == 49 then
                return "Off";
            else
                return;
            end;
        end)
    }, true;
end);
v161 = nil;
v87.antiaim = {};
v162 = v8.create("\v\f<rotate-left>  \rAnti Aim", {
    [1] = {
        [1] = "main", 
        [2] = "Main", 
        [3] = 1
    }, 
    [2] = {
        [1] = "builder", 
        [2] = "Builder", 
        [3] = 2
    }
});
v87.antiaim.manuals = v162.main:combo("Manual Yaw", {
    [1] = "Disabled", 
    [2] = "Left", 
    [3] = "Right", 
    [4] = "Forward", 
    [5] = "Backward"
}, "", function(v180)
    return {
        disablers = v180:switch("Use Static Yaw")
    };
end);
v87.antiaim.defensive = v162.main:selectable("Defensive Conditions", {
    [1] = "Stand", 
    [2] = "Move", 
    [3] = "Slow Walk", 
    [4] = "Air", 
    [5] = "Air Crouch", 
    [6] = "Crouch", 
    [7] = "Move Crouch"
});
v87.antiaim.defensive_aa = v162.main:switch("Defensive AA", false, "", function(v181)
    return {
        pitch = v181:combo("Pitch", {
            [1] = "Down", 
            [2] = "Up", 
            [3] = "Half Down", 
            [4] = "Half Up", 
            [5] = "Random"
        }), 
        yaw = v181:combo("Yaw", {
            [1] = "Default", 
            [2] = "Sideways", 
            [3] = "Forward", 
            [4] = "Random"
        })
    }, true;
end);
v87.antiaim.safe_head = v162.main:selectable("Safe Head", {
    [1] = "Stand", 
    [2] = "Slow Walk", 
    [3] = "Crouch", 
    [4] = "Air Crouch", 
    [5] = "Air Knife", 
    [6] = "Air Zeus"
});
v87.antiaim.mode = v162.main:combo("Mode", {
    [1] = "Conditional", 
    [2] = "Preset"
});
v87.antiaim.preset = v162.main:combo("Preset", {
    [1] = "Waiting..."
}):depend({
    [1] = nil, 
    [2] = "Preset", 
    [1] = v87.antiaim.mode
});
v169 = nil;
v87.angles = {};
v87.antiaim.team = v162.builder:combo("Player Team", v84.teams);
v87.antiaim.condition = v162.builder:combo("Player Condition", v84.conditions);
for _, v183 in next, v84.conditions do
    local v184 = {};
    do
        local l_v184_0 = v184;
        for _, v187 in next, v84.teams do
            l_v184_0[v187] = {};
            if v183 ~= v84.conditions[1] then
                l_v184_0[v187].enable = v162.builder:switch(l_format_0("Enable %s\n%s%s", v183, v187, v183)):depend({
                    [1] = v87.antiaim.team, 
                    [2] = v187
                }, {
                    [1] = v87.antiaim.condition, 
                    [2] = v183
                });
            end;
            l_v184_0[v187].pitch = v162.builder:combo(l_format_0("Pitch\n%s%s", v183, v187), v45.aa.angles.pitch:list()):depend({
                [1] = v87.antiaim.team, 
                [2] = v187
            }, {
                [1] = v87.antiaim.condition, 
                [2] = v183
            }, l_v184_0[v187].enable);
            l_v184_0[v187].yaw = v162.builder:combo(l_format_0("Yaw\n%s%s", v183, v187), v45.aa.angles.yaw.self:list(), false, function(v188)
                -- upvalues: v45 (ref)
                local v189 = {
                    base = v188:combo("Base", v45.aa.angles.yaw.base:list()), 
                    mode = v188:combo("Mode", {
                        [1] = "180", 
                        [2] = "Left / Right"
                    }), 
                    offset = v188:slider("Offset", -180, 180, 0), 
                    left = v188:slider("Left Offset", -180, 180, 0), 
                    right = v188:slider("Right Offset", -180, 180, 0), 
                    delay = v188:switch("Delayed Switch"), 
                    delay_tick = v188:slider("Ticks", 2, 20, 5, 1, "tk")
                };
                v189.offset:depend({
                    [1] = nil, 
                    [2] = "180", 
                    [1] = v189.mode
                });
                v189.left:depend({
                    [1] = nil, 
                    [2] = "Left / Right", 
                    [1] = v189.mode
                });
                v189.right:depend({
                    [1] = nil, 
                    [2] = "Left / Right", 
                    [1] = v189.mode
                });
                v189.delay:depend({
                    [1] = nil, 
                    [2] = "Left / Right", 
                    [1] = v189.mode
                });
                v189.delay_tick:depend({
                    [1] = nil, 
                    [2] = "Left / Right", 
                    [1] = v189.mode
                }, v189.delay);
                return v189;
            end):depend({
                [1] = v87.antiaim.team, 
                [2] = v187
            }, {
                [1] = v87.antiaim.condition, 
                [2] = v183
            }, l_v184_0[v187].enable);
            l_v184_0[v187].yaw_modifier = v162.builder:combo(l_format_0("Yaw Modifier\n%s%s", v183, v187), v45.aa.angles.yaw_modifier.self:list(), false, function(v190)
                return {
                    offset = v190:slider("Offset", -180, 180, 0), 
                    randomize = v190:slider("Randomize", 0, 180, 0, 1, function(v191)
                        if v191 == 0 then
                            return "Off";
                        else
                            return v191;
                        end;
                    end)
                };
            end):depend({
                [1] = v87.antiaim.team, 
                [2] = v187
            }, {
                [1] = v87.antiaim.condition, 
                [2] = v183
            }, l_v184_0[v187].enable);
            l_v184_0[v187].body_yaw = v162.builder:switch(l_format_0("Body Yaw\n%s%s", v183, v187), false, "", function(v192)
                -- upvalues: v45 (ref)
                return {
                    inverter = v192:switch("Inverter"), 
                    left = v192:slider("Left Limit", 0, 60, 60), 
                    right = v192:slider("Right Limit", 0, 60, 60), 
                    options = v192:selectable("Options", v45.aa.angles.body_yaw.options:list()), 
                    freestanding = v192:combo("Freestanding", v45.aa.angles.body_yaw.freestanding:list())
                };
            end):depend({
                [1] = v87.antiaim.team, 
                [2] = v187
            }, {
                [1] = v87.antiaim.condition, 
                [2] = v183
            }, l_v184_0[v187].enable);
            l_v184_0[v187].copy = v162.builder:button(l_format_0("Copy to %s\n%s", v187 == "CT" and "T" or "CT", v183), nil, true):depend({
                [1] = v87.antiaim.team, 
                [2] = v187
            }, {
                [1] = v87.antiaim.condition, 
                [2] = v183
            }, l_v184_0[v187].enable);
            do
                local l_v187_0 = v187;
                l_v184_0[l_v187_0].copy:set_callback(function(_)
                    -- upvalues: l_v187_0 (ref), l_v184_0 (ref)
                    local v195 = l_v187_0 == "CT" and "T" or "CT";
                    for v196, v197 in next, l_v184_0[l_v187_0] do
                        if v196 ~= "copy" then
                            l_v184_0[v195][v196]:set(l_v184_0[l_v187_0][v196]:get());
                            for v198, _ in next, v197[1] do
                                l_v184_0[v195][v196][v198]:set(l_v184_0[l_v187_0][v196][v198]:get());
                            end;
                        end;
                    end;
                end);
                v87.angles[v183] = l_v184_0;
            end;
        end;
    end;
end;
v162.builder:depend({
    [1] = nil, 
    [2] = "Conditional", 
    [1] = v87.antiaim.mode
});
v88 = nil;
v88 = {
    reset = false
};
v88.reset_backups = function()
    -- upvalues: v88 (ref), v45 (ref)
    if v88.reset then
        v45.rage.main.dt.options:override();
        v45.rage.main.hide.options:override();
        v88.reset = false;
    end;
end;
v46.Defensive.createmove:set(function(_, _, _)
    -- upvalues: v87 (ref), v88 (ref), v84 (ref), l_table_0 (ref), v45 (ref)
    local l_value_0 = v87.antiaim.defensive.value;
    if #l_value_0 == 0 then
        return v88.reset_backups();
    else
        local v204 = v84.get_condition(true);
        if not l_table_0.contains(l_value_0, v204) then
            return v88.reset_backups();
        else
            v45.rage.main.dt.options:override("Always On");
            v45.rage.main.hide.options:override("Break LC");
            v88.reset = true;
            return;
        end;
    end;
end);
l_angles_0 = nil;
l_angles_0 = {};
v161 = v47.new("Defensive AA", 8);
do
    local l_v161_0 = v161;
    v46["Defensive AA"].createmove:set(function(_, _, _)
        -- upvalues: v87 (ref), v44 (ref), v45 (ref), l_utils_0 (ref), v84 (ref), l_v161_0 (ref), l_math_0 (ref)
        if not v87.antiaim.defensive_aa.value then
            return;
        elseif v44.functions.manuals or v45.aa.angles.freestanding.value and rage.antiaim:get_target(true) then
            return;
        else
            local l_value_1 = v87.antiaim.defensive_aa.pitch.value;
            local v210 = 0;
            local v211 = l_utils_0.random_float(45, 65);
            if l_value_1 == "Up" then
                v210 = -89;
            elseif l_value_1 == "Half Down" then
                v210 = v211;
            elseif l_value_1 == "Half Up" then
                v210 = v211 * -1;
            elseif l_value_1 == "Random" then
                v210 = l_utils_0.random_float(-89, 89);
            end;
            v211 = v87.antiaim.defensive_aa.yaw.value;
            local v212 = 0;
            if v211 == "Sideways" then
                v212 = 90 * v84.command;
            elseif v211 == "Forward" then
                v212 = 180 * v84.command;
            elseif v211 == "Random" then
                v212 = l_utils_0.random_float(-180, 180);
            end;
            l_v161_0:tick();
            l_v161_0.yaw.hidden = true;
            if l_value_1 ~= "Down" then
                rage.antiaim:override_hidden_pitch(v210);
            end;
            if v211 ~= "Default" then
                rage.antiaim:override_hidden_yaw_offset(l_math_0.normalize_yaw(v212));
            end;
            l_v161_0:run();
            return;
        end;
    end);
end;
v161 = nil;
v161 = {};
v162 = v47.new("Conditional", 1);
do
    local l_v162_0 = v162;
    v46.Conditional.createmove:set(function(_, v215, _)
        -- upvalues: v87 (ref), v84 (ref), l_utils_0 (ref), l_v162_0 (ref), l_math_0 (ref)
        if v87.antiaim.mode.value ~= "Conditional" then
            return;
        else
            local v217 = v84.team[v215.m_iTeamNum];
            local v218 = v84.get_condition(not v87.angles["Fake Lag"][v217].enable.value);
            v84.condition = v218;
            if not v87.angles[v218][v217].enable.value then
                v218 = "Global";
            end;
            local v219 = v87.angles[v218][v217];
            local l_value_2 = v219.yaw.offset.value;
            local l_value_3 = v219.yaw_modifier.offset.value;
            local l_value_4 = v219.yaw_modifier.randomize.value;
            if v219.yaw.mode.value == "Left / Right" then
                if v219.yaw.delay.value then
                    local l_value_5 = v219.yaw.delay_tick.value;
                    local v224 = l_value_5 * 2;
                    local v225 = l_value_5 <= v84.packets % v224;
                    rage.antiaim:inverter(v225);
                end;
                l_value_2 = rage.antiaim:inverter() and v219.yaw.left.value or v219.yaw.right.value;
            end;
            if l_value_4 ~= 0 then
                l_value_3 = l_value_3 + l_utils_0.random_int(-l_value_4, l_value_4);
            end;
            l_v162_0:tick();
            l_v162_0.pitch = v219.pitch.value;
            l_v162_0.yaw.self = v219.yaw.value;
            l_v162_0.yaw.base = v219.yaw.base.value;
            l_v162_0.yaw.offset = l_math_0.normalize_yaw(l_value_2);
            l_v162_0.yaw_modifier.self = v219.yaw_modifier.value;
            l_v162_0.yaw_modifier.offset = l_math_0.normalize_yaw(l_value_3);
            l_v162_0.body_yaw.self = v219.body_yaw.value;
            l_v162_0.body_yaw.left = v219.body_yaw.left.value;
            l_v162_0.body_yaw.right = v219.body_yaw.right.value;
            l_v162_0.body_yaw.inverter = v219.body_yaw.inverter.value;
            l_v162_0.body_yaw.options = v219.body_yaw.options.value;
            l_v162_0.body_yaw.freestanding = v219.body_yaw.freestanding.value;
            l_v162_0:run();
            return;
        end;
    end);
end;
v162 = nil;
v162 = {
    items = v8.setup(v87, true)
};
v162.export = function()
    -- upvalues: v162 (ref), v10 (ref), l_concat_0 (ref), v44 (ref)
    local v226 = v162.items:save();
    local l_status_3, l_result_3 = pcall(msgpack.pack, v226);
    if not l_status_3 then
        return;
    else
        local l_status_4, l_result_4 = pcall(v10.encode, l_result_3);
        if not l_status_4 then
            return;
        else
            return l_concat_0({
                [1] = nil, 
                [2] = "::", 
                [3] = nil, 
                [4] = "::", 
                [1] = v44.title, 
                [3] = l_result_4, 
                [5] = v44.title
            });
        end;
    end;
end;
v162.import = function(v231)
    -- upvalues: v9 (ref), l_concat_0 (ref), v44 (ref), l_format_0 (ref), v10 (ref), v162 (ref)
    local v232 = v231 or v9.get();
    if v232 == nil then
        return false, "Input is empty.";
    else
        local v233 = false;
        for v234 in string.gmatch(v232, l_concat_0({
            [1] = nil, 
            [2] = "::", 
            [3] = "(.-)", 
            [4] = "::", 
            [1] = v44.title, 
            [5] = v44.title
        })) do
            local l_v234_0 = v234;
            v233 = true;
            v232 = l_v234_0;
            break;
        end;
        if not v233 then
            return false, l_format_0("Config is not compatible with %s.", v44.title);
        else
            local l_status_5, l_result_5 = pcall(v10.decode, v232);
            if not l_status_5 then
                return false, "Failed to decode configuration.";
            else
                local l_status_6, l_result_6 = pcall(msgpack.unpack, l_result_5);
                if not l_status_6 then
                    return false, "Failed to parse configuration.";
                else
                    v162.items:load(l_result_6);
                    return true;
                end;
            end;
        end;
    end;
end;
v87.configs.export:set_callback(function()
    -- upvalues: v9 (ref), v162 (ref)
    v9.set(v162.export());
    print("Successfully copied config.");
end);
v87.configs.import:set_callback(function()
    -- upvalues: v162 (ref)
    local v240, v241 = v162.import();
    if not v240 then
        return print(v241);
    else
        print("Successfully loaded config.");
        return;
    end;
end);
v87.configs.default:set_callback(function(v242)
    -- upvalues: v162 (ref)
    v242:disabled(true);
    network.get("https://electus.mishkat.cloud/config", {}, function(v243)
        -- upvalues: v162 (ref), v242 (ref)
        if not v243 or #v243 == 0 then
            return print("No internet connection.");
        else
            local v244, v245 = v162.import(v243);
            if not v244 then
                return print(v245);
            else
                print("Successfully loaded default config.");
                v242:disabled(false);
                return;
            end;
        end;
    end);
end);
v169 = nil;
v169 = {
    alpha = v86.new(), 
    align = v86.new()
};
v172 = {};
do
    local l_v172_0 = v172;
    v169.add_hotkey = function(v247, v248, v249)
        -- upvalues: l_v172_0 (ref), v86 (ref)
        l_v172_0[#l_v172_0 + 1] = {
            name = v247, 
            animation = v86.new(), 
            active = function()
                -- upvalues: v248 (ref), v249 (ref)
                return v248.value == v249;
            end
        };
    end;
    v169.add_hotkey("DT", v45.rage.main.dt, true);
    v169.add_hotkey("HS", v45.rage.main.hide, true);
    v169.add_hotkey("FS", v45.aa.angles.freestanding, true);
    v169.add_hotkey("DA", v45.rage.main.dormant, true);
    v169.add_hotkey("FD", v45.aa.misc.fakeduck, true);
    v169.add_hotkey("BAIM", v45.rage.safety.body, "Force");
    local v250 = nil;
    v250 = {};
    for _, v252 in next, l_v172_0 do
        v250[v252.name] = render.measure_text(2, nil, v252.name);
    end;
    v250.heading = render.measure_text(2, nil, l_format_0("ELECTUS %s", string.upper(v44.build)));
    v46.Indicators.render:set(function(v253, v254)
        -- upvalues: v169 (ref), v87 (ref), v44 (ref), v85 (ref), l_format_0 (ref), v250 (ref), l_vector_0 (ref), v84 (ref), l_v172_0 (ref)
        local v255 = v169.alpha(0.2, v87.visuals.indicators.value and v254);
        if v255 < 0.001 then
            return;
        else
            local l_m_bIsScoped_0 = v253.m_bIsScoped;
            l_m_bIsScoped_0 = v169.align(0.1, not l_m_bIsScoped_0);
            local v257 = v44.screen_center:clone();
            v257.x = v257.x + (5 - 5 * l_m_bIsScoped_0);
            v257.y = v257.y + 20;
            local l_value_6 = v87.visuals.indicators.color.value;
            l_value_6.a = 255 * v255;
            local v259 = v85.white:alpha_modulate(255 * v255);
            local v260 = l_format_0("ELECTUS \a%s%s", l_value_6:to_hex(), string.upper(v44.build));
            local l_heading_0 = v250.heading;
            render.text(2, l_vector_0(v257.x - l_heading_0.x * 0.5 * l_m_bIsScoped_0, v257.y), v259, nil, v260);
            v257.y = v257.y + 8;
            l_heading_0 = string.upper(v84.condition);
            local v262 = render.measure_text(2, nil, l_heading_0);
            render.text(2, l_vector_0(v257.x - v262.x * 0.5 * l_m_bIsScoped_0, v257.y), l_value_6, nil, l_heading_0);
            v257.y = v257.y + 8;
            v262 = 0;
            for _, v264 in next, l_v172_0 do
                local v265 = v264.animation(0.15, v264.active());
                if v265 >= 0.001 then
                    local l_name_0 = v264.name;
                    local v267 = v250[l_name_0];
                    render.text(2, l_vector_0(v257.x - v267.x * 0.5 * l_m_bIsScoped_0, v257.y + v262), v259:alpha_modulate(v265, true), nil, l_name_0);
                    v262 = v262 + 8 * v265;
                end;
            end;
            return;
        end;
    end);
end;
v172 = nil;
v172 = {
    export = function()
        -- upvalues: v162 (ref), v10 (ref)
        local v268 = v162.items:save("angles");
        local l_status_7, l_result_7 = pcall(msgpack.pack, v268);
        if not l_status_7 then
            return;
        else
            local l_status_8, l_result_8 = pcall(v10.encode, l_result_7);
            if not l_status_8 then
                return;
            else
                return l_result_8;
            end;
        end;
    end, 
    parse = function(v273, v274)
        -- upvalues: v10 (ref), v162 (ref)
        if not v273 then
            return;
        else
            local l_status_9, l_result_9 = pcall(v10.decode, v273);
            if not l_status_9 then
                return;
            else
                local l_status_10, l_result_10 = pcall(msgpack.unpack, l_result_9);
                if not l_status_10 then
                    return;
                else
                    if v274 then
                        v162.items:load(l_result_10, {
                            [1] = "angles"
                        });
                    end;
                    return l_result_10.angles;
                end;
            end;
        end;
    end
};
network.get("https://mishkat.cloud/electus/presets.json", {}, function(v279)
    -- upvalues: v172 (ref), l_table_0 (ref), v87 (ref), v43 (ref)
    if v279 == nil or #v279 == 0 then
        return print("Failed to fetch presets.");
    else
        local l_status_11, l_result_11 = pcall(json.parse, v279);
        if not l_status_11 then
            return print("Failed to parse presets.");
        else
            local v282 = {};
            for v283, v284 in next, l_result_11 do
                v282[#v282 + 1] = v283;
                v172[v283] = v172.parse(v284);
            end;
            l_table_0.sort(v282);
            if #v282 == 0 then
                return;
            else
                v87.antiaim.preset:update(v282);
                if v43.last_preset then
                    v87.antiaim.preset:set(v43.last_preset);
                end;
                return;
            end;
        end;
    end;
end);
local v285 = v47.new("Presets", 2);
do
    local l_v285_0 = v285;
    v46.Presets.createmove:set(function(_, v288, _)
        -- upvalues: v87 (ref), v84 (ref), v172 (ref), l_utils_0 (ref), l_v285_0 (ref), l_math_0 (ref)
        if v87.antiaim.mode.value ~= "Preset" then
            return;
        else
            local v290 = v84.team[v288.m_iTeamNum];
            local v291 = v172[v87.antiaim.preset:get()];
            if not v291 then
                return;
            else
                local v292 = v84.get_condition(not v291["Fake Lag"][v290].enable);
                v84.condition = v292;
                if not v291[v292][v290].enable then
                    v292 = "Global";
                end;
                local v293 = v291[v292][v290];
                local l_offset_0 = v293["~yaw"].offset;
                local l_offset_1 = v293["~yaw_modifier"].offset;
                local l_randomize_0 = v293["~yaw_modifier"].randomize;
                if v293["~yaw"].mode == "Left / Right" then
                    if v293["~yaw"].delay then
                        local l_delay_tick_0 = v293["~yaw"].delay_tick;
                        local v298 = l_delay_tick_0 * 2;
                        local v299 = l_delay_tick_0 <= v84.packets % v298;
                        rage.antiaim:inverter(v299);
                    end;
                    l_offset_0 = rage.antiaim:inverter() and v293["~yaw"].left or v293["~yaw"].right;
                end;
                if l_randomize_0 ~= 0 then
                    l_offset_1 = l_offset_1 + l_utils_0.random_int(-l_randomize_0, l_randomize_0);
                end;
                l_v285_0:tick();
                l_v285_0.pitch = v293.pitch;
                l_v285_0.yaw.self = v293.yaw;
                l_v285_0.yaw.base = v293["~yaw"].base;
                l_v285_0.yaw.offset = l_math_0.normalize_yaw(l_offset_0);
                l_v285_0.yaw_modifier.self = v293.yaw_modifier;
                l_v285_0.yaw_modifier.offset = l_math_0.normalize_yaw(l_offset_1);
                l_v285_0.body_yaw.self = v293.body_yaw;
                l_v285_0.body_yaw.left = v293["~body_yaw"].left;
                l_v285_0.body_yaw.right = v293["~body_yaw"].right;
                l_v285_0.body_yaw.inverter = v293["~body_yaw"].inverter;
                l_v285_0.body_yaw.options = v293["~body_yaw"].options;
                l_v285_0.body_yaw.freestanding = v293["~body_yaw"].freestanding;
                l_v285_0:run();
                return;
            end;
        end;
    end);
    local v300 = {
        Copy = function()
            -- upvalues: v9 (ref), v172 (ref)
            v9.set(v172.export());
            print("Copied preset.");
        end, 
        Import = function()
            -- upvalues: v172 (ref), v9 (ref)
            v172.parse(v9.get(), true);
        end
    };
    local v302 = v8.create("\v\f<rotate-left>  \rAnti Aim", "Presets", 2):depend({
        [1] = v87.antiaim.mode, 
        [2] = function(v301)
            return v301.value == "Conditional" and not _IS_MARKET;
        end
    });
    for v303, v304 in next, v300 do
        v302:button(v303, v304, true);
    end;
end;
v285 = nil;
v285 = {
    offsets = {
        Backward = 0, 
        Forward = 180, 
        Right = 90, 
        Left = -90
    }
};
local v305 = v47.new("Manuals", 7);
do
    local l_v305_0 = v305;
    v46.Manuals.createmove:set(function(_, _, _)
        -- upvalues: v44 (ref), v87 (ref), l_v305_0 (ref), v285 (ref)
        v44.functions.manuals = false;
        local l_value_7 = v87.antiaim.manuals.value;
        if l_value_7 == "Disabled" then
            return;
        else
            l_v305_0:tick();
            l_v305_0.yaw.self = "Backward";
            l_v305_0.yaw.base = "Local view";
            l_v305_0.yaw.offset = v285.offsets[l_value_7];
            if v87.antiaim.manuals.disablers.value then
                l_v305_0.yaw_modifier.self = "Disabled";
                l_v305_0.body_yaw.options = "";
                rage.antiaim:inverter(false);
            end;
            l_v305_0.freestanding = false;
            l_v305_0:run();
            v44.functions.manuals = true;
            return;
        end;
    end);
end;
v305 = nil;
v305 = {};
local v311 = {
    Stand = {
        [3] = {
            right_limit = 20, 
            offset = 5, 
            inverter = false, 
            left_limit = 20
        }, 
        [2] = {
            right_limit = 25, 
            offset = 0, 
            inverter = false, 
            left_limit = 20
        }
    }, 
    Crouch = {
        [3] = {
            right_limit = 60, 
            offset = -5, 
            inverter = true, 
            left_limit = 35
        }, 
        [2] = {
            right_limit = 26, 
            offset = 17, 
            inverter = false, 
            left_limit = 20
        }
    }, 
    ["Slow Walk"] = {
        [3] = {
            right_limit = 20, 
            offset = 5, 
            inverter = false, 
            left_limit = 20
        }, 
        [2] = {
            right_limit = 25, 
            offset = 0, 
            inverter = false, 
            left_limit = 20
        }
    }, 
    ["Air Crouch"] = {
        [3] = {
            right_limit = 25, 
            offset = 0, 
            inverter = false, 
            left_limit = 25
        }, 
        [2] = {
            right_limit = 25, 
            offset = 0, 
            inverter = false, 
            left_limit = 25
        }
    }, 
    [107] = {
        [3] = {
            right_limit = 60, 
            offset = 0, 
            inverter = true, 
            left_limit = 60
        }, 
        [2] = {
            right_limit = 60, 
            offset = 0, 
            inverter = true, 
            left_limit = 60
        }
    }, 
    [268] = {
        [3] = {
            right_limit = 30, 
            offset = 23, 
            inverter = false, 
            left_limit = 60
        }, 
        [2] = {
            right_limit = 60, 
            offset = 17, 
            inverter = false, 
            left_limit = 20
        }
    }
};
local l_sv_gravity_0 = cvar.sv_gravity;
do
    local l_v311_0, l_l_sv_gravity_0_0 = v311, l_sv_gravity_0;
    local function v321(v315, v316, v317)
        -- upvalues: l_l_sv_gravity_0_0 (ref), l_utils_0 (ref)
        local l_tickinterval_0 = globals.tickinterval;
        local l_m_vecVelocity_0 = v315.m_vecVelocity;
        local v320 = v317:clone();
        v320.x = v320.x + l_m_vecVelocity_0.x * l_tickinterval_0 * v316;
        v320.y = v320.y + l_m_vecVelocity_0.y * l_tickinterval_0 * v316;
        if not v315.m_hGroundEntity then
            v320.z = v320.z + l_m_vecVelocity_0.z * l_tickinterval_0 * v316 - l_l_sv_gravity_0_0:float() * l_tickinterval_0;
        end;
        return l_utils_0.trace_hull(v317, v320, v315.m_vecMins, v315.m_vecMaxs, v315).end_pos:clone();
    end;
    local v322 = v47.new("Safe Head", 15);
    v46["Safe Head"].createmove:set(function(_, v324, _)
        -- upvalues: v44 (ref), v87 (ref), v84 (ref), l_table_0 (ref), l_utils_0 (ref), v321 (ref), l_vector_0 (ref), l_v311_0 (ref), v322 (ref)
        v44.functions.safe_head = false;
        local l_value_8 = v87.antiaim.safe_head.value;
        if #l_value_8 == 0 then
            return;
        elseif v44.functions.manuals then
            return;
        else
            local v327 = v324:get_player_weapon();
            if v327 == nil then
                return;
            else
                local v328 = 0;
                local v329 = false;
                local v330 = false;
                if not v84.on_ground and not v329 then
                    local v331 = v327:get_classid();
                    v328 = v331;
                    if v331 == 107 then
                        v329 = l_table_0.contains(l_value_8, "Air Knife");
                    elseif v331 == 268 then
                        v329 = l_table_0.contains(l_value_8, "Air Zeus");
                    end;
                    v330 = v329;
                end;
                if not v329 and not l_table_0.contains(l_value_8, v84.get_condition(true)) then
                    return;
                else
                    v44.functions.safe_head = v330;
                    if not v44.functions.safe_head then
                        local v332 = v324:get_origin();
                        local v333 = entity.get_threat();
                        local _ = 0;
                        if v333 and v333:is_alive() then
                            local v335 = v333:get_origin();
                            if (v330 and v332.z - 1 or v335.z + 5) < v332.z then
                                local v336 = l_utils_0.trace_bullet(v333, v321(v333, 5, v333:get_eye_position()), v324:get_hitbox_position(0) + l_vector_0(0, 0, 6));
                                v44.functions.safe_head = v336 > 0;
                            end;
                        end;
                    end;
                    if not v44.functions.safe_head then
                        return;
                    else
                        local v337 = v330 and l_v311_0[v328] or l_v311_0[v84.condition];
                        if not v337 then
                            return;
                        else
                            local v338 = v337[v324.m_iTeamNum];
                            if not v338 then
                                return;
                            else
                                v322:tick();
                                v322.yaw.self = "Backward";
                                v322.yaw.base = "At Target";
                                v322.yaw.offset = v338.offset;
                                v322.yaw_modifier.self = "Disabled";
                                v322.body_yaw.self = true;
                                v322.body_yaw.options = "";
                                v322.body_yaw.left = v338.left_limit;
                                v322.body_yaw.right = v338.right_limit;
                                rage.antiaim:inverter(v338.inverter);
                                v322:run();
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end);
end;
v311 = nil;
v311 = {
    hitgroups = {
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
    verb = {
        knife = "Knifed", 
        inferno = "Burned", 
        hegrenade = "Naded"
    }, 
    push = function(v339)
        -- upvalues: v87 (ref), l_table_0 (ref)
        local l_value_9 = v87.rage.logs.output.value;
        if #l_value_9 == 0 then
            return;
        else
            l_value_9 = l_table_0.convert(l_value_9);
            if l_value_9.Console then
                print_raw(v339);
            end;
            if l_value_9.Events then
                print_dev(v339);
            end;
            return;
        end;
    end, 
    format = function(v341, v342)
        local v343 = "\a" .. v342:to_hex();
        return (string.gsub(v341, "[\v\r]", {
            ["\r"] = "\aDEFAULT", 
            ["\v"] = v343
        }));
    end
};
v46["Aimbot Logs"].aim_ack:set(function(v344, _, _)
    -- upvalues: v87 (ref), l_table_0 (ref), v44 (ref), l_format_0 (ref), v311 (ref), l_concat_0 (ref)
    if not v87.rage.logs.value then
        return;
    elseif not l_table_0.contains(v87.rage.logs.events.value, "Aimbot Logs") then
        return;
    else
        local l_target_0 = v344.target;
        if l_target_0 == nil then
            return;
        elseif v344.state then
            local l_value_10 = v87.rage.logs.miss.value;
            local v349 = {
                nil, 
                nil, 
                "due to ", 
                [1] = v44.title_log, 
                [2] = l_format_0("Missed at \v%s\r ", l_target_0:get_name()), 
                l_format_0("\v%s\r ", v344.state), 
                l_format_0("(backtrack: \v%d\r | damage: \v%d\r)", v344.backtrack, v344.wanted_damage)
            };
            local v350 = v311.format(l_concat_0(v349), l_value_10);
            v311.push(v350);
            return;
        else
            local l_value_11 = v87.rage.logs.hit.value;
            local v352 = {
                nil, 
                nil, 
                "in the ", 
                nil, 
                "for ", 
                [1] = v44.title_log, 
                [2] = l_format_0("Hit \v%s\r ", l_target_0:get_name()), 
                [4] = l_format_0("\v%s\r ", v311.hitgroups[v344.hitgroup]), 
                l_format_0("\v%d\r damage ", v344.damage), 
                l_format_0("(\v%d\r health remaining)", l_target_0.m_iHealth)
            };
            local v353 = v311.format(l_concat_0(v352), l_value_11);
            v311.push(v353);
            return;
        end;
    end;
end);
v46["Aimbot Logs"].player_hurt:set(function(v354, v355, _)
    -- upvalues: v87 (ref), l_table_0 (ref), v311 (ref), v44 (ref), l_format_0 (ref), l_concat_0 (ref)
    if not v87.rage.logs.value then
        return;
    elseif not l_table_0.contains(v87.rage.logs.events.value, "Damage Dealt") then
        return;
    else
        local v357 = entity.get(v354.userid, true);
        local v358 = entity.get(v354.attacker, true);
        if v357 == v355 or v358 ~= v355 then
            return;
        else
            local v359 = v311.verb[v354.weapon];
            if not v359 then
                return;
            else
                local l_value_12 = v87.rage.logs.hit.value;
                local v361 = {
                    [1] = nil, 
                    [2] = nil, 
                    [3] = nil, 
                    [4] = "for ", 
                    [1] = v44.title_log, 
                    [2] = v359, 
                    [3] = l_format_0(" \v%s\r ", v357:get_name()), 
                    [5] = l_format_0("\v%s \rdamage ", v354.dmg_health or 0), 
                    [6] = v354.health ~= 0 and l_format_0("(\v%d \rhealth remaining)", v354.health or 0) or ""
                };
                local v362 = v311.format(l_concat_0(v361), l_value_12);
                v311.push(v362);
                return;
            end;
        end;
    end;
end);
l_sv_gravity_0 = nil;
l_sv_gravity_0 = {};
local v363 = {
    fov = cvar.viewmodel_fov, 
    x = cvar.viewmodel_offset_x, 
    y = cvar.viewmodel_offset_y, 
    z = cvar.viewmodel_offset_z
};
do
    local l_v363_0 = v363;
    l_sv_gravity_0.reset = function()
        -- upvalues: l_v363_0 (ref)
        for _, v366 in next, l_v363_0 do
            v366:float(tonumber(v366:string()) or 0);
        end;
    end;
    l_sv_gravity_0.set = function()
        -- upvalues: v87 (ref), l_v363_0 (ref), l_sv_gravity_0 (ref)
        if v87.view.viewmodel.value then
            for v367, v368 in next, l_v363_0 do
                v368:float(v87.view.viewmodel[v367].value * 0.1, true);
            end;
        else
            l_sv_gravity_0.reset();
        end;
    end;
    v87.view.viewmodel:set_callback(l_sv_gravity_0.set, true);
    for v369, _ in next, l_v363_0 do
        v87.view.viewmodel[v369]:set_callback(l_sv_gravity_0.set, true);
    end;
    v46.Viewmodel.shutdown:set(l_sv_gravity_0.reset);
end;
v363 = nil;
v363 = {
    should_reset = false, 
    start = cvar.r_aspectratio:float()
};
v363.reset = function()
    -- upvalues: v363 (ref)
    if v363.should_reset then
        cvar.r_aspectratio:float(v363.start);
        v363.should_reset = false;
    end;
end;
v363.set = function()
    -- upvalues: v87 (ref), v363 (ref)
    local v371 = v87.view.aspect.value and v87.view.aspect.ratio.value / 100 or v363.start;
    cvar.r_aspectratio:float(v371);
    if v371 == 0.49 then
        v363.should_reset = true;
        v363.reset();
    else
        v363.should_reset = v371 ~= 0.49;
    end;
end;
v87.view.aspect:set_callback(v363.set, true);
v87.view.aspect.ratio:set_callback(v363.set, true);
v46["Aspect Ratio"].shutdown:set(v363.reset);
local v372 = nil;
v372 = {};
local v373 = {
    Bottom = l_vector_0(v44.screen_center.x, v44.screen.y - 15), 
    Left = l_vector_0(60, v44.screen_center.y), 
    Right = l_vector_0(v44.screen.x - 60, v44.screen_center.y)
};
do
    local l_v373_0 = v373;
    v46.Watermark.render:set(function(_, _)
        -- upvalues: l_v373_0 (ref), v87 (ref), v85 (ref), v44 (ref), l_format_0 (ref)
        local v377 = l_v373_0[v87.visuals.watermark.value];
        local v378 = string.fade("E L E C T U S", v87.visuals.watermark.color.value, v85.watermark, -1.5);
        if v44.build == "Beta" then
            v378 = l_format_0("%s\aC84545FF [BETA]", v378);
        end;
        render.text(1, v377, v85.white, "c", v378);
    end);
end;
v46.Localplayer.createmove:set(v84.createmove);
v46["AA Handler"].createmove:set(v47.createmove);
v46.Database.shutdown:set(function()
    -- upvalues: v43 (ref), v87 (ref)
    v43.last_preset = v87.antiaim.preset:get();
    db.electus = v43;
end);
ui.sidebar("Electus", "\240\159\145\187");