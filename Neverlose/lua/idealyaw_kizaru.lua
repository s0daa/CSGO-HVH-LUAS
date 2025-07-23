-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = true;
local v0 = nil;
local v1 = nil;
local v2 = nil;
local v3 = nil;
local v4 = nil;
v0 = require("neverlose/pui");
v1 = require("neverlose/base64");
v2 = require("neverlose/md5");
v3 = require("neverlose/inspect");
v4 = require("neverlose/websockets");
local v5 = {
    name = "idealyaw", 
    online = 0, 
    latest_update = "Nov 22 2023", 
    verification = "ideal-yaw", 
    alpha = 1, 
    version = "LIVE", 
    user = common.get_username(), 
    screen = render.screen_size(), 
    screen_center = render.screen_size() / 2, 
    conditions = {
        [1] = "Shared", 
        [2] = "Standing", 
        [3] = "Moving", 
        [4] = "Slow Walking", 
        [5] = "Air", 
        [6] = "Air + Crouch", 
        [7] = "Crouching", 
        [8] = "In Use", 
        [9] = "Fake Lag"
    }, 
    presets = {
        [1] = "Builder", 
        [2] = "Center", 
        [3] = "Meta", 
        [4] = "Hybrid"
    }, 
    preset_icons = {
        [1] = "\226\154\153\239\184\143", 
        [2] = "\240\159\152\136", 
        [3] = "\240\159\146\128", 
        [4] = "\240\159\152\142"
    }, 
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
    functions = {
        legit = false, 
        freestand = false, 
        peek = false, 
        safe = false, 
        edge = false
    }
};
local v6 = {
    moving = false, 
    in_duck = false, 
    velocity = 0, 
    defensive = false, 
    tickbase = 0, 
    jitter = -1, 
    jitter_count = 0, 
    condition = "Standing", 
    on_land = false, 
    on_ground = false, 
    miss_timer = globals.realtime
};
local v7 = {
    Console = 3, 
    Small = 2, 
    Default = 1, 
    Bold = render.load_font("Verdana", 12, "adb"), 
    verdana_bold = render.load_font("Verdana", 12, "ad"), 
    calibri_bold = render.load_font("Calibri Bold", 23, "ad")
};
local v8 = nil;
v8 = {
    white = color(), 
    red = color(255, 25, 25), 
    default = color("96C83CFF"), 
    link_active = ui.get_style("Link Active"), 
    inactive = color("1313137F"), 
    idle = color(200, 60), 
    green = color(155, 200, 21, 200), 
    piss = color(255, 175, 70, 200), 
    plant_ok = color(255, 255, 130, 200), 
    plant_warning = color(255, 255, 135, 200), 
    gradient_in = color(0, 0, 0, 60), 
    gradient_out = color(0, 0, 0, 0), 
    white_idle = color(255, 200), 
    skeet_red = color("ff0032")
};
local v9 = nil;
v9 = {};
local v10 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
local v11 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
local v12 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
do
    local l_v10_0, l_v11_0, l_v12_0 = v10, v11, v12;
    local function v17(...)
        -- upvalues: l_v11_0 (ref)
        local v16 = tostring(table.concat({
            ...
        }));
        l_v11_0(v16, string.len(v16));
    end;
    local function v22()
        -- upvalues: l_v10_0 (ref), l_v12_0 (ref)
        local v18 = l_v10_0();
        if v18 > 0 then
            local v19 = ffi.typeof("char[?]")(v18);
            l_v12_0(0, v19, v18);
            local v20 = ffi.string(v19, v18 - 1);
            local v21 = nil;
            v21 = v20:find("_idealyaw");
            if v21 then
                v20 = v20:sub(1, v21);
            end;
            return v20;
        else
            return;
        end;
    end;
    v9.set = v17;
    v9.get = v22;
end;
v10 = nil;
v10 = {};
v11 = utils.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
v12 = function(v23, v24, v25, v26, v27)
    local v28 = v23(v26, v24, v25 - v24, v27);
    if type(v28) == "number" then
        if math.abs(v25 - v28) <= 0.01 then
            return v25;
        else
            local v29 = v28 % 1;
            if v29 < 0.001 then
                return math.floor(v28);
            elseif v29 > 0.999 then
                return math.ceil(v28);
            end;
        end;
    end;
    return v28;
end;
local v30 = {};
do
    local l_v11_1, l_v12_1, l_v30_0 = v11, v12, v30;
    local function v42(v34, v35, v36, v37)
        -- upvalues: l_v11_1 (ref), l_v12_1 (ref)
        local v38 = type(v34.value);
        local v39 = type(v36);
        if v39 == "boolean" then
            v36 = v36 and 1 or 0;
            v39 = "number";
        end;
        assert(v38 == v39, string.format("type mismatch, expected %s (received %s)", v38, v39));
        if v36 ~= v34.to then
            v34.clock = 0;
            v34.from = v34.value;
            v34.to = v36;
        end;
        local v40 = globals.frametime / l_v11_1();
        local v41 = v35 or 0.15;
        if v34.clock == v41 then
            return v36;
        elseif v40 <= 0 and v41 <= v40 then
            v34.clock = 0;
            v34.from = v36;
            v34.to = v36;
            v34.value = v36;
            return v36;
        else
            v34.clock = math.min(v34.clock + v40, v41);
            v34.value = l_v12_1(v37 or v34.easings, v34.from, v34.to, v34.clock, v41);
            return v34.value;
        end;
    end;
    l_v30_0.__metatable = false;
    l_v30_0.__call = v42;
    l_v30_0.__index = l_v30_0;
    v10.new = function(_, v44, v45)
        -- upvalues: l_v30_0 (ref)
        if type(v44) == "boolean" then
            v44 = v44 and 1 or 0;
        end;
        local v50 = {
            clock = 0, 
            value = not v44 and 0 or v44, 
            easings = v45 or function(v46, v47, v48, v49)
                return v48 * v46 / v49 + v47;
            end
        };
        return setmetatable(v50, l_v30_0);
    end;
end;
v11 = nil;
v11 = {
    RAGE = {
        double_tap = {
            main = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
            options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
        }, 
        hide_shots = {
            main = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
            options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
        }, 
        auto_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
        delay_shot = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage", "Delay Shot"), 
        auto_scope = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope"), 
        min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        body_aim_disablers = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers"), 
        safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
    }, 
    AA = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
                base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
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
            freestanding = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
                disablers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
                body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            }, 
            extended_angles = {
                main = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
                pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
                roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
            }
        }, 
        other = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }, 
        fake_lag = {
            main = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
            variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
        }
    }, 
    VISUALS = {
        scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
        thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson"), 
        hitmarker = ui.find("Visuals", "World", "Other", "Hit Marker")
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
v12 = nil;
v12 = {
    crc32 = function(v51, v52)
        if not v52 then
            v52 = {};
        end;
        local v53 = nil;
        local v54 = nil;
        local v55 = nil;
        if not v52[1] then
            for v56 = 1, 256 do
                v54 = v56 - 1;
                for _ = 1, 8 do
                    v55 = -bit.band(v54, 1);
                    v54 = bit.bxor(bit.rshift(v54, 1), bit.band(3988292384, v55));
                end;
                v52[v56] = v54;
            end;
        end;
        v54 = 4294967295;
        for v58 = 1, #v51 do
            v53 = string.byte(v51, v58);
            v54 = bit.bxor(bit.rshift(v54, 8), v52[bit.band(bit.bxor(v54, v53), 255) + 1]);
        end;
        return bit.band(bit.bnot(v54), 4294967295);
    end, 
    breathe = function(v59, v60)
        local v61 = globals.realtime * (v60 or 1) % math.pi;
        local v62 = math.sin(v61 + (v59 or 0));
        return (math.abs(v62));
    end, 
    format = function(v63, v64)
        -- upvalues: v8 (ref)
        if type(v63) ~= "string" then
            return v63;
        else
            if not v64 then
                v64 = v8.link_active:to_hex();
            else
                v64 = v64:to_hex();
            end;
            return (string.gsub(v63, "[\v\r]", {
                ["\r"] = "\aDEFAULT", 
                ["\v"] = "\a" .. v64
            }));
        end;
    end
};
v30 = cvar.sv_gravity;
do
    local l_v30_1 = v30;
    v12.extrapolate = function(v66, v67, v68)
        -- upvalues: l_v30_1 (ref)
        local l_tickinterval_0 = globals.tickinterval;
        local l_m_vecVelocity_0 = v66.m_vecVelocity;
        local v71 = v68:clone();
        v71.x = v71.x + l_m_vecVelocity_0.x * l_tickinterval_0 * v67;
        v71.y = v71.y + l_m_vecVelocity_0.y * l_tickinterval_0 * v67;
        if not v66.m_hGroundEntity then
            v71.z = v71.z + l_m_vecVelocity_0.z * l_tickinterval_0 * v67 - l_v30_1:float() * l_tickinterval_0;
        end;
        return utils.trace_hull(v68, v71, v66.m_vecMins, v66.m_vecMaxs, v66).end_pos:clone();
    end;
end;
table.convert = function(v72)
    if v72 == nil then
        return {};
    else
        local v73 = {};
        for v74 = 1, #v72 do
            v73[v72[v74]] = true;
        end;
        return v73;
    end;
end;
table.invert = function(v75)
    if v75 == nil then
        return {};
    else
        local v76 = {};
        for v77, v78 in pairs(v75) do
            if v78 then
                v76[#v76 + 1] = v77;
            end;
        end;
        return v76;
    end;
end;
table.search = function(v79, v80)
    local v81 = false;
    for _, v83 in pairs(v79) do
        if v83 == v80 then
            v81 = true;
            break;
        end;
    end;
    return v81;
end;
string.clamp = function(v84, v85, v86)
    local v87 = {};
    local v88 = 1;
    for v89 in string.gmatch(v84, ".[\128-\191]*") do
        local v90 = v88 + 1;
        v87[v88] = v89;
        v88 = v90;
        if v85 < v88 then
            if v86 then
                v87[v88] = v86 == true and "..." or v86;
                break;
            else
                break;
            end;
        end;
    end;
    return table.concat(v87);
end;
string.wave = function(v91, v92, v93, v94)
    -- upvalues: v12 (ref)
    local v95 = 0;
    local v96 = 1 / (#v91:gsub("[\128-\191]", "") - 1);
    local v97 = color();
    return v91:gsub("(.[\128-\191]*)", function(v98)
        -- upvalues: v12 (ref), v95 (ref), v94 (ref), v97 (ref), v92 (ref), v93 (ref), v96 (ref)
        local v99 = v12.breathe(v95, v94);
        v97 = v92:lerp(v93, v99);
        v95 = v95 + v96;
        return string.format("\a%s%s", v97:to_hex(), v98), v97;
    end), v97;
end;
string.gradient = function(v100, v101, v102)
    local v103 = 0;
    local v104 = 1 / (#v100:gsub("[\128-\191]", "") - 1);
    return (v100:gsub("(.[\128-\191]*)", function(v105)
        -- upvalues: v101 (ref), v102 (ref), v103 (ref), v104 (ref)
        local v106 = v101:lerp(v102, v103);
        v103 = v103 + v104;
        return string.format("\a%s%s", v106:to_hex(), v105);
    end));
end;
string.split = function(v107, v108)
    local v109 = {};
    local v110 = string.format("(.-)%s", v108);
    local v111 = 0;
    local v112, v113, v114 = string.find(v107, v110, 1);
    while v112 do
        if v112 ~= 1 or v114 ~= "" then
            table.insert(v109, v114);
        end;
        v111 = v113 + 1;
        local v115, v116, v117 = string.find(v107, v110, v111);
        v114 = v117;
        v113 = v116;
        v112 = v115;
    end;
    if v111 <= #v107 then
        v114 = v107:sub(v111);
        table.insert(v109, v114);
    end;
    return v109;
end;
v30 = nil;
v30 = {
    DEV_MODE = not _IS_MARKET
};
local v118 = nil;
v118 = {};
local v119 = "99w2HabpkgfgUY";
local v120 = "https://mishkat.cloud/exscord/reports";
local function v123(v121, v122)
    -- upvalues: v2 (ref)
    return v2.sumhexa(string.format("reports-%s%s", v121, v122));
end;
local v124 = {};
do
    local l_v119_0, l_v120_0, l_v123_0, l_v124_0 = v119, v120, v123, v124;
    v118.send = function(v129, v130, v131)
        -- upvalues: l_v124_0 (ref), l_v123_0 (ref), l_v119_0 (ref), l_v120_0 (ref)
        if l_v124_0[v131] then
            return false;
        else
            l_v124_0[v131] = true;
            local v132 = l_v123_0(v129, l_v119_0);
            network.post(l_v120_0, {
                username = v129, 
                signature = v132, 
                report = v130
            }, {
                ["Content-Type"] = "application/json"
            }, function(...)

            end);
            return;
        end;
    end;
    v118.markup = function(v133, v134, v135)
        -- upvalues: v5 (ref)
        return string.format("\n\nUsername: <b>%s</b>\nCallback: <b>%s</b> (%s)\n\n<b>Error:</b>\n<code>%s</code>\n\n<b>Loaded Scripts:</b>\n%s", v5.user, v133, v134, v135, table.concat(common.get_active_scripts(), "\n"));
    end;
end;
v119 = {};
do
    local l_v118_0, l_v119_1, l_v120_1, l_v123_1, l_v124_1 = v118, v119, v120, v123, v124;
    l_v120_1 = function(v141)
        -- upvalues: l_v119_1 (ref)
        if l_v119_1[v141] == nil then
            l_v119_1[v141] = {};
            events[v141]:set(function(_)
                -- upvalues: l_v119_1 (ref), v141 (ref)
                local v143 = l_v119_1[v141];
                v143.local_player = entity.get_local_player();
                v143.is_valid = v143.local_player ~= nil and v143.local_player:is_alive();
            end);
            return l_v119_1[v141];
        else
            return l_v119_1[v141];
        end;
    end;
    l_v123_1 = {
        __index = function(v144, v145)
            -- upvalues: l_v120_1 (ref), v30 (ref), l_v118_0 (ref), v5 (ref)
            local v146 = events[v145];
            return {
                set = function(_, v148)
                    -- upvalues: l_v120_1 (ref), v145 (ref), v30 (ref), l_v118_0 (ref), v5 (ref), v144 (ref), v146 (ref)
                    local v149 = l_v120_1(v145);
                    local v150 = nil;
                    v150 = not v30.DEV_MODE and function(v151)
                        -- upvalues: v148 (ref), v149 (ref), l_v118_0 (ref), v5 (ref), v144 (ref), v145 (ref)
                        local v152 = nil;
                        local v153 = nil;
                        if v151 == nil then
                            local l_status_0, l_result_0 = pcall(v148, v149.local_player, v149.is_valid);
                            v153 = l_result_0;
                            v152 = l_status_0;
                        else
                            local l_status_1, l_result_1 = pcall(v148, v151, v149.local_player, v149.is_valid);
                            v153 = l_result_1;
                            v152 = l_status_1;
                        end;
                        if not v152 then
                            return l_v118_0.send(v5.user, l_v118_0.markup(v144.name, v145, v153), v144.name);
                        else
                            return v153;
                        end;
                    end or function(v158)
                        -- upvalues: v148 (ref), v149 (ref)
                        if v158 == nil then
                            return v148(v149.local_player, v149.is_valid);
                        else
                            return v148(v158, v149.local_player, v149.is_valid);
                        end;
                    end;
                    v146:set(v150);
                end
            };
        end, 
        __tostring = function(v159)
            return "events::" .. v159.name;
        end
    };
    l_v124_1 = {};
    local function v161(v160)
        -- upvalues: l_v124_1 (ref), l_v123_1 (ref)
        if l_v124_1[v160] == nil then
            l_v124_1[v160] = setmetatable({
                name = v160
            }, l_v123_1);
        end;
        return l_v124_1[v160];
    end;
    local v164 = {
        __index = function(_, v163)
            -- upvalues: v161 (ref)
            return v161(v163);
        end
    };
    setmetatable(v30, v164);
end;
v118 = nil;
v118 = {};
v119 = v5.screen_center;
v120 = {};
v123 = "";
v124 = false;
local v165 = vector();
local v166 = false;
local v167 = false;
local v168 = false;
local v169 = 20;
local v170 = v119.x + v169;
local v171 = v119.x - v169;
local v172 = nil;
local v173 = ui.create("...");
do
    local l_v119_2, l_v120_2, l_v123_2, l_v124_2, l_v165_0, l_v166_0, l_v167_0, l_v168_0, l_v170_0, l_v171_0, l_v172_0, l_v173_0 = v119, v120, v123, v124, v165, v166, v167, v168, v170, v171, v172, v173;
    v118.add = function(v186, v187, v188)
        -- upvalues: l_v120_2 (ref), l_v173_0 (ref), v5 (ref), v10 (ref), l_v166_0 (ref), l_v165_0 (ref), l_v168_0 (ref), l_v124_2 (ref), l_v123_2 (ref), l_v167_0 (ref), l_v171_0 (ref), l_v170_0 (ref), l_v119_2 (ref)
        l_v120_2[v186] = {
            dragging = false, 
            is_in_b = false, 
            alpha = 1, 
            is_rmb_pressed = false, 
            id = v186, 
            menu = {
                x = l_v173_0:slider(v186 .. "_x", 0, v5.screen.x, v187.x), 
                y = l_v173_0:slider(v186 .. "_y", 0, v5.screen.y, v187.y)
            }, 
            position = v187, 
            size = v188, 
            max = v5.screen - v188, 
            animation = v10:new(), 
            drag = vector(), 
            process = function(v189)
                -- upvalues: l_v166_0 (ref), l_v165_0 (ref), l_v168_0 (ref), l_v124_2 (ref), l_v123_2 (ref), v186 (ref), l_v167_0 (ref), l_v171_0 (ref), l_v170_0 (ref), l_v119_2 (ref)
                if not l_v166_0 then
                    return v189;
                else
                    local l_position_0 = v189.position;
                    local v191 = v189.position + v189.size;
                    local v192 = l_v165_0.x >= l_position_0.x and l_v165_0.y >= l_position_0.y and l_v165_0.x <= v191.x and l_v165_0.y <= v191.y;
                    v189.is_rmb_pressed = v192 and l_v168_0;
                    v189.is_in_b = v192;
                    v189.alpha = v189.animation(0.1, v189.dragging and 0.5 or 1);
                    if v192 or v189.dragging then
                        l_v124_2 = true;
                    end;
                    if (v192 or v189.dragging) and (l_v123_2 == "" or l_v123_2 == v186) and l_v167_0 then
                        l_v123_2 = v186;
                        if not v189.dragging then
                            v189.dragging = true;
                            v189.drag = l_v165_0 - l_position_0;
                        else
                            v189.position = l_v165_0 - v189.drag;
                        end;
                    elseif not l_v167_0 then
                        l_v123_2 = "";
                        v189.dragging = false;
                        v189.drag = vector(0, 0);
                    end;
                    v189.menu.x:set(v189.position.x);
                    v189.menu.y:set(v189.position.y);
                    return v189;
                end;
            end
        };
        if l_v120_2[v186].menu.x:get() ~= v187.x then
            l_v120_2[v186].position = vector(l_v120_2[v186].menu.x:get(), l_v120_2[v186].menu.y:get());
        end;
        l_v120_2[v186].menu.x:visibility(false);
        l_v120_2[v186].menu.y:visibility(false);
        return l_v120_2[v186];
    end;
    ffi.cdef("        int GetAsyncKeyState(int vKey);\n    ");
    v30.Containers.render:set(function()
        -- upvalues: l_v172_0 (ref), l_v124_2 (ref), l_v166_0 (ref), v5 (ref), l_v165_0 (ref), l_v167_0 (ref), l_v168_0 (ref)
        l_v172_0 = nil;
        l_v124_2 = false;
        l_v166_0 = v5.alpha > 0;
        if l_v166_0 then
            l_v165_0 = ui.get_mouse_position();
            l_v167_0 = common.is_button_down(1);
            l_v168_0 = ffi.C.GetAsyncKeyState(2) > 0;
            if l_v168_0 then
                l_v167_0 = false;
            end;
        end;
    end);
    events.mouse_input:set(function()
        -- upvalues: l_v124_2 (ref)
        return not l_v124_2;
    end);
end;
v119 = nil;
v119 = {};
v120 = {};
v123 = v11.AA.angles;
v124 = {};
v165 = {};
for v193, v194 in pairs(v123) do
    v171 = type(v194) == "table";
    v165[v193] = v171;
    if v171 then
        v124[v193] = {};
        for v195, _ in pairs(v194) do
            v124[v193][v195] = {
                [1] = 0, 
                [2] = -1
            };
        end;
    else
        v124[v193] = {
            [1] = 0, 
            [2] = -1
        };
    end;
end;
v166 = {};
v167 = -1;
do
    local l_v120_3, l_v123_3, l_v124_3, l_v165_1, l_v166_1, l_v167_1, l_v168_1, l_v169_0, l_v170_1 = v120, v123, v124, v165, v166, v167, v168, v169, v170;
    l_v168_1 = {
        run = function(v206)
            -- upvalues: l_v167_1 (ref), l_v124_3 (ref), l_v165_1 (ref)
            l_v167_1 = math.max(v206.layer, l_v167_1);
            for v207, v208 in pairs(v206.overrides) do
                local v209 = l_v124_3[v207];
                if l_v165_1[v207] then
                    for v210, v211 in pairs(v208) do
                        if v210 ~= "__mt" and v209[v210][2] <= v206.layer then
                            v209[v210][1] = v211;
                            v209[v210][2] = v206.layer;
                        end;
                    end;
                else
                    v209[1] = v208;
                    v209[2] = v206.layer;
                end;
            end;
        end, 
        tick = function(v212)
            v212.overrides = {};
        end
    };
    l_v169_0 = {
        __newindex = function(v213, v214, v215)
            -- upvalues: l_v165_1 (ref)
            if l_v165_1[v214] ~= nil then
                if not l_v165_1[v214] then
                    v213.overrides[v214] = v215;
                end;
            else
                print("[antiaims] failed to index " .. v214);
            end;
        end, 
        __index = function(v216, v217)
            -- upvalues: l_v168_1 (ref), l_v165_1 (ref)
            if l_v168_1[v217] then
                return l_v168_1[v217];
            else
                if l_v165_1[v217] ~= nil then
                    if l_v165_1[v217] then
                        if v216.overrides[v217] == nil then
                            v216.overrides[v217] = {};
                            v216.overrides[v217].__mt = setmetatable({}, {
                                __newindex = function(_, v219, v220)
                                    -- upvalues: v216 (ref), v217 (ref)
                                    v216.overrides[v217][v219] = v220;
                                end
                            });
                        end;
                        return v216.overrides[v217].__mt;
                    end;
                else
                    print("[antiaims] failed to index " .. v217);
                end;
                return;
            end;
        end
    };
    l_v170_1 = {};
    v119.new = function(v221, v222)
        -- upvalues: l_v120_3 (ref), l_v170_1 (ref), l_v169_0 (ref)
        assert(l_v120_3[v221] == nil, "aa name already user");
        assert(l_v170_1[v222] == nil, "aa layer already user");
        l_v170_1[v222] = true;
        l_v120_3[v221] = {
            name = v221, 
            layer = v222, 
            overrides = {}
        };
        return setmetatable(l_v120_3[v221], l_v169_0);
    end;
    v119.override = -1;
    v119.references = l_v123_3;
    v119.on_createmove = function()
        -- upvalues: l_v123_3 (ref), l_v124_3 (ref), l_v165_1 (ref), l_v166_1 (ref), l_v167_1 (ref)
        for _, v224 in pairs(l_v123_3) do
            if type(v224) == "table" then
                for _, v226 in pairs(v224) do
                    v226:override();
                end;
            else
                v224:override();
            end;
        end;
        for v227, v228 in pairs(l_v124_3) do
            if l_v165_1[v227] then
                for v229, v230 in pairs(v228) do
                    if v230[2] ~= -1 then
                        l_v123_3[v227][v229]:override(v230[1]);
                        v230[2] = -1;
                    else
                        l_v123_3[v227][v229]:override();
                    end;
                end;
            elseif v228[2] ~= -1 then
                l_v123_3[v227]:override(v228[1]);
                v228[2] = -1;
            else
                l_v123_3[v227]:override();
            end;
        end;
        l_v166_1 = {};
        l_v167_1 = -1;
    end;
    v119.condition = function(_, v232)
        -- upvalues: v6 (ref), v11 (ref), v5 (ref)
        local v233 = v6.in_duck or v11.AA.other.fake_duck:get();
        if v232 and rage.exploit:get() == 0 and not v11.RAGE.double_tap.main:get() and not v11.RAGE.hide_shots.main:get() and not v5.functions.legit then
            return v5.conditions[9];
        elseif v5.functions.legit then
            return v5.conditions[8];
        elseif not v6.on_ground then
            return v5.conditions[(not not v233 or v11.MISC.air_duck:get()) and 6 or 5];
        elseif v233 then
            return v5.conditions[7];
        elseif v6.velocity > 2 then
            return v5.conditions[v11.AA.other.slow_walk:get() and 4 or 3];
        else
            return v5.conditions[2];
        end;
    end;
end;
v120 = nil;
v120 = {};
v0.string_recorder.open();
v123 = nil;
v120.information = {};
v120.configs = {};
v124 = v0.create("\226\157\151\239\184\143  Info", {
    [1] = {
        [1] = "info", 
        [2] = "\t\t\t\t\t\t\t\t\a{Active Text}\240\159\145\139 Welcome", 
        [3] = 1
    }, 
    [2] = {
        [1] = "social", 
        [2] = "\t\t\t\t\t\t\t\t\a{Active Text}\240\159\146\173 Social", 
        [3] = 2
    }, 
    [3] = {
        [1] = "recommmendations", 
        [2] = "\t\t\t\t\t\t\a{Active Text}\240\159\148\165 Recommmendations", 
        [3] = 1
    }, 
    [4] = {
        [1] = "configs", 
        [2] = "\t\t\t\t\t\t\a{Active Text}\240\159\147\130 Configurations", 
        [3] = 2
    }
});
v120.information.user = v124.info:label(string.format("\v\f<user>\t\a{Active Text}Welcome back, \v%s \r[\v%s\r]", v5.user, v5.version));
v120.information.update = v124.info:label(string.format("\v\f<tag>\t\a{Active Text}Latest Update: \v%s", v5.latest_update));
v120.information.online = v124.info:label(string.format("\v\f<tiktok>\t\a{Active Text}Online Users: \v%s", v5.online));
v165 = {
    [1] = "Have problems with the script?", 
    [2] = "Want to get a configured config or share what new feature to add?\n\vJoin my discord\r\n"
};
v166 = {
    [1] = "\vHow to Get a Role?\r\n", 
    [2] = "\v1. \rOpen Informations Tab", 
    [3] = "\v2. \rGet your verify code by pressing \r'Copy Verification Code'\r", 
    [4] = "\v3. \rJoin the Discord and pass the CAPTCHA\nyou will see channel \v#verify-idealyaw\r", 
    [5] = "\v4. \rWrite in this channel \v/verify\r and \vcopy code"
};
v120.information.discord = v124.social:button(" \v\f<discord>  \aFFFFFFFFDiscord ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/cAZpSva");
end, true, table.concat(v165, "\n"));
v120.information.verify = v124.social:button(" \v\f<link>  \aFFFFFFFFLink Discord Account ", nil, true, table.concat(v166, "\n")):set_callback(function()
    -- upvalues: v5 (ref), v12 (ref), v1 (ref), v9 (ref)
    local v234 = string.format("%s:%s:%s", v5.user, v5.verification, tostring(math.floor(math.abs(v12.crc32(v5.user) + common.get_timestamp()))));
    v234 = v1.encode(v234, "0ucHJINGekQRUwZWVbPXyYlshz65DfLnpxTtKiFvor4ad9A7M3mSBCE21gjO8q+/=");
    network.get("https://northon.dev/neverlose/discord/get_verification_code.php?data=" .. v234, {}, function(v235)
        -- upvalues: v9 (ref), v12 (ref)
        if v235 == nil or #v235 == 0 then
            return;
        else
            cvar.play:call("ui\\beepclear");
            v9.set(v235);
            print_raw(v12.format(string.format("\videalyaw \r~ Your verification code is ready: \v%s\n\rJoin our discord, then verify by using your code!", v235)));
            return;
        end;
    end);
end);
v120.information.config = v124.recommmendations:button(" \v\f<gear>  \aFFFFFFFFConfig ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/Toq4Jd");
end, true);
v120.information.youtube = v124.recommmendations:button(" \v\f<youtube>  \aFFFFFFFFYoutube ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/Kizaru1337");
end, true);
v120.information.theme = v124.recommmendations:button(" \v\f<brush>  \aFFFFFFFFTheme ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/getitem?c=2HZ1yiKd5NHwCj1p-xZRR5O4agI");
end, true);
v120.configs.export = v124.configs:button(" \v\f<file-export>  \aFFFFFFFFExport ", nil, true);
v120.configs.import = v124.configs:button(" \v\f<file-import>  \aFFFFFFFFImport ", nil, true);
v120.configs.default = v124.configs:button(" \v\f<file-export>  \aFFFFFFFFDefault ", nil, true);
v124 = nil;
v120.rage = {};
v120.visuals = {};
v120.modification = {};
v120.misc = {};
v120.additional = {};
v165 = v0.create("\240\159\140\141 Global", {
    [1] = {
        [1] = "rage", 
        [2] = "\t\t\t\t\t\t\t\t \a{Active Text}\240\159\148\171 Ragebot", 
        [3] = 1
    }, 
    [2] = {
        [1] = "visuals", 
        [2] = "\t\t\t\t\t\t\t\t \a{Active Text}\240\159\150\140 Visuals", 
        [3] = 1
    }, 
    [3] = {
        [1] = "modification", 
        [2] = "\t\t\t\t\t\t\t \a{Active Text}\226\156\168 Modification", 
        [3] = 1
    }, 
    [4] = {
        [1] = "misc", 
        [2] = "\t\t\t\t\t\t\t\t\t \a{Active Text}\226\154\153\239\184\143 Misc", 
        [3] = 2
    }, 
    [5] = {
        [1] = "additional", 
        [2] = "\t\t\t\t\t\t\t   \a{Active Text}\240\159\140\128 Additional", 
        [3] = 2
    }
});
v120.rage.logs = v165.rage:switch("Aimbot Logs", false, "", function(v236)
    local v238 = {
        events = v236:selectable("Events", {
            [1] = "Aimbot Shots", 
            [2] = "Damage Dealt", 
            [3] = "Hurt", 
            [4] = "Purchases"
        }), 
        show = v236:selectable("Show", {
            [1] = "Console", 
            [2] = "Events", 
            [3] = "Notifications"
        }), 
        color = v236:color_picker("Hit Color", color("A2C929FF")), 
        miss_color = v236:color_picker("Miss Color", color("DD1239FF")), 
        missmatch_color = v236:color_picker("Missmatch Color", color("FFC900FF")), 
        purchase_color = v236:color_picker("Purchase Color", color("66CDAAFF")), 
        glow = v236:switch("Shadow Effect", false), 
        offset = v236:slider("Offset", 0, 300, 0, 1, function(v237)
            if v237 == 0 then
                return "Def.";
            else
                return v237 .. "px";
            end;
        end)
    };
    v238.glow:depend({
        [1] = v238.events, 
        [2] = function(v239)
            return #v239.value ~= 0;
        end
    }, {
        [1] = nil, 
        [2] = "Notifications", 
        [1] = v238.show
    });
    v238.color:depend({
        [1] = nil, 
        [2] = "Aimbot Shots", 
        [3] = "Damage Dealt", 
        [1] = v238.events
    });
    v238.miss_color:depend({
        [1] = nil, 
        [2] = "Aimbot Shots", 
        [1] = v238.events
    });
    v238.missmatch_color:depend({
        [1] = nil, 
        [2] = "Aimbot Shots", 
        [1] = v238.events
    });
    v238.purchase_color:depend({
        [1] = nil, 
        [2] = "Purchases", 
        [1] = v238.events
    });
    v238.offset:depend({
        [1] = nil, 
        [2] = "Notifications", 
        [1] = v238.show
    });
    return v238, true;
end);
v166 = function()
    -- upvalues: v120 (ref), v11 (ref)
    if v120.rage.logs.value then
        local l_status_2, l_result_2 = pcall(table.convert, v11.MISC.log_events:get());
        if not l_status_2 then
            return print("Something went wrong while overriding windows.");
        else
            for _, v243 in pairs(v120.rage.logs.events.value) do
                if l_result_2[v243] then
                    l_result_2[v243] = false;
                end;
            end;
            v11.MISC.log_events:override(table.invert(l_result_2));
        end;
    else
        v11.MISC.log_events:override();
    end;
