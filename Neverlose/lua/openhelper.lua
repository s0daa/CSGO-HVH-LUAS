-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = not _IS_MARKET;
local v0 = common.get_username();
local v1 = false;
local v2 = "csgo";
local v3 = "1.2";
local v4 = 1;
local v5 = _DEBUG and function(...)
    print_raw(...);
    print_dev(...);
end or function()

end;
local function v10(v6)
    local v7 = {};
    for v8, v9 in next, v6 do
        v7[v8] = v9;
    end;
    return v7;
end;
local v11 = require(_DEBUG and "sec-base64" or "neverlose/sec-base64");
local v12 = require(_DEBUG and "pui" or "neverlose/pui");
if not _DEBUG or not require("inspect") then
    local function _(...)
        return ...;
    end;
end;
local v14 = v10(math);
local v15 = v10(table);
local v16 = v10(string);
local v17 = 180 / v14.pi;
v14.deginrad = v14.pi / 180;
v14.radindeg = v17;
v14.map = function(v18, v19, v20, v21, v22, v23)
    -- upvalues: v14 (ref)
    if v23 then
        local v24 = v14.clamp(v18, v19, v20);
        if v24 then
            v18 = v24;
        end;
    end;
    return v21 + (v18 - v19) * (v22 - v21) / (v20 - v19);
end;
v14.lerp = function(v25, v26, v27)
    return v25 + (v26 - v25) * v27;
end;
v14.clamp = function(v28, v29, v30)
    if v28 < v29 then
        return v29;
    elseif v30 < v28 then
        return v30;
    else
        return v28;
    end;
end;
v14.cycle = function(v31, v32)
    local v33 = v31 % v32;
    return v33 == 0 and v32 or v33;
end;
v14.round = function(v34)
    -- upvalues: v14 (ref)
    return v14.floor(v34 + 0.5);
end;
v14.roundb = function(v35, v36)
    -- upvalues: v14 (ref)
    local v37 = 10 ^ (v36 or 0);
    return v14.floor(v35 * v37 + 0.5) / v37;
end;
v14.medium = function(...)
    local v38 = 0;
    local v39 = 0;
    for v40, v41 in ipairs({
        ...
    }) do
        local l_v40_0 = v40;
        v38 = v38 + v41;
        v39 = l_v40_0;
    end;
    return v38 / v39;
end;
v14.average = function(v43)
    local v44 = 0;
    local v45 = 0;
    for v46 = 1, #v43 do
        local l_v46_0 = v46;
        v44 = v44 + v43[v46];
        v45 = l_v46_0;
    end;
    return v44 / v45;
end;
v14.tolerate = function(v48, v49)
    if v48 < v49 then
        return 0;
    elseif 1 - v49 < v48 then
        return 1;
    else
        return v48;
    end;
end;
v14.extrapolate = function(v50, v51, v52)
    return v50 + v51 * globals.tickinterval * v52;
end;
v14.dist = function(v53, v54, v55)
    -- upvalues: v14 (ref)
    local v56 = v54 and v54.x - v53.x or v53.x;
    local v57 = v54 and v54.y - v53.y or v53.y;
    local v58 = not v55 and (v54 and v54.z - v53.z or v53.z) or nil;
    return v14.sqrt(v56 * v56 + v57 * v57 + (v58 and v58 * v58 or 0));
end;
v14.distsqr = function(v59, v60, v61)
    local v62 = v60 and v60.x - v59.x or v59.x;
    local v63 = v60 and v60.y - v59.y or v59.y;
    local v64 = not v61 and (v60 and v60.z - v59.z or v59.z) or nil;
    return v62 * v62 + v63 * v63 + (v64 and v64 * v64 or 0);
end;
v14.distb = function(v65, v66, v67)
    -- upvalues: v14 (ref)
    local v68 = v66 and v66[1] - v65[1] or v65[1];
    local v69 = v66 and v66[2] - v65[2] or v65[2];
    local v70 = not v67 and (v66 and v66[3] - v65[3] or v65[3]) or nil;
    return v14.sqrt(v68 * v68 + v69 * v69 + (v70 and v70 * v70 or 0));
end;
v14.sqrt3 = function(v71, v72, v73)
    -- upvalues: v14 (ref)
    return v14.sqrt(v71 * v71 + v72 * v72 + (v73 and v73 * v73 or 0));
end;
v14.angle_to = function(v74, v75)
    -- upvalues: v14 (ref)
    local v76 = v75.x - v74.x;
    local v77 = v75.y - v74.y;
    local v78 = v75.z - v74.z;
    return vector(v14.atan2(-v78, v14.sqrt(v76 * v76 + v77 * v77)) * v14.radindeg, v14.atan2(v77, v76) * v14.radindeg, 0);
end;
v14.relative_yaw = function(v79, v80)
    -- upvalues: v14 (ref)
    return v14.atan2(v79.y - v80.y, v79.x - v80.x) * v14.radindeg;
end;
v14.relative_pitch = function(v81, v82)
    -- upvalues: v14 (ref)
    return v14.atan2(-(v82.z - v81.z), v14.sqrt((v82.x - v81.x) * (v82.x - v81.x) + (v82.y - v81.y) * (v82.y - v81.y))) * v14.radindeg;
end;
v14.normalize_yaw = function(v83)
    return (v83 + 180) % -360 + 180;
end;
v14.normalize_pitch = function(v84)
    -- upvalues: v14 (ref)
    return v14.clamp(v84, -89, 89);
end;
v15.new = require("table.new");
v15.clear = require("table.clear");
v15.find = function(v85, v86)
    local v87 = false;
    for v88 = 1, #v85 do
        if not v87 then
            if v85[v88] ~= v86 then
                v87 = false;
            else
                v87 = true;
            end;
        end;
    end;
    return v87;
end;
v15.copy = function(v89)
    -- upvalues: v15 (ref)
    if type(v89) ~= "table" then
        return v89;
    else
        local v90 = {};
        for v91, v92 in pairs(v89) do
            v90[v15.copy(v91)] = v15.copy(v92);
        end;
        return v90;
    end;
end;
v15.filter = function(v93)
    -- upvalues: v15 (ref)
    local v94 = {};
    local v95 = 1;
    for v96 = 1, v15.maxn(v93) do
        if v93[v96] ~= nil then
            local l_v95_0 = v95;
            local v98 = v93[v96];
            v95 = v95 + 1;
            v94[l_v95_0] = v98;
        end;
    end;
    return v94;
end;
v15.distribute = function(v99, v100, v101)
    local v102 = {};
    for v103, v104 in ipairs(v99) do
        v102[v101 and v104[v101] or v103] = v100 == nil and v103 or v104[v100];
    end;
    return v102;
end;
v16.limit = function(v105, v106, v107)
    -- upvalues: v16 (ref), v15 (ref)
    local v108 = {};
    local v109 = 1;
    for v110 in v16.gmatch(v105, ".[\128-\191]*") do
        local v111 = v109 + 1;
        v108[v109] = v110;
        v109 = v111;
        if v106 < v109 then
            if v107 then
                v108[v109] = v107 == true and "..." or v107;
                break;
            else
                break;
            end;
        end;
    end;
    return v15.concat(v108);
end;
v16.clean = function(v112)
    -- upvalues: v16 (ref)
    return v16.gsub(v16.gsub(v112, "^%s+", ""), "%s+$", "");
end;
v16.is_valid = function(v113, v114, v115)
    -- upvalues: v16 (ref)
    return #v113 > 0 and (not v114 or #v113 == #v16.gsub(v113, ".[\128-\191]*", "!")) and (not v115 or v16.find(v113, "[\\/:%*%?\"%<%>%|]") == nil);
end;
v16.assemble = function(...)
    -- upvalues: v15 (ref), v16 (ref)
    return v15.concat({
        v16.char(...)
    });
end;
v16.disassemble = function(v116)
    -- upvalues: v15 (ref), v16 (ref)
    return v15.concat({
        v16.byte(v116, 1, #v116)
    }, ",");
end;
if _DEBUG then
    setmetatable(_G, {
        __index = function(_, v118)
            -- upvalues: v5 (ref)
            v5("_G READ: ", v118);
            return nil;
        end, 
        __newindex = function(v119, v120, v121)
            -- upvalues: v5 (ref)
            v5("_G SET: ", v120);
            rawset(v119, v120, v121);
        end
    });
end;
v17 = v16.format("openhelper/%s/", v2);
local v122 = nil;
local l_events_0 = _G.events;
local l_any_0 = l_events_0.any;
local v125 = {
    set = l_any_0.set, 
    unset = l_any_0.unset, 
    call = l_any_0.call
};
local v126 = nil;
do
    local l_l_events_0_0, l_v125_0, l_v126_0 = l_events_0, v125, v126;
    l_v126_0 = {
        set = function(v130, v131)
            if v130.proxy[v131] == nil then
                local v132 = #v130.callbacks + 1;
                local l_callbacks_0 = v130.callbacks;
                local l_proxy_0 = v130.proxy;
                local l_v131_0 = v131;
                l_proxy_0[v131] = v132;
                l_callbacks_0[v132] = l_v131_0;
            end;
        end, 
        unset = function(v136, v137)
            -- upvalues: v15 (ref)
            local v138 = v136.proxy[v137];
            if v138 == nil then
                return;
            else
                v15.remove(v136.callbacks, v138);
                v136.proxy[v137] = nil;
                for v139, v140 in next, v136.proxy do
                    if v138 < v140 then
                        v136.proxy[v139] = v140 - 1;
                    end;
                end;
                return;
            end;
        end, 
        __call = function(v141, v142, v143)
            -- upvalues: l_v126_0 (ref)
            if v143 ~= false then
                l_v126_0.set(v141, v142);
            else
                l_v126_0.unset(v141, v142);
            end;
        end, 
        call = function(v144, ...)
            -- upvalues: l_v125_0 (ref)
            if v144.name == "voice_message" then
                return l_v125_0.call(v144[0], ...);
            else
                return v144.mainfn(...);
            end;
        end, 
        gcall = function(v145, ...)
            -- upvalues: l_v125_0 (ref)
            l_v125_0.call(v145[0], ...);
        end, 
        unhook = function(v146)
            -- upvalues: l_v125_0 (ref)
            l_v125_0.unset(v146[0], v146.mainfn);
        end
    };
    l_v126_0.__index = l_v126_0;
    v122 = setmetatable({}, {
        __index = function(v147, v148)
            -- upvalues: l_l_events_0_0 (ref), l_v126_0 (ref), l_v125_0 (ref)
            local v149 = setmetatable({
                [0] = l_l_events_0_0[v148], 
                name = v148, 
                proxy = {}, 
                callbacks = {}
            }, l_v126_0);
            v149.mainfn = function(...)
                -- upvalues: v149 (ref)
                local v150 = nil;
                for v151 = 1, #v149.callbacks do
                    local v152 = v149.callbacks[v151](...);
                    if v152 ~= nil then
                        v150 = v152;
                    end;
                end;
                return v150;
            end;
            l_v125_0.set(v149[0], v149.mainfn);
            rawset(v147, v148, v149);
            return v149;
        end
    });
end;
l_events_0 = nil;
l_any_0 = nil;
v125 = nil;
v126 = nil;
local v153 = nil;
local v154 = nil;
local v155 = 1;
local v156 = render.screen_size();
v153 = v156;
v125 = v156 / v155;
local v157 = v156 * 0.5;
v126 = v125 * 0.5;
v154 = v157;
v155 = nil;
v156 = _G.render;
v157 = v14.floor;
local v158 = color();
local v159 = 1;
local v160 = "s";
do
    local l_v156_0, l_v158_0, l_v159_0, l_v160_0 = v156, v158, v159, v160;
    local function v166(v165)
        -- upvalues: l_v159_0 (ref)
        if l_v159_0 == 1 then
            return v165;
        else
            return v165 * l_v159_0;
        end;
    end;
    local v167 = nil;
    local v168 = l_v156_0.get_scale(2) ~= 1;
    do
        local l_v168_0 = v168;
        v167 = {
            callback = function()
                -- upvalues: l_v159_0 (ref), l_v156_0 (ref), l_v160_0 (ref), v155 (ref), v122 (ref), l_v168_0 (ref)
                l_v159_0 = l_v156_0.get_scale(2);
                l_v160_0 = l_v159_0 ~= 1 and "s" or "";
                if v155.dpi ~= l_v159_0 then
                    v122.render_dpi:call(l_v159_0, v155.dpi, l_v168_0);
                    local l_v155_0 = v155;
                    local l_l_v159_0_0 = l_v159_0;
                    l_v168_0 = false;
                    l_v155_0.dpi = l_l_v159_0_0;
                end;
            end
        };
        v122.render_dpi:set(function(v172, _)
            -- upvalues: v125 (ref), v153 (ref), v126 (ref)
            v125 = v153 / v172;
            v126 = v125 * 0.5;
        end);
    end;
    v168 = 1;
    local v174 = {};
    local l_alpha_modulate_0 = color().alpha_modulate;
    local function v178(v176, v177)
        -- upvalues: v168 (ref), l_events_0 (ref), l_alpha_modulate_0 (ref)
        if v168 == 1 then
            return v176;
        elseif not v177 and v168 == 0 then
            return l_events_0.bnull;
        else
            return l_alpha_modulate_0(v176, v168, true);
        end;
    end;
    v155 = setmetatable({
        cheap = false, 
        dpi = l_v156_0.get_scale(2), 
        dpi_t = v167, 
        push_alpha = function(v179)
            -- upvalues: v174 (ref), v168 (ref)
            local v180 = #v174;
            if v180 > 255 then
                error("alpha stack exceeded 255 objects, report to developers");
            end;
            v174[v180 + 1] = v179;
            v168 = v168 * v174[v180 + 1] * (v174[v180] or 1);
        end, 
        pop_alpha = function()
            -- upvalues: v174 (ref), v168 (ref)
            local v181 = #v174;
            local l_v174_0 = v174;
            local l_v181_0 = v181;
            local v184 = nil;
            v181 = v181 - 1;
            l_v174_0[l_v181_0] = v184;
            v168 = v181 == 0 and 1 or v174[v181] * (v174[v181 - 1] or 1);
        end, 
        get_alpha = function(v185)
            -- upvalues: v174 (ref), v168 (ref)
            if v185 then
                return v174[v185];
            else
                return v168, #v174;
            end;
        end, 
        screen_size = function(v186)
            -- upvalues: l_v156_0 (ref), l_v159_0 (ref)
            return l_v156_0.screen_size() / (v186 and 1 or l_v159_0);
        end, 
        measure_text = function(v187, ...)
            -- upvalues: l_v156_0 (ref), l_v160_0 (ref), l_v159_0 (ref)
            return l_v156_0.measure_text(v187, l_v160_0, ...) / l_v159_0;
        end, 
        load_font = function(v188, v189, v190)
            -- upvalues: l_v156_0 (ref)
            return l_v156_0.load_font(v188, v189, v190 or "");
        end, 
        text = function(v191, v192, v193, v194, v195, v196)
            -- upvalues: l_v156_0 (ref), v166 (ref), v178 (ref), l_v160_0 (ref), v155 (ref)
            l_v156_0.text(v191, v166(v192), v178(v193), v194 and v194 .. l_v160_0 or l_v160_0, v195);
            if v196 == true then
                return v155.measure_text(v191, v195);
            else
                return;
            end;
        end, 
        blur = function(v197, v198, v199, v200, v201)
            -- upvalues: v155 (ref), v166 (ref), v168 (ref), l_v156_0 (ref)
            if v155.cheap then
                return;
            else
                if type(v201) == "table" then
                    for v202 = 1, 4 do
                        v201[v202] = v166(v201[v202] or 0);
                    end;
                else
                    v201 = v166(v201 or 0);
                end;
                local v203 = (v200 or 1) * v168;
                v199 = v166(v199 or 2);
                v200 = v203;
                if v200 > 0 and v199 > 0 then
                    l_v156_0.blur(v166(v197), v166(v198), v199, v200, v201);
                end;
                return;
            end;
        end, 
        shadow = function(v204, v205, v206, v207, v208, v209)
            -- upvalues: v155 (ref), l_v156_0 (ref), v166 (ref), v178 (ref)
            if v155.cheap then
                return;
            else
                l_v156_0.shadow(v166(v204), v166(v205), v178(v206), v166(v207 or 16), v166(v208 or 0), v166(v209 or 0));
                return;
            end;
        end, 
        line = function(v210, v211, v212)
            -- upvalues: l_v156_0 (ref), v166 (ref), v178 (ref)
            l_v156_0.line(v166(v210), v166(v211), v178(v212));
        end, 
        rect = function(v213, v214, v215, v216, v217)
            -- upvalues: v166 (ref), l_v156_0 (ref), v178 (ref)
            if type(v216) == "table" then
                for v218 = 1, 4 do
                    v216[v218] = v166(v216[v218] or 0);
                end;
            else
                v216 = v166(v216 or 0);
            end;
            l_v156_0.rect(v166(v213), v166(v214), v178(v215), v216, v217 or false);
        end, 
        rect_outline = function(v219, v220, v221, v222, v223, v224)
            -- upvalues: v166 (ref), l_v156_0 (ref), v178 (ref)
            if type(v223) == "table" then
                for v225 = 1, 4 do
                    v223[v225] = v166(v223[v225] or 0);
                end;
            else
                v223 = v166(v223 or 0);
            end;
            l_v156_0.rect_outline(v166(v219), v166(v220), v178(v221), v166(v222 or 0), v223, v224 or false);
        end, 
        gradient = function(v226, v227, v228, v229, v230, v231, v232)
            -- upvalues: l_v156_0 (ref), v166 (ref), v178 (ref)
            local v233 = v230 or v228;
            if not v231 then
                v231 = v229;
            end;
            l_v156_0.gradient(v166(v226), v166(v227), v178(v228, true), v178(v229, true), v178(v233, true), v178(v231, true), v232 or 0);
        end, 
        circle = function(v234, v235, v236, v237, v238)
            -- upvalues: l_v156_0 (ref), v166 (ref), v178 (ref)
            l_v156_0.circle(v166(v234), v178(v235), v166(v236), v237 or 0, v238 or 1);
        end, 
        circle_outline = function(v239, v240, v241, v242, v243, v244)
            -- upvalues: l_v156_0 (ref), v166 (ref), v178 (ref)
            l_v156_0.circle_outline(v166(v239), v178(v240), v166(v241), v242 or 0, v243 or 1, v166(v244 or 1));
        end, 
        circle_3d = function(v245, v246, v247, v248, v249)
            -- upvalues: l_v156_0 (ref), v178 (ref)
            l_v156_0.circle_3d(v245, v178(v246), v247, v248 or 0, v249 or 1, false);
        end, 
        circle_3d_outline = function(v250, v251, v252, v253, v254, v255)
            -- upvalues: l_v156_0 (ref), v178 (ref), v166 (ref)
            l_v156_0.circle_3d_outline(v250, v178(v251), v252, v253 or 0, v254 or 1, v166(v255 or 1));
        end, 
        circle_3d_gradient = function(v256, v257, v258, v259, v260, v261, v262)
            -- upvalues: l_v156_0 (ref), v178 (ref), v166 (ref)
            l_v156_0.circle_3d_gradient(v256, v178(v257), v178(v258), v259, v260 or 0, v261 or 1, v166(v262 or 1));
        end, 
        texture = function(v263, v264, v265, v266, v267, v268)
            -- upvalues: l_v158_0 (ref), l_v156_0 (ref), v166 (ref), v178 (ref)
            if not v263 then
                return;
            else
                if not v266 then
                    v266 = l_v158_0;
                end;
                l_v156_0.texture(v263, v166(v264), v166(v265 or vector(v263.width, v263.height)), v178(v266), v267 or "", v268 or 0);
                return;
            end;
        end, 
        push_clip_rect = function(v269, v270, v271)
            -- upvalues: l_v156_0 (ref), v166 (ref)
            l_v156_0.push_clip_rect(v166(v269), v166(v270), v271 or false);
        end
    }, {
        __index = l_v156_0
    });
end;
v156 = nil;
v157 = setmetatable({}, {
    __mode = "k"
});
v158 = globals.frametime;
v159 = 1;
do
    local l_v157_0, l_v158_1, l_v159_1, l_v160_1 = v157, v158, v159, v160;
    ui.find("Settings", "Animation Speed"):set_callback(function(v276)
        -- upvalues: l_v159_1 (ref)
        l_v159_1 = v276:get();
    end, true);
    l_v160_1 = {
        pow = {
            [1] = function(v277, v278)
                return 1 - (1 - v277) ^ (v278 or 3);
            end, 
            [2] = function(v279, v280)
                return v279 ^ (v280 or 3);
            end, 
            [3] = function(v281, v282)
                -- upvalues: v14 (ref)
                return v281 < 0.5 and 4 * v14.pow(v281, v282 or 3) or 1 - v14.pow(-2 * v281 + 2, v282 or 3) * 0.5;
            end
        }
    };
    v156 = {
        pulse = 0, 
        easings = l_v160_1, 
        lerp = function(v283, v284, v285, v286)
            -- upvalues: l_v158_1 (ref), l_v159_1 (ref), v14 (ref)
            local v287 = v283 + (v284 - v283) * l_v158_1 * (v285 or 8) * l_v159_1;
            return v14.abs(v284 - v287) < (v286 or 0.002) and v284 or v287;
        end, 
        condition = function(v288, v289, v290, v291)
            -- upvalues: l_v157_0 (ref), v14 (ref), l_v158_1 (ref), l_v159_1 (ref), l_v160_1 (ref)
            local v292 = v288[1] and v288 or l_v157_0[v288];
            if not v292 then
                l_v157_0[v288] = {
                    [1] = v289 and 1 or 0, 
                    [2] = v289
                };
                v292 = l_v157_0[v288];
            end;
            if not v290 then
                v290 = 4;
            end;
            local l_v290_0 = v290;
            if type(v290) == "table" then
                l_v290_0 = v289 and v290[1] or v290[2];
            end;
            v292[1] = v14.clamp(v292[1] + l_v158_1 * v14.abs(l_v290_0) * l_v159_1 * (v289 and 1 or -1), 0, 1);
            return (not (v292[1] % 1 ~= 0) or l_v290_0 < 0) and v292[1] or l_v160_1.pow[v291 and (v289 and v291[1][1] or v291[2][1]) or v289 and 1 or 3](v292[1], v291 and (v289 and v291[1][2] or v291[2][2]) or 3);
        end
    };
    v122.post_render:set(function()
        -- upvalues: v156 (ref), v14 (ref), l_v158_1 (ref)
        v156.pulse = v14.sin(globals.realtime) * 0.5 + 0.5;
        l_v158_1 = globals.frametime;
    end);
end;
v157 = {
    regular = v155.load_font("Segoe UI Semibold", vector(14, 12), "a"), 
    bold = v155.load_font("Segoe UI Bold", vector(14, 12), "a")
};
l_events_0 = {
    accent = ui.get_style("Link Active"), 
    window = ui.get_style("Window Title"), 
    sidebar = ui.get_style("Sidebar Background"), 
    text = ui.get_style("Active Text"), 
    text_sb = ui.get_style("Sidebar Text"), 
    white = color(255), 
    black = color(0), 
    bnull = color(0, 0), 
    spot = {
        back1 = color(0, 40), 
        back2 = color(0, 127), 
        back_circle = color(0, 64), 
        idle = color(255), 
        throwing = color(120, 240, 80), 
        prepare = color(255, 200, 80)
    }, 
    location = {
        back = color(0, 80), 
        icon_back = color(0, 48), 
        icon_back_far = color(0, 32)
    }
};
l_any_0 = v157;
v157 = function()
    -- upvalues: l_events_0 (ref), v14 (ref)
    l_events_0.accent = ui.get_style("Link Active");
    l_events_0.window = ui.get_style("Window Title");
    l_events_0.sidebar = ui.get_style("Sidebar Background");
    l_events_0.text = ui.get_style("Active Text");
    l_events_0.text_sb = ui.get_style("Sidebar Text");
    l_events_0.location.back = l_events_0.window;
    l_events_0.location.icon_back = l_events_0.sidebar:alpha_modulate(v14.min(l_events_0.sidebar.a, 155));
end;
do
    local l_v157_1, l_v158_2, l_v159_2 = v157, v158, v159;
    v122.pre_render:set(function()
        -- upvalues: v12 (ref), l_v157_1 (ref)
        if v12.alpha > 0 then
            l_v157_1();
        end;
    end);
    l_v157_1();
    l_v158_2 = nil;
    l_v159_2 = l_any_0;
    v160 = function(v297)
        -- upvalues: l_any_0 (ref), l_v159_2 (ref), l_v158_2 (ref), v155 (ref)
        if v297 == 1 then
            l_any_0 = l_v159_2;
        else
            if not l_v158_2 then
                l_v158_2 = {
                    regular = v155.load_font("Segoe UI Semibold", vector(12, 12), "a"), 
                    bold = v155.load_font("Segoe UI Bold", vector(12, 12), "a")
                };
            end;
            l_any_0 = l_v158_2;
        end;
    end;
    v160(v155.dpi);
    v122.render_dpi:set(v160);
end;
v157 = {
    MERGE_HEIGHT_DIFF = 8, 
    MERGE_DIST = 30, 
    COLLAPSE_FOV = 100, 
    COLLAPSE_DIST = 400, 
    COLLAPSE_IN_FOV_DIST = 1000, 
    BLEND_DIST = 1200, 
    MAX_DIST = 1500, 
    SELECTION_DIST = 24
};
v158 = setmetatable({
    data = {
        [44] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "hegrenade", 
            [1] = vector(9, 16), 
            [2] = vector(0, 2), 
            [3] = color("d25151")
        }, 
        [46] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "molotov", 
            [1] = vector(10, 18), 
            [2] = vector(0, 2), 
            [3] = color("e69839")
        }, 
        [48] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "incgrenade", 
            [1] = vector(7, 18), 
            [2] = vector(-1, 2), 
            [3] = color("e69839")
        }, 
        [45] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "smokegrenade", 
            [1] = vector(7, 18), 
            [2] = vector(-1, 1), 
            [3] = color(200)
        }, 
        [43] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "flashbang", 
            [1] = vector(10, 18), 
            [2] = vector(0, 0), 
            [3] = color("d4ca70")
        }, 
        [47] = {
            [1] = nil, 
            [2] = nil, 
            [3] = nil, 
            [4] = "decoy", 
            [1] = vector(12, 18), 
            [2] = vector(0, 1), 
            [3] = color(240)
        }
    }
}, {
    __index = function(v298, v299)
        -- upvalues: v155 (ref), v16 (ref)
        local v300 = nil;
        if v155.dpi > 1 then
            local v301 = v298.data[v299];
            local v302 = v16.format("materials\\panorama\\images\\icons\\equipment\\%s.svg", v301[4]);
            v300 = v155.load_image_from_file(v302, v301[1] * 2);
        else
            v300 = v155.get_weapon_icon(v299);
        end;
        rawset(v298, v299, v300);
        return v300;
    end
});
v122.render_dpi:set(function()
    -- upvalues: v158 (ref)
    for v303, _ in next, v158 do
        if v303 ~= "data" then
            v158[v303] = nil;
        end;
    end;
end);
v159 = {
    grenades = {
        [1] = {
            [1] = 1, 
            [2] = 44, 
            [3] = "weapon_hegrenade", 
            [4] = "HE", 
            ic = "\ad25151ff"
        }, 
        [2] = {
            [1] = 2, 
            [2] = 46, 
            [3] = "weapon_molotov", 
            [4] = "Molly", 
            ic = "\ae69839ff"
        }, 
        [3] = {
            [1] = 2, 
            [2] = 48, 
            [3] = "weapon_incgrenade", 
            [4] = "Molly", 
            ic = "\ae69839ff"
        }, 
        [4] = {
            [1] = 3, 
            [2] = 45, 
            [3] = "weapon_smokegrenade", 
            [4] = "Smoke", 
            ic = "\a{Active Text}"
        }, 
        [5] = {
            [1] = 4, 
            [2] = 43, 
            [3] = "weapon_flashbang", 
            [4] = "Flash", 
            ic = "\ad4ca70ff"
        }, 
        [6] = {
            [1] = 5, 
            [2] = 47, 
            [3] = "weapon_decoy", 
            [4] = "Decoy", 
            ic = "\aa7e8e8ff"
        }
    }
};
v160 = {
    location = {
        ACTIVE = 3, 
        FOCUSED = 2, 
        IDLE = 1, 
        INVISIBLE = 0
    }, 
    playback = {
        RETREATING = 7, 
        POST_THROW = 6, 
        THROW = 5, 
        PRE_THROW = 4, 
        MOVING = 3, 
        PRE_MOVE = 2, 
        PREPARING = 1, 
        IDLE = 0, 
        DONE = 8
    }, 
    maps_proxy = {
        de_shortdust = "de_dust", 
        de_shortnuke = "de_nuke"
    }, 
    throw_strength_proxy = {
        Full = 0, 
        Short = 2, 
        Medium = 1
    }, 
    throw_strength = {
        [0] = "Full", 
        [1] = "Medium", 
        [2] = "Short"
    }, 
    grenades_cn_to_id = v15.distribute(v159.grenades, 1, 3), 
    grenades_id_to_cn = v15.distribute(v159.grenades, 3, 1), 
    grenades_name_to_id = v15.distribute(v159.grenades, 1, 4), 
    grenades_id_to_name = v15.distribute(v159.grenades, 4, 1), 
    grenades_uid_to_id = v15.distribute(v159.grenades, 1, 2), 
    grenades_id_to_tid = v15.distribute(v159.grenades, nil, 1)
};
local v305 = nil;
local function v309(_)
    -- upvalues: v160 (ref)
    local v307 = common.get_map_data();
    if not v307 then
        return;
    else
        local l_shortname_0 = v307.shortname;
        if l_shortname_0 and v160.maps_proxy[l_shortname_0] then
            l_shortname_0 = v160.maps_proxy[l_shortname_0];
        end;
        return l_shortname_0;
    end;
