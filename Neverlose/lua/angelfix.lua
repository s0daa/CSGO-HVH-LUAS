local l_base64_0 = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local _ = require("neverlose/inspect");
local v3 = "\226\128\138";
local function v7(v4, v5)
    for v6 = 1, #v4 do
        if v4[v6] == v5 then
            return v6;
        end;
    end;
    return nil;
end;
local function v10(...)
    local v8 = "";
    for v9 = 1, select("#", ...) do
        v8 = v8 .. select(v9, ...);
    end;
    return v8;
end;
local function v12(v11)
    return math.floor(v11 + 0.5);
end;
local v13 = {};
local v14 = common.get_username();
v13.name = "angelwings";
v13.user = v14;
v13.build = "live";
v14 = nil;
v14 = {
    lerp = function(v15, v16, v17)
        return v15 + v17 * (v16 - v15);
    end,
    closest_ray_point = function(v18, v19, v20, v21)
        local v22 = v20 - v18;
        local v23 = v19 - v18;
        local v24 = v23.x * v23.x + v23.y * v23.y;
        local v25 = (v22.x * v23.x + v22.y * v23.y) / v24;
        if v21 then
            if v25 <= 0 then
                return v18;
            elseif v25 >= 1 then
                return v19;
            end;
        end;
        return v18 + v25 * v23;
    end
};
local v26 = nil;
v26 = {
    antiaim = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yaw = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
            },
            yaw_modifier = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
            },
            body_yaw = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            },
            freestanding = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            },
            extended_angles = {
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
                ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
            }
        },
        misc = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
            leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    },
    ragebot = {
        main = {
            peek_assist = {
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
                {
                    ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style")
                },
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop"),
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode")
            },
            hide_shots = {
                ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
                ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
            },
            double_tap = {
                ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
                ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
                ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
                ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"),
                ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch")
            }
        },
        selection = {
            min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
        }
    }
};
local v27 = nil;
v27 = {};
local v28 = ffi.typeof("        struct {\n            float x, y, z;\n        }\n    ");
local v29 = ffi.typeof("        struct {\n            uint8_t r, g, b, a;\n        }\n    ");
local v30 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 1, ffi.typeof("void(__thiscall*)(void *thisptr, const $ &origin, const $ &mins, const $ &maxs, const $ &angles, int r, int g, int b, int a, float duration)", v28, v28, v28, v28));
local v31 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 20, ffi.typeof("void(__thiscall*)(void *thisptr, const $ &origin, const $ &dest, int r, int g, int b, int a, bool noDepthTest, float duration)", v28, v28));
local v32 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 21, "void(__thiscall*)(void *thisptr, const $ &origin, const $ &mins, const $ &maxs, const $ &angles, $ *face_color, $ *edge_color, float duration)", v28, v28, v28, v28, v29, v29);
do
    local l_v28_0, l_v29_0, l_v30_0, l_v31_0, l_v32_0 = v28, v29, v30, v31, v32;
    v27.box = function(v38, v39, v40, v41, v42, v43, v44, v45, v46)
        -- upvalues: l_v28_0 (ref), l_v30_0 (ref)
        v38 = l_v28_0(v38:unpack());
        v39 = l_v28_0(v39:unpack());
        v40 = l_v28_0(v40:unpack());
        v41 = l_v28_0(v41:unpack());
        l_v30_0(v38, v39, v40, v41, v42, v43, v44, v45, v46);
    end;
    v27.line = function(v47, v48, v49, v50, v51)
        -- upvalues: l_v28_0 (ref), l_v31_0 (ref)
        v47 = l_v28_0(v47:unpack());
        v48 = l_v28_0(v48:unpack());
        l_v31_0(v47, v48, v49.r, v49.g, v49.b, v49.a, v50, v51);
    end;
    v27.box_new = function(v52, v53, v54, v55, v56, v57, v58)
        -- upvalues: l_v28_0 (ref), l_v29_0 (ref), l_v32_0 (ref)
        v52 = l_v28_0(v52:unpack());
        v53 = l_v28_0(v53:unpack());
        v54 = l_v28_0(v54:unpack());
        v55 = l_v28_0(v55:unpack());
        v56 = l_v29_0(v56:unpack());
        v57 = l_v29_0(v57:unpack());
        l_v32_0(v52, v53, v54, v55, v56, v57, v58);
    end;
end;
v28 = nil;
v28 = {};
v29 = {};
v29.__index = v29;
v29.new = function(v59)
    return setmetatable({
        count = 0,
        list = {}
    }, v59);
end;
v29.__len = function(v60)
    return v60.count;
end;
v29.__call = function(v61, v62, v63)
    if v63 == false then
        return v61:unset(v62);
    else
        return v61:set(v62);
    end;
end;
v29.unset = function(v64, v65)
    -- upvalues: v7 (ref)
    local v66 = v7(v64.list, v65);
    if v66 ~= nil then
        v64.count = v64.count - 1;
        table.remove(v64.list, v66);
    end;
    return v64;
end;
v29.set = function(v67, v68, v69)
    -- upvalues: v7 (ref)
    if v69 == false then
        return v67:unset(v68);
    else
        if not v7(v67.list, v68) then
            v67.count = v67.count + 1;
            table.insert(v67.list, v68);
        end;
        return v67;
    end;
end;
v29.fire = function(v70, ...)
    local l_list_0 = v70.list;
    for v72 = 1, #l_list_0 do
        l_list_0[v72](...);
    end;
    return v70;
end;
v30 = {};
do
    local l_v29_1, l_v30_1 = v29, v30;
    v31 = function(v75, v76)
        -- upvalues: l_v29_1 (ref)
        local v77 = rawget(v75, v76);
        if v77 == nil then
            v77 = l_v29_1:new();
            rawset(v75, v76, v77);
        end;
        return v77;
    end;
    do
        local l_v31_1 = v31;
        l_v30_1.new = function(_)
            -- upvalues: l_v31_1 (ref)
            return setmetatable({}, {
                __index = l_v31_1
            });
        end;
    end;
    v28.new = function(_)
        -- upvalues: l_v30_1 (ref)
        return l_v30_1:new();
    end;
end;
v29 = nil;
v29 = {};
v30 = bit.lshift(1, 0);
v31 = {};
v31.__index = v31;
v31.__newindex = function(v81, v82, v83)
    v81[0][v82] = v83;
end;
do
    local l_v30_2, l_v31_2 = v30, v31;
    l_v31_2.__index = function(v86, v87)
        -- upvalues: l_v31_2 (ref), l_v30_2 (ref)
        local v88 = rawget(l_v31_2, v87);
        if v88 ~= nil then
            return v88;
        else
            local v89 = rawget(v86, v87);
            if v89 ~= nil then
                return v89;
            else
                local v90 = v86[0][v87];
                if v90 == nil then
                    return nil;
                elseif type(v90) == "function" then
                    local function v94(...)
                        -- upvalues: v86 (ref), l_v30_2 (ref), v90 (ref)
                        local v91 = {};
                        local v92 = select("#", ...);
                        for v93 = 1, v92 do
                            v91[v93] = select(v93, ...);
                        end;
                        if bit.band(v86.flags, l_v30_2) ~= 0 then
                            v86:fire_callbacks(v91, v92);
                        end;
                        if v91[1] == v86 then
                            v91[1] = v86[0];
                        end;
                        return v90(unpack(v91, 1, v92));
                    end;
                    rawset(v86, v87, v94);
                    return v94;
                else
                    return v90;
                end;
            end;
        end;
    end;
    l_v31_2.new = function(v95, v96)
        -- upvalues: l_v30_2 (ref)
        local v97 = {
            flags = 0,
            [0] = v96,
            callbacks = {}
        };
        v97.flags = bit.bor(v97.flags, l_v30_2);
        return setmetatable(v97, v95);
    end;
    l_v31_2.fire_callbacks = function(v98, ...)
        local v99 = rawget(v98, "callbacks");
        for v100 = 1, #v99 do
            v99[v100](...);
        end;
        return v98;
    end;
    l_v31_2.get_flag = function(v101, v102)
        return bit.band(v101.flags, v102) ~= 0;
    end;
    l_v31_2.set_flag = function(v103, v104, v105)
        if v105 then
            v103.flags = bit.bor(v103.flags, v104);
        else
            v103.flags = bit.band(v103.flags, bit.bnot(v104));
        end;
        return v103;
    end;
    l_v31_2.set_callback = function(v106, v107)
        -- upvalues: v7 (ref)
        local v108 = rawget(v106, "callbacks");
        if v7(v108, v107) == nil then
            table.insert(v108, v107);
        end;
        return v106;
    end;
    l_v31_2.unset_callback = function(v109, v110)
        -- upvalues: v7 (ref)
        local v111 = rawget(v109, "callbacks");
        local v112 = v7(v111, v110);
        if v112 ~= nil then
            table.remove(v111, v112);
        end;
        return v109;
    end;
    v29.group_flags = {
        callbacks = l_v30_2
    };
    v29.cast = function(v113)
        -- upvalues: l_v31_2 (ref)
        return l_v31_2:new(v113);
    end;
    v29.create = function(...)
        -- upvalues: l_v31_2 (ref)
        return l_v31_2:new(ui.create(...));
    end;
end;
v30 = nil;
v30 = {};
v31 = "ui\\beepclear.wav";
v32 = "resource\\warning.wav";
local l_play_0 = cvar.play;
local function v119(v115, v116)
    -- upvalues: v13 (ref)
    local v117 = " \194\183 ";
    local v118 = string.format("\a%s[%s]\aDEFAULT", v115:to_hex(), v13.name);
    print_raw(v118 .. v117 .. v116);
end;
do
    local l_v31_3, l_v32_1, l_l_play_0_0, l_v119_0 = v31, v32, l_play_0, v119;
    v30.log = function(v124)
        -- upvalues: l_v119_0 (ref)
        l_v119_0(color(255, 255, 255, 200), v124);
    end;
    v30.success = function(v125)
        -- upvalues: l_v119_0 (ref), l_l_play_0_0 (ref), l_v31_3 (ref)
        l_v119_0(color(250, 137, 250, 255), v125);
        l_l_play_0_0:call(l_v31_3);
    end;
    v30.error = function(v126)
        -- upvalues: l_v119_0 (ref), l_l_play_0_0 (ref), l_v32_1 (ref)
        l_v119_0(color(250, 0, 50, 255), v126);
        l_l_play_0_0:call(l_v32_1);
    end;
end;
v31 = nil;
v31 = {};
v32 = {};
do
    local l_v32_2 = v32;
    v31.get = function()
        -- upvalues: l_v32_2 (ref)
        return l_v32_2;
    end;
    v31.add = function(v128, v129, v130)
        -- upvalues: l_v32_2 (ref)
        l_v32_2[v128] = {
            [1] = v129,
            [2] = v130
        };
    end;
end;
v32 = nil;
v32 = {};
l_play_0 = function(v131, v132, v133, v134)
    return v133 * v131 / v134 + v132;
end;
v119 = function()
    return globals.frametime;
end;
local function v141(v135, v136, v137, v138, v139)
    if v138 <= 0 then
        return v137;
    elseif v139 <= v138 then
        return v137;
    else
        v136 = v135(v138, v136, v137 - v136, v139);
        if type(v136) == "number" then
            if math.abs(v137 - v136) < 0.001 then
                return v137;
            else
                local v140 = v136 % 1;
                if v140 < 0.001 then
                    return math.floor(v136);
                elseif v140 > 0.999 then
                    return math.ceil(v136);
                end;
            end;
        end;
        return v136;
    end;
end;
do
    local l_l_play_0_1, l_v119_1, l_v141_0 = l_play_0, v119, v141;
    v32.interp = function(v145, v146, v147, v148)
        -- upvalues: l_l_play_0_1 (ref), l_v141_0 (ref), l_v119_1 (ref)
        if not v148 then
            v148 = l_l_play_0_1;
        end;
        if type(v146) == "boolean" then
            v146 = v146 and 1 or 0;
        end;
        return l_v141_0(v148, v145, v146, l_v119_1(), v147);
    end;
end;
l_play_0 = nil;
v119 = _G.render;
v141 = math.floor;
local v149 = color(0, 0, 0, 0);
local v150 = 1;
local v151 = "s";
do
    local l_v119_2, l_v149_0, l_v150_0 = v119, v149, v150;
    local function v156(v155)
        -- upvalues: l_v150_0 (ref)
        if l_v150_0 == 1 then
            return v155;
        else
            return v155 * l_v150_0;
        end;
    end;
    local v157 = 1;
    local v158 = {};
    local l_alpha_modulate_0 = color().alpha_modulate;
    local function v162(v160, v161)
        -- upvalues: v157 (ref), l_v149_0 (ref), l_alpha_modulate_0 (ref)
        if v157 == 1 then
            return v160;
        elseif not v161 and v157 == 0 then
            return l_v149_0;
        else
            return l_alpha_modulate_0(v160, v157, true);
        end;
    end;
    l_play_0 = setmetatable({
        cheap = false,
        dpi = l_v119_2.get_scale(2),
        push_alpha = function(v163)
            -- upvalues: v158 (ref), v157 (ref)
            local v164 = #v158;
            if v164 > 255 then
                error("alpha stack exceeded 255 objects, report to developers");
            end;
            v158[v164 + 1] = v163;
            v157 = v157 * v158[v164 + 1] * (v158[v164] or 1);
        end,
        pop_alpha = function()
            -- upvalues: v158 (ref), v157 (ref)
            local v165 = #v158;
            local l_v158_0 = v158;
            local l_v165_0 = v165;
            local v168 = nil;
            v165 = v165 - 1;
            l_v158_0[l_v165_0] = v168;
            v157 = v165 == 0 and 1 or v158[v165] * (v158[v165 - 1] or 1);
        end,
        get_alpha = function(v169)
            -- upvalues: v158 (ref), v157 (ref)
            if v169 then
                return v158[v169];
            else
                return v157, #v158;
            end;
        end,
        screen_size = function(v170)
            -- upvalues: l_v119_2 (ref), l_v150_0 (ref)
            return l_v119_2.screen_size() / (v170 and 1 or l_v150_0);
        end,
        measure_text = function(v171, ...)
            -- upvalues: l_v119_2 (ref), l_v150_0 (ref)
            return l_v119_2.measure_text(v171, ...) / l_v150_0;
        end,
        load_font = function(v172, v173, v174)
            -- upvalues: l_v119_2 (ref)
            return l_v119_2.load_font(v172, v173, v174 or "");
        end,
        text = function(v175, v176, v177, v178, ...)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref), l_play_0 (ref)
            l_v119_2.text(v175, v156(v176), v162(v177), v178, ...);
            if measure == true then
                return l_play_0.measure_text(v175, v178, ...);
            else
                return;
            end;
        end,
        blur = function(v179, v180, v181, v182, v183)
            -- upvalues: l_play_0 (ref), v156 (ref), v157 (ref), l_v119_2 (ref)
            if l_play_0.cheap then
                return;
            else
                if type(v183) == "table" then
                    for v184 = 1, 4 do
                        v183[v184] = v156(v183[v184] or 0);
                    end;
                else
                    v183 = v156(v183 or 0);
                end;
                local v185 = (v182 or 1) * v157;
                v181 = v156(v181 or 2);
                v182 = v185;
                if v182 > 0 and v181 > 0 then
                    l_v119_2.blur(v156(v179), v156(v180), v181, v182, v183);
                end;
                return;
            end;
        end,
        shadow = function(v186, v187, v188, v189, v190, v191)
            -- upvalues: l_play_0 (ref), l_v119_2 (ref), v156 (ref), v162 (ref)
            if l_play_0.cheap then
                return;
            else
                l_v119_2.shadow(v156(v186), v156(v187), v162(v188), v156(v189 or 16), v156(v190 or 0), v156(v191 or 0));
                return;
            end;
        end,
        line = function(v192, v193, v194)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref)
            l_v119_2.line(v156(v192), v156(v193), v162(v194));
        end,
        rect = function(v195, v196, v197, v198, v199)
            -- upvalues: v156 (ref), l_v119_2 (ref), v162 (ref)
            if type(v198) == "table" then
                for v200 = 1, 4 do
                    v198[v200] = v156(v198[v200] or 0);
                end;
            else
                v198 = v156(v198 or 0);
            end;
            l_v119_2.rect(v156(v195), v156(v196), v162(v197), v198, v199 or false);
        end,
        rect_outline = function(v201, v202, v203, v204, v205, v206)
            -- upvalues: v156 (ref), l_v119_2 (ref), v162 (ref)
            if type(v205) == "table" then
                for v207 = 1, 4 do
                    v205[v207] = v156(v205[v207] or 0);
                end;
            else
                v205 = v156(v205 or 0);
            end;
            l_v119_2.rect_outline(v156(v201), v156(v202), v162(v203), v156(v204 or 0), v205, v206 or false);
        end,
        gradient = function(v208, v209, v210, v211, v212, v213, v214)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref)
            local v215 = v212 or v210;
            if not v213 then
                v213 = v211;
            end;
            l_v119_2.gradient(v156(v208), v156(v209), v162(v210, true), v162(v211, true), v162(v215, true), v162(v213, true), v214 or 0);
        end,
        circle = function(v216, v217, v218, v219, v220)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref)
            l_v119_2.circle(v156(v216), v162(v217), v156(v218), v219 or 0, v220 or 1);
        end,
        circle_outline = function(v221, v222, v223, v224, v225, v226)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref)
            l_v119_2.circle_outline(v156(v221), v162(v222), v156(v223), v224 or 0, v225 or 1, v156(v226 or 1));
        end,
        circle_3d = function(v227, v228, v229, v230, v231)
            -- upvalues: l_v119_2 (ref), v162 (ref)
            l_v119_2.circle_3d(v227, v162(v228), v229, v230 or 0, v231 or 1, false);
        end,
        circle_3d_outline = function(v232, v233, v234, v235, v236, v237)
            -- upvalues: l_v119_2 (ref), v162 (ref), v156 (ref)
            l_v119_2.circle_3d_outline(v232, v162(v233), v234, v235 or 0, v236 or 1, v156(v237 or 1));
        end,
        circle_3d_gradient = function(v238, v239, v240, v241, v242, v243, v244)
            -- upvalues: l_v119_2 (ref), v162 (ref), v156 (ref)
            l_v119_2.circle_3d_gradient(v238, v162(v239), v162(v240), v241, v242 or 0, v243 or 1, v156(v244 or 1));
        end,
        texture = function(v245, v246, v247, v248, v249, v250)
            -- upvalues: l_v119_2 (ref), v156 (ref), v162 (ref)
            if not v245 then
                return;
            else
                if not v248 then
                    v248 = color();
                end;
                l_v119_2.texture(v245, v156(v246), v156(v247 or vector(v245.width, v245.height)), v162(v248), v249 or "", v250 or 0);
                return;
            end;
        end,
        push_clip_rect = function(v251, v252, v253)
            -- upvalues: l_v119_2 (ref), v156 (ref)
            l_v119_2.push_clip_rect(v156(v251), v156(v252), v253 or false);
        end
    }, {
        __index = l_v119_2
    });
end;
v119 = nil;
v141 = {};
v149 = nil;
v150 = color(255, 255, 255, 255);
v151 = function(v254, v255, v256)
    return v254.x >= v255.x and v254.x <= v256.x and v254.y >= v255.y and v254.y <= v256.y;
end;
local v257 = v29.create("##DRAG");
v257:visibility(false);
local v258 = l_play_0.screen_size();
do
    local l_v149_1, l_v150_1, l_v151_0, l_v257_0, l_v258_0 = v149, v150, v151, v257, v258;
    v119 = {
        data = v141,
        in_bounds = l_v151_0,
        new = function(v264, v265)
            -- upvalues: v119 (ref), l_v257_0 (ref), l_v258_0 (ref), v12 (ref)
            if type(v265) ~= "table" then
                v265 = {};
            end;
            v119[v264.id] = {
                x = l_v257_0:slider(v264.id .. "::x", 0, 10000, v264.pos.x / l_v258_0.x * 10000),
                y = l_v257_0:slider(v264.id .. "::y", 0, 10000, v264.pos.y / l_v258_0.y * 10000)
            };
            v119[v264.id].x:set_callback(function(v266)
                -- upvalues: v264 (ref), v12 (ref), l_v258_0 (ref)
                v264.pos.x = v12(v266:get() * 1.0E-4 * l_v258_0.x);
            end, true);
            v119[v264.id].y:set_callback(function(v267)
                -- upvalues: v264 (ref), v12 (ref), l_v258_0 (ref)
                v264.pos.y = v12(v267:get() * 1.0E-4 * l_v258_0.y);
            end, true);
            v264.__drag = {
                active = false,
                locked = false,
                point = vector(),
                progress = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                    [4] = 0
                },
                border = v265.border or {
                    [1] = vector(),
                    [2] = oscreen
                },
                rulers = v265.rulers or {},
                on_release = v265.on_release,
                on_held = v265.on_held,
                on_active = v265.on_active,
                config = v119[v264.id]
            };
            events.mouse_input:set(function()
                -- upvalues: v264 (ref)
                if ui.get_alpha() > 0 and (v264.__drag.hovered or v264.__drag.active) then
                    return false;
                else
                    return;
                end;
            end);
            events.dpi_change:set(function(_, _, _)
                -- upvalues: v119 (ref), v264 (ref)
                v119[v264.id].x:set(v119[v264.id].x.value);
                v119[v264.id].y:set(v119[v264.id].y.value);
            end);
        end,
        process = function(v271)
            -- upvalues: l_play_0 (ref), l_v151_0 (ref), l_v149_1 (ref), v32 (ref), l_v150_1 (ref), l_v258_0 (ref)
            local l___drag_0 = v271.__drag;
            if l___drag_0.locked or ui.get_alpha() == 0 then
                return;
            else
                local v273 = ui.get_mouse_position() / l_play_0.dpi;
                local v274 = ui.get_position();
                local v275 = ui.get_size();
                local v276 = ui.get_alpha() > 0 and common.is_button_down(1);
                local v277 = l_v151_0(v273, v271.pos, v271.pos + v271.size) and not l_v151_0(v273, v274 / l_play_0.dpi, (v274 + v275) / l_play_0.dpi);
                if v276 and l___drag_0.ready == nil then
                    local l_v277_0 = v277;
                    local v279 = v271.pos - v273;
                    l___drag_0.init = v271.pos:clone();
                    l___drag_0.point = v279;
                    l___drag_0.ready = l_v277_0;
                end;
                if v276 and l___drag_0.ready then
                    if l_v149_1 == nil and l___drag_0.on_held then
                        l___drag_0.on_held(v271, l___drag_0);
                    end;
                    l_v149_1 = l___drag_0.ready and l_v149_1 == nil and v271.id or l_v149_1;
                    l___drag_0.active = l_v149_1 == v271.id;
                elseif not v276 then
                    if l___drag_0.active and l___drag_0.on_release then
                        l___drag_0.on_release(v271, l___drag_0);
                    end;
                    l___drag_0.active = false;
                    local v280 = nil;
                    local v281 = nil;
                    local v282 = nil;
                    local v283 = nil;
                    l_v149_1 = nil;
                    l___drag_0.aligning = v283;
                    l___drag_0.init = v282;
                    l___drag_0.point = v281;
                    l___drag_0.ready = v280;
                end;
                local v284 = v271.pos * l_play_0.dpi;
                local v285 = v271.size * l_play_0.dpi;
                l___drag_0.hovered = v277 or l___drag_0.active;
                local v286 = {};
                local v287 = v284 + v285 * 0.5;
                local v288 = l___drag_0.point and (l___drag_0.point + v273) * l_play_0.dpi or v284;
                l___drag_0.progress[1] = v32.interp(l___drag_0.progress[1], l___drag_0.active, 0.1);
                l___drag_0.progress[2] = v32.interp(l___drag_0.progress[2], l___drag_0.active or l___drag_0.hovered, 0.1);
                local v289 = l___drag_0.progress[1];
                local v290 = l___drag_0.progress[2];
                l_play_0.push_alpha(ui.get_alpha());
                l_play_0.rect(v271.pos - 4, v271.pos + v271.size + 4, l_v150_1:alpha_modulate(0.1 * (v290 * 0.65 + 0.35), true), 6);
                l_play_0.rect_outline(v271.pos - 5, v271.pos + v271.size + 5, l_v150_1:alpha_modulate(0.3 * v289, true), 1, 7);
                l_play_0.push_alpha(v289);
                if v289 > 0 and not common.is_button_down(162) then
                    local v291 = (v288 + v285 * 0.5) / l_play_0.dpi;
                    for _, v293 in ipairs(l___drag_0.rulers) do
                        v293[4] = v293[4] or {
                            [1] = 0
                        };
                        local v294 = v293[2] / l_play_0.dpi;
                        local v295 = math.abs(v293[1] and v291.x - v294.x or v291.y - v294.y) < 10 * l_play_0.dpi;
                        local l_v294_0 = v294;
                        local v297 = v293[1] and vector(v294.x + 1, v293[3] / l_play_0.dpi) or vector(v293[3] / l_play_0.dpi, v294.y + 1);
                        local v298 = v293[1] and 1 or 2;
                        if not v286[v298] then
                            v286[v298] = v295 and (v293[1] and v294.x - v271.size.x * 0.5 or v294.y - v271.size.y * 0.5) or nil;
                        end;
                        local v299 = math.abs(v293[1] and v287.x - v294.x or v287.y - v294.y);
                        l___drag_0.progress[4] = v32.interp(l___drag_0.progress[4], v295 or v299 < 10 * l_play_0.dpi, 0.1);
                        local v300 = l___drag_0.progress[4] * 0.35 + 0.1;
                        l_play_0.rect(l_v294_0, v297, l_v150_1:alpha_modulate(v300, true));
                    end;
                    if l___drag_0.border[3] then
                        local v301 = utilities.in_bounds(v271.pos, l___drag_0.border[1], l___drag_0.border[2] - v271.size * 0.5 - 1);
                        l___drag_0.progress[3] = v32.interp(l___drag_0.progress[3], not v301, 0.1);
                        local v302 = l___drag_0.progress[3];
                        l_play_0.rect_outline(l___drag_0.border[1] / l_play_0.dpi, l___drag_0.border[2] / l_play_0.dpi, l_v150_1:alpha_modulate(v302 * 0.75 + 0.25, true), 1, 4);
                    end;
                end;
                l_play_0.pop_alpha();
                l_play_0.pop_alpha();
                if l___drag_0.active then
                    local v303 = v288 / l_play_0.dpi;
                    if common.is_button_down(160) then
                        local v304 = l___drag_0.init:to(v303);
                        local v305 = math.abs(v304.y);
                        local v306 = math.abs(v304.x);
                        if l___drag_0.aligning == nil then
                            if v305 > 0.9 then
                                l___drag_0.aligning = 0;
                            elseif v306 > 0.9 then
                                l___drag_0.aligning = 1;
                            end;
                        end;
                        if l___drag_0.aligning == 0 then
                            v303.x = l___drag_0.init.x;
                            l_play_0.rect(vector(v303.x + v271.size.x * 0.5, 0), vector(v303.x + v271.size.x * 0.5 + 1, l_v258_0.y), color(255, 64));
                        elseif l___drag_0.aligning == 1 then
                            v303.y = l___drag_0.init.y;
                            l_play_0.rect(vector(0, v303.y + v271.size.y * 0.5), vector(l_v258_0.x, v303.y + v271.size.y * 0.5 + 1), color(255, 64));
                        end;
                    end;
                    local v307 = v286[1] or v303.x;
                    v303.y = v286[2] or v303.y;
                    v303.x = v307;
                    v307 = (l___drag_0.border[1] - v285 * 0.5) / l_play_0.dpi;
                    local v308 = (l___drag_0.border[2] - v285 * 0.5) / l_play_0.dpi;
                    v271:set_position(math.clamp(v303.x, v307.x, math.min(v308.x, l_v258_0.x - v271.size.x)), (math.clamp(v303.y, v307.y, math.min(v308.y, l_v258_0.y - v271.size.y))));
                    if l___drag_0.on_active then
                        l___drag_0.on_active(v271, l___drag_0, v303);
                    end;
                end;
                return;
            end;
        end
    };
end;
v141 = nil;
v149 = nil;
do
    local l_v149_2 = v149;
    l_v149_2 = {
        update = function(_)
            return 1;
        end,
        paint = function(_, _, _)

        end,
        set_position = function(v314, v315, v316)
            -- upvalues: l_play_0 (ref)
            local v317 = nil;
            local v318 = nil;
            if type(v315) == "userdata" then
                local l_x_0 = v315.x;
                v318 = v315.y;
                v317 = l_x_0;
            else
                local l_v315_0 = v315;
                v318 = v316;
                v317 = l_v315_0;
            end;
            local v321 = l_play_0.screen_size();
            if v314.__drag then
                if v317 then
                    v314.__drag.config.x:set(v317 / v321.x * 10000);
                end;
                if v318 then
                    v314.__drag.config.y:set(v318 / v321.y * 10000);
                end;
            else
                local l_pos_0 = v314.pos;
                local l_pos_1 = v314.pos;
                local v324;
                if not v317 then
                    v324 = v314.pos.x;
                else
                    v324 = v317;
                end;
                local v325;
                if not v318 then
                    v325 = v314.pos.y;
                else
                    v325 = v318;
                end;
                l_pos_1.y = v325;
                l_pos_0.x = v324;
            end;
        end,
        get_drag_position = function(v326)
            -- upvalues: l_play_0 (ref)
            local v327 = v326.__drag and v326.__drag.config;
            if not v327 then
                return v326.pos;
            else
                local v328 = l_play_0.screen_size();
                local v329 = v327.x:get();
                local v330 = v327.y:get();
                return vector(v329 * 1.0E-4 * v328.x, v330 * 1.0E-4 * v328.y);
            end;
        end,
        get_drag_size = function(v331)
            return v331.size:clone();
        end,
        __call = function(v332)
            -- upvalues: l_play_0 (ref), v119 (ref), l_v149_2 (ref)
            local l___list_0 = v332.__list;
            local l___drag_1 = v332.__drag;
            if l___list_0 then
                local v335 = l___list_0.collect();
                l___list_0.active = 0;
                l___list_0.items = v335;
                for v336 = 1, #l___list_0.items do
                    if l___list_0.items[v336].active then
                        l___list_0.active = l___list_0.active + 1;
                    end;
                end;
            end;
            v332.alpha = v332:update();
            l_play_0.push_alpha(v332.alpha);
            if v332.alpha > 0 then
                if l___drag_1 then
                    v119.process(v332);
                end;
                if l___list_0 then
                    l_v149_2.traverse(v332);
                end;
                v332:paint(v332.pos, v332.pos + v332.size);
            end;
            l_play_0.pop_alpha();
        end,
        enlist = function(v337, v338, v339, v340)
            v337.__list = {
                longest = 0,
                active = 0,
                items = {},
                progress = setmetatable({}, {
                    __mode = "k"
                }),
                minwidth = v337.size.x,
                collect = v338,
                paint = v339,
                rev = v340
            };
        end,
        traverse = function(v341)
            -- upvalues: l_play_0 (ref)
            local l___list_1 = v341.__list;
            local v343 = 0;
            local v344 = vector();
            local v345 = 0;
            l___list_1.longest = 0;
            l___list_1.active = v345;
            for v346 = 1, #l___list_1.items do
                local v347 = l___list_1.items[v346];
                local v348 = v347.name or v346;
                l___list_1.progress[v348] = l___list_1.progress[v348] or {
                    [1] = 0
                };
                local v349 = anima.condition(l___list_1.progress[v348], v347.active, 6, {
                    [1] = {
                        [1] = 1,
                        [2] = 3
                    },
                    [2] = {
                        [1] = 2,
                        [2] = 3
                    }
                });
                if v349 > 0 then
                    l_play_0.push_alpha(v349);
                    v344 = l___list_1.paint(v341, v347, v343, v349);
                    l_play_0.pop_alpha();
                    local v350 = l___list_1.active + 1;
                    v343 = v343 + v344.y * v349;
                    l___list_1.active = v350;
                    l___list_1.longest = math.max(l___list_1.longest, v344.x);
                end;
            end;
            v341.size.x = anima.lerp(v341.size.x, math.max(l___list_1.longest, l___list_1.minwidth), 10, 0.5);
        end,
        lock = function(v351, v352)
            if not v351.__drag then
                return;
            else
                v351.__drag.locked = v352 and true or false;
                return;
            end;
        end
    };
    l_v149_2.__index = l_v149_2;
    v141 = {
        new = function(v353, v354, v355, v356)
            -- upvalues: v119 (ref), l_v149_2 (ref)
            local v357 = {
                alpha = 1,
                id = v353,
                pos = v354,
                size = v355,
                progress = {
                    [1] = 0
                }
            };
            if v356 then
                v119.new(v357, type(v356) == "table" and v356 or nil);
            end;
            return setmetatable(v357, l_v149_2);
        end
    };
end;
v149 = nil;
v149 = {};
v150 = function(v358)
    local v359 = {};
    local v360 = 0;
    for v361 in string.gmatch(v358, ".[\128-\191]*") do
        v360 = v360 + 1;
        v359[v360] = v361;
    end;
    return v359, v360;
end;
do
    local l_v150_2 = v150;
    v149.gradient = function(v363, v364, v365, v366)
        -- upvalues: l_v150_2 (ref)
        local v367 = {};
        local v368, v369 = l_v150_2(v363);
        local v370 = 1 / (v369 - 1);
        local v371 = v366.r - v365.r;
        local v372 = v366.g - v365.g;
        local v373 = v366.b - v365.b;
        local v374 = v366.a - v365.a;
        for v375 = 1, v369 do
            local v376 = v368[v375];
            local v377 = v364 % 2;
            if v377 > 1 then
                v377 = 2 - v377;
            end;
            local v378 = v365.r + v377 * v371;
            local v379 = v365.g + v377 * v372;
            local v380 = v365.b + v377 * v373;
            local v381 = v365.a + v377 * v374;
            local v382 = string.format("%02x%02x%02x%02x", v378, v379, v380, v381);
            table.insert(v367, "\a");
            table.insert(v367, v382);
            table.insert(v367, v376);
            v364 = v364 + v370;
        end;
        return table.concat(v367);
    end;
end;
v150 = nil;
v150 = {
    recorder = {}
};
v151 = nil;
v151 = {
    aimtools = {
        [1] = "Pistols",
        [2] = "AutoSnipers",
        [3] = "AWP",
        [4] = "SSG-08",
        [5] = "Desert Eagle",
        [6] = "R8 Revolver"
    },
    states = {
        [0] = "Shared",
        [1] = "Standing",
        [2] = "Running",
        [3] = "Slow motion",
        [4] = "Crouching",
        [5] = "Move & Crouching",
        [6] = "Air",
        [7] = "Air & Crouching",
        [8] = "On use",
        [9] = "Fakelag",
        [10] = "Freestanding",
        [11] = "Safe Head",
        [12] = "Manual Yaw"
    }
};
v257 = nil;
v257 = {};
v258 = ".\\" .. v13.name;
local function v384(v383)
    return type(v383.type) == "string" and type(v383.link) == "string" and type(v383.width) == "number" and type(v383.height) == "number";
end;
do
    local l_v258_1, l_v384_0 = v258, v384;
    local function v393(v387)
        -- upvalues: l_v384_0 (ref), l_v258_1 (ref), v257 (ref), l_play_0 (ref)
        return function(v388)
            -- upvalues: l_v384_0 (ref), l_v258_1 (ref), v387 (ref), v257 (ref), l_play_0 (ref)
            if not l_v384_0(v388) then
                return false;
            else
                files.create_folder(l_v258_1);
                local v389 = string.format("%s/%s.%s", l_v258_1, v387, v388.type);
                local v390 = files.read(v389, true);
                if v390 ~= nil then
                    v257[v387] = l_play_0.load_image(v390, vector(v388.width, v388.height));
                else
                    network.get(v388.link, {}, function(v391)
                        -- upvalues: v257 (ref), v387 (ref), l_play_0 (ref), v388 (ref), v389 (ref)
                        if v391 == nil then
                            return;
                        else
                            local l_v391_0 = v391;
                            v257[v387] = l_play_0.load_image(l_v391_0, vector(v388.width, v388.height));
                            files.write(v389, l_v391_0, true);
                            return;
                        end;
                    end);
                end;
                return true;
            end;
        end;
    end;
    v393("eva_small")({
        height = 35,
        link = "https://cdn.hysteria.one/angelwings/angelwings_eva_img.png",
        type = "png",
        width = 35
    });
    v393("billy")({
        height = 185,
        link = "https://cdn.hysteria.one/angelwings/billy.png",
        type = "png",
        width = 131
    });
    v393("tulen")({
        height = 401,
        link = "https://cdn.hysteria.one/angelwings/tulen.png",
        type = "png",
        width = 401
    });
end;
v258 = nil;
v258 = {};
local v394 = ({
    illusory = 0,
    live = 2,
    exclusive = 1,
    debug = -1
})[v13.build:lower()];
local v395 = {};
local function v398(v396, v397)
    v396:set(unpack(v397));
    v396:disabled(false);
end;
do
    local l_v394_0, l_v395_0, l_v398_0 = v394, v395, v398;
    local function v404()
        -- upvalues: l_v395_0 (ref), l_v398_0 (ref)
        for v402 = 1, #l_v395_0 do
            local v403 = l_v395_0[v402];
            l_v398_0(v403.item, v403.value);
        end;
    end;
    v258.is_locked = function(v405)
        -- upvalues: l_v394_0 (ref)
        if l_v394_0 == -1 then
            return false;
        elseif v405 == -1 then
            return true;
        else
            return v405 <= l_v394_0;
        end;
    end;
    v258.push = function(v406, v407, ...)
        -- upvalues: v258 (ref), l_v395_0 (ref), l_v398_0 (ref)
        if not v258.is_locked(v406) then
            return v407;
        else
            local v408 = {
                ...
            };
            if select("#", ...) == 0 then
                v408 = {
                    [1] = false
                };
            end;
            table.insert(l_v395_0, {
                item = v407,
                value = v408
            });
            v407:set_callback(function(v409)
                -- upvalues: l_v398_0 (ref), v408 (ref)
                l_v398_0(v409, v408);
            end, true);
            return v407;
        end;
    end;
    v258.update = function()
        -- upvalues: v404 (ref)
        v404();
    end;
    local function v411(v410)
        -- upvalues: v404 (ref)
        if v410 == "pre_save" then
            v404();
        end;
    end;
    utils.execute_after(0, v404);
    events.config_state(v411);
end;
v384 = nil;
v384 = {};
v394 = 1;
v395 = 2;
v398 = function(v412)
    return (string.gsub(v412, "${(.-)}", "\a{Link Active}%1\aDEFAULT"));
end;
local function v414(v413)
    -- upvalues: v3 (ref)
    return string.rep(v3, v413);
end;
local function v418(v415, v416)
    -- upvalues: v3 (ref)
    local v417 = string.rep(v3, v416);
    return v417 .. v415 .. v417;
end;
do
    local l_v398_1, l_v414_0 = v398, v414;
    local function v426(v421, v422, v423, v424, v425)
        -- upvalues: l_v414_0 (ref)
        return l_v414_0(v424) .. "\a" .. v421 .. ui.get_icon(v422) .. l_v414_0(v425) .. "\aDEFAULT" .. v423;
    end;
    local function v431(v427, v428, v429, v430)
        -- upvalues: v426 (ref)
        return v426("{Link Active}", v427, v428, v429, v430);
    end;
    local function v438(v432, v433, v434, v435)
        -- upvalues: l_v414_0 (ref)
        local v436 = l_v414_0(v435);
        local v437 = l_v414_0(3);
        return v436 .. "\a" .. v432 .. ui.get_icon(v433) .. v437 .. "\aDEFAULT" .. v434 .. v436;
    end;
    local function v442(v439, v440, v441)
        -- upvalues: v438 (ref)
        return v438("{Link Active}", v439, v440, v441);
    end;
    local function v447(v443, v444, v445)
        -- upvalues: l_v414_0 (ref)
        local v446 = l_v414_0(v445);
        return v446 .. "\a" .. v443 .. ui.get_icon(v444) .. v446;
    end;
    local function v450(v448, v449)
        -- upvalues: v447 (ref)
        return v447("{Link Active}", v448, v449);
    end;
    local function v458(v451, v452)
        local v453 = v451:get();
        if #v453 == 0 then
            if v452 == nil then
                local v454 = v451:type();
                local v455 = v451:list();
                if v454 == "selectable" then
                    v452 = v455;
                elseif v454 == "listable" then
                    v452 = {};
                    for v456 = 1, #v455 do
                        v452[v456] = v456;
                    end;
                end;
            end;
            v453 = v452;
            v451:set(v452);
        end;
        v451:set_callback(function()
            -- upvalues: v451 (ref), v453 (ref)
            local v457 = v451:get();
            if #v457 > 0 then
                v453 = v457;
            else
                v451:set(v453);
            end;
        end);
    end;
    local v459 = {
        category = v29.create("~", "##CATEGORY", v394),
        info = v29.create("~", "##INFO", v394),
        antiaim = {
            main = v29.create("~", "##AA_MAIN", v394),
            state = v29.create("~", "##AA_STATE", v395),
            recorder = v29.create("~", "##AA_RECORDER", v395),
            settings = v29.create("~", "##AA_SETTINGS", v395),
            presets = v29.create("~", "##AA_PRESETS", v395)
        },
        ragebot = v29.create("~", "##RAGEBOT", v395),
        visuals = v29.create("~", "##VISUALS", v395),
        misc = v29.create("~", "##MISC", v395)
    };
    local _ = nil;
    local function v466()
        -- upvalues: v149 (ref), v13 (ref)
        local v461 = ui.get_style();
        local v462 = color(40, 40, 40, 255);
        local v463 = v461["Link Active"];
        local v464 = -globals.realtime * 0.8;
        local v465 = v149.gradient(v13.name, v464, v463, v462);
        ui.sidebar(v465, "sparkles");
    end;
    events.render(v466);
    v466 = nil;
    v466 = v459.category:list("##CATEGORY", {
        [1] = "Anti-Aim",
        [2] = "Ragebot",
        [3] = "Visuals",
        [4] = "Misc"
    });
    v384.category = v466;
    local v467 = {};
    local v468 = string.lower(v13.build);
    v467.welcome_text = v459.info:label(v431("user", l_v398_1(string.format("Welcome back, ${%s}", v13.user)), 1, 7));
    v467.welcome_text = v459.info:label(v431("code-branch", l_v398_1(string.format("Your build is ${%s}", v468)), 1, 7));
    v384.info = v467;
    v384.links = {
        label = v459.info:label(v10("\a{Link Active}", "Links")),
        discord = v459.info:button(v450("discord", 10), nil, true),
        youtube = v459.info:button(v450("youtube", 10), nil, true),
        config = v459.info:button(v450("file", 10), nil, true)
    };
    v384.configs = {
        label = v459.info:label(v10("\a{Link Active}", "Config")),
        export = v459.info:button(v442("copy", "Export", 7), nil, true),
        import = v459.info:button(v442("paste", "Import", 7), nil, true),
        default = v459.info:button(v418("Load Default Config", 34), nil, true)
    };
    local v469 = {};
    local l_main_0 = v459.antiaim.main;
    local l_state_0 = v459.antiaim.state;
    local l_settings_0 = v459.antiaim.settings;
    local l_presets_0 = v459.antiaim.presets;
    local l_recorder_0 = v459.antiaim.recorder;
    v31.add("##ANTIAIM_MAIN", l_main_0, "AA");
    v31.add("##ANTIAIM_STATE", l_state_0, "AA");
    v31.add("##ANTIAIM_SETTINGS", l_settings_0, "AA");
    v469.enabled = l_main_0:switch("Enabled");
    v469.mode = l_main_0:list("##MODE", {
        [1] = "Main",
        [2] = "Settings",
        [3] = "Presets"
    });
    local v475 = {};
    local v476 = {
        unpack(v151.states, 0)
    };
    local v477 = {};
    v475.state = l_state_0:combo("State", v476);
    local v478 = nil;
    local function v480(v479)
        -- upvalues: v459 (ref)
        v459.info:visibility(v479);
    end;
    do
        local l_l_settings_0_0, l_l_presets_0_0, l_l_recorder_0_0, l_v475_0 = l_settings_0, l_presets_0, l_recorder_0, v475;
        do
            local l_v476_0, l_v477_0 = v476, v477;
            local function v498(v487)
                -- upvalues: l_v475_0 (ref), l_v476_0 (ref), l_v477_0 (ref), l_l_recorder_0_0 (ref)
                local v488 = l_v475_0.state:get();
                l_v475_0.state:visibility(v487);
                local v489 = false;
                for v490 = 1, #l_v476_0 do
                    local v491 = l_v476_0[v490];
                    local v492 = l_v475_0[v491];
                    local v493 = l_v477_0[v491];
                    local v494 = v487 and v491 == v488;
                    if v492 ~= nil and v492.enabled ~= nil then
                        v492.enabled:visibility(v494);
                        if v494 then
                            v494 = v492.enabled:get();
                        end;
                    end;
                    if v492.bomb_e_fix ~= nil then
                        v492.bomb_e_fix:visibility(v494);
                    end;
                    local v495 = v492.mode:get();
                    v492.mode:visibility(v494);
                    local v496 = v495 == "Builder";
                    local v497 = v495 == "Recorder";
                    if v493 ~= nil then
                        if v493.angles ~= nil then
                            v493.angles:visibility(v496 and v494);
                        end;
                        if v493.defensive ~= nil then
                            v493.defensive:visibility(v496 and v494);
                        end;
                        if v493.recorder ~= nil then
                            v493.recorder:visibility(v497 and v494);
                        end;
                    end;
                    if v497 and v494 then
                        v489 = true;
                    end;
                end;
                l_l_recorder_0_0:visibility(v489);
            end;
            local function v500(v499)
                -- upvalues: l_l_presets_0_0 (ref)
                l_l_presets_0_0:visibility(v499);
            end;
            local function v502(v501)
                -- upvalues: l_l_settings_0_0 (ref)
                l_l_settings_0_0:visibility(v501);
            end;
            do
                local l_v480_0, l_v498_0, l_v500_0, l_v502_0 = v480, v498, v500, v502;
                local function v513(v507)
                    -- upvalues: v469 (ref), l_v480_0 (ref), l_v498_0 (ref), l_v502_0 (ref), l_v500_0 (ref)
                    local v508 = v469.mode:get();
                    local v509 = v469.enabled:get();
                    local v510 = v508 == 1;
                    local v511 = v508 == 2;
                    local v512 = v508 == 3;
                    v469.enabled:visibility(v507);
                    v469.mode:visibility(v507 and v509);
                    l_v480_0(not v507 or not v509);
                    l_v498_0(v507 and v509 and v510);
                    l_v502_0(v507 and v509 and v511);
                    l_v500_0(v507 and v509 and v512);
                end;
                v478 = function()
                    -- upvalues: v466 (ref), v513 (ref)
                    local v514 = v466:get();
                    v513(v514 == 1);
                end;
            end;
            v480 = function(v515, v516)
                -- upvalues: l_v398_1 (ref)
                local v517 = {
                    [1] = "Off",
                    [2] = "Offset",
                    [3] = "Center",
                    [4] = "Skitter",
                    [5] = "Custom Ways",
                    [6] = "Spin",
                    [7] = "Random"
                };
                local v518 = {
                    [1] = "Off",
                    [2] = "Left",
                    [3] = "Right",
                    [4] = "Jitter",
                    [5] = "Random"
                };
                local function v520(v519)
                    return v519 > 0 and v519 .. "%" or "Off";
                end;
                local function v522(v521)
                    return v521 > 1 and v521 .. "t" or "Off";
                end;
                local function v524(v523)
                    return v523 > 0 and v523 .. "t" or "Off";
                end;
                v516.yaw_offset = v515:slider("Offset", -90, 90, 0, nil, "\194\176");
                v516.add_yaw = v515:switch("Add Yaw");
                v516.yaw_left = v515:slider(l_v398_1("${~}   Left##YAW"), -90, 90, 0, nil, "\194\176");
                v516.yaw_right = v515:slider(l_v398_1("${~}   Right##YAW"), -90, 90, 0, nil, "\194\176");
                v516.add_yaw:set_callback(function(v525)
                    -- upvalues: v516 (ref)
                    local v526 = v525:get();
                    v516.yaw_left:visibility(v526);
                    v516.yaw_right:visibility(v526);
                end, true);
                v516.yaw_jitter = v515:combo("Jitter", v517);
                v516.jitter_offset = v515:slider(l_v398_1("${~}   Degree"), -90, 90, 0, nil, "\194\176");
                v516.way = {
                    v515:slider(l_v398_1("${~}   Way 1"), -90, 90, 0, nil, "\194\176"),
                    v515:slider(l_v398_1("${~}   Way 2"), -90, 90, 0, nil, "\194\176"),
                    v515:slider(l_v398_1("${~}   Way 3"), -90, 90, 0, nil, "\194\176")
                };
                v516.yaw_jitter:set_callback(function(v527)
                    -- upvalues: v516 (ref)
                    local v528 = v527:get();
                    local v529 = v528 == "Off";
                    local v530 = not v529 and v528 ~= "Custom Ways";
                    local v531 = not v529 and v528 == "Custom Ways";
                    v516.jitter_offset:visibility(v530);
                    for v532 = 1, #v516.way do
                        v516.way[v532]:visibility(v531);
                    end;
                end, true);
                v516.body_yaw = v515:combo("Body Yaw", v518);
                local v533 = v516.body_yaw:create();
                v516.avoid_overlap = v533:switch("Avoid overlap");
                v516.freestanding_body_yaw = v533:combo("Freestanding", {
                    [1] = "Off",
                    [2] = "Peek Fake",
                    [3] = "Peek Real"
                });
                v516.left_limit = v515:slider(l_v398_1("${~}   Left##BODY_YAW"), 0, 60, 60, nil, "\194\176");
                v516.right_limit = v515:slider(l_v398_1("${~}   Right##BODY_YAW"), 0, 60, 60, nil, "\194\176");
                v516.body_yaw:set_callback(function(v534)
                    -- upvalues: v516 (ref)
                    local v535 = v534:get();
                    local v536 = v535 == "Left";
                    local v537 = v535 == "Right";
                    local v538 = v535 == "Jitter";
                    local v539 = v535 == "Random";
                    v516.left_limit:visibility(v536 or v538 or v539);
                    v516.right_limit:visibility(v537 or v538 or v539);
                end, true);
                v516.random = v515:slider("Randomization", 0, 100, 0, nil, v520);
                v516.delay = v515:slider("Delay", 1, 14, 1, nil, v522);
                v516.random_delay = v516.delay:create():slider("Random ticks", 0, 14, 0, nil, v524);
                return v516;
            end;
            v498 = function(v540, v541)
                -- upvalues: l_v398_1 (ref)
                local v542 = {
                    [1] = "Off",
                    [2] = "Static",
                    [3] = "Jitter",
                    [4] = "Spin",
                    [5] = "Random"
                };
                local v543 = {
                    [1] = "Off",
                    [2] = "Static",
                    [3] = "Spin",
                    [4] = "Random",
                    [5] = "Left/Right"
                };
                local v544 = {
                    [1] = "Off",
                    [2] = "Offset",
                    [3] = "Center",
                    [4] = "Skitter"
                };
                local function v546(v545)
                    return v545 > 1 and v545 .. "t" or "Off";
                end;
                local function v548(v547)
                    return v547 > 0 and v547 .. "t" or "Off";
                end;
                v541.force_break_lc = v540:switch("Force Break LC");
                v541.enabled = v540:switch("Defensive AA");
                v541.pitch = v540:combo("Pitch", v542);
                v541.pitch_offset_1 = v540:slider(l_v398_1("${~}   Angle 1##PITCH"), -89, 89, 0, nil, "\194\176");
                v541.pitch_offset_2 = v540:slider(l_v398_1("${~}   Angle 2##PITCH"), -89, 89, 0, nil, "\194\176");
                v541.pitch_speed = v540:slider(l_v398_1("${~}   Speed##PITCH"), -50, 50, 20, 0.1);
                v541.yaw = v540:combo("Yaw", v543);
                v541.yaw_left = v540:slider(l_v398_1("${~}   Yaw Left##YAW"), -180, 180, 0, nil, "\194\176");
                v541.yaw_right = v540:slider(l_v398_1("${~}   Yaw Right##YAW"), -180, 180, 0, nil, "\194\176");
                v541.yaw_offset = v540:slider(l_v398_1("${~}   Yaw Offset##YAW"), 0, 360, 0, nil, "\194\176");
                v541.yaw_speed = v540:slider(l_v398_1("${~}   Yaw Speed##YAW"), -50, 50, 20, 0.1);
                v541.yaw_modifier = v540:combo(l_v398_1("${~}   Modifier##MOD"), v544);
                v541.modifier_offset = v540:slider(l_v398_1("${~}   Degree##MOD"), -180, 180, 0, nil, "\194\176");
                v541.delay = v540:slider(l_v398_1("${~}   Delay##MOD"), 1, 14, 1, nil, v546);
                v541.random_delay = v541.delay:create():slider("Random ticks", 0, 14, 0, nil, v548);
                v541.force_target_yaw = v540:switch("Force Target Yaw");
                local v549 = nil;
                local function v556(v550)
                    -- upvalues: v541 (ref)
                    local v551 = v550:get();
                    local v552 = v551 == "Static";
                    local v553 = v551 == "Jitter";
                    local v554 = v551 == "Random";
                    local v555 = v551 == "Spin";
                    v541.pitch_offset_1:visibility(v553 or v554 or v555 or v552);
                    v541.pitch_offset_2:visibility(v553 or v554 or v555);
                    v541.pitch_speed:visibility(v555);
                end;
                local function v559(v557)
                    -- upvalues: v541 (ref)
                    local v558 = v557:get() ~= "Off";
                    v541.modifier_offset:visibility(v558);
                    v541.delay:visibility(v558);
                end;
                do
                    local l_v556_0, l_v559_0 = v556, v559;
                    local function v567(v562)
                        -- upvalues: v541 (ref), l_v559_0 (ref)
                        local v563 = v562:get();
                        local v564 = v563 == "Off";
                        local v565 = v563 == "Spin";
                        local v566 = v563 == "Left/Right";
                        v541.yaw_left:visibility(v566);
                        v541.yaw_right:visibility(v566);
                        v541.yaw_offset:visibility(not v564 and not v566);
                        v541.yaw_speed:visibility(v565);
                        v541.yaw_modifier:visibility(not v564);
                        if not v564 then
                            v541.yaw_modifier:set_callback(l_v559_0, true);
                        else
                            v541.yaw_modifier:unset_callback(l_v559_0);
                        end;
                        if v564 then
                            v541.modifier_offset:visibility(false);
                            v541.delay:visibility(false);
                        end;
                    end;
                    local function v570(v568)
                        -- upvalues: v541 (ref), l_v556_0 (ref), v567 (ref), l_v559_0 (ref)
                        local v569 = v568:get();
                        if not v569 then
                            v541.pitch_offset_1:visibility(false);
                            v541.pitch_offset_2:visibility(false);
                            v541.pitch_speed:visibility(false);
                            v541.yaw_left:visibility(false);
                            v541.yaw_right:visibility(false);
                            v541.yaw_offset:visibility(false);
                            v541.yaw_speed:visibility(false);
                            v541.yaw_modifier:visibility(false);
                            v541.modifier_offset:visibility(false);
                            v541.delay:visibility(false);
                        end;
                        if v569 then
                            v541.pitch:set_callback(l_v556_0, true);
                            v541.yaw:set_callback(v567, true);
                        else
                            v541.pitch:unset_callback(l_v556_0);
                            v541.yaw:unset_callback(v567);
                            v541.yaw_modifier:unset_callback(l_v559_0);
                        end;
                        v541.pitch:visibility(v569);
                        v541.yaw:visibility(v569);
                        v541.force_target_yaw:visibility(v569);
                    end;
                    v541.enabled:set_callback(v570, true);
                end;
                v541.flick_enabled = v540:switch("Defensive Flick");
                v541.flick_mode = v540:combo("Mode", {
                    [1] = "Default",
                    [2] = "Silent"
                });
                v541.flick_pitch = v540:slider("Pitch", -89, 89, 0);
                v541.flick_yaw = v540:slider("Yaw", 0, 180, 120);
                v541.flick_yaw_random = v541.flick_yaw:create():slider("Yaw Random", 0, 180, 0);
                v541.flick_limit = v540:slider("Limit", 0, 60, 60);
                v541.flick_speed = v540:slider("Speed", 2, 10, 7);
                v541.flick_speed_random = v541.flick_speed:create():slider("Speed Random", 0, 8, 0);
                v549 = nil;
                v556 = function(v571)
                    -- upvalues: v541 (ref)
                    local v572 = v571:get();
                    v541.flick_mode:visibility(v572);
                    v541.flick_pitch:visibility(v572);
                    v541.flick_yaw:visibility(v572);
                    v541.flick_limit:visibility(v572);
                    v541.flick_speed:visibility(v572);
                end;
                v541.flick_enabled:set_callback(v556, true);
                return v541;
            end;
            v500 = function(v573, v574)
                v574.record = v573:value("record", "[]");
                v574.inverse_inverter = v573:switch("Inverse Inverter");
                return v574;
            end;
            for v575 = 1, #l_v476_0 do
                local v576 = l_v476_0[v575];
                local v577 = string.format("##ANGLES_%s", v576);
                local v578 = string.format("##DEFENSIVE_%s", v576);
                local v579 = string.format("##RECORDER_%s", v576);
                local v580 = v29.create("~", v577, v395);
                local v581 = v29.create("~", v578, v395);
                local v582 = v29.create("~", v579, v395);
                do
                    local l_v576_0 = v576;
                    local function v588(v584)
                        -- upvalues: l_v576_0 (ref)
                        local v585 = string.format("##%s", l_v576_0);
                        local _, v587 = string.find(v584[2], "##");
                        if v587 ~= nil then
                            v585 = v585 .. string.sub(v584[2], v587 + 1);
                        end;
                        v584[2] = v584[2] .. v585;
                    end;
                    local v589 = {};
                    l_state_0:set_callback(v588);
                    v580:set_callback(v588);
                    v581:set_callback(v588);
                    v582:set_callback(v588);
                    v589.mode = l_state_0:combo("Mode", {
                        [1] = "Builder",
                        [2] = "Recorder"
                    });
                    v589.mode:set_callback(v478);
                    if l_v576_0 ~= "Shared" then
                        l_state_0:set_flag(v29.group_flags.callbacks, false);
                        v589.enabled = l_state_0:switch(string.format("\a{Link Active}Allow %s", l_v576_0:lower()));
                        l_state_0:set_flag(v29.group_flags.callbacks, true);
                        v589.enabled:set_callback(v478);
                    end;
                    if l_v576_0 == "On use" then
                        v589.bomb_e_fix = l_state_0:switch("Bomb E Fix");
                    end;
                    v589.angles = v480(v580, {});
                    if l_v576_0 ~= "Fakelag" then
                        v589.defensive = v498(v581, {});
                    end;
                    v589.recorder = v500(v582, {});
                    l_state_0:unset_callback(v588);
                    v580:unset_callback(v588);
                    v581:unset_callback(v588);
                    v582:unset_callback(v588);
                    l_v475_0[l_v576_0] = v589;
                    l_v477_0[l_v576_0] = {
                        angles = v580,
                        defensive = v581,
                        recorder = v582
                    };
                    v31.add(v577, v580, "AA");
                    v31.add(v578, v581, "AA");
                    v31.add(v579, v582, "AA");
                end;
            end;
            v502 = nil;
            v466:set_callback(v478);
            v469.enabled:set_callback(v478);
            v469.mode:set_callback(v478);
            l_v475_0.state:set_callback(v478);
            v478();
            v469.builder = l_v475_0;
        end;
        v469.recorder = {
            sequence_list = l_l_recorder_0_0:list("##SEQUENCE_LIST", {}),
            set_start_button = l_l_recorder_0_0:button(v418("Set Start", 52), nil, true),
            set_end_button = l_l_recorder_0_0:button(v418("Set End", 53), nil, true),
            save_button = l_l_recorder_0_0:button(v418("Save", 57), nil, true),
            import_button = l_l_recorder_0_0:button(v418("Import", 53), nil, true)
        };
        v469.presets = {
            list = l_l_presets_0_0:list("##PRESET_LIST", {
                [1] = "Empty"
            }),
            name = l_l_presets_0_0:input("##PRESET_NAME", ""),
            load = l_l_presets_0_0:button(v418("\a{Link Active}Load", 12), nil, true),
            save = l_l_presets_0_0:button(v418("Save", 12), nil, true),
            delete = l_l_presets_0_0:button(v418("\aCD6060FFDelete", 8), nil, true),
            import = l_l_presets_0_0:button(v418("Import", 19), nil, true),
            export = l_l_presets_0_0:button(v418("Export", 20), nil, true)
        };
        v478 = {};
        v480 = {
            enabled = l_l_settings_0_0:switch("Anti-Bruteforce")
        };
        local v590 = v480.enabled:create();
        v480.refresh_modifier = v590:combo("Refresh Modifier", {
            [1] = "Off",
            [2] = "Adaptive",
            [3] = "Increase",
            [4] = "Decrease"
        });
        v480.refresh_offset = v590:switch("Refresh Offset");
        v480.enforce_delay = v590:switch("Enforce Delay Period");
        v480.duration = v590:slider("Duration", 0, 100, 0, 0.1, function(v591)
            return v591 == 0 and "Inf." or v591 * 0.1 .. "s";
        end);
        v258.push(2, v480.enabled);
        v478.antibrute = v480;
        v590 = {};
        local v592 = {
            [1] = "With Knife",
            [2] = "With Taser"
        };
        if not v258.is_locked(1) then
            table.insert(v592, "Above Enemy");
            table.insert(v592, "Far from Enemy");
        end;
        v590.select = l_l_settings_0_0:selectable("Safe Head", v592);
        v258.push(2, v590.select, {});
        v478.safe_head = v590;
        v592 = {
            select = l_l_settings_0_0:combo("Manual Yaw", {
                [1] = "Off",
                [2] = "Left",
                [3] = "Right",
                [4] = "Backward",
                [5] = "Forward"
            })
        };
        local v593 = v592.select:create();
        v592.disable_yaw_modifiers = v593:switch("Disable Yaw Modifiers");
        v592.body_freestanding = v593:switch("Body Freestanding");
        v478.manual_yaw = v592;
        v593 = {
            enabled = l_l_settings_0_0:switch("Freestanding")
        };
        local v594 = v593.enabled:create();
        v593.disablers = v594:selectable("Disablers", {
            [1] = "Standing",
            [2] = "Running",
            [3] = "Slow motion",
            [4] = "Crouching",
            [5] = "Air"
        });
        v593.disable_yaw_modifiers = v594:switch("Disable Yaw Modifiers");
        v593.body_freestanding = v594:switch("Body Freestanding");
        v478.freestanding = v593;
        v478.edge_yaw = {
            enabled = l_l_settings_0_0:switch("Edge Yaw")
        };
        v478.invert_flick = {
            enabled = l_l_settings_0_0:switch("Invert Flick")
        };
        local v595 = {
            value = l_l_settings_0_0:slider("Roll", -45, 45, 0, nil, "\194\176")
        };
        local v596 = v595.value:create();
        v595.change_on_fakelag = v596:switch("Change on Fakelag");
        v595.fakelag_value = v596:slider("Fakelag Roll", -45, 45, 0, nil, "\194\176");
        local _ = nil;
        do
            local l_v595_0 = v595;
            local function v600(v599)
                -- upvalues: l_v595_0 (ref)
                l_v595_0.fakelag_value:visibility(v599:get());
            end;
            l_v595_0.change_on_fakelag:set_callback(v600, true);
            v258.push(2, l_v595_0.value, 0);
            v478.roll = l_v595_0;
            v469.settings = v478;
        end;
        v384.antiaim = v469;
    end;
    l_main_0 = {};
    l_state_0 = v459.ragebot;
    v31.add("##RAGEBOT", l_state_0, "AA");
    l_settings_0 = {};
    l_presets_0 = {
        [1] = "Higher than you",
        [2] = "Lower than you",
        [3] = "Lethal",
        [4] = "After X misses",
        [5] = "HP lower than X"
    };
    l_settings_0.enabled = l_state_0:switch("Aimtools");
    l_recorder_0 = v29.cast(l_settings_0.enabled:create());
    l_settings_0.flag = l_recorder_0:switch("Draw Flags");
    l_settings_0.weapon = l_recorder_0:combo("Weapon", v151.aimtools);
    v475 = nil;
    v476 = function(v601, v602)
        v601.conditions:visibility(v602);
        v601.max_misses:visibility(v602 and v601.conditions:get("After X misses"));
        v601.lower_hp:visibility(v602 and v601.conditions:get("HP lower than X"));
    end;
    do
        local l_l_state_0_0, l_l_settings_0_1, l_l_presets_0_1, l_l_recorder_0_1 = l_state_0, l_settings_0, l_presets_0, l_recorder_0;
        do
            local l_l_l_presets_0_1_0 = l_l_presets_0_1;
            v477 = function(v608, v609)
                -- upvalues: l_l_l_presets_0_1_0 (ref)
                local v610 = v608.conditions:get();
                v608.conditions:visibility(v609);
                for v611 = 1, #l_l_l_presets_0_1_0 do
                    local v612 = l_l_l_presets_0_1_0[v611];
                    local v613 = v608[v612];
                    if v613 ~= nil then
                        local v614 = v609 and v610 == v612;
                        v613.enabled:visibility(v614);
                        if not v613.enabled:get() then
                            v614 = false;
                        end;
                        if v613.max_misses ~= nil then
                            v613.max_misses:visibility(v614);
                        end;
                        if v613.lower_hp ~= nil then
                            v613.lower_hp:visibility(v614);
                        end;
                        if v613.value ~= nil then
                            v613.value:visibility(v614);
                        end;
                    end;
                end;
            end;
            do
                local l_v476_1, l_v477_1, l_v478_0, l_v480_1 = v476, v477, v478, v480;
                l_v478_0 = function(v619, v620)
                    -- upvalues: l_v476_1 (ref), l_v477_1 (ref)
                    l_v476_1(v619.prefer_body, v620);
                    l_v476_1(v619.force_safe, v620);
                    l_v477_1(v619.hit_chance, v620);
                    l_v477_1(v619.multipoints, v620);
                end;
                l_v480_1 = function(v621, v622)
                    -- upvalues: l_l_settings_0_1 (ref), l_v478_0 (ref)
                    local v623 = v622:get();
                    for v624 = 1, #v621 do
                        local v625 = v621[v624];
                        local v626 = l_l_settings_0_1[v625];
                        local v627 = v625 == v623;
                        l_v478_0(v626, v627);
                    end;
                end;
                v475 = function()
                    -- upvalues: l_v480_1 (ref), v151 (ref), l_l_settings_0_1 (ref)
                    l_v480_1(v151.aimtools, l_l_settings_0_1.weapon);
                end;
            end;
            do
                local l_l_l_recorder_0_1_0, l_v475_1, l_v476_2, l_v477_2 = l_l_recorder_0_1, v475, v476, v477;
                l_v476_2 = function(v632)
                    -- upvalues: l_l_l_recorder_0_1_0 (ref), l_l_l_presets_0_1_0 (ref), l_v475_1 (ref)
                    local v633 = {};
                    local function v635(v634)
                        -- upvalues: v632 (ref)
                        v634[2] = v634[2] .. string.format("##%s", v632);
                    end;
                    l_l_l_recorder_0_1_0:set_callback(v635);
                    v633.conditions = l_l_l_recorder_0_1_0:selectable(v632, l_l_l_presets_0_1_0);
                    v633.max_misses = l_l_l_recorder_0_1_0:slider("\tMax Misses", 1, 10, 2);
                    v633.lower_hp = l_l_l_recorder_0_1_0:slider("\tLower HP", 0, 100, 80);
                    v633.conditions:set_callback(l_v475_1);
                    l_l_l_recorder_0_1_0:unset_callback(v635);
                    return v633;
                end;
                l_v477_2 = function(v636, v637, v638, v639)
                    -- upvalues: l_l_l_recorder_0_1_0 (ref), l_l_l_presets_0_1_0 (ref), l_v475_1 (ref)
                    local v640 = {};
                    local function v642(v641)
                        -- upvalues: v636 (ref)
                        v641[2] = v641[2] .. string.format("##%s", v636);
                    end;
                    l_l_l_recorder_0_1_0:set_callback(v642);
                    v640.conditions = l_l_l_recorder_0_1_0:combo(v636, l_l_l_presets_0_1_0);
                    for v643 = 1, #l_l_l_presets_0_1_0 do
                        local v644 = l_l_l_presets_0_1_0[v643];
                        do
                            local l_v644_0 = v644;
                            local function v647(v646)
                                -- upvalues: l_v644_0 (ref)
                                v646[2] = v646[2] .. string.format("##%s", l_v644_0);
                            end;
                            l_l_l_recorder_0_1_0:set_callback(v647);
                            local v648 = {
                                enabled = l_l_l_recorder_0_1_0:switch("\tEnabled")
                            };
                            if l_v644_0 == "After X misses" then
                                v648.max_misses = l_l_l_recorder_0_1_0:slider("\tMax Misses", 1, 10, 2);
                            end;
                            if l_v644_0 == "HP lower than X" then
                                v648.lower_hp = l_l_l_recorder_0_1_0:slider("\tLower HP", 0, 100, 80);
                            end;
                            v648.value = l_l_l_recorder_0_1_0:slider("\tValue", v637, v638, v639);
                            l_l_l_recorder_0_1_0:unset_callback(v647);
                            v648.enabled:set_callback(l_v475_1);
                            v640[l_v644_0] = v648;
                        end;
                    end;
                    l_l_l_recorder_0_1_0:unset_callback(v642);
                    v640.conditions:set_callback(l_v475_1);
                    return v640;
                end;
                v478 = function(_, v650)
                    -- upvalues: l_v476_2 (ref), l_v477_2 (ref)
                    v650.prefer_body = l_v476_2("Prefer Body Aim");
                    v650.force_safe = l_v476_2("Force Safe Point");
                    v650.hit_chance = l_v477_2("Hit Chance", 0, 100, 50);
                    v650.multipoints = l_v477_2("Multipoints", 0, 100, 50);
                    return v650;
                end;
                for v651 = 1, #v151.aimtools do
                    local v652 = v151.aimtools[v651];
                    do
                        local l_v652_0 = v652;
                        local function v658(v654)
                            -- upvalues: l_v652_0 (ref)
                            local v655 = string.format("##%s", l_v652_0);
                            local _, v657 = string.find(v654[2], "##");
                            if v657 ~= nil then
                                v655 = v655 .. string.sub(v654[2], v657 + 1);
                            end;
                            v654[2] = v654[2] .. v655;
                        end;
                        l_l_l_recorder_0_1_0:set_callback(v658);
                        l_l_settings_0_1[l_v652_0] = v478(l_v652_0, {});
                        l_l_l_recorder_0_1_0:unset_callback(v658);
                    end;
                end;
                v258.push(1, l_l_settings_0_1.enabled);
                l_l_settings_0_1.weapon:set_callback(l_v475_1, true);
            end;
            l_main_0.aimtools = l_l_settings_0_1;
        end;
        l_l_presets_0_1 = {
            enabled = l_l_state_0_0:switch("AI Peek")
        };
        l_l_recorder_0_1 = l_l_presets_0_1.enabled:create();
        l_l_presets_0_1.simulation = l_l_recorder_0_1:slider("Simulation", 25, 35, 28, 0.01, "s");
        l_l_presets_0_1.rate_limit = l_l_recorder_0_1:slider("Rate Limit", 0, 30, 2, 0.01, "s");
        l_l_presets_0_1.hit_chance = l_l_recorder_0_1:slider("Hit Chance", 0, 100, 35, nil, function(v659)
            return v659 == 0 and "Def." or v659 .. "%";
        end);
        l_l_presets_0_1.unsafety = l_l_recorder_0_1:switch("Unsafety", false);
        l_l_presets_0_1.dev_mode = l_l_recorder_0_1:switch("Dev Mode", false);
        l_l_presets_0_1.range = l_l_recorder_0_1:slider("Range", 15, 25, 20, nil, "t");
        l_l_presets_0_1.retreat = l_l_recorder_0_1:slider("Retreat", 15, 30, 25, nil, "u");
        l_l_presets_0_1.weapons = l_l_recorder_0_1:selectable("Weapons", {
            [1] = "SSG-08",
            [2] = "Pistols",
            [3] = "Deagle"
        });
        l_l_presets_0_1.hitboxes = l_l_recorder_0_1:selectable("Hitboxes", {
            [1] = "Head",
            [2] = "Chest",
            [3] = "Stomach",
            [4] = "Arms",
            [5] = "Legs"
        });
        l_l_presets_0_1.color = l_l_recorder_0_1:color_picker("Color", color(200, 0, 0, 255));
        v458(l_l_presets_0_1.weapons);
        v458(l_l_presets_0_1.hitboxes);
        v258.push(1, l_l_presets_0_1.enabled);
        v475 = nil;
        v476 = function(v660)
            -- upvalues: l_l_presets_0_1 (ref)
            local v661 = v660:get();
            l_l_presets_0_1.range:visibility(v661);
            l_l_presets_0_1.retreat:visibility(v661);
        end;
        l_l_presets_0_1.dev_mode:set_callback(v476, true);
        l_main_0.ai_peek = l_l_presets_0_1;
        l_l_recorder_0_1 = {
            enabled = l_l_state_0_0:switch("Logs")
        };
        v475 = l_l_recorder_0_1.enabled:create();
        l_l_recorder_0_1.output = v475:selectable("Output", {
            [1] = "Events",
            [2] = "Render",
            [3] = "Console"
        });
        l_l_recorder_0_1.hit_color = v475:color_picker("Hit Color", color(163, 211, 80, 255));
        l_l_recorder_0_1.miss_color = v475:color_picker("Miss Color", color(240, 191, 86, 255));
        l_l_recorder_0_1.background_color = v475:color_picker("Background Color", color(22, 22, 22, 255));
        l_l_recorder_0_1.logo = v475:combo("Logo", {
            [1] = "Off",
            [2] = "!",
            [3] = "Icon",
            [4] = "Text"
        });
        l_l_recorder_0_1.glow = v475:slider("Glow", 0, 150, 100, nil, "%");
        l_l_recorder_0_1.offset = v475:slider("Offset", 1, 144, 60, 5, "px");
        l_l_recorder_0_1.duration = v475:slider("Duration", 1, 8, 5, nil, "s.");
        v476 = nil;
        v477 = function(v662)
            -- upvalues: l_l_recorder_0_1 (ref)
            local v663 = v662:get("Render");
            l_l_recorder_0_1.background_color:visibility(v663);
            l_l_recorder_0_1.logo:visibility(v663);
            l_l_recorder_0_1.glow:visibility(v663);
            l_l_recorder_0_1.offset:visibility(v663);
            l_l_recorder_0_1.duration:visibility(v663);
        end;
        l_l_recorder_0_1.output:set_callback(v477, true);
        l_main_0.logs = l_l_recorder_0_1;
        v475 = {
            enabled = l_l_state_0_0:switch("Dormant Aimbot")
        };
        v476 = v475.enabled:create();
        v475.hitboxes = v476:selectable("Hitboxes", {
            [1] = "Head",
            [2] = "Chest",
            [3] = "Stomach",
            [4] = "Legs"
        });
        v475.alpha_modifier = v476:slider("Alpha Modifier", 0, 90, 80, nil, "%");
        v475.minimum_damage = v476:slider("Minimum Damage", 0, 130, 0, nil, function(v664)
            if v664 == 0 then
                return "Def.";
            elseif v664 > 100 then
                return "+" .. v664 - 100;
            else
                return;
            end;
        end);
        v458(v475.hitboxes);
        v258.push(1, v475.enabled);
        l_main_0.dormant_aimbot = v475;
        v476 = nil;
        v466:set_callback(function(v665)
            -- upvalues: l_l_state_0_0 (ref)
            local v666 = v665:get() == 2;
            l_l_state_0_0:visibility(v666);
        end, true);
        v384.ragebot = l_main_0;
    end;
    l_state_0 = {};
    l_settings_0 = v459.visuals;
    v31.add("##VISUALS", l_settings_0, "VISUALS");
    l_presets_0 = {};
    l_recorder_0 = {
        [1] = "5:4",
        [2] = "4:3",
        [3] = "16:9",
        [4] = "16:10"
    };
    v475 = {
        ["4:3"] = 133,
        ["5:4"] = 125,
        ["16:10"] = 160,
        ["16:9"] = 177
    };
    v476 = {};
    for v667 = 1, #l_recorder_0 do
        local v668 = l_recorder_0[v667];
        v476[v475[v668]] = v668;
    end;
    l_presets_0.enabled = l_settings_0:switch("Aspect Ratio");
    v477 = l_presets_0.enabled:create();
    do
        local l_l_settings_0_2, l_l_presets_0_2, l_v475_2, l_v476_3, l_v477_3, l_v478_1 = l_settings_0, l_presets_0, v475, v476, v477, v478;
        do
            local l_l_v476_3_0 = l_v476_3;
            l_l_presets_0_2.value = l_v477_3:slider("##VALUE", 1, 200, 177, 0.01, function(v676)
                -- upvalues: l_l_v476_3_0 (ref)
                return l_l_v476_3_0[v676] or nil;
            end);
            for v677 = 1, #l_recorder_0 do
                local v678 = l_recorder_0[v677];
                local v679 = l_v475_2[v678];
                do
                    local l_v679_0 = v679;
                    local function v681()
                        -- upvalues: l_l_presets_0_2 (ref), l_v679_0 (ref)
                        l_l_presets_0_2.value:set(l_v679_0);
                    end;
                    l_v477_3:button(v418(v678, (math.ceil(#v678 * 1.34))), v681, true);
                end;
            end;
            l_state_0.aspect_ratio = l_l_presets_0_2;
        end;
        l_recorder_0 = {
            enabled = l_l_settings_0_2:switch("Viewmodel")
        };
        l_v475_2 = l_recorder_0.enabled:create();
        l_recorder_0.fov = l_v475_2:slider("FOV", 2000, 17000, 6800, 0.01);
        l_recorder_0.offset_x = l_v475_2:slider("X", -2000, 2000, 0, 0.01);
        l_recorder_0.offset_y = l_v475_2:slider("Y", -2000, 2000, 0, 0.01);
        l_recorder_0.offset_z = l_v475_2:slider("Z", -2000, 2000, 0, 0.01);
        l_recorder_0.opposite_knife_hand = l_v475_2:switch("Opposite Knife Hand");
        l_state_0.viewmodel = l_recorder_0;
        l_v475_2 = {
            enabled = l_l_settings_0_2:switch("Indicators")
        };
        l_v476_3 = l_v475_2.enabled:create();
        l_v475_2.style = l_v476_3:list("Style", {
            [1] = "Stars",
            [2] = "Pixel"
        });
        l_v475_2.offset = l_v476_3:slider("Offset", 0, 200, 32, nil, "px");
        l_v475_2.accent_color = l_v476_3:color_picker("Accent", color(172, 167, 209, 255));
        l_v475_2.secondary_color = l_v476_3:color_picker("Secondary", color(255, 255, 255, 255));
        l_state_0.indicators = l_v475_2;
        l_v476_3 = {
            enabled = l_l_settings_0_2:switch("Solus UI")
        };
        l_v477_3 = l_v476_3.enabled:create();
        l_v476_3.color = l_v477_3:color_picker("Color", color(172, 167, 209, 50));
        l_v476_3.select = l_v477_3:listable("##SELECT", {
            [1] = "Watermark",
            [2] = "Spectators",
            [3] = "Hotkey List",
            [4] = "Anti-aimbot indication",
            [5] = "Frequency update information"
        });
        l_v476_3.only_key_state = l_v477_3:switch("Only Key State", false);
        v458(l_v476_3.select);
        l_v478_1 = nil;
        v480 = function(v682)
            -- upvalues: l_v476_3 (ref)
            l_v476_3.only_key_state:visibility(v682:get("Hotkey List"));
        end;
        l_v476_3.select:set_callback(v480, true);
        l_state_0.solus_ui = l_v476_3;
        l_v477_3 = {
            enabled = l_l_settings_0_2:switch("Watermark")
        };
        l_v478_1 = l_v477_3.enabled:create();
        l_v477_3.style = l_v478_1:listable("Style", {
            [1] = "Branded",
            [2] = "Corner"
        });
        l_v477_3.color = l_v478_1:color_picker("Color", color(172, 167, 209, 255));
        v458(l_v477_3.style, {
            [1] = "Branded"
        });
        l_state_0.watermark = l_v477_3;
        l_v478_1 = {
            enabled = l_l_settings_0_2:switch("Manual Arrows")
        };
        v480 = l_v478_1.enabled:create();
        l_v478_1.style = v480:list("Style", {
            [1] = "Invictus",
            [2] = "Teamskeet",
            [3] = "Modern",
            [4] = "Ambani"
        });
        l_v478_1.animate_scope = v480:switch("Animate Scope", true);
        l_v478_1.dynamic_mode = v480:switch("Dynamic Mode", true);
        l_v478_1.offset = v480:slider("Offset", 5, 150, 40, nil, "px");
        l_v478_1.accent_color = v480:color_picker("Accent", color(172, 167, 209, 255));
        l_v478_1.secondary_color = v480:color_picker("Secondary", color(255, 255, 255, 255));
        local v683 = nil;
        local function v686(v684)
            -- upvalues: l_v478_1 (ref)
            local v685 = v684:get();
            l_v478_1.animate_scope:visibility(v685 == 3);
            l_v478_1.dynamic_mode:visibility(v685 == 1 or v685 == 4);
        end;
        l_v478_1.style:set_callback(v686, true);
        l_state_0.manual_arrows = l_v478_1;
        v480 = {
            enabled = l_l_settings_0_2:switch("Custom Scope")
        };
        v683 = v480.enabled:create();
        v480.offset = v683:slider("Offset", 0, 500, 10, nil, "px");
        v480.position = v683:slider("Position", 0, 500, 105, nil, "px");
        v480.thickness = v683:slider("Thickness", 1, 10, 1, nil, "px");
        v480.accent_color = v683:color_picker("Accent", color(255, 255, 255, 255));
        v480.secondary_color = v683:color_picker("Secondary", color(255, 255, 255, 0));
        v480.extra_options = v683:selectable("Extra Options", {
            [1] = "Rotate Angle",
            [2] = "Dynamic Offset"
        });
        v480.exclude_lines = v683:selectable("Exclude Lines", {
            [1] = "Left",
            [2] = "Top",
            [3] = "Right",
            [4] = "Bottom"
        });
        l_state_0.custom_scope = v480;
        v683 = {
            enabled = l_l_settings_0_2:switch("Damage Indicator")
        };
        v686 = v683.enabled:create();
        v683.if_override = v686:switch("If override");
        v683.font = v686:combo("Font", {
            [1] = "Default",
            [2] = "Alternative"
        });
        v683.offset = v686:slider("Offset", 2, 8, 2, nil, "px");
        v683.active_color = v686:color_picker("Active Color", color(172, 167, 209, 255));
        v683.inactive_color = v686:color_picker("Inactive Color", color(255, 255, 255, 100));
        local v687 = nil;
        local function v689(v688)
            -- upvalues: v683 (ref)
            v683.inactive_color:visibility(not v688:get());
        end;
        v683.if_override:set_callback(v689, true);
        l_state_0.damage_indicator = v683;
        v686 = {
            enabled = l_l_settings_0_2:switch("Break LC Indicator")
        };
        v258.push(1, v686.enabled);
        l_state_0.break_lc_indicator = v686;
        v687 = {
            enabled = l_l_settings_0_2:switch("Velocity Warning")
        };
        v689 = v687.enabled:create();
        v687.color_accent = v689:color_picker("Accent Color", color(255, 255, 255, 200));
        v687.color_secondary = v689:color_picker("Secondary Color", color(150, 150, 150, 255));
        l_state_0.velocity_warning = v687;
        v689 = {
            enabled = l_l_settings_0_2:switch("Gamesense Indicators")
        };
        local v690 = v689.enabled:create();
        v689.spectator_list = v690:switch("Spectator List", true);
        v689.feature_list = v690:listable("Indicators", {
            [1] = "Hit/Miss",
            [2] = "Dormant Aimbot",
            [3] = "Damage Override",
            [4] = "Hitchance Override",
            [5] = "Lag Compensation",
            [6] = "Hitbox Override",
            [7] = "Fake Latency",
            [8] = "Fake Angles",
            [9] = "Fake Duck",
            [10] = "Body Aim",
            [11] = "Safe Points",
            [12] = "Freestanding",
            [13] = "Bomb Info",
            [14] = "Hide Shots",
            [15] = "Double Tap"
        });
        v458(v689.feature_list, {
            [1] = "Damage Override",
            [2] = "Fake Latency",
            [3] = "Fake Duck",
            [4] = "Body Aim",
            [5] = "Safe Points",
            [6] = "Freestanding",
            [7] = "Bomb Info",
            [8] = "Hide Shots",
            [9] = "Double Tap"
        });
        l_state_0.gamesense_indicators = v689;
        v690 = {
            enabled = l_l_settings_0_2:switch("Grenade Radius")
        };
        local v691 = v690.enabled:create();
        v690.molotov = v691:switch("Molotov", true);
        v690.molotov_color = v690.molotov:color_picker(color(245, 90, 90, 255));
        v690.smoke = v691:switch("Smoke", true);
        v690.smoke_color = v690.smoke:color_picker(color(130, 130, 255, 255));
        v258.push(1, v690.enabled);
        local v692 = nil;
        local function v694(v693)
            -- upvalues: v690 (ref)
            if not v693:get() and not v690.smoke:get() then
                v690.smoke:set(true);
            end;
        end;
        local function v696(v695)
            -- upvalues: v690 (ref)
            if not v695:get() and not v690.molotov:get() then
                v690.molotov:set(true);
            end;
        end;
        v690.molotov:set_callback(v694);
        v690.smoke:set_callback(v696);
        l_state_0.grenade_radius = v690;
        v691 = {
            label = l_l_settings_0_2:label("Static Watermark")
        };
        v692 = v691.label:create();
        v691.style = v692:list("Style", {
            [1] = "Classic",
            [2] = "Modern"
        });
        v691.position = v692:combo("Position", {
            [1] = "Bottom",
            [2] = "Left",
            [3] = "Right"
        });
        v691.remove_spaces = v692:switch("Remove Spaces");
        v691.color = v692:color_picker("Color", color(142, 165, 229, 255));
        v692 = nil;
        v694 = function()
            -- upvalues: l_v477_3 (ref), l_v475_2 (ref), l_v476_3 (ref), v691 (ref)
            local v697 = l_v477_3.enabled:get() or l_v475_2.enabled:get();
            local v698 = l_v476_3.enabled:get() and l_v476_3.select:get("Watermark");
            v691.label:disabled(v697 or v698);
        end;
        l_v477_3.enabled:set_callback(v694);
        l_v475_2.enabled:set_callback(v694);
        l_v476_3.enabled:set_callback(v694);
        l_v476_3.select:set_callback(v694);
        v694();
        l_state_0.static_watermark = v691;
        v692 = nil;
        v466:set_callback(function(v699)
            -- upvalues: l_l_settings_0_2 (ref)
            local v700 = v699:get() == 3;
            l_l_settings_0_2:visibility(v700);
        end, true);
        v384.visuals = l_state_0;
    end;
    l_settings_0 = {};
    l_presets_0 = v459.misc;
    v31.add("##MISC", l_presets_0, "MISC");
    l_settings_0.clantag = {
        enabled = l_presets_0:switch("Clantag")
    };
    l_settings_0.trashtalk = {
        enabled = l_presets_0:switch("Trashtalk")
    };
    v476 = {
        enabled = l_presets_0:switch("Fast Ladder")
    };
    v258.push(2, v476.enabled);
    l_settings_0.fast_ladder = v476;
    v477 = {
        enabled = l_presets_0:switch("Edge Stop")
    };
    v258.push(1, v477.enabled);
    l_settings_0.edge_stop = v477;
    v478 = {
        enabled = l_presets_0:switch("Collision Air Duck")
    };
    v258.push(1, v478.enabled);
    l_settings_0.collision_air_duck = v478;
    v480 = {
        enabled = l_presets_0:switch("No Fall Damage")
    };
    v258.push(2, v480.enabled);
    l_settings_0.no_fall_damage = v480;
    local v701 = {
        enabled = l_presets_0:switch("Super Toss")
    };
    v258.push(2, v701.enabled);
    l_settings_0.super_toss = v701;
    local v702 = {
        enabled = l_presets_0:switch("Grenade Release")
    };
    v702.damage = v702.enabled:create():slider("Damage", 1, 50, 35, nil, "hp");
    v258.push(2, v702.enabled);
    l_settings_0.grenade_release = v702;
    local v703 = {
        enabled = l_presets_0:switch("Fps Optimize")
    };
    local v704 = v703.enabled:create();
    v703.always_on = v704:switch("Always on");
    v703.detections = v704:selectable("Detections", {
        [1] = "Peeking",
        [2] = "Hit Flag"
    });
    v703.select = v704:selectable("Optimizations", {
        [1] = "Fog",
        [2] = "Blood",
        [3] = "Bloom",
        [4] = "Decals",
        [5] = "Shadows",
        [6] = "Sprites",
        [7] = "Particles",
        [8] = "Ropes",
        [9] = "Dynamic lights",
        [10] = "Map details",
        [11] = "Weapon effects",
        [12] = "Teammates"
    });
    v458(v703.detections);
    v458(v703.select, {
        [1] = "Blood",
        [2] = "Decals",
        [3] = "Sprites",
        [4] = "Ropes",
        [5] = "Dynamic lights",
        [6] = "Weapon effects"
    });
    local v705 = nil;
    do
        local l_l_presets_0_3, l_v703_0, l_v705_0 = l_presets_0, v703, v705;
        local function v710(v709)
            -- upvalues: l_v703_0 (ref)
            l_v703_0.detections:visibility(not v709:get());
        end;
        l_v703_0.always_on:set_callback(v710, true);
        l_settings_0.fps_optimize = l_v703_0;
        v704 = {
            enabled = l_l_presets_0_3:switch("Ping Unlocker")
        };
        v704.value = v704.enabled:create():slider("Latency", 0, 200, 0, nil, "ms");
        v258.push(2, v704.enabled);
        l_settings_0.ping_unlocker = v704;
        l_v705_0 = {
            enabled = l_l_presets_0_3:switch("Animation Breaker")
        };
        v710 = l_v705_0.enabled:create();
        l_v705_0.air_legs = v710:combo("Air Legs", {
            [1] = "Disabled",
            [2] = "Static",
            [3] = "Haram"
        });
        l_v705_0.ground_legs = v710:combo("Ground Legs", {
            [1] = "Default",
            [2] = "Static",
            [3] = "Jitter",
            [4] = "Allah",
            [5] = "Kangaroo"
        });
        l_v705_0.legs_offset_1 = v710:slider("Offset 1", 0, 100, 100);
        l_v705_0.legs_offset_2 = v710:slider("Offset 2", 0, 100, 100);
        l_v705_0.body_lean = v710:slider("Body Lean", -1, 100, -1, nil, function(v711)
            return v711 == -1 and "Off" or v711 .. "%";
        end);
        l_v705_0.pitch_on_land = v710:switch("Pitch on Land", true);
        v258.push(2, l_v705_0.enabled);
        local v712 = nil;
        local function v715(v713)
            -- upvalues: l_v705_0 (ref)
            local v714 = v713:get() == "Jitter";
            l_v705_0.legs_offset_1:visibility(v714);
            l_v705_0.legs_offset_2:visibility(v714);
        end;
        l_v705_0.ground_legs:set_callback(v715, true);
        l_settings_0.animation_breaker = l_v705_0;
        v710 = {
            label = l_l_presets_0_3:label("Fake Duck")
        };
        v710.options = v710.label:create():selectable("Options", {
            [1] = "Unlock Speed",
            [2] = "On Freezetime"
        });
        v258.push(2, v710.label);
        v258.push(2, v710.options, {});
        l_settings_0.fake_duck = v710;
        v712 = {
            label = l_l_presets_0_3:label("Nickname Generator")
        };
        v715 = v712.label:create();
        v712.input = v715:input("##INPUT");
        v712.set_button = v715:button(v418("Set", 11), nil, false);
        v712.generate_button = v715:button(v418("Generate", 5), nil, true);
        v712.reset_button = v715:button(v418("Reset", 8), nil, true);
        l_settings_0.nickname_generator = v712;
        v715 = nil;
        v466:set_callback(function(v716)
            -- upvalues: l_l_presets_0_3 (ref)
            local v717 = v716:get() == 4;
            l_l_presets_0_3:visibility(v717);
        end, true);
        v384.misc = l_settings_0;
    end;
    l_presets_0 = nil;
    l_recorder_0 = ui.get_icon("sparkles");
    l_presets_0 = v29.create("~", "##COPYRIGHT", v395):label(v10("\a{Link Active}", l_recorder_0, l_v414_0(4), v13.name, "\aDEFAULT", " \226\128\148 2025"));
end;
v394 = nil;
v394 = {};
v395 = 0;
v398 = 0;
v394.is_onground = false;
v394.is_moving = false;
v394.is_crouched = false;
v394.is_peeking = false;
v394.is_vulnerable = false;
v394.velocity2d = 0;
v394.duck_amount = 0;
v394.team_num = 0;
v394.sent_packets = 0;
v414 = function(v718, v719, v720)
    return v718 + v719 * (v720 * globals.tickinterval);
end;
do
    local l_v395_1, l_v398_2, l_v414_1, l_v418_0 = v395, v398, v414, v418;
    l_v418_0 = function(v725)
        -- upvalues: l_v414_1 (ref)
        local v726 = false;
        local v727 = false;
        local l_m_vecVelocity_0 = v725.m_vecVelocity;
        local v729 = v725:get_eye_position();
        local v730 = l_v414_1(v729, l_m_vecVelocity_0, 14);
        local v731 = entity.get_players(true);
        local v732 = entity.get_threat(true);
        for v733 = 1, #v731 do
            local v734 = v731[v733];
            if v734:is_alive() then
                if v734 == v732 then
                    v727 = true;
                else
                    local v735 = v734:get_hitbox_position(0);
                    local v736 = l_v414_1(v735, l_m_vecVelocity_0, 4);
                    local v737 = utils.trace_bullet(v725, v730, v736);
                    if v737 ~= nil and v737 > 0 then
                        v726 = true;
                        break;
                    end;
                end;
            end;
        end;
        return v726, v727;
    end;
    local function v742(v738)
        -- upvalues: l_v418_0 (ref), l_v395_1 (ref), v394 (ref)
        local v739 = entity.get_local_player();
        if v739 == nil then
            return;
        else
            local v740, v741 = l_v418_0(v739);
            l_v395_1 = v739.m_fFlags;
            v394.velocity2d = v739.m_vecVelocity:length2d();
            v394.is_peeking = v740;
            v394.is_vulnerable = v741;
            if v738.choked_commands == 0 then
                v394.duck_amount = v739.m_flDuckAmount;
                v394.sent_packets = v394.sent_packets + 1;
            end;
            v394.is_moving = v394.velocity2d > 3.63;
            v394.is_crouched = v394.duck_amount > 0;
            v394.team_num = v739.m_iTeamNum;
            return;
        end;
    end;
    local function v745(_)
        -- upvalues: l_v398_2 (ref), v394 (ref), l_v395_1 (ref)
        local v744 = entity.get_local_player();
        if v744 == nil then
            return;
        else
            l_v398_2 = v744.m_fFlags;
            v394.is_onground = bit.band(l_v395_1, 1) == 1 and bit.band(l_v398_2, 1) == 1;
            return;
        end;
    end;
    events.createmove(v742);
    events.createmove_run(v745);
end;
v395 = nil;
v395 = {};
v398 = nil;
v414 = 0;
v395.max_defensive_ticks = 0;
v395.defensive_ticks = 0;
v395.teleport_units_sqr = 0;
do
    local l_v398_3, l_v414_2, l_v418_1 = v398, v414, v418;
    l_v418_1 = function(v749)
        -- upvalues: l_v414_2 (ref), v395 (ref)
        local l_m_nTickBase_0 = v749.m_nTickBase;
        if math.abs(l_m_nTickBase_0 - l_v414_2) > 64 then
            l_v414_2 = 0;
        end;
        local v751 = 0;
        if l_v414_2 < l_m_nTickBase_0 then
            l_v414_2 = l_m_nTickBase_0;
        elseif l_m_nTickBase_0 < l_v414_2 then
            v751 = math.min(14, math.max(0, l_v414_2 - l_m_nTickBase_0 - 1));
        end;
        if v751 > 0 then
            if v395.max_defensive_ticks == 0 then
                v395.max_defensive_ticks = v751;
            end;
            v395.defensive_ticks = v751;
        else
            v395.defensive_ticks = 0;
            v395.max_defensive_ticks = 0;
        end;
    end;
    local function v754(v752, v753)
        -- upvalues: v395 (ref)
        v395.teleport_units_sqr = (v753 - v752):lengthsqr();
    end;
    local function v759(v755)
        -- upvalues: l_v398_3 (ref), v754 (ref)
        local v756 = v755:get_simulation_time();
        if v756 == nil then
            return;
        else
            local l_m_vecOrigin_0 = v755.m_vecOrigin;
            if l_v398_3 ~= nil then
                local v758 = to_ticks(v756.current - v756.old);
                if v758 < 0 or v758 > 0 and v758 <= 64 then
                    v754(l_v398_3, l_m_vecOrigin_0);
                end;
            end;
            l_v398_3 = l_m_vecOrigin_0;
            return;
        end;
    end;
    local function v761()
        -- upvalues: l_v418_1 (ref)
        local v760 = entity.get_local_player();
        if v760 == nil then
            return;
        else
            l_v418_1(v760);
            return;
        end;
    end;
    local function v763()
        -- upvalues: v759 (ref)
        local v762 = entity.get_local_player();
        if v762 == nil then
            return;
        else
            v759(v762);
            return;
        end;
    end;
    events.createmove(v761);
    events.net_update_start(v763);
end;
v398 = nil;
v398 = {};
v414 = nil;
v418 = function()
    -- upvalues: v394 (ref), v26 (ref)
    if v394.is_onground then
        if v26.antiaim.misc.slow_walk:get() then
            return "Slow motion";
        elseif not v394.is_moving then
            if v394.is_crouched then
                return "Crouching";
            else
                return "Standing";
            end;
        elseif v394.is_crouched then
            return "Move & Crouching";
        else
            return "Running";
        end;
    else
        return v394.is_crouched and "Air & Crouching" or "Air";
    end;
end;
do
    local l_v414_3, l_v418_2 = v414, v418;
    local function v766()
        -- upvalues: l_v414_3 (ref), l_v418_2 (ref)
        l_v414_3 = l_v418_2();
    end;
    v398.get = function()
        -- upvalues: l_v414_3 (ref)
        return l_v414_3;
    end;
    events.createmove(v766);
end;
v414 = nil;
v414 = {};
v418 = v28:new();
local v767 = {};
local function v771(v768)
    local l_tickcount_0 = globals.tickcount;
    local v770 = v768:get_eye_position();
    return {
        tick = l_tickcount_0,
        player = v768,
        eye_pos = v770,
        impacts = {}
    };
end;
do
    local l_v418_3, l_v767_0, l_v771_0 = v418, v767, v771;
    local function v777(v775)
        -- upvalues: l_v767_0 (ref), l_v771_0 (ref)
        local v776 = entity.get(v775.userid, true);
        if v776 == nil then
            return;
        else
            table.insert(l_v767_0, l_v771_0(v776));
            return;
        end;
    end;
    local function v783(v778)
        -- upvalues: l_v767_0 (ref)
        local v779 = entity.get(v778.userid, true);
        local v780 = entity.get(v778.attacker, true);
        if v779 == nil or v780 == nil then
            return;
        else
            for v781 = #l_v767_0, 1, -1 do
                local v782 = l_v767_0[v781];
                if v782.player == v780 then
                    v782.victim = v779;
                    v782.damage = v778.dmg_health;
                    v782.hitgroup = v778.hitgroup;
                    break;
                end;
            end;
            return;
        end;
    end;
    local function v789(v784)
        -- upvalues: l_v767_0 (ref)
        local v785 = entity.get(v784.userid, true);
        if v785 == nil then
            return;
        else
            for v786 = #l_v767_0, 1, -1 do
                local v787 = l_v767_0[v786];
                if v787.player == v785 then
                    local v788 = vector(v784.x, v784.y, v784.z);
                    table.insert(v787.impacts, v788);
                    break;
                end;
            end;
            return;
        end;
    end;
    local function v801()
        -- upvalues: l_v767_0 (ref), l_v418_3 (ref), v14 (ref)
        local v790 = entity.get_local_player();
        if v790 == nil then
            return;
        else
            local v791 = nil;
            if v790:is_alive() then
                v791 = v790:get_hitbox_position(0);
            end;
            for v792 = 1, #l_v767_0 do
                local v793 = l_v767_0[v792];
                local v794 = #v793.impacts;
                if v794 ~= 0 then
                    local l_eye_pos_0 = v793.eye_pos;
                    local v796 = v793.impacts[v794];
                    l_v418_3.player_shot:fire({
                        tick = v793.tick,
                        player = v793.player,
                        victim = v793.victim,
                        eye_pos = l_eye_pos_0,
                        end_pos = v796,
                        damage = v793.damage,
                        hitgroup = v793.hitgroup
                    });
                    if v791 ~= nil and v793.player:is_enemy() then
                        local v797 = v14.closest_ray_point(l_eye_pos_0, v796, v791, true);
                        local v798 = v791.distsqr(v791, v797);
                        if v798 <= 6400 then
                            local v799 = math.sqrt(v798);
                            l_v418_3.enemy_shot:fire({
                                tick = v793.tick,
                                distance = v799,
                                player = v793.player,
                                victim = v793.victim,
                                eye_pos = l_eye_pos_0,
                                end_pos = v796,
                                damage = v793.damage,
                                hitgroup = v793.hitgroup
                            });
                        end;
                    end;
                end;
            end;
            for v800 = 1, #l_v767_0 do
                l_v767_0[v800] = nil;
            end;
            return;
        end;
    end;
    v414.get_event_bus = function()
        -- upvalues: l_v418_3 (ref)
        return l_v418_3;
    end;
    events.weapon_fire(v777);
    events.player_hurt(v783);
    events.bullet_impact(v789);
    events.net_update_start(v801);
end;
v418 = nil;
v418 = {};
v767 = "lTZA7O1VkC3wj2YacHuBdMPRE8mtQXpnJKe5Ux9L4SIvNirWohDygszf60FbqG+/=";
v771 = ".\\" .. v13.name;
local v802 = v771 .. "\\db.dat";
local v803 = {};
do
    local l_v767_1, l_v771_1, l_v802_0, l_v803_0 = v767, v771, v802, v803;
    local function v808()
        -- upvalues: l_v802_0 (ref)
        return files.read(l_v802_0);
    end;
    local function v811(v809, v810)
        -- upvalues: l_v802_0 (ref)
        if v810 == nil then
            v810 = false;
        end;
        return files.write(l_v802_0, v809, v810);
    end;
    local function v817(v812)
        -- upvalues: l_base64_0 (ref), l_v767_1 (ref)
        local l_status_0, l_result_0 = pcall(json.stringify, v812);
        if not l_status_0 then
            return false, l_result_0;
        else
            local l_status_1, l_result_1 = pcall(l_base64_0.encode, l_result_0, l_v767_1);
            l_result_0 = l_result_1;
            if not l_status_1 then
                return false, l_result_0;
            else
                return true, l_result_0;
            end;
        end;
    end;
    local function v823(v818)
        -- upvalues: l_base64_0 (ref), l_v767_1 (ref)
        local l_status_2, l_result_2 = pcall(l_base64_0.decode, v818, l_v767_1);
        if not l_status_2 then
            return false, l_result_2;
        else
            local l_status_3, l_result_3 = pcall(json.parse, l_result_2);
            l_result_2 = l_result_3;
            if not l_status_3 then
                return false, l_result_2;
            else
                return true, l_result_2;
            end;
        end;
    end;
    local function v827(v824)
        -- upvalues: l_v771_1 (ref), v817 (ref), v30 (ref), v811 (ref)
        files.create_folder(l_v771_1);
        local v825, v826 = v817(v824);
        if not v825 then
            v30.error("Unable to encode data");
            return false;
        elseif not v811(v826) then
            v30.error("Unable to write db");
            return false;
        else
            return true;
        end;
    end;
    local function v831()
        -- upvalues: l_v771_1 (ref), v808 (ref), v827 (ref), v30 (ref), v823 (ref)
        files.create_folder(l_v771_1);
        local v828 = v808();
        if v828 == nil then
            if not v827({}) then
                v30.log("Unable to create db");
            end;
            return {};
        else
            local v829, v830 = v823(v828);
            if not v829 then
                v30.error("Unable to decode db");
                v30.log("Trying to flush db");
                if not v827({}) then
                    v30.error("Unable to flush db");
                end;
                return {};
            else
                return v830;
            end;
        end;
    end;
    local v837 = {
        __index = function(_, v833)
            -- upvalues: l_v803_0 (ref)
            return l_v803_0[v833];
        end,
        __newindex = function(_, v835, v836)
            -- upvalues: l_v803_0 (ref), v827 (ref)
            l_v803_0[v835] = v836;
            v827(l_v803_0);
        end
    };
    l_v803_0 = v831();
    setmetatable(v418, v837);
end;
v767 = nil;
v767 = {};
v771 = {};
do
    local l_v771_2 = v771;
    v802 = function()
        -- upvalues: l_v771_2 (ref)
        local v839 = ui.get_binds();
        for v840 in pairs(l_v771_2) do
            l_v771_2[v840] = nil;
        end;
        for v841 = 1, #v839 do
            local v842 = v839[v841];
            l_v771_2[v842.reference:id()] = v842;
        end;
    end;
    v767.get = function(v843)
        -- upvalues: l_v771_2 (ref)
        if v843 == nil then
            return nil;
        else
            return l_v771_2[v843:id()];
        end;
    end;
    events.render(v802);
end;
v771 = nil;
v802 = v384.links;
v803 = nil;
local function v844()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/BtbuapEw4e");
end;
local function v845()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://youtube.com/channel/UCT78kJfwruisG8w4u8LOEkQ");
end;
local function v846()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=5QrOCS");
end;
v802.discord:set_callback(v844);
v802.youtube:set_callback(v845);
v802.config:set_callback(v846);
v802 = nil;
v802 = {};
v803 = v384.configs;
v844 = "MNVaEeiPfvJ4BgzWUmtsRZFS8OXc9kqhy3dobp5IDwuTAG6Kl2Cr7HnY10jxLQ+/=";
v845 = "qCfof7ezm72eRHQNXSfdzdvxSVf2Ba9CBaMlgrN9fowxSVfCgr9nzsyrgrN9foD2BY7ASVf2gsEnBo90goECSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsRHgaEHBaMHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsb7gsRlBrb1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2goUrgsy7BoEYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2grUYgof1Ba8HSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCBrE2grBrBofCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaRngaMCzsR1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBsbnBobnBak9fowxSVfCgr9nzsyrgrN9foDHgY7ASVfrBoblBs82Bav9fowxSVfCgr9nzsyrgrN9foDr4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBrbHgoECBoR1gpldzIG9fofYgr80zaBYBeldzoR1ht29foU2zaM2gaRHBrO9fowxSVfCgr9nzsyrgrN9foDrBP7ASVfYgoE1gs9ngrk9fowxSVfCgr9nzsyrgrN9foDGBoeQ4eldzaf2go92go9lSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQhS7d4Vfof7ezm72eRHQNXSfyvdNa95QH8n3wc59dzdvxSVfCBayYgsRYzs8nSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29fofCga9HBrU2zsN9fowxSVfCgr9nzsyrgrN9foD2gS7ASVfCgaBrBsflBsf0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsMlBsB0grM2SVfjqHldBo9Ygob1Br9lSVfj4sfnht29foBlzaE2ga80BoN9fowxSVfCgr9nzsyrgrN9foDrgY7ASVfrBo9YgoRYBsUCSVfjqHldBo9Ygob1Br9lSVfjBS7ASVfrBr8ngsRCzaB7SVfjqHldBo9Ygob1Br9lSVfjgspQ4eldBrR2gs8HBoE2BeldzIG9fofYgr80zaBYBeldzoNQ4eldBr8ngrBrzsMrzeldzIG9fofYgr80zaBYBeldzofASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrzsfCBs9CBoe9fowxSVfCgr9nzsyrgrN9foDlht29foR2zsy7goM1zZldzIG9fofYgr80zaBYBeldzImCkFZQ4eldgobCgrRngsylSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0Bs8YgrynBpldzIG9fofYgr80zaBYBeldzoNQ4eldzsbHBabYBse9fowxSVfCgr9nzsyrgrN9foDHzPHQfdldfCgNsbkBmZghUYvKkFgDXF0IfoDdqHldBsU0zsMCBa80BZldzIG9fofYgr80zaBYBeldzd7rBS7ASVf2gsB2gafCBr81SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBs8lBrB2Bo81geldzIG9fofYgr80zaBYBeldzoNQ4eldBoU2Bry0gsU1geldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCzabnBoRYzsO9fowxSVfCgr9nzsyrgrN9foDlht29fof0gaflzaflgsN9fowxSVfCgr9nzsyrgrN9foDlht29foB2zsM1zaRHgag9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBCzsUnzsylgo39fowxSVfCgr9nzsyrgrN9foDlht29foBHBoBCgs8ngre9fowxSVfCgr9nzsyrgrN9foDlht29foBYBrUYBsfYgap9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrgr8rBrBYgs92SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7Bay0gaR1gsUlSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foyrBoE0zaB7BpldzIG9fofYgr80zaBYBeldzoUHht29foy7zsyrBaR7BeldzIG9fofYgr80zaBYBeldzoNQhtfAfdBoUR0PsEZsS7O3XnZA8F9dzdvxSVf2BrErgof7goy1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsBHzsU0gaBCgZldzIG9fofYgr80zaBYBeldzoNQ4eldBs8Cgob0BsB1BZldzIG9fofYgr80zaBYBeldzoNQ4eldBs87zaE7grB0gHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCBrfHzsfHzsb0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaBHgr8CzsRHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsMCBr90Bs9YSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBoblBrRngaBrBpldzIG9fofYgr80zaBYBeldzoNQ4eldBobYBsBngs9lzZldzIG9fofYgr80zaBYBeldzoNQ4eldBrBHgaM2BrBlBpldzIG9fofYgr80zaBYBeldzo8lht29foBnBoM0BrB1gsg9fowxSVfCgr9nzsyrgrN9foDlht29foBngaU1Ba97gom9fowxSVfCgr9nzsyrgrN9foDlht29foUlgsR7zsyYgae9fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldgrBYBsf7BrU1SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghmIvpOSg78F0bXF0IfoDdqHldBsB0zaBYgsb0zZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foEHBsRHgsfYgsp9fowxSVfCgr9nzsyrgrN9foDlht29fofCgob2gsyrBrN9fowxSVfCgr9nzsyrgrN9foDlht29fofrgrfHBofHgre9fowxSVfCgr9nzsyrgrN9foDlht29fofYBoB1gsB1zsg9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCzablBs9lBsv9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrErzaElBoE1BeldzIG9fofYgr80zaBYBeldzoNQ4eldBrUHBobCgs9HgpldzIG9fofYgr80zaBYBeldzoNQ4eldBryHBoMrgrynBeldzIG9fofYgr80zaBYBeldzofASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVf7BaMrBsM0gav9fowxSVfCgr9nzsyrgrN9foDlht29foUlgr97grB0zsO9fowxSVfCgr9nzsyrgrN9foDlht29fo92BrRHzaB0gZldzIG9fofYgr80zaBYBeldzoNQ4eldgrf7BsfYBoBnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfYzsbHBrBngsO9fowxSVfCgr9nzsyrgrN9foDnBPHQfdldfCgNsbkBmZghsFe6kFeAfep3kCfjfIG9foECBoBngsM7grk9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2BoBngobrzaZ9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsRHBay1zs97gHldzIG9fofYgr80zaBYBeldzoNQ4eldBs9lgsR1gsf0gpldzIG9fofYgr80zaBYBeldzoNQ4eldBoM1BsE0Ba91geldzIG9fofYgr80zaBYBeldzoNQ4eldBoBYBoyHBaE1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBrMrgrf2Br92BHldzIG9fofYgr80zaBYBeldzoNQ4eldBrUCBaBHBay1BZldzIG9fofYgr80zaBYBeldzoNQ4eldBrUrzsflzaMHgHldzIG9fofYgr80zaBYBeldzoNQ4eldBr9rzsRnza90SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrza9YgoUCgoy2SVfjqHldBo9Ygob1Br9lSVfjBd29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foUCzabHBaU1gsv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7zsErBr91gZldzIG9fofYgr80zaBYBeldzoNQ4eldzsEYgry0BaE1SVfjqHldBo9Ygob1Br9lSVfjgoNQhtfAfdBoUR0PsEZsS7HKk5RyvdNa95QH8n3wc59dzdvxSVfCBr9lgoy2BoR2SVfjqHldBo9Ygob1Br9lSVfjBsOQ4eldBoU1za8rBsyrgpldzIG9fofYgr80zaBYBeldzovQ4eldBoRrBaU7zaBHBHldzIG9fofYgr80zaBYBeldzoNQ4eldBo81BsyCza9rSVfjqHldBo9Ygob1Br9lSVfjBd29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof0BrR1BoE0BHldzIG9fofYgr80zaBYBeldzoNQ4eldBr82gaBlgr80BeldzIG9fofYgr80zaBYBeldzo8lht29foBYgrRlzs90gsO9fowxSVfCgr9nzsyrgrN9fow79IZpht29foB1gsf7gay1gae9fowxSVfCgr9nzsyrgrN9foDGgsmQ4eldBryHzaB2Bo8lzeldzIG9fofYgr80zaBYBeldzoNQ4eldBrbnzsb1BoB7gZldzIG9fofYgr80zaBYBeldzoBASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVf7BaRCgsU1BrU0SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldgoR0Bo8rBsUHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnzsf7BsMrBoN9fowxSVfCgr9nzsyrgrN9foDGzP7ASVf1zsECBabHgok9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7ezm72eRHQWcdNH9nRdzdvxSVf2BafngrUHBoE2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2Ba8HgoR7Br9CSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foErzaRYBr81Bo39fowxSVfCgr9nzsyrgrN9foDlht29foEnga8YgoErBsp9fowxSVfCgr9nzsyrgrN9foDlht29foE0goUrBrRlBop9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCgrbHgoR7BsfrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgs9YBaECgo39fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBr87Bo8lgsbnBeldzIG9fofYgr80zaBYBeldzo8lht29foBngr90BaE2zs39fowxSVfCgr9nzsyrgrN9foDlht29foUlgay0grbrgrZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7BaRlBr80Br87SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7BsUCgoMngoN9fowxSVfCgr9nzsyrgrN9foDlht29foUHgab0zsfYgpldzIG9fofYgr80zaBYBeldzoNQ4eldzaU2BrU2go97SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghRIZ6c5p6OCfjfIG9foElzaE1Ba90Bag9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2BoErgrEngsEYSVfjqHldBo9Ygob1Br9lSVfjBsOQ4eldBsRrBrU7BoMCzeldzIG9fofYgr80zaBYBeldzo8lht29foE0gaMlzsRnBsk9fowxSVfCgr9nzsyrgrN9foDlht29foflBa91zs80zsm9fowxSVfCgr9nzsyrgrN9foDlht29foflgrRnzsyrgre9fowxSVfCgr9nzsyrgrN9foDlht29fofYBoRCgo8HBsZ9fowxSVfCgr9nzsyrgrN9foDlht29fofYgab2gaM2BoO9fowxSVfCgr9nzsyrgrN9foDCht29foB2gsb1BrE7Bag9fowxSVfCgr9nzsyrgrN9foDr4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBrb2zsy1BoEnBpldzIG9fofYgr80zaBYBeldzd7CBP7ASVf7Bs90gs9rgsN9fowxSVfCgr9nzsyrgrN9fow79IZpht29foUnBryCgob1gHldzIG9fofYgr80zaBYBeldzd77gS7ASVfYBrErBoUlgag9fowxSVfCgr9nzsyrgrN9foDlht29fo9HBoU1BaMHzZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhSHQfdldfCgNsbkBmZghRne5OtNfOFebfoDdqHldBsMngaf2go8nzeldzIG9fofYgr80zaBYBeldzo8lht29foECBsUlBsE2BsZ9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBs97BoE0gr81BZldzIG9fofYgr80zaBYBeldzoNQ4eldBsb0BsMlBsEYgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foflgsbCzaE7Bop9fowxSVfCgr9nzsyrgrN9foDlht29foflzsU1BsBnzsp9fowxSVfCgr9nzsyrgrN9foDGBsNQ4eldBoBCBrBYBoBlBpldzIG9fofYgr80zaBYBeldzoNQ4eldBoRnBrUHBrflBpldzIG9fofYgr80zaBYBeldzoNQ4eldBo9CgoElBr9YzeldzIG9fofYgr80zaBYBeldzoNQ4eldBoy1zsRYgaEYBZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVfrBsRHzabrgsyrSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrB1ga9lza9CBHldzIG9fofYgr80zaBYBeldzoNQ4eldBrb7gab2BrUngHldzIG9fofYgr80zaBYBeldzoNQ4eldgaMrgaf1BrEHSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghRn3395ZbfoDdqHldBsf2grU2BoR0BHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gsB7go9rgo39fowxSVfCgr9nzsyrgrN9foDlht29foEHBr97zsRlgap9fowxSVfCgr9nzsyrgrN9foDlht29foEYzsyHBsbHgaN9fowxSVfCgr9nzsyrgrN9foDlht29fof1BaUnBoBrgsZ9fowxSVfCgr9nzsyrgrN9foDlht29fof0ga97Bsfrgam9fowxSVfCgr9nzsyrgrN9foDlht29foBlgoE1gsy1zav9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf7BoMlgrBYgsbnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaflBoECgrR1gZldzIG9fofYgr80zaBYBeldzoNQ4eldgaUHBs8CgsEYSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldgsM0gaR0gay0SVfjqHldBo9Ygob1Br9lSVfjBV29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foRngoM2zay1BZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMngrRYgabYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsBlzsb1zsZ9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7ezm72eRHQsciQYfiHKkipKcdfjfIG9foErgoU1gaR0Bsv9fowxSVfCgr9nzsyrgrN9foDlht29foEHgoBCBrU7gZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gs9CgoBlgaErSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaE7BaMHgrRYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zab0gaMrzam9fowxSVfCgr9nzsyrgrN9fow79IZpht29foE0zsEnBsR0gae9fowxSVfCgr9nzsyrgrN9foDlht29foflBr97zs8CBog9fowxSVfCgr9nzsyrgrN9foD7BI7ASVfCBsb7zsEYBof2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrRYgs82Bo8lSVfjqHldBo9Ygob1Br9lSVfj4sB1ht29fofrzsRHga87zZldzIG9fofYgr80zaBYBeldzo8lht29foBlBrElBoyrzsN9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrgr91BrRYzsfHSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foU2BoM1gaB7gse9fowxSVfCgr9nzsyrgrN9foDlht29foy2zsb7BabHgpldzIG9fofYgr80zaBYBeldzoNQhtfAfdBoUR0PsEZsSHg78F0bXF0IfoDdqHldBsfCgsBnBo82BeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gsyCBsMHzsU1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gr82zs9lBr8lSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zsMCzaMnBoE1SVfjqHldBo9Ygob1Br9lSVfjBrgQ4eldBsb7Bsy0Brb7gpldzIG9fofYgr80zaBYBeldzoNQ4eldBo80Ba8rgsB1BZldzIG9fofYgr80zaBYBeldzoeQ4eldBoy0grUHzafnSVfjqHldBo9Ygob1Br9lSVfj4s80ht29fof0ga8lzabngok9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrBa92BaEHBsM2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrBHzaR7gs8rgeldzIG9fofYgr80zaBYBeldzoBASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVfrzsb0gaEHzaM2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfHBo9CBsUlzav9fowxSVfCgr9nzsyrgrN9foDlht29fo80BsfHzsM2gHldzIG9fofYgr80zaBYBeldzoNQ4eldzsfYBa8HgaBlSVfjqHldBo9Ygob1Br9lSVfjgoNQhtfAfdBoUR0RtRevsZQgURpzfoDdqHldBsR7goEHgr97geldzIG9fofYgr80zaBYBeldzoeQ4eldBrUlBrUrgoUlBeldzIG9fofYgr80zaBYBeldzImCkFZQhtfAfdBoUR0RtRevsZQsmZmRtR0PRCfjfIG9foflzabHgaU0zsN9fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9foEYBob1zsyCgsp9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzsy1BrB2zay2SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofHgo82goRrgrZ9fowxSVfCgsUCgoblgrk9fowcqHldBsUCgryHgsyrgpldz5O3cPgp4eldBs9rgs9lgoE1Bpldz5O3cPgp4eldBsbCzafCzs82SVfjkPvHOt29foE0BrU0gobYgeldzo8ASVfCBablgsEHBaE1SVfjBt29fofrzsb7gaM0BaZ9foDl4eldBrBlgrMnzaBnBHldz5O3cPgphZ7ASVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVf2BoM1BsU0gsMCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgay2ga8nBry2SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCzafrgoE7zabCSVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foBlzsb2goE0zsp9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9foflzsMCBrMYgog9fowxSVfCgr9nzsyrgrN9foD7BP7ASVfCBs9rBa81zaR0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoRCBaR2Brb7gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgsMngaE1gsp9fowxSVfCgr9nzsyrgrN9foD2hSHQ4eldBrRnBob1grb2BeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgrRngo9lzsm9fowxSVfCgr9nzsyrgrN9foD2ht29fo97zablgsBngeldzIG9fofHgafnzsMYgHldzpGxSVf2gafYzaRHzaBnSVfjO5eA9nRASVf2grBHgrMnBsyCSVfjBV29foE0BoyCBobnBZldzoEASVf2zsB7zs80grm9foD0BV29foflzsMHBsRlBs39foDl4eldBoB0zsU7BablgZldzoMASVfrBrMYBa81Br8rSVfjO5eA9nZQ4PG9foE7Bo91gsR1BrO9fow58F2rOt29foEYBrRYBa82zav9foDl4eldBsbCzafCzs82SVfjBd29foE0BrU0gobYgeldzoy14eldBoM0BaR2gsM2zeldzoMASVfCBrb0gaUlzsMHSVfjBV29foBrBa9lgoyrgog9fow58F2rOSHk4eldBo9Ygob1Br9lSVfjBV29foUlgsM7zaf2gsN9fowxSVfCgay2ga8nBry2SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCzafrgoE7zabCSVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foyHBaM0zsRnBHldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4Vfof7ezZEpNtRHhRHmNZERdzdvxSVf2BsM0BrB1BaBnSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2BsbrgryYgoRnSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gaUrBob0gs91SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gabYBafHBafHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsR1zsU0gaMnzZldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBs8YBrRrzsErgHldzIG9fofYgr80zaBYBeldzoNQ4eldBs8YBr9CgrU7BHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBs9CgrU7zaUYgZldzIG9fofYgr80zaBYBeldzoNQ4eldBs91goE2ga8rSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaE2gobHBaRCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zab1BrUlgablSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsb1BoblgsMnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrB1zs8nzsEnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoBngoErBrMngHldzIG9fofYgr80zaBYBeldzoNQ4eldBoBnza82zsfnSVfjqHldBo9Ygob1Br9lSVfjBseQ4eldBoUlBrE0BofCBHldzIG9fofYgr80zaBYBeldzoNQ4eldBoR7grRYBafHgHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBo8CzaU0gsBHgHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBo81gsBCgav9fowxSVfCgr9nzsyrgrN9foDlht29fof1grB7BoBHBaO9fowxSVfCgr9nzsyrgrN9foDlht29foBlzs9lgrU1grZ9fowxSVfCgr9nzsyrgrN9fow79IZpht29foB2BablgrMHzaN9fowxSVfCgr9nzsyrgrN9foDlht29foBrBoM2goMCBrp9fowxSVfCgr9nzsyrgrN9foDlht29foB7BobCzs9YBre9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrzaUCBob1Bsy7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfHzaU1zsE0Bo39fowxSVfCgr9nzsyrgrN9fow79IZpht29foyrBs91BsErgHldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7ew9dfjfIG9foElBry1Bsf1BrO9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2BsU7Br97grbrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2BrMrzs9Yzse9fowxSVfCgr9nzsyrgrN9foD2ht29foE7gaU0BsU2gsv9fowxSVfCgr9nzsyrgrN9foDGgaZQ4eldBsUHgoR0BofnzeldzIG9fofYgr80zaBYBeldzoNQ4eldBsRrgr9Ygr82geldzIG9fofYgr80zaBYBeldzoNQ4eldBsylgoBlBaElBpldzIG9fofYgr80zaBYBeldzo8lht29foE1BsEnzsRlgsv9fowxSVfCgr9nzsyrgrN9foDlht29fof7BaR2zsU2gap9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCgrUCzsRHzaRHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgryrBsy1goB7SVfjqHldBo9Ygob1Br9lSVfjBsylht29foBHBayYzaRnBap9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgsElBa91gaE7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrR1Bsb7ga97gpldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBrR0Ba80goe9fowxSVfCgr9nzsyrgrN9foD0BP7ASVfrgryrzs9HBrflSVfjqHldBo9Ygob1Br9lSVfjgP7ASVfrzsfrgrblBsR0SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foU2BoRlgobngoZ9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf7Bof1zs8rzsbCSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fo8ngs87zaMCSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfYgo87BoRCBsm9fowxSVfCgr9nzsyrgrN9foDGzsNQhtfAfdBomEZimR0stZOeS7ew9dM5fEgCcYZoXip6OCfjfIG9foECgs8lBry2gsg9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2BoylgaEHSVfjqHldBo9Ygob1Br9lSVfjBsfl4eldgaMHBaU1BoEHBeldzIG9foU2grBHBrE2gsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsR1zayHBrMlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsbCzsB7za8nSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gofCgrU7BaUnSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBs91gayYBobHBeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE1goy2gryrgoe9fowxSVfCgr9nzsyrgrN9foDlht29foE0Bsy2gaB7zsZ9fowxSVfCgr9nzsyrgrN9foD2ht29fof2Brf1zafngoO9fowxSVfCgr9nzsyrgrN9fow79IZpht29fofrgaf1goE0zak9fowxSVfCgr9nzsyrgrN9foDlht29fof7zsy2ga9rgam9fowxSVfCgr9nzsyrgrN9foDlht29fof1goBrzaBlgr39fowxSVfCgr9nzsyrgrN9foDlht29fof0BoBnBr9rBsm9fowxSVfCgr9nzsyrgrN9foD2zaNQ4eldBob1gaylBo8rgpldzIG9fofYgr80zaBYBeldzoflht29foBlBrfYzs9nBrv9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrElzsMYBaR1BeldzIG9fofYgr80zaBYBeldzoNQ4eldBrE0Br8HgoR2BpldzIG9fofYgr80zaBYBeldzoeQ4eldBrBHzaRnBs91BHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf7grMnBsbYgoe9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfYzaM2gaUHgoe9fowxSVfCgr9nzsyrgrN9foDlht29fobrgoylBrB2zZldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7gCcYZoXip6OCfjfIG9foElBaEYBsb0gsm9fowxSVfCgr9nzsyrgrN9foDlht29foElgrR1BoMHgsO9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2zaB2ga80grEYSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE1Br9rzaf7zsm9fowxSVfCgr9nzsyrgrN9foD2ht29foE0gsRlgoEngre9fowxSVfCgr9nzsyrgrN9foDCBP7ASVfCBsR7BrE0gr8YSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrbCBsR7zs9nSVfjqHldBo9Ygob1Br9lSVfjBsylht29fofngaB0goblBrv9fowxSVfCgr9nzsyrgrN9fow79IZpht29fof1grB7BoBHBaO9fowxSVfCgr9nzsyrgrN9foDlht29fof0zsU7BofHBsv9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBHgsb1goMlgaO9fowxSVfCgr9nzsyrgrN9foDlht29foBnBsf7BoBYBaN9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrzaRHza97BsUCSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foB1zsBHgrylzaZ9fowxSVfCgr9nzsyrgrN9foD2ht29foUCBsf0gaf0zsk9fowxSVfCgr9nzsyrgrN9foDlht29fo8Hza8lBs9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfngoBCgrf7gsZ9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfngoRlgsylgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo9nzsM7gsfCgpldzIG9fofYgr80zaBYBeldzoflht29foy1zaBrBoBHgpldzIG9fofYgr80zaBYBeldzoNQ4eldzay0gaflgoR7SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhm5eTOF23OCfjf50Hcild4Vfof7membZzR7pFmZQi95Zp9Ym3c5mwc59dzdvxSVf2Ba8rzsB2BoynSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gaUYzaU7ga82SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE1goR7grE2BsO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2zabHgofrBrE1SVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE0grRnzay1goe9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2zsyCzsMHBaO9fowxSVfCgr9nzsyrgrN9foDlht29foflBrfngoRHgrO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgsU0grBCzaEHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoU1grE0goM1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoy1gsUYgoR1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsM7gaylzaB7SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBobrga9ngr9CgZldzIG9fofYgr80zaBYBeldzoNQ4eldBrECgrB7BrRCgpldzIG9fofYgr80zaBYBeldzoNQ4eldBrB7za92BafrgpldzIG9fofYgr80zaBYBeldzoNQ4eldBrU7Bs9HgabCSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrUHgaM7goUrzZldzIG9fofYgr80zaBYBeldzoNQ4eldBry0BryCBo80gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foB0ga9HBoUngop9fowxSVfCgr9nzsyrgrN9foDlht29fo8rBaMngo81zeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foy7gsE0BrMCBHldzIG9fofYgr80zaBYBeldzoflht29fobCBablgo9ngZldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7H3cIZ3cVNO8S9dzdvxSVf2BaflBrb7zaU0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsEngaB7zab0gHldzIG9fofYgr80zaBYBeldzoNQ4eldBsU7go92gr8ngpldzIG9fofYgr80zaBYBeldzoNQ4eldBsU1zsyHBsE2gHldzIG9fofYgr80zaBYBeldzoNQ4eldBsRlgaflBrbYgHldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foEngrR2Ba9HgeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2grM1gsR7zs8CSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBsM2BsbCBsfHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBofrBsfCBry2BpldzIG9fofYgr80zaBYBeldzoNQ4eldBoUlBrE0BofCBHldzIG9fofYgr80zaBYBeldzoNQ4eldBoRYBrRYgrE0gZldzIG9fofYgr80zaBYBeldzoNQ4eldBo87zaM2gsB1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBoyHBaRrzs87gHldzIG9fofYgr80zaBYBeldzoNQ4eldBrf2BsyrgrM2gHldzIG9fofYgr80zaBYBeldzo8lht29foB7BaBrBsfCBap9fowxSVfCgr9nzsyrgrN9foDlht29foB7BoE2Bob2grg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgr82zaM7BoEHSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgaMHgs9lgrU2zZldzIG9fofYgr80zaBYBeldzoNQ4eldgafngaE1za8nzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foUngaBCgay7BHldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfHgo92gsRrBsO9fowxSVfCgr9nzsyrgrN9foDCBPHQfdldfCgEmROespgvZbZhsFQnOtM5fEgCcYZoXip6OCfjfIG9foE2grMYBrM2gap9fowxSVfCgr9nzsyrgrN9fow79IZpht29foE7go91BrEHgap9fowxSVfCgr9nzsyrgrN9foDrgoNQ4eldBsR2goMCgayYBHldzIG9fofYgr80zaBYBeldzo8lht29foEngsRrgrBrBsk9fowxSVfCgr9nzsyrgrN9foDlht29foE1Bs8HBoynzsp9fowxSVfCgr9nzsyrgrN9foDCht29foflgry1grR2zaN9fowxSVfCgr9nzsyrgrN9foDlht29fof2gsMnBob2Brv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgs92BrE2gaM0SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCgo97Bo9CBab1SVfjqHldBo9Ygob1Br9lSVfjBS7ASVfCzsBHzaU2BsB1SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof0Bryrzsf2gre9fowxSVfCgr9nzsyrgrN9foDGgaZQ4eldBrfYBofrBsR7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBrflBs8lBoB0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgaynBoyYBs9HSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBr9rgoEHgsb1BZldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foBYgrU7Bablgsk9fowxSVfCgr9nzsyrgrN9foDlht29foUCgs9rBoBlBHldzIG9fofYgr80zaBYBeldzoNQ4eldgsBCBrf2zsBrSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfnBaB7zsUHBrv9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf1BaB2gsf0gsZ9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldzsbYgaf7ga81SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhsn1ykSgpfoDdqHldBsMnBsMrza8YzZldzIG9fofYgr80zaBYBeldzoNQ4eldBsR2BoR7BoBrBeldzIG9fofYgr80zaBYBeldzoNQ4eldBs8YBoflBofrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaM1Bob2gsMrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBsbnBsRngsErBpldzIG9fofYgr80zaBYBeldzoNQ4eldBoB2BoRCgs9ngpldzIG9fofYgr80zaBYBeldzoNQ4eldBoRCgsMnzsBnBpldzIG9fofYgr80zaBYBeldzoflht29fofngoElBoE0zae9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCgoyHBrf7BpldzIG9fofYgr80zaBYBeldzoNQ4eldBoyCgr9nBsRlBZldzIG9fofYgr80zaBYBeldzoNQ4eldBrMlgaBYBoEYBeldzIG9fofYgr80zaBYBeldzoNQ4eldBrB7gaUHgrfYgpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBYBa92zay7Bov9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBr92grMrBa9lzeldzIG9fofYgr80zaBYBeldzo8lht29foB0BrR2gsE1geldzIG9fofYgr80zaBYBeldz5O3cPgpht29foB0zs8CBaM0Bs39fowxSVfCgr9nzsyrgrN9foDlht29foU2BobHgoUCgak9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7BsbrBoR0za80SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foUrgaR2zaEnzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foy2gsUnzs8YBpldzIG9fofYgr80zaBYBeldzoNQ4eldzaUYBsM7zaErSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhRIZ6c5p6OCfjfIG9foElgaElza97grO9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsf7Bo9Hgo8YBZldzIG9fofYgr80zaBYBeldzoNQ4eldBsBCgsBnBsBrgeldzIG9fofYgr80zaBYBeldzoNQ4eldBsB0zsyCBsylgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE7grUCgrU2grm9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2zaf7zs92gsbrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBoMCBr9Hgr91zZldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCBsBlBo90BoM7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrU1gsRrBofYSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBo9YBs9CBsblgZldzIG9fofYgr80zaBYBeldzoNQ4eldBoyrBrRnBo9lBZldzIG9fofYgr80zaBYBeldzoNQ4eldBobrzaRrBsyHzZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBlgr9Cgsy2BoO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBof7Boy2gsy1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBoU7gsBlBrbYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgafCBrB7gsU1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgoUnzsbnBaB1SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgaM0BoM2BsyYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7gof7zabrBoO9fowxSVfCgr9nzsyrgrN9foDlht29foUngrfrBrBHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldzaB2gry2BsBYSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhRne5OtNfOFebfoDdqHldBsE7gsMHza91zeldzIG9fofYgr80zaBYBeldzoNQ4eldBsU7gaM1ga8nBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE7gaylgrBrgae9fowxSVfCgr9nzsyrgrN9foDlht29foEngrBHBrb2Brk9fowxSVfCgr9nzsyrgrN9foDlht29foEYzsUHBry2gag9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2zsbnBsf1BrErSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBoE2gsU2gsU7BHldzIG9fofYgr80zaBYBeldzoNQ4eldBofCzaylBrM7BZldzIG9fofYgr80zaBYBeldzoNQ4eldBoU2BoRrzsBrBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofHBsBYBsUrgs39fowxSVfCgr9nzsyrgrN9foDCBP7ASVfCgsRlza87zs9lSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoRHzsy0gr9rSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofnzsBnzsBYBsO9fowxSVfCgr9nzsyrgrN9foDlht29foBlgsyHgsf1Bam9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrEnBsR1za9rgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBrzaE7Baf1gsm9fowxSVfCgr9nzsyrgrN9foDlht29foBnBsbCBrylgog9fowxSVfCgr9nzsyrgrN9foDlht29foU2grM0BaB7zag9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfnBoUHBsf1gov9fowxSVfCgr9nzsyrgrN9foDlht29fo8rgrU0zaECgZldzIG9fofYgr80zaBYBeldzoNQ4eldzaRlgoMHBrbHSVfjqHldBo9Ygob1Br9lSVfjBsfl4eldgaMHBaU1BoEHBeldzIG9foU2grBHBrE2gsp9fowxSVfCgr9nzsyrgrN9foDlhSHQhtfAfdBomEZimR0stZOeSHgD8SvpOVfjfIG9foElzayCza9Czap9fowxSVfCgr9nzsyrgrN9foDlht29foEngsEYzsEHBsp9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2grynBsE7gog9fowxSVfCgr9nzsyrgrN9foDlht29foE0gsU7zaBngs39fowxSVfCgr9nzsyrgrN9foDlht29fof2zaU7BafrBak9fowxSVfCgr9nzsyrgrN9foDlht29fof7goUCzaB0zak9fowxSVfCgr9nzsyrgrN9foDlht29foB2Bsf1gofngeldzIG9fofYgr80zaBYBeldzoNQ4eldBrB2zsb1BoMCgpldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrgabnBoEHgabYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrR7gaflgrBngeldzIG9fofYgr80zaBYBeldzoNQ4eldBrR1zablzs8YgpldzIG9fofYgr80zaBYBeldzoNQ4eldBryHzab7go87BHldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrza81gry1zsf0SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrblBsMnzsMrgZldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foUCBr92gsb2BoZ9fowxSVfCgr9nzsyrgrN9foDlht29foUCzaErBof7go39fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7Bob2ga8lBsy1SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgsUHBo9rgaMHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgsynBo9nBry0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgoB0Bo87gayYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsy1goBlBrm9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7membZzR7pFmZQsciQYfiHKkipKcdfjfIG9foEHzsyrBsUlgap9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2goE1gsbHzaEnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2go80goblBs9nSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBsbYgo8YBrbnBHldzIG9fofYgr80zaBYBeldzoNQ4eldBsb1BrfCzs8rgZldzIG9fofYgr80zaBYBeldzoflht29fofrBof2gaBrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBr8nBsBrBa8YSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaM1BaE1zs8YSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof1zsR2zay1gaO9fowxSVfCgr9nzsyrgrN9foDlht29fof0go8lBo9nBrk9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrBaErgoyrzay1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBaBYzabHBrfHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBoy2goMYgabrSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrBnzsB1goR1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBr8rBsMrBr92BeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrgoU0ga9rgoM1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBr80Brynzsy7gHldzIG9fofYgr80zaBYBeldzoNQ4eldBrbYzaUHzsb1BZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foyCgr90BoR1BHldzIG9fofYgr80zaBYBeldzoNQ4eldzsEYzsB0zsB7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsMlgoU7BoZ9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgEmROespgvZbZhRYm3c5mwc59dzdvxSVf2BaMYgsb0BrN9fowxSVfCgr9nzsyrgrN9foDlht29foE2Bsf1BaB1Bsm9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2gaMrgsBrza82SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gaRYBaylBoMlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaMYBsy1zse9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsyHza87gsE7BeldzIG9fofYgr80zaBYBeldzoNQ4eldBofYzaR7grUlSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofrBrbHgaB0Ba39fowxSVfCgr9nzsyrgrN9foDlht29fofrgs82gobnBav9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCgsUlgaB2BaBlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgrynza80grO9fowxSVfCgr9nzsyrgrN9foDCBP7ASVfrgaErBaUlBoRrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBrRlgofYzs91SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrRlgo87gryHBZldzIG9fofYgr80zaBYBeldzoNQ4eldBr8ngrMlgo91geldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foBYBaR2zsU7zsm9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgrUrBa82gaBHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrzaUCBob1Bsy7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBrBnBo97zsg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf1Baf0BaB1Brm9fowxSVfCgr9nzsyrgrN9foDlht29fobYBsU2gr82BHldzIG9fofYgr80zaBYBeldzoNQhtfAfdBosRpsUCfjfIG9foE7BrUnzsfngov9fowxSVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVfrBr8YgoR0zsfHSVfjqHldBo9Ygob1Br9lSVfjBoMlhSHQ4eldBs92zaf7gr9YgHldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9foElBa92BaM2BHldzIG9fofYgr80zaBYBeldzoElBP7ASVf2BaMYBsMlBsm9fowxSVfCgr9nzsyrgrN9foD2BaNQ4eldBoBrBaBngrfCgZldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofHgobYgs9lgag9fowxSVfCgr9nzsyrgrN9foDGBS7ASVfrzsfnzaMlBsv9fowxSVfCgr9nzsyrgrN9foD2ht29foylgoblgoBngHldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2zaMngoy1BaBHSVfjqHldgaMHBaU1BoEHBeldzIG9foBHBrUCgrfnBoZ9fowxSVfCgr9nzsyrgrN9foDChSHQ4eldBof1Brf1go9CBeldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofrBsBCBsM0Bap9fowxSVfCgr9nzsyrgrN9fow79IZpht29fofngo8HBoBnBrZ9fowxSVfCgr9nzsyrgrN9fow79IZpht29fofYgsBYgoMCzak9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBlgrB1goRnzsO9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBHBr81BoEYza39fowxSVfCgsUCgoblgrk9fowcqHldBsUCgryHgsyrgpldz5O3cPgp4eldBs9rgs9lgoE1Bpldz5O3cPgp4eldBsbCzafCzs82SVfjkPvHOt29foE0BrU0gobYgeldzoEASVfCBablgsEHBaE1SVfjBt29fofrzsb7gaM0BaZ9foDl4eldBrBlgrMnzaBnBHldz5O3cPgphZ7ASVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVfCzsECBrfrgsy1SVfjqHldBo9Ygob1Br9lSVfjBokQhS7ASVfHBryrBo91gre9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9fofCgabCBaUCgsZ9fowxSVfCgr9nzsyrgrN9foDCBaUYht29fofHgrRrgsM7zak9fowxSVfCgr9nzsyrgrN9foDrht29foB1Brb1BsB1grZ9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29fo8HgrfYzaBCBpldzIG9foUlgsM7zaf2gsN9fowxSVf2gsB0grR1BaRnSVfjcIZAcV29foB2goU2BrM7zZldz50HcilASVfrgr9rgrb0BrRHSVfjqHldBo9Ygob1Br9lSVfjSVv9fI7ASVfnBrUrBr9rBoN9fow6kF2AhS7ASVfngsbHBaBYzsO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfYgafngobHBag9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtURkeUbQRfoDdqHldBsMlgo91BobrBpldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9foEnBo9YgaUlga39fowxSVfCgr9nzsyrgrN9foDCht29foE1zsMlgaE0gom9fowxSVfCgr9nzsyrgrN9foDrgS7ASVfCBs9YBsbrBrv9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV1l4eldBs9Ygo9nSVfjBV1l4eldBs9YgoyYSVfjBV1YzaUrBsBYzs90gsMYgaUnhZHQht29foflzsMHBsRlBs39foDlhS7ASVfCBrRlBa80BrN9fowxSVfCgr9nzsyrgrN9foDCBP7ASVfCgsfnzaRYgaE0SVfjqHldBo9Ygob1Br9lSVfjBreQ4eldBo81BrRrBoMCzeldzIG9fofYgr80zaBYBeldzofHht29fof0grbngaElgoZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgafHgrRCgsv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgoflgsUYzsm9fowxSVfCgr9nzsyrgrN9foDCzP7ASVfHBoyrgaUCBoO9fowxSVfCgr9nzsyrgrN9foDYhSHQ4eldBoM1zsBCzsf2BeldzIG9fofYgr80zaBYBeldzImCkFRASVf7BaRlgayCBsRlSVfjqHldBoM1zsE7goRCgpldzIG9fofYgr80zaBYBeldzoElBP7ASVfCBay0Brf0BoMnSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCBablBoBlgr8rSVfjqHldBo9Ygob1Br9lSVfjgS7ASVfrBrU1gsElgsM1SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrBngo90zs9lBpldzIG9fofYgr80zaBYBeldzoZQ4eldBrU7BsUHBsflzZldzIG9fofYgr80zaBYBeldzIG9foflzsM2gsR0BoO9fowxSVflSVfjqHldBoM0BaEHgsbCgpldzpGxSVf2gr9ngrN9foD24oMASVf2gr9ngre9foDl4oB2Br9CgsRlBsf0zablgaUASVf2gr9ngrO9foDl4oyCgrUHBsMHBaf1BsRCga9ASVf2gr9nzak9foDl4o8rzsf2gs9lgr9YzabrBakQSSHQ4eldBoM0BaR2gsM2zeldzoNQht29foB7zs9lBoR1goN9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV1lza8CgrUHBsf2Bsf2gaMngd29foEYgr8YgpldzoM6BaynBo97gsECBsECBsUlgo8ASVf2gr9nzak9foDl4oM1gofYgaR2BoE2BoE7Ba8nhZHQht29foflzsMHBsRlBs39foDlhS7ASVf0goU1BoErgrO9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV1rBr9CgsU0BsEngoE2gaylgC29foEYgr8YgpldzoM6grU0BaE0gofCzaMCgrB7gV29foEYgr81gHldzoM6zsU2Bs9ngsBrgob0BaBHgIHkhS7ASVfCBablgsEHBaE1SVfjBPHQhS7ASVfCzaR1gsfCBsB7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nRASVf7BaRlgayCBsRlSVfjqHldBoRCgoyHgrU2zZldzIG9fofYgr80zaBYBeldzoEHht29fofYgoBrgaE7Brm9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf7BoMHzab7goy1SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof0gry1zsfnBZldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9foElBs8lzabYBoO9fowxSVfCgr9nzsyrgrN9foDlht29foElgay0grR1Brk9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2Ba9Cgry7grR7SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsE2BoECzaflgpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE2BrflBrUlgrv9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf2BsRCgs87gr9lSVfjqHldBo9Ygob1Br9lSVfjBI7ASVf2Bs9nBrRlBr97SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsflBab2goECBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foECgoRlzsRrgr39fowxSVfCgr9nzsyrgrN9foD1BP7ASVf2BoyCBob1BsbYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsf0goUrBoR2gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foErBs92BoU1BZldzIG9fofYgr80zaBYBeldzoylht29foErBo8ngrMrgrv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2BrUlzaM7goblSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsU2BafCgaBrBpldzIG9fofYgr80zaBYBeldzoylht29foE7Bry7grMHBsp9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2gaUngr9lzaylSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsU7zaE0gsElBeldzIG9fofYgr80zaBYBeldzoNQ4eldBsUYBoU1zsMYzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foEHBrf1BsU2gam9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2gsBngaMHBoyrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsUlgs9CgrbYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsR1Ba81gay0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2goE2BrfHzsRCSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBs82BoE1BaMlBpldzIG9fofYgr80zaBYBeldzovQ4eldBs8CBsRYzabrBeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foEngrM1gsBHBrk9fowxSVfCgr9nzsyrgrN9foDlht29foEngryYBsy1gsN9fowxSVfCgr9nzsyrgrN9foDlht29foEnzsElgsE7gov9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2gob1gaMYga8YSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBs9lBa8YgayCBHldzIG9fofYgr80zaBYBeldzoRlht29foEYBsB0Bofnzav9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2grEHBr9HgpldzIG9fofYgr80zaBYBeldzovQ4eldBs9rzsbrzaE2BpldzIG9fofYgr80zaBYBeldzoRlht29foEYgaBrgaRCgoO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2zaf2BrRYzsU2SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsyCzsfCgoyrBpldzIG9fofYgr80zaBYBeldzoRlht29foE1gaE7Brf2zsp9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2zaU0BayYgryCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaU0Br91Bay7SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsyHBo9nBa8lgpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE1gofHzaf2gZldzIG9fofYgr80zaBYBeldzoNQ4eldBsyngoy0gabCgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE1zaUHzsM2Brv9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2zabnBrRrBobnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsb2BaU1gr82geldzIG9fofYgr80zaBYBeldzoRlht29foE0BsyrgrUrgo39fowxSVfCgr9nzsyrgrN9foDlht29foE0Bo9ngoM7Bo39fowxSVfCgr9nzsyrgrN9foD1BP7ASVf2zs92grUHBsBCSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsbYzs8HzsBrgHldzIG9fofYgr80zaBYBeldzovQ4eldBsb1goElBr80BHldzIG9fofYgr80zaBYBeldzoRlht29foflBafCgrM2zsg9fowxSVfCgr9nzsyrgrN9foDCht29foflBobrzsbYBrO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBaUrgsB7BaR7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoM7grf2BoUnBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foflgo81zsR1ga39fowxSVfCgr9nzsyrgrN9foDCht29fof2BaB0BrU1gr39fowxSVfCgr9nzsyrgrN9foDlht29fof2BaUYBsUnBsp9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBsE1zaU1zsBYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoEngrfHzab7zZldzIG9fofYgr80zaBYBeldzoNQ4eldBoEYgoy0Bs81zZldzIG9fofYgr80zaBYBeldzoNQ4eldBoE0BaMlgaUCgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofCBsBCBofCBsm9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCBoBHBrE1gab7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBoB0gaM0grMnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBof1BrMlBoB0gpldzIG9fofYgr80zaBYBeldzoRlht29fofCzs91goUHgaO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCBrUngoyHgrZ9fowxSVfCgr9nzsyrgrN9foDCht29fofrgsUlgsE0Bsk9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgaMlBobCBZldzIG9fofYgr80zaBYBeldzoylht29fof7gof7BsbnBs39fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCgab7goU0gov9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgsR0zayHzs80SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBo8lBaf7go90zeldzIG9fofYgr80zaBYBeldzovQ4eldBo8lBrB1BsbHgZldzIG9fofYgr80zaBYBeldzoRlht29fofnBsUYBayngZldzIG9fofYgr80zaBYBeldzoRlht29fofnBrE7zsUnzag9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCgo8lzs82zaBHSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCgrf1zaR7grE7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBo9rgsBnBsf0gZldzIG9fofYgr80zaBYBeldzoNQ4eldBoy7BoUCgrfCzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29fof1gsMYBo9Hzap9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCza87za82zsMYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBoyYBab7grRrSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBoyYgsE2gay1gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29fof1zsy1Bof2zae9fowxSVfCgr9nzsyrgrN9foDCht29fof0BaEYzabrgav9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzsEngoflzsbCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsE1gaR0BsN9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCzsfngaMngofHSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBobrBr87gsR0gpldzIG9fofYgr80zaBYBeldzovQ4eldBobrgo9YBayHBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fof0gsUCBsMYgr39fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBaR0zaMCBo39fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBayCgr8CgryYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrElBob2gaMrzZldzIG9fofYgr80zaBYBeldzoRlht29foB2BaR7gsBCzsZ9fowxSVfCgr9nzsyrgrN9foDlht29foB2Bs91grbrzse9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBsfHBrElBrRnSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrBsUYBrM2zs9HSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrE7zsfYBaB7geldzIG9fofYgr80zaBYBeldzoNQ4eldBrEHBaR2goflgZldzIG9fofYgr80zaBYBeldzoNQ4eldBrEHBoU1BsUHBpldzIG9fofYgr80zaBYBeldzoRlht29foB2goEYzaElgrN9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrBs9rBrM2BsE7SVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrBsyCzaRngabYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrfrgs8lgrU0gpldzIG9fofYgr80zaBYBeldzoRlht29foBCgaylga8ngrO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBo87BrRnBaErSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrBoylzsfnBrErSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrf0Bay0goBlBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBrBaRlgo8HBo39fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBrfCBoEHBsE1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrB7grU2BsRnzZldzIG9fofYgr80zaBYBeldzoRlht29foBrgoMHga91Bsp9fowxSVfCgr9nzsyrgrN9foDCht29foBrgoR1zaEYgag9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrgaMlBs8Cgs81SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrUrBrBYzsU1zZldzIG9fofYgr80zaBYBeldzoylht29foB7Bry7gsbngsk9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrgaU7gaf0gofYSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBrU7gsbnzsM0SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrUHBsEnzsEYBpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foB7goflBrUCzaO9fowxSVfCgr9nzsyrgrN9foDCht29foB7zaU2BoyCBrg9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrgayngr9lBsblSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrRYBaBnBay0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrRYgoE2zsMnBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHzafHgsyrgok9fowxSVfCgr9nzsyrgrN9foDCht29foBHza9rBsfCgHldzIG9fofYgr80zaBYBeldzoRlht29foBnBa9Hza91grv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgoECgsBlgo8rSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrgoEYBs91zsfrSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBr87gsyrBobrgeldzIG9fofYgr80zaBYBeldzoNQ4eldBr8nBafCgsElBHldzIG9fofYgr80zaBYBeldzoNQ4eldBr8YzaR7BoflgZldzIG9fofYgr80zaBYBeldzovQ4eldBr81BrR2goflgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBYBaE1BoECgsZ9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrgrEHzsRHgs9rSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBr9ngry0BsMYgpldzIG9fofYgr80zaBYBeldzovQ4eldBr91zaB1BobnBpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBYzsBCgsy0zZldzIG9fofYgr80zaBYBeldzoNQ4eldBry7gry7gry2BHldzIG9fofYgr80zaBYBeldzoRlht29foB1gay7go80zsg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrza8rzaBrBrMnSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrzabCBaR0goyrSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrblBaBlgrf1BZldzIG9fofYgr80zaBYBeldzoNQ4eldBrblgoB7BaRCBpldzIG9fofYgr80zaBYBeldzoylht29foB0BsU1BofHgpldzIG9fofYgr80zaBYBeldzoylht29foB0Bo9ngo9ngrZ9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrzs9HBo9HBoBrSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrzsy0Bs9YBayYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgaMlgrBrza8ngeldzIG9fofYgr80zaBYBeldzoRlht29foUlBsf7Baf1zaZ9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf7BaR7za9rBeldzIG9fofYgr80zaBYBeldzoylht29foUlzsM7Ba92gr39fowxSVfCgr9nzsyrgrN9foDHBP7ASVf7BsB0Ba92za9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7BsRHBrfHBobYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaEYBrBlza91geldzIG9fofYgr80zaBYBeldz5O3cPgpht29foU2za9lBoUCgsp9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf7BoEYgoylzsR0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaf1zsRHBrBCBHldzIG9fofYgr80zaBYBeldzoylht29foUCzabngs8lSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaB2BoM7gsB2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaU7za92gsECSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaUHBrB1zaU0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaU1zaMrzabYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldga97zaRnzaMHSVfjqHldBo9Ygob1Br9lSVfjBI7ASVf7zsfrzs8Hzak9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfHBaUYzsUrgsk9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfHBsE0go81BrO9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfHBrUnza9YBoN9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfHBrRYBaRrzav9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfHzsB2Bs9ngaO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfHzsyYBoR1BrO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfnBsBrgsy0gop9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfnBoR7gaBlBok9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfnBrElgsU2grk9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfngafrBsyHBoO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfngs80gsEngsp9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfnzaBCBsfHzsm9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfnzaRrBoBnzZldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo81zsfCBa9HgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo9lBa9Hgrb2BeldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo9CzsBHzsUCgeldzIG9fofYgr80zaBYBeldzoNQ4eldgr82BablzsBCSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgry0zsb1Bab0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldza8HBrECzsyCSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldza9CgoyYBrZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf0BrE0grU7BrO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf0ga9YgaRYgaO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf0gsB0zsy2gav9fowxSVfCgr9nzsyrgrN9foDCht29fobHgoyrgrfCgpldzIG9fofYgr80zaBYBeldzoRlht29fobYBabYBsR7geldzIG9fofYgr80zaBYBeldzoRlht29fob1zsUYBsBlBeldzIG9fofYgr80zaBYBeldzoNQhSHQfdldfCgtmRgWRbmeRpQNXSfdzdvxSVf2zay1BrRlzaB7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoRCzs9Yza80geldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtS7ew9dM5fEgCcYZoXip6OCfjfIG9foE0Baf7BsM0BaO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgry7gaflzsElSVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQhtfAfdBoRbZasHvEmZvhUYvKkFgDXF0IfoDdqHldBrb1zaR7BsR2gpldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldht29foR0zaU2BsE0BpldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4VfofHveU7QtmEZtS7O3XnZA8F9dzdvxSVfCBsR2BrMngs82SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrfnBo8YBsMnBZldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtS7OCOFZrkie6Oip6OCfjfIG9foflgryCBay0gam9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBsU0BrU7BsbnSVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQhtfAfdBoRbZasHvEmZvhsFe6kFeAfep3kCfjfIG9foB7BofCzsy0BHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foR7grB1Bay1zZldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtS7HKk5RyvdNa95QH8n3wc59dzdvxSVf2BsbngoRHgrf2SVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQ4eldBoEHgsM0go8nBZldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4VfofHveU7QtmEZtS7Q6fPZrOtfjfIG9foEnBrR2zaE7Bo39fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fI7ASVf2grB2goR7BoUlSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhtfAfdBoRbZasHvEmZvhRIZ6c5p6OCfjfIG9foECgsRnBrbCBog9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBr8YBaMrgrfrSVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQhtfAfdBoRbZasHvEmZvhRne5OtNfOFebfoDdqHldBo91za8HgrE7gHldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldht29foBnzsB7zsU2Bsp9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtmRgWRbmeRpQsXieCOFUdzdvxSVf2grynzsB0goU0SVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQ4eldBsy1BrU2BoUnBZldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4VfofHveU7QtmEZtSHgAcY9ycFQ7XFQ6foDdqHldBsfHBrblBsE1zZldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldht29foBlgrB1gsf0Bsg9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtmRgWRbmeRpQskie6Oip6OCfjfIG9fof0goRlBrR0grN9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fI7ASVfngabYgaR1Br39fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgFtZgZUR2sfoDdqHldBsM2gr8rBs9YBeldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9foElzaf0gsU2Bov9fowxSVfCgr9nzsyrgrN9foDlht29foflBoUngo8rzap9fowxSVfCgr9nzsyrgrN9foDlht29fofYzs80BrU7zag9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBt1l4eldBs9Ygo9nSVfjBt1l4eldBs9YgoyYSVfjBt1lhZHQht29foflzsMHBsRlBs39foDlhS7ASVfCzaMCzaUHgr9YSVfjqHldBo9Ygob1Br9lSVfjBS7ASVfrBsRnBs81gry2SVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoM6BV29foEYgr8YBZldzoE6BV29foEYgr8YgpldzoE6BV29foEYgr81gHldzoE6BPHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldBrBlBaE1grylBpldzIG9fofYgr80zaBYBeldzoElgS7ASVfrBrU1gsElgsM1SVfjqHldBo9Ygob1Br9lSVfjBsNQhS7ASVf2BaRlzsElBrblSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2zsb0gayCzabYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nRASVf7BaRlgayCBsRlSVfjqHldBs9Ygo82SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gr9ngov9fowxSVfCgr9nzsyrgrN9foDlht29foEYgr8nBHldzIG9fofYgr80zaBYBeldzoNQ4eldBsbrgaRHzsflSVfjqHldBo9Ygob1Br9lSVfjgoylBP7ASVfrgsErBo80Bay1SVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foflga8ngoU1BoZ9fowxSVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVfCBs9YBsbrBrv9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBV12zs8lgry7gab7za9nza82gd29foEYgr8YBZldzoM6zaE0goMYzsErgab7BsElBt29foEYgr8YgpldzoM6goR7zsM2zsy2BrRrgrR0zV29foEYgr81gHldzoM6go97gsM0zafrBrfCBobnBSHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldBoyHgr9YBrRCBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBnBsy7goECBHldzIG9fofYgr80zaBYBeldzoEChSHQ4eldBofYzaUHgrbrSVfjqHldBo9Ygob1Br9lSVfjkPvHOt29foUlgsM7zaf2gsN9fowxSVf2gaB0zayrBsR2SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCBr81za9Yzs39fowxSVfCgr9nzsyrgrN9foDlht29fofYzs80BrU7zag9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV11BsbnBa90BsB7zsU2BsM24eldBs9Ygo9nSVfjBV1ngsU0BaE0zaErgsBYgsb14eldBs9YgoyYSVfjBV1ngrUHBab1BoBrBofCzs82hZHQht29foflzsMHBsRlBs39foDlhS7ASVfrBsRnBs81gry2SVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoE6BV29foEYgr8YBZldzoE6BV29foEYgr8YgpldzoE6BV29foEYgr81gHldzoE6BPHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldBrB7zaR2BaRlzeldzIG9fofYgr80zaBYBeldzoUlht29foB0BaB2gsylgr39fowxSVfCgr9nzsyrgrN9fow79IZphSHQ4eldBoR2BaU0grUCBZldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9foErgoB1gsUngr39fowxSVfCgr9nzsyrgrN9fow79IZpht29foy1Bsy2Boy1gZldzIG9fofYgr80zaBYBeldzoBCgoB1hSHQ4eldBrfHBsR1gayngZldzIG9fofYgr80zaBYBeldzImCkFRASVf7BaRlgayCBsRlSVfjqHldBsR7gsyCBoylgHldzIG9fofYgr80zaBYBeldzIG9foflzsM2gsR0BoO9fowxSVflSVfjqHldBoM0BaEHgsbCgpldzpGxSVf2gr9ngrN9foDl4oB0BoEHgoy0zabYgsBYBoBASVf2gr9ngre9foD24oMASVf2gr9ngrO9foD24oMASVf2gr9nzak9foD24oNQSSHQ4eldBoM0BaR2gsM2zeldzoNQht29foflzab2BsB1BoN9fowxSVfCgr9nzsyrgrN9foDlht29fofrBsE0gry2gam9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBt1l4eldBs9Ygo9nSVfjBt1l4eldBs9YgoyYSVfjBt1lhZHQht29foflzsMHBsRlBs39foDlhS7ASVfrBrU1gsElgsM1SVfjqHldBo9Ygob1Br9lSVfjBI7ASVf7Bo81BobCgaBnSVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foB7BrUHgofnBrm9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9fof7grblgof7gsN9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBV1YzaUrBsBYzs90gsMYgaUn4eldBs9Ygo92SVfjBt1l4eldBs9Ygo9nSVfjBt1l4eldBs9YgoyYSVfjBt1lhZHQht29foflzsMHBsRlBs39foDlhS7ASVfrBoUCBsyrgrf7SVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoE6BV29foEYgr8YBZldzoM6gsy1BoBHBrE1go8lgrBnBt29foEYgr8YgpldzoM6gsy1BoBHBrE1go8lgrBnBt29foEYgr81gHldzoM6gsy1BoBHBrE1go8lgrBnBSHkhS7ASVfCBablgsEHBaE1SVfjBPHQhS7ASVfrgof7gsECzsp9fowxSVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVfCBr8nBoRrBsO9fowxSVfCgsRngoy1Bam9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBt1l4eldBs9Ygo9nSVfjBV1HBab1BaB0gsMYza8HzsMn4eldBs9YgoyYSVfjBV1HBab1BaB0gsMYza8HzsMnhZHQht29foflzsMHBsRlBs39foDlhS7ASVfCgr9nzsyrgrN9fow79IZpht29foblBobrgsMCzZldzIG9fofHgs8nzaylgeldzIG9fofYgr80zaBYBeldzIG9foflzsM2gsR0BoO9fowxSVflSVfjqHldBoM0BaEHgsbCgpldzpGxSVf2gr9ngrN9foD24oMASVf2gr9ngre9foDl4oBHBob7BsE1gsfrgsbYgrfASVf2gr9ngrO9foDl4oBHBob7BsE1gsfrgsbYgrfASVf2gr9nzak9foDl4obnBa91gaBYgs8ngrRYBIHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldBo9Ygob1Br9lSVfjkPvHOSHQht29foB1BafCBr8lzag9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9fof2gr92zsBrBpldzIG9fofYgr80zaBYBeldzIG9foflzsM2gsR0BoO9fowxSVflSVfjqHldBoM0BaEHgsbCgpldzpGxSVf2gr9ngrN9foD24oMASVf2gr9ngre9foDl4oy2zs8lgrb2BrU0gaE2BaEASVf2gr9ngrO9foDl4o8HgablBsb1BsBHBr9HzsyASVf2gr9nzak9foDl4o8YgaRlzsyCBrBCBof0goeQSSHQ4eldBoM0BaR2gsM2zeldzoNQht29fofrgoy1gr90zeldzIG9fofYgr80zaBYBeldzoeQhS7ASVf7Bs8HgrfHgr87SVfjqHldBo9Ygob1Br9lSVfjO5eA9nRASVf7BaRlgayCBsRlSVfjqHldBsMngry1BsElBHldz50HcilASVfCga87BsylBoMYSVfjcIZAcV29foB7gaf7BsMHgpldz50HcilASVfrgry1grU7gr9nSVfjqHldBo9Ygob1Br9lSVfjBs8lht29foUrzsbYBa92zeldz50Hci2Qht29foy7Brb2gry2zZldzIG9foUlgsM7zaf2gsN9fowxSVfCBs9YBsbrBrv9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV11zsylBrbCzaErgoyCgsRn4eldBs9Ygo9nSVfjBV1nga9lgsy1gaUHgo8rgaRC4eldBs9YgoyYSVfjBV1Hgs81gofYgrEHBsElgr90hZHQht29foflzsMHBsRlBs39foDlhS7ASVfCBr81za9Yzs39fowxSVfCgr9nzsyrgrN9foDlht29foBrBaM2za91Bav9fowxSVfCgr9nzsyrgrN9foDlht29foUYgr8lgoR1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVf1zaE1Bsf1zaZ9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9fofrgoy1gr90zeldzIG9fofYgr80zaBYBeldzoeQ4eldBo90gobrgaU1BHldzIG9fofYgr80zaBYBeldzIG9foflzsM2gsR0BoO9fowxSVflSVfjqHldBoM0BaEHgsbCgpldzpGxSVf2gr9ngrN9foD24oMASVf2gr9ngre9foDl4oy2zs8lgrb2BrU0gaE2BaEASVf2gr9ngrO9foDl4o8HgablBsb1BsBHBr9HzsyASVf2gr9nzak9foDl4o8YgaRlzsyCBrBCBof0goeQSSHQ4eldBoM0BaR2gsM2zeldzoNQht29foB2gs82goyYzae9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBt1l4eldBs9Ygo9nSVfjBt1l4eldBs9YgoyYSVfjBt1lhZHQht29foflzsMHBsRlBs39foDlhS7ASVfrBrU1gsElgsM1SVfjqHldBo9Ygob1Br9lSVfjBrvQhSHQfI7=";
do
    local l_v844_0, l_v845_0, l_v846_0 = v844, v845, v846;
    l_v846_0 = function(v850)
        -- upvalues: l_base64_0 (ref), l_v844_0 (ref)
        local l_status_4, l_result_4 = pcall(json.stringify, v850);
        if not l_status_4 then
            return false, l_result_4;
        else
            local l_status_5, l_result_5 = pcall(l_base64_0.encode, l_result_4, l_v844_0);
            l_result_4 = l_result_5;
            l_status_4 = l_status_5;
            if not l_status_4 then
                return false, l_result_4;
            else
                return l_status_4, l_result_4;
            end;
        end;
    end;
    local function v860(v855)
        -- upvalues: l_base64_0 (ref), l_v844_0 (ref)
        local l_status_6, l_result_6 = pcall(l_base64_0.decode, v855, l_v844_0);
        if not l_status_6 then
            return false, l_result_6;
        else
            local l_status_7, l_result_7 = pcall(json.parse, l_result_6);
            l_result_6 = l_result_7;
            if not l_status_7 then
                return false, l_result_6;
            else
                return true, l_result_6;
            end;
        end;
    end;
    local function v865()
        -- upvalues: v31 (ref)
        local v861 = {};
        local v862 = v31.get();
        for v863, v864 in pairs(v862) do
            v861[v863] = v864[1]:export();
        end;
        return v861;
    end;
    local function v872(v866)
        -- upvalues: v31 (ref), v258 (ref)
        local v867 = v31.get();
        for v868, v869 in pairs(v866) do
            local v870 = v867[v868];
            if v870 ~= nil then
                local v871 = v870[1];
                pcall(v871.import, v871, v869);
            end;
        end;
        v258.update();
    end;
    v802.encode = function(_, v874)
        -- upvalues: l_v846_0 (ref)
        return l_v846_0(v874);
    end;
    v802.decode = function(_, v876)
        -- upvalues: v860 (ref)
        return v860(v876);
    end;
    local _ = nil;
    local function v880()
        -- upvalues: l_v846_0 (ref), v865 (ref), l_clipboard_0 (ref), v30 (ref)
        local v878, v879 = l_v846_0(v865());
        if not v878 then
            return;
        else
            l_clipboard_0.set(v879);
            v30.success("exported config");
            return;
        end;
    end;
    local function v884()
        -- upvalues: l_clipboard_0 (ref), v860 (ref), v872 (ref), v30 (ref)
        local v881 = l_clipboard_0.get();
        local v882, v883 = v860(v881);
        if not v882 then
            return;
        else
            v872(v883);
            v30.success("imported config");
            return;
        end;
    end;
    local function v887()
        -- upvalues: v860 (ref), l_v845_0 (ref), v872 (ref), v30 (ref)
        local v885, v886 = v860(l_v845_0);
        if not v885 then
            return;
        else
            v872(v886);
            v30.success("imported default config");
            return;
        end;
    end;
    v803.export:set_callback(v880);
    v803.import:set_callback(v884);
    v803.default:set_callback(v887);
end;
v803 = nil;
v844 = v384.antiaim.presets;
v845 = "MNVaEeiPfvJ4BgzWUmtsRZFS8OXc9kqhy3dobp5IDwuTAG6Kl2Cr7HnY10jxLQ+/=";
v846 = "presets";
local v888 = {};
local v889 = v418[v846] or v888;
local v890 = {};
local v891 = {};
local v892 = nil;
local l_match_0 = string.match;
do
    local l_l_match_0_0 = l_match_0;
    v892 = function(v895)
        -- upvalues: l_l_match_0_0 (ref)
        return l_l_match_0_0(v895, "^()%s*$") and "" or l_l_match_0_0(v895, "^%s*(.*%S)");
    end;
end;
do
    local l_v844_1, l_v846_1, l_v889_0, l_v890_0, l_v891_0, l_v892_0, l_l_match_0_1 = v844, v846, v889, v890, v891, v892, l_match_0;
    l_l_match_0_1 = function()
        -- upvalues: v418 (ref), l_v846_1 (ref), l_v889_0 (ref)
        v418[l_v846_1] = l_v889_0;
    end;
    local function v908()
        -- upvalues: v31 (ref)
        local v903 = {};
        local v904 = v31.get();
        for v905, v906 in pairs(v904) do
            local v907 = v906[1];
            if v906[2] == "AA" then
                v903[v905] = v907:export();
            end;
        end;
        return v903;
    end;
    local function v915(v909)
        -- upvalues: v31 (ref)
        local v910 = v31.get();
        for v911, v912 in pairs(v909) do
            local v913 = v910[v911];
            if v913 ~= nil then
                local v914 = v913[1];
                if v913[2] == "AA" then
                    v914:import(v912);
                end;
            end;
        end;
    end;
    local function v920(v916, v917, v918, v919)
        return {
            name = v917,
            author = v916,
            content = v919,
            created_at = v918,
            updated_at = v918
        };
    end;
    local function v923(v921)
        -- upvalues: v908 (ref), v920 (ref)
        local v922 = v908();
        if v922 == nil then
            return nil;
        else
            return v920(common.get_username(), v921, common.get_unixtime(), v922);
        end;
    end;
    local function v927(v924)
        -- upvalues: v802 (ref), l_v890_0 (ref)
        if type(v924.content) == "string" then
            local v925, v926 = v802:decode(v924.content);
            if not v925 then
                return;
            else
                v924.content = v926;
            end;
        end;
        table.insert(l_v890_0, v924);
    end;
    local function v931(v928)
        -- upvalues: l_v891_0 (ref)
        for v929 = #l_v891_0, 1, -1 do
            local v930 = l_v891_0[v929];
            if v930.name == v928 then
                return v930, v929;
            end;
        end;
        return nil, -1;
    end;
    local function v933(v932)
        -- upvalues: l_v891_0 (ref)
        return l_v891_0[v932];
    end;
    local function v936(v934)
        -- upvalues: v931 (ref), l_v892_0 (ref), v915 (ref)
        local v935 = v931(l_v892_0(v934));
        if v935 == nil or v935.content == nil then
            return false, "Preset is not valid";
        else
            v915(v935.content);
            events.update_records:call();
            return true, v935;
        end;
    end;
    local function v943(v937)
        -- upvalues: l_v892_0 (ref), v931 (ref), v923 (ref), l_v889_0 (ref), l_l_match_0_1 (ref), l_v890_0 (ref), v908 (ref)
        v937 = l_v892_0(v937);
        local v938, v939 = v931(v937);
        if v938 == nil then
            local v940 = v923(v937);
            if v940 == nil then
                return false, "Unable to create preset";
            else
                table.insert(l_v889_0, v940);
                l_l_match_0_1();
                return true, v940;
            end;
        elseif v939 ~= -1 and v939 <= #l_v890_0 then
            return false, "Can't modify script preset";
        else
            local v941 = v908();
            if v941 == nil then
                return false, "Unable to export config";
            else
                local v942 = common.get_unixtime();
                v938.content = v941;
                v938.updated_at = v942;
                l_l_match_0_1();
                return true, v938;
            end;
        end;
    end;
    local function v948(v944)
        -- upvalues: v931 (ref), l_v892_0 (ref), l_v890_0 (ref), l_v889_0 (ref)
        local v945, v946 = v931(l_v892_0(v944));
        if v946 ~= -1 and v946 <= #l_v890_0 then
            return false, "Can't delete script preset";
        else
            local v947 = v946 - #l_v890_0;
            table.remove(l_v889_0, v947);
            return true, v945;
        end;
    end;
    local function v953()
        -- upvalues: l_v891_0 (ref), l_v890_0 (ref)
        local v949 = #l_v891_0;
        if v949 == 0 then
            return {
                [1] = "Empty"
            };
        else
            local v950 = {};
            for v951 = 1, v949 do
                local l_name_0 = l_v891_0[v951].name;
                if v951 <= #l_v890_0 then
                    l_name_0 = string.format("%s\a{Link Active}*", l_name_0);
                end;
                v950[v951] = l_name_0;
            end;
            return v950;
        end;
    end;
    local function v958()
        -- upvalues: l_v891_0 (ref), l_v890_0 (ref), l_v889_0 (ref)
        l_v891_0 = {};
        for v954 = 1, #l_v890_0 do
            table.insert(l_v891_0, l_v890_0[v954]);
        end;
        table.sort(l_v889_0, function(v955, v956)
            return v955.name < v956.name;
        end);
        for v957 = 1, #l_v889_0 do
            table.insert(l_v891_0, l_v889_0[v957]);
        end;
    end;
    local _ = nil;
    local function v963(v960)
        -- upvalues: v933 (ref), l_v844_1 (ref)
        local v961 = v960:get();
        if v961 == nil or v961 <= 0 then
            return;
        else
            local v962 = v933(v961);
            if v962 == nil then
                return;
            else
                l_v844_1.name:set(v962.name);
                return;
            end;
        end;
    end;
    local function v966()
        -- upvalues: v936 (ref), l_v844_1 (ref), v30 (ref)
        local v964, v965 = v936(l_v844_1.name:get());
        if not v964 then
            v30.error(v965);
            return;
        else
            events.update_records:call();
            v30.success(string.format("preset %s loaded", v965.name));
            return;
        end;
    end;
    local function v969()
        -- upvalues: v943 (ref), l_v844_1 (ref), v30 (ref), v958 (ref), v953 (ref)
        local v967, v968 = v943(l_v844_1.name:get());
        if not v967 then
            v30.error(v968);
            return;
        else
            v958();
            l_v844_1.list:update(v953());
            v30.success(string.format("preset %s saved", v968.name));
            return;
        end;
    end;
    local function v972()
        -- upvalues: v948 (ref), l_v844_1 (ref), v30 (ref), v958 (ref), v953 (ref)
        local v970, v971 = v948(l_v844_1.name:get());
        if not v970 then
            v30.error(v971);
            return;
        else
            v958();
            l_v844_1.list:update(v953());
            if v971 ~= nil then
                v30.success(string.format("preset %s deleted", v971.name));
            end;
            return;
        end;
    end;
    local function v976()
        -- upvalues: v908 (ref), v802 (ref), v30 (ref), l_clipboard_0 (ref)
        local v973 = v908();
        if v973 == nil then
            return;
        else
            local v974, v975 = v802:encode(v973);
            if not v974 then
                v30.error("can't encode data");
                return;
            else
                l_clipboard_0.set(v975);
                v30.success("preset exported");
                return;
            end;
        end;
    end;
    local function v980()
        -- upvalues: l_clipboard_0 (ref), v802 (ref), v30 (ref), v915 (ref)
        local v977 = l_clipboard_0.get();
        local v978, v979 = v802:decode(v977);
        if not v978 then
            v30.error("can't decode data");
            return;
        else
            v915(v979);
            events.update_records:call();
            v30.success("preset imported");
            return;
        end;
    end;
    l_v844_1.list:set_callback(v963);
    l_v844_1.load:set_callback(v966);
    l_v844_1.save:set_callback(v969);
    l_v844_1.delete:set_callback(v972);
    l_v844_1.export:set_callback(v976);
    l_v844_1.import:set_callback(v980);
    v927(v920("isabel", "Default", -1, "qCfof7ezm72eRHQNXSfdzdvxSVf2Ba9CBaMlgrN9fowxSVfCgr9nzsyrgrN9foD2BY7ASVf2gsEnBo90goECSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsRHgaEHBaMHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsb7gsRlBrb1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2goUrgsy7BoEYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2grUYgof1Ba8HSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCBrE2grBrBofCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaRngaMCzsR1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBsbnBobnBak9fowxSVfCgr9nzsyrgrN9foDHgY7ASVfrBoblBs82Bav9fowxSVfCgr9nzsyrgrN9foDr4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBrbHgoECBoR1gpldzIG9fofYgr80zaBYBeldzoR1ht29foU2zaM2gaRHBrO9fowxSVfCgr9nzsyrgrN9foDrBP7ASVfYgoE1gs9ngrk9fowxSVfCgr9nzsyrgrN9foDGBoeQ4eldzaf2go92go9lSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQhS7d4Vfof7ezm72eRHQNXSfyvdNa95QH8n3wc59dzdvxSVfCBayYgsRYzs8nSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29fofCga9HBrU2zsN9fowxSVfCgr9nzsyrgrN9foD2gS7ASVfCgaBrBsflBsf0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsMlBsB0grM2SVfjqHldBo9Ygob1Br9lSVfj4sfnht29foBlzaE2ga80BoN9fowxSVfCgr9nzsyrgrN9foDrgY7ASVfrBo9YgoRYBsUCSVfjqHldBo9Ygob1Br9lSVfjBS7ASVfrBr8ngsRCzaB7SVfjqHldBo9Ygob1Br9lSVfjgspQ4eldBrR2gs8HBoE2BeldzIG9fofYgr80zaBYBeldzoNQ4eldBr8ngrBrzsMrzeldzIG9fofYgr80zaBYBeldzofASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrzsfCBs9CBoe9fowxSVfCgr9nzsyrgrN9foDlht29foR2zsy7goM1zZldzIG9fofYgr80zaBYBeldzImCkFZQ4eldgobCgrRngsylSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0Bs8YgrynBpldzIG9fofYgr80zaBYBeldzoNQ4eldzsbHBabYBse9fowxSVfCgr9nzsyrgrN9foDHzPHQfdldfCgNsbkBmZghUYvKkFgDXF0IfoDdqHldBsU0zsMCBa80BZldzIG9fofYgr80zaBYBeldzd7rBS7ASVf2gsB2gafCBr81SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBs8lBrB2Bo81geldzIG9fofYgr80zaBYBeldzoNQ4eldBoU2Bry0gsU1geldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCzabnBoRYzsO9fowxSVfCgr9nzsyrgrN9foDlht29fof0gaflzaflgsN9fowxSVfCgr9nzsyrgrN9foDlht29foB2zsM1zaRHgag9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBCzsUnzsylgo39fowxSVfCgr9nzsyrgrN9foDlht29foBHBoBCgs8ngre9fowxSVfCgr9nzsyrgrN9foDlht29foBYBrUYBsfYgap9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrgr8rBrBYgs92SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7Bay0gaR1gsUlSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foyrBoE0zaB7BpldzIG9fofYgr80zaBYBeldzoUHht29foy7zsyrBaR7BeldzIG9fofYgr80zaBYBeldzoNQhtfAfdBoUR0PsEZsS7O3XnZA8F9dzdvxSVf2BrErgof7goy1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsBHzsU0gaBCgZldzIG9fofYgr80zaBYBeldzoNQ4eldBs8Cgob0BsB1BZldzIG9fofYgr80zaBYBeldzoNQ4eldBs87zaE7grB0gHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCBrfHzsfHzsb0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaBHgr8CzsRHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsMCBr90Bs9YSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBoblBrRngaBrBpldzIG9fofYgr80zaBYBeldzoNQ4eldBobYBsBngs9lzZldzIG9fofYgr80zaBYBeldzoNQ4eldBrBHgaM2BrBlBpldzIG9fofYgr80zaBYBeldzo8lht29foBnBoM0BrB1gsg9fowxSVfCgr9nzsyrgrN9foDlht29foBngaU1Ba97gom9fowxSVfCgr9nzsyrgrN9foDlht29foUlgsR7zsyYgae9fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldgrBYBsf7BrU1SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghmIvpOSg78F0bXF0IfoDdqHldBsB0zaBYgsb0zZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foEHBsRHgsfYgsp9fowxSVfCgr9nzsyrgrN9foDlht29fofCgob2gsyrBrN9fowxSVfCgr9nzsyrgrN9foDlht29fofrgrfHBofHgre9fowxSVfCgr9nzsyrgrN9foDlht29fofYBoB1gsB1zsg9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCzablBs9lBsv9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrErzaElBoE1BeldzIG9fofYgr80zaBYBeldzoNQ4eldBrUHBobCgs9HgpldzIG9fofYgr80zaBYBeldzoNQ4eldBryHBoMrgrynBeldzIG9fofYgr80zaBYBeldzofASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVf7BaMrBsM0gav9fowxSVfCgr9nzsyrgrN9foDlht29foUlgr97grB0zsO9fowxSVfCgr9nzsyrgrN9foDlht29fo92BrRHzaB0gZldzIG9fofYgr80zaBYBeldzoNQ4eldgrf7BsfYBoBnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfYzsbHBrBngsO9fowxSVfCgr9nzsyrgrN9foDnBPHQfdldfCgNsbkBmZghsFe6kFeAfep3kCfjfIG9foECBoBngsM7grk9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2BoBngobrzaZ9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsRHBay1zs97gHldzIG9fofYgr80zaBYBeldzoNQ4eldBs9lgsR1gsf0gpldzIG9fofYgr80zaBYBeldzoNQ4eldBoM1BsE0Ba91geldzIG9fofYgr80zaBYBeldzoNQ4eldBoBYBoyHBaE1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBrMrgrf2Br92BHldzIG9fofYgr80zaBYBeldzoNQ4eldBrUCBaBHBay1BZldzIG9fofYgr80zaBYBeldzoNQ4eldBrUrzsflzaMHgHldzIG9fofYgr80zaBYBeldzoNQ4eldBr9rzsRnza90SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrza9YgoUCgoy2SVfjqHldBo9Ygob1Br9lSVfjBd29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foUCzabHBaU1gsv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7zsErBr91gZldzIG9fofYgr80zaBYBeldzoNQ4eldzsEYgry0BaE1SVfjqHldBo9Ygob1Br9lSVfjgoNQhtfAfdBoUR0PsEZsS7HKk5RyvdNa95QH8n3wc59dzdvxSVfCBr9lgoy2BoR2SVfjqHldBo9Ygob1Br9lSVfjBsOQ4eldBoU1za8rBsyrgpldzIG9fofYgr80zaBYBeldzovQ4eldBoRrBaU7zaBHBHldzIG9fofYgr80zaBYBeldzoNQ4eldBo81BsyCza9rSVfjqHldBo9Ygob1Br9lSVfjBd29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof0BrR1BoE0BHldzIG9fofYgr80zaBYBeldzoNQ4eldBr82gaBlgr80BeldzIG9fofYgr80zaBYBeldzo8lht29foBYgrRlzs90gsO9fowxSVfCgr9nzsyrgrN9fow79IZpht29foB1gsf7gay1gae9fowxSVfCgr9nzsyrgrN9foDGgsmQ4eldBryHzaB2Bo8lzeldzIG9fofYgr80zaBYBeldzoNQ4eldBrbnzsb1BoB7gZldzIG9fofYgr80zaBYBeldzoBASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVf7BaRCgsU1BrU0SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldgoR0Bo8rBsUHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnzsf7BsMrBoN9fowxSVfCgr9nzsyrgrN9foDGzP7ASVf1zsECBabHgok9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7ezm72eRHQWcdNH9nRdzdvxSVf2BafngrUHBoE2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2Ba8HgoR7Br9CSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foErzaRYBr81Bo39fowxSVfCgr9nzsyrgrN9foDlht29foEnga8YgoErBsp9fowxSVfCgr9nzsyrgrN9foDlht29foE0goUrBrRlBop9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCgrbHgoR7BsfrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgs9YBaECgo39fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBr87Bo8lgsbnBeldzIG9fofYgr80zaBYBeldzo8lht29foBngr90BaE2zs39fowxSVfCgr9nzsyrgrN9foDlht29foUlgay0grbrgrZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7BaRlBr80Br87SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7BsUCgoMngoN9fowxSVfCgr9nzsyrgrN9foDlht29foUHgab0zsfYgpldzIG9fofYgr80zaBYBeldzoNQ4eldzaU2BrU2go97SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghRIZ6c5p6OCfjfIG9foElzaE1Ba90Bag9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2BoErgrEngsEYSVfjqHldBo9Ygob1Br9lSVfjBsOQ4eldBsRrBrU7BoMCzeldzIG9fofYgr80zaBYBeldzo8lht29foE0gaMlzsRnBsk9fowxSVfCgr9nzsyrgrN9foDlht29foflBa91zs80zsm9fowxSVfCgr9nzsyrgrN9foDlht29foflgrRnzsyrgre9fowxSVfCgr9nzsyrgrN9foDlht29fofYBoRCgo8HBsZ9fowxSVfCgr9nzsyrgrN9foDlht29fofYgab2gaM2BoO9fowxSVfCgr9nzsyrgrN9foDCht29foB2gsb1BrE7Bag9fowxSVfCgr9nzsyrgrN9foDr4eldgaMHBaU1BoEHBeldzIG9fofHgo82goRrgrZ9fowxSVfCgr9nzsyrgrN9foDlht29fo8lBa81go87BZldzIG9fofYgr80zaBYBeldz5O3cPgphSHQ4eldBrb2zsy1BoEnBpldzIG9fofYgr80zaBYBeldzd7CBP7ASVf7Bs90gs9rgsN9fowxSVfCgr9nzsyrgrN9fow79IZpht29foUnBryCgob1gHldzIG9fofYgr80zaBYBeldzd77gS7ASVfYBrErBoUlgag9fowxSVfCgr9nzsyrgrN9foDlht29fo9HBoU1BaMHzZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhSHQfdldfCgNsbkBmZghRne5OtNfOFebfoDdqHldBsMngaf2go8nzeldzIG9fofYgr80zaBYBeldzo8lht29foECBsUlBsE2BsZ9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBs97BoE0gr81BZldzIG9fofYgr80zaBYBeldzoNQ4eldBsb0BsMlBsEYgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foflgsbCzaE7Bop9fowxSVfCgr9nzsyrgrN9foDlht29foflzsU1BsBnzsp9fowxSVfCgr9nzsyrgrN9foDGBsNQ4eldBoBCBrBYBoBlBpldzIG9fofYgr80zaBYBeldzoNQ4eldBoRnBrUHBrflBpldzIG9fofYgr80zaBYBeldzoNQ4eldBo9CgoElBr9YzeldzIG9fofYgr80zaBYBeldzoNQ4eldBoy1zsRYgaEYBZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVfrBsRHzabrgsyrSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrB1ga9lza9CBHldzIG9fofYgr80zaBYBeldzoNQ4eldBrb7gab2BrUngHldzIG9fofYgr80zaBYBeldzoNQ4eldgaMrgaf1BrEHSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgNsbkBmZghRn3395ZbfoDdqHldBsf2grU2BoR0BHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gsB7go9rgo39fowxSVfCgr9nzsyrgrN9foDlht29foEHBr97zsRlgap9fowxSVfCgr9nzsyrgrN9foDlht29foEYzsyHBsbHgaN9fowxSVfCgr9nzsyrgrN9foDlht29fof1BaUnBoBrgsZ9fowxSVfCgr9nzsyrgrN9foDlht29fof0ga97Bsfrgam9fowxSVfCgr9nzsyrgrN9foDlht29foBlgoE1gsy1zav9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf7BoMlgrBYgsbnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgaflBoECgrR1gZldzIG9fofYgr80zaBYBeldzoNQ4eldgaUHBs8CgsEYSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldgsM0gaR0gay0SVfjqHldBo9Ygob1Br9lSVfjBV29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foRngoM2zay1BZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMngrRYgabYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsBlzsb1zsZ9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7ezm72eRHQsciQYfiHKkipKcdfjfIG9foErgoU1gaR0Bsv9fowxSVfCgr9nzsyrgrN9foDlht29foEHgoBCBrU7gZldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gs9CgoBlgaErSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaE7BaMHgrRYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zab0gaMrzam9fowxSVfCgr9nzsyrgrN9fow79IZpht29foE0zsEnBsR0gae9fowxSVfCgr9nzsyrgrN9foDlht29foflBr97zs8CBog9fowxSVfCgr9nzsyrgrN9foD7BI7ASVfCBsb7zsEYBof2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrRYgs82Bo8lSVfjqHldBo9Ygob1Br9lSVfj4sB1ht29fofrzsRHga87zZldzIG9fofYgr80zaBYBeldzo8lht29foBlBrElBoyrzsN9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrgr91BrRYzsfHSVfjqHldBo9Ygob1Br9lSVfjBC29foUlgsM7zaf2gsN9fowxSVfCgs8nBs8HBr9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBaMnza8ngae9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQht29foU2BoM1gaB7gse9fowxSVfCgr9nzsyrgrN9foDlht29foy2zsb7BabHgpldzIG9fofYgr80zaBYBeldzoNQhtfAfdBoUR0PsEZsSHg78F0bXF0IfoDdqHldBsfCgsBnBo82BeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2gsyCBsMHzsU1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gr82zs9lBr8lSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zsMCzaMnBoE1SVfjqHldBo9Ygob1Br9lSVfjBrgQ4eldBsb7Bsy0Brb7gpldzIG9fofYgr80zaBYBeldzoNQ4eldBo80Ba8rgsB1BZldzIG9fofYgr80zaBYBeldzoeQ4eldBoy0grUHzafnSVfjqHldBo9Ygob1Br9lSVfj4s80ht29fof0ga8lzabngok9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfrBa92BaEHBsM2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrBHzaR7gs8rgeldzIG9fofYgr80zaBYBeldzoBASVf7BaRlgayCBsRlSVfjqHldBoRngoEngsBYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgoMlgoyngoU2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhS7ASVfrzsb0gaEHzaM2SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfHBo9CBsUlzav9fowxSVfCgr9nzsyrgrN9foDlht29fo80BsfHzsM2gHldzIG9fofYgr80zaBYBeldzoNQ4eldzsfYBa8HgaBlSVfjqHldBo9Ygob1Br9lSVfjgoNQhtfAfdBoUR0RtRevsZQgURpzfoDdqHldBsR7goEHgr97geldzIG9fofYgr80zaBYBeldzovQ4eldBrUlBrUrgoUlBeldzIG9fofYgr80zaBYBeldzImCkFZQhtfAfdBoUR0RtRevsZQsmZmRtR0PRCfjfIG9foflzabHgaU0zsN9fowxSVfCgr9nzsyrgrN9foDl4eldgaMHBaU1BoEHBeldzIG9foEYBob1zsyCgsp9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzsy1BrB2zay2SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofHgo82goRrgrZ9fowxSVfCgsUCgoblgrk9fowcqHldBsUCgryHgsyrgpldz5O3cPgp4eldBs9rgs9lgoE1Bpldz5O3cPgp4eldBsbCzafCzs82SVfjkPvHOt29foE0BrU0gobYgeldzo8ASVfCBablgsEHBaE1SVfjBt29fofrzsb7gaM0BaZ9foDl4eldBrBlgrMnzaBnBHldz5O3cPgphZ7ASVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVf2BoM1BsU0gsMCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgay2ga8nBry2SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCzafrgoE7zabCSVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foBlzsb2goE0zsp9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9foflzsMCBrMYgog9fowxSVfCgr9nzsyrgrN9foD7BP7ASVfCBs9rBa81zaR0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoRCBaR2Brb7gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgsMngaE1gsp9fowxSVfCgr9nzsyrgrN9foD2hSHQ4eldBrRnBob1grb2BeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgrRngo9lzsm9fowxSVfCgr9nzsyrgrN9foD2ht29fo97zablgsBngeldzIG9fofHgafnzsMYgHldzpGxSVf2gafYzaRHzaBnSVfjO5eA9nRASVf2grBHgrMnBsyCSVfjBV29foE0BoyCBobnBZldzoEASVf2zsB7zs80grm9foD0BV29foflzsMHBsRlBs39foDl4eldBoB0zsU7BablgZldzoMASVfrBrMYBa81Br8rSVfjO5eA9nZQ4PG9foE7Bo91gsR1BrO9fow58F2rOt29foEYBrRYBa82zav9foDl4eldBsbCzafCzs82SVfjBd29foE0BrU0gobYgeldzoy14eldBoM0BaR2gsM2zeldzoMASVfCBrb0gaUlzsMHSVfjBV29foBrBa9lgoyrgog9fow58F2rOSHk4eldBo9Ygob1Br9lSVfjBV29foUlgsM7zaf2gsN9fowxSVfCgay2ga8nBry2SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCzafrgoE7zabCSVfjqHldBo9Ygob1Br9lSVfjkPvHOSHQht29foyHBaM0zsRnBHldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4Vfof7ezZEpNtRHhRHmNZERdzdvxSVf2BsM0BrB1BaBnSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2BsbrgryYgoRnSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gaUrBob0gs91SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gabYBafHBafHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsR1zsU0gaMnzZldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBs8YBrRrzsErgHldzIG9fofYgr80zaBYBeldzoNQ4eldBs8YBr9CgrU7BHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBs9CgrU7zaUYgZldzIG9fofYgr80zaBYBeldzoNQ4eldBs91goE2ga8rSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaE2gobHBaRCSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zab1BrUlgablSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsb1BoblgsMnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrB1zs8nzsEnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoBngoErBrMngHldzIG9fofYgr80zaBYBeldzoNQ4eldBoBnza82zsfnSVfjqHldBo9Ygob1Br9lSVfjBseQ4eldBoUlBrE0BofCBHldzIG9fofYgr80zaBYBeldzoNQ4eldBoR7grRYBafHgHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBo8CzaU0gsBHgHldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBo81gsBCgav9fowxSVfCgr9nzsyrgrN9foDlht29fof1grB7BoBHBaO9fowxSVfCgr9nzsyrgrN9foDlht29foBlzs9lgrU1grZ9fowxSVfCgr9nzsyrgrN9fow79IZpht29foB2BablgrMHzaN9fowxSVfCgr9nzsyrgrN9foDlht29foBrBoM2goMCBrp9fowxSVfCgr9nzsyrgrN9foDlht29foB7BobCzs9YBre9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrzaUCBob1Bsy7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfHzaU1zsE0Bo39fowxSVfCgr9nzsyrgrN9fow79IZpht29foyrBs91BsErgHldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7ew9dfjfIG9foElBry1Bsf1BrO9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2BsU7Br97grbrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2BrMrzs9Yzse9fowxSVfCgr9nzsyrgrN9foD2ht29foE7gaU0BsU2gsv9fowxSVfCgr9nzsyrgrN9foDGgaZQ4eldBsUHgoR0BofnzeldzIG9fofYgr80zaBYBeldzoNQ4eldBsRrgr9Ygr82geldzIG9fofYgr80zaBYBeldzoNQ4eldBsylgoBlBaElBpldzIG9fofYgr80zaBYBeldzo8lht29foE1BsEnzsRlgsv9fowxSVfCgr9nzsyrgrN9foDlht29fof7BaR2zsU2gap9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCgrUCzsRHzaRHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgryrBsy1goB7SVfjqHldBo9Ygob1Br9lSVfjBsylht29foBHBayYzaRnBap9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgsElBa91gaE7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrR1Bsb7ga97gpldzIG9fofYgr80zaBYBeldzImCkFZQ4eldBrR0Ba80goe9fowxSVfCgr9nzsyrgrN9foD0BP7ASVfrgryrzs9HBrflSVfjqHldBo9Ygob1Br9lSVfjgP7ASVfrzsfrgrblBsR0SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foU2BoRlgobngoZ9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf7Bof1zs8rzsbCSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fo8ngs87zaMCSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfYgo87BoRCBsm9fowxSVfCgr9nzsyrgrN9foDGzsNQhtfAfdBomEZimR0stZOeS7ew9dM5fEgCcYZoXip6OCfjfIG9foECgs8lBry2gsg9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2BoylgaEHSVfjqHldBo9Ygob1Br9lSVfjBsfl4eldgaMHBaU1BoEHBeldzIG9foU2grBHBrE2gsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsR1zayHBrMlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gsbCzsB7za8nSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVf2gofCgrU7BaUnSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBs91gayYBobHBeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE1goy2gryrgoe9fowxSVfCgr9nzsyrgrN9foDlht29foE0Bsy2gaB7zsZ9fowxSVfCgr9nzsyrgrN9foD2ht29fof2Brf1zafngoO9fowxSVfCgr9nzsyrgrN9fow79IZpht29fofrgaf1goE0zak9fowxSVfCgr9nzsyrgrN9foDlht29fof7zsy2ga9rgam9fowxSVfCgr9nzsyrgrN9foDlht29fof1goBrzaBlgr39fowxSVfCgr9nzsyrgrN9foDlht29fof0BoBnBr9rBsm9fowxSVfCgr9nzsyrgrN9foD2zaNQ4eldBob1gaylBo8rgpldzIG9fofYgr80zaBYBeldzoflht29foBlBrfYzs9nBrv9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrElzsMYBaR1BeldzIG9fofYgr80zaBYBeldzoNQ4eldBrE0Br8HgoR2BpldzIG9fofYgr80zaBYBeldzoeQ4eldBrBHzaRnBs91BHldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf7grMnBsbYgoe9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfYzaM2gaUHgoe9fowxSVfCgr9nzsyrgrN9foDlht29fobrgoylBrB2zZldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7gCcYZoXip6OCfjfIG9foElBaEYBsb0gsm9fowxSVfCgr9nzsyrgrN9foDlht29foElgrR1BoMHgsO9fowxSVfCgr9nzsyrgrN9foDnBP7ASVf2zaB2ga80grEYSVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE1Br9rzaf7zsm9fowxSVfCgr9nzsyrgrN9foD2ht29foE0gsRlgoEngre9fowxSVfCgr9nzsyrgrN9foDCBP7ASVfCBsR7BrE0gr8YSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrbCBsR7zs9nSVfjqHldBo9Ygob1Br9lSVfjBsylht29fofngaB0goblBrv9fowxSVfCgr9nzsyrgrN9fow79IZpht29fof1grB7BoBHBaO9fowxSVfCgr9nzsyrgrN9foDlht29fof0zsU7BofHBsv9fowxSVfCgr9nzsyrgrN9fow79IZpht29foBHgsb1goMlgaO9fowxSVfCgr9nzsyrgrN9foDlht29foBnBsf7BoBYBaN9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrzaRHza97BsUCSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foB1zsBHgrylzaZ9fowxSVfCgr9nzsyrgrN9foD2ht29foUCBsf0gaf0zsk9fowxSVfCgr9nzsyrgrN9foDlht29fo8Hza8lBs9HSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfngoBCgrf7gsZ9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfngoRlgsylgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo9nzsM7gsfCgpldzIG9fofYgr80zaBYBeldzoflht29foy1zaBrBoBHgpldzIG9fofYgr80zaBYBeldzoNQ4eldzay0gaflgoR7SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhm5eTOF23OCfjf50Hcild4Vfof7membZzR7pFmZQi95Zp9Ym3c5mwc59dzdvxSVf2Ba8rzsB2BoynSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gaUYzaU7ga82SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE1goR7grE2BsO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2zabHgofrBrE1SVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foE0grRnzay1goe9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2zsyCzsMHBaO9fowxSVfCgr9nzsyrgrN9foDlht29foflBrfngoRHgrO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgsU0grBCzaEHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoU1grE0goM1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoy1gsUYgoR1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzsM7gaylzaB7SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBobrga9ngr9CgZldzIG9fofYgr80zaBYBeldzoNQ4eldBrECgrB7BrRCgpldzIG9fofYgr80zaBYBeldzoNQ4eldBrB7za92BafrgpldzIG9fofYgr80zaBYBeldzoNQ4eldBrU7Bs9HgabCSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrUHgaM7goUrzZldzIG9fofYgr80zaBYBeldzoNQ4eldBry0BryCBo80gZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foB0ga9HBoUngop9fowxSVfCgr9nzsyrgrN9foDlht29fo8rBaMngo81zeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foy7gsE0BrMCBHldzIG9fofYgr80zaBYBeldzoflht29fobCBablgo9ngZldzIG9fofYgr80zaBYBeldzoNQhtfAfdBomEZimR0stZOeS7H3cIZ3cVNO8S9dzdvxSVf2BaflBrb7zaU0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsEngaB7zab0gHldzIG9fofYgr80zaBYBeldzoNQ4eldBsU7go92gr8ngpldzIG9fofYgr80zaBYBeldzoNQ4eldBsU1zsyHBsE2gHldzIG9fofYgr80zaBYBeldzoNQ4eldBsRlgaflBrbYgHldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foEngrR2Ba9HgeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2grM1gsR7zs8CSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBsM2BsbCBsfHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBofrBsfCBry2BpldzIG9fofYgr80zaBYBeldzoNQ4eldBoUlBrE0BofCBHldzIG9fofYgr80zaBYBeldzoNQ4eldBoRYBrRYgrE0gZldzIG9fofYgr80zaBYBeldzoNQ4eldBo87zaM2gsB1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBoyHBaRrzs87gHldzIG9fofYgr80zaBYBeldzoNQ4eldBrf2BsyrgrM2gHldzIG9fofYgr80zaBYBeldzo8lht29foB7BaBrBsfCBap9fowxSVfCgr9nzsyrgrN9foDlht29foB7BoE2Bob2grg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgr82zaM7BoEHSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgaMHgs9lgrU2zZldzIG9fofYgr80zaBYBeldzoNQ4eldgafngaE1za8nzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foUngaBCgay7BHldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfHgo92gsRrBsO9fowxSVfCgr9nzsyrgrN9foDCBPHQfdldfCgEmROespgvZbZhsFQnOtM5fEgCcYZoXip6OCfjfIG9foE2grMYBrM2gap9fowxSVfCgr9nzsyrgrN9fow79IZpht29foE7go91BrEHgap9fowxSVfCgr9nzsyrgrN9foDrgoNQ4eldBsR2goMCgayYBHldzIG9fofYgr80zaBYBeldzo8lht29foEngsRrgrBrBsk9fowxSVfCgr9nzsyrgrN9foDlht29foE1Bs8HBoynzsp9fowxSVfCgr9nzsyrgrN9foDCht29foflgry1grR2zaN9fowxSVfCgr9nzsyrgrN9foDlht29fof2gsMnBob2Brv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCgs92BrE2gaM0SVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfCgo97Bo9CBab1SVfjqHldBo9Ygob1Br9lSVfjBS7ASVfCzsBHzaU2BsB1SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof0Bryrzsf2gre9fowxSVfCgr9nzsyrgrN9foDGgaZQ4eldBrfYBofrBsR7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBrflBs8lBoB0SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgaynBoyYBs9HSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBr9rgoEHgsb1BZldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foBYgrU7Bablgsk9fowxSVfCgr9nzsyrgrN9foDlht29foUCgs9rBoBlBHldzIG9fofYgr80zaBYBeldzoNQ4eldgsBCBrf2zsBrSVfjqHldBo9Ygob1Br9lSVfjkPvHOS7ASVfnBaB7zsUHBrv9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf1BaB2gsf0gsZ9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldzsbYgaf7ga81SVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhsn1ykSgpfoDdqHldBsMnBsMrza8YzZldzIG9fofYgr80zaBYBeldzoNQ4eldBsR2BoR7BoBrBeldzIG9fofYgr80zaBYBeldzoNQ4eldBs8YBoflBofrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaM1Bob2gsMrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBsbnBsRngsErBpldzIG9fofYgr80zaBYBeldzoNQ4eldBoB2BoRCgs9ngpldzIG9fofYgr80zaBYBeldzoNQ4eldBoRCgsMnzsBnBpldzIG9fofYgr80zaBYBeldzoflht29fofngoElBoE0zae9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCgoyHBrf7BpldzIG9fofYgr80zaBYBeldzoNQ4eldBoyCgr9nBsRlBZldzIG9fofYgr80zaBYBeldzoNQ4eldBrMlgaBYBoEYBeldzIG9fofYgr80zaBYBeldzoNQ4eldBrB7gaUHgrfYgpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBYBa92zay7Bov9fowxSVfCgr9nzsyrgrN9foDY4eldgaMHBaU1BoEHBeldzIG9foB7BrU1zsMHBsp9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBr92grMrBa9lzeldzIG9fofYgr80zaBYBeldzo8lht29foB0BrR2gsE1geldzIG9fofYgr80zaBYBeldz5O3cPgpht29foB0zs8CBaM0Bs39fowxSVfCgr9nzsyrgrN9foDlht29foU2BobHgoUCgak9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7BsbrBoR0za80SVfjqHldBo9Ygob1Br9lSVfjBt29foUlgsM7zaf2gsN9fowxSVf2gaUrBrbnzsBCSVfjqHldBo9Ygob1Br9lSVfjBPHQht29foUrgaR2zaEnzeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foy2gsUnzs8YBpldzIG9fofYgr80zaBYBeldzoNQ4eldzaUYBsM7zaErSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhRIZ6c5p6OCfjfIG9foElgaElza97grO9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsf7Bo9Hgo8YBZldzIG9fofYgr80zaBYBeldzoNQ4eldBsBCgsBnBsBrgeldzIG9fofYgr80zaBYBeldzoNQ4eldBsB0zsyCBsylgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE7grUCgrU2grm9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVf2zaf7zs92gsbrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBoMCBr9Hgr91zZldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCBsBlBo90BoM7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBrU1gsRrBofYSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBo9YBs9CBsblgZldzIG9fofYgr80zaBYBeldzoNQ4eldBoyrBrRnBo9lBZldzIG9fofYgr80zaBYBeldzoNQ4eldBobrzaRrBsyHzZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBlgr9Cgsy2BoO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBof7Boy2gsy1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBoU7gsBlBrbYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgafCBrB7gsU1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrgoUnzsbnBaB1SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgaM0BoM2BsyYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf7gof7zabrBoO9fowxSVfCgr9nzsyrgrN9foDlht29foUngrfrBrBHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldzaB2gry2BsBYSVfjqHldBo9Ygob1Br9lSVfjBPHQfdldfCgEmROespgvZbZhRne5OtNfOFebfoDdqHldBsE7gsMHza91zeldzIG9fofYgr80zaBYBeldzoNQ4eldBsU7gaM1ga8nBHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE7gaylgrBrgae9fowxSVfCgr9nzsyrgrN9foDlht29foEngrBHBrb2Brk9fowxSVfCgr9nzsyrgrN9foDlht29foEYzsUHBry2gag9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2zsbnBsf1BrErSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBoE2gsU2gsU7BHldzIG9fofYgr80zaBYBeldzoNQ4eldBofCzaylBrM7BZldzIG9fofYgr80zaBYBeldzoNQ4eldBoU2BoRrzsBrBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofHBsBYBsUrgs39fowxSVfCgr9nzsyrgrN9foDCBP7ASVfCgsRlza87zs9lSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgoRHzsy0gr9rSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofnzsBnzsBYBsO9fowxSVfCgr9nzsyrgrN9foDlht29foBlgsyHgsf1Bam9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBrEnBsR1za9rgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBrzaE7Baf1gsm9fowxSVfCgr9nzsyrgrN9foDlht29foBnBsbCBrylgog9fowxSVfCgr9nzsyrgrN9foDlht29foU2grM0BaB7zag9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfnBoUHBsf1gov9fowxSVfCgr9nzsyrgrN9foDlht29fo8rgrU0zaECgZldzIG9fofYgr80zaBYBeldzoNQ4eldzaRlgoMHBrbHSVfjqHldBo9Ygob1Br9lSVfjBsfl4eldgaMHBaU1BoEHBeldzIG9foU2grBHBrE2gsp9fowxSVfCgr9nzsyrgrN9foDlhSHQhtfAfdBomEZimR0stZOeSHgD8SvpOVfjfIG9foElzayCza9Czap9fowxSVfCgr9nzsyrgrN9foDlht29foEngsEYzsEHBsp9fowxSVfCgr9nzsyrgrN9foDCBP7ASVf2grynBsE7gog9fowxSVfCgr9nzsyrgrN9foDlht29foE0gsU7zaBngs39fowxSVfCgr9nzsyrgrN9foDlht29fof2zaU7BafrBak9fowxSVfCgr9nzsyrgrN9foDlht29fof7goUCzaB0zak9fowxSVfCgr9nzsyrgrN9foDlht29foB2Bsf1gofngeldzIG9fofYgr80zaBYBeldzoNQ4eldBrB2zsb1BoMCgpldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrgabnBoEHgabYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrR7gaflgrBngeldzIG9fofYgr80zaBYBeldzoNQ4eldBrR1zablzs8YgpldzIG9fofYgr80zaBYBeldzoNQ4eldBryHzab7go87BHldzIG9fofYgr80zaBYBeldzo9ASVf7BaRlgayCBsRlSVfjqHldBrUrgay0BaR2zZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrza81gry1zsf0SVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrblBsMnzsMrgZldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foUCBr92gsb2BoZ9fowxSVfCgr9nzsyrgrN9foDlht29foUCzaErBof7go39fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7Bob2ga8lBsy1SVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldgsUHBo9rgaMHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgsynBo9nBry0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgoB0Bo87gayYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsy1goBlBrm9fowxSVfCgr9nzsyrgrN9foDlhS7d4Vfof7membZzR7pFmZQsciQYfiHKkipKcdfjfIG9foEHzsyrBsUlgap9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2goE1gsbHzaEnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2go80goblBs9nSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBsbYgo8YBrbnBHldzIG9fofYgr80zaBYBeldzoNQ4eldBsb1BrfCzs8rgZldzIG9fofYgr80zaBYBeldzoflht29fofrBof2gaBrSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBr8nBsBrBa8YSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCzaM1BaE1zs8YSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fof1zsR2zay1gaO9fowxSVfCgr9nzsyrgrN9foDlht29fof0go8lBo9nBrk9fowxSVfCgr9nzsyrgrN9foD2BoMASVf7BaRlgayCBsRlSVfjqHldgaEYBrRrBsEHzZldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrBaErgoyrzay1SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBaBYzabHBrfHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBoy2goMYgabrSVfjqHldBo9Ygob1Br9lSVfjgoNQ4eldBrBnzsB1goR1zeldzIG9fofYgr80zaBYBeldzoNQ4eldBr8rBsMrBr92BeldzIG9fofYgr80zaBYBeldzoEASVf7BaRlgayCBsRlSVfjqHldBsU7BrB0gobrBpldzIG9fofYgr80zaBYBeldzoNQhS7ASVfrgoU0ga9rgoM1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBr80Brynzsy7gHldzIG9fofYgr80zaBYBeldzoNQ4eldBrbYzaUHzsb1BZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foyCgr90BoR1BHldzIG9fofYgr80zaBYBeldzoNQ4eldzsEYzsB0zsB7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf0zsMlgoU7BoZ9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgEmROespgvZbZhRYm3c5mwc59dzdvxSVf2BaMYgsb0BrN9fowxSVfCgr9nzsyrgrN9foDlht29foE2Bsf1BaB1Bsm9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2gaMrgsBrza82SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gaRYBaylBoMlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zaMYBsy1zse9fowxSVfCgr9nzsyrgrN9foD24eldgaMHBaU1BoEHBeldzIG9foE7gaBrzs80Brv9fowxSVfCgr9nzsyrgrN9foDlhSHQ4eldBsyHza87gsE7BeldzIG9fofYgr80zaBYBeldzoNQ4eldBofYzaR7grUlSVfjqHldBo9Ygob1Br9lSVfjgC29foUlgsM7zaf2gsN9fowxSVfrgaB7zablgsE0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29fofrBrbHgaB0Ba39fowxSVfCgr9nzsyrgrN9foDlht29fofrgs82gobnBav9fowxSVfCgr9nzsyrgrN9foDnBP7ASVfCgsUlgaB2BaBlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCgrynza80grO9fowxSVfCgr9nzsyrgrN9foDCBP7ASVfrgaErBaUlBoRrSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBrRlgofYzs91SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrRlgo87gryHBZldzIG9fofYgr80zaBYBeldzoNQ4eldBr8ngrMlgo91geldzIG9fofYgr80zaBYBeldzoECBV29foUlgsM7zaf2gsN9fowxSVf7Bs9rgsB2BsR0SVfjqHldBo9Ygob1Br9lSVfjBPHQht29foBYBaR2zsU7zsm9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgrUrBa82gaBHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrzaUCBob1Bsy7SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfnBrBnBo97zsg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf1Baf0BaB1Brm9fowxSVfCgr9nzsyrgrN9foDlht29fobYBsU2gr82BHldzIG9fofYgr80zaBYBeldzoNQhtfAfdBoRbePmRvWZVfjfIG9foElBa8Yzaf0Brv9fowxSVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVf2gofYgrU7BaU1SVfjqHldBo9Ygob1Br9lSVfjBI7ASVf2zablBaU2zs87SVfjqHldBo9Ygob1Br9lSVfjBrZQ4eldBoEYgrE0BrBCSVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoE6BV29foEYgr8YBZldzoM6BV29foEYgr8YgpldzoM6BV29foEYgr81gHldzoM6gry7BrErgrbYzsRlgrU7gIHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldBoBHBaMnzsBlSVfjqHldBo9Ygob1Br9lSVfjBoNQ4eldBoRCgoyHgrU2zZldzIG9fofYgr80zaBYBeldzoB2ht29fofnzaBHBrflBo39fowxSVfCgr9nzsyrgrN9foDCgS7ASVfCzs90goU2Ba8HSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrUCgs9HBoRCSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBr8CBaR7grb7SVfjqHldBo9Ygob1Br9lSVfjBo3Q4eldgsf1BrU7BofnSVfjqHldBo9Ygob1Br9lSVfjgYHQht29foflzabrBobCBsN9fowxSVfCgr9nzsyrgrN9fow79IZp4eldgaMHBaU1BoEHBeldzIG9foflzab2ga8HBoO9fowxSVfCgr9nzsyrgrN9foD2BaNQ4eldBoM1zsBCzsflgpldzIG9fofYgr80zaBYBeldzovQ4eldBoM0BafrBa9nBHldzIG9fofYgr80zaBYBeldzoZQ4eldBrB7zaR2BaRlzeldzIG9fofYgr80zaBYBeldzo8lht29foBrgo8YzsbYBav9fowxSVfCgr9nzsyrgrN9foDHht29foB7gaE7gsECBap9fowxSVfCgr9nzsyrgrN9fowxSVfCBablBsRHzsfnSVfjqHldBeldzIG9foflzsM2gsR0BoO9fowcqHldBs9Ygo9lSVfjBt1l4eldBs9Ygo92SVfjBV1rBsBYBoRHBaECzsy0BaU74eldBs9Ygo9nSVfjBV11Bo97gsElgsMCzaEHBoUY4eldBs9YgoyYSVfjBV1nBrbCBsRYBa9Ygry0BrMYhZHQht29foflzsMHBsRlBs39foDlhS7ASVfrgabYBafHza8lSVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoE6BV29foEYgr8YBZldzoM6BaynBo97gsECBsECBsUlgo8ASVf2gr9ngrO9foDl4oM1gofYgaR2BoE2BoE7Ba8n4eldBs9YgoyYSVfjBV1lza8CgrUHBsf2Bsf2gaMngIHkhS7ASVfCBablgsEHBaE1SVfjBPHQ4eldzs87zaf2Br9nSVfjqHldBo9Ygob1Br9lSVfjqHldBoM0BaEHgsbCgpldzIG9foN9fowxSVfCBablBsRHzsfnSVfjFYG9foEYgr8YBeldzoE6BV29foEYgr8YBZldzoM6BrBYBoR7zsE2go82BsU1Ba9ASVf2gr9ngrO9foDl4o97zsM2zs8CBoylBo9rgaUASVf2gr9nzak9foDl4ob7BsEYgoRrBr80zsMrgsOQSSHQ4eldBoM0BaR2gsM2zeldzoNQhSHQ4eldBoyHzaRCBoErgeldzIG9fofYgr80zaBYBeldz5O3cPgp4eldgaMHBaU1BoEHBeldzIG9fofHBo81gs97Bsp9fowxSVfCgr9nzsyrgrN9foD2gS7ASVfCgr8rBrU2gaB7SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldgaflgsy0ga81zeldzIG9fofYgr80zaBYBeldzoNQhS7ASVfCzs91zabCgoe9fowxSVfCgr9nzsyrgrN9fow58F2rOt29foUlgsM7zaf2gsN9fowxSVf2BaEnBay0grfnSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2BaU1zs9HzaBYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsMYBo91ga9HgeldzIG9fofYgr80zaBYBeldzoylht29foE2Bsf2BoyCBaO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2BsBCBaB7Ba9CSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsEHBoRnga9YBeldzIG9fofYgr80zaBYBeldzovQ4eldBsEYgoBHBaBYgeldzIG9fofYgr80zaBYBeldzoylht29foECBaM0Bs82Bog9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2Bo8HBabHBr91SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsf1Bof0zaE0gHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foECzs87BrfHBsZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2BrEYBsf7zae9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf2Brfngo9lBr9CSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsB7Baylga80BeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foE7BsMCBoUrBrv9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf2gaB1ga9lgsE0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsU7go9YBay1BeldzIG9fofYgr80zaBYBeldzoRlht29foE7gay2zsR2BaN9fowxSVfCgr9nzsyrgrN9foDlht29foE7grf7zablgr39fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2gsBCzaE7BsU7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBsRrgoUlgsf1BHldzIG9fofYgr80zaBYBeldzoNQ4eldBsR7BaRYBo90gHldzIG9fofYgr80zaBYBeldzoRlht29foEHzaMnzaU1zZldzIG9fofYgr80zaBYBeldzoNQ4eldBs82BsBCgsbHBpldzIG9fofYgr80zaBYBeldzoRlht29foEnBsf2zaMlBav9fowxSVfCgr9nzsyrgrN9foDCht29foEnBoEHgry0BrN9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2go9lzaRrgsBYSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2go91grE1zaRlSVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2gob2BaR2ga8CSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBs80zaUlgrUngHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foEYBaMngrU1Bog9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2grErzsfCgoyCSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBs92gsBYgsO9fowxSVfCgr9nzsyrgrN9foDCht29foEYBrb0Bry2Bsv9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2grUrBrUHBo8nSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsyCBsBHgrb7BZldzIG9fofYgr80zaBYBeldzoylht29foE1BobCBo81Brv9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2zaU2gaBCBsb0SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsy7zsM1gr91BpldzIG9fofYgr80zaBYBeldzoNQ4eldBsy7zsBYzaM1geldzIG9fofYgr80zaBYBeldzoRlht29foE1gsfYgoMnBaO9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2za8CgsyCBsZ9fowxSVfCgr9nzsyrgrN9foDlht29foE1go81zsU0Bom9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf2zay7gsblBsBCSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBsy0goBHBrf0gpldzIG9fofYgr80zaBYBeldzoRlht29foE0BsM7za9nBsm9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf2zsE1Br97Br81SVfjqHldBo9Ygob1Br9lSVfjBP7ASVf2zsfYgo8lgaf1SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBsbYBs97gsErBpldzIG9fofYgr80zaBYBeldzoRlht29foE0grbngsbrBrk9fowxSVfCgr9nzsyrgrN9foDCht29foE0za82BaBnzsg9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCBaMCBo9lBsbrSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCBaf0Brb0grBnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoM7BrRrgaMHgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foflga9CBsf7gog9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBa8nzabHzaU1SVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCBsMrzsB7za91SVfjqHldBo9Ygob1Br9lSVfjBP7ASVfCBsM7grE7goE0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoE2zay7zabrgHldzIG9fofYgr80zaBYBeldz5O3cPgpht29fof2go9Cgsy0gap9fowxSVfCgr9nzsyrgrN9foDlht29fof2gr81zsEnzap9fowxSVfCgr9nzsyrgrN9foDlht29fof2zsMlBaU7Bok9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCBoErBofCBoE7SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBofrgsB2zaU0geldzIG9fofYgr80zaBYBeldzoNQ4eldBofrzsUlzs9lgpldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofCzaBlBafrzsO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCBobYza87gsUnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBoB7go81gs9HSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCBrR7BaR2zsEYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoUlBaf0Boe9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfCga8CgaE0goE1SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBoU0ga87zs8CSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoRHzsy1gsbnzZldzIG9fofYgr80zaBYBeldzoylht29fofnBaMCga8Yzs39fowxSVfCgr9nzsyrgrN9foDCht29fofnBaBrzaE0gsZ9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCgoE7grM1goZ9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfCgoB2gab7goyrSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBo8nBabnBsyrgZldzIG9fofYgr80zaBYBeldzovQ4eldBo9CzayHga92geldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofYBrRrgoECzsZ9fowxSVfCgr9nzsyrgrN9foDlht29fof1gaf7Bo9CBo39fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzaRlgrfYgsy0SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBoyngaynBsblgHldzIG9fofYgr80zaBYBeldzoRlht29fof1grM0ga9HBHldzIG9fofYgr80zaBYBeldzoRlht29fof1grR2BsU1zaZ9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzab1zafCBsy2SVfjqHldBo9Ygob1Br9lSVfjBI7ASVfCzsM2gry0BrUCSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBob2go8CBab0BpldzIG9fofYgr80zaBYBeldzoNQ4eldBob2zaUHzsElSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBobCgoUlgo8CgZldzIG9fofYgr80zaBYBeldzoRlht29fof0BrBngaRHzsO9fowxSVfCgr9nzsyrgrN9foDCht29fof0Br8YgrM1gsg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfCzsR7BoElgr91SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrMHzsylBof1SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrM1Bo9nBo91gHldzIG9fofYgr80zaBYBeldzoRlht29foB2Baf0BsUlBrp9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBsMHgaRrBobHSVfjqHldBo9Ygob1Br9lSVfjBP7ASVfrBsEYza90Brb2SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrECgsB2BaBHgpldzIG9fofYgr80zaBYBeldzovQ4eldBrE7grBlBsbYgZldzIG9fofYgr80zaBYBeldzoRlht29foB2gabCgrMrgam9fowxSVfCgr9nzsyrgrN9foDlht29foB2gsMHBs8CBaZ9fowxSVfCgr9nzsyrgrN9foDlht29foB2gsf7zaE7gsv9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBs82gry2Ba9lSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBrEYBrBlBsE2geldzIG9fofYgr80zaBYBeldzovQ4eldBrE1BoyHgoU0gHldzIG9fofYgr80zaBYBeldzoRlht29foBCBrRnBa97zsO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBoU1BaUngo9nSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrfngaBHgoM2BHldzIG9fofYgr80zaBYBeldzovQ4eldBrf1BabCgoB2BHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBCzsM1zs8rBag9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrBrMHBa8ngsf1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrBCBof2gsE2zeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBrga97BsEHgop9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrBr8lgsUYzaE0SVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrBr8Hzay2grUrSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBrUlBaEnBoRnzeldzIG9fofYgr80zaBYBeldzoRlht29foB7BrBrgrb7zap9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrgaB1gaR0goRYSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBrU7gaUCzs8CgHldzIG9fofYgr80zaBYBeldzoylht29foB7gaR0goblzZldzIG9fofYgr80zaBYBeldzoRlht29foB7gsE2gob2grv9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrga8CBaB7BoynSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrgay7Bsf1BoBrSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBrU1go9YBaE0BeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgrMrgoM1zZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBHgr82Bsblgoe9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgsyCgsR1Br8YSVfjqHldBo9Ygob1Br9lSVfjBI7ASVfrgsyYBrECBok9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrgoMYgsyYza9CSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBr82BoRrBa8nBHldzIG9fofYgr80zaBYBeldzovQ4eldBr82grEYzabCBHldzIG9fofYgr80zaBYBeldzoRlht29foBngaR1Brf0Brm9fowxSVfCgr9nzsyrgrN9foDlht29foBngoMCBoR2Bag9fowxSVfCgr9nzsyrgrN9foDlht29foBngryHgafCBaZ9fowxSVfCgr9nzsyrgrN9foDCht29foBnzaBHBs8CBak9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgrM2zaf2BoRHSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldBr92gsbHgsRYBHldzIG9fofYgr80zaBYBeldzoRlht29foBYgo91zsElgrO9fowxSVfCgr9nzsyrgrN9foDCht29foBYzayrzaf0gov9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfrgrbrBoR1zsp9fowxSVfCgr9nzsyrgrN9foDlht29foB1ga91ga91Bsg9fowxSVfCgr9nzsyrgrN9foDHBP7ASVfrzaU1ga8nzsbrSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBrynBryrBrBlgpldzIG9fofYgr80zaBYBeldzovQ4eldBry0BoMHzs81BHldzIG9fofYgr80zaBYBeldzoRlht29foB0BaMrBa9Czae9fowxSVfCgr9nzsyrgrN9foDlht29foB0Ba8rgaMHBov9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrzsE7zafCgsO9fowxSVfCgr9nzsyrgrN9foD1BP7ASVfrzsfYgo8Ygo9HSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldBrbYgsfYgsfrBHldzIG9fofYgr80zaBYBeldzovQ4eldBrb1zsEYgrM1gHldzIG9fofYgr80zaBYBeldzoRlht29foUlBa9rBryngom9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf7BaECgaMCzayHSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgaMHgayYBrN9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf7BablgaMYBs91SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgaErzsMYBsyYgZldzIG9fofYgr80zaBYBeldzoNQ4eldgaEHgsBCgsf0gHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foU2grBrBayYzam9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVf7BsyYBaf7BoR0SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldgaf2gr81BabHzZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foUCzabHgsBrBog9fowxSVfCgr9nzsyrgrN9foD1BP7ASVf7Boy0goRnBeldzIG9fofYgr80zaBYBeldz5O3cPgpht29foUrBsflgaRrBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foU7gayYBsR2BpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foU7gsBrzay7zZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foU7zaylBry0gHldzIG9fofYgr80zaBYBeldz5O3cPgpht29foUYgayHgoylgZldzIG9fofYgr80zaBYBeldzovQ4eldgabCBrbngsyYSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgsM7grb7BrRYSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldgsE2zs8nzaBnSVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldgsB7goyYgrflSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgsBHgrMHBryCSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgsbrBsEYgoUnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgsb1grfHzaBnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgoErBrR1zs80SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgofHgaUrBafYSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldgoB2BaR7Bs9YSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgoUCBrE1gsfnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgoRnzsR2goR0SVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldgoyrBoECgsb7SVfjqHldBo9Ygob1Br9lSVfjzaNQ4eldgoyHBrfrgop9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfnzabCBoMYgsk9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfYBaMYgs90BsN9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfYBobrgsb7Bom9fowxSVfCgr9nzsyrgrN9foDlht29fo9nBsM0BabrBpldzIG9fofYgr80zaBYBeldz5O3cPgpht29fo91zsb0zaM0zZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foyngsB2Bob1BpldzIG9fofYgr80zaBYBeldz5O3cPgpht29foyYBo81grBHSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldzsB2zs97gaBnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldzsUYgrUHgrUnSVfjqHldBo9Ygob1Br9lSVfjgsNQ4eldzsRrzsb1BsUCSVfjqHldBo9Ygob1Br9lSVfjBI7ASVf0gs81Br9CBoO9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf0grM0grEHgam9fowxSVfCgr9nzsyrgrN9foDHBP7ASVf0zab7grErBaN9fowxSVfCgr9nzsyrgrN9foDlhSHQhtfAfdBoRbZasHvEmZvhUFpCfoDdqHldBsy1zaBHBayrgeldzIG9fofYgr80zaBYBeldz5O3cPgpht29fofHBobYgrynzsm9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fIHQfdldfCgtmRgWRbmeRpQNXSfyvdNa95QH8n3wc59dzdvxSVf2zsMCgaElzsMnSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBo91gaUCBab2BeldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtS7gCcYZoXip6OCfjfIG9foB0zayHgaEHBsO9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fI7ASVfHzsy7BsE2zsv9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtmRgWRbmeRpQi8FGpcieIfoDdqHldBoEHBsBlgoRnBZldzIG9fofYgr80zaBYBeldz5O3cPgpht29foBCgofngrElgoe9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fIHQfdldfCgtmRgWRbmeRpQi95Zp9Ym3c5mwc59dzdvxSVfCBa91BoM1zsU7SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoE7zsB7gaE0gpldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtS7H3cIZ3cVNO8S9dzdvxSVfrgafCBob1zsg9fowxSVfCgr9nzsyrgrN9fow58F2rOS7ASVfHga9rzaM1zap9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fIHQfdldfCgtmRgWRbmeRpQgcYOpfV8yUYvKkFgDXF0IfoDdqHldBsE0go8Hgs9CBZldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldht29fof2gsRlzs8ngoe9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtmRgWRbmeRpQWcdNH9nRdzdvxSVf2goBHBsy2gaf1SVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQ4eldBs9rBs8Hgaf7BeldzIG9fofYgr80zaBYBeldz5O3cPgphS7d4VfofHveU7QtmEZtSHvHc50wc59dzdvxSVf2BoRHgoB0BofrSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQ4eldBoBngrMlBr9CBHldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldhS7d4VfofHveU7QtmEZtSHg3O5RytiZ3OVfjfIG9fofYzayngs92gak9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fI7ASVfrgobrgab7BsE0SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhtfAfdBoRbZasHvEmZvhRn3395ZbfoDdqHldBs91gobrzs87zZldzIG9fofYgr80zaBYBeldzpldSe29fpGkSe29fpldht29foE1zaB7Bsf7goe9fowxSVfCgr9nzsyrgrN9fow58F2rOSHQfdldfCgtmRgWRbmeRpQsciQYfiHKkipKcdfjfIG9foECgsB0BaE2zap9fowxSVfCgr9nzsyrgrN9fow9fp29SVvcSZ29SVv9fI7ASVfrBa9rzaRCzsErSVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhtfAfdBoRbZasHvEmZvhRYm3c5mwc59dzdvxSVfCzs8HBaBHzs9lSVfjqHldBo9Ygob1Br9lSVfjSVv9SeldFHH9SeldSVvQ4eldgoU0grUHzaB1SVfjqHldBo9Ygob1Br9lSVfjO5eA9nZQhtvQ"));
    v958();
    l_v844_1.list:update(v953());
end;
v844 = nil;
v844 = {};
v845 = 0;
v846 = false;
v888 = 0;
v889 = false;
v890 = {
    [1] = -1,
    [2] = 1,
    [3] = 0,
    [4] = -1,
    [5] = 1,
    [6] = 0,
    [7] = -1,
    [8] = 0,
    [9] = 1,
    [10] = -1,
    [11] = 0,
    [12] = 1
};
v891 = 0;
v892 = 0;
l_match_0 = {};
local l_angles_0 = v26.antiaim.angles;
local v982 = {};
v982.__index = v982;
v982.clear = function(v983)
    for v984 in pairs(v983) do
        v983[v984] = nil;
    end;
end;
v982.copy = function(v985, v986)
    for v987, v988 in pairs(v986) do
        v985[v987] = v988;
    end;
end;
do
    local l_l_angles_0_0 = l_angles_0;
    v982.unset = function(_)
        -- upvalues: l_l_angles_0_0 (ref)
        l_l_angles_0_0.enabled:override();
        l_l_angles_0_0.pitch:override();
        l_l_angles_0_0.yaw[1]:override();
        l_l_angles_0_0.yaw[2]:override();
        l_l_angles_0_0.yaw[3]:override();
        l_l_angles_0_0.yaw[4]:override();
        l_l_angles_0_0.yaw[5]:override();
        l_l_angles_0_0.yaw_modifier[1]:override();
        l_l_angles_0_0.yaw_modifier[2]:override();
        l_l_angles_0_0.body_yaw[1]:override();
        l_l_angles_0_0.body_yaw[2]:override();
        l_l_angles_0_0.body_yaw[3]:override();
        l_l_angles_0_0.body_yaw[4]:override();
        l_l_angles_0_0.body_yaw[5]:override();
        l_l_angles_0_0.body_yaw[6]:override();
        l_l_angles_0_0.freestanding[1]:override();
        l_l_angles_0_0.freestanding[2]:override();
        l_l_angles_0_0.freestanding[3]:override();
        l_l_angles_0_0.extended_angles[1]:override();
        l_l_angles_0_0.extended_angles[2]:override();
        l_l_angles_0_0.extended_angles[3]:override();
    end;
    v982.set = function(v991)
        -- upvalues: l_l_angles_0_0 (ref)
        l_l_angles_0_0.enabled:override(v991.enabled);
        l_l_angles_0_0.pitch:override(v991.pitch);
        l_l_angles_0_0.yaw[1]:override(v991.yaw);
        l_l_angles_0_0.yaw[2]:override(v991.yaw_base);
        l_l_angles_0_0.yaw[3]:override(v991.yaw_offset);
        l_l_angles_0_0.yaw[4]:override(v991.avoid_backstab);
        l_l_angles_0_0.yaw[5]:override(v991.hidden);
        l_l_angles_0_0.yaw_modifier[1]:override(v991.yaw_modifier);
        l_l_angles_0_0.yaw_modifier[2]:override(v991.modifier_offset);
        l_l_angles_0_0.body_yaw[1]:override(v991.body_yaw);
        l_l_angles_0_0.body_yaw[2]:override(v991.inverter);
        l_l_angles_0_0.body_yaw[3]:override(v991.left_limit);
        l_l_angles_0_0.body_yaw[4]:override(v991.right_limit);
        l_l_angles_0_0.body_yaw[5]:override(v991.options);
        l_l_angles_0_0.body_yaw[6]:override(v991.freestanding_body_yaw);
        l_l_angles_0_0.freestanding[1]:override(v991.freestanding);
        l_l_angles_0_0.freestanding[2]:override(v991.freestanding_disable_yaw_modifiers);
        l_l_angles_0_0.freestanding[3]:override(v991.freestanding_body_freestanding);
        l_l_angles_0_0.extended_angles[1]:override(v991.extended_angles);
        l_l_angles_0_0.extended_angles[2]:override(v991.extended_angles_pitch);
        l_l_angles_0_0.extended_angles[3]:override(v991.extended_angles_roll);
    end;
    setmetatable(l_match_0, v982);
end;
l_angles_0 = {};
v982 = false;
local v992 = 0;
do
    local l_v845_1, l_v846_2, l_v888_0, l_v889_1, l_v890_1, l_v891_1, l_v892_1, l_l_match_0_2, l_l_angles_0_1, l_v982_0, l_v992_0 = v845, v846, v888, v889, v890, v891, v892, l_match_0, l_angles_0, v982, v992;
    do
        local l_l_v982_0_0, l_l_v992_0_0 = l_v982_0, l_v992_0;
        local function v1006()
            -- upvalues: l_l_v982_0_0 (ref)
            l_l_v982_0_0 = not l_l_v982_0_0;
        end;
        local function v1007()
            -- upvalues: l_l_v992_0_0 (ref)
            l_l_v992_0_0 = l_l_v992_0_0 + 1;
        end;
        local function v1009(v1008)
            -- upvalues: v395 (ref), l_l_match_0_2 (ref)
            if not v1008.force_target_yaw:get() then
                return;
            elseif v395.defensive_ticks == 0 then
                return;
            else
                l_l_match_0_2.yaw_left = -9;
                l_l_match_0_2.yaw_right = 6;
                l_l_match_0_2.yaw_modifier = "Disabled";
                l_l_match_0_2.modifier_offset = 0;
                l_l_match_0_2.body_yaw = true;
                l_l_match_0_2.inverter = false;
                l_l_match_0_2.left_limit = 60;
                l_l_match_0_2.right_limit = 60;
                l_l_match_0_2.options = {};
                return;
            end;
        end;
        local function v1017(v1010, v1011)
            -- upvalues: l_l_v982_0_0 (ref), v14 (ref)
            local v1012 = v1011.pitch:get();
            local v1013 = v1011.pitch_speed:get();
            local v1014 = v1011.pitch_offset_1:get();
            local v1015 = v1011.pitch_offset_2:get();
            if v1012 == "Off" then
                return;
            elseif v1012 == "Static" then
                v1010.pitch_offset = v1014;
                return;
            elseif v1012 == "Jitter" then
                v1010.pitch_offset = l_l_v982_0_0 and v1015 or v1014;
                return;
            elseif v1012 == "Spin" then
                local v1016 = globals.curtime * v1013 * 0.1;
                v1010.pitch_offset = v14.lerp(v1014, v1015, v1016 % 1);
                return;
            elseif v1012 == "Random" then
                v1010.pitch_offset = utils.random_int(v1014, v1015);
                return;
            else
                return;
            end;
        end;
        local function v1024(v1018, v1019)
            local v1020 = v1019.yaw_modifier:get();
            if v1020 == "Off" then
                return;
            else
                local v1021 = v1019.modifier_offset:get();
                local v1022 = v1019.delay:get();
                local v1023 = v1019.random_delay:get();
                if v1022 > 1 and v1023 > 0 then
                    v1022 = utils.random_int(v1022, v1023);
                end;
                if v1020 == "Offset" then
                    v1018.yaw_offset = 0;
                    v1018.yaw_modifier = "Offset";
                    v1018.modifier_offset = v1021;
                    v1018.delay = v1022;
                end;
                if v1020 == "Center" then
                    v1018.yaw_offset = 0;
                    v1018.yaw_modifier = "Center";
                    v1018.modifier_offset = v1021;
                    v1018.delay = v1022;
                end;
                if v1020 == "Skitter" then
                    v1018.yaw_offset = 0;
                    v1018.yaw_modifier = "Skitter";
                    v1018.modifier_offset = v1021;
                    v1018.delay = v1022;
                end;
                return;
            end;
        end;
        local function v1035(v1025, v1026)
            -- upvalues: v14 (ref), v1024 (ref)
            local v1027 = v1026.yaw:get();
            if v1027 == "Off" then
                return;
            else
                local v1028 = v1026.yaw_speed:get();
                local v1029 = v1026.yaw_offset:get();
                local v1030 = v1026.yaw_left:get();
                local v1031 = v1026.yaw_right:get();
                if v1027 == "Static" then
                    v1025.yaw_offset = v1029;
                end;
                if v1027 == "Spin" then
                    local v1032 = globals.curtime * v1028 * 0.1;
                    local v1033 = v1029 * 0.5;
                    v1025.yaw_offset = -(180 + v14.lerp(-v1033, v1033, v1032 % 1));
                end;
                if v1027 == "Random" then
                    local v1034 = math.abs(v1029 * 0.5);
                    v1025.yaw_offset = 180 + utils.random_int(-v1034, v1034);
                end;
                if v1027 == "Left/Right" then
                    v1025.yaw_offset = 0;
                    v1025.yaw_left = v1030;
                    v1025.yaw_right = v1031;
                end;
                v1024(v1025, v1026);
                return;
            end;
        end;
        l_l_angles_0_1.update = function(_, v1037)
            -- upvalues: l_l_match_0_2 (ref), v26 (ref), v1006 (ref), v1007 (ref)
            l_l_match_0_2.hidden = false;
            v26.ragebot.main.hide_shots[2]:override();
            v26.ragebot.main.double_tap[2]:override();
            if v1037.choked_commands == 0 then
                v1006();
                v1007();
            end;
        end;
        l_l_angles_0_1.apply = function(_, _, v1040)
            -- upvalues: l_l_match_0_2 (ref), v26 (ref), v1009 (ref), v1017 (ref), v1035 (ref)
            if v1040.force_break_lc ~= nil and v1040.force_break_lc:get() then
                l_l_match_0_2.hidden = true;
                v26.ragebot.main.hide_shots[2]:override("Break LC");
                v26.ragebot.main.double_tap[2]:override("Always On");
            end;
            if v1040.enabled:get() then
                local v1041 = {};
                v1009(v1040);
                v1017(v1041, v1040);
                v1035(v1041, v1040);
                l_l_match_0_2.defensive = v1041;
                return true;
            else
                return false;
            end;
        end;
    end;
    l_v982_0 = {};
    l_v992_0 = v384.antiaim.settings.invert_flick;
    local v1042 = 0;
    local function v1046()
        if rage.exploit:get() ~= 1 then
            return false;
        else
            local v1043 = entity.get_local_player();
            if v1043 == nil then
                return false;
            else
                local v1044 = v1043:get_player_weapon();
                if v1044 == nil then
                    return false;
                else
                    local v1045 = v1044:get_weapon_info();
                    if v1045 == nil or v1045.is_revolver then
                        return false;
                    else
                        return true;
                    end;
                end;
            end;
        end;
    end;
    do
        local l_l_v992_0_1, l_v1042_0, l_v1046_0 = l_v992_0, v1042, v1046;
        l_v982_0.update = function(_, v1051, v1052)
            -- upvalues: l_v1046_0 (ref), l_v1042_0 (ref), v395 (ref), l_l_match_0_2 (ref), l_l_v992_0_1 (ref)
            if not v1052.flick_enabled:get() then
                return false;
            elseif not l_v1046_0() then
                return false;
            else
                if v1051.choked_commands == 0 then
                    l_v1042_0 = l_v1042_0 + 1;
                end;
                v1051.force_defensive = v1051.command_number % 7 == 0;
                if v395.defensive_ticks > 0 then
                    local v1053 = v1052.flick_speed:get();
                    local v1054 = v1052.flick_speed_random:get();
                    if v1054 > 0 then
                        v1053 = v1053 + utils.random_int(-v1054, v1054);
                        v1053 = math.clamp(v1053, 2, 10);
                    end;
                    if v1053 < v395.defensive_ticks - v395.max_defensive_ticks then
                        return;
                    end;
                end;
                local v1055 = v1052.flick_limit:get();
                l_l_match_0_2.yaw = "Backward";
                l_l_match_0_2.yaw_offset = 0;
                l_l_match_0_2.yaw_left = 0;
                l_l_match_0_2.yaw_right = 0;
                l_l_match_0_2.hidden = true;
                l_l_match_0_2.yaw_modifier = "Disabled";
                l_l_match_0_2.modifier_offset = 0;
                l_l_match_0_2.body_yaw = true;
                l_l_match_0_2.inverter = false;
                l_l_match_0_2.left_limit = v1055;
                l_l_match_0_2.right_limit = v1055;
                l_l_match_0_2.options = {};
                local v1056 = {};
                local v1057 = v1052.flick_pitch:get();
                local v1058 = v1052.flick_yaw:get();
                local v1059 = v1052.flick_yaw_random:get();
                v1058 = v1058 + utils.random_int(-v1059 * 0.6, v1059 * 0.6);
                v1056.pitch_offset = v1057;
                v1056.yaw_offset = v1058;
                v1057 = l_l_v992_0_1.enabled:get();
                if v1052.flick_mode:get() == "Silent" and bit.band(l_v1042_0, 1) ~= 0 then
                    v1057 = not v1057;
                end;
                if v1057 then
                    v1056.yaw_offset = -v1056.yaw_offset;
                end;
                l_l_match_0_2.defensive = v1056;
                return true;
            end;
        end;
    end;
    l_v992_0 = {};
    v1042 = v384.antiaim.recorder;
    v1046 = v384.antiaim.builder;
    local v1060 = "dWP7FQ3AEliGeqr98jbUM64XmCfc05gw1JDHhaYBKk2tRxVypInNouvsLZzOST+/=";
    local v1061 = {};
    local v1062 = 0;
    local function v1066(v1063)
        local l_status_8, l_result_8 = pcall(json.parse, v1063);
        if not l_status_8 then
            return false, "Can't parse data";
        else
            return true, l_result_8;
        end;
    end;
    do
        local l_v1042_1, l_v1046_1, l_v1060_0, l_v1061_0, l_v1062_0, l_v1066_0 = v1042, v1046, v1060, v1061, v1062, v1066;
        local function v1076(v1073)
            -- upvalues: l_base64_0 (ref), l_v1060_0 (ref)
            local l_status_9, l_result_9 = pcall(l_base64_0.decode, v1073, l_v1060_0);
            if not l_status_9 then
                return false, "Can't decode data";
            else
                return true, l_result_9;
            end;
        end;
        local function v1078(v1077)
            if type(v1077) == "table" then
                v1077 = "[ " .. table.concat(v1077, ", ") .. " ]";
            end;
            return v1077;
        end;
        local function _(v1079, v1080)
            table.insert(v1079, {
                measure = vector(0, v1080)
            });
            return v1080;
        end;
        local function v1086(v1082, v1083)
            -- upvalues: l_play_0 (ref)
            local v1084 = l_play_0.measure_text(1, "", v1083);
            local v1085 = {
                text = v1083,
                measure = v1084
            };
            table.insert(v1082, v1085);
            return v1085;
        end;
        local function _(v1087, v1088, v1089)
            -- upvalues: v1078 (ref), v1086 (ref)
            local v1090 = string.format("%s: \a{Link Active}%s\aDEFAULT", v1088, v1078(v1089));
            return v1086(v1087, v1090);
        end;
        local function v1095(v1092, v1093, v1094)
            -- upvalues: v3 (ref)
            if v1092 == v1093 and v1092 == v1094 then
                return ui.get_icon("arrow-right") .. v3:rep(3);
            elseif v1092 == v1093 then
                return ui.get_icon("arrow-down") .. v3:rep(4);
            elseif v1092 == v1094 then
                return ui.get_icon("arrow-up") .. v3:rep(4);
            elseif v1093 < v1092 and v1092 < v1094 then
                return v3:rep(2) .. ui.get_icon("pipe") .. v3:rep(6);
            else
                return v3:rep(9);
            end;
        end;
        local function v1103(v1096)
            -- upvalues: v10 (ref), v1095 (ref)
            if v1096 == nil then
                return {};
            else
                local l_data_0 = v1096.data;
                local l_sequence_start_0 = v1096.sequence_start;
                local l_sequence_end_0 = v1096.sequence_end;
                if l_data_0 == nil then
                    return {};
                else
                    local v1100 = {};
                    for v1101 = 1, #l_data_0 do
                        local v1102 = l_data_0[v1101];
                        v1100[v1101] = v10(v1095(v1101, l_sequence_start_0, l_sequence_end_0), "\a{Link Active}", v1101, "\aDEFAULT", ":", " ", "Yaw: ", "\a{Link Active}", v1102[4], "\aDEFAULT", " ", "Modifier: ", "\a{Link Active}", v1102[8], "\aDEFAULT");
                    end;
                    return v1100;
                end;
            end;
        end;
        local function v1104()
            -- upvalues: l_v1046_1 (ref)
            return l_v1046_1.state:get();
        end;
        local function v1106(v1105)
            -- upvalues: l_v1046_1 (ref)
            return l_v1046_1[v1105];
        end;
        local function v1111(v1107, v1108)
            local l_status_10, l_result_10 = pcall(json.stringify, v1108);
            if not l_status_10 then
                return false;
            else
                v1107 = v1107.recorder;
                if v1107 == nil then
                    return false;
                else
                    v1107.record:set(l_result_10);
                    return true;
                end;
            end;
        end;
        local function v1115(v1112, v1113, v1114)
            v1112.pitch = v1113[1];
            v1112.yaw = v1113[2];
            v1112.yaw_base = v1113[3];
            v1112.yaw_offset = v1113[4];
            v1112.hidden = v1113[6];
            v1112.yaw_modifier = v1113[7];
            v1112.modifier_offset = v1113[8];
            v1112.body_yaw = v1113[9];
            v1112.inverter = v1113[10];
            v1112.left_limit = v1113[11];
            v1112.right_limit = v1113[12];
            v1112.options = v1113[13];
            v1112.freestanding_body_yaw = v1113[14];
            v1112.delay = nil;
            if v1114 then
                v1112.inverter = not v1112.inverter;
            end;
        end;
        local function v1117()
            -- upvalues: v1103 (ref), v150 (ref), l_v1042_1 (ref)
            local v1116 = v1103(v150.recorder);
            l_v1042_1.sequence_list:update(v1116);
        end;
        local function v1119(v1118)
            -- upvalues: l_v1042_1 (ref)
            l_v1042_1.sequence_list:visibility(v1118);
            l_v1042_1.set_start_button:visibility(v1118);
            l_v1042_1.set_end_button:visibility(v1118);
            l_v1042_1.save_button:visibility(v1118);
            l_v1042_1.import_button:visibility(not v1118);
        end;
        local function v1126()
            -- upvalues: v151 (ref), v1106 (ref), l_v1061_0 (ref)
            for v1120 = 0, #v151.states do
                local v1121 = v151.states[v1120];
                local v1122 = v1106(v1121);
                if v1122 ~= nil then
                    v1122 = v1122.recorder;
                    if v1122 ~= nil then
                        local v1123 = v1122.record:get();
                        local l_status_11, l_result_11 = pcall(json.parse, v1123);
                        if l_status_11 then
                            l_v1061_0[v1121] = l_result_11;
                        end;
                    end;
                end;
            end;
        end;
        l_v992_0.update = function(_, v1128)
            -- upvalues: v1106 (ref), v150 (ref), l_v1042_1 (ref), v1115 (ref), l_l_match_0_2 (ref), l_v1061_0 (ref), l_v1062_0 (ref)
            local v1129 = v1106(v1128);
            if v1129 == nil then
                return;
            else
                v1129 = v1129.recorder;
                if v1129 == nil then
                    return;
                else
                    local l_data_1 = v150.recorder.data;
                    local l_capture_0 = v150.recorder.capture;
                    if l_data_1 ~= nil and l_capture_0 ~= nil then
                        local v1132 = l_v1042_1.sequence_list:get();
                        if v1132 == nil then
                            return false;
                        else
                            local v1133 = l_data_1[v1132];
                            if v1133 == nil then
                                return false;
                            else
                                local v1134 = v1129.inverse_inverter:get();
                                v1115(l_l_match_0_2, v1133, v1134);
                                return true;
                            end;
                        end;
                    else
                        local v1135 = l_v1061_0[v1128];
                        if v1135 == nil then
                            return false;
                        else
                            local v1136 = #v1135;
                            if globals.choked_commands == 0 then
                                if v1136 <= l_v1062_0 then
                                    l_v1062_0 = 0;
                                end;
                                l_v1062_0 = l_v1062_0 + 1;
                            end;
                            local v1137 = v1135[l_v1062_0];
                            if v1137 == nil then
                                return false;
                            else
                                local v1138 = v1129.inverse_inverter:get();
                                v1115(l_l_match_0_2, v1137, v1138);
                                return true;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        local function v1139()
            -- upvalues: v1126 (ref)
            v1126();
        end;
        local _ = nil;
        local function v1142()
            -- upvalues: v150 (ref), l_v1042_1 (ref), v1117 (ref)
            if v150.recorder.capture == nil then
                return;
            else
                local v1141 = l_v1042_1.sequence_list:get();
                if v150.recorder.sequence_end < v1141 then
                    v150.recorder.sequence_end = #v150.recorder.data;
                end;
                v150.recorder.sequence_start = v1141;
                v1117();
                return;
            end;
        end;
        local function v1144()
            -- upvalues: v150 (ref), l_v1042_1 (ref), v1117 (ref)
            if v150.recorder.capture == nil then
                return;
            else
                local v1143 = l_v1042_1.sequence_list:get();
                if v1143 < v150.recorder.sequence_start then
                    v150.recorder.sequence_start = 1;
                end;
                v150.recorder.sequence_end = v1143;
                v1117();
                return;
            end;
        end;
        local function v1150()
            -- upvalues: v1104 (ref), v1106 (ref), v150 (ref), v1111 (ref), v1117 (ref), v1119 (ref), v1126 (ref)
            local v1145 = v1104();
            if v1145 == nil then
                return;
            else
                local v1146 = v1106(v1145);
                if v1146 == nil then
                    return;
                else
                    local l_data_2 = v150.recorder.data;
                    if l_data_2 == nil then
                        return;
                    else
                        local v1148 = {};
                        for v1149 = v150.recorder.sequence_start, v150.recorder.sequence_end do
                            table.insert(v1148, l_data_2[v1149]);
                        end;
                        v1111(v1146, v1148);
                        v150.recorder.data = nil;
                        v150.recorder.capture = nil;
                        v150.recorder.sequence_start = nil;
                        v150.recorder.sequence_end = nil;
                        v1117();
                        v1119(false);
                        v1126();
                        return;
                    end;
                end;
            end;
        end;
        local function v1157()
            -- upvalues: v1104 (ref), v1106 (ref), l_clipboard_0 (ref), v1076 (ref), l_v1066_0 (ref), v150 (ref), v1119 (ref), v1117 (ref)
            local v1151 = v1104();
            if v1151 == nil then
                return;
            elseif v1106(v1151) == nil then
                return;
            else
                local v1152 = l_clipboard_0.get();
                if v1152 == nil then
                    return nil;
                else
                    local v1153, v1154 = v1076(v1152);
                    if not v1153 or v1154 == nil then
                        return;
                    else
                        local v1155, v1156 = l_v1066_0(v1154);
                        v1154 = v1156;
                        if not v1155 or v1154 == nil then
                            return;
                        else
                            v1155 = #v1154;
                            v150.recorder.data = v1154;
                            v150.recorder.capture = v1151;
                            v150.recorder.sequence_start = 1;
                            v150.recorder.sequence_end = v1155;
                            v1119(true);
                            v1117();
                            return;
                        end;
                    end;
                end;
            end;
        end;
        l_v1042_1.set_start_button:set_callback(v1142);
        l_v1042_1.set_end_button:set_callback(v1144);
        l_v1042_1.save_button:set_callback(v1150);
        l_v1042_1.import_button:set_callback(v1157);
        events.update_records(v1139);
        v1119(false);
        v1126();
    end;
    v1042 = {};
    v1046 = v384.antiaim.builder;
    v1060 = nil;
    v1061 = function(v1158)
        -- upvalues: l_l_match_0_2 (ref)
        local l_angles_1 = v1158.angles;
        l_l_match_0_2.yaw = "Backward";
        l_l_match_0_2.yaw_offset = l_angles_1.yaw_offset:get();
        if l_angles_1.add_yaw:get() then
            local v1160 = l_angles_1.random:get();
            local v1161 = l_angles_1.yaw_left:get();
            local v1162 = l_angles_1.yaw_right:get();
            if v1160 > 0 then
                local v1163 = v1160 * 0.01;
                local v1164 = utils.random_float(-v1163 * 0.6, v1163 * 0.6);
                v1161 = v1161 + v1161 * v1164;
                v1162 = v1162 + v1162 * v1164;
            end;
            l_l_match_0_2.yaw_left = v1161;
            l_l_match_0_2.yaw_right = v1162;
        end;
    end;
    v1062 = function(v1165)
        -- upvalues: l_l_match_0_2 (ref)
        local l_angles_2 = v1165.angles;
        local v1167 = l_angles_2.yaw_jitter:get();
        local v1168 = l_angles_2.jitter_offset:get();
        if v1167 == "Off" then
            l_l_match_0_2.yaw_modifier = "Disabled";
            l_l_match_0_2.modifier_offset = nil;
            return;
        else
            local v1169 = l_angles_2.random:get();
            if v1169 > 0 then
                local v1170 = v1169 * 0.01;
                v1168 = v1168 + v1168 * utils.random_float(-v1170 * 0.6, v1170 * 0.6);
            end;
            l_l_match_0_2.yaw_modifier = v1167;
            l_l_match_0_2.modifier_offset = v1168;
            if l_angles_2.way ~= nil then
                l_l_match_0_2.way = {};
                for v1171 = 1, #l_angles_2.way do
                    l_l_match_0_2.way[v1171] = l_angles_2.way[v1171]:get();
                end;
            end;
            return;
        end;
    end;
    v1066 = function(v1172)
        -- upvalues: l_l_match_0_2 (ref)
        local l_angles_3 = v1172.angles;
        local v1174 = l_angles_3.body_yaw:get();
        local v1175 = l_angles_3.left_limit:get();
        local v1176 = l_angles_3.right_limit:get();
        local v1177 = v1174 ~= "Off";
        if v1177 then
            l_l_match_0_2.options = {};
            l_l_match_0_2.left_limit = v1175;
            l_l_match_0_2.right_limit = v1176;
            if v1174 == "Left" then
                l_l_match_0_2.inverter = true;
                l_l_match_0_2.right_limit = v1175;
            end;
            if v1174 == "Right" then
                l_l_match_0_2.inverter = false;
                l_l_match_0_2.left_limit = v1176;
            end;
            if v1174 == "Jitter" then
                table.insert(l_l_match_0_2.options, "Jitter");
            end;
            if v1174 == "Random" then
                table.insert(l_l_match_0_2.options, "Jitter");
                table.insert(l_l_match_0_2.options, "Randomize Jitter");
            end;
            if l_angles_3.avoid_overlap:get() then
                table.insert(l_l_match_0_2.options, "Avoid Overlap");
            end;
            l_l_match_0_2.freestanding_body_yaw = l_angles_3.freestanding_body_yaw:get();
        end;
        local v1178 = l_angles_3.delay:get();
        local v1179 = l_angles_3.random_delay:get();
        if v1178 ~= nil and v1178 > 1 then
            if v1179 ~= nil and v1179 > 0 then
                v1178 = utils.random_int(v1178, v1179);
            end;
            l_l_match_0_2.delay = v1178;
        end;
        l_l_match_0_2.body_yaw = v1177;
    end;
    do
        local l_v1046_2, l_v1060_1, l_v1061_1, l_v1062_1, l_v1066_1 = v1046, v1060, v1061, v1062, v1066;
        v1042.get = function(_, v1186)
            -- upvalues: l_v1046_2 (ref)
            return l_v1046_2[v1186];
        end;
        v1042.is_active_ex = function(_, v1188)
            return v1188.enabled == nil or v1188.enabled:get();
        end;
        v1042.is_active = function(v1189, v1190)
            -- upvalues: v1042 (ref)
            local v1191 = v1189:get(v1190);
            if v1191 == nil then
                return false;
            else
                return v1042:is_active_ex(v1191);
            end;
        end;
        v1042.get_old_items = function(_)
            -- upvalues: l_v1060_1 (ref)
            return l_v1060_1;
        end;
        v1042.apply_ex = function(_, v1194)
            -- upvalues: l_l_match_0_2 (ref), l_v1061_1 (ref), l_v1062_1 (ref), l_v1066_1 (ref), l_v1060_1 (ref)
            if v1194 == nil then
                return false;
            else
                if v1194.angles ~= nil then
                    l_l_match_0_2.enabled = true;
                    l_l_match_0_2.pitch = "Down";
                    l_l_match_0_2.yaw_base = "At Target";
                    l_v1061_1(v1194);
                    l_v1062_1(v1194);
                    l_v1066_1(v1194);
                end;
                l_v1060_1 = v1194;
                return true;
            end;
        end;
        v1042.apply = function(v1195, v1196)
            -- upvalues: l_v992_0 (ref)
            local v1197 = v1195:get(v1196);
            if v1197 == nil then
                return nil;
            elseif not v1195:is_active_ex(v1197) then
                return nil;
            else
                local v1198 = v1197.mode:get();
                if v1198 == "Builder" then
                    v1195:apply_ex(v1197);
                end;
                if v1198 == "Recorder" then
                    l_v992_0:update(v1196);
                end;
                return v1197;
            end;
        end;
        v1042.update = function(v1199, _)
            -- upvalues: v398 (ref)
            if rage.exploit:get() ~= 1 then
                local v1201 = v1199:apply("Fakelag");
                if v1201 ~= nil then
                    return v1201;
                end;
            end;
            local v1202 = v1199:apply((v398.get()));
            if v1202 ~= nil then
                return v1202;
            else
                return v1199:apply("Shared");
            end;
        end;
        v844.builder = v1042;
    end;
    v1046 = {};
    v1060 = v384.antiaim.settings.antibrute;
    v1061 = nil;
    v1062 = nil;
    v1066 = nil;
    local v1203 = nil;
    local v1204 = v414.get_event_bus();
    do
        local l_v1060_2, l_v1061_2, l_v1062_2, l_v1066_2, l_v1203_0, l_v1204_0 = v1060, v1061, v1062, v1066, v1203, v1204;
        local function v1211()
            -- upvalues: l_v1060_2 (ref)
            if l_v1060_2.refresh_offset:get() then
                return math.random(-7, 13);
            else
                return nil;
            end;
        end;
        local function v1213()
            -- upvalues: l_v1060_2 (ref)
            local v1212 = l_v1060_2.refresh_modifier:get();
            if v1212 == "increase" then
                return math.random(0, 5);
            elseif v1212 == "decrease" then
                return math.random(-5, 0);
            elseif v1212 == "adaptive" then
                return math.random(-3, 5);
            else
                return nil;
            end;
        end;
        local function v1214()
            -- upvalues: l_v1061_2 (ref), l_v1062_2 (ref), l_v1066_2 (ref), l_v1203_0 (ref)
            l_v1061_2 = nil;
            l_v1062_2 = nil;
            l_v1066_2 = nil;
            l_v1203_0 = nil;
        end;
        v1046.update = function(_, _)
            -- upvalues: l_v1060_2 (ref), l_v1061_2 (ref), v1214 (ref), l_v1062_2 (ref), l_l_match_0_2 (ref), l_v1066_2 (ref), l_v1203_0 (ref)
            if not l_v1060_2.enabled:get() then
                return false;
            elseif l_v1061_2 ~= nil and globals.curtime > l_v1061_2 then
                v1214();
                return false;
            else
                if l_v1062_2 ~= nil then
                    l_l_match_0_2.delay = l_v1062_2;
                end;
                if l_v1066_2 ~= nil and l_l_match_0_2.yaw_offset ~= nil then
                    l_l_match_0_2.yaw_offset = l_l_match_0_2.yaw_offset + l_v1066_2;
                end;
                if l_v1203_0 ~= nil and l_l_match_0_2.modifier_offset ~= nil then
                    l_l_match_0_2.modifier_offset = l_l_match_0_2.modifier_offset + l_v1203_0;
                end;
                return true;
            end;
        end;
        local function v1218()
            -- upvalues: l_v1060_2 (ref), l_v1061_2 (ref), l_v1062_2 (ref), l_v1066_2 (ref), v1211 (ref), l_v1203_0 (ref), v1213 (ref)
            local v1217 = l_v1060_2.duration:get();
            if v1217 ~= 0 then
                l_v1061_2 = globals.curtime + v1217 * 0.1;
            end;
            if l_v1060_2.enforce_delay:get() then
                l_v1062_2 = math.random(1, 5);
            end;
            l_v1066_2 = v1211();
            l_v1203_0 = v1213();
        end;
        local _ = nil;
        local function v1222(v1220)
            -- upvalues: v1214 (ref), l_v1204_0 (ref), v1218 (ref)
            local v1221 = v1220:get();
            if not v1221 then
                v1214();
            end;
            l_v1204_0.enemy_shot:set(v1218, v1221);
        end;
        do
            local l_v1222_0 = v1222;
            local function v1226(v1224)
                -- upvalues: v1214 (ref), l_v1204_0 (ref), v1218 (ref), l_v1060_2 (ref), l_v1222_0 (ref)
                local v1225 = v1224:get();
                if not v1225 then
                    v1214();
                    l_v1204_0.enemy_shot:set(v1218, false);
                end;
                if v1225 then
                    l_v1060_2.enabled:set_callback(l_v1222_0, true);
                else
                    l_v1060_2.enabled:unset_callback(l_v1222_0);
                end;
            end;
            v384.antiaim.enabled:set_callback(v1226, true);
        end;
    end;
    v1060 = {};
    v1061 = v384.antiaim.settings.roll;
    do
        local l_v1061_3, l_v1062_3 = v1061, v1062;
        l_v1062_3 = function()
            -- upvalues: l_v1061_3 (ref)
            if l_v1061_3.change_on_fakelag:get() and rage.exploit:get() ~= 1 then
                return l_v1061_3.fakelag_value:get();
            else
                return l_v1061_3.value:get();
            end;
        end;
        v1060.update = function(_, v1230)
            -- upvalues: l_v1062_3 (ref)
            local v1231 = l_v1062_3();
            if v1231 == nil or v1231 == 0 then
                return;
            else
                v1230.view_angles.z = v1231;
                return;
            end;
        end;
    end;
    v1061 = {};
    v1062 = false;
    do
        local l_v1062_4, l_v1066_3 = v1062, v1066;
        l_v1066_3 = function(v1234, v1235)
            -- upvalues: l_play_0 (ref), l_v1062_4 (ref)
            local v1236 = entity.get_local_player();
            if v1236 == nil then
                return false;
            else
                local v1237 = v1236:get_player_weapon();
                if v1237 == nil then
                    return false;
                else
                    local l_m_iTeamNum_0 = v1236.m_iTeamNum;
                    local v1239 = v1236:get_origin();
                    local v1240 = v1237:get_weapon_index() == 49;
                    if v1236.m_bIsDefusing or v1236.m_bIsGrabbingHostage then
                        return false;
                    elseif v1236.m_bInBombZone and (not v1235.bomb_e_fix:get() or v1240) then
                        return false;
                    else
                        if l_m_iTeamNum_0 == 3 and v1234.view_angles.x > 15 then
                            local v1241 = entity.get_entities("CPlantedC4");
                            for v1242 = 1, #v1241 do
                                if (v1241[v1242]:get_origin() - v1239):lengthsqr() < 3844 then
                                    return false;
                                end;
                            end;
                        end;
                        local v1243 = l_play_0.camera_angles();
                        local v1244 = vector():angles(v1243);
                        local v1245 = v1236:get_eye_position();
                        local v1246 = v1245 + v1244 * 128;
                        local v1247 = utils.trace_line(v1245, v1246, v1236, 4294967295, 0);
                        if v1247.fraction ~= 1 then
                            local l_entity_0 = v1247.entity;
                            if l_entity_0 == nil then
                                return true;
                            else
                                local v1249 = l_entity_0:get_classname();
                                if v1249 == "CWorld" then
                                    return true;
                                elseif v1249 == "CFuncBrush" then
                                    return true;
                                elseif v1249 == "CCSPlayer" then
                                    return true;
                                elseif v1249 == "CHostage" and v1245:distsqr((l_entity_0:get_origin())) < 7056 then
                                    return false;
                                elseif not l_v1062_4 then
                                    l_v1062_4 = true;
                                    return false;
                                end;
                            end;
                        end;
                        return true;
                    end;
                end;
            end;
        end;
        v1061.update = function(_, v1251)
            -- upvalues: l_v1062_4 (ref), v1042 (ref), l_v1066_3 (ref), l_l_angles_0_1 (ref), l_v982_0 (ref), l_l_match_0_2 (ref)
            if not v1251.in_use then
                l_v1062_4 = false;
                return false;
            else
                local v1252 = v1042:get("On use");
                if v1252 == nil then
                    return false;
                elseif not v1042:is_active_ex(v1252) then
                    return false;
                elseif not l_v1066_3(v1251, v1252) then
                    return false;
                else
                    v1251.in_use = false;
                    v1042:apply_ex(v1252);
                    if v1252 ~= nil and v1252.defensive ~= nil then
                        l_l_angles_0_1:apply(v1251, v1252.defensive);
                        l_v982_0:update(v1251, v1252.defensive);
                    end;
                    if l_l_match_0_2.yaw_offset ~= nil then
                        l_l_match_0_2.yaw_offset = l_l_match_0_2.yaw_offset + 180;
                    end;
                    l_l_match_0_2.pitch = "Disabled";
                    l_l_match_0_2.yaw_base = "Local View";
                    l_l_match_0_2.freestanding = false;
                    return true;
                end;
            end;
        end;
    end;
    v1062 = {};
    v1066 = v384.antiaim.settings.manual_yaw;
    v1203 = {
        Forward = 180,
        Right = 90,
        Left = -90,
        Backward = 0
    };
    do
        local l_v1066_4, l_v1203_1, l_v1204_1 = v1066, v1203, v1204;
        l_v1204_1 = function()
            -- upvalues: l_v1203_1 (ref), l_v1066_4 (ref)
            return l_v1203_1[l_v1066_4.select:get()];
        end;
        v1062.update = function(_, v1257)
            -- upvalues: l_v1204_1 (ref), l_l_match_0_2 (ref), l_v1066_4 (ref), v1042 (ref), l_v982_0 (ref), l_l_angles_0_1 (ref)
            local v1258 = l_v1204_1();
            if v1258 == nil then
                return false;
            else
                local v1259 = l_l_match_0_2.yaw_offset or 0;
                l_l_match_0_2.enabled = true;
                l_l_match_0_2.yaw_offset = v1259 + v1258;
                l_l_match_0_2.freestanding = false;
                if l_v1066_4.disable_yaw_modifiers:get() then
                    l_l_match_0_2.yaw_offset = v1259 + v1258;
                    l_l_match_0_2.yaw_left = 0;
                    l_l_match_0_2.yaw_right = 0;
                    l_l_match_0_2.yaw_modifier = "Disabled";
                    l_l_match_0_2.modifier_offset = 0;
                end;
                if l_v1066_4.body_freestanding:get() then
                    l_l_match_0_2.body_yaw = true;
                    l_l_match_0_2.left_limit = 60;
                    l_l_match_0_2.right_limit = 60;
                    l_l_match_0_2.options = {};
                    l_l_match_0_2.freestanding_body_yaw = "Peek Fake";
                end;
                local v1260 = v1042:apply("Manual Yaw");
                if v1260 ~= nil then
                    l_l_match_0_2.yaw_offset = l_l_match_0_2.yaw_offset + v1258;
                    if v1260.defensive ~= nil and (l_v982_0:update(v1257, v1260.defensive) or l_l_angles_0_1:apply(v1257, v1260.defensive)) then
                        local l_yaw_offset_0 = l_l_match_0_2.defensive.yaw_offset;
                        if l_yaw_offset_0 ~= nil then
                            l_l_match_0_2.defensive.yaw_offset = l_yaw_offset_0 + v1258;
                        end;
                    end;
                end;
                l_l_match_0_2.yaw_base = "Local View";
                return true;
            end;
        end;
    end;
    v1066 = {};
    v1203 = v384.antiaim.settings.freestanding;
    v1204 = function()
        -- upvalues: v394 (ref), v26 (ref)
        if not v394.is_onground then
            return "Air";
        elseif v394.is_crouched then
            return "Crouching";
        elseif v394.is_moving then
            if v26.antiaim.misc.slow_walk:get() then
                return "Slow motion";
            else
                return "Running";
            end;
        else
            return "Standing";
        end;
    end;
    do
        local l_v1203_2, l_v1204_2 = v1203, v1204;
        local function v1264()
            -- upvalues: l_v1203_2 (ref), l_v1204_2 (ref)
            return l_v1203_2.disablers:get(l_v1204_2());
        end;
        local function v1265()
            -- upvalues: l_v1203_2 (ref), v1264 (ref)
            return l_v1203_2.enabled:get() and not v1264();
        end;
        local function v1268()
            local v1266 = rage.antiaim:get_target(false);
            local v1267 = rage.antiaim:get_target(true);
            if v1266 == nil or v1267 == nil then
                return nil;
            else
                return v1267 - v1266;
            end;
        end;
        local function v1273(v1269)
            -- upvalues: v1268 (ref), v1042 (ref), l_l_match_0_2 (ref), l_v1203_2 (ref), l_v982_0 (ref), l_l_angles_0_1 (ref)
            local v1270 = v1268();
            if v1270 == nil then
                return;
            else
                local v1271 = v1042:apply("Freestanding");
                if v1271 == nil then
                    l_l_match_0_2.freestanding = true;
                    l_l_match_0_2.freestanding_disable_yaw_modifiers = l_v1203_2.disable_yaw_modifiers:get();
                    l_l_match_0_2.freestanding_body_freestanding = l_v1203_2.body_freestanding:get();
                    return;
                else
                    l_l_match_0_2.yaw_offset = l_l_match_0_2.yaw_offset + v1270;
                    if v1271.defensive ~= nil and (l_v982_0:update(v1269, v1271.defensive) or l_l_angles_0_1:apply(v1269, v1271.defensive)) then
                        local l_yaw_offset_1 = l_l_match_0_2.defensive.yaw_offset;
                        if l_yaw_offset_1 ~= nil then
                            l_l_match_0_2.defensive.yaw_offset = l_yaw_offset_1 + v1270;
                        end;
                    end;
                    l_l_match_0_2.freestanding = false;
                    return;
                end;
            end;
        end;
        v1066.update = function(_, v1275)
            -- upvalues: v1265 (ref), l_l_match_0_2 (ref), v1273 (ref)
            if not v1265() then
                l_l_match_0_2.freestanding = false;
                return false;
            else
                v1273(v1275);
                return true;
            end;
        end;
    end;
    v1203 = {};
    v1204 = v384.antiaim.settings.edge_yaw;
    local function v1290(v1276)
        local v1277 = entity.get_local_player();
        if v1277 == nil then
            return nil;
        else
            local v1278 = v1277:get_eye_position();
            if v1278 == nil then
                return nil;
            else
                local v1279 = 1;
                local v1280 = nil;
                local v1281 = {};
                for v1282 = -180, 179, 45 do
                    local v1283 = v1278 + vector():angles(vector(0, v1282, 0)) * 24;
                    local v1284 = utils.trace_line(v1278, v1283, v1277);
                    if v1284.fraction < v1279 and (v1284.entity == nil or not v1284.entity:is_player()) then
                        local l_fraction_0 = v1284.fraction;
                        v1280 = v1282;
                        v1279 = l_fraction_0;
                    end;
                end;
                if v1280 == nil then
                    return nil;
                else
                    for v1286 = v1280 - 30, v1280 + 30, 10 do
                        local v1287 = v1278 + vector():angles(vector(0, v1286, 0)) * 24;
                        local v1288 = utils.trace_line(v1278, v1287, v1277, nil, 1);
                        if v1288.fraction < 1 then
                            v1281[#v1281 + 1] = v1286;
                            if v1288.fraction < v1279 then
                                local l_fraction_1 = v1288.fraction;
                                v1280 = v1286;
                                v1279 = l_fraction_1;
                            end;
                        end;
                    end;
                    return math.normalize_yaw(v1280 * 2 - v1276.move_yaw);
                end;
            end;
        end;
    end;
    do
        local l_v1204_3, l_v1290_0 = v1204, v1290;
        v1203.update = function(_, v1294)
            -- upvalues: l_v1204_3 (ref), l_v1290_0 (ref), l_l_match_0_2 (ref)
            if not l_v1204_3.enabled:get() then
                return false;
            else
                local v1295 = l_v1290_0(v1294);
                if v1295 == nil then
                    return false;
                else
                    l_l_match_0_2.yaw_offset = (l_l_match_0_2.yaw_offset or 0) + v1295;
                    return true;
                end;
            end;
        end;
    end;
    v1204 = {};
    v1290 = v384.antiaim.settings.safe_head;
    local v1296 = 0;
    local v1297 = 1440000;
    local function v1299(v1298)
        return v1298:get_weapon_index() == 31;
    end;
    do
        local l_v1290_1, l_v1296_0, l_v1297_0, l_v1299_0 = v1290, v1296, v1297, v1299;
        local function v1306(v1304)
            -- upvalues: l_v1299_0 (ref), l_v1296_0 (ref)
            if l_v1299_0(v1304) then
                return false;
            else
                local v1305 = v1304:get_weapon_info();
                if v1305 == nil then
                    return false;
                else
                    return v1305.weapon_type == l_v1296_0;
                end;
            end;
        end;
        local function v1317()
            -- upvalues: v1306 (ref), l_v1299_0 (ref), v394 (ref), l_v1290_1 (ref), l_v1297_0 (ref)
            local v1307 = entity.get_local_player();
            if v1307 == nil then
                return nil;
            else
                local v1308 = v1307:get_player_weapon();
                if v1308 == nil then
                    return nil;
                else
                    local v1309 = entity.get_threat();
                    if v1309 == nil then
                        return nil;
                    else
                        local v1310 = v1306(v1308);
                        local v1311 = l_v1299_0(v1308);
                        local v1312 = not v394.is_onground;
                        local l_is_moving_0 = v394.is_moving;
                        local l_is_crouched_0 = v394.is_crouched;
                        local v1315 = v1307:get_origin() - v1309:get_origin();
                        local v1316 = v1315:lengthsqr();
                        if v1310 and v1312 and l_is_crouched_0 and l_v1290_1.select:get("With Knife") then
                            return "With Knife";
                        elseif v1311 and v1312 and l_is_crouched_0 and l_v1290_1.select:get("With Taser") then
                            return "With Taser";
                        elseif v1315.z > 50 and (not l_is_moving_0 or l_is_crouched_0) and l_v1290_1.select:get("Above Enemy") then
                            return "Above Enemy";
                        elseif l_v1297_0 < v1316 and not l_is_moving_0 and l_is_crouched_0 and l_v1290_1.select:get("Far from Enemy") then
                            return "Far from Enemy";
                        else
                            return nil;
                        end;
                    end;
                end;
            end;
        end;
        local function v1321(v1318, _)
            -- upvalues: v1042 (ref), l_l_angles_0_1 (ref), l_v982_0 (ref), l_l_match_0_2 (ref)
            local v1320 = v1042:apply("Safe Head");
            if v1320 ~= nil then
                if v1318 ~= nil and v1320.defensive ~= nil then
                    l_l_angles_0_1:apply(v1318, v1320.defensive);
                    l_v982_0:update(v1318, v1320.defensive);
                end;
                return true;
            else
                l_l_match_0_2.pitch = "Down";
                l_l_match_0_2.yaw_base = "At Target";
                l_l_match_0_2.yaw = "Backward";
                l_l_match_0_2.yaw_offset = 10;
                l_l_match_0_2.yaw_left = 0;
                l_l_match_0_2.yaw_right = 0;
                l_l_match_0_2.yaw_modifier = "Off";
                l_l_match_0_2.modifier_offset = 0;
                l_l_match_0_2.body_yaw = true;
                l_l_match_0_2.left_limit = 0;
                l_l_match_0_2.right_limit = 0;
                l_l_match_0_2.freestanding_body_yaw = "Off";
                return;
            end;
        end;
        v1204.update = function(_, v1323)
            -- upvalues: v1317 (ref), v1321 (ref)
            local v1324 = v1317();
            if v1324 == nil then
                return false;
            else
                v1321(v1323, v1324);
                return true;
            end;
        end;
    end;
    v1290 = function()
        -- upvalues: l_l_match_0_2 (ref), l_v891_1 (ref), v7 (ref), l_v845_1 (ref), l_v846_2 (ref)
        if rage.exploit:get() == 1 then
            local v1325 = math.max(1, l_l_match_0_2.delay or 1);
            l_v891_1 = l_v891_1 + 1;
            if l_v891_1 < v1325 then
                return;
            end;
        end;
        local v1326 = true;
        if l_l_match_0_2.options ~= nil and v7(l_l_match_0_2.options, "Randomize Jitter") ~= nil then
            v1326 = utils.random_int(0, 1) == 0;
        end;
        l_v845_1 = l_v845_1 + 1;
        if v1326 then
            l_v846_2 = not l_v846_2;
        end;
        l_v891_1 = 0;
    end;
    v1296 = function()
        -- upvalues: l_l_match_0_2 (ref), l_v892_1 (ref), l_v888_0 (ref), l_v889_1 (ref)
        local l_defensive_0 = l_l_match_0_2.defensive;
        local v1328 = 1;
        if l_defensive_0 ~= nil and l_defensive_0.delay ~= nil then
            v1328 = math.max(1, l_defensive_0.delay);
        end;
        l_v892_1 = l_v892_1 + 1;
        if l_v892_1 < v1328 then
            return;
        else
            l_v888_0 = l_v888_0 + 1;
            l_v889_1 = not l_v889_1;
            l_v892_1 = 0;
            return;
        end;
    end;
    v1297 = function()
        -- upvalues: l_l_match_0_2 (ref), l_v889_1 (ref), l_v888_0 (ref), l_v890_1 (ref)
        local l_defensive_1 = l_l_match_0_2.defensive;
        if l_defensive_1 == nil then
            return;
        else
            if l_defensive_1.pitch_offset ~= nil then
                rage.antiaim:override_hidden_pitch(l_defensive_1.pitch_offset);
            end;
            if l_defensive_1.yaw_offset ~= nil then
                local l_yaw_offset_2 = l_defensive_1.yaw_offset;
                if l_l_match_0_2.yaw_offset ~= nil then
                    l_yaw_offset_2 = l_yaw_offset_2 - l_l_match_0_2.yaw_offset;
                end;
                if l_defensive_1.yaw_left ~= nil and l_v889_1 == true then
                    l_yaw_offset_2 = l_yaw_offset_2 + l_defensive_1.yaw_left;
                end;
                if l_defensive_1.yaw_right ~= nil and l_v889_1 == false then
                    l_yaw_offset_2 = l_yaw_offset_2 + l_defensive_1.yaw_right;
                end;
                if l_defensive_1.yaw_modifier == "Offset" then
                    local l_modifier_offset_0 = l_defensive_1.modifier_offset;
                    if not l_v889_1 then
                        l_modifier_offset_0 = 0;
                    end;
                    l_yaw_offset_2 = l_yaw_offset_2 + l_modifier_offset_0;
                end;
                if l_defensive_1.yaw_modifier == "Center" then
                    local v1332 = l_defensive_1.modifier_offset * 0.5;
                    if not l_v889_1 then
                        v1332 = -v1332;
                    end;
                    l_yaw_offset_2 = l_yaw_offset_2 + v1332;
                end;
                if l_defensive_1.yaw_modifier == "Skitter" then
                    l_yaw_offset_2 = l_yaw_offset_2 + l_defensive_1.modifier_offset * l_v890_1[l_v888_0 % #l_v890_1 + 1];
                end;
                rage.antiaim:override_hidden_yaw_offset(-l_yaw_offset_2);
            end;
            return;
        end;
    end;
    v1299 = function()
        -- upvalues: l_l_match_0_2 (ref)
        if l_l_match_0_2.yaw_left ~= nil and l_l_match_0_2.yaw_right ~= nil then
            local v1333 = l_l_match_0_2.yaw_offset or 0;
            if l_l_match_0_2.inverter == true then
                l_l_match_0_2.yaw_offset = v1333 + l_l_match_0_2.yaw_left;
            end;
            if l_l_match_0_2.inverter == false then
                l_l_match_0_2.yaw_offset = v1333 + l_l_match_0_2.yaw_right;
            end;
            return;
        else
            return;
        end;
    end;
    local function v1349()
        -- upvalues: l_l_match_0_2 (ref), l_v846_2 (ref), l_v845_1 (ref), l_v890_1 (ref), v14 (ref)
        if l_l_match_0_2.yaw_modifier == "Offset" then
            local v1334 = l_l_match_0_2.yaw_offset or 0;
            local l_modifier_offset_1 = l_l_match_0_2.modifier_offset;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1334 + (l_v846_2 and l_modifier_offset_1 or 0);
            return;
        elseif l_l_match_0_2.yaw_modifier == "Center" then
            local v1336 = l_l_match_0_2.yaw_offset or 0;
            local l_modifier_offset_2 = l_l_match_0_2.modifier_offset;
            if not l_v846_2 then
                l_modifier_offset_2 = -l_modifier_offset_2;
            end;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1336 + l_modifier_offset_2 / 2;
            return;
        elseif l_l_match_0_2.yaw_modifier == "Skitter" then
            local v1338 = l_v890_1[l_v845_1 % #l_v890_1 + 1];
            local v1339 = l_l_match_0_2.yaw_offset or 0;
            local l_modifier_offset_3 = l_l_match_0_2.modifier_offset;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1339 + l_modifier_offset_3 * v1338;
            return;
        elseif l_l_match_0_2.yaw_modifier == "Custom Ways" then
            local v1341 = l_l_match_0_2.yaw_offset or 0;
            local v1342 = 0;
            if l_l_match_0_2.way ~= nil then
                local v1343 = l_l_match_0_2.way[l_v845_1 % 3 + 1];
                if v1343 ~= nil then
                    v1342 = v1343;
                end;
            end;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1341 + v1342;
            return;
        elseif l_l_match_0_2.yaw_modifier == "Spin" then
            local v1344 = globals.curtime * 3;
            local v1345 = l_l_match_0_2.yaw_offset or 0;
            local l_modifier_offset_4 = l_l_match_0_2.modifier_offset;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1345 + v14.lerp(-l_modifier_offset_4, l_modifier_offset_4, v1344 % 1);
            return;
        elseif l_l_match_0_2.yaw_modifier == "Random" then
            local v1347 = l_l_match_0_2.yaw_offset or 0;
            local l_modifier_offset_5 = l_l_match_0_2.modifier_offset;
            l_l_match_0_2.yaw_modifier = "Off";
            l_l_match_0_2.modifier_offset = 0;
            l_l_match_0_2.yaw_offset = v1347 + utils.random_int(-l_modifier_offset_5, l_modifier_offset_5);
            return;
        else
            return;
        end;
    end;
    local function v1354()
        -- upvalues: l_l_match_0_2 (ref), l_v846_2 (ref)
        if l_l_match_0_2.options == nil then
            return;
        else
            local v1350 = false;
            local v1351 = {};
            for v1352 = 1, #l_l_match_0_2.options do
                local v1353 = l_l_match_0_2.options[v1352];
                if v1353 == "Jitter" then
                    v1350 = true;
                elseif v1353 ~= "Randomize Jitter" then
                    table.insert(v1351, v1353);
                end;
            end;
            if v1350 then
                l_l_match_0_2.inverter = l_v846_2;
            end;
            l_l_match_0_2.options = v1351;
            return;
        end;
    end;
    local function v1357(v1355)
        -- upvalues: l_l_angles_0_1 (ref), v1042 (ref), v1046 (ref), v1061 (ref), v1060 (ref), v1062 (ref), v1066 (ref), v1204 (ref), v1203 (ref), l_v982_0 (ref)
        l_l_angles_0_1:update(v1355);
        local v1356 = v1042:update();
        v1046:update(v1355);
        if v1061:update(v1355) then
            return;
        else
            v1060:update(v1355);
            if v1062:update(v1355) then
                return;
            elseif v1066:update(v1355) then
                return;
            elseif v1204:update(v1355) then
                return;
            elseif v1203:update(v1355) then
                return;
            else
                if v1356 ~= nil and v1356.defensive ~= nil then
                    l_l_angles_0_1:apply(v1355, v1356.defensive);
                    l_v982_0:update(v1355, v1356.defensive);
                end;
                return;
            end;
        end;
    end;
    local function v1359(v1358)
        -- upvalues: v1290 (ref), v1296 (ref), v1354 (ref), v1349 (ref), v1299 (ref), v1297 (ref)
        rage.antiaim:override_hidden_yaw_offset(0);
        if v1358.choked_commands == 0 then
            v1290();
            v1296();
        end;
        v1354();
        v1349();
        v1299();
        v1297();
    end;
    local function v1360()
        -- upvalues: l_l_match_0_2 (ref)
        l_l_match_0_2:unset();
    end;
    local function v1362(v1361)
        -- upvalues: l_l_match_0_2 (ref), v1357 (ref), v1359 (ref)
        l_l_match_0_2:clear();
        l_l_match_0_2:unset();
        v1357(v1361);
        v1359(v1361);
        l_l_match_0_2:set();
    end;
    local _ = nil;
    local l_antiaim_0 = v384.antiaim;
    local function v1367(v1365)
        -- upvalues: l_l_match_0_2 (ref), v26 (ref), v1360 (ref), v1362 (ref)
        local v1366 = v1365:get();
        if not v1366 then
            l_l_match_0_2:unset();
            v26.ragebot.main.hide_shots[2]:override();
            v26.ragebot.main.double_tap[2]:override();
        end;
        events.shutdown(v1360, v1366);
        events.createmove(v1362, v1366);
    end;
    l_antiaim_0.enabled:set_callback(v1367, true);
end;
v845 = nil;
v846 = nil;
v888 = v384.ragebot.aimtools;
v889 = 0;
v890 = 1;
v891 = 2;
v892 = 3;
l_match_0 = 4;
l_angles_0 = 5;
v982 = 6;
v992 = 7;
local v1368 = 10;
local v1369 = 1;
local v1370 = 5;
local l_aimtools_0 = v151.aimtools;
local v1372 = {};
local v1373 = {};
do
    local l_v888_1, l_v890_2, l_v892_2, l_v982_1, l_v992_1, l_v1369_0, l_v1370_0, l_l_aimtools_0_0, l_v1372_0, l_v1373_0 = v888, v890, v892, v982, v992, v1369, v1370, l_aimtools_0, v1372, v1373;
    local function v1385(v1384)
        -- upvalues: l_v1373_0 (ref)
        l_v1373_0[v1384] = {
            head_scale = ui.find("Aimbot", "Ragebot", "Selection", v1384, "Multipoint", "Head Scale"),
            body_scale = ui.find("Aimbot", "Ragebot", "Selection", v1384, "Multipoint", "Body Scale"),
            hit_chance = ui.find("Aimbot", "Ragebot", "Selection", v1384, "Hit Chance"),
            body_aim = ui.find("Aimbot", "Ragebot", "Safety", v1384, "Body Aim"),
            safe_points = ui.find("Aimbot", "Ragebot", "Safety", v1384, "Safe Points")
        };
    end;
    for v1386 = 1, #l_l_aimtools_0_0 do
        v1385(l_l_aimtools_0_0[v1386]);
    end;
    v1385 = function(v1387)
        -- upvalues: l_v1369_0 (ref), l_v1370_0 (ref)
        local v1388 = v1387:get_weapon_info();
        if v1388 == nil then
            return nil;
        else
            local l_weapon_type_0 = v1388.weapon_type;
            local v1390 = v1387:get_weapon_index();
            if l_weapon_type_0 == l_v1369_0 then
                if v1390 == 1 then
                    return "Desert Eagle";
                elseif v1390 == 64 then
                    return "R8 Revolver";
                else
                    return "Pistols";
                end;
            elseif l_weapon_type_0 == l_v1370_0 then
                if v1390 == 9 then
                    return "AWP";
                elseif v1390 == 40 then
                    return "SSG-08";
                else
                    return "AutoSnipers";
                end;
            else
                return nil;
            end;
        end;
    end;
    local function v1392(v1391)
        -- upvalues: l_v890_2 (ref), l_v892_2 (ref), l_v982_1 (ref), l_v992_1 (ref)
        if v1391 == l_v890_2 then
            return 4;
        elseif v1391 == l_v892_2 then
            return 1.25;
        elseif v1391 == l_v982_1 then
            return 0.75;
        elseif v1391 == l_v992_1 then
            return 0.75;
        else
            return 1;
        end;
    end;
    local function v1397(v1393, v1394, v1395, v1396)
        -- upvalues: v1392 (ref), l_v890_2 (ref)
        v1394 = v1394 * v1392(v1395);
        if v1393.m_ArmorValue > 0 then
            if v1395 == l_v890_2 then
                if v1393.m_bHasHelmet then
                    v1394 = v1394 * (v1396 * 0.5);
                end;
            else
                v1394 = v1394 * (v1396 * 0.5);
            end;
        end;
        return v1394;
    end;
    local function v1409(v1398, v1399, v1400, v1401, v1402)
        -- upvalues: v1397 (ref)
        local v1403 = v1399 - v1398;
        local l_damage_0 = v1402.damage;
        local l_armor_ratio_0 = v1402.armor_ratio;
        local l_range_0 = v1402.range;
        local l_range_modifier_0 = v1402.range_modifier;
        local v1408 = math.min(l_range_0, v1403:length());
        l_damage_0 = l_damage_0 * math.pow(l_range_modifier_0, v1408 * 0.002);
        return (v1397(v1400, l_damage_0, v1401, l_armor_ratio_0));
    end;
    local function v1414(v1410, v1411)
        local v1412 = v1410:get_origin();
        local v1413 = v1411:get_origin();
        return v1412.z - v1413.z > 53;
    end;
    local function v1418(v1415, v1416)
        local v1417 = v1415:get_origin();
        return v1416:get_origin().z - v1417.z > 53;
    end;
    local function v1424(v1419, v1420, v1421, v1422, v1423)
        -- upvalues: v1409 (ref)
        return v1409(v1419, v1420, v1421, v1422, v1423) >= v1421.m_iHealth;
    end;
    local function v1427()
        -- upvalues: l_l_aimtools_0_0 (ref), l_v1373_0 (ref)
        for v1425 = 1, #l_l_aimtools_0_0 do
            local v1426 = l_v1373_0[l_l_aimtools_0_0[v1425]];
            v1426.head_scale:override();
            v1426.body_scale:override();
            v1426.hit_chance:override();
            v1426.body_aim:override();
            v1426.safe_points:override();
        end;
    end;
    local function v1428()
        return {
            force_safe = false,
            misses = 0,
            prefer_body = false
        };
    end;
    local function v1430(v1429)
        -- upvalues: l_v1372_0 (ref)
        return l_v1372_0[v1429];
    end;
    local function v1433(v1431)
        -- upvalues: v1430 (ref), v1428 (ref), l_v1372_0 (ref)
        local v1432 = v1430(v1431);
        if v1432 == nil then
            v1432 = v1428();
            l_v1372_0[v1431] = v1432;
        end;
        return v1432;
    end;
    local function v1435(v1434)
        -- upvalues: l_v1372_0 (ref)
        l_v1372_0[v1434] = nil;
    end;
    local function v1437()
        -- upvalues: l_v1372_0 (ref), v1435 (ref)
        for v1436 in pairs(l_v1372_0) do
            v1435(v1436);
        end;
    end;
    local function v1448(v1438, v1439, v1440, v1441, v1442, v1443)
        -- upvalues: v1414 (ref), v1418 (ref), v1424 (ref)
        local v1444 = v1438:get_eye_position();
        local v1445 = v1440:get_hitbox_position(5);
        local v1446 = v1439:get_weapon_info();
        local v1447 = v1443.body_aim:get() ~= "Force" and (v1442.conditions:get("Higher than you") and v1414(v1440, v1438) or v1442.conditions:get("Lower than you") and v1418(v1440, v1438) or v1442.conditions:get("Lethal") and v1424(v1444, v1445, v1440, 3, v1446) or v1442.conditions:get("After X misses") and not (v1441.misses <= v1442.max_misses:get()) or v1442.conditions:get("HP lower than X") and v1440.m_iHealth < v1442.lower_hp:get());
        v1443.body_aim:override(v1447 and "Prefer" or nil);
        v1441.prefer_body = v1447;
    end;
    local function v1459(v1449, v1450, v1451, v1452, v1453, v1454)
        -- upvalues: v1414 (ref), v1418 (ref), v1424 (ref)
        local v1455 = v1449:get_eye_position();
        local v1456 = v1451:get_hitbox_position(5);
        local v1457 = v1450:get_weapon_info();
        local v1458 = v1453.conditions:get("Higher than you") and v1414(v1451, v1449) or v1453.conditions:get("Lower than you") and v1418(v1451, v1449) or v1453.conditions:get("Lethal") and v1424(v1455, v1456, v1451, 3, v1457) or v1453.conditions:get("After X misses") and v1452.misses > v1453.max_misses:get() or v1453.conditions:get("HP lower than X") and v1451.m_iHealth < v1453.lower_hp:get();
        v1454.safe_points:override(v1458 and "Force" or nil);
        v1452.force_safe = v1458;
    end;
    local function v1470(v1460, v1461, v1462, v1463, v1464, v1465)
        -- upvalues: v1414 (ref), v1418 (ref), v1424 (ref)
        local v1466 = v1460:get_eye_position();
        local v1467 = v1462:get_hitbox_position(5);
        local v1468 = v1461:get_weapon_info();
        local v1469 = v1464["Higher than you"].enabled:get() and v1414(v1462, v1460) and v1464["Higher than you"].value:get() or v1464["Lower than you"].enabled:get() and v1418(v1462, v1460) and v1464["Lower than you"].value:get() or v1464.Lethal.enabled:get() and v1424(v1466, v1467, v1462, 3, v1468) and v1464.Lethal.value:get() or v1464["After X misses"].enabled:get() and v1463.misses > v1464["After X misses"].max_misses:get() and v1464["After X misses"].value:get() or v1464["HP lower than X"].enabled:get() and v1462.m_iHealth < v1464["HP lower than X"].lower_hp:get() and v1464["HP lower than X"].value:get() or nil;
        v1465.hit_chance:override(v1469);
        v1463.hit_chance = v1469;
    end;
    local function v1481(v1471, v1472, v1473, v1474, v1475, v1476)
        -- upvalues: v1414 (ref), v1418 (ref), v1424 (ref)
        local v1477 = v1471:get_eye_position();
        local v1478 = v1473:get_hitbox_position(5);
        local v1479 = v1472:get_weapon_info();
        local v1480 = v1475["Higher than you"].enabled:get() and v1414(v1473, v1471) and v1475["Higher than you"].value:get() or v1475["Lower than you"].enabled:get() and v1418(v1473, v1471) and v1475["Lower than you"].value:get() or v1475.Lethal.enabled:get() and v1424(v1477, v1478, v1473, 3, v1479) and v1475.Lethal.value:get() or v1475["After X misses"].enabled:get() and v1474.misses > v1475["After X misses"].max_misses:get() and v1475["After X misses"].value:get() or v1475["HP lower than X"].enabled:get() and v1473.m_iHealth < v1475["HP lower than X"].lower_hp:get() and v1475["HP lower than X"].value:get() or nil;
        v1476.head_scale:override(v1480);
        v1476.body_scale:override(v1480);
        v1474.multipoints = v1480;
    end;
    local function v1489(v1482, v1483, v1484)
        -- upvalues: v1385 (ref), l_v888_1 (ref), l_v1373_0 (ref), v1433 (ref), v1448 (ref), v1459 (ref), v1470 (ref), v1481 (ref), v1427 (ref)
        local v1485 = v1385(v1484);
        local v1486 = l_v888_1[v1485];
        local v1487 = l_v1373_0[v1485];
        if v1483 ~= nil and v1486 ~= nil and v1487 ~= nil then
            local v1488 = v1433(v1483:get_index());
            v1448(v1482, v1484, v1483, v1488, v1486.prefer_body, v1487);
            v1459(v1482, v1484, v1483, v1488, v1486.force_safe, v1487);
            v1470(v1482, v1484, v1483, v1488, v1486.hit_chance, v1487);
            v1481(v1482, v1484, v1483, v1488, v1486.multipoints, v1487);
        else
            v1427();
        end;
    end;
    local function v1490()
        -- upvalues: v1427 (ref)
        v1427();
    end;
    local function v1493()
        -- upvalues: v1489 (ref)
        local v1491 = entity.get_local_player();
        if v1491 == nil then
            return;
        else
            local v1492 = v1491:get_player_weapon();
            if v1492 == nil then
                return;
            else
                v1489(v1491, entity.get_threat(), v1492);
                return;
            end;
        end;
    end;
    local function v1505()
        -- upvalues: v1385 (ref), v1430 (ref), l_play_0 (ref)
        local v1494 = entity.get_local_player();
        if v1494 == nil or not v1494:is_alive() then
            return;
        else
            local v1495 = v1494:get_player_weapon();
            if v1495 == nil then
                return;
            else
                local v1496 = entity.get_threat();
                local v1497 = v1385(v1495);
                if v1496 == nil or v1497 == nil then
                    return;
                else
                    local v1498 = v1430(v1496:get_index());
                    if v1498 == nil then
                        return;
                    else
                        local v1499 = {};
                        if v1498.prefer_body then
                            table.insert(v1499, "BODY");
                        end;
                        if v1498.force_safe then
                            table.insert(v1499, "SAFE");
                        end;
                        if v1498.multipoints ~= nil then
                            table.insert(v1499, v1498.multipoints);
                        end;
                        if v1498.hit_chance ~= nil then
                            table.insert(v1499, v1498.hit_chance .. "%");
                        end;
                        if #v1499 == 0 then
                            return;
                        else
                            local v1500 = v1496:get_bbox();
                            if v1500 == nil then
                                return;
                            else
                                local l_pos1_0 = v1500.pos1;
                                local l_pos2_0 = v1500.pos2;
                                local l_alpha_0 = v1500.alpha;
                                if l_pos1_0 == nil or l_pos2_0 == nil or l_alpha_0 == nil then
                                    return;
                                else
                                    local v1504 = vector((v1500.pos1.x + v1500.pos2.x) * 0.5, v1500.pos1.y - 20);
                                    l_play_0.text(1, v1504, color(255, 255, 255, 200 * l_alpha_0), "c", table.concat(v1499, " + "));
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    local function v1510(v1506)
        -- upvalues: v1433 (ref)
        local l_state_1 = v1506.state;
        local l_target_0 = v1506.target;
        if l_state_1 == nil or l_target_0 == nil then
            return;
        else
            local v1509 = v1433(l_target_0:get_index());
            v1509.misses = v1509.misses + 1;
            return;
        end;
    end;
    local function v1514(v1511)
        -- upvalues: v1435 (ref)
        local v1512 = entity.get_local_player();
        local v1513 = entity.get(v1511.userid, true);
        if v1512 ~= entity.get(v1511.attacker, true) or v1512 == v1513 then
            return;
        else
            v1435(v1513:get_index());
            return;
        end;
    end;
    local function v1517(v1515)
        -- upvalues: v1435 (ref)
        local v1516 = entity.get(v1515.userid, true);
        if v1516 == nil then
            return;
        else
            v1435(v1516:get_index());
            return;
        end;
    end;
    local _ = nil;
    local function v1520(v1519)
        -- upvalues: v1505 (ref)
        events.render(v1505, v1519:get());
    end;
    do
        local l_v1520_0 = v1520;
        local function v1524(v1522)
            -- upvalues: v1427 (ref), v1437 (ref), l_v888_1 (ref), l_v1520_0 (ref), v1490 (ref), v1493 (ref), v1510 (ref), v1514 (ref), v1517 (ref)
            local v1523 = v1522:get();
            if not v1523 then
                v1427();
                v1437();
            end;
            if v1523 then
                l_v888_1.flag:set_callback(l_v1520_0, true);
            else
                l_v888_1.flag:unset_callback(l_v1520_0);
            end;
            events.shutdown(v1490, v1523);
            events.createmove(v1493, v1523);
            events.aim_ack(v1510, v1523);
            events.player_death(v1514, v1523);
            events.player_spawn(v1517, v1523);
        end;
        l_v888_1.enabled:set_callback(v1524, true);
    end;
end;
v888 = nil;
v889 = v384.ragebot.ai_peek;
v890 = bit.lshift(1, 0);
v891 = 0;
v892 = 1;
l_match_0 = 2;
l_angles_0 = 3;
v982 = 4;
v992 = 5;
v1368 = 6;
v1369 = 7;
v1370 = 10;
l_aimtools_0 = 0;
v1372 = 1;
v1373 = 2;
local v1525 = 3;
local v1526 = 4;
local v1527 = 5;
local v1528 = 6;
local v1529 = 7;
local v1530 = 8;
local v1531 = 9;
local v1532 = 10;
local v1533 = 11;
local v1534 = 12;
local v1535 = 13;
local v1536 = 14;
local v1537 = 15;
local v1538 = 16;
local v1539 = 17;
local v1540 = 18;
local v1541 = {
    [l_aimtools_0] = v892,
    [v1527] = l_match_0,
    [v1525] = l_angles_0,
    [v1530] = v1368,
    [v1529] = v1369,
    [v1534] = v1368,
    [v1533] = v1369,
    [v1539] = v982,
    [v1537] = v992
};
local v1542 = nil;
local v1543 = 0;
local v1544 = nil;
local v1545 = {};
local function v1547(v1546)
    return {
        selection = {
            head_scale = ui.find("Aimbot", "Ragebot", "Selection", v1546, "Multipoint", "Head Scale"),
            body_scale = ui.find("Aimbot", "Ragebot", "Selection", v1546, "Multipoint", "Body Scale"),
            min_damage = ui.find("Aimbot", "Ragebot", "Selection", v1546, "Min. Damage"),
            hit_chance = ui.find("Aimbot", "Ragebot", "Selection", v1546, "Hit Chance")
        },
        safety = {
            body_aim = ui.find("Aimbot", "Ragebot", "Safety", v1546, "Body Aim"),
            safe_points = ui.find("Aimbot", "Ragebot", "Safety", v1546, "Safe Points"),
            ensure_hitbox_safety = ui.find("Aimbot", "Ragebot", "Safety", v1546, "Ensure Hitbox Safety")
        }
    };
end;
v1545["SSG-08"] = v1547("SSG-08");
v1545.Deagle = v1547("Desert Eagle");
v1545.Pistols = v1547("Pistols");
do
    local l_v889_2, l_v890_3, l_v891_2, l_v892_3, l_l_angles_0_2, l_v1368_0, l_v1369_1, l_l_aimtools_0_1, l_v1525_0, l_v1527_0, l_v1529_0, l_v1530_0, l_v1531_0, l_v1532_0, l_v1537_0, l_v1539_0, l_v1541_0, l_v1542_0, l_v1543_0, l_v1544_0, l_v1545_0, l_v1547_0 = v889, v890, v891, v892, l_angles_0, v1368, v1369, l_aimtools_0, v1525, v1527, v1529, v1530, v1531, v1532, v1537, v1539, v1541, v1542, v1543, v1544, v1545, v1547;
    l_v1547_0 = function()
        -- upvalues: l_v1542_0 (ref), l_v1543_0 (ref), l_v1544_0 (ref)
        l_v1542_0 = nil;
        l_v1543_0 = 0;
        l_v1544_0 = nil;
    end;
    local function v1572()
        -- upvalues: v26 (ref), l_v1545_0 (ref)
        v26.ragebot.main.double_tap[1]:override();
        v26.ragebot.main.peek_assist[4]:override();
        for _, v1571 in pairs(l_v1545_0) do
            v1571.selection.head_scale:override();
            v1571.selection.body_scale:override();
            v1571.selection.hit_chance:override();
            v1571.safety.body_aim:override();
            v1571.safety.safe_points:override();
            v1571.safety.ensure_hitbox_safety:override();
        end;
    end;
    local function v1577()
        -- upvalues: l_v889_2 (ref), v26 (ref), l_v1545_0 (ref)
        local v1573 = l_v889_2.hit_chance:get();
        local v1574 = l_v889_2.unsafety:get();
        v26.ragebot.main.peek_assist[4]:override("On Shot");
        for _, v1576 in pairs(l_v1545_0) do
            v1576.selection.head_scale:override(100);
            v1576.selection.body_scale:override(100);
            if v1573 ~= -1 then
                v1576.selection.hit_chance:override(v1573);
            end;
            if v1574 then
                v1576.safety.body_aim:override("Default");
                v1576.safety.safe_points:override("Default");
                v1576.safety.ensure_hitbox_safety:override({});
            end;
        end;
    end;
    local function v1579(v1578)
        -- upvalues: l_v892_3 (ref), l_l_angles_0_2 (ref), l_v1368_0 (ref), l_v1369_1 (ref)
        if v1578 == l_v892_3 then
            return 4;
        elseif v1578 == l_l_angles_0_2 then
            return 1.25;
        elseif v1578 == l_v1368_0 then
            return 0.75;
        elseif v1578 == l_v1369_1 then
            return 0.75;
        else
            return 1;
        end;
    end;
    local function v1584(v1580, v1581, v1582, v1583)
        -- upvalues: v1579 (ref), l_v892_3 (ref)
        v1581 = v1581 * v1579(v1582);
        if v1580.m_ArmorValue > 0 then
            if v1582 == l_v892_3 then
                if v1580.m_bHasHelmet then
                    v1581 = v1581 * (v1583 * 0.5);
                end;
            else
                v1581 = v1581 * (v1583 * 0.5);
            end;
        end;
        return v1581;
    end;
    local function v1596(v1585, v1586, v1587, v1588, v1589)
        -- upvalues: v1584 (ref)
        local v1590 = v1586 - v1585;
        local l_damage_1 = v1589.damage;
        local l_armor_ratio_1 = v1589.armor_ratio;
        local l_range_1 = v1589.range;
        local l_range_modifier_1 = v1589.range_modifier;
        local v1595 = math.min(l_range_1, v1590:length());
        l_damage_1 = l_damage_1 * math.pow(l_range_modifier_1, v1595 * 0.002);
        return (v1584(v1587, l_damage_1, v1588, l_armor_ratio_1));
    end;
    local function v1597()
        -- upvalues: l_v889_2 (ref)
        return l_v889_2.simulation:get() * 0.01;
    end;
    local function v1598()
        -- upvalues: l_v889_2 (ref)
        return l_v889_2.rate_limit:get() * 0.01;
    end;
    local function v1599()
        -- upvalues: v26 (ref)
        return v26.ragebot.selection.min_damage:get();
    end;
    local function v1600()
        -- upvalues: l_v889_2 (ref)
        return l_v889_2.dev_mode:get() and l_v889_2.range:get() or 20;
    end;
    local function v1601()
        -- upvalues: l_v889_2 (ref)
        return l_v889_2.dev_mode:get() and l_v889_2.retreat:get() or 25;
    end;
    local function v1603()
        -- upvalues: l_v889_2 (ref), l_l_aimtools_0_1 (ref), l_v1527_0 (ref), l_v1525_0 (ref), l_v1539_0 (ref), l_v1537_0 (ref), l_v1530_0 (ref), l_v1529_0 (ref), l_v1532_0 (ref), l_v1531_0 (ref)
        local v1602 = {};
        if l_v889_2.hitboxes:get("Head") then
            table.insert(v1602, l_l_aimtools_0_1);
        end;
        if l_v889_2.hitboxes:get("Chest") then
            table.insert(v1602, l_v1527_0);
        end;
        if l_v889_2.hitboxes:get("Stomach") then
            table.insert(v1602, l_v1525_0);
        end;
        if l_v889_2.hitboxes:get("Arms") then
            table.insert(v1602, l_v1539_0);
            table.insert(v1602, l_v1537_0);
        end;
        if l_v889_2.hitboxes:get("Legs") then
            table.insert(v1602, l_v1530_0);
            table.insert(v1602, l_v1529_0);
            table.insert(v1602, l_v1532_0);
            table.insert(v1602, l_v1531_0);
        end;
        return v1602;
    end;
    local function v1605(v1604)
        -- upvalues: l_v1541_0 (ref), l_v891_2 (ref)
        return l_v1541_0[v1604] or l_v891_2;
    end;
    local function v1607(v1606)
        return v1606[0];
    end;
    local function v1612(v1608, v1609)
        local v1610 = v1608:get_weapon_index();
        local l_weapon_type_1 = v1609.weapon_type;
        if v1610 == 1 then
            return "Deagle";
        elseif v1610 == 64 then
            return "Revolver";
        elseif v1610 == 40 then
            return "SSG-08";
        elseif l_weapon_type_1 == 1 then
            return "Pistols";
        else
            return nil;
        end;
    end;
    local function v1629(v1613, v1614, v1615, v1616, v1617)
        -- upvalues: v1605 (ref), v1596 (ref)
        local v1618 = {};
        local v1619 = v1614:get_eye_position();
        local v1620 = v1615:get_weapon_info();
        local l_m_iHealth_0 = v1616.m_iHealth;
        for v1622 = 1, #v1613 do
            local v1623 = v1613[v1622];
            local v1624 = v1605(v1623);
            local v1625 = v1616:get_hitbox_position(v1623);
            local v1626 = v1596(v1619, v1625, v1616, v1624, v1620);
            local v1627 = v1626 < v1617;
            local v1628 = v1626 < l_m_iHealth_0;
            if not v1627 or not v1628 then
                table.insert(v1618, {
                    index = v1622,
                    pos = v1625
                });
            end;
        end;
        return v1618;
    end;
    local function v1633(v1630)
        -- upvalues: v1607 (ref)
        if v1630 == nil then
            return false;
        else
            local l_status_12, l_result_12 = pcall(v1607, v1630);
            if not l_status_12 or l_result_12 == nil then
                return false;
            else
                return true;
            end;
        end;
    end;
    local function v1635(v1634)
        -- upvalues: v1633 (ref)
        return v1633(v1634.target);
    end;
    local function v1637(v1636)
        return not v1636.in_forward and not v1636.in_back and not v1636.in_moveleft and not v1636.in_moveright;
    end;
    local function v1639(v1638)
        -- upvalues: l_v889_2 (ref)
        return l_v889_2.weapons:get(v1638);
    end;
    local function v1643(v1640, v1641, v1642)
        if v1640 == nil or v1641 == nil then
            return false;
        elseif v1642.max_clip1 == 0 or v1641.m_iClip1 == 0 then
            return false;
        elseif globals.curtime < v1640.m_flNextAttack then
            return false;
        elseif globals.curtime < v1641.m_flNextPrimaryAttack then
            return false;
        else
            return true;
        end;
    end;
    local function v1644()
        return true;
    end;
    local function v1647(v1645, v1646)
        return {
            ctx = v1645,
            target = v1646,
            simtime = 0,
            retreat = -1,
            teleport = 0
        };
    end;
    local function v1649(v1648)
        return v1648:simulate_movement(nil, vector(), 1);
    end;
    local function v1656(v1650, v1651, v1652)
        local v1654, v1655 = utils.trace_bullet(v1650, v1651, v1652, function(v1653)
            -- upvalues: v1650 (ref)
            return v1653 ~= v1650 and v1653:is_enemy();
        end);
        return v1654, v1655;
    end;
    local function v1669(v1657, v1658, v1659, v1660, v1661)
        -- upvalues: v1656 (ref)
        local l_m_iHealth_1 = v1658.m_iHealth;
        for v1663 = 1, #v1660 do
            local v1664 = v1660[v1663];
            local v1665, _ = v1656(v1657, v1659, v1664.pos);
            local v1667 = v1661 <= v1665;
            local v1668 = l_m_iHealth_1 <= v1665;
            if v1667 or v1668 then
                return true;
            end;
        end;
        return false;
    end;
    local function v1676(v1670, v1671, v1672, v1673, v1674)
        -- upvalues: v1669 (ref)
        local v1675 = v1670.origin + vector(0, 0, v1670.view_offset);
        return v1670, v1669(v1671, v1672, v1675, v1673, v1674);
    end;
    local function v1686(v1677, v1678, v1679, v1680, v1681, v1682, v1683)
        -- upvalues: l_v890_3 (ref), v1676 (ref)
        v1677.view_angles.y = v1681;
        v1680:think(1);
        if bit.band(v1680.flags, l_v890_3) == 0 then
            return nil, false;
        else
            local _, v1685 = v1676(v1680, v1678, v1679, v1682, v1683);
            if v1685 then
                v1680:think(1);
            end;
            return v1680, v1685;
        end;
    end;
    local function v1721(v1687, v1688, v1689)
        -- upvalues: v1644 (ref), v1598 (ref), v1599 (ref), v1603 (ref), l_v1542_0 (ref), v1635 (ref), v1629 (ref), v1676 (ref), l_v1543_0 (ref), v1637 (ref), l_v890_3 (ref), v1669 (ref), v1649 (ref), v1600 (ref), v1686 (ref), v1647 (ref)
        if not v1644() then
            return false;
        else
            local l_frametime_0 = globals.frametime;
            local v1691 = v1598();
            local v1692 = v1599();
            local v1693 = v1603();
            if l_v1542_0 ~= nil and v1635(l_v1542_0) then
                local l_ctx_0 = l_v1542_0.ctx;
                local l_target_1 = l_v1542_0.target;
                local l_m_iHealth_2 = l_target_1.m_iHealth;
                if v1692 >= 100 then
                    v1692 = v1692 + l_m_iHealth_2 - 100;
                end;
                local v1697 = v1629(v1693, v1688, v1689, l_target_1, v1692);
                local _, v1699 = v1676(l_ctx_0, v1688, l_target_1, v1697, v1692);
                if v1699 then
                    l_v1542_0.simtime = 0;
                end;
                l_v1542_0.simtime = l_v1542_0.simtime + l_frametime_0;
                return true;
            else
                if v1691 > 0 then
                    if l_v1543_0 > 0 then
                        l_v1543_0 = l_v1543_0 - l_frametime_0;
                        return false;
                    else
                        l_v1543_0 = v1691;
                    end;
                end;
                if not v1637(v1687) then
                    return false;
                else
                    local l_m_fFlags_0 = v1688.m_fFlags;
                    if bit.band(l_m_fFlags_0, l_v890_3) == 0 then
                        return false;
                    elseif v1688.m_vecVelocity:length2dsqr() > 6400 then
                        return false;
                    else
                        local v1701 = entity.get_threat();
                        if v1701 == nil or v1701:is_dormant() then
                            return false;
                        else
                            local l_m_iHealth_3 = v1701.m_iHealth;
                            if v1692 >= 100 then
                                v1692 = v1692 + l_m_iHealth_3 - 100;
                            end;
                            local v1703 = v1629(v1693, v1688, v1689, v1701, v1692);
                            if v1669(v1688, v1701, v1688:get_eye_position(), v1703, v1692) then
                                return false;
                            else
                                local v1704 = nil;
                                local v1705 = nil;
                                local v1706 = v1688:get_origin();
                                local v1707 = (v1701:get_origin() - v1706):angles().y + 180;
                                v1704 = v1707 - 90;
                                v1705 = v1707 + 90;
                                v1706 = v1687.view_angles:clone();
                                local l_forwardmove_0 = v1687.forwardmove;
                                local l_sidemove_0 = v1687.sidemove;
                                local l_in_duck_0 = v1687.in_duck;
                                v1707 = v1687.in_jump;
                                local l_in_speed_0 = v1687.in_speed;
                                v1687.forwardmove = 450;
                                v1687.sidemove = 0;
                                v1687.in_duck = false;
                                v1687.in_jump = false;
                                v1687.in_speed = false;
                                local v1712 = v1649(v1688);
                                local v1713 = v1649(v1688);
                                local v1714 = 0;
                                local v1715 = 0;
                                for v1716 = 1, v1600() do
                                    if v1714 ~= -1 then
                                        v1714 = v1716;
                                        local v1717, v1718 = v1686(v1687, v1688, v1701, v1712, v1704, v1703, v1692);
                                        if v1717 == nil then
                                            v1714 = -1;
                                        end;
                                        if v1718 then
                                            l_v1542_0 = v1647(v1717, v1701);
                                            break;
                                        end;
                                    end;
                                    if v1715 ~= -1 then
                                        v1715 = v1716;
                                        local v1719, v1720 = v1686(v1687, v1688, v1701, v1713, v1705, v1703, v1692);
                                        if v1719 == nil then
                                            v1715 = -1;
                                        end;
                                        if v1720 then
                                            l_v1542_0 = v1647(v1719, v1701);
                                            break;
                                        end;
                                    end;
                                end;
                                v1687.view_angles.y = v1706.y;
                                v1687.forwardmove = l_forwardmove_0;
                                v1687.sidemove = l_sidemove_0;
                                v1687.in_duck = l_in_duck_0;
                                v1687.in_jump = v1707;
                                v1687.in_speed = l_in_speed_0;
                                return l_v1542_0 ~= nil;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    local function v1729(v1722, v1723, v1724)
        local v1725 = v1724 - v1723:get_origin();
        local v1726 = v1725:length2dsqr();
        if v1726 < 25 then
            local l_m_vecVelocity_1 = v1723.m_vecVelocity;
            local v1728 = l_m_vecVelocity_1:length();
            v1722.move_yaw = l_m_vecVelocity_1:angles().y;
            v1722.forwardmove = -v1728;
            v1722.sidemove = 0;
            return true, v1726;
        else
            v1722.move_yaw = v1725:angles().y;
            v1722.forwardmove = 450;
            v1722.sidemove = 0;
            return false, v1726;
        end;
    end;
    local function v1731(v1730)
        v1730.in_duck = false;
        v1730.in_jump = false;
        v1730.in_speed = false;
        v1730.in_forward = true;
        v1730.in_back = false;
        v1730.in_moveleft = false;
        v1730.in_moveright = false;
    end;
    local function v1751(v1732, v1733, v1734, v1735)
        -- upvalues: v1643 (ref), v1721 (ref), l_v1542_0 (ref), v1597 (ref), l_v1544_0 (ref), v1601 (ref), v1729 (ref), l_v889_2 (ref), v1731 (ref), v1577 (ref), v27 (ref), l_v1547_0 (ref), v26 (ref), v1572 (ref)
        local v1736 = v1643(v1733, v1734, v1735);
        local v1737 = v1721(v1732, v1733, v1734);
        if l_v1542_0 == nil then
            return;
        else
            if v1597() < l_v1542_0.simtime then
                v1737 = false;
            end;
            if v1735.weapon_type == 5 and not v1733.m_bIsScoped then
                v1737 = false;
            end;
            if l_v1542_0.retreat <= 0 and v1737 then
                local l_ctx_1 = l_v1542_0.ctx;
                if l_v1544_0 == nil then
                    local v1739 = v1733:get_origin();
                    local v1740 = l_ctx_1.origin - v1739;
                    v1740:normalize();
                    local v1741 = l_ctx_1.origin - v1740 * v1601();
                    l_v1544_0 = utils.trace_hull(v1739, v1741, l_ctx_1.obb_mins, l_ctx_1.obb_maxs, v1733, 33636363, 0).end_pos;
                end;
                local v1742, _ = v1729(v1732, v1733, l_ctx_1.origin);
                local v1744 = l_v889_2.color:get();
                v1731(v1732);
                v1577();
                l_v1542_0.retreat = 0;
                if v1742 then
                    l_v1542_0.retreat = 1;
                end;
                v27.box_new(l_ctx_1.origin, l_ctx_1.obb_mins, l_ctx_1.obb_maxs, vector(), color(0, 0, 0, 0), v1744, globals.tickinterval * 2);
                return;
            elseif not v1736 then
                l_v1547_0();
                return;
            elseif l_v1542_0.ctx == nil or l_v1542_0.retreat == -1 then
                return;
            else
                l_v1542_0.retreat = l_v1542_0.retreat + 1;
                local v1745, _ = v1729(v1732, v1733, l_v1544_0);
                local v1747 = v1733:get_origin();
                local l_m_vecVelocity_2 = v1733.m_vecVelocity;
                local v1749 = (l_v1544_0 - v1747):angles() - l_m_vecVelocity_2:angles();
                local v1750 = l_m_vecVelocity_2:length2dsqr();
                v1731(v1732);
                v1577();
                if v1750 > 1600 and math.abs(v1749.y) < 20 then
                    rage.exploit:force_teleport();
                    v26.ragebot.main.double_tap[1]:override(false);
                end;
                if v1736 and v1745 then
                    l_v1547_0();
                    v1572();
                end;
                return;
            end;
        end;
    end;
    local function v1757(v1752)
        -- upvalues: v26 (ref), l_v1547_0 (ref), v1572 (ref), v1612 (ref), v1639 (ref), v1751 (ref)
        if not v26.ragebot.main.peek_assist[1]:get() then
            l_v1547_0();
            v1572();
            return;
        else
            local v1753 = entity.get_local_player();
            if v1753 == nil then
                return;
            else
                local v1754 = v1753:get_player_weapon();
                if v1754 == nil then
                    return;
                else
                    local v1755 = v1754:get_weapon_info();
                    if v1755 == nil then
                        return;
                    else
                        local v1756 = v1612(v1754, v1755);
                        if not v1639(v1756) then
                            l_v1547_0();
                            v1572();
                            return;
                        else
                            v1751(v1752, v1753, v1754, v1755);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
    local function v1758()
        -- upvalues: l_v1542_0 (ref), l_v1547_0 (ref)
        if l_v1542_0 == nil then
            return nil;
        else
            l_v1547_0();
            return;
        end;
    end;
    local _ = nil;
    local function v1762(v1760)
        -- upvalues: l_v1547_0 (ref), v1572 (ref), v1758 (ref), v1757 (ref)
        local v1761 = v1760:get();
        if not v1761 then
            l_v1547_0();
            v1572();
        end;
        events.aim_fire(v1758, v1761);
        events.createmove(v1757, v1761);
    end;
    l_v889_2.enabled:set_callback(v1762, true);
end;
v889 = nil;
v890 = v384.ragebot.logs;
v891 = string.upper(v13.name:sub(1, 1));
v892 = string.lower(v13.name);
l_match_0 = 7;
l_angles_0 = 5;
v982 = l_match_0;
v992 = {};
v1368 = {
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
v1369 = {
    decoy = "decoyed",
    knife = "knifed",
    c4 = "bombed",
    smokegrenade = "harmed",
    incgrenade = "harmed",
    hegrenade = "naded",
    flashbang = "harmed",
    inferno = "burned",
    molotov = "harmed"
};
do
    local l_v890_4, l_v891_3, l_v892_4, l_l_match_0_3, l_l_angles_0_3, l_v982_2, l_v992_2, l_v1368_1, l_v1369_2, l_v1370_1, l_l_aimtools_0_2, l_v1372_1, l_v1373_1, l_v1525_1, l_v1526_0, l_v1527_1, l_v1528_0, l_v1529_1, l_v1530_1, l_v1531_1, l_v1532_1 = v890, v891, v892, l_match_0, l_angles_0, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529, v1530, v1531, v1532;
    l_v1370_1 = function(v1784)
        -- upvalues: l_v890_4 (ref)
        if not l_v890_4.output:get("Events") then
            return;
        else
            print_dev(v1784);
            return;
        end;
    end;
    l_l_aimtools_0_2 = function(v1785, v1786)
        -- upvalues: l_v890_4 (ref), l_v992_2 (ref)
        if not l_v890_4.output:get("Render") then
            return;
        else
            local v1787 = l_v890_4.duration:get();
            local v1788 = #l_v992_2 + 1;
            l_v992_2[v1788] = {
                alpha = 0,
                text = v1786,
                color = v1785,
                time = v1787
            };
            return v1788;
        end;
    end;
    l_v1372_1 = function(v1789)
        -- upvalues: l_v890_4 (ref)
        if not l_v890_4.output:get("Console") then
            return;
        else
            print_raw(v1789);
            return;
        end;
    end;
    l_v1373_1 = function(v1790, v1791, v1792)
        local v1793 = string.gsub(v1790, "${(.-)}", string.format("\a%s%%1\a%s", v1791, v1792));
        if v1793:sub(1, 1) ~= "\a" then
            v1793 = "\a" .. v1792 .. v1793;
        end;
        return v1793;
    end;
    l_v1525_1 = function()
        -- upvalues: l_v992_2 (ref)
        for v1794 = 1, #l_v992_2 do
            l_v992_2[v1794] = nil;
        end;
    end;
    l_v1526_0 = function(v1795)
        -- upvalues: l_v891_3 (ref), l_v892_4 (ref)
        if v1795 == "Off" then
            return nil;
        elseif v1795 == "Icon" then
            return l_v891_3;
        elseif v1795 == "Text" then
            return l_v892_4;
        else
            return v1795;
        end;
    end;
    l_v1527_1 = function(v1796, v1797, v1798, v1799, v1800)
        -- upvalues: l_play_0 (ref), v12 (ref)
        local v1801 = 4;
        if v1799 > 0 then
            local v1802 = math.map(v1799, 0, 1.5, 0, 115, true);
            local v1803 = v1798:clone();
            v1803.a = v1802 * v1800;
            l_play_0.shadow(v1796, v1797, v1803, v12(8 * v1799), 0, v1801);
        end;
        local v1804 = v1798:clone();
        v1804.a = v1804.a * v1800;
        l_play_0.rect(v1796, v1797, v1804, v1801);
    end;
    l_v1528_0 = function()
        -- upvalues: l_v890_4 (ref), l_v992_2 (ref), l_play_0 (ref), l_v1526_0 (ref), v32 (ref), l_l_match_0_3 (ref), l_l_angles_0_3 (ref), l_v982_2 (ref), l_v1527_1 (ref), v12 (ref)
        local v1805 = l_v890_4.background_color:get();
        local l_frametime_1 = globals.frametime;
        local v1807 = #l_v992_2;
        local v1808 = l_play_0.screen_size() / 2;
        v1808.y = v1808.y + l_v890_4.offset:get() * 5;
        local v1809 = l_v890_4.logo:get();
        local v1810 = v1809 == "!";
        local v1811 = l_v1526_0(v1809);
        local v1812 = 4;
        local v1813 = "";
        local v1814 = l_play_0.measure_text(v1812, v1813, v1811);
        for v1815 = v1807, 1, -1 do
            local v1816 = l_v992_2[v1815];
            local v1817 = v1816.time > 0 and v1807 - v1815 < 6;
            v1816.alpha = v32.interp(v1816.alpha, v1817, 0.075);
            if not v1817 then
                if v1816.alpha <= 0 then
                    table.remove(l_v992_2, v1815);
                end;
            else
                v1816.time = v1816.time - l_frametime_1;
            end;
        end;
        local v1818 = 1;
        local v1819 = "";
        local v1820 = l_v890_4.glow:get() * 0.01;
        for v1821 = 1, #l_v992_2 do
            local v1822 = l_v992_2[v1821];
            local l_color_0 = v1822.color;
            local l_text_0 = v1822.text;
            local l_alpha_1 = v1822.alpha;
            if not v1810 then
                l_text_0 = l_text_0 .. " !";
            end;
            local v1826 = l_play_0.measure_text(v1818, v1819, l_text_0);
            local v1827 = v1826 + vector(l_l_match_0_3, l_l_angles_0_3) * 2;
            if v1811 ~= nil then
                v1827.x = v1827.x + v1814.x + l_v982_2;
            end;
            local v1828 = v1808 - v1827 / 2;
            local v1829 = v1828 + vector(l_l_match_0_3, l_l_angles_0_3);
            local v1830 = vector(v1829.x, v1828.y + (v1827.y - v1814.y) / 2);
            l_v1527_1(v1828, v1828 + v1827, v1805, v1820, l_alpha_1);
            if v1811 ~= nil then
                local v1831 = l_color_0:clone();
                v1831.a = v1831.a * l_alpha_1;
                l_play_0.text(v1812, v1830, v1831, v1813, v1811);
                v1829.x = v1829.x + v1814.x + l_v982_2;
            end;
            v1829.y = v1828.y + (v1827.y - v1826.y) / 2;
            local v1832 = color(255, 255, 255, 255 * l_alpha_1);
            l_play_0.text(v1818, v1829, v1832, v1819, l_text_0);
            v1808.y = v1808.y - v12((v1827.y + 5) * l_alpha_1);
        end;
    end;
    l_v1529_1 = function(v1833)
        -- upvalues: l_v890_4 (ref), l_v1368_1 (ref), l_v1373_1 (ref), l_v1370_1 (ref), l_v1372_1 (ref), l_l_aimtools_0_2 (ref)
        local l_target_2 = v1833.target;
        if l_target_2 == nil then
            return;
        else
            local v1835 = l_v890_4.hit_color:get();
            local v1836 = l_target_2:get_name();
            local l_m_iHealth_4 = l_target_2.m_iHealth;
            local l_backtrack_0 = v1833.backtrack;
            local l_hitchance_0 = v1833.hitchance;
            local v1840 = v1833.damage or 0;
            local v1841 = v1833.wanted_damage or 0;
            local v1842 = l_v1368_1[v1833.hitgroup] or "?";
            local v1843 = l_v1368_1[v1833.wanted_hitgroup] or "?";
            local v1844 = v1841 - v1840 > 10;
            local v1845 = v1843 ~= v1842;
            local v1846 = nil;
            v1846 = string.format("hit ${%s}'s ${%s} for ${%d} dmg", v1836, v1842, v1840);
            local v1847 = nil;
            local v1848 = {};
            table.insert(v1848, string.format("hit: ${%s}", v1836));
            if v1845 then
                table.insert(v1848, string.format("hb: ${%s}/%s", v1842, v1843));
            else
                table.insert(v1848, string.format("hb: ${%s}", v1842));
            end;
            if v1844 then
                table.insert(v1848, string.format("dmg: ${%d}/%d", v1840, v1841));
            else
                table.insert(v1848, string.format("dmg: ${%d}", v1840));
            end;
            table.insert(v1848, string.format("bt: ${%d}", l_backtrack_0));
            table.insert(v1848, string.format("hc: ${%d%%}", l_hitchance_0));
            if l_m_iHealth_4 <= 0 then
                table.insert(v1848, "rph: ${0} (dead)");
            else
                table.insert(v1848, string.format("rph: ${%d}", l_m_iHealth_4));
            end;
            v1847 = table.concat(v1848, "  ");
            v1846 = l_v1373_1(v1846, v1835:to_hex(), "c8c8c8ff");
            v1847 = l_v1373_1(v1847, v1835:to_hex(), "c8c8c8ff");
            l_v1370_1(v1847);
            l_v1372_1(v1847);
            l_l_aimtools_0_2(v1835, v1846);
            return;
        end;
    end;
    l_v1530_1 = function(v1849)
        -- upvalues: l_v890_4 (ref), l_v1368_1 (ref), l_v1373_1 (ref), l_v1370_1 (ref), l_v1372_1 (ref), l_l_aimtools_0_2 (ref)
        local l_target_3 = v1849.target;
        if l_target_3 == nil then
            return;
        else
            local v1851 = l_v890_4.miss_color:get();
            local v1852 = l_target_3:get_name();
            local l_state_2 = v1849.state;
            local l_hitchance_1 = v1849.hitchance;
            local l_backtrack_1 = v1849.backtrack;
            local v1856 = v1849.wanted_damage or 0;
            local v1857 = l_v1368_1[v1849.wanted_hitgroup] or "?";
            local v1858 = nil;
            v1858 = string.format("missed ${%s}'s ${%s} due to ${%s}", v1852, v1857, l_state_2);
            local v1859 = nil;
            local v1860 = {};
            table.insert(v1860, string.format("missed: ${%s}", v1852));
            table.insert(v1860, string.format("hb: ${%s}", v1857));
            table.insert(v1860, string.format("due: ${%s}", l_state_2));
            table.insert(v1860, string.format("dmg: ${%d}", v1856));
            table.insert(v1860, string.format("bt: ${%d}", l_backtrack_1));
            table.insert(v1860, string.format("hc: ${%d%%}", l_hitchance_1));
            v1859 = table.concat(v1860, "  ");
            v1858 = l_v1373_1(v1858, v1851:to_hex(), "c8c8c8ff");
            v1859 = l_v1373_1(v1859, v1851:to_hex(), "c8c8c8ff");
            l_v1370_1(v1859);
            l_v1372_1(v1859);
            l_l_aimtools_0_2(v1851, v1858);
            return;
        end;
    end;
    l_v1531_1 = function(v1861)
        -- upvalues: l_v1529_1 (ref), l_v1530_1 (ref)
        if v1861.state == nil then
            l_v1529_1(v1861);
        else
            l_v1530_1(v1861);
        end;
    end;
    l_v1532_1 = function(v1862)
        -- upvalues: l_v1369_2 (ref), l_v890_4 (ref), l_v1373_1 (ref), l_v1370_1 (ref), l_v1372_1 (ref), l_l_aimtools_0_2 (ref)
        local v1863 = entity.get_local_player();
        local v1864 = entity.get(v1862.userid, true);
        if entity.get(v1862.attacker, true) ~= v1863 or v1864 == v1863 then
            return;
        else
            local l_weapon_0 = v1862.weapon;
            local v1866 = l_v1369_2[l_weapon_0];
            if v1866 == nil then
                return;
            else
                local v1867 = l_v890_4.hit_color:get();
                local v1868 = v1864:get_name();
                local l_m_iHealth_5 = v1864.m_iHealth;
                local l_dmg_health_0 = v1862.dmg_health;
                local v1871 = nil;
                v1871 = string.format("%s ${%s} for ${%d} dmg", v1866, v1868, l_dmg_health_0);
                local v1872 = nil;
                local v1873 = {};
                table.insert(v1873, string.format("harmed: ${%s}", v1868));
                table.insert(v1873, string.format("dmg: ${%d}", l_dmg_health_0));
                if l_m_iHealth_5 <= 0 then
                    table.insert(v1873, "rph: ${0} (dead)");
                else
                    table.insert(v1873, string.format("rph: ${%d}", l_m_iHealth_5));
                end;
                table.insert(v1873, string.format("wep: ${%s}", l_weapon_0));
                v1872 = table.concat(v1873, "  ");
                v1871 = l_v1373_1(v1871, v1867:to_hex(), "c8c8c8ff");
                v1872 = l_v1373_1(v1872, v1867:to_hex(), "c8c8c8ff");
                l_v1370_1(v1872);
                l_v1372_1(v1872);
                l_l_aimtools_0_2(v1867, v1871);
                return;
            end;
        end;
    end;
    v1533 = nil;
    v1534 = function(v1874)
        -- upvalues: l_v1525_1 (ref), l_v1528_0 (ref)
        local v1875 = v1874:get("Render");
        if not v1875 then
            l_v1525_1();
        end;
        events.render(l_v1528_0, v1875);
    end;
    do
        local l_v1534_0 = v1534;
        v1535 = function(v1877)
            -- upvalues: l_v1525_1 (ref), l_v1528_0 (ref), l_v890_4 (ref), l_v1534_0 (ref), l_v1531_1 (ref), l_v1532_1 (ref)
            local v1878 = v1877:get();
            if not v1878 then
                l_v1525_1();
            end;
            if not v1878 then
                events.render(l_v1528_0, false);
            end;
            if v1878 then
                l_v890_4.output:set_callback(l_v1534_0, true);
            else
                l_v890_4.output:unset_callback(l_v1534_0);
            end;
            events.aim_ack(l_v1531_1, v1878);
            events.player_hurt(l_v1532_1, v1878);
        end;
        l_v890_4.enabled:set_callback(v1535, true);
    end;
end;
v890 = nil;
v891 = v384.ragebot.dormant_aimbot;
v892 = true;
l_match_0 = 5;
l_angles_0 = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot");
v982 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
v992 = nil;
v1368 = nil;
v1369 = nil;
v1370 = nil;
l_aimtools_0 = nil;
v1372 = false;
v1373 = false;
v1525 = 1;
v1526 = 0;
v1527 = {
    [0] = "Generic",
    [1] = "Head",
    [2] = "Chest",
    [3] = "Stomach",
    [4] = "Chest",
    [5] = "Chest",
    [6] = "Legs",
    [7] = "Legs",
    [8] = "Head",
    [9] = nil,
    [10] = "Gear"
};
v1528 = {
    [1] = {
        hitbox = "Stomach",
        scale = 5,
        vec = vector(0, 0, 40)
    },
    [2] = {
        hitbox = "Chest",
        scale = 6,
        vec = vector(0, 0, 50)
    },
    [3] = {
        hitbox = "Head",
        scale = 3,
        vec = vector(0, 0, 58)
    },
    [4] = {
        hitbox = "Legs",
        scale = 4,
        vec = vector(0, 0, 20)
    }
};
v1529 = function(v1879, v1880)
    for v1881 = 1, #v1879 do
        if v1879[v1881] == v1880 then
            return true;
        end;
    end;
    return false;
end;
v1530 = function(v1882)
    return v1882 >= 1 and v1882 <= 6;
end;
v1531 = function()
    local v1883 = {};
    local v1884 = entity.get_player_resource();
    for v1885 = 1, globals.max_players do
        local v1886 = entity.get(v1885);
        if v1886 ~= nil and v1884.m_bConnected[v1885] and v1886:is_enemy() and v1886:is_dormant() then
            table.insert(v1883, v1886);
        end;
    end;
    return v1883;
end;
v1532 = function(v1887, v1888, v1889)
    local v1890 = v1887:to(v1888):angles();
    local v1891 = math.rad(v1890.y + 90);
    local v1892 = vector(math.cos(v1891), math.sin(v1891), 0) * v1889;
    return {
        [1] = {
            text = "Middle",
            vec = v1888
        },
        [2] = {
            text = "Left",
            vec = v1888 + v1892
        },
        [3] = {
            text = "Right",
            vec = v1888 - v1892
        }
    };
end;
v1533 = function(v1893, v1894, v1895, v1896)
    local v1897, v1898 = utils.trace_bullet(v1893, v1894, v1895, v1896);
    if v1898 ~= nil then
        local l_entity_1 = v1898.entity;
        if l_entity_1 == nil then
            return 0, v1898;
        elseif l_entity_1:is_player() and not l_entity_1:is_enemy() then
            return 0, v1898;
        end;
    end;
    return v1897, v1898;
end;
do
    local l_v891_4, l_v892_5, l_l_match_0_4, l_l_angles_0_4, l_v982_3, l_v992_3, l_v1368_2, l_v1369_3, l_v1370_2, l_l_aimtools_0_3, l_v1372_2, l_v1373_2, l_v1525_2, l_v1526_1, l_v1527_2, l_v1528_1, l_v1529_2, l_v1530_2, l_v1531_2, l_v1532_2, l_v1533_0, l_v1534_1, l_v1535_0, l_v1536_0, l_v1537_1 = v891, v892, l_match_0, l_angles_0, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529, v1530, v1531, v1532, v1533, v1534, v1535, v1536, v1537;
    l_v1534_1 = function(v1925)
        -- upvalues: l_l_angles_0_4 (ref), l_v1526_1 (ref), l_v1530_2 (ref), l_v1531_2 (ref), l_v891_4 (ref), l_v1525_2 (ref), l_v982_3 (ref), l_v1528_1 (ref), l_v1529_2 (ref), l_v1532_2 (ref), l_v1533_0 (ref), l_v992_3 (ref), l_v1369_3 (ref), l_v1370_2 (ref), l_v1368_2 (ref), l_l_aimtools_0_3 (ref), l_v892_5 (ref), l_l_match_0_4 (ref), l_v1373_2 (ref)
        l_l_angles_0_4:override(false);
        local v1926 = entity.get_local_player();
        if v1926 == nil then
            return;
        else
            local v1927 = v1926:get_player_weapon();
            if v1927 == nil then
                return;
            else
                local v1928 = v1927:get_weapon_info();
                if v1928 == nil then
                    return;
                else
                    local v1929 = v1927:get_inaccuracy();
                    if v1929 == nil then
                        return;
                    else
                        local l_tickcount_1 = globals.tickcount;
                        local v1931 = v1926:get_eye_position();
                        local l_current_0 = v1926:get_simulation_time().current;
                        local v1933 = bit.band(v1926.m_fFlags, bit.lshift(1, 0)) ~= 0;
                        if l_tickcount_1 < l_v1526_1 then
                            return;
                        elseif v1925.in_jump and not v1933 then
                            return;
                        else
                            local l_weapon_type_2 = v1928.weapon_type;
                            if not l_v1530_2(l_weapon_type_2) or v1927.m_iClip1 <= 0 then
                                return false;
                            else
                                local v1935 = l_v1531_2();
                                local v1936 = l_v891_4.hitboxes:get();
                                if l_tickcount_1 % #v1935 ~= 0 then
                                    l_v1525_2 = l_v1525_2 + 1;
                                else
                                    l_v1525_2 = 1;
                                end;
                                local v1937 = v1935[l_v1525_2];
                                if v1937 == nil then
                                    return;
                                else
                                    local v1938 = v1937:get_bbox();
                                    local v1939 = v1937:get_origin();
                                    local l_m_flDuckAmount_0 = v1937.m_flDuckAmount;
                                    local v1941 = l_v891_4.alpha_modifier:get();
                                    local v1942 = l_v891_4.minimum_damage:get();
                                    if v1942 == 0 then
                                        v1942 = l_v982_3:get();
                                    end;
                                    if v1942 >= 100 then
                                        v1942 = v1942 - 100 + v1937.m_iHealth;
                                    end;
                                    local v1943 = {};
                                    for v1944 = 1, #l_v1528_1 do
                                        local v1945 = l_v1528_1[v1944];
                                        local l_vec_0 = v1945.vec;
                                        local l_scale_0 = v1945.scale;
                                        local l_hitbox_0 = v1945.hitbox;
                                        if l_hitbox_0 == "Head" then
                                            l_vec_0 = l_vec_0 - vector(0, 0, 10 * l_m_flDuckAmount_0);
                                        end;
                                        if l_hitbox_0 == "Chest" then
                                            l_vec_0 = l_vec_0 - vector(0, 0, 4 * l_m_flDuckAmount_0);
                                        end;
                                        if #v1936 ~= 0 then
                                            if l_v1529_2(v1936, l_hitbox_0) then
                                                table.insert(v1943, {
                                                    vec = l_vec_0,
                                                    scale = l_scale_0,
                                                    hitbox = l_hitbox_0
                                                });
                                            end;
                                        else
                                            table.insert(v1943, 1, {
                                                vec = l_vec_0,
                                                scale = l_scale_0,
                                                hitbox = l_hitbox_0
                                            });
                                        end;
                                    end;
                                    if not (v1928.is_revolver and not (v1927.m_flNextPrimaryAttack >= l_current_0) or math.max(v1926.m_flNextAttack, v1927.m_flNextPrimaryAttack, v1927.m_flNextSecondaryAttack) < l_current_0) then
                                        return;
                                    else
                                        local v1949 = nil;
                                        local v1950 = nil;
                                        if math.floor(v1938.alpha * 100) + 5 <= v1941 then
                                            return;
                                        else
                                            for v1951 = 1, #v1943 do
                                                local v1952 = v1943[v1951];
                                                local v1953 = l_v1532_2(v1931, v1939 + v1952.vec, v1952.scale);
                                                for v1954 = 1, #v1953 do
                                                    local v1955 = v1953[v1954];
                                                    local l_vec_1 = v1955.vec;
                                                    local v1958, v1959 = l_v1533_0(v1926, v1931, l_vec_1, function(v1957)
                                                        -- upvalues: v1937 (ref)
                                                        return v1957 == v1937;
                                                    end);
                                                    if (v1959 == nil or not v1959:is_visible()) and v1958 ~= 0 and v1942 < v1958 then
                                                        v1949 = l_vec_1;
                                                        v1950 = v1958;
                                                        l_v992_3 = v1937;
                                                        l_v1369_3 = v1952.hitbox;
                                                        l_v1370_2 = v1958;
                                                        l_v1368_2 = v1955.text;
                                                        l_l_aimtools_0_3 = v1938.alpha;
                                                        break;
                                                    end;
                                                end;
                                                if v1949 and v1950 then
                                                    break;
                                                end;
                                            end;
                                            if not v1949 or not v1950 then
                                                return;
                                            else
                                                local v1960 = v1931:to(v1949):angles();
                                                v1925.block_movement = 1;
                                                if l_v892_5 then
                                                    local v1961 = not v1925.in_jump and v1933;
                                                    local v1962 = v1926.m_bIsScoped or v1926.m_bResumeZoom;
                                                    local v1963 = v1928.weapon_type == l_l_match_0_4;
                                                    if not v1962 and v1963 and v1961 then
                                                        v1925.in_attack2 = true;
                                                    end;
                                                end;
                                                if v1929 < 0.01 then
                                                    v1925.view_angles = v1960;
                                                    v1925.in_attack = true;
                                                    l_v1373_2 = true;
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
        end;
    end;
    l_v1535_0 = function(v1964)
        -- upvalues: l_v1373_2 (ref), l_v1372_2 (ref), l_v992_3 (ref), l_v1369_3 (ref), l_v1370_2 (ref), l_v1368_2 (ref), l_l_aimtools_0_3 (ref)
        utils.execute_after(0.03, function()
            -- upvalues: v1964 (ref), l_v1373_2 (ref), l_v1372_2 (ref), l_v992_3 (ref), l_v1369_3 (ref), l_v1370_2 (ref), l_v1368_2 (ref), l_l_aimtools_0_3 (ref)
            if entity.get(v1964.userid, true) == entity.get_local_player() then
                if l_v1373_2 and not l_v1372_2 then
                    events.dormant_miss:call({
                        userid = l_v992_3,
                        aim_hitbox = l_v1369_3,
                        aim_damage = l_v1370_2,
                        aim_point = l_v1368_2,
                        accuracy = l_l_aimtools_0_3
                    });
                end;
                l_v1372_2 = false;
                l_v1373_2 = false;
                l_v992_3 = nil;
                l_v1369_3 = nil;
                l_v1370_2 = nil;
                l_v1368_2 = nil;
                l_l_aimtools_0_3 = nil;
            end;
        end);
    end;
    l_v1536_0 = function(v1965)
        -- upvalues: l_v1373_2 (ref), l_v1372_2 (ref), l_v1527_2 (ref), l_v1368_2 (ref), l_v1369_3 (ref), l_v1370_2 (ref)
        local v1966 = entity.get_local_player();
        local v1967 = entity.get(v1965.userid, true);
        local v1968 = entity.get(v1965.attacker, true);
        if v1967 == nil or v1968 ~= v1966 then
            return;
        else
            local v1969 = v1967:get_bbox();
            if v1969 == nil then
                return;
            else
                if v1967:is_dormant() and l_v1373_2 == true then
                    l_v1372_2 = true;
                    events.dormant_hit:call({
                        userid = v1967,
                        attacker = v1968,
                        health = v1965.health,
                        armor = v1965.armor,
                        weapon = v1965.weapon,
                        dmg_health = v1965.dmg_health,
                        dmg_armor = v1965.dmg_armor,
                        hitgroup = v1965.hitgroup,
                        accuracy = v1969.alpha,
                        hitbox = l_v1527_2[v1965.hitgroup],
                        aim_point = l_v1368_2,
                        aim_hitbox = l_v1369_3,
                        aim_damage = l_v1370_2
                    });
                end;
                return;
            end;
        end;
    end;
    l_v1537_1 = function()
        -- upvalues: l_l_angles_0_4 (ref)
        l_l_angles_0_4:override();
    end;
    v1538 = nil;
    v1539 = function(v1970)
        -- upvalues: l_l_angles_0_4 (ref), l_v1537_1 (ref), l_v1534_1 (ref), l_v1535_0 (ref), l_v1536_0 (ref)
        local v1971 = v1970:get();
        if not v1971 then
            l_l_angles_0_4:override();
        end;
        events.shutdown(l_v1537_1, v1971);
        events.createmove(l_v1534_1, v1971);
        events.weapon_fire(l_v1535_0, v1971);
        events.player_hurt(l_v1536_0, v1971);
    end;
    l_v891_4.enabled:set_callback(v1539, true);
end;
v846 = nil;
v888 = nil;
v889 = v384.visuals.aspect_ratio;
v890 = cvar.r_aspectratio;
do
    local l_v889_3, l_v890_5, l_v891_5, l_v892_6, l_l_match_0_5 = v889, v890, v891, v892, l_match_0;
    l_v891_5 = function()
        -- upvalues: l_v890_5 (ref)
        l_v890_5:float(tonumber(l_v890_5:string()), true);
    end;
    l_v892_6 = function(v1977)
        -- upvalues: l_v890_5 (ref)
        l_v890_5:float(v1977, true);
    end;
    l_l_match_0_5 = function()
        -- upvalues: l_v891_5 (ref)
        l_v891_5();
    end;
    l_angles_0 = nil;
    v982 = function(v1978)
        -- upvalues: l_v892_6 (ref)
        l_v892_6(v1978:get() * 0.01);
    end;
    do
        local l_v982_4 = v982;
        v992 = function(v1980)
            -- upvalues: l_v891_5 (ref), l_v889_3 (ref), l_v982_4 (ref), l_l_match_0_5 (ref)
            local v1981 = v1980:get();
            if not v1981 then
                l_v891_5();
            end;
            if v1981 then
                l_v889_3.value:set_callback(l_v982_4, true);
            else
                l_v889_3.value:unset_callback(l_v982_4);
            end;
            events.shutdown(l_l_match_0_5, v1981);
        end;
        l_v889_3.enabled:set_callback(v992, true);
    end;
end;
v889 = nil;
v890 = v384.visuals.viewmodel;
v891 = 0;
v892 = cvar.cl_righthand;
l_match_0 = cvar.viewmodel_fov;
l_angles_0 = cvar.viewmodel_offset_x;
v982 = cvar.viewmodel_offset_y;
v992 = cvar.viewmodel_offset_z;
v1368 = nil;
v1369 = function(v1982)
    return tonumber(v1982:string());
end;
do
    local l_v890_6, l_v891_6, l_v892_7, l_l_match_0_6, l_l_angles_0_5, l_v982_5, l_v992_4, l_v1368_3, l_v1369_4, l_v1370_3, l_l_aimtools_0_4, l_v1372_3, l_v1373_3, l_v1525_3 = v890, v891, v892, l_match_0, l_angles_0, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525;
    l_v1370_3 = function(v1997)
        -- upvalues: l_v892_7 (ref)
        if l_v892_7:string() == "1" then
            l_v892_7:int(v1997 and 0 or 1, true);
        else
            l_v892_7:int(v1997 and 1 or 0, true);
        end;
    end;
    l_l_aimtools_0_4 = function()
        -- upvalues: l_l_match_0_6 (ref), l_v1369_4 (ref), l_l_angles_0_5 (ref), l_v982_5 (ref), l_v992_4 (ref), l_v892_7 (ref)
        l_l_match_0_6:float(l_v1369_4(l_l_match_0_6), false);
        l_l_angles_0_5:float(l_v1369_4(l_l_angles_0_5), false);
        l_v982_5:float(l_v1369_4(l_v982_5), false);
        l_v992_4:float(l_v1369_4(l_v992_4), false);
        l_v892_7:int(l_v892_7:string() == "1" and 1 or 0, false);
    end;
    l_v1372_3 = function()
        -- upvalues: l_l_aimtools_0_4 (ref)
        l_l_aimtools_0_4();
    end;
    l_v1373_3 = function()
        -- upvalues: l_v1368_3 (ref), l_v891_6 (ref), l_v1370_3 (ref)
        local v1998 = entity.get_local_player();
        if v1998 == nil then
            return;
        else
            local v1999 = v1998:get_player_weapon();
            if v1999 == nil then
                return;
            else
                local v2000 = v1999:get_weapon_index();
                if l_v1368_3 ~= v2000 then
                    l_v1368_3 = v2000;
                    local v2001 = v1999:get_weapon_info();
                    if v2001 == nil then
                        return;
                    else
                        local v2002 = v2001.weapon_type == l_v891_6;
                        l_v1370_3(v2002);
                    end;
                end;
                return;
            end;
        end;
    end;
    l_v1525_3 = function(v2003)
        -- upvalues: l_l_aimtools_0_4 (ref), l_v1373_3 (ref), l_v1372_3 (ref)
        if not v2003 then
            l_l_aimtools_0_4();
        end;
        if not v2003 then
            events.pre_render(l_v1373_3, v2003);
        end;
        events.shutdown(l_v1372_3, v2003);
    end;
    v1526 = nil;
    v1527 = function(v2004)
        -- upvalues: l_l_match_0_6 (ref)
        l_l_match_0_6:float(v2004:get() * 0.01, true);
    end;
    v1528 = function(v2005)
        -- upvalues: l_l_angles_0_5 (ref)
        l_l_angles_0_5:float(v2005:get() * 0.01, true);
    end;
    v1529 = function(v2006)
        -- upvalues: l_v982_5 (ref)
        l_v982_5:float(v2006:get() * 0.01, true);
    end;
    v1530 = function(v2007)
        -- upvalues: l_v992_4 (ref)
        l_v992_4:float(v2007:get() * 0.01, true);
    end;
    v1531 = function(v2008)
        -- upvalues: l_v892_7 (ref), l_v1368_3 (ref), l_v1373_3 (ref)
        local v2009 = v2008:get();
        if not v2009 then
            l_v892_7:int(l_v892_7:string() == "1" and 1 or 0, false);
        else
            l_v1368_3 = nil;
        end;
        events.pre_render(l_v1373_3, v2009);
    end;
    do
        local l_v1527_3, l_v1528_2, l_v1529_3, l_v1530_3, l_v1531_3 = v1527, v1528, v1529, v1530, v1531;
        v1532 = function(v2015)
            -- upvalues: l_v890_6 (ref), l_v1527_3 (ref), l_v1528_2 (ref), l_v1529_3 (ref), l_v1530_3 (ref), l_v1531_3 (ref), l_v1525_3 (ref)
            local v2016 = v2015:get();
            if v2016 then
                l_v890_6.fov:set_callback(l_v1527_3, true);
                l_v890_6.offset_x:set_callback(l_v1528_2, true);
                l_v890_6.offset_y:set_callback(l_v1529_3, true);
                l_v890_6.offset_z:set_callback(l_v1530_3, true);
                l_v890_6.opposite_knife_hand:set_callback(l_v1531_3, true);
            else
                l_v890_6.fov:unset_callback(l_v1527_3);
                l_v890_6.offset_x:unset_callback(l_v1528_2);
                l_v890_6.offset_y:unset_callback(l_v1529_3);
                l_v890_6.offset_z:unset_callback(l_v1530_3);
                l_v890_6.opposite_knife_hand:unset_callback(l_v1531_3);
            end;
            l_v1525_3(v2016);
        end;
        l_v890_6.enabled:set_callback(v1532, true);
    end;
end;
v890 = nil;
v891 = v384.visuals.indicators;
v892 = {};
l_match_0 = {
    [1] = {
        [1] = "\226\156\166",
        [2] = 0,
        [3] = 10,
        [4] = 0.5
    },
    [2] = {
        [1] = "\226\139\134",
        [2] = -3,
        [3] = 3,
        [4] = 0.2
    },
    [3] = {
        [1] = "\226\152\133",
        [2] = -1,
        [3] = 8,
        [4] = 0.4
    },
    [4] = {
        [1] = "\226\156\166",
        [2] = 0,
        [3] = 6,
        [4] = 0.7
    },
    [5] = {
        [1] = "\226\139\134",
        [2] = -2,
        [3] = 2,
        [4] = 0.3
    },
    [6] = {
        [1] = "\226\152\133",
        [2] = 1,
        [3] = 7,
        [4] = 0.6
    },
    [7] = {
        [1] = "\226\139\134",
        [2] = 0,
        [3] = 3,
        [4] = 0.2
    },
    [8] = {
        [1] = "\226\156\166",
        [2] = 0,
        [3] = 8,
        [4] = 0.7
    },
    [9] = {
        [1] = "\226\139\134",
        [2] = -2,
        [3] = 7,
        [4] = 0.2
    }
};
l_angles_0 = 0;
v982 = 0;
v992 = 0;
v1368 = 0;
v1369 = 0;
v1370 = function()
    -- upvalues: v394 (ref), v26 (ref)
    if not v394.is_onground then
        if v394.is_crouched then
            return "airc";
        else
            return "air";
        end;
    elseif v394.is_crouched then
        if v394.is_moving then
            return "sneak";
        else
            return "crouch";
        end;
    elseif v394.is_moving then
        if v26.antiaim.misc.slow_walk:get() then
            return "walk";
        else
            return "run";
        end;
    else
        return "stand";
    end;
end;
do
    local l_v891_7, l_v892_8, l_l_match_0_7, l_l_angles_0_6 = v891, v892, l_match_0, l_angles_0;
    do
        local l_l_l_match_0_7_0, l_l_l_angles_0_6_0, l_v982_6, l_v992_5, l_v1368_4, l_v1369_5, l_v1370_4, l_l_aimtools_0_5, l_v1372_4, l_v1373_4, l_v1525_4, l_v1526_2, l_v1527_4, l_v1528_3, l_v1529_4 = l_l_match_0_7, l_l_angles_0_6, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529;
        l_l_aimtools_0_5 = function(v2036, v2037)
            -- upvalues: l_l_l_match_0_7_0 (ref), l_play_0 (ref), v12 (ref), l_v982_6 (ref)
            local l_realtime_0 = globals.realtime;
            local v2039 = {};
            local v2040 = #l_l_l_match_0_7_0;
            local v2041 = 0;
            local v2042 = 0;
            for v2043 = 1, v2040 do
                local v2044 = l_l_l_match_0_7_0[v2043];
                local v2045 = l_play_0.measure_text(1, "", v2044[1]);
                v2041 = v2041 + (v2045.x + v2044[2]);
                v2042 = math.max(v2042, v2045.y + v2044[3]);
                v2039[v2043] = v2045;
            end;
            local v2046 = v2036:clone();
            v2046.x = v12(v2046.x - v2041 * 0.5 * (1 - l_v982_6));
            for v2047 = 1, v2040 do
                local v2048 = l_l_l_match_0_7_0[v2047];
                local v2049 = v2039[v2047];
                local v2050 = v2048[1];
                local v2051 = v2048[2];
                local v2052 = v2048[3];
                local v2053 = v2048[4];
                local v2054 = (math.sin(l_realtime_0 * v2053) * 0.5 + 0.5) * 0.7 + 0.3;
                local v2055 = v2037:clone();
                local v2056 = v2046:clone();
                v2056.x = v2056.x + v2051;
                v2056.y = v2056.y + v2052;
                v2055.a = v2055.a * v2054;
                l_play_0.text(1, v2056, v2055, "", v2050);
                v2046.x = v2046.x + (v2049.x + v2051);
            end;
            v2036.y = v2036.y + v2042 * 0.66;
        end;
        l_v1372_4 = function(v2057, v2058, v2059)
            -- upvalues: v13 (ref), l_play_0 (ref), v149 (ref), v12 (ref), l_v982_6 (ref)
            local v2060 = 4;
            local l_name_1 = v13.name;
            local v2062 = "";
            local v2063 = l_play_0.measure_text(v2060, v2062, l_name_1);
            local v2064 = -globals.realtime * 1.25;
            l_name_1 = v149.gradient(l_name_1, v2064, v2058, v2059);
            local v2065 = v2057:clone();
            v2065.x = v12(v2065.x - v2063.x * 0.5 * (1 - l_v982_6));
            l_play_0.text(v2060, v2065, v2058, v2062, l_name_1);
            v2057.y = v2057.y + v2063.y;
        end;
        l_v1373_4 = function(v2066, v2067, v2068)
            -- upvalues: l_v1370_4 (ref), l_play_0 (ref), v12 (ref), l_v982_6 (ref)
            local v2069 = 1;
            local v2070 = l_v1370_4();
            local v2071 = "";
            local v2072 = l_play_0.measure_text(v2069, v2071, v2070);
            local v2073 = v2067:clone();
            local v2074 = v2066:clone();
            v2073.a = v2073.a * v2068;
            v2074.x = v12(v2074.x - v2072.x * 0.5 * (1 - l_v982_6));
            l_play_0.text(v2069, v2074, v2073, v2071, v2070);
            v2066.y = v2066.y + v12(v2072.y);
        end;
        l_v1525_4 = function(v2075, v2076, v2077)
            -- upvalues: l_play_0 (ref), v12 (ref), l_v982_6 (ref)
            local v2078 = 1;
            local v2079 = "dt";
            local v2080 = "";
            local v2081 = l_play_0.measure_text(v2078, v2080, v2079);
            local v2082 = v2076:clone();
            local v2083 = v2075:clone();
            local v2084 = rage.exploit:get();
            v2082 = v2082:lerp(color(255, 0, 50, 255), 1 - v2084 * v2084);
            v2082.a = v2082.a * v2077;
            v2083.x = v12(v2083.x - v2081.x * 0.5 * (1 - l_v982_6));
            l_play_0.text(v2078, v2083, v2082, v2080, v2079);
            v2075.y = v2075.y + v12(v2081.y * v2077);
        end;
        l_v1526_2 = function(v2085, v2086, v2087)
            -- upvalues: l_play_0 (ref), v12 (ref), l_v982_6 (ref)
            local v2088 = 1;
            local v2089 = "dmg";
            local v2090 = "";
            local v2091 = l_play_0.measure_text(v2088, v2090, v2089);
            local v2092 = v2086:clone();
            local v2093 = v2085:clone();
            v2092.a = v2092.a * v2087;
            v2093.x = v12(v2093.x - v2091.x * 0.5 * (1 - l_v982_6));
            l_play_0.text(v2088, v2093, v2092, v2090, v2089);
            v2085.y = v2085.y + v12(v2091.y * v2087);
        end;
        l_v1527_4 = function(v2094, v2095, v2096)
            -- upvalues: l_play_0 (ref), v12 (ref), l_v982_6 (ref)
            local v2097 = 1;
            local v2098 = "osaa";
            local v2099 = "";
            local v2100 = l_play_0.measure_text(v2097, v2099, v2098);
            local v2101 = v2095:clone();
            local v2102 = v2094:clone();
            v2101.a = v2101.a * v2096;
            v2102.x = v12(v2102.x - v2100.x * 0.5 * (1 - l_v982_6));
            l_play_0.text(v2097, v2102, v2101, v2099, v2098);
            v2094.y = v2094.y + v12(v2100.y * v2096);
        end;
        l_v1528_3 = function(v2103)
            -- upvalues: v767 (ref), v26 (ref), l_l_l_angles_0_6_0 (ref), v32 (ref), l_v982_6 (ref), l_v992_5 (ref), l_v1368_4 (ref), l_v1369_5 (ref)
            local v2104 = v2103:is_alive();
            local l_m_bIsScoped_0 = v2103.m_bIsScoped;
            local v2106 = v767.get(v26.ragebot.selection.min_damage);
            local v2107 = v2106 ~= nil and (v2106.active or false);
            local v2108 = v26.ragebot.main.double_tap[1]:get();
            local v2109 = v26.ragebot.main.hide_shots[1]:get();
            l_l_l_angles_0_6_0 = v32.interp(l_l_l_angles_0_6_0, v2104, 0.05);
            l_v982_6 = v32.interp(l_v982_6, l_m_bIsScoped_0, 0.05);
            l_v992_5 = v32.interp(l_v992_5, v2108, 0.05);
            l_v1368_4 = v32.interp(l_v1368_4, v2107, 0.05);
            l_v1369_5 = v32.interp(l_v1369_5, v2109, 0.05);
        end;
        l_v1529_4 = function()
            -- upvalues: l_play_0 (ref), l_v891_7 (ref), v12 (ref), l_v982_6 (ref), l_l_l_angles_0_6_0 (ref), l_l_aimtools_0_5 (ref), l_v1372_4 (ref), l_v1373_4 (ref), l_v1525_4 (ref), l_v992_5 (ref), l_v1526_2 (ref), l_v1368_4 (ref), l_v1527_4 (ref), l_v1369_5 (ref)
            local v2110 = l_play_0.screen_size() * 0.5;
            local v2111 = l_v891_7.accent_color:get();
            local v2112 = l_v891_7.secondary_color:get();
            v2110.x = v2110.x + v12(10 * l_v982_6);
            v2110.y = v2110.y + l_v891_7.offset:get();
            v2111.a = v2111.a * l_l_l_angles_0_6_0;
            v2112.a = v2112.a * l_l_l_angles_0_6_0;
            l_l_aimtools_0_5(v2110, v2111);
            l_v1372_4(v2110, v2111, v2112);
            l_v1373_4(v2110, color(255, 255, 255, 200), l_l_l_angles_0_6_0);
            l_v1525_4(v2110, color(255, 255, 255, 200), l_v992_5 * l_l_l_angles_0_6_0);
            l_v1526_2(v2110, color(255, 255, 255, 200), l_v1368_4 * l_l_l_angles_0_6_0);
            l_v1527_4(v2110, color(255, 255, 255, 200 * (1 - l_v992_5 * 0.5)), l_v1369_5 * l_l_l_angles_0_6_0);
        end;
        l_v892_8.on_render = function()
            -- upvalues: l_v1528_3 (ref), l_l_l_angles_0_6_0 (ref), l_v1529_4 (ref)
            local v2113 = entity.get_local_player();
            if v2113 == nil then
                return;
            else
                l_v1528_3(v2113);
                if l_l_l_angles_0_6_0 > 0 then
                    l_v1529_4();
                end;
                return;
            end;
        end;
    end;
    l_l_match_0_7 = {};
    l_l_angles_0_6 = "";
    v982 = 0;
    v992 = 0;
    v1368 = 0;
    v1369 = 0;
    v1370 = 0;
    l_aimtools_0 = 0;
    v1372 = function(v2114)
        local v2115 = v2114:get_player_weapon();
        if v2115 == nil then
            return false;
        else
            local v2116 = v2115:get_weapon_info();
            if v2116 == nil then
                return false;
            elseif v2116.type ~= 9 then
                return false;
            else
                return true;
            end;
        end;
    end;
    v1373 = function(v2117, v2118)
        -- upvalues: v14 (ref)
        local v2119 = globals.realtime * 3;
        local v2120 = math.abs(math.sin(v2119));
        return v14.lerp(v2117, v2118, v2120);
    end;
    v1525 = function()
        -- upvalues: v394 (ref), v26 (ref)
        if not v394.is_onground then
            return "-AIR-";
        elseif v394.is_crouched then
            return "-CROUCH-";
        elseif v394.is_moving then
            if v26.antiaim.misc.slow_walk:get() then
                return "-WALKING-";
            else
                return "-MOVING-";
            end;
        else
            return "-STANDING-";
        end;
    end;
    do
        local l_l_l_angles_0_6_1, l_v982_7, l_v992_6, l_v1368_5, l_v1369_6, l_v1370_5, l_l_aimtools_0_6, l_v1372_5, l_v1373_5, l_v1525_5, l_v1526_3, l_v1527_5, l_v1528_4, l_v1529_5, l_v1530_4, l_v1531_4, l_v1532_3, l_v1533_1 = l_l_angles_0_6, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529, v1530, v1531, v1532, v1533;
        l_v1526_3 = function()
            -- upvalues: v26 (ref), l_l_l_angles_0_6_1 (ref)
            if v26.ragebot.main.double_tap[1]:get() then
                l_l_l_angles_0_6_1 = "DT";
            elseif v26.ragebot.main.hide_shots[1]:get() then
                l_l_l_angles_0_6_1 = "HIDE";
            end;
            return l_l_l_angles_0_6_1, color(255, 255, 255, 255);
        end;
        l_v1527_5 = function(v2139)
            -- upvalues: v395 (ref)
            if v2139 == 0 then
                return "WAITING", color(255, 64, 64, 255);
            elseif v2139 == 1 then
                if v395.defensive_ticks > 0 then
                    return "ACTIVE", color(120, 255, 255, 255);
                else
                    return "READY", color(192, 255, 109, 255);
                end;
            else
                return "CHARGING", color(255, 64, 64, 255):lerp(color(192, 255, 109, 255), v2139);
            end;
        end;
        l_v1528_4 = function(v2140)
            -- upvalues: l_v1372_5 (ref), v767 (ref), v26 (ref), l_v982_7 (ref), v32 (ref), l_v992_6 (ref), l_v1369_6 (ref), l_v1370_5 (ref), l_l_aimtools_0_6 (ref)
            local v2141 = v2140:is_alive();
            local l_m_bIsScoped_1 = v2140.m_bIsScoped;
            local v2143 = l_v1372_5(v2140);
            local v2144 = v767.get(v26.ragebot.selection.min_damage);
            local v2145 = v2144 ~= nil and (v2144.active or false);
            local v2146 = v26.ragebot.main.double_tap[1]:get();
            local v2147 = v26.ragebot.main.hide_shots[1]:get();
            local v2148 = 0;
            if v2141 then
                v2148 = v2143 and 0.5 or 1;
            end;
            l_v982_7 = v32.interp(l_v982_7, v2148, 0.05);
            l_v992_6 = v32.interp(l_v992_6, l_m_bIsScoped_1, 0.05);
            l_v1369_6 = v32.interp(l_v1369_6, v2146, 0.03);
            l_v1370_5 = v32.interp(l_v1370_5, v2145, 0.03);
            l_l_aimtools_0_6 = v32.interp(l_l_aimtools_0_6, v2147, 0.03);
        end;
        l_v1529_5 = function(v2149, v2150, v2151, v2152)
            -- upvalues: l_play_0 (ref), l_v1373_5 (ref), l_v992_6 (ref)
            local v2153 = 2;
            local v2154 = "";
            local v2155 = "ANGELIC";
            local v2156 = "YAW";
            local v2157 = l_play_0.measure_text(v2153, v2154, v2155);
            local v2158 = l_play_0.measure_text(v2153, v2154, v2156);
            local v2159 = v2157.x + v2158.x;
            local v2160 = math.max(v2157.y, v2158.y);
            local v2161 = v2149:clone();
            local v2162 = v2159 * 0.5;
            local v2163 = l_v1373_5(0.25, 1);
            local v2164 = v2150:clone();
            local v2165 = v2151:clone();
            v2164.a = v2164.a * v2152;
            v2165.a = v2165.a * v2152;
            v2164.a = v2164.a * v2163;
            v2161.x = v2161.x - v2162 * (1 - l_v992_6) + 1;
            l_play_0.text(v2153, v2161, v2165, v2154, v2155);
            v2161.x = v2161.x + v2157.x;
            l_play_0.text(v2153, v2161, v2164, v2154, v2156);
            v2149.y = v2149.y + (v2160 - 3);
        end;
        l_v1530_4 = function(v2166, _, v2168)
            -- upvalues: l_v1525_5 (ref), l_play_0 (ref), l_v1368_5 (ref), v32 (ref), l_v992_6 (ref)
            local v2169 = 2;
            local v2170 = "";
            local v2171 = l_v1525_5();
            local v2172 = l_play_0.measure_text(v2169, v2170, v2171);
            local l_x_1 = v2172.x;
            local l_y_0 = v2172.y;
            if l_v1368_5 < l_x_1 then
                l_v1368_5 = v32.interp(l_v1368_5, l_x_1, 0.05);
            else
                l_v1368_5 = l_x_1;
            end;
            local v2175 = v2166:clone();
            local v2176 = l_v1368_5 * 0.5;
            v2175.x = v2175.x - v2176 * (1 - l_v992_6) + 1;
            local v2177 = color(255, 255, 255, 255);
            v2177.a = v2177.a * v2168;
            l_play_0.push_clip_rect(v2175, v2175 + vector(l_v1368_5, l_y_0));
            l_play_0.text(v2169, v2175, v2177, v2170, v2171);
            l_play_0.pop_clip_rect();
            v2166.y = v2166.y + (l_y_0 - 3);
        end;
        l_v1531_4 = function(v2178, v2179, v2180)
            -- upvalues: l_v1526_3 (ref), l_v1527_5 (ref), l_play_0 (ref), l_v992_6 (ref)
            local v2181 = 2;
            local v2182 = "";
            local v2183 = rage.exploit:get();
            local v2184, v2185 = l_v1526_3();
            local v2186, v2187 = l_v1527_5(v2183);
            local v2188 = string.format("\a%s%s \a%s%s", v2185:to_hex(), v2184, v2187:to_hex(), v2186);
            local v2189 = l_play_0.measure_text(v2181, v2182, v2188);
            local l_x_2 = v2189.x;
            local l_y_1 = v2189.y;
            local v2192 = v2178:clone();
            local v2193 = l_x_2 * 0.5;
            v2192.x = v2192.x - v2193 * v2179 * (1 - l_v992_6) + 1;
            local v2194 = color(255, 255, 255, 255);
            v2194.a = v2194.a * v2180 * v2179;
            local v2195 = v2194:clone();
            v2195.a = v2195.a * 0.5;
            l_play_0.push_clip_rect(v2192, v2192 + vector(l_x_2 * v2179, l_y_1));
            l_play_0.text(v2181, v2192, v2195, v2182, v2188);
            l_play_0.pop_clip_rect();
            l_play_0.push_clip_rect(v2192, v2192 + vector(l_x_2 * v2179 * v2183, l_y_1));
            l_play_0.text(v2181, v2192, v2194, v2182, v2188);
            l_play_0.pop_clip_rect();
            v2178.y = v2178.y + (l_y_1 - 3) * v2179;
        end;
        l_v1532_3 = function(v2196, v2197, v2198)
            -- upvalues: l_play_0 (ref), l_v992_6 (ref)
            local v2199 = 2;
            local v2200 = "";
            local v2201 = "DMG";
            local v2202 = l_play_0.measure_text(v2199, v2200, v2201);
            local l_x_3 = v2202.x;
            local l_y_2 = v2202.y;
            local v2205 = v2196:clone();
            local v2206 = l_x_3 * 0.5;
            v2205.x = v2205.x - v2206 * v2197 * (1 - l_v992_6) + 1;
            local v2207 = color(255, 255, 255, 255);
            v2207.a = v2207.a * v2198 * v2197;
            l_play_0.push_clip_rect(v2205, v2205 + vector(l_x_3 * v2197, l_y_2));
            l_play_0.text(v2199, v2205, v2207, v2200, v2201);
            l_play_0.pop_clip_rect();
            v2196.y = v2196.y + (l_y_2 - 3) * v2197;
        end;
        l_v1533_1 = function()
            -- upvalues: l_play_0 (ref), l_v891_7 (ref), l_v1369_6 (ref), l_l_aimtools_0_6 (ref), v12 (ref), l_v992_6 (ref), l_v1529_5 (ref), l_v982_7 (ref), l_v1530_4 (ref), l_v1531_4 (ref), l_v1532_3 (ref), l_v1370_5 (ref)
            local v2208 = l_play_0.screen_size() * 0.5;
            local v2209 = l_v891_7.accent_color:get();
            local v2210 = l_v891_7.secondary_color:get();
            local v2211 = math.max(l_v1369_6, l_l_aimtools_0_6);
            v2208.x = v2208.x + v12(10 * l_v992_6);
            v2208.y = v2208.y + l_v891_7.offset:get();
            l_v1529_5(v2208, v2209, v2210, l_v982_7);
            l_v1530_4(v2208, color(255, 255, 255, 255), l_v982_7);
            l_v1531_4(v2208, v2211, l_v982_7);
            l_v1532_3(v2208, l_v1370_5, l_v982_7);
        end;
        l_l_match_0_7.on_render = function()
            -- upvalues: l_v1528_4 (ref), l_v982_7 (ref), l_v1533_1 (ref)
            local v2212 = entity.get_local_player();
            if v2212 == nil then
                return;
            else
                l_v1528_4(v2212);
                if l_v982_7 > 0 then
                    l_v1533_1();
                end;
                return;
            end;
        end;
    end;
    l_l_angles_0_6 = function(v2213)
        -- upvalues: l_v892_8 (ref), l_l_match_0_7 (ref)
        local v2214 = v2213 == 1;
        local v2215 = v2213 == 2;
        events.render(l_v892_8.on_render, v2214);
        events.render(l_l_match_0_7.on_render, v2215);
    end;
    v982 = nil;
    v992 = function(v2216)
        -- upvalues: l_l_angles_0_6 (ref)
        l_l_angles_0_6(v2216:get());
    end;
    do
        local l_v992_7 = v992;
        v1368 = function(v2218)
            -- upvalues: l_l_angles_0_6 (ref), l_v891_7 (ref), l_v992_7 (ref)
            local v2219 = v2218:get();
            if not v2219 then
                l_l_angles_0_6(nil);
            end;
            if v2219 then
                l_v891_7.style:set_callback(l_v992_7, true);
            else
                l_v891_7.style:unset_callback(l_v992_7);
            end;
        end;
        l_v891_7.enabled:set_callback(v1368, true);
    end;
end;
v891 = nil;
v892 = v384.visuals.solus_ui;
l_match_0 = 5;
l_angles_0 = 1;
v982 = function(v2220, v2221)
    local v2222 = {};
    for v2223 = 1, v2221 do
        v2222[v2223] = v2220;
    end;
    return v2222;
end;
v992 = function(v2224, v2225, v2226)
    if v2226 or v2224[#v2224] ~= v2225 then
        table.insert(v2224, v2225);
        table.remove(v2224, 1);
    end;
end;
v1368 = function(v2227)
    local v2228 = 0;
    local v2229 = 0;
    for _, v2231 in pairs(v2227) do
        v2229 = v2229 + v2231;
        v2228 = v2228 + 1;
    end;
    return v2229 / v2228;
end;
v1369 = function()
    -- upvalues: l_play_0 (ref)
    return {
        draw = function(_, v2233, v2234, v2235, v2236, v2237, v2238)
            -- upvalues: l_play_0 (ref)
            local l_v2234_0 = v2234;
            local l_clr_1_0 = v2237.clr_1;
            v2234 = 0;
            v2235 = v2235 - l_v2234_0;
            v2237.h = v2237.h - v2237.thickness;
            if v2238 then
                l_play_0.rect_outline(vector(v2237.x, v2237.y), vector(v2237.x + v2237.w - 1, v2237.y + v2237.h - 1 + v2237.thickness), l_clr_1_0);
            end;
            if v2234 == v2235 then
                l_play_0.line(vector(v2237.x, v2237.y + v2237.h), vector(v2237.x + v2237.w, v2237.y + v2237.h), l_clr_1_0);
                return;
            else
                local v2241 = v2237.w / (v2236 - 1);
                local v2242 = v2235 - v2234;
                for v2243 = 1, v2236 - 1 do
                    local v2244 = vector((v2233[v2243] - l_v2234_0) / v2242, (v2233[v2243 + 1] - l_v2234_0) / v2242);
                    local v2245 = {
                        vector(v2237.x + v2241 * (v2243 - 1), v2237.y + v2237.h - v2237.h * v2244.x),
                        vector(v2237.x + v2241 * v2243, v2237.y + v2237.h - v2237.h * v2244.y)
                    };
                    for v2246 = 1, v2237.thickness do
                        l_play_0.line(vector(v2245[1].x, v2245[1].y + v2246 - 1), vector(v2245[2].x, v2245[2].y + v2246 - 1), l_clr_1_0);
                    end;
                end;
                return;
            end;
        end,
        draw_histogram = function(_, v2248, v2249, v2250, v2251, v2252, v2253)
            -- upvalues: l_play_0 (ref)
            local l_v2249_0 = v2249;
            v2249 = 0;
            v2250 = v2250 - l_v2249_0;
            if v2253 then
                l_play_0.rect_outline(vector(v2252.x, v2252.y), vector(v2252.x + v2252.w - 1, v2252.y + v2252.h - 1), color(255, 255, 255, 255));
            end;
            local v2255 = v2252.w / (v2251 - 1);
            local v2256 = v2250 - v2249;
            for v2257 = 1, v2251 - 1 do
                local v2258 = vector((v2248[v2257] - l_v2249_0) / v2256, (v2248[v2257 + 1] - l_v2249_0) / v2256);
                local v2259 = {
                    [1] = vector(math.floor(v2252.x + v2255 * (v2257 - 1)), math.floor(v2252.y + v2252.h - v2252.h * v2258.x)),
                    [2] = vector(math.floor(v2252.x + v2255 * v2257), math.floor(v2252.y + v2252.h)),
                    isZero = math.floor(v2252.y + v2252.h) == math.floor(v2252.y + v2252.h - v2252.h * v2258.x)
                };
                if v2252.draw_bar == "fill" then
                    l_play_0.rect(v2259[1], v2259[2], v2252.clr_1);
                elseif v2252.draw_bar == "gradient_fadeout" then
                    local v2260 = v2252.clr_1:clone();
                    local v2261 = v2252.clr_1:clone();
                    v2261.a = 0;
                    l_play_0.gradient(v2259[1], v2259[2], v2260, v2260, v2261, v2261);
                elseif v2252.draw_bar == "gradient_fadein" then
                    local v2262 = v2252.clr_1:clone();
                    local v2263 = v2252.clr_1:clone();
                    v2263.a = 0;
                    l_play_0.gradient(v2259[1], v2259[2], v2263, v2263, v2262, v2262);
                end;
                if v2252.draw_peeks and not v2259.isZero then
                    l_play_0.line(v2259[1], v2259[2], v2252.clr_2);
                end;
            end;
        end
    };
end;
v1370 = function(v2264, v2265, v2266, v2267, v2268, ...)
    -- upvalues: l_play_0 (ref)
    l_play_0.rect(vector(v2264, v2265), vector(v2264 + v2266, v2265 + v2267), v2268, ...);
end;
l_aimtools_0 = function(v2269, v2270, v2271, v2272, v2273, v2274, v2275, ...)
    -- upvalues: l_play_0 (ref)
    local v2276 = nil;
    local v2277 = nil;
    local v2278 = nil;
    local v2279 = nil;
    if v2275 then
        local l_v2273_0 = v2273;
        v2278 = v2273;
        v2276 = l_v2273_0;
        l_v2273_0 = v2274;
        v2279 = v2274;
        v2277 = l_v2273_0;
    else
        local l_v2273_1 = v2273;
        v2277 = v2273;
        v2276 = l_v2273_1;
        l_v2273_1 = v2274;
        v2279 = v2274;
        v2278 = l_v2273_1;
    end;
    l_play_0.gradient(vector(v2269, v2270), vector(v2269 + v2271, v2270 + v2272), v2276, v2277, v2278, v2279, ...);
end;
do
    local l_v892_9, l_l_match_0_8, l_l_angles_0_7, l_v992_8, l_v1368_6, l_v1370_6, l_l_aimtools_0_7, l_v1372_6, l_v1373_6, l_v1525_6, l_v1526_4, l_v1527_6, l_v1528_5 = v892, l_match_0, l_angles_0, v992, v1368, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528;
    l_v1372_6 = function(v2295, v2296, v2297, v2298)
        -- upvalues: l_play_0 (ref), l_l_match_0_8 (ref), l_v1370_6 (ref), l_l_angles_0_7 (ref), l_l_aimtools_0_7 (ref)
        local l_x_4 = v2295.x;
        local l_y_3 = v2295.y;
        local v2301 = v2296.x - v2295.x;
        local v2302 = v2296.y - v2295.y;
        local v2303 = v2297:alpha_modulate(255 * v2298);
        local v2304 = v2297:alpha_modulate(50 * v2298);
        l_play_0.blur(v2295, v2296, 0.5, v2298, l_l_match_0_8);
        l_play_0.rect(v2295, v2296, color(17, 17, 17, v2297.a * v2298), l_l_match_0_8);
        l_v1370_6(l_x_4 + l_l_match_0_8, l_y_3, v2301 - l_l_match_0_8 * 2, l_l_angles_0_7, v2303);
        l_v1370_6(l_x_4 + l_l_match_0_8, l_y_3 + v2302 - l_l_angles_0_7, v2301 - l_l_match_0_8 * 2, l_l_angles_0_7, v2304);
        l_play_0.circle_outline(vector(l_x_4 + l_l_match_0_8, l_y_3 + l_l_match_0_8), v2303, l_l_match_0_8 + 0.5, 180, 0.25, l_l_angles_0_7);
        l_play_0.circle_outline(vector(l_x_4 + v2301 - l_l_match_0_8, l_y_3 + l_l_match_0_8), v2303, l_l_match_0_8 + 0.5, 270, 0.25, l_l_angles_0_7);
        l_play_0.circle_outline(vector(l_x_4 + l_l_match_0_8, l_y_3 + v2302 - l_l_match_0_8), v2304, l_l_match_0_8 + 0.5, 90, 0.25, l_l_angles_0_7);
        l_play_0.circle_outline(vector(l_x_4 + v2301 - l_l_match_0_8, l_y_3 + v2302 - l_l_match_0_8), v2304, l_l_match_0_8 + 0.5, 0, 0.25, l_l_angles_0_7);
        l_l_aimtools_0_7(l_x_4, l_y_3 + l_l_match_0_8, l_l_angles_0_7, v2302 - l_l_match_0_8 * 2, v2303, v2304, false);
        l_l_aimtools_0_7(l_x_4 + v2301 - l_l_angles_0_7, l_y_3 + l_l_match_0_8, l_l_angles_0_7, v2302 - l_l_match_0_8 * 2, v2303, v2304, false);
    end;
    l_v1373_6 = {};
    l_v1525_6 = 0;
    l_v1526_4 = function()
        -- upvalues: l_v892_9 (ref)
        return l_v892_9.enabled:get() and l_v892_9.select:get("Watermark");
    end;
    do
        local l_l_v1525_6_0, l_l_v1526_4_0 = l_v1525_6, l_v1526_4;
        l_v1373_6.draw = function(v2307)
            -- upvalues: l_l_v1525_6_0 (ref), v32 (ref), l_l_v1526_4_0 (ref), l_play_0 (ref), l_v1372_6 (ref), l_v892_9 (ref)
            local v2308 = v2307:clone();
            l_l_v1525_6_0 = v32.interp(l_l_v1525_6_0, l_l_v1526_4_0(), 0.05);
            if l_l_v1525_6_0 <= 0 then
                return;
            else
                local v2309 = {};
                local v2310 = utils.net_channel();
                local v2311 = common.get_system_time();
                table.insert(v2309, "angelwings");
                table.insert(v2309, common.get_username());
                if v2310 ~= nil then
                    table.insert(v2309, string.format("delay: %dms", v2310.latency[1] * 1000));
                end;
                if v2311 ~= nil then
                    table.insert(v2309, string.format("%02d:%02d:%02d", v2311.hours, v2311.minutes, v2311.seconds));
                end;
                v2310 = 1;
                v2311 = "";
                local v2312 = table.concat(v2309, " | ");
                local v2313 = l_play_0.measure_text(v2310, v2311, v2312);
                local v2314 = color(255, 255, 255, 255);
                local v2315 = v2313 + vector(10, 8);
                v2308.x = v2308.x - v2315.x;
                v2314.a = v2314.a * l_l_v1525_6_0;
                l_v1372_6(v2308, v2308 + v2315, l_v892_9.color:get(), l_l_v1525_6_0);
                l_play_0.text(v2310, v2308 + vector(5, 4), v2314, v2311, v2312);
                v2307.y = v2307.y + (v2315.y + 10) * l_l_v1525_6_0;
                return;
            end;
        end;
    end;
    l_v1525_6 = {};
    l_v1526_4 = {};
    l_v1527_6 = 0;
    l_v1528_5 = nil;
    v1529 = nil;
    v1530 = vector(400, 340);
    v1531 = vector(120, 20);
    v1532 = l_play_0.screen_size();
    v1529 = v141.new("spectators", v1530, v1531, {
        border = {
            vector(0, 0),
            v1532:clone()
        }
    });
    do
        local l_l_v1526_4_1, l_l_v1527_6_0, l_l_v1528_5_0, l_v1529_6, l_v1530_5, l_v1531_5, l_v1532_4 = l_v1526_4, l_v1527_6, l_v1528_5, v1529, v1530, v1531, v1532;
        l_v1529_6.update = function()
            -- upvalues: l_l_v1527_6_0 (ref)
            return l_l_v1527_6_0;
        end;
        l_v1530_5 = function()
            -- upvalues: l_v892_9 (ref)
            return l_v892_9.enabled:get() and l_v892_9.select:get("Spectators");
        end;
        l_v1531_5 = function(v2323)
            local l_m_iObserverMode_0 = v2323.m_iObserverMode;
            if l_m_iObserverMode_0 == 4 or l_m_iObserverMode_0 == 5 then
                local l_m_hObserverTarget_0 = v2323.m_hObserverTarget;
                if l_m_hObserverTarget_0 ~= nil then
                    return l_m_hObserverTarget_0:get_spectators();
                end;
            end;
            return v2323:get_spectators();
        end;
        l_v1532_4 = function(v2326, v2327)
            -- upvalues: l_v1531_5 (ref), l_l_v1526_4_1 (ref), l_play_0 (ref), v32 (ref)
            local v2328 = entity.get_local_player();
            local v2329 = {};
            local v2330 = false;
            local v2331 = 0;
            if v2328 ~= nil then
                local v2332 = l_v1531_5(v2328) or {};
                for _, v2334 in pairs(v2332) do
                    local v2335 = v2334:get_index();
                    local v2336 = v2334:get_name();
                    local v2337 = v2334:get_steam_avatar();
                    v2330 = true;
                    v2329[v2335] = v2334;
                    l_l_v1526_4_1[v2335] = l_l_v1526_4_1[v2335] or {
                        name_height = 0,
                        name_width = 0,
                        alpha = 0,
                        name = v2336,
                        avatar = v2337
                    };
                    local v2338 = l_l_v1526_4_1[v2335];
                    local v2339 = l_play_0.measure_text(v2326, v2327, v2336);
                    v2338.name = v2336;
                    v2338.name_width = v2339.x;
                    v2338.name_height = v2339.y;
                end;
            end;
            for v2340, v2341 in pairs(l_l_v1526_4_1) do
                local v2342 = v2329[v2340] ~= nil;
                v2341.alpha = v32.interp(v2341.alpha, v2342, 0.05);
                if v2341.alpha <= 0.01 then
                    l_l_v1526_4_1[v2340] = nil;
                elseif (v2341.alpha > 0 or v2342) and v2331 < v2341.name_width then
                    v2331 = v2341.name_width;
                end;
            end;
            return l_l_v1526_4_1, v2330, v2331;
        end;
        l_v1525_6.draw = function()
            -- upvalues: l_v1532_4 (ref), l_v1530_5 (ref), l_l_v1527_6_0 (ref), v32 (ref), l_v1529_6 (ref), l_l_v1528_5_0 (ref), l_v1372_6 (ref), l_v892_9 (ref), l_play_0 (ref), v12 (ref)
            local v2343 = 1;
            local v2344 = "c";
            local v2345 = "spectators";
            local v2346, v2347, v2348 = l_v1532_4(v2343, v2344);
            local v2349 = l_v1530_5() and (v2347 or ui.get_alpha() > 0);
            l_l_v1527_6_0 = v32.interp(l_l_v1527_6_0, v2349, 0.05);
            if l_l_v1527_6_0 <= 0 then
                return;
            else
                local v2350 = l_v1529_6:get_drag_position():clone();
                local v2351 = math.max(66, v2348);
                local v2352 = vector(75 + v2351, 20);
                if l_l_v1528_5_0 == nil then
                    l_l_v1528_5_0 = v2352.x;
                end;
                l_l_v1528_5_0 = v32.interp(l_l_v1528_5_0, v2352.x, 0.033);
                v2352.x = math.floor(l_l_v1528_5_0);
                l_v1372_6(v2350, v2350 + v2352, l_v892_9.color:get(), l_l_v1527_6_0);
                l_play_0.text(v2343, v2350 + v2352 / 2 - vector(0, 1), color(255, 255 * l_l_v1527_6_0), v2344, v2345);
                local v2353 = 0;
                v2350.y = v2350.y + 3;
                for _, v2355 in pairs(v2346) do
                    local l_name_2 = v2355.name;
                    local l_avatar_0 = v2355.avatar;
                    local v2358 = color(255, 255, 255, 255);
                    local v2359 = l_l_v1527_6_0 * v2355.alpha;
                    v2358.a = v2358.a * v2359;
                    local v2360 = vector(v2355.name_height, v2355.name_height);
                    local v2361 = vector(v2350.x + 5, v2350.y + v2352.y);
                    local v2362 = vector(v2350.x + v2352.x - 5 - v2360.x, v2350.y + v2352.y);
                    l_play_0.text(v2343, v2361, v2358, "", l_name_2);
                    if l_avatar_0 ~= nil then
                        l_play_0.texture(l_avatar_0, v2362, v2360, v2358);
                    end;
                    v2353 = math.max(v2353, v2359);
                    v2352.y = v2352.y + v12(15 * v2359);
                end;
                v2352.y = v2352.y + v12(3 * v2353);
                l_v1529_6.size = v2352;
                l_v1529_6();
                return;
            end;
        end;
    end;
    l_v1526_4 = {};
    l_v1527_6 = {};
    l_v1528_5 = 0;
    v1529 = nil;
    v1530 = nil;
    v1531 = vector(400, 200);
    v1532 = vector(120, 20);
    v1533 = l_play_0.screen_size();
    v1530 = v141.new("hotkey_list", v1531, v1532, {
        border = {
            vector(0, 0),
            v1533:clone()
        }
    });
    do
        local l_l_v1527_6_1, l_l_v1528_5_1, l_v1529_7, l_v1530_6, l_v1531_6, l_v1532_5, l_v1533_2, l_v1534_2 = l_v1527_6, l_v1528_5, v1529, v1530, v1531, v1532, v1533, v1534;
        l_v1530_6.update = function()
            -- upvalues: l_l_v1528_5_1 (ref)
            return l_l_v1528_5_1;
        end;
        l_v1531_6 = function()
            -- upvalues: l_v892_9 (ref)
            return l_v892_9.enabled:get() and l_v892_9.select:get("Hotkey List");
        end;
        l_v1532_5 = function(v2371, v2372)
            if next(v2372) == nil then
                v2372 = v2371:get();
                if next(v2372) == nil then
                    v2372 = v2371:list();
                end;
            end;
            local v2373 = {};
            for v2374 = 1, #v2372 do
                v2373[#v2373 + 1] = v2372[v2374]:sub(1, 1);
            end;
            return table.concat(v2373, ", ");
        end;
        l_v1533_2 = function(v2375, v2376, v2377)
            -- upvalues: l_v892_9 (ref), l_v1532_5 (ref)
            if type(v2377) == "boolean" or l_v892_9.only_key_state:get() then
                if v2376 == 1 then
                    return "Holding";
                elseif v2376 == 2 then
                    return "Toggled";
                else
                    return "Enabled";
                end;
            elseif type(v2377) == "table" then
                return l_v1532_5(v2375, v2377);
            else
                return tostring(v2377);
            end;
        end;
        l_v1534_2 = function(v2378, v2379)
            -- upvalues: l_v1533_2 (ref), l_l_v1527_6_1 (ref), l_play_0 (ref), v32 (ref)
            local v2380 = {};
            local v2381 = false;
            local v2382 = 0;
            local v2383 = 0;
            for _, v2385 in pairs(ui.get_binds()) do
                local v2386 = v2385.reference:id();
                local v2387 = string.format("[%s]", string.lower(l_v1533_2(v2385.reference, v2385.mode, v2385.value)));
                local l_name_3 = v2385.name;
                if v2385.active then
                    v2381 = true;
                    v2380[v2386] = v2385;
                end;
                l_l_v1527_6_1[v2386] = l_l_v1527_6_1[v2386] or {
                    value_width = 0,
                    height = 0,
                    name_width = 0,
                    alpha = 0,
                    name = l_name_3,
                    mode = v2385.mode,
                    value = v2385.value,
                    reference = v2385.reference
                };
                local v2389 = l_l_v1527_6_1[v2386];
                local v2390 = l_play_0.measure_text(v2378, v2379, l_name_3);
                local v2391 = l_play_0.measure_text(v2378, v2379, v2387);
                v2389.name = l_name_3;
                v2389.value = v2387;
                v2389.mode = v2385.mode;
                v2389.reference = v2385.reference;
                v2389.height = math.max(v2390.y, v2391.y);
                v2389.name_width = v2390.x;
                v2389.value_width = v2391.x;
            end;
            for v2392, v2393 in pairs(l_l_v1527_6_1) do
                local v2394 = v2380[v2392] ~= nil;
                v2393.alpha = v32.interp(v2393.alpha, v2394, 0.05);
                if v2393.alpha <= 0.01 then
                    l_l_v1527_6_1[v2392] = nil;
                elseif v2393.alpha > 0 or v2394 then
                    if v2382 < v2393.name_width then
                        v2382 = v2393.name_width;
                    end;
                    if v2383 < v2393.value_width then
                        v2383 = v2393.value_width;
                    end;
                end;
            end;
            return l_l_v1527_6_1, v2381, v2382, v2383;
        end;
        l_v1526_4.draw = function()
            -- upvalues: l_v1534_2 (ref), l_v1531_6 (ref), l_l_v1528_5_1 (ref), v32 (ref), l_v1530_6 (ref), l_v1529_7 (ref), l_v1372_6 (ref), l_v892_9 (ref), l_play_0 (ref), v12 (ref)
            local v2395 = 1;
            local v2396 = "c";
            local v2397 = "keybinds";
            local v2398, v2399, v2400 = l_v1534_2(v2395, v2396);
            local v2401 = l_v1531_6() and (v2399 or ui.get_alpha() > 0);
            l_l_v1528_5_1 = v32.interp(l_l_v1528_5_1, v2401, 0.033);
            if l_l_v1528_5_1 <= 0 then
                return;
            else
                local v2402 = l_v1530_6:get_drag_position():clone();
                local v2403 = math.max(66, v2400);
                local v2404 = vector(75 + v2403, 20);
                if l_v1529_7 == nil then
                    l_v1529_7 = v2404.x;
                end;
                l_v1529_7 = v32.interp(l_v1529_7, v2404.x, 0.035);
                v2404.x = math.floor(l_v1529_7);
                l_v1372_6(v2402, v2402 + v2404, l_v892_9.color:get(), l_l_v1528_5_1);
                l_play_0.text(v2395, v2402 + v2404 / 2 - vector(0, 1), color(255, 255 * l_l_v1528_5_1), v2396, v2397);
                local v2405 = 0;
                v2402.y = v2402.y + 3;
                for _, v2407 in pairs(v2398) do
                    local l_v2407_0 = v2407;
                    local l_name_4 = l_v2407_0.name;
                    local l_value_0 = l_v2407_0.value;
                    local v2411 = color(255, 255, 255, 255);
                    local v2412 = l_v2407_0.alpha * l_l_v1528_5_1;
                    v2411.a = v2411.a * v2412;
                    local v2413 = vector(v2402.x + 5, v2402.y + v2404.y);
                    local v2414 = vector(v2402.x + v2404.x - 5, v2402.y + v2404.y);
                    l_play_0.text(v2395, v2413, v2411, "", l_name_4);
                    l_play_0.text(v2395, v2414, v2411, "r", l_value_0);
                    v2405 = math.max(v2405, l_v2407_0.alpha);
                    v2404.y = v2404.y + v12(15 * l_v2407_0.alpha);
                end;
                v2404.y = v2404.y + v12(3 * v2405);
                l_v1530_6.size = v2404;
                l_v1530_6();
                return;
            end;
        end;
    end;
    l_v1527_6 = {};
    l_v1528_5 = 0;
    v1529 = 0;
    v1530 = 0;
    v1531 = v982(0, 2);
    v1532 = v982(0, 3);
    v1533 = 0;
    v1534 = 0;
    v1535 = 0;
    v1536 = 0;
    v1537 = 0;
    v1538 = 0;
    v1539 = vector();
    v1540 = false;
    v1541 = false;
    v1542 = function()
        -- upvalues: l_v892_9 (ref)
        return l_v892_9.enabled:get() and l_v892_9.select:get("Anti-aimbot indication");
    end;
    v1543 = function()
        local v2415 = rage.antiaim:get_max_desync();
        local v2416 = rage.antiaim:get_rotation(false);
        local v2417 = rage.antiaim:get_rotation(true);
        local v2418 = math.normalize_yaw(v2417 - v2416);
        return math.clamp(v2418, -v2415, v2415);
    end;
    do
        local l_l_v1528_5_2, l_v1529_8, l_v1530_7, l_v1531_7, l_v1532_6, l_v1533_3, l_v1534_3, l_v1535_1, l_v1536_1, l_v1537_2, l_v1538_0, l_v1539_1, l_v1540_0, l_v1541_1, l_v1542_1, l_v1543_1, l_v1544_1, l_v1545_1 = l_v1528_5, v1529, v1530, v1531, v1532, v1533, v1534, v1535, v1536, v1537, v1538, v1539, v1540, v1541, v1542, v1543, v1544, v1545;
        l_v1544_1 = function()
            -- upvalues: l_v1536_1 (ref)
            local l_l_v1536_1_0 = l_v1536_1;
            if tonumber(l_l_v1536_1_0) < 10 then
                l_l_v1536_1_0 = "  " .. l_l_v1536_1_0;
            end;
            return string.format("FL: %s", l_l_v1536_1_0);
        end;
        l_v1545_1 = function()
            -- upvalues: l_v1540_0 (ref), l_v1530_7 (ref), v32 (ref), l_v1529_8 (ref), l_v1541_1 (ref)
            if l_v1540_0 then
                l_v1530_7 = v32.interp(l_v1530_7, false, 0.05);
                local v2438 = l_v1530_7 <= 0.01;
                l_v1529_8 = v32.interp(l_v1529_8, v2438, 0.05);
                return;
            elseif l_v1541_1 then
                l_v1529_8 = v32.interp(l_v1529_8, false, 0.05);
                local v2439 = l_v1529_8 <= 0.01;
                l_v1530_7 = v32.interp(l_v1530_7, v2439, 0.05);
                return;
            else
                l_v1529_8 = v32.interp(l_v1529_8, false, 0.05);
                l_v1530_7 = v32.interp(l_v1530_7, false, 0.05);
                return;
            end;
        end;
        v1547 = function(v2440)
            -- upvalues: l_v1539_1 (ref), l_v1538_0 (ref), l_v992_8 (ref), l_v1532_6 (ref), l_v1531_7 (ref), l_v1543_1 (ref), l_v1536_1 (ref), l_v1537_2 (ref), l_v1540_0 (ref), l_v1541_1 (ref), l_v1368_6 (ref)
            local v2441 = entity.get_local_player();
            if v2441 == nil then
                return;
            else
                if v2440.choked_commands == 0 then
                    local l_m_vecOrigin_1 = v2441.m_vecOrigin;
                    if l_v1539_1 ~= nil then
                        l_v1538_0 = (l_m_vecOrigin_1 - l_v1539_1):length2dsqr();
                        l_v992_8(l_v1532_6, l_v1538_0, true);
                    end;
                    l_v992_8(l_v1531_7, math.abs(l_v1543_1()), true);
                    l_v1536_1 = l_v1537_2;
                    l_v1539_1 = l_m_vecOrigin_1;
                end;
                l_v1540_0 = rage.exploit:get() == 1;
                l_v1541_1 = l_v1368_6(l_v1532_6) > 3200;
                l_v1537_2 = v2440.choked_commands;
                return;
            end;
        end;
        l_v1527_6.draw = function(v2443)
            -- upvalues: l_v1542_1 (ref), l_l_v1528_5_2 (ref), v32 (ref), l_v1545_1 (ref), l_v892_9 (ref), l_v1544_1 (ref), l_v1368_6 (ref), l_v1532_6 (ref), l_v1538_0 (ref), l_v1534_3 (ref), l_v1535_1 (ref), l_v1533_3 (ref), l_v1541_1 (ref), l_play_0 (ref), l_v1529_8 (ref), l_v1530_7 (ref), l_v1372_6 (ref), l_v1531_7 (ref)
            local v2444 = v2443:clone();
            local v2445 = entity.get_local_player();
            local v2446 = l_v1542_1() and v2445 ~= nil and v2445:is_alive();
            l_l_v1528_5_2 = v32.interp(l_l_v1528_5_2, v2446, 0.05);
            l_v1545_1();
            if l_l_v1528_5_2 <= 0 then
                return;
            else
                local v2447 = 1;
                local v2448 = "";
                local v2449 = l_v892_9.color:get();
                local v2450 = l_v1544_1();
                local v2451 = globals.frametime * 3.75;
                local v2452 = 1200 + math.max(0, l_v1368_6(l_v1532_6) - 3800);
                local v2453 = math.abs(math.min(l_v1538_0 - 3800, v2452) / v2452 * 100);
                if l_v1534_3 ~= v2453 and l_v1535_1 < globals.realtime then
                    l_v1535_1 = globals.realtime + 0.005;
                    l_v1534_3 = l_v1534_3 + (v2453 < l_v1534_3 and -1 or 1);
                end;
                l_v1533_3 = l_v1533_3 + (l_v1541_1 and v2451 or -v2451);
                l_v1533_3 = l_v1533_3 > 1 and 1 or l_v1533_3;
                l_v1533_3 = l_v1533_3 < 0 and 0 or l_v1533_3;
                local v2454 = " | SHIFTING";
                local v2455 = l_play_0.measure_text(v2447, v2448, v2454);
                local v2456 = " | dst: " .. string.rep(" ", 10);
                local v2457 = l_play_0.measure_text(v2447, v2448, v2456);
                local v2458 = l_play_0.measure_text(v2447, v2448, v2450);
                local v2459 = color(255, 255, 255, 255);
                local v2460 = vector(v2458.x + 8, 17);
                v2460.x = v2460.x + v2455.x * l_v1529_8;
                v2460.x = v2460.x + v2457.x * l_v1530_7;
                v2444.x = v2444.x - v2460.x;
                v2459.a = v2459.a * l_l_v1528_5_2;
                local v2461 = vector(v2444.x + 4, v2444.y + 2);
                l_v1372_6(v2444, v2444 + v2460, l_v892_9.color:get(), l_l_v1528_5_2);
                l_play_0.text(v2447, v2461, v2459, v2448, v2450);
                v2461.x = v2461.x + v2458.x;
                if l_v1529_8 > 0 then
                    local v2462 = v2459:clone();
                    v2462.a = v2462.a * math.map(l_v1529_8, 0.9, 1, 0, 1);
                    l_play_0.text(v2447, v2461, v2462, v2448, v2454);
                end;
                if l_v1530_7 > 0 then
                    local v2463 = v2459:clone();
                    local v2464 = math.map(l_v1530_7, 0.9, 1, 0, 1);
                    v2463.a = v2463.a * v2464;
                    local v2465 = l_play_0.measure_text(v2447, v2448, " | dst: ");
                    local v2466 = vector(v2461.x + v2465.x + 2, v2461.y + 4);
                    local v2467 = v2466 + vector(math.min(100, l_v1534_3) / 100 * 24, 5);
                    local v2468 = v2449:clone();
                    local v2469 = v2449:clone();
                    v2468.a = 220 * l_v1533_3 * v2464 * l_l_v1528_5_2;
                    v2469.a = 25 * l_v1533_3 * v2464 * l_l_v1528_5_2;
                    l_play_0.text(v2447, v2461, v2463, v2448, v2456);
                    l_play_0.gradient(v2466, v2467, v2468, v2469, v2468, v2469);
                end;
                local v2470 = string.format("FAKE (%.1f\194\176)", l_v1368_6(l_v1531_7));
                local v2471 = l_play_0.measure_text(v2447, v2448, v2470);
                local v2472 = vector(v2471.x + 8, 18);
                v2444.x = v2444.x - v2472.x - 4;
                l_v1372_6(v2444, v2444 + v2472, l_v892_9.color:get(), l_l_v1528_5_2);
                l_play_0.text(v2447, v2444 + vector(4, 2), v2459, v2448, v2470);
                v2443.y = v2443.y + (v2472.y + 10) * l_l_v1528_5_2;
                return;
            end;
        end;
        events.createmove(v1547);
    end;
    l_v1528_5 = {};
    v1529 = v1369();
    v1530 = function(v2473)
        if v2473 < 1 then
            return ("%.2f"):format(v2473);
        elseif v2473 < 10 then
            return ("%.1f"):format(v2473);
        else
            return ("%d"):format(v2473);
        end;
    end;
    pcall(ffi.cdef, "                bool EnumDisplaySettingsA(\n                    unsigned int  lpszDeviceName,\n                    unsigned long iModeNum,\n                    void*         lpDevMode\n                );\n            ");
    v1532 = ffi.typeof("                struct {\n                    char pad_0[120];\n                    unsigned long dmDisplayFrequency;\n                    char pad_1[32];\n                }\n            ")();
    ffi.C.EnumDisplaySettingsA(0, -1, v1532);
    v1533 = 0;
    v1534 = common.get_timestamp();
    v1535 = v982(0, 90);
    v1536 = v982(0, 30);
    v1537 = 0;
    v1538 = 0;
    v1539 = function()
        -- upvalues: l_v892_9 (ref)
        return l_v892_9.enabled:get() and l_v892_9.select:get("Frequency update information");
    end;
    do
        local l_v1529_9, l_v1530_8, l_v1532_7, l_v1533_4, l_v1534_4, l_v1535_2, l_v1536_2, l_v1537_3, l_v1538_1, l_v1539_2, l_v1540_1 = v1529, v1530, v1532, v1533, v1534, v1535, v1536, v1537, v1538, v1539, v1540;
        l_v1540_1 = function()
            -- upvalues: l_v1537_3 (ref), l_v992_8 (ref), l_v1536_2 (ref), l_v1538_1 (ref)
            l_v1537_3 = 0.9 * l_v1537_3 + 0.09999999999999998 * globals.absoluteframetime;
            l_v992_8(l_v1536_2, math.abs(l_v1538_1 - 1 / l_v1537_3), true);
            l_v1538_1 = 1 / l_v1537_3;
        end;
        v1541 = function()
            -- upvalues: l_v1534_4 (ref)
            l_v1534_4 = common.get_timestamp();
        end;
        v1542 = function()
            -- upvalues: l_v1534_4 (ref), l_v992_8 (ref), l_v1535_2 (ref)
            local v2485 = common.get_timestamp() - l_v1534_4;
            l_v992_8(l_v1535_2, v2485);
        end;
        l_v1528_5.draw = function(v2486)
            -- upvalues: l_v1540_1 (ref), l_v1539_2 (ref), l_v1533_4 (ref), v32 (ref), l_v892_9 (ref), l_v1368_6 (ref), l_v1535_2 (ref), l_v1532_7 (ref), l_v1530_8 (ref), l_play_0 (ref), l_v1372_6 (ref), l_v1536_2 (ref), l_v1529_9 (ref)
            l_v1540_1();
            local v2487 = v2486:clone();
            local v2488 = l_v1539_2();
            l_v1533_4 = v32.interp(l_v1533_4, v2488, 0.05);
            if l_v1533_4 <= 0 then
                return;
            else
                local v2489 = 1;
                local v2490 = "";
                local v2491 = l_v892_9.color:get();
                local v2492 = l_v1368_6(l_v1535_2);
                local v2493 = tonumber(l_v1532_7.dmDisplayFrequency);
                local v2494 = string.format("%sms / %dhz", l_v1530_8(v2492), v2493);
                local v2495 = l_play_0.measure_text(v2489, v2490, v2494);
                local v2496 = color(255, 255, 255, 255);
                local v2497 = vector(v2495.x + 8, 18);
                v2487.x = v2487.x - v2497.x;
                v2496.a = v2496.a * l_v1533_4;
                l_v1372_6(v2487, v2487 + v2497, l_v892_9.color:get(), l_v1533_4);
                l_play_0.text(v2489, vector(v2487.x + 4, v2487.y + 2), v2496, v2490, v2494);
                local v2498 = "IO | ";
                local v2499 = l_play_0.measure_text(v2489, v2490, v2498);
                local v2500 = v2498 .. "       ";
                local v2501 = l_play_0.measure_text(v2489, v2490, v2500);
                local v2502 = v2499.x + 4;
                local v2503 = vector(v2501.x + 8, 18);
                local v2504 = {
                    [1] = nil,
                    [2] = 1,
                    [3] = 3,
                    [4] = nil,
                    [5] = 0,
                    [1] = v2492,
                    [4] = l_v1368_6(l_v1536_2) / 4
                };
                local _ = math.min(unpack(v2504));
                local v2506 = math.max(unpack(v2504));
                v2487.x = v2487.x - v2503.x;
                local v2507 = vector(v2487.x - 4, v2487.y);
                l_v1372_6(v2507, v2507 + v2503, l_v892_9.color:get(), l_v1533_4);
                l_play_0.text(v2489, v2487 + vector(0, 2), v2496, v2490, v2500);
                l_v1529_9:draw_histogram(v2504, 0, v2506, #v2504, {
                    draw_bar = "gradient_fadein",
                    draw_peeks = false,
                    thickness = 1,
                    x = v2487.x - 4 + v2502,
                    y = v2487.y + 4,
                    w = v2503.x - v2502 - 4,
                    h = v2503.y - 8,
                    clr_1 = v2491:alpha_modulate(255 * l_v1533_4),
                    clr_2 = color(0, 127, 255, 255 * l_v1533_4)
                }, false);
                return;
            end;
        end;
        events.pre_render(v1541);
        events.post_render(v1542);
    end;
    v1529 = function()
        -- upvalues: l_play_0 (ref), l_v1373_6 (ref), l_v1525_6 (ref), l_v1526_4 (ref), l_v1527_6 (ref), l_v1528_5 (ref)
        local v2508 = l_play_0.screen_size();
        local v2509 = vector(v2508.x - 10, 10);
        l_v1373_6.draw(v2509);
        l_v1525_6.draw();
        l_v1526_4.draw();
        l_v1527_6.draw(v2509);
        l_v1528_5.draw(v2509);
    end;
    events.render(v1529);
end;
v892 = nil;
l_match_0 = v384.visuals.watermark;
l_angles_0 = {};
v982 = string.format("%s\a%%s.PINK", string.upper(v13.name));
v992 = string.format("VICTIM - %s [\a%%s%s\a%%s]", string.upper(v13.user), string.upper(v13.build));
do
    local l_l_match_0_9, l_l_angles_0_8, l_v982_8, l_v992_9 = l_match_0, l_angles_0, v982, v992;
    do
        local l_l_v982_8_0, l_l_v992_9_0 = l_v982_8, l_v992_9;
        l_l_angles_0_8.on_render = function()
            -- upvalues: l_l_match_0_9 (ref), l_play_0 (ref), l_l_v982_8_0 (ref), l_l_v992_9_0 (ref), v257 (ref)
            local v2516 = l_l_match_0_9.color:get():alpha_modulate(255);
            local v2517 = color();
            local v2518 = v2516:to_hex();
            local v2519 = v2517:to_hex();
            local v2520 = l_play_0.screen_size();
            local v2521 = 2;
            local v2522 = "";
            local v2523 = {
                string.format(l_l_v982_8_0, v2518),
                string.format(l_l_v992_9_0, v2518, v2519)
            };
            local v2524 = vector(8, v2520.y / 2);
            if v257.eva_small ~= nil then
                local v2525 = vector(35, 35);
                local v2526 = color(255, 255, 255);
                l_play_0.texture(v257.eva_small, v2524, v2525, v2526, "f");
                v2524.x = v2524.x + v2525.x - 4;
                v2524.y = v2524.y + v2525.y + 1;
            end;
            local v2527 = l_play_0.measure_text(v2521, v2522, v2523[1]);
            local v2528 = l_play_0.measure_text(v2521, v2522, v2523[2]);
            v2527.y = v2527.y - 2;
            v2528.y = v2528.y - 2;
            v2524.y = v2524.y - v2528.y;
            l_play_0.text(v2521, v2524, v2517, v2522, v2523[2]);
            v2524.y = v2524.y - (v2527.y - 2);
            l_play_0.text(v2521, v2524, v2517, v2522, v2523[1]);
        end;
    end;
    l_v982_8 = {};
    l_v992_9 = 1;
    v1368 = 3;
    v1369 = 3;
    v1370 = 34;
    l_aimtools_0 = 5;
    v1372 = utils.get_vfunc("steamclient.dll", "SteamClient017", 2, "int(__thiscall*)(void*, int)");
    v1373 = utils.get_vfunc("steamclient.dll", "SteamClient017", 8, "int*(__thiscall*)(void*, int, int, const char*)");
    v1525 = utils.get_vfunc("steamclient.dll", "SteamClient017", 9, "int*(__thiscall*)(void*, int, const char*)");
    v1526 = utils.get_vfunc(35, "int(__thiscall*)(void*, uint64_t)");
    v1527 = utils.get_vfunc(5, "bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)");
    v1528 = utils.get_vfunc(6, "bool(__thiscall*)(void*, int, unsigned char*, int)");
    v1530 = v1373(v1372(l_v992_9), l_v992_9, "SteamFriends015");
    v1531 = v1525(l_v992_9, "SteamUtils009");
    v1532 = string.format("\a%%s%s\a%%s.pink", string.lower(v13.name));
    v1533 = string.format("build: \a%%s%s", string.lower(v13.build));
    v1534 = string.format("user: \a%%s%s", v13.user);
    do
        local l_v1368_7, l_v1369_7, l_v1370_7, l_l_aimtools_0_8, l_v1526_5, l_v1527_7, l_v1528_6, l_v1530_9, l_v1531_8, l_v1532_8, l_v1533_5, l_v1534_5, l_v1537_4 = v1368, v1369, v1370, l_aimtools_0, v1526, v1527, v1528, v1530, v1531, v1532, v1533, v1534, v1537;
        l_v1537_4 = (function(v2542)
            -- upvalues: l_v1526_5 (ref), l_v1530_9 (ref), l_v1527_7 (ref), l_v1531_8 (ref), l_v1528_6 (ref), l_play_0 (ref)
            local v2543 = l_v1526_5(l_v1530_9, v2542);
            if v2543 <= 0 then
                return nil;
            else
                local v2544 = ffi.new("unsigned int[?]", 1);
                local v2545 = ffi.new("unsigned int[?]", 1);
                if not l_v1527_7(l_v1531_8, v2543, v2544, v2545) then
                    return nil;
                else
                    local v2546 = v2544[0] * v2545[0] * 4;
                    local v2547 = ffi.new("unsigned char[?]", v2546);
                    if not l_v1528_6(l_v1531_8, v2543, v2547, v2546) then
                        return nil;
                    else
                        local v2548 = ffi.string(v2547, v2546);
                        local v2549 = vector(v2544[0], v2545[0]);
                        return l_play_0.load_image_rgba(v2548, v2549), v2549;
                    end;
                end;
            end;
        end)((function()
            local l_MyPersonaAPI_0 = panorama.MyPersonaAPI;
            if l_MyPersonaAPI_0 == nil then
                return 0ULL;
            else
                local v2551 = l_MyPersonaAPI_0.GetXuid();
                return 76500000000000000ULL + tonumber(v2551:sub(4, -1));
            end;
        end)());
        l_v982_8.on_render = function()
            -- upvalues: l_v1537_4 (ref), l_l_match_0_9 (ref), l_play_0 (ref), l_v1532_8 (ref), l_v1533_5 (ref), l_v1534_5 (ref), l_v1368_7 (ref), l_v1369_7 (ref), l_v1370_7 (ref), l_l_aimtools_0_8 (ref)
            if l_v1537_4 == nil then
                return;
            else
                local v2552 = l_l_match_0_9.color:get():alpha_modulate(255);
                local v2553 = color();
                local v2554 = v2552:to_hex();
                local v2555 = v2553:to_hex();
                local v2556 = l_play_0.screen_size();
                local v2557 = vector(v2556.x, 0);
                local v2558 = 4;
                local v2559 = "";
                local v2560 = string.format(l_v1532_8, v2554, v2555);
                local v2561 = 1;
                local v2562 = "";
                local v2563 = string.format(l_v1533_5, v2554);
                local v2564 = 1;
                local v2565 = "";
                local v2566 = string.format(l_v1534_5, v2554);
                local v2567 = l_play_0.measure_text(v2558, v2559, v2560);
                local v2568 = l_play_0.measure_text(v2561, v2562, v2563);
                local v2569 = l_play_0.measure_text(v2564, v2565, v2566);
                local v2570 = vector(l_v1368_7, l_v1369_7) * 2 + vector(math.max(v2567.x, v2568.x, v2569.x) + l_v1370_7 + l_l_aimtools_0_8, math.max(v2567.y + v2568.y + v2569.y, l_v1370_7));
                local v2571 = v2570 + vector(10, 0);
                local v2572 = v2557 + vector(-(l_v1368_7 + l_v1370_7), (v2570.y - l_v1370_7) / 2);
                local v2573 = v2557 + vector(-v2571.x, 0);
                l_play_0.gradient(v2573, v2573 + v2571, v2552:alpha_modulate(0), v2552:alpha_modulate(220), v2552:alpha_modulate(0), v2552:alpha_modulate(220));
                l_play_0.texture(l_v1537_4, v2572, vector(l_v1370_7, l_v1370_7), color(), "f");
                local v2574 = v2557 + vector(-v2570.x + l_v1368_7, l_v1369_7);
                l_play_0.text(v2558, v2574, v2553, v2559, v2560);
                v2574.y = v2574.y + v2567.y;
                l_play_0.text(v2561, v2574, v2553, v2562, v2563);
                v2574.y = v2574.y + v2568.y;
                l_play_0.text(v2564, v2574, v2553, v2565, v2566);
                v2574.y = v2574.y + v2569.y;
                return;
            end;
        end;
    end;
    l_v992_9 = function(v2575)
        -- upvalues: l_l_angles_0_8 (ref), l_v982_8 (ref)
        if v2575 == nil then
            v2575 = {};
        end;
        events.render(l_l_angles_0_8.on_render, v2575.branded == true);
        events.render(l_v982_8.on_render, v2575.corner == true);
    end;
    v1368 = nil;
    v1369 = function(v2576)
        -- upvalues: l_v992_9 (ref)
        l_v992_9({
            branded = v2576:get("Branded"),
            corner = v2576:get("Corner")
        });
    end;
    do
        local l_v1369_8 = v1369;
        v1370 = function(v2578)
            -- upvalues: l_v992_9 (ref), l_l_match_0_9 (ref), l_v1369_8 (ref)
            local v2579 = v2578:get();
            if not v2579 then
                l_v992_9(nil);
            end;
            if v2579 then
                l_l_match_0_9.style:set_callback(l_v1369_8, true);
            else
                l_l_match_0_9.style:unset_callback(l_v1369_8);
            end;
        end;
        l_l_match_0_9.enabled:set_callback(v1370, true);
    end;
end;
l_match_0 = nil;
l_angles_0 = v384.visuals.manual_arrows;
v982 = v384.antiaim.settings.manual_yaw;
v992 = l_play_0.load_font("C:\\Windows\\Fonts\\verdana.ttf", vector(16, 16.5, 0), "a");
v1368 = l_play_0.load_font("C:\\Windows\\Fonts\\calibrib.ttf", vector(25, 23.5, 0), "a");
v1369 = 0;
v1370 = 0;
l_aimtools_0 = function(v2580, v2581, v2582)
    return v2580 + v2581 * vector():angles(vector(0, v2582, 0));
end;
do
    local l_l_angles_0_9, l_v982_9, l_v992_10, l_v1368_8, l_v1369_9, l_v1370_8, l_l_aimtools_0_9, l_v1372_7, l_v1373_7, l_v1525_7, l_v1526_6 = l_angles_0, v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526;
    l_v1372_7 = function()
        -- upvalues: l_l_angles_0_9 (ref), l_play_0 (ref), l_l_aimtools_0_9 (ref)
        if not l_l_angles_0_9.dynamic_mode:get() then
            return 0;
        else
            local v2594 = l_l_angles_0_9.style:get();
            if v2594 ~= 1 and v2594 ~= 4 then
                return 0;
            else
                local v2595 = entity.get_local_player();
                local v2596 = entity.get_threat();
                if v2595 == nil or v2596 == nil then
                    return 0;
                else
                    local v2597 = l_play_0.camera_angles();
                    local l_m_angEyeAngles_0 = v2596.m_angEyeAngles;
                    local v2599 = v2595:get_origin();
                    local v2600 = v2596:get_origin();
                    local v2601 = l_l_aimtools_0_9(v2599, 50, v2597.y + 110);
                    local v2602 = l_l_aimtools_0_9(v2599, 30, v2597.y + 60);
                    local v2603 = l_l_aimtools_0_9(v2599, 50, v2597.y - 110);
                    local v2604 = l_l_aimtools_0_9(v2599, 30, v2597.y - 60);
                    local v2605 = l_l_aimtools_0_9(v2600, 40, l_m_angEyeAngles_0.y + 115);
                    local v2606 = l_l_aimtools_0_9(v2600, 20, l_m_angEyeAngles_0.y + 35);
                    local v2607 = l_l_aimtools_0_9(v2600, 40, l_m_angEyeAngles_0.y - 115);
                    local v2608 = l_l_aimtools_0_9(v2600, 20, l_m_angEyeAngles_0.y - 35);
                    local v2609 = utils.trace_bullet(v2596, vector(v2605.x, v2605.y, v2605.z + 70), v2601);
                    local v2610 = utils.trace_bullet(v2596, vector(v2606.x, v2606.y, v2606.z + 30), v2602);
                    local v2611 = utils.trace_bullet(v2596, vector(v2607.x, v2607.y, v2607.z + 70), v2603);
                    local v2612 = utils.trace_bullet(v2596, vector(v2608.x, v2608.y, v2608.z + 30), v2604);
                    local v2613 = 0;
                    if v2609 == 0 then
                        if v2612 > 0 then
                            v2613 = 2;
                        elseif v2611 > 0 then
                            v2613 = 1;
                        end;
                    end;
                    if v2611 == 0 then
                        if v2610 > 0 then
                            v2613 = -2;
                        elseif v2609 > 0 then
                            v2613 = -1;
                        end;
                    end;
                    return v2613;
                end;
            end;
        end;
    end;
    l_v1373_7 = function()
        -- upvalues: l_v982_9 (ref)
        return l_v982_9.select:get();
    end;
    l_v1525_7 = function()
        -- upvalues: l_v1370_8 (ref), l_v1372_7 (ref)
        l_v1370_8 = l_v1372_7();
    end;
    l_v1526_6 = function()
        -- upvalues: l_l_angles_0_9 (ref), l_v1373_7 (ref), l_v1370_8 (ref), l_play_0 (ref), l_v1369_9 (ref), v32 (ref), l_v1368_8 (ref), v12 (ref), l_v992_10 (ref)
        local v2614 = entity.get_local_player();
        if v2614 == nil or not v2614:is_alive() then
            return;
        else
            local v2615 = l_l_angles_0_9.style:get();
            local v2616 = l_l_angles_0_9.offset:get();
            local v2617 = l_l_angles_0_9.accent_color:get();
            local v2618 = l_l_angles_0_9.secondary_color:get();
            local v2619 = l_v1373_7();
            local v2620 = rage.antiaim:inverter();
            local v2621 = v2619 == "Left" or l_v1370_8 < 0;
            local v2622 = v2619 == "Right" or l_v1370_8 > 0;
            local l_m_bIsScoped_2 = v2614.m_bIsScoped;
            local v2624 = l_play_0.screen_size();
            local v2625, v2626 = vector(v2624.x / 2, v2624.y / 2):unpack();
            local v2627 = v2619 ~= nil and v2619 ~= "Off";
            l_v1369_9 = v32.interp(l_v1369_9, l_m_bIsScoped_2 and l_l_angles_0_9.animate_scope:get(), 0.05);
            if v2627 or l_v1370_8 ~= 0 then
                if v2615 == 1 then
                    local l_l_v1368_8_0 = l_v1368_8;
                    local v2629 = "+";
                    local v2630 = l_v1370_8 == -2 and "<<" or "<";
                    local v2631 = l_v1370_8 == 2 and ">>" or ">";
                    local v2632 = l_play_0.measure_text(l_l_v1368_8_0, v2629, v2630);
                    local v2633 = l_play_0.measure_text(l_l_v1368_8_0, v2629, v2631);
                    local v2634 = v2621 and v2617 or v2618;
                    local v2635 = v2622 and v2617 or v2618;
                    local v2636 = vector(v2625 - v2616, v2626 + 1 - v2632.y * 0.5);
                    local v2637 = vector(v2625 + v2616, v2626 + 1 - v2633.y * 0.5);
                    v2636.x = v2636.x - v2632.x;
                    l_play_0.text(l_l_v1368_8_0, v2636, v2634, v2629, v2630);
                    l_play_0.text(l_l_v1368_8_0, v2637, v2635, v2629, v2631);
                end;
                if v2615 == 3 then
                    local l_l_v1368_8_1 = l_v1368_8;
                    local v2639 = "+";
                    local v2640 = "\239\132\132";
                    local v2641 = "\239\132\133";
                    local v2642 = l_play_0.measure_text(l_l_v1368_8_1, v2639, v2640);
                    local v2643 = l_play_0.measure_text(l_l_v1368_8_1, v2639, v2641);
                    local v2644 = v2621 and v2617 or v2618;
                    local v2645 = v2622 and v2617 or v2618;
                    local v2646 = v12(20 * l_v1369_9);
                    local v2647 = v12(20 * l_v1369_9);
                    v2644.a = v2644.a - v2644.a * (0.4 * l_v1369_9);
                    v2645.a = v2645.a - v2645.a * (0.4 * l_v1369_9);
                    local v2648 = vector(v2625 - v2616 - v2646, v2626 - v2642.y * 0.4);
                    local v2649 = vector(v2625 + v2616 + v2647, v2626 - v2643.y * 0.4);
                    v2648.x = v2648.x - v2642.x;
                    l_play_0.text(l_l_v1368_8_1, v2648, v2644, v2639, v2640);
                    l_play_0.text(l_l_v1368_8_1, v2649, v2645, v2639, v2641);
                end;
                if v2615 == 4 then
                    local l_l_v992_10_0 = l_v992_10;
                    local v2651 = "";
                    local v2652 = l_v1370_8 == -2 and "\226\157\174\226\157\174" or "\226\157\174";
                    local v2653 = l_v1370_8 == 2 and "\226\157\175\226\157\175" or "\226\157\175";
                    local v2654 = l_play_0.measure_text(l_l_v992_10_0, v2651, v2652);
                    local v2655 = l_play_0.measure_text(l_l_v992_10_0, v2651, v2653);
                    local v2656 = v2621 and v2617 or v2618;
                    local v2657 = v2622 and v2617 or v2618;
                    local v2658 = vector(v2625 - v2616, v2626 - v2654.y * 0.5);
                    local v2659 = vector(v2625 + v2616, v2626 - v2655.y * 0.5);
                    v2658.x = v2658.x - v2654.x;
                    l_play_0.text(l_l_v992_10_0, v2658, v2656, v2651, v2652);
                    l_play_0.text(l_l_v992_10_0, v2659, v2657, v2651, v2653);
                end;
            end;
            if v2615 == 2 then
                local v2660 = 2;
                local v2661 = 13;
                local v2662 = 9;
                local v2663 = color(35, 35, 35, 150);
                local v2664 = v2621 and v2617 or v2663;
                local v2665 = v2622 and v2617 or v2663;
                local v2666 = v2620 == true and v2618 or v2663;
                local v2667 = v2620 == false and v2618 or v2663;
                local v2668 = v2625 - v2616 - v2661;
                local v2669 = v2625 + v2616 + v2661;
                local v2670 = vector(v2668 + v2660 + 2, v2626 - v2662);
                local v2671 = vector(v2669 - v2660 - 2, v2626 - v2662);
                local v2672 = vector(-v2660, v2662 * 2);
                local v2673 = vector(v2660, v2662 * 2);
                l_play_0.poly(v2664, vector(v2668 + 1 - v2661, v2626), vector(v2668 + 1, v2626 - v2662), vector(v2668 + 1, v2626 + v2662));
                l_play_0.poly(v2665, vector(v2669 + v2661, v2626), vector(v2669, v2626 - v2662), vector(v2669, v2626 + v2662));
                l_play_0.rect(v2670, v2670 + v2672, v2666);
                l_play_0.rect(v2671, v2671 + v2673, v2667);
            end;
            return;
        end;
    end;
    v1527 = nil;
    v1528 = function(v2674)
        -- upvalues: l_v1526_6 (ref), l_v1525_7 (ref)
        local v2675 = v2674:get();
        events.render(l_v1526_6, v2675);
        events.createmove(l_v1525_7, v2675);
    end;
    l_l_angles_0_9.enabled:set_callback(v1528, true);
end;
l_angles_0 = nil;
v982 = v384.visuals.custom_scope;
v992 = 9.25925925925926E-4;
v1368 = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay");
v1369 = 0;
do
    local l_v982_10, l_v992_11, l_v1368_9, l_v1369_10, l_v1370_9, l_l_aimtools_0_10, l_v1372_8 = v982, v992, v1368, v1369, v1370, l_aimtools_0, v1372;
    l_v1370_9 = function()
        -- upvalues: l_v1369_10 (ref), v32 (ref), l_play_0 (ref), l_v982_10 (ref), l_v992_11 (ref), v12 (ref)
        local v2683 = entity.get_local_player();
        if v2683 == nil or not v2683:is_alive() then
            return;
        else
            local v2684 = v2683:get_player_weapon();
            if v2684 == nil then
                return;
            else
                l_v1369_10 = v32.interp(l_v1369_10, v2683.m_bIsScoped, 0.05);
                if l_v1369_10 == 0 then
                    return;
                else
                    local v2685 = l_play_0.screen_size();
                    local v2686 = v2685 * 0.5;
                    local v2687 = l_v982_10.accent_color:get();
                    local v2688 = l_v982_10.secondary_color:get();
                    local v2689 = l_v982_10.offset:get() * v2685.y * l_v992_11;
                    local v2690 = l_v982_10.position:get() * v2685.y * l_v992_11;
                    local v2691 = l_v982_10.thickness:get();
                    local v2692 = l_v982_10.extra_options:get("Rotate Angle");
                    if l_v982_10.extra_options:get("Dynamic Offset") then
                        local v2693 = v2684:get_spread();
                        local v2694 = (v2684:get_inaccuracy() + v2693) * 360;
                        v2689 = v2689 + v2694;
                        v2690 = v2690 + v2694;
                    end;
                    v2689 = v12(v2689);
                    v2690 = v12(v2690);
                    v2687.a = v2687.a * l_v1369_10;
                    v2688.a = v2688.a * l_v1369_10;
                    if v2692 then
                        l_play_0.push_rotation(45);
                    end;
                    if not l_v982_10.exclude_lines:get("Top") then
                        local v2695 = vector(v2686.x + 0.5 - v2691 * 0.5, v2686.y - v2689 + 1);
                        local v2696 = vector(v2686.x + 0.5 + v2691 * 0.5, v2686.y - v2690 + 1);
                        l_play_0.gradient(v2695, v2696, v2687, v2687, v2688, v2688);
                    end;
                    if not l_v982_10.exclude_lines:get("Bottom") then
                        local v2697 = vector(v2686.x + 0.5 - v2691 * 0.5, v2686.y + v2689);
                        local v2698 = vector(v2686.x + 0.5 + v2691 * 0.5, v2686.y + v2690);
                        l_play_0.gradient(v2697, v2698, v2687, v2687, v2688, v2688);
                    end;
                    if not l_v982_10.exclude_lines:get("Left") then
                        local v2699 = vector(v2686.x - v2689 + 1, v2686.y + 0.5 - v2691 * 0.5);
                        local v2700 = vector(v2686.x - v2690 + 1, v2686.y + 0.5 + v2691 * 0.5);
                        l_play_0.gradient(v2699, v2700, v2687, v2688, v2687, v2688);
                    end;
                    if not l_v982_10.exclude_lines:get("Right") then
                        local v2701 = vector(v2686.x + v2689, v2686.y + 0.5 - v2691 * 0.5);
                        local v2702 = vector(v2686.x + v2690, v2686.y + 0.5 + v2691 * 0.5);
                        l_play_0.gradient(v2701, v2702, v2687, v2688, v2687, v2688);
                    end;
                    if v2692 then
                        l_play_0.pop_rotation();
                    end;
                    return;
                end;
            end;
        end;
    end;
    l_l_aimtools_0_10 = function()
        -- upvalues: l_v1368_9 (ref)
        l_v1368_9:override();
    end;
    l_v1372_8 = function(v2703)
        -- upvalues: l_v1368_9 (ref), l_v1370_9 (ref), l_l_aimtools_0_10 (ref)
        if not v2703 then
            l_v1368_9:override();
        end;
        events.render(l_v1370_9, v2703);
        events.shutdown(l_l_aimtools_0_10, v2703);
    end;
    v1373 = nil;
    v1525 = function(v2704)
        -- upvalues: l_v1368_9 (ref), l_v1372_8 (ref)
        local v2705 = v2704:get();
        if v2705 then
            l_v1368_9:override("Remove All");
        end;
        l_v1372_8(v2705);
    end;
    l_v982_10.enabled:set_callback(v1525, true);
end;
v982 = nil;
v992 = v384.visuals.damage_indicator;
v1368 = {
    Alternative = 2,
    Default = 1
};
v1369 = function()
    -- upvalues: v26 (ref)
    local v2706 = v26.ragebot.selection.min_damage:get();
    if v2706 == 0 then
        return "A";
    elseif v2706 > 100 then
        return string.format("+%d", v2706 - 100);
    else
        return v2706;
    end;
end;
do
    local l_v992_12, l_v1368_10, l_v1369_11, l_v1370_10, l_l_aimtools_0_11 = v992, v1368, v1369, v1370, l_aimtools_0;
    l_v1370_10 = function()
        -- upvalues: v767 (ref), v26 (ref), l_v992_12 (ref), l_play_0 (ref), l_v1368_10 (ref), l_v1369_11 (ref)
        local v2712 = entity.get_local_player();
        if v2712 == nil or not v2712:is_alive() then
            return;
        else
            local v2713 = v767.get(v26.ragebot.selection.min_damage);
            if (v2713 == nil or not v2713.active) and l_v992_12.if_override:get() then
                return;
            else
                local v2714 = v2713 ~= nil and v2713.active and l_v992_12.active_color:get() or l_v992_12.inactive_color:get();
                local v2715 = (l_play_0.screen_size() / 2):clone();
                local v2716 = l_v1368_10[l_v992_12.font:get()];
                if v2716 == nil then
                    return;
                else
                    local v2717 = l_v992_12.offset:get();
                    local v2718 = "";
                    local v2719 = l_v1369_11();
                    local v2720 = l_play_0.measure_text(v2716, v2718, v2719);
                    v2715.x = v2715.x + v2717 + 2;
                    v2715.y = v2715.y - v2717;
                    v2715.y = v2715.y - v2720.y;
                    l_play_0.text(v2716, v2715, v2714, v2718, v2719);
                    return;
                end;
            end;
        end;
    end;
    l_l_aimtools_0_11 = function(v2721)
        -- upvalues: l_v1370_10 (ref)
        events.render(l_v1370_10, v2721);
    end;
    v1372 = nil;
    v1373 = function(v2722)
        -- upvalues: l_l_aimtools_0_11 (ref)
        l_l_aimtools_0_11(v2722:get());
    end;
    l_v992_12.enabled:set_callback(v1373, true);
end;
v992 = nil;
v1368 = v384.visuals.break_lc_indicator;
v1369 = l_play_0.load_font("Calibri", 11, "ad");
v1370 = 0;
l_aimtools_0 = 0;
v1372 = "lc status";
v1373 = color();
v1525 = 0;
v1526 = 0;
v1527 = 0;
v1528 = false;
v1529 = nil;
v1530 = l_play_0.screen_size();
v1531 = vector(60, 30);
v1532 = vector((v1530.x - v1531.x) / 2, v1530.y * 0.3475);
v1529 = v141.new("lc_indicator", v1532, v1531, {
    rulers = {
        [1] = {
            [1] = true,
            [2] = vector(v1530.x / 2, 0),
            [3] = v1530.y
        }
    },
    border = {
        vector(v1530.x * 0.5, 0),
        vector(v1530.x * 0.5, v1530.y)
    }
});
v1530 = function()
    -- upvalues: v384 (ref), v394 (ref), v844 (ref)
    if not v384.antiaim.enabled:get() then
        return not v394.is_onground;
    else
        local v2723 = entity.get_local_player();
        if v2723 == nil then
            return;
        else
            local v2724 = v2723:get_player_weapon();
            if v2724 == nil then
                return;
            else
                local v2725 = v2724:get_weapon_info();
                if v2725 == nil then
                    return;
                else
                    local l_weapon_type_3 = v2725.weapon_type;
                    local v2727 = v2724:get_weapon_index();
                    local v2728 = l_weapon_type_3 == 9;
                    local v2729 = v2727 == 64;
                    if v2728 or v2729 then
                        return false;
                    else
                        local v2730 = v844.builder:get_old_items();
                        if v2730 == nil then
                            return false;
                        else
                            local l_defensive_2 = v2730.defensive;
                            if l_defensive_2 == nil then
                                return false;
                            else
                                return l_defensive_2.force_break_lc:get();
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
v1531 = function(v2732)
    if v2732 <= 0 then
        return "failed", color(255, 64, 64);
    elseif v2732 <= 3 then
        return "bad", color(255, 175, 104);
    elseif v2732 <= 6 then
        return "ok", color(255, 255, 255);
    elseif v2732 <= 9 then
        return "good", color(205, 236, 142);
    elseif v2732 <= 11 then
        return "nice", color(122, 241, 182);
    elseif v2732 <= 12 then
        return "ideal lc", color(101, 213, 255);
    else
        return "angel lc", color(207, 145, 255);
    end;
end;
do
    local l_v1369_12, l_v1370_11, l_l_aimtools_0_12, l_v1372_9, l_v1373_8, l_v1525_8, l_v1526_7, l_v1527_8, l_v1528_7, l_v1529_10, l_v1530_10, l_v1531_9, l_v1532_9, l_v1533_6, l_v1534_6 = v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529, v1530, v1531, v1532, v1533, v1534;
    l_v1532_9 = function()
        -- upvalues: l_v1529_10 (ref), l_l_aimtools_0_12 (ref), l_v1372_9 (ref), l_v1525_8 (ref), l_v1373_8 (ref), l_v1370_11 (ref), l_play_0 (ref), l_v1369_12 (ref)
        local v2748 = l_v1529_10:get_drag_position() + l_v1529_10:get_drag_size() / 2;
        local v2749 = ui.get_alpha();
        if v2749 > 0 then
            l_l_aimtools_0_12 = 1;
        end;
        if l_l_aimtools_0_12 <= 0 then
            return;
        else
            local v2750 = "";
            local l_l_v1372_9_0 = l_v1372_9;
            local v2752 = l_v1525_8 .. "t";
            local v2753 = l_v1373_8:clone();
            local v2754 = color(255, 255, 255, 128);
            if l_v1370_11 == 0 and v2749 > 0 then
                l_l_v1372_9_0 = "lc status";
                v2753 = color();
            end;
            v2754.a = v2754.a * l_l_aimtools_0_12;
            v2753.a = v2753.a * l_l_aimtools_0_12;
            local v2755 = l_play_0.measure_text(l_v1369_12, v2750, l_l_v1372_9_0);
            local v2756 = l_play_0.measure_text(l_v1369_12, v2750, v2752);
            v2748.y = v2748.y - (v2755.y + v2756.y + 1) / 2;
            local v2757 = v2748 + vector(-v2755.x * 0.5, 0);
            local v2758 = v2748 + vector(-v2756.x * 0.5, 0);
            v2758.y = v2758.y + (v2755.y + 1);
            l_play_0.text(l_v1369_12, v2757, v2753, v2750, l_l_v1372_9_0);
            l_play_0.text(l_v1369_12, v2758, v2754, v2750, v2752);
            l_v1370_11 = math.max(0, l_v1370_11 - globals.frametime);
            if l_v1370_11 == 0 then
                l_l_aimtools_0_12 = math.max(0, l_l_aimtools_0_12 - globals.frametime * 8);
            end;
            l_v1529_10();
            return;
        end;
    end;
    l_v1533_6 = function()
        -- upvalues: l_v1526_7 (ref), l_v1528_7 (ref), l_v1530_10 (ref), l_v1527_8 (ref), l_v1531_9 (ref), l_v1370_11 (ref), l_l_aimtools_0_12 (ref), l_v1373_8 (ref), l_v1372_9 (ref), l_v1525_8 (ref), v395 (ref)
        local v2759 = rage.exploit:get();
        local v2760 = v2759 - l_v1526_7;
        if v2760 > 0 then
            l_v1528_7 = true;
        end;
        if l_v1528_7 and v2760 < 0 then
            l_v1528_7 = false;
            if l_v1530_10() or l_v1527_8 > 0 then
                local v2761, v2762 = l_v1531_9(l_v1527_8);
                l_v1370_11 = 0.66;
                l_l_aimtools_0_12 = 1;
                l_v1373_8 = v2762;
                l_v1372_9 = v2761;
                l_v1525_8 = l_v1527_8;
            end;
        end;
        l_v1526_7 = v2759;
        l_v1527_8 = v395.defensive_ticks;
    end;
    l_v1534_6 = function(v2763)
        -- upvalues: l_v1532_9 (ref), l_v1533_6 (ref)
        events.render(l_v1532_9, v2763);
        events.createmove(l_v1533_6, v2763);
    end;
    v1535 = nil;
    v1536 = function(v2764)
        -- upvalues: l_v1534_6 (ref)
        l_v1534_6(v2764:get());
    end;
    v1368.enabled:set_callback(v1536, true);
end;
v1368 = nil;
v1369 = v384.visuals.velocity_warning;
v1370 = 0;
l_aimtools_0 = nil;
v1372 = l_play_0.screen_size();
v1373 = vector(130, 12);
v1525 = vector((v1372.x - v1373.x) / 2, v1372.y * 0.285);
l_aimtools_0 = v141.new("velocity_warning", v1525, v1373, {
    rulers = {
        [1] = {
            [1] = true,
            [2] = vector(v1372.x / 2, 0),
            [3] = v1372.y
        }
    },
    border = {
        vector(v1372.x * 0.5, 0),
        vector(v1372.x * 0.5, v1372.y)
    }
});
do
    local l_v1369_13, l_v1370_12, l_l_aimtools_0_13, l_v1372_10, l_v1373_9 = v1369, v1370, l_aimtools_0, v1372, v1373;
    l_v1372_10 = function()
        -- upvalues: l_l_aimtools_0_13 (ref), l_v1369_13 (ref), l_v1370_12 (ref), v32 (ref), v149 (ref), l_play_0 (ref)
        local v2770 = entity.get_local_player();
        if v2770 == nil then
            return;
        else
            local v2771 = l_l_aimtools_0_13:get_drag_position():clone();
            local v2772 = l_l_aimtools_0_13:get_drag_size();
            local v2773 = -globals.realtime;
            local v2774 = v2770:is_alive();
            local v2775 = ui.get_alpha() > 0;
            local v2776 = l_v1369_13.color_accent:get();
            local v2777 = l_v1369_13.color_secondary:get();
            local l_m_flVelocityModifier_0 = v2770.m_flVelocityModifier;
            if not v2774 then
                l_m_flVelocityModifier_0 = 1;
            end;
            local v2779 = v2775 or v2774 and l_m_flVelocityModifier_0 < 1;
            l_v1370_12 = v32.interp(l_v1370_12, v2779, 0.05);
            if l_v1370_12 > 0 then
                v2776.a = v2776.a * l_v1370_12;
                v2777.a = v2777.a * l_v1370_12;
                local v2780 = v149.gradient(string.format("%d%%", l_m_flVelocityModifier_0 * 100), v2773, v2776, v2777);
                local v2781 = 1;
                local v2782 = "";
                local v2783 = string.format("velocity inflicted ~ %s", v2780);
                local v2784 = l_play_0.measure_text(v2781, v2782, v2783);
                v2771.x = v2771.x + (v2772.x - v2784.x) / 2 + 1;
                l_play_0.text(v2781, v2771, v2776, v2782, v2783);
            end;
            l_l_aimtools_0_13();
            return;
        end;
    end;
    l_v1373_9 = function(v2785)
        -- upvalues: l_v1372_10 (ref)
        events.render(l_v1372_10, v2785);
    end;
    v1525 = nil;
    v1526 = function(v2786)
        -- upvalues: l_v1373_9 (ref)
        l_v1373_9(v2786:get());
    end;
    l_v1369_13.enabled:set_callback(v1526, true);
end;
v1369 = nil;
v1370 = v384.visuals.grenade_radius;
l_aimtools_0 = cvar.mp_friendlyfire;
v1372 = {};
v1373 = {};
do
    local l_v1370_13, l_l_aimtools_0_14, l_v1372_11, l_v1373_10, l_v1525_9, l_v1526_8, l_v1527_9, l_v1528_8, l_v1529_11 = v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529;
    l_v1525_9 = function(v2796)
        -- upvalues: l_l_aimtools_0_14 (ref)
        if l_l_aimtools_0_14:int() == 1 then
            return false;
        else
            local v2797 = entity.get_local_player();
            local l_m_hOwnerEntity_0 = v2796.m_hOwnerEntity;
            if l_m_hOwnerEntity_0 == nil or not l_m_hOwnerEntity_0:is_player() then
                return false;
            elseif v2797 == l_m_hOwnerEntity_0 or l_m_hOwnerEntity_0:is_enemy() then
                return false;
            else
                return true;
            end;
        end;
    end;
    l_v1526_8 = function(v2799)
        for v2800 in pairs(v2799) do
            v2799[v2800] = nil;
        end;
    end;
    l_v1527_9 = function()
        -- upvalues: l_v1372_11 (ref)
        local v2801 = entity.get_entities("CSmokeGrenadeProjectile");
        local v2802 = {};
        for v2803 = 1, #v2801 do
            local v2804 = v2801[v2803];
            if v2804.m_bDidSmokeEffect then
                local v2805 = v2804:get_index();
                if l_v1372_11[v2805] == nil then
                    local v2806 = v2804:get_origin();
                    l_v1372_11[v2805] = {
                        alpha = 0,
                        radius = 125,
                        index = v2805,
                        origin = v2806
                    };
                end;
                v2802[v2805] = true;
            end;
        end;
        for v2807 in pairs(l_v1372_11) do
            if v2802[v2807] == nil then
                l_v1372_11[v2807] = nil;
            end;
        end;
    end;
    l_v1528_8 = function()
        -- upvalues: l_v1373_10 (ref), l_v1525_9 (ref)
        local v2808 = entity.get_entities("CInferno");
        local v2809 = {};
        for v2810 = 1, #v2808 do
            local v2811 = v2808[v2810];
            local l_m_fireCount_0 = v2811.m_fireCount;
            if l_m_fireCount_0 ~= 0 then
                local v2813 = v2811:get_index();
                if l_v1373_10[v2813] == nil then
                    local v2814 = v2811:get_origin();
                    local v2815 = l_v1525_9(v2811);
                    l_v1373_10[v2813] = {
                        fire_count = 0,
                        alpha = 0,
                        radius = 0,
                        index = v2813,
                        origin = v2814,
                        friendly = v2815
                    };
                end;
                local v2816 = l_v1373_10[v2813];
                if v2816.fire_count < l_m_fireCount_0 then
                    v2816.fire_count = l_m_fireCount_0;
                    local v2817 = 0;
                    local v2818 = nil;
                    local v2819 = nil;
                    local v2820 = {};
                    local v2821 = 0;
                    local _ = v2811:get_origin();
                    for v2823 = 0, l_m_fireCount_0 - 1 do
                        if v2811.m_bFireIsBurning[v2823] then
                            local v2824 = vector(v2811.m_fireXDelta[v2823], v2811.m_fireYDelta[v2823], v2811.m_fireZDelta[v2823]);
                            v2821 = v2821 + 1;
                            v2820[v2821] = v2824;
                        end;
                    end;
                    for v2825 = 1, v2821 do
                        for v2826 = 1, v2821 do
                            local v2827 = v2820[v2825];
                            local v2828 = v2820[v2826];
                            local v2829 = (v2828 - v2827):lengthsqr();
                            if v2817 < v2829 then
                                v2817 = v2829;
                                v2818 = v2827;
                                v2819 = v2828;
                            end;
                        end;
                    end;
                    if v2818 ~= nil and v2819 ~= nil then
                        v2816.radius = math.sqrt(v2817) / 2 + 40;
                    end;
                end;
                v2809[v2813] = true;
            end;
        end;
        for v2830 in pairs(l_v1373_10) do
            if v2809[v2830] == nil then
                l_v1373_10[v2830] = nil;
            end;
        end;
    end;
    l_v1529_11 = function()
        -- upvalues: l_v1370_13 (ref), l_v1372_11 (ref), l_play_0 (ref), l_v1373_10 (ref)
        local l_frametime_2 = globals.frametime;
        local v2832 = l_v1370_13.smoke_color:get();
        local v2833 = l_v1370_13.molotov_color:get();
        for _, v2835 in pairs(l_v1372_11) do
            v2835.alpha = math.min(v2835.alpha + l_frametime_2 * 4, 1);
            local v2836 = v2835.radius * v2835.alpha;
            l_play_0.circle_3d_outline(v2835.origin, v2832, v2836, 0, 1, 1);
        end;
        for _, v2838 in pairs(l_v1373_10) do
            v2838.alpha = math.min(v2838.alpha + l_frametime_2 * 4, 1);
            local v2839 = v2838.radius * v2838.alpha;
            l_play_0.circle_3d_outline(v2838.origin, v2833, v2839, 0, 1, 1);
            local v2840 = l_play_0.world_to_screen(v2838.origin);
            if v2840 ~= nil then
                if v2838.teammate then
                    l_play_0.text(1, v2840, color(149, 184, 6, 255), "c", "\226\156\148");
                else
                    l_play_0.text(1, v2840, color(230, 21, 21, 255), "c", "\226\157\140");
                end;
            end;
        end;
    end;
    v1530 = nil;
    v1531 = function(v2841)
        -- upvalues: l_v1526_8 (ref), l_v1372_11 (ref), l_v1527_9 (ref)
        local v2842 = v2841:get();
        if not v2842 then
            l_v1526_8(l_v1372_11);
        end;
        events.net_update_start(l_v1527_9, v2842);
    end;
    v1532 = function(v2843)
        -- upvalues: l_v1526_8 (ref), l_v1373_10 (ref), l_v1528_8 (ref)
        local v2844 = v2843:get();
        if not v2844 then
            l_v1526_8(l_v1373_10);
        end;
        events.net_update_start(l_v1528_8, v2844);
    end;
    do
        local l_v1531_10, l_v1532_10 = v1531, v1532;
        v1533 = function(v2847)
            -- upvalues: l_v1526_8 (ref), l_v1372_11 (ref), l_v1373_10 (ref), l_v1527_9 (ref), l_v1528_8 (ref), l_v1370_13 (ref), l_v1531_10 (ref), l_v1532_10 (ref), l_v1529_11 (ref)
            local v2848 = v2847:get();
            if not v2848 then
                l_v1526_8(l_v1372_11);
                l_v1526_8(l_v1373_10);
                events.net_update_start(l_v1527_9, false);
                events.net_update_start(l_v1528_8, false);
            end;
            if v2848 then
                l_v1370_13.smoke:set_callback(l_v1531_10, true);
                l_v1370_13.molotov:set_callback(l_v1532_10, true);
            else
                l_v1370_13.smoke:unset_callback(l_v1531_10);
                l_v1370_13.molotov:unset_callback(l_v1532_10);
            end;
            events.render(l_v1529_11, v2848);
        end;
        l_v1370_13.enabled:set_callback(v1533, true);
    end;
end;
v1370 = nil;
l_aimtools_0 = v384.visuals.gamesense_indicators;
v1372 = 380;
v1373 = 8;
v1525 = 24;
v1526 = 4;
v1527 = 3;
v1528 = l_play_0.load_font("C:\\Windows\\Fonts\\calibrib.ttf", vector(25, 23.5, 0), "a");
v1529 = {};
v1529.__index = v1529;
v1529.new = function(v2849, v2850, v2851)
    return setmetatable({
        id = v2850,
        size = v2851
    }, v2849);
end;
v1529.draw = function(v2852, v2853, v2854, ...)
    -- upvalues: l_play_0 (ref)
    l_play_0.texture(v2852.id, v2853, v2852.size, v2854, ...);
end;
v1531 = {
    bomb_c4 = v1529:new(({
        bomb_c4 = l_play_0.load_image_from_file("materials\\panorama\\images\\icons\\ui\\bomb_c4.svg", vector(32, 32))
    }).bomb_c4, vector(32, 29))
};
v1532 = {};
v1533 = 100;
v1534 = 0;
v1535 = 0;
v1536 = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot");
v1537 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
v1538 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
v1539 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim");
v1540 = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points");
v1541 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
v1542 = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance");
v1543 = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes");
v1544 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
v1545 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding");
v1547 = ui.find("Miscellaneous", "Main", "Other", "Fake Latency");
local l_feature_list_0 = l_aimtools_0.feature_list;
local function v2858(v2856)
    local v2857 = v2856:get_override();
    if v2857 ~= nil then
        return v2857;
    else
        return v2856:get();
    end;
end;
local function v2861(v2859)
    -- upvalues: v767 (ref)
    local v2860 = v767.get(v2859);
    return v2860 ~= nil and v2860.active;
end;
do
    local l_l_aimtools_0_15, l_v1372_12, l_v1373_11, l_v1525_10, l_v1526_9, l_v1527_10, l_v1528_9, l_v1531_11, l_v1532_11, l_v1533_7, l_v1534_7, l_v1535_3, l_v1536_3, l_v1537_5, l_v1538_2, l_v1539_3, l_v1540_2, l_v1541_2, l_v1542_2, l_v1543_2, l_v1544_2, l_v1545_2, l_v1547_1, l_l_feature_list_0_0, l_v2858_0, l_v2861_0 = l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1531, v1532, v1533, v1534, v1535, v1536, v1537, v1538, v1539, v1540, v1541, v1542, v1543, v1544, v1545, v1547, l_feature_list_0, v2858, v2861;
    local function v2889()
        -- upvalues: l_v1532_11 (ref)
        for v2888 = 1, #l_v1532_11 do
            l_v1532_11[v2888] = nil;
        end;
    end;
    local function v2894(v2890)
        -- upvalues: l_play_0 (ref), l_v1528_9 (ref), l_v1526_9 (ref), l_v1532_11 (ref), l_v1372_12 (ref), l_v1373_11 (ref)
        local v2891 = l_play_0.measure_text(l_v1528_9, nil, v2890.text);
        local v2892 = l_play_0.screen_size();
        v2891.y = v2891.y + l_v1526_9 * 2;
        local v2893 = next(l_v1532_11) == nil and v2892.y - (v2892.y - l_v1372_12) / 2 or l_v1532_11[#l_v1532_11].offset - l_v1373_11 - v2891.y;
        v2890.offset = v2893;
        v2890.text_size = v2891;
        table.insert(l_v1532_11, v2890);
        return v2893;
    end;
    local function v2897(v2895, v2896, ...)
        -- upvalues: v2894 (ref)
        v2896 = table.concat({
            v2896,
            ...
        });
        return v2894({
            text = v2896,
            color = v2895
        });
    end;
    local function v2903(v2898, v2899)
        local v2900 = 0.5;
        local v2901 = 0.5;
        if v2899 > 0 then
            local v2902 = v2898 * v2900;
            if v2899 < (v2898 - v2902) * v2901 then
                v2902 = v2898 - v2899 * (1 / v2901);
            end;
            v2898 = v2902;
        end;
        return v2898;
    end;
    local function v2912(v2904, v2905)
        -- upvalues: v2903 (ref)
        local v2906 = 1;
        local v2907 = 500;
        local v2908 = v2907 * 3.5;
        local v2909 = (v2905:get_origin() - v2904:get_eye_position()):length();
        local v2910 = v2908 / 3;
        local v2911 = v2907 * math.exp(-v2909 * v2909 / (2 * v2910 * v2910)) * v2906;
        return v2903(v2911, v2904.m_ArmorValue);
    end;
    local function v2941(_)
        -- upvalues: l_v2861_0 (ref), l_v1541_2 (ref), l_v1542_2 (ref), l_v1543_2 (ref), l_v1547_1 (ref), l_v2858_0 (ref), l_v1544_2 (ref), l_v1545_2 (ref), l_v1539_3 (ref), l_v1540_2 (ref), l_v1537_5 (ref), l_v1538_2 (ref), l_v1536_3 (ref), l_l_feature_list_0_0 (ref), v2897 (ref), v394 (ref), v395 (ref), l_v1533_7 (ref)
        local v2914 = l_v2861_0(l_v1541_2);
        local v2915 = l_v2861_0(l_v1542_2);
        local v2916 = l_v2861_0(l_v1543_2);
        local v2917 = l_v1547_1:get() > 0;
        local v2918 = l_v2858_0(l_v1544_2);
        local v2919 = l_v2858_0(l_v1545_2);
        local v2920 = l_v2858_0(l_v1539_3) == "Force";
        local v2921 = l_v2858_0(l_v1540_2) == "Force";
        local v2922 = l_v2858_0(l_v1537_5) and not v2918;
        local v2923 = l_v2858_0(l_v1538_2) and not v2918 and not v2922;
        local v2924 = l_v2858_0(l_v1536_3);
        if v2917 and l_l_feature_list_0_0:get("Fake Latency") then
            local v2925 = utils.net_channel();
            if v2925 ~= nil then
                local v2926 = nil;
                local v2927 = l_v2858_0(l_v1547_1);
                local v2928 = math.clamp(v2925.latency[0] + v2925.latency[1], 0.001, 0.2);
                local v2929 = math.clamp(v2927 * 0.001 + v2925.avg_latency[1], 0.001, 0.2);
                local v2930 = math.clamp(v2928 / v2929, 0, 1);
                if v2930 < 0.5 then
                    v2926 = color(250, 234, 232, 255):lerp(color(213, 197, 84, 255), v2930 * 2);
                else
                    v2926 = color(213, 197, 84, 255):lerp(color(143, 194, 21, 255), (v2930 - 0.5) * 2);
                end;
                v2897(v2926, "PING");
            end;
        end;
        if v2923 and l_l_feature_list_0_0:get("Hide Shots") then
            v2897(color(255, 255, 255, 200), "OSAA");
        end;
        if v2922 and l_l_feature_list_0_0:get("Double Tap") then
            local v2931 = color(255, 0, 50, 255);
            if rage.exploit:get() == 1 then
                v2931 = color(255, 255, 255, 200);
            end;
            v2897(v2931, "DT");
        end;
        if v2924 and l_l_feature_list_0_0:get("Dormant Aimbot") then
            v2897(color(255, 255, 255, 200), "DA");
        end;
        if v2918 and l_l_feature_list_0_0:get("Fake Duck") then
            v2897(color(255, 255, 255, 200), "DUCK");
        end;
        if v2921 and l_l_feature_list_0_0:get("Safe Points") then
            v2897(color(255, 255, 255, 200), "SAFE");
        end;
        if v2920 and l_l_feature_list_0_0:get("Body Aim") then
            v2897(color(255, 255, 255, 200), "BODY");
        end;
        if v2914 and l_l_feature_list_0_0:get("Damage Override") then
            v2897(color(255, 255, 255, 200), "MD");
        end;
        if v2915 and l_l_feature_list_0_0:get("Hitchance Override") then
            v2897(color(255, 255, 255, 200), "HITCHANCE OVR");
        end;
        if v2916 and l_l_feature_list_0_0:get("Hitbox Override") then
            v2897(color(255, 255, 255, 200), "HITBOX OVR");
        end;
        if v2919 and l_l_feature_list_0_0:get("Freestanding") then
            v2897(color(255, 255, 255, 200), "FS");
        end;
        if not v394.is_onground and l_l_feature_list_0_0:get("Lag Compensation") then
            local v2932 = 255;
            local v2933 = 0;
            local v2934 = 50;
            local v2935 = 255;
            if v395.defensive_ticks > 0 or v395.teleport_units_sqr > 4096 then
                local v2936 = 255;
                local v2937 = 255;
                local v2938 = 255;
                v2935 = 200;
                v2934 = v2938;
                v2933 = v2937;
                v2932 = v2936;
            end;
            v2897(color(v2932, v2933, v2934, v2935), "LC");
        end;
        if l_l_feature_list_0_0:get("Fake Angles") then
            local v2939 = rage.antiaim:get_max_desync();
            local v2940 = color(196, 15, 15):lerp(color(132, 196, 20), v2939 / 58);
            v2897(v2940, "FAKE");
        end;
        if l_l_feature_list_0_0:get("Hit/Miss") then
            v2897(color(255, 255, 255, 200), l_v1533_7 .. "%");
        end;
    end;
    local function v2951(v2942, v2943)
        -- upvalues: v2894 (ref), l_v1531_11 (ref)
        local v2944 = v2943:get_player_weapon();
        if v2944 == nil then
            return;
        elseif not v2944.m_bStartedArming then
            return;
        else
            local l_m_fArmedTime_0 = v2944.m_fArmedTime;
            if l_m_fArmedTime_0 == nil then
                return;
            else
                local v2946 = v2943:get_origin();
                local l_m_bombsiteCenterA_0 = v2942.m_bombsiteCenterA;
                local l_m_bombsiteCenterB_0 = v2942.m_bombsiteCenterB;
                local v2949 = v2946:distsqr(l_m_bombsiteCenterA_0) < v2946:distsqr(l_m_bombsiteCenterB_0) and "A" or "B";
                local v2950 = (l_m_fArmedTime_0 - globals.curtime) / 3;
                v2894({
                    text = v2949,
                    color = color(252, 243, 105, 255),
                    progress = 1 - v2950,
                    draw_cmd = l_v1531_11.bomb_c4
                });
                return;
            end;
        end;
    end;
    local function v2966(v2952, v2953)
        -- upvalues: l_play_0 (ref), v2894 (ref), l_v1531_11 (ref), v2912 (ref), v2897 (ref)
        local l_m_bBombDefused_0 = v2953.m_bBombDefused;
        if not v2953.m_bBombTicking or l_m_bBombDefused_0 then
            return;
        else
            local l_curtime_0 = globals.curtime;
            local l_m_flC4Blow_0 = v2953.m_flC4Blow;
            local v2957 = l_m_flC4Blow_0 - l_curtime_0;
            if v2957 > 0 then
                if v2953.m_hBombDefuser ~= nil then
                    local v2958 = l_play_0.screen_size();
                    local l_m_flDefuseCountDown_0 = v2953.m_flDefuseCountDown;
                    local v2960 = (l_m_flDefuseCountDown_0 - l_curtime_0) / 10;
                    local v2961 = l_m_flC4Blow_0 < l_m_flDefuseCountDown_0 and color(235, 50, 75, 125) or color(50, 235, 75, 125);
                    local v2962 = (v2958.y - 2) * (1 - v2960);
                    l_play_0.rect(vector(0, 0), vector(20, v2958.y), color(0, 0, 0, 115));
                    l_play_0.rect(vector(1, 1 + v2962), vector(19, v2958.y - 1), v2961);
                end;
                local v2963 = string.format("%s - %.1fs", v2953.m_nBombSite == 1 and "B" or "A", v2957);
                v2894({
                    text = v2963,
                    color = color(255, 255, 255, 200),
                    draw_cmd = l_v1531_11.bomb_c4
                });
            end;
            local l_m_iHealth_6 = v2952.m_iHealth;
            local v2965 = v2912(v2952, v2953);
            v2965 = math.floor(v2965);
            if l_m_iHealth_6 <= v2965 then
                v2897(color(255, 0, 50, 255), "FATAL");
            elseif v2965 > 0 then
                v2897(color(252, 243, 105, 255), string.format("-%d HP", v2965));
            end;
            return;
        end;
    end;
    local function v2974(v2967)
        -- upvalues: v2951 (ref), v2966 (ref)
        local v2968 = entity.get_game_rules();
        if v2968 == nil then
            return;
        else
            local v2969 = entity.get_player_resource();
            if v2969 == nil then
                return;
            else
                local l_m_bBombPlanted_0 = v2968.m_bBombPlanted;
                local l_m_iPlayerC4_0 = v2969.m_iPlayerC4;
                if l_m_iPlayerC4_0 ~= nil and l_m_iPlayerC4_0 ~= 0 then
                    local v2972 = entity.get(l_m_iPlayerC4_0);
                    if v2972 ~= nil then
                        v2951(v2969, v2972);
                    end;
                end;
                if l_m_bBombPlanted_0 then
                    local v2973 = entity.get_entities("CPlantedC4")[1];
                    if v2973 ~= nil then
                        v2966(v2967, v2973);
                    end;
                end;
                return;
            end;
        end;
    end;
    local function v2976()
        -- upvalues: v2941 (ref), l_l_feature_list_0_0 (ref), v2974 (ref)
        local v2975 = entity.get_local_player();
        if v2975 == nil then
            return;
        else
            if v2975:is_alive() then
                v2941(v2975);
            end;
            if l_l_feature_list_0_0:get("Bomb Info") then
                v2974(v2975);
            end;
            return;
        end;
    end;
    local function v2982(v2977, v2978)
        -- upvalues: l_play_0 (ref)
        local v2979 = (v2977 + v2978) / 2;
        local v2980 = color(0, 0, 0, 0);
        local v2981 = color(0, 0, 0, 50);
        l_play_0.gradient(v2977, vector(v2979.x, v2978.y), v2980, v2981, v2980, v2981);
        l_play_0.gradient(v2978, vector(v2979.x, v2977.y), v2980, v2981, v2980, v2981);
    end;
    local function v2989(v2983, v2984, v2985, v2986, v2987, v2988)
        -- upvalues: l_play_0 (ref)
        l_play_0.circle_outline(v2983, color(0, 0, 0, 255), v2985, v2986, 1, v2988);
        l_play_0.circle_outline(v2983, v2984, v2985 - 1, v2986, v2987, v2988 - 2);
    end;
    local function v3003()
        -- upvalues: l_v1532_11 (ref), l_v1527_10 (ref), l_v1525_10 (ref), l_v1526_9 (ref), v2982 (ref), l_play_0 (ref), l_v1528_9 (ref), v2989 (ref)
        for v2990 = 1, #l_v1532_11 do
            local v2991 = l_v1532_11[v2990];
            if v2991.color ~= nil then
                local v2992 = vector(l_v1527_10, v2991.offset);
                local v2993 = v2992 + vector(l_v1525_10, l_v1526_9);
                local v2994 = v2991.text_size + vector(50);
                local l_color_1 = v2991.color;
                local l_draw_cmd_0 = v2991.draw_cmd;
                local l_progress_0 = v2991.progress;
                v2993.y = v2993.y + 2;
                if l_draw_cmd_0 ~= nil then
                    v2994.x = v2994.x + l_draw_cmd_0.size.x + 5;
                end;
                if l_progress_0 ~= nil then
                    v2994.x = v2994.x + 30;
                end;
                v2982(v2992, v2992 + v2994);
                if l_draw_cmd_0 ~= nil then
                    local v2998 = v2992:clone();
                    v2998.x = v2998.x + l_v1525_10;
                    v2998.y = v2998.y + (v2994.y - l_draw_cmd_0.size.y) / 2;
                    l_draw_cmd_0:draw(v2998, l_color_1, "f");
                    v2993.x = v2993.x + l_draw_cmd_0.size.x + 5;
                end;
                l_play_0.text(l_v1528_9, v2993 + 1, color(0, 0, 0, 128), "", v2991.text);
                l_play_0.text(l_v1528_9, v2993, l_color_1, "", v2991.text);
                v2993.x = v2993.x + v2991.text_size.x;
                if l_progress_0 ~= nil then
                    local v2999 = v2993.x + 10 / 2 + 12;
                    local v3000 = v2992.y + v2994.y / 2;
                    local v3001 = vector(v2999, v3000);
                    local v3002 = color(255, 255, 255, 200);
                    v2989(v3001, v3002, 10, 0, l_progress_0, 5);
                end;
            end;
        end;
    end;
    local function v3011()
        -- upvalues: l_play_0 (ref)
        local v3004 = entity.get_local_player();
        if v3004 == nil then
            return;
        else
            local v3005 = v3004:get_spectators();
            if v3005 == nil then
                return;
            else
                local v3006 = l_play_0.screen_size();
                local v3007 = vector(v3006.x - 10, 5);
                for v3008 = 1, #v3005 do
                    local v3009 = v3005[v3008]:get_name();
                    local v3010 = color(255, 255, 255, 200);
                    l_play_0.text(1, v3007, v3010, "r", v3009);
                    v3007.y = v3007.y + 18;
                end;
                return;
            end;
        end;
    end;
    local function v3012()
        -- upvalues: v2976 (ref), v3003 (ref), v2889 (ref)
        if globals.is_in_game then
            v2976();
            v3003();
        end;
        v2889();
    end;
    local function v3014(v3013)
        -- upvalues: l_v1535_3 (ref), l_v1534_7 (ref), l_v1533_7 (ref)
        if v3013.state == "death" or not (v3013.state ~= "player death") or v3013.state == "unregistered shot" then
            return;
        else
            l_v1535_3 = l_v1535_3 + 1;
            if v3013.state == nil then
                l_v1534_7 = l_v1534_7 + 1;
            end;
            l_v1533_7 = math.floor(l_v1534_7 / math.max(1, l_v1535_3) * 100);
            return;
        end;
    end;
    local function v3016(v3015)
        -- upvalues: v3012 (ref), v3014 (ref)
        events.render(v3012, v3015);
        events.aim_ack(v3014, v3015);
    end;
    local _ = nil;
    local function v3019(v3018)
        -- upvalues: v3011 (ref)
        events.render(v3011, v3018:get());
    end;
    do
        local l_v3019_0 = v3019;
        local function v3023(v3021)
            -- upvalues: v3011 (ref), l_l_aimtools_0_15 (ref), l_v3019_0 (ref), v3016 (ref)
            local v3022 = v3021:get();
            if not v3022 then
                events.render(v3011, false);
            end;
            if v3022 then
                l_l_aimtools_0_15.spectator_list:set_callback(l_v3019_0, true);
            else
                l_l_aimtools_0_15.spectator_list:unset_callback(l_v3019_0);
            end;
            v3016(v3022);
        end;
        l_l_aimtools_0_15.enabled:set_callback(v3023, true);
    end;
end;
l_aimtools_0 = nil;
v1372 = v384.visuals.static_watermark;
v1373 = v384.visuals.watermark;
v1525 = v384.visuals.indicators;
v1526 = v384.visuals.solus_ui;
v1527 = {};
v1528 = 0;
do
    local l_v1528_10, l_v1529_12, l_v1530_11 = v1528, v1529, v1530;
    l_v1529_12 = function()
        -- upvalues: l_v1528_10 (ref)
        if l_v1528_10 <= 0 then
            return;
        else
            local v3027 = globals.frametime * 1.66;
            l_v1528_10 = math.max(0, l_v1528_10 - v3027);
            return;
        end;
    end;
    l_v1530_11 = function()
        -- upvalues: l_play_0 (ref), v13 (ref), l_v1528_10 (ref)
        local v3028 = l_play_0.screen_size();
        local v3029 = vector(v3028.x * 0.5, v3028.y - 18);
        local v3030 = 4;
        local v3031 = "";
        local l_name_5 = v13.name;
        local v3033 = l_play_0.measure_text(v3030, v3031, l_name_5);
        local v3034 = color(255, 255, 255, 255);
        v3029.x = v3029.x - v3033.x * 0.5;
        v3029.y = v3029.y - v3033.y;
        l_play_0.text(v3030, v3029, v3034, v3031, l_name_5);
        if l_v1528_10 > 0 then
            local v3035 = "";
            local v3036 = 5;
            local v3037 = "\194\168\203\156\226\128\157*\194\176\226\128\162";
            local v3038 = "\226\128\162\194\176*\226\128\157\203\156\194\168";
            local v3039 = l_play_0.measure_text(v3030, v3035, v3037);
            local v3040 = vector(v3029.x - v3039.x - v3036, v3029.y);
            local v3041 = vector(v3029.x + v3033.x + v3036, v3029.y);
            local v3042 = v3034:clone();
            v3042.a = v3042.a * l_v1528_10;
            l_play_0.text(v3030, v3040, v3042, v3035, v3037);
            l_play_0.text(v3030, v3041, v3042, v3035, v3038);
        end;
    end;
    v1527.on_render = function()
        -- upvalues: l_v1529_12 (ref), l_v1530_11 (ref)
        l_v1529_12();
        l_v1530_11();
    end;
    v1527.on_player_death = function(v3043)
        -- upvalues: l_v1528_10 (ref)
        local v3044 = entity.get_local_player();
        local v3045 = entity.get(v3043.userid, true);
        if entity.get(v3043.attacker, true) ~= v3044 or v3045 == v3044 then
            return;
        else
            l_v1528_10 = 1;
            return;
        end;
    end;
end;
v1528 = {};
v1529 = 4;
v1530 = function(v3046, v3047)
    return v3046:gsub(".", "%1" .. v3047, #v3046 - 1);
end;
do
    local l_v1372_13, l_v1373_12, l_v1525_11, l_v1526_10, l_v1527_11, l_v1528_11, l_v1529_13 = v1372, v1373, v1525, v1526, v1527, v1528, v1529;
    do
        local l_l_v1529_13_0, l_v1530_12, l_v1531_12, l_v1532_12 = l_v1529_13, v1530, v1531, v1532;
        l_v1531_12 = function()
            -- upvalues: l_v1372_13 (ref), l_v1530_12 (ref), v149 (ref)
            local v3059 = "";
            local v3060 = "ANGEL";
            local v3061 = "WINGS";
            if not l_v1372_13.remove_spaces:get() then
                v3059 = " ";
                v3060 = l_v1530_12(v3060, v3059);
                v3061 = l_v1530_12(v3061, v3059);
            end;
            return v3060 .. v3059 .. v149.gradient(v3061, -globals.realtime, color(255, 255, 255, 255), color(55, 55, 55, 255));
        end;
        l_v1532_12 = function()
            return string.format("[%s]", "DEBUG");
        end;
        l_v1528_11.on_render = function()
            -- upvalues: l_play_0 (ref), l_v1372_13 (ref), l_v1531_12 (ref), l_v1532_12 (ref), l_l_v1529_13_0 (ref)
            local v3062 = 1;
            local v3063 = "";
            local v3064 = l_play_0.screen_size();
            local v3065 = l_v1372_13.color:get();
            local v3066 = l_v1372_13.position:get();
            local v3067 = l_v1531_12();
            local v3068 = l_v1532_12();
            local v3069 = l_play_0.measure_text(v3062, v3063, v3067);
            local v3070 = l_play_0.measure_text(v3062, v3063, v3068);
            if v3066 == "Bottom" then
                local v3071 = vector(v3064.x * 0.5, v3064.y - 14);
                local v3072 = v3071 - vector(v3069.x * 0.5, v3069.y);
                v3071.y = v3071.y - v3069.y;
                v3071.y = v3071.y - l_l_v1529_13_0;
                local v3073 = v3071 - vector(v3070.x * 0.5, v3070.y);
                l_play_0.text(v3062, v3072, v3065, v3063, v3067);
                l_play_0.text(v3062, v3073, color(200, 69, 69), v3063, v3068);
                return;
            else
                local v3074 = vector(20, v3064.y * 0.5);
                local v3075 = v3069.x + v3070.x + l_l_v1529_13_0;
                local v3076 = math.max(v3069.y, v3070.y);
                if v3066 == "Right" then
                    v3074.x = v3064.x - v3074.x;
                    v3074.x = v3074.x - v3075 + 1;
                end;
                v3074.y = v3074.y - v3076 * 0.5;
                local v3077 = v3074:clone();
                local v3078 = v3074:clone();
                v3078.x = v3078.x + v3069.x;
                v3078.x = v3078.x + l_l_v1529_13_0;
                l_play_0.text(v3062, v3077, v3065, v3063, v3067);
                l_play_0.text(v3062, v3078, color(200, 69, 69), v3063, v3068);
                return;
            end;
        end;
    end;
    l_v1529_13 = function(v3079)
        -- upvalues: l_v1527_11 (ref), l_v1528_11 (ref)
        local v3080 = v3079 == 1;
        local v3081 = v3079 == 2;
        events.render(l_v1527_11.on_render, v3080);
        events.render(l_v1528_11.on_render, v3081);
        events.player_death(l_v1527_11.on_player_death, v3080);
    end;
    v1530 = nil;
    v1531 = function(v3082)
        -- upvalues: l_v1372_13 (ref), l_v1529_13 (ref)
        local v3083 = v3082:get();
        local v3084 = v3083 == 2;
        l_v1372_13.remove_spaces:visibility(v3084);
        l_v1372_13.position:visibility(v3084);
        l_v1372_13.color:visibility(v3084);
        l_v1529_13(v3083);
    end;
    do
        local l_v1531_13 = v1531;
        v1532 = function()
            -- upvalues: l_v1373_12 (ref), l_v1525_11 (ref), l_v1526_10 (ref), l_v1529_13 (ref), l_v1372_13 (ref), l_v1531_13 (ref)
            local v3086 = l_v1373_12.enabled:get() or l_v1525_11.enabled:get();
            local v3087 = l_v1526_10.enabled:get() and l_v1526_10.select:get("Watermark");
            local v3088 = v3086 or v3087;
            if v3088 then
                l_v1529_13(nil);
            end;
            if not v3088 then
                l_v1372_13.style:set_callback(l_v1531_13, true);
            else
                l_v1372_13.style:unset_callback(l_v1531_13);
            end;
        end;
        l_v1525_11.enabled:set_callback(v1532);
        l_v1373_12.enabled:set_callback(v1532);
        l_v1526_10.enabled:set_callback(v1532);
        l_v1526_10.select:set_callback(v1532);
        v1532();
    end;
end;
v888 = nil;
v889 = nil;
v890 = v384.misc.clantag;
v891 = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag");
v892 = 0;
l_match_0 = {
    [1] = "",
    [2] = "a",
    [3] = "an",
    [4] = "ang",
    [5] = "ange",
    [6] = "angel",
    [7] = "angelw",
    [8] = "angelwi",
    [9] = "angelwin",
    [10] = "angelwing",
    [11] = "angelwings",
    [12] = "angelwings",
    [13] = "angelwings",
    [14] = "angelwings",
    [15] = "angelwings",
    [16] = "angelwings",
    [17] = "angelwings",
    [18] = "angelwings",
    [19] = "angelwings",
    [20] = "angelwings",
    [21] = "angelwings",
    [22] = "angelwings",
    [23] = "angelwings",
    [24] = "ngelwings",
    [25] = "gelwings",
    [26] = "elwings",
    [27] = "lwings",
    [28] = "wings",
    [29] = "ings",
    [30] = "ngs",
    [31] = "gs",
    [32] = "s",
    [33] = ""
};
l_angles_0 = function()
    -- upvalues: v12 (ref)
    return v12(globals.curtime * 4);
end;
do
    local l_v891_8, l_v892_10, l_l_match_0_10, l_l_angles_0_10, l_v982_11 = v891, v892, l_match_0, l_angles_0, v982;
    l_v982_11 = function()
        -- upvalues: l_l_angles_0_10 (ref), l_l_match_0_10 (ref), l_v892_10 (ref)
        if not globals.is_in_game then
            return;
        else
            local v3094 = l_l_angles_0_10() % #l_l_match_0_10 + 1;
            if l_v892_10 ~= v3094 then
                l_v892_10 = v3094;
                common.set_clan_tag(l_l_match_0_10[v3094] or "");
            end;
            return;
        end;
    end;
    v992 = nil;
    v1368 = function(v3095)
        -- upvalues: l_v891_8 (ref), l_v982_11 (ref)
        local v3096 = v3095:get();
        if not v3096 then
            common.set_clan_tag("");
        end;
        local l_l_v891_8_0 = l_v891_8;
        local l_l_l_v891_8_0_0 = l_l_v891_8_0;
        l_l_v891_8_0 = l_l_v891_8_0.override;
        if v3096 then

        end;
        l_l_v891_8_0(l_l_l_v891_8_0_0, nil);
        events.net_update_end(l_v982_11, v3096);
    end;
    v890.enabled:set_callback(v1368, true);
end;
v890 = nil;
v891 = v384.misc.trashtalk;
v892 = 0;
l_match_0 = {};
l_angles_0 = "https://cdn.hysteria.one/angelwings/trashtalk.txt";
do
    local l_v892_11, l_l_match_0_11, l_l_angles_0_11 = v892, l_match_0, l_angles_0;
    v982 = function(v3102)
        -- upvalues: l_l_match_0_11 (ref)
        if not v3102 or string.find(v3102, "404") then
            return;
        else
            local v3103 = 0;
            for v3104 in string.gmatch(v3102, "(.-)\n") do
                v3103 = v3103 + 1;
                l_l_match_0_11[v3103] = v3104;
            end;
            return;
        end;
    end;
    network.get(l_l_angles_0_11, nil, v982);
    l_l_angles_0_11 = function(v3105)
        -- upvalues: l_l_match_0_11 (ref), l_v892_11 (ref)
        local v3106 = entity.get_local_player();
        local v3107 = entity.get(v3105.userid, true);
        if entity.get(v3105.attacker, true) ~= v3106 or v3107 == v3106 then
            return;
        else
            local v3108 = #l_l_match_0_11;
            local v3109 = math.random(1, v3108);
            if v3109 == l_v892_11 then
                v3109 = v3109 + 1;
                if v3109 == v3108 then
                    v3109 = 1;
                end;
            end;
            utils.console_exec("say " .. l_l_match_0_11[v3109]);
            l_v892_11 = v3109;
            return;
        end;
    end;
    v982 = nil;
    v992 = function(v3110)
        -- upvalues: l_l_angles_0_11 (ref)
        events.player_death(l_l_angles_0_11, v3110:get());
    end;
    v891.enabled:set_callback(v992, true);
end;
v891 = nil;
v892 = v384.misc.fast_ladder;
l_match_0 = 9;
do
    local l_l_match_0_12, l_l_angles_0_12 = l_match_0, l_angles_0;
    l_l_angles_0_12 = function(v3113)
        -- upvalues: l_l_match_0_12 (ref), l_play_0 (ref), v12 (ref)
        local v3114 = entity.get_local_player();
        if v3114 == nil then
            return;
        elseif v3114.m_MoveType ~= l_l_match_0_12 then
            return;
        else
            local v3115 = l_play_0.camera_angles();
            v3113.view_angles.y = v12(v3113.view_angles.y);
            v3113.view_angles.z = 0;
            if v3113.forwardmove > 0 and v3115.y < 45 then
                v3113.view_angles.x = 89;
                v3113.in_moveright = 1;
                v3113.in_moveleft = 0;
                v3113.in_forward = 0;
                v3113.in_back = 1;
                if v3113.sidemove == 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 90;
                end;
                if v3113.sidemove < 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 150;
                end;
                if v3113.sidemove > 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 30;
                end;
            elseif v3113.forwardmove < 0 then
                v3113.view_angles.x = 89;
                v3113.in_moveleft = 1;
                v3113.in_moveright = 0;
                v3113.in_forward = 1;
                v3113.in_back = 0;
                if v3113.sidemove == 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 90;
                end;
                if v3113.sidemove > 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 150;
                end;
                if v3113.sidemove < 0 then
                    v3113.view_angles.y = v3113.view_angles.y + 30;
                end;
            end;
            return;
        end;
    end;
    v982 = nil;
    v992 = function(v3116)
        -- upvalues: l_l_angles_0_12 (ref)
        events.createmove(l_l_angles_0_12, v3116:get());
    end;
    v892.enabled:set_callback(v992, true);
end;
v892 = nil;
l_match_0 = v384.misc.edge_stop;
l_angles_0 = function(v3117)
    local v3118 = entity.get_local_player();
    if v3118 == nil then
        return;
    else
        local v3119 = v3118:simulate_movement();
        v3119:think(5);
        if v3119.velocity.z < 0 then
            v3117.block_movement = 2;
        end;
        return;
    end;
end;
v982 = nil;
do
    local l_l_angles_0_13 = l_angles_0;
    v992 = function(v3121)
        -- upvalues: l_l_angles_0_13 (ref)
        events.createmove(l_l_angles_0_13, v3121:get());
    end;
    l_match_0.enabled:set_callback(v992, true);
end;
l_match_0 = nil;
l_angles_0 = v384.misc.collision_air_duck;
v982 = function(v3122)
    local v3123 = entity.get_local_player();
    if v3123 == nil then
        return;
    else
        local l_m_fFlags_1 = v3123.m_fFlags;
        if bit.band(l_m_fFlags_1, 1) ~= 0 then
            return;
        elseif v3122.in_duck then
            return;
        else
            local v3125 = false;
            local v3126 = v3123:simulate_movement();
            v3122.in_duck = true;
            v3126:think(1);
            v3125 = bit.band(v3126.flags, 1) == 0 and v3126.did_hit_collision;
            v3126 = false;
            local v3127 = v3123:simulate_movement();
            v3122.in_duck = false;
            v3127:think(1);
            v3126 = bit.band(v3127.flags, 1) == 0 and v3127.did_hit_collision;
            if not v3125 and v3126 then
                v3122.in_duck = true;
            end;
            return;
        end;
    end;
end;
v992 = nil;
do
    local l_v982_12 = v982;
    v1368 = function(v3129)
        -- upvalues: l_v982_12 (ref)
        events.createmove(l_v982_12, v3129:get());
    end;
    l_angles_0.enabled:set_callback(v1368, true);
end;
l_angles_0 = nil;
v982 = v384.misc.no_fall_damage;
v992 = false;
v1368 = function(v3130, v3131)
    local v3132 = v3130:get_origin();
    for v3133 = 0, math.pi * 2, math.pi * 2 / 8 do
        local v3134 = math.sin(v3133);
        local v3135 = math.cos(v3133);
        local v3136 = v3132 + vector(10 * v3135, 10 * v3134, 0);
        local v3137 = v3136 - vector(0, 0, v3131);
        if utils.trace_line(v3136, v3137, v3130).fraction ~= 1 then
            return true;
        end;
    end;
    return false;
end;
do
    local l_v992_13, l_v1368_11, l_v1369_14 = v992, v1368, v1369;
    l_v1369_14 = function(v3141)
        -- upvalues: l_v992_13 (ref), l_v1368_11 (ref)
        local v3142 = entity.get_local_player();
        if v3142 == nil then
            return;
        else
            if v3142.m_vecVelocity.z >= -500 then
                l_v992_13 = false;
            elseif l_v1368_11(v3142, 15) then
                l_v992_13 = false;
            elseif l_v1368_11(v3142, 75) then
                l_v992_13 = true;
            end;
            if v3142.m_vecVelocity.z < -500 then
                v3141.in_duck = l_v992_13;
            end;
            return;
        end;
    end;
    v1370 = nil;
    l_aimtools_0 = function(v3143)
        -- upvalues: l_v1369_14 (ref)
        events.createmove(l_v1369_14, v3143:get());
    end;
    v982.enabled:set_callback(l_aimtools_0, true);
end;
v982 = nil;
v992 = v384.misc.super_toss;
v1368 = 0.3;
v1369 = function(v3144, v3145, v3146)
    if math.abs(v3144.x) > math.abs(v3144.y) then
        local v3147 = v3144.y / v3144.x;
        local v3148 = 1 + v3147 * v3147;
        local v3149 = -2 * v3145.x - 2 * v3147 * v3145.y;
        local v3150 = v3145:length2dsqr() - v3146 * v3146;
        local v3151 = v3149 * v3149 - 4 * v3148 * v3150;
        if v3151 < 0 then
            return v3145 + (v3144 * v3145:dot(v3144) - v3145):normalized() * v3146;
        elseif v3151 < 0.001 then
            local v3152 = -v3149 / (2 * v3148);
            local v3153 = v3147 * v3152;
            return vector(v3152, v3153);
        else
            local v3154 = math.sqrt(v3151);
            local v3155 = (-v3149 + v3154) / (2 * v3148);
            local v3156 = v3147 * v3155;
            local v3157 = vector(v3155, v3156);
            v3155 = (-v3149 - v3154) / (2 * v3148);
            v3156 = v3147 * v3155;
            local v3158 = vector(v3155, v3156);
            if v3144:dot(v3157) > v3144:dot(v3158) then
                return v3157;
            else
                return v3158;
            end;
        end;
    else
        local v3159 = v3144.x / v3144.y;
        local v3160 = 1 + v3159 * v3159;
        local v3161 = -2 * v3145.y - 2 * v3159 * v3145.x;
        local v3162 = v3145:length2dsqr() - v3146 * v3146;
        local v3163 = v3161 * v3161 - 4 * v3160 * v3162;
        if v3163 < 0 then
            return v3145 + (v3144 * v3145:dot(v3144) - v3145):normalized() * v3146;
        elseif v3163 < 0.001 then
            local v3164 = -v3161 / (2 * v3160);
            local v3165 = v3159 * v3164;
            return vector(v3165, v3164);
        else
            local v3166 = math.sqrt(v3163);
            local v3167 = (-v3161 + v3166) / (2 * v3160);
            local v3168 = v3159 * v3167;
            local v3169 = vector(v3168, v3167);
            v3167 = (-v3161 - v3166) / (2 * v3160);
            v3168 = v3159 * v3167;
            local v3170 = vector(v3168, v3167);
            if v3144:dot(v3169) > v3144:dot(v3170) then
                return v3169;
            else
                return v3170;
            end;
        end;
    end;
end;
do
    local l_v1368_12, l_v1369_15, l_v1370_14, l_l_aimtools_0_16, l_v1372_14, l_v1373_13 = v1368, v1369, v1370, l_aimtools_0, v1372, v1373;
    l_v1370_14 = function(v3177, v3178, v3179, v3180)
        -- upvalues: v14 (ref), l_v1368_12 (ref), l_v1369_15 (ref)
        local v3181 = vector():angles(v3177);
        local v3182 = vector():angles(v3177.x - (90 - math.abs(v3177.x)) * 10 / 90, v3177.y);
        local v3183 = v3182:dot(v3181) / v3181:length();
        local v3184 = math.clamp(v3179 * 0.9, 15, 750);
        local v3185 = math.clamp(v3180, 0, 1);
        v3184 = v3184 * v14.lerp(l_v1368_12, 1, v3185);
        v3177.y = (l_v1369_15(v3182, v3178 * 1.25, v3184 * v3183) - v3178 * 1.25):angles().y;
        v3177.x = math.clamp(v3177.x + math.clamp(v3178.z * 0.1, -20, 20), -89, 89);
    end;
    l_l_aimtools_0_16 = function(v3186, v3187)
        local v3188 = math.rad(v3187);
        local v3189 = math.cos(v3188);
        local v3190 = math.sin(v3188);
        local v3191 = v3189 * v3186.forwardmove + v3190 * v3186.sidemove;
        local v3192 = v3190 * v3186.forwardmove + v3189 * v3186.sidemove;
        v3186.forwardmove = v3191;
        v3186.sidemove = v3192;
    end;
    l_v1372_14 = function(v3193)
        -- upvalues: l_play_0 (ref), l_v1370_14 (ref), l_l_aimtools_0_16 (ref)
        local v3194 = entity.get_local_player();
        if v3194 == nil then
            return;
        else
            local v3195 = v3194:get_player_weapon();
            if v3195 == nil then
                return;
            else
                local v3196 = v3195:get_weapon_info();
                if v3196 == nil or v3196.weapon_type ~= 9 then
                    return;
                elseif v3195.m_fThrowTime == 0 then
                    return;
                elseif v3194.m_nTickBase * globals.tickinterval < v3195.m_fThrowTime and rage.exploit:get() ~= 1 then
                    return;
                else
                    local l_view_angles_0 = v3193.view_angles;
                    local l_y_4 = l_view_angles_0.y;
                    local v3199 = l_play_0.camera_angles();
                    if v3199.x ~= l_view_angles_0.x or v3199.y ~= l_view_angles_0.y then
                        return;
                    else
                        l_v1370_14(l_view_angles_0, v3194.m_vecVelocity, v3196.throw_velocity, v3195.m_flThrowStrength);
                        l_l_aimtools_0_16(v3193, math.normalize_yaw(l_y_4 - l_view_angles_0.y));
                        return;
                    end;
                end;
            end;
        end;
    end;
    l_v1373_13 = function(v3200)
        -- upvalues: l_v1370_14 (ref)
        local v3201 = entity.get_local_player();
        if v3201 == nil then
            return;
        else
            local v3202 = v3201:get_player_weapon();
            if v3202 == nil then
                return;
            else
                local v3203 = v3202:get_weapon_info();
                if v3203 ~= nil and v3203.weapon_type == 9 then
                    l_v1370_14(v3200.angles, v3200.velocity, v3203.throw_velocity, v3202.m_flThrowStrength);
                end;
                return;
            end;
        end;
    end;
    v1525 = nil;
    v1526 = function(v3204)
        -- upvalues: l_v1372_14 (ref), l_v1373_13 (ref)
        local v3205 = v3204:get();
        events.createmove(l_v1372_14, v3205);
        events.grenade_override_view(l_v1373_13, v3205);
    end;
    v992.enabled:set_callback(v1526, true);
end;
v992 = nil;
v1368 = v384.misc.grenade_release;
v1369 = nil;
do
    local l_v1368_13, l_v1369_16, l_v1370_15, l_l_aimtools_0_17, l_v1372_15 = v1368, v1369, v1370, l_aimtools_0, v1372;
    l_v1370_15 = function(v3211, v3212)
        -- upvalues: l_v1368_13 (ref)
        if v3211 == nil or v3212 == nil then
            return false;
        elseif v3211:get_weapon_index() == 45 then
            return v3212 > 0;
        else
            return l_v1368_13.damage:get() <= v3212;
        end;
    end;
    l_l_aimtools_0_17 = function(v3213)
        -- upvalues: l_v1370_15 (ref), l_v1369_16 (ref)
        local v3214 = entity.get_local_player();
        if v3214 == nil then
            return;
        else
            local v3215 = v3214:get_player_weapon();
            if v3215 == nil then
                return;
            elseif not v3215.m_bPinPulled then
                return;
            elseif v3215.m_flThrowStrength <= 0 then
                return;
            else
                if l_v1370_15(v3215, l_v1369_16) then
                    v3213.in_attack = false;
                    v3213.in_attack2 = false;
                end;
                l_v1369_16 = nil;
                return;
            end;
        end;
    end;
    l_v1372_15 = function(v3216)
        -- upvalues: l_v1369_16 (ref)
        l_v1369_16 = v3216.damage;
    end;
    v1373 = nil;
    v1525 = function(v3217)
        -- upvalues: l_l_aimtools_0_17 (ref), l_v1372_15 (ref)
        local v3218 = v3217:get();
        events.createmove(l_l_aimtools_0_17, v3218);
        events.grenade_prediction(l_v1372_15, v3218);
    end;
    l_v1368_13.enabled:set_callback(v1525, true);
end;
v1368 = nil;
v1369 = v384.misc.fps_optimize;
v1370 = false;
l_aimtools_0 = {};
v1372 = function(v3219)
    assert(type(v3219) == "table", "cmds must be a table");
    assert(type(v3219.set) == "function", "set must be a function");
    assert(type(v3219.unset) == "function", "unset must be a function");
    return {
        set = v3219.set,
        unset = v3219.unset
    };
end;
do
    local l_v1372_16 = v1372;
    v1373 = function(v3221, v3222)
        -- upvalues: l_v1372_16 (ref)
        assert(type(v3221) == "userdata", "convar must be a userdata");
        assert(type(v3222) == "number", "value must be a number");
        local v3223 = nil;
        local l_v3222_0 = v3222;
        local function v3225()
            -- upvalues: v3223 (ref), v3221 (ref), l_v3222_0 (ref)
            if v3223 == nil then
                v3223 = v3221:int();
                v3221:int(l_v3222_0);
            end;
        end;
        local function v3226()
            -- upvalues: v3223 (ref), v3221 (ref)
            if v3223 ~= nil then
                v3221:int(v3223);
                v3223 = nil;
            end;
        end;
        return l_v1372_16({
            set = v3225,
            unset = v3226
        });
    end;
    v1525 = function(v3227)
        -- upvalues: l_v1372_16 (ref)
        assert(type(v3227) == "function", "fn must be a function");
        local v3228 = {};
        v3227(v3228);
        return l_v1372_16(v3228);
    end;
    l_aimtools_0.Fog = {
        v1373(cvar.fog_enable, 0),
        v1373(cvar.fog_enable_water_fog, 0)
    };
    l_aimtools_0.Blood = {
        v1373(cvar.violence_hblood, 0)
    };
    l_aimtools_0.Bloom = {
        v1373(cvar.mat_disable_bloom, 1)
    };
    l_aimtools_0.Decals = {
        v1373(cvar.r_drawdecals, 0)
    };
    l_aimtools_0.Shadows = {
        v1373(cvar.r_shadows, 0),
        v1373(cvar.cl_csm_static_prop_shadows, 0),
        v1373(cvar.cl_csm_shadows, 0),
        v1373(cvar.cl_csm_world_shadows, 0),
        v1373(cvar.cl_foot_contact_shadows, 0),
        v1373(cvar.cl_csm_viewmodel_shadows, 0),
        v1373(cvar.cl_csm_rope_shadows, 0),
        v1373(cvar.cl_csm_sprite_shadows, 0),
        v1373(cvar.cl_csm_translucent_shadows, 0),
        v1373(cvar.cl_csm_entity_shadows, 0),
        v1373(cvar.cl_csm_world_shadows_in_viewmodelcascade, 0)
    };
    l_aimtools_0.Sprites = {
        v1373(cvar.r_drawsprites, 0)
    };
    l_aimtools_0.Particles = {
        v1373(cvar.r_drawparticles, 0)
    };
    l_aimtools_0.Ropes = {
        v1373(cvar.r_drawropes, 0)
    };
    l_aimtools_0["Dynamic lights"] = {
        v1373(cvar.mat_disable_fancy_blending, 1)
    };
    l_aimtools_0["Map details"] = {
        v1373(cvar.func_break_max_pieces, 0),
        v1373(cvar.props_break_max_pieces, 0)
    };
    l_aimtools_0["Weapon effects"] = {
        v1373(cvar.muzzleflash_light, 0),
        v1373(cvar.r_drawtracers_firstperson, 0)
    };
    l_aimtools_0.Teammates = {
        v1525(function(v3229)
            local v3230 = 628;
            local function v3233(v3231, v3232)
                -- upvalues: v3230 (ref)
                ffi.cast("int*", ffi.cast("uint32_t", v3231[0]) + v3230)[0] = v3232;
            end;
            local function v3239()
                -- upvalues: v3233 (ref)
                local v3234 = entity.get_local_player();
                if v3234 == nil then
                    return;
                else
                    local l_m_iTeamNum_1 = v3234.m_iTeamNum;
                    if l_m_iTeamNum_1 < 2 or l_m_iTeamNum_1 > 3 then
                        return;
                    else
                        local v3236 = entity.get_players();
                        for v3237 = 1, #v3236 do
                            local v3238 = v3236[v3237];
                            if v3234 ~= v3238 and v3238.m_iTeamNum == l_m_iTeamNum_1 then
                                v3233(v3238, 0);
                            end;
                        end;
                        return;
                    end;
                end;
            end;
            local function v3243(v3240)
                -- upvalues: v3239 (ref)
                local l_entity_2 = v3240.entity;
                if l_entity_2 == nil or not l_entity_2:is_player() then
                    return true;
                else
                    local v3242 = entity.get_local_player();
                    if l_entity_2.m_iTeamNum == v3242.m_iTeamNum then
                        return false;
                    else
                        v3239();
                        return;
                    end;
                end;
            end;
            local function v3244()
                -- upvalues: v3243 (ref)
                events.draw_model(v3243, true);
            end;
            local function v3245()
                -- upvalues: v3243 (ref)
                events.draw_model(v3243, false);
            end;
            v3229.set = v3244;
            v3229.unset = v3245;
        end)
    };
end;
do
    local l_v1369_17, l_v1370_16, l_l_aimtools_0_18, l_v1372_17, l_v1373_14, l_v1525_12, l_v1526_11, l_v1527_12 = v1369, v1370, l_aimtools_0, v1372, v1373, v1525, v1526, v1527;
    l_v1372_17 = function()
        -- upvalues: l_v1369_17 (ref), v394 (ref)
        if l_v1369_17.always_on:get() then
            return true;
        elseif v394.is_peeking and l_v1369_17.detections:get("Peeking") then
            return true;
        elseif v394.is_vulnerable and l_v1369_17.detections:get("Hit Flag") then
            return true;
        else
            return false;
        end;
    end;
    l_v1373_14 = function()
        -- upvalues: l_v1370_16 (ref), l_l_aimtools_0_18 (ref)
        if not l_v1370_16 then
            return;
        else
            for _, v3255 in pairs(l_l_aimtools_0_18) do
                for v3256 = 1, #v3255 do
                    v3255[v3256]:unset();
                end;
            end;
            l_v1370_16 = false;
            return;
        end;
    end;
    l_v1525_12 = function()
        -- upvalues: l_v1370_16 (ref), l_v1369_17 (ref), l_l_aimtools_0_18 (ref)
        if l_v1370_16 then
            return;
        else
            local v3257 = l_v1369_17.select:get();
            for v3258 = 1, #v3257 do
                local v3259 = l_l_aimtools_0_18[v3257[v3258]];
                for v3260 = 1, #v3259 do
                    v3259[v3260]:set();
                end;
            end;
            l_v1370_16 = true;
            return;
        end;
    end;
    l_v1526_11 = function()
        -- upvalues: l_v1373_14 (ref)
        l_v1373_14();
    end;
    l_v1527_12 = function()
        -- upvalues: l_v1372_17 (ref), l_v1373_14 (ref), l_v1525_12 (ref)
        if not l_v1372_17() then
            return l_v1373_14();
        else
            l_v1525_12();
            return;
        end;
    end;
    v1528 = nil;
    v1529 = function(_)
        -- upvalues: l_v1373_14 (ref), l_v1525_12 (ref)
        l_v1373_14();
        l_v1525_12();
    end;
    do
        local l_v1529_14 = v1529;
        v1530 = function(v3263)
            -- upvalues: l_v1369_17 (ref), l_v1529_14 (ref), l_v1373_14 (ref), l_v1526_11 (ref), l_v1527_12 (ref)
            local v3264 = v3263:get();
            if v3264 then
                l_v1369_17.select:set_callback(l_v1529_14, true);
            else
                l_v1369_17.select:unset_callback(l_v1529_14);
            end;
            if not v3264 then
                l_v1373_14();
            end;
            events.shutdown(l_v1526_11, v3264);
            events.net_update_end(l_v1527_12, v3264);
        end;
        l_v1369_17.enabled:set_callback(v1530, true);
    end;
end;
v1369 = nil;
v1370 = v384.misc.ping_unlocker;
l_aimtools_0 = ui.find("Miscellaneous", "Main", "Other", "Fake Latency");
v1372 = cvar.sv_maxunlag;
do
    local l_v1370_17, l_l_aimtools_0_19, l_v1372_18, l_v1373_15, l_v1525_13, l_v1526_12 = v1370, l_aimtools_0, v1372, v1373, v1525, v1526;
    l_v1373_15 = function()
        -- upvalues: l_l_aimtools_0_19 (ref), l_v1372_18 (ref)
        l_l_aimtools_0_19:override();
        l_l_aimtools_0_19:disabled(false);
        l_v1372_18:float(tonumber(l_v1372_18:string()), true);
    end;
    l_v1525_13 = function(v3271)
        -- upvalues: l_l_aimtools_0_19 (ref), l_v1372_18 (ref)
        l_l_aimtools_0_19:override(v3271);
        l_l_aimtools_0_19:disabled(false);
        l_v1372_18:float(0.4, true);
    end;
    l_v1526_12 = function()
        -- upvalues: l_v1373_15 (ref)
        l_v1373_15();
    end;
    v1527 = nil;
    v1528 = function(v3272)
        -- upvalues: l_v1525_13 (ref)
        l_v1525_13(v3272:get());
    end;
    do
        local l_v1528_12 = v1528;
        v1529 = function(v3274)
            -- upvalues: l_v1373_15 (ref), l_v1370_17 (ref), l_v1528_12 (ref), l_v1526_12 (ref)
            local v3275 = v3274:get();
            if not v3275 then
                l_v1373_15();
            end;
            if v3275 then
                l_v1370_17.value:set_callback(l_v1528_12, true);
            else
                l_v1370_17.value:unset_callback(l_v1528_12);
            end;
            events.shutdown(l_v1526_12, v3275);
        end;
        l_v1370_17.enabled:set_callback(v1529, true);
    end;
end;
v1370 = nil;
l_aimtools_0 = v384.misc.animation_breaker;
v1372 = 2;
v1373 = 6;
v1525 = 12;
v1526 = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement");
v1527 = ffi.typeof("            struct {\n                float  m_flLayerAnimtime;\n                float  m_flLayerFadeOuttime;\n\n                // dispatch flags\n                void  *m_pDispatchedStudioHdr;\n                int    m_nDispatchedSrc;\n                int    m_nDispatchedDst;\n\n                int    m_nOrder;\n                int    m_nSequence;\n                float  m_flPrevCycle;\n                float  m_flWeight;\n                float  m_flWeightDeltaRate;\n\n                // used for automatic crossfades between sequence changes;\n                float  m_flPlaybackRate;\n                float  m_flCycle;\n                int    m_pOwner;\n                int    m_nInvalidatePhysicsBits;\n            } **\n        ");
do
    local l_l_aimtools_0_20, l_v1372_19, l_v1373_16, l_v1525_14, l_v1526_13, l_v1527_13, l_v1528_13, l_v1529_15, l_v1530_13, l_v1531_14, l_v1532_13, l_v1533_8 = l_aimtools_0, v1372, v1373, v1525, v1526, v1527, v1528, v1529, v1530, v1531, v1532, v1533;
    l_v1528_13 = function(v3288)
        -- upvalues: l_v1527_13 (ref)
        return ffi.cast(l_v1527_13, ffi.cast("uintptr_t", v3288[0]) + 10640)[0];
    end;
    l_v1529_15 = function(v3289)
        -- upvalues: v394 (ref), l_l_aimtools_0_20 (ref), l_v1526_13 (ref)
        if v394.is_onground then
            local v3290 = l_l_aimtools_0_20.ground_legs:get();
            if v3290 == "Static" then
                l_v1526_13:override("Sliding");
                v3289.m_flPoseParameter[0] = 0;
                return;
            elseif v3290 == "Jitter" then
                local l_tickcount_2 = globals.tickcount;
                local v3292 = l_l_aimtools_0_20.legs_offset_1:get();
                local v3293 = l_l_aimtools_0_20.legs_offset_2:get();
                local v3294 = 1 / (l_tickcount_2 % 8 >= 4 and 200 or 400);
                local v3295 = l_tickcount_2 % 4 >= 2 and v3292 or v3293;
                l_v1526_13:override("Sliding");
                v3289.m_flPoseParameter[0] = v3295 * v3294;
                return;
            elseif v3290 == "Allah" then
                l_v1526_13:override("Walking");
                v3289.m_flPoseParameter[7] = 0;
                return;
            elseif v3290 == "Kangaroo" then
                v3289.m_flPoseParameter[3] = math.random();
                v3289.m_flPoseParameter[6] = math.random();
                v3289.m_flPoseParameter[7] = math.random();
            end;
        end;
        l_v1526_13:override();
    end;
    l_v1530_13 = function(v3296, v3297)
        -- upvalues: l_l_aimtools_0_20 (ref), v394 (ref), l_v1373_16 (ref)
        local v3298 = l_l_aimtools_0_20.air_legs:get();
        if v3298 == "Disabled" then
            return;
        elseif v394.is_onground then
            return;
        elseif v3298 == "Static" then
            v3296.m_flPoseParameter[6] = 1;
            return;
        elseif v3298 == "kangaroo" then
            v3296.m_flPoseParameter[3] = math.random();
            v3296.m_flPoseParameter[6] = math.random();
            v3296.m_flPoseParameter[7] = math.random();
            return;
        elseif v3298 == "Haram" then
            if not v394.is_moving then
                return;
            else
                local v3299 = v3297[l_v1373_16];
                if v3299 == nil then
                    return;
                else
                    v3299.m_flWeight = 1;
                    return;
                end;
            end;
        else
            return;
        end;
    end;
    l_v1531_14 = function(v3300)
        -- upvalues: l_l_aimtools_0_20 (ref), l_v1525_14 (ref)
        local v3301 = l_l_aimtools_0_20.body_lean:get();
        if v3301 == -1 then
            return;
        else
            local v3302 = v3300[l_v1525_14];
            if v3302 == nil then
                return;
            else
                v3302.m_flWeight = v3301 * 0.1;
                return;
            end;
        end;
    end;
    l_v1532_13 = function(v3303, v3304)
        -- upvalues: l_l_aimtools_0_20 (ref), v394 (ref)
        if not l_l_aimtools_0_20.pitch_on_land:get() then
            return;
        elseif not v394.is_onground then
            return;
        elseif not v3304.landing then
            return;
        else
            v3303.m_flPoseParameter[12] = 0.5;
            return;
        end;
    end;
    l_v1533_8 = function(v3305)
        -- upvalues: l_v1528_13 (ref), l_v1372_19 (ref), l_v1529_15 (ref), l_v1530_13 (ref), l_v1532_13 (ref), l_v1531_14 (ref)
        local v3306 = entity.get_local_player();
        if v3306 == nil or v3305 ~= v3306 then
            return;
        else
            local v3307 = v3305:get_anim_state();
            if v3307 == nil then
                return;
            else
                local v3308 = l_v1528_13(v3305);
                if v3308 == nil then
                    return;
                else
                    if v3306.m_MoveType == l_v1372_19 then
                        l_v1529_15(v3306);
                        l_v1530_13(v3306, v3308);
                        l_v1532_13(v3306, v3307);
                    end;
                    l_v1531_14(v3308);
                    return;
                end;
            end;
        end;
    end;
    v1534 = nil;
    v1535 = function(v3309)
        -- upvalues: l_v1526_13 (ref), l_v1533_8 (ref)
        local v3310 = v3309:get();
        if not v3310 then
            l_v1526_13:override();
        end;
        events.post_update_clientside_animation(l_v1533_8, v3310);
    end;
    l_l_aimtools_0_20.enabled:set_callback(v1535, true);
end;
l_aimtools_0 = nil;
v1372 = v384.misc.fake_duck;
v1373 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
v1525 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
v1526 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
v1527 = {};
v1528 = 0;
do
    local l_v1373_17, l_v1525_15, l_v1526_14, l_v1527_14, l_v1528_14 = v1373, v1525, v1526, v1527, v1528;
    do
        local l_l_v1528_14_0, l_v1529_16, l_v1530_14, l_v1531_15, l_v1532_14, l_v1533_9 = l_v1528_14, v1529, v1530, v1531, v1532, v1533;
        l_v1529_16 = function()
            -- upvalues: l_l_v1528_14_0 (ref)
            if l_l_v1528_14_0 >= 14 then
                l_l_v1528_14_0 = 0;
            end;
            l_l_v1528_14_0 = l_l_v1528_14_0 + 1;
        end;
        l_v1530_14 = function()
            -- upvalues: l_v1373_17 (ref), l_v1525_15 (ref)
            l_v1373_17:override();
            l_v1525_15:override();
        end;
        l_v1531_15 = function()
            -- upvalues: l_v1530_14 (ref)
            l_v1530_14();
        end;
        l_v1532_14 = function(v3322)
            -- upvalues: l_v1526_14 (ref)
            if not l_v1526_14:get() then
                return;
            else
                local v3323 = entity.get_local_player();
                if v3323 == nil then
                    return;
                else
                    local v3324 = entity.get_game_rules();
                    if v3324 == nil or not v3324.m_bFreezePeriod then
                        return;
                    else
                        v3322.camera.z = v3323:get_origin().z + 64;
                        return;
                    end;
                end;
            end;
        end;
        l_v1533_9 = function(v3325)
            -- upvalues: l_v1526_14 (ref), l_v1530_14 (ref), l_v1529_16 (ref), l_l_v1528_14_0 (ref), l_v1373_17 (ref), l_v1525_15 (ref)
            if not l_v1526_14:get() then
                return l_v1530_14();
            else
                local v3326 = entity.get_game_rules();
                if v3326 == nil or not v3326.m_bFreezePeriod then
                    return;
                else
                    l_v1529_16();
                    v3325.in_duck = l_l_v1528_14_0 > 7;
                    v3325.send_packet = l_l_v1528_14_0 == 14;
                    l_v1373_17:override(false);
                    l_v1525_15:override(false);
                    return;
                end;
            end;
        end;
        l_v1527_14.update = function(v3327)
            -- upvalues: l_v1531_15 (ref), l_v1533_9 (ref), l_v1532_14 (ref)
            local v3328 = v3327:get("On Freezetime");
            events.shutdown(l_v1531_15, v3328);
            events.createmove(l_v1533_9, v3328);
            events.override_view(l_v1532_14, v3328);
        end;
    end;
    l_v1528_14 = {};
    v1529 = function(v3329)
        -- upvalues: l_v1526_14 (ref)
        if not l_v1526_14:get() then
            return;
        else
            local v3330 = vector(v3329.forwardmove, v3329.sidemove);
            if v3330:length2dsqr() < 25 then
                return;
            else
                v3330:normalize();
                v3329.forwardmove = v3330.x * 150;
                v3329.sidemove = v3330.y * 150;
                return;
            end;
        end;
    end;
    do
        local l_v1529_17 = v1529;
        l_v1528_14.update = function(v3332)
            -- upvalues: l_v1529_17 (ref)
            events.createmove_run(l_v1529_17, v3332:get("Unlock Speed"));
        end;
    end;
    v1529 = nil;
    v1530 = function(v3333)
        -- upvalues: l_v1527_14 (ref), l_v1528_14 (ref)
        l_v1527_14.update(v3333);
        l_v1528_14.update(v3333);
    end;
    v1372.options:set_callback(v1530, true);
end;
v1372 = nil;
v1373 = v384.misc.nickname_generator;
v1525 = cvar.name;
v1526 = nil;
v1527 = {
    [1] = "\208\177\208\187\209\143 \208\189\208\190\209\128\208\188\208\176\208\187\209\140\208\189\208\190 \208\189\208\176\208\178\208\176\209\133\209\131 \208\186\209\131\208\191\208\184\208\187",
    [2] = "\209\143 \208\178\208\181\208\185\208\191 \208\186\209\131\208\191\208\184\208\187",
    [3] = "\209\135\208\180? \208\186\208\180?",
    [4] = "\209\143\208\186\209\131\208\177\208\190\208\178\209\135\208\184567",
    [5] = "\208\177\208\187\208\181\208\186 \208\176\208\189\208\179\208\181\208\187 \209\131\208\177\208\184\208\178\209\136\208\186\208\17611",
    [6] = "\209\130\208\176\209\128\208\176\208\186\208\176\208\189 \208\180\208\184\208\189\208\184\209\129",
    [7] = "\208\182\209\131\208\187\209\140\208\178\208\181\209\128\208\184\208\186",
    [8] = "\209\143\209\128\208\190\209\129\209\130\208\189\209\139\208\185 \208\188\208\184\208\189\208\181\209\128\208\187\209\140\208\189\209\139\208\185 \209\135\208\181\209\135\208\181\208\189\208\181\209\134 \208\186\208\176\208\182\209\141\209\131\208\176\208\187",
    [9] = "\209\129\208\189\208\181\208\179\208\190\208\178\208\190\208\185 \208\176\208\178\208\191\208\186\208\184\208\189\208\179\209\131\208\187\209\143",
    [10] = "mr \208\179\208\181\208\185\208\188\208\181\209\128300",
    [11] = "\209\133\209\129\208\176\209\142 \208\178\208\178 \209\129 \208\191\208\181\209\128\208\178\208\190\208\185 \208\191\209\131",
    [12] = "\208\186\209\131\208\180\208\176 \208\178 \209\133\209\131\208\185",
    [13] = "hasbik style KZ",
    [14] = "60G AJlTaUcKuX 7oP",
    [15] = "4\208\181 \208\178 Xy\209\1437y",
    [16] = "\209\133\209\129\208\176\209\142 \208\180\208\176\208\182\208\181 \208\189\208\176 \209\130\208\190\208\1874\208\186\208\181",
    [17] = "OnlyBaim gang$",
    [18] = "\208\177\209\139\208\187 \208\178\209\139\208\181\208\177\208\176\208\189 \208\186\208\184\208\183\208\176\209\128\209\131\209\133\208\178\209\133",
    [19] = "9PoCtHblU KUnKoG",
    [20] = "TTu3\208\180oH\209\142x",
    [21] = "CTaPa\209\143 Ho OTTacHeH\209\140Ka\209\143",
    [22] = "\209\143 \208\178\209\139\208\181\208\183\208\182\208\176\209\142 \208\189\208\190\209\129\208\190\208\191\209\139\209\128\208\186\208\184",
    [23] = "\226\156\170FasTIK\226\156\170",
    [24] = "\208\130\206\163\198\138O\197\129\226\136\134G\226\136\134",
    [25] = "\239\184\187\227\131\135\226\149\144\228\184\128 \226\152\173 sniper",
    [26] = "\208\147\209\131\208\161\208\181\208\153\208\189 \208\168\208\190\208\163",
    [27] = "o\208\159 \208\175 \208\186\208\160\209\131\208\162\208\190\208\153 \208\144 \209\130\208\171 \208\165\209\131\208\153",
    [28] = "\209\133\209\131\209\143\209\130\208\190\209\128\209\131\208\177\208\184\208\178\208\176\209\130\208\190\209\1286731",
    [29] = "\226\153\149\239\189\129\239\189\146\239\189\148\239\189\133\239\189\141 \239\188\145\239\188\149\239\188\148",
    [30] = "\209\129\209\128\208\181\208\179\208\176 \208\188\208\190\208\177\208\184\208\187\208\186\208\184\208\189",
    [31] = "\208\188\208\176\209\130\208\178\208\181\208\185 \208\186\209\128\208\176\208\177\208\190\208\178",
    [32] = "\208\186\208\190\208\185\209\132\208\190\208\178\208\176\209\143 \208\186\209\128\208\184\208\178\208\181\209\130\208\186\208\176 \208\181\208\177\208\187\208\176\208\189\208\184\209\137\208\181",
    [33] = "\226\156\167*:\239\189\165\239\190\159\226\156\167 \240\157\144\133\240\157\144\148\240\157\144\130\240\157\144\138 \240\157\144\152\240\157\144\142\240\157\144\148 \226\156\167*:\239\189\165\239\190\159\226\156\167",
    [34] = "SPASIBO ZA SKEET",
    [35] = "\240\157\144\141\240\157\144\154\240\157\144\128\240\157\144\162\240\157\144\171\240\157\144\140\240\157\144\154\240\157\144\177",
    [36] = "\208\177\209\131\208\185\208\189\209\139\208\185 \209\129\208\187\208\176\208\178\208\184\208\186 \208\179\208\176\208\183\208\190\208\187\208\184\209\128",
    [37] = "\208\187\209\145\208\178\208\176 \209\130\208\176\209\128\208\176\208\186\208\176\208\189-56",
    [38] = "yKpoTuTeJlb_6a6yweK",
    [39] = "anatoly fakeyaw",
    [40] = "\208\146\208\176\208\187\208\181\208\189\209\130\208\184\208\189",
    [41] = "\208\161\209\131\208\191\208\181\209\128 \208\161\208\189\208\176\208\185\208\191\208\181\209\128228",
    [42] = "\208\151\208\176\208\186\208\176\208\183\208\176\209\130\209\140 \208\191\208\181\208\180\208\190\209\132u\208\187\208\176",
    [43] = "\208\160\208\176\208\188\208\183\208\176\208\189 \208\154\208\176\208\180\209\139\209\128\208\190\208\178",
    [44] = "\208\191\209\128\208\190\208\178\208\181\209\128\208\186\208\176 \208\189\208\176 \209\135\208\184\209\130\209\139",
    [45] = "main nick sanyaKiller228",
    [46] = "\208\145\208\190\209\128\208\184\209\129 \208\150\208\184\208\178\208\190\209\130\208\189\208\190\208\181",
    [47] = "bmw top",
    [48] = "\208\148\208\184\208\188\208\176[RUS]2005",
    [49] = "\208\184\209\129\208\187\208\176\208\188 \208\188\208\176\208\179\208\190\208\188\208\181\208\180\208\190\208\178",
    [50] = "\208\162\208\152\208\156\208\144\208\162\208\152\208\165\208\146\208\165",
    [51] = "eldoradohvh",
    [52] = "\208\177\209\131\208\187\209\140\209\130\208\176\208\183\208\176\209\128",
    [53] = "\209\143 \208\181\208\177\208\187\208\176\208\189 \208\177\208\184\208\179\208\184\209\130\208\184",
    [54] = "pavlo.matvei98",
    [55] = "www.CSGOSETTINGS.ru 111",
    [56] = "\208\188\208\176\208\188\208\186\208\176\208\181\208\1772009",
    [57] = "\209\132\209\131\208\179\208\176\209\129 \209\130\208\184\208\188\208\190\209\133\208\176",
    [58] = "VLAD_\208\159\208\163\208\161\208\162\208\158\208\153",
    [59] = "\208\146\208\181\208\187\208\184\208\188\208\184\209\128 (Not Cheater)",
    [60] = "\208\158\208\191\208\144$\208\189\208\171\208\185 \208\188\208\176\209\129\209\130\208\181\209\128 \208\186\208\187\208\176\209\130\209\135\208\181\208\185 \208\187\208\181\209\133\208\176 \208\181\208\177\208\176\209\130\209\140",
    [61] = "KirillMachine",
    [62] = "THIS IS OMLEEEEEEET (\226\151\163\226\151\162)",
    [63] = "soldier (\209\129\208\190\208\187\208\180\208\176\209\130)",
    [64] = "-----= S.E.N.A.T.O.R =-----",
    [65] = "*-\208\154\209\128Y\209\135E_\208\145\208\190\208\179\208\176_u_\208\166\208\176\208\160\209\143-*",
    [66] = "\225\180\155\202\156\225\180\135\202\153\225\180\135s\225\180\155",
    [67] = "\226\153\165\194\167\226\130\173\195\174\226\132\146\200\180\226\138\149\225\151\169\225\153\161\199\158\226\132\153\226\132\176\226\132\156\226\130\179\240\159\142\134",
    [68] = "GloBal~BaNaN",
    [69] = "Fucking.Ba[nn]Y...",
    [70] = "d[oo]dLeZzzz...",
    [71] = "VIP Sex Energy VIP",
    [72] = "\240\159\165\145\240\157\149\146\240\157\149\167\240\157\149\146\240\157\149\148\240\157\149\146\240\157\149\149\240\157\149\160\240\159\165\145",
    [73] = "\228\185\130...\240\157\148\161.\240\157\148\166.\240\157\148\168.\240\157\148\166.y...\228\185\130",
    [74] = "\226\149\145\226\152\190 \196\166 \206\158 \226\136\128 \229\141\131 \206\163 \229\176\186\226\149\145",
    [75] = "\229\189\161[\225\180\133\225\180\135\225\180\128\225\180\133 \225\180\139\201\170\202\159\202\159\225\180\135\202\128]\229\189\161",
    [76] = "\202\128\225\180\135\225\180\152 \201\170\201\180s\225\180\128\201\180\225\180\135 \225\180\161\201\170\225\180\155\202\156 \225\180\128\225\180\161\225\180\152",
    [77] = "\208\161\208\191\209\131\208\180\208\184 \208\156\209\131\208\189",
    [78] = "\225\151\171\225\131\162\226\130\166\226\132\139\226\132\177\199\190\226\132\156",
    [79] = "\226\152\162\196\142\226\130\179\195\145\199\164\196\146\226\132\159\226\152\162",
    [80] = "\196\162\197\151\196\133\197\134\196\143_\226\130\165\196\133\239\174\144\197\167\206\190\197\151",
    [81] = "F@$$$TiK...",
    [82] = "...::::K[RAM]m[ER]::::...",
    [83] = "\208\190\208\191\208\181\209\128 \208\190\208\186\208\176\209\143\208\189\208\189\209\139\208\185",
    [84] = "\208\148\208\158\208\157\208\144\208\162 \208\161 PAYPAL",
    [85] = "shelzi228",
    [86] = "\209\132\208\176\209\128\209\136",
    [87] = "\209\130\208\176\208\189\209\134\209\131\209\142 \208\187\208\181\208\183\208\179\208\184\208\189\208\186\209\131",
    [88] = "OPER\209\131\208\191\208\190\208\187\208\189\208\190\208\188\208\190\209\135\208\181\208\189\208\189\209\139\208\185",
    [89] = "2 \208\190\209\133\208\187\208\176\208\182\208\180\208\181\208\189\208\189\209\139\209\133 \209\143\208\185\209\134\208\176",
    [90] = "\208\188\208\176\208\183\208\184\208\186 \208\190\208\186\208\176\209\143\208\189\208\189\209\139\208\185",
    [91] = "Ballin' Maut",
    [92] = "Balin`Shprot",
    [93] = "MILLIONAR Balin",
    [94] = "\208\154\208\160\208\144\208\168 \208\162\208\149\208\161\208\162 \208\156\208\144\208\160\208\154 2",
    [95] = "\226\128\139HVH RACING",
    [96] = "\208\186\208\187\209\131\208\177\208\189\208\184\209\135\208\189\208\190-\208\178\208\184\209\136\208\189\208\181\208\178\209\139\208\185 \209\129\208\187\208\190\208\189\209\143\209\128\208\176",
    [97] = "\209\143\208\177\208\187\208\190\209\135\208\189\209\139\208\185 \208\179\208\184\208\191\208\190\208\191\208\190\209\130\208\176\208\188",
    [98] = "\208\186\209\128\208\190\208\187 \209\128\208\182\208\176\209\135\208\189\209\139\208\185 \208\176\208\177\209\128\208\184\208\186\208\190\209\129\208\190\208\178\209\139\208\185",
    [99] = "\208\144\208\179\209\128\208\181\209\129\209\129\208\184\208\178\208\189\209\139\208\185 \208\186\208\176\209\128\208\177\209\142\209\128\208\176\209\130\208\190\209\128",
    [100] = "tw1x^zz1^aced1v1",
    [101] = "s1mple",
    [102] = "\234\167\129\226\132\179a\226\178\166\226\177\148\201\170\226\132\163a\225\186\149\226\177\148\201\170\226\156\158\234\167\130",
    [103] = "\226\128\162\225\180\174\225\180\172\225\180\176\202\153\225\180\143\202\143\227\131\132",
    [104] = "\234\167\129\224\166\148\224\167\163\226\152\172\226\156\158\240\157\147\147\240\157\150\148\240\157\150\147\226\156\158\226\152\172\224\166\148\224\167\163\234\167\130",
    [105] = "\226\136\134\226\153\163\239\184\143JOKER\226\153\165\239\184\143\226\136\134",
    [106] = "SpraY",
    [107] = "\234\167\129\224\188\186\226\130\166\208\135\226\130\166\226\132\145\226\130\179\224\188\187\234\167\130",
    [108] = "\226\158\162 I\225\180\141\225\180\141\225\180\143\202\128\225\180\155\225\180\128\202\159",
    [109] = "\226\149\190\226\148\129\226\149\164\227\131\135\226\149\166\239\184\187 \226\130\179\226\130\173-\226\157\185\226\157\188 \240\157\147\176\240\157\147\184\240\157\147\173",
    [110] = "\239\184\187\227\131\135\226\149\144\228\184\128GOD_SK",
    [111] = "\240\159\133\188*\240\159\133\176\239\184\143*\240\159\134\133*\240\159\133\180*\240\159\134\129*\240\159\133\184*\240\159\133\178*\240\159\133\186",
    [112] = "\224\188\186Le\205\165ge\205\163n\205\171d\224\188\187\225\180\179\225\181\146\225\181\136",
    [113] = "\234\167\129\226\156\170\226\153\149BOT\226\153\149\226\156\170\234\167\130",
    [114] = "\240\159\148\165\240\157\147\150\240\157\147\161\240\157\147\144\240\157\147\162\240\157\147\164\240\159\148\165",
    [115] = "T\195\152XIC",
    [116] = "\240\157\149\181\240\157\150\134\240\157\148\179\240\157\150\142\240\157\150\142 \226\156\170",
    [117] = "\240\159\133\180\240\159\134\137\240\159\134\137 \240\159\133\189\240\159\133\190\239\184\143\240\159\133\190\239\184\143\240\159\133\177\239\184\143\240\159\134\130",
    [118] = "\234\167\129\224\188\186J\204\189\205\147o\204\189\205\147s\204\189\205\147I\204\189\205\147\224\188\187\234\167\130",
    [119] = "\226\153\161 AWP \226\128\147 senpai \226\151\149\226\128\191\226\151\149 [\227\131\132]",
    [120] = "\227\131\133 [OnI-ChaN] FreSH[x]\226\152\170\239\184\143",
    [121] = "\234\167\129\225\180\179\225\181\146\225\181\136Slayer\234\167\130",
    [122] = "\224\188\186Le\205\165ge\205\163n\205\171d\224\188\187",
    [123] = "\226\156\170\226\130\166\208\135\226\130\166\226\132\145\226\130\179\224\188\187\239\184\187\227\131\135\226\149\144\228\184\128",
    [124] = ".S!ckBoY^",
    [125] = "\240\157\149\190\240\157\150\153\240\157\150\154\240\157\150\151\240\157\150\146\240\157\149\189\240\157\150\138\240\157\150\135\240\157\150\138\240\157\150\145\240\157\150\145",
    [126] = "\226\153\165\239\184\143\240\157\147\154\240\157\147\174\240\157\147\157\240\157\147\157\240\157\148\130\240\157\147\162\226\153\165\239\184\143",
    [127] = "Snax",
    [128] = "\234\167\129\224\166\148\224\167\163\226\152\172\226\156\158\240\157\147\181\240\157\147\174\240\157\147\176\240\157\147\174\240\157\147\183\240\157\147\173\203\161\225\181\146\225\181\155\225\181\137 \202\184\225\181\146\225\181\152\226\156\158\226\152\172\224\166\148\224\167\163\234\167\130",
    [129] = "\226\153\149\209\149\208\189\209\148 \194\162\206\177\226\132\147\226\132\147 \208\188\209\148 \208\189\206\177\194\162",
    [130] = "\226\156\170AnARcHY_",
    [131] = "bl1tz",
    [132] = "Carry Potter",
    [133] = "\226\156\170TaCt1CaL",
    [134] = "vk.com/vampire",
    [135] = "\225\151\176E\225\151\176E \225\148\149E\225\145\142\225\148\149E",
    [136] = "\226\128\157*\194\176\226\128\162.\226\152\133..Angel_Of_The_Night..\226\152\133.\226\128\162\194\176*\226\128\157\203\156",
    [137] = "\195\177\198\164\195\188\206\178\194\163\207\175 \206\168\208\189\211\185\198\164\209\140 \207\175\194\163\225\131\156\209\143 \194\163\225\131\156\194\163\207\175 j\194\163\194\167\201\165\194\167",
    [138] = "\196\153\206\178\195\163\197\130 \200\155\195\189\195\164 \226\136\154 \197\153\195\184\197\163",
    [139] = "\229\191\141\227\129\179 1 \208\163\208\159\208\144\208\155 \227\129\179\229\191\141",
    [140] = "MaJIeHkuu_Ho_OnacHekuu",
    [141] = "\226\128\162\219\169\219\158\219\169[\204\178\204\133\208\159\204\178\204\133\208\190\204\178\204\133\208\155\204\178\204\133\208\174\204\178\204\133\208\177\204\178\204\133\208\144\204\178\204\133\208\161(\217\191)\204\178\204\133\208\167\204\178\204\133\208\184\204\133\208\162\204\178\204\178\208\144\208\154\204\178\204\133]\219\169\219\158\219\169\226\128\162",
    [142] = "Y\208\177\208\152u\208\166\208\176_\208\154\209\128\208\152\208\191\208\149r\208\158\208\178",
    [143] = "\208\162\208\181\208\191\208\181\209\128\209\140 \209\143 - \208\174\209\130\209\131\208\177\208\181\209\128 \208\158\208\188\208\187\208\181\209\130 (\226\151\163\226\151\162)",
    [144] = "\226\146\182a\197\180\195\158 \239\184\187\227\131\135 \228\184\128 PUTIN",
    [145] = "VAAAAAAAC \208\178 \209\135\208\176\209\130!!! (\227\129\165 \226\151\149\226\128\191\226\151\149 )",
    [146] = "\227\129\165 \228\187\142\233\151\169\228\187\142\233\149\191\228\184\171 \228\187\168\228\186\148\233\151\169\228\186\186",
    [147] = "+Yeb@shu_v_k@shu+",
    [148] = "\194\163\225\131\156\195\191 \207\175\209\143",
    [149] = "AHHAHAHHAHAHH LIFEHACK \226\153\165\239\184\143\226\153\165\239\184\143\226\153\165\239\184\143\226\153\165\239\184\143\226\153\165\239\184\143",
    [150] = "\208\159\209\131\208\155\208\184_\208\158\209\130_\208\145\208\176\208\145\209\131\208\155\208\184",
    [151] = "\208\159\208\176\208\160\208\181\208\157\209\140 \208\145\208\181\208\151 \209\129\208\162\209\128\208\144\209\133\208\144",
    [152] = "\208\157.\208\149.\208\161.\208\158.\208\154.\208\160.\208\163.\208\168.\208\152.\208\156.\208\171.\208\153",
    [153] = "KpyToI_4elOBeK",
    [154] = "^^Stell^^::.[Pro_Game_Xom9k]",
    [155] = "3Jlou_\208\151AdrOT",
    [156] = "\195\177\195\188\209\171\194\164\198\164 \195\177\195\188\198\186\209\171\195\165 \207\175\195\191\198\186 \201\177\194\164\208\189\194\164\200\185\209\143",
    [157] = "\209\143 \196\183\194\164\208\189\201\165\195\165\206\187 \207\175\206\178\194\164\194\163\195\188 \201\177\195\165\201\177\196\183\194\163 \206\178 \198\164\194\164\207\175",
    [158] = "\226\146\182a\197\180\195\158 \239\184\187\227\131\135 \228\184\128",
    [159] = "\208\186\208\190\208\188\209\129\208\190\208\188\208\190\208\187\209\140\209\129\208\186\208\184\208\185 \209\134\209\139\208\179\208\176\208\189",
    [160] = "\208\189\208\190\209\129\208\176\209\130\209\139\208\185 \208\189\208\190\209\129 \209\128\208\176\208\185\208\183\208\181\208\189\208\176",
    [161] = "\208\176\209\136\208\186\209\131\208\180\208\184\209\136\208\186\208\176 \209\129\208\190 \208\178\208\186\209\131\209\129\208\190\208\188 \209\131\209\133\208\176",
    [162] = "pepper roni (\208\191\208\184\209\134\209\134\208\176) \209\129\208\190 \208\178\208\186\209\131\209\129\208\190\208\188 \209\129\208\188\208\181\209\130\208\176\208\189\209\139",
    [163] = "METAN HVH",
    [164] = "\208\168\208\146\208\149\208\148\208\161\208\154\208\152\208\153 \208\161\208\162\208\158\208\155 \208\147\208\160\208\152\208\147\208\158\208\160\208\152\208\175 \208\155\208\149\208\159\208\161\208\144",
    [165] = "\208\144\208\144\208\144\208\144\208\144 \208\154\208\171\208\151\208\155\208\144\208\160 \208\154\208\163\208\162\208\144\208\154 \208\145\208\144\208\161 \208\144\208\168\208\144\208\155\208\144\208\156\208\144\208\157\208\144\208\144\208\144 \208\145\208\152\208\155\208\175\208\175\208\175 \208\173\208\163\208\163\208\163",
    [166] = "Z V",
    [167] = "\208\161\208\155\208\171\208\168\208\163 ZOV",
    [168] = "\208\162\208\174\208\164\208\175\208\175\208\175\208\154 (\208\159\208\144\208\162\208\160\208\152\208\154)",
    [169] = "GuGu_Zha_IIIagu",
    [170] = "GyGaBait",
    [171] = "ebaWu_V_KaWu (Z)",
    [172] = "\208\156\208\144\208\156\208\152\208\157\208\158 \208\159\208\160\208\158\208\162\208\152\208\146\208\158\208\160\208\149\208\167\208\152\208\149",
    [173] = "Nell\209\143\209\135\208\186\208\176 UwU",
    [174] = "\208\164\208\184\208\187\209\140\208\188 \194\171\208\163\208\187\209\139\208\177\208\186\208\176\194\187",
    [175] = "\208\154\208\190\209\130\208\187\208\181\209\130\208\190\209\129\209\139 \208\184\208\183 z\209\139\209\128\208\176",
    [176] = "\208\154\208\176\208\186\208\176\208\190 \208\177\208\190\208\177\208\181\209\128",
    [177] = "\208\164\208\176\208\187\209\140\209\136\208\184\208\178\208\176\209\143 \209\131\209\130\208\186\208\176",
    [178] = "\208\160\209\139\209\129\208\186\208\176\208\189\208\184\208\181 \208\189\208\184\208\182\208\189\208\181\208\185 \209\135\208\176\209\129\209\130\208\184 \209\130\208\181\208\187\208\176",
    [179] = "\208\179\209\131\209\129\208\181\208\185\208\189 \208\179\208\176\208\183",
    [180] = "\209\130\209\131\208\176\208\187\208\181\209\130\208\189\209\139\208\185 \209\131\209\130\209\142\208\179",
    [181] = "\208\147\208\176\208\183\208\190\208\178\208\176\208\189\208\184\209\143 \208\189\208\176 \209\131\208\180\208\176\209\135\209\131",
    [182] = "\209\129\208\191\208\184\209\128\208\176\208\187\209\140 \208\188\208\176\208\189\209\139",
    [183] = "\208\159\208\190\208\180\208\186\208\190\208\178\208\176 \209\129\209\128\208\176\208\186\208\190\209\130\208\176\208\189\208\176",
    [184] = "\208\148\209\131\208\191\208\187\208\190 \209\133\208\190\208\188\209\143\208\186\208\176",
    [185] = "\208\145\208\181\208\187\209\140\209\135\208\184\208\185 \208\176\209\131\208\187",
    [186] = "\208\175\208\151\208\171\208\154 \208\162\208\149\208\155\208\144",
    [187] = "\209\130\209\142\208\187\209\140\208\191\208\176\208\189\208\190\208\178\209\139\208\181 \208\179\208\190\209\128\209\139 \209\128\208\176\208\180\208\190\209\129\209\130\208\184",
    [188] = "\208\161\209\139\209\128 \208\177\209\139\208\177 \209\128\209\139\209\128",
    [189] = "\208\168\208\184\208\188\208\191\208\176\208\189Z\208\181 (\208\190\208\177\208\184\208\180\208\186\208\176)",
    [190] = "\208\155\208\190\208\182\208\189\209\139\208\181 \208\190\209\130\209\129\209\130\208\176\208\178\208\176\208\189\208\184\209\143",
    [191] = "\208\146\208\177\208\184\208\178 / \208\178\209\139\208\177\208\184\208\178 \208\183\209\131\208\177\208\190\208\178 \208\179.\208\163\209\128\209\142\208\191\208\184\208\189\209\129\208\186",
    [192] = "\208\147\209\131\209\129\208\181\208\185\208\189 \208\179\208\176\208\183\209\131\208\185 \208\189\208\176\209\133",
    [193] = "\208\151\208\181\208\189\208\184\209\134\208\176 \208\190\208\186\208\190",
    [194] = "Zorix(csgo)",
    [195] = "\208\159\208\184\208\180\208\181\209\128 \208\191\208\176\208\185\208\180\208\181\209\128",
    [196] = "\208\151\209\131\208\177\209\139 \208\188\209\131\208\180\209\128\208\190\209\129\209\130\208\184",
    [197] = "\208\169\208\181\208\186\208\190\209\130\208\189\208\190\208\181 \209\130\208\181\209\128\208\181\208\177\208\190\208\189\209\140\208\186\208\176\208\189\209\140\208\181",
    [198] = "ZELTR1X",
    [199] = "ZOLDY1337",
    [200] = "K1neXj.",
    [201] = "Evolvex",
    [202] = "ANGELS HVH",
    [203] = "\208\168\208\181\209\129\209\130\208\176\209\143 \208\191\209\143\209\130\208\186\208\176",
    [204] = "\208\156\208\190\208\183\208\190\208\187\208\184\209\129\209\130\209\139\208\185 \209\136\208\176\208\187\208\190\208\191\208\176\208\185",
    [205] = "\209\130\209\142\209\128\208\181\208\188\209\129\208\186\208\184\208\185 \209\131\208\183\209\131\209\128\208\191\208\176\209\130\208\190\209\128",
    [206] = "\208\161\209\130\208\190\209\143\208\186 \208\191\209\139\209\133\209\130\209\131\208\189",
    [207] = "\208\157\208\176\209\130\208\190\208\191\209\130\209\139\209\136\208\184",
    [208] = "\208\157\208\176\208\177\209\128\208\176\208\187 \208\180\208\190\208\187\208\179\208\190\208\178",
    [209] = "\208\151\208\176\208\177\208\184\208\178 \208\186\208\176\208\187\209\140\209\143\208\189\208\190\208\178",
    [210] = "\208\162\209\131\209\128\208\189\208\184\209\135\208\186\208\190\208\178\208\176\209\143 \208\183\208\176\208\177\208\184\208\178\208\186\208\176",
    [211] = "\208\162\209\128\208\181\208\189\208\184\209\128\208\190\208\178\208\186\208\176 \208\191\208\190\208\180 \208\180\208\190\208\182\208\180\208\181\208\188",
    [212] = "\208\148\209\128\208\190\209\135\209\131 \209\129\209\130\208\190\209\143",
    [213] = "\208\153\208\190\208\182\208\184\208\186 \208\182\209\131\209\133\208\187\209\139\208\185",
    [214] = "\208\149\209\133\208\184\208\180\208\189\208\176\209\143 \209\133\208\176\209\128\209\143",
    [215] = "\208\154\208\176\208\185\209\132\208\181\209\134\208\186\208\184\208\185 \208\186\209\131\208\188\208\176\209\128\209\135\208\184\208\186",
    [216] = "\208\154\208\144\208\160\208\162\208\158\208\164\208\149\208\155\208\172",
    [217] = "SANCHEZJ X FIPP",
    [218] = "\208\147\208\149\208\158\208\160\208\147\208\152\208\153 \208\164\208\144\208\156\208\163\208\162\208\152\208\155\208\158\208\146",
    [219] = "\208\144\208\151\208\144\208\151\208\144\208\151\208\144\208\151\208\144 \208\144\208\151\208\155\208\144\208\147\208\158\208\160",
    [220] = "\208\160\208\181\208\177\208\181\208\189\208\190\208\186 \208\191\208\190\208\180\208\186\208\184\208\180\209\139\209\136\209\140",
    [221] = "\208\148\208\149\208\162\208\152 \208\146 \208\159\208\158\208\148\208\146\208\144\208\155\208\149",
    [222] = "\208\161\208\162\208\152\208\146\208\144\208\165\208\144",
    [223] = "\208\164\209\128\208\190\209\129\209\130 \209\129\208\189\208\181\208\185\208\186 \208\184 \208\191\208\176\209\128\208\189\208\184\209\136\208\176",
    [224] = "\208\162\208\152\208\156\208\158\208\164\208\149\208\153 \208\152 \208\149\208\147\208\158 \208\148\208\160\208\163\208\147 \208\159\208\172\208\175\208\157\208\171\208\153 \208\149\208\147\208\158\208\160",
    [225] = "\208\151\208\176\208\177\208\187\208\190\208\186\208\184\209\128\208\190\208\178\208\176\208\189\208\189\209\139\208\185 \209\129\208\186\208\176\208\185\208\191",
    [226] = "\208\148\208\158\208\154\208\162\208\158\208\160 \208\145\208\160\208\144\208\163\208\157? \209\129\208\187\209\131\209\136\208\176\209\142.",
    [227] = "\208\144\208\160\208\158\208\156\208\144\208\162 \208\151\208\152\208\160\208\144\208\159\208\162\208\158\208\160\208\161\208\144 \208\161\208\161\208\171\208\162 \208\146 \208\160\208\144\208\154\208\158\208\146\208\152\208\157\208\163",
    [228] = "\208\161\208\154\208\144\208\144\208\144\208\153",
    [229] = "\208\148\208\190\208\186\209\130\208\190\209\128 \208\177\208\176\208\177\209\131\208\189",
    [230] = "\208\189\208\184\209\130\209\128\208\176\209\130 \209\132\208\176\208\177\209\131\209\128\208\184\209\130\208\176",
    [231] = "\209\135\208\181\209\128\208\189\208\190\208\179\208\190\208\187\208\190\208\178\208\186\208\176))",
    [232] = "\208\161\209\129\209\139\208\186\208\176\208\189\209\140\208\181 \208\178 \209\130\208\176\208\183\208\184\208\186",
    [233] = "\208\187\208\184\208\186\209\130\208\190\209\132\208\176\209\130 \208\189\208\176\209\130\209\128\208\184\209\143",
    [234] = "\208\156\209\139\209\130\209\140\208\181 \208\178 \208\177\208\184\208\180\208\190\208\189\208\181",
    [235] = "\208\189\208\184\208\191\208\190\209\128\209\130\208\176\208\188 \208\178 \209\128\208\176\208\186\208\190\208\178\208\184\208\189\208\181",
    [236] = "\208\178\209\139\208\179\209\131\208\187\208\184\208\178\208\176\209\130\209\140 \208\186\208\190\208\187\208\177\208\176\209\129\209\131 \208\178\208\188\208\181\209\129\209\130\208\190 \209\129\208\190\208\177\208\176\208\186\208\184 \208\189\208\176 \208\177\208\176\208\187\208\186\208\190\208\189\208\181",
    [237] = "\208\147\208\184\208\191\208\191\208\190\208\191\208\190\209\130\208\176\208\188 \209\129\209\139\209\128\208\189\209\139\208\185",
    [238] = "\208\183\209\131\208\191\208\184\209\132\208\176\208\187\209\140\208\189\209\139\208\185 \208\189\208\176\208\183\208\176\208\187\209\140\208\189\209\139\208\185 \209\129\208\191\209\128\208\181\208\185 \208\180\208\187\209\143 \208\189\208\190\208\179\209\130\208\181\208\185",
    [239] = "\208\159\208\184\208\180\208\190\209\128\209\129\208\186\208\184\208\181 \209\129\209\139\209\128\208\189\208\184\208\186\208\184",
    [240] = "\208\179\208\190\208\179\208\184 \208\189\208\176 \209\131\209\128\208\190\208\179\208\184",
    [241] = "GoGiMan777",
    [242] = "\208\154\208\176\209\128\208\176\208\188\208\181\208\187\209\140\208\189\209\139\208\181 \208\189\208\190\208\179\208\190\209\130\208\190\209\135\208\186\208\184",
    [243] = "\208\180\208\181\209\128\208\181\208\178\209\143\208\189\208\189\208\190\208\181 \209\143\208\177\208\187\208\190\208\186\208\190",
    [244] = "\208\176\209\128\208\177\209\131\208\183\208\189\209\139\208\181 \209\129\208\187\208\176\208\189\209\134\209\139",
    [245] = "hey? MACARENAA",
    [246] = "\209\130\209\128\208\184\209\134\208\181\209\128\208\176\208\191\209\130\208\190\209\128\209\129",
    [247] = "\208\165\208\190\209\128\208\190\209\136\208\176\209\143 \208\190\208\180\208\181\208\182\208\180\208\176",
    [248] = "LXNER \209\128\208\181\208\191\208\184\209\128",
    [249] = "\208\156\208\190\208\180\208\189\209\139\208\185 \208\191\209\128\208\184\208\179\208\190\208\178\208\190\209\128",
    [250] = "\209\129\209\130\209\131\208\180\208\181\208\189\209\130",
    [251] = "\208\160\208\181\208\187\208\184\208\183 sqwore",
    [252] = "\209\133\208\176\208\185\208\191\208\181\209\128\208\191\208\190\208\191 \209\129\208\176\208\188\208\176\209\128\208\176",
    [253] = "18\208\180\208\178\208\176\208\180\209\134\208\181\209\130\208\184\208\189",
    [254] = "\208\166\208\184\209\130\209\128\209\131\209\129 \208\190\209\130 \208\183\209\131\208\180\208\176",
    [255] = "\208\166\208\184\209\130\209\128\208\184\208\189\208\190\208\178\209\139\208\185 \208\186\208\176\209\136\208\181\208\187\209\140",
    [256] = "\208\162\208\176\208\189\208\180\209\131\208\188 \208\178\208\181\209\128\208\180\208\181 \209\132\208\190\209\128\209\130\208\181",
    [257] = "\208\162\208\144\208\145\208\163\208\157 \208\147\208\158\208\161\208\162\208\149\208\153",
    [258] = "\208\158\208\155\208\149\208\147 \208\162\208\152\208\157\208\172\208\154\208\158\208\164\208\164",
    [259] = "SAILOR MOON \208\160\208\158\208\145\208\149\208\160\208\162 \208\161 \208\144\208\160\208\145\208\163\208\151\208\158\208\156",
    [260] = "\208\154\208\158\208\151\208\144\208\165\208\161\208\162\208\144\208\157 \208\171\208\171\208\171\208\171\208\171\208\144\208\144\208\144\208\144\208\144\208\144\208\144",
    [261] = "\208\146\208\181\208\187\208\184\208\188\208\184\209\128 \209\129\208\191\208\184\209\128\208\184\208\180\208\190\208\189\208\190\208\178",
    [262] = "\208\146\208\176\209\133\208\184\208\180 \208\177\208\176\208\177\208\181\208\178",
    [263] = "\208\161\209\131\209\128\208\184\208\186\208\176\209\130\208\189\209\139\208\185 \209\130\209\131\209\136\208\186\208\176\208\189\209\135\208\184\208\186",
    [264] = "\208\144\208\183\208\184\208\183 \209\136\208\176\208\178\208\181\209\128\209\136\209\143\208\189",
    [265] = "\208\178\208\184\208\187\209\140\208\178\208\181\209\130\208\190\208\178\209\139\208\185 \208\190\209\129\209\140\208\188\208\184\208\189\208\190\208\179",
    [266] = "\208\186\208\190\208\187\208\177\208\176\209\129\208\176 \209\129 \208\187\209\139\209\129\209\139\208\188 \208\188\209\131\208\182\208\184\208\186\208\190\208\188",
    [267] = "\208\180\208\181\208\189\209\140\208\179\208\184 \208\184 \208\191\208\176\209\133\209\131\209\135\208\184\208\181 \208\189\208\190\208\179\208\184",
    [268] = "\208\154\208\176\209\128\208\176\209\129\209\140 \209\129\208\190 \209\129\209\130\209\128\208\176\208\183\208\176\208\188\208\184",
    [269] = "\208\160\208\171\208\145\208\144 \208\156\208\158\208\149\208\153 \208\156\208\149\208\167\208\162\208\152",
    [270] = "\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\175\208\151\208\172",
    [271] = "\208\162\209\131\208\189\208\181\209\134 \208\190\209\130 \209\133\208\176\208\187\208\184\208\186\208\184",
    [272] = "\208\154\208\176\208\188\208\177\208\176\208\187\208\176 \208\178 \208\178\208\176\208\189\208\189\208\181",
    [273] = "\208\186\208\176\208\187\209\140\209\143\208\189\208\184\208\183\208\176\209\134\208\184\209\143 \208\191\209\128\208\190\209\136\208\187\208\176 \209\131\209\129\208\191\208\181\209\136\208\189\208\190\240\159\140\185",
    [274] = "\209\136\208\184\209\136\208\186\208\176 \208\178 \208\188\209\139\209\136\208\186\208\181",
    [275] = "\208\159\208\187\208\190\209\130\208\189\208\190\208\181 \209\143\208\177\208\187\208\190\209\135\208\186\208\190",
    [276] = "\208\187\208\190\208\191\208\176\209\129\209\130\208\184 \208\188\208\184\208\186\209\128\208\190\209\132\208\190\208\189\208\176",
    [277] = "\208\154\209\131\208\188\208\176\209\128\208\189\208\176\209\143 \209\129\208\181\209\129\209\129\208\184\209\143",
    [278] = "\208\186\208\187\208\176\208\178\208\184\208\176\209\130\209\131\209\128\208\176 \208\184\208\189\209\132\208\190\209\128\208\188\208\176\209\130\208\184\208\186\208\176",
    [279] = "\208\159\209\128\208\190\208\177\208\184\209\128\208\186\208\176 \208\177\208\184\208\190\208\187\208\190\208\179\208\184\209\135\208\186\208\184",
    [280] = "\208\183\208\181\208\187\208\181\208\189\208\190\208\181 \208\189\208\181\208\177\208\190 \208\178 \208\183\208\176\208\186\208\176\209\130\208\181",
    [281] = "\209\130\208\181\208\188\208\189\208\190\208\181 \208\190\208\183\208\176\209\128\208\181\208\189\208\184\208\181 \209\130\208\181\208\191\208\187\208\176",
    [282] = "\208\191\208\181\208\189\209\143\209\137\208\181\208\181 \209\129\209\135\208\176\209\129\209\130\209\140\208\181",
    [283] = "\209\129\208\190 \209\129\208\186\208\184\209\130\209\131\208\187\209\140\208\186\208\190\208\185 \208\178 \208\188\208\188\209\131\208\187\209\142",
    [284] = "\208\177\208\190\208\179\208\176\209\130\209\139\208\181 \208\178\208\190\208\187\208\190\209\129\209\139 \208\186\208\184\209\128\208\186\208\190\209\128\208\190\208\178\208\176",
    [285] = "\208\152\208\179\209\128\208\176\209\142 \208\186\208\176\208\186 fifty",
    [286] = "\208\186\208\190\209\128\208\190\208\178\208\176 \209\128\208\184\208\188\208\183\208\176\208\186\209\129\208\176",
    [287] = "\208\160\208\176\208\188\208\190\208\189\209\139 \208\190\209\130 \209\129\208\181\209\128\208\181\208\179\208\184",
    [288] = "\208\191\209\131\209\130\208\184\208\187\209\140\209\132\208\176\209\130 \208\179\209\131\208\187\209\140\208\183\208\176\208\189\209\130\208\184\209\143 (\208\191\209\128\208\184\208\178\208\181\209\130)",
    [289] = "\209\128\208\176\209\132\209\139 \208\190\209\130 Raffaello",
    [290] = "\208\186\209\128\208\176\209\129\208\189\208\176\209\143 \208\188\208\176\209\136\208\184\208\189\208\176 \209\129 \208\180\208\181\209\128\208\181\208\178\208\190\208\188 \208\190\209\130 \208\191\208\184\209\130\208\190\208\187\209\140\208\180\209\139",
    [291] = "\208\159\209\128\208\184\208\186\208\190\208\187\209\140\208\189\209\139\208\185 \208\191\209\131\208\180\208\184\208\189\208\179 \208\190\209\130 \208\191\208\190\208\189\209\135\208\184\208\186\208\176",
    [292] = "\208\186\208\190\208\182\208\176\208\189\208\176\209\143 \209\129\209\130\208\181\208\189\208\176",
    [293] = "\208\191\208\190\208\180\209\129\209\130\208\190\208\187\209\140\208\189\209\139\208\181 \208\191\208\190\208\187\209\131\208\191\208\190\208\186\208\181\209\128\209\139",
    [294] = "\208\176\208\188\209\129\209\130\208\181\209\128\208\180\208\176\208\188 \208\179\208\184\208\187\209\140\208\179\208\190\208\189\208\176",
    [295] = "\208\151\208\178\208\190\208\189\208\190\208\186 \208\189\208\176 \209\131\209\128\208\190\208\186",
    [296] = "\208\162\208\176\208\177\209\131\209\128\208\181\209\130 \208\190\209\135\208\186\208\184 \209\131\209\129\209\139",
    [297] = "\208\167\208\184\209\130\208\176\209\142 \209\128\208\181\208\191\209\135\208\176\208\179\209\131",
    [298] = "\208\167\208\152\208\159\208\161\208\152 \208\158\208\162 \208\160\208\149\208\157\208\149\208\147\208\144\208\162\208\144 \208\162\208\144\208\162\208\144\208\160\208\161\208\154\208\158\208\147\208\158",
    [299] = "\208\162\208\144\208\162\208\144\208\160\208\161\208\154\208\152\208\153 MALIK163ONMYNECK",
    [300] = "\208\157\208\158\208\146\208\171\208\153 \208\160\208\149\208\159\208\152\208\160",
    [301] = "\208\146\208\163\208\156\208\159\208\152\208\160",
    [302] = "\208\189\208\190\209\129\208\176\209\130\208\190\208\181 \209\131\208\181\208\177\208\184\209\137\208\181",
    [303] = "\209\136\208\181\209\129\209\130\208\190\208\181 \209\135\209\131\208\178\209\129\209\130\208\178\208\190",
    [304] = "\208\182\208\190\208\191\208\189\209\139\208\185 \208\191\209\128\208\181\208\180\208\184\208\186\209\130",
    [305] = "\208\167\208\152\208\162\208\149\208\160\208\171 \208\152\208\156\208\149\208\174\208\162 6 \208\167\208\163\208\146\208\162\208\161\208\146\208\158",
    [306] = "\208\162\208\160\208\149\208\162\208\152\208\153 \208\147\208\155\208\144\208\151 \208\157\208\144 \208\159\208\160\208\144\208\146\208\158\208\153 \208\169\208\149\208\154\208\149",
    [307] = "\208\159\208\158\208\148\208\145\208\158\208\160\208\158\208\148\208\158\208\154 \208\146 \208\160\208\144\208\151\208\146\208\144\208\155 \208\161 \208\157\208\158\208\161\208\158\208\160\208\158\208\147\208\158\208\156",
    [308] = "\208\147\208\157\208\152\208\155\208\158\208\153 \208\163\208\162\208\174\208\147",
    [309] = "\208\159\208\172\208\175\208\157\208\144\208\175 \208\148\208\171\208\157\208\175",
    [310] = "\208\145\208\149\208\168\208\149\208\157\208\171\208\153 \208\154\208\144\208\160\208\162\208\158\208\164\208\149\208\155\208\172",
    [311] = "\208\159\209\140\209\143\208\189\209\139\208\185 \208\191\209\139\208\187\208\181\209\129\208\190\209\129",
    [312] = "UWU GANG",
    [313] = "\208\153\208\190\208\177\208\189\209\131\209\130\208\184\208\185 \208\181\208\182\208\184\208\186",
    [314] = "\208\149\208\182\208\184\208\186 \208\178 \209\130\209\131\208\188\208\176\208\189\208\181",
    [315] = "\208\156\208\176\208\189\209\131\208\187 \208\178 \208\183\208\190\208\190\208\191\208\176\209\128\208\186\208\181",
    [316] = "\209\130\208\181\208\188\208\189\209\139\208\185 \208\178\208\176\208\187\208\181\209\130",
    [317] = "\208\189\209\142\209\133\208\189\209\131\208\187 \208\191\208\190\208\180\208\188\209\139\209\133\208\176\209\128\208\184\208\186",
    [318] = "\209\131\209\136\208\176\209\129\209\130\208\190 \208\177\208\190\208\187\209\140\209\136\208\184\208\181 \208\177\209\128\208\190\208\178\208\184",
    [319] = "\208\191\208\190\209\133\208\190\208\182\209\131 \208\189\208\176 \209\143\208\189\208\180\208\181\208\186\209\129 \208\177\209\128\208\176\209\131\208\183\208\181\209\128",
    [320] = "\208\161\208\187\208\190\208\189 \208\189\208\176 \208\186\209\128\208\190\208\186\208\190\208\180\208\184\208\187\208\181",
    [321] = "\208\184\208\189\208\180\209\142\208\186 \208\178 \208\188\208\176\209\129\208\187\208\181",
    [322] = "\208\177\209\131\209\128\208\180\209\142\208\186 \209\129 \208\191\209\128\208\184\208\186\208\190\208\187\208\190\208\188",
    [323] = "\208\186\208\184\208\181\208\178\209\129\208\186\208\176\209\143 \208\186\208\190\209\130\208\187\208\181\209\130\208\176",
    [324] = "\209\136\208\184\208\187\208\190 \208\189\208\176 \208\188\209\139\208\187\208\190",
    [325] = "\208\145\208\176\208\177\209\131 \208\189\208\176 \208\186\208\176\208\188\208\181\208\189\209\140",
    [326] = "\209\134\209\131\208\186\208\181\209\128\208\177\208\181\209\128\208\179 \208\191\208\176\208\189\208\183\208\181\209\128\209\132\208\176\209\131\209\129\209\130 1337",
    [327] = "\208\183\208\176\208\191\208\190\209\128\208\190\208\182\209\140\208\181 9000",
    [328] = "\208\156\208\190\209\129\208\186\208\178\208\184\209\135 65",
    [329] = "\209\143 \209\135\209\130\208\190 \208\191\208\190\209\133\208\190\208\182 \208\189\208\176 \208\176\208\177\208\190\208\189\208\181\208\189\209\130\208\176",
    [330] = "\208\161\208\181\209\128\208\181\208\179\208\176 \208\180\209\131\209\128\208\189\209\139\208\185",
    [331] = "\208\184\208\178\208\176\208\189 \208\189\208\176\208\178\208\184",
    [332] = "\208\158\209\130\208\178\208\181\209\130 \208\189\208\176 \209\130\208\190\208\188 \208\186\208\190\208\189\209\134\208\181",
    [333] = "\208\161\208\178\208\181\209\130 \208\178 \208\189\208\176\209\135\208\176\208\187\208\181 \208\181\208\187\208\186\208\184",
    [334] = "\209\129\208\181\209\128\208\179\208\181\208\185 \209\132\208\176\208\186\208\181\208\187",
    [335] = "\209\133\209\131\208\185\208\191\208\176\209\129\209\130\209\128\208\184\208\191\209\129",
    [336] = "\209\133\209\131\208\185\208\191\208\176\209\135\208\184\208\191\209\129",
    [337] = "\208\165\209\131\208\185\208\191\208\176\209\129\208\190\208\187\209\140",
    [338] = "\208\165\209\131\208\185\208\191\208\176\208\177\209\131\209\128\208\179\208\181\209\128",
    [339] = "\208\160\208\184\209\129 \209\129 \208\186\208\176\209\129\209\139\208\188\208\176\208\186\208\190\208\188",
    [340] = "\208\161\208\186\208\176\208\187\208\181\208\189\208\176\209\136 \208\188\208\190\209\130\209\139\208\179\208\176",
    [341] = "\208\161\208\186\208\176\208\187\208\181\208\189\208\176\209\136 \209\130\208\176\208\186\209\139\209\136",
    [342] = "\209\135\208\184\209\132\208\184\209\128\208\190\208\186 \209\129 \208\179\208\190\209\128\209\143\209\137\208\184\208\188 \208\186\208\190\209\130\208\190\208\188",
    [343] = "\208\158\208\189\208\176 \209\129 \208\154\208\176\208\183\208\176\209\133\209\129\209\130\208\176\208\189\208\176",
    [344] = "\208\157\208\176\209\129\208\178\208\176\208\185 \208\189\208\181 \208\186\208\184\208\180\208\176\208\181\208\188 \209\141\209\130\208\190 \209\133\208\176\209\128\208\176\208\188 \209\133\208\176\209\128\208\176\208\188",
    [345] = "\209\131\209\129\208\176\209\130\208\190\208\181 \208\191\208\190\208\183\208\190\209\128\208\184\209\137\208\181",
    [346] = "\208\163\209\130\209\128\208\181\208\189\208\189\208\184\208\185 \208\189\208\176\208\188\208\176\208\183 \208\191\208\190\208\180 \208\186\208\176\208\189\209\131\208\189 \208\189\208\190\208\178\208\190\208\179\208\190 \208\179\208\190\208\180\208\176",
    [347] = "\208\188\209\139 \208\189\208\181 \208\180\208\181\208\187\208\176\208\181\208\188 \209\130\209\128\208\176\208\191 \208\188\209\139 \208\180\208\181\208\187\208\176\208\181\208\188 \208\177\208\190\208\187\209\140\209\136\208\184\208\181 \208\189\208\190\208\179\209\130\208\184",
    [348] = "\209\131\208\183\208\177\208\181\208\186 \209\128\209\131\209\129\209\129\208\186\208\184\208\185",
    [349] = "\208\157\208\176 \208\189\208\190\209\129\209\131 \208\179\208\181\209\128\208\190\208\184\208\189",
    [350] = "\208\151\208\176\208\178\208\184\209\129\208\184\208\188\209\139\208\185 \209\129\208\176\208\188\208\190\208\178\208\176\209\128",
    [351] = "\209\129\208\184\208\189\208\184\208\181 \208\178\208\190\208\187\208\190\209\129\209\139 \208\191\208\190\208\186\208\190\209\128\208\184\208\187\208\184 \208\189\208\181\208\177\208\190",
    [352] = "ZV \209\136\208\188\208\176\208\187\209\140 \208\178 \208\191\208\187\208\181\209\135\208\181",
    [353] = "\208\148\208\181\209\132\208\181\208\186\209\130\208\189\209\139\208\185 \208\191\208\181\209\128\209\132\208\190\209\128\208\176\209\130\208\190\209\128",
    [354] = "\209\129\208\176\208\188\208\190\208\178\209\139\209\128\208\176\208\182\208\176\209\142\209\137\208\184\208\185 \208\189\208\184\208\186\209\129\208\178\208\176\209\128",
    [355] = "\208\189\208\176\209\129\209\130\208\190\209\143\209\137\208\184\208\185 \208\191\209\131\208\177\208\181\209\128\209\130\208\176\208\189\209\130",
    [356] = "Gloria damn",
    [357] = "\208\176\208\189\209\130\208\190\208\187\208\190\208\179\208\184\209\143 \208\176\208\189\209\130\208\190\208\189\208\176",
    [358] = "gloria fuck",
    [359] = "cocki \209\143\208\186\208\184",
    [360] = "\208\186\208\184\209\130\208\176\208\185\209\129\208\186\208\184\208\185 \209\128\208\181\208\191",
    [361] = "\209\134\209\131\209\132\208\176\208\189\208\183\209\142 \209\132\208\176\208\188\208\181\209\128\208\179\208\181 (\209\133\208\178\209\133)",
    [362] = "\208\186\209\131\209\130\208\176\208\187\208\177\209\139\208\186 \209\136\209\131\209\128\208\176\208\177\208\183\208\184\208\186",
    [363] = "\209\130\209\131\208\191\208\190\208\185 \209\131\209\128\208\190\208\180",
    [364] = "\209\129\209\131\208\188\208\186\208\176 \209\129\208\190 \208\178\208\186\209\131\209\129\208\190\208\188 \208\178\208\184\209\130\208\176\208\187\209\140\208\186\208\184",
    [365] = "\209\135\208\181\209\128\208\181\208\191\208\176 \208\178 \208\176\209\132\208\179\208\176\208\189\208\184\209\129\209\130\208\176\208\189\208\181 \208\191\209\140\209\142\209\130 \208\188\208\184\208\186\209\128\208\190\209\132\208\190\208\189",
    [366] = "\208\191\208\184\209\130\209\140 \208\181\208\180\209\131 \208\181\209\129\209\130\209\140 \208\178\208\190\208\180\209\131",
    [367] = "\208\182\208\181\208\187\209\130\208\190\208\178\208\190\208\187\208\190\209\129\209\139\208\185 \208\191\208\176\209\129\208\191\208\190\209\128\209\130",
    [368] = "\208\191\208\184\208\183\208\180\208\181\209\134 \208\188\208\181\208\189\209\143 \209\128\208\176\209\129\208\191\208\181\209\128\208\187\208\190 \208\189\208\176\209\133\209\131\208\185 \209\135\208\181\208\187",
    [369] = "\208\151\208\176\208\187\208\190\208\179 \209\131\209\129\208\191\208\181\209\133\208\190\208\178",
    [370] = "\208\160\209\139\208\177\208\176 \208\178 \208\186\208\187\209\143\209\128\208\181",
    [371] = "\208\147\209\128\208\190\208\188\208\190\209\132\208\190\208\189",
    [372] = "\208\168\209\131\208\177\208\176 \208\191\208\190\208\180 \209\129\208\181\208\187\208\181\208\180\208\186\208\190\208\185",
    [373] = "\208\156\208\176\208\189\209\131\208\176\208\187 \208\191\208\190 \208\188\208\176\208\189\209\131\208\187\208\176\208\188",
    [374] = "\208\157\208\152\208\154\208\158\208\147\208\148\208\144 \208\157\208\149 \208\159\208\160\208\158\208\152\208\147\208\160\208\171\208\146\208\144\208\162\208\172",
    [375] = "\208\159\209\143\209\130\209\140\208\180\208\181\209\129\209\143\209\130",
    [376] = "\209\129\208\181\208\188\209\140\209\129\208\190\209\130 \208\180\208\181\209\129\209\143\209\130\209\140",
    [377] = "\208\179\209\128\209\143\208\188 \208\176\209\128\208\177\209\131\209\129\208\176",
    [378] = "\208\178\208\181\209\129 \209\133\208\176\209\135\208\176",
    [379] = "1\209\133\208\177\208\181\209\130",
    [380] = "yamete kudasai ^^",
    [381] = "\208\159\209\128\208\184\208\181\209\133\208\176\208\187\208\176 \209\135\208\184\209\133\209\131\208\176\209\133\209\131\208\176",
    [382] = "\209\135\208\184\209\133\208\189\209\131\208\187 \208\177\208\181\208\183 \209\129\208\187\208\181\208\183",
    [383] = "\208\176\208\187\209\140\208\191\208\181\208\189\208\184\209\129\209\130 \208\178 \208\191\208\181\209\129\208\186\208\181",
    [384] = "\208\145\208\176\208\189\208\176\208\189\208\190\208\178\209\139\208\185 \209\128\208\176\208\185",
    [385] = "\208\150\208\181\208\187\209\130\208\190\208\186 \208\189\208\176 \209\135\208\184\208\187\208\184\208\191\208\184\208\183\208\180\209\128\208\184\208\186\208\181",
    [386] = "\208\147\208\190\208\178\208\190\209\128\209\143\209\137\208\184\208\185 \208\191\208\190\209\128\209\130\209\129\208\184\208\179\208\176\209\128",
    [387] = "\208\159\208\181\209\128\208\181\208\178\208\181\209\128\208\189\209\131\209\130\208\176\209\143 \208\186\208\176\208\189\208\176\209\128\208\181\208\185\208\186\208\176",
    [388] = "\208\182\208\181\209\129\209\130\208\186\208\184\208\185 \208\186\208\184\208\189\208\190\209\130\208\181\208\176\209\130\209\128",
    [389] = "\208\151\208\184\208\188\208\189\208\181\208\181 \208\187\208\181\209\130\208\190",
    [390] = "\209\130\209\128\208\181\209\130\208\184\208\185 \208\191\208\190\208\180\208\177\208\190\209\128\208\190\208\180\208\190\208\186",
    [391] = "\208\155\209\140\209\142 \208\187\208\184\208\188\208\190\208\189\208\176\208\180 \208\188\208\184\208\188\208\190 \209\128\209\130\208\176",
    [392] = "\208\159\208\181\209\128\208\181\208\183\208\176\209\128\209\143\208\182\208\176\209\142 \208\186\208\181\209\132\208\184\209\128",
    [393] = "\208\186\208\176\209\136\208\187\209\143\209\142 \209\133\209\141\209\136\208\181\208\188",
    [394] = "\208\156\208\190\208\187\208\190\208\186\208\190 2 \208\187\208\184\209\130\209\128\208\176",
    [395] = "\208\186\208\190\208\187\208\177\208\176\209\129\208\176 \209\129 \208\186\208\176\208\191\209\131\209\129\209\130\208\190\208\185 \208\180\208\176 \208\181\209\137\208\181 \208\184 \209\129 \208\191\208\181\209\135\208\181\208\189\209\140\208\181\208\188",
    [396] = "\208\180\208\176 \208\184 \208\178 \208\191\209\128\208\184\208\186\209\131\209\129\208\186\209\131 cock\208\176 \208\186\208\190\208\187\208\176",
    [397] = "\208\165\208\184\209\130\209\128\209\139\208\185 \208\186\209\129\208\184\208\188\208\184",
    [398] = "\208\157\208\190\208\178\208\190\208\188\208\190\208\180\208\189\209\139\208\185 vertu",
    [399] = "\208\184\208\189\209\130\208\181\209\128\208\189\208\181\209\130 \208\186\208\176\208\177\208\181\208\187\209\140",
    [400] = "\208\162\208\181\208\187\208\181\209\132\208\190\208\189\208\189\209\139\208\185 \209\136\208\189\209\131\209\128",
    [401] = "\209\136\208\189\209\131\209\128 \208\180\208\187\209\143 \208\177\209\128\208\184\209\130\209\140\209\143",
    [402] = "\208\145\208\176\209\128\208\176\208\177\208\176\209\136\208\186\208\176 \208\177\208\181\208\183 \208\186\208\176\209\130\209\131\209\136\208\181\208\186",
    [403] = "\208\156\208\190\208\186\209\128\208\190\208\181 \208\177\208\181\208\187\209\140\208\181",
    [404] = "\209\143\208\185\209\134\208\190 \209\129\208\190 \209\129\209\130\209\128\208\184\208\191\209\129\208\190\208\188 \208\178 \209\131\209\133\208\181",
    [405] = "\208\188\208\190\208\184 \208\188\209\139\209\129\208\187\208\181 \208\189\208\176 \208\188\209\139\208\187\208\181 \208\190\208\189\208\184 so low",
    [406] = "\208\146 \208\167\208\149\208\160\208\157\208\158\208\156 \208\161\208\159\208\152\208\161\208\154\208\149",
    [407] = "\209\130\208\184\208\186\208\184 \209\130\208\190\208\186\208\184 \208\190\209\130 \208\177\209\131\209\128\208\188\208\176\208\187\208\180\209\139",
    [408] = "\209\131\209\136\208\176\209\129\209\130\209\139\208\185 \209\136\208\190\208\186\208\190\208\187\208\176\208\180",
    [409] = "\208\188\209\139\209\136\208\186\208\176 \208\187\208\190\208\179\208\184YECH",
    [410] = "MinYEAT",
    [411] = "\208\156\208\152\208\157\208\172\208\149\208\162",
    [412] = "\208\147\208\176\209\128\208\184\208\186 \208\180\208\190 \209\135\208\181\208\187\209\142\209\129\209\130\208\184",
    [413] = "\208\158\208\177\208\184\208\180\209\135\208\181\208\178\209\139\208\185 \209\136\208\186\208\190\208\187\209\140\208\189\208\184\208\186",
    [414] = "\208\159\208\144\208\145\208\144\208\154\208\144 \208\163\208\155\208\171\208\145\208\144\208\154\208\144",
    [415] = "\208\163\208\165-\208\162\208\171-\208\150-\208\153\208\158!",
    [416] = "\208\149\209\130\208\184\208\182\208\184 \208\191\208\176\209\129\209\129\208\176\209\130\208\184\208\182\208\184",
    [417] = "\208\168\208\184\208\187\208\190 \208\178 \209\128\209\139\208\187\208\190",
    [418] = "\208\155\208\176\208\185\209\132 \208\178 \208\186\208\176\208\185\209\132",
    [419] = "\208\154\208\144\208\153\208\164 \208\155\208\144\208\153\208\164",
    [420] = "Zahar bobr",
    [421] = "\208\146\208\181\209\128\208\176 \208\178 \208\183\208\176\208\188\208\176\209\143",
    [422] = "15 \208\179\208\190\208\180 \209\141\209\130\208\190 \208\178\208\176\208\182\208\189\208\190",
    [423] = "\208\154\208\190\208\187\209\143 \209\133\208\181\208\185\209\130\208\181\209\128",
    [424] = "\208\191\208\184\209\129\209\142\208\189\208\184\209\129\209\130\209\139\208\185 \209\132\208\176\208\186\209\131\208\187\209\140\209\130\208\181\209\130",
    [425] = "\208\178\209\129\208\181\208\188 \209\129\208\191\208\176\209\130\209\140",
    [426] = "\208\178\208\181\208\187\209\140\208\178\208\181\209\130\208\190\208\178\209\139\208\185 \208\190\209\129\209\140\208\188\208\184\208\189\208\190\208\179",
    [427] = "\208\188\209\143\209\129\208\189\208\190\208\185 \208\188\208\181\208\180\208\178\208\181\208\180",
    [428] = "first day with neverlose.cc",
    [429] = "https://vk.com/avtopodborkazahstan",
    [430] = "\208\163\209\129\208\191\208\181\209\136\208\189\209\139\208\185 \208\176\208\178\209\130\208\190\208\188\208\190\208\177\208\184\208\187\208\184\209\129\209\130",
    [431] = "\208\176\208\178\209\130\208\190\208\191\208\190\208\180\208\177\208\190\209\128 KZ",
    [432] = "\208\145\208\176\208\183\208\190\208\178\208\176\209\143 \208\184 \208\191\208\190\208\187\208\189\208\176\209\143",
    [433] = "\208\188\208\176\208\185 \208\176\208\187\208\188\208\176\208\185\208\180\209\139!",
    [434] = "\208\144\209\129\209\130\209\139 \209\130\208\176\208\183\208\176, \209\129\209\130\208\176\208\186\208\176\208\189\208\180\208\176\209\128\209\139 \209\129\208\176\209\131"
};
do
    local l_v1373_18, l_v1525_16, l_v1526_15, l_v1527_15, l_v1528_15, l_v1529_18 = v1373, v1525, v1526, v1527, v1528, v1529;
    l_v1528_15 = function()
        -- upvalues: l_v1526_15 (ref)
        if l_v1526_15 == nil then
            return;
        else
            common.set_name(l_v1526_15);
            l_v1526_15 = nil;
            return;
        end;
    end;
    l_v1529_18 = function()
        -- upvalues: l_v1528_15 (ref)
        l_v1528_15();
    end;
    v1530 = nil;
    v1531 = function()
        -- upvalues: l_v1526_15 (ref), l_v1525_16 (ref), l_v1373_18 (ref), l_v1529_18 (ref)
        if l_v1526_15 == nil then
            l_v1526_15 = l_v1525_16:string();
        end;
        common.set_name(l_v1373_18.input:get());
        events.shutdown(l_v1529_18, true);
    end;
    v1532 = function()
        -- upvalues: l_v1528_15 (ref), l_v1529_18 (ref)
        l_v1528_15();
        events.shutdown(l_v1529_18, false);
    end;
    v1533 = function()
        -- upvalues: l_v1527_15 (ref), l_v1373_18 (ref)
        local v3340 = l_v1527_15[math.random(1, #l_v1527_15)];
        l_v1373_18.input:set(v3340);
    end;
    l_v1373_18.set_button:set_callback(v1531);
    l_v1373_18.reset_button:set_callback(v1532);
    l_v1373_18.generate_button:set_callback(v1533);
end;
v889 = nil;
v890 = {
    [1] = "crash",
    [2] = "flush",
    [3] = "buildmodelforworld",
    [4] = "envmap",
    [5] = "demos",
    [6] = "+mat_texture_list",
    [7] = "cc_random",
    [8] = "kdtree_test",
    [9] = "spincycle",
    [10] = "-mat_texture_list",
    [11] = "ai_test_los",
    [12] = "cl_soundscape_printdebuginfo"
};
for v3341 = 1, #v890 do
    v982 = v890[v3341];
    do
        local l_v3341_0 = v3341;
        cvar[v982]:set_callback(function()
            -- upvalues: l_v3341_0 (ref)
            print("\aFF4040FFerror CV" .. l_v3341_0);
            return false;
        end);
    end;
end;