end;
v120.rage.logs:set_callback(v166, true);
v120.rage.logs.events:set_callback(v166, true);
v11.MISC.log_events:set_callback(v166, true);
v166 = {
    [1] = "Auto", 
    [2] = "Scout", 
    [3] = "AWP"
};
do
    local l_v166_2 = v166;
    v120.rage.hitchance = v165.rage:switch("Hitchance Modifications", false, "\v\226\128\162 \rNo Scope - Overrides your ragebot hit chance along with auto scope while an enemy is within the specified distance.\n\n\v\226\128\162 \rIn Air - Overrides your ragebot hit chance while in the air.", function(v245)
        -- upvalues: l_v166_2 (ref)
        local v246 = {
            weapons = v245:list("Weapons", l_v166_2)
        };
        for v247, v248 in next, l_v166_2 do
            v246["Enabled_" .. v248] = v245:switch("Enable " .. v248, false):depend({
                [1] = v246.weapons, 
                [2] = v247
            });
            v246["Conditions_" .. v248] = v245:selectable("Conditions ## " .. v248, {
                [1] = "No Scope", 
                [2] = "In Air"
            }):depend({
                [1] = v246.weapons, 
                [2] = v247
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v246["Enabled_" .. v248]
            });
            v246["Distance_" .. v248] = v245:slider("Distance ## " .. v248, 100, 1001, 200, 1, function(v249)
                if v249 == 1001 then
                    return "Inf.";
                else
                    return string.format("%.2fm", v249 * 0.01);
                end;
            end):depend({
                [1] = v246.weapons, 
                [2] = v247
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v246["Enabled_" .. v248]
            }, {
                [1] = nil, 
                [2] = "No Scope", 
                [1] = v246["Conditions_" .. v248]
            });
            v246["No Scope_" .. v248] = v245:slider("No Scope ## " .. v248, 1, 100, 50, 1, "%"):depend({
                [1] = v246.weapons, 
                [2] = v247
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v246["Enabled_" .. v248]
            }, {
                [1] = nil, 
                [2] = "No Scope", 
                [1] = v246["Conditions_" .. v248]
            });
            v246["In Air_" .. v248] = v245:slider("In Air ## " .. v248, 1, 100, 50, 1, "%"):depend({
                [1] = v246.weapons, 
                [2] = v247
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v246["Enabled_" .. v248]
            }, {
                [1] = nil, 
                [2] = "In Air", 
                [1] = v246["Conditions_" .. v248]
            });
        end;
        return v246, true;
    end);
    v167 = function()
        -- upvalues: l_v166_2 (ref), v120 (ref)
        local v250 = {};
        for _, v252 in next, l_v166_2 do
            v250[#v250 + 1] = string.format("%s%s", v252, v120.rage.hitchance["Enabled_" .. v252]:get() and "\a{Link Active} \194\183 Active" or "");
        end;
        v120.rage.hitchance.weapons:update(v250);
    end;
    for _, v254 in next, l_v166_2 do
        v120.rage.hitchance["Enabled_" .. v254]:set_callback(v167, true);
    end;
end;
v120.rage.teleport = v165.rage:switch("Automatic Teleport", false, "", function(v255)
    local v256 = {
        weapons = v255:selectable("Weapons", {
            [1] = "Auto", 
            [2] = "Scout", 
            [3] = "AWP", 
            [4] = "Pistols", 
            [5] = "Taser", 
            [6] = "Knife"
        }), 
        delay = v255:slider("Delay", 1, 5, 2)
    };
    v256.delay:depend({
        [1] = v256.weapons, 
        [2] = function(v257)
            return #v257.value ~= 0;
        end
    });
    return v256, true;
end);
v120.rage.peek = v165.rage:switch("Ideal Peek", false, "\v\226\128\162 \rA peek mode that is setup everything you need in one bind. Mainly for scout.", function(v258)
    local v259 = {
        weapons = v258:selectable("Weapons", {
            [1] = "SSG 08", 
            [2] = "Deagle / Pistols", 
            [3] = "AWP", 
            [4] = "R8 Revolver"
        }), 
        options = v258:selectable("Options", {
            [1] = "Double Tap", 
            [2] = "Freestanding", 
            [3] = "Min. Damage", 
            [4] = "Prefer Baim", 
            [5] = "Prefer Safe Points", 
            [6] = "Delay Shot"
        }), 
        damage = v258:slider("Min. Damage", 1, 100, 50), 
        indicate = v258:switch("Indication")
    };
    v259.damage:depend({
        [1] = nil, 
        [2] = "Min. Damage", 
        [1] = v259.options
    });
    return v259, true;
end);
v120.visuals.widgets = v165.visuals:switch("Widgets", false, "", function(v260)
    -- upvalues: v8 (ref)
    local v261 = {
        items = v260:selectable("Items", {
            [1] = "Watermark", 
            [2] = "Hotkeys", 
            [3] = "Flag Watermark", 
            [4] = "Velocity Warning"
        }), 
        wm_items = v260:selectable("Display", {
            [1] = "Username", 
            [2] = "Delay", 
            [3] = "Time"
        }), 
        outline = v260:color_picker("Outline Color"), 
        fade = v260:switch("Fade Line"), 
        background = v260:color_picker("Background Color", color("0D0D0D7D")), 
        flag_color = v260:color_picker("Flag Watermark Color", v8.default)
    };
    v261.wm_items:depend({
        [1] = nil, 
        [2] = "Watermark", 
        [1] = v261.items
    });
    v261.outline:depend({
        [1] = nil, 
        [2] = "Watermark", 
        [3] = "Hotkeys", 
        [1] = v261.items
    });
    v261.fade:depend({
        [1] = nil, 
        [2] = "Watermark", 
        [3] = "Hotkeys", 
        [1] = v261.items
    });
    v261.background:depend({
        [1] = nil, 
        [2] = "Watermark", 
        [3] = "Hotkeys", 
        [1] = v261.items
    });
    v261.flag_color:depend({
        [1] = nil, 
        [2] = "Flag Watermark", 
        [1] = v261.items
    });
    return v261, true;
end);
v166 = function()
    -- upvalues: v120 (ref), v11 (ref), v12 (ref)
    if v120.visuals.widgets.value then
        local l_status_3, l_result_3 = pcall(table.convert, v11.MISC.windows:get());
        if not l_status_3 then
            return print(v12.format("\videalyaw \r~ Failed to override windows."));
        else
            for _, v265 in pairs(v120.visuals.widgets.items.value) do
                if l_result_3[v265] then
                    l_result_3[v265] = false;
                end;
            end;
            v11.MISC.windows:override(table.invert(l_result_3));
        end;
    else
        v11.MISC.windows:override();
    end;
end;
v120.visuals.widgets:set_callback(v166, true);
v120.visuals.widgets.items:set_callback(v166, true);
v11.MISC.windows:set_callback(v166, true);
v120.visuals.indicators = v165.visuals:switch("Crosshair Indicators", false, "", function(v266)
    -- upvalues: v8 (ref)
    local v267 = {
        mode = v266:combo("Type", {
            [1] = "Default", 
            [2] = "Modern"
        }), 
        adjust_pos = v266:switch("Adjust Position in Scope"), 
        color = v266:switch("Color", false, {
            Static = {
                color()
            }, 
            Gradient = {
                [1] = color(), 
                [2] = v8.link_active
            }, 
            Animated = {
                [1] = color(), 
                [2] = v8.link_active
            }
        }), 
        build = v266:switch("Show Version", false, {
            [1] = nil, 
            [2] = true, 
            [1] = v8.default
        }), 
        state_color = v266:color_picker("State Color", v8.default), 
        shadow = v266:switch("Shadow Effect"), 
        damage = v266:switch("Damage Indicator"), 
        font = v266:combo("Font", {
            [1] = "Default", 
            [2] = "Small"
        })
    };
    for v268, v269 in pairs(v267) do
        if v268 ~= "mode" and v268 ~= "damage" and v268 ~= "font" then
            v269:depend({
                [1] = nil, 
                [2] = "Modern", 
                [1] = v267.mode
            });
        end;
    end;
    v267.font:depend(v267.damage);
    return v267, true;
end);
v120.visuals.arrows = v165.visuals:switch("Manual Arrows", false, "", function(v270)
    -- upvalues: v8 (ref)
    local v271 = {
        mode = v270:combo("Type", {
            [1] = "Default", 
            [2] = "Team Skeet"
        }), 
        color = v270:color_picker("Color", v8.default), 
        distance = v270:slider("Distance", 20, 100, 40, 1, "px"), 
        scope = v270:switch("Disable in Scope", true), 
        lines = v270:switch("Show Desync Lines", true)
    };
    v271.lines:depend({
        [1] = nil, 
        [2] = "Team Skeet", 
        [1] = v271.mode
    });
    return v271, true;
end);
v120.visuals.gs = v165.visuals:switch("Game\aCBF62DFFSense\aFFFFFFFF", false, "", function(v272)
    local v273 = {
        items = v272:selectable("Items", {
            [1] = "Indicators", 
            [2] = "Spectators", 
            [3] = "Menu Overlay"
        }), 
        indicators = v272:selectable("Indicators", {
            [1] = "Bomb Info", 
            [2] = "Aimbot Shots", 
            [3] = "Freestanding", 
            [4] = "Min. Damage", 
            [5] = "Hit Chance", 
            [6] = "Body Aim", 
            [7] = "Safe Point", 
            [8] = "Double Tap", 
            [9] = "Hide Shots", 
            [10] = "Fake Duck", 
            [11] = "Fake Latency", 
            [12] = "Dormant Aimbot"
        })
    };
    v273.indicators:depend({
        [1] = nil, 
        [2] = "Indicators", 
        [1] = v273.items
    });
    return v273, true;
end);
v120.modification.hitmarker = v165.modification:switch("3D Hitmarker", false, "\v\226\128\162 \rDraws a visuals clue indicating that you have hit or miss the target.", function(v274)
    return {
        color = v274:color_picker("Color"), 
        size = v274:slider("Size", 1, 10, 3, 1, "px"), 
        duration = v274:slider("Duration", 1, 5, 3, 1, "s")
    }, true;
end);
v166 = function()
    -- upvalues: v120 (ref), v11 (ref)
    if v120.modification.hitmarker.value then
        v11.VISUALS.hitmarker:override(false);
    else
        v11.VISUALS.hitmarker:override();
    end;
end;
v120.modification.hitmarker:set_callback(v166, true);
v11.VISUALS.hitmarker:set_callback(v166, true);
v120.modification.shot_marker = v165.modification:switch("Shot Marker", false, "\v\226\128\162 \rDraws a visuals clue indicating that shows which hitboxes you hitted or miss with the reason.", function(v275)
    return {
        triggers = v275:selectable("Triggers", {
            [1] = "Hit", 
            [2] = "Miss"
        }), 
        font = v275:combo("Font", {
            [1] = "Default", 
            [2] = "Small", 
            [3] = "Console"
        }), 
        hit_color = v275:color_picker("Hit Color", color("CBF62DFF")), 
        miss_color = v275:color_picker("Miss Color", color("FF6464FF")), 
        duration = v275:slider("Duration", 1, 5, 3, 1, "s")
    }, true;
end);
v120.modification.damage_marker = v165.modification:switch("Damage Marker", false, "\v\226\128\162 \rDraws a visuals clue indiating that show how much damage you deal with a weapon or grenades.", function(v276)
    -- upvalues: v8 (ref)
    return {
        font = v276:combo("Font", {
            [1] = "Default", 
            [2] = "Bold"
        }), 
        hit = v276:color_picker("Hit Color", v8.white), 
        head = v276:color_picker("Head Color", color("95B806FF")), 
        nade = v276:color_picker("Nade Color", color("FF8F00FF"))
    }, true;
end);
v120.misc.clantag = v165.misc:switch("Clan Tag", false, "", function(v277)
    return {
        text = v277:input("## Text", "idealyaw.lua")
    }, true;
end);
v166 = function()
    -- upvalues: v120 (ref), v11 (ref)
    if v120.misc.clantag.value then
        v11.MISC.clantag:override(false);
    else
        utils.execute_after(0.1, common.set_clan_tag, "");
        v11.MISC.clantag:override();
    end;
end;
v120.misc.clantag:set_callback(v166, true);
v11.MISC.clantag:set_callback(v166, true);
v120.misc.trashtalk = v165.misc:switch("Trashtalk");
v166 = nil;
v167 = {
    [1] = "16:9", 
    [2] = "16:10", 
    [3] = "3:2", 
    [4] = "4:3", 
    [5] = "5:4"
};
v168 = {};
for v278 = 1, #v167 do
    v173 = v167[v278];
    local v279, v280 = v173:match("(%d*):(%d*)");
    v168[math.floor(v279 / v280 * 100)] = v173;
end;
do
    local l_v167_2, l_v168_2 = v167, v168;
    v120.misc.aspect_ratio = v165.misc:switch("Aspect Ratio", false, "", function(v283)
        -- upvalues: l_v168_2 (ref), l_v167_2 (ref)
        local v285 = {
            ratio = v283:slider("Ratio", 49, 180, cvar.r_aspectratio:float(), 0.01, function(v284)
                -- upvalues: l_v168_2 (ref)
                if v284 == 49 then
                    return "Off";
                else
                    return l_v168_2[v284] or string.format("%.2f", v284 * 0.01);
                end;
            end)
        };
        for v286 = 1, #l_v167_2 do
            local v287 = l_v167_2[v286];
            local v288, v289 = v287:match("(%d*):(%d*)");
            local v290 = math.floor(v288 / v289 * 100);
            do
                local l_v290_0 = v290;
                v285["Button_" .. v286] = v283:button(" " .. v287 .. " ", function()
                    -- upvalues: v285 (ref), l_v290_0 (ref)
                    v285.ratio:set(l_v290_0);
                end, true);
            end;
        end;
        return v285, true;
    end);
end;
v167 = nil;
v168 = {
    fov = cvar.viewmodel_fov, 
    x = cvar.viewmodel_offset_x, 
    y = cvar.viewmodel_offset_y, 
    z = cvar.viewmodel_offset_z
};
v169 = {};
for v292, v293 in pairs(v168) do
    v169[v292] = tonumber(v293:string()) or 0;
end;
do
    local l_v168_3, l_v169_1 = v168, v169;
    v120.misc.viewmodel = v165.misc:switch("Override Viewmodel", false, "", function(v296)
        -- upvalues: l_v169_1 (ref), l_v168_3 (ref)
        local v297 = {
            fov = v296:slider("FOV", -1800, 1800, l_v169_1.fov * 10, 0.1), 
            x = v296:slider("Offset X", -1800, 1800, l_v169_1.x * 10, 0.1), 
            y = v296:slider("Offset Y", -1800, 1800, l_v169_1.y * 10, 0.1), 
            z = v296:slider("Offset Z", -1800, 1800, l_v169_1.z * 10, 0.1), 
            reset = v296:button("\v\f<arrow-rotate-left>  \rReset", nil, true)
        };
        v297.reset:set_callback(function()
            -- upvalues: l_v168_3 (ref), v297 (ref)
            for v298, _ in pairs(l_v168_3) do
                if v297[v298] then
                    v297[v298]:set((tonumber(l_v168_3[v298]:string()) or 0) * 10);
                end;
            end;
        end);
        return v297, true;
    end);
end;
v120.misc.scope = v165.misc:switch("Custom Scope", false, "", function(v300)
    -- upvalues: v8 (ref)
    return {
        size = v300:slider("Size", 1, 500, 100, 1, "px"), 
        gap = v300:slider("Gap", 1, 500, 10, 1, "px"), 
        inverted = v300:switch("Inverted", false, {
            [1] = v8.link_active
        }), 
        t = v300:switch("T Style")
    }, true;
end);
v168 = function()
    -- upvalues: v120 (ref), v11 (ref)
    if v120.misc.scope.value then
        v11.VISUALS.scope_overlay:override("Remove All");
    else
        v11.VISUALS.scope_overlay:override();
    end;
end;
v120.misc.scope:set_callback(v168, true);
v11.VISUALS.scope_overlay:set_callback(v168, true);
v120.misc.nade_fix = v165.misc:switch("Nade Throw Fix", false);
v120.additional.taskbar = v165.additional:switch("Taskbar Notify on Round Start", false, "\v\226\128\162 \rIf you're tabbed out, the game icon will flash if the new round started so that you don't miss it.");
v120.additional.reveal_users = v165.additional:switch("Reveal Ideal Yaw Users");
v120.additional.unmute = v165.additional:switch("Unmute Muted Players", false, "\v\226\128\162 \rAutomatically unmutes players that have an abuse communications mute.");
v120.additional.console = v165.additional:switch("Console Color Modulation", false, {
    [1] = nil, 
    [2] = true, 
    [1] = color(0, 100)
});
v120.additional.transparency = v165.additional:switch("Keep Model Transparency");
v165 = nil;
v120.antiaim = {};
v165 = {};
v166 = v0.create("\240\159\142\175 Anti Aim", {
    [1] = {
        [1] = "main", 
        [2] = "\t\t\t\t\t\t\t\t\t\a{Active Text}\240\159\142\175 Anti Aim", 
        [3] = 1
    }, 
    [2] = {
        [1] = "other", 
        [2] = "\t\t\t\t\t\t\t\t\t\a{Active Text}\240\159\155\160 Builder", 
        [3] = 2
    }
});
v120.antiaim.type = v166.main:list("## Anti Aim Type", v5.presets);
v165.refresh = function(_)
    -- upvalues: v5 (ref), v120 (ref)
    local v302 = {};
    for v303, v304 in pairs(v5.presets) do
        v302[#v302 + 1] = string.format("%s  %s%s", v5.preset_icons[v303], v304, v303 == v120.antiaim.type.value and string.format("\a{Link Active} \194\183 Active") or "");
    end;
    v120.antiaim.type:update(v302);
end;
v120.antiaim.type:set_callback(v165.refresh, true);
v120.antiaim.tweaks = v166.main:selectable("Tweaks", {
    [1] = "Legit AA on Use", 
    [2] = "Fast Ladder Move", 
    [3] = "No Fall Damage"
});
v120.antiaim.edge_yaw = v166.main:switch("Edge Yaw", false, "", function(v305)
    return {
        fd = v305:switch("Only While Fake Ducking"), 
        disablers = v305:switch("Disable Yaw Modifiers")
    };
end);
v120.antiaim.manuals = v166.main:combo("Manual Yaw", {
    [1] = "Disabled", 
    [2] = "Backward", 
    [3] = "Left", 
    [4] = "Right", 
    [5] = "Forward"
}, "", function(v306)
    return {
        static = v306:switch("Disable Yaw Modifiers", false), 
        exploit = v306:switch("Duck Exploit")
    };
end);
v120.antiaim.safe = v166.main:selectable("Safe Head", {
    [1] = "Standing", 
    [2] = "Crouching", 
    [3] = "Air + Crouch", 
    [4] = "Slow Walking", 
    [5] = "Air Knife", 
    [6] = "Air Taser"
}, "\v\226\128\162 \rAllows you to reduce the chance of hitting ground advantage on specific conditions.\n\n\v\226\128\162 \rAir Knife makes your anti-aims fully static in jump crouch conditions, also working same for Deagle.");
v120.antiaim.defensive = v166.main:switch("Defensive AA", false, "", function(v307)
    return {
        triggers = v307:selectable("Triggers", {
            [1] = "Double Tap", 
            [2] = "Hide Shots"
        }), 
        conditions = v307:selectable("Conditions", {
            [1] = "Standing", 
            [2] = "Moving", 
            [3] = "Slow Walking", 
            [4] = "Air", 
            [5] = "Air + Crouch", 
            [6] = "Crouching", 
            [7] = "On Peek"
        }), 
        tweaks = v307:selectable("Tweaks", {
            [1] = "Weapon Switch", 
            [2] = "Flashed", 
            [3] = "Reloading"
        }), 
        pitch = v307:combo("Pitch", {
            [1] = "Down", 
            [2] = "Zero", 
            [3] = "Up", 
            [4] = "Up-Switch", 
            [5] = "Down-Switch", 
            [6] = "Random"
        }), 
        yaw = v307:combo("Yaw", {
            [1] = "Default", 
            [2] = "Forward", 
            [3] = "Sideways", 
            [4] = "Spin"
        }), 
        e_spam = v307:switch("E Spam on Safe Head")
    }, true;
end);
v120.antiaim.animations = v166.main:switch("Animation Breaker", false, "Forces specific animations on the local player. Client-side only.\n\n\v\226\128\162 \rZero Pitch on Land makes the pitch angle appear to be zero degrees during playback of the landing animation.\n\v\226\128\162 \rLeg Movement isn't fully client-side as it overrides 'Leg Movement' to 'Sliding'.", function(v308)
    return {
        ground = v308:combo("Leg Movement", {
            [1] = "Off", 
            [2] = "Static", 
            [3] = "Walking"
        }), 
        air = v308:combo("In Air", {
            [1] = "Off", 
            [2] = "Static", 
            [3] = "Walking"
        }), 
        pitch = v308:switch("Zero Pitch on Land")
    }, true;
end);
v120.antiaim.fs = v166.main:switch("Freestanding", false, "", function(v309)
    return {
        disable_ym = v309:switch("Disable Yaw Modifiers"), 
        body_fs = v309:switch("Body Freestanding"), 
        disablers = v309:selectable("Disablers", {
            [1] = "Standing", 
            [2] = "Moving", 
            [3] = "Slow Walking", 
            [4] = "Air", 
            [5] = "Air + Crouch", 
            [6] = "Crouching", 
            [7] = "Fake Lag"
        })
    };
end);
v120.antiaim.preset_label = v166.other:label("..."):depend({
    [1] = v120.antiaim.type, 
    [2] = function(v310)
        return v310.value ~= 1;
    end
});
v120.antiaim.type:set_callback(function(v311)
    -- upvalues: v120 (ref), v5 (ref)
    local v312 = v311:get();
    v120.antiaim.preset_label:name(string.format("You are using %s %s preset.\nEverything is already set up!\nEnjoy, %s!", v5.preset_icons[v312], v5.presets[v312], v5.user));
end, true);
v120.conditional = {};
v120.antiaim.condition = v166.other:combo("Player State", v5.conditions):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v120.antiaim.type
});
v120.antiaim.label = v166.other:label("\v\f<user-gear>\t\rActions:");
v120.antiaim.copy = v166.other:button("\v\f<copy>\t\rCopy", nil, true);
v120.antiaim.import = v166.other:button("\v\f<file-import>\t\rImport", nil, true);
v120.antiaim.label:visibility(not _IS_MARKET);
v120.antiaim.copy:visibility(not _IS_MARKET);
v120.antiaim.import:visibility(not _IS_MARKET);
v120.antiaim.label:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v120.antiaim.type
});
v120.antiaim.copy:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v120.antiaim.type
});
v120.antiaim.import:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v120.antiaim.type
});
for _, v314 in pairs(v5.conditions) do
    v120.conditional[v314] = {};
    v172 = v0.create("\240\159\142\175 Anti Aim", string.format("%s Angles", v314), 2);
    if v314 ~= v5.conditions[1] then
        v120.conditional[v314].enabled = v166.other:switch("Override " .. v314):depend({
            [1] = v120.antiaim.condition, 
            [2] = v314
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v120.antiaim.type
        });
        v172:depend(v120.conditional[v314].enabled);
    end;
    v120.conditional[v314].pitch = v172:combo("Pitch", v11.AA.angles.pitch:list());
    if v314 == v5.conditions[8] then
        v120.conditional[v314].pitch:disabled(true);
    end;
    v120.conditional[v314].yaw = v172:combo("Yaw", v11.AA.angles.yaw.main:list(), "", function(v315)
        -- upvalues: v11 (ref)
        local v316 = {
            base = v315:combo("Base", v11.AA.angles.yaw.base:list()), 
            swap_type = v315:combo("Type", {
                [1] = "180", 
                [2] = "180 L&R", 
                [3] = "Delayed Swap"
            }), 
            offset = v315:slider("Offset", -180, 180, 0, 1, "\194\176"), 
            left = v315:slider("Left Offset", -180, 180, 0, 1, "\194\176"), 
            right = v315:slider("Right Offset", -180, 180, 0, 1, "\194\176"), 
            delay = v315:slider("Delay", 3, 64, 10, 1, "t")
        };
        v316.offset:depend({
            [1] = nil, 
            [2] = "180", 
            [1] = v316.swap_type
        });
        v316.left:depend({
            [1] = nil, 
            [2] = "180 L&R", 
            [3] = "Delayed Swap", 
            [1] = v316.swap_type
        });
        v316.right:depend({
            [1] = nil, 
            [2] = "180 L&R", 
            [3] = "Delayed Swap", 
            [1] = v316.swap_type
        });
        v316.delay:depend({
            [1] = nil, 
            [2] = "Delayed Swap", 
            [1] = v316.swap_type
        });
        return v316;
    end);
    v120.conditional[v314].yaw_modifier = v172:combo("Yaw Modifier", v11.AA.angles.yaw_modifier.main:list(), "", function(v317)
        local v318 = {
            custom_way = v317:switch("Use Custom Way Values")
        };
        for v319 = 1, 5 do
            v318["offset" .. v319] = v317:slider(string.format("Offset %s", v319 == 1 and "" or v319), -180, 180, 0, 1, "\194\176");
        end;
        v318.randomize = v317:slider("Randomize", 0, 180, 0, 1, function(v320)
            if v320 == 0 then
                return "Off";
            else
                return v320 .. "\194\176";
            end;
        end);
        return v318;
    end);
    v120.conditional[v314].yaw_modifier.custom_way:depend({
        [1] = nil, 
        [2] = "3-Way", 
        [3] = "5-Way", 
        [1] = v120.conditional[v314].yaw_modifier
    });
    do
        local l_v314_0 = v314;
        for v322 = 2, 5 do
            do
                local l_v322_0 = v322;
                v120.conditional[l_v314_0].yaw_modifier["offset" .. l_v322_0]:depend({
                    [1] = v120.conditional[l_v314_0].yaw_modifier, 
                    [2] = function(v324)
                        -- upvalues: v120 (ref), l_v314_0 (ref), l_v322_0 (ref)
                        return v120.conditional[l_v314_0].yaw_modifier.custom_way.value and l_v322_0 <= 3 and (not (v324.value ~= "3-Way") or not (v324.value ~= "5-Way")) or v324.value == "5-Way";
                    end
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v120.conditional[l_v314_0].yaw_modifier.custom_way
                });
            end;
        end;
        v120.conditional[l_v314_0].body_yaw = v172:switch("Body Yaw", false, "", function(v325)
            -- upvalues: v11 (ref)
            return {
                inverter = v325:switch("Inverter", false), 
                left_limit = v325:slider("Left Limit", 0, 60, 60, 1, "\194\176"), 
                right_limit = v325:slider("Right Limit", 0, 60, 60, 1, "\194\176"), 
                options = v325:selectable("Fake Options", v11.AA.angles.body_yaw.options:list()), 
                freestanding = v325:combo("Freestanding", v11.AA.angles.body_yaw.freestanding:list())
            };
        end);
        v172:depend({
            [1] = v120.antiaim.condition, 
            [2] = l_v314_0
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v120.antiaim.type
        });
    end;
