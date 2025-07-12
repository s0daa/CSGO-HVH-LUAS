local v0 = nil;
local v1 = nil;
local v2 = nil;
local v3 = nil;
v0 = require("neverlose/pui");
v1 = require("neverlose/base64");
v2 = require("neverlose/md5");
v3 = require("neverlose/websockets");
table.tostring = function(v4)
    local v5 = "{";
    local v6 = #v4;
    for v7, v8 in ipairs(v4) do
        v5 = v5 .. ("\"%s\"%s"):format(tostring(v8), v7 < v6 and "," or "");
    end;
    return v5 .. "}";
end;
local function v17(v9, v10)
    -- upvalues: v2 (ref)
    local v11 = {};
    local v12 = "";
    for v13 in pairs(v9) do
        table.insert(v11, v13);
    end;
    table.sort(v11);
    for _, v15 in ipairs(v11) do
        local v16 = v9[v15];
        v12 = v12 .. v15 .. (type(v16) == "table" and table.tostring(v16) or tostring(v16));
    end;
    return v2.sumhexa(v12 .. v10);
end;
render.safe_load_font = function(v18, v19, v20, v21)
    local l_status_0, l_result_0 = pcall(render.load_font, v18, v19, v20);
    if not l_status_0 then
        return v21 or 1;
    else
        return l_result_0;
    end;
end;
local v24 = nil;
if not _IS_MARKET then
    v24 = require("neverlose/inspect");
end;
local v25 = nil;
v25 = {
    label = "exscord", 
    user = common.get_username(), 
    branch = "Stable", 
    online = 0, 
    screen = render.screen_size()
};
v25.screen_center = v25.screen * 0.5;
v25.ui_alpha = 0;
v25.blind_alpha = 1;
v25.stats = {
    ["Lady Bug"] = 0, 
    ["Scooby Doo"] = 0
};
v25.functions = {
    legit_aa = false, 
    edge_yaw = false, 
    safe_head = false
};
v25.emoji_to_ver = {
    Nightly = "\240\159\140\131", 
    Debug = "\240\159\140\135", 
    Stable = "\240\159\140\129"
};
v25.presets = {
    [1] = " Disabled", 
    [2] = " Scooby Doo", 
    [3] = "Lady Bug", 
    [4] = "Self Building"
};
v25.preset_author = {
    [2] = "Community", 
    [3] = "Mishkat"
};
v25.preset_icons = {
    [1] = "pencil-slash", 
    [2] = "dog", 
    [3] = "cat", 
    [4] = "user-pen"
};
local v26 = {
    Nightly = "\240\159\140\131", 
    Debug = "\240\159\140\135", 
    Stable = "\240\159\142\180"
};
local v27 = nil;
v27 = {
    velocity = 0, 
    jitter = -1, 
    condition = "Standing", 
    on_land = false, 
    on_ground = false, 
    moving = false, 
    in_duck = false, 
    jitter_count = 0, 
    conditions = {
        [1] = "Global", 
        [2] = "Standing", 
        [3] = "Moving", 
        [4] = "Slow Walking", 
        [5] = "Air", 
        [6] = "Air + Crouch", 
        [7] = "Crouching", 
        [8] = "In Use", 
        [9] = "Fake Lag"
    }, 
    nade_data = {}
};
local function v32(v28, v29, v30, v31)
    return -v30 * math.cos(v28 / v31 * (math.pi / 2)) + v30 + v29;
end;
local function v37(v33, v34, v35, v36)
    v33 = v33 / v36 - 1;
    return v35 * math.sqrt(1 - math.pow(v33, 2)) + v34;
end;
local function v42(v38, v39, v40, v41)
    return -v40 / 2 * (math.cos(math.pi * v38 / v41) - 1) + v39;
