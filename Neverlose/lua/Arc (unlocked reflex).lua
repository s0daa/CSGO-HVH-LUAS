-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = false;
_DISABLE_UI_EVENTS = false;
_DEBUG = _DEBUG and common.get_username() == common.get_script_author();
_DISABLE_UI_EVENTS = _DEBUG and _DISABLE_UI_EVENTS;
local v0 = "Arc";
local v1 = string.lower(v0);
local v2 = "artstation";
local v3 = {
    1.1, 
    "Release", 
    ui.get_icon("brackets-curly")
};
local v4 = "b1 c8 9a 05 4f 0e 3c 64";
local v5 = {
    [1] = {
        [1] = "4FF9FFFF", 
        [2] = "Arc Night", 
        [3] = "https://neverlose.cc/getitem?c=6qtHOL8UpKS6djWt-emKc1HDv2y"
    }, 
    [2] = {
        [1] = "FFB84FFF", 
        [2] = "Arc Desert", 
        [3] = "https://neverlose.cc/getitem?c=w2B2aiTXE9Kym9gX-gLGk0aGwyQ"
    }, 
    [3] = {
        [1] = "FF5065FF", 
        [2] = "Arc Autumn", 
        [3] = "https://neverlose.cc/getitem?c=MTGwBnqLX9oU013w-3Kzg83BeZB"
    }
};
local v6 = {
    [1] = {
        [1] = "\240\159\148\174 Solus", 
        [2] = "https://market.neverlose.cc/solus"
    }, 
    [2] = {
        [1] = "\240\159\144\189 Chimera", 
        [2] = "https://market.neverlose.cc/chimera"
    }
};
local v7 = {
    [1] = {
        [1] = " \240\159\141\130 Fall", 
        [2] = "https://en.neverlose.cc/market/item?id=gMgsPp"
    }, 
    [2] = {
        [1] = " \226\155\136 Rain", 
        [2] = "https://market.neverlose.cc/twilight_rain"
    }, 
    [3] = {
        [1] = " \240\159\140\137 Night", 
        [2] = "https://market.neverlose.cc/twilight_night"
    }
};
local _ = print;
local l_print_error_0 = print_error;
local l_error_0 = error;
local _ = assert;
local v12 = nil;
local v13 = nil;
local v14 = nil;
local v15 = nil;
local v16 = nil;
local v17 = nil;
local v18 = nil;
v12 = function(...)
    -- upvalues: v4 (ref)
    local v19 = table.concat({
        ...
    });
    local v20 = #v19;
    local v21 = #v4;
    local v22 = ffi.new("char[?]", v20 + 1);
    local v23 = ffi.new("char[?]", v21 + 1);
    ffi.copy(v22, v19);
    ffi.copy(v23, v4);
    for v24 = 0, v20 - 1 do
        v22[v24] = bit.bxor(v22[v24], v23[v24 % v21]);
    end;
    return ffi.string(v22, v20);
end;
v13 = function(...)
    -- upvalues: v1 (ref)
    local v25 = {
        ...
    };
    local v26 = #v25;
    if v26 == 0 then
        return;
    else
        local v27 = "";
        local v28 = false;
        for v29, v30 in ipairs(v25) do
            if v26 > 1 and v29 == v26 then
                if type(v30) == "boolean" then
                    v28 = v30;
                else
                    v27 = v27 .. tostring(v30);
                end;
            else
                v27 = v27 .. tostring(v30);
            end;
        end;
        local v32 = string.gsub(v27, "\a(%x%x%x%x%x%x%x%x)", function(v31)
            return "\a" .. (v31 == "FFFFFFFF" and "C5CAD0FF" or v31);
        end);
        if v28 ~= true then
            print_dev(string.format("\aC5CAD0FF%s\aC5CAD0FF", v27));
        end;
        print_raw(string.format("\a9EB3DEFF%s \a888888FF\194\183 \aC5CAD0FF%s\aC5CAD0FF", v1, v32));
        return;
    end;
end;
v17 = function(...)
    -- upvalues: v13 (ref)
    if _DEBUG ~= true then
        return;
    else
        local v33 = {
            ...
        };
        if #v33 == 1 and v33[1] == "" then
            print_raw(" ");
            return;
        else
            v13(...);
            return;
        end;
    end;
end;
v14 = function(...)
    -- upvalues: v13 (ref), l_print_error_0 (ref)
    if _DEBUG ~= true then
        return;
    else
        local v34 = {
            ...
        };
        if #v34 == 1 and v34[1] == "" then
            print_raw(" ");
            return;
        else
            v13("\aFF3E3EFF", table.concat({
                ...
            }), false);
            l_print_error_0("");
            return;
        end;
    end;
end;
v15 = function(...)
    -- upvalues: v13 (ref), l_print_error_0 (ref)
    v13("\aFF3E3EFF", table.concat({
        ...
    }), false);
    l_print_error_0("");
end;
v16 = function(...)
    -- upvalues: v13 (ref), l_error_0 (ref)
    v13("\aFF3E3EFF", table.concat({
        ...
    }), false);
    l_error_0("");
end;
v18 = function(v35, ...)
    -- upvalues: v13 (ref), l_error_0 (ref)
    if not v35 then
        v13("\aFF3E3EFF", table.concat({
            ...
        }), "\aDEFAULT", false);
        l_error_0("");
    end;
end;
v17("");
v17("\aCC9F6CFFinitialization in progress...");
v17("loading libary: \aCC9F6CFFbase64");
local l_base64_0 = require("neverlose/base64");
v17("loading libary: \aCC9F6CFFclipboard");
local l_clipboard_0 = require("neverlose/clipboard");
local v38 = nil;
v17("loading libary: \aCC9F6CFFlagrecord");
v38 = require("neverlose/lagrecord");
v38 = v38 ^ v38.SIGNED;
local v39 = nil;
v17("loading libary: \aCC9F6CFFvoice_listener");
v39 = require("neverlose/voice_listener");
v39 = v39 ^ v39.VOSIGNED;
local v40 = nil;
v17("loading libary: \aCC9F6CFFw7animations/sod");
v40 = require("neverlose/w7animations").SOD;
local v41 = v1 .. "_statistics";
local v42 = v1 .. "_presets";
local v43 = " ";
local v44 = "\226\128\138";
local function v48(v45)
    local v46 = 0;
    local v47 = 0;
    while v45 >= 6 do
        v46 = v46 + 1;
        v45 = v45 - 3;
    end;
    while v45 >= 4 do
        v47 = v47 + 1;
        v45 = v45 - 2;
    end;
    if v45 == 3 then
        v46 = v46 + 1;
    end;
    if v45 == 2 then
        v47 = v47 + 1;
    end;
    return v46, v47;
end;
local function v52(v49, v50, v51)
    return v49 + (v50 - v49) * v51;
end;
local function v56(v53, v54, v55)
    return math.max(v54, math.min(v55, v53));
end;
local function v63(v57, v58, v59, v60, v61, v62)
    -- upvalues: v56 (ref)
    if v62 == true then
        v57 = v56(v57, v58, v59);
    end;
    return v60 + (v57 - v58) * (v61 - v60) / (v59 - v58);
end;
local function v82(v64, v65, v66, v67, v68, v69)
    -- upvalues: v48 (ref), v43 (ref), v44 (ref)
    local v70 = v66 or 0;
    local v71 = v67 or 0;
    if not v68 then
        v68 = 0;
    end;
    v67 = v71;
    v66 = v70;
    v70 = 0;
    v71 = 0;
    local v72 = 0;
    local v73 = 0;
    local v74 = 0;
    local v75 = 0;
    if v66 >= 2 then
        local v76, v77 = v48(v66);
        v71 = v77;
        v70 = v76;
    end;
    if v67 >= 2 then
        local v78, v79 = v48(v67);
        v73 = v79;
        v72 = v78;
    end;
    if v68 >= 2 then
        local v80, v81 = v48(v68);
        v75 = v81;
        v74 = v80;
    end;
    return (v70 > 0 and string.rep(v43, v70) or "") .. (v71 > 0 and string.rep(v44, v71) or "") .. (v64 and string.format("%s%s\aDEFAULT", v69 and v69 or "\a{Link Active}", ui.get_icon(v64)) or "") .. (v72 > 0 and string.rep(v43, v72) or "") .. (v73 > 0 and string.rep(v44, v73) or "") .. (v65 or "") .. (v74 > 0 and string.rep(v43, v74) or "") .. (v75 > 0 and string.rep(v44, v75) or "");
end;
local function v86()
    local v83 = common.get_username();
    local v84 = common.get_config_author();
    local v85 = common.get_script_author();
    return v83 == v84 or v83 == v85;
end;
local v87 = {};
local v88 = false;
local function v90(v89)
    return "\a96B0BAFF" .. v89 .. "\aDEFAULT";
end;
local function v102(v91, v92, v93, v94, ...)
    -- upvalues: v18 (ref), v17 (ref), v88 (ref), v87 (ref)
    local l_v93_0 = v93;
    if l_v93_0 == nil then
        l_v93_0 = true;
    end;
    v18(type(v91) == "userdata", "invalid userdata");
    v18(type(v92) == "function", "invalid callback type");
    v18(type(l_v93_0) == "boolean", "invalid state type");
    local v96 = {};
    if l_v93_0 == true then
        if type(v91.set_callback) == "function" then
            v96 = {
                v91:set_callback(v92, ...)
            };
        elseif type(v91.set) == "function" then
            v96 = {
                v91:set(v92, ...)
            };
        end;
    elseif type(v91.unset_callback) == "function" then
        v96 = {
            v91:unset_callback(v92, ...)
        };
    elseif type(v91.unset) == "function" then
        v96 = {
            v91:unset(v92, ...)
        };
    end;
    v17(string.format("%s callback: \a99FF99FF%s %s", l_v93_0 == true and "enabled" or "disabled", v91, v94 == true and "\aFF3E3EFF[override]" or ""));
    if v88 ~= true then
        local v97 = tostring(v91);
        if v97:sub(1, 6) == "event(" then
            local v98 = nil;
            local v99 = string.match(v97, "event%((.*)%)");
            for v100, v101 in pairs(v87) do
                if v101.callback == v92 then
                    v98 = v100;
                    break;
                end;
            end;
            if l_v93_0 == true and v94 == true then
                if v98 ~= nil then
                    v87[v98] = nil;
                end;
                table.insert(v87, {
                    event = v91, 
                    event_name = v99, 
                    callback = v92, 
                    current_index = #v91
                });
            end;
            if v98 ~= nil and l_v93_0 == false then
                v87[v98] = nil;
            end;
        end;
    end;
    return unpack(v96);