end;
v305 = {
    valid = false, 
    userid = 0, 
    enemies = {}, 
    map = v309()
};
local function v317(v310)
    -- upvalues: v305 (ref), v14 (ref), v122 (ref)
    v305.self = entity.get_local_player();
    v305.valid = v305.self ~= nil and v305.self:is_alive();
    if v305.self then
        v305.userid = v305.self:get_player_info().userid;
        if v305.valid then
            v305.flags = v305.self.m_fFlags;
            v305.on_ground = bit.band(v305.flags, bit.lshift(1, 0)) == 1;
            v305.crouching = v305.self.m_flDuckAmount > 0.5;
            v305.velocity = v14.sqrt3(v305.self.m_vecVelocity:unpack());
            local l_v305_0 = v305;
            local l_v305_1 = v305;
            local v313 = v305.self:get_origin();
            l_v305_1.eyes = v305.self:get_eye_position();
            l_v305_0.origin = v313;
            if v310 then
                l_v305_0 = v305.self:get_player_weapon();
                if l_v305_0 ~= v305.weapon then
                    l_v305_1 = v305;
                    v313 = v305;
                    local l_v305_2 = v305;
                    local l_l_v305_0_0 = l_v305_0;
                    local v316 = l_v305_0 and l_v305_0:get_weapon_info();
                    l_v305_2.weapon_i = l_v305_0 and l_v305_0:get_weapon_index();
                    v313.weapon_t = v316;
                    l_v305_1.weapon = l_l_v305_0_0;
                    v122.local_weapon_change:call(l_v305_0);
                end;
                v305.using = v310.in_use;
                v305.walking = v305.velocity > 5 and v310.in_speed;
                v305.jumping = v310.in_jump or not v305.on_ground;
            end;
        end;
    end;
end;
v122.createmove:set(v317);
v122.player_death:set(function(v318)
    -- upvalues: v305 (ref), v122 (ref)
    if v318.userid ~= v305.userid then
        return;
    else
        v122.local_death:call(v318);
        return;
    end;
end);
v122.player_spawn:set(function(v319)
    -- upvalues: v305 (ref), v122 (ref)
    if v319.userid ~= v305.userid then
        return;
    else
        v122.local_spawn:call(v319);
        return;
    end;
end);
v122.player_connect_full:set(function(v320)
    -- upvalues: v305 (ref), v122 (ref)
    if v320.userid ~= v305.userid then
        return;
    else
        v122.local_connect_full:call(v320);
        return;
    end;
end);
local v321 = nil;
do
    local l_v309_0, l_v321_0 = v309, v321;
    v122.render:set(function()
        -- upvalues: l_v321_0 (ref), v305 (ref), v122 (ref)
        local l_is_in_game_0 = globals.is_in_game;
        if l_v321_0 and not l_is_in_game_0 then
            local l_v305_3 = v305;
            local l_v305_4 = v305;
            local v327 = nil;
            l_v305_4.valid = false;
            l_v305_3.self = v327;
            v305.map = nil;
            v122.local_disconnect:call();
            l_v321_0 = false;
        end;
        l_v321_0 = l_is_in_game_0;
    end);
    v122.level_init:set(function()
        -- upvalues: v305 (ref), l_v309_0 (ref)
        v305.map = l_v309_0(v305.map);
    end);
end;
v309 = v16.assemble(82, 76, 69, 83, 73, 65, 70, 71, 79, 80, 88, 66, 85, 77, 78, 87, 75, 67, 74, 81, 68, 89, 84, 86, 72, 90, 103, 116, 108, 110, 98, 105, 117, 97, 112, 120, 121, 122, 113, 102, 111, 114, 107, 118, 109, 104, 115, 106, 101, 99, 100, 119, 56, 49, 51, 53, 50, 54, 57, 48, 52, 55, 43, 47, 61);
ffi.cdef("\tint GetProcAddress(void*, const char*);\n    void* GetModuleHandleA(const char*);\n\ttypedef void*(__cdecl* ShellExecuteA_OH)(void*, const char*, const char*, const char*, const char*, int);\n");
v317 = nil;
v321 = "filesystem_stdio.dll";
local v328 = "VBaseFileSystem011";
local v329 = "VFileSystem017";
local v330 = {
    remove_file = utils.get_vfunc(v321, v329, 20, "void (__thiscall*)(void*, const char*, const char*)"), 
    find_first = utils.get_vfunc(v321, v329, 32, "const char* (__thiscall*)(void*, const char*, int*)"), 
    find_next = utils.get_vfunc(v321, v329, 33, "const char* (__thiscall*)(void*, int)"), 
    find_is_directory = utils.get_vfunc(v321, v329, 34, "bool (__thiscall*)(void*, int)"), 
    find_close = utils.get_vfunc(v321, v329, 35, "void (__thiscall*)(void*, int)"), 
    find_first_ex = utils.get_vfunc(v321, v329, 36, "const char* (__thiscall*)(void*, const char*, const char*, int*)")
};
local v331 = {
    exists = utils.get_vfunc(v321, v328, 10, "bool (__thiscall*)(void*, const char*, const char*)"), 
    add_search_path = utils.get_vfunc(v321, v329, 11, "void (__thiscall*)(void*, const char*, const char*, int)"), 
    remove_search_path = utils.get_vfunc(v321, v329, 12, "bool (__thiscall*)(void*, const char*, const char*)"), 
    get_game_directory = utils.get_vfunc("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")
};
local v332 = v16.sub(ffi.string(v331.get_game_directory()), 1, -5);
v331.add_search_path(v332, "ROOT_PATH", 0);
do
    local l_v330_0, l_v331_0, l_v332_0 = v330, v331, v332;
    v122.shutdown:set(function()
        -- upvalues: l_v331_0 (ref), l_v332_0 (ref)
        l_v331_0.remove_search_path(l_v332_0, "ROOT_PATH");
    end);
    local v336 = ffi.cast("ShellExecuteA_OH", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("shell32.dll"), "ShellExecuteA"));
    files.create_folder("openhelper");
    files.create_folder(v17);
    local v337 = ffi.typeof("int[1]");
    v317 = {
        game_directory = l_v332_0, 
        open_folder = function(v338, v339)
            -- upvalues: v336 (ref), v317 (ref)
            v336(nil, "explore", (v339 ~= false and v317.game_directory or "") .. v338, nil, nil, 1);
        end, 
        exists = function(v340)
            -- upvalues: l_v331_0 (ref)
            return l_v331_0.exists(v340, "ROOT_PATH");
        end, 
        for_each = function(v341, v342)
            -- upvalues: v16 (ref), v337 (ref), l_v330_0 (ref), l_v331_0 (ref)
            assert(v341);
            assert(v342);
            local v343 = v16.match(v341, "(.*/)");
            local v344 = ffi.new(v337);
            local v345 = l_v330_0.find_first_ex(v341, "ROOT_PATH", v344);
            while v345 ~= nil do
                local v346 = ffi.string(v345);
                if l_v331_0.exists(v343 .. v346, "ROOT_PATH") then
                    v342(v346, v344);
                end;
                v345 = l_v330_0.find_next(v344[0]);
            end;
            l_v330_0.find_close(v344[0]);
        end, 
        delete = function(v347)
            -- upvalues: l_v330_0 (ref)
            assert(v347);
            l_v330_0.remove_file(v347);
        end
    };
