local l_websockets_0 = require("neverlose/websockets");
local l_clipboard_0 = require("neverlose/clipboard");
local l_base64_0 = require("neverlose/base64");
local v3 = "\226\128\138";
local function v5(v4)
    return math.floor(v4 + 0.5);
end;
local function v8(...)
    local v6 = "";
    for v7 = 1, select("#", ...) do
        v6 = v6 .. select(v7, ...);
    end;
    return v6;
end;
local v9 = nil;
v9 = {
    cheat = "nl", 
    user = common.get_username(), 
    name = "Rebellion", 
    build = "Debug"
};
local v10 = nil;
v10 = {
    teams = {
        [1] = "Terrorist", 
        [2] = "Counter-Terrorist"
    }, 
    states = {
        [1] = "Standing", 
        [2] = "Running", 
        [3] = "Walking", 
        [4] = "Crouching", 
        [5] = "Sneaking", 
        [6] = "In Air", 
        [7] = "Air Crouch"
    }
};
local v11 = nil;
v11 = {};
local v12 = {};
do
    local l_v12_0 = v12;
    v11.get = function(v14)
        -- upvalues: l_v12_0 (ref)
        local v15 = l_v12_0[v14];
        if v15 == nil then
            v15 = ui.get_icon(v14);
            l_v12_0[v14] = v15;
        end;
        return v15;
    end;
end;
v12 = nil;
v12 = {};
local v16 = "ui\\beepclear.wav";
local v17 = "resource\\warning.wav";
local l_play_0 = cvar.play;
local v19 = "\aC0CAFFFF" .. string.lower(v9.name) .. "\aC8C8C8FF" .. " \194\183 ";
do
    local l_v16_0, l_v17_0, l_l_play_0_0, l_v19_0 = v16, v17, l_play_0, v19;
    v12.success = function(v24)
        -- upvalues: l_v19_0 (ref), l_l_play_0_0 (ref), l_v16_0 (ref)
        v24 = l_v19_0 .. "\a9AFF9AFF" .. v24;
        print_raw(v24);
        print_dev(v24);
        l_l_play_0_0:call(l_v16_0);
    end;
    v12.error = function(v25)
        -- upvalues: l_v19_0 (ref), l_l_play_0_0 (ref), l_v17_0 (ref)
        v25 = l_v19_0 .. "\aFF0032FF" .. v25;
        print_raw(v25);
        print_dev(v25);
        l_l_play_0_0:call(l_v17_0);
    end;
end;
v16 = nil;
v16 = {};
v17 = function(v26, v27, v28, v29)
    return v28 * v26 / v29 + v27;
end;
l_play_0 = function()
    return globals.frametime;
end;
v19 = function(v30, v31, v32, v33, v34)
    if v33 <= 0 then
        return v32;
    elseif v34 <= v33 then
        return v32;
    else
        v31 = v30(v33, v31, v32 - v31, v34);
        if type(v31) == "number" then
            if math.abs(v32 - v31) < 0.001 then
                return v32;
            else
                local v35 = v31 % 1;
                if v35 < 0.001 then
                    return math.floor(v31);
                elseif v35 > 0.999 then
                    return math.ceil(v31);
                end;
            end;
        end;
        return v31;
    end;
end;
do
    local l_v17_1, l_l_play_0_1, l_v19_1 = v17, l_play_0, v19;
    v16.interp = function(v39, v40, v41, v42)
        -- upvalues: l_v17_1 (ref), l_v19_1 (ref), l_l_play_0_1 (ref)
        if not v42 then
            v42 = l_v17_1;
        end;
        if type(v40) == "boolean" then
            v40 = v40 and 1 or 0;
        end;
        return l_v19_1(v42, v39, v40, l_l_play_0_1(), v41);
    end;
end;
v17 = nil;
v17 = {};
l_play_0 = ffi.typeof("        struct {\n            float x, y, z;\n        }\n    ");
v19 = ffi.typeof("        struct {\n            uint8_t r, g, b, a;\n        }\n    ");
local v43 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 20, ffi.typeof("void(__thiscall*)(void *thisptr, const $ &origin, const $ &dest, int r, int g, int b, int a, bool noDepthTest, float duration)", l_play_0, l_play_0));
local v44 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 21, "void(__thiscall*)(void *thisptr, const $ &origin, const $ &mins, const $ &maxs, const $ &angles, $ *face_color, $ *edge_color, float duration)", l_play_0, l_play_0, l_play_0, l_play_0, v19, v19);
do
    local l_l_play_0_2, l_v19_2, l_v43_0, l_v44_0 = l_play_0, v19, v43, v44;
    v17.line = function(v49, v50, v51, v52, v53)
        -- upvalues: l_l_play_0_2 (ref), l_v43_0 (ref)
        v49 = l_l_play_0_2(v49:unpack());
        v50 = l_l_play_0_2(v50:unpack());
        l_v43_0(v49, v50, v51.r, v51.g, v51.b, v51.a, v52, v53);
    end;
    v17.box_new = function(v54, v55, v56, v57, v58, v59, v60)
        -- upvalues: l_l_play_0_2 (ref), l_v19_2 (ref), l_v44_0 (ref)
        v54 = l_l_play_0_2(v54:unpack());
        v55 = l_l_play_0_2(v55:unpack());
        v56 = l_l_play_0_2(v56:unpack());
        v57 = l_l_play_0_2(v57:unpack());
        v58 = l_v19_2(v58:unpack());
        v59 = l_v19_2(v59:unpack());
        l_v44_0(v54, v55, v56, v57, v58, v59, v60);
    end;
end;
l_play_0 = nil;
l_play_0 = {};
v19 = "ws://89.169.34.90:8765";
v43 = nil;
v44 = {};
do
    local l_v19_3, l_v43_1, l_v44_1 = v19, v43, v44;
    local function v67(v64, ...)
        -- upvalues: l_v44_1 (ref)
        local v65 = l_v44_1[v64];
        if v65 == nil then
            return;
        else
            for v66 = 1, #v65 do
                v65[v66](...);
            end;
            return;
        end;
    end;
    local v79 = {
        open = function(v68)
            -- upvalues: l_v43_1 (ref), v67 (ref)
            l_v43_1 = v68;
            v67("connect", v68);
        end, 
        message = function(_, v70)
            -- upvalues: v67 (ref)
            local l_status_0, l_result_0 = pcall(json.parse, v70);
            data = l_result_0;
            success = l_status_0;
            if not success then
                return;
            else
                if type(data.event) == "string" then
                    v67(data.event, data.data);
                end;
                return;
            end;
        end, 
        close = function(_, v74, _, _)
            -- upvalues: l_v43_1 (ref), v67 (ref)
            l_v43_1 = nil;
            v67("disconnect", v74);
        end, 
        error = function(_, v78)
            -- upvalues: l_v43_1 (ref), v67 (ref)
            l_v43_1 = nil;
            v67("error", v78);
        end
    };
    local v96 = {
        connect = function(_)
            -- upvalues: l_websockets_0 (ref), l_v19_3 (ref), v79 (ref)
            l_websockets_0.connect(l_v19_3, v79);
        end, 
        close = function(_)
            -- upvalues: l_v43_1 (ref)
            if l_v43_1 == nil then
                return false;
            else
                l_v43_1:close();
                return true;
            end;
        end, 
        send_message = function(_, v83)
            -- upvalues: l_v43_1 (ref)
            if l_v43_1 == nil then
                return false;
            else
                local l_status_1, l_result_1 = pcall(json.stringify, v83);
                result = l_result_1;
                success = l_status_1;
                if not success then
                    return false;
                else
                    l_v43_1:send(result);
                    return true;
                end;
            end;
        end, 
        set_event_callback = function(_, v87, v88)
            -- upvalues: l_v44_1 (ref)
            if l_v44_1[v87] == nil then
                l_v44_1[v87] = {};
            end;
            table.insert(l_v44_1[v87], v88);
        end, 
        subscribe = function(v89, v90, v91)
            -- upvalues: l_v44_1 (ref)
            if l_v44_1[v90] == nil then
                l_v44_1[v90] = {};
            end;
            v89:send_message({
                event = v90
            });
            table.insert(l_v44_1[v90], v91);
        end, 
        interact = function(v92, v93, v94)
            local v95 = {
                event = v93
            };
            if v94 ~= nil then
                v95.data = v94;
            end;
            v92:send_message(v95);
        end
    };
    local _ = nil;
    v96:set_event_callback("connect", function(_)
        -- upvalues: v12 (ref)
        v12.success("Connected to the server");
    end);
    v96:set_event_callback("disconnect", function(_)
        -- upvalues: v12 (ref)
        v12.error("Disconnected from the server");
    end);
    v96:set_event_callback("error", function(_, _)
        -- upvalues: v12 (ref)
        v12.error("Error ocurred when connecting to the server");
    end);
    v96:connect();
    events.shutdown(function()
        -- upvalues: v96 (ref)
        v96:close();
    end);
    l_play_0 = v96;
end;
v19 = nil;
v19 = {};
v43 = string.format("%s::%s::", string.lower(v9.name), string.lower(v9.cheat));
v44 = {};
local v102 = nil;
do
    local l_v43_2, l_v44_2, l_v102_0 = v43, v44, v102;
    v19.bind = function(v106)
        -- upvalues: l_v102_0 (ref)
        l_v102_0 = v106;
    end;
    v19.push = function(v107, v108, v109)
        -- upvalues: l_v44_2 (ref)
        if l_v44_2[v107] == nil then
            l_v44_2[v107] = {};
        end;
        l_v44_2[v107][v108] = v109;
        return v109;
    end;
    v19.encode = function(v110)
        -- upvalues: l_base64_0 (ref), l_v43_2 (ref)
        local l_status_2, l_result_2 = pcall(json.stringify, v110);
        v110 = l_result_2;
        success = l_status_2;
        if not success then
            return false, "Invalid JSON";
        else
            l_status_2, l_result_2 = pcall(l_base64_0.encode, v110);
            v110 = l_result_2;
            success = l_status_2;
            if not success then
                return false, "Invalid BASE64";
            else
                v110 = string.gsub(v110, "[%+%/%=]", {
                    ["+"] = "g2134", 
                    ["="] = "_", 
                    ["/"] = "g2634"
                });
                return true, l_v43_2 .. v110;
            end;
        end;
    end;
    v19.decode = function(v113)
        -- upvalues: v9 (ref), l_base64_0 (ref)
        local v114, v115, v116 = string.match(v113, "^(%w+)::(%w+)::(.+)$");
        v113 = v116;
        cheat = v115;
        name = v114;
        if name ~= string.lower(v9.name) then
            return false, "Preset not supported!";
        elseif cheat ~= string.lower(v9.cheat) then
            return false, "Preset for another cheat!";
        else
            v113 = string.gsub(v113, "[%g2134%g2634%_]", {
                _ = "=", 
                g2634 = "/", 
                g2134 = "+"
            });
            v114, v115 = pcall(l_base64_0.decode, v113);
            v113 = v115;
            success = v114;
            if not success then
                return false, "Invalid BASE64";
            else
                v114, v115 = pcall(json.parse, v113);
                v113 = v115;
                success = v114;
                if not success then
                    return false, "Invalid JSON";
                else
                    return true, v113;
                end;
            end;
        end;
    end;
    v19.import = function(v117)
        -- upvalues: l_v102_0 (ref), l_v44_2 (ref)
        if v117 == nil then
            return false, "Preset is empty!";
        elseif type(v117) ~= "table" then
            return false, "Preset is not valid!";
        else
            local v118 = 0;
            for v119, v120 in pairs(v117) do
                if l_v102_0 == nil or l_v102_0:get(v119) then
                    local v121 = l_v44_2[v119];
                    if v121 ~= nil then
                        for v122, v123 in pairs(v120) do
                            local v124 = v121[v122];
                            if v124 ~= nil then
                                if v124:type() == "color_picker" then
                                    v123 = color(v123);
                                end;
                                pcall(v124.set, v124, v123);
                            end;
                        end;
                        v118 = v118 + 1;
                    end;
                end;
            end;
            return true, v118;
        end;
    end;
    v19.export = function()
        -- upvalues: l_v44_2 (ref)
        local v125 = {};
        for v126, v127 in pairs(l_v44_2) do
            local v128 = {};
            for v129, v130 in pairs(v127) do
                local v131 = v130:get();
                if v130:type() == "color_picker" then
                    v131 = v131:to_hex();
                end;
                v128[v129] = v131;
            end;
            v125[v126] = v128;
        end;
        return v125;
    end;