end;
local function v103()
    -- upvalues: v87 (ref), v88 (ref), v102 (ref), v17 (ref), v90 (ref), v103 (ref)
    local v104 = {};
    for _, v106 in pairs(v87) do
        local v107 = #v106.event;
        if v107 ~= v106.current_index then
            v88 = true;
            v102(v106.event, v106.callback, false, true);
            v102(v106.event, v106.callback, true, true);
            v88 = false;
            if v106.current_index < v107 then
                v104[v106.event_name] = v104[v106.event_name] or {};
                table.insert(v104[v106.event_name], {
                    [1] = v107, 
                    [2] = v106.current_index
                });
            end;
            v106.current_index = v107;
        end;
    end;
    for v108, v109 in pairs(v104) do
        v17(string.format("\aFF3E3EFFtook priority over \a99FF99FF%s \aFF3E3EFFcallback \a888888FF/\aDEFAULT overrides: %s \a888888FF\194\183\aDEFAULT idx: %s \a888888FF\194\183\aDEFAULT high: %s", v108, v90(#v109), v90(v109[1][1]), v90(v109[1][2])));
    end;
    utils.execute_after(0.1, v103);
end;
v103();
local v110 = {};
(function()
    -- upvalues: v110 (ref), v102 (ref), v63 (ref), v56 (ref), v18 (ref), v39 (ref), v1 (ref), v90 (ref), v13 (ref), v38 (ref), v52 (ref), v2 (ref), v0 (ref), v82 (ref), v17 (ref), v15 (ref), v16 (ref)
    local function v113(v111)
        if not v111 then
            v111 = 1;
        end;
        local v112 = nil;
        v112 = 1 / globals.tickinterval * v111;
        if globals.server_tick % v112 > 0 then
            return true;
        else
            return false;
        end;
    end;
    local function v116()
        local v114 = "";
        for _ = 1, utils.random_int(35, 128) do
            v114 = v114 .. string.char(utils.random_int(1, 255));
        end;
        return events[v114];
    end;
    v110.reflex = function()
        -- upvalues: v102 (ref)
        ffi.cdef("            void* GetProcAddress(void*, const char*);\n            void* GetModuleHandleA(const char*);\n\n            void* GetCurrentProcess();\n            void* GetCurrentThread();\n\n            bool SetThreadPriority(void*, int);\n        ");
        local v117 = true;
        local v118 = 0;
        local v119 = ffi.C.GetCurrentProcess();
        local v120 = ffi.C.GetCurrentThread();
        local v121 = nil;
        local v122 = ffi.C.GetModuleHandleA("ntdll.dll");
        local v123 = ffi.cast("long(__stdcall*)(void*, unsigned long, void*, unsigned long)", ffi.C.GetProcAddress(v122, "NtSetInformationProcess"));
        local v124 = ffi.typeof("unsigned long[1]");
        local v125 = v124(5);
        local v126 = v124(2);
        do
            local l_v123_0, l_v124_0, l_v125_0, l_v126_0 = v123, v124, v125, v126;
            v121 = function()
                -- upvalues: l_v123_0 (ref), v119 (ref), l_v125_0 (ref), l_v124_0 (ref), l_v126_0 (ref)
                l_v123_0(v119, 39, l_v125_0, ffi.sizeof(l_v124_0));
                l_v123_0(v119, 33, l_v126_0, ffi.sizeof(l_v124_0));
            end;
        end;
        v122 = function()
            -- upvalues: v118 (ref), v120 (ref)
            local l_realtime_0 = globals.realtime;
            if math.abs(l_realtime_0 - v118) <= 0.5 then
                return;
            else
                v118 = l_realtime_0;
                ffi.C.SetThreadPriority(v120, 2);
                return;
            end;
        end;
        v123 = function()
            -- upvalues: v120 (ref)
            ffi.C.SetThreadPriority(v120, 0);
        end;
        return function(v132)
            -- upvalues: v102 (ref), v122 (ref), v123 (ref), v117 (ref)
            if type(v132) == "boolean" then
                v102(events.render, v122, v132);
                v102(events.shutdown, v123, v132);
                v117 = v132;
                return;
            else
                return v117;
            end;
        end;
    end;
    v110.interpolation_fixes = function()
        -- upvalues: v116 (ref), v113 (ref), v63 (ref), v102 (ref)
        local v133 = v116();
        local v134 = false;
        local v135 = false;
        local v136 = false;
        local v137 = 0;
        local v138 = nil;
        local l_cl_predictweapons_0 = cvar.cl_predictweapons;
        local function v147()
            -- upvalues: v134 (ref), v137 (ref)
            local l_memory_0 = require("neverlose/memory");
            local v141 = utils.opcode_scan("client.dll", "57 8B F9 8B 07 8B 80 ? ? ? ? FF D0 84 C0 75 35");
            local v142 = ffi.cast("void(__fastcall*)(void*, void*)", v141);
            return l_memory_0.hook_func(v142, function(v143, v144, v145)
                -- upvalues: v134 (ref), v137 (ref)
                local v146 = entity.get_local_player();
                if v134 and v144 ~= nil and v145 ~= nil and v146 ~= nil and entity.get(v144) == v146 then
                    v137 = globals.realtime;
                    return;
                else
                    return v143:get_original(v144, v145);
                end;
            end):detach();
        end;
        local function v148()
            -- upvalues: v113 (ref), l_cl_predictweapons_0 (ref)
            if v113(0.25) == true then
                return;
            else
                l_cl_predictweapons_0:int(0, true);
                return;
            end;
        end;
        local function v154()
            -- upvalues: v137 (ref), v63 (ref)
            local v149 = math.abs(v137 - globals.realtime);
            local v150 = v63(v149, 0, 0.35, 1, 0, true);
            local v151 = v149 < 3.5 and 1 or v63(v149, 3.5, 3.75, 1, 0, true);
            local v152 = color():lerp(color(255, 50, 80), v150):alpha_modulate(v151, true);
            local v153 = nil;
            v153 = render.screen_size();
            v153.x = v153.x * 0.5;
            v153.y = v153.y * 0.9785;
            render.text(2, v153, v152, "cs", string.upper("PREDICTION  ERROR"));
        end;
        local function v155()
            -- upvalues: v137 (ref), l_cl_predictweapons_0 (ref)
            v137 = 0;
            l_cl_predictweapons_0:int(tonumber(l_cl_predictweapons_0:string()), true);
        end;
        local function v162(v156)
            -- upvalues: v135 (ref), v136 (ref), v138 (ref), v147 (ref), v133 (ref), v134 (ref), v137 (ref), v102 (ref), v154 (ref), v148 (ref), v155 (ref)
            if type(v156) == "boolean" then
                if v135 then

                end;
                if v156 and not v136 then
                    local _ = nil;
                    local l_status_0, l_result_0 = pcall(v147);
                    v138 = l_result_0;
                    if l_status_0 == false then
                        v133:call({
                            enabled = v134 and not v135, 
                            disabled = v135
                        });
                    end;
                end;
                if v138 ~= nil and pcall(v138[v156 == true and "attach" or "detach"], v138) == false then
                    local v160 = false;
                    local v161 = true;
                    v137 = 0;
                    v135 = v161;
                    v156 = v160;
                    v133:call({
                        enabled = v156 and not v135, 
                        disabled = v135
                    });
                end;
                v102(events.render, v154, v156);
                v102(events.net_update_end, v148, v156);
                v102(events.shutdown, v155, v156);
                if v156 == false and v134 ~= v156 then
                    v155();
                end;
                v134 = v156;
                return;
            else
                return v134;
            end;
        end;
        return {
            callback = v133, 
            enabled = v162
        };
    end;
    v110.no_fall_damage = function()
        -- upvalues: v102 (ref)
        local v163 = false;
        local l_sv_gravity_0 = cvar.sv_gravity;
        local v165 = utils.get_vfunc(76, "float*(__thiscall*)(void*)");
        local v166 = utils.get_vfunc(77, "float*(__thiscall*)(void*)");
        local function v173(v167, v168, v169)
            -- upvalues: v165 (ref), v166 (ref)
            local v170 = nil;
            local v171 = nil;
            v170 = v165(v167[0]);
            v171 = v166(v167[0]);
            v170 = vector(v170[0], v170[1], v170[2]);
            v171 = vector(v171[0], v171[1], 54);
            local v172 = utils.trace_hull(v168, v168 - vector(0, 0, v169), v170, v171, v167, 1);
            return v172.fraction < 1 and not v172.start_solid and not v172.all_solid and v172.plane.normal.z >= 0.69999999, v172;
        end;
        local function v181(v174, v175)
            -- upvalues: l_sv_gravity_0 (ref)
            local l_tickinterval_0 = globals.tickinterval;
            local v177 = l_sv_gravity_0:float() * l_tickinterval_0 * 0.5;
            local l_v174_0 = v174;
            local v179 = 0;
            local v180 = 0;
            while l_v174_0 > 11 do
                v179 = v175 - v177;
                v180 = l_tickinterval_0 * v179;
                v175 = v179 - v177;
                l_v174_0 = l_v174_0 + v180;
            end;
            return v175 <= -580 and l_v174_0 >= 9;
        end;
        local function v192(v182)
            -- upvalues: v173 (ref), v181 (ref)
            local v183 = entity.get_local_player();
            local v184 = bit.band(v183.m_fFlags, 1) == 1;
            if v183.m_MoveType == 2 and not v184 then
                local v185 = v183:get_origin();
                if bit.band(v183.m_fFlags, 2) == 0 then
                    v185.z = v185.z + 9;
                end;
                local v186, v187 = v173(v183, v185, 1000);
                if v186 then
                    local v188 = v187.fraction * 1000;
                    local l_z_0 = v183.m_vecVelocity.z;
                    if l_z_0 >= 0 or v188 >= 11 then
                        if not v181(v188, l_z_0) then
                            return;
                        else
                            local v190 = 0;
                            v182.in_duck = 1;
                            v182.in_jump = v190;
                            return;
                        end;
                    elseif l_z_0 < -580 and v188 > 9 then
                        local v191 = 0;
                        v182.in_jump = 1;
                        v182.in_duck = v191;
                        return;
                    end;
                end;
            end;
        end;
        return function(v193)
            -- upvalues: v102 (ref), v192 (ref), v163 (ref)
            if type(v193) == "boolean" then
                v102(events.createmove, v192, v193, true);
                v163 = v193;
                return;
            else
                return v163;
            end;
        end;
    end;
    v110.avoid_collisions = function()
        -- upvalues: v102 (ref)
        local v194 = false;
        local v195 = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe");
        local v196 = ui.find("Miscellaneous", "Main", "Movement", "Edge Jump");
        local function v214(v197)
            -- upvalues: v196 (ref), v195 (ref)
            if v196:get_override() or v196:get() then
                return;
            else
                local v198 = entity.get_local_player();
                if v198.m_MoveType ~= 2 then
                    return;
                elseif bit.band(v198.m_fFlags, 1) == 1 then
                    return;
                elseif v197.in_duck or v197.in_speed then
                    return;
                else
                    local l_m_vecVelocity_0 = v198.m_vecVelocity;
                    local l_m_vecMins_0 = v198.m_vecMins;
                    local l_m_vecMaxs_0 = v198.m_vecMaxs;
                    local v202 = vector():angles(0, v197.view_angles.y);
                    local v203 = v202:vectors();
                    local v204 = 0;
                    local v205 = 0;
                    if v197.sidemove == 0 then
                        v204 = 450;
                    end;
                    if v195:get() then
                        local v206 = v197.forwardmove == 0 and v197.sidemove == 0 and 450 or v197.forwardmove;
                        v205 = v197.sidemove;
                        v204 = v206;
                    end;
                    local v207 = vector(v202.x * v204 + v203.x * v205, v202.y * v204 + v203.y * v205);
                    v207:normalize();
                    local v208 = v198:get_origin();
                    local v209 = v208.z + 20;
                    local v210 = 36;
                    l_m_vecVelocity_0.z = 0;
                    l_m_vecMaxs_0.z = v210;
                    v208.z = v209;
                    v209 = l_m_vecVelocity_0:normalized();
                    if v209:dot(v207) <= 0 then
                        return;
                    else
                        v210 = v208 + v207 * 46;
                        local v211 = utils.trace_hull(v208, v210, l_m_vecMins_0, l_m_vecMaxs_0, v198, 33636363);
                        local l_normal_0 = v211.plane.normal;
                        if v211:did_hit_world() and math.abs(l_normal_0.z) < 0.1 and bit.band(v211.contents, 536870912) ~= 536870912 and not v211.entity:is_breakable() then
                            if v209:dot(v211.plane.normal) < -0.85 then
                                v209 = v207;
                            end;
                            local v213 = l_normal_0:vectors();
                            if v213:dot(v209) < 0 then
                                v213 = v213 * -1;
                            end;
                            v197.move_yaw = math.deg(math.atan2(v213.y, v213.x));
                            v197.forwardmove = 450;
                            v197.sidemove = 0;
                        end;
                        return;
                    end;
                end;
            end;
        end;
        return function(v215)
            -- upvalues: v102 (ref), v214 (ref), v194 (ref)
            if type(v215) == "boolean" then
                v102(events.createmove, v214, v215, true);
                v194 = v215;
                return;
            else
                return v194;
            end;
        end;
    end;
    v110.collision_air_duck = function()
        -- upvalues: v102 (ref)
        local v216 = false;
        local v217 = 0;
        local v218 = 8;
        local v219 = 7;
        local function v238(v220)
            -- upvalues: v217 (ref), v219 (ref), v218 (ref)
            local v221 = entity.get_local_player();
            local v222 = v221:get_anim_state();
            if v221.m_MoveType ~= 2 then
                v217 = 0;
                return;
            elseif bit.band(v221.m_fFlags, 1) == 1 and not v222.landed_on_ground_this_frame then
                v217 = 0;
                return;
            else
                local v223 = v221:get_origin();
                local l_y_0 = v220.view_angles.y;
                local l_forwardmove_0 = v220.forwardmove;
                local l_sidemove_0 = v220.sidemove;
                local l_in_duck_0 = v220.in_duck;
                local v228 = 0;
                local v229 = v221:simulate_movement();
                v220.in_duck = 1;
                while v229.duck_amount < 1 do
                    v229:think();
                    v228 = v228 + 1;
                end;
                local v230 = v221.m_vecMaxs:clone();
                v221.m_vecMaxs = vector(v230.x, v230.y, math.min(54, v230.z));
                local v231 = v221:simulate_movement(v229.origin, v229.velocity, v229.flags);
                for _ = 1, v219 do
                    v231:think();
                    v228 = v228 + 1;
                end;
                v221.m_vecMaxs = v230;
                v220.in_duck = l_in_duck_0;
                local v233 = v221:simulate_movement();
                for _ = 1, v228 do
                    v233:think();
                end;
                local v235 = v223:dist2d(v231.origin);
                local v236 = v223:dist2d(v233.origin);
                local v237 = v231.origin:dist2d(v233.origin);
                if v236 < v235 and v218 < v237 then
                    v217 = v219;
                end;
                v220.in_duck = l_in_duck_0;
                v220.view_angles.y = l_y_0;
                v220.forwardmove = l_forwardmove_0;
                v220.sidemove = l_sidemove_0;
                if v217 > 0 then
                    v217 = v217 - 1;
                    v220.in_duck = true;
                end;
                return;
            end;
        end;
        return function(v239)
            -- upvalues: v102 (ref), v238 (ref), v216 (ref)
            if type(v239) == "boolean" then
                v102(events.createmove, v238, v239, true);
                v216 = v239;
                return;
            else
                return v216;
            end;
        end;
    end;
    v110.edge_quick_stop = function()
        -- upvalues: v102 (ref)
        local v240 = false;
        local v241 = 0;
        local v242 = vector();
        local v243 = ui.find("Miscellaneous", "Main", "Movement", "Edge Jump");
        local function v245(v244)
            return bit.band(v244, 1) == 1;
        end;
        local function v258(v246, v247, v248)
            -- upvalues: v243 (ref), v245 (ref)
            if v243:get_override() or v243:get() then
                return false;
            elseif not v245(v247.m_fFlags) or v248.landed_on_ground_this_frame then
                return false;
            else
                local v249 = false;
                local l_y_1 = v246.view_angles.y;
                local l_forwardmove_1 = v246.forwardmove;
                local l_sidemove_1 = v246.sidemove;
                local v253 = v247:simulate_movement();
                v253:think();
                if v246.in_jump and not v245(v253.flags) then
                    return false;
                else
                    for _ = 0, 3 do
                        v253:think();
                    end;
                    local v255 = v253.velocity:clone();
                    if v255:normalize() == 0 then
                        return false;
                    else
                        v246.view_angles.y = v255:angles().y;
                        v246.forwardmove = -450;
                        v246.sidemove = 0;
                        local l_velocity_0 = v253.velocity;
                        local v257 = l_velocity_0:length2dsqr();
                        while l_velocity_0:length2dsqr() < v257 do
                            v257 = l_velocity_0:length2dsqr();
                            v253:think();
                        end;
                        v255 = v247:simulate_movement(v253.origin, v253.velocity, v253.flags);
                        v255:think();
                        if not v245(v255.flags) then
                            v249 = true;
                        end;
                        v246.view_angles.y = l_y_1;
                        v246.forwardmove = l_forwardmove_1;
                        v246.sidemove = l_sidemove_1;
                        return v249;
                    end;
                end;
            end;
        end;
        local function v262(v259)
            -- upvalues: v258 (ref), v241 (ref), v242 (ref)
            local v260 = entity.get_local_player();
            local v261 = v260:get_anim_state();
            if v260.m_MoveType ~= 2 then
                return;
            else
                if v258(v259, v260, v261) then
                    v241 = 1;
                end;
                if v241 > 0 then
                    v241 = v241 - 1;
                    v259.block_movement = 2;
                end;
                v242 = v260.m_vecVelocity:clone();
                return;
            end;
        end;
        return function(v263)
            -- upvalues: v102 (ref), v262 (ref), v240 (ref)
            if type(v263) == "boolean" then
                v102(events.createmove, v262, v263);
                v240 = v263;
                return;
            else
                return v240;
            end;
        end;
    end;
    v110.fast_ladder = function()
        -- upvalues: v102 (ref)
        local v264 = false;
        local function v274(v265)
            if v265.sidemove ~= 0 or v265.forwardmove == 0 then
                return;
            else
                local v266 = entity.get_local_player();
                if v266.m_MoveType ~= 9 or bit.band(v266.m_fFlags, 1) == 1 then
                    return;
                else
                    local v267 = v266:get_player_weapon();
                    if v267 == nil then
                        return;
                    else
                        local l_m_fThrowTime_0 = v267.m_fThrowTime;
                        if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 > 0 then
                            return;
                        else
                            local l_m_vecLadderNormal_0 = v266.m_vecLadderNormal;
                            if l_m_vecLadderNormal_0:normalize() == 0 then
                                return;
                            else
                                local l_view_angles_0 = v265.view_angles;
                                local v271 = l_m_vecLadderNormal_0:angles();
                                local v272 = v265.forwardmove > 0;
                                local v273 = math.normalize_yaw(l_view_angles_0.y - v271.y) <= 0;
                                if l_view_angles_0.x - v271.x > 45 then
                                    v272 = not v272;
                                end;
                                v265.in_back = v272 and 1 or 0;
                                v265.in_forward = v272 and 0 or 1;
                                if v273 then
                                    v265.in_moveleft = v272 and 1 or 0;
                                    v265.in_moveright = v272 and 0 or 1;
                                else
                                    v265.in_moveleft = v272 and 0 or 1;
                                    v265.in_moveright = v272 and 1 or 0;
                                end;
                                l_view_angles_0.x = 89;
                                l_view_angles_0.y = v271.y + (v273 and 90 or -90);
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        return function(v275)
            -- upvalues: v264 (ref), v102 (ref), v274 (ref)
            if v275 ~= v264 then
                v102(events.createmove, v274, v275, true);
                v264 = v275;
                return;
            else
                return v264;
            end;
        end;
    end;
    v110.fast_walk = function()
        -- upvalues: v102 (ref)
        local v276 = false;
        local function v280(v277, v278)
            local v279 = vector(v277.forwardmove, v277.sidemove);
            v279 = v279:normalized() * math.min(v278, v279:length());
            v277.forwardmove = v279.x;
            v277.sidemove = v279.y;
        end;
        local function v286(v281)
            -- upvalues: v280 (ref)
            local v282 = entity.get_local_player();
            local v283 = 133.9;
            if v281.in_speed and not v281.in_jump and bit.band(v282.m_fFlags, 1) == 1 then
                v281.in_speed = false;
                v280(v281, v283);
                local v284 = v282:simulate_movement();
                v284:think();
                local v285 = v284.velocity:length();
                if v283 < math.floor(v285) then
                    v280(v281, v283 * 0.25);
                end;
            end;
        end;
        return function(v287)
            -- upvalues: v102 (ref), v286 (ref), v276 (ref)
            if type(v287) == "boolean" then
                v102(events.createmove, v286, v287);
                v276 = v287;
                return;
            else
                return v276;
            end;
        end;
    end;
    v110.quick_throw = function()
        -- upvalues: v102 (ref)
        local v288 = false;
        local v289 = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions");
        local l_sv_infinite_ammo_0 = cvar.sv_infinite_ammo;
        local function v293()
            -- upvalues: v288 (ref), v289 (ref)
            if not v288 then
                v289:override();
                return;
            else
                local v291 = v289:get_override() or v289:get();
                for v292 = 1, #v291 do
                    if v291[v292] == "Quick Switch" then
                        table.remove(v291, v292);
                    end;
                end;
                v289:override(v291);
                return;
            end;
        end;
        local function v295(v294)
            if entity.get_local_player() ~= entity.get(v294.userid, true) then
                return;
            else
                utils.execute_after(globals.tickinterval, utils.console_exec, "slot3; slot2; slot1");
                return;
            end;
        end;
        local function v297(v296)
            -- upvalues: l_sv_infinite_ammo_0 (ref)
            if v296.weapon ~= "weapon_taser" or l_sv_infinite_ammo_0:int() == 1 then
                return;
            elseif entity.get_local_player() ~= entity.get(v296.userid, true) then
                return;
            else
                utils.console_exec("slot3; slot2; slot1");
                return;
            end;
        end;
        return function(v298)
            -- upvalues: v102 (ref), v295 (ref), v297 (ref), v289 (ref), v293 (ref), v288 (ref)
            if type(v298) == "boolean" then
                v102(events.grenade_thrown, v295, v298, true);
                v102(events.weapon_fire, v297, v298, true);
                v102(v289, v293, v298);
                v288 = v298;
                v293();
                return;
            else
                return v288;
            end;
        end;
    end;
    v110.quick_interractions = function()
        -- upvalues: v102 (ref)
        local v299 = false;
        local v300 = 0;
        local v301 = false;
        local v302 = nil;
        local v303 = nil;
        local v304 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
        local function v308(v305)
            -- upvalues: v302 (ref), v303 (ref), v301 (ref)
            if not v305:get_weapon_index() then
                return;
            elseif v305:get_weapon_owner() then
                return;
            else
                local v306 = v305:get_origin();
                if v302:dist(v306) > 128 then
                    return;
                else
                    local v307 = v302:to(v306);
                    if math.deg(math.acos(v303:dot(v307) / v307:length())) > 15 then
                        return;
                    else
                        v301 = true;
                        return;
                    end;
                end;
            end;
        end;
        local function v312(v309, v310)
            -- upvalues: v302 (ref), v301 (ref), v303 (ref), v308 (ref)
            v302 = v310:get_eye_position();
            v301 = false;
            v303 = vector():angles(v309.view_angles:unpack());
            entity.get_entities(false, false, v308);
            local v311 = nil;
            v303 = nil;
            v302 = v311;
            return v301;
        end;
        local function v319(v313, v314)
            local v315 = v314:get_eye_position();
            local v316 = vector():angles(v313.view_angles:unpack());
            local v317 = utils.trace_line(v315, v315 + v316 * 128, v314, 1174421515);
            if not v317.entity then
                return false;
            else
                local v318 = v317.entity:get_classid();
                if v318 == 40 or v318 == 275 or v318 == 83 then
                    return false;
                else
                    return true;
                end;
            end;
        end;
        local function v329(v320, v321)
            -- upvalues: v304 (ref)
            if v320 == nil then
                return;
            else
                local l_huge_0 = math.huge;
                local v323 = nil;
                if v304:get_override() or v304:get() then
                    return;
                else
                    entity.get_entities(97, false, function(v324)
                        -- upvalues: v321 (ref), l_huge_0 (ref), v323 (ref)
                        local v325 = v324:get_origin();
                        local v326 = v321:dist(v325);
                        if v326 < 80 and v326 < l_huge_0 then
                            local l_v326_0 = v326;
                            v323 = v324;
                            l_huge_0 = l_v326_0;
                        end;
                    end);
                    if v323 ~= nil then
                        local v328 = v321:to(v323:get_origin()):angles();
                        return v323, v328;
                    else
                        return;
                    end;
                end;
            end;
        end;
        local function v335(v330, v331)
            -- upvalues: v329 (ref), v300 (ref)
            if v331.m_iTeamNum ~= 3 or v331.m_hCarriedHostage ~= nil then
                return;
            else
                local v332 = v331:get_eye_position();
                local v333, v334 = v329(v331, v332);
                if v330.in_use == false or v333 == nil then
                    v300 = 0;
                else
                    v300 = v300 + 1;
                    v330.view_angles = v334;
                    v330.no_choke = true;
                end;
                if v300 == 1 then
                    v330.in_use = 0;
                elseif v300 > 1 then
                    v330.in_use = 1;
                end;
                return;
            end;
        end;
        local function v343(v336, v337, v338)
            -- upvalues: v312 (ref), v319 (ref)
            if v338:get_classname() ~= "CC4" or v337.m_iTeamNum ~= 2 then
                return;
            elseif v312(v336, v337) or v319(v336, v337) then
                return;
            else
                local v339 = v337:get_anim_state();
                local v340 = v339 and v339.landed_on_ground_this_frame;
                local v341 = bit.band(v337.m_fFlags, 1) == 0 or v336.in_jump or v340;
                if v336.in_attack or v336.in_use then
                    local v342 = not v341 and v337.m_bInBombZone;
                    v336.in_use = v342;
                    v336.in_attack = v342;
                end;
                return;
            end;
        end;
        local function v347(v344)
            -- upvalues: v343 (ref), v335 (ref)
            local v345 = entity.get_local_player();
            local v346 = v345:get_player_weapon();
            if v346 == nil then
                return;
            else
                v343(v344, v345, v346);
                v335(v344, v345);
                return;
            end;
        end;
        return function(v348)
            -- upvalues: v102 (ref), v347 (ref), v299 (ref)
            if type(v348) == "boolean" then
                v102(events.createmove, v347, v348, true);
                v299 = v348;
                return;
            else
                return v299;
            end;
        end;
    end;
    v110.super_toss = function()
        -- upvalues: v56 (ref), v102 (ref)
        local v349 = false;
        local function v354(v350)
            -- upvalues: v56 (ref)
            local v351 = v350:get_weapon_info();
            if v351 == nil then
                return;
            else
                local l_m_flThrowStrength_0 = v350.m_flThrowStrength;
                if l_m_flThrowStrength_0 == nil then
                    return;
                else
                    local _ = nil;
                    l_m_flThrowStrength_0 = l_m_flThrowStrength_0 * 0.7 + 0.3;
                    return v56(v351.throw_velocity * 0.9, 15, 750) * l_m_flThrowStrength_0;
                end;
            end;
        end;
        local function v366(v355, v356, v357, v358)
            local v359 = entity.get_local_player();
            if v359 == nil then
                return;
            else
                local v360 = v359:get_player_weapon();
                if v360 == nil then
                    return;
                elseif v360.m_flThrowStrength == nil then
                    return;
                elseif v358 ~= nil and (v360.m_bPinPulled or v360.m_fThrowTime <= 0) then
                    return;
                else
                    local v361 = vector():angles(vector(v357.x, v357.y));
                    local v362 = v356:length();
                    local v363 = v361:dot(-v356:normalized());
                    local v364 = ((math.sqrt(25 * v363 * v363 * v362 * v362 + 16 * v355 * v355 - 25 * v362 * v362) - 5 * v362 * v363) * 0.25 * v361 - v356 * 1.25) * (1 / v355);
                    if v364.y == 0 and v364.x == 0 then
                        if v364.z <= 0 then
                            v357.x = 90;
                        else
                            v357.x = 270;
                        end;
                    elseif v364.x ~= v364.x or v364.y ~= v364.y or v364.z ~= v364.z then
                        return;
                    else
                        local v365 = v364:angles();
                        v357.x = v365.x;
                        v357.y = v365.y;
                    end;
                    return;
                end;
            end;
        end;
        local function v377(v367)
            -- upvalues: v349 (ref), v354 (ref), v366 (ref)
            local v368 = entity.get_local_player();
            local v369 = v368:get_player_weapon();
            if v349 == false or v369 == nil then
                return;
            else
                local v370 = v354(v369);
                local v371 = to_ticks(v369.m_fThrowTime or 0);
                local _, v373 = rage.exploit:get(true);
                local v374 = v371 - v373 - v368.m_nTickBase;
                if v374 <= -1 and -to_ticks(1) < v374 then
                    v367.in_speed = true;
                end;
                local v375 = nil;
                local v376 = v368:simulate_movement();
                v376:think();
                v375 = v376.velocity:clone();
                v366(v370, v375, v367.view_angles, v367.move_yaw);
                return;
            end;
        end;
        local function v382(v378)
            -- upvalues: v354 (ref), v366 (ref)
            local v379 = entity.get_local_player();
            if v379 == nil then
                return;
            else
                local v380 = v379:get_player_weapon();
                if v380 == nil then
                    return;
                else
                    local v381 = v354(v380);
                    v366(v381, v378.velocity, v378.angles);
                    return;
                end;
            end;
        end;
        return {
            on_createmove = v377, 
            enabled = function(v383)
                -- upvalues: v102 (ref), v382 (ref), v349 (ref)
                if type(v383) == "boolean" then
                    v102(events.grenade_override_view, v382, v383);
                    v349 = v383;
                    return;
                else
                    return v349;
                end;
            end
        };
    end;
    v110.grenade_release = function()
        -- upvalues: v102 (ref)
        local v384 = false;
        local v385 = 1;
        local v386 = nil;
        local v387 = nil;
        local v388 = nil;
        local v389 = nil;
        local v390 = false;
        local l_mp_friendlyfire_0 = cvar.mp_friendlyfire;
        local v392 = ffi.typeof("float[3]");
        local _ = utils.get_vfunc("engine.dll", "VEngineClient014", 18, "void(__thiscall*)(void*, float*)");
        local v394 = utils.get_vfunc("engine.dll", "VEngineClient014", 19, "void(__thiscall*)(void*, float*)");
        local function v396(v395)
            -- upvalues: v386 (ref)
            v386 = {
                tick = globals.tickcount, 
                type = v395.type, 
                damage = v395.damage, 
                fatal = v395.fatal, 
                target = v395.target, 
                path = v395.path, 
                collisions = v395.collisions
            };
        end;
        local function v398(v397)
            -- upvalues: v388 (ref)
            v388 = v397.velocity:clone();
        end;
        local function v400(v399)
            -- upvalues: v389 (ref)
            v389 = v399.view:clone();
        end;
        return {
            on_createmove = function(v401)
                -- upvalues: v384 (ref), v387 (ref), v390 (ref), v386 (ref), v385 (ref), l_mp_friendlyfire_0 (ref), v389 (ref), v392 (ref), v388 (ref), v394 (ref)
                local v402 = entity.get_local_player();
                local v403 = v402:get_player_weapon();
                if v384 == false or v403 == nil or v403.m_fThrowTime == nil then
                    v387 = nil;
                    v390 = false;
                    return;
                else
                    local l_m_bPinPulled_0 = v403.m_bPinPulled;
                    if v386 ~= nil and #v386.path > 1 and v386.tick == v401.tickcount and v390 == true and v401.in_attack then
                        local v405 = nil;
                        v405 = false;
                        if v386.type == "Frag" and (v386.fatal or v386.damage >= v385) then
                            local l_target_0 = v386.target;
                            if l_target_0 ~= nil and l_target_0.m_ArmorValue == 0 then
                                if v386.damage >= v385 * 1.75 then
                                    v405 = true;
                                end;
                            else
                                v405 = true;
                            end;
                        end;
                        if v386.type == "Molly" and v386.target ~= nil and v386.damage / 12 <= 12.5 then
                            v405 = true;
                        end;
                        if v386.type == "Flash" and v386.target ~= nil and v386.damage >= 50 then
                            v405 = true;
                        end;
                        if v386.type == "Smoke" and v386.damage > 0 then
                            local v407 = v386.path[#v386.path];
                            local l_huge_1 = math.huge;
                            local v409 = nil;
                            local v410 = l_mp_friendlyfire_0:int();
                            do
                                local l_v407_0, l_l_huge_1_0, l_v409_0, l_v410_0 = v407, l_huge_1, v409, v410;
                                entity.get_entities("CInferno", false, function(v415)
                                    -- upvalues: v402 (ref), l_v410_0 (ref), l_v407_0 (ref), l_l_huge_1_0 (ref), l_v409_0 (ref)
                                    if v415.m_nFireEffectTickBegin == nil then
                                        return;
                                    else
                                        local l_m_hOwnerEntity_0 = v415.m_hOwnerEntity;
                                        if l_m_hOwnerEntity_0 ~= nil then
                                            if l_m_hOwnerEntity_0 == v402 then
                                                return;
                                            elseif not l_m_hOwnerEntity_0:is_enemy() and l_v410_0 == 0 then
                                                return;
                                            end;
                                        end;
                                        local v417 = v415:get_origin();
                                        local v418 = l_v407_0:dist(v417);
                                        if v418 <= l_l_huge_1_0 then
                                            l_l_huge_1_0 = v418;
                                            l_v409_0 = v417;
                                            if l_l_huge_1_0 / 12 <= 12.5 then
                                                return false;
                                            end;
                                        end;
                                        return;
                                    end;
                                end);
                                if l_l_huge_1_0 / 12 <= 12.5 then
                                    v405 = true;
                                end;
                            end;
                        end;
                        if v405 and v389 ~= nil then
                            v401.in_cancel = true;
                            v401.in_attack = false;
                            v401.in_attack2 = false;
                            if v387 == nil then
                                v387 = {
                                    in_moveright = false, 
                                    in_moveleft = false, 
                                    in_forward = false, 
                                    in_back = false, 
                                    sidemove = 0, 
                                    view_angles = v389:clone(), 
                                    camera_angles = v392(v389:unpack()), 
                                    move_yaw = v388:angles().y, 
                                    forwardmove = v402.m_vecVelocity:length() >= 3 and 450 or 0
                                };
                            end;
                        end;
                    end;
                    local v419 = to_ticks(v403.m_fThrowTime) - v402.m_nTickBase;
                    if v387 ~= nil and v419 >= -1 then
                        for v420, v421 in pairs(v387) do
                            if v420 == "camera_angles" then
                                v394(v421);
                            else
                                v401[v420] = v421;
                            end;
                        end;
                        if v419 == -1 then
                            v387 = nil;
                        end;
                    end;
                    v390 = l_m_bPinPulled_0;
                    return;
                end;
            end, 
            enabled = function(v422, v423)
                -- upvalues: v384 (ref), v385 (ref), v102 (ref), v400 (ref), v398 (ref), v396 (ref)
                local v424 = type(v422);
                local v425 = type(v423);
                if v424 ~= "boolean" and v425 ~= "number" then
                    return v384, v385;
                else
                    local v426 = false;
                    if v424 == "boolean" and v422 ~= v384 then
                        v384 = v422;
                        v426 = true;
                    end;
                    if v425 == "number" and v423 ~= v385 then
                        v385 = v423;
                        v426 = true;
                    end;
                    if v426 then
                        v102(events.override_view, v400, v384, true);
                        v102(events.grenade_override_view, v398, v384);
                        v102(events.grenade_prediction, v396, v384, true);
                    end;
                    return;
                end;
            end
        };
    end;
    v110.tone_mapping = function()
        -- upvalues: v116 (ref), v113 (ref), v102 (ref), v18 (ref), v63 (ref)
        local v427 = v116();
        local v428 = false;
        local v429 = true;
        local v430 = false;
        local v431 = -1;
        local v432 = -1;
        local v433 = -1;
        local v434 = false;
        local v435 = color(33, 33, 34, 135);
        local v436 = nil;
        local v437 = nil;
        local v438 = nil;
        local v439 = nil;
        local v440 = -1;
        local v441 = -1;
        local l_r_modelAmbientMin_0 = cvar.r_modelAmbientMin;
        local l_mat_postprocess_enable_0 = cvar.mat_postprocess_enable;
        local l_mat_fullbright_0 = cvar.mat_fullbright;
        local v445 = ui.find("Visuals", "World", "Main", "Removals");
        local v446, v447 = ui.find("Visuals", "World", "Ambient", "Post Processing");
        local function v449(v448)
            -- upvalues: v437 (ref)
            if v448 == nil then
                return;
            else
                if v437 < 0 then
                    v448.m_bUseCustomBloomScale = false;
                    v448.m_flCustomBloomScale = 0;
                else
                    v448.m_bUseCustomBloomScale = true;
                    v448.m_flCustomBloomScale = v437;
                end;
                return;
            end;
        end;
        local function v451(v450)
            -- upvalues: v438 (ref), v439 (ref)
            if v450 == nil then
                return;
            else
                if v438 < 0 then
                    v450.m_bUseCustomAutoExposureMin = false;
                    v450.m_flCustomAutoExposureMin = 0;
                else
                    v450.m_bUseCustomAutoExposureMin = true;
                    v450.m_flCustomAutoExposureMin = v438;
                end;
                if v439 < 0 then
                    v450.m_bUseCustomAutoExposureMax = false;
                    v450.m_flCustomAutoExposureMax = 0;
                else
                    v450.m_bUseCustomAutoExposureMax = true;
                    v450.m_flCustomAutoExposureMax = v439;
                end;
                return;
            end;
        end;
        local function v453(v452)
            -- upvalues: v431 (ref), v437 (ref), v440 (ref), v449 (ref)
            if v452 == nil then
                return;
            else
                if v431 >= 0 then
                    if v437 == nil then
                        if v452.m_bUseCustomBloomScale then
                            v437 = v452.m_flCustomBloomScale;
                        else
                            v437 = -1;
                        end;
                    end;
                    v452.m_bUseCustomBloomScale = true;
                    v452.m_flCustomBloomScale = v431 * 0.01;
                elseif v440 ~= nil and v440 >= 0 and v437 ~= nil then
                    v449(v452);
                end;
                v440 = v431;
                return;
            end;
        end;
        local function v456(v454)
            -- upvalues: v432 (ref), v438 (ref), v439 (ref), v441 (ref), v451 (ref)
            if v454 == nil then
                return;
            else
                if v432 >= 0 then
                    if v438 == nil then
                        if v454.m_bUseCustomAutoExposureMin then
                            v438 = v454.m_flCustomAutoExposureMin;
                        else
                            v438 = -1;
                        end;
                        if v454.m_bUseCustomAutoExposureMax then
                            v439 = v454.m_flCustomAutoExposureMax;
                        else
                            v439 = -1;
                        end;
                    end;
                    local v455 = math.max(0, v432 * 0.001);
                    v454.m_bUseCustomAutoExposureMin = true;
                    v454.m_bUseCustomAutoExposureMax = true;
                    v454.m_flCustomAutoExposureMin = v455;
                    v454.m_flCustomAutoExposureMax = v455;
                elseif v441 ~= nil and v441 >= 0 and v438 ~= nil then
                    v451(v454);
                end;
                v441 = v432;
                return;
            end;
        end;
        local function v469()
            -- upvalues: v434 (ref), v430 (ref), v435 (ref), v446 (ref), v447 (ref)
            if v434 == false or v430 == false then
                return;
            else
                local v457, v458, v459, v460 = v435:unpack();
                local v461 = v457 / 255;
                local v462 = v458 / 255;
                v459 = v459 / 255;
                v458 = v462;
                v457 = v461;
                v461 = v460 / 128 - 1;
                v462 = nil;
                local v463 = nil;
                local v464 = nil;
                if v461 > 0 then
                    v461 = v461 * (900 ^ v461 - 1);
                    local v465 = v457 * v461;
                    local v466 = v458 * v461;
                    v464 = v459 * v461;
                    v463 = v466;
                    v462 = v465;
                else
                    v461 = v461 * 1;
                    local v467 = (1 - v457) * v461;
                    local v468 = (1 - v458) * v461;
                    v464 = (1 - v459) * v461;
                    v463 = v468;
                    v462 = v467;
                end;
                v446:override(true);
                v447:override(color(v462 * 255, v463 * 255, v464 * 255, 255));
                return;
            end;
        end;
        local function v473()
            -- upvalues: v440 (ref), v437 (ref), v449 (ref), v441 (ref), v438 (ref), v451 (ref), v436 (ref), v439 (ref)
            entity.get_entities("CEnvTonemapController", true, function(v470)
                -- upvalues: v440 (ref), v437 (ref), v449 (ref), v441 (ref), v438 (ref), v451 (ref)
                if v440 >= 0 and v437 ~= nil then
                    v449(v470);
                end;
                if v441 >= 0 and v438 ~= nil then
                    v451(v470);
                end;
            end);
            v436 = nil;
            local v471 = nil;
            local v472 = nil;
            v439 = nil;
            v438 = v472;
            v437 = v471;
        end;
        local function v477()
            -- upvalues: v431 (ref), v440 (ref), v432 (ref), v441 (ref), v113 (ref), v436 (ref), v437 (ref), v438 (ref), v439 (ref), v453 (ref), v456 (ref)
            if v431 == v440 and v432 == v441 and v113(0.5) then
                return;
            else
                entity.get_entities("CEnvTonemapController", true, function(v474)
                    -- upvalues: v436 (ref), v437 (ref), v438 (ref), v439 (ref), v453 (ref), v456 (ref)
                    if v436 ~= nil and v436 ~= v474[0] then
                        local v475 = nil;
                        local v476 = nil;
                        v439 = nil;
                        v438 = v476;
                        v437 = v475;
                    end;
                    v436 = v474[0];
                    v453(v474);
                    v456(v474);
                end);
                return;
            end;
        end;
        local function v478()
            -- upvalues: v113 (ref), v469 (ref)
            if v113() then
                return;
            else
                v469();
                return;
            end;
        end;
        local function v479()
            -- upvalues: v446 (ref), v447 (ref)
            v446:override();
            v447:override();
        end;
        local function v480()
            -- upvalues: l_r_modelAmbientMin_0 (ref)
            l_r_modelAmbientMin_0:float(tonumber(l_r_modelAmbientMin_0:string()), true);
        end;
        local function v481()
            -- upvalues: v433 (ref), l_r_modelAmbientMin_0 (ref)
            if v433 < 0 then
                return;
            else
                l_r_modelAmbientMin_0:float(v433, true);
                return;
            end;
        end;
        local function v483()
            -- upvalues: v429 (ref), v431 (ref), v432 (ref), v428 (ref), v473 (ref), v102 (ref), v477 (ref)
            local v482 = v429 and (v431 >= 0 or v432 >= 0);
            if v482 == false and v428 == true then
                v473();
            end;
            if v482 ~= v428 then
                v428 = v482;
                v102(events.shutdown, v473, v428);
                v102(events.net_update_end, v477, v428);
            end;
        end;
        local function v484()
            -- upvalues: v102 (ref), v479 (ref), v434 (ref), v478 (ref), v446 (ref), v469 (ref), v447 (ref), v430 (ref)
            v102(events.shutdown, v479, v434);
            v102(events.net_update_end, v478, v434);
            v102(v446, v469, v434);
            v102(v447, v469, v434);
            if v434 ~= v430 then
                if v434 == false then
                    v479();
                else
                    v469();
                end;
            end;
            v430 = v434;
        end;
        local function v487()
            -- upvalues: v445 (ref), l_mat_postprocess_enable_0 (ref), l_mat_fullbright_0 (ref), v429 (ref), v483 (ref), v427 (ref), v428 (ref)
            local v485 = true;
            if globals.is_in_game then
                v485 = #entity.get_entities("CEnvTonemapController") > 0;
            end;
            local v486 = v485 == true and v445:get("Post Processing") == false and l_mat_postprocess_enable_0:int() == 1 and l_mat_fullbright_0:int() == 0;
            if v486 ~= v429 then
                v429 = v486;
                v483();
                v427:call({
                    tonemap_enabled = v428 and v429, 
                    tonemap_available = v429
                });
            end;
        end;
        local function v489(v488)
            -- upvalues: v431 (ref), v18 (ref), v63 (ref), v483 (ref)
            if type(v488) ~= "number" then
                return v431;
            else
                v18(v488 >= -1 and v488 <= 250, "bloom must be within range [-1, 250]");
                v431 = v488 >= 0 and v63(v488, 0, 250, 0, 500) or v488;
                v483();
                return v431;
            end;
        end;
        local function v491(v490)
            -- upvalues: v432 (ref), v18 (ref), v63 (ref), v483 (ref)
            if type(v490) ~= "number" then
                return v432;
            else
                v18(v490 >= -1 and v490 <= 200, "exposure must be within range [-1, 250]");
                v432 = v490 >= 0 and v63(v490, 0, 200, 0, 2000) or v490;
                v483();
                return v432;
            end;
        end;
        local function v494(v492)
            -- upvalues: v433 (ref), v18 (ref), v63 (ref), v102 (ref), v480 (ref), l_r_modelAmbientMin_0 (ref), v481 (ref)
            if type(v492) ~= "number" then
                return v433;
            else
                v18(v492 >= -1 and v492 <= 200, "model brightness must be within range [-1, 250]");
                local v493 = v63(v492, 0, 200, 0, 50, true);
                if v493 == v433 then
                    return;
                else
                    v433 = v493;
                    v102(events.shutdown, v480, v492 > 0);
                    v102(l_r_modelAmbientMin_0, v481, v492 > 0);
                    if v492 < 0 then
                        v480();
                    else
                        l_r_modelAmbientMin_0:float(v433, true);
                    end;
                    return;
                end;
            end;
        end;
        local function v500(v495, v496)
            -- upvalues: v434 (ref), v435 (ref), v484 (ref)
            local v497 = type(v495);
            local v498 = type(v496);
            if v497 ~= "boolean" and v498 ~= "userdata" then
                return v434, v435;
            else
                local v499 = false;
                if v497 == "boolean" and v434 ~= v495 then
                    v434 = v495;
                    v499 = true;
                end;
                if v498 == "userdata" and v435 ~= v496 then
                    v435 = v496;
                    v499 = true;
                end;
                if v499 then
                    v484();
                end;
                return v434, v435;
            end;
        end;
        utils.execute_after(0, function()
            -- upvalues: v102 (ref), v487 (ref), v445 (ref), l_mat_postprocess_enable_0 (ref), l_mat_fullbright_0 (ref)
            v102(events.level_init, v487, not _DISABLE_UI_EVENTS);
            v102(v445, v487, not _DISABLE_UI_EVENTS, true);
            v102(l_mat_postprocess_enable_0, v487, not _DISABLE_UI_EVENTS);
            v102(l_mat_fullbright_0, v487, not _DISABLE_UI_EVENTS);
            local l_is_in_game_0 = globals.is_in_game;
            local function v502()
                -- upvalues: l_is_in_game_0 (ref), v487 (ref), v502 (ref)
                local l_is_in_game_1 = globals.is_in_game;
                if l_is_in_game_1 == false and l_is_in_game_1 ~= l_is_in_game_0 then
                    v487();
                end;
                l_is_in_game_0 = l_is_in_game_1;
                utils.execute_after(0.1, v502);
            end;
            v502();
        end);
        return {
            callback = v427, 
            tonemap_enabled = function()
                -- upvalues: v428 (ref)
                return v428;
            end, 
            tonemap_available = function()
                -- upvalues: v429 (ref)
                return v429;
            end, 
            ambient_light = v500, 
            model_brightness = v494, 
            exposure = v491, 
            bloom = v489
        };
    end;
    v110.colored_weapons = function()
        -- upvalues: v113 (ref), v102 (ref), v18 (ref)
        local v504 = false;
        local v505 = false;
        local v506 = nil;
        local v507 = color();
        local v508 = {};
        local v509 = false;
        local v510 = color();
        local v511 = "Default";
        local v512 = color();
        local v513 = {};
        local v514 = {
            [1] = "Default", 
            [2] = "Solid", 
            [3] = "Glow", 
            [4] = "Glass", 
            [5] = "Material"
        };
        local v515 = ui.find("Visuals", "Players", "Self", "Chams", "Weapon");
        local v516 = ui.find("Visuals", "Players", "Self", "Chams", "Weapon", "Color");
        local v517, v518 = ui.find("Visuals", "Players", "Self", "Chams", "Weapon", "Style");
        local function v524(v519, v520)
            local v521 = false;
            for _, v523 in ipairs(v519) do
                if v523 == v520 then
                    v521 = true;
                    break;
                end;
            end;
            return v521;
        end;
        local function v527()
            -- upvalues: v513 (ref), v506 (ref)
            for _, v526 in pairs(v513) do
                if v526 ~= nil and v526:is_valid() then
                    v526:reset();
                end;
            end;
            if v506 ~= nil and v506:is_valid() == true then
                v506:reset();
            end;
            v513 = {};
        end;
        local function v535()
            -- upvalues: v504 (ref), v506 (ref), v524 (ref), v513 (ref), v508 (ref), v507 (ref)
            if v504 == false or v506 == nil then
                return;
            else
                local v528 = entity.get_local_player();
                if v528 == nil or v528:is_alive() == false then
                    return;
                else
                    local v529 = v528.m_hViewModel[0];
                    if v529 == nil or v529.m_hWeapon == nil or v529.m_hWeapon.m_hOwnerEntity ~= v528 then
                        return;
                    else
                        for _, v531 in ipairs(v529:get_materials()) do
                            if not v524(v513, v531) then
                                table.insert(v513, v531);
                            end;
                            for v532 = 0, 31 do
                                v531:var_flag(v532, v506:var_flag(v532));
                            end;
                            v531:shader_param(6, v506:shader_param(6));
                            v531:shader_param("$phong", "0");
                            for _, v534 in pairs(v508) do
                                v531:var_flag(v534, not v531:var_flag(v534));
                            end;
                            v531:color_modulate(v507);
                            v531:alpha_modulate(v507.a);
                        end;
                        return;
                    end;
                end;
            end;
        end;
        local function v536()
            -- upvalues: v509 (ref), v505 (ref), v515 (ref), v516 (ref), v510 (ref), v517 (ref), v511 (ref), v518 (ref), v512 (ref)
            if v509 == false or v505 == false then
                return;
            else
                v515:override(v509);
                v516:override(v510);
                v517:override(v511);
                v518:override(v512);
                return;
            end;
        end;
        local function v538(v537)
            -- upvalues: v506 (ref), v527 (ref)
            if entity.get(v537.userid, true) ~= entity.get_local_player() then
                return;
            elseif v506 == nil or v506:is_valid() == false then
                return;
            else
                v527();
                return;
            end;
        end;
        local function v540(v539)
            -- upvalues: v535 (ref)
            if entity.get(v539.userid, true) ~= entity.get_local_player() then
                return;
            else
                utils.execute_after(0, v535);
                utils.execute_after(globals.tickinterval * globals.clock_offset, v535);
                return;
            end;
        end;
        local function v541()
            -- upvalues: v113 (ref), v535 (ref)
            if v113() then
                return;
            else
                v535();
                return;
            end;
        end;
        local function v542()
            -- upvalues: v527 (ref)
            v527();
        end;
        local function v543()
            -- upvalues: v113 (ref), v536 (ref)
            if v113() then
                return;
            else
                v536();
                return;
            end;
        end;
        local function v544()
            -- upvalues: v515 (ref), v516 (ref), v517 (ref), v518 (ref)
            v515:override();
            v516:override();
            v517:override();
            v518:override();
        end;
        local function v547(v545)
            -- upvalues: v506 (ref), v504 (ref), v542 (ref), v102 (ref), v540 (ref), v538 (ref), v541 (ref), v535 (ref)
            local v546 = v506 ~= nil;
            if v546 == false and v504 == true then
                v542();
            end;
            if v546 ~= v504 then
                v504 = v546;
                v102(events.shutdown, v542, v504);
                v102(events.item_equip, v540, v504);
                v102(events.player_spawn, v538, v504);
                v102(events.net_update_end, v541, v504);
                v535();
            end;
            if v504 and v545 == true then
                v535();
            end;
        end;
        local function v548()
            -- upvalues: v509 (ref), v505 (ref), v544 (ref), v102 (ref), v543 (ref), v515 (ref), v536 (ref), v516 (ref), v517 (ref), v518 (ref)
            if v509 == false and v505 == true then
                v544();
            end;
            v505 = v509;
            v102(events.shutdown, v544, v509);
            v102(events.net_update_end, v543, v509);
            v102(v515, v536, v509);
            v102(v516, v536, v509);
            v102(v517, v536, v509);
            v102(v518, v536, v509);
            if v509 == true then
                v536();
            end;
        end;
        local function v558(v549, v550, v551)
            -- upvalues: v506 (ref), v527 (ref), v547 (ref), v18 (ref), v507 (ref), v508 (ref)
            local v552 = {};
            local v553 = false;
            local l_pairs_0 = pairs;
            local v555 = v551 or {};
            for _, v557 in l_pairs_0(v555) do
                if type(v557) == "number" and v557 >= 0 and v557 <= 32 then
                    table.insert(v552, v557);
                end;
            end;
            if v549 == nil and v550 == nil and v551 == nil then
                v506 = nil;
                v527();
                v547();
                return;
            else
                if type(v549) == "string" then
                    l_pairs_0 = materials.get(v549, true);
                    v18(l_pairs_0 ~= nil, "invalid material");
                    if v506 == nil or v506 ~= nil and v506:get_name() ~= l_pairs_0:get_name() then
                        v506 = l_pairs_0;
                        v553 = true;
                    end;
                end;
                if type(v550) == "userdata" and v550.r ~= nil and v550.g ~= nil and v550.b ~= nil then
                    l_pairs_0 = v550:clone();
                    if v507 ~= l_pairs_0 then
                        v507 = l_pairs_0;
                        v553 = true;
                    end;
                end;
                if type(v551) == "table" and table.concat(v508) ~= table.concat(v552) then
                    v508 = v552;
                    v553 = true;
                end;
                if v553 then
                    v547(true);
                end;
                return;
            end;
        end;
        local function v571(v559, v560, v561, v562)
            -- upvalues: v509 (ref), v511 (ref), v510 (ref), v512 (ref), v514 (ref), v18 (ref), v548 (ref)
            local v563 = type(v559);
            local v564 = type(v560);
            local v565 = type(v561);
            local v566 = type(v562);
            if v563 ~= "boolean" and v564 ~= "string" and v565 ~= "userdata" and v566 ~= "userdata" then
                return v509, v511, v510, v512;
            else
                local v567 = false;
                if v563 == "boolean" and v509 ~= v559 then
                    v509 = v559;
                    v567 = true;
                end;
                if v564 == "string" and v511 ~= v560 then
                    local v568 = false;
                    for _, v570 in ipairs(v514) do
                        if v560:lower() == v570:lower() then
                            v568 = true;
                            break;
                        end;
                    end;
                    v18(v568, "unknown chams style");
                    v511 = v560;
                    v567 = true;
                end;
                if v565 == "userdata" and v510 ~= v561 then
                    v510 = v561;
                    v567 = true;
                end;
                if v566 == "userdata" and v512 ~= v562 then
                    v512 = v562;
                    v567 = true;
                end;
                if v567 then
                    v548();
                end;
                return;
            end;
        end;
        return {
            setup = v558, 
            setup_chams = v571, 
            reset = v527
        };
    end;
    v110.weather = function()
        -- upvalues: v113 (ref), v18 (ref), v102 (ref)
        local v572 = -1;
        local v573 = nil;
        local v574 = nil;
        local v575 = 8192;
        local v576 = ffi.typeof("            struct {\n                void*(*create_class)(int, int);\n                void*(*create_event)();\n                char* network_name;\n                void* recv_table;\n                void* next;\n                int class_id;\n            }\n        ");
        local v577 = utils.get_vfunc("client.dll", "VClient018", 8, "$* (__thiscall*)(void*)", v576);
        local v578 = utils.get_vfunc("client.dll", "VClientEntityList003", 0, "void*(__thiscall*)(void*, int)");
        local v579 = utils.get_vfunc(1, "float*(__thiscall*)(void*)");
        local v580 = utils.get_vfunc(2, "float*(__thiscall*)(void*)");
        local v581 = utils.get_vfunc(3, "void***(__thiscall*)(void*)");
        local v582 = utils.get_vfunc(4, "void(__thiscall*)(void*, int)");
        local v583 = utils.get_vfunc(5, "void(__thiscall*)(void*, int)");
        local v584 = utils.get_vfunc(6, "void(__thiscall*)(void*, int)");
        local v585 = utils.get_vfunc(7, "void(__thiscall*)(void*, int)");
        local function v587()
            -- upvalues: v573 (ref), v577 (ref), v576 (ref)
            if entity.get_local_player() == nil or globals.is_in_game == false then
                return;
            else
                if #entity.get_entities("CPrecipitation") == 0 then
                    if v573 == nil then
                        local v586 = v577();
                        while v586 ~= nil do
                            if v586.class_id == 138 then
                                v573 = v586;
                                break;
                            else
                                v586 = ffi.cast(ffi.typeof("$*", v576), v586.next);
                            end;
                        end;
                    end;
                    if v573 ~= nil and v573.create_class ~= nil then
                        pcall(v573.create_class, 2047, 0);
                    end;
                end;
                return;
            end;
        end;
        local function v596(v588)
            -- upvalues: v574 (ref), v578 (ref), v584 (ref), v582 (ref), v581 (ref), v579 (ref), v580 (ref), v575 (ref), v572 (ref), v583 (ref), v585 (ref)
            if v588[0] == nil then
                return;
            elseif v574 ~= nil and v574 == v588[0] then
                return;
            else
                v574 = v588[0];
                local v589 = v588:get_index();
                local v590 = v578(v589);
                if v590 ~= nil then
                    v584(v590, 0);
                    v582(v590, 0);
                    local v591 = v581(v588[0]);
                    if v591 ~= nil then
                        local v592 = v579(v591);
                        local v593 = v580(v591);
                        if v592 ~= nil and v593 ~= nil then
                            local l_v575_0 = v575;
                            local l_v575_1 = v575;
                            v593[2] = v575;
                            v593[1] = l_v575_1;
                            v593[0] = l_v575_0;
                            l_v575_0 = -v575;
                            l_v575_1 = -v575;
                            v592[2] = -v575;
                            v592[1] = l_v575_1;
                            v592[0] = l_v575_0;
                            v588.m_nPrecipType = v572;
                        end;
                    end;
                    v583(v590, 0);
                    v585(v590, 0);
                end;
                return;
            end;
        end;
        local function v598()
            -- upvalues: v596 (ref)
            if entity.get_local_player() == nil or globals.is_in_game == false then
                return;
            else
                entity.get_entities("CPrecipitation", true, function(v597)
                    -- upvalues: v596 (ref)
                    v596(v597);
                    return false;
                end);
                return;
            end;
        end;
        local function v599()
            common.force_full_update();
        end;
        local function v600()
            -- upvalues: v113 (ref), v587 (ref), v598 (ref)
            if v113(0.5) == true then
                return;
            else
                v587();
                v598();
                return;
            end;
        end;
        local function v601()
            -- upvalues: v599 (ref)
            v599();
        end;
        return function(v602)
            -- upvalues: v572 (ref), v18 (ref), v102 (ref), v600 (ref), v601 (ref), v599 (ref), v587 (ref), v598 (ref)
            if type(v602) ~= "number" then
                return v572 + 1;
            else
                v18(v602 >= 0 and v602 <= 2, "weather mode must be within range [Off, 1, 2]");
                if v602 ~= v572 + 1 then
                    v572 = v602 - 1;
                    v102(events.net_update_end, v600, v602 > 0);
                    v102(events.shutdown, v601, v602 > 0);
                    if v572 == -1 then
                        v599();
                    else
                        v587();
                        v598();
                    end;
                end;
                return;
            end;
        end;
    end;
    v110.viewmodel = function()
        -- upvalues: v102 (ref)
        local l_cl_righthand_0 = cvar.cl_righthand;
        local l_viewmodel_fov_0 = cvar.viewmodel_fov;
        local l_viewmodel_offset_x_0 = cvar.viewmodel_offset_x;
        local l_viewmodel_offset_y_0 = cvar.viewmodel_offset_y;
        local l_viewmodel_offset_z_0 = cvar.viewmodel_offset_z;
        local l_viewmodel_offset_randomize_0 = cvar.viewmodel_offset_randomize;
        local l_viewmodel_presetpos_0 = cvar.viewmodel_presetpos;
        local l_cl_use_new_headbob_0 = cvar.cl_use_new_headbob;
        local v611 = false;
        local v612 = false;
        local v613 = false;
        local v614 = false;
        local v615 = false;
        local v616 = tonumber(l_viewmodel_offset_x_0:string()) or 0;
        local v617 = tonumber(l_viewmodel_offset_y_0:string()) or 0;
        local v618 = tonumber(l_viewmodel_offset_z_0:string()) or 0;
        local v619 = tonumber(l_viewmodel_fov_0:string()) or 54;
        local function v622()
            local v620 = entity.get_local_player();
            if v620 == nil then
                return;
            else
                local v621 = v620:get_player_weapon();
                if v621 == nil then
                    return;
                else
                    return v621:get_classid() == 107;
                end;
            end;
        end;
        local function v626()
            -- upvalues: v611 (ref), l_cl_righthand_0 (ref), l_cl_use_new_headbob_0 (ref), v615 (ref), v622 (ref), l_viewmodel_offset_x_0 (ref), v616 (ref), l_viewmodel_offset_y_0 (ref), v617 (ref), l_viewmodel_offset_z_0 (ref), v618 (ref), l_viewmodel_fov_0 (ref), v619 (ref), v614 (ref)
            if not v611 then
                return;
            else
                local v623 = tonumber(l_cl_righthand_0:string()) or 1;
                local v624 = tonumber(l_cl_use_new_headbob_0:string()) or 1;
                local v625 = v615 and v622();
                l_viewmodel_offset_x_0:float(v616, true);
                l_viewmodel_offset_y_0:float(v617, true);
                l_viewmodel_offset_z_0:float(v618, true);
                l_viewmodel_fov_0:float(v619, true);
                l_cl_righthand_0:int(bit.bxor(v623, v625 and 1 or 0), true);
                l_cl_use_new_headbob_0:int(bit.bxor(v624, v614 and 1 or 0), true);
                return;
            end;
        end;
        local function v628()
            -- upvalues: v611 (ref), v615 (ref), v622 (ref), v613 (ref), v626 (ref)
            if not v611 then
                return;
            else
                local v627 = v615 and v622();
                if v627 ~= v613 then
                    v613 = v627;
                    v626();
                end;
                return;
            end;
        end;
        local function v629()
            -- upvalues: l_viewmodel_offset_x_0 (ref), l_viewmodel_offset_y_0 (ref), l_viewmodel_offset_z_0 (ref), l_viewmodel_fov_0 (ref), l_cl_righthand_0 (ref), l_cl_use_new_headbob_0 (ref)
            l_viewmodel_offset_x_0:float(tonumber(l_viewmodel_offset_x_0:string()) or 0, true);
            l_viewmodel_offset_y_0:float(tonumber(l_viewmodel_offset_y_0:string()) or 0, true);
            l_viewmodel_offset_z_0:float(tonumber(l_viewmodel_offset_z_0:string()) or 0, true);
            l_viewmodel_fov_0:float(tonumber(l_viewmodel_fov_0:string()) or 54, true);
            l_cl_righthand_0:int(tonumber(l_cl_righthand_0:string()) or 1, true);
            l_cl_use_new_headbob_0:int(tonumber(l_cl_use_new_headbob_0:string()) or 1, true);
        end;
        local function v630()
            -- upvalues: v611 (ref), v612 (ref), v102 (ref), v628 (ref), v629 (ref), l_cl_righthand_0 (ref), v626 (ref), l_viewmodel_offset_x_0 (ref), l_viewmodel_offset_y_0 (ref), l_viewmodel_offset_z_0 (ref), l_viewmodel_fov_0 (ref), l_viewmodel_offset_randomize_0 (ref), l_viewmodel_presetpos_0 (ref), l_cl_use_new_headbob_0 (ref)
            if v611 ~= v612 then
                v102(events.render, v628, v611);
                v102(events.shutdown, v629, v611);
                v102(l_cl_righthand_0, v626, v611);
                v102(l_viewmodel_offset_x_0, v626, v611);
                v102(l_viewmodel_offset_y_0, v626, v611);
                v102(l_viewmodel_offset_z_0, v626, v611);
                v102(l_viewmodel_fov_0, v626, v611);
                v102(l_viewmodel_offset_randomize_0, v626, v611);
                v102(l_viewmodel_presetpos_0, v626, v611);
                v102(l_cl_use_new_headbob_0, v626, v611);
                if v611 == true then
                    v626();
                else
                    v629();
                end;
                v612 = v611;
            end;
        end;
        return function(v631, v632, v633, v634, v635, v636, v637)
            -- upvalues: v611 (ref), v615 (ref), v616 (ref), v617 (ref), v618 (ref), v619 (ref), v614 (ref), v630 (ref), v626 (ref)
            local v638 = type(v631);
            local v639 = type(v632);
            local v640 = type(v633);
            local v641 = type(v634);
            local v642 = type(v635);
            local v643 = type(v636);
            local v644 = type(v637);
            if v638 ~= "boolean" and v639 ~= "boolean" and v640 ~= "boolean" and v641 ~= "number" and v642 ~= "number" and v643 ~= "number" and v644 ~= "number" then
                return v611, v615, v616, v617, v618, v619;
            else
                local v645 = false;
                if v638 == "boolean" then
                    v611 = v631;
                    v645 = true;
                end;
                if v639 == "boolean" then
                    v615 = v632;
                    v645 = true;
                end;
                if v640 == "boolean" then
                    v614 = v633;
                    v645 = true;
                end;
                if v641 == "number" then
                    v616 = v634;
                    v645 = true;
                end;
                if v642 == "number" then
                    v617 = v635;
                    v645 = true;
                end;
                if v643 == "number" then
                    v618 = v636;
                    v645 = true;
                end;
                if v644 == "number" then
                    v619 = v637;
                    v645 = true;
                end;
                if v645 then
                    v630();
                    v626();
                end;
                return;
            end;
        end;
    end;
    v110.removals = function()
        -- upvalues: v113 (ref), v102 (ref)
        local v646 = false;
        local v647 = false;
        local v648 = 0;
        local l_violence_ablood_0 = cvar.violence_ablood;
        local l_violence_hblood_0 = cvar.violence_hblood;
        local l_violence_agibs_0 = cvar.violence_agibs;
        local l_violence_hgibs_0 = cvar.violence_hgibs;
        local function v654(v653)
            -- upvalues: l_violence_ablood_0 (ref), l_violence_hblood_0 (ref), l_violence_agibs_0 (ref), l_violence_hgibs_0 (ref)
            if v653 == true then
                l_violence_ablood_0:int(tonumber(l_violence_ablood_0:string()), true);
                l_violence_hblood_0:int(tonumber(l_violence_hblood_0:string()), true);
                l_violence_agibs_0:int(tonumber(l_violence_agibs_0:string()), true);
                l_violence_hgibs_0:int(tonumber(l_violence_hgibs_0:string()), true);
            else
                l_violence_ablood_0:int(0, true);
                l_violence_hblood_0:int(0, true);
                l_violence_agibs_0:int(0, true);
                l_violence_hgibs_0:int(0, true);
            end;
        end;
        local function v655()
            -- upvalues: v113 (ref), v654 (ref)
            if v113(0.5) then
                return;
            else
                v654();
                return;
            end;
        end;
        local function v656()
            -- upvalues: v654 (ref)
            v654(true);
        end;
        local function v658(v657)
            -- upvalues: v646 (ref), v654 (ref), v102 (ref), v656 (ref), v655 (ref), l_violence_ablood_0 (ref), l_violence_agibs_0 (ref), l_violence_hgibs_0 (ref)
            if type(v657) ~= "boolean" then
                return v646;
            else
                if v657 ~= v646 then
                    if v657 == false then
                        v654(true);
                    end;
                    v646 = v657;
                    v102(events.shutdown, v656, v657);
                    v102(events.net_update_end, v655, v657);
                    v102(l_violence_ablood_0, v654, v657);
                    v102(l_violence_agibs_0, v654, v657);
                    v102(l_violence_agibs_0, v654, v657);
                    v102(l_violence_hgibs_0, v654, v657);
                    if v657 == true then
                        v654();
                        cvar.r_cleardecals:call();
                    end;
                end;
                return;
            end;
        end;
        local function v661(v659)
            -- upvalues: v648 (ref)
            local v660 = ffi.cast("void**", ffi.cast("uint32_t", v659[0]) + 10752);
            if v660 == nil then
                return;
            else
                if v648 == 2 then
                    v659.m_nRenderMode = 10;
                end;
                v660[0] = nil;
                return;
            end;
        end;
        local function v664()
            -- upvalues: v661 (ref)
            if entity.get_local_player() == nil then
                return;
            else
                for _, v663 in ipairs(entity.get_entities(42)) do
                    v661(v663);
                end;
                return;
            end;
        end;
        local function v666(v665)
            -- upvalues: v648 (ref), v102 (ref), v664 (ref)
            if type(v665) ~= "number" then
                return v648;
            else
                if v665 ~= v648 then
                    v102(events.net_update_end, v664, v665 > 0);
                    v648 = v665;
                end;
                return;
            end;
        end;
        local function v671(v667)
            -- upvalues: v647 (ref)
            local v668 = entity.get_local_player();
            if v668 == nil then
                return;
            else
                local v669 = v668:is_alive();
                entity.get_players(false, true, function(v670)
                    -- upvalues: v668 (ref), v667 (ref), v647 (ref), v669 (ref)
                    if v670 ~= v668 and v670:is_enemy() == false then
                        if v667 == true or not v647 or not v669 then
                            v670.m_nRenderMode = 0;
                        else
                            v670.m_nRenderMode = 10;
                        end;
                    end;
                end);
                return;
            end;
        end;
        local function v672()
            -- upvalues: v671 (ref)
            v671(true);
        end;
        local function v673()
            -- upvalues: v671 (ref)
            v671();
        end;
        local function v675(v674)
            -- upvalues: v647 (ref), v671 (ref), v102 (ref), v672 (ref), v673 (ref)
            if type(v674) ~= "boolean" then
                return v647;
            else
                if v674 ~= v647 then
                    v671(not v674);
                    v102(events.shutdown, v672, v674);
                    v102(events.net_update_end, v673, v674);
                    v647 = v674;
                end;
                return;
            end;
        end;
        return {
            blood = v658, 
            team_rendering = v675, 
            ragdoll_physics = v666
        };
    end;
    v110.console_color = function()
        -- upvalues: v102 (ref)
        local v676 = false;
        local v677 = false;
        local v678 = false;
        local v679 = color(255, 0);
        local l_toggleconsole_0 = cvar.toggleconsole;
        local v681 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
        local v682 = {
            [1] = "vgui_white", 
            [2] = "vgui/hud/800corner1", 
            [3] = "vgui/hud/800corner2", 
            [4] = "vgui/hud/800corner3", 
            [5] = "vgui/hud/800corner4"
        };
        for v683, v684 in ipairs(v682) do
            v682[v683] = materials.get_materials(v684)[1];
        end;
        local function v688(v685)
            -- upvalues: v682 (ref), v679 (ref)
            for _, v687 in ipairs(v682) do
                if v685 == true then
                    v687:reset();
                else
                    v687:color_modulate(v679);
                    v687:alpha_modulate(v679.a / 255);
                end;
            end;
        end;
        local function v689()
            -- upvalues: v676 (ref), v681 (ref), v678 (ref), v688 (ref)
            if v676 and v681() then
                if v678 == false then
                    v688();
                    v678 = true;
                end;
            elseif v678 == true then
                v688(true);
                v678 = false;
            end;
        end;
        local function v690()
            -- upvalues: v688 (ref), v678 (ref)
            v688(true);
            v678 = false;
        end;
        local function v691()
            -- upvalues: v676 (ref), v677 (ref), v678 (ref), v690 (ref), v102 (ref), v689 (ref), l_toggleconsole_0 (ref), v688 (ref), v681 (ref)
            if v676 == false and v677 == true then
                v678 = false;
                v690();
            end;
            v677 = v676;
            v678 = false;
            v102(events.render, v689, v676);
            v102(events.shutdown, v690, v676);
            v102(l_toggleconsole_0, v688, v676);
            if v676 == true and v681() then
                utils.execute_after(0, v688);
            end;
        end;
        return function(v692, v693)
            -- upvalues: v676 (ref), v679 (ref), v691 (ref)
            local v694 = type(v692);
            local v695 = type(v693);
            if v694 ~= "boolean" and v695 ~= "userdata" then
                return v676, v679;
            else
                local v696 = true;
                if v694 == "boolean" and v676 ~= v692 then
                    v676 = v692;
                    v696 = true;
                end;
                if v695 == "userdata" and v679 ~= v693 then
                    v679 = v693;
                    v696 = true;
                end;
                if v696 then
                    v691();
                end;
                return;
            end;
        end;
    end;
    v110.game_focus = function()
        -- upvalues: v18 (ref), v102 (ref)
        local v697 = false;
        local v698 = 0;
        local v699 = nil;
        local l_PartyListAPI_0 = panorama.PartyListAPI;
        local v701 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
        local v702 = nil;
        local v703 = nil;
        ffi.cdef("            void* GetForegroundWindow();\n            void* SetForegroundWindow(void*);\n            void* SetFocus(void*);\n            bool ShowWindow(void*, int);\n        ");
        local function v704()
            -- upvalues: l_PartyListAPI_0 (ref)
            return l_PartyListAPI_0.GetPartySessionSetting("game/mmqueue");
        end;
        local function v707(_)
            -- upvalues: v702 (ref), v703 (ref), v18 (ref), v701 (ref)
            if v702 == nil or v703 == nil then
                v702 = utils.opcode_scan("engine.dll", "8B 0D ? ? ? ? 85 C9 74 16 8B 01 8B", 2);
                v18(v702 ~= nil, "raw_HWND signature is NULL");
                v703 = ffi.cast("void**", ffi.cast("char*", ffi.cast("void***", v702)[0][0]) + 8);
            end;
            local v706 = v703[0];
            if ffi.cast("void*", ffi.C.GetForegroundWindow()) ~= v706 then
                ffi.C.ShowWindow(v706, 6);
                ffi.C.ShowWindow(v706, 9);
                ffi.C.SetForegroundWindow(v706);
                ffi.C.SetFocus(v706);
                if v701() then
                    cvar.toggleconsole:call();
                end;
                return true;
            else
                return false;
            end;
        end;
        local function v710()
            -- upvalues: v698 (ref), v704 (ref), v699 (ref), v707 (ref)
            local l_realtime_1 = globals.realtime;
            if l_realtime_1 - v698 >= 1 then
                local v709 = v704();
                if v709 ~= v699 then
                    if v709 == "reserved" then
                        v707(state);
                    end;
                    v699 = v709;
                end;
                v698 = l_realtime_1;
            end;
        end;
        local function v713()
            -- upvalues: v707 (ref)
            local v711 = entity.get_local_player();
            if v711 == nil then
                return;
            else
                local v712 = entity.get_game_rules();
                if v712 == nil then
                    return;
                elseif v712.m_bWarmupPeriod or v711.m_iTeamNum ~= 2 and v711.m_iTeamNum ~= 3 then
                    return;
                else
                    v707(state);
                    return;
                end;
            end;
        end;
        return function(v714)
            -- upvalues: v102 (ref), v710 (ref), v713 (ref), v698 (ref), v699 (ref), v697 (ref)
            if type(v714) == "boolean" then
                v102(events.render, v710, v714);
                v102(events.round_start, v713, v714);
                v698 = 0;
                v699 = nil;
                v697 = v714;
                return;
            else
                return v697;
            end;
        end;
    end;
    v110.unmute_players = function()
        -- upvalues: v102 (ref)
        local v715 = 0;
        local l_GameStateAPI_0 = panorama.GameStateAPI;
        local function v718(v717)
            -- upvalues: v715 (ref)
            if v717 == nil then
                return;
            elseif v717 == entity.get_local_player() then
                return true;
            elseif v715 == 1 and v717:is_enemy() then
                return true;
            elseif v715 == 2 and not v717:is_enemy() then
                return true;
            else
                return v715 ~= 0;
            end;
        end;
        local function v720(v719)
            -- upvalues: l_GameStateAPI_0 (ref)
            if not l_GameStateAPI_0.IsXuidValid(v719) then
                return;
            else
                if l_GameStateAPI_0.HasCommunicationAbuseMute(v719) and l_GameStateAPI_0.IsSelectedPlayerMuted(v719) then
                    l_GameStateAPI_0.ToggleMute(v719);
                end;
                return;
            end;
        end;
        local function v723()
            -- upvalues: v718 (ref), l_GameStateAPI_0 (ref), v720 (ref)
            for v721 = 1, globals.max_players do
                if v718(entity.get(v721)) then
                    local v722 = l_GameStateAPI_0.GetPlayerXuidStringFromEntIndex(v721);
                    v720(v722);
                end;
            end;
        end;
        local function v726(v724)
            -- upvalues: v723 (ref), v718 (ref), l_GameStateAPI_0 (ref), v720 (ref)
            if entity.get_local_player() == entity.get(v724.userid, true) then
                v723();
            elseif v718(entity.get(v724.userid, true)) then
                local v725 = l_GameStateAPI_0.GetPlayerXuidFromUserID(v724.userid);
                v720(v725);
            end;
        end;
        return function(v727)
            -- upvalues: v102 (ref), v726 (ref), v715 (ref), v723 (ref)
            if type(v727) == "number" then
                v102(events.player_connect_full, v726, v727 > 0);
                if v715 ~= v727 then
                    v715 = v727;
                    if v715 > 0 then
                        v723();
                    end;
                end;
                return;
            else
                return v715;
            end;
        end;
    end;
    v110.steal_player_name = function()
        local v728 = nil;
        return function()
            -- upvalues: v728 (ref)
            local v729 = entity.get_local_player();
            if v729 == nil then
                return;
            else
                local v730 = {};
                entity.get_players(false, true, function(v731)
                    -- upvalues: v729 (ref), v730 (ref)
                    if v731:is_enemy() == false and v731 ~= v729 then
                        v730[#v730 + 1] = v731:get_name();
                    end;
                end);
                local v732 = #v730;
                if v732 == 0 then
                    return;
                else
                    local v733 = nil;
                    if v732 > 1 then
                        v733 = v730[utils.random_int(1, v732)];
                        while v728 == v733 do
                            v733 = v730[utils.random_int(1, v732)];
                        end;
                    else
                        v733 = v730[1];
                    end;
                    local v734 = nil;
                    if v728 ~= v733 then
                        common.set_name(v733 .. "\227\133\164");
                        v734 = v733;
                    end;
                    v728 = v733;
                    return v734;
                end;
            end;
        end;
    end;
    v110.cheat_revealer = function()
        -- upvalues: v39 (ref), v102 (ref)
        local v735 = false;
        local v736 = {};
        local function v739()
            -- upvalues: v736 (ref)
            if entity.get_local_player() == nil then
                return;
            else
                entity.get_players(false, true, function(v737)
                    -- upvalues: v736 (ref)
                    local v738 = v737:get_xuid();
                    if v736[v738] then
                        v737:set_icon();
                        v736[v738] = nil;
                    end;
                end);
                return;
            end;
        end;
        local function v746()
            -- upvalues: v39 (ref), v736 (ref)
            local v740 = {};
            entity.get_players(false, true, function(v741)
                -- upvalues: v39 (ref), v740 (ref), v736 (ref)
                local v742 = v741:get_xuid();
                local v743 = v39.get_software(v741);
                v740[v742] = v741;
                if not v743 and v736[v742] then
                    v736[v742] = nil;
                    v741:set_icon();
                end;
                if v743 then
                    local v744 = v39.get_icon(v743.signature);
                    if v744 then
                        v736[v742] = v743;
                        v741:set_icon(v744);
                    end;
                end;
            end);
            for v745 in pairs(v736) do
                if v740[v745] == nil then
                    v736[v745] = nil;
                end;
            end;
        end;
        local function v747()
            -- upvalues: v739 (ref)
            v739();
        end;
        return function(v748)
            -- upvalues: v39 (ref), v102 (ref), v746 (ref), v747 (ref), v735 (ref)
            if type(v748) == "boolean" and v39 ~= nil then
                v102(events.net_update_end, v746, v748);
                v102(events.shutdown, v747, v748);
                if v748 == false and v748 ~= v735 then
                    v747();
                end;
                v735 = v748;
                return;
            else
                return v735;
            end;
        end;
    end;
    v110.shared_logo = function()
        -- upvalues: v102 (ref)
        local v749 = false;
        local v750 = {};
        local v751 = 0;
        local v752 = 1;
        local _ = 2;
        local v754 = {
            SECURITY_KEY = ".ZnVtaW5v|", 
            HASH = 65262, 
            ID = 393317
        };
        local function v758(v755, v756)
            local v757 = bit.bxor(v755, v756);
            return (v757 + bit.lshift(v757, 1) + bit.lshift(v757, 4) + bit.lshift(v757, 7) + bit.lshift(v757, 8) + bit.lshift(v757, 24)) % 4294967296;
        end;
        local function v763(v759)
            -- upvalues: v758 (ref), v754 (ref)
            events.voice_message:call(function(v760)
                -- upvalues: v758 (ref), v754 (ref), v759 (ref)
                local l_server_tick_0 = globals.server_tick;
                local v762 = v758(l_server_tick_0, v754.HASH);
                v760:write_bits(l_server_tick_0, 32);
                v760:write_bits(v762, 32);
                v760:write_bits(v754.ID, 32);
                v760:write_bits(v759 or 1, 4);
                v760:crypt(v754.SECURITY_KEY);
            end);
        end;
        local function v769(v764)
            -- upvalues: v754 (ref), v758 (ref), v750 (ref)
            if type(v764) ~= "userdata" or v764.entity == nil then
                return nil;
            elseif v764.entity == entity.get_local_player() then
                return;
            else
                local l_buffer_0 = v764.buffer;
                l_buffer_0:crypt(v754.SECURITY_KEY);
                local v766 = l_buffer_0:read_bits(32);
                local v767 = l_buffer_0:read_bits(32);
                if l_buffer_0:read_bits(32) ~= v754.ID then
                    return;
                else
                    local v768 = l_buffer_0:read_bits(4);
                    if to_time(globals.server_tick - v766) > 1 or v767 ~= v758(v766, v754.HASH) then
                        return;
                    else
                        v750[v764.entity:get_xuid()] = {
                            signature = v768, 
                            heartbeat = globals.server_tick
                        };
                        return;
                    end;
                end;
            end;
        end;
        local function v778()
            -- upvalues: v751 (ref), v750 (ref), v752 (ref), v763 (ref)
            local l_realtime_2 = globals.realtime;
            local v771 = {};
            local v772 = entity.get_local_player();
            if v772 == nil then
                return;
            else
                if math.abs(l_realtime_2 - v751) > 1 then
                    local v773 = tostring(v772:get_xuid());
                    v751 = l_realtime_2;
                    v750[v773] = {
                        signature = v752, 
                        heartbeat = globals.server_tick
                    };
                    v763(v752);
                end;
                entity.get_players(false, true, function(v774)
                    -- upvalues: v750 (ref), v771 (ref)
                    local v775 = v774:get_xuid();
                    local v776 = v750[v775];
                    v771[v775] = v774;
                    if v776 then
                        if math.abs(to_time(v776.heartbeat - globals.server_tick)) > 2 then
                            v750[v775] = nil;
                            v774:set_icon();
                        else
                            v774:set_icon(string.format("%s", "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/arc.png"));
                        end;
                    end;
                end);
                for v777 in pairs(v750) do
                    if v771[v777] == nil then
                        v750[v777] = nil;
                    end;
                end;
                return;
            end;
        end;
        local function v781()
            -- upvalues: v750 (ref)
            if entity.get_local_player() == nil then
                return;
            else
                entity.get_players(false, true, function(v779)
                    -- upvalues: v750 (ref)
                    local v780 = v779:get_xuid();
                    if v750[v780] then
                        v779:set_icon();
                        v750[v780] = nil;
                    end;
                end);
                return;
            end;
        end;
        return function(v782)
            -- upvalues: v102 (ref), v769 (ref), v778 (ref), v781 (ref), v749 (ref)
            if type(v782) == "boolean" then
                v102(events.voice_message, v769, v782);
                v102(events.net_update_end, v778, v782);
                v102(events.shutdown, v781, v782);
                if v782 == false and v782 ~= v749 then
                    v781();
                end;
                v749 = v782;
                return;
            else
                return v749;
            end;
        end;
    end;
    v110.clan_tag_spammer = function()
        -- upvalues: v1 (ref), v102 (ref)
        local v783 = false;
        local v784 = false;
        local v785 = string.format("%s.lua", v1);
        local v786 = #v785;
        local v787 = "";
        local v788 = "               " .. v785 .. "                      ";
        local v789 = {
            [1] = 0, 
            [2] = 1, 
            [3] = 2, 
            [4] = 3, 
            [5] = 4, 
            [6] = 5, 
            [7] = 6, 
            [8] = 7, 
            [9] = 8, 
            [10] = 9, 
            [11] = 10, 
            [12] = 11, 
            [13] = 12, 
            [14] = 12, 
            [15] = 12, 
            [16] = 12, 
            [17] = 12, 
            [18] = 12, 
            [19] = 12, 
            [20] = 12, 
            [21] = 13, 
            [22] = 14, 
            [23] = 15, 
            [24] = 16, 
            [25] = 17, 
            [26] = 18, 
            [27] = 19, 
            [28] = 20, 
            [29] = 21, 
            [30] = 22, 
            [31] = 23, 
            [32] = 24
        };
        local l_cl_clanid_0 = cvar.cl_clanid;
        local v791 = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag");
        local l_v785_0 = v785;
        local v793 = v786 + 13;
        v789 = {};
        v786 = v793;
        for v794 = 0, v793 do
            if v794 == math.floor(v793 * 0.5) then
                for _ = 1, 8 do
                    v789[#v789 + 1] = v794;
                end;
            else
                v789[#v789 + 1] = v794;
            end;
        end;
        v788 = "               " .. l_v785_0 .. "                      ";
        l_v785_0 = function(_)
            -- upvalues: v786 (ref), v788 (ref), v789 (ref), v787 (ref), v784 (ref)
            local v797 = utils.net_channel();
            local v798 = entity.get_game_rules();
            if v797 == nil or v798 == nil then
                return;
            else
                local v799 = nil;
                if v798.m_timeUntilNextPhaseStarts > 0 then
                    v799 = math.floor(v786 * 0.5) + 1;
                    return common.set_clan_tag(string.sub(v788, v799 + 2, v799 + 16));
                else
                    v799 = (globals.tickcount + to_ticks(v797.avg_latency[0])) / to_ticks(0.3);
                    v799 = v789[math.floor(v799 % #v789) + 1] + 1;
                    local v800 = string.sub(v788, v799 + 2, v799 + 16);
                    if v800 ~= v787 then
                        if v784 == true then
                            local v801 = "";
                            for v802 = 1, #v800 do
                                v801 = v801 .. (utils.random_int(0, 1) == 1 and v800:sub(v802, v802):upper() or v800:sub(v802, v802):lower());
                            end;
                            common.set_clan_tag(v801);
                        else
                            common.set_clan_tag(v800);
                        end;
                    end;
                    v787 = v800;
                    return;
                end;
            end;
        end;
        v793 = function(v803)
            -- upvalues: v791 (ref)
            if v803:get() then
                v791:override(false);
            else
                v791:override();
            end;
        end;
        local function v804()
            -- upvalues: v791 (ref), l_cl_clanid_0 (ref)
            v791:override();
            l_cl_clanid_0:call(l_cl_clanid_0:string());
        end;
        return function(v805)
            -- upvalues: v102 (ref), l_v785_0 (ref), v804 (ref), v791 (ref), v793 (ref), v783 (ref), v787 (ref)
            if type(v805) == "boolean" then
                v102(events.net_update_end, l_v785_0, v805);
                v102(events.shutdown, v804, v805);
                v102(v791, v793, v805, true);
                if v805 ~= v783 then
                    v787 = "";
                    v793(v791);
                end;
                if v805 == false and v805 ~= v783 then
                    v804();
                end;
                v783 = v805;
                return;
            else
                return v783;
            end;
        end;
    end;
    v110.log_events = function()
        -- upvalues: v90 (ref), v13 (ref), v102 (ref)
        local v806 = false;
        local v807 = false;
        local v808 = false;
        local v809 = ui.find("Aimbot", "Ragebot", "Main", "Enabled");
        local v810 = ui.find("Miscellaneous", "Main", "Other", "Log Events");
        local v811 = 0;
        local v812 = {};
        local v813 = {
            knife = "Knifed", 
            inferno = "Burned", 
            hegrenade = "Naded"
        };
        local v814 = {
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
        local function v817(v815)
            -- upvalues: v811 (ref), v812 (ref)
            local v816 = entity.get_local_player();
            if v816 == nil or not v816:is_alive() then
                return;
            else
                v811 = v811 + 1;
                if v811 > 100 then
                    v811 = 1;
                end;
                v812[v811] = {
                    id = v815.id, 
                    target = v815.target, 
                    tick = globals.server_tick
                };
                return;
            end;
        end;
        local function v832(v818)
            -- upvalues: v812 (ref), v807 (ref), v809 (ref), v814 (ref), v90 (ref), v13 (ref)
            local l_server_tick_1 = globals.server_tick;
            for v820, v821 in pairs(v812) do
                if math.abs(to_time(l_server_tick_1 - v821.tick)) > 2 then
                    v812[v820] = nil;
                end;
            end;
            local v822 = nil;
            local l_id_0 = v818.id;
            for _, v825 in pairs(v812) do
                if v825.id == l_id_0 then
                    v822 = v825;
                    break;
                end;
            end;
            if v822 == nil then
                return;
            else
                l_id_0 = v818.target;
                local v826 = nil;
                v826 = l_id_0:get_name();
                if #v826 > 18 then
                    v826 = v826:sub(0, 18) .. "...";
                end;
                if not v807 or not v809:get_override() and not v809:get() then
                    return;
                else
                    local v827 = v814[v818.hitgroup] or "gear";
                    local v828 = v814[v818.wanted_hitgroup] or "gear";
                    if v818.state == nil then
                        local v829 = v827 ~= v828 and string.format("(%s)", v90(v828)) or "";
                        local v830 = v818.damage ~= v818.wanted_damage and string.format("(%s)", v90(v818.wanted_damage)) or "";
                        local v831 = v818.target:is_dormant() and "Dormant hit" or "Hit";
                        v13(string.format("%s \aFF4040FF%s\aDEFAULT in the %s%s for %s%s damage (hc: %s \a888888FF\194\183\aDEFAULT history: %s \a888888FF\194\183\aDEFAULT elapsed: %s)", v831, l_id_0:get_name(), v90(v827), v829, v90(v818.damage), v830, v90(v818.hitchance .. "%"), v90(v818.backtrack .. "t"), v90(l_server_tick_1 - v822.tick - 1 .. "t")), true);
                        print_dev(string.format("%s \aFF4040FF%s\aDEFAULT in the %s for %s damage (hc: %s \a888888FF\194\183\aDEFAULT history: %s)", v831, l_id_0:get_name(), v90(v827), v90(v818.damage), v90(v818.hitchance .. "%"), v90(v818.backtrack .. "t")));
                        return;
                    else
                        v13(string.format("Missed \aFF4040FF%s\aDEFAULT's %s due to \a99FF99FF%s\aDEFAULT (hc: %s \a888888FF\194\183\aDEFAULT history: %s)", l_id_0:get_name(), v90(v828), v818.state == "correction" and "?" or v818.state, v90(v818.hitchance .. "%"), v90(v818.backtrack .. "t")));
                        return;
                    end;
                end;
            end;
        end;
        local function v840(v833)
            -- upvalues: v807 (ref), v814 (ref), v813 (ref), v13 (ref), v90 (ref), v809 (ref)
            if not v807 then
                return;
            else
                local v834 = entity.get(v833.attacker, true);
                local v835 = entity.get(v833.userid, true);
                if v834 ~= entity.get_local_player() then
                    return;
                else
                    local v836 = nil;
                    v836 = v835:get_name();
                    if #v836 > 18 then
                        v836 = v836:sub(0, 18) .. "...";
                    end;
                    local v837 = v835:is_dormant();
                    local v838 = v814[v833.hitgroup] or "gear";
                    if v838 == "generic" and v813[v833.weapon] ~= nil then
                        v13(string.format("%s \aFF4040FF%s\aDEFAULT for %s damage (%s health remaining)", v813[v833.weapon], v836, v90(v833.dmg_health), v90(v833.health)));
                    elseif v837 or not v809:get_override() and not v809:get() then
                        local v839 = v835:is_dormant() and "Dormant hit" or "Hit";
                        v13(string.format("%s \aFF4040FF%s\aDEFAULT in the %s for %s damage (%s health remaining)", v839, v836, v90(v838), v90(v833.dmg_health), v90(v833.health)));
                    end;
                    return;
                end;
            end;
        end;
        local function v844(v841)
            -- upvalues: v808 (ref), v13 (ref), v90 (ref)
            if not v808 or v841.weapon == "weapon_unknown" then
                return;
            else
                local v842 = entity.get(v841.userid, true);
                if not v842:is_enemy() then
                    return;
                else
                    local v843 = nil;
                    v843 = v842:get_name();
                    if #v843 > 18 then
                        v843 = v843:sub(0, 18) .. "...";
                    end;
                    v13(string.format("\aFF4040FF%s\aDEFAULT bought %s", v843, v90(v841.weapon)));
                    return;
                end;
            end;
        end;
        local function v848()
            -- upvalues: v810 (ref), v807 (ref), v808 (ref)
            local v845 = v810:get();
            for v846, v847 in pairs(v845) do
                if v847 == "Damage Dealt" and v807 then
                    v845[v846] = nil;
                end;
                if v847 == "Purchases" and v808 then
                    v845[v846] = nil;
                end;
            end;
            v810:override(v845);
        end;
        local function v849()
            -- upvalues: v810 (ref)
            v810:override();
        end;
        local function v852(v850)
            -- upvalues: v807 (ref), v808 (ref), v806 (ref), v102 (ref), v817 (ref), v832 (ref), v840 (ref), v844 (ref), v849 (ref), v810 (ref), v848 (ref)
            local v851 = v807 or v808;
            if v851 ~= v806 or v850 == true then
                v102(events.aim_fire, v817, v851);
                v102(events.aim_ack, v832, v851);
                v102(events.player_hurt, v840, v851);
                v102(events.item_purchase, v844, v851);
                v102(events.shutdown, v849, v851);
                v102(v810, v848, v851, true);
                if v851 == true then
                    v848();
                else
                    v849();
                end;
            end;
            v806 = v851;
        end;
        local function v855(v853)
            -- upvalues: v807 (ref), v852 (ref)
            if type(v853) == "boolean" then
                local v854 = v853 ~= v807;
                v807 = v853;
                v852(v854);
                return;
            else
                return v807;
            end;
        end;
        local function v858(v856)
            -- upvalues: v808 (ref), v852 (ref)
            if type(v856) == "boolean" then
                local v857 = v856 ~= v808;
                v808 = v856;
                v852(v857);
                return;
            else
                return v808;
            end;
        end;
        return {
            damage_dealt = v855, 
            purchases = v858
        };
    end;
    v110.force_player_animations = function()
        -- upvalues: v116 (ref), v63 (ref), v102 (ref), v18 (ref)
        local v859 = v116();
        local v860 = ffi.typeof("\t\t\tstruct {\n\t\t\t\tchar pad0[0x18];\n\t\t\t\tuint32_t sequence;\n\t\t\t\tfloat prev_cycle;\n\t\t\t\tfloat weight;\n\t\t\t\tfloat weight_delta_rate;\n\t\t\t\tfloat playback_rate;\n\t\t\t\tfloat cycle;\n\t\t\t\tvoid* entity;\n\t\t\t\tchar pad1[0x4];\n\t\t\t}\n\t\t");
        local v861 = false;
        local v862 = false;
        local v863 = false;
        local v864 = 0;
        local v865 = 0;
        local v866 = false;
        local v867 = false;
        local v868 = false;
        local v869 = 2;
        local v870 = false;
        local v871 = 0;
        local v872 = 0;
        local v873 = ui.find("Miscellaneous", "Main", "Movement", "Bunny Hop");
        local v874 = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement");
        local v875 = {};
        local v876 = {};
        for v877 = 0, 12 do
            local v878 = 0;
            v876[v877] = 0;
            v875[v877] = v878;
        end;
        local function v889(v879)
            -- upvalues: v860 (ref), v863 (ref), v873 (ref), v870 (ref), v864 (ref), v63 (ref), v872 (ref), v865 (ref), v874 (ref), v867 (ref), v868 (ref), v869 (ref), v875 (ref), v876 (ref)
            local v880 = entity.get_local_player();
            if v880 ~= v879 then
                return;
            elseif v880:get_anim_state() == nil then
                return;
            else
                local v881 = ffi.cast(ffi.typeof("$ **", v860), ffi.cast("char*", v879[0]) + 10640);
                if v881 == nil then
                    return;
                else
                    local l_m_flPoseParameter_0 = v880.m_flPoseParameter;
                    if v863 then
                        local v883 = v880:get_anim_state();
                        if v883 ~= nil and v883.landing and (not v873:get() or not v870) then
                            l_m_flPoseParameter_0[12] = 0.5;
                        end;
                    end;
                    if v864 > 0 then
                        if v864 == 1 then
                            l_m_flPoseParameter_0[0] = 0.5;
                            l_m_flPoseParameter_0[6] = 0.5;
                        else
                            l_m_flPoseParameter_0[6] = v63(math.clamp(v872, 0.75, 1.5), 0.7, 1.5, 0, 1);
                        end;
                    end;
                    if v865 > 0 then
                        v874:override();
                        if v865 == 1 or v865 == 3 then
                            v874:override("Walking");
                            l_m_flPoseParameter_0[7] = 1;
                        end;
                        if v865 > 1 and bit.band(v880.m_fFlags, 1) ~= 1 then
                            local v884 = v881[0][6];
                            v884.weight = v884.weight == 0 and 1 or v884.weight;
                        end;
                    end;
                    if v867 then
                        v881[0][12].weight = 0;
                    end;
                    if v868 then
                        local v885 = globals.tickinterval * v869;
                        for v886 = 0, 12 do
                            v875[v886] = v885 * v875[v886] + (1 - v885) * l_m_flPoseParameter_0[v886];
                            l_m_flPoseParameter_0[v886] = v875[v886];
                        end;
                        for v887 = 0, 12 do
                            local v888 = v881[0][v887];
                            v876[v887] = v885 * v876[v887] + (1 - v885) * v888.weight;
                            v888.weight = v876[v887];
                        end;
                    end;
                    return;
                end;
            end;
        end;
        local function v891()
            -- upvalues: v872 (ref)
            local v890 = entity.get_local_player();
            if v890 == nil then
                return;
            else
                if bit.band(v890.m_fFlags, 1) == 1 then
                    v872 = 0;
                else
                    v872 = v872 + globals.tickinterval;
                end;
                return;
            end;
        end;
        local function v894(v892)
            -- upvalues: v871 (ref), v866 (ref), v870 (ref)
            local l_m_nTickBase_0 = entity.get_local_player().m_nTickBase;
            if math.abs(l_m_nTickBase_0 - v871) > 64 then
                v871 = 0;
            end;
            if v871 < l_m_nTickBase_0 then
                v871 = l_m_nTickBase_0;
            elseif l_m_nTickBase_0 < v871 and v866 then
                v892.skip_animation_this_tick = true;
            end;
            v870 = v892.in_jump;
        end;
        local function v895()
            -- upvalues: v870 (ref), v872 (ref)
            v870 = false;
            v872 = 0;
        end;
        local function v897()
            -- upvalues: v863 (ref), v866 (ref), v864 (ref), v865 (ref), v867 (ref), v868 (ref), v861 (ref), v102 (ref), v889 (ref), v891 (ref), v894 (ref), v895 (ref)
            local v896 = v863 or v866 or v864 > 0 or not (v865 <= 0) or v867 or v868;
            if v896 ~= v861 then
                v102(events.post_update_clientside_animation, v889, v896);
                v102(events.net_update_end, v891, v896);
                v102(events.createmove, v894, v896);
                v102(events.shutdown, v895, v896);
            end;
            if v896 == false and v896 ~= v861 then
                v895();
            end;
            v861 = v896;
        end;
        local function v899(v898)
            -- upvalues: v863 (ref), v897 (ref)
            if type(v898) == "boolean" then
                v863 = v898;
                v897();
                return;
            else
                return v863;
            end;
        end;
        local function v901(v900)
            -- upvalues: v18 (ref), v864 (ref), v897 (ref)
            if type(v900) == "number" then
                v18(v900 >= 0 and v900 <= 2, "force falling range must be within range [0, 2]");
                v864 = v900;
                v897();
                return;
            else
                return v864;
            end;
        end;
        local function v903(v902)
            -- upvalues: v18 (ref), v865 (ref), v874 (ref), v897 (ref)
            if type(v902) == "number" then
                v18(v902 >= 0 and v902 <= 3, "directional legs range must be within range [0, 3]");
                if v902 == 0 and v902 ~= v865 then
                    v874:override();
                end;
                v865 = v902;
                v897();
                return;
            else
                return v865;
            end;
        end;
        local function v905(v904)
            -- upvalues: v866 (ref), v897 (ref)
            if type(v904) == "boolean" then
                v866 = v904;
                v897();
                return;
            else
                return v866;
            end;
        end;
        local function v907(v906)
            -- upvalues: v867 (ref), v897 (ref)
            if type(v906) == "boolean" then
                v867 = v906;
                v897();
                return;
            else
                return v867;
            end;
        end;
        local function v913(v908, v909)
            -- upvalues: v868 (ref), v869 (ref), v897 (ref)
            local v910 = type(v908);
            local v911 = type(v909);
            if v910 ~= "boolean" and v911 ~= "number" then
                return v868, v869;
            else
                local v912 = false;
                if v910 == "boolean" and v908 ~= v868 then
                    v868 = v908;
                    v912 = true;
                end;
                if v911 == "number" and v909 ~= v869 then
                    v869 = v909;
                    v912 = true;
                end;
                if v912 then
                    v897();
                end;
                return;
            end;
        end;
        local function v914()
            -- upvalues: v862 (ref), v897 (ref), v859 (ref), v914 (ref)
            local v915 = false;
            if v862 ~= v915 then
                v897();
                v859:call({
                    disabled = v915
                });
            end;
            v862 = v915;
            utils.execute_after(0, v914);
        end;
        utils.execute_after(0, v914);
        return {
            callback = v859, 
            landing_pitch = v899, 
            force_falling = v901, 
            directional_legs = v903, 
            preserve_last_animated_tick = v905, 
            disable_move_lean = v907, 
            exp_interpolation = v913
        };
    end;
    v110.visualize_exploits = function()
        -- upvalues: v38 (ref), v102 (ref)
        local v916 = false;
        local v917 = 0.35;
        local v918 = color("FF0000FF");
        local v919 = {
            [1] = {
                [1] = 0, 
                [2] = 1
            }, 
            [2] = {
                [1] = 1, 
                [2] = 2
            }, 
            [3] = {
                [1] = 2, 
                [2] = 3
            }, 
            [4] = {
                [1] = 3, 
                [2] = 0
            }, 
            [5] = {
                [1] = 5, 
                [2] = 6
            }, 
            [6] = {
                [1] = 6, 
                [2] = 7
            }, 
            [7] = {
                [1] = 1, 
                [2] = 4
            }, 
            [8] = {
                [1] = 4, 
                [2] = 8
            }, 
            [9] = {
                [1] = 0, 
                [2] = 4
            }, 
            [10] = {
                [1] = 1, 
                [2] = 5
            }, 
            [11] = {
                [1] = 2, 
                [2] = 6
            }, 
            [12] = {
                [1] = 3, 
                [2] = 7
            }, 
            [13] = {
                [1] = 5, 
                [2] = 8
            }, 
            [14] = {
                [1] = 7, 
                [2] = 8
            }, 
            [15] = {
                [1] = 3, 
                [2] = 4
            }
        };
        local function v931(v920, v921, v922, v923, v924)
            -- upvalues: v919 (ref)
            if v920 == nil or v921 == nil or v922 == nil then
                return;
            else
                if not v923 then
                    v923 = color();
                end;
                if not v924 then
                    v924 = 0.15;
                end;
                local v925 = {
                    [1] = v922[1] + v921, 
                    [2] = v922[2] + v921
                };
                local v926 = {
                    vector(v925[1].x, v925[1].y, v925[1].z), 
                    vector(v925[1].x, v925[2].y, v925[1].z), 
                    vector(v925[2].x, v925[2].y, v925[1].z), 
                    vector(v925[2].x, v925[1].y, v925[1].z), 
                    vector(v925[1].x, v925[1].y, v925[2].z), 
                    vector(v925[1].x, v925[2].y, v925[2].z), 
                    vector(v925[2].x, v925[2].y, v925[2].z), 
                    vector(v925[2].x, v925[1].y, v925[2].z)
                };
                for _, v928 in ipairs(v919) do
                    if v926[v928[1]] ~= nil and v926[v928[2]] ~= nil then
                        local v929 = v926[v928[1]];
                        local v930 = v926[v928[2]];
                        if v929:length2dsqr() > 0 and v930:length2dsqr() > 0 then
                            v920:render(v929, v930, v924, "lgw", v923);
                        end;
                    end;
                end;
                return;
            end;
        end;
        local function v939(v932)
            -- upvalues: v38 (ref), v931 (ref), v918 (ref), v917 (ref)
            local v933 = entity.get_local_player();
            if v933 == nil or v38 == nil then
                return;
            else
                entity.get_players(true, false, function(v934)
                    -- upvalues: v38 (ref), v933 (ref), v931 (ref), v932 (ref), v918 (ref), v917 (ref)
                    if v934:get_bbox().pos1 == nil then
                        return;
                    else
                        local v935 = v38.get_snapshot(v934);
                        if v935 == nil then
                            return;
                        else
                            local l_no_entry_0 = v935.command.no_entry;
                            if l_no_entry_0.y > 0 then
                                local v937 = true;
                                if v933.m_hObserverTarget == v934 and v933.m_iObserverMode == 5 then
                                    v937 = false;
                                end;
                                if v937 then
                                    local l_origin_0 = v935.origin;
                                    v931(v932, l_origin_0.current, l_origin_0.volume, v918, v917 * (l_no_entry_0.x / l_no_entry_0.y));
                                end;
                            end;
                            return;
                        end;
                    end;
                end);
                return;
            end;
        end;
        local function v941(v940)
            return v940:is_enemy();
        end;
        return function(v942, v943, v944)
            -- upvalues: v916 (ref), v918 (ref), v917 (ref), v38 (ref), v102 (ref), v939 (ref), v941 (ref)
            local v945 = type(v942);
            local v946 = type(v943);
            local v947 = type(v944);
            if v945 ~= "boolean" and v946 ~= "number" and v947 ~= "userdata" then
                return v916, v943, v918;
            else
                local v948 = false;
                if v945 == "boolean" and v942 ~= v916 then
                    v916 = v942;
                    v948 = true;
                end;
                if v946 == "number" and v943 ~= v917 then
                    v917 = v943;
                    v948 = true;
                end;
                if v947 == "userdata" and v944 ~= v918 then
                    v918 = v944:clone();
                    v948 = true;
                end;
                if v948 and v38 ~= nil then
                    v102(events.render_glow, v939, v916);
                    if v916 then
                        pcall(v38.set_update_callback, v941);
                    else
                        pcall(v38.unset_update_callback, v941);
                    end;
                end;
                return;
            end;
        end;
    end;
    v110.flashlight = function()
        -- upvalues: v102 (ref)
        local v949 = false;
        local function v952(_)
            local v951 = entity.get_local_player();
            if v951 == nil or v951:is_alive() == false then
                return;
            else
                v951.m_fEffects = bit.bor(v951.m_fEffects, 4);
                return;
            end;
        end;
        return function(v953)
            -- upvalues: v102 (ref), v952 (ref), v949 (ref)
            if type(v953) == "boolean" then
                v102(events.pre_render, v952, v953);
                v949 = v953;
                return;
            else
                return v949;
            end;
        end;
    end;
    v110.hit_marker = function()
        -- upvalues: v102 (ref)
        local v954 = false;
        local v955 = 0;
        local v956 = color(255, 230);
        local function v961(v957, v958, v959, v960)
            v957 = v957 / v960 - 1;
            return v959 * (math.pow(v957, 3) + 1) + v958;
        end;
        local function v967(v962, v963, v964)
            local v965 = color(0, v964.a * 0.5);
            local v966 = v963 * 2;
            render.line(vector(v962.x - v966 - 1, v962.y - v966 - 1), vector(v962.x - (v963 - 1), v962.y - (v963 - 1)), v965);
            render.line(vector(v962.x - v966 - 1, v962.y + v966 + 1), vector(v962.x - (v963 - 1), v962.y + (v963 + 1)), v965);
            render.line(vector(v962.x + v966 + 1, v962.y - v966 - 1), vector(v962.x + (v963 + 1), v962.y - (v963 - 1)), v965);
            render.line(vector(v962.x + v966 + 1, v962.y + v966 + 1), vector(v962.x + (v963 + 1), v962.y + (v963 + 1)), v965);
            render.line(vector(v962.x - v966, v962.y - v966), vector(v962.x - v963, v962.y - v963), v964);
            render.line(vector(v962.x - v966, v962.y + v966), vector(v962.x - v963, v962.y + v963), v964);
            render.line(vector(v962.x + v966, v962.y - v966), vector(v962.x + v963, v962.y - v963), v964);
            render.line(vector(v962.x + v966, v962.y + v966), vector(v962.x + v963, v962.y + v963), v964);
        end;
        local function v971()
            -- upvalues: v955 (ref), v961 (ref), v967 (ref), v956 (ref)
            if not globals.is_in_game then
                return;
            else
                local v968 = globals.realtime - v955;
                if v968 < 0.4 then
                    local v969 = 1 - math.max(0, math.min(1, v968 * 2.5));
                    local v970 = v961(v969, 0, 1, 1);
                    v967(render.screen_size() * 0.5, 5, v956:alpha_modulate(v970, true));
                end;
                return;
            end;
        end;
        local function v976(v972)
            -- upvalues: v955 (ref)
            local v973 = entity.get_local_player();
            if v973 == nil then
                return;
            else
                local v974 = entity.get(v972.userid, true);
                local v975 = entity.get(v972.attacker, true);
                if v975 ~= v973 or v974 == v975 then
                    return;
                else
                    v955 = globals.realtime;
                    return;
                end;
            end;
        end;
        return function(v977)
            -- upvalues: v102 (ref), v971 (ref), v976 (ref), v954 (ref)
            if type(v977) == "boolean" then
                v102(events.render, v971, v977);
                v102(events.player_hurt, v976, v977);
                v102(events.player_blind, v976, v977);
                v954 = v977;
                return;
            else
                return v954;
            end;
        end;
    end;
    v110.keep_scope_transparency = function()
        -- upvalues: v52 (ref), v63 (ref), v102 (ref)
        local v978 = false;
        local v979 = 0;
        local v980 = 0;
        local v981 = 255;
        local v982 = 255;
        local v983 = false;
        local v984 = ui.find("Visuals", "Players", "Self", "Chams", "Model", "Transparency");
        local function v991(v985)
            -- upvalues: v984 (ref), v979 (ref), v983 (ref), v981 (ref), v982 (ref), v52 (ref), v63 (ref), v980 (ref)
            local v986 = entity.get_local_player();
            if v986 == nil then
                return;
            else
                local l_curtime_0 = globals.curtime;
                local v988 = common.is_in_thirdperson();
                local v989 = v986.m_bResumeZoom and v984:get("In Scope") and 59 or v985;
                if v979 - l_curtime_0 > 1 or v983 ~= v988 then
                    v979 = 0;
                    v981 = v989;
                    v982 = v989;
                    v983 = v988;
                    return;
                else
                    if v981 ~= v989 then
                        if v979 - l_curtime_0 >= 0 then
                            v982 = v52(v982, v981, v63(v979 - l_curtime_0, v980, 0, 0, 1, true));
                            v980 = v63(math.abs(v989 - v982), 0, 196, 0, 0.07);
                            v979 = l_curtime_0 + v980;
                        else
                            v980 = v63(math.abs(v989 - v981), 0, 196, 0, 0.07);
                            v979 = l_curtime_0 + v980;
                        end;
                        v981 = v989;
                    end;
                    if v979 - l_curtime_0 >= 0 then
                        return v52(v982, v989, math.map(v979 - l_curtime_0, v980, 0, 0, 1, true));
                    else
                        local l_v989_0 = v989;
                        v980 = 0;
                        v982 = l_v989_0;
                        return v989;
                    end;
                end;
            end;
        end;
        return function(v992)
            -- upvalues: v978 (ref), v102 (ref), v991 (ref)
            if type(v992) == "boolean" then
                if v992 ~= v978 then
                    v102(events.localplayer_transparency, v991, v992);
                    v978 = v992;
                end;
                return;
            else
                return v978;
            end;
        end;
    end;
    v110.inaccuracy_overlay = function()
        -- upvalues: v102 (ref)
        local v993 = false;
        local v994 = 90;
        local v995 = 0;
        local v996 = 0;
        local v997 = math.pi / 180;
        local v998 = 180 / math.pi;
        local v999 = color(0, 160);
        local v1000 = color(0, 0);
        local function v1002(v1001)
            -- upvalues: v994 (ref)
            v994 = v1001.fov;
        end;
        local function v1005()
            -- upvalues: v995 (ref), v996 (ref)
            local v1003 = entity.get_local_player():get_player_weapon();
            if v1003 == nil then
                return;
            else
                local v1004 = v1003:get_spread();
                v996 = v1003:get_inaccuracy();
                v995 = v1004;
                return;
            end;
        end;
        local function v1011()
            -- upvalues: v995 (ref), v996 (ref), v998 (ref), v997 (ref), v994 (ref), v999 (ref), v1000 (ref)
            local v1006 = entity.get_local_player();
            if v1006 == nil or not v1006:is_alive() then
                return;
            elseif v995 <= 0 and v996 <= 0 then
                return;
            else
                local v1007 = render.screen_size();
                local v1008 = (v995 + v996) * v998;
                local v1009 = 1.3333333333333333 / (v1007.x / v1007.y);
                local v1010 = math.tan(v1008 * v997 * 0.5) / math.tan(v994 * v997 * 0.5) * v1007.x * v1009 + 0.5;
                if v1010 > 0 then
                    render.circle_gradient(v1007 * 0.5, v999, v1000, v1010, 0, 1);
                end;
                return;
            end;
        end;
        return function(v1012, v1013, v1014)
            -- upvalues: v993 (ref), v999 (ref), v1000 (ref), v102 (ref), v1002 (ref), v1005 (ref), v1011 (ref)
            local v1015 = type(v1012);
            local v1016 = type(v1013);
            local v1017 = type(v1014);
            if v1015 ~= "boolean" and v1016 ~= "userdata" and v1017 ~= "userdata" then
                return v993, v999, v1000;
            else
                local v1018 = false;
                if v1015 == "boolean" and v1012 ~= v993 then
                    v993 = v1012;
                    v1018 = true;
                end;
                if v1016 == "userdata" and v1013 ~= v999 then
                    v999 = v1013:clone();
                    v1018 = true;
                end;
                if v1017 == "userdata" and v1014 ~= v1000 then
                    v1000 = v1014:clone();
                    v1018 = true;
                end;
                if v1018 then
                    v102(events.override_view, v1002, v993);
                    v102(events.createmove, v1005, v993);
                    v102(events.render, v1011, v993);
                end;
                return;
            end;
        end;
    end;
    v110.grenade_trajectory = function()
        -- upvalues: v102 (ref)
        local v1019 = false;
        local v1020 = nil;
        local v1021 = nil;
        local v1022 = nil;
        local v1023 = vector(-1, 0);
        local v1024 = color(255, 0, 40);
        local v1025 = color(0, 255, 40);
        local v1026 = color(150, 200, 59, 220);
        local v1027 = color(255, 160);
        local v1028 = color(255, 200);
        local v1029 = ui.find("Visuals", "World", "Other", "Grenade Prediction");
        local v1030 = ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color");
        local v1031, v1032 = ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color Hit");
        local function v1033()
            -- upvalues: v1020 (ref), v1030 (ref), v1021 (ref), v1031 (ref), v1032 (ref)
            v1020 = v1030:get();
            v1021 = v1031:get() and v1032:get() or v1020;
        end;
        local function v1035(v1034)
            -- upvalues: v1022 (ref)
            v1022 = {
                tick = globals.tickcount, 
                type = v1034.type, 
                damage = v1034.damage, 
                fatal = v1034.fatal, 
                target = v1034.target, 
                path = v1034.path, 
                collisions = v1034.collisions
            };
            return false;
        end;
        local function v1058()
            -- upvalues: v1022 (ref), v1021 (ref), v1020 (ref), v1023 (ref), v1025 (ref), v1024 (ref), v1027 (ref), v1026 (ref), v1028 (ref)
            if entity.get_local_player() == nil or v1022 == nil then
                return;
            else
                local l_tickcount_0 = globals.tickcount;
                if math.abs(v1022.tick - l_tickcount_0) > 0 or #v1022.path == 0 then
                    v1022 = nil;
                    return;
                else
                    local l_path_0 = v1022.path;
                    local l_damage_0 = v1022.damage;
                    local v1039 = l_damage_0 >= 1 and v1021 or v1020;
                    local v1040 = v1039:alpha_modulate(0.65, true);
                    local v1041 = nil;
                    local v1042 = nil;
                    local v1043 = nil;
                    for _, v1045 in ipairs(l_path_0) do
                        if v1041 ~= nil then
                            local v1046 = v1045:to_screen();
                            if v1043 ~= nil and v1046 ~= nil then
                                if math.floor(v1043.x - v1046.x) == 0 then
                                    render.line(v1043 - v1023, v1046 - v1023, v1040);
                                    render.line(v1043, v1046, v1040);
                                else
                                    render.line(v1043 - v1023, v1046 - v1023, v1039);
                                end;
                            end;
                            v1043 = v1046;
                        end;
                        v1041 = v1045;
                    end;
                    local l_collisions_0 = v1022.collisions;
                    local v1048 = #l_collisions_0;
                    local v1049 = l_damage_0 >= 1 and v1025 or v1024;
                    if #l_path_0 > 1 and v1048 > 0 then
                        for v1050, v1051 in pairs(l_collisions_0) do
                            local v1052 = v1050 == v1048 and v1041.to_screen(v1041) or v1051:to_screen();
                            if v1052 ~= nil then
                                local v1053 = v1052 + vector(-1, 0);
                                if v1048 == v1050 then
                                    v1042 = v1052:clone();
                                end;
                                render.rect(v1053 - 1, v1053 + 5, color(0, 60), 6);
                                render.rect(v1053, v1053 + 4, v1050 == v1048 and v1049 or v1027, 6);
                            end;
                        end;
                    end;
                    if l_damage_0 >= 1 and v1042 ~= nil then
                        local l_type_0 = v1022.type;
                        local v1055 = nil;
                        local v1056 = nil;
                        local v1057 = nil;
                        if l_type_0 == "Frag" then
                            v1055 = string.format("%d dmg", l_damage_0);
                            v1057 = v1022.fatal or l_damage_0 > 50;
                        end;
                        if l_type_0 == "Molly" then
                            v1055 = string.format("%.1f ft", l_damage_0 / 12);
                            v1057 = l_damage_0 / 12 < 12.5;
                        end;
                        if l_type_0 == "Flash" then
                            v1055 = string.format("%d%%", l_damage_0);
                        end;
                        if v1055 ~= nil then
                            v1056 = render.measure_text(1, "d", v1055);
                            render.text(1, v1042 - vector(0, v1056.y - 2), v1057 and v1026 or v1028, "c", v1055);
                        end;
                    end;
                    return;
                end;
            end;
        end;
        return function(v1059)
            -- upvalues: v1019 (ref), v102 (ref), v1058 (ref), v1035 (ref), v1029 (ref), v1033 (ref), v1031 (ref), v1030 (ref), v1032 (ref)
            if type(v1059) == "boolean" then
                if v1059 ~= v1019 then
                    v1019 = v1059;
                    v102(events.render_ingame, v1058, v1059);
                    v102(events.grenade_prediction, v1035, v1059);
                    v102(v1029, v1033, v1059);
                    v102(v1031, v1033, v1059);
                    v102(v1030, v1033, v1059);
                    v102(v1032, v1033, v1059);
                    v1033();
                end;
                return;
            else
                return v1019;
            end;
        end;
    end;
    v110.grenade_warning = function()
        -- upvalues: v63 (ref), v102 (ref)
        local v1060 = false;
        local v1061 = nil;
        local v1062 = {};
        local l_mp_friendlyfire_1 = cvar.mp_friendlyfire;
        local v1064 = render.load_image_from_file("materials/panorama/images/icons/equipment/hegrenade.svg");
        local v1065 = render.load_image_from_file("materials/panorama/images/icons/equipment/inferno.svg");
        local v1066 = render.load_font("Verdana Bold", vector(10, 11.6), "a");
        local v1067 = color("BE0000FF");
        local v1068 = color("000000D2");
        local v1069 = color("323232BE");
        local v1070 = color("FFFFFFC8");
        local v1071 = ffi.typeof("struct { float m[4][4]; }");
        local l_m_0 = utils.get_vfunc("engine.dll", "VEngineClient014", 37, "$& (__thiscall*)(void*)", v1071)().m;
        local function v1079(v1073, v1074)
            -- upvalues: l_m_0 (ref)
            local v1075 = vector(l_m_0[0][0] * v1073.x + l_m_0[0][1] * v1073.y + l_m_0[0][2] * v1073.z + l_m_0[0][3], l_m_0[1][0] * v1073.x + l_m_0[1][1] * v1073.y + l_m_0[1][2] * v1073.z + l_m_0[1][3]);
            local v1076 = l_m_0[3][0] * v1073.x + l_m_0[3][1] * v1073.y + l_m_0[3][2] * v1073.z + l_m_0[3][3];
            local v1077 = false;
            if v1076 < 0.001 then
                v1077 = true;
                v1075 = v1075 * -(1 / v1076);
            else
                v1077 = false;
                v1075 = v1075 * (1 / v1076);
            end;
            local v1078 = 0.5 * v1075 * v1074;
            v1075.x = v1074.x * 0.5 + v1078.x;
            v1075.y = v1074.y * 0.5 - v1078.y;
            return v1075, v1077;
        end;
        local function v1085(v1080, v1081, v1082, v1083)
            if not v1082 then
                v1082 = 50;
            end;
            local v1084 = v1080 - v1082;
            if v1083 == false then
                return v1080 - v1082;
            else
                if v1082 <= v1080 - v1082 then
                    if v1082 <= v1081 then
                        if v1084 < v1081 then
                            v1084 = v1080 - v1082;
                        else
                            v1084 = v1081;
                        end;
                    else
                        v1084 = v1082;
                    end;
                else
                    v1084 = v1080 - v1082;
                end;
                return v1084;
            end;
        end;
        local function v1091(v1086)
            -- upvalues: v1079 (ref), v1085 (ref)
            local v1087 = 50;
            local v1088 = render.screen_size();
            local v1089, v1090 = v1079(v1086, v1088);
            return vector(v1085(v1088.x, v1089.x, v1087), v1085(v1088.y, v1089.y, v1087, not v1090));
        end;
        local function v1094(v1092)
            -- upvalues: v63 (ref)
            local v1093 = nil;
            v1093 = math.clamp(v1092, 36, 200);
            v1093 = math.ceil(50 - (v1093 - 36) * 20 / 164);
            return (v63(v1093, 30, 50, 0, 1));
        end;
        local function v1096()
            local v1095 = entity.get_local_player();
            if v1095 == nil then
                return;
            else
                return v1095:is_alive() and v1095:get_origin() or render.camera_position();
            end;
        end;
        local function v1107(v1097, v1098, v1099, v1100, v1101, v1102, v1103)
            -- upvalues: v63 (ref), v1070 (ref), v1066 (ref)
            local v1104 = v63(v1101, 0, 1, 30, 50, true);
            local v1105 = vector(v1102.width, v1102.height);
            local v1106 = v1097 - v1105 * 0.5 - vector(0, 11);
            render.circle_gradient(v1097, v1098, v1098:lerp(v1099, 1), v1104, 0, 1);
            render.circle_outline(v1097, v1070, v1104 - 0.5, 0, v1100, 2);
            render.texture(v1102, v1106, v1105, v1070);
            render.text(v1066, v1097 + vector(0, 15), v1070, "cs", v1103);
        end;
        local function v1110(v1108)
            -- upvalues: l_mp_friendlyfire_1 (ref)
            if v1108 == nil then
                return true;
            else
                local v1109 = v1108:is_enemy();
                if v1109 or v1108 == entity.get_local_player() then
                    return true;
                elseif not v1109 and l_mp_friendlyfire_1:int() == 1 then
                    return true;
                else
                    return false;
                end;
            end;
        end;
        local function v1112(v1111)
            -- upvalues: v1062 (ref)
            v1062[v1111.entity:get_index()] = {
                tick = globals.tickcount, 
                entity = v1111.entity, 
                origin = v1111.origin, 
                closest_point = v1111.closest_point, 
                type = v1111.type, 
                damage = v1111.damage, 
                expire_time = v1111.expire_time, 
                icon = v1111.icon, 
                path = v1111.path
            };
            return false;
        end;
        local function v1115()
            -- upvalues: v1061 (ref)
            local v1113 = entity.get_local_player();
            if v1113 == nil then
                return;
            else
                local v1114 = v1113:simulate_movement();
                v1114:think(to_ticks(0.2));
                v1061 = v1114.origin:clone();
                return;
            end;
        end;
        local function v1117(v1116)
            return v1116[0];
        end;
        local function v1152()
            -- upvalues: v1096 (ref), v1061 (ref), v1062 (ref), v1117 (ref), v1091 (ref), v1094 (ref), v1068 (ref), v1069 (ref), v1067 (ref), v63 (ref), v1107 (ref), v1064 (ref), v1065 (ref), v1110 (ref)
            local v1118 = entity.get_local_player();
            if v1118 == nil then
                return;
            else
                local l_tickcount_1 = globals.tickcount;
                local l_m_iHealth_0 = v1118.m_iHealth;
                local v1121 = v1096();
                if not v1118:is_alive() then
                    v1061 = v1121;
                end;
                local v1122 = v1061 or v1121;
                for v1123, v1124 in pairs(v1062) do
                    if math.abs(v1124.tick - l_tickcount_1) > 1 or not pcall(v1117, v1124.entity) then
                        v1062[v1123] = nil;
                    elseif #v1124.path > 0 then
                        local v1125 = v1124.path[#v1124.path];
                        if v1125 ~= nil then
                            local v1126 = v1122:dist(v1125);
                            local v1127 = v1121:dist(v1125);
                            local v1128 = v1091(v1125);
                            if v1128 ~= nil then
                                local v1129 = v1094(v1126);
                                if v1124.type == "Frag" and (v1124.damage > 0 or v1126 < 350 or v1127 < 350) then
                                    local v1130 = (v1124.expire_time - globals.curtime) / 1.5;
                                    local v1131 = math.clamp(v1124.damage / math.min(50, l_m_iHealth_0), 0, 1);
                                    local v1132 = nil;
                                    local v1133 = v1124.damage >= 1 and v1131 or 0;
                                    if v1133 < 0.01 then
                                        v1132 = v1068;
                                    else
                                        v1132 = v1069:lerp(v1067, v63(v1133, 0, 0.5, 0, 1, true));
                                    end;
                                    v1107(v1128, v1068, v1132, v1130, v1129, v1064, string.format("%d", v1124.damage), 1);
                                end;
                                if v1124.type == "Molly" then
                                    local v1134 = v1127 / 12;
                                    if v1134 <= 34 then
                                        local v1135 = ffi.cast("float*", ffi.cast("uint32_t", v1124.entity[0]) + 728)[0];
                                        local v1136 = v63(globals.curtime, v1135, v1124.expire_time, 1, 0, true);
                                        local v1137 = v1134 <= 12.5 and v1067 or v1068;
                                        v1107(v1128, v1068, v1137, v1136, v1129, v1065, string.format("%d", v1134), 1);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                entity.get_entities("CInferno", false, function(v1138)
                    -- upvalues: v1110 (ref), v1091 (ref), v1121 (ref), v1094 (ref), v1067 (ref), v1068 (ref), v1107 (ref), v1065 (ref)
                    if not v1110(v1138.m_hOwnerEntity) then
                        return;
                    else
                        local v1139 = v1138:get_origin();
                        local v1140 = v1091(v1139);
                        if v1140 == nil or v1138.m_nFireEffectTickBegin == nil then
                            return;
                        else
                            local v1141 = v1121:dist(v1139) / 12;
                            local v1142 = to_time(v1138.m_nFireEffectTickBegin);
                            local v1143 = (7 - math.clamp(globals.curtime - v1142, 0, 7)) / 7;
                            local v1144 = v1121:dist(v1139);
                            local l_v1139_0 = v1139;
                            for v1146 = 1, v1138.m_fireCount do
                                local v1147 = v1139 + vector(v1138.m_fireXDelta[v1146], v1138.m_fireYDelta[v1146], v1138.m_fireZDelta[v1146]);
                                local v1148 = v1121:dist(v1147);
                                if v1148 <= v1144 then
                                    v1144 = v1148;
                                    l_v1139_0 = v1147;
                                end;
                            end;
                            if l_v1139_0 ~= nil then
                                local v1149 = v1144 / 12;
                                if v1141 <= 34 then
                                    local v1150 = v1094(v1144);
                                    local v1151 = v1149 <= 12.5 and v1067 or v1068;
                                    v1107(v1140, v1068, v1151, v1143, v1150, v1065, string.format("%d", v1144 / 12), 1);
                                end;
                            end;
                            return;
                        end;
                    end;
                end);
                return;
            end;
        end;
        return function(v1153)
            -- upvalues: v102 (ref), v1152 (ref), v1115 (ref), v1112 (ref), v1060 (ref)
            if type(v1153) == "boolean" then
                v102(events.render, v1152, v1153);
                v102(events.createmove, v1115, v1153);
                v102(events.grenade_warning, v1112, v1153);
                v1060 = v1153;
                return;
            else
                return v1060;
            end;
        end;
    end;
    v110.watermark = function()
        -- upvalues: v2 (ref), v0 (ref), v102 (ref)
        local v1154 = false;
        local v1155 = false;
        local v1156 = 4;
        local v1157 = render.load_font("Verdana", vector(11.86, 13.5, 1), "a");
        local v1158 = color(7, 11, 20, 80);
        local v1159 = color(25, 32, 60, 50);
        local v1160 = color(155, 175, 190, 255);
        local function v1169()
            -- upvalues: v2 (ref), v0 (ref), v1155 (ref), v1159 (ref), v1157 (ref), v1156 (ref), v1158 (ref), v1160 (ref)
            local v1161 = ui.get_style("Link Active");
            local v1162 = string.format("\a%s%s\aDEFAULT  %s", v1161:to_hex(), ui.get_icon(v2), v0);
            if v1155 then
                v1162 = v1162 .. string.format(" \a%s|\aDEFAULT %s", v1159:to_hex(), common.get_username());
            end;
            local v1163 = render.measure_text(v1157, nil, v1162);
            local v1164 = vector(4, 2);
            local v1165 = vector(11, 11);
            local v1166 = nil;
            local v1167 = render.screen_size();
            if v1156 == 1 then
                v1166 = v1165 - vector(0, 3);
            elseif v1156 == 2 then
                v1166 = vector(v1167.x - v1165.x - v1163.x, v1165.y - 2);
            elseif v1156 == 3 then
                v1166 = vector(v1165.x, v1167.y - v1165.y - v1163.y + 2);
            else
                v1166 = vector(v1167.x - v1165.x - v1163.x, v1167.y - v1165.y - v1163.y + 2);
            end;
            v1167 = v1166 - v1164 - vector(2, 0);
            local v1168 = v1166 + v1163 + v1164 + 1 + vector(0, 2);
            render.rect(v1167, v1168, v1158, 7);
            render.rect_outline(v1167, v1168, v1159, 1, 7);
            render.text(v1157, v1166, v1160, nil, v1162);
        end;
        return function(v1170, v1171, v1172)
            -- upvalues: v1154 (ref), v1156 (ref), v1155 (ref), v102 (ref), v1169 (ref)
            local v1173 = type(v1170);
            local v1174 = type(v1171);
            local v1175 = type(v1172);
            if v1173 ~= "boolean" and v1174 ~= "number" and v1175 ~= "boolean" then
                return v1154, v1156, v1155;
            else
                local v1176 = false;
                if v1173 == "boolean" and v1170 ~= v1154 then
                    v1154 = v1170;
                    v1176 = true;
                end;
                if v1174 == "number" and v1171 ~= v1156 then
                    v1156 = v1171;
                    v1176 = true;
                end;
                if v1175 == "boolean" and v1172 ~= v1155 then
                    v1155 = v1172;
                    v1176 = true;
                end;
                if v1176 then
                    v102(events.render, v1169, v1154 and not _DISABLE_UI_EVENTS, true);
                end;
                return;
            end;
        end;
    end;
    v110.network_metrics = function()
        -- upvalues: v63 (ref), v82 (ref), v2 (ref), v0 (ref), v102 (ref)
        local v1177 = false;
        local v1178 = false;
        local v1179 = false;
        local v1180 = false;
        local v1181 = false;
        local v1182 = render.load_font("Verdana", vector(11.86, 13.5, 1), "a");
        local v1183 = render.load_font("Verdana", vector(11.86, 13.5), "a");
        local l_realtime_3 = globals.realtime;
        local l_cl_updaterate_0 = cvar.cl_updaterate;
        local v1186 = 1;
        local v1187 = {};
        local v1188 = 0;
        local v1189 = 0;
        local v1190 = 0;
        local v1191 = 0;
        local v1192 = 0;
        local v1193 = 0;
        local v1194 = 0;
        local v1195 = {};
        local v1196 = "";
        local v1197 = vector();
        local v1198 = "";
        local v1199 = vector();
        local v1200 = color(7, 11, 20, 80);
        local v1201 = color(25, 32, 60, 50);
        local v1202 = color(155, 175, 190, 255);
        ffi.cdef("int EnumDisplaySettingsA(unsigned int, unsigned long, void*);");
        local v1203 = ffi.typeof("            struct {\n                unsigned char dmDeviceName[32];\n                unsigned short dmSpecVersion;\n                unsigned short dmDriverVersion;\n                unsigned short dmSize;\n                unsigned short dmDriverExtra;\n                unsigned long dmFields;\n                char pad_0[16];\n                short dmColor;\n                short dmDuplex;\n                short dmYResolution;\n                short dmTTOption;\n                short dmCollate;\n                unsigned char dmFormName[32];\n                unsigned short dmLogPixels;\n                unsigned long dmBitsPerPel;\n                unsigned long dmPelsWidth;\n                unsigned long dmPelsHeight;\n                union {\n                    unsigned long dmDisplayFlags;\n                    unsigned long dmNup;\n                } flags;\n                unsigned long dmDisplayFrequency;\n            }\n        ")();
        local function v1206(v1204, v1205)
            return v1205 < v1204;
        end;
        local function v1213(v1207, v1208)
            local v1209 = #v1207;
            local v1210 = math.clamp(v1209 * v1208, 1, v1209);
            if v1210 > 0 then
                local v1211 = 0;
                for v1212 = 1, v1210 do
                    if v1207[v1212] ~= nil then
                        v1211 = v1211 + math.floor(1 / v1207[v1212]);
                    else
                        v1210 = math.max(0, v1210 - 1);
                    end;
                end;
                return math.min(v1211 / v1210, 999);
            else
                return 0;
            end;
        end;
        local function v1218()
            -- upvalues: v1186 (ref), l_realtime_3 (ref), v1187 (ref), v1206 (ref), v1188 (ref), v1189 (ref), v1213 (ref)
            local l_realtime_4 = globals.realtime;
            local l_exactframetime_0 = globals.exactframetime;
            local v1216 = math.floor(1 / l_exactframetime_0);
            v1186 = 0.9 * v1186 + 0.09999999999999998 * v1216;
            if l_realtime_4 - l_realtime_3 >= 1 then
                table.sort(v1187, v1206);
                v1188 = math.floor(v1186);
                v1189 = v1213(v1187, 0.02);
                local l_l_realtime_4_0 = l_realtime_4;
                v1187 = {};
                l_realtime_3 = l_l_realtime_4_0;
                return;
            else
                v1187[#v1187 + 1] = l_exactframetime_0;
                return;
            end;
        end;
        local function v1224(v1219, v1220, v1221, v1222)
            -- upvalues: v63 (ref)
            local v1223 = v1219 - v1220;
            return v1223 < v1221 and 1 or v63(v1223, v1221, v1222, 1, 0, true);
        end;
        local function v1237()
            -- upvalues: v1194 (ref), v1195 (ref), v1203 (ref), l_cl_updaterate_0 (ref), v1188 (ref), v1189 (ref)
            local l_realtime_5 = globals.realtime;
            if l_realtime_5 - v1194 <= 0.05 then
                return v1195, false;
            else
                local v1226 = utils.net_channel();
                local v1227 = ffi.C.EnumDisplaySettingsA(0, -1, v1203);
                local v1228 = nil;
                local v1229 = nil;
                local v1230 = nil;
                local v1231 = nil;
                local v1232 = nil;
                local v1233 = nil;
                if v1226 ~= nil then
                    local v1234 = l_cl_updaterate_0:float();
                    local v1235 = v1226:get_server_info();
                    if v1235 ~= nil then
                        v1232 = v1235.frame_time;
                        v1233 = v1235.deviation;
                    end;
                    v1231 = v1226.is_timing_out;
                    v1230 = v1226.avg_latency[1];
                    if v1234 > 0.001 then
                        v1230 = v1230 + -0.5 / v1234;
                    end;
                    v1228 = v1226.loss[0] * 100;
                    v1229 = v1226.choke[0] * 100;
                    v1230 = math.max(0, v1230 * 1000);
                end;
                local l_l_realtime_5_0 = l_realtime_5;
                v1195 = {
                    loss = v1228, 
                    choke = v1229, 
                    latency_avg = v1230, 
                    latency_ticks = globals.clock_offset, 
                    server_frametime = v1232, 
                    server_deviation = v1233, 
                    fps_average = v1188, 
                    fps_low = v1189, 
                    monitor_frequency = v1227 and v1203.dmDisplayFrequency or 999
                };
                v1194 = l_l_realtime_5_0;
                return v1195, true;
            end;
        end;
        local function v1254()
            -- upvalues: v1237 (ref), v1196 (ref), v1197 (ref), v1198 (ref), v82 (ref), v2 (ref), v0 (ref), v1199 (ref), v1183 (ref), v1178 (ref), v1191 (ref), v1190 (ref), v1181 (ref), v1224 (ref), v1202 (ref), v1179 (ref), v1192 (ref), v1180 (ref), v1193 (ref), v1182 (ref), v1200 (ref), v1201 (ref)
            local v1238, v1239 = v1237();
            if v1239 then
                local v1240 = ui.get_style("Link Active");
                local v1241 = 1 / globals.tickinterval;
                local l_realtime_6 = globals.realtime;
                v1196 = "";
                v1197 = vector();
                v1198 = v82(v2, v0 .. " Metrics", 2, 6);
                v1199 = render.measure_text(v1183, nil, v1198);
                if v1178 then
                    local v1243 = nil;
                    local v1244 = nil;
                    v1191 = v1238.fps_average < v1241 and l_realtime_6 or v1191;
                    v1190 = v1238.fps_low < v1241 and l_realtime_6 or v1190;
                    if v1181 and v1238.fps_low < v1238.monitor_frequency then
                        v1190 = l_realtime_6;
                    end;
                    local v1245 = v1224(l_realtime_6, v1191, 1, 1.35);
                    v1244 = v1224(l_realtime_6, v1190, 1, 1.35);
                    v1243 = v1245;
                    v1245 = "\a" .. v1202:lerp(v1240, math.max(v1243, v1244)):to_hex();
                    v1196 = v82("chart-line", string.format("fps: %s%d\aDEFAULT (99%%: %s%d\aDEFAULT)", "\a" .. v1202:lerp(v1240, v1243):to_hex(), v1238.fps_average, "\a" .. v1202:lerp(v1240, v1244):to_hex(), v1238.fps_low), 2, 6, nil, v1245);
                end;
                if v1238.latency_avg ~= nil then
                    if v1179 then
                        local v1246 = nil;
                        v1192 = (not (v1238.loss <= 0) or v1238.choke > 0) and l_realtime_6 or v1192;
                        v1246 = v1224(l_realtime_6, v1192, 1, 1.35);
                        local v1247 = "\a" .. v1202:lerp(v1240, v1246):to_hex();
                        v1196 = v1196 .. (v1196 ~= "" and "\n" or "") .. v82("server", string.format("ping: %dms (%d ticks)  %sloss: %d%% (%d%%)", v1238.latency_avg, v1238.latency_ticks, v1247, v1238.loss, v1238.choke), 2, 7, nil, v1247);
                    end;
                    if v1180 then
                        local v1248 = nil;
                        v1193 = v1238.server_frametime > v1241 + 1.0E-4 and l_realtime_6 or v1193;
                        v1248 = v1224(l_realtime_6, v1193, 1, 1.35);
                        local v1249 = "\a" .. v1202:lerp(v1240, v1248):to_hex();
                        v1196 = v1196 .. (v1196 ~= "" and "\n" or "") .. v82("circle-exclamation", string.format("server: %s%.1f +- %.1fms (%.3f ms)\aDEFAULT  rate: %.1f tps", v1249, v1238.server_frametime, v1238.server_deviation, v1238.server_deviation, v1241), 2, 7, nil, v1249);
                    end;
                end;
                v1197 = render.measure_text(v1182, nil, v1196);
            end;
            if v1196 == "" then
                return;
            else
                local v1250 = nil;
                v1250 = render.screen_size();
                v1250.x = v1250.x * 0.59765;
                v1250.y = v1250.y - v1197.y - 48;
                local v1251 = 6.5;
                local v1252 = v1250 - v1251;
                local v1253 = v1250 + v1197 + v1251 + 2 + vector(0, 2);
                render.text(v1183, v1252 - vector(-v1251, v1199.y + v1251 * 0.75), v1202:alpha_modulate(0.85, true), nil, v1198);
                render.rect(v1252, v1253, v1200, 7);
                render.rect_outline(v1252, v1253, v1201, 1, 7);
                render.text(v1182, v1250, v1202, nil, v1196);
                return;
            end;
        end;
        local function v1255()
            -- upvalues: v1177 (ref), v1178 (ref), v1179 (ref), v1180 (ref), v102 (ref), v1218 (ref), v1254 (ref)
            v1177 = v1178 or v1179 or v1180;
            v102(events.post_render, v1218, v1177);
            v102(events.render, v1254, v1177, true);
        end;
        return function(v1256, v1257, v1258, v1259)
            -- upvalues: v1178 (ref), v1179 (ref), v1180 (ref), v1181 (ref), v1255 (ref)
            local v1260 = type(v1256);
            local v1261 = type(v1257);
            local v1262 = type(v1258);
            local v1263 = type(v1259);
            if v1260 ~= "boolean" and v1261 ~= "boolean" and v1262 ~= "boolean" and v1263 ~= "boolean" then
                return v1178, v1179, v1180, v1181;
            else
                local v1264 = false;
                if v1260 == "boolean" and v1256 ~= v1178 then
                    v1178 = v1256;
                    v1264 = true;
                end;
                if v1261 == "boolean" and v1257 ~= v1179 then
                    v1179 = v1257;
                    v1264 = true;
                end;
                if v1262 == "boolean" and v1258 ~= v1180 then
                    v1180 = v1258;
                    v1264 = true;
                end;
                if v1263 == "boolean" and v1259 ~= v1181 then
                    v1181 = v1259;
                    v1264 = true;
                end;
                if v1264 then
                    v1255();
                end;
                return;
            end;
        end;
    end;
    v110.screen_indicators = function()
        -- upvalues: v102 (ref)
        local v1265 = {};
        local v1266 = {
            [1] = "Aimbot Statistics", 
            [2] = "Ping Spike", 
            [3] = "Fake Duck", 
            [4] = "Hide Shots", 
            [5] = "Double Tap", 
            [6] = "Safe Point", 
            [7] = "Body Aim", 
            [8] = "Minimum Damage", 
            [9] = "Hit Chance Override", 
            [10] = "Dormant Aimbot", 
            [11] = "Freestanding", 
            [12] = "Defusing", 
            [13] = "Bomb Information"
        };
        local v1267 = ui.find("Miscellaneous", "Main", "Other", "Fake Latency");
        local v1268 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
        local v1269 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
        local v1270 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
        local v1271 = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points");
        local v1272 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim");
        local v1273 = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers");
        local v1274 = ui.find("Aimbot", "Ragebot", "Main", "Enabled");
        local v1275 = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot");
        local v1276 = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding");
        local v1277 = 0;
        local v1278 = 0;
        local v1279 = nil;
        local v1280 = nil;
        local v1281 = nil;
        local v1282 = 3.125;
        local v1283 = bit.lshift(1, 6);
        local function v1289(v1284, v1285)
            local v1286 = 0.5;
            local v1287 = 0.5;
            if v1285 > 0 then
                local v1288 = v1284 * v1286;
                if v1285 < (v1284 - v1288) * v1287 then
                    v1288 = v1284 - v1285 * (1 / v1287);
                end;
                v1284 = v1288;
            end;
            return v1284;
        end;
        local v1290 = render.load_font("Calibri Bold", vector(25, 23.5), "da");
        local v1291 = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(32, 32));
        local v1292 = {};
        local function v1297(v1293, v1294, v1295, v1296)
            -- upvalues: v1292 (ref)
            v1292[#v1292 + 1] = {
                clr = v1293, 
                text = v1294, 
                pct = v1295 or -1, 
                icon = v1296
            };
        end;
        local function v1347()
            -- upvalues: v1270 (ref), v1265 (ref), v1277 (ref), v1278 (ref), v1297 (ref), v1267 (ref), v1268 (ref), v1283 (ref), v1269 (ref), v1271 (ref), v1272 (ref), v1273 (ref), v1274 (ref), v1275 (ref), v1276 (ref), v1281 (ref), v1280 (ref), v1282 (ref), v1279 (ref), v1291 (ref), v1289 (ref), v1292 (ref), v1290 (ref)
            local v1298 = entity.get_local_player();
            if v1298 == nil then
                return;
            else
                local v1299 = v1298:is_alive();
                local v1300 = false;
                local v1301 = v1270:get_override() or v1270:get();
                for _, v1303 in ipairs(v1265) do
                    if v1303 == "Aimbot Statistics" then
                        local v1304 = math.clamp(v1277 / (v1277 + v1278), 0, 1);
                        if v1304 > 0 then
                            v1297(color(255, 200), string.format("%d%%", v1304 * 100));
                        end;
                    end;
                    if v1303 == "Ping Spike" and v1299 then
                        local v1305 = utils.net_channel();
                        local v1306 = v1267:get_override() or v1267:get();
                        if v1305 ~= nil and v1306 > 0 then
                            local v1307 = v1305.latency[0] + v1305.latency[1];
                            local v1308 = v1305.avg_latency[0];
                            local v1309 = v1305.avg_latency[1];
                            local v1310 = math.clamp(v1307 / math.min(math.max(v1309 - v1306 * -0.001 + v1308, 0.001), 0.2), 0, 1);
                            local v1311 = nil;
                            if v1310 >= 0.5 then
                                v1311 = color(213, 197, 84, 255):lerp(color(145, 195, 25, 255), (v1310 - 0.5) * 2);
                            else
                                v1311 = color(250, 234, 232, 255):lerp(color(213, 197, 84, 255), v1310 * 2);
                            end;
                            v1297(v1311, "PING");
                        end;
                    end;
                    if v1303 == "Fake Duck" and v1299 then
                        local v1312 = v1268:get_override() or v1268:get();
                        local v1313 = bit.band(v1298.m_fFlags, v1283) == v1283 or entity.get_game_rules().m_bFreezePeriod == true;
                        if v1312 and v1313 == false then
                            v1300 = true;
                            v1297(color(255, 200), "DUCK");
                        end;
                    end;
                    if v1303 == "Hide Shots" and v1299 and not v1300 and not v1301 and (v1269:get_override() or v1269:get()) then
                        v1297(color(255, 200), "OSAA");
                    end;
                    if v1303 == "Double Tap" and v1299 and not v1300 and v1301 then
                        v1297(rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 40, 200), "DT");
                    end;
                    if v1303 == "Safe Point" and v1299 and (v1271:get_override() == "Force" or v1271:get() == "Force") then
                        v1297(color(255, 200), "SAFE");
                    end;
                    if v1303 == "Body Aim" and v1299 and (v1272:get_override() == "Force" or v1272:get() == "Force") and #v1273:get() == 0 then
                        v1297(color(255, 200), "BODY");
                    end;
                    if v1303 == "Minimum Damage" and v1299 then
                        for _, v1315 in ipairs(ui.get_binds()) do
                            if v1315.name == "Min. Damage" and v1315.active then
                                v1297(color(255, 200), "MD");
                                break;
                            end;
                        end;
                    end;
                    if v1303 == "Hit Chance Override" and v1299 then
                        for _, v1317 in ipairs(ui.get_binds()) do
                            if v1317.name == "Hit Chance" and v1317.active then
                                v1297(color(255, 200), "HC");
                                break;
                            end;
                        end;
                    end;
                    if v1303 == "Dormant Aimbot" and (v1274:get_override() or v1274:get()) and (v1275:get_override() or v1275:get()) then
                        v1297(color(255, 200), "DA");
                    end;
                    if v1303 == "Freestanding" and v1299 and (v1276:get_override() or v1276:get()) then
                        v1297((not not rage.antiaim:get_target(true) or entity.get_threat(true)) and color(255, 200) or color(255, 0, 0, 200), "FS");
                    end;
                    if v1303 == "Defusing" then
                        local v1318 = entity.get_entities(129)[1];
                        if v1318 ~= nil and v1318.m_hBombDefuser ~= nil then
                            local v1319 = 1 - (10 - (v1318.m_flDefuseCountDown - globals.curtime)) * 0.1;
                            if v1319 > 0 and v1319 < 1 then
                                local v1320 = color(252, 243, 105, 255);
                                if v1318.m_flDefuseCountDown - globals.curtime > v1318.m_flC4Blow - globals.curtime then
                                    v1320 = color(255, 0, 0);
                                end;
                                v1297(v1320, "DEF", v1319);
                            end;
                        end;
                    end;
                    if v1303 == "Bomb Information" then
                        local l_curtime_1 = globals.curtime;
                        do
                            local l_l_curtime_1_0 = l_curtime_1;
                            if v1281 ~= nil then
                                local v1323 = (l_l_curtime_1_0 - v1280) / v1282;
                                if v1323 > 0 and v1323 < 1 and entity.get_game_rules().m_bBombPlanted ~= 1 then
                                    v1297(color(252, 243, 105, 255), "" .. v1279, v1323, v1291);
                                end;
                            else
                                local l_m_ArmorValue_0 = v1298.m_ArmorValue;
                                local l_m_iHealth_1 = v1298.m_iHealth;
                                do
                                    local l_l_m_ArmorValue_0_0, l_l_m_iHealth_1_0 = l_m_ArmorValue_0, l_m_iHealth_1;
                                    entity.get_entities("CPlantedC4", true, function(v1328)
                                        -- upvalues: l_l_curtime_1_0 (ref), v1297 (ref), v1291 (ref), v1298 (ref), v1289 (ref), l_l_m_ArmorValue_0_0 (ref), v1299 (ref), l_l_m_iHealth_1_0 (ref)
                                        if v1328.m_bBombDefused then
                                            return false;
                                        else
                                            local l_m_flC4Blow_0 = v1328.m_flC4Blow;
                                            local v1330 = v1328.m_nBombSite == 0 and "A" or "B";
                                            if l_m_flC4Blow_0 - l_l_curtime_1_0 >= 0 then
                                                v1297(color(255, 255, 255, 200), string.format("%s - %.1fs", v1330, l_m_flC4Blow_0 - l_l_curtime_1_0), nil, v1291);
                                                local v1331 = v1298:get_eye_position():dist(v1328:get_origin());
                                                local v1332 = 500;
                                                local v1333 = v1332 * 3.5;
                                                v1332 = v1332 * math.exp(-(v1331 * v1331 / (v1333 * 2 / 3 * (v1333 / 3))));
                                                v1332 = math.max(v1332, 0);
                                                v1332 = v1289(v1332, l_l_m_ArmorValue_0_0);
                                                if v1299 and v1332 >= 1 then
                                                    if v1332 < l_l_m_iHealth_1_0 then
                                                        v1297(color(252, 243, 105, 255), string.format("-%d HP", v1332));
                                                    else
                                                        v1297(color(255, 0, 50, 255), "FATAL");
                                                    end;
                                                end;
                                            end;
                                            return false;
                                        end;
                                    end);
                                end;
                            end;
                        end;
                    end;
                end;
                local v1334 = color(7, 11, 20, 45);
                local v1335 = color(25, 32, 60, 60);
                local v1336 = render.screen_size();
                local v1337 = vector(30, v1336.y - 345);
                local v1338 = 0;
                for _, v1340 in ipairs(v1292) do
                    local v1341 = 0;
                    local v1342 = 0;
                    local v1343 = nil;
                    v1343 = render.measure_text(v1290, nil, v1340.text);
                    if v1340.icon ~= nil then
                        v1341 = v1340.icon.width;
                    end;
                    if v1340.pct ~= -1 then
                        v1342 = 10;
                    end;
                    local v1344 = 6;
                    local v1345 = v1337 + vector(-v1344, v1338 - v1344 * 0.75);
                    local v1346 = v1337 + vector(v1341 + v1344 + v1342 * 2.5, v1338 + v1344 * 0.75) + v1343;
                    render.rect(v1345, v1346, v1334, 8);
                    render.rect_outline(v1345, v1346, v1335, 0, 8);
                    if v1341 > 0 then
                        render.texture(v1340.icon, vector(v1337.x + v1344 * 0.35, v1337.y + v1338), vector(0, v1343.y), v1340.clr);
                    end;
                    render.text(v1290, vector(v1337.x + v1341, v1337.y + v1338 + 1), v1340.clr, nil, v1340.text);
                    if v1340.pct ~= -1 then
                        render.circle_outline(vector(v1337.x + v1343.x + v1342 * 1.65 + v1341, v1337.y + v1338 + v1343.y * 0.5), color(0, 200), v1342, 0, 1, 5);
                        render.circle_outline(vector(v1337.x + v1343.x + v1342 * 1.65 + v1341, v1337.y + v1338 + v1343.y * 0.5), color(255, 200), v1342 - 1, 0, v1340.pct, 3);
                    end;
                    v1338 = v1338 - (v1343.y + 17);
                end;
                v1292 = {};
                return;
            end;
        end;
        local function v1349(v1348)
            -- upvalues: v1278 (ref), v1277 (ref)
            if v1348.state and v1348.state ~= "death" and v1348.state ~= "unregistered shot" and v1348.state ~= "player death" then
                v1278 = v1278 + 1;
            else
                v1277 = v1277 + 1;
            end;
        end;
        local function v1351()
            -- upvalues: v1277 (ref), v1278 (ref)
            local v1350 = 0;
            v1278 = 0;
            v1277 = v1350;
        end;
        local function v1352()
            -- upvalues: v1279 (ref), v1281 (ref)
            v1279 = nil;
            v1281 = nil;
        end;
        local function v1359(v1353)
            -- upvalues: v1279 (ref), v1280 (ref), v1281 (ref)
            local v1354 = entity.get_player_resource();
            if v1354 == nil then
                return;
            else
                local l_m_bombsiteCenterA_0 = v1354.m_bombsiteCenterA;
                local l_m_bombsiteCenterB_0 = v1354.m_bombsiteCenterB;
                local v1357 = entity.get(v1353.site);
                if v1357 == nil then
                    return;
                else
                    local v1358 = v1357.m_vecMins:lerp(v1357.m_vecMaxs, 0.5);
                    v1279 = v1358:distsqr(l_m_bombsiteCenterA_0) < v1358:distsqr(l_m_bombsiteCenterB_0) and "A" or "B";
                    v1280 = globals.curtime;
                    v1281 = entity.get(v1353.userid, true);
                    return;
                end;
            end;
        end;
        return {
            setup = function(v1360)
                -- upvalues: v1266 (ref), v102 (ref), v1347 (ref), v1349 (ref), v1351 (ref), v1359 (ref), v1352 (ref), v1265 (ref)
                if type(v1360) == "table" then
                    local v1361 = {};
                    local v1362 = {};
                    for _, v1364 in pairs(v1266) do
                        v1361[v1364] = true;
                    end;
                    for _, v1366 in ipairs(v1360) do
                        if v1361[v1366] == true then
                            table.insert(v1362, v1366);
                        end;
                    end;
                    local v1367 = #v1362 > 0;
                    v102(events.render, v1347, v1367, true);
                    v102(events.aim_ack, v1349, v1367);
                    v102(events.level_init, v1351, v1367);
                    v102(events.bomb_beginplant, v1359, v1367);
                    v102(events.bomb_abortplant, v1352, v1367);
                    v102(events.bomb_planted, v1352, v1367);
                    v102(events.round_start, v1352, v1367);
                    if v1367 == false then
                        v1352();
                        v1351();
                    end;
                    v1265 = v1362;
                    return;
                else
                    return v1265;
                end;
            end, 
            available_features = v1266
        };
    end;
    v17("");
    v17("\aCC9F6CFFinitializing functions...");
    for v1368, v1369 in pairs(v110) do
        do
            local l_v1368_0, l_v1369_0 = v1368, v1369;
            local l_status_1, l_result_1 = pcall(function()
                -- upvalues: v17 (ref), l_v1368_0 (ref), v110 (ref), l_v1369_0 (ref)
                v17("loading sector: \a6BBCAFFF" .. l_v1368_0);
                v110[l_v1368_0] = l_v1369_0();
            end);
            if not l_status_1 then
                v15(l_result_1);
                v16(string.format("failed to initialize %s biome. please restart the game.", l_v1368_0));
            end;
        end;
    end;
end)();
v102(events.createmove, function(v1374)
    -- upvalues: v110 (ref)
    v110.grenade_release.on_createmove(v1374);
    v110.super_toss.on_createmove(v1374);
end, true);
v17("");
v17("\aCC9F6CFFinitializing menu...");
local function v1378(v1375)
    -- upvalues: v12 (ref), l_base64_0 (ref)
    local l_status_2, l_result_2 = pcall(function()
        -- upvalues: v12 (ref), l_base64_0 (ref), v1375 (ref)
        return msgpack.unpack(v12(l_base64_0.decode(v1375)));
    end);
    if not l_status_2 then
        return;
    else
        return l_result_2;
    end;
end;
local function v1385(v1379)
    local v1380 = {};
    for v1381 in pairs(v1379) do
        table.insert(v1380, v1381);
    end;
    table.sort(v1380, function(v1382, v1383)
        -- upvalues: v1379 (ref)
        if type(v1379[v1382]) == "table" and type(v1379[v1383]) == "table" then
            return v1379[v1382][1] < v1379[v1383][1];
        else
            return;
        end;
    end);
    local v1384 = 0;
    return function()
        -- upvalues: v1384 (ref), v1380 (ref), v1379 (ref)
        v1384 = v1384 + 1;
        if v1380[v1384] ~= nil then
            return v1380[v1384], v1379[v1380[v1384]];
        else
            return nil;
        end;
    end;
end;
do
    local l_v1378_0, l_v1385_0 = v1378, v1385;
    local function v1396(v1388)
        -- upvalues: l_v1378_0 (ref)
        local v1389 = {};
        for v1390 in pairs(v1388) do
            table.insert(v1389, v1390);
        end;
        table.sort(v1389, function(v1391, v1392)
            -- upvalues: v1388 (ref), l_v1378_0 (ref)
            if type(v1388[v1391]) == "string" and type(v1388[v1392]) == "string" then
                local v1393 = l_v1378_0(v1388[v1391]);
                local v1394 = l_v1378_0(v1388[v1392]);
                if v1393 ~= nil and v1394 then
                    return v1393.created_at > v1394.created_at;
                end;
            end;
        end);
        local v1395 = 0;
        return function()
            -- upvalues: v1395 (ref), v1389 (ref), v1388 (ref)
            v1395 = v1395 + 1;
            if v1389[v1395] ~= nil then
                return v1389[v1395], v1388[v1389[v1395]];
            else
                return nil;
            end;
        end;
    end;
    local function v1405(v1397)
        local v1398 = "Never";
        local v1399 = v1397 / 60;
        local v1400 = v1399 / 60;
        local v1401 = v1400 / 24;
        local v1402 = v1401 / 7;
        local v1403 = v1401 / 30.4;
        local v1404 = v1401 / 365.25;
        if v1397 < 1 then
            v1398 = "Just now";
        elseif v1397 < 60 then
            v1398 = string.format("%.0f Seconds", v1397);
        elseif v1399 < 60 then
            v1398 = string.format("%.0f Minutes", v1399);
        elseif v1400 < 24 then
            v1398 = string.format("%.0f Hours", v1400);
        elseif v1401 < 7 then
            v1398 = string.format("%.0f Days", v1401);
        elseif v1402 < 4 then
            v1398 = string.format("%.0f Weeks", v1402);
        elseif v1403 < 12 then
            v1398 = string.format("%.0f Months", v1403);
        else
            v1398 = string.format("%.0f Years", v1404);
        end;
        return v1398;
    end;
    local function v1466()
        -- upvalues: v18 (ref), v102 (ref)
        local function v1407(v1406)
            return v1406:get() or {};
        end;
        local function v1415(v1408, ...)
            -- upvalues: v18 (ref)
            for _, v1410 in pairs({
                ...
            }) do
                v18(type(v1410[2]) == "userdata" or type(v1410[2]) == "table", "invalid item reference: " .. v1410[1]);
                if v1410[2].get ~= nil then
                    v1408.references[v1410[1]] = v1410[2];
                end;
            end;
            local v1411 = {};
            for v1412 in pairs(v1408.categories) do
                for v1413, v1414 in pairs(v1408.references) do
                    v1411[v1412] = v1411[v1412] or {};
                    v1411[v1412][v1413] = v1414:export();
                end;
            end;
            v1408.config_ref:set(v1411);
            return v1408;
        end;
        local function v1427(v1416, v1417)
            -- upvalues: v1407 (ref)
            if v1416.config_ref == nil or not v1416.enabled or v1417 == nil then
                return;
            else
                local v1418 = v1416.weapon_id_to_category[v1417] or v1416.global_category;
                local v1419 = v1407(v1416.config_ref);
                local v1420 = v1419[v1418];
                local v1421 = {};
                for v1422, v1423 in pairs(v1416.references) do
                    v1420[v1422] = v1423:export();
                    v1421[v1422] = v1423;
                end;
                for v1424, v1425 in pairs(v1419) do
                    for v1426 in pairs(v1425) do
                        if v1421[v1426] == nil then
                            v1419[v1424][v1426] = nil;
                        end;
                    end;
                end;
                v1416.config_ref:set(v1419);
                return;
            end;
        end;
        local function v1435(v1428, v1429)
            -- upvalues: v1407 (ref)
            if v1428.config_ref == nil or not v1428.enabled then
                return;
            else
                local v1430 = v1428.weapon_id_to_category[v1429] or v1428.global_category;
                local v1431 = v1407(v1428.config_ref)[v1430];
                for v1432, v1433 in pairs(v1428.references) do
                    local v1434 = v1431[v1432];
                    if v1434 ~= nil then
                        v1433:import(v1434);
                    end;
                end;
                return;
            end;
        end;
        local function v1438(v1436, v1437)
            -- upvalues: v1435 (ref), v1427 (ref)
            if v1436.config_ref == nil or not v1436.enabled then
                return;
            elseif v1436.active_weapon_idx == nil then
                v1435(v1436, v1437);
                v1436.active_weapon_idx = v1437;
                return true;
            elseif v1436.active_weapon_idx ~= v1437 then
                v1427(v1436, v1436.active_weapon_idx);
                v1435(v1436, v1437);
                v1436.active_weapon_idx = v1437;
                return true;
            else
                return false;
            end;
        end;
        local function v1441(v1439)
            -- upvalues: v1438 (ref)
            if v1439 == nil or v1439.config_ref == nil or not v1439.is_enabled then
                return;
            else
                local v1440 = entity.get_local_player():get_player_weapon();
                if v1440 == nil then
                    return;
                else
                    v1438(v1439, v1440:get_weapon_index());
                    return;
                end;
            end;
        end;
        local function v1443(v1442)
            -- upvalues: v1427 (ref)
            v1427(v1442, v1442.active_weapon_idx);
        end;
        local function v1445(v1444)
            v1444.active_config_idx = nil;
        end;
        return function(v1446, v1447, v1448)
            -- upvalues: v18 (ref), v1435 (ref), v1443 (ref), v1415 (ref), v102 (ref), v1441 (ref), v1445 (ref)
            v18(type(v1446) == "userdata" and v1446.type, "the item has to be created as 'group:value(...)'");
            v18(type(v1447) == "table", "invalid weapon categories");
            v18(type(v1448) == "string" or v1448 == nil, "invalid global category name");
            local v1449 = true;
            local v1450 = {};
            local v1451 = v1448 or "Global";
            for v1452, v1453 in pairs(v1447) do
                if type(v1453) ~= "table" then
                    v1449 = false;
                    break;
                else
                    for _, v1455 in pairs(v1453) do
                        if type(v1455) ~= "number" then
                            v1449 = false;
                            break;
                        else
                            v1450[v1455] = v1452;
                        end;
                    end;
                end;
            end;
            v18(v1449, "invalid weapon categories");
            v1447[v1451] = {};
            local v1463 = {
                is_enabled = true, 
                config_ref = v1446, 
                references = {}, 
                categories = v1447, 
                weapon_id_to_category = v1450, 
                global_category = v1451, 
                enabled = function(v1456, v1457)
                    -- upvalues: v18 (ref)
                    if v1457 == nil then
                        return v1456.is_enabled;
                    else
                        v18(type(v1457) == "boolean", "invalid override value");
                        v1456.is_enabled = v1457;
                        return;
                    end;
                end, 
                get_active_weapon_idx = function(v1458)
                    return v1458.active_weapon_idx;
                end, 
                load_group = function(v1459, v1460)
                    -- upvalues: v1435 (ref)
                    if v1459 == nil or v1459.config_ref == nil or not v1459.is_enabled then
                        return;
                    elseif entity.get_local_player():get_player_weapon() == nil then
                        return;
                    else
                        v1435(v1459, v1460, true);
                        return;
                    end;
                end, 
                save_group = function(v1461)
                    -- upvalues: v1443 (ref)
                    v1443(v1461);
                end, 
                reference = function(v1462, ...)
                    -- upvalues: v1415 (ref)
                    return v1415(v1462, ...);
                end
            };
            local v1464 = nil;
            v102(events.createmove, function()
                -- upvalues: v1464 (ref), v1441 (ref)
                if not v1464.is_enabled then
                    return;
                else
                    v1441(v1464);
                    return;
                end;
            end, not _DISABLE_UI_EVENTS);
            v102(events.config_state, function(v1465)
                -- upvalues: v1445 (ref), v1464 (ref), v1443 (ref)
                if v1465 == "pre_load" then
                    v1445(v1464);
                end;
                if v1465 == "pre_save" and v1464.is_enabled then
                    v1443(v1464);
                end;
            end, not _DISABLE_UI_EVENTS);
            v1464 = setmetatable(v1463, {
                __mode = "k", 
                __metatable = false, 
                __index = {}
            });
            return v1464;
        end;
    end;
    local v1467 = {};
    local v1468 = v1466();
    local v1469 = nil;
    local v1470 = nil;
    local l_v0_0 = v0;
    local v1472 = #l_v0_0 + 1;
    local function v1477(v1473, v1474)
        local v1475 = globals.realtime * (v1474 or 1) % math.pi;
        local v1476 = math.sin(v1475 + (v1473 or 0));
        return (math.abs(v1476));
    end;
    do
        local l_l_v0_0_0, l_v1472_0, l_v1477_0 = l_v0_0, v1472, v1477;
        v102(events.render, function()
            -- upvalues: l_v1472_0 (ref), l_l_v0_0_0 (ref), l_v1477_0 (ref), v3 (ref), v2 (ref)
            if ui.get_alpha() <= 0.01 then
                return;
            else
                local v1481 = "";
                local v1482 = "";
                local v1483 = ui.get_style("Text Preview");
                local v1484 = ui.get_style("Link Active");
                for v1485 = 1, l_v1472_0 do
                    local v1486 = l_l_v0_0_0:sub(v1485, v1485);
                    local v1487 = (v1485 - 1) / l_v1472_0;
                    local v1488 = v1484:lerp(v1483, (l_v1477_0(v1487 * 1.5, 1.5))):to_hex();
                    v1481 = v1481 .. string.format("\a%s%s", v1488, v1486);
                end;
                if v3[3] ~= nil then
                    v1482 = "\a{Text Preview}  \226\128\162  \a{Link Active}" .. v3[3];
                end;
                ui.sidebar(v1481 .. v1482, v2);
                return;
            end;
        end, not _DISABLE_UI_EVENTS);
    end;
    l_v0_0 = string.format("\a{Link Active}%s", ui.get_icon("house"));
    local v1489;
    v1472, v1477, v1489 = ui.create(l_v0_0, " ##HOME_SELECTION", 1);
    v1477 = {
        v82("user", "About", 0, 18, nil, "")
    };
    v1489 = v1472:list("", v1477);
    local v1490 = ui.create(l_v0_0, "##PREVIEW_WARNING", 1);
    v1490:label(v82("triangle-exclamation", "The script is a work in progress and some features may not work as intended.", 2, 8, nil, "\aB6B665FF"));
    v1490:label(v82("bug", "Report Bugs", 2, 8, nil, ""));
    v1490:button(string.format(" \a{Link Active}%s\aDEFAULT  Discord Server", ui.get_icon("discord")), function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/g5K7X6nEyZ");
    end, true):tooltip("\194\183 In order to report a bug, you need to join \a{Link Active}Chimera Discord\aDEFAULT.\n\n\194\183 Open the \"\240\159\154\168 create-ticket\" channel and click the \"\240\159\147\169 Create ticket\" button\n\n\194\183 Describe the issue and what steps we can take to reproduce it.\n\n\194\183 Add the \a{Link Active}#Arc\aDEFAULT hashtag to your message and tag \a{Link Active}@Salvatore\aDEFAULT (Admin)");
    local v1491 = ui.create(l_v0_0, "", 1);
    v1491:label(v82("user", common.get_username(), 1, 15));
    v1491:label(v82("code-branch", string.format("%.1f  \a{Link Active}%s", v3[1], v3[2]), 1, 15));
    local v1492 = ui.create(l_v0_0, "Statistics", 2);
    local v1493 = nil;
    v1493 = db[v41] or {};
    v1493.time_spent = v1493.time_spent or 0;
    v1493.enemies_killed = v1493.enemies_killed or 0;
    local v1499 = {
        [1] = {
            type = "int", 
            var = cvar.bot_stop, 
            validate = function(v1494)
                return v1494 == 0;
            end
        }, 
        [2] = {
            type = "float", 
            var = cvar.host_timescale, 
            validate = function(v1495)
                return v1495 == 1;
            end
        }, 
        [3] = {
            type = "int", 
            var = cvar.mp_respawn_on_death_ct, 
            validate = function(v1496)
                return v1496 == 0;
            end
        }, 
        [4] = {
            type = "int", 
            var = cvar.mp_respawn_on_death_t, 
            validate = function(v1497)
                return v1497 == 0;
            end
        }, 
        [5] = {
            type = "int", 
            var = cvar.sv_infinite_ammo, 
            validate = function(v1498)
                return v1498 == 0;
            end
        }
    };
    local l_realtime_7 = globals.realtime;
    local v1501 = 0;
    local v1502 = 0;
    local v1503 = nil;
    local v1504 = false;
    local v1505 = nil;
    local v1506 = false;
    local v1507 = nil;
    v1492:label(v82("skull-crossbones", "Enemies killed", 0, 10));
    v1507 = v1492:button("0", nil, true);
    v1492:label(v82("clock", "Time played", 0, 9));
    do
        local l_v1493_0, l_v1499_0, l_l_realtime_7_0, l_v1501_0, l_v1502_0, l_v1503_0, l_v1504_0, l_v1505_0, l_v1506_0, l_v1507_0 = v1493, v1499, l_realtime_7, v1501, v1502, v1503, v1504, v1505, v1506, v1507;
        l_v1503_0 = v1492:button("0 mins", function()
            -- upvalues: l_v1501_0 (ref), l_v1504_0 (ref)
            if l_v1501_0 <= 60 then
                return;
            else
                l_v1504_0 = not l_v1504_0;
                return;
            end;
        end, true);
        l_v1503_0:tooltip("Amount of time you've spent playing the game (this session).\n\n\194\183 Click the button to change the way the time is displayed.");
        v1492:label(v82("hourglass-clock", "Time spent", 0, 8));
        l_v1505_0 = v1492:button("0 mins", function()
            -- upvalues: l_v1502_0 (ref), l_v1506_0 (ref)
            if l_v1502_0 <= 60 then
                return;
            else
                l_v1506_0 = not l_v1506_0;
                return;
            end;
        end, true);
        l_v1505_0:tooltip("Amount of time you've spent playing with the script.\n\n\194\183 Click the button to change the way the time is displayed.");
        v102(events.render, function()
            -- upvalues: l_v1501_0 (ref), l_v1502_0 (ref), l_v1493_0 (ref), l_l_realtime_7_0 (ref), l_v1507_0 (ref), l_v1503_0 (ref), l_v1504_0 (ref), v1405 (ref), l_v1505_0 (ref), l_v1506_0 (ref)
            l_v1501_0 = globals.realtime;
            l_v1502_0 = l_v1493_0.time_spent + (l_v1501_0 - l_l_realtime_7_0);
            if ui.get_alpha() <= 0.01 then
                return;
            else
                l_v1507_0:name("\a{Link Active}" .. tostring(l_v1493_0.enemies_killed));
                l_v1503_0:name("\a{Link Active}" .. (l_v1504_0 and string.format("%.0f Minutes", l_v1501_0 / 60) or v1405(l_v1501_0)));
                l_v1505_0:name("\a{Link Active}" .. (l_v1506_0 and string.format("%.0f Minutes", l_v1502_0 / 60) or v1405(l_v1502_0)));
                return;
            end;
        end, not _DISABLE_UI_EVENTS);
        v102(events.player_death, function(v1518)
            -- upvalues: l_v1499_0 (ref), l_v1493_0 (ref)
            local v1519 = entity.get(v1518.userid, true);
            if entity.get(v1518.attacker, true) ~= entity.get_local_player() or not v1519:is_enemy() then
                return;
            else
                for _, v1521 in ipairs(l_v1499_0) do
                    local v1522 = false;
                    if v1521.type == "float" then
                        v1522 = v1521.var:float();
                    elseif v1521.type == "int" then
                        v1522 = v1521.var:int();
                    end;
                    if not v1521.validate(v1522) then
                        return;
                    end;
                end;
                l_v1493_0.enemies_killed = l_v1493_0.enemies_killed + 1;
                return;
            end;
        end, not _DISABLE_UI_EVENTS);
        v102(events.shutdown, function()
            -- upvalues: l_v1493_0 (ref), l_l_realtime_7_0 (ref), v41 (ref)
            l_v1493_0.time_spent = l_v1493_0.time_spent + (globals.realtime - l_l_realtime_7_0);
            db[v41] = l_v1493_0;
        end, not _DISABLE_UI_EVENTS);
    end;
    v1493 = ui.create(l_v0_0, "Our Products", 2);
    if #v5 > 0 then
        v1493:label("\a{Small Text}Themes");
        for v1523, v1524 in ipairs(v5) do
            do
                local l_v1524_0 = v1524;
                v1504 = v1493:button(string.format(" \a%s%s ##%d", l_v1524_0[1], ui.get_icon("circle"), v1523), function()
                    -- upvalues: l_v1524_0 (ref)
                    panorama.SteamOverlayAPI.OpenExternalBrowserURL(l_v1524_0[3]);
                end, true);
                if type(l_v1524_0[2]) == "string" then
                    v1504:tooltip(string.format("\194\183 %s", l_v1524_0[2]));
                end;
            end;
        end;
    end;
    if #v6 > 0 then
        v1493:label("\a{Small Text}Scripts");
        for v1526, v1527 in ipairs(v6) do
            do
                local l_v1527_0 = v1527;
                v1493:button(string.format("%s ##%d", l_v1527_0[1], v1526), function()
                    -- upvalues: l_v1527_0 (ref)
                    panorama.SteamOverlayAPI.OpenExternalBrowserURL(l_v1527_0[2]);
                end, true);
            end;
        end;
    end;
    if #v7 > 0 then
        v1493:label("\a{Small Text}Configs");
        for v1529, v1530 in ipairs(v7) do
            do
                local l_v1530_0 = v1530;
                v1493:button(string.format("%s ##%d", l_v1530_0[1], v1529), function()
                    -- upvalues: l_v1530_0 (ref)
                    panorama.SteamOverlayAPI.OpenExternalBrowserURL(l_v1530_0[2]);
                end, true);
            end;
        end;
    end;
    do
        local l_v1477_1, l_v1489_0, l_v1490_0, l_v1491_0, l_v1492_0, l_v1493_1 = v1477, v1489, v1490, v1491, v1492, v1493;
        l_v1489_0:set_callback(function()
            -- upvalues: l_v1489_0 (ref), l_v1477_1 (ref), l_v1490_0 (ref), l_v1491_0 (ref), l_v1492_0 (ref), l_v1493_1 (ref)
            local v1538 = l_v1489_0:get();
            local v1539 = {};
            for v1540, v1541 in ipairs(l_v1477_1) do
                if v1540 == v1538 then
                    v1539[#v1539 + 1] = "\a{Link Active}" .. v1541;
                else
                    v1539[#v1539 + 1] = "\a{Small Text}" .. v1541;
                end;
            end;
            l_v1489_0:update(v1539);
            l_v1490_0:visibility(v1538 == 1);
            l_v1491_0:visibility(v1538 == 1);
            l_v1492_0:visibility(v1538 == 1);
            l_v1493_1:visibility(v1538 == 1);
        end, true);
    end;
    l_v0_0 = string.format("\a{Link Active}%s", ui.get_icon("list-tree"));
    v1472, v1477, v1489 = ui.create(l_v0_0, " ##FEATURES_SELECTION", 1);
    v1477 = {
        v82("bars-staggered", "Features", 2, 13, nil, ""), 
        v82("house-night", "World", 0, 11, nil, ""), 
        v82("symbols", "Other", 2, 13, nil, "")
    };
    v1489 = v1472:list("", v1477);
    v1490 = ui.create(l_v0_0, "##EXTRA", 1);
    v1490:switch("Reflex"):name(v82("binary", string.format("\a{Text Preview}%s Reflex", v0), 0, 17, nil, "\aB6B665FF")):tooltip("Improves PC responsiveness during a gameplay by dynamically adjusting CPU / IO priorities. (and a lot more behind the scenes)"):disabled(false);
    v1470 = v1490:switch(v82("code-pull-request-draft", "\a{Text Preview}Force Interpolation", 0, 16, nil, "\aB6B665FF")):set_callback(function(v1542)
        -- upvalues: v110 (ref)
        v110.interpolation_fixes.enabled(v1542:get());
    end, true):tooltip("Makes the game feel smoother by disabling specific engine mechanics that make the game reset the interpolation.\n\n\194\183 The \"Prediction Error\" indicator (bottom-center) is displayed every time the game is interpolated by the script.\n\n\194\183 \aB6B665FFThis feature can cause unexpected crashes. Use at your own risk.");
    v110.interpolation_fixes.callback(function(v1543)
        -- upvalues: v1470 (ref)
        v1470:disabled(v1543.disabled);
    end);
    v1491 = ui.create(l_v0_0, "##COMMON", 1);
    v1492 = v1491:switch(v82("hand", "Viewmodel", 1, 15));
    v1493 = v1492:create();
    v1493:slider("Field of View", 0, 1000, cvar.viewmodel_fov:float() * 10, 0.1):set_callback(function(v1544)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, nil, nil, nil, nil, nil, v1544:get() * 0.1);
    end, true);
    v1493:slider("Offset X", -100, 100, cvar.viewmodel_offset_x:float() * 10, 0.1):set_callback(function(v1545)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, nil, nil, v1545:get() * 0.1);
    end, true);
    v1493:slider("Offset Y", -100, 100, cvar.viewmodel_offset_y:float() * 10, 0.1):set_callback(function(v1546)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, nil, nil, nil, v1546:get() * 0.1);
    end, true);
    v1493:slider("Offset Z", -100, 100, cvar.viewmodel_offset_z:float() * 10, 0.1):set_callback(function(v1547)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, nil, nil, nil, nil, v1547:get() * 0.1);
    end, true);
    v1493:switch("Opposite Knife Hand"):set_callback(function(v1548)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, v1548:get());
    end, true);
    v1493:switch("Force CS:S Animations"):set_callback(function(v1549)
        -- upvalues: v110 (ref)
        v110.viewmodel(nil, nil, v1549:get());
    end, true);
    v1492:set_callback(function(v1550)
        -- upvalues: v110 (ref)
        v110.viewmodel(v1550:get());
    end, true);
    v1491:switch(v82("rectangle-terminal", "VGUI Color", 1, 15)):set_callback(function(v1551)
        -- upvalues: v110 (ref)
        v110.console_color(v1551:get());
    end, true):color_picker(color(50, 50, 75, 200)):set_callback(function(v1552)
        -- upvalues: v110 (ref)
        v110.console_color(nil, v1552:get());
    end, true);
    v1491:switch(v82("expand", "Game Focus", 2, 14)):set_callback(function(v1553)
        -- upvalues: v110 (ref)
        v110.game_focus(v1553:get());
    end, true):tooltip("\194\183 Tabs into the game when the event is occured.\n\n\194\183 Available events: Match Found, Round Start.\n\n\194\183 This is an improved version of the feature that everybody has copied into their scripts.");
    v1491:combo(v82("microphone-lines", "Unmute Players", 3, 14), "Disabled", "Enemies", "Teammates", "Everyone"):set_callback(function(v1554)
        -- upvalues: v110 (ref)
        local v1555 = v1554:get();
        if v1555 == "Enemies" then
            v110.unmute_players(1);
        elseif v1555 == "Teammates" then
            v110.unmute_players(2);
        elseif v1555 == "Everyone" then
            v110.unmute_players(3);
        else
            v110.unmute_players(0);
        end;
    end, true);
    v1493 = nil;
    v1499 = nil;
    l_realtime_7 = string.format("  \a{Link Active}%s   \aDEFAULTSteal  ", ui.get_icon("magnifying-glass-location"));
    v1501 = 2.5;
    v1502 = 0;
    v1503 = nil;
    v1504 = nil;
    v1505 = panorama.MyPersonaAPI.GetName;
    v1506 = function(v1556)
        if #v1556 > 10 then
            return v1556:sub(0, 10) .. "..";
        else
            return v1556;
        end;
    end;
    do
        local l_v1493_2, l_v1499_1, l_l_realtime_7_1, l_v1501_1, l_v1502_1, l_v1503_1, l_v1504_1, l_v1505_1, l_v1506_1, l_v1507_1 = v1493, v1499, l_realtime_7, v1501, v1502, v1503, v1504, v1505, v1506, v1507;
        l_v1507_1 = function(v1567, v1568)
            -- upvalues: l_v1493_2 (ref)
            if l_v1493_2 == nil then
                return;
            else
                local v1569 = v1568 == true and "\a{Link Active}" or "\aB6B665FF";
                l_v1493_2:name(string.format("  %s%s   \aDEFAULT%s  ", v1569, ui.get_icon(v1568 == true and "check" or "xmark"), v1567));
                return;
            end;
        end;
        v102(events.render, function()
            -- upvalues: l_v1499_1 (ref), l_v1505_1 (ref), l_v1502_1 (ref), l_v1503_1 (ref), l_v1504_1 (ref), l_v1493_2 (ref), l_l_realtime_7_1 (ref), l_v1507_1 (ref)
            if ui.get_alpha() <= 0.01 then
                return;
            else
                local v1570 = entity.get_local_player();
                l_v1499_1:visibility(v1570 ~= nil and l_v1505_1() ~= v1570:get_name());
                if v1570 == nil or l_v1502_1 == 0 then
                    return;
                else
                    if globals.realtime > l_v1502_1 then
                        local v1571 = 0;
                        local v1572 = nil;
                        l_v1504_1 = nil;
                        l_v1503_1 = v1572;
                        l_v1502_1 = v1571;
                        l_v1493_2:name(l_l_realtime_7_1);
                    elseif l_v1503_1 ~= nil then
                        local v1573 = v1570:get_name();
                        l_v1507_1(l_v1504_1, v1573 == l_v1503_1 .. "\227\133\164" or v1573 == l_v1505_1() and v1573 == l_v1503_1);
                    end;
                    return;
                end;
            end;
        end, not _DISABLE_UI_EVENTS);
        v1491:label(v82("signature", "Player Name", 1, 10));
        l_v1499_1 = v1491:button(string.format(" \a{Link Active}%s ", ui.get_icon("backward")), function()
            -- upvalues: l_v1505_1 (ref), l_v1506_1 (ref), l_v1502_1 (ref), l_v1503_1 (ref), l_v1504_1 (ref), l_v1501_1 (ref), l_v1507_1 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            local v1574 = entity.get_local_player();
            if v1574 == nil then
                return;
            else
                local v1575 = l_v1505_1();
                local v1576 = l_v1506_1(v1575);
                local v1577 = globals.realtime + l_v1501_1;
                local l_v1575_0 = v1575;
                l_v1504_1 = v1576;
                l_v1503_1 = l_v1575_0;
                l_v1502_1 = v1577;
                common.set_name(v1575);
                l_v1507_1(l_v1504_1, v1574:get_name() == l_v1503_1);
                return;
            end;
        end, true):tooltip("\194\183 Tap to reset your nickname to the original one.");
        l_v1493_2 = v1491:button(l_l_realtime_7_1, function()
            -- upvalues: v110 (ref), l_v1506_1 (ref), l_v1502_1 (ref), l_v1503_1 (ref), l_v1504_1 (ref), l_v1501_1 (ref), l_v1507_1 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            local v1579 = entity.get_local_player();
            if v1579 == nil then
                return;
            else
                local v1580 = v110.steal_player_name();
                if v1580 == nil then
                    return;
                else
                    local v1581 = l_v1506_1(v1580);
                    if type(v1580) == "string" then
                        local v1582 = globals.realtime + l_v1501_1;
                        local l_v1580_0 = v1580;
                        l_v1504_1 = v1581;
                        l_v1503_1 = l_v1580_0;
                        l_v1502_1 = v1582;
                        l_v1507_1(l_v1504_1, v1579:get_name() == l_v1503_1 .. "\227\133\164");
                    end;
                    return;
                end;
            end;
        end, true);
    end;
    v1492 = ui.create(l_v0_0, "Movement", 2);
    v1492:switch(v82("arrows-turn-to-dots", "Avoid Collisions", 0, 13)):set_callback(function(v1584)
        -- upvalues: v110 (ref)
        v110.avoid_collisions(v1584:get());
    end, true):tooltip("\194\183 Attempts to avoid obstacles by overriding \"Air Strafe\" direction.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.");
    v1492:switch(v82("person-walking-dashed-line-arrow-right", "Collision Air Duck", 0, 9)):set_callback(function(v1585)
        -- upvalues: v110 (ref)
        v110.collision_air_duck(v1585:get());
    end, true):tooltip("\194\183 Automatically ducks if there's a possibility of avoiding collision by making the player fully-ducked.\n\n\194\183 Doesn't work on ground.");
    v1492:switch(v82("person-falling-burst", "No Fall Damage", 0, 9)):set_callback(function(v1586)
        -- upvalues: v110 (ref)
        v110.no_fall_damage(v1586:get());
    end, true):tooltip("\194\183 Attempts to perform a jumpbug when possible.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.");
    v1492:switch(v82("water-ladder", "Fast Ladder", 0, 11)):set_callback(function(v1587)
        -- upvalues: v110 (ref)
        v110.fast_ladder(v1587:get());
    end, true):tooltip("\194\183 Abuses the ladder movement mechanic and makes you move a little faster.");
    v1492:switch(v82("person-running", "Fast Walk", 2, 13)):set_callback(function(v1588)
        -- upvalues: v110 (ref)
        v110.fast_walk(v1588:get());
    end, true):tooltip("\194\183 Makes you walk at the highest possible speed without making a footstep noise.\n\n\194\183 Hold \"+speed\" (Shift) keybind to toggle the feature.");
    v1492:switch(v82("person-circle-exclamation", "Edge Quick Stop", 2, 9)):set_callback(function(v1589)
        -- upvalues: v110 (ref)
        v110.edge_quick_stop(v1589:get());
    end, true):tooltip("\194\183 Prevents you from walking or jumping off edges, similar to the Minecraft sneaking mechanic.\n\n\194\183 Works best with Peek Assist.");
    v1493 = ui.create(l_v0_0, "Weapon Features", 2);
    v1493:switch(v82("hand-holding-droplet", "Super Toss", 0, 14)):set_callback(function(v1590)
        -- upvalues: v110 (ref)
        v110.super_toss.enabled(v1590:get());
    end, true):tooltip("\194\183 Attempts to optimize the throw trajectory by automatically adjusting the aiming angle slightly downward and aiming differently to account for the movement speed or direction.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.");
    v1493:switch(v82("hand-fist", "Quick Throw", 2, 16)):set_callback(function(v1591)
        -- upvalues: v110 (ref)
        v110.quick_throw(v1591:get());
    end, true):tooltip("\194\183 Instantly throws a grenade or switches to primary weapon after shooting with a taser.");
    v1493:switch(v82("land-mine-on", "Quick Interactions", 1, 14)):set_callback(function(v1592)
        -- upvalues: v110 (ref)
        v110.quick_interractions(v1592:get());
    end, true):tooltip("\194\183 Instantly picks up the hostage when entering the interaction zone (hold \"+use\" key). It also let's you pick up the hostage even if you're not looking at him directly. \n\n\194\183 Instantly plants the bomb when entering bombsite or landing on ground (hold \"+use\" key when entering the bombsite).\n\n\194\183 It also adds the ability to abort planting by pressing / holding \"+jump\" key (Space).");
    v1493:switch(v82("bomb", "Grenade Release", 2, 14)):set_callback(function(v1593)
        -- upvalues: v110 (ref)
        v110.grenade_release.enabled(v1593:get());
    end, true):tooltip("\194\183 Releases the grenade if there's a possibility of dealing damage to an enemy."):create():slider("Min. Damage", 1, 50, 50):set_callback(function(v1594)
        -- upvalues: v110 (ref)
        v110.grenade_release.enabled(nil, v1594:get());
    end, true);
    v1499 = ui.create(l_v0_0, "Colored Weapons", 1);
    l_realtime_7 = v1499:value("Adaptive Settings", {});
    v1501 = v1499:combo(v82("shirt", "Chams", 1, 9), "Disabled", "Default", "Material", "Glow", "Glass", "Solid"):set_callback(function(v1595)
        -- upvalues: v110 (ref)
        local v1596 = v1595:get();
        v110.colored_weapons.setup_chams(v1596 ~= "Disabled", v1596 ~= "Disabled" and v1596 or nil);
    end, true);
    v1502, v1503, v1504 = v1501:create();
    v1503 = v1502:color_picker("Color", color("000000FF")):set_callback(function(v1597)
        -- upvalues: v110 (ref)
        v110.colored_weapons.setup_chams(nil, nil, v1597:get());
    end, true);
    v1504 = v1502:color_picker("Style Color", color("3C414BFF")):set_callback(function(v1598)
        -- upvalues: v110 (ref)
        v110.colored_weapons.setup_chams(nil, nil, nil, v1598:get());
    end, true);
    do
        local l_v1503_2, l_v1504_2, l_v1506_2, l_v1507_2 = v1503, v1504, v1506, v1507;
        v1501:set_callback(function(v1603)
            -- upvalues: l_v1503_2 (ref), l_v1504_2 (ref)
            local v1604 = v1603:get();
            local v1605 = v1604 ~= "Disabled" and v1604 ~= "Off";
            local v1606 = v1605 and v1604 ~= "Solid" and v1604 ~= "Material";
            l_v1503_2:visibility(v1605);
            l_v1504_2:visibility(v1605 and v1606);
        end, true);
        v1505 = nil;
        l_v1506_2 = nil;
        l_v1507_2 = nil;
        local v1607 = nil;
        local v1608 = nil;
        local v1609 = nil;
        local v1610 = nil;
        local v1611 = {
            [v82("chart-scatter", "No Draw", 0, 10, nil, "")] = 2, 
            [v82("square-plus", "Additive", 3, 11, nil, "")] = 7, 
            [v82("house-flood-water-circle-arrow-right", "Nocull", 0, 7, nil, "")] = 13, 
            [v82("block-brick", "Ignorez", 3, 11, nil, "")] = 15, 
            [v82("frame", "Wireframe", 3, 11, nil, "")] = 28
        };
        v1608 = {};
        v1607 = v1611;
        for v1612 in pairs(v1607) do
            v1608[#v1608 + 1] = v1612;
        end;
        table.sort(v1608);
        v1611 = {
            Dogstags = "models/inventory_items/dogtags/dogtags", 
            ["2016 glass"] = "models/inventory_items/service_medal_2016/glass_lvl4", 
            Gloss = "models/inventory_items/trophy_majors/gloss", 
            Glass = "models/gibs/glass/glass", 
            Glow = "vgui/achievements/glow", 
            Gold = "models/inventory_items/trophy_majors/gold", 
            ["Hydra crystal detail"] = "models/inventory_items/hydra_crystal/hydra_crystal_detail", 
            ["Crystal clear"] = "models/inventory_items/trophy_majors/crystal_clear", 
            ["2015 glass"] = "models/inventory_items/service_medal_2015/glass", 
            ["FBI Glass"] = "models/player/ct_fbi/ct_fbi_glass", 
            ["Dreamhack star"] = "models/inventory_items/dreamhack_trophies/dreamhack_star_blur", 
            ["Charset color"] = "models/inventory_items/contributor_map_tokens/contributor_charset_color", 
            Guerilla = "models/player/t_guerilla/t_guerilla", 
            ESL_C = "models/weapons/customization/stickers/cologne2014/esl_c", 
            ["Major gloss"] = "models/inventory_items/trophy_majors/gloss", 
            Branches = "models/props_foliage/urban_tree03_branches", 
            ["Speech info"] = "models/extras/speech_info", 
            ["MP3 detail"] = "models/inventory_items/music_kit/darude_01/mp3_detail", 
            ["Hydra crystal"] = "models/inventory_items/hydra_crystal/hydra_crystal", 
            ["Dogtag light"] = "models/inventory_items/dogtags/dogtags_lightray", 
            ["Dogtag outline"] = "models/inventory_items/dogtags/dogtags_outline", 
            Fishnet = "models/props_shacks/fishing_net01", 
            Velvet = "models/inventory_items/trophy_majors/velvet", 
            ["Silver winners"] = "models/inventory_items/trophy_majors/silver_winners", 
            ["Crystal blue"] = "models/inventory_items/trophy_majors/crystal_blue", 
            ["Wildfire gold"] = "models/inventory_items/wildfire_gold/wildfire_gold_detail"
        };
        v1610 = {};
        v1609 = v1611;
        for v1613, _ in pairs(v1609) do
            v1610[#v1610 + 1] = v1613;
        end;
        table.sort(v1610);
        v1610[0] = "Disabled";
        v1505 = v1499:combo(v82("x-ray", "Texture", 2, 11), v1610);
        l_v1506_2 = v1505:color_picker():set_callback(function(v1615)
            -- upvalues: v110 (ref)
            v110.colored_weapons.setup(nil, v1615:get());
        end, true);
        l_v1507_2 = v1499:listable(v82("list-check", "Variable Flags", 2, 12), v1608):set_callback(function(v1616)
            -- upvalues: v1608 (ref), v1607 (ref), v110 (ref)
            local v1617 = {};
            for _, v1619 in pairs(v1616:get()) do
                local v1620 = v1607[v1608[v1619]];
                v1617[#v1617 + 1] = v1620;
            end;
            v110.colored_weapons.setup(nil, nil, v1617);
        end, true);
        v1505:set_callback(function(v1621)
            -- upvalues: v110 (ref), v1609 (ref), l_v1506_2 (ref), l_v1507_2 (ref)
            local v1622 = v1621:get();
            local v1623 = v1622 == "Disabled";
            if v1623 then
                v110.colored_weapons.setup();
            else
                v110.colored_weapons.setup(v1609[v1622]);
            end;
            l_v1506_2:visibility(not v1623);
            l_v1507_2:disabled(v1623);
        end, true);
        v1611 = {
            Grenades = {
                [1] = 43, 
                [2] = 44, 
                [3] = 45, 
                [4] = 46, 
                [5] = 47, 
                [6] = 48, 
                [7] = 68, 
                [8] = 70, 
                [9] = 81, 
                [10] = 82, 
                [11] = 83, 
                [12] = 84, 
                [13] = 85
            }, 
            Knives = {
                [1] = 41, 
                [2] = 42, 
                [3] = 59, 
                [4] = 74, 
                [5] = 500, 
                [6] = 503, 
                [7] = 505, 
                [8] = 506, 
                [9] = 507, 
                [10] = 508, 
                [11] = 509, 
                [12] = 512, 
                [13] = 514, 
                [14] = 515, 
                [15] = 516, 
                [16] = 517, 
                [17] = 518, 
                [18] = 519, 
                [19] = 520, 
                [20] = 521, 
                [21] = 522, 
                [22] = 523, 
                [23] = 525
            }
        };
        for v1624 = 1, 40 do
            if v1624 ~= 20 and v1624 ~= 37 then
                v1611[tostring(v1624)] = {
                    [1] = v1624
                };
            end;
        end;
        for v1625 = 60, 64 do
            if v1625 ~= 62 then
                v1611[tostring(v1625)] = {
                    [1] = v1625
                };
            end;
        end;
        v1469 = v1468(l_realtime_7, v1611, "Global");
        v1469:reference({
            [1] = "chams", 
            [2] = v1501
        }, {
            [1] = "chams_color", 
            [2] = l_v1503_2
        }, {
            [1] = "chams_style_color", 
            [2] = l_v1504_2
        }, {
            [1] = "texture", 
            [2] = v1505
        }, {
            [1] = "texture_color", 
            [2] = l_v1506_2
        }, {
            [1] = "var_flags", 
            [2] = l_v1507_2
        });
    end;
    l_realtime_7 = ui.create(l_v0_0, " ##TONEMAP_NOTIFICATION", 2);
    l_realtime_7:label(v82("triangle-exclamation", "Post processing is not available.", 2, 13, nil, "\aB6B665FF"));
    v1501, v1502, v1503 = ui.create(l_v0_0, "Ambient", 2);
    v1504 = function(v1626)
        return v1626 == -1 and "Off" or v1626 .. "%";
    end;
    v1501:switch(v82("paint-roller", "Wall Dyeing", 1, 12)):set_callback(function(v1627)
        -- upvalues: v110 (ref)
        v110.tone_mapping.ambient_light(v1627:get());
    end, true):color_picker(color(33, 33, 34, 135)):set_callback(function(v1628)
        -- upvalues: v110 (ref)
        v110.tone_mapping.ambient_light(nil, v1628:get());
    end, true);
    v1502 = v1501:slider(v82("keyboard-brightness", "Bloom", 1, 9), -1, 250, -1, 1, v1504):set_callback(function(v1629)
        -- upvalues: v110 (ref)
        v110.tone_mapping.bloom(v1629:get());
    end, true);
    v1503 = v1501:slider(v82("moon-cloud", "Exposure", 1, 9), -1, 200, -1, 1, v1504):set_callback(function(v1630)
        -- upvalues: v110 (ref)
        v110.tone_mapping.exposure(v1630:get());
    end, true);
    v1501:slider(v82("brightness", "Model Brightness", 1, 13), 0, 200, 0, 1, function(v1631)
        return v1631 == 0 and "Off" or v1631 .. "%";
    end):set_callback(function(v1632)
        -- upvalues: v110 (ref)
        v110.tone_mapping.model_brightness(v1632:get());
    end, true);
    v1504 = ui.create(l_v0_0, "Removals", 2);
    v1504:switch(v82("droplet", "No Blood", 2, 14)):set_callback(function(v1633)
        -- upvalues: v110 (ref)
        v110.removals.blood(v1633:get());
    end, true);
    v1504:switch(v82("user-group-crown", "Disable Teammate Rendering", 1, 10)):set_callback(function(v1634)
        -- upvalues: v110 (ref)
        v110.removals.team_rendering(v1634:get());
    end, true);
    v1504:combo(v82("person-harassing", "Disable Ragdolls", 1, 11), "Default", "Physics", "Rendering"):set_callback(function(v1635)
        -- upvalues: v110 (ref)
        local v1636 = v1635:get();
        if v1636 == "Rendering" then
            v110.removals.ragdoll_physics(2);
        elseif v1636 == "Physics" then
            v110.removals.ragdoll_physics(1);
        else
            v110.removals.ragdoll_physics(0);
        end;
    end, true);
    v1505 = ui.create(l_v0_0, "##MISCELLANEOUS", 2);
    v1505:switch(v82("flashlight", "Flashlight", 0, 10)):set_callback(function(v1637)
        -- upvalues: v110 (ref)
        v110.flashlight(v1637:get());
    end, true):tooltip("\aB6B665FF\194\183 This feature requires heavy processing. Enabling this may greatly affect your FPS.");
    v1505:switch(v82("raindrops", "Override Weather", 3, 13)):set_callback(function(v1638)
        -- upvalues: v110 (ref)
        v110.weather(v1638:get() and 2 or 0);
    end, true):tooltip("\aB6B665FF\194\183 This feature requires heavy processing. Enabling this may greatly affect your FPS.\n\n\aDEFAULT\194\183 \aFF3E3EFFPlease note that the \"Force Interpolation\" feature causes instabilities and may crash the game when the Weather Changer is enabled.");
    v1507 = v1505:switch(v82("cube", "Visualize Exploits", 2, 14)):set_callback(function(v1639)
        -- upvalues: v110 (ref)
        v110.visualize_exploits(v1639:get());
    end, true):tooltip("\194\183 Displays a 3D box at the location of the last valid history record when the enemy is attempting to invalidate backtrack records (Lag Peek / Defensive).\n\n\aB6B665FF\194\183 This feature requires heavy processing. Enabling this may greatly affect your FPS."):create();
    v1507:color_picker("Color", "FF0000FF"):set_callback(function(v1640)
        -- upvalues: v110 (ref)
        v110.visualize_exploits(nil, nil, v1640:get());
    end, true);
    v1507:slider("Thickness", 0, 100, 35, 1, "%"):set_callback(function(v1641)
        -- upvalues: v110 (ref)
        v110.visualize_exploits(nil, v1641:get() * 0.01);
    end, true);
    v1506 = ui.create(l_v0_0, "Player Animations", 1);
    v1507 = {
        v82("timeline-arrow", "Interpolate", 1, 9, nil, ""), 
        v82("person-walking-arrow-right", "Disable Move Lean", 0, 9, nil, ""), 
        v82("head-side", "Landing Zero-Pitch", 1, 13, nil, ""), 
        v82("clock-rotate-left", "Preserve Animated Tick", 0, 13, nil, "")
    };
    local v1642 = v1506:label(v82("circle-info", "Overridden by 3rd party hook.", 0, 12, nil, "\aFF3E3EFF")):visibility(false);
    local v1643 = v1506:selectable(v82("layer-group", "Animations", 1, 13), v1507):tooltip("\194\183 \"Interpolate\" smooths out local player animations in order to make them look nicer. It replicates some of the \a95B806FFgamesense\aDEFAULT's animation fix logic.\n\n\194\183 \"Disable Move Lean\" disables the move lean animation playback.\n\n\194\183 \"Landing Zero-Pitch\" forces the playback of the animation of falling.\n\n\194\183 \"Preserve Animated Tick\" prevents the cheat from animating ticks that aren't lagcompensated.");
    local v1646 = v1643:create():slider(v82("timeline-arrow", "Amount", 1, 9, nil, ""), 1, 16, 2, 1, function(v1644)
        return string.format("\aB6B665FF%d t.", v1644);
    end):set_callback(function(v1645)
        -- upvalues: v110 (ref)
        v110.force_player_animations.exp_interpolation(nil, v1645:get());
    end, true);
    do
        local l_v1477_2, l_v1489_1, l_v1490_1, l_v1491_1, l_v1492_1, l_v1493_3, l_v1499_2, l_l_realtime_7_2, l_v1501_2, l_v1502_2, l_v1503_3, l_v1504_3, l_v1505_2, l_v1506_3, l_v1507_3, l_v1642_0, l_v1643_0 = v1477, v1489, v1490, v1491, v1492, v1493, v1499, l_realtime_7, v1501, v1502, v1503, v1504, v1505, v1506, v1507, v1642, v1643;
        do
            local l_l_v1507_3_0, l_l_v1642_0_0 = l_v1507_3, l_v1642_0;
            do
                local l_v1646_0 = v1646;
                l_v1643_0:set_callback(function(v1667)
                    -- upvalues: l_l_v1507_3_0 (ref), v110 (ref), l_v1646_0 (ref)
                    local v1668 = {};
                    for v1669 in ipairs(l_l_v1507_3_0) do
                        v1668[v1669] = false;
                    end;
                    for _, v1671 in ipairs(v1667:get()) do
                        local v1672 = nil;
                        for v1673, v1674 in pairs(l_l_v1507_3_0) do
                            if v1671 == v1674 then
                                v1672 = v1673;
                                break;
                            end;
                        end;
                        if v1672 ~= nil then
                            v1668[v1672] = true;
                        end;
                    end;
                    v110.force_player_animations.exp_interpolation(v1668[1]);
                    v110.force_player_animations.disable_move_lean(v1668[2]);
                    v110.force_player_animations.landing_pitch(v1668[3]);
                    v110.force_player_animations.preserve_last_animated_tick(v1668[4]);
                    l_v1646_0:visibility(v1668[1]);
                end, true);
            end;
            l_v1506_3:combo(v82("person-falling", "Falling Animation", 0, 15), "Default", "Force", "Legacy"):set_callback(function(v1675)
                -- upvalues: v110 (ref)
                local v1676 = v1675:get();
                if v1676 == "Legacy" then
                    v110.force_player_animations.force_falling(2);
                elseif v1676 == "Force" then
                    v110.force_player_animations.force_falling(1);
                else
                    v110.force_player_animations.force_falling(0);
                end;
            end, true):tooltip("\194\183 \"Force\" forces the falling animation playback.\n\n\194\183 \"Legacy\" makes the game animate falling playback the way it was before the Danger Zone update.");
            l_v1506_3:selectable(v82("person-walking", "Directional Legs", 0, 18), "Ground", "Jumping"):set_callback(function(v1677)
                -- upvalues: v110 (ref)
                local v1678 = false;
                local v1679 = false;
                for _, v1681 in pairs(v1677:get()) do
                    if v1681 == "Ground" then
                        v1679 = true;
                    end;
                    if v1681 == "Jumping" then
                        v1678 = true;
                    end;
                end;
                if v1678 and v1679 then
                    v110.force_player_animations.directional_legs(3);
                elseif v1678 then
                    v110.force_player_animations.directional_legs(2);
                elseif v1679 then
                    v110.force_player_animations.directional_legs(1);
                else
                    v110.force_player_animations.directional_legs(0);
                end;
            end, true);
            v110.force_player_animations.callback(function(v1682)
                -- upvalues: l_l_v1642_0_0 (ref), l_v1506_3 (ref)
                l_l_v1642_0_0:visibility(v1682.disabled);
                l_v1506_3:disabled(v1682.disabled);
            end);
        end;
        l_v1507_3 = ui.create(l_v0_0, "Shared Features", 1);
        l_v1507_3:switch(v82("fingerprint", "Cheat Revealer", 2, 14)):set_callback(function(v1683)
            -- upvalues: v110 (ref)
            v110.cheat_revealer(v1683:get());
        end, true):tooltip(v82("circle-info", "This feature solely relies on Shared ESP data and may not work on servers with certain configuration.", 5, 7, nil, "\aFF3E3EFF"));
        l_v1507_3:switch(v82("share-nodes", "Shared Logo ", 3, 16), true):set_callback(function(v1684)
            -- upvalues: v110 (ref)
            v110.shared_logo(v1684:get());
        end, true);
        l_v1507_3:switch(v82("tag", "Clan Tag Spammer", 3, 16)):set_callback(function(v1685)
            -- upvalues: v110 (ref)
            v110.clan_tag_spammer(v1685:get());
        end, true);
        l_v1642_0 = ui.create(l_v0_0, " ##VISUALS", 2);
        local v1686;
        l_v1643_0, v1646, v1686 = l_v1642_0:label(v82("rectangle-ad", "Watermark", 0, 10));
        local v1687 = l_v1643_0:create();
        v1686 = v1687:list("##POSITIONING", "Upper-Left", "Upper-Right", "Bottom-Left", "Bottom-Right"):set(4):set_callback(function(v1688)
            -- upvalues: v110 (ref)
            v110.watermark(nil, v1688:get());
        end, true);
        v1646 = v1687:label(v82("circle-info", "This feature is overridden by the \"Network Metrics\" feature.", 5, 14, nil, "\aFF3E3EFF"));
        l_v1642_0:label(v82("gallery-thumbnails", "Screen Indicators", 0, 10)):create():listable("", v110.screen_indicators.available_features):set_callback(function(v1689)
            -- upvalues: v110 (ref)
            local v1690 = {};
            local v1691 = v1689:list();
            for _, v1693 in pairs(v1689:get()) do
                table.insert(v1690, v1691[v1693]);
            end;
            v110.screen_indicators.setup(v1690);
        end, true);
        local v1694 = l_v1642_0:label(v82("circle-nodes", "Network Metrics", 0, 12)):tooltip("\194\183 99% FPS indicator shows that 99% of your frames are above this threshold. It helps identify instances of stuttering or lagging, which might significantly impact the gameplay, even if the average frame rate seems satisfactory."):create();
        do
            local l_v1646_1, l_v1686_0 = v1646, v1686;
            v1694:listable("", {
                [1] = "Framerate", 
                [2] = "Connectivity", 
                [3] = "Server Responsiveness"
            }):set_callback(function(v1697)
                -- upvalues: v110 (ref), l_v1646_1 (ref), l_v1686_0 (ref)
                local v1698 = v1697:list();
                local v1699 = false;
                local v1700 = false;
                local v1701 = false;
                local v1702 = v1697:get();
                for _, v1704 in ipairs(v1702) do
                    local v1705 = v1698[v1704];
                    if v1705 == "Framerate" then
                        v1699 = true;
                    end;
                    if v1705 == "Connectivity" then
                        v1700 = true;
                    end;
                    if v1705 == "Server Responsiveness" then
                        v1701 = true;
                    end;
                end;
                v110.network_metrics(v1699, v1700, v1701);
                v110.watermark(#v1702 == 0);
                l_v1646_1:visibility(#v1702 > 0);
                l_v1686_0:disabled(#v1702 > 0);
            end, true);
            v1694:switch("Flash if Below Monitor's Frequency", true):tooltip("\194\183 Flashes the 99% FPS indicator if the FPS is below the monitor's update frequency."):set_callback(function(v1706)
                -- upvalues: v110 (ref)
                v110.network_metrics(nil, nil, nil, v1706:get());
            end, true);
            l_v1642_0:switch(v82("bullseye-arrow", "Hit Marker", 0, 12)):set_callback(function(v1707)
                -- upvalues: v110 (ref)
                v110.hit_marker(v1707:get());
            end, true);
            l_v1642_0:switch(v82("transporter-4", "Grenade Trajectory", 0, 12)):set_callback(function(v1708)
                -- upvalues: v110 (ref)
                v110.grenade_trajectory(v1708:get());
            end, true):tooltip("\194\183 Shows the predicted trajectory of the held grenade.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.\n\n\194\183 If you want to use this function, then do not forget to enable the Grenade Trajectory from Neverlose, which is located in World \194\187 Other \194\187 Grenade Prediction");
            l_v1642_0:switch(v82("hexagon-exclamation", "Grenade Proximity Warning", 0, 12)):set_callback(function(v1709)
                -- upvalues: v110 (ref)
                v110.grenade_warning(v1709:get());
            end, true):tooltip("\194\183 Shows a warning if there's a grenade in the immediate vicinity.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.\n\n\194\183 If you want to use this function, then do not forget to enable the Grenade Warning from Neverlose, which is located in World \194\187 Other \194\187 Grenade Proximity Warning");
            l_v1642_0:switch(v82("face-dotted", "Keep Model Transparency", 0, 12)):set_callback(function(v1710)
                -- upvalues: v110 (ref)
                v110.keep_scope_transparency(v1710:get());
            end, true):tooltip("\194\183 Keeps the local player model transparent after shooting with bolt-action sniper rifles and adds an extra fade-in/out animation.\n\n\194\183 This is a 1:1 replica from \a95B806FFgamesense\aDEFAULT.");
            local v1711 = nil;
            v1711 = {
                Simple = {
                    color(0, 160)
                }, 
                Fade = {
                    color(0, 10, 33, 0), 
                    color(30, 60, 135, 130)
                }
            };
            l_v1642_0:switch(v82("circle-notch", "Inaccuracy Overlay", 0, 12)):set_callback(function(v1712)
                -- upvalues: v110 (ref)
                v110.inaccuracy_overlay(v1712:get());
            end, true):color_picker(v1711):set("Fade"):set_callback(function(v1713)
                -- upvalues: v110 (ref)
                local v1714, v1715 = v1713:get();
                if v1714 == "Simple" then
                    v110.inaccuracy_overlay(nil, v1715, v1715:alpha_modulate(0));
                else
                    v110.inaccuracy_overlay(nil, v1715[1], v1715[2]);
                end;
            end, true);
        end;
        l_v1643_0 = ui.create(l_v0_0, "Other##VISUALS_EXTRA", 2);
        v1646 = l_v1643_0:label(v82("calendar-lines-pen", "Log Events", 0, 11)):create();
        v1646:switch("Purchases"):set_callback(function(v1716)
            -- upvalues: v110 (ref)
            v110.log_events.purchases(v1716:get());
        end, true);
        v1646:switch("Damage Dealt"):set_callback(function(v1717)
            -- upvalues: v110 (ref)
            v110.log_events.damage_dealt(v1717:get());
        end, true);
        l_v1643_0:label(v82("github", "Github", 0, 14));
        l_v1643_0:button(" \a{Text Preview}tickcount ", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://github.com/tickcount/");
        end, true);
        v1467.features_extra = l_v1490_1;
        v1467.features_common = l_v1491_1;
        v1467.features_movement = l_v1492_1;
        v1467.features_weapons = l_v1493_3;
        v1467.world_colored_weapons = l_v1499_2;
        v1467.world_ambient = l_v1501_2;
        v1467.world_removals = l_v1504_3;
        v1467.world_miscellaneous = l_v1505_2;
        v1467.visuals_local_player_animations = l_v1506_3;
        v1467.visuals_shared_features = l_v1507_3;
        v1467.visuals_main = l_v1642_0;
        v1467.visuals_other = l_v1643_0;
        v1646 = function()
            -- upvalues: l_v1489_1 (ref), l_v1477_2 (ref), l_v1490_1 (ref), l_v1491_1 (ref), l_v1492_1 (ref), l_v1493_3 (ref), v110 (ref), l_v1499_2 (ref), l_l_realtime_7_2 (ref), l_v1501_2 (ref), l_v1502_2 (ref), l_v1503_3 (ref), l_v1504_3 (ref), l_v1505_2 (ref), l_v1506_3 (ref), l_v1507_3 (ref), l_v1642_0 (ref), l_v1643_0 (ref)
            local v1718 = l_v1489_1:get();
            local v1719 = {};
            for v1720, v1721 in ipairs(l_v1477_2) do
                if v1720 == v1718 then
                    v1719[#v1719 + 1] = "\a{Link Active}" .. v1721;
                else
                    v1719[#v1719 + 1] = "\a{Small Text}" .. v1721;
                end;
            end;
            l_v1489_1:update(v1719);
            l_v1490_1:visibility(v1718 == 1);
            l_v1491_1:visibility(v1718 == 1);
            l_v1492_1:visibility(v1718 == 1);
            l_v1493_3:visibility(v1718 == 1);
            local v1722 = v110.tone_mapping.tonemap_available();
            l_v1499_2:visibility(v1718 == 2);
            l_l_realtime_7_2:visibility(v1718 == 2 and not v1722);
            l_v1501_2:visibility(v1718 == 2);
            l_v1502_2:visibility(v1722);
            l_v1503_3:visibility(v1722);
            l_v1504_3:visibility(v1718 == 2);
            l_v1505_2:visibility(v1718 == 2);
            l_v1506_3:visibility(v1718 == 3);
            l_v1507_3:visibility(v1718 == 3);
            l_v1642_0:visibility(v1718 == 3);
            l_v1643_0:visibility(v1718 == 3);
        end;
        l_v1489_1:set_callback(v1646, true);
        v110.tone_mapping.callback(v1646);
    end;
    l_v0_0 = function(v1723, v1724, v1725)
        local v1726 = {};
        for _, v1728 in pairs(v1723) do
            local v1729 = v1724[v1728];
            local v1730 = v1725[v1729];
            if v1730 ~= nil then
                v1726[v1729] = {
                    index = v1730.index, 
                    group = v1730.group, 
                    belongs_to = v1730.tab, 
                    author_only = v1730.author_only, 
                    reference = v1730.reference
                };
            end;
        end;
        return v1726;
    end;
    v1472 = function(v1731, v1732)
        for v1733, v1734 in pairs(v1731) do
            if v1734 == v1732 then
                return v1733;
            end;
        end;
        return nil;
    end;
    do
        local l_l_v0_0_1, l_v1472_1, l_v1477_3, l_v1489_2, l_v1490_2, l_v1492_2, l_v1499_3, l_l_realtime_7_3, l_v1501_3, l_v1502_3, l_v1503_4, l_v1504_4, l_v1505_3, l_v1506_4, l_v1507_4, l_v1642_1, l_v1643_1, l_v1646_2 = l_v0_0, v1472, v1477, v1489, v1490, v1492, v1499, l_realtime_7, v1501, v1502, v1503, v1504, v1505, v1506, v1507, v1642, v1643, v1646;
        l_v1477_3 = function(v1753, v1754, v1755)
            -- upvalues: l_v1472_1 (ref)
            return l_v1472_1(v1753, v1755) ~= nil and l_v1472_1(v1754, v1755) == nil;
        end;
        l_v1489_2 = function(v1756, v1757, v1758)
            -- upvalues: l_v1472_1 (ref)
            return l_v1472_1(v1756, v1758) == nil and l_v1472_1(v1757, v1758) ~= nil;
        end;
        l_v1490_2 = function(v1759)
            -- upvalues: l_v1385_0 (ref), v82 (ref), v0 (ref), v2 (ref)
            local v1760 = {};
            local v1761 = {};
            for v1762, v1763 in l_v1385_0(v1759) do
                local v1764 = v82(v1762:sub(0, #v0) == v0 and v2 or "browsers", string.format("%s##TAB", v1762), 0, 13, nil, "\a{Small Text}");
                v1760[#v1760 + 1] = v1764;
                local v1765 = 0;
                local v1766 = nil;
                local v1767 = nil;
                for v1768, v1769 in pairs(v1763) do
                    if v1768 ~= 1 and v1768 ~= "author_only" then
                        v1765 = v1765 + 1;
                        v1767 = v1768;
                        v1766 = v1769;
                    end;
                end;
                if v1765 == 1 and (v1765 ~= 1 or v1763.reference ~= nil) then
                    v1761[v1764] = {
                        index = #v1760, 
                        group = v1766, 
                        tab = v1763, 
                        tab_name = v1764, 
                        author_only = v1763.author_only, 
                        reference = {
                            [1] = v1762, 
                            [2] = v1767
                        }
                    };
                end;
                if v1765 > 1 or v1765 == 1 and v1763.reference == nil then
                    for v1770, v1771 in l_v1385_0(v1763) do
                        if v1770 ~= 1 and v1770 ~= "author_only" then
                            local v1772 = v82("caret-right", string.format("%s##GROUP:%s", v1770, v1762:upper()), 28, 15);
                            v1760[#v1760 + 1] = v1772;
                            v1761[v1772] = {
                                index = #v1760, 
                                group = v1771[2], 
                                tab = v1763, 
                                tab_name = v1764, 
                                author_only = v1763.author_only, 
                                reference = {
                                    [1] = v1762, 
                                    [2] = v1770
                                }
                            };
                        end;
                    end;
                end;
            end;
            return v1760, v1761;
        end;
        v1491 = string.format("\a{Link Active}%s", ui.get_icon("flask-round-potion"));
        l_v1492_2 = v82("file-magnifying-glass", "Nothing to see here...", 0, 10, nil, "\a{Small Text}");
        v1493 = ui.create(v1491, "Presets", 1);
        l_v1499_3 = ui.create(v1491, "##PRESET_INFO", 1):visibility(false);
        l_l_realtime_7_3 = ui.create(v1491, "##NOTIFICATION", 1):label(v82("circle-info", "In order to prevent config-dumping, it's made so that only the author of the config can export native tabs.", 2, 10, nil, "\aB6B665FF"));
        l_v1501_3 = ui.create(v1491, "Selection", 2):disabled(true);
        l_v1502_3 = {
            [string.format("%s Features", v0)] = {
                [1] = 1, 
                author_only = false, 
                Extra = {
                    [1] = 1, 
                    [2] = v1467.features_extra
                }, 
                Common = {
                    [1] = 2, 
                    [2] = v1467.features_common
                }, 
                Movement = {
                    [1] = 3, 
                    [2] = v1467.features_movement
                }, 
                ["Weapon Features"] = {
                    [1] = 4, 
                    [2] = v1467.features_weapons
                }
            }, 
            [string.format("%s World", v0)] = {
                [1] = 2, 
                author_only = false, 
                Ambient = {
                    [1] = 1, 
                    [2] = v1467.world_ambient
                }, 
                Removals = {
                    [1] = 2, 
                    [2] = v1467.world_removals
                }, 
                Miscellaneous = {
                    [1] = 3, 
                    [2] = v1467.world_miscellaneous
                }, 
                ["Colored Weapons"] = {
                    [1] = 4, 
                    [2] = v1467.world_colored_weapons
                }
            }, 
            [string.format("%s Other", v0)] = {
                [1] = 3, 
                author_only = false, 
                Main = {
                    [1] = 1, 
                    [2] = v1467.visuals_main
                }, 
                Other = {
                    [1] = 2, 
                    [2] = v1467.visuals_other
                }, 
                ["Player Animations"] = {
                    [1] = 3, 
                    [2] = v1467.visuals_local_player_animations
                }, 
                ["Shared Features"] = {
                    [1] = 4, 
                    [2] = v1467.visuals_shared_features
                }
            }, 
            World = {
                [1] = 4, 
                author_only = true, 
                Main = {
                    1, 
                    ui.find("Visuals", "World", "Main")
                }, 
                ["World ESP"] = {
                    2, 
                    ui.find("Visuals", "World", "World ESP")
                }, 
                Ambient = {
                    3, 
                    ui.find("Visuals", "World", "Ambient")
                }, 
                Other = {
                    4, 
                    ui.find("Visuals", "World", "Other")
                }
            }, 
            Players = {
                [1] = 5, 
                author_only = true, 
                Enemies = {
                    1, 
                    ui.find("Visuals", "Players", "Enemies")
                }, 
                Teammates = {
                    2, 
                    ui.find("Visuals", "Players", "Teammates")
                }, 
                ["Local Player"] = {
                    3, 
                    ui.find("Visuals", "Players", "Self")
                }
            }, 
            Ragebot = {
                [1] = 6, 
                author_only = true, 
                reference = ui.find("Aimbot", "Ragebot")
            }, 
            ["Anti-Aim"] = {
                [1] = 7, 
                author_only = true, 
                reference = ui.find("Aimbot", "Anti Aim")
            }, 
            Inventory = {
                [1] = 8, 
                author_only = true, 
                reference = ui.find("Visuals", "Inventory")
            }, 
            Miscellaneous = {
                [1] = 9, 
                author_only = true, 
                reference = ui.find("Miscellaneous", "Main")
            }
        };
        l_v1503_4, l_v1504_4 = l_v1490_2(l_v1502_3);
        l_v1505_3 = {
            creator = common.get_username(), 
            created_at = common.get_unixtime()
        };
        l_v1506_4 = db[v42] or {};
        l_v1507_4 = nil;
        l_v1642_1 = nil;
        l_v1643_1 = nil;
        l_v1646_2 = nil;
        local v1773 = nil;
        local v1774 = nil;
        local v1775 = nil;
        local v1776 = nil;
        local v1777 = nil;
        local v1778 = nil;
        local v1779 = nil;
        l_v1507_4 = v1493:list("##PRESET_LIST", l_v1492_2):disabled(true);
        l_v1642_1 = v1493:input(string.format("##PRESET_NAME [%s]", globals.exactframetime)):set("Default");
        l_v1643_1 = v1493:button(string.format(" \a{Text Preview}%s ", ui.get_icon("file-export")), nil, true):tooltip("\194\183 Export current settings.\n\n\194\183\a{Link Active} Please note that the settings will be exported from the current configuration, not the selected preset.");
        l_v1646_2 = v1493:button(string.format(" \a{Text Preview}%s ", ui.get_icon("download")), nil, true):tooltip("\194\183 Import current settings.\n\n\194\183\a{Link Active} Please note that the settings will be imported into the current configuration, not the selected preset.");
        v1773 = v1493:button(string.format(" \aDB6361FF%s ", ui.get_icon("trash-xmark")), nil, true):disabled(true):tooltip("\194\183 Delete preset");
        v1774 = v1493:button(string.format("  \a{Link Active}%s    \a{Text Preview}%s  ", ui.get_icon("floppy-disk"), "Save"), nil, true):tooltip("\194\183 Save preset");
        v1775 = v1493:button(string.format("  \a{Link Active}%s    \a{Text Preview}%s  ", ui.get_icon("toggle-on"), "Load"), nil, true):disabled(true):tooltip("\194\183 Load preset");
        v1778 = v1493:button(string.format("%s\aDB6361FF%s    \a{Text Preview}%s%s", string.rep(" ", 8), ui.get_icon("xmark"), "Cancel", string.rep(" ", 8)), nil, true):visibility(false);
        v1779 = v1493:button(string.format("%s\a{Link Active}%s    \a{Text Preview}%s%s", string.rep(" ", 7), ui.get_icon("check"), "Confirm", string.rep(" ", 7)), nil, true):visibility(false);
        v1776 = l_v1499_3:label(v82("user", "Unknown", 2, 13));
        v1777 = l_v1499_3:label(v82("clock", "Never", 2, 11));
        local v1780 = {};
        local function v1826(v1781)
            -- upvalues: l_v1503_4 (ref), l_v1504_4 (ref), l_v1489_2 (ref), v1780 (ref), l_v1472_1 (ref), l_v1477_3 (ref)
            local v1782 = v1781:get();
            local v1783 = v1781:get();
            for _, v1785 in ipairs(v1782) do
                local v1786 = l_v1503_4[v1785];
                local v1787 = l_v1504_4[v1786];
                if l_v1489_2(v1780, v1782, v1785) then
                    local v1788 = {};
                    for _, v1790 in ipairs(v1782) do
                        table.insert(v1788, v1790);
                    end;
                    if v1787 == nil then
                        for _, v1792 in pairs(l_v1504_4) do
                            if v1786 == v1792.tab_name then
                                table.insert(v1788, v1792.index);
                                table.insert(v1783, v1792.index);
                            end;
                        end;
                        v1781:set(v1788);
                    else
                        local v1793 = 0;
                        local v1794 = 0;
                        local l_tab_0 = v1787.tab;
                        for v1796, v1797 in pairs(l_v1504_4) do
                            if l_tab_0 == v1797.tab then
                                v1793 = v1793 + 1;
                                for _, v1799 in ipairs(v1782) do
                                    if v1796 == l_v1503_4[v1799] then
                                        v1794 = v1794 + 1;
                                    end;
                                end;
                            end;
                        end;
                        if v1793 == v1794 then
                            local v1800 = l_v1472_1(l_v1503_4, v1787.tab_name);
                            table.insert(v1788, v1800);
                            table.insert(v1783, v1800);
                            v1781:set(v1788);
                        end;
                    end;
                end;
            end;
            for _, v1802 in ipairs(v1780) do
                local v1803 = l_v1503_4[v1802];
                local v1804 = l_v1504_4[v1803];
                if l_v1477_3(v1780, v1782, v1802) then
                    local v1805 = {};
                    for _, v1807 in ipairs(v1782) do
                        table.insert(v1805, v1807);
                    end;
                    if v1804 == nil then
                        for _, v1809 in pairs(l_v1504_4) do
                            if v1803 == v1809.tab_name then
                                for v1810, v1811 in ipairs(v1805) do
                                    if v1811 == v1809.index then
                                        table.remove(v1805, v1810);
                                        break;
                                    end;
                                end;
                                for v1812, v1813 in ipairs(v1783) do
                                    if v1813 == v1809.index then
                                        table.remove(v1783, v1812);
                                        break;
                                    end;
                                end;
                            end;
                        end;
                        v1781:set(v1805);
                    else
                        local v1814 = 0;
                        local v1815 = 0;
                        local l_tab_1 = v1804.tab;
                        for v1817, v1818 in pairs(l_v1504_4) do
                            if l_tab_1 == v1818.tab then
                                v1814 = v1814 + 1;
                                for _, v1820 in ipairs(v1782) do
                                    if v1817 == l_v1503_4[v1820] then
                                        v1815 = v1815 + 1;
                                    end;
                                end;
                            end;
                        end;
                        if v1814 ~= v1815 then
                            local v1821 = l_v1472_1(l_v1503_4, v1804.tab_name);
                            for v1822, v1823 in ipairs(v1805) do
                                if v1823 == v1821 then
                                    table.remove(v1805, v1822);
                                    break;
                                end;
                            end;
                            for v1824, v1825 in ipairs(v1783) do
                                if v1825 == v1821 then
                                    table.remove(v1783, v1824);
                                    break;
                                end;
                            end;
                            v1781:set(v1805);
                        end;
                    end;
                end;
            end;
            v1780 = v1783;
        end;
        options_ref = l_v1501_3:listable(string.format("##CONFIG_OPTIONS [%s]", globals.exactframetime), l_v1503_4):set_callback(v1826, true);
        local function v1829()
            -- upvalues: l_v1507_4 (ref), l_v1492_2 (ref), l_v1378_0 (ref), l_v1506_4 (ref), l_v1505_3 (ref)
            local v1827 = l_v1507_4:get();
            local v1828 = l_v1507_4:list()[v1827];
            if v1828 == l_v1492_2 then
                preset_data = nil;
                return;
            else
                preset_data = l_v1378_0(l_v1506_4[v1828]);
                if preset_data == nil or preset_data.creator == nil then
                    preset_data = nil;
                    l_v1505_3.creator = nil;
                    l_v1505_3.created_at = nil;
                    return;
                else
                    l_v1505_3.creator = preset_data.creator;
                    l_v1505_3.created_at = preset_data.created_at;
                    return;
                end;
            end;
        end;
        local function v1835()
            -- upvalues: l_v1503_4 (ref), l_v1504_4 (ref), l_v1490_2 (ref), l_v1502_3 (ref), l_v1642_1 (ref), l_v1506_4 (ref), v1773 (ref), v1775 (ref), v1774 (ref), l_v1646_2 (ref), l_v1643_1 (ref), l_v1507_4 (ref), l_v1492_2 (ref), l_v1501_3 (ref), l_v1499_3 (ref), v1778 (ref), v1779 (ref), l_v1505_3 (ref), v1396 (ref), l_v1378_0 (ref), v1829 (ref)
            local v1830, v1831 = l_v1490_2(l_v1502_3);
            l_v1504_4 = v1831;
            l_v1503_4 = v1830;
            l_v1642_1:disabled(false);
            options_ref:update(l_v1503_4);
            options_ref:set({});
            v1830 = 0;
            for _ in pairs(l_v1506_4) do
                v1830 = v1830 + 1;
            end;
            if v1830 == 0 then
                v1773:disabled(true);
                v1775:disabled(true);
                v1774:disabled(false);
                l_v1646_2:disabled(false);
                l_v1643_1:disabled(false);
                l_v1507_4:disabled(true);
                l_v1507_4:update({
                    [1] = l_v1492_2
                });
                l_v1501_3:disabled(true);
                l_v1499_3:visibility(false);
                v1778:visibility(false);
                v1779:visibility(false);
                l_v1505_3.creator = common.get_username();
                l_v1505_3.created_at = nil;
                return;
            else
                v1831 = {};
                for v1833, v1834 in v1396(l_v1506_4) do
                    if l_v1378_0(v1834) == nil then
                        l_v1506_4[v1833] = nil;
                    else
                        v1831[#v1831 + 1] = v1833;
                    end;
                end;
                v1773:disabled(false);
                v1775:disabled(false);
                v1774:disabled(false);
                l_v1646_2:disabled(false);
                l_v1643_1:disabled(false);
                l_v1507_4:disabled(false);
                l_v1507_4:update(v1831);
                l_v1501_3:disabled(true);
                l_v1499_3:visibility(true);
                l_v1642_1:disabled(false);
                v1778:visibility(false);
                v1779:visibility(false);
                v1829();
                return;
            end;
        end;
        local v1836 = 0;
        local v1837 = 0;
        local v1838 = 0;
        local v1839 = 0;
        local v1840 = nil;
        v1773:set_callback(function()
            -- upvalues: v1838 (ref), l_v1642_1 (ref), v1779 (ref), v1778 (ref), v1773 (ref), v1775 (ref), v1774 (ref), l_v1646_2 (ref), l_v1643_1 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            if v1838 == 0 then
                v1838 = v1838 + 1;
                l_v1642_1:disabled(true);
                v1779:visibility(true);
                v1778:visibility(true);
                v1773:disabled(true);
                v1775:disabled(true);
                v1774:disabled(true);
                l_v1646_2:disabled(true);
                l_v1643_1:disabled(true);
            end;
        end);
        v1774:set_callback(function()
            -- upvalues: v18 (ref), l_v1642_1 (ref), v1836 (ref), l_v1503_4 (ref), l_v1504_4 (ref), l_v1490_2 (ref), l_v1502_3 (ref), v1779 (ref), v1778 (ref), v1773 (ref), v1775 (ref), v1774 (ref), l_v1646_2 (ref), l_v1643_1 (ref), l_v1499_3 (ref), l_v1501_3 (ref), l_v1505_3 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            v18(#l_v1642_1:get():gsub(" ", "") > 0, "The preset name cannot be empty.");
            if v1836 == 0 then
                local v1841, v1842 = l_v1490_2(l_v1502_3);
                l_v1504_4 = v1842;
                l_v1503_4 = v1841;
                v1841 = {};
                for _, v1844 in ipairs(l_v1503_4) do
                    if not v1844:find(ui.get_icon("browsers")) then
                        table.insert(v1841, v1844);
                    else
                        break;
                    end;
                end;
                v1779:visibility(true);
                v1778:visibility(true);
                v1773:disabled(true);
                v1775:disabled(true);
                v1774:disabled(true);
                l_v1646_2:disabled(true);
                l_v1643_1:disabled(true);
                l_v1499_3:visibility(true);
                l_v1501_3:disabled(false);
                options_ref:update(l_v1503_4);
                options_ref:set(v1841);
                l_v1505_3.creator = common.get_username();
                l_v1505_3.created_at = common.get_unixtime();
                v1836 = v1836 + 1;
            end;
        end);
        v1775:set_callback(function()
            -- upvalues: v1837 (ref), l_v1642_1 (ref), l_v1506_4 (ref), v18 (ref), l_v1378_0 (ref), l_v1502_3 (ref), l_v1503_4 (ref), l_v1504_4 (ref), l_v1490_2 (ref), l_v1501_3 (ref), v1780 (ref), l_v1507_4 (ref), v1773 (ref), v1774 (ref), v1775 (ref), l_v1646_2 (ref), l_v1643_1 (ref), v1779 (ref), v1778 (ref), l_v1505_3 (ref), v1840 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            if v1837 == 0 then
                local v1845 = l_v1506_4[l_v1642_1:get()];
                v18(v1845 ~= nil, "The selected preset is unavailable.");
                local v1846 = l_v1378_0(v1845);
                v18(type(v1846) == "table" and v1846.creator ~= nil, "The selected preset is corrupted.");
                local l_settings_0 = v1846.settings;
                local v1848 = {};
                for _, v1850 in pairs(l_settings_0) do
                    local v1851 = v1850[1];
                    local v1852 = v1850[2];
                    if l_v1502_3[v1851] ~= nil then
                        local v1853 = l_v1502_3[v1851];
                        if v1853[v1852] ~= nil then
                            if v1848[v1851] == nil then
                                v1848[v1851] = {};
                                v1848[v1851][1] = v1853[1];
                                v1848[v1851].author_only = v1853.author_only;
                            end;
                            v1848[v1851][v1852] = v1853[v1852];
                        end;
                    end;
                end;
                local v1854 = false;
                for _ in pairs(v1848) do
                    v1854 = true;
                end;
                v18(v1854, "The selected preset is empty.");
                local v1856, v1857 = l_v1490_2(v1848, true);
                l_v1504_4 = v1857;
                l_v1503_4 = v1856;
                v1856 = {};
                for _, v1859 in ipairs(l_v1503_4) do
                    table.insert(v1856, v1859);
                end;
                l_v1501_3:disabled(false);
                v1780 = {};
                options_ref:update(l_v1503_4);
                options_ref:set(v1856);
                l_v1507_4:disabled(true);
                l_v1642_1:disabled(true);
                l_v1501_3:disabled(false);
                v1773:disabled(true);
                v1774:disabled(true);
                v1775:disabled(true);
                l_v1646_2:disabled(true);
                l_v1643_1:disabled(true);
                v1779:visibility(true);
                v1778:visibility(true);
                l_v1505_3.creator = v1846.creator;
                l_v1505_3.created_at = v1846.created_at;
                v1837 = v1837 + 1;
                v1840 = l_settings_0;
            end;
        end);
        l_v1643_1:set_callback(function()
            -- upvalues: v1839 (ref), l_v1503_4 (ref), l_v1504_4 (ref), l_v1490_2 (ref), l_v1502_3 (ref), l_v1507_4 (ref), l_v1642_1 (ref), l_v1499_3 (ref), l_v1501_3 (ref), v1773 (ref), v1774 (ref), v1775 (ref), l_v1646_2 (ref), l_v1643_1 (ref), v1779 (ref), v1778 (ref), l_v1505_3 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            if v1839 == 0 then
                local v1860, v1861 = l_v1490_2(l_v1502_3);
                l_v1504_4 = v1861;
                l_v1503_4 = v1860;
                v1860 = {};
                for _, v1863 in ipairs(l_v1503_4) do
                    if not v1863:find(ui.get_icon("browsers")) then
                        table.insert(v1860, v1863);
                    else
                        break;
                    end;
                end;
                l_v1507_4:disabled(true);
                l_v1642_1:disabled(true);
                l_v1499_3:visibility(true);
                l_v1501_3:disabled(false);
                v1773:disabled(true);
                v1774:disabled(true);
                v1775:disabled(true);
                l_v1646_2:disabled(true);
                l_v1643_1:disabled(true);
                v1779:visibility(true);
                v1778:visibility(true);
                options_ref:update(l_v1503_4);
                options_ref:set(v1860);
                l_v1505_3.creator = common.get_username();
                l_v1505_3.created_at = common.get_unixtime();
                v1839 = v1839 + 1;
            end;
        end);
        l_v1646_2:set_callback(function()
            -- upvalues: v1837 (ref), l_clipboard_0 (ref), v18 (ref), l_v1378_0 (ref), l_v1502_3 (ref), l_v1503_4 (ref), l_v1504_4 (ref), l_v1490_2 (ref), l_v1501_3 (ref), v1780 (ref), l_v1507_4 (ref), l_v1642_1 (ref), l_v1499_3 (ref), v1773 (ref), v1774 (ref), v1775 (ref), l_v1646_2 (ref), l_v1643_1 (ref), v1779 (ref), v1778 (ref), l_v1505_3 (ref), v1840 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            if v1837 == 0 then
                local v1864 = l_clipboard_0.get();
                if v1864 == nil then
                    return;
                else
                    v18(v1864 ~= nil, "The preset is unavailable.");
                    local v1865 = l_v1378_0(v1864);
                    v18(type(v1865) == "table" and v1865.creator ~= nil, "The preset is corrupted.");
                    local l_settings_1 = v1865.settings;
                    local v1867 = {};
                    for _, v1869 in pairs(l_settings_1) do
                        local v1870 = v1869[1];
                        local v1871 = v1869[2];
                        if l_v1502_3[v1870] ~= nil then
                            local v1872 = l_v1502_3[v1870];
                            if v1872[v1871] ~= nil then
                                if v1867[v1870] == nil then
                                    v1867[v1870] = {};
                                    v1867[v1870][1] = v1872[1];
                                    v1867[v1870].author_only = v1872.author_only;
                                end;
                                v1867[v1870][v1871] = v1872[v1871];
                            end;
                        end;
                    end;
                    local v1873 = false;
                    for _ in pairs(v1867) do
                        v1873 = true;
                    end;
                    v18(v1873, "The preset is empty.");
                    local v1875, v1876 = l_v1490_2(v1867, true);
                    l_v1504_4 = v1876;
                    l_v1503_4 = v1875;
                    v1875 = {};
                    for _, v1878 in ipairs(l_v1503_4) do
                        table.insert(v1875, v1878);
                    end;
                    l_v1501_3:disabled(false);
                    v1780 = {};
                    options_ref:update(l_v1503_4);
                    options_ref:set(v1875);
                    l_v1507_4:disabled(true);
                    l_v1642_1:disabled(true);
                    l_v1499_3:visibility(true);
                    l_v1501_3:disabled(false);
                    v1773:disabled(true);
                    v1774:disabled(true);
                    v1775:disabled(true);
                    l_v1646_2:disabled(true);
                    l_v1643_1:disabled(true);
                    v1779:visibility(true);
                    v1778:visibility(true);
                    l_v1505_3.creator = v1865.creator;
                    l_v1505_3.created_at = v1865.created_at;
                    v1837 = v1837 + 1;
                    v1840 = l_settings_1;
                end;
            end;
        end);
        v1779:set_callback(function()
            -- upvalues: v18 (ref), l_v1642_1 (ref), v1838 (ref), l_v1506_4 (ref), v1835 (ref), v13 (ref), l_v1507_4 (ref), l_v1492_2 (ref), v1829 (ref), v1836 (ref), l_l_v0_0_1 (ref), l_v1503_4 (ref), l_v1504_4 (ref), v86 (ref), v1469 (ref), l_v1505_3 (ref), l_base64_0 (ref), v12 (ref), v1837 (ref), v1840 (ref), v1839 (ref), l_clipboard_0 (ref), v42 (ref)
            cvar.playvol:call("ui\\buttonrollover", 1);
            v18(#l_v1642_1:get():gsub(" ", "") > 0, "The preset name cannot be empty.");
            if v1838 == 1 then
                local v1879 = l_v1642_1:get();
                v18(l_v1506_4[v1879] ~= nil, "The selected preset is unavailable.");
                l_v1506_4[v1879] = nil;
                v1835();
                v13(string.format("Deleted preset: \a{Link Active}%s", v1879));
                cvar.playvol:call("ui\\item_drop", 1);
                utils.execute_after(0, function()
                    -- upvalues: l_v1507_4 (ref), l_v1492_2 (ref), l_v1642_1 (ref), v1829 (ref)
                    local v1880 = l_v1507_4:list()[l_v1507_4:get()];
                    if v1880 ~= l_v1492_2 then
                        l_v1642_1:set(v1880);
                    end;
                    v1829();
                end);
                v1838 = 0;
            end;
            if v1836 == 1 then
                local v1881 = l_l_v0_0_1(options_ref:get(), l_v1503_4, l_v1504_4);
                local v1882 = 0;
                local v1883 = false;
                local v1884 = {};
                for v1885, v1886 in pairs(v1881) do
                    local v1887 = v1886.author_only and v86();
                    if v1886.author_only and not v1887 then
                        v1883 = true;
                    end;
                    if not v1886.author_only or v1887 then
                        local l_reference_0 = v1886.reference;
                        local v1889 = l_reference_0[1];
                        local v1890 = l_reference_0[2];
                        if tostring(v1886.group) == "menu_group(Colored Weapons)" and v1469 ~= nil then
                            v1469:save_group();
                        end;
                        v1884[v1885] = {
                            v1889, 
                            v1890, 
                            json.parse(v1886.group:export())
                        };
                        v1882 = v1882 + 1;
                    end;
                end;
                v18(v1882 ~= 0 or not v1883, "You are not allowed to save options from configs that are not yours.");
                v18(v1882 > 0, "You have to select at least 1 item to save.");
                local v1891 = {
                    creator = common.get_username(), 
                    created_at = l_v1505_3.created_at, 
                    settings = v1884
                };
                local v1892 = l_v1642_1:get();
                l_v1506_4[v1892] = l_base64_0.encode(v12(msgpack.pack(v1891)));
                v1835();
                do
                    local l_v1892_0 = v1892;
                    utils.execute_after(0, function()
                        -- upvalues: v1836 (ref), v13 (ref), l_v1892_0 (ref), l_v1507_4 (ref)
                        v1836 = 0;
                        v13(string.format("Saved preset: \a{Link Active}%s", l_v1892_0));
                        cvar.playvol:call("ui\\item_drop", 1);
                        for v1894, v1895 in ipairs(l_v1507_4:list()) do
                            if v1895 == l_v1892_0 then
                                l_v1507_4:set(v1894);
                            end;
                        end;
                    end);
                end;
            end;
            if v1837 == 1 then
                local v1896 = l_l_v0_0_1(options_ref:get(), l_v1503_4, l_v1504_4);
                local v1897 = 0;
                local v1898 = ui.find("Visuals", "Inventory");
                if v1840 ~= nil then
                    for v1899, v1900 in pairs(v1896) do
                        local v1901 = v1840[v1899];
                        do
                            local l_v1900_0 = v1900;
                            do
                                local l_v1901_0 = v1901;
                                if l_v1901_0 ~= nil then
                                    local v1904 = tostring(l_v1900_0.group);
                                    local v1905 = v1904 == "menu_group(Colored Weapons)" and v1469 ~= nil;
                                    local v1906 = nil;
                                    if v1905 then
                                        v1906 = v1469:get_active_weapon_idx();
                                    end;
                                    local l_status_3, _ = pcall(function()
                                        -- upvalues: l_v1900_0 (ref), l_v1901_0 (ref)
                                        return l_v1900_0.group:import(json.stringify(l_v1901_0[3]));
                                    end);
                                    if l_status_3 then
                                        v1897 = v1897 + 1;
                                        if v1904 == tostring(v1898) then
                                            common.force_inventory_update();
                                        end;
                                        if v1905 ~= nil and v1906 ~= nil then
                                            v1469:load_group(v1906);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v1835();
                do
                    local l_v1897_0 = v1897;
                    utils.execute_after(0, function()
                        -- upvalues: v1837 (ref), v1840 (ref), l_v1897_0 (ref), v13 (ref)
                        v1837 = 0;
                        v1840 = nil;
                        if l_v1897_0 > 0 then
                            v13("Sucessfully loaded the preset");
                            cvar.playvol:call("ui\\item_drop", 1);
                        end;
                    end);
                end;
            end;
            if v1839 == 1 then
                local v1910 = l_l_v0_0_1(options_ref:get(), l_v1503_4, l_v1504_4);
                local v1911 = 0;
                local v1912 = false;
                local v1913 = {};
                for v1914, v1915 in pairs(v1910) do
                    local v1916 = v1915.author_only and v86();
                    if v1915.author_only and not v1916 then
                        v1912 = true;
                    end;
                    if not v1915.author_only or v1916 then
                        local l_reference_1 = v1915.reference;
                        local v1918 = l_reference_1[1];
                        local v1919 = l_reference_1[2];
                        if tostring(v1915.group) == "menu_group(Colored Weapons)" and v1469 ~= nil then
                            v1469:save_group();
                        end;
                        v1913[v1914] = {
                            v1918, 
                            v1919, 
                            json.parse(v1915.group:export())
                        };
                        v1911 = v1911 + 1;
                    end;
                end;
                v18(v1911 ~= 0 or not v1912, "You are not allowed to save options from configs that are not yours.");
                v18(v1911 > 0, "You have to select at least 1 item to save.");
                local v1920 = {
                    creator = common.get_username(), 
                    created_at = common.get_unixtime(), 
                    settings = v1913
                };
                l_clipboard_0.set(l_base64_0.encode(v12(msgpack.pack(v1920))));
                v1835();
                utils.execute_after(0, function()
                    -- upvalues: v1839 (ref), v13 (ref)
                    v1839 = 0;
                    v13("Exported settings to clipboard");
                    cvar.playvol:call("ui\\item_drop", 1);
                end);
            end;
            db[v42] = l_v1506_4;
        end);
        v1778:set_callback(function()
            -- upvalues: v1836 (ref), v1837 (ref), v1838 (ref), v1839 (ref), v1778 (ref), v1779 (ref), v1840 (ref), v1835 (ref)
            if v1836 == 0 and v1837 == 0 and v1838 == 0 and v1839 == 0 then
                v1778:visibility(false);
                v1779:visibility(false);
                return;
            else
                local v1921 = 0;
                local v1922 = 0;
                local v1923 = 0;
                v1839 = 0;
                v1838 = v1923;
                v1837 = v1922;
                v1836 = v1921;
                v1840 = nil;
                cvar.playvol:call("ui\\menu_back", 1);
                v1835();
                return;
            end;
        end);
        v1835();
        l_v1507_4:set_callback(function()
            -- upvalues: l_v1507_4 (ref), l_v1492_2 (ref), l_v1642_1 (ref), v1829 (ref)
            local v1924 = l_v1507_4:get();
            local v1925 = l_v1507_4:list()[v1924];
            if v1925 == l_v1492_2 then
                return;
            else
                l_v1642_1:set(v1925);
                v1829();
                return;
            end;
        end, true);
        v102(events.render, function()
            -- upvalues: l_v1505_3 (ref), v1405 (ref), v1776 (ref), v82 (ref), v1777 (ref), l_l_realtime_7_3 (ref), v86 (ref)
            if ui.get_alpha() <= 0.01 then
                return;
            else
                local v1926 = "Never";
                if l_v1505_3.created_at ~= nil then
                    local v1927 = common.get_unixtime() - l_v1505_3.created_at;
                    v1926 = v1405(v1927) .. (v1927 >= 1 and " ago" or "");
                end;
                v1776:name(v82("user", l_v1505_3.creator, 2, 13));
                v1777:name(v82("clock", v1926, 2, 11));
                l_l_realtime_7_3:visibility(not v86());
                return;
            end;
        end, not _DISABLE_UI_EVENTS);
        v102(events.shutdown, function()
            -- upvalues: v42 (ref), l_v1506_4 (ref)
            db[v42] = l_v1506_4;
        end, not _DISABLE_UI_EVENTS);
    end;
end;
v17("\aCC9F6CFFfinished initialization");
v17("");