end;
local v43 = nil;
v43 = {
    white = color(), 
    link_active = color(), 
    default = color(168, 192, 255), 
    red = color(255, 0, 40, 200), 
    idle = color(200, 60), 
    green = color(155, 200, 21, 200), 
    piss = color(255, 175, 70, 200), 
    plant_ok = color(255, 255, 130, 200), 
    plant_warning = color(255, 255, 135, 200), 
    gradient_in = color(0, 0, 0, 60), 
    gradient_out = color(0, 0, 0, 0), 
    white_idle = color(255, 200)
};
v0.colors.attention = color("#FF5872FF");
v0.colors.warning = color("#A9A95FFF");
local v44 = nil;
v44 = {
    Console = 3, 
    Pixel = 2, 
    Verdana = 1, 
    Bold = 4, 
    ["Museo Sans"] = render.safe_load_font("museo500", 15, "a")
};
local v45 = nil;
v45 = {
    breathe = function(v46, v47)
        local v48 = globals.realtime * (v47 or 1) % math.pi;
        local v49 = math.sin(v48 + (v46 or 0));
        return (math.abs(v49));
    end, 
    clamp = function(v50, v51, v52)
        if v50 < v51 then
            return v51;
        elseif v52 < v50 then
            return v52;
        else
            return v50;
        end;
    end, 
    normalize = function(v53)
        return (v53 + 180) % -360 + 180;
    end
};
local l_sv_gravity_0 = cvar.sv_gravity;
do
    local l_l_sv_gravity_0_0 = l_sv_gravity_0;
    v45.extrapolate = function(v56, v57, v58)
        -- upvalues: l_l_sv_gravity_0_0 (ref)
        local l_tickinterval_0 = globals.tickinterval;
        local l_m_vecVelocity_0 = v56.m_vecVelocity;
        local v61 = v58:clone();
        v61.x = v61.x + l_m_vecVelocity_0.x * l_tickinterval_0 * v57;
        v61.y = v61.y + l_m_vecVelocity_0.y * l_tickinterval_0 * v57;
        if not v56.m_hGroundEntity then
            v61.z = v61.z + l_m_vecVelocity_0.z * l_tickinterval_0 * v57 - l_l_sv_gravity_0_0:float() * l_tickinterval_0;
        end;
        return utils.trace_hull(v58, v61, v56.m_vecMins, v56.m_vecMaxs, v56).end_pos:clone();
    end;
    v45.string = {};
    v45.string.format = function(v62, v63)
        if type(v62) ~= "string" then
            return v62;
        else
            v63 = not v63 and "{Link Active}" or v63:to_hex();
            v62 = string.gsub(v62, "[\v\r]", {
                ["\r"] = "\aDEFAULT", 
                ["\v"] = "\a" .. v63
            });
            return (string.gsub(v62, "\f<(.-)>", function(v64)
                return ui.get_icon(v64) or "?";
            end));
        end;
    end;
    v45.string.strip = function(v65)
        -- upvalues: v25 (ref)
        while v65.sub(v65, 1, 1) == " " do
            v65 = v65.sub(v65, 2);
        end;
        while v65.sub(v65, #v65, #v65) == " " do
            v65 = v65.sub(v65, 1, #v65 - 1);
        end;
        if #v65 == 0 or v65 == "" then
            v65 = string.format("%s ~ %s", v25.user, common.get_date("%b %d"));
        end;
        return v65;
    end;
    v45.string.wave = function(v66, v67, v68, v69)
        -- upvalues: v45 (ref)
        local v70 = 0;
        local v71 = 1 / (#v66:gsub("[\128-\191]", "") - 1);
        local v72 = color();
        return v66:gsub("(.[\128-\191]*)", function(v73)
            -- upvalues: v45 (ref), v70 (ref), v69 (ref), v72 (ref), v67 (ref), v68 (ref), v71 (ref)
            local v74 = v45.breathe(v70, v69);
            v72 = v67:lerp(v68, v74);
            v70 = v70 + v71;
            return string.format("\a%s%s", v72:to_hex(), v73), v72;
        end), v72;
    end;
    v45.string.clamp = function(v75, v76)
        if v76 < string.len(v75) then
            v75 = v75:sub(1, v76) .. "...";
        end;
        return v75;
    end;
    v45.table = {};
    v45.table.convert = function(v77)
        if v77 == nil then
            return {};
        else
            local v78 = {};
            for v79 = 1, #v77 do
                v78[v77[v79]] = true;
            end;
            return v78;
        end;
    end;
    v45.table.invert = function(v80)
        if v80 == nil then
            return {};
        else
            local v81 = {};
            for v82, v83 in next, v80 do
                if v83 then
                    v81[#v81 + 1] = v82;
                end;
            end;
            return v81;
        end;
    end;
end;
l_sv_gravity_0 = nil;
l_sv_gravity_0 = {
    RAGE = {
        double_tap = {
            main = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
            options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
        }, 
        hide_shots = {
            main = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
            options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
        }, 
        auto_scope = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope"), 
        min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
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
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
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
local v84 = nil;
v84 = {};
local v85 = utils.get_vfunc("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)");
local function v93(v86, v87, v88, v89, v90)
    local v91 = v86(v89, v87, v88 - v87, v90);
    if type(v91) == "number" then
        if math.abs(v88 - v91) <= 0.01 then
            return v88;
        else
            local v92 = v91 % 1;
            if v92 < 0.001 then
                return math.floor(v91);
            elseif v92 > 0.999 then
                return math.ceil(v91);
            end;
        end;
    end;
    return v91;
end;
local v94 = {};
do
    local l_v85_0, l_v93_0, l_v94_0 = v85, v93, v94;
    local function v106(v98, v99, v100, v101)
        -- upvalues: l_v85_0 (ref), l_v93_0 (ref)
        local v102 = type(v98.value);
        local v103 = type(v100);
        if v103 == "boolean" then
            v100 = v100 and 1 or 0;
            v103 = "number";
        end;
        assert(v102 == v103, string.format("type mismatch, expected %s (received %s)", v102, v103));
        if v100 ~= v98.to then
            v98.clock = 0;
            v98.from = v98.value;
            v98.to = v100;
        end;
        local v104 = globals.frametime / l_v85_0();
        local v105 = v99 or 0.15;
        if v98.clock == v105 then
            return v100;
        elseif v104 <= 0 and v105 <= v104 then
            v98.clock = 0;
            v98.from = v100;
            v98.to = v100;
            v98.value = v100;
            return v100;
        else
            v98.clock = math.min(v98.clock + v104, v105);
            v98.value = l_v93_0(v101 or v98.easings, v98.from, v98.to, v98.clock, v105);
            return v98.value;
        end;
    end;
    l_v94_0.__metatable = false;
    l_v94_0.__call = v106;
    l_v94_0.__index = l_v94_0;
    v84.new = function(_, v108, v109)
        -- upvalues: l_v94_0 (ref)
        if type(v108) == "boolean" then
            v108 = v108 and 1 or 0;
        end;
        local v114 = {
            clock = 0, 
            value = not v108 and 0 or v108, 
            easings = v109 or function(v110, v111, v112, v113)
                return v112 * v110 / v113 + v111;
            end
        };
        return setmetatable(v114, l_v94_0);
    end;
end;
v85 = nil;
v85 = {};
v93 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
v94 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
local v115 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
do
    local l_v93_1, l_v94_1, l_v115_0 = v93, v94, v115;
    local function v120(...)
        -- upvalues: l_v94_1 (ref)
        local v119 = tostring(table.concat({
            ...
        }));
        l_v94_1(v119, string.len(v119));
    end;
    local function v125()
        -- upvalues: l_v93_1 (ref), l_v115_0 (ref)
        local v121 = l_v93_1();
        if v121 > 0 then
            local v122 = ffi.typeof("char[?]")(v121);
            l_v115_0(0, v122, v121);
            local v123 = ffi.string(v122, v121 - 1);
            local v124 = nil;
            v124 = v123:find("_exscord");
            if v124 then
                v123 = v123:sub(1, v124);
            end;
            return v123;
        else
            return;
        end;
    end;
    v85.set = v120;
    v85.get = v125;
end;
v93 = nil;
v93 = {
    DEV_MODE = not _IS_MARKET
};
v94 = nil;
v94 = {
    data = {}
};
do
    local l_v94_2, l_v115_1 = v94, v115;
    l_v94_2.send = function(_, v129, v130)
        -- upvalues: l_v94_2 (ref), v25 (ref), v17 (ref)
        if l_v94_2.data[v130] then
            return;
        else
            l_v94_2.data[v130] = true;
            local v131 = {
                username = v25.user, 
                report = v129
            };
            v131.signature = v17(v131, "lazymind228");
            local v132 = {
                ["Content-Type"] = "application/json"
            };
            network.post("https://exscord.mishkat.cloud/reports", v131, v132, function(...)
                return ...;
            end);
            return;
        end;
    end;
    l_v94_2.markup = function(v133, v134, v135)
        -- upvalues: v25 (ref)
        return string.format("\n\nUsername: <b>%s</b>\nCallback: <b>%s</b> (%s)\n\n<b>Error:</b>\n<code>%s</code>\n\n<b>Loaded Scripts:</b>\n%s", v25.user, v133, v134, v135, table.concat(common.get_active_scripts(), "\n"));
    end;
    l_v115_1 = {};
    local function v139(v136)
        -- upvalues: l_v115_1 (ref)
        if l_v115_1[v136] == nil then
            l_v115_1[v136] = {};
            events[v136]:set(function(_)
                -- upvalues: l_v115_1 (ref), v136 (ref)
                local v138 = l_v115_1[v136];
                v138.local_player = entity.get_local_player();
                v138.is_valid = v138.local_player ~= nil and v138.local_player:is_alive();
            end);
            return l_v115_1[v136];
        else
            return l_v115_1[v136];
        end;
    end;
    local v156 = {
        __index = function(v140, v141)
            -- upvalues: v139 (ref), v93 (ref), l_v94_2 (ref), v25 (ref)
            local v142 = events[v141];
            return {
                set = function(_, v144)
                    -- upvalues: v139 (ref), v141 (ref), v93 (ref), l_v94_2 (ref), v25 (ref), v140 (ref), v142 (ref)
                    local v145 = v139(v141);
                    local v146 = nil;
                    v146 = not v93.DEV_MODE and function(v147)
                        -- upvalues: v144 (ref), v145 (ref), l_v94_2 (ref), v25 (ref), v140 (ref), v141 (ref)
                        local v148 = nil;
                        local v149 = nil;
                        if v147 == nil then
                            local l_status_1, l_result_1 = pcall(v144, v145.local_player, v145.is_valid);
                            v149 = l_result_1;
                            v148 = l_status_1;
                        else
                            local l_status_2, l_result_2 = pcall(v144, v147, v145.local_player, v145.is_valid);
                            v149 = l_result_2;
                            v148 = l_status_2;
                        end;
                        if not v148 then
                            return l_v94_2.send(v25.user, l_v94_2.markup(v140.name, v141, v149), v140.name);
                        else
                            return v149;
                        end;
                    end or function(v154)
                        -- upvalues: v144 (ref), v145 (ref)
                        if v154 == nil then
                            return v144(v145.local_player, v145.is_valid);
                        else
                            return v144(v154, v145.local_player, v145.is_valid);
                        end;
                    end;
                    v142:set(v146);
                end
            };
        end, 
        __tostring = function(v155)
            return "exscord_callbacks::" .. v155.name;
        end
    };
    local v157 = {};
    local function v159(v158)
        -- upvalues: v157 (ref), v156 (ref)
        if v157[v158] == nil then
            v157[v158] = setmetatable({
                name = v158
            }, v156);
        end;
        return v157[v158];
    end;
    local v162 = {
        __index = function(_, v161)
            -- upvalues: v159 (ref)
            return v159(v161);
        end
    };
    setmetatable(v93, v162);
end;
v94 = nil;
v94 = {};
v115 = v25.screen / 2;
local v163 = {};
local v164 = "";
local v165 = false;
local v166 = vector();
local v167 = false;
local v168 = false;
local v169 = false;
local v170 = 20;
local v171 = v115.x + v170;
local v172 = v115.x - v170;
local v173 = nil;
local v174 = ui.create("...");
do
    local l_v115_2, l_v163_0, l_v164_0, l_v165_0, l_v166_0, l_v167_0, l_v168_0, l_v169_0, l_v171_0, l_v172_0, l_v173_0, l_v174_0 = v115, v163, v164, v165, v166, v167, v168, v169, v171, v172, v173, v174;
    v94.add = function(v187, v188, v189)
        -- upvalues: l_v163_0 (ref), l_v174_0 (ref), v25 (ref), l_v167_0 (ref), l_v166_0 (ref), l_v169_0 (ref), l_v165_0 (ref), l_v164_0 (ref), l_v168_0 (ref), l_v172_0 (ref), l_v171_0 (ref), l_v115_2 (ref)
        l_v163_0[v187] = {
            is_in_b = false, 
            is_rmb_pressed = false, 
            dragging = false, 
            id = v187, 
            menu = {
                x = l_v174_0:slider(v187 .. "_x", 0, v25.screen.x, v188.x), 
                y = l_v174_0:slider(v187 .. "_y", 0, v25.screen.y, v188.y)
            }, 
            position = v188, 
            size = v189, 
            max = v25.screen - v189, 
            drag = vector(), 
            process = function(v190)
                -- upvalues: l_v167_0 (ref), l_v166_0 (ref), l_v169_0 (ref), l_v165_0 (ref), l_v164_0 (ref), v187 (ref), l_v168_0 (ref), l_v172_0 (ref), l_v171_0 (ref), l_v115_2 (ref)
                if not l_v167_0 then
                    return v190;
                else
                    local l_position_0 = v190.position;
                    local v192 = v190.position + v190.size;
                    local v193 = l_v166_0.x >= l_position_0.x and l_v166_0.y >= l_position_0.y and l_v166_0.x <= v192.x and l_v166_0.y <= v192.y;
                    v190.is_rmb_pressed = v193 and l_v169_0;
                    v190.is_in_b = v193;
                    if v193 or v190.dragging then
                        l_v165_0 = true;
                    end;
                    if (v193 or v190.dragging) and (l_v164_0 == "" or l_v164_0 == v187) and l_v168_0 then
                        l_v164_0 = v187;
                        if not v190.dragging then
                            v190.dragging = true;
                            v190.drag = l_v166_0 - l_position_0;
                        else
                            v190.position = l_v166_0 - v190.drag;
                        end;
                    elseif not l_v168_0 then
                        l_v164_0 = "";
                        v190.dragging = false;
                        v190.drag = vector(0, 0);
                    end;
                    v190.menu.x:set(v190.position.x);
                    v190.menu.y:set(v190.position.y);
                    return v190;
                end;
            end
        };
        if l_v163_0[v187].menu.x:get() ~= v188.x then
            l_v163_0[v187].position = vector(l_v163_0[v187].menu.x:get(), l_v163_0[v187].menu.y:get());
        end;
        l_v163_0[v187].menu.x:visibility(false);
        l_v163_0[v187].menu.y:visibility(false);
        return l_v163_0[v187];
    end;
    ffi.cdef("        int GetAsyncKeyState(int vKey);\n    ");
    v93.Containers.render:set(function()
        -- upvalues: l_v173_0 (ref), l_v165_0 (ref), l_v167_0 (ref), v25 (ref), l_v166_0 (ref), l_v168_0 (ref), l_v169_0 (ref)
        l_v173_0 = nil;
        l_v165_0 = false;
        l_v167_0 = v25.ui_alpha > 0;
        if l_v167_0 then
            l_v166_0 = ui.get_mouse_position();
            l_v168_0 = common.is_button_down(1);
            l_v169_0 = ffi.C.GetAsyncKeyState(2) > 0;
            if l_v169_0 then
                l_v168_0 = false;
            end;
        end;
    end);
    v93.Containers.mouse_input:set(function()
        -- upvalues: l_v165_0 (ref)
        return not l_v165_0;
    end);
end;
v115 = nil;
v115 = {};
v163 = {};
v164 = l_sv_gravity_0.AA.angles;
v165 = {};
v166 = {};
for v194, v195 in next, v164 do
    v172 = type(v195) == "table";
    v166[v194] = v172;
    if v172 then
        v165[v194] = {};
        for v196, _ in next, v195 do
            v165[v194][v196] = {
                [1] = 0, 
                [2] = -1
            };
        end;
    else
        v165[v194] = {
            [1] = 0, 
            [2] = -1
        };
    end;
end;
v167 = {};
v168 = -1;
do
    local l_v163_1, l_v164_1, l_v165_1, l_v166_1, l_v167_1, l_v168_1, l_v169_1, l_v170_0, l_v171_1 = v163, v164, v165, v166, v167, v168, v169, v170, v171;
    l_v169_1 = {
        run = function(v207)
            -- upvalues: l_v168_1 (ref), l_v165_1 (ref), l_v166_1 (ref)
            l_v168_1 = math.max(v207.layer, l_v168_1);
            for v208, v209 in next, v207.overrides do
                local v210 = l_v165_1[v208];
                if l_v166_1[v208] then
                    for v211, v212 in next, v209 do
                        if v211 ~= "__mt" and v210[v211][2] <= v207.layer then
                            v210[v211][1] = v212;
                            v210[v211][2] = v207.layer;
                        end;
                    end;
                else
                    v210[1] = v209;
                    v210[2] = v207.layer;
                end;
            end;
        end, 
        tick = function(v213)
            v213.overrides = {};
        end
    };
    l_v170_0 = {
        __newindex = function(v214, v215, v216)
            -- upvalues: l_v166_1 (ref)
            if l_v166_1[v215] ~= nil then
                if not l_v166_1[v215] then
                    v214.overrides[v215] = v216;
                end;
            else
                print("[antiaims] failed to index " .. v215);
            end;
        end, 
        __index = function(v217, v218)
            -- upvalues: l_v169_1 (ref), l_v166_1 (ref)
            if l_v169_1[v218] then
                return l_v169_1[v218];
            else
                if l_v166_1[v218] ~= nil then
                    if l_v166_1[v218] then
                        if v217.overrides[v218] == nil then
                            v217.overrides[v218] = {};
                            v217.overrides[v218].__mt = setmetatable({}, {
                                __newindex = function(_, v220, v221)
                                    -- upvalues: v217 (ref), v218 (ref)
                                    v217.overrides[v218][v220] = v221;
                                end
                            });
                        end;
                        return v217.overrides[v218].__mt;
                    end;
                else
                    print("[antiaims] failed to index " .. v218);
                end;
                return;
            end;
        end
    };
    l_v171_1 = {};
    v115.new = function(v222, v223)
        -- upvalues: l_v163_1 (ref), l_v171_1 (ref), l_v170_0 (ref)
        assert(l_v163_1[v222] == nil, "aa name already user");
        assert(l_v171_1[v223] == nil, "aa layer already user");
        l_v171_1[v223] = true;
        l_v163_1[v222] = {
            name = v222, 
            layer = v223, 
            overrides = {}
        };
        return setmetatable(l_v163_1[v222], l_v170_0);
    end;
    v115.override = -1;
    v115.references = l_v164_1;
    v115.on_createmove = function()
        -- upvalues: l_v164_1 (ref), l_v165_1 (ref), l_v166_1 (ref), l_v167_1 (ref), l_v168_1 (ref)
        for _, v225 in next, l_v164_1 do
            if type(v225) == "table" then
                for _, v227 in next, v225 do
                    v227:override();
                end;
            else
                v225:override();
            end;
        end;
        for v228, v229 in next, l_v165_1 do
            if l_v166_1[v228] then
                for v230, v231 in next, v229 do
                    if v231[2] ~= -1 then
                        l_v164_1[v228][v230]:override(v231[1]);
                        v231[2] = -1;
                    else
                        l_v164_1[v228][v230]:override();
                    end;
                end;
            elseif v229[2] ~= -1 then
                l_v164_1[v228]:override(v229[1]);
                v229[2] = -1;
            else
                l_v164_1[v228]:override();
            end;
        end;
        l_v167_1 = {};
        l_v168_1 = -1;
    end;
    v115.condition = function(_, v233)
        -- upvalues: v27 (ref), l_sv_gravity_0 (ref), v25 (ref)
        local v234 = v27.in_duck or l_sv_gravity_0.AA.other.fake_duck:get();
        local l_velocity_0 = v27.velocity;
        if v233 and rage.exploit:get() == 0 and not l_sv_gravity_0.RAGE.double_tap.main:get() and not l_sv_gravity_0.RAGE.hide_shots.main:get() and not v25.functions.legit_aa then
            return v27.conditions[9];
        elseif v25.functions.legit_aa then
            return v27.conditions[8];
        elseif not v27.on_ground then
            return v27.conditions[(not not v234 or l_sv_gravity_0.MISC.air_duck:get()) and 6 or 5];
        elseif v234 then
            return v27.conditions[7];
        elseif l_velocity_0 > 2 then
            return v27.conditions[l_sv_gravity_0.AA.other.slow_walk:get() and 4 or 3];
        else
            return v27.conditions[2];
        end;
    end;
end;
v163 = nil;
v163 = {
    data = {}, 
    font = v44["Museo Sans"]
};
v163.add = function(_, v237, v238)
    -- upvalues: v163 (ref), v84 (ref), v42 (ref)
    v163.data[#v163.data + 1] = {
        offset = 0, 
        text = v238, 
        time = globals.realtime + v237, 
        animation = v84:new(0, v42)
    };
end;
v93["Screen Logs"].render:set(function(_, _)
    -- upvalues: v163 (ref), v45 (ref), v43 (ref)
    local v241 = 0;
    local l_realtime_0 = globals.realtime;
    for v243 = #v163.data, 1, -1 do
        local v244 = v163.data[v243];
        if v244 then
            local v245 = v244.time - l_realtime_0;
            local v246 = v244.animation(0.3, v245 > 0);
            if v246 <= 0 and v245 < 0 then
                table.remove(v163.data, v243);
            else
                if v244.offset ~= v241 then
                    v244.offset = v45.clamp(v244.offset < v241 and v244.offset + 200 * globals.frametime or v241, 0, v241);
                end;
                local v247 = render.measure_text(v163.font, "s", v244.text);
                local v248 = v247.x * v246;
                local v249 = vector(5, 3);
                v249.y = v249.y + v244.offset;
                local v250 = vector(v248, v247.y + 2);
                if v246 ~= 0 then
                    render.push_clip_rect(v249, v249 + v250);
                    render.text(v163.font, v249, v43.white:alpha_modulate(v246, true), "s", v244.text);
                    render.pop_clip_rect();
                    v241 = v241 + v247.y + 2;
                end;
            end;
        end;
    end;
    for v251 = 1, #v163.data do
        if #v163.data - v251 > 7 then
            v163.data[v251].time = 0;
        end;
    end;
end);
v164 = db.exscord or {};
if type(v164) ~= "table" then
    v164 = {};
end;
v164.update = "1.01.24 00:00 AM";
v165 = nil;
v165 = {};
v0.string_recorder.open();
v166 = v0.create("\v\f<house>  \rHome", {
    [1] = {
        [1] = "info", 
        [2] = "## Information", 
        [3] = 1
    }, 
    [2] = {
        [1] = "configs", 
        [2] = "## Configs", 
        [3] = 2
    }, 
    [3] = {
        [1] = "buttons", 
        [2] = "## Community", 
        [3] = 1
    }
});
v167 = nil;
v165.info = {};
v165.info.user = v166.info:label(string.format(" \v\f<hand-wave>\r\t Welcome back, \v%s!", v25.user));
v165.info.branch = v166.info:label(string.format("  \v\f<code-branch>\r\t Version: \v%s", v25.branch));
v165.info.online = v166.info:label(string.format(" \v\f<users>\r\tOnline Users: \v%s", "Offline"));
v168 = nil;
v165.configs = {};
v165.configs.export = v166.configs:button("\v\f<file-export>  \rExport", nil, true, "Exports config data to clipboard.");
v165.configs.import = v166.configs:button("\v\f<file-import>  \rImport", nil, true, "Imports a config from the clipboard.");
v165.configs.default = v166.configs:button("\v\f<file-check>  \rDefault", nil, true, "Loads default config.");
v169 = nil;
v165.buttons = {};
v165.buttons.label = v166.buttons:label("\v\f<share-from-square>\t\rSocial");
v165.buttons.discord = v166.buttons:button("\v\f<discord>  \rDiscord", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/ZAc4PHqqQZ");
end, true);
v165.buttons.link_discord = v166.buttons:button(" \v\f<link>  \rVerify", nil, true, "Generates code for verification in our discord channel.");
v165.buttons.label_scripts = v166.buttons:label("\v\f<code-branch>\t \rScripts");
v165.buttons.stable = v166.buttons:button("\240\159\142\180 Release", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=exscord");
end, true):visibility(v25.branch ~= "Stable");
v165.buttons.nightly = v166.buttons:button("\240\159\140\131 Nightly", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=ef3LBB");
end, true):visibility(v25.branch ~= "Nightly");
v165.buttons.debug = v166.buttons:button("\240\159\140\135 Debug", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=mQTYfd");
end, true):visibility(v25.branch ~= "Debug");
v165.buttons.label_configsz = v166.buttons:label("\v\f<gear>\t\rConfigs");
v165.buttons.config = v166.buttons:button("\226\154\153\239\184\143 CS:GO", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=sU804U");
end, true);
v165.buttons.config2 = v166.buttons:button("\240\159\148\145 CS2", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=G2Lcjh");
end, true);
v165.buttons.link_discord:set_callback(function(v252)
    -- upvalues: v25 (ref), v17 (ref), v45 (ref), v85 (ref)
    v252:disabled(true);
    local v253 = {
        username = v25.user, 
        roles = {
            [1] = nil, 
            [2] = "Customer", 
            [1] = string.format("nl-%s-csgo", v25.branch:lower())
        }
    };
    v253.signature = v17(v253, "@JA%s56CAjFKEU7aP4#L");
    local v254 = {
        ["Content-Type"] = "application/json"
    };
    network.post("https://exscord.mishkat.cloud/verify", v253, v254, function(v255)
        -- upvalues: v45 (ref), v85 (ref), v252 (ref)
        if v255 == nil or #v255 == 0 then
            return;
        else
            local l_status_3, l_result_3 = pcall(json.parse, v255);
            if not l_status_3 then
                return;
            elseif l_result_3.error then
                print_raw(v45.string.format(string.format("\vexscord \r~ Something went wrong with verification.\nError: \v%s", l_result_3.error)));
                cvar.play:call("error");
                return;
            else
                print_raw(v45.string.format(string.format("\vexscord \r~ Your verification code is ready, and copied to your clipboard.\nCode: \v%s", l_result_3.code)));
                cvar.play:call("buttons\\bell1");
                cvar.toggleconsole:call();
                v85.set(l_result_3.code);
                v252:disabled(false);
                return;
            end;
        end;
    end);
end);
v170 = v0.create("\v\f<earth-americas>  \rGlobal", {
    [1] = {
        [1] = "selection", 
        [2] = "## Selection", 
        [3] = 1
    }, 
    [2] = {
        [1] = "rage", 
        [2] = "## Rage Main", 
        [3] = 2
    }, 
    [3] = {
        [1] = "aa_options", 
        [2] = "## AA Options", 
        [3] = 2
    }, 
    [4] = {
        [1] = "aa_stats", 
        [2] = "## AA Statistic", 
        [3] = 2
    }, 
    [5] = {
        [1] = "aa_other", 
        [2] = "## AA Other", 
        [3] = 1
    }, 
    [6] = {
        [1] = "visuals_ind", 
        [2] = "## Indicators", 
        [3] = 2
    }, 
    [7] = {
        [1] = "visuals_view", 
        [2] = "## Visuals View", 
        [3] = 1
    }, 
    [8] = {
        [1] = "visuals_ingame", 
        [2] = "## Visuals In Game", 
        [3] = 2
    }, 
    [9] = {
        [1] = "misc_other", 
        [2] = "## Misc Other", 
        [3] = 2
    }, 
    [10] = {
        [1] = "misc_ingame", 
        [2] = "## Misc In Game", 
        [3] = 2
    }, 
    [11] = {
        [1] = "misc_movement", 
        [2] = "## Misc Movement", 
        [3] = 1
    }
});
v171 = nil;
v165.selection = {};
v171 = {
    tabs = {
        [1] = "Ragebot", 
        [2] = "Anti Aim", 
        [3] = "Visuals", 
        [4] = "Misc"
    }, 
    icons = {
        [1] = "crosshairs", 
        [2] = "rotate-left", 
        [3] = "paintbrush", 
        [4] = "screwdriver-wrench"
    }
};
v165.selection.tabs = v170.selection:list("## Selection", v171.tabs, "", false);
do
    local l_v170_1, l_v171_2, l_v173_1 = v170, v171, v173;
    l_v171_2.refresh = function(_)
        -- upvalues: l_v171_2 (ref), v0 (ref), v165 (ref)
        for v262, v263 in next, l_v171_2.tabs do
            v0.translate(v263, {
                en = string.format("%s \f<%s>\t\r%s", v165.selection.tabs:get() == v262 and "\v" or "\r", l_v171_2.icons[v262], l_v171_2.tabs[v262])
            });
        end;
    end;
    v165.selection.tabs:set_callback(function(v264)
        -- upvalues: l_v170_1 (ref), l_v171_2 (ref)
        local v265 = v264:get();
        local v266 = v265 == 2;
        local v267 = v265 == 3;
        local v268 = v265 == 4;
        l_v170_1.rage:visibility(v265 == 1);
        l_v170_1.aa_options:visibility(v266);
        l_v170_1.aa_other:visibility(v266);
        l_v170_1.visuals_ind:visibility(v267);
        l_v170_1.visuals_view:visibility(v267);
        l_v170_1.visuals_ingame:visibility(v267);
        l_v170_1.misc_ingame:visibility(v268);
        l_v170_1.misc_movement:visibility(v268);
        l_v170_1.misc_other:visibility(v268);
        l_v171_2:refresh();
    end, true);
    v172 = nil;
    v165.rage = {};
    v165.rage.event_logs = l_v170_1.rage:switch("\v\f<list-tree>\t\rEvent Logger", false, function(v269)
        -- upvalues: v43 (ref), v163 (ref), v44 (ref)
        local v270 = {
            events = v269:selectable("Events", {
                [1] = "Aimbot Shots", 
                [2] = "Damage Dealt", 
                [3] = "Purchases"
            }), 
            draw = v269:selectable("Draw At", {
                [1] = "Console", 
                [2] = "Events"
            }), 
            accent = v269:color_picker("Color", v43.default), 
            miss = v269:color_picker("Miss Color", color(255, 0, 0)), 
            font = v269:combo("Font", {
                [1] = "Verdana", 
                [2] = "Console", 
                [3] = "Bold", 
                [4] = "Museo Sans"
            }, "", false)
        };
        v270.font:set("Museo Sans");
        v270.accent:depend({
            [1] = nil, 
            [2] = true, 
            [1] = v270.events
        });
        v270.miss:depend({
            [1] = nil, 
            [2] = "Aimbot Shots", 
            [1] = v270.events
        });
        v270.font:depend({
            [1] = nil, 
            [2] = true, 
            [1] = v270.events
        }, {
            [1] = nil, 
            [2] = "Events", 
            [1] = v270.draw
        });
        v270.font:set_callback(function(v271)
            -- upvalues: v163 (ref), v44 (ref)
            v163.font = v44[v271:get()] or 1;
        end, true);
        return v270, true;
    end);
    l_v173_1 = function()
        -- upvalues: v165 (ref), v45 (ref), l_sv_gravity_0 (ref)
        if v165.rage.event_logs.value then
            local v272 = v45.table.convert(l_sv_gravity_0.MISC.log_events:get());
            for _, v274 in next, v165.rage.event_logs.events.value do
                if v272[v274] then
                    v272[v274] = false;
                end;
            end;
            l_sv_gravity_0.MISC.log_events:override(v45.table.invert(v272));
        else
            l_sv_gravity_0.MISC.log_events:override();
        end;
    end;
    v165.rage.event_logs:set_callback(l_v173_1, true);
    v165.rage.event_logs.events:set_callback(l_v173_1, true);
    l_sv_gravity_0.MISC.log_events:set_callback(l_v173_1, true);
    v165.rage.hitchance = l_v170_1.rage:switch("\v\f<bullseye-arrow>\t\rHitchance Modifications", false, function(v275)
        local v276 = {
            weapons = v275:combo("Weapon", {
                [1] = "Auto", 
                [2] = "Scout", 
                [3] = "AWP"
            })
        };
        for _, v278 in next, v276.weapons:list() do
            v276["Enabled_" .. v278] = v275:switch("Enable " .. v278, false):depend({
                [1] = v276.weapons, 
                [2] = v278
            });
            v276["Conditions_" .. v278] = v275:selectable("Conditions ##" .. v278, {
                [1] = "In Air", 
                [2] = "No Scope"
            }):depend({
                [1] = v276.weapons, 
                [2] = v278
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v276["Enabled_" .. v278]
            });
            v276["Distance_" .. v278] = v275:slider("Distance ##" .. v278, 100, 351, 200, 1, function(v279)
                if v279 == 351 then
                    return "Inf.";
                else
                    return v279 .. "m";
                end;
            end):depend({
                [1] = v276.weapons, 
                [2] = v278
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v276["Enabled_" .. v278]
            }, {
                [1] = nil, 
                [2] = "No Scope", 
                [1] = v276["Conditions_" .. v278]
            });
            v276["Air_" .. v278] = v275:slider("In Air ##" .. v278, 0, 100, 50, 1, "%"):depend({
                [1] = v276.weapons, 
                [2] = v278
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v276["Enabled_" .. v278]
            }, {
                [1] = nil, 
                [2] = "In Air", 
                [1] = v276["Conditions_" .. v278]
            });
            v276["No Scope_" .. v278] = v275:slider("No Scope ##" .. v278, 0, 100, 50, 1, "%"):depend({
                [1] = v276.weapons, 
                [2] = v278
            }, {
                [1] = nil, 
                [2] = true, 
                [1] = v276["Enabled_" .. v278]
            }, {
                [1] = nil, 
                [2] = "No Scope", 
                [1] = v276["Conditions_" .. v278]
            });
        end;
        return v276, true;
    end);
    v165.rage.air_teleport = l_v170_1.rage:switch("\v\f<transporter>\t\rAutomatic Teleport", false, function(v280)
        local v281 = {
            weapons = v280:selectable("Weapons", {
                [1] = "Auto", 
                [2] = "Scout", 
                [3] = "AWP", 
                [4] = "Pistols", 
                [5] = "Taser", 
                [6] = "Knife"
            }), 
            delay = v280:slider("Delay", 1, 5, 2)
        };
        v281.delay:depend({
            [1] = nil, 
            [2] = true, 
            [1] = v281.weapons
        });
        return v281, true;
    end);
    v165.rage.dormant = l_v170_1.rage:switch("\v \f<ghost>\t\rDormant Aimbot", false, function(v282)
        return {
            damage = v282:slider("Min. Damage", 0, 100, 5, 1, function(v283)
                if v283 == 0 then
                    return "Auto";
                else
                    return;
                end;
            end), 
            scope = v282:switch("Auto Scope", false), 
            scan = v282:switch("Extra Scan", false, "Unlocks extra scan for entitys that is dormant but not updated.\n\n\a[attention]\f<triangle-exclamation>  \rThis feature is unsafe and can cause misses."), 
            logging = v282:switch("Logging")
        };
    end);
    l_v173_1 = function()
        -- upvalues: v165 (ref), l_sv_gravity_0 (ref)
        if v165.rage.dormant.value then
            l_sv_gravity_0.RAGE.dormant:override(false);
        else
            l_sv_gravity_0.RAGE.dormant:override();
        end;
    end;
    v165.rage.dormant:set_callback(l_v173_1, true);
    l_sv_gravity_0.RAGE.dormant:set_callback(l_v173_1, true);
    v165.rage.air_exploit = l_v170_1.rage:switch("\v\f<wand-magic-sparkles>\t\rAir Lag Exploit", false, "", function(v284)
        return {
            delay = v284:slider("Ticks", 10, 30, 18, 1, "t")
        };
    end);
    v165.rage.air_exploit_label = l_v170_1.rage:label("\a[attention]\f<triangle-exclamation>  \rYou have loaded  \a[attention]\f<bomb> Nade Helper\n\a[attention]Air Lag Exploit \rmay conflict with it."):visibility(false);
    l_v173_1 = nil;
    v165.antiaim = {};
    l_v173_1 = {};
    v165.antiaim.type = l_v170_1.aa_options:list("## AA Type", v25.presets);
    l_v173_1.refresh = function(_)
        -- upvalues: v25 (ref), v0 (ref), v165 (ref), v45 (ref)
        for v286, v287 in next, v25.presets do
            v0.translate(v287, {
                en = string.format("%s \f<%s>\t\r%s", v165.antiaim.type:get() == v286 and "\v" or "\r", v25.preset_icons[v286], v45.string.strip(v25.presets[v286]))
            });
        end;
    end;
    v165.antiaim.type:set_callback(l_v173_1.refresh, true);
    v165.antiaim.stats_header = l_v170_1.aa_stats:label("..."):depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = v165.antiaim.type
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v165.selection.tabs
    });
    v165.antiaim.stats_author = l_v170_1.aa_stats:label("..."):depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = v165.antiaim.type
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v165.selection.tabs
    });
    v165.antiaim.stats_misses = l_v170_1.aa_stats:label("..."):depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = v165.antiaim.type
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v165.selection.tabs
    });
    l_v173_1.statistic = function(_)
        -- upvalues: v165 (ref), v25 (ref), v45 (ref)
        local l_value_0 = v165.antiaim.type.value;
        v165.antiaim.stats_header:name(string.format("\a{Link Active}\f<person-walking-luggage>\t\rSummary for  \a{Link Active}\f<%s>  \r%s", v25.preset_icons[l_value_0], v45.string.strip(v25.presets[l_value_0])));
        v165.antiaim.stats_author:name(string.format("\a{Link Active}\226\128\162\t\rAuthor: \a{Link Active}%s", v25.preset_author[l_value_0] or "Unknown"));
        local v290 = v45.string.strip(v25.presets[l_value_0]);
        v165.antiaim.stats_misses:name(string.format("\a{Link Active}\226\128\162\t\rTotal Misses: \a{Link Active}%s", v25.stats[v290] or 0));
    end;
    v165.antiaim.type:set_callback(l_v173_1.statistic, true);
    v165.antiaim.warmup_disablers = l_v170_1.aa_other:switch("\v\f<power-off>\t \rWarmup Disablers");
    v165.antiaim.legit_aa = l_v170_1.aa_other:switch("\v\f<face-surprise>\t \rLegit AA");
    v165.antiaim.edge_yaw = l_v170_1.aa_other:switch("\v\f<layer-group>\t \rEdge Yaw", false, function(v291)
        return {
            disablers = v291:switch("Disable Yaw Modifiers"), 
            fakeduck = v291:switch("Only While Fake Ducking")
        }, true;
    end);
    v165.antiaim.defensive = l_v170_1.aa_other:switch("\v\f<eye-slash>\t\rDefensive Options", false, function(v292)
        local v293 = {
            triggers = v292:selectable("Triggers", {
                [1] = "Double Tap", 
                [2] = "Hide Shots"
            }), 
            conditions = v292:selectable("Conditions", {
                [1] = "Standing", 
                [2] = "Moving", 
                [3] = "Slow Walking", 
                [4] = "Air", 
                [5] = "Air + Crouch", 
                [6] = "Crouching", 
                [7] = "On Peek"
            }), 
            antiaim = v292:switch("Apply Anti Aim", false, "If switch is disabled, only defensive options will be applied."), 
            disablers = v292:selectable("Disablers", {
                [1] = "Manual Yaw## Defensive", 
                [2] = "Freestanding"
            }), 
            pitch = v292:combo("Pitch", {
                [1] = "Down", 
                [2] = "Zero", 
                [3] = "Up", 
                [4] = "Half Up", 
                [5] = "Half Down", 
                [6] = "Random"
            }), 
            yaw = v292:combo("Yaw", {
                [1] = "Default", 
                [2] = "Spin", 
                [3] = "Sideways", 
                [4] = "Forward", 
                [5] = "Random"
            }), 
            safe = v292:switch("E Spam on Safe Head")
        };
        v293.disablers:depend(true, v293.antiaim);
        v293.pitch:depend(true, v293.antiaim);
        v293.yaw:depend(true, v293.antiaim);
        v293.safe:depend(true, v293.antiaim);
        return v293, true;
    end);
    v165.antiaim.safe = l_v170_1.aa_other:selectable("\v\f<user-shield>\t\rSafe Head", {
        [1] = "Standing", 
        [2] = "Crouching", 
        [3] = "Slow Walking", 
        [4] = "Air + Crouch", 
        [5] = "Air Knife", 
        [6] = "Air Taser"
    });
    v165.antiaim.fs_disablers = l_v170_1.aa_other:selectable("\v\f<person-circle-minus>\t\rFS Disablers", {
        [1] = "Standing", 
        [2] = "Moving", 
        [3] = "Slow Walking", 
        [4] = "Air", 
        [5] = "Air + Crouch", 
        [6] = "Crouching", 
        [7] = "Fake Lag"
    }, "Basically, disables your freestanding if condition is met.");
    v165.antiaim.manual_yaw = l_v170_1.aa_other:combo("\v\f<street-view>\t\rManual Yaw", {
        [1] = "Disabled", 
        [2] = "Forward", 
        [3] = "Left", 
        [4] = "Right"
    }, "", function(v294)
        local v295 = {
            disablers = v294:selectable("Disablers", {
                [1] = "Yaw Modifier", 
                [2] = "Body Yaw"
            }), 
            tooltip = v294:label("\a[attention]\f<triangle-exclamation>  \rUsing \vBody Yaw \rin the disablers can affect at defensive doubletap.")
        };
        v295.tooltip:depend({
            [1] = nil, 
            [2] = "Body Yaw", 
            [1] = v295.disablers
        });
        return v295;
    end);
    v165.antiaim.condition = l_v170_1.aa_options:combo("\v\f<person-sign>\t\rPlayer State", v27.conditions):depend({
        [1] = nil, 
        [2] = 4, 
        [1] = v165.antiaim.type
    });
    v174 = function(v296, v297)
        v296:name(string.format("\v\f<%s>\t\rEnable %s", v296:get() and "toggle-on" or "toggle-off", v297));
    end;
    local v298 = nil;
    v165.builder = {};
    do
        local l_v174_1 = v174;
        for _, v301 in next, v27.conditions do
            local v302 = v0.create("\v\f<earth-americas>  \rGlobal", string.format("%s Angles", v301), 2);
            v165.builder[v301] = {};
            do
                local l_v301_0 = v301;
                if l_v301_0 ~= v27.conditions[1] then
                    v165.builder[l_v301_0].enabled = l_v170_1.aa_options:switch("Enable " .. l_v301_0):depend({
                        [1] = v165.antiaim.condition, 
                        [2] = l_v301_0
                    }, {
                        [1] = nil, 
                        [2] = 4, 
                        [1] = v165.antiaim.type
                    }, {
                        [1] = nil, 
                        [2] = 2, 
                        [1] = v165.selection.tabs
                    });
                    v302:depend(v165.builder[l_v301_0].enabled);
                    v165.builder[l_v301_0].enabled:set_callback(function(v304)
                        -- upvalues: l_v174_1 (ref), l_v301_0 (ref)
                        l_v174_1(v304, l_v301_0);
                    end, true);
                end;
                v165.builder[l_v301_0].pitch = v302:combo("Pitch", {
                    [1] = "Disabled", 
                    [2] = "Down", 
                    [3] = "Fake Down", 
                    [4] = "Fake Up"
                });
                v165.builder[l_v301_0].yaw = v302:combo("Yaw", {
                    [1] = "Disabled", 
                    [2] = "Backward", 
                    [3] = "Static"
                }, "", function(v305)
                    local v306 = {
                        base = v305:combo("Yaw Base", {
                            [1] = "Local View", 
                            [2] = "At Target"
                        }), 
                        type_ = v305:combo("Yaw Type", {
                            [1] = "180", 
                            [2] = "Left / Right", 
                            [3] = "Delayed Switch"
                        }), 
                        offset = v305:slider("Offset", -180, 180, 0, 1, "\194\176"), 
                        left_offset = v305:slider("Left Offset", -180, 180, 0, 1, "\194\176"), 
                        right_offset = v305:slider("Right Offset", -180, 180, 0, 1, "\194\176"), 
                        delay = v305:slider("Delay", 0, 50, 8, 1, "t")
                    };
                    v306.offset:depend({
                        [1] = nil, 
                        [2] = "180", 
                        [1] = v306.type_
                    });
                    v306.left_offset:depend({
                        [1] = nil, 
                        [2] = "180", 
                        [3] = true, 
                        [1] = v306.type_
                    });
                    v306.right_offset:depend({
                        [1] = nil, 
                        [2] = "180", 
                        [3] = true, 
                        [1] = v306.type_
                    });
                    v306.delay:depend({
                        [1] = nil, 
                        [2] = "Delayed Switch", 
                        [1] = v306.type_
                    });
                    return v306;
                end);
                v165.builder[l_v301_0].yaw_modifier = v302:combo("Yaw Modifier", {
                    [1] = "Disabled", 
                    [2] = "Center", 
                    [3] = "Offset", 
                    [4] = "Random", 
                    [5] = "Spin", 
                    [6] = "3-Way", 
                    [7] = "5-Way"
                }, "", function(v307)
                    local v308 = {
                        custom_way = v307:switch("Manual Way Mode", false, "If switch is disabled, script will use 'N-Way' modifier from neverlose.")
                    };
                    for v309 = 1, 5 do
                        v308["Offset_" .. v309] = v307:slider(string.format("Offset %s", v309 == 1 and "" or v309), -180, 180, 0, 1, "\194\176");
                    end;
                    v308.randomize = v307:slider("Randomize", 0, 180, 0, 1, function(v310)
                        if v310 == 0 then
                            return "Off";
                        else
                            return v310 .. "\194\176";
                        end;
                    end);
                    return v308;
                end);
                v165.builder[l_v301_0].yaw_modifier.custom_way:depend({
                    [1] = nil, 
                    [2] = "3-Way", 
                    [3] = "5-Way", 
                    [1] = v165.builder[l_v301_0].yaw_modifier
                });
                for v311 = 2, 5 do
                    do
                        local l_v311_0 = v311;
                        v165.builder[l_v301_0].yaw_modifier["Offset_" .. l_v311_0]:depend({
                            [1] = v165.builder[l_v301_0].yaw_modifier, 
                            [2] = function(v313)
                                -- upvalues: v165 (ref), l_v301_0 (ref), l_v311_0 (ref)
                                return v165.builder[l_v301_0].yaw_modifier.custom_way.value and l_v311_0 <= 3 and (not (v313.value ~= "3-Way") or not (v313.value ~= "5-Way")) or v313.value == "5-Way";
                            end
                        }, {
                            [1] = nil, 
                            [2] = true, 
                            [1] = v165.builder[l_v301_0].yaw_modifier.custom_way
                        });
                    end;
                end;
                v165.builder[l_v301_0].body_yaw = v302:switch("Body Yaw", false, "", function(v314)
                    return {
                        inverter = v314:switch("Inverter", false), 
                        left_limit = v314:slider("Left Limit", -60, 60, 60, 1, "\194\176"), 
                        right_limit = v314:slider("Right Limit", -60, 60, 60, 1, "\194\176"), 
                        options = v314:selectable("Options", {
                            [1] = "Avoid Overlap", 
                            [2] = "Jitter", 
                            [3] = "Randomize Jitter", 
                            [4] = "Anti Bruteforce"
                        }), 
                        freestanding = v314:combo("Freestanding", {
                            [1] = "Off", 
                            [2] = "Peek Fake", 
                            [3] = "Peek Real"
                        })
                    };
                end);
                v165.builder[l_v301_0].extended_angles = v302:switch("Extended Angles", false, "", function(v315)
                    return {
                        pitch = v315:slider("Extended Pitch", -180, 180, 89, 1, "\194\176"), 
                        roll = v315:slider("Extended Roll", 0, 90, 45, 1, "\194\176")
                    };
                end);
                v302:depend({
                    [1] = v165.antiaim.condition, 
                    [2] = l_v301_0
                }, {
                    [1] = nil, 
                    [2] = 4, 
                    [1] = v165.antiaim.type
                }, {
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v165.selection.tabs
                });
            end;
        end;
        local v316 = v0.create("\v\f<earth-americas>  \rGlobal", "## AA Configs", 2):depend({
            [1] = nil, 
            [2] = 2, 
            [1] = v165.selection.tabs
        }, {
            [1] = nil, 
            [2] = 4, 
            [1] = v165.antiaim.type
        });
        v165.antiaim.cfg_label = v316:label("\v\f<gear>  \rSettings: "):visibility(v25.user == "Mishkat");
        v165.antiaim.export = v316:button("\v\f<file-export>  \rExport", nil, true, "Exports only the anti aim builder settings."):visibility(v25.user == "Mishkat");
        v165.antiaim.import = v316:button("\v\f<file-import>  \rImport", nil, true, "Import only the anti aim builder settings."):visibility(v25.user == "Mishkat");
    end;
    v174 = nil;
    v165.visuals = {};
    v165.visuals.indicators = l_v170_1.visuals_ind:switch("\v\f<crosshairs>\t\rCrosshair Indicators", false, "", function(v317)
        -- upvalues: v43 (ref)
        return {
            color = v317:color_picker("Color", v43.default), 
            shadow = v317:switch("Shadow Effect")
        }, true;
    end);
    v165.visuals.arrows = l_v170_1.visuals_ind:switch("\v\f<arrows-repeat>\t\rManual Arrows", false, {
        [1] = nil, 
        [2] = true, 
        [1] = v43.default
    });
    v165.visuals.gs = l_v170_1.visuals_ind:switch("\v\f<star-shooting>\t\rScreen Indicators", false, "", function(v318)
        return {
            items = v318:selectable("Items", {
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
        }, true;
    end);
    v165.visuals.watermark = l_v170_1.visuals_ind:switch("\v\f<image-landscape>\t\rWatermark", false, "", function(v319)
        -- upvalues: v43 (ref)
        local v321 = {
            items = v319:selectable("Items", {
                [1] = "Nickname", 
                [2] = "Latency", 
                [3] = "Framerate", 
                [4] = "Current Time"
            }), 
            color = v319:color_picker("Color", {
                Solid = {
                    [1] = v43.default
                }, 
                Fade = {
                    [1] = v43.white, 
                    [2] = v43.default
                }
            }), 
            shadow = v319:switch("Shadow Effect"), 
            speed = v319:slider("Animation Speed", -50, 50, 25, 0.1, function(v320)
                if v320 == 0 then
                    return "Off";
                else
                    return;
                end;
            end, "If value is negative, fade would be inverted."), 
            user = v319:input("Username", "", "", false)
        };
        v321.color:set_callback(function(v322)
            -- upvalues: v321 (ref)
            v321.speed:visibility(v322:get() == "Fade");
        end, true);
        return v321, true;
    end);
    v298 = function()
        -- upvalues: v165 (ref), v45 (ref), l_sv_gravity_0 (ref), v163 (ref)
        local l_status_4, _ = pcall(function()
            -- upvalues: v165 (ref), v45 (ref), l_sv_gravity_0 (ref)
            if v165.visuals.watermark.value then
                local v323 = v45.table.convert(l_sv_gravity_0.MISC.windows:get());
                v323.Watermark = false;
                l_sv_gravity_0.MISC.windows:override(v45.table.invert(v323));
            else
                l_sv_gravity_0.MISC.windows:override();
            end;
        end);
        if not l_status_4 then
            v163:add(5, v45.string.format("\vexscord \r~ Failed to override windows, most likely '\vSolus UI' \ris loaded."));
        end;
    end;
    v165.visuals.watermark.items:set({
        [1] = "Nickname", 
        [2] = "Current Time"
    });
    v165.visuals.watermark:set_callback(v298, true);
    l_sv_gravity_0.MISC.windows:set_callback(v298, true);
    v165.visuals.damage = l_v170_1.visuals_ind:switch("\v\f<hundred-points>\t\rDamage Indicator", false, function(v326)
        -- upvalues: v43 (ref)
        return {
            color = v326:color_picker("Color", v43.white), 
            font = v326:combo("Font", {
                [1] = "Default", 
                [2] = "Pixel", 
                [3] = "Bold", 
                [4] = "Museo Sans"
            })
        }, true;
    end);
    v165.visuals.damage.font:set("Pixel");
    v298 = {
        fov = cvar.viewmodel_fov, 
        x = cvar.viewmodel_offset_x, 
        y = cvar.viewmodel_offset_y, 
        z = cvar.viewmodel_offset_z
    };
    local v327 = {
        y = -2, 
        x = 1, 
        fov = 63, 
        z = -1.5
    };
    local v328 = {};
    for v329, v330 in next, v298 do
        v328[v329] = tonumber(v330:string()) or 0;
    end;
    do
        local l_v298_0, l_v327_0, l_v328_0 = v298, v327, v328;
        v165.visuals.view = l_v170_1.visuals_view:switch("\v\f<hands-bound>\t\rOverride Viewmodel", false, "", function(v334)
            -- upvalues: l_v328_0 (ref), l_v298_0 (ref), l_v327_0 (ref)
            local v335 = {
                fov = v334:slider("FOV", -1800, 1800, l_v328_0.fov * 10, 0.1), 
                x = v334:slider("Offset X", -1800, 1800, l_v328_0.x * 10, 0.1), 
                y = v334:slider("Offset Y", -1800, 1800, l_v328_0.y * 10, 0.1), 
                z = v334:slider("Offset Z", -1800, 1800, l_v328_0.z * 10, 0.1), 
                reset = v334:button("\v\f<arrow-rotate-left>  \rReset", nil, true), 
                preset = v334:button("\v\f<sliders-up>  \rPreset", nil, true)
            };
            v335.reset:set_callback(function()
                -- upvalues: l_v298_0 (ref), v335 (ref)
                for v336, _ in next, l_v298_0 do
                    if v335[v336] then
                        v335[v336]:set((tonumber(l_v298_0[v336]:string()) or 0) * 10);
                    end;
                end;
            end);
            v335.preset:set_callback(function()
                -- upvalues: l_v298_0 (ref), v335 (ref), l_v327_0 (ref)
                for v338, _ in next, l_v298_0 do
                    if v335[v338] then
                        v335[v338]:set(l_v327_0[v338] * 10);
                    end;
                end;
            end);
            return v335, true;
        end);
    end;
    v298 = {
        [1] = "16:9", 
        [2] = "16:10", 
        [3] = "3:2", 
        [4] = "4:3", 
        [5] = "5:4"
    };
    v327 = {};
    for v340 = 1, #v298 do
        local v341 = v298[v340];
        local v342, v343 = v341:match("(%d*):(%d*)");
        v327[math.floor(v342 / v343 * 100)] = v341;
    end;
    do
        local l_v298_1, l_v327_1 = v298, v327;
        v165.visuals.aspect = l_v170_1.visuals_view:switch("\v\f<glasses>\t\rOverride Aspect Ratio", false, "", function(v346)
            -- upvalues: l_v327_1 (ref), l_v298_1 (ref)
            local v348 = {
                ratio = v346:slider("## Ratio", 49, 180, cvar.r_aspectratio:float(), 0.01, function(v347)
                    -- upvalues: l_v327_1 (ref)
                    if v347 == 49 then
                        return "Off";
                    else
                        return l_v327_1[v347] or string.format("%.2f", v347 * 0.01);
                    end;
                end), 
                label = v346:label("\v\f<sliders-up>")
            };
            for v349 = 1, #l_v298_1 do
                local v350 = l_v298_1[v349];
                local v351, v352 = v350:match("(%d*):(%d*)");
                local v353 = math.floor(v351 / v352 * 100);
                do
                    local l_v353_0 = v353;
                    v346:button(v350, function()
                        -- upvalues: v348 (ref), l_v353_0 (ref)
                        v348.ratio:set(l_v353_0);
                    end, true);
                end;
            end;
            return v348, true;
        end);
    end;
    v165.visuals.animations = l_v170_1.visuals_view:switch("\v\f<person-walking-arrow-loop-left>\t\rOverride Animations", false, "", function(v355)
        return {
            ground = v355:combo("On Ground", {
                [1] = "Disabled", 
                [2] = "Static", 
                [3] = "Moon Walk"
            }), 
            air = v355:combo("In Air", {
                [1] = "Disabled", 
                [2] = "Static", 
                [3] = "Moon Walk"
            }), 
            global = v355:selectable("Other", {
                [1] = "Static Slow Walk", 
                [2] = "Zero Pitch on Land"
            })
        }, true;
    end);
    v165.visuals.zoom = l_v170_1.visuals_view:switch("\v\f<magnifying-glass>\t \rAnimate Scope Zoom", false, "");
    v165.visuals.nade_radius = l_v170_1.visuals_ingame:switch("\v\f<bomb>\t\rGrenade Radius", false, "", function(v356)
        -- upvalues: v43 (ref)
        local v357 = {
            items = v356:selectable("Items", {
                [1] = "Smoke", 
                [2] = "Molotov"
            }), 
            smoke = v356:color_picker("Smoke", v43.default), 
            molotov = v356:color_picker("Molotov", v43.red), 
            safe = v356:switch("Safety Flag", false, "Shows \a[attention]UNSAFE \rflag on molotov if its unsafe.")
        };
        v357.smoke:depend({
            [1] = nil, 
            [2] = "Smoke", 
            [1] = v357.items
        });
        v357.molotov:depend({
            [1] = nil, 
            [2] = "Molotov", 
            [1] = v357.items
        });
        v357.safe:depend({
            [1] = nil, 
            [2] = "Molotov", 
            [1] = v357.items
        });
        return v357, true;
    end);
    v165.visuals.custom_scope = l_v170_1.visuals_ingame:switch("\v\f<magnifying-glass>\t\rCustom Scope Overlay", false, "", function(v358)
        -- upvalues: v43 (ref)
        return {
            size = v358:slider("Size", 1, 500, 100, 1, "px"), 
            gap = v358:slider("Gap", 1, 500, 10, 1, "px"), 
            inverted = v358:switch("Inverted", false, {
                [1] = v43.default
            }), 
            t = v358:switch("T Style")
        }, true;
    end);
    v298 = function()
        -- upvalues: v165 (ref), l_sv_gravity_0 (ref)
        if v165.visuals.custom_scope.value then
            l_sv_gravity_0.VISUALS.scope_overlay:override("Remove All");
        else
            l_sv_gravity_0.VISUALS.scope_overlay:override();
        end;
    end;
    v165.visuals.custom_scope:set_callback(v298, true);
    l_sv_gravity_0.VISUALS.scope_overlay:set_callback(v298, true);
    v165.visuals.marker = l_v170_1.visuals_ingame:switch(" \v\f<xmark>\t \rHit Marker", false, "", function(v359)
        -- upvalues: v43 (ref)
        local v360 = {
            _3d = v359:switch("3D Marker", false, {
                [1] = v43.default
            }), 
            damage = v359:switch("Damage Marker", false, {
                [1] = v43.white
            }), 
            miss = v359:switch("Miss Marker", false, {
                [1] = v43.red
            }), 
            size = v359:slider("Size", 1, 10, 2, 1, "px"), 
            duration = v359:slider("Duration", 1, 10, 3, 1, "s")
        };
        local function v361()
            -- upvalues: v360 (ref)
            v360.size:visibility(v360._3d.value);
            v360.duration:visibility(v360._3d.value or v360.miss.value);
        end;
        v360._3d:set_callback(v361, true);
        v360.miss:set_callback(v361, true);
        return v360, true;
    end);
    v298 = function()
        -- upvalues: v165 (ref), l_sv_gravity_0 (ref)
        if v165.visuals.marker.value then
            l_sv_gravity_0.VISUALS.hitmarker:override(false);
        else
            l_sv_gravity_0.VISUALS.hitmarker:override();
        end;
    end;
    v165.visuals.marker:set_callback(v298, true);
    l_sv_gravity_0.VISUALS.hitmarker:set_callback(v298, true);
    v298 = nil;
    v165.misc = {};
    v165.misc.console = l_v170_1.misc_other:switch(" \v\f<game-console-handheld>\t\rConsole Color Modulation", false, {
        [1] = nil, 
        [2] = true, 
        [1] = color("000000AE")
    });
    v165.misc.unmute = l_v170_1.misc_other:switch("\v\f<volume-xmark>\t\rUnmute Silenced Players", false, "Automatically unmutes people that have an abuse communication mute.");
    v165.misc.taskbar = l_v170_1.misc_other:switch("\v\f<triangle-exclamation>\t\rTaskbar Notification", false, "Flashes your CS:GO icon on round-start if you're alt-tabbed.\n\n\a[attention]NOTE: \rThis function doesnt work on official servers due to potential VAC risks.");
    v165.misc.drop_nades = l_v170_1.misc_other:switch("\v\f<hand-holding-droplet>\t\rDrop Nades", false, "Allows you to instantly drop nades.\n\a[attention]\f<triangle-exclamation>  This function requires a binding!");
    v165.misc.fix_nades = l_v170_1.misc_other:switch("\v\f<face-confounded>\t\rFix Throw Nades", false, "Attempts to improve nade throwing.", function(v362)
        return {
            quick_switch = v362:switch("Disable Quick Switch")
        }, true;
    end);
    v165.misc.ladder = l_v170_1.misc_movement:switch("\v\f<water-ladder>\t\rFast Ladder Move", false, "Makes your movement a little faster on ladders.");
    v165.misc.no_fall = l_v170_1.misc_movement:switch("\v\f<person-falling>\t \rNo Fall Damage", false, "Attempts to prevent damage from falling when its possible.");
    v165.misc.nade_release = l_v170_1.misc_movement:switch("\v\f<bomb>\t\rGrenade Release", false, "", function(v363)
        return {
            disabler = v363:switch("Disable In Air", false), 
            Molly = v363:switch("Allow Molotov"), 
            Frag = v363:slider("HE Grenade", 1, 100, 50, 1, "hp"), 
            Flash = v363:slider("Flashbang", 1, 100, 50, 1, "%")
        }, true;
    end);
    v165.misc.clan = l_v170_1.misc_ingame:switch("\v\f<tags>\t\rClantag");
    v327 = function()
        -- upvalues: v165 (ref), l_sv_gravity_0 (ref)
        if v165.misc.clan.value then
            l_sv_gravity_0.MISC.clantag:override(false);
        else
            utils.execute_after(0.1, common.set_clan_tag, "");
            l_sv_gravity_0.MISC.clantag:override();
        end;
    end;
    v165.misc.clan:set_callback(v327, true);
    l_sv_gravity_0.MISC.clantag:set_callback(v327, true);
    v165.misc.shared = l_v170_1.misc_ingame:switch("\v\f<fingerprint>\t\rShared Logo", false, "This feature allows you to recognize other exscord users.\n\nEven if feature is disabled, other \vexscord \rusers with enabled feature can see your icon in scoreboard."):disabled(true);
    v327 = nil;
    v327 = {};
    if not v164.statistic then
        v164.statistic = {};
        v164.statistic["Scooby Doo"] = 0;
        v164.statistic["Lady Bug"] = 0;
    end;
    if not v164.statistic["Lady Bug"] then
        v164.statistic["Lady Bug"] = 0;
    end;
    v25.stats["Scooby Doo"] = v164.statistic["Scooby Doo"];
    v25.stats["Lady Bug"] = v164.statistic["Lady Bug"];
    l_v173_1:statistic();
    v93.Statistic.bullet_impact:set(function(v364, v365, v366)
        -- upvalues: v165 (ref), v164 (ref), v25 (ref), l_v173_1 (ref)
        if not v366 then
            return;
        else
            local v367 = entity.get(v364.userid, true);
            if v367 == nil or v367 == v365 then
                return;
            elseif v367:is_bot() or not v367:is_enemy() then
                return;
            else
                local v368 = v365:get_eye_position();
                local v369 = v367:get_eye_position();
                local v370 = vector(v364.x, v364.y, v364.z);
                if v368 == nil or v369 == nil or v370 == nil then
                    return;
                elseif v368:closest_ray_point(v369, v370):dist(v368) >= 60 then
                    return;
                else
                    local l_value_1 = v165.antiaim.type.value;
                    if l_value_1 == 2 then
                        v164.statistic["Scooby Doo"] = v164.statistic["Scooby Doo"] + 1;
                        v25.stats["Scooby Doo"] = v164.statistic["Scooby Doo"];
                    end;
                    if l_value_1 == 3 then
                        v164.statistic["Lady Bug"] = v164.statistic["Lady Bug"] + 1;
                        v25.stats["Lady Bug"] = v164.statistic["Lady Bug"];
                    end;
                    l_v173_1:statistic();
                    return;
                end;
            end;
        end;
    end);
end;
v166 = v0.setup(v165, true);
v167 = nil;
v167 = {
    hitgroup = {
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
    weapons = {
        knife = "Knifed", 
        hegrenade = "Naded", 
        inferno = "Burned"
    }, 
    push = function(v372)
        -- upvalues: v165 (ref), v45 (ref), v163 (ref)
        local l_value_2 = v165.rage.event_logs.draw.value;
        if #l_value_2 == 0 then
            return;
        else
            local v374 = v45.table.convert(l_value_2);
            if v374.Console then
                print_raw(v372);
            end;
            if v374.Events then
                v163:add(5, v372);
            end;
            return;
        end;
    end
};
v93.Logger.item_purchase:set(function(v375)
    -- upvalues: v165 (ref), v167 (ref), v45 (ref)
    if not v165.rage.event_logs.value or not v165.rage.event_logs.events:get("Purchases") then
        return;
    else
        local v376 = entity.get(v375.userid, true);
        if v376 == nil then
            return;
        elseif not v376:is_enemy() then
            return;
        else
            local l_weapon_0 = v375.weapon;
            if l_weapon_0 == "weapon_unknown" then
                return;
            else
                local v378 = {
                    "\vexscord \r~ ", 
                    nil, 
                    "bought ", 
                    [2] = string.format("\v%s\r ", v376:get_name()), 
                    string.format("\v%s", l_weapon_0:gsub("weapon_", ""):gsub("item_", ""))
                };
                v167.push(v45.string.format(table.concat(v378, ""), v165.rage.event_logs.accent.value));
                return;
            end;
        end;
    end;
end);
v93.Logger.player_hurt:set(function(v379, v380, v381)
    -- upvalues: v165 (ref), v167 (ref), v45 (ref)
    if not v165.rage.event_logs.value or not v165.rage.event_logs.events:get("Damage Dealt") or not v381 then
        return;
    else
        local v382 = entity.get(v379.userid, true);
        local v383 = entity.get(v379.attacker, true);
        if not v382 or v382 == v380 or not v383 or v383 ~= v380 then
            return;
        elseif not v167.weapons[v379.weapon] then
            return;
        else
            local v384 = {
                [1] = "\vexscord \r~ ", 
                [2] = nil, 
                [3] = nil, 
                [4] = "for ", 
                [2] = string.format("%s ", v167.weapons[v379.weapon]), 
                [3] = string.format("\v%s\r ", v382:get_name()), 
                [5] = string.format("\v%s \rdamage ", v379.dmg_health or 0), 
                [6] = v379.health ~= 0 and string.format("(\v%d \rhealth remaining)", v379.health or 0) or ""
            };
            v167.push(v45.string.format(table.concat(v384, ""), v165.rage.event_logs.accent.value));
            return;
        end;
    end;
end);
v93.Logger.aim_ack:set(function(v385, _)
    -- upvalues: v165 (ref), v167 (ref), v45 (ref)
    if not v165.rage.event_logs.value or not v165.rage.event_logs.events:get("Aimbot Shots") then
        return;
    else
        local l_target_0 = v385.target;
        if l_target_0 == nil then
            return;
        elseif not v385.state then
            local v388 = l_target_0.m_iHealth or 0;
            local v389 = {
                [1] = "\vexscord \r~ ", 
                [2] = nil, 
                [3] = nil, 
                [4] = "in the ", 
                [2] = v388 > 0 and "Hit " or "Killed ", 
                [3] = string.format("\v%s\r ", l_target_0:get_name()), 
                [5] = v385.hitgroup ~= v385.wanted_hitgroup and string.format("\v%s\r (aimed: \v%s\r) ", v167.hitgroup[v385.hitgroup], v167.hitgroup[v385.wanted_hitgroup]) or string.format("\v%s\r ", v167.hitgroup[v385.hitgroup]), 
                [6] = v388 > 0 and "for " or "", 
                [7] = v388 > 0 and (v385.damage ~= v385.wanted_damage and string.format("\v%d\r(\v%d\r) ", v385.damage, v385.wanted_damage) or string.format("\v%d\r ", v385.damage)) or "", 
                [8] = v388 > 0 and "damage " or "", 
                [9] = v385.backtrack ~= 0 and string.format("(history: \v%d\r) ", v385.backtrack) or "", 
                [10] = v388 > 0 and string.format("(\v%d \rhealth remaining)", v388) or ""
            };
            v167.push(v45.string.format(table.concat(v389, ""), v165.rage.event_logs.accent.value));
            return;
        else
            local v390 = {
                "\vexscord \r~ ", 
                "Missed at ", 
                nil, 
                nil, 
                "due to ", 
                [3] = string.format("\v%s\r's ", l_target_0:get_name()), 
                [4] = string.format("\v%s\r(\v%d%%\r) ", v167.hitgroup[v385.wanted_hitgroup], v385.hitchance or 0), 
                string.format("\v%s\r ", v385.state or "?"), 
                string.format("(dmg: \v%d\r | history: \v%d\r)", v385.wanted_damage or 0, v385.backtrack or 0)
            };
            v167.push(v45.string.format(table.concat(v390, ""), v165.rage.event_logs.miss.value));
            return;
        end;
    end;
end);
v168 = nil;
v168 = {
    default = "", 
    prefix = "exscord::", 
    export = function()
        -- upvalues: v166 (ref), v25 (ref), v1 (ref), v163 (ref), v45 (ref)
        local v391 = v166:save();
        if v391 == nil then
            return;
        else
            local v392 = {
                author = v25.user, 
                data = v391, 
                update = common.get_date("%A, %B %e, %Y %H:%M")
            };
            local l_status_5, l_result_5 = pcall(msgpack.pack, v392);
            if not l_status_5 then
                return;
            else
                local l_status_6, l_result_6 = pcall(v1.encode, l_result_5);
                if not l_status_6 then
                    return;
                else
                    v163:add(5, v45.string.format("\vexscord \r~ Copied configuration."));
                    return table.concat({
                        [1] = "exscord::", 
                        [2] = nil, 
                        [3] = "_exscord", 
                        [2] = l_result_6
                    });
                end;
            end;
        end;
    end
};
v168.load = function(v397)
    -- upvalues: v85 (ref), v163 (ref), v45 (ref), v168 (ref), v1 (ref), v166 (ref)
    if not v397 then
        v397 = v85.get();
    end;
    if v397 == nil or v397 == "" then
        return v163:add(5, v45.string.format("\vexscord \r~ Clipboard is empty."));
    elseif string.sub(v397, 1, #v168.prefix) ~= v168.prefix then
        return v163:add(5, v45.string.format("\vexscord \r~ Config is not compatible."));
    else
        v397 = string.sub(v397, #v168.prefix + 1);
        if string.find(v397, "_exscord") then
            v397 = string.gsub(v397, "_exscord", "");
        end;
        local l_status_7, l_result_7 = pcall(v1.decode, v397);
        if not l_status_7 then
            return v163:add(5, v45.string.format("\vexscord \r~ Unable to decode your confiugration."));
        else
            local l_status_8, l_result_8 = pcall(msgpack.unpack, l_result_7);
            if not l_status_8 then
                return v163:add(5, v45.string.format("\vexscord \r~ Unable to unpack your configuration."));
            else
                v166:load(l_result_8.data);
                return true;
            end;
        end;
    end;
end;
v165.configs.export:set_callback(function(_)
    -- upvalues: v168 (ref), v85 (ref)
    local v403 = v168.export();
    v85.set(v403);
end);
v165.configs.import:set_callback(function(_)
    -- upvalues: v168 (ref), v163 (ref), v45 (ref)
    if v168.load() then
        v163:add(5, v45.string.format("\vexscord \r~ Successfully loaded configuration."));
    end;
end);
v165.configs.default:set_callback(function(v405)
    -- upvalues: v163 (ref), v45 (ref), v168 (ref)
    v405:disabled(true);
    network.get("https://exscord.mishkat.cloud/config", {}, function(v406)
        -- upvalues: v163 (ref), v45 (ref), v168 (ref), v405 (ref)
        if v406 == nil or #v406 == 0 then
            return v163:add(5, v45.string.format("\vexscord \r~ Failed to fetch default config."));
        else
            if v168.load(v406) then
                v163:add(5, v45.string.format("\vexscord \r~ Successfully loaded default configuration."));
            end;
            v405:disabled(false);
            return;
        end;
    end);
end);
v169 = nil;
v169 = {
    reset = false, 
    replacements = {
        [267] = "Scout", 
        [242] = "Auto", 
        [261] = "Auto", 
        [233] = "AWP"
    }, 
    backups = function(v407)
        -- upvalues: l_sv_gravity_0 (ref)
        if v407.reset then
            l_sv_gravity_0.RAGE.hit_chance:override();
            l_sv_gravity_0.RAGE.auto_scope:override();
            v407.reset = false;
        end;
    end, 
    distance = function(_, v409, v410)
        local v411 = v409:get_origin();
        if v411 == nil then
            return;
        else
            local v412 = entity.get_threat();
            if v412 == nil then
                return;
            else
                local v413 = v412:get_origin();
                if v413 == nil then
                    return;
                elseif v410 == 351 then
                    return "Inf.";
                else
                    return v411:in_range(v413, v410);
                end;
            end;
        end;
    end
};
v93.Hitchance.createmove:set(function(_, v415, v416)
    -- upvalues: v165 (ref), v169 (ref), v45 (ref), v27 (ref), l_sv_gravity_0 (ref)
    if not v165.rage.hitchance.value or not v416 then
        return v169:backups();
    else
        local v417 = v415:get_player_weapon();
        if v417 == nil then
            return v169:backups();
        else
            local v418 = v169.replacements[v417:get_classid()];
            if v418 == nil then
                return v169:backups();
            elseif not v165.rage.hitchance["Enabled_" .. v418].value then
                return v169:backups();
            else
                local v419 = v169:distance(v415, v165.rage.hitchance["Distance_" .. v418].value);
                local v420 = v45.table.convert(v165.rage.hitchance["Conditions_" .. v418].value);
                if v420["In Air"] and not v27.on_ground then
                    l_sv_gravity_0.RAGE.hit_chance:override(v165.rage.hitchance["Air_" .. v418].value);
                elseif v420["No Scope"] and not v415.m_bIsScoped and v419 then
                    l_sv_gravity_0.RAGE.hit_chance:override(v165.rage.hitchance["No Scope_" .. v418].value);
                    l_sv_gravity_0.RAGE.auto_scope:override(false);
                else
                    return v169:backups();
                end;
                if v419 == "Inf." then
                    l_sv_gravity_0.RAGE.auto_scope:override();
                end;
                v169.reset = true;
                return;
            end;
        end;
    end;
end);
v170 = nil;
v170 = {
    tick = -1, 
    ents = {
        [1] = "CHostage", 
        [2] = "CPlantedC4"
    }, 
    scan_entities = function(_, v422, v423)
        for _, v425 in next, v423 do
            if v422:dist((v425:get_origin())) < 128 then
                return true;
            end;
        end;
        return false;
    end
};
v171 = v115.new("Legit AA", 8);
do
    local l_v171_3 = v171;
    v93["Legit AA"].createmove:set(function(v427, v428, v429)
        -- upvalues: v25 (ref), v165 (ref), v170 (ref), l_v171_3 (ref)
        v25.functions.legit_aa = false;
        if not v165.antiaim.legit_aa.value or not v429 then
            return;
        elseif not v427.in_use then
            v170.tick = -1;
            return;
        else
            local v430 = v428:get_player_weapon();
            if v430 == nil then
                return;
            elseif v430:get_classname() == "CC4" then
                return;
            else
                local v431 = v428:get_origin();
                for v432 = 1, #v170.ents do
                    if v170:scan_entities(v431, entity.get_entities(v170.ents[v432], false)) then
                        return;
                    end;
                end;
                if v170.tick == -1 then
                    v170.tick = globals.tickcount + 1;
                end;
                v427.in_use = v170.tick > globals.tickcount;
                l_v171_3:tick();
                l_v171_3.pitch = "Disabled";
                l_v171_3.body_yaw.main = true;
                l_v171_3.yaw.base = "Local View";
                l_v171_3.yaw.offset = 180;
                l_v171_3.freestanding = false;
                v25.functions.legit_aa = true;
                l_v171_3:run();
                return;
            end;
        end;
    end);
end;
v171 = nil;
v172 = {
    Left = -90, 
    Forward = 180, 
    Right = 90
};
v173 = v115.new("Manual Yaw", 6);
do
    local l_v172_1, l_v173_2 = v172, v173;
    v93["Manual Yaw"].createmove:set(function()
        -- upvalues: v165 (ref), l_v173_2 (ref), l_v172_1 (ref)
        if v165.antiaim.manual_yaw.value == "Disabled" then
            return;
        else
            l_v173_2:tick();
            l_v173_2.yaw.main = "Backward";
            l_v173_2.yaw.offset = l_v172_1[v165.antiaim.manual_yaw.value];
            l_v173_2.yaw.base = "Local View";
            if v165.antiaim.manual_yaw.disablers:get("Yaw Modifier") then
                l_v173_2.yaw_modifier.main = "Disabled";
                l_v173_2.body_yaw.options = "";
            end;
            if v165.antiaim.manual_yaw.disablers:get("Body Yaw") then
                l_v173_2.body_yaw.main = false;
            end;
            l_v173_2.freestanding = false;
            l_v173_2:run();
            return;
        end;
    end);
end;
v172 = nil;
v173 = v115.new("Freestand Disablers", 12);
do
    local l_v173_3 = v173;
    v93["Freestand Disablers"].createmove:set(function(_, _, v438)
        -- upvalues: v165 (ref), v27 (ref), l_sv_gravity_0 (ref), l_v173_3 (ref)
        if #v165.antiaim.fs_disablers.value == 0 or not v438 then
            return;
        else
            local v439 = false;
            for _, v441 in next, v165.antiaim.fs_disablers.value do
                if v441 == v27.condition then
                    v439 = true;
                    break;
                end;
            end;
            if not v439 or not l_sv_gravity_0.AA.angles.freestanding:get() then
                return;
            else
                l_v173_3:tick();
                l_v173_3.freestanding = false;
                l_v173_3:run();
                return;
            end;
        end;
    end);
end;
v173 = nil;
v174 = v115.new("Disable on Warmup", 10);
do
    local l_v174_2 = v174;
    v93["Warmup Disablers"].createmove:set(function(_, _, v445)
        -- upvalues: v165 (ref), l_v174_2 (ref)
        if not v165.antiaim.warmup_disablers.value or not v445 then
            return;
        else
            l_v174_2:tick();
            local v446 = entity.get_game_rules();
            if v446 == nil then
                return;
            else
                if v446.m_bWarmupPeriod then
                    l_v174_2.enabled = false;
                end;
                l_v174_2:run();
                return;
            end;
        end;
    end);
end;
v174 = nil;
v174 = {
    should_reset = false, 
    switch = -1, 
    manual_offsets = {
        Left = 90, 
        Forward = 180, 
        Right = -90
    }, 
    backups = function(v447)
        -- upvalues: l_sv_gravity_0 (ref)
        if v447.should_reset then
            l_sv_gravity_0.RAGE.double_tap.options:override();
            l_sv_gravity_0.RAGE.hide_shots.options:override();
            v447.should_reset = false;
        end;
    end, 
    triggers = {
        ["Double Tap"] = l_sv_gravity_0.RAGE.double_tap.main, 
        ["Hide Shots"] = l_sv_gravity_0.RAGE.hide_shots.main
    }
};
local v448 = v115.new("Defensive", 7);
do
    local l_v448_0 = v448;
    v93.Defensive.createmove:set(function(v450, _, v452)
        -- upvalues: v165 (ref), v174 (ref), v27 (ref), l_sv_gravity_0 (ref), v25 (ref), l_v448_0 (ref), v45 (ref)
        if not v165.antiaim.defensive.value or #v165.antiaim.defensive.conditions.value == 0 or not v452 then
            return v174:backups();
        else
            local v453 = false;
            for _, v455 in next, v165.antiaim.defensive.triggers.value do
                if v174.triggers[v455] and v174.triggers[v455]:get() then
                    v453 = true;
                    break;
                end;
            end;
            if not v453 or rage.exploit:get() ~= 1 then
                return v174:backups();
            else
                local v456 = false;
                local v457 = false;
                for _, v459 in next, v165.antiaim.defensive.conditions.value do
                    if v459 == "On Peek" then
                        v456 = true;
                        v457 = true;
                        break;
                    elseif v459 == v27.condition then
                        v456 = true;
                        break;
                    end;
                end;
                if not v456 then
                    return v174:backups();
                else
                    if v450.choked_commands == 0 then
                        v174.switch = v174.switch * -1;
                    end;
                    local l_value_3 = v165.antiaim.manual_yaw.value;
                    if v165.antiaim.defensive.disablers:get(1) and l_value_3 ~= "Disabled" or v165.antiaim.defensive.disablers:get(2) and l_sv_gravity_0.AA.angles.freestanding:get() or v25.functions.edge_yaw then
                        return v174:backups();
                    else
                        l_v448_0:tick();
                        local l_value_4 = v165.antiaim.defensive.pitch.value;
                        local l_x_0 = v450.view_angles.x;
                        if l_value_4 == "Zero" then
                            l_x_0 = 0;
                        elseif l_value_4 == "Up" then
                            l_x_0 = -89;
                        elseif l_value_4 == "Half Up" then
                            l_x_0 = utils.random_int(-45, -60);
                        elseif l_value_4 == "Half Down" then
                            l_x_0 = utils.random_int(45, 60);
                        elseif l_value_4 == "Random" then
                            l_x_0 = utils.random_int(-89, 89);
                        end;
                        local l_value_5 = v165.antiaim.defensive.yaw.value;
                        local l_y_0 = v450.view_angles.y;
                        if l_value_5 == "Spin" then
                            l_y_0 = v45.normalize(-180 + globals.tickcount % 9 * 40 + utils.random_float(-30, 30));
                        elseif l_value_5 == "Sideways" then
                            l_y_0 = v45.normalize(v174.switch * 90);
                        elseif l_value_5 == "Forward" then
                            l_y_0 = v45.normalize(180 * v27.jitter);
                        elseif l_value_5 == "Random" then
                            l_y_0 = v45.normalize(utils.random_int(-180, 180));
                        end;
                        if not v457 then
                            l_sv_gravity_0.RAGE.double_tap.options:override("Always On");
                            l_sv_gravity_0.RAGE.hide_shots.options:override("Break LC");
                        else
                            v174:backups();
                        end;
                        if v165.antiaim.defensive.antiaim.value then
                            l_v448_0.yaw.hidden = true;
                        end;
                        if l_value_4 ~= "Down" then
                            rage.antiaim:override_hidden_pitch(l_x_0);
                        end;
                        local v465 = rage.antiaim:get_target(true);
                        if l_value_5 ~= "Default" then
                            if l_value_3 ~= "Disabled" then
                                rage.antiaim:override_hidden_pitch(0 + utils.random_int(-5, 10));
                                rage.antiaim:override_hidden_yaw_offset(180 + utils.random_int(0, 10));
                            elseif v465 ~= nil and l_sv_gravity_0.AA.angles.freestanding:get() then
                                l_v448_0.freestanding = false;
                                rage.antiaim:override_hidden_pitch(0);
                                rage.antiaim:override_hidden_yaw_offset(180);
                                l_v448_0.yaw.main = "Static";
                                l_v448_0.yaw.base = "Local View";
                                l_v448_0.yaw.offset = v465;
                            elseif v25.functions.safe_head and v165.antiaim.defensive.safe.value then
                                rage.antiaim:override_hidden_pitch(0);
                                rage.antiaim:override_hidden_yaw_offset(-180);
                            else
                                rage.antiaim:override_hidden_yaw_offset(l_y_0);
                            end;
                        end;
                        l_v448_0:run();
                        v174.should_reset = true;
                        return;
                    end;
                end;
            end;
        end;
    end);
end;
v448 = nil;
local function v480(v466, v467)
    -- upvalues: v45 (ref)
    local v468 = {};
    local v469 = nil;
    local v470 = v466:get_eye_position() + vector(0, 0, 10);
    for v471 = 18, 360, 18 do
        v471 = v45.normalize(v471);
        local v472 = v470 + vector():angles(0, v471) * 96;
        local v473 = utils.trace_line(v470, v472, v466, 33570827);
        local l_entity_0 = v473.entity;
        if l_entity_0 and l_entity_0:get_classname() == "CWorld" and v473.fraction < 0.35 then
            v468[#v468 + 1] = {
                vecTraceEnd = v473.end_pos, 
                flYaw = v471
            };
        end;
    end;
    table.sort(v468, function(v475, v476)
        return v475.flYaw < v476.flYaw;
    end);
    if #v468 >= 2 then
        v469 = (v470 - v468[1].vecTraceEnd:lerp(v468[#v468].vecTraceEnd, 0.5)):angles();
    end;
    if v469 then
        local l_y_1 = v467.view_angles.y;
        local l_y_2 = v469.y;
        local v479 = v45.normalize(l_y_2 - l_y_1);
        if math.abs(v479) < 90 then
            v479 = 0;
            l_y_1 = v45.normalize(l_y_2 + 180);
        end;
        return v45.normalize(-l_y_1 + l_y_2 + v479 + 180);
    else
        return;
    end;
end;
local v481 = v115.new("Edge Yaw", 5);
do
    local l_v480_0, l_v481_0 = v480, v481;
    v93["Edge Yaw"].createmove:set(function(v484, v485, v486)
        -- upvalues: v25 (ref), v165 (ref), l_v481_0 (ref), l_v480_0 (ref), l_sv_gravity_0 (ref)
        v25.functions.edge_yaw = false;
        if not v165.antiaim.edge_yaw.value or not v486 then
            return;
        else
            l_v481_0:tick();
            local v487 = l_v480_0(v485, v484);
            if v487 and not v25.functions.legit_aa then
                if v165.antiaim.edge_yaw.fakeduck.value and not l_sv_gravity_0.AA.other.fake_duck:get() then
                    return;
                else
                    l_v481_0.yaw.main = "Backward";
                    l_v481_0.yaw.base = "Local View";
                    l_v481_0.yaw.offset = v487;
                    if v165.antiaim.edge_yaw.disablers.value then
                        l_v481_0.yaw_modifier.main = "Disabled";
                        l_v481_0.body_yaw.options = "";
                    end;
                    v25.functions.edge_yaw = true;
                end;
            end;
            l_v481_0:run();
            return;
        end;
    end);
end;
v480 = nil;
v480 = {
    weapon = false, 
    is_air_weapon = false, 
    on_condition = false, 
    presets = {
        Standing = {
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
        Crouching = {
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
        ["Slow Walking"] = {
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
        ["Air + Crouch"] = {
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
                left_limit = 60, 
                offset = 0, 
                inverter = true, 
                right_limit = 60
            }, 
            [2] = {
                left_limit = 60, 
                offset = 0, 
                inverter = true, 
                right_limit = 60
            }
        }, 
        [268] = {
            [3] = {
                left_limit = 60, 
                offset = 23, 
                inverter = false, 
                right_limit = 30
            }, 
            [2] = {
                left_limit = 20, 
                offset = 17, 
                inverter = false, 
                right_limit = 60
            }
        }
    }
};
v481 = v115.new("Safe Head", 15);
do
    local l_v481_1 = v481;
    v93["Safe Head"].createmove:set(function(_, v490, _)
        -- upvalues: v25 (ref), v480 (ref), v165 (ref), v27 (ref), v45 (ref), l_v481_1 (ref)
        v25.functions.safe_head = false;
        v480.weapon = false;
        if #v165.antiaim.safe.value == 0 or v25.functions.legit_aa or v25.functions.edge_yaw or v165.antiaim.manual_yaw.value ~= "Disabled" then
            return;
        else
            v480.on_condition = false;
            v480.is_air_weapon = false;
            v480.class_id = 0;
            local l_condition_0 = v27.condition;
            if l_condition_0 == "Air" or l_condition_0 == "Air + Crouch" and not v480.on_condition then
                local v493 = v490:get_player_weapon();
                if v493 then
                    local v494 = v493:get_classid();
                    v480.class_id = v494;
                    if v494 == 107 then
                        v480.on_condition = v165.antiaim.safe:get(5);
                    elseif v494 == 268 then
                        v480.on_condition = v165.antiaim.safe:get(6);
                    end;
                    v480.is_air_weapon = v480.on_condition;
                end;
            end;
            if not v480.on_condition then
                for _, v496 in next, v165.antiaim.safe.value do
                    if v27.condition == v496 then
                        v480.on_condition = true;
                        break;
                    end;
                end;
            end;
            if not v480.on_condition then
                return;
            else
                v25.functions.safe_head = v480.is_air_weapon;
                if not v25.functions.safe_head then
                    local v497 = v490:get_origin();
                    local v498 = entity.get_threat();
                    local _ = 0;
                    if v498 and v498:is_alive() then
                        local v500 = v498:get_origin();
                        if (v480.is_air_weapon and v497.z - 1 or v500.z + 5) < v497.z then
                            local v501 = utils.trace_bullet(v498, v45.extrapolate(v498, 5, v498:get_eye_position()), v490:get_hitbox_position(0) + vector(0, 0, 6));
                            v25.functions.safe_head = v501 > 0;
                        end;
                    end;
                end;
                v480.weapon = v480.is_air_weapon;
                l_v481_1:tick();
                if v25.functions.safe_head then
                    local v502 = v480.is_air_weapon and v480.presets[v480.class_id] or v480.presets[v27.condition];
                    if not v502 then
                        if v480.is_air_weapon then
                            v502 = v480.presets.Other;
                        else
                            return;
                        end;
                    end;
                    local v503 = v502[v490.m_iTeamNum];
                    if not v503 then
                        return;
                    else
                        l_v481_1.body_yaw.main = true;
                        l_v481_1.yaw.base = "At Target";
                        l_v481_1.yaw_modifier.main = "Disabled";
                        l_v481_1.body_yaw.options = "";
                        l_v481_1.yaw.main = "Backward";
                        l_v481_1.yaw.offset = v503.offset;
                        l_v481_1.body_yaw.left_limit = v503.left_limit;
                        l_v481_1.body_yaw.right_limit = v503.right_limit;
                        rage.antiaim:inverter(v503.inverter);
                    end;
                end;
                l_v481_1:run();
                return;
            end;
        end;
    end);
end;
v481 = nil;
v481 = {
    step = 1, 
    val = 0, 
    current_tick = -1
};
local v504 = v115.new("Conditional AA", 1);
do
    local l_v504_0 = v504;
    v93["Anti Aims"].createmove:set(function(v506, _, v508)
        -- upvalues: v165 (ref), v27 (ref), v25 (ref), v481 (ref), v45 (ref), l_v504_0 (ref)
        if v165.antiaim.type.value ~= 4 or not v508 then
            return;
        else
            local l_condition_1 = v27.condition;
            if not v165.builder[l_condition_1].enabled.value then
                l_condition_1 = "Global";
            end;
            local v510 = v165.builder[l_condition_1];
            local l_value_6 = v510.yaw.offset.value;
            local l_value_7 = v510.yaw.type_.value;
            local l_value_8 = v510.yaw_modifier.value;
            local l_value_9 = v510.yaw_modifier.Offset_1.value;
            local l_value_10 = v510.yaw_modifier.randomize.value;
            if l_value_7 == "Left / Right" then
                l_value_6 = rage.antiaim:inverter() and v510.yaw.left_offset.value or v510.yaw.right_offset.value;
            end;
            if l_value_7 == "Delayed Switch" and not v25.functions.safe_head then
                local v516 = false;
                local v517 = to_ticks(globals.realtime) - v481.current_tick;
                v516 = v517 * 2 >= v510.yaw.delay.value;
                if v510.yaw.delay.value <= v517 then
                    v481.current_tick = to_ticks(globals.realtime);
                end;
                if v506.choked_commands == 0 or rage.exploit:get() < 1 then
                    v481.val = v516 and v510.yaw.left_offset.value or v510.yaw.right_offset.value;
                end;
                rage.antiaim:inverter(v516);
                l_value_6 = v481.val;
            end;
            if l_value_10 ~= 0 then
                if v27.jitter_count % 2 == 0 or v481.modifier_random == nil then
                    v481.modifier_random = utils.random_int(0, (l_value_9 > 0 and 1 or -1) * l_value_10);
                end;
                l_value_9 = v45.normalize(l_value_9 + v481.modifier_random);
            end;
            if l_value_8 == "3-Way" or l_value_8 == "5-Way" then
                if v506.choked_commands == 0 then
                    v481.step = v481.step + 1;
                    if v481.step > (l_value_8 == "3-Way" and 3 or 5) then
                        v481.step = 1;
                    end;
                end;
                if v510.yaw_modifier.custom_way.value then
                    l_value_6 = v510.yaw_modifier["Offset_" .. v481.step].value;
                    l_value_8 = "Disabled";
                    l_value_9 = 0;
                end;
            end;
            l_v504_0:tick();
            l_v504_0.pitch = v25.functions.legit_aa and "Disabled" or v510.pitch.value;
            l_v504_0.yaw.main = v510.yaw.value;
            l_v504_0.yaw.base = v510.yaw.base.value;
            l_v504_0.yaw.offset = l_value_6;
            l_v504_0.yaw_modifier.main = l_value_8;
            l_v504_0.yaw_modifier.offset = l_value_9;
            l_v504_0.body_yaw.main = v510.body_yaw.value;
            l_v504_0.body_yaw.inverter = v510.body_yaw.inverter.value;
            l_v504_0.body_yaw.left_limit = v510.body_yaw.left_limit.value;
            l_v504_0.body_yaw.right_limit = v510.body_yaw.right_limit.value;
            l_v504_0.body_yaw.options = v510.body_yaw.options.value;
            l_v504_0.body_yaw.freestanding = v510.body_yaw.freestanding.value;
            l_v504_0.extended_angles.main = v510.extended_angles.value;
            l_v504_0.extended_angles.pitch = v510.extended_angles.pitch.value;
            l_v504_0.extended_angles.roll = v510.extended_angles.roll.value;
            l_v504_0:run();
            return;
        end;
    end);
end;
v504 = nil;
v504 = {
    step = 1, 
    val = 0, 
    current_tick = -1, 
    copy_preset = function(_)
        -- upvalues: v166 (ref), v1 (ref), v85 (ref)
        local v519 = v166:save("builder");
        local l_status_9, l_result_9 = pcall(json.stringify, v519);
        if not l_status_9 then
            return;
        else
            local l_status_10, l_result_10 = pcall(v1.encode, l_result_9);
            if not l_status_10 then
                return;
            else
                v85.set(l_result_10);
                return l_result_10;
            end;
        end;
    end, 
    parse_preset = function(_, v525)
        -- upvalues: v1 (ref)
        if type(v525) ~= "string" then
            return;
        else
            local l_status_11, l_result_11 = pcall(v1.decode, v525);
            if not l_status_11 then
                return;
            else
                local l_status_12, l_result_12 = pcall(json.parse, l_result_11);
                if not l_status_12 then
                    return;
                else
                    return l_result_12.builder;
                end;
            end;
        end;
    end, 
    parse_menu = function(_)
        -- upvalues: v85 (ref), v1 (ref), v166 (ref)
        local v531 = v85.get();
        local l_status_13, l_result_13 = pcall(v1.decode, v531);
        if not l_status_13 then
            return;
        else
            local l_status_14, l_result_14 = pcall(json.parse, l_result_13);
            if not l_status_14 then
                return;
            else
                v166:load(l_result_14, {
                    [1] = "builder"
                });
                return;
            end;
        end;
    end
};
v165.antiaim.export:set_callback(v504.copy_preset);
v165.antiaim.import:set_callback(v504.parse_menu);
v504["2"] = v504:parse_preset("eyJidWlsZGVyIjp7IkFpciI6eyJib2R5X3lhdyI6eyJfUyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjp0cnVlLCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMi4wLCJsZWZ0X29mZnNldCI6LTI2LjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjIzLjAsInR5cGVfIjoiRGVsYXllZCBTd2l0Y2gifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjowLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiRGlzYWJsZWQiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjowLjB9fSwiQWlyICsgQ3JvdWNoIjp7ImJvZHlfeWF3Ijp7Il9TIjp0cnVlLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sImVuYWJsZWQiOnRydWUsImV4dGVuZGVkX2FuZ2xlcyI6eyJfUyI6ZmFsc2UsInBpdGNoIjo4OS4wLCJyb2xsIjo0NS4wfSwicGl0Y2giOiJEb3duIiwieWF3Ijp7Il9TIjoiQmFja3dhcmQiLCJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjguMCwibGVmdF9vZmZzZXQiOjAuMCwib2Zmc2V0IjowLjAsInJpZ2h0X29mZnNldCI6MjQuMCwidHlwZV8iOiJMZWZ0IC8gUmlnaHQifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjotMzcuMCwiT2Zmc2V0XzIiOjAuMCwiT2Zmc2V0XzMiOjAuMCwiT2Zmc2V0XzQiOjAuMCwiT2Zmc2V0XzUiOjAuMCwiX1MiOiJDZW50ZXIiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjoxMC4wfX0sIkNyb3VjaGluZyI6eyJib2R5X3lhdyI6eyJfUyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjp0cnVlLCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsInJpZ2h0X29mZnNldCI6NDAuMCwidHlwZV8iOiJMZWZ0IC8gUmlnaHQifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjowLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiRGlzYWJsZWQiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjowLjB9fSwiRmFrZSBMYWciOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6OC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0IjowLjAsInR5cGVfIjoiMTgwIn0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6MC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IkRpc2FibGVkIiwiY3VzdG9tX3dheSI6ZmFsc2UsInJhbmRvbWl6ZSI6MC4wfX0sIkdsb2JhbCI6eyJib2R5X3lhdyI6eyJfUyI6ZmFsc2UsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRpc2FibGVkIiwieWF3Ijp7Il9TIjoiRGlzYWJsZWQiLCJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjAuMCwidHlwZV8iOiIxODAifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjowLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiRGlzYWJsZWQiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjowLjB9fSwiSW4gVXNlIjp7ImJvZHlfeWF3Ijp7Il9TIjpmYWxzZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjpmYWxzZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRpc2FibGVkIiwieWF3Ijp7Il9TIjoiRGlzYWJsZWQiLCJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjAuMCwidHlwZV8iOiIxODAifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjowLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiRGlzYWJsZWQiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjowLjB9fSwiTW92aW5nIjp7ImJvZHlfeWF3Ijp7Il9TIjp0cnVlLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sImVuYWJsZWQiOnRydWUsImV4dGVuZGVkX2FuZ2xlcyI6eyJfUyI6ZmFsc2UsInBpdGNoIjo4OS4wLCJyb2xsIjo0NS4wfSwicGl0Y2giOiJEb3duIiwieWF3Ijp7Il9TIjoiQmFja3dhcmQiLCJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjguMCwibGVmdF9vZmZzZXQiOi0xMC4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0IjoxMC4wLCJ0eXBlXyI6IkxlZnQgLyBSaWdodCJ9LCJ5YXdfbW9kaWZpZXIiOnsiT2Zmc2V0XzEiOi01Ni4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IkNlbnRlciIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjAuMH19LCJTbG93IFdhbGtpbmciOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6OC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjEwLjAsInR5cGVfIjoiTGVmdCAvIFJpZ2h0In0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6LTU1LjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiQ2VudGVyIiwiY3VzdG9tX3dheSI6ZmFsc2UsInJhbmRvbWl6ZSI6MTMuMH19LCJTdGFuZGluZyI6eyJib2R5X3lhdyI6eyJfUyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjp0cnVlLCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjotMy4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0IjoxNy4wLCJ0eXBlXyI6IkxlZnQgLyBSaWdodCJ9LCJ5YXdfbW9kaWZpZXIiOnsiT2Zmc2V0XzEiOi0xNy4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IkNlbnRlciIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjAuMH19fX0=");
v504["3"] = v504:parse_preset("eyJidWlsZGVyIjp7IkFpciI6eyJib2R5X3lhdyI6eyJfUyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjp0cnVlLCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsInJpZ2h0X29mZnNldCI6MjkuMCwidHlwZV8iOiJMZWZ0IC8gUmlnaHQifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjoxMC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IjMtV2F5IiwiY3VzdG9tX3dheSI6ZmFsc2UsInJhbmRvbWl6ZSI6MjUuMH19LCJBaXIgKyBDcm91Y2giOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6OC4wLCJsZWZ0X29mZnNldCI6LTIzLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjI5LjAsInR5cGVfIjoiTGVmdCAvIFJpZ2h0In0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6MTAuMCwiT2Zmc2V0XzIiOjAuMCwiT2Zmc2V0XzMiOjAuMCwiT2Zmc2V0XzQiOjAuMCwiT2Zmc2V0XzUiOjAuMCwiX1MiOiIzLVdheSIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjI1LjB9fSwiQ3JvdWNoaW5nIjp7ImJvZHlfeWF3Ijp7Il9TIjp0cnVlLCJmcmVlc3RhbmRpbmciOiJPZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnRfbGltaXQiOjYwLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMH0sImVuYWJsZWQiOnRydWUsImV4dGVuZGVkX2FuZ2xlcyI6eyJfUyI6ZmFsc2UsInBpdGNoIjo4OS4wLCJyb2xsIjo0NS4wfSwicGl0Y2giOiJEb3duIiwieWF3Ijp7Il9TIjoiQmFja3dhcmQiLCJiYXNlIjoiQXQgVGFyZ2V0IiwiZGVsYXkiOjguMCwibGVmdF9vZmZzZXQiOi0yMi4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ0eXBlXyI6IkxlZnQgLyBSaWdodCJ9LCJ5YXdfbW9kaWZpZXIiOnsiT2Zmc2V0XzEiOjEwLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiNS1XYXkiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjoyNS4wfX0sIkZha2UgTGFnIjp7ImJvZHlfeWF3Ijp7Il9TIjpmYWxzZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjpmYWxzZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRpc2FibGVkIiwieWF3Ijp7Il9TIjoiRGlzYWJsZWQiLCJiYXNlIjoiTG9jYWwgVmlldyIsImRlbGF5Ijo4LjAsImxlZnRfb2Zmc2V0IjowLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjAuMCwidHlwZV8iOiIxODAifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjowLjAsIk9mZnNldF8yIjowLjAsIk9mZnNldF8zIjowLjAsIk9mZnNldF80IjowLjAsIk9mZnNldF81IjowLjAsIl9TIjoiRGlzYWJsZWQiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjowLjB9fSwiR2xvYmFsIjp7ImJvZHlfeWF3Ijp7Il9TIjpmYWxzZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkxvY2FsIFZpZXciLCJkZWxheSI6OC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0IjowLjAsInR5cGVfIjoiMTgwIn0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6MC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IkNlbnRlciIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjAuMH19LCJJbiBVc2UiOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJMb2NhbCBWaWV3IiwiZGVsYXkiOjguMCwibGVmdF9vZmZzZXQiOjAuMCwib2Zmc2V0IjowLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ0eXBlXyI6IkxlZnQgLyBSaWdodCJ9LCJ5YXdfbW9kaWZpZXIiOnsiT2Zmc2V0XzEiOjAuMCwiT2Zmc2V0XzIiOjAuMCwiT2Zmc2V0XzMiOjAuMCwiT2Zmc2V0XzQiOjAuMCwiT2Zmc2V0XzUiOjAuMCwiX1MiOiJDZW50ZXIiLCJjdXN0b21fd2F5IjpmYWxzZSwicmFuZG9taXplIjozMC4wfX0sIk1vdmluZyI6eyJib2R5X3lhdyI6eyJfUyI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjoiT2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjB9LCJlbmFibGVkIjp0cnVlLCJleHRlbmRlZF9hbmdsZXMiOnsiX1MiOmZhbHNlLCJwaXRjaCI6ODkuMCwicm9sbCI6NDUuMH0sInBpdGNoIjoiRG93biIsInlhdyI6eyJfUyI6IkJhY2t3YXJkIiwiYmFzZSI6IkF0IFRhcmdldCIsImRlbGF5IjoxMy4wLCJsZWZ0X29mZnNldCI6LTMzLjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjM0LjAsInR5cGVfIjoiRGVsYXllZCBTd2l0Y2gifSwieWF3X21vZGlmaWVyIjp7Ik9mZnNldF8xIjoxMC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6IjUtV2F5IiwiY3VzdG9tX3dheSI6ZmFsc2UsInJhbmRvbWl6ZSI6MjUuMH19LCJTbG93IFdhbGtpbmciOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6MTMuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0MS4wLCJ0eXBlXyI6IkRlbGF5ZWQgU3dpdGNoIn0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6MC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6Ik9mZnNldCIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjEwLjB9fSwiU3RhbmRpbmciOnsiYm9keV95YXciOnsiX1MiOnRydWUsImZyZWVzdGFuZGluZyI6Ik9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdF9saW1pdCI6NjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wfSwiZW5hYmxlZCI6dHJ1ZSwiZXh0ZW5kZWRfYW5nbGVzIjp7Il9TIjpmYWxzZSwicGl0Y2giOjg5LjAsInJvbGwiOjQ1LjB9LCJwaXRjaCI6IkRvd24iLCJ5YXciOnsiX1MiOiJCYWNrd2FyZCIsImJhc2UiOiJBdCBUYXJnZXQiLCJkZWxheSI6OC4wLCJsZWZ0X29mZnNldCI6LTI4LjAsIm9mZnNldCI6MC4wLCJyaWdodF9vZmZzZXQiOjM0LjAsInR5cGVfIjoiTGVmdCAvIFJpZ2h0In0sInlhd19tb2RpZmllciI6eyJPZmZzZXRfMSI6MC4wLCJPZmZzZXRfMiI6MC4wLCJPZmZzZXRfMyI6MC4wLCJPZmZzZXRfNCI6MC4wLCJPZmZzZXRfNSI6MC4wLCJfUyI6Ik9mZnNldCIsImN1c3RvbV93YXkiOmZhbHNlLCJyYW5kb21pemUiOjUuMH19fX0=");
local v536 = v115.new("Preset", 2);
local v537 = v165.antiaim.type:list();
do
    local l_v536_0 = v536;
    v93.Presets.createmove:set(function(v539, v540, v541)
        -- upvalues: v165 (ref), v25 (ref), v504 (ref), v115 (ref), v27 (ref), v45 (ref), l_v536_0 (ref)
        if v165.antiaim.type.value ~= 2 and v165.antiaim.type.value ~= 3 or v25.ui_alpha ~= 0 or not v541 then
            return;
        else
            local v542 = v504[tostring(v165.antiaim.type.value)];
            local v543 = v115.condition(v540, v542["Fake Lag"].enabled);
            if not v542[v543].enabled then
                v543 = "Global";
            end;
            local v544 = v542[v543];
            local l_offset_0 = v544.yaw.offset;
            local l_type__0 = v544.yaw.type_;
            local l__S_0 = v544.yaw_modifier._S;
            local l_Offset_1_0 = v544.yaw_modifier.Offset_1;
            local l_randomize_0 = v544.yaw_modifier.randomize;
            if l_type__0 == "Left / Right" then
                l_offset_0 = rage.antiaim:inverter() and v544.yaw.left_offset or v544.yaw.right_offset;
            end;
            if l_type__0 == "Delayed Switch" and not v25.functions.safe_head then
                local v550 = false;
                local v551 = to_ticks(globals.realtime) - v504.current_tick;
                v550 = v551 * 2 >= v544.yaw.delay;
                if v544.yaw.delay <= v551 then
                    v504.current_tick = to_ticks(globals.realtime);
                end;
                if v539.choked_commands == 0 or rage.exploit:get() < 1 then
                    v504.val = v550 and v544.yaw.left_offset or v544.yaw.right_offset;
                end;
                rage.antiaim:inverter(v550);
                l_offset_0 = v504.val;
            end;
            if l_randomize_0 ~= 0 then
                if v27.jitter_count % 2 == 0 or v504.modifier_random == nil then
                    v504.modifier_random = utils.random_int(0, (l_Offset_1_0 > 0 and 1 or -1) * l_randomize_0);
                end;
                l_Offset_1_0 = v45.normalize(l_Offset_1_0 + v504.modifier_random);
            end;
            if l__S_0 == "3-Way" or l__S_0 == "5-Way" then
                if v539.choked_commands == 0 then
                    v504.step = v504.step + 1;
                    if v504.step > (l__S_0 == "3-Way" and 3 or 5) then
                        v504.step = 1;
                    end;
                end;
                if v544.yaw_modifier.custom_way then
                    l_offset_0 = v544.yaw_modifier["Offset_" .. v504.step].value;
                    l__S_0 = "Disabled";
                    l_Offset_1_0 = 0;
                end;
            end;
            l_v536_0:tick();
            l_v536_0.pitch = v25.functions.legit_aa and "Disabled" or v544.pitch;
            l_v536_0.yaw.main = v544.yaw._S;
            l_v536_0.yaw.base = v544.yaw.base;
            l_v536_0.yaw.offset = v45.normalize(l_offset_0);
            l_v536_0.yaw_modifier.main = l__S_0;
            l_v536_0.yaw_modifier.offset = l_Offset_1_0;
            l_v536_0.body_yaw.main = v544.body_yaw._S;
            l_v536_0.body_yaw.inverter = v544.body_yaw.inverter;
            l_v536_0.body_yaw.left_limit = v544.body_yaw.left_limit;
            l_v536_0.body_yaw.right_limit = v544.body_yaw.right_limit;
            l_v536_0.body_yaw.options = v544.body_yaw.options;
            l_v536_0.body_yaw.freestanding = v544.body_yaw.freestanding;
            l_v536_0.extended_angles.main = v544.extended_angles._S;
            l_v536_0.extended_angles.pitch = v544.extended_angles.pitch;
            l_v536_0.extended_angles.roll = v544.extended_angles.roll;
            l_v536_0:run();
            return;
        end;
    end);
end;
v536 = nil;
v536 = {
    is_any_active = false, 
    data = {}
};
v536.get = function(_, v553)
    -- upvalues: v536 (ref)
    local v554 = v536.data[v553];
    return v554 ~= nil and v554.active;
end;
v93.Hotkeys.render:set(function()
    -- upvalues: v536 (ref)
    v536.data = {};
    v536.is_any_active = false;
    for _, v556 in next, ui.get_binds() do
        if v556.active then
            v536.is_any_active = true;
        end;
        v536.data[v556.name] = v556;
    end;
end);
v537 = nil;
v537 = {
    alpha = v84:new(), 
    allign = v84:new(0, v37), 
    width = v84:new(0, v32), 
    blind = v84:new(), 
    shadow = v84:new()
};
local v557 = {
    [1] = {
        text = "DT", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.RAGE.double_tap.main:get();
        end, 
        color = function()
            -- upvalues: v43 (ref)
            return v43.red:lerp(v43.white, rage.exploit:get());
        end, 
        animation = v84:new()
    }, 
    [2] = {
        text = "OS", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.RAGE.hide_shots.main:get();
        end, 
        animation = v84:new()
    }, 
    [3] = {
        text = "FS", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.AA.angles.freestanding:get();
        end, 
        animation = v84:new()
    }, 
    [4] = {
        text = "DMG", 
        status = function()
            -- upvalues: v536 (ref)
            return v536:get("Min. Damage");
        end, 
        animation = v84:new()
    }, 
    [5] = {
        text = "HC", 
        status = function()
            -- upvalues: v536 (ref)
            return v536:get("Hit Chance");
        end, 
        animation = v84:new()
    }, 
    [6] = {
        text = "BAIM", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.RAGE.body_aim:get() == "Force";
        end, 
        animation = v84:new()
    }, 
    [7] = {
        text = "SAFE", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.RAGE.safe_point:get() == "Force";
        end, 
        animation = v84:new()
    }, 
    [8] = {
        text = "DUCK", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.AA.other.fake_duck:get();
        end, 
        animation = v84:new()
    }, 
    [9] = {
        text = "PING", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref)
            return l_sv_gravity_0.MISC.fake_latency:get() ~= 0;
        end, 
        animation = v84:new()
    }, 
    [10] = {
        text = "DA", 
        status = function()
            -- upvalues: l_sv_gravity_0 (ref), v165 (ref)
            return l_sv_gravity_0.RAGE.dormant:get() or v165.rage.dormant.value;
        end, 
        color = function()
            return color(255, 127);
        end, 
        animation = v84:new()
    }
};
local l_Pixel_0 = v44.Pixel;
do
    local l_v557_0, l_l_Pixel_0_0 = v557, l_Pixel_0;
    v93.Indicators.render:set(function(v561, v562)
        -- upvalues: v537 (ref), v165 (ref), v25 (ref), v43 (ref), l_l_Pixel_0_0 (ref), v27 (ref), l_v557_0 (ref)
        local v563 = v537.alpha(0.2, v165.visuals.indicators.value and v562);
        if v563 <= 0 then
            v25.blind_alpha = 1;
            return;
        else
            local v564 = math.max(0.2, math.abs(math.sin(globals.realtime * 2.5)));
            local v565 = v537.allign(0.1, not v561 or not v561.m_bIsScoped or false);
            local v566 = 1;
            local v567 = v561 and v561:get_player_weapon() or false;
            if v567 then
                local v568 = v567:get_weapon_info();
                v566 = v537.blind(0.1, v568.weapon_type == 9 and 0.3 or 1);
                v25.blind_alpha = v566;
            end;
            v567 = v165.visuals.indicators.color.value;
            local v569 = v43.white:alpha_modulate(v563 * v566, true);
            local v570 = v567:alpha_modulate(255 * v563 * v566);
            local v571 = v25.screen:clone();
            v571.x = v571.x * 0.5 + (1 - v565);
            v571.y = v571.y * 0.5 + 20;
            local v572 = string.format("%s \a%s%s", "EXSCORD", v570:alpha_modulate(v564, true):to_hex(), v25.branch:upper());
            local v573 = render.measure_text(l_l_Pixel_0_0, "s", v572);
            local v574 = v571:clone();
            v574.x = v574.x - v573.x * 0.5 * v565;
            local v575 = v537.shadow(0.2, v165.visuals.indicators.shadow.value);
            if v575 ~= 0 then
                render.shadow(vector(v574.x, v574.y + v573.y * 0.55), vector(v574.x + v573.x - 1, v574.y + v573.y * 0.55), v570:alpha_modulate(v564 * v575, true), 20, 0, 0);
            end;
            render.text(l_l_Pixel_0_0, v574, v569, "s", v572);
            v571.y = v571.y + (v573.y - 4);
            v573 = string.upper(v25.functions.safe_head and "SAFE" or v27.condition);
            v574 = render.measure_text(l_l_Pixel_0_0, "s", v573);
            v575 = v537.width(0.1, v574.x);
            if v574.x < v575 then
                v575 = v574.x;
            end;
            local v576 = v571:clone();
            v576.x = v576.x - v575 * 0.5 * v565;
            local v577 = vector(v575, v574.y);
            render.push_clip_rect(v576, v576 + v577);
            render.text(l_l_Pixel_0_0, v576, v570, "s", v573);
            render.pop_clip_rect();
            v571.y = v571.y + (v574.y - 4);
            v574 = 0;
            for _, v579 in next, l_v557_0 do
                local v580 = v579.animation(0.1, v579.status());
                if v580 > 0 then
                    local v581 = v579.text or v579.get_text();
                    local v582 = v579.color and v579.color() or v43.white;
                    local v583 = render.measure_text(l_l_Pixel_0_0, "s", v581);
                    local v584 = v571:clone();
                    v584.x = v584.x - v583.x * 0.5 * v565;
                    v584.y = v584.y + v574;
                    render.text(l_l_Pixel_0_0, v584, v582:alpha_modulate(v563 * v580 * v566, true), "s", v581);
                    v574 = v574 + (v583.y - 4) * v580;
                end;
            end;
            return;
        end;
    end);
end;
v557 = nil;
v557 = {
    animation = v84:new(l_sv_gravity_0.VISUALS.fov:get(), v32)
};
v93["Animate Zoom"].override_view:set(function(v585, _, v587)
    -- upvalues: v165 (ref), v557 (ref)
    if not v165.visuals.zoom.value or not v587 then
        return;
    else
        v585.fov = v557.animation(0.1, v585.fov);
        return;
    end;
end);
l_Pixel_0 = nil;
l_Pixel_0 = {
    font = render.safe_load_font("Tahoma", 19, "adb"), 
    alpha = v84:new(), 
    blind = v84:new(), 
    left = v84:new(), 
    right = v84:new(), 
    offset = v25.screen.y / 1080
};
l_Pixel_0.generate_position = function(_, v589, v590)
    -- upvalues: v25 (ref), l_Pixel_0 (ref)
    local v591 = v25.screen_center:clone();
    local v592 = vector();
    if v589 ~= nil then
        v592.x = v592.x + v589 * l_Pixel_0.offset;
    end;
    if v590 ~= nil then
        v592.y = v592.y + v590 * l_Pixel_0.offset;
    end;
    return v591 + v592;
end;
v93.Arrows.render:set(function(v593, v594)
    -- upvalues: l_Pixel_0 (ref), v165 (ref), v43 (ref)
    local v595 = l_Pixel_0.alpha(0.2, v165.visuals.arrows.value and v594);
    if v595 <= 0 then
        return;
    else
        local v596 = l_Pixel_0.blind(0.08, v593 and not v593.m_bIsScoped or false);
        if v596 <= 0 then
            return;
        else
            local v597 = v165.visuals.arrows.color.value:alpha_modulate(255);
            local l_value_11 = v165.antiaim.manual_yaw.value;
            local v599 = v43.idle:lerp(v597, l_Pixel_0.left(0.2, l_value_11 == "Left"));
            local v600 = v43.idle:lerp(v597, l_Pixel_0.right(0.2, l_value_11 == "Right"));
            local v601 = l_Pixel_0:generate_position(-35);
            local v602 = render.measure_text(l_Pixel_0.font, "s", "\226\157\176");
            render.text(l_Pixel_0.font, v601 - vector(v602.x, v602.y * 0.5), v599:alpha_modulate(v595 * v596, true), "s", "\226\157\176");
            v601 = l_Pixel_0:generate_position(35);
            v602 = render.measure_text(l_Pixel_0.font, "s", "\226\157\177");
            render.text(l_Pixel_0.font, v601 - vector(0, v602.y * 0.5), v600:alpha_modulate(v595 * v596, true), "s", "\226\157\177");
            return;
        end;
    end;
end);
local _ = nil;
local v604 = render.safe_load_font("Calibri Bold", vector(25, 22, -1), "ad");
do
    local l_v604_0 = v604;
    local function v610(v606, v607, v608)
        -- upvalues: l_v604_0 (ref), v43 (ref)
        local v609 = render.measure_text(l_v604_0, "a", v607);
        render.gradient(v606 - vector(0, 5), v606 + vector(28 + v609.x / 2, 28), v43.gradient_out, v43.gradient_in, v43.gradient_out, v43.gradient_in);
        render.gradient(v606 + vector(28 + v609.x / 2, -5), v606 + vector((28 + v609.x / 2) * 2 - 1, 28), v43.gradient_in, v43.gradient_out, v43.gradient_in, v43.gradient_out);
        render.text(l_v604_0, v606 + vector(27, 3), v608, nil, v607);
    end;
    local v611 = nil;
    v611 = {
        hits = 0, 
        total = 0, 
        reasons = {
            ["prediction error"] = true, 
            ["player death"] = true, 
            death = true, 
            ["unregistered shot"] = true
        }
    };
    v93["Screen Indicators"].aim_ack:set(function(v612)
        -- upvalues: v611 (ref)
        if v611.reasons[v612.state] ~= nil then
            return;
        else
            v611.total = v611.total + 1;
            if not v612.state then
                v611.hits = v611.hits + 1;
            end;
            return;
        end;
    end);
    v93["Screen Indicators"].player_connect_full:set(function(v613, v614)
        -- upvalues: v611 (ref)
        if entity.get(v613.userid, true) ~= v614 then
            return;
        else
            v611.hits = 0;
            v611.total = 0;
            return;
        end;
    end);
    local v615 = nil;
    v615 = {
        damage = "-0 HP", 
        icon = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
    };
    local function v616()
        -- upvalues: v615 (ref)
        v615.site = nil;
    end;
    events.round_start:set(v616);
    events.bomb_planted:set(v616);
    events.bomb_abortplant:set(v616);
    v615.planting_time = 3.125;
    local function v622(v617, v618)
        local v619 = 0.5;
        local v620 = 0.5;
        if v618 and v618 > 0 then
            local v621 = v617 * v619;
            if v618 < (v617 - v621) * v620 then
                v621 = v617 - v618 * (1 / v620);
            end;
            v617 = v621;
        end;
        return v617;
    end;
    do
        local l_v622_0 = v622;
        local function v629(v624, v625)
            -- upvalues: l_v622_0 (ref)
            if not v624 then
                return 0;
            else
                local v626 = v624:get_origin():dist(v625:get_origin());
                local v627 = 500;
                local v628 = v627 * 3.5;
                v627 = v627 * math.exp(-(v626 * v626 / (v628 * 2 / 3 * (v628 / 3))));
                return (math.floor(l_v622_0(math.max(v627, 0), v624.m_ArmorValue)));
            end;
        end;
        v93.Bomb.render:set(function()
            -- upvalues: v165 (ref), v615 (ref), v629 (ref)
            if not v165.visuals.gs.value then
                return;
            else
                v615.entity = nil;
                v615.damage = "";
                v615.player = nil;
                entity.get_entities("CPlantedC4", true, function(v630)
                    -- upvalues: v615 (ref)
                    if not v630.m_bBombTicking or globals.curtime > v630.m_flC4Blow then
                        return;
                    else
                        v615.entity = v630;
                        return;
                    end;
                end);
                local v631 = entity.get_local_player();
                if not v615.entity or not v631 then
                    return;
                else
                    local l_m_iObserverMode_0 = v631.m_iObserverMode;
                    if l_m_iObserverMode_0 == 6 or l_m_iObserverMode_0 == 1 or l_m_iObserverMode_0 == 2 then
                        return;
                    else
                        v615.player = v631.m_hObserverTarget or v631;
                        local v633 = v629(v615.player, v615.entity);
                        v615.damage = v615.player.m_iHealth <= v633 and "FATAL" or string.format("-%d HP", v633);
                        return;
                    end;
                end;
            end;
        end);
        events.bomb_beginplant:set(function(v634)
            -- upvalues: v615 (ref)
            local v635 = entity.get(v634.site);
            if not v635 then
                return;
            else
                local v636 = ffi.cast("uintptr_t", v635[0]) + 340;
                v615.site = ffi.cast("char*", v636)[0] == 65 and "A" or "B";
                v615.planting_started = globals.curtime;
                return;
            end;
        end);
    end;
    v616 = v165.visuals.gs.items.ref;
    v622 = {
        [1] = {
            condition = function()
                -- upvalues: v615 (ref), v616 (ref)
                return v615.site ~= nil and entity.get_game_rules() ~= nil and v616:get("Bomb Info");
            end, 
            get_text = function()
                -- upvalues: v615 (ref)
                return "        " .. v615.site .. "        ";
            end, 
            additional_render = function(v637)
                -- upvalues: v615 (ref), v43 (ref)
                local v638 = (globals.curtime - v615.planting_started) / v615.planting_time;
                render.circle_outline(v637 + vector(97, 11), color(0, 0, 0, 100), 10, 0, 1, 4);
                render.circle_outline(v637 + vector(97, 11), color(), 9, 0, v638, 2.5);
                render.texture(v615.icon, v637 + vector(27, -3), nil, v43.plant_ok);
            end, 
            col = function()
                -- upvalues: v615 (ref), v43 (ref)
                local v639 = entity.get_game_rules();
                return v615.planting_started + v615.planting_time < v639.m_fRoundStartTime + v639.m_iRoundTime and v43.plant_warning or v43.plant_ok;
            end
        }, 
        [2] = {
            get_text = function()
                -- upvalues: v615 (ref)
                return v615.damage;
            end, 
            col = function()
                -- upvalues: v615 (ref), v43 (ref)
                return v615.damage == "FATAL" and v43.red or v43.plant_ok;
            end, 
            condition = function(_)
                -- upvalues: v615 (ref), v616 (ref)
                return v615.entity ~= nil and v615.damage ~= "-0 HP" and v616:get("Bomb Info") and v615.player ~= nil;
            end
        }, 
        [3] = {
            get_text = function()
                -- upvalues: v615 (ref)
                local _ = "";
                local l_entity_1 = v615.entity;
                return "        " .. (l_entity_1.m_nBombSite == 0 and "A" or "B") .. string.format(" - %.1fs", l_entity_1.m_flC4Blow - globals.curtime);
            end, 
            additional_render = function(v643)
                -- upvalues: v615 (ref), v43 (ref)
                render.texture(v615.icon, v643 + vector(27, -3), nil, v43.white);
            end, 
            condition = function()
                -- upvalues: v615 (ref), v616 (ref)
                return v615.entity ~= nil and v616:get("Bomb Info");
            end
        }, 
        [4] = {
            text = "FS", 
            condition = function(v644)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return l_sv_gravity_0.AA.angles.freestanding:get() and v616:get("Freestanding") and v644;
            end, 
            col = function()
                -- upvalues: v43 (ref)
                return rage.antiaim:get_target(true) and v43.white_idle or v43.red;
            end
        }, 
        [5] = {
            text = "MD", 
            condition = function(v645)
                -- upvalues: v536 (ref), v616 (ref)
                return v536:get("Min. Damage") and v616:get("Min. Damage") and v645;
            end
        }, 
        [6] = {
            text = "HC", 
            condition = function(v646)
                -- upvalues: v536 (ref), v616 (ref)
                return v536:get("Hit Chance") and v616:get("Hit Chance") and v646;
            end
        }, 
        [7] = {
            get_text = function()
                -- upvalues: v611 (ref)
                local v647 = v611.total ~= 0 and v611.hits / v611.total * 100 or 100;
                return string.format("%d%%", v647);
            end, 
            condition = function(v648)
                -- upvalues: v616 (ref), v611 (ref)
                return v616:get("Aimbot Shots") and v648 and v611.total ~= 0;
            end
        }, 
        [8] = {
            text = "DUCK", 
            condition = function(v649)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return l_sv_gravity_0.AA.other.fake_duck:get() and v616:get("Fake Duck") and v649;
            end
        }, 
        [9] = {
            text = "DA", 
            condition = function(v650)
                -- upvalues: l_sv_gravity_0 (ref), v165 (ref), v616 (ref)
                return (not not l_sv_gravity_0.RAGE.dormant:get() or v165.rage.dormant.value) and v616:get("Dormant Aimbot") and v650;
            end
        }, 
        [10] = {
            text = "BODY", 
            condition = function(v651)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return l_sv_gravity_0.RAGE.body_aim:get() == "Force" and v616:get("Body Aim") and v651;
            end
        }, 
        [11] = {
            text = "SAFE", 
            condition = function(v652)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return l_sv_gravity_0.RAGE.safe_point:get() == "Force" and v616:get("Safe Point") and v652;
            end
        }, 
        [12] = {
            text = "DT", 
            col = function()
                -- upvalues: v43 (ref)
                return rage.exploit:get() == 1 and v43.white_idle or v43.red;
            end, 
            condition = function(v653)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return not l_sv_gravity_0.AA.other.fake_duck:get() and l_sv_gravity_0.RAGE.double_tap.main:get() and v616:get("Double Tap") and v653;
            end
        }, 
        [13] = {
            text = "OSAA", 
            condition = function(v654)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return not l_sv_gravity_0.AA.other.fake_duck:get() and not l_sv_gravity_0.RAGE.double_tap.main:get() and l_sv_gravity_0.RAGE.hide_shots.main:get() and v616:get("Hide Shots") and v654;
            end
        }, 
        [14] = {
            text = "PING", 
            col = function(_)
                -- upvalues: v43 (ref), l_sv_gravity_0 (ref)
                local v656 = utils.net_channel();
                if not v656 then
                    return v43.green;
                else
                    local v657 = v656.latency[0] * 1000;
                    local v658 = l_sv_gravity_0.MISC.fake_latency:get() / v657;
                    if v658 > 1 then
                        v658 = 1 - v658 % 1;
                    end;
                    return v43.piss:lerp(v43.green, v658);
                end;
            end, 
            condition = function(v659)
                -- upvalues: l_sv_gravity_0 (ref), v616 (ref)
                return l_sv_gravity_0.MISC.fake_latency:get() ~= 0 and v616:get("Fake Latency") and v659;
            end
        }
    };
    v93["Screen Indicators"].render:set(function(v660, v661)
        -- upvalues: v165 (ref), v25 (ref), v622 (ref), v43 (ref), v610 (ref), v615 (ref)
        if not v165.visuals.gs.value or #v165.visuals.gs.items.value == 0 then
            return;
        elseif not globals.is_in_game then
            return;
        else
            local v662 = vector(0, v25.screen.y - 340);
            local v663 = 0;
            local v664 = #v622;
            for v665 = 0, v664 - 1 do
                local v666 = v622[v664 - v665];
                if not v666.condition or v666.condition(v661) then
                    local v667 = v666.col and v666.col(v660) or v43.white_idle;
                    local v668 = v666.text or v666.get_text();
                    local v669 = v662 - vector(0, v663 * 41);
                    v610(v669, v668, v667);
                    if v666.additional_render then
                        v666.additional_render(v669);
                    end;
                    v663 = v663 + 1;
                end;
            end;
            if not v615.entity then
                return;
            else
                local l_m_hBombDefuser_0 = v615.entity.m_hBombDefuser;
                local _ = v615.entity.m_flDefuseLength;
                local v672 = l_m_hBombDefuser_0 and (v615.entity.m_flDefuseCountDown - globals.curtime) * 10 / 10 or -1;
                local v673 = v615.entity.m_flC4Blow - globals.curtime;
                if v672 > 0 then
                    render.rect(vector(), vector(16, v25.screen.y), color(25, 25, 25, 160));
                    render.rect_outline(vector(), vector(16, v25.screen.y), color(25, 25, 25, 160));
                    render.rect(vector(0, v25.screen.y - (v25.screen.y - 50) / 10 * v672), vector(16, v25.screen.y), v672 < v673 and color(58, 191, 54, 160) or color(255, 0, 0, 125));
                end;
                return;
            end;
        end;
    end);
end;
v604 = nil;
v604 = {
    fps = 0, 
    fps_normalized = 0, 
    time = 0, 
    alpha = v84:new(), 
    width = v84:new(150, v37), 
    height = v84:new(20), 
    shadow = v84:new(), 
    items = v84:new(), 
    container = v94.add("Watermark", vector(), vector(150, 20)), 
    font = v44["Museo Sans"]
};
local v674 = {
    user = ui.get_icon("user"), 
    ping = ui.get_icon("clock-rotate-left"), 
    fps = ui.get_icon("chart-line"), 
    time = ui.get_icon("clock")
};
local v675 = "\aFFFFFF68 | \aDEFAULT";
do
    local l_v674_0 = v674;
    v93.Watermark.render:set(function()
        -- upvalues: v604 (ref), v165 (ref), v45 (ref), v25 (ref), v26 (ref), l_v674_0 (ref), v43 (ref)
        local v677 = v604.alpha(0.2, v165.visuals.watermark.value);
        if v677 <= 0 then
            return;
        else
            local v678 = v604.container:process();
            local v679 = v45.table.convert(v165.visuals.watermark.items.value);
            local v680, v681 = v165.visuals.watermark.color:get();
            local l_value_12 = v165.visuals.watermark.user.value;
            if l_value_12:gsub(" ", "") == "" then
                l_value_12 = v25.user;
            end;
            local v683 = color();
            local v684 = color();
            local v685 = nil;
            if v680 == "Fade" then
                local v686 = v681[1];
                local v687 = v681[2];
                local v688 = 255;
                v687.a = 255;
                v686.a = v688;
                v686, v687 = v45.string.wave("exscord", v681[1], v681[2], v165.visuals.watermark.speed.value * 0.1);
                v685 = string.format("%s %s", v26[v25.branch], v686);
                v683 = v687;
                v684 = v681[2];
            else
                v681.a = 255;
                v685 = string.format("%s exscord", v26[v25.branch]);
                v683 = v681;
                v684 = v681;
            end;
            local v689 = {
                [1] = v685
            };
            v684 = v684.to_hex(v684);
            if v679.Nickname then
                table.insert(v689, string.format("\a%s%s  \aDEFAULT%s", v684, l_v674_0.user, v45.string.clamp(l_value_12, 15)));
            end;
            if globals.is_in_game and v679.Latency then
                local v690 = utils.net_channel();
                if v690 ~= nil and not v690.is_loopback then
                    local v691 = v690.latency[1] * 1000;
                    if v691 > 0 then
                        table.insert(v689, string.format("\a%s%s  \aDEFAULT%d ms", v684, l_v674_0.ping, math.floor(v691)));
                    end;
                end;
            end;
            if v679.Framerate then
                if globals.tickcount % 96 == 0 or v604.fps == 0 then
                    v604.fps = 0.9 * v604.fps + 0.1 * globals.absoluteframetime;
                    if v604.fps < 0 then
                        v604.fps = 1;
                    end;
                    v604.fps_normalized = 1 / v604.fps;
                end;
                local v692 = math.floor(v604.fps_normalized);
                table.insert(v689, string.format("\a%s%s  \aDEFAULT%s fps", v684, l_v674_0.fps, v692));
            end;
            if v679["Current Time"] then
                if globals.tickcount % 320 == 0 or v604.time == 0 then
                    v604.time = common.get_date("%H:%M");
                end;
                table.insert(v689, string.format("\a%s%s  \aDEFAULT%s", v684, l_v674_0.time, v604.time));
            end;
            local v693 = table.concat(v689, "\aDEFAULT  ");
            local v694 = render.measure_text(v604.font, "s", v693);
            local v695 = vector(v25.screen.x, -3);
            local v696 = vector(v694.x + 8, v694.y + 8);
            v696.x = v604.width(0.2, v696.x);
            v696.y = v604.height(0.2, v696.y);
            v695 = v695 - vector(v696.x + 10, v696.y * -0.6 * v677);
            v678.position = v695;
            v678.size = v696;
            render.rect(v678.position, v678.position + v678.size, color(0, 125 * v677), 3);
            local v697 = v604.shadow(0.2, v165.visuals.watermark.shadow.value);
            if v697 ~= 0 then
                render.shadow(v678.position, v678.position + v678.size, v683.alpha_modulate(v683, v677 * v697, true), 25, 0, 3);
            end;
            render.push_clip_rect(v695, v695 + v696);
            render.text(v604.font, vector(v678.position.x + 4, v678.position.y + 4), v43.white:alpha_modulate(v677, true), "s", v693);
            render.pop_clip_rect();
            return;
        end;
    end);
end;
v674 = nil;
v674 = {
    alpha = v84:new(), 
    number = v84:new(0, v37), 
    hovered = v84:new(), 
    container = v94.add("Damage", vector(v25.screen_center.x + 5, v25.screen_center.y - 22), vector(20, 20))
};
v93["Damage Indicator"].render:set(function(_, v699)
    -- upvalues: v674 (ref), v165 (ref), v44 (ref), v25 (ref), v43 (ref), l_sv_gravity_0 (ref)
    local v700 = v674.alpha(0.2, v165.visuals.damage.value and v699);
    if v700 <= 0 then
        return;
    else
        local v701 = v674.container:process();
        local v702 = v44[v165.visuals.damage.font.value] or 1;
        local v703 = v674.hovered(0.2, v701.is_in_b);
        if v703 ~= 0 and v25.ui_alpha == 1 then
            render.text(v44["Museo Sans"], vector(v25.screen_center.x, v25.screen_center.y - 50), v43.white:alpha_modulate(v703 * v700, true), "sc", "You can restore default position by clicking M2 on element.");
        end;
        if v701.is_in_b and v701.is_rmb_pressed and v25.ui_alpha > 0 then
            v701.position = vector(v25.screen_center.x + 5, v25.screen_center.y - 22);
        end;
        local v704 = l_sv_gravity_0.RAGE.min_damage:get();
        local v705 = v674.number(0.06, v704);
        local v706 = v705 == 0 and "AUTO" or math.floor(v705);
        render.text(v702, v701.position + v701.size / 2, v165.visuals.damage.color.value:alpha_modulate(v700 * v25.blind_alpha, true), "cs", v706);
        return;
    end;
end);
v675 = nil;
v675 = {
    restore = function(_)
        cvar.viewmodel_fov:float(tonumber(cvar.viewmodel_fov:string()));
        cvar.viewmodel_offset_x:float(tonumber(cvar.viewmodel_offset_x:string()));
        cvar.viewmodel_offset_y:float(tonumber(cvar.viewmodel_offset_y:string()));
        cvar.viewmodel_offset_z:float(tonumber(cvar.viewmodel_offset_z:string()));
    end
};
v675.refresh = function(_)
    -- upvalues: v165 (ref), v675 (ref)
    if v165.visuals.view:get() then
        cvar.viewmodel_fov:float(v165.visuals.view.fov.value * 0.1, true);
        cvar.viewmodel_offset_x:float(v165.visuals.view.x.value * 0.1, true);
        cvar.viewmodel_offset_y:float(v165.visuals.view.y.value * 0.1, true);
        cvar.viewmodel_offset_z:float(v165.visuals.view.z.value * 0.1, true);
    else
        v675:restore();
    end;
end;
v165.visuals.view:set_callback(v675.refresh, true);
v165.visuals.view.fov:set_callback(v675.refresh, true);
v165.visuals.view.x:set_callback(v675.refresh, true);
v165.visuals.view.y:set_callback(v675.refresh, true);
v165.visuals.view.z:set_callback(v675.refresh, true);
v93.Viewmodel.shutdown:set(v675.restore);
v93.Viewmodel.console_input:set(function(v709)
    -- upvalues: v165 (ref)
    if not v165.visuals.view.value then
        return;
    elseif v709:find("viewmodel") then
        return false;
    else
        return;
    end;
end);
local v710 = nil;
v710 = {
    to_reset = false, 
    start = cvar.r_aspectratio:float()
};
v710.reset = function(_)
    -- upvalues: v710 (ref)
    if v710.to_reset then
        cvar.r_aspectratio:float(v710.start);
        v710.to_reset = false;
    end;
end;
v710.update = function(_)
    -- upvalues: v165 (ref), v710 (ref)
    local v713 = v165.visuals.aspect:get() and v165.visuals.aspect.ratio:get() / 100 or v710.start;
    cvar.r_aspectratio:float(v713);
    if v713 == 0.49 then
        v710.to_reset = true;
        v710:reset();
    else
        v710.to_reset = v713 ~= 0.49;
    end;
end;
v165.visuals.aspect:set_callback(v710.update, true);
v165.visuals.aspect.ratio:set_callback(v710.update, true);
v93["Aspect Ratio"].shutdown:set(v710.reset);
v93["Aspect Ratio"].console_input:set(function(v714)
    -- upvalues: v165 (ref)
    if not v165.visuals.aspect.value then
        return;
    elseif v714:find("r_aspectratio") then
        return false;
    else
        return;
    end;
end);
local v715 = nil;
v715 = {};
v93["3D Hitmarker"].aim_ack:set(function(v716)
    -- upvalues: v165 (ref), v715 (ref), v84 (ref)
    if not v165.visuals.marker.value or not v165.visuals.marker._3d.value then
        return;
    elseif v716.state then
        return;
    else
        v715[#v715 + 1] = {
            [1] = v84:new(), 
            [2] = v716.aim or vector(), 
            [3] = globals.realtime + v165.visuals.marker.duration.value, 
            [4] = v165.visuals.marker._3d.color.value, 
            [5] = v165.visuals.marker.size.value
        };
        return;
    end;
end);
v93["3D Hitmarker"].render:set(function()
    -- upvalues: v165 (ref), v715 (ref)
    if not v165.visuals.marker.value or not v165.visuals.marker._3d.value then
        return;
    else
        local l_realtime_1 = globals.realtime;
        for v718, v719 in next, v715 do
            if v719 then
                local v720 = v719[3] - l_realtime_1;
                local v721 = v719[1](0.2, v720 > 0);
                if v721 <= 0 then
                    table.remove(v715, v718);
                else
                    local v722 = v719[2]:to_screen();
                    if v722 ~= nil then
                        local v723 = v719[4]:alpha_modulate(v721, true);
                        local v724 = v719[5] * render.get_scale(2);
                        render.line(v722 + v724, v722 + v724 * 2, v723);
                        render.line(vector(v722.x - v724, v722.y + v724), vector(v722.x - v724 * 2, v722.y + v724 * 2), v723);
                        render.line(vector(v722.x + v724, v722.y - v724), vector(v722.x + v724 * 2, v722.y - v724 * 2), v723);
                        render.line(vector(v722.x - v724, v722.y - v724), vector(v722.x - v724 * 2, v722.y - v724 * 2), v723);
                    end;
                end;
            end;
        end;
        return;
    end;
end);
local v725 = nil;
v725 = {};
local v726 = {
    [1] = 0, 
    [2] = 5, 
    [3] = 2, 
    [4] = 13, 
    [5] = 14, 
    [6] = 7, 
    [7] = 8
};
do
    local l_v726_0 = v726;
    v93["Damage Markers"].player_hurt:set(function(v728, v729, _)
        -- upvalues: v165 (ref), l_v726_0 (ref), v725 (ref), v84 (ref)
        if not v165.visuals.marker.value or not v165.visuals.marker.damage.value then
            return;
        else
            local v731 = entity.get(v728.userid, true);
            local v732 = entity.get(v728.attacker, true);
            if v731 == nil or v731 == v729 or v732 == nil or v732 ~= v729 then
                return;
            else
                local v733 = l_v726_0[v728.hitgroup] or 3;
                v725[#v725 + 1] = {
                    v84:new(), 
                    globals.realtime + 2, 
                    v165.visuals.marker.damage.color.value, 
                    v728.dmg_health, 
                    v731:get_hitbox_position(v733)
                };
                return;
            end;
        end;
    end);
    v93["Damage Markers"].render:set(function()
        -- upvalues: v165 (ref), v725 (ref)
        if not v165.visuals.marker.value or not v165.visuals.marker.damage.value then
            return;
        else
            local l_realtime_2 = globals.realtime;
            for v735, v736 in next, v725 do
                if v736 ~= nil then
                    local v737 = v736[2] - l_realtime_2;
                    local v738 = v736[1](0.2, v737 > 0);
                    if v738 <= 0 then
                        table.remove(v725, v735);
                    else
                        local v739 = vector(v736[5].x, v736[5].y, v736[5].z + 60 - v737 * 40):to_screen();
                        if v739 ~= nil then
                            render.text(1, v739, v736[3]:alpha_modulate(v738, true), "s", v736[4]);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end);
end;
v726 = nil;
v726 = {};
v93["Miss Markers"].aim_ack:set(function(v740)
    -- upvalues: v165 (ref), v726 (ref), v84 (ref)
    if not v165.visuals.marker.value or not v165.visuals.marker.miss.value then
        return;
    elseif not v740.state then
        return;
    else
        v726[#v726 + 1] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = nil, 
            [5] = nil, 
            [6] = 2, 
            [1] = v84:new(), 
            [2] = v740.state:upper() or "?", 
            [3] = v740.aim or vector(), 
            [4] = globals.realtime + v165.visuals.marker.duration.value, 
            [5] = v165.visuals.marker.miss.color.value
        };
        return;
    end;
end);
v93["Miss Markers"].render:set(function()
    -- upvalues: v165 (ref), v726 (ref)
    if not v165.visuals.marker.value or not v165.visuals.marker.miss.value then
        return;
    else
        local l_realtime_3 = globals.realtime;
        for v742, v743 in next, v726 do
            if v743 then
                local v744 = v743[4] - l_realtime_3;
                local v745 = v743[1](0.2, v744 > 0);
                if v745 <= 0 then
                    table.remove(v726, v742);
                else
                    local v746 = v743[3]:to_screen();
                    if v746 ~= nil then
                        local v747 = v743[5]:alpha_modulate(v745, true);
                        local v748 = v743[6] * render.get_scale(2);
                        render.line(v746 + v748, v746 + v748 * 2, v747);
                        render.line(vector(v746.x - v748, v746.y + v748), vector(v746.x - v748 * 2, v746.y + v748 * 2), v747);
                        render.line(vector(v746.x + v748, v746.y - v748), vector(v746.x + v748 * 2, v746.y - v748 * 2), v747);
                        render.line(vector(v746.x - v748, v746.y - v748), vector(v746.x - v748 * 2, v746.y - v748 * 2), v747);
                        render.text(2, vector(v746.x + 8, v746.y - 6), v747, "s", v743[2]);
                    end;
                end;
            end;
        end;
        return;
    end;
end);
local v749 = nil;
v749 = {
    force_unmute = utils.get_vfunc("client.dll", "GameClientExports001", 3, "void(__thiscall*)(void*, int)")
};
v749.perform = function(_)
    -- upvalues: v165 (ref), v749 (ref)
    if not v165.misc.unmute.value then
        return;
    else
        for _, v752 in next, entity.get_players() do
            if v752 ~= nil then
                v749.force_unmute(v752:get_index());
            end;
        end;
        return;
    end;
end;
v165.misc.unmute:set_callback(v749.perform, true);
v93["Unmute Players"].player_connect_full:set(v749.perform);
local _ = nil;
ffi.cdef("        typedef void* hwnd;\n        typedef const char* lpcstr;\n\n        hwnd FindWindowA(lpcstr lpClassName, lpcstr lpWindowName);\n        bool FlashWindow(hwnd hWnd, bool bInvert);\n    ");
local v754 = ffi.C.FindWindowA("Valve001", nil);
do
    local l_v754_0 = v754;
    v93["Taskbar Notification"].round_start:set(function()
        -- upvalues: v165 (ref), l_v754_0 (ref)
        if not v165.misc.taskbar.value then
            return;
        else
            local v756 = entity.get_game_rules();
            if v756 == nil then
                return;
            elseif v756.m_bIsValveDS then
                return;
            else
                ffi.C.FlashWindow(l_v754_0, false);
                return;
            end;
        end;
    end);
end;
v754 = nil;
v93["No Fall Damage"].createmove:set(function(v757, v758, _)
    -- upvalues: v165 (ref), v27 (ref)
    if not v758 or not v165.misc.no_fall.value then
        return;
    else
        local v760 = v758:get_origin();
        local v761 = utils.trace_line(v760, vector(v760.x, v760.y, v760.z - 500), nil, nil, 1);
        if v760.z - v761.end_pos.z <= 70 and v760.z - v761.end_pos.z >= 12 and not v27.on_ground and v758.m_vecVelocity.z < -450 then
            v757.in_duck = true;
        end;
        return;
    end;
end);
v93["Fast Ladder"].createmove:set(function(v762, v763, _)
    -- upvalues: v165 (ref)
    if not v763 or not v165.misc.ladder.value then
        return;
    elseif v763.m_MoveType ~= 9 then
        return;
    else
        local v765 = v763:get_player_weapon();
        if v765 == nil then
            return;
        else
            local l_m_fThrowTime_0 = v765.m_fThrowTime;
            if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 ~= 0 then
                return;
            else
                if v762.sidemove == 0 then
                    v762.view_angles.y = v762.view_angles.y + 45;
                end;
                if v762.in_forward and v762.sidemove < 0 then
                    v762.view_angles.y = v762.view_angles.y + 90;
                end;
                if v762.in_back and v762.sidemove > 0 then
                    v762.view_angles.y = v762.view_angles.y + 90;
                end;
                v762.in_moveleft = v762.in_back;
                v762.in_moveright = v762.in_forward;
                if v762.view_angles.x < 0 then
                    v762.view_angles.x = -45;
                end;
                return;
            end;
        end;
    end;
end);
local v767 = nil;
v767 = {
    reset = false, 
    overrides = function(v768)
        -- upvalues: l_sv_gravity_0 (ref)
        if v768.reset then
            l_sv_gravity_0.MISC.weapon_actions:override();
            v768.reset = false;
        end;
    end
};
v93["Grenade Fix"].createmove:set(function(_, v770, _)
    -- upvalues: v165 (ref), v767 (ref), l_sv_gravity_0 (ref)
    if not v770 or not v165.misc.fix_nades.value then
        return v767:overrides();
    else
        local v772 = v770:get_player_weapon();
        if v772 == nil then
            return v767:overrides();
        elseif v772:get_weapon_info().weapon_type ~= 9 then
            return v767:overrides();
        else
            if v165.misc.fix_nades.quick_switch.value then
                l_sv_gravity_0.MISC.weapon_actions:override("");
            else
                v767:overrides();
            end;
            rage.exploit:allow_defensive(false);
            v767.reset = true;
            return;
        end;
    end;
end);
local v773 = nil;
v773 = {
    previous = "", 
    animation = function(_, v775)
        local v776 = {};
        for v777 = 1, #v775 do
            table.insert(v776, v775:sub(1, v777));
        end;
        for v778 = 1, #v775 do
            table.insert(v776, v775:sub(v778, #v775));
        end;
        table.insert(v776, "");
        return v776;
    end
};
v93.Clantag.render:set(function()
    -- upvalues: v165 (ref), v773 (ref)
    if not v165.misc.clan.value then
        return;
    else
        local v779 = v773:animation("exscord");
        local v780 = math.floor(globals.curtime * 4.5);
        if v780 ~= v773.previous then
            common.set_clan_tag(v779[v780 % #v779 + 1]);
        end;
        v773.previous = v780;
        return;
    end;
end);
v93.Clantag.shutdown:set(function()
    common.set_clan_tag("");
end);
local v781 = nil;
v781 = {
    alpha = v84:new(), 
    width = v84:new(), 
    invert = v84:new()
};
local l_screen_center_0 = v25.screen_center;
do
    local l_l_screen_center_0_0 = l_screen_center_0;
    v93["Scope Overlay"].render:set(function(v784, _)
        -- upvalues: v781 (ref), v165 (ref), l_l_screen_center_0_0 (ref)
        local v786 = v781.alpha(0.2, v165.visuals.custom_scope.value);
        if v786 <= 0 then
            return;
        else
            local v787 = v784 and v784.m_bIsScoped or false;
            local v788 = v781.width(0.05, v787);
            if v788 <= 0 then
                return;
            else
                local l_value_13 = v165.visuals.custom_scope.inverted.color.value;
                l_value_13.a = 255 * v786;
                local v790 = v787 and v165.visuals.custom_scope.size.value * v788 or 0;
                local l_value_14 = v165.visuals.custom_scope.gap.value;
                local v792 = v781.invert(0.2, v165.visuals.custom_scope.inverted.value);
                local v793 = l_value_13:alpha_modulate(0);
                local v794 = l_value_13:lerp(v793, v792);
                local v795 = v793:lerp(l_value_13, v792);
                if not v165.visuals.custom_scope.t.value then
                    render.gradient(vector(l_l_screen_center_0_0.x, l_l_screen_center_0_0.y - l_value_14), vector(l_l_screen_center_0_0.x + 1, l_l_screen_center_0_0.y - l_value_14 - v790), v794, v794, v795, v795);
                end;
                render.gradient(vector(l_l_screen_center_0_0.x, l_l_screen_center_0_0.y + l_value_14 + 1), vector(l_l_screen_center_0_0.x + 1, l_l_screen_center_0_0.y + l_value_14 + v790 + 1), v794, v794, v795, v795);
                render.gradient(vector(l_l_screen_center_0_0.x - l_value_14, l_l_screen_center_0_0.y), vector(l_l_screen_center_0_0.x - l_value_14 - v790, l_l_screen_center_0_0.y + 1), v794, v795, v794, v795);
                render.gradient(vector(l_l_screen_center_0_0.x + l_value_14 + 1, l_l_screen_center_0_0.y), vector(l_l_screen_center_0_0.x + l_value_14 + v790 + 1, l_l_screen_center_0_0.y + 1), v794, v795, v794, v795);
                return;
            end;
        end;
    end);
end;
l_screen_center_0 = nil;
l_screen_center_0 = {
    reset = false, 
    visible = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)"), 
    previous = color(), 
    colorize = function(_, v797)
        -- upvalues: v43 (ref)
        if not v797 then
            v797 = v43.white;
        end;
        materials.get_materials("vgui/hud/800", false, function(v798)
            -- upvalues: v797 (ref)
            v798:color_modulate(v797);
            v798:alpha_modulate(v797.a / 255);
        end);
        materials.get_materials("vgui_white", false, function(v799)
            -- upvalues: v797 (ref)
            v799:color_modulate(v797);
            v799:alpha_modulate(v797.a / 255);
        end);
    end
};
l_screen_center_0.handle = function(_)
    -- upvalues: v165 (ref), l_screen_center_0 (ref)
    if not v165.misc.console.value then
        if l_screen_center_0.reset then
            l_screen_center_0.reset = false;
            l_screen_center_0:colorize();
        end;
        return;
    else
        local l_value_15 = v165.misc.console.color.value;
        if l_value_15 ~= l_screen_center_0.previous then
            l_screen_center_0.reset = not l_screen_center_0.visible();
            l_screen_center_0:colorize(l_value_15);
            l_screen_center_0.previous = l_value_15;
        end;
        if l_screen_center_0.visible() then
            if not l_screen_center_0.reset then
                l_screen_center_0.reset = true;
                l_screen_center_0:colorize(l_value_15);
            end;
        elseif l_screen_center_0.reset then
            l_screen_center_0.reset = false;
            l_screen_center_0:colorize();
        end;
        return;
    end;
end;
v93["Console Color"].pre_render:set(l_screen_center_0.handle);
events.shutdown:set(l_screen_center_0.colorize);
local v802 = nil;
v802 = {
    tick = 0, 
    next_tick = 0, 
    reset = false
};
v93["Drop Nades"].createmove:set(function(v803, v804, v805)
    -- upvalues: v802 (ref), v165 (ref)
    if not v804 or not v805 then
        return;
    else
        v802.tick = globals.curtime;
        if v165.misc.drop_nades.value then
            if v802.reset then
                v802.reset = false;
                local v806 = {};
                for _, v808 in next, v804:get_player_weapon(true) do
                    if v808 ~= nil then
                        local v809 = v808:get_weapon_info();
                        if v809.weapon_type == 9 then
                            table.insert(v806, v809.weapon_name);
                        end;
                    end;
                end;
                if #v806 ~= 0 then
                    for v810, v811 in next, v806 do
                        do
                            local l_v811_0 = v811;
                            utils.execute_after(0.02 * v810, function()
                                -- upvalues: l_v811_0 (ref)
                                utils.console_exec("use " .. l_v811_0);
                                utils.console_exec("drop");
                            end);
                        end;
                    end;
                    v803.in_use = true;
                    v803.send_packet = true;
                    v803.no_choke = true;
                    v802.next_tick = globals.curtime + 0.02 * #v806;
                end;
            end;
            if v802.tick < v802.next_tick then
                v803.in_use = true;
                v803.send_packet = true;
                v803.no_choke = true;
                return;
            end;
        elseif not v165.misc.drop_nades.value and not v802.reset then
            v802.reset = true;
        end;
        return;
    end;
end);
local v813 = nil;
v813 = {
    delay = 0, 
    time = 0, 
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
v93["Air Teleport"].createmove:set(function(_, v815, v816)
    -- upvalues: v165 (ref), v27 (ref), v813 (ref), v45 (ref)
    if not v165.rage.air_teleport.value or not v816 then
        rage.exploit:allow_charge(true);
        return;
    else
        local l_value_16 = v165.rage.air_teleport.weapons.value;
        if #l_value_16 == 0 then
            return;
        elseif v27.on_ground or #v815.m_vecVelocity < 100 then
            return;
        elseif rage.exploit:get() ~= 1 then
            return;
        else
            local v818 = entity.get_threat();
            if v818 == nil then
                return;
            else
                local v819 = v815:get_player_weapon();
                if v819 == nil then
                    return;
                else
                    local v820 = v819:get_weapon_index();
                    local v821 = false;
                    local v822 = false;
                    for _, v824 in next, l_value_16 do
                        local v825 = v813.weapons[v824];
                        if v825 then
                            for _, v827 in next, v825 do
                                if v827 == v820 then
                                    v821 = true;
                                    break;
                                end;
                            end;
                        elseif v824 == "Knife" then
                            v822 = true;
                        end;
                    end;
                    if not v821 and v822 and v819:get_classid() == 107 then
                        v821 = true;
                    end;
                    if not v821 then
                        return;
                    else
                        local v828 = v818:get_resource();
                        if not v828 then
                            return;
                        else
                            local l_m_iPing_0 = v828.m_iPing;
                            local v830 = math.max(5, to_ticks(l_m_iPing_0 * (l_m_iPing_0 <= 10 and 2 or 1.75) / 1000));
                            local v831 = v818:get_hitbox_position(4);
                            local v832 = v815:get_hitbox_position(4);
                            local v833, v834 = utils.trace_bullet(v818, v831, v45.extrapolate(v815, v830, v832));
                            local v835;
                            if not v833 or v833 <= 0 then
                                v835 = false;
                            elseif not v834.entity or v834.entity:get_classname() == "CWorld" then
                                v835 = false;
                            else
                                v835 = true;
                            end;
                            if v835 and v813.time < globals.realtime then
                                if v813.delay == v165.rage.air_teleport.delay.value then
                                    v813.time = globals.realtime + 0.5;
                                    rage.exploit:force_teleport();
                                    rage.exploit:allow_charge(false);
                                    v813.delay = 0;
                                end;
                                v813.delay = v813.delay + 1;
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
local v836 = nil;
v836 = {
    reset = false
};
local v837 = ffi.typeof("        struct {\n            float   anim_time;\n            float   fade_out_time;\n            int     nil;\n            int     activty;\n            int     priority;\n            int     order;\n            int     sequence;\n            float   prev_cycle;\n            float   weight;\n            float   weight_delta_rate;\n            float   playback_rate;\n            float   cycle;\n            int     owner;\n            int     bits;\n        }\n        ");
do
    local l_v837_0 = v837;
    v93["Animation Breakers"].post_update_clientside_animation:set(function(v839, v840, _)
        -- upvalues: v165 (ref), v836 (ref), l_sv_gravity_0 (ref), l_v837_0 (ref), v27 (ref), v45 (ref)
        if not v165.visuals.animations.value then
            if v836.reset then
                v836.reset = false;
                l_sv_gravity_0.AA.other.leg_movement:override();
            end;
            return;
        else
            local l_m_MoveType_0 = v840.m_MoveType;
            if v840 == nil or v839 == nil or l_m_MoveType_0 == 8 or l_m_MoveType_0 == 9 then
                if v836.reset then
                    v836.reset = false;
                    l_sv_gravity_0.AA.other.leg_movement:override();
                end;
                return;
            else
                if v839 == v840 then
                    local v843 = ffi.cast("uintptr_t", v839[0]);
                    local v844 = ffi.cast(ffi.typeof("$**", l_v837_0), v843 + 10640)[0];
                    if v27.on_ground then
                        local l_value_17 = v165.visuals.animations.ground.value;
                        if l_value_17 ~= "Disabled" then
                            if l_value_17 == "Static" then
                                v839.m_flPoseParameter[0] = 1;
                                l_sv_gravity_0.AA.other.leg_movement:override("Sliding");
                                v836.reset = true;
                            elseif l_value_17 == "Moon Walk" then
                                v839.m_flPoseParameter[7] = 0.5;
                                l_sv_gravity_0.AA.other.leg_movement:override("Walking");
                                v836.reset = true;
                            end;
                        elseif v836.reset then
                            v836.reset = false;
                            l_sv_gravity_0.AA.other.leg_movement:override();
                        end;
                    else
                        local l_value_18 = v165.visuals.animations.air.value;
                        if l_value_18 ~= "Disabled" then
                            if l_value_18 == "Static" then
                                v839.m_flPoseParameter[6] = 1;
                            elseif l_value_18 == "Moon Walk" then
                                local v847 = globals.realtime * 0.7 % 2;
                                if v847 > 1 then
                                    v847 = 1 - (v847 - 1);
                                end;
                                v844[6].weight = 1;
                                v844[6].cycle = v847;
                            end;
                        end;
                    end;
                    local l_value_19 = v165.visuals.animations.global.value;
                    if #l_value_19 ~= 0 then
                        local v849 = v45.table.convert(l_value_19);
                        if v849["Static Slow Walk"] and l_sv_gravity_0.AA.other.slow_walk:get() then
                            v839.m_flPoseParameter[9] = 0;
                        end;
                        if v849["Zero Pitch on Land"] and v27.on_land then
                            v839.m_flPoseParameter[12] = 0.5;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end);
end;
v837 = nil;
v837 = {
    link = "wss://exscord.mishkat.cloud/ws", 
    encoder = "ILOVEexscordABCDFGHJKMNPQRSTUWXYZabfghijklmnpqtuvwyz0123456789+/=", 
    failed_connections = 0, 
    data = {}, 
    icon_data = {}
};
v837.retrieve = function()
    -- upvalues: v25 (ref), v1 (ref), v837 (ref)
    local v850 = json.stringify({
        steam = tostring(panorama.MyPersonaAPI.GetXuid():sub(7) - 97960265728), 
        logo = v25.branch
    });
    return v1.encode(v850, v837.encoder);
end;
v837.callbacks = {
    open = function(v851)
        -- upvalues: v837 (ref)
        v851:send(v837.retrieve());
        v837.socket = v851;
    end, 
    message = function(_, v853)
        -- upvalues: v1 (ref), v837 (ref), v25 (ref), v165 (ref)
        local l_status_15, l_result_15 = pcall(v1.decode, v853, v837.encoder);
        if not l_status_15 or type(l_result_15) ~= "string" then
            return;
        else
            local l_status_16, l_result_16 = pcall(json.parse, l_result_15);
            if not l_status_16 then
                return;
            else
                local v858 = 10;
                for _, v860 in next, l_result_16 do
                    if type(v860) == "string" then
                        v858 = v858 + 1;
                    end;
                end;
                v837.data = l_result_16;
                v25.online = v858;
                v165.info.online:name(string.format(" \a{Link Active}\f<users>\r\tOnline Users: \a{Link Active}%s", v25.online));
                return;
            end;
        end;
    end, 
    close = function(_)
        -- upvalues: v837 (ref), v45 (ref), v25 (ref), v3 (ref)
        if v837.failed_connections >= 3 then
            common.add_notify("exscord Renewed", v45.string.format("Cannot connnect to the server. Aborting..."));
            return;
        else
            v837.socket = nil;
            v25.online = 0;
            v837.data = {};
            v837.icon_data = {};
            v837.failed_connections = v837.failed_connections + 1;
            utils.execute_after(10, v3.connect, v837.link, v837.callbacks);
            return;
        end;
    end
};
v837.send = function()
    -- upvalues: v837 (ref)
    if not v837.socket then
        return;
    else
        v837.socket:send(v837.retrieve());
        return;
    end;
end;
v837.attach = function(v862)
    -- upvalues: v165 (ref), v837 (ref)
    local v863 = v165.misc.shared.value and not v862;
    entity.get_players(false, true, function(v864)
        -- upvalues: v863 (ref), v837 (ref)
        local v865 = tostring(v864:get_xuid());
        if not v863 then
            if not v837.icon_data[v865] then
                v864:set_icon();
                v837.icon_data[v865] = true;
            end;
        else
            local v866 = v837.data[v865];
            if v866 then
                v864:set_icon(string.format("https://mishkat.cloud/exscord/icons/%s.png", v866));
                v837.icon_data[v865] = false;
            elseif not v837.icon_data[v865] then
                v864:set_icon();
                v837.icon_data[v865] = true;
            end;
        end;
    end);
end;
v837.init = function()
    -- upvalues: v3 (ref), v837 (ref), v165 (ref), v93 (ref)
    v3.connect(v837.link, v837.callbacks);
    v165.misc.shared:set_callback(v837.send);
    utils.execute_after(2, v837.send);
    v93.Shared.render:set(function()
        -- upvalues: v837 (ref)
        v837.attach();
    end);
    v93.Shared.shutdown:set(function()
        -- upvalues: v837 (ref)
        v837.attach(true);
    end);
end;
local v867 = nil;
v867 = {
    smoke_duration = 17.55, 
    smoke = 125, 
    molotov_cell_radius = 40, 
    data = {}
};
local v868 = {
    molotov_time = cvar.inferno_flame_lifetime, 
    friendly_fire = cvar.mp_friendlyfire
};
do
    local l_v868_0 = v868;
    v93["Nade Radius"].net_update_end:set(function(v870, v871)
        -- upvalues: v165 (ref), v867 (ref), l_v868_0 (ref)
        if not v165.visuals.nade_radius.value or not v871 then
            v867.data = {};
            return;
        else
            local v872 = {};
            local v873 = l_v868_0.molotov_time:float();
            local _ = globals.realtime;
            local l_tickcount_0 = globals.tickcount;
            local l_tickinterval_1 = globals.tickinterval;
            entity.get_entities("CInferno", true, function(v877)
                -- upvalues: l_tickinterval_1 (ref), l_tickcount_0 (ref), v873 (ref), v870 (ref), l_v868_0 (ref), v872 (ref), v867 (ref)
                local _ = v877:get_index();
                local l_m_fireCount_0 = v877.m_fireCount;
                if l_m_fireCount_0 and l_m_fireCount_0 > 0 then
                    local l_m_nFireEffectTickBegin_0 = v877.m_nFireEffectTickBegin;
                    if l_m_nFireEffectTickBegin_0 then
                        local v881 = l_tickinterval_1 * (l_tickcount_0 - l_m_nFireEffectTickBegin_0);
                        if v881 <= v873 then
                            local v882 = v877:get_origin();
                            local l_m_hOwnerEntity_0 = v877.m_hOwnerEntity;
                            local v884 = true;
                            if l_m_hOwnerEntity_0 and v870 then
                                v884 = l_m_hOwnerEntity_0 == v870 or not (l_v868_0.friendly_fire:int() ~= 1) or l_m_hOwnerEntity_0:is_enemy();
                            end;
                            local v885 = 0;
                            local l_m_bFireIsBurning_0 = v877.m_bFireIsBurning;
                            local v887 = {
                                x = v877.m_fireXDelta, 
                                y = v877.m_fireYDelta, 
                                z = v877.m_fireZDelta
                            };
                            local v888 = {};
                            for v889 = 0, 63 do
                                if l_m_bFireIsBurning_0[v889] then
                                    v888[#v888 + 1] = v882 + vector(v887.x[v889], v887.y[v889], v887.z[v889]);
                                end;
                            end;
                            local v890 = vector();
                            local v891 = #v888;
                            for v892 = 1, v891 do
                                v890 = v890 + v888[v892];
                            end;
                            local v893 = v890 / v891;
                            for v894 = 1, v891 do
                                local v895 = v888[v894]:dist2d(v893);
                                if v885 < v895 then
                                    v885 = v895;
                                end;
                            end;
                            if v885 ~= 0 then
                                v872[#v872 + 1] = {
                                    type = "molotov", 
                                    origin = v893, 
                                    radius = v885 + v867.molotov_cell_radius, 
                                    created_at = l_m_nFireEffectTickBegin_0, 
                                    time_alive = v881, 
                                    unsafe = v884, 
                                    max_alive = v873
                                };
                            end;
                        end;
                    end;
                end;
            end);
            entity.get_entities("CSmokeGrenadeProjectile", true, function(v896)
                -- upvalues: l_tickinterval_1 (ref), l_tickcount_0 (ref), v867 (ref), v872 (ref)
                if v896.m_bDidSmokeEffect then
                    local v897 = v896:get_origin();
                    local l_m_nSmokeEffectTickBegin_0 = v896.m_nSmokeEffectTickBegin;
                    if l_m_nSmokeEffectTickBegin_0 then
                        local v899 = l_tickinterval_1 * (l_tickcount_0 - l_m_nSmokeEffectTickBegin_0);
                        if v899 > 0 and v899 <= v867.smoke_duration then
                            v872[#v872 + 1] = {
                                type = "smoke", 
                                origin = v897, 
                                radius = smoke_radius, 
                                created_at = l_m_nSmokeEffectTickBegin_0, 
                                time_alive = v899, 
                                max_alive = v867.smoke_duration
                            };
                        end;
                    end;
                end;
            end);
            v867.data = v872;
            return;
        end;
    end);
    v93["Nade Radius"].render:set(function(_, _)
        -- upvalues: v165 (ref), v867 (ref)
        if not v165.visuals.nade_radius.value or not globals.is_in_game then
            v867.data = {};
            return;
        else
            local v902 = v165.visuals.nade_radius.items:get("Smoke");
            local l_value_20 = v165.visuals.nade_radius.smoke.value;
            local v904 = v165.visuals.nade_radius.items:get("Molotov");
            local l_value_21 = v165.visuals.nade_radius.molotov.value;
            if not v902 and not v904 then
                return;
            else
                local _ = globals.realtime;
                local l_tickcount_1 = globals.tickcount;
                local l_tickinterval_2 = globals.tickinterval;
                for v909 = 1, #v867.data do
                    local v910 = v867.data[v909];
                    if v910 then
                        local v911 = (l_tickcount_1 - v910.created_at) * l_tickinterval_2;
                        v910.time_left = v910.max_alive - v911;
                        v910.progress = (v910.max_alive - v911) / v910.max_alive;
                        local v912 = v910.origin:to_screen();
                        local l_progress_0 = v910.progress;
                        if v910.type == "smoke" then
                            if v902 then
                                local v914 = l_value_20:clone();
                                local l_smoke_0 = v867.smoke;
                                if v911 <= 0.3 then
                                    l_smoke_0 = l_smoke_0 * 0.6 + l_smoke_0 * (v911 / 0.3) * 0.4;
                                    v914 = v914:alpha_modulate(v911 / 0.3, true);
                                end;
                                if v910.time_left <= 1 then
                                    l_smoke_0 = l_smoke_0 * (v910.time_left / 1 * 0.3 + 0.7);
                                end;
                                v914 = v914.alpha_modulate(v914, math.min(1, l_progress_0 * 1.3), true);
                                render.circle_3d_outline(v910.origin, v914, l_smoke_0, 0, 1);
                            end;
                        elseif v910.type == "molotov" then
                            if v904 then
                                local v916 = math.min(1, v911 / 0.3);
                                local v917 = math.min(1, v910.time_left / 0.3);
                                local v918 = l_value_21:clone():alpha_modulate(v916, true):alpha_modulate(v917, true);
                                render.circle_3d_outline(v910.origin, v918, v910.radius * v916 * v917, 0, 1);
                            end;
                            if v912 ~= nil and v165.visuals.nade_radius.safe.value and v910.unsafe then
                                render.text(1, v912 + vector(-19, 4), color(230, 21, 21, 255 * l_progress_0), "s", "UNSAFE");
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end);
    v93["Nade Radius"].round_start:set(function()
        -- upvalues: v867 (ref)
        v867.data = {};
    end);
end;
v868 = nil;
local v919 = {
    weapon_awp = true, 
    weapon_ssg08 = true, 
    weapon_g3sg1 = true, 
    weapon_scar20 = true
};
local v920 = {
    [1] = 2, 
    [2] = 3, 
    [3] = 4, 
    [4] = 5, 
    [5] = 6
};
do
    local l_v919_0, l_v920_0 = v919, v920;
    v93["Dormant Aimbot"].createmove:set(function(v923, v924, v925)
        -- upvalues: v165 (ref), l_sv_gravity_0 (ref), l_v920_0 (ref), l_v919_0 (ref), v163 (ref), v45 (ref)
        if not v165.rage.dormant.value or not v925 then
            return;
        elseif v923.choked_commands ~= 0 then
            return;
        else
            local v926 = v924:get_player_weapon();
            if v926 == nil then
                return;
            elseif globals.curtime < v926.m_flNextPrimaryAttack then
                return;
            else
                local v927 = v924:get_eye_position();
                if v927 == nil then
                    return;
                else
                    local v928 = v926:get_weapon_info();
                    if v928.weapon_type == 0 or v928.weapon_type == 9 then
                        return;
                    else
                        local l_value_22 = v165.rage.dormant.damage.value;
                        if l_value_22 == 0 then
                            l_value_22 = l_sv_gravity_0.RAGE.min_damage:get();
                        end;
                        local v930 = v165.rage.dormant.scan.value and 4 or 3;
                        for _, v932 in next, entity.get_players() do
                            if v932:is_alive() and v932:is_enemy() and v932:is_dormant() and v932:get_network_state() ~= 0 and v930 >= v932:get_network_state() then
                                local v933 = nil;
                                local v934 = nil;
                                local v935 = -1;
                                for _, v937 in next, l_v920_0 do
                                    local v938 = v932:get_hitbox_position(v937) - vector(0, 0, 25);
                                    local v939, v940 = utils.trace_bullet(v924, v927, v938);
                                    if v939 >= v935 then
                                        v935 = v939;
                                        v934 = v940;
                                        v933 = v938;
                                    end;
                                end;
                                if v933 and utils.trace_line(v927, v933, v924, 33570827, 0).fraction ~= 1 and (v934.fraction == 1 or not v934.entity or not v934.entity:is_player() or v934.entity:is_enemy()) and v935 >= l_value_22 then
                                    if v165.rage.dormant.scope.value and l_v919_0[v928.weapon_name] and not v924.m_bIsScoped then
                                        v923.buttons = bit.bor(v923.buttons, 2048);
                                    end;
                                    v923.block_movement = 1;
                                    if v926:get_inaccuracy() <= 0.015 then
                                        local v941 = (v933 - v927):angles();
                                        if v941 then
                                            v923.view_angles = v941;
                                            v923.in_attack = true;
                                            if v165.rage.dormant.logging.value then
                                                v163:add(5, v45.string.format(string.format("\v\f<ghost>  exscord \r~ Fired at \v%s\r with \v%.f \rdamage", v932:get_name(), v935)));
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end);
end;
v919 = nil;
v919 = {
    reset = false, 
    cvar = cvar.sv_maxusrcmdprocessticks
};
v919.backups = function()
    -- upvalues: v919 (ref), l_sv_gravity_0 (ref)
    if v919.reset then
        l_sv_gravity_0.AA.fake_lag.limit:override();
        l_sv_gravity_0.AA.other.fake_duck:override();
        v919.reset = false;
    end;
end;
v165.rage.air_exploit:set_callback(function(v942)
    -- upvalues: v919 (ref)
    if v942:get() then
        v919.cvar:int(19);
    else
        v919.cvar:int(tonumber(v919.cvar:string()));
    end;
end, true);
v93["Air Exploit"].createmove:set(function(_, v944, v945)
    -- upvalues: v165 (ref), v919 (ref), v27 (ref), l_sv_gravity_0 (ref)
    if not v165.rage.air_exploit.value or not v945 then
        return v919.backups();
    elseif v27.on_ground or #v944.m_vecVelocity < 100 then
        return v919.backups();
    else
        l_sv_gravity_0.AA.fake_lag.limit:override(17);
        l_sv_gravity_0.AA.other.fake_duck:override(globals.tickcount % v165.rage.air_exploit.delay.value == 0);
        v919.reset = true;
        return;
    end;
end);
v93["Air Exploit"].shutdown:set(function()
    -- upvalues: v919 (ref)
    v919.cvar:int(tonumber(v919.cvar:string()));
end);
v920 = nil;
local v946 = {
    Frag = true, 
    Flash = true, 
    Molly = false
};
do
    local l_v946_0 = v946;
    v93["Grenade Release"].grenade_prediction:set(function(v948, v949)
        -- upvalues: v165 (ref), v27 (ref), l_v946_0 (ref)
        if not v165.misc.nade_release.value or not v949 then
            return;
        elseif v165.misc.nade_release.disabler.value and (not v27.on_ground or v27.on_land) then
            return;
        else
            local l_type_0 = v948.type;
            l_v946_0.Molly = v165.misc.nade_release.Molly.value;
            if not l_v946_0[l_type_0] then
                return;
            else
                local v951 = v949:get_player_weapon();
                if v951 == nil then
                    return;
                else
                    if v951.m_bPinPulled then
                        if l_type_0 == "Molly" then
                            if v948.damage ~= 0 then
                                cvar["-attack"]:call();
                            end;
                        elseif v948.damage >= v165.misc.nade_release[l_type_0].value or l_type_0 ~= "Flash" and v948.fatal then
                            cvar["-attack"]:call();
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end);
end;
v93.post_update_info.createmove:set(function(v952, v953, v954)
    -- upvalues: v27 (ref), v115 (ref), v165 (ref)
    if not v954 then
        return;
    else
        local v955 = v953:get_anim_state();
        if v955 == nil then
            return;
        else
            v27.in_duck = v953.m_flDuckAmount > 0.89;
            v27.velocity = v955.velocity_length_xy;
            v27.moving = v27.velocity > 5;
            v27.on_ground = v955.on_ground and not v955.landed_on_ground_this_frame;
            v27.on_land = v955.landing and v27.on_ground;
            v115.on_createmove();
            v27.condition = v115.condition(v953, v165.builder["Fake Lag"].enabled.value);
            if v952.choked_commands == 0 then
                v27.jitter = v27.jitter * -1;
                v27.jitter_count = v27.jitter_count + 1;
            end;
            return;
        end;
    end;
end);
do
    local l_v946_1 = v946;
    l_v946_1 = function()
        -- upvalues: v164 (ref), l_v946_1 (ref)
        db.exscord = v164;
        utils.execute_after(300, l_v946_1);
    end;
    events.shutdown:set(l_v946_1);
    l_v946_1();
end;
ui.sidebar("exscord", "sparkles");