end;
v166 = nil;
v166 = {
    list = v0.string_recorder.close()
};
do
    local l_v166_3 = v166;
    events.render(function()
        -- upvalues: v5 (ref), v12 (ref), l_v166_3 (ref), v120 (ref), v8 (ref)
        v5.alpha = ui.get_alpha();
        if v5.alpha ~= 1 then
            return;
        else
            local v327 = ui.get_style();
            local v328 = v327["Link Active"];
            local v329 = v327["Active Text"];
            local v330 = "";
            local v331 = nil;
            local v332 = string.format("%s [%s]", v5.name, v5.version);
            local v333 = #v332 + 1;
            for v334 = 1, v333 do
                local v335 = v332:sub(v334, v334);
                local v336 = (v334 - 1) / v333;
                local v337 = v12.breathe(v336 * 1.5, 2.5);
                local v338 = color(255, 135, 210):lerp(v328, v337);
                if v334 == 1 then
                    v331 = v338;
                end;
                v330 = v330 .. string.format("\a%s%s", v338:to_hex(), v335);
            end;
            ui.sidebar(v330, string.format("\a%s%s", v331.to_hex(v331), ui.get_icon("user-secret")));
            if l_v166_3.link ~= v328 or l_v166_3.text ~= v329 then
                v120.information.user:name(string.format("\v\f<user>\t\a{Active Text}Welcome back, \v%s \r[\a%s\r]", v5.user, string.gradient(v5.version, v329, v328)));
                v8.link_active = v328;
                l_v166_3.link = v328;
                l_v166_3.text = v329;
            end;
            return;
        end;
    end);
end;
v123 = v0.setup(v120, true);
v124 = nil;
v124 = {
    start = "idealyaw_", 
    end_ = "_idealyaw"
};
v124.export = function()
    -- upvalues: v123 (ref), v5 (ref), v1 (ref), v124 (ref)
    local v339 = v123:save();
    if v339 == nil then
        return;
    else
        local v340 = {
            author = v5.user, 
            date = common.get_date("%m/%d/%Y at %H:%M"), 
            config = v339
        };
        local l_status_4, l_result_4 = pcall(msgpack.pack, v340);
        if not l_status_4 then
            return;
        else
            local l_status_5, l_result_5 = pcall(v1.encode, l_result_4);
            if not l_status_5 then
                return;
            else
                print_raw("\a{Link Active}idealyaw \aDEFAULT~ Successfully exported config.");
                print_dev("\aDEFAULTSuccessfully exported config.");
                cvar.play:call("ui\\beepclear");
                return string.format("%s%s%s", v124.start, l_result_5, v124.end_);
            end;
        end;
    end;
