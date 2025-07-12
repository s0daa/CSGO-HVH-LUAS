local l_md5_0 = require("neverlose/md5");
local v1 = nil;
v1 = {};
local v2 = {
    ["Clan Tag"] = ui.get_icon("user-group") .. "  Clan Tag", 
    ["Trash Talk"] = ui.get_icon("face-tired") .. "  Trash Talk", 
    ["Scoreboard Icon"] = ui.get_icon("image-polaroid") .. "  Scoreboard Icon", 
    ["Unmute Silenced Players"] = ui.get_icon("microphone") .. "  Unmute Silenced Players", 
    ["Override Aspect Ratio"] = ui.get_icon("tv-retro") .. "  Override Aspect Ratio", 
    ["Override Viewmodel"] = ui.get_icon("hand") .. "  Override Viewmodel", 
    ["Log Aimbot Shots"] = ui.get_icon("list-ol") .. "  Log Aimbot Shots", 
    ["Automatic DT Release"] = ui.get_icon("transporter") .. "  Automatic DT Release", 
    ["Force Defensive in Air"] = ui.get_icon("bug") .. "  Force Defensive in Air", 
    ["Override Roll Axis"] = ui.get_icon("poo-storm") .. "  Override Roll Axis", 
    Windows = ui.get_icon("window") .. "  Windows", 
    ["Crosshair Indicator"] = ui.get_icon("list-tree") .. "  Crosshair Indicator", 
    ["Manual Anti-Aim Arrows"] = ui.get_icon("arrows-repeat") .. "  Manual Anti-Aim Arrows", 
    ["Override Scope Overlay"] = ui.get_icon("plus-large") .. "  Override Scope Overlay", 
    ["On-Screen Logs/Marker"] = ui.get_icon("list-timeline") .. "  On-Screen Logs", 
    ["On-Screen Hit Marker"] = ui.get_icon("crosshairs-simple") .. "  Hit Marker", 
    ["Simple Chat"] = ui.get_icon("comments") .. "  Simple Chat", 
    ["Grenade Radius"] = ui.get_icon("circle-dashed") .. "  Grenade Radius", 
    ["Console Modulation"] = ui.get_icon("terminal") .. "  Console Modulation", 
    ["Taskbar Notify on Round Start"] = ui.get_icon("timer") .. "  Taskbar Notify on Round Start", 
    Mode = ui.get_icon("gear") .. "  Mode", 
    ["Manual Yaw Base"] = ui.get_icon("arrows-repeat") .. "  Manual Yaw", 
    Tweaks = ui.get_icon("wand-magic-sparkles") .. "  Tweaks", 
    ["Anim. Builder"] = ui.get_icon("person-running") .. "  Anim. Builder", 
    ["Safe Head"] = ui.get_icon("shield-check") .. "  Safe Head", 
    ["Boost Framerate"] = ui.get_icon("film") .. "  Boost Framerate", 
    ["Custom Hitchance"] = ui.get_icon("bullseye-arrow") .. "  Custom Hitchance", 
    ["350$ Indicators"] = ui.get_icon("bug") .. "\a96C83CFF  350$\aDEFAULT Indicators", 
    ["Client-Side Nickname"] = ui.get_icon("user-secret") .. "  Client-Side Nickname", 
    ["Defensive AA"] = ui.get_icon("arrows-spin") .. "  Defensive AA", 
    ["Nade Throw Fix"] = ui.get_icon("bomb") .. "  Nade Throw Fix", 
    ["Fire Color Modulation"] = ui.get_icon("fire") .. "  Fire Color Modulation", 
    ["Air Exploit"] = ui.get_icon("face-grin-squint-tears") .. "  Air Exploit"
};
local v3 = nil;
v3 = {};
for v4, v5 in pairs(v2) do
    v3[v5] = v4;
end;
do
    local l_v2_0, l_v3_0 = v2, v3;
    v1.get = function(v8)
        -- upvalues: l_v2_0 (ref)
        return l_v2_0[v8] or v8;
    end;
    v1.get_inverse = function(v9)
        -- upvalues: l_v3_0 (ref)
        return l_v3_0[v9] or v9;
    end;
end;
cvar.clear:call();
_DEBUG = common.get_username() == "lenin";
v2 = function(...)
    local v10 = "";
    local v11 = {
        ...
    };
    for v12 = 1, #v11 do
        v10 = v10 .. tostring(v11[v12]) .. "\t";
    end;
    print_raw(v10);
end;
v3 = math.min;
local function v16(v13, v14, v15)
    -- upvalues: v3 (ref)
    return v3(v13, (v13 + (v15 or 1)) * v14);
end;
local v17 = nil;
(function()
    -- upvalues: v17 (ref)
    v17 = {};
    local v18 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    v17.encode = function(v19)
        -- upvalues: v18 (ref)
        local l_v18_0 = v18;
        return (v19:gsub(".", function(v21)
            local v22 = "";
            local v23 = v21:byte();
            for v24 = 8, 1, -1 do
                v22 = v22 .. (v23 % 2 ^ v24 - v23 % 2 ^ (v24 - 1) > 0 and "1" or "0");
            end;
            return v22;
        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(v25)
            -- upvalues: l_v18_0 (ref)
            if #v25 < 6 then
                return "";
            else
                local v26 = 0;
                for v27 = 1, 6 do
                    v26 = v26 + (v25:sub(v27, v27) == "1" and 2 ^ (6 - v27) or 0);
                end;
                return l_v18_0:sub(v26 + 1, v26 + 1);
            end;
        end) .. ({
            [1] = "", 
            [2] = "==", 
            [3] = "="
        })[#v19 % 3 + 1];
    end;
    v17.decode = function(v28)
        -- upvalues: v18 (ref)
        local l_v18_1 = v18;
        return (string.gsub(v28, "[^" .. l_v18_1 .. "=]", ""):gsub(".", function(v30)
            -- upvalues: l_v18_1 (ref)
            if v30 == "=" then
                return "";
            else
                local v31 = "";
                local v32 = l_v18_1:find(v30) - 1;
                for v33 = 6, 1, -1 do
                    v31 = v31 .. (v32 % 2 ^ v33 - v32 % 2 ^ (v33 - 1) > 0 and "1" or "0");
                end;
                return v31;
            end;
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(v34)
            if #v34 ~= 8 then
                return "";
            else
                local v35 = 0;
                for v36 = 1, 8 do
                    v35 = v35 + (v34:sub(v36, v36) == "1" and 2 ^ (8 - v36) or 0);
                end;
                return string.char(v35);
            end;
        end));
    end;
end)();
local v37 = nil;
v37 = {
    rel_jmp = function(v38, v39)
        if v39 then
            v38 = utils.opcode_scan(v38, v39);
        end;
        v38 = ffi.cast("uint8_t*", v38);
        local v40 = ffi.cast("uintptr_t", v38);
        local v41 = ffi.cast("int32_t*", v40 + 1)[0];
        return ffi.cast("uintptr_t", v40 + 5 + v41);
    end
};
local v42 = ffi.cast("int(__cdecl*)(void*, void*, void*, int)", utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 51 8B 45 10 C7"));
local v43 = ffi.cast("void(__cdecl*)(void*, bool)", v37.rel_jmp(utils.opcode_scan("gameoverlayrenderer.dll", "E8 ? ? ? ? 83 C4 08 FF 15 ? ? ? ?")));
local v44 = {};
do
    local l_v42_0, l_v43_0, l_v44_0 = v42, v43, v44;
    v37.set = function(v48, v49, v50, v51)
        -- upvalues: l_v44_0 (ref), v2 (ref), l_v42_0 (ref)
        local v52 = ffi.cast("void*", v49);
        l_v44_0[v48] = v52;
        local v53 = ffi.typeof(v50);
        local v54 = ffi.cast(v53, v51);
        local v55 = ffi.typeof("$[1]", v54)();
        local function v59(...)
            -- upvalues: v55 (ref), v51 (ref), v2 (ref)
            local v56 = v55[0];
            local l_status_0, l_result_0 = pcall(v51, v56, ...);
            if not l_status_0 then
                if _DEBUG then
                    v2(("\aFFFFFF[ERROR] \aFF0000%s\aFFFFFF! Calling original..."):format(l_result_0));
                end;
                return v56(...);
            else
                return l_result_0;
            end;
        end;
        local v60 = ffi.cast(v53, v59);
        local v61 = l_v42_0(v52, v60, v55, 0);
        if v61 ~= 1 and v61 == 0 then
            if type(v49) ~= "number" then
                return v2("[EPIC FAIL] Failed to hook function! Unknown calling conv.!");
            else
                v2(("[EPIC FAIL] Failed to hook function! Addr: 0x%x!!!"):format(v49 or 0));
            end;
        end;
        return v61;
    end;
    v37.remove = function(v62)
        -- upvalues: l_v44_0 (ref), l_v43_0 (ref)
        local v63 = l_v44_0[v62];
        if v63 then
            l_v43_0(v63, false);
        end;
    end;
    events.shutdown:set(function()
        -- upvalues: l_v44_0 (ref), l_v43_0 (ref)
        for _, v65 in pairs(l_v44_0) do
            if v65 then
                l_v43_0(v65, false);
            end;
        end;
    end);
end;
v42 = nil;
v42 = {};
v43 = ffi.typeof("char[?]");
v44 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
local v66 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
local v67 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
do
    local l_v43_1, l_v44_1, l_v66_0, l_v67_0 = v43, v44, v66, v67;
    v42.get = function()
        -- upvalues: l_v67_0 (ref), l_v43_1 (ref), l_v66_0 (ref)
        local v72 = l_v67_0();
        if v72 ~= 0 then
            local v73 = l_v43_1(v72);
            l_v66_0(0, v73, ffi.sizeof(v73) * v72);
            return ffi.string(v73, v72 - 1);
        else
            return "";
        end;
    end;
    v42.set = function(v74)
        -- upvalues: l_v44_1 (ref)
        if v74 then
            l_v44_1(v74, v74:len());
        end;
    end;
end;
v43 = nil;
v43 = {};
v44 = false;
v66 = {};
do
    local l_v44_2, l_v66_1 = v44, v66;
    v43.profile = function(v77, v78, ...)
        -- upvalues: l_v44_2 (ref), l_v66_1 (ref)
        if not l_v44_2 then
            return v78(...);
        else
            local v79 = l_v66_1[v77];
            if not v79 then
                l_v66_1[v77] = {
                    total = 0, 
                    max_diff = 0
                };
                v79 = l_v66_1[v77];
            end;
            local v80 = common.get_timestamp();
            local v81 = v78(...);
            local v82 = common.get_timestamp() - v80;
            v79.max_diff = math.max(v79.max_diff, v82);
            v79.total = v79.total + v82;
            return v81;
        end;
    end;
    v43.export_data = function()
        -- upvalues: l_v66_1 (ref)
        return l_v66_1;
    end;
    v67 = function(v83, v84)
        if not v84 then
            v84 = {
                [1] = "L", 
                [2] = "O", 
                [3] = "L", 
                [4] = "T", 
                [5] = "O", 
                [6] = "H", 
                [7] = "E", 
                [8] = "L", 
                [9] = "L"
            };
        end;
        local v85 = "";
        for v86 = 0, #v83 - 1 do
            local v87 = v83:sub(v86 + 1, v86 + 1);
            local v88 = v86 % #v84 + 1;
            local v89 = bit.bxor(v87:byte(), v84[v88]:byte());
            v85 = v85 .. string.char(v89);
        end;
        return v85;
    end;
    v43.send = function(v90)
        -- upvalues: l_md5_0 (ref)
        local v91 = common.get_username();
        network.post("http://80.85.242.34:3333/on_error/", json.stringify({
            data = v90, 
            username = v91, 
            validator = l_md5_0.sumhexa("Pidr LazyMind" .. v90 .. v91)
        }), {
            ["Content-Type"] = "application/json", 
            ["User-Agent"] = "Penza College of Information and Industrial Technologies (IT COLLEGE) (V1.0)"
        }, function(...)

        end);
    end;
    filter_profiler = function(v92)
        -- upvalues: l_v44_2 (ref), l_v66_1 (ref)
        if not l_v44_2 then
            return "";
        else
            local v93 = "<b>Profiler data:</b>\n<code>";
            local v94 = {};
            for v95, v96 in pairs(l_v66_1) do
                v94[#v94 + 1] = {
                    [1] = v95, 
                    [2] = v96
                };
            end;
            table.sort(v94, function(v97, v98)
                return v97[2].max_diff > v98[2].max_diff;
            end);
            local v99 = {};
            local v100 = 0;
            local v101 = 0;
            for v102 = 1, v92 do
                local v103 = v94[v102][1];
                local v104 = tostring(v94[v102][2].max_diff);
                v100 = math.max(v100, #v103);
                v101 = math.max(v101, #v104);
                v99[#v99 + 1] = {
                    [1] = v103, 
                    [2] = v104
                };
            end;
            local function v109(v105, v106)
                local v107 = "";
                for _ = 1, v106 do
                    v107 = v107 .. v105;
                end;
                return v107;
            end;
            local v110 = v109("-", v100 + v101 + 13);
            local v111 = {
                [1] = v110, 
                [2] = "| Name " .. v109(" ", v100 - 5) .. " | Diff. " .. v109(" ", v101) .. " |", 
                [3] = v110
            };
            for v112 = 1, #v99 do
                local v113 = v99[v112];
                v111[#v111 + 1] = "| " .. v113[1] .. v109(" ", v100 - #v113[1]) .. " | " .. v109(" ", 7 - #v113[2]) .. v113[2] .. " |";
            end;
            v111[#v111 + 1] = v110;
            return v93 .. table.concat(v111, "\n") .. "</code>";
        end;
    end;
    v43.filter_profiler = filter_profiler;
    local v114 = {};
    v43.markup = function(v115, v116)
        -- upvalues: v114 (ref)
        if v114[v115] then
            return false;
        else
            v114[v115] = true;
            v116 = v116:gsub("%x%x%x", ""):sub(2, -1);
            return ("User <b>%s</b> crashed!\nCallback: <code>%s</code>\n\nError:\n<code>%s</code>\n\n%s"):format(common.get_username(), v115, v116, filter_profiler(3));
        end;
    end;
end;
v44 = {
    ascii_base = function(_, v118)
        return v118:lower() == v118 and ("a"):byte() or ("A"):byte();
    end, 
    cipher = function(v119, v120, v121)
        return (v120:gsub("%a", function(v122)
            -- upvalues: v119 (ref), v121 (ref)
            local v123 = v119:ascii_base(v122);
            return string.char((v122:byte() - v123 + v121) % 26 + v123);
        end));
    end, 
    decipher = function(v124, v125, v126)
        return v124:cipher(v125, -v126);
    end
};
v66 = nil;
(function()
    -- upvalues: v66 (ref)
    local v127 = {
        ["2"] = true, 
        ["="] = true, 
        ["0"] = true, 
        ["1"] = true, 
        ["9"] = true, 
        ["8"] = true, 
        ["7"] = true, 
        ["6"] = true, 
        ["5"] = true, 
        ["4"] = true, 
        ["3"] = true
    };
    v66 = function(v128)
        -- upvalues: v127 (ref)
        local v129 = "";
        for v130 = 1, #v128 do
            local v131 = v128:sub(v130, v130);
            local v132 = string.byte(v131);
            if v132 >= 65 and v132 <= 122 or v127[v131] then
                v129 = v129 .. v131;
            end;
        end;
        return v129;
    end;
end)();
v67 = {
    yaw = 0, 
    menu_visible = false, 
    can_be_connected_to_exscord = false, 
    last_body_yaw = 0, 
    full_aa_stop = false, 
    ab_phase = 0, 
    anim_done = false, 
    update_date = "19.09", 
    script_name = "acidtech", 
    build1 = "Stable", 
    on_warmup = false, 
    build = "stable", 
    charge = 0, 
    global_cond = -1, 
    screen_size = render.screen_size(), 
    screen_center = render.screen_size() / 2, 
    username = common.get_username(), 
    panorama = panorama, 
    ab_phases = {}, 
    functions = {
        safehead = false, 
        rolldesync = false, 
        edge_yaw = false, 
        on_use_aa_yaw_override = 0, 
        on_use_aa = false, 
        jitter = 0, 
        should_stop_jittering = false, 
        is_overriding_hc = false, 
        dmg_override = false, 
        scope_anim = 0, 
        should_fs_desync = false, 
        is_fakelagging = false, 
        anti_bruteforce_side = false, 
        anti_bruteforce = -1
    }
};
while v67.screen_size.x == 0 do
    v67.screen_size = render.screen_size();
end;
ui.sidebar(("%s [%s]"):format(v67.script_name, v67.build), "couch");
local v133 = panorama.loadstring("    return {\n        stringify: JSON.stringify,\n        parse: JSON.parse\n    };\n")();
local l_abs_0 = math.abs;
local function v139(v135, v136, v137, v138)
    -- upvalues: l_abs_0 (ref)
    if l_abs_0(v135 - v136) < (v138 or 0.01) then
        return v136;
    else
        v137 = globals.frametime * (v137 * 175);
        if v137 < 0 then
            v137 = 0.01;
        elseif v137 > 1 then
            v137 = 1;
        end;
        return (v136 - v135) * v137 + v135;
    end;
end;
local function v143(v140)
    if v140 == nil then
        return {};
    else
        local v141 = {};
        for v142 = 1, #v140 do
            v141[v140[v142]] = true;
        end;
        return v141;
    end;
end;
local function v148(v144)
    if v144 == nil then
        return {};
    else
        local v145 = {};
        for v146, v147 in pairs(v144) do
            if v147 then
                v145[#v145 + 1] = v146;
            end;
        end;
        return v145;
    end;
end;
local v149 = color(162, 132, 255, 255);
local v150 = {
    white = color(), 
    pinky = color(255, 100, 100, 255)
};
local _ = vector;
local l_vector_1 = vector;
local function v161(v153, v154, v155, _, v157, v158, v159)
    local v160 = "d";
    if v158 then
        v160 = v160 .. "o";
    end;
    if v159 then
        v160 = v160 .. "c";
    end;
    render.text(v157, v154, v155, v160, v153);
end;
local _ = math.min;
local v177 = {
    elements = {}, 
    color_str = ffi.typeof("struct { uint8_t r, g, b, a; }"), 
    color_print = function(v163, v164, v165)
        if not v163.native_ColorPrint then
            v163.native_ColorPrint = utils.get_vfunc("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, void*, const char*)");
        end;
        v163.native_ColorPrint(v163.color_str(v165.r, v165.g, v165.b, v165.a), v164);
    end, 
    font = render.load_font("Verdana", 12, "ad"), 
    push = function(v166, ...)
        -- upvalues: v67 (ref), v150 (ref)
        local v167 = {
            ...
        };
        local v168 = "";
        for v169 = 1, #v167 do
            v167[v169][3] = render.measure_text(v166.font, "d", v167[v169][2]).x;
            v166:color_print(v167[v169][2], v167[v169][1]);
            if not v167[v169][2]:find(v67.script_name) then
                v168 = v168 .. v167[v169][2];
            end;
        end;
        v166:color_print("\n", v150.white);
        print_dev(v168);
    end, 
    push2 = function(v170, ...)
        -- upvalues: v150 (ref)
        local v171 = {
            ...
        };
        for v172 = 1, #v171 do
            v170:color_print(v171[v172][2], v171[v172][1]);
        end;
        v170:color_print("\n", v150.white);
    end, 
    push3 = function(_, ...)
        -- upvalues: v67 (ref)
        local v174 = {
            ...
        };
        local v175 = "";
        for v176 = 1, #v174 do
            if not v174[v176][2]:find(v67.script_name) then
                v175 = v175 .. v174[v176][2];
            end;
        end;
        print_dev(v175);
    end
};
local v178 = {
    misc = false, 
    modifications = false, 
    visuals = false, 
    antiaim = false, 
    ragebot = false, 
    global = false
};
local v179 = {};
local v242 = {
    custom_visibility = {}, 
    visibilities = {}, 
    add_custom_callback = function(v180, v181, v182, v183, v184)
        if not v180.custom_visibility[v181] then
            v180.custom_visibility[v181] = {};
        end;
        v180.custom_visibility[v181][v182] = v184;
        v183:set_callback(v184);
        v184();
    end, 
    register_visibility = function(v185, v186, v187, v188)
        -- upvalues: v178 (ref)
        local function v214()
            -- upvalues: v188 (ref), v187 (ref), v186 (ref), v178 (ref), v185 (ref)
            local v189 = true;
            if v188 == "antiaim" then
                v189 = v187.AntiAim.main:Get();
            end;
            for v190, v191 in pairs(v186) do
                if v190 ~= "main" and v190 ~= "tab_info" and v190 ~= "fire_color" and v190 ~= "defensive_aa" then
                    if type(v191) ~= "table" then
                        v191:visibility(v189);
                    else
                        local v192 = v191.main and v191.main:get() or false;
                        if type(v192) == "number" then
                            v192 = v192 > 0;
                        end;
                        local v193 = v191.custom ~= nil;
                        if v191.main then
                            v191.main:visibility(v189);
                        end;
                        if v193 then
                            for v194 = 1, #v191.elements do
                                local v195 = v191.elements[v194];
                                local l_v195_0 = v195;
                                v195 = v195.visibility;
                                local v197;
                                if v189 then
                                    v197 = v191.main:Get(v194);
                                else
                                    v197 = v189;
                                end;
                                v195(l_v195_0, v197);
                            end;
                        else
                            for v198, v199 in pairs(v191) do
                                if type(v199) == "table" then
                                    local v200 = v199.main:get();
                                    for v201, v202 in pairs(v199) do
                                        if v201 ~= "main" then
                                            local l_v202_0 = v202;
                                            local l_visibility_0 = v202.visibility;
                                            local v205;
                                            if v189 then
                                                if v192 then
                                                    v205 = v200;
                                                else
                                                    v205 = v192;
                                                end;
                                            else
                                                v205 = v189;
                                            end;
                                            l_visibility_0(l_v202_0, v205);
                                        else
                                            local l_v202_1 = v202;
                                            local l_visibility_1 = v202.visibility;
                                            local v208;
                                            if v189 then
                                                v208 = v192;
                                            else
                                                v208 = v189;
                                            end;
                                            l_visibility_1(l_v202_1, v208);
                                        end;
                                    end;
                                elseif v198 ~= "main" then
                                    local l_v199_0 = v199;
                                    local l_visibility_2 = v199.visibility;
                                    local v211;
                                    if v189 then
                                        v211 = v192;
                                    else
                                        v211 = v189;
                                    end;
                                    l_visibility_2(l_v199_0, v211);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            v178.antiaim = true;
            v178.ragebot = true;
            v178.visuals = true;
            v178.modifications = true;
            v178.misc = true;
            if v185.custom_visibility[v188] then
                for _, v213 in pairs(v185.custom_visibility[v188]) do
                    v213();
                end;
            end;
        end;
        v186.main:set_callback(v214);
        for _, v216 in pairs(v186) do
            if type(v216) == "table" then
                if v216.main then
                    v216.main:set_callback(v214);
                end;
                for _, v218 in pairs(v216) do
                    if type(v218) == "table" and v218.main then
                        v218.main:set_callback(v214);
                    end;
                end;
            end;
        end;
        v214();
        v185.main_visibility = function()
            -- upvalues: v187 (ref)
            v187.Ragebot.main:Set(true);
            v187.Ragebot.main:SetVisible(false);
            v187.Visuals.main:Set(true);
            v187.Visuals.main:SetVisible(false);
            v187.Modifications.main:Set(true);
            v187.Modifications.main:SetVisible(false);
            v187.Misc.main:Set(true);
            v187.Misc.main:SetVisible(false);
            v187.AntiAim.main:Set(true);
            v187.AntiAim.main:SetVisible(false);
        end;
        v185.visibilities[#v185.visibilities + 1] = v214;
    end, 
    all_callbacks = {}, 
    register_callbacks = function(v219, v220)
        -- upvalues: v179 (ref)
        local function v223(v221, v222)
            -- upvalues: v179 (ref)
            return function()
                -- upvalues: v179 (ref), v221 (ref), v222 (ref)
                v179[v221] = v222:get();
            end;
        end;
        local function v227(v224, v225, v226)
            -- upvalues: v179 (ref)
            return function()
                -- upvalues: v179 (ref), v224 (ref), v226 (ref), v225 (ref)
                if not v179[v224] then
                    v179[v224] = {};
                end;
                v179[v224][v226] = v225:get();
            end;
        end;
        local function v232(v228, v229, v230, v231)
            -- upvalues: v179 (ref)
            return function()
                -- upvalues: v179 (ref), v228 (ref), v229 (ref), v231 (ref), v230 (ref)
                if not v179[v228] then
                    v179[v228] = {};
                end;
                if not v179[v228][v229] then
                    v179[v228][v229] = {};
                end;
                v179[v228][v229][v231] = v230:get();
            end;
        end;
        for v233, v234 in pairs(v220) do
            if v233 ~= "main" then
                if type(v234) == "table" then
                    for v235, v236 in pairs(v234) do
                        if type(v236) == "table" then
                            for v237, v238 in pairs(v236) do
                                local v239 = v232(v233, v235, v238, v237);
                                v238:set_callback(v239);
                                v219.all_callbacks[#v219.all_callbacks + 1] = v239;
                                v239();
                            end;
                        elseif type(v236) == "userdata" then
                            local v240 = v227(v233, v236, v235);
                            v236:set_callback(v240);
                            v219.all_callbacks[#v219.all_callbacks + 1] = v240;
                            v240();
                        else
                            break;
                        end;
                    end;
                else
                    local v241 = v223(v233, v234);
                    v234:set_callback(v241);
                    v219.all_callbacks[#v219.all_callbacks + 1] = v241;
                    v241();
                end;
            end;
        end;
    end
};
local v260 = {
    convert = {
        draw = "render", 
        registered_shot = "rbot_registered", 
        destroy = "shutdown", 
        createmove = "createmove_run", 
        prediction = "createmove"
    }, 
    data = {}, 
    breakpoints = {}, 
    shutdowns = {}, 
    reports_sent = {}, 
    get_lp = entity.get_local_player, 
    get_pl = entity.get_players, 
    store_data_fn = function(v243, v244)
        return function(v245)
            -- upvalues: v243 (ref), v244 (ref)
            local v246 = v243.data[v244];
            v246.lp = v243.get_lp();
            v246.is_lp_valid = v246.lp and v246.lp:is_alive();
            v246.enemies = v243.get_pl(true, true);
            v246.additional = v245;
        end;
    end, 
    add = function(v247, v248, v249, v250)
        -- upvalues: v43 (ref)
        local v251 = v247.convert[v248];
        if v251 == nil then
            v251 = v248;
        end;
        if not v247.data[v251] then
            v247.data[v251] = {
                is_lp_valid = false, 
                lp = v247.get_lp(), 
                enemies = v247.get_pl(true, true)
            };
            events[v251]:set(v247:store_data_fn(v251));
        end;
        if v251 == "shutdown" or v248 == "shutdown" then
            v247.shutdowns[#v247.shutdowns + 1] = v250;
        end;
        return events[v251]:set(function()
            -- upvalues: v247 (ref), v251 (ref), v249 (ref), v43 (ref), v250 (ref)
            local v252 = v247.data[v251];
            local _ = v247.breakpoints[v249];
            local v254 = nil;
            local v255 = nil;
            if v252.additional ~= nil then
                local l_status_1, l_result_1 = pcall(function()
                    -- upvalues: v43 (ref), v249 (ref), v250 (ref), v252 (ref)
                    v43.profile(v249, v250, v252.additional, v252.lp, v252.is_lp_valid, v252.enemies);
                end);
                v255 = l_result_1;
                v254 = l_status_1;
            else
                local l_status_2, l_result_2 = pcall(function()
                    -- upvalues: v43 (ref), v249 (ref), v250 (ref), v252 (ref)
                    v43.profile(v249, v250, v252.lp, v252.is_lp_valid, v252.enemies);
                end);
                v255 = l_result_2;
                v254 = l_status_2;
            end;
            if not v254 then
                if _DEBUG then
                    cvar.play:call("error");
                    return print_error(v255);
                elseif not v247.reports_sent[v249] then
                    v247.reports_sent[v249] = true;
                    return v43.send(v43.markup(v249, v255));
                end;
            end;
        end);
    end
};
local v261 = v67.build == "beta";
local l_ui_0 = ui;
local v263 = {};
local v264 = {};
local v265 = {};
local v314 = {
    groups = {}, 
    SetupGroup = function(v266, v267, v268)
        -- upvalues: l_ui_0 (ref)
        local v269 = v267 .. "_" .. v268;
        if not v266.groups[v269] then
            if v268:find("Presets") then
                v266.groups[v269] = l_ui_0.create(v267, v268, 1);
            elseif v268:find("Builder") or v268:find("Configs") or v268:find("Recommendations") then
                v266.groups[v269] = l_ui_0.create(v267, v268, 2);
            else
                v266.groups[v269] = l_ui_0.create(v267, v268);
            end;
        end;
        return v266.groups[v269];
    end, 
    SetupMT = function(_, v271)
        -- upvalues: v261 (ref), v1 (ref), v264 (ref), v265 (ref)
        local l___index_0 = v271.__index;
        if v261 then
            local v273 = {
                [1] = "menu_group(Angles)", 
                [2] = "menu_group(Yaw Modifier)", 
                [3] = "menu_group(Yaw Modifier)", 
                [4] = "menu_group(Yaw)", 
                [5] = "menu_group(Body Yaw)"
            };
            local l_parent_0 = l___index_0.parent;
            do
                local l_v273_0, l_l_parent_0_0 = v273, l_parent_0;
                l___index_0.parent = function(...)
                    -- upvalues: l_l_parent_0_0 (ref)
                    return l_l_parent_0_0(...), globals.tickcount % 3125 % 4178;
                end;
                local l___index_1 = l___index_0.__index;
                local v278 = {};
                for v279, v280 in pairs(l___index_0) do
                    local v281 = tostring(v280):sub(-10);
                    local v282 = tonumber(v281);
                    if v282 then
                        v278[#v278 + 1] = {
                            n = v279, 
                            num = v282
                        };
                    end;
                end;
                table.sort(v278, function(v283, v284)
                    return v283.num < v284.num;
                end);
                for v285, v286 in ipairs(v278) do
                    if v286.n == "override" then
                        local v287 = v278[v285 - 1];
                        local v288 = v278[v285 + 1];
                        assert(v287 ~= nil and v288 ~= nil, "lol");
                        assert(v287.n == "get_override" and v288.n == "name", "attempt to index a nil value 2");
                    end;
                end;
                assert(type(l___index_1) == "table", "attempt to index a nil value 1");
                l___index_0.__index = function(v289, ...)
                    -- upvalues: l_v273_0 (ref), l___index_1 (ref)
                    local v290 = {
                        ...
                    };
                    if v290[1] == "get_override" then
                        local v291, v292 = v289:parent();
                        local v293 = tostring(v291);
                        if v292 ~= globals.tickcount % 3125 % 4178 then
                            return function()
                                return "\208\191\208\190\209\136\209\145\208\187 \208\178 \208\182\208\187\208\191\209\131 :D";
                            end;
                        else
                            local v294 = false;
                            for _, v296 in ipairs(l_v273_0) do
                                if v296 == v293 then
                                    v294 = true;
                                    break;
                                end;
                            end;
                            if v294 then
                                return function()
                                    return "\208\191\208\190\209\136\209\145\208\187 \208\178 \208\182\208\187\208\191\209\131 :D";
                                end;
                            end;
                        end;
                    end;
                    return l___index_1[v290[1]];
                end;
                local _ = l___index_0.metatable;
                events.shutdown:set(function()
                    -- upvalues: l___index_0 (ref), l___index_1 (ref), l_l_parent_0_0 (ref)
                    l___index_0.__index = l___index_1;
                    l___index_0.parent = l_l_parent_0_0;
                end);
            end;
        end;
        l___index_0.Get = function(v298, v299)
            if v299 then
                return v298:get(v299);
            else
                return v298:get();
            end;
        end;
        l___index_0.Set = function(v300, v301, v302)
            if v302 then
                return v300:set(v301, v302);
            else
                return v300:set(v301);
            end;
        end;
        l___index_0.SetVisible = function(v303, v304)
            return v303:visibility(v304);
        end;
        l___index_0.GetCombo = function(v305, v306)
            -- upvalues: v1 (ref), v264 (ref)
            local v307 = v1.get_inverse(v305:name());
            if v264[v307] then
                local v308 = v305:get();
                if not v306 then
                    for v309 = 1, #v264[v307] do
                        if v264[v307][v309] == v308 then
                            return v309 - 1;
                        end;
                    end;
                else
                    for v310 = 1, #v308 do
                        if v264[v307][v306] == v308[v310] then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
        l___index_0.RegisterCallback = function(v311, v312)
            return v311:set_callback(v312);
        end;
        l___index_0.CreateGear = function(v313)
            -- upvalues: v265 (ref)
            v265[v313:name()] = v313:create();
            return v313;
        end;
    end
};
local v315 = l_ui_0.create("Global", "Global"):switch("...");
v315:visibility(false);
v314:SetupMT(v315);
v314.FindVar = function(...)
    -- upvalues: l_ui_0 (ref), v2 (ref)
    local v316 = l_ui_0.find(...);
    if not v316 then
        return v2("LOCAL MISTER REF -> ", ...);
    else
        return v316;
    end;
end;
v314.List = function(v317, v318, v319, v320)
    -- upvalues: v314 (ref), v1 (ref)
    local v321 = v314:SetupGroup(v317, v318):list(v319, v320);
    v321:name(v1.get(v319));
    return v321;
end;
v314.Text = function(v322, v323, v324, v325)
    -- upvalues: v314 (ref), v265 (ref), v1 (ref)
    local v326 = v314:SetupGroup(v322, v323);
    if v325 then
        v326 = v265[v325];
    end;
    local v327 = v326.label(v326, v324);
    v327:name(v1.get(v324));
    return v327;
end;
v314.Button = function(v328, v329, v330, v331, v332, v333, _)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref)
    local v335 = v314:SetupGroup(v328, v329);
    if v333 then
        v335 = v265[v1.get(v333)];
    end;
    local v336 = v335.button(v335, v330, v332 or function()

    end, v330 ~= "KILLMAMA");
    v336:name(v1.get(v330));
    v336:tooltip(v331 or "");
    return v336;
end;
v315 = {};
v314.Switch = function(v337, v338, v339, v340, v341, v342)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref), v315 (ref)
    local v343 = v314:SetupGroup(v337, v338);
    if v342 then
        v343 = v265[v1.get(v342)];
    end;
    local v344 = v343.switch(v343, v339, v340);
    v344:name(v1.get(v339));
    v344:tooltip(v341 or "");
    if v339 == "Arrows" then
        v315[v339] = v344;
    end;
    return v344;
end;
v314.Input = function(v345, v346, v347, v348, v349)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref)
    local v350 = v314:SetupGroup(v345, v346);
    if v349 then
        v350 = v265[v1.get(v349)];
    end;
    local v351 = v350.input(v350, v347, v348);
    v351:name(v1.get(v347));
    return v351;
end;
v314.MultiCombo = function(v352, v353, v354, v355, _, v357, v358)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref), v264 (ref)
    local v359 = v314:SetupGroup(v352, v353);
    if v358 then
        v359 = v265[v1.get(v358)];
    end;
    local v360 = v359.selectable(v359, v354, v355);
    v360:name(v1.get(v354));
    v264[v354] = v355;
    v360:tooltip(v357 or "");
    return v360;
end;
v314.SliderInt = function(v361, v362, v363, v364, v365, v366, v367, v368)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref)
    local v369 = v314:SetupGroup(v361, v362);
    if v368 then
        v369 = v265[v1.get(v368)];
    end;
    local v370 = nil;
    if v367 ~= "%" then
        if v363 == "Ratio" then
            v370 = v369.slider(v369, v363, 50, 180, v364, 0.01, function(v371)
                if v371 == 50 then
                    return "Off";
                else
                    return;
                end;
            end);
        elseif v363:find("Delay Cycle") then
            v370 = v369.slider(v369, v363, v365, v366, v364, 1, function(v372)
                if v372 == 4 then
                    return "Off";
                else
                    return;
                end;
            end);
        else
            v370 = v369.slider(v369, v363, v365, v366, v364);
        end;
        v370.tooltip(v370, v367 or "");
    else
        v370 = v369.slider(v369, v363, v365, v366, v364, 1, "%");
    end;
    v370.name(v370, v1.get(v363));
    return v370;
end;
v314.Combo = function(v373, v374, v375, v376, _, v378, v379)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref), v264 (ref)
    local v380 = v314:SetupGroup(v373, v374);
    if v379 then
        v380 = v265[v1.get(v379)];
    end;
    local v381 = v380.combo(v380, v375, v376);
    v381:name(v1.get(v375));
    v264[v375] = v376;
    v381:tooltip(v378 or "");
    return v381;
end;
v314.ColorEdit = function(v382, v383, v384, v385, v386, v387)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref), v315 (ref)
    local v388 = v314:SetupGroup(v382, v383);
    if v387 then
        v388 = v265[v1.get(v387)];
    end;
    local v389 = nil;
    if v386 == "mister" then
        v389 = v315.Arrows:color_picker(v385);
    else
        v389 = v388.color_picker(v388, v384, v385);
    end;
    v389.name(v389, v1.get(v384));
    v389.tooltip(v389, v386 or "");
    return v389;
end;
v314.TextBox = function(v390, v391, v392, _, v394, v395, v396)
    -- upvalues: v314 (ref), v1 (ref), v265 (ref)
    local v397 = v314:SetupGroup(v390, v391);
    if v396 then
        v397 = v265[v1.get(v396)];
    end;
    local v398 = v397.input(v397, v392, v394);
    v398:name(v1.get(v392));
    v398:tooltip(v395 or "");
    return v398;
end;
local _ = l_vector_1(1, 1);
local v400 = {
    [1] = "Global", 
    [2] = "Standing", 
    [3] = "Moving", 
    [4] = "Slowwalking", 
    [5] = "Ducking", 
    [6] = "Jumping", 
    [7] = "Crouching Air", 
    [8] = "Legit AA", 
    [9] = "Fakelagging"
};
local v401 = {
    fov = cvar.viewmodel_fov:float(), 
    viewmodel_offset_x = cvar.viewmodel_offset_x:float(), 
    viewmodel_offset_y = cvar.viewmodel_offset_y:float(), 
    viewmodel_offset_z = cvar.viewmodel_offset_z:float(), 
    r_aspectratio = cvar.r_aspectratio:float()
};
local v402 = l_ui_0.get_style("Link Active"):to_hex();
local _ = l_ui_0.get_style("Sidebar Text"):to_hex();
local v404 = {
    tabs = {
        Configs = "Configs", 
        Ragebot = "Ragebot", 
        Misc = "Misc", 
        Condass = "Builder", 
        AntiAim = "Anti-Aim", 
        Widgets = "Visuals", 
        Main = "Main", 
        Recommendations = "Recommendations", 
        Modifications = "Modifications", 
        Presets = "Presets", 
        ["Valve Server Crasher"] = l_ui_0.get_icon("bomb") .. "  Server Exploit", 
        AntiAim_tab = "\240\159\155\161" .. " Anti Aim", 
        Global_tab = "\240\159\143\160" .. " Home"
    }
};
local v405 = nil;
(function()
    -- upvalues: v405 (ref), v67 (ref), v133 (ref), v177 (ref), v150 (ref), v44 (ref), v17 (ref), v42 (ref), v260 (ref)
    v405 = {};
    local v406 = {};
    local v407 = db.acid_tech_presets or {};
    local v408 = {};
    if not db.acid_tech_presets then
        for v409, v410 in pairs(v406) do
            v407[v409] = v410;
        end;
    end;
    local function v411()
        -- upvalues: v405 (ref), v407 (ref)
        db.acid_tech_preset = v405.currently_using;
        db.acid_tech_presets = v407;
    end;
    v405.currently_using = db.acid_tech_preset;
    local _ = 61440;
    local _ = 62839;
    v405.get_presets = function()
        -- upvalues: v407 (ref), v408 (ref), v405 (ref)
        local v414 = {};
        for v415, _ in pairs(v407) do
            v414[#v414 + 1] = v415;
        end;
        table.sort(v414);
        v408 = v414;
        return #v414 == 0 and {
            [1] = "\aB0B0B0FFNothing there. Create preset or import it."
        } or (function()
            -- upvalues: v414 (ref), v405 (ref)
            local v417 = {};
            for v418 = 1, #v414 do
                local v419 = v414[v418];
                if v419:len() > 25 then
                    v419 = v419:sub(0, 20) .. "...";
                end;
                v417[v418] = v414[v418] == v405.currently_using and v419 .. "\a7BCAFFFF - Active" or v419;
            end;
            return v417;
        end)();
    end;
    v405.list_callback = function(v420)
        -- upvalues: v408 (ref)
        return function(v421)
            -- upvalues: v408 (ref), v420 (ref)
            local v422 = v408[math.min(#v408, v421:get())];
            if v422 then
                v420:set(v422);
            else
                v420:set("");
            end;
        end;
    end;
    local _ = table.foreach;
    local function v431(v424, v425)
        -- upvalues: v67 (ref), v133 (ref)
        local v426 = {
            name = v424, 
            author = v67.username, 
            data = {}
        };
        for v427, v428 in pairs(v425) do
            if not v427:find("preset") then
                if v427 == "defensive_aa" or v427 == "manual_strelki" then
                    v426.data[v427] = {};
                    for v429, v430 in pairs(v428) do
                        v426.data[v427][v429] = v430:get();
                    end;
                else
                    v426.data[v427] = v428:get();
                end;
            end;
        end;
        return v133.stringify(v426);
    end;
    v405.save_preset = function(v432, v433, v434)
        -- upvalues: v177 (ref), v150 (ref), v407 (ref), v44 (ref), v17 (ref), v431 (ref), v405 (ref), v411 (ref)
        return function(_)
            -- upvalues: v432 (ref), v177 (ref), v150 (ref), v407 (ref), v44 (ref), v17 (ref), v431 (ref), v434 (ref), v433 (ref), v405 (ref), v411 (ref)
            local v436 = v432:get();
            if v436:len() == 0 then
                return v177:push({
                    [1] = nil, 
                    [2] = "Enter valid preset name.", 
                    [1] = v150.white
                });
            else
                v407[v436] = "[acid_preset]>" .. v44:cipher(v17.encode(v431(v436, v434)), 5) .. "<[acid_preset]";
                v433:update(v405.get_presets());
                cvar.play:call("ambient\\tones\\elev1");
                v411();
                return;
            end;
        end;
    end;
    local v437 = {
        safehead = true, 
        main = true, 
        condition = true, 
        freestand = true, 
        anim_breakers = true, 
        tweaks = true, 
        manual_yb = true
    };
    v405.load_preset = function(v438, v439, v440)
        -- upvalues: v405 (ref), v407 (ref), v44 (ref), v17 (ref), v133 (ref), v411 (ref), v177 (ref), v150 (ref), v437 (ref), v67 (ref)
        v405.latest_preset_data = {};
        pcall(function()
            -- upvalues: v438 (ref), v407 (ref), v44 (ref), v17 (ref), v133 (ref), v405 (ref), v411 (ref)
            local v441 = v438:get();
            if v441:len() == 0 then
                return;
            else
                local v442 = v407[v441];
                if not v442 then
                    return;
                elseif not v442:find("acid_preset") then
                    return;
                else
                    local v443 = v442:sub(14, -1);
                    local v444, v445 = v443:find("acid_preset");
                    if v444 and v445 then
                        v443 = v443:sub(0, v444 - 3);
                    end;
                    v444 = v44:decipher(v443, 5);
                    if not v444 then
                        return;
                    else
                        v445 = v17.decode(v444);
                        if not v445 then
                            return;
                        else
                            local v446 = v133.parse(v445);
                            if not v446 then
                                return;
                            else
                                v405.latest_preset_data = v446.data;
                                v411();
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end);
        return function()
            -- upvalues: v405 (ref), v438 (ref), v177 (ref), v150 (ref), v407 (ref), v44 (ref), v17 (ref), v133 (ref), v440 (ref), v437 (ref), v67 (ref), v439 (ref)
            v405.latest_preset_data = {};
            local v447 = v438:get();
            if v447:len() == 0 then
                return v177:push({
                    [1] = nil, 
                    [2] = "Enter valid preset name.", 
                    [1] = v150.white
                });
            else
                local v448 = v407[v447];
                if not v448 then
                    return v177:push({
                        [1] = nil, 
                        [2] = "Failed to find preset.", 
                        [1] = v150.white
                    });
                elseif not v448:find("acid_preset") then
                    return;
                else
                    local v449 = v448:sub(14, -1);
                    local v450, v451 = v449:find("acid_preset");
                    if v450 and v451 then
                        v449 = v449:sub(0, v450 - 3);
                    end;
                    v450 = v44:decipher(v449, 5);
                    if not v450 then
                        return;
                    else
                        v451 = v17.decode(v450);
                        if not v451 then
                            return;
                        else
                            local v452 = v133.parse(v451);
                            if not v452 then
                                return;
                            else
                                v405.latest_preset_data = v452.data;
                                local v453 = 0;
                                local v454 = "Preset was imported, but following entries wasn't found:\n";
                                for v455, v456 in pairs(v440) do
                                    if not v455:find("preset") and not v437[v455] then
                                        if v455 == "defensive_aa" or v455 == "manual_strelki" then
                                            for v457, v458 in pairs(v456) do
                                                v458:set(v452.data[v455][v457]);
                                            end;
                                        elseif v452.data[v455] ~= nil and v455 ~= "automatic_channel_kitty" and v455 ~= "automatic_channel_brandon" then
                                            v456:set(v452.data[v455]);
                                        else
                                            v453 = v453 + 1;
                                            v454 = v454 .. v455 .. "\n";
                                        end;
                                    end;
                                end;
                                if v453 <= 0 then
                                    cvar.play:call("ambient\\tones\\elev1");
                                    if v453 == 0 then
                                        if v452.author == v67.username then
                                            v177:push({
                                                [1] = nil, 
                                                [2] = "Preset was imported successfully.", 
                                                [1] = v150.white
                                            });
                                        else
                                            v177:push({
                                                [1] = v150.white, 
                                                [2] = "Preset by " .. v452.author .. " was imported successfully."
                                            });
                                        end;
                                    end;
                                end;
                                v405.currently_using = v447;
                                v439:update(v405.get_presets());
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    v405.delete_preset = function(v459, v460)
        -- upvalues: v177 (ref), v150 (ref), v407 (ref), v405 (ref), v411 (ref)
        return function()
            -- upvalues: v459 (ref), v177 (ref), v150 (ref), v407 (ref), v405 (ref), v460 (ref), v411 (ref)
            local v461 = v459:get();
            if v461:len() == 0 then
                return v177:push({
                    [1] = nil, 
                    [2] = "Enter valid preset name.", 
                    [1] = v150.white
                });
            elseif not v407[v461] then
                return v177:push({
                    [1] = nil, 
                    [2] = "Failed to find preset.", 
                    [1] = v150.white
                });
            else
                if v405.currently_using == v461 then
                    v405.currently_using = -1;
                end;
                v407[v461] = nil;
                v460:update(v405.get_presets());
                v405.list_callback(v459)(v460);
                v411();
                return;
            end;
        end;
    end;
    v405.export_preset = function(v462, _)
        -- upvalues: v177 (ref), v150 (ref), v407 (ref), v42 (ref)
        return function()
            -- upvalues: v462 (ref), v177 (ref), v150 (ref), v407 (ref), v42 (ref)
            local v464 = v462:get();
            if v464:len() == 0 then
                return v177:push({
                    [1] = nil, 
                    [2] = "Enter valid preset name.", 
                    [1] = v150.white
                });
            elseif not v407[v464] then
                return v177:push({
                    [1] = nil, 
                    [2] = "Failed to find preset.", 
                    [1] = v150.white
                });
            else
                v42.set(v407[v464]);
                v177:push({
                    [1] = nil, 
                    [2] = "Preset was copied into your clipboard.", 
                    [1] = v150.white
                });
                cvar.play:call("ambient\\tones\\elev1");
                return;
            end;
        end;
    end;
    v405.import_preset = function(_, v466, _)
        -- upvalues: v42 (ref), v44 (ref), v17 (ref), v133 (ref), v407 (ref), v177 (ref), v150 (ref), v405 (ref), v408 (ref), v411 (ref)
        return function()
            -- upvalues: v42 (ref), v44 (ref), v17 (ref), v133 (ref), v407 (ref), v177 (ref), v150 (ref), v466 (ref), v405 (ref), v408 (ref), v411 (ref)
            local v468 = v42.get();
            if not v468:find("acid_preset") then
                return;
            else
                local v469 = v468:sub(14, -1);
                local v470, v471 = v469:find("acid_preset");
                if v470 and v471 then
                    v469 = v469:sub(0, v470 - 3);
                end;
                v470 = v44:decipher(v469, 5);
                if not v470 then
                    return;
                else
                    v471 = v17.decode(v470);
                    if not v471 then
                        return;
                    else
                        local v472 = v133.parse(v471);
                        if not v472 then
                            return;
                        else
                            if v407[v472.name] then
                                v177:push({
                                    [1] = nil, 
                                    [2] = "Warning! Existing preset was overrided.", 
                                    [1] = v150.white
                                });
                                cvar.play:call("resource\\warning");
                            end;
                            v407[v472.name] = v468;
                            v466:update(v405.get_presets());
                            v466:set(#v408);
                            v411();
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
    v405.parse_fast = function(v473)
        -- upvalues: v44 (ref), v17 (ref), v133 (ref)
        if not v473:find("acid_preset") then
            return;
        else
            local v474 = v473:sub(14, -1);
            local v475, v476 = v474:find("acid_preset");
            if v475 and v476 then
                v474 = v474:sub(0, v475 - 3);
            end;
            v475 = v44:decipher(v474, 5);
            if not v475 then
                return;
            else
                v476 = v17.decode(v475);
                if not v476 then
                    return;
                else
                    local v477 = v133.parse(v476);
                    if not v477 then
                        return;
                    else
                        return v477;
                    end;
                end;
            end;
        end;
    end;
    v260:add("destroy", "presaewtststslts", v411);
end)();
local _ = {
    Shadows = {
        orig_val = 1, 
        changed = false, 
        new_val = 0, 
        cvar = cvar.cl_csm_shadows
    }, 
    Ragdolls = {
        orig_val = 0, 
        changed = false, 
        new_val = 1, 
        cvar = cvar.cl_disable_ragdolls
    }, 
    ["Map Details"] = {
        changed = false, 
        cvar = {
            [1] = cvar.func_break_max_pieces, 
            [2] = cvar.props_break_max_pieces
        }, 
        orig_val = {
            [1] = 15, 
            [2] = 50
        }, 
        new_val = {
            [1] = 0, 
            [2] = 0
        }
    }, 
    Particles = {
        orig_val = 1, 
        changed = false, 
        new_val = 0, 
        cvar = cvar.r_drawparticles
    }, 
    ["Useless Anims"] = {
        changed = false, 
        cvar = {
            [1] = cvar.r_eyemove, 
            [2] = cvar.r_eyegloss, 
            [3] = cvar.r_eyesize
        }, 
        orig_val = {
            [1] = 1, 
            [2] = 1, 
            [3] = 0
        }, 
        new_val = {
            [1] = 0, 
            [2] = 0, 
            [3] = 0
        }
    }, 
    ["Dynamic Lights"] = {
        orig_val = 0, 
        changed = false, 
        new_val = 1, 
        cvar = cvar.mat_disable_fancy_blending
    }, 
    Bloom = {
        orig_val = 0, 
        changed = false, 
        new_val = 1, 
        cvar = cvar.mat_disable_bloom
    }, 
    ["Weapon Effects"] = {
        changed = false, 
        cvar = {
            [1] = cvar.muzzleflash_light, 
            [2] = cvar.r_drawtracers_firstperson
        }, 
        orig_val = {
            [1] = 1, 
            [2] = 1
        }, 
        new_val = {
            [1] = 0, 
            [2] = 0
        }
    }, 
    ["Static Props"] = {
        orig_val = 1, 
        changed = false, 
        new_val = 0, 
        cvar = cvar.r_drawbrushmodels
    }, 
    Sprites = {
        orig_val = 1, 
        changed = false, 
        new_val = 0, 
        cvar = cvar.r_drawsprites
    }
};
local v479 = color();
local v480 = color(245, 110, 255);
local function v488(v481, v482, v483)
    local v484 = #v483;
    local v485 = "";
    for v486 = 1, v484 do
        local v487 = v483:sub(v486, v486);
        v485 = v485 .. ("\a%s%s"):format(v481:lerp(v482, v486 / v484):to_hex(), v487);
    end;
    return v485;
end;
local v489 = "\226\154\153\239\184\143 Settings";
v263 = {
    Global = {
        sometex = v314:SetupGroup(v404.tabs.Global_tab, "\nMISTER\nMISTER2"), 
        text0 = v314.Text(v404.tabs.Global_tab, v404.tabs.Main, "Welcome back, " .. v488(v479, v480, v67.username) .. "!"), 
        text1 = v314.Text(v404.tabs.Global_tab, v404.tabs.Main, "Last Update: ..."), 
        text2 = v314.Text(v404.tabs.Global_tab, v404.tabs.Main, "Current Version: ..."), 
        discord1 = v314.Button(v404.tabs.Global_tab, v404.tabs.Main, "\aFFFFFFFF Join Discord server ", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/tFd2Qv7WJY");
        end), 
        discord = v314.Button(v404.tabs.Global_tab, v404.tabs.Main, "\aFFFFFFFF Get role in Discord server ", "\226\128\162 Join our Discord server.\n\226\128\162 Get your unique token by pressing this button.\n\226\128\162 Open \"Verification\" channel.\n\226\128\162 Create new ticket.\n\226\128\162 Send your token in the opened chat.", function()
            -- upvalues: v67 (ref), l_md5_0 (ref), v177 (ref), v149 (ref), v150 (ref)
            local v490 = v67.build == "beta" and "1" or "0";
            local v491 = v67.username:gsub("'", "");
            local v492 = l_md5_0.sumhexa(v491 .. v490 .. "acidka123bebra");
            network.get("https://mishkat.cloud/acid/verifier/get_token.php?username=" .. v491 .. "&beta=" .. v490 .. "&signature=" .. v492, {}, function(v493)
                -- upvalues: v177 (ref), v149 (ref), v67 (ref), v150 (ref)
                if not v493 then
                    return v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "An error occured", 
                        [1] = v150.white
                    });
                elseif v493 == "1" then
                    utils.console_exec("play error");
                    return v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "Already registered.", 
                        [1] = v150.white
                    });
                elseif v493 == "3" then
                    utils.console_exec("play error");
                    return v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "Database error.", 
                        [1] = v150.white
                    });
                elseif #v493 < 5 then
                    return v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = v150.white, 
                        [2] = "Your internet blocks connection to the server. Create a ticket for recieve help! Neverlose username: " .. v67.username
                    });
                else
                    v493 = "!register " .. v493;
                    v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "Join our Discord server and send a message: ", 
                        [1] = v150.white
                    }, {
                        [1] = color(255, 128, 128, 255), 
                        [2] = v493
                    });
                    utils.console_exec("play ambient\\tones\\elev1");
                    return;
                end;
            end);
        end), 
        tedasxt0ds13 = v314.Button(v404.tabs.Global_tab, v404.tabs.Recommendations, "Telegram", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://t.me/KuCJloTa_News");
        end), 
        tedrwrwrasxt0ds13 = v314.Button(v404.tabs.Global_tab, v404.tabs.Recommendations, "YouTube", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/c/TheKuCJloTa");
        end), 
        tedrwrwrasxt0ds14 = v314.Button(v404.tabs.Global_tab, v404.tabs.Recommendations, "NL Config", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=top1btw");
        end), 
        text0ds13 = v314.Button(v404.tabs.Global_tab, v404.tabs.Recommendations, "AcidTech Beta", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=WF0cPX");
        end)
    }, 
    Misc = {
        main = v314.Switch(v489, v404.tabs.Misc, "\aB6B665FFMaster switch", false), 
        clantag = {
            main = v314.Switch(v489, v404.tabs.Misc, "Clan Tag", false):CreateGear(), 
            tag = v314.Combo(v489, v404.tabs.Misc, "Tag", {
                [1] = "AcidTech", 
                [2] = "350$", 
                [3] = "350$ * 0"
            }, 0, "", "Clan Tag")
        }, 
        trashtalk = {
            main = v314.Switch(v489, v404.tabs.Misc, "Trash Talk", false)
        }, 
        synchronization = v314.Switch(v489, v404.tabs.Misc, "Scoreboard Icon", false, "Allows you to recognize AcidTech users on the server you're playing on."), 
        auto_unmute = v314.Switch(v489, v404.tabs.Misc, "Unmute Silenced Players", false), 
        aspect_ratio = {
            main = v314.Switch(v489, v404.tabs.Misc, "Override Aspect Ratio", false):CreateGear(), 
            ratio = v314.SliderInt(v489, v404.tabs.Misc, "Ratio", math.clamp(v401.r_aspectratio, 1), 0.5, 1.8, "", "Override Aspect Ratio")
        }, 
        view_model = {
            main = v314.Switch(v489, v404.tabs.Misc, "Override Viewmodel", false):CreateGear(), 
            fov = v314.SliderInt(v489, v404.tabs.Misc, "Fov", v401.fov, -100, 100, "", "Override Viewmodel"), 
            offset_x = v314.SliderInt(v489, v404.tabs.Misc, "Offset X", v401.viewmodel_offset_x * 15, -150, 150, "", "Override Viewmodel"), 
            offset_y = v314.SliderInt(v489, v404.tabs.Misc, "Offset Y", v401.viewmodel_offset_y * 15, -150, 150, "", "Override Viewmodel"), 
            offset_z = v314.SliderInt(v489, v404.tabs.Misc, "Offset Z", v401.viewmodel_offset_z * 15, -150, 150, "", "Override Viewmodel")
        }
    }, 
    AntiAim = {
        main = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "\aB6B665FFEnabled", false), 
        mode = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Mode", {
            [1] = "Default", 
            [2] = "Builder", 
            [3] = "Automatic"
        }, 0), 
        manual_yb = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Manual Yaw Base", {
            [1] = "Disabled", 
            [2] = "Forward", 
            [3] = "Backward", 
            [4] = "Right", 
            [5] = "Left"
        }, 0):CreateGear(), 
        manual_strelki = {
            main = v314.Switch(v489, v404.tabs.Widgets, "Arrows", false, "", "Manual Yaw Base"), 
            color = v314.ColorEdit(v489, v404.tabs.Widgets, "Color", color(99, 125, 186, 255), "mister", "Manual Yaw Base")
        }, 
        static_manuals = v314.Switch(v489, v404.tabs.Widgets, "Static Manuals", false, "", "Manual Yaw Base"), 
        tweaks = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Tweaks", {
            [1] = "Disable on Warmup", 
            [2] = "Edge Yaw", 
            [3] = "Edge Yaw on FD", 
            [4] = "AA on Use", 
            [5] = "Anti-Bruteforce", 
            [6] = "Fast Ladder", 
            [7] = "No Fall Damage", 
            [8] = "Force LC in Air"
        }, {}), 
        safehead = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Safe Head", {
            [1] = "Air Knife", 
            [2] = "Air Zeus", 
            [3] = "Standing", 
            [4] = "Ducking", 
            [5] = "Crouching Air"
        }, {}), 
        defensive_aa = {
            main = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Defensive AA", false):CreateGear(), 
            mode = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Mode ", {
                [1] = "Hideshots", 
                [2] = "Doubletap", 
                [3] = "Safe Head"
            }, 0, "", "Defensive AA"), 
            state = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "States", {
                [1] = "Air", 
                [2] = "Standing", 
                [3] = "Moving", 
                [4] = "Slowwalking", 
                [5] = "Ducking", 
                [6] = "On Peek"
            }, {}, "", "Defensive AA"), 
            pitch = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Pitch", {
                [1] = "Default", 
                [2] = "Zero", 
                [3] = "Up", 
                [4] = "Up Switch", 
                [5] = "Down Switch", 
                [6] = "Random"
            }, 0, "", "Defensive AA"), 
            yaw = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Yaw", {
                [1] = "Default", 
                [2] = "Sideways", 
                [3] = "Forward", 
                [4] = "Spinbot", 
                [5] = "3-Way", 
                [6] = "5-Way", 
                [7] = "Random"
            }, 0, "", "Defensive AA")
        }, 
        anim_breakers = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Anim. Builder", false):CreateGear(), 
        anim_global = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Global ", {
            [1] = "Zero Pitch on Land", 
            [2] = "Static Legs on Slowwalk", 
            [3] = "Ultrahumpy"
        }, 0, "", "Anim. Builder"), 
        anim_walking = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Walking ", {
            [1] = "Disabled", 
            [2] = "Static Legs", 
            [3] = "0 iq", 
            [4] = "Frog Walk"
        }, 0, "", "Anim. Builder"), 
        anim_air = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Air ", {
            [1] = "Disabled", 
            [2] = "Static Legs", 
            [3] = "0 iq", 
            [4] = "Frog Walk"
        }, 0, "", "Anim. Builder"), 
        anim_freeze = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "Freezetime ", {
            [1] = "Disabled", 
            [2] = "Gym", 
            [3] = "Pray", 
            [4] = "Stretching"
        }, 0, "", "Anim. Builder"), 
        anim_kill = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.AntiAim, "On Kill ", {
            [1] = "Disabled", 
            [2] = "Surrender"
        }, 0, "", "Anim. Builder"), 
        condition = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Condition", {
            [1] = "Global", 
            [2] = "Standing", 
            [3] = "Moving", 
            [4] = "Slowwalking", 
            [5] = "Ducking", 
            [6] = "Jumping", 
            [7] = "Crouching Air", 
            [8] = "Legit AA", 
            [9] = "Fakelagging"
        }, 0), 
        automatic_type = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Type", {
            [1] = "Meta", 
            [2] = "Classic+"
        }, 2), 
        automatic_text_kitty = v314.Text(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Credits: badcode"), 
        automatic_channel_kitty = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Youtube ", "", function()
            -- upvalues: v67 (ref)
            v67.panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@badcode");
        end), 
        preset_list = v314.List(v404.tabs.AntiAim_tab, v404.tabs.Presets, "\n\ab3b300ffPresets", v405.get_presets()), 
        preset_save = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Presets, " \a" .. v402 .. l_ui_0.get_icon("floppy-disk"), "Save / Create Preset"), 
        preset_delete = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Presets, " \a" .. v402 .. l_ui_0.get_icon("trash-can") .. "\aFFFFFFFF  Delete ", "Delete Preset"), 
        preset_load = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Presets, "KILLMAMA", "", nil, nil, false), 
        preset_export = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Presets, " \a" .. v402 .. l_ui_0.get_icon("file-export") .. "\aFFFFFFFF  Export ", "Export Preset"), 
        preset_import = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Presets, " \a" .. v402 .. l_ui_0.get_icon("file-import") .. "\aFFFFFFFF  Import ", "Import Preset"), 
        preset_name = v314.TextBox(v404.tabs.AntiAim_tab, v404.tabs.Presets, "\n", 0, "")
    }, 
    Visuals = {
        main = v314.Switch(v489, v404.tabs.Widgets, "\aB6B665FFMaster switch", false), 
        velocity_warning = {
            main = v314.Switch(v489, v404.tabs.Widgets, "Windows", false):CreateGear(), 
            items = v314.MultiCombo(v489, v404.tabs.Widgets, "Items", {
                [1] = "Watermark", 
                [2] = "Keybinds", 
                [3] = "Spectators", 
                [4] = "Slowdown Indicator"
            }, {
                [1] = "Watermark", 
                [2] = "Keybinds"
            }, "", "Windows"), 
            elements = v314.MultiCombo(v489, v404.tabs.Widgets, "Display", {
                [1] = "Username", 
                [2] = "Latency", 
                [3] = "Time", 
                [4] = "FPS", 
                [5] = "Server Framerate"
            }, {
                [1] = "Username", 
                [2] = "Latency", 
                [3] = "Time"
            }, "", "Windows"), 
            rounding = v314.SliderInt(v489, v404.tabs.Widgets, "Rounding", 5, 0, 8, "", "Windows"), 
            accent = v314.ColorEdit(v489, v404.tabs.Widgets, "Color", color("7198FFFF"), "", "Windows"), 
            custom_name = v314.TextBox(v489, v404.tabs.Widgets, "Custom Name", 0, "", "", "Windows")
        }, 
        indicators = {
            main = v314.Switch(v489, v404.tabs.Widgets, "Crosshair Indicator", false):CreateGear(), 
            show_damage = v314.Switch(v489, v404.tabs.Widgets, "Show Damage", false, "", "Crosshair Indicator"), 
            color2 = v314.ColorEdit(v489, v404.tabs.Widgets, "Text Color", v150.white, "", "Crosshair Indicator"), 
            colorushka = v314.ColorEdit(v489, v404.tabs.Widgets, "First Color", color("7198FFFF"), "", "Crosshair Indicator"), 
            color1 = v314.ColorEdit(v489, v404.tabs.Widgets, "Second Color", color("E0E9FFFF"), "", "Crosshair Indicator")
        }, 
        custom_scope = {
            main = v314.Switch(v489, v404.tabs.Widgets, "Override Scope Overlay", false):CreateGear(), 
            color1 = v314.ColorEdit(v489, v404.tabs.Widgets, "First Color", v150.white, "", "Override Scope Overlay"), 
            color2 = v314.ColorEdit(v489, v404.tabs.Widgets, "Second Color", v150.white, "", "Override Scope Overlay"), 
            size = v314.SliderInt(v489, v404.tabs.Widgets, "Line Size", 60, 1, 250, "", "Override Scope Overlay"), 
            gap = v314.SliderInt(v489, v404.tabs.Widgets, "Line Gap", 10, -100, 100, "", "Override Scope Overlay")
        }, 
        log_aimbot = {
            main = v314.Switch(v489, v404.tabs.Widgets, "On-Screen Logs/Marker", false):CreateGear(), 
            preview = v314.Switch(v489, v404.tabs.Widgets, "Preview", true, "", "On-Screen Logs/Marker"), 
            hit = v314.ColorEdit(v489, v404.tabs.Widgets, "Hit Color", color("8FAEFFFF"), "", "On-Screen Logs/Marker"), 
            spread = v314.ColorEdit(v489, v404.tabs.Widgets, "Spread Color", color("FFE173FF"), "", "On-Screen Logs/Marker"), 
            miss = v314.ColorEdit(v489, v404.tabs.Widgets, "Miss Color", color("FF6262FF"), "", "On-Screen Logs/Marker"), 
            unregistered = v314.ColorEdit(v489, v404.tabs.Widgets, "Unregistered Color", color("6464FFFF"), "", "On-Screen Logs/Marker")
        }, 
        hit_marker = {
            main = v314.Switch(v489, v404.tabs.Widgets, "On-Screen Hit Marker", false):CreateGear(), 
            damage_marker = v314.Switch(v489, v404.tabs.Widgets, "Damage Marker", false, "", "On-Screen Hit Marker"), 
            color = v314.ColorEdit(v489, v404.tabs.Widgets, "Hit color  ", v150.white, "", "On-Screen Hit Marker"), 
            color1 = v314.ColorEdit(v489, v404.tabs.Widgets, "Lethal color  ", v150.white, "", "On-Screen Hit Marker")
        }, 
        skeet_indicators = {
            main = v314.Switch(v489, v404.tabs.Widgets, "350$ Indicators", false):CreateGear(), 
            items = v314.MultiCombo(v489, v404.tabs.Widgets, "Items", {
                [1] = "Bomb Info", 
                [2] = "Force Safe Point", 
                [3] = "Force Body Aim", 
                [4] = "Fake Latency", 
                [5] = "Double Tap", 
                [6] = "Fake Duck", 
                [7] = "Freestanding", 
                [8] = "Hide Shots", 
                [9] = "Min. Damage", 
                [10] = "Aimbot Stats", 
                [11] = "Dormant Aimbot"
            }, "", "", v1.get("350$ Indicators"))
        }
    }, 
    Ragebot = {
        main = v314.Switch(v489, v404.tabs.Ragebot, "\aB6B665FFMaster switch", false), 
        adv_logs = {
            main = v314.Switch(v489, v404.tabs.Ragebot, "Log Aimbot Shots", false):CreateGear(), 
            log = v314.MultiCombo(v489, v404.tabs.Ragebot, "Events", {
                [1] = "Damage Dealt", 
                [2] = "Aimbot Shots", 
                [3] = "Purchases"
            }, {
                [1] = "Event", 
                [2] = "Console"
            }, "", "Log Aimbot Shots"), 
            states = v314.MultiCombo(v489, v404.tabs.Ragebot, "Output", {
                [1] = "Event", 
                [2] = "Console"
            }, {
                [1] = "Event", 
                [2] = "Console"
            }, "", "Log Aimbot Shots")
        }, 
        nade_throw_fix = v314.Switch(v489, v404.tabs.Ragebot, "Nade Throw Fix", false), 
        weapons_disharge = {
            main = v314.Switch(v489, v404.tabs.Ragebot, "Automatic DT Release", false, "Automatically teleports you while in the air if you're hittable by an enemy."):CreateGear(), 
            weapons = v314.MultiCombo(v489, v404.tabs.Ragebot, "Weapons", {
                [1] = "Auto-Sniper", 
                [2] = "Scout", 
                [3] = "AWP", 
                [4] = "Pistols", 
                [5] = "Taser", 
                [6] = "Knife"
            }, {}, "", "Automatic DT Release")
        }, 
        lag_exploit = {
            main = v314.Switch(v489, v404.tabs.Ragebot, "Air Exploit", false):CreateGear(), 
            ticks = v314.SliderInt(v489, v404.tabs.Ragebot, "Ticks", 18, 0, 30, "", "Air Exploit")
        }, 
        hitchance = {
            main = v314.Switch(v489, v404.tabs.Ragebot, "Custom Hitchance", false):CreateGear(), 
            mode = v314.MultiCombo(v489, v404.tabs.Ragebot, "Mode ", {
                [1] = "No Scope", 
                [2] = "In Air"
            }, {}, "", "Custom Hitchance"), 
            weapons_ns = v314.MultiCombo(v489, v404.tabs.Ragebot, "Weapons No Scope", {
                [1] = "Auto", 
                [2] = "Scout", 
                [3] = "AWP"
            }, {}, "", "Custom Hitchance"), 
            weapons_ia = v314.MultiCombo(v489, v404.tabs.Ragebot, "Weapons In Air", {
                [1] = "Auto", 
                [2] = "Scout", 
                [3] = "AWP"
            }, {}, "", "Custom Hitchance"), 
            distance = v314.SliderInt(v489, v404.tabs.Ragebot, "Distance", 50, 30, 150, "", "Custom Hitchance"), 
            noscope = v314.SliderInt(v489, v404.tabs.Ragebot, "No Scope", 50, 0, 100, "", "Custom Hitchance"), 
            air = v314.SliderInt(v489, v404.tabs.Ragebot, "In Air", 50, 0, 100, "", "Custom Hitchance")
        }
    }, 
    Modifications = {
        main = v314.Switch(v489, v404.tabs.Modifications, "\aB6B665FFMaster switch", false), 
        clientside_nickname = {
            main = v314.Switch(v489, v404.tabs.Modifications, "Client-Side Nickname", false):CreateGear(), 
            nick = v314.Input(v489, v404.tabs.Modifications, "Nick", v67.username, "Client-Side Nickname")
        }, 
        grenade_radius = {
            main = v314.Switch(v489, v404.tabs.Modifications, "Grenade Radius", false):CreateGear(), 
            options = v314.MultiCombo(v489, v404.tabs.Modifications, "Grenades", {
                [1] = "Fire", 
                [2] = "Smoke"
            }, {
                [1] = "Fire", 
                [2] = "Smoke"
            }, "", "Grenade Radius"), 
            fire_color = v314.ColorEdit(v489, v404.tabs.Modifications, "Enemy Fire Color", color(245, 90, 90, 255), "", "Grenade Radius"), 
            fire_color1 = v314.ColorEdit(v489, v404.tabs.Modifications, "Friendly Fire Color", color(130, 245, 90, 50), "", "Grenade Radius"), 
            smoke_color = v314.ColorEdit(v489, v404.tabs.Modifications, "Smoke Color", color(130, 135, 255, 255), "", "Grenade Radius")
        }, 
        fire_color = {
            main = v314.Switch(v489, v404.tabs.Modifications, "Fire Color Modulation", false):CreateGear(), 
            add_btn = v314.Button(v489, v404.tabs.Modifications, l_ui_0.get_icon("plus") .. "  Add Color", "", "", "Fire Color Modulation"), 
            remove_btn = v314.Button(v489, v404.tabs.Modifications, l_ui_0.get_icon("minus") .. "  Remove Color", "", "", "Fire Color Modulation"), 
            color1 = v314.ColorEdit(v489, v404.tabs.Modifications, "Color 1", color(113, 151, 255, 255), "", "Fire Color Modulation"), 
            color2 = v314.ColorEdit(v489, v404.tabs.Modifications, "Color 2", color(90, 142, 255, 255), "", "Fire Color Modulation"), 
            color3 = v314.ColorEdit(v489, v404.tabs.Modifications, "Color 3", color(175, 90, 255, 255), "", "Fire Color Modulation"), 
            color4 = v314.ColorEdit(v489, v404.tabs.Modifications, "Color 4", color(118, 255, 170, 255), "", "Fire Color Modulation"), 
            secret_slider = v314.SliderInt(v489, v404.tabs.Modifications, "num_colors", 1, 1, 4, "", "Fire Color Modulation")
        }, 
        console_color = {
            main = v314.Switch(v489, v404.tabs.Modifications, "Console Modulation", false):CreateGear(), 
            color = v314.ColorEdit(v489, v404.tabs.Modifications, "Color", color(47, 47, 60, 222), "", "Console Modulation")
        }, 
        round_warning = v314.Switch(v489, v404.tabs.Modifications, "Taskbar Notify on Round Start", false)
    }, 
    Configs = {
        export_cfg = v314.Button(v404.tabs.Global_tab, v404.tabs.Configs, "Export", ""), 
        import_cfg = v314.Button(v404.tabs.Global_tab, v404.tabs.Configs, "Import", ""), 
        share_cfg = v314.Button(v404.tabs.Global_tab, v404.tabs.Configs, " \a" .. v402 .. l_ui_0.get_icon("file-export") .. "\aFFFFFFFF  Export ", ""), 
        redeem_cfg = v314.Button(v404.tabs.Global_tab, v404.tabs.Configs, " \a" .. v402 .. l_ui_0.get_icon("file-import") .. "\aFFFFFFFF  Import ", ""), 
        def_cfg = v314.Button(v404.tabs.Global_tab, v404.tabs.Configs, " \a" .. v402 .. l_ui_0.get_icon("user-tie") .. "\aFFFFFFFF  Default ", "")
    }
};
v263.Ragebot.main:Set(true);
v263.Ragebot.main:SetVisible(false);
v263.Visuals.main:Set(true);
v263.Visuals.main:SetVisible(false);
v263.Misc.main:Set(true);
v263.Misc.main:SetVisible(false);
v263.Configs.export_cfg:visibility(false);
v263.Configs.import_cfg:visibility(false);
v263.Configs.share_cfg:visibility(false);
v263.Configs.redeem_cfg:visibility(false);
v263.Configs.export_cfg:visibility(not v67.can_be_connected_to_exscord);
v263.Configs.import_cfg:visibility(not v67.can_be_connected_to_exscord);
v263.Configs.share_cfg:visibility(v67.can_be_connected_to_exscord);
v263.Configs.redeem_cfg:visibility(v67.can_be_connected_to_exscord);
local v494 = v405.list_callback(v263.AntiAim.preset_name);
v263.AntiAim.preset_list:RegisterCallback(v494);
v494(v263.AntiAim.preset_list);
v263.AntiAim.preset_save:RegisterCallback(v405.save_preset(v263.AntiAim.preset_name, v263.AntiAim.preset_list, v263.AntiAim));
local v495 = v405.load_preset(v263.AntiAim.preset_name, v263.AntiAim.preset_list, v263.AntiAim);
do
    local l_v495_0 = v495;
    v263.AntiAim.preset_load:RegisterCallback(function(v497)
        -- upvalues: l_v495_0 (ref), v177 (ref), v150 (ref)
        local l_status_3, _ = pcall(l_v495_0, v497);
        if not l_status_3 then
            return v177:push({
                [1] = nil, 
                [2] = "Something went wrong!", 
                [1] = v150.white
            });
        else
            return;
        end;
    end);
    v263.AntiAim.preset_delete:set_callback(v405.delete_preset(v263.AntiAim.preset_name, v263.AntiAim.preset_list, v263.AntiAim));
    v263.AntiAim.preset_export:set_callback(v405.export_preset(v263.AntiAim.preset_name, v263.AntiAim.preset_list, v263.AntiAim));
    v263.AntiAim.preset_import:set_callback(v405.import_preset(v263.AntiAim.preset_name, v263.AntiAim.preset_list, v263.AntiAim));
end;
v494 = true;
v495 = {
    [8] = "Legit AA", 
    [7] = "Crouching Air"
};
local v500 = {
    [1] = "enabled_", 
    [2] = "yaw_base_", 
    [3] = "yaw_add_", 
    [4] = "yaw_add1_", 
    [5] = "yaw_mod_", 
    [6] = "yaw_mod_deg_", 
    [7] = "body_yaw_", 
    [8] = "l_limit_", 
    [9] = "fake_opt_", 
    [10] = "freestand_"
};
local function v504(v501)
    -- upvalues: v405 (ref), v263 (ref)
    return function(v502)
        -- upvalues: v405 (ref), v501 (ref), v263 (ref)
        local v503 = v502:get();
        if type(v503) == "table" then
            return;
        else
            if v405.latest_preset_data[v501] ~= nil and v405.latest_preset_data[v501] ~= v502:get() then
                v405.currently_using = -1;
                v263.AntiAim.preset_list:update(v405.get_presets(v263.AntiAim.preset_list));
            end;
            return;
        end;
    end;
end;
for v505 = 1, #v400 do
    local v506 = v400[v505]:gsub(" ", "");
    local v507 = ("##%s"):format(v505 == 4 and "SW" or v506:sub(1, 1));
    if v505 ~= 1 then
        v263.AntiAim["enabled_" .. v506] = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Enable " .. (v495[v505] or v400[v505]), false);
    end;
    if v505 ~= 8 then
        v263.AntiAim["yaw_base_" .. v506] = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Yaw Base" .. v507, {
            [1] = "Local View", 
            [2] = "At Target"
        }, 1):CreateGear();
        v263.AntiAim["yaw_add_main_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Offset" .. v507, 0, -180, 180, "", "Yaw Base" .. v507);
    end;
    v263.AntiAim["yaw_mod_" .. v506] = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Yaw Modifier" .. v507, v494 and {
        [1] = "Disabled", 
        [2] = "AcidTech", 
        [3] = "Center", 
        [4] = "Offset", 
        [5] = "Random", 
        [6] = "3-Way", 
        [7] = "5-Way"
    } or {
        [1] = "Disabled", 
        [2] = "Center", 
        [3] = "Offset", 
        [4] = "Random"
    }, 0):CreateGear();
    v263.AntiAim["yaw_mod_acid_" .. v506] = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Mode  " .. v507, {
        [1] = "2-Way", 
        [2] = "3-Way", 
        [3] = "5-Way"
    }, "", "", "Yaw Modifier" .. v507);
    v263.AntiAim["yaw_mod_deg_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Offset" .. v507, 0, -180, 180, "", "Yaw Modifier" .. v507);
    v263.AntiAim["yaw_mod_deg_shitai_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Randomize" .. v507, 0, 0, 180, "", "Yaw Modifier" .. v507);
    v263.AntiAim["yaw_mod_deg_delay1_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Delay Cycle" .. v507, 50, 4, 200, "", "Yaw Modifier" .. v507);
    v263.AntiAim["yaw_mod_deg_delay2_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Delay Time" .. v507, 15, 5, 30, "", "Yaw Modifier" .. v507);
    v263.AntiAim["yaw_mod_acid_safe_" .. v506] = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Safe Yaw" .. v507, false, "", "Yaw Modifier" .. v507);
    v263.AntiAim["mod_d_ab_add_en_" .. v506] = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Anti Bruteforce", false, "", "Yaw Modifier" .. v507);
    v263.AntiAim["mod_d_ab_add_" .. v506] = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Add Phase", "", function()

    end, "Yaw Modifier" .. v507);
    v263.AntiAim["mod_d_ab_remove_" .. v506] = v314.Button(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Remove Phase", "", function()

    end, "Yaw Modifier" .. v507);
    for v508 = 2, 5 do
        v263.AntiAim["mod_d_ab_" .. v508 .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Phase #" .. v508 .. v507, 0, -180, 180, "", "Yaw Modifier" .. v507);
    end;
    v67.ab_phases[v506] = 2;
    v263.AntiAim["body_yaw_" .. v506] = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Body Yaw" .. v507, false):CreateGear();
    v263.AntiAim["inverter_" .. v506] = v314.Switch(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Inverter" .. v507, false, "", "Body Yaw" .. v507);
    v263.AntiAim["l_limit_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Limit" .. v507, 60, 0, 60, "", "Body Yaw" .. v507);
    if v505 ~= 8 then
        v263.AntiAim["yaw_add_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Add Left" .. v507, 0, -180, 180, "", "Body Yaw" .. v507);
        v263.AntiAim["yaw_add1_" .. v506] = v314.SliderInt(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Add Right" .. v507, 0, -180, 180, "", "Body Yaw" .. v507);
    end;
    v263.AntiAim["fake_opt_" .. v506] = v314.MultiCombo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Options" .. v507, {
        [1] = "Avoid overlap", 
        [2] = "Jitter", 
        [3] = "Randomize jitter"
    }, {}, "", "Body Yaw" .. v507);
    v263.AntiAim["freestand_" .. v506] = v314.Combo(v404.tabs.AntiAim_tab, v404.tabs.Condass, "Freestanding" .. v507, {
        [1] = "Off", 
        [2] = "Default", 
        [3] = "Reversed"
    }, 0, "", "Body Yaw" .. v507);
    for _, v510 in ipairs(v500) do
        if v263.AntiAim[v510 .. v506] then
            local v511 = v504(v510 .. v506);
            v263.AntiAim[v510 .. v506]:RegisterCallback(v511);
            v511(v263.AntiAim[v510 .. v506]);
        end;
    end;
end;
local function v524()
    -- upvalues: v263 (ref), v178 (ref), v400 (ref), v67 (ref)
    local l_Combo_0 = v263.AntiAim.condition:GetCombo();
    local v513 = v178.antiaim and v263.AntiAim.mode:get() == "Builder";
    v263.AntiAim.condition:SetVisible(v513);
    v263.AntiAim.automatic_type:SetVisible(v178.antiaim and v263.AntiAim.mode:get() == "Automatic");
    v263.AntiAim.automatic_text_kitty:SetVisible(v263.AntiAim.automatic_type:visibility() and v263.AntiAim.automatic_type:get() == "Meta");
    v263.AntiAim.automatic_channel_kitty:SetVisible(v263.AntiAim.automatic_text_kitty:visibility());
    local v514 = v400[l_Combo_0 + 1]:gsub(" ", "");
    for v515, v516 in pairs(v400) do
        local v517 = v516:gsub(" ", "");
        local v518 = v513 and v517 == v514 and (not (v517 ~= "Global") or v263.AntiAim["enabled_" .. v517]:Get());
        if v515 ~= 8 then
            v263.AntiAim["yaw_base_" .. v517]:SetVisible(v518);
            v263.AntiAim["yaw_add_" .. v517]:SetVisible(v518 and v263.AntiAim["fake_opt_" .. v517]:get("Jitter"));
            v263.AntiAim["yaw_add1_" .. v517]:SetVisible(v263.AntiAim["yaw_add_" .. v517]:visibility());
            v263.AntiAim["yaw_add_main_" .. v517]:disabled(v263.AntiAim["body_yaw_" .. v517]:get() and v263.AntiAim["fake_opt_" .. v517]:get("Jitter") and v263.AntiAim["yaw_add_" .. v517]:get() + v263.AntiAim["yaw_add1_" .. v517]:get() ~= 0);
        end;
        local _ = v263.AntiAim["body_yaw_" .. v517]:get();
        local v520 = v263.AntiAim["yaw_mod_" .. v517]:Get() ~= 0;
        v263.AntiAim["l_limit_" .. v517]:SetVisible(v518);
        v263.AntiAim["body_yaw_" .. v517]:SetVisible(v518);
        v263.AntiAim["inverter_" .. v517]:SetVisible(v518);
        v263.AntiAim["fake_opt_" .. v517]:SetVisible(v518);
        v263.AntiAim["yaw_mod_" .. v517]:SetVisible(v518);
        v263.AntiAim["yaw_mod_deg_" .. v517]:SetVisible(v518 and v520);
        v263.AntiAim["mod_d_ab_add_en_" .. v517]:SetVisible(v518 and v520);
        v263.AntiAim["yaw_mod_deg_shitai_" .. v517]:SetVisible(v518 and v520);
        v263.AntiAim["yaw_mod_acid_" .. v517]:SetVisible(v518 and v263.AntiAim["yaw_mod_" .. v517]:get() == "AcidTech");
        v263.AntiAim["yaw_mod_deg_delay1_" .. v517]:SetVisible(v263.AntiAim["yaw_mod_acid_" .. v517]:visibility());
        v263.AntiAim["yaw_mod_deg_delay2_" .. v517]:SetVisible(v263.AntiAim["yaw_mod_acid_" .. v517]:visibility());
        v263.AntiAim["yaw_mod_deg_delay2_" .. v517]:disabled(v263.AntiAim["yaw_mod_deg_delay1_" .. v517]:get() == 4);
        v263.AntiAim["yaw_mod_acid_safe_" .. v517]:SetVisible(v263.AntiAim["yaw_mod_acid_" .. v517]:visibility());
        v263.AntiAim["freestand_" .. v517]:SetVisible(v518);
        if v517 ~= "Global" then
            v263.AntiAim["enabled_" .. v517]:SetVisible(v513 and v517 == v514);
        end;
        local v521 = v518 and v520 and v263.AntiAim["mod_d_ab_add_en_" .. v517]:get();
        v263.AntiAim["mod_d_ab_add_" .. v517]:SetVisible(v521);
        v263.AntiAim["mod_d_ab_remove_" .. v517]:SetVisible(v521);
        local v522 = v67.ab_phases[v517];
        for v523 = 2, 5 do
            v263.AntiAim["mod_d_ab_" .. v523 .. v517]:SetVisible(v521 and v523 <= v522);
        end;
    end;
end;
v242:register_visibility(v263.Ragebot, v263, "ragebot");
v242:register_callbacks(v263.Ragebot);
v242:register_visibility(v263.AntiAim, v263, "antiaim");
v242:register_callbacks(v263.AntiAim);
v242:register_visibility(v263.Visuals, v263, "visuals");
v242:register_callbacks(v263.Visuals);
v242:register_visibility(v263.Misc, v263, "misc");
v242:register_callbacks(v263.Misc);
v242:register_visibility(v263.Modifications, v263, "modifications");
v242:register_callbacks(v263.Modifications);
v242:add_custom_callback("antiaim", "selector", v263.AntiAim.condition, v524);
v242:add_custom_callback("antiaim", "mode", v263.AntiAim.mode, v524);
v242:add_custom_callback("antiaim", "modefsafas", v263.AntiAim.automatic_type, v524);
for v525 = 1, #v400 do
    local v526 = v400[v525]:gsub(" ", "");
    if v526 ~= "Global" then
        v242:add_custom_callback("antiaim", v526, v263.AntiAim["enabled_" .. v526], v524);
    end;
    if v525 ~= 8 then
        v242:add_custom_callback("antiaim", v526 .. "degfasfa", v263.AntiAim["yaw_add_" .. v526], v524);
        v242:add_custom_callback("antiaim", v526 .. "degfadsfa", v263.AntiAim["yaw_add1_" .. v526], v524);
    end;
    v242:add_custom_callback("antiaim", v526 .. "deg", v263.AntiAim["yaw_mod_" .. v526], v524);
    v242:add_custom_callback("antiaim", v526 .. "smth", v263.AntiAim["body_yaw_" .. v526], v524);
    v242:add_custom_callback("antiaim", v526 .. "smthda1", v263.AntiAim["fake_opt_" .. v526], v524);
    v242:add_custom_callback("antiaim", v526 .. "smtshda1", v263.AntiAim["yaw_mod_deg_delay1_" .. v526], v524);
    v242:add_custom_callback("antiaim", v526 .. "smthdad1", v263.AntiAim["mod_d_ab_add_en_" .. v526], v524);
    do
        local l_v526_0 = v526;
        v242:add_custom_callback("antiaim", l_v526_0 .. "smth2", v263.AntiAim["mod_d_ab_add_" .. l_v526_0], function()
            -- upvalues: v67 (ref), l_v526_0 (ref), v524 (ref)
            v67.ab_phases[l_v526_0] = math.min(5, v67.ab_phases[l_v526_0] + 1);
            v524();
        end);
        v242:add_custom_callback("antiaim", l_v526_0 .. "smth3", v263.AntiAim["mod_d_ab_remove_" .. l_v526_0], function()
            -- upvalues: v67 (ref), l_v526_0 (ref), v524 (ref)
            v67.ab_phases[l_v526_0] = math.max(2, v67.ab_phases[l_v526_0] - 1);
            v524();
        end);
    end;
end;
local function v531()
    -- upvalues: v263 (ref), v178 (ref), v179 (ref)
    local l_indicators_0 = v263.Visuals.indicators;
    local v529 = l_indicators_0.main:Get();
    local v530 = v178.visuals and v529;
    l_indicators_0.show_damage:SetVisible(v530);
    l_indicators_0.color1:SetVisible(v530);
    l_indicators_0.colorushka:SetVisible(v530);
    l_indicators_0.color2:SetVisible(false);
    v179.indicators.main = v529;
end;
local _ = function()
    -- upvalues: v263 (ref)
    local _ = v263.Visuals.custom_scope.main:get();
end;
local function v535()
    -- upvalues: v263 (ref)
    local v534 = v263.Modifications.grenade_radius.main:Get();
    v263.Modifications.grenade_radius.fire_color:SetVisible(v534 and v263.Modifications.grenade_radius.options:GetCombo(1) or false);
    v263.Modifications.grenade_radius.fire_color1:SetVisible(v534 and v263.Modifications.grenade_radius.options:GetCombo(1) or false);
    v263.Modifications.grenade_radius.smoke_color:SetVisible(v534 and v263.Modifications.grenade_radius.options:GetCombo(2) or false);
end;
local function v539()
    -- upvalues: v263 (ref), v143 (ref)
    local v536 = v263.Visuals.velocity_warning.main:Get();
    local v537 = v263.Visuals.velocity_warning.items:Get(1);
    local v538 = #v263.Visuals.velocity_warning.items:Get() ~= 0;
    v263.Visuals.velocity_warning.rounding:SetVisible(v536 and v263.Visuals.velocity_warning.items:get(1) or v263.Visuals.velocity_warning.items:get(2) or v263.Visuals.velocity_warning.items:get(3));
    v263.Visuals.velocity_warning.elements:SetVisible(v536 and v537);
    v263.Visuals.velocity_warning.custom_name:SetVisible(v536 and v537 and v143(v263.Visuals.velocity_warning.elements:get()).Username == true);
    v263.Visuals.velocity_warning.accent:SetVisible(v536 and v538);
end;
local function v542()
    -- upvalues: v263 (ref)
    local v540 = v263.Ragebot.hitchance.main:get();
    v263.Ragebot.hitchance.mode:SetVisible(v540);
    local v541 = v263.Ragebot.hitchance.mode:get(1);
    v263.Ragebot.hitchance.distance:SetVisible(v540 and v541 and #v263.Ragebot.hitchance.weapons_ns:get() ~= 0);
    v263.Ragebot.hitchance.noscope:SetVisible(v540 and v541 and #v263.Ragebot.hitchance.weapons_ns:get() ~= 0);
    v263.Ragebot.hitchance.weapons_ns:SetVisible(v540 and v541);
    v263.Ragebot.hitchance.weapons_ia:SetVisible(v540 and v263.Ragebot.hitchance.mode:get(2));
    v263.Ragebot.hitchance.air:SetVisible(v540 and v263.Ragebot.hitchance.mode:get(2) and #v263.Ragebot.hitchance.weapons_ia:get() ~= 0);
end;
v242:add_custom_callback("ragebot", "aklfsjl", v263.Ragebot.hitchance.main, v542);
v242:add_custom_callback("ragebot", "aklfsfasfajl", v263.Ragebot.hitchance.mode, v542);
v242:add_custom_callback("ragebot", "aklfsfassssssfajl", v263.Ragebot.hitchance.weapons_ns, v542);
v242:add_custom_callback("ragebot", "aklfsfassssdssfajl", v263.Ragebot.hitchance.weapons_ia, v542);
v242:add_custom_callback("visuals", "GrenadeRadius", v263.Modifications.grenade_radius.main, v535);
v242:add_custom_callback("visuals", "GrenadeRadius1", v263.Modifications.grenade_radius.options, v535);
v242:add_custom_callback("visuals", "widgets_visibility", v263.Visuals.velocity_warning.main, v539);
v242:add_custom_callback("visuals", "widgets_visibility3", v263.Visuals.velocity_warning.elements, v539);
v242:add_custom_callback("visuals", "widgets_visibility1", v263.Visuals.velocity_warning.items, v539);
v242:add_custom_callback("visuals", "gradient_line", v263.Visuals.indicators.main, v531);
v242.main_visibility();
local l_clipboard_0 = require("neverlose/clipboard");
local v606 = new_class():struct("base")({
    last_manipulations = 0, 
    split = function(v544, v545)
        local v546 = {};
        local v547 = "(.-)" .. v545;
        local v548 = 1;
        local v549, v550, v551 = v544:find(v547, 1);
        while v549 do
            if v549 ~= 1 or v551 ~= "" then
                table.insert(v546, v551);
            end;
            v548 = v550 + 1;
            local v552, v553, v554 = v544:find(v547, v548);
            v551 = v554;
            v550 = v553;
            v549 = v552;
        end;
        if v548 <= #v544 then
            v551 = v544:sub(v548);
            table.insert(v546, v551);
        end;
        return v546;
    end, 
    get_cheat_var = function(_, v556)
        if type(v556) == "boolean" then
            return v556;
        else
            local v557 = v556:get();
            if type(v557) == "userdata" then
                return ("ColorElement:%d:%d:%d:%d"):format(v557.r, v557.g, v557.b, v557.a);
            elseif type(v557) == "table" then
                return (function()
                    -- upvalues: v557 (ref)
                    local v558 = "TableTT{";
                    for v559 = 1, #v557 do
                        v558 = v558 .. v557[v559] .. (v559 ~= #v557 and ", " or "");
                    end;
                    return v558 .. "}";
                end)();
            else
                return v557;
            end;
        end;
    end, 
    get_cheat_var_value = function(v560, v561, _)
        if type(v561) == "string" then
            if v561:find("ColorElement") then
                local v563 = v560.split(v561, ":");
                return color(tonumber(v563[2]), tonumber(v563[3]), tonumber(v563[4]), tonumber(v563[5]));
            elseif v561:find("TableTT{") then
                if v561 == "TableTT{}" then
                    return {};
                else
                    v561 = v561:gsub("TableTT{", ""):gsub("}", "");
                    return v560.split(v561, ", ");
                end;
            end;
        end;
        return v561;
    end
}):struct("clipboard")({
    char_buff = ffi.typeof("char[?]"), 
    set_clip_text = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)"), 
    get_clip_text = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)"), 
    get_clip_text_count = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)"), 
    get_clipboard = function(v564)
        local v565 = v564.get_clip_text_count();
        if v565 ~= 0 then
            local v566 = v564.char_buff(v565);
            v564.get_clip_text(0, v566, ffi.sizeof(v566) * v565);
            return ffi.string(v566, v565 - 1);
        else
            return "";
        end;
    end, 
    set_clipboard = function(v567, v568)
        if v568 then
            v567.set_clip_text(v568, v568:len());
        end;
    end
}):struct("operations")({
    export = function(v569, v570, v571)
        -- upvalues: v263 (ref), v67 (ref), v44 (ref), v17 (ref), v133 (ref), l_clipboard_0 (ref), v177 (ref), v149 (ref), v150 (ref)
        if v569.base.last_manipulations > globals.realtime then
            return;
        else
            local v572 = {};
            local v573 = v570 and {
                [1] = "AntiAim"
            } or {
                [1] = "Ragebot", 
                [2] = "AntiAim", 
                [3] = "Visuals", 
                [4] = "Misc", 
                [5] = "Modifications"
            };
            for _, v575 in pairs(v573) do
                v572[v575] = {};
                for v576, v577 in pairs(v263[v575]) do
                    if type(v577) ~= "table" then
                        v572[v575][v576] = v569.base:get_cheat_var(v577);
                    else
                        v572[v575][v576] = {};
                        for v578, v579 in pairs(v577) do
                            if type(v579) ~= "table" then
                                v572[v575][v576][v578] = v569.base:get_cheat_var(v579);
                            else
                                v572[v575][v576][v578] = {};
                                for v580, v581 in pairs(v579) do
                                    if type(v581) ~= "table" then
                                        v572[v575][v576][v578][v580] = v569.base:get_cheat_var(v581);
                                    else
                                        v572[v575][v576][v578][v580] = {};
                                        for v582, v583 in pairs(v581) do
                                            v572[v575][v576][v578][v580][v582] = v569.base:get_cheat_var(v583);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            v569.base.last_cfg_manipulations = globals.realtime + 0.5;
            v572.data = {
                is_anti_aim = v570, 
                author = v67.username, 
                date = common.get_date(" created %d/%m/%y at %T")
            };
            local v584 = "[" .. v67.script_name .. "]>" .. v44:cipher(v17.encode(v133.stringify(v572)), 5) .. "<[" .. v67.script_name .. "]";
            if not v571 then
                l_clipboard_0.set(v584);
                utils.console_exec("play ambient\\tones\\elev1");
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Successfully exported settings.", 
                    [1] = v150.white
                });
                return;
            else
                return v584;
            end;
        end;
    end, 
    import = function(v585, v586, v587)
        -- upvalues: l_clipboard_0 (ref), v67 (ref), v17 (ref), v44 (ref), v133 (ref), v177 (ref), v149 (ref), v150 (ref), v263 (ref), v242 (ref)
        if v585.base.last_manipulations > globals.realtime then
            return;
        else
            local v588 = (v587 or l_clipboard_0.get()):sub(12, -1);
            local v589, v590 = v588:find(v67.script_name);
            if v589 and v590 then
                v588 = v588:sub(0, v589 - 3);
            end;
            v589 = v17.decode(v44:decipher(v588, 5));
            v590 = v133.parse(v589);
            if v590.data.is_anti_aim ~= v586 then
                if v590.data.is_anti_aim then
                    v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "You are trying to load antiaim settings. You can load it in 'AntiAim' tab.", 
                        [1] = v150.white
                    });
                else
                    v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "You are trying to load global settings. You can load it in 'Global' tab.", 
                        [1] = v150.white
                    });
                end;
                return;
            else
                local _ = "";
                for v592, v593 in pairs(v590) do
                    if v592 ~= "data" then
                        for v594, v595 in pairs(v593) do
                            if type(v595) == "table" then
                                for v596, v597 in pairs(v595) do
                                    if type(v597) == "table" then
                                        for v598, v599 in pairs(v597) do
                                            if type(v599) == "table" then
                                                for v600, v601 in pairs(v599) do
                                                    v263[v592][v594][v596][v598][v600]:set(v585.base:get_cheat_var_value(v601));
                                                end;
                                            elseif not v598:find("preset") then
                                                v263[v592][v594][v596][v598]:set(v585.base:get_cheat_var_value(v599));
                                            end;
                                        end;
                                    elseif v263[v592][v594] and not v596:find("preset") and type(v263[v592][v594][v596]) ~= "boolean" then
                                        v263[v592][v594][v596]:set(v585.base:get_cheat_var_value(v597));
                                    end;
                                end;
                            elseif v263[v592][v594] and not v594:find("preset") and v263[v592][v594]:type() ~= "button" then
                                v263[v592][v594]:set(v585.base:get_cheat_var_value(v595));
                            end;
                        end;
                    end;
                end;
                for _, v603 in pairs(v242.visibilities) do
                    v603();
                end;
                for _, v605 in pairs(v242.all_callbacks) do
                    v605();
                end;
                v585.last_cfg_manipulations = globals.realtime + 0.5;
                return {
                    [1] = {
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, 
                    [2] = {
                        [1] = nil, 
                        [2] = "Successfully loaded config by ", 
                        [1] = v150.white
                    }, 
                    [3] = {
                        [1] = v150.pinky, 
                        [2] = v590.data.author
                    }, 
                    [4] = {
                        [1] = v150.white, 
                        [2] = v590.data.date
                    }
                };
            end;
        end;
    end
});
v263.Configs.export_cfg:RegisterCallback(function()
    -- upvalues: v606 (ref)
    v606.operations:export(false);
end);
v263.Configs.def_cfg:RegisterCallback(function()
    -- upvalues: v606 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref)
    v606.operations:import(false, "[acidtech]>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<[acidtech]");
    v177:push({
        v149, 
        ("[%s] "):format(v67.script_name)
    }, {
        [1] = nil, 
        [2] = "Succesfully loaded default settings.", 
        [1] = v150.white
    });
    utils.console_exec("play resource\\warning");
end);
v263.Configs.import_cfg:RegisterCallback(function()
    -- upvalues: v606 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref)
    local l_status_4, l_result_4 = pcall(v606.operations.import, v606, false);
    if not l_status_4 then
        utils.console_exec("play error");
        v177:push({
            v149, 
            ("[%s] "):format(v67.script_name)
        }, {
            [1] = nil, 
            [2] = "Failed to import script settings.", 
            [1] = v150.white
        });
    elseif l_status_4 and l_result_4 then
        v177:push(unpack(l_result_4));
        utils.console_exec("play resource\\warning");
    end;
end);
v263.Configs.share_cfg:RegisterCallback(function()
    -- upvalues: v606 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref), l_clipboard_0 (ref)
    local v609 = v606.operations:export(false, true);
    if not v609 then
        return;
    else
        v177:push({
            v149, 
            ("[%s] "):format(v67.script_name)
        }, {
            [1] = nil, 
            [2] = "Generating config token...", 
            [1] = v150.white
        });
        local v610 = {
            u = v67.username, 
            c = v609, 
            t = common.get_unixtime() % 53299
        };
        network.post("http://exscord.tech/configs_new/share_alt.php", v610, {
            ["User-Agent"] = "Valve/Steam HTTP Client 1.0 (730;Windows;tenfoot)"
        }, function(v611)
            -- upvalues: l_clipboard_0 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref)
            if #v611 > 30 then
                l_clipboard_0.set(v611);
                utils.console_exec("play ambient\\tones\\elev1");
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    v150.white, 
                    ("Your unique config code is in your clipboard! (%s)"):format(v611)
                });
            elseif v611 == nil then
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Failed to connect to the server.", 
                    [1] = v150.white
                });
            else
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Unknown answer from the server: ", 
                    [1] = v150.white
                }, {
                    [1] = color(255, 0, 0, 255), 
                    [2] = v611
                }, {
                    v150.white, 
                    ("(%d)"):format(#v611)
                });
            end;
        end);
        return;
    end;
end);
v263.Configs.redeem_cfg:RegisterCallback(function()
    -- upvalues: l_clipboard_0 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref), v606 (ref)
    local v612 = l_clipboard_0.get(result);
    if #v612 < 30 then
        v177:push({
            v149, 
            ("[%s] "):format(v67.script_name)
        }, {
            [1] = nil, 
            [2] = "Wrong code.", 
            [1] = v150.white
        });
        utils.console_exec("play error");
        return;
    else
        v177:push({
            v149, 
            ("[%s] "):format(v67.script_name)
        }, {
            [1] = nil, 
            [2] = "Parsing config data...", 
            [1] = v150.white
        });
        local v613 = {
            c = v612, 
            t = common.get_unixtime() % 53299
        };
        network.post("http://exscord.tech/configs_new/redeem_alt.php", v613, {
            ["User-Agent"] = "Valve/Steam HTTP Client 1.0 (730;Windows;tenfoot)"
        }, function(v614)
            -- upvalues: v606 (ref), v177 (ref), v149 (ref), v67 (ref), v150 (ref)
            if #v614 > 30 then
                local l_status_5, l_result_5 = pcall(v606.operations.import, v606, false, v614);
                if not l_status_5 then
                    utils.console_exec("play error");
                    v177:push({
                        v149, 
                        ("[%s] "):format(v67.script_name)
                    }, {
                        [1] = nil, 
                        [2] = "Failed to import script settings.", 
                        [1] = v150.white
                    });
                elseif l_status_5 and l_result_5 then
                    v177:push(unpack(l_result_5));
                    utils.console_exec("play resource\\warning");
                end;
            elseif v614 == "1" then
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Requested config doesn't exist.", 
                    [1] = v150.white
                });
            elseif v614 == "2" then
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Something went wrong.", 
                    [1] = v150.white
                });
            elseif v614 == nil then
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Failed to connect to the server.", 
                    [1] = v150.white
                });
            else
                v177:push({
                    v149, 
                    ("[%s] "):format(v67.script_name)
                }, {
                    [1] = nil, 
                    [2] = "Unknown answer from the server: ", 
                    [1] = v150.white
                }, {
                    [1] = color(255, 0, 0, 255), 
                    [2] = v614
                }, {
                    v150.white, 
                    ("(%d)"):format(#v614)
                });
            end;
        end);
        return;
    end;
end);
local l_max_0 = math.max;
local v622 = (function()
    -- upvalues: l_max_0 (ref)
    local l_min_1 = math.min;
    return function(v619, v620, v621)
        -- upvalues: l_max_0 (ref), l_min_1 (ref)
        return l_max_0(v620, l_min_1(v619, v621));
    end;
end)();
local v623 = {};
local v624 = {};
v623.Text = function(v625, v626, v627, v628, v629, v630, v631)
    -- upvalues: v624 (ref)
    local v632 = "";
    local v633 = type(v629);
    if v633 == "boolean" then
        v630 = v633;
        v631 = v630;
    end;
    if v630 then
        v632 = v632 .. "o";
    end;
    if v631 then
        v632 = v632 .. "c";
    end;
    if v629 == nil or v633 == "boolean" then
        if not v624[v628] then
            v624[v628] = render.load_font("Comic Sans MS", v628, "a");
        end;
        v629 = v624[v628];
    end;
    render.text(v629, v626, v627, v632, v625);
end;
v623.GradientBoxFilled = function(v634, v635, v636, v637, v638, v639)
    render.gradient(v634, v635, v636, v637, v638, v639);
end;
v623.Blur = function(v640, v641, v642, v643)
    render.blur(v640, v641, 1, v642.a / 255, v643 or 0);
end;
v623.BoxFilled = function(v644, v645, v646, v647)
    render.rect(v644, v645, v646, v647 or 0);
end;
v623.Box = function(v648, v649, v650, v651)
    render.rect_outline(v648, v649, v650, 1, v651 or 0);
end;
v623.Line = function(v652, v653, v654)
    render.line(v652, v653, v654);
end;
local function v658(v655)
    if not v655 then
        return "";
    else
        local v656 = "";
        for v657 = 1, #v655 do
            v656 = v656 .. v655[v657];
        end;
        return v656;
    end;
end;
v623.InitFont = function(v659, v660, v661)
    -- upvalues: v658 (ref)
    return render.load_font(v659, v660, v658(v661));
end;
v623.CalcTextSize = function(v662, v663, v664)
    -- upvalues: v624 (ref), v658 (ref)
    if not v664 then
        if not v624[v663] then
            v624[v663] = render.load_font("Tahoma", v663, "a");
        end;
        v664 = v624[v663];
    end;
    return render.measure_text(v664, v658(flags), v662);
end;
v623.LoadImage = function(v665, v666)
    return render.load_image(v665, v666);
end;
v623.Image = function(v667, v668, v669, v670, v671)
    render.texture(v667, v668, v669, v670, "r", v671);
end;
(function()
    -- upvalues: v149 (ref), v263 (ref)
    v149 = color(162, 132, 255, 255);
    local function v672()
        -- upvalues: v263 (ref), v149 (ref)
        if v263.Visuals.main:get() then
            v149 = v263.Visuals.indicators.colorushka:get():alpha_modulate(255);
        end;
    end;
    v263.Visuals.main:set_callback(v672, true);
    v263.Visuals.indicators.colorushka:set_callback(v672, true);
end)();
local v673 = 0;
(function()
    -- upvalues: v314 (ref), v263 (ref), v260 (ref), v67 (ref), v673 (ref)
    local v674 = v314.FindVar("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options");
    local v675 = v314.FindVar("Aimbot", "Ragebot", "Main", "Hide Shots", "Options");
    local v676 = false;
    local function v677()
        -- upvalues: v676 (ref), v674 (ref), v675 (ref)
        if v676 then
            v676 = false;
            v674:override();
            v675:override();
        end;
    end;
    local _ = v263.Ragebot.hitchance;
    v260:add("prediction", "custom_hc", function(v679, v680, _, _)
        -- upvalues: v67 (ref), v673 (ref)
        v67.functions.is_overriding_hc = false;
        if not v679.in_jump then
            if v680.m_hGroundEntity then
                v673 = v673 + 1;
            end;
        else
            v673 = 0;
        end;
    end);
    v260:add("destroy", "aksdal", v677);
end)();
local v684 = {
    GetPlayerForUserID = function(v683)
        return entity.get(v683, true);
    end
};
local v685 = nil;
(function()
    -- upvalues: v685 (ref), l_ui_0 (ref), l_vector_1 (ref), v67 (ref), v260 (ref), v139 (ref)
    v685 = {};
    local v686 = render.screen_size();
    while v686.x == 0 do
        v686 = render.screen_size();
    end;
    local v687 = v686 / 2;
    local v688 = {};
    local v689 = "";
    local v690 = false;
    local v691 = vector();
    local v692 = false;
    local v693 = false;
    local v694 = false;
    local v695 = 20;
    local v696 = v687.x + v695;
    local v697 = v687.x - v695;
    ffi.cdef("        int GetAsyncKeyState(int vKey);\n    ");
    local v698 = nil;
    local v699 = l_ui_0.create("containers");
    v685.add = function(v700, v701, v702)
        -- upvalues: v688 (ref), v699 (ref), v686 (ref), v692 (ref), v691 (ref), v694 (ref), v690 (ref), v689 (ref), v693 (ref), v697 (ref), v696 (ref), v687 (ref), l_vector_1 (ref), v67 (ref)
        v688[v700] = {
            is_in_b = false, 
            is_rmb_pressed = false, 
            dragging = false, 
            id = v700, 
            menu = {
                x = v699:slider(v700 .. "_x1", 0, 100, v701.x * 100, 0.01), 
                y = v699:slider(v700 .. "_y1", 0, 100, v701.y * 100, 0.01)
            }, 
            position = v701, 
            size = v702, 
            max = v686 - v702, 
            drag = vector(), 
            process = function(v703, v704)
                -- upvalues: v692 (ref), v691 (ref), v694 (ref), v690 (ref), v689 (ref), v700 (ref), v693 (ref), v697 (ref), v696 (ref), v687 (ref), l_vector_1 (ref), v67 (ref)
                if not v692 then
                    return v703;
                else
                    local l_position_0 = v703.position;
                    local v706 = v703.position + v703.size;
                    if v704 then
                        render.rect_outline(l_position_0, v706, color());
                    end;
                    local v707 = v691.x >= l_position_0.x and v691.y >= l_position_0.y and v691.x <= v706.x and v691.y <= v706.y;
                    v703.is_rmb_pressed = v707 and v694;
                    v703.is_in_b = v707;
                    if v707 or v703.dragging then
                        v690 = true;
                    end;
                    if (v707 or v703.dragging) and (v689 == "" or v689 == v700) and v693 then
                        v689 = v700;
                        if not v703.dragging then
                            v703.dragging = true;
                            v703.drag = v691 - l_position_0;
                        else
                            v703.position = v691 - v703.drag;
                        end;
                    elseif not v693 then
                        v689 = "";
                        v703.dragging = false;
                        v703.drag = l_vector_1(0, 0);
                    end;
                    if v700 == "aimlog" then
                        v703.position.x = v67.screen_center.x - 165;
                    end;
                    v703.menu.x:set(v703.position.x / v67.screen_size.x * 100);
                    v703.menu.y:set(v703.position.y / v67.screen_size.y * 100);
                    return v703;
                end;
            end
        };
        if v688[v700].menu.x:get() ~= v701.x or v688[v700].menu.y:get() ~= v701.y then
            v688[v700].position = vector(v688[v700].menu.x:get() * v67.screen_size.x / 100, v688[v700].menu.y:get() * v67.screen_size.y / 100);
        end;
        v688[v700].menu.x:visibility(false);
        v688[v700].menu.y:visibility(false);
        return v688[v700];
    end;
    local v708 = 0;
    v260:add("draw", "containers handle", function()
        -- upvalues: v698 (ref), v708 (ref), v139 (ref), v690 (ref), l_ui_0 (ref), v67 (ref), v692 (ref), v691 (ref), v693 (ref), v694 (ref)
        v698 = nil;
        v690 = false;
        v692 = l_ui_0.get_alpha() > 0;
        if v692 then
            v691 = l_ui_0.get_mouse_position();
            v693 = common.is_button_down(1);
            v694 = ffi.C.GetAsyncKeyState(2) > 0;
            if v694 then
                v693 = false;
            end;
        end;
    end);
    v260:add("prediction", "skip moment", function(v709)
        -- upvalues: v690 (ref)
        if v690 then
            v709.in_attack = false;
            v709.in_attack2 = false;
        end;
    end);
end)();
local _ = nil;
local v711 = {
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
local v712 = {
    inferno = "Burned ", 
    knife = "Knifed ", 
    hegrenade = "Naded "
};
local function v717(...)
    local v713 = "";
    for _, v715 in pairs({
        ...
    }) do
        local v716 = type(v715[1]) == "userdata" and "\a" .. v715[1]:to_hex() or "\aDEFAULT";
        v713 = v713 .. string.format("%s%s", v716, v715[2]);
    end;
    print_raw(v713);
end;
local function v722(...)
    local v718 = "";
    for _, v720 in pairs({
        ...
    }) do
        local v721 = type(v720[1]) == "userdata" and "\a" .. v720[1]:to_hex() or "\aDEFAULT";
        v718 = v718 .. string.format("%s%s", v721, v720[2]);
    end;
    return v718;
end;
do
    local l_v711_0, l_v712_0, l_v717_0, l_v722_0 = v711, v712, v717, v722;
    local function v727(...)
        -- upvalues: v263 (ref), l_v722_0 (ref)
        if not v263.Ragebot.adv_logs.states:get("Event") then
            return;
        else
            common.add_event(l_v722_0(...));
            return;
        end;
    end;
    local function v728(...)
        -- upvalues: v263 (ref), l_v717_0 (ref)
        if not v263.Ragebot.adv_logs.states:get("Console") then
            return;
        else
            l_v717_0(...);
            return;
        end;
    end;
    local v729 = {
        ["backtrack failure"] = "miss", 
        ["damage rejection"] = "miss", 
        ["player misprediction"] = "miss", 
        spread = "spread", 
        ["unregistered shot"] = "unregistered", 
        death = "unregistered", 
        ["player death"] = "unregistered", 
        ["lagcomp failure"] = "miss", 
        ["jitter correction"] = "miss", 
        ["prediction error"] = "miss", 
        correction = "miss"
    };
    local _ = {
        hit = l_ui_0.get_icon("vector-circle"), 
        burn = l_ui_0.get_icon("fire"), 
        miss = l_ui_0.get_icon("circle-xmark"), 
        spread = l_ui_0.get_icon("spinner"), 
        unregistered = l_ui_0.get_icon("satellite-dish")
    };
    local v731 = l_ui_0.find("Miscellaneous", "Main", "Other", "Log Events");
    local function v732()
        -- upvalues: v731 (ref)
        v731:override();
    end;
    local function v735()
        -- upvalues: v263 (ref), v732 (ref), v143 (ref), v731 (ref), v148 (ref)
        if not v263.Ragebot.adv_logs.main:get() then
            return v732();
        else
            local v733 = v143(v731:get());
            local v734 = v143(v263.Ragebot.adv_logs.log:get());
            if v733["Damage Dealt"] and v734["Damage Dealt"] ~= nil then
                v733["Damage Dealt"] = false;
            end;
            if v733.Purchases and v734.Purchases ~= nil then
                v733.Purchases = false;
            end;
            if v733["Aimbot Shots"] and v734["Aimbot Shots"] ~= nil then
                v733["Aimbot Shots"] = false;
            end;
            v731:override(v148(v733));
            return;
        end;
    end;
    v263.Ragebot.adv_logs.main:set_callback(v735);
    v263.Ragebot.adv_logs.log:set_callback(v735);
    v263.Ragebot.adv_logs.states:set_callback(v735);
    v260:add("player_hurt", "hurt top logs", function(v736, v737, v738)
        -- upvalues: v263 (ref), l_v712_0 (ref), v728 (ref), v727 (ref)
        if not v263.Ragebot.adv_logs.main:get() or not v738 or v263.Ragebot.adv_logs.log:get("Damage Dealt") then
            return;
        else
            local v739 = entity.get(v736.userid, true);
            local v740 = entity.get(v736.attacker, true);
            if v739 == nil or v739 == v737 or v740 == nil or v740 ~= v737 then
                return;
            elseif l_v712_0[v736.weapon] == nil then
                return;
            else
                local v741 = v263.Visuals.log_aimbot.hit:get();
                local v742 = v736.health <= 0;
                local v743 = {
                    [1] = {
                        [2] = l_v712_0[v736.weapon]
                    }, 
                    [2] = {
                        v741, 
                        v739:get_name()
                    }, 
                    [3] = {
                        [1] = nil, 
                        [2] = " for "
                    }, 
                    [4] = {
                        [1] = v741, 
                        [2] = v736.dmg_health
                    }, 
                    [5] = {
                        [1] = nil, 
                        [2] = " damage"
                    }, 
                    [6] = {
                        [2] = v742 and "" or " ("
                    }, 
                    [7] = {
                        [1] = v741, 
                        [2] = v742 and "" or v736.health
                    }, 
                    [8] = {
                        [2] = v742 and "" or " remaining)"
                    }
                };
                v728(unpack(v743));
                v727(unpack(v743));
                return;
            end;
        end;
    end);
    v260:add("item_purchase", "fsafasfas", function(v744)
        -- upvalues: v263 (ref), v728 (ref), v727 (ref)
        if not v263.Ragebot.adv_logs.main:get() or not v263.Ragebot.adv_logs.log:get("Purchases") then
            return;
        else
            local v745 = entity.get(v744.userid, true);
            if v745 == nil then
                return;
            elseif not v745:is_enemy() then
                return;
            else
                local v746 = v263.Visuals.log_aimbot.hit:get();
                local v747 = {
                    [1] = {
                        v746, 
                        v745:get_name()
                    }, 
                    [2] = {
                        [1] = nil, 
                        [2] = " bought "
                    }, 
                    [3] = {
                        [1] = v746, 
                        [2] = v744.weapon or "?"
                    }
                };
                v728(unpack(v747));
                v727(unpack(v747));
                return;
            end;
        end;
    end);
    v260:add("aim_ack", "qhouz", function(v748)
        -- upvalues: v263 (ref), v729 (ref), v728 (ref), l_v711_0 (ref), v727 (ref)
        if not v263.Ragebot.adv_logs.main:get() or not v263.Ragebot.adv_logs.log:get("Aimbot Shots") then
            return;
        else
            local v749 = entity.get(v748.target, true);
            if v749 == nil then
                return;
            elseif v748.state then
                local v750 = v263.Visuals.log_aimbot[v729[v748.state]]:get();
                v728({
                    [1] = nil, 
                    [2] = "Missed shot at "
                }, {
                    [1] = v750, 
                    [2] = v749:get_name() or "?"
                }, {
                    [1] = nil, 
                    [2] = "'s "
                }, {
                    [1] = v750, 
                    [2] = l_v711_0[v748.wanted_hitgroup]
                }, {
                    [1] = nil, 
                    [2] = "("
                }, {
                    v750, 
                    string.format("%d%%", v748.hitchance or 0)
                }, {
                    [1] = nil, 
                    [2] = ") due to "
                }, {
                    [1] = v750, 
                    [2] = v748.state
                }, {
                    [1] = nil, 
                    [2] = " (dmg: "
                }, {
                    [1] = v750, 
                    [2] = v748.wanted_damage or 0
                }, {
                    [1] = nil, 
                    [2] = " | history: "
                }, {
                    [1] = v750, 
                    [2] = v748.backtrack or 0
                }, {
                    [1] = nil, 
                    [2] = ")"
                });
                v727({
                    [1] = nil, 
                    [2] = "Missed shot at "
                }, {
                    v750, 
                    v749:get_name()
                }, {
                    [1] = nil, 
                    [2] = "'s due to "
                }, {
                    [1] = v750, 
                    [2] = v748.state
                });
                return;
            else
                local v751 = v263.Visuals.log_aimbot.hit:get();
                local v752 = v748.wanted_damage - v748.damage ~= 0;
                local v753 = v749.m_iHealth <= 0;
                local v754 = v748.backtrack > 0;
                v728({
                    [1] = nil, 
                    [2] = "Hit "
                }, {
                    [1] = v751, 
                    [2] = v749:get_name() or "?"
                }, {
                    [1] = nil, 
                    [2] = "'s "
                }, {
                    [1] = v751, 
                    [2] = l_v711_0[v748.hitgroup]
                }, {
                    [1] = nil, 
                    [2] = " for "
                }, {
                    [1] = v751, 
                    [2] = v748.damage or 0
                }, {
                    [1] = nil, 
                    [2] = "("
                }, {
                    [1] = v752 and v751 or nil, 
                    [2] = v748.wanted_damage
                }, {
                    [1] = nil, 
                    [2] = ") aimed="
                }, {
                    [1] = v748.hitgroup ~= v748.wanted_hitgroup and v751 or nil, 
                    [2] = l_v711_0[v748.wanted_hitgroup]
                }, {
                    [1] = nil, 
                    [2] = "("
                }, {
                    v751, 
                    string.format("%d%%", v748.hitchance or 0)
                }, {
                    [1] = nil, 
                    [2] = ") (history: "
                }, {
                    [1] = v751, 
                    [2] = v748.backtrack or 0
                }, {
                    [1] = nil, 
                    [2] = ") ("
                }, {
                    [1] = v751, 
                    [2] = v749.m_iHealth or 0
                }, {
                    [1] = nil, 
                    [2] = " remaining)"
                });
                v727({
                    [1] = nil, 
                    [2] = "Hit "
                }, {
                    [1] = v751, 
                    [2] = v749:get_name() or "?"
                }, {
                    [1] = nil, 
                    [2] = "'s "
                }, {
                    [1] = v751, 
                    [2] = l_v711_0[v748.hitgroup]
                }, {
                    [1] = nil, 
                    [2] = " for "
                }, {
                    [1] = v751, 
                    [2] = v748.damage or 0
                }, {
                    [1] = nil, 
                    [2] = " damage"
                }, {
                    [2] = v754 and " (bt: " or ""
                }, {
                    [1] = v751, 
                    [2] = v754 and v748.backtrack or ""
                }, {
                    [2] = v754 and ")" or ""
                }, {
                    [2] = v753 and "" or " ("
                }, {
                    [1] = v751, 
                    [2] = v753 and "" or v749.m_iHealth
                }, {
                    [2] = v753 and "" or " remaining)"
                });
                return;
            end;
        end;
    end);
end;
(function()
    -- upvalues: l_ui_0 (ref), v263 (ref), v260 (ref)
    local l_sv_maxusrcmdprocessticks_0 = cvar.sv_maxusrcmdprocessticks;
    local v756 = false;
    local v757 = l_ui_0.find("Aimbot", "Anti Aim", "Fake Lag", "Limit");
    local v758 = l_ui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
    local function v759()
        -- upvalues: v756 (ref), v757 (ref), v758 (ref), l_sv_maxusrcmdprocessticks_0 (ref)
        if v756 then
            v757:override();
            v758:override();
            l_sv_maxusrcmdprocessticks_0:int(16);
            v756 = false;
        end;
    end;
    local l_lag_exploit_0 = v263.Ragebot.lag_exploit;
    v260:add("prediction", "air exploit", function(_, v762, v763, _)
        -- upvalues: l_lag_exploit_0 (ref), v759 (ref), l_sv_maxusrcmdprocessticks_0 (ref), v757 (ref), v758 (ref), v756 (ref)
        if not l_lag_exploit_0.main:get() then
            return v759();
        elseif not v763 then
            return v759();
        else
            local v765 = v762:get_anim_state();
            if v765 == nil then
                return v759();
            elseif v765.on_ground or #v762.m_vecVelocity < 100 then
                return v759();
            else
                l_sv_maxusrcmdprocessticks_0:int(19);
                v757:override(17);
                v758:override(globals.tickcount % l_lag_exploit_0.ticks:get() == 0);
                v756 = true;
                return;
            end;
        end;
    end);
    v260:add("destroy", "air exploit 1", v759);
end)();
v712 = math.floor;
(function()
    -- upvalues: v67 (ref), v712 (ref), v314 (ref), v260 (ref), v178 (ref), v179 (ref), v673 (ref), v263 (ref), l_max_0 (ref)
    local function v768(v766, v767)
        return v766[2] < v767[2];
    end;
    local function v776(v769)
        -- upvalues: v67 (ref), v768 (ref)
        local v770 = {};
        for _, v772 in pairs(v769) do
            if v772:is_alive() and not v772:is_dormant() then
                local v773 = v772:get_player_weapon();
                if v773 and v773:get_weapon_reload() == -1 then
                    local v774 = v773:get_weapon_info();
                    if v774 and (v774.weapon_type == 5 or v774.weapon_type == 1) then
                        local v775 = render.world_to_screen(v772:get_origin());
                        if v775 then
                            v770[#v770 + 1] = {
                                v772, 
                                v775:dist(v67.screen_center)
                            };
                        end;
                    end;
                end;
            end;
        end;
        table.sort(v770, v768);
        return {
            [1] = v770[1], 
            [2] = v770[2], 
            [3] = v770[3]
        };
    end;
    local v777 = 0;
    local v778 = 0;
    local v779 = false;
    local v780 = false;
    local function v782(v781)
        -- upvalues: v712 (ref)
        return v712(0.5 + v781 / globals.tickinterval);
    end;
    local function v788(v783, v784, v785)
        local l_m_vecVelocity_0 = v783.m_vecVelocity;
        local v787 = v785:clone();
        v787.x = v787.x + l_m_vecVelocity_0.x * globals.tickinterval * v784;
        v787.y = v787.y + l_m_vecVelocity_0.y * globals.tickinterval * v784;
        return v787;
    end;
    local v789 = v314.FindVar("Aimbot", "Ragebot", "Main", "Double Tap");
    local l_exploit_0 = rage.exploit;
    v260:add("prediction", "Discharge DT on air-peek", function(_, v792, v793, v794)
        -- upvalues: v67 (ref), l_exploit_0 (ref), v779 (ref), v178 (ref), v179 (ref), v789 (ref), v673 (ref), v780 (ref), v263 (ref), v776 (ref), l_max_0 (ref), v782 (ref), v788 (ref), v777 (ref), v778 (ref)
        v67.charge = l_exploit_0:get();
        v779 = v178.ragebot and v179.weapons_disharge.main and v67.charge == 1 and v789:get();
        if not v779 then
            return l_exploit_0:allow_charge(true);
        elseif not v793 then
            return;
        else
            local v795 = v792:get_player_weapon();
            if not v795 then
                return;
            elseif v673 > 5 or #v792.m_vecVelocity < 100 then
                return;
            else
                local v796 = v795:get_weapon_info();
                if not v796 then
                    return;
                else
                    v780 = false;
                    local v797 = v795:get_weapon_index();
                    local v798 = {
                        [1] = v796.weapon_type == 5 and v797 ~= 40 and v797 ~= 9, 
                        [2] = v797 == 40, 
                        [3] = v797 == 9, 
                        [4] = v796.weapon_type == 1, 
                        [5] = v797 == 31, 
                        [6] = v796.weapon_type == 0
                    };
                    for v799, v800 in pairs(v798) do
                        local v801 = v800 and v263.Ragebot.weapons_disharge.weapons:get(v799);
                        if not v780 then
                            v780 = v801;
                        end;
                    end;
                    if not v780 then
                        return;
                    else
                        local v802 = v776(v794);
                        if not #v802 then
                            return;
                        else
                            local v803 = v792:get_hitbox_position(4);
                            local v804 = false;
                            for _, v806 in pairs(v802) do
                                if not v804 then
                                    local v807 = v806[1];
                                    local v808 = v807:get_resource();
                                    if v808 then
                                        local l_m_iPing_0 = v808.m_iPing;
                                        local v810 = l_max_0(5, v782(l_m_iPing_0 * (l_m_iPing_0 <= 10 and 2 or 1.75) / 1000));
                                        local v811 = v807:get_hitbox_position(4);
                                        local v812, v813 = utils.trace_bullet(v807, v811, v788(v792, v810, v803));
                                        if not v812 or v812 <= 0 then
                                            v804 = false;
                                        elseif not v813.entity or v813.entity:get_classname() == "CWorld" then
                                            v804 = false;
                                        else
                                            v804 = true;
                                        end;
                                    end;
                                else
                                    break;
                                end;
                            end;
                            if v804 and v777 < globals.realtime then
                                if v778 == 1 then
                                    v777 = globals.realtime + 0.5;
                                    l_exploit_0:force_teleport();
                                    l_exploit_0:allow_charge(false);
                                    v778 = 0;
                                end;
                                v778 = v778 + 1;
                            else
                                l_exploit_0:allow_charge(true);
                            end;
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v314 (ref), v260 (ref), v178 (ref), v179 (ref)
    local v814 = v314.FindVar("Miscellaneous", "Main", "In-Game", "Clan Tag");
    local v815 = {
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
        [13] = 11, 
        [14] = 11, 
        [15] = 11, 
        [16] = 11, 
        [17] = 11, 
        [18] = 11, 
        [19] = 11, 
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
        [30] = 22
    };
    local v816 = 0;
    v260:add("net_update_end", "tag", function()
        -- upvalues: v178 (ref), v179 (ref), v816 (ref), v814 (ref), v815 (ref)
        if not v178.misc or not v179.clantag.main then
            if v816 ~= 0 then
                common.set_clan_tag("");
            end;
            v816 = 0;
            return v814:override();
        else
            v814:override(false);
            local v817 = 0;
            local v818 = entity.get_game_rules();
            if v818 and v818.m_gamePhase == 4 then
                v817 = 11;
            else
                local v819 = 0.3 / globals.tickinterval;
                local v820 = globals.client_tick + globals.clock_offset;
                v817 = v815[math.floor(v820 / math.floor(v819 + 0.5) % 30) + 1];
            end;
            if v817 ~= v816 then
                local v821 = "";
                local l_tag_0 = v179.clantag.tag;
                v821 = l_tag_0 == "AcidTech" and "             acidtech                " or l_tag_0 == "500$ * 0" and "             gAmeSenSe                " or "             gamesense                ";
                common.set_clan_tag(v821:sub(v817 + 1, v817 + 18));
            end;
            v816 = v817;
            return;
        end;
    end);
    v260:add("destroy", "tag destroy", function()
        -- upvalues: v814 (ref)
        common.set_clan_tag("");
        v814:override();
    end);
end)();
local l_min_2 = math.min;
local v824 = 0;
local l_abs_1 = math.abs;
local function v827(v826)
    -- upvalues: l_min_2 (ref), l_abs_1 (ref), v712 (ref)
    return l_min_2(57, l_abs_1(v712((v826.m_flPoseParameter[11] or 0) * 120 - 60 + 0.5, 1)));
end;
(function()
    -- upvalues: l_vector_1 (ref), v67 (ref), v685 (ref), v139 (ref), v263 (ref), v161 (ref), v623 (ref), l_ui_0 (ref), v260 (ref), v622 (ref), v178 (ref), v673 (ref), v824 (ref), v827 (ref)
    local v828 = l_vector_1(215, 50);
    local v829 = l_vector_1(math.floor(v67.screen_center.x - 108) / v67.screen_size.x, v67.screen_size.y / 3.5 / v67.screen_size.y);
    local v830 = v685.add("velocity", v829, v828);
    local v831 = 0;
    local v832 = 0;
    local function v848(v833, v834, v835, v836, v837, v838, v839)
        -- upvalues: v830 (ref), v67 (ref), v831 (ref), v139 (ref), v832 (ref)
        local v840 = v835 * 255;
        if v830.is_in_b and v830.is_rmb_pressed and v839 then
            v830.position.x = v67.screen_center.x - 108;
        end;
        v831 = v139(v831, (not (v830.is_in_b and v839) or v830.dragging) and 0 or 1, 0.06);
        local v841 = v840 * v831;
        if v841 ~= 0 then
            render.text(1, v837 + vector(15, 40), color(255, 255, 255, v841), "", "Press M2 to center.");
        end;
        local v842 = color(255, 75, 75, v840);
        v832 = v139(v832, v838 and 1 or 0, 0.05);
        local v843 = v834.a * v835;
        v834 = v834:lerp(v842, v832):alpha_modulate(v840);
        local v844 = vector(v837.x + 15, v837.y + 30);
        local v845 = v844 + vector(185, 4);
        local v846 = v842:lerp(v834, v833);
        render.shadow(v844, v845, v846:alpha_modulate(v843), 20, 0);
        render.rect(v844, v845, color(0, 0, 0, v840));
        render.rect(v844 + vector(1, 1), v844 + vector(184 * v833, 3), v846);
        local v847 = (1 - v833) * 100;
        render.text(1, v844 + vector(92, -10), color():alpha_modulate(v840), "c", ("%s %d%%"):format(v836, v847));
    end;
    local v849 = 0;
    local function v856(v850, v851, v852, v853)
        -- upvalues: v830 (ref), v263 (ref), v848 (ref)
        v830:process();
        local l_position_1 = v830.position;
        if v851 == 1 and v850 == 0 then
            return;
        else
            local v855 = v263.Visuals.velocity_warning.accent:get();
            v848(v851, v855, v850, "\226\155\148\239\184\143 Max velocity reduced by", l_position_1, v852, v853);
            return;
        end;
    end;
    local function _(v857, v858, v859, ...)
        -- upvalues: v161 (ref), l_vector_1 (ref), v623 (ref)
        local v860 = {
            ...
        };
        local v861 = 0;
        for v862 = 1, #v860 do
            local v863 = v860[v862];
            v161(v863[1], l_vector_1(v857.x + v861, v857.y), v863[2], v858, v859);
            v861 = v861 + (v863[3] or v623.CalcTextSize(v863[1], v858, v859).x);
        end;
    end;
    local _ = false;
    local l_get_alpha_0 = l_ui_0.get_alpha;
    local l_get_mouse_position_0 = l_ui_0.get_mouse_position;
    v260:add("draw", "gui", function(v868, v869)
        -- upvalues: l_get_alpha_0 (ref), v67 (ref), l_get_mouse_position_0 (ref), l_vector_1 (ref), v622 (ref), v178 (ref), v263 (ref), v849 (ref), v139 (ref), v856 (ref), v673 (ref)
        local v870 = l_get_alpha_0();
        local v871 = v870 ~= 0;
        v67.menu_visible = v871;
        local v872 = l_get_mouse_position_0();
        mouse_position = l_vector_1(v622(v872.x, 0, v67.screen_size.x), v622(v872.y, 0, v67.screen_size.y));
        inactive_window = v872.x < 0 or not (v872.x <= v67.screen_size.x) or not (v872.y >= 0) or v872.y > v67.screen_size.y;
        local v873 = v178.visuals and v263.Visuals.velocity_warning.main:get() and v263.Visuals.velocity_warning.items:Get(4);
        local v874 = v869 and v868.m_flVelocityModifier or 1;
        if v871 and v873 then
            v874 = math.min(1, globals.tickcount % 200 / 150);
        end;
        local v875 = v873 and v874 ~= 1;
        v849 = v139(v849, v875 and 1 or 0, 0.05, 0.01);
        if v849 ~= 0 then
            local l_v849_0 = v849;
            if v871 and v873 then
                l_v849_0 = v870;
                v849 = v870;
            end;
            v856(l_v849_0, v874, v673 < 3, v871);
        end;
    end);
    v260:add("createmove", "trash info", function(_, v878)
        -- upvalues: v824 (ref), v827 (ref)
        v824 = v827(v878);
    end);
end)();
local l_functions_0 = v67.functions;
local v880 = nil;
local v881 = 1;
local l_band_0 = bit.band;
local v883 = v314.FindVar("Aimbot", "Anti Aim", "Misc", "Slow Walk");
local v884 = v314.FindVar("Aimbot", "Anti Aim", "Misc", "Fake Duck");
local v885 = v314.FindVar("Miscellaneous", "Main", "Movement", "Air Duck");
do
    local l_v881_0, l_l_band_0_0, l_v883_0, l_v884_0, l_v885_0 = v881, l_band_0, v883, v884, v885;
    v880 = function(v891, v892)
        -- upvalues: l_v884_0 (ref), l_l_band_0_0 (ref), v67 (ref), l_functions_0 (ref), v673 (ref), l_v885_0 (ref), l_v881_0 (ref), l_v883_0 (ref)
        local v893 = v891.m_flDuckAmount > 0.89 or l_v884_0:get();
        local v894 = 1;
        local v895 = l_l_band_0_0(v891.m_fFlags, 1);
        v894 = v67.functions.on_use_aa and 8 or not v892 and l_functions_0.is_fakelagging and 9 or v893 and (not (v895 ~= 0) or v673 < 3) and 7 or (not (v895 ~= 0) or v673 < 3) and (not l_v885_0:get() or l_v881_0 == 6) and 6 or v893 and v895 ~= 0 and 5 or l_v883_0:get() and 4 or #v891.m_vecVelocity > 2 and v673 > 10 and 3 or v673 > 10 and 2 or l_v881_0;
        l_v881_0 = v894;
        return v894;
    end;
end;
(function()
    -- upvalues: v150 (ref), v67 (ref), v314 (ref), v260 (ref), v178 (ref), v179 (ref), v622 (ref), v623 (ref), l_vector_1 (ref), l_max_0 (ref), v684 (ref), v263 (ref)
    local v896 = 0;
    local _ = 11;
    local _ = 5;
    local v899 = 0;
    local v900 = 4;
    local v901 = false;
    local v902 = 6;
    local l_white_0 = v150.white;
    local v904 = {};
    local v905 = render.load_font("Calibri", 18, "a");
    local l_screen_center_0 = v67.screen_center;
    local v907 = v314.FindVar("Visuals", "World", "Other", "Hit Marker");
    local v908 = false;
    local _ = vector(0, 15);
    v260:add("draw", "Hit marker", function(_, v911)
        -- upvalues: v178 (ref), v179 (ref), v908 (ref), v907 (ref), v896 (ref), v622 (ref), v899 (ref), l_white_0 (ref), v623 (ref), l_vector_1 (ref), l_screen_center_0 (ref), v902 (ref), v900 (ref), v904 (ref), l_max_0 (ref), v905 (ref)
        if not v178.visuals or not v179.hit_marker.main then
            if v908 then
                v908 = false;
                v907:override();
            end;
            return;
        elseif not v911 then
            return;
        else
            local v912 = v896 - globals.realtime;
            if v912 > 0 then
                local _ = v622((v899 - globals.tickcount) / 2, 6, 20) - v622((v899 - globals.tickcount) / 2, 0, 3);
                local v914 = color(l_white_0.r, l_white_0.g, l_white_0.b, l_white_0.a * v912 / 1);
                v623.Line(l_vector_1(l_screen_center_0.x - v902 - v900, l_screen_center_0.y - v902 - v900), l_vector_1(l_screen_center_0.x - v902, l_screen_center_0.y - v902), v914, 1);
                v623.Line(l_vector_1(l_screen_center_0.x + v902 + v900, l_screen_center_0.y + v902 + v900), l_vector_1(l_screen_center_0.x + v902, l_screen_center_0.y + v902), v914, 1);
                v623.Line(l_vector_1(l_screen_center_0.x + v902 + v900, l_screen_center_0.y - v902 - v900), l_vector_1(l_screen_center_0.x + v902, l_screen_center_0.y - v902), v914, 2);
                v623.Line(l_vector_1(l_screen_center_0.x - v902 - v900, l_screen_center_0.y + v902 + v900), l_vector_1(l_screen_center_0.x - v902, l_screen_center_0.y + v902), v914, 2);
            end;
            if v179.hit_marker.damage_marker then
                local l_realtime_0 = globals.realtime;
                for v916, v917 in pairs(v904) do
                    if v917.hit_pos then
                        local v918 = render.world_to_screen(v917.hit_pos);
                        if v918 then
                            local v919 = v917.timer - l_realtime_0;
                            local v920 = v919 < 2 and l_max_0(0, v919) * 2 or 1;
                            render.text(v905, v918, v917.color:alpha_modulate(v920 * 255), "cd", v917.damage);
                        end;
                        if v917.timer < l_realtime_0 then
                            v904[v916] = nil;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end);
    v260:add("round_prestart", "Hit marker event 1", function(_, _)
        -- upvalues: v904 (ref)
        v904 = {};
    end);
    v260:add("destroy", "Hit marker event 2", function(_, _)
        -- upvalues: v907 (ref)
        v907:override();
    end);
    local v925 = 0;
    local v926 = {};
    local _ = vector();
    v260:add("bullet_impact", "top damag marker", function(v928, v929)
        -- upvalues: v178 (ref), v179 (ref), v684 (ref), v925 (ref), v926 (ref)
        if not v178.visuals or not v179.hit_marker.main then
            return;
        elseif not v929 or not v929:is_alive() then
            return;
        elseif v684.GetPlayerForUserID(v928.userid) ~= v929 then
            return;
        else
            if v925 ~= globals.tickcount then
                v926 = {};
                v925 = globals.tickcount;
            end;
            v926[#v926 + 1] = vector(v928.x, v928.y, v928.z);
            return;
        end;
    end);
    v260:add("player_hurt", "Hit marker event", function(v930, v931)
        -- upvalues: v178 (ref), v179 (ref), v684 (ref), v901 (ref), v896 (ref), v899 (ref), l_white_0 (ref), v263 (ref), v907 (ref), v908 (ref), v926 (ref), v904 (ref)
        if not v178.visuals or not v179.hit_marker.main then
            return;
        else
            local v932 = v684.GetPlayerForUserID(v930.userid);
            local v933 = v684.GetPlayerForUserID(v930.attacker);
            if not v932 or not v933 or v932 == v933 or v933 ~= v931 then
                return;
            else
                v901 = v930.health <= 0;
                v896 = globals.realtime + 1;
                v899 = globals.tickcount + 20;
                l_white_0 = v901 and v263.Visuals.hit_marker.color1:Get() or v263.Visuals.hit_marker.color:Get();
                if v179.hit_marker.damage_marker then
                    v907:override(false);
                    v908 = true;
                    local l_hitgroup_0 = v930.hitgroup;
                    local v935 = nil;
                    if l_hitgroup_0 == 0 then
                        v935 = v932:get_hitbox_position(l_hitgroup_0);
                    else
                        local v936 = v932:get_hitbox_position(l_hitgroup_0);
                        local l_huge_0 = math.huge;
                        local v938 = vector();
                        for v939 = 1, #v926 do
                            local v940 = v926[v939]:dist(v936);
                            if v940 < l_huge_0 then
                                v938 = v926[v939];
                                l_huge_0 = v940;
                            end;
                        end;
                        v935 = v938;
                    end;
                    v904[v932:get_index()] = {
                        timer = globals.realtime + 3, 
                        damage = tostring(v930.dmg_health), 
                        hit_pos = v935, 
                        color = l_hitgroup_0 == 1 and color(237, 28, 36) or color(240, 240)
                    };
                else
                    v904 = {};
                    v907:override();
                    v908 = false;
                end;
                return;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v314 (ref), v260 (ref), v67 (ref), v263 (ref), v179 (ref), v623 (ref), l_vector_1 (ref)
    local v941 = v314.FindVar("Visuals", "World", "Main", "Override Zoom", "Scope Overlay");
    local v942 = 0;
    local function v943()
        -- upvalues: v942 (ref), v941 (ref)
        if v942 == 1 then
            v941:override();
            v942 = 0;
        end;
    end;
    v260:add("destroy", "yazik_asembler", function()
        -- upvalues: v943 (ref)
        v943();
    end);
    local v944 = 0;
    local l_screen_center_1 = v67.screen_center;
    local l_sqrt_0 = math.sqrt;
    local l_pow_0 = math.pow;
    local function v952(v948, v949, v950, v951)
        -- upvalues: l_sqrt_0 (ref), l_pow_0 (ref)
        v948 = v948 / v951 - 1;
        return v950 * l_sqrt_0(1 - l_pow_0(v948, 2)) + v949;
    end;
    local _ = 0;
    v260:add("draw", "microsecond", function(v954, v955)
        -- upvalues: v67 (ref), v944 (ref), v952 (ref), v263 (ref), v943 (ref), v942 (ref), v941 (ref), v179 (ref), v623 (ref), l_vector_1 (ref), l_screen_center_1 (ref)
        v67.functions.scope_anim = 0;
        local v956 = false;
        local v957 = 0;
        if v955 then
            v956 = v954.m_bIsScoped;
            v944 = math.clamp(v944 + globals.frametime * (v956 and 3 or -7), 0, 1);
            if v67.menu_visible then
                if v956 then
                    v944 = 1;
                else
                    v944 = 0;
                end;
            end;
            v957 = v952(v944, 0, 1, 1);
            v67.functions.scope_anim = v957;
        end;
        if not v263.Visuals.custom_scope.main:get() or not v955 or not v955 then
            return v943();
        else
            if v942 == 0 then
                v942 = 1;
            end;
            if not v956 then
                return;
            elseif v957 == 0 then
                return;
            else
                v941:override("Remove All");
                local v958 = v263.Visuals.custom_scope.color1:get();
                local v959 = v263.Visuals.custom_scope.color2:get():alpha_modulate(0);
                v958 = v958:alpha_modulate(v958.a * v67.functions.scope_anim);
                v959 = v959:alpha_modulate(v959.a * v67.functions.scope_anim);
                local l_gap_0 = v179.custom_scope.gap;
                local v961 = v179.custom_scope.size * v957;
                v623.GradientBoxFilled(l_vector_1(l_screen_center_1.x, l_screen_center_1.y - l_gap_0), l_vector_1(l_screen_center_1.x + 1, l_screen_center_1.y - l_gap_0 - v961), v958, v958, v959, v959);
                v623.GradientBoxFilled(l_vector_1(l_screen_center_1.x, l_screen_center_1.y + l_gap_0 + 1), l_vector_1(l_screen_center_1.x + 1, l_screen_center_1.y + l_gap_0 + v961 + 1), v958, v958, v959, v959);
                v623.GradientBoxFilled(l_vector_1(l_screen_center_1.x - l_gap_0, l_screen_center_1.y), l_vector_1(l_screen_center_1.x - l_gap_0 - v961, l_screen_center_1.y + 1), v958, v959, v958, v959);
                v623.GradientBoxFilled(l_vector_1(l_screen_center_1.x + l_gap_0 + 1, l_screen_center_1.y), l_vector_1(l_screen_center_1.x + l_gap_0 + v961 + 1, l_screen_center_1.y + 1), v958, v959, v958, v959);
                return;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v314 (ref), v67 (ref), v685 (ref), l_ui_0 (ref), l_vector_1 (ref), v260 (ref), v178 (ref), v179 (ref), v880 (ref), v263 (ref), l_min_2 (ref), v139 (ref)
    local v962 = {
        [1] = {
            [1] = "DT", 
            [2] = nil, 
            [3] = 0, 
            [2] = v314.FindVar("Aimbot", "Ragebot", "Main", "Double Tap")
        }, 
        [2] = {
            [1] = "HS", 
            [2] = nil, 
            [3] = 0, 
            [2] = v314.FindVar("Aimbot", "Ragebot", "Main", "Hide Shots")
        }, 
        [3] = {
            [1] = "FD", 
            [2] = nil, 
            [3] = 0, 
            [2] = v314.FindVar("Aimbot", "Anti Aim", "Misc", "Fake Duck")
        }, 
        [4] = {
            [1] = "DMG", 
            [2] = 0, 
            [3] = 0
        }
    };
    local v963 = {};
    for _, v965 in ipairs(v962) do
        v963[v965[1]] = render.measure_text(2, "", v965[1]);
    end;
    local v966 = vector(28, 16);
    local v967 = vector((v67.screen_center.x + 10) / v67.screen_size.x, (v67.screen_center.y - 30) / v67.screen_size.y);
    local v968 = v685.add("damageindicator", v967, v966);
    local v969 = l_ui_0.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
    local v970 = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local _ = 0;
    local v979 = {
        [1] = "IDLE", 
        [2] = "STAND", 
        [3] = "RUN", 
        [4] = "S.WALK", 
        [5] = "CROUCH", 
        [6] = "AIR", 
        [7] = "AIR", 
        [8] = "USE", 
        [9] = "FAKELAG"
    };
    local _ = l_vector_1(v67.screen_center.x, v67.screen_center.y + 20);
    local v981 = "";
    local _ = false;
    local _ = rage.antiaim;
    v260:add("prediction", "wapaduruduruwap 123", function(_, v985, _)
        -- upvalues: v178 (ref), v179 (ref), v981 (ref), v67 (ref), v979 (ref), v880 (ref), v263 (ref)
        if not v178.visuals or not v179.indicators.main then
            return;
        else
            v981 = v67.functions.safehead and "SAFE" or v67.functions.edge_yaw and "EDGE" or v979[v880(v985, not v263.AntiAim.enabled_Fakelagging:get())];
            return;
        end;
    end);
    local function v998(v987, v988, v989, v990, v991, v992)
        local v993 = #v992;
        local v994 = "";
        local v995 = nil;
        for v996 = 1, v993 do
            local v997 = v992:sub(v996, v996);
            v994 = v994 .. ("\a%s%s"):format(v987:lerp(v988, v996 / v993):to_hex(), v997);
        end;
        render.text(v990, v989, color(), v991, v994);
        return v995;
    end;
    local function v1013(v999, v1000, v1001, v1002, v1003, v1004, v1005)
        local v1006 = 0;
        local v1007 = #v1004;
        local v1008 = math.ceil(v1007 / 2);
        local v1009 = nil;
        for v1010 = 1, v1007 do
            local v1011 = v1004:sub(v1010, v1010);
            local v1012 = v999:lerp(v1000, v1010 / v1007);
            if not v1005 then
                render.text(v1002, v1001 + vector(v1006, 0), v1012, v1003, v1011);
                v1006 = v1006 + render.measure_text(v1002, v1003, v1011).x - 1;
            end;
            if v1010 == v1008 then
                v1009 = {
                    [1] = v999:lerp(v1000, (v1010 - 1) / v1007), 
                    [2] = v1012
                };
            end;
        end;
        return v1009;
    end;
    local function v1017(v1014, v1015, v1016)
        -- upvalues: l_min_2 (ref)
        return l_min_2(v1014, (v1014 + (v1016 or 1)) * v1015);
    end;
    local v1018 = 0;
    local v1019 = 0;
    local v1020 = 0;
    local _ = 28.5;
    local v1022 = "ACIDTECH ";
    local v1023 = {
        color(), 
        color()
    };
    local v1024 = 9;
    local v1025 = render.measure_text(2, "", v1022);
    local v1026 = render.measure_text(2, "", "DT");
    local v1027 = v67.screen_center + vector(1, 20);
    local v1028 = 0;
    local v1029 = 0;
    local v1030 = "";
    local v1031 = 0;
    local v1032 = 0;
    local _ = 0;
    v260:add("draw", "wapaduruduruwap", function(v1034, v1035)
        -- upvalues: v178 (ref), v179 (ref), v970 (ref), v139 (ref), v1018 (ref), v1019 (ref), v1020 (ref), v1017 (ref), v67 (ref), v1027 (ref), v1031 (ref), v1025 (ref), v1023 (ref), v263 (ref), v1013 (ref), v1024 (ref), v1022 (ref), v1032 (ref), v981 (ref), v998 (ref), l_ui_0 (ref), v962 (ref), v963 (ref), v1026 (ref), v968 (ref), v969 (ref), v1028 (ref), v1030 (ref), v1029 (ref)
        local v1036 = 0;
        local v1037 = 0.045;
        local v1038 = -1;
        if v178.visuals and v179.indicators.main and v1035 then
            v1036 = 1;
            local v1039 = v1034:get_player_weapon();
            if v1039 then
                local v1040 = v1039:get_weapon_info();
                v1038 = v1040.weapon_type;
                if v1040 and v1038 == 9 then
                    v1036 = 0.4;
                    v1037 = 0.15;
                end;
            end;
        end;
        v970 = v139(v970, v1036, v1037, 0.01);
        if v970 < 0.01 then
            return;
        else
            v1018 = (v1018 + globals.frametime * 1) % 1;
            if v1019 - v1018 > 0.9 then
                v1020 = v1020 + 1;
            end;
            v1019 = v1018;
            local v1041 = v1020 % 4 + 1;
            local v1042 = nil;
            local v1043 = nil;
            if v1041 == 1 then
                v1042 = v1018;
                v1043 = 0;
            elseif v1041 == 2 then
                v1042 = 1;
                v1043 = v1018;
            elseif v1041 == 3 then
                v1042 = 1 - v1018;
                v1043 = 1;
            elseif v1041 == 4 then
                v1042 = 0;
                v1043 = 1 - v1018;
            end;
            local v1044 = 0;
            local v1045 = true;
            local v1046 = v1017(not v1045 and 15 or 35, v67.functions.scope_anim, 3);
            local v1047 = vector(v1046, 0);
            local v1048 = v1046 / (not v1045 and 15 or 35);
            local l_v1027_0 = v1027;
            local v1050 = color(0, 0, 0, 255);
            local v1051 = color(0, 0, 0, 0);
            local v1052 = true;
            if v1031 > 0.01 then
                render.shadow(l_v1027_0 - vector(v1025.x / 2, 1) + v1047, l_v1027_0 + vector(v1025.x / 2, -1) + v1047, color(v1023[1].r, v1023[1].g, v1023[1].b, 190 * v970 * v1031), 40 + v1050:lerp(v1051, v1042).a / 25.5, 0);
            end;
            local v1053 = v970 * 255;
            local v1054 = v263.Visuals.indicators.colorushka:get():alpha_modulate(v1053 * v1031);
            local v1055 = v263.Visuals.indicators.color1:get():alpha_modulate(v1053 * v1031);
            v1023 = v1013(v1054:lerp(v1055, v1042), v1055:lerp(v1054, v1043), l_v1027_0 + vector(-v1025.x / 2 - 3, v1044 * v1024 - v1025.y / 2) + v1047, 2, "", v1022, v1031 < 0.01);
            v1031 = v139(v1031, v1045 and 1 or 0, 0.05);
            if v1031 > 0.1 then
                v1044 = v1044 + 1;
            end;
            local v1056 = v263.Visuals.indicators.color2:get():alpha_modulate(v1053);
            v1032 = v139(v1032, true and 1 or 0, 0.05);
            if v1032 > 0.01 then
                local v1057 = -render.measure_text(2, "", v981).x / 2 * (1 - v1048) + 13 * v1048;
                if v1052 then
                    v998(v1023[1]:alpha_modulate(v1053 * v1032), v1023[2]:alpha_modulate(v1053 * v1032), l_v1027_0 + vector(v1057, v1044 * v1024 - 6), 2, "", v981);
                else
                    render.text(2, l_v1027_0 + vector(0, v1044 * v1024), v1056:alpha_modulate(v1053 * v1032), "", v981);
                end;
                v1044 = v1044 + 1;
                local v1058 = false;
                local v1059 = l_ui_0.get_binds();
                for _, v1061 in pairs(v1059) do
                    if v1061.name == "Min. Damage" then
                        v1058 = v1061.active;
                        break;
                    end;
                end;
                local v1062 = v1044 * v1024;
                for v1063 = 1, #v962 do
                    local v1064 = v962[v1063];
                    local v1065 = v1053 * v1064[3] * v1032;
                    local v1066 = -v963[v1064[1]].x / 2 * (1 - v1048) + 13 * v1048;
                    if v1064[1] == "DT" then
                        local v1067 = rage.exploit:get();
                        local v1068 = -v1026.x / 2 * (1 - v1048) + 13 * v1048;
                        if v1038 ~= 9 or v1067 ~= 1 then
                            render.text(2, l_v1027_0 + vector(v1068, v1062 - 6), color(255, 100, 100, 0.7 * v1065), "", "DT");
                        end;
                        render.push_clip_rect(l_v1027_0 + vector(v1068, v1062 - 6), l_v1027_0 + vector(-v1026.x / 2 + v1067 * (v1026.x / 2 + 12) + 13 * v1048, v1062 + 6));
                        if not v1052 then
                            render.text(2, l_v1027_0 + vector(0, v1062 - 6), v1056:alpha_modulate(v1067 * v1065), "", "DT");
                        else
                            v998(v1023[1]:alpha_modulate(v1065), v1023[2]:alpha_modulate(v1065), l_v1027_0 + vector(v1068, v1062 - 6), 2, "", "DT");
                        end;
                        render.pop_clip_rect();
                    elseif v1064[3] ~= 0 then
                        if not v1052 then
                            render.text(2, l_v1027_0 + vector(0, v1062), v1056:alpha_modulate(v1065), "", v1064[1]);
                        else
                            v998(v1023[1]:alpha_modulate(v1065), v1023[2]:alpha_modulate(v1065), l_v1027_0 + vector(v1066, v1062 - 6), 2, "", v1064[1]);
                        end;
                    end;
                    local v1069 = 0;
                    if v1064[1] == "DMG" then
                        v1069 = v1058 and 1 or 0;
                    elseif v1064[1] == "BAIM" then
                        v1069 = v1064[2]:get() == v1064[4] and 1 or 0;
                    elseif v1064[4] ~= nil then
                        v1069 = v1064[2]:get() == v1064[4] and 1 or 0;
                    else
                        v1069 = v1064[2]:get() and 1 or 0;
                    end;
                    v1064[3] = v139(v1064[3], v1069, 0.1, 0.05);
                    v1062 = v1062 + v1017(9, v1064[3]);
                end;
            end;
            local v1070 = v263.Visuals.indicators.show_damage:get();
            local v1071 = true;
            if v1070 then
                v968:process();
                local v1072 = v969:get();
                v1028 = v139(v1028, v1072, 0.4, 0.5);
                local l_position_2 = v968.position;
                if v1035 and v1038 ~= -1 then
                    local l_v1038_0 = v1038;
                    if l_v1038_0 == 0 or l_v1038_0 == 9 or l_v1038_0 == 7 or v1034.m_flNextAttack - 0.7 > globals.curtime then
                        v1071 = false;
                    end;
                end;
                local v1075 = "";
                local v1076 = l_ui_0.get_alpha();
                if not v1071 then
                    if v1076 ~= 0 then
                        v1071 = true;
                        v1075 = "AUTO";
                    else
                        v1075 = v1030;
                    end;
                else
                    v1075 = v1072 == 0 and "AUTO" or v1072 > 100 and string.format("HP+%d", v1072 - 100) or tostring(math.ceil(v1028));
                    v1030 = v1075;
                end;
                local v1077 = vector(17 + render.measure_text(2, "", v1075).x, 24);
                v968.size = v1077;
                local v1078 = v1023[2]:alpha_modulate(v1053 * v1029);
                if v1078.a ~= 0 then
                    render.text(2, l_position_2 + vector(9, 6), v1078, "", v1075);
                end;
                local v1079 = v1076 * 50 * v970 * v1029;
                if v1079 ~= 0 then
                    render.rect_outline(l_position_2, l_position_2 + v1077, color():alpha_modulate(v1079), 0, 8);
                end;
            end;
            v1029 = v139(v1029, v1070 and v1071 and 1 or 0, 0.125);
            return;
        end;
    end);
end)();
(function()
    -- upvalues: v67 (ref), v685 (ref), l_ui_0 (ref), v179 (ref), v139 (ref), v16 (ref), v260 (ref), v178 (ref), v263 (ref)
    local v1080 = nil;
    local v1081 = {};
    local v1082 = {};
    local v1083 = vector((v67.screen_center.x - 165) / v67.screen_size.x, (v67.screen_size.y - v67.screen_size.y / 3.5) / v67.screen_size.y);
    local v1084 = vector(330, 120);
    local v1085 = v685.add("aimlog", v1083, v1084);
    local v1086 = color();
    local v1087 = {
        hit = l_ui_0.get_icon("vector-circle") .. " ", 
        burn = l_ui_0.get_icon("fire") .. " ", 
        miss = l_ui_0.get_icon("circle-xmark") .. " ", 
        spread = l_ui_0.get_icon("spinner") .. " ", 
        unregistered = l_ui_0.get_icon("satellite-dish") .. " "
    };
    local v1088 = {
        [1] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Hit ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "hit", 
                    [2] = "vladislav"
                }, 
                [3] = {
                    [1] = nil, 
                    [2] = " for ", 
                    [1] = v1086
                }, 
                [4] = {
                    [1] = "hit", 
                    [2] = 10
                }, 
                [5] = {
                    [1] = nil, 
                    [2] = " damage", 
                    [1] = v1086
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [2] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Hit ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "hit", 
                    [2] = "monster"
                }, 
                [3] = {
                    [1] = nil, 
                    [2] = " in the ", 
                    [1] = v1086
                }, 
                [4] = {
                    [1] = "hit", 
                    [2] = "head"
                }, 
                [5] = {
                    [1] = nil, 
                    [2] = " for ", 
                    [1] = v1086
                }, 
                [6] = {
                    [1] = "hit", 
                    [2] = 103
                }, 
                [7] = {
                    [1] = nil, 
                    [2] = " damage", 
                    [1] = v1086
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [3] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "miss", 
                    [2] = "correction"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [4] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "miss", 
                    [2] = "prediction error"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [5] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "miss", 
                    [2] = "lagcomp failure"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [6] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "spread", 
                    [2] = "spread"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [7] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "unregistered", 
                    [2] = "unregistered shot"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [8] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "unregistered", 
                    [2] = "player death"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }, 
        [9] = {
            data = {
                [1] = {
                    [1] = nil, 
                    [2] = "Missed shot due to ", 
                    [1] = v1086
                }, 
                [2] = {
                    [1] = "unregistered", 
                    [2] = "death"
                }
            }, 
            timers = {
                alpha = 1, 
                remove = math.huge, 
                remove_log = math.huge
            }
        }
    };
    local v1089 = 0;
    local v1090 = 0;
    local function v1112(v1091, v1092, v1093, v1094, _, v1096, v1097)
        -- upvalues: v179 (ref), v1087 (ref), v1086 (ref), v139 (ref), v16 (ref)
        local v1098 = v1091.timers.alpha * 255 * (v1097 or 1);
        local v1099 = "";
        local l_data_0 = v1091.data;
        local v1101 = #l_data_0;
        local v1102 = l_data_0[2][2]:find("Burned ") and v1093 < v1091.timers.shadow_pulse;
        local v1103 = nil;
        local v1104 = nil;
        local v1105 = 0;
        local v1106 = 0;
        local v1107 = 0;
        for v1108 = 1, v1101 do
            local v1109 = l_data_0[v1108];
            if v1108 == 1 and not v1096 then
                v1103 = v1109[1]:alpha_modulate(v1098);
            elseif v1108 == 2 and v1096 then
                v1103 = v179.log_aimbot[v1109[1]]:alpha_modulate(v1098);
            end;
            if v1102 then
                if v1108 == 5 then
                    v1105 = render.measure_text(1, "", v1099).x;
                elseif v1108 == 6 then
                    v1106 = render.measure_text(1, "", v1099).x - v1105;
                end;
            end;
            if v1096 and type(v1109[1]) == "string" then
                v1104 = v1109[1];
                v1099 = v1099 .. "\a" .. v179.log_aimbot[v1109[1]]:alpha_modulate(v1098):to_hex() .. v1109[2] .. "\aDEFAULT";
            else
                v1099 = v1099 .. "\a" .. v1109[1]:alpha_modulate(v1098):to_hex() .. v1109[2] .. "\aDEFAULT";
            end;
        end;
        if v1098 ~= 0 then
            if v1096 then
                v1099 = (string.format("\a%s%s\aDEFAULT", v1103.alpha_modulate(v1103, v1098):to_hex(), v1087[v1104]) or "") .. v1099;
            end;
            v1107 = render.measure_text(1, "", v1099).x / 2;
            render.shadow(v1092 - vector(v1107, -6 - v1094), v1092 + vector(v1107, 6 + v1094), v1103, 30 * v1103.a / 255, 0, 0);
            if v1102 then
                local v1110 = v1091.timers.shadow_pulse - v1093;
                local v1111 = vector(v1092.x + v1105 - v1107, v1092.y + v1094 + 7);
                render.shadow(v1111, v1111 + vector(v1106, 0), v1103, 50 * v1103.a / 255 * v1110, 0, 10);
            end;
            render.text(1, vector(v1092.x - v1107, v1092.y + v1094), v1086, "", v1099);
        end;
        v1091.timers.alpha = v139(v1091.timers.alpha, v1093 < v1091.timers.remove and 1 or 0, 0.1);
        return v16(13, v1091.timers.alpha, 3);
    end;
    v260:add("draw", "alt logs", function(_, _)
        -- upvalues: v178 (ref), v179 (ref), v1089 (ref), v139 (ref), v1081 (ref), v1082 (ref), l_ui_0 (ref), v1080 (ref), v1085 (ref), v67 (ref), v1090 (ref), v1084 (ref), v1088 (ref), v1112 (ref)
        local v1115 = v178.visuals and v179.log_aimbot.main;
        v1089 = v139(v1089, v1115 and 1 or 0, 0.1);
        if v1089 == 0 then
            local v1116 = {};
            v1082 = {};
            v1081 = v1116;
            return;
        else
            local v1117 = l_ui_0.get_alpha();
            if v1117 ~= 1 then
                v1089 = v1117;
            end;
            local l_shadow_0 = v179.log_aimbot.shadow;
            if v1117 == 1 and v179.log_aimbot.preview or not v1080 then
                local v1119 = v1085:process();
                if v1119.is_in_b and v1119.is_rmb_pressed then
                    v1119.position.x = v67.screen_center.x - 165;
                end;
                v1080 = v1119.position;
                v1090 = v139(v1090, (not v1119.is_in_b or v1119.dragging) and 0 or 1, 0.06);
                if v1089 * v1090 ~= 0 then

                end;
            end;
            local v1120 = v1080 + vector(165, 0);
            local l_realtime_1 = globals.realtime;
            if v1089 ~= 0 and v179.log_aimbot.preview then
                render.rect_outline(v1080, v1080 + v1084, color(255, 50 * v1089), 0, 8);
                local v1122 = 0;
                for v1123 = 1, #v1088 do
                    local v1124 = v1088[v1123];
                    v1122 = v1122 + v1112(v1124, v1120, l_realtime_1, v1122, l_shadow_0, true, v1089);
                end;
                return;
            else
                local v1125 = 0;
                for v1126 = 1, #v1081 do
                    local v1127 = v1081[v1126];
                    v1125 = v1125 + v1112(v1127, v1120, l_realtime_1, v1125, l_shadow_0);
                end;
                return;
            end;
        end;
    end);
    local _ = color(125, 255, 125);
    local v1129 = {
        smokegrenade = "Smoked ", 
        hegrenade = "Naded ", 
        snowball = "Snowballed ", 
        taser = "Tased ", 
        knife = "Stabbed "
    };
    local v1130 = {
        [1] = "generic", 
        [2] = "head", 
        [3] = "chest", 
        [4] = "stomach", 
        [5] = "left arm", 
        [6] = "right arm", 
        [7] = "left leg", 
        [8] = "right leg", 
        [9] = "?"
    };
    local function v1137(v1131)
        -- upvalues: v1081 (ref)
        if not v1131 then
            v1131 = 0;
        end;
        local v1132 = 0;
        local v1133 = {};
        for v1134 = 1, #v1081 do
            local v1135 = v1081[v1134];
            if v1135.timers.alpha > 0 then
                v1132 = v1132 + 1;
                v1133[#v1133 + 1] = v1135;
            end;
        end;
        if v1132 > 9 then
            for v1136 = 1, v1132 - 8 + v1131 do
                v1133[v1136].timers.remove = 0;
            end;
        end;
    end;
    local v1138 = {
        inferno = l_ui_0.get_icon("fire") .. " ", 
        taser = l_ui_0.get_icon("bolt") .. " ", 
        hegrenade = l_ui_0.get_icon("burst") .. " ", 
        knife = l_ui_0.get_icon("fork-knife") .. " "
    };
    local v1139 = 0;
    local v1140 = 0;
    v260:add("player_hurt", "alt logs hurt", function(v1141, v1142, v1143)
        -- upvalues: v178 (ref), v179 (ref), v1140 (ref), v1139 (ref), v1138 (ref), v1087 (ref), v1082 (ref), v1081 (ref), v1086 (ref), v1137 (ref), v1129 (ref), v1130 (ref)
        if not v178.visuals or not v179.log_aimbot.main or not v1143 then
            return;
        else
            local v1144 = entity.get(v1141.userid, true);
            local v1145 = entity.get(v1141.attacker, true);
            if v1144 == nil or v1145 == nil or v1144 == v1145 or v1145 ~= v1142 then
                return;
            else
                local l_tickcount_0 = globals.tickcount;
                if v1140 ~= l_tickcount_0 then
                    v1140 = l_tickcount_0;
                else
                    v1139 = v1139 + 1;
                end;
                local l_weapon_0 = v1141.weapon;
                local l_hit_0 = v179.log_aimbot.hit;
                local v1149 = v1138[l_weapon_0] or v1087.hit or "";
                local v1150 = v1144:get_name();
                if l_weapon_0 == "inferno" then
                    local l_tickcount_1 = globals.tickcount;
                    local v1152 = v1082[v1150];
                    if not v1152 then
                        v1082[v1150] = {
                            all_damage = 0, 
                            tick = l_tickcount_1
                        };
                        v1152 = v1082[v1150];
                    end;
                    if l_tickcount_1 - v1152.tick > 50 then
                        v1152.all_damage = 0;
                    end;
                    v1152.tick = l_tickcount_1;
                    v1152.all_damage = v1152.all_damage + v1141.dmg_health;
                    local v1153 = nil;
                    table.foreach(v1081, function(v1154, v1155)
                        -- upvalues: v1150 (ref), v1153 (ref), v1081 (ref)
                        if v1155.data[2][2] == "Burned " and v1155.data[3][2] == v1150 then
                            v1153 = v1081[v1154];
                        end;
                    end);
                    if not v1153 then
                        v1081[#v1081 + 1] = {
                            data = {
                                [1] = {
                                    [1] = l_hit_0, 
                                    [2] = v1149
                                }, 
                                [2] = {
                                    [1] = nil, 
                                    [2] = "Burned ", 
                                    [1] = v1086
                                }, 
                                [3] = {
                                    [1] = l_hit_0, 
                                    [2] = v1150
                                }, 
                                [4] = {
                                    [1] = nil, 
                                    [2] = " for ", 
                                    [1] = v1086
                                }, 
                                [5] = {
                                    l_hit_0, 
                                    tostring(v1152.all_damage)
                                }, 
                                [6] = {
                                    [1] = nil, 
                                    [2] = " damage", 
                                    [1] = v1086
                                }
                            }, 
                            timers = {
                                alpha = 0, 
                                remove = math.huge, 
                                shadow_pulse = globals.realtime + 0.5, 
                                remove_log = globals.realtime + 7
                            }
                        };
                        v1153 = v1081[#v1081];
                    end;
                    v1153.data[5][2] = tostring(v1152.all_damage);
                    v1153.timers.remove = globals.realtime + 6;
                    v1153.timers.remove_log = globals.realtime + 7;
                    v1153.timers.shadow_pulse = globals.realtime + 0.5;
                    v1137();
                    return;
                elseif v1129[l_weapon_0] ~= nil then
                    v1081[#v1081 + 1] = {
                        data = {
                            [1] = {
                                [1] = l_hit_0, 
                                [2] = v1149
                            }, 
                            [2] = {
                                [1] = v1086, 
                                [2] = v1129[l_weapon_0]
                            }, 
                            [3] = {
                                [1] = l_hit_0, 
                                [2] = v1150
                            }, 
                            [4] = {
                                [1] = nil, 
                                [2] = " for ", 
                                [1] = v1086
                            }, 
                            [5] = {
                                l_hit_0, 
                                tostring(v1141.dmg_health)
                            }, 
                            [6] = {
                                [1] = nil, 
                                [2] = " damage", 
                                [1] = v1086
                            }
                        }, 
                        timers = {
                            alpha = 0, 
                            remove = globals.realtime + 6, 
                            remove_log = globals.realtime + 7
                        }
                    };
                    v1137();
                    return;
                else
                    local l_hitgroup_1 = v1141.hitgroup;
                    if l_hitgroup_1 == 0 then
                        v1081[#v1081 + 1] = {
                            data = {
                                [1] = {
                                    [1] = l_hit_0, 
                                    [2] = v1149
                                }, 
                                [2] = {
                                    [1] = nil, 
                                    [2] = "Hit ", 
                                    [1] = v1086
                                }, 
                                [3] = {
                                    [1] = l_hit_0, 
                                    [2] = v1150
                                }, 
                                [4] = {
                                    [1] = nil, 
                                    [2] = " for ", 
                                    [1] = v1086
                                }, 
                                [5] = {
                                    l_hit_0, 
                                    tostring(v1141.dmg_health)
                                }, 
                                [6] = {
                                    [1] = nil, 
                                    [2] = " damage", 
                                    [1] = v1086
                                }
                            }, 
                            timers = {
                                alpha = 0, 
                                remove = globals.realtime + 6, 
                                remove_log = globals.realtime + 7
                            }
                        };
                    else
                        v1081[#v1081 + 1] = {
                            data = {
                                [1] = {
                                    [1] = l_hit_0, 
                                    [2] = v1149
                                }, 
                                [2] = {
                                    [1] = nil, 
                                    [2] = "Hit ", 
                                    [1] = v1086
                                }, 
                                [3] = {
                                    [1] = l_hit_0, 
                                    [2] = v1150
                                }, 
                                [4] = {
                                    [1] = nil, 
                                    [2] = " in the ", 
                                    [1] = v1086
                                }, 
                                [5] = {
                                    [1] = l_hit_0, 
                                    [2] = v1130[l_hitgroup_1 + 1]
                                }, 
                                [6] = {
                                    [1] = nil, 
                                    [2] = " for ", 
                                    [1] = v1086
                                }, 
                                [7] = {
                                    l_hit_0, 
                                    tostring(v1141.dmg_health)
                                }, 
                                [8] = {
                                    [1] = nil, 
                                    [2] = " damage", 
                                    [1] = v1086
                                }
                            }, 
                            timers = {
                                alpha = 0, 
                                remove = globals.realtime + 6, 
                                remove_log = globals.realtime + 7
                            }
                        };
                    end;
                    v1137();
                    return;
                end;
            end;
        end;
    end);
    v260:add("cs_game_disconnected", "Log aimbot clean", function(_)
        -- upvalues: v1081 (ref)
        v1081 = {};
    end);
    v260:add("round_prestart", "Log aimbot clean 1", function(_)
        -- upvalues: v1081 (ref)
        v1081 = {};
    end);
    local v1159 = {
        ["backtrack failure"] = "miss", 
        ["damage rejection"] = "miss", 
        ["player misprediction"] = "miss", 
        spread = "spread", 
        ["unregistered shot"] = "unregistered", 
        death = "unregistered", 
        ["player death"] = "unregistered", 
        ["lagcomp failure"] = "miss", 
        ["jitter correction"] = "miss", 
        ["prediction error"] = "miss", 
        correction = "miss"
    };
    local v1160 = {
        misprediction = "jitter correction"
    };
    v260:add("aim_ack", "logs aim", function(v1161)
        -- upvalues: v178 (ref), v179 (ref), v1159 (ref), v263 (ref), v1160 (ref), v1087 (ref), v1081 (ref), v1086 (ref), v1137 (ref)
        if not v178.visuals or not v179.log_aimbot.main then
            return;
        else
            local l_target_0 = v1161.target;
            if not l_target_0 or l_target_0 == nil or not v1161.state then
                return;
            elseif not v1161.wanted_damage or v1161.wanted_damage == 0 then
                return;
            else
                local v1163 = v1159[v1161.state];
                local v1164 = v263.Visuals.log_aimbot[v1163];
                if not v1164 then
                    return;
                else
                    local v1165 = v1160[v1161.state] or v1161.state;
                    local v1166 = v1164:get();
                    local v1167 = v1087[v1163] or "";
                    v1081[#v1081 + 1] = {
                        data = {
                            [1] = {
                                [1] = v1166, 
                                [2] = v1167
                            }, 
                            [2] = {
                                [1] = nil, 
                                [2] = "Missed shot due to ", 
                                [1] = v1086
                            }, 
                            [3] = {
                                [1] = v1166, 
                                [2] = v1165
                            }
                        }, 
                        timers = {
                            alpha = 0, 
                            remove = globals.realtime + 6, 
                            remove_log = globals.realtime + 7
                        }
                    };
                    v1137();
                    return;
                end;
            end;
        end;
    end);
end)();
v885 = {
    yaw_base = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    yaw_base1 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    yaw_add = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    freestand = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Freestanding")
};
(function()
    -- upvalues: v67 (ref), v260 (ref), v139 (ref), v178 (ref), v179 (ref), v263 (ref)
    local v1168 = {
        [1] = {
            vector(55, 2), 
            vector(42, -7), 
            vector(42, 11)
        }, 
        [2] = {
            vector(-54, 2), 
            vector(-41, -7), 
            vector(-41, 11)
        }
    };
    local v1169 = 0;
    local v1170 = v67.screen_center + vector(0, -1);
    local v1171 = 0;
    local v1172 = 0;
    local v1173 = 0;
    local v1174 = 0;
    local l_poly_0 = render.poly;
    local l_antiaim_1 = rage.antiaim;
    local v1177 = color(0, 0, 0, 90);
    v260:add("draw", "manuali", function(_, v1179)
        -- upvalues: v1169 (ref), v139 (ref), v178 (ref), v179 (ref), v67 (ref), l_antiaim_1 (ref), v263 (ref), v1171 (ref), v1172 (ref), v1173 (ref), v1174 (ref), v1177 (ref), l_poly_0 (ref), v1170 (ref), v1168 (ref)
        v1169 = v139(v1169, v178.visuals and v179.manual_strelki.main and v67.functions.scope_anim < 0.3 and v1179 and 1 or 0, 0.1, 0.01);
        if v1169 < 0.01 then
            return;
        else
            local v1180 = l_antiaim_1:inverter();
            local v1181 = v263.AntiAim.manual_strelki.color:get():alpha_modulate(255);
            local l_manual_yb_0 = v179.manual_yb;
            local v1183 = l_manual_yb_0 == "Right";
            local v1184 = l_manual_yb_0 == "Left";
            v1171 = v139(v1171, v1183 and 1 or 0, 0.1, 0.05);
            v1172 = v139(v1172, v1184 and 1 or 0, 0.1, 0.05);
            v1173 = v139(v1173, v1180 and 1 or 0, 0.1, 0.05);
            v1174 = v139(v1174, not v1180 and 1 or 0, 0.1, 0.05);
            local v1185 = v1177:lerp(v1181, v1171);
            local v1186 = v1177:lerp(v1181, v1172);
            local v1187 = v1177:lerp(v1181, v1173);
            local v1188 = v1177:lerp(v1181, v1174);
            l_poly_0(v1185:alpha_modulate(v1185.a * v1169), v1170 + v1168[1][1], v1170 + v1168[1][2], v1170 + v1168[1][3]);
            l_poly_0(v1186:alpha_modulate(v1186.a * v1169), v1170 + v1168[2][1], v1170 + v1168[2][2], v1170 + v1168[2][3]);
            render.rect(v1170 + vector(38, -7), v1170 + vector(40, 11), v1187:alpha_modulate(v1187.a * v1169));
            render.rect(v1170 + vector(-39, -7), v1170 + vector(-37, 11), v1188:alpha_modulate(v1188.a * v1169));
            return;
        end;
    end);
end)();
(function()
    -- upvalues: v401 (ref), v178 (ref), v263 (ref), v260 (ref)
    local l_r_aspectratio_0 = cvar.r_aspectratio;
    local v1190 = false;
    local function v1191()
        -- upvalues: v1190 (ref), l_r_aspectratio_0 (ref), v401 (ref)
        if v1190 then
            l_r_aspectratio_0:float(v401.r_aspectratio);
            v1190 = false;
        end;
    end;
    local function v1193()
        -- upvalues: v178 (ref), v263 (ref), v401 (ref), l_r_aspectratio_0 (ref), v1190 (ref), v1191 (ref)
        local v1192 = v178.misc and v263.Misc.aspect_ratio.main:Get() and v263.Misc.aspect_ratio.ratio:Get() / 100 or v401.r_aspectratio;
        l_r_aspectratio_0:float(v1192);
        if v1192 == 0.5 then
            v1190 = true;
            v1191();
        else
            v1190 = v1192 ~= 1;
        end;
    end;
    v260:add("draw", "aspect_ratio", function()
        -- upvalues: v178 (ref), v1191 (ref)
        if not v178.misc then
            return v1191();
        else
            return;
        end;
    end);
    v263.Misc.main:RegisterCallback(v1193);
    v263.Misc.aspect_ratio.main:RegisterCallback(v1193);
    v263.Misc.aspect_ratio.ratio:RegisterCallback(v1193);
    v1193();
    v260:add("destroy", "aspect_ratio 1", v1191);
end)();
local function v1195(v1194)
    while v1194 > 180 do
        v1194 = v1194 - 360;
    end;
    while v1194 < -180 do
        v1194 = v1194 + 360;
    end;
    return v1194;
end;
(function()
    -- upvalues: v314 (ref), v260 (ref), l_min_2 (ref), l_abs_1 (ref), v67 (ref), l_ui_0 (ref), v263 (ref), v179 (ref), l_functions_0 (ref), v1195 (ref), v880 (ref), v178 (ref), v405 (ref), v143 (ref)
    local v1196 = {
        [1] = "Global", 
        [2] = "Standing", 
        [3] = "Moving", 
        [4] = "Slowwalking", 
        [5] = "Ducking", 
        [6] = "Jumping", 
        [7] = "CrouchingAir", 
        [8] = "LegitAA", 
        [9] = "Fakelagging"
    };
    local v1197 = {
        pitch = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Pitch"), 
        yaw_base = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw"), 
        yaw_base1 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        yaw_defen = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        yaw_add = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
        fakeopt = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        free_dsy = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        yaw_mod = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
        yaw_mod_d = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
        freestand = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        limit1 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        limit2 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        body_yaw = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw")
    };
    local v1198 = {
        [1] = false, 
        [2] = false, 
        [3] = false
    };
    local v1199 = {
        [1] = {
            yaw_mod_d = 0, 
            yaw_mod = 0, 
            free_dsy = 0, 
            fakeopt = 0, 
            yaw_defen = 0, 
            pitch = 0, 
            limit1 = 0, 
            freestand = 0, 
            limit2 = 0, 
            yaw_add = 0
        }, 
        [2] = {
            yaw_mod_d = 0, 
            yaw_mod = 0, 
            free_dsy = 0, 
            fakeopt = 0, 
            yaw_defen = 0, 
            pitch = 0, 
            limit1 = 0, 
            freestand = 0, 
            limit2 = 0, 
            yaw_add = 0
        }, 
        [3] = {
            yaw_mod_d = 0, 
            yaw_mod = 0, 
            free_dsy = 0, 
            fakeopt = 0, 
            yaw_defen = 0, 
            pitch = 0, 
            limit1 = 0, 
            freestand = 0, 
            limit2 = 0, 
            yaw_add = 0
        }, 
        [4] = {
            yaw_mod_d = 0, 
            yaw_mod = 0, 
            free_dsy = 0, 
            fakeopt = 0, 
            yaw_defen = 0, 
            pitch = 0, 
            limit1 = 0, 
            freestand = 0, 
            limit2 = 0, 
            yaw_add = 0
        }
    };
    local v1200 = 1;
    local v1201 = 1;
    local _ = 0;
    local function v1206(v1203)
        -- upvalues: v1198 (ref), v1197 (ref), v1199 (ref)
        if v1198[v1203] then
            return;
        else
            for v1204, v1205 in pairs(v1197) do
                v1199[v1203][v1204] = v1205:get();
            end;
            v1198[v1203] = true;
            return;
        end;
    end;
    local function v1210(v1207)
        -- upvalues: v1198 (ref), v1197 (ref)
        if not v1198[v1207] then
            return;
        else
            for _, v1209 in pairs(v1197) do
                v1209:override();
            end;
            v1198[v1207] = false;
            return;
        end;
    end;
    v260:add("destroy", "cond aas dest", function()
        -- upvalues: v1210 (ref), v1197 (ref)
        v1210(1);
        v1210(2);
        v1210(3);
        v1210(4);
        v1197.yaw_base:override();
        v1197.yaw_base1:override();
        v1197.freestand:override();
        v1197.pitch:override();
        v1197.yaw_add:override();
        v1197.body_yaw:override();
    end);
    local l_antiaim_2 = rage.antiaim;
    local function _()
        -- upvalues: l_min_2 (ref), l_abs_1 (ref), l_antiaim_2 (ref)
        return l_min_2(l_abs_1(l_antiaim_2:get_rotation() - l_antiaim_2:get_rotation(true)), l_antiaim_2:get_max_desync());
    end;
    local v1213 = 0;
    local v1214 = false;
    local v1215 = false;
    local v1216 = {
        [0] = "Forward", 
        [1] = "Backward", 
        [2] = "Right", 
        [3] = "Left", 
        [4] = "At target", 
        [5] = "Freestanding"
    };
    local v1217 = 0;
    local _ = v67.screen_center;
    local v1219 = false;
    local v1220 = l_ui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options");
    local v1221 = l_ui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options");
    local v1222 = l_ui_0.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden");
    local v1223 = l_ui_0.find("Aimbot", "Anti Aim", "Angles", "Body Yaw");
    local v1224 = {
        Moving = 3, 
        Standing = 2, 
        Ducking = 5, 
        Slowwalking = 4
    };
    local v1225 = {
        Hideshots = l_ui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        Doubletap = l_ui_0.find("Aimbot", "Ragebot", "Main", "Double Tap")
    };
    local v1226 = false;
    local function v1227()
        -- upvalues: v1226 (ref), v1220 (ref), v1221 (ref), v1222 (ref), v1223 (ref)
        if not v1226 then
            return;
        else
            v1226 = false;
            v1220:override();
            v1221:override();
            v1222:override();
            v1223:override();
            return;
        end;
    end;
    local v1228 = {
        [1] = -180, 
        [2] = 0, 
        [3] = 90, 
        [4] = -90
    };
    local v1229 = {
        [1] = 90, 
        [2] = 180, 
        [3] = -90, 
        [4] = 180, 
        [5] = 90
    };
    local v1230 = "";
    local function v1232()
        -- upvalues: v263 (ref), v1230 (ref)
        local l_defensive_aa_0 = v263.AntiAim.defensive_aa;
        v1230 = l_defensive_aa_0.yaw:get();
        if l_defensive_aa_0.pitch:get() == "Default" then
            l_defensive_aa_0.yaw:update({
                [1] = "None", 
                [2] = "Default", 
                [3] = "Sideways", 
                [4] = "Forward", 
                [5] = "Spinbot", 
                [6] = "3-Way", 
                [7] = "5-Way", 
                [8] = "Random"
            });
            l_defensive_aa_0.yaw:set(v1230);
        else
            l_defensive_aa_0.yaw:update({
                [1] = "Default", 
                [2] = "Sideways", 
                [3] = "Forward", 
                [4] = "Spinbot", 
                [5] = "3-Way", 
                [6] = "5-Way", 
                [7] = "Random"
            });
            l_defensive_aa_0.yaw:set(v1230);
        end;
    end;
    v263.AntiAim.defensive_aa.main:RegisterCallback(v1232);
    v263.AntiAim.defensive_aa.pitch:RegisterCallback(v1232);
    local l_defensive_aa_1 = v263.AntiAim.defensive_aa;
    v260:add("prediction", "defensive aa", function(v1234, _, _)
        -- upvalues: v1219 (ref), v67 (ref), l_defensive_aa_1 (ref), v1227 (ref), v179 (ref), v1225 (ref), l_functions_0 (ref), v1213 (ref), v1224 (ref), v1195 (ref), v1200 (ref), v1229 (ref), v1201 (ref), v1226 (ref), v1220 (ref), v1221 (ref), v1222 (ref), v1223 (ref)
        v1219 = false;
        v67.full_aa_stop = v1219;
        if not l_defensive_aa_1.main:get() or rage.exploit:get() ~= 1 or v67.functions.on_use_aa or v67.functions.edge_yaw then
            return v1227();
        elseif v179.manual_yb == "Right" or v179.manual_yb == "Left" then
            return v1227();
        else
            local v1237 = false;
            local l_ipairs_0 = ipairs;
            local v1239 = l_defensive_aa_1.mode:get() or {};
            for _, v1241 in l_ipairs_0(v1239) do
                if v1225[v1241] and v1225[v1241]:get() then
                    v1237 = true;
                    break;
                end;
            end;
            l_ipairs_0 = false;
            if l_functions_0.safehead and l_defensive_aa_1.mode:get(3) then
                v1237 = true;
                l_ipairs_0 = true;
            end;
            if l_functions_0.safehead and v1237 and not l_ipairs_0 then
                return v1227();
            elseif not v1237 then
                return v1227();
            else
                v1239 = false;
                local v1242 = false;
                if not l_ipairs_0 then
                    if v1213 == 6 or v1213 == 7 then
                        v1242 = l_defensive_aa_1.state:get("Air");
                    else
                        for _, v1244 in ipairs(l_defensive_aa_1.state:get()) do
                            if v1244 == "On Peek" then
                                v1242 = true;
                                v1239 = true;
                                break;
                            elseif v1224[v1244] == v1213 then
                                v1242 = true;
                                break;
                            end;
                        end;
                    end;
                end;
                if not v1242 and not l_ipairs_0 then
                    return v1227();
                else
                    local l_x_0 = v1234.view_angles.x;
                    local v1246 = l_defensive_aa_1.pitch:get();
                    if v1246 ~= "Default" then
                        if v1246 == "Zero" then
                            l_x_0 = 0;
                        elseif v1246 == "Up" then
                            l_x_0 = -89;
                        elseif v1246 == "Switch" then
                            if v1234.forwardmove > 0 then
                                l_x_0 = -89 + 29 * (globals.tickcount % v1234.forwardmove % 6 + 1);
                            else
                                l_x_0 = -89 + 29 * (globals.tickcount % 6 + 1);
                            end;
                        elseif v1246 == "Up Switch" then
                            l_x_0 = utils.random_float(-45, -60);
                        elseif v1246 == "Down Switch" then
                            l_x_0 = utils.random_float(45, 60);
                        elseif v1246 == "Random" then
                            l_x_0 = utils.random_float(-89, 89);
                        end;
                    end;
                    local l_y_0 = v1234.view_angles.y;
                    local v1248 = l_defensive_aa_1.yaw:get();
                    if v1248 == "Sideways" then
                        l_y_0 = v1195(v1200 * 90 + utils.random_float(-30, 30));
                    elseif v1248 == "Forward" then
                        l_y_0 = v1195(v1200 * 180 + utils.random_float(-30, 30));
                    elseif v1248 == "Spinbot" then
                        l_y_0 = v1195(-180 + globals.tickcount % 9 * 40 + utils.random_float(-30, 30));
                    elseif v1248 == "3-Way" then
                        l_y_0 = v1195(v1229[v1201 % 5 + 1] + utils.random_float(-15, 15));
                    elseif v1248 == "5-Way" then
                        l_y_0 = v1195(({
                            [1] = 90, 
                            [2] = 135, 
                            [3] = 180, 
                            [4] = 225, 
                            [5] = 270
                        })[v1201 % 5 + 1] + utils.random_float(-15, 15));
                    elseif v1248 == "Random" then
                        l_y_0 = utils.random_float(-180, 180);
                    end;
                    v1226 = true;
                    if not v1239 then
                        v1220:override("Always On");
                        v1221:override("Break LC");
                    else
                        v1227();
                    end;
                    if v1248 ~= "None" then
                        v1222:override(true);
                    else
                        v1222:override();
                    end;
                    v1223:override(true);
                    if v1246 ~= "Default" then
                        rage.antiaim:override_hidden_pitch(l_x_0);
                    end;
                    if v1248 ~= "Default" then
                        rage.antiaim:override_hidden_yaw_offset(l_y_0);
                    end;
                    v1219 = true;
                    v67.full_aa_stop = v1219;
                    return;
                end;
            end;
        end;
    end);
    local v1249 = false;
    local function v1250()
        -- upvalues: v1249 (ref), v1220 (ref)
        if not v1249 then
            return;
        else
            v1249 = false;
            v1220:override();
            return;
        end;
    end;
    local v1251 = {
        ["Crouching Air"] = 5, 
        Standing = 1, 
        Ducking = 3
    };
    local l_sv_gravity_0 = cvar.sv_gravity;
    local function v1259(v1253, v1254)
        -- upvalues: l_sv_gravity_0 (ref)
        local l_tickinterval_0 = globals.tickinterval;
        local l_m_vecVelocity_1 = v1253.m_vecVelocity;
        local v1257 = v1254:clone();
        local v1258 = 16;
        if #l_m_vecVelocity_1 < 32 then
            v1258 = 32;
        end;
        v1257.x = v1257.x + l_m_vecVelocity_1.x * l_tickinterval_0 * v1258;
        v1257.y = v1257.y + l_m_vecVelocity_1.y * l_tickinterval_0 * v1258;
        if not v1253.m_hGroundEntity then
            v1257.z = v1257.z + l_m_vecVelocity_1.z * l_tickinterval_0 * v1258 - l_sv_gravity_0:float() * l_tickinterval_0;
        end;
        return utils.trace_hull(v1254, v1257, v1253.m_vecMins, v1253.m_vecMaxs, v1253).end_pos:clone();
    end;
    local v1266 = {
        [1] = {
            [3] = {
                offset = 15, 
                left_limit = 24, 
                inverter = false, 
                right_limit = 24
            }, 
            [2] = {
                offset = 15, 
                left_limit = 24, 
                inverter = false, 
                right_limit = 24
            }
        }, 
        [3] = {
            [3] = {
                offset = -5, 
                inverter = false, 
                right_limit = 45, 
                left_limit = 45, 
                get_offset = function(v1260, v1261)
                    local v1262 = #v1261.m_vecVelocity;
                    return v1260.in_forward and v1260.in_moveright and v1262 > 10 and v1262 < 70 and 32 or 27;
                end
            }, 
            [2] = {
                offset = 17, 
                inverter = false, 
                right_limit = 45, 
                left_limit = 45, 
                get_offset = function(v1263, v1264)
                    local v1265 = #v1264.m_vecVelocity;
                    return v1263.in_forward and v1263.in_moveright and v1265 > 10 and v1265 < 70 and 32 or 27;
                end
            }
        }, 
        [5] = {
            [3] = {
                offset = 0, 
                left_limit = 25, 
                inverter = false, 
                right_limit = 25
            }, 
            [2] = {
                offset = 0, 
                left_limit = 25, 
                inverter = false, 
                right_limit = 25
            }
        }, 
        [107] = {
            [3] = {
                offset = 0, 
                left_limit = 60, 
                inverter = true, 
                right_limit = 60
            }, 
            [2] = {
                offset = 0, 
                left_limit = 60, 
                inverter = true, 
                right_limit = 60
            }
        }, 
        [268] = {
            [3] = {
                offset = 23, 
                left_limit = 60, 
                inverter = false, 
                right_limit = 30
            }, 
            [2] = {
                offset = 17, 
                left_limit = 20, 
                inverter = false, 
                right_limit = 60
            }
        }
    };
    local v1267 = false;
    v260:add("prediction", "safehead", function(v1268, v1269, v1270, _)
        -- upvalues: l_functions_0 (ref), v1215 (ref), v1267 (ref), v1217 (ref), v1213 (ref), v880 (ref), v263 (ref), v67 (ref), v178 (ref), v179 (ref), v1250 (ref), v1210 (ref), v1251 (ref), v1249 (ref), v1220 (ref), v1259 (ref), v1206 (ref), v1214 (ref), v1266 (ref), v1197 (ref)
        l_functions_0.safehead = false;
        v1215 = false;
        v1267 = false;
        v1217 = 0;
        if v1269 and v1270 then
            v1213 = v880(v1269, not v263.AntiAim.enabled_Fakelagging:get());
            v67.global_cond = v1213;
        end;
        if not v178.antiaim or not v1270 or l_functions_0.on_use_aa or l_functions_0.edge_yaw or v179.manual_yb == "Right" or v179.manual_yb == "Left" then
            v1250();
            return v1210(3);
        else
            local v1272 = v880(v1269, true) - 1;
            if v1272 == 2 then
                v1250();
                return v1210(3);
            else
                if v1272 > 2 then
                    v1272 = v1272 - 1;
                end;
                v1272 = math.clamp(v1272, 0, 5);
                local v1273 = false;
                local v1274 = false;
                local v1275 = 0;
                if v1272 == 4 or v1272 == 5 and not v1273 then
                    local v1276 = v1269:get_player_weapon();
                    if v1276 then
                        local v1277 = v1276:get_classid();
                        v1275 = v1277;
                        if v1277 == 107 then
                            v1273 = v263.AntiAim.safehead:get(1);
                        elseif v1277 == 268 then
                            v1273 = v263.AntiAim.safehead:get(2);
                        end;
                        v1274 = true;
                    end;
                end;
                if not v1273 then
                    for _, v1279 in pairs(v263.AntiAim.safehead:get()) do
                        if v1251[v1279] and v1272 == v1251[v1279] then
                            v1273 = true;
                            break;
                        end;
                    end;
                end;
                if not v1273 then
                    v1250();
                    return v1210(3);
                else
                    l_functions_0.safehead = v1274;
                    if v1272 == 4 or v1272 == 5 and v1274 then
                        v1249 = true;
                        v1220:override("Always On");
                    else
                        v1250();
                    end;
                    local _ = 4096;
                    local v1281 = nil;
                    local _ = 0;
                    if not l_functions_0.safehead then
                        local v1283 = v1269:get_origin();
                        v1281 = entity.get_threat();
                        if v1281 and v1281:is_alive() then
                            local v1284 = v1281:get_origin();
                            if (v1274 and v1283.z - 1 or v1284.z + 5) < v1283.z then
                                l_functions_0.safehead = utils.trace_bullet(v1281, v1259(v1281, v1281:get_eye_position()), v1269:get_hitbox_position(0) + vector(0, 0, 6)) > 0;
                            end;
                        end;
                    end;
                    v1267 = v1274;
                    if l_functions_0.safehead then
                        v1206(3);
                        if not v1214 then
                            v1215 = true;
                        end;
                        local v1285 = v1274 and v1266[v1275] or v1266[v1272];
                        if not v1285 then
                            if v1274 then
                                v1285 = v1266.Other;
                            else
                                v1250();
                                return v1210(3);
                            end;
                        end;
                        local v1286 = v1285[v1269.m_iTeamNum];
                        if not v1286 then
                            v1250();
                            return v1210(3);
                        else
                            v1197.body_yaw:override(true);
                            v1197.yaw_base1:override("At Target");
                            v1197.yaw_mod:override("Disabled");
                            v1197.fakeopt:override({});
                            v1197.yaw_base:override("Backward");
                            v1197.yaw_add:override(v1286.get_offset and v1286.get_offset(v1268, v1269) or v1286.offset);
                            v1197.limit1:override(v1286.left_limit);
                            v1197.limit2:override(v1286.right_limit);
                            rage.antiaim:inverter(v1286.inverter);
                            return;
                        end;
                    else
                        v1250();
                        return v1210(3);
                    end;
                end;
            end;
        end;
    end);
    local v1287 = false;
    local v1288 = 1;
    local v1289 = {
        [1] = -0.75, 
        [2] = 1, 
        [3] = 0, 
        [4] = 0.4, 
        [5] = -0.25
    };
    v260.breakpoints["cond aas"] = -1;
    local v1290 = false;
    local v1291 = 0;
    local v1292 = nil;
    local v1293 = {
        Meta = v405.parse_fast("[acid_preset]>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<[acid_preset]").data, 
        ["Classic+"] = v405.parse_fast("[acid_preset]>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<[acid_preset]").data
    };
    local v1294 = {
        Default = "Peek Fake", 
        Reversed = "Peek Real", 
        Off = "Off"
    };
    local _ = 0;
    local v1296 = {
        ["2-Way"] = {
            [1] = -0.5, 
            [2] = 0.5
        }, 
        ["3-Way"] = {
            [1] = -0.5, 
            [2] = 0, 
            [3] = 0.5
        }, 
        ["5-Way"] = {
            [1] = -0.75, 
            [2] = 1, 
            [3] = 0, 
            [4] = 0.4, 
            [5] = -0.25
        }
    };
    local v1297 = {};
    local function v1299()
        -- upvalues: v1297 (ref)
        for v1298 = 1, 14 do
            v1297[v1298] = {
                previous_angle = 0, 
                current = 0, 
                is_active = false, 
                ticks = 0
            };
        end;
    end;
    v1299();
    local v1300 = {};
    local v1301 = 0;
    local v1302 = false;
    v260:add("prediction", "cond aas", function(v1303, v1304, v1305)
        -- upvalues: v67 (ref), v1200 (ref), v1201 (ref), v1302 (ref), v1214 (ref), v178 (ref), v263 (ref), v260 (ref), v1197 (ref), v1290 (ref), v1216 (ref), l_functions_0 (ref), v1287 (ref), v1215 (ref), v1228 (ref), v1210 (ref), v1206 (ref), l_ui_0 (ref), v1293 (ref), v880 (ref), v1196 (ref), v143 (ref), v1300 (ref), v1299 (ref), v1301 (ref), v1294 (ref), v1297 (ref), v1292 (ref), v1195 (ref), v1291 (ref), v1289 (ref), v1288 (ref), v1296 (ref), v1266 (ref)
        v67.ab_working = false;
        if v1304 == nil then
            return;
        else
            if v1303.choked_commands == 0 then
                v67.jitter = 0;
                v1200 = v1200 * -1;
                v1201 = v1201 + 1;
                local v1306 = v1304:get_anim_state();
                v1302 = math.normalize_yaw(v1306.abs_yaw - v1306.eye_yaw) < 0;
            end;
            v1214 = not v178.antiaim or not (v263.AntiAim.mode:get() ~= "Default") or not v1305;
            v260.breakpoints["cond aas"] = 0;
            if v67.on_warmup then
                v1197.pitch:override("Disabled");
                v1197.yaw_base:override("Disabled");
                v1197.body_yaw:override(false);
                v1290 = true;
                return;
            else
                if v1290 then
                    v1197.pitch:override();
                    v1197.yaw_base:override();
                    v1197.body_yaw:override();
                    v1290 = false;
                end;
                v260.breakpoints["cond aas"] = 1;
                local v1307 = v263.AntiAim.manual_yb:GetCombo() or 0;
                v1197.yaw_base:override(v1216[1]);
                v1197.freestand:override();
                local v1308 = false;
                if v178.antiaim and v263.AntiAim.mode:get() == "Default" and v1305 and not l_functions_0.edge_yaw and v1307 ~= 0 and not l_functions_0.on_use_aa then
                    v260.breakpoints["cond aas"] = 2;
                    v1287 = true;
                    v1197.yaw_add:override(0);
                    v1197.freestand:override(false);
                    if v1215 then
                        v1197.yaw_base1:override("At Target");
                    else
                        v1308 = true;
                        if v1307 > 4 then
                            if v1307 == 5 then
                                v1197.yaw_base1:override("Local View");
                                v1197.freestand:override(true);
                            end;
                        else
                            v1197.yaw_base1:override("Local View");
                            v1197.yaw_add:override(v1228[v1307] or 0);
                        end;
                    end;
                    v260.breakpoints["cond aas"] = 3;
                else
                    v260.breakpoints["cond aas"] = 4;
                    if v1287 then
                        v1287 = false;
                        v1197.yaw_add:override();
                        v1197.yaw_base:override();
                        v1197.yaw_base1:override();
                    end;
                    v260.breakpoints["cond aas"] = 5;
                end;
                v260.breakpoints["cond aas"] = 6;
                if v1214 or l_functions_0.edge_yaw then
                    return v1210(1);
                else
                    v260.breakpoints["cond aas"] = 7;
                    if v1215 then
                        return;
                    else
                        v1210(3);
                        v260.breakpoints["cond aas"] = 8;
                        v1206(1);
                        v260.breakpoints["cond aas"] = 9;
                        local v1309 = 0;
                        local v1310 = "";
                        local v1311 = "Global";
                        local v1312 = {};
                        local v1313 = {};
                        if v263.AntiAim.mode:get() == "Automatic" and l_ui_0.get_alpha() == 0 then
                            local v1314 = v1293[v263.AntiAim.automatic_type:get()];
                            v1309 = v880(v1304, not v1314.enabled_Fakelagging);
                            v1310 = v1196[v1309]:gsub(" ", "");
                            v1311 = v1309 == 1 and "Global" or v1314["enabled_" .. v1310] and v1310 or "Global";
                            v1312.body_yaw = v1314["body_yaw_" .. v1311];
                            v1312.inverted = v1314["inverter_" .. v1311] or false;
                            v1312.limit1 = v1314["l_limit_" .. v1311];
                            v1312.free_dsy = l_functions_0.should_fs_desync and "Peek Fake" or v1314["freestand_" .. v1311];
                            v1312.yaw_base1 = v1314["yaw_base_" .. v1311];
                            v1312.yaw_add = v1314["yaw_add_" .. v1311];
                            v1312.yaw_add_main = v1314["yaw_add_main_" .. v1311];
                            v1312.yaw_add1 = v1314["yaw_add1_" .. v1311];
                            v1312.yaw_mod = v1314["yaw_mod_" .. v1311];
                            v1312.fake_opt_combo_2 = v143(v1314["fake_opt_" .. v1311]).Jitter;
                            v1312.fake_opt = v1314["fake_opt_" .. v1311];
                            v1312.fake_opt_fj = v143(v1314["fake_opt_" .. v1311])["Randomize jitter"];
                            v1312.yaw_mod_d = v1314["yaw_mod_deg_" .. v1311];
                            v1312.yaw_mod_deg_random = v1314["yaw_mod_deg_shitai_" .. v1311];
                            v1312.yaw_mod_ab = v1314["mod_d_ab_add_en_" .. v1311];
                            v1312.acid_mode = v1314["yaw_mod_acid_" .. v1311];
                            v1312.delay_1 = v1314["yaw_mod_deg_delay1_" .. v1311];
                            v1312.delay_2 = v1314["yaw_mod_deg_delay2_" .. v1311];
                            v1312.delay_safe = v1314["yaw_mod_acid_safe_" .. v1311];
                            for v1315 = 1, 0 do
                                v1312["mod_d_ab_" .. v1315] = v1314["lby_mode_" .. v1311];
                            end;
                        else
                            v1309 = v880(v1304, not v263.AntiAim.enabled_Fakelagging:get());
                            v1310 = v1196[v1309]:gsub(" ", "");
                            v1311 = v1309 == 1 and "Global" or v263.AntiAim["enabled_" .. v1310]:get() and v1310 or "Global";
                            v1312.body_yaw = v263.AntiAim["body_yaw_" .. v1311]:Get();
                            v1312.inverted = v263.AntiAim["inverter_" .. v1311]:get();
                            v1312.limit1 = v263.AntiAim["l_limit_" .. v1311]:Get();
                            v1312.free_dsy = l_functions_0.should_fs_desync and "Default" or v263.AntiAim["freestand_" .. v1311]:Get();
                            if v263.AntiAim["yaw_base_" .. v1311] then
                                v1312.yaw_base1 = v263.AntiAim["yaw_base_" .. v1311]:Get();
                                v1312.yaw_add = v263.AntiAim["yaw_add_" .. v1311]:Get();
                                v1312.yaw_add_main = v263.AntiAim["yaw_add_main_" .. v1311]:Get();
                                v1312.yaw_add1 = v263.AntiAim["yaw_add1_" .. v1311]:Get();
                            end;
                            v1312.yaw_mod = v263.AntiAim["yaw_mod_" .. v1311]:Get();
                            v1312.fake_opt_combo_2 = v263.AntiAim["fake_opt_" .. v1311]:GetCombo(2);
                            v1312.fake_opt = v263.AntiAim["fake_opt_" .. v1311]:get();
                            v1312.fake_opt_fj = v263.AntiAim["fake_opt_" .. v1311]:get(3);
                            v1312.yaw_mod_d = v263.AntiAim["yaw_mod_deg_" .. v1311]:get();
                            v1312.yaw_mod_deg_random = v263.AntiAim["yaw_mod_deg_shitai_" .. v1311]:get();
                            v1312.yaw_mod_ab = v263.AntiAim["mod_d_ab_add_en_" .. v1311]:get();
                            v1312.acid_mode = v263.AntiAim["yaw_mod_acid_" .. v1311]:get();
                            v1312.delay_1 = v263.AntiAim["yaw_mod_deg_delay1_" .. v1311]:get();
                            v1312.delay_2 = v263.AntiAim["yaw_mod_deg_delay2_" .. v1311]:get();
                            v1312.delay_safe = v263.AntiAim["yaw_mod_acid_safe_" .. v1311]:get();
                            if not v1300["yaw_mod_deg_delay1_" .. v1311] then
                                v1300["yaw_mod_deg_delay1_" .. v1311] = true;
                                v263.AntiAim["yaw_mod_deg_delay1_" .. v1311]:set_callback(v1299);
                                v263.AntiAim["yaw_mod_deg_delay2_" .. v1311]:set_callback(v1299);
                                v263.AntiAim["yaw_mod_acid_safe_" .. v1311]:set_callback(v1299);
                                v1301 = 0;
                            end;
                            v1313[#v1313 + 1] = v1312.yaw_mod_d;
                            for v1316 = 2, v67.ab_phases[v1311] do
                                v1313[#v1313 + 1] = v263.AntiAim["mod_d_ab_" .. v1316 .. v1311]:get();
                            end;
                        end;
                        v1197.body_yaw:override(v1312.body_yaw);
                        v260.breakpoints["cond aas"] = 10;
                        local l_v1302_0 = v1302;
                        if v1312.fake_opt and v1312.fake_opt_combo_2 and v1312.fake_opt_fj and v1312.yaw_mod == "AcidTech" then
                            l_v1302_0 = rage.antiaim:inverter();
                        end;
                        v1197.limit1:override(v1312.limit1);
                        v1197.limit2:override(v1312.limit1);
                        v260.breakpoints["cond aas"] = 11;
                        v1197.free_dsy:override(v1294[v1312.free_dsy]);
                        v1197.fakeopt:override({});
                        v1197.yaw_mod:override("Disabled");
                        v1197.yaw_add:override(0);
                        v260.breakpoints["cond aas"] = 12;
                        local v1318 = v1297[v1309];
                        local v1319 = 0;
                        if not l_functions_0.on_use_aa then
                            v260.breakpoints["cond aas"] = 13;
                            if v263.AntiAim["yaw_base_" .. v1311] then
                                v1197.yaw_base1:override(v1312.yaw_base1);
                            end;
                            local v1320 = v1307 - 1;
                            if v1320 ~= -1 then
                                v1197.yaw_base1:override("Local View");
                                v1197.freestand:override(false);
                            end;
                            if v1320 > 3 then
                                v260.breakpoints["cond aas"] = 14;
                                v1197.yaw_base:override(v1216[1]);
                                if v1320 == 4 then
                                    v1197.freestand:override(true);
                                end;
                            else
                                v1319 = v1319 + (v1228[v1320 + 1] or 0);
                            end;
                        else
                            v1319 = v1319 + v67.functions.on_use_aa_yaw_override;
                        end;
                        v260.breakpoints["cond aas"] = 16;
                        if not l_functions_0.rolldesync then
                            v260.breakpoints["cond aas"] = 17;
                            local v1321 = not l_functions_0.should_stop_jittering and v1312.yaw_mod or "Disabled";
                            local v1322 = not l_functions_0.should_stop_jittering and #v1312.fake_opt ~= 0 and not v1318.is_delay;
                            if v1322 then
                                v1197.fakeopt:override(v1312.fake_opt);
                            end;
                            local v1323 = l_functions_0.anti_bruteforce > globals.realtime and v1321 == "Disabled";
                            v67.ab_working = v1323;
                            if v1322 then
                                local v1324 = false;
                                for _, v1326 in ipairs(v1312.fake_opt) do
                                    if v1326 == "Jitter" then
                                        v1324 = true;
                                        break;
                                    end;
                                end;
                                if not v1324 and not v1323 then
                                    rage.antiaim:inverter(v1312.inverted);
                                end;
                            elseif not v1323 then
                                rage.antiaim:inverter(v1312.inverted);
                            end;
                            if v1307 == 0 and not v1318.is_delay then
                                local v1327 = v1312.yaw_add or 0;
                                local v1328 = v1312.yaw_add1 or 0;
                                local v1329 = v1312.yaw_add_main or 0;
                                if v1309 == 5 then
                                    local l_m_bIsScoped_0 = v1304.m_bIsScoped;
                                    local v1331 = v1304:get_player_weapon();
                                    if v1331 then
                                        local v1332 = v1331:get_weapon_info();
                                        local v1333 = l_m_bIsScoped_0 and v1332.max_player_speed_alt or v1332.max_player_speed;
                                        if v1304.m_flDuckAmount == 1 then
                                            v1333 = v1333 / 100 * 34;
                                        end;
                                        local v1334 = #v1304.m_vecVelocity;
                                        local v1335 = v1333 - v1333 / 100 * 10;
                                        local v1336 = v1334 > 1.2 and v1334 < v1335;
                                        if v1335 / 1.8 < v1334 then
                                            v1327 = v1327 - 10;
                                            v1328 = v1328 - 6;
                                            v1329 = v1329 - 8;
                                        end;
                                        if (v1303.in_forward or v1303.in_back) and v1303.in_moveright and v1334 > 1.2 and not v1336 then
                                            v1327 = v1327 + 10;
                                            v1328 = v1328 + 6;
                                            v1329 = v1329 + 8;
                                        end;
                                    end;
                                end;
                                if v1312.fake_opt_combo_2 and v1312.body_yaw and v1328 + v1327 ~= 0 then
                                    if l_v1302_0 then
                                        v1319 = v1319 + v1327;
                                        v1301 = v1327;
                                    else
                                        v1319 = v1319 + v1328;
                                        v1301 = v1328;
                                    end;
                                else
                                    v1319 = v1319 + v1329;
                                end;
                            end;
                            local l_yaw_mod_d_0 = v1312.yaw_mod_d;
                            local _ = v1312.yaw_mod_deg_type;
                            if v1312.yaw_mod_deg_random ~= 0 then
                                if v1201 % 2 == 0 or v1292 == nil then
                                    v1292 = utils.random_int(0, (l_yaw_mod_d_0 > 0 and 1 or -1) * v1312.yaw_mod_deg_random);
                                end;
                                l_yaw_mod_d_0 = v1195(l_yaw_mod_d_0 + v1292);
                            end;
                            if v1312.yaw_mod_ab and v67.ab_phase ~= 0 then
                                l_yaw_mod_d_0 = v1313[v67.ab_phase % #v1313 + 1];
                            end;
                            if v1321 == "Shaitan" then
                                if v1303.choked_commands == 0 then
                                    v1291 = l_yaw_mod_d_0 * v1289[v1288];
                                    v1288 = v1288 + 1;
                                    if v1288 > #v1289 then
                                        v1288 = 1;
                                    end;
                                end;
                                v1319 = v1319 + v1291;
                            elseif v1321 == "AcidTech" and v1307 == 0 then
                                v1318.ticks = v1318.ticks + 1;
                                local l_acid_mode_0 = v1312.acid_mode;
                                local v1340 = v1296[l_acid_mode_0];
                                local v1341 = v1340[v1201 % #v1340 + 1];
                                if v1312.delay_1 ~= 4 and not v1318.is_delay and v1318.ticks % v1312.delay_1 == 0 and (v1309 ~= 8 or not l_functions_0.on_use_aa) then
                                    v1318.is_delay = true;
                                end;
                                local v1342 = false;
                                if v1318.is_delay then
                                    if v1318.current < v1312.delay_2 then
                                        v1318.current = v1318.current + 1;
                                        if v1312.delay_safe then
                                            local v1343 = v1266[1][v1304.m_iTeamNum];
                                            v1319 = v1343.offset;
                                            v1197.limit1:override(v1343.left_limit);
                                            v1197.limit2:override(v1343.right_limit);
                                            v1342 = true;
                                        end;
                                        v1319 = v1319 + v1301;
                                    else
                                        v1318.is_delay = false;
                                        v1318.ticks = 0;
                                        v1318.current = 0;
                                        v1318.previous_angle = 0;
                                        v1301 = 0;
                                    end;
                                else
                                    local v1344 = 0;
                                    if l_acid_mode_0 == "2-Way" and v1312.fake_opt_combo_2 and v1312.body_yaw then
                                        v1344 = math.normalize_yaw(v1319 + (l_v1302_0 and l_yaw_mod_d_0 / 2 or l_yaw_mod_d_0 * -1 / 2));
                                    else
                                        v1344 = math.normalize_yaw(v1319 + l_yaw_mod_d_0 * v1341);
                                    end;
                                    v1318.previous_angle = v1344;
                                end;
                                if not v1342 then
                                    v1319 = v1318.previous_angle;
                                end;
                            else
                                v1299();
                                v1197.yaw_mod:override(v1321);
                                v1197.yaw_mod_d:override(l_yaw_mod_d_0);
                            end;
                            v260.breakpoints["cond aas"] = 18;
                            v1197.yaw_add:override(v1319);
                            v260.breakpoints["cond aas"] = 19;
                        end;
                        v67.yaw = v1319;
                        return;
                    end;
                end;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v260 (ref), v67 (ref), v178 (ref), v263 (ref)
    local _ = -1;
    v260:add("draw", "warmup disablers", function()
        -- upvalues: v67 (ref), v178 (ref), v263 (ref)
        v67.on_warmup = false;
        if not v178.antiaim or not v263.AntiAim.tweaks:get(1) then
            return;
        else
            local v1346 = entity.get_game_rules();
            if not v1346 then
                return;
            elseif not v1346.m_bWarmupPeriod then
                return;
            else
                v67.on_warmup = true;
                return;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v314 (ref), v885 (ref), v260 (ref), v67 (ref), v178 (ref), v263 (ref), l_functions_0 (ref)
    local v1347 = false;
    local v1348 = 0;
    hostage_check = function(v1349)
        local v1350 = entity.get_entities(97);
        for _, v1352 in pairs(v1350) do
            local v1353 = v1352:get_origin();
            if v1353 and v1353:dist(v1349) < 64 then
                return false;
            end;
        end;
        return true;
    end;
    bomb_check = function(v1354)
        local v1355 = v1354:get_player_weapon();
        if v1355 then
            if v1355:get_weapon_index() == 34 then
                return false;
            else
                return true;
            end;
        else
            return false;
        end;
    end;
    defuse_check = function(v1356)
        local v1357 = entity.get_entities(129);
        for _, v1359 in pairs(v1357) do
            local v1360 = v1359:get_origin();
            if v1360 and v1360:dist(v1356) < 100 then
                return false;
            end;
        end;
        return true;
    end;
    local v1361 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Pitch");
    local v1362 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset");
    local v1363 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter");
    local v1364 = -1;
    local function v1365()
        -- upvalues: v1364 (ref), v1361 (ref), v1362 (ref), v885 (ref), v1363 (ref)
        if v1364 ~= -1 then
            v1361:override();
            v1362:override();
            v885.yaw_base:override();
            v885.yaw_base1:override();
            v885.freestand:override();
            v1363:override();
            v1364 = -1;
        end;
    end;
    local l_antiaim_3 = rage.antiaim;
    v260:add("prediction", "On use anti-aim", function(v1367, v1368, v1369)
        -- upvalues: v67 (ref), v178 (ref), v263 (ref), v1365 (ref), v1348 (ref), v1347 (ref), v885 (ref), v1361 (ref), v1362 (ref), l_antiaim_3 (ref), l_functions_0 (ref), v1363 (ref), v1364 (ref)
        v67.functions.on_use_aa = false;
        v67.functions.on_use_aa_yaw_override = 0;
        if not v1369 or not v178.antiaim or not v263.AntiAim.tweaks:Get(4) then
            return v1365();
        else
            local l_in_use_0 = v1367.in_use;
            local v1371 = false;
            if l_in_use_0 then
                local v1372 = v1368:get_origin();
                v1371 = hostage_check(v1372) and bomb_check(v1368) and defuse_check(v1372);
                if v1371 then
                    v1348 = not v1347 and globals.tickcount or v1348;
                    v1347 = true;
                    v885.freestand:override(false);
                    v1361:override("Disabled");
                    v67.functions.on_use_aa_yaw_override = 180;
                    if not v178.antiaim or v263.AntiAim.mode:get() == "Default" then
                        v1362:override(180);
                    end;
                    l_antiaim_3:inverter(v67.ab_working and l_functions_0.anti_bruteforce_side or not v1363:get());
                    if v1364 == -1 then
                        v1364 = v885.yaw_base:get();
                    end;
                    v885.yaw_base1:override("Local View");
                else
                    v1347 = false;
                    v1365();
                end;
            else
                v1347 = false;
                v1365();
            end;
            l_functions_0.on_use_aa = v1347;
            if v1348 + 4 <= globals.tickcount and v1371 then
                v1367.in_use = false;
            end;
            return;
        end;
    end);
    v260:add("destroy", "ebalop zavali", v1365);
end)();
(function()
    -- upvalues: l_functions_0 (ref), v1195 (ref), l_abs_1 (ref), v885 (ref), l_ui_0 (ref), v260 (ref), v178 (ref), v67 (ref), v263 (ref)
    local function v1376(v1373, v1374, v1375)
        return v1373 + (v1374 - v1373) * v1375;
    end;
    local function v1379(v1377, v1378)
        return v1377.flYaw < v1378.flYaw;
    end;
    local l_sort_0 = table.sort;
    local _ = rage.antiaim;
    local function v1394(v1382, v1383)
        -- upvalues: l_functions_0 (ref), v1195 (ref), l_sort_0 (ref), v1379 (ref), v1376 (ref), l_abs_1 (ref)
        if not v1382 then
            return;
        elseif l_functions_0.on_use_aa then
            return;
        else
            local v1384 = {};
            local v1385 = nil;
            local v1386 = v1382:get_eye_position() + vector(0, 0, 10);
            for v1387 = 18, 360, 18 do
                v1387 = v1195(v1387);
                local v1388 = v1386 + vector():angles(0, v1387) * 96;
                local v1389 = utils.trace_line(v1386, v1388, v1382, 33570827);
                local l_entity_0 = v1389.entity;
                if l_entity_0 and l_entity_0:get_classname() == "CWorld" and v1389.fraction < 0.35 then
                    v1384[#v1384 + 1] = {
                        vecTraceEnd = v1389.end_pos, 
                        flYaw = v1387
                    };
                end;
            end;
            l_sort_0(v1384, v1379);
            if #v1384 >= 2 then
                v1385 = (v1386 - v1376(v1384[1].vecTraceEnd, v1384[#v1384].vecTraceEnd, 0.5)):angles();
            end;
            if v1385 then
                local l_y_1 = v1383.view_angles.y;
                local l_y_2 = v1385.y;
                local v1393 = v1195(l_y_2 - l_y_1);
                if l_abs_1(v1393) < 90 then
                    v1393 = 0;
                    l_y_1 = v1195(l_y_2 + 180);
                end;
                return v1195(-l_y_1 + l_y_2 + v1393 + 180);
            else
                return;
            end;
        end;
    end;
    local v1395 = -1;
    local function v1396()
        -- upvalues: v1395 (ref), v885 (ref)
        if v1395 ~= -1 then
            v885.yaw_base:override();
            v885.yaw_base1:override();
            v885.freestand:override();
            v885.yaw_add:override();
            v1395 = -1;
        end;
    end;
    local v1397 = l_ui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
    v260:add("prediction", "edge yaw bratka", function(v1398, v1399, v1400)
        -- upvalues: l_functions_0 (ref), v178 (ref), v67 (ref), v1396 (ref), v263 (ref), v1397 (ref), v1394 (ref), v1395 (ref), v885 (ref)
        l_functions_0.edge_yaw = false;
        if not v178.antiaim or not v1400 or v67.on_warmup then
            return v1396();
        else
            local v1401 = v263.AntiAim.tweaks:get(2);
            local v1402 = v263.AntiAim.tweaks:get(3);
            local v1403 = v1401 and v1402;
            if not v1403 then
                if v1401 then
                    v1403 = not v1397:get();
                elseif v1402 then
                    v1403 = v1397:get();
                end;
            end;
            if not v1403 then
                return v1396();
            else
                local v1404 = v1394(v1399, v1398);
                if v1404 then
                    if v1395 == -1 then
                        v1395 = v885.yaw_base:get();
                    end;
                    v885.yaw_base:override("Backward");
                    v885.yaw_base1:override("Local View");
                    v885.yaw_add:override(v1404);
                    l_functions_0.edge_yaw = true;
                else
                    v1396();
                end;
                return;
            end;
        end;
    end);
    v260:add("destroy", "globals", v1396);
end)();
(function()
    -- upvalues: v260 (ref), v178 (ref), v67 (ref), v684 (ref), v263 (ref), l_functions_0 (ref)
    local v1405 = 0;
    local function v1416(v1406, v1407, v1408)
        local v1409 = v1408 - v1406;
        local v1410 = v1407 - v1406;
        local v1411 = v1410:length();
        v1410.x = v1410.x / v1411;
        v1410.y = v1410.y / v1411;
        v1410.z = v1410.z / v1411;
        local v1412 = v1410.x * v1409.x + v1410.y * v1409.y + v1410.z * v1409.z;
        if v1412 < 0 then
            return v1406;
        elseif v1411 < v1412 then
            return v1407;
        else
            local v1413 = v1406.x + v1410.x * v1412;
            local v1414 = v1406.y + v1410.y * v1412;
            local v1415 = v1406.z + v1410.z * v1412;
            return vector(v1413, v1414, v1415);
        end;
    end;
    local v1417 = 0;
    v260:add("bullet_impact", "anti brute bratka", function(v1418, v1419, v1420)
        -- upvalues: v178 (ref), v67 (ref), v684 (ref), v1416 (ref), v1405 (ref), v263 (ref), l_functions_0 (ref), v1417 (ref)
        if not v178.antiaim or not v1418 then
            return;
        elseif v67.full_aa_stop then
            return;
        else
            local v1421 = v684.GetPlayerForUserID(v1418.userid);
            if not v1420 or not v1421 or v1419 == v1421 then
                return;
            else
                local v1422 = v1419:get_eye_position();
                local v1423 = v1421:get_eye_position();
                if not v1423 then
                    return;
                else
                    local v1424 = vector(v1418.x, v1418.y, v1418.z);
                    if v1416(v1423, v1424, v1422):dist(v1422) > 60 or globals.tickcount == v1405 then
                        return;
                    else
                        if v263.AntiAim.tweaks:get(5) then
                            l_functions_0.anti_bruteforce = globals.realtime + 3;
                            l_functions_0.anti_bruteforce_side = not rage.antiaim:inverter();
                        end;
                        v67.ab_phase = v67.ab_phase + 1;
                        v1417 = globals.realtime + 3;
                        v1405 = globals.tickcount;
                        return;
                    end;
                end;
            end;
        end;
    end);
    v260:add("prediction", "anti brute bratka jopka", function(_, _, _)
        -- upvalues: v67 (ref), v1417 (ref), v178 (ref), v263 (ref), l_functions_0 (ref)
        if v67.ab_phase ~= 0 and v1417 < globals.realtime then
            v67.ab_phase = 0;
        end;
        if not v178.antiaim or not v263.AntiAim.tweaks:get(5) then
            l_functions_0.anti_bruteforce = -1;
            return;
        else
            if v67.ab_working then
                rage.antiaim:inverter(l_functions_0.anti_bruteforce_side);
            else
                l_functions_0.anti_bruteforce = -1;
            end;
            return;
        end;
    end);
end)();
(function()
    -- upvalues: v314 (ref), v885 (ref), v260 (ref), l_functions_0 (ref), v178 (ref), v263 (ref), v179 (ref), v67 (ref)
    local v1428 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options");
    local v1429 = v314.FindVar("Aimbot", "Anti Aim", "Angles", "Yaw Modifier");
    local v1430 = nil;
    local v1431 = nil;
    local function v1433()
        -- upvalues: v1430 (ref), v1431 (ref), v1428 (ref), v1429 (ref), v885 (ref)
        if v1430 and v1431 then
            v1428:override();
            v1429:override();
            v885.yaw_add:override();
            local v1432 = nil;
            v1431 = nil;
            v1430 = v1432;
        end;
    end;
    v260:add("prediction", "static manuals", function(_, _, v1436)
        -- upvalues: l_functions_0 (ref), v178 (ref), v263 (ref), v179 (ref), v67 (ref), v1433 (ref), v1430 (ref), v1431 (ref), v1429 (ref), v1428 (ref)
        l_functions_0.should_stop_jittering = v1436 and v178.antiaim and v263.AntiAim.static_manuals:get() and (not (v179.manual_yb ~= "Right") or v179.manual_yb == "Left");
        if v67.full_aa_stop then
            return v1433();
        elseif l_functions_0.should_stop_jittering and v263.AntiAim.mode:Get() == "Default" then
            if not v1430 or not v1431 then
                local v1437 = v1429:get();
                v1431 = v1428:get();
                v1430 = v1437;
            end;
            v1429:override("Disabled");
            local v1438 = {};
            for v1439 = 1, #v1431 do
                if v1431[v1439] ~= "Jitter" then
                    v1438[#v1438 + 1] = v1431[v1439];
                end;
            end;
            rage.antiaim:inverter(false);
            v1428:override(v1438);
            return;
        else
            return v1433();
        end;
    end);
    v260:add("destroy", "static manuals destr", v1433);
end)();
local _ = nil;
local v1441 = nil;
v1441 = {};
local v1442 = {};
do
    local l_v1442_0 = v1442;
    v1441.add_animation = function(v1444, v1445, v1446, v1447, v1448)
        -- upvalues: l_v1442_0 (ref)
        table.insert(l_v1442_0, {
            progress = 0, 
            type = 0, 
            player = v1444, 
            layer = v1445, 
            sequence = v1446, 
            speed = v1447 or 1, 
            weight = v1448 or false
        });
    end;
    v1441.add_repeated_animation = function(v1449, v1450, v1451, v1452, v1453, v1454, v1455, v1456)
        -- upvalues: l_v1442_0 (ref)
        table.insert(l_v1442_0, {
            progress = 0, 
            time_iteration = 0, 
            times = 0, 
            type = 1, 
            player = v1449, 
            layer = v1450, 
            sequence = v1451, 
            min_cycle = v1452, 
            max_cycle = v1453, 
            anim_times = v1454, 
            speed = v1455 or 1, 
            weight = v1456 or false
        });
    end;
    v1441.process = function(v1457, v1458)
        -- upvalues: l_v1442_0 (ref)
        for v1459, v1460 in ipairs(l_v1442_0) do
            if v1460.player == v1457 then
                local v1461 = v1458[v1460.layer];
                v1461.sequence = v1460.sequence;
                if v1460.weight then
                    v1461.weight = v1460.weight;
                end;
                if v1460.type == 0 then
                    v1461.cycle = v1460.progress / 100;
                    v1460.progress = v1460.progress + v1460.speed;
                elseif v1460.type == 1 then
                    local v1462 = (1 - math.cos(v1460.progress)) / 2;
                    v1461.cycle = v1460.min_cycle + v1460.max_cycle * v1462;
                    v1460.progress = (v1460.progress + v1460.speed) % 100;
                    if v1462 >= 0.99 and v1460.time_iteration < globals.tickcount then
                        v1460.times = v1460.times + 0.5;
                        v1460.time_iteration = globals.tickcount + v1460.speed * (v1460.min_cycle + v1460.max_cycle) * 2500;
                    end;
                end;
            end;
            if v1460.type == 0 then
                if v1460.progress >= 100 then
                    table.remove(l_v1442_0, v1459);
                end;
            elseif v1460.type == 1 and v1460.times == v1460.anim_times then
                table.remove(l_v1442_0, v1459);
            end;
        end;
    end;
end;
v1442 = ffi.typeof("        struct {\n            float   anim_time;\n            float   fade_out_time;\n            int     flags;\n            int     activty;\t\n            int     priority;\n            int     order;\t\t\t\n            int     sequence;\n            float   prev_cycle;\n            float   weight;\n            float   weight_delta_rate;\n            float   playback_rate;\n            float   cycle;\n            int     owner;\n            int     bits;\n        }\n    ");
local v1463 = utils.opcode_scan("client.dll", "74 36 8B 06 FF 90 ? ? ? ?", -14);
local v1464 = l_ui_0.find("Aimbot", "Anti Aim", "Misc", "Leg Movement");
local l_anim_breakers_0 = v263.AntiAim.anim_breakers;
local v1466 = false;
local v1467 = false;
local v1468 = false;
do
    local l_v1441_0, l_v1442_1, l_v1464_0, l_l_anim_breakers_0_0, l_v1466_0, l_v1467_0, l_v1468_0 = v1441, v1442, v1464, l_anim_breakers_0, v1466, v1467, v1468;
    v260:add("post_update_clientside_animation", "csa", function(v1476, _, _)
        -- upvalues: l_l_anim_breakers_0_0 (ref), l_v1464_0 (ref), l_v1442_1 (ref), l_v1441_0 (ref), v263 (ref), l_v1466_0 (ref), v673 (ref), l_v1468_0 (ref), l_v1467_0 (ref)
        if not l_l_anim_breakers_0_0:get() then
            return l_v1464_0:override();
        else
            local v1479 = entity.get_local_player();
            if not v1479 then
                return;
            else
                local v1480 = v1479[0];
                if v1480 == 0 then
                    return;
                else
                    v1480 = ffi.cast("int", v1480);
                    if v1476 == v1479 then
                        local v1481 = ffi.cast(ffi.typeof("$**", l_v1442_1), v1480 + 10640)[0];
                        l_v1441_0.process(v1479, v1481);
                        local l_m_flPoseParameter_0 = v1479.m_flPoseParameter;
                        if v263.AntiAim.anim_global:get(1) and ffi.cast("bool*", ffi.cast("uintptr_t*", v1480 + 39264)[0] + 265)[0] and not l_v1466_0 and v673 > 8 and v673 < 100 then
                            l_m_flPoseParameter_0[12] = 0.5;
                        end;
                        if v263.AntiAim.anim_global:get(2) and l_v1468_0 then
                            v1481[6].weight = 0;
                        end;
                        if v263.AntiAim.anim_global:get(3) then
                            v1481[7].sequence = 217;
                            v1481[7].weight = 1;
                        end;
                        if v673 > 3 then
                            local v1483 = v263.AntiAim.anim_walking:get();
                            if v1483 == "Static Legs" then
                                l_m_flPoseParameter_0[0] = 1;
                                l_v1464_0:override("Sliding");
                                l_v1467_0 = true;
                            elseif v1483 == "0 iq" then
                                l_m_flPoseParameter_0[7] = 0.5;
                                v1481[6].cycle = v1481[6].cycle * 1.5 % 1;
                                l_v1464_0:override("Walking");
                            elseif v1483 == "Frog Walk" then
                                v1481[12].sequence = 21;
                                v1481[12].weight = 1;
                                l_v1464_0:override("Walking");
                            elseif l_v1467_0 then
                                l_v1464_0:override();
                                l_v1467_0 = false;
                            end;
                        else
                            local v1484 = v263.AntiAim.anim_air:get();
                            if v1484 == "Static Legs" then
                                l_m_flPoseParameter_0[6] = 1;
                            elseif v1484 == "0 iq" then
                                v1481[6].weight = 1;
                                v1481[6].cycle = v1481[6].cycle * 1.3 % 1;
                            elseif v1484 == "Frog Walk" then
                                v1481[12].sequence = 21;
                                v1481[12].weight = 1;
                                l_v1464_0:override("Walking");
                            elseif l_v1467_0 then
                                l_v1464_0:override();
                                l_v1467_0 = false;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end);
    local v1485 = {
        Gym = {
            [1] = 0, 
            [2] = 232, 
            [3] = 0.645, 
            [4] = 0.08, 
            [5] = 2, 
            [6] = 0.03, 
            [7] = 100
        }, 
        Pray = {
            [1] = 0, 
            [2] = 232, 
            [3] = 0.4, 
            [4] = 0.22, 
            [5] = 2, 
            [6] = 0.05, 
            [7] = 100
        }, 
        Stretching = {
            [1] = 0, 
            [2] = 11, 
            [3] = 0, 
            [4] = 0.8, 
            [5] = 4, 
            [6] = 0.002, 
            [7] = 100
        }
    };
    v263.AntiAim.anim_freeze:set_callback(function(v1486)
        -- upvalues: v1485 (ref), l_v1441_0 (ref)
        local v1487 = v1486:get();
        if v1487 ~= "Disabled" and v1485[v1487] then
            local v1488 = entity.get_local_player();
            if v1488 ~= nil then
                l_v1441_0.add_repeated_animation(v1488, unpack(v1485[v1487]));
            end;
        end;
    end);
    v260:add("round_start", "anim bilderushka", function(_, v1490, v1491)
        -- upvalues: l_l_anim_breakers_0_0 (ref), v263 (ref), l_v1441_0 (ref), v1485 (ref)
        if not v1491 or not l_l_anim_breakers_0_0:get() then
            return;
        else
            local v1492 = v263.AntiAim.anim_freeze:get();
            if v1492 == "Disabled" then
                return;
            else
                l_v1441_0.add_repeated_animation(v1490, unpack(v1485[v1492]));
                return;
            end;
        end;
    end);
    local v1493 = ffi.typeof("struct {float x, y, z;}");
    local v1494 = v37.rel_jmp(utils.opcode_scan("client.dll", "E8 ? ? ? ? 5F 5E 5D C2 04 00 8B 0D ? ? ? ? 81 F9 ? ? ? ?"));
    local v1495 = utils.get_vfunc(2, ffi.typeof("$*(__thiscall*)(void*)", v1493));
    local v1496 = ffi.cast(ffi.typeof("void(__thiscall*)(void*, $*)", v1493), v37.rel_jmp("client.dll", "E8 ? ? ? ? 53 8D 45 F0"));
    local v1497 = utils.get_vfunc(219, "void(__thiscall*)(void*, int)");
    local v1498 = ffi.cast("int(__thiscall*)(void*, const char*)", v37.rel_jmp("client.dll", "E8 ? ? ? ? 5E 83 F8 FF"));
    local v1499 = {
        ffi.cast("void(__thiscall*)(void*, float*)", v37.rel_jmp("client.dll", "E8 ? ? ? ? EB 19 8B 07")), 
        ffi.cast("void(__thiscall*)(void*, float*)", v37.rel_jmp("client.dll", "E8 ? ? ? ? EB 57 8D 44 24 24")), 
        ffi.cast("void(__thiscall*)(void*, void*)", v37.rel_jmp("client.dll", "E8 ? ? ? ? 8B 46 04 8D 4E 04 FF 50 28")), 
        ffi.cast("void(__thiscall*)(void*)", v37.rel_jmp("client.dll", "E8 ? ? ? ? 83 BE ? ? ? ? ? 74 16"))
    };
    do
        local l_v1495_0, l_v1496_0, l_v1497_0, l_v1498_0, l_v1499_0 = v1495, v1496, v1497, v1498, v1499;
        v37.set("ragdoll", v1494, "void(__thiscall*)(void*)", function(v1505, v1506)
            -- upvalues: l_l_anim_breakers_0_0 (ref), v263 (ref), l_v1499_0 (ref), l_v1495_0 (ref), l_v1496_0 (ref), l_v1498_0 (ref), l_v1497_0 (ref)
            if not l_l_anim_breakers_0_0:get() or v263.AntiAim.anim_kill:get() == "Disabled" then
                return v1505(v1506);
            else
                local v1507 = ffi.cast("uintptr_t", v1506);
                if v1507 == 0 then
                    return v1505(v1506);
                else
                    l_v1499_0[1](v1506, ffi.cast("float*", v1507 + 2695));
                    l_v1499_0[2](v1506, ffi.cast("float*", v1507 + 2692));
                    ffi.cast("int*", v1507 + 10429)[0] = 1;
                    local v1508 = entity.get(v1506);
                    if v1508 == nil then
                        return v1505(v1506);
                    else
                        local l_m_hPlayer_0 = v1508.m_hPlayer;
                        if not l_m_hPlayer_0 then
                            return v1505(v1506);
                        else
                            local v1510 = ffi.cast("void*", l_m_hPlayer_0[0]);
                            local v1511 = ffi.cast("uintptr_t", l_m_hPlayer_0[0]);
                            local v1512 = ffi.cast("bool*", v1511 + 39700);
                            if v1512[0] then
                                l_v1499_0[3](v1510, v1506);
                            end;
                            local v1513 = l_v1495_0(ffi.cast("void*", v1511 + 4));
                            l_v1496_0(v1506, v1513[0]);
                            local v1514 = ffi.cast("float*", v1506);
                            v1514[75] = v1513.x;
                            v1514[76] = v1513.y;
                            v1514[77] = v1513.z;
                            if v1512[0] then
                                l_v1499_0[4](v1510);
                            end;
                            local v1515 = utils.random_int(0, 1) == 0 and l_v1498_0(v1510, "deathpose_lowviolence") or 262;
                            l_v1497_0(v1506, v1515 == -1 and 232 or v1515);
                            ffi.cast("int*", v1507 + 10400)[0] = 1;
                            return;
                        end;
                    end;
                end;
            end;
        end);
    end;
    v1493 = l_ui_0.find("Aimbot", "Anti Aim", "Misc", "Slow Walk");
    v260:add("prediction", "animushe4ka bildorushe4ka", function(v1516, _, v1518)
        -- upvalues: l_l_anim_breakers_0_0 (ref), l_v1466_0 (ref), l_v1468_0 (ref), v1493 (ref)
        if not v1518 or not l_l_anim_breakers_0_0:get() then
            return;
        else
            l_v1466_0 = v1516.in_jump;
            l_v1468_0 = v1493:get();
            return;
        end;
    end);
end;
(function()
    -- upvalues: v263 (ref), v179 (ref), v260 (ref), v178 (ref), v684 (ref)
    local v1519 = utils.get_vfunc("client.dll", "GameClientExports001", 3, "void(__thiscall*)(void*, int)");
    v263.Misc.auto_unmute:RegisterCallback(function()
        -- upvalues: v179 (ref), v1519 (ref)
        if v179.auto_unmute then
            for _, v1521 in pairs(entity.get_players()) do
                v1519(v1521:get_index());
            end;
        end;
    end);
    v260:add("player_connect_full", "auto unmute", function(v1522, v1523)
        -- upvalues: v178 (ref), v179 (ref), v684 (ref), v1519 (ref)
        if not v178.misc or not v179.auto_unmute then
            return;
        else
            local v1524 = v684.GetPlayerForUserID(v1522.userid);
            if not v1524 then
                return;
            elseif v1524 == v1523 then
                for _, v1526 in pairs(entity.get_players()) do
                    v1519(v1526:get_index());
                end;
                return;
            else
                v1519(v1524:get_index());
                return;
            end;
        end;
    end);
end)();
v1442 = panorama.loadstring("        let entity_panels = {}\n        let entity_data = {}\n        let event_callbacks = {}\n\n        let SLOT_LAYOUT = `\n            <root>\n                <Panel style=\"min-width: 3px; padding-top: 2px; padding-left: 0px;\" scaling='stretch-to-fit-y-preserve-aspect'>\n                    <Image id=\"smaller\" textureheight=\"15\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;\"  />\n                    <Image id=\"small\" textureheight=\"17\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;\" />\n                    <Image id=\"image\" textureheight=\"21\" style=\"opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;\" />\n                </Panel>\n            </root>\n        `\n\n        let _DestroyEntityPanel = function (key) {\n            let panel = entity_panels[key]\n\n            if(panel != null && panel.IsValid()) {\n                var parent = panel.GetParent()\n                let musor = parent.GetChild(0)\n\n                musor.visible = true\n                if(parent.FindChildTraverse(\"id-sb-skillgroup-image\") != null) {\n                    parent.FindChildTraverse(\"id-sb-skillgroup-image\").style.margin = \"0px 0px 0px 0px\"\n                }\n\n                panel.DeleteAsync(0.0)\n            }\n            delete entity_panels[key]\n        }\n\n        let _DestroyEntityPanels = function() {\n            for(key in entity_panels){\n                _DestroyEntityPanel(key)\n            }\n        }\n\n        let _GetOrCreateCustomPanel = function(xuid) {\n            if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){\n                entity_panels[xuid] = null\n\n                let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse(\"ScoreboardContainer\").FindChildTraverse(\"Scoreboard\") || $.GetContextPanel().FindChildTraverse(\"id-eom-scoreboard-container\").FindChildTraverse(\"Scoreboard\")\n\n                if(scoreboard_context_panel == null){\n                    _Clear()\n                    _DestroyEntityPanels()\n\n                    return\n                }\n\n                scoreboard_context_panel.FindChildrenWithClassTraverse(\"sb-row\").forEach(function(el){\n                    let scoreboard_el\n\n                    if(el.m_xuid == xuid) {\n                        el.Children().forEach(function(child_frame){\n                            let stat = child_frame.GetAttributeString(\"data-stat\", \"\")\n                            if(stat == \"rank\")\n                                scoreboard_el = child_frame.GetChild(0)\n                        })\n\n                        if(scoreboard_el) {\n                            let scoreboard_el_parent = scoreboard_el.GetParent()\n\n                            let custom_icons = $.CreatePanel(\"Panel\", scoreboard_el_parent, \"custom-weapons\", {\n                            })\n\n                            if(scoreboard_el_parent.FindChildTraverse(\"id-sb-skillgroup-image\") != null) {\n                                scoreboard_el_parent.FindChildTraverse(\"id-sb-skillgroup-image\").style.margin = \"0px 0px 0px 0px\"\n                            }\n\n                            scoreboard_el_parent.MoveChildAfter(custom_icons, scoreboard_el_parent.GetChild(1))\n\n                            let prev_panel = scoreboard_el_parent.GetChild(0)\n                            prev_panel.visible = false\n\n                            let panel_slot_parent = $.CreatePanel(\"Panel\", custom_icons, `icon`)\n\n                            panel_slot_parent.visible = false\n                            panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)\n\n                            entity_panels[xuid] = custom_icons\n\n                            return custom_icons\n                        }\n                    }\n                })\n            }\n\n            return entity_panels[xuid]\n        }\n\n        let _UpdatePlayer = function(entindex, path_to_image) {\n            if(entindex == null || entindex == 0)\n                return\n\n            entity_data[entindex] = {\n                applied: false,\n                image_path: path_to_image\n            }\n        }\n\n        let _ApplyPlayer = function(entindex) {\n            let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)\n\n            let panel = _GetOrCreateCustomPanel(xuid)\n\n            if(panel == null)\n                return\n\n            let panel_slot_parent = panel.FindChild(`icon`)\n            panel_slot_parent.visible = true\n\n            let panel_slot = panel_slot_parent.FindChild(\"image\")\n            panel_slot.visible = true\n            panel_slot.style.opacity = \"1\"\n            panel_slot.SetImage(entity_data[entindex].image_path)\n\n            return true\n        }\n\n        let _ApplyData = function() {\n            for(entindex in entity_data) {\n                entindex = parseInt(entindex)\n\n                let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)\n\n                if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {\n                    if(_ApplyPlayer(entindex)) {\n                        entity_data[entindex].applied = true\n                    }\n                }\n            }\n        }\n\n        let _Create = function() {\n            event_callbacks[\"OnOpenScoreboard\"] = $.RegisterForUnhandledEvent(\"OnOpenScoreboard\", _ApplyData)\n            event_callbacks[\"Scoreboard_UpdateEverything\"] = $.RegisterForUnhandledEvent(\"Scoreboard_UpdateEverything\", function(){\n                _ApplyData()\n            })\n            event_callbacks[\"Scoreboard_UpdateJob\"] = $.RegisterForUnhandledEvent(\"Scoreboard_UpdateJob\", _ApplyData)\n        }\n\n        let _Clear = function() {\n            entity_data = {}\n        }\n\n        let _Destroy = function() {\n            // clear entity data\n            _Clear()\n            _DestroyEntityPanels()\n\n            for(event in event_callbacks){\n                $.UnregisterForUnhandledEvent(event, event_callbacks[event])\n\n                delete event_callbacks[event]\n            }\n        }\n\n        return {\n            create: _Create,\n            destroy: _Destroy,\n            clear: _Clear,\n            update_player: _UpdatePlayer,\n            destroy_panel: _DestroyEntityPanels\n        }\n    ", "CSGOHud")();
v1442.create();
v1463 = (function()
    local l_GetPlayerXuidStringFromEntIndex_0 = panorama.GameStateAPI.GetPlayerXuidStringFromEntIndex;
    return function(v1528)
        -- upvalues: l_GetPlayerXuidStringFromEntIndex_0 (ref)
        if not v1528 then
            return;
        else
            local v1529 = l_GetPlayerXuidStringFromEntIndex_0(v1528:get_index());
            if not v1529 then
                return;
            else
                local v1530 = v1529:sub(4, -1);
                if #v1530 == 0 then
                    return;
                else
                    return 76500000000000000ULL + tonumber(v1530);
                end;
            end;
        end;
    end;
end)();
v1464 = (function()
    ffi.cdef("        \tuint32_t GetModuleHandleA(const char* lpModuleName);\n        \tuint32_t GetProcAddress(uint32_t hModule, const char* lpProcName);\n        ");
    local v1531 = ffi.typeof("            struct {\n        \t\tint m_eType;\n        \t\tint m_cbSize;\n        \t\tunion {\n        \t\t\tuint64_t m_steamID64;\n        \t\t\tchar m_szGenericString[ 32 ];\n        \t\t\tuint8_t m_genericBytes[ 32 ];\n        \t\t\tchar m_szUnknownRawString[ 128 ];\n        \t\t\tvoid* m_ip;\n        \t\t\tuint32_t m_reserved[ 32 ];\n        \t\t};\n        \t}\n        ");
    local v1532 = ffi.typeof("            struct {\n                void* m_pData;\n                int m_cbSize;\n                unsigned int m_conn;\n                $ m_identityPeer;\n                int64_t m_nConnUserData;\n                long long m_usecTimeReceived;\n                int64_t m_nMessageNumber;\n                void(__thiscall* m_pfnFreeData)(void*);\n                void(__thiscall* m_pfnRelease)(void*);\n                int m_nChannel;\n                int m_nFlags;\n                int64_t m_nUserData;\n            }\n        ", v1531);
    local v1533 = ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("steamnetworkingsockets.dll"), "SteamNetworkingMessages_LibV2");
    assert(v1533 ~= 0, "failed to get steam_networking_messages");
    local l_v1531_0 = v1531;
    local v1535 = ffi.typeof("$* [?]", v1532);
    local v1536 = ffi.cast("void***", ffi.cast("void*(__thiscall*)()", v1533)());
    local v1537 = ffi.cast(ffi.typeof("int(__thiscall*)(void*, const $&, const void *, uint32_t, int, int)", v1531), v1536[0][0]);
    local v1538 = ffi.cast(ffi.typeof("int(__thiscall*)(void*, int, $, int)", v1535), v1536[0][1]);
    local v1539 = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", v1531), v1536[0][2]);
    local v1540 = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const $&)", v1531), v1536[0][3]);
    local v1541 = 2000;
    local function v1548(v1542, v1543, v1544)
        -- upvalues: l_v1531_0 (ref), v1537 (ref), v1536 (ref), v1541 (ref)
        local v1545 = ffi.cast("uint64_t", v1542);
        local v1546 = ffi.cast("const char*", v1543);
        local v1547 = l_v1531_0();
        v1547.m_eType = 16;
        v1547.m_cbSize = ffi.sizeof(v1545);
        v1547.m_steamID64 = v1545;
        return v1537(v1536, v1547, v1546, v1543:len(), 8, v1544 or v1541);
    end;
    local function v1551(v1549)
        -- upvalues: v1535 (ref), v1538 (ref), v1536 (ref), v1541 (ref)
        local v1550 = v1535(1337);
        return v1538(v1536, v1549 or v1541, v1550, 1337), v1550;
    end;
    local function v1555(v1552)
        -- upvalues: l_v1531_0 (ref), v1540 (ref), v1536 (ref)
        local v1553 = ffi.cast("uint64_t", v1552);
        local v1554 = l_v1531_0();
        v1554.m_eType = 16;
        v1554.m_cbSize = ffi.sizeof(v1553);
        v1554.m_steamID64 = v1553;
        return v1540(v1536, v1554);
    end;
    local function v1559(v1556)
        -- upvalues: l_v1531_0 (ref), v1539 (ref), v1536 (ref)
        local v1557 = ffi.cast("uint64_t", v1556);
        local v1558 = l_v1531_0();
        v1558.m_eType = 16;
        v1558.m_cbSize = ffi.sizeof(v1557);
        v1558.m_steamID64 = v1557;
        return v1539(v1536, v1558);
    end;
    return {
        send_message_to_user = v1548, 
        receive_messages_on_channel = v1551, 
        close_connection_with_user = v1555, 
        accept_session_with_user = v1559
    };
end)();
do
    local l_v1442_2, l_v1463_0, l_v1464_1, l_l_anim_breakers_0_1, l_v1466_1, l_v1467_1 = v1442, v1463, v1464, l_anim_breakers_0, v1466, v1467;
    l_l_anim_breakers_0_1 = (function()
        -- upvalues: l_v1442_2 (ref), v67 (ref), v133 (ref), l_v1463_0 (ref), l_v1464_1 (ref), v2 (ref)
        local v1566 = {};
        local function v1570()
            -- upvalues: v1566 (ref), l_v1442_2 (ref)
            for _, v1568 in pairs(entity.get_players()) do
                local v1569 = v1568:get_index();
                if v1566[v1569] then
                    table.remove(v1566, v1569);
                end;
            end;
            l_v1442_2.destroy_panel();
        end;
        local v1571 = {
            lenin = 1, 
            Mishkat = 1, 
            KuCJloTa1337 = 1, 
            Kikron = 1
        };
        local function v1578()
            -- upvalues: v1570 (ref), v1571 (ref), v67 (ref), v133 (ref), l_v1463_0 (ref), l_v1464_1 (ref)
            local v1572 = entity.get_local_player();
            v1570();
            local v1573 = {
                hash = "fa8a2f2ecbce2b23c7589a4543ff881c", 
                idx = v1572:get_index(), 
                version = v1571[v67.username] and 3 or v67.build == "beta" and 2 or 1
            };
            local v1574 = "[[" .. v133.stringify(v1573) .. "]]";
            for _, v1576 in pairs(entity.get_players()) do
                if v1576 ~= v1572 then
                    local v1577 = l_v1463_0(v1576);
                    if v1577 then
                        l_v1464_1.close_connection_with_user(v1577);
                        l_v1464_1.send_message_to_user(v1577, v1574);
                    end;
                end;
            end;
        end;
        local function v1583()
            -- upvalues: l_v1463_0 (ref), l_v1464_1 (ref)
            local v1579 = entity.get_local_player();
            for _, v1581 in pairs(entity.get_players()) do
                if v1581 ~= v1579 then
                    local v1582 = l_v1463_0(v1581);
                    if v1582 then
                        l_v1464_1.accept_session_with_user(v1582);
                    end;
                end;
            end;
        end;
        local function v1588(v1584)
            -- upvalues: v133 (ref)
            if not v1584 or not v1584:find("fa8a2f2ecbce2b23c7589a4543ff881c") then
                return;
            else
                local v1585 = string.gmatch(v1584, "([^[[]+)([]]]+)")();
                if not v1585 or #v1585 == 0 then
                    return;
                else
                    local l_status_6, l_result_6 = pcall(v133.parse, v1585);
                    if not l_status_6 then
                        return;
                    else
                        return l_result_6;
                    end;
                end;
            end;
        end;
        local v1589 = {
            [1] = "acid", 
            [2] = "acidb", 
            [3] = "acid_dev"
        };
        local function v1592()
            -- upvalues: v1566 (ref), l_v1442_2 (ref), v1571 (ref), v67 (ref)
            local v1590 = entity.get_local_player();
            if v1590 then
                local v1591 = v1590:get_index();
                v1566[v1591] = {
                    backup = -1337, 
                    level = 8525
                };
                l_v1442_2.update_player(v1591, ("file://{images}/icons/acidtech/%s.png"):format(v1571[v67.username] and "acid_dev" or v67.build ~= "beta" and "acid" or "acidb"));
            end;
        end;
        local function v1600()
            -- upvalues: l_v1464_1 (ref), v1588 (ref), v1566 (ref), l_v1463_0 (ref), l_v1442_2 (ref), v1589 (ref), v1592 (ref)
            local v1593, v1594 = l_v1464_1.receive_messages_on_channel();
            for v1595 = 1, v1593 do
                local v1596 = v1594[v1595 - 1][0];
                if v1596 then
                    local v1597 = v1588(ffi.string(v1596.m_pData));
                    if v1597 then
                        local v1598 = entity.get(v1597.idx);
                        if v1598 then
                            v1566[v1597.idx] = {
                                backup = -1337, 
                                level = v1597.version == 0 and 8524 or 8525
                            };
                            local v1599 = l_v1463_0(v1598);
                            if v1599 then
                                l_v1464_1.close_connection_with_user(v1599);
                            end;
                            l_v1442_2.update_player(v1597.idx, ("file://{images}/icons/acidtech/%s.png"):format(v1589[v1597.version]));
                        end;
                    end;
                end;
            end;
            v1592();
        end;
        local v1601 = {
            [1] = "materials", 
            [2] = "panorama", 
            [3] = "images", 
            [4] = "icons", 
            [5] = "acidtech"
        };
        local v1602 = {
            ["acid_dev.png"] = "https://i.imgur.com/BF6BBAk.png", 
            ["acidb.png"] = "https://i.imgur.com/FntUDbe.png", 
            ["acid.png"] = "https://i.imgur.com/JuieUCH.png"
        };
        local v1606 = (function()
            local v1603 = ffi.cast("void***", utils.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"));
            local v1604 = ffi.cast("bool(__thiscall*)(void*, const char*, const char*)", v1603[0][10]);
            return function(v1605)
                -- upvalues: v1604 (ref), v1603 (ref)
                return v1604(v1603, v1605, nil);
            end;
        end)();
        local function v1615()
            -- upvalues: v1601 (ref), v1602 (ref), v1606 (ref), v2 (ref)
            local v1607 = common.get_game_directory() .. "\\";
            for v1608 = 1, #v1601 do
                local v1609 = v1607 .. v1601[v1608];
                files.create_folder(v1609);
                v1607 = v1609 .. "\\";
            end;
            local l_v1607_0 = v1607;
            for v1611, v1612 in pairs(v1602) do
                local v1613 = l_v1607_0 .. v1611;
                if not v1606(v1613) then
                    v2("file didnt exist");
                    local v1614 = network.get(v1612);
                    if v1614 then
                        files.write(v1613, v1614, true);
                    end;
                end;
            end;
        end;
        return {
            update_local = v1592, 
            clean_players = v1570, 
            send_messages = v1578, 
            download_images = v1615, 
            receive_messages = v1600, 
            accept_connections = v1583
        };
    end)();
    l_l_anim_breakers_0_1.download_images();
    l_v1466_1 = false;
    l_v1467_1 = false;
    v260:add("draw", "sync draw", function()
        -- upvalues: l_v1466_1 (ref), v178 (ref), v263 (ref), l_v1467_1 (ref), l_l_anim_breakers_0_1 (ref), l_v1442_2 (ref)
        l_v1466_1 = v178.misc and v263.Misc.synchronization:get();
        if globals.is_connected and globals.is_in_game then
            if l_v1466_1 then
                if not l_v1467_1 then
                    l_l_anim_breakers_0_1.update_local();
                    l_v1467_1 = true;
                end;
            elseif l_v1467_1 then
                l_v1442_2.clear();
                l_l_anim_breakers_0_1.clean_players();
                l_v1467_1 = false;
            end;
        end;
    end);
    v260:add("shutdown", "sync shutdown", function()
        -- upvalues: l_l_anim_breakers_0_1 (ref), l_v1442_2 (ref)
        l_l_anim_breakers_0_1.clean_players();
        if l_v1442_2 and l_v1442_2.destroy then
            l_v1442_2.destroy();
        end;
    end);
    v260.breakpoints["sync round_end"] = -1;
    v260:add("round_end", "sync round_end", function()
        -- upvalues: v260 (ref), l_v1466_1 (ref), l_l_anim_breakers_0_1 (ref), l_v1442_2 (ref)
        v260.breakpoints["sync round_end"] = 0;
        if l_v1466_1 then
            v260.breakpoints["sync round_end"] = 1;
            l_l_anim_breakers_0_1.send_messages();
        else
            v260.breakpoints["sync round_end"] = 2;
            l_l_anim_breakers_0_1.clean_players();
        end;
        v260.breakpoints["sync round_end"] = 3;
        l_v1442_2.clear();
        v260.breakpoints["sync round_end"] = 4;
    end);
    v260:add("round_prestart", "sync round_prestart", function()
        -- upvalues: l_v1466_1 (ref), l_l_anim_breakers_0_1 (ref)
        if l_v1466_1 then
            l_l_anim_breakers_0_1.accept_connections();
        end;
    end);
    v260:add("round_freeze_end", "sync round_freeze_end", function()
        -- upvalues: l_v1466_1 (ref), l_l_anim_breakers_0_1 (ref)
        if l_v1466_1 then
            l_l_anim_breakers_0_1.receive_messages();
        end;
    end);
    v260:add("level_init", "sync level init", function()
        -- upvalues: l_v1442_2 (ref)
        l_v1442_2.clear();
    end);
end;
(function()
    -- upvalues: v260 (ref), v178 (ref), v179 (ref), v684 (ref), v263 (ref)
    local l_random_int_0 = utils.random_int;
    local v1617 = {
        start = {
            [1] = "\208\177\208\187\209\143", 
            [2] = "\208\189\209\131", 
            [3] = "ahah", 
            [4] = "\208\177\208\187\209\143\209\143\209\143", 
            [5] = "\208\191\208\184\208\183\208\180\208\176", 
            [6] = "\209\130\209\131\208\180\208\176", 
            [7] = "\208\186\209\131\208\180\208\176 \208\187\208\181\209\130\208\184\209\136\209\140", 
            [8] = "\208\191\208\190\208\187\209\131\209\135\208\184\208\187 \208\191\208\190 \208\177\208\176\209\136\208\186\208\181", 
            [9] = "1.", 
            [10] = "ez", 
            [11] = "ahah", 
            [12] = "\209\141\209\130\208\190\209\130 \208\188\209\131\208\178", 
            [13] = "\208\189\208\190\209\128\208\188\208\176\209\129", 
            [14] = "\208\189\208\190\209\128\208\188", 
            [15] = "\208\178\208\191\208\181\208\189\208\184\208\187 \208\184\208\180\208\184\208\190\209\130\208\176", 
            [16] = "\208\178\209\129\208\190\209\135\208\189\209\143\209\128\208\184\208\187 \209\133\209\131\208\181\209\129\208\190\209\129\208\176", 
            [17] = "\209\130\209\139 \208\188\208\189\208\181 \208\178 \209\136\208\184\209\128\208\184\208\189\208\186\209\131 \208\180\209\139\209\136\208\184\209\136\209\140", 
            [18] = "\209\129\208\187\208\176\208\178\208\176 \209\131\208\186\209\128\208\176\208\184\208\189\208\184", 
            [19] = "\208\186\209\131\208\180\208\176 \209\129\208\191\209\128\209\143\209\130\208\176\208\187\209\129\209\143", 
            [20] = "\208\188\208\181\208\189\209\143 \208\189\208\181 \209\131\208\177\208\184\209\130\209\140", 
            [21] = "\208\190\208\191\208\190\208\183\208\190\209\128\208\184\208\187\209\129\209\143", 
            [22] = "\209\128\208\176\208\183\209\138\208\181\208\177\208\190\208\189\209\135\208\184\208\186", 
            [23] = "\208\189\208\176 \208\183\208\180\208\190\209\128\208\190\208\178\209\140\208\181", 
            [24] = "\208\180\208\190\208\189 \208\187\208\184\208\188\208\190\208\189", 
            [25] = "\208\180\208\190\208\189 \208\178\208\176\209\130\208\181\209\128\208\188\208\181\208\187\208\190\208\189", 
            [26] = "stay acid"
        }, 
        mid = {
            [1] = "\209\135\208\188\208\190", 
            [2] = "name", 
            [3] = "\208\177\208\184\209\135", 
            [4] = "name", 
            [5] = "\208\180\208\190\208\187\208\177\208\176\209\145\208\177", 
            [6] = "\209\131\208\187\208\181\209\130\208\181\208\187 \208\189\208\176 \208\179\208\190\209\128\209\136\208\186\208\181", 
            [7] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129", 
            [8] = "\209\129\208\187\208\184\209\130\209\139\208\185", 
            [9] = "\208\191\209\128\208\190\208\187\209\131\208\183\208\176\208\178\209\136\208\184\208\185", 
            [10] = "\209\130\209\131\208\191\208\190\209\128\209\139\208\187\209\139\208\185", 
            [11] = "\209\135\208\188\208\190", 
            [12] = "\209\131\208\189\208\184\208\182\208\181\208\189\208\189\209\139\208\185 \208\184\208\189\208\178\208\176\208\187\208\184\208\180", 
            [13] = "superior slow walk unhsble", 
            [14] = "\209\136\208\187\209\142\209\133\208\176"
        }, 
        close = {
            [1] = "\208\189\208\176\209\133", 
            [2] = "\208\191\208\190\208\191\209\131\209\137\208\181\208\189\209\139\208\185", 
            [3] = "\208\181\208\177\208\187\208\176\208\189 \208\176\209\133\208\176\209\133", 
            [4] = "\208\177\208\187\209\143 \208\177\208\190\208\182\208\181", 
            [5] = "\209\135\209\145 \209\130\209\139 \208\180\208\181\208\187\208\176\208\181\209\136\209\140", 
            [6] = "ahah", 
            [7] = "\208\190\208\188\208\188\208\179", 
            [8] = "...", 
            [9] = "\209\131\209\135\208\184\209\129\209\140 \208\184\208\179\209\128\208\176\209\130\209\140", 
            [10] = "\209\133\208\190\209\135\208\181\209\136\209\140 \208\177\208\187\209\143 \208\188\208\177 \208\191\208\190\209\131\209\135\208\184\209\140\209\129\209\143 \208\184\208\179\209\128\208\176\209\130\209\140 \209\131 \208\188\208\181\208\189\209\143???", 
            [11] = "\208\188\209\141\208\187\209\129\209\130\209\128\208\190\208\185 \208\177\209\139 \208\189\208\181 \208\190\208\180\208\190\208\177\209\128\208\184\208\187", 
            [12] = "\209\129\208\187\208\184\209\136\208\186\208\190\208\188 \208\191\209\128\208\190\209\129\209\130\208\190 \208\180\208\187\209\143 \208\188\208\181\208\189\209\143 (\226\151\149\226\128\191\226\151\149)", 
            [13] = "\208\165\208\144\208\165\208\144\208\165\208\144\208\165\208\144 (\226\140\163\204\128_\226\140\163\204\129) \208\151\208\144\208\159\208\149\208\157", 
            [14] = "\209\143 \209\131\208\182\208\181 \208\188\208\176\209\130\209\145\209\128\209\139\208\185 \208\178 \209\141\209\130\208\190\208\188 \208\180\208\181\208\187\208\181", 
            [15] = "\208\189\208\184\208\186\209\129\208\178\208\176\209\128>all"
        }, 
        v2 = {
            [1] = "0 \208\190\209\136\208\184\208\177\208\190\208\186", 
            [2] = "stay acid \209\136\208\187\209\142\209\133\208\176 \226\128\162_\226\128\162)", 
            [3] = "\208\178\209\129\208\190\209\135\208\189\209\143\209\128\208\184\208\187 \208\179\208\176\208\178\208\189\208\190\208\181\208\180\208\176", 
            [4] = "\208\187\208\190\208\187, \208\184\208\180\208\184 \209\129\208\186\208\184\208\187\208\187\209\131\209\133\209\131 \209\130\209\128\208\181\208\189\208\189\208\184\209\128\209\131\208\185, \208\189\209\131\208\177\208\176\209\129", 
            [5] = "\209\131\208\189\208\184\208\182\208\181\208\189\208\189\209\139\208\185 \208\184\208\189\208\178\208\176\208\187\208\184\208\180 \209\130\209\139 \208\188\208\189\208\181 \208\178 \209\136\208\184\209\128\208\184\208\189\208\186\209\131 \208\180\209\139\209\136\208\184\209\136\209\140", 
            [6] = "\208\189\208\176\208\185\209\129 \208\176\208\186\208\186\208\176\209\131\208\189\209\130 [\204\178\204\133$\204\178\204\133(\204\178\204\1331\204\133)\204\178\204\133$\204\178\204\133]", 
            [7] = "\208\189\209\142\209\133\208\176\208\185 \208\191\209\141\208\189\209\129\208\181\208\187,\208\177\208\176\208\186\208\187\208\176\208\189", 
            [8] = "acidtech gang", 
            [9] = "\208\186\208\190\208\187\208\184\208\186\208\184 \208\177\208\190\208\187\208\184\208\186\208\184", 
            [10] = "AcidTech.LUA \208\157\208\144 \208\161\208\149\208\160\208\146\208\149\208\160\208\149, \208\146\208\161\208\149\208\156 \208\158\208\162\208\158\208\153\208\162\208\152 \208\157\208\144 \208\145\208\149\208\151\208\158\208\159\208\144\208\161\208\157\208\158\208\149 \208\160\208\144\208\161\208\161\208\162\208\158\208\175\208\157\208\152\208\149", 
            [11] = "~\226\157\164\208\162\208\178\208\190\208\185|\208\160\208\176\209\129\209\130\208\176\209\132\208\176\209\128\208\176\208\185\226\157\164~", 
            [12] = "\208\178\208\190 \209\129\208\188\208\181\209\133, \208\176\208\182 \208\191\208\190\208\191\208\190\208\185 \209\133\209\128\209\142\208\186\208\189\209\131\208\187 \208\188\208\176\208\187\209\145\209\133\208\176", 
            [13] = "\208\163 \208\159\208\144\208\160\208\157\208\175 \208\144\208\144 \208\158\208\162 \208\161\208\154\208\152\208\162\208\144 \208\158\208\162\208\154\208\144\208\151\208\144\208\155\208\152 \208\154\208\144\208\154 \208\154\208\155\208\144\208\157\208\162\208\149\208\147 AcidTech \208\163\208\146\208\152\208\148\208\149\208\155\208\152 \208\165\208\144\208\165\208\144\208\165\208\144\208\165\208\144\208\165\208\144", 
            [14] = "\208\178\208\191\208\184\209\130\209\139\208\178\208\176\208\185 \208\184 \209\130\208\181\209\128\208\191\208\184", 
            [15] = "\208\178\208\184\208\180\208\189\208\190 \209\130\209\139 \208\177\208\181\208\183 AcidTech.lua, \208\191\208\190\209\128\208\176 \208\191\209\128\208\184\208\186\209\131\208\191\208\184\209\130\209\140 \209\129\209\139\208\189\208\190\209\135\208\181\208\186", 
            [16] = "\208\163\208\146\208\158\208\155\208\149\208\157 by AcidTech.lua", 
            [17] = "\208\189\208\187 \209\129\208\181\208\179\208\190\208\180\208\189\209\143 \208\191\208\190\208\180\208\186\208\190\208\178\208\176\208\189", 
            [18] = "fipp#3882 \208\189\208\176\208\191\208\184\209\136\208\184 \208\181\209\129\208\187\208\184 \209\132\209\128\208\184 \208\186\209\132\208\179 \208\189\208\176 \208\189\208\187\208\186\209\131 \208\178\209\139\208\180\208\176\209\130\209\140", 
            [19] = "\208\180\208\182\209\131\208\188\208\176\208\189\208\180\208\182\208\176)", 
            [20] = "\208\191\208\176\209\134\208\176\208\189 \208\191\208\190\208\191\209\131\209\130\208\176\208\187 \208\177\208\181\209\128\208\181\208\179\208\176 \208\184 \208\177\209\139\208\187 \208\191\209\128\208\190\208\191\208\181\208\189\208\181\208\189", 
            [21] = "\208\183\208\176\208\183\208\181\208\178\208\176\208\187\209\129\209\143 \208\184 \208\191\208\190\208\189\209\142\209\133\208\176\208\187 \208\177\208\181\208\177\209\128\208\190\209\135\208\186\208\184 ( \205\161\202\152 \205\156\202\150 \205\161\202\152)", 
            [22] = "\209\131\209\130\209\128\208\190 \208\189\208\176\209\135\208\184\208\189\208\176\208\181\209\130\209\129\209\143 \209\129 \208\191\209\131\208\187\208\184 \208\190\209\130 \208\176\209\129\208\184\208\180\209\130\208\181\209\135.\208\187\209\131\208\176", 
            [23] = "\208\189\208\181 \209\129\208\189\208\184\208\188\208\176\208\185 \208\191\208\190\208\180\208\179\209\131\208\183\208\189\208\184\208\186, \208\191\209\128\208\190\209\129\209\130\208\190 \208\190\209\130\208\190\208\180\208\178\208\184\208\189\209\140 \208\181\208\179\208\190 \208\178 \209\129\209\130\208\190\209\128\208\190\208\189\209\131", 
            [24] = "\208\191\209\128\208\190\208\188\208\190\208\187\209\135\208\184\209\136\209\140?", 
            [25] = "\208\189\208\181\208\182\208\181\208\187\208\176\209\130\208\181\208\187\209\140\208\189\209\139\208\185 \208\190\208\186\209\131\209\128\208\190\208\186 \208\177\209\139\208\187 \208\189\208\176\208\186\208\176\208\183\208\176\208\189", 
            [26] = "hs", 
            [27] = "\226\153\155\208\176\208\187\209\140\209\132\208\176\209\135 \208\189\208\176 \209\129\208\181\209\128\208\178\208\181\209\128\208\181\226\153\155", 
            [28] = "\208\165\208\144\208\165\208\144\208\165\208\144\208\165\208\144 (\239\188\155\226\140\163\204\128_\226\140\163\204\129) \208\151\208\144\208\159\208\149\208\157", 
            [29] = "\208\178\209\129\208\181 \208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\189\208\184\209\143 \208\178 \208\191\209\141\208\189\209\129\208\181\208\187", 
            [30] = "1.", 
            [31] = "\209\135\208\181\208\187 \209\129 \208\186\209\132\208\179 \208\190\209\130 \209\128\208\181\208\183\208\190\208\187\209\140\208\178\208\181\209\128\208\176, \208\186\208\190\208\183\209\143\208\178\209\131 \208\179\208\187\208\190\209\130\208\176\208\181\209\136\209\140?", 
            [32] = "\208\189\208\181\208\188\208\189\208\190\208\179\208\190 \208\189\208\176\208\191\209\128\209\131\208\180\208\190\208\189\208\184\208\187", 
            [33] = "\209\135\209\130\208\190 \208\183\208\176 \208\186\209\128\208\176\209\129\208\190\209\130\208\176, \209\129\209\128\208\181\208\180\208\184 \209\141\209\130\208\190 \208\188\208\176\209\129\209\129\208\190\208\178\208\186\208\184", 
            [34] = "\208\190\208\179\209\131\208\183\208\190\208\186 \208\189\208\176\208\180\209\128\208\184\209\129\209\130\208\176\208\187 \209\129\208\190 \209\129\208\178\208\190\208\181\208\185 \208\191\208\187\208\181\209\136\208\184", 
            [35] = "\208\191\209\128\208\184\208\187\208\190\209\129\208\186\208\176\208\187 \208\186\208\190\209\129\208\188\208\176\209\130\208\190\208\179\208\190 ~(\203\152\226\150\190\203\152~)", 
            [36] = "\209\129\208\187\208\176\208\178\208\176 \208\177\208\190\208\179\209\131 \209\143 \209\142\208\183\208\176\209\142 AcidTech", 
            [37] = "\208\190\208\177\208\190\209\129\209\129\208\176\208\187 \208\189\208\181 \208\178\208\183\208\184\209\128\208\176\209\143 \208\189\208\181 \208\191\208\190\209\129\208\187\208\181\208\180\209\129\209\130\208\178\208\184\209\143", 
            [38] = "\208\191\208\190\209\135\209\131\209\133\208\176\208\187 \208\191\208\190\208\191\209\131 \208\191\208\176\208\187\209\140\209\135\208\184\208\186\208\190\208\188", 
            [39] = "\208\189\209\131 \209\130\209\139 \208\183\208\178\208\181\209\128\209\140", 
            [40] = "\208\178\208\186\209\131\209\129\208\189\208\190?", 
            [41] = "\208\191\208\190\208\189\209\142\209\133\208\176\208\185 \208\191\208\190\208\191\209\131 \208\189\208\190\209\129\208\184\208\186\208\190\208\188, \208\191\209\128\208\184\208\186\208\184\208\189\209\140\209\129\209\143 \208\186\208\184\209\129\208\176 \208\191\209\145\209\129\208\184\208\186\208\190\208\188", 
            [42] = "\208\186\209\131\208\180\208\176 \209\129\208\191\209\128\209\143\209\130\208\176\208\187\209\129\209\143, \208\188\208\176\208\188\208\176 \208\189\208\176\209\131\209\135\208\184\208\187\208\176 \208\184\208\183 \209\136\208\186\208\176\209\132\208\176 \208\191\208\190\208\180\208\179\208\187\209\143\208\180\209\139\208\178\208\176\209\130\209\140?", 
            [43] = "\208\188\208\181\208\189\209\143 \208\189\208\181 \209\131\208\177\208\184\209\130\209\140 - superior slow walk unhsble", 
            [44] = "\208\191\208\176\209\128\208\189\208\184, \209\143 \208\184 \208\191\209\145\209\128\208\189\209\131\209\130\209\140 \208\189\208\181 \209\131\209\129\208\191\208\181\208\178\208\176\209\142, \208\178\209\139 \209\131\208\182\208\181 \208\189\209\142\209\133\208\176\208\181\209\130\208\181", 
            [45] = "\209\135\208\184\209\130 \208\190\208\186\208\187\208\181\208\188\208\176\208\187\209\129\209\143 \208\188\208\190\208\182\208\189\208\190 \208\184 \208\191\208\190\208\191\208\181\208\189\208\184\209\130\209\140", 
            [46] = "\208\191\208\176\209\128\208\181\208\189\209\140, \209\143 \208\178\208\184\208\182\209\131 \209\130\209\139 \208\177\208\181\208\180\208\190\208\187\208\176\208\179\208\176, \208\183\208\176\208\185\208\180\208\184 \208\189\208\176 \209\132\208\190\209\128\209\131\208\188 \209\130\208\176\208\188 \209\137\208\176 AcidTech \208\189\208\190\208\188\208\181\209\128 1", 
            [47] = "\208\177\208\190\209\130\208\184\208\186, \209\130\209\139 \208\191\209\128\208\190 AcidTech.lua \209\129\208\187\209\139\209\133\208\176\208\187 \209\135\208\181\209\130\208\190?", 
            [48] = "\208\190\208\191\208\176, \209\135\208\184\209\130 \208\191\209\128\208\190\208\179\209\128\208\181\208\187", 
            [49] = "\208\191\209\128\208\190\209\131\209\135\208\181\208\189.", 
            [50] = "\208\189\208\176 \208\178\208\184\209\128\208\176\208\182\208\184\208\186\208\181 \209\136\208\187\208\181\208\191\208\190\208\186 \208\180\208\176\208\187 \208\189\208\181\208\177\208\190\208\187\209\140\209\136\208\190\208\185", 
            [51] = "Malik163#6401 \208\180\208\190\208\177\208\176\208\178\209\140 \208\178 \208\180\209\128, \208\184\209\137\209\131 \208\180\209\128\209\131\208\183\208\181\208\185", 
            [52] = "AcidTech \208\191\208\190\208\186\208\176\208\183\209\139\208\178\208\176\208\181\209\130 \208\189\208\176\208\179\208\187\208\181\208\182\208\176 (\226\151\163_\226\151\162)", 
            [53] = "\208\190\208\191\209\143\209\130\209\140 \208\190\208\180\208\184\208\189 \208\183\208\176 \209\130\208\184\208\188\208\188\208\181\208\185\209\130\208\190\208\178 \208\178\209\129\209\142 \209\128\208\176\208\177\208\190\209\130\209\131 \209\129\208\180\208\181\208\187\208\176\208\187", 
            [54] = "\209\131 \208\186\208\190\208\179\208\190 \209\129\208\186\208\184\209\130 \208\191\209\128\208\181\208\180\208\187\208\190\208\179\208\176\209\142 \208\183\208\176\209\129\208\189\209\131\209\130\209\140 \208\178 \208\191\208\190\208\191\209\131 \208\191\209\128\208\190\208\177\208\186\209\131 - \208\190\209\137\209\131\209\137\208\181\208\189\208\184\209\143 \209\130\208\181 \208\182\208\181, \208\180\208\176\208\182\208\181 \208\191\209\128\208\184\209\143\209\130\208\189\208\181\208\181", 
            [55] = "\209\130\209\139 \208\189\208\181 \209\131\208\188\209\145\209\133\208\176, \208\179\208\176\208\185\208\180\209\139 \208\190\209\130 KuCJloTa HvH \208\191\208\190\209\129\208\188\208\190\209\130\209\128\208\184", 
            [56] = "\209\143 \209\131\208\182\208\181 \208\188\208\176\209\130\209\145\209\128\209\139\208\185 \208\178 \209\141\209\130\208\190\208\188 \208\180\208\181\208\187\208\181", 
            [57] = "\209\130\209\131\209\129\208\189\209\143 \208\191\208\190\209\136\208\187\208\176 (\226\140\146\226\128\191\226\140\146)", 
            [58] = "\208\190\208\191\208\190\208\183\208\190\209\128\208\184\208\187 \209\135\209\131\209\133\208\176\208\189\209\135\208\184\208\186\208\176", 
            [59] = "\209\143 \208\191\208\190\208\180\208\186\208\190\208\178\208\176\208\189 \208\178 \209\141\209\130\208\190\208\188", 
            [60] = "\208\188\208\190\209\135\208\186\208\176\208\189\209\131\208\187 \208\189\208\176\208\184\208\178\208\189\208\190\208\179\208\190", 
            [61] = "\208\186\209\128\208\181\208\188 \208\184\208\183 \208\191\208\184\209\129\209\142\209\133\208\184 \227\131\131", 
            [62] = "\208\189\208\176 \208\186\209\131\209\128\208\176\208\182\208\184\208\186\208\181 \208\178 \208\179\208\176\208\178\208\189\209\145\209\133\209\131 \208\189\208\176\209\129\209\130\209\131\208\191\208\184\208\187", 
            [63] = "\208\159\209\128\208\184\208\189\209\134\208\181\209\129\209\129\208\176 \208\190\208\179\208\190\209\128\208\190\209\136\208\181\208\189\208\176 (o_O)", 
            [64] = "\208\187\209\142\208\180\208\184 \209\129\208\177\208\181\208\182\208\176\208\187\208\184 \208\178 \209\129\209\130\209\128\208\176\209\133\208\181... \209\129\208\181\209\128\208\178\208\181\209\128 \208\191\209\128\208\190\208\186\208\176\209\135\208\181\208\189...", 
            [65] = "\208\188\208\190\209\135\208\176\208\187\208\186\208\176 \208\183\208\176\209\133\208\190\209\130\208\181\208\187\208\176 \209\128\208\176\208\183\208\180\209\128\208\176\209\143 \208\184 \208\177\209\139\208\187\208\176 \208\183\208\176\208\191\208\181\208\189\208\184\208\189\208\176", 
            [66] = "\208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \208\179\208\187\208\176\208\180\208\184\208\190\208\187\209\131\209\129 \194\175\\_(\227\131\132)_/\194\175", 
            [67] = "\208\177\208\181\208\180\208\190\208\187\208\176\208\182\208\189\209\139\208\185, \208\191\208\190\208\189\209\142\209\133\208\176\208\185 \208\188\208\190\208\185 acidtech:3", 
            [68] = "\208\189\208\176\209\130\209\139\208\186\208\176\208\187\209\129\209\143 \209\143 \208\179\208\180\208\181\209\130\208\190 \208\189\208\176 \209\130\208\181\208\177\209\143, \209\130\209\139 c \208\186\208\187\208\176\208\189\209\130\208\181\208\179\208\190\208\188 chimera \208\190\209\130\209\129\208\176\209\129\209\139\208\178\208\176\208\187?", 
            [69] = "\208\183\208\176\208\191\208\181\208\189\209\143\208\178\208\190\209\135\208\186\208\176 \208\189\208\176 \209\129\208\181\209\128\208\178\208\181\209\128\208\181", 
            [70] = "\209\128\208\176\208\183\209\138\208\181\208\177\208\190\208\189\209\135\208\184\208\186", 
            [71] = "senpai~~~, \208\183\208\176\208\190\208\178\208\189\208\184 \208\188\208\181\208\189\209\143 ^^", 
            [72] = "\208\189\208\176 \208\186\209\131\209\128\208\176\208\182\208\184\208\186\208\181", 
            [73] = "\208\191\208\181\208\189\208\176 \209\130\208\176\208\186 \208\184 \209\133\208\187\208\181\209\137\208\181\209\130", 
            [74] = "\208\186\208\190\208\191\208\190\209\130\209\140 \209\130\208\176\208\186 \208\184 \208\180\209\139\208\188\209\131\209\128\208\184\209\130\209\129\209\143", 
            [75] = "\208\186\208\176\208\186 \208\190\209\130\208\189\208\190\209\129\208\184\209\136\209\140\209\129\209\143 \208\186 \208\176\208\189\208\176\208\189\208\176\209\129\209\131 \208\189\208\176 \208\191\208\184\209\134\209\134\208\181?", 
            [76] = "\209\129\208\178\208\184\208\189\209\143\209\135\208\184\208\185 \208\189\208\176\208\191\208\181\208\189", 
            [77] = "\208\189\208\176 \208\183\208\180\208\190\209\128\208\190\208\178\209\140\208\181", 
            [78] = "\208\191\208\190\208\180\209\130\209\128\208\184\209\133\208\176\208\188\208\190\208\189\208\190\208\183\208\184\208\187", 
            [79] = "\208\190\209\130\208\186\208\176\208\189\208\184\209\132\208\190\208\187\208\184\208\187", 
            [80] = "\208\180\208\190\208\189 \208\187\208\184\208\188\208\190\208\189", 
            [81] = "\208\183\208\176\208\186\209\128\209\139\209\130 \208\191\208\190\209\130\208\189\209\143\208\178\208\186\208\176", 
            [82] = "\209\133\208\176\208\191\208\189\209\131\208\187 \208\183\208\176\208\177\208\190\209\128\208\184\209\129\209\130\208\190\208\179\208\190", 
            [83] = "\208\189\208\176\208\186\208\176\208\183\208\176\208\189\208\176 \\(^O^)/", 
            [84] = "\208\156\208\163\208\150\208\152\208\154\208\152 \208\175 \208\154\208\144\208\145\208\144\208\157 \208\157\208\149 \208\168\208\156\208\144\208\155\208\175\208\153\208\162\208\149 \208\165\208\160\208\152\208\161\208\162\208\144 \208\160\208\144\208\148\208\152 \208\157\208\149 \208\147\208\163\208\145\208\152\208\162\208\149", 
            [85] = "\209\135\208\176\209\135\208\186\208\176 \208\191\208\184\208\191\209\129\208\190\208\178)))", 
            [86] = "by \208\176\209\129\208\184\208\180\209\130\208\181\209\135 \208\189\209\131\208\177\208\176\209\129", 
            [87] = "AcidTech records", 
            [88] = "\209\130\209\139 \209\135\209\130\208\190\209\130\208\190 \208\191\209\145\209\128\208\189\209\131\208\187? \208\158\208\162\208\154\208\144\208\151\208\144\208\157\208\158", 
            [89] = "\209\136\208\176\208\187\209\140\208\189\208\176\209\143 \208\183\208\176\208\187\208\181\209\130\208\181\208\187\208\176", 
            [90] = "\208\189\208\184\209\133\209\131\209\143 \209\130\209\139 \208\180\208\182\208\181\208\189\209\130\208\181\208\187\209\140\208\188\208\181\208\189, \208\176\208\182 \209\136\208\187\209\143\208\191\208\176 \209\129\208\187\208\181\209\130\208\181\208\187\208\176", 
            [91] = "\209\129\208\184\208\187\209\140\208\189\208\190 \208\178\209\129\209\130\208\176\208\187", 
            [92] = "\209\128\208\190\208\178\208\189\208\190 \208\180\208\178\208\184\208\179\208\176\209\142\209\129\209\140", 
            [93] = "\208\191\209\128\208\190\208\186\208\176\209\135\208\176\208\187\209\129\209\143 \209\129\209\145\208\180\208\189\209\143, \208\191\208\181\208\189\208\184\209\130\209\140 \208\177\209\131\208\180\209\131", 
            [94] = "\208\178\208\176\208\186 \208\178 \209\135\208\176\209\130 \208\178\209\129\208\181 \208\180\208\181\208\187\208\176", 
            [95] = "8 6 4 2 \209\128\209\131\209\135\208\186\208\176 \209\130\209\128\208\176\209\133\208\189\209\131\208\187\208\176 \208\177\208\190\208\177\209\128\208\176", 
            [96] = "\208\191\208\190\209\129\208\187\208\181 \209\130\208\176\208\186\208\190\208\185 \208\191\209\131\208\187\208\184, \209\131 \209\130\208\181\208\177\209\143 \208\191\208\190\209\128\208\178\208\176\208\187\208\184\209\129\209\140 \209\130\209\128\209\131\209\129\208\184\208\186\208\184", 
            [97] = "\208\156\208\171 \208\160\208\163\208\161\208\161\208\154\208\152\208\149 - \208\161 \208\157\208\144\208\156\208\152 \208\145\208\158\208\147", 
            [98] = "\208\167\209\130\208\190 \208\191\209\128\208\181\208\178\209\128\208\176\209\137\208\176\208\181\209\130 \208\180\208\181\208\178\209\131\209\136\208\186\209\131 \208\178 \208\182\208\181\208\189\209\137\208\184\208\189\209\131? \208\161\208\181\208\186\209\129 \209\129 \208\178\208\184\209\130\208\188\208\190\208\185", 
            [99] = "( \205\161\194\176 \205\156\202\150 \205\161\194\176)", 
            [100] = "\208\183\208\176\208\180\208\190\209\128\208\189\208\176\209\143 \209\132\208\181\208\189\209\143", 
            [101] = "( \205\161\194\176 \205\156\202\150 \205\161\194\176)\226\177\173 \204\182\205\158 \204\182\205\158 \204\182\205\158 \204\182\205\158 \239\187\157\239\174\158", 
            [102] = " \208\149\208\161\208\161\208\161 -3 \208\174\208\165\208\163\208\163\208\163\208\163\208\163", 
            [103] = "\209\128\208\176\208\183, \208\180\208\178\208\176, \209\130\209\128\208\184 - \208\191\208\190\208\191\209\131 \208\191\208\190\208\180\208\190\209\130\209\128\208\184", 
            [104] = "\208\176\208\189\208\176\208\189\209\129\208\190\208\178\209\139\208\185 \209\129\208\184\209\128\208\190\208\191, \208\190\208\191 \208\190\208\191 \208\190\208\191 \208\190\208\191", 
            [105] = "\208\159\209\131\209\129\209\130\209\140 \208\178\208\176\209\136\208\184 \208\191\208\181\209\135\208\176\208\187\209\140\208\186\208\184 \208\191\209\128\208\181\208\178\209\128\208\176\209\130\209\143\209\130\209\129\209\143 \208\178 \208\181\209\128\209\131\208\189\208\180\209\131\208\187\209\140\208\186\208\184", 
            [106] = "\209\129\208\184\209\129\209\143 \\(^.^)/", 
            [107] = "\208\191\208\190\209\130\209\143\209\128\208\176, \208\177\208\181\208\183 \208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\189\208\184\208\185 \209\130\208\190\208\187\209\140\208\186\208\190", 
            [108] = "\208\184\208\188\208\177\208\190\208\178\208\190 \208\186\209\128\208\184\208\189\208\182\208\176\208\189\209\131\208\187", 
            [109] = "\208\189\208\181\208\187\208\181\208\191\208\176\209\143 \209\129\209\131\208\181\209\130\208\176", 
            [110] = "\209\129\208\188\208\176\209\135\208\189\208\190 \208\180\209\131\208\189\209\131\208\187 \208\178 \208\191\209\141\208\189\209\129\208\181\208\187", 
            [111] = "\209\145\208\180\209\128\209\145\208\189 \208\186\208\176\209\128\209\130\208\190\208\189", 
            [112] = "\208\176 \208\178 \208\191\208\190\208\191\209\131 \208\177\208\190\208\187\209\140\208\189\208\190?", 
            [113] = "\208\181\208\180\209\128\209\145\208\189 \208\177\208\176\209\130\208\190\208\189, KAK JE YA JEBOSHY", 
            [114] = "\209\143 \208\190\208\177\208\187\208\176\208\180\208\176\209\130\208\181\208\187\209\140 - AcidTech.lua, \208\190\209\132\208\190\209\128\208\188\208\184 3a\208\179Jlo\209\130 \209\132\208\176\209\129\209\130\208\190\208\188", 
            [115] = "\208\189\208\176\209\133\208\176\208\187\209\140\208\189\208\190 \208\190\209\130\208\187\208\184\208\188\208\190\208\189\208\184\208\187", 
            [116] = "\209\134\208\181\208\187\209\131\208\185\209\130\208\181 \208\188\208\190\208\184 \208\177\209\131\208\187\208\186\208\184, \209\143 \208\191\208\176\208\159\208\163\208\155\208\172\208\154\208\144", 
            [117] = "\208\180\209\128\208\176\208\186\208\176\208\186\209\131\208\187\208\176(", 
            [118] = "\208\180\209\128\208\176\209\135\208\184\208\186\209\131\208\187\208\176)", 
            [119] = "\208\189\208\176\208\186\208\184\208\180\208\176\208\187 \208\183\208\176 \209\136\208\184\208\178\208\190\209\128\208\190\209\130", 
            [120] = "\208\175 \208\146\208\161\208\129\208\155\208\171\208\153 \208\162\208\144\208\160\208\144\208\154\208\144\208\157, \208\175 \208\145\208\149\208\147\208\163 \208\145\208\149\208\147\208\163 \208\145\208\149\208\147\208\163", 
            [121] = "\209\135\209\131\209\133\208\189\209\131\208\187 \208\191\208\181\208\189\208\184\209\129\208\190\208\188 \208\189\208\176\209\133\208\176\208\187\208\176", 
            [122] = "\226\153\154 \209\135\208\184\208\186 \208\191\209\131\208\186 \209\130\209\128\208\176\208\187\209\143\208\187\209\143 \226\153\154", 
            [123] = "\226\153\155\239\188\161\239\189\140\239\189\140 \239\188\166\239\189\129\239\189\141\239\189\137\239\189\140\239\189\153 AcidTech\226\153\155", 
            [124] = "\208\178 \209\130\209\131\208\183\208\176 \208\189\208\176\208\191\208\184\209\133\208\176\208\187", 
            [125] = "\208\191\209\128\208\184\209\129\209\131\208\189\209\131\208\187 \208\178 \209\131\209\136\208\186\208\190, \209\130\209\139 \208\188\208\190\209\143 \208\191\208\190\208\180\209\128\209\131\208\182\208\186\208\176)", 
            [126] = "\208\187\208\190\209\136\208\176\209\128\208\176) \209\143 \209\129 \208\189\208\187\208\190\208\188"
        }
    };
    local v1618 = {
        m = "\208\188", 
        j = "\208\182", 
        z = "\208\183", 
        e = "\208\181", 
        s = "\209\129", 
        y = "\209\139", 
        w = "\208\178", 
        o = "\208\190", 
        h = "\209\133", 
        r = "\209\128", 
        x = "\208\186\209\129", 
        c = "\209\134", 
        b = "\208\177", 
        n = "\208\189", 
        p = "\208\191", 
        u = "\209\131", 
        a = "\209\141", 
        q = "\208\186", 
        d = "\208\180", 
        f = "\209\132", 
        g = "\208\179", 
        l = "\208\187", 
        v = "\208\178", 
        k = "\208\186", 
        i = "\208\184", 
        t = "\209\130"
    };
    local function v1625(v1619)
        -- upvalues: v1618 (ref)
        local _ = "";
        local v1621 = v1619:lower();
        local _ = string.len(v1621);
        local v1623 = "";
        for v1624 = 1, #v1621 do
            v1623 = v1623 .. (v1618[v1621:sub(v1624, v1624)] or " ");
        end;
        return v1623;
    end;
    local function v1629()
        -- upvalues: l_random_int_0 (ref)
        local v1626 = "";
        local v1627 = "\209\133";
        for _ = 1, l_random_int_0(4, 10) do
            if v1627 == "\209\133" then
                if l_random_int_0(0, 3) ~= 0 then
                    v1626 = v1626 .. "\208\176";
                else
                    v1626 = v1626 .. "\209\133";
                end;
                v1627 = "\208\176";
            else
                if l_random_int_0(0, 3) ~= 0 then
                    v1626 = v1626 .. "\209\133";
                else
                    v1626 = v1626 .. "\208\176";
                end;
                v1627 = "\209\133";
            end;
            if l_random_int_0(0, 5) == 0 then
                v1626 = v1626 .. "\209\138";
            end;
        end;
        if l_random_int_0(0, 5) == 0 then
            v1626 = v1626.upper(v1626);
        end;
        return v1626;
    end;
    local v1630 = {
        start = {
            [1] = "\208\191\208\190\209\129\208\188\208\190\209\130\209\128\208\184\209\130\208\181", 
            [2] = "ahah", 
            [3] = "\208\178\208\176\209\137\208\181", 
            [4] = "\208\182\208\176\209\131\208\189", 
            [5] = "\208\189\208\181 \208\183\208\176\208\177\208\181\208\185", 
            [6] = "st1vaha#9099 \208\189\208\176\208\191\208\184\209\136\208\184 \208\181\209\129\208\187\208\184 \209\132\209\128\208\184 \208\186\209\132\208\179 \208\189\208\176 \208\189\208\187\208\186\209\131 \208\178\209\139\208\180\208\176\209\130\209\140", 
            [7] = "vitmoid#2845 \208\180\208\190\208\177\208\176\208\178\209\140 \208\178 \208\180\209\128, \208\184\209\137\209\131 \208\180\209\128\209\131\208\183\208\181\208\185", 
            [8] = "\208\191\208\181\208\189\208\176 \209\130\208\176\208\186 \208\184 \209\133\208\187\208\181\209\137\208\181\209\130", 
            [9] = "\208\156\208\163\208\150\208\152\208\154\208\152 \208\175 \208\154\208\144\208\145\208\144\208\157 \208\157\208\149 \208\168\208\156\208\144\208\155\208\175\208\153\208\162\208\149 \208\165\208\160\208\152\208\161\208\162\208\144 \208\160\208\144\208\148\208\152 \208\157\208\149 \208\147\208\163\208\145\208\152\208\162\208\149"
        }, 
        mid = {
            [1] = "\209\135\209\130\208\190 \209\141\209\130\208\190\209\130", 
            [2] = "\208\189\209\131 \209\141\209\130\208\190\209\130", 
            [3] = "\209\129\209\129\208\176\208\189\209\139\208\185", 
            [4] = "\208\187\208\190\208\187", 
            [5] = "ahah"
        }, 
        close = {
            [1] = "\208\191\209\139\209\130\208\176\208\181\209\130\209\129\209\143 \209\129\208\180\208\181\208\187\208\176\209\130\209\140", 
            [2] = "\209\129\209\130\208\176\209\128\208\176\208\181\209\130\209\140\209\129\209\143", 
            [3] = "\208\191\209\139\209\133\209\130\208\184\209\130", 
            [4] = "\208\188\209\131\208\178\208\176\208\181\209\134\208\176 \209\129\208\188\208\181\209\136\208\189\208\190", 
            [5] = "\208\188\209\131\208\178 \208\184\209\129\208\191\208\190\208\187\208\189\208\184\208\187"
        }, 
        close_optional = {
            [1] = "\208\177\208\187\209\143", 
            [2] = "ahah", 
            [3] = "1x1 \208\179\208\190", 
            [4] = "\208\181\208\177\208\187\208\176\208\189", 
            [5] = "\208\180\208\190\208\187\208\177\208\176\209\145\208\177"
        }
    };
    local v1631 = {};
    local function v1638(v1632)
        -- upvalues: v1630 (ref), l_random_int_0 (ref), v1629 (ref), v1625 (ref), v1631 (ref)
        local v1633 = v1630.start[l_random_int_0(1, #v1630.start)];
        local v1634 = v1630.mid[l_random_int_0(1, #v1630.mid)];
        local v1635 = v1630.close[l_random_int_0(1, #v1630.close)];
        local v1636 = v1630.close_optional[l_random_int_0(1, #v1630.close_optional)];
        local v1637 = ("%s %s %s %s %s"):format(v1633 == "ahah" and v1629() or v1633, v1634 == "ahah" and v1629() or v1634, v1625(v1632), v1635 == "ahah" and v1629() or v1635, l_random_int_0(0, 2) == 0 and (v1636 == "ahah" and v1629() or v1636) or "");
        v1631.troll = {
            [1] = globals.realtime + v1637:len() * utils.random_float(0.1, 0.3), 
            [2] = v1637
        };
    end;
    local function v1645(v1639)
        -- upvalues: l_random_int_0 (ref), v1617 (ref), v1631 (ref), v1629 (ref), v1625 (ref), v1638 (ref)
        if l_random_int_0(0, 2) >= 1 then
            local v1640 = v1617.v2[globals.tickcount % #v1617.v2 + 1];
            v1631.kill = {
                [1] = globals.realtime + v1640:len() * 0.075, 
                [2] = v1640
            };
            return;
        else
            local v1641 = v1617.start[l_random_int_0(1, #v1617.start)];
            local v1642 = v1617.mid[l_random_int_0(1, #v1617.mid)];
            local v1643 = v1617.close[l_random_int_0(1, #v1617.close)];
            local v1644 = ("%s %s %s"):format(v1641 == "ahah" and v1629() or v1641, v1642 == "name" and v1625(v1639:get_name()) or v1642, v1643 == "ahah" and v1629() or v1643);
            v1631.kill = {
                [1] = globals.realtime + v1644:len() * 0.075, 
                [2] = v1644
            };
            if l_random_int_0(0, 9) == 0 then
                v1638(v1639:get_name());
            end;
            return;
        end;
    end;
    local v1646 = {
        start = {
            [1] = "\209\135\209\130\208\190 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187", 
            [2] = "?", 
            [3] = "\208\189\208\176\208\185\209\129 \208\188\209\131\208\178", 
            [4] = "\208\191\208\184\208\183\208\180 \209\130\209\139 \208\186\208\190\208\189\209\135", 
            [5] = "\208\189\208\176\208\185\209\129 \208\191\208\190\208\180\208\187\208\190\208\178\208\184\208\187", 
            [6] = "\208\177\208\181\208\183 \208\180\209\130 \208\189\208\181 \208\188\208\190\208\182\208\181\209\130", 
            [7] = "\208\191\209\128\208\190\209\129\209\130\208\190 +\208\178", 
            [8] = "\208\177\208\187\209\143", 
            [9] = "\208\189\208\176 \208\191\208\190\208\180\208\191\208\184\208\186\208\181", 
            [10] = "\208\181\208\187\208\181 \209\131\208\177\208\184\208\187", 
            [11] = "\208\191\208\190\209\135\209\130\208\184 \209\133\208\190\209\128\208\190\209\136\208\190", 
            [12] = "\209\130\208\178\208\176\209\128\209\142\208\179\208\176", 
            [13] = "\208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\185 \208\188\209\131\208\178", 
            [14] = "\208\189\209\131", 
            [15] = "gbpltw", 
            [16] = ",kznm", 
            [17] = "\209\130\209\131\208\191\208\190\208\185", 
            [18] = "\208\156\208\149\208\157\208\175 \208\162\208\159\208\165\208\157\208\163\208\155\208\158", 
            [19] = "\209\143 \209\129\209\130\209\128\208\181\208\187\209\140\208\189\209\131\208\187?", 
            [20] = "\208\179\208\176\208\178\208\189\208\190\208\181\208\180", 
            [21] = "\209\143\209\143 \208\178 \208\188\209\131\209\130\208\181?", 
            [22] = "\208\189\209\131 \209\130\208\184\208\188\208\188\208\181\208\185\209\130 \209\132\208\181\208\180\209\131\208\186\208\176 \208\180\208\176\208\178\208\184\209\130", 
            [23] = "\208\186\208\181\209\128\208\180\209\139\208\186", 
            [24] = "\209\135\209\130\208\190 \208\183\208\176 \208\178\208\190\208\189\209\140 \209\131\208\177\208\184\208\187\208\176", 
            [25] = "\209\130\209\139 \208\180\209\130 \208\190\209\130\208\182\208\176\208\187?", 
            [26] = "\209\131 \208\188\208\181\208\189\209\143 \208\190\208\180\208\189\208\190\208\178\208\190 \209\129\208\181\209\128\208\178 \208\187\208\176\208\179?", 
            [27] = "\208\189\208\176\208\185\209\129 \208\176\208\178\209\130\208\190\208\191\208\184\208\186+\208\188\208\184\208\189\208\180\208\188\208\179", 
            [28] = "\208\177\208\181\208\186\209\136\209\131\209\130?", 
            [29] = "\209\130\209\139 \209\129 \209\129\208\190\209\130\208\186\208\190\208\185 \208\178\209\129\209\130\208\176\208\187?", 
            [30] = "\208\189\209\131 \209\130\209\139 \208\183\208\178\208\181\209\128\209\140", 
            [31] = "\209\129\208\184\208\180\208\184\209\130 \208\191\209\128\208\181\208\180\208\184\208\186\209\130\208\184\209\130", 
            [32] = "\208\190\208\189\208\187\208\184 \208\177\208\190\208\180\208\184 \209\135\209\131\209\128\208\186\208\176", 
            [33] = "\208\188\209\128\208\176\208\183\208\190\209\130\208\176 \208\191\208\190\209\130\208\181\208\181\209\130", 
            [34] = "\208\189\208\181 \208\191\208\190\209\130\208\181\208\185", 
            [35] = "\209\130\209\139 \209\129 \208\188\208\184\208\189\208\180\208\176\208\188\208\176\208\179\208\190\208\188 \208\191\208\184\208\186\208\189\209\131\208\187?", 
            [36] = "?", 
            [37] = "\209\131 \209\130\208\181\208\177\209\143 \208\191\208\184\208\189\208\186 \209\129\208\191\208\176\208\185\208\186?", 
            [38] = "\208\186\208\176\208\186 \209\130\209\139 \208\180\208\176\208\188\208\176\208\179 \208\178\209\139\208\177\208\184\208\187?", 
            [39] = "\208\189\208\176\209\133\209\131\208\185 \209\130\209\139 \209\141\209\130\208\190 \208\191\208\184\208\186\208\176\208\181\209\136\209\140?", 
            [40] = "\208\189\208\176\209\133\209\131\208\185 \209\130\209\139 \208\191\208\184\208\186\208\189\209\131\208\187?", 
            [41] = "\208\188\208\176\209\130\209\140 \208\181\208\177\208\176\208\187 \208\191\208\184\208\180\208\176\209\128\208\176\209\129", 
            [42] = "\209\130\209\139 \209\129 \209\129\208\190\209\130\208\186\208\190\208\185 \208\191\208\184\208\186\208\189\209\131\208\187?", 
            [43] = "\208\189\209\131 \209\132\209\128\208\184\209\129\209\130\208\181\208\189\208\180\208\184\208\189\208\179 \208\182\208\181 \208\189\208\181 \209\129\209\128\208\176\208\177\208\190\209\130\208\176\208\181\209\130", 
            [44] = "\209\135\208\184\209\130 \208\180\208\181\208\187\208\181\208\184\209\130", 
            [45] = "\208\177\208\187\209\143 \208\189\209\131 \209\130\209\139 \209\128\208\181\208\176\208\187\209\140\208\189\208\190 \208\181\208\177\208\187\208\176\208\189", 
            [46] = "\208\189\209\131 \208\189\208\181\209\130", 
            [47] = "\209\129\209\128\208\176\208\183\209\131 \208\178\208\184\208\180\208\189\208\190 iq 14\208\186 \209\142\208\184\208\180\208\176", 
            [48] = "S[DF[F[DF[SDF[SD[FSD[FDS[F[F[F[F", 
            [49] = "\208\180\208\176 \209\131\208\177\208\190\208\179\208\184\208\185 \209\133\209\131\208\181\209\129\208\190\209\129", 
            [50] = "\209\131 \209\130\208\181\208\177\209\143 \209\129\208\186\208\184\209\130?", 
            [51] = "\208\189\209\131 \209\130\209\139 \208\181\208\177\208\176\208\187\208\190\208\190", 
            [52] = "\208\180\208\176 \208\186\209\131\208\180\208\176 \209\130\209\139 \209\131\208\177\208\184\208\187 \209\131\209\145\208\177\208\190\208\186", 
            [53] = "\208\180\208\176 \208\190\208\191\209\143\209\130\209\140 \209\131\209\145\208\177\208\184\209\137\208\181 \209\131\208\177\208\184\208\187\208\190", 
            [54] = "\209\130\209\139 \208\184\208\183 \208\177\208\184\208\185\209\129\208\186\208\176?", 
            [55] = "\209\133\208\190\209\128\208\190\209\136 \208\180\208\190\208\188\208\184\208\189\208\184\208\186", 
            [56] = "\208\180\208\176 \209\131 \209\130\208\181\208\177\209\143 \208\188\208\176\209\130\209\140 \209\136\208\187\209\142\209\133\208\181\208\189\208\180\209\128\208\176", 
            [57] = "\208\189\208\181 \209\131\208\182\208\181\208\187\208\184 \208\180\208\190\208\187\208\177\208\176\208\181\208\177 \208\180\208\190\208\180\209\131\208\188\208\176\208\187\209\129\209\143 \208\191\208\184\208\186\208\189\209\131\209\130\209\140", 
            [58] = "\209\130\208\184\208\188\208\188\208\181\208\185\209\130 \208\181\208\177\209\131 \208\180\208\176\208\187, \208\191\209\128\208\190\209\129\209\130\208\190 \209\129\208\188\209\139\209\129\208\187\209\129\209\143 \208\189\208\176\209\133\209\131\208\185", 
            [59] = "\209\131 \208\178\208\176\209\129 \209\130\208\190\208\182\208\181 loss \208\191\208\190\208\180\208\189\209\143\208\187\209\129\209\143?", 
            [60] = "\209\131 \208\186\208\190\208\179\208\190 \208\191\208\190\209\129\208\187\208\181 \208\190\208\177\208\189\208\190\208\178\209\139 sprid \208\178\209\139\208\187\208\181\209\130\208\176\208\181\209\130 \209\130\208\190\208\182\208\181", 
            [61] = "\208\180\208\190\208\187\208\177\208\176\208\181\208\177?", 
            [62] = "\209\141\209\130\208\190 100 dmg?"
        }, 
        mid = {
            [1] = "\208\184\208\180\208\184\208\190\209\130", 
            [2] = "\208\180\208\190\208\187\208\177\208\176\209\145\208\177", 
            [3] = "name", 
            [4] = "ahah", 
            [5] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
            [6] = "\209\129\209\131\209\135\208\176\209\128\208\176 \208\177\208\187\209\143", 
            [7] = "name", 
            [8] = "ahah", 
            [9] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
            [10] = "\208\180\208\190\208\187\208\177\208\190\209\145\208\177\208\184\208\186", 
            [11] = "\209\129\208\178\208\184\208\189\209\140\209\143", 
            [12] = "\209\131\208\186\209\128\208\176\208\184\208\189\208\181\209\134 \209\145\208\177\208\176\208\189\209\139\208\185", 
            [13] = "\209\133\209\131\208\185", 
            [14] = "\208\188\209\131\209\129\208\190\209\128", 
            [15] = "\208\189\208\184\208\186 \209\132\208\184\208\186\209\129", 
            [16] = "\208\186\209\130\208\190 \209\130\208\181\208\177\208\181 \209\130\208\176\208\186\208\190\208\185 \208\189\208\184\208\186 \208\191\209\128\208\184\208\180\209\131\208\188\208\176\208\187??", 
            [17] = "\208\189\208\181\208\185\208\188 \209\132\208\184\208\186\209\129", 
            [18] = "\208\184\208\180\208\184 \208\189\208\176\209\133\209\131\208\185", 
            [19] = "0 \208\190\209\136\208\184\208\177\208\190\208\186", 
            [20] = "\209\129\208\190\209\135\208\189\209\143\209\128\208\176", 
            [21] = "\208\177\208\181\208\183 \209\129\208\186\208\184\209\130\208\176", 
            [22] = "\208\186\209\128\209\143\208\186\208\181\209\128", 
            [23] = "\208\189\208\184\208\186\209\129 \209\142\208\183\208\181\209\128", 
            [24] = "\208\184\209\136\208\176\208\186", 
            [25] = "\208\180\208\190\208\188\208\184\208\189\208\184\208\186", 
            [26] = "\208\176\209\128\208\188\209\143\208\189\208\184\208\189", 
            [27] = "\208\178\209\139\209\129\208\181\209\128 \208\191\208\190\209\130\208\189\209\139\208\185", 
            [28] = "\208\191\208\190\209\130\208\189\208\176\209\143 \209\133\209\131\208\184\208\187\208\176", 
            [29] = "\208\189\209\131 \208\179\208\187\209\131\208\191\209\139\208\185 \208\188\208\190\209\135\208\181\208\179\208\190\208\189", 
            [30] = "\208\180\208\176\208\182\208\181 \208\188\208\176\209\131\209\130 \208\187\209\131\209\135\209\136\208\181 \209\130\208\181\208\177\209\143", 
            [31] = "\208\180\208\176\208\182\208\181 \209\130\209\131\209\128\208\186\208\184 \208\187\209\131\209\135\209\136\208\181 \209\130\208\181\208\177\209\143 \209\133\208\178\209\133 \208\184\208\179\209\128\208\176\209\142\209\130", 
            [32] = "\208\190\208\189\208\190 \208\182\208\181 \208\189\208\176 \208\187\208\190\209\131 \208\177\209\128\208\181\208\185\208\189\208\181 \208\184\208\179\209\128\208\176\208\181\209\130", 
            [33] = "\208\180\208\176 \209\129\209\129\208\176\208\189\209\139\208\185 \208\186\208\190\208\189\209\135\208\181\208\187\209\139\208\179\208\176", 
            [34] = "\209\135\209\131\209\128\208\186\208\184\209\129\209\130\208\176\208\189 \209\131\208\177\208\190\208\179\208\184\208\185", 
            [35] = "\208\189\209\131 \208\179\208\187\209\131\208\191\209\139\208\185 \209\128\208\181\208\177\209\145\208\189\208\190\208\186", 
            [36] = "\208\188\209\128\208\176\208\183\209\140 \208\181\208\177\208\176\208\189\208\176\209\143", 
            [37] = "\208\188\209\131\209\129\208\190\209\128\208\184\208\187\208\176 \208\179\208\187\209\131\208\191\208\176\209\143", 
            [38] = "\208\191\209\128\208\190\208\177\208\186\208\176 \208\187\208\181\208\179\208\184\209\130\208\189\208\176\209\143", 
            [39] = "\208\183\209\128\209\143 \209\129\209\131\209\135\208\190\208\189\208\190\208\186"
        }, 
        close = {
            [1] = "1x1?", 
            [2] = "\208\180\209\129 \208\186\208\184\208\180\208\176\208\185", 
            [3] = "\208\186\208\184\208\189\209\140 \208\186\209\132\208\179", 
            [4] = "\209\135\209\145 \208\183\208\176 \208\187\209\131\208\176", 
            [5] = "1.", 
            [6] = "\208\186\208\190\208\189\209\135", 
            [7] = "\208\186\208\178??", 
            [8] = "\209\129\209\130\208\176\209\130\209\131 \208\176\208\189\208\188\208\176\209\130\209\135\208\181\208\180\208\176 \208\186\208\184\208\180\208\176\208\185 \209\133\209\131\208\181\209\129\208\190\209\129", 
            [9] = "\208\181\208\187\208\181 \209\129\208\176\208\177 \208\179\208\181\209\130\208\189\209\131\208\187?", 
            [10] = "\208\186\208\190\208\189\208\189\208\181\208\186\209\130 \208\182\208\180\209\131", 
            [11] = "\208\189\209\131 \208\179\208\180\208\181 \209\130\208\184\208\188\208\188\208\181\208\185\209\130\209\139", 
            [12] = "\208\191\208\184\208\183\208\180\208\176 \209\130\208\178\208\190\208\181\208\188\209\131 \208\176\208\186\208\186\209\131 \209\129 \208\187\208\190\208\187\208\183\208\176", 
            [13] = "\209\130\208\181\208\177\209\143 \209\129\209\130\208\184\208\178\208\176\209\133\208\176 \208\189\208\181 \208\183\208\189\208\176\208\181\209\130", 
            [14] = "\209\130\209\139 \208\178\208\190\208\190\208\177\209\137\208\181 \209\135\208\184\209\130\208\176\208\181\209\136\209\140 \209\135\209\130\208\190 \209\143 \208\191\208\184\209\136\209\131", 
            [15] = "\208\189\208\187 1\208\189\208\1761 \208\178\209\139\208\178\208\181\208\183\208\181\209\136\209\140?", 
            [16] = "\208\176\209\136\208\176\208\187\208\181\208\181\208\181\209\130\209\140", 
            [17] = "\209\130\209\139 \209\129\208\190\209\135\208\189\209\139\208\185 \208\183\208\176 \209\130\208\181\208\177\209\143 \208\178 \209\135\208\176\209\130 \208\187\209\131\208\176 \208\191\208\184\209\136\208\181\209\130", 
            [18] = "\208\190\209\130 \209\129\208\176\208\177\208\186\208\184 \208\180\208\190 \209\129\208\176\208\177\208\186\208\184 \208\182\208\184\208\178\209\145\208\184\209\130", 
            [19] = "\209\143 \208\178 \208\176\209\133\209\131\208\181", 
            [20] = "\208\189\208\181 \208\187\208\184\208\178\208\176\208\185", 
            [21] = "\209\143 \209\137\208\176\209\129 \208\177\208\181\208\186\208\176\208\191 \208\191\208\190\208\183\208\190\208\178\209\131", 
            [22] = "\209\143 \208\177\209\131\208\180\209\131 \208\190\208\189\208\187\208\184 \208\177\208\190\208\180\208\184 \209\130\208\181\208\191\208\181\209\128\209\140", 
            [23] = "\209\130\209\139 \209\133\208\190\209\130\209\140 \208\191\208\190\208\189\209\143\208\187 \209\135\209\130\208\190 \209\129\208\180\208\181\208\187\208\176\208\187", 
            [24] = "\209\135\209\131\209\135\208\181\208\187\208\190 \209\129\208\191\208\184\208\189\208\190\208\185 \209\131\208\177\208\184\208\187\208\190", 
            [25] = "\208\158\208\157\208\158 \208\156\208\149\208\157\208\175 \208\145\208\149\208\161\208\152\208\162", 
            [26] = "\208\181\208\188\209\131 \209\135\208\184\209\130 \208\190\208\177\208\189\208\190\208\178\208\184\208\187\208\184", 
            [27] = "\208\189\208\176\208\185\209\129 100 \208\180\208\188\208\179 \208\190\208\189\208\187\208\184", 
            [28] = "\208\190\209\135\208\181\209\128\208\181\208\180\208\189\208\190\208\185 \208\187\208\181\208\179\208\184\209\130\208\189\209\139\208\185 \208\181\208\177\208\187\208\176\208\189", 
            [29] = "\208\190\209\135\208\181\209\128\208\181\208\180\208\189\208\190\208\185 \208\191\208\190\208\180\209\129\208\190\209\129 \209\129\208\176\208\189\209\135\208\181\208\183\208\176?", 
            [30] = "\208\176 \209\141\209\130\208\190 \208\189\208\181 \209\130\209\139 \208\186\208\178 \208\188\208\189\208\181 \208\191\209\128\208\190\208\184\208\179\209\128\208\176\208\187?", 
            [31] = "\209\143 \209\130\208\181\208\177\209\143 \209\130\209\128\208\176\209\133\208\189\209\131", 
            [32] = "40\208\186 \208\183\208\176 \208\184\208\189\208\178\208\176\208\185\209\130 \208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\187\208\184 \209\129\208\181\208\177\209\143", 
            [33] = "\208\189\208\184\209\137\208\184\209\130\208\176 \208\181\208\177\208\176\208\189\208\176\209\143", 
            [34] = "\208\180\208\176 \209\130\209\143 \208\180\208\176\208\182\208\181 \209\129\209\130\208\184\208\178\208\176\209\133\208\176 \208\191\208\181\209\128\208\181\208\177\208\176\208\185\209\130\208\184\209\130", 
            [35] = "\208\180\208\176\208\182\208\181 \209\129\209\130\208\184\208\178\208\176\209\133\208\176 \208\187\209\131\209\135\209\136\208\181 \209\130\208\181\208\177\209\143 \208\184\208\179\209\128\208\176\208\181\209\130", 
            [36] = "\209\141\209\130\208\190 \208\189\208\181 \209\130\209\139 \208\188\208\189\208\181 \208\189\208\176 \208\176\208\189\208\188\208\176\209\130\209\135\208\181\208\180\208\181 \208\191\209\128\208\190\208\184\208\179\209\128\208\176\208\187?", 
            [37] = "\209\141\209\130\208\190 \209\130\209\139 \208\184\208\183 \208\177\208\184\208\185\209\129\208\186\208\176?", 
            [38] = "\208\191\208\184\208\183\208\180\208\181\209\134 \209\129\208\190\209\135\208\189\208\184\208\186\208\184 \209\132\208\176\208\189\208\176\209\130\209\143\209\130", 
            [39] = "\208\176 \208\177\209\128\209\143\208\189\209\129\208\186 \209\141\209\130\208\190 \208\178\208\189\208\176\209\130\209\131\209\128\208\181 \208\179\208\190\209\128\208\190\208\180?", 
            [40] = "\209\130\209\139 \208\184\208\183 \208\177\208\184\208\185\209\129\208\186\208\176?)", 
            [41] = "\209\141\209\130\208\190 \208\189\208\181 \209\130\209\139 \208\177\209\131\208\186\208\178\209\131 z \208\189\208\176 \208\187\208\177\209\131 \208\189\208\176\209\128\208\184\209\129\208\190\208\178\208\176\208\187?", 
            [42] = "\209\141\209\130\208\190 \208\189\208\181 \209\130\209\139 \209\131 \209\132\208\184\208\191\208\176 \209\129\208\176\208\177\208\186\209\131 \208\191\208\190\208\186\209\131\208\191\208\176\208\187?", 
            [43] = "\208\183\208\176\208\179\209\128\209\131\208\183\208\184\208\187 \208\180\208\190\208\188\208\181\208\189\208\184\208\186 \209\143\208\178 \208\184 \208\178\208\190\209\130 \209\130\208\181 \209\128\208\176\208\183, \209\131\208\178\208\184\208\180\208\184\208\188\209\129\209\143 \208\178 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\181\208\188 \209\128\208\176\209\131\208\189\208\180\208\181", 
            [44] = "\209\143 \209\135\209\130\208\190 \208\190\208\180\208\184\208\189 \208\178 \209\130\208\184\208\188\208\181 \208\177\208\187\209\143\209\130\209\140", 
            [45] = "\208\188\209\131\208\182\208\184\208\186\208\184, \209\143 \208\178 \208\188\209\131\209\130\208\181?", 
            [46] = "\209\131 \208\188\208\181\208\189\209\143 \209\130\208\184\208\188\208\188\208\181\208\185\209\130\209\139 \209\129 \208\189\208\184\208\186\209\129\208\190\208\188 \209\135\209\130\208\190\208\187\208\184 \208\191\208\190\208\179\208\190\208\187\208\190\208\178\208\189\208\190, \208\190\209\130\208\186\208\184\209\129\208\176\209\142\209\130 \208\189\208\176 \209\128\208\176\208\183 \208\180\208\178\208\176", 
            [47] = "\208\191\208\176\209\128\208\189\208\184 \208\186\208\176\208\186 \208\178 tub \208\191\208\190\208\186\208\176\208\183 \208\189\208\187\208\176 \208\178\209\139\208\186\208\187\209\142\209\135\208\184\209\130\209\140", 
            [48] = "\208\180\208\176 \208\178\209\139 \208\177\208\187\209\143 \209\129 \208\191\209\128\208\181\208\180\208\184\208\186\209\130\208\190\208\188 \209\135\209\130\208\190\208\187\208\184 \208\178\208\176\209\130\209\128\209\131\209\133\209\131 \208\179\208\190\208\189\209\143\208\181\209\130\208\181", 
            [49] = "\209\129\208\186\208\190\208\186 \209\137\208\176 \208\178 \208\189\208\187\208\181 \208\191\208\184\208\189\208\179 \209\129\209\130\208\176\208\178\208\184\209\130\209\140 \208\187\209\131\209\135\209\136\208\181"
        }
    };
    local function v1651()
        -- upvalues: l_random_int_0 (ref)
        local v1647 = "";
        local v1648 = "";
        for _ = 1, l_random_int_0(1, 4) do
            if v1648 == ")" then
                local v1650 = l_random_int_0(0, 2) == 0 and "0" or ")";
                v1647 = v1647 .. v1650;
                v1648 = v1650;
            else
                v1647 = v1647 .. ")";
                v1648 = ")";
            end;
        end;
        return v1647;
    end;
    local function _(v1652)
        -- upvalues: v1646 (ref), l_random_int_0 (ref), v1625 (ref), v1629 (ref), v1651 (ref), v1631 (ref)
        local v1653 = v1646.start[l_random_int_0(1, #v1646.start)];
        if l_random_int_0(0, 2) == 0 then
            v1653 = v1653:upper();
        end;
        local v1654 = v1646.mid[l_random_int_0(1, #v1646.mid)];
        if v1654 == "name" then
            v1654 = v1625(v1652:get_name());
        elseif v1654 == "ahah" then
            v1654 = v1629();
        end;
        if l_random_int_0(0, 2) == 0 then
            v1654 = v1654 .. v1651();
        end;
        v1631.kill = {
            [1] = 5
        };
        v1631.troll = {
            [1] = 5
        };
        v1631["death #1"] = {
            [1] = 5, 
            [2] = v1653
        };
        if l_random_int_0(0, 2) > 0 then
            v1631["death #2"] = {
                [1] = 5, 
                [2] = v1654
            };
            if l_random_int_0(0, 1) == 1 then
                local v1655 = v1646.close[l_random_int_0(1, #v1646.close)];
                v1631["death #3"] = {
                    [1] = 0.2, 
                    [2] = v1655
                };
            end;
        end;
    end;
    v260:add("draw", "trashtalk run", function(_, _)
        -- upvalues: v178 (ref), v179 (ref), v1631 (ref)
        if not v178.misc or not v179.trashtalk.main then
            return;
        else
            local l_realtime_2 = globals.realtime;
            for v1660, v1661 in pairs(v1631) do
                if v1661 and v1661[1] ~= 0 and v1661[1] < l_realtime_2 then
                    if utils.random_int(0, 2) == 0 then
                        utils.console_exec("say 1");
                    else
                        utils.console_exec("say 1");
                    end;
                    v1631[v1660] = {
                        [1] = 0
                    };
                end;
            end;
            return;
        end;
    end);
    local _ = {
        [1] = "\208\189\208\176\208\185\209\129 \208\184\208\179\209\128\208\176", 
        [2] = "\209\131\209\145\208\177\208\184\209\137\208\181 \208\178\208\176\208\187\208\178", 
        [3] = "\209\131\208\177\208\184\208\187\208\190 \208\189\208\176\209\133\209\131\208\185", 
        [4] = "\208\189\208\184\209\137\208\184\208\185 \208\178\208\176\208\187\208\178", 
        [5] = "\208\189\208\176\208\180\208\181\209\142\209\129\209\140 \208\178 \209\129\209\131\209\128\209\129 2 \208\191\208\190\209\132\208\184\208\186\209\129\209\143\209\130 \209\141\209\130\208\190", 
        [6] = "\208\181\208\177\208\176\209\130\209\140", 
        [7] = "\208\177\208\187\209\143\209\143\209\143\209\143 \209\131\208\177\208\184\208\187\208\190\208\190\208\190"
    };
    local v1663 = -1;
    v260:add("player_death", "trashtalk player death", function(v1664, v1665, _)
        -- upvalues: v178 (ref), v179 (ref), v684 (ref), v263 (ref), v1663 (ref), v1631 (ref), v1645 (ref)
        if not v1665 or not v178.misc or not v179.trashtalk.main then
            return;
        else
            local v1667 = entity.get_game_rules();
            if not v1667 then
                return;
            elseif v1667.m_bWarmupPeriod then
                return;
            else
                local v1668 = v684.GetPlayerForUserID(v1664.userid);
                local v1669 = v684.GetPlayerForUserID(v1664.attacker);
                if not v1668 or not v1669 or v1668 == nil or v1669 == nil then
                    return;
                elseif v1668 == v1669 then
                    return;
                else
                    local v1670 = v263.Misc.trashtalk.main:get();
                    if v1663 ~= -1 and v1670 and v1669 ~= v1665 and entity.get(v1663) == v1668 then
                        v1631["death #1"] = nil;
                        v1631["death #2"] = nil;
                        v1631["death #3"] = nil;
                        v1631.killer = {
                            [1] = nil, 
                            [2] = "1.", 
                            [1] = globals.realtime + 0.4
                        };
                        v1663 = -1;
                    end;
                    if v263.Misc.trashtalk.main:get() and v1669 == v1665 then
                        v1645(v1668);
                    end;
                    if v1668 == v1665 and v1670 and v1669:is_player() then
                        v1663 = v1669:get_index();
                    end;
                    return;
                end;
            end;
        end;
    end);
    v260:add("round_prestart", "trashtalk killer", function(_, _, _)
        -- upvalues: v1663 (ref), v1631 (ref)
        v1663 = -1;
        v1631 = {};
    end);
end)();
(function()
    -- upvalues: v401 (ref), v178 (ref), v263 (ref), v260 (ref)
    local function v1674()
        -- upvalues: v401 (ref)
        cvar.viewmodel_fov:int(v401.fov, true);
        cvar.viewmodel_offset_x:float(v401.viewmodel_offset_x, true);
        cvar.viewmodel_offset_y:float(v401.viewmodel_offset_y, true);
        cvar.viewmodel_offset_z:float(v401.viewmodel_offset_z, true);
    end;
    local function v1675()
        -- upvalues: v178 (ref), v263 (ref), v1674 (ref)
        if v178.misc and v263.Misc.view_model.main:get() then
            cvar.viewmodel_fov:int(v263.Misc.view_model.fov:get(), true);
            cvar.viewmodel_offset_x:float(v263.Misc.view_model.offset_x:get() / 15, true);
            cvar.viewmodel_offset_y:float(v263.Misc.view_model.offset_y:get() / 15, true);
            cvar.viewmodel_offset_z:float(v263.Misc.view_model.offset_z:get() / 15, true);
        else
            v1674();
        end;
    end;
    v263.Misc.view_model.main:RegisterCallback(v1675);
    v263.Misc.view_model.fov:RegisterCallback(v1675);
    v263.Misc.view_model.offset_x:RegisterCallback(v1675);
    v263.Misc.view_model.offset_y:RegisterCallback(v1675);
    v263.Misc.view_model.offset_z:RegisterCallback(v1675);
    v263.Misc.main:RegisterCallback(v1675);
    v1675();
    v260:add("destroy", "view model fix", v1674);
end)();
(function()
    -- upvalues: v260 (ref), v179 (ref)
    ffi.cdef("        uintptr_t GetForegroundWindow();\n        int FlashWindow(void* hWnd, int bInvert);\n    ");
    local function v1679()
        local v1676 = entity.get_game_rules();
        if not v1676 or v1676 == nil or v1676.m_bIsValveDS then
            return;
        else
            local v1677 = utils.opcode_scan("engine.dll", "8B 0D ? ? ? ? 85 C9 74 16 8B 01 8B");
            local v1678 = ffi.cast("void*", (ffi.cast("uintptr_t***", ffi.cast("uintptr_t", v1677) + 2)[0][0] + 2)[0]);
            if v1678 ~= ffi.C.GetForegroundWindow() then
                ffi.C.FlashWindow(v1678, 0);
            end;
            return;
        end;
    end;
    v260:add("round_prestart", "wanignging", function()
        -- upvalues: v179 (ref), v1679 (ref)
        if v179.round_warning then
            v1679();
        end;
    end);
    v260:add("round_freeze_end", "wanignging1", function()
        -- upvalues: v179 (ref), v1679 (ref)
        if v179.round_warning then
            v1679();
        end;
    end);
end)();
(function()
    -- upvalues: v179 (ref), v263 (ref), v260 (ref)
    local v1680 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
    local v1681 = false;
    local function v1687(v1682)
        table.foreach(materials.get_materials("vgui/hud/800"), function(_, v1684)
            -- upvalues: v1682 (ref)
            v1684:color_modulate(v1682);
            v1684:alpha_modulate(v1682.a / 255);
        end);
        table.foreach(materials.get_materials("vgui_white"), function(_, v1686)
            -- upvalues: v1682 (ref)
            v1686:color_modulate(v1682);
            v1686:alpha_modulate(v1682.a / 255);
        end);
    end;
    local function v1688()
        -- upvalues: v1681 (ref), v1687 (ref)
        if v1681 then
            v1687(color());
            v1681 = false;
        end;
    end;
    local function v1689()
        -- upvalues: v1681 (ref), v1687 (ref), v179 (ref)
        if not v1681 then
            v1687(v179.console_color.color);
            v1681 = true;
        end;
    end;
    cvar.toggleconsole:set_callback(function()
        -- upvalues: v179 (ref), v1689 (ref)
        if not v179.console_color.main then
            return;
        else
            v1689();
            return;
        end;
    end);
    v263.Modifications.console_color.color:RegisterCallback(function()
        -- upvalues: v179 (ref), v1681 (ref)
        if v179.console_color.main then
            v1681 = false;
        end;
    end);
    v260:add("draw", "console color", function()
        -- upvalues: v179 (ref), v1680 (ref), v1688 (ref), v1689 (ref)
        if not v179.console_color.main or not v1680() then
            return v1688();
        else
            v1689();
            return;
        end;
    end);
    v260:add("destroy", "console color 1", v1688);
end)();
(function()
    -- upvalues: v260 (ref), v179 (ref), v263 (ref), v139 (ref)
    local l_tickinterval_1 = globals.tickinterval;
    local v1691 = cvar.inferno_flame_lifetime:float();
    local v1692 = {};
    local v1693 = {};
    v260:add("draw", "grenade radius", function(v1694, v1695)
        -- upvalues: v179 (ref), v263 (ref), v1692 (ref), v1691 (ref), v139 (ref), v1693 (ref), l_tickinterval_1 (ref)
        if not v179.grenade_radius.main or v179.grenade_radius.options and #v179.grenade_radius.options == 0 then
            return;
        else
            local v1696 = nil;
            if v1695 then
                v1696 = v1694;
            elseif v1694 then
                v1696 = v1694.m_hObserverTarget;
            end;
            if not v1696 then
                return;
            else
                local v1697 = v1696.get_origin(v1696);
                local l_realtime_3 = globals.realtime;
                local l_tickcount_2 = globals.tickcount;
                if v263.Modifications.grenade_radius.options:get(1) then
                    local v1700 = {
                        v263.Modifications.grenade_radius.fire_color:Get(), 
                        v263.Modifications.grenade_radius.fire_color1:Get()
                    };
                    local l_m_iTeamNum_0 = v1696.m_iTeamNum;
                    do
                        local l_v1700_0, l_l_m_iTeamNum_0_0 = v1700, l_m_iTeamNum_0;
                        entity.get_entities("CInferno", false, function(v1704)
                            -- upvalues: v1692 (ref), v1691 (ref), l_realtime_3 (ref), l_tickcount_2 (ref), v139 (ref), v1697 (ref), l_v1700_0 (ref), l_l_m_iTeamNum_0_0 (ref), v1694 (ref)
                            local v1705 = v1704:get_origin();
                            if not v1705 then
                                return;
                            else
                                local v1706 = v1704:get_index();
                                if not v1692[v1706] then
                                    v1692[v1706] = {
                                        [1] = 0, 
                                        [2] = nil, 
                                        [3] = 0, 
                                        [4] = 175, 
                                        [2] = vector(), 
                                        [5] = v1704.m_nFireEffectTickBegin + v1691 * 64
                                    };
                                end;
                                local v1707 = v1692[v1706];
                                if v1707[3] < l_realtime_3 then
                                    local v1708 = {};
                                    for v1709 = 1, 20 do
                                        v1708[v1709] = v1705 + vector(v1704.m_fireXDelta[v1709 - 1], v1704.m_fireYDelta[v1709 - 1], 0);
                                    end;
                                    local v1710 = 0;
                                    local v1711 = 1;
                                    local v1712 = 1;
                                    for v1713 = 1, 20 do
                                        for v1714 = 1, 20 do
                                            local v1715 = v1708[v1713]:dist(v1708[v1714]);
                                            if v1710 < v1715 then
                                                v1710 = v1715;
                                                local l_v1713_0 = v1713;
                                                v1712 = v1714;
                                                v1711 = l_v1713_0;
                                            end;
                                        end;
                                    end;
                                    if v1710 == 0 then
                                        return;
                                    else
                                        v1707[2] = (v1708[v1711] + v1708[v1712]) / 2;
                                        v1707[3] = l_realtime_3 + 0.5;
                                        v1707[4] = v1710 * 0.65;
                                    end;
                                end;
                                local v1717 = v1707[5] - l_tickcount_2;
                                v1707[1] = v139(v1707[1], v1707[4], 0.05);
                                local v1718 = v1707[1];
                                local v1719 = v1707[2];
                                local v1720 = 1;
                                if v1697 then
                                    local v1721 = v1697:dist(v1705);
                                    v1720 = v1721 > 500 and math.clamp(15 / (v1721 - 500), 0, 1) or 1;
                                end;
                                local v1722 = l_v1700_0[1];
                                local l_m_hOwnerEntity_0 = v1704.m_hOwnerEntity;
                                if l_m_hOwnerEntity_0 and l_m_hOwnerEntity_0.m_iTeamNum == l_l_m_iTeamNum_0_0 and l_m_hOwnerEntity_0 ~= v1694 then
                                    v1722 = l_v1700_0[2];
                                end;
                                render.circle_3d_outline(v1719, v1722.alpha_modulate(v1722, v1722.a * v1720 * (v1717 < 15 and v1717 / 15 or 1)), v1718, 0, 1, 1.3);
                                if v1717 <= 0 then
                                    v1692[v1706] = nil;
                                end;
                                return;
                            end;
                        end);
                    end;
                end;
                if v263.Modifications.grenade_radius.options:get(2) then
                    local v1724 = v263.Modifications.grenade_radius.smoke_color:Get();
                    do
                        local l_v1724_0 = v1724;
                        entity.get_entities("CSmokeGrenadeProjectile", false, function(v1726)
                            -- upvalues: v1693 (ref), l_tickinterval_1 (ref), v139 (ref), v1697 (ref), l_tickcount_2 (ref), l_v1724_0 (ref)
                            local v1727 = v1726:get_origin();
                            if not v1727 or v1726.m_nSmokeEffectTickBegin == 0 then
                                return;
                            else
                                local v1728 = v1726:get_index();
                                if not v1693[v1728] then
                                    v1693[v1728] = {
                                        [1] = 0, 
                                        [2] = v1726.m_nSmokeEffectTickBegin + math.floor(17.55 / l_tickinterval_1)
                                    };
                                end;
                                local v1729 = v1693[v1728];
                                v1729[1] = v139(v1729[1], 125, 0.05);
                                local v1730 = 1;
                                if v1697 then
                                    local v1731 = v1697:dist(v1727);
                                    v1730 = v1731 > 850 and math.clamp(15 / (v1731 - 850), 0, 1) or 1;
                                end;
                                local v1732 = v1729[2] - l_tickcount_2;
                                render.circle_3d_outline(v1727, l_v1724_0:alpha_modulate(l_v1724_0.a * v1730 * (v1732 < 15 and v1732 / 15 or 1)), v1729[1], 0, 1, 1.3);
                                if v1732 <= 0 then
                                    v1693[v1728] = nil;
                                end;
                                return;
                            end;
                        end);
                    end;
                end;
                return;
            end;
        end;
    end);
end)();
v1467 = function(v1733, v1734)
    local v1735 = globals.realtime * (v1734 or 1) % math.pi;
    local v1736 = math.sin(v1735 + (v1733 or 0));
    return (math.abs(v1736));
end;
v1468 = table.concat;
local v1749 = new_class():struct("info")({
    screen_size = render.screen_size()
}):struct("draw")({
    field = function(_, v1738, v1739, v1740, v1741, v1742, v1743, v1744)
        local l_v1744_0 = v1744;
        render.shadow(v1738 - vector(0, v1743), v1738 + v1739, v1742, 32, 0, l_v1744_0);
        render.rect(v1738, v1738 + v1739, v1741, l_v1744_0);
        if v1743 ~= 0 then
            render.rect(v1738 - vector(-l_v1744_0, v1743), v1738 + vector(v1739.x - l_v1744_0, 0), v1740, 0);
            if l_v1744_0 ~= 0 then
                local v1746 = vector(l_v1744_0, l_v1744_0);
                render.circle_outline(v1738 + v1746, v1740, l_v1744_0 + v1743, -180, 0.25, v1743);
                render.circle_outline(v1738 + vector(v1739.x - l_v1744_0, l_v1744_0), v1740, l_v1744_0 + v1743, -90, 0.25, v1743);
                local v1747 = v1740:alpha_modulate(0);
                local _ = v1743 / 2 - 1;
                render.gradient(v1738 - vector(v1743, -l_v1744_0), v1738 + vector(0, l_v1744_0 + 10), v1740, v1740, v1747, v1747);
                render.gradient(v1738 + vector(v1739.x, l_v1744_0), v1738 + vector(v1739.x + v1743, l_v1744_0 + 10), v1740, v1740, v1747, v1747);
            end;
        end;
    end
});
local function v1752(v1750, v1751)
    if v1751 < v1750:len() then
        v1750 = v1750:sub(0, v1751) .. "...";
    end;
    return v1750;
end;
local function v1757(v1753, v1754, v1755, v1756)
    v1753 = v1753 / v1756 - 1;
    return v1755 * (math.pow(v1753, 5) + 1) + v1754;
end;
local v1758 = v67.build == "beta" and " [beta]" or "";
local v1759 = l_ui_0.find("Miscellaneous", "Main", "Other", "Windows");
local v1760 = 0;
local v1761 = 0;
local v1762 = 0;
local v1763 = "0 fps";
local l_cl_updaterate_0 = cvar.cl_updaterate;
local v1765 = nil;
local v1766 = utils.get_vfunc("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)");
local v1767 = utils.get_vfunc(25, "void(__thiscall*)(void*, float*, float*, float*)");
local v1768 = ffi.typeof("float[1]");
do
    local l_v1766_0, l_v1767_0, l_v1768_0 = v1766, v1767, v1768;
    v1765 = function()
        -- upvalues: l_v1766_0 (ref), l_v1768_0 (ref), l_v1767_0 (ref)
        local v1772 = l_v1766_0();
        if v1772 == nil then
            return 0, 0;
        else
            local v1773 = l_v1768_0();
            local v1774 = l_v1768_0();
            l_v1767_0(v1772, v1773, v1774, l_v1768_0());
            return tonumber(v1773[0]), tonumber(v1774[0]);
        end;
    end;
end;
v1766 = {
    color(255, 255, 255, 255), 
    color(255, 31, 31, 255), 
    color(255, 125, 31, 255), 
    color(255, 255, 31, 255)
};
do
    local l_v1468_1, l_v1749_0, l_v1752_0, l_v1758_0, l_v1759_0, l_v1760_0, l_v1761_0, l_v1763_0, l_l_cl_updaterate_0_0, l_v1765_0, l_v1766_1, l_v1767_1, l_v1768_1 = v1468, v1749, v1752, v1758, v1759, v1760, v1761, v1763, l_cl_updaterate_0, v1765, v1766, v1767, v1768;
    l_v1767_1 = function(v1788, v1789, v1790, v1791, v1792)
        -- upvalues: l_v1766_1 (ref), l_abs_0 (ref)
        if v1789 == 0 then
            return l_v1766_1[1];
        else
            local v1793 = l_abs_0(v1789 - v1788) / v1789;
            if v1792 < v1793 then
                return l_v1766_1[2];
            elseif v1791 < v1793 then
                return l_v1766_1[3];
            elseif v1790 < v1793 then
                return l_v1766_1[4];
            else
                return l_v1766_1[1];
            end;
        end;
    end;
    l_v1768_1 = nil;
    network.get("https://i.imgur.com/6viN9T2.png", {}, function(v1794)
        -- upvalues: l_v1768_1 (ref)
        if v1794 then
            l_v1768_1 = render.load_image(v1794, vector(64, 64));
        end;
    end);
    local v1925 = new_class():struct("ui")({
        parent = v314:SetupGroup(v489, v404.tabs.Widgets), 
        get_colors = function(_, v1796)
            local v1797 = {
                v1796:to_hsv()
            };
            local v1798 = (v1797[2] * 255 - 85) / 255;
            return color():as_hsv(v1797[1], math.max(0, v1798), v1797[3] + (v1798 < 0 and -v1798 or 0), 1), v1796;
        end
    }):struct("watermark")({
        menu = {}, 
        anims = {
            requested_size_x = 125, 
            global_alpha = 0, 
            new_alpha_req = 1, 
            size_x = 0
        }, 
        initialize = function(v1799)
            -- upvalues: v263 (ref)
            v1799.menu.main = v263.Visuals.velocity_warning.items;
            v1799.menu.parent = v1799.menu.main:create();
            local l_parent_1 = v1799.menu.parent;
            v1799.menu.accent = l_parent_1:color_picker("Accent", color(167, 167, 255, 255));
            v1799.menu.accent1 = l_parent_1:color_picker("Gradient", color());
            v1799.menu.shadow = l_parent_1:color_picker("Shadow", color(167, 167, 255, 125));
            v1799.menu.background = l_parent_1:color_picker("Background", color(17, 17, 17, 125));
            l_parent_1:label(" ");
            v1799.menu.elements = l_parent_1:selectable("Elements", {
                [1] = "Title", 
                [2] = "Username", 
                [3] = "Latency", 
                [4] = "Time"
            });
            l_parent_1:label(" ");
            v1799.menu.rounding = l_parent_1:slider("Rounding", 0, 10, 4, 1, "px");
            v1799.menu.thickness = l_parent_1:slider("Thickness", 1, 10, 2, 1, "px");
            v1799.menu.backup = nil;
        end, 
        update_time = globals.realtime, 
        update_time_sv = globals.realtime, 
        update_time_var = globals.realtime, 
        update_time_ping = globals.realtime, 
        icons = {
            Username = l_ui_0.get_icon("user") .. " ", 
            Latency = l_ui_0.get_icon("clock-rotate-left") .. " ", 
            Time = l_ui_0.get_icon("clock-five") .. " ", 
            FPS = l_ui_0.get_icon("film") .. " ", 
            ["Server Framerate"] = l_ui_0.get_icon("server") .. " "
        }, 
        reset_backup = function(v1801)
            -- upvalues: v143 (ref), l_v1759_0 (ref), v148 (ref)
            if v1801.menu.backup ~= nil then
                local v1802 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                v1802.Watermark = v1801.menu.backup;
                l_v1759_0:override(v148(v1802));
                v1801.menu.backup = nil;
            end;
        end, 
        draw = function(v1803)
            -- upvalues: v263 (ref), v139 (ref), v143 (ref), l_v1759_0 (ref), v148 (ref), l_v1749_0 (ref), l_v1768_1 (ref), v67 (ref), v1467 (ref), v488 (ref), l_v1758_0 (ref), l_v1752_0 (ref), l_l_cl_updaterate_0_0 (ref), l_v1760_0 (ref), l_v1761_0 (ref), l_v1763_0 (ref), l_v1765_0 (ref), l_v1766_1 (ref), l_v1767_1 (ref)
            local v1804 = v263.Visuals.velocity_warning.main:Get() and v263.Visuals.velocity_warning.items:Get(1);
            local v1805 = v263.Visuals.velocity_warning.elements:get() or {};
            if v1805 == nil then
                return;
            else
                local v1806 = #v1805 - 1;
                local v1807 = v1806 == -1;
                v1803.anims.global_alpha = v139(v1803.anims.global_alpha, v1804 and v1803.anims.new_alpha_req or 0, 0.1);
                local l_global_alpha_0 = v1803.anims.global_alpha;
                if l_global_alpha_0 == 0 then
                    return v1803:reset_backup();
                else
                    local v1809 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                    if v1803.menu.backup == nil then
                        v1803.menu.backup = v1809.Watermark;
                        v1809.Watermark = false;
                        l_v1759_0:override(v148(v1809));
                    end;
                    v1803.anims.size_x = v139(v1803.anims.size_x, v1803.anims.requested_size_x, 0.075);
                    local l_size_x_0 = v1803.anims.size_x;
                    local v1811 = vector(l_size_x_0, 21);
                    local v1812 = vector(l_v1749_0.info.screen_size.x - v1811.x - 10, 9);
                    local v1813 = v263.Visuals.velocity_warning.accent:Get();
                    local v1814 = l_v1768_1 and color(0, 0) or color(17, 17, 17, l_global_alpha_0 * 145);
                    local v1815, v1816 = v1803.ui:get_colors(v1813);
                    local v1817 = v1813:alpha_modulate(v1813.a * l_global_alpha_0);
                    local v1818 = v263.Visuals.velocity_warning.rounding:get();
                    local v1819 = v1816:alpha_modulate(v1816.a * l_global_alpha_0 * (l_v1768_1 and 0 or 1));
                    local v1820 = "";
                    if l_v1768_1 then
                        local _ = v1813:alpha_modulate(0);
                        local v1822 = v1812 - vector(21, 0);
                        local v1823 = v1812 + vector(v1811.x, 21);
                        render.rect(v1822, v1823, color(17, 17, 17, l_global_alpha_0 * 145), v1818);
                        render.shadow(v1822, v1823, v1816:alpha_modulate(v1816.a * l_global_alpha_0), 32, 0, v1818);
                        render.texture(l_v1768_1, v1812 - vector(18, 0), vector(22, 22), color(255, 255, 255, l_global_alpha_0 * 255));
                        if v67.build == "beta" then
                            local v1824 = "[beta] ";
                            local v1825 = #v1824 + 1;
                            local v1826 = "";
                            local v1827 = nil;
                            for v1828 = 1, v1825 do
                                local v1829 = v1824:sub(v1828, v1828);
                                local v1830 = (v1828 - 1) / v1825;
                                local v1831 = v1467(v1830 * 0.8, 0.8);
                                local v1832 = v1813:alpha_modulate(l_global_alpha_0 * 255):lerp(color(255, 255, 255, l_global_alpha_0 * 255), v1831);
                                if v1828 == 1 then
                                    v1827 = v1832;
                                end;
                                v1826 = v1826 .. string.format("\a%s%s", v1832:to_hex(), v1829);
                            end;
                            v1820 = v1820 .. v1826 .. "\aDEFAULT";
                        end;
                        v1820 = v1820 .. (not v1807 and "\194\183 " or "");
                    end;
                    l_v1749_0.draw:field(v1812, v1811, v1817, v1814:alpha_modulate(v1814.a * l_global_alpha_0), v1819, 0, v1818, l_v1768_1);
                    local v1833 = v143(v1805);
                    if v1833.Title then
                        local l_v1813_0 = v1813;
                        local l_v1815_0 = v1815;
                        v1820 = v1820 .. v488(l_v1813_0:alpha_modulate(l_global_alpha_0 * 255), l_v1815_0:alpha_modulate(l_v1815_0.a * l_global_alpha_0), "neverlose") .. "\aDEFAULT" .. l_v1758_0 .. (v1806 > 0 and " \194\183 " or "");
                        v1806 = v1806 - 1;
                    end;
                    if v1833.Username then
                        local v1836 = l_v1752_0(v263.Visuals.velocity_warning.custom_name:get(), 30);
                        local v1837 = v1836 == "" and v67.username or v1836;
                        v1820 = v1820 .. v1803.icons.Username .. v1837 .. (v1806 > 0 and " \194\183 " or "");
                        v1806 = v1806 - 1;
                    end;
                    local l_realtime_4 = globals.realtime;
                    if v1833.Latency then
                        if v1803.ping == nil or v1803.update_time_ping < l_realtime_4 then
                            v1803.ping = "local";
                            local v1839 = utils.net_channel();
                            if v1839 and not v1839.is_loopback then
                                local v1840 = l_l_cl_updaterate_0_0:float();
                                if v1840 > 0.001 then
                                    local v1841 = -0.5 / v1840;
                                    v1803.ping = math.max(0, math.floor((v1839.avg_latency[1] + v1841) * 1000)) .. "ms";
                                else
                                    v1803.ping = math.max(0, math.floor(v1839.avg_latency[1] * 1000)) .. "ms";
                                end;
                            end;
                            v1803.update_time_ping = l_realtime_4 + 2;
                        end;
                        if v1803.ping ~= "local" then
                            v1820 = v1820 .. v1803.icons.Latency .. v1803.ping .. (v1806 > 0 and " \194\183 " or "");
                            v1806 = v1806 - 1;
                        end;
                    end;
                    if v1833.FPS then
                        if globals.tickcount % 64 == 0 or l_v1760_0 == 0 then
                            l_v1760_0 = 0.9 * l_v1760_0 + 0.1 * globals.absoluteframetime;
                            if l_v1760_0 < 0 then
                                l_v1760_0 = 1;
                            end;
                            l_v1761_0 = 1 / l_v1760_0;
                        end;
                        local v1842 = math.floor(l_v1761_0);
                        l_v1763_0 = v1842 <= 70 and "\a" .. color(255, 117, 117):lerp(color(255, 0, 0), math.min(1, 1 - (v1842 - 60) / 10)):to_hex() .. v1842 or v1842;
                        v1820 = v1820 .. v1803.icons.FPS .. l_v1763_0 .. "fps\aDEFAULT" .. (v1806 > 0 and " \194\183 " or "");
                        v1806 = v1806 - 1;
                    end;
                    if v1833["Server Framerate"] then
                        if not v1803.sv or v1803.update_time_sv < l_realtime_4 then
                            local v1843, v1844 = l_v1765_0();
                            local v1845 = l_v1766_1[1];
                            local l_tickinterval_2 = globals.tickinterval;
                            if l_tickinterval_2 + 1.0E-4 < v1843 then
                                v1845 = l_v1767_1(v1843, l_tickinterval_2, 0.25, 0.5, 0.75);
                            end;
                            v1803.sv = ("\a%ssv: %.1f (%.1fms)\aDEFAULT"):format(v1845.to_hex(v1845), v1843 * 1000, v1844 * 1000);
                            v1803.update_time_sv = l_realtime_4 + 0.5;
                        end;
                        v1820 = v1820 .. v1803.icons["Server Framerate"] .. v1803.sv .. (v1806 > 0 and " \194\183 " or "");
                        v1806 = v1806 - 1;
                    end;
                    if v1833.Time then
                        if not v1803.time or v1803.update_time < l_realtime_4 then
                            local v1847 = common.get_system_time();
                            v1803.time = ("%02d:%02d"):format(v1847.hours, v1847.minutes);
                            v1803.update_time = l_realtime_4 + 5;
                        end;
                        v1820 = v1820 .. v1803.icons.Time .. v1803.time .. (v1806 > 0 and " \194\183 " or "");
                        v1806 = v1806 - 1;
                    end;
                    if v1806 == 0 then
                        v1820 = v1820.sub(v1820, 0, -5);
                    end;
                    render.push_clip_rect(v1812, v1812 + v1811 - vector(0, 4));
                    render.text(1, v1812 + vector(7, 4), color(255, 255 * l_global_alpha_0), "", v1820);
                    render.pop_clip_rect();
                    v1803.anims.requested_size_x = render.measure_text(1, "", v1820).x + (not v1807 and 13 or 8);
                    return;
                end;
            end;
        end
    }):struct("keybinds")({
        drag = v685.add("keybinds", vector(40 / v67.screen_size.x, v67.screen_size.y / 5 / v67.screen_size.y), vector(125, 22)), 
        menu = {}, 
        initialize = function(v1848)
            v1848.menu.main = v1848.ui.parent:switch("Keybinds");
            v1848.menu.parent = v1848.menu.main:create();
            local l_parent_2 = v1848.menu.parent;
            v1848.menu.accent = l_parent_2:color_picker("Accent", color(167, 167, 255, 255));
            v1848.menu.shadow = l_parent_2:color_picker("Shadow", color(167, 167, 255, 125));
            v1848.menu.background = l_parent_2:color_picker("Background", color(17, 17, 17, 125));
            l_parent_2:label(" ");
            v1848.menu.rounding = l_parent_2:slider("Rounding", 0, 10, 4, 1, "px");
            v1848.menu.thickness = l_parent_2:slider("Thickness", 1, 10, 2, 1, "px");
            v1848.menu.backup = nil;
        end, 
        anims = {
            requested_size_x = 125, 
            global_alpha = 0, 
            size_x = 125, 
            binds = {}
        }, 
        reset_backup = function(v1850)
            -- upvalues: v143 (ref), l_v1759_0 (ref), v148 (ref)
            if v1850.menu.backup ~= nil then
                local v1851 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                v1851.Hotkeys = v1850.menu.backup;
                l_v1759_0:override(v148(v1851));
                v1850.menu.backup = nil;
            end;
        end, 
        draw = function(v1852)
            -- upvalues: v263 (ref), l_ui_0 (ref), v139 (ref), v143 (ref), l_v1759_0 (ref), v148 (ref), l_v1749_0 (ref), l_v1468_1 (ref), l_v1752_0 (ref), v16 (ref)
            local v1853 = v263.Visuals.velocity_warning.main:Get() and v263.Visuals.velocity_warning.items:Get(2);
            local v1854 = nil;
            local v1855 = false;
            if v1853 then
                v1854 = l_ui_0.get_binds();
                for _, v1857 in pairs(v1854) do
                    local l_name_0 = v1857.name;
                    local l_value_0 = v1857.value;
                    if not v1852.anims.binds[l_name_0] then
                        v1852.anims.binds[l_name_0] = {
                            anim = 0, 
                            type = type(l_value_0)
                        };
                    end;
                    if v1857.active then
                        v1855 = true;
                        break;
                    end;
                end;
            end;
            local v1860 = l_ui_0.get_alpha();
            v1852.anims.global_alpha = v139(v1852.anims.global_alpha, v1853 and (not (v1860 <= 0) or v1855) and 1 or 0, 0.1);
            local l_global_alpha_1 = v1852.anims.global_alpha;
            if v1860 ~= 0 and v1853 and not v1855 then
                v1852.anims.global_alpha = v1860;
                l_global_alpha_1 = v1860;
            end;
            if not v1853 then
                v1852:reset_backup();
            end;
            if l_global_alpha_1 == 0 then
                return;
            else
                local v1862 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                if v1852.menu.backup == nil and v1853 then
                    v1852.menu.backup = v1862.Hotkeys;
                    v1862.Hotkeys = false;
                    l_v1759_0:override(v148(v1862));
                end;
                local v1863 = v1852.drag:process();
                v1852.anims.size_x = v139(v1852.anims.size_x, v1852.anims.requested_size_x, 0.075);
                v1863.size.x = v1852.anims.size_x;
                local v1864 = v263.Visuals.velocity_warning.accent:Get();
                local v1865 = color(17, 17, 17, 145);
                local _, v1867 = v1852.ui:get_colors(v1864);
                local l_position_3 = v1863.position;
                local l_size_0 = v1863.size;
                l_v1749_0.draw:field(l_position_3, l_size_0, v1864:alpha_modulate(v1864.a * l_global_alpha_1), v1865:alpha_modulate(v1865.a * l_global_alpha_1), v1867:alpha_modulate(v1867.a * l_global_alpha_1), 0, v263.Visuals.velocity_warning.rounding:get());
                render.text(1, l_position_3 + l_size_0 / 2 - vector(0, 1), color(255, 255 * l_global_alpha_1), "c", "keybinds");
                local v1870 = 27;
                v1852.anims.requested_size_x = 125;
                if not v1854 then
                    return;
                else
                    local v1871 = 0;
                    for _, v1873 in pairs(v1854) do
                        local l_name_1 = v1873.name;
                        local l_value_1 = v1873.value;
                        if not v1852.anims.binds[l_name_1] then
                            v1852.anims.binds[l_name_1] = {
                                anim = 0, 
                                type = type(l_value_1)
                            };
                        end;
                        local v1876 = v1852.anims.binds[l_name_1];
                        v1876.anim = v139(v1876.anim, v1873.active and 1 or 0, 0.1);
                        local l_anim_0 = v1876.anim;
                        local v1878 = 255 * l_global_alpha_1 * l_anim_0;
                        if v1878 ~= 0 then
                            local v1879 = nil;
                            if v1876.type == "table" then
                                v1879 = "";
                                for _, _ in pairs(l_value_1) do
                                    v1879 = l_v1468_1(l_value_1, ", ");
                                end;
                            elseif v1876.type == "boolean" then
                                v1879 = v1873.mode == 1 and "holding" or "toggled";
                            else
                                v1879 = tostring(l_value_1);
                            end;
                            v1879 = "[" .. l_v1752_0(v1879, 15) .. "]";
                            render.text(1, l_position_3 + vector(2, v1870), color(255, v1878), "", l_name_1);
                            render.text(1, l_position_3 + vector(l_size_0.x - 2, v1870), color(255, v1878), "r", v1879);
                            local v1882 = render.measure_text(1, "", l_name_1).x + render.measure_text(1, "", v1879).x + 15;
                            if v1882 > 125 and v1871 < v1882 then
                                v1852.anims.requested_size_x = v1882;
                                v1871 = v1852.anims.requested_size_x;
                            end;
                        end;
                        v1870 = v1870 + v16(15, l_anim_0);
                    end;
                    return;
                end;
            end;
        end
    }):struct("spectators")({
        drag = v685.add("spectators", vector(40 / v67.screen_size.x, v67.screen_size.y / 3 / v67.screen_size.y), vector(125, 22)), 
        menu = {}, 
        specs = {}, 
        anims = {
            requested_size_x = 125, 
            global_alpha = 0, 
            size_x = 125
        }, 
        reset_backup = function(v1883)
            -- upvalues: v143 (ref), l_v1759_0 (ref), v148 (ref)
            if v1883.menu.backup ~= nil then
                local v1884 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                v1884.Spectators = v1883.menu.backup;
                l_v1759_0:override(v148(v1884));
                v1883.menu.backup = nil;
            end;
        end, 
        update = function(v1885)
            -- upvalues: l_v1752_0 (ref), v139 (ref)
            if not globals.is_connected or not globals.is_in_game then
                v1885.specs = {};
                return {}, false;
            else
                local v1886 = false;
                local _ = true;
                local v1888 = entity.get_local_player();
                if not v1888 then
                    return;
                else
                    local v1889 = v1888:is_alive();
                    local v1890 = nil;
                    if not v1889 then
                        v1890 = v1888.m_hObserverTarget;
                    end;
                    local v1891 = 0;
                    for v1892 = 1, 65 do
                        local v1893 = v1885.specs[v1892];
                        if not v1893 then
                            v1885.specs[v1892] = {
                                animation = 0
                            };
                            v1893 = v1885.specs[v1892];
                        end;
                        local v1894 = entity.get(v1892 - 1);
                        if v1894 ~= nil and v1894:is_player() and v1894 ~= v1888 then
                            local l_m_iObserverMode_0 = v1894.m_iObserverMode;
                            local l_m_hObserverTarget_0 = v1894.m_hObserverTarget;
                            if not v1893.name then
                                v1893.name = l_v1752_0(v1894:get_name(), 16);
                            end;
                            local v1897 = l_m_iObserverMode_0 == 6 or not (l_m_hObserverTarget_0 == (v1889 and v1888 or v1890)) or v1894:is_dormant();
                            v1893.animation = v139(v1893.animation, v1897 and 0 or 1, 0.1);
                            local l_animation_0 = v1893.animation;
                            if not v1897 then
                                v1891 = v1891 + 1;
                            end;
                            if l_animation_0 > 0.01 then
                                if not v1893.avatar then
                                    v1893.avatar = v1894:get_steam_avatar();
                                end;
                                v1886 = true;
                            end;
                        end;
                    end;
                    return v1885.specs, v1891 > 0;
                end;
            end;
        end, 
        reset_specs = function(v1899)
            v1899.specs = {};
        end, 
        draw = function(v1900)
            -- upvalues: v263 (ref), l_ui_0 (ref), v139 (ref), v143 (ref), l_v1759_0 (ref), v148 (ref), l_v1749_0 (ref), v16 (ref)
            local v1901 = v263.Visuals.velocity_warning.main:Get() and v263.Visuals.velocity_warning.items:Get(3);
            local v1902 = nil;
            local v1903 = nil;
            if v1901 then
                local v1904, v1905 = v1900:update();
                v1903 = v1905;
                v1902 = v1904;
            end;
            local v1906 = l_ui_0.get_alpha();
            v1900.anims.global_alpha = v139(v1900.anims.global_alpha, v1901 and (not (v1906 <= 0) or v1903) and 1 or 0, 0.1);
            local l_global_alpha_2 = v1900.anims.global_alpha;
            if v1906 ~= 0 and v1901 and not v1903 then
                v1900.anims.global_alpha = v1906;
                l_global_alpha_2 = v1906;
            end;
            if not v1901 then
                v1900:reset_backup();
            end;
            if l_global_alpha_2 == 0 then
                return;
            else
                if not v1902 then
                    v1902 = {};
                end;
                local v1908 = v143(l_v1759_0:get_override() or l_v1759_0:get());
                if v1900.menu.backup == nil and v1901 then
                    v1900.menu.backup = v1908.Spectators;
                    v1908.Spectators = false;
                    l_v1759_0:override(v148(v1908));
                end;
                local v1909 = v1900.drag:process();
                v1900.anims.size_x = v139(v1900.anims.size_x, v1900.anims.requested_size_x, 0.075);
                v1909.size.x = v1900.anims.size_x;
                local v1910 = v263.Visuals.velocity_warning.accent:Get();
                local v1911 = color(17, 17, 17, 145);
                local _, v1913 = v1900.ui:get_colors(v1910);
                local l_position_4 = v1909.position;
                local l_size_1 = v1909.size;
                l_v1749_0.draw:field(l_position_4, l_size_1, v1910:alpha_modulate(v1910.a * l_global_alpha_2), v1911:alpha_modulate(v1911.a * l_global_alpha_2), v1913:alpha_modulate(v1913.a * l_global_alpha_2), 0, v263.Visuals.velocity_warning.rounding:get());
                render.text(1, l_position_4 + l_size_1 / 2, color(255, 255 * l_global_alpha_2), "c", "spectators");
                local v1916 = 25;
                v1900.anims.requested_size_x = 125;
                local v1917 = 125;
                for v1918 = 1, #v1902 do
                    local v1919 = v1902[v1918];
                    local l_animation_1 = v1919.animation;
                    if l_animation_1 > 0.01 then
                        local v1921 = 0;
                        local v1922 = l_animation_1 * l_global_alpha_2;
                        local v1923 = v1922 * 255;
                        if v1919.avatar then
                            render.texture(v1919.avatar, l_position_4 + vector(2, v1916), vector(12, 12), color(255, v1923), "f", 3);
                            v1921 = 18;
                        end;
                        render.text(1, l_position_4 + vector(v1921 + 2, v1916), color(255, v1923), "", v1919.name);
                        local v1924 = render.measure_text(1, "", v1919.name).x + v1921;
                        if v1924 and v1924 > 125 and v1917 < v1924 then
                            v1900.anims.requested_size_x = v1924;
                            v1917 = v1900.anims.requested_size_x;
                        end;
                        v1916 = v1916 + v16(15, v1922);
                    end;
                end;
                return;
            end;
        end
    });
    v263.Visuals.velocity_warning.elements:set_callback(function()
        -- upvalues: v1925 (ref)
        v1925.watermark.anims.new_alpha_req = 0;
        v1925.watermark.anims.global_alpha = 0.01;
        utils.execute_after(0.25, function()
            -- upvalues: v1925 (ref)
            v1925.watermark.anims.new_alpha_req = 1;
        end);
    end, true);
    v260:add("draw", "sowus", function()
        -- upvalues: v1925 (ref)
        v1925.watermark:draw();
        v1925.keybinds:draw();
        v1925.spectators:draw();
    end);
    v260:add("destroy", "sowus backups", function()
        -- upvalues: v1925 (ref)
        v1925.watermark:reset_backup();
        v1925.keybinds:reset_backup();
        v1925.spectators:reset_backup();
    end);
    v260:add("cs_game_disconnected", "sowus spectawtows", function()
        -- upvalues: v1925 (ref)
        v1925.spectators:reset_specs();
    end);
    v260:add("round_prestart", "sowus spectawtows1", function()
        -- upvalues: v1925 (ref)
        v1925.spectators:reset_specs();
    end);
end;
v1468 = nil;
v1749 = render.load_font("Calibri Bold", vector(25, 22, -1), "ad");
v1752 = {
    white = color(255, 255, 255, 200), 
    red = color(255, 0, 40, 200), 
    green = color(155, 200, 21, 200), 
    piss = color(255, 175, 70, 200), 
    plant_ok = color(255, 255, 130, 200), 
    plant_warning = color(255, 255, 135, 200), 
    gradient_in = color(0, 0, 0, 60), 
    gradient_out = color(0, 0, 0, 0)
};
v1757 = {
    gap = 41
};
do
    local l_v1749_1, l_v1752_1, l_v1757_0, l_v1758_1, l_v1759_1, l_v1760_1, l_v1761_1, l_v1762_0, l_v1763_1, l_l_cl_updaterate_0_1 = v1749, v1752, v1757, v1758, v1759, v1760, v1761, v1762, v1763, l_cl_updaterate_0;
    l_v1758_1 = function(v1936, v1937, v1938)
        -- upvalues: l_v1749_1 (ref), l_v1752_1 (ref)
        local v1939 = render.measure_text(l_v1749_1, "a", v1937);
        local l_gradient_in_0 = l_v1752_1.gradient_in;
        local l_gradient_out_0 = l_v1752_1.gradient_out;
        render.gradient(v1936 - vector(0, 5), v1936 + vector(28 + v1939.x / 2, 28), l_gradient_out_0, l_gradient_in_0, l_gradient_out_0, l_gradient_in_0);
        render.gradient(v1936 + vector(28 + v1939.x / 2, -5), v1936 + vector((28 + v1939.x / 2) * 2 - 1, 28), l_gradient_in_0, l_gradient_out_0, l_gradient_in_0, l_gradient_out_0);
        render.text(l_v1749_1, v1936 + vector(27, 3), v1938, "", v1937);
    end;
    l_v1759_1 = {
        doubletap = l_ui_0.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        hideshots = l_ui_0.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        fakeduck = l_ui_0.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        body_aim = {
            main = l_ui_0.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
            disablers = l_ui_0.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
        }, 
        safe_points = l_ui_0.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        freestanding = l_ui_0.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        fake_latency = l_ui_0.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        ragebot = l_ui_0.find("Aimbot", "Ragebot", "Main", "Enabled"), 
        dormant_aimbot = l_ui_0.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
    };
    l_v1760_1 = nil;
    l_v1760_1 = {
        hits = 0, 
        total = 0, 
        reasons = {
            ["prediction error"] = true, 
            ["unregistered shot"] = true, 
            death = true, 
            ["player death"] = true
        }
    };
    events.aim_ack:set(function(v1942)
        -- upvalues: l_v1760_1 (ref)
        if l_v1760_1.reasons[v1942.state] ~= nil then
            return;
        else
            l_v1760_1.total = l_v1760_1.total + 1;
            if not v1942.state then
                l_v1760_1.hits = l_v1760_1.hits + 1;
            end;
            return;
        end;
    end);
    l_v1761_1 = function()
        -- upvalues: l_v1760_1 (ref)
        l_v1760_1.hits = 0;
        l_v1760_1.total = 0;
    end;
    events.level_init:set(l_v1761_1);
    events.game_start:set(l_v1761_1);
    l_v1761_1 = nil;
    l_v1761_1 = {
        damage = "-0 HP", 
        icon = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(30, 30))
    };
    l_v1762_0 = function()
        -- upvalues: l_v1761_1 (ref)
        l_v1761_1.site = nil;
    end;
    events.round_start:set(l_v1762_0);
    events.bomb_planted:set(l_v1762_0);
    events.bomb_abortplant:set(l_v1762_0);
    l_v1761_1.planting_time = 3.125;
    l_v1763_1 = function(v1943, v1944)
        local v1945 = 0.5;
        local v1946 = 0.5;
        if v1944 and v1944 > 0 then
            local v1947 = v1943 * v1945;
            if v1944 < (v1943 - v1947) * v1946 then
                v1947 = v1943 - v1944 * (1 / v1946);
            end;
            v1943 = v1947;
        end;
        return v1943;
    end;
    do
        local l_l_v1763_1_0, l_l_l_cl_updaterate_0_1_0 = l_v1763_1, l_l_cl_updaterate_0_1;
        l_l_l_cl_updaterate_0_1_0 = function(v1950, v1951)
            -- upvalues: l_l_v1763_1_0 (ref)
            if not v1950 then
                return 0;
            else
                local v1952 = v1950:get_origin():dist(v1951:get_origin());
                local v1953 = 500;
                local v1954 = v1953 * 3.5;
                v1953 = v1953 * math.exp(-(v1952 * v1952 / (v1954 * 2 / 3 * (v1954 / 3))));
                return (math.floor(l_l_v1763_1_0(math.max(v1953, 0), v1950.m_ArmorValue)));
            end;
        end;
        v260:add("draw", "skit \208\183\208\176\208\191\208\187\208\181\208\189\209\135\208\181\208\189\208\176\209\143 \208\177\208\190\208\188\208\177\208\176 \208\180\208\181\209\130\208\181\208\186\209\130", function()
            -- upvalues: l_v1761_1 (ref), l_l_l_cl_updaterate_0_1_0 (ref)
            l_v1761_1.entity = nil;
            l_v1761_1.damage = "";
            entity.get_entities("CPlantedC4", true, function(v1955)
                -- upvalues: l_v1761_1 (ref)
                if not v1955.m_bBombTicking or globals.curtime > v1955.m_flC4Blow then
                    return;
                else
                    l_v1761_1.entity = v1955;
                    return;
                end;
            end);
            local v1956 = entity.get_local_player();
            if not l_v1761_1.entity or not v1956 then
                return;
            else
                local l_m_iObserverMode_1 = v1956.m_iObserverMode;
                if l_m_iObserverMode_1 == 6 or l_m_iObserverMode_1 == 1 or l_m_iObserverMode_1 == 2 then
                    return;
                else
                    local v1958 = v1956.m_hObserverTarget or v1956;
                    local v1959 = l_l_l_cl_updaterate_0_1_0(v1958, l_v1761_1.entity);
                    l_v1761_1.damage = v1958.m_iHealth <= v1959 and "FATAL" or string.format("-%d HP", v1959);
                    return;
                end;
            end;
        end);
        v260:add("bomb_beginplant", "skit bomba", function(v1960)
            -- upvalues: l_v1761_1 (ref)
            local v1961 = entity.get(v1960.site);
            if not v1961 then
                return;
            else
                local v1962 = ffi.cast("uintptr_t", v1961[0]) + 340;
                l_v1761_1.site = ffi.cast("char*", v1962)[0] == 65 and "A" or "B";
                l_v1761_1.planting_started = globals.curtime;
                return;
            end;
        end);
    end;
    l_v1762_0 = {
        [1] = {
            menu = "Bomb Info", 
            condition = function()
                -- upvalues: l_v1761_1 (ref)
                return l_v1761_1.site ~= nil and entity.get_game_rules() ~= nil;
            end, 
            get_text = function()
                -- upvalues: l_v1761_1 (ref)
                return "       " .. l_v1761_1.site .. "        ";
            end, 
            additional_render = function(v1963)
                -- upvalues: l_v1761_1 (ref), l_v1752_1 (ref)
                local v1964 = (globals.curtime - l_v1761_1.planting_started) / l_v1761_1.planting_time;
                render.circle_outline(v1963 + vector(97, 13), color(0, 0, 0, 100), 10, 0, 1, 4);
                render.circle_outline(v1963 + vector(97, 13), color(), 9, 0, v1964, 2.5);
                render.texture(l_v1761_1.icon, v1963 + vector(27, -3), nil, l_v1752_1.plant_ok);
            end, 
            col = function()
                -- upvalues: l_v1761_1 (ref), l_v1752_1 (ref)
                local v1965 = entity.get_game_rules();
                return l_v1761_1.planting_started + l_v1761_1.planting_time < v1965.m_fRoundStartTime + v1965.m_iRoundTime and l_v1752_1.plant_warning or l_v1752_1.plant_ok;
            end
        }, 
        [2] = {
            menu = "Bomb Info", 
            get_text = function()
                -- upvalues: l_v1761_1 (ref)
                return l_v1761_1.damage;
            end, 
            col = function()
                -- upvalues: l_v1761_1 (ref), l_v1752_1 (ref)
                return l_v1761_1.damage == "FATAL" and l_v1752_1.red or l_v1752_1.plant_ok;
            end, 
            condition = function()
                -- upvalues: l_v1761_1 (ref)
                return l_v1761_1.entity ~= nil and l_v1761_1.damage ~= "-0 HP";
            end
        }, 
        [3] = {
            menu = "Bomb Info", 
            get_text = function()
                -- upvalues: l_v1761_1 (ref)
                local _ = "";
                local l_entity_1 = l_v1761_1.entity;
                return "        " .. (l_entity_1.m_nBombSite == 0 and "A" or "B") .. string.format(" - %.1fs", l_entity_1.m_flC4Blow - globals.curtime);
            end, 
            additional_render = function(v1968)
                -- upvalues: l_v1761_1 (ref), l_v1752_1 (ref)
                render.texture(l_v1761_1.icon, v1968 + vector(27, -3), nil, l_v1752_1.white);
            end, 
            condition = function()
                -- upvalues: l_v1761_1 (ref)
                return l_v1761_1.entity ~= nil;
            end
        }, 
        [4] = {
            menu = "Freestanding", 
            text = "FS", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.freestanding:get();
            end
        }, 
        [5] = {
            menu = "Min. Damage", 
            text = "MD", 
            condition = function()
                -- upvalues: l_ui_0 (ref)
                for _, v1970 in ipairs(l_ui_0.get_binds()) do
                    if v1970.name == "Min. Damage" and v1970.active then
                        return true;
                    end;
                end;
                return false;
            end
        }, 
        [6] = {
            menu = "Force Body Aim", 
            text = "BODY", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.body_aim.main:get() == "Force" and #l_v1759_1.body_aim.disablers:get() == 0;
            end
        }, 
        [7] = {
            menu = "Force Safe Point", 
            text = "SAFE", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.safe_points:get() == "Force";
            end
        }, 
        [8] = {
            menu = "Fake Duck", 
            text = "DUCK", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.fakeduck:get();
            end
        }, 
        [9] = {
            menu = "Dormant Aimbot", 
            text = "DA", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.ragebot:get() and l_v1759_1.dormant_aimbot:get();
            end
        }, 
        [10] = {
            menu = "Double Tap", 
            text = "DT", 
            col = function()
                -- upvalues: l_v1752_1 (ref)
                return rage.exploit:get() == 1 and l_v1752_1.white or l_v1752_1.red;
            end, 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return not l_v1759_1.fakeduck:get() and l_v1759_1.doubletap:get();
            end
        }, 
        [11] = {
            menu = "Hide Shots", 
            text = "OSAA", 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return not l_v1759_1.fakeduck:get() and not l_v1759_1.doubletap:get() and l_v1759_1.hideshots:get();
            end
        }, 
        [12] = {
            menu = "Fake Latency", 
            text = "PING", 
            col = function(_)
                -- upvalues: l_v1752_1 (ref), l_v1759_1 (ref)
                local v1972 = utils.net_channel();
                if not v1972 then
                    return l_v1752_1.green;
                else
                    local v1973 = math.min(200, v1972.latency[0] * 1000 - 15);
                    local v1974 = l_v1759_1.fake_latency:get();
                    local v1975 = math.min(v1973, v1974) / math.max(v1973, v1974);
                    if v1975 > 1 then
                        v1975 = 1;
                    end;
                    return v1975 > 0.5 and l_v1752_1.piss:lerp(l_v1752_1.green, (v1975 - 0.5) * 2) or l_v1752_1.white:lerp(l_v1752_1.piss, v1975);
                end;
            end, 
            condition = function()
                -- upvalues: l_v1759_1 (ref)
                return l_v1759_1.fake_latency:get() ~= 0;
            end
        }, 
        [13] = {
            menu = "Aimbot Stats", 
            get_text = function()
                -- upvalues: l_v1760_1 (ref)
                local v1976 = l_v1760_1.total ~= 0 and l_v1760_1.hits / l_v1760_1.total * 100 or 100;
                return string.format("%s%d%%", v1976 < 50 and "\240\159\164\172 " or "", v1976);
            end
        }
    };
    l_v1763_1 = {};
    l_l_cl_updaterate_0_1 = render.screen_size();
    v260:add("draw", "skeet indiki", function()
        -- upvalues: v179 (ref), v143 (ref), v263 (ref), l_l_cl_updaterate_0_1 (ref), l_v1762_0 (ref), l_v1752_1 (ref), l_v1757_0 (ref), l_v1758_1 (ref), l_v1763_1 (ref), l_v1761_1 (ref)
        if not v179.skeet_indicators.main then
            return;
        else
            local v1977 = v143(v263.Visuals.skeet_indicators.items:get());
            local v1978 = entity.get_local_player();
            if not v1978 or not v1978:is_alive() then
                return;
            else
                local v1979 = vector(0, l_l_cl_updaterate_0_1.y - 345);
                local v1980 = 0;
                local v1981 = #l_v1762_0;
                for v1982 = 0, v1981 - 1 do
                    local v1983 = l_v1762_0[v1981 - v1982];
                    if v1977[v1983.menu] and (not v1983.condition or v1983.condition(v1978)) then
                        local v1984 = v1983.col and v1983.col(v1978) or l_v1752_1.white;
                        local v1985 = v1983.text or v1983.get_text();
                        local v1986 = v1979 - vector(0, v1980 * l_v1757_0.gap);
                        l_v1758_1(v1986, l_v1763_1[v1985] or v1985, v1984);
                        if v1983.additional_render then
                            v1983.additional_render(v1986);
                        end;
                        v1980 = v1980 + 1;
                    end;
                end;
                if not l_v1761_1.entity or not v263.Visuals.skeet_indicators.items:get("Bomb Info") then
                    return;
                else
                    local l_m_hBombDefuser_0 = l_v1761_1.entity.m_hBombDefuser;
                    local _ = l_v1761_1.entity.m_flDefuseLength;
                    local v1989 = l_m_hBombDefuser_0 and (l_v1761_1.entity.m_flDefuseCountDown - globals.curtime) * 10 / 10 or -1;
                    local v1990 = l_v1761_1.entity.m_flC4Blow - globals.curtime;
                    if v1989 > 0 then
                        render.rect(vector(), vector(16, l_l_cl_updaterate_0_1.y), color(25, 25, 25, 160));
                        render.rect_outline(vector(), vector(16, l_l_cl_updaterate_0_1.y), color(25, 25, 25, 160));
                        render.rect(vector(0, l_l_cl_updaterate_0_1.y - (l_l_cl_updaterate_0_1.y - 50) / 10 * v1989), vector(16, l_l_cl_updaterate_0_1.y), v1989 < v1990 and color(58, 191, 54, 160) or color(255, 0, 0, 125));
                    end;
                    return;
                end;
            end;
        end;
    end);
end;
(function()
    -- upvalues: v260 (ref), v178 (ref), v263 (ref)
    v260:add("prediction", "very fast ladder", function(v1991, v1992, v1993)
        -- upvalues: v178 (ref), v263 (ref)
        if not v1993 or not v178.antiaim or not v263.AntiAim.tweaks:Get(6) then
            return;
        else
            local v1994 = v1992:get_player_weapon();
            if not v1994 then
                return;
            else
                local v1995 = true;
                if not v1994.m_bPinPulled then
                    v1995 = v1994.m_fThrowTime == nil or v1994.m_fThrowTime == 0;
                end;
                if v1992.m_MoveType == 9 and v1995 then
                    if v1991.sidemove == 0 then
                        v1991.view_angles.y = v1991.view_angles.y + 45;
                    end;
                    if v1991.in_forward then
                        if v1991.sidemove > 0 then
                            v1991.view_angles.y = v1991.view_angles.y - 1;
                        end;
                        if v1991.sidemove < 0 then
                            v1991.view_angles.y = v1991.view_angles.y + 90;
                        end;
                        v1991.in_moveleft = 0;
                        v1991.in_moveright = 1;
                    end;
                    if v1991.in_back then
                        if v1991.sidemove < 0 then
                            v1991.view_angles.y = v1991.view_angles.y - 1;
                        end;
                        if v1991.sidemove > 0 then
                            v1991.view_angles.y = v1991.view_angles.y + 90;
                        end;
                        v1991.in_moveleft = 1;
                        v1991.in_moveright = 0;
                    end;
                end;
                return;
            end;
        end;
    end);
end)();
(function()
    -- upvalues: v260 (ref), v178 (ref), v263 (ref)
    v260:add("prediction", "\208\186\209\128\208\184\209\130\208\188\209\131\208\178", function(v1996, v1997, v1998)
        -- upvalues: v178 (ref), v263 (ref)
        if not v1998 or not v178.antiaim or not v263.AntiAim.tweaks:Get(7) then
            return;
        else
            local v1999 = v1997:get_origin();
            local v2000 = utils.trace_line(v1999, vector(v1999.x, v1999.y, v1999.z - 500), nil, nil, 1);
            if v1999.z - v2000.end_pos.z <= 70 and v1999.z - v2000.end_pos.z >= 12 and bit.band(v1997.m_fFlags, 1) == 0 and v1997.m_vecVelocity.z < -450 then
                v1996.in_duck = true;
            end;
            return;
        end;
    end);
end)();
(function()
    -- upvalues: l_ui_0 (ref), v260 (ref), v178 (ref), v263 (ref), v67 (ref), v673 (ref)
    local v2001 = l_ui_0.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options");
    local v2002 = false;
    local function v2003()
        -- upvalues: v2002 (ref), v2001 (ref)
        if v2002 then
            v2001:override();
            v2002 = false;
        end;
    end;
    v260:add("prediction", "\208\186\209\128\208\184\209\130\208\188\209\131\208\178 v2", function(_, _, v2006)
        -- upvalues: v178 (ref), v263 (ref), v2003 (ref), v67 (ref), v673 (ref), v2001 (ref), v2002 (ref)
        if not v2006 or not v178.antiaim or not v263.AntiAim.tweaks:Get(8) then
            return v2003();
        elseif v263.AntiAim.defensive_aa.main:get() and rage.exploit:get() == 1 and not v67.functions.on_use_aa and not v67.functions.edge_yaw then
            return v2003();
        else
            if v673 < 3 then
                v2001:override("Always On");
                v2002 = true;
            else
                v2003();
            end;
            return;
        end;
    end);
end)();
(function()
    -- upvalues: l_ui_0 (ref), v260 (ref), v263 (ref), v673 (ref)
    local v2007 = {
        [267] = true, 
        [242] = true, 
        [261] = true, 
        [233] = true
    };
    local v2008 = l_ui_0.find("Aimbot", "Ragebot", "Selection", "Hit Chance");
    local v2009 = l_ui_0.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope");
    local v2010 = false;
    local function v2011()
        -- upvalues: v2010 (ref), v2008 (ref), v2009 (ref)
        if v2010 then
            v2010 = false;
            v2008:override();
            v2009:override();
        end;
    end;
    local _ = {
        Scout = 267, 
        AWP = 233
    };
    v260:add("prediction", "very fast hitchance", function(_, v2014, v2015)
        -- upvalues: v263 (ref), v2011 (ref), v2007 (ref), v673 (ref), v2008 (ref), v2010 (ref), v2009 (ref)
        if not v2015 or not v263.Ragebot.hitchance.main:get() then
            return v2011();
        else
            local v2016 = v2014:get_player_weapon();
            if v2016 == nil then
                return v2011();
            else
                local v2017 = v2016:get_classid();
                if not v2007[v2017] then
                    return v2011();
                else
                    local v2018 = false;
                    local v2019 = false;
                    if v2017 == 261 or v2017 == 242 then
                        v2018 = v263.Ragebot.hitchance.weapons_ns:get("Auto");
                        v2019 = v263.Ragebot.hitchance.weapons_ia:get("Auto");
                    elseif v2017 == 233 then
                        v2018 = v263.Ragebot.hitchance.weapons_ns:get("AWP");
                        v2019 = v263.Ragebot.hitchance.weapons_ia:get("AWP");
                    elseif v2017 == 267 then
                        v2018 = v263.Ragebot.hitchance.weapons_ns:get("Scout");
                        v2019 = v263.Ragebot.hitchance.weapons_ia:get("Scout");
                    end;
                    if not v2018 and not v2019 then
                        return v2011();
                    else
                        if v263.Ragebot.hitchance.mode:get(2) and v673 < 3 and v2019 then
                            v2008:override(v263.Ragebot.hitchance.air:get());
                            v2010 = true;
                        else
                            v2008:override();
                            v2009:override();
                        end;
                        if v263.Ragebot.hitchance.mode:get(1) and v2014.m_bIsScoped == false and v2018 then
                            local v2020 = entity.get_threat();
                            if v2020 then
                                if v2020:get_origin():dist(v2014:get_origin()) / 5 > v263.Ragebot.hitchance.distance:get() then
                                    return v2011();
                                else
                                    v2010 = true;
                                    v2008:override(v263.Ragebot.hitchance.noscope:get());
                                    v2009:override(false);
                                end;
                            end;
                        end;
                        v2010 = true;
                        return;
                    end;
                end;
            end;
        end;
    end);
end)();
v1759 = nil;
v1760 = ffi.cast("uintptr_t**", utils.opcode_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1));
v1761 = ffi.typeof("        struct {\n            int64_t         unknown;\n            int64_t         steamID64;\n            char            szName[128];\n            int             userId;\n            char            szSteamID[20];\n            char            pad_0x00A8[0x10];\n            unsigned long   iSteamID;\n            char            szFriendsName[128];\n            bool            fakeplayer;\n            bool            ishltv;\n            unsigned int    customfiles[4];\n            unsigned char   filesdownloaded;\n        }\n    ");
v1762 = utils.get_vfunc(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", v1761));
v1763 = nil;
do
    local l_v1760_2, l_v1762_1, l_v1763_2, l_l_cl_updaterate_0_2, l_v1765_1, l_v1766_2, l_v1767_2 = v1760, v1762, v1763, l_cl_updaterate_0, v1765, v1766, v1767;
    l_l_cl_updaterate_0_2 = function(v2028)
        -- upvalues: l_v1760_2 (ref), l_v1762_1 (ref), l_v1763_2 (ref)
        local v2029 = entity.get_local_player();
        if not v2029 then
            return;
        else
            local v2030 = l_v1760_2[0][0];
            if not v2030 then
                return;
            else
                local v2031 = ffi.cast("void***", v2030 + 21184)[0];
                if not v2031 then
                    return;
                else
                    local v2032 = l_v1762_1(v2031, v2029:get_index() - 1, nil);
                    if not v2032 then
                        return;
                    else
                        local v2033 = ffi.string(v2032[0].szName);
                        if v2028 ~= v2033 and l_v1763_2 == nil then
                            l_v1763_2 = v2033;
                        end;
                        v2032[0].szName = ffi.new("char[128]", v2028);
                        return;
                    end;
                end;
            end;
        end;
    end;
    l_v1765_1 = v263.Modifications.clientside_nickname;
    l_v1766_2 = false;
    l_v1767_2 = function()
        -- upvalues: l_v1765_1 (ref), l_v1766_2 (ref), l_l_cl_updaterate_0_2 (ref), l_v1763_2 (ref)
        local v2034 = l_v1765_1.nick:get():sub(0, 32);
        l_v1765_1.nick:set(v2034);
        if not l_v1765_1.main:get() or #v2034 == 0 then
            if l_v1766_2 then
                l_v1766_2 = false;
                l_l_cl_updaterate_0_2(l_v1763_2 or panorama.MyPersonaAPI.GetName());
                l_v1763_2 = nil;
            end;
            return;
        else
            l_v1766_2 = true;
            l_l_cl_updaterate_0_2(v2034);
            return;
        end;
    end;
    l_v1765_1.main:RegisterCallback(l_v1767_2);
    l_v1765_1.nick:RegisterCallback(l_v1767_2);
    v260:add("round_prestart", "hanle name prestart", l_v1767_2);
    v260:add("player_connect_full", "hanle name connect", function(v2035, v2036)
        -- upvalues: v684 (ref), l_v1767_2 (ref)
        local v2037 = v684.GetPlayerForUserID(v2035.userid);
        if not v2037 then
            return;
        else
            if v2037 == v2036 then
                l_v1767_2();
            end;
            return;
        end;
    end);
    l_v1767_2();
    v260:add("destroy", "handle destroy name", function()
        -- upvalues: l_l_cl_updaterate_0_2 (ref)
        l_l_cl_updaterate_0_2(panorama.MyPersonaAPI.GetName());
    end);
end;
v1760 = nil;
v1760 = {};
v1761 = ffi.typeof("        struct {\n            char pad[92];\n            unsigned char min[4];\n            unsigned char max[4];\n            unsigned char colmin[4];\n            unsigned char colmax[4];\n            unsigned char tintmin[4];\n            unsigned char tintmax[4];\n        }\n    ");
v1762 = ffi.typeof("        struct {\n            char pad_0[0x16C];\n            $** data;\n            char pad_1[0x8];\n            int size;\n        }*\n    ", v1761);
v1763 = ffi.typeof("        struct {\n            float* base[24];\n            size_t size[24];\n        }\n    ");
l_cl_updaterate_0 = ffi.typeof("        struct {\n            char* buffer;\n            int capacity;\n            int grow_size;\n            int length;\n        }\n    ");
v1765 = ffi.typeof("        struct {\n            char pad_0[0x134];\n            $ name;\n        }\n    ", l_cl_updaterate_0);
v1766 = ffi.typeof("        struct {\n            void* prev;\n            void* next;\n\n            $* object;\n        }*\n    ", v1765);
v1767 = ffi.typeof("        struct {\n            char pad_0[0x30]; \n            int active_particles; // 48\n            char pad_1[0xC];\n            $ definition; // 64\n            char pad_2[0x4];\n            $ initializers; // 72\n            char pad_2[0x40];\n            int* parent;\n            char pad_3[0x50];\n            $ attributes;\n        }*\n    ", v1766, v1762, v1763);
v1768 = v37.rel_jmp("client.dll", "E8 ? ? ? ? C7 43 ? ? ? ? ? 8D BB ? ? ? ?");
local v2038 = v37.rel_jmp("client.dll", "E8 ? ? ? ? 85 F6 74 14");
local v2039 = {};
do
    local l_v1766_3, l_v1767_3, l_v2039_0 = v1766, v1767, v2039;
    v37.set("molotov 1", v1768, "void*(__fastcall*)(void*, void*)", function(v2043, v2044, v2045)
        -- upvalues: l_v2039_0 (ref)
        local v2046 = v2043(v2044, v2045);
        table.insert(l_v2039_0, ffi.cast("int*", v2046));
        return v2046;
    end);
    local v2047 = false;
    v37.set("molotov 2", v2038, "void(__fastcall*)(void*, void*)", function(v2048, v2049, v2050)
        -- upvalues: v2047 (ref), l_v2039_0 (ref)
        v2047 = true;
        for v2051, v2052 in ipairs(l_v2039_0) do
            if ffi.cast("int", v2052) == ffi.cast("int", v2049) then
                table.remove(l_v2039_0, v2051);
                break;
            end;
        end;
        v2048(v2049, v2050);
        v2047 = false;
    end);
    local function v2057(v2053, v2054, v2055)
        local v2056 = math.floor(v2055 / 4);
        return v2053.base[v2054] + v2053.size[v2054] * v2056 + bit.band(v2055, 3);
    end;
    local v2058 = {
        explosion_molotov_air = true, 
        molotov_explosion = true, 
        molotov_groundfire_fallback2 = true, 
        molotov_groundfire_fallback = true, 
        molotov_groundfire_00HIGH = true, 
        molotov_groundfire_00MEDIUM = true, 
        molotov_groundfire = true, 
        env_fire_tiny_b = true, 
        incgrenade_thrown_trail = true, 
        weapon_molotov_thrown = true, 
        weapon_molotov_fp = true, 
        weapon_molotov_held = true, 
        extinguish_fire = true
    };
    local v2059 = {
        explosion_molotov_air_smoke = true, 
        extinguish_fire_swirl_smoke = true, 
        molotov_smoking_ground_child03_cheapo = true, 
        molotov_smoking_ground_child03 = true, 
        molotov_smoking_ground_child02_cheapo = true, 
        molotov_smoking_ground_child02 = true, 
        molotov_smoking_ground_child01 = true
    };
    local _ = {
        molotov_groundfire_child_base = true, 
        molotov_groundfire_child_base8 = true
    };
    local function v2076(v2061, v2062)
        -- upvalues: l_v1767_3 (ref), l_v1766_3 (ref), v2058 (ref), v2059 (ref), v2057 (ref)
        local v2063 = ffi.cast(l_v1767_3, v2061);
        if v2063.active_particles == 0 then
            return;
        else
            local v2064 = ffi.cast(l_v1766_3, v2061[0] + 64);
            local v2065 = ffi.cast(l_v1766_3, v2061[0] + 64);
            local v2066 = ffi.cast("int*", v2061[0] + 136);
            while v2066[0] ~= 0 do
                v2064 = ffi.cast(l_v1766_3, v2066[0] + 64);
                v2066 = ffi.cast("int*", v2066[0] + 136);
            end;
            local v2067 = ffi.string(v2064.object.name.buffer);
            local v2068 = ffi.string(v2065.object.name.buffer);
            if v2058[v2067] == nil then
                return;
            elseif v2059[v2068] ~= nil then
                return;
            else
                local v2069 = #v2062;
                for v2070 = 0, v2063.initializers.size - 1 do
                    local v2071 = v2063.initializers.data[v2070][0];
                    if v2071 and v2071.colmin[0] ~= 0 then
                        local v2072 = v2062[v2070 % v2069 + 1];
                        v2071.min[0] = v2072.r;
                        v2071.min[1] = v2072.g;
                        v2071.min[2] = v2072.b;
                        v2071.max[0] = v2072.r;
                        v2071.max[1] = v2072.g;
                        v2071.max[2] = v2072.b;
                    end;
                end;
                for v2073 = 0, v2063.active_particles - 1 do
                    local v2074 = v2057(v2063.attributes, 6, v2073);
                    local v2075 = v2062[v2073 % v2069 + 1];
                    v2074[0] = v2075.r;
                    v2074[4] = v2075.g;
                    v2074[8] = v2075.b;
                end;
                return;
            end;
        end;
    end;
    local l_fire_color_0 = v263.Modifications.fire_color;
    local v2078 = {
        [1] = l_fire_color_0.color1, 
        [2] = l_fire_color_0.color2, 
        [3] = l_fire_color_0.color3, 
        [4] = l_fire_color_0.color4
    };
    l_fire_color_0.secret_slider:visibility(false);
    local function v2081()
        -- upvalues: l_fire_color_0 (ref), v2078 (ref)
        local v2079 = l_fire_color_0.secret_slider:get();
        for v2080 = 1, 4 do
            v2078[v2080]:visibility(v2080 <= v2079 and l_fire_color_0.main:get());
        end;
        l_fire_color_0.add_btn:disabled(v2079 == 4);
        l_fire_color_0.remove_btn:disabled(v2079 == 1);
    end;
    l_fire_color_0.main:set_callback(function()
        -- upvalues: l_fire_color_0 (ref), v2081 (ref)
        local v2082 = l_fire_color_0.main:get();
        l_fire_color_0.add_btn:visibility(v2082);
        l_fire_color_0.remove_btn:visibility(v2082);
        v2081();
    end, true);
    l_fire_color_0.add_btn:set_callback(function()
        -- upvalues: l_fire_color_0 (ref), v2081 (ref)
        l_fire_color_0.secret_slider:set(math.min(4, l_fire_color_0.secret_slider:get() + 1));
        v2081();
    end);
    l_fire_color_0.remove_btn:set_callback(function()
        -- upvalues: l_fire_color_0 (ref), v2081 (ref)
        l_fire_color_0.secret_slider:set(math.max(1, l_fire_color_0.secret_slider:get() - 1));
        v2081();
    end);
    v2081();
    local v2083 = nil;
    v2083 = materials.get_materials("flare", true);
    for _, v2085 in ipairs({
        [1] = "particle/fire_explosion_1/fire_explosion_1_oriented", 
        [2] = "particle/fire_explosion_1/fire_explosion_1_bright"
    }) do
        v2083[#v2083 + 1] = materials.get(v2085, true);
    end;
    local function v2089(v2086)
        -- upvalues: v2083 (ref)
        for _, v2088 in ipairs(v2083) do
            v2088:var_flag(2, v2086);
        end;
    end;
    v2089(true);
    v1760.on_render = function()
        -- upvalues: l_fire_color_0 (ref), v2047 (ref), v2089 (ref), v2078 (ref), l_v2039_0 (ref), v2076 (ref)
        if not l_fire_color_0.main:get() then
            return;
        elseif v2047 then
            return;
        else
            v2089(true);
            local v2090 = {};
            for v2091 = 1, l_fire_color_0.secret_slider:get() do
                local v2092 = v2078[v2091]:get();
                v2090[v2091] = {
                    r = v2092.r / 255, 
                    g = v2092.g / 255, 
                    b = v2092.b / 255
                };
            end;
            for v2093, v2094 in ipairs(l_v2039_0) do
                if v2094[0] < 10000 then
                    table.remove(l_v2039_0, v2093);
                    break;
                else
                    v2076(v2094, v2090);
                end;
            end;
            return;
        end;
    end;
    v1760.on_shutdown = function()
        -- upvalues: v2089 (ref)
        v2089(false);
    end;
    v260:add("destroy", "molotov destroy", v1760.on_shutdown);
    v260:add("post_render", "molotov render", v1760.on_render);
end;
v1761 = nil;
v260:add("prediction", "nade throw fix", function(_, v2096)
    -- upvalues: v263 (ref)
    if not v263.Ragebot.nade_throw_fix:get() or not v2096 then
        return;
    else
        local v2097 = v2096:get_player_weapon();
        if not v2097 then
            return;
        elseif v2097:get_weapon_info().weapon_type ~= 9 then
            return;
        else
            rage.exploit:allow_defensive(false);
            return;
        end;
    end;
end);
v1762 = function()
    -- upvalues: v260 (ref)
    table.foreach(v260.shutdowns, function(_, v2099)
        v2099();
    end);
end;
v1763 = false;
do
    local l_v1762_2, l_v1763_3, l_l_cl_updaterate_0_3 = v1762, v1763, l_cl_updaterate_0;
    cvar.exit:set_callback(function()
        -- upvalues: l_v1763_3 (ref), l_v1762_2 (ref)
        if not l_v1763_3 then
            l_v1762_2();
            l_v1763_3 = true;
            utils.execute_after(0.5, function()
                utils.console_exec("exit");
            end);
            return false;
        else
            return;
        end;
    end);
    l_l_cl_updaterate_0_3 = false;
    cvar.quit:set_callback(function()
        -- upvalues: l_l_cl_updaterate_0_3 (ref), l_v1762_2 (ref)
        if not l_l_cl_updaterate_0_3 then
            l_v1762_2();
            l_l_cl_updaterate_0_3 = true;
            utils.execute_after(0.5, function()
                utils.console_exec("quit");
            end);
            return false;
        else
            return;
        end;
    end);
end;
v1762 = 0;
v1763 = color();
l_cl_updaterate_0 = {
    [1] = "\240\159\152\142", 
    [2] = "\240\159\152\141", 
    [3] = "\240\159\152\137", 
    [4] = "\240\159\153\131", 
    [5] = "\240\159\152\137", 
    [6] = "\240\159\165\176", 
    [7] = "\240\159\153\131", 
    [8] = "\240\159\152\137", 
    [9] = "\240\159\164\169", 
    [10] = "\240\159\152\152", 
    [11] = "\240\159\152\139", 
    [12] = "\240\159\164\170", 
    [13] = "\240\159\152\156", 
    [14] = "\240\159\152\155", 
    [15] = "\240\159\164\160"
};
v1765 = l_cl_updaterate_0[globals.tickcount % #l_cl_updaterate_0 + 1];
v1766 = nil;
v1767 = nil;
v1768 = render.get_scale(1);
v2038 = {
    [1] = 19, 
    [2] = 16, 
    [0.75] = 15, 
    [1.25] = 18, 
    [1.5] = 17, 
    [1.75] = 16
};
l_ui_0.sidebar("\208\176\209\129\208\184\208\180\208\186\208\176", "\240\159\167\172");
v2039 = false;
events.render:set(function()
    -- upvalues: l_ui_0 (ref), v2039 (ref), v1467 (ref), v1766 (ref), v1767 (ref), v1768 (ref), v479 (ref), v1763 (ref), v2038 (ref), v263 (ref), v488 (ref), v67 (ref)
    if l_ui_0.get_alpha() == 0 and not v2039 then
        return;
    else
        v2039 = true;
        local v2103 = l_ui_0.get_style("Link Active");
        local v2104 = l_ui_0.get_style("Sidebar Text");
        local v2105 = l_ui_0.get_style("Active Text");
        local v2106 = "AcidTech V4 ";
        local v2107 = nil;
        local v2108 = #v2106 + 1;
        local v2109 = "";
        local v2110 = nil;
        for v2111 = 1, v2108 do
            local v2112 = v2106:sub(v2111, v2111);
            local v2113 = (v2111 - 1) / v2108;
            local v2114 = v2103:lerp(v2105, (v1467(v2113 * 0.8, 0.8)));
            if v2111 == 1 then
                v2110 = v2114;
            end;
            v2109 = v2109 .. string.format("\a%s%s", v2114:to_hex(), v2112);
        end;
        l_ui_0.sidebar(v2109, "\240\159\167\172");
        v2106 = render.get_scale(1);
        if v2103 ~= v1766 or v2105 ~= v1767 or v2106 ~= v1768 then
            v479 = v2103;
            v1763 = v2104;
            v1766 = v2103;
            v1767 = v2105;
            v1768 = v2106;
            v2107 = string.rep(" ", v2038[v2106] or 1);
            v2108 = " \a" .. v479:to_hex();
            v2109 = "\a" .. v479:to_hex();
            v2110 = "\a" .. v1763:to_hex();
            v263.Configs.export_cfg:name(v2108 .. l_ui_0.get_icon("file-export") .. v2110 .. "  Export ");
            v263.Configs.import_cfg:name(v2108 .. l_ui_0.get_icon("file-import") .. v2110 .. "  Import ");
            v263.Configs.def_cfg:name(v2108 .. l_ui_0.get_icon("circle-check") .. v2110 .. "  Default ");
            v263.AntiAim.preset_export:name(v2109 .. l_ui_0.get_icon("file-export"));
            v263.AntiAim.preset_import:name(v2109 .. l_ui_0.get_icon("file-import"));
            v263.AntiAim.preset_save:name(v2109 .. l_ui_0.get_icon("floppy-disk"));
            v263.AntiAim.preset_load:name(v2107 .. "Load" .. v2107);
            v263.AntiAim.preset_delete:name(v2109 .. l_ui_0.get_icon("trash-can"));
            v263.Global.discord:name(v2108 .. l_ui_0.get_icon("link") .. v2110 .. "  Get Role  ");
            v263.Global.discord1:name(v2108 .. l_ui_0.get_icon("discord") .. v2110 .. "  Join Discord Server ");
            v263.Global.tedasxt0ds13:name(v2108 .. l_ui_0.get_icon("telegram") .. v2110 .. "  Telegram  ");
            v263.Global.tedrwrwrasxt0ds13:name(v2108 .. l_ui_0.get_icon("youtube") .. v2110 .. "  Youtube ");
            v263.AntiAim.automatic_channel_kitty:name(v2108 .. l_ui_0.get_icon("youtube") .. v2110 .. "  Youtube ");
            v263.Global.tedrwrwrasxt0ds14:name(v2108 .. l_ui_0.get_icon("cart-shopping") .. v2110 .. "  NL Config ");
            v263.Global.text0ds13:name(v2108 .. l_ui_0.get_icon("cart-plus") .. v2110 .. "  AT Beta  ");
            v263.AntiAim.automatic_text_kitty:name(string.format("\a%sCredits: \a%s", v2105:to_hex(), v488(v2103, v2105, "badcode")));
            v263.Global.text0:name(string.format("\a%s%s  Welcome back, \a%s", v2105:to_hex(), l_ui_0.get_icon("hand-wave"), v488(v2103, v2105, v67.username)));
            v263.Global.text1:name(string.format("\a%s%s  Last Update: \a%s", v2105:to_hex(), l_ui_0.get_icon("clock"), v488(v2103, v2105, v67.update_date)));
            v263.Global.text2:name(string.format("\a%s%s  Current Version: \a%s", v2105:to_hex(), l_ui_0.get_icon("tag"), v488(v2103, v2105, v67.build1)));
        end;
        return;
    end;
end);