end;
v43 = nil;
v43 = {
    rage = {
        main = {
            dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
            hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
            hide_shots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
            double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
            double_tap_lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
            peek_assist = {
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style"), 
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop"), 
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode")
            }
        }, 
        selection = {
            hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
            min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
            multipoint_scale = {
                ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"), 
                ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale")
            }
        }, 
        safety = {
            body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
            safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
        }
    }, 
    antiaim = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
            yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
            yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
            avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
            hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
            yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
            modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
            body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
            inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
            freestanding_body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
            disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
            body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
            extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
            extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
            extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
        }, 
        fake_lag = {
            enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
            variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
        }, 
        misc = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    visuals = {
        world = {
            main = {
                scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
            }
        }
    }, 
    misc = {
        main = {
            in_game = {
                clan_tag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
            }, 
            other = {
                windows = ui.find("Miscellaneous", "Main", "Other", "Windows"), 
                log_events = ui.find("Miscellaneous", "Main", "Other", "Log Events"), 
                fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
};
v44 = nil;
v44 = {};
v102 = function(v132)
    -- upvalues: v3 (ref)
    return string.rep(v3, v132);
end;
local function v136(v133, v134)
    -- upvalues: v3 (ref)
    local v135 = string.rep(v3, v134);
    return v135 .. v133 .. v135;
end;
local function v139(v137, v138)
    if string.find(v137, "##") == nil then
        v137 = v137 .. "##";
    end;
    return v137 .. v138;
end;
local function v141(v140)
    -- upvalues: v8 (ref), v11 (ref)
    return v8("\a{Small Text}", v11.get(v140), "\aDEFAULT");
end;
do
    local l_v102_1, l_v136_0, l_v139_0 = v102, v136, v139;
    local function v147(v145, v146)
        -- upvalues: v8 (ref), l_v102_1 (ref)
        return v8(l_v102_1(1), v146 or "\a{Small Text}", "\226\128\162", "\aDEFAULT", l_v102_1(5), v145);
    end;
    local function v154(v148)
        local v149 = v148:get();
        local v150 = v148:list();
        local v151 = v148:type();
        local v152 = {};
        if #v149 == 0 then
            if v151 == "selectable" then
                v152 = v150;
            elseif v151 == "listable" then
                for v153 = 1, #v150 do
                    v152[v153] = v150[v153];
                end;
            end;
            v148:set(v152);
        end;
    end;
    local function _(v155)
        return function()
            -- upvalues: v155 (ref)
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(v155);
        end;
    end;
    local v157 = {};
    local v158 = v11.get("house");
    local v159 = {
        profile = ui.create(v158, "##profile", 1), 
        storage = ui.create(v158, "##storage", 1), 
        cloud = ui.create(v158, "##cloud", 2), 
        presets = ui.create(v158, "##presets", 2)
    };
    local v160 = {
        build_label = v159.profile:label(v8(l_v102_1(1), v141("signature"), l_v102_1(7), v9.name)), 
        build_button = v159.profile:button(l_v136_0(v9.build, 2), nil, true), 
        online_label = v159.profile:label(v8(l_v102_1(1), v141("users"), l_v102_1(7), "Online")), 
        online_button = v159.profile:button(l_v136_0("1", 2), nil, true)
    };
    do
        local l_v159_0, l_v160_0 = v159, v160;
        l_play_0:subscribe("get_active_connections", function(v163)
            -- upvalues: l_v160_0 (ref), l_v136_0 (ref)
            l_v160_0.online_button:name(l_v136_0(v163, 2));
        end);
        v157.profile = l_v160_0;
        local v164 = {
            storage = l_v159_0.storage:combo(v147("Storage"), {
                [1] = "Cloud", 
                [2] = "Local"
            }), 
            categories = l_v159_0.storage:selectable(v147("Categories"), {
                [1] = "Anti-Aim", 
                [2] = "Aimbot", 
                [3] = "Visuals", 
                [4] = "Miscellaneous"
            })
        };
        v154(v164.categories);
        local function v167(v165)
            -- upvalues: l_v159_0 (ref)
            local v166 = v165:get();
            l_v159_0.cloud:visibility(v166 == "Cloud");
            l_v159_0.presets:visibility(v166 == "Local");
        end;
        v164.storage:set_callback(v167, true);
        local v168 = {};
        local v169 = "http://89.169.34.90:5000/api/";
        local v170 = {};
        do
            local l_v168_0, l_v169_0 = v168, v169;
            do
                local l_l_v169_0_0, l_v170_0 = l_v169_0, v170;
                local function v179()
                    -- upvalues: l_v170_0 (ref)
                    local v175 = {};
                    for _, v177 in pairs(l_v170_0) do
                        local v178 = string.format("%s  \aFFFFFF40(%s)", v177.name, common.get_date("%d.%m.%Y %H:%M", v177.update_date));
                        table.insert(v175, v178);
                    end;
                    if #v175 == 0 then
                        return {
                            [1] = "\aFFFFFF40Empty presets list..."
                        };
                    else
                        return v175;
                    end;
                end;
                local function v186()
                    -- upvalues: l_l_v169_0_0 (ref), v12 (ref), l_v170_0 (ref), l_v168_0 (ref), v179 (ref)
                    local v180 = {
                        ["Content-Type"] = "application/json"
                    };
                    network.post(l_l_v169_0_0 .. "get", {}, v180, function(v181)
                        -- upvalues: v12 (ref), l_v170_0 (ref), l_v168_0 (ref), v179 (ref)
                        if not v181 then
                            return;
                        else
                            local l_status_3, l_result_3 = pcall(json.parse, v181);
                            data = l_result_3;
                            success = l_status_3;
                            if not success then
                                v12.error("Invalid JSON");
                                return;
                            elseif data.type == "error" or data.success == false then
                                v12.error(data.message);
                                return;
                            else
                                l_v170_0 = data;
                                table.sort(l_v170_0, function(v184, v185)
                                    return v184.update_date > v185.update_date;
                                end);
                                l_v168_0.list:update(v179());
                                return;
                            end;
                        end;
                    end);
                end;
                local function v194()
                    -- upvalues: l_v168_0 (ref), l_v170_0 (ref), l_l_v169_0_0 (ref), v12 (ref), v19 (ref), v186 (ref)
                    local v187 = l_v168_0.list:get();
                    if v187 == nil then
                        return;
                    else
                        local v188 = l_v170_0[v187];
                        if v188 == nil then
                            return;
                        else
                            local v189 = {
                                name = v188.name
                            };
                            local v190 = {
                                ["Content-Type"] = "application/json"
                            };
                            network.post(l_l_v169_0_0 .. "load", v189, v190, function(v191)
                                -- upvalues: v189 (ref), v12 (ref), v19 (ref), v186 (ref)
                                if not v191 then
                                    return;
                                else
                                    local l_status_4, l_result_4 = pcall(json.parse, v191);
                                    v189 = l_result_4;
                                    success = l_status_4;
                                    if not success then
                                        v12.error("Invalid JSON");
                                        return;
                                    elseif v189.type == "error" or v189.success == false then
                                        v12.error(v189.message);
                                        return;
                                    else
                                        l_status_4, l_result_4 = v19.decode(v189.preset);
                                        v189 = l_result_4;
                                        success = l_status_4;
                                        if not success then
                                            v12.error(v189);
                                            return;
                                        else
                                            l_status_4, l_result_4 = v19.import(v189);
                                            v189 = l_result_4;
                                            success = l_status_4;
                                            v186();
                                            if not success then
                                                v12.error(v189);
                                                return;
                                            else
                                                v12.success(string.format("%d groups successfully loaded!", v189));
                                                return;
                                            end;
                                        end;
                                    end;
                                end;
                            end);
                            return;
                        end;
                    end;
                end;
                local function v202()
                    -- upvalues: v19 (ref), v12 (ref), v9 (ref), l_l_v169_0_0 (ref), v186 (ref)
                    local v195, v196 = v19.encode(v19.export());
                    if not v195 then
                        v12.error(data);
                        return;
                    else
                        local v197 = {
                            name = v9.user, 
                            preset = v196, 
                            update_date = common.get_unixtime()
                        };
                        local v198 = {
                            ["Content-Type"] = "application/json"
                        };
                        network.post(l_l_v169_0_0 .. "upload", v197, v198, function(v199)
                            -- upvalues: v195 (ref), v197 (ref), v12 (ref), v186 (ref)
                            if not v199 then
                                return;
                            else
                                local l_status_5, l_result_5 = pcall(json.parse, v199);
                                v197 = l_result_5;
                                v195 = l_status_5;
                                if not v195 then
                                    v12.error("Invalid JSON");
                                    return;
                                elseif v197.type == "error" or v197.success == false then
                                    v12.error(v197.message);
                                    return;
                                else
                                    v186();
                                    v12.success(v197.message);
                                    return;
                                end;
                            end;
                        end);
                        return;
                    end;
                end;
                local function v208()
                    -- upvalues: v9 (ref), l_l_v169_0_0 (ref), v12 (ref), v186 (ref)
                    local v203 = {
                        name = v9.user
                    };
                    local v204 = {
                        ["Content-Type"] = "application/json"
                    };
                    network.post(l_l_v169_0_0 .. "delete", v203, v204, function(v205)
                        -- upvalues: v203 (ref), v12 (ref), v186 (ref)
                        if not v205 then
                            return;
                        else
                            local l_status_6, l_result_6 = pcall(json.parse, v205);
                            v203 = l_result_6;
                            success = l_status_6;
                            if not success then
                                v12.error("Invalid JSON");
                                return;
                            elseif v203.type == "error" or v203.success == false then
                                v12.error(v203.message);
                                return;
                            else
                                v186();
                                v12.success(v203.message);
                                return;
                            end;
                        end;
                    end);
                end;
                l_v168_0.load_button = l_v159_0.cloud:button(l_v136_0(v11.get("check"), 10), v194, false);
                l_v168_0.upload_button = l_v159_0.cloud:button(l_v136_0(v141("up-from-bracket"), 10), v202, true);
                l_v168_0.delete_button = l_v159_0.cloud:button(l_v136_0(v8("\aFF5050FF", v11.get("trash-can")), 10), v208, true);
                l_v168_0.update_button = l_v159_0.cloud:button(l_v136_0(v11.get("arrows-rotate"), 10), v186, true);
                l_v168_0.list = l_v159_0.cloud:list("##cloud.list", v179());
                v186();
                v164.cloud = l_v168_0;
            end;
            l_v169_0 = {};
            v170 = string.lower(v9.name) .. "666";
            local v209 = db[v170] or {};
            local v210 = {};
            local v211 = {};
            do
                local l_v170_1, l_v209_0, l_v210_0, l_v211_0 = v170, v209, v210, v211;
                local function v219(v216, v217)
                    -- upvalues: l_v211_0 (ref)
                    local v218 = {
                        name = v216, 
                        data = v217
                    };
                    table.insert(l_v211_0, v218);
                end;
                v219("Unmatched.gg", "rebellion::nl::eyJBaW1ib3QiOnsiYWlfcGVlay5jb2xvciI6IkMzQ0FGRkZGIiwiYWlfcGVlay5kb3RzIjo0LjAsImFpX3BlZWsuZW5hYmxlZCI6ZmFsc2UsImFpX3BlZWsuaGl0Ym94ZXMiOlsiSGVhZCIsIkNoZXN0IiwiU3RvbWFjaCIsIkFybXMiLCJMZWdzIiwiRmVldCJdLCJhaV9wZWVrLnJhZGl1cyI6NDguMCwiYWlfcGVlay53ZWFwb25zIjpbIlNTRyAwOCIsIlI4IFJldm9sdmVyIiwiRGVzZXJ0IEVhZ2xlIiwiUGlzdG9sIiwiUmlmbGUiLCJTaG90Z3VuIl0sImNsb2NrX2NvcnJlY3Rpb24uZW5hYmxlZCI6ZmFsc2UsImRvcm1hbnRfYWltYm90LmFjY3VyYWN5Ijo0MC4wLCJkb3JtYW50X2FpbWJvdC5lbmFibGVkIjpmYWxzZSwiZG9ybWFudF9haW1ib3QuaGl0Ym94ZXMiOlsiSGVhZCIsIkNoZXN0IiwiU3RvbWFjaCJdLCJkb3JtYW50X2FpbWJvdC5taW5fZGFtYWdlIjo1LjAsImZha2VfbGF0ZW5jeS5lbmFibGVkIjp0cnVlLCJsb2dfZXZlbnRzLmNvbG9yX2hpdCI6IkMzQ0FGRkZGIiwibG9nX2V2ZW50cy5jb2xvcl9taXNzIjoiRkY5MjkyRkYiLCJsb2dfZXZlbnRzLmVuYWJsZWQiOnRydWUsImxvZ19ldmVudHMub3V0cHV0IjpbIkNvbnNvbGUiLCJOb3RpZnkiXSwibWF4dXNyY21kcHJvY2Vzc3RpY2tzLmVuYWJsZWQiOmZhbHNlLCJtYXh1c3JjbWRwcm9jZXNzdGlja3MudGlja3MiOjE2LjB9LCJBbnRpLUFpbSI6eyJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmJvZHlfeWF3IjoiSml0dGVyIiwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI1LjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoXzIiOjI1LjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjo5LjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVsYXlfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlbGF5XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOm1vZGlmaWVyX29mZnNldCI6OS4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOnJpZ2h0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19hZGQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6eWF3X2xlZnQiOi0yMC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19tb2RpZmllciI6IlNwaW4iLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfcmlnaHQiOjMzLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpib2R5X3lhdyI6IkppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcGl0Y2hfMiI6MjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWxheV8yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpyaWdodF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOnlhd19hZGQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfbGVmdCI6LTIyLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfcmlnaHQiOjQ0LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpib2R5X3lhdyI6IkppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfMiI6MjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWxheV8yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6bW9kaWZpZXJfb2Zmc2V0IjotOS4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6eWF3X2xlZnQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOnlhd19vZmZzZXQiOi01LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjp5YXdfcmlnaHQiOjI2LjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6Ym9keV95YXciOiJSYW5kb21pemUgSml0dGVyIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaF8yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd18xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd18yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVsYXlfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlbGF5XzIiOjEuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOm1vZGlmaWVyX29mZnNldCI6MTMuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpyaWdodF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOnlhd19sZWZ0IjotMjcuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfbW9kaWZpZXIiOiJTcGluIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6eWF3X3JpZ2h0IjozNS4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpib2R5X3lhdyI6IkppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9lbmFibGVkIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXdfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlbGF5XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6bGVmdF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfbGVmdCI6LTE2LjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6eWF3X29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfcmlnaHQiOjQ0LjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmJvZHlfeWF3IjoiUmFuZG9taXplIEppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9lbmFibGVkIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9waXRjaF8xIjotNzUuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOi00MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjotMzMuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfeWF3XzEiOi05MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0Ijo5MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjozMC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWxheV8xIjoxLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzIiOjQuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6bGVmdF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzp5YXdfbGVmdCI6LTIzLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6eWF3X29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzp5YXdfcmlnaHQiOjM4LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6Ym9keV95YXciOiJKaXR0ZXIiLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9lbmFibGVkIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaCI6IlN3YXkiLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaF8xIjotMjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2hfMiI6MjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3IjoiU3dpdGNoIiwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3XzEiOi05MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3X29mZnNldCI6MTgwLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVsYXlfMiI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmxlZnRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6eWF3X2FkZCI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzp5YXdfbGVmdCI6LTQ0LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6eWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOnlhd19vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzp5YXdfcmlnaHQiOjQ4LjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmJvZHlfeWF3IjoiSml0dGVyIiwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX2VuYWJsZWQiOmZhbHNlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoXzEiOi0yNS4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2hfMiI6MjUuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWxheV8xIjowLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlbGF5XzIiOjAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6bGVmdF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6bW9kaWZpZXJfb2Zmc2V0Ijo5LjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfYWRkIjp0cnVlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfbGVmdCI6LTIwLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19tb2RpZmllciI6IlNwaW4iLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19yaWdodCI6MzMuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpib2R5X3lhdyI6IkppdHRlciIsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOmZhbHNlLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9mb3JjZV9kZWZlbnNpdmUiOnRydWUsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOi0yOS4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9waXRjaF8yIjoyOS4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcmFuZG9taXphdGlvbiI6OS4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3lhd18yIjo5MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlbGF5XzEiOjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWxheV8yIjowLjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6bGVmdF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpyaWdodF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfYWRkIjp0cnVlLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOnlhd19sZWZ0IjotMjIuMCwiVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIlRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOnlhd19yaWdodCI6NDQuMCwiVGVycm9yaXN0OkluIEFpcjpib2R5X3lhdyI6IkppdHRlciIsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2VuYWJsZWQiOmZhbHNlLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9mb3JjZV9kZWZlbnNpdmUiOnRydWUsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3BpdGNoXzEiOi0yOS4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaF8yIjoyOS4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcmFuZG9taXphdGlvbiI6OS4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3lhd18yIjo5MC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlbGF5XzEiOjAuMCwiVGVycm9yaXN0OkluIEFpcjpkZWxheV8yIjowLjAsIlRlcnJvcmlzdDpJbiBBaXI6bGVmdF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OkluIEFpcjptb2RpZmllcl9vZmZzZXQiOi05LjAsIlRlcnJvcmlzdDpJbiBBaXI6cmlnaHRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpJbiBBaXI6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OkluIEFpcjp5YXdfbGVmdCI6MC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiVGVycm9yaXN0OkluIEFpcjp5YXdfb2Zmc2V0IjotNS4wLCJUZXJyb3Jpc3Q6SW4gQWlyOnlhd19yaWdodCI6MjYuMCwiVGVycm9yaXN0OlJ1bm5pbmc6Ym9keV95YXciOiJSYW5kb21pemUgSml0dGVyIiwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOmZhbHNlLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV95YXdfMSI6MC4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfeWF3XzIiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWxheV8xIjowLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlbGF5XzIiOjEuMCwiVGVycm9yaXN0OlJ1bm5pbmc6bGVmdF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6bW9kaWZpZXJfb2Zmc2V0IjoxMy4wLCJUZXJyb3Jpc3Q6UnVubmluZzpyaWdodF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OlJ1bm5pbmc6eWF3X2xlZnQiOi0yNy4wLCJUZXJyb3Jpc3Q6UnVubmluZzp5YXdfbW9kaWZpZXIiOiJTcGluIiwiVGVycm9yaXN0OlJ1bm5pbmc6eWF3X29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6UnVubmluZzp5YXdfcmlnaHQiOjM1LjAsIlRlcnJvcmlzdDpTbmVha2luZzpib2R5X3lhdyI6IkppdHRlciIsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9waXRjaF8xIjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfcGl0Y2hfMiI6MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfcmFuZG9taXphdGlvbiI6MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3XzEiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXdfMiI6MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlbGF5XzEiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlbGF5XzIiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpTbmVha2luZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OlNuZWFraW5nOnlhd19sZWZ0IjotMTYuMCwiVGVycm9yaXN0OlNuZWFraW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiVGVycm9yaXN0OlNuZWFraW5nOnlhd19vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOnlhd19yaWdodCI6NDQuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmJvZHlfeWF3IjoiUmFuZG9taXplIEppdHRlciIsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9jaG9rZV8yIjoxNi4wLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTc1LjAsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfMiI6LTQwLjAsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjotMzMuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0Ijo5MC4wLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MzAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzEiOjEuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzIiOjQuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpTdGFuZGluZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19sZWZ0IjotMjMuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19yaWdodCI6MzguMCwiVGVycm9yaXN0OldhbGtpbmc6Ym9keV95YXciOiJKaXR0ZXIiLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9mb3JjZV9kZWZlbnNpdmUiOnRydWUsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaCI6IlN3YXkiLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaF8yIjoyOS4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcmFuZG9taXphdGlvbiI6OS4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3IjoiU3dpdGNoIiwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd18yIjo5MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3X29mZnNldCI6MTgwLjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlbGF5XzEiOjAuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVsYXlfMiI6MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpsZWZ0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OldhbGtpbmc6cmlnaHRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpXYWxraW5nOnlhd19hZGQiOnRydWUsIlRlcnJvcmlzdDpXYWxraW5nOnlhd19sZWZ0IjotNDQuMCwiVGVycm9yaXN0OldhbGtpbmc6eWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJUZXJyb3Jpc3Q6V2Fsa2luZzp5YXdfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpXYWxraW5nOnlhd19yaWdodCI6NDguMCwiYXZvaWRfYmFja3N0YWIuZW5hYmxlZCI6dHJ1ZSwiZmxpY2tfZXhwbG9pdC5jb25kaXRpb25zIjpbIlN0YW5kaW5nIiwiV2Fsa2luZyIsIkNyb3VjaGluZyIsIlNuZWFraW5nIl0sImZsaWNrX2V4cGxvaXQuZW5hYmxlZCI6ZmFsc2UsImZyZWVzdGFuZGluZy5kaXNhYmxlcnMiOltdLCJmcmVlc3RhbmRpbmcuZW5hYmxlZCI6ZmFsc2UsImZyZWVzdGFuZGluZy5zdGF0aWMiOmZhbHNlLCJtYW51YWxfeWF3LmRpcmVjdGlvbiI6IkRpc2FibGVkIiwibWFudWFsX3lhdy5kaXNhYmxlcnMiOltdLCJtYW51YWxfeWF3LnN0YXRpYyI6ZmFsc2UsIm1vZGlmeV9vbl93YXJtdXAuZW5hYmxlZCI6ZmFsc2UsIm9uX3VzZS5lbmFibGVkIjp0cnVlLCJzYWZlX2hlYWQuY29uZGl0aW9ucyI6WyJBaXIgS25pZmUiLCJEaXN0YW5jZSJdLCJzYWZlX2hlYWQuZW5hYmxlZCI6dHJ1ZX0sIk1pc2NlbGxhbmVvdXMiOnsiYXZvaWRfY29sbGlzaW9ucy5lbmFibGVkIjpmYWxzZSwiY2xhbnRhZy5lbmFibGVkIjpmYWxzZSwiZWRnZV9zdG9wLmVuYWJsZWQiOmZhbHNlLCJmYXN0X2xhZGRlci5lbmFibGVkIjp0cnVlLCJub19mYWxsX2RhbWFnZS5lbmFibGVkIjp0cnVlLCJzaGFyZWRfaWNvbi5lbmFibGVkIjp0cnVlLCJzaGFyZWRfaWNvbi5pY29uIjoxMi4wLCJzdXBlcl90b3NzLmVuYWJsZWQiOnRydWUsInRyYXNodGFsay5kZWxheSI6MzAuMCwidHJhc2h0YWxrLmVuYWJsZWQiOmZhbHNlLCJ1bmxvY2tfZmRfc3BlZWQuZW5hYmxlZCI6dHJ1ZX0sIlZpc3VhbHMiOnsiYW5pbWF0aW9ucy5lYXJ0aHF1YWtlIjpmYWxzZSwiYW5pbWF0aW9ucy5lbmFibGVkIjp0cnVlLCJhbmltYXRpb25zLmluX2FpciI6IlN0YXRpYyIsImFuaW1hdGlvbnMubW92ZV9sZWFuIjoxMDAuMCwiYW5pbWF0aW9ucy5vbl9ncm91bmQiOiJEaXNhYmxlZCIsImFuaW1hdGlvbnMucGl0Y2hfb25fbGFuZCI6ZmFsc2UsImFuaW1hdGlvbnMuc2xpZGluZ19jcm91Y2giOmZhbHNlLCJhbmltYXRpb25zLnNsaWRpbmdfc2xvd3dhbGsiOmZhbHNlLCJhc3BlY3RfcmF0aW8uZW5hYmxlZCI6dHJ1ZSwiYXNwZWN0X3JhdGlvLnByb3BvcnRpb24iOjEyNS4wLCJjb25zb2xlX2NvbG9yLmNvbG9yIjoiODA4MDgwRkYiLCJjb25zb2xlX2NvbG9yLmVuYWJsZWQiOnRydWUsImNyb3NzaGFpcl9pbmRpY2F0b3JzLmNvbG9yIjoiQzBDQUZGRkYiLCJjcm9zc2hhaXJfaW5kaWNhdG9ycy5lbmFibGVkIjpmYWxzZSwiY3Jvc3NoYWlyX2luZGljYXRvcnMub2Zmc2V0Ijo0MC4wLCJkYW1hZ2VfaW5kaWNhdG9yLmNvbG9yIjoiRkZGRkZGRkYiLCJkYW1hZ2VfaW5kaWNhdG9yLmVuYWJsZWQiOnRydWUsImRhbWFnZV9pbmRpY2F0b3IuZm9udCI6IlNtYWxsIiwiaGl0X21hcmtlci5jb2xvciI6IjAwRkZGRkZGIiwiaGl0X21hcmtlci5lbmFibGVkIjp0cnVlLCJoaXRfbWFya2VyLnNpemUiOjUuMCwiaGl0X21hcmtlci50aGlja25lc3MiOjIuMCwia2VlcF90cmFuc3BhcmVuY3kuZW5hYmxlZCI6dHJ1ZSwibGFnX2NvbXBfYm94LmNvbG9yIjoiMkY3NURERkYiLCJsYWdfY29tcF9ib3guZW5hYmxlZCI6dHJ1ZSwibWFudWFsX2Fycm93cy5jb2xvciI6IkMwQ0FGRkZGIiwibWFudWFsX2Fycm93cy5lbmFibGVkIjp0cnVlLCJtYW51YWxfYXJyb3dzLm9mZnNldCI6NDAuMCwibWFudWFsX2Fycm93cy5zdHlsZSI6IkxlZ2FjeSIsIm5hZGVfcmFkaXVzLmVuYWJsZWQiOnRydWUsIm5hZGVfcmFkaXVzLm1vbG90b3YiOnRydWUsIm5hZGVfcmFkaXVzLm1vbG90b3ZfY29sb3IiOiJGRjNGM0ZGRiIsIm5hZGVfcmFkaXVzLnNtb2tlIjp0cnVlLCJuYWRlX3JhZGl1cy5zbW9rZV9jb2xvciI6IjNEOTNGQUZGIiwicmVtb3ZlX2Zvb3RzdGVwc19zaGFkb3cuZW5hYmxlZCI6dHJ1ZSwic2NvcGVfb3ZlcmxheS5hZGRpdGlvbnMiOltdLCJzY29wZV9vdmVybGF5LmNvbG9yIjoiRkZGRkZGODAiLCJzY29wZV9vdmVybGF5LmVuYWJsZWQiOnRydWUsInNjb3BlX292ZXJsYXkuZXhjbHVkZV9saW5lcyI6W10sInNjb3BlX292ZXJsYXkuZ2FwIjo1LjAsInNjb3BlX292ZXJsYXkuc2l6ZSI6MjUuMCwic2tlZXRfaW5kaWNhdG9ycy5lbmFibGVkIjp0cnVlLCJza2VldF9pbmRpY2F0b3JzLml0ZW1zIjpbMS4wLDIuMCwzLjAsNC4wLDUuMCw2LjAsNy4wLDguMCw5LjAsMTAuMCwxMS4wXSwidmVsb2NpdHlfd2FybmluZy5jb2xvciI6IkMwQ0FGRkZGIiwidmVsb2NpdHlfd2FybmluZy5lbmFibGVkIjp0cnVlLCJ2ZWxvY2l0eV93YXJuaW5nLm9mZnNldCI6MTYwLjAsInZpZXdtb2RlbC5lbmFibGVkIjp0cnVlLCJ2aWV3bW9kZWwuZm92Ijo2ODAuMCwidmlld21vZGVsLm9mZnNldF94IjowLjAsInZpZXdtb2RlbC5vZmZzZXRfeSI6MC4wLCJ2aWV3bW9kZWwub2Zmc2V0X3oiOjE1LjB9fQ__");
                v219("Defensive", "rebellion::nl::eyJBaW1ib3QiOnsiYWlfcGVlay5jb2xvciI6IkMzQ0FGRkZGIiwiYWlfcGVlay5kb3RzIjo0LjAsImFpX3BlZWsuZW5hYmxlZCI6ZmFsc2UsImFpX3BlZWsuaGl0Ym94ZXMiOlsiSGVhZCIsIkNoZXN0IiwiU3RvbWFjaCIsIkFybXMiLCJMZWdzIiwiRmVldCJdLCJhaV9wZWVrLnJhZGl1cyI6NDguMCwiYWlfcGVlay53ZWFwb25zIjpbIlNTRyAwOCIsIlI4IFJldm9sdmVyIiwiRGVzZXJ0IEVhZ2xlIiwiUGlzdG9sIiwiUmlmbGUiLCJTaG90Z3VuIl0sImNsb2NrX2NvcnJlY3Rpb24uZW5hYmxlZCI6ZmFsc2UsImRvcm1hbnRfYWltYm90LmFjY3VyYWN5Ijo0MC4wLCJkb3JtYW50X2FpbWJvdC5lbmFibGVkIjpmYWxzZSwiZG9ybWFudF9haW1ib3QuaGl0Ym94ZXMiOlsiSGVhZCIsIkNoZXN0IiwiU3RvbWFjaCJdLCJkb3JtYW50X2FpbWJvdC5taW5fZGFtYWdlIjo1LjAsImZha2VfbGF0ZW5jeS5lbmFibGVkIjp0cnVlLCJsb2dfZXZlbnRzLmNvbG9yX2hpdCI6IkMzQ0FGRkZGIiwibG9nX2V2ZW50cy5jb2xvcl9taXNzIjoiRkY5MjkyRkYiLCJsb2dfZXZlbnRzLmVuYWJsZWQiOnRydWUsImxvZ19ldmVudHMub3V0cHV0IjpbIkNvbnNvbGUiLCJOb3RpZnkiXSwibWF4dXNyY21kcHJvY2Vzc3RpY2tzLmVuYWJsZWQiOmZhbHNlLCJtYXh1c3JjbWRwcm9jZXNzdGlja3MudGlja3MiOjE2LjB9LCJBbnRpLUFpbSI6eyJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmJvZHlfeWF3IjoiSml0dGVyIiwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfZW5hYmxlZCI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9waXRjaCI6IlN3YXkiLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9waXRjaF8xIjotMjUuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2hfMiI6MjUuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3IjoiU3dpdGNoIiwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3XzEiOi05MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3X29mZnNldCI6MTgwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVsYXlfMiI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOmxlZnRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6bW9kaWZpZXJfb2Zmc2V0Ijo5LjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6eWF3X2FkZCI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfbGVmdCI6LTIwLjAsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6eWF3X21vZGlmaWVyIjoiU3BpbiIsIkNvdW50ZXItVGVycm9yaXN0OkFpciBDcm91Y2g6eWF3X29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19yaWdodCI6MzMuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmJvZHlfeWF3IjoiSml0dGVyIiwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9lbmFibGVkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9waXRjaCI6IlN3YXkiLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOi0yOS4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjI5LjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjo5LjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3IjoiU3dpdGNoIiwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3X29mZnNldCI6MTgwLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVsYXlfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVsYXlfMiI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6bGVmdF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6Q3JvdWNoaW5nOm1vZGlmaWVyX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X2xlZnQiOi0yMi4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X3JpZ2h0Ijo0NC4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6Ym9keV95YXciOiJKaXR0ZXIiLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX2VuYWJsZWQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfMiI6MjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpkZWxheV8yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6bW9kaWZpZXJfb2Zmc2V0IjotOS4wLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpJbiBBaXI6eWF3X2xlZnQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6SW4gQWlyOnlhd19vZmZzZXQiOi01LjAsIkNvdW50ZXItVGVycm9yaXN0OkluIEFpcjp5YXdfcmlnaHQiOjI2LjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6Ym9keV95YXciOiJSYW5kb21pemUgSml0dGVyIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfZW5hYmxlZCI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaF8yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd18xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd18yIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6ZGVsYXlfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOmRlbGF5XzIiOjEuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOm1vZGlmaWVyX29mZnNldCI6MTMuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzpyaWdodF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpSdW5uaW5nOnlhd19sZWZ0IjotMjcuMCwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfbW9kaWZpZXIiOiJTcGluIiwiQ291bnRlci1UZXJyb3Jpc3Q6UnVubmluZzp5YXdfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlJ1bm5pbmc6eWF3X3JpZ2h0IjozNS4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpib2R5X3lhdyI6IkppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9lbmFibGVkIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXdfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzpkZWxheV8xIjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOmRlbGF5XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6bGVmdF9saW1pdCI6NjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfYWRkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfbGVmdCI6LTE2LjAsIkNvdW50ZXItVGVycm9yaXN0OlNuZWFraW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6U25lYWtpbmc6eWF3X29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTbmVha2luZzp5YXdfcmlnaHQiOjQ0LjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmJvZHlfeWF3IjoiUmFuZG9taXplIEppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9lbmFibGVkIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3BpdGNoXzEiOi03NS4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfMiI6LTQwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOi0zMy4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjkwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjMwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzEiOjEuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVsYXlfMiI6NC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6cmlnaHRfbGltaXQiOjYwLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOnlhd19hZGQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOnlhd19sZWZ0IjotMjMuMCwiQ291bnRlci1UZXJyb3Jpc3Q6U3RhbmRpbmc6eWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJDb3VudGVyLVRlcnJvcmlzdDpTdGFuZGluZzp5YXdfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OlN0YW5kaW5nOnlhd19yaWdodCI6MzguMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpib2R5X3lhdyI6IkppdHRlciIsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjI5LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjo5LjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6ZGVsYXlfMSI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOmRlbGF5XzIiOjAuMCwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzpsZWZ0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOm1vZGlmaWVyX29mZnNldCI6MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOnlhd19hZGQiOnRydWUsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6eWF3X2xlZnQiOi00NC4wLCJDb3VudGVyLVRlcnJvcmlzdDpXYWxraW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiQ291bnRlci1UZXJyb3Jpc3Q6V2Fsa2luZzp5YXdfb2Zmc2V0IjowLjAsIkNvdW50ZXItVGVycm9yaXN0OldhbGtpbmc6eWF3X3JpZ2h0Ijo0OC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpib2R5X3lhdyI6IkppdHRlciIsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV9lbmFibGVkIjp0cnVlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoXzEiOi0yNS4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcGl0Y2hfMiI6MjUuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfcmFuZG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfMSI6LTkwLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWZlbnNpdmVfeWF3X3NwZWVkIjoyMC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDpkZWxheV8xIjowLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOmRlbGF5XzIiOjAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6bGVmdF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OkFpciBDcm91Y2g6bW9kaWZpZXJfb2Zmc2V0Ijo5LjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfYWRkIjp0cnVlLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfbGVmdCI6LTIwLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19tb2RpZmllciI6IlNwaW4iLCJUZXJyb3Jpc3Q6QWlyIENyb3VjaDp5YXdfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpBaXIgQ3JvdWNoOnlhd19yaWdodCI6MzMuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpib2R5X3lhdyI6IkppdHRlciIsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOnRydWUsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcGl0Y2giOiJTd2F5IiwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTI5LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjI5LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3BpdGNoX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjo5LjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3lhdyI6IlN3aXRjaCIsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVmZW5zaXZlX3lhd19vZmZzZXQiOjE4MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6ZGVsYXlfMSI6MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOmRlbGF5XzIiOjAuMCwiVGVycm9yaXN0OkNyb3VjaGluZzpsZWZ0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOm1vZGlmaWVyX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOnlhd19hZGQiOnRydWUsIlRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X2xlZnQiOi0yMi4wLCJUZXJyb3Jpc3Q6Q3JvdWNoaW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiVGVycm9yaXN0OkNyb3VjaGluZzp5YXdfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpDcm91Y2hpbmc6eWF3X3JpZ2h0Ijo0NC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmJvZHlfeWF3IjoiSml0dGVyIiwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfY3VzdG9tX2Nob2tlIjpmYWxzZSwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfZW5hYmxlZCI6dHJ1ZSwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaCI6IlN3YXkiLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV9waXRjaF8xIjotMjkuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfMiI6MjkuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjkuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfeWF3IjoiU3dpdGNoIiwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfeWF3XzEiOi05MC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiVGVycm9yaXN0OkluIEFpcjpkZWZlbnNpdmVfeWF3X29mZnNldCI6MTgwLjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiVGVycm9yaXN0OkluIEFpcjpkZWxheV8xIjowLjAsIlRlcnJvcmlzdDpJbiBBaXI6ZGVsYXlfMiI6MC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpJbiBBaXI6bW9kaWZpZXJfb2Zmc2V0IjotOS4wLCJUZXJyb3Jpc3Q6SW4gQWlyOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6SW4gQWlyOnlhd19hZGQiOnRydWUsIlRlcnJvcmlzdDpJbiBBaXI6eWF3X2xlZnQiOjAuMCwiVGVycm9yaXN0OkluIEFpcjp5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIlRlcnJvcmlzdDpJbiBBaXI6eWF3X29mZnNldCI6LTUuMCwiVGVycm9yaXN0OkluIEFpcjp5YXdfcmlnaHQiOjI2LjAsIlRlcnJvcmlzdDpSdW5uaW5nOmJvZHlfeWF3IjoiUmFuZG9taXplIEppdHRlciIsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9jaG9rZV8xIjoxNi4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2N1c3RvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9lbmFibGVkIjpmYWxzZSwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaCI6IlN0YXRpYyIsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaF8xIjowLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaF8yIjowLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjowLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV95YXciOiJTdGF0aWMiLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWZlbnNpdmVfeWF3XzEiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd18yIjowLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6ZGVsYXlfMSI6MC4wLCJUZXJyb3Jpc3Q6UnVubmluZzpkZWxheV8yIjoxLjAsIlRlcnJvcmlzdDpSdW5uaW5nOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpSdW5uaW5nOm1vZGlmaWVyX29mZnNldCI6MTMuMCwiVGVycm9yaXN0OlJ1bm5pbmc6cmlnaHRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpSdW5uaW5nOnlhd19hZGQiOnRydWUsIlRlcnJvcmlzdDpSdW5uaW5nOnlhd19sZWZ0IjotMjcuMCwiVGVycm9yaXN0OlJ1bm5pbmc6eWF3X21vZGlmaWVyIjoiU3BpbiIsIlRlcnJvcmlzdDpSdW5uaW5nOnlhd19vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlJ1bm5pbmc6eWF3X3JpZ2h0IjozNS4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6Ym9keV95YXciOiJKaXR0ZXIiLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOmZhbHNlLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9waXRjaCI6IlN0YXRpYyIsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfcGl0Y2hfMSI6MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXciOiJTdGF0aWMiLCJUZXJyb3Jpc3Q6U25lYWtpbmc6ZGVmZW5zaXZlX3lhd18xIjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzpkZWZlbnNpdmVfeWF3XzIiOjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiVGVycm9yaXN0OlNuZWFraW5nOmRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsIlRlcnJvcmlzdDpTbmVha2luZzpkZWxheV8xIjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzpkZWxheV8yIjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzpsZWZ0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6U25lYWtpbmc6bW9kaWZpZXJfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzpyaWdodF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OlNuZWFraW5nOnlhd19hZGQiOnRydWUsIlRlcnJvcmlzdDpTbmVha2luZzp5YXdfbGVmdCI6LTE2LjAsIlRlcnJvcmlzdDpTbmVha2luZzp5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIlRlcnJvcmlzdDpTbmVha2luZzp5YXdfb2Zmc2V0IjowLjAsIlRlcnJvcmlzdDpTbmVha2luZzp5YXdfcmlnaHQiOjQ0LjAsIlRlcnJvcmlzdDpTdGFuZGluZzpib2R5X3lhdyI6IlJhbmRvbWl6ZSBKaXR0ZXIiLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2Nob2tlXzEiOjE2LjAsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfY2hva2VfMiI6MTYuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX2VuYWJsZWQiOnRydWUsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfZm9yY2VfZGVmZW5zaXZlIjp0cnVlLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfMSI6LTc1LjAsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfMiI6LTQwLjAsIlRlcnJvcmlzdDpTdGFuZGluZzpkZWZlbnNpdmVfcGl0Y2hfb2Zmc2V0IjotMzMuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV9yYW5kb21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3JhbmRvbWl6YXRpb24iOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhd18xIjotOTAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfMiI6OTAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0Ijo5MC4wLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MzAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzEiOjEuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmRlbGF5XzIiOjQuMCwiVGVycm9yaXN0OlN0YW5kaW5nOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpTdGFuZGluZzptb2RpZmllcl9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnJpZ2h0X2xpbWl0Ijo2MC4wLCJUZXJyb3Jpc3Q6U3RhbmRpbmc6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19sZWZ0IjotMjMuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19tb2RpZmllciI6IkRpc2FibGVkIiwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19vZmZzZXQiOjAuMCwiVGVycm9yaXN0OlN0YW5kaW5nOnlhd19yaWdodCI6MzguMCwiVGVycm9yaXN0OldhbGtpbmc6Ym9keV95YXciOiJKaXR0ZXIiLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfY2hva2VfMSI6MTYuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2Nob2tlXzIiOjE2LjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9jdXN0b21fY2hva2UiOmZhbHNlLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfZW5hYmxlZCI6dHJ1ZSwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX2ZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3BpdGNoIjoiU3dheSIsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaF8xIjotMjkuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3BpdGNoXzIiOjI5LjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9waXRjaF9vZmZzZXQiOjAuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3JhbmRvbV9jaG9rZSI6ZmFsc2UsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV9yYW5kb21pemF0aW9uIjo5LjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV95YXciOiJTd2l0Y2giLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3XzEiOi05MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWZlbnNpdmVfeWF3XzIiOjkwLjAsIlRlcnJvcmlzdDpXYWxraW5nOmRlZmVuc2l2ZV95YXdfb2Zmc2V0IjoxODAuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiVGVycm9yaXN0OldhbGtpbmc6ZGVsYXlfMSI6MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpkZWxheV8yIjowLjAsIlRlcnJvcmlzdDpXYWxraW5nOmxlZnRfbGltaXQiOjYwLjAsIlRlcnJvcmlzdDpXYWxraW5nOm1vZGlmaWVyX29mZnNldCI6MC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzpyaWdodF9saW1pdCI6NjAuMCwiVGVycm9yaXN0OldhbGtpbmc6eWF3X2FkZCI6dHJ1ZSwiVGVycm9yaXN0OldhbGtpbmc6eWF3X2xlZnQiOi00NC4wLCJUZXJyb3Jpc3Q6V2Fsa2luZzp5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsIlRlcnJvcmlzdDpXYWxraW5nOnlhd19vZmZzZXQiOjAuMCwiVGVycm9yaXN0OldhbGtpbmc6eWF3X3JpZ2h0Ijo0OC4wLCJhdm9pZF9iYWNrc3RhYi5lbmFibGVkIjp0cnVlLCJmbGlja19leHBsb2l0LmNvbmRpdGlvbnMiOlsiU3RhbmRpbmciLCJXYWxraW5nIiwiQ3JvdWNoaW5nIiwiU25lYWtpbmciXSwiZmxpY2tfZXhwbG9pdC5lbmFibGVkIjpmYWxzZSwiZnJlZXN0YW5kaW5nLmRpc2FibGVycyI6W10sImZyZWVzdGFuZGluZy5lbmFibGVkIjpmYWxzZSwiZnJlZXN0YW5kaW5nLnN0YXRpYyI6ZmFsc2UsIm1hbnVhbF95YXcuZGlyZWN0aW9uIjoiRGlzYWJsZWQiLCJtYW51YWxfeWF3LmRpc2FibGVycyI6W10sIm1hbnVhbF95YXcuc3RhdGljIjpmYWxzZSwibW9kaWZ5X29uX3dhcm11cC5lbmFibGVkIjpmYWxzZSwib25fdXNlLmVuYWJsZWQiOnRydWUsInNhZmVfaGVhZC5jb25kaXRpb25zIjpbIkFpciBLbmlmZSJdLCJzYWZlX2hlYWQuZW5hYmxlZCI6dHJ1ZX0sIk1pc2NlbGxhbmVvdXMiOnsiYXZvaWRfY29sbGlzaW9ucy5lbmFibGVkIjpmYWxzZSwiY2xhbnRhZy5lbmFibGVkIjpmYWxzZSwiZWRnZV9zdG9wLmVuYWJsZWQiOmZhbHNlLCJmYXN0X2xhZGRlci5lbmFibGVkIjp0cnVlLCJub19mYWxsX2RhbWFnZS5lbmFibGVkIjp0cnVlLCJzaGFyZWRfaWNvbi5lbmFibGVkIjp0cnVlLCJzaGFyZWRfaWNvbi5pY29uIjoxMi4wLCJzdXBlcl90b3NzLmVuYWJsZWQiOnRydWUsInRyYXNodGFsay5kZWxheSI6MzAuMCwidHJhc2h0YWxrLmVuYWJsZWQiOmZhbHNlLCJ1bmxvY2tfZmRfc3BlZWQuZW5hYmxlZCI6dHJ1ZX0sIlZpc3VhbHMiOnsiYW5pbWF0aW9ucy5lYXJ0aHF1YWtlIjpmYWxzZSwiYW5pbWF0aW9ucy5lbmFibGVkIjp0cnVlLCJhbmltYXRpb25zLmluX2FpciI6IlN0YXRpYyIsImFuaW1hdGlvbnMubW92ZV9sZWFuIjoxMDAuMCwiYW5pbWF0aW9ucy5vbl9ncm91bmQiOiJEaXNhYmxlZCIsImFuaW1hdGlvbnMucGl0Y2hfb25fbGFuZCI6ZmFsc2UsImFuaW1hdGlvbnMuc2xpZGluZ19jcm91Y2giOmZhbHNlLCJhbmltYXRpb25zLnNsaWRpbmdfc2xvd3dhbGsiOmZhbHNlLCJhc3BlY3RfcmF0aW8uZW5hYmxlZCI6dHJ1ZSwiYXNwZWN0X3JhdGlvLnByb3BvcnRpb24iOjEyNS4wLCJjb25zb2xlX2NvbG9yLmNvbG9yIjoiODA4MDgwRkYiLCJjb25zb2xlX2NvbG9yLmVuYWJsZWQiOnRydWUsImNyb3NzaGFpcl9pbmRpY2F0b3JzLmNvbG9yIjoiQzBDQUZGRkYiLCJjcm9zc2hhaXJfaW5kaWNhdG9ycy5lbmFibGVkIjpmYWxzZSwiY3Jvc3NoYWlyX2luZGljYXRvcnMub2Zmc2V0Ijo0MC4wLCJkYW1hZ2VfaW5kaWNhdG9yLmNvbG9yIjoiRkZGRkZGRkYiLCJkYW1hZ2VfaW5kaWNhdG9yLmVuYWJsZWQiOnRydWUsImRhbWFnZV9pbmRpY2F0b3IuZm9udCI6IlNtYWxsIiwiaGl0X21hcmtlci5jb2xvciI6IjAwRkZGRkZGIiwiaGl0X21hcmtlci5lbmFibGVkIjp0cnVlLCJoaXRfbWFya2VyLnNpemUiOjUuMCwiaGl0X21hcmtlci50aGlja25lc3MiOjIuMCwia2VlcF90cmFuc3BhcmVuY3kuZW5hYmxlZCI6dHJ1ZSwibGFnX2NvbXBfYm94LmNvbG9yIjoiMkY3NURERkYiLCJsYWdfY29tcF9ib3guZW5hYmxlZCI6dHJ1ZSwibWFudWFsX2Fycm93cy5jb2xvciI6IkMwQ0FGRkZGIiwibWFudWFsX2Fycm93cy5lbmFibGVkIjp0cnVlLCJtYW51YWxfYXJyb3dzLm9mZnNldCI6NDAuMCwibWFudWFsX2Fycm93cy5zdHlsZSI6IkxlZ2FjeSIsIm5hZGVfcmFkaXVzLmVuYWJsZWQiOnRydWUsIm5hZGVfcmFkaXVzLm1vbG90b3YiOnRydWUsIm5hZGVfcmFkaXVzLm1vbG90b3ZfY29sb3IiOiJGRjNGM0ZGRiIsIm5hZGVfcmFkaXVzLnNtb2tlIjp0cnVlLCJuYWRlX3JhZGl1cy5zbW9rZV9jb2xvciI6IjNEOTNGQUZGIiwicmVtb3ZlX2Zvb3RzdGVwc19zaGFkb3cuZW5hYmxlZCI6dHJ1ZSwic2NvcGVfb3ZlcmxheS5hZGRpdGlvbnMiOltdLCJzY29wZV9vdmVybGF5LmNvbG9yIjoiRkZGRkZGODAiLCJzY29wZV9vdmVybGF5LmVuYWJsZWQiOnRydWUsInNjb3BlX292ZXJsYXkuZXhjbHVkZV9saW5lcyI6W10sInNjb3BlX292ZXJsYXkuZ2FwIjo1LjAsInNjb3BlX292ZXJsYXkuc2l6ZSI6MjUuMCwic2tlZXRfaW5kaWNhdG9ycy5lbmFibGVkIjp0cnVlLCJza2VldF9pbmRpY2F0b3JzLml0ZW1zIjpbMS4wLDIuMCwzLjAsNC4wLDUuMCw2LjAsNy4wLDguMCw5LjAsMTAuMCwxMS4wXSwidmVsb2NpdHlfd2FybmluZy5jb2xvciI6IkMwQ0FGRkZGIiwidmVsb2NpdHlfd2FybmluZy5lbmFibGVkIjp0cnVlLCJ2ZWxvY2l0eV93YXJuaW5nLm9mZnNldCI6MTYwLjAsInZpZXdtb2RlbC5lbmFibGVkIjp0cnVlLCJ2aWV3bW9kZWwuZm92Ijo2ODAuMCwidmlld21vZGVsLm9mZnNldF94IjowLjAsInZpZXdtb2RlbC5vZmZzZXRfeSI6MC4wLCJ2aWV3bW9kZWwub2Zmc2V0X3oiOjE1LjB9fQ__");
                v219 = function(v220)
                    -- upvalues: l_v210_0 (ref)
                    for v221 = #l_v210_0, 1, -1 do
                        local v222 = l_v210_0[v221];
                        if v222.name == v220 then
                            return v222, v221;
                        end;
                    end;
                    return nil, -1;
                end;
                local function v227()
                    -- upvalues: l_v210_0 (ref), l_v211_0 (ref)
                    local v223 = {};
                    for v224, v225 in pairs(l_v210_0) do
                        local l_name_0 = v225.name;
                        if l_v211_0[v224] then
                            l_name_0 = string.format("* %s", l_name_0);
                        end;
                        table.insert(v223, l_name_0);
                    end;
                    if #v223 == 0 then
                        return {
                            [1] = "\aFFFFFF40Empty presets list..."
                        };
                    else
                        return v223;
                    end;
                end;
                local function v229(v228)
                    -- upvalues: l_v210_0 (ref)
                    return l_v210_0[v228];
                end;
                local function v234()
                    -- upvalues: l_v210_0 (ref), l_v211_0 (ref), l_v209_0 (ref), l_v169_0 (ref), v227 (ref)
                    l_v210_0 = {};
                    for _, v231 in pairs(l_v211_0) do
                        table.insert(l_v210_0, v231);
                    end;
                    for _, v233 in pairs(l_v209_0) do
                        table.insert(l_v210_0, v233);
                    end;
                    l_v169_0.list:update(v227());
                end;
                local function v240()
                    -- upvalues: l_v169_0 (ref), v219 (ref), v12 (ref), v19 (ref)
                    local v235 = l_v169_0.name:get();
                    if v235 == "" then
                        return;
                    else
                        local v236, _ = v219(v235);
                        if v236 == nil or v236.data == nil then
                            v12.error("Preset data is invalid!");
                            return;
                        else
                            local v238, v239 = v19.decode(v236.data);
                            data = v239;
                            success = v238;
                            if not success or data == nil then
                                v12.error(data);
                                return;
                            else
                                v238, v239 = v19.import(data);
                                data = v239;
                                success = v238;
                                if not success then
                                    v12.error(data);
                                    return;
                                else
                                    v12.success(string.format("%d groups successfully loaded!", data));
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;
                local function v245()
                    -- upvalues: l_v169_0 (ref), v19 (ref), v12 (ref), v219 (ref), l_v209_0 (ref), l_v211_0 (ref), l_v170_1 (ref), v234 (ref)
                    local v241 = l_v169_0.name:get();
                    if v241 == "" then
                        return;
                    else
                        local v242, v243 = v19.encode(v19.export());
                        data = v243;
                        success = v242;
                        if not success then
                            v12.error(data);
                            return;
                        else
                            v242 = {
                                name = v241, 
                                data = data
                            };
                            local v244;
                            v243, v244 = v219(v241);
                            if v243 == nil then
                                v243 = v242;
                                table.insert(l_v209_0, v242);
                            end;
                            if v244 ~= -1 and v244 <= #l_v211_0 then
                                v12.error("Can't modify built-in preset!");
                                return;
                            else
                                v243.data = data;
                                db[l_v170_1] = l_v209_0;
                                v234();
                                v12.success("Preset successfully saved!");
                                return;
                            end;
                        end;
                    end;
                end;
                local function v249()
                    -- upvalues: l_v169_0 (ref), v219 (ref), v12 (ref), l_v211_0 (ref), l_v209_0 (ref), l_v170_1 (ref), v234 (ref)
                    local v246 = l_v169_0.name:get();
                    if v246 == "" then
                        return;
                    else
                        local v247, v248 = v219(v246);
                        if v247 == nil then
                            v12.error("Preset not selected!");
                            return;
                        elseif v248 ~= -1 and v248 <= #l_v211_0 then
                            v12.error("Can't delete built-in preset!");
                            return;
                        else
                            table.remove(l_v209_0, v248 - #l_v211_0);
                            db[l_v170_1] = l_v209_0;
                            v234();
                            v12.success("Preset successfully deleted!");
                            return;
                        end;
                    end;
                end;
                local function v254()
                    -- upvalues: v19 (ref), l_clipboard_0 (ref), v12 (ref)
                    local v250, v251 = v19.decode(l_clipboard_0.get());
                    if not v250 then
                        v12.error(v251);
                        return;
                    else
                        local v252, v253 = v19.import(v251);
                        v251 = v253;
                        if not v252 then
                            v12.error(v251);
                            return;
                        else
                            v12.success(string.format("%d groups successfully imported!", v251));
                            return;
                        end;
                    end;
                end;
                local function v257()
                    -- upvalues: v19 (ref), v12 (ref), l_clipboard_0 (ref)
                    local v255, v256 = v19.encode(v19.export());
                    if not v255 then
                        v12.error(v256);
                        return;
                    else
                        l_clipboard_0.set(v256);
                        v12.success("Preset successfully exported!");
                        return;
                    end;
                end;
                l_v169_0.name = l_v159_0.presets:input("Preset Name");
                l_v169_0.load_button = l_v159_0.presets:button(l_v136_0(v11.get("check"), 5), v240, false);
                l_v169_0.save_button = l_v159_0.presets:button(l_v136_0(v141("floppy-disk"), 7), v245, true);
                l_v169_0.delete_button = l_v159_0.presets:button(l_v136_0(v8("\aFF5050FF", v11.get("trash-can")), 7), v249, true);
                l_v169_0.export_button = l_v159_0.presets:button(l_v136_0(v11.get("up-from-bracket"), 7), v257, true);
                l_v169_0.import_button = l_v159_0.presets:button(l_v136_0(v11.get("down-to-bracket"), 7), v254, true);
                l_v169_0.list = l_v159_0.presets:list("##main.list", {});
                l_v169_0.list:set_callback(function(v258)
                    -- upvalues: v229 (ref), l_v169_0 (ref)
                    local v259 = v258:get();
                    if v259 == nil or v259 <= 0 then
                        return;
                    else
                        local v260 = v229(v259);
                        if v260 == nil then
                            return;
                        else
                            l_v169_0.name:set(v260.name);
                            return;
                        end;
                    end;
                end, true);
                v234();
                v164.main = l_v169_0;
            end;
            v19.bind(v164.categories);
            v157.presets = v164;
        end;
        v44.home = v157;
    end;
    v158 = {};
    v159 = v11.get("shield");
    v160 = {
        tweaks = ui.create(v159, "##tweaks", 1), 
        angles = ui.create(v159, "##angles", 2), 
        hotkeys = ui.create(v159, "##hotkeys", 1), 
        builder = ui.create(v159, "##builder", 2), 
        defensive = ui.create(v159, "##defenive", 2)
    };
    local v261 = {
        avoid_backstab = {
            enabled = v19.push("Anti-Aim", "avoid_backstab.enabled", v160.tweaks:switch(v8(l_v102_1(2), v141("knife-kitchen"), l_v102_1(7), "Avoid Backstab")))
        }, 
        on_use = {
            enabled = v19.push("Anti-Aim", "on_use.enabled", v160.tweaks:switch(v8(l_v102_1(2), v141("user-helmet-safety"), l_v102_1(9), "On Use")))
        }, 
        modify_on_warmup = {
            enabled = v19.push("Anti-Aim", "modify_on_warmup.enabled", v160.tweaks:switch(v8(l_v102_1(2), v141("shuffle"), l_v102_1(8), "Modify on Warmup")))
        }
    };
    local v262 = {
        enabled = v19.push("Anti-Aim", "flick_exploit.enabled", v160.tweaks:switch(v8(l_v102_1(2), v141("wand-magic-sparkles"), l_v102_1(7), "Flick Exploit")))
    };
    local v263 = v262.enabled:create();
    v262.conditions = v19.push("Anti-Aim", "flick_exploit.conditions", v263:selectable("Conditions", {
        [1] = "Standing", 
        [2] = "Walking", 
        [3] = "Crouching", 
        [4] = "Sneaking"
    }));
    v261.flick_exploit = v262;
    v263 = {
        enabled = v19.push("Anti-Aim", "safe_head.enabled", v160.tweaks:switch(v8(l_v102_1(2), v141("face-head-bandage"), l_v102_1(7), "Safe Head")))
    };
    local v264 = v263.enabled:create();
    v263.conditions = v19.push("Anti-Aim", "safe_head.conditions", v264:selectable("Conditions", {
        [1] = "Standing", 
        [2] = "Crouch", 
        [3] = "Air Crouch", 
        [4] = "Air Knife", 
        [5] = "Air Taser", 
        [6] = "Distance"
    }));
    v261.safe_head = v263;
    v158.tweaks = v261;
    local v265 = {};
    local v266 = {
        enabled = v19.push("Anti-Aim", "freestanding.enabled", v160.hotkeys:switch("Freestanding"))
    };
    local v267 = v266.enabled:create();
    v266.static = v19.push("Anti-Aim", "freestanding.static", v267:switch("Static Freestanding"));
    v266.disablers = v19.push("Anti-Aim", "freestanding.disablers", v267:selectable("Disablers", {
        [1] = "Standing", 
        [2] = "Running", 
        [3] = "Walking", 
        [4] = "Crouching", 
        [5] = "Sneaking", 
        [6] = "In Air", 
        [7] = "Air Crouch"
    }));
    v265.freestanding = v266;
    v267 = {
        direction = v19.push("Anti-Aim", "manual_yaw.direction", v160.hotkeys:combo("Manual Yaw", {
            [1] = "Disabled", 
            [2] = "Left", 
            [3] = "Right", 
            [4] = "Backward", 
            [5] = "Forward"
        }))
    };
    v262 = v267.direction:create();
    v267.static = v19.push("Anti-Aim", "manual_yaw.static", v262:switch("Static Manual Yaw"));
    v267.disablers = v19.push("Anti-Aim", "manual_yaw.disablers", v262:selectable("Disablers", {
        [1] = "Standing", 
        [2] = "Running", 
        [3] = "Walking", 
        [4] = "Crouching", 
        [5] = "Sneaking", 
        [6] = "In Air", 
        [7] = "Air Crouch"
    }));
    v265.manual_yaw = v267;
    v158.hotkeys = v265;
    v266 = function()
        -- upvalues: v158 (ref), v10 (ref)
        local v268 = v158.builder.state:get();
        local v269 = v158.builder.team:get();
        for v270 = 1, #v10.teams do
            local v271 = v10.teams[v270];
            local v272 = v271 == v269;
            for v273 = 1, #v10.states do
                local v274 = v10.states[v273];
                local v275 = v274 == v268;
                local v276 = v272 and v275;
                local l_angles_0 = v158.builder[v271][v274].angles;
                l_angles_0.yaw_offset:visibility(v276);
                l_angles_0.yaw_add:visibility(v276);
                l_angles_0.yaw_modifier:visibility(v276);
                l_angles_0.body_yaw:visibility(v276);
                local l_defensive_0 = v158.builder[v271][v274].defensive;
                l_defensive_0.force_defensive:visibility(v276);
                l_defensive_0.enabled:visibility(v276);
                if not l_defensive_0.enabled:get() then
                    v276 = false;
                end;
                l_defensive_0.pitch:visibility(v276);
                l_defensive_0.yaw:visibility(v276);
            end;
        end;
    end;
    do
        local l_v160_1, l_v266_0, l_v263_0 = v160, v266, v263;
        v267 = function(v282, v283)
            -- upvalues: v19 (ref), l_v160_1 (ref), l_v139_0 (ref), v147 (ref), l_v266_0 (ref)
            local v284 = {};
            local function v286(v285)
                -- upvalues: v282 (ref), v283 (ref)
                return v282 .. ":" .. v283 .. ":defensive_" .. v285;
            end;
            v284.force_defensive = v19.push("Anti-Aim", v286("force_defensive"), l_v160_1.defensive:switch(l_v139_0(v147("Force Defensive"), v286("force_defensive"))));
            local v287 = v284.force_defensive:create();
            v284.custom_choke = v19.push("Anti-Aim", v286("custom_choke"), v287:switch("Custom Choke"));
            v284.random_choke = v19.push("Anti-Aim", v286("random_choke"), v287:switch("Randomize Choke"));
            v284.choke_1 = v19.push("Anti-Aim", v286("choke_1"), v287:slider("Choke", 1, 22, 16, nil, "t"));
            v284.choke_2 = v19.push("Anti-Aim", v286("choke_2"), v287:slider("2nd Choke", 1, 22, 16, nil, "t"));
            local v288 = nil;
            local function v290()
                -- upvalues: v284 (ref)
                local v289 = v284.force_defensive:get();
                v284.custom_choke:visibility(v289);
                if not v284.custom_choke:get() then
                    v289 = false;
                end;
                v284.random_choke:visibility(v289);
                v284.choke_1:visibility(v289);
                if not v284.random_choke:get() then
                    v289 = false;
                end;
                v284.choke_2:visibility(v289);
            end;
            v284.force_defensive:set_callback(v290);
            v284.custom_choke:set_callback(v290);
            v284.random_choke:set_callback(v290);
            v290();
            v284.enabled = v19.push("Anti-Aim", v286("enabled"), l_v160_1.defensive:switch(l_v139_0(v147("Hidden", "\a{Link Active}"), v286("enabled")))):set_callback(l_v266_0);
            v284.pitch = v19.push("Anti-Aim", v286("pitch"), l_v160_1.defensive:combo(l_v139_0(v147("Pitch"), v286("pitch")), {
                [1] = "Static", 
                [2] = "Jitter", 
                [3] = "Random", 
                [4] = "Spin", 
                [5] = "Sway"
            }));
            v288 = v284.pitch:create();
            v284.pitch_offset = v19.push("Anti-Aim", v286("pitch_offset"), v288:slider("Offset", -89, 89, 0, 1, "\194\176"));
            v284.pitch_1 = v19.push("Anti-Aim", v286("pitch_1"), v288:slider("From", -89, 89, 0, 1, "\194\176"));
            v284.pitch_2 = v19.push("Anti-Aim", v286("pitch_2"), v288:slider("To", -89, 89, 0, 1, "\194\176"));
            v290 = nil;
            local function v292()
                -- upvalues: v284 (ref)
                local v291 = v284.pitch:get();
                v284.pitch_offset:visibility(v291 == "Static");
                v284.pitch_1:visibility(v291 ~= "Static");
                v284.pitch_2:visibility(v291 ~= "Static");
            end;
            v284.pitch:set_callback(v292, true);
            v284.yaw = v19.push("Anti-Aim", v286("yaw"), l_v160_1.defensive:combo(l_v139_0(v147("Yaw"), v286("yaw")), {
                [1] = "Static", 
                [2] = "Switch", 
                [3] = "Random", 
                [4] = "Spin", 
                [5] = "Sway"
            }));
            v290 = v284.yaw:create();
            v284.yaw_offset = v19.push("Anti-Aim", v286("yaw_offset"), v290:slider("Offset", 0, 360, 180, 1, "\194\176"));
            v284.yaw_1 = v19.push("Anti-Aim", v286("yaw_1"), v290:slider("From", -180, 180, 0, 1, "\194\176"));
            v284.yaw_2 = v19.push("Anti-Aim", v286("yaw_2"), v290:slider("To", -180, 180, 0, 1, "\194\176"));
            v284.randomization = v19.push("Anti-Aim", v286("randomization"), v290:slider("Randomization", 0, 20, 0, 1, "t"));
            v284.yaw_speed = v19.push("Anti-Aim", v286("yaw_speed"), v290:slider("Speed", -50, 50, 20, 0.1));
            v292 = nil;
            local function v294()
                -- upvalues: v284 (ref)
                local v293 = v284.yaw:get();
                v284.yaw_offset:visibility(v293 == "Static" or not (v293 ~= "Spin") or v293 == "Sway");
                v284.yaw_1:visibility(v293 == "Switch" or v293 == "Random");
                v284.yaw_2:visibility(v293 == "Switch" or v293 == "Random");
                v284.randomization:visibility(v293 == "Switch");
                v284.yaw_speed:visibility(v293 == "Spin" or v293 == "Sway");
            end;
            v284.yaw:set_callback(v294, true);
            return v284;
        end;
        v262 = function(v295, v296)
            -- upvalues: v19 (ref), l_v160_1 (ref), l_v139_0 (ref), v147 (ref)
            local v297 = {};
            local function v299(v298)
                -- upvalues: v295 (ref), v296 (ref)
                return v295 .. ":" .. v296 .. ":" .. v298;
            end;
            v297.yaw_offset = v19.push("Anti-Aim", v299("yaw_offset"), l_v160_1.builder:slider(l_v139_0(v147("Yaw Offset"), v299("yaw_offset")), -180, 180, 0, nil, "\194\176"));
            v297.yaw_add = v19.push("Anti-Aim", v299("yaw_add"), l_v160_1.builder:switch(l_v139_0(v147("Yaw Add"), v299("yaw_add"))));
            local v300 = v297.yaw_add:create();
            v297.yaw_left = v19.push("Anti-Aim", v299("yaw_left"), v300:slider("Left Offset", -180, 180, 0, nil, "\194\176"));
            v297.yaw_right = v19.push("Anti-Aim", v299("yaw_right"), v300:slider("Right Offset", -180, 180, 0, nil, "\194\176"));
            local function v302()
                -- upvalues: v297 (ref)
                local v301 = v297.yaw_add:get();
                v297.yaw_left:visibility(v301);
                v297.yaw_right:visibility(v301);
            end;
            v297.yaw_add:set_callback(v302, true);
            v297.yaw_modifier = v19.push("Anti-Aim", v299("yaw_modifier"), l_v160_1.builder:combo(l_v139_0(v147("Yaw Modifier"), v299("yaw_modifier")), {
                [1] = "Disabled", 
                [2] = "Center", 
                [3] = "Offset", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "3-Way", 
                [7] = "5-Way"
            }));
            v302 = v297.yaw_modifier:create();
            v297.modifier_offset = v19.push("Anti-Aim", v299("modifier_offset"), v302:slider("Offset", -180, 180, 0, nil, "\194\176"));
            local function v304()
                -- upvalues: v297 (ref)
                local v303 = v297.yaw_modifier:get();
                v297.modifier_offset:visibility(v303 ~= "Disabled");
            end;
            v297.yaw_modifier:set_callback(v304, true);
            v297.body_yaw = v19.push("Anti-Aim", v299("body_yaw"), l_v160_1.builder:combo(l_v139_0(v147("Body Yaw"), v299("body_yaw")), {
                [1] = "Disabled", 
                [2] = "Left", 
                [3] = "Right", 
                [4] = "Jitter", 
                [5] = "Randomize Jitter"
            }));
            v304 = v297.body_yaw:create();
            v297.left_limit = v19.push("Anti-Aim", v299("left_limit"), v304:slider("Left Limit", 0, 60, 60, nil, "\194\176"));
            v297.right_limit = v19.push("Anti-Aim", v299("right_limit"), v304:slider("Right Limit", 0, 60, 60, nil, "\194\176"));
            v297.delay_1 = v19.push("Anti-Aim", v299("delay_1"), v304:slider("Delay", 0, 16, 0, nil, "t"));
            v297.delay_2 = v19.push("Anti-Aim", v299("delay_2"), v304:slider("2nd Delay", 0, 16, 0, nil, "t"));
            local function v306()
                -- upvalues: v297 (ref)
                local v305 = v297.body_yaw:get();
                v297.left_limit:visibility(v305 ~= "Disabled");
                v297.right_limit:visibility(v305 ~= "Disabled");
                v297.delay_1:visibility(v305 == "Jitter" or v305 == "Randomize Jitter");
                v297.delay_2:visibility(v305 == "Randomize Jitter");
            end;
            v297.body_yaw:set_callback(v306, true);
            return v297;
        end;
        l_v263_0 = {
            team = l_v160_1.angles:combo(v147("Team", "\a{Link Active}"), v10.teams):set_callback(l_v266_0), 
            state = l_v160_1.angles:combo(v147("State", "\a{Link Active}"), v10.states):set_callback(l_v266_0)
        };
        for v307 = 1, #v10.teams do
            local v308 = v10.teams[v307];
            local v309 = {};
            for v310 = 1, #v10.states do
                local v311 = v10.states[v310];
                v309[v311] = {};
                v309[v311].angles = v262(v308, v311);
                v309[v311].defensive = v267(v308, v311);
            end;
            l_v263_0[v308] = v309;
        end;
        v264 = function(v312)
            local v313 = {};
            for v314, v315 in pairs(v312) do
                local v316 = v312[v314];
                if v316 ~= nil then
                    v313[v314] = {};
                    for v317, _ in pairs(v315) do
                        local v319 = v316[v317];
                        if v319 ~= nil then
                            v313[v314][v317] = v319:get();
                        end;
                    end;
                end;
            end;
            return v313;
        end;
        local function v328(v320, v321)
            for v322, v323 in pairs(v320) do
                for v324, _ in pairs(v323) do
                    local v326 = v320[v322][v324];
                    local v327 = v321[v322][v324];
                    if v326 ~= nil and v327 ~= nil then
                        v326:set(v327);
                    end;
                end;
            end;
        end;
        do
            local l_v264_0, l_v328_0 = v264, v328;
            local function v337()
                -- upvalues: l_v263_0 (ref), l_v264_0 (ref), l_base64_0 (ref), l_clipboard_0 (ref), v12 (ref)
                local v331 = l_v263_0.team:get();
                local v332 = l_v263_0.state:get();
                local v333 = l_v263_0[v331][v332];
                if v333 == nil then
                    return;
                else
                    local v334 = l_v264_0(v333);
                    local l_status_7, l_result_7 = pcall(json.stringify, v334);
                    v334 = l_result_7;
                    success = l_status_7;
                    if not success then
                        return;
                    else
                        l_status_7, l_result_7 = pcall(l_base64_0.encode, v334);
                        v334 = l_result_7;
                        success = l_status_7;
                        if not success then
                            return;
                        else
                            l_clipboard_0.set(v334);
                            v12.success("State successfully exported!");
                            return;
                        end;
                    end;
                end;
            end;
            local function v342()
                -- upvalues: l_clipboard_0 (ref), l_base64_0 (ref), l_v263_0 (ref), l_v264_0 (ref), l_v328_0 (ref), v12 (ref)
                local l_status_8, l_result_8 = pcall(l_clipboard_0.get);
                data = l_result_8;
                success = l_status_8;
                if not success then
                    return;
                else
                    l_status_8, l_result_8 = pcall(l_base64_0.encode, data);
                    data = l_result_8;
                    success = l_status_8;
                    if not success then
                        return;
                    else
                        l_status_8, l_result_8 = pcall(json.stringify, data);
                        data = l_result_8;
                        success = l_status_8;
                        if not success then
                            return;
                        else
                            l_status_8 = l_v263_0.team:get();
                            l_result_8 = l_v263_0.state:get();
                            local v340 = l_v263_0[l_status_8][l_result_8];
                            if v340 == nil then
                                return;
                            else
                                local v341 = l_v264_0(v340);
                                l_v328_0(v340, v341);
                                v12.success("State successfully imported!");
                                return;
                            end;
                        end;
                    end;
                end;
            end;
            local function v348()
                -- upvalues: l_v263_0 (ref), l_v264_0 (ref), l_v328_0 (ref), v12 (ref)
                local v343 = l_v263_0.team:get();
                local v344 = l_v263_0.state:get();
                local v345 = l_v263_0[v343][v344];
                if v345 == nil then
                    return;
                else
                    local v346 = l_v264_0(v345);
                    local v347 = l_v263_0[v343 == "Counter-Terrorist" and "Terrorist" or "Counter-Terrorist"][v344];
                    if v347 == nil then
                        return;
                    else
                        l_v328_0(v347, v346);
                        v12.success("State successfully transfered to opposite team!");
                        return;
                    end;
                end;
            end;
            local v349 = l_v263_0.state:create();
            v349:button(l_v136_0(v8(v141("arrow-up-from-bracket"), l_v102_1(3), "Copy"), 5), v337, true);
            v349:button(l_v136_0(v8(v141("arrow-down-to-bracket"), l_v102_1(3), "Paste"), 5), v342, true);
            v349:button(l_v136_0(v8(v141("send-backward"), l_v102_1(3), "Send to another team"), 3), v348, true);
            v158.builder = l_v263_0;
        end;
        l_v266_0();
        v44.antiaim = v158;
    end;
    v159 = {};
    v160 = v11.get("send-backward");
    v261 = {
        category = ui.create(v160, "##category", 1), 
        aimbot = ui.create(v160, "##aimbot", 2), 
        interface = ui.create(v160, "##interface", 2), 
        visuals = ui.create(v160, "##visuals", 1), 
        misc = ui.create(v160, "##misc", 2), 
        movement = ui.create(v160, "##movement", 2), 
        shared = ui.create(v160, "##shared", 1)
    };
    v159.category = v261.category:list("##category", {
        v147("Aimbot"), 
        v147("Visuals"), 
        v147("Misc")
    });
    do
        local l_v261_0, l_v265_0, l_v266_1 = v261, v265, v266;
        l_v265_0 = function(v353)
            -- upvalues: l_v261_0 (ref)
            local v354 = v353:get();
            l_v261_0.aimbot:visibility(v354 == 1);
            l_v261_0.interface:visibility(v354 == 2);
            l_v261_0.visuals:visibility(v354 == 2);
            l_v261_0.misc:visibility(v354 == 2);
            l_v261_0.movement:visibility(v354 == 3);
            l_v261_0.shared:visibility(v354 == 3);
        end;
        l_v266_1 = function(v355)
            local v356 = v355:get();
            local v357 = v355:list();
            local v358 = {};
            for v359 = 1, #v357 do
                local v360 = v357[v359];
                if v356 == v359 then
                    v358[v359] = v360:gsub("\a{Small Text}", "\a{Link Active}");
                else
                    v358[v359] = v360:gsub("\a{Link Active}", "\a{Small Text}");
                end;
            end;
            v355:update(v358);
        end;
        v267 = function(v361)
            -- upvalues: l_v265_0 (ref), l_v266_1 (ref)
            l_v265_0(v361);
            l_v266_1(v361);
        end;
        v159.category:set_callback(v267, true);
        v262 = {};
        v263 = {
            enabled = v19.push("Aimbot", "dormant_aimbot.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(2), v141("person-rays"), l_v102_1(7), "Dormant Aimbot")))
        };
        v264 = v263.enabled:create();
        v263.hitboxes = v19.push("Aimbot", "dormant_aimbot.hitboxes", v264:selectable("Hitboxes", {
            [1] = "Head", 
            [2] = "Chest", 
            [3] = "Stomach", 
            [4] = "Legs"
        }));
        v154(v263.hitboxes);
        v263.accuracy = v19.push("Aimbot", "dormant_aimbot.accuracy", v264:slider("Accuracy", 1, 100, 60, nil, "%"));
        v263.min_damage = v19.push("Aimbot", "dormant_aimbot.min_damage", v264:slider("Min. damage", 0, 130, 10, nil, function(v362)
            if v362 == 0 then
                return "Auto";
            elseif v362 > 100 then
                return "+" .. v362;
            else
                return v362;
            end;
        end));
        v262.dormant_aimbot = v263;
        v264 = {
            enabled = v19.push("Aimbot", "ai_peek.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(2), v141("microchip-ai"), l_v102_1(7), "AI Peek")))
        };
        local v363 = v264.enabled:create();
        v264.hitboxes = v19.push("Aimbot", "ai_peek.hitboxes", v363:selectable("Hitboxes", {
            [1] = "Head", 
            [2] = "Chest", 
            [3] = "Stomach", 
            [4] = "Arms", 
            [5] = "Legs", 
            [6] = "Feet"
        }));
        v154(v264.hitboxes);
        v264.weapons = v19.push("Aimbot", "ai_peek.weapons", v363:selectable("Weapons", {
            [1] = "SSG 08", 
            [2] = "R8 Revolver", 
            [3] = "Desert Eagle", 
            [4] = "Pistol", 
            [5] = "Rifle", 
            [6] = "Shotgun"
        }));
        v154(v264.weapons);
        v264.dots = v19.push("Aimbot", "ai_peek.dots", v363:slider("Dots", 1, 10, 4));
        v264.radius = v19.push("Aimbot", "ai_peek.radius", v363:slider("Radius", 32, 64, 32));
        v264.color = v19.push("Aimbot", "ai_peek.color", v363:color_picker("Color"));
        v262.ai_peek = v264;
        v363 = {
            enabled = v19.push("Aimbot", "log_events.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(2), v141("pen-field"), l_v102_1(5), "Log Events")))
        };
        local v364 = v363.enabled:create();
        v363.output = v19.push("Aimbot", "log_events.output", v364:selectable("Output", {
            [1] = "Console", 
            [2] = "Debug", 
            [3] = "Notify"
        }));
        v363.color_hit = v19.push("Aimbot", "log_events.color_hit", v364:color_picker("Hit Color", color(195, 202, 255, 255)));
        v363.color_miss = v19.push("Aimbot", "log_events.color_miss", v364:color_picker("Miss Color", color(255, 146, 146, 255)));
        local v365 = nil;
        do
            local l_v363_0 = v363;
            local function v368()
                -- upvalues: l_v363_0 (ref)
                local v367 = l_v363_0.enabled:get();
                l_v363_0.output:visibility(v367);
                if #l_v363_0.output:get() == 0 then
                    v367 = false;
                end;
                l_v363_0.color_hit:visibility(v367);
                l_v363_0.color_miss:visibility(v367);
            end;
            l_v363_0.output:set_callback(v368);
            l_v363_0.enabled:set_callback(v368);
            v368();
            v262.log_events = l_v363_0;
            v262.clock_correction = {
                enabled = v19.push("Aimbot", "clock_correction.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(1), " ", v141("clock"), l_v102_1(7), "Clock Correction")))
            };
            v365 = {
                enabled = v19.push("Aimbot", "maxusrcmdprocessticks.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(1), " ", v141("code-compare"), l_v102_1(7), "Max User Process Ticks")))
            };
            v368 = v365.enabled:create();
            v365.ticks = v19.push("Aimbot", "maxusrcmdprocessticks.ticks", v368:slider("Value", 8, 32, 16, nil, function(v369)
                if v369 == 16 then
                    return "Default";
                else
                    return v369 .. "t";
                end;
            end));
            local _ = nil;
            do
                local l_v368_0 = v368;
                local function v373(v372)
                    -- upvalues: l_v368_0 (ref)
                    l_v368_0:visibility(v372:get());
                end;
                v365.enabled:set_callback(v373, true);
                v262.maxusrcmdprocessticks = v365;
            end;
            v262.fake_latency = {
                enabled = v19.push("Aimbot", "fake_latency.enabled", l_v261_0.aimbot:switch(v8(l_v102_1(2), " ", v141("satellite-dish"), l_v102_1(6), "Unlock Fake Latency")))
            };
            v159.aimbot = v262;
        end;
        v263 = {};
        v264 = {
            enabled = v19.push("Visuals", "crosshair_indicators.enabled", l_v261_0.interface:switch(v8(l_v102_1(2), v141("crosshairs"), l_v102_1(7), "Crosshair Indicators")))
        };
        v363 = v264.enabled:create();
        v264.offset = v19.push("Visuals", "crosshair_indicators.offset", v363:slider("Offset", 0, 200, 40, nil, "px"));
        v264.color = v19.push("Visuals", "crosshair_indicators.color", v363:color_picker("Color", color(192, 202, 255, 255)));
        v364 = nil;
        do
            local l_v363_1 = v363;
            v365 = function(v375)
                -- upvalues: l_v363_1 (ref)
                l_v363_1:visibility(v375:get());
            end;
            v264.enabled:set_callback(v365, true);
            v263.crosshair_indicators = v264;
        end;
        v363 = {
            enabled = v19.push("Visuals", "manual_arrows.enabled", l_v261_0.interface:switch(v8(l_v102_1(2), v141("location-arrow"), l_v102_1(8), "Manual Arrows")))
        };
        v364 = v363.enabled:create();
        v363.style = v19.push("Visuals", "manual_arrows.style", v364:combo("Style", {
            [1] = "Legacy", 
            [2] = "TeamSkeet", 
            [3] = "Renewed"
        }));
        v363.offset = v19.push("Visuals", "manual_arrows.offset", v364:slider("Offset", 0, 200, 40, nil, "px"));
        v363.color = v19.push("Visuals", "manual_arrows.color", v364:color_picker("Color", color(255, 255, 255, 255)));
        v365 = nil;
        do
            local l_v364_0 = v364;
            local function v378(v377)
                -- upvalues: l_v364_0 (ref)
                l_v364_0:visibility(v377:get());
            end;
            v363.enabled:set_callback(v378, true);
            v263.manual_arrows = v363;
        end;
        v364 = {
            enabled = v19.push("Visuals", "damage_indicator.enabled", l_v261_0.interface:switch(v8(l_v102_1(2), v141("hundred-points"), l_v102_1(7), "Damage Indicator")))
        };
        v365 = v364.enabled:create();
        v364.font = v19.push("Visuals", "damage_indicator.font", v365:combo("Font", {
            [1] = "Small", 
            [2] = "Pixel", 
            [3] = "Bold"
        }));
        v364.color = v19.push("Visuals", "damage_indicator.color", v365:color_picker("Color", color(255, 255, 255, 255)));
        local v379 = nil;
        do
            local l_v365_0 = v365;
            local function v382(v381)
                -- upvalues: l_v365_0 (ref)
                l_v365_0:visibility(v381:get());
            end;
            v364.enabled:set_callback(v382, true);
            v263.damage_indicator = v364;
        end;
        v365 = {
            enabled = v19.push("Visuals", "velocity_warning.enabled", l_v261_0.interface:switch(v8(l_v102_1(1), " ", v141("chart-line"), l_v102_1(5), " ", "Velocity Warning")))
        };
        v379 = v365.enabled:create();
        local v383 = render.screen_size();
        v365.offset = v19.push("Visuals", "velocity_warning.offset", v379:slider("Offset", 0, v383.y * 0.5, 160));
        v365.color = v19.push("Visuals", "velocity_warning.color", v379:color_picker("Color", color(192, 202, 255, 255)));
        local v384 = nil;
        do
            local l_v379_0 = v379;
            local function v387(v386)
                -- upvalues: l_v379_0 (ref)
                l_v379_0:visibility(v386:get());
            end;
            v365.enabled:set_callback(v387, true);
            v263.velocity_warning = v365;
        end;
        v379 = {
            enabled = v19.push("Visuals", "skeet_indicators.enabled", l_v261_0.interface:switch(v8(l_v102_1(3), v141("scanner-touchscreen"), l_v102_1(6), "Skeet Indicators")))
        };
        v383 = v379.enabled:create();
        v379.items = v19.push("Visuals", "skeet_indicators.items", v383:listable("##skeet_indicators.items", {
            [1] = "PING", 
            [2] = "DT", 
            [3] = "OSAA", 
            [4] = "DUCK", 
            [5] = "DA", 
            [6] = "SAFE", 
            [7] = "BODY", 
            [8] = "MD", 
            [9] = "HC", 
            [10] = "FS", 
            [11] = "Bomb Information"
        }));
        v154(v379.items);
        v384 = nil;
        do
            local l_v383_0 = v383;
            local function v390(v389)
                -- upvalues: l_v383_0 (ref)
                l_v383_0:visibility(v389:get());
            end;
            v379.enabled:set_callback(v390, true);
            v263.skeet_indicators = v379;
        end;
        v383 = {
            enabled = v19.push("Visuals", "animations.enabled", l_v261_0.visuals:switch(v8(l_v102_1(3), v141("layer-group"), l_v102_1(8), "Animations")))
        };
        v384 = v383.enabled:create();
        local v391 = {
            [1] = "Disabled", 
            [2] = "Static", 
            [3] = "Walking", 
            [4] = "Jitter", 
            [5] = "Kangaroo"
        };
        v383.on_ground = v19.push("Visuals", "animations.on_ground", v384:combo("On Ground", v391));
        v383.in_air = v19.push("Visuals", "animations.in_air", v384:combo("In Air", v391));
        v383.pitch_on_land = v19.push("Visuals", "animations.pitch_on_land", v384:switch("0 Pitch on Land"));
        v383.sliding_slowwalk = v19.push("Visuals", "animations.sliding_slowwalk", v384:switch("Sliding Slow Walk"));
        v383.sliding_crouch = v19.push("Visuals", "animations.sliding_crouch", v384:switch("Sliding Crouch"));
        v383.earthquake = v19.push("Visuals", "animations.earthquake", v384:switch("Earthquake"));
        v383.move_lean = v19.push("Visuals", "animations.move_lean", v384:slider("Move Lean", 0, 100, 0, nil, "%"));
        v391 = nil;
        do
            local l_v384_0 = v384;
            local function v394(v393)
                -- upvalues: l_v384_0 (ref)
                l_v384_0:visibility(v393:get());
            end;
            v383.enabled:set_callback(v394, true);
            v263.animations = v383;
        end;
        v384 = {
            enabled = v19.push("Visuals", "hit_marker.enabled", l_v261_0.visuals:switch(v8(l_v102_1(2), " ", v141("xmark-large"), l_v102_1(7), " ", "Hit Marker")))
        };
        v391 = v384.enabled:create();
        v384.size = v19.push("Visuals", "hit_marker.size", v391:slider("Size", 2, 5, 4, nil, "px"));
        v384.thickness = v19.push("Visuals", "hit_marker.thickness", v391:slider("Thickness", 1, 5, 2, nil, "px"));
        v384.color = v19.push("Visuals", "hit_marker.color", v391:color_picker("Color", color(0, 255, 255, 255)));
        local v395 = nil;
        do
            local l_v391_0 = v391;
            local function v398(v397)
                -- upvalues: l_v391_0 (ref)
                l_v391_0:visibility(v397:get());
            end;
            v384.enabled:set_callback(v398, true);
            v263.hit_marker = v384;
        end;
        v391 = {
            enabled = v19.push("Visuals", "scope_overlay.enabled", l_v261_0.visuals:switch(v8(l_v102_1(3), v141("crosshairs-simple"), l_v102_1(8), "Scope Overlay")))
        };
        v395 = v391.enabled:create();
        v391.additions = v19.push("Visuals", "scope_overlay.additions", v395:selectable("Additions", {
            [1] = "Inverted", 
            [2] = "Rotated", 
            [3] = "Spread Dependency"
        }));
        v391.exclude_lines = v19.push("Visuals", "scope_overlay.exclude_lines", v395:selectable("Exclude Lines", {
            [1] = "Left", 
            [2] = "Right", 
            [3] = "Top", 
            [4] = "Bottom"
        }));
        v391.size = v19.push("Visuals", "scope_overlay.size", v395:slider("Size", 0, 300, 50, nil, "px"));
        v391.gap = v19.push("Visuals", "scope_overlay.gap", v395:slider("Gap", 0, 300, 5, nil, "px"));
        v391.color = v19.push("Visuals", "scope_overlay.color", v395:color_picker("Color", color(255, 255, 255, 255)));
        local v399 = nil;
        do
            local l_v395_0 = v395;
            local function v402(v401)
                -- upvalues: l_v395_0 (ref)
                l_v395_0:visibility(v401:get());
            end;
            v391.enabled:set_callback(v402, true);
            v263.scope_overlay = v391;
        end;
        v395 = {
            enabled = v19.push("Visuals", "nade_radius.enabled", l_v261_0.visuals:switch(v8(l_v102_1(2), " ", v141("fire"), l_v102_1(7), " ", "Nade Radius")))
        };
        v399 = v395.enabled:create();
        v395.molotov = v19.push("Visuals", "nade_radius.molotov", v399:switch("Molotov"));
        v395.molotov_color = v19.push("Visuals", "nade_radius.molotov_color", v395.molotov:color_picker(color(255, 63, 63, 255)));
        v395.smoke = v19.push("Visuals", "nade_radius.smoke", v399:switch("Smoke"));
        v395.smoke_color = v19.push("Visuals", "nade_radius.smoke_color", v395.smoke:color_picker(color(61, 147, 250, 255)));
        local v403 = nil;
        do
            local l_v399_0 = v399;
            local function v406(v405)
                -- upvalues: l_v399_0 (ref)
                l_v399_0:visibility(v405:get());
            end;
            v395.enabled:set_callback(v406, true);
            v263.nade_radius = v395;
        end;
        v399 = {
            enabled = v19.push("Visuals", "lag_comp_box.enabled", l_v261_0.visuals:switch(v8(l_v102_1(2), " ", v141("box"), l_v102_1(7), " ", "Lag Comp Box")))
        };
        v403 = v399.enabled:create();
        v399.color = v19.push("Visuals", "lag_comp_box.color", v403:color_picker("Color", color(47, 117, 221, 255)));
        local v407 = nil;
        do
            local l_v403_0 = v403;
            local function v410(v409)
                -- upvalues: l_v403_0 (ref)
                l_v403_0:visibility(v409:get());
            end;
            v399.enabled:set_callback(v410, true);
            v263.lag_comp_box = v399;
        end;
        v403 = {
            enabled = v19.push("Visuals", "console_color.enabled", l_v261_0.visuals:switch(v8(l_v102_1(3), v141("rectangle-terminal"), l_v102_1(8), "Console Color")))
        };
        v403.color = v19.push("Visuals", "console_color.color", v403.enabled:color_picker(color(128, 128, 128, 255)));
        v407 = nil;
        do
            local l_v403_1, l_v407_0 = v403, v407;
            local function v414(v413)
                -- upvalues: l_v403_1 (ref)
                l_v403_1.color:visibility(v413:get());
            end;
            l_v403_1.enabled:set_callback(v414, true);
            v263.console_color = l_v403_1;
            l_v407_0 = {
                enabled = v19.push("Visuals", "aspect_ratio.enabled", l_v261_0.misc:switch(v8(l_v102_1(2), v141("tv"), l_v102_1(7), "Aspect Ratio")))
            };
            v414 = l_v407_0.enabled:create();
            local v415 = {
                [1] = "5:4", 
                [2] = "4:3", 
                [3] = "3:2", 
                [4] = "16:10", 
                [5] = "16:9"
            };
            local v416 = {
                ["4:3"] = 133, 
                ["5:4"] = 125, 
                ["16:9"] = 177, 
                ["16:10"] = 160, 
                ["3:2"] = 150
            };
            local v417 = {};
            for v418 = 1, #v415 do
                local v419 = v415[v418];
                v417[v416[v419]] = v419;
            end;
            do
                local l_v417_0 = v417;
                local function v422(v421)
                    -- upvalues: l_v417_0 (ref)
                    if v421 == 0 then
                        return "Off";
                    else
                        return l_v417_0[v421];
                    end;
                end;
                l_v407_0.proportion = v19.push("Visuals", "aspect_ratio.proportion", v414:slider("Aspect Ratio", 0, 200, 0, 0.01, v422));
                for v423 = 1, #v415 do
                    local v424 = v415[v423];
                    local v425 = v416[v424];
                    do
                        local l_v425_0 = v425;
                        local function v427()
                            -- upvalues: l_v407_0 (ref), l_v425_0 (ref)
                            l_v407_0.proportion:set(l_v425_0);
                        end;
                        v414:button(l_v136_0(v424, 3), v427, true);
                    end;
                end;
            end;
            v415 = nil;
            do
                local l_v414_0 = v414;
                v416 = function(v429)
                    -- upvalues: l_v414_0 (ref)
                    l_v414_0:visibility(v429:get());
                end;
                l_v407_0.enabled:set_callback(v416, true);
                v263.aspect_ratio = l_v407_0;
            end;
            v414 = {
                enabled = v19.push("Visuals", "viewmodel.enabled", l_v261_0.misc:switch(v8(l_v102_1(3), v141("hand"), l_v102_1(8), "Viewmodel")))
            };
            v415 = v414.enabled:create();
            v414.fov = v19.push("Visuals", "viewmodel.fov", v415:slider("Field of View", 0, 1000, 680, 0.1, "\194\176"));
            v414.offset_x = v19.push("Visuals", "viewmodel.offset_x", v415:slider("Offset X", -100, 100, 25, 0.1, "\194\176"));
            v414.offset_y = v19.push("Visuals", "viewmodel.offset_y", v415:slider("Offset Y", -100, 100, 0, 0.1, "\194\176"));
            v414.offset_z = v19.push("Visuals", "viewmodel.offset_z", v415:slider("Offset Z", -100, 100, -15, 0.1, "\194\176"));
            v415:button("Reset", function()
                -- upvalues: v414 (ref)
                v414.fov:reset();
                v414.offset_x:reset();
                v414.offset_y:reset();
                v414.offset_z:reset();
            end, true);
            v416 = nil;
            do
                local l_v415_0 = v415;
                v417 = function(v431)
                    -- upvalues: l_v415_0 (ref)
                    l_v415_0:visibility(v431:get());
                end;
                v414.enabled:set_callback(v417, true);
                v263.viewmodel = v414;
            end;
            v263.keep_transparency = {
                enabled = v19.push("Visuals", "keep_transparency.enabled", l_v261_0.misc:switch(v8(l_v102_1(2), " ", v141("transporter-2"), l_v102_1(6), " ", "Keep Transparency")))
            };
            v263.remove_footsteps_shadow = {
                enabled = v19.push("Visuals", "remove_footsteps_shadow.enabled", l_v261_0.misc:switch(v8(l_v102_1(3), v141("shoe-prints"), l_v102_1(6), "Remove Footsteps Shadow")))
            };
            v159.visuals = v263;
        end;
        v264 = {
            avoid_collisions = {
                enabled = v19.push("Miscellaneous", "avoid_collisions.enabled", l_v261_0.movement:switch(v8(l_v102_1(4), v141("person-rays"), l_v102_1(7), "Avoid Collisions")))
            }, 
            fast_ladder = {
                enabled = v19.push("Miscellaneous", "fast_ladder.enabled", l_v261_0.movement:switch(v8(l_v102_1(3), v141("water-ladder"), l_v102_1(7), "Fast Ladder")))
            }, 
            super_toss = {
                enabled = v19.push("Miscellaneous", "super_toss.enabled", l_v261_0.movement:switch(v8(l_v102_1(4), v141("bomb"), l_v102_1(7), "Super Toss")))
            }, 
            edge_stop = {
                enabled = v19.push("Miscellaneous", "edge_stop.enabled", l_v261_0.movement:switch(v8(l_v102_1(3), v141("person-falling-burst"), l_v102_1(6), "Edge Stop")))
            }, 
            no_fall_damage = {
                enabled = v19.push("Miscellaneous", "no_fall_damage.enabled", l_v261_0.movement:switch(v8(l_v102_1(2), v141("person-arrow-up-from-line"), l_v102_1(7), "No Fall Damage")))
            }, 
            unlock_fd_speed = {
                enabled = v19.push("Miscellaneous", "unlock_fd_speed.enabled", l_v261_0.movement:switch(v8(l_v102_1(3), v141("duck"), l_v102_1(8), "Unlock FD Speed")))
            }
        };
        v391 = {
            enabled = v19.push("Miscellaneous", "trashtalk.enabled", l_v261_0.shared:switch(v8(l_v102_1(4), v141("trash-can"), l_v102_1(8), "Trashtalk")))
        };
        v395 = v391.enabled:create();
        v391.delay = v19.push("Miscellaneous", "trashtalk.delay", v395:slider("Delay", 0, 50, 30, 0.1, "s"));
        v399 = nil;
        do
            local l_v395_1 = v395;
            v403 = function(v433)
                -- upvalues: l_v395_1 (ref)
                l_v395_1:visibility(v433:get());
            end;
            v391.enabled:set_callback(v403, true);
            v264.trashtalk = v391;
        end;
        v264.clantag = {
            enabled = v19.push("Miscellaneous", "clantag.enabled", l_v261_0.shared:switch(v8(l_v102_1(3), v141("tags"), l_v102_1(8), "Clantag")))
        };
        v399 = {
            enabled = v19.push("Miscellaneous", "shared_icon.enabled", l_v261_0.shared:switch(v8(l_v102_1(3), v141("icons"), l_v102_1(8), "Shared Icon")))
        };
        v403 = v399.enabled:create();
        v399.icon = v19.push("Miscellaneous", "shared_icon.icon", v403:list("##shared_icon.icon", {
            [1] = "Loading..."
        }));
        v407 = nil;
        do
            local l_v403_2 = v403;
            local function v436(v435)
                -- upvalues: l_v403_2 (ref)
                l_v403_2:visibility(v435:get());
            end;
            v399.enabled:set_callback(v436, true);
            v264.shared_icon = v399;
        end;
        v159.misc = v264;
        v44.other = v159;
    end;
end;
v102 = nil;
v102 = {
    is_moving = false, 
    is_onground = false, 
    is_crouched = false, 
    sent_packets = 0, 
    duck_amount = 0, 
    velocity2d_sqr = 0, 
    side = -1, 
    desync_delta = 0
};
v136 = function(v437)
    -- upvalues: v102 (ref)
    local v438 = entity.get_local_player();
    if v438 == nil then
        return;
    else
        local l_m_fFlags_0 = v438.m_fFlags;
        local l_m_vecVelocity_0 = v438.m_vecVelocity;
        local l_m_flDuckAmount_0 = v438.m_flDuckAmount;
        local v442 = bit.band(l_m_fFlags_0, 1) ~= 0;
        local v443 = math.abs(v438.m_flPoseParameter[11] * 2 - 1);
        local v444 = l_m_vecVelocity_0:length2dsqr();
        v102.is_moving = v444 > 25;
        v102.is_onground = v442;
        if v437.choked_commands == 0 then
            v102.sent_packets = v102.sent_packets + 1;
            v102.is_crouched = l_m_flDuckAmount_0 > 0.5;
            v102.duck_amount = l_m_flDuckAmount_0;
            v102.desync_delta = v443;
        end;
        v102.velocity2d_sqr = v444;
        if v437.sidemove ~= 0 then
            v102.side = v437.sidemove < 0 and -1 or 1;
        end;
        return;
    end;
end;
events.createmove(v136);
v136 = nil;
v136 = {};
v139 = {};
v141 = 0;
do
    local l_v139_1, l_v141_0 = v139, v141;
    local function v448(v447)
        -- upvalues: l_v141_0 (ref), l_v139_1 (ref)
        l_v141_0 = l_v141_0 + 1;
        l_v139_1[l_v141_0] = v447;
    end;
    local function v450()
        -- upvalues: l_v141_0 (ref), l_v139_1 (ref)
        for v449 = 1, l_v141_0 do
            l_v139_1[v449] = nil;
        end;
        l_v141_0 = 0;
    end;
    local function v451()
        -- upvalues: v102 (ref), v448 (ref), v43 (ref)
        if not v102.is_onground then
            return;
        elseif v102.is_moving then
            v448("Running");
            if v102.is_crouched then
                return;
            else
                if v43.antiaim.misc.slow_walk:get() then
                    v448("Walking");
                end;
                return;
            end;
        else
            v448("Standing");
            return;
        end;
    end;
    local function v452()
        -- upvalues: v102 (ref), v448 (ref)
        if not v102.is_crouched then
            return;
        else
            v448("Crouching");
            if v102.is_moving then
                v448("Sneaking");
            end;
            return;
        end;
    end;
    local function v453()
        -- upvalues: v102 (ref), v448 (ref)
        if v102.is_onground then
            return;
        else
            v448("In Air");
            if v102.is_crouched then
                v448("Air Crouch");
            end;
            return;
        end;
    end;
    v136.get = function()
        -- upvalues: l_v139_1 (ref)
        return l_v139_1[#l_v139_1];
    end;
    local function v454()
        -- upvalues: v450 (ref), v451 (ref), v452 (ref), v453 (ref)
        v450();
        v451();
        v452();
        v453();
    end;
    events.createmove(v454);
end;
v139 = nil;
v139 = {
    get = function()
        local v455 = entity.get_local_player();
        if v455 == nil then
            return;
        else
            local l_m_iTeamNum_0 = v455.m_iTeamNum;
            if l_m_iTeamNum_0 == 2 then
                return "Terrorist";
            elseif l_m_iTeamNum_0 == 3 then
                return "Counter-Terrorist";
            else
                return;
            end;
        end;
    end
};
v141 = nil;
v141 = {};
local function v461(v457)
    local v458 = {};
    local v459 = 0;
    for v460 in string.gmatch(v457, ".[\128-\191]*") do
        v459 = v459 + 1;
        v458[v459] = v460;
    end;
    return v458, v459;
end;
do
    local l_v461_0 = v461;
    v141.gradient = function(v463, v464, v465, v466)
        -- upvalues: l_v461_0 (ref)
        local v467 = {};
        local v468, v469 = l_v461_0(v463);
        local v470 = 1 / (v469 - 1);
        local v471 = v466.r - v465.r;
        local v472 = v466.g - v465.g;
        local v473 = v466.b - v465.b;
        local v474 = v466.a - v465.a;
        for v475 = 1, v469 do
            local v476 = v468[v475];
            local v477 = v464 % 2;
            if v477 > 1 then
                v477 = 2 - v477;
            end;
            local v478 = v465.r + v477 * v471;
            local v479 = v465.g + v477 * v472;
            local v480 = v465.b + v477 * v473;
            local v481 = v465.a + v477 * v474;
            local v482 = color(v478, v479, v480, v481):to_hex();
            table.insert(v467, "\a");
            table.insert(v467, v482);
            table.insert(v467, v476);
            v464 = v464 + v470;
        end;
        return table.concat(v467);
    end;
end;
v461 = nil;
local v483 = nil;
v483 = {};
local v484 = 0;
local v485 = false;
local v486 = false;
local v487 = 0;
local v488 = {};
local l_angles_1 = v43.antiaim.angles;
local function v491(v490)
    v490:override(nil);
end;
local function v493(v492, ...)
    if ... == nil then
        return;
    else
        v492:override(...);
        return;
    end;
end;
local v494 = {};
v494.__index = v494;
v494.clear = function(v495)
    for v496 in pairs(v495) do
        v495[v496] = nil;
    end;
end;
v494.copy = function(v497, v498)
    for v499, v500 in pairs(v498) do
        v497[v499] = v500;
    end;
end;
do
    local l_l_angles_1_0, l_v491_0, l_v493_0 = l_angles_1, v491, v493;
    v494.unset = function(_)
        -- upvalues: l_v491_0 (ref), l_l_angles_1_0 (ref)
        l_v491_0(l_l_angles_1_0.extended_roll);
        l_v491_0(l_l_angles_1_0.extended_pitch);
        l_v491_0(l_l_angles_1_0.extended_angles);
        l_v491_0(l_l_angles_1_0.body_freestanding);
        l_v491_0(l_l_angles_1_0.disable_yaw_modifiers);
        l_v491_0(l_l_angles_1_0.freestanding);
        l_v491_0(l_l_angles_1_0.freestanding_body_yaw);
        l_v491_0(l_l_angles_1_0.options);
        l_v491_0(l_l_angles_1_0.right_limit);
        l_v491_0(l_l_angles_1_0.left_limit);
        l_v491_0(l_l_angles_1_0.inverter);
        l_v491_0(l_l_angles_1_0.body_yaw);
        l_v491_0(l_l_angles_1_0.modifier_offset);
        l_v491_0(l_l_angles_1_0.yaw_modifier);
        l_v491_0(l_l_angles_1_0.hidden);
        l_v491_0(l_l_angles_1_0.avoid_backstab);
        l_v491_0(l_l_angles_1_0.yaw_offset);
        l_v491_0(l_l_angles_1_0.yaw_base);
        l_v491_0(l_l_angles_1_0.yaw);
        l_v491_0(l_l_angles_1_0.pitch);
        l_v491_0(l_l_angles_1_0.enabled);
    end;
    v494.set = function(v505)
        -- upvalues: l_v493_0 (ref), l_l_angles_1_0 (ref)
        if v505.yaw_offset ~= nil then
            v505.yaw_offset = math.normalize_yaw(v505.yaw_offset);
        end;
        if v505.modifier_offset ~= nil then
            v505.modifier_offset = math.normalize_yaw(v505.modifier_offset);
        end;
        if v505.left_limit ~= nil then
            v505.left_limit = math.clamp(v505.left_limit, 0, 60);
        end;
        if v505.right_limit ~= nil then
            v505.right_limit = math.clamp(v505.right_limit, 0, 60);
        end;
        if v505.extended_pitch ~= nil then
            v505.extended_pitch = math.normalize_yaw(v505.extended_pitch);
        end;
        if v505.extended_roll ~= nil then
            v505.extended_roll = math.clamp(v505.extended_roll, -90, 90);
        end;
        l_v493_0(l_l_angles_1_0.enabled, v505.enabled);
        l_v493_0(l_l_angles_1_0.pitch, v505.pitch);
        l_v493_0(l_l_angles_1_0.yaw, v505.yaw);
        l_v493_0(l_l_angles_1_0.yaw_base, v505.yaw_base);
        l_v493_0(l_l_angles_1_0.yaw_offset, v505.yaw_offset);
        l_v493_0(l_l_angles_1_0.avoid_backstab, v505.avoid_backstab);
        l_v493_0(l_l_angles_1_0.hidden, v505.hidden);
        l_v493_0(l_l_angles_1_0.yaw_modifier, v505.yaw_modifier);
        l_v493_0(l_l_angles_1_0.modifier_offset, v505.modifier_offset);
        l_v493_0(l_l_angles_1_0.body_yaw, v505.body_yaw);
        l_v493_0(l_l_angles_1_0.inverter, v505.inverter);
        l_v493_0(l_l_angles_1_0.left_limit, v505.left_limit);
        l_v493_0(l_l_angles_1_0.right_limit, v505.right_limit);
        l_v493_0(l_l_angles_1_0.options, v505.options);
        l_v493_0(l_l_angles_1_0.freestanding_body_yaw, v505.freestanding_body_yaw);
        l_v493_0(l_l_angles_1_0.freestanding, v505.freestanding);
        l_v493_0(l_l_angles_1_0.disable_yaw_modifiers, v505.disable_yaw_modifiers);
        l_v493_0(l_l_angles_1_0.body_freestanding, v505.body_freestanding);
        l_v493_0(l_l_angles_1_0.extended_angles, v505.extended_angles);
        l_v493_0(l_l_angles_1_0.extended_pitch, v505.extended_pitch);
        l_v493_0(l_l_angles_1_0.extended_roll, v505.extended_roll);
    end;
    setmetatable(v488, v494);
    v483.buffer = v488;
end;
l_angles_1 = {};
v491 = false;
v493 = false;
v494 = function(v506, v507, v508)
    return v506 + v508 * (v507 - v506);
end;
do
    local l_v484_0, l_v485_0, l_v486_0, l_v487_0, l_v488_0, l_l_angles_1_1, l_v491_1, l_v493_1, l_v494_0 = v484, v485, v486, v487, v488, l_angles_1, v491, v493, v494;
    do
        local l_l_v491_1_0, l_l_v493_1_0, l_l_v494_0_0 = l_v491_1, l_v493_1, l_v494_0;
        local function v521()
            -- upvalues: l_l_v491_1_0 (ref)
            l_l_v491_1_0 = not l_l_v491_1_0;
        end;
        local function v530(_, v523)
            -- upvalues: l_v488_0 (ref), l_l_v491_1_0 (ref), l_l_v494_0_0 (ref)
            local v524 = v523.pitch:get();
            local v525 = v523.pitch_offset:get();
            local v526 = v523.pitch_1:get();
            local v527 = v523.pitch_2:get();
            l_v488_0.pitch = "Down";
            if v524 == "Static" then
                return v525;
            elseif v524 == "Jitter" then
                return l_l_v491_1_0 and v526 or v527;
            elseif v524 == "Random" then
                return (utils.random_int(v526, v527));
            elseif v524 == "Spin" then
                local v528 = globals.curtime * 1.5;
                return (l_l_v494_0_0(v526, v527, v528 % 1));
            elseif v524 == "Sway" then
                local v529 = globals.curtime * 5;
                return (l_l_v494_0_0(v526, v527, math.sin(v529) % 1));
            else
                return 0;
            end;
        end;
        local function v548(v531, v532)
            -- upvalues: l_v488_0 (ref), v102 (ref), l_l_v493_1_0 (ref), l_v485_0 (ref), l_l_v494_0_0 (ref)
            local v533 = v532.yaw:get();
            local v534 = v532.yaw_offset:get();
            local v535 = v532.yaw_1:get();
            local v536 = v532.yaw_2:get();
            local v537 = v532.randomization:get();
            local v538 = v532.yaw_speed:get();
            l_v488_0.yaw = "Backward";
            l_v488_0.yaw_base = "At Target";
            l_v488_0.yaw_offset = 0;
            l_v488_0.hidden = true;
            l_v488_0.yaw_add = false;
            l_v488_0.yaw_left = 0;
            l_v488_0.yaw_right = 0;
            l_v488_0.yaw_modifier = "Disabled";
            l_v488_0.modifier_offset = 0;
            l_v488_0.inverter = false;
            l_v488_0.left_limit = 60;
            l_v488_0.right_limit = 60;
            l_v488_0.options = {};
            l_v488_0.freestanding_body_yaw = "Off";
            if v533 == "Static" then
                l_v488_0.body_yaw = "Left";
                return v534;
            elseif v533 == "Switch" then
                if v537 ~= 0 then
                    local v539 = v102.sent_packets % v537 == 0;
                    local v540 = v539 and v535 or v536;
                    if v531.chokedcommands == 0 and v539 then
                        l_l_v493_1_0 = not l_l_v493_1_0;
                    end;
                    l_v488_0.body_yaw = l_l_v493_1_0 and "Left" or "Right";
                    return v540 * v102.side;
                else
                    return l_v485_0 and v535 or v536;
                end;
            elseif v533 == "Random" then
                local v541 = utils.random_int(v535, v536);
                l_v488_0.body_yaw = "Left";
                return v541;
            elseif v533 == "Spin" then
                local v542 = globals.curtime * v538 * 0.1;
                local v543 = v534 * 0.5;
                local v544 = l_l_v494_0_0(-v543, v543, v542 % 1);
                l_v488_0.body_yaw = "Left";
                return v544;
            elseif v533 == "Sway" then
                local v545 = globals.curtime * v538 * 0.1;
                local v546 = v534 * 0.5;
                local v547 = l_l_v494_0_0(-v546, v546, math.sin(v545) % 1);
                l_v488_0.body_yaw = "Left";
                return v547;
            else
                return 0;
            end;
        end;
        local function v550(v549)
            if v549.random_choke:get() then
                return utils.random_int(v549.choke_1:get(), v549.choke_2:get());
            else
                return v549.choke_1:get();
            end;
        end;
        local function v553(v551, v552)
            -- upvalues: v43 (ref), v550 (ref)
            v43.rage.main.double_tap_lag_options:override();
            v43.rage.main.hide_shots_options:override();
            if v552.force_defensive == nil or not v552.force_defensive:get() then
                return;
            elseif v552.custom_choke:get() then
                v551.force_defensive = v551.command_number % v550(v552) == 0;
                return;
            else
                v551.force_defensive = v551.command_number % 16 == 0;
                v43.rage.main.double_tap_lag_options:override("Always on");
                v43.rage.main.hide_shots_options:override("Break LC");
                return;
            end;
        end;
        l_l_angles_1_1.update = function(_, v555)
            -- upvalues: v521 (ref)
            if v555.choked_commands == 0 then
                v521();
            end;
        end;
        l_l_angles_1_1.apply = function(_, v557, v558)
            -- upvalues: v553 (ref), v43 (ref), v530 (ref), v548 (ref)
            v553(v557, v558);
            local v559 = rage.exploit:get() == 1;
            local v560 = v43.antiaim.misc.fake_duck:get();
            if not v559 or v560 then
                return false;
            elseif not v558.enabled:get() then
                return false;
            else
                local v561 = v530(v557, v558);
                local v562 = v548(v557, v558);
                rage.antiaim:override_hidden_pitch(v561);
                rage.antiaim:override_hidden_yaw_offset(v562);
                return true;
            end;
        end;
    end;
    l_v491_1 = {};
    l_v493_1 = v44.antiaim.builder;
    l_v494_0 = function(_)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.pitch = "Down";
    end;
    local function v565(v564)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.yaw = "Backward";
        l_v488_0.yaw_base = "At Target";
        l_v488_0.yaw_offset = v564.yaw_offset:get();
        l_v488_0.yaw_add = v564.yaw_add:get();
        l_v488_0.yaw_left = v564.yaw_left:get();
        l_v488_0.yaw_right = v564.yaw_right:get();
    end;
    local function v567(v566)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.yaw_modifier = v566.yaw_modifier:get();
        l_v488_0.modifier_offset = v566.modifier_offset:get();
    end;
    local function v569(v568)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.body_yaw = v568.body_yaw:get();
        l_v488_0.inverter = false;
        l_v488_0.left_limit = v568.left_limit:get();
        l_v488_0.right_limit = v568.right_limit:get();
        l_v488_0.options = {};
        l_v488_0.freestanding_body_yaw = "Off";
        l_v488_0.delay_1 = v568.delay_1:get();
        l_v488_0.delay_2 = v568.delay_2:get();
    end;
    local function v571(_)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.freestanding = false;
    end;
    local function v573(_)
        -- upvalues: l_v488_0 (ref)
        l_v488_0.extended_angles = false;
        l_v488_0.extended_pitch = 0;
        l_v488_0.extended_roll = 0;
    end;
    do
        local l_l_v493_1_1, l_l_v494_0_1, l_v565_0, l_v567_0, l_v569_0, l_v571_0, l_v573_0 = l_v493_1, l_v494_0, v565, v567, v569, v571, v573;
        l_v491_1.get = function(_, v582, v583)
            -- upvalues: l_l_v493_1_1 (ref)
            return l_l_v493_1_1[v582][v583];
        end;
        l_v491_1.is_active_ex = function(_, v585)
            if v585.angles == nil then
                return false;
            else
                return true;
            end;
        end;
        l_v491_1.is_active = function(v586, v587, v588)
            local v589 = v586:get(v587, v588);
            if v589 == nil then
                return false;
            else
                return v586:is_active_ex(v589);
            end;
        end;
        l_v491_1.apply_ex = function(_, v591)
            -- upvalues: l_l_v494_0_1 (ref), l_v565_0 (ref), l_v567_0 (ref), l_v569_0 (ref), l_v571_0 (ref), l_v573_0 (ref)
            if v591 == nil then
                return false;
            else
                local l_angles_2 = v591.angles;
                if l_angles_2 == nil then
                    return false;
                else
                    l_l_v494_0_1(l_angles_2);
                    l_v565_0(l_angles_2);
                    l_v567_0(l_angles_2);
                    l_v569_0(l_angles_2);
                    l_v571_0(l_angles_2);
                    l_v573_0(l_angles_2);
                    return true;
                end;
            end;
        end;
        l_v491_1.apply = function(v593, v594, v595)
            local v596 = v593:get(v594, v595);
            if v596 == nil then
                return false, nil;
            elseif not v593:is_active_ex(v596) then
                return false, v596;
            else
                v593:apply_ex(v596);
                return true, v596;
            end;
        end;
        l_v491_1.update = function(v597)
            -- upvalues: v136 (ref), v139 (ref)
            local v598 = v136.get();
            local v599 = v139.get();
            if v598 == nil or v599 == nil then
                return false, nil;
            else
                local _, v601 = v597:apply(v599, v598);
                return true, v601;
            end;
        end;
    end;
    l_v493_1 = {};
    l_v494_0 = v44.antiaim.tweaks.avoid_backstab;
    do
        local l_l_v494_0_2 = l_v494_0;
        l_v493_1.update = function(_)
            -- upvalues: l_v488_0 (ref), l_l_v494_0_2 (ref)
            l_v488_0.avoid_backstab = l_l_v494_0_2.enabled:get();
        end;
    end;
    l_v494_0 = {};
    v565 = v44.antiaim.tweaks.on_use;
    v567 = false;
    do
        local l_v565_1, l_v567_1, l_v569_1 = v565, v567, v569;
        l_v569_1 = function(v607)
            -- upvalues: l_v565_1 (ref), l_v567_1 (ref)
            if not l_v565_1.enabled:get() then
                return false;
            else
                local v608 = entity.get_local_player();
                if v608 == nil then
                    return false;
                else
                    local v609 = v608:get_player_weapon();
                    if v609 == nil then
                        return false;
                    else
                        local v610 = v609:get_weapon_info();
                        if v610 == nil then
                            return false;
                        else
                            local l_m_iTeamNum_1 = v608.m_iTeamNum;
                            local v612 = v608:get_origin();
                            local v613 = v610.idx == 49;
                            local l_m_bIsDefusing_0 = v608.m_bIsDefusing;
                            local l_m_bIsGrabbingHostage_0 = v608.m_bIsGrabbingHostage;
                            local l_m_bInBombZone_0 = v608.m_bInBombZone;
                            if l_m_bIsDefusing_0 or l_m_bIsGrabbingHostage_0 then
                                return false;
                            elseif l_m_bInBombZone_0 and v613 then
                                return false;
                            else
                                if l_m_iTeamNum_1 == 3 and v607.view_angles.x > 25 then
                                    local v617 = entity.get_entities("CPlantedC4");
                                    for v618 = 1, #v617 do
                                        if (v617[v618]:get_origin() - v612):lengthsqr() < 3844 then
                                            return false;
                                        end;
                                    end;
                                end;
                                local v619 = render.camera_angles();
                                local v620 = vector():angles(v619);
                                local v621 = v608:get_eye_position();
                                local v622 = v621 + v620 * 128;
                                local v623 = utils.trace_line(v621, v622, v608);
                                if v623.fraction ~= 1 then
                                    local v624 = v623.entity:get_classname();
                                    if v624 == "CWorld" then
                                        return true;
                                    elseif v624 == "CFuncBrush" then
                                        return true;
                                    elseif v624 == "CCSPlayer" then
                                        return true;
                                    elseif v624 == "CHostage" and v621:distsqr((ent:get_origin())) < 7056 then
                                        return false;
                                    elseif not l_v567_1 then
                                        l_v567_1 = true;
                                        return false;
                                    end;
                                end;
                                return true;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        l_v494_0.update = function(_, v626)
            -- upvalues: l_v567_1 (ref), l_v569_1 (ref), l_v488_0 (ref)
            if v626.in_use == false then
                l_v567_1 = false;
                return false;
            elseif not l_v569_1(v626) then
                return false;
            else
                l_v488_0.pitch = "Disabled";
                l_v488_0.yaw_base = "Local view";
                l_v488_0.yaw_offset = l_v488_0.yaw_offset + 180;
                l_v488_0.freestanding = false;
                v626.in_use = false;
                return true;
            end;
        end;
    end;
    v565 = {};
    v567 = v44.antiaim.tweaks.modify_on_warmup;
    v569 = function()
        local v627 = entity.get_game_rules();
        if v627 == nil then
            return false;
        else
            return v627.m_bWarmupPeriod;
        end;
    end;
    do
        local l_v567_2, l_v569_2, l_v571_1 = v567, v569, v571;
        l_v571_1 = function()
            -- upvalues: l_v567_2 (ref), l_v569_2 (ref)
            if not l_v567_2.enabled:get() then
                return false;
            else
                return l_v569_2();
            end;
        end;
        v565.update = function(_)
            -- upvalues: l_v571_1 (ref), l_v488_0 (ref)
            if not l_v571_1() then
                return false;
            else
                l_v488_0.enabled = true;
                l_v488_0.pitch = "Disabled";
                l_v488_0.yaw = "Backward";
                l_v488_0.yaw_base = "At Target";
                l_v488_0.yaw_offset = globals.tickcount * 8;
                l_v488_0.yaw_add = false;
                l_v488_0.yaw_left = 0;
                l_v488_0.yaw_right = 0;
                l_v488_0.yaw_modifier = "Disabled";
                l_v488_0.modifier_offset = 0;
                l_v488_0.body_yaw = "Disabled";
                l_v488_0.inverter = false;
                l_v488_0.left_limit = 0;
                l_v488_0.right_limit = 0;
                l_v488_0.options = {};
                l_v488_0.freestanding_body_yaw = "Off";
                l_v488_0.delay_1 = 0;
                l_v488_0.delay_2 = 0;
                l_v488_0.freestanding = false;
                return true;
            end;
        end;
    end;
    v567 = {};
    v569 = v44.antiaim.tweaks.flick_exploit;
    do
        local l_v569_3, l_v571_2 = v569, v571;
        l_v571_2 = function()
            -- upvalues: l_v569_3 (ref), v136 (ref)
            if not l_v569_3.enabled:get() then
                return false;
            else
                local v634 = entity.get_local_player();
                if v634 == nil then
                    return false;
                else
                    local v635 = v634:get_player_weapon();
                    if v635 == nil then
                        return false;
                    else
                        local v636 = v635:get_weapon_info();
                        if v636 == nil or v636.is_revolver then
                            return false;
                        elseif not (rage.exploit:get() == 1) then
                            return false;
                        else
                            local v637 = v136.get();
                            if v637 == nil then
                                return false;
                            else
                                return l_v569_3.conditions:get(v637);
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v567.update = function(_, v639)
            -- upvalues: l_v571_2 (ref), l_v488_0 (ref)
            if not l_v571_2() then
                return false;
            else
                l_v488_0.enabled = true;
                l_v488_0.pitch = "Down";
                l_v488_0.yaw = "Backward";
                l_v488_0.yaw_base = "At Target";
                l_v488_0.yaw_offset = 0;
                l_v488_0.hidden = true;
                l_v488_0.yaw_add = false;
                l_v488_0.yaw_left = 0;
                l_v488_0.yaw_right = 0;
                l_v488_0.yaw_modifier = "Disabled";
                l_v488_0.modifier_offset = 0;
                l_v488_0.body_yaw = "Left";
                l_v488_0.inverter = false;
                l_v488_0.left_limit = 60;
                l_v488_0.right_limit = 60;
                l_v488_0.options = {};
                l_v488_0.freestanding_body_yaw = "Off";
                l_v488_0.delay_1 = 0;
                l_v488_0.delay_2 = 0;
                l_v488_0.freestanding = false;
                rage.antiaim:override_hidden_pitch(89);
                rage.antiaim:override_hidden_yaw_offset(-70);
                v639.force_defensive = v639.command_number % 7 == 0;
                return true;
            end;
        end;
    end;
    v569 = {};
    v571 = v44.antiaim.tweaks.safe_head;
    v573 = 1000000;
    do
        local l_v571_3, l_v573_1 = v571, v573;
        local function v652(v642, v643)
            -- upvalues: v102 (ref), l_v573_1 (ref)
            local v644 = v642:get_player_weapon();
            if v644 == nil then
                return nil;
            else
                local v645 = v644:get_classname();
                local v646 = v645 == "CKnife";
                local v647 = v645 == "CWeaponTaser";
                local v648 = v642:get_origin();
                local v649 = v643:get_origin() - v648;
                local v650 = -v649.z;
                local v651 = v649:length2dsqr();
                if v102.is_onground then
                    if (not v102.is_moving or v102.is_crouched) and v650 >= 10 and l_v573_1 < v651 then
                        return "Distance";
                    else
                        if v102.is_crouched then
                            if v650 >= 48 then
                                return "Crouching";
                            end;
                        elseif not v102.is_moving and v650 >= 24 then
                            return "Standing";
                        end;
                        return nil;
                    end;
                else
                    if v102.is_crouched then
                        if v647 and v650 > -20 and v651 < 250000 then
                            return "Air Taser";
                        elseif v646 and v650 > -100 then
                            return "Air Knife";
                        elseif v650 > 130 then
                            return "Air Crouch";
                        end;
                    end;
                    return nil;
                end;
            end;
        end;
        local function v656()
            -- upvalues: l_v571_3 (ref), v652 (ref)
            if not l_v571_3.enabled:get() then
                return false;
            else
                local v653 = entity.get_local_player();
                if v653 == nil then
                    return false;
                else
                    local v654 = entity.get_threat();
                    if v654 == nil then
                        return false;
                    else
                        local v655 = v652(v653, v654);
                        if v655 == nil then
                            return false;
                        else
                            return l_v571_3.conditions:get(v655);
                        end;
                    end;
                end;
            end;
        end;
        v569.update = function(_)
            -- upvalues: v656 (ref), l_v488_0 (ref)
            if not v656() then
                return false;
            else
                l_v488_0.enabled = true;
                l_v488_0.pitch = "Down";
                l_v488_0.yaw = "Backward";
                l_v488_0.yaw_base = "At Target";
                l_v488_0.yaw_offset = 0;
                l_v488_0.yaw_add = false;
                l_v488_0.yaw_left = 0;
                l_v488_0.yaw_right = 0;
                l_v488_0.yaw_modifier = "Disabled";
                l_v488_0.modifier_offset = 0;
                l_v488_0.body_yaw = "Disabled";
                l_v488_0.inverter = false;
                l_v488_0.left_limit = 0;
                l_v488_0.right_limit = 0;
                l_v488_0.options = {};
                l_v488_0.freestanding_body_yaw = "Off";
                l_v488_0.delay_1 = 0;
                l_v488_0.delay_2 = 0;
                l_v488_0.freestanding = false;
                return true;
            end;
        end;
    end;
    v571 = {};
    v573 = v44.antiaim.hotkeys.freestanding;
    do
        local l_v573_2 = v573;
        local function v659()
            -- upvalues: l_v573_2 (ref)
            return l_v573_2.static:get();
        end;
        local function v661()
            -- upvalues: v136 (ref), l_v573_2 (ref)
            local v660 = v136.get();
            if v660 == nil then
                return false;
            else
                return l_v573_2.disablers:get(v660);
            end;
        end;
        v571.update = function(_)
            -- upvalues: l_v573_2 (ref), v661 (ref), v659 (ref), l_v488_0 (ref)
            if not l_v573_2.enabled:get() then
                return false;
            elseif v661() then
                return false;
            else
                if v659() then
                    l_v488_0.yaw_offset = 0;
                    l_v488_0.yaw_add = false;
                    l_v488_0.yaw_modifier = "Disabled";
                    l_v488_0.body_yaw = "Left";
                end;
                l_v488_0.yaw_base = "Local View";
                l_v488_0.freestanding = true;
                return true;
            end;
        end;
    end;
    v573 = {};
    local l_manual_yaw_0 = v44.antiaim.hotkeys.manual_yaw;
    local v664 = {
        Backward = 0, 
        Right = 90, 
        Left = -90, 
        Forward = 180
    };
    do
        local l_l_manual_yaw_0_0, l_v664_0 = l_manual_yaw_0, v664;
        local function v667()
            -- upvalues: l_l_manual_yaw_0_0 (ref)
            return l_l_manual_yaw_0_0.static:get();
        end;
        local function v669()
            -- upvalues: v136 (ref), l_l_manual_yaw_0_0 (ref)
            local v668 = v136.get();
            if v668 == nil then
                return false;
            else
                return l_l_manual_yaw_0_0.disablers:get(v668);
            end;
        end;
        v573.update = function(_)
            -- upvalues: l_v664_0 (ref), l_l_manual_yaw_0_0 (ref), v669 (ref), v667 (ref), l_v488_0 (ref)
            local v671 = l_v664_0[l_l_manual_yaw_0_0.direction:get()];
            if not v671 then
                return false;
            elseif v669() then
                return false;
            else
                if v667() then
                    l_v488_0.yaw_offset = 0;
                    l_v488_0.yaw_add = false;
                    l_v488_0.yaw_modifier = "Disabled";
                    l_v488_0.body_yaw = "Left";
                end;
                l_v488_0.yaw_base = "Local View";
                l_v488_0.yaw_offset = l_v488_0.yaw_offset + v671;
                return true;
            end;
        end;
    end;
    l_manual_yaw_0 = function()
        -- upvalues: l_v485_0 (ref), l_v488_0 (ref), l_v487_0 (ref), l_v486_0 (ref), l_v484_0 (ref)
        if rage.exploit:get() == 0 then
            l_v485_0 = not l_v485_0;
            return;
        else
            if l_v488_0.body_yaw == "Jitter" then
                l_v487_0 = l_v488_0.delay_1;
            end;
            if l_v488_0.body_yaw == "Randomize Jitter" and l_v486_0 then
                l_v487_0 = utils.random_int(l_v488_0.delay_1, l_v488_0.delay_2);
                l_v486_0 = false;
            end;
            l_v484_0 = l_v484_0 + 1;
            if l_v487_0 < l_v484_0 then
                l_v485_0 = not l_v485_0;
                l_v484_0 = 0;
                l_v486_0 = true;
            end;
            return;
        end;
    end;
    v664 = function(v672)
        -- upvalues: l_v491_1 (ref), l_l_angles_1_1 (ref), v565 (ref), l_v494_0 (ref), l_v493_1 (ref), v573 (ref), v571 (ref), v569 (ref), v567 (ref)
        local v673, v674 = l_v491_1:update();
        l_l_angles_1_1:update(v672);
        if v565:update() then
            return;
        elseif l_v494_0:update(v672) then
            return;
        elseif l_v493_1:update() then
            return;
        elseif v573:update() then
            return;
        elseif v571:update() then
            return;
        elseif v569:update() then
            return;
        elseif v567:update(v672) then
            return;
        else
            if v673 and v674 ~= nil and v674.defensive ~= nil then
                l_l_angles_1_1:apply(v672, v674.defensive);
            end;
            return;
        end;
    end;
    local function v676()
        -- upvalues: l_v488_0 (ref), l_v485_0 (ref)
        if not l_v488_0.yaw_add then
            return;
        else
            local v675 = l_v485_0 and l_v488_0.yaw_left or l_v488_0.yaw_right;
            l_v488_0.yaw_offset = l_v488_0.yaw_offset + v675;
            return;
        end;
    end;
    local function v677()

    end;
    local function v678()
        -- upvalues: l_v488_0 (ref), l_v485_0 (ref)
        if l_v488_0.body_yaw == "Disabled" then
            l_v488_0.body_yaw = false;
            return;
        elseif l_v488_0.body_yaw == "Left" then
            l_v488_0.body_yaw = true;
            rage.antiaim:inverter(false);
            return;
        elseif l_v488_0.body_yaw == "Right" then
            l_v488_0.body_yaw = true;
            rage.antiaim:inverter(true);
            return;
        elseif l_v488_0.body_yaw == "Jitter" or l_v488_0.body_yaw == "Randomize Jitter" then
            l_v488_0.body_yaw = true;
            rage.antiaim:inverter(l_v485_0);
            return;
        else
            return;
        end;
    end;
    local function v680(v679)
        -- upvalues: l_manual_yaw_0 (ref), v678 (ref), v677 (ref), v676 (ref)
        if v679.choked_commands == 0 then
            l_manual_yaw_0();
        end;
        v678();
        v677();
        v676();
    end;
    local function v681()
        -- upvalues: l_v488_0 (ref)
        l_v488_0:clear();
        l_v488_0:unset();
    end;
    local function v683(v682)
        -- upvalues: l_v488_0 (ref), v664 (ref), v680 (ref)
        l_v488_0:clear();
        l_v488_0:unset();
        v664(v682);
        v680(v682);
        l_v488_0:set();
    end;
    local _ = nil;
    events.shutdown(v681);
    events.createmove(v683);
end;
v484 = nil;
v485 = nil;
v486 = v44.other.aimbot.dormant_aimbot;
v487 = function(v685)
    return v685.weapon_type >= 1 and v685.weapon_type <= 6;
end;
v488 = function(v686, v687, v688)
    if v688.max_clip1 == 0 or v687.m_iClip1 == 0 then
        return false;
    elseif globals.curtime < v686.m_flNextAttack then
        return false;
    elseif globals.curtime < v687.m_flNextPrimaryAttack then
        return false;
    else
        return true;
    end;
end;
l_angles_1 = function(v689, v690)
    if v690.weapon_type == 5 then
        return v689.m_bIsScoped or v689.m_bResumeZoom;
    else
        return true;
    end;
end;
v491 = function(v691, v692, v693, v694)
    local v695, v696 = utils.trace_bullet(v691, v692, v693, v694);
    if v696 ~= nil then
        local l_entity_0 = v696.entity;
        if l_entity_0 == nil then
            return 0, v696;
        elseif l_entity_0:is_player() and not l_entity_0:is_enemy() then
            return 0, v696;
        end;
    end;
    return v695, v696;
end;
do
    local l_v486_1, l_v487_1, l_v488_1, l_l_angles_1_2, l_v491_2, l_v493_2, l_v494_1 = v486, v487, v488, l_angles_1, v491, v493, v494;
    l_v493_2 = function()
        -- upvalues: l_v486_1 (ref)
        local v705 = {};
        if l_v486_1.hitboxes:get("Head") then
            local v706 = {
                position = vector(0, 0, 58), 
                hitbox = "Head"
            };
            table.insert(v705, v706);
        end;
        if l_v486_1.hitboxes:get("Chest") then
            local v707 = {
                position = vector(0, 0, 50), 
                hitbox = "Chest"
            };
            table.insert(v705, v707);
        end;
        if l_v486_1.hitboxes:get("Stomach") then
            local v708 = {
                position = vector(0, 0, 40), 
                hitbox = "Stomach"
            };
            table.insert(v705, v708);
        end;
        if l_v486_1.hitboxes:get("Legs") then
            local v709 = {
                position = vector(0, 0, 20), 
                hitbox = "Legs"
            };
            table.insert(v705, v709);
        end;
        return v705;
    end;
    l_v494_1 = function()
        local v710 = {};
        local v711 = entity.get_player_resource();
        for v712 = 1, globals.max_players do
            local v713 = entity.get(v712);
            if v713 ~= nil and v711.m_bConnected[v712] and v713:is_enemy() and v713:is_dormant() and v713:is_alive() and v713:get_network_state() ~= 5 then
                table.insert(v710, v713);
            end;
        end;
        return v710;
    end;
    local function v738(v714)
        -- upvalues: v102 (ref), l_v487_1 (ref), l_v488_1 (ref), l_v493_2 (ref), l_v486_1 (ref), l_v494_1 (ref), l_v491_2 (ref), l_l_angles_1_2 (ref)
        local v715 = entity.get_local_player();
        if v715 == nil then
            return;
        else
            local v716 = v715:get_player_weapon();
            if v716 == nil then
                return;
            else
                local v717 = v716:get_weapon_info();
                if v717 == nil then
                    return;
                else
                    local v718 = v716:get_inaccuracy();
                    if v718 == nil then
                        return;
                    elseif v714.in_jump or not v102.is_onground then
                        return;
                    else
                        local v719 = v715:get_eye_position();
                        if not l_v487_1(v717) then
                            return;
                        elseif not l_v488_1(v715, v716, v717) then
                            return;
                        else
                            local v720 = l_v493_2();
                            if #v720 == 0 then
                                return;
                            else
                                local v721 = l_v486_1.accuracy:get();
                                local v722 = l_v486_1.min_damage:get();
                                local v723 = nil;
                                local v724 = l_v494_1();
                                if #v724 == 0 then
                                    return;
                                else
                                    for v725 = 1, #v724 do
                                        local v726 = v724[v725];
                                        if v726 ~= nil then
                                            local v727 = v726:get_bbox();
                                            if v727 ~= nil then
                                                local l_alpha_0 = v727.alpha;
                                                if l_alpha_0 ~= 0 and math.floor(l_alpha_0 * 100) + 5 > v721 then
                                                    local l_m_vecOrigin_0 = v726.m_vecOrigin;
                                                    local l_m_flDuckAmount_1 = v726.m_flDuckAmount;
                                                    for v731 = 1, #v720 do
                                                        local v732 = v720[v731];
                                                        local l_position_0 = v732.position;
                                                        local l_hitbox_0 = v732.hitbox;
                                                        l_position_0 = l_position_0 + l_m_vecOrigin_0;
                                                        if l_hitbox_0 == "Head" then
                                                            l_position_0 = l_position_0 - vector(0, 0, 10 * l_m_flDuckAmount_1);
                                                        end;
                                                        if l_hitbox_0 == "Chest" then
                                                            l_position_0 = l_position_0 - vector(0, 0, 4 * l_m_flDuckAmount_1);
                                                        end;
                                                        local v735, v736 = l_v491_2(v715, v719, l_position_0);
                                                        if l_hitbox_0 == "Head" then
                                                            v735 = v735 * 4;
                                                        end;
                                                        if (v736 == nil or not v736:is_visible()) and v735 ~= 0 and v722 <= v735 then
                                                            v723 = l_position_0;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                    if not v723 then
                                        return;
                                    else
                                        local v737 = v719:to(v723):angles();
                                        if not l_l_angles_1_2(v715, v717) then
                                            v714.in_attack2 = true;
                                        end;
                                        v714.block_movement = 1;
                                        if v718 < 0.01 then
                                            v714.view_angles = v737;
                                            v714.in_attack = true;
                                        end;
                                        return;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    local _ = nil;
    local function v742(v740)
        -- upvalues: v738 (ref)
        local v741 = v740:get();
        events.createmove(v738, v741);
    end;
    l_v486_1.enabled:set_callback(v742, true);
end;
v486 = nil;
v487 = v44.other.aimbot.ai_peek;
v488 = {
    point = nil, 
    retreat = -1, 
    retreat_point = nil
};
l_angles_1 = 1;
v491 = 40;
v493 = 64;
v494 = 0;
local v743 = 1;
local v744 = 2;
local v745 = 3;
local v746 = 4;
local v747 = 5;
local v748 = 6;
local v749 = 7;
local v750 = 10;
local v751 = 0;
local v752 = 1;
local v753 = 2;
local v754 = 3;
local v755 = 4;
local v756 = 5;
local v757 = 6;
local v758 = 7;
local v759 = 8;
local v760 = 9;
local v761 = 10;
local v762 = 11;
local v763 = 12;
local v764 = 13;
local _ = 14;
local v766 = 15;
local _ = 16;
local v768 = 17;
local _ = 18;
local v770 = {
    [v751] = v743, 
    [v756] = v744, 
    [v754] = v745, 
    [v759] = v748, 
    [v758] = v749, 
    [v763] = v748, 
    [v762] = v749, 
    [v768] = v746, 
    [v766] = v747
};
do
    local l_v487_2, l_v488_2, l_l_angles_1_3, l_v491_3, l_v493_3, l_v494_2, l_v743_0, l_v745_0, l_v748_0, l_v749_0, l_v751_0, l_v754_0, l_v756_0, l_v758_0, l_v759_0, l_v760_0, l_v761_0, l_v766_0, l_v768_0, l_v770_0 = v487, v488, l_angles_1, v491, v493, v494, v743, v745, v748, v749, v751, v754, v756, v758, v759, v760, v761, v766, v768, v770;
    local function v792(v791)
        -- upvalues: l_v770_0 (ref), l_v494_2 (ref)
        return l_v770_0[v791] or l_v494_2;
    end;
    local function v794()
        -- upvalues: l_v487_2 (ref), l_v751_0 (ref), l_v756_0 (ref), l_v754_0 (ref), l_v768_0 (ref), l_v766_0 (ref), l_v759_0 (ref), l_v758_0 (ref), l_v761_0 (ref), l_v760_0 (ref)
        local v793 = {};
        if l_v487_2.hitboxes:get("Head") then
            table.insert(v793, l_v751_0);
        end;
        if l_v487_2.hitboxes:get("Chest") then
            table.insert(v793, l_v756_0);
        end;
        if l_v487_2.hitboxes:get("Stomach") then
            table.insert(v793, l_v754_0);
        end;
        if l_v487_2.hitboxes:get("Arms") then
            table.insert(v793, l_v768_0);
            table.insert(v793, l_v766_0);
        end;
        if l_v487_2.hitboxes:get("Legs") then
            table.insert(v793, l_v759_0);
            table.insert(v793, l_v758_0);
            table.insert(v793, l_v761_0);
            table.insert(v793, l_v760_0);
        end;
        return v793;
    end;
    local function v796(v795)
        -- upvalues: l_v743_0 (ref), l_v745_0 (ref), l_v748_0 (ref), l_v749_0 (ref)
        if v795 == l_v743_0 then
            return 4;
        elseif v795 == l_v745_0 then
            return 1.25;
        elseif v795 == l_v748_0 then
            return 0.75;
        elseif v795 == l_v749_0 then
            return 0.75;
        else
            return 1;
        end;
    end;
    local function v803(v797, v798, v799, v800)
        -- upvalues: v796 (ref), l_v743_0 (ref)
        v798 = v798 * v796(v799);
        local l_m_ArmorValue_0 = v797.m_ArmorValue;
        local l_m_bHasHelmet_0 = v797.m_bHasHelmet;
        if l_m_ArmorValue_0 > 0 then
            if v799 == l_v743_0 then
                if l_m_bHasHelmet_0 ~= 0 then
                    v798 = v798 * (v800 * 0.5);
                end;
            else
                v798 = v798 * (v800 * 0.5);
            end;
        end;
        return v798;
    end;
    local function v815(v804, v805, v806, v807, v808)
        -- upvalues: v803 (ref)
        local v809 = v805 - v804;
        local l_damage_0 = v808.damage;
        local l_armor_ratio_0 = v808.armor_ratio;
        local l_range_0 = v808.range;
        local l_range_modifier_0 = v808.range_modifier;
        local v814 = math.min(l_range_0, v809:length());
        l_damage_0 = l_damage_0 * math.pow(l_range_modifier_0, v814 * 0.002);
        return (v803(v806, l_damage_0, v807, l_armor_ratio_0));
    end;
    local function v831(v816, v817, v818, v819, v820)
        -- upvalues: v792 (ref), v815 (ref)
        local v821 = {};
        local v822 = v817:get_eye_position();
        local l_m_iHealth_0 = v819.m_iHealth;
        for v824 = 1, #v816 do
            local v825 = v816[v824];
            local v826 = v792(v825);
            local v827 = v819:get_hitbox_position(v825);
            local v828 = v815(v822, v827, v819, v826, v818);
            local v829 = v828 < v820;
            local v830 = v828 < l_m_iHealth_0;
            if not v829 or not v830 then
                table.insert(v821, {
                    index = v824, 
                    pos = v827
                });
            end;
        end;
        return v821;
    end;
    local function v836(v832, v833)
        -- upvalues: l_v491_3 (ref), l_v493_3 (ref), l_l_angles_1_3 (ref)
        local v834 = v832:get_weapon_index();
        local l_weapon_type_0 = v833.weapon_type;
        if l_weapon_type_0 == 5 and v834 == l_v491_3 then
            return "SSG 08";
        elseif l_weapon_type_0 == 1 then
            if v834 == l_v493_3 then
                return "R8 Revolver";
            elseif v834 == l_l_angles_1_3 then
                return "Desert Eagle";
            else
                return "Pistol";
            end;
        elseif l_weapon_type_0 == 3 then
            return "Rifle";
        elseif l_weapon_type_0 == 4 then
            return "Shotgun";
        else
            return nil;
        end;
    end;
    local function v840(v837, v838, v839)
        if v839.max_clip1 == 0 or v838.m_iClip1 == 0 then
            return false;
        elseif globals.curtime < v837.m_flNextAttack then
            return false;
        elseif globals.curtime < v838.m_flNextPrimaryAttack then
            return false;
        else
            return true;
        end;
    end;
    local function v843(v841, v842)
        if v842.weapon_type_int == 5 then
            return v841.m_bIsScoped == 1;
        else
            return true;
        end;
    end;
    local function v844()
        -- upvalues: v43 (ref)
        v43.rage.main.double_tap:override();
    end;
    local function v846(v845)
        return not v845.in_forward and not v845.in_back and not v845.in_moveleft and not v845.in_moveright;
    end;
    local function v848(v847)
        v847.in_duck = false;
        v847.in_jump = false;
        v847.in_speed = false;
        v847.in_forward = false;
        v847.in_back = false;
        v847.in_moveleft = false;
        v847.in_moveright = false;
    end;
    local function v856(v849, v850, v851, v852)
        local v853, v854 = utils.trace_bullet(v849, v850, v851, v852);
        if v854 ~= nil then
            local l_entity_1 = v854.entity;
            if l_entity_1 == nil then
                return 0, v854;
            elseif l_entity_1:is_player() and not l_entity_1:is_enemy() then
                return 0, v854;
            end;
        end;
        return v853, v854;
    end;
    local function v863(v857, v858, v859)
        local v860 = v859 - v858.m_vecOrigin;
        if v860:length2dsqr() < 25 then
            local l_m_vecVelocity_1 = v858.m_vecVelocity;
            local v862 = l_m_vecVelocity_1:length();
            v857.move_yaw = l_m_vecVelocity_1:angles().y;
            v857.forwardmove = -v862;
            v857.sidemove = 0;
            return true;
        else
            v857.move_yaw = v860:angles().y;
            v857.forwardmove = 450;
            v857.sidemove = 0;
            return false;
        end;
    end;
    local function v867(v864, v865, v866)
        return v864 + vector():angles(0, v865, 0) * v866;
    end;
    local function v873(v868, v869, v870, v871)
        -- upvalues: v867 (ref)
        local v872 = v867(v869, v870, v871);
        return utils.trace_line(v869, v872, v868).end_pos;
    end;
    local function v888(v874, v875, v876, v877, v878, v879, v880, v881)
        -- upvalues: v873 (ref), v856 (ref)
        local v882 = v873(v874, v877, v878, v879);
        for v883 = 1, #v880 do
            local l_pos_0 = v880[v883].pos;
            local v886, _ = v856(v874, v882, l_pos_0, function(v885)
                -- upvalues: v875 (ref)
                return v885 == v875;
            end);
            if v881 <= v886 then
                return v882 - vector(0, 0, v877.z - v876.z), true;
            end;
        end;
        return nil, false;
    end;
    local function v913(v889, v890, _, v892)
        -- upvalues: v846 (ref), v794 (ref), v43 (ref), v831 (ref), l_v487_2 (ref), v888 (ref), l_v488_2 (ref)
        if not v846(v889) then
            return;
        else
            local l_m_fFlags_1 = v890.m_fFlags;
            if bit.band(l_m_fFlags_1, 1) == 0 then
                return;
            else
                local v894 = entity.get_threat();
                if v894 == nil or v894:is_dormant() then
                    return;
                else
                    local l_m_vecOrigin_1 = v890.m_vecOrigin;
                    local l_m_vecOrigin_2 = v894.m_vecOrigin;
                    local v897 = v890:get_eye_position();
                    local v898 = v794();
                    local v899 = v43.rage.selection.min_damage:get();
                    local v900 = v831(v898, v890, v892, v894, v899);
                    local v901 = nil;
                    local v902 = nil;
                    local v903 = (l_m_vecOrigin_2 - l_m_vecOrigin_1):angles().y + 180;
                    v901 = v903 - 90;
                    v902 = v903 + 90;
                    local v904 = 0;
                    local v905 = 0;
                    v903 = l_v487_2.dots:get();
                    local v906 = l_v487_2.radius:get() / v903;
                    for v907 = 1, v903 do
                        local v908 = v906 * v907;
                        if v904 ~= -1 then
                            v904 = v907;
                            local v909, v910 = v888(v890, v894, l_m_vecOrigin_1, v897, v901, v908, v900, v899);
                            if v910 then
                                l_v488_2.point = v909;
                                break;
                            end;
                        end;
                        if v905 ~= -1 then
                            v905 = v907;
                            local v911, v912 = v888(v890, v894, l_m_vecOrigin_1, v897, v902, v908, v900, v899);
                            if v912 then
                                l_v488_2.point = v911;
                                break;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end;
    local function v926(v914, v915, v916, v917)
        -- upvalues: l_v488_2 (ref), v840 (ref), v843 (ref), v913 (ref), l_v487_2 (ref), v863 (ref), v848 (ref), v17 (ref), v43 (ref), v844 (ref)
        if l_v488_2.retreat_point == nil then
            l_v488_2.retreat_point = v915.m_vecOrigin;
        end;
        local v918 = v840(v915, v916, v917);
        local v919 = v843(v915, v917);
        v913(v914, v915, v916, v917);
        local l_m_vecMins_0 = v915.m_vecMins;
        local l_m_vecMaxs_0 = v915.m_vecMaxs;
        local v922 = l_v487_2.color:get();
        local v923 = color(0, 0, 0, 0);
        if l_v488_2.retreat <= 0 and v918 and v919 and l_v488_2.point then
            local v924 = v863(v914, v915, l_v488_2.point);
            v848(v914);
            l_v488_2.retreat = 0;
            if v924 then
                l_v488_2.retreat = 1;
            end;
            v17.box_new(l_v488_2.point, l_m_vecMins_0, l_m_vecMaxs_0, vector(), v923, v922, globals.tickinterval * 2);
            return;
        elseif l_v488_2.retreat == -1 then
            return;
        else
            local v925 = v863(v914, v915, l_v488_2.retreat_point);
            v848(v914);
            l_v488_2.retreat = l_v488_2.retreat + 1;
            if l_v488_2.retreat >= 3 then
                v43.rage.main.double_tap:override(false);
            end;
            if v918 and v925 then
                l_v488_2.point = nil;
                l_v488_2.retreat = -1;
                l_v488_2.retreat_point = nil;
                v844();
            end;
            return;
        end;
    end;
    local function v930(v927, v928)
        -- upvalues: v836 (ref), l_v487_2 (ref)
        local v929 = v836(v927, v928);
        if v929 == nil then
            return;
        else
            return l_v487_2.weapons:get(v929);
        end;
    end;
    local function v935(v931)
        -- upvalues: v844 (ref), v930 (ref), v926 (ref)
        v844();
        local v932 = entity.get_local_player();
        if v932 == nil or not v932:is_alive() then
            return;
        else
            local v933 = v932:get_player_weapon();
            if v933 == nil then
                return;
            else
                local v934 = v933:get_weapon_info();
                if v934 == nil then
                    return;
                elseif not v930(v933, v934) then
                    return;
                else
                    v926(v931, v932, v933, v934);
                    return;
                end;
            end;
        end;
    end;
    local function v936()
        -- upvalues: l_v488_2 (ref), v844 (ref)
        l_v488_2.retreat = 1;
        v844();
    end;
    local function v937()
        -- upvalues: v844 (ref)
        v844();
    end;
    local _ = nil;
    local function v941(v939)
        -- upvalues: l_v488_2 (ref), v844 (ref), v937 (ref), v936 (ref), v935 (ref)
        local v940 = v939:get();
        if not v940 then
            l_v488_2.point = nil;
            l_v488_2.retreat = -1;
            l_v488_2.retreat_point = nil;
            v844();
        end;
        events.shutdown(v937, v940);
        events.aim_fire(v936, v940);
        events.createmove(v935, v940);
    end;
    l_v487_2.enabled:set_callback(v941, true);
end;
v487 = nil;
v488 = v44.other.aimbot.log_events;
l_angles_1 = 6;
v491 = 6;
v493 = 4;
v494 = 8;
v743 = 4;
v744 = 24;
v745 = {};
do
    local l_v488_3, l_l_angles_1_4, l_v491_4, l_v493_4, l_v494_3, l_v743_1, l_v744_0, l_v745_1, l_v746_0, l_v747_0, l_v748_1, l_v749_1, l_v750_0, l_v751_1, l_v752_0, l_v753_0, l_v754_1, l_v755_0, l_v756_1, l_v757_0, l_v758_1 = v488, l_angles_1, v491, v493, v494, v743, v744, v745, v746, v747, v748, v749, v750, v751, v752, v753, v754, v755, v756, v757, v758;
    l_v746_0 = function()
        -- upvalues: l_v745_1 (ref)
        l_v745_1 = {};
    end;
    l_v747_0 = function(v963, v964)
        -- upvalues: l_v488_3 (ref), l_v745_1 (ref)
        if not l_v488_3.output:get("Notify") then
            return;
        else
            local v965 = {
                text = v964, 
                color = v963, 
                time = 5, 
                alpha = 0
            };
            table.insert(l_v745_1, 1, v965);
            return;
        end;
    end;
    l_v748_1 = function()
        -- upvalues: l_v745_1 (ref), v16 (ref), v9 (ref), v5 (ref), l_l_angles_1_4 (ref), l_v491_4 (ref), l_v493_4 (ref), l_v744_0 (ref), l_v743_1 (ref), l_v494_3 (ref)
        local l_frametime_0 = globals.frametime;
        local v967 = #l_v745_1;
        for v968 = v967, 1, -1 do
            local v969 = l_v745_1[v968];
            local v970 = v969.time > 0 and v967 - v968 < 5;
            v969.alpha = v16.interp(v969.alpha, v970, 0.05);
            if v970 then
                v969.time = v969.time - l_frametime_0;
            elseif v969.alpha <= 0 then
                table.remove(l_v745_1, v967);
            end;
        end;
        local v971 = render.screen_size() * 0.5;
        v971.y = v971.y * 1.7;
        local v972 = string.lower(v9.name);
        local v973 = render.measure_text(4, nil, v972);
        for v974 = 1, #l_v745_1 do
            local v975 = l_v745_1[v974];
            local v976, v977, v978, _ = v975.color:unpack();
            local l_text_0 = v975.text;
            local l_alpha_1 = v975.alpha;
            local v982 = v5(#l_text_0 * l_alpha_1);
            l_text_0 = string.sub(l_text_0, 1, v982);
            local v983 = render.measure_text(1, nil, l_text_0) + vector(l_l_angles_1_4, l_v491_4) * 2;
            v983.x = v983.x + v973.x + l_v493_4;
            local v984 = v971 - v983 * 0.5;
            local v985 = v984 + vector(l_l_angles_1_4, l_v491_4);
            local v986 = v985 + vector(v973.x + l_v493_4, 0);
            render.shadow(v984, v984 + v983, color(v976, v977, v978, 128 * l_alpha_1), l_v744_0, 0, l_v743_1);
            render.rect(v984, v984 + v983, color(18, 18, 18, 255 * l_alpha_1), l_v743_1);
            render.text(4, v985, color(v976, v977, v978, 255 * l_alpha_1), nil, v972);
            render.text(1, v986, color(200, 200, 200, 255 * l_alpha_1), nil, l_text_0);
            v971.y = v971.y + v5((v983.y + l_v494_3) * l_alpha_1);
        end;
    end;
    l_v749_1 = {
        [0] = "generic", 
        [1] = "head", 
        [2] = "chest", 
        [3] = "stomach", 
        [4] = "left arm", 
        [5] = "right arm", 
        [6] = "left leg", 
        [7] = "right leg", 
        [8] = "neck", 
        [9] = nil, 
        [10] = "gear"
    };
    l_v750_0 = {
        flashbang = "Harmed", 
        hegrenade = "Naded", 
        molotov = "Harmed", 
        inferno = "Burned", 
        decoy = "Decoyed", 
        knife = "Knifed", 
        c4 = "Bombed", 
        smokegrenade = "Harmed", 
        incgrenade = "Harmed"
    };
    l_v751_1 = function(v987, v988)
        -- upvalues: v9 (ref)
        return "\a" .. v988:to_hex() .. string.lower(v9.name) .. "\aC8C8C8FF" .. " \194\183 " .. v987;
    end;
    l_v752_0 = function(v989, v990)
        -- upvalues: l_v488_3 (ref), l_v751_1 (ref)
        if not l_v488_3.output:get("Debug") then
            return;
        else
            print_dev(l_v751_1(v990, v989));
            return;
        end;
    end;
    l_v753_0 = function(v991, v992)
        -- upvalues: l_v488_3 (ref), l_v751_1 (ref)
        if not l_v488_3.output:get("Console") then
            return;
        else
            print_raw(l_v751_1(v992, v991));
            return;
        end;
    end;
    l_v754_1 = function(v993)
        -- upvalues: l_v749_1 (ref)
        return l_v749_1[v993] or "?";
    end;
    l_v755_0 = function(v994)
        -- upvalues: l_v488_3 (ref), l_v754_1 (ref), l_v747_0 (ref), l_v752_0 (ref), l_v753_0 (ref)
        local l_target_0 = v994.target;
        if l_target_0 == nil then
            return;
        else
            local v996 = l_v488_3.color_hit:get();
            local v997 = "Hit";
            if not v994.target:is_alive() then
                v997 = "Killed";
            end;
            local v998 = l_target_0:get_name();
            local l_hitchance_0 = v994.hitchance;
            local v1000 = l_v754_1(v994.hitgroup);
            local v1001 = l_v754_1(v994.wanted_hitgroup);
            local l_damage_1 = v994.damage;
            local l_wanted_damage_0 = v994.wanted_damage;
            local l_backtrack_0 = v994.backtrack;
            local v1005 = l_wanted_damage_0 - l_damage_1 > 0;
            local v1006 = v1001 ~= v1000;
            local v1007 = nil;
            v1007 = string.format("%s %s in %s for %s damage", v997, v998, v1000, l_damage_1);
            local v1008 = nil;
            if v1006 then
                v1000 = string.format("%s(%s)", v1000, v1001);
            end;
            if v1005 then
                l_damage_1 = string.format("%s(%d)", l_damage_1, l_wanted_damage_0);
            end;
            local v1009 = {};
            local v1010 = " \194\183 ";
            table.insert(v1009, string.format("hc: %d%%", l_hitchance_0));
            table.insert(v1009, string.format("bt: %dt", l_backtrack_0));
            v1009 = table.concat(v1009, v1010);
            v1008 = string.format("%s %s in %s for %s damage (%s)", v997, v998, v1000, l_damage_1, v1009);
            l_v747_0(v996, v1007);
            l_v752_0(v996, v1008);
            l_v753_0(v996, v1008);
            return;
        end;
    end;
    l_v756_1 = function(v1011)
        -- upvalues: l_v488_3 (ref), l_v754_1 (ref), l_v747_0 (ref), l_v752_0 (ref), l_v753_0 (ref)
        local l_target_1 = v1011.target;
        if l_target_1 == nil then
            return;
        else
            local v1013 = l_v488_3.color_miss:get();
            local v1014 = l_target_1:get_name();
            local l_hitchance_1 = v1011.hitchance;
            local v1016 = l_v754_1(v1011.wanted_hitgroup);
            local l_backtrack_1 = v1011.backtrack;
            local l_state_0 = v1011.state;
            local v1019 = nil;
            v1019 = string.format("Missed %s's %s due to %s", v1014, v1016, l_state_0);
            local v1020 = nil;
            local v1021 = {};
            local v1022 = " \194\183 ";
            table.insert(v1021, string.format("hc: %d%%", l_hitchance_1));
            table.insert(v1021, string.format("bt: %dt", l_backtrack_1));
            v1021 = table.concat(v1021, v1022);
            v1020 = string.format("Missed %s's %s due to %s (%s)", v1014, v1016, l_state_0, v1021);
            l_v747_0(v1013, v1019);
            l_v752_0(v1013, v1020);
            l_v753_0(v1013, v1020);
            return;
        end;
    end;
    l_v757_0 = function(v1023)
        -- upvalues: l_v755_0 (ref), l_v756_1 (ref)
        if v1023.state == nil then
            l_v755_0(v1023);
        else
            l_v756_1(v1023);
        end;
    end;
    l_v758_1 = function(v1024)
        -- upvalues: l_v750_0 (ref), l_v488_3 (ref), l_v747_0 (ref), l_v752_0 (ref), l_v753_0 (ref)
        local v1025 = entity.get_local_player();
        local v1026 = entity.get(v1024.userid, true);
        if entity.get(v1024.attacker, true) ~= v1025 or v1026 == v1025 then
            return;
        else
            local v1027 = l_v750_0[v1024.weapon];
            if v1027 == nil then
                return;
            else
                local v1028 = l_v488_3.color_hit:get();
                local v1029 = v1026:get_name();
                local l_dmg_health_0 = v1024.dmg_health;
                local v1031 = string.format("%s %s for %d damage", v1027, v1029, l_dmg_health_0);
                l_v747_0(v1028, v1031);
                l_v752_0(v1028, v1031);
                l_v753_0(v1028, v1031);
                return;
            end;
        end;
    end;
    v759 = nil;
    v760 = function(v1032)
        -- upvalues: l_v746_0 (ref)
        if not v1032:get("Notify") then
            l_v746_0();
        end;
    end;
    do
        local l_v760_1 = v760;
        v761 = function(v1034)
            -- upvalues: l_v488_3 (ref), l_v760_1 (ref), l_v746_0 (ref), l_v758_1 (ref), l_v757_0 (ref), l_v748_1 (ref)
            local v1035 = v1034:get();
            if v1035 then
                l_v488_3.output:set_callback(l_v760_1);
            else
                l_v488_3.output:unset_callback(l_v760_1);
            end;
            if not v1035 then
                l_v746_0();
            end;
            events.player_hurt(l_v758_1, v1035);
            events.aim_ack(l_v757_0, v1035);
            events.render(l_v748_1, v1035);
        end;
        l_v488_3.enabled:set_callback(v761, true);
    end;
end;
v488 = nil;
l_angles_1 = v44.other.aimbot.clock_correction;
v491 = cvar.cl_clock_correction;
do
    local l_v491_5, l_v493_5, l_v494_4, l_v743_2 = v491, v493, v494, v743;
    l_v493_5 = function()
        -- upvalues: l_v491_5 (ref)
        l_v491_5:int(tonumber(l_v491_5:string()), true);
    end;
    l_v494_4 = function()
        -- upvalues: l_v491_5 (ref)
        l_v491_5:int(0, true);
    end;
    l_v743_2 = function()
        -- upvalues: l_v493_5 (ref)
        l_v493_5();
    end;
    v744 = nil;
    v745 = function(v1040)
        -- upvalues: l_v494_4 (ref), l_v493_5 (ref), l_v743_2 (ref)
        local v1041 = v1040:get();
        if v1041 then
            l_v494_4();
        else
            l_v493_5();
        end;
        events.shutdown(l_v743_2, v1041);
    end;
    l_angles_1.enabled:set_callback(v745, true);
end;
l_angles_1 = nil;
v491 = v44.other.aimbot.maxusrcmdprocessticks;
v493 = cvar.sv_maxusrcmdprocessticks;
do
    local l_v491_6, l_v493_6, l_v494_5, l_v743_3, l_v744_1 = v491, v493, v494, v743, v744;
    l_v494_5 = function()
        -- upvalues: l_v493_6 (ref)
        l_v493_6:int(tonumber(l_v493_6:string()), true);
    end;
    l_v743_3 = function()
        -- upvalues: l_v493_6 (ref), l_v491_6 (ref)
        l_v493_6:int(l_v491_6.ticks:get(), true);
    end;
    l_v744_1 = function()
        -- upvalues: l_v494_5 (ref)
        l_v494_5();
    end;
    v745 = nil;
    v746 = function(_)
        -- upvalues: l_v743_3 (ref)
        l_v743_3();
    end;
    do
        local l_v746_1 = v746;
        v747 = function(v1049)
            -- upvalues: l_v491_6 (ref), l_v746_1 (ref), l_v743_3 (ref), l_v494_5 (ref), l_v744_1 (ref)
            local v1050 = v1049:get();
            if v1050 then
                l_v491_6.ticks:set_callback(l_v746_1);
                l_v743_3();
            else
                l_v491_6.ticks:unset_callback(l_v746_1);
                l_v494_5();
            end;
            events.shutdown(l_v744_1, v1050);
        end;
        l_v491_6.enabled:set_callback(v747, true);
    end;
end;
v491 = nil;
v493 = v44.other.aimbot.fake_latency;
v494 = cvar.sv_maxunlag;
do
    local l_v494_6, l_v743_4, l_v744_2, l_v745_2 = v494, v743, v744, v745;
    l_v743_4 = function()
        -- upvalues: l_v494_6 (ref)
        l_v494_6:float(tonumber(l_v494_6:string()), true);
    end;
    l_v744_2 = function()
        -- upvalues: l_v494_6 (ref)
        l_v494_6:float(0.4, true);
    end;
    l_v745_2 = function()
        -- upvalues: l_v743_4 (ref)
        l_v743_4();
    end;
    v746 = nil;
    v747 = function(v1055)
        -- upvalues: l_v744_2 (ref), l_v743_4 (ref), l_v745_2 (ref)
        local v1056 = v1055:get();
        if v1056 then
            l_v744_2();
        else
            l_v743_4();
        end;
        events.shutdown(l_v745_2, v1056);
    end;
    v493.enabled:set_callback(v747, true);
end;
v485 = nil;
v486 = nil;
v487 = v44.other.visuals.crosshair_indicators;
v488 = 10;
l_angles_1 = 0;
v491 = 0;
v493 = 0;
v494 = 0;
v743 = 0;
v744 = 0;
v745 = 0;
v746 = 0;
v747 = 0;
v748 = function()
    -- upvalues: v43 (ref)
    local v1057 = ui.get_binds(true);
    for v1058 = 1, #v1057 do
        local v1059 = v1057[v1058];
        local l_value_0 = v1059.value;
        local l_reference_0 = v1059.reference;
        if l_reference_0:get() == l_value_0 and l_reference_0:id() == v43.rage.selection.min_damage:id() then
            return true;
        end;
    end;
    return false;
end;
v749 = function()
    -- upvalues: v43 (ref)
    local v1062 = ui.get_binds(true);
    for v1063 = 1, #v1062 do
        local v1064 = v1062[v1063];
        local l_value_1 = v1064.value;
        local l_reference_1 = v1064.reference;
        if l_reference_1:get() == l_value_1 and l_reference_1:id() == v43.rage.selection.hit_chance:id() then
            return true;
        end;
    end;
    return false;
end;
do
    local l_v487_3, l_v488_4, l_l_angles_1_5, l_v491_7, l_v493_7, l_v494_7, l_v743_5, l_v744_3, l_v745_3, l_v746_2, l_v747_1, l_v748_2, l_v749_2, l_v750_1, l_v751_2, l_v752_1, l_v753_1, l_v754_2, l_v755_1, l_v756_2, l_v757_1, l_v758_2, l_v759_1, l_v760_2 = v487, v488, l_angles_1, v491, v493, v494, v743, v744, v745, v746, v747, v748, v749, v750, v751, v752, v753, v754, v755, v756, v757, v758, v759, v760;
    l_v750_1 = function(v1091, v1092, v1093)
        -- upvalues: v9 (ref), v141 (ref), v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1094 = string.upper(v9.name);
        local v1095 = 2;
        local v1096 = -(globals.realtime * 1.5);
        v1094 = v141.gradient(v1094, v1096, v1092, v1093);
        v1096 = render.measure_text(v1095, nil, v1094);
        local v1097 = v1091:clone();
        v1097.x = v1097.x - v5(v1096.x * 0.5);
        v1092.a = v1092.a * l_l_angles_1_5;
        render.text(v1095, v1097, v1092, nil, v1094);
        v1091.y = v1091.y + l_v488_4;
    end;
    l_v751_2 = function(v1098, v1099)
        -- upvalues: v9 (ref), v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1100 = string.upper(v9.build);
        local v1101 = 2;
        local v1102 = render.measure_text(v1101, nil, v1100);
        local v1103 = v1098:clone();
        v1103.x = v1103.x - v5(v1102.x * 0.5);
        v1099.a = v1099.a * l_l_angles_1_5;
        render.text(v1101, v1103, v1099, nil, v1100);
        v1098.y = v1098.y + l_v488_4 + 2;
    end;
    l_v752_1 = function(v1104, v1105, v1106, v1107)
        -- upvalues: v9 (ref), v5 (ref), l_v494_7 (ref), l_l_angles_1_5 (ref)
        local v1108 = string.upper(v9.build);
        local v1109 = render.measure_text(2, nil, v1108);
        local l_x_0 = v1104.x;
        local l_y_0 = v1104.y;
        l_x_0 = l_x_0 - v5(v1109.x * 0.5);
        local v1112 = v1109.x - 2;
        local l_l_v494_7_0 = l_v494_7;
        v1105.a = v1105.a * (v1107 * l_l_angles_1_5);
        v1106.a = v1106.a * (v1107 * l_l_angles_1_5);
        render.gradient(vector(l_x_0, l_y_0), vector(l_x_0 + v1112, l_y_0 + l_l_v494_7_0), v1105, v1105, v1106, v1106);
        render.rect(vector(l_x_0, l_y_0), vector(l_x_0 + v1112, l_y_0 + 1), v1105);
        render.gradient(vector(l_x_0, l_y_0 + 1), vector(l_x_0 + 1, l_y_0 + l_l_v494_7_0), v1105, v1105, v1106, v1106);
        render.gradient(vector(l_x_0 + v1112, l_y_0 + 1), vector(l_x_0 + v1112 - 1, l_y_0 + l_l_v494_7_0), v1105, v1105, v1106, v1106);
    end;
    l_v753_1 = function(v1114, v1115, v1116)
        -- upvalues: v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1117 = "DMG";
        local v1118 = 2;
        local v1119 = render.measure_text(v1118, nil, v1117);
        local v1120 = v1114:clone();
        v1120.x = v1120.x - v5(v1119.x * 0.5);
        v1115.a = v1115.a * (v1116 * l_l_angles_1_5);
        render.text(v1118, v1120, v1115, nil, v1117);
        v1114.y = v1114.y + v5(l_v488_4 * v1116);
    end;
    l_v754_2 = function(v1121, v1122, v1123)
        -- upvalues: v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1124 = "HC";
        local v1125 = 2;
        local v1126 = render.measure_text(v1125, nil, v1124);
        local v1127 = v1121:clone();
        v1127.x = v1127.x - v5(v1126.x * 0.5);
        v1122.a = v1122.a * (v1123 * l_l_angles_1_5);
        render.text(v1125, v1127, v1122, nil, v1124);
        v1121.y = v1121.y + v5(l_v488_4 * v1123);
    end;
    l_v755_1 = function(v1128, v1129, v1130)
        -- upvalues: v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1131 = "DT";
        local v1132 = 2;
        local v1133 = render.measure_text(v1132, nil, v1131);
        local v1134 = v1128:clone();
        v1134.x = v1134.x - v5(v1133.x * 0.5);
        v1129 = color(255, 0, 0, 255):lerp(v1129, rage.exploit:get());
        v1129.a = v1129.a * (v1130 * l_l_angles_1_5);
        render.text(v1132, v1134, v1129, nil, v1131);
        v1128.y = v1128.y + v5(l_v488_4 * v1130);
    end;
    l_v756_2 = function(v1135, v1136, v1137)
        -- upvalues: v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1138 = "OS";
        local v1139 = 2;
        local v1140 = render.measure_text(v1139, nil, v1138);
        local v1141 = v1135:clone();
        v1141.x = v1141.x - v5(v1140.x * 0.5);
        v1136.a = v1136.a * (v1137 * l_l_angles_1_5);
        render.text(v1139, v1141, v1136, nil, v1138);
        v1135.y = v1135.y + v5(l_v488_4 * v1137);
    end;
    l_v757_1 = function(v1142, v1143, v1144)
        -- upvalues: v5 (ref), l_l_angles_1_5 (ref), l_v488_4 (ref)
        local v1145 = "FS";
        local v1146 = 2;
        local v1147 = render.measure_text(v1146, nil, v1145);
        local v1148 = v1142:clone();
        v1148.x = v1148.x - v5(v1147.x * 0.5);
        v1143.a = v1143.a * (v1144 * l_l_angles_1_5);
        render.text(v1146, v1148, v1143, nil, v1145);
        v1142.y = v1142.y + v5(l_v488_4 * v1144);
    end;
    l_v758_2 = function(v1149)
        -- upvalues: l_l_angles_1_5 (ref), v16 (ref), l_v491_7 (ref), l_v743_5 (ref), l_v748_2 (ref), l_v744_3 (ref), l_v749_2 (ref), l_v745_3 (ref), v43 (ref), l_v746_2 (ref), l_v747_1 (ref), v44 (ref), l_v493_7 (ref)
        local v1150 = v1149.m_bIsScoped and 1 or 0;
        l_l_angles_1_5 = v16.interp(l_l_angles_1_5, l_v491_7 == v1150, 0.05);
        if l_l_angles_1_5 <= 0 then
            l_v491_7 = v1150;
        end;
        l_v743_5 = v16.interp(l_v743_5, l_v748_2(), 0.04);
        l_v744_3 = v16.interp(l_v744_3, l_v749_2(), 0.04);
        l_v745_3 = v16.interp(l_v745_3, v43.rage.main.double_tap:get(), 0.04);
        l_v746_2 = v16.interp(l_v746_2, v43.rage.main.hide_shots:get(), 0.04);
        l_v747_1 = v16.interp(l_v747_1, v44.antiaim.hotkeys.freestanding.enabled:get(), 0.04);
        l_v493_7 = math.max(l_v743_5, l_v744_3, l_v745_3, l_v746_2, l_v747_1);
    end;
    l_v759_1 = function()
        -- upvalues: v5 (ref), l_v491_7 (ref), l_v487_3 (ref), l_v750_1 (ref), l_v751_2 (ref), l_v752_1 (ref), l_v493_7 (ref), l_v753_1 (ref), l_v743_5 (ref), l_v754_2 (ref), l_v744_3 (ref), l_v755_1 (ref), l_v745_3 (ref), l_v756_2 (ref), l_v746_2 (ref), l_v757_1 (ref), l_v747_1 (ref), l_v494_7 (ref)
        local v1151 = render.screen_size() * 0.5;
        v1151.x = v1151.x + v5(l_v491_7 * 32);
        v1151.y = v1151.y + l_v487_3.offset:get();
        local v1152 = l_v487_3.color:get();
        l_v750_1(v1151, v1152, color(255, 255, 255, 128));
        l_v751_2(v1151, color(255, 255, 255, 128));
        l_v752_1(v1151, color(255, 255, 255, 64), color(255, 255, 255, 0), l_v493_7);
        local l_y_1 = v1151.y;
        l_v753_1(v1151, color(255, 255, 255, 255), l_v743_5);
        l_v754_2(v1151, color(255, 255, 255, 255), l_v744_3);
        l_v755_1(v1151, color(255, 255, 255, 255), l_v745_3);
        l_v756_2(v1151, color(255, 255, 255, 255), (1 - l_v745_3) * l_v746_2);
        l_v757_1(v1151, color(255, 255, 255, 255), l_v747_1);
        l_v494_7 = v1151.y - l_y_1;
    end;
    l_v760_2 = function()
        -- upvalues: l_v758_2 (ref), l_v759_1 (ref)
        local v1154 = entity.get_local_player();
        if v1154 == nil or not v1154:is_alive() then
            return;
        else
            l_v758_2(v1154);
            l_v759_1();
            return;
        end;
    end;
    v761 = nil;
    v762 = function(v1155)
        -- upvalues: l_v760_2 (ref)
        events.render(l_v760_2, v1155:get());
    end;
    l_v487_3.enabled:set_callback(v762, true);
end;
v487 = nil;
v488 = v44.other.visuals.manual_arrows;
l_angles_1 = render.load_font("Verdana", 16, "a");
v491 = render.load_font("Verdana", 24, "a");
v493 = color(0, 0, 0, 96);
do
    local l_v488_5, l_l_angles_1_6, l_v491_8, l_v493_8, l_v494_8 = v488, l_angles_1, v491, v493, v494;
    l_v494_8 = function()
        -- upvalues: v44 (ref), l_v488_5 (ref), l_l_angles_1_6 (ref), l_v493_8 (ref), l_v491_8 (ref)
        local v1161 = entity.get_local_player();
        if v1161 == nil or not v1161:is_alive() then
            return;
        else
            local v1162 = render.screen_size() * 0.5;
            local v1163 = v44.antiaim.hotkeys.manual_yaw.direction:get();
            local v1164 = l_v488_5.style:get();
            local v1165 = l_v488_5.offset:get();
            local v1166 = l_v488_5.color:get();
            if v1164 == "Legacy" then
                if v1163 == "Left" then
                    local v1167 = "\226\157\174";
                    local l_l_l_angles_1_6_0 = l_l_angles_1_6;
                    local v1169 = render.measure_text(l_l_l_angles_1_6_0, "s", v1167);
                    local v1170 = vector(v1162.x - v1169.x - v1165 + 1, v1162.y - v1169.y * 0.5 - 1);
                    render.text(l_l_l_angles_1_6_0, v1170, v1166, "s", v1167);
                end;
                if v1163 == "Right" then
                    local v1171 = "\226\157\175";
                    local l_l_l_angles_1_6_1 = l_l_angles_1_6;
                    local v1173 = render.measure_text(l_l_l_angles_1_6_1, "s", v1171);
                    local v1174 = vector(v1162.x + v1165, v1162.y - v1173.y * 0.5 - 1);
                    render.text(l_l_l_angles_1_6_1, v1174, v1166, "s", v1171);
                end;
                return;
            else
                if v1164 == "TeamSkeet" then
                    local v1175 = 2;
                    local v1176 = 18;
                    local v1177 = 2;
                    local v1178 = math.floor(v1176 * 0.75);
                    local v1179 = rage.antiaim:get_rotation(false);
                    local v1180 = rage.antiaim:get_rotation(true);
                    local v1181 = math.normalize_yaw(v1180 - v1179);
                    local v1182 = v1181 < 0;
                    local v1183 = v1181 > 0;
                    local _ = nil;
                    local v1185 = v1162 - vector(v1165, 0);
                    local v1186 = vector(v1175, v1176);
                    local v1187 = v1185 - vector(v1186.x, v1186.y * 0.5);
                    local v1188 = v1182 and v1166 or l_v493_8;
                    local v1189 = v1163 == "Left" and v1166 or l_v493_8;
                    render.rect(v1187, v1187 + v1186, v1188);
                    v1185.x = v1185.x - (v1186.x + v1177);
                    local v1190 = vector(v1185.x, v1185.y - v1176 * 0.5);
                    local v1191 = vector(v1185.x, v1185.y + v1176 * 0.5);
                    local v1192 = vector(v1185.x - v1178, v1185.y);
                    render.poly(v1189, v1190, v1191, v1192);
                    v1185 = nil;
                    v1186 = v1162 + vector(v1165 + 1, 0);
                    v1187 = vector(v1175, v1176);
                    v1188 = v1186 - vector(0, v1187.y * 0.5);
                    v1189 = v1183 and v1166 or l_v493_8;
                    v1190 = v1163 == "Right" and v1166 or l_v493_8;
                    render.rect(v1188, v1188 + v1187, v1189);
                    v1186.x = v1186.x + (v1187.x + v1177);
                    v1191 = vector(v1186.x, v1186.y - v1176 * 0.5);
                    v1192 = vector(v1186.x, v1186.y + v1176 * 0.5);
                    local v1193 = vector(v1186.x + v1178, v1186.y);
                    render.poly(v1190, v1191, v1192, v1193);
                end;
                if v1164 == "Renewed" then
                    local v1194 = v1166:alpha_modulate(255);
                    if v1163 == "Left" then
                        local v1195 = "\226\174\156";
                        local l_l_v491_8_0 = l_v491_8;
                        local v1197 = render.measure_text(l_l_v491_8_0, "s", v1195);
                        local v1198 = vector(v1162.x - v1197.x - v1165 + 1, v1162.y - v1197.y * 0.5 - 1);
                        local v1199 = vector(v1198.x + v1197.x * 0.5, v1162.y);
                        render.shadow(v1199, v1199, v1194, l_l_v491_8_0.height + 4);
                        render.text(l_l_v491_8_0, v1198, v1166, "s", v1195);
                    end;
                    if v1163 == "Right" then
                        local v1200 = "\226\174\158";
                        local l_l_v491_8_1 = l_v491_8;
                        local v1202 = render.measure_text(l_l_v491_8_1, "s", v1200);
                        local v1203 = vector(v1162.x + v1165, v1162.y - v1202.y * 0.5 - 1);
                        local v1204 = vector(v1203.x + v1202.x * 0.5, v1162.y);
                        render.shadow(v1204, v1204, v1194, l_l_v491_8_1.height + 4);
                        render.text(l_l_v491_8_1, v1203, v1166, "s", v1200);
                    end;
                    return;
                else
                    return;
                end;
            end;
        end;
    end;
    v743 = nil;
    v744 = function(v1205)
        -- upvalues: l_v494_8 (ref)
        events.render(l_v494_8, v1205:get());
    end;
    l_v488_5.enabled:set_callback(v744, true);
end;
v488 = nil;
l_angles_1 = v44.other.visuals.damage_indicator;
v491 = 4;
v493 = 4;
v494 = {
    Pixel = 2, 
    Small = 1, 
    Bold = 4
};
v743 = v43.rage.selection.min_damage;
do
    local l_l_angles_1_7, l_v491_9, l_v493_9, l_v494_9, l_v743_6, l_v744_4, l_v745_4 = l_angles_1, v491, v493, v494, v743, v744, v745;
    l_v744_4 = function()
        -- upvalues: l_v743_6 (ref)
        local v1213 = ui.get_binds(true);
        for v1214 = 1, #v1213 do
            local v1215 = v1213[v1214];
            local l_value_2 = v1215.value;
            local l_reference_2 = v1215.reference;
            if l_reference_2:get() == l_value_2 and l_reference_2:id() == l_v743_6:id() then
                return true;
            end;
        end;
        return false;
    end;
    l_v745_4 = function()
        -- upvalues: l_v744_4 (ref), l_v743_6 (ref), l_l_angles_1_7 (ref), l_v494_9 (ref), l_v491_9 (ref), l_v493_9 (ref)
        local v1218 = entity.get_local_player();
        if v1218 == nil or not v1218:is_alive() then
            return;
        elseif not l_v744_4() then
            return;
        else
            local v1219 = render.screen_size() * 0.5;
            local v1220 = l_v743_6:get();
            local v1221 = l_l_angles_1_7.font:get();
            local v1222 = l_l_angles_1_7.color:get();
            local v1223 = tostring(v1220);
            local v1224 = l_v494_9[v1221];
            local v1225 = render.measure_text(v1224, nil, v1223);
            local v1226 = vector(v1219.x + l_v491_9, v1219.y - v1225.y - l_v493_9);
            render.text(v1224, v1226, v1222, nil, v1223);
            return;
        end;
    end;
    v746 = nil;
    v747 = function(v1227)
        -- upvalues: l_v745_4 (ref)
        events.render(l_v745_4, v1227:get());
    end;
    l_l_angles_1_7.enabled:set_callback(v747, true);
end;
l_angles_1 = nil;
v491 = v44.other.visuals.hit_marker;
v493 = {};
do
    local l_v491_10, l_v493_10, l_v494_10, l_v743_7, l_v744_5 = v491, v493, v494, v743, v744;
    l_v494_10 = function()
        -- upvalues: l_v493_10 (ref)
        l_v493_10 = {};
    end;
    l_v743_7 = function(v1233)
        -- upvalues: l_v493_10 (ref)
        local v1234 = {
            position = v1233.aim, 
            time = 3
        };
        table.insert(l_v493_10, v1234);
    end;
    l_v744_5 = function()
        -- upvalues: l_v493_10 (ref), l_v491_10 (ref)
        local v1235 = entity.get_local_player();
        if v1235 == nil or not v1235:is_alive() then
            return;
        else
            local l_frametime_1 = globals.frametime;
            local v1237 = #l_v493_10;
            for v1238 = v1237, 1, -1 do
                local v1239 = l_v493_10[v1238];
                if v1239.time > 0 then
                    v1239.time = v1239.time - l_frametime_1;
                else
                    table.remove(l_v493_10, v1237);
                end;
            end;
            local v1240 = l_v491_10.thickness:get() * 0.5;
            local v1241 = l_v491_10.size:get() + v1240;
            local v1242 = l_v491_10.color:get();
            for v1243 = 1, #l_v493_10 do
                local v1244 = l_v493_10[v1243];
                local v1245 = render.world_to_screen(v1244.position);
                if v1245 ~= nil then
                    local v1246 = math.clamp(v1244.time, 0, 1);
                    local v1247 = v1242:clone();
                    local v1248 = v1245 - vector(v1240, v1241);
                    local v1249 = v1245 + vector(v1240, v1241);
                    local v1250 = v1245 - vector(v1241, v1240);
                    local v1251 = v1245 + vector(v1241, v1240);
                    v1247.a = v1247.a * v1246;
                    render.rect(v1248, v1249, v1247);
                    render.rect(v1250, v1251, v1247);
                end;
            end;
            return;
        end;
    end;
    v745 = nil;
    v746 = function(v1252)
        -- upvalues: l_v494_10 (ref), l_v744_5 (ref), l_v743_7 (ref)
        local v1253 = v1252:get();
        if not v1253 then
            l_v494_10();
        end;
        events.render(l_v744_5, v1253);
        events.aim_ack(l_v743_7, v1253);
    end;
    l_v491_10.enabled:set_callback(v746, true);
end;
v491 = nil;
v493 = v44.other.visuals.velocity_warning;
v494 = 160;
v743 = 4;
v744 = 0;
do
    local l_v493_11, l_v494_11, l_v743_8, l_v744_6, l_v745_5 = v493, v494, v743, v744, v745;
    l_v745_5 = function()
        -- upvalues: l_v744_6 (ref), v16 (ref), l_v493_11 (ref), l_v494_11 (ref), l_v743_8 (ref)
        local v1259 = entity.get_local_player();
        if v1259 == nil or not v1259:is_alive() then
            return;
        else
            local l_m_flVelocityModifier_0 = v1259.m_flVelocityModifier;
            l_v744_6 = v16.interp(l_v744_6, l_m_flVelocityModifier_0 ~= 1 or ui.get_alpha() > 0.5, 0.05);
            if l_v744_6 <= 0 then
                return;
            else
                local v1261 = render.screen_size();
                local v1262 = vector(v1261.x * 0.5, l_v493_11.offset:get());
                local v1263 = l_v493_11.color:get();
                local v1264 = color(255, 255, 255, 255);
                local v1265 = color(0, 0, 0, 255);
                v1263.a = v1263.a * l_v744_6;
                v1264.a = v1264.a * l_v744_6;
                v1265.a = v1265.a * l_v744_6;
                local v1266 = string.format("Max velocity reduced by %s%%", math.floor(l_m_flVelocityModifier_0 * 100));
                local v1267 = 1;
                local v1268 = render.measure_text(v1267, nil, v1266);
                local v1269 = vector(v1262.x - v1268.x * 0.5, v1262.y);
                render.text(v1267, v1269, v1264, nil, v1266);
                v1262.y = v1262.y + 16;
                local v1270 = vector(v1262.x - l_v494_11 * 0.5, v1262.y);
                local v1271 = vector(v1262.x + l_v494_11 * 0.5, v1262.y + l_v743_8);
                render.shadow(v1270, v1271, v1263, 32, 0, 4);
                render.rect(v1270, v1271, v1265, 4);
                v1270 = v1270 + 1;
                v1271 = v1271 - 1;
                v1271.x = v1271.x - (l_v494_11 - l_v494_11 * l_m_flVelocityModifier_0);
                render.rect(v1270, v1271, v1263, 4);
                return;
            end;
        end;
    end;
    v746 = nil;
    v747 = function(v1272)
        -- upvalues: l_v745_5 (ref)
        events.render(l_v745_5, v1272:get());
    end;
    l_v493_11.enabled:set_callback(v747, true);
end;
v493 = nil;
v494 = v44.other.visuals.skeet_indicators;
v743 = vector(24, 22, 0);
v744 = render.load_font("Calibri", v743, "ab");
v745 = 520;
v746 = 8;
v747 = 24;
v748 = 4;
v749 = 3;
v750 = vector(30, 30);
v751 = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", v750);
v752 = color(0, 0, 0, 50);
v753 = color(0, 0, 0, 0);
v754 = function(v1273)
    local v1274 = v1273:get_override();
    if v1274 ~= nil then
        return v1274;
    else
        return v1273:get();
    end;
end;
v755 = function(v1275)
    local v1276 = ui.get_binds(true);
    for v1277 = 1, #v1276 do
        local v1278 = v1276[v1277];
        local l_value_3 = v1278.value;
        local l_reference_3 = v1278.reference;
        if l_reference_3:get() == l_value_3 and l_reference_3:id() == v1275:id() then
            return true;
        end;
    end;
    return false;
end;
v756 = function(v1281, v1282)
    local v1283 = 0.5;
    local v1284 = 0.5;
    if v1282 > 0 then
        local v1285 = v1281 * v1283;
        if v1282 < (v1281 - v1285) * v1284 then
            v1285 = v1281 - v1282 * (1 / v1284);
        end;
        v1281 = v1285;
    end;
    return v1281;
end;
do
    local l_v494_12, l_v744_7, l_v745_6, l_v746_3, l_v747_2, l_v748_3, l_v749_3, l_v750_2, l_v751_3, l_v752_2, l_v753_2, l_v754_3, l_v755_2, l_v756_3, l_v757_2, l_v758_3, l_v759_2, l_v760_3, l_v761_1, l_v762_0 = v494, v744, v745, v746, v747, v748, v749, v750, v751, v752, v753, v754, v755, v756, v757, v758, v759, v760, v761, v762;
    l_v757_2 = function(v1306, v1307)
        -- upvalues: l_v756_3 (ref)
        local v1308 = 1;
        local v1309 = 500;
        local v1310 = v1309 * 3.5;
        local v1311 = (v1307:get_origin() - v1306:get_origin()):length();
        local v1312 = v1310 / 3;
        local v1313 = v1309 * math.exp(-v1311 * v1311 / (2 * v1312 * v1312)) * v1308;
        return l_v756_3(v1313, v1306.m_ArmorValue);
    end;
    l_v758_3 = function(v1314, v1315, v1316, v1317, v1318)
        -- upvalues: l_v747_2 (ref), l_v748_3 (ref), l_v744_7 (ref), l_v750_2 (ref), l_v753_2 (ref), l_v752_2 (ref), v5 (ref), l_v746_3 (ref)
        local v1319 = v1314 + vector(l_v747_2, l_v748_3);
        local v1320 = render.measure_text(l_v744_7, nil, v1316);
        local l_v1320_0 = v1320;
        l_v1320_0.y = l_v1320_0.y + l_v748_3 * 2;
        l_v1320_0 = l_v1320_0 + vector(50, 2);
        v1319.y = v1319.y + 3;
        if v1317 then
            l_v1320_0.x = l_v1320_0.x + 30;
        end;
        if v1318 then
            l_v1320_0.x = l_v1320_0.x + l_v750_2.x + 2;
        end;
        local l_v1314_0 = v1314;
        local v1323 = v1314 + l_v1320_0;
        local v1324 = (l_v1314_0 + v1323) * 0.5;
        render.gradient(l_v1314_0, vector(v1324.x, v1323.y), l_v753_2, l_v752_2, l_v753_2, l_v752_2);
        render.gradient(v1323, vector(v1324.x, l_v1314_0.y), l_v753_2, l_v752_2, l_v753_2, l_v752_2);
        if v1318 then
            l_v1314_0 = v1314:clone();
            l_v1314_0.x = l_v1314_0.x + l_v747_2;
            l_v1314_0.y = l_v1314_0.y + (l_v1320_0.y - l_v750_2.y) * 0.5;
            render.texture(v1318, l_v1314_0, l_v750_2, v1315, "f");
            v1319.x = v1319.x + l_v750_2.x + 6;
        end;
        render.text(l_v744_7, v1319 + 1, color(0, 0, 0, 128), nil, v1316);
        render.text(l_v744_7, v1319, v1315, nil, v1316);
        v1319.x = v1319.x + v1320.x;
        if v1317 then
            l_v1314_0 = 10;
            v1323 = 5;
            v1324 = color(255, 255, 255, 200);
            local v1325 = vector(v1319.x + l_v1314_0 * 0.5 + 12, v1314.y + l_v1320_0.y * 0.5);
            render.circle_outline(v1325, color(0, 0, 0, 255), l_v1314_0, 0, 1, v1323);
            render.circle_outline(v1325, v1324, l_v1314_0 - 1, 0, v1317, v1323 - 2);
        end;
        v1314.y = v1314.y - v5(l_v1320_0.y + l_v746_3);
    end;
    l_v759_2 = function(v1326, v1327, v1328)
        -- upvalues: l_v758_3 (ref), l_v751_3 (ref)
        local v1329 = v1327:get_player_weapon();
        if v1329 == nil then
            return;
        elseif not v1329.m_bStartedArming then
            return;
        else
            local l_m_fArmedTime_0 = v1329.m_fArmedTime;
            if l_m_fArmedTime_0 == nil then
                return;
            else
                local v1331 = v1327:get_origin();
                local l_m_bombsiteCenterA_0 = v1328.m_bombsiteCenterA;
                local l_m_bombsiteCenterB_0 = v1328.m_bombsiteCenterB;
                local v1334 = v1331:distsqr(l_m_bombsiteCenterA_0) < v1331:distsqr(l_m_bombsiteCenterB_0) and "A" or "B";
                local v1335 = (l_m_fArmedTime_0 - globals.curtime) / 3;
                l_v758_3(v1326, color(252, 243, 105, 255), v1334, 1 - v1335, l_v751_3);
                return;
            end;
        end;
    end;
    l_v760_3 = function(v1336, v1337, v1338)
        -- upvalues: l_v758_3 (ref), l_v751_3 (ref), l_v757_2 (ref)
        local l_m_bBombDefused_0 = v1338.m_bBombDefused;
        if not v1338.m_bBombTicking or l_m_bBombDefused_0 then
            return;
        else
            local l_curtime_0 = globals.curtime;
            local l_m_flC4Blow_0 = v1338.m_flC4Blow;
            local v1342 = l_m_flC4Blow_0 - l_curtime_0;
            if v1342 > 0 then
                if v1338.m_hBombDefuser ~= nil then
                    local v1343 = render.screen_size();
                    local l_m_flDefuseCountDown_0 = v1338.m_flDefuseCountDown;
                    local v1345 = (l_m_flDefuseCountDown_0 - l_curtime_0) / 10;
                    local v1346 = l_m_flC4Blow_0 < l_m_flDefuseCountDown_0 and color(235, 50, 75, 125) or color(50, 235, 75, 125);
                    local v1347 = (v1343.y - 2) * v1345;
                    render.rect(vector(0, 0), vector(20, v1343.y), color(0, 0, 0, 115));
                    render.rect(vector(1, 1 + v1347), vector(19, v1343.y - 1), v1346);
                end;
                local v1348 = string.format("%s - %.1fs", v1338.m_nBombSite == 1 and "B" or "A", v1342);
                l_v758_3(v1336, color(255, 255, 255, 200), v1348, nil, l_v751_3);
            end;
            local l_m_iHealth_1 = v1337.m_iHealth;
            local v1350 = l_v757_2(v1337, v1338);
            v1350 = math.floor(v1350);
            if l_m_iHealth_1 <= v1350 then
                l_v758_3(v1336, color(255, 0, 50, 255), "FATAL");
            elseif v1350 > 0 then
                l_v758_3(v1336, color(252, 243, 105, 255), string.format("-%d HP", v1350));
            end;
            return;
        end;
    end;
    l_v761_1 = function(v1351, v1352)
        -- upvalues: l_v759_2 (ref), l_v760_3 (ref)
        local v1353 = entity.get_game_rules();
        if v1353 == nil then
            return;
        else
            local v1354 = entity.get_player_resource();
            if v1354 == nil then
                return;
            else
                local l_m_bBombPlanted_0 = v1353.m_bBombPlanted;
                local l_m_iPlayerC4_0 = v1354.m_iPlayerC4;
                if l_m_iPlayerC4_0 ~= nil and l_m_iPlayerC4_0 ~= 0 then
                    local v1357 = entity.get(l_m_iPlayerC4_0);
                    if v1357 ~= nil then
                        l_v759_2(v1351, v1357, v1354);
                    end;
                end;
                if l_m_bBombPlanted_0 then
                    local v1358 = entity.get_entities("CPlantedC4")[1];
                    if v1358 ~= nil then
                        l_v760_3(v1351, v1352, v1358);
                    end;
                end;
                return;
            end;
        end;
    end;
    l_v762_0 = function()
        -- upvalues: l_v749_3 (ref), l_v745_6 (ref), l_v494_12 (ref), l_v754_3 (ref), v43 (ref), l_v758_3 (ref), v44 (ref), l_v755_2 (ref), l_v761_1 (ref)
        local v1359 = entity.get_local_player();
        if v1359 == nil then
            return;
        else
            local v1360 = render.screen_size();
            local v1361 = vector(l_v749_3, v1360.y - (v1360.y - l_v745_6) * 0.5);
            if v1359:is_alive() then
                if l_v494_12.items:get("PING") then
                    local v1362 = l_v754_3(v43.misc.main.other.fake_latency);
                    if v1362 > 0 then
                        local v1363 = utils.net_channel();
                        if v1363 ~= nil then
                            local v1364 = nil;
                            local v1365 = math.clamp(v1363.latency[0] + v1363.latency[1], 0.001, 0.2);
                            local v1366 = math.clamp(v1362 * 0.001 + v1363.avg_latency[1], 0.001, 0.2);
                            local v1367 = math.clamp(v1365 / v1366, 0, 1);
                            if v1367 < 0.5 then
                                v1364 = color(200, 200, 200, 255):lerp(color(213, 197, 84, 255), v1367 * 2);
                            else
                                v1364 = color(213, 197, 84, 255):lerp(color(143, 194, 21, 255), (v1367 - 0.5) * 2);
                            end;
                            if v1364 ~= nil then
                                l_v758_3(v1361, v1364, "PING");
                            end;
                        end;
                    end;
                end;
                if l_v494_12.items:get("DT") and l_v754_3(v43.rage.main.double_tap) and not l_v754_3(v43.antiaim.misc.fake_duck) then
                    local v1368 = color(255, 0, 50, 255);
                    if rage.exploit:get() == 1 then
                        v1368 = color(255, 255, 255, 200);
                    end;
                    l_v758_3(v1361, v1368, "DT");
                end;
                if l_v494_12.items:get("OSAA") and l_v754_3(v43.rage.main.hide_shots) and not l_v754_3(v43.rage.main.double_tap) and not l_v754_3(v43.antiaim.misc.fake_duck) then
                    l_v758_3(v1361, color(255, 255, 255, 200), "OSAA");
                end;
                if l_v494_12.items:get("DUCK") and l_v754_3(v43.antiaim.misc.fake_duck) then
                    l_v758_3(v1361, color(255, 255, 255, 200), "DUCK");
                end;
                if l_v494_12.items:get("DA") and (l_v754_3(v43.rage.main.dormant_aimbot) or v44.other.aimbot.dormant_aimbot.enabled:get()) then
                    local v1369 = color(255, 0, 50, 255);
                    if #entity.get_players(true, false) == 0 then
                        v1369 = color(255, 255, 255, 200);
                    end;
                    l_v758_3(v1361, v1369, "DA");
                end;
                if l_v494_12.items:get("SAFE") and l_v754_3(v43.rage.safety.safe_points) == "Force" then
                    l_v758_3(v1361, color(255, 255, 255, 200), "SAFE");
                end;
                if l_v494_12.items:get("BODY") and l_v754_3(v43.rage.safety.body_aim) == "Force" then
                    l_v758_3(v1361, color(255, 255, 255, 200), "BODY");
                end;
                if l_v494_12.items:get("MD") and l_v755_2(v43.rage.selection.min_damage) then
                    l_v758_3(v1361, color(255, 255, 255, 200), "MD");
                end;
                if l_v494_12.items:get("HC") and l_v755_2(v43.rage.selection.hit_chance) then
                    l_v758_3(v1361, color(255, 255, 255, 200), "HC");
                end;
                if l_v494_12.items:get("FS") and l_v754_3(v43.antiaim.angles.freestanding) then
                    l_v758_3(v1361, color(255, 255, 255, 200), "FS");
                end;
            end;
            if l_v494_12.items:get("Bomb Information") then
                l_v761_1(v1361, v1359);
            end;
            return;
        end;
    end;
    v763 = nil;
    v764 = function(v1370)
        -- upvalues: l_v762_0 (ref)
        events.render(l_v762_0, v1370:get());
    end;
    l_v494_12.enabled:set_callback(v764, true);
end;
v494 = nil;
v743 = v44.other.visuals.scope_overlay;
v744 = 0;
do
    local l_v743_9, l_v744_8, l_v745_7 = v743, v744, v745;
    l_v745_7 = function()
        -- upvalues: l_v744_8 (ref), v16 (ref), v43 (ref), l_v743_9 (ref)
        local v1374 = entity.get_local_player();
        if v1374 == nil or not v1374:is_alive() then
            return;
        else
            local v1375 = v1374:get_player_weapon();
            if v1375 == nil then
                return;
            else
                l_v744_8 = v16.interp(l_v744_8, v1374.m_bIsScoped, 0.05);
                if l_v744_8 <= 0 then
                    return;
                else
                    v43.visuals.world.main.scope_overlay:override("Remove All");
                    local v1376 = render.screen_size() * 0.5;
                    local v1377 = l_v743_9.additions:get("Inverted");
                    local v1378 = l_v743_9.additions:get("Rotated");
                    local v1379 = l_v743_9.additions:get("Spread Dependency");
                    local v1380 = l_v743_9.size:get() * l_v744_8;
                    local v1381 = l_v743_9.gap:get();
                    local v1382 = l_v743_9.color:get();
                    local v1383 = v1375:get_inaccuracy();
                    if v1379 then
                        v1381 = v1381 + v1383 * 100;
                    end;
                    local v1384 = v1382:clone();
                    local v1385 = v1382:clone();
                    v1384.a = v1377 and v1384.a * l_v744_8 or 0;
                    v1385.a = v1377 and 0 or v1385.a * l_v744_8;
                    if v1378 then
                        render.push_rotation(45);
                    end;
                    if not l_v743_9.exclude_lines:get("Top") then
                        local v1386 = vector(v1376.x, v1376.y - (v1380 + v1381));
                        local v1387 = vector(v1386.x + 1, v1376.y - v1381);
                        render.gradient(v1386, v1387, v1384, v1384, v1385, v1385);
                    end;
                    if not l_v743_9.exclude_lines:get("Bottom") then
                        local v1388 = vector(v1376.x, v1376.y + v1380 + v1381);
                        local v1389 = vector(v1388.x + 1, v1376.y + v1381);
                        render.gradient(v1388, v1389, v1384, v1384, v1385, v1385);
                    end;
                    if not l_v743_9.exclude_lines:get("Left") then
                        local v1390 = vector(v1376.x - (v1380 + v1381), v1376.y);
                        local v1391 = vector(v1376.x - v1381, v1376.y + 1);
                        render.gradient(v1390, v1391, v1384, v1385, v1384, v1385);
                    end;
                    if not l_v743_9.exclude_lines:get("Right") then
                        local v1392 = vector(v1376.x + v1380 + v1381, v1376.y);
                        local v1393 = vector(v1376.x + v1381, v1376.y + 1);
                        render.gradient(v1392, v1393, v1384, v1385, v1384, v1385);
                    end;
                    if v1378 then
                        render.pop_rotation();
                    end;
                    return;
                end;
            end;
        end;
    end;
    v746 = nil;
    v747 = function(v1394)
        -- upvalues: v43 (ref), l_v745_7 (ref)
        local v1395 = v1394:get();
        if not v1395 then
            v43.visuals.world.main.scope_overlay:override();
        end;
        events.render(l_v745_7, v1395);
    end;
    l_v743_9.enabled:set_callback(v747, true);
end;
v743 = nil;
v744 = v44.other.visuals.aspect_ratio;
v745 = cvar.r_aspectratio;
do
    local l_v744_9, l_v745_8, l_v746_4, l_v747_3, l_v748_4 = v744, v745, v746, v747, v748;
    l_v746_4 = function()
        -- upvalues: l_v745_8 (ref)
        l_v745_8:float(tonumber(l_v745_8:string()), true);
    end;
    l_v747_3 = function()
        -- upvalues: l_v745_8 (ref), l_v744_9 (ref)
        l_v745_8:float(l_v744_9.proportion:get() * 0.01, true);
    end;
    l_v748_4 = function()
        -- upvalues: l_v746_4 (ref)
        l_v746_4();
    end;
    v749 = nil;
    v750 = function(v1401)
        -- upvalues: l_v744_9 (ref), l_v747_3 (ref), l_v746_4 (ref), l_v748_4 (ref)
        local v1402 = v1401:get();
        if v1402 then
            l_v744_9.proportion:set_callback(l_v747_3);
            l_v747_3();
        else
            l_v744_9.proportion:unset_callback(l_v747_3);
            l_v746_4();
        end;
        events.shutdown(l_v748_4, v1402);
    end;
    l_v744_9.enabled:set_callback(v750, true);
end;
v744 = nil;
v745 = v44.other.visuals.viewmodel;
v746 = cvar.viewmodel_fov;
v747 = cvar.viewmodel_offset_x;
v748 = cvar.viewmodel_offset_y;
v749 = cvar.viewmodel_offset_z;
do
    local l_v745_9, l_v746_5, l_v747_4, l_v748_5, l_v749_4, l_v750_3, l_v751_4, l_v752_3 = v745, v746, v747, v748, v749, v750, v751, v752;
    l_v750_3 = function()
        -- upvalues: l_v746_5 (ref), l_v747_4 (ref), l_v748_5 (ref), l_v749_4 (ref)
        l_v746_5:float(tonumber(l_v746_5:string()), true);
        l_v747_4:float(tonumber(l_v747_4:string()), true);
        l_v748_5:float(tonumber(l_v748_5:string()), true);
        l_v749_4:float(tonumber(l_v749_4:string()), true);
    end;
    l_v751_4 = function()
        -- upvalues: l_v746_5 (ref), l_v745_9 (ref), l_v747_4 (ref), l_v748_5 (ref), l_v749_4 (ref)
        l_v746_5:float(l_v745_9.fov:get() * 0.1, true);
        l_v747_4:float(l_v745_9.offset_x:get() * 0.1, true);
        l_v748_5:float(l_v745_9.offset_y:get() * 0.1, true);
        l_v749_4:float(l_v745_9.offset_z:get() * 0.1, true);
    end;
    l_v752_3 = function()
        -- upvalues: l_v750_3 (ref)
        l_v750_3();
    end;
    v753 = nil;
    v754 = function(v1411)
        -- upvalues: l_v745_9 (ref), l_v751_4 (ref), l_v750_3 (ref), l_v752_3 (ref)
        local v1412 = v1411:get();
        if v1412 then
            l_v745_9.fov:set_callback(l_v751_4);
            l_v745_9.offset_x:set_callback(l_v751_4);
            l_v745_9.offset_y:set_callback(l_v751_4);
            l_v745_9.offset_z:set_callback(l_v751_4);
            l_v751_4();
        else
            l_v745_9.fov:unset_callback(l_v751_4);
            l_v745_9.offset_x:unset_callback(l_v751_4);
            l_v745_9.offset_y:unset_callback(l_v751_4);
            l_v745_9.offset_z:unset_callback(l_v751_4);
            l_v750_3();
        end;
        events.shutdown(l_v752_3, v1412);
    end;
    l_v745_9.enabled:set_callback(v754, true);
end;
v745 = nil;
v746 = v44.other.visuals.animations;
v747 = ffi.typeof("                struct {\n                    float  m_flLayerAnimtime;\n                    float  m_flLayerFadeOuttime;\n        \n                    // dispatch flags\n                    void  *m_pDispatchedStudioHdr;\n                    int    m_nDispatchedSrc;\n                    int    m_nDispatchedDst;\n        \n                    int    m_nOrder;\n                    int    m_nSequence;\n                    float  m_flPrevCycle;\n                    float  m_flWeight;\n                    float  m_flWeightDeltaRate;\n        \n                    // used for automatic crossfades between sequence changes;\n                    float  m_flPlaybackRate;\n                    float  m_flCycle;\n                    int    m_pOwner;\n                    int    m_nInvalidatePhysicsBits;\n                } **\n            ");
do
    local l_v746_6, l_v747_5, l_v748_6, l_v749_5, l_v750_4, l_v751_5, l_v752_4, l_v753_3, l_v754_4, l_v755_3, l_v756_4, l_v757_3 = v746, v747, v748, v749, v750, v751, v752, v753, v754, v755, v756, v757;
    l_v748_6 = function(v1425)
        -- upvalues: l_v747_5 (ref)
        return ffi.cast(l_v747_5, ffi.cast("uintptr_t", v1425[0]) + 10640)[0];
    end;
    l_v749_5 = 6;
    l_v750_4 = 12;
    l_v751_5 = function(v1426)
        -- upvalues: l_v746_6 (ref), v43 (ref)
        local v1427 = l_v746_6.on_ground:get();
        if v1427 == "Static" then
            v1426.m_flPoseParameter[0] = 1;
            v43.antiaim.misc.leg_movement:override("Sliding");
            return;
        elseif v1427 == "Jitter" then
            if globals.tickcount % 4 > 1 then
                v1426.m_flPoseParameter[0] = 1;
                v1426.m_flPoseParameter[1] = 1;
            end;
            v43.antiaim.misc.leg_movement:override("Sliding");
            return;
        elseif v1427 == "Walking" then
            v1426.m_flPoseParameter[7] = 0;
            v43.antiaim.misc.leg_movement:override("Walking");
            return;
        elseif v1427 == "Kangaroo" then
            v1426.m_flPoseParameter[0] = utils.random_float(0, 1);
            v43.antiaim.misc.leg_movement:override("Sliding");
            return;
        else
            v43.antiaim.misc.leg_movement:override();
            return;
        end;
    end;
    l_v752_4 = function(v1428)
        -- upvalues: l_v746_6 (ref), l_v748_6 (ref), l_v749_5 (ref)
        local v1429 = l_v746_6.in_air:get();
        if v1429 == "Static" then
            v1428.m_flPoseParameter[6] = 1;
            return;
        elseif v1429 == "Jitter" then
            v1428.m_flPoseParameter[6] = globals.tickcount % 4 > 1 and 1 or 0;
            return;
        elseif v1429 == "Walking" then
            local v1430 = l_v748_6(v1428);
            if v1430 == nil then
                return;
            else
                local v1431 = v1430[l_v749_5];
                if v1431 == nil then
                    return;
                else
                    v1431.m_flWeight = 1;
                    return;
                end;
            end;
        elseif v1429 == "Kangaroo" then
            v1428.m_flPoseParameter[6] = utils.random_float(0.1, 1);
            return;
        else
            return;
        end;
    end;
    l_v753_3 = function(v1432)
        -- upvalues: l_v746_6 (ref)
        if not l_v746_6.pitch_on_land:get() then
            return;
        else
            local v1433 = v1432:get_anim_state();
            if v1433 == nil or not v1433.landing then
                return;
            else
                v1432.m_flPoseParameter[12] = 0.5;
                return;
            end;
        end;
    end;
    l_v754_4 = function(v1434)
        -- upvalues: l_v746_6 (ref)
        if not l_v746_6.sliding_slowwalk:get() then
            return;
        else
            v1434.m_flPoseParameter[9] = 0;
            return;
        end;
    end;
    l_v755_3 = function(v1435)
        -- upvalues: l_v746_6 (ref)
        if not l_v746_6.sliding_crouch:get() then
            return;
        else
            v1435.m_flPoseParameter[8] = 0;
            return;
        end;
    end;
    l_v756_4 = function(v1436)
        -- upvalues: l_v748_6 (ref), l_v750_4 (ref), l_v746_6 (ref)
        local v1437 = l_v748_6(v1436);
        if v1437 == nil then
            return;
        else
            local v1438 = v1437[l_v750_4];
            if v1438 == nil then
                return;
            elseif l_v746_6.earthquake:get() then
                v1438.m_flWeight = utils.random_float(0, 1);
                return;
            else
                local v1439 = l_v746_6.move_lean:get();
                if v1439 == -1 then
                    return;
                else
                    v1438.m_flWeight = v1439 * 0.01;
                    return;
                end;
            end;
        end;
    end;
    l_v757_3 = function(v1440)
        -- upvalues: l_v751_5 (ref), l_v752_4 (ref), l_v753_3 (ref), l_v754_4 (ref), l_v755_3 (ref), l_v756_4 (ref)
        local v1441 = entity.get_local_player();
        if v1440 ~= v1441 then
            return;
        else
            l_v751_5(v1441);
            l_v752_4(v1441);
            l_v753_3(v1441);
            l_v754_4(v1441);
            l_v755_3(v1441);
            l_v756_4(v1441);
            return;
        end;
    end;
    v758 = nil;
    v759 = function(v1442)
        -- upvalues: v43 (ref), l_v757_3 (ref)
        local v1443 = v1442:get();
        if not v1443 then
            v43.antiaim.misc.leg_movement:override();
        end;
        events.post_update_clientside_animation(l_v757_3, v1443);
    end;
    l_v746_6.enabled:set_callback(v759, true);
end;
v746 = nil;
v747 = v44.other.visuals.nade_radius;
do
    local l_v747_6, l_v748_7 = v747, v748;
    l_v748_7 = function()
        -- upvalues: l_v747_6 (ref)
        if entity.get_local_player() == nil then
            return;
        else
            local v1446 = l_v747_6.molotov_color:get();
            local v1447 = l_v747_6.smoke_color:get();
            if l_v747_6.molotov:get() then
                entity.get_entities("CInferno", nil, function(v1448)
                    -- upvalues: v1446 (ref)
                    local v1449 = v1448:get_origin();
                    local v1450 = v1448:get_bbox();
                    local v1451 = v1446:clone();
                    v1451.a = v1451.a * v1450.alpha;
                    render.circle_3d_outline(v1449, v1451, 125, 0, 1, 1.5);
                end);
            end;
            if l_v747_6.smoke:get() then
                entity.get_entities("CSmokeGrenadeProjectile", nil, function(v1452)
                    -- upvalues: v1447 (ref)
                    if not v1452.m_bDidSmokeEffect then
                        return;
                    else
                        local v1453 = v1452:get_origin();
                        local v1454 = v1452:get_bbox();
                        local v1455 = v1447:clone();
                        v1455.a = v1455.a * v1454.alpha;
                        render.circle_3d_outline(v1453, v1455, 125, 0, 1, 1.5);
                        return;
                    end;
                end);
            end;
            return;
        end;
    end;
    v749 = nil;
    v750 = function(v1456)
        -- upvalues: l_v748_7 (ref)
        events.render(l_v748_7, v1456:get());
    end;
    l_v747_6.enabled:set_callback(v750, true);
end;
v747 = nil;
v748 = v44.other.visuals.lag_comp_box;
v749 = {};
v750 = {};
v751 = function(v1457, v1458, v1459)
    return v1457 + v1458 * (globals.tickinterval * v1459);
end;
do
    local l_v748_8, l_v749_6, l_v750_5, l_v751_6, l_v752_5 = v748, v749, v750, v751, v752;
    l_v752_5 = function()
        -- upvalues: l_v748_8 (ref), l_v749_6 (ref), l_v750_5 (ref), l_v751_6 (ref), v17 (ref)
        if entity.get_local_player() == nil then
            return;
        else
            local v1465 = l_v748_8.color:get();
            local v1466 = color(0, 0, 0, 0);
            entity.get_players(true, false, function(v1467)
                -- upvalues: l_v749_6 (ref), l_v750_5 (ref), l_v751_6 (ref), v17 (ref), v1466 (ref), v1465 (ref)
                local v1468 = v1467:get_index();
                if not v1467:is_enemy() or not v1467:is_alive() or v1467:is_dormant() or v1467:get_network_state() == 5 then
                    l_v749_6[v1468] = nil;
                    l_v750_5[v1468] = nil;
                else
                    local l_m_vecOrigin_3 = v1467.m_vecOrigin;
                    local l_m_vecVelocity_2 = v1467.m_vecVelocity;
                    local l_m_vecMins_1 = v1467.m_vecMins;
                    local l_m_vecMaxs_1 = v1467.m_vecMaxs;
                    if l_v750_5[v1468] then
                        local v1473 = v1467:get_simulation_time();
                        local v1474 = v1473.current - v1473.old;
                        if v1474 < 0 or v1474 > 0 and v1474 <= 64 then
                            local v1475 = l_m_vecOrigin_3:distsqr(l_v750_5[v1468].m_vecOrigin);
                            l_v749_6[v1468] = {
                                predicted_origin = l_v751_6(l_m_vecOrigin_3, l_m_vecVelocity_2, v1474), 
                                is_lagcomp = v1475 > 4096
                            };
                        end;
                    end;
                    if l_v749_6[v1468] and l_v749_6[v1468].is_lagcomp then
                        local l_predicted_origin_0 = l_v749_6[v1468].predicted_origin;
                        v17.box_new(l_predicted_origin_0, l_m_vecMins_1, l_m_vecMaxs_1, vector(), v1466, v1465, globals.tickinterval * 2);
                    end;
                    l_v750_5[v1468] = {
                        m_vecOrigin = l_m_vecOrigin_3
                    };
                end;
            end);
            return;
        end;
    end;
    v753 = nil;
    v754 = function(v1477)
        -- upvalues: l_v752_5 (ref)
        events.net_update_end(l_v752_5, v1477:get());
    end;
    l_v748_8.enabled:set_callback(v754, true);
end;
v748 = nil;
v749 = v44.other.visuals.console_color;
v750 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
v751 = {
    [1] = materials.get_materials("vgui_white")[1], 
    [2] = materials.get_materials("vgui/hud/800corner1")[1], 
    [3] = materials.get_materials("vgui/hud/800corner2")[1], 
    [4] = materials.get_materials("vgui/hud/800corner3")[1], 
    [5] = materials.get_materials("vgui/hud/800corner4")[1]
};
do
    local l_v749_7, l_v750_6, l_v751_7, l_v752_6, l_v753_4, l_v754_5, l_v755_4 = v749, v750, v751, v752, v753, v754, v755;
    l_v752_6 = function()
        -- upvalues: l_v751_7 (ref)
        for v1485 = 1, #l_v751_7 do
            l_v751_7[v1485]:reset();
        end;
    end;
    l_v753_4 = function(v1486)
        -- upvalues: l_v751_7 (ref)
        local v1487 = v1486.a / 255;
        for v1488 = 1, #l_v751_7 do
            local v1489 = l_v751_7[v1488];
            v1489:alpha_modulate(v1487);
            v1489:color_modulate(v1486);
        end;
    end;
    l_v754_5 = function()
        -- upvalues: l_v750_6 (ref), l_v753_4 (ref), l_v749_7 (ref)
        if not l_v750_6() then
            l_v753_4(color(255, 255, 255, 255));
        else
            l_v753_4(l_v749_7.color:get());
        end;
    end;
    l_v755_4 = function()
        -- upvalues: l_v752_6 (ref)
        l_v752_6();
    end;
    v756 = nil;
    v757 = function(v1490)
        -- upvalues: l_v752_6 (ref), l_v755_4 (ref), l_v754_5 (ref)
        local v1491 = v1490:get();
        if not v1491 then
            l_v752_6();
        end;
        events.shutdown(l_v755_4, v1491);
        events.pre_render(l_v754_5, v1491);
    end;
    l_v749_7.enabled:set_callback(v757, true);
end;
v749 = nil;
v750 = v44.other.visuals.keep_transparency;
v751 = function(_)
    local v1493 = entity.get_local_player();
    if v1493 == nil then
        return;
    else
        local l_m_bIsScoped_0 = v1493.m_bIsScoped;
        local l_m_bResumeZoom_0 = v1493.m_bResumeZoom;
        if not l_m_bIsScoped_0 and not l_m_bResumeZoom_0 then
            return;
        else
            return 59;
        end;
    end;
end;
v752 = nil;
do
    local l_v751_8 = v751;
    v753 = function(v1497)
        -- upvalues: l_v751_8 (ref)
        events.localplayer_transparency(l_v751_8, v1497:get());
    end;
    v750.enabled:set_callback(v753, true);
end;
v750 = nil;
v751 = v44.other.visuals.remove_footsteps_shadow;
v752 = cvar.cl_foot_contact_shadows;
do
    local l_v752_7, l_v753_5, l_v754_6, l_v755_5 = v752, v753, v754, v755;
    l_v753_5 = function()
        -- upvalues: l_v752_7 (ref)
        l_v752_7:int(0, true);
    end;
    l_v754_6 = function()
        -- upvalues: l_v752_7 (ref)
        l_v752_7:int(tonumber(l_v752_7:string()), true);
    end;
    l_v755_5 = function()
        -- upvalues: l_v754_6 (ref)
        l_v754_6();
    end;
    v756 = nil;
    v757 = function(v1502)
        -- upvalues: l_v753_5 (ref), l_v754_6 (ref), l_v755_5 (ref)
        local v1503 = v1502:get();
        if v1503 then
            l_v753_5();
        else
            l_v754_6();
        end;
        events.shutdown(l_v755_5, v1503);
    end;
    v751.enabled:set_callback(v757, true);
end;
v486 = nil;
v487 = nil;
v488 = v44.other.misc.avoid_collisions;
l_angles_1 = function(v1504)
    local v1505 = entity.get_local_player();
    if v1505 == nil then
        return;
    else
        local l_m_fFlags_2 = v1505.m_fFlags;
        if bit.band(l_m_fFlags_2, 1) == 1 then
            return;
        elseif v1504.in_duck or v1504.in_speed then
            return;
        else
            local v1507 = render.camera_angles();
            local l_m_vecOrigin_4 = v1505.m_vecOrigin;
            local l_m_vecVelocity_3 = v1505.m_vecVelocity;
            l_m_vecVelocity_3.z = 0;
            local l_m_vecMins_2 = v1505.m_vecMins;
            local l_m_vecMaxs_2 = v1505.m_vecMaxs;
            local v1512 = vector():angles(0, v1507.y);
            local v1513 = v1512:vectors();
            local v1514 = vector(v1512.x * v1504.forwardmove + v1513.x * v1504.sidemove, v1512.y * v1504.forwardmove + v1513.y * v1504.sidemove);
            v1514:normalize();
            local v1515 = l_m_vecOrigin_4 + v1514 * 8;
            local v1516 = utils.trace_hull(l_m_vecOrigin_4, v1515, l_m_vecMins_2, l_m_vecMaxs_2, entity.get_players(), 33636363, 0);
            if v1516.entity == nil or not v1516:did_hit_world() or bit.band(v1516.contents, 536870912) ~= 0 then
                return;
            else
                local v1517 = l_m_vecVelocity_3:normalized();
                if v1517:dot(v1514) <= 0 then
                    return;
                else
                    local l_normal_0 = v1516.plane.normal;
                    if math.abs(l_normal_0.z) >= 0.1 then
                        return;
                    else
                        if v1517:dot(l_normal_0) < -0.85 then
                            v1517 = v1514;
                        end;
                        local v1519 = l_normal_0:vectors();
                        if v1519:dot(v1517) < 0 then
                            v1519 = v1519 * -1;
                        end;
                        v1504.move_yaw = math.deg(math.atan2(v1519.y, v1519.x));
                        v1504.forwardmove = 450;
                        v1504.sidemove = 0;
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v491 = nil;
do
    local l_l_angles_1_8 = l_angles_1;
    v493 = function(v1521)
        -- upvalues: l_l_angles_1_8 (ref)
        events.createmove(l_l_angles_1_8, v1521:get());
    end;
    v488.enabled:set_callback(v493, true);
end;
v488 = nil;
l_angles_1 = v44.other.misc.fast_ladder;
v491 = 9;
v493 = function(v1522)
    local l_x_1 = render.camera_angles().x;
    if v1522.forwardmove > 0 and l_x_1 < 45 then
        v1522.view_angles.x = 89;
        v1522.in_moveright = 1;
        v1522.in_moveleft = 0;
        v1522.in_forward = 0;
        v1522.in_back = 1;
        if v1522.sidemove == 0 then
            v1522.view_angles.y = v1522.view_angles.y + 90;
        end;
        if v1522.sidemove < 0 then
            v1522.view_angles.y = v1522.view_angles.y + 150;
        end;
        if v1522.sidemove > 0 then
            v1522.view_angles.y = v1522.view_angles.y + 30;
        end;
    end;
    if v1522.forwardmove < 0 then
        v1522.view_angles.x = 89;
        v1522.in_moveleft = 1;
        v1522.in_moveright = 0;
        v1522.in_forward = 1;
        v1522.in_back = 0;
        if v1522.sidemove == 0 then
            v1522.view_angles.y = v1522.view_angles.y + 90;
        end;
        if v1522.sidemove > 0 then
            v1522.view_angles.y = v1522.view_angles.y + 150;
        end;
        if v1522.sidemove < 0 then
            v1522.view_angles.y = v1522.view_angles.y + 30;
        end;
    end;
end;
do
    local l_v491_11, l_v493_12, l_v494_13 = v491, v493, v494;
    l_v494_13 = function(v1527)
        -- upvalues: l_v491_11 (ref), l_v493_12 (ref)
        local v1528 = entity.get_local_player();
        if v1528 == nil then
            return;
        elseif v1528.m_MoveType ~= l_v491_11 then
            return;
        else
            l_v493_12(v1527);
            return;
        end;
    end;
    v743 = nil;
    v744 = function(v1529)
        -- upvalues: l_v494_13 (ref)
        events.createmove(l_v494_13, v1529:get());
    end;
    l_angles_1.enabled:set_callback(v744, true);
end;
l_angles_1 = nil;
v491 = v44.other.misc.edge_stop;
v493 = function(v1530)
    local v1531 = entity.get_local_player();
    if v1531 == nil then
        return;
    else
        local v1532 = v1531:simulate_movement();
        v1532:think(5);
        if v1532.velocity.z < 0 then
            v1530.block_movement = 2;
        end;
        return;
    end;
end;
v494 = nil;
do
    local l_v493_13 = v493;
    v743 = function(v1534)
        -- upvalues: l_v493_13 (ref)
        events.createmove(l_v493_13, v1534:get());
    end;
    v491.enabled:set_callback(v743, true);
end;
v491 = nil;
v493 = v44.other.misc.no_fall_damage;
v494 = false;
v743 = math.pi * 2;
v744 = v743 / 8;
do
    local l_v494_14, l_v743_10, l_v744_10, l_v745_10, l_v746_7 = v494, v743, v744, v745, v746;
    l_v745_10 = function(v1540, v1541)
        -- upvalues: l_v743_10 (ref), l_v744_10 (ref)
        local v1542 = v1540:get_origin();
        for v1543 = 0, l_v743_10, l_v744_10 do
            local v1544 = math.sin(v1543);
            local v1545 = math.cos(v1543);
            local v1546 = v1542.x + v1545 * 10;
            local v1547 = v1542.y + v1544 * 10;
            local v1548 = vector(v1546, v1547, v1542.z);
            local v1549 = v1548:clone();
            v1549.z = v1549.z - v1541;
            if utils.trace_line(v1548, v1549, v1540).fraction ~= 1 then
                return true;
            end;
        end;
        return false;
    end;
    l_v746_7 = function(v1550)
        -- upvalues: l_v494_14 (ref), l_v745_10 (ref)
        local v1551 = entity.get_local_player();
        if v1551 == nil then
            return;
        elseif v1551.m_vecVelocity.z >= -500 then
            l_v494_14 = false;
            return;
        else
            if l_v745_10(v1551, 15) then
                l_v494_14 = false;
            elseif l_v745_10(v1551, 75) then
                l_v494_14 = true;
            end;
            v1550.in_duck = l_v494_14;
            return;
        end;
    end;
    v747 = nil;
    v748 = function(v1552)
        -- upvalues: l_v746_7 (ref)
        events.createmove(l_v746_7, v1552:get());
    end;
    v493.enabled:set_callback(v748, true);
end;
v493 = nil;
v494 = v44.other.misc.unlock_fd_speed;
v743 = 5;
do
    local l_v743_11, l_v744_11 = v743, v744;
    l_v744_11 = function(v1555)
        -- upvalues: v43 (ref), l_v743_11 (ref)
        if not v43.antiaim.misc.fake_duck:get() then
            return;
        elseif entity.get_local_player() == nil then
            return;
        else
            local l_forwardmove_0 = v1555.forwardmove;
            local l_sidemove_0 = v1555.sidemove;
            if math.abs(l_forwardmove_0) > l_v743_11 or math.abs(l_sidemove_0) > l_v743_11 then
                local v1558 = 450 / (l_forwardmove_0 * l_forwardmove_0 + l_sidemove_0 * l_sidemove_0) ^ 0.5;
                v1555.forwardmove = l_forwardmove_0 * v1558;
                v1555.sidemove = l_sidemove_0 * v1558;
            end;
            return;
        end;
    end;
    v745 = nil;
    v746 = function(v1559)
        -- upvalues: l_v744_11 (ref)
        events.createmove(l_v744_11, v1559:get());
    end;
    v494.enabled:set_callback(v746, true);
end;
v494 = nil;
v743 = v44.other.misc.super_toss;
v744 = 0.3;
v745 = function(v1560, v1561, v1562)
    return v1560 + v1562 * (v1561 - v1560);
end;
do
    local l_v744_12, l_v745_11, l_v746_8, l_v747_7, l_v748_9 = v744, v745, v746, v747, v748;
    l_v746_8 = function(v1568, v1569, v1570, v1571)
        -- upvalues: l_v745_11 (ref), l_v744_12 (ref)
        v1568.x = v1568.x - 10 + math.abs(v1568.x) / 9;
        local v1572 = vector():angles(v1568);
        local v1573 = v1571 * 1.25;
        local v1574 = math.clamp(v1569 * 0.9, 15, 750);
        local v1575 = math.clamp(v1570, 0, 1);
        v1574 = v1574 * l_v745_11(l_v744_12, 1, v1575);
        local l_v1572_0 = v1572;
        for _ = 1, 8 do
            l_v1572_0 = (v1572 * (l_v1572_0 * v1574 + v1573):length() - v1573) / v1574;
            l_v1572_0:normalize();
        end;
        local v1578 = l_v1572_0.angles(l_v1572_0);
        if v1578.x > -10 then
            v1578.x = 0.9 * v1578.x + 9;
        else
            v1578.x = 1.125 * v1578.x + 11.25;
        end;
        return v1578;
    end;
    l_v747_7 = function(v1579)
        -- upvalues: l_v746_8 (ref)
        local v1580 = entity.get_local_player();
        if v1580 == nil then
            return;
        else
            local v1581 = v1580:get_player_weapon();
            if v1581 == nil then
                return;
            else
                local v1582 = v1581:get_weapon_info();
                if v1582 == nil then
                    return;
                else
                    v1579.angles = l_v746_8(v1579.angles, v1582.throw_velocity, v1581.m_flThrowStrength, v1579.velocity);
                    return;
                end;
            end;
        end;
    end;
    l_v748_9 = function(v1583)
        -- upvalues: l_v746_8 (ref)
        if v1583.jitter_move ~= true then
            return;
        else
            local v1584 = entity.get_local_player();
            if v1584 == nil then
                return;
            else
                local v1585 = v1584:get_player_weapon();
                if v1585 == nil then
                    return;
                else
                    local v1586 = v1585:get_weapon_info();
                    if v1586 == nil or v1586.weapon_type ~= 9 then
                        return;
                    elseif v1585.m_fThrowTime < globals.curtime - to_time(globals.clock_offset) then
                        return;
                    else
                        v1583.in_speed = true;
                        local v1587 = v1584:simulate_movement();
                        v1587:think();
                        v1583.view_angles = l_v746_8(v1583.view_angles, v1586.throw_velocity, v1585.m_flThrowStrength, v1587.velocity);
                        return;
                    end;
                end;
            end;
        end;
    end;
    v749 = nil;
    v750 = function(v1588)
        -- upvalues: l_v748_9 (ref), l_v747_7 (ref)
        local v1589 = v1588:get();
        events.createmove(l_v748_9, v1589);
        events.grenade_override_view(l_v747_7, v1589);
    end;
    v743.enabled:set_callback(v750, true);
end;
v743 = nil;
v744 = v44.other.misc.trashtalk;
v745 = {
    [1] = "\208\157\208\184 \225\180\143\225\180\155\208\180\225\180\128\202\141 \208\189\208\184 \225\180\139\225\180\143\202\141\209\131... \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167\226\153\155", 
    [2] = "\209\143 \208\189\225\180\135 \208\188\208\190\208\179\202\143 \208\177\225\180\135\208\183 \209\130\225\180\135\208\177\209\143 \208\182\208\184\209\130\209\140... \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167\226\153\155", 
    [3] = "\225\180\128\208\177\208\190\208\189\225\180\135\208\189\225\180\155 \202\153\225\180\169\225\180\135\202\141\225\180\135\208\189\208\189\208\190 \208\189\225\180\135\208\180\208\190\225\180\132\225\180\155\209\131\225\180\168\225\180\135\208\189. \225\180\168\208\190\225\180\139\225\180\128!", 
    [4] = "\240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167 \207\129\209\143g\207\131\208\188 \209\129 \207\132\207\131\206\180\207\131\197\175 g\207\131 \208\191\207\131\209\129\208\187\208\181g\208\189\208\181\208\179\207\131 \208\178\208\183g\207\131\209\133\206\177\226\128\166\208\154\207\131\208\179g\206\177 \207\132\208\181\206\180\208\181 \207\129\206\177g\207\131\209\129\207\132\208\189\207\131 u \208\186\207\131\208\179g\206\177 \207\132\208\181\206\180\208\181 \208\191\208\187\207\131\209\133\207\131\226\128\166\226\153\155", 
    [5] = "\208\146 \208\171 \208\149 \208\145 \208\144 \208\157 \226\153\155", 
    [6] = "\226\157\157\240\157\159\143\226\157\158", 
    [7] = "\226\152\133\229\189\161( 1 )\229\189\161\226\152\133", 
    [8] = "\228\184\128\226\149\144\227\131\135\239\184\187 1 \239\184\187\227\131\135\226\149\144\228\184\128", 
    [9] = "\240\157\159\153", 
    [10] = "\194\184.\194\183\226\156\169\194\183.\194\184\194\184.\194\183\194\175\226\141\163\226\156\169 \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167 \226\156\169\226\141\163\194\175\194\183.\194\184\194\184.\194\183\226\156\169\194\183.\194\184", 
    [11] = "`\226\156\181\226\128\162.\194\184,\226\156\181\194\176\226\156\181.\239\189\161.\226\156\176 \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167 \226\156\176.\239\189\161.\226\156\181\194\176\226\156\181,\194\184.\226\128\162\226\156\181\194\180", 
    [12] = "\203\156\226\128\157*\194\176\226\128\162.\203\156\226\128\157*\194\176\226\128\162 \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167 \226\128\162\194\176*\226\128\157\203\156.\226\128\162\194\176*\226\128\157\203\156", 
    [13] = "\208\157\208\181\208\180\208\190\209\128\208\176\208\183\208\178\208\184\209\130\209\139\208\185 \209\129\209\130\209\128\208\184\208\188\208\181\209\128 \209\129 \209\135\208\184\209\130\208\176\208\188\208\184 \208\178 CS \208\190\208\191\208\190\208\183\208\190\209\128\208\184\208\187\209\129\209\143 \208\189\208\176 1,230 \208\183\209\128\208\184\209\130\208\181\208\187\208\181\208\185 \208\162\208\176\208\186\208\190\208\181 \208\189\208\181 \208\180\208\190\208\187\208\182\208\189\208\190 \208\177\209\139\208\187\208\190 \208\191\208\190\208\191\208\176\209\129\209\130\209\140 \208\178 \208\184\208\189\208\181\209\130.", 
    [14] = "\208\173\209\130\208\190 \208\178\208\190\208\185\208\180\208\181\209\130 \208\178 \208\184\209\129\209\130\208\190\209\128\208\184\209\142! \208\159\208\190\208\186\208\176\208\183\208\176\208\187\208\184 \208\180\208\176\208\182\208\181 \208\189\208\176 \208\191\208\181\209\128\208\178\208\190\208\188 \208\186\208\176\208\189\208\176\208\187\208\181 rebellion vs all \226\153\155", 
    [15] = "\208\161\208\157\208\147 \208\191\208\176\209\128\208\189\208\184 \208\189\208\176 *\208\157\208\190\208\178\209\139\208\185 \208\147\208\190\208\180* \208\183\208\176\209\128\209\131\208\177\208\184\208\187\208\184 \208\186\208\187\208\190\208\191\208\190\208\178 \208\189\208\176 GALAXYTAPS$ \"st1vaha,vitma,rayzen,onej,kislota\" OWNED.", 
    [16] = "\208\175 \208\190\208\180\208\184\208\189, \208\186\208\176\208\186 \208\178\209\129\209\143 \209\130\208\184\208\188\208\176. VS \"vitma,st1vaha,kislota,onej,rayzen,fifty,martiny,fipp,nolove,walper\"", 
    [17] = "\226\128\167\204\141\204\138\203\153\203\154\203\153\225\181\149\224\184\138\224\184\181\224\184\167\224\184\180\224\184\149\224\184\130\224\184\173\224\184\135\224\184\137\224\184\177\224\184\153\224\184\132\224\184\183\224\184\173\224\185\132\224\184\174\224\184\129\224\184\184\227\128\128\226\130\133\226\130\135\226\130\133\227\128\128\240\157\144\171 \240\157\144\158 \240\157\144\155 \240\157\144\158 \240\157\144\165 \240\157\144\165 \240\157\144\162 \240\157\144\168 \240\157\144\167\239\188\142\239\188\142\227\129\130\227\129\170\227\129\159\227\129\175\232\170\176\234\148\171\239\188\154\239\188\138\239\188\139\239\190\159\227\128\128\227\130\128\231\171\185\227\130\182", 
    [18] = "\208\186\209\128\208\190\208\178\209\140 \208\189\208\176 \208\177\208\181\208\187\208\190\208\185 \208\178\209\131\208\176\208\187\208\184", 
    [19] = "\226\152\134*: .\239\189\161. o(\226\137\167\226\150\189\226\137\166)o .\239\189\161.:*\226\152\134", 
    [20] = "(\239\189\143 \226\128\181-\226\128\178)\227\131\142\226\128\157(\227\131\142\239\185\143<\227\128\130)", 
    [21] = "\226\152\160\239\184\143 \240\157\144\138\240\157\144\128\240\157\144\145\240\157\144\147\240\157\144\128\240\157\144\147\240\157\144\128\240\157\144\136 \240\157\144\129\240\157\144\142\240\157\144\147 \226\152\160\239\184\143", 
    [22] = "\208\149\208\145\208\149\208\156 \208\145\208\152\208\162\208\171 \208\149\208\145\208\149\208\156 \208\168\208\144\208\155\208\144\208\146 \208\175 \208\158\208\145\208\172\208\149\208\145\208\144\208\157\208\171\208\153 \208\159\208\152\208\151\208\148\208\149\208\149\208\149\208\149\208\166", 
    [23] = "\208\159\208\160\208\158\208\164\208\152\208\162\208\152\208\154 \208\145\208\160\208\144\208\162 \208\152\208\148\208\152 \208\154\208\144 \208\161\208\174\208\148\208\144", 
    [24] = "\240\157\153\145\240\157\153\128\240\157\153\137\240\157\153\138\240\157\153\136\240\157\153\128\240\157\153\137\240\157\152\188\240\157\153\135\240\157\153\137\240\157\153\138\226\153\155", 
    [25] = "\240\157\144\128\240\157\144\145\240\157\144\132 \240\157\144\152\240\157\144\142\240\157\144\148 \240\157\144\134\240\157\144\148\240\157\144\152\240\157\144\146 \240\157\144\146\240\157\144\128\240\157\144\150 \240\157\144\147\240\157\144\135\240\157\144\136\240\157\144\146 \240\157\144\141\240\157\144\136\240\157\144\134\240\157\144\134\240\157\144\128? \239\189\146\239\189\133\239\189\130\239\189\133\239\189\140\239\189\140\239\189\137\239\189\143\239\189\142- \225\180\155\202\156\201\170s \225\180\143\225\180\152\225\180\152s \225\180\132\225\180\128\201\180\225\180\155 \202\156\225\180\135\225\180\128\225\180\133s\202\156\225\180\143\225\180\155 \225\180\141\225\180\135 (\226\151\163_\226\151\162)", 
    [26] = "\240\157\144\157\240\157\144\154\240\157\144\178\240\157\144\173\240\157\144\158 \240\157\144\166\240\157\144\167\240\157\144\158 \240\157\159\143\240\157\159\142 \240\157\144\172\240\157\144\158\240\157\144\164\240\157\144\174\240\157\144\167\240\157\144\157 >>> \209\143 \208\178\209\140\208\181\208\177\209\131 2 \208\177\208\176\209\128\208\176", 
    [27] = "\240\157\152\174\240\157\152\176\240\157\152\173\240\157\152\176\240\157\152\165\240\157\152\176\240\157\152\186 \240\157\152\165\240\157\152\187\240\157\152\169\240\157\152\176\240\157\152\175 \240\157\152\168\240\157\152\162\240\157\152\179\240\157\152\170\240\157\152\172 \226\150\183 \240\157\144\145\240\157\144\132\240\157\144\129\240\157\144\132\240\157\144\139\240\157\144\139\240\157\144\136\240\157\144\142\240\157\144\141", 
    [28] = "\239\188\178\239\188\165\239\188\162\239\188\165\239\188\172\239\188\172\239\188\169\239\188\175\239\188\174 \239\188\183\239\188\169\239\188\172\239\188\172 \239\188\162\239\188\165 \239\188\161\239\188\172\239\188\183\239\188\161\239\188\185\239\188\179 \239\188\161\239\188\168\239\188\165\239\188\161\239\188\164", 
    [29] = "s\202\156\201\170\225\180\135s\225\180\155\202\143 \225\180\143\201\180 \225\180\141\202\143 \202\156\225\180\135\225\180\128\225\180\133 \234\156\176\201\170\201\180\201\180\225\180\128 \225\180\152\225\180\156\202\159\202\159 \225\180\156\225\180\152 \201\180 \225\180\156 \201\162\225\180\143\201\180\201\180\225\180\128 \225\180\133\201\170\225\180\135", 
    [30] = "\240\157\150\152\240\157\150\154\240\157\150\144\240\157\150\134 \240\157\150\152\240\157\150\148 \240\157\150\146\240\157\150\147\240\157\150\148\240\157\150\158 6\240\157\150\142\240\157\150\157\240\157\150\134 \240\157\150\152\240\157\150\154\240\157\150\144\240\157\150\134 \240\157\150\159\240\157\150\148\240\157\150\155\240\157\150\154 \240\157\150\138\240\157\150\140\240\157\150\148 \240\157\150\152\240\157\150\145\240\157\150\142\240\157\150\146\240\157\150\138", 
    [31] = "\239\188\164\239\188\178\239\188\169\239\188\176 \239\188\179\239\188\176\239\188\172\239\188\161\239\188\179\239\188\168 \239\188\175\239\188\174 \239\188\173\239\188\185 \239\188\174\239\188\165\239\188\163\239\188\171 >>> \239\188\178\239\188\165\239\188\162\239\188\165\239\188\172\239\188\172\239\188\169\239\188\175\239\188\174", 
    [32] = "\226\150\132\239\184\187\227\131\135\240\157\144\154\240\157\144\155\240\157\144\172\240\157\144\168\240\157\144\165\240\157\144\174\240\157\144\173\240\157\144\158 \240\157\144\156\240\157\144\162\240\157\144\167\240\157\144\158\240\157\144\166\240\157\144\154\226\149\144\226\149\144\226\148\129\228\184\128", 
    [33] = "\226\157\157\240\157\144\143\240\157\144\142\240\157\144\150\240\157\144\145\240\157\144\142\240\157\144\147 \240\157\144\130\240\157\144\128\240\157\144\141\240\157\144\147 \240\157\144\143\240\157\144\145\240\157\144\132\240\157\144\131\240\157\144\136\240\157\144\130\240\157\144\147 \240\157\144\147\240\157\144\135\240\157\144\136\240\157\144\146 \240\157\144\133\240\157\144\147. \240\157\144\145\240\157\144\132\240\157\144\129\240\157\144\132\240\157\144\139\240\157\144\139\240\157\144\136\240\157\144\142\240\157\144\141\226\157\158", 
    [34] = "\239\188\175\239\188\162\239\188\178\239\188\161\239\188\162\239\188\175\239\188\180\239\188\171\239\188\161 \239\188\162\239\188\185 \239\188\179\239\188\169\239\188\174 \239\188\179\239\188\168\239\188\172\239\188\181\239\188\168\239\188\169", 
    [35] = "\226\139\134.\203\154\226\156\174\239\188\181\239\188\173\239\188\178\239\188\169 \239\188\174\239\188\161\239\188\168\239\188\181\239\188\169\226\156\174\203\154.\226\139\134", 
    [36] = "\226\171\152\226\171\152\226\171\152\226\171\152\226\171\152\226\171\152\208\155\208\152\208\161\208\162\208\144\208\153 \208\155\208\152\208\161\208\162\208\144\208\153", 
    [37] = "\226\149\176\226\148\136\226\158\164V_\208\171_E_B_A_N [rebellion / gs]", 
    [38] = "\224\180\166\224\181\141\224\180\166\224\180\191(\203\181 \226\128\162\204\128 \225\180\151 - \203\181 ) \226\156\167", 
    [39] = "\226\152\163 ! ATTENTION ! REBELLION DETECTED \226\152\163", 
    [40] = " \239\183\189\224\163\170\240\150\164\144\224\163\170\240\150\164\144\224\163\170\240\150\164\144", 
    [41] = "\226\155\167\194\176\227\128\130 \226\139\134\224\188\186\239\189\146\239\189\133\239\189\130\239\189\133\239\189\140\239\189\140\239\189\137\239\189\143\239\189\142\224\188\187\226\139\134\227\128\130 \194\176\226\155\167", 
    [42] = "@evildealers", 
    [43] = "\208\154\208\158\208\157\208\161\208\154\208\152\208\153 \208\167\208\155\208\149\208\157 \208\159\208\158 \208\148\208\149\208\148\208\158\208\146\208\161\208\154\208\158\208\156\208\163 \208\156\208\149\208\162\208\158\208\148\208\163 - \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167\226\153\155", 
    [44] = "\240\157\144\175\240\157\144\158\240\157\144\179\240\157\144\162 \240\157\144\166\240\157\144\158\240\157\144\167\240\157\144\178\240\157\144\154, \240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\178\240\157\144\178 \240\157\144\169\240\157\144\178\240\157\144\154\240\157\144\173\240\157\144\162\240\157\144\172\240\157\144\168\240\157\144\173\240\157\144\178\240\157\144\178 \227\137\166\226\132\179\226\132\176\226\132\155\226\132\130\226\132\176\226\133\133\226\132\176\213\143\227\137\166", 
    [45] = "\239\189\146\239\189\133\239\189\130\239\189\133\239\189\140\239\189\140\239\189\137\239\189\143\239\189\142 \226\149\173\226\136\169\226\149\174( \226\128\162\204\128_\226\128\162\204\129 )\226\149\173\226\136\169\226\149\174", 
    [46] = "\208\178\209\129\208\181 \209\129\209\131\208\186\208\184 \208\178 \208\187\208\190\208\189\208\180\208\190\208\189\208\181 \208\188\208\181\209\128\209\130\208\178\209\139\208\181 \226\155\167", 
    [47] = "\226\139\134\226\153\177\239\189\146\239\189\133\239\189\130\239\189\133\239\189\140\239\189\140\239\189\137\239\189\143\239\189\142\226\153\177\226\139\134", 
    [48] = "\203\154\226\130\138\226\128\167\234\146\176\225\131\144 \202\128\225\180\135\202\153\225\180\135\202\159\202\159\201\170\225\180\143\201\180 \225\180\141\225\180\143\225\180\133\225\180\135 \225\180\135\201\180\225\180\128\202\153\202\159\225\180\135\225\180\133 \224\187\146\234\146\177 \226\128\167\226\130\138\203\154", 
    [49] = "\209\143 \208\178 \209\132\208\176\208\189\209\130\209\131 \208\186\208\184\208\189\209\131\208\187 \209\132\208\176\208\185\208\183\208\181\209\128 Z_Z", 
    [50] = "@evildealers \226\150\132\239\184\187\227\131\134\226\149\144\226\149\144\226\148\129\228\184\128\239\188\165\239\188\184\239\188\163\239\188\172\239\188\181\239\188\179\239\188\169\239\188\182\239\188\165 \239\188\179\239\188\168\239\188\169\239\188\180", 
    [51] = "\239\188\176\239\188\175\239\188\183\239\188\165\239\188\178\239\188\165\239\188\164  \239\188\162\239\188\185  @evildealers (\240\147\129\185 \240\147\129\185)", 
    [52] = "\240\157\151\150\240\157\151\152\240\157\151\162 \240\157\151\153\240\157\151\148\240\157\151\165\240\157\151\167\240\157\151\152\240\157\151\161\240\157\151\150\240\157\151\156\195\147\240\157\151\161", 
    [53] = "\226\139\134\203\154\224\191\148 Sample Text \240\157\156\151\240\157\156\154\203\154\226\139\134", 
    [54] = "\209\129\208\186\208\176\209\135\208\176\209\130\209\140 vegas pro 20 torrent", 
    [55] = "\208\175 \208\146\209\139\208\182\208\184\208\187 \208\146 5 \208\161\208\176\208\188\209\139\209\133 \208\158\208\191\208\176\209\129\208\189\209\139\209\133 \208\156\208\181\209\129\209\130\208\176\209\133 \208\157\208\176 \208\151\208\181\208\188\208\187\208\181 ft. rebellion", 
    [56] = "\208\146 \209\141\209\130\208\190\208\188 \208\178\208\184\208\180\208\181\208\190 \208\188\209\139 \209\128\208\176\208\183\208\177\208\184\209\128\208\176\208\181\208\188 \209\136\208\190\208\186\208\184\209\128\209\131\209\142\209\137\208\184\208\181 \209\129\208\187\209\131\209\135\208\176\208\184 \209\141\208\186\208\191\208\184\208\180\208\190\209\128\209\129\208\186\208\190\208\179\208\190 \208\191\209\128\208\190\208\184\208\183\208\178\208\190\208\187\208\176 \208\184 \209\128\208\176\209\129\208\184\208\183\208\188\208\176 \208\178 CS:GO", 
    [57] = "\209\130\208\190\209\128\209\128\208\181\208\189\209\130 \208\184\208\179\209\128\209\131\209\133\208\176", 
    [58] = "@emberanonymous", 
    [59] = "SHADOW SWAG FREESTYLE + tuborosho + rebellion", 
    [60] = "REBELLION RAGE SECURITY", 
    [61] = "SAFRONOV 40 000 - REBELLION DOMINATION", 
    [62] = "\226\157\175\226\157\175\226\157\175\226\157\175 \208\161\208\158\208\151\208\148\208\144\208\155\208\152 \208\155\208\163\208\167\208\168\208\152\208\149 \208\154\208\155\208\158\208\157\208\171 \208\154\208\161 \208\147\208\158 \208\152\208\151-\208\151\208\144 \208\154\208\158\208\162\208\158\208\160\208\171\208\165 CS:GO \208\154\208\158\208\157\208\149\208\166! - \208\186\209\129\208\179\208\190 \208\189\208\176 \208\176\208\189\208\180\209\128\208\190\208\184\208\180, iphone \208\184 \208\180\208\187\209\143 \209\129\208\187\208\176\208\177\209\139\209\133 \208\191\208\186", 
    [63] = "REKT BY KIDUAHOOK", 
    [64] = "\194\175\\_(\227\131\132)_/\194\175 \226\156\181 \240\157\144\171\240\157\144\158\240\157\144\155\240\157\144\158\240\157\144\165\240\157\144\165\240\157\144\162\240\157\144\168\240\157\144\167 \226\156\181", 
    [65] = "\226\153\165 \240\157\144\128\240\157\144\145\240\157\144\139\240\157\144\132\240\157\144\138\240\157\144\136\240\157\144\141 \240\157\159\146\240\157\159\142 \240\157\159\142\240\157\159\142\240\157\159\142 \226\153\165", 
    [66] = "\226\150\132\239\184\187\227\131\135\199\159\202\128\202\159\201\155\211\132\201\168\213\188 40 000\226\149\144\226\149\144\226\148\129\228\184\128", 
    [67] = "\240\157\144\143\240\157\144\128\240\157\144\145\240\157\144\139\240\157\144\128\240\157\144\140\240\157\144\136\240\157\144\132\240\157\144\141\240\157\144\147 \240\157\144\141\240\157\144\136\240\157\144\134\240\157\144\135\240\157\144\147 \240\157\144\129\240\157\144\139\240\157\144\148\240\157\144\132 + \240\157\144\145\240\157\144\136\240\157\144\130\240\157\144\135 \240\157\144\134\240\157\144\145\240\157\144\132\240\157\144\132\240\157\144\141 \240\157\144\147\240\157\144\132\240\157\144\128", 
    [68] = "\227\128\140text here\227\128\141"
};
do
    local l_v744_13, l_v745_12, l_v746_9 = v744, v745, v746;
    l_v746_9 = function(v1593)
        -- upvalues: l_v744_13 (ref), l_v745_12 (ref)
        local v1594 = entity.get_local_player();
        local v1595 = entity.get(v1593.userid, true);
        local v1596 = entity.get(v1593.attacker, true);
        if v1594 == v1595 or v1594 ~= v1596 then
            return;
        else
            local v1597 = l_v744_13.delay:get() * 0.1;
            local v1598 = l_v745_12[utils.random_int(1, #l_v745_12)];
            utils.execute_after(v1597, function()
                -- upvalues: v1598 (ref)
                utils.console_exec("say " .. v1598);
            end);
            return;
        end;
    end;
    v747 = nil;
    v748 = function(v1599)
        -- upvalues: l_v746_9 (ref)
        events.player_death(l_v746_9, v1599:get());
    end;
    l_v744_13.enabled:set_callback(v748, true);
end;
v744 = nil;
v745 = v44.other.misc.clantag;
v746 = {
    [1] = "         ", 
    [2] = "r        ", 
    [3] = "re       ", 
    [4] = "reb      ", 
    [5] = "rebe     ", 
    [6] = "rebel    ", 
    [7] = "rebell   ", 
    [8] = "rebelli  ", 
    [9] = "rebellio ", 
    [10] = "rebellion", 
    [11] = "rebellion", 
    [12] = "rebellion", 
    [13] = "rebellion", 
    [14] = "rebellion", 
    [15] = "rebellion", 
    [16] = " ebellion", 
    [17] = "  bellion", 
    [18] = "   ellion", 
    [19] = "    llion", 
    [20] = "     lion", 
    [21] = "      ion", 
    [22] = "       on", 
    [23] = "        n", 
    [24] = "         "
};
v747 = cvar.cl_clanid;
v748 = nil;
do
    local l_v746_10, l_v747_8, l_v748_10, l_v749_8, l_v750_7, l_v751_9 = v746, v747, v748, v749, v750, v751;
    l_v749_8 = function(v1606)
        -- upvalues: l_v748_10 (ref)
        if v1606 ~= l_v748_10 then
            common.set_clan_tag(v1606 or "");
            l_v748_10 = v1606;
        end;
    end;
    l_v750_7 = function(_)
        -- upvalues: l_v746_10 (ref), l_v749_8 (ref)
        local v1608 = utils.net_channel();
        if v1608 == nil then
            return;
        else
            local l_tickcount_0 = globals.tickcount;
            local v1610 = to_ticks(v1608.latency[0]);
            local v1611 = math.floor((l_tickcount_0 + v1610) * 0.0625) % #l_v746_10 + 1;
            l_v749_8(l_v746_10[v1611]);
            return;
        end;
    end;
    l_v751_9 = function()
        -- upvalues: l_v749_8 (ref), l_v747_8 (ref)
        l_v749_8("");
        l_v747_8:call(l_v747_8:string());
    end;
    v752 = nil;
    v753 = function(v1612)
        -- upvalues: l_v749_8 (ref), l_v747_8 (ref), l_v751_9 (ref), l_v750_7 (ref)
        local v1613 = v1612:get();
        if not v1613 then
            l_v749_8("");
            l_v747_8:call(l_v747_8:string());
        end;
        events.shutdown(l_v751_9, v1613);
        events.net_update_end(l_v750_7, v1613);
    end;
    v745.enabled:set_callback(v753, true);
end;
v745 = nil;
v746 = v44.other.misc.shared_icon;
v747 = {
    [1] = "tasty", 
    [2] = "cat", 
    [3] = "mclovin", 
    [4] = "respect", 
    [5] = "jason", 
    [6] = "blue", 
    [7] = "red", 
    [8] = "green", 
    [9] = "purple", 
    [10] = "orange", 
    [11] = "pink", 
    [12] = "gray"
};
v746.icon:update(v747);
v748 = panorama.loadstring("                let _get_xuid = function(entity_index) {\n                    let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entity_index);\n                    return xuid;\n                }\n\n                let _set_icon = function(entity_index, icon) {\n                    let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entity_index);\n                    let context_panel = $.GetContextPanel();\n                    let ctx = context_panel.FindChildTraverse(\"ScoreboardContainer\").FindChildTraverse(\"Scoreboard\") || context_panel.FindChildTraverse(\"id-eom-scoreboard-container\").FindChildTraverse(\"Scoreboard\")\n                    if (ctx == null)\n                        return;\n\n                    ctx.FindChildrenWithClassTraverse(\"sb-row\").forEach(function(e) {\n                        if (e.m_xuid != xuid)\n                            return false;\n\n                        e.Children().forEach(function(child) {\n                            let attribute = child.GetAttributeString(\"data-stat\", \"\");\n                            if (attribute != \"rank\")\n                                return false;\n\n                            var image = child.FindChildTraverse(\"image\");\n                            if (!image || !image.IsValid())\n                                return false;\n\n                            image.SetImage(icon === null ? \"\" : icon)\n                            return true;\n                        })\n                    })\n\n                    return xuid;\n                }\n\n                return {\n                    get_xuid: _get_xuid,\n                    set_icon: _set_icon\n                }\n            ", "CSGOHud")();
v749 = {};
v750 = {};
do
    local l_v746_11, l_v747_9, l_v748_11, l_v749_9, l_v750_8, l_v751_10, l_v753_6, l_v754_7, l_v757_4 = v746, v747, v748, v749, v750, v751, v753, v754, v757;
    l_v751_10 = function()
        -- upvalues: l_v748_11 (ref)
        entity.get_players(false, true, function(v1623)
            -- upvalues: l_v748_11 (ref)
            l_v748_11.set_icon(v1623:get_index());
        end);
    end;
    v752 = function(v1624)
        -- upvalues: l_v749_9 (ref), l_v746_11 (ref)
        l_v749_9 = {};
        if not l_v746_11.enabled:get() then
            return;
        else
            l_v749_9 = v1624;
            return;
        end;
    end;
    l_v753_6 = function()
        -- upvalues: l_v748_11 (ref), l_v749_9 (ref), l_v750_8 (ref)
        entity.get_players(false, true, function(v1625)
            -- upvalues: l_v748_11 (ref), l_v749_9 (ref), l_v750_8 (ref)
            local v1626 = v1625:get_index();
            if v1626 ~= nil then
                local v1627 = l_v748_11.get_xuid(v1626);
                local v1628 = l_v749_9[v1627];
                if v1628 ~= nil then
                    if v1628.enabled then
                        l_v748_11.set_icon(v1626, string.format("https://github.com/shelzyj/rebellion/blob/main/icons/%s.png?raw=true", v1628.icon));
                        l_v750_8[v1627] = false;
                    elseif not l_v750_8[v1627] then
                        l_v748_11.set_icon(v1626);
                        l_v750_8[v1627] = true;
                    end;
                end;
            end;
        end);
    end;
    l_v754_7 = function()
        -- upvalues: l_play_0 (ref), l_v746_11 (ref), l_v747_9 (ref)
        l_play_0:interact("get_users_xuid", {
            enabled = l_v746_11.enabled:get(), 
            xuid = panorama.MyPersonaAPI.GetXuid(), 
            icon = l_v747_9[l_v746_11.icon:get()]
        });
    end;
    v755 = function()
        -- upvalues: l_v754_7 (ref)
        l_v754_7();
    end;
    v756 = function()
        -- upvalues: l_v751_10 (ref)
        l_v751_10();
    end;
    l_v757_4 = function()
        -- upvalues: l_v751_10 (ref)
        l_v751_10();
    end;
    v758 = nil;
    v759 = function(_)
        -- upvalues: l_v754_7 (ref)
        l_v754_7();
    end;
    v760 = function(v1630)
        -- upvalues: l_v751_10 (ref), l_v754_7 (ref), l_v757_4 (ref), l_v753_6 (ref)
        local v1631 = v1630:get();
        if not v1631 then
            l_v751_10();
        end;
        l_v754_7();
        events.shutdown(l_v757_4, v1631);
        events.net_update_end(l_v753_6, v1631);
    end;
    l_play_0:set_event_callback("disconnect", v756);
    l_play_0:set_event_callback("connect", v755);
    l_play_0:subscribe("get_users_xuid", v752);
    l_v746_11.icon:set_callback(v759, true);
    l_v746_11.enabled:set_callback(v760, true);
end;
v483 = nil;
ui.sidebar(v9.name, "star-christmas");