end;
v321 = nil;
v328 = ffi.typeof("char[?]");
v329 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
v330 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
v331 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
do
    local l_v328_0, l_v329_0, l_v330_1, l_v331_1 = v328, v329, v330, v331;
    v321 = {
        get = function()
            -- upvalues: l_v329_0 (ref), l_v328_0 (ref), l_v331_1 (ref)
            local v352 = l_v329_0();
            if v352 == 0 then
                return;
            else
                local v353 = l_v328_0(v352);
                l_v331_1(0, v353, v352);
                return ffi.string(v353, v352 - 1);
            end;
        end, 
        set = function(v354)
            -- upvalues: l_v330_1 (ref)
            v354 = tostring(v354);
            l_v330_1(v354, #v354);
        end
    };
end;
v328 = {
    [true] = function(v355, ...)
        -- upvalues: v12 (ref), v16 (ref)
        v12.sidebar("\vOpen\rHelper", "\abfd94eff\f<file-circle-check>");
        common.add_notify(v12.string("Config"), v16.format(v12.string(v355), ...));
        v12.sidebar("\vOpen\rHelper", "bowling-ball");
        return true;
    end, 
    [false] = function(v356, ...)
        -- upvalues: v12 (ref), v16 (ref)
        v12.sidebar("\vOpen\rHelper", "\ad25151ff\f<file-circle-exclamation>");
        common.add_notify(v12.string("Error"), v16.format(v12.string(v356), ...));
        v12.sidebar("\vOpen\rHelper", "bowling-ball");
        return false;
    end
};
v329 = nil;
v330 = 1;
v331 = false;
v332 = nil;
local v357 = "openhelper/data";
local function v359(v358)
    -- upvalues: v11 (ref), v309 (ref)
    assert(v358);
    return msgpack.unpack(v11.decode(v358, v309));
end;
local function v361(v360)
    -- upvalues: v11 (ref), v309 (ref)
    assert(v360);
    return v11.encode(msgpack.pack(v360), v309);
end;
do
    local l_v331_2, l_v332_1, l_v357_0, l_v359_0, l_v361_0 = v331, v332, v357, v359, v361;
    local function v369()
        -- upvalues: v317 (ref), l_v357_0 (ref), l_v359_0 (ref)
        if not v317.exists(l_v357_0) then
            return;
        else
            local l_status_0, l_result_0 = pcall(l_v359_0, files.read(l_v357_0, true));
            if not l_status_0 then
                return;
            else
                return l_result_0;
            end;
        end;
    end;
    local function v370()
        -- upvalues: l_v332_1 (ref), l_v357_0 (ref), l_v361_0 (ref), l_v331_2 (ref)
        assert(l_v332_1);
        files.write(l_v357_0, l_v361_0(l_v332_1), true);
        l_v331_2 = false;
    end;
    l_v332_1 = v369();
    if not l_v332_1 then
        v1 = true;
        l_v332_1 = {
            version = v330, 
            user = {}, 
            configs = {
                loaded = {}
            }
        };
        v370();
    end;
    if v330 ~= l_v332_1.version then
        l_v332_1.version = v330;
    end;
    do
        local function v371()
            -- upvalues: v122 (ref), v370 (ref), v371 (ref)
            v122.oh_pre_database_write:call();
            v370();
            v122.oh_post_database_write:call();
            utils.execute_after(300, v371);
        end;
        utils.execute_after(300, v371);
        v122.shutdown:set(v370);
    end;
    v329 = setmetatable({
        refresh = v369, 
        flush = v370
    }, {
        __index = function(_, v373)
            -- upvalues: l_v331_2 (ref), l_v332_1 (ref)
            l_v331_2 = true;
            return rawget(l_v332_1, v373);
        end, 
        __newindex = function(_, v375, v376)
            -- upvalues: l_v332_1 (ref), l_v331_2 (ref)
            rawset(l_v332_1, v375, v376);
            l_v331_2 = true;
        end
    });
end;
v330 = nil;
v330 = {
    validate_loc = function(v377)
        -- upvalues: v160 (ref)
        return type(v377.N) == "string" and (not (v377.D ~= nil) or type(v377.D) == "string") and type(v377.T) == "number" and v160.grenades_id_to_name[v377.T] ~= nil and type(v377.s) == "table" and #v377.s == 5 and (not (v377.j ~= nil) or type(v377.j) == "boolean") and (not (v377.c ~= nil) or type(v377.c) == "boolean") and (not (v377.d ~= nil) or type(v377.d) == "number") and (not (v377.z ~= nil) or type(v377.z) == "table") and (not (v377.x ~= nil) or type(v377.x) == "table") and (not (v377.t ~= nil) or type(v377.t) == "number");
    end, 
    unpack_loc = function(v378)
        return {
            name = v378.N, 
            desc = v378.D, 
            type = v378.T, 
            pos = vector(v378.s[1], v378.s[2], v378.s[3]), 
            ang = vector(v378.s[4], v378.s[5]), 
            jump = v378.j ~= nil, 
            duck = v378.c ~= nil, 
            delay = v378.d, 
            pre = v378.z and {
                dir = v378.z[1], 
                time = v378.z[2], 
                walk = v378.z[3]
            } or nil, 
            post = v378.x and {
                dir = v378.x[1], 
                jump = v378.x[2]
            } or nil, 
            throw = v378.t or 0
        };
    end, 
    pack_loc = function(v379)
        return {
            N = v379.name, 
            D = v379.desc, 
            T = v379.type, 
            s = {
                [1] = v379.pos.x, 
                [2] = v379.pos.y, 
                [3] = v379.pos.z, 
                [4] = v379.ang.x, 
                [5] = v379.ang.y
            }, 
            j = v379.jump and true or nil, 
            c = v379.duck and true or nil, 
            d = v379.delay and v379.delay > 0 and v379.delay or nil, 
            t = v379.throw and v379.throw > 0 and v379.throw or nil, 
            z = v379.pre and {
                [1] = v379.pre.dir, 
                [2] = v379.pre.time, 
                [3] = v379.pre.walk
            } or nil, 
            x = v379.post and {
                [1] = v379.post.dir, 
                [2] = v379.post.jump or nil
            } or nil
        };
    end, 
    convert_loc = function(v380)
        -- upvalues: v5 (ref), v160 (ref)
        if v380.name == "Wall [Lethal]" then
            v5(v380.name);
        end;
        if not v380 then
            return;
        else
            local v381 = v380.grenade or {};
            local v382 = v160.grenades_cn_to_id[v380.weapon];
            if not v382 then
                return;
            else
                local v383 = v380.name or "Unnamed";
                if type(v383) == "table" then
                    v383 = v380.name[2] or v380.name[1] or "Unnamed";
                end;
                return {
                    N = v383, 
                    T = v382, 
                    s = {
                        [1] = v380.position[1], 
                        [2] = v380.position[2], 
                        [3] = v380.position[3], 
                        [4] = v380.viewangles[1], 
                        [5] = v380.viewangles[2]
                    }, 
                    j = v381.jump and true or nil, 
                    c = v380.duck and true or nil, 
                    t = v381.strength and (1 - v381.strength) * 2 or nil, 
                    d = v381.delay or nil, 
                    z = v381.run and {
                        [1] = v381.run_yaw or 0, 
                        [2] = v381.run, 
                        [3] = v381.run_speed or nil
                    } or nil, 
                    x = v381.recovery_yaw and {
                        [1] = nil, 
                        [2] = 0, 
                        [1] = v381.recovery_yaw or 0, 
                        [3] = v381.recovery_jump or nil
                    } or nil
                };
            end;
        end;
    end, 
    convert = function(v384)
        -- upvalues: v160 (ref), v330 (ref)
        local v385 = {};
        for v386, v387 in next, v384 do
            local v388 = v160.maps_proxy[v386];
            if v388 then
                v386 = v388;
            end;
            v385[v386] = v385[v386] or {};
            v388 = v385[v386];
            local v389 = #v388;
            for v390 = 1, #v387 do
                local v391 = v330.convert_loc(v387[v390]);
                if v391 then
                    v389 = v389 + 1;
                    v388[v389] = v391;
                end;
            end;
        end;
        return v385;
    end, 
    encode = function(v392)
        -- upvalues: v11 (ref), v309 (ref)
        return v11.encode(msgpack.pack(v392), v309);
    end, 
    decode = function(v393)
        -- upvalues: v11 (ref), v309 (ref)
        return msgpack.unpack(v11.decode(v393, v309));
    end, 
    avg_dist_loc = function(v394)
        -- upvalues: v14 (ref)
        local v395 = 0;
        local v396 = 0;
        for v397 = 1, #v394 do
            local l_v397_0 = v397;
            v395 = v395 + v14.sqrt3(unpack(v394[v397].s, 1, 3));
            v396 = l_v397_0;
        end;
        return v395 / v396;
    end, 
    avg_pos = function(v399)
        local v400 = 0;
        local v401 = 0;
        local v402 = 0;
        local v403 = #v399;
        for v404 = 1, #v399 do
            local v405 = v400 + v399[v404].s[1];
            local v406 = v401 + v399[v404].s[2];
            v402 = v402 + v399[v404].s[3];
            v401 = v406;
            v400 = v405;
        end;
        return {
            [1] = v400 / v403, 
            [2] = v401 / v403, 
            [3] = v402 / v403
        };
    end, 
    being_thrown = function(v407)
        if v407 and v407.m_bPinPulled == false then
            return v407.m_fThrowTime > 0;
        else
            return false;
        end;
    end
};
v331 = {
    rage = {
        accuracy = {
            autostop = v12.find("Aimbot", "Ragebot", "Accuracy", "Global", "Auto Stop")
        }, 
        main = {
            enable = v12.find("Aimbot", "Ragebot", "Main", "Enabled"), 
            peek = v12.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
            dt = v12.find("Aimbot", "Ragebot", "Main", "Double Tap", {
                fl = "Fake Lag Limit", 
                lag = "Lag Options"
            }), 
            hs = v12.find("Aimbot", "Ragebot", "Main", "Hide shots", {
                options = "Options"
            })
        }
    }, 
    antiaim = {
        __groups = {
            angles = v12.find("Aimbot", "Anti Aim", "Angles"), 
            fakelag = v12.find("Aimbot", "Anti Aim", "Fake Lag"), 
            misc = v12.find("Aimbot", "Anti Aim", "Misc")
        }, 
        fl = {
            enable = v12.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = v12.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
            var = v12.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
        }, 
        misc = {
            fd = v12.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            sw = v12.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            leg = v12.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    misc = {
        move = {
            bunnyhop = v12.find("Miscellaneous", "Main", "Movement", "Bunny Hop"), 
            airstrafe = v12.find("Miscellaneous", "Main", "Movement", "Air Strafe"), 
            airduck = v12.find("Miscellaneous", "Main", "Movement", "Air Duck"), 
            strafeassist = v12.find("Miscellaneous", "Main", "Movement", "Strafe Assist"), 
            quickstop = v12.find("Miscellaneous", "Main", "Movement", "Quick Stop")
        }, 
        other = {
            weapon_actions = v12.find("Miscellaneous", "Main", "Other", "Weapon Actions")
        }, 
        dpi = v12.find("Settings", "ESP Scale")
    }
};
v332 = nil;
v357 = {
    known_angles = function(v408)
        if v408 == 90 then
            return "Left";
        elseif v408 == -90 then
            return "Right";
        elseif v408 == 180 then
            return "Back";
        elseif v408 == 0 then
            return "Forward";
        else
            return v408 .. "\194\176";
        end;
    end, 
    ticks_to_time = function(v409)
        -- upvalues: v16 (ref)
        if v409 == 0 then
            return "Off";
        else
            return v16.format("%.2fs", v409 / 64);
        end;
    end
};
v359 = {
    nade = v12.create("\f<house-blank>", {
        [1] = {
            [1] = "hotkey", 
            [2] = "Hotkey", 
            [3] = 2
        }, 
        [2] = {
            [1] = "settings", 
            [2] = "Settings", 
            [3] = 2
        }, 
        [3] = {
            [1] = "about", 
            [2] = "About", 
            [3] = 1
        }, 
        [4] = {
            [1] = "links", 
            [2] = "Links", 
            [3] = 1
        }
    }), 
    configs = v12.create("\f<folder>", {
        [1] = {
            [1] = "list", 
            [2] = "Configs", 
            [3] = 1
        }, 
        [2] = {
            [1] = "misc", 
            [2] = "\nmisc", 
            [3] = 1
        }, 
        [3] = {
            [1] = "info", 
            [2] = "Information", 
            [3] = 2
        }, 
        [4] = {
            [1] = "options", 
            [2] = "Options", 
            [3] = 2
        }, 
        [5] = {
            [1] = "new", 
            [2] = "New", 
            [3] = 2
        }
    }), 
    editor = v12.create("\f<pen-to-square>", {
        [1] = {
            [1] = "main", 
            [2] = "Editor", 
            [3] = 1
        }, 
        [2] = {
            [1] = "list", 
            [2] = "Locations", 
            [3] = 2
        }, 
        [3] = {
            [1] = "selected", 
            [2] = "\vName", 
            [3] = 2
        }, 
        [4] = {
            [1] = "nade", 
            [2] = "Grenade", 
            [3] = 1
        }, 
        [5] = {
            [1] = "info", 
            [2] = "Information", 
            [3] = 2
        }, 
        [6] = {
            [1] = "finish", 
            [2] = "Saving", 
            [3] = 2
        }
    })
};
do
    local l_v357_1 = v357;
    v332 = {
        __groups = v359, 
        main = {
            hotkey = v359.nade.hotkey:hotkey("\nhotkey"), 
            auto = v359.nade.settings:switch("Auto-throw", true), 
            wexp = v359.nade.settings:combo("Exploit throw", {
                [1] = "Off", 
                [2] = "Fast approach", 
                [3] = "Fast move", 
                [4] = "Fast retreat"
            }), 
            style = v359.nade.settings:combo("Style", {
                [1] = "hysteria", 
                [2] = "Classic"
            }), 
            binds = v359.nade.settings:label("Binds", function(v411)
                return {
                    [1] = v411:label("\a{Small Text}Editor"), 
                    setpos = v411:hotkey("Set position and angles"), 
                    tp = v411:hotkey("Teleport to position")
                };
            end), 
            [1] = v359.nade.about:label("\a{Small Text}\f<code-commit>\r\tVersion"), 
            [2] = v359.nade.about:button(v16.format(" %s \nver", v3), nil, true), 
            [3] = v359.nade.links:label("\a{Small Text}Scripts"), 
            [4] = v359.nade.links:button("  \v\f<star-christmas>\r  hysteria  ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://market.neverlose.cc/hysteria");
            end, true), 
            [5] = v359.nade.links:label("\a{Small Text}Community"), 
            join = v359.nade.links:button("  \f<discord>  Join  ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/pDEK54EXfw");
            end, true)
        }, 
        configs = {
            list = v359.configs.list:list("\nlist", {}), 
            misc = {
                new = v359.configs.misc:button("\t\t\f<circle-plus>  New\t\t"), 
                refresh = v359.configs.misc:button("\t\v\f<arrows-rotate>\t", nil, true, "Refresh list"), 
                folder = v359.configs.misc:button("\t\f<folder>\t", function()
                    -- upvalues: v317 (ref), v17 (ref)
                    v317.open_folder(v17);
                end, true, "Open folder")
            }, 
            options = {
                load = v359.configs.options:button("\t\t\f<play>   Load\t\t", nil, false, "You can also double-click on the list to load"), 
                convert = v359.configs.options:button("  \v\f<arrow-down-to-square>\r  Convert  ", nil, true, "Convert a .json config to .ohc for quicker loading and editing."), 
                editable = v359.configs.options:switch("Editable")
            }, 
            new = {
                state = v359.configs.new:switch("state"), 
                name = v359.configs.new:input("Name", "", "Only ASCII characters."), 
                cancel = v359.configs.new:button("\t\t\t\aFF6060FF\f<xmark>\r  Cancel\t\t\t", nil, true), 
                create = v359.configs.new:button("\t\f<check>  Create\t")
            }
        }, 
        editor = {
            main = {
                new = v359.editor.main:button("\t\t\t  \f<circle-plus>\r  New  \t\t\t", nil, false), 
                import = v359.editor.main:button("\t\v\f<arrow-down-to-bracket>\r  Import\t", nil, true), 
                cancel = v359.editor.main:button("\t\aFF6060FF\f<xmark>\r  Cancel\t", nil, true), 
                back = v359.editor.main:button("\t\f<arrow-left>\t", nil, true), 
                next = v359.editor.main:button("\t\f<arrow-right>  Next\t", nil, false), 
                div = v359.editor.main:button("", nil, true)
            }, 
            finish = {
                name = v359.editor.info:input("Name\adb6b6bff*", ""), 
                desc = v359.editor.info:input("Description", ""), 
                save = v359.editor.info:button("\t\t\t\f<floppy-disk>  Save\t\t\t"), 
                export = v359.editor.info:button("\t\v\f<arrow-up-from-bracket>\r  Export\t", nil, true)
            }, 
            nade = {
                type = v359.editor.nade:combo("Grenade type", {
                    [1] = "Select", 
                    [2] = "HE", 
                    [3] = "Molly", 
                    [4] = "Smoke", 
                    [5] = "Flash"
                }), 
                [1] = v359.editor.nade:label("Angles and position"), 
                tp = v359.editor.nade:button(" TP ", nil, true), 
                setpos = v359.editor.nade:button("  Set  ", nil, false), 
                options = v359.editor.nade:label("Options", function(v412)
                    return {
                        throw = v412:combo("Throw strength", {
                            [1] = "Full", 
                            [2] = "Medium", 
                            [3] = "Short"
                        }), 
                        jump = v412:switch("Jump-throw"), 
                        duck = v412:switch("Duck-throw"), 
                        delay = v412:slider("Delay", 0, 64, 0, 1, "t")
                    };
                end), 
                pre = v359.editor.nade:switch("Move before throw", false, function(v413)
                    -- upvalues: l_v357_1 (ref)
                    local v414 = nil;
                    v414 = {
                        time = v413:slider("Duration", 0, 64, 0, 1, "t"), 
                        walk = v413:switch("Walking"), 
                        dir = v413:slider("Direction", -179, 180, 0, 1, l_v357_1.known_angles); 
                        v413:label(" "), 
                        v413:button(" \f<arrow-left> ", function()
                            -- upvalues: v414 (ref)
                            v414.dir:set(90);
                        end, true), 
                        v413:button(" \f<arrow-right> ", function()
                            -- upvalues: v414 (ref)
                            v414.dir:set(-90);
                        end, true), 
                        v413:button(" \f<arrow-down> ", function()
                            -- upvalues: v414 (ref)
                            v414.dir:set(180);
                        end, true), 
                        v413:button(" \f<arrow-up> ", function()
                            -- upvalues: v414 (ref)
                            v414.dir:set(0);
                        end, true)
                    };
                    local v415 = {
                        [1] = nil, 
                        [2] = 1, 
                        [3] = 64, 
                        [1] = v414.time
                    };
                    v414.walk:depend(v415);
                    v414.dir:depend(v415);
                    for v416 = 1, 5 do
                        v414[v416]:depend(v415);
                    end;
                    return v414, true;
                end), 
                post = v359.editor.nade:switch("Move after throw", false, function(v417)
                    -- upvalues: l_v357_1 (ref)
                    local v418 = nil;
                    v418 = {
                        jump = v417:switch("Jump"), 
                        dir = v417:slider("Direction", -179, 180, 180, 1, l_v357_1.known_angles); 
                        v417:label(" "), 
                        v417:button(" \f<arrow-left> ", function()
                            -- upvalues: v418 (ref)
                            v418.dir:set(90);
                        end, true), 
                        v417:button(" \f<arrow-right> ", function()
                            -- upvalues: v418 (ref)
                            v418.dir:set(-90);
                        end, true), 
                        v417:button(" \f<arrow-down> ", function()
                            -- upvalues: v418 (ref)
                            v418.dir:set(180);
                        end, true), 
                        v417:button(" \f<arrow-up> ", function()
                            -- upvalues: v418 (ref)
                            v418.dir:set(0);
                        end, true)
                    };
                    return v418, true;
                end)
            }, 
            locations = {
                map = v359.editor.list:combo("Map", {
                    [1] = "Current"
                }, function(v419)
                    -- upvalues: v159 (ref), v16 (ref)
                    local v420 = {};
                    for v421 = 1, #v159.grenades do
                        local v422 = v159.grenades[v421];
                        v420[v422[1]] = v16.format("%s\226\128\162\r  %s", v422.ic, v422[4]);
                    end;
                    return {
                        filter = v419:listable("\nfilter", v420), 
                        sort = v419:combo("Sort by", {
                            [1] = "Time", 
                            [2] = "Name", 
                            [3] = "Grenade"
                        })
                    };
                end), 
                list = v359.editor.list:list("\nMy locations", {}), 
                edit = v359.editor.selected:button("\t\t\f<pen>  Edit\t\t", nil, false), 
                export = v359.editor.selected:button("\t\v\f<arrow-up-from-bracket>\r  Export\t", nil, true), 
                delete = v359.editor.selected:button("  \aDEFAULT\f<trash>\r  ", nil, true)
            }
        }
    };
    v361 = 1;
    local v423 = {
        [2] = v12.get_icon("bolt"), 
        [3] = v12.get_icon("vial"), 
        [4] = v12.get_icon("brackets-curly")
    };
    local v424 = {};
    for v425 in v16.gmatch("openhelper", ".[\128-\191]*") do
        v424[#v424 + 1] = {
            d = false, 
            w = v425, 
            p = {
                [1] = 0
            }
        };
    end;
    local v426 = v15.new(#v424, 0);
    local v427 = nil;
    for v428 = 1, #v424 do
        local v429 = v424[v428];
        v426[#v426 + 1] = v16.format("\a%02x%02x%02x%02x%s", 0, 0, 0, 0, v429.w);
    end;
    v426[#v426 + 1] = v16.format("\a%02x%02x%02x%02x  \226\128\162  \a%02x%02x%02x%02x%s", 0, 0, 0, 0, 0, 0, 0, 0, v423[v4]);
    v427 = v15.concat(v426);
    v12.sidebar(v427, "\nempty");
    do
        local l_v361_1, l_v423_0, l_v424_0, l_v426_0, l_v427_0 = v361, v423, v424, v426, v427;
        local v471 = {
            [1] = {
                p = {
                    [1] = 0
                }, 
                work = function(v435)
                    -- upvalues: v156 (ref), v16 (ref), v12 (ref), l_v427_0 (ref), l_v361_1 (ref)
                    local v436, v437, v438, v439 = ui.get_style("Sidebar Text"):unpack();
                    local v440 = v156.condition(v435.p, true, 4);
                    local v441 = v16.format("\a%02x%02x%02x%02x\f<tennis-ball>", v436, v437, v438, v439 * v440);
                    v12.sidebar(l_v427_0, v441);
                    if v440 == 1 then
                        l_v361_1 = 2;
                    end;
                end
            }, 
            [2] = {
                work = function(_)
                    -- upvalues: l_v424_0 (ref), v156 (ref), l_v426_0 (ref), v16 (ref), l_v427_0 (ref), v15 (ref), v12 (ref), l_v361_1 (ref)
                    local v443 = ui.get_style("Sidebar Text");
                    local v444, v445, v446, v447 = v443:unpack();
                    for v448 = 1, #l_v424_0 do
                        local v449 = l_v424_0[v448];
                        v449.n = v449.n or globals.realtime + (v448 - 1) * 0.1;
                        v449.d = v449.d or globals.realtime >= v449.n;
                        local v450 = v156.condition(v449.p, v449.d, 2);
                        l_v426_0[v448] = v16.format("\a%02x%02x%02x%02x%s", v444, v445, v446, v447 * v450, v449.w);
                    end;
                    l_v427_0 = v15.concat(l_v426_0);
                    v12.sidebar(l_v427_0, v16.format("\a%s\f<tennis-ball>", v443:to_hex()));
                    if l_v424_0[#l_v424_0].p[1] == 1 then
                        l_v361_1 = 3;
                    end;
                end
            }, 
            [3] = {
                p = {
                    [1] = 0
                }, 
                work = function(v451)
                    -- upvalues: v156 (ref), v16 (ref), v12 (ref), l_v427_0 (ref), l_v361_1 (ref)
                    local v452 = v156.condition(v451.p, true, 3);
                    local v453, v454, v455, v456 = ui.get_style("Sidebar Text"):lerp(ui.get_style("Link Active"), v452):unpack();
                    local v457 = v16.format("\a%02x%02x%02x%02x\f<tennis-ball>", v453, v454, v455, v456);
                    v12.sidebar(l_v427_0, v457);
                    if v452 == 1 then
                        l_v361_1 = 4;
                    end;
                end
            }, 
            [4] = {
                p = {
                    [1] = 0
                }, 
                work = function(v458)
                    -- upvalues: v4 (ref), v156 (ref), l_v426_0 (ref), v16 (ref), v12 (ref), l_v423_0 (ref), l_v427_0 (ref), v15 (ref), l_v361_1 (ref)
                    if v4 > 1 then
                        local v459 = v156.condition(v458.p, true, 3);
                        local v460, v461, v462, v463 = ui.get_style("Link Active"):unpack();
                        local v464, v465, v466 = ui.get_style("Sidebar Text"):unpack();
                        l_v426_0[#l_v426_0] = v16.format("\a%02x%02x%02x%02x  \226\128\162  \a%02x%02x%02x%02x%s", v464, v465, v466, v459 * 32 * v12.alpha, v460, v461, v462, v463 * v459, l_v423_0[v4]);
                        l_v427_0 = v15.concat(l_v426_0);
                        v12.sidebar(l_v427_0, "tennis-ball");
                        if v459 == 1 then
                            l_v361_1 = 5;
                        end;
                    else
                        l_v361_1 = 5;
                    end;
                end
            }, 
            [5] = {
                work = function(_)
                    -- upvalues: l_v427_0 (ref), v4 (ref), v16 (ref), v12 (ref), l_v423_0 (ref)
                    l_v427_0 = "openhelper";
                    if v4 > 1 then
                        local v468, v469, v470 = ui.get_style("Sidebar Text"):unpack();
                        l_v427_0 = v16.format("openhelper\a%02x%02x%02x%02x  \226\128\162  \v%s", v468, v469, v470, 32 * v12.alpha, l_v423_0[v4]);
                    end;
                    v12.sidebar(l_v427_0, "\f<tennis-ball>");
                end
            }
        };
        local function v472()
            -- upvalues: l_v361_1 (ref), v471 (ref), v122 (ref), v472 (ref)
            if l_v361_1 then
                v471[l_v361_1]:work();
            else
                v122.render:unset(v472);
            end;
        end;
        utils.execute_after(0.25, function()
            -- upvalues: v122 (ref), v472 (ref)
            v122.render:set(v472);
        end);
    end;
    v331.misc.dpi:set_callback(function()
        -- upvalues: v155 (ref)
        utils.execute_after(0, v155.dpi_t.callback);
    end, true);
end;
v357 = nil;
v359 = {};
v361 = {};
local v473 = {};
local v474 = {};
local v475 = {};
local l_configs_0 = v332.configs;
local v477 = {
    [".ohc"] = true, 
    [".json"] = true
};
local v478 = nil;
do
    local l_v359_1, l_v361_2, l_v473_0, l_v474_0, l_v475_0, l_l_configs_0_0, l_v477_0, l_v478_0 = v359, v361, v473, v474, v475, l_configs_0, v477, v478;
    l_v478_0 = {
        create = function(v487, v488)
            -- upvalues: l_v477_0 (ref), v16 (ref), v17 (ref), v328 (ref), v0 (ref), v330 (ref)
            local l_v487_0 = v487;
            if not v488 then
                v488 = ".json";
            end;
            v487 = l_v487_0;
            if not l_v477_0[v488] then
                return;
            else
                l_v487_0 = v16.format(v17 .. "%s%s", v487, v488);
                if files.read(l_v487_0) then
                    return v328[false]("\v%s%s\r already exists.", v487, v488);
                else
                    local v490 = {
                        info = {
                            author = v0, 
                            created = common.get_unixtime()
                        }, 
                        locations = {}
                    };
                    if v488 == ".json" then
                        files.write(l_v487_0, json.stringify(v490), true);
                    elseif v488 == ".ohc" then
                        files.write(l_v487_0, v330.encode(v490), true);
                    end;
                    return;
                end;
            end;
        end, 
        parse = function(v491, v492)
            -- upvalues: v330 (ref), v2 (ref)
            local _ = nil;
            local v494 = nil;
            local v495 = nil;
            if v492 then
                local l_status_1, l_result_1 = pcall(function()
                    -- upvalues: v330 (ref), v491 (ref)
                    return v330.decode(v491);
                end);
                v494 = l_result_1;
                if not l_status_1 then
                    return;
                elseif type(v494.info) ~= "table" or type(v494.locations) ~= "table" then
                    return false;
                else
                    v495 = {
                        info = v494.info, 
                        locations = v494.locations
                    };
                end;
            else
                local l_status_2, l_result_2 = pcall(json.parse, v491);
                v494 = l_result_2;
                if not l_status_2 then
                    return;
                else
                    v495 = {
                        info = {
                            author = "unknown", 
                            ported = true, 
                            game = v2
                        }, 
                        locations = v330.convert(v494)
                    };
                end;
            end;
            return v495;
        end, 
        load = function(v500)
            -- upvalues: v16 (ref), l_v477_0 (ref), v17 (ref), v328 (ref), l_v478_0 (ref), v0 (ref), l_v359_1 (ref), v122 (ref)
            local v501, v502 = v16.match(v500, "(.*)(%.%w*)$");
            if not v502 or not l_v477_0[v502] then
                return;
            else
                local v503 = files.read(v17 .. v500);
                if not v503 then
                    return v328[false]("\v%s\r not found.", v500);
                else
                    local v504 = l_v478_0.parse(v503, v502 == ".ohc");
                    if not v504 then
                        return v328[false]("\v%s\r is corrupted.", v501);
                    elseif v504.info.vip ~= nil and v504.info.vip ~= v0 then
                        return v328[false]("\v%s\r is private and not available for you.", v500);
                    else
                        l_v359_1[v500] = v504;
                        v122.oh_configs_update:call(v500, true);
                        return;
                    end;
                end;
            end;
        end, 
        unload = function(v505)
            -- upvalues: l_v359_1 (ref), v122 (ref)
            l_v359_1[v505] = nil;
            v122.oh_configs_update:call(v505, false);
        end, 
        rewrite_editable = function()
            -- upvalues: v329 (ref), v16 (ref), l_v477_0 (ref), l_v359_1 (ref), v17 (ref), v330 (ref)
            local l_editable_0 = v329.configs.editable;
            if not l_editable_0 then
                return;
            else
                local _, v508 = v16.match(l_editable_0, "(.*)(%.%w*)$");
                if not v508 or not l_v477_0[v508] or v508 == ".json" then
                    return;
                else
                    local v509 = l_v359_1[l_editable_0];
                    if not v509 then
                        return;
                    else
                        local v510 = v17 .. l_editable_0;
                        files.write(v510, v508 == ".ohc" and v330.encode(v509) or json.stringify(v509), true);
                        return;
                    end;
                end;
            end;
        end, 
        update_page = function()
            -- upvalues: l_v473_0 (ref), l_l_configs_0_0 (ref), v332 (ref), v16 (ref), v329 (ref)
            local v511 = l_v473_0[l_l_configs_0_0.list.value];
            v332.__groups.configs.options:visibility(v511 ~= nil);
            if not v511 then
                return;
            else
                v332.__groups.configs.options:name(v16.format("\v%s\r \226\128\148 Options", v511.name));
                l_l_configs_0_0.options.load:name(v511.loaded and "\t\t\f<stop>  Unload\t\t" or "\t\t \f<play>   Load \t\t");
                l_l_configs_0_0.options.convert:visibility(v511.ext == ".json");
                l_l_configs_0_0.options.convert:disabled(not v511.loaded);
                l_l_configs_0_0.options.editable:visibility(v511.loaded);
                l_l_configs_0_0.options.editable:disabled(v511.ext == ".json" or v329.configs.editable == v511.name);
                l_l_configs_0_0.options.editable:set(v329.configs.editable == v511.name);
                return;
            end;
        end, 
        refresh = function()
            -- upvalues: l_v473_0 (ref), l_v474_0 (ref), l_v475_0 (ref), v317 (ref), v17 (ref), v16 (ref), l_v477_0 (ref), l_v359_1 (ref), v329 (ref), v12 (ref), l_v478_0 (ref), l_l_configs_0_0 (ref), v122 (ref)
            local v512 = 0;
            local v513 = {};
            local v514 = {};
            local v515 = {};
            l_v475_0 = {};
            l_v474_0 = v515;
            l_v473_0 = v514;
            v317.for_each(v17 .. "*.*", function(v516)
                -- upvalues: v16 (ref), l_v477_0 (ref), v512 (ref), l_v359_1 (ref), v329 (ref), l_v473_0 (ref), l_v474_0 (ref), l_v475_0 (ref), v513 (ref), v12 (ref)
                local v517, v518 = v16.match(v516, "(.*)(%.%w*)$");
                local l_v516_0 = v516;
                if l_v477_0[v518] then
                    v512 = v512 + 1;
                    local v520 = l_v359_1[l_v516_0] ~= nil;
                    local v521 = v329.configs.editable == l_v516_0;
                    local l_l_v473_0_0 = l_v473_0;
                    local l_v512_0 = v512;
                    local l_l_v474_0_0 = l_v474_0;
                    local l_l_v475_0_0 = l_v475_0;
                    local l_v512_1 = v512;
                    local v527 = {
                        j = v512, 
                        name = l_v516_0, 
                        ext = v518, 
                        loaded = v520
                    };
                    local l_v512_2 = v512;
                    l_l_v475_0_0[l_v512_1] = l_v516_0;
                    l_l_v474_0_0[l_v516_0] = l_v512_2;
                    l_l_v473_0_0[l_v512_0] = v527;
                    v513[v512] = v12.string(v16.format("%s%s  %s", v520 and "\v\226\128\162\r   " or "", v518 == ".json" and l_v516_0 or v517, v521 and "\f<pen>" or ""));
                end;
            end);
            for v529, _ in next, l_v359_1 do
                if not l_v474_0[v529] then
                    l_v478_0.unload(v529);
                end;
            end;
            l_l_configs_0_0.list:update(v513);
            l_v478_0.update_page();
            v122.oh_configs_refresh:call();
        end, 
        delete = function(v531)
            if not v531 then

            end;
        end
    };
    if v1 then
        l_v478_0.create("My locations", ".ohc");
        l_v478_0.load("My locations.ohc");
        v329.configs.editable = "My locations.ohc";
    end;
    local v532 = {
        time = 0
    };
    do
        local l_v532_0 = v532;
        l_l_configs_0_0.list:set_callback(function(v534)
            -- upvalues: l_v532_0 (ref), l_v473_0 (ref), l_v478_0 (ref)
            local l_realtime_0 = globals.realtime;
            local l_value_0 = v534.value;
            if l_v532_0.value == l_value_0 and l_realtime_0 - l_v532_0.time <= 0.5 then
                local v537 = l_v473_0[v534.value];
                l_v478_0[v537.loaded and "unload" or "load"](v537.name, v537.ext);
                l_v532_0.time = l_v532_0.time - 0.5;
                return;
            else
                local l_l_v532_0_0 = l_v532_0;
                local l_l_v532_0_1 = l_v532_0;
                local l_l_realtime_0_0 = l_realtime_0;
                l_l_v532_0_1.value = l_value_0;
                l_l_v532_0_0.time = l_l_realtime_0_0;
                return;
            end;
        end);
    end;
    l_l_configs_0_0.options.load:set_callback(function()
        -- upvalues: l_v473_0 (ref), l_l_configs_0_0 (ref), l_v478_0 (ref)
        local v541 = l_v473_0[l_l_configs_0_0.list.value];
        l_v478_0[v541.loaded and "unload" or "load"](v541.name, v541.ext);
        l_v478_0.update_page();
    end);
    l_l_configs_0_0.misc.refresh:set_callback(l_v478_0.refresh, true);
    l_l_configs_0_0.list:set_callback(l_v478_0.update_page, true);
    l_l_configs_0_0.misc.new:set_callback(function()
        -- upvalues: l_l_configs_0_0 (ref)
        l_l_configs_0_0.new.name:reset();
        l_l_configs_0_0.new.state:set(true);
    end);
    l_l_configs_0_0.new.cancel:set_callback(function()
        -- upvalues: l_l_configs_0_0 (ref)
        l_l_configs_0_0.new.state:set(false);
    end);
    l_l_configs_0_0.misc.new:depend(true, {
        [1] = nil, 
        [2] = false, 
        [1] = l_l_configs_0_0.new.state
    });
    l_l_configs_0_0.new.state:visibility(false);
    l_l_configs_0_0.new.name:set_callback(function(v542)
        -- upvalues: v16 (ref)
        v542.value = v16.clean(v542.value);
    end);
    l_l_configs_0_0.new.create:depend(true, {
        [1] = l_l_configs_0_0.new.name, 
        [2] = function()
            -- upvalues: v16 (ref), l_l_configs_0_0 (ref)
            return v16.is_valid(l_l_configs_0_0.new.name.value, true, true);
        end
    });
    v332.__groups.configs.new:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_l_configs_0_0.new.state
    });
    l_l_configs_0_0.new.create:set_callback(function()
        -- upvalues: l_l_configs_0_0 (ref), l_v478_0 (ref)
        l_l_configs_0_0.new.state:set(false);
        l_v478_0.create(l_l_configs_0_0.new.name.value, ".ohc");
        l_v478_0.refresh();
    end);
    l_l_configs_0_0.options.convert:set_callback(function(_)
        -- upvalues: l_v473_0 (ref), l_l_configs_0_0 (ref), l_v359_1 (ref), v0 (ref), v2 (ref), v16 (ref), v17 (ref), v330 (ref), v328 (ref), l_v478_0 (ref)
        local v544 = l_v473_0[l_l_configs_0_0.list.value];
        local v545 = l_v359_1[v544.name];
        if not v545 or v544.ext ~= ".json" then
            return;
        else
            local v546 = {
                info = {
                    ported = true, 
                    author = v0, 
                    game = v2
                }, 
                locations = v545.locations
            };
            local v547 = v16.format(v17 .. "%s_ported.ohc", v16.gsub(v544.name, "%" .. v544.ext, ""));
            local v548 = files.write(v547, v330.encode(v546), true);
            v328[v548](v548 and "Successfully converted and saved at \v" .. v547 or "Something went wrong while saving a converted file.");
            utils.execute_after(0.5, l_v478_0.refresh);
            return;
        end;
    end);
    l_l_configs_0_0.options.editable:set_callback(function(v549)
        -- upvalues: l_v473_0 (ref), l_l_configs_0_0 (ref), v329 (ref), l_v478_0 (ref), v122 (ref)
        if v549.value then
            local v550 = l_v473_0[l_l_configs_0_0.list.value];
            v329.configs.editable = v550.name;
            l_v478_0.refresh();
            v122.oh_configs_editable:call(v550);
        end;
    end);
    v122.oh_configs_update:set(function()
        -- upvalues: l_v478_0 (ref), l_v361_2 (ref), l_v359_1 (ref), v329 (ref)
        l_v478_0.refresh();
        l_v361_2 = {};
        for v551, _ in next, l_v359_1 do
            l_v361_2[#l_v361_2 + 1] = v551;
        end;
        v329.configs.loaded = l_v361_2;
    end);
    if v329.configs.editable and not v317.exists(v17 .. v329.configs.editable) then
        v329.configs.editable = nil;
    end;
    for _, v554 in ipairs(v329.configs.loaded) do
        l_v478_0.load(v554);
    end;
    v357 = {
        loaded = l_v359_1, 
        refresh = l_v478_0.refresh, 
        rewrite_editable = l_v478_0.rewrite_editable
    };
end;
v359 = nil;
v359 = {
    location = {
        v = false, 
        a = 0, 
        n = 1, 
        d = 0, 
        [1] = {
            N = "New location", 
            T = 5, 
            s = {
                [1] = 0, 
                [2] = 0, 
                [3] = -1024
            }
        }, 
        p = vector(unpack({
            [1] = 0, 
            [2] = 0, 
            [3] = -1024
        }, 1, 3)), 
        as = {
            [1] = {
                g = {
                    [1] = 0
                }, 
                f = {
                    [1] = 0
                }, 
                s = {
                    [1] = 0
                }
            }
        }, 
        ag = {
            g = {
                [1] = 0
            }, 
            s = {
                [1] = 0
            }
        }
    }
};
v361 = v357.loaded[v329.configs.editable];
v473 = v332.editor;
v474 = v332.__groups;
v475 = v474.editor.main:slider("\neditor:state", -2, 3, 0);
v475:reset();
utils.execute_after(0, v475.reset, v475);
l_configs_0 = {
    array = {}, 
    hash = {}
};
v477 = {
    Name = function(v555)
        -- upvalues: v15 (ref), v16 (ref)
        v15.sort(v555, function(v556, v557)
            -- upvalues: v16 (ref)
            return (v556.N and v16.lower(v556.N) or "~") < (v557.N and v16.lower(v557.N) or "~");
        end);
    end, 
    Grenade = function(v558)
        -- upvalues: v15 (ref), v16 (ref)
        v15.sort(v558, function(v559, v560)
            -- upvalues: v16 (ref)
            if v559.T ~= v560.T then
                return v559.T < v560.T;
            else
                return (v559.N and v16.lower(v559.N) or "~") < (v560.N and v16.lower(v560.N) or "~");
            end;
        end);
    end
};
v478 = nil;
do
    local l_v361_3, l_v473_1, l_v474_1, l_v475_1, l_l_configs_0_1, l_v477_1, l_v478_1 = v361, v473, v474, v475, l_configs_0, v477, v478;
    l_v478_1 = {
        parse = function(v568)
            -- upvalues: l_v361_3 (ref), l_v473_1 (ref), v15 (ref), l_v477_1 (ref), v160 (ref)
            if not l_v361_3 then
                return {};
            else
                local l_map_0 = l_v473_1.locations.map;
                local v570 = nil;
                local v571 = v15.copy(v568 and l_v361_3.locations[v568] or {});
                local l_value_1 = l_map_0.filter.value;
                local v573 = l_v477_1[l_map_0.sort.value];
                local v574 = #l_value_1 > 0 and #l_value_1 < #v160.grenades_id_to_cn;
                local v575 = v573 ~= nil;
                if v574 or v575 then
                    for v576 = 1, #v571 do
                        v571[v576].__id = v571[v576].__id or v576;
                    end;
                    if v574 then
                        local v577 = {};
                        local v578 = v15.new(#v160.grenades_id_to_cn, 0);
                        for v579 = 1, #l_value_1 do
                            v578[l_value_1[v579]] = true;
                        end;
                        local v580 = 0;
                        for v581 = 1, #v571 do
                            local v582 = v571[v581];
                            if v578[v582.T] then
                                v580 = v580 + 1;
                                v577[v580] = v582;
                            end;
                        end;
                        v571 = v577;
                    end;
                    if v575 then
                        v573(v571);
                    end;
                    v570 = v15.new(#v571, 0);
                    for v583 = 1, #v571 do
                        local v584 = v571[v583];
                        local l___id_0 = v571[v583].__id;
                        v584.__id = nil;
                        v570[v583] = l___id_0;
                    end;
                end;
                return v571, v570;
            end;
        end, 
        update_list = function()
            -- upvalues: l_v361_3 (ref), l_v473_1 (ref), v305 (ref), l_v478_1 (ref), v15 (ref), v160 (ref), v16 (ref), v159 (ref), l_v474_1 (ref), v329 (ref), l_l_configs_0_1 (ref), v122 (ref)
            local v586 = {
                [1] = "Current"
            };
            local v587 = 2;
            local l_next_0 = next;
            local v589 = l_v361_3 and l_v361_3.locations or {};
            for v590, _ in l_next_0, v589 do
                local l_v587_0 = v587;
                local l_v590_0 = v590;
                v587 = v587 + 1;
                v586[l_v587_0] = l_v590_0;
            end;
            l_v473_1.locations.map:update(v586);
            if l_v361_3 then
                v586 = l_v473_1.locations.map.value ~= "Current" and l_v473_1.locations.map.value or v305.map;
                v587, l_next_0 = l_v478_1.parse(v586);
                v589 = v15.new(#v587, 0);
                for v594 = 1, #v587 do
                    local v595 = v587[v594];
                    local v596 = v160.grenades_id_to_tid[v595.T];
                    v589[v594] = v16.format("%s\226\128\162\aDEFAULT  %s\n%d", v159.grenades[v596].ic or "", v595.N or "\aB04040FFunnamed", v594);
                end;
                l_v474_1.editor.list:name(v16.format("\v%s\r \226\128\148 %s", v329.configs.editable, v586));
                l_v473_1.locations.list:update(v589);
                local l_l_l_configs_0_1_0 = l_l_configs_0_1;
                local l_l_l_configs_0_1_1 = l_l_configs_0_1;
                local l_v587_1 = v587;
                l_l_l_configs_0_1_1.hash = l_next_0;
                l_l_l_configs_0_1_0.array = l_v587_1;
            else
                l_v474_1.editor.list:name("Locations");
                l_v473_1.locations.list:update({});
                v15.clear(l_l_configs_0_1.array);
                l_l_configs_0_1.hash = nil;
            end;
            v122.oh_editor_list_update:call();
        end, 
        reset = function()
            -- upvalues: v12 (ref), l_v473_1 (ref), v359 (ref), v122 (ref), l_v474_1 (ref)
            v12.traverse({
                [1] = l_v473_1.nade, 
                [2] = l_v473_1.info, 
                [3] = l_v473_1.finish
            }, function(v600, _)
                v600:reset();
                for _, v603 in next, v600[1] do
                    v603:reset();
                end;
            end);
            v359.context = nil;
            v122.oh_editor_reset:call();
            utils.execute_after(0, function()
                -- upvalues: l_v474_1 (ref)
                l_v474_1.editor.selected:visibility(false);
            end);
        end, 
        export = function(v604, v605)
            -- upvalues: v330 (ref), v16 (ref), v2 (ref)
            local v606 = v330.encode({
                map = v604, 
                payload = v605
            });
            return v16.format("openhelper::%s<%s>", v2, v606);
        end
    };
    local function v607()
        -- upvalues: l_v361_3 (ref), v357 (ref), v329 (ref), l_v478_1 (ref)
        l_v361_3 = v357.loaded[v329.configs.editable];
        l_v478_1.update_list();
    end;
    v607();
    v122.oh_configs_editable:set(v607);
    v122.oh_configs_update:set(v607);
    v122.oh_editor_saved:set(l_v478_1.update_list);
    v122.local_disconnect:set(l_v478_1.update_list);
    v122.level_init:set(l_v478_1.update_list);
    l_v473_1.locations.map:set_callback(l_v478_1.update_list);
    l_v473_1.locations.map.sort:set_callback(l_v478_1.update_list);
    l_v473_1.locations.map.filter:set_callback(l_v478_1.update_list);
    v607 = {
        start = function(v608)
            -- upvalues: l_v475_1 (ref), v359 (ref), v305 (ref), v329 (ref), l_v474_1 (ref), v122 (ref)
            l_v475_1:set(1);
            utils.execute_after(0.33, function()
                -- upvalues: l_v475_1 (ref), v359 (ref), v305 (ref), v329 (ref), v608 (ref), l_v474_1 (ref), v122 (ref)
                l_v475_1:set(2);
                v359.context = {
                    map = v305.map, 
                    config = v329.configs.editable
                };
                if type(v608) == "function" then
                    v608();
                end;
                l_v474_1.editor.selected:visibility(false);
                utils.execute_after(0, function()
                    -- upvalues: v122 (ref)
                    v122.oh_editor_started:call();
                end);
            end);
        end, 
        main = function(v609)
            -- upvalues: l_v475_1 (ref), l_v478_1 (ref), l_v474_1 (ref)
            l_v475_1:set(1);
            utils.execute_after(0.33, function()
                -- upvalues: l_v478_1 (ref), v609 (ref), l_v475_1 (ref), l_v474_1 (ref)
                l_v478_1.reset();
                if type(v609) == "function" then
                    v609();
                end;
                l_v475_1:set(0);
                l_v474_1.editor.selected:visibility(false);
            end);
        end
    };
    v122.pre_render:set(function()
        -- upvalues: l_v361_3 (ref), l_v475_1 (ref), l_v478_1 (ref), v305 (ref)
        if not l_v361_3 then
            if l_v475_1.value ~= -2 then
                l_v475_1:set(-2);
                l_v478_1.reset();
            end;
        elseif not v305.valid then
            if l_v475_1.value ~= -1 then
                l_v475_1:set(-1);
                l_v478_1.reset();
            end;
        elseif l_v475_1.value < 0 then
            l_v475_1:set(0);
        end;
    end);
    l_v473_1.main.new:set_callback(v607.start);
    l_v473_1.main.import:set_callback(function()
        -- upvalues: v321 (ref), v16 (ref), v330 (ref), l_v361_3 (ref), v2 (ref), v122 (ref), v328 (ref), v357 (ref)
        local v610 = v321.get();
        if not v610 then
            return;
        else
            local v611 = 0;
            for v612, v613 in v16.gmatch(v610, "openhelper::(%w-)<(.-)>") do
                v613 = v330.decode(v613);
                if v330.validate_loc(v613.payload) then
                    local v614 = l_v361_3.locations[v613.map];
                    if not v614 then
                        l_v361_3.locations[v613.map] = {};
                        v614 = l_v361_3.locations[v613.map];
                    end;
                    if v612 ~= v2 then
                        v613.payload.N = v16.format("%s [%s]", v613.payload.N, v612);
                    end;
                    local v615 = #v614 + 1;
                    v614[v615] = v613.payload;
                    v611 = v611 + 1;
                    v122.oh_editor_saved:call(v615, v613.payload, v613.map);
                end;
            end;
            if v611 > 0 then
                v328[true]("%d location%s %s been imported.", v611, v611 == 1 and "" or "s", v611 == 1 and "has" or "have");
                v357.rewrite_editable();
                v122.oh_configs_update:call();
            end;
            return;
        end;
    end);
    l_v473_1.main.cancel:set_callback(v607.main);
    l_v473_1.main.next:set_callback(function()
        -- upvalues: l_v475_1 (ref), v122 (ref)
        local v616 = l_v475_1.value + 1;
        l_v475_1:set(v616);
        l_v475_1.value = v616;
        v122.oh_editor_update:call();
    end);
    l_v473_1.main.back:set_callback(function()
        -- upvalues: l_v475_1 (ref), v122 (ref)
        local v617 = l_v475_1.value - 1;
        l_v475_1:set(v617);
        l_v475_1.value = v617;
        v122.oh_editor_update:call();
    end);
    v122.oh_editor_started:set(function()
        -- upvalues: v359 (ref), l_v473_1 (ref), v15 (ref), v159 (ref), v305 (ref)
        local l_context_0 = v359.context;
        l_v473_1.main.next:disabled(l_context_0 and l_context_0.s == nil);
        local v619 = v15.distribute(v159.grenades, 4, 2)[v305.weapon.m_iItemDefinitionIndex];
        if v619 and l_v473_1.nade.type:get() == "Select" then
            l_v473_1.nade.type:set(v619);
        end;
        local v620 = l_context_0 and l_context_0.map ~= v305.map;
        l_v473_1.nade[1]:disabled(v620);
        l_v473_1.nade.tp:disabled(v620);
        l_v473_1.nade.setpos:disabled(v620);
    end);
    v122.oh_editor_reset:set(function()
        -- upvalues: l_v473_1 (ref)
        l_v473_1.nade.setpos:tooltip("Position and angles not set.");
    end);
    v122.oh_editor_saved:set(function(_, _, v623)
        -- upvalues: v15 (ref), l_v361_3 (ref), l_v478_1 (ref)
        v15.sort(l_v361_3.locations[v623], function(v624, v625)
            return v624.T < v625.T;
        end);
        l_v478_1.update_list();
    end);
    v122.oh_editor_update:set(function()
        -- upvalues: v359 (ref)
        local v626 = v359.context or {};
        local v627 = v359.location[1];
        v627.N = v626.N or "New location";
        v627.D = v626.D;
        v627.T = v626.T or 5;
        v627.s = v626.s or {
            [1] = 0, 
            [2] = 0, 
            [3] = -1024, 
            [4] = 0, 
            [5] = 0
        };
        v627.j = v626.j;
        v627.c = v626.c;
        v627.d = v626.d;
        v627.t = v626.t;
        v627.z = v626.z;
        v627.x = v626.x;
        v359.location.p = vector(unpack(v626.s or {
            [1] = 0, 
            [2] = 0, 
            [3] = -1024
        }, 1, 3));
    end);
    local function v633()
        -- upvalues: l_v473_1 (ref), l_l_configs_0_1 (ref), v305 (ref), l_v361_3 (ref), v329 (ref)
        local l_value_2 = l_v473_1.locations.list.value;
        if l_l_configs_0_1.hash then
            local v629 = l_l_configs_0_1.hash[l_value_2];
            if v629 then
                l_value_2 = v629;
            end;
        end;
        local v630 = l_v473_1.locations.map:get();
        if v630 == "Current" then
            local l_map_1 = v305.map;
            if l_map_1 then
                v630 = l_map_1;
            end;
        end;
        local v632 = l_v361_3 and l_v361_3.locations[v630];
        return v632 and v632[l_value_2], v630, l_value_2, v329.configs.editable;
    end;
    local v634, v635, v636, v637 = v633();
    do
        local l_v633_0, l_v634_0, l_v635_0, l_v636_0, l_v637_0 = v633, v634, v635, v636, v637;
        v122.oh_editor_list_update:set(function()
            -- upvalues: l_v634_0 (ref), l_v633_0 (ref)
            l_v634_0 = l_v633_0();
        end);
        l_v473_1.locations.list:set_callback(function(_)
            -- upvalues: l_v634_0 (ref), l_v633_0 (ref), l_v475_1 (ref), l_v474_1 (ref), v16 (ref), v160 (ref)
            l_v634_0 = l_v633_0();
            if l_v475_1.value ~= 0 then
                return;
            else
                if l_v634_0 then
                    l_v474_1.editor.selected:visibility(true);
                    l_v474_1.editor.selected:name(v16.format("\v%s\r \226\128\148 %s", l_v634_0.N, v160.grenades_id_to_name[l_v634_0.T]));
                else
                    l_v474_1.editor.selected:visibility(false);
                end;
                return;
            end;
        end);
        l_v473_1.locations.edit:set_callback(function()
            -- upvalues: v607 (ref), l_v634_0 (ref), l_v635_0 (ref), l_v636_0 (ref), l_v637_0 (ref), l_v633_0 (ref), v359 (ref), v305 (ref), l_v473_1 (ref), v160 (ref), v15 (ref), v16 (ref), v122 (ref)
            v607.start(function()
                -- upvalues: l_v634_0 (ref), l_v635_0 (ref), l_v636_0 (ref), l_v637_0 (ref), l_v633_0 (ref), v359 (ref), v305 (ref), l_v473_1 (ref), v160 (ref), v15 (ref), v16 (ref), v122 (ref)
                local v644, v645, v646, v647 = l_v633_0();
                l_v637_0 = v647;
                l_v636_0 = v646;
                l_v635_0 = v645;
                l_v634_0 = v644;
                v359.context.orig = l_v636_0;
                v359.context.map = l_v635_0 or v305.map;
                l_v473_1.nade.type:set(v160.grenades_id_to_name[l_v634_0.T]);
                v359.context.s = v15.copy(l_v634_0.s);
                l_v473_1.nade.setpos:tooltip(v16.format("Pos: \v{ %.2f, %.2f, %.2f }\r\nAng: \v{ %.1f\194\176, %.1f\194\176 }\r", unpack(l_v634_0.s)));
                l_v473_1.nade.options.throw:set(l_v634_0.t and v160.throw_strength[l_v634_0.t] or "Full");
                l_v473_1.nade.options.jump:set(l_v634_0.j == true);
                l_v473_1.nade.options.duck:set(l_v634_0.c == true);
                l_v473_1.nade.options.delay:set(l_v634_0.d or 0);
                if l_v634_0.z then
                    l_v473_1.nade.pre:set(true);
                    l_v473_1.nade.pre.dir:set(l_v634_0.z[1]);
                    l_v473_1.nade.pre.time:set(l_v634_0.z[2]);
                    l_v473_1.nade.pre.walk:set(l_v634_0.z[3] == true);
                end;
                if l_v634_0.x then
                    l_v473_1.nade.post:set(true);
                    l_v473_1.nade.post.dir:set(l_v634_0.x[1]);
                    l_v473_1.nade.post.jump:set(l_v634_0.x[2] == true);
                end;
                l_v473_1.finish.name:set(l_v634_0.N or "unnamed");
                l_v473_1.finish.desc:set(l_v634_0.D or "");
                v122.oh_editor_update:call();
            end);
        end);
        l_v473_1.locations.export:set_callback(function()
            -- upvalues: l_v635_0 (ref), l_v634_0 (ref), v321 (ref), l_v478_1 (ref)
            if l_v635_0 ~= nil and l_v634_0 ~= nil then
                v321.set(l_v478_1.export(l_v635_0, l_v634_0));
            end;
        end);
        local v648 = 0;
        local v649 = false;
        do
            local l_v648_0, l_v649_0 = v648, v649;
            local function v652()
                -- upvalues: l_v648_0 (ref), l_v649_0 (ref), l_v473_1 (ref), v122 (ref), v652 (ref)
                if l_v648_0 < globals.realtime or l_v649_0 == false then
                    l_v473_1.locations.delete:name("  \f<trash>\r  ");
                    v122.render:unset(v652);
                    l_v649_0 = false;
                end;
            end;
            l_v473_1.locations.delete:set_callback(function()
                -- upvalues: l_v649_0 (ref), l_v473_1 (ref), l_l_configs_0_1 (ref), v305 (ref), l_v361_3 (ref), v15 (ref), v357 (ref), v122 (ref), l_v648_0 (ref), v652 (ref)
                if l_v649_0 then
                    local l_value_3 = l_v473_1.locations.list.value;
                    if l_l_configs_0_1.hash then
                        local v654 = l_l_configs_0_1.hash[l_value_3];
                        if v654 then
                            l_value_3 = v654;
                        end;
                    end;
                    local v655 = l_v473_1.locations.map:get();
                    if v655 == "Current" then
                        local l_map_2 = v305.map;
                        if l_map_2 then
                            v655 = l_map_2;
                        end;
                    end;
                    local v657 = l_v361_3.locations[v655];
                    if v657 and v657[l_value_3] then
                        v15.remove(v657, l_value_3);
                        v357.rewrite_editable();
                        v122.oh_editor_saved:call(nil, nil, v655);
                        v122.oh_configs_update:call();
                    end;
                    l_v649_0 = false;
                else
                    l_v473_1.locations.delete:name("  \ad25151ff\f<trash>\r  ");
                    local v658 = globals.realtime + 1;
                    l_v649_0 = true;
                    l_v648_0 = v658;
                    v122.render:set(v652);
                end;
            end);
        end;
    end;
    l_v475_1:visibility(false);
    l_v473_1.main.new:depend({
        [1] = nil, 
        [2] = -1, 
        [3] = 0, 
        [1] = l_v475_1
    });
    l_v473_1.main.import:depend({
        [1] = nil, 
        [2] = -1, 
        [3] = 0, 
        [1] = l_v475_1
    });
    l_v473_1.main.cancel:depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = l_v475_1
    });
    l_v473_1.main.back:depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = l_v475_1
    });
    l_v473_1.main.next:depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = l_v475_1
    });
    l_v473_1.main.back:depend(true, {
        [1] = nil, 
        [2] = 3, 
        [1] = l_v475_1
    });
    l_v473_1.main.div:depend({
        [1] = nil, 
        [2] = 1, 
        [1] = l_v475_1
    });
    l_v474_1.editor.main:depend(true, {
        [1] = nil, 
        [2] = 0, 
        [3] = 3, 
        [1] = l_v475_1
    });
    l_v474_1.editor.nade:depend({
        [1] = nil, 
        [2] = 2, 
        [3] = 3, 
        [1] = l_v475_1
    });
    l_v474_1.editor.nade:depend(true, {
        [1] = nil, 
        [2] = 2, 
        [1] = l_v475_1
    });
    l_v474_1.editor.info:depend({
        [1] = nil, 
        [2] = 3, 
        [1] = l_v475_1
    });
    l_v474_1.editor.info:depend(true, {
        [1] = nil, 
        [2] = 3, 
        [1] = l_v475_1
    });
    l_v474_1.editor.list:depend({
        [1] = nil, 
        [2] = -1, 
        [3] = 0, 
        [1] = l_v475_1
    });
    l_v474_1.editor.list:depend(true, {
        [1] = nil, 
        [2] = 0, 
        [1] = l_v475_1
    });
    l_v474_1.editor.selected:depend({
        [1] = nil, 
        [2] = 0, 
        [1] = l_v475_1
    });
    l_v474_1.editor.selected:depend(true, {
        [1] = nil, 
        [2] = 0, 
        [1] = l_v475_1
    });
    v633 = {
        [1] = l_v473_1.finish.name, 
        [2] = function(v659)
            -- upvalues: v16 (ref)
            return v16.is_valid(v659.value);
        end
    };
    l_v473_1.finish.name:set_callback(function(v660)
        -- upvalues: v16 (ref)
        v660.value = v16.clean(v660.value);
    end);
    l_v473_1.finish.desc:set_callback(function(v661)
        -- upvalues: v16 (ref)
        v661.value = v16.clean(v661.value);
    end);
    l_v473_1.finish.save:depend(true, v633);
    l_v473_1.finish.export:depend(true, v633);
    l_v473_1.finish.desc:depend(v633);
    l_v473_1.nade.type:set_callback(function(v662)
        -- upvalues: v359 (ref), v160 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.T = v160.grenades_name_to_id[v662.value];
            v122.oh_editor_update:call();
            return;
        end;
    end);
    v633 = function()
        -- upvalues: v359 (ref), v305 (ref), v328 (ref), v155 (ref), v14 (ref), l_v473_1 (ref), v16 (ref), v122 (ref)
        if v359.context == nil then
            return;
        elseif v305.velocity > 1.5 or not v305.on_ground then
            return v328[false]("Stay still while setting position.");
        else
            local v663, v664, v665 = v305.self:get_origin():unpack();
            local v666, v667 = v155.camera_angles():unpack();
            local v668 = v14.roundb(v663, 4);
            local v669 = v14.roundb(v664, 4);
            local v670 = v14.roundb(v665, 4);
            local v671 = v14.roundb(v666, 5);
            v667 = v14.roundb(v667, 5);
            v666 = v671;
            v665 = v670;
            v664 = v669;
            v663 = v668;
            v359.context.s = {
                [1] = v663, 
                [2] = v664, 
                [3] = v665, 
                [4] = v666, 
                [5] = v667
            };
            l_v473_1.nade.setpos:tooltip(v16.format("Pos: \v{ %.2f, %.2f, %.2f }\r\nAng: \v{ %.1f\194\176, %.1f\194\176 }\r", v663, v664, v665, v666, v667));
            v122.oh_editor_update:call();
            return;
        end;
    end;
    v634 = function()
        -- upvalues: v359 (ref), v328 (ref), v160 (ref), v16 (ref)
        if v359.context == nil then
            return;
        else
            local l_s_0 = v359.context.s;
            if not l_s_0 then
                return v328[false]("You have not set position and angles yet.");
            elseif cvar.sv_cheats:int() == 0 then
                return v328[false]("sv_cheats is 0.");
            else
                local v673 = nil;
                v673 = v359.context.T == 2 and "weapon_incgrenade; use weapon_molotov" or v160.grenades_id_to_cn[v359.context.T or 0] or "";
                utils.console_exec(v16.format("use %s; setpos_exact %s %s %s; setang_exact %s %s 0", v673, unpack(l_s_0)));
                return;
            end;
        end;
    end;
    l_v473_1.nade.setpos:set_callback(v633);
    l_v473_1.nade.tp:set_callback(v634);
    v635 = 0;
    v636 = 0;
    v637 = false;
    local v674 = false;
    do
        local l_v633_1, l_v634_1, l_v635_1, l_v636_1, l_v637_1, l_v674_0 = v633, v634, v635, v636, v637, v674;
        v332.main.binds.tp:set_callback(function(v681)
            -- upvalues: l_v635_1 (ref)
            l_v635_1 = v681:key();
        end, true);
        v332.main.binds.setpos:set_callback(function(v682)
            -- upvalues: l_v636_1 (ref)
            l_v636_1 = v682:key();
        end, true);
        v359.check_binds = function()
            -- upvalues: v359 (ref), l_v635_1 (ref), v332 (ref), l_v637_1 (ref), l_v634_1 (ref), l_v636_1 (ref), l_v674_0 (ref), l_v633_1 (ref)
            if not v359.context then
                return;
            else
                if l_v635_1 ~= 0 then
                    if v332.main.binds.tp:get() then
                        if not l_v637_1 then
                            l_v634_1();
                            l_v637_1 = true;
                        end;
                    elseif l_v637_1 then
                        l_v637_1 = false;
                    end;
                end;
                if l_v636_1 ~= 0 then
                    if v332.main.binds.setpos:get() then
                        if not l_v674_0 then
                            l_v633_1();
                            l_v674_0 = true;
                        end;
                    elseif l_v674_0 then
                        l_v674_0 = false;
                    end;
                end;
                return;
            end;
        end;
    end;
    l_v473_1.nade.options.throw:set_callback(function(v683)
        -- upvalues: v359 (ref), v160 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.t = v683.value ~= "Full" and v160.throw_strength_proxy[v683.value] or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    l_v473_1.nade.options.jump:set_callback(function(v684)
        -- upvalues: v359 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.j = v684.value or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    l_v473_1.nade.options.duck:set_callback(function(v685)
        -- upvalues: v359 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.c = v685.value or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    l_v473_1.nade.options.delay:set_callback(function(v686)
        -- upvalues: v359 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.d = v686.value > 0 and v686.value or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    v633 = function()
        -- upvalues: v359 (ref), l_v473_1 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            local l_pre_0 = l_v473_1.nade.pre;
            v359.context.z = l_pre_0.value and l_pre_0.time.value > 0 and {
                [1] = l_pre_0.dir.value, 
                [2] = l_pre_0.time.value, 
                [3] = l_pre_0.walk.value and true or nil
            } or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end;
    l_v473_1.nade.pre:set_callback(v633);
    l_v473_1.nade.pre.dir:set_callback(v633);
    l_v473_1.nade.pre.walk:set_callback(v633);
    l_v473_1.nade.pre.time:set_callback(v633);
    v634 = function()
        -- upvalues: v359 (ref), l_v473_1 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            local l_post_0 = l_v473_1.nade.post;
            v359.context.x = l_post_0.value and {
                [1] = l_post_0.dir.value, 
                [2] = l_post_0.jump.value and true or nil
            } or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end;
    l_v473_1.nade.post:set_callback(v634);
    l_v473_1.nade.post.dir:set_callback(v634);
    l_v473_1.nade.post.jump:set_callback(v634);
    l_v473_1.finish.name:set_callback(function(v689)
        -- upvalues: v359 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.N = v689.value;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    l_v473_1.finish.desc:set_callback(function(v690)
        -- upvalues: v359 (ref), v122 (ref)
        if v359.context == nil then
            return;
        else
            v359.context.D = #v690.value > 0 and v690.value or nil;
            v122.oh_editor_update:call();
            return;
        end;
    end);
    l_v473_1.finish.save:set_callback(function()
        -- upvalues: v359 (ref), l_v361_3 (ref), v122 (ref), l_v478_1 (ref), v607 (ref), v357 (ref)
        if v359.context == nil then
            return;
        else
            local l_map_3 = v359.context.map;
            if type(l_map_3) ~= "string" then
                return;
            else
                v359.context.map = nil;
                local v692 = l_v361_3.locations[l_map_3];
                if not v692 then
                    l_v361_3.locations[l_map_3] = {};
                    v692 = l_v361_3.locations[l_map_3];
                end;
                local v693 = #v692 + 1;
                if v359.context.orig then
                    v693 = v359.context.orig;
                    v359.context.orig = nil;
                end;
                v692[v693] = v359.context;
                v122.oh_editor_saved:call(v693, v359.context, l_map_3);
                l_v478_1.reset();
                v607.main();
                v357.rewrite_editable();
                v122.oh_configs_update:call();
                return;
            end;
        end;
    end);
    l_v473_1.finish.export:set_callback(function()
        -- upvalues: v359 (ref), v321 (ref), l_v478_1 (ref)
        if v359.context == nil then
            return;
        else
            local l_map_4 = v359.context.map;
            local l_context_1 = v359.context;
            local l_context_2 = v359.context;
            local v697 = nil;
            l_context_2.orig = nil;
            l_context_1.map = v697;
            v321.set(l_v478_1.export(l_map_4, v359.context));
            v359.context.map = l_map_4;
            return;
        end;
    end);
    v122.oh_editor_update:set(function()
        -- upvalues: v359 (ref), l_v473_1 (ref), l_v475_1 (ref)
        local v698 = v359.context.s ~= nil and v359.context.T ~= nil;
        l_v473_1.main.next:disabled(not v698 or l_v475_1.value > 2);
    end);
    v633 = function(v699, v700, v701)
        -- upvalues: v16 (ref), v122 (ref)
        local v702 = v699:name();
        local v703 = v16.format("\adb6b6bff%s", v702);
        local v704 = nil;
        if not v701 then
            v701 = v699;
        end;
        local function v705()
            -- upvalues: v700 (ref), v701 (ref), v699 (ref), v704 (ref), v703 (ref), v702 (ref)
            if v700(v701, v699) then
                if v704 ~= false then
                    v699:name(v703);
                    v704 = false;
                end;
            elseif v704 ~= true then
                v699:name(v702);
                v704 = true;
            end;
        end;
        v122.oh_editor_started:set(v705);
        local l_v701_0 = v701;
        v701.set_callback(l_v701_0, v705);
    end;
    v633(l_v473_1.nade.type, function(v707)
        return v707.value == "Select";
    end);
    v633(l_v473_1.nade[1], function(_)
        -- upvalues: v359 (ref)
        return v359.context.s == nil;
    end, l_v473_1.nade.setpos);
    l_v478_1.reset();
    utils.execute_after(0, l_v478_1.reset);
end;
v361 = nil;
v473 = {};
v474 = {
    state = 0
};
v475 = nil;
l_configs_0 = v357.loaded;
v475 = {
    n = 0
};
do
    local l_l_configs_0_2 = l_configs_0;
    v477 = function()
        -- upvalues: v15 (ref), v475 (ref), v305 (ref), v160 (ref), v359 (ref), l_l_configs_0_2 (ref), v14 (ref), v157 (ref), v330 (ref)
        v15.clear(v475);
        v475.n = 0;
        if v305.valid ~= true then
            return;
        else
            local l_map_5 = v305.map;
            local v711 = v305.weapon and v160.grenades_uid_to_id[v305.weapon_i] or nil;
            if l_map_5 == nil or v711 == nil then
                return;
            else
                local l_context_3 = v359.context;
                if not l_context_3 or l_context_3.map ~= l_map_5 or not l_context_3 then
                    l_context_3 = nil;
                end;
                if not l_context_3 then
                    for v713, v714 in next, l_l_configs_0_2 do
                        local v715 = v714.locations[l_map_5];
                        local v716 = 1;
                        local v717 = v715 and #v715 or 0;
                        for v718 = v716, v717 do
                            local v719 = v715[v718];
                            if l_context_3 and l_context_3.orig == v718 and l_context_3.config == v713 then
                                v719 = nil;
                            end;
                            if v719 and v719.T == v711 then
                                v475.n = v475.n + 1;
                                v475[v475.n] = {
                                    v = false, 
                                    a = 0, 
                                    n = 1, 
                                    d = 0, 
                                    [1] = v719, 
                                    p = vector(unpack(v719.s, 1, 3)), 
                                    as = {
                                        [1] = {
                                            g = {
                                                [1] = 0
                                            }, 
                                            f = {
                                                [1] = 0
                                            }, 
                                            s = {
                                                [1] = 0
                                            }
                                        }
                                    }, 
                                    ag = {
                                        g = {
                                            [1] = 0
                                        }, 
                                        s = {
                                            [1] = 0
                                        }
                                    }
                                };
                            end;
                        end;
                    end;
                    local v720 = false;
                    for v721 = 1, v475.n do
                        local v722 = v475[v721];
                        for v723 = v721 + 1, v475.n do
                            local v724 = v475[v723];
                            if v722 ~= nil and v724 ~= nil and v14.abs(v722.p.z - v724[1].s[3]) < v157.MERGE_HEIGHT_DIFF and v14.distb(v330.avg_pos(v722), v724[1].s, true) <= v157.MERGE_DIST then
                                v722.n = v722.n + 1;
                                local l_n_0 = v722.n;
                                local l_as_0 = v722.as;
                                local l_n_1 = v722.n;
                                local v728 = v724[1];
                                l_as_0[l_n_1] = v724.as[1];
                                v722[l_n_0] = v728;
                                v722.p = vector(unpack(v330.avg_pos(v722)));
                                l_n_0 = v475;
                                l_as_0 = nil;
                                v720 = true;
                                l_n_0[v723] = l_as_0;
                            end;
                        end;
                    end;
                    if v720 then
                        v475 = v15.filter(v475);
                        v475.n = #v475;
                    end;
                end;
                if l_context_3 then
                    v475.n = v475.n + 1;
                    v475[v475.n] = v359.location;
                end;
                return;
            end;
        end;
    end;
    v122.oh_editor_started:set(v477);
    v122.oh_editor_reset:set(v477);
    v122.oh_editor_saved:set(v477);
    v122.oh_configs_update:set(v477);
    v122.local_weapon_change:set(v477);
    v122.local_disconnect:set(v477);
    v122.local_death:set(v477);
end;
l_configs_0 = nil;
v477 = {
    back = color(0, 120), 
    outline = color(0, 40), 
    stroke = color(0, 40), 
    text = color(255, 255)
};
v478 = nil;
local v729 = 0;
local v730 = true;
local v731 = v155.camera_position();
local v732 = false;
do
    local l_v729_0, l_v730_0, l_v731_0, l_v732_0 = v729, v730, v731, v732;
    v122.local_weapon_change:set(function()
        -- upvalues: l_v730_0 (ref)
        l_v730_0 = true;
    end);
    v478 = {
        should = function()
            -- upvalues: l_v731_0 (ref), v155 (ref), v305 (ref), l_v732_0 (ref), l_v730_0 (ref), l_v729_0 (ref)
            local v737 = common.is_in_thirdperson();
            l_v731_0 = v155.camera_position();
            local v738 = 0.35;
            if v305.velocity and v305.velocity > 5 then
                v738 = 0.15;
            end;
            if l_v732_0 ~= v737 then
                local l_v737_0 = v737;
                l_v730_0 = true;
                l_v732_0 = l_v737_0;
            end;
            if v738 < globals.realtime - l_v729_0 then
                l_v730_0 = true;
            end;
        end, 
        check = function(v740)
            -- upvalues: v156 (ref), l_v730_0 (ref), v157 (ref), v155 (ref), l_v731_0 (ref), v305 (ref)
            v740.a = v156.condition(v740.ag.g, v740.v, {
                [1] = 4, 
                [2] = 12
            });
            if not l_v730_0 then
                return;
            else
                local v741 = true and v740.d < v157.MAX_DIST;
                if v741 then
                    v741 = v155.world_to_screen(v740.p) ~= nil;
                    if not v741 and v740.v then
                        v740.ag.g[1] = 0;
                    end;
                end;
                if v741 then
                    local v742 = utils.trace_line(l_v731_0, v740.p + vector(0, 0, 8), v305.self, nil, 1);
                    if not v742 or v742.fraction ~= 1 then
                        v741 = false;
                    else
                        v741 = true;
                    end;
                end;
                v740.v = v741;
                return;
            end;
        end, 
        finish = function()
            -- upvalues: l_v730_0 (ref), l_v729_0 (ref)
            if l_v730_0 then
                local v743 = false;
                l_v729_0 = globals.realtime;
                l_v730_0 = v743;
            end;
        end
    };
end;
v729 = nil;
v730 = {
    corner_h1 = v155.load_image("<svg width=\"4\" height=\"5.87\" viewBox=\"0 0 4 6\"><path fill=\"#fff\" d=\"M0 6V4c0-2 2-4 4-4v2C2 2 0 4 0 6Z\"/></svg>", vector(8, 12)), 
    corner_h2 = v155.load_image("<svg width=\"4\" height=\"5.87\" viewBox=\"0 0 4 6\"><path fill=\"#fff\" d=\"M4 6c0-2-2-4-4-4V0c2 0 4 2 4 4v2Z\"/></svg>", vector(8, 12)), 
    corner_v1 = v155.load_image("<svg width=\"5.87\" height=\"4\" viewBox=\"0 0 6 4\"><path fill=\"#fff\" d=\"M2 4H0c0-2 2-4 4-4h2C4 0 2 2 2 4Z\"/></svg>", vector(12, 8)), 
    corner_v2 = v155.load_image("<svg width=\"5.87\" height=\"4\" viewBox=\"0 0 6 4\"><path fill=\"#fff\" d=\"M2 0H0c0 2 2 4 4 4h2C4 4 2 2 2 0Z\"/></svg>", vector(12, 12)), 
    warning = v155.load_image("<svg width=\"16\" height=\"16\" viewBox=\"0 0 16 16\"><path fill=\"#fff\" d=\"m13.259 13h-10.518c-0.35787 0.0023-0.68906-0.1889-0.866-0.5-0.18093-0.3088-0.18093-0.6912 0-1l5.259-9.015c0.1769-0.31014 0.50696-0.50115 0.864-0.5 0.3568-0.00121 0.68659 0.18986 0.863 0.5l5.26 9.015c0.1809 0.3088 0.1809 0.6912 0 1-0.1764 0.3097-0.5056 0.5006-0.862 0.5zm-6.259-3v2h2v-2zm0-5v4h2v-4z\"/></svg>", vector(32, 32))
};
do
    local l_v730_1 = v730;
    v729 = {
        edge_v = function(v745, v746, v747)
            -- upvalues: l_events_0 (ref), v155 (ref), l_v730_1 (ref)
            if not v747 then
                v747 = l_events_0.accent;
            end;
            v155.rect(vector(v745.x, v745.y + 4), v745 + vector(2, v746 - 4), v747);
            v155.texture(l_v730_1.corner_v1, vector(v745.x, v745.y), vector(6, 4), v747, "f");
            v155.texture(l_v730_1.corner_v2, vector(v745.x, v745.y + v746 - 4), vector(6, 4), v747, "f");
        end
    };
end;
do
    local l_v477_2, l_v478_2, l_v729_1, l_v730_2 = v477, v478, v729, v730;
    l_v730_2 = {
        hysteria = {
            location = function(v752, v753)
                -- upvalues: v155 (ref), v158 (ref), v305 (ref), v473 (ref), v474 (ref), v156 (ref), v14 (ref), v154 (ref), v157 (ref), v15 (ref), l_any_0 (ref), l_events_0 (ref), l_v729_1 (ref)
                local v754 = v155.world_to_screen(v752.p + vector(0, 0, 8));
                if v752.a > 0 and v754 then
                    local v755 = v158.data[v305.weapon_i];
                    v155.push_alpha(v752.a);
                    local v756 = nil;
                    if v473.current or v474.i then
                        v756 = v156.condition(v752.ag.s, (v473.current or v474.i) == v753, 4);
                    else
                        local v757 = v14.dist(v754, v154, true) < v157.COLLAPSE_FOV;
                        v756 = v156.condition(v752.ag.s, v752.d < (v757 and v157.COLLAPSE_IN_FOV_DIST or v157.COLLAPSE_DIST), 4);
                    end;
                    v754 = (v754 / v155.dpi):floor();
                    if v756 > 0 then
                        local v758 = v15.new(#v752, 0);
                        for v759 = 1, #v752 do
                            v758[v759] = v752[v759].N or "Unnamed";
                        end;
                        local v760 = v15.concat(v758, "\226\128\138\n");
                        local v761 = v155.measure_text(l_any_0.regular, v760) * v756;
                        local v762 = vector(6, 4);
                        local v763 = vector(4, 0);
                        local v764 = vector(24, v14.max(24, v761.y + 12));
                        v754 = vector(v754.x - (v761.x * 0.5 + v764.x - v763.x), v754.y - v761.y * 0.5);
                        v155.rect(v754, v754 + v764 + vector(2 * v756, 0), l_events_0.location.icon_back:alpha_modulate(v756 * 0.75 + 0.25, true), {
                            [1] = 4, 
                            [2] = nil, 
                            [3] = nil, 
                            [4] = 4, 
                            [2] = (1 - v756) * 4, 
                            [3] = (1 - v756) * 4
                        });
                        v155.texture(v158[v305.weapon_i], v754 + vector((v764.x - v755[1].x) * 0.5 - v755[2].x, (v764.y - v755[1].y) * 0.5 - v755[2].y), v755[1], l_events_0.text_sb:alpha_modulate(100 + 155 * v756));
                        v155.push_alpha(v756);
                        v754 = v754 + vector(v764.x, 0);
                        l_v729_1.edge_v(v754, v761.y + v762.y * 2 + 4);
                        v754 = v754 + vector(v763.x, 1);
                        local v765 = v754 + vector(v761.x + v762.x * 2, v761.y + v762.y * 2 + 2);
                        v155.rect(v754, v765, l_events_0.location.back, 4);
                        if v756 < 1 then
                            v155.push_clip_rect(v754, v765, true);
                        end;
                        v155.text(l_any_0.regular, v754 + vector(v762.x, v762.y), l_events_0.text, "", v760);
                        if v756 < 1 then
                            v155.pop_clip_rect();
                        end;
                        v155.pop_alpha();
                    else
                        local v766 = v14.map(v752.d, v157.BLEND_DIST, v157.MAX_DIST, 0.25, 0, true);
                        local v767 = vector(4, 0);
                        local v768 = vector(24, 24);
                        v155.push_alpha(v766);
                        v754 = vector(v754.x - (v768.x - v767.x), v754.y);
                        v155.rect(v754, v754 + v768, l_events_0.location.icon_back, 4);
                        v155.texture(v158[v305.weapon_i], v754 + vector((v768.x - v755[1].x) * 0.5 - v755[2].x, (v768.y - v755[1].y) * 0.5 - v755[2].y), v755[1], l_events_0.text_sb);
                        v155.pop_alpha();
                    end;
                    v155.pop_alpha();
                end;
            end, 
            spots = function(v769)
                -- upvalues: v156 (ref), v155 (ref), v15 (ref), v14 (ref), v154 (ref), l_any_0 (ref), l_events_0 (ref), v474 (ref), v473 (ref)
                local v770 = v156.condition(v769.ag.s, true);
                v155.push_alpha(v770);
                local v771 = v15.new(v769.n, 0);
                local v772 = {
                    [1] = v14.huge, 
                    [2] = v769.n == 1 and 1 or nil
                };
                for v773 = 1, v769.n do
                    local v774 = v769[v773];
                    local v775 = vector():angles(v774.s[4], v774.s[5]);
                    local v776 = vector(v774.s[1], v774.s[2], v774.s[3]) + v775 * 720;
                    v776.z = v776.z + 64;
                    local v777, _, v779 = v155.get_offscreen(v776, 32, true);
                    v771[v773] = {
                        [1] = v777 / v155.dpi, 
                        [2] = v779
                    };
                    local v780 = v14.dist(v154, v777);
                    if not v779 and v772[1] > v14.min(v772[1], v780) then
                        local l_v780_0 = v780;
                        v772[2] = v773;
                        v772[1] = l_v780_0;
                    end;
                end;
                for v782 = 1, v769.n do
                    local v783 = v769[v782];
                    local v784 = v769.as[v782];
                    local v785 = v771[v782][1];
                    local v786 = v771[v782][2];
                    local v787 = v772[2] == v782;
                    local v788 = v156.condition(v784.f, v786 == false, 3);
                    local v789 = v156.condition(v784.s, v787, 5);
                    if v785 then
                        local v790 = v789 > 0.5 and l_any_0.bold or l_any_0.regular;
                        local v791 = v155.measure_text(v790, v783.N);
                        local v792 = 16;
                        if v788 > 0 then
                            if v789 > 0 then
                                local v793 = v155.measure_text(l_any_0.regular, v783.D) * v789;
                                v791 = vector(v14.max(v793.x, v791.x), v793.y + v791.y);
                            end;
                            local v794 = v785 + vector(v792, -11);
                            local v795 = v785 + vector(v792 + 12 + v791.x, v791.y - 1);
                            v155.push_alpha(v788);
                            v155.rect(v794, v795, l_events_0.spot.back1:lerp(l_events_0.spot.back2, v789), 4);
                            v155.text(v790, v785 + vector(v792 + 6, -7), l_events_0.white, nil, v783.N);
                            v155.text(l_any_0.regular, v785 + vector(v792 + 6, 6), l_events_0.white:alpha_modulate(v789, true), nil, v783.D);
                            v155.pop_alpha();
                        end;
                        local v796 = v474.position_approached and v474.strength_achieved;
                        local v797 = v474.j == v782 and (v796 and l_events_0.spot.throwing or l_events_0.spot.prepare) or l_events_0.spot.idle;
                        v155.circle(v785, l_events_0.spot.back_circle, 8);
                        v155.circle_outline(v785, v797, 6, 0, 1, 6 * v789);
                    end;
                end;
                v473.selected = v772[2];
                v155.pop_alpha();
            end
        }, 
        Classic = {
            location = function(v798, v799)
                -- upvalues: v155 (ref), v158 (ref), v305 (ref), v473 (ref), v156 (ref), v474 (ref), v14 (ref), v154 (ref), v157 (ref), v15 (ref), l_v477_2 (ref), l_events_0 (ref)
                local v800 = v155.world_to_screen(v798.p + vector(0, 0, 8));
                if v798.a > 0 and v800 then
                    local v801 = v158.data[v305.weapon_i];
                    v155.push_alpha(v798.a);
                    local v802 = nil;
                    if v473.current then
                        v802 = v156.condition(v798.ag.s, v473.current == v799 or v474.location, 4);
                    else
                        local v803 = v14.dist(v800, v154, true) < v157.COLLAPSE_FOV;
                        v802 = v156.condition(v798.ag.s, v798.d < (v803 and v157.COLLAPSE_IN_FOV_DIST or v157.COLLAPSE_DIST), 4);
                    end;
                    v800 = (v800 / v155.dpi):floor();
                    if v802 > 0 then
                        local v804 = v15.new(#v798, 0);
                        for v805 = 1, #v798 do
                            v804[v805] = v798[v805].N or "Unnamed";
                        end;
                        local v806 = v15.concat(v804, "\226\128\138\n");
                        local v807 = v155.measure_text(1, v806);
                        local v808 = vector(6, 4);
                        local v809 = vector(4, 0);
                        local v810 = vector(20, 22);
                        local v811 = v14.max(v807.y * v802, 12);
                        v800 = vector(v800.x - (v807.x * 0.5 * v802 + v810.x - v809.x), v800.y + v809.y - v811);
                        local v812 = v800 + vector(v810.x + (v807.x + v808.x + 8) * v802, v811 + v808.y * 2 + 2);
                        v155.rect(v800, v812, l_v477_2.back:alpha_modulate(0.25 + 1 * v802, true));
                        v155.rect_outline(v800, v812, l_v477_2.outline:alpha_modulate(0.25 + 1 * v802, true));
                        if v802 < 1 then
                            v155.push_clip_rect(v800, v812, true);
                        end;
                        v155.texture(v158[v305.weapon_i], v800 + vector((v810.x - v801[1].x) * 0.5 - v801[2].x, (v811 + v808.y * 2 + 2) * 0.5 - v810.y * 0.5), v801[1], l_events_0.accent:alpha_modulate(0.25 + 1 * v802, true));
                        v155.push_alpha(v802);
                        v155.line(v800 + vector(v810.x, v808.y + 1), v800 + vector(v810.x, v808.y + v807.y + 1), l_events_0.accent);
                        v155.text(1, v800 + vector(v808.x + v810.x, v808.y), l_events_0.accent, "", v806);
                        v155.pop_alpha();
                        if v802 < 1 then
                            v155.pop_clip_rect();
                        end;
                    else
                        local v813 = v14.map(v798.d, v157.BLEND_DIST, v157.MAX_DIST, 0.25, 0, true);
                        local v814 = vector(4, 0);
                        local v815 = vector(20, 22);
                        v155.push_alpha(v813);
                        v800 = vector(v800.x - (v815.x - v814.x), v800.y + v814.y - 12);
                        v155.rect(v800, v800 + v815, l_v477_2.back);
                        v155.rect_outline(v800, v800 + v815, l_v477_2.outline);
                        v155.texture(v158[v305.weapon_i], v800 + vector((v815.x - v801[1].x) * 0.5 - v801[2].x, (v815.y - v801[1].y) * 0.5 - v801[2].y), v801[1], l_events_0.accent);
                        v155.pop_alpha();
                    end;
                    v155.pop_alpha();
                end;
            end, 
            spots = function(v816)
                -- upvalues: v156 (ref), v155 (ref), v15 (ref), v14 (ref), v154 (ref), v16 (ref), l_v477_2 (ref), l_events_0 (ref), v474 (ref), v473 (ref)
                local v817 = v156.condition(v816.ag.s, true);
                v155.push_alpha(v817);
                local v818 = v15.new(v816.n, 0);
                local v819 = {
                    [1] = v14.huge, 
                    [2] = v816.n == 1 and 1 or nil
                };
                for v820 = 1, v816.n do
                    local v821 = v816[v820];
                    local v822 = vector():angles(v821.s[4], v821.s[5]);
                    local v823 = vector(v821.s[1], v821.s[2], v821.s[3]) + v822 * 720;
                    v823.z = v823.z + 64;
                    local v824, _, v826 = v155.get_offscreen(v823, 32, true);
                    v818[v820] = {
                        [1] = v824 / v155.dpi, 
                        [2] = v826
                    };
                    local v827 = v14.dist(v154, v824);
                    if not v826 and v819[1] > v14.min(v819[1], v827) then
                        local l_v827_0 = v827;
                        v819[2] = v820;
                        v819[1] = l_v827_0;
                    end;
                end;
                for v829 = 1, v816.n do
                    local v830 = v816[v829];
                    local v831 = v816.as[v829];
                    local v832 = v818[v829][1];
                    local v833 = v818[v829][2];
                    local v834 = v819[2] == v829;
                    local v835 = v156.condition(v831.f, v833 == false, 3);
                    local v836 = v156.condition(v831.s, v834, 5);
                    if v832 then
                        local v837 = "\194\187" .. (v830.N or "?");
                        local v838 = v830.D and v16.upper(v830.D);
                        local v839 = v836 > 0.5 and 4 or 1;
                        local v840 = v155.measure_text(v839, v837);
                        local v841 = 8;
                        if v835 > 0 then
                            if v836 > 0 and v830.D then
                                local v842 = v155.measure_text(2, v838) * v836;
                                v840 = vector(v14.max(v842.x, v840.x), v842.y + v840.y);
                            end;
                            local v843 = v832 + vector(-v841, -(v840.y - 2));
                            local v844 = v832 + vector(v841 + 12 + v840.x, v840.y - 2);
                            v155.push_alpha(v835);
                            v155.rect(v843, v844, l_v477_2.back:alpha_modulate(0.25 + 1 * v836, true));
                            v155.rect_outline(v843, v844, l_v477_2.outline:alpha_modulate(0.25 + 1 * v836, true));
                            v155.rect_outline(v843 - 1, v844 + 1, l_v477_2.stroke:alpha_modulate(0.25 + 1 * v836, true));
                            v155.line(v832 + vector(v841, -5), v832 + vector(v841, 5), l_events_0.accent);
                            v155.text(v839, v832 + vector(v841 + 6, -7), l_events_0.accent, nil, v837);
                            v155.text(2, v832 + vector(v841 + 6, 6), l_events_0.accent, nil, v838);
                            v155.pop_alpha();
                        end;
                        local v845 = v474.position_approached and v474.strength_achieved;
                        local v846 = v474.j == v829 and (v845 and l_events_0.spot.throwing or l_events_0.spot.prepare) or l_events_0.spot.idle;
                        v155.circle(v832, v846, 4);
                    end;
                end;
                v473.selected = v819[2];
                v155.pop_alpha();
            end
        }, 
        ["Low FPS"] = {
            location = function(v847, v848)
                -- upvalues: v155 (ref), v158 (ref), v305 (ref), v473 (ref), v14 (ref), v154 (ref), v157 (ref), v15 (ref), l_v477_2 (ref), l_events_0 (ref)
                local v849 = v155.world_to_screen(v847.p + vector(0, 0, 8));
                if v847.a > 0 and v849 then
                    local v850 = v158.data[v305.weapon_i];
                    v155.push_alpha(v847.a);
                    local v851 = nil;
                    if v473.current then
                        v851 = v473.current == v848 and 1 or 0;
                    else
                        local v852 = v14.dist(v849, v154, true) < v157.COLLAPSE_FOV;
                        v851 = v847.d < (v852 and v157.COLLAPSE_IN_FOV_DIST or v157.COLLAPSE_DIST) and 1 or 0;
                    end;
                    v849 = (v849 / v155.dpi):floor();
                    if v851 > 0 then
                        local v853 = v15.new(#v847, 0);
                        for v854 = 1, #v847 do
                            v853[v854] = v847[v854].N or "Unnamed";
                        end;
                        local v855 = v15.concat(v853, "\226\128\138\n");
                        local v856 = v155.measure_text(1, v855);
                        local v857 = vector(6, 4);
                        local v858 = vector(4, 0);
                        local v859 = vector(20, 22);
                        local v860 = v14.max(v856.y * v851, 12);
                        v849 = vector(v849.x - (v856.x * 0.5 * v851 + v859.x - v858.x), v849.y + v858.y - v860);
                        local v861 = v849 + vector(v859.x + (v856.x + v857.x + 8) * v851, v860 + v857.y * 2 + 2);
                        v155.rect(v849, v861, l_v477_2.back:alpha_modulate(0.25 + 1 * v851, true));
                        v155.rect_outline(v849, v861, l_v477_2.outline:alpha_modulate(0.25 + 1 * v851, true));
                        if v851 < 1 then
                            v155.push_clip_rect(v849, v861, true);
                        end;
                        v155.texture(v158[v305.weapon_i], v849 + vector((v859.x - v850[1].x) * 0.5 - v850[2].x, (v860 + v857.y * 2 + 2) * 0.5 - v859.y * 0.5), v850[1], l_events_0.accent:alpha_modulate(0.25 + 1 * v851, true));
                        v155.push_alpha(v851);
                        v155.line(v849 + vector(v859.x, v857.y + 1), v849 + vector(v859.x, v857.y + v856.y + 1), l_events_0.accent);
                        v155.text(1, v849 + vector(v857.x + v859.x, v857.y), l_events_0.accent, "", v855);
                        v155.pop_alpha();
                        if v851 < 1 then
                            v155.pop_clip_rect();
                        end;
                    else
                        local v862 = v14.map(v847.d, v157.BLEND_DIST, v157.MAX_DIST, 0.25, 0, true);
                        local v863 = vector(4, 0);
                        local v864 = vector(20, 22);
                        v155.push_alpha(v862);
                        v849 = vector(v849.x - (v864.x - v863.x), v849.y + v863.y - 12);
                        v155.rect(v849, v849 + v864, l_v477_2.back);
                        v155.rect_outline(v849, v849 + v864, l_v477_2.outline);
                        v155.texture(v158[v305.weapon_i], v849 + vector((v864.x - v850[1].x) * 0.5 - v850[2].x, (v864.y - v850[1].y) * 0.5 - v850[2].y), v850[1], l_events_0.accent);
                        v155.pop_alpha();
                    end;
                    v155.pop_alpha();
                end;
            end, 
            spots = function(v865)
                -- upvalues: v156 (ref), v155 (ref), v15 (ref), v14 (ref), v154 (ref), v16 (ref), l_v477_2 (ref), l_events_0 (ref), v474 (ref), v473 (ref)
                local v866 = v156.condition(v865.ag.s, true);
                v155.push_alpha(v866);
                local v867 = v15.new(v865.n, 0);
                local v868 = {
                    [1] = v14.huge, 
                    [2] = v865.n == 1 and 1 or nil
                };
                for v869 = 1, v865.n do
                    local v870 = v865[v869];
                    local v871 = vector():angles(v870.s[4], v870.s[5]);
                    local v872 = vector(v870.s[1], v870.s[2], v870.s[3]) + v871 * 720;
                    v872.z = v872.z + 64;
                    local v873, _, v875 = v155.get_offscreen(v872, 32, true);
                    v867[v869] = {
                        [1] = v873 / v155.dpi, 
                        [2] = v875
                    };
                    local v876 = v14.dist(v154, v873);
                    if not v875 and v868[1] > v14.min(v868[1], v876) then
                        local l_v876_0 = v876;
                        v868[2] = v869;
                        v868[1] = l_v876_0;
                    end;
                end;
                for v878 = 1, v865.n do
                    local v879 = v865[v878];
                    local v880 = v865.as[v878];
                    local v881 = v867[v878][1];
                    local v882 = v867[v878][2];
                    local v883 = v868[2] == v878;
                    local v884 = v156.condition(v880.f, v882 == false, 3);
                    local v885 = v156.condition(v880.s, v883, 5);
                    if v881 then
                        local v886 = "\194\187" .. (v879.N or "?");
                        local v887 = v879.D and v16.upper(v879.D);
                        local v888 = v885 > 0.5 and 4 or 1;
                        local v889 = v155.measure_text(v888, v886);
                        local v890 = 8;
                        if v884 > 0 then
                            if v885 > 0 and v879.D then
                                local v891 = v155.measure_text(2, v887) * v885;
                                v889 = vector(v14.max(v891.x, v889.x), v891.y + v889.y);
                            end;
                            local v892 = v881 + vector(-v890, -(v889.y - 2));
                            local v893 = v881 + vector(v890 + 12 + v889.x, v889.y - 2);
                            v155.push_alpha(v884);
                            v155.rect(v892, v893, l_v477_2.back:alpha_modulate(0.25 + 1 * v885, true));
                            v155.rect_outline(v892, v893, l_v477_2.outline:alpha_modulate(0.25 + 1 * v885, true));
                            v155.rect_outline(v892 - 1, v893 + 1, l_v477_2.stroke:alpha_modulate(0.25 + 1 * v885, true));
                            v155.line(v881 + vector(v890, -5), v881 + vector(v890, 5), l_events_0.accent);
                            v155.text(v888, v881 + vector(v890 + 6, -7), l_events_0.accent, nil, v886);
                            v155.text(2, v881 + vector(v890 + 6, 6), l_events_0.accent, nil, v887);
                            v155.pop_alpha();
                        end;
                        local v894 = v474.position_approached and v474.strength_achieved;
                        local v895 = v474.j == v878 and (v894 and l_events_0.spot.throwing or l_events_0.spot.prepare) or l_events_0.spot.idle;
                        v155.circle(v881, v895, 4);
                    end;
                end;
                v473.selected = v868[2];
                v155.pop_alpha();
            end
        }
    };
    l_configs_0 = {
        editor = {
            work = function(_)
                -- upvalues: v125 (ref), v126 (ref), v155 (ref), l_any_0 (ref), l_v477_2 (ref), v359 (ref), v160 (ref), v16 (ref)
                local v897 = 200;
                local v898 = 320;
                local v899 = vector(v125.x - v897 - 24, v126.y - v898 * 0.5);
                local v900 = vector(v125.x - 24, v126.y + v898 * 0.5);
                v155.blur(v899, v900, 2, 1, 8);
                v155.rect(v899, v900, color(0, 128), 8);
                v155.rect_outline(v899 - 1, v900 + 1, color(0, 255), 1, 9);
                v155.rect_outline(v899, v900, color(255, 40), 1, 8);
                v155.text(l_any_0.bold, v899 + vector(16, 12), l_v477_2.text, "", "EDITOR");
                local l_context_4 = v359.context;
                if l_context_4 then
                    local v902 = {
                        [1] = {
                            [1] = "Name", 
                            [2] = l_context_4.N or "Unnamed"
                        }, 
                        [2] = {
                            [1] = "Description", 
                            [2] = l_context_4.D or "No"
                        }, 
                        [3] = {
                            [1] = "Type", 
                            [2] = v160.grenades_id_to_name[l_context_4.T]
                        }, 
                        [4] = {
                            [1] = "Position", 
                            [2] = l_context_4.s and v16.format("{%d, %d, %d}, {%.1f\194\176, %.1f\194\176}", unpack(l_context_4.s))
                        }, 
                        [5] = {
                            [1] = "Jump", 
                            [2] = l_context_4.j and "Yes" or "No"
                        }, 
                        [6] = {
                            [1] = "Move before throw", 
                            [2] = l_context_4.z and v16.format("%d\194\176, %dt  %s", l_context_4.z[1], l_context_4.z[2], l_context_4.z[3] and "Walk" or "") or "No"
                        }, 
                        [7] = {
                            [1] = "Move after throw", 
                            [2] = l_context_4.x and v16.format("%d\194\176  %s", l_context_4.x[1], l_context_4.x[2] and "Jump" or "") or "No"
                        }
                    };
                    for v903 = 1, #v902 do
                        local v904 = v902[v903];
                        local v905 = v903 * 40;
                        v155.text(l_any_0.regular, v899 + vector(16, v905), l_v477_2.text, nil, v904[1]);
                        v155.text(l_any_0.bold, v899 + vector(16, v905 + 18), l_v477_2.text, nil, tostring(v904[2]));
                    end;
                end;
            end
        }, 
        main = function()
            -- upvalues: v473 (ref), v475 (ref), l_v478_2 (ref), l_v730_2 (ref), v332 (ref), v157 (ref), v359 (ref), l_configs_0 (ref)
            v473.selected = nil;
            if v475.n == 0 then
                return;
            else
                l_v478_2.should();
                local v906 = l_v730_2[v332.main.style.value];
                for v907 = 1, v475.n do
                    local v908 = v475[v907];
                    if v908.d < v157.MAX_DIST then
                        l_v478_2.check(v908);
                        v906.location(v908, v907);
                        if v473.current == v907 then
                            v906.spots(v908);
                        end;
                    end;
                end;
                l_v478_2.finish();
                if v359.context then
                    l_configs_0.editor:work();
                end;
                return;
            end;
        end
    };
end;
v477 = nil;
v478 = v160.playback;
v729 = {
    movement = false, 
    cancel = false, 
    selection = false
};
v730 = {
    was_pressed = false, 
    cvar = cvar.joy_no_accel_jump
};
v730.cvar:int(0);
v731 = nil;
v732 = 0;
local function v911(v909, v910)
    return v909.d > v910.d;
end;
do
    local l_v732_1, l_v911_0 = v732, v911;
    v731 = function()
        -- upvalues: v305 (ref), l_v732_1 (ref), v15 (ref), v475 (ref), l_v911_0 (ref)
        if v305.velocity > 25 and globals.realtime - l_v732_1 > 2 then
            v15.sort(v475, l_v911_0);
            l_v732_1 = globals.realtime;
        end;
    end;
end;
v732 = {
    pause = function(v914, v915)
        -- upvalues: v361 (ref)
        local v916 = v361.in_forward or v361.in_back or v361.in_moveleft or v361.in_moveright or v361.in_jump;
        if v914 or not v916 then
            local l_v361_4 = v361;
            local l_v361_5 = v361;
            local l_v361_6 = v361;
            local l_v361_7 = v361;
            local l_v361_8 = v361;
            local l_v361_9 = v361;
            local l_v361_10 = v361;
            local l_v361_11 = v361;
            local l_v361_12 = v361;
            local l_v361_13 = v361;
            local v927 = false;
            local v928 = false;
            local v929 = false;
            local v930 = false;
            local v931 = false;
            local v932 = false;
            local v933 = false;
            local v934 = false;
            local v935 = 0;
            l_v361_13.sidemove = 0;
            l_v361_12.forwardmove = v935;
            l_v361_11.in_use = v934;
            l_v361_10.in_speed = v933;
            l_v361_9.in_jump = v932;
            l_v361_8.in_moveright = v931;
            l_v361_7.in_moveleft = v930;
            l_v361_6.in_back = v929;
            l_v361_5.in_forward = v928;
            l_v361_4.jitter_move = v927;
            if not v915 then
                v361.in_duck = false;
            end;
        end;
        return v916;
    end, 
    approach = function(v936)
        -- upvalues: v305 (ref), v361 (ref), v14 (ref)
        local v937 = (v936 + (v936 - v305.origin):normalized() * 10 - v305.origin):angles();
        local v938 = v936:dist2d(v305.origin);
        local v939 = v938 < 0.02 + v305.self.m_flDuckAmount * 0.03;
        local v940 = nil;
        if not v939 then
            if v361.in_duck then
                v940 = v938 > 6 and 250 or v14.min(250, v14.max(1.1 + v305.self.m_flDuckAmount * 10, v938 * 9));
            elseif v938 > 6 then
                v940 = 250;
            elseif v938 > 1 and not v361.in_duck then
                v940 = v14.clamp(250 * v14.pow(v938 / 8, 1.25), 1.1, 250);
            elseif v938 > 0.05 and not v361.in_duck then
                v940 = v14.clamp(250 * v14.pow(v938 / 8, 1.1), 1.1, 250);
            else
                v940 = v14.min(250, v14.max(1.1 + v305.self.m_flDuckAmount * 10, v938 * 9));
            end;
            local l_v361_14 = v361;
            local l_v361_15 = v361;
            local l_y_0 = v937.y;
            l_v361_15.in_forward = true;
            l_v361_14.move_yaw = l_y_0;
            v361.forwardmove = v940;
        end;
        return v939;
    end, 
    strength = function(v944)
        -- upvalues: v305 (ref), v361 (ref)
        if not v944 then
            v944 = 0;
        end;
        local v945 = v305.weapon.m_flThrowStrength == 1 - v944 * 0.5;
        if v944 == 0 then
            local l_v361_16 = v361;
            local l_v361_17 = v361;
            local v948 = true;
            l_v361_17.in_attack2 = false;
            l_v361_16.in_attack = v948;
        elseif v944 == 1 then
            local l_v361_18 = v361;
            local l_v361_19 = v361;
            local v951 = true;
            l_v361_19.in_attack2 = true;
            l_v361_18.in_attack = v951;
        elseif v944 == 2 then
            local l_v361_20 = v361;
            local l_v361_21 = v361;
            local v954 = false;
            l_v361_21.in_attack2 = true;
            l_v361_20.in_attack = v954;
        end;
        return v945;
    end, 
    override = function(v955)
        -- upvalues: v331 (ref)
        local v956 = nil;
        if v955 then
            v956 = false;
        end;
        v331.rage.accuracy.autostop:override(v956);
        v331.antiaim.misc.sw:override(v956);
        v331.antiaim.misc.fd:override(v956);
        v331.misc.move.airstrafe:override(v956);
        v331.misc.move.airduck:override(v956);
        v331.misc.move.strafeassist:override(v956);
        v331.misc.move.quickstop:override(v956);
        v331.misc.other.weapon_actions:override(v955 and {} or nil);
        if v956 == nil then
            v331.rage.main.dt:override();
            v331.rage.main.hs:override();
            v331.rage.main.hs.options:override();
            rage.exploit:allow_charge(true);
        end;
    end
};
do
    local l_v478_3, l_v729_2, l_v730_3, l_v731_1, l_v732_2, l_v911_1 = v478, v729, v730, v731, v732, v911;
    l_v911_1 = {
        reset = function(v963)
            -- upvalues: l_v729_2 (ref), v305 (ref), v474 (ref), v15 (ref), l_v732_2 (ref), l_v478_3 (ref), l_v730_3 (ref), v5 (ref)
            if not v963 and not l_v729_2.cancel and v305.weapon_i == v474.weapon_i and v305.weapon.m_bPinPulled then
                utils.console_exec("use weapon_knife");
            end;
            v15.clear(v474);
            l_v732_2.override();
            v474.state = l_v478_3.IDLE;
            l_v730_3.cvar:int(0);
            local l_l_v729_2_0 = l_v729_2;
            local l_l_v729_2_1 = l_v729_2;
            local l_l_v729_2_2 = l_v729_2;
            local v967 = false;
            local v968 = false;
            l_l_v729_2_2.cancel = false;
            l_l_v729_2_1.selection = v968;
            l_l_v729_2_0.movement = v967;
            v5("playback reset");
        end
    };
    v477 = {
        traverse = function()
            -- upvalues: v473 (ref), v305 (ref), v475 (ref), v14 (ref), v157 (ref), l_v731_1 (ref)
            local l_current_0 = v473.current;
            v473.current = nil;
            local v970 = {
                v305.origin:unpack()
            };
            for v971 = 1, v475.n do
                local v972 = v475[v971];
                v972.d = v14.distb(v970, {
                    v972.p:unpack()
                });
                if v473.current == nil and v972.d < v157.SELECTION_DIST then
                    v473.current = v971;
                end;
                if l_current_0 == v971 and v473.current ~= v971 then
                    v972.ag.s[1] = 0;
                end;
            end;
            l_v731_1();
        end, 
        commence = function()
            -- upvalues: v332 (ref), v361 (ref), v474 (ref), l_v478_3 (ref), v473 (ref), l_v729_2 (ref), l_v911_1 (ref), v5 (ref), v475 (ref), v305 (ref), v122 (ref), l_v730_3 (ref), l_v732_2 (ref), v331 (ref), v330 (ref), v14 (ref)
            local v973 = v332.main.hotkey:get();
            local v974 = v332.main.hotkey:key();
            local l_value_4 = v332.main.auto.value;
            local v976 = false;
            if v973 then
                if l_value_4 or v974 ~= 1 and v361.in_attack then
                    v976 = true;
                end;
                local v977 = false;
                if v474.state == l_v478_3.IDLE or not l_value_4 and v474.j ~= v473.selected and v473.selected then
                    v977 = true;
                end;
                if not l_v729_2.selection and (v474.state == l_v478_3.IDLE or v977) and v473.current and v473.selected then
                    l_v911_1.reset(v977);
                    v5("new target");
                    local l_v474_2 = v474;
                    local l_v474_3 = v474;
                    local l_current_1 = v473.current;
                    l_v474_3.j = v473.selected;
                    l_v474_2.i = l_current_1;
                    v474.location = v475[v474.i][v474.j];
                    v474.weapon_i = v305.weapon_i;
                    v474.state = l_v478_3.PREPARING;
                    l_v474_2 = l_v729_2;
                    l_v474_3 = l_v729_2;
                    l_current_1 = l_v729_2;
                    local v981 = true;
                    local v982 = false;
                    l_current_1.cancel = false;
                    l_v474_3.selection = v982;
                    l_v474_2.movement = v981;
                    v122.oh_helper_start:call();
                    l_v730_3.cvar:int(1);
                end;
            else
                if v974 == 1 and l_v730_3.was_pressed then
                    v976 = true;
                    l_v729_2.cancel = true;
                end;
                if not l_v729_2.cancel and v474.location or v305.weapon_i ~= v474.weapon_i and v474.location and v474.state < l_v478_3.RETREATING then
                    l_v911_1.reset();
                end;
            end;
            l_v730_3.was_pressed = v973;
            local l_location_0 = v474.location;
            if l_location_0 then
                l_v732_2.override(true);
                local v984 = rage.exploit:get() == 1 and (v331.rage.main.dt.value or v331.rage.main.hs.value and v331.rage.main.hs.options == "Break LC");
                if v984 and v332.main.wexp.value == "Fast approach" then
                    rage.exploit:allow_charge(false);
                    rage.exploit:force_teleport();
                end;
                local v985 = vector(unpack(l_location_0.s, 1, 3));
                local v986 = l_v732_2.pause(true, l_location_0.c and (v474.state < l_v478_3.MOVING or v474.state == l_v478_3.RETREATING));
                if v474.state < l_v478_3.POST_THROW then
                    v474.strength_achieved = l_v732_2.strength(l_location_0.t);
                end;
                local v987 = v305.self.m_flDuckAmount == (l_location_0.c and 1 or 0);
                if v474.state == l_v478_3.PREPARING then
                    v474.started_approach_at = v474.started_approach_at or v361.command_number;
                    v474.position_approached = l_v732_2.approach(v985);
                    if v976 and v474.position_approached and v474.strength_achieved and v305.weapon.m_bPinPulled then
                        local l_v474_4 = v474;
                        local l_v474_5 = v474;
                        local l_MOVING_0 = l_v478_3.MOVING;
                        l_v474_5.started_at = v361.command_number;
                        l_v474_4.state = l_MOVING_0;
                        l_v474_4 = l_v729_2;
                        l_v474_5 = l_v729_2;
                        l_MOVING_0 = l_v729_2;
                        local v991 = true;
                        local v992 = true;
                        l_MOVING_0.cancel = v976;
                        l_v474_5.selection = v992;
                        l_v474_4.movement = v991;
                    end;
                end;
                if v474.state == l_v478_3.MOVING or v474.state == l_v478_3.PRE_THROW or v474.state == l_v478_3.THROW then
                    local l_z_0 = l_location_0.z;
                    if l_location_0.c then
                        v361.in_duck = true;
                    end;
                    if l_z_0 then
                        if v984 and v332.main.wexp.value == "Fast move" then
                            rage.exploit:allow_charge(false);
                            rage.exploit:force_teleport();
                        end;
                        if v474.state == l_v478_3.MOVING and v361.command_number - v474.started_at >= l_z_0[2] then
                            local l_v474_6 = v474;
                            local l_v474_7 = v474;
                            local l_PRE_THROW_0 = l_v478_3.PRE_THROW;
                            l_v474_7.moved = true;
                            l_v474_6.state = l_PRE_THROW_0;
                        end;
                        v361.move_yaw = l_location_0.s[5] + l_z_0[1];
                        local l_v361_22 = v361;
                        local l_v361_23 = v361;
                        local l_v361_24 = v361;
                        local v1000 = 450;
                        local v1001 = true;
                        l_v361_24.in_speed = l_z_0[3] == true;
                        l_v361_23.in_forward = v1001;
                        l_v361_22.forwardmove = v1000;
                    elseif v474.state == l_v478_3.MOVING then
                        v474.state = l_v478_3.PRE_THROW;
                    end;
                end;
                if v474.state == l_v478_3.PRE_THROW then
                    if l_location_0.j then
                        v361.in_jump = true;
                    end;
                    if v987 then
                        local l_v474_8 = v474;
                        local l_v474_9 = v474;
                        local l_THROW_0 = l_v478_3.THROW;
                        l_v474_9.throw_at = v361.command_number;
                        l_v474_8.state = l_THROW_0;
                    end;
                end;
                if v474.state == l_v478_3.THROW then
                    local v1005 = l_location_0.d or 0;
                    if v984 and (v331.rage.main.dt.value or v331.rage.main.hs.value and v331.rage.main.hs.options == "Break LC") then
                        v1005 = v1005 + 6;
                    end;
                    if v1005 <= v361.command_number - v474.throw_at then
                        local l_v361_25 = v361;
                        local l_v361_26 = v361;
                        local v1008 = false;
                        l_v361_26.in_attack2 = false;
                        l_v361_25.in_attack = v1008;
                    end;
                    if v330.being_thrown(v305.weapon) then
                        local l_view_angles_0 = v361.view_angles;
                        local l_view_angles_1 = v361.view_angles;
                        local l_view_angles_2 = v361.view_angles;
                        local v1012 = l_location_0.s[4];
                        local v1013 = l_location_0.s[5];
                        l_view_angles_2.z = 0;
                        l_view_angles_1.y = v1013;
                        l_view_angles_0.x = v1012;
                        v474.thrown_at = v361.command_number;
                    elseif v305.weapon.m_fThrowTime == 0 and v474.thrown_at and v474.thrown_at > v474.throw_at then
                        v474.state = l_v478_3.RETREATING;
                        local l_l_v729_2_3 = l_v729_2;
                        local l_l_v729_2_4 = l_v729_2;
                        local l_l_v729_2_5 = l_v729_2;
                        local v1017 = false;
                        local v1018 = false;
                        l_l_v729_2_5.cancel = false;
                        l_l_v729_2_4.selection = v1018;
                        l_l_v729_2_3.movement = v1017;
                        v331.misc.move.airstrafe:override(true);
                    end;
                elseif v474.state == l_v478_3.RETREATING then
                    local v1019 = l_location_0.x or {};
                    local v1020 = l_location_0.z or {};
                    if v986 or l_location_0.z == nil then
                        l_v911_1.reset();
                        v122.oh_helper_end:call();
                    else
                        local v1021 = v1019[1] and v1019[1] + (v1020[1] or 0) or (v1020[1] or 0) - 180;
                        v331.misc.move.airstrafe:override(true);
                        if v474.retreating_at then
                            if v984 and v332.main.wexp.value == "Fast retreat" then
                                rage.exploit:allow_charge(false);
                                rage.exploit:force_teleport();
                            end;
                        else
                            v474.retreating_at = v361.command_number;
                        end;
                        local v1022 = v14.min(32, v1020[2] or 16) + 13 + (v1019[3] and 10 or 0);
                        v361.move_yaw = l_location_0.s[5] + v1021;
                        local l_v361_27 = v361;
                        local l_v361_28 = v361;
                        local v1025 = 450;
                        l_v361_28.in_forward = true;
                        l_v361_27.forwardmove = v1025;
                        v361.in_jump = v1019[3] or false;
                        if v361.command_number >= v474.retreating_at + v1022 then
                            l_v911_1.reset();
                            v122.oh_helper_end:call();
                        end;
                    end;
                end;
            end;
        end
    };
end;
v122.createmove:set(function(v1026)
    -- upvalues: v361 (ref), v477 (ref)
    v361 = v1026;
    v477.traverse();
    v477.commence();
end);
v122.createmove_run:set(function()
    -- upvalues: v359 (ref)
    v359.check_binds();
end);
v122.render:set(function()
    -- upvalues: l_configs_0 (ref)
    l_configs_0.main();
end);