end;
v120.configs.export:set_callback(function()
    -- upvalues: v9 (ref), v124 (ref)
    v9.set(v124.export());
end);
v124.import = function(v345)
    -- upvalues: v9 (ref), v124 (ref), v1 (ref), v123 (ref)
    if not v345 then
        v345 = v9.get();
    end;
    if v345.sub(v345, 1, #v124.start) ~= v124.start then
        cvar.play:call("buttons\\weapon_cant_buy.wav");
        print_raw("\a{Link Active}idealyaw \aDEFAULT~ Looks like this config is not compatible.");
        return;
    else
        v345 = v345.gsub(v345, v124.start, ""):gsub(v124.end_, "");
        local l_status_6, l_result_6 = pcall(v1.decode, v345);
        if not l_status_6 then
            cvar.play:call("buttons\\weapon_cant_buy.wav");
            print_raw("\a{Link Active}idealyaw \aDEFAULT~ Failed to encode configuration.");
            return;
        else
            local l_status_7, l_result_7 = pcall(msgpack.unpack, l_result_6);
            if not l_status_7 then
                cvar.play:call("buttons\\weapon_cant_buy.wav");
                print_raw("\a{Link Active}idealyaw \aDEFAULT~ Failed to unpack configuration.");
                return;
            else
                v123:load(l_result_7.config);
                print_raw(string.format("\a{Link Active}idealyaw \aDEFAULT~ Successfully loaded config by \a{Link Active}%s\aDEFAULT, created at \a{Link Active}%s.", l_result_7.author, l_result_7.date));
                print_dev(string.format("\aDEFAULTSuccessfully loaded config by \a{Link Active}%s\aDEFAULT, created at \a{Link Active}%s.", l_result_7.author, l_result_7.date));
                cvar.play:call("ui\\beepclear");
                return;
            end;
        end;
    end;
end;
v120.configs.import:set_callback(function()
    -- upvalues: v124 (ref)
    v124.import();
end);
v120.configs.default:set_callback(function()
    -- upvalues: v124 (ref)
    v124.import("idealyaw_g6Zjb25maWeHp2FudGlhaW2OqmFuaW1hdGlvbnPDpHNhZmWUqFN0YW5kaW5nqUNyb3VjaGluZ6lBaXIgS25pZmWhfqhlZGdlX3lhd8KmdHdlYWtzlK9MZWdpdCBBQSBvbiBVc2WwRmFzdCBMYWRkZXIgTW92Za5ObyBGYWxsIERhbWFnZaF+p21hbnVhbHOoRGlzYWJsZWSiZnPCqWNvbmRpdGlvbqZNb3Zpbmeofm1hbnVhbHOCpnN0YXRpY8OnZXhwbG9pdMOrfmFuaW1hdGlvbnODpmdyb3VuZKZTdGF0aWOjYWlyo09mZqVwaXRjaMKpfmVkZ2VfeWF3gqJmZMOpZGlzYWJsZXJzw6R0eXBlA6N+ZnODp2JvZHlfZnPDqmRpc2FibGVfeW3DqWRpc2FibGVyc5asU2xvdyBXYWxraW5no0FpcqxBaXIgKyBDcm91Y2ipQ3JvdWNoaW5nqEZha2UgTGFnoX6qfmRlZmVuc2l2ZYaqY29uZGl0aW9uc5SjQWlyrEFpciArIENyb3VjaKlDcm91Y2hpbmehfqZlX3NwYW3DqHRyaWdnZXJzk6pEb3VibGUgVGFwqkhpZGUgU2hvdHOhfqN5YXeoU2lkZXdheXOlcGl0Y2imUmFuZG9tpnR3ZWFrc5StV2VhcG9uIFN3aXRjaKdGbGFzaGVkqVJlbG9hZGluZ6F+qWRlZmVuc2l2ZcOkcmFnZYilfmxvZ3OIpmV2ZW50c5SsQWltYm90IFNob3RzrERhbWFnZSBEZWFsdKlQdXJjaGFzZXOhfqZvZmZzZXQAqm1pc3NfY29sb3KpI0ZGMDAzMkZGpGdsb3fCpWNvbG9yqSNBMkM5MjlGRq9taXNzbWF0Y2hfY29sb3KpI0ZGQzkwMEZGrnB1cmNoYXNlX2NvbG9yqSM2NkNEQUFGRqRzaG93k6dDb25zb2xlpkV2ZW50c6F+qn5oaXRjaGFuY2XeABCsSW4gQWlyX1Njb3V0N61EaXN0YW5jZV9BdXRvzQHsp3dlYXBvbnMCrU5vIFNjb3BlX0F1dG8yrE5vIFNjb3BlX0FXUDysRGlzdGFuY2VfQVdQzQEtrEVuYWJsZWRfQXV0b8OtRW5hYmxlZF9TY291dMOwQ29uZGl0aW9uc19TY291dJOoTm8gU2NvcGWmSW4gQWlyoX6qSW4gQWlyX0FXUDyrRW5hYmxlZF9BV1DDrkRpc3RhbmNlX1Njb3V0zQHsq0luIEFpcl9BdXRvAa5ObyBTY29wZV9TY291dDyuQ29uZGl0aW9uc19BV1CTqE5vIFNjb3BlpkluIEFpcqF+r0NvbmRpdGlvbnNfQXV0b5KoTm8gU2NvcGWhfqV+cGVla4Snd2VhcG9uc5WmU1NHIDA4sERlYWdsZSAvIFBpc3RvbHOjQVdQq1I4IFJldm9sdmVyoX6nb3B0aW9uc5OqRG91YmxlIFRhcKxGcmVlc3RhbmRpbmehfqhpbmRpY2F0ZcOmZGFtYWdlMqRwZWVrwqh0ZWxlcG9ydMKkbG9nc8OpaGl0Y2hhbmNlw6l+dGVsZXBvcnSCp3dlYXBvbnORoX6lZGVsYXkCp3Zpc3VhbHOIp35hcnJvd3OFqGRpc3RhbmNlLKVzY29wZcKlY29sb3KpI0NCRjYyREZGpG1vZGWnRGVmYXVsdKVsaW5lc8OiZ3PDpmFycm93c8OofndpZGdldHOGp291dGxpbmWpIzlDRkRFOEZGpGZhZGXDqHdtX2l0ZW1zlKhVc2VybmFtZaVEZWxheaRUaW1loX6qYmFja2dyb3VuZKkjMDAwMDAwM0KlaXRlbXOVqVdhdGVybWFya6dIb3RrZXlzrkZsYWcgV2F0ZXJtYXJrsFZlbG9jaXR5IFdhcm5pbmehfqpmbGFnX2NvbG9yqSNGMjgwODBGRqppbmRpY2F0b3Jzw6N+Z3OCpWl0ZW1zk6pJbmRpY2F0b3JzqlNwZWN0YXRvcnOhfqppbmRpY2F0b3JznalCb21iIEluZm+sQWltYm90IFNob3RzrEZyZWVzdGFuZGluZ6tNaW4uIERhbWFnZapIaXQgQ2hhbmNlqEJvZHkgQWltqlNhZmUgUG9pbnSqRG91YmxlIFRhcKpIaWRlIFNob3RzqUZha2UgRHVja6xGYWtlIExhdGVuY3muRG9ybWFudCBBaW1ib3Shfqt+aW5kaWNhdG9yc4qrc3RhdGVfY29sb3KpI0ZGRkZGRjc2pGZvbnSnRGVmYXVsdKVjb2xvcsKmKmNvbG9yk6ZTdGF0aWOpI0ZGRkZGRkZGoX6mKmJ1aWxkqSNGRjhGMDBGRqRtb2Rlp0RlZmF1bHSqYWRqdXN0X3Bvc8OmZGFtYWdlw6VidWlsZMOmc2hhZG93w6d3aWRnZXRzw6xtb2RpZmljYXRpb26Gqn5oaXRtYXJrZXKDpWNvbG9yqSNGRkZGRkZGRqRzaXplAqhkdXJhdGlvbgKrc2hvdF9tYXJrZXLDrn5kYW1hZ2VfbWFya2VyhKRmb250pEJvbGSkbmFkZakjRkY4RjAwRkakaGVhZKkjOTVCODA2RkajaGl0qSNGRkZGRkZGRqloaXRtYXJrZXLDrH5zaG90X21hcmtlcoWpaGl0X2NvbG9yqSNDQkY2MkRGRqptaXNzX2NvbG9yqSNGRjY0NjRGRqRmb250pVNtYWxsqHRyaWdnZXJzk6NIaXSkTWlzc6F+qGR1cmF0aW9uA61kYW1hZ2VfbWFya2Vyw6RtaXNjiql0cmFzaHRhbGvCrGFzcGVjdF9yYXRpb8Opdmlld21vZGVswqdjbGFudGFnwqhuYWRlX2ZpeMOlc2NvcGXCqH5jbGFudGFngaR0ZXh0rGlkZWFseWF3Lmx1Ya1+YXNwZWN0X3JhdGlvgaVyYXRpb2SqfnZpZXdtb2RlbISheQqhevajZm92zQJYoXgKpn5zY29wZYWpKmludmVydGVkqSM5NkM4M0NGRqRzaXplZKF0wqhpbnZlcnRlZMKjZ2FwCqphZGRpdGlvbmFshqgqY29uc29sZakjMDAwMDAwNjSnY29uc29sZcKndGFza2JhcsOmdW5tdXRlw6x0cmFuc3BhcmVuY3nDrHJldmVhbF91c2Vyc8KrY29uZGl0aW9uYWyJplNoYXJlZIelcGl0Y2ikRG93bql+Ym9keV95YXeFqGludmVydGVywqpsZWZ0X2xpbWl0PKtyaWdodF9saW1pdDynb3B0aW9uc5KmSml0dGVyoX6sZnJlZXN0YW5kaW5no09mZq1+eWF3X21vZGlmaWVyh6dvZmZzZXQzAKlyYW5kb21pemUAp29mZnNldDQAqmN1c3RvbV93YXnCp29mZnNldDUAp29mZnNldDEAp29mZnNldDIArHlhd19tb2RpZmllcqhEaXNhYmxlZKN5YXeoQmFja3dhcmSoYm9keV95YXfCpH55YXeGpm9mZnNldAClZGVsYXkKpXJpZ2h0AKlzd2FwX3R5cGWjMTgwpGJhc2WpQXQgVGFyZ2V0pGxlZnQAqFN0YW5kaW5niKVwaXRjaKREb3dup2VuYWJsZWTDrX55YXdfbW9kaWZpZXKHp29mZnNldDMAqXJhbmRvbWl6ZQCnb2Zmc2V0NACqY3VzdG9tX3dhecKnb2Zmc2V0NQCnb2Zmc2V0Meinb2Zmc2V0MgCpfmJvZHlfeWF3hahpbnZlcnRlcsKqbGVmdF9saW1pdDyrcmlnaHRfbGltaXQ8p29wdGlvbnOSpkppdHRlcqF+rGZyZWVzdGFuZGluZ6NPZmaseWF3X21vZGlmaWVypkNlbnRlcqN5YXeoQmFja3dhcmSoYm9keV95YXfDpH55YXeGpm9mZnNldAClZGVsYXkFpXJpZ2h0Ealzd2FwX3R5cGWnMTgwIEwmUqRiYXNlqUF0IFRhcmdldKRsZWZ09qZNb3ZpbmeIpXBpdGNopERvd26nZW5hYmxlZMOtfnlhd19tb2RpZmllcoenb2Zmc2V0MwCpcmFuZG9taXplAKdvZmZzZXQ0AKpjdXN0b21fd2F5wqdvZmZzZXQ1AKdvZmZzZXQxAKdvZmZzZXQyAKl+Ym9keV95YXeFqGludmVydGVywqpsZWZ0X2xpbWl0PKtyaWdodF9saW1pdDynb3B0aW9uc5GhfqxmcmVlc3RhbmRpbmejT2ZmrHlhd19tb2RpZmllcqhEaXNhYmxlZKN5YXeoQmFja3dhcmSoYm9keV95YXfDpH55YXeGpm9mZnNldAOlZGVsYXkEpXJpZ2h0H6lzd2FwX3R5cGWsRGVsYXllZCBTd2FwpGJhc2WpQXQgVGFyZ2V0pGxlZnThrFNsb3cgV2Fsa2luZ4ilcGl0Y2ikRG93bqdlbmFibGVkw61+eWF3X21vZGlmaWVyh6dvZmZzZXQzAKlyYW5kb21pemUAp29mZnNldDQAqmN1c3RvbV93YXnCp29mZnNldDUAp29mZnNldDHop29mZnNldDIAqX5ib2R5X3lhd4WoaW52ZXJ0ZXLCqmxlZnRfbGltaXQ8q3JpZ2h0X2xpbWl0PKdvcHRpb25zkaF+rGZyZWVzdGFuZGluZ6NPZmaseWF3X21vZGlmaWVypkNlbnRlcqN5YXeoQmFja3dhcmSoYm9keV95YXfDpH55YXeGpm9mZnNldAClZGVsYXkHpXJpZ2h0Kqlzd2FwX3R5cGWsRGVsYXllZCBTd2FwpGJhc2WpQXQgVGFyZ2V0pGxlZnTko0FpcoilcGl0Y2ikRG93bqdlbmFibGVkw61+eWF3X21vZGlmaWVyh6dvZmZzZXQzJalyYW5kb21pemUAp29mZnNldDQAqmN1c3RvbV93YXnDp29mZnNldDUAp29mZnNldDHtp29mZnNldDLQ26l+Ym9keV95YXeFqGludmVydGVywqpsZWZ0X2xpbWl0HatyaWdodF9saW1pdB2nb3B0aW9uc5OmSml0dGVysFJhbmRvbWl6ZSBKaXR0ZXKhfqxmcmVlc3RhbmRpbmejT2ZmrHlhd19tb2RpZmllcqUzLVdheaN5YXeoQmFja3dhcmSoYm9keV95YXfDpH55YXeGpm9mZnNldAClZGVsYXkIpXJpZ2h0Jqlzd2FwX3R5cGWjMTgwpGJhc2WpQXQgVGFyZ2V0pGxlZnTQ36xBaXIgKyBDcm91Y2iIpXBpdGNopERvd26nZW5hYmxlZMOtfnlhd19tb2RpZmllcoenb2Zmc2V0MwCpcmFuZG9taXplAKdvZmZzZXQ0AKpjdXN0b21fd2F5wqdvZmZzZXQ1AKdvZmZzZXQx0NSnb2Zmc2V0MgCpfmJvZHlfeWF3hahpbnZlcnRlcsKqbGVmdF9saW1pdDyrcmlnaHRfbGltaXQ8p29wdGlvbnOSpkppdHRlcqF+rGZyZWVzdGFuZGluZ6NPZmaseWF3X21vZGlmaWVypkNlbnRlcqN5YXeoQmFja3dhcmSoYm9keV95YXfDpH55YXeGpm9mZnNldAClZGVsYXkHpXJpZ2h0Jqlzd2FwX3R5cGWjMTgwpGJhc2WpQXQgVGFyZ2V0pGxlZnTwqUNyb3VjaGluZ4ilcGl0Y2ikRG93bqdlbmFibGVkw61+eWF3X21vZGlmaWVyh6dvZmZzZXQzAKlyYW5kb21pemUAp29mZnNldDQAqmN1c3RvbV93YXnCp29mZnNldDUAp29mZnNldDHQ26dvZmZzZXQyAKl+Ym9keV95YXeFqGludmVydGVywqpsZWZ0X2xpbWl0PKtyaWdodF9saW1pdDynb3B0aW9uc5KmSml0dGVyoX6sZnJlZXN0YW5kaW5no09mZqx5YXdfbW9kaWZpZXKmQ2VudGVyo3lhd6hCYWNrd2FyZKhib2R5X3lhd8Okfnlhd4amb2Zmc2V0AKVkZWxheQilcmlnaHQzqXN3YXBfdHlwZaMxODCkYmFzZalBdCBUYXJnZXSkbGVmdNDapkluIFVzZYilcGl0Y2ioRGlzYWJsZWSnZW5hYmxlZMOtfnlhd19tb2RpZmllcoenb2Zmc2V0MwCpcmFuZG9taXplAKdvZmZzZXQ0AKpjdXN0b21fd2F5wqdvZmZzZXQ1AKdvZmZzZXQxAKdvZmZzZXQyAKl+Ym9keV95YXeFqGludmVydGVywqpsZWZ0X2xpbWl0HatyaWdodF9saW1pdB2nb3B0aW9uc5GhfqxmcmVlc3RhbmRpbmejT2ZmrHlhd19tb2RpZmllcqZDZW50ZXKjeWF3qEJhY2t3YXJkqGJvZHlfeWF3w6R+eWF3hqZvZmZzZXQApWRlbGF5CqVyaWdodACpc3dhcF90eXBlozE4MKRiYXNlqkxvY2FsIFZpZXekbGVmdACoRmFrZSBMYWeIpXBpdGNoqERpc2FibGVkp2VuYWJsZWTCrX55YXdfbW9kaWZpZXKHp29mZnNldDMAqXJhbmRvbWl6ZQCnb2Zmc2V0NACqY3VzdG9tX3dhecKnb2Zmc2V0NQCnb2Zmc2V0MQCnb2Zmc2V0MgCpfmJvZHlfeWF3hahpbnZlcnRlcsKqbGVmdF9saW1pdDyrcmlnaHRfbGltaXQ8p29wdGlvbnORoX6sZnJlZXN0YW5kaW5no09mZqx5YXdfbW9kaWZpZXKoRGlzYWJsZWSjeWF3qERpc2FibGVkqGJvZHlfeWF3wqR+eWF3hqZvZmZzZXQApWRlbGF5CqVyaWdodACpc3dhcF90eXBlozE4MKRiYXNlqkxvY2FsIFZpZXekbGVmdACmYXV0aG9ypksxWjRSVaRkYXRlszExLzIyLzIwMjMgYXQgMjA6MjM=_idealyaw");
end);
v165 = nil;
v165 = {
    data = {}
};
v165.push = function(_, v351, v352, v353)
    -- upvalues: v165 (ref), v10 (ref), v8 (ref)
    v165.data[#v165.data + 1] = {
        offset = 0, 
        text = v352, 
        duration = globals.realtime + v351, 
        animation = v10:new(), 
        color = v353 or v8.white
    };
end;
v30.Logs.render:set(function(_, _)
    -- upvalues: v120 (ref), v165 (ref), v5 (ref), v8 (ref)
    if not v120.rage.logs.value or not v120.rage.logs.show:get("Notifications") then
        v165.data = {};
        return;
    else
        local v356 = 0;
        local l_realtime_0 = globals.realtime;
        local l_value_0 = v120.rage.logs.glow.value;
        local l_value_1 = v120.rage.logs.offset.value;
        for v360 = #v165.data, 1, -1 do
            local v361 = v165.data[v360];
            if v361 then
                local v362 = v361.duration - l_realtime_0;
                local v363 = v361.animation(0.2, v362 > 0);
                if v363 <= 0 and v362 < 0 then
                    table.remove(v165.data, v360);
                else
                    if v361.offset ~= v356 then
                        v361.offset = math.clamp(v361.offset < v356 and v361.offset + 200 * globals.frametime or v356, 0, v356);
                    end;
                    local v364 = render.measure_text(1, nil, v361.text);
                    local v365 = v5.screen_center:clone();
                    v365.x = v365.x - v364.x / 2;
                    v365.y = v365.y + 300 + v361.offset + l_value_1;
                    local v366 = v361.color:alpha_modulate(v363, true);
                    if l_value_0 then
                        render.shadow(vector(v365.x, v365.y + 6), vector(v365.x + v364.x, v365.y + 6), v366, 30, 0, 0);
                    end;
                    render.text(1, v365, v8.white:alpha_modulate(v363, true), nil, v361.text);
                    v356 = v356 + v364.y + 2;
                end;
            end;
        end;
        for v367 = 1, #v165.data do
            if #v165.data - v367 > 7 then
                v165.data[v367].duration = 0;
            end;
        end;
        return;
    end;
end);
v166 = nil;
v167 = {
    Forward = 180, 
    Right = 90, 
    Left = -90, 
    Backward = 0
};
v168 = v119.new("Manual", 6);
do
    local l_v167_3, l_v168_4 = v167, v168;
    v30["Manual Yaw"].createmove:set(function(_, v371)
        -- upvalues: v120 (ref), l_v168_4 (ref), l_v167_3 (ref)
        if v120.antiaim.manuals.value == "Disabled" or not v371 then
            return;
        else
            l_v168_4:tick();
            l_v168_4.yaw.main = "Backward";
            l_v168_4.yaw.base = "Local View";
            l_v168_4.yaw.offset = l_v167_3[v120.antiaim.manuals.value];
            if v120.antiaim.manuals.static.value then
                l_v168_4.yaw_modifier.main = "Disabled";
                l_v168_4.body_yaw.options = "";
            end;
            l_v168_4.freestanding.main = false;
            l_v168_4:run();
            return;
        end;
    end);
end;
v167 = nil;
v168 = v119.new("Freestanding", 12);
do
    local l_v168_5 = v168;
    v30.Freestanding.createmove:set(function(_, v374)
        -- upvalues: v5 (ref), v120 (ref), l_v168_5 (ref), v6 (ref)
        v5.functions.freestand = false;
        if not v120.antiaim.fs.value or not v374 then
            return;
        elseif v5.functions.legit then
            return;
        else
            v5.functions.freestand = true;
            l_v168_5:tick();
            l_v168_5.freestanding.main = true;
            l_v168_5.freestanding.disablers = v120.antiaim.fs.disable_ym.value;
            l_v168_5.freestanding.body_fs = v120.antiaim.fs.body_fs.value;
            local v375 = false;
            for _, v377 in pairs(v120.antiaim.fs.disablers.value) do
                if v377 == v6.condition then
                    v375 = true;
                    break;
                end;
            end;
            if v375 then
                l_v168_5.freestanding.main = false;
                v5.functions.freestand = false;
            end;
            l_v168_5:run();
            return;
        end;
    end);
end;
v168 = nil;
v169 = {
    [1] = "CHostage", 
    [2] = "CPlantedC4"
};
v170 = -1;
v171 = function(v378, v379)
    for _, v381 in pairs(v379) do
        if v378:dist((v381:get_origin())) < 128 then
            return true;
        end;
    end;
    return false;
end;
v172 = v119.new("Legit AA", 8);
do
    local l_v169_2, l_v170_2, l_v171_1, l_v172_1 = v169, v170, v171, v172;
    v30["Legit AA"].createmove:set(function(v386, v387, v388)
        -- upvalues: v5 (ref), v120 (ref), l_v170_2 (ref), l_v169_2 (ref), l_v171_1 (ref), l_v172_1 (ref)
        v5.functions.legit = false;
        if not v120.antiaim.tweaks:get("Legit AA on Use") or not v388 then
            return;
        elseif not v386.in_use then
            l_v170_2 = -1;
            return;
        else
            local v389 = v387:get_player_weapon();
            if v389 == nil then
                return;
            elseif v389:get_classname() == "CC4" then
                return;
            else
                local v390 = v387:get_origin();
                for v391 = 1, #l_v169_2 do
                    if l_v171_1(v390, entity.get_entities(l_v169_2[v391], false)) then
                        return;
                    end;
                end;
                if l_v170_2 == -1 then
                    l_v170_2 = globals.tickcount + 1;
                end;
                if v387.m_bInBombZone then
                    v386.in_use = false;
                else
                    v386.in_use = l_v170_2 > globals.tickcount;
                end;
                l_v172_1:tick();
                l_v172_1.pitch = "Disabled";
                l_v172_1.yaw.main = "Backward";
                l_v172_1.yaw.base = "Local View";
                l_v172_1.yaw.offset = 180;
                l_v172_1.body_yaw.main = true;
                l_v172_1.freestanding.main = false;
                v5.functions.legit = true;
                l_v172_1:run();
                return;
            end;
        end;
    end);
end;
v169 = nil;
v169 = {};
v170 = false;
do
    local l_v170_3, l_v171_2, l_v172_2, l_v173_1 = v170, v171, v172, v173;
    l_v171_2 = function()
        -- upvalues: l_v170_3 (ref), v11 (ref)
        if l_v170_3 then
            v11.RAGE.double_tap.options:override();
            v11.RAGE.hide_shots.options:override();
            l_v170_3 = false;
        end;
    end;
    l_v172_2 = 0;
    l_v173_1 = false;
    v169.tweaks = function(v396)
        -- upvalues: l_v172_2 (ref), l_v173_1 (ref)
        local v397 = v396:get_player_weapon();
        if v397 == nil then
            return;
        else
            local l_m_flFlashDuration_0 = v396.m_flFlashDuration;
            if l_m_flFlashDuration_0 > 0 then
                if l_v172_2 == 0 then
                    l_v172_2 = globals.curtime + l_m_flFlashDuration_0 * 0.75;
                end;
                l_v173_1 = l_v172_2 > globals.curtime;
            else
                l_v172_2 = 0;
                l_v173_1 = false;
            end;
            if v396.m_flNextAttack > globals.curtime and v397:get_weapon_reload() == -1 then
                return "Weapon Switch";
            elseif l_v173_1 then
                return "Flashed";
            elseif v397:get_weapon_reload() ~= -1 then
                return "Reloading";
            else
                return;
            end;
        end;
    end;
    local v399 = {
        ["Double Tap"] = v11.RAGE.double_tap.main, 
        ["Hide Shots"] = v11.RAGE.hide_shots.main
    };
    local v400 = v119.new("Defensive", 7);
    v30["Defensive AA"].createmove:set(function(v401, v402, v403)
        -- upvalues: v120 (ref), l_v171_2 (ref), v399 (ref), v6 (ref), v169 (ref), v11 (ref), v5 (ref), v400 (ref), l_v170_3 (ref)
        if not v120.antiaim.defensive.value or not v403 then
            return l_v171_2();
        else
            local v404 = false;
            for _, v406 in pairs(v120.antiaim.defensive.triggers.value) do
                if v399[v406] and v399[v406]:get() then
                    v404 = true;
                    break;
                end;
            end;
            if not v404 then
                return l_v171_2();
            else
                local v407 = false;
                local v408 = false;
                for _, v410 in pairs(v120.antiaim.defensive.conditions.value) do
                    if v410 == "On Peek" then
                        v407 = true;
                        v408 = true;
                        break;
                    elseif v410 == v6.condition then
                        v407 = true;
                        break;
                    end;
                end;
                local v411 = v169.tweaks(v402);
                if not v120.antiaim.defensive.tweaks:get(v411) and not v407 then
                    return l_v171_2();
                else
                    local l_value_2 = v120.antiaim.defensive.pitch.value;
                    local l_x_0 = v401.view_angles.x;
                    if l_value_2 == "Zero" then
                        l_x_0 = 0;
                    elseif l_value_2 == "Up" then
                        l_x_0 = -89;
                    elseif l_value_2 == "Up-Switch" then
                        l_x_0 = utils.random_int(-45, -60);
                    elseif l_value_2 == "Down-Switch" then
                        l_x_0 = utils.random_int(45, 60);
                    elseif l_value_2 == "Random" then
                        l_x_0 = utils.random_int(-89, 89);
                    end;
                    local l_value_3 = v120.antiaim.defensive.yaw.value;
                    local l_y_0 = v401.view_angles.y;
                    if l_value_3 == "Spin" then
                        l_y_0 = math.normalize_yaw(-180 + globals.tickcount % 9 * 40 + utils.random_float(-30, 30));
                    elseif l_value_3 == "Sideways" then
                        l_y_0 = math.normalize_yaw(v6.jitter * 90 + utils.random_float(-30, 30));
                    elseif l_value_3 == "Forward" then
                        l_y_0 = math.normalize_yaw(180 * v6.jitter);
                    elseif l_value_3 == "Random" then
                        l_y_0 = math.normalize_yaw(utils.random_int(-180, 180));
                    end;
                    if not v408 then
                        v11.RAGE.double_tap.options:override("Always On");
                        v11.RAGE.hide_shots.options:override("Break LC");
                    else
                        l_v171_2();
                    end;
                    local l_value_4 = v120.antiaim.manuals.value;
                    local v417 = v6.condition == "Crouching" and v120.antiaim.manuals.exploit.value;
                    if v5.functions.freestand or l_value_4 ~= "Disabled" and not v417 then
                        return;
                    else
                        if l_value_2 ~= "Down" then
                            rage.antiaim:override_hidden_pitch(l_x_0);
                        end;
                        v400:tick();
                        v400.yaw.hidden = true;
                        if l_value_3 ~= "Default" then
                            if l_value_4 ~= "Disabled" and v417 then
                                rage.antiaim:override_hidden_pitch(utils.random_int(-5, 10));
                                rage.antiaim:override_hidden_yaw_offset(180 + utils.random_int(0, 10));
                            elseif v5.functions.safe and v120.antiaim.defensive.e_spam.value then
                                rage.antiaim:override_hidden_pitch(0);
                                rage.antiaim:override_hidden_yaw_offset(-180);
                            else
                                rage.antiaim:override_hidden_yaw_offset(l_y_0);
                            end;
                        end;
                        v400:run();
                        l_v170_3 = true;
                        return;
                    end;
                end;
            end;
        end;
    end);
end;
v170 = nil;
v170 = {
    on_condition = false, 
    is_air_weapon = false, 
    weapon = false, 
    presets = {
        Standing = {
            [3] = {
                inverter = false, 
                right_limit = 20, 
                left_limit = 20, 
                offset = 5
            }, 
            [2] = {
                inverter = false, 
                right_limit = 25, 
                left_limit = 20, 
                offset = 0
            }
        }, 
        Crouching = {
            [3] = {
                inverter = true, 
                right_limit = 60, 
                left_limit = 35, 
                offset = -5
            }, 
            [2] = {
                inverter = false, 
                right_limit = 26, 
                left_limit = 20, 
                offset = 17
            }
        }, 
        ["Air + Crouch"] = {
            [3] = {
                inverter = false, 
                right_limit = 25, 
                left_limit = 25, 
                offset = 0
            }, 
            [2] = {
                inverter = false, 
                right_limit = 25, 
                left_limit = 25, 
                offset = 0
            }
        }, 
        ["Slow Walking"] = {
            [3] = {
                inverter = false, 
                right_limit = 20, 
                left_limit = 20, 
                offset = 5
            }, 
            [2] = {
                inverter = false, 
                right_limit = 25, 
                left_limit = 20, 
                offset = 0
            }
        }, 
        [107] = {
            [3] = {
                inverter = true, 
                right_limit = 60, 
                left_limit = 60, 
                offset = 0
            }, 
            [2] = {
                inverter = true, 
                right_limit = 60, 
                left_limit = 60, 
                offset = 0
            }
        }, 
        [268] = {
            [3] = {
                inverter = false, 
                right_limit = 30, 
                left_limit = 60, 
                offset = 23
            }, 
            [2] = {
                inverter = false, 
                right_limit = 60, 
                left_limit = 20, 
                offset = 17
            }
        }
    }
};
v171 = v119.new("Safe Head", 15);
do
    local l_v171_3 = v171;
    v30["Safe Head"].createmove:set(function(_, v420, _)
        -- upvalues: v5 (ref), v120 (ref), v170 (ref), v6 (ref), v12 (ref), l_v171_3 (ref)
        v5.functions.safe = false;
        if #v120.antiaim.safe.value == 0 or v5.functions.legit or v5.functions.edge or v120.antiaim.manuals.value ~= "Disabled" then
            return;
        else
            v170.on_condition = false;
            v170.is_air_weapon = false;
            v170.class_id = 0;
            local l_condition_0 = v6.condition;
            if l_condition_0 == "Air" or l_condition_0 == "Air + Crouch" and not v170.on_condition then
                local v423 = v420:get_player_weapon();
                if v423 then
                    local v424 = v423:get_classid();
                    v170.class_id = v424;
                    if v424 == 107 then
                        v170.on_condition = v120.antiaim.safe:get(5);
                    elseif v424 == 268 then
                        v170.on_condition = v120.antiaim.safe:get(6);
                    end;
                    v170.is_air_weapon = true;
                end;
            end;
            if not v170.on_condition then
                for _, v426 in pairs(v120.antiaim.safe.value) do
                    if v6.condition == v426 then
                        v170.on_condition = true;
                        break;
                    end;
                end;
            end;
            if not v170.on_condition then
                return;
            else
                v5.functions.safe = v170.is_air_weapon;
                if not v5.functions.safe then
                    local v427 = v420:get_origin();
                    local v428 = entity.get_threat();
                    local _ = 0;
                    if v428 and v428:is_alive() then
                        local v430 = v428:get_origin();
                        if (v170.is_air_weapon and v427.z - 1 or v430.z + 5) < v427.z then
                            local v431 = utils.trace_bullet(v428, v12.extrapolate(v428, 5, v428:get_eye_position()), v420:get_hitbox_position(0) + vector(0, 0, 6));
                            v5.functions.safe = v431 > 0;
                        end;
                    end;
                end;
                l_v171_3:tick();
                if v5.functions.safe then
                    local v432 = v170.is_air_weapon and v170.presets[v170.class_id] or v170.presets[v6.condition];
                    if not v432 then
                        return;
                    else
                        local v433 = v432[v420.m_iTeamNum];
                        if not v433 then
                            return;
                        else
                            l_v171_3.yaw.main = "Backward";
                            l_v171_3.yaw.base = "At Target";
                            l_v171_3.yaw.offset = v433.offset;
                            l_v171_3.yaw_modifier.main = "Disabled";
                            l_v171_3.body_yaw.main = true;
                            l_v171_3.body_yaw.options = "";
                            l_v171_3.body_yaw.left_limit = v433.left_limit;
                            l_v171_3.body_yaw.right_limit = v433.right_limit;
                            rage.antiaim:inverter(v433.inverter);
                        end;
                    end;
                end;
                l_v171_3:run();
                return;
            end;
        end;
    end);
end;
v171 = nil;
v172 = v119.new("Edge Yaw", 5);
do
    local l_v172_3 = v172;
    v30["Edge Yaw"].createmove:set(function(v435, v436, _)
        -- upvalues: v5 (ref), v120 (ref), v6 (ref), v11 (ref), l_v172_3 (ref)
        v5.functions.edge = false;
        if not v120.antiaim.edge_yaw.value then
            return;
        elseif v5.functions.freestand then
            return;
        elseif v436 == nil or not v6.on_ground then
            return;
        else
            local v438 = {};
            local v439 = v436:get_eye_position();
            for v440 = 18, 360, 18 do
                local v441 = math.normalize_yaw(v440);
                local v442 = v439 + vector():angles(0, v441) * 28;
                local v443 = utils.trace_line(v439, v442, me, 33570827);
                local l_entity_0 = v443.entity;
                if v443.fraction ~= 1 and l_entity_0 ~= nil and l_entity_0:get_classname() == "CWorld" then
                    v438[#v438 + 1] = v443.end_pos;
                end;
            end;
            local v445 = #v438;
            if v445 < 2 then
                return;
            else
                local l_view_angles_0 = v435.view_angles;
                local v447 = (v439 - v438[1]:lerp(v438[v445], 0.5)):angles();
                local v448 = math.normalize_yaw(-l_view_angles_0.y + v447.y);
                if math.abs(v448) < 90 then
                    return;
                else
                    v448 = v448 * 2 + 180;
                    if v120.antiaim.edge_yaw.fd.value and not v11.AA.other.fake_duck:get() then
                        return;
                    else
                        l_v172_3:tick();
                        l_v172_3.yaw.base = "Local View";
                        l_v172_3.yaw.offset = math.normalize_yaw(v448);
                        if v120.antiaim.edge_yaw.disablers.value then
                            l_v172_3.yaw_modifier.main = "Disabled";
                            l_v172_3.body_yaw.options = "";
                        end;
                        l_v172_3:run();
                        return;
                    end;
                end;
            end;
        end;
    end);
end;
v172 = nil;
v173 = utils.get_vfunc("client.dll", "GameClientExports001", 3, "void(__thiscall*)(void*, int)");
do
    local l_v173_2 = v173;
    local function v452()
        -- upvalues: v120 (ref), l_v173_2 (ref)
        if not v120.additional.unmute.value then
            return;
        else
            for _, v451 in pairs(entity.get_players()) do
                if v451 ~= nil then
                    l_v173_2(v451:get_index());
                end;
            end;
            return;
        end;
    end;
    v120.additional.unmute:set_callback(v452, true);
    v30["Unmute Players"].player_connect_full:set(v452);
end;
v173 = nil;
ffi.cdef("        typedef void* hwnd;\n        typedef const char* lpcstr;\n\n        hwnd FindWindowA(lpcstr lpClassName, lpcstr lpWindowName);\n        bool FlashWindow(hwnd hWnd, bool bInvert);\n    ");
local v453 = ffi.C.FindWindowA("Valve001", nil);
do
    local l_v453_0 = v453;
    v30["Taskbar Notify"].round_start:set(function()
        -- upvalues: v120 (ref), l_v453_0 (ref)
        if not v120.additional.taskbar.value then
            return;
        else
            local v455 = entity.get_game_rules();
            if v455 == nil then
                return;
            elseif v455.m_bIsValveDS then
                return;
            else
                ffi.C.FlashWindow(l_v453_0, false);
                return;
            end;
        end;
    end);
end;
v453 = nil;
local function v456()
    cvar.viewmodel_fov:float(tonumber(cvar.viewmodel_fov:string()));
    cvar.viewmodel_offset_x:float(tonumber(cvar.viewmodel_offset_x:string()));
    cvar.viewmodel_offset_y:float(tonumber(cvar.viewmodel_offset_y:string()));
    cvar.viewmodel_offset_z:float(tonumber(cvar.viewmodel_offset_z:string()));
end;
do
    local l_v456_0 = v456;
    local function v458()
        -- upvalues: v120 (ref), l_v456_0 (ref)
        if v120.misc.viewmodel.value then
            cvar.viewmodel_fov:float(v120.misc.viewmodel.fov.value * 0.1, true);
            cvar.viewmodel_offset_x:float(v120.misc.viewmodel.x.value * 0.1, true);
            cvar.viewmodel_offset_y:float(v120.misc.viewmodel.y.value * 0.1, true);
            cvar.viewmodel_offset_z:float(v120.misc.viewmodel.z.value * 0.1, true);
        else
            l_v456_0();
        end;
    end;
    v120.misc.viewmodel:set_callback(v458, true);
    v120.misc.viewmodel.fov:set_callback(v458, true);
    v120.misc.viewmodel.x:set_callback(v458, true);
    v120.misc.viewmodel.y:set_callback(v458, true);
    v120.misc.viewmodel.z:set_callback(v458, true);
    v30.Viewmodel.shutdown:set(l_v456_0);
end;
v456 = nil;
local v459 = false;
local v460 = cvar.r_aspectratio:float();
do
    local l_v459_0, l_v460_0 = v459, v460;
    local function v463()
        -- upvalues: l_v459_0 (ref), l_v460_0 (ref)
        if l_v459_0 then
            cvar.r_aspectratio:float(l_v460_0);
            l_v459_0 = false;
        end;
    end;
    local function v465()
        -- upvalues: v120 (ref), l_v460_0 (ref), l_v459_0 (ref), v463 (ref)
        local v464 = v120.misc.aspect_ratio.value and v120.misc.aspect_ratio.ratio.value / 100 or l_v460_0;
        cvar.r_aspectratio:float(v464);
        if v464 == 0.49 then
            l_v459_0 = true;
            v463();
        else
            l_v459_0 = v464 ~= 0.49;
        end;
    end;
    v120.misc.aspect_ratio:set_callback(v465, true);
    v120.misc.aspect_ratio.ratio:set_callback(v465, true);
    v30["Aspect Ratio"].shutdown:set(v463);
end;
v459 = nil;
v459 = {};
v30.Hitmarker.aim_ack:set(function(v466, _, _)
    -- upvalues: v120 (ref), v459 (ref), v10 (ref)
    if not v120.modification.hitmarker.value then
        return;
    elseif v466.state then
        return;
    else
        v459[#v459 + 1] = {
            position = v466.aim or vector(), 
            duration = globals.realtime + v120.modification.hitmarker.duration.value, 
            animation = v10:new(), 
            size = v120.modification.hitmarker.size.value, 
            color = v120.modification.hitmarker.color.value
        };
        return;
    end;
end);
v30.Hitmarker.render:set(function(_, _)
    -- upvalues: v120 (ref), v459 (ref)
    if not v120.modification.hitmarker.value then
        return;
    else
        local l_realtime_1 = globals.realtime;
        for v472, v473 in pairs(v459) do
            if v473 then
                local v474 = v473.duration - l_realtime_1;
                local v475 = v473.animation(0.2, v474 > 0);
                if v475 <= 0 and v474 < 0 then
                    table.remove(v459, v472);
                else
                    local v476 = v473.position:to_screen();
                    if v476 ~= nil then
                        local v477 = v473.color:alpha_modulate(v475, true);
                        local l_size_0 = v473.size;
                        render.line(v476 + l_size_0, v476 + l_size_0 * 2, v477);
                        render.line(vector(v476.x - l_size_0, v476.y + l_size_0), vector(v476.x - l_size_0 * 2, v476.y + l_size_0 * 2), v477);
                        render.line(vector(v476.x + l_size_0, v476.y - l_size_0), vector(v476.x + l_size_0 * 2, v476.y - l_size_0 * 2), v477);
                        render.line(vector(v476.x - l_size_0, v476.y - l_size_0), vector(v476.x - l_size_0 * 2, v476.y - l_size_0 * 2), v477);
                    end;
                end;
            end;
        end;
        return;
    end;
end);
v460 = nil;
v460 = {};
v30["Shot Markers"].aim_ack:set(function(v479, _, _)
    -- upvalues: v120 (ref), v460 (ref), v10 (ref), v7 (ref), v5 (ref)
    if not v120.modification.shot_marker.value then
        return;
    else
        local v482 = table.convert(v120.modification.shot_marker.triggers.value);
        if v482.Hit and not v479.state then
            v460[#v460 + 1] = {
                position = v479.aim or vector(), 
                duration = globals.realtime + v120.modification.shot_marker.duration.value, 
                animation = v10:new(), 
                color = v120.modification.shot_marker.hit_color.value, 
                font = v7[v120.modification.shot_marker.font.value], 
                text = v5.hitgroups[v479.hitgroup]:upper()
            };
        elseif v482.Miss and v479.state then
            v460[#v460 + 1] = {
                position = v479.aim or vector(), 
                duration = globals.realtime + v120.modification.shot_marker.duration.value, 
                animation = v10:new(), 
                color = v120.modification.shot_marker.miss_color.value, 
                font = v7[v120.modification.shot_marker.font.value], 
                text = v479.state:upper()
            };
        end;
        return;
    end;
end);
v30["Shot Markers"].render:set(function()
    -- upvalues: v120 (ref), v460 (ref), v8 (ref)
    if not v120.modification.shot_marker.value then
        return;
    else
        local l_realtime_2 = globals.realtime;
        for v484, v485 in pairs(v460) do
            if v485 then
                local v486 = v485.duration - l_realtime_2;
                local v487 = v485.animation(0.2, v486 > 0);
                if v487 <= 0 and v486 < 0 then
                    table.remove(v460, v484);
                else
                    local v488 = v485.position:to_screen();
                    if v488 ~= nil then
                        render.text(v485.font, v488, v8.white:alpha_modulate(v487, true), "c", "x");
                        render.text(v485.font, vector(v488.x + 3, v488.y - 1), v485.color:alpha_modulate(v487, true), nil, v485.text);
                    end;
                end;
            end;
        end;
        return;
    end;
end);
local v489 = nil;
v489 = {};
local v490 = {
    [1] = 0, 
    [2] = 5, 
    [3] = 2, 
    [4] = 13, 
    [5] = 14, 
    [6] = 7, 
    [7] = 8
};
v30["Damage Markers"].player_hurt:set(function(v491, v492, v493)
    -- upvalues: v120 (ref), v489 (ref), v10 (ref), v7 (ref)
    if not v120.modification.damage_marker.value or not v493 then
        return;
    else
        local v494 = entity.get(v491.userid, true);
        local v495 = entity.get(v491.attacker, true);
        if v494 == nil or v494 == v492 or v495 == nil or v495 ~= v492 then
            return;
        else
            local l_hitgroup_0 = v491.hitgroup;
            local l_weapon_0 = v491.weapon;
            local v498 = "hit";
            if l_hitgroup_0 == 1 then
                v498 = "head";
            elseif l_weapon_0 == "hegrenade" or l_weapon_0 == "inferno" then
                v498 = "nade";
            end;
            v489[#v489 + 1] = {
                position = v494:get_hitbox_position(1), 
                duration = globals.realtime + 1, 
                animation = v10:new(), 
                damage = v491.dmg_health, 
                color = v120.modification.damage_marker[v498].value, 
                font = v7[v120.modification.damage_marker.font.value]
            };
            return;
        end;
    end;
end);
v30["Damage Markers"].render:set(function()
    -- upvalues: v120 (ref), v489 (ref)
    if not v120.modification.damage_marker.value then
        return;
    else
        local l_realtime_3 = globals.realtime;
        for v500, v501 in pairs(v489) do
            if v501 then
                local v502 = v501.duration - l_realtime_3;
                local v503 = v501.animation(0.2, v502 > 0);
                if v503 <= 0 and v502 < 0 then
                    table.remove(v489, v500);
                else
                    local l_position_1 = v501.position;
                    local v505 = vector(l_position_1.x, l_position_1.y, l_position_1.z + 60 - v502 * 40):to_screen();
                    if v505 ~= nil then
                        render.text(v501.font, v505, v501.color:alpha_modulate(v503, true), nil, v501.damage);
                    end;
                end;
            end;
        end;
        return;
    end;
end);
v490 = nil;
local v506 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
local v507 = false;
local v508 = color();
local function v512(v509)
    -- upvalues: v8 (ref)
    if not v509 then
        v509 = v8.white;
    end;
    materials.get_materials("vgui/hud/800", false, function(v510)
        -- upvalues: v509 (ref)
        v510:color_modulate(v509);
        v510:alpha_modulate(v509.a / 255);
    end);
    materials.get_materials("vgui_white", false, function(v511)
        -- upvalues: v509 (ref)
        v511:color_modulate(v509);
        v511:alpha_modulate(v509.a / 255);
    end);
end;
do
    local l_v506_0, l_v507_0, l_v508_0, l_v512_0 = v506, v507, v508, v512;
    local function v518()
        -- upvalues: v120 (ref), l_v507_0 (ref), l_v512_0 (ref), l_v508_0 (ref), l_v506_0 (ref)
        if not v120.additional.console.value then
            if l_v507_0 then
                l_v507_0 = false;
                l_v512_0();
            end;
            return;
        else
            local l_value_5 = v120.additional.console.color.value;
            if l_value_5 ~= l_v508_0 then
                l_v507_0 = not l_v506_0();
                l_v512_0(l_value_5);
                l_v508_0 = l_value_5;
            end;
            if l_v506_0() then
                if not l_v507_0 then
                    l_v507_0 = true;
                    l_v512_0(l_value_5);
                end;
            elseif l_v507_0 then
                l_v507_0 = false;
                l_v512_0();
            end;
            return;
        end;
    end;
    events.pre_render(v518);
    events.shutdown:set(l_v512_0);
end;
v506 = nil;
v507 = false;
v508 = ffi.typeof("        struct {\n            float   anim_time;\n            float   fade_out_time;\n            int     nil;\n            int     activty;\n            int     priority;\n            int     order;\n            int     sequence;\n            float   prev_cycle;\n            float   weight;\n            float   weight_delta_rate;\n            float   playback_rate;\n            float   cycle;\n            int     owner;\n            int     bits;\n        }\n        ");
do
    local l_v507_1, l_v508_1 = v507, v508;
    v30["Animation Breaker"].post_update_clientside_animation:set(function(v521, v522, _)
        -- upvalues: v120 (ref), l_v507_1 (ref), v11 (ref), l_v508_1 (ref), v6 (ref)
        if not v120.antiaim.animations.value then
            if l_v507_1 then
                l_v507_1 = false;
                v11.AA.other.leg_movement:override();
            end;
            return;
        elseif v522 == nil or v521 == nil then
            return;
        else
            if v521 == v522 then
                local v524 = ffi.cast("uintptr_t", v521[0]);
                local v525 = ffi.cast(ffi.typeof("$**", l_v508_1), v524 + 10640)[0];
                if v6.on_ground then
                    local l_value_6 = v120.antiaim.animations.ground.value;
                    if l_value_6 ~= "Off" then
                        if l_value_6 == "Static" then
                            v521.m_flPoseParameter[0] = 1;
                            v11.AA.other.leg_movement:override("Sliding");
                            l_v507_1 = true;
                        elseif l_value_6 == "Walking" then
                            v521.m_flPoseParameter[7] = 0.5;
                            v11.AA.other.leg_movement:override("Walking");
                            l_v507_1 = true;
                        end;
                    elseif l_v507_1 then
                        l_v507_1 = false;
                        v11.AA.other.leg_movement:override();
                    end;
                else
                    local l_value_7 = v120.antiaim.animations.air.value;
                    if l_value_7 ~= "Off" then
                        if l_value_7 == "Static" then
                            v521.m_flPoseParameter[6] = 1;
                        elseif l_value_7 == "Walking" then
                            local v528 = globals.realtime * 0.7 % 2;
                            if v528 > 1 then
                                v528 = 1 - (v528 - 1);
                            end;
                            v525[6].weight = 1;
                        end;
                    end;
                end;
                if v120.antiaim.animations.pitch.value and v6.on_land then
                    v521.m_flPoseParameter[12] = 0.5;
                end;
            end;
            return;
        end;
    end);
end;
v507 = nil;
v508 = "\t";
v512 = "\t";
do
    local l_v508_2, l_v512_1 = v508, v512;
    local function v540(v531)
        -- upvalues: l_v508_2 (ref), l_v512_1 (ref)
        local v532 = {};
        local v533 = #v531;
        if v533 < 2 then
            table.insert(v532, v531);
            return v532;
        else
            for _ = 1, 8 do
                table.insert(v532, string.format("%s%s%s", l_v508_2, v531, l_v512_1));
            end;
            for v535 = 1, v533 do
                local v536 = v531:sub(v535, v533);
                table.insert(v532, string.format("%s%s%s", l_v508_2, v536, l_v512_1));
            end;
            table.insert(v532, string.format("%s%s", l_v508_2, l_v512_1));
            for v537 = math.min(2, v533), v533 do
                local v538 = v531:sub(1, v537);
                table.insert(v532, string.format("%s%s%s", l_v508_2, v538, l_v512_1));
            end;
            for _ = 1, 4 do
                table.insert(v532, string.format("%s%s%s", l_v508_2, v531, l_v512_1));
            end;
            return v532;
        end;
    end;
    local v541 = -1;
    local v542 = v540(v120.misc.clantag.text.value);
    local function v543()
        -- upvalues: v542 (ref), v540 (ref), v120 (ref)
        v542 = v540(v120.misc.clantag.text.value);
    end;
    v120.misc.clantag.text:set_callback(v543, true);
    v30.Clantag.net_update_end:set(function(v544, _)
        -- upvalues: v120 (ref), v542 (ref), v541 (ref)
        if not v120.misc.clantag.value then
            return;
        elseif v544 == nil or v544.m_iTeamNum == 0 then
            return;
        else
            local v546 = utils.net_channel();
            if v546 == nil then
                return;
            else
                local v547 = v546.latency[0] / globals.tickinterval;
                local v548 = globals.tickcount + v547;
                local v549 = math.floor(v548 * 0.0625) % #v542 + 1;
                if v549 == v541 then
                    return;
                else
                    v541 = v549;
                    common.set_clan_tag(v542[v549] or "");
                    return;
                end;
            end;
        end;
    end);
    v30.Clantag.shutdown:set(function()
        common.set_clan_tag("");
    end);
end;
v508 = nil;
v508 = {
    width = v10:new(), 
    invert = v10:new()
};
v512 = v5.screen_center;
do
    local l_v512_2 = v512;
    v30["Scope Overlay"].render:set(function(v551, v552)
        -- upvalues: v120 (ref), v508 (ref), l_v512_2 (ref)
        if not v120.misc.scope.value or not v552 then
            return;
        else
            local l_m_bIsScoped_0 = v551.m_bIsScoped;
            local v554 = v508.width(0.05, l_m_bIsScoped_0);
            if v554 <= 0 then
                return;
            else
                local l_value_8 = v120.misc.scope.inverted.color.value;
                l_value_8.a = 255;
                local v556 = l_m_bIsScoped_0 and v120.misc.scope.size.value * v554 or 0;
                local l_value_9 = v120.misc.scope.gap.value;
                local v558 = v508.invert(0.2, v120.misc.scope.inverted.value);
                local v559 = l_value_8:alpha_modulate(0);
                local v560 = l_value_8:lerp(v559, v558);
                local v561 = v559:lerp(l_value_8, v558);
                if not v120.misc.scope.t.value then
                    render.gradient(vector(l_v512_2.x, l_v512_2.y - l_value_9), vector(l_v512_2.x + 1, l_v512_2.y - l_value_9 - v556), v560, v560, v561, v561);
                end;
                render.gradient(vector(l_v512_2.x, l_v512_2.y + l_value_9 + 1), vector(l_v512_2.x + 1, l_v512_2.y + l_value_9 + v556 + 1), v560, v560, v561, v561);
                render.gradient(vector(l_v512_2.x - l_value_9, l_v512_2.y), vector(l_v512_2.x - l_value_9 - v556, l_v512_2.y + 1), v560, v561, v560, v561);
                render.gradient(vector(l_v512_2.x + l_value_9 + 1, l_v512_2.y), vector(l_v512_2.x + l_value_9 + v556 + 1, l_v512_2.y + 1), v560, v561, v560, v561);
                return;
            end;
        end;
    end);
end;
v512 = nil;
v512 = {
    head = {
        [1] = "1", 
        [2] = "\203\156\226\128\157\194\176\226\128\162.\203\156\226\128\157\194\176\226\128\162 1 \226\128\162\194\176\226\128\157\203\156.\226\128\162\194\176\226\128\157\203\156", 
        [3] = "1 on my screen"
    }, 
    body = {
        [1] = "AHHAHAHHAHAHH", 
        [2] = "iqless nn / bot", 
        [3] = "\209\131\208\187\208\181\209\130\208\176\208\181\209\136 \208\178 \208\186\208\190\208\191\208\184\208\187\208\186\209\131 \208\188\208\181\209\128\209\130\208\178\209\139\209\133 \209\129\208\190\209\135\208\189\208\184\208\186\208\190\208\178"
    }, 
    taser = {
        [1] = "\209\136\208\187\209\142\209\133\208\176 \208\189\208\176 \208\183\208\181\208\178\209\129\208\181", 
        [2] = "a12 / f12", 
        [3] = "yt bot"
    }, 
    knife = {
        [1] = "cy@yt", 
        [2] = "\208\189\208\176 \208\189\208\190\208\182\208\181 \209\133\209\131\208\185\209\129\208\190\209\129\208\184\208\186", 
        [3] = "a12 / f12"
    }, 
    inferno = {
        [1] = "\209\129\208\179\208\190\209\128\208\181\208\187 \208\191\208\184\208\180\208\190\209\128\208\176\209\129 \208\181\208\177\208\176\208\189\209\139\208\185", 
        [2] = "\209\135\208\181 \209\129\208\188\208\190\208\186 \209\130\209\143\208\182\208\181\208\187\208\190 \208\186\208\184\208\189\209\131\209\130\209\140 \208\180\208\190\208\187\208\177\208\176\208\181\208\177?", 
        [3] = "\208\179\208\190\209\128\208\184 \208\178 \208\176\208\180\209\131"
    }, 
    hegrenade = {
        [1] = "\208\178\208\183\208\190\209\128\208\178\208\176\208\189 \209\133\209\131\208\185\209\129\208\190\209\129", 
        [2] = "allah akbar \209\133\209\131\208\185\209\129\208\190\209\129"
    }, 
    death = {
        [1] = "\209\135\209\130\208\190 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187 / \209\130\209\131\208\191\208\190\208\185 \208\180\208\176\209\131\208\189 / \208\177\208\181\208\183\208\188\208\190\208\183\208\179\208\187\209\139\208\185", 
        [2] = "\208\189\208\181 \208\191\208\190\208\178\208\181\208\183\208\187\208\190", 
        [3] = "\208\189\209\131 \209\132\209\131 / \209\135\209\130\208\190 \209\130\209\139 \208\180\208\181\208\187\208\176\208\181\209\136\209\140"
    }
};
v512.get_phrase = function(_, v563)
    -- upvalues: v512 (ref)
    local v564 = v512[v563];
    if not v564 then
        return;
    else
        local v565 = #v564;
        if v565 == 0 then
            return;
        else
            local v566 = v564[utils.random_int(1, v565)];
            if v566 == nil then
                return;
            else
                return string.split(v566, " / ");
            end;
        end;
    end;
end;
v30.Trashtalk.player_death:set(function(v567, v568, _)
    -- upvalues: v120 (ref), v512 (ref)
    if not v120.misc.trashtalk.value then
        return;
    else
        local v570 = entity.get(v567.userid, true);
        local v571 = entity.get(v567.attacker, true);
        local v572 = nil;
        if v571 == v568 and v570 ~= v568 then
            v572 = "body";
            if v567.headshot then
                v572 = "head";
            end;
            if v512[v567.weapon] ~= nil then
                v572 = v567.weapon;
            end;
        elseif v571 ~= v568 and v570 == v568 then
            v572 = "death";
        end;
        if not v572 then
            return;
        else
            local v573 = v512:get_phrase(v572);
            if v573 == nil then
                return;
            else
                for _, v575 in ipairs(v573) do
                    local v576 = v575:len() > 15 and v575:len() / 5 or v575:len() / 20;
                    if v576 > 5 then
                        v576 = v576 / 2;
                    end;
                    if v576 > 5 then
                        v576 = v576 / 2;
                    end;
                    do
                        local l_v575_0 = v575;
                        utils.execute_after(v576, function()
                            -- upvalues: l_v575_0 (ref)
                            utils.console_exec("say " .. l_v575_0);
                        end);
                    end;
                end;
                return;
            end;
        end;
    end;
end);
local v578 = "";
if v5.version ~= "Release" then
    v578 = string.format("\aE7605FFF[%s]", v5.version:upper());
end;
do
    local l_v578_0 = v578;
    v30["Bottom Watermark"].render:set(function(_, _)
        -- upvalues: v120 (ref), v8 (ref), l_v578_0 (ref), v5 (ref)
        if v120.visuals.indicators.value then
            return;
        else
            local v582 = string.wave("I D E A L", v8.white, color(55, 55, 55, 255), -1.5);
            v582 = string.format("%s \a{Link Active}Y A W %s", v582, l_v578_0);
            render.text(1, vector(v5.screen_center.x, v5.screen.y - 20), v8.white, "c", v582);
            return;
        end;
    end);
end;
v578 = nil;
v578 = {
    time = 0, 
    delay = 0, 
    weapons = {
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
    }
};
v30["Air Teleport"].createmove:set(function(_, v584, v585)
    -- upvalues: v120 (ref), v6 (ref), v578 (ref), v12 (ref)
    if not v120.rage.teleport.value or not v585 then
        rage.exploit:allow_charge(true);
        return;
    else
        local l_value_10 = v120.rage.teleport.weapons.value;
        if #l_value_10 == 0 then
            return;
        elseif v6.on_ground or #v584.m_vecVelocity < 100 then
            return;
        elseif rage.exploit:get() ~= 1 then
            return;
        else
            local v587 = entity.get_threat();
            if v587 == nil then
                return;
            else
                local v588 = v584:get_player_weapon();
                if v588 == nil then
                    return;
                else
                    local v589 = v588:get_weapon_index();
                    local v590 = false;
                    local v591 = false;
                    for _, v593 in ipairs(l_value_10) do
                        local v594 = v578.weapons[v593];
                        if v594 then
                            for _, v596 in ipairs(v594) do
                                if v596 == v589 then
                                    v590 = true;
                                    break;
                                end;
                            end;
                        elseif v593 == "Knife" then
                            v591 = true;
                        end;
                    end;
                    if not v590 and v591 and v588:get_classid() == 107 then
                        v590 = true;
                    end;
                    if not v590 then
                        return;
                    else
                        local v597 = v587:get_resource();
                        if not v597 then
                            return;
                        else
                            local l_m_iPing_0 = v597.m_iPing;
                            local v599 = math.max(5, to_ticks(l_m_iPing_0 * (l_m_iPing_0 <= 10 and 2 or 1.75) / 1000));
                            local v600 = v587:get_hitbox_position(4);
                            local v601 = v584:get_hitbox_position(4);
                            local v602, v603 = utils.trace_bullet(v587, v600, v12.extrapolate(v584, v599, v601));
                            local v604;
                            if not v602 or v602 <= 0 then
                                v604 = false;
                            elseif not v603.entity or v603.entity:get_classname() == "CWorld" then
                                v604 = false;
                            else
                                v604 = true;
                            end;
                            if v604 and v578.time < globals.realtime then
                                if v578.delay == v120.rage.teleport.delay.value then
                                    v578.time = globals.realtime + 0.5;
                                    rage.exploit:force_teleport();
                                    rage.exploit:allow_charge(false);
                                    v578.delay = 0;
                                end;
                                v578.delay = v578.delay + 1;
                            else
                                rage.exploit:allow_charge(true);
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
end);
local v605 = nil;
v605 = {
    reset = false, 
    replacements = {
        [267] = "Scout", 
        [242] = "Auto", 
        [261] = "Auto", 
        [233] = "AWP"
    }, 
    backups = function(v606)
        -- upvalues: v11 (ref)
        if v606.reset then
            v11.RAGE.hit_chance:override();
            v11.RAGE.auto_scope:override();
            v606.reset = false;
        end;
    end, 
    distance = function(_, v608, v609)
        local v610 = v608:get_origin();
        if v610 == nil then
            return;
        else
            local v611 = entity.get_threat();
            if v611 == nil then
                return;
            else
                local v612 = v611:get_origin();
                if v612 == nil then
                    return;
                elseif v609 == 1001 then
                    return "Inf.";
                else
                    return v610:in_range(v612, v609);
                end;
            end;
        end;
    end
};
v30.Hitchance.createmove:set(function(_, v614, v615)
    -- upvalues: v120 (ref), v605 (ref), v6 (ref), v11 (ref)
    if not v120.rage.hitchance.value or not v615 then
        return v605:backups();
    else
        local v616 = v614:get_player_weapon();
        if v616 == nil then
            return v605:backups();
        else
            local v617 = v605.replacements[v616:get_classid()];
            if v617 == nil then
                return v605:backups();
            elseif not v120.rage.hitchance["Enabled_" .. v617].value then
                return v605:backups();
            else
                local v618 = v605:distance(v614, v120.rage.hitchance["Distance_" .. v617].value);
                local v619 = table.convert(v120.rage.hitchance["Conditions_" .. v617].value);
                if v619["In Air"] and not v6.on_ground then
                    v11.RAGE.hit_chance:override(v120.rage.hitchance["In Air_" .. v617].value);
                elseif v619["No Scope"] and not v614.m_bIsScoped and v618 then
                    v11.RAGE.hit_chance:override(v120.rage.hitchance["No Scope_" .. v617].value);
                    v11.RAGE.auto_scope:override(false);
                else
                    return v605:backups();
                end;
                if v618 == "Inf." then
                    v11.RAGE.auto_scope:override();
                end;
                v605.reset = true;
                return;
            end;
        end;
    end;
end);
local v620 = nil;
v620 = {
    reset = false, 
    animation = v10:new(), 
    backups = function(v621)
        -- upvalues: v11 (ref)
        if v621.reset then
            v11.RAGE.double_tap.main:override();
            v11.AA.angles.freestanding.main:override();
            v11.RAGE.min_damage:override();
            v11.RAGE.body_aim:override();
            v11.RAGE.safe_point:override();
            v11.RAGE.delay_shot:override();
            v621.reset = false;
        end;
    end
};
local v622 = {
    ["SSG 08"] = {
        [1] = 40
    }, 
    ["Deagle / Pistols"] = {
        [1] = 4, 
        [2] = 63, 
        [3] = 36, 
        [4] = 3, 
        [5] = 1, 
        [6] = 2, 
        [7] = 30, 
        [8] = 61, 
        [9] = 32
    }, 
    AWP = {
        [1] = 9
    }, 
    ["R8 Revolver"] = {
        [1] = 64
    }
};
local v623 = v119.new("Peek", 338);
do
    local l_v622_0, l_v623_0 = v622, v623;
    v30["Ideal Peek"].createmove:set(function(_, v627, _)
        -- upvalues: v5 (ref), v120 (ref), v11 (ref), v620 (ref), l_v622_0 (ref), l_v623_0 (ref)
        v5.functions.peek = false;
        if not v120.rage.peek.value or not v11.RAGE.auto_peek:get() then
            return v620:backups();
        else
            local v629 = v627:get_player_weapon();
            if v629 == nil then
                return v620:backups();
            else
                local v630 = v629:get_weapon_index();
                local v631 = false;
                for _, v633 in ipairs(v120.rage.peek.weapons.value) do
                    local v634 = l_v622_0[v633];
                    if v634 then
                        for _, v636 in ipairs(v634) do
                            if v636 == v630 then
                                v631 = true;
                                break;
                            end;
                        end;
                    end;
                end;
                if not v631 then
                    return v620:backups();
                else
                    v5.functions.peek = true;
                    l_v623_0:tick();
                    local v637 = table.convert(v120.rage.peek.options.value);
                    if v637["Double Tap"] then
                        v11.RAGE.double_tap.main:override(true);
                    end;
                    if v637.Freestanding then
                        l_v623_0.freestanding.main = true;
                    end;
                    if v637["Min. Damage"] then
                        v11.RAGE.min_damage:override(v120.rage.peek.damage.value);
                    end;
                    if v637["Prefer Baim"] then
                        v11.RAGE.body_aim:override("Prefer");
                    end;
                    if v637["Prefer Safe Points"] then
                        v11.RAGE.safe_point:override("Prefer");
                    end;
                    if v637["Delay Shot"] then
                        v11.RAGE.delay_shot:override(true);
                    end;
                    l_v623_0:run();
                    v620.reset = true;
                    return;
                end;
            end;
        end;
    end);
    local v638 = v118.add("Ideal Peek", vector(v5.screen_center.x - 50, v5.screen_center.y - 150), vector(100, 30));
    v30["Ideal Peek"].render:set(function(_, _)
        -- upvalues: v620 (ref), v120 (ref), v5 (ref), v638 (ref), v8 (ref)
        local v641 = v620.animation(0.2, v120.rage.peek.value and v120.rage.peek.indicate.value and (v5.alpha ~= 0 or v5.functions.peek));
        if v641 <= 0 then
            return;
        else
            if v5.alpha ~= 0 then
                v638:process();
                render.rect_outline(v638.position, v638.position + v638.size, v8.white:alpha_modulate(v5.alpha * v641 * v638.alpha, true), 0, 5);
            end;
            local v642 = rage.exploit:get();
            local v643 = string.format("\"+-IDEAL-PEEK-+\" %s%%", math.floor(v642 * 100));
            if v642 > 0.9 then
                v643 = "\"+-IDEAL-PEEK-+\"";
            end;
            render.text(2, v638.position + v638.size / 2, v8.white:alpha_modulate(v641 * v638.alpha, true), "c", v643);
            return;
        end;
    end);
end;
v622 = nil;
v623 = v119.new("Builder", 1);
local v644 = -1;
local v645 = 0;
local v646 = 1;
local v647 = nil;
do
    local l_v623_1, l_v644_0, l_v645_0, l_v646_0, l_v647_0 = v623, v644, v645, v646, v647;
    v30["AA Builder"].createmove:set(function(v653, _, v655)
        -- upvalues: v120 (ref), v6 (ref), v5 (ref), l_v644_0 (ref), l_v645_0 (ref), l_v647_0 (ref), l_v646_0 (ref), l_v623_1 (ref)
        if v120.antiaim.type.value ~= 1 or not v655 then
            return;
        else
            local l_condition_1 = v6.condition;
            if not v120.conditional[l_condition_1].enabled.value then
                l_condition_1 = v5.conditions[1];
            end;
            local v657 = v120.conditional[l_condition_1];
            local l_value_11 = v657.yaw.offset.value;
            local l_value_12 = v657.yaw.swap_type.value;
            local l_value_13 = v657.yaw_modifier.value;
            local l_value_14 = v657.yaw_modifier.offset1.value;
            local l_value_15 = v657.yaw_modifier.randomize.value;
            if l_value_12 == "180 L&R" then
                l_value_11 = rage.antiaim:inverter() and v657.yaw.left.value or v657.yaw.right.value;
            end;
            if l_value_12 == "Delayed Swap" and not v5.functions.safe then
                local v663 = false;
                local v664 = to_ticks(globals.realtime) - l_v644_0;
                v663 = v664 * 2 >= v657.yaw.delay.value;
                if v657.yaw.delay.value <= v664 then
                    l_v644_0 = to_ticks(globals.realtime);
                end;
                if v653.choked_commands == 0 or rage.exploit:get() < 1 then
                    l_v645_0 = v663 and v657.yaw.left.value or v657.yaw.right.value;
                end;
                rage.antiaim:inverter(v663);
                l_value_11 = l_v645_0;
            end;
            if l_value_15 ~= 0 then
                if v6.jitter_count % 2 == 0 or l_v647_0 == nil then
                    l_v647_0 = utils.random_int(0, (l_value_14 > 0 and 1 or -1) * l_value_15);
                end;
                l_value_14 = math.normalize_yaw(l_value_14 + l_v647_0);
            end;
            if l_value_13 == "3-Way" or l_value_13 == "5-Way" then
                if v653.choked_commands == 0 then
                    l_v646_0 = l_v646_0 + 1;
                    if l_v646_0 > (l_value_13 == "3-Way" and 3 or 5) then
                        l_v646_0 = 1;
                    end;
                end;
                if v657.yaw_modifier.custom_way.value then
                    l_value_11 = v657.yaw_modifier["offset" .. l_v646_0].value;
                    l_value_13 = "Disabled";
                    l_value_14 = 0;
                end;
            end;
            l_v623_1:tick();
            l_v623_1.pitch = v5.functions.legit and "Disabled" or v657.pitch.value;
            l_v623_1.yaw.main = v657.yaw.value;
            l_v623_1.yaw.base = v657.yaw.base.value;
            l_v623_1.yaw.offset = l_value_11;
            l_v623_1.yaw_modifier.main = l_value_13;
            l_v623_1.yaw_modifier.offset = l_value_14;
            l_v623_1.body_yaw.main = v657.body_yaw.value;
            l_v623_1.body_yaw.inverter = v657.body_yaw.inverter.value;
            l_v623_1.body_yaw.left_limit = v657.body_yaw.left_limit.value;
            l_v623_1.body_yaw.right_limit = v657.body_yaw.right_limit.value;
            l_v623_1.body_yaw.options = v657.body_yaw.options.value;
            l_v623_1.body_yaw.freestanding = v657.body_yaw.freestanding.value;
            l_v623_1:run();
            return;
        end;
    end);
end;
v623 = nil;
v623 = {
    copy = function()
        -- upvalues: v123 (ref), v1 (ref), v9 (ref)
        local v665 = v123:save("conditional");
        if v665 == nil then
            return print("[Presets] Failed to Copy.");
        else
            local l_status_8, l_result_8 = pcall(json.stringify, v665);
            if not l_status_8 then
                return print("[Presets] Failed to json.stringify.");
            else
                local l_status_9, l_result_9 = pcall(v1.encode, l_result_8);
                if not l_status_9 then
                    return print("[Presets] Failed to base64.encode.");
                else
                    v9.set(l_result_9);
                    return l_result_9;
                end;
            end;
        end;
    end, 
    parse = function(v670)
        -- upvalues: v1 (ref)
        local l_status_10, l_result_10 = pcall(v1.decode, v670);
        if not l_status_10 then
            return print("[Presets] Failed to decode.");
        else
            local l_status_11, l_result_11 = pcall(json.parse, l_result_10);
            if not l_status_11 then
                return print("[Presets] Failed to parse.");
            else
                return l_result_11.conditional;
            end;
        end;
    end, 
    import = function()
        -- upvalues: v9 (ref), v1 (ref), v123 (ref)
        local v675 = v9.get();
        local l_status_12, l_result_12 = pcall(v1.decode, v675);
        if not l_status_12 then
            return print("[Presets] Failed to decode.");
        else
            local l_status_13, l_result_13 = pcall(json.parse, l_result_12);
            if not l_status_13 then
                return print("[Presets] Failed to parse.");
            else
                v123:load(l_result_13, {
                    [1] = "conditional"
                });
                return;
            end;
        end;
    end
};
v120.antiaim.copy:set_callback(v623.copy);
v120.antiaim.import:set_callback(v623.import);
v623.Center = v623.parse("eyJjb25kaXRpb25hbCI6eyJBaXIiOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi0zLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MTYuMCwic3dhcF90eXBlIjoiMTgwIEwmUiJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotNDcuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjIuMH19LCJBaXIgKyBDcm91Y2giOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi04LjAsIm9mZnNldCI6MTIuMCwicmlnaHQiOjE0LjAsInN3YXBfdHlwZSI6IjE4MCBMJlIifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6LTQ2LjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiQ3JvdWNoaW5nIjp7ImJvZHlfeWF3Ijp0cnVlLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMC4wLCJsZWZ0IjotMTAuMCwib2Zmc2V0IjozNS4wLCJyaWdodCI6MTYuMCwic3dhcF90eXBlIjoiMTgwIEwmUiJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotMzUuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19LCJGYWtlIExhZyI6eyJib2R5X3lhdyI6ZmFsc2UsImVuYWJsZWQiOmZhbHNlLCJwaXRjaCI6IkRpc2FibGVkIiwieWF3IjoiRGlzYWJsZWQiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkxvY2FsIFZpZXciLCJkZWxheSI6MTAuMCwibGVmdCI6MC4wLCJvZmZzZXQiOjAuMCwicmlnaHQiOjAuMCwic3dhcF90eXBlIjoiMTgwIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOjAuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19LCJJbiBVc2UiOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXciOiJEaXNhYmxlZCIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6IlBlZWsgRmFrZSIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MzUuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19LCJNb3ZpbmciOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6MzYuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0IjozNi4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi02LjAsIm9mZnNldCI6MzQuMCwicmlnaHQiOjExLjAsInN3YXBfdHlwZSI6IjE4MCBMJlIifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6LTUyLjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiU2hhcmVkIjp7ImJvZHlfeWF3Ijp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMC4wLCJsZWZ0IjoxNS4wLCJvZmZzZXQiOi0xNy4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAgTCZSIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOi02OS4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIlNsb3cgV2Fsa2luZyI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kaWZpZXIiOiJTcGluIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NDUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo0NS4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi0yMy4wLCJvZmZzZXQiOjQ1LjAsInJpZ2h0Ijo0Ny4wLCJzd2FwX3R5cGUiOiIxODAgTCZSIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOi01LjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiU3RhbmRpbmciOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6MzAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0IjozMC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi03LjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MTEuMCwic3dhcF90eXBlIjoiMTgwIEwmUiJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjo0Ni4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6NS4wfX19fQ==");
v623.Meta = v623.parse("eyJjb25kaXRpb25hbCI6eyJBaXIiOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiMy1XYXkiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0IjoyOS4wLCJvcHRpb25zIjpbIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0IjoyOS4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjguMCwibGVmdCI6LTMzLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MzguMCwic3dhcF90eXBlIjoiMTgwIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6dHJ1ZSwib2Zmc2V0MSI6LTE5LjAsIm9mZnNldDIiOi0zNy4wLCJvZmZzZXQzIjozNy4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiQWlyICsgQ3JvdWNoIjp7ImJvZHlfeWF3Ijp0cnVlLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5Ijo3LjAsImxlZnQiOi0xNi4wLCJvZmZzZXQiOjAuMCwicmlnaHQiOjM4LjAsInN3YXBfdHlwZSI6IjE4MCJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotNDQuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19LCJDcm91Y2hpbmciOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjguMCwibGVmdCI6LTM4LjAsIm9mZnNldCI6MC4wLCJyaWdodCI6NTEuMCwic3dhcF90eXBlIjoiMTgwIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOi0zNy4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIkZha2UgTGFnIjp7ImJvZHlfeWF3IjpmYWxzZSwiZW5hYmxlZCI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXciOiJEaXNhYmxlZCIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MC4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIkluIFVzZSI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6MjkuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjoyOS4wfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MC4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIk1vdmluZyI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5Ijo0LjAsImxlZnQiOi0zMS4wLCJvZmZzZXQiOjMuMCwicmlnaHQiOjMxLjAsInN3YXBfdHlwZSI6IkRlbGF5ZWQgU3dhcCJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjowLjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiU2hhcmVkIjp7ImJvZHlfeWF3IjpmYWxzZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MC4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIlNsb3cgV2Fsa2luZyI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+eWF3Ijp7ImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6Ny4wLCJsZWZ0IjotMjguMCwib2Zmc2V0IjowLjAsInJpZ2h0Ijo0Mi4wLCJzd2FwX3R5cGUiOiJEZWxheWVkIFN3YXAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6LTI0LjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiU3RhbmRpbmciOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjUuMCwibGVmdCI6LTEwLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MTcuMCwic3dhcF90eXBlIjoiMTgwIEwmUiJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotMjQuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19fX0=");
v623.Hybrid = v623.parse("eyJjb25kaXRpb25hbCI6eyJBaXIiOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi0zLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MTAuMCwic3dhcF90eXBlIjoiMTgwIEwmUiJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotNTUuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjAuMH19LCJBaXIgKyBDcm91Y2giOnsiYm9keV95YXciOnRydWUsImVuYWJsZWQiOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOjAuMCwib2Zmc2V0IjoxMi4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6LTcxLjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjo4LjB9fSwiQ3JvdWNoaW5nIjp7ImJvZHlfeWF3Ijp0cnVlLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjQwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NDAuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MzUuMCwicmlnaHQiOjAuMCwic3dhcF90eXBlIjoiMTgwIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOi01Ni4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6OC4wfX0sIkZha2UgTGFnIjp7ImJvZHlfeWF3IjpmYWxzZSwiZW5hYmxlZCI6ZmFsc2UsInBpdGNoIjoiRGlzYWJsZWQiLCJ5YXciOiJEaXNhYmxlZCIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6MC4wLCJzd2FwX3R5cGUiOiIxODAifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MC4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIkluIFVzZSI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEaXNhYmxlZCIsInlhdyI6IkRpc2FibGVkIiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiUGVlayBGYWtlIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+eWF3Ijp7ImJhc2UiOiJMb2NhbCBWaWV3IiwiZGVsYXkiOjEwLjAsImxlZnQiOjAuMCwib2Zmc2V0IjowLjAsInJpZ2h0IjowLjAsInN3YXBfdHlwZSI6IjE4MCJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjozNS4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX0sIk1vdmluZyI6eyJib2R5X3lhdyI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZSwicGl0Y2giOiJEb3duIiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ+Ym9keV95YXciOnsiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJ+eWF3Ijp7ImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6MTAuMCwibGVmdCI6MC4wLCJvZmZzZXQiOjM0LjAsInJpZ2h0IjowLjAsInN3YXBfdHlwZSI6IjE4MCJ9LCJ+eWF3X21vZGlmaWVyIjp7ImN1c3RvbV93YXkiOmZhbHNlLCJvZmZzZXQxIjotNjUuMCwib2Zmc2V0MiI6MC4wLCJvZmZzZXQzIjowLjAsIm9mZnNldDQiOjAuMCwib2Zmc2V0NSI6MC4wLCJyYW5kb21pemUiOjcuMH19LCJTaGFyZWQiOnsiYm9keV95YXciOnRydWUsInBpdGNoIjoiRG93biIsInlhdyI6IkJhY2t3YXJkIiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOjE1LjAsIm9mZnNldCI6LTE3LjAsInJpZ2h0IjowLjAsInN3YXBfdHlwZSI6IjE4MCBMJlIifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6LTY5LjAsIm9mZnNldDIiOjAuMCwib2Zmc2V0MyI6MC4wLCJvZmZzZXQ0IjowLjAsIm9mZnNldDUiOjAuMCwicmFuZG9taXplIjowLjB9fSwiU2xvdyBXYWxraW5nIjp7ImJvZHlfeWF3Ijp0cnVlLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6Ik9mZnNldCIsIn5ib2R5X3lhdyI6eyJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjQ1LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NDUuMH0sIn55YXciOnsiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6NDUuMCwicmlnaHQiOjAuMCwic3dhcF90eXBlIjoiMTgwIn0sIn55YXdfbW9kaWZpZXIiOnsiY3VzdG9tX3dheSI6ZmFsc2UsIm9mZnNldDEiOi04Mi4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6OC4wfX0sIlN0YW5kaW5nIjp7ImJvZHlfeWF3Ijp0cnVlLCJlbmFibGVkIjp0cnVlLCJwaXRjaCI6IkRvd24iLCJ5YXciOiJCYWNrd2FyZCIsInlhd19tb2RpZmllciI6IkRpc2FibGVkIiwifmJvZHlfeWF3Ijp7ImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwifnlhdyI6eyJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjEwLjAsImxlZnQiOi0yMy4wLCJvZmZzZXQiOjAuMCwicmlnaHQiOjQ3LjAsInN3YXBfdHlwZSI6IjE4MCBMJlIifSwifnlhd19tb2RpZmllciI6eyJjdXN0b21fd2F5IjpmYWxzZSwib2Zmc2V0MSI6MC4wLCJvZmZzZXQyIjowLjAsIm9mZnNldDMiOjAuMCwib2Zmc2V0NCI6MC4wLCJvZmZzZXQ1IjowLjAsInJhbmRvbWl6ZSI6MC4wfX19fQ==");
v644 = v119.new("Presets", 2);
v645 = -1;
v646 = 0;
v647 = 1;
local v680 = nil;
do
    local l_v644_1, l_v645_1, l_v646_1, l_v647_1, l_v680_0 = v644, v645, v646, v647, v680;
    v30.Presets.createmove:set(function(v686, v687, v688)
        -- upvalues: v120 (ref), v623 (ref), v5 (ref), v119 (ref), l_v645_1 (ref), l_v646_1 (ref), v6 (ref), l_v680_0 (ref), l_v647_1 (ref), l_v644_1 (ref)
        if v120.antiaim.type.value == 1 or not v688 then
            return;
        else
            local v689 = v623[v5.presets[v120.antiaim.type.value]];
            local v690 = v119.condition(v687, v689["Fake Lag"].enabled);
            if not v689[v690].enabled then
                v690 = "Shared";
            end;
            local v691 = v689[v690];
            local l_offset_0 = v691["~yaw"].offset;
            local l_swap_type_0 = v691["~yaw"].swap_type;
            local l_yaw_modifier_0 = v691.yaw_modifier;
            local l_offset1_0 = v691["~yaw_modifier"].offset1;
            local l_randomize_0 = v691["~yaw_modifier"].randomize;
            if l_swap_type_0 == "180 L&R" then
                l_offset_0 = rage.antiaim:inverter() and v691["~yaw"].left or v691["~yaw"].right;
            end;
            if l_swap_type_0 == "Delayed Swap" and not v5.functions.safe then
                local v697 = false;
                local v698 = to_ticks(globals.realtime) - l_v645_1;
                v697 = v698 * 2 >= v691["~yaw"].delay;
                if v691["~yaw"].delay <= v698 then
                    l_v645_1 = to_ticks(globals.realtime);
                end;
                if v686.choked_commands == 0 or rage.exploit:get() < 1 then
                    l_v646_1 = v697 and v691["~yaw"].left or v691["~yaw"].right;
                end;
                rage.antiaim:inverter(v697);
                l_offset_0 = l_v646_1;
            end;
            if l_randomize_0 ~= 0 then
                if v6.jitter_count % 2 == 0 or l_v680_0 == nil then
                    l_v680_0 = utils.random_int(0, (l_offset1_0 > 0 and 1 or -1) * l_randomize_0);
                end;
                l_offset1_0 = math.normalize_yaw(l_offset1_0 + l_v680_0);
            end;
            if l_yaw_modifier_0 == "3-Way" or l_yaw_modifier_0 == "5-Way" then
                if v686.choked_commands == 0 then
                    l_v647_1 = l_v647_1 + 1;
                    if l_v647_1 > (l_yaw_modifier_0 == "3-Way" and 3 or 5) then
                        l_v647_1 = 1;
                    end;
                end;
                if v691["~yaw_modifier"].custom_way then
                    l_offset_0 = v691["~yaw_modifier"]["offset" .. l_v647_1];
                    l_yaw_modifier_0 = "Disabled";
                    l_offset1_0 = 0;
                end;
            end;
            l_v644_1:tick();
            l_v644_1.pitch = v5.functions.legit and "Disabled" or v691.pitch;
            l_v644_1.yaw.main = v691.yaw;
            l_v644_1.yaw.base = v691["~yaw"].base;
            l_v644_1.yaw.offset = l_offset_0;
            l_v644_1.yaw_modifier.main = l_yaw_modifier_0;
            l_v644_1.yaw_modifier.offset = l_offset1_0;
            l_v644_1.body_yaw.main = v691.body_yaw;
            l_v644_1.body_yaw.inverter = v691["~body_yaw"].inverter;
            l_v644_1.body_yaw.left_limit = v691["~body_yaw"].left_limit;
            l_v644_1.body_yaw.right_limit = v691["~body_yaw"].right_limit;
            l_v644_1.body_yaw.options = v691["~body_yaw"].options;
            l_v644_1.body_yaw.freestanding = v691["~body_yaw"].freestanding;
            l_v644_1:run();
            return;
        end;
    end);
end;
v644 = nil;
v30["No Fall Damage"].createmove:set(function(v699, v700, v701)
    -- upvalues: v120 (ref), v6 (ref)
    if not v120.antiaim.tweaks:get("No Fall Damage") or not v701 then
        return;
    else
        local v702 = v700:get_origin();
        local v703 = utils.trace_line(v702, vector(v702.x, v702.y, v702.z - 500), nil, nil, 1);
        if v702.z - v703.end_pos.z <= 70 and v702.z - v703.end_pos.z >= 12 and not v6.on_ground and v700.m_vecVelocity.z < -450 then
            v699.in_duck = true;
        end;
        return;
    end;
end);
v30["Fast Ladder"].createmove:set(function(v704, v705, v706)
    -- upvalues: v120 (ref)
    if not v120.antiaim.tweaks:get("Fast Ladder Move") or not v706 then
        return;
    elseif v705.m_MoveType ~= 9 then
        return;
    else
        local v707 = v705:get_player_weapon();
        if v707 == nil then
            return;
        else
            local l_m_fThrowTime_0 = v707.m_fThrowTime;
            if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 ~= 0 then
                return;
            else
                if v704.forwardmove > 0 then
                    if v704.view_angles.x < 45 then
                        v704.view_angles.x = 89;
                        v704.in_moveright = 1;
                        v704.in_moveleft = 0;
                        v704.in_forward = 0;
                        v704.in_back = 1;
                        if v704.sidemove == 0 then
                            v704.view_angles.y = v704.view_angles.y + 90;
                        end;
                        if v704.sidemove < 0 then
                            v704.view_angles.y = v704.view_angles.y + 150;
                        end;
                        if v704.sidemove > 0 then
                            v704.view_angles.y = v704.view_angles.y + 30;
                        end;
                    end;
                elseif v704.forwardmove < 0 then
                    v704.view_angles.x = 89;
                    v704.in_moveleft = 1;
                    v704.in_moveright = 0;
                    v704.in_forward = 1;
                    v704.in_back = 0;
                    if v704.sidemove == 0 then
                        v704.view_angles.y = v704.view_angles.y + 90;
                    end;
                    if v704.sidemove > 0 then
                        v704.view_angles.y = v704.view_angles.y + 150;
                    end;
                    if v704.sidemove < 0 then
                        v704.view_angles.y = v704.view_angles.y + 30;
                    end;
                end;
                return;
            end;
        end;
    end;
end);
v30["Anti Bruteforce"].bullet_impact:set(function(v709, v710, v711)
    -- upvalues: v6 (ref)
    if not v711 then
        return;
    else
        local v712 = entity.get(v709.userid, true);
        if v712 == nil or v712 == v710 then
            return;
        elseif v712:is_bot() or not v712:is_enemy() then
            return;
        else
            local v713 = v710:get_eye_position();
            if v713:closest_ray_point(v712:get_eye_position(), (vector(v709.x, v709.y, v709.z))):dist(v713) >= 60 then
                return;
            else
                v6.miss_timer = globals.realtime + 3;
                return;
            end;
        end;
    end;
end);
v645 = nil;
v645 = {
    is_any_active = false, 
    data = {}
};
v645.get = function(_, v715)
    -- upvalues: v645 (ref)
    local v716 = v645.data[v715];
    return v716 ~= nil and v716.active;
end;
v30.Hotkeys.render:set(function()
    -- upvalues: v645 (ref)
    v645.data = {};
    v645.is_any_active = false;
    for _, v718 in pairs(ui.get_binds()) do
        if v718.active then
            v645.is_any_active = true;
        end;
        v645.data[v718.name] = v718;
    end;
end);
v646 = nil;
v646 = {};
network.get("https://flagsapi.com/" .. panorama.MyPersonaAPI.GetMyCountryCode() .. "/flat/64.png", {}, function(v719)
    -- upvalues: v646 (ref)
    if v719 == nil or #v719 == 0 then
        return;
    else
        v646.img = render.load_image(v719);
        return;
    end;
end);
v30["Flag Watermark"].render:set(function(_, v721)
    -- upvalues: v120 (ref), v5 (ref), v8 (ref), v646 (ref)
    if not v120.visuals.widgets.value or not v120.visuals.widgets.items:get("Flag Watermark") or not v721 then
        return;
    else
        local l_value_16 = v120.visuals.widgets.flag_color.value;
        local v723 = l_value_16:clone():alpha_modulate(0);
        render.gradient(vector(0, v5.screen_center.y), vector(110, v5.screen_center.y + 29), l_value_16, v723, l_value_16, v723);
        local l_white_0 = v8.white;
        if v646.img then
            render.texture(v646.img, vector(5, v5.screen_center.y - 1), vector(32, 32), l_white_0);
        end;
        render.text(2, vector(40, v5.screen_center.y + 3), l_white_0, nil, string.format("IDEAL YAW \a%s[%s]", l_value_16:to_hex(), v5.version:upper()));
        render.text(2, vector(40, v5.screen_center.y + 13), l_white_0, nil, string.format("USER: %s", v5.user:upper()));
        return;
    end;
end);
v647 = nil;
v647 = {
    align = v10:new()
};
v680 = {
    [1] = {
        get_text = function()
            -- upvalues: v120 (ref), v12 (ref), v5 (ref)
            return string.format("\a%s%s", v120.visuals.indicators.build.color.value:alpha_modulate(v12.breathe(2.5, 3), true):to_hex(), v5.version:upper());
        end, 
        condition = function()
            -- upvalues: v120 (ref)
            return v120.visuals.indicators.build.value;
        end, 
        animation = v10:new()
    }, 
    [2] = {
        header = true, 
        get_text = function()
            -- upvalues: v120 (ref), v8 (ref), v12 (ref)
            local v725, v726 = v120.visuals.indicators.color.color:get();
            if not v120.visuals.indicators.color.value then
                local v727 = "Menu";
                v726 = v8.link_active;
                v725 = v727;
            end;
            if v725 == "Gradient" then
                return string.wave("IDEAL YAW", v726[1], v726[2], 0), v726[1];
            elseif v725 == "Animated" then
                return string.wave("IDEAL YAW", v726[1], v726[2], 2.5), v726[1];
            else
                return string.format("IDEAL \a%sYAW", v726.alpha_modulate(v726, v12.breathe(2.5, 3), true):to_hex()), v726;
            end;
        end, 
        condition = function()
            return true;
        end, 
        animation = v10:new()
    }, 
    [3] = {
        get_text = function()
            -- upvalues: v6 (ref)
            return v6.condition:upper();
        end, 
        condition = function()
            return true;
        end, 
        color = function()
            -- upvalues: v120 (ref)
            return v120.visuals.indicators.state_color.value;
        end, 
        animation = v10:new()
    }, 
    [4] = {
        text = "DT", 
        condition = function()
            -- upvalues: v11 (ref)
            local l_main_0 = v11.RAGE.double_tap.main;
            return l_main_0:get_override() or l_main_0:get();
        end, 
        color = function()
            -- upvalues: v8 (ref)
            return v8.red:lerp(v8.white, rage.exploit:get());
        end, 
        animation = v10:new()
    }, 
    [5] = {
        text = "HS", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.hide_shots.main:get() and not v11.RAGE.double_tap.main:get();
        end, 
        animation = v10:new()
    }, 
    [6] = {
        text = "BAIM", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.body_aim:get() == "Force" and v11.RAGE.safe_point:get() ~= "Force";
        end, 
        color = function()
            return color(255, 99, 198, 255);
        end, 
        animation = v10:new()
    }, 
    [7] = {
        text = "SAFE", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.safe_point:get() == "Force" and v11.RAGE.body_aim:get() ~= "Force";
        end, 
        color = function()
            return color(255, 99, 198, 255);
        end, 
        animation = v10:new()
    }, 
    [8] = {
        text = "DMG", 
        condition = function()
            -- upvalues: v645 (ref)
            return v645:get("Min. Damage");
        end, 
        animation = v10:new()
    }, 
    [9] = {
        text = "FS", 
        condition = function()
            -- upvalues: v120 (ref), v5 (ref)
            return v120.antiaim.fs.value and v5.functions.freestand;
        end, 
        animation = v10:new()
    }, 
    [10] = {
        text = "DA", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.dormant:get();
        end, 
        color = function()
            return color(255, 127);
        end, 
        animation = v10:new()
    }
};
local v734 = {
    [1] = {
        get_text = function()
            -- upvalues: v5 (ref), v120 (ref), v6 (ref)
            local v729 = "\aDA7600FFIDEAL YAW";
            if v5.functions.legit then
                v729 = "\aD18BE6FFE-PEEK";
            end;
            local l_value_17 = v120.antiaim.fs.value;
            if l_value_17 then
                v729 = "\aB197FFFFFREESTAND";
            end;
            if v6.miss_timer > globals.realtime then
                v729 = l_value_17 and "\aFF0000FFFREESTAND" or "\a006400FFIDEAL YAW";
            end;
            if v5.functions.edge then
                v729 = "\aDA7600FFIDEAL YAW+";
            end;
            if v5.functions.safe then
                local l_condition_2 = v6.condition;
                if l_condition_2 ~= "Air" and l_condition_2 ~= "Air + Crouch" or entity.get_threat(true) then
                    v729 = l_value_17 and "\aFF0000FFFREESTAND" or "\aFF0000FFIDEAL YAW";
                end;
            end;
            if v120.antiaim.manuals.value ~= "Disabled" then
                v729 = "\aB197FFFFFAKE YAW";
            end;
            return v729;
        end, 
        condition = function()
            return true;
        end
    }, 
    [2] = {
        get_text = function()
            -- upvalues: v120 (ref), v11 (ref), v5 (ref), v6 (ref)
            local v732 = "\aD18BE6FFDYNAMIC";
            if v120.antiaim.manuals.value ~= "Disabled" or v11.AA.angles.yaw.base:get() == "Local View" or v5.functions.legit then
                v732 = "\aFF0000FFDEFAULT";
            end;
            if v6.freestanding and v120.antiaim.fs.value and v5.functions.freestand then
                v732 = "\aD18BE6FFDYNAMIC+";
            end;
            return v732;
        end, 
        condition = function()
            return true;
        end
    }, 
    [3] = {
        text = "DT", 
        condition = function()
            -- upvalues: v11 (ref)
            local l_main_1 = v11.RAGE.double_tap.main;
            return l_main_1:get_override() or l_main_1:get();
        end, 
        color = function()
            -- upvalues: v8 (ref)
            return v8.red:lerp(color(0, 255, 0, 255), rage.exploit:get());
        end
    }, 
    [4] = {
        text = "HIDE", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.hide_shots.main:get() and not v11.RAGE.double_tap.main:get();
        end, 
        color = function()
            return color(0, 255, 0, 255);
        end
    }, 
    [5] = {
        text = "BAIM", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.body_aim:get() == "Force" and v11.RAGE.safe_point:get() ~= "Force";
        end, 
        color = function()
            return color(255, 99, 198, 255);
        end
    }, 
    [6] = {
        text = "SAFE", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.safe_point:get() == "Force" and v11.RAGE.body_aim:get() ~= "Force";
        end, 
        color = function()
            return color(255, 99, 198, 255);
        end
    }, 
    [7] = {
        text = "VERYSAFE", 
        condition = function()
            -- upvalues: v11 (ref)
            return v11.RAGE.safe_point:get() == "Force" and v11.RAGE.body_aim:get() == "Force";
        end, 
        color = function()
            return color(255, 99, 198, 255);
        end
    }
};
do
    local l_v680_1, l_v734_0 = v680, v734;
    v647.Modern = function(v737, _)
        -- upvalues: v647 (ref), v120 (ref), v5 (ref), l_v680_1 (ref), v8 (ref)
        local v739 = v647.align(0.1, v120.visuals.indicators.adjust_pos.value and v737.m_bIsScoped);
        local v740 = 0;
        local v741 = v5.screen_center:clone();
        v741.x = v741.x + 30 * v739;
        v741.y = v741.y + 25;
        for _, v743 in pairs(l_v680_1) do
            local v744 = v743.animation(0.1, v743.condition());
            if v744 > 0 then
                local v745 = v743.text or v743.get_text();
                local v746 = v743.color and v743.color() or v8.white;
                if v743.header and v120.visuals.indicators.shadow.value then
                    local v747 = {
                        v743.get_text()
                    };
                    render.shadow(vector(v741.x - 20, v741.y + v740 + 1), vector(v741.x + 20, v741.y + v740 + 1), v747[2], 20);
                end;
                render.text(2, vector(v741.x, v741.y + v740), v746:alpha_modulate(v744, true), "c", v745);
                v740 = v740 + 8 * v744;
            end;
        end;
    end;
    v647.Default = function(_, _)
        -- upvalues: v5 (ref), l_v734_0 (ref), v8 (ref), v7 (ref)
        local v750 = 0;
        local v751 = v5.screen_center:clone();
        v751.y = v751.y + 20;
        for _, v753 in pairs(l_v734_0) do
            if v753.condition() then
                local v754 = v753.text or v753.get_text();
                local v755 = v753.color and v753.color() or v8.white;
                render.text(v7.verdana_bold, vector(v751.x, v751.y + 12 * v750), v755, nil, v754);
                v750 = v750 + 1;
            end;
        end;
    end;
    local v756 = v118.add("Damage", vector(v5.screen_center.x + 5, v5.screen_center.y - 22), vector(20, 20));
    v30.Indicators.render:set(function(v757, v758)
        -- upvalues: v120 (ref), v647 (ref), v756 (ref), v7 (ref), v11 (ref), v8 (ref), v5 (ref)
        if not v120.visuals.indicators.value or not v758 then
            return;
        else
            v647[v120.visuals.indicators.mode.value](v757, v758);
            if v120.visuals.indicators.damage.value then
                local v759 = v756:process();
                local v760 = v757:get_player_weapon();
                if v760 == nil then
                    return;
                elseif v760:get_weapon_info().max_player_speed > 244 then
                    return;
                else
                    local v761 = v7[v120.visuals.indicators.font.value];
                    local v762 = v11.RAGE.min_damage:get();
                    local v763 = v762 == 0 and "AUTO" or v762;
                    local v764 = v8.white:alpha_modulate(v759.alpha, true);
                    if v5.alpha ~= 0 then
                        render.rect_outline(v759.position, v759.position + v759.size, v764:alpha_modulate(v5.alpha, true), 0, 5);
                        v759.size = render.measure_text(v761, nil, v763) + 10;
                    end;
                    render.text(v761, v759.position + v759.size / 2, v764, "c", v763);
                end;
            end;
            return;
        end;
    end);
end;
v680 = nil;
v680 = {
    left = v10:new(), 
    right = v10:new()
};
v680.Default = function()
    -- upvalues: v120 (ref), v680 (ref), v7 (ref), v5 (ref)
    local l_value_18 = v120.visuals.arrows.color.value;
    local l_value_19 = v120.visuals.arrows.distance.value;
    local v767 = v680.left(0.1, v120.antiaim.manuals.value == "Left");
    if v767 ~= 0 then
        render.text(v7.calibri_bold, vector(v5.screen_center.x - l_value_19, v5.screen_center.y - 10), l_value_18:alpha_modulate(v767, true), nil, "<");
    end;
    local v768 = v680.right(0.1, v120.antiaim.manuals.value == "Right");
    if v768 ~= 0 then
        render.text(v7.calibri_bold, vector(v5.screen_center.x + l_value_19, v5.screen_center.y - 10), l_value_18:alpha_modulate(v768, true), nil, ">");
    end;
end;
v680["Team Skeet"] = function()
    -- upvalues: v120 (ref), v8 (ref), v680 (ref), v5 (ref)
    local l_value_20 = v120.visuals.arrows.color.value;
    local l_value_21 = v120.visuals.arrows.distance.value;
    local v771 = v8.inactive:lerp(l_value_20, v680.left(0.1, v120.antiaim.manuals.value == "Left"));
    local v772 = v8.inactive:lerp(l_value_20, v680.right(0.1, v120.antiaim.manuals.value == "Right"));
    render.poly(v771, vector(v5.screen_center.x - (l_value_21 + 2), v5.screen_center.y + 9), vector(v5.screen_center.x - (l_value_21 + 2), v5.screen_center.y - 9), vector(v5.screen_center.x - (l_value_21 + 17), v5.screen_center.y));
    render.poly(v772, vector(v5.screen_center.x + (l_value_21 + 2), v5.screen_center.y + 9), vector(v5.screen_center.x + (l_value_21 + 2), v5.screen_center.y - 9), vector(v5.screen_center.x + (l_value_21 + 17), v5.screen_center.y));
    if v120.visuals.arrows.lines.value then
        local v773 = rage.antiaim:inverter();
        render.rect(vector(v5.screen_center.x - l_value_21, v5.screen_center.y - 9), vector(v5.screen_center.x - l_value_21 + 2, v5.screen_center.y + 9), v773 and l_value_20 or v8.inactive);
        render.rect(vector(v5.screen_center.x + l_value_21 - 2, v5.screen_center.y - 9), vector(v5.screen_center.x + l_value_21, v5.screen_center.y + 9), v773 and v8.inactive or l_value_20);
    end;
end;
v30["Manual Arrows"].render:set(function(v774, v775)
    -- upvalues: v120 (ref), v680 (ref)
    if not v120.visuals.arrows.value or not v775 then
        return;
    elseif v120.visuals.arrows.scope.value and v774.m_bIsScoped then
        return;
    else
        v680[v120.visuals.arrows.mode.value]();
        return;
    end;
end);
v734 = nil;
local function v783(v776, v777, v778, v779)
    -- upvalues: v120 (ref), v8 (ref)
    if v778 <= 0 then
        return;
    else
        render.rect(v776, v776 + v777, v120.visuals.widgets.background.value:alpha_modulate(v778, true));
        if v120.visuals.widgets.fade.value then
            local v780 = color(204, 18, 204, 255 * v778);
            local v781 = color(0, 213, 255, 255 * v778);
            local v782 = color(255, 250, 0, 255 * v778);
            render.gradient(v776, v776 + vector(v777.x / 2, 2), v781, v780, v781, v780);
            render.gradient(vector(v776.x + v777.x / 2 - 1, v776.y), vector(v776.x + v777.x, v776.y + 2), v780, v782, v780, v782);
        else
            render.rect(v776, v776 + vector(v777.x, 2), v120.visuals.widgets.outline.value:alpha_modulate(v778, true));
        end;
        if v779 then
            render.text(1, vector(v776.x + v777.x * 0.5, v776.y + v777.y * 0.5 + 1), v8.white:alpha_modulate(v778, true), "c", v779);
        end;
        return;
    end;
end;
local v784 = nil;
v784 = {
    alpha = v10:new(), 
    hovered = v10:new(), 
    modifier = v10:new()
};
local v785 = v118.add("Velocity Warning", vector(v5.screen_center.x - 90, v5.screen_center.y * 0.5), vector(140, 50));
local v786 = render.load_image_from_file("materials/panorama/images/icons/ui/warning.svg");
local v787 = color(213, 48, 50);
local function v790(v788, v789, ...)
    return render.rect(v788, v788 + v789, ...);
end;
do
    local l_v783_0, l_v784_0, l_v785_0, l_v786_0 = v783, v784, v785, v786;
    do
        local l_l_v785_0_0, l_l_v786_0_0, l_v790_0 = l_v785_0, l_v786_0, v790;
        v30["Velocity Warning"].render:set(function(v798, v799)
            -- upvalues: v120 (ref), v5 (ref), l_v784_0 (ref), l_l_v785_0_0 (ref), v8 (ref), v12 (ref), l_l_v786_0_0 (ref), l_v790_0 (ref)
            local v800 = v798 and v798.m_flVelocityModifier or 1;
            local v801 = v120.visuals.widgets.value and v120.visuals.widgets.items:get("Velocity Warning") and (v799 and not (v800 == 1) or v5.alpha == 1);
            local v802 = l_v784_0.alpha(0.2, v801);
            if v802 <= 0 then
                return;
            else
                local v803 = 1;
                if v5.alpha ~= 0 then
                    l_l_v785_0_0:process();
                    if l_l_v785_0_0.is_in_b and l_l_v785_0_0.is_rmb_pressed and v5.alpha > 0 and l_l_v785_0_0.alpha == 1 then
                        l_l_v785_0_0.position.x = v5.screen_center.x - 70;
                    end;
                    local v804 = l_v784_0.hovered(0.1, l_l_v785_0_0.is_in_b and v5.alpha == 1 and l_l_v785_0_0.alpha == 1);
                    if v804 ~= 0 then
                        render.text(1, vector(l_l_v785_0_0.position.x + 3, l_l_v785_0_0.position.y + 43), v8.white:alpha_modulate(v804 * v802, true), nil, "Press M2 to Center.");
                    end;
                    render.rect_outline(l_l_v785_0_0.position, l_l_v785_0_0.position + vector(l_l_v785_0_0.size.x, l_l_v785_0_0.size.y + 8 * v804), v8.white:alpha_modulate(v5.alpha * l_l_v785_0_0.alpha * v802, true), 1, 5);
                    v803 = v12.breathe(1.5, 3.3);
                end;
                local v805 = l_v784_0.modifier(0.1, v5.alpha == 1 and globals.tickcount % 150 / 150 or v800);
                local v806 = v8.red:lerp(v8.green, v805):alpha_modulate(255 * v802 * l_l_v785_0_0.alpha);
                local v807 = v8.white:alpha_modulate(v802 * l_l_v785_0_0.alpha, true);
                local v808 = vector(l_l_v785_0_0.position.x + 45, l_l_v785_0_0.position.y + 25);
                local v809 = v808 + vector(90, 13);
                render.texture(l_l_v786_0_0, v808 - vector(43, 23), vector(41, 41), color(16, 255 * v802));
                l_v790_0(v808 - vector(27, 8), vector(8, 20), color(16, 255 * v802), 2);
                render.texture(l_l_v786_0_0, v808 - vector(40, 19), vector(35, 35), v806:alpha_modulate(v803, true));
                render.rect(v808, v809, color(0, 125 * v802), 3);
                render.rect(v808 + vector(1, 1), v808 + vector(89 * v805, 12), v806, 3);
                render.text(1, v808 + vector(0, -15), v807, nil, string.format("Slowed Down %d%%", v805 * 100));
                return;
            end;
        end);
    end;
    l_v785_0 = nil;
    l_v785_0 = {
        alpha = v10:new(), 
        size = v10:new(125)
    };
    l_v786_0 = {};
    v787 = v118.add("Keybinds", vector(300, 100), vector(125, 23));
    do
        local l_l_v786_0_1, l_v787_0 = l_v786_0, v787;
        l_v785_0.render = function(v812)
            -- upvalues: l_v787_0 (ref), l_l_v786_0_1 (ref), v10 (ref), v8 (ref), l_v785_0 (ref), l_v783_0 (ref)
            l_v787_0:process();
            local v813 = 0;
            local v814 = 125;
            local v815 = vector(l_v787_0.position.x, l_v787_0.position.y + 26);
            for _, v817 in pairs(ui.get_binds()) do
                local l_name_0 = v817.name;
                local l_value_22 = v817.value;
                if not l_l_v786_0_1[l_name_0] then
                    l_l_v786_0_1[l_name_0] = {
                        name = l_name_0, 
                        type = type(l_value_22), 
                        anim = v10:new()
                    };
                end;
                local v820 = l_l_v786_0_1[l_name_0];
                local v821 = v820.anim(0.1, v817.active);
                if v821 > 0 then
                    render.text(1, v815 + vector(3, v813), v8.white:alpha_modulate(v821 * v812 * l_v787_0.alpha, true), nil, l_name_0);
                    local v822 = "";
                    if v820.type == "table" then
                        v822 = table.concat(l_value_22, ", ");
                    elseif v820.type == "boolean" then
                        v822 = l_value_22 == false and "disabled" or v817.mode == 1 and "holding" or "toggled";
                    else
                        v822 = tostring(l_value_22);
                    end;
                    local v823 = string.format("[%s]", v822);
                    local l_x_1 = render.measure_text(1, nil, v823).x;
                    render.text(1, v815 + vector(l_v787_0.size.x - l_x_1 - 3, v813), v8.white:alpha_modulate(v821 * v812 * l_v787_0.alpha, true), nil, v823);
                    local v825 = render.measure_text(1, nil, l_name_0).x + l_x_1 + 20;
                    if v814 < v825 then
                        v814 = v825;
                    end;
                    v813 = v813 + 15 * v821;
                end;
            end;
            l_v787_0.size.x = l_v785_0.size(0.1, v814);
            l_v783_0(l_v787_0.position, l_v787_0.size, v812 * l_v787_0.alpha, "keybinds");
        end;
        v30.Keybinds.render:set(function()
            -- upvalues: l_v785_0 (ref), v120 (ref), v5 (ref), v645 (ref)
            local v826 = l_v785_0.alpha(0.1, v120.visuals.widgets.value and v120.visuals.widgets.items:get("Hotkeys") and (v5.alpha ~= 0 or v645.is_any_active));
            if v826 <= 0 then
                return;
            else
                l_v785_0.render(v826);
                return;
            end;
        end);
    end;
    l_v786_0 = nil;
    l_v786_0 = {
        alpha = v10:new(), 
        size = v10:new()
    };
    v787 = vector(10, 10);
    v30.Watermark.render:set(function(_, _)
        -- upvalues: l_v786_0 (ref), v120 (ref), v5 (ref), l_v783_0 (ref), v8 (ref)
        local v829 = l_v786_0.alpha(0.2, v120.visuals.widgets.value and v120.visuals.widgets.items:get("Watermark"));
        if v829 <= 0 then
            return;
        else
            local l_value_23 = v120.visuals.widgets.outline.value;
            l_value_23.a = 255;
            local v831 = {
                [1] = v5.version == "Release" and string.format("ideal\a%syaw\aDEFAULT", l_value_23:to_hex()) or string.format("idealyaw [%s\aDEFAULT]", v120.visuals.widgets.fade.value and string.wave(v5.version:upper(), color(204, 18, 204, 255), color(255, 250, 0, 255), 0) or string.format("\a%s%s", l_value_23:to_hex(), v5.version:upper()))
            };
            local v832 = table.convert(v120.visuals.widgets.wm_items.value);
            if v832.Username then
                table.insert(v831, v5.user);
            end;
            if v832.Delay then
                local v833 = utils.net_channel();
                if v833 ~= nil then
                    if v833.is_loopback then
                        table.insert(v831, "local server");
                    else
                        local v834 = v833.latency[1] * 1000;
                        if v834 > 0 then
                            table.insert(v831, string.format("delay: %dms", math.floor(v834)));
                        end;
                    end;
                end;
            end;
            if v832.Time then
                table.insert(v831, common.get_date("%H:%M:%S"));
            end;
            local v835 = table.concat(v831, " | ");
            local v836 = render.measure_text(1, nil, v835);
            local v837 = vector(v5.screen.x, -3);
            local v838 = vector(v836.x + 8, 23);
            v838.x = l_v786_0.size(0.1, v838.x);
            v837 = v837 - vector(v838.x + 10, v838.y * -0.6);
            l_v783_0(v837, v838, v829);
            render.push_clip_rect(v837, v837 + v838);
            render.text(1, vector(v837.x + 4, v837.y + 6), v8.white:alpha_modulate(v829, true), nil, v835);
            render.pop_clip_rect();
            return;
        end;
    end);
end;
v783 = nil;
v783 = {
    should_run = false
};
v784 = v119.new("Disablers", 455);
v785 = 0;
do
    local l_v784_1, l_v785_1 = v784, v785;
    v30.Disablers.createmove:set(function(_, _, v843)
        -- upvalues: v783 (ref), l_v785_1 (ref), l_v784_1 (ref)
        if not v783.should_run or not v843 then
            return;
        else
            local v844 = false;
            for _, v846 in next, entity.get_players(true, true) do
                if v846:is_alive() then
                    v844 = true;
                    break;
                end;
            end;
            if v844 then
                return;
            else
                l_v785_1 = l_v785_1 + 40;
                l_v784_1:tick();
                l_v784_1.yaw.offset = math.normalize_yaw(l_v785_1);
                l_v784_1.yaw_modifier.main = "Disabled";
                l_v784_1.body_yaw.main = false;
                l_v784_1:run();
                return;
            end;
        end;
    end);
    events.round_prestart(function()
        -- upvalues: v783 (ref)
        v783.should_run = false;
    end);
    events.round_end(function()
        -- upvalues: v783 (ref)
        v783.should_run = true;
    end);
end;
v784 = nil;
v784 = {
    weapons_verb = {
        hegrenade = "Naded", 
        taser = "Zeused", 
        knife = "Knifed", 
        inferno = "Burned"
    }, 
    miss_replacement = {
        ["backtrack failure"] = "lagcomp"
    }, 
    push = function(v847, v848)
        -- upvalues: v120 (ref)
        local l_value_24 = v120.rage.logs.show.value;
        if #l_value_24 == 0 then
            return;
        else
            local v850 = table.convert(l_value_24);
            if v850.Console then
                print_raw(string.format("\a%sidealyaw \aDEFAULT~ %s", v848:to_hex(), v847));
            end;
            if v850.Events then
                print_dev(v847);
            end;
            return;
        end;
    end
};
v30["Log Events"].item_purchase:set(function(v851, _, _)
    -- upvalues: v120 (ref), v12 (ref), v784 (ref)
    if not v120.rage.logs.value or not table.search(v120.rage.logs.events.value, "Purchases") then
        return;
    else
        local v854 = entity.get(v851.userid, true);
        if v854 == nil then
            return;
        elseif not v854:is_enemy() then
            return;
        else
            local v855 = {
                nil, 
                "\rbought ", 
                [1] = string.format("\v%s\r ", v854:get_name()), 
                string.format("\v%s", v851.weapon)
            };
            local l_value_25 = v120.rage.logs.purchase_color.value;
            local v857 = v12.format(table.concat(v855, ""), l_value_25);
            v784.push(v857, l_value_25);
            return;
        end;
    end;
end);
v30["Log Events"].player_hurt:set(function(v858, v859, _)
    -- upvalues: v120 (ref), v5 (ref), v6 (ref), v12 (ref), v784 (ref), v165 (ref)
    if not v120.rage.logs.value then
        return;
    else
        local v861 = entity.get(v858.userid, true);
        local v862 = entity.get(v858.attacker, true);
        if v861 == nil or v862 == nil then
            return;
        elseif v861 == v859 and table.search(v120.rage.logs.events.value, "Hurt") then
            local v863 = {
                "You got hit in the ", 
                nil, 
                nil, 
                "for ", 
                nil, 
                "by ", 
                [2] = string.format("\v%s\r ", v5.hitgroups[v858.hitgroup] or "?"), 
                [3] = string.format("(while \v%s\r) ", v6.condition), 
                [5] = string.format("\v%d\r damage ", v858.dmg_health), 
                string.format("\v%s\r ", v862:get_name()), 
                string.format("(\v%d\r health remaining)", v858.health)
            };
            local l_value_26 = v120.rage.logs.color.value;
            local v865 = v12.format(table.concat(v863, ""), l_value_26);
            v784.push(v865, l_value_26);
            v165:push(5, v865, l_value_26);
            return;
        else
            if v862 == v859 and table.search(v120.rage.logs.events.value, "Damage Dealt") then
                local l_weapon_1 = v858.weapon;
                if not v784.weapons_verb[l_weapon_1] then
                    return;
                else
                    local v867 = {
                        nil, 
                        nil, 
                        "for ", 
                        [1] = string.format("%s ", v784.weapons_verb[l_weapon_1]), 
                        [2] = string.format("\v%s\r ", v861:get_name()), 
                        string.format("\v%s \rdamage ", v858.dmg_health or 0), 
                        string.format("(\v%d \rhealth remaining)", v858.health or 0)
                    };
                    local l_value_27 = v120.rage.logs.color.value;
                    local v869 = v12.format(table.concat(v867, ""), l_value_27);
                    v784.push(v869, l_value_27);
                    v165:push(5, v869, l_value_27);
                end;
            end;
            return;
        end;
    end;
end);
v30["Log Events"].aim_ack:set(function(v870, _, _)
    -- upvalues: v120 (ref), v5 (ref), v784 (ref), v12 (ref), v165 (ref)
    if not v120.rage.logs.value or not table.search(v120.rage.logs.events.value, "Aimbot Shots") then
        return;
    else
        local l_target_0 = v870.target;
        if l_target_0 == nil then
            return;
        elseif v870.hitgroup == 0 then
            return;
        elseif v870.state then
            local l_value_28 = v120.rage.logs.miss_color.value;
            local v875 = {
                "Missed ", 
                nil, 
                nil, 
                nil, 
                "due to ", 
                [2] = string.format("\v%s\r's ", l_target_0:get_name() or "unknown"), 
                [3] = string.format("\v%s\r", v5.hitgroups[v870.wanted_hitgroup]), 
                [4] = string.format("(\v%d\r) ", v870.wanted_damage or 0), 
                string.format("\v%s\r, ", v784.miss_replacement[v870.state] or v870.state), 
                string.format("bt (\v%d\r) hc (\v%d\r)", v870.backtrack, v870.hitchance)
            };
            v784.push(v12.format(table.concat(v875, ""), l_value_28), l_value_28);
            v165:push(5, v12.format(string.format("Missed at \v%s\r due to \v%s", l_target_0:get_name() or "unknown", v870.state), l_value_28), l_value_28);
            return;
        else
            local l_value_29 = v120.rage.logs.color.value;
            if v870.damage ~= v870.wanted_damage then
                l_value_29 = v120.rage.logs.missmatch_color.value;
            end;
            local v877 = {
                "Hit ", 
                nil, 
                nil, 
                "for ", 
                [2] = string.format("\v%s\r's ", l_target_0:get_name() or "unknown"), 
                [3] = string.format("\v%s\r ", v5.hitgroups[v870.hitgroup] or "generic"), 
                string.format("\v%d\r(\v%d\r) ", v870.damage or 0, v870.wanted_damage or 0), 
                string.format("(\v%d \rremaining) ", l_target_0.m_iHealth or 0), 
                string.format("(client: \v%s\r) (server: \v%s\r) ", v5.hitgroups[v870.wanted_hitgroup], v5.hitgroups[v870.hitgroup]), 
                string.format("bt (\v%d\r) hc (\v%d\r)", v870.backtrack, v870.hitchance)
            };
            v784.push(v12.format(table.concat(v877, ""), l_value_29), l_value_29);
            v165:push(5, v12.format(string.format("Hit \v%s \rin the \v%s \rfor \v%d \rdamage", l_target_0:get_name() or "unknown", v5.hitgroups[v870.hitgroup], v870.damage or 0), l_value_29), l_value_29);
            return;
        end;
    end;
end);
v785 = nil;
v30["GS Spectators"].render:set(function(v878, _)
    -- upvalues: v120 (ref), v5 (ref)
    if not v120.visuals.gs.value or not v120.visuals.gs.items:get("Spectators") or not globals.is_in_game then
        return;
    else
        local v880 = v878.m_hObserverTarget or v878;
        if v880 == nil then
            return;
        else
            local v881 = 0;
            local v882 = v880:get_spectators() or {};
            for _, v884 in next, v882 do
                if v884 then
                    local v885 = v884:get_name();
                    local v886 = render.measure_text(1, nil, v885);
                    render.text(1, vector(v5.screen.x - v886.x - 10, v881 + 6), color(220, 255), nil, v885);
                    v881 = v881 + 8 + v886.y;
                end;
            end;
            return;
        end;
    end;
end);
v786 = nil;
v787 = render.load_font("Calibri Bold", vector(25, 22, -1), "ad");
do
    local l_v787_1, l_v790_1 = v787, v790;
    l_v790_1 = function(v889, v890, v891)
        -- upvalues: l_v787_1 (ref), v8 (ref)
        local v892 = render.measure_text(l_v787_1, "a", v890);
        render.gradient(v889 - vector(0, 5), v889 + vector(28 + v892.x / 2, 28), v8.gradient_out, v8.gradient_in, v8.gradient_out, v8.gradient_in);
        render.gradient(v889 + vector(28 + v892.x / 2, -5), v889 + vector((28 + v892.x / 2) * 2 - 1, 28), v8.gradient_in, v8.gradient_out, v8.gradient_in, v8.gradient_out);
        render.text(l_v787_1, v889 + vector(27, 3), v891, nil, v890);
    end;
    local v893 = nil;
    v893 = {
        total = 0, 
        hits = 0, 
        reasons = {
            ["prediction error"] = true, 
            ["player death"] = true, 
            death = true, 
            ["unregistered shot"] = true
        }
    };
    v30["Skeet Indicators"].aim_ack:set(function(v894)
        -- upvalues: v893 (ref)
        if v893.reasons[v894.state] ~= nil then
            return;
        else
            v893.total = v893.total + 1;
            if not v894.state then
                v893.hits = v893.hits + 1;
            end;
            return;
        end;
    end);
    v30["Skeet Indicators"].player_connect_full:set(function(v895, v896)
        -- upvalues: v893 (ref)
        if entity.get(v895.userid, true) ~= v896 then
            return;
        else
            v893.hits = 0;
            v893.total = 0;
            return;
        end;
    end);
    local v897 = nil;
    v897 = {
        damage = "-0 HP", 
        icon = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
    };
    local function v898()
        -- upvalues: v897 (ref)
        v897.site = nil;
    end;
    events.round_start:set(v898);
    events.bomb_planted:set(v898);
    events.bomb_abortplant:set(v898);
    v897.planting_time = 3.125;
    local function v904(v899, v900)
        local v901 = 0.5;
        local v902 = 0.5;
        if v900 and v900 > 0 then
            local v903 = v899 * v901;
            if v900 < (v899 - v903) * v902 then
                v903 = v899 - v900 * (1 / v902);
            end;
            v899 = v903;
        end;
        return v899;
    end;
    do
        local l_v904_0 = v904;
        local function v911(v906, v907)
            -- upvalues: l_v904_0 (ref)
            if not v906 then
                return 0;
            else
                local v908 = v906:get_origin():dist(v907:get_origin());
                local v909 = 500;
                local v910 = v909 * 3.5;
                v909 = v909 * math.exp(-(v908 * v908 / (v910 * 2 / 3 * (v910 / 3))));
                return (math.floor(l_v904_0(math.max(v909, 0), v906.m_ArmorValue)));
            end;
        end;
        v30.Bomb.render:set(function()
            -- upvalues: v120 (ref), v897 (ref), v911 (ref)
            if not v120.visuals.gs.value or not v120.visuals.gs.items:get("Indicators") then
                return;
            else
                v897.entity = nil;
                v897.damage = "";
                v897.player = nil;
                entity.get_entities("CPlantedC4", true, function(v912)
                    -- upvalues: v897 (ref)
                    if not v912.m_bBombTicking or globals.curtime > v912.m_flC4Blow then
                        return;
                    else
                        v897.entity = v912;
                        return;
                    end;
                end);
                local v913 = entity.get_local_player();
                if not v897.entity or not v913 then
                    return;
                else
                    local l_m_iObserverMode_0 = v913.m_iObserverMode;
                    if l_m_iObserverMode_0 == 6 or l_m_iObserverMode_0 == 1 or l_m_iObserverMode_0 == 2 then
                        return;
                    else
                        v897.player = v913.m_hObserverTarget or v913;
                        local v915 = v911(v897.player, v897.entity);
                        v897.damage = v897.player.m_iHealth <= v915 and "FATAL" or string.format("-%d HP", v915);
                        return;
                    end;
                end;
            end;
        end);
        v30.Bomb.bomb_beginplant:set(function(v916)
            -- upvalues: v897 (ref)
            local v917 = entity.get(v916.site);
            if not v917 then
                return;
            else
                local v918 = ffi.cast("uintptr_t", v917[0]) + 340;
                v897.site = ffi.cast("char*", v918)[0] == 65 and "A" or "B";
                v897.planting_started = globals.curtime;
                return;
            end;
        end);
    end;
    v898 = v120.visuals.gs.indicators.ref;
    v904 = v10:new();
    local v944 = {
        [1] = {
            condition = function()
                -- upvalues: v897 (ref), v898 (ref)
                return v897.site ~= nil and entity.get_game_rules() ~= nil and v898:get("Bomb Info");
            end, 
            get_text = function()
                -- upvalues: v897 (ref)
                return "        " .. v897.site .. "        ";
            end, 
            additional_render = function(v919)
                -- upvalues: v897 (ref), v8 (ref)
                local v920 = (globals.curtime - v897.planting_started) / v897.planting_time;
                render.circle_outline(v919 + vector(97, 11), color(0, 0, 0, 100), 10, 0, 1, 4);
                render.circle_outline(v919 + vector(97, 11), color(), 9, 0, v920, 2.5);
                render.texture(v897.icon, v919 + vector(27, -3), nil, v8.plant_ok);
            end, 
            col = function()
                -- upvalues: v897 (ref), v8 (ref)
                local v921 = entity.get_game_rules();
                return v897.planting_started + v897.planting_time < v921.m_fRoundStartTime + v921.m_iRoundTime and v8.plant_warning or v8.plant_ok;
            end
        }, 
        [2] = {
            get_text = function()
                -- upvalues: v897 (ref)
                return v897.damage;
            end, 
            col = function()
                -- upvalues: v897 (ref), v8 (ref)
                return v897.damage == "FATAL" and v8.red or v8.plant_ok;
            end, 
            condition = function(_)
                -- upvalues: v897 (ref), v898 (ref)
                return v897.entity ~= nil and v897.damage ~= "-0 HP" and v898:get("Bomb Info") and v897.player ~= nil;
            end
        }, 
        [3] = {
            get_text = function()
                -- upvalues: v897 (ref)
                local _ = "";
                local l_entity_1 = v897.entity;
                return "        " .. (l_entity_1.m_nBombSite == 0 and "A" or "B") .. string.format(" - %.1fs", l_entity_1.m_flC4Blow - globals.curtime);
            end, 
            additional_render = function(v925)
                -- upvalues: v897 (ref), v8 (ref)
                render.texture(v897.icon, v925 + vector(27, -3), nil, v8.white);
            end, 
            condition = function()
                -- upvalues: v897 (ref), v898 (ref)
                return v897.entity ~= nil and v898:get("Bomb Info");
            end
        }, 
        [4] = {
            text = "FS", 
            condition = function(v926)
                -- upvalues: v120 (ref), v898 (ref)
                return v120.antiaim.fs.value and v898:get("Freestanding") and v926;
            end, 
            col = function()
                -- upvalues: v6 (ref), v5 (ref), v8 (ref)
                return v6.freestanding and v5.functions.freestand and v8.white_idle or v8.skeet_red;
            end
        }, 
        [5] = {
            text = "MD", 
            condition = function(v927)
                -- upvalues: v645 (ref), v898 (ref)
                return v645:get("Min. Damage") and v898:get("Min. Damage") and v927;
            end
        }, 
        [6] = {
            text = "HC", 
            condition = function(v928)
                -- upvalues: v645 (ref), v898 (ref)
                return v645:get("Hit Chance") and v898:get("Hit Chance") and v928;
            end
        }, 
        [7] = {
            text = "BODY", 
            condition = function(v929)
                -- upvalues: v11 (ref), v898 (ref)
                return v11.RAGE.body_aim:get() == "Force" and v898:get("Body Aim") and v929;
            end
        }, 
        [8] = {
            text = "SAFE", 
            condition = function(v930)
                -- upvalues: v11 (ref), v898 (ref)
                return v11.RAGE.safe_point:get() == "Force" and v898:get("Safe Point") and v930;
            end
        }, 
        [9] = {
            text = "DA", 
            condition = function(v931)
                -- upvalues: v11 (ref), v898 (ref)
                return v11.RAGE.dormant:get() and v898:get("Dormant Aimbot") and v931;
            end, 
            col = function()
                -- upvalues: v8 (ref)
                local v932 = entity.get_threat();
                if v932 == nil then
                    return v8.skeet_red;
                elseif v932:is_dormant() then
                    return v8.white_idle;
                else
                    return v8.skeet_red;
                end;
            end
        }, 
        [10] = {
            text = "DUCK", 
            condition = function(v933)
                -- upvalues: v11 (ref), v898 (ref)
                return v11.AA.other.fake_duck:get() and v898:get("Fake Duck") and v933;
            end
        }, 
        [11] = {
            text = "DT", 
            col = function()
                -- upvalues: v6 (ref), v8 (ref)
                if v6.defensive then
                    return color(143, 194, 21, 255);
                else
                    return v8.skeet_red:lerp(v8.white_idle, rage.exploit:get());
                end;
            end, 
            condition = function(v934)
                -- upvalues: v11 (ref), v898 (ref)
                local l_main_2 = v11.RAGE.double_tap.main;
                return (not not l_main_2:get_override() or l_main_2:get()) and v898:get("Double Tap") and v934 and not v11.AA.other.fake_duck:get();
            end
        }, 
        [12] = {
            text = "HIDE", 
            condition = function(v936)
                -- upvalues: v11 (ref), v898 (ref)
                return not v11.AA.other.fake_duck:get() and not v11.RAGE.double_tap.main:get() and v11.RAGE.hide_shots.main:get() and v898:get("Hide Shots") and v936;
            end
        }, 
        [13] = {
            text = "PING", 
            col = function(_)
                -- upvalues: v8 (ref), v11 (ref)
                local v938 = utils.net_channel();
                if not v938 then
                    return v8.green;
                else
                    local v939 = v938.latency[0] * 1000;
                    local v940 = v11.MISC.fake_latency:get() / v939;
                    if v940 > 1 then
                        v940 = 1 - v940 % 1;
                    end;
                    return v8.piss:lerp(v8.green, v940);
                end;
            end, 
            condition = function(v941)
                -- upvalues: v11 (ref), v898 (ref)
                return v11.MISC.fake_latency:get() ~= 0 and v898:get("Fake Latency") and v941;
            end
        }, 
        [14] = {
            get_text = function()
                -- upvalues: v893 (ref)
                local v942 = v893.total ~= 0 and v893.hits / v893.total * 100 or 100;
                return string.format("%d / %d (%.1f%%)", v893.hits, v893.total, v942);
            end, 
            condition = function(v943)
                -- upvalues: v898 (ref), v893 (ref)
                return v898:get("Aimbot Shots") and v943 and v893.total ~= 0;
            end
        }
    };
    v30["Screen Indicators"].render:set(function(v945, v946)
        -- upvalues: v120 (ref), v5 (ref), v944 (ref), v8 (ref), l_v790_1 (ref), v897 (ref)
        if not v120.visuals.gs.value or not v120.visuals.gs.items:get("Indicators") then
            return;
        elseif not globals.is_in_game then
            return;
        else
            local v947 = vector(0, v5.screen.y - 340);
            local v948 = 0;
            local v949 = #v944;
            for v950 = 0, v949 - 1 do
                local v951 = v944[v949 - v950];
                if not v951.condition or v951.condition(v946) then
                    local v952 = v951.col and v951.col(v945) or v8.white_idle;
                    local v953 = v951.text or v951.get_text();
                    local v954 = v947 - vector(0, v948 * 41);
                    l_v790_1(v954, v953, v952);
                    if v951.additional_render then
                        v951.additional_render(v954);
                    end;
                    v948 = v948 + 1;
                end;
            end;
            if not v897.entity then
                return;
            else
                local l_m_hBombDefuser_0 = v897.entity.m_hBombDefuser;
                local _ = v897.entity.m_flDefuseLength;
                local v957 = l_m_hBombDefuser_0 and (v897.entity.m_flDefuseCountDown - globals.curtime) * 10 / 10 or -1;
                local v958 = v897.entity.m_flC4Blow - globals.curtime;
                if v957 > 0 then
                    render.rect(vector(), vector(16, v5.screen.y), color(25, 25, 25, 160));
                    render.rect_outline(vector(), vector(16, v5.screen.y), color(25, 25, 25, 160));
                    render.rect(vector(0, v5.screen.y - (v5.screen.y - 50) / 10 * v957), vector(16, v5.screen.y), v957 < v958 and color(58, 191, 54, 160) or color(255, 0, 0, 125));
                end;
                return;
            end;
        end;
    end);
end;
v787 = nil;
v790 = false;
do
    local l_v790_2 = v790;
    local function v960()
        -- upvalues: l_v790_2 (ref), v11 (ref)
        if l_v790_2 then
            v11.MISC.weapon_actions:override();
            l_v790_2 = false;
        end;
    end;
    v30["Grenade Fix"].createmove:set(function(_, v962, _)
        -- upvalues: v120 (ref), v960 (ref), v11 (ref), l_v790_2 (ref)
        if not v962 or not v120.misc.nade_fix.value then
            return v960();
        else
            local v964 = v962:get_player_weapon();
            if v964 == nil then
                return v960();
            elseif v964:get_weapon_info().weapon_type ~= 9 then
                return v960();
            else
                v11.MISC.weapon_actions:override("");
                rage.exploit:allow_defensive(false);
                l_v790_2 = true;
                return;
            end;
        end;
    end);
end;
v790 = nil;
local v965 = v10:new();
do
    local l_v965_0 = v965;
    v30.Transparency.localplayer_transparency:set(function(_, v968, v969)
        -- upvalues: v120 (ref), v11 (ref), l_v965_0 (ref)
        if not v120.additional.transparency.value or not v969 then
            return;
        elseif not v11.VISUALS.thirdperson:get() then
            return 255;
        else
            return l_v965_0(0.1, (not not v968.m_bResumeZoom or v968.m_bIsScoped) and 59 or 255);
        end;
    end);
end;
v965 = nil;
local function v981(v970, v971, v972, v973)
    local v974 = 255 * (v973 or 1);
    if v974 <= 0 then
        return;
    else
        render.rect_outline(v970, v971, color(10, v974));
        render.rect_outline(v970 + 1, v971 - 1, color(60, v974));
        render.rect_outline(v970 + 3, v971 - 3, color(40, v974), 3);
        render.rect_outline(v970 + 5, v971 - 5, color(60, v974));
        render.rect(v970 + 6, v971 - 6, color(20, v974));
        if v972 then
            local v975 = v970 + 7;
            local v976 = v971 - 7;
            local v977 = v976 - v975;
            local v978 = color(59, 175, 222, v974);
            local v979 = color(202, 70, 205, v974);
            local v980 = color(201, 227, 58, v974);
            render.gradient(v975, v975 + vector(v977.x * 0.5, 1), v978, v979, v978, v979);
            render.gradient(v975 + vector(v977.x * 0.5), v975 + vector(v977.x, 1), v979, v980, v979, v980);
            v975.y = v975.y + 1;
            v976.y = v976.y + 1;
            v978.a = v978.a * 0.2;
            v979.a = v979.a * 0.2;
            v980.a = v980.a * 0.2;
            render.gradient(v975, v975 + vector(v977.x * 0.5, 1), v978, v979, v978, v979);
            render.gradient(v975 + vector(v977.x * 0.5), v975 + vector(v977.x, 1), v979, v980, v979, v980);
        end;
        return;
    end;
end;
do
    local l_v981_0 = v981;
    v30["GS Overlay"].render:set(function()
        -- upvalues: v120 (ref), l_v981_0 (ref), v5 (ref)
        if not v120.visuals.gs.value or not v120.visuals.gs.items:get("Menu Overlay") then
            return;
        else
            local v983 = ui.get_position();
            local v984 = v983 + ui.get_size();
            l_v981_0(v983 - vector(7, 9), v984 + 7, true, v5.alpha);
            return;
        end;
    end);
end;
v981 = nil;
v981 = {
    link = "wss://mishkat.cloud/idealyaw/ws", 
    failed_connections = 0, 
    data = {}, 
    icon_data = {}, 
    retrieve = function()
        -- upvalues: v5 (ref), v1 (ref)
        local v985 = json.stringify({
            steam = tostring(panorama.MyPersonaAPI.GetXuid():sub(7) - 97960265728), 
            logo = v5.user
        });
        return v1.encode(v985);
    end
};
v981.callbacks = {
    open = function(v986)
        -- upvalues: v981 (ref), v12 (ref)
        v986:send(v981.retrieve());
        if v981.failed_connections > 1 then
            print_raw(v12.format("\videalyaw \r~ Connection established!"));
        else
            print_raw(v12.format("\videalyaw \r~ Successfully connected to the server!"));
        end;
        v981.socket = v986;
    end, 
    message = function(_, v988)
        -- upvalues: v1 (ref), v120 (ref), v981 (ref), v5 (ref)
        local l_status_14, l_result_14 = pcall(v1.decode, v988);
        if not l_status_14 or type(l_result_14) ~= "string" then
            return;
        else
            local l_status_15, l_result_15 = pcall(json.parse, l_result_14);
            if not l_status_15 then
                return;
            else
                local v993 = 1;
                for _, v995 in pairs(l_result_15) do
                    if type(v995) == "string" then
                        v993 = v993 + 1;
                    end;
                end;
                v120.information.online:name(string.format("\v\f<tiktok>\t\a{Active Text}Online Users: \v%s", v993));
                v981.data = l_result_15;
                v5.online = v993;
                return;
            end;
        end;
    end, 
    close = function(_)
        -- upvalues: v981 (ref), v12 (ref), v5 (ref), v4 (ref)
        if v981.failed_connections >= 3 then
            print_raw(v12.format("\videalyaw \r~ Cannot connnect to the server. Aborting..."));
            return;
        else
            v5.online = 0;
            v981.data = {};
            v981.icon_data = {};
            print_raw(v12.format("\videalyaw \r~ Connection lost. Reconnecting in \v10 \rseconds..."));
            v981.failed_connections = v981.failed_connections + 1;
            utils.execute_after(10, v4.connect, v981.link, v981.callbacks);
            return;
        end;
    end
};
v981.send = function()
    -- upvalues: v981 (ref)
    if not v981.socket then
        return;
    else
        v981.socket:send(v981.retrieve());
        return;
    end;
end;
v981.attach = function(v997)
    -- upvalues: v120 (ref), v981 (ref)
    local v998 = v120.additional.reveal_users.value and not v997;
    entity.get_players(false, true, function(v999)
        -- upvalues: v998 (ref), v981 (ref)
        local v1000 = tostring(v999:get_xuid());
        if not v998 then
            if not v981.icon_data[v1000] then
                v999:set_icon();
                v981.icon_data[v1000] = true;
            end;
        elseif v981.data[v1000] then
            v999:set_icon("https://mishkat.cloud/idealyaw/logo.png");
            v981.icon_data[v1000] = false;
        elseif not v981.icon_data[v1000] then
            v999:set_icon();
            v981.icon_data[v1000] = true;
        end;
    end);
end;
v981.init = function()
    -- upvalues: v4 (ref), v981 (ref), v120 (ref), v30 (ref)
    v4.connect(v981.link, v981.callbacks);
    v120.additional.reveal_users:set_callback(v981.send);
    utils.execute_after(2, v981.send);
    v30.Shared.render:set(function()
        -- upvalues: v981 (ref)
        v981.attach();
    end);
    v30.Shared.shutdown:set(function()
        -- upvalues: v981 (ref)
        v981.attach(true);
    end);
end;
v981.init();
v30["Update Player Info"].createmove:set(function(v1001, v1002, v1003)
    -- upvalues: v6 (ref), v119 (ref), v120 (ref)
    if not v1003 then
        return;
    else
        local v1004 = v1002:get_anim_state();
        if v1004 == nil then
            return;
        else
            local l_m_nTickBase_0 = v1002.m_nTickBase;
            if v6.tickbase < l_m_nTickBase_0 then
                v6.tickbase = l_m_nTickBase_0;
                v6.defensive = false;
            elseif v6.tickbase > l_m_nTickBase_0 + 2 then
                v6.defensive = true;
            end;
            if math.abs(v6.tickbase - l_m_nTickBase_0) > 64 then
                v6.tickbase = l_m_nTickBase_0;
            end;
            v6.in_duck = v1002.m_flDuckAmount > 0.89;
            v6.velocity = v1004.velocity_length_xy;
            v6.on_ground = v1004.on_ground and not v1004.landed_on_ground_this_frame;
            v6.on_land = v1004.landing and v6.on_ground;
            v119.on_createmove();
            v6.condition = v119.condition(v1002, v120.conditional["Fake Lag"].enabled.value);
            v6.freestanding = rage.antiaim:get_target(true);
            if v1001.choked_commands == 0 then
                v6.jitter = v6.jitter * -1;
                v6.jitter_count = v6.jitter_count + 1;
            end;
            return;
        end;
    end;
end);