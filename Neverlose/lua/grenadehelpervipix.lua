local v0 = false;
local l_camera_position_0 = render.camera_position;
local l_camera_angles_0 = render.camera_angles;
local l_measure_text_0 = render.measure_text;
local l_rect_outline_0 = render.rect_outline;
local l_rect_0 = render.rect;
local l_texture_0 = render.texture;
local l_push_clip_rect_0 = render.push_clip_rect;
local l_pop_clip_rect_0 = render.pop_clip_rect;
local l_circle_outline_0 = render.circle_outline;
local l_circle_0 = render.circle;
local l_text_0 = render.text;
local l_sub_0 = string.sub;
local l_gsub_0 = string.gsub;
local l_format_0 = string.format;
local l_find_0 = string.find;
local l_lower_0 = string.lower;
local l_upper_0 = string.upper;
local l_byte_0 = string.byte;
local l_char_0 = string.char;
local l_rep_0 = string.rep;
local l_gmatch_0 = string.gmatch;
local l_sin_0 = math.sin;
local l_cos_0 = math.cos;
local l_pow_0 = math.pow;
local l_atan2_0 = math.atan2;
local l_abs_0 = math.abs;
local l_min_0 = math.min;
local l_max_0 = math.max;
local l_floor_0 = math.floor;
local l_clamp_0 = math.clamp;
local l_normalize_yaw_0 = math.normalize_yaw;
local l_pi_0 = math.pi;
local l_tostring_0 = tostring;
local _ = tonumber;
local l_next_0 = next;
local l_type_0 = type;
local l_pcall_0 = pcall;
local l_error_0 = error;
local l_select_0 = select;
local l_unpack_0 = unpack;
local l_setmetatable_0 = setmetatable;
local l_band_0 = bit.band;
local l_bnot_0 = bit.bnot;
local l_bxor_0 = bit.bxor;
local l_rshift_0 = bit.rshift;
local l_lshift_0 = bit.lshift;
local l_bor_0 = bit.bor;
local l_get_map_data_0 = common.get_map_data;
local l_add_notify_0 = common.add_notify;
local l_get_timestamp_0 = common.get_timestamp;
local l_execute_after_0 = utils.execute_after;
local l_console_exec_0 = utils.console_exec;
local l_trace_line_0 = utils.trace_line;
local l_remove_0 = table.remove;
local l_concat_0 = table.concat;
local l_sort_0 = table.sort;
local l_get_0 = entity.get;
local l_get_local_player_0 = entity.get_local_player;
local l_pack_0 = msgpack.pack;
local l_unpack_1 = msgpack.unpack;
local l_parse_0 = json.parse;
local l_stringify_0 = json.stringify;
local l_get_1 = network.get;
local l_post_0 = network.post;
local l_print_raw_0 = print_raw;
local l_print_dev_0 = print_dev;
local l_events_0 = events;
local l_globals_0 = globals;
local l_vector_0 = vector;
local v70 = nil;
local v71 = nil;
local v72 = nil;
local v73 = nil;
local v74 = nil;
local v75 = nil;
local v76 = nil;
local v77 = nil;
local v78 = nil;
v70 = l_vector_0();
v71 = v70.clone;
v72 = v70.angles;
v73 = v70.length2d;
v74 = v70.to_screen;
local l_dist_0 = v70.dist;
v76 = v70.dist2d;
v75 = l_dist_0;
l_dist_0 = v70.normalize;
v78 = v70.normalized;
v77 = l_dist_0;
l_dist_0 = color;
local v80 = nil;
local v81 = nil;
local v82 = nil;
local v83 = nil;
v80 = l_dist_0();
v81 = v80.lerp;
v82 = v80.to_hex;
v83 = v80.alpha_modulate;
local v84 = nil;
local v85 = nil;
local v86 = nil;
local v87 = nil;
local v88 = nil;
v84 = ui.find;
local v89 = v84("Aimbot", "Ragebot", "Main", "Enabled");
local l_get_2 = v89.get;
v86 = v89.set;
v85 = l_get_2;
l_get_2 = v89.override;
v88 = v89.get_override;
v87 = l_get_2;
v89 = common.get_username();
l_get_2 = nil;
local v91 = nil;
l_get_2 = render.screen_size();
v91 = l_get_2 * 0.5;
local v92 = "0ucHJINGekQRUwZWVbPXyYlshz65DfLnpxTtKiFvor4ad9A7M3mSBCE21gjO8q+/=";
local v93 = nil;
local v94 = nil;
local v95 = nil;
v93 = require("neverlose/clipboard");
v94 = (function()
    -- upvalues: l_band_0 (ref), l_rshift_0 (ref), l_lshift_0 (ref), l_byte_0 (ref), l_sub_0 (ref), l_error_0 (ref), l_tostring_0 (ref), l_setmetatable_0 (ref), l_char_0 (ref), l_concat_0 (ref), l_next_0 (ref), l_format_0 (ref), l_gsub_0 (ref)
    local function v99(v96, v97, v98)
        -- upvalues: l_band_0 (ref), l_rshift_0 (ref), l_lshift_0 (ref)
        return l_band_0(l_rshift_0(v96, v97), l_lshift_0(1, v98) - 1);
    end;
    local function v105(v100)
        -- upvalues: l_byte_0 (ref), l_sub_0 (ref), l_error_0 (ref), l_tostring_0 (ref)
        local v101 = {};
        local v102 = {};
        for v103 = 1, 65 do
            local v104 = l_byte_0(l_sub_0(v100, v103, v103)) or 32;
            if v102[v104] ~= nil then
                l_error_0("invalid alphabet: duplicate character " .. l_tostring_0(v104), 3);
            end;
            v101[v103 - 1] = v104;
            v102[v104] = v103 - 1;
        end;
        return v101, v102;
    end;
    local v106 = {};
    local v107 = {};
    local v108, v109 = v105("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=");
    v107.base64 = v109;
    v106.base64 = v108;
    v108 = {
        __index = function(v110, v111)
            -- upvalues: v106 (ref), v107 (ref), v105 (ref)
            local v112 = #v111;
            if v112 == 64 or v112 == 65 then
                local l_v106_0 = v106;
                local l_v107_0 = v107;
                local v115, v116 = v105(v111);
                l_v107_0[v111] = v116;
                l_v106_0[v111] = v115;
                return v110[v111];
            else
                return;
            end;
        end
    };
    l_setmetatable_0(v106, v108);
    l_setmetatable_0(v107, v108);
    v109 = function(v117, v118)
        -- upvalues: v106 (ref), l_error_0 (ref), l_byte_0 (ref), l_char_0 (ref), v99 (ref), l_concat_0 (ref)
        v118 = v106[v118 or "base64"] or l_error_0("invalid alphabet specified", 2);
        local v119 = {};
        local v120 = 1;
        local v121 = #v117;
        local v122 = v121 % 3;
        local _ = {};
        for v124 = 1, v121 - v122, 3 do
            local v125, v126, v127 = l_byte_0(v117, v124, v124 + 2);
            local v128 = v125 * 65536 + v126 * 256 + v127;
            v119[v120] = l_char_0(v118[v99(v128, 18, 6)], v118[v99(v128, 12, 6)], v118[v99(v128, 6, 6)], v118[v99(v128, 0, 6)]);
            v120 = v120 + 1;
        end;
        if v122 == 2 then
            local v129, v130 = l_byte_0(v117, v121 - 1, v121);
            local v131 = v129 * 65536 + v130 * 256;
            v119[v120] = l_char_0(v118[v99(v131, 18, 6)], v118[v99(v131, 12, 6)], v118[v99(v131, 6, 6)], v118[64]);
        elseif v122 == 1 then
            local v132 = l_byte_0(v117, v121) * 65536;
            v119[v120] = l_char_0(v118[v99(v132, 18, 6)], v118[v99(v132, 12, 6)], v118[64], v118[64]);
        end;
        return l_concat_0(v119);
    end;
    local function v156(v133, v134, _)
        -- upvalues: v107 (ref), l_error_0 (ref), l_next_0 (ref), l_format_0 (ref), l_char_0 (ref), l_gsub_0 (ref), l_sub_0 (ref), l_byte_0 (ref), v99 (ref), l_concat_0 (ref)
        v134 = v107[v134 or "base64"] or l_error_0("invalid alphabet specified", 2);
        local v136 = "[^%w%+%/%=]";
        if v134 then
            local v137 = nil;
            local v138 = nil;
            for v139, v140 in l_next_0, v134 do
                if v140 == 62 then
                    v137 = v139;
                elseif v140 == 63 then
                    v138 = v139;
                end;
            end;
            v136 = l_format_0("[^%%w%%%s%%%s%%=]", l_char_0(v137), l_char_0(v138));
        end;
        v133 = l_gsub_0(v133, v136, "");
        local v141 = {};
        local v142 = 1;
        local v143 = #v133;
        local v144 = l_sub_0(v133, -2) == "==" and 2 or l_sub_0(v133, -1) == "=" and 1 or 0;
        local v145 = 1;
        local v146 = v144 > 0 and v143 - 4 or v143;
        for v147 = v145, v146, 4 do
            local v148, v149, v150, v151 = l_byte_0(v133, v147, v147 + 3);
            local v152 = v134[v148] * 262144 + v134[v149] * 4096 + v134[v150] * 64 + v134[v151];
            v141[v142] = l_char_0(v99(v152, 16, 8), v99(v152, 8, 8), v99(v152, 0, 8));
            v142 = v142 + 1;
        end;
        if v144 == 1 then
            local v153;
            v145, v146, v153 = l_byte_0(v133, v143 - 3, v143 - 1);
            local v154 = v134[v145] * 262144 + v134[v146] * 4096 + v134[v153] * 64;
            v141[v142] = l_char_0(v99(v154, 16, 8), v99(v154, 8, 8));
        elseif v144 == 2 then
            v145, v146 = l_byte_0(v133, v143 - 3, v143 - 2);
            local v155 = v134[v145] * 262144 + v134[v146] * 4096;
            v141[v142] = l_char_0(v99(v155, 16, 8));
        end;
        return l_concat_0(v141);
    end;
    return {
        encode = v109, 
        decode = v156
    };
end)();
v95 = (function()
    -- upvalues: l_tostring_0 (ref), l_sub_0 (ref), l_rep_0 (ref), l_concat_0 (ref), l_remove_0 (ref), v82 (ref), l_dist_0 (ref), l_print_raw_0 (ref)
    local v157 = {
        [1] = 221, 
        [2] = 221, 
        [3] = 221
    };
    local v158 = {
        [1] = 180, 
        [2] = 230, 
        [3] = 30
    };
    local v159 = {
        [1] = 96, 
        [2] = 160, 
        [3] = 220
    };
    local v160 = {
        [1] = 218, 
        [2] = 230, 
        [3] = 30
    };
    local function v177(v161, v162, v163, v164)
        -- upvalues: l_tostring_0 (ref), l_sub_0 (ref), l_rep_0 (ref), l_concat_0 (ref)
        v161 = l_tostring_0(v161);
        local v165 = l_tostring_0(v162 or "\n");
        local v166 = l_tostring_0(v163 or "\t");
        v164 = l_tostring_0(v164 or " ");
        v163 = v166;
        v162 = v165;
        v165 = 1;
        v166 = 0;
        local v167 = 0;
        local v168 = #v161;
        local v169 = {};
        local v170 = nil;
        local v171 = nil;
        local v172 = l_sub_0(v164, -1) == "\n";
        for v173 = 1, v168 do
            local v174 = l_sub_0(v161, v173, v173);
            if not v171 and (v174 == "{" or v174 == "[") then
                v169[v165] = v170 == ":" and v174 .. v162 or l_rep_0(v163, v166) .. v174 .. v162;
                v166 = v166 + 1;
            elseif not v171 and (v174 == "}" or v174 == "]") then
                v166 = v166 - 1;
                if v170 == "{" or v170 == "[" then
                    v165 = v165 - 1;
                    v169[v165] = l_rep_0(v163, v166) .. v170 .. v174;
                else
                    v169[v165] = v162 .. l_rep_0(v163, v166) .. v174;
                end;
            elseif not v171 and v174 == "," then
                v169[v165] = v174 .. v162;
                v167 = -1;
            elseif not v171 and v174 == ":" then
                v169[v165] = v174 .. v164;
                if v172 then
                    v165 = v165 + 1;
                    v169[v165] = l_rep_0(v163, v166);
                end;
            else
                if v174 == "\"" and v170 ~= "\\" then
                    if not v171 then
                        v171 = true;
                    else
                        v171 = nil;
                    end;
                end;
                if v166 ~= v167 then
                    v169[v165] = l_rep_0(v163, v166);
                    local v175 = v165 + 1;
                    v167 = v166;
                    v165 = v175;
                end;
                v169[v165] = v174;
            end;
            local l_v174_0 = v174;
            v165 = v165 + 1;
            v170 = l_v174_0;
        end;
        return l_concat_0(v169);
    end;
    local function v195(v178, v179, v180, v181, v182)
        -- upvalues: v157 (ref), v158 (ref), v159 (ref), v160 (ref), l_tostring_0 (ref), l_sub_0 (ref), l_remove_0 (ref), l_concat_0 (ref)
        local v183 = v179 or v157;
        local v184 = v181 or v158;
        local v185 = v182 or v159;
        if not v180 then
            v180 = v160;
        end;
        v182 = v185;
        v181 = v184;
        v179 = v183;
        v178 = l_tostring_0(v178);
        v183 = 1;
        v184 = #v178;
        v185 = {};
        local v186 = nil;
        local v187 = nil;
        local l_v179_0 = v179;
        local v189 = {};
        for v190 = 1, v184 do
            local v191 = l_sub_0(v178, v190, v190);
            local v192 = nil;
            if not v187 and (v191 == "{" or v191 == "[") then
                v192 = v179;
                v189[#v189 + 1] = v191;
            elseif not v187 and (v191 == "}" or v191 == "]") then
                v192 = v179;
                if v186 == "{" or v186 == "[" then
                    v189[#v189 + 1] = v191;
                else
                    v189[#v189 + 1] = v191;
                end;
            elseif not v187 and (v191 == "," or v191 == ":") then
                v192 = v179;
                v189[#v189 + 1] = v191;
            else
                if v191 == "\"" and v186 ~= "\\" then
                    if not v187 then
                        v187 = true;
                    else
                        v187 = nil;
                    end;
                    v192 = v180;
                elseif l_v179_0 == v180 then
                    v192 = v187 and v181 or v182;
                elseif l_v179_0 == v179 and v191 ~= " " and v191 ~= "\n" and v191 ~= "\t" then
                    v192 = v187 and v181 or v182;
                end;
                v189[#v189 + 1] = v191;
            end;
            if v192 ~= nil and v192 ~= l_v179_0 then
                local v193 = {
                    l_remove_0(v189, #v189)
                };
                v185[#v185 + 1] = {
                    l_v179_0[1], 
                    l_v179_0[2], 
                    l_v179_0[3], 
                    l_concat_0(v189)
                };
                local l_v192_0 = v192;
                v189 = v193;
                l_v179_0 = l_v192_0;
            end;
            v186 = v191;
        end;
        if #v189 > 0 then
            v185[#v185 + 1] = {
                l_v179_0[1], 
                l_v179_0[2], 
                l_v179_0[3], 
                l_concat_0(v189)
            };
        end;
        return v185;
    end;
    local function v210(v196, v197, v198, v199, v200)
        -- upvalues: v195 (ref), v82 (ref), l_dist_0 (ref), l_concat_0 (ref), l_print_raw_0 (ref)
        local v201 = {};
        local v202 = v195(v196, v197, v199, v200, v198);
        local v203 = #v202;
        for v204 = 1, v203 do
            local v205 = v202[v204];
            local v206 = v205[1];
            local v207 = v205[2];
            local v208 = v205[3];
            local v209 = v205[4];
            v201[#v201 + 1] = "\a";
            v201[#v201 + 1] = v82(l_dist_0(v206, v207, v208, 255));
            v201[#v201 + 1] = v209;
            if v204 == v203 then
                v201[#v201 + 1] = "\n";
            end;
        end;
        v201[#v201] = nil;
        v201 = l_concat_0(v201);
        l_print_raw_0(v201);
    end;
    return {
        format = v177, 
        highlight = v195, 
        print_highlighted = v210
    };
end)();
local v211 = nil;
local v212 = nil;
local v213 = nil;
local v214 = nil;
local v215 = nil;
local v216 = nil;
v211 = function(v217, v218, v219, v220)
    -- upvalues: l_pow_0 (ref)
    v217 = v217 / v220 * 2;
    if v217 < 1 then
        return v219 * 0.5 * l_pow_0(v217, 2) + v218;
    else
        return -v219 * 0.5 * ((v217 - 1) * (v217 - 3) - 1) + v218;
    end;
end;
v212 = function(v221, v222, v223, v224)
    -- upvalues: l_pow_0 (ref)
    v221 = v221 / v224 - 1;
    return -v223 * (l_pow_0(v221, 4) - 1) + v222;
end;
v213 = function(v225, v226, v227, v228)
    -- upvalues: l_cos_0 (ref), l_pi_0 (ref)
    return -v227 * 0.5 * (l_cos_0(l_pi_0 * v225 / v228) - 1) + v226;
end;
v214 = function(v229, v230, v231, v232)
    -- upvalues: l_pow_0 (ref)
    v229 = v229 / v232;
    return v231 * l_pow_0(v229, 3) + v230;
end;
v215 = function(v233, v234, v235, v236)
    -- upvalues: l_sin_0 (ref), l_pi_0 (ref)
    return v235 * l_sin_0(v233 / v236 * (l_pi_0 * 0.5)) + v234;
end;
v216 = function(v237, v238, v239, v240)
    -- upvalues: l_pow_0 (ref)
    if v237 == 0 then
        return v238;
    else
        return v239 * l_pow_0(2, 10 * (v237 / v240 - 1)) + v238 - v239 * 0.001;
    end;
end;
local v241 = nil;
local v242 = {};
for v243 = 1, 256 do
    local v244 = v243 - 1;
    for _ = 1, 8 do
        local v246 = -l_band_0(v244, 1);
        v244 = l_bxor_0(l_rshift_0(v244, 1), l_band_0(3988292384, v246));
    end;
    v242[v243] = v244;
end;
do
    local l_v242_0 = v242;
    v241 = function(v248)
        -- upvalues: l_byte_0 (ref), l_bxor_0 (ref), l_rshift_0 (ref), l_v242_0 (ref), l_band_0 (ref), l_bnot_0 (ref)
        local v249 = 4294967295;
        for v250 = 1, #v248 do
            local v251 = l_byte_0(v248, v250);
            v249 = l_bxor_0(l_rshift_0(v249, 8), l_v242_0[l_band_0(l_bxor_0(v249, v251), 255) + 1]);
        end;
        return l_band_0(l_bnot_0(v249), 4294967295);
    end;
end;
v242 = nil;
local v252 = nil;
local v253 = nil;
v242 = function(v254)
    -- upvalues: l_type_0 (ref), l_next_0 (ref), v242 (ref)
    if l_type_0(v254) ~= "table" then
        return v254;
    else
        local v255 = {};
        for v256, v257 in l_next_0, v254 do
            v255[v256] = v242(v257);
        end;
        return v255;
    end;
end;
v252 = function(v258, v259)
    -- upvalues: l_next_0 (ref)
    local v260 = {};
    for v261, v262 in l_next_0, v258 do
        local v263, v264 = v259(v261, v262);
        v260[v263] = v264;
    end;
    return v260;
end;
v253 = function(v265, v266, v267)
    -- upvalues: l_next_0 (ref), l_type_0 (ref), v253 (ref)
    if v266 == nil then
        v266 = {};
        v267 = "";
    end;
    for v268, v269 in l_next_0, v265 do
        local v270 = v267 .. v268;
        if l_type_0(v269) == "table" and #v269 == 0 then
            v253(v269, v266, v270 .. ".");
        else
            v266[v270] = v269;
        end;
    end;
    return v266;
end;
local v271 = nil;
local v272 = nil;
local l_decode_0 = v94.decode;
local l_encode_0 = v94.encode;
local l_read_0 = files.read;
local l_write_0 = files.write;
files.create_folder("nl\\scripts\\grenade helper");
local v277 = "nl\\scripts\\grenade helper\\database.msg";
do
    local l_l_decode_0_0, l_l_encode_0_0, l_l_read_0_0, l_l_write_0_0, l_v277_0 = l_decode_0, l_encode_0, l_read_0, l_write_0, v277;
    v271 = function()
        -- upvalues: l_l_read_0_0 (ref), l_v277_0 (ref), l_pcall_0 (ref), l_l_decode_0_0 (ref), v92 (ref), l_unpack_1 (ref), l_type_0 (ref)
        local v283 = l_l_read_0_0(l_v277_0);
        local _, v285 = l_pcall_0(l_l_decode_0_0, v283, v92);
        local v286, v287 = l_pcall_0(l_unpack_1, v285);
        if not v286 or l_type_0(v287) ~= "table" then
            v287 = {};
        end;
        v287.locations = v287.locations or {};
        v287.active_locations = v287.active_locations or {
            [1] = true, 
            [2] = true, 
            [3] = true
        };
        v287.cloud_active_locations = v287.cloud_active_locations or {};
        v287.map_patterns = v287.map_patterns or {};
        return v287;
    end;
    v272 = function(v288)
        -- upvalues: l_type_0 (ref), l_pack_0 (ref), l_l_encode_0_0 (ref), v92 (ref), l_l_write_0_0 (ref), l_v277_0 (ref)
        if l_type_0(v288) ~= "table" then
            return;
        else
            local v289 = l_pack_0(v288);
            v289 = l_l_encode_0_0(v289, v92);
            l_l_write_0_0(l_v277_0, v289);
            return;
        end;
    end;
end;
l_decode_0 = nil;
l_decode_0 = {};
l_encode_0 = nil;
l_read_0 = panorama.SteamOverlayAPI.OpenExternalBrowserURL;
do
    local l_l_read_0_1 = l_read_0;
    l_encode_0 = function(v291)
        -- upvalues: l_l_read_0_1 (ref)
        return function()
            -- upvalues: l_l_read_0_1 (ref), v291 (ref)
            l_l_read_0_1(v291);
        end;
    end;
end;
l_read_0 = nil;
l_read_0 = ui.create("\a{Link Active}\239\128\135", "\n main", 1);
l_read_0:label("\a{Link Active}\239\128\135\aDEFAULT   " .. v89);
l_read_0:label("\a{Link Active}\239\132\166\aDEFAULT   2.1 \a{Link Active} " .. (v0 and "Beta" or "Stable"));
if not v0 then
    l_read_0:button("\a{Link Active}\239\140\182\aDEFAULT  Beta Version", l_encode_0("https://neverlose.cc/market/item?id=FL1YSP"), true);
end;
l_write_0 = nil;
l_write_0 = ui.create("\a{Link Active}\239\128\135", "\n discord", 1);
l_write_0:button("\a{Link Active}\239\142\146\aDEFAULT Discord", l_encode_0("https://discord.gg/uM2uSEJzQJ"), true);
v277 = function(v292)
    -- upvalues: v93 (ref), l_print_raw_0 (ref)
    if v292 == nil or #v292 == 0 then
        return;
    else
        v93.set(v292);
        l_print_raw_0("\a{Link Active}[Helper] \aDEFAULTYour verification code: \a{Link Active}" .. v292 .. "\aDEFAULT (Copied to clipboard)");
        return;
    end;
end;
do
    local l_v277_1 = v277;
    l_write_0:button("\a{Link Active}\239\131\129\aDEFAULT Get Verification Code", function()
        -- upvalues: v0 (ref), l_tostring_0 (ref), l_floor_0 (ref), l_abs_0 (ref), v241 (ref), v89 (ref), l_get_timestamp_0 (ref), v94 (ref), v92 (ref), l_get_1 (ref), l_v277_1 (ref)
        local v294 = v0 and "grenade-helper-beta" or "grenade-helper";
        local v295 = l_tostring_0(l_floor_0(l_abs_0(v241(v89) + l_get_timestamp_0())));
        local v296 = v89 .. ":" .. v294 .. ":" .. v295;
        v296 = v94.encode(v296, v92);
        l_get_1("https://northon.dev/neverlose/discord/get_verification_code.php?data=" .. v296, nil, l_v277_1);
    end, true);
end;
v277 = nil;
v277 = ui.create("\a{Link Active}\239\128\135", "best world editor ~ remaper", 1);
v277:button("\239\149\189 Best World Edtior ~ Remaper", l_encode_0("https://neverlose.cc/market/item?id=a67tQs"));
local v297 = nil;
local v298 = ui.create("\a{Link Active}\239\128\147", "\n settings", 1);
v297 = {
    hotkey = v298:hotkey("\a{Link Active}\238\150\162\aDEFAULT  Hotkey")
};
do
    local l_v277_2, l_v297_0, l_v298_0 = v277, v297, v298;
    local v303 = l_v298_0:combo("\a{Link Active}\239\129\155\aDEFAULT   Aimbot", "Off", "Legit", "Rage"):set_callback(function(v302)
        -- upvalues: l_v297_0 (ref), v85 (ref)
        l_v297_0.aimbot = v85(v302);
    end, true);
    local v304 = v303:create();
    local v306 = v304:slider("\a{Link Active}\239\131\154\aDEFAULT  Field Of View", 40, 180, 100, 1, "\194\176"):set_callback(function(v305)
        -- upvalues: l_v297_0 (ref), v85 (ref)
        l_v297_0.fov = v85(v305);
    end, true);
    local v308 = v304:slider("\a{Link Active}\239\131\154\aDEFAULT  Smooth", 1, 100, 50, 1, "%"):set_callback(function(v307)
        -- upvalues: l_v297_0 (ref), v85 (ref)
        l_v297_0.smooth = v85(v307) * 0.1;
    end, true);
    do
        local l_v306_0, l_v308_0 = v306, v308;
        v303:set_callback(function(v311)
            -- upvalues: v85 (ref), l_v306_0 (ref), l_v308_0 (ref)
            local v312 = v85(v311);
            l_v306_0:visibility(v312 ~= "Off");
            l_v308_0:visibility(v312 == "Legit");
        end, true);
        l_v298_0:selectable("\a{Link Active}\239\130\133\aDEFAULT  Options", "\a{Link Active}\238\147\162\aDEFAULT   Automatic Throw", "\a{Link Active}\239\143\173   Exploit:\aDEFAULT Force Defensive", "\a{Link Active}\238\129\133   Exploit:\aDEFAULT Recovery Teleport"):set_callback(function(v313)
            -- upvalues: l_v297_0 (ref), v85 (ref)
            local l_l_v297_0_0 = l_v297_0;
            local l_l_v297_0_1 = l_v297_0;
            local l_l_v297_0_2 = l_v297_0;
            local v317 = v85(v313, 1);
            local v318 = v85(v313, 2);
            l_l_v297_0_2.recovery_teleport = v85(v313, 3);
            l_l_v297_0_1.force_defensive = v318;
            l_l_v297_0_0.automatic_throw = v317;
        end, true);
        l_decode_0.settings = l_v297_0;
    end;
    l_v298_0 = nil;
    v303 = ui.create("\a{Link Active}\239\128\147", "customization", 1);
    l_v298_0 = {};
    l_v298_0.options = v303:selectable("\n customization", "\a{Link Active}\239\129\176\aDEFAULT  Show Behind Walls", "\a{Link Active}\239\131\133\aDEFAULT   Hide Duplicates", "\a{Link Active}\238\146\129\aDEFAULT  Hide Icon With Text"):set_callback(function(v319)
        -- upvalues: l_v298_0 (ref), v85 (ref)
        local l_l_v298_0_0 = l_v298_0;
        local l_l_v298_0_1 = l_v298_0;
        local l_l_v298_0_2 = l_v298_0;
        local v323 = v85(v319, 1);
        local v324 = v85(v319, 2);
        l_l_v298_0_2.hide_icon_with_text = v85(v319, 3);
        l_l_v298_0_1.hide_duplicates = v324;
        l_l_v298_0_0.show_behind_walls = v323;
    end, true);
    v304 = ui.get_style("Link Active");
    l_v298_0.options:color_picker(v304):set_callback(function(v325)
        -- upvalues: v85 (ref), l_max_0 (ref), l_v298_0 (ref)
        local v326 = v85(v325);
        local v327 = l_max_0(40, v326.a) / 255;
        local l_l_v298_0_3 = l_v298_0;
        local l_l_v298_0_4 = l_v298_0;
        local l_v326_0 = v326;
        l_l_v298_0_4.alpha = v327;
        l_l_v298_0_3.color = l_v326_0;
    end, true);
    l_decode_0.customization = l_v298_0;
    v303 = nil;
    v303 = {
        enabled = ui.create("\a{Link Active}\239\128\147", "\n grenade release", 1):switch("\a{Link Active}\239\135\162\aDEFAULT   Grenade Release"):tooltip("Releases the grenade is there's a possibility of dealing damage to an enemy\n\n\aAFAF62FF" .. ui.get_icon("triangle-exclamation") .. "  This feature is a work in progress and may not work as intended")
    };
    v306 = v303.enabled:create();
    do
        local l_v306_1 = v306;
        v303.enabled:set_callback(function(v332)
            -- upvalues: l_v306_1 (ref), v85 (ref)
            l_v306_1:visibility(v85(v332));
        end, true);
        l_v306_1:switch("\a{Link Active}\239\131\154\aDEFAULT  Disable in Air", true):set_callback(function(v333)
            -- upvalues: v303 (ref), v85 (ref)
            v303.disable_in_air = v85(v333);
        end, true);
        l_v306_1:slider("\a{Link Active}\239\131\154\aDEFAULT  High Explosive", 0, 51, 50, 1, function(v334)
            if v334 == 0 then
                return "Off";
            elseif v334 == 51 then
                return "Lethal";
            else
                return v334 .. " dmg";
            end;
        end):set_callback(function(v335)
            -- upvalues: v303 (ref), v85 (ref)
            v303.hegrenade = v85(v335);
        end, true);
        l_v306_1:slider("\a{Link Active}\239\131\154\aDEFAULT  Flashbang", 0, 90, 60, 1, function(v336)
            if v336 == 0 then
                return "Off";
            else
                return v336 .. "%";
            end;
        end):set_callback(function(v337)
            -- upvalues: v303 (ref), v85 (ref)
            v303.flashbang = v85(v337);
        end, true);
        l_v306_1:slider("\a{Link Active}\239\131\154\aDEFAULT  Molotov", 0, 30, 20, 1, function(v338)
            if v338 == 0 then
                return "Off";
            else
                return v338 * 0.1 .. "m";
            end;
        end):set_callback(function(v339)
            -- upvalues: v303 (ref), v85 (ref)
            v303.molotov = v85(v339) * 0.1;
        end, true);
    end;
    l_decode_0.grenade_release = v303;
    v304 = nil;
    v304 = ui.create("\a{Link Active}\239\128\147", "best world editor ~ remaper", 1);
    v304:button("\239\149\189 Best World Edtior ~ Remaper", l_encode_0("https://neverlose.cc/market/item?id=a67tQs"));
    v306 = ui.create("\a{Link Active}\239\128\147", "best world editor ~ remaper ", 2);
    l_get_1("https://northon.dev/neverlose/remaper/world_editor.jpg", nil, function(v340)
        -- upvalues: l_v277_2 (ref), l_vector_0 (ref), v304 (ref)
        if v340 == nil or #v340 == 0 then
            return;
        else
            local v341 = render.load_image(v340);
            l_v277_2:texture(v341, l_vector_0(480, 270));
            v304:texture(v341, l_vector_0(280, 175));
            return;
        end;
    end);
    v306 = nil;
    v308 = ui.create("\a{Link Active}\239\128\147", "\n types", 2);
    local v342 = {
        [1] = "weapon_smokegrenade", 
        [2] = "weapon_flashbang", 
        [3] = "weapon_decoy", 
        [4] = "weapon_hegrenade", 
        [5] = "weapon_molotov", 
        [6] = "weapon_wallbang", 
        [7] = "weapon_knife"
    };
    v306 = {
        selection = v308:listable("\n types", "\a{Link Active}\239\157\160\aDEFAULT  Smoke", "\a{Link Active}\239\129\176\aDEFAULT  Flashbang", " \a{Link Active}\239\158\184\aDEFAULT   Decoy", " \a{Link Active}\239\135\162\aDEFAULT  High Explosive", " \a{Link Active}\239\129\173\aDEFAULT   Molotov", "\a{Link Active}\239\155\171\aDEFAULT   Wallbang", "\a{Link Active}\239\156\137\aDEFAULT  Movement")
    };
    do
        local l_v342_0 = v342;
        v306.selection:set_callback(function(v344)
            -- upvalues: l_v342_0 (ref), v306 (ref), v85 (ref)
            for v345 = 1, #l_v342_0 do
                v306[l_v342_0[v345]] = v85(v344, v345);
            end;
        end, true);
        l_decode_0.types = v306;
    end;
    v308 = nil;
    v342 = ui.create("\a{Link Active}\239\149\176", "\n locations", 1);
    v308 = {
        selection = v342:list("\n selection"), 
        enabled = v342:switch("Enabled"), 
        new_source_name = v342:input("\n name"):reset(), 
        create_label = v342:label("Create"), 
        create = v342:button("\a{Link Active}    \239\131\135    ", nil, true):tooltip("Create"), 
        label = v342:label("Edit & Delete"), 
        edit = v342:button("\a{Link Active}   \239\129\132   ", nil, true):tooltip("Edit"), 
        delete = v342:button("\a{Link Active}   \239\135\184   ", nil, true):tooltip("Delete"), 
        delete_confirm = v342:button("\a{Link Active}   \238\138\175   ", nil, true):tooltip("Confirm"), 
        delete_cancel = v342:button("\a{Link Active}   \238\138\174   ", nil, true):tooltip("Cancel")
    };
    v308.on_visibility = function()
        -- upvalues: v85 (ref), v308 (ref)
        local v346 = v85(v308.selection);
        local v347 = v346 == #v308.selection:list();
        v308.enabled:visibility(not v347);
        v308.new_source_name:visibility(v347);
        v308.create_label:visibility(v347);
        v308.create:visibility(v347);
        v308.delete_confirm:visibility(false);
        v308.delete_cancel:visibility(false);
        v308.label:visibility(not v347 and v346 > 3);
        v308.edit:visibility(not v347 and v346 > 3);
        v308.delete:visibility(not v347 and v346 > 3);
    end;
    v308.selection:set_callback(v308.on_visibility, true);
    v308.delete:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_confirm:visibility(true);
        v308.delete_cancel:visibility(true);
        v308.delete:visibility(false);
    end);
    v308.delete_confirm:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_confirm:visibility(false);
        v308.delete_cancel:visibility(false);
        v308.delete:visibility(true);
    end);
    v308.delete_cancel:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_confirm:visibility(false);
        v308.delete_cancel:visibility(false);
        v308.delete:visibility(true);
    end);
    v308.search = v342:input("\n search"):reset();
    v308.locations_selection = v342:list("\n locations selection");
    v308.all_maps = v342:switch("All Maps");
    v308.clipboard = v342:label("Clipboard");
    v308.import = v342:button("\a{Link Active}   \239\149\175    ", nil, true):tooltip("Import");
    v308.export = v342:button("\a{Link Active}    \239\149\174   ", nil, true):tooltip("Export");
    v308.delete_location_label = v342:label("Delete & Back");
    v308.back_label = v342:label("Back");
    v308.delete_location = v342:button("\a{Link Active}    \239\135\184    ", nil, true):tooltip("Delete");
    v308.delete_location_confirm = v342:button("\a{Link Active}    \238\138\175    ", nil, true):tooltip("Confirm");
    v308.delete_location_cancel = v342:button("\a{Link Active}    \238\138\174    ", nil, true):tooltip("Cancel");
    v308.back = v342:button("\a{Link Active}   \239\139\170    ", nil, true):tooltip("Back");
    v308.edit:set_callback(function()
        -- upvalues: v308 (ref)
        v308.search:reset();
        v308.edit:visibility(false);
        v308.back:visibility(true);
        v308.selection:visibility(false);
        v308.enabled:visibility(false);
        v308.delete_confirm:visibility(false);
        v308.delete_cancel:visibility(false);
        v308.label:visibility(false);
        v308.delete:visibility(false);
        v308.search:visibility(true);
        v308.locations_selection:visibility(true);
        v308.all_maps:visibility(true);
        v308.clipboard:visibility(true);
        v308.import:visibility(true);
        v308.export:visibility(true);
        v308.delete_location_confirm:visibility(false);
        v308.delete_location_cancel:visibility(false);
        v308.delete_location_label:visibility(true);
        v308.back_label:visibility(false);
        v308.delete_location:visibility(true);
    end);
    v308.locations_selection:set_callback(function(v348)
        -- upvalues: v85 (ref), v308 (ref)
        local v349 = v85(v348);
        local v350 = not v308.edit:visibility();
        v308.delete_location_confirm:visibility(false);
        v308.delete_location_cancel:visibility(false);
        v308.delete_location_label:visibility(v349 > 1 and v350);
        v308.back_label:visibility(v349 == 1 and v350);
        v308.delete_location:visibility(v349 > 1 and v350);
    end, true);
    v308.delete_location:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_location_confirm:visibility(true);
        v308.delete_location_cancel:visibility(true);
        v308.delete_location:visibility(false);
    end);
    v308.delete_location_confirm:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_location_confirm:visibility(false);
        v308.delete_location_cancel:visibility(false);
        v308.delete_location:visibility(true);
    end);
    v308.delete_location_cancel:set_callback(function()
        -- upvalues: v308 (ref)
        v308.delete_location_confirm:visibility(false);
        v308.delete_location_cancel:visibility(false);
        v308.delete_location:visibility(true);
    end);
    v308.back:set_callback(function()
        -- upvalues: v308 (ref), l_execute_after_0 (ref)
        v308.search:reset();
        v308.label:visibility(true);
        v308.edit:visibility(true);
        v308.back:visibility(false);
        v308.selection:visibility(true);
        v308.search:visibility(false);
        v308.locations_selection:visibility(false);
        v308.all_maps:visibility(false);
        v308.clipboard:visibility(false);
        v308.import:visibility(false);
        v308.export:visibility(false);
        v308.delete_location_confirm:visibility(false);
        v308.delete_location_cancel:visibility(false);
        l_execute_after_0(0, v308.back_label.visibility, v308.back_label, false);
        v308.delete_location_label:visibility(false);
        v308.delete_location:visibility(false);
        v308.on_visibility();
    end, true);
    l_decode_0.locations = v308;
    v342 = nil;
    local v351 = ui.create("\a{Link Active}\239\149\176", "\n builder", 2);
    do
        local l_v351_0 = v351;
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: l_v351_0 (ref)
            l_v351_0:visibility(true);
        end);
        l_decode_0.locations.back:set_callback(function()
            -- upvalues: l_v351_0 (ref)
            l_v351_0:visibility(false);
        end, true);
        v342 = {
            type = l_v351_0:combo("\n type", "Grenade", "Wallbang", "Movement"), 
            name = l_v351_0:input("Name"):reset(), 
            description = l_v351_0:input("Description"):reset(), 
            jump = l_v351_0:switch("Jump"), 
            run = l_v351_0:combo("Run", "Disabled", "Forward", "Left", "Right", "Back", "Custom")
        };
        local v353 = v342.run:create();
        v342.run_custom = v353:slider("Direction", -180, 180, 0);
        v342.run_duration = v353:slider("Duration", 0, 256, 20);
        v342.run_walk = v353:switch("Walk (Shift)");
        v342.run:set_callback(function(v354)
            -- upvalues: v85 (ref), v353 (ref), v342 (ref)
            local v355 = v85(v354);
            v353:visibility(v355 ~= "Disabled");
            v342.run_custom:visibility(v355 == "Custom");
        end, true);
        v342.recovery = l_v351_0:combo("Recovery", "Disabled", "Forward", "Left", "Right", "Back", "Custom");
        local v356 = v342.recovery:create();
        v342.recovery_custom = v356:slider("Direction", -180, 180, 0);
        v342.recovery_bunnyhop = v356:switch("Bunny Hop");
        v342.recovery:set_callback(function(v357)
            -- upvalues: v85 (ref), v356 (ref), v342 (ref)
            local v358 = v85(v357);
            v356:visibility(v358 ~= "Disabled");
            v342.recovery_custom:visibility(v358 == "Custom");
        end, true);
        v342.strength = l_v351_0:combo("Strength", "Left", "Left / Right", "Right");
        v342.delay = l_v351_0:slider("Delay", 0, 64, 0, 1, function(v359)
            if v359 == 0 then
                return "Off";
            else
                return;
            end;
        end);
        local v360 = ui.create("\a{Link Active}\239\149\176", "\n buttons", 2);
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: v360 (ref)
            v360:visibility(true);
        end);
        l_decode_0.locations.back:set_callback(function()
            -- upvalues: v360 (ref)
            v360:visibility(false);
        end, true);
        v342.record = v360:switch("Record");
        local v361 = "set_location_teleport_label";
        local v362 = "teleport_label";
        local v363 = v360:label("Set Location & Teleport");
        v342[v362] = v360:label("Teleport");
        v342[v361] = v363;
        v342.set_location = v360:button("\a{Link Active}   \239\130\173   ", nil, true):tooltip("Set Position, Angles, Weapon");
        v342.teleport = v360:button("\a{Link Active}   \238\129\133   ", nil, true):tooltip("Teleport");
        v342.export_save = v360:label("Export & Save");
        v342.export = v360:button("\a{Link Active}   \239\149\174   ", nil, true):tooltip("Export");
        v342.save = v360:button("\a{Link Active}   \239\131\135   ", nil, true):tooltip("Save");
        v342.type:set_callback(function(v364)
            -- upvalues: v85 (ref), v342 (ref)
            local v365 = v85(v364);
            local v366 = v365 == "Grenade";
            local _ = v365 == "Wallbang";
            local v368 = v365 == "Movement";
            v342.jump:visibility(v366);
            v342.run:visibility(v366);
            v342.recovery:visibility(v366);
            v342.strength:visibility(v366);
            v342.delay:visibility(v366);
            v342.record:visibility(v368);
            v342.set_location_teleport_label:visibility(not v368);
            v342.set_location:visibility(not v368);
            v342.teleport_label:visibility(v368);
        end, true);
        v361 = ui.create("\a{Link Active}\239\149\176", "\n hotkeys", 2);
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: v361 (ref)
            v361:visibility(true);
        end);
        l_decode_0.locations.back:set_callback(function()
            -- upvalues: v361 (ref)
            v361:visibility(false);
        end, true);
        v342.set_location_hotkey = v361:hotkey("Set Location"):tooltip("Set Position, Angles, Weapon");
        v342.teleport_hotkey = v361:hotkey("Teleport"):tooltip("Teleport");
        l_decode_0.builder = v342;
    end;
    v351 = nil;
    local v369 = ui.create("\a{Link Active}\239\149\176", "\n cloud sources", 2);
    v351 = {};
    do
        local l_v369_0 = v369;
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: l_v369_0 (ref)
            l_v369_0:visibility(false);
        end);
        l_decode_0.locations.back:set_callback(function()
            -- upvalues: l_v369_0 (ref)
            l_v369_0:visibility(true);
        end);
        local v371 = not v0;
        if v371 then
            l_v369_0:button("Cloud Sources Is Available in Beta Version", l_encode_0("https://neverlose.cc/market/item?id=FL1YSP"), false);
        end;
        v351.selection = l_v369_0:list("\n selection"):disabled(v371);
        if v0 then
            v351.enabled = l_v369_0:switch("Enabled");
            v351.selection:set_callback(function(v372)
                -- upvalues: v351 (ref), v85 (ref)
                v351.enabled:visibility(v85(v372) > 1);
            end, true);
            v351.update_selection = l_v369_0:list("\n update selection");
            v351.upload_selection = l_v369_0:list("\n upload selection");
            v351.update_delete_label = l_v369_0:label("Update & Delete");
            v351.delete_label = l_v369_0:label("Delete");
            v351.update = l_v369_0:button("\a{Link Active}   \239\131\174   ", nil, true):tooltip("Update");
            v351.delete = l_v369_0:button("\a{Link Active}   \239\135\184   ", nil, true):tooltip("Delete");
            v351.delete_confirm = l_v369_0:button("\a{Link Active}   \238\138\175   ", nil, true):tooltip("Confirm");
            v351.delete_cancel = l_v369_0:button("\a{Link Active}   \238\138\174   ", nil, true):tooltip("Cancel");
            v351.upload_label = l_v369_0:label("Upload");
            v351.upload = l_v369_0:button("\a{Link Active}   \239\130\147   ", nil, true):tooltip("Upload");
            v351.upload_text = l_v369_0:label("\a{Link Active}\239\129\177\aDEFAULT You don't have any locations that you can upload to the cloud");
        end;
        v351.market_locations_label = l_v369_0:label("Market Locations"):visibility(false);
        v351.market_locations = v351.market_locations_label:create();
        if v0 then
            v351.delete:set_callback(function()
                -- upvalues: v351 (ref)
                v351.delete:visibility(false);
                v351.delete_confirm:visibility(true);
                v351.delete_cancel:visibility(true);
            end);
            v351.delete_confirm:set_callback(function()
                -- upvalues: v351 (ref)
                v351.delete:visibility(true);
                v351.delete_confirm:visibility(false);
                v351.delete_cancel:visibility(false);
            end);
            v351.delete_cancel:set_callback(function()
                -- upvalues: v351 (ref)
                v351.delete:visibility(true);
                v351.delete_confirm:visibility(false);
                v351.delete_cancel:visibility(false);
            end);
        end;
        l_decode_0.cloud_sources = v351;
    end;
    v369 = nil;
    local v373 = ui.create("\a{Link Active}\239\149\176", "\n map patterns", 1);
    do
        local l_v373_0 = v373;
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: l_v373_0 (ref)
            l_v373_0:visibility(false);
        end);
        l_decode_0.locations.back:set_callback(function()
            -- upvalues: l_v373_0 (ref)
            l_v373_0:visibility(true);
        end);
        v369 = {
            selection = l_v373_0:list("\n selection", "Edit Current Map Pattern"), 
            new_map_name = l_v373_0:input("\n new map name"):reset(), 
            save_label = l_v373_0:label("Save"), 
            current_map_pattern = l_v373_0:button("\n map pattern", nil, true):tooltip("Current Map Pattern"), 
            save = l_v373_0:button("\a{Link Active}    \239\131\135    ", nil, true):tooltip("Save"), 
            delete_label = l_v373_0:label("Delete"), 
            delete = l_v373_0:button("\a{Link Active}    \239\135\184    ", nil, true):tooltip("Delete")
        };
        v369.on_visibility = function()
            -- upvalues: v369 (ref), v85 (ref)
            local v375 = v369.selection:list();
            local v376 = v85(v369.selection);
            if #v375 < v376 then
                local v377 = #v375;
                if v377 then
                    v376 = v377;
                end;
            end;
            local v378 = v376 == 1;
            v369.new_map_name:visibility(v378);
            v369.save_label:visibility(v378);
            v369.save:visibility(v378);
            v369.current_map_pattern:visibility(v378);
            v369.delete_label:visibility(not v378);
            v369.delete:visibility(not v378);
        end;
        v369.selection:set_callback(v369.on_visibility);
        l_decode_0.map_patterns = v369;
    end;
    v373 = nil;
    local l_get_alpha_0 = ui.get_alpha;
    local l_get_style_0 = ui.get_style;
    local l_sidebar_0 = ui.sidebar;
    local v382 = " Grenade Helper";
    local v383 = #v382 + 1;
    do
        local l_l_get_alpha_0_0, l_l_get_style_0_0, l_l_sidebar_0_0, l_v382_0, l_v383_0 = l_get_alpha_0, l_get_style_0, l_sidebar_0, v382, v383;
        local function v399()
            -- upvalues: l_l_get_alpha_0_0 (ref), l_l_get_style_0_0 (ref), l_v383_0 (ref), l_abs_0 (ref), l_sin_0 (ref), l_globals_0 (ref), l_pi_0 (ref), v81 (ref), v82 (ref), l_sub_0 (ref), l_v382_0 (ref), l_concat_0 (ref), l_l_sidebar_0_0 (ref)
            if l_l_get_alpha_0_0() == 0 then
                return;
            else
                local v389 = {};
                local v390 = l_l_get_style_0_0("Link Active");
                local v391 = v390 * 0.3;
                local v392 = nil;
                for v393 = 1, l_v383_0 do
                    local v394 = (v393 - 1) / l_v383_0;
                    local v395 = l_abs_0(l_sin_0(l_globals_0.realtime % l_pi_0 + v394 * 2));
                    local v396 = v81(v391, v390, v395);
                    v396.a = 255;
                    local v397 = "\a" .. v82(v396);
                    if v393 == 1 then
                        v392 = v397;
                    else
                        local v398 = l_sub_0(l_v382_0, v393, v393);
                        v389[#v389 + 1] = v397 .. v398;
                    end;
                end;
                v389 = l_concat_0(v389);
                l_l_sidebar_0_0(v389, v392 .. "\239\135\162");
                return;
            end;
        end;
        l_events_0.render(v399);
    end;
end;
l_encode_0 = function(...)
    -- upvalues: l_concat_0 (ref), l_print_raw_0 (ref), l_print_dev_0 (ref)
    local v400 = l_concat_0({
        ...
    });
    local v401 = "\a{Link Active}[Helper] \aDEFAULT";
    l_print_raw_0(v401 .. v400);
    l_print_dev_0(v401 .. v400);
end;
l_read_0 = nil;
l_write_0 = {
    [38] = "weapon_wallbang", 
    [40] = "weapon_wallbang", 
    [1] = "weapon_wallbang", 
    [44] = "weapon_hegrenade", 
    [48] = "weapon_molotov", 
    [11] = "weapon_wallbang", 
    [46] = "weapon_molotov", 
    [64] = "weapon_wallbang", 
    [9] = "weapon_wallbang", 
    [45] = "weapon_smokegrenade", 
    [43] = "weapon_flashbang", 
    [47] = "weapon_decoy"
};
do
    local l_l_write_0_1 = l_write_0;
    l_read_0 = function(v403)
        -- upvalues: l_l_write_0_1 (ref)
        local v404 = v403:get_player_weapon();
        if v404 == nil then
            return;
        else
            local v405 = l_l_write_0_1[v404:get_weapon_index()];
            if v405 ~= nil then
                return v404, v405;
            else
                return v404, v404:get_weapon_info().weapon_name;
            end;
        end;
    end;
end;
l_write_0 = l_events_0["[Grenade Helper] Map Change"];
v277 = l_events_0["[Grenade Helper] Cloud Updated"];
v297 = nil;
v298 = nil;
local l_map_patterns_0 = l_decode_0.map_patterns;
local l_map_patterns_1 = v271().map_patterns;
local v408 = nil;
local v409 = {
    ["1507960924"] = "cs_agency", 
    ["1722587796"] = "de_dust2_old", 
    ["1476824995"] = "de_vertigo", 
    ["1850283081"] = "de_anubis", 
    ["1463756432"] = "cs_assault", 
    ["1900771637"] = "de_cache", 
    ["1445192006"] = "de_engage", 
    ["1964982021"] = "de_elysion", 
    ["1364328969"] = "cs_militia", 
    ["2041417734"] = "de_cbble", 
    ["1238495690"] = "ar_dizzy", 
    ["2056138930"] = "gd_rialto", 
    ["1014664118"] = "cs_office", 
    ["899765791"] = "de_safehouse", 
    ["878725495"] = "de_bank", 
    ["792319475"] = "de_ancient", 
    ["790893427"] = "dz_sirocco", 
    ["549370830"] = "de_lake", 
    ["405708653"] = "de_overpass", 
    ["371013699"] = "de_stmarc", 
    ["-182586077"] = "de_aztec", 
    ["-222265935"] = "ar_baggage", 
    ["-542128589"] = "ar_monastery", 
    ["-692592072"] = "cs_italy", 
    ["-768791216"] = "de_dust2", 
    ["-923663825"] = "dz_frostbite", 
    ["-1218081885"] = "de_guard", 
    ["-1348292803"] = "cs_apollo", 
    ["-1411074561"] = "de_tulip", 
    ["-1439577949"] = "de_canals", 
    ["-1541779215"] = "de_sugarcane", 
    ["-1621571143"] = "de_dust", 
    ["-1639993233"] = "de_mirage", 
    ["-1752602089"] = "de_inferno", 
    ["-1768287648"] = "dz_blacksite", 
    ["-1890957714"] = "ar_shoots", 
    ["-2011174878"] = "de_train", 
    ["1563115098"] = "de_nuke"
};
local v410 = {};
do
    local l_l_map_patterns_0_0, l_l_map_patterns_1_0, l_v409_0, l_v410_0 = l_map_patterns_0, l_map_patterns_1, v409, v410;
    local function v418()
        -- upvalues: l_get_0 (ref), v298 (ref), l_format_0 (ref), l_tostring_0 (ref), v241 (ref), l_l_map_patterns_0_0 (ref)
        local v415 = l_get_0(0);
        if v415 == nil then
            v298 = nil;
            return;
        else
            local l_m_WorldMins_0 = v415.m_WorldMins;
            local l_m_WorldMaxs_0 = v415.m_WorldMaxs;
            v298 = l_format_0("bomb_%.2f_%.2f_%.2f %.2f_%.2f_%.2f", l_m_WorldMins_0.x, l_m_WorldMins_0.y, l_m_WorldMins_0.z, l_m_WorldMaxs_0.x, l_m_WorldMaxs_0.y, l_m_WorldMaxs_0.z);
            v298 = l_tostring_0(v241(v298));
            l_l_map_patterns_0_0.current_map_pattern:name("\a{Link Active}" .. v298);
            return;
        end;
    end;
    v418();
    local function v419()
        -- upvalues: l_globals_0 (ref), v297 (ref), l_write_0 (ref), l_v410_0 (ref), v298 (ref), l_lower_0 (ref), l_get_map_data_0 (ref)
        if not l_globals_0.is_in_game then
            v297 = nil;
            return l_write_0:call();
        else
            v297 = l_v410_0[v298];
            if v297 ~= nil then
                return l_write_0:call();
            else
                v297 = l_lower_0(l_get_map_data_0().shortname);
                if v297 == "de_shortnuke" then
                    v297 = "de_nuke";
                end;
                l_write_0:call();
                return;
            end;
        end;
    end;
    local function v427()
        -- upvalues: l_v410_0 (ref), l_next_0 (ref), l_v409_0 (ref), l_l_map_patterns_1_0 (ref), l_format_0 (ref), l_l_map_patterns_0_0 (ref), v419 (ref)
        l_v410_0 = {};
        for v420, v421 in l_next_0, l_v409_0 do
            l_v410_0[v420] = v421;
        end;
        local v422 = {
            [1] = "Edit Current Map Pattern"
        };
        for v423 = 1, #l_l_map_patterns_1_0 do
            local v424 = l_l_map_patterns_1_0[v423];
            local l_map_0 = v424.map;
            local l_pattern_0 = v424.pattern;
            l_v410_0[l_pattern_0] = l_map_0;
            v422[#v422 + 1] = l_format_0("\a{Link Active}%s:\aDEFAULT %s", l_map_0, l_pattern_0);
        end;
        l_l_map_patterns_0_0.selection:update(v422);
        l_l_map_patterns_0_0.on_visibility();
        v419();
    end;
    v427();
    local function v430(v428, v429)
        return v429.pattern, v428;
    end;
    l_l_map_patterns_0_0.save:set_callback(function()
        -- upvalues: v298 (ref), l_v409_0 (ref), l_encode_0 (ref), l_format_0 (ref), v85 (ref), l_l_map_patterns_0_0 (ref), l_gsub_0 (ref), l_type_0 (ref), v252 (ref), l_l_map_patterns_1_0 (ref), v430 (ref), v271 (ref), v272 (ref), v427 (ref)
        if v298 == nil then
            return;
        elseif l_v409_0[v298] ~= nil then
            return l_encode_0(l_format_0("Failed to create pattern: Already exists (%s: %s)", v298, l_v409_0[v298]));
        else
            local v431 = v85(l_l_map_patterns_0_0.new_map_name);
            v431 = l_gsub_0(v431, " ", "");
            if l_type_0(v431) ~= "string" or v431 == "" then
                return l_encode_0("Failed to create pattern: Invalid map name");
            else
                l_l_map_patterns_1_0[v252(l_l_map_patterns_1_0, v430)[v298] or #l_l_map_patterns_1_0 + 1] = {
                    map = v431, 
                    pattern = v298
                };
                local v432 = v271();
                v432.map_patterns = l_l_map_patterns_1_0;
                v272(v432);
                v432 = nil;
                v427();
                return;
            end;
        end;
    end);
    l_l_map_patterns_0_0.delete:set_callback(function()
        -- upvalues: v85 (ref), l_l_map_patterns_0_0 (ref), l_l_map_patterns_1_0 (ref), l_remove_0 (ref), v271 (ref), v272 (ref), v427 (ref)
        local v433 = v85(l_l_map_patterns_0_0.selection) - 1;
        if l_l_map_patterns_1_0[v433] == nil then
            return;
        else
            l_remove_0(l_l_map_patterns_1_0, v433);
            local v434 = v271();
            v434.map_patterns = l_l_map_patterns_1_0;
            v272(v434);
            v434 = nil;
            v427();
            return;
        end;
    end);
    local function v435()
        -- upvalues: v418 (ref), v427 (ref)
        v418();
        v427();
    end;
    l_events_0.level_init(v435);
    l_events_0.cs_game_disconnected(v435);
end;
l_map_patterns_0 = nil;
v408 = nil;
l_map_patterns_1 = nil;
v409 = nil;
v410 = nil;
local v436 = nil;
local v437 = nil;
local v438 = {};
local v439 = {};
local v440 = {};
v437 = {};
v436 = v440;
v410 = v439;
v408 = v438;
v438 = function(v441)
    -- upvalues: l_decode_0 (ref), l_next_0 (ref), v297 (ref), v408 (ref)
    local l_types_0 = l_decode_0.types;
    for v443, v444 in l_next_0, v441 do
        if v297 == v443 then
            for v445 = 1, #v444 do
                local v446 = v444[v445];
                if v446 ~= nil then
                    local l_weapon_0 = v446.weapon;
                    if l_types_0[l_weapon_0] then
                        local v448 = v408[l_weapon_0];
                        if v448 == nil then
                            v448 = {};
                            v408[l_weapon_0] = v448;
                        end;
                        v448[#v448 + 1] = v446;
                    else
                        v444[v445] = nil;
                    end;
                end;
            end;
        else
            v441[v443] = nil;
        end;
    end;
end;
do
    local l_v438_0 = v438;
    l_map_patterns_0 = function(v450, v451)
        -- upvalues: v408 (ref), l_map_patterns_1 (ref), v437 (ref), v297 (ref), v271 (ref), v242 (ref), l_v438_0 (ref), l_next_0 (ref), v410 (ref), v436 (ref)
        local v452 = {};
        l_map_patterns_1 = nil;
        v408 = v452;
        v437 = {};
        if v297 == nil then
            return;
        else
            v452 = v450 or v271();
            local l_active_locations_0 = v452.active_locations;
            local l_locations_0 = v452.locations;
            local v455 = v451 ~= nil and v451.source_index;
            for v456 = 1, #l_locations_0 do
                if l_active_locations_0[v456] then
                    local l_locations_1 = l_locations_0[v456].locations;
                    if v455 == v456 then
                        local l_location_0 = v451.location;
                        local l_map_name_0 = l_location_0.map_name;
                        local v460 = l_locations_1[l_map_name_0];
                        if v460 == nil then
                            v460 = {};
                            l_locations_1[l_map_name_0] = v460;
                        end;
                        local v461 = v242(l_location_0.editing);
                        v461.editing = true;
                        local l_index_0 = l_location_0.index;
                        if l_index_0 == 0 then
                            l_index_0 = #v460 + 1;
                        end;
                        v460[l_index_0] = v461;
                    end;
                    l_v438_0(l_locations_1);
                else
                    if v455 == v456 then
                        local l_location_1 = v451.location;
                        local v464 = v242(l_location_1.editing);
                        v464.editing = true;
                        local v465 = {
                            [l_location_1.map_name] = {
                                [1] = v464
                            }
                        };
                        l_v438_0(v465);
                    end;
                    l_locations_0[v456] = nil;
                end;
            end;
            for _, v467 in l_next_0, v410 do
                l_v438_0(v467);
            end;
            for _, v469 in l_next_0, v436 do
                l_v438_0(v469);
            end;
            v452 = nil;
            l_active_locations_0 = nil;
            l_locations_0 = nil;
            return;
        end;
    end;
    l_map_patterns_0();
    v439 = function()
        -- upvalues: v410 (ref), v436 (ref), l_map_patterns_0 (ref)
        v410 = {};
        v436 = {};
        l_map_patterns_0();
    end;
    l_write_0(v439);
    l_decode_0.types.selection:set_callback(v439);
    l_decode_0.customization.options:set_callback(v439);
end;
v438 = false;
v439 = nil;
v440 = nil;
local v470 = nil;
local v471 = nil;
local v472 = nil;
local v473 = nil;
v471 = {};
local l_settings_0 = l_decode_0.settings;
local l_customization_0 = l_decode_0.customization;
local v476 = v84("Aimbot", "Ragebot", "Main", "Double Tap");
local v477 = v84("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options");
local v478 = v84("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch");
local v479 = v84("Aimbot", "Ragebot", "Main", "Hide Shots");
local v480 = v84("Aimbot", "Ragebot", "Main", "Hide Shots", "Options");
local v481 = v84("Aimbot", "Anti Aim", "Angles", "Extended Angles");
local v482 = v84("Aimbot", "Anti Aim", "Misc", "Slow Walk");
local v483 = v84("Aimbot", "Anti Aim", "Misc", "Fake Duck");
local v484 = v84("Miscellaneous", "Main", "Movement", "Air Duck");
local v485 = v84("Miscellaneous", "Main", "Movement", "Air Strafe");
local v486 = v84("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe");
local v487 = v84("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing");
local v488 = v84("Miscellaneous", "Main", "Movement", "Quick Stop");
local v489 = v84("Miscellaneous", "Main", "Movement", "Strafe Assist");
local v490 = v84("Miscellaneous", "Main", "Movement", "Edge Jump");
do
    local l_l_settings_0_0, l_l_customization_0_0, l_v476_0, l_v477_0, l_v478_0, l_v480_0, l_v481_0, l_v482_0, l_v483_0, l_v484_0, l_v485_0, l_v486_0, l_v487_0, l_v488_0, l_v489_0, l_v490_0 = l_settings_0, l_customization_0, v476, v477, v478, v480, v481, v482, v483, v484, v485, v486, v487, v488, v489, v490;
    local function v507()
        -- upvalues: v87 (ref), l_v478_0 (ref), l_v477_0 (ref), l_v480_0 (ref), l_v481_0 (ref), l_v482_0 (ref), l_v483_0 (ref), l_v484_0 (ref), l_v485_0 (ref), l_v488_0 (ref), l_v486_0 (ref), l_v487_0 (ref), l_v489_0 (ref), l_v490_0 (ref)
        v87(l_v478_0);
        v87(l_v477_0);
        v87(l_v480_0);
        v87(l_v481_0);
        v87(l_v482_0);
        v87(l_v483_0);
        v87(l_v484_0);
        v87(l_v485_0);
        v87(l_v488_0);
        v87(l_v486_0);
        v87(l_v487_0);
        v87(l_v489_0);
        v87(l_v490_0);
    end;
    local v508 = nil;
    local v509 = cvar.sensitivity:float();
    local v510 = true;
    v508 = function(_)

    end;
    local v512 = nil;
    local v513 = nil;
    v509 = function(v514)
        local v515 = false;
        v514.in_back = false;
        v514.in_forward = v515;
        v515 = false;
        v514.in_moveright = false;
        v514.in_moveleft = v515;
        v515 = 0;
        v514.sidemove = 0;
        v514.forwardmove = v515;
        v514.in_jump = false;
        v514.in_speed = false;
        v514.in_duck = false;
    end;
    v510 = 1;
    local v516 = 2;
    local v517 = 3;
    local v518 = 4;
    local v519 = 5;
    local l_exploit_0 = rage.exploit;
    local l_get_3 = l_exploit_0.get;
    local l_force_teleport_0 = l_exploit_0.force_teleport;
    do
        local l_v509_0, l_v510_0, l_v516_0, l_v517_0, l_v518_0, l_v519_0, l_l_exploit_0_0, l_l_get_3_0, l_l_force_teleport_0_0 = v509, v510, v516, v517, v518, v519, l_exploit_0, l_get_3, l_force_teleport_0;
        v513 = function(v532, v533, v534, v535)
            -- upvalues: v471 (ref), l_v510_0 (ref), l_l_settings_0_0 (ref), l_v519_0 (ref), v508 (ref), l_camera_angles_0 (ref), l_v516_0 (ref), l_v518_0 (ref), v507 (ref), l_v509_0 (ref), v87 (ref), l_v478_0 (ref), l_v477_0 (ref), l_v480_0 (ref), l_min_0 (ref), l_v485_0 (ref), l_l_force_teleport_0_0 (ref), l_l_exploit_0_0 (ref), l_v517_0 (ref), v88 (ref), l_v476_0 (ref), v85 (ref), l_l_get_3_0 (ref)
            local l_location_2 = v471.location;
            local l_data_0 = v471.data;
            if l_data_0 == nil then
                l_data_0 = {};
                v471.data = l_data_0;
            end;
            if not l_data_0.state then
                l_data_0.state = l_v510_0;
            end;
            if l_l_settings_0_0.aimbot == "Rage" then
                v532.view_angles = l_location_2.viewangles;
            elseif l_data_0.state ~= l_v519_0 then
                v508(false);
                local l_viewangles_0 = l_location_2.viewangles;
                l_camera_angles_0(l_viewangles_0);
            end;
            local l_grenade_0 = l_location_2.grenade;
            local v540 = l_grenade_0 ~= nil and l_grenade_0.strength or 1;
            if l_data_0.state == l_v510_0 or l_data_0.state == l_v516_0 or l_data_0.state == l_v518_0 then
                if v540 == 0 then
                    local v541 = false;
                    v532.in_attack2 = true;
                    v532.in_attack = v541;
                elseif v540 == 0.5 then
                    local v542 = true;
                    v532.in_attack2 = true;
                    v532.in_attack = v542;
                else
                    local v543 = true;
                    v532.in_attack2 = false;
                    v532.in_attack = v543;
                end;
            end;
            local l_duck_0 = l_location_2.duck;
            if l_data_0.state ~= l_v519_0 then
                if v535 ~= l_location_2.weapon then
                    v507();
                    v471 = {};
                end;
                l_v509_0(v532);
                v532.in_duck = l_duck_0;
            end;
            local l_m_flDuckAmount_0 = v533.m_flDuckAmount;
            if l_duck_0 and l_m_flDuckAmount_0 ~= 1 or not l_duck_0 and l_m_flDuckAmount_0 ~= 0 then
                return;
            else
                if l_data_0.state == l_v510_0 and v534.m_flThrowStrength == v540 and v534.m_bPinPulled then
                    l_data_0.state = l_v516_0;
                    l_data_0.start_at = v532.command_number;
                end;
                v87(l_v478_0, false);
                if l_l_settings_0_0.force_defensive then
                    v87(l_v477_0, "Always on");
                    v87(l_v480_0, "Break LC");
                end;
                if l_data_0.state == l_v519_0 then
                    if l_data_0.recovery_yaw ~= nil then
                        if not l_data_0.recovery_start_at then
                            l_data_0.recovery_start_at = v532.command_number;
                        end;
                        local v546 = v532.in_forward or v532.in_back or v532.in_moveleft or v532.in_moveright or v532.in_jump;
                        local v547 = l_grenade_0 ~= nil and l_grenade_0.recovery_jump;
                        local v548 = l_min_0(32, l_data_0.run or 16) + 13 + (v547 and 10 or 0);
                        if v532.command_number - l_data_0.recovery_start_at >= 1.0E-10 or v546 then
                            v87(l_v485_0, true);
                            if l_l_settings_0_0.recovery_teleport and l_data_0.teleported == nil and not v546 then
                                l_l_force_teleport_0_0(l_l_exploit_0_0);
                                l_data_0.teleported = true;
                            end;
                        end;
                        if v546 then
                            v507();
                            v471 = {};
                        elseif l_data_0.recovery_start_at + v548 >= v532.command_number then
                            l_v509_0(v532);
                            v532.move_yaw = v532.view_angles.y + l_data_0.recovery_yaw + l_data_0.run_yaw;
                            v532.forwardmove = 450;
                            if v547 then
                                v532.in_jump = true;
                            end;
                        else
                            v507();
                            v471 = {};
                        end;
                    else
                        v507();
                        v471 = {};
                    end;
                end;
                if l_data_0.state == l_v516_0 or l_data_0.state == l_v517_0 or l_data_0.state == l_v518_0 then
                    local v549 = v532.command_number - l_data_0.start_at;
                    local v550 = l_grenade_0 ~= nil and l_grenade_0.run;
                    local v551 = l_grenade_0 ~= nil and l_grenade_0.run_yaw or 0;
                    local l_v550_0 = v550;
                    l_data_0.run_yaw = v551;
                    l_data_0.run = l_v550_0;
                    if (not v550 or v549 >= v550) and l_data_0.state == l_v516_0 then
                        l_data_0.state = l_v517_0;
                    end;
                    if v550 then
                        if v533.m_MoveType == 9 then
                            if l_data_0.run_yaw == -90 then
                                v532.in_moveright = true;
                            elseif l_data_0.run_yaw == 90 then
                                v532.in_moveleft = true;
                            elseif l_data_0.run_yaw == 180 or l_data_0.run_yaw == -180 then
                                v532.in_back = true;
                            else
                                v532.in_forward = true;
                            end;
                        else
                            v532.move_yaw = v532.view_angles.y + l_data_0.run_yaw;
                            v532.forwardmove = 450;
                            v532.in_forward = true;
                        end;
                        v532.in_speed = l_grenade_0 ~= nil and l_grenade_0.run_speed and 1 or 0;
                    end;
                end;
                if l_data_0.state == l_v517_0 then
                    if l_grenade_0 ~= nil and l_grenade_0.jump then
                        v532.in_jump = true;
                    end;
                    l_data_0.state = l_v518_0;
                    l_data_0.throw_at = v532.command_number;
                end;
                local v553 = l_grenade_0 ~= nil and l_grenade_0.delay or 0;
                local v554 = nil;
                if l_data_0.state == l_v518_0 then
                    local v555 = v88(l_v476_0);
                    if v555 == nil then
                        v555 = v85(l_v476_0);
                    end;
                    if l_l_get_3_0(l_l_exploit_0_0) == 1 and v555 then
                        v553 = v553 + 6;
                    end;
                    v554 = v532.command_number - l_data_0.throw_at;
                    if v553 - 3 <= v554 then
                        v87(l_v478_0, false);
                        v87(l_v477_0, "Disabled");
                        v87(l_v480_0, "Favor Fake Lag");
                    end;
                    if v553 <= v554 then
                        local v556 = false;
                        v532.in_attack2 = false;
                        v532.in_attack = v556;
                        l_data_0.recovery_yaw = l_grenade_0 and l_grenade_0.recovery_yaw and l_grenade_0.recovery_yaw or l_grenade_0 and (l_location_2.grenade.recovery_jump or l_location_2.grenade.jump) and 180;
                    end;
                end;
                if l_data_0.state == l_v518_0 then
                    if v553 < v554 then
                        l_data_0.thrown_at = v532.command_number;
                    end;
                    if v534.m_fThrowTime == 0 and l_data_0.thrown_at and l_data_0.thrown_at > l_data_0.throw_at then
                        l_data_0.state = l_v519_0;
                    end;
                end;
                return;
            end;
        end;
    end;
    v509 = nil;
    v510 = nil;
    v510 = {};
    v516 = "in_forward";
    v517 = "in_back";
    v518 = "F";
    v510[v517] = "B";
    v510[v516] = v518;
    v516 = "in_moveleft";
    v517 = "in_moveright";
    v518 = "L";
    v510[v517] = "R";
    v510[v516] = v518;
    v516 = "in_attack";
    v517 = "in_attack2";
    v518 = "A";
    v510[v517] = "Z";
    v510[v516] = v518;
    v516 = "in_jump";
    v517 = "in_duck";
    v518 = "J";
    v510[v517] = "D";
    v510[v516] = v518;
    v510.in_speed = "S";
    v510.in_use = "U";
    v516 = "F";
    v517 = "B";
    v518 = "in_forward";
    v510[v517] = "in_back";
    v510[v516] = v518;
    v516 = "L";
    v517 = "R";
    v518 = "in_moveleft";
    v510[v517] = "in_moveright";
    v510[v516] = v518;
    v516 = "A";
    v517 = "Z";
    v518 = "in_attack";
    v510[v517] = "in_attack2";
    v510[v516] = v518;
    v516 = "J";
    v517 = "D";
    v518 = "in_jump";
    v510[v517] = "in_duck";
    v510[v516] = v518;
    v510.S = "in_speed";
    v510.U = "in_use";
    do
        local l_v510_1, l_v516_1 = v510, v516;
        l_v516_1 = function(v559)
            -- upvalues: l_gmatch_0 (ref), l_lower_0 (ref), l_v510_1 (ref), l_upper_0 (ref)
            local v560 = {};
            local v561 = {};
            for v562 in l_gmatch_0(v559, ".") do
                if l_lower_0(v562) == v562 then
                    v561[#v561 + 1] = l_v510_1[l_upper_0(v562)] or false;
                else
                    v560[#v560 + 1] = l_v510_1[v562] or false;
                end;
            end;
            return v560, v561;
        end;
        v509 = function(v563)
            -- upvalues: v471 (ref), l_type_0 (ref), l_next_0 (ref), l_v510_1 (ref), l_unpack_0 (ref), l_v516_1 (ref), v507 (ref), l_vector_0 (ref), l_decode_0 (ref), v508 (ref), l_camera_angles_0 (ref)
            local l_location_3 = v471.location;
            local l_data_1 = v471.data;
            if not l_data_1 then
                v471.data = {};
                l_data_1 = v471.data;
            end;
            local l_frames_0 = l_data_1.frames;
            if l_frames_0 == nil then
                l_data_1.frames = {};
                l_frames_0 = l_data_1.frames;
                local l_frames_1 = l_location_3.movement.frames;
                for v568 = 1, #l_frames_1 do
                    local v569 = l_frames_1[v568];
                    if l_type_0(v569) == "number" then
                        if v569 > 0 then
                            for _ = 1, v569 do
                                l_frames_0[#l_frames_0 + 1] = {};
                            end;
                        end;
                    elseif l_type_0(v569) == "table" then
                        l_frames_0[#l_frames_0 + 1] = v569;
                    end;
                end;
                local l_viewangles_1 = l_location_3.viewangles;
                local v572 = {
                    viewangles = {
                        pitch = l_viewangles_1.x, 
                        yaw = l_viewangles_1.y
                    }, 
                    buttons = {}
                };
                for v573, _ in l_next_0, l_v510_1 do
                    v572.buttons[v573] = false;
                end;
                for v575 = 1, #l_frames_0 do
                    local v576 = l_frames_0[v575];
                    local v577, v578, v579, v580, v581 = l_unpack_0(v576);
                    v572.viewangles.pitch = v572.viewangles.pitch + (v577 or 0);
                    v572.viewangles.yaw = v572.viewangles.yaw + (v578 or 0);
                    if l_type_0(v579) == "string" then
                        local v582, v583 = l_v516_1(v579);
                        for v584 = 1, #v582 do
                            local v585 = v582[v584];
                            v572.buttons[v585] = true;
                        end;
                        for v586 = 1, #v583 do
                            local v587 = v583[v586];
                            v572.buttons[v587] = false;
                        end;
                    end;
                    v572.forwardmove = l_type_0(v580) == "number" and v580 >= -450 and v580 <= 450 and v580 or v572.buttons.in_forward and 450 or v572.buttons.in_back and -450 or 0;
                    v572.sidemove = l_type_0(v581) == "number" and v581 >= -450 and v581 <= 450 and v581 or v572.buttons.in_moveright and 450 or v572.buttons.in_moveleft and -450 or 0;
                    l_frames_0[v575] = {
                        pitch = v572.viewangles.pitch, 
                        yaw = v572.viewangles.yaw, 
                        move_yaw = v572.viewangles.yaw, 
                        forwardmove = v572.forwardmove, 
                        sidemove = v572.sidemove
                    };
                    for v588, v589 in l_next_0, v572.buttons do
                        l_data_1.frames[v575][v588] = v589;
                    end;
                end;
            end;
            if not l_data_1.start_at then
                l_data_1.start_at = v563.command_number;
            end;
            local v590 = l_frames_0[v563.command_number - l_data_1.start_at + 1];
            if not v590 then
                v507();
                v471 = {};
                return;
            else
                local v591 = l_vector_0(v590.pitch, v590.yaw, 0);
                if l_decode_0.settings.aimbot == "Rage" then
                    v563.view_angles = v591;
                else
                    v508(false);
                    l_camera_angles_0(v591);
                end;
                local l_in_attack_0 = v590.in_attack;
                v563.in_attack2 = v590.in_attack2;
                v563.in_attack = l_in_attack_0;
                v563.move_yaw = v590.move_yaw;
                v563.forwardmove = v590.forwardmove;
                v563.sidemove = v590.sidemove;
                v563.in_speed = v590.in_speed;
                v563.in_duck = v590.in_duck;
                v563.in_use = v590.in_use;
                v563.in_jump = v590.in_jump;
                return;
            end;
        end;
    end;
    v510 = function(v593)
        -- upvalues: v471 (ref), v507 (ref), v87 (ref), l_v484_0 (ref), l_v485_0 (ref), l_v489_0 (ref), l_v490_0 (ref), l_v488_0 (ref), l_v486_0 (ref), l_v487_0 (ref), l_vector_0 (ref), l_decode_0 (ref), v508 (ref), l_camera_angles_0 (ref)
        local l_location_4 = v471.location;
        local l_data_2 = v471.data;
        if not l_data_2 then
            v471.data = {};
            l_data_2 = v471.data;
        end;
        if not l_data_2.start_at then
            l_data_2.start_at = v593.command_number;
        end;
        local v596 = v593.command_number - l_data_2.start_at + 1;
        local v597 = l_location_4.movement.steps[v596];
        if not v597 then
            v507();
            v471 = {};
            return;
        else
            v87(l_v484_0, false);
            v87(l_v485_0);
            v87(l_v489_0, true);
            v87(l_v490_0, false);
            local l_strafer_0 = l_location_4.strafer;
            if l_strafer_0 ~= nil then
                v87(l_v488_0, l_strafer_0.quick_stop);
                v87(l_v485_0, l_strafer_0.air_strafe);
                v87(l_v486_0, l_strafer_0.wasd_strafer);
                v87(l_v487_0, l_strafer_0.strafer_smoothing);
            end;
            local l_viewangles_2 = v597.viewangles;
            l_viewangles_2 = l_vector_0(l_viewangles_2[1], l_viewangles_2[2], 0);
            if l_decode_0.settings.aimbot == "Rage" then
                v593.view_angles = l_viewangles_2;
            else
                v508(false);
                l_camera_angles_0(l_viewangles_2);
            end;
            v593.move_yaw = v597.move_yaw;
            local l_forwardmove_0 = v597.forwardmove;
            if l_forwardmove_0 then
                v593.forwardmove = l_forwardmove_0;
            end;
            local l_sidemove_0 = v597.sidemove;
            if l_sidemove_0 then
                v593.sidemove = l_sidemove_0;
            end;
            local v602 = v597.buttons or {};
            if v593.in_attack or v593.in_attack2 or v602.in_attack or v602.in_attack2 then
                l_data_2.is_attack = true;
            end;
            if l_data_2.is_attack then
                local v603 = v602.in_attack or false;
                v593.in_attack2 = v602.in_attack2 or false;
                v593.in_attack = v603;
            end;
            v593.in_forward = v602.in_forward or false;
            v593.in_moveleft = v602.in_moveleft or false;
            v593.in_moveright = v602.in_moveright or false;
            v593.in_back = v602.in_back or false;
            v593.in_speed = v602.in_speed or false;
            v593.in_duck = v602.in_duck or false;
            v593.in_use = v602.in_use or false;
            v593.in_jump = v602.in_jump or false;
            return;
        end;
    end;
    do
        local l_v513_0, l_v509_1, l_v510_2 = v513, v509, v510;
        v512 = function(v607, v608, v609, v610, v611)
            -- upvalues: v87 (ref), l_v481_0 (ref), l_v482_0 (ref), l_v484_0 (ref), l_v485_0 (ref), l_v489_0 (ref), l_v490_0 (ref), l_v509_1 (ref), l_v510_2 (ref), l_v513_0 (ref)
            if v607 == nil then
                return;
            else
                v608.jitter_move = false;
                v87(l_v481_0, false);
                v87(l_v482_0, false);
                v87(l_v484_0, false);
                v87(l_v485_0, false);
                v87(l_v489_0, false);
                v87(l_v490_0, false);
                local l_movement_0 = v607.movement;
                if l_movement_0 ~= nil then
                    if l_movement_0.frames ~= nil then
                        return l_v509_1(v608);
                    else
                        return l_v510_2(v608);
                    end;
                else
                    l_v513_0(v608, v609, v610, v611);
                    return;
                end;
            end;
        end;
    end;
    v513 = nil;
    v509 = l_vector_0(0, 0, 64);
    v510 = l_vector_0(0, 0, 6);
    do
        local l_v509_2, l_v510_3, l_v516_2 = v509, v510, v516;
        l_v516_2 = function(v616, v617)
            -- upvalues: l_l_customization_0_0 (ref), v438 (ref), l_type_0 (ref), l_vector_0 (ref), v71 (ref), l_v509_2 (ref), v72 (ref), l_tostring_0 (ref), l_remove_0 (ref)
            local v618 = l_l_customization_0_0.hide_duplicates and not v438;
            local v619 = {};
            for v620 = v617, 1, -1 do
                local v621 = v616[v620];
                local l_name_0 = v621.name;
                if l_type_0(l_name_0) == "table" then
                    v621.name = l_name_0[2] or l_name_0;
                end;
                local l_position_0 = v621.position;
                if l_type_0(l_position_0) == "table" then
                    l_position_0 = l_vector_0(l_position_0[1], l_position_0[2], l_position_0[3]);
                    v621.position = l_position_0;
                    v621.render_position = v71(l_position_0);
                end;
                local l_viewangles_3 = v621.viewangles;
                if l_type_0(l_viewangles_3) == "table" then
                    l_viewangles_3 = l_vector_0(l_viewangles_3[1], l_viewangles_3[2]);
                    v621.viewangles = l_viewangles_3;
                    v621.viewangles_forward = l_position_0 + l_v509_2 + v72(l_vector_0(), l_viewangles_3) * 700;
                end;
                v621.in_fov_select = 0;
                v621.on_screen = 0;
                if v618 then
                    local v625 = l_tostring_0(v621.position) .. l_tostring_0(v621.viewangles);
                    if v619[v625] ~= nil then
                        l_remove_0(v616, v620);
                    else
                        v619[v625] = true;
                    end;
                end;
            end;
        end;
        v513 = function(v626, v627, v628)
            -- upvalues: v437 (ref), l_v516_2 (ref), v75 (ref), l_remove_0 (ref), l_v510_3 (ref), l_concat_0 (ref), l_gsub_0 (ref), l_measure_text_0 (ref)
            if v437[v628] ~= nil then
                return;
            else
                l_v516_2(v626, v627);
                for v629 = 1, v627 do
                    local v630 = v626[v629];
                    if v630 ~= nil then
                        local l_render_position_0 = v630.render_position;
                        local l_l_render_position_0_0 = l_render_position_0;
                        local v633 = {
                            [1] = v630
                        };
                        for v634 = v627, v629 + 1, -1 do
                            local v635 = v626[v634];
                            if v635 ~= nil then
                                local l_render_position_1 = v635.render_position;
                                if v75(l_render_position_0, l_render_position_1) <= 20 then
                                    l_l_render_position_0_0 = l_l_render_position_0_0 + l_render_position_1;
                                    v633[#v633 + 1] = v635;
                                    l_remove_0(v626, v634);
                                end;
                            end;
                        end;
                        l_l_render_position_0_0 = l_l_render_position_0_0 / #v633;
                        local v637 = {
                            viewangles_alpha = 0, 
                            distance_width = 0, 
                            visible_alpha = 0, 
                            weapon = v630.weapon, 
                            position = l_l_render_position_0_0, 
                            world_position = l_l_render_position_0_0 + l_v510_3
                        };
                        local v638 = {};
                        local v639 = false;
                        local v640 = false;
                        local v641 = #v633;
                        for v642 = 1, v641 do
                            local v643 = v633[v642];
                            local l_name_1 = v643.name;
                            if v643.editing then
                                v638[#v638 + 1] = "<editing>" .. l_name_1;
                                v640 = true;
                                if v641 == 1 then
                                    v639 = true;
                                end;
                            else
                                v638[#v638 + 1] = l_name_1;
                            end;
                            v637[v642] = v643;
                        end;
                        v638 = l_concat_0(v638, "\aDEFAULT\n");
                        local v645 = l_gsub_0(v638, "<editing>", "");
                        v645 = l_measure_text_0(1, nil, v645);
                        v637.text = v638;
                        local l_x_0 = v645.x;
                        v637.height = v645.y;
                        v637.width = l_x_0;
                        l_x_0 = v639;
                        v637.is_have_editing = v640;
                        v637.is_one_editing = l_x_0;
                        v626[v629] = v637;
                    end;
                end;
                v437[v628] = true;
                return;
            end;
        end;
    end;
    v509 = nil;
    v510 = {};
    v516 = nil;
    v517 = nil;
    v518 = function(v647, v648)
        return v647.distance > v648.distance;
    end;
    do
        local l_v510_4, l_v516_3, l_v517_1, l_v518_1, l_v519_1 = v510, v516, v517, v518, v519;
        l_v519_1 = function(v654, v655, v656)
            -- upvalues: l_sort_0 (ref), l_v518_1 (ref), v472 (ref), v473 (ref), v75 (ref), v211 (ref)
            l_sort_0(v654, l_v518_1);
            local v657 = v654[v655];
            v473 = 1;
            v472 = v657;
            if v472 == nil then
                return;
            else
                v657 = v75(v656, v472.position);
                if v657 > 30 then
                    v472 = nil;
                    return;
                else
                    v473 = 0.4 + v211(v657, 0, 0.6, 30);
                    return;
                end;
            end;
        end;
        v509 = function(v658, v659, v660, v661)
            -- upvalues: l_v516_3 (ref), l_map_patterns_1 (ref), v409 (ref), v408 (ref), l_v517_1 (ref), v513 (ref), l_globals_0 (ref), l_v510_4 (ref), v75 (ref), v212 (ref), l_trace_line_0 (ref), l_v519_1 (ref)
            if l_v516_3 ~= v660 then
                l_v516_3 = v660;
                l_map_patterns_1 = nil;
            end;
            if l_map_patterns_1 == nil then
                local v662 = v408[v660] or false;
                v409 = {};
                l_map_patterns_1 = v662;
                if l_map_patterns_1 then
                    for v663 = 1, #l_map_patterns_1 do
                        local v664 = l_map_patterns_1[v663];
                        v664.visible_alpha = 0;
                        v664.distance_width = 0;
                        v664.viewangles_alpha = 0;
                    end;
                end;
                l_v517_1 = 0;
            end;
            if not l_map_patterns_1 then
                return;
            else
                local v665 = #l_map_patterns_1;
                if v665 == 0 then
                    return;
                else
                    v513(l_map_patterns_1, v665, v660);
                    v665 = #l_map_patterns_1;
                    local l_realtime_0 = l_globals_0.realtime;
                    if l_v517_1 + 0.07 < l_realtime_0 then
                        l_v517_1 = l_realtime_0;
                        local v667 = {};
                        l_v510_4 = {};
                        v409 = v667;
                        for v668 = 1, v665 do
                            local v669 = l_map_patterns_1[v668];
                            local v670 = v75(v659, v669.position);
                            v669.distance = v670;
                            if v670 <= 1500 then
                                v409[#v409 + 1] = v669;
                                if v670 <= 50 then
                                    l_v510_4[#l_v510_4 + 1] = v669;
                                end;
                                v669.distance_alpha = v212(1 - v670 / 1500, 0, 1, 1);
                                v669.is_visible = l_trace_line_0(v661, v669.world_position, v658, 33570827).fraction > 0.97;
                                v669.in_range = v670 <= 650;
                            else
                                v669.distance_width = 0;
                                v669.in_range = false;
                            end;
                        end;
                        return l_v519_1(v409, #v409, v659);
                    else
                        v665 = #l_v510_4;
                        if v665 == 0 then
                            return;
                        else
                            for v671 = 1, v665 do
                                local v672 = l_v510_4[v671];
                                if v672.distance > 30 then
                                    v672.distance = v75(v659, v672.position);
                                    for v673 = 1, #v672 do
                                        local v674 = v672[v673];
                                        v674.in_fov_select = 0;
                                        v674.on_screen = 0;
                                    end;
                                end;
                            end;
                            l_v519_1(l_v510_4, v665, v659);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
    v440 = function(v675)
        -- upvalues: l_get_local_player_0 (ref), v508 (ref), v507 (ref), v471 (ref), l_map_patterns_1 (ref), l_read_0 (ref), l_camera_position_0 (ref), v509 (ref), l_l_settings_0_0 (ref), v85 (ref), v470 (ref), v75 (ref), v76 (ref), v73 (ref), l_band_0 (ref), v87 (ref), l_v481_0 (ref), l_v482_0 (ref), l_bor_0 (ref), v78 (ref), v72 (ref), l_clamp_0 (ref), l_min_0 (ref), l_max_0 (ref), l_v488_0 (ref), l_globals_0 (ref), l_camera_angles_0 (ref), l_normalize_yaw_0 (ref), l_abs_0 (ref), v77 (ref), l_vector_0 (ref), v512 (ref)
        local v676 = l_get_local_player_0();
        if v676 == nil or not v676:is_alive() then
            v508(true);
            v507();
            v471 = {};
            l_map_patterns_1 = nil;
            return;
        else
            local v677, v678 = l_read_0(v676);
            if v677 == nil then
                return;
            else
                local v679 = v676:get_origin();
                local v680 = l_camera_position_0();
                v509(v676, v679, v678, v680);
                local v681 = l_l_settings_0_0.aimbot == "Legit";
                local l_location_5 = v471.location;
                if not v85(l_l_settings_0_0.hotkey) then
                    if v681 or v470 ~= nil or l_location_5 ~= nil then
                        v507();
                        v508(true);
                    end;
                    v471 = {};
                    return;
                else
                    if v470 ~= nil then
                        v507();
                    end;
                    if v470 ~= nil and l_location_5 == nil then
                        local l_position_1 = v470.position;
                        local v684 = v75(v679, l_position_1);
                        local v685 = v76(v679, l_position_1);
                        if v685 < 0.5 and v684 > 0.08 and v684 < 5 then
                            v684 = v685;
                        end;
                        local v686 = v73(v676.m_vecAbsVelocity);
                        local v687 = l_band_0(v676.m_fFlags, 1) == 1;
                        local v688 = v676.m_MoveType == 9;
                        local v689 = v675.in_forward or v675.in_back or v675.in_moveleft or v675.in_moveright or v675.in_jump or not v688 and not v687;
                        local l_on_position_0 = v470.on_position;
                        if not l_on_position_0 and not v689 then
                            v87(l_v481_0, false);
                            v87(l_v482_0, false);
                            v675.jitter_move = false;
                            v675.sidemove = 0;
                            local v691 = false;
                            v675.in_moveright = false;
                            v675.in_moveleft = v691;
                            if v688 then
                                v691 = l_position_1.z - v679.z;
                                local v692 = l_position_1.y - v679.y;
                                local v693 = v691 > 0.5 or v691 < -0.5;
                                local v694 = v692 > 0.5 or v692 < -0.5;
                                if v693 then
                                    v675.buttons = v691 > 0 and l_bor_0(v675.buttons, 8) or l_bor_0(v675.buttons, 16);
                                end;
                                if v694 then
                                    v675.buttons = v692 > 0 and l_bor_0(v675.buttons, 512) or l_bor_0(v675.buttons, 1024);
                                end;
                                if v693 or v694 then
                                    v675.in_speed = true;
                                    v675.in_duck = true;
                                end;
                            else
                                local v695 = l_position_1 + v78(l_position_1 - v679) * 10 - v679;
                                v675.move_yaw = v72(v695).y;
                                v675.in_speed = false;
                                if v684 > 14 then
                                    v675.forwardmove = 450;
                                else
                                    local l_m_flDuckAmount_1 = v676.m_flDuckAmount;
                                    local v697 = l_clamp_0(1.1 + l_m_flDuckAmount_1 * 10, v684 * 9, 450);
                                    if l_min_0(250, v697) + 15 <= v686 then
                                        v675.forwardmove = 0;
                                        v675.in_forward = false;
                                    else
                                        v675.forwardmove = l_max_0(6, l_min_0(250, v697) <= v686 and v697 * 0.9 or v697);
                                        v675.in_forward = true;
                                        if v684 < 1 then
                                            v87(l_v488_0, false);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        if v470.weapon ~= "weapon_wallbang" then
                            if v675.in_attack or v675.in_attack2 then
                                local v698 = v470.grenade and v470.grenade.strength;
                                if v698 == 0 then
                                    local v699 = false;
                                    v675.in_attack2 = true;
                                    v675.in_attack = v699;
                                elseif v698 == 0.5 then
                                    local v700 = true;
                                    v675.in_attack2 = true;
                                    v675.in_attack = v700;
                                else
                                    local v701 = true;
                                    v675.in_attack2 = false;
                                    v675.in_attack = v701;
                                end;
                            end;
                            local v702 = l_l_settings_0_0.automatic_throw and l_globals_0.curtime > v676.m_flNextAttack or v470.movement and v675.in_attack or v675.in_attack2 or v677.m_bPinPulled;
                            if l_on_position_0 and v702 and v686 < 2 then
                                if v681 then
                                    local v703 = l_camera_angles_0();
                                    local v704 = v703 - v470.viewangles;
                                    v704.y = l_normalize_yaw_0(v704.y);
                                    local l_x_1 = v704.x;
                                    local l_y_0 = v704.y;
                                    local v707 = l_abs_0(v77(v704));
                                    local l_fov_0 = l_l_settings_0_0.fov;
                                    local l_smooth_0 = l_l_settings_0_0.smooth;
                                    if v707 <= l_fov_0 then
                                        local v710 = l_min_0(1, v707 / 3) * 0.5;
                                        local v711 = (v710 + l_abs_0(v707 * (1 - v710))) * l_globals_0.frametime * l_smooth_0;
                                        v508(false);
                                        l_camera_angles_0(l_vector_0(v703.x - l_x_1 / v707 * v711, v703.y - l_y_0 / v707 * v711, 0));
                                    end;
                                end;
                                if v470.is_on_fov then
                                    v471.location = v470;
                                end;
                            end;
                            if (v675.in_attack or v675.in_attack2) and v470.movement ~= nil then
                                local v712 = false;
                                v675.in_attack2 = false;
                                v675.in_attack = v712;
                            end;
                        end;
                    elseif v681 then
                        v508(true);
                    end;
                    v512(l_location_5, v675, v676, v677, v678);
                    return;
                end;
            end;
        end;
    end;
    v510 = -1;
    v516 = l_events_0.createmove;
    v517 = function()
        -- upvalues: l_execute_after_0 (ref), v517 (ref), v516 (ref), v510 (ref), v440 (ref)
        l_execute_after_0(1, v517);
        local v713 = #v516;
        if v510 == v713 then
            return;
        else
            v510 = v713;
            v516(v440, false);
            v516(v440, true);
            return;
        end;
    end;
    v517();
end;
l_settings_0 = nil;
l_customization_0 = l_decode_0.settings;
v476 = l_decode_0.customization;
v477 = l_dist_0(16, 16, 16, 255);
v478 = l_dist_0(255, 245, 5);
v479 = l_dist_0(20, 236, 0);
v480 = l_dist_0(140, 255);
v481 = l_dist_0(255, 16, 16);
v482 = nil;
v483 = nil;
v483 = utils.get_vfunc("engine.dll", "VEngineClient014", 37, "struct { float m[4][4]; } & (__thiscall*)(void*)");
v484 = function(v714, v715, v716, v717, v718, v719, v720, v721)
    local v722 = v714 * v717 - v715 * v716;
    local v723 = v718 * v721 - v719 * v720;
    local v724 = (v714 - v716) * (v719 - v721) - (v715 - v717) * (v718 - v720);
    return (v722 * (v718 - v720) - (v714 - v716) * v723) / v724, (v722 * (v719 - v721) - (v715 - v717) * v723) / v724;
end;
v485 = v91.x;
v486 = v91.y;
v487 = l_get_2.x;
v488 = l_get_2.y;
do
    local l_v484_1, l_v485_1, l_v486_1, l_v487_1, l_v488_1 = v484, v485, v486, v487, v488;
    v482 = function(v730, v731, v732)
        -- upvalues: l_v485_1 (ref), l_v487_1 (ref), l_v486_1 (ref), l_v488_1 (ref), l_atan2_0 (ref), l_max_0 (ref), l_cos_0 (ref), l_sin_0 (ref), l_v484_1 (ref), l_vector_0 (ref)
        local l_x_2 = v731.x;
        local l_y_1 = v731.y;
        local l_z_0 = v731.z;
        local l_m_0 = v730.m;
        local v737 = l_m_0[0];
        local v738 = l_m_0[1];
        local v739 = l_m_0[3];
        local v740 = v737[0] * l_x_2 + v737[1] * l_y_1 + v737[2] * l_z_0 + v737[3];
        local v741 = v738[0] * l_x_2 + v738[1] * l_y_1 + v738[2] * l_z_0 + v738[3];
        l_z_0 = v739[0] * l_x_2 + v739[1] * l_y_1 + v739[2] * l_z_0 + v739[3];
        l_y_1 = v741;
        l_x_2 = v740;
        v740 = l_z_0 >= 0.001;
        v741 = (v740 and 1 or -1) / l_z_0;
        local v742 = l_x_2 * v741;
        l_y_1 = l_y_1 * v741;
        v742 = l_v485_1 + (0.5 * v742 * l_v487_1 + 0.5);
        l_y_1 = l_v486_1 - (0.5 * l_y_1 * l_v488_1 + 0.5);
        l_x_2 = v742;
        if not v740 or l_x_2 < v732 or l_v487_1 - v732 < l_x_2 or l_y_1 < v732 or l_v488_1 - v732 < l_y_1 then
            if not v740 then
                v742 = l_atan2_0(l_y_1 - l_v486_1, l_x_2 - l_v485_1);
                local v743 = l_max_0(l_v487_1, l_v488_1);
                local v744 = l_v485_1 + v743 * l_cos_0(v742);
                l_y_1 = l_v486_1 + v743 * l_sin_0(v742);
                l_x_2 = v744;
            end;
            v742 = {
                [1] = v732, 
                [2] = v732, 
                [3] = l_v487_1 - v732, 
                [4] = v732, 
                [5] = l_v487_1 - v732, 
                [6] = v732, 
                [7] = l_v487_1 - v732, 
                [8] = l_v488_1 - v732, 
                [9] = v732, 
                [10] = v732, 
                [11] = v732, 
                [12] = l_v488_1 - v732, 
                [13] = v732, 
                [14] = l_v488_1 - v732, 
                [15] = l_v487_1 - v732, 
                [16] = l_v488_1 - v732
            };
            for v745 = 1, 16, 4 do
                local v746 = v742[v745];
                local v747 = v742[v745 + 1];
                local v748 = v742[v745 + 2];
                local v749 = v742[v745 + 3];
                local v750, v751 = l_v484_1(v746, v747, v748, v749, l_v485_1, l_v486_1, l_x_2, l_y_1);
                if v745 == 1 and l_y_1 < v732 and v732 <= v750 and v750 <= l_v487_1 - v732 or v745 == 5 and l_v487_1 - v732 < l_x_2 and v732 <= v751 and v751 <= l_v488_1 - v732 or v745 == 9 and l_x_2 < v732 and v732 <= v751 and v751 <= l_v488_1 - v732 or v745 == 13 and l_v488_1 - v732 < l_y_1 and v732 <= v750 and v750 <= l_v487_1 - v732 then
                    return l_vector_0(v750, v751), false;
                end;
            end;
            return l_vector_0(l_x_2, l_y_1), false;
        else
            return l_vector_0(l_x_2, l_y_1), true;
        end;
    end;
end;
v484 = render.load_font("calibri", 11, "abd");
v485 = nil;
v486 = nil;
v485 = {
    weapon_smokegrenade = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\smokegrenade.svg"), 
    weapon_flashbang = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\flashbang.svg"), 
    weapon_decoy = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\decoy.svg"), 
    weapon_hegrenade = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\hegrenade.svg"), 
    weapon_molotov = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\molotov.svg"), 
    weapon_wallbang = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\bullet.svg"), 
    weapon_knife = render.load_image("<?xml version='1.0' encoding='UTF-8' standalone='no'?>\n<svg xmlns:svg='http://www.w3.org/2000/svg' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 158 200' height='200mm' width='158mm'>\n<g style='mix-blend-mode:normal'>\n<path d='m 27.692726,195.58287 c -2.00307,-2.00307 -2.362731,-5.63696 -1.252001,-12.64982 .51631,-3.25985 .938744,-6.15692 .938744,-6.43794 0,-.28102 -1.054647,-.68912 -2.343659,-.9069 -1.289012,-.21778 -2.343659,-.46749 -2.343659,-.55491 0,-.0874 .894568,-2.10761 1.987932,-4.48934 4.178194,-9.10153 7.386702,-22.1671 7.386702,-3.07983 v -3.57114 l -3.439063,-.65356 c -7.509422,-1.42712 -14.810239,-6.3854 -17.132592,-11.63547 -.617114,-1.39509 -1.6652612,-5.2594 -2.3292172,-8.58736 -.894299,-4.48252 -1.742757,-6.93351 -3.273486,-9.45625 -2.296839,-3.78538 -2.316583,-5.11371 -.151099,-1.165583 .632785,-1.47622 2.428356,-7.85932 3.990157,-14.18467 2.3650332,-9.578444 3.4874882,-12.902312 6.7157522,-19.887083 5.153317,-11.149867 5.357987,-11.987895 3.936721,-16.118875 -1.318135,-3.831228 -1.056436,-5.345174 1.69769,-9.821193 .98924,-1.607722 2.121218,-4.129295 2.515508,-5.6035 C 25.28429,28.210324 25.23258,27.949807 23.35135,24.502898 21.710552,21.496527 21.306782,19.993816 2.889474,15.340532 2.614927,12.279129 2.380889,8.4556505 2.369393,6.8439185 l -.02091,-2.930428 9.333915,.83216 9.333914,.832161 .415652,4.4356115 c .228605,2.439587 .232248,9.481725 .0081,15.649196 l -.407561,11.213581 3.401641,.387936 c 1.8709,.213363 4.456285,.528941 5.745297,.701283 l 2.343658,.31335 .01922,-4.58462 c .01523,-3.630049 .300834,-5.120017 1.371678,-7.156027 3.087768,-5.870826 9.893488,-1.61208 17.039741,-11.87087 2.720173,-.479148 4.160963,-.409507 7.136663,.344951 8.66897,2.197927 13.98192,9.621168 13.98192,19.535491 0,3.495649 -.1404,3.901096 -1.99211,5.752805 -1.24394,1.243942 -2.56423,1.992111 -3.51549,1.992111 -1.49731,0 -1.52337,.07107 -1.52337,4.153986 v 4.15399 l 8.9352,-.237138 c 5.2858,-.140285 11.170779,-.674802 14.408789,-1.308719 l 5.4736,-1.071577 -.38275,-2.552314 c -.37145,-2.476984 -.33603,-2.552315 1.19984,-2.552315 .87041,0 1.91062,-.448636 2.31157,-.996969 .68332,-.93449 1.27483,-.910186 9.43922,.387872 4.86768,.773912 12.32893,1.486871 16.91304,1.616118 4.51154,.127203 8.93123,.513358 9.82152,.858128 2.24255,.86843 2.71036,3.071333 1.03169,4.858196 -2.36272,2.515004 -4.22494,2.914196 -9.65444,2.069567 -6.49602,-1.010535 -9.48434,-.608226 -12.89073,1.735433 -1.51944,1.045409 -3.78166,2.037422 -5.02716,2.204478 -2.12756,.285364 -2.24441,.404325 -1.93193,1.966706 .54423,2.721143 -.2472,4.489222 -3.68173,8.225132 -3.77119,4.102112 -4.63155,5.89093 -5.49449,11.423793 -.94965,6.08886 -1.57396,7.52473 -5.32281,12.24226 -5.48499,6.90229 -11.865029,11.373083 -16.271159,11.401983 -2.96514,.0195 -5.44164,-1.427403 -1.64598,-6.219683 -6.09285,-5.61044 -11.509723,-9.58715 -13.059111,-9.58715 -.74413,0 -2.728788,1.56375 -5.069514,3.99435 -2.115662,2.19689 -4.279795,4.24027 -4.809188,4.54084 -.873942,.49619 -.888303,.97152 -.156034,5.16456 .443574,2.539953 1.213393,5.239093 1.710714,5.998093 1.234397,1.88393 4.464204,3.43033 1.249847,4.90755 11.894956,3.03704 24.227356,12.17082 28.700056,21.25618 3.277059,6.65665 3.756559,14.90456 1.06537,18.32585 -2.00495,2.54888 -4.71703,3.29933 -13.73034,3.79931 -12.02449,.66702 -11.43259,.30042 -25.191149,15.60203 -3.539415,3.93635 -4.947788,5.02545 -9.098134,7.03552 -6.030466,2.92066 -8.127669,5.18229 -9.759102,1.52427 -1.407053,4.60727 -3.889283,7.93618 -7.163048,9.60633 -3.066476,1.56439 -5.550268,1.48363 -7.270304,-.2364 z M 99.119321,71.201503 c 3.729129,-4.724307 6.662059,-8.707839 6.517599,-8.852305 -.14446,-.144451 -2.7777,1.571678 -5.851649,3.813635 -4.38891,3.20102 -6.56642,4.363275 -1.1411,5.412849 -2.50365,.73511 -4.68393,1.459682 -4.84506,1.610152 -.31664,.295703 6.47662,6.567603 7.13899,6.591103 .22054,.008 3.4521,-3.85113 7.18122,-8.575434 z' style='fill:#ffffff;fill-opacity:1;stroke:none;stroke-width:.585916;stroke-opacity:1' />\n</g>\n</svg>\n", l_vector_0(26, 26))
};
v487 = {
    [1] = 0, 
    [2] = 0, 
    [3] = 0, 
    [4] = 0
};
v488 = {
    [v485.weapon_smokegrenade] = {
        [1] = 0.2, 
        [2] = -0.1, 
        [3] = 0.35, 
        [4] = 0
    }, 
    [v485.weapon_hegrenade] = {
        [1] = 0.1, 
        [2] = -0.12, 
        [3] = 0.2, 
        [4] = 0
    }, 
    [v485.weapon_molotov] = {
        [1] = 0, 
        [2] = -0.04, 
        [3] = 0, 
        [4] = 0
    }, 
    [v485.weapon_knife] = {
        [1] = 0, 
        [2] = 0, 
        [3] = -0.2, 
        [4] = 0
    }
};
do
    local l_v487_2, l_v488_2 = v487, v488;
    v486 = l_setmetatable_0({}, {
        __index = function(v754, v755)
            -- upvalues: l_v488_2 (ref), l_v487_2 (ref), l_setmetatable_0 (ref), l_vector_0 (ref), l_tostring_0 (ref)
            local v756 = l_v488_2[v755] or l_v487_2;
            v754[v755] = l_setmetatable_0({}, {
                __index = function(v757, v758)
                    -- upvalues: v755 (ref), v756 (ref), l_vector_0 (ref), l_tostring_0 (ref)
                    local v759 = v755.width * v758 / v755.height;
                    local l_v758_0 = v758;
                    local v761 = v756[1] * v759;
                    local v762 = v756[2] * l_v758_0;
                    local v763 = {
                        v759 + v756[3] * v759, 
                        l_v758_0 + v756[4] * l_v758_0, 
                        v761, 
                        v762, 
                        l_vector_0(v759, l_v758_0)
                    };
                    if l_tostring_0(v763[1]) ~= "nan" then
                        v757[v758] = v763;
                    end;
                    return v763;
                end
            });
            return v754[v755];
        end
    });
end;
v487 = function(v764, v765)
    return v764.fov > v765.fov;
end;
do
    local l_l_customization_0_1, l_v476_1, l_v477_1, l_v478_1, l_v479_0, l_v480_1, l_v481_1, l_v482_1, l_v483_1, l_v484_2, l_v485_2, l_v486_2, l_v487_3 = l_customization_0, v476, v477, v478, v479, v480, v481, v482, v483, v484, v485, v486, v487;
    l_settings_0 = function()
        -- upvalues: v470 (ref), l_get_local_player_0 (ref), l_map_patterns_1 (ref), v409 (ref), l_v476_1 (ref), l_l_customization_0_1 (ref), l_globals_0 (ref), v471 (ref), v472 (ref), v473 (ref), l_min_0 (ref), l_max_0 (ref), v211 (ref), v213 (ref), v74 (ref), l_v481_1 (ref), l_v485_2 (ref), l_floor_0 (ref), l_v486_2 (ref), l_vector_0 (ref), l_v477_1 (ref), l_rect_0 (ref), l_rect_outline_0 (ref), l_gsub_0 (ref), v82 (ref), l_push_clip_rect_0 (ref), l_text_0 (ref), l_pop_clip_rect_0 (ref), l_texture_0 (ref), v214 (ref), l_camera_angles_0 (ref), l_normalize_yaw_0 (ref), l_abs_0 (ref), v77 (ref), v75 (ref), v76 (ref), l_sort_0 (ref), l_v487_3 (ref), l_v483_1 (ref), l_v482_1 (ref), l_measure_text_0 (ref), l_v484_2 (ref), v70 (ref), l_upper_0 (ref), l_get_2 (ref), v215 (ref), l_circle_0 (ref), v216 (ref), v81 (ref), l_v478_1 (ref), l_v479_0 (ref), l_v480_1 (ref), l_circle_outline_0 (ref)
        v470 = nil;
        local v779 = l_get_local_player_0();
        if v779 == nil or not v779:is_alive() then
            return;
        elseif not l_map_patterns_1 then
            return;
        else
            local v780 = #v409;
            if v780 == 0 then
                return;
            else
                local l_color_0 = l_v476_1.color;
                local l_alpha_0 = l_v476_1.alpha;
                local l_show_behind_walls_0 = l_v476_1.show_behind_walls;
                local l_hide_icon_with_text_0 = l_v476_1.hide_icon_with_text;
                local l_aimbot_0 = l_l_customization_0_1.aimbot;
                local l_fov_1 = l_l_customization_0_1.fov;
                if l_aimbot_0 ~= "Rage" then
                    l_fov_1 = 0.3;
                end;
                local l_frametime_0 = l_globals_0.frametime;
                local l_location_6 = v471.location;
                for v789 = 1, v780 do
                    local v790 = v409[v789];
                    local v791 = v790 == v472;
                    if not v791 then
                        v790.viewangles_alpha = 0;
                    end;
                    local v792 = v790.in_range and (v473 > 0.5 or v791);
                    local l_distance_width_0 = v790.distance_width;
                    if v792 and l_distance_width_0 < 1 then
                        l_distance_width_0 = l_min_0(1, l_distance_width_0 + l_frametime_0 * 6);
                    elseif not v792 and l_distance_width_0 > 0 then
                        l_distance_width_0 = l_max_0(0, l_distance_width_0 - l_frametime_0 * 6);
                    end;
                    v790.distance_width = l_distance_width_0;
                    l_distance_width_0 = v211(l_distance_width_0, 0, 1, 1);
                    local l_visible_alpha_0 = v790.visible_alpha;
                    local l_is_visible_0 = v790.is_visible;
                    local v796 = l_show_behind_walls_0 and l_distance_width_0 > 0 and 0.45 or 0;
                    local v797 = (not (l_show_behind_walls_0 and l_distance_width_0 > 0) or l_is_visible_0) and 1 or 0.33;
                    if l_is_visible_0 and l_visible_alpha_0 < 1 or l_visible_alpha_0 < v796 then
                        l_visible_alpha_0 = l_min_0(1, l_visible_alpha_0 + l_frametime_0 * 5.5 * v797);
                    elseif not l_is_visible_0 and v796 < l_visible_alpha_0 then
                        l_visible_alpha_0 = l_max_0(v796, l_visible_alpha_0 - l_frametime_0 * 7.5 * v797);
                    end;
                    local v798 = l_location_6 == v790 and 1 or v790.distance_alpha;
                    v790.visible_alpha = l_visible_alpha_0;
                    l_visible_alpha_0 = v213(l_visible_alpha_0, 0, 1, 1) * (v791 and 1 or v473) * v798;
                    if l_visible_alpha_0 > 0 then
                        local v799 = v74(v790.world_position);
                        if v799 ~= nil then
                            local l_x_3 = v799.x;
                            local l_y_2 = v799.y;
                            l_visible_alpha_0 = l_alpha_0 * l_visible_alpha_0;
                            local v802 = 255 * l_visible_alpha_0;
                            local l_l_color_0_0 = l_color_0;
                            l_l_color_0_0.a = v802;
                            local l_is_have_editing_0 = v790.is_have_editing;
                            if l_is_have_editing_0 then
                                l_v481_1.a = v802;
                                if v790.is_one_editing then
                                    l_l_color_0_0 = l_v481_1;
                                end;
                            end;
                            local l_width_0 = v790.width;
                            local l_height_0 = v790.height;
                            if l_distance_width_0 < 1 then
                                local v807 = l_width_0 * l_distance_width_0;
                                l_height_0 = l_height_0 * l_distance_width_0;
                                l_width_0 = v807;
                            end;
                            local v808 = l_v485_2[v790.weapon];
                            local v809 = nil;
                            local v810 = nil;
                            local v811 = nil;
                            local v812 = nil;
                            if l_hide_icon_with_text_0 and l_distance_width_0 > 0 then
                                v808 = nil;
                            end;
                            local l_l_height_0_0 = l_height_0;
                            if v808 ~= nil then
                                local v814 = v790.distance - 60;
                                local v815 = l_min_0(20, l_floor_0(l_max_0(13, l_height_0 + 2, v814 < 0 and -v814 or 0)));
                                local v816 = l_v486_2[v808][v815];
                                v812 = v816[5];
                                local v817 = v816[1];
                                v811 = v816[2];
                                v810 = v817;
                                l_width_0 = l_width_0 + l_distance_width_0 * 8 + v810;
                                l_height_0 = l_max_0(v811, l_height_0);
                                v817 = l_x_3 - l_width_0 * 0.5 + v816[3];
                                local v818 = l_y_2 - l_height_0 + v816[4];
                                if v811 < l_l_height_0_0 then
                                    v818 = v818 + (l_l_height_0_0 - v811) * 0.5;
                                end;
                                v809 = l_vector_0(l_floor_0(v817), l_floor_0(v818));
                            else
                                l_width_0 = l_width_0 - 3 * l_distance_width_0;
                            end;
                            local v819 = l_x_3 - l_width_0 * 0.5;
                            l_y_2 = l_y_2 - l_height_0;
                            l_x_3 = v819;
                            v819 = l_x_3 + l_width_0;
                            local v820 = l_y_2 + l_height_0;
                            l_v477_1.a = 180 * l_visible_alpha_0;
                            l_rect_0(l_vector_0(l_x_3 - 3, l_y_2 - 3), l_vector_0(v819 + 3, v820 + 3), l_v477_1, 0, true);
                            l_v477_1.a = 195 * l_visible_alpha_0;
                            l_rect_outline_0(l_vector_0(l_x_3 - 4, l_y_2 - 4), l_vector_0(v819 + 4, v820 + 4), l_v477_1, 0, 0, true);
                            if l_distance_width_0 > 0 then
                                if v810 ~= nil then
                                    local v821 = l_x_3 + v810;
                                    local v822 = l_y_2 + 2;
                                    l_rect_0(l_vector_0(v821 + 3, v822), l_vector_0(v821 + 4, v822 + l_height_0 - 3), l_l_color_0_0, 0, true);
                                    l_x_3 = l_x_3 + v810 + 8;
                                end;
                                if l_l_height_0_0 < l_height_0 then
                                    l_y_2 = l_y_2 + (l_height_0 - l_l_height_0_0) * 0.5;
                                end;
                                local l_text_1 = v790.text;
                                if l_is_have_editing_0 then
                                    l_text_1 = l_gsub_0(l_text_1, "<editing>", "\a" .. v82(l_v481_1));
                                end;
                                l_push_clip_rect_0(l_vector_0(l_x_3, l_y_2), l_vector_0(v819, v820), false);
                                l_text_0(1, l_vector_0(l_x_3, l_y_2 - 1), l_l_color_0_0, nil, l_text_1);
                                l_pop_clip_rect_0();
                            end;
                            if v808 ~= nil then
                                l_texture_0(v808, v809, v812, l_l_color_0_0, "f", 0);
                            end;
                        end;
                    end;
                end;
                if v472 == nil then
                    return;
                else
                    local l_viewangles_alpha_0 = v472.viewangles_alpha;
                    if v472 == l_location_6 then
                        l_viewangles_alpha_0 = 1;
                    elseif l_viewangles_alpha_0 < 1 then
                        l_viewangles_alpha_0 = l_min_0(1, l_viewangles_alpha_0 + l_frametime_0 * 6);
                    end;
                    v472.viewangles_alpha = l_viewangles_alpha_0;
                    l_viewangles_alpha_0 = v214(l_viewangles_alpha_0, 0, 1, 1);
                    if l_viewangles_alpha_0 == 0 then
                        return;
                    else
                        local v825 = v779:get_origin();
                        local v826 = l_camera_angles_0();
                        local l_m_flDuckAmount_2 = v779.m_flDuckAmount;
                        local v828 = v779.m_MoveType == 9;
                        local v829 = #v472;
                        for v830 = 1, v829 do
                            local v831 = v472[v830];
                            local v832 = v826 - v831.viewangles;
                            v832.y = l_normalize_yaw_0(v832.y);
                            local v833 = l_abs_0(v77(v832));
                            local l_v833_0 = v833;
                            v831.is_on_fov = v833 <= l_fov_1;
                            v831.fov = l_v833_0;
                            l_v833_0 = v831.position;
                            local v835 = v75(v825, l_v833_0);
                            local v836 = v76(v825, l_v833_0);
                            if v836 < 1.5 then
                                v835 = v836;
                            end;
                            local l_v835_0 = v835;
                            v831.distance_2d = v836;
                            v831.distance = l_v835_0;
                            v831.on_position = v835 < (v828 and 0.45 or 0.1) and (l_m_flDuckAmount_2 == v831.duck and 1 or 0);
                        end;
                        l_sort_0(v472, l_v487_3);
                        v470 = v472[v829];
                        local v838 = l_v483_1();
                        for v839 = 1, v829 do
                            local v840 = v472[v839];
                            local v841 = v840 == v470;
                            local l_is_on_fov_0 = v840.is_on_fov;
                            local v843 = v841 and l_is_on_fov_0;
                            local v844 = v840.on_position or v840 == l_location_6;
                            local v845, v846 = l_v482_1(v838, v840.viewangles_forward, 40);
                            local l_on_screen_0 = v840.on_screen;
                            if v846 and l_on_screen_0 < 1 then
                                l_on_screen_0 = l_min_0(1, l_on_screen_0 + l_frametime_0 * 4.5);
                            elseif not v846 and l_on_screen_0 > 0 then
                                l_on_screen_0 = l_max_0(0, l_on_screen_0 - l_frametime_0 * 5.5);
                            end;
                            v840.on_screen = l_on_screen_0;
                            local v848 = l_alpha_0 * ((0.5 + l_on_screen_0 * 0.5) * l_viewangles_alpha_0);
                            local l_l_color_0_1 = l_color_0;
                            if v840.editing then
                                l_l_color_0_1 = l_v481_1;
                            end;
                            local v850 = 255 * v848;
                            l_l_color_0_1.a = v850;
                            local v851 = "\194\187" .. v840.name;
                            local l_description_0 = v840.description;
                            local v853 = l_measure_text_0(l_v484_2, nil, v851);
                            local l_v70_0 = v70;
                            if l_description_0 ~= nil then
                                l_description_0 = l_gsub_0(l_upper_0(l_description_0), " ", "  ");
                                l_v70_0 = l_measure_text_0(2, nil, l_description_0);
                            end;
                            local v855 = l_floor_0(l_v70_0.y * 0.5);
                            local v856 = l_max_0(v853.x, l_v70_0.x);
                            local v857 = v853.y + l_v70_0.y;
                            local v858 = l_floor_0(v853.y * 0.5 - 1) * 2.25;
                            local v859 = 0;
                            if l_on_screen_0 > 0 then
                                v859 = l_floor_0((v858 + 7) * l_on_screen_0) + v855;
                                v856 = v856 + v859;
                            end;
                            local v860 = l_min_0(v845.x - v858 * 0.5 - v855 * 0.5, l_get_2.x - 40 - v856);
                            local v861 = v845.y - v857 * 0.5;
                            local v862 = v860 + v856;
                            local v863 = v861 + v857;
                            local v864 = v215(v848, 0, 1, 1);
                            l_v477_1.a = 180 * v864;
                            l_rect_0(l_vector_0(v860 - 2, v861 - 2), l_vector_0(v862 + 2, v863 + 2), l_v477_1);
                            l_v477_1.a = 170 * v864;
                            l_rect_outline_0(l_vector_0(v860 - 3, v861 - 3), l_vector_0(v862 + 3, v863 + 3), l_v477_1);
                            l_v477_1.a = 195 * v864;
                            l_rect_outline_0(l_vector_0(v860 - 4, v861 - 4), l_vector_0(v862 + 4, v863 + 4), l_v477_1);
                            l_v477_1.a = 40 * v864;
                            l_rect_outline_0(l_vector_0(v860 - 5, v861 - 5), l_vector_0(v862 + 5, v863 + 5), l_v477_1);
                            if l_on_screen_0 > 0.5 then
                                v858 = v858 * 0.5;
                                local l_in_fov_select_0 = v840.in_fov_select;
                                if v843 and l_in_fov_select_0 < 1 then
                                    l_in_fov_select_0 = l_min_0(1, l_in_fov_select_0 + l_frametime_0 * 2.5 * (l_is_on_fov_0 and 2 or 1));
                                elseif not v843 and l_in_fov_select_0 > 0 then
                                    l_in_fov_select_0 = l_max_0(0, l_in_fov_select_0 - l_frametime_0 * 4.5);
                                end;
                                v840.in_fov_select = l_in_fov_select_0;
                                local v866 = l_vector_0(v860 + v858 + v855 * 0.5, v861 + v857 * 0.5);
                                if l_location_6 == v840 then
                                    l_circle_0(v866, l_l_color_0_1 * 1.2, v858, 0, 1);
                                else
                                    local v867 = v850 * v216(l_on_screen_0, 0, 1, 1);
                                    local v868 = v81(l_v478_1, l_v479_0, v844 and 1 or 0);
                                    local v869 = v81(l_v480_1, v868, l_in_fov_select_0);
                                    v869.a = v867;
                                    l_v477_1.a = v867 * 0.5;
                                    l_circle_outline_0(v866, l_v477_1, v858 + 1, 0, 1, 2);
                                    l_circle_0(v866, v869, v858, 0, 1);
                                    l_v477_1.a = v867 * 0.3;
                                    l_circle_outline_0(v866, l_v477_1, v858 + 1, 0, 1, 2);
                                    l_v477_1.a = v867 * 0.2;
                                    l_circle_outline_0(v866, l_v477_1, v858, 0, 1, 2);
                                    l_v477_1.a = v867 * 0.1;
                                    l_circle_outline_0(v866, l_v477_1, v858 - 1, 0, 1, 2);
                                end;
                            end;
                            v860 = v860 + v859;
                            if v859 > 1 then
                                l_l_color_0_1.a = l_l_color_0_1.a * l_on_screen_0;
                                l_rect_0(l_vector_0(v860 - 4, v861 + 1), l_vector_0(v860 - 3, v861 + 1 + v857 - 1), l_l_color_0_1);
                            end;
                            l_text_0(l_v484_2, l_vector_0(v860, v861), l_l_color_0_1, nil, v851);
                            if l_description_0 ~= nil then
                                l_text_0(2, l_vector_0(v860, v861 + v853.y), l_l_color_0_1 * 1.2, nil, l_description_0);
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
    l_events_0.render(l_settings_0);
end;
l_customization_0 = nil;
l_customization_0 = l_decode_0.grenade_release;
v476 = nil;
v477 = nil;
v478 = nil;
do
    local l_v476_2, l_v477_2, l_v478_2, l_v479_1, l_v480_2 = v476, v477, v478, v479, v480;
    l_v479_1 = {
        Frag = function(v875)
            -- upvalues: l_customization_0 (ref), l_v476_2 (ref), l_v477_2 (ref), l_camera_angles_0 (ref)
            local l_damage_0 = v875.damage;
            local l_hegrenade_0 = l_customization_0.hegrenade;
            local l_fatal_0 = v875.fatal;
            if l_hegrenade_0 > 0 and (l_hegrenade_0 == 51 and l_fatal_0 or l_hegrenade_0 ~= 51 and l_hegrenade_0 <= l_damage_0 or l_fatal_0) then
                local v879 = true;
                l_v477_2 = l_camera_angles_0();
                l_v476_2 = v879;
            end;
        end, 
        Flash = function(v880)
            -- upvalues: l_customization_0 (ref), l_v476_2 (ref), l_v477_2 (ref), l_camera_angles_0 (ref)
            local l_damage_1 = v880.damage;
            local l_flashbang_0 = l_customization_0.flashbang;
            if l_flashbang_0 > 0 and l_flashbang_0 <= l_damage_1 then
                local v883 = true;
                l_v477_2 = l_camera_angles_0();
                l_v476_2 = v883;
            end;
        end, 
        Molly = function(v884)
            -- upvalues: l_customization_0 (ref), l_v476_2 (ref), l_v477_2 (ref), l_camera_angles_0 (ref)
            local l_damage_2 = v884.damage;
            local l_molotov_0 = l_customization_0.molotov;
            local v887 = l_damage_2 / 52.5;
            if l_molotov_0 > 0 and v887 > 0 and v887 <= l_molotov_0 then
                local v888 = true;
                l_v477_2 = l_camera_angles_0();
                l_v476_2 = v888;
            end;
        end
    };
    do
        local l_l_v479_1_0 = l_v479_1;
        l_v478_2 = function(v890)
            -- upvalues: l_v476_2 (ref), l_v477_2 (ref), l_l_v479_1_0 (ref)
            local v891 = nil;
            l_v477_2 = nil;
            l_v476_2 = v891;
            v891 = l_l_v479_1_0[v890.type];
            if v891 ~= nil then
                v891(v890);
            end;
            return true;
        end;
    end;
    l_v479_1 = nil;
    l_v480_2 = 1;
    v481 = nil;
    v481 = {
        [48] = true, 
        [46] = true, 
        [43] = true, 
        [44] = true
    };
    v482 = l_decode_0.settings.hotkey;
    do
        local l_l_v480_2_0, l_v481_2, l_v482_2 = l_v480_2, v481, v482;
        l_v479_1 = function(v895)
            -- upvalues: v85 (ref), l_v482_2 (ref), l_v476_2 (ref), l_v477_2 (ref), l_get_local_player_0 (ref), l_band_0 (ref), l_l_v480_2_0 (ref), l_customization_0 (ref), l_v481_2 (ref)
            if v85(l_v482_2) then
                return;
            elseif l_v476_2 == nil and l_v477_2 == nil then
                return;
            else
                local v896 = l_get_local_player_0();
                if v896 == nil or not v896:is_alive() then
                    return;
                elseif not (l_band_0(v896.m_fFlags, l_l_v480_2_0) ~= 0 and not v895.in_jump) and l_customization_0.disable_in_air then
                    return;
                else
                    local v897 = v896:get_player_weapon();
                    if v897 == nil then
                        return;
                    elseif l_v481_2[v897:get_weapon_index()] == nil then
                        return;
                    else
                        local l_view_angles_0 = v895.view_angles;
                        local l_view_angles_1 = v895.view_angles;
                        local l_x_4 = l_v477_2.x;
                        l_view_angles_1.y = l_v477_2.y;
                        l_view_angles_0.x = l_x_4;
                        if v897.m_bPinPulled or v897.m_fThrowTime > 0 then
                            l_view_angles_0 = false;
                            v895.in_attack2 = false;
                            v895.in_attack = l_view_angles_0;
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
    l_v480_2 = v84("Visuals", "World", "Other", "Grenade Prediction");
    v481 = function()
        -- upvalues: l_v476_2 (ref), l_v477_2 (ref), v87 (ref), l_v480_2 (ref), v85 (ref), l_customization_0 (ref), l_events_0 (ref), l_v478_2 (ref), l_v479_1 (ref)
        local v901 = nil;
        l_v477_2 = nil;
        l_v476_2 = v901;
        v87(l_v480_2);
        v901 = v85(l_customization_0.enabled);
        if v901 then
            v87(l_v480_2, true);
        end;
        l_events_0.grenade_prediction(l_v478_2, v901);
        l_events_0.createmove(l_v479_1, v901);
    end;
    l_v480_2:set_callback(v481, true);
    l_customization_0.enabled:set_callback(v481, true);
end;
v476 = nil;
v477 = nil;
v478 = nil;
v479 = {};
v480 = {};
v478 = {};
v477 = v480;
v476 = v479;
v479 = "https://northon.dev/grenade-helper-api";
v480 = "%s::%s";
v481 = "\a{Active Text}%s\aDEFAULT ~ %s";
do
    local l_v479_2, l_v480_3, l_v481_3 = v479, v480, v481;
    if v0 then
        v483 = v271().cloud_active_locations;
        v482 = nil;
        v484 = nil;
        v485 = nil;
        v486 = nil;
        v487 = nil;
        v488 = {};
        do
            local l_v483_2, l_v484_3, l_v485_3, l_v486_3, l_v487_4, l_v488_3 = v483, v484, v485, v486, v487, v488;
            do
                local l_l_v488_3_0, l_v489_1 = l_v488_3, v489;
                l_v487_4 = function()
                    -- upvalues: l_l_v488_3_0 (ref), l_format_0 (ref), l_v480_3 (ref), l_v483_2 (ref), v410 (ref), l_map_patterns_0 (ref), l_get_1 (ref), l_v479_2 (ref), l_pcall_0 (ref), v94 (ref), v92 (ref), l_type_0 (ref), l_unpack_1 (ref)
                    local v913 = 0;
                    local v914 = 0;
                    for v915 = 1, #l_l_v488_3_0 do
                        local v916 = l_l_v488_3_0[v915];
                        local v917 = v916[2];
                        local v918 = v916[3];
                        local v919 = l_format_0(l_v480_3, v917, v918);
                        local v920 = l_v483_2[v919];
                        do
                            local l_v919_0, l_v920_0 = v919, v920;
                            if not l_v920_0 then
                                local v923 = v410[l_v919_0] ~= nil;
                                v410[l_v919_0] = nil;
                                if v923 then
                                    l_map_patterns_0();
                                end;
                            elseif l_v920_0 and v410[l_v919_0] == nil then
                                v913 = v913 + 1;
                                local v924 = v916[1];
                                local v925 = l_format_0("/%s-%s", v924, v917);
                                l_get_1(l_v479_2 .. v925, nil, function(v926)
                                    -- upvalues: l_v920_0 (ref), v410 (ref), l_v919_0 (ref), v914 (ref), l_pcall_0 (ref), v94 (ref), v92 (ref), l_type_0 (ref), l_unpack_1 (ref), v913 (ref), l_map_patterns_0 (ref)
                                    if not l_v920_0 then
                                        v410[l_v919_0] = nil;
                                        return;
                                    else
                                        v914 = v914 + 1;
                                        if v926 == nil or #v926 == 0 then
                                            return;
                                        else
                                            local v927, v928 = l_pcall_0(v94.decode, v926, v92);
                                            if not v927 or l_type_0(v928) ~= "string" then
                                                return;
                                            else
                                                v410[l_v919_0] = l_unpack_1(v928);
                                                if v913 == v914 then
                                                    l_map_patterns_0();
                                                end;
                                                return;
                                            end;
                                        end;
                                    end;
                                end);
                            end;
                        end;
                    end;
                end;
                l_write_0(l_v487_4);
                l_decode_0.types.selection:set_callback(l_v487_4);
                l_decode_0.customization.options:set_callback(l_v487_4);
                l_v486_3 = function()
                    -- upvalues: v476 (ref), l_l_v488_3_0 (ref), l_format_0 (ref), l_v480_3 (ref), l_v481_3 (ref), l_v483_2 (ref), l_decode_0 (ref), l_v487_4 (ref)
                    v476 = {};
                    local v929 = {
                        [1] = "\a{Link Active}\239\153\158\aDEFAULT  New"
                    };
                    for v930 = 1, #l_l_v488_3_0 do
                        local v931 = l_l_v488_3_0[v930];
                        local v932 = v931[2];
                        local v933 = v931[3];
                        local v934 = l_format_0(l_v480_3, v932, v933);
                        local v935 = l_format_0(l_v481_3, v932, v933);
                        local v936 = #v929 + 1;
                        v929[v936] = (l_v483_2[v934] and "\a{Link Active}\239\131\190\aDEFAULT   " or "\a{Link Active}\239\133\134\aDEFAULT   ") .. v935;
                        v476[v936] = v931;
                    end;
                    l_decode_0.cloud_sources.selection:update(v929);
                    l_v487_4();
                end;
                l_v485_3 = function(v937)
                    -- upvalues: v85 (ref), v477 (ref), l_decode_0 (ref), v476 (ref), v478 (ref), v89 (ref), l_format_0 (ref), l_v480_3 (ref), l_v483_2 (ref), v86 (ref)
                    local v938 = v85(v937);
                    local v939 = v938 == 1;
                    local v940 = #v477;
                    l_decode_0.cloud_sources.upload_selection:visibility(v939 and v940 > 0);
                    l_decode_0.cloud_sources.upload_label:visibility(v939 and v940 > 0);
                    l_decode_0.cloud_sources.upload:visibility(v939 and v940 > 0);
                    l_decode_0.cloud_sources.upload_text:visibility(v939 and v940 == 0);
                    l_decode_0.cloud_sources.update_selection:visibility(false);
                    l_decode_0.cloud_sources.update_delete_label:visibility(false);
                    l_decode_0.cloud_sources.delete_label:visibility(false);
                    l_decode_0.cloud_sources.update:visibility(false);
                    l_decode_0.cloud_sources.delete:visibility(false);
                    l_decode_0.cloud_sources.delete_confirm:visibility(false);
                    l_decode_0.cloud_sources.delete_cancel:visibility(false);
                    local v941 = v476[v938];
                    if v941 == nil then
                        return;
                    else
                        local v942 = #v478;
                        local v943 = v89 == v476[v938][2];
                        l_decode_0.cloud_sources.update_selection:visibility(v943 and v942 > 0);
                        l_decode_0.cloud_sources.update_delete_label:visibility(v943 and v942 > 0);
                        l_decode_0.cloud_sources.delete_label:visibility(v943 and v942 == 0);
                        l_decode_0.cloud_sources.update:visibility(v943 and v942 > 0);
                        l_decode_0.cloud_sources.delete:visibility(v943);
                        l_decode_0.cloud_sources.delete_confirm:visibility(false);
                        l_decode_0.cloud_sources.delete_cancel:visibility(false);
                        local v944 = l_format_0(l_v480_3, v941[2], v941[3]);
                        local v945 = v85(l_decode_0.cloud_sources.enabled);
                        local v946 = l_v483_2[v944] or false;
                        if v945 == v946 then
                            return;
                        else
                            v86(l_decode_0.cloud_sources.enabled, v946);
                            return;
                        end;
                    end;
                end;
                l_decode_0.cloud_sources.selection:set_callback(l_v485_3, true);
                on_enabled = function(v947)
                    -- upvalues: v85 (ref), l_decode_0 (ref), v476 (ref), l_format_0 (ref), l_v480_3 (ref), l_v483_2 (ref), v271 (ref), v272 (ref), l_v486_3 (ref)
                    local v948 = v476[v85(l_decode_0.cloud_sources.selection)];
                    if v948 == nil then
                        return;
                    else
                        local v949 = l_format_0(l_v480_3, v948[2], v948[3]);
                        local v950 = v85(v947);
                        if v950 == (l_v483_2[v949] or false) then
                            return;
                        else
                            l_v483_2[v949] = v950;
                            local v951 = v271();
                            v951.cloud_active_locations = l_v483_2;
                            v272(v951);
                            v951 = nil;
                            l_v486_3();
                            return;
                        end;
                    end;
                end;
                l_decode_0.cloud_sources.enabled:set_callback(on_enabled, true);
                l_v489_1 = function(v952)
                    -- upvalues: l_pcall_0 (ref), l_parse_0 (ref), l_type_0 (ref), l_l_v488_3_0 (ref), l_v486_3 (ref), v277 (ref), l_v485_3 (ref), l_decode_0 (ref)
                    if v952 == nil or #v952 == 0 then
                        return;
                    else
                        local v953, v954 = l_pcall_0(l_parse_0, v952);
                        if not v953 or l_type_0(v954) ~= "table" then
                            return;
                        else
                            l_l_v488_3_0 = v954;
                            l_v486_3();
                            v277:call();
                            l_v485_3(l_decode_0.cloud_sources.selection);
                            return;
                        end;
                    end;
                end;
                l_v484_3 = function()
                    -- upvalues: l_get_1 (ref), l_v479_2 (ref), l_v489_1 (ref)
                    l_get_1(l_v479_2, nil, l_v489_1);
                end;
                l_v484_3();
            end;
            l_v488_3 = function(v955)
                -- upvalues: l_gsub_0 (ref), l_byte_0 (ref), l_tostring_0 (ref)
                local v956 = 0;
                l_gsub_0(v955, ".", function(v957)
                    -- upvalues: v956 (ref), l_byte_0 (ref)
                    v956 = v956 + l_byte_0(v957);
                end);
                local v958 = v956 * 5345;
                return l_tostring_0(v958);
            end;
            v489 = nil;
            v490 = function(v959)
                -- upvalues: l_encode_0 (ref), l_add_notify_0 (ref), l_v484_3 (ref)
                if v959 ~= "success" then
                    return;
                else
                    l_encode_0("Locations successfully updated");
                    l_add_notify_0("Grenade Helper", "Locations Successfully Updated");
                    l_v484_3();
                    return;
                end;
            end;
            do
                local l_v490_1 = v490;
                v489 = function()
                    -- upvalues: v85 (ref), l_decode_0 (ref), v478 (ref), v476 (ref), l_format_0 (ref), l_v480_3 (ref), v410 (ref), v271 (ref), l_pack_0 (ref), v94 (ref), v92 (ref), v89 (ref), l_stringify_0 (ref), l_v488_3 (ref), l_post_0 (ref), l_v479_2 (ref), l_v490_1 (ref)
                    local v961 = v85(l_decode_0.cloud_sources.selection);
                    local v962 = v478[v85(l_decode_0.cloud_sources.update_selection)];
                    local v963 = v476[v961];
                    if v963 == nil then
                        return;
                    else
                        local v964 = v963[1];
                        local v965 = v963[2];
                        local v966 = v963[3];
                        v410[l_format_0(l_v480_3, v965, v966)] = nil;
                        local l_locations_2 = v271().locations;
                        local _ = nil;
                        local v969 = l_locations_2[v962];
                        local _ = v969.name;
                        local l_locations_3 = v969.locations;
                        l_locations_3 = l_pack_0(l_locations_3);
                        l_locations_3 = v94.encode(l_locations_3, v92);
                        local v972 = {
                            id = v964, 
                            author = v89, 
                            locations = l_locations_3
                        };
                        v972 = l_stringify_0(v972);
                        local v973 = {
                            json = v972, 
                            signature = l_v488_3(v972)
                        };
                        l_post_0(l_v479_2 .. "/update", v973, nil, l_v490_1);
                        return;
                    end;
                end;
                l_decode_0.cloud_sources.update:set_callback(v489);
            end;
            v490 = nil;
            local function v975(v974)
                -- upvalues: l_encode_0 (ref), l_add_notify_0 (ref), l_v484_3 (ref)
                if v974 ~= "success" then
                    return;
                else
                    l_encode_0("Locations successfully deleted");
                    l_add_notify_0("Grenade Helper", "Locations Successfully Deleted");
                    l_v484_3();
                    return;
                end;
            end;
            do
                local l_v975_0 = v975;
                v490 = function()
                    -- upvalues: v85 (ref), l_decode_0 (ref), v476 (ref), l_format_0 (ref), l_v480_3 (ref), v410 (ref), v89 (ref), l_stringify_0 (ref), l_v488_3 (ref), l_post_0 (ref), l_v479_2 (ref), l_v975_0 (ref)
                    local v977 = v476[v85(l_decode_0.cloud_sources.selection)];
                    if v977 == nil then
                        return;
                    else
                        local v978 = v977[1];
                        local v979 = v977[2];
                        local v980 = v977[3];
                        v410[l_format_0(l_v480_3, v979, v980)] = nil;
                        local v981 = {
                            id = v978, 
                            author = v89
                        };
                        v981 = l_stringify_0(v981);
                        local v982 = {
                            json = v981, 
                            signature = l_v488_3(v981)
                        };
                        l_post_0(l_v479_2 .. "/delete", v982, nil, l_v975_0);
                        return;
                    end;
                end;
                l_decode_0.cloud_sources.delete_confirm:set_callback(v490);
            end;
            v975 = nil;
            local function v984(v983)
                -- upvalues: l_encode_0 (ref), l_add_notify_0 (ref), l_v484_3 (ref)
                if v983 ~= "success" then
                    return;
                else
                    l_encode_0("Locations successfully uploaded");
                    l_add_notify_0("Grenade Helper", "Locations Successfully Uploaded");
                    l_v484_3();
                    return;
                end;
            end;
            do
                local l_v984_0 = v984;
                v975 = function()
                    -- upvalues: v477 (ref), v85 (ref), l_decode_0 (ref), v271 (ref), l_pack_0 (ref), v94 (ref), v92 (ref), v89 (ref), l_stringify_0 (ref), l_v488_3 (ref), l_post_0 (ref), l_v479_2 (ref), l_v984_0 (ref)
                    local v986 = v477[v85(l_decode_0.cloud_sources.upload_selection)];
                    local l_locations_4 = v271().locations;
                    local _ = nil;
                    local v989 = l_locations_4[v986];
                    local l_name_3 = v989.name;
                    local l_locations_5 = v989.locations;
                    l_locations_5 = l_pack_0(l_locations_5);
                    l_locations_5 = v94.encode(l_locations_5, v92);
                    local v992 = {
                        author = v89, 
                        name = l_name_3, 
                        locations = l_locations_5
                    };
                    v992 = l_stringify_0(v992);
                    local v993 = {
                        json = v992, 
                        signature = l_v488_3(v992)
                    };
                    l_post_0(l_v479_2 .. "/upload", v993, nil, l_v984_0);
                end;
                l_decode_0.cloud_sources.upload:set_callback(v975);
            end;
        end;
    else
        l_get_1(l_v479_2, nil, function(v994)
            -- upvalues: l_pcall_0 (ref), l_parse_0 (ref), l_type_0 (ref), l_format_0 (ref), l_v481_3 (ref), l_decode_0 (ref)
            if v994 == nil or #v994 == 0 then
                return;
            else
                local v995, v996 = l_pcall_0(l_parse_0, v994);
                if not v995 or l_type_0(v996) ~= "table" then
                    return;
                else
                    local v997 = {
                        [1] = "\a{Link Active}\239\153\158\aDEFAULT  New"
                    };
                    for v998 = 1, #v996 do
                        local v999 = v996[v998];
                        local v1000 = v999[2];
                        local v1001 = v999[3];
                        local v1002 = l_format_0(l_v481_3, v1000, v1001);
                        v997[#v997 + 1] = "\a{Link Active}\239\133\134\aDEFAULT   " .. v1002;
                    end;
                    l_decode_0.cloud_sources.selection:update(v997);
                    return;
                end;
            end;
        end);
    end;
end;
v479 = nil;
v479 = {
    [1] = {
        [1] = 0.1, 
        [2] = "kizaru", 
        [3] = "nl\\scripts\\grenade helper\\helper.txt", 
        [4] = "KeBA1OZtLzFUJ9SRuXYnV2Tc4dNkfmDjpyCvha37GrIQWq85lgxw6obsHEM0Pi+/="
    }, 
    [2] = {
        [1] = 0.2, 
        [2] = "brandon", 
        [3] = "nl\\scripts\\grenade helper\\brandon.txt", 
        [4] = "WD836KSxLOJ0ZTdflXVb4nchmzpiB59ArjMkytuvHwPURYs712IEQaqoFeGgNC+/="
    }, 
    [3] = {
        [1] = 0.3, 
        [2] = "fencai", 
        [3] = "nl\\scripts\\grenade helper\\fencai.txt", 
        [4] = "IOJMABGWSFCTmR08ei4cVatr6hgsYZqvpzwkfuQxb592oLXHUPlDKNj7E1n3yd+/="
    }, 
    [4] = {
        [1] = 0.4, 
        [2] = "japan_malva", 
        [3] = "nl\\scripts\\grenade helper\\japan_malva.txt", 
        [4] = "JPFAO6aWYSVRTCBMDXyhZ2ewqbNnjitgrUm0d4pxLz1vu9fc3kl75oGsK8HQEI+/="
    }, 
    [5] = {
        [1] = 0.5, 
        [2] = "spacex", 
        [3] = "nl\\scripts\\grenade helper\\spacex.txt", 
        [4] = "dtaS4Khx3R6MjfuwHl7YATbEFXvmPCLJ2y5pW98rGVUZz0QOeDsokqIB1iNgcn+/="
    }, 
    [6] = {
        [1] = 0.6, 
        [2] = "mercy", 
        [3] = "nl\\scripts\\grenade helper\\mercy.txt", 
        [4] = "4GKMcHNUqTVgbCkRFultJoBaydjfZmp3PW5vD6zxr9L0SYi8XInsEA7Qh2Ow1e+/="
    }
};
v480 = "https://northon.dev/neverlose/grenade_helper/%s.txt";
do
    local l_v480_4 = v480;
    for v1004 = 1, #v479 do
        v485 = v479[v1004];
        v486 = v485[1];
        v487 = v485[2];
        v488 = v485[3];
        v489 = v485[4];
        do
            local l_v487_5, l_v488_4, l_v489_2 = v487, v488, v489;
            l_execute_after_0(v486, function()
                -- upvalues: l_abs_0 (ref), v241 (ref), v89 (ref), l_tostring_0 (ref), l_pack_0 (ref), v94 (ref), l_v489_2 (ref), l_v488_4 (ref), l_v487_5 (ref), l_decode_0 (ref), v85 (ref), v436 (ref), l_map_patterns_0 (ref), l_get_1 (ref), l_format_0 (ref), l_v480_4 (ref), l_pcall_0 (ref), l_unpack_1 (ref), l_write_0 (ref)
                local v1008 = l_abs_0(v241(v89));
                v1008 = v89 .. ":" .. v1008;
                v1008 = l_tostring_0(l_abs_0(v241(v1008)));
                v1008 = l_pack_0(v1008);
                v1008 = v94.encode(v1008, l_v489_2);
                if v94.encode(v1008) ~= files.read(l_v488_4) then
                    return;
                else
                    local l_l_v487_5_0 = l_v487_5;
                    if l_l_v487_5_0 == "japan_malva" then
                        l_l_v487_5_0 = "japan & malva";
                    end;
                    l_decode_0.cloud_sources.market_locations_label:visibility(true);
                    local v1010 = l_decode_0.cloud_sources.market_locations:switch(l_l_v487_5_0);
                    local function v1019()
                        -- upvalues: v85 (ref), v1010 (ref), v436 (ref), l_v487_5 (ref), l_map_patterns_0 (ref), l_get_1 (ref), l_format_0 (ref), l_v480_4 (ref), l_pcall_0 (ref), v94 (ref), l_v489_2 (ref), l_unpack_1 (ref)
                        if not v85(v1010) then
                            local v1011 = v436[l_v487_5] ~= nil;
                            v436[l_v487_5] = nil;
                            if v1011 then
                                l_map_patterns_0();
                            end;
                            return;
                        else
                            l_get_1(l_format_0(l_v480_4, l_v487_5), nil, function(v1012)
                                -- upvalues: l_pcall_0 (ref), v94 (ref), l_v489_2 (ref), l_unpack_1 (ref), v436 (ref), l_v487_5 (ref), l_map_patterns_0 (ref)
                                if v1012 == nil or #v1012 == 0 then
                                    return;
                                else
                                    local v1013, v1014 = l_pcall_0(v94.decode, v1012);
                                    if not v1013 then
                                        return;
                                    else
                                        local v1015, v1016 = l_pcall_0(v94.decode, v1014, l_v489_2);
                                        if not v1015 then
                                            return;
                                        else
                                            local v1017, v1018 = l_pcall_0(l_unpack_1, v1016);
                                            if not v1017 then
                                                return;
                                            else
                                                v436[l_v487_5] = v1018;
                                                l_map_patterns_0();
                                                return;
                                            end;
                                        end;
                                    end;
                                end;
                            end);
                            return;
                        end;
                    end;
                    v1010:set_callback(v1019, true);
                    l_write_0(v1019);
                    l_decode_0.types.selection:set_callback(v1019);
                    l_decode_0.customization.options:set_callback(v1019);
                    return;
                end;
            end);
        end;
    end;
end;
v480 = nil;
v481 = {
    weapon_hegrenade = "HE", 
    weapon_decoy = "Decoy", 
    weapon_flashbang = "Flashbang", 
    weapon_smokegrenade = "Smoke", 
    weapon_knife = "Movement", 
    weapon_wallbang = "Wallbang", 
    weapon_molotov = "Molotov"
};
v482 = nil;
v483 = l_decode_0.cloud_sources.selection;
v484 = l_decode_0.cloud_sources.update_selection;
v485 = l_decode_0.cloud_sources.upload_selection;
v486 = l_decode_0.locations.selection;
v488 = v271().active_locations;
v487 = nil;
v489 = function(_, v1021)
    -- upvalues: v89 (ref)
    if v89 == v1021[2] then
        return v1021[3], true;
    else
        return 0, false;
    end;
end;
do
    local l_v481_4, l_v482_3, l_v486_4, l_v487_6, l_v488_5, l_v489_3, l_v490_2 = v481, v482, v486, v487, v488, v489, v490;
    do
        local l_v483_3, l_v484_4, l_v485_4, l_l_v486_4_0, l_l_v488_5_0, l_l_v489_3_0 = v483, v484, v485, l_v486_4, l_v488_5, l_v489_3;
        l_v482_3 = function(v1035)
            -- upvalues: v271 (ref), l_l_v488_5_0 (ref), l_l_v486_4_0 (ref), v0 (ref), v477 (ref), v478 (ref), v252 (ref), v476 (ref), l_l_v489_3_0 (ref), l_v484_4 (ref), l_v485_4 (ref), v86 (ref), l_v483_3 (ref), v85 (ref), l_decode_0 (ref)
            local l_locations_6 = v271().locations;
            v1035 = nil;
            local v1037 = {};
            for v1038 = 1, #l_locations_6 do
                local v1039 = l_locations_6[v1038];
                v1037[#v1037 + 1] = (l_l_v488_5_0[v1038] and "\a{Link Active}\239\131\190\aDEFAULT   " or "\a{Link Active}\239\133\134\aDEFAULT   ") .. v1039.name;
            end;
            v1037[#v1037 + 1] = "\a{Link Active}\239\153\158\aDEFAULT  New";
            l_l_v486_4_0:update(v1037);
            if v0 then
                local v1040 = {};
                local v1041 = {};
                local v1042 = {};
                v478 = {};
                v477 = v1042;
                for v1043 = 1, #l_locations_6 do
                    local v1044 = l_locations_6[v1043];
                    if v1043 > 3 then
                        if not v252(v476, l_l_v489_3_0)[v1044.name] then
                            v1040[#v1040 + 1] = v1044.name;
                            v477[#v477 + 1] = v1043;
                        end;
                        v1041[#v1041 + 1] = v1044.name;
                        v478[#v478 + 1] = v1043;
                    end;
                end;
                l_v484_4:update(v1041);
                l_v485_4:update(v1040);
                v86(l_v483_3, v85(l_v483_3));
            end;
            l_locations_6 = nil;
            l_decode_0.locations.on_visibility();
        end;
        l_v482_3();
        v277(l_v482_3);
        l_v490_2 = function(v1045)
            -- upvalues: v85 (ref), l_decode_0 (ref), l_l_v488_5_0 (ref), v86 (ref)
            local v1046 = v85(v1045);
            local v1047 = v85(l_decode_0.locations.enabled);
            local v1048 = l_l_v488_5_0[v1046] or false;
            if v1047 == v1048 then
                return;
            else
                v86(l_decode_0.locations.enabled, v1048);
                return;
            end;
        end;
        l_execute_after_0(0.01, l_l_v486_4_0.set_callback, l_l_v486_4_0, l_v490_2, true);
        local function v1053(v1049)
            -- upvalues: v85 (ref), l_l_v486_4_0 (ref), l_l_v488_5_0 (ref), v271 (ref), v272 (ref), l_v482_3 (ref), l_map_patterns_0 (ref)
            local v1050 = v85(l_l_v486_4_0);
            local v1051 = v85(v1049);
            if v1051 == (l_l_v488_5_0[v1050] or false) then
                return;
            else
                l_l_v488_5_0[v1050] = v1051;
                local v1052 = v271();
                v1052.active_locations = l_l_v488_5_0;
                v272(v1052);
                l_v482_3(v1052);
                l_map_patterns_0(v1052);
                v1052 = nil;
                return;
            end;
        end;
        l_decode_0.locations.enabled:set_callback(v1053);
    end;
    v483 = nil;
    (function()
        -- upvalues: v271 (ref), l_format_0 (ref), l_get_1 (ref), l_pcall_0 (ref), l_parse_0 (ref), l_type_0 (ref), v272 (ref), l_v482_3 (ref)
        local v1054 = {
            [1] = {
                [1] = "grenades", 
                [2] = "Default: Grenade"
            }, 
            [2] = {
                [1] = "movements", 
                [2] = "Default: Movement"
            }, 
            [3] = {
                [1] = "wallbangs", 
                [2] = "Default: Wallbang"
            }
        };
        local v1055 = 0;
        local v1056 = v271();
        local l_locations_7 = v1056.locations;
        if #l_locations_7 >= 3 then
            v1056 = nil;
            l_locations_7 = nil;
            return;
        else
            for v1058 = 1, #v1054 do
                local v1059 = v1054[v1058];
                local v1060 = v1059[1];
                local v1061 = v1059[2];
                local v1062 = l_format_0("https://northon.dev/neverlose/grenade_helper/%s.json", v1060);
                do
                    local l_v1058_0 = v1058;
                    do
                        local l_v1061_0 = v1061;
                        l_get_1(v1062, nil, function(v1065)
                            -- upvalues: v1056 (ref), l_locations_7 (ref), l_pcall_0 (ref), l_parse_0 (ref), l_type_0 (ref), l_v1058_0 (ref), l_v1061_0 (ref), v1055 (ref), v1054 (ref), v272 (ref), l_v482_3 (ref)
                            if v1065 == nil or #v1065 == 0 then
                                v1056 = nil;
                                l_locations_7 = nil;
                                return;
                            else
                                local v1066, v1067 = l_pcall_0(l_parse_0, v1065);
                                if not v1066 or l_type_0(v1067) ~= "table" then
                                    v1056 = nil;
                                    l_locations_7 = nil;
                                    return;
                                else
                                    l_locations_7[l_v1058_0] = {
                                        name = l_v1061_0, 
                                        locations = v1067
                                    };
                                    v1055 = v1055 + 1;
                                    if v1055 ~= #v1054 then
                                        return;
                                    else
                                        v272(v1056);
                                        l_v482_3(v1056);
                                        v1056 = nil;
                                        l_locations_7 = nil;
                                        return;
                                    end;
                                end;
                            end;
                        end);
                    end;
                end;
            end;
            return;
        end;
    end)();
    v484 = nil;
    v485 = l_decode_0.locations.new_source_name;
    l_v486_4 = function(_, v1069)
        return v1069.name, true;
    end;
    do
        local l_v485_5, l_l_v486_4_1 = v485, l_v486_4;
        v484 = function()
            -- upvalues: v85 (ref), l_v485_5 (ref), l_gsub_0 (ref), v271 (ref), v252 (ref), l_l_v486_4_1 (ref), l_format_0 (ref), v272 (ref), l_v482_3 (ref)
            local v1072 = v85(l_v485_5);
            if l_gsub_0(v1072, " ", "") == "" then
                v1072 = "Unnamed";
            end;
            local v1073 = v271();
            local l_locations_8 = v1073.locations;
            local l_v1072_0 = v1072;
            local v1076 = 2;
            local v1077 = v252(l_locations_8, l_l_v486_4_1);
            while v1077[l_v1072_0] do
                l_v1072_0 = l_format_0("%s (%d)", v1072, v1076);
                v1076 = v1076 + 1;
            end;
            l_locations_8[#l_locations_8 + 1] = {
                name = l_v1072_0, 
                locations = {}
            };
            v272(v1073);
            l_v482_3(v1073);
            v1073 = nil;
            l_locations_8 = nil;
            l_v485_5:reset();
        end;
        l_decode_0.locations.create:set_callback(v484);
    end;
    v485 = nil;
    l_v486_4 = l_decode_0.locations.selection;
    do
        local l_l_v486_4_2 = l_v486_4;
        v485 = function()
            -- upvalues: v85 (ref), l_l_v486_4_2 (ref), v271 (ref), l_remove_0 (ref), v272 (ref), l_v482_3 (ref), l_map_patterns_0 (ref)
            local v1079 = v85(l_l_v486_4_2);
            local v1080 = v271();
            local l_locations_9 = v1080.locations;
            l_remove_0(l_locations_9, v1079);
            v272(v1080);
            l_v482_3(v1080);
            l_map_patterns_0(v1080);
            v1080 = nil;
            l_locations_9 = nil;
        end;
        l_decode_0.locations.delete_confirm:set_callback(v485);
    end;
    l_v486_4 = nil;
    l_v487_6 = l_decode_0.locations.search;
    l_v488_5 = l_decode_0.locations.all_maps;
    l_v489_3 = l_decode_0.locations.locations_selection;
    l_v490_2 = function(v1082, v1083, v1084, v1085, v1086, v1087)
        -- upvalues: l_type_0 (ref), l_find_0 (ref), l_lower_0 (ref), l_format_0 (ref), l_v481_4 (ref)
        if v1082 == nil then
            return;
        else
            local v1088 = v1085 and "[\a{Link Active}%s\aDEFAULT] \a{Link Active}%s:\aDEFAULT %s" or "\a{Link Active}%s:\aDEFAULT %s";
            for v1089 = 1, #v1082 do
                local v1090 = v1082[v1089];
                local l_name_4 = v1090.name;
                if l_type_0(l_name_4) == "table" then
                    local v1092 = l_name_4[2];
                    if v1092 then
                        l_name_4 = v1092;
                    end;
                end;
                if l_find_0(l_lower_0(l_name_4), v1084, 1, true) ~= nil then
                    local v1093 = #v1086 + 1;
                    v1086[v1093] = v1085 and l_format_0(v1088, v1083, l_v481_4[v1090.weapon], l_name_4) or l_format_0(v1088, l_v481_4[v1090.weapon], l_name_4);
                    v1087[v1093] = {
                        map_name = v1083, 
                        index = v1089, 
                        location = v1090
                    };
                end;
            end;
            return;
        end;
    end;
    do
        local l_l_v487_6_0, l_l_v488_5_1, l_l_v489_3_1, l_l_v490_2_0 = l_v487_6, l_v488_5, l_v489_3, l_v490_2;
        l_v486_4 = function()
            -- upvalues: v439 (ref), l_lower_0 (ref), v85 (ref), l_l_v487_6_0 (ref), v297 (ref), l_l_v488_5_1 (ref), l_next_0 (ref), l_l_v490_2_0 (ref), l_l_v489_3_1 (ref)
            if v439 == nil then
                return;
            else
                local l_locations_10 = v439.source.locations;
                local v1099 = {
                    [1] = "\a{Link Active}\238\146\163\aDEFAULT  New"
                };
                local v1100 = {};
                local v1101 = l_lower_0(v85(l_l_v487_6_0));
                local v1102 = v297 == nil or v85(l_l_v488_5_1);
                if v1102 then
                    for v1103, v1104 in l_next_0, l_locations_10 do
                        l_l_v490_2_0(v1104, v1103, v1101, v1102, v1099, v1100);
                    end;
                else
                    l_l_v490_2_0(l_locations_10[v297], v297, v1101, v1102, v1099, v1100);
                end;
                v439.selection = v1100;
                l_l_v489_3_1:update(v1099);
                return;
            end;
        end;
        l_decode_0.locations.search:set_callback(l_v486_4);
        l_decode_0.locations.all_maps:set_callback(l_v486_4);
    end;
    l_v487_6 = nil;
    l_v488_5 = nil;
    l_v489_3 = {
        viewangles = "4", 
        position = "3", 
        weapon = "2", 
        name = "1"
    };
    do
        local l_l_v489_3_2, l_l_v490_2_1 = l_v489_3, l_v490_2;
        l_v488_5 = function(v1107, v1108)
            -- upvalues: l_l_v489_3_2 (ref)
            return (l_l_v489_3_2[v1108[1]] or v1108[1]) > (l_l_v489_3_2[v1107[1]] or v1107[1]);
        end;
        l_l_v490_2_1 = {
            edit = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\edit.svg"), 
            warning = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\warning.svg")
        };
        local function v1133()
            -- upvalues: l_v487_6 (ref), l_type_0 (ref), l_measure_text_0 (ref), l_select_0 (ref), l_unpack_0 (ref), v91 (ref), l_floor_0 (ref), l_rect_0 (ref), l_vector_0 (ref), l_dist_0 (ref), l_rect_outline_0 (ref), l_texture_0 (ref), l_l_v490_2_1 (ref), l_text_0 (ref)
            if l_v487_6 == nil then
                return;
            else
                local v1109 = 0;
                local v1110 = 0;
                local v1111 = {};
                for v1112 = 1, #l_v487_6 do
                    local v1113 = l_v487_6[v1112];
                    local v1114 = l_type_0(v1113[1]) == "string";
                    local v1115 = l_measure_text_0(1, nil, l_select_0(v1114 and 6 or 5, l_unpack_0(v1113)));
                    local l_x_5 = v1115.x;
                    local l_y_3 = v1115.y;
                    if v1114 then
                        l_x_5 = l_x_5 + 13;
                    end;
                    if v1109 < l_x_5 then
                        v1109 = l_x_5;
                    end;
                    v1111[v1112] = v1110;
                    v1110 = v1110 + l_y_3;
                    if v1112 == 1 then
                        v1110 = v1110 + 2;
                    end;
                end;
                local v1118 = v91.x - l_floor_0(v1109 * 0.5);
                local v1119 = 140;
                l_rect_0(l_vector_0(v1118 - 4, v1119 - 3), l_vector_0(v1118 - 4, v1119 - 3) + l_vector_0(v1109 + 8, v1110 + 6), l_dist_0(16, 16, 16, 105));
                l_rect_outline_0(l_vector_0(v1118 - 5, v1119 - 4), l_vector_0(v1118 - 5, v1119 - 4) + l_vector_0(v1109 + 10, v1110 + 8), l_dist_0(16, 16, 16, 120));
                l_rect_outline_0(l_vector_0(v1118 - 6, v1119 - 5), l_vector_0(v1118 - 6, v1119 - 5) + l_vector_0(v1109 + 12, v1110 + 10), l_dist_0(16, 16, 16, 135));
                l_rect_outline_0(l_vector_0(v1118 - 7, v1119 - 6), l_vector_0(v1118 - 7, v1119 - 6) + l_vector_0(v1109 + 14, v1110 + 12), l_dist_0(16, 16, 16, 28));
                l_rect_0(l_vector_0(v1118 + 13, v1119), l_vector_0(v1118 + 13, v1119) + l_vector_0(1, 12), l_dist_0());
                for v1120 = 1, #l_v487_6 do
                    local v1121 = l_v487_6[v1120];
                    if l_type_0(v1121[1]) == "string" then
                        local v1122, v1123, v1124, v1125, v1126, v1127 = l_unpack_0(v1121);
                        l_texture_0(l_l_v490_2_1[v1122], l_vector_0(v1118 - 2, v1119 + v1111[v1120]), l_vector_0(12, 12), l_dist_0(v1123, v1124, v1125, 255));
                        l_text_0(1, l_vector_0(v1118 + 13, v1119 + v1111[v1120]), l_dist_0(v1123, v1124, v1125, v1126), nil, v1127);
                    else
                        local v1128, v1129, v1130, v1131, v1132 = l_unpack_0(l_v487_6[v1120]);
                        l_text_0(1, l_vector_0(v1118 - 2, v1119 + v1111[v1120]), l_dist_0(v1128, v1129, v1130, v1131), nil, v1132);
                    end;
                end;
                return;
            end;
        end;
        l_events_0.render(v1133);
    end;
    l_v489_3 = nil;
    l_v490_2 = l_decode_0.locations.selection;
    local l_locations_selection_0 = l_decode_0.locations.locations_selection;
    do
        local l_l_v490_2_2, l_l_locations_selection_0_0 = l_v490_2, l_locations_selection_0;
        l_v489_3 = function(v1137)
            -- upvalues: v85 (ref), l_l_v490_2_2 (ref), v271 (ref), v438 (ref), v439 (ref), v86 (ref), l_l_locations_selection_0_0 (ref), l_v486_4 (ref)
            local v1138 = v85(l_l_v490_2_2);
            local v1139 = v1137 or v271();
            local l_locations_11 = v1139.locations;
            local l_active_locations_1 = v1139.active_locations;
            v1139 = nil;
            v438 = true;
            v439 = {
                source = l_locations_11[v1138], 
                source_index = v1138, 
                enabled = l_active_locations_1[v1138]
            };
            v86(l_l_locations_selection_0_0, 1);
            l_v486_4();
            l_locations_11 = nil;
            l_active_locations_1 = nil;
        end;
        l_decode_0.locations.edit:set_callback(function()
            -- upvalues: l_v489_3 (ref)
            l_v489_3();
        end);
    end;
    l_v490_2 = {
        [0] = "Forward", 
        Left = 90, 
        Forward = 0, 
        Back = 180, 
        [180] = "Back", 
        [-90] = "Right", 
        [90] = "Left", 
        Right = -90
    };
    l_locations_selection_0 = {
        [0] = "Right", 
        [1] = "Left", 
        Left = 1, 
        [0.5] = "Left / Right", 
        ["Left / Right"] = 0.5, 
        Right = 0
    };
    local v1142 = nil;
    local l_builder_0 = l_decode_0.builder;
    do
        local l_l_builder_0_0 = l_builder_0;
        v1142 = function()
            -- upvalues: l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_read_0 (ref), v439 (ref), v297 (ref), v85 (ref), l_l_builder_0_0 (ref), v86 (ref), l_map_patterns_0 (ref)
            local v1145 = l_get_local_player_0();
            if v1145 == nil or not v1145:is_alive() then
                return;
            else
                local v1146 = v1145:get_origin();
                local v1147 = l_camera_angles_0();
                local l_m_flDuckAmount_3 = v1145.m_flDuckAmount;
                local v1149, v1150 = l_read_0(v1145);
                if v1149 == nil then
                    return;
                else
                    local l_location_7 = v439.location;
                    if l_location_7.map_name ~= v297 then
                        return;
                    else
                        local v1152 = v85(l_l_builder_0_0.type);
                        if v1150 == "weapon_wallbang" and v1152 ~= "Wallbang" then
                            v86(l_l_builder_0_0.type, "Wallbang");
                        elseif v1152 == "Wallbang" then
                            v1150 = "weapon_wallbang";
                        end;
                        local l_editing_0 = l_location_7.editing;
                        l_editing_0.position = {
                            [1] = v1146.x, 
                            [2] = v1146.y, 
                            [3] = v1146.z
                        };
                        l_editing_0.viewangles = {
                            [1] = v1147.x, 
                            [2] = v1147.y
                        };
                        l_editing_0.weapon = v1150;
                        l_editing_0.duck = l_m_flDuckAmount_3 == 1 or nil;
                        l_editing_0.strafer = nil;
                        l_map_patterns_0(nil, v439);
                        return;
                    end;
                end;
            end;
        end;
        l_l_builder_0_0.set_location:set_callback(v1142);
    end;
    l_builder_0 = nil;
    local l_sv_cheats_0 = cvar.sv_cheats;
    local l_int_0 = l_sv_cheats_0.int;
    do
        local l_l_sv_cheats_0_0, l_l_int_0_0 = l_sv_cheats_0, l_int_0;
        l_builder_0 = function()
            -- upvalues: v439 (ref), v297 (ref), l_l_int_0_0 (ref), l_l_sv_cheats_0_0 (ref), l_console_exec_0 (ref), l_format_0 (ref), l_execute_after_0 (ref)
            local l_location_8 = v439.location;
            if l_location_8.map_name ~= v297 then
                return;
            else
                local l_editing_1 = l_location_8.editing;
                local l_position_2 = l_editing_1.position;
                local l_viewangles_4 = l_editing_1.viewangles;
                local l_weapon_1 = l_editing_1.weapon;
                if l_position_2 == nil or l_viewangles_4 == nil or l_weapon_1 == nil then
                    return;
                else
                    if l_weapon_1 == "weapon_molotov" then
                        l_weapon_1 = "weapon_molotov; use weapon_incgrenade";
                    end;
                    local v1163 = l_l_int_0_0(l_l_sv_cheats_0_0);
                    l_l_int_0_0(l_l_sv_cheats_0_0, 1);
                    l_console_exec_0(l_format_0("noclip off; setpos_exact %s %s %s; setang %s %s; use %s", l_position_2[1], l_position_2[2], l_position_2[3], l_viewangles_4[1], l_viewangles_4[2], l_weapon_1));
                    l_execute_after_0(0.01, l_l_int_0_0, l_l_sv_cheats_0_0, v1163);
                    return;
                end;
            end;
        end;
        l_decode_0.builder.teleport:set_callback(l_builder_0);
    end;
    l_sv_cheats_0 = nil;
    l_int_0 = nil;
    local v1164 = nil;
    local l_builder_1 = l_decode_0.builder;
    do
        local l_l_builder_1_0 = l_builder_1;
        l_sv_cheats_0 = function()
            -- upvalues: v439 (ref), v85 (ref), l_l_builder_1_0 (ref), l_gsub_0 (ref), l_v490_2 (ref), l_locations_selection_0 (ref), l_map_patterns_0 (ref), v253 (ref), l_next_0 (ref), l_type_0 (ref), l_tostring_0 (ref), l_stringify_0 (ref), v95 (ref), l_format_0 (ref), l_concat_0 (ref), l_sort_0 (ref), l_v488_5 (ref), l_v487_6 (ref), l_decode_0 (ref), l_v481_4 (ref), v1164 (ref)
            if v439 == nil then
                return;
            else
                local l_location_9 = v439.location;
                local l_index_1 = l_location_9.index;
                local l_editing_2 = l_location_9.editing;
                local l_original_0 = l_location_9.original;
                local v1171 = v85(l_l_builder_1_0.name);
                local v1172 = v85(l_l_builder_1_0.description);
                if l_gsub_0(v1171, " ", "") == "" then
                    v1171 = "Unnamed";
                end;
                v1172 = l_gsub_0(v1172, " ", "") ~= "" and l_gsub_0(l_gsub_0(v1172, "^%s+", ""), "%s+$", "") or nil;
                local l_v1171_0 = v1171;
                l_editing_2.description = v1172;
                l_editing_2.name = l_v1171_0;
                local v1174;
                l_v1171_0, v1174 = v85(l_l_builder_1_0.type);
                if l_v1171_0 == "Grenade" then
                    if v85(l_l_builder_1_0.jump) then
                        if not v1174 then
                            v1174 = {};
                        end;
                        v1174.jump = true;
                    end;
                    local v1175 = v85(l_l_builder_1_0.run);
                    if v1175 ~= "Disabled" then
                        if not v1174 then
                            v1174 = {};
                        end;
                        v1174.run = v85(l_l_builder_1_0.run_duration);
                        local v1176 = v1175 == "Custom" and v85(l_l_builder_1_0.run_custom) or l_v490_2[v1175];
                        v1174.run_yaw = v1176 ~= 0 and v1176 or nil;
                        v1174.run_speed = v85(l_l_builder_1_0.run_walk) or nil;
                    end;
                    local v1177 = v85(l_l_builder_1_0.recovery);
                    if v1177 ~= "Disabled" then
                        if not v1174 then
                            v1174 = {};
                        end;
                        v1174.recovery_yaw = v1177 == "Custom" and v85(l_l_builder_1_0.recovery_custom) or l_v490_2[v1177];
                        v1174.recovery_jump = v85(l_l_builder_1_0.recovery_bunnyhop) or nil;
                    end;
                    local v1178 = v85(l_l_builder_1_0.strength);
                    if v1178 ~= "Left" then
                        if not v1174 then
                            v1174 = {};
                        end;
                        v1174.strength = l_locations_selection_0[v1178];
                    end;
                    local v1179 = v85(l_l_builder_1_0.delay);
                    if v1179 > 0 then
                        if not v1174 then
                            v1174 = {};
                        end;
                        v1174.delay = v1179;
                    end;
                    l_editing_2.movement = nil;
                elseif l_v1171_0 == "Wallbang" then
                    l_editing_2.weapon = "weapon_wallbang";
                    l_editing_2.movement = nil;
                end;
                l_editing_2.grenade = v1174;
                local v1180 = l_editing_2.position ~= nil and l_editing_2.viewangles ~= nil and l_editing_2.weapon ~= nil;
                if v1180 then
                    l_map_patterns_0(nil, v439);
                elseif l_index_1 == 0 and not v1180 then
                    l_map_patterns_0();
                end;
                local v1181 = false;
                local v1182 = v253(l_editing_2);
                local v1183 = v253(l_original_0);
                local v1184 = {};
                for v1185, v1186 in l_next_0, v1182 do
                    local v1187 = l_type_0(v1186) ~= "table" and l_tostring_0(v1186) or l_stringify_0(v1186);
                    local v1188 = v1183[v1185];
                    if v1185 == "name" and l_type_0(v1188) == "table" then
                        local v1189 = v1188[2];
                        if v1189 then
                            v1188 = v1189;
                        end;
                    end;
                    local v1190 = v1187 ~= (l_type_0(v1188) ~= "table" and l_tostring_0(v1188) or l_stringify_0(v1188));
                    if v1190 then
                        v1181 = true;
                    end;
                    if v1185 == "movement.steps" then
                        local v1191 = "movement";
                        v1187 = v1186 ~= nil and #v1186;
                        v1185 = v1191;
                    elseif v1185 == "movement.frames" then
                        local v1192 = "movement";
                        v1187 = v1186 ~= nil and #v1186;
                        v1185 = v1192;
                    end;
                    local v1193 = {};
                    local v1194 = v95.highlight(v1187, v1190 and {
                        [1] = 244, 
                        [2] = 147, 
                        [3] = 134
                    } or {
                        [1] = 221, 
                        [2] = 221, 
                        [3] = 221
                    }, v1190 and {
                        [1] = 223, 
                        [2] = 57, 
                        [3] = 35
                    } or {
                        [1] = 218, 
                        [2] = 230, 
                        [3] = 30
                    }, v1190 and {
                        [1] = 209, 
                        [2] = 42, 
                        [3] = 62
                    } or {
                        [1] = 180, 
                        [2] = 230, 
                        [3] = 30
                    }, v1190 and {
                        [1] = 209, 
                        [2] = 42, 
                        [3] = 62
                    } or {
                        [1] = 96, 
                        [2] = 160, 
                        [3] = 220
                    });
                    for v1195 = 1, #v1194 do
                        local v1196 = v1194[v1195];
                        local v1197 = v1196[1];
                        local v1198 = v1196[2];
                        local v1199 = v1196[3];
                        local v1200 = v1196[4];
                        v1193[#v1193 + 1] = l_format_0("\a%02X%02X%02XFF%s", v1197, v1198, v1199, v1200);
                    end;
                    v1193 = l_concat_0(v1193);
                    v1184[#v1184 + 1] = {
                        [1] = v1185, 
                        [2] = v1193, 
                        [3] = v1190
                    };
                end;
                l_sort_0(v1184, l_v488_5);
                l_v487_6 = {
                    [1] = {
                        [1] = "edit", 
                        [2] = 255, 
                        [3] = 255, 
                        [4] = 255, 
                        [5] = 220, 
                        [6] = " Editing Location:"
                    }
                };
                for _, v1202 in l_next_0, v1184 do
                    l_v487_6[#l_v487_6 + 1] = {
                        [1] = 255, 
                        [2] = 255, 
                        [3] = 255, 
                        [4] = 220, 
                        [5] = v1202[1] .. ": " .. v1202[2]
                    };
                end;
                local l_weapon_2 = l_editing_2.weapon;
                local v1204 = l_weapon_2 == nil or l_decode_0.types[l_weapon_2];
                local l_enabled_0 = v439.enabled;
                if v1181 or not v1204 or not l_enabled_0 then
                    l_v487_6[#l_v487_6 + 1] = {
                        [1] = 255, 
                        [2] = 255, 
                        [3] = 255, 
                        [4] = 255, 
                        [5] = " "
                    };
                end;
                if v1181 then
                    l_v487_6[#l_v487_6 + 1] = {
                        [1] = "warning", 
                        [2] = 234, 
                        [3] = 64, 
                        [4] = 18, 
                        [5] = 220, 
                        [6] = "You have unsaved changes! Make sure to click Save."
                    };
                end;
                if not v1204 then
                    l_v487_6[#l_v487_6 + 1] = {
                        "warning", 
                        234, 
                        64, 
                        18, 
                        220, 
                        l_format_0("Location not shown because type \"%s\" is not enabled.", l_v481_4[l_weapon_2])
                    };
                end;
                if not l_enabled_0 then
                    l_v487_6[#l_v487_6 + 1] = {
                        "warning", 
                        234, 
                        64, 
                        18, 
                        220, 
                        l_format_0("Location not shown because source \"%s\" is not enabled.", v439.source.name)
                    };
                end;
                v1164 = #l_v487_6 + 1;
                return;
            end;
        end;
        local v1206 = {
            save = true, 
            teleport = true, 
            record = true, 
            export = true
        };
        l_int_0 = function(v1207)
            -- upvalues: l_next_0 (ref), l_l_builder_1_0 (ref), v1206 (ref), l_sv_cheats_0 (ref)
            for v1208, v1209 in l_next_0, l_l_builder_1_0 do
                if v1206[v1208] == nil then
                    if v1207 then
                        v1209:set_callback(l_sv_cheats_0);
                    else
                        v1209:unset_callback(l_sv_cheats_0);
                    end;
                end;
            end;
        end;
        l_int_0(true);
        l_decode_0.types.selection:set_callback(l_sv_cheats_0);
        local v1210 = {};
        local v1211 = v84("Miscellaneous", "Main", "Movement", "Air Duck");
        local v1212 = v84("Miscellaneous", "Main", "Movement", "Air Strafe");
        local v1213 = v84("Miscellaneous", "Main", "Movement", "Quick Stop");
        local v1214 = v84("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe");
        local v1215 = v84("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing");
        local v1216 = v84("Miscellaneous", "Main", "Movement", "Strafe Assist");
        local v1217 = v84("Miscellaneous", "Main", "Movement", "Edge Jump");
        local l_builder_2 = l_decode_0.builder;
        local l_set_location_hotkey_0 = l_builder_2.set_location_hotkey;
        local l_teleport_hotkey_0 = l_builder_2.teleport_hotkey;
        local l_get_4 = l_set_location_hotkey_0.get;
        local v1222 = nil;
        local v1223 = nil;
        local function v1244(v1224)
            -- upvalues: v439 (ref), v1210 (ref), l_get_4 (ref), l_set_location_hotkey_0 (ref), v1223 (ref), v1142 (ref), l_teleport_hotkey_0 (ref), v1222 (ref), l_builder_0 (ref), l_builder_2 (ref), l_get_local_player_0 (ref), l_sv_cheats_0 (ref), l_read_0 (ref), l_camera_angles_0 (ref), v1213 (ref), v1212 (ref), v1214 (ref), v1215 (ref), l_v487_6 (ref), v1164 (ref), l_format_0 (ref), l_globals_0 (ref), v87 (ref), v1211 (ref), v1216 (ref), v1217 (ref)
            if v439 == nil then
                v1210 = {};
                return;
            else
                local v1225 = l_get_4(l_set_location_hotkey_0);
                if v1225 and v1223 == nil then
                    v1223 = true;
                    v1142();
                elseif not v1225 then
                    v1223 = nil;
                end;
                local v1226 = l_get_4(l_teleport_hotkey_0);
                if v1226 and v1222 == nil then
                    v1222 = true;
                    l_builder_0();
                elseif not v1226 then
                    v1222 = nil;
                end;
                if l_get_4(l_builder_2.type) ~= "Movement" then
                    v1210 = {};
                    return;
                else
                    local v1227 = l_get_local_player_0();
                    if v1227 == nil or not v1227:is_alive() then
                        v1210 = {};
                        return;
                    else
                        local l_editing_3 = v439.location.editing;
                        local l_start_at_0 = v1210.start_at;
                        local l_movement_1 = v1210.movement;
                        if not l_get_4(l_builder_2.record) then
                            if l_movement_1 ~= nil then
                                l_editing_3.movement = l_movement_1;
                                l_sv_cheats_0();
                            end;
                            v1210 = {};
                            return;
                        else
                            local _, v1232 = l_read_0(v1227);
                            local v1233 = v1227:get_origin();
                            local v1234 = l_camera_angles_0();
                            local v1235 = v1227.m_vecAbsVelocity:length2d();
                            if l_start_at_0 == nil and v1235 < 2 then
                                local v1236 = {
                                    [1] = v1233.x, 
                                    [2] = v1233.y, 
                                    [3] = v1233.z
                                };
                                l_editing_3.viewangles = {
                                    [1] = v1234.x, 
                                    [2] = v1234.y
                                };
                                l_editing_3.position = v1236;
                                l_editing_3.weapon = v1232;
                                if l_editing_3.strafer == nil then
                                    l_editing_3.strafer = {};
                                    l_editing_3.strafer.quick_stop = l_get_4(v1213);
                                    l_editing_3.strafer.air_strafe = l_get_4(v1212);
                                    l_editing_3.strafer.wasd_strafer = l_get_4(v1214);
                                    l_editing_3.strafer.strafer_smoothing = l_get_4(v1215);
                                end;
                                v1236 = v1224.command_number;
                                l_movement_1 = {
                                    steps = {}
                                };
                                l_start_at_0 = v1236;
                                v1236 = v1210;
                                local l_v1210_0 = v1210;
                                local l_l_start_at_0_0 = l_start_at_0;
                                l_v1210_0.movement = l_movement_1;
                                v1236.start_at = l_l_start_at_0_0;
                            end;
                            local v1239 = l_start_at_0 == nil and 0 or v1224.command_number - v1210.start_at;
                            l_v487_6[v1164] = {
                                234, 
                                64, 
                                18, 
                                220, 
                                l_format_0("Recorded for %.2fs", l_globals_0.tickinterval * v1239)
                            };
                            if v1239 == 0 then
                                return;
                            else
                                v87(v1211, false);
                                v87(v1212);
                                v87(v1216, true);
                                v87(v1217, false);
                                local v1240 = nil;
                                if v1224.in_forward then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_forward = true;
                                end;
                                if v1224.in_moveleft then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_moveleft = true;
                                end;
                                if v1224.in_moveright then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_moveright = true;
                                end;
                                if v1224.in_back then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_back = true;
                                end;
                                if v1224.in_duck then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_duck = true;
                                end;
                                if v1224.in_attack then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_attack = true;
                                end;
                                if v1224.in_attack2 then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_attack2 = true;
                                end;
                                if v1224.in_jump then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_jump = true;
                                end;
                                if v1224.in_use then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_use = true;
                                end;
                                if v1224.in_speed then
                                    if not v1240 then
                                        v1240 = {};
                                    end;
                                    v1240.in_speed = true;
                                end;
                                local l_move_yaw_0 = v1224.move_yaw;
                                local l_forwardmove_1 = v1224.forwardmove;
                                local l_sidemove_1 = v1224.sidemove;
                                l_movement_1.steps[#l_movement_1.steps + 1] = {
                                    move_yaw = l_move_yaw_0, 
                                    forwardmove = l_forwardmove_1 ~= 0 and l_forwardmove_1 or nil, 
                                    sidemove = l_sidemove_1 ~= 0 and l_sidemove_1 or nil, 
                                    buttons = v1240, 
                                    viewangles = {
                                        [1] = v1234.x, 
                                        [2] = v1234.y
                                    }
                                };
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        l_events_0.createmove(v1244);
    end;
    l_builder_1 = nil;
    local l_builder_3 = l_decode_0.builder;
    local l_locations_selection_1 = l_decode_0.locations.locations_selection;
    do
        local l_l_builder_3_0, l_l_locations_selection_1_0 = l_builder_3, l_locations_selection_1;
        l_builder_1 = function()
            -- upvalues: v439 (ref), l_int_0 (ref), v85 (ref), l_l_locations_selection_1_0 (ref), l_l_builder_3_0 (ref), v297 (ref), l_sv_cheats_0 (ref), v86 (ref), l_type_0 (ref), l_v490_2 (ref), l_locations_selection_0 (ref), v242 (ref)
            if v439 == nil then
                return;
            else
                l_int_0(false);
                local v1249 = v85(l_l_locations_selection_1_0);
                local v1250 = v439.selection[v1249];
                if v1250 == nil then
                    l_l_builder_3_0.type:reset();
                    l_l_builder_3_0.name:reset();
                    l_l_builder_3_0.description:reset();
                    l_l_builder_3_0.jump:reset();
                    l_l_builder_3_0.run:reset();
                    l_l_builder_3_0.run_custom:reset();
                    l_l_builder_3_0.run_duration:reset();
                    l_l_builder_3_0.run_walk:reset();
                    l_l_builder_3_0.recovery:reset();
                    l_l_builder_3_0.recovery_custom:reset();
                    l_l_builder_3_0.recovery_bunnyhop:reset();
                    l_l_builder_3_0.strength:reset();
                    l_l_builder_3_0.delay:reset();
                    v439.location = {
                        index = 0, 
                        map_name = v297, 
                        editing = {}, 
                        original = {}
                    };
                    l_sv_cheats_0();
                    return l_int_0(true);
                else
                    local l_map_name_1 = v1250.map_name;
                    local l_index_2 = v1250.index;
                    v1250 = v439.source.locations[l_map_name_1][l_index_2];
                    if v1250.movement ~= nil then
                        v86(l_l_builder_3_0.type, "Movement");
                    elseif v1250.weapon == "weapon_wallbang" then
                        v86(l_l_builder_3_0.type, "Wallbang");
                    else
                        v86(l_l_builder_3_0.type, "Grenade");
                    end;
                    local l_name_5 = v1250.name;
                    local v1254 = v1250.description or "";
                    if l_type_0(l_name_5) == "table" then
                        local v1255 = l_name_5[2];
                        if v1255 then
                            l_name_5 = v1255;
                        end;
                    end;
                    v86(l_l_builder_3_0.name, l_name_5);
                    v86(l_l_builder_3_0.description, v1254);
                    local v1256 = v1250.grenade or {};
                    local v1257 = v1256.jump or false;
                    v86(l_l_builder_3_0.jump, v1257);
                    local l_run_0 = v1256.run;
                    local l_run_yaw_0 = v1256.run_yaw;
                    local v1260 = v1256.run_speed or false;
                    local v1261 = l_run_0 == nil and "Disabled" or l_run_yaw_0 == nil and "Forward" or l_v490_2[l_run_yaw_0] or "Custom";
                    v86(l_l_builder_3_0.run, v1261);
                    v86(l_l_builder_3_0.run_custom, l_run_yaw_0 or 0);
                    v86(l_l_builder_3_0.run_duration, l_run_0 or 0);
                    v86(l_l_builder_3_0.run_walk, v1260);
                    local l_recovery_yaw_0 = v1256.recovery_yaw;
                    local v1263 = v1256.recovery_jump or false;
                    local v1264 = l_recovery_yaw_0 == nil and "Disabled" or l_v490_2[l_recovery_yaw_0] or "Custom";
                    v86(l_l_builder_3_0.recovery, v1264);
                    v86(l_l_builder_3_0.recovery_custom, l_recovery_yaw_0 or 0);
                    v86(l_l_builder_3_0.recovery_bunnyhop, v1263);
                    local v1265 = l_locations_selection_0[v1256.strength or 1];
                    v86(l_l_builder_3_0.strength, v1265);
                    local v1266 = v1256.delay or 0;
                    v86(l_l_builder_3_0.delay, v1266);
                    v439.location = {
                        index = l_index_2, 
                        map_name = v297, 
                        editing = v242(v1250), 
                        original = v1250
                    };
                    l_sv_cheats_0();
                    l_int_0(true);
                    return;
                end;
            end;
        end;
        l_l_locations_selection_1_0:set_callback(l_builder_1);
    end;
    l_builder_3 = nil;
    l_builder_3 = function()
        -- upvalues: v439 (ref), l_stringify_0 (ref), v95 (ref), v93 (ref)
        local l_editing_4 = v439.location.editing;
        local v1268 = l_stringify_0(l_editing_4);
        v1268 = v95.format(v1268, "\n", "  ");
        v95.print_highlighted(v1268);
        v93.set(v1268);
    end;
    l_decode_0.builder.export:set_callback(l_builder_3);
    l_locations_selection_1 = nil;
    l_locations_selection_1 = function()
        -- upvalues: v439 (ref), v271 (ref), v272 (ref), l_v489_3 (ref), l_builder_1 (ref)
        local l_location_10 = v439.location;
        local l_editing_5 = l_location_10.editing;
        if l_editing_5.position == nil or l_editing_5.viewangles == nil or l_editing_5.weapon == nil then
            return;
        else
            local l_source_index_0 = v439.source_index;
            local v1272 = v271();
            local l_locations_12 = v1272.locations[l_source_index_0].locations;
            local l_index_3 = l_location_10.index;
            local l_map_name_2 = l_location_10.map_name;
            if l_index_3 == 0 then
                local v1276 = l_locations_12[l_map_name_2];
                if v1276 == nil then
                    v1276 = {};
                    l_locations_12[l_map_name_2] = v1276;
                end;
                v1276[#v1276 + 1] = l_editing_5;
            else
                l_locations_12[l_map_name_2][l_index_3] = l_editing_5;
            end;
            v272(v1272);
            l_v489_3(v1272);
            v1272 = nil;
            local _ = nil;
            l_builder_1();
            return;
        end;
    end;
    l_decode_0.builder.save:set_callback(l_locations_selection_1);
    local v1278 = nil;
    local function v1286(v1279)
        -- upvalues: l_type_0 (ref)
        if l_type_0(v1279) ~= "table" then
            return false, "wrong type, expected table";
        else
            local l_name_6 = v1279.name;
            if (l_type_0(l_name_6) ~= "string" or #l_name_6 <= 0) and (l_type_0(l_name_6) ~= "table" or #l_name_6 ~= 2) then
                return false, "invalid name, expected string or table of length 2";
            else
                local l_description_1 = v1279.description;
                if l_description_1 ~= nil and (l_type_0(l_description_1) ~= "string" or #l_description_1 == 0) then
                    return false, "invalid description, expected nil or non-empty string";
                else
                    local l_weapon_3 = v1279.weapon;
                    if l_type_0(l_weapon_3) ~= "string" or #l_weapon_3 == 0 then
                        return false, "invalid weapon";
                    else
                        local l_position_3 = v1279.position;
                        if l_type_0(l_position_3) == "table" and #l_position_3 == 3 then
                            if l_type_0(l_position_3[1]) ~= "number" or l_type_0(l_position_3[2]) ~= "number" or l_type_0(l_position_3[3]) ~= "number" then
                                return false, "invalid type in position";
                            else
                                local l_viewangles_5 = v1279.viewangles;
                                if l_type_0(l_viewangles_5) == "table" or #l_viewangles_5 == 2 then
                                    if l_type_0(l_viewangles_5[1]) ~= "number" or l_type_0(l_viewangles_5[2]) ~= "number" then
                                        return false, "invalid type in viewangles";
                                    else
                                        local l_duck_1 = v1279.duck;
                                        if l_duck_1 ~= nil and l_type_0(l_duck_1) ~= "boolean" then
                                            return false, "invalid duck";
                                        else
                                            return true;
                                        end;
                                    end;
                                else
                                    return false, "invalid viewangles";
                                end;
                            end;
                        else
                            return false, "invalid position";
                        end;
                    end;
                end;
            end;
        end;
    end;
    local v1287 = nil;
    local v1288 = {};
    for v1289 = 128, 255 do
        v1288[#v1288 + 1] = l_char_0(v1289);
    end;
    v1288 = l_concat_0(v1288);
    v1288 = l_format_0("[%s]", v1288);
    do
        local l_v1288_0 = v1288;
        v1287 = function(v1291)
            -- upvalues: l_gsub_0 (ref), l_v1288_0 (ref)
            return l_gsub_0(v1291, l_v1288_0, "");
        end;
    end;
    do
        local l_v1286_0, l_v1287_0, l_v1288_1 = v1286, v1287, v1288;
        l_v1288_1 = function(v1295, v1296, v1297, v1298)
            -- upvalues: l_type_0 (ref), l_find_0 (ref), l_encode_0 (ref), l_format_0 (ref), l_v1286_0 (ref)
            if l_type_0(v1297) ~= "string" or l_find_0(v1297, " ") ~= nil then
                return l_encode_0(l_format_0("Failed to import: Invalid map name (%s)", v1297));
            elseif v1296 == nil then
                return;
            else
                local v1299 = v1295[v1297];
                if v1299 == nil then
                    v1299 = {};
                    v1295[v1297] = v1299;
                end;
                for v1300 = 1, #v1296 do
                    local v1301 = v1296[v1300];
                    local l_position_4 = v1301.position;
                    local l_viewangles_6 = v1301.viewangles;
                    local v1304 = v1297 .. v1301.weapon .. l_position_4[1] .. l_position_4[2] .. l_position_4[3] .. l_viewangles_6[1] .. l_viewangles_6[2];
                    if v1298[v1304] == nil then
                        local v1305, v1306 = l_v1286_0(v1301);
                        if v1305 then
                            v1299[#v1299 + 1] = v1301;
                        else
                            l_encode_0(l_format_0("[%s] location: [%s] skipped due to %s", v1297, v1300, v1306));
                        end;
                        v1298[v1304] = v1300;
                    else
                        l_encode_0(l_format_0("[%s] location: [%s] skipped due to duplication [%s]", v1297, v1300, v1298[v1304]));
                    end;
                end;
                return;
            end;
        end;
        v1278 = function()
            -- upvalues: v93 (ref), l_encode_0 (ref), l_v1287_0 (ref), l_pcall_0 (ref), l_parse_0 (ref), l_type_0 (ref), l_sub_0 (ref), v439 (ref), l_next_0 (ref), l_v1288_1 (ref), v297 (ref), v271 (ref), v272 (ref), l_v486_4 (ref), l_map_patterns_0 (ref)
            local v1307 = v93.get();
            if v1307 == nil then
                return l_encode_0("Failed to import: Clipboard is empty");
            else
                v1307 = l_v1287_0(v1307);
                local v1308, v1309 = l_pcall_0(l_parse_0, v1307);
                if not v1308 or l_type_0(v1309) ~= "table" then
                    return l_encode_0("Failed to import: Invalid JSON");
                else
                    local v1310 = l_sub_0(v1307, 1, 1) == "[";
                    if not v1310 and (v1309.name ~= nil or v1309.grenade ~= nil or v1309.weapon ~= nil) then
                        v1309 = {
                            [1] = v1309
                        };
                        v1310 = true;
                    end;
                    local l_locations_13 = v439.source.locations;
                    local v1312 = {};
                    for v1313, v1314 in l_next_0, l_locations_13 do
                        for v1315 = 1, #v1314 do
                            local v1316 = v1314[v1315];
                            local l_position_5 = v1316.position;
                            local l_viewangles_7 = v1316.viewangles;
                            v1312[v1313 .. v1316.weapon .. l_position_5[1] .. l_position_5[2] .. l_position_5[3] .. l_viewangles_7[1] .. l_viewangles_7[2]] = v1315;
                        end;
                    end;
                    if v1310 then
                        l_v1288_1(l_locations_13, v1309, v297, v1312);
                    else
                        for v1319, v1320 in l_next_0, v1309 do
                            l_v1288_1(l_locations_13, v1320, v1319, v1312);
                        end;
                    end;
                    local l_source_index_1 = v439.source_index;
                    local l_enabled_1 = v439.enabled;
                    local v1323 = v271();
                    v1323.locations[l_source_index_1].locations = l_locations_13;
                    v272(v1323);
                    l_v486_4();
                    if l_enabled_1 then
                        l_map_patterns_0();
                    end;
                    v1323 = nil;
                    local _ = nil;
                    return;
                end;
            end;
        end;
        l_decode_0.locations.import:set_callback(v1278);
    end;
    v1286 = nil;
    v1287 = l_decode_0.locations.all_maps;
    do
        local l_v1287_1 = v1287;
        v1286 = function()
            -- upvalues: v439 (ref), v85 (ref), l_v1287_1 (ref), v297 (ref), l_next_0 (ref), l_stringify_0 (ref), v95 (ref), v93 (ref)
            local l_locations_14 = v439.source.locations;
            if not (v85(l_v1287_1) and v297 ~= nil) then
                l_locations_14 = l_locations_14[v297];
            end;
            if l_locations_14 == nil or l_next_0(l_locations_14) == nil then
                return;
            else
                local v1327 = l_stringify_0(l_locations_14);
                v1327 = v95.format(v1327, "\n", "  ");
                v95.print_highlighted(v1327);
                v93.set(v1327);
                return;
            end;
        end;
        l_decode_0.locations.export:set_callback(v1286);
    end;
    v1287 = nil;
    v1288 = l_decode_0.locations.locations_selection;
    do
        local l_v1288_2 = v1288;
        v1287 = function()
            -- upvalues: v85 (ref), l_v1288_2 (ref), v439 (ref), l_remove_0 (ref), v271 (ref), v272 (ref), l_v486_4 (ref), l_map_patterns_0 (ref), v86 (ref)
            local v1329 = v85(l_v1288_2);
            local v1330 = v439.selection[v1329];
            local l_locations_15 = v439.source.locations;
            local l_map_name_3 = v1330.map_name;
            local l_index_4 = v1330.index;
            local v1334 = l_locations_15[l_map_name_3];
            l_remove_0(v1334, l_index_4);
            if #v1334 == 0 then
                l_locations_15[l_map_name_3] = nil;
            end;
            local l_source_index_2 = v439.source_index;
            local l_enabled_2 = v439.enabled;
            local v1337 = v271();
            v1337.locations[l_source_index_2].locations = l_locations_15;
            v272(v1337);
            l_v486_4();
            if l_enabled_2 then
                l_map_patterns_0();
            end;
            v1337 = nil;
            local _ = nil;
            v86(l_v1288_2, v1329 - 1);
        end;
        l_decode_0.locations.delete_location_confirm:set_callback(v1287);
    end;
    v1288 = nil;
    local l_locations_selection_2 = l_decode_0.locations.locations_selection;
    do
        local l_l_locations_selection_2_0 = l_locations_selection_2;
        v1288 = function()
            -- upvalues: v438 (ref), v439 (ref), l_v487_6 (ref), l_l_locations_selection_2_0 (ref), l_map_patterns_0 (ref)
            v438 = false;
            v439 = nil;
            l_v487_6 = nil;
            l_l_locations_selection_2_0:update({});
            l_map_patterns_0();
        end;
        l_decode_0.locations.back:set_callback(v1288);
    end;
end;