-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = true;
local function v5(v0)
    return function(v1)
        local v2 = v1:gsub("\a(%x%x%x%x%x%x)", "");
        local v3 = ("\aFF0000[xo-yaw errors] \a12bffc[%s] \aDEFAULT%s"):format(v0, v1);
        local v4 = ("[xo-yaw errors] [%s] %s"):format(v0, v2);
        print_raw(v3);
        print_dev(v4);
    end;
end;
local l_events_0 = events;
events = setmetatable({}, {
    __index = function(_, v8)
        return {
            set = function(_, v10)
                l_events_0[v8]:set(function(...)
                    local v11 = {
                        xpcall(v10, v5(v8), ...)
                    };
                    if v11[1] then
                        table.remove(v11, 1);
                        return unpack(v11);
                    else
                        return ;
                    end;
                end);
            end
        };
    end
});
xpcall(function()
    local l_print_0 = print;
    local l_print_raw_0 = print_raw;
    local l_format_0 = string.format;
    local l_sub_0 = string.sub;
    local l_byte_0 = string.byte;
    local l_char_0 = string.char;
    local l_insert_0 = table.insert;
    local l_remove_0 = table.remove;
    local l_floor_0 = math.floor;
    local l_max_0 = math.max;
    local l_min_0 = math.min;
    local l_abs_0 = math.abs;
    local l_sin_0 = math.sin;
    local l_ceil_0 = math.ceil;
    local l_normalize_yaw_0 = math.normalize_yaw;
    local l_load_0 = ffi.load;
    local l_cast_0 = ffi.cast;
    local _ = ffi.cdef;
    local l_C_0 = ffi.C;
    local l_screen_size_0 = render.screen_size;
    local l_get_alpha_0 = ui.get_alpha;
    local l_find_0 = ui.find;
    local l_get_icon_0 = ui.get_icon;
    local l_get_style_0 = ui.get_style;
    local l_create_0 = ui.create;
    local l_get_binds_0 = ui.get_binds;
    local l_sidebar_0 = ui.sidebar;
    local l_get_local_player_0 = entity.get_local_player;
    local l_get_0 = entity.get;
    local l_get_entities_0 = entity.get_entities;
    local l_get_players_0 = entity.get_players;
    local l_trace_line_0 = utils.trace_line;
    local l_net_channel_0 = utils.net_channel;
    local l_console_exec_0 = utils.console_exec;
    local l_random_int_0 = utils.random_int;
    local l_opcode_scan_0 = utils.opcode_scan;
    local l_get_username_0 = common.get_username;
    local l_set_clan_tag_0 = common.set_clan_tag;
    local v251 = (function()
        local v50 = table.unpack or unpack;
        local l_concat_0 = table.concat;
        local l_byte_1 = string.byte;
        local l_char_1 = string.char;
        local l_rep_0 = string.rep;
        local l_sub_1 = string.sub;
        local l_format_1 = string.format;
        local l_floor_1 = math.floor;
        local l_ceil_1 = math.ceil;
        local l_min_1 = math.min;
        local l_max_1 = math.max;
        local v61 = nil;
        local v62 = nil;
        local v63 = nil;
        local v64 = nil;
        local v65 = nil;
        local v66 = nil;
        local v67 = nil;
        local v68 = nil;
        v64 = function(v69, v70)
            return (v69 * 2 ^ v70) % 4294967296;
        end;
        v65 = function(v71, v72)
            v71 = (v71 % 4294967296) / 2 ^ v72;
            return v71 - v71 % 1;
        end;
        v66 = function(v73, v74)
            v73 = (v73 % 4294967296) * 2 ^ v74;
            local v75 = v73 % 4294967296;
            return v75 + (v73 - v75) / 4294967296;
        end;
        v67 = function(v76, v77)
            v76 = (v76 % 4294967296) / 2 ^ v77;
            local v78 = v76 % 1;
            return (v78 * 4294967296 + v76) - v78;
        end;
        local v79 = {};
        for v80 = 0, 65535 do
            local v81 = v80 % 256;
            local v82 = (v80 - v81) / 256;
            local v83 = 0;
            local v84 = 1;
            while v81 * v82 ~= 0 do
                local v85 = v81 % 2;
                local v86 = v82 % 2;
                v83 = v83 + (v85 * v86) * v84;
                v81 = (v81 - v85) / 2;
                v82 = (v82 - v86) / 2;
                v84 = v84 * 2;
            end;
            v79[v80] = v83;
        end;
        local function v95(v87, v88, v89)
            local v90 = v87 % 4294967296;
            local v91 = v88 % 4294967296;
            local v92 = v90 % 256;
            local v93 = v91 % 256;
            local v94 = v79[v92 + v93 * 256];
            v87 = v90 - v92;
            v88 = (v91 - v93) / 256;
            v92 = v87 % 65536;
            v93 = v88 % 256;
            v94 = v94 + v79[v92 + v93] * 256;
            v87 = (v87 - v92) / 256;
            v88 = (v88 - v93) / 256;
            v92 = v87 % 65536 + v88 % 256;
            v94 = (v94 + v79[v92] * 65536) + v79[((v87 + v88) - v92) / 256] * 16777216;
            if v89 then
                v94 = (v90 + v91) - v89 * v94;
            end;
            return v94;
        end;
        v61 = function(v96, v97)
            return v95(v96, v97);
        end;
        v62 = function(v98, v99)
            return v95(v98, v99, 1);
        end;
        v63 = function(v100, v101, v102)
            if v102 then
                v101 = v95(v101, v102, 2);
            end;
            return v95(v100, v101, 2);
        end;
        v68 = function(v103)
            return l_format_1("%08x", v103 % 4294967296);
        end;
        local v104 = {};
        local v105 = {};
        local v106 = {};
        local v107 = {};
        local v108 = {
            [224] = {}, 
            [256] = v107
        };
        local v109 = {
            [384] = {}, 
            [512] = v106
        };
        local v110 = {
            [384] = {}, 
            [512] = v107
        };
        local v111 = {};
        local function v140(v112, v113, v114, v115, v116, v117)
            for v118 = v116, (v117 + v116) - 1, 64 do
                for v119 = 1, 16 do
                    v118 = v118 + 4;
                    local v120, v121, v122, v123 = l_byte_1(v114, v118 - 3, v118);
                    v115[v119] = ((v120 * 256 + v121) * 256 + v122) * 256 + v123;
                end;
                for v124 = 17, 64 do
                    local v125 = v115[v124 - 15];
                    local v126 = v115[v124 - 2];
                    v115[v124] = ((v63(v67(v125, 7), v66(v125, 14), v65(v125, 3)) + v63(v66(v126, 15), v66(v126, 13), v65(v126, 10))) + v115[v124 - 7]) + v115[v124 - 16];
                end;
                local v127 = v112[1];
                local v128 = v112[2];
                local v129 = v112[3];
                local v130 = v112[4];
                local v131 = v112[5];
                local v132 = v112[6];
                local v133 = v112[7];
                local v134 = v112[8];
                local v135 = nil;
                for v136 = 1, 64 do
                    v135 = ((((v63(v67(v131, 6), v67(v131, 11), v66(v131, 7)) + v61(v131, v132)) + v61(-1 - v131, v133)) + v134) + v113[v136]) + v115[v136];
                    v134 = v133;
                    v133 = v132;
                    v132 = v131;
                    v131 = v135 + v130;
                    v130 = v129;
                    v129 = v128;
                    v128 = v127;
                    v127 = ((v135 + v61(v130, v129)) + v61(v127, v63(v130, v129))) + v63(v67(v127, 2), v67(v127, 13), v66(v127, 10));
                end;
                local v137 = (v127 + v112[1]) % 4294967296;
                local v138 = (v128 + v112[2]) % 4294967296;
                local v139 = (v129 + v112[3]) % 4294967296;
                v112[4] = (v130 + v112[4]) % 4294967296;
                v112[3] = v139;
                v112[2] = v138;
                v112[1] = v137;
                v137 = (v131 + v112[5]) % 4294967296;
                v138 = (v132 + v112[6]) % 4294967296;
                v139 = (v133 + v112[7]) % 4294967296;
                v112[8] = (v134 + v112[8]) % 4294967296;
                v112[7] = v139;
                v112[6] = v138;
                v112[5] = v137;
            end;
        end;
        local function v183(v141, v142, v143, v144, v145, v146, v147, v148)
            for v149 = v147, (v148 + v147) - 1, 128 do
                for v150 = 1, 32 do
                    v149 = v149 + 4;
                    local v151, v152, v153, v154 = l_byte_1(v145, v149 - 3, v149);
                    v146[v150] = ((v151 * 256 + v152) * 256 + v153) * 256 + v154;
                end;
                local v155 = nil;
                local v156 = nil;
                for v157 = 34, 160, 2 do
                    local v158 = v146[v157 - 30];
                    local v159 = v146[v157 - 31];
                    local v160 = v146[v157 - 4];
                    local v161 = v146[v157 - 5];
                    v155 = ((v63(v65(v158, 1) + v64(v159, 31), v65(v158, 8) + v64(v159, 24), v65(v158, 7) + v64(v159, 25)) + v63(v65(v160, 19) + v64(v161, 13), v64(v160, 3) + v65(v161, 29), v65(v160, 6) + v64(v161, 26))) + v146[v157 - 14]) + v146[v157 - 32];
                    v156 = v155 % 4294967296;
                    v146[v157 - 1] = (((v63(v65(v159, 1) + v64(v158, 31), v65(v159, 8) + v64(v158, 24), v65(v159, 7)) + v63(v65(v161, 19) + v64(v160, 13), v64(v161, 3) + v65(v160, 29), v65(v161, 6))) + v146[v157 - 15]) + v146[v157 - 33]) + (v155 - v156) / 4294967296;
                    v146[v157] = v156;
                end;
                local v162 = v141[1];
                local v163 = v141[2];
                local v164 = v141[3];
                local v165 = v141[4];
                local v166 = v141[5];
                local v167 = v141[6];
                local v168 = v141[7];
                local v169 = v141[8];
                local v170 = nil;
                local v171 = v142[1];
                local v172 = v142[2];
                local v173 = v142[3];
                local v174 = v142[4];
                local v175 = v142[5];
                local v176 = v142[6];
                local v177 = v142[7];
                local v178 = v142[8];
                local v179 = nil;
                for v180 = 1, 80 do
                    local v181 = 2 * v180;
                    v155 = ((((v63(v65(v166, 14) + v64(v175, 18), v65(v166, 18) + v64(v175, 14), v64(v166, 23) + v65(v175, 9)) + v61(v166, v167)) + v61(-1 - v166, v168)) + v169) + v143[v180]) + v146[v181];
                    v170 = v155 % 4294967296;
                    v179 = (((((v63(v65(v175, 14) + v64(v166, 18), v65(v175, 18) + v64(v166, 14), v64(v175, 23) + v65(v166, 9)) + v61(v175, v176)) + v61(-1 - v175, v177)) + v178) + v144[v180]) + v146[v181 - 1]) + (v155 - v170) / 4294967296;
                    v169 = v168;
                    v178 = v177;
                    v168 = v167;
                    v177 = v176;
                    v167 = v166;
                    v176 = v175;
                    v155 = v170 + v165;
                    v166 = v155 % 4294967296;
                    v175 = (v179 + v174) + (v155 - v166) / 4294967296;
                    v165 = v164;
                    v174 = v173;
                    v164 = v163;
                    v173 = v172;
                    v163 = v162;
                    v172 = v171;
                    v155 = ((v170 + v61(v165, v164)) + v61(v163, v63(v165, v164))) + v63(v65(v163, 28) + v64(v172, 4), v64(v163, 30) + v65(v172, 2), v64(v163, 25) + v65(v172, 7));
                    v162 = v155 % 4294967296;
                    v171 = (((v179 + v61(v174, v173)) + v61(v172, v63(v174, v173))) + v63(v65(v172, 28) + v64(v163, 4), v64(v172, 30) + v65(v163, 2), v64(v172, 25) + v65(v163, 7))) + (v155 - v162) / 4294967296;
                end;
                v155 = v141[1] + v162;
                v156 = v155 % 4294967296;
                local l_v156_0 = v156;
                v142[1] = ((v142[1] + v171) + (v155 - v156) / 4294967296) % 4294967296;
                v141[1] = l_v156_0;
                v155 = v141[2] + v163;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[2] = ((v142[2] + v172) + (v155 - v156) / 4294967296) % 4294967296;
                v141[2] = l_v156_0;
                v155 = v141[3] + v164;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[3] = ((v142[3] + v173) + (v155 - v156) / 4294967296) % 4294967296;
                v141[3] = l_v156_0;
                v155 = v141[4] + v165;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[4] = ((v142[4] + v174) + (v155 - v156) / 4294967296) % 4294967296;
                v141[4] = l_v156_0;
                v155 = v141[5] + v166;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[5] = ((v142[5] + v175) + (v155 - v156) / 4294967296) % 4294967296;
                v141[5] = l_v156_0;
                v155 = v141[6] + v167;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[6] = ((v142[6] + v176) + (v155 - v156) / 4294967296) % 4294967296;
                v141[6] = l_v156_0;
                v155 = v141[7] + v168;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[7] = ((v142[7] + v177) + (v155 - v156) / 4294967296) % 4294967296;
                v141[7] = l_v156_0;
                v155 = v141[8] + v169;
                v156 = v155 % 4294967296;
                l_v156_0 = v156;
                v142[8] = ((v142[8] + v178) + (v155 - v156) / 4294967296) % 4294967296;
                v141[8] = l_v156_0;
            end;
        end;
        local function v196(v184, v185, v186, v187)
            local v188 = {};
            local v189 = 0;
            local v190 = 0;
            local v191 = 1;
            for v192 = 1, v187 do
                local v193 = 0;
                for v194 = l_max_1(1, (v192 + 1) - #v185), l_min_1(v192, #v184) do
                    v193 = v193 + v184[v194] * v185[(v192 + 1) - v194];
                end;
                v189 = v189 + v193 * v186;
                local v195 = v189 % 16777216;
                v188[v192] = v195;
                v189 = l_floor_1(v189 / 16777216);
                v190 = v190 + v195 * v191;
                v191 = v191 * 16777216;
            end;
            return v188, v190;
        end;
        local v197 = 0;
        local v198 = {
            [1] = 4, 
            [2] = 1, 
            [3] = 2, 
            [4] = -2, 
            [5] = 2
        };
        local v199 = 4;
        local v200 = {
            [1] = 1
        };
        local l_v107_0 = v107;
        local l_v106_0 = v106;
        local v203 = 0;
        while true do
            v199 = v199 + v198[v199 % 6];
            local v204 = 1;
            while true do
                v204 = v204 + v198[v204 % 6];
                if v199 < v204 * v204 then
                    v197 = v197 + 1;
                    local v205 = v199 ^ 0.3333333333333333;
                    local v206 = v196({
                        l_floor_1(v205 * 1099511627776)
                    }, v200, 1, 2);
                    local v207, v208 = v196(v206, v196(v206, v206, 1, 4), -1, 4);
                    local v209 = (v206[2] % 65536) * 65536 + l_floor_1(v206[1] / 256);
                    local v210 = (v206[1] % 256) * 16777216 + l_floor_1((((v208 * 1.3877787807814457E-17) / 3) * v205) / v199);
                    local l_v209_0 = v209;
                    v104[v197] = v210;
                    v105[v197] = l_v209_0;
                    if v197 < 17 then
                        v205 = v199 ^ 0.5;
                        v206 = v196({
                            l_floor_1(v205 * 1099511627776)
                        }, v200, 1, 2);
                        local v212;
                        l_v209_0, v212 = v196(v206, v206, -1, 2);
                        v208 = v212;
                        v207 = l_v209_0;
                        v209 = (v206[2] % 65536) * 65536 + l_floor_1(v206[1] / 256);
                        v210 = (v206[1] % 256) * 16777216 + l_floor_1((v208 * 7.62939453125E-6) / v205);
                        v108[224][v197 + v203] = v210;
                        l_v209_0 = v197 + v203;
                        v212 = v197 + v203;
                        local l_v209_1 = v209;
                        l_v106_0[v212] = v210;
                        l_v107_0[l_v209_0] = l_v209_1;
                        if v197 == 8 then
                            l_v209_0 = v110[384];
                            v212 = v109[384];
                            v203 = -8;
                            l_v106_0 = v212;
                            l_v107_0 = l_v209_0;
                            break;
                        else
                            break;
                        end;
                    else
                        break;
                    end;
                elseif v199 % v204 == 0 then
                    break;
                end;
            end;
            if v197 > 79 then
                break;
            end;
        end;
        for v214 = 224, 256, 32 do
            v200 = {};
            l_v107_0 = {};
            for v215 = 1, 8 do
                v200[v215] = v63(v106[v215], 2779096485);
                l_v107_0[v215] = v63(v107[v215], 2779096485);
            end;
            v183(v200, l_v107_0, v104, v105, "SHA-512/" .. tonumber(v214) .. "\128" .. l_rep_0("\000", 115) .. "X", v111, 0, 128);
            v109[v214] = v200;
            v110[v214] = l_v107_0;
        end;
        v196 = function(v216, v217)
            local v218 = {
                v50(v108[v216])
            };
            local v219 = 0;
            local v220 = "";
            local function v221(v222)
                if v222 then
                    if v220 then
                        v219 = v219 + #v222;
                        local v223 = 0;
                        if v220 ~= "" and #v220 + #v222 >= 64 then
                            v223 = 64 - #v220;
                            v140(v218, v105, v220 .. l_sub_1(v222, 1, v223), v111, 0, 64);
                            v220 = "";
                        end;
                        local v224 = #v222 - v223;
                        local v225 = v224 % 64;
                        v140(v218, v105, v222, v111, v223, v224 - v225);
                        v220 = v220 .. l_sub_1(v222, (#v222 + 1) - v225);
                        return v221;
                    else
                        error("Adding more chunks is not allowed after asking for final result", 2);
                        return ;
                    end;
                else
                    if v220 then
                        local v226 = {
                            nil, 
                            "\128", 
                            [1] = v220, 
                            l_rep_0("\000", (-9 - v219) % 64 + 1)
                        };
                        v220 = nil;
                        v219 = (v219 * 8) / 72057594037927936;
                        for v227 = 4, 10 do
                            v219 = (v219 % 1) * 256;
                            v226[v227] = l_char_1(l_floor_1(v219));
                        end;
                        v226 = l_concat_0(v226);
                        v140(v218, v105, v226, v111, 0, #v226);
                        local v228 = v216 / 32;
                        for v229 = 1, v228 do
                            v218[v229] = v68(v218[v229]);
                        end;
                        v218 = l_concat_0(v218, "", 1, v228);
                    end;
                    return v218;
                end;
            end;
            if v217 then
                return v221(v217)();
            else
                return v221;
            end;
        end;
        v197 = function(v230, v231)
            local v232 = 0;
            local v233 = "";
            local v234 = {
                v50(v109[v230])
            };
            local v235 = {
                v50(v110[v230])
            };
            local function v236(v237)
                if v237 then
                    if v233 then
                        v232 = v232 + #v237;
                        local v238 = 0;
                        if v233 ~= "" and #v233 + #v237 >= 128 then
                            v238 = 128 - #v233;
                            v183(v234, v235, v104, v105, v233 .. l_sub_1(v237, 1, v238), v111, 0, 128);
                            v233 = "";
                        end;
                        local v239 = #v237 - v238;
                        local v240 = v239 % 128;
                        v183(v234, v235, v104, v105, v237, v111, v238, v239 - v240);
                        v233 = v233 .. l_sub_1(v237, (#v237 + 1) - v240);
                        return v236;
                    else
                        error("Adding more chunks is not allowed after asking for final result", 2);
                        return ;
                    end;
                else
                    if v233 then
                        local v241 = {
                            nil, 
                            "\128", 
                            [1] = v233, 
                            l_rep_0("\000", (-17 - v232) % 128 + 9)
                        };
                        v233 = nil;
                        v232 = (v232 * 8) / 72057594037927936;
                        for v242 = 4, 10 do
                            v232 = (v232 % 1) * 256;
                            v241[v242] = l_char_1(l_floor_1(v232));
                        end;
                        v241 = l_concat_0(v241);
                        v183(v234, v235, v104, v105, v241, v111, 0, #v241);
                        local v243 = l_ceil_1(v230 / 64);
                        for v244 = 1, v243 do
                            v234[v244] = v68(v235[v244]) .. v68(v234[v244]);
                        end;
                        v235 = nil;
                        v234 = l_concat_0(v234, "", 1, v243):sub(1, v230 / 4);
                    end;
                    return v234;
                end;
            end;
            if v231 then
                return v236(v231)();
            else
                return v236;
            end;
        end;
        return {
            sha224 = function(v245)
                return v196(224, v245);
            end, 
            sha256 = function(v246)
                return v196(256, v246);
            end, 
            sha384 = function(v247)
                return v197(384, v247);
            end, 
            sha512 = function(v248)
                return v197(512, v248);
            end, 
            sha512_224 = function(v249)
                return v197(224, v249);
            end, 
            sha512_256 = function(v250)
                return v197(256, v250);
            end
        };
    end)();
    local v252 = l_load_0("Shell32");
    local l_base64_0 = require("neverlose/base64");
    local l_clipboard_0 = require("neverlose/clipboard");
    local l_memory_0 = require("neverlose/memory");
    local _ = require("neverlose/inspect");
    local _ = require("neverlose/easing");
    local _ = (function()
        return {
            data = {}, 
            clamp = function(_, v259, v260, v261)
                return l_min_0(v261, l_max_0(v260, v259));
            end, 
            animate = function(v262, v263, v264, v265)
                if not v262.data[v263] then
                    v262.data[v263] = 0;
                end;
                if not v265 then
                    v265 = 4;
                end;
                v262.data[v263] = v262:clamp(v262.data[v263] + (globals.frametime * v265) * (v264 and -1 or 1), 0, 1);
                return v262.data[v263];
            end
        };
    end)();
    local v278 = (function()
        return {
            data = {}, 
            new_frame = function(v267, v268)
                for _, v270 in pairs(v267.data) do
                    if v270.speed <= v268 - v270.last_tick then
                        v270.flicked = not v270.flicked;
                        v270.last_tick = v268;
                    end;
                end;
            end, 
            flick = function(v271, v272, v273, v274, v275)
                local v276 = math.min(v273, v274);
                local v277 = math.max(v273, v274);
                if not v271.data[v272] then
                    v271.data[v272] = {
                        flicked = false, 
                        last_tick = 0, 
                        speed = v275
                    };
                end;
                if v271.data[v272].speed ~= v275 then
                    v271.data[v272].speed = v275;
                end;
                return v271.data[v272].flicked and v277 or v276;
            end
        };
    end)();
    local v294 = (function()
        return {
            data = {}, 
            new_frame = function(v279, v280)
                for _, v282 in pairs(v279.data) do
                    if v282.speed <= v280 - v282.last_tick then
                        for _ = 1, v282.times do
                            if v282.forward then
                                if v282.value < v282.max then
                                    v282.value = v282.value + 1;
                                else
                                    v282.forward = false;
                                end;
                            elseif v282.min < v282.value then
                                v282.value = v282.value - 1;
                            else
                                v282.forward = true;
                            end;
                        end;
                        v282.last_tick = v280;
                    end;
                end;
            end, 
            sway = function(v284, v285, v286, v287, v288, v289)
                local v290 = math.min(v286, v287);
                local v291 = math.max(v286, v287);
                local v292 = v289 or 1;
                if not v284.data[v285] then
                    v284.data[v285] = {
                        forward = true, 
                        last_tick = 0, 
                        value = v290, 
                        min = v290, 
                        max = v291, 
                        speed = v288, 
                        times = v292
                    };
                end;
                local v293 = v284.data[v285];
                if not (v293.min == v290) or v293.max ~= v291 then
                    v284.data[v285] = {
                        forward = true, 
                        last_tick = 0, 
                        value = v290, 
                        min = v290, 
                        max = v291, 
                        speed = v288, 
                        times = v292
                    };
                end;
                if v284.data[v285].speed ~= v288 then
                    v284.data[v285].speed = v288;
                end;
                if v284.data[v285].times ~= v292 then
                    v284.data[v285].times = v292;
                end;
                return v284.data[v285].value;
            end
        };
    end)();
    local _ = (function()
        local v295 = 4294967296;
        local v296 = v295 - 1;
        local function v303(v297)
            local v298 = {};
            local v299 = setmetatable({}, v298);
            v298.__index = function(_, v301)
                local v302 = v297(v301);
                v299[v301] = v302;
                return v302;
            end;
            return v299;
        end;
        local function v312(v304, v305)
            return function(v306, v307)
                local v308 = 0;
                local v309 = 1;
                while v306 ~= 0 and v307 ~= 0 do
                    local v310 = v306 % v305;
                    local v311 = v307 % v305;
                    v308 = v308 + v304[v310][v311] * v309;
                    v306 = (v306 - v310) / v305;
                    v307 = (v307 - v311) / v305;
                    v309 = v309 * v305;
                end;
                return v308 + (v306 + v307) * v309;
            end;
        end;
        local v317 = (function(v313)
            local v314 = v312(v313, 2);
            return v312(v303(function(v315)
                return v303(function(v316)
                    return v314(v315, v316);
                end);
            end), 2 ^ (v313.n or 1));
        end)({
            n = 4, 
            [0] = {
                [0] = 0, 
                [1] = 1
            }, 
            [1] = {
                [0] = 1, 
                [1] = 0
            }
        });
        local function v318(v319, v320, v321, ...)
            local v322 = nil;
            if v320 then
                v322 = v317(v319 % v295, v320 % v295);
                if v321 then
                    v322 = v318(v322, v321, ...);
                end;
                return v322;
            elseif v319 then
                return v319 % v295;
            else
                return 0;
            end;
        end;
        local function v327(v323, v324, v325, ...)
            local v326 = nil;
            if v324 then
                v323 = v323 % v295;
                v324 = v324 % v295;
                v326 = ((v323 + v324) - v317(v323, v324)) / 2;
                if v325 then
                    v326 = bit32_band(v326, v325, ...);
                end;
                return v326;
            elseif v323 then
                return v323 % v295;
            else
                return v296;
            end;
        end;
        local function v329(v328)
            return (-1 - v328) % v295;
        end;
        local function v332(v330, v331)
            if v331 < 0 then
                return lshift(v330, -v331);
            else
                return l_floor_0((v330 % 4294967296) / 2 ^ v331);
            end;
        end;
        local function v335(v333, v334)
            if not (v334 <= 31) or v334 < -31 then
                return 0;
            else
                return v332(v333 % v295, v334);
            end;
        end;
        local function v338(v336, v337)
            if v337 < 0 then
                return v335(v336, -v337);
            else
                return (v336 * 2 ^ v337) % 4294967296;
            end;
        end;
        local function v341(v339, v340)
            v339 = v339 % v295;
            v340 = v340 % 32;
            return v335(v339, v340) + v338(v327(v339, 2 ^ v340 - 1), 32 - v340);
        end;
        local v342 = {
            [1] = 1116352408, 
            [2] = 1899447441, 
            [3] = 3049323471, 
            [4] = 3921009573, 
            [5] = 961987163, 
            [6] = 1508970993, 
            [7] = 2453635748, 
            [8] = 2870763221, 
            [9] = 3624381080, 
            [10] = 310598401, 
            [11] = 607225278, 
            [12] = 1426881987, 
            [13] = 1925078388, 
            [14] = 2162078206, 
            [15] = 2614888103, 
            [16] = 3248222580, 
            [17] = 3835390401, 
            [18] = 4022224774, 
            [19] = 264347078, 
            [20] = 604807628, 
            [21] = 770255983, 
            [22] = 1249150122, 
            [23] = 1555081692, 
            [24] = 1996064986, 
            [25] = 2554220882, 
            [26] = 2821834349, 
            [27] = 2952996808, 
            [28] = 3210313671, 
            [29] = 3336571891, 
            [30] = 3584528711, 
            [31] = 113926993, 
            [32] = 338241895, 
            [33] = 666307205, 
            [34] = 773529912, 
            [35] = 1294757372, 
            [36] = 1396182291, 
            [37] = 1695183700, 
            [38] = 1986661051, 
            [39] = 2177026350, 
            [40] = 2456956037, 
            [41] = 2730485921, 
            [42] = 2820302411, 
            [43] = 3259730800, 
            [44] = 3345764771, 
            [45] = 3516065817, 
            [46] = 3600352804, 
            [47] = 4094571909, 
            [48] = 275423344, 
            [49] = 430227734, 
            [50] = 506948616, 
            [51] = 659060556, 
            [52] = 883997877, 
            [53] = 958139571, 
            [54] = 1322822218, 
            [55] = 1537002063, 
            [56] = 1747873779, 
            [57] = 1955562222, 
            [58] = 2024104815, 
            [59] = 2227730452, 
            [60] = 2361852424, 
            [61] = 2428436474, 
            [62] = 2756734187, 
            [63] = 3204031479, 
            [64] = 3329325298
        };
        local function v345(v343)
            return string.gsub(v343, ".", function(v344)
                return l_format_0("%02x", string.byte(v344));
            end);
        end;
        local function v351(v346, v347)
            local v348 = "";
            for _ = 1, v347 do
                local v350 = v346 % 256;
                v348 = l_char_0(v350) .. v348;
                v346 = (v346 - v350) / 256;
            end;
            return v348;
        end;
        local function v356(v352, v353)
            local v354 = 0;
            for v355 = v353, v353 + 3 do
                v354 = v354 * 256 + string.byte(v352, v355);
            end;
            return v354;
        end;
        local function v359(v357, v358)
            v357 = v357 .. "\128" .. string.rep("\000", 64 - (v358 + 9) % 64) .. v351(8 * v358, 8);
            assert(#v357 % 64 == 0);
            return v357;
        end;
        local function v361(v360)
            v360[1] = 1779033703;
            v360[2] = 3144134277;
            v360[3] = 1013904242;
            v360[4] = 2773480762;
            v360[5] = 1359893119;
            v360[6] = 2600822924;
            v360[7] = 528734635;
            v360[8] = 1541459225;
            return v360;
        end;
        local function v388(v362, v363, v364)
            local v365 = {};
            for v366 = 1, 16 do
                v365[v366] = v356(v362, v363 + (v366 - 1) * 4);
            end;
            for v367 = 17, 64 do
                local v368 = v365[v367 - 15];
                local v369 = v318(v341(v368, 7), v341(v368, 18), v335(v368, 3));
                v368 = v365[v367 - 2];
                v365[v367] = ((v365[v367 - 16] + v369) + v365[v367 - 7]) + v318(v341(v368, 17), v341(v368, 19), v335(v368, 10));
            end;
            local v370 = v364[1];
            local v371 = v364[2];
            local v372 = v364[3];
            local v373 = v364[4];
            local v374 = v364[5];
            local v375 = v364[6];
            local v376 = v364[7];
            local v377 = v364[8];
            for v378 = 1, 64 do
                local v379 = v318(v341(v370, 2), v341(v370, 13), v341(v370, 22)) + v318(v327(v370, v371), v327(v370, v372), v327(v371, v372));
                local v380 = (((v377 + v318(v341(v374, 6), v341(v374, 11), v341(v374, 25))) + v318(v327(v374, v375), v327(v329(v374), v376))) + v342[v378]) + v365[v378];
                local l_v376_0 = v376;
                local l_v375_0 = v375;
                local l_v374_0 = v374;
                local v384 = v373 + v380;
                local l_v372_0 = v372;
                local l_v371_0 = v371;
                local l_v370_0 = v370;
                v370 = v380 + v379;
                v371 = l_v370_0;
                v372 = l_v371_0;
                v373 = l_v372_0;
                v374 = v384;
                v375 = l_v374_0;
                v376 = l_v375_0;
                v377 = l_v376_0;
            end;
            v364[1] = v327(v364[1] + v370);
            v364[2] = v327(v364[2] + v371);
            v364[3] = v327(v364[3] + v372);
            v364[4] = v327(v364[4] + v373);
            v364[5] = v327(v364[5] + v374);
            v364[6] = v327(v364[6] + v375);
            v364[7] = v327(v364[7] + v376);
            v364[8] = v327(v364[8] + v377);
        end;
        return function(v389)
            v389 = v359(v389, #v389);
            local v390 = v361({});
            for v391 = 1, #v389, 64 do
                v388(v389, v391, v390);
            end;
            return v345(v351(v390[1], 4) .. v351(v390[2], 4) .. v351(v390[3], 4) .. v351(v390[4], 4) .. v351(v390[5], 4) .. v351(v390[6], 4) .. v351(v390[7], 4) .. v351(v390[8], 4));
        end;
    end)();
    local v393 = {};
    local v394 = {};
    local v395 = {};
    local v396 = {};
    local v397 = {};
    local v398 = {};
    local v399 = {};
    local v400 = {};
    local v401 = {};
    local v402 = {};
    local v403 = {};
    local v404 = {};
    local v405 = {};
    local v406 = {};
    local v407 = {};
    local v408 = {};
    local v409 = {};
    local v410 = {};
    local v411 = {};
    local v412 = {};
    local v413 = {};
    local v414 = {};
    local v415 = {};
    local v416 = {};
    local v417 = {};
    local v418 = {};
    local v419 = {};
    local v420 = {};
    local v421 = {};
    local v422 = {};
    local v423 = {};
    local v424 = {};
    local v425 = {};
    local v426 = {};
    local v427 = {};
    local v428 = {};
    local v429 = {};
    local v430 = {};
    local v431 = {};
    local v432 = {};
    local v433 = {};
    local v434 = {};
    ffi.cdef("        typedef void* HWND;\n        typedef const char* LPCSTR;\n\n        bool FlashWindow(HWND HWND, bool bInvert);\n        HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);\n        HWND GetActiveWindow();\n        HWND GetForegroundWindow();\n\n        HWND ShellExecuteA(HWND HWND, LPCSTR op, LPCSTR file, LPCSTR params, LPCSTR dir, int show_cmd);\n\n        typedef struct {\n            char  pad_0000[20];\n            int m_nOrder; //0x0014\n            int m_nSequence; //0x0018\n            float m_flPrevCycle; //0x001C\n            float m_flWeight; //0x0020\n            float m_flWeightDeltaRate; //0x0024\n            float m_flPlaybackRate; //0x0028\n            float m_flCycle; //0x002C\n            void *m_pOwner; //0x0030\n            char  pad_0038[4]; //0x0034\n        } CAnimationLayer;\n    ");
    local function v435(...)
        l_print_raw_0(l_format_0(...));
    end;
    local function v436(...)
        error(l_format_0(...), 3);
    end;
    local function v438(v437)
        return l_floor_0(v437);
    end;
    local function v440(v439)
        return v438(v439 + 0.5);
    end;
    local function v444(v441, v442, v443)
        return l_max_0(v442, l_min_0(v441, v443));
    end;
    local function v448(v445, v446)
        for v447 = 1, #v445 do
            if v445[v447] == v446 then
                return true;
            end;
        end;
        return false;
    end;
    local function v452(v449, v450, v451)
        return v449 + (v450 - v449) * v451;
    end;
    local function _(v453)
        return math.floor(v453 / globals.tickinterval + 0.5);
    end;
    local function v457(v455)
        local v456 = v455 % 10;
        if v456 == 1 and v456 ~= 11 then
            return "st";
        elseif v456 == 2 and v456 ~= 12 then
            return "nd";
        elseif v456 == 3 and v456 ~= 13 then
            return "rd";
        else
            return "th";
        end;
    end;
    local function v463(...)
        local v458 = {
            ...
        };
        local l_realtime_0 = globals.realtime;
        if type(v458[1]) == "function" then
            local v460 = v458[1](select(2, ...));
            if v460 ~= nil then
                l_realtime_0 = v460;
            end;
        else
            local v461, v462 = unpack(v458);
            if v462 ~= nil then
                l_realtime_0 = l_realtime_0 * v462;
            end;
            if v461 ~= nil then
                l_realtime_0 = l_realtime_0 + v461;
            end;
        end;
        return l_abs_0((l_sin_0(l_realtime_0)));
    end;
    local function v467(v464)
        local v465 = "";
        for v466 = 1, #v464 do
            v465 = l_format_0("%s\\x%02x", v465, (l_byte_0((l_sub_0(v464, v466, v466)))));
        end;
        return v465;
    end;
    local function v468()
        return l_get_alpha_0() > 0;
    end;
    local function v470(v469)
        return v469.m_bIsScoped;
    end;
    local function v477(v471)
        local v472 = "";
        local v473 = {};
        for v474 in pairs(v471) do
            l_insert_0(v473, v474);
        end;
        table.sort(v473);
        for v475 = 1, #v473 do
            local v476 = v473[v475];
            v472 = v472 .. v476 .. tostring(v471[v476]);
        end;
        return v472;
    end;
    local function v480(v478, v479)
        return v251.sha256(v477(v478) .. v479);
    end;
    v393.csgo = l_C_0.GetActiveWindow();
    v393.user = l_get_username_0();
    v393.label = "xo-yaw";
    v393.build = "beta";
    v393.update_time = "04.04.23";
    v393.scr = l_screen_size_0();
    v393.scr.x = v393.scr.x == 0 and 1920 or v393.scr.x;
    v393.scr.y = v393.scr.y == 0 and 1080 or v393.scr.y;
    v393.center = v393.scr * 0.5;
    v393.offset = v393.scr.y / 1080;
    v394.len = function(v481)
        return #v481:gsub("[\128-\191]", "");
    end;
    v395.ragebot = {
        main = {
            double_tap = l_find_0("Aimbot", "Ragebot", "Main", "Double Tap"), 
            lag_options = l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
            hide_shots = l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots"), 
            options = l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
            dormant_aimbot = l_find_0("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")
        }, 
        safety = {
            body_aim = l_find_0("Aimbot", "Ragebot", "Safety", "Body Aim"), 
            safe_points = l_find_0("Aimbot", "Ragebot", "Safety", "Safe Points")
        }, 
        selection = {
            hitboxes = l_find_0("Aimbot", "Ragebot", "Selection", "Hitboxes"), 
            minimum_damage = l_find_0("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
            hitchance = l_find_0("Aimbot", "Ragebot", "Selection", "Hit Chance")
        }
    };
    v395.antiaim = {
        misc = {
            fake_duck = l_find_0("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = l_find_0("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            leg_movement = l_find_0("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }, 
        fakelag = {
            enabled = l_find_0("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
            limit = l_find_0("Aimbot", "Anti Aim", "Fake Lag", "Limit")
        }, 
        angles = {
            enabled = l_find_0("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            hidden = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
            pitch = l_find_0("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw"), 
            yaw_base = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
            yaw_offset = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
            avoid_backstab = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
            yaw_modifier = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
            modifier_offset = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
            body_yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
            inverter = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
            left_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
            right_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
            options = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
            freestanding_desync = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
            freestanding = l_find_0("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
            extended_angles = l_find_0("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
            extended_pitch = l_find_0("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
            extended_roll = l_find_0("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
        }
    };
    v395.visuals = {
        main = {
            scope_overlay = l_find_0("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
        }
    };
    v395.misc = {
        main = {
            clan_tag = l_find_0("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
            log_events = l_find_0("Miscellaneous", "Main", "Other", "Log Events"), 
            fake_latency = l_find_0("Miscellaneous", "Main", "Other", "Fake Latency")
        }
    };
    v396.offsets = {
        m_pStudioHdr = 10576
    };
    v396.get_override = function(v482)
        return ({
            [v395.antiaim.angles.yaw_offset:id()] = math.random(-50, 44), 
            [v395.antiaim.angles.avoid_backstab:id()] = "Ben: Yes", 
            [v395.antiaim.angles.yaw_modifier:id()] = "\208\166\208\181\208\189\209\130\209\128\208\176\208\187\209\140\208\189\209\139\208\185", 
            [v395.antiaim.angles.body_yaw:id()] = "way_ydob", 
            [v395.antiaim.angles.inverter:id()] = "\208\159\208\181\209\128\208\181\208\178\208\181\209\128\208\189\209\131\209\130"
        })[v482:id()] or "\208\151\208\144\208\169\208\152\208\169\208\149\208\157\208\158 \208\156\208\146\208\148 RUSSIA @ 2023";
    end;
    v397.column = {
        RIGHT = 2, 
        LEFT = 1
    };
    v398["door-open"] = "\239\148\171";
    v398["check-square"] = "\239\133\138";
    v398["angle-right"] = "\239\132\133";
    v398.spider = "\239\156\151";
    v398["user-plus"] = "\239\136\180";
    v398["clipboard-check"] = "\239\145\172";
    v398["sign-in-alt"] = "\239\139\182";
    v398["sign-out-alt"] = "\239\139\181";
    v398["sd-card"] = "\239\159\130";
    v398.cog = "\239\128\147";
    v398["info-circle"] = "\239\129\154";
    v398["shield-alt"] = "\239\143\173";
    v398.redo = "\239\128\158";
    v398.plus = "\239\129\167";
    v398.minus = "\239\129\168";
    v398["exclamation-triangle"] = "\239\129\177";
    v398.crosshairs = "\239\129\155";
    v398.wrench = "\239\130\173";
    v398.shapes = "\239\152\159";
    v398.map = "\239\137\185";
    v398.video = "\239\128\189";
    v398.seedling = "\239\147\152";
    v398["user-shield"] = "\239\148\133";
    v398["house-user"] = "\238\129\165";
    setmetatable(v398, {
        __index = function(v483, v484)
            local v485 = rawget(v483, v484);
            if v485 ~= nil then
                return v485;
            else
                local v486 = l_get_icon_0(v484);
                if v486 == nil then
                    v435("Icon not found: %s", v484);
                    return ;
                else
                    rawset(v483, v484, v486);
                    v435("ico[ '%s' ] = '%s';", v484, v467(v486));
                    return v486;
                end;
            end;
        end
    });
    v399.red = color(255, 0, 0);
    v399.blue = color(0, 150, 220);
    v399.pink = color(220, 128, 220);
    v399.aqua = color("00a4ef");
    v399.white = color();
    v399.black = color(17);
    v399.skeet = color("F50303FF");
    v400.list = {};
    v400.lerp = function(_, v488, v489, v490, v491)
        if v488 == nil then
            return v489;
        else
            if type(v490) == "boolean" then
                v490 = nil;
                v491 = true;
            end;
            local v492 = (not v490 and 0.095 or v490) * (globals.frametime * 175);
            if type(v489) ~= "number" then
                if v488 == nil then
                    v488 = v489:clone();
                end;
                return v488.lerp(v488, v489, v490);
            elseif v488 == v489 then
                return v488;
            elseif l_abs_0(v489 - v488) <= 0.095 and not v491 then
                return v489;
            else
                return v452(v488, v489, v492);
            end;
        end;
    end;
    v400.new = function(v493, v494, v495, v496, v497)
        if v493.list[v494] == nil then
            v493.list[v494] = {
                __value = v496 or 0
            };
        end;
        local v498 = v493.list[v494];
        v498.__value = v493:lerp(v498.__value, v495, v497);
        v498.__frame = true;
        return v498.__value;
    end;
    v400.update = function(v499)
        for _, v501 in pairs(v499.list) do
            if v501.__frame then
                v501.__frame = false;
            else
                v501.__value = v499:lerp(v501.__value, 0);
            end;
        end;
    end;
    setmetatable(v400, {
        __index = function(v502, v503)
            local v504 = v502.list[v503];
            if v504 == nil then
                return rawget(v502, v503);
            else
                return v504.__value;
            end;
        end
    });
    local v505 = {};
    local v506 = {};
    do
        local l_v505_0, l_v506_0 = v505, v506;
        v401.refresh = function(_)
            for v510 = 1, #l_v505_0 do
                local v511 = l_v505_0[v510];
                local l_reference_0 = v511.reference;
                local v513 = v511:callback();
                if not (type(v513) ~= "string") then
                    l_reference_0:name(v513);
                end;
            end;
        end;
        v401.listen = function(_, v515)
            if type(v515) ~= "string" then
                return false;
            else
                local v516 = l_get_style_0(v515);
                if v516 == l_v506_0[v515] then
                    return false;
                else
                    l_v506_0[v515] = v516;
                    return true;
                end;
            end;
        end;
        v401.attach = function(v517, v518, v519)
            l_insert_0(l_v505_0, {
                name = v518:name(), 
                reference = v518, 
                callback = v519
            });
            v517:refresh();
        end;
        v401.sidebar = function(v520)
            local v521 = l_format_0("%s.lua", v393.label);
            local v522 = v520["Link Active"];
            local v523 = v520["Sidebar Text"];
            l_sidebar_0(v402:wave(v521, v522, v523), v402:solid(v398.seedling, v522:lerp(v523, v463())));
        end;
        v401.paint = function(v524)
            if not v468() then
                return ;
            else
                v524:sidebar();
                local v525 = false;
                for v526 in pairs(l_v506_0) do
                    if v524:listen(v526) then
                        v525 = true;
                    end;
                end;
                if not v525 then
                    return ;
                else
                    v524:refresh();
                    return ;
                end;
            end;
        end;
        v401:listen("Link Active");
        v401:listen("Sidebar Text");
        setmetatable(v401, {
            __index = function(v527, v528)
                return rawget(l_v506_0, v528) or rawget(v527, v528);
            end
        });
    end;
    v402.solid = function(_, v530, v531)
        return l_format_0("\a%s%s", v531:to_hex(), v530);
    end;
    v402.gradient = function(v532, v533, v534, v535)
        local v536 = 0;
        local v537 = 1 / (v394.len(v533) - 1);
        return (v533:gsub("(.[\128-\191]*)", function(v538)
            local v539 = v534:lerp(v535, v536);
            v536 = v536 + v537;
            return v532:solid(v538, v539);
        end));
    end;
    v402.wave = function(v540, v541, v542, v543, v544)
        local v545 = 0;
        local v546 = 1 / (v394.len(v541) - 1);
        return (v541:gsub("(.[\128-\191]*)", function(v547)
            local v548 = v542:lerp(v543, (v463(v545, v544)));
            v545 = v545 + v546;
            return v540:solid(v547, v548);
        end));
    end;
    v505 = {};
    v506 = {};
    local function v551(v549, v550)
        if v550 == nil then
            v550 = v549;
        end;
        if type(v550) ~= "function" then
            return function(...)
                return v550:get();
            end;
        else
            return v550;
        end;
    end;
    do
        local l_v505_1, l_v506_1, l_v551_0 = v505, v506, v551;
        local function v559(v555, v556)
            local v557 = rawget(l_v505_1, v556) or rawget(v555, v556);
            if v557 ~= nil then
                return v557;
            else
                local v558 = rawget(v555, "ref");
                v557 = v558[v556];
                if type(v557) == "function" then
                    return function(...)
                        if ... == v555 then
                            return v557(v558, select(2, ...));
                        else
                            return v557(...);
                        end;
                    end;
                else
                    return v557;
                end;
            end;
        end;
        v403.items = {};
        v403.refresh = function(v560)
            local v561 = #l_v506_1;
            for _, v563 in pairs(v560.items) do
                for _, v565 in pairs(v563) do
                    local l_ref_0 = v565.ref;
                    local l_depends_0 = v565.depends;
                    for v568 = 1, #l_depends_0 do
                        if l_depends_0[v568]() == false then
                            l_ref_0:visibility(false);
                            goto label0 --[[  false, false  ]];
                        end;
                    end;
                    for v569 = 1, v561 do
                        local v570 = l_v506_1[v569];
                        local l_invoker_0 = v570.invoker;
                        if l_invoker_0 == v565 then
                            l_ref_0:visibility(true);
                            goto label0 --[[  false, false  ]];
                        elseif v570.callback(l_invoker_0, v565) == false then
                            l_ref_0:visibility(false);
                            goto label0 --[[  false, false  ]];
                        end;
                    end;
                    l_ref_0:visibility(true);
                    ::label0::;
                end;
            end;
        end;
        v403.new = function(v572, v573, v574, v575)
            if v572.items[v573] == nil then
                v572.items[v573] = {};
            end;
            if v572.items[v573][v574] ~= nil then
                v436("Already exist repository: %s / %s", v573, v574);
                return ;
            else
                local v576 = {
                    depends = {}, 
                    branch = v573, 
                    name = v574, 
                    ref = v575
                };
                v572.items[v573][v574] = v576;
                setmetatable(v576, {
                    __index = v559
                });
                v575:set_callback(function()
                    v572:refresh();
                end);
                return v576;
            end;
        end;
        l_v505_1.depend = function(v577, v578, ...)
            local v579 = {
                ...
            };
            l_insert_0(v579, v578 or v577);
            for v580 = 1, #v579 do
                l_insert_0(v577.depends, (l_v551_0(v577, v579[v580])));
            end;
            return v577;
        end;
        l_v505_1.dependency = function(v581, v582, ...)
            local v583 = {
                ...
            };
            l_insert_0(v583, v582 or v581);
            for v584 = 1, #v583 do
                l_insert_0(l_v506_1, {
                    invoker = v581, 
                    callback = l_v551_0(v581, v583[v584])
                });
            end;
        end;
        setmetatable(v403, {
            __call = v403.new
        });
    end;
    v505 = nil;
    v404.save = function(_)
        local v586 = {};
        for v587, v588 in pairs(v403.items) do
            v586[v587] = {};
            for v589, v590 in pairs(v588) do
                local v591 = {
                    pcall(v590.get, v590)
                };
                if v591[1] then
                    l_remove_0(v591, 1);
                    local v592 = {
                        val = v591
                    };
                    if type(v591[1]) == "userdata" then
                        v592 = {
                            color = v591[1]:to_hex()
                        };
                    end;
                    v586[v587][v589] = v592;
                end;
            end;
        end;
        return l_base64_0.encode((json.stringify(v586))) .. "_xoyaw";
    end;
    v404.load = function(_, v594)
        local v595, _ = v594:find("_xoyaw");
        if v595 then
            v594 = v594:sub(1, v595 - 1);
        end;
        local l_status_0, l_result_0 = pcall(l_base64_0.decode, v594);
        if not l_status_0 then
            return ;
        else
            local l_status_1, l_result_1 = pcall(json.parse, l_result_0);
            if not l_status_1 then
                return ;
            else
                for v601, v602 in pairs(l_result_1) do
                    local v603 = v403.items[v601];
                    if not (v603 == nil) then
                        for v604, v605 in pairs(v602) do
                            local v606 = v603[v604];
                            if not (v606 == nil) then
                                if v605.color then
                                    pcall(v606.set, v606, v605.color);
                                elseif v605.val then
                                    pcall(v606.set, v606, unpack(v605.val));
                                end;
                            end;
                        end;
                    end;
                end;
                return true;
            end;
        end;
    end;
    v405.combo_control = function(_, v608, v609)
        if not v609 then
            v609 = {};
        end;
        local v610 = {};
        if #v609 > 0 then
            v608:update(v609);
        end;
        setmetatable(v610, {
            __newindex = function(v611, v612, v613)
                rawset(v611, v612, v613);
                l_insert_0(v609, v612);
                v608:update(v609);
            end
        });
        return v610;
    end;
    v506 = function(v614, v615)
        return function()
            return l_format_0("%s  %s", v402:solid(v614, v401["Link Active"]), v402:solid(v615, v401["Sidebar Text"]));
        end;
    end;
    v405.tabs = {};
    v405.groups = {};
    v405.tabs.hub = l_format_0("%s  Hub", v398["house-user"]);
    v405.tabs.aa = l_format_0("%s  Anti-Aim", v398["user-shield"]);
    v405.tabs.features = l_format_0("%s  Features", v398["angle-right"]);
    v405.groups.hub = {};
    v405.groups.aa = {};
    v405.groups.features = {};
    v405.groups.hub.get_started = l_create_0(v405.tabs.hub, "Get Started", v397.column.LEFT);
    v405.groups.hub.information = l_create_0(v405.tabs.hub, "RECOMMENDATIONS", v397.column.RIGHT);
    v405.groups.hub.settings = l_create_0(v405.tabs.hub, "CONFIGS", v397.column.LEFT);
    v405.groups.aa.main = l_create_0(v405.tabs.aa, "Main", v397.column.LEFT);
    v405.groups.aa.angles = l_create_0(v405.tabs.aa, "Angles", v397.column.RIGHT);
    v405.groups.aa.defensive_angles = l_create_0(v405.tabs.aa, "Defensive Angles", v397.column.RIGHT);
    v405.groups.features.ragebot = l_create_0(v405.tabs.features, "Ragebot", v397.column.LEFT);
    v405.groups.features.misc = l_create_0(v405.tabs.features, "Miscellaneous", v397.column.LEFT);
    v405.groups.features.screen = l_create_0(v405.tabs.features, "Screen", v397.column.RIGHT);
    v405.groups.features.interface = l_create_0(v405.tabs.features, "Interface", v397.column.RIGHT);
    v505 = function(v616, v617)
        return function()
            return l_format_0("%s %s%s", v398["angle-right"], v616, v402:gradient(v617, v401["Link Active"], v401["Sidebar Text"]));
        end;
    end;
    v506 = function(v618, v619, v620)
        local v621 = (" "):rep(v620 or 0);
        return function()
            return l_format_0("%s%s  \aDEFAULT%s%s", v621, v402:solid(v618, v401["Link Active"]), v619, v621);
        end;
    end;
    v406.welcome = v405.groups.hub.get_started:label("\n welcome");
    v406.update_time = v405.groups.hub.get_started:label("\n update_time");
    v406.join_discord_server = v405.groups.hub.information:button("\n join_discord_server", nil, true);
    v406.get_discord_role = v405.groups.hub.information:button("\n get_discord_role", nil, true);
    v406.discord_tutorial = v405.groups.hub.information:button("\n discord_tutorial", nil, true);
    v406.config_demyaha = v405.groups.hub.information:button("\n config_demyaha", nil, true);
    v401:attach(v406.welcome, v505("Welcome Back, ", v393.user));
    v401:attach(v406.update_time, v505("Last Update Time: ", v393.update_time));
    v401:attach(v406.join_discord_server, v506(v398["user-plus"], "Join Discord Server ", 20));
    v401:attach(v406.get_discord_role, v506(v398["clipboard-check"], "Get Discord Role", 24));
    v401:attach(v406.discord_tutorial, v506(v398.video, "Discord Role Tutorial", 19));
    v401:attach(v406.config_demyaha, v506(v398["check-square"], "Neverlose Config ", 23));
    v406.export = v405.groups.hub.settings:button("\n export", nil, true);
    v406.import = v405.groups.hub.settings:button("\n import", nil, true);
    v406.default = v405.groups.hub.settings:button("\n default", nil, true);
    v401:attach(v406.export, v506(v398["sign-out-alt"], "Export", 2));
    v401:attach(v406.import, v506(v398["sign-in-alt"], "Import", 2));
    v401:attach(v406.default, v506(v398["sd-card"], "Default", 2));
    v406.export:set_callback(function()
        local v622 = v404:save();
        if v622 ~= nil then
            l_clipboard_0.set(v622);
            common.add_notify("xo-yaw.lua", "Succesfully exported config");
            utils.console_exec("play ui\\beepclear");
        else
            common.add_notify("xo-yaw.lua", "Failed to export config");
            utils.console_exec("play buttons\\weapon_cant_buy.wav");
        end;
    end);
    v406.import:set_callback(function()
        local v623 = l_clipboard_0.get();
        local v624, _ = v623:find("_xoyaw");
        local v626 = nil;
        if v624 then
            v626 = v404:load(v623:sub(1, v624 - 1));
        else
            v626 = v404:load(v623);
        end;
        if v626 == true then
            common.add_notify("xo-yaw.lua", "Succesfully imported config");
            utils.console_exec("play ui\\beepclear");
        else
            common.add_notify("xo-yaw.lua", "Failed to import config");
            utils.console_exec("play buttons\\weapon_cant_buy.wav");
        end;
    end);
    v406.default:set_callback(function()
        v404:load("eyJBQSI6eyJBbnRpYnJ1dGVbQWlyK10uYk1hc3RlciI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbQWlyK10uYnl2YWkiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0FpcitdLmlDb3VudCI6eyJ2YWwiOlsyLjBdfSwiQW50aWJydXRlW0FpcitdLnNhbGFtIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtBaXIrXS5zelN0YWdlIjp7InZhbCI6WyIyIl19LCJBbnRpYnJ1dGVbQWlyK11bMTBdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bMTBdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzEwXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXIrXVsxXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzFdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzFdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0FpcitdWzJdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bMl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bMl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyK11bM10uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVszXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVszXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXIrXVs0XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzRdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzRdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0FpcitdWzVdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bNV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bNV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyK11bNl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVs2XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVs2XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXIrXVs3XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0FpcitdWzddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0FpcitdWzhdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bOF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyK11bOF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyK11bOV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVs5XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXIrXVs5XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXJdLmJNYXN0ZXIiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0Fpcl0uYnl2YWkiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0Fpcl0uaUNvdW50Ijp7InZhbCI6WzIuMF19LCJBbnRpYnJ1dGVbQWlyXS5zYWxhbSI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbQWlyXS5zelN0YWdlIjp7InZhbCI6WyIyIl19LCJBbnRpYnJ1dGVbQWlyXVsxMF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzEwXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzEwXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXJdWzFdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVsxXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzFdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Fpcl1bMl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzJdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bMl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyXVszXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bM10uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVszXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXJdWzRdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVs0XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzRdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Fpcl1bNV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzVdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bNV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyXVs2XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bNl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVs2XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtBaXJdWzddLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVs3XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Fpcl1bOF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtBaXJdWzhdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bOF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQWlyXVs5XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Fpcl1bOV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQWlyXVs5XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdLmJNYXN0ZXIiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0Nyb3VjaF0uYnl2YWkiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0Nyb3VjaF0uaUNvdW50Ijp7InZhbCI6WzIuMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXS5zYWxhbSI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbQ3JvdWNoXS5zelN0YWdlIjp7InZhbCI6WyIyIl19LCJBbnRpYnJ1dGVbQ3JvdWNoXVsxMF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzEwXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzEwXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzFdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVsxXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzFdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bMl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzJdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bMl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVszXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bM10uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVszXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzRdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs0XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzRdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bNV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzVdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bNV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs2XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bNl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs2XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzddLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs3XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bOF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtDcm91Y2hdWzhdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bOF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs5XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Nyb3VjaF1bOV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbQ3JvdWNoXVs5XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ10uYk1hc3RlciI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbRmFrZSBMYWddLmJ5dmFpIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtGYWtlIExhZ10uaUNvdW50Ijp7InZhbCI6WzIuMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddLnNhbGFtIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtGYWtlIExhZ10uc3pTdGFnZSI6eyJ2YWwiOlsiMiJdfSwiQW50aWJydXRlW0Zha2UgTGFnXVsxMF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bMTBdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVsxMF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzFdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzFdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVsxXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bMl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bMl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzJdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVszXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVszXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bM10uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzRdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzRdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs0XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bNV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bNV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzVdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs2XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs2XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bNl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzddLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs3XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bOF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bOF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbRmFrZSBMYWddWzhdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs5XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0Zha2UgTGFnXVs5XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtGYWtlIExhZ11bOV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbR2xvYmFsXS5iTWFzdGVyIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtHbG9iYWxdLmJ5dmFpIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtHbG9iYWxdLmlDb3VudCI6eyJ2YWwiOlsyLjBdfSwiQW50aWJydXRlW0dsb2JhbF0uc2FsYW0iOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW0dsb2JhbF0uc3pTdGFnZSI6eyJ2YWwiOlsiMiJdfSwiQW50aWJydXRlW0dsb2JhbF1bMTBdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVsxMF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVsxMF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVsxXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bMV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVsxXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzJdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVsyXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzJdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0dsb2JhbF1bM10uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzNdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bM10uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs0XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bNF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs0XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzVdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs1XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzVdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0dsb2JhbF1bNl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzZdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bNl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs3XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bN10uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs3XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzhdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbR2xvYmFsXVs4XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzhdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW0dsb2JhbF1bOV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtHbG9iYWxdWzldLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW0dsb2JhbF1bOV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbTW92ZV0uYk1hc3RlciI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbTW92ZV0uYnl2YWkiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW01vdmVdLmlDb3VudCI6eyJ2YWwiOlsyLjBdfSwiQW50aWJydXRlW01vdmVdLnNhbGFtIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtNb3ZlXS5zelN0YWdlIjp7InZhbCI6WyIyIl19LCJBbnRpYnJ1dGVbTW92ZV1bMTBdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bMTBdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzEwXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtNb3ZlXVsxXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzFdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzFdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW01vdmVdWzJdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bMl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bMl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbTW92ZV1bM10uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVszXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVszXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs0XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzRdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzRdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW01vdmVdWzVdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bNV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bNV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbTW92ZV1bNl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs2XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs2XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs3XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW01vdmVdWzddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW01vdmVdWzhdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bOF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbTW92ZV1bOF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbTW92ZV1bOV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs5XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtNb3ZlXVs5XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl0uYk1hc3RlciI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dLmJ5dmFpIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl0uaUNvdW50Ijp7InZhbCI6WzIuMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dLnNhbGFtIjp7InZhbCI6W2ZhbHNlXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl0uc3pTdGFnZSI6eyJ2YWwiOlsiMiJdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVsxMF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bMTBdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVsxMF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzFdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzFdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVsxXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bMl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bMl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzJdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVszXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVszXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bM10uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzRdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzRdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs0XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bNV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bNV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzVdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs2XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs2XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bNl0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzddLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs3XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bOF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bOF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU2xvdy1tb3Rpb25dWzhdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs5XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1Nsb3ctbW90aW9uXVs5XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTbG93LW1vdGlvbl1bOV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU3RhbmRdLmJNYXN0ZXIiOnsidmFsIjpbZmFsc2VdfSwiQW50aWJydXRlW1N0YW5kXS5ieXZhaSI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbU3RhbmRdLmlDb3VudCI6eyJ2YWwiOlsyLjBdfSwiQW50aWJydXRlW1N0YW5kXS5zYWxhbSI6eyJ2YWwiOltmYWxzZV19LCJBbnRpYnJ1dGVbU3RhbmRdLnN6U3RhZ2UiOnsidmFsIjpbIjIiXX0sIkFudGlicnV0ZVtTdGFuZF1bMTBdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzEwXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bMTBdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1N0YW5kXVsxXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVsxXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bMV0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzJdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzJdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVsyXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bM10uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bM10uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzNdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1N0YW5kXVs0XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVs0XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bNF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzVdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzVdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVs1XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bNl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bNl0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzZdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQW50aWJydXRlW1N0YW5kXVs3XS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVs3XS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bN10uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzhdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzhdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQW50aWJydXRlW1N0YW5kXVs4XS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bOV0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkFudGlicnV0ZVtTdGFuZF1bOV0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJBbnRpYnJ1dGVbU3RhbmRdWzldLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5iQm9keVlhdyI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW0FpcitdLmJPdmVycmlkZSI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW0FpcitdLmlEZWxheURlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltBaXIrXS5pRnJvbURlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltBaXIrXS5pTGVmdFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkJ1aWxkZXJbQWlyK10uaVJpZ2h0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0FpcitdLmlTcGVlZERlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltBaXIrXS5pVG9EZWdyZWUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVdheVsxMF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVdheVsxXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5pV2F5WzJdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0FpcitdLmlXYXlbM10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVdheVs0XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5pV2F5WzVdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0FpcitdLmlXYXlbNl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVdheVs3XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXIrXS5pV2F5WzhdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0FpcitdLmlXYXlbOV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVhXYXlDb3VudCI6eyJ2YWwiOlszLjBdfSwiQnVpbGRlcltBaXIrXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uaVlhd01vZGlmaWVyUmFuZG9taXplIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0FpcitdLmlZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyK10uc3pGcmVlc3RhbmRpbmdEZXN5bmMiOnsidmFsIjpbIk9mZiJdfSwiQnVpbGRlcltBaXIrXS5zek9wdGlvbnMiOnsidmFsIjpbW11dfSwiQnVpbGRlcltBaXIrXS5zelBpdGNoIjp7InZhbCI6WyJEb3duIl19LCJCdWlsZGVyW0FpcitdLnN6WFdheSI6eyJ2YWwiOlsiRGVmYXVsdCJdfSwiQnVpbGRlcltBaXIrXS5zellhdyI6eyJ2YWwiOlsiQmFja3dhcmQiXX0sIkJ1aWxkZXJbQWlyK10uc3pZYXdNZXRob2QiOnsidmFsIjpbIjE4MCJdfSwiQnVpbGRlcltBaXIrXS5zellhd01vZGlmaWVyIjp7InZhbCI6WyJEaXNhYmxlZCJdfSwiQnVpbGRlcltBaXJdLmJCb2R5WWF3Ijp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbQWlyXS5iT3ZlcnJpZGUiOnsidmFsIjpbZmFsc2VdfSwiQnVpbGRlcltBaXJdLmlEZWxheURlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltBaXJdLmlGcm9tRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Fpcl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkJ1aWxkZXJbQWlyXS5pTGVmdFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltBaXJdLmlSaWdodFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlTcGVlZERlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltBaXJdLmlUb0RlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlXYXlbMTBdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Fpcl0uaVdheVsxXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlXYXlbMl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyXS5pV2F5WzNdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Fpcl0uaVdheVs0XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlXYXlbNV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyXS5pV2F5WzZdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Fpcl0uaVdheVs3XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlXYXlbOF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyXS5pV2F5WzldIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Fpcl0uaVhXYXlDb3VudCI6eyJ2YWwiOlszLjBdfSwiQnVpbGRlcltBaXJdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlZYXdNb2RpZmllclJhbmRvbWl6ZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltBaXJdLmlZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQWlyXS5zekZyZWVzdGFuZGluZ0Rlc3luYyI6eyJ2YWwiOlsiT2ZmIl19LCJCdWlsZGVyW0Fpcl0uc3pPcHRpb25zIjp7InZhbCI6W1tdXX0sIkJ1aWxkZXJbQWlyXS5zelBpdGNoIjp7InZhbCI6WyJEb3duIl19LCJCdWlsZGVyW0Fpcl0uc3pYV2F5Ijp7InZhbCI6WyJEZWZhdWx0Il19LCJCdWlsZGVyW0Fpcl0uc3pZYXciOnsidmFsIjpbIkJhY2t3YXJkIl19LCJCdWlsZGVyW0Fpcl0uc3pZYXdNZXRob2QiOnsidmFsIjpbIjE4MCJdfSwiQnVpbGRlcltBaXJdLnN6WWF3TW9kaWZpZXIiOnsidmFsIjpbIkRpc2FibGVkIl19LCJCdWlsZGVyW0Nyb3VjaF0uYkJvZHlZYXciOnsidmFsIjpbZmFsc2VdfSwiQnVpbGRlcltDcm91Y2hdLmJPdmVycmlkZSI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW0Nyb3VjaF0uaURlbGF5RGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaUZyb21EZWdyZWUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQ3JvdWNoXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltDcm91Y2hdLmlMZWZ0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVJpZ2h0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVNwZWVkRGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVRvRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVdheVsxMF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQ3JvdWNoXS5pV2F5WzFdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVdheVsyXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltDcm91Y2hdLmlXYXlbM10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQ3JvdWNoXS5pV2F5WzRdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVdheVs1XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltDcm91Y2hdLmlXYXlbNl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQ3JvdWNoXS5pV2F5WzddIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVdheVs4XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltDcm91Y2hdLmlXYXlbOV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbQ3JvdWNoXS5pWFdheUNvdW50Ijp7InZhbCI6WzMuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVlhd01vZGlmaWVyUmFuZG9taXplIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Nyb3VjaF0uaVlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltDcm91Y2hdLnN6RnJlZXN0YW5kaW5nRGVzeW5jIjp7InZhbCI6WyJPZmYiXX0sIkJ1aWxkZXJbQ3JvdWNoXS5zek9wdGlvbnMiOnsidmFsIjpbW11dfSwiQnVpbGRlcltDcm91Y2hdLnN6UGl0Y2giOnsidmFsIjpbIkRvd24iXX0sIkJ1aWxkZXJbQ3JvdWNoXS5zelhXYXkiOnsidmFsIjpbIkRlZmF1bHQiXX0sIkJ1aWxkZXJbQ3JvdWNoXS5zellhdyI6eyJ2YWwiOlsiQmFja3dhcmQiXX0sIkJ1aWxkZXJbQ3JvdWNoXS5zellhd01ldGhvZCI6eyJ2YWwiOlsiMTgwIl19LCJCdWlsZGVyW0Nyb3VjaF0uc3pZYXdNb2RpZmllciI6eyJ2YWwiOlsiRGlzYWJsZWQiXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmJCb2R5WWF3Ijp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmJPdmVycmlkZSI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW0Zha2UgTGFnXS5pRGVsYXlEZWdyZWUiOnsidmFsIjpbMS4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlGcm9tRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Zha2UgTGFnXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltGYWtlIExhZ10uaUxlZnRZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltGYWtlIExhZ10uaVJpZ2h0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Zha2UgTGFnXS5pU3BlZWREZWdyZWUiOnsidmFsIjpbMS4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlUb0RlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltGYWtlIExhZ10uaVdheVsxMF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbMV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbMl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbM10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbNF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbNV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbNl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbN10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbOF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlXYXlbOV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlYV2F5Q291bnQiOnsidmFsIjpbMi4wXX0sIkJ1aWxkZXJbRmFrZSBMYWddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltGYWtlIExhZ10uaVlhd01vZGlmaWVyUmFuZG9taXplIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Zha2UgTGFnXS5pWWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0Zha2UgTGFnXS5zekZyZWVzdGFuZGluZ0Rlc3luYyI6eyJ2YWwiOlsiT2ZmIl19LCJCdWlsZGVyW0Zha2UgTGFnXS5zek9wdGlvbnMiOnsidmFsIjpbW11dfSwiQnVpbGRlcltGYWtlIExhZ10uc3pQaXRjaCI6eyJ2YWwiOlsiRG93biJdfSwiQnVpbGRlcltGYWtlIExhZ10uc3pYV2F5Ijp7InZhbCI6WyJEZWZhdWx0Il19LCJCdWlsZGVyW0Zha2UgTGFnXS5zellhdyI6eyJ2YWwiOlsiQmFja3dhcmQiXX0sIkJ1aWxkZXJbRmFrZSBMYWddLnN6WWF3TWV0aG9kIjp7InZhbCI6WyIxODAiXX0sIkJ1aWxkZXJbRmFrZSBMYWddLnN6WWF3TW9kaWZpZXIiOnsidmFsIjpbIkRpc2FibGVkIl19LCJCdWlsZGVyW0dsb2JhbF0uYkJvZHlZYXciOnsidmFsIjpbZmFsc2VdfSwiQnVpbGRlcltHbG9iYWxdLmlEZWxheURlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlGcm9tRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0dsb2JhbF0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkJ1aWxkZXJbR2xvYmFsXS5pTGVmdFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltHbG9iYWxdLmlSaWdodFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlTcGVlZERlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlUb0RlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlXYXlbMTBdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0dsb2JhbF0uaVdheVsxXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlXYXlbMl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbR2xvYmFsXS5pV2F5WzNdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0dsb2JhbF0uaVdheVs0XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlXYXlbNV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbR2xvYmFsXS5pV2F5WzZdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0dsb2JhbF0uaVdheVs3XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlXYXlbOF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbR2xvYmFsXS5pV2F5WzldIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW0dsb2JhbF0uaVhXYXlDb3VudCI6eyJ2YWwiOlsyLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlZYXdNb2RpZmllclJhbmRvbWl6ZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltHbG9iYWxdLmlZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbR2xvYmFsXS5zekZyZWVzdGFuZGluZ0Rlc3luYyI6eyJ2YWwiOlsiT2ZmIl19LCJCdWlsZGVyW0dsb2JhbF0uc3pPcHRpb25zIjp7InZhbCI6W1tdXX0sIkJ1aWxkZXJbR2xvYmFsXS5zelBpdGNoIjp7InZhbCI6WyJEb3duIl19LCJCdWlsZGVyW0dsb2JhbF0uc3pYV2F5Ijp7InZhbCI6WyJEZWZhdWx0Il19LCJCdWlsZGVyW0dsb2JhbF0uc3pZYXciOnsidmFsIjpbIkJhY2t3YXJkIl19LCJCdWlsZGVyW0dsb2JhbF0uc3pZYXdNZXRob2QiOnsidmFsIjpbIjE4MCJdfSwiQnVpbGRlcltHbG9iYWxdLnN6WWF3TW9kaWZpZXIiOnsidmFsIjpbIkRpc2FibGVkIl19LCJCdWlsZGVyW01vdmVdLmJCb2R5WWF3Ijp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbTW92ZV0uYk92ZXJyaWRlIjp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbTW92ZV0uaURlbGF5RGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW01vdmVdLmlGcm9tRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW01vdmVdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJCdWlsZGVyW01vdmVdLmlMZWZ0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW01vdmVdLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltNb3ZlXS5pUmlnaHRZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbTW92ZV0uaVNwZWVkRGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW01vdmVdLmlUb0RlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pV2F5WzEwXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pV2F5WzFdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW01vdmVdLmlXYXlbMl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbTW92ZV0uaVdheVszXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pV2F5WzRdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW01vdmVdLmlXYXlbNV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbTW92ZV0uaVdheVs2XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pV2F5WzddIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW01vdmVdLmlXYXlbOF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbTW92ZV0uaVdheVs5XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pWFdheUNvdW50Ijp7InZhbCI6WzQuMF19LCJCdWlsZGVyW01vdmVdLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5pWWF3TW9kaWZpZXJSYW5kb21pemUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbTW92ZV0uaVlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltNb3ZlXS5zekZyZWVzdGFuZGluZ0Rlc3luYyI6eyJ2YWwiOlsiT2ZmIl19LCJCdWlsZGVyW01vdmVdLnN6T3B0aW9ucyI6eyJ2YWwiOltbXV19LCJCdWlsZGVyW01vdmVdLnN6UGl0Y2giOnsidmFsIjpbIkRvd24iXX0sIkJ1aWxkZXJbTW92ZV0uc3pYV2F5Ijp7InZhbCI6WyJEZWZhdWx0Il19LCJCdWlsZGVyW01vdmVdLnN6WWF3Ijp7InZhbCI6WyJCYWNrd2FyZCJdfSwiQnVpbGRlcltNb3ZlXS5zellhd01ldGhvZCI6eyJ2YWwiOlsiMTgwIl19LCJCdWlsZGVyW01vdmVdLnN6WWF3TW9kaWZpZXIiOnsidmFsIjpbIkRpc2FibGVkIl19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5iQm9keVlhdyI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5iT3ZlcnJpZGUiOnsidmFsIjpbZmFsc2VdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uaURlbGF5RGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pRnJvbURlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uaUxlZnRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLmlMZWZ0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pUmlnaHRMaW1pdCI6eyJ2YWwiOls1OC4wXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLmlSaWdodFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uaVNwZWVkRGVncmVlIjp7InZhbCI6WzEuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pVG9EZWdyZWUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLmlXYXlbMTBdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzFdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzJdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzNdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzRdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzVdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzZdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzddIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzhdIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pV2F5WzldIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pWFdheUNvdW50Ijp7InZhbCI6WzMuMF19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5pWWF3TW9kaWZpZXIiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLmlZYXdNb2RpZmllclJhbmRvbWl6ZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uaVlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uc3pGcmVlc3RhbmRpbmdEZXN5bmMiOnsidmFsIjpbIk9mZiJdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uc3pPcHRpb25zIjp7InZhbCI6W1tdXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLnN6UGl0Y2giOnsidmFsIjpbIkRvd24iXX0sIkJ1aWxkZXJbU2xvdy1tb3Rpb25dLnN6WFdheSI6eyJ2YWwiOlsiRGVmYXVsdCJdfSwiQnVpbGRlcltTbG93LW1vdGlvbl0uc3pZYXciOnsidmFsIjpbIkJhY2t3YXJkIl19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5zellhd01ldGhvZCI6eyJ2YWwiOlsiMTgwIl19LCJCdWlsZGVyW1Nsb3ctbW90aW9uXS5zellhd01vZGlmaWVyIjp7InZhbCI6WyJEaXNhYmxlZCJdfSwiQnVpbGRlcltTdGFuZF0uYkJvZHlZYXciOnsidmFsIjpbZmFsc2VdfSwiQnVpbGRlcltTdGFuZF0uYk92ZXJyaWRlIjp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbU3RhbmRdLmlEZWxheURlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltTdGFuZF0uaUZyb21EZWdyZWUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU3RhbmRdLmlMZWZ0TGltaXQiOnsidmFsIjpbNTguMF19LCJCdWlsZGVyW1N0YW5kXS5pTGVmdFlhd09mZnNldCI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVJpZ2h0TGltaXQiOnsidmFsIjpbNTguMF19LCJCdWlsZGVyW1N0YW5kXS5pUmlnaHRZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU3RhbmRdLmlTcGVlZERlZ3JlZSI6eyJ2YWwiOlsxLjBdfSwiQnVpbGRlcltTdGFuZF0uaVRvRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1N0YW5kXS5pV2F5WzEwXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVsxXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVsyXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVszXSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs0XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs1XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs2XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs3XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs4XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVdheVs5XSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltTdGFuZF0uaVhXYXlDb3VudCI6eyJ2YWwiOls0LjBdfSwiQnVpbGRlcltTdGFuZF0uaVlhd01vZGlmaWVyIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1N0YW5kXS5pWWF3TW9kaWZpZXJSYW5kb21pemUiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU3RhbmRdLmlZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbU3RhbmRdLnN6RnJlZXN0YW5kaW5nRGVzeW5jIjp7InZhbCI6WyJPZmYiXX0sIkJ1aWxkZXJbU3RhbmRdLnN6T3B0aW9ucyI6eyJ2YWwiOltbXV19LCJCdWlsZGVyW1N0YW5kXS5zelBpdGNoIjp7InZhbCI6WyJEb3duIl19LCJCdWlsZGVyW1N0YW5kXS5zelhXYXkiOnsidmFsIjpbIkRlZmF1bHQiXX0sIkJ1aWxkZXJbU3RhbmRdLnN6WWF3Ijp7InZhbCI6WyJCYWNrd2FyZCJdfSwiQnVpbGRlcltTdGFuZF0uc3pZYXdNZXRob2QiOnsidmFsIjpbIjE4MCJdfSwiQnVpbGRlcltTdGFuZF0uc3pZYXdNb2RpZmllciI6eyJ2YWwiOlsiRGlzYWJsZWQiXX0sIkJ1aWxkZXJbVXNpbmddLmJCb2R5WWF3Ijp7InZhbCI6W2ZhbHNlXX0sIkJ1aWxkZXJbVXNpbmddLmJPdmVycmlkZSI6eyJ2YWwiOltmYWxzZV19LCJCdWlsZGVyW1VzaW5nXS5pRGVsYXlEZWdyZWUiOnsidmFsIjpbMS4wXX0sIkJ1aWxkZXJbVXNpbmddLmlGcm9tRGVncmVlIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1VzaW5nXS5pTGVmdExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltVc2luZ10uaUxlZnRZYXdPZmZzZXQiOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlSaWdodExpbWl0Ijp7InZhbCI6WzU4LjBdfSwiQnVpbGRlcltVc2luZ10uaVJpZ2h0WWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1VzaW5nXS5pU3BlZWREZWdyZWUiOnsidmFsIjpbMS4wXX0sIkJ1aWxkZXJbVXNpbmddLmlUb0RlZ3JlZSI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltVc2luZ10uaVdheVsxMF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbMV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbMl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbM10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbNF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbNV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbNl0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbN10iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbOF0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlXYXlbOV0iOnsidmFsIjpbMC4wXX0sIkJ1aWxkZXJbVXNpbmddLmlYV2F5Q291bnQiOnsidmFsIjpbMi4wXX0sIkJ1aWxkZXJbVXNpbmddLmlZYXdNb2RpZmllciI6eyJ2YWwiOlswLjBdfSwiQnVpbGRlcltVc2luZ10uaVlhd01vZGlmaWVyUmFuZG9taXplIjp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1VzaW5nXS5pWWF3T2Zmc2V0Ijp7InZhbCI6WzAuMF19LCJCdWlsZGVyW1VzaW5nXS5zekZyZWVzdGFuZGluZ0Rlc3luYyI6eyJ2YWwiOlsiT2ZmIl19LCJCdWlsZGVyW1VzaW5nXS5zek9wdGlvbnMiOnsidmFsIjpbW11dfSwiQnVpbGRlcltVc2luZ10uc3pYV2F5Ijp7InZhbCI6WyJEZWZhdWx0Il19LCJCdWlsZGVyW1VzaW5nXS5zellhd01ldGhvZCI6eyJ2YWwiOlsiMTgwIl19LCJCdWlsZGVyW1VzaW5nXS5zellhd01vZGlmaWVyIjp7InZhbCI6WyJEaXNhYmxlZCJdfSwiRGVmZW5zaXZlX2lQaXRjaFZhbHVlIjp7InZhbCI6WzAuMF19LCJEZWZlbnNpdmVfaVlhd1ZhbHVlIjp7InZhbCI6WzAuMF19LCJEZWZlbnNpdmVfc2NEaXNhYmxlU3RhdGVzIjp7InZhbCI6W1tdXX0sIkRlZmVuc2l2ZV9zelBpdGNoIjp7InZhbCI6WyJJbmNyZWFzZSJdfSwiRGVmZW5zaXZlX3N6WWF3Ijp7InZhbCI6WyJPcHBvc2l0ZSJdfSwiYkFsbG93QUFvblVzZSI6eyJ2YWwiOlt0cnVlXX0sImJBbmltQnJlYWtlciI6eyJ2YWwiOltmYWxzZV19LCJiQW5pbUJyZWFrZXIuYlBpdGNoWmVyb09uTGFuZCI6eyJ2YWwiOlt0cnVlXX0sImJBbmltQnJlYWtlci5iU2xpZGluZ0Nyb3VjaCI6eyJ2YWwiOlt0cnVlXX0sImJBbmltQnJlYWtlci5iU2xpZGluZ1Nsb3dXYWxrIjp7InZhbCI6W3RydWVdfSwiYkFuaW1CcmVha2VyLnN6QWlyIjp7InZhbCI6WyJNaWNoYWVsIEphY2tzb24iXX0sImJBbmltQnJlYWtlci5zekxlZ01vdmVtZW50Ijp7InZhbCI6WyJGcm96ZW4iXX0sImJEZWZlbnNpdmVBQSI6eyJ2YWwiOlt0cnVlXX0sImJEZWZlbnNpdmVBQS5SYW5kb21pemVUaWNrcyI6eyJ2YWwiOltmYWxzZV19LCJiRWRnZVlhdyI6eyJ2YWwiOltmYWxzZV19LCJiRnJlZXN0YW5kaW5nIjp7InZhbCI6W2ZhbHNlXX0sImJTaGl0UHJlc2V0Ijp7InZhbCI6W3RydWVdfSwic3pBbGxvd0FBb25Vc2UiOnsidmFsIjpbIkZha2UgSml0dGVyIFBlZWsiXX0sInN6QnVpbGRlclN0YXRlIjp7InZhbCI6WyJHbG9iYWwiXX0sInN6RGlzYWJsZXJzIjp7InZhbCI6W1siRnJlZXN0YW5kaW5nIiwiTWFudWFscyJdXX0sInN6RWRnZVlhdyI6eyJ2YWwiOlsiRXllIEJhc2VkIl19LCJzek1hbnVhbFlhdyI6eyJ2YWwiOlsiRGlzYWJsZWQiXX0sInN6TW9kZSI6eyJ2YWwiOlsiSHlicmlkIl19LCJ0eHRBbGxvd0FBb25Vc2UiOnsidmFsIjpbMjg5NTUzMzgyOC4wXX0sInR4dFhXYXkiOnsidmFsIjpbMzAzOTY3NzQ2MC4wXX19LCJEUkFHIjp7ImZsWFtkYW1hZ2VfaW5kaWNhdG9yXSI6eyJ2YWwiOls5NzEuMF19LCJmbFhba2V5YmluZHNdIjp7InZhbCI6WzMyOC4wXX0sImZsWVtkYW1hZ2VfaW5kaWNhdG9yXSI6eyJ2YWwiOls0NzYuMF19LCJmbFlba2V5YmluZHNdIjp7InZhbCI6WzM3NS4wXX19LCJIaXRtYXJrZXIiOnsiYkNvbnRyb2xsZXIiOnsidmFsIjpbZmFsc2VdfSwiY2xySGl0Ijp7ImNvbG9yIjoiRkZGRkZGRkYifSwiY2xyTGV0aGFsIjp7ImNvbG9yIjoiQTRENjc3RkYifX0sIklDUyI6eyJiU2NvcGVBbGlnbm1lbnQiOnsidmFsIjpbdHJ1ZV19LCJjbHJQcmltYXJ5Ijp7ImNvbG9yIjoiNDg2QUZGRkYifSwiY2xyU2Vjb25kYXJ5Ijp7ImNvbG9yIjoiOTVBOUZERkYifSwiY2xyVGVydGlhcnkiOnsiY29sb3IiOiI5NUE5RkRGRiJ9LCJpQW5pbWF0aW9uU3BlZWQiOnsidmFsIjpbMzAuMF19LCJzekNvbnRyb2xsZXIiOnsidmFsIjpbIlN0eWxpc2giXX19LCJLaWJpdE1hcmtlciI6eyJiQ29udHJvbGxlciI6eyJ2YWwiOlt0cnVlXX0sImNsckhvcml6b250YWwiOnsiY29sb3IiOiI5NUIyRkRGRiJ9LCJjbHJWZXJ0aWNhbCI6eyJjb2xvciI6Ijk1OUZGREZGIn19LCJNQSI6eyJiSGlkZVdoZW5TY29wZWQiOnsidmFsIjpbdHJ1ZV19LCJjbHJQcmltYXJ5Ijp7ImNvbG9yIjoiNjk4QUZGRkIifSwiY2xyU2Vjb25kYXJ5Ijp7ImNvbG9yIjoiMTExMTExODAifSwic3pDb250cm9sbGVyIjp7InZhbCI6WyJUcmlhbmdsZSJdfX0sIk1JU0MiOnsiYkFzcGVjdFJhdGlvIjp7InZhbCI6W2ZhbHNlXX0sImJBc3BlY3RSYXRpbzEiOnsidmFsIjpbZmFsc2VdfSwiYkFzcGVjdFJhdGlvMiI6eyJ2YWwiOltmYWxzZV19LCJiQXNwZWN0UmF0aW8zIjp7InZhbCI6W2ZhbHNlXX0sImJBc3BlY3RSYXRpbzQiOnsidmFsIjpbZmFsc2VdfSwiYkFzcGVjdFJhdGlvNSI6eyJ2YWwiOltmYWxzZV19LCJiQ2xhbnRhZyI6eyJ2YWwiOlt0cnVlXX0sImJDb25zb2xlQ29sb3IiOnsidmFsIjpbdHJ1ZV19LCJiRHJvcE5hZGVzIjp7InZhbCI6W2ZhbHNlXX0sImJGYXN0TGFkZGVyIjp7InZhbCI6W3RydWVdfSwiYlNoaXRUYWxraW5nIjp7InZhbCI6W3RydWVdfSwiYlRhc2tiYXJOb3RpZnkiOnsidmFsIjpbdHJ1ZV19LCJiVmlld21vZGVsQ2hhbmdlciI6eyJ2YWwiOlt0cnVlXX0sImNsckNvbnNvbGVDb2xvciI6eyJjb2xvciI6IjVDNUM1Q0ZGIn0sImZsQXNwZWN0UmF0aW8iOnsidmFsIjpbMTQ1LjBdfSwiZmxWaWV3bW9kZWxGb3YiOnsidmFsIjpbNTk5LjBdfSwiZmxWaWV3bW9kZWxYIjp7InZhbCI6WzkuMF19LCJmbFZpZXdtb2RlbFkiOnsidmFsIjpbLTMzLjBdfSwiZmxWaWV3bW9kZWxaIjp7InZhbCI6Wy04LjBdfX0sIlJBR0UiOnsiYkJvZHlBaW1JZkxldGhhbCI6eyJ2YWwiOltmYWxzZV19LCJiQ2FsY3VsYXRlRGFtYWdlIjp7InZhbCI6W3RydWVdfSwiYkNhbGN1bGF0ZVR3b3Nob3QiOnsidmFsIjpbdHJ1ZV19LCJiRGlzY2hhcmdlRXhwbG9pdCI6eyJ2YWwiOltmYWxzZV19LCJiUmFnZWJvdExvZ3MiOnsidmFsIjpbdHJ1ZV19LCJiUmFnZWJvdExvZ3MuY2xyRGVhdGgiOnsiY29sb3IiOiIyQzJDMkNGRiJ9LCJiUmFnZWJvdExvZ3MuY2xySGl0Ijp7ImNvbG9yIjoiOEQ5OEZGRkIifSwiYlJhZ2Vib3RMb2dzLmNsck1pc3MiOnsiY29sb3IiOiJGRjhEOERGQiJ9LCJiUmFnZWJvdExvZ3Muc3pEcmF3Ijp7InZhbCI6W1siT24gU2NyZWVuIiwiQ29uc29sZSJdXX0sInNEaXNjaGFyZ2VXZWFwb25zIjp7InZhbCI6W1siU25pcGVycyJdXX0sInN6RXhwbG9pdFR3ZWFrcyI6eyJ2YWwiOltbIkZvcmNlIERlZmVuc2l2ZSBBaXIiLCJGYWtlIExhZyBvbiBDcm91Y2giLCJPZmYgRmFrZSBMYWcgb24gRFQiLCJGaXggdGhyb3cgTmFkZXMiLCJJZ25vcmUgc2hpZnQgaW4gQWlyIFN0cmFmZSJdXX19LCJTTCI6eyJiQW5pbWF0ZVpvb20iOnsidmFsIjpbdHJ1ZV19LCJiQ29udHJvbGxlciI6eyJ2YWwiOlt0cnVlXX0sImNsclBpY2tlciI6eyJjb2xvciI6IkZGRkZGRkZGIn0sImlPZmZzZXQiOnsidmFsIjpbNzAuMF19LCJpUG9zaXRpb24iOnsidmFsIjpbMTQuMF19fSwiVklTVUFMUyI6eyJiQmciOnsidmFsIjpbZmFsc2VdfSwiYkRhbWFnZUluZGljYXRvciI6eyJ2YWwiOltmYWxzZV19LCJiR2FtZVNlbnNlIjp7InZhbCI6W3RydWVdfSwiYkdsb3ciOnsidmFsIjpbdHJ1ZV19LCJiS2V5YmluZHMiOnsidmFsIjpbZmFsc2VdfSwiYldhdGVybWFyayI6eyJ2YWwiOlt0cnVlXX0sImJXYXRlcm1hcmsuc3pOYW1lIjp7InZhbCI6WyIiXX0sImNsckNvbG9yIjp7ImNvbG9yIjoiNjk4QUZGRkIifSwiY2xyQ29sb3JMb2dvRmlyc3QiOnsiY29sb3IiOiI4OEI4RkZGRiJ9LCJjbHJDb2xvckxvZ29TZWNvbmQiOnsiY29sb3IiOiJGRkZGRkZGRiJ9LCJpUm91bmRpbmciOnsidmFsIjpbNS4wXX0sInN6R2FtZVNlbnNlIjp7InZhbCI6W1siSW5kaWNhdG9ycyIsIk5ldCBHcmFwaCIsIkJ1eSBMaXN0Il1dfSwic3pHYW1lU2Vuc2Uuc3pFeHRyYUluZGljYXRvcnMiOnsidmFsIjpbWzEuMCwxMy4wXV19LCJzelN0eWxlIjp7InZhbCI6WyJSZW5ld2VkIl19fX0=_xoyaw");
        common.add_notify("xo-yaw.lua", "Succesfully loaded default config");
        utils.console_exec("play ui\\beepclear");
    end);
    v406.join_discord_server:set_callback(function()
        v252.ShellExecuteA(nil, "open", "https://discord.gg/GkJhY44rdB", nil, nil, 1);
    end);
    v406.config_demyaha:set_callback(function()
        v252.ShellExecuteA(nil, "open", "https://en.neverlose.cc/market/item?id=FcEbaS", nil, nil, 1);
    end);
    v406.get_discord_role:set_callback(function()
        local v627 = {
            username = l_get_username_0(), 
            role = v393.build == "stable" and "live" or "beta"
        };
        v627.signature = v480(v627, "vitalikmudilalyblumobili");
        network.post("http://ethereal.su:25565/luaserver", json.stringify(v627), {
            ["content-type"] = "application/json"
        }, function(v628)
            if not v628 then
                l_print_0("Failed to get token");
                utils.console_exec("play buttons/weapon_cant_buy.wav");
                return ;
            else
                local l_status_2, l_result_2 = pcall(json.parse, v628);
                if not l_status_2 or not l_result_2.generated_token then
                    l_print_0(("Failed to get token. Status %s"):format(not l_status_2 and tostring(l_result_2) or "unaccessible"));
                    utils.console_exec("play buttons/weapon_cant_buy.wav");
                    return ;
                else
                    local l_generated_token_0 = l_result_2.generated_token;
                    utils.console_exec("play ui/beepclear");
                    l_print_0(("Your token is %s. It also copied to clipboard. Use it in any discord chat with command: \n/getnlrole token:%s username:%s "):format(l_generated_token_0, l_generated_token_0, v393.user));
                    l_clipboard_0.set(l_generated_token_0);
                    return ;
                end;
            end;
        end);
    end);
    v406.discord_tutorial:set_callback(function()
        v252.ShellExecuteA(nil, "open", "https://www.youtube.com/watch?v=Fe7xxM88U-g&ab_channel=Villian", nil, nil, 1);
    end);
    v506 = v395.antiaim.misc;
    v551 = {
        CROUCH = 4, 
        SLOW_MOTION = 3, 
        MOVE = 2, 
        STAND = 1, 
        FAKELAG = 7, 
        AIR_EX = 6, 
        AIR = 5
    };
    local v632 = {
        [v551.STAND] = "Stand", 
        [v551.MOVE] = "Move", 
        [v551.SLOW_MOTION] = "Slow-motion", 
        [v551.CROUCH] = "Crouch", 
        [v551.AIR] = "Air", 
        [v551.AIR_EX] = "Air+", 
        [v551.FAKELAG] = "Fake Lag"
    };
    v407.enum = v551;
    v407.states = v632;
    v407.using = false;
    v407.crouch = false;
    v407.moving = false;
    v407.onground = false;
    v407.velocity = 0;
    v407.target = "";
    v407.state = "";
    v407.packets = 0;
    v407.body_yaw = 0;
    do
        local l_v506_2, l_v551_1, l_v632_0 = v506, v551, v632;
        v407.get_state = function(v636, _, _, v639)
            if (not v639 and not v395.ragebot.main.double_tap:get()) and not v395.ragebot.main.hide_shots:get() then
                return l_v632_0[l_v551_1.FAKELAG];
            else
                local l_crouch_0 = v636.crouch;
                if not v636.onground then
                    return l_v632_0[l_crouch_0 and l_v551_1.AIR_EX or l_v551_1.AIR];
                elseif l_crouch_0 or v395.antiaim.misc.fake_duck:get() then
                    return l_v632_0[l_v551_1.CROUCH];
                elseif v636.moving then
                    return l_v632_0[l_v506_2.slow_walk:get() and l_v551_1.SLOW_MOTION or l_v551_1.MOVE];
                else
                    return l_v632_0[l_v551_1.STAND];
                end;
            end;
        end;
        v407.pre = function(v641, v642, v643, v644)
            v641.using = v642.in_use;
            v641.crouch = v643.m_flDuckAmount > 0;
            v641.velocity = v644.velocity_length_xy;
            v641.moving = v641.velocity > 5;
            v641.onground = v644.on_ground and not v644.landed_on_ground_this_frame;
        end;
        v407.post = function(v645, v646, v647, v648)
            v645.state = v645:get_state(v646, v647);
            if v646.choked_commands == 0 then
                v645.packets = v645.packets + 1;
                v645.body_yaw = l_normalize_yaw_0(v648.eye_yaw - v648.abs_yaw);
            end;
        end;
        v407.get_target = function(_)
            if entity.get_threat() ~= nil then
                v407.target = entity.get_threat():get_name();
            end;
        end;
        v407.createmove = function(v650, v651)
            local v652 = l_get_local_player_0();
            if v652 == nil then
                return ;
            else
                local v653 = v652:get_anim_state();
                if v653 == nil then
                    return ;
                else
                    v650:pre(v651, v652, v653);
                    v650:post(v651, v652, v653);
                    return ;
                end;
            end;
        end;
    end;
    v506 = nil;
    v551 = {};
    v632 = v395.antiaim.angles;
    local v654 = 58;
    local v655 = "Global";
    local v656 = "Using";
    local v657 = {
        unpack(v407.states)
    };
    l_insert_0(v657, 1, v655);
    l_insert_0(v657, v656);
    local v658 = {};
    local v659 = {};
    local v660 = {};
    local v661 = {};
    local v662 = {};
    local v663 = {};
    local v664 = {};
    local v665 = {};
    local v666 = {};
    local v667 = {};
    local v668 = {};
    local function v670(v669, ...)
        if ... == nil then
            return ;
        else
            v669:override(...);
            return ;
        end;
    end;
    v506 = function(v671, v672, v673, v674)
        v671.yaw_modifier = v403("AA", l_format_0(v673, "szYawModifier"), v672:combo("Yaw Modifier", {
            [1] = "Disabled", 
            [2] = "Center", 
            [3] = "Offset", 
            [4] = "Random", 
            [5] = "Spin", 
            [6] = "3-Way", 
            [7] = "5-Way", 
            [8] = "X-Way"
        }));
        local l_status_3, l_result_3 = pcall(v671.yaw_modifier.create, v671.yaw_modifier);
        local _ = 0;
        if not l_status_3 then
            l_result_3 = v672;
        end;
        local function v678()
            return v671.yaw_modifier:get() ~= "Disabled";
        end;
        local function v679()
            return v671.yaw_modifier:get() == "X-Way";
        end;
        v671.way = {};
        v671.x_way = v403("AA", l_format_0(v673, "szXWay"), l_result_3.combo(l_result_3, "X-Way", {
            [1] = "Default", 
            [2] = "Custom"
        })):depend(v679);
        v671.x_way_count = v403("AA", l_format_0(v673, "iXWayCount"), l_result_3.slider(l_result_3, "X-Way Count", 2, 10, 2)):depend(v679);
        v671.modifier_offset = v403("AA", l_format_0(v673, "iYawModifier"), l_result_3.slider(l_result_3, "Offset", -180, 180, 0, 1, "\194\176")):depend(v678);
        local function v680()
            return v671.x_way:get() == "Custom" and (tonumber((v671.x_way_count:get())) or false);
        end;
        v671.modifier_offset:depend(function()
            return not v679() or v671.x_way:get() == "Default";
        end);
        for v681 = 1, 10 do
            v671.way[v681] = v403("AA", l_format_0(v673, l_format_0("iWay[%d]", v681)), l_result_3.slider(l_result_3, l_format_0("%d%s Way", v681, v457(v681)), -180, 180, 0, 1, "\194\176")):depend(v679);
            do
                local l_v681_0 = v681;
                v671.way[l_v681_0]:depend(function()
                    local v683 = v680();
                    return (v683 and l_v681_0 <= v683) and v671.x_way:get() == "Custom";
                end);
            end;
        end;
        if v674 ~= nil then
            v671.yaw_modifier:depend(v674);
        end;
        v671.randomize_offset = v403("AA", l_format_0(v673, "iYawModifierRandomize"), l_result_3.slider(l_result_3, "Randomize", 0, 180, 0)):depend(v678);
        return v671;
    end;
    v408.yaw = 0;
    v408.yaw_modifier = 0;
    v408.antibrute = v662;
    v408.manual_yaw = v665;
    v408.freestanding = v666;
    v408.edge_yaw = v664;
    v659.pressed = false;
    v659.valid_entities = {
        CCSPlayer = true, 
        CWorld = true, 
        CFuncBrush = true
    };
    v660.controller = v403("AA", "szMode", v405.groups.aa.main:combo("Mode"));
    v660.container = v405:combo_control(v660.controller, {
        [1] = "Disabled"
    });
    do
        local l_v632_1, l_v654_0, l_v655_0, l_v656_0, l_v659_0, l_v660_0, l_v661_0, l_v662_0, l_v663_0, l_v664_0, l_v665_0, l_v666_0, l_v667_0, l_v668_0, l_v670_0 = v632, v654, v655, v656, v659, v660, v661, v662, v663, v664, v665, v666, v667, v668, v670;
        local function v700(v699)
            v699.pitch = "Down";
            v699.yaw = "Backward";
            v699.yaw_base = "At Target";
            v699.body_yaw = true;
            v699.inverter = false;
            v699.left_limit = v699.left_limit or l_v654_0;
            v699.right_limit = v699.right_limit or l_v654_0;
            v699.options = "Jitter";
            v699.freestanding_desync = "Disabled";
            v699.antibrute_length = v699.antibrute ~= nil and #v699.antibrute or 0;
            return v699;
        end;
        local function v702(v701)
            v701.pitch = "Down";
            v701.yaw = "Backward";
            v701.yaw_base = "At Target";
            v701.body_yaw = true;
            v701.inverter = false;
            v701.options = v701.options or "";
            v701.freestanding_desync = v701.freestanding_desync;
            v701.antibrute_length = v701.antibrute ~= nil and #v701.antibrute or 0;
            return v701;
        end;
        l_v660_0.container.Hybrid = {
            [v407.states[v407.enum.STAND]] = v700({
                yaw_modifier = "Disabled", 
                modifier_offset = 0, 
                right_yaw = 47, 
                left_yaw = -23, 
                yaw_method = "180LR"
            }), 
            [v407.states[v407.enum.CROUCH]] = v700({
                right_limit = 40, 
                modifier_offset = -49, 
                randomize_offset = 15, 
                yaw_modifier = "Offset", 
                left_limit = 40, 
                yaw_method = "180", 
                yaw_offset = 35
            }), 
            [v407.states[v407.enum.MOVE]] = v700({
                right_limit = 58, 
                modifier_offset = -58, 
                randomize_offset = 15, 
                yaw_modifier = "Offset", 
                left_limit = 58, 
                yaw_method = "180", 
                yaw_offset = 34
            }), 
            [v407.states[v407.enum.SLOW_MOTION]] = v700({
                yaw_modifier = "Offset", 
                modifier_offset = -75, 
                randomize_offset = 15, 
                right_yaw = 45, 
                left_yaw = 45, 
                left_limit = 45, 
                yaw_method = "180LR", 
                right_limit = 45
            }), 
            [v407.states[v407.enum.AIR]] = v700({
                yaw_modifier = "Center", 
                modifier_offset = -55, 
                right_yaw = 10, 
                left_yaw = -3, 
                yaw_method = "180LR"
            }), 
            [v407.states[v407.enum.AIR_EX]] = v700({
                modifier_offset = -64, 
                randomize_offset = 15, 
                yaw_modifier = "Center", 
                yaw_method = "180", 
                yaw_offset = 12
            })
        };
        l_v660_0.container["X-Way"] = {
            [v407.states[v407.enum.STAND]] = v702({
                modifier_offset = 0, 
                right_limit = 58, 
                left_limit = 58, 
                x_way_method = "Custom", 
                yaw_modifier = "X-Way", 
                x_way_count = 3, 
                yaw_method = "180", 
                yaw_offset = 0, 
                x_ways = {
                    [1] = -14, 
                    [2] = -15, 
                    [3] = 45
                }
            }), 
            [v407.states[v407.enum.MOVE]] = v702({
                modifier_offset = 0, 
                right_limit = 54, 
                left_limit = 36, 
                x_way_method = "Custom", 
                yaw_modifier = "X-Way", 
                x_way_count = 5, 
                yaw_method = "180", 
                yaw_offset = 0, 
                x_ways = {
                    [1] = -9, 
                    [2] = -13, 
                    [3] = -10, 
                    [4] = 46, 
                    [5] = 30
                }
            }), 
            [v407.states[v407.enum.SLOW_MOTION]] = v702({
                modifier_offset = 0, 
                right_limit = 28, 
                left_limit = 30, 
                x_way_method = "Custom", 
                yaw_modifier = "X-Way", 
                x_way_count = 3, 
                yaw_method = "180", 
                yaw_offset = 0, 
                x_ways = {
                    [1] = -6, 
                    [2] = -5, 
                    [3] = 41
                }
            }), 
            [v407.states[v407.enum.CROUCH]] = v702({
                modifier_offset = 0, 
                right_limit = 44, 
                left_limit = 41, 
                x_way_method = "Custom", 
                yaw_modifier = "X-Way", 
                x_way_count = 5, 
                yaw_method = "180", 
                yaw_offset = 0, 
                x_ways = {
                    [1] = 6, 
                    [2] = 4, 
                    [3] = 44, 
                    [4] = -2, 
                    [5] = 50
                }
            }), 
            [v407.states[v407.enum.AIR]] = v702({
                modifier_offset = 0, 
                right_limit = 58, 
                left_limit = 58, 
                x_way_method = "Custom", 
                yaw_modifier = "X-Way", 
                x_way_count = 5, 
                yaw_method = "180", 
                yaw_offset = 0, 
                x_ways = {
                    [1] = 2, 
                    [2] = 0, 
                    [3] = 42
                }
            }), 
            [v407.states[v407.enum.AIR_EX]] = v700({
                yaw_modifier = "Center", 
                modifier_offset = -47, 
                right_yaw = 20, 
                left_yaw = 5, 
                yaw_method = "180LR"
            })
        };
        l_v660_0.container.Custom = function(v703)
            v408:builder(v703);
        end;
        local function v704()
            return l_v660_0.controller:get() == "Custom";
        end;
        l_v661_0.state = v403("AA", "szBuilderState", v405.groups.aa.angles:combo("State", v657));
        l_v661_0.state:depend(v704);
        l_v662_0.min = 2;
        l_v662_0.max = 10;
        l_v662_0.time = -1;
        l_v662_0.stage = 0;
        l_v662_0.delay = 3;
        l_v662_0.target = nil;
        l_v662_0.current = 0;
        for v705 = 1, #v657 do
            local v706 = v657[v705];
            local v707 = {};
            do
                local l_v706_0, l_v707_0 = v706, v707;
                local function v710()
                    return v704() and l_v661_0.state:get() == l_v706_0;
                end;
                local function v712(v711)
                    return l_format_0("Builder[%s].%s", l_v706_0, v711);
                end;
                local l_v710_0 = v710;
                if l_v706_0 ~= l_v655_0 then
                    l_v707_0.override = v403("AA", v712("bOverride"), v405.groups.aa.angles:switch("Override"));
                    l_v707_0.override:depend(l_v710_0);
                    l_v710_0 = function()
                        return v710() and l_v707_0.override:get();
                    end;
                end;
                if l_v706_0 ~= l_v656_0 then
                    l_v707_0.pitch = v403("AA", v712("szPitch"), v405.groups.aa.angles:combo("Pitch", {
                        [1] = "Disabled", 
                        [2] = "Down", 
                        [3] = "Fake Down", 
                        [4] = "Fake Up"
                    }));
                    l_v707_0.yaw = v403("AA", v712("szYaw"), v405.groups.aa.angles:combo("Yaw", {
                        [1] = "Disabled", 
                        [2] = "Backward", 
                        [3] = "Static"
                    }));
                    l_v707_0.pitch:set("Down");
                    l_v707_0.yaw:set("Backward");
                    local v714 = l_v707_0.yaw:create();
                    local function v715()
                        return l_v707_0.yaw:get() ~= "Disabled";
                    end;
                    l_v707_0.yaw_method = v403("AA", v712("szYawMethod"), v714:combo("Method", {
                        [1] = "180", 
                        [2] = "180LR", 
                        [3] = "Flick", 
                        [4] = "Sway"
                    })):depend(v715);
                    l_v707_0.yaw_offset = v403("AA", v712("iYawOffset"), v714:slider("Offset", -180, 180, 0, 1, "\194\176")):depend(v715);
                    l_v707_0.left_yaw = v403("AA", v712("iLeftYawOffset"), v714:slider("Left Offset", -180, 180, 0, 1, "\194\176")):depend(v715);
                    l_v707_0.right_yaw = v403("AA", v712("iRightYawOffset"), v714:slider("Right Offset", -180, 180, 0, 1, "\194\176")):depend(v715);
                    l_v707_0.from_degree = v403("AA", v712("iFromDegree"), v714:slider("From", -180, 180, 0, 1, "\194\176")):depend(v715);
                    l_v707_0.to_degree = v403("AA", v712("iToDegree"), v714:slider("To", -180, 180, 0, 1, "\194\176")):depend(v715);
                    l_v707_0.delay_degree = v403("AA", v712("iDelayDegree"), v714:slider("Delay", 1, 64, 1)):depend(v715);
                    l_v707_0.speed_degree = v403("AA", v712("iSpeedDegree"), v714:slider("Speed", 1, 64, 1)):depend(v715);
                    l_v707_0.pitch:depend(l_v710_0);
                    l_v707_0.yaw:depend(l_v710_0);
                    do
                        local l_v715_0 = v715;
                        l_v707_0.yaw_offset:depend(function()
                            return l_v715_0() and l_v707_0.yaw_method:get() == "180";
                        end);
                        local function v717()
                            return l_v715_0() and l_v707_0.yaw_method:get() == "180LR";
                        end;
                        local function v718()
                            return l_v710_0() and (l_v707_0.yaw_method:get() == "Flick" or l_v707_0.yaw_method:get() == "Sway");
                        end;
                        local function v719()
                            return l_v710_0() and l_v707_0.yaw_method:get() == "Sway";
                        end;
                        l_v707_0.left_yaw:depend(v717);
                        l_v707_0.right_yaw:depend(v717);
                        l_v707_0.from_degree:depend(v718);
                        l_v707_0.to_degree:depend(v718);
                        l_v707_0.delay_degree:depend(v718);
                        l_v707_0.speed_degree:depend(v719);
                    end;
                else
                    l_v707_0.yaw_method = v403("AA", v712("szYawMethod"), v405.groups.aa.angles:combo("Yaw Method", {
                        [1] = "180", 
                        [2] = "180LR", 
                        [3] = "Flick", 
                        [4] = "Sway"
                    }));
                    local v720 = l_v707_0.yaw_method:create();
                    l_v707_0.yaw_offset = v403("AA", v712("iYawOffset"), v720:slider("Yaw Offset", -180, 180, 0, 1, "\194\176"));
                    l_v707_0.left_yaw = v403("AA", v712("iLeftYawOffset"), v720:slider("Left Offset", -180, 180, 0, 1, "\194\176"));
                    l_v707_0.right_yaw = v403("AA", v712("iRightYawOffset"), v720:slider("Right Offset", -180, 180, 0, 1, "\194\176"));
                    l_v707_0.from_degree = v403("AA", v712("iFromDegree"), v720:slider("From", -180, 180, 0, 1, "\194\176"));
                    l_v707_0.to_degree = v403("AA", v712("iToDegree"), v720:slider("To", -180, 180, 0, 1, "\194\176"));
                    l_v707_0.delay_degree = v403("AA", v712("iDelayDegree"), v720:slider("Delay", 1, 64, 1));
                    l_v707_0.speed_degree = v403("AA", v712("iSpeedDegree"), v720:slider("Speed", 1, 64, 1));
                    l_v707_0.yaw_method:depend(l_v710_0);
                    l_v707_0.yaw_offset:depend(function()
                        return l_v710_0() and l_v707_0.yaw_method:get() == "180";
                    end);
                    local function v721()
                        return l_v710_0() and l_v707_0.yaw_method:get() == "180LR";
                    end;
                    local function v722()
                        return l_v710_0() and (l_v707_0.yaw_method:get() == "Flick" or l_v707_0.yaw_method:get() == "Sway");
                    end;
                    local function v723()
                        return l_v710_0() and l_v707_0.yaw_method:get() == "Sway";
                    end;
                    l_v707_0.left_yaw:depend(v721);
                    l_v707_0.right_yaw:depend(v721);
                    l_v707_0.from_degree:depend(v722);
                    l_v707_0.to_degree:depend(v722);
                    l_v707_0.delay_degree:depend(v722);
                    l_v707_0.speed_degree:depend(v723);
                end;
                v506(l_v707_0, v405.groups.aa.angles, v712("%s"), l_v710_0);
                l_v707_0.body_yaw = v403("AA", v712("bBodyYaw"), v405.groups.aa.angles:switch("Body Yaw"));
                l_v707_0.body_yaw:depend(l_v710_0);
                local v724 = l_v707_0.body_yaw:create();
                l_v707_0.left_limit = v403("AA", v712("iLeftLimit"), v724:slider("Left Limit", 0, l_v654_0, l_v654_0, 1, "\194\176")):depend(l_v707_0.body_yaw);
                l_v707_0.right_limit = v403("AA", v712("iRightLimit"), v724:slider("Right Limit", 0, l_v654_0, l_v654_0, 1, "\194\176")):depend(l_v707_0.body_yaw);
                l_v707_0.options = v403("AA", v712("szOptions"), v724:selectable("Body Yaw", {
                    [1] = "Avoid Overlap", 
                    [2] = "Jitter", 
                    [3] = "Randomize Jitter"
                })):depend(l_v707_0.body_yaw);
                l_v707_0.freestanding_desync = v403("AA", v712("szFreestandingDesync"), v724:combo("Freestanding", {
                    [1] = "Off", 
                    [2] = "Peek Fake", 
                    [3] = "Peek Real"
                })):depend(l_v707_0.body_yaw);
                if l_v706_0 ~= l_v656_0 then
                    local function v726(v725)
                        return l_format_0("Antibrute[%s].%s", l_v706_0, v725);
                    end;
                    local v727 = {
                        master = v403("AA", v726("bMaster"), v405.groups.aa.angles:switch("Anti-bruteforce"))
                    };
                    local v728 = v727.master:create();
                    v727.count = v403("AA", v726("iCount"), v728:slider("Count", l_v662_0.min, l_v662_0.max)):depend(v727.master);
                    v727.count:depend(function()
                        return false;
                    end);
                    v727.stage = v403("AA", v726("szStage"), v728:combo("Stage")):depend(v727.master);
                    local v729 = {};
                    do
                        local l_v727_0, l_v729_0 = v727, v729;
                        local function v733(v732)
                            if not (v732 >= l_v662_0.min) or l_v662_0.max < v732 then
                                return ;
                            else
                                while v732 < #l_v729_0 do
                                    l_remove_0(l_v729_0);
                                end;
                                while #l_v729_0 < v732 do
                                    l_insert_0(l_v729_0, tostring(#l_v729_0 + 1));
                                end;
                                l_v727_0.count:set(#l_v729_0);
                                l_v727_0.stage:update(l_v729_0);
                                l_v727_0.stage:set(tostring(#l_v729_0));
                                return l_v729_0;
                            end;
                        end;
                        v733(l_v727_0.count:get());
                        l_v727_0.add = v403("AA", v726("salam"), v728:button("+", function()
                            return v733(l_v727_0.count:get() + 1);
                        end)):depend(l_v727_0.master);
                        l_v727_0.remove = v403("AA", v726("byvai"), v728:button("-", function()
                            return v733(l_v727_0.count:get() - 1);
                        end)):depend(l_v727_0.master);
                        for v734 = 1, l_v662_0.max do
                            do
                                local l_v734_0 = v734;
                                local function v737(v736)
                                    return l_format_0("Antibrute[%s][%d].%s", l_v706_0, l_v734_0, v736);
                                end;
                                local function v738()
                                    return tonumber(l_v727_0.stage:get()) == l_v734_0;
                                end;
                                local v739 = {
                                    left_limit = v403("AA", v737("iLeftLimit"), v728:slider("Left Limit", 0, l_v654_0, l_v654_0, 1, "\194\176")):depend(l_v727_0.master), 
                                    right_limit = v403("AA", v737("iRightLimit"), v728:slider("Right Limit", 0, l_v654_0, l_v654_0, 1, "\194\176")):depend(l_v727_0.master), 
                                    modifier_offset = v403("AA", v737("iYawModifier"), v728:slider("Modifier Offset", -180, 180, 0, 1, "\194\176")):depend(l_v727_0.master)
                                };
                                v739.left_limit:depend(v738);
                                v739.right_limit:depend(v738);
                                v739.modifier_offset:depend(v738);
                                l_v727_0[l_v734_0] = v739;
                            end;
                        end;
                        l_v727_0.master:depend(l_v710_0);
                        l_v662_0[l_v706_0] = l_v727_0;
                    end;
                end;
                l_v661_0[l_v706_0] = l_v707_0;
            end;
        end;
        l_v661_0.warning = v403("AA", "txtXWay", v405.groups.aa.angles:label(l_format_0("\affff00ff%s  X-Way not working with anti-bruteforce", v398["exclamation-triangle"])));
        l_v661_0.warning:depend(function()
            local v740 = l_v661_0.state:get();
            if not (v704() and l_v662_0[v740] ~= nil) or not l_v662_0[v740].master:get() then
                return false;
            else
                local v741 = l_v661_0[v740];
                if not (not (v741.override ~= nil) or v741.override:get()) or not v741.yaw_modifier:get():match("(%d)-Way") then
                    return false;
                else
                    return true;
                end;
            end;
        end);
        l_v665_0.controller = v403("AA", "szManualYaw", v405.groups.aa.main:combo("Manual Yaw"));
        l_v665_0.directions = v405:combo_control(l_v665_0.controller, {
            [1] = "Disabled"
        });
        l_v665_0.directions.Forward = 180;
        l_v665_0.directions.Backward = 0;
        l_v665_0.directions.Left = -90;
        l_v665_0.directions.Right = 90;
        l_v667_0.controller = v403("AA", "szDisablers", v405.groups.aa.main:selectable("Static Sideways", {
            [1] = "Freestanding", 
            [2] = "Manuals"
        }));
        l_v667_0.static = function(_)
            v395.antiaim.angles.yaw_modifier:override("Disabled");
            v395.antiaim.angles.options:override({});
            v408.yaw_modifier = 0;
            v408:set_yaw_offset(v408.yaw);
        end;
        l_v663_0.controller = v403("AA", "bShitPreset", v405.groups.aa.main:switch("Shit Preset on Warmup"));
        l_v663_0.controller:tooltip("Sets randomized anti-aim for breaking enemy's resolver");
        l_v663_0.list = {
            yaw_base = "At Target", 
            yaw = "Backward", 
            left_limit = 20, 
            pitch = "Down", 
            right_limit = 33, 
            right_yaw = 15, 
            freestanding_desync = "Peek Fake", 
            body_yaw = true, 
            modifier_offset = 50, 
            antibrute_length = 0, 
            yaw_modifier = "Random", 
            left_yaw = -23, 
            yaw_method = "180LR", 
            options = {
                [1] = "Jitter", 
                [2] = "Randomize Jitter"
            }
        };
        l_v663_0.update = function(v743)
            local v744 = entity.get_game_rules();
            if not (v744 ~= nil and v744.m_bWarmupPeriod) or not v743.controller:get() then
                return ;
            else
                v408:set(v743.list);
                return ;
            end;
        end;
        l_v664_0.controller = v403("AA", "bEdgeYaw", v405.groups.aa.main:switch("Edge Yaw"));
        l_v664_0.mode = v403("AA", "szEdgeYaw", l_v664_0.controller:create():combo("Mode", {
            [1] = "Eye Based", 
            [2] = "Static"
        })):depend(l_v664_0.controller);
        l_v659_0.controller = v403("AA", "bAllowAAonUse", v405.groups.aa.main:switch("Allow Anti-Aim on Use"));
        local v745 = l_v659_0.controller:create();
        l_v659_0.warning = v403("AA", "txtAllowAAonUse", v405.groups.aa.main:label(l_format_0("\affff00ff%s  Anti-Aim on Use is using cheat-based settings", v398["exclamation-triangle"])));
        l_v659_0.warning:depend(function()
            if not ((l_v659_0.controller:get() and l_v659_0.mode:get() ~= "Fake Jitter Peek") and l_v660_0.controller:get() == "Custom") or l_v661_0[l_v656_0].override:get() then
                return false;
            else
                return true;
            end;
        end);
        l_v659_0.mode = v403("AA", "szAllowAAonUse", v745:combo("Mode")):depend(l_v659_0.controller);
        l_v659_0.container = v405:combo_control(l_v659_0.mode);
        l_v659_0.container.Default = function()
            if l_v660_0.controller:get() == "Custom" then
                l_v660_0.container.Custom(l_v656_0);
            end;
        end;
        l_v659_0.container["Fake Jitter Peek"] = function()
            v408:set({
                options = "Anti Bruteforce", 
                yaw_modifier = "Center", 
                freestanding_desync = "Peek Fake", 
                body_yaw = true, 
                modifier_offset = 60, 
                right_yaw = 0, 
                left_yaw = 30, 
                yaw_method = "180LR", 
                inverter = v408:get_inverter_state(), 
                left_limit = l_v654_0, 
                right_limit = l_v654_0
            });
        end;
        l_v666_0.active = false;
        l_v666_0.controller = v403("AA", "bFreestanding", v405.groups.aa.main:switch("Freestanding"));
        l_v666_0.update = function(_)
            if l_v665_0.controller:get() ~= "Disabled" then
                l_v666_0.active = false;
                return ;
            else
                l_v666_0.active = l_v666_0.controller:get();
                l_v632_1.freestanding:override(l_v666_0.active);
                if (l_v666_0.active and l_v667_0.controller:get("Freestanding")) and rage.antiaim:get_target(true) then
                    l_v667_0:static();
                end;
                return ;
            end;
        end;
        l_v668_0.controller = v403("AA", "bAnimBreaker", v405.groups.aa.main:switch("\aB6B665FFAnimation Fix Breaker"));
        local v747 = l_v668_0.controller:create();
        l_v668_0.air = v403("AA", "bAnimBreaker.szAir", v747:combo("In Air", {
            [1] = "Disabled", 
            [2] = "Frozen", 
            [3] = "Michael Jackson"
        })):depend(l_v668_0.controller);
        l_v668_0.leg_movement = v403("AA", "bAnimBreaker.szLegMovement", v747:combo("Leg Movement", {
            [1] = "Disabled", 
            [2] = "Frozen", 
            [3] = "Michael Jackson", 
            [4] = "Sliding"
        })):depend(l_v668_0.controller);
        l_v668_0.pitch_zero_on_land = v403("AA", "bAnimBreaker.bPitchZeroOnLand", v747:switch("Pitch 0 on Land")):depend(l_v668_0.controller);
        l_v668_0.sliding_slowwalk = v403("AA", "bAnimBreaker.bSlidingSlowWalk", v747:switch("Sliding Slow Walk")):depend(l_v668_0.controller);
        l_v668_0.sliding_crouch = v403("AA", "bAnimBreaker.bSlidingCrouch", v747:switch("Sliding Crouch")):depend(l_v668_0.controller);
        local v748 = ffi.cast("void(__fastcall*)(void*, void*)", (l_opcode_scan_0("client.dll", "8B F1 80 BE ? ? ? ? ? 74 36", -5)));
        l_v668_0.states = {
            landing = false, 
            slow_walk = false, 
            move = false, 
            crouch = false, 
            air = false
        };
        l_v668_0.activate = function(v749, _)
            if not v749.controller:get() then
                return ;
            else
                local v751 = l_get_local_player_0();
                if not v751 or not v751:is_alive() then
                    return ;
                else
                    v749.states.landing = v751:get_anim_state().landing and v407.onground;
                    v749.states.slow_walk = v407.state == "Slow-motion";
                    v749.states.move = v407.state == "Move";
                    v749.states.air = not v407.onground;
                    v749.states.crouch = v407.onground and v407.crouch;
                    return ;
                end;
            end;
        end;
        l_memory_0.hook_func(v748, function(v752, v753, v754)
            if not l_v668_0.controller:get() then
                v395.antiaim.misc.leg_movement:override();
                return v752:get_original(v753, v754);
            else
                v752:get_original(v753, v754);
                local v755 = l_get_local_player_0();
                if not (v755 ~= nil) or v753 == nil then
                    return ;
                else
                    local v756 = l_get_0(v753);
                    if v756 == v755 then
                        local v757 = ffi.cast("uintptr_t", v756[0]);
                        local v758 = ffi.cast("float*", v757 + 10104);
                        local v759 = ffi.cast("CAnimationLayer**", v757 + 10640)[0];
                        local v760 = l_v668_0.air:get();
                        local v761 = l_v668_0.leg_movement:get();
                        if l_v668_0.states.air then
                            if v760 == "Frozen" then
                                v758[6] = 1;
                            elseif v760 == "Michael Jackson" then
                                v759[6].m_flWeight = 1;
                            end;
                        end;
                        if l_v668_0.states.move then
                            if v761 == "Frozen" then
                                v758[0] = 0;
                                v395.antiaim.misc.leg_movement:override("Sliding");
                            elseif v761 == "Michael Jackson" then
                                v758[7] = 1;
                                v395.antiaim.misc.leg_movement:override("Walking");
                            elseif v761 == "Sliding" then
                                v758[9] = 0;
                                v758[10] = 0;
                                v395.antiaim.misc.leg_movement:override("Walking");
                            end;
                        end;
                        if l_v668_0.states.slow_walk and l_v668_0.sliding_slowwalk:get() then
                            v758[9] = 0;
                        end;
                        if l_v668_0.pitch_zero_on_land:get() and l_v668_0.states.landing then
                            v758[12] = 0.5;
                        end;
                        if l_v668_0.states.crouch and l_v668_0.sliding_crouch:get() then
                            v758[8] = 0;
                        end;
                    end;
                    return ;
                end;
            end;
        end);
        local function v762(...)
            return ("Defensive_%s"):format(...);
        end;
        v551.increase = 0;
        v551.increasing = false;
        v551.controller = v403("AA", "bDefensiveAA", v405.groups.aa.main:switch("Defensive AA"));
        v551.group = v405.groups.aa.defensive_angles;
        v551.disable_states = v403("AA", v762("scDisableStates"), v405.groups.aa.defensive_angles:selectable("Disable while", {
            [1] = "Stand", 
            [2] = "Move", 
            [3] = "Slow-motion", 
            [4] = "Crouch", 
            [5] = "Air", 
            [6] = "Air+", 
            [7] = "Manual Yaw"
        })):depend(v551.controller);
        v551.randomize_ticks = v403("AA", "bDefensiveAA.RandomizeTicks", v551.group:switch("Randomize Ticks")):depend(v551.controller);
        v551.pitch = v403("AA", v762("szPitch"), v405.groups.aa.defensive_angles:combo("Pitch", {
            [1] = "Down", 
            [2] = "Up", 
            [3] = "Custom", 
            [4] = "Random", 
            [5] = "Increase"
        })):depend(function()
            return v551.controller:get();
        end);
        v551.pitch_group = v551.pitch:create();
        v551.pitch_value = v403("AA", v762("iPitchValue"), v551.pitch_group:slider("Pitch", -89, 89, 89, 1, "\194\176")):depend(function()
            return v551.controller:get() and v551.pitch:get() == "Custom";
        end);
        v551.yaw = v403("AA", v762("szYaw"), v405.groups.aa.defensive_angles:combo("Yaw", {
            [1] = "Default", 
            [2] = "180", 
            [3] = "Opposite", 
            [4] = "Random"
        })):depend(function()
            return v551.controller:get();
        end);
        v551.yaw_group = v551.yaw:create();
        v551.yaw_value = v403("AA", v762("iYawValue"), v551.yaw_group:slider("Yaw", -180, 180, 0, 1, "\194\176")):depend(function()
            return v551.controller:get() and v551.yaw:get() == "180";
        end);
        v551.pitch_values = {
            Up = -89, 
            Down = 89
        };
        v551.random = {
            [1] = -89, 
            [2] = 89
        };
        v551.rand = 1;
        v551.update = function(v763, _)
            if l_get_local_player_0() == nil then
                return ;
            elseif v763.disable_states:get("Manual Yaw") and l_v665_0.controller:get() ~= "Disabled" then
                return ;
            elseif v763.disable_states:get(v407.state) then
                return ;
            elseif v763.randomize_ticks:get() and utils.random_int(1, 10) <= 5 then
                return ;
            else
                v395.antiaim.angles.hidden:override(v763.controller:get());
                if not v763.controller:get() then
                    return ;
                else
                    local v765 = nil;
                    local v766 = nil;
                    local v767 = v763.pitch:get();
                    if v763.yaw:get() ~= "Default" then
                        if v763.yaw:get() == "180" then
                            v765 = v763.yaw_value:get();
                        elseif v763.yaw:get() == "Random" then
                            v765 = utils.random_int(-180, 180);
                        elseif v763.yaw:get() == "Opposite" then
                            v765 = 180;
                        end;
                    end;
                    v766 = v763.pitch_values[v767];
                    if v766 == nil then
                        if v767 == "Random" then
                            v766 = v763.random[v763.rand];
                        elseif v767 == "Custom" then
                            v766 = v763.pitch_value:get();
                        elseif v767 == "Increase" then
                            v766 = v444(v763.increase, -89, 89);
                        end;
                    end;
                    if v765 ~= nil then
                        rage.antiaim:override_hidden_yaw_offset(v765);
                    end;
                    if v766 ~= nil then
                        rage.antiaim:override_hidden_pitch(v766);
                    end;
                    return ;
                end;
            end;
        end;
        l_v662_0.reset = function(v768)
            v768.time = -1;
            v768.stage = 0;
        end;
        l_v662_0.get = function(v769)
            local v770 = v769.time - globals.realtime;
            if v770 < 0 then
                return 0;
            else
                return v770 / v769.delay;
            end;
        end;
        l_v662_0.bullet_impact = function(v771, v772)
            if l_v660_0.controller:get() == "Disabled" then
                return ;
            else
                local v773 = l_get_local_player_0();
                local v774 = l_get_0(v772.userid, true);
                if not ((v773 and v773:is_alive()) and v774) or not v774:is_enemy() then
                    return ;
                else
                    local l_tickcount_0 = globals.tickcount;
                    if l_tickcount_0 == v771.tick then
                        return ;
                    else
                        local v776 = v773:get_eye_position();
                        if v776:closest_ray_point(v774:get_eye_position(), (vector(v772.x, v772.y, v772.z))):dist(v776) > 45 then
                            return ;
                        else
                            if v771:get() == 0 then
                                v771.stage = 0;
                            end;
                            v771.tick = l_tickcount_0;
                            v771.time = globals.realtime + v771.delay;
                            v771.stage = v771.stage + 1;
                            v771.target = v772.userid;
                            return ;
                        end;
                    end;
                end;
            end;
        end;
        l_v662_0.player_death = function(v777, v778, v779, v780)
            if v777:get() == 0 then
                return ;
            elseif not (v778.userid ~= v777.target) or v780 == v779 then
                v426:antibrute_reseted(v778);
                return v777:reset();
            else
                return ;
            end;
        end;
        l_v665_0.update = function(v781, _)
            local v783 = v781.directions[v781.controller:get()];
            if v783 == nil then
                return ;
            else
                local v784 = v408.yaw + v783;
                if l_v667_0.controller:get("Manuals") then
                    v784 = v783;
                    l_v667_0:static();
                end;
                v408:local_view();
                v408:set_yaw_offset(v784);
                return ;
            end;
        end;
        l_v659_0.is_invalid_check = function(v785, v786, v787)
            local l_m_iTeamNum_0 = v787.m_iTeamNum;
            if l_m_iTeamNum_0 == 2 then
                if not v787.m_bInBombZone or globals.curtime < v787.m_flNextAttack then
                    return ;
                else
                    local v789 = v787:get_player_weapon();
                    if v789 == nil then
                        return ;
                    elseif v789:get_classname() ~= "CC4" then
                        return ;
                    else
                        return true;
                    end;
                end;
            elseif l_m_iTeamNum_0 == 3 then
                local v790 = l_get_entities_0("CPlantedC4")[1];
                if v790 == nil then
                    return ;
                else
                    local v791 = v787:get_eye_position();
                    local v792 = v790:get_origin();
                    local v793 = 87.5;
                    local v794 = v792:dist(v791);
                    if v787.m_flDuckAmount == 1 then
                        v793 = v793 - 25;
                    end;
                    if v793 < v794 then
                        return ;
                    else
                        return true;
                    end;
                end;
            else
                local l_pressed_0 = v785.pressed;
                v785.pressed = true;
                local v796 = v787:get_eye_position();
                local l_entity_0 = l_trace_line_0(v796, v796 + vector():angles(v786.view_angles) * 128, v787, 1174421515).entity;
                if l_entity_0 == nil then
                    return ;
                else
                    local v798 = l_entity_0:get_classname();
                    if v798 == "CHostage" then
                        return true;
                    elseif l_pressed_0 then
                        return ;
                    elseif v785.valid_entities[v798] then
                        return ;
                    else
                        return true;
                    end;
                end;
            end;
        end;
        l_v659_0.is_invalid_trace = function(v799, v800, v801)
            local l_pressed_1 = v799.pressed;
            v799.pressed = true;
            local v803 = v801:get_eye_position();
            local l_entity_1 = l_trace_line_0(v803, v803 + vector():angles(v800.view_angles) * 128, v801, 1174421515).entity;
            if l_entity_1 == nil then
                return ;
            else
                local v805 = l_entity_1:get_classname();
                if v805 == "CHostage" then
                    return true;
                elseif l_pressed_1 then
                    return ;
                elseif v799.valid_entities[v805] then
                    return ;
                else
                    return true;
                end;
            end;
        end;
        l_v659_0.update = function(v806, v807)
            if not v806.controller:get() then
                return ;
            else
                local v808 = v806.container[v806.mode:get()];
                if type(v808) == "function" then
                    v808();
                end;
                local v809 = l_get_local_player_0();
                if v806:is_invalid_check(v807, v809) or v806:is_invalid_trace(v807, v809) then
                    return ;
                else
                    v807.in_use = false;
                    v408:local_view();
                    l_v632_1.pitch:override("Disabled");
                    v408:set_yaw_offset(v408.yaw + 180);
                    return ;
                end;
            end;
        end;
        v408.shutdown = function(_)
            for _, v812 in pairs(l_v632_1) do
                v812:override();
            end;
        end;
        v408.get_inverter_state = function(_)
            return v407.body_yaw > 0;
        end;
        v408.determine_yaw = function(v814, v815, v816)
            return v814:get_inverter_state() and v815 or v816;
        end;
        v408.flick_yaw = function(_, v818, v819, v820)
            return v278:flick(0, v818, v819, v820);
        end;
        v408.sway_yaw = function(_, v822, v823, v824, v825)
            return v294:sway(v407.state, v822, v823, v824, v825);
        end;
        v408.set_yaw_offset = function(v826, v827)
            v826.yaw = l_normalize_yaw_0(v826.yaw_modifier + v827);
            l_v632_1.yaw_offset:override(v826.yaw);
        end;
        v408.local_view = function(_)
            l_v632_1.yaw_base:override("Local View");
            l_v632_1.freestanding:override(false);
        end;
        v408.x_way = function(v829, v830, v831)
            local v832 = v407.packets % v831;
            if v830.x_ways ~= nil and v830.x_way_method == "Custom" then
                v829.yaw_modifier = v830.x_ways[v832 + 1] or 0;
            elseif v830.modifier_offset == nil then
                return ;
            else
                local l_modifier_offset_0 = v830.modifier_offset;
                if v830.randomize_offset ~= nil then
                    if v830.modifier_offset > 0 then
                        l_modifier_offset_0 = utils.random_int(v444(v830.modifier_offset, -180, 180), v444(v830.modifier_offset + v830.randomize_offset, -180, 180));
                    else
                        l_modifier_offset_0 = utils.random_int(v444(v830.modifier_offset, -180, 180), v444(v830.modifier_offset - v830.randomize_offset, -180, 180));
                    end;
                end;
                local v834 = v438(v831 * 0.5);
                if v832 ~= v834 then
                    local v835 = (v832 - v834) / v834;
                    local v836 = l_modifier_offset_0 * v835;
                    if (v830.yaw_method == "180LR" and v830.left_yaw ~= nil) and v830.right_yaw ~= nil then
                        local v837 = v835 > 0;
                        local v838 = not v837 and v830.left_yaw or v830.right_yaw;
                        v829.yaw = 0;
                        v836 = v836 + v838 * l_abs_0(v835);
                        v395.antiaim.angles.inverter:override(v837);
                    end;
                    v829.yaw_modifier = l_normalize_yaw_0(v829.yaw_modifier + v440(v836));
                else
                    v829.yaw_modifier = 0;
                end;
            end;
            v829:set_yaw_offset(v829.yaw);
            l_v632_1.yaw_modifier:override("Disabled");
        end;
        v408.set = function(v839, v840)
            l_v670_0(l_v632_1.pitch, v840.pitch);
            l_v670_0(l_v632_1.yaw, v840.yaw);
            l_v670_0(l_v632_1.yaw_base, v840.yaw_base);
            l_v670_0(l_v632_1.body_yaw, v840.body_yaw);
            l_v670_0(l_v632_1.inverter, v840.inverter);
            l_v670_0(l_v632_1.left_limit, v840.left_limit);
            l_v670_0(l_v632_1.right_limit, v840.right_limit);
            l_v670_0(l_v632_1.options, v840.options);
            l_v670_0(l_v632_1.freestanding_desync, v840.freestanding_desync);
            if v840.yaw_method ~= nil then
                if v840.yaw_method == "180" and v840.yaw_offset ~= nil then
                    v839:set_yaw_offset(v840.yaw_offset);
                end;
                if (v840.yaw_method == "180LR" and v840.left_yaw ~= nil) and v840.right_yaw ~= nil then
                    v839:set_yaw_offset(v839:determine_yaw(v840.left_yaw, v840.right_yaw));
                end;
                if ((v840.yaw_method == "Flick" and v840.from_degree ~= nil) and v840.to_degree ~= nil) and v840.delay_degree ~= nil then
                    v839:set_yaw_offset(v839:flick_yaw(v840.from_degree, v840.to_degree, v840.delay_degree));
                end;
                if (((v840.yaw_method == "Sway" and v840.from_degree ~= nil) and v840.to_degree ~= nil) and v840.speed_degree ~= nil) and v840.delay_degree ~= nil then
                    v839:set_yaw_offset(v839:sway_yaw(v840.from_degree, v840.to_degree, v840.delay_degree, v840.speed_degree));
                end;
            end;
            local l_modifier_offset_1 = v840.modifier_offset;
            if v840.randomize_offset ~= nil then
                local l_randomize_offset_0 = v840.randomize_offset;
                if v840.modifier_offset ~= nil then
                    if v840.modifier_offset > 0 then
                        v840.modifier_offset = utils.random_int(v444(v840.modifier_offset, -180, 180), v444(v840.modifier_offset + l_randomize_offset_0, -180, 180));
                    else
                        v840.modifier_offset = utils.random_int(v444(v840.modifier_offset, -180, 180), v444(v840.modifier_offset - l_randomize_offset_0, -180, 180));
                    end;
                end;
            end;
            if v840.yaw_modifier ~= nil then
                if v840.yaw_modifier == "X-Way" and v840.x_way_count ~= nil then
                    v839:x_way(v840, v840.x_way_count);
                else
                    l_v632_1.yaw_modifier:override(v840.yaw_modifier);
                    if v840.modifier_offset ~= nil then
                        l_v632_1.modifier_offset:override(v840.modifier_offset);
                    end;
                end;
            end;
            v840.modifier_offset = l_modifier_offset_1;
            if l_v662_0:get() ~= 0 and v840.antibrute ~= nil then
                local l_antibrute_length_0 = v840.antibrute_length;
                if not (l_antibrute_length_0 == 0) then
                    local v844 = (l_v662_0.stage - 1) % l_antibrute_length_0 + 1;
                    v839:set(v840.antibrute[v844]);
                    l_v662_0.current = v844;
                end;
            end;
        end;
        v408.builder = function(v845, v846)
            local v847 = l_v661_0[v846];
            local v848 = l_v662_0[v846];
            if (not (v847 ~= nil) or not v847.override:get()) and v846 == "Fake Lag" then
                v846 = v407:get_state(nil, nil, true);
                local v849 = l_v661_0[v846];
                v848 = l_v662_0[v846];
                v847 = v849;
            end;
            if not (v847 ~= nil) or not v847.override:get() then
                if v846 == l_v656_0 then
                    return ;
                else
                    v847 = l_v661_0[l_v655_0];
                    v848 = l_v662_0[l_v655_0];
                    if v847 == nil then
                        return ;
                    end;
                end;
            end;
            local v850 = {};
            if v847.pitch ~= nil then
                v850.pitch = v847.pitch:get();
                v850.yaw = v847.yaw:get();
            end;
            v850.yaw_method = v847.yaw_method:get();
            v850.yaw_offset = v847.yaw_offset:get();
            v850.left_yaw = v847.left_yaw:get();
            v850.right_yaw = v847.right_yaw:get();
            v850.yaw_modifier = v847.yaw_modifier:get();
            v850.randomize_offset = v847.randomize_offset:get();
            v850.modifier_offset = v847.modifier_offset:get();
            v850.from_degree = v847.from_degree:get();
            v850.to_degree = v847.to_degree:get();
            v850.speed_degree = v847.speed_degree:get();
            v850.delay_degree = v847.delay_degree:get();
            v850.x_way_count = v847.x_way_count:get();
            v850.x_way_method = v847.x_way:get();
            v850.x_ways = {};
            for v851 = 1, v847.x_way_count:get() do
                local v852 = v847.way[v851]:get();
                if v850.randomize_offset ~= nil then
                    if v852 > 0 then
                        v852 = utils.random_int(v444(v852, -180, 180), v444(v852 + v850.randomize_offset, -180, 180));
                    else
                        v852 = utils.random_int(v444(v852, -180, 180), v444(v852 - v850.randomize_offset, -180, 180));
                    end;
                end;
                v850.x_ways[v851] = v852;
            end;
            v850.body_yaw = v847.body_yaw:get();
            v850.left_limit = v847.left_limit:get();
            v850.right_limit = v847.right_limit:get();
            v850.options = v847.options:get();
            v850.freestanding_desync = v847.freestanding_desync:get();
            if v848 ~= nil and v848.master:get() then
                local v853 = {};
                for v854 = 1, v848.count:get() do
                    local v855 = v848[v854];
                    local v856 = {
                        left_limit = v855.left_limit:get(), 
                        right_limit = v855.right_limit:get()
                    };
                    if v850.yaw_modifier:match("(%d)-Way") then

                    end;
                    v856.yaw_modifier = v850.yaw_modifier;
                    v856.modifier_offset = v855.modifier_offset:get();
                    v853[v854] = v856;
                end;
                v850.antibrute = v853;
                v850.antibrute_length = v848.count:get();
            end;
            v845:set(v850);
        end;
        v408.modify = function(v857, _)
            local l_state_0 = v407.state;
            local v860 = l_v660_0.container[l_v660_0.controller:get()];
            if v860 == nil then
                return ;
            elseif type(v860) == "function" then
                return v860(l_state_0);
            elseif v468() then
                return ;
            else
                local v861 = v860[l_state_0];
                if v861 == nil and l_state_0 == "Fake Lag" then
                    v861 = v860[v407:get_state(nil, nil, true)];
                end;
                if v861 == nil then
                    v861 = v860[l_v655_0];
                    if v861 == nil then
                        return ;
                    end;
                end;
                v857:set(v861);
                return ;
            end;
        end;
        l_v664_0.update = function(v862, v863)
            if l_v666_0.active and rage.antiaim:get_target(true) then
                return ;
            elseif not v862.controller:get() then
                return ;
            else
                local v864 = l_get_local_player_0();
                if not (v864 ~= nil) or not v407.onground then
                    return ;
                else
                    local v865 = {};
                    local v866 = v864:get_eye_position();
                    for v867 = 18, 360, 18 do
                        local v868 = l_trace_line_0(v866, v866 + vector():angles(0, (l_normalize_yaw_0(v867))) * 28, v864, 33570827);
                        local l_entity_2 = v868.entity;
                        if not (not (v868.fraction ~= 1 and l_entity_2 ~= nil) or l_entity_2:get_classname() ~= "CWorld") then
                            v865[#v865 + 1] = v868.end_pos;
                        end;
                    end;
                    local v870 = #v865;
                    if v870 < 2 then
                        return ;
                    else
                        local v871 = l_normalize_yaw_0(-v863.view_angles.y + (v866 - v865[1]:lerp(v865[v870], 0.5)):angles().y);
                        if l_abs_0(v871) < 90 then
                            return ;
                        else
                            if v862.mode:get() == "Eye Based" then
                                v871 = v871 * 2 + 180;
                            end;
                            l_v632_1.yaw_modifier:override("Disabled");
                            l_v632_1.yaw_offset:override(l_normalize_yaw_0(v871));
                            l_v632_1.yaw_base:override("Local View");
                            return ;
                        end;
                    end;
                end;
            end;
        end;
        v408.pre = function(v872, v873)
            v872.yaw = 0;
            v872.yaw_modifier = 0;
            v872:shutdown();
            l_v668_0:activate(v873);
        end;
        v408.post = function(v874, v875)
            if v407.using then
                return l_v659_0:update(v875);
            else
                l_v659_0.pressed = false;
                v874:modify(v875);
                l_v663_0:update();
                l_v666_0:update();
                l_v664_0:update(v875);
                l_v665_0:update(v875);
                v551:update(v875);
                return ;
            end;
        end;
        v408.player_connect_full = function(_, _)

        end;
        v408.createmove = function(v878, v879)
            v878:pre(v879);
            v878:post(v879);
        end;
    end;
    v632 = 1;
    v654 = cvar.cl_interp;
    v655 = cvar.cl_interp_ratio;
    v656 = cvar.cl_updaterate;
    v657 = ffi.new("float[1]");
    v658 = ffi.new("float[1]");
    v659 = ffi.new("float[1]");
    v660 = ffi.typeof("void***");
    v661 = ffi.typeof("bool(__thiscall*)(void*)");
    v662 = ffi.typeof("bool(__thiscall*)(void*, int, int)");
    v663 = ffi.typeof("float(__thiscall*)(void*, int)");
    v664 = ffi.typeof("int(__thiscall*)(void*, int)");
    v665 = ffi.typeof("void(__thiscall*)(void*, float*, float*, float*)");
    v667 = l_cast_0(v660, utils.create_interface("engine.dll", "VEngineClient014") or error("VEngineClient014 wasnt found", 2)) or error("rawivengineclient is nil", 2);
    v668 = l_cast_0("void*(__thiscall*)(void*)", v667[0][78]) or error("ivengineclient is nil");
    v670 = 1;
    local v880 = render.load_image_rgba("\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255k\255\255\255\252\255\255\255\253\255\255\255o\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255<\255\255\255\255\255\255\255j\255\255\255p\255\255\255\255\255\255\255@\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\202\255\255\255\161\255\255\255\000\255\255\255\000\255\255\255\182\255\255\255\206\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255M\255\255\255\252\255\255\255 \255\255\255\000\255\255\255\000\255\255\2551\255\255\255\255\255\255\255P\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\216\255\255\255\148\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\170\255\255\255\220\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255^\255\255\255\247\255\255\255\021\255\255\255\000\255\255\255R\255\255\255V\255\255\255\000\255\255\255$\255\255\255\255\255\255\255a\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\229\255\255\255\131\255\255\255\000\255\255\255\000\255\255\255\218\255\255\255\227\255\255\255\000\255\255\255\000\255\255\255\153\255\255\255\233\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255p\255\255\255\240\255\255\255\n\255\255\255\000\255\255\255\000\255\255\255\209\255\255\255\217\255\255\255\000\255\255\255\000\255\255\255\023\255\255\255\254\255\255\255s\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\t\255\255\255\239\255\255\255r\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\134\255\255\255\244\255\255\255\v\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\130\255\255\255\231\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\f\255\255\255\245\255\255\255\132\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\019\255\255\255\248\255\255\255a\255\255\255\000\255\255\255\004\255\255\255\000\255\255\255\000\255\255\255\210\255\255\255\219\255\255\255\000\255\255\255\000\255\255\255\004\255\255\255\000\255\255\255s\255\255\255\254\255\255\255\022\255\255\255\000\255\255\255\001\255\255\255\003\255\255\255\000\255\255\255\148\255\255\255\219\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\208\255\255\255\216\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\003\255\255\255\233\255\255\255\151\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\031\255\255\255\254\255\255\255Q\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\224\255\255\255\233\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255a\255\255\255\255\255\255\255\"\255\255\255\000\255\255\255\000\255\255\255\166\255\255\255\205\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255m\255\255\255r\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\220\255\255\255\169\255\255\255\000\255\255\255-\255\255\255\255\255\255\255A\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255}\255\255\255\130\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\003\255\255\255\000\255\255\255O\255\255\255\255\255\255\2550\255\255\255\188\255\255\255\188\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\167\255\255\255\174\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\204\255\255\255\187\255\255\255\255\255\255\255>\255\255\255\000\255\255\255\001\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\000\255\255\255\002\255\255\255\000\255\255\255@\255\255\255\247\255\255\255\224\255\255\255}\255\255\255\000\255\255\255\a\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\004\255\255\255\006\255\255\255\000\255\255\255\138\255\255\255\220\255\255\255?\255\255\255\231\255\255\255\228\255\255\255\225\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\227\255\255\255\227\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\226\255\255\255\225\255\255\255\229\255\255\255\240\255\255\255C", vector(20, 19));
    local function v882(v881)
        if v881 < 40 then
            return color(255, 255, 255);
        elseif v881 < 100 then
            return color(255, 125, 95);
        else
            return color(255, 60, 80);
        end;
    end;
    do
        local l_v632_2, l_v655_1, l_v656_1, l_v657_0, l_v658_0, l_v659_1, l_v661_1, l_v662_1, l_v663_1, l_v664_1, l_v665_1, l_v667_1, l_v668_1, l_v670_1, l_v880_0, l_v882_0 = v632, v655, v656, v657, v658, v659, v661, v662, v663, v664, v665, v667, v668, v670, v880, v882;
        local function v903(v899)
            if v899 == nil then
                return ;
            else
                local v900 = l_cast_0(l_v664_1, v899[0][17])(v899, 1);
                return {
                    seqNr_out = v900, 
                    is_loopback = l_cast_0(l_v661_1, v899[0][6])(v899), 
                    is_timing_out = l_cast_0(l_v661_1, v899[0][7])(v899), 
                    latency = {
                        crn = function(v901)
                            return l_cast_0(l_v663_1, v899[0][9])(v899, v901);
                        end, 
                        average = function(v902)
                            return l_cast_0(l_v663_1, v899[0][10])(v899, v902);
                        end
                    }, 
                    loss = l_cast_0(l_v663_1, v899[0][11])(v899, 1), 
                    choke = l_cast_0(l_v663_1, v899[0][12])(v899, 1), 
                    got_bytes = l_cast_0(l_v663_1, v899[0][13])(v899, 1), 
                    sent_bytes = l_cast_0(l_v663_1, v899[0][13])(v899, 0), 
                    is_valid_packet = l_cast_0(l_v662_1, v899[0][18])(v899, 1, v900 - 1)
                };
            end;
        end;
        local function v907(v904)
            if v904 == nil then
                return 0, 0;
            else
                local v905 = 0;
                local v906 = 0;
                l_cast_0(l_v665_1, v904[0][25])(v904, l_v657_0, l_v658_0, l_v659_1);
                if ((l_v657_0 ~= nil and l_v658_0 ~= nil) and l_v659_1 ~= nil) and l_v657_0[0] > 0 then
                    v905 = l_v659_1[0] * 1000;
                    v906 = l_v657_0[0] * 1000;
                end;
                return v906, v905;
            end;
        end;
        v422.render = function(_)
            if not (l_get_local_player_0() ~= nil) or not globals.is_in_game then
                return ;
            else
                local v909 = l_cast_0("void***", l_v668_1(l_v667_1)) or error("netchaninfo is nil");
                local v910 = v903(v909);
                local v911, v912 = v907(v909);
                local v913 = 255 * (1 - v463(nil, 2) * 0.55);
                local v914 = color(255, 200, 95);
                local v915 = v393.scr:clone();
                local v916 = v915.x * 0.5 + 1;
                v915.y = v915.y - 155;
                v915.x = v916;
                v916 = 0;
                local v917 = {
                    [0] = "clock syncing", 
                    [1] = "packet choke", 
                    [2] = "packet loss", 
                    [3] = "lost connection"
                };
                if v910.choke > 0 then
                    v916 = 1;
                end;
                if v910.loss > 0 then
                    v916 = 2;
                end;
                if v910.is_timing_out then
                    v916 = 3;
                    v910.loss = 1;
                    l_v670_1 = l_v670_1 - globals.frametime;
                    l_v670_1 = l_v670_1 < 0.05 and 0.05 or l_v670_1;
                else
                    l_v670_1 = l_v670_1 + globals.frametime * 2;
                    l_v670_1 = l_v670_1 > 1 and 1 or l_v670_1;
                end;
                local v918 = v916 ~= 0 and l_format_0("%.1f%% (%.1f%%)", v910.loss * 100, v910.choke * 100) or l_format_0("%.1fms", v912 / 2);
                if v916 ~= 0 then
                    v914 = color(255, 50, 50, v913);
                end;
                local v919 = v917[v916];
                local v920 = vector((v915.x - render.measure_text(l_v632_2, "", v919).x) - 25, v915.y);
                local v921 = 1;
                render.text(l_v632_2, v920, color(255, 255, 255, v916 ~= 0 and 255 or v913), "", v919);
                render.texture(l_v880_0, vector(v915.x - 12, v920.y - 8), nil, v914);
                render.text(l_v632_2, vector(v915.x + 20, v920.y), color(), "", l_format_0("+- %s", v918));
                local v922 = l_format_0("in: %.2fk/s    ", v910.got_bytes / 1024);
                local v923 = render.measure_text(l_v632_2, "", v922);
                local v924 = 1 / globals.tickinterval;
                local v925 = l_v655_1:float() * (1000 / v924);
                local v926 = color(255, 255, 255, l_v670_1 * 255);
                if v925 / 1000 < 2 / l_v656_1:int() then
                    v926 = color(255, 125, 95, l_v670_1 * 255);
                end;
                render.text(l_v632_2, vector(v920.x, v920.y + 20 * v921), color(255, l_v670_1 * 255), "", v922);
                render.text(l_v632_2, vector(v920.x + v923.x, v920.y + 20 * v921), v926, "", l_format_0("lerp: %.1fms", v925));
                v921 = v921 + 1;
                render.text(l_v632_2, vector(v920.x, v920.y + 20 * v921), color(255, l_v670_1 * 255), "", l_format_0("out: %.2fk/s", v910.sent_bytes / 1024));
                v921 = v921 + 1;
                render.text(l_v632_2, vector(v920.x, v920.y + 20 * v921), color(255, l_v670_1 * 255), "", l_format_0("sv: %.2f +- %.2fms    var: %.3f ms", v911, v912, v912));
                v921 = v921 + 1;
                local v927 = v910.latency.crn(0);
                local v928 = v910.latency.crn(1);
                local v929 = v927 * 1000;
                local v930 = v910.latency.average(0) * 1000;
                local v931 = v395.misc.main.fake_latency:get();
                local v932 = v931 ~= 0 and v931 or 1;
                local v933 = l_min_0(((v927 + v928) / (v932 - globals.tickinterval)) * 1000, 1) * 100;
                local v934 = l_v882_0(v930);
                local _ = render.measure_text(l_v632_2, "", (l_format_0("tick: %dp/s    ", v924)));
                local v936 = l_format_0("delay: %dms (+- %dms)    ", v930, l_abs_0(v930 - v929));
                local v937 = render.measure_text(l_v632_2, "", v936);
                local v938 = l_max_0(0, (v928 - v927) * 1000);
                local v939 = l_format_0("datagram%s", (v932 ~= 1 and v938 > 1) and l_format_0(": %dms", v938) or "");
                render.text(l_v632_2, vector(v920.x, v920.y + 20 * v921), color(v934.r, v934.g, v934.b, l_v670_1 * 255), "", v936);
                render.text(l_v632_2, vector(v920.x + v937.x, v920.y + 20 * v921), color(255, 2.55 * v933, 2.55 * v933, l_v670_1 * 255), "", v939);
                v921 = v921 + 1;
                return ;
            end;
        end;
    end;
    v632 = render.load_font("Calibri", 21, "adb");
    v654 = "s";
    v655 = {};
    v656 = {
        [1] = 0
    };
    v657 = color(255, 200);
    v658 = color(255, 0, 0);
    v659 = color(132, 195, 16);
    v660 = color(0, 5);
    v661 = color(0, 55);
    v662 = {
        [1] = "weapon_deagle", 
        [2] = "weapon_elite", 
        [3] = "weapon_fiveseven", 
        [4] = "weapon_glock", 
        [5] = nil, 
        [6] = nil, 
        [7] = "weapon_ak47", 
        [8] = "weapon_aug", 
        [9] = "weapon_awp", 
        [10] = "weapon_famas", 
        [11] = "weapon_g3sg1", 
        [12] = nil, 
        [13] = "weapon_galilar", 
        [14] = "weapon_m249", 
        [15] = nil, 
        [16] = "weapon_m4a1", 
        [17] = "weapon_mac10", 
        [18] = nil, 
        [19] = "weapon_p90", 
        [20] = nil, 
        [21] = nil, 
        [22] = nil, 
        [23] = "weapon_mp5sd", 
        [24] = "weapon_ump45", 
        [25] = "weapon_xm1014", 
        [26] = "weapon_bizon", 
        [27] = "weapon_mag7", 
        [28] = "weapon_negev", 
        [29] = "weapon_sawedoff", 
        [30] = "weapon_tec9", 
        [31] = "weapon_taser", 
        [32] = "weapon_hkp2000", 
        [33] = "weapon_mp7", 
        [34] = "weapon_mp9", 
        [35] = "weapon_nova", 
        [36] = "weapon_p250", 
        [37] = nil, 
        [38] = "weapon_scar20", 
        [39] = "weapon_sg556", 
        [40] = "weapon_ssg08", 
        [41] = "weapon_knifegg", 
        [42] = "weapon_knife", 
        [43] = "weapon_flashbang", 
        [44] = "weapon_hegrenade", 
        [45] = "weapon_smokegrenade", 
        [46] = "weapon_molotov", 
        [47] = "weapon_decoy", 
        [48] = "weapon_incgrenade", 
        [49] = "weapon_c4", 
        [50] = "item_kevlar", 
        [51] = "item_assaultsuit", 
        [52] = "item_heavyassaultsuit", 
        [53] = nil, 
        [54] = nil, 
        [55] = "item_defuser", 
        [56] = "item_cutters", 
        [57] = "weapon_healthshot", 
        [58] = nil, 
        [59] = "weapon_knife_t", 
        [60] = "weapon_m4a1_silencer", 
        [61] = "weapon_usp_silencer", 
        [62] = nil, 
        [63] = "weapon_cz75a", 
        [64] = "weapon_revolver", 
        [65] = nil, 
        [66] = nil, 
        [67] = nil, 
        [68] = "weapon_tagrenade", 
        [69] = "weapon_fists", 
        [70] = "weapon_breachcharge", 
        [71] = nil, 
        [72] = "weapon_tablet", 
        [73] = nil, 
        [74] = "weapon_melee", 
        [75] = "weapon_axe", 
        [76] = "weapon_hammer", 
        [77] = nil, 
        [78] = "weapon_spanner", 
        [79] = nil, 
        [80] = "weapon_knife_ghost", 
        [81] = "weapon_firebomb", 
        [82] = "weapon_diversion", 
        [83] = "weapon_frag_grenade", 
        [84] = "weapon_snowball", 
        [515] = "weapon_knife_butterfly", 
        [508] = "weapon_knife_m9_bayonet", 
        [509] = "weapon_knife_tactical", 
        [506] = "weapon_knife_gut", 
        [507] = "weapon_knife_karambit", 
        [516] = "weapon_knife_push", 
        [505] = "weapon_knife_flip", 
        [523] = "weapon_knife_widowmaker", 
        [500] = "weapon_bayonet", 
        [522] = "weapon_knife_stiletto", 
        [520] = "weapon_knife_gypsy_jackknife", 
        [519] = "weapon_knife_ursus", 
        [514] = "weapon_knife_survival_bowie", 
        [512] = "weapon_knife_falchion"
    };
    v663 = {
        secondary = {
            [1] = 1, 
            [2] = 2, 
            [3] = 3, 
            [4] = 4, 
            [5] = 30, 
            [6] = 32, 
            [7] = 36, 
            [8] = 61, 
            [9] = 63, 
            [10] = 64
        }, 
        rifle = {
            [1] = 7, 
            [2] = 8, 
            [3] = 9, 
            [4] = 10, 
            [5] = 11, 
            [6] = 13, 
            [7] = 16, 
            [8] = 38, 
            [9] = 39, 
            [10] = 40, 
            [11] = 60
        }, 
        heavy = {
            [1] = 14, 
            [2] = 25, 
            [3] = 27, 
            [4] = 28, 
            [5] = 29, 
            [6] = 35
        }, 
        smg = {
            [1] = 17, 
            [2] = 19, 
            [3] = 23, 
            [4] = 24, 
            [5] = 26, 
            [6] = 33, 
            [7] = 34
        }, 
        equipment = {
            [1] = 31, 
            [2] = 50, 
            [3] = 51, 
            [4] = 52, 
            [5] = 55, 
            [6] = 56
        }, 
        melee = {
            [1] = 41, 
            [2] = 42, 
            [3] = 59, 
            [4] = 69, 
            [5] = 74, 
            [6] = 75, 
            [7] = 76, 
            [8] = 78, 
            [9] = 80, 
            [10] = 500, 
            [11] = 505, 
            [12] = 506, 
            [13] = 507, 
            [14] = 508, 
            [15] = 509, 
            [16] = 512, 
            [17] = 514, 
            [18] = 515, 
            [19] = 516, 
            [20] = 519, 
            [21] = 520, 
            [22] = 522, 
            [23] = 523
        }, 
        grenade = {
            [1] = 43, 
            [2] = 44, 
            [3] = 45, 
            [4] = 46, 
            [5] = 47, 
            [6] = 48, 
            [7] = 68, 
            [8] = 81, 
            [9] = 82, 
            [10] = 83, 
            [11] = 84
        }, 
        c4 = {
            [1] = 49, 
            [2] = 70
        }, 
        boost = {
            [1] = 57
        }, 
        utility = {
            [1] = 72
        }
    };
    v664 = setmetatable({}, {
        __index = function(v940, v941)
            return type(v941) == "number" and rawget(v940, bit_band(v941, 65535)) or nil;
        end
    });
    v665 = {};
    for v942, v943 in pairs(v663) do
        for v944 = 1, #v943 do
            local v945 = v943[v944];
            local v946 = v662[v943[v944]];
            local v947 = v943[v944];
            local l_v942_0 = v942;
            local l_v942_1 = v942;
            v665[v947] = v662[v943[v944]];
            v664[v946] = l_v942_1;
            v664[v945] = l_v942_0;
        end;
    end;
    v666 = {
        grenade = 0.4, 
        utility = 0.4, 
        equipment = 0.7, 
        secondary = 0.7
    };
    v667 = {};
    v668 = utils.get_vfunc("filesystem_stdio.dll", "VBaseFileSystem011", 0, "int(__thiscall*)(void*, void*, int, void*)");
    v670 = utils.get_vfunc("filesystem_stdio.dll", "VBaseFileSystem011", 2, "void*(__thiscall*)(void*, const char*, const char*, const char*)");
    local v950 = utils.get_vfunc("filesystem_stdio.dll", "VBaseFileSystem011", 7, "unsigned int(__thiscall*)(void*, void*)");
    do
        local l_v632_3, l_v654_1, l_v655_2, l_v657_1, l_v658_1, l_v659_2, l_v660_1, l_v661_2, l_v664_2, l_v666_1, l_v667_2, l_v668_2, l_v670_2, l_v950_0, l_v880_1, l_v882_1 = v632, v654, v655, v657, v658, v659, v660, v661, v664, v666, v667, v668, v670, v950, v880, v882;
        l_v880_1 = function(v967)
            local v968 = l_v670_2(v967, "r", "MOD");
            if v968 == nil then
                return ;
            else
                local v969 = l_v950_0(v968);
                if not (v969 ~= nil) or v969 < 0 then
                    return ;
                else
                    local v970 = ffi.new("char[" .. v969 + 1 .. "]");
                    if v970 == nil then
                        return ;
                    elseif not l_v668_2(v970, v969, v968) then
                        return ;
                    else
                        return ffi.string(v970, v969);
                    end;
                end;
            end;
        end;
        l_v882_1 = function(v971)
            local v972 = v971:match("<svg(.*)>.*</svg>");
            if v972 == nil then
                error("Invalid svg, missing <svg> tag", 2);
                return ;
            else
                v972 = v972:gsub("\r\n", ""):gsub("\n", "");
                local v973 = false;
                local v974 = "";
                local v975 = "";
                local v976 = {};
                local v977 = 1;
                while true do
                    local v978 = v972:sub(v977, v977);
                    if not (v978 == "") then
                        if v973 then
                            if v978 == "\"" then
                                v973 = false;
                                v976[v974.gsub(v974, "\t", ""):lower()] = v975;
                                local v979 = "";
                                v975 = "";
                                v974 = v979;
                            else
                                v975 = v975 .. v978;
                            end;
                        elseif not (v978 == ">") then
                            if v978 == "=" then
                                if v972:sub(v977, v977 + 1) == "=\"" then
                                    v973 = true;
                                    v977 = v977 + 1;
                                end;
                            else
                                v974 = v978 == " " and "" or v974 .. v978;
                            end;
                        else
                            break;
                        end;
                        v977 = v977 + 1;
                    else
                        break;
                    end;
                end;
                local v980 = nil;
                local v981 = nil;
                if v976.width ~= nil then
                    v980 = tonumber((v976.width:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")));
                    if v980 ~= nil and v980 <= 0 then
                        v980 = nil;
                    end;
                end;
                if v976.height ~= nil then
                    v981 = tonumber((v976.height:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")));
                    if v981 ~= nil and v981 <= 0 then
                        v981 = nil;
                    end;
                end;
                if not (v980 ~= nil) or v981 == nil and v976.viewbox ~= nil then
                    local _, _, _, _ = v976.viewbox:match("^%s*([%d.]*) ([%d.]*) ([%d.]*) ([%d.]*)%s*$");
                    local v986 = tonumber(v980);
                    v981 = tonumber(v981);
                    v980 = v986;
                    if (v980 ~= nil and v981 ~= nil) and (not (v980 > 0) or v981 <= 0) then
                        v986 = nil;
                        v981 = nil;
                        v980 = v986;
                    end;
                end;
                if ((v980 ~= nil and v981 ~= nil) and v980 > 0) and v981 > 0 then
                    return v980, v981;
                else
                    return 20, 16;
                end;
            end;
        end;
        local function v991(v987)
            if not l_v667_2[v987] then
                local v988 = l_v880_1("materials/panorama/images/" .. string.gsub(string.gsub(string.gsub(string.gsub(string.gsub("icons/equipment/" .. string.gsub(string.gsub(v987, "^weapon_", ""), "^item_", "") .. ".svg", "%z", ""), "%c", ""), "\\", "/"), "%.%./", ""), "^/+", ""));
                if v988 then
                    local v989, v990 = l_v882_1(v988);
                    l_v667_2[v987] = render.load_image(v988, vector(v989, v990)) or false;
                else
                    l_v667_2[v987] = false;
                end;
            end;
            return l_v667_2[v987];
        end;
        local v992 = false;
        local v993 = nil;
        v409.on_update = function()
            local v994 = false;
            local v995 = nil;
            (function()
                local v996 = l_get_local_player_0();
                if not v996 or not v996:is_alive() then
                    return ;
                else
                    local v997 = v996:get_origin();
                    if v993 then
                        v994 = (v997 - v993):lengthsqr() > 4096;
                    end;
                    v995 = v997;
                    return ;
                end;
            end)();
            local l_v994_0 = v994;
            v993 = v995;
            v992 = l_v994_0;
        end;
        local v999 = 3;
        local function v1032()
            local v1000 = entity.get_local_player();
            if v1000 and v1000:is_alive() then
                if v409.extra_indicators:get("Freestanding") and v408.freestanding.active then
                    v409:indicator(l_v657_1, "FS");
                end;
                if v409.extra_indicators:get("Ping Spike") then
                    local v1001 = v395.misc.main.fake_latency:get();
                    if v1001 ~= 0 then
                        local v1002 = utils.net_channel();
                        if v1002 ~= nil then
                            local v1003 = v1001 / (v1002.latency[0] * 1000);
                            if v1003 > 1 then
                                v1003 = 1 - v1003 % 1;
                            end;
                            v409:indicator(color(255, 255, 128):lerp(color(175, 255, 75), v1003), "PING");
                        end;
                    end;
                end;
                if v409.extra_indicators:get("Edge Yaw") and v408.edge_yaw.controller:get() then
                    v409:indicator(color(189, 170, 255), "EDGE");
                end;
                if v409.extra_indicators:get("Safe Points") and v395.ragebot.safety.safe_points:get() == "Force" then
                    v409:indicator(l_v657_1, "SAFE");
                end;
                if v409.extra_indicators:get("Body Aim") and v395.ragebot.safety.body_aim:get() == "Force" then
                    v409:indicator(l_v657_1, "BODY");
                end;
                if v409.extra_indicators:get("Fake Duck") and v395.antiaim.misc.fake_duck:get() then
                    v409:indicator(color(210, 210, 210), "DUCK");
                end;
                if v409.extra_indicators:get("Dormant Aimbot") and v395.ragebot.main.dormant_aimbot:get() then
                    v409:indicator(l_v659_2, "DA");
                end;
                if v409.extra_indicators:get("LC") and (not v407.onground or v992) then
                    v409:indicator(v992 and l_v659_2 or l_v658_1, "LC");
                end;
            end;
            if v409.extra_indicators:get("Bomb") then
                local v1004 = entity.get_entities("CC4")[1];
                if v1004 and v1004.m_bStartedArming then
                    local v1005 = 1 - (v1004.m_fArmedTime - globals.curtime) / v999;
                    local v1006 = entity.get_entities("CCSPlayerResource")[1];
                    local v1007 = v1004:get_origin();
                    local l_m_bombsiteCenterA_0 = v1006.m_bombsiteCenterA;
                    local l_m_bombsiteCenterB_0 = v1006.m_bombsiteCenterB;
                    local v1010 = "B";
                    if v1007:dist(l_m_bombsiteCenterA_0) < v1007:dist(l_m_bombsiteCenterB_0) then
                        v1010 = "A";
                    end;
                    v409:indicator(color(250, 245, 130), "Bombsite " .. v1010, v1005);
                end;
                local v1011 = entity.get_entities("CPlantedC4")[1];
                if (v1011 and v1011.m_bBombTicking) and not v1011.m_bBombDefused then
                    local l_m_hBombDefuser_0 = v1011.m_hBombDefuser;
                    local l_m_flC4Blow_0 = v1011.m_flC4Blow;
                    local v1014 = l_m_flC4Blow_0 - globals.curtime;
                    if v1014 > 0 then
                        v409:indicator(color(255, 255, 255, 200), l_format_0("%s - %.1fs", v1011.m_nBombSite == 1 and "B" or "A", v1014));
                    end;
                    local v1015 = v1000:get_origin();
                    local v1016 = v1011:get_origin();
                    local l_m_iHealth_0 = v1000.m_iHealth;
                    local l_m_ArmorValue_0 = v1000.m_ArmorValue;
                    local v1019 = v1016:dist(v1015);
                    local v1020 = 450.7;
                    local v1021 = (v1019 - 75.68) / 789.2;
                    local v1022 = v1020 * math.exp(-v1021 * v1021);
                    if l_m_ArmorValue_0 > 0 then
                        local v1023 = v1022 * 0.5;
                        local v1024 = (v1022 - v1023) * 0.5;
                        if l_m_ArmorValue_0 < v1024 then
                            l_m_ArmorValue_0 = l_m_ArmorValue_0 * 2;
                            v1023 = v1022 - v1024;
                        end;
                        v1022 = v1023;
                    end;
                    if v1022 > 0.5 then
                        if l_m_iHealth_0 <= math.ceil(v1022) then
                            v409:indicator(color(255, 0, 0), "FATAL");
                        else
                            v409:indicator(color(210, 215, 110), l_format_0("-%dHP", v1022));
                        end;
                    end;
                    if l_m_hBombDefuser_0 and not v1011.m_bBombDefused then
                        local l_m_flDefuseLength_0 = v1011.m_flDefuseLength;
                        local l_m_flDefuseCountDown_0 = v1011.m_flDefuseCountDown;
                        local v1027 = (l_m_flDefuseCountDown_0 - globals.curtime) / l_m_flDefuseLength_0;
                        local v1028 = vector();
                        local v1029 = vector(20, v393.scr.y);
                        render.rect(v1028, v1029, color(0, 0, 0, 128));
                        v1028 = v1028 + 1;
                        v1029 = v1029 - 1;
                        render.rect(v1028:lerp(vector(v1028.x, v1029.y), 1 - v1027), v1029, l_m_flDefuseCountDown_0 < l_m_flC4Blow_0 and color(0, 255, 0, 128) or color(255, 0, 0, 128));
                    end;
                end;
            end;
            if v1000 and v1000:is_alive() then
                if v409.extra_indicators:get("Hide Shots") and v395.ragebot.main.hide_shots:get() then
                    v409:indicator(color(210, 210, 210), "OSAA");
                end;
                if v409.extra_indicators:get("Double Tap") and v395.ragebot.main.double_tap:get() then
                    v409:indicator(rage.exploit:get() == 1 and color(210, 210, 210) or l_v658_1, "DT");
                end;
                if v409.extra_indicators:get("Hit Chance") then
                    local v1030 = v410:get("Hit Chance");
                    if v1030 ~= nil and v1030.item.active then
                        v409:indicator(color(225, 85, 85), l_format_0("Hitchance: %d", v1030.item.value));
                    end;
                end;
                if v409.extra_indicators:get("Minimum Damage") then
                    local v1031 = v410:get("Min. Damage");
                    if v1031 ~= nil and v1031.item.active then
                        v409:indicator(l_v657_1, l_format_0("Damage: %d", v1031.item.value));
                    end;
                end;
            end;
        end;
        v409.controller = v403("VISUALS", "bGameSense", v405.groups.features.screen:switch("Game\a95b806ffSense"));
        local v1033 = v409.controller:create();
        v409.features_ref = v403("VISUALS", "szGameSense", v1033:selectable("Features")):depend(v409.controller);
        v409.extra_indicators = v403("VISUALS", "szGameSense.szExtraIndicators", v1033:listable("Show", {
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
            [13] = "LC"
        })):depend(v409.controller);
        v409.features = v405:combo_control(v409.features_ref);
        v409.features["Menu Background"] = function()
            local v1034 = ui.get_position();
            v409:box(v1034 - vector(7, 9), (v1034 + ui.get_size()) + 7, true, (l_get_alpha_0()));
        end;
        v409.features.Indicators = function()
            if not globals.is_in_game then
                return ;
            elseif not l_get_local_player_0() then
                return ;
            else
                v1032();
                local v1035 = vector(10, v393.scr.y * 0.68);
                for v1036 = 1, #l_v655_2 do
                    local v1037 = l_v655_2[v1036];
                    local l_text_0 = v1037.text;
                    local l_color_0 = v1037.color;
                    local l_pct_0 = v1037.pct;
                    local v1041 = render.measure_text(l_v632_3, l_v654_1, l_text_0) + vector(10, 4);
                    local v1042 = v1035:clone();
                    local v1043 = vector(v1041.x * 0.5, v1041.y);
                    render.gradient(v1042, v1042 + v1043, l_v660_1, l_v661_2, l_v660_1, l_v661_2);
                    render.gradient(v1042 + vector(v1043.x), v1042 + v1041, l_v661_2, l_v660_1, l_v661_2, l_v660_1);
                    v1042 = v1042 + vector(10, 4);
                    render.text(l_v632_3, v1042, l_color_0, l_v654_1, l_text_0);
                    v1043 = v1041.y * 0.4;
                    if l_pct_0 ~= nil then
                        v1042 = v1042 + vector(v1041.x + 12, v1041.y * 0.5 - 3);
                        render.circle_outline(v1042, color(0, 0, 0, 210), v1043, 0, 1, 5);
                        render.circle_outline(v1042, color(), v1043 - 1, 0, l_pct_0, 3);
                    end;
                    v1035.y = v1035.y - (v1041.y + 7);
                end;
                return ;
            end;
        end;
        v409.features["Net Graph"] = function()
            v422:render();
        end;
        local v1044 = {};
        local v1045 = 4;
        local v1046 = 18;
        v409.features["Buy List"] = function()
            local v1047 = 90;
            local v1048 = {};
            local v1049 = {};
            local v1050 = 1;
            local v1051 = color(255, 255, 255);
            for v1052, v1053 in pairs(v1044) do
                local v1054 = entity.get(v1052);
                if v1054 and #v1053 ~= 0 then
                    v1048[v1052] = l_format_0("%s bought ", v1054:get_name());
                    local l_x_0 = render.measure_text(1, "", v1048[v1052]).x;
                    v1049[v1052] = l_x_0;
                    for v1056 = 1, #v1053 do
                        if not (v1053[v1056] == "kevlar") or not v448(v1053, "assaultsuit") then
                            local v1057 = v991(v1053[v1056]);
                            if v1057 then
                                l_x_0 = (l_x_0 + l_floor_0(v1057.width * (16 / v1057.height))) + v1045;
                            end;
                        end;
                    end;
                    v1047 = l_max_0(v1047, l_x_0);
                    v1050 = v1050 + 1;
                end;
            end;
            if v1050 == 1 then
                return ;
            else
                local v1058 = entity.get_game_rules();
                if not v1058 then
                    return ;
                else
                    local v1059 = 255;
                    local v1060 = globals.curtime - v1058.m_fRoundStartTime;
                    if v1060 > 5 and v1060 <= 6 then
                        v1059 = 255 * (1 - (v1060 - 5) / 1);
                    elseif v1060 > 6 then
                        v1059 = 0;
                    end;
                    if v1059 == 0 then
                        return ;
                    else
                        local v1061 = render.screen_size();
                        local l_x_1 = v1061.x;
                        local l_y_0 = v1061.y;
                        local v1064 = ((l_x_1 - v1047) - 16) - 11;
                        local v1065 = l_y_0 / 2.3;
                        local v1066 = vector(v1064 - 4, v1065 - 4);
                        v409:box(v1066, v1066 + vector(v1047 + 16, v1050 * v1046), true, v1059 / 255);
                        local v1067 = v1064 + 5;
                        local v1068 = v1065 + 8;
                        local v1069 = 1;
                        for v1070, v1071 in pairs(v1044) do
                            if entity.get(v1070) and #v1071 ~= 0 then
                                local v1072 = (v1069 - 1) * v1046;
                                render.text(1, vector(v1067, v1068 + v1072), color(v1051.r, v1051.g, v1051.b, v1059), "", v1048[v1070]);
                                local v1073 = v1049[v1070];
                                local v1074 = {
                                    [1] = "c4", 
                                    [2] = "boost", 
                                    [3] = "utility", 
                                    [4] = "rifle", 
                                    [5] = "heavy", 
                                    [6] = "smg", 
                                    [7] = "secondary", 
                                    [8] = "melee", 
                                    [9] = "equipment", 
                                    [10] = "grenade"
                                };
                                for v1075 = 1, #v1074 do
                                    local v1076 = v1074[v1075];
                                    for v1077 = 1, #v1071 do
                                        local v1078 = l_v664_2[v1071[v1077]];
                                        if v1078 == v1076 and (not (v1071[v1077] == "item_kevlar") or not v448(v1071, "item_assaultsuit")) then
                                            local v1079 = v991(v1071[v1077]);
                                            if v1079 then
                                                local v1080 = l_v666_1[v1078] or 1;
                                                local v1081 = l_floor_0(v1079.width * (16 / v1079.height));
                                                render.texture(v1079, vector(v1067 + v1073, (v1068 + v1072) - 1), vector(v1081, 16), color(v1051.r, v1051.g, v1051.b, v1059 * v1080));
                                                v1073 = (v1073 + v1081) + v1045;
                                            end;
                                        end;
                                    end;
                                end;
                                v1069 = v1069 + 1;
                            end;
                        end;
                        return ;
                    end;
                end;
            end;
        end;
        v409.item_purchase = function(_, v1083)
            local v1084 = entity.get(v1083.userid, true);
            if not v1084 or not v1084:is_enemy() then
                return ;
            else
                local v1085 = v1084:get_index();
                if v1044[v1085] == nil then
                    v1044[v1085] = {};
                end;
                table.insert(v1044[v1085], v1083.weapon);
                return ;
            end;
        end;
        v409.player_spawn = function(_, v1087)
            local v1088 = entity.get(v1087.userid, true);
            if not v1088 or not v1088:is_enemy() then
                return ;
            else
                local v1089 = v1088:get_index();
                if v1044[v1089] == nil then
                    v1044[v1089] = {};
                end;
                return ;
            end;
        end;
        v409.round_start = function(_, _)
            v1044 = {};
        end;
        v409.round_end = function(_, _)
            v1044 = {};
        end;
        v409.extra_indicators:depend(function()
            return v409.features_ref:get("Indicators");
        end);
        v409.box = function(_, v1095, v1096, v1097, v1098)
            local v1099 = 255 * (v1098 or 1);
            if v1099 <= 0 then
                return ;
            else
                render.rect_outline(v1095, v1096, color(10, v1099));
                render.rect_outline(v1095 + 1, v1096 - 1, color(60, v1099));
                render.rect_outline(v1095 + 3, v1096 - 3, color(40, v1099), 3);
                render.rect_outline(v1095 + 5, v1096 - 5, color(60, v1099));
                render.rect(v1095 + 6, v1096 - 6, color(20, v1099));
                if v1097 then
                    local v1100 = v1095 + 7;
                    local v1101 = v1096 - 7;
                    local v1102 = v1101 - v1100;
                    local v1103 = color(59, 175, 222, v1099);
                    local v1104 = color(202, 70, 205, v1099);
                    local v1105 = color(201, 227, 58, v1099);
                    render.gradient(v1100, v1100 + vector(v1102.x * 0.5, 1), v1103, v1104, v1103, v1104);
                    render.gradient(v1100 + vector(v1102.x * 0.5), v1100 + vector(v1102.x, 1), v1104, v1105, v1104, v1105);
                    v1100.y = v1100.y + 1;
                    v1101.y = v1101.y + 1;
                    v1103.a = v1103.a * 0.2;
                    v1104.a = v1104.a * 0.2;
                    v1105.a = v1105.a * 0.2;
                    render.gradient(v1100, v1100 + vector(v1102.x * 0.5, 1), v1103, v1104, v1103, v1104);
                    render.gradient(v1100 + vector(v1102.x * 0.5), v1100 + vector(v1102.x, 1), v1104, v1105, v1104, v1105);
                end;
                return ;
            end;
        end;
        v409.indicator = function(_, v1107, v1108, v1109)
            l_v655_2[#l_v655_2 + 1] = {
                color = v1107, 
                text = v1108, 
                pct = v1109
            };
        end;
        v409.pre = function(_)
            l_v655_2 = {};
        end;
        v409.post = function(_)
            if not v409.controller:get() then
                return ;
            else
                for v1112, v1113 in pairs(v409.features) do
                    if v409.features_ref:get(v1112) then
                        v1113();
                    end;
                end;
                return ;
            end;
        end;
    end;
    v632 = {};
    v654 = {};
    do
        local l_v632_4, l_v654_2 = v632, v654;
        v410.update = function(_)
            l_v632_4 = {};
            l_v654_2 = l_get_binds_0();
            for v1117 = 1, #l_v654_2 do
                local v1118 = l_v654_2[v1117];
                local l_reference_1 = v1118.reference;
                local l_active_0 = v1118.active;
                local v1121 = l_format_0("binding.%d", (l_reference_1:id()));
                if l_active_0 then
                    v400:new(v1121, 1);
                end;
                l_v632_4[v1118.name] = {
                    item = v1118, 
                    alpha = v400[v1121] or 0
                };
            end;
        end;
        v410.get = function(_, v1123)
            if v1123 ~= nil then
                return l_v632_4[v1123];
            else
                return l_v654_2;
            end;
        end;
    end;
    v632 = {};
    v654 = {};
    v655 = nil;
    v656 = false;
    v657 = {};
    v658 = function(v1124, v1125, v1126)
        return ((v1125.x <= v1124.x and v1125.y <= v1124.y) and v1124.x <= v1126.x) and v1124.y <= v1126.y;
    end;
    v659 = function()
        return false;
    end;
    do
        local l_v632_5, l_v654_3, l_v655_3, l_v656_2, l_v657_2, l_v658_2, l_v659_3 = v632, v654, v655, v656, v657, v658, v659;
        v411.new = function(_, v1135, v1136, v1137)
            local v1138 = {
                active = false, 
                hovered = false, 
                x_slider = v403("DRAG", l_format_0("flX[%s]", v1135), v405.groups.features.screen:slider(l_format_0("%s_x", v1135), 0, v393.scr.x, v1136 ~= nil and v1136.x or 0)), 
                y_slider = v403("DRAG", l_format_0("flY[%s]", v1135), v405.groups.features.screen:slider(l_format_0("%s_y", v1135), 0, v393.scr.y, v1136 ~= nil and v1136.x or 0))
            };
            v1138.pos = vector(v1138.x_slider:get(), v1138.y_slider:get());
            v1138.size = v1137 or vector(144, 20);
            v1138.alpha = 1;
            v1138.x_slider:depend(l_v659_3);
            v1138.y_slider:depend(l_v659_3);
            setmetatable(v1138, {
                __index = l_v632_5
            });
            l_insert_0(l_v654_3, v1138);
            return v1138;
        end;
        v411.createmove = function(_, v1140)
            if not (l_v655_3 == nil) or l_v657_2.instance ~= nil then
                v1140.in_attack = false;
                v1140.in_attack2 = false;
            end;
        end;
        v411.render = function(_)
            l_v655_3 = nil;
            if not v468() then
                return ;
            else
                local v1142 = ui.get_mouse_position();
                local v1143 = common.is_button_down(1);
                for v1144 = 1, #l_v654_3 do
                    local v1145 = l_v654_3[v1144];
                    local l_pos_0 = v1145.pos;
                    v1145.hovered = l_v658_2(v1142, l_pos_0, l_pos_0 + v1145.size);
                    if v1145.active and v1145.hovered then
                        l_v655_3 = v1145;
                    end;
                    v1145.alpha = v400:lerp(v1145.alpha, l_v657_2.instance == v1145 and 0.5 or 1);
                    v1145.active = false;
                end;
                if not v1143 then
                    l_v657_2.delta = nil;
                    l_v657_2.instance = nil;
                end;
                if ((l_v655_3 ~= nil and l_v657_2.instance == nil) and v1143) and not l_v656_2 then
                    l_v657_2.delta = v1142 - l_v655_3.pos;
                    l_v657_2.instance = l_v655_3;
                end;
                if l_v657_2.instance ~= nil then
                    local l_instance_0 = l_v657_2.instance;
                    local v1148 = v1142 - l_v657_2.delta;
                    v1148.x = v444(v1148.x, 0, v393.scr.x - l_instance_0.size.x);
                    v1148.y = v444(v1148.y, 0, v393.scr.y - l_instance_0.size.y);
                    l_instance_0.x_slider:set(v1148.x);
                    l_instance_0.y_slider:set(v1148.y);
                    l_instance_0.pos = v1148;
                end;
                l_v656_2 = v1143;
                return ;
            end;
        end;
        l_v632_5.update = function(v1149)
            v1149.active = true;
        end;
    end;
    v632 = function(v1150)
        local v1151 = color();
        for v1152 in v1150:gmatch("\a(%x%x%x%x%x%x)") do
            v1151 = color(v1152);
        end;
        return v1151;
    end;
    v654 = 1;
    v655 = "s";
    v656 = {};
    do
        local l_v654_4, l_v655_4, l_v656_3 = v654, v655, v656;
        v412.new = function(_, v1157, v1158)
            l_insert_0(l_v656_3, 1, {
                alpha = 0, 
                time = globals.realtime + v1157, 
                text = v1158
            });
        end;
        v412.render = function(_)
            local l_realtime_1 = globals.realtime;
            local v1161 = vector(v393.scr.x * 0.5, v393.scr.y * 0.8);
            for v1162 = #l_v656_3, 1, -1 do
                local v1163 = l_v656_3[v1162];
                if v1163.time < l_realtime_1 then
                    v1163.alpha = v400:lerp(v1163.alpha, 0);
                    if v1163.alpha == 0 then
                        l_v656_3[v1162] = nil;
                        goto label1 --[[  false, false  ]];
                    end;
                else
                    v1163.alpha = v400:lerp(v1163.alpha, 1);
                end;
                local l_text_1 = v1163.text;
                local v1165 = render.measure_text(l_v654_4, l_v655_4, l_text_1);
                local v1166 = vector(v1161.x - v1165.x / 2, v1161.y);
                render.shadow(v1166 - vector(0, -7), (v1166 + v1165) + vector(0, -v1165.y + 7), v632(l_text_1):alpha_modulate(v1163.alpha * 140), 25, 0, 5);
                render.text(l_v654_4, v1166, v399.white:alpha_modulate(v1163.alpha * 255), l_v655_4, l_text_1);
                v1161.y = v1161.y - (v1165.y + 4) * v1163.alpha;
                ::label1::;
            end;
        end;
    end;
    v413.controller = v403("SL", "bController", v405.groups.features.screen:switch("Scope Lines"));
    v413.gear = v413.controller:create();
    v413.animate_zoom = v403("SL", "bAnimateZoom", v413.gear:switch("Animate Zoom")):depend(v413.controller);
    v413.color = v403("SL", "clrPicker", v413.gear:color_picker("Color")):depend(v413.controller);
    v413.position = v403("SL", "iPosition", v413.gear:slider("Position", 0, 500, 190)):depend(v413.controller);
    v413.offset = v403("SL", "iOffset", v413.gear:slider("Offset", 0, 500, 15)):depend(v413.controller);
    v413.fov = nil;
    v413.shutdown = function(_)
        v395.visuals.main.scope_overlay:override();
    end;
    v413.override_view = function(v1168, v1169)
        if not v1168.controller:get() or not v1168.animate_zoom:get() then
            v413.fov = nil;
            return ;
        else
            v413.fov = v400:lerp(v413.fov, v1169.fov);
            v1169.fov = v413.fov;
            return ;
        end;
    end;
    v413.__init = function(v1170)
        if not v1170.controller:get() then
            return ;
        else
            local v1171 = l_get_local_player_0();
            if not (v1171 ~= nil) or not v1171:is_alive() then
                return ;
            elseif not v470(v1171) then
                return ;
            else
                v400:new("sl.alpha", 1);
                return ;
            end;
        end;
    end;
    v413.render = function(v1172)
        if not v413.controller:get() then
            v1172:shutdown();
            return ;
        else
            v395.visuals.main.scope_overlay:override("Remove All");
            local v1173 = v400["sl.alpha"] or 0;
            if v1173 == 0 then
                return ;
            else
                local l_center_0 = v393.center;
                local v1175 = v1172.position:get() * v393.offset;
                local v1176 = v1172.offset:get() * v393.offset;
                if v1175 == 0 and v1176 == 0 then
                    return ;
                else
                    local v1177 = v1172.color:get();
                    v1177 = v1177:alpha_modulate(v1177.a * v1173);
                    local v1178 = v1177:alpha_modulate(0);
                    local v1179 = vector(1, v1175 - v1176);
                    local v1180 = vector(v1175 - v1176, 1);
                    if v1176 == 0 then
                        render.rect(l_center_0, l_center_0 + 1, v1177);
                    end;
                    local v1181 = vector(l_center_0.x, l_center_0.y - v1175);
                    render.gradient(v1181, v1181 + v1179, v1178, v1178, v1177, v1177);
                    v1181 = vector(l_center_0.x, (l_center_0.y + v1176) + 1);
                    render.gradient(v1181, v1181 + v1179, v1177, v1177, v1178, v1178);
                    v1181 = vector(l_center_0.x - v1175, l_center_0.y);
                    render.gradient(v1181, v1181 + v1180, v1178, v1177, v1178, v1177);
                    v1181 = vector((l_center_0.x + v1176) + 1, l_center_0.y);
                    render.gradient(v1181, v1181 + v1180, v1177, v1178, v1177, v1178);
                    return ;
                end;
            end;
        end;
    end;
    v654 = nil;
    v655 = 5;
    v656 = 3;
    v657 = {};
    v414.controller = v403("KibitMarker", "bController", v405.groups.features.screen:switch("Kibit Marker"));
    v414.gear = v414.controller:create();
    v414.vertical = v403("KibitMarker", "clrVertical", v414.gear:color_picker("Vertical Color", color(0, 255, 255))):depend(v414.controller);
    v414.horizontal = v403("KibitMarker", "clrHorizontal", v414.gear:color_picker("Horizontal Color", color(0, 255, 0))):depend(v414.controller);
    do
        local l_v654_5, l_v655_5, l_v656_4, l_v657_3 = v654, v655, v656, v657;
        v414.controller:set_callback(function(v1186)
            if not v1186:get() then
                l_v657_3 = {};
            end;
        end);
        v414.aim_fire = function(_, v1188)
            if not v414.controller:get() then
                return ;
            else
                l_v654_5 = v1188.aim;
                return ;
            end;
        end;
        v414.aim_ack = function(_, _)
            if not v414.controller:get() then
                return ;
            else
                table.insert(l_v657_3, 1, {
                    alpha = 1, 
                    time = globals.realtime + l_v656_4, 
                    impact = l_v654_5
                });
                return ;
            end;
        end;
        v414.render = function(v1191)
            if not v1191.controller:get() then
                return ;
            else
                local l_realtime_2 = globals.realtime;
                local v1193 = v414.vertical:get();
                local v1194 = v414.horizontal:get();
                for v1195 = #l_v657_3, 1, -1 do
                    local v1196 = l_v657_3[v1195];
                    if v1196.time < l_realtime_2 then
                        v1196.alpha = v400:lerp(v1196.alpha, 0);
                        if v1196.alpha == 0 then
                            l_v657_3[v1195] = nil;
                            goto label2 --[[  false, false  ]];
                        end;
                    end;
                    local v1197 = render.world_to_screen(v1196.impact);
                    if not (v1197 == nil) then
                        local v1198 = vector(1, l_v655_5);
                        local v1199 = vector(l_v655_5, 1);
                        render.rect(v1197 - v1198, v1197 + v1198, v1193:alpha_modulate(v1193.a * v1196.alpha));
                        render.rect(v1197 - v1199, v1197 + v1199, v1194:alpha_modulate(v1194.a * v1196.alpha));
                    end;
                    ::label2::;
                end;
                return ;
            end;
        end;
    end;
    v415.controller = v403("Hitmarker", "bController", v405.groups.features.screen:switch("Hitmarker"));
    v415.gear = v415.controller:create();
    v415.hit_color = v403("Hitmarker", "clrHit", v415.gear:color_picker("Hit Color")):depend(v415.controller);
    v415.lethal_color = v403("Hitmarker", "clrLethal", v415.gear:color_picker("Lethal Color")):depend(v415.controller);
    v415.size = 5;
    v415.delay = 0.5;
    v415.padding = 5;
    v415.reset = function(v1200)
        v1200.time = nil;
        v1200.alpha = 0;
        v1200.lethal = false;
    end;
    v415.apply = function(v1201, v1202)
        v1201.time = globals.realtime + v1201.delay;
        v1201.alpha = 1;
        v1201.lethal = v1202 == true;
    end;
    v415.active = function(v1203)
        return globals.realtime < v1203.time;
    end;
    v415.player_hurt = function(v1204, v1205)
        if not v415.controller:get() then
            return ;
        else
            v1204:apply(v1205.health <= 0);
            return ;
        end;
    end;
    v415.render = function(v1206)
        if not (v1206.time ~= nil) or v1206.alpha == 0 then
            return ;
        else
            if not v1206:active() then
                v1206.alpha = v400:lerp(v1206.alpha, 0);
            end;
            local l_center_1 = v393.center;
            local l_size_0 = v1206.size;
            local l_padding_0 = v1206.padding;
            local v1210 = (v1206.lethal and v1206.lethal_color or v1206.hit_color):get();
            v1210 = v1210:alpha_modulate(v1210.a * v1206.alpha);
            local l_l_padding_0_0 = l_padding_0;
            local v1212 = l_l_padding_0_0 + l_size_0;
            render.line(l_center_1 + l_l_padding_0_0, l_center_1 + v1212, v1210);
            render.line(l_center_1 - l_l_padding_0_0, l_center_1 - v1212, v1210);
            l_l_padding_0_0 = vector(l_padding_0, -l_padding_0);
            v1212 = l_l_padding_0_0 + vector(l_size_0, -l_size_0);
            render.line(l_center_1 + l_l_padding_0_0, l_center_1 + v1212, v1210);
            render.line(l_center_1 - l_l_padding_0_0, l_center_1 - v1212, v1210);
            return ;
        end;
    end;
    v415.controller:set_callback(function()
        v415:reset();
    end, true);
    v654 = 2;
    v655 = "cs";
    v656 = v411:new("damage_indicator", v393.scr * vector(0.5078125, 0.475), vector(20, 20));
    v657 = function()
        local o_get_override = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
        local v1213 = o_get_override;
        return type(v1213) == "number" and v1213;
    end;
    v416.controller = v403("VISUALS", "bDamageIndicator", v405.groups.features.screen:switch("Damage Indicator"));
    v416.pre = function(_)
        if not v416.controller:get() then
            return ;
        else
            if v468() then
                v400:new("di.alpha", 1);
                v400:new("di.drag", 1);
            end;
            local v1215 = l_get_local_player_0();
            if not v1215 or not v1215:is_alive() then
                return ;
            else
                v400:new("di.alpha", 1);
                return ;
            end;
        end;
    end;
    do
        local l_v654_6, l_v655_6, l_v656_5, l_v657_4 = v654, v655, v656, v657;
        v416.post = function(_)
            local v1221 = (v400["di.alpha"] or 0) * l_v656_5.alpha;
            if v1221 == 0 then
                return ;
            else
                local v1222 = (v400["di.drag"] or 0) * v1221;
                local v1223 = l_v657_4();
                local v1224 = v399.white:alpha_modulate(255 * v1221);
                l_v656_5.size = render.measure_text(l_v654_6, l_v655_6, v1223) + vector(9, 8);
                if v1222 > 0 then
                    render.rect_outline(l_v656_5.pos, l_v656_5.pos + l_v656_5.size, v1224:alpha_modulate(v1222 * v1224.a), 1, 5);
                end;
                render.text(l_v654_6, (l_v656_5.pos + l_v656_5.size * 0.5) + vector(1), v1224, l_v655_6, v1223);
                l_v656_5:update();
                return ;
            end;
        end;
        v416.render = function(v1225)
            v1225:pre();
            v1225:post();
        end;
    end;
    delitel_texta_pizdec = function(v1226, v1227)
        local v1228 = {};
        for v1229 in v1226:gmatch(".") do
            v1228[#v1228 + 1] = v1229;
        end;
        return table.concat(v1228, v1227);
    end;
    v417.controller = v403("ICS", "szController", v405.groups.features.screen:combo("Indicate State"));
    v417.styles = v405:combo_control(v417.controller, {
        [1] = "Off"
    });
    v417.gear = v417.controller:create();
    v417.controller:dependency(function(v1230, v1231)
        return v1230.branch ~= v1231.branch or v1230:get() ~= "Off";
    end);
    v417.scope_alignment = v403("ICS", "bScopeAlignment", v417.gear:switch("Scope Alignment"));
    v417.anim_speed = v403("ICS", "iAnimationSpeed", v417.gear:slider("Animation Speed", 1, 100, 10, 0.1, "x"));
    v417.primary_color = v403("ICS", "clrPrimary", v417.gear:color_picker("Primary Color", v399.blue));
    v417.secondary_color = v403("ICS", "clrSecondary", v417.gear:color_picker("Secondary Color", v399.pink));
    v417.tertiary_color = v403("ICS", "clrTertiary", v417.gear:color_picker("Tertiary Color", v399.white));
    v417.styles.Stylish = {
        __shadow = 30, 
        __align = 0.005, 
        __label = {
            __text = "xo-yaw.lua\194\176", 
            __font = 1, 
            __flags = "s"
        }, 
        __features = {
            __font = 1, 
            __list = {
                [1] = {
                    __text = "brute", 
                    __active = function()
                        return v408.antibrute:get() ~= 0;
                    end
                }, 
                [2] = {
                    __text = "spike", 
                    __active = function()
                        local v1232 = v410:get("Fake Latency");
                        if v1232 ~= nil and v1232.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [3] = {
                    __text = "doubletap", 
                    __active = function()
                        return v395.ragebot.main.double_tap:get(), rage.exploit:get();
                    end
                }, 
                [4] = {
                    __text = "onshot", 
                    __active = function()
                        return v395.ragebot.main.hide_shots:get();
                    end
                }, 
                [5] = {
                    __text = "freestand", 
                    __active = function()
                        return v408.freestanding.active;
                    end
                }, 
                [6] = {
                    __text = "damage", 
                    __active = function()
                        local v1233 = v410:get("Min. Damage");
                        if v1233 ~= nil and v1233.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [7] = {
                    __text = "hitchance", 
                    __active = function()
                        local v1234 = v410:get("Hit Chance");
                        if v1234 ~= nil and v1234.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [8] = {
                    __text = "bodyaim", 
                    __active = function()
                        return v395.ragebot.safety.body_aim:get() == "Force";
                    end
                }, 
                [9] = {
                    __text = "safepoint", 
                    __active = function()
                        return v395.ragebot.safety.safe_points:get() == "Force";
                    end
                }, 
                [10] = {
                    __text = "duck", 
                    __active = function()
                        return v395.antiaim.misc.fake_duck:get();
                    end
                }
            }
        }, 
        __init = function(_, v1236)
            v400:new("ics.new.alpha", 1);
            if v470(v1236) and v417.scope_alignment:get() then
                v400:new("ics.new.scoped", 1);
            end;
        end, 
        __render = function(v1237, v1238, v1239, v1240, v1241)
            if v1238 == 0 then
                return ;
            else
                local v1242 = v1239 or 0;
                local v1243 = 1 - v1242;
                local v1244 = v393.scr * vector(0.5 + v1237.__align * v1242, 0.525);
                v1244.x = v1244.x + 1;
                local l___label_0 = v1237.__label;
                local l___font_0 = l___label_0.__font;
                local l___flags_0 = l___label_0.__flags;
                local v1248 = v402:wave(l___label_0.__text, v1240, v1241, v417.anim_speed:get() / 10);
                local v1249 = render.measure_text(l___font_0, l___flags_0, v1248);
                local v1250 = v1249 * 0.5;
                local v1251 = v1240:lerp(v1241, v463(0.5, v417.anim_speed:get() / 10));
                v1251.a = v1251.a * v1238;
                local v1252 = (v1244 - vector(v1250.x, 0) * v1243) - vector(0, -1);
                render.shadow(v1252 + vector(1, v1250.y + 1), v1252 + vector(v1249.x - 2, v1250.y + 1), v1251, v1237.__shadow);
                render.text(l___font_0, v1252 + vector(1, 0) * v1243, v1251, l___flags_0, v1248);
                v1244.y = v1244.y + v1249.y;
                local l___features_0 = v1237.__features;
                local l___font_1 = l___features_0.__font;
                local l___list_0 = l___features_0.__list;
                local v1256 = #l___list_0;
                render.push_clip_rect(vector(0, v1244.y), vector(v393.scr.x, v1244.y + (render.measure_text(l___font_1, l___flags_0, "~").y * v1256) * v1238), true);
                for v1257 = 1, v1256 do
                    local v1258 = l___list_0[v1257];
                    local v1259 = l_format_0("ics.new[%d].alpha", v1257);
                    local v1260, v1261 = v1258.__active();
                    if v1260 then
                        v400:new(v1259, 1);
                    end;
                    local v1262 = v400[v1259] or 0;
                    if not (v1262 == 0) then
                        local l_v1262_0 = v1262;
                        local l___text_0 = v1258.__text;
                        local v1265 = render.measure_text(l___font_1, l___flags_0, l___text_0);
                        local v1266 = v1265 * 0.5;
                        local v1267 = v1251:alpha_modulate(v1251.a * v1262);
                        local v1268 = l_v1262_0 ~= nil and l_v1262_0 ~= 1;
                        local v1269 = v1244 - vector(v1266.x, 0) * v1243;
                        v1269.y = v1269.y;
                        if v1268 then
                            local v1270 = v1269 + vector(v1265.x / 2);
                            render.push_clip_rect(v1270 - vector((v1265.x / 2) * l_v1262_0, 0), v1270 + vector((v1265.x / 2) * l_v1262_0, v1265.y), true);
                        end;
                        if v1261 then
                            v1267 = v399.red:alpha_modulate(v1267.a):lerp(v1267, v1261);
                        end;
                        render.text(l___font_1, v1269, v1267, l___flags_0, l___text_0);
                        if v1268 then
                            render.pop_clip_rect();
                        end;
                        v1244.y = v1244.y + (v1265.y - 2) * v1262;
                    end;
                end;
                render.pop_clip_rect();
                return ;
            end;
        end, 
        __draw = function(v1271, v1272, v1273)
            local v1274 = v400["ics.new.alpha"] or 0;
            local v1275 = v400["ics.new.scoped"] or 0;
            v1271:__render(l_max_0(0, v1274 - v1275), 0, v1272, v1273);
            v1271:__render(v1275, 1, v1272, v1273);
        end
    };
    v417.styles.Modern = {
        __capsule_body_yaw = 0, 
        __capsule_alpha = 1, 
        __capsule_ab = false, 
        __flags = "s", 
        __font = 2, 
        __label = v393.label:upper(), 
        __features = {
            __list = {
                [1] = {
                    __text = "DOUBLETAP", 
                    __color = v399.white, 
                    __active = function()
                        return v395.ragebot.main.double_tap:get(), rage.exploit:get();
                    end
                }, 
                [2] = {
                    __text = "PING", 
                    __color = color(132, 195, 16), 
                    __active = function()
                        local v1276 = v410:get("Fake Latency");
                        if v1276 ~= nil and v1276.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [3] = {
                    __text = "ONSHOT", 
                    __color = color(145, 165, 255), 
                    __active = function()
                        return v395.ragebot.main.hide_shots:get();
                    end
                }, 
                [4] = {
                    __text = "FREESTANDING", 
                    __color = color(130, 210, 15), 
                    __active = function()
                        return v408.freestanding.active;
                    end
                }, 
                [5] = {
                    __text = "DMG", 
                    __color = color(255, 195, 195), 
                    __active = function()
                        local v1277 = v410:get("Min. Damage");
                        if v1277 ~= nil and v1277.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [6] = {
                    __text = "HC", 
                    __color = color(255, 75, 75), 
                    __active = function()
                        local v1278 = v410:get("Hit Chance");
                        if v1278 ~= nil and v1278.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [7] = {
                    __text = "DUCK", 
                    __color = color(255, 255, 255), 
                    __active = function()
                        return v395.antiaim.misc.fake_duck:get();
                    end
                }, 
                [8] = {
                    __text = "BAIM", 
                    __color = color(255, 80, 80), 
                    __active = function()
                        return v395.ragebot.safety.body_aim:get() == "Force";
                    end
                }, 
                [9] = {
                    __text = "SAFE", 
                    __color = color(255, 80, 80), 
                    __active = function()
                        return v395.ragebot.safety.safe_points:get() == "Force";
                    end
                }
            }
        }, 
        __capsule = function(_, v1280, v1281, v1282, v1283, v1284, v1285)
            if not v1284 then
                v1284 = 1;
            end;
            render.shadow(v1280, v1281, v1282:alpha_modulate(v1282.a * v1285), 10, 0, 3);
            render.rect(v1280, v1281, color(17, 17, 17, (v1282.a * 0.8) * v1285), 3);
            v1280 = v1280 + 1;
            v1281 = v1281 - 1;
            if v1283 <= 0.01 then
                return ;
            else
                v1281.x = v452(v1280.x, v1281.x, l_min_0(1, v1283));
                v1282 = v1282:alpha_modulate(v1282.a * v1284);
                local v1286 = v1282:alpha_modulate(v1282.a * 0.3);
                render.gradient(v1280, v1281, v1282, v1282, v1286, v1286, 3);
                return ;
            end;
        end, 
        __init = function(_)
            v400:new("ics.modern.alpha", 1);
        end, 
        __render = function(v1288, v1289, v1290, v1291, v1292)
            if v1289 == 0 then
                return ;
            else
                local l___font_2 = v1288.__font;
                local l___flags_1 = v1288.__flags;
                local v1295 = v393.scr * vector(0.5, 0.52);
                v1295.x = v1295.x + 2;
                local v1296 = v399.white:alpha_modulate(v399.white.a * v1289);
                local l_v1292_0 = v1292;
                local v1298 = l_format_0("%s  %s", v1288.__label, v402:wave(v393.build:upper(), v1290, v1291, v417.anim_speed:get() / 10));
                local v1299 = render.measure_text(l___font_2, l___flags_1, v1298);
                render.text(l___font_2, v1295, v1296, l___flags_1, v1298);
                v1295.y = v1295.y + v1299.y;
                local v1300 = v1295:clone();
                local v1301 = vector(v1299.x - 1, 5);
                local v1302 = v408.antibrute:get();
                local v1303 = v400:new("ics.modern.body_yaw", (l_abs_0(v407.body_yaw)));
                local _ = v1292:alpha_modulate(v1296.a);
                local v1305 = v1302 ~= 0;
                if v1305 ~= v1288.__capsule_ab then
                    v1288.__capsule_ab = v1305;
                    v1288.__capsule_alpha = 0;
                end;
                v1288.__capsule_alpha = v400:lerp(v1288.__capsule_alpha, 1) * v1289;
                v1288:__capsule(v1300, v1300 + v1301, l_v1292_0, v1305 and v1302 or v444(v1303 / 57, 0, 1), v1288.__capsule_alpha, v1289);
                v1295.y = v1295.y + v1301.y;
                v1301 = v1288.__features.__list;
                v1302 = #v1301;
                local l_v1289_0 = v1289;
                v1295.y = v1295.y - 1;
                for v1307 = 1, v1302 do
                    local v1308 = v1301[v1307];
                    local v1309 = l_format_0("ics.modern[%d].alpha", v1307);
                    local v1310, v1311 = v1308.__active();
                    if v1310 then
                        v400:new(v1309, 1);
                    end;
                    local v1312 = v400[v1309] or 0;
                    if not (v1312 == 0) then
                        local l___text_1 = v1308.__text;
                        local l___color_0 = v1308.__color;
                        local v1315 = render.measure_text(l___font_2, l___flags_1, l___text_1);
                        if v1311 ~= nil then
                            l___color_0 = v399.red:lerp(l___color_0, v1311);
                        end;
                        render.text(l___font_2, v1295, l___color_0.alpha_modulate(l___color_0, (l___color_0.a * v1312) * l_v1289_0), l___flags_1, l___text_1);
                        v1295.y = v1295.y + (v1315.y - 3) * v1312;
                    end;
                end;
                return ;
            end;
        end, 
        __draw = function(v1316, v1317, v1318, v1319)
            v1316:__render(v400["ics.modern.alpha"] or 0, v1317, v1318, v1319);
        end
    };
    v417.styles.Legacy = {
        __font = 2, 
        __align = 0.005, 
        __state_alpha = 1, 
        __label = l_format_0("%s", v393.label:upper()), 
        __features = {
            __list = {
                [1] = {
                    __text = "BRUTE", 
                    __active = function()
                        return v408.antibrute:get() ~= 0;
                    end
                }, 
                [2] = {
                    __text = "PING", 
                    __active = function()
                        local v1320 = v410:get("Fake Latency");
                        if v1320 ~= nil and v1320.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [3] = {
                    __text = "DT", 
                    __active = function()
                        return v395.ragebot.main.double_tap:get(), rage.exploit:get();
                    end
                }, 
                [4] = {
                    __text = "DMG", 
                    __active = function()
                        local v1321 = v410:get("Min. Damage");
                        if v1321 ~= nil and v1321.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [5] = {
                    __text = "HC", 
                    __active = function()
                        local v1322 = v410:get("Hit Chance");
                        if v1322 ~= nil and v1322.item.active then
                            return true;
                        else
                            return ;
                        end;
                    end
                }, 
                [6] = {
                    __text = "FD", 
                    __color = color(255, 255, 255), 
                    __active = function()
                        return v395.antiaim.misc.fake_duck:get();
                    end
                }
            }
        }, 
        __under = {
            __padding = 1, 
            __list = {
                [1] = {
                    __text = "BODY", 
                    __clr = v399.red, 
                    __active = function()
                        return v395.ragebot.safety.body_aim:get() == "Force";
                    end
                }, 
                [2] = {
                    __text = "OS", 
                    __clr = color(171, 211, 255), 
                    __active = function()
                        return v395.ragebot.main.hide_shots:get();
                    end
                }, 
                [3] = {
                    __text = "FS", 
                    __clr = v399.white, 
                    __active = function()
                        return v408.freestanding.active;
                    end
                }, 
                [4] = {
                    __text = "SP", 
                    __clr = color(255, 195, 195), 
                    __active = function()
                        return v395.ragebot.safety.safe_points:get() == "Force";
                    end
                }
            }
        }, 
        __init = function(_, v1324)
            v400:new("ics.legacy.alpha", 1);
            if v470(v1324) and v417.scope_alignment:get() then
                v400:new("ics.legacy.scoped", 1);
            end;
        end, 
        __render = function(v1325, v1326, v1327, v1328, v1329)
            if v1326 == 0 then
                return ;
            else
                local v1330 = v1327 or 0;
                local v1331 = 1 - v1330;
                local v1332 = v393.scr * vector(0.5 + v1325.__align * v1330, 0.525);
                v1332.x = v1332.x + 1;
                local v1333 = v1328:alpha_modulate(255 * v1326);
                local v1334 = v1329:alpha_modulate(255 * (1 - v463(nil, 2) * 0.55)) * v1326;
                local v1335 = l_format_0("%s  \a%s%s", v1325.__label, v1334:to_hex(), v393.build:upper());
                local l___font_3 = v1325.__font;
                local v1337 = "s";
                local v1338 = render.measure_text(l___font_3, v1337, v1335);
                local v1339 = v1338 * 0.5;
                local v1340 = v1332 - vector(v1339.x) * v1331;
                render.shadow(v1340 + vector(2, v1339.y), v1340 + vector(v1338.x - 4, v1339.y), v1334, 30, 0, 0);
                render.text(l___font_3, v1340, v1333, v1337, v1335);
                v1332.y = v1332.y + (v1338.y - 4);
                local v1341 = v407.state:upper();
                v1338 = render.measure_text(l___font_3, v1337, v1341);
                v1340 = v1332 - vector((v1338 * 0.5).x) * v1331;
                if v1341 ~= v1325.__last_state then
                    v1325.__last_state = v1341;
                    v1325.__state_alpha = 0;
                else
                    v1325.__state_alpha = v400:lerp(v1325.__state_alpha, 1);
                end;
                render.text(l___font_3, v1340, v1333:alpha_modulate(v1325.__state_alpha * v1333.a), v1337, v1341);
                v1332.y = v1332.y + (v1338.y - 4);
                local l___list_1 = v1325.__features.__list;
                for v1343 = 1, #l___list_1 do
                    local v1344 = l___list_1[v1343];
                    local v1345 = l_format_0("ics.legacy.features[%d].alpha", v1343);
                    local v1346, v1347 = v1344.__active();
                    if v1346 then
                        v400:new(v1345, 1);
                    end;
                    local v1348 = (v400[v1345] or 0) * v1326;
                    if not (v1348 == 0) then
                        local l___text_2 = v1344.__text;
                        local v1350 = render.measure_text(l___font_3, v1337, l___text_2);
                        local v1351 = v1350 * 0.5;
                        local l_white_0 = v399.white;
                        if v1347 ~= nil then
                            l_white_0 = v399.red:lerp(l_white_0, v1347);
                        end;
                        render.text(l___font_3, v1332 - vector(v1351.x) * v1331, l_white_0.alpha_modulate(l_white_0, l_white_0.a * v1348), v1337, l___text_2);
                        v1332.y = v1332.y + (v1350.y - 4) * v1348;
                    end;
                end;
                local l___under_0 = v1325.__under;
                local l___list_2 = l___under_0.__list;
                local v1355 = #l___list_2;
                local v1356 = 0;
                for v1357 = 1, v1355 do
                    local v1358 = render.measure_text(l___font_3, v1337, l___list_2[v1357].__text);
                    if v1357 ~= 1 then
                        v1356 = v1356 + l___under_0.__padding;
                    end;
                    v1356 = v1356 + v1358.x;
                end;
                local v1359 = v1332 - vector(v1356 * 0.5) * v1331;
                v1356 = 0;
                for v1360 = 1, v1355 do
                    local v1361 = l___list_2[v1360];
                    local v1362 = l_format_0("ics.legacy.under[%d].alpha", v1360);
                    if v1361.__active() then
                        v400:new(v1362, 1);
                    end;
                    local v1363 = (v400[v1362] or 0) * v1326;
                    local v1364 = l___list_2[v1360];
                    local l___text_3 = v1364.__text;
                    local v1366 = render.measure_text(l___font_3, v1337, l___text_3);
                    if v1360 ~= 1 then
                        v1356 = v1356 + l___under_0.__padding;
                    end;
                    render.text(l___font_3, v1359 + vector(v1356), color(255, 75 * v1326):lerp(v1364.__clr, v1363), v1337, l___text_3);
                    v1356 = v1356 + v1366.x;
                end;
                return ;
            end;
        end, 
        __draw = function(v1367, v1368, v1369)
            v1367:__render(v400["ics.legacy.alpha"] or 0, v400["ics.legacy.scoped"] or 0, v1368, v1369);
        end
    };
    v417.render = function(v1370)
        local v1371 = l_get_local_player_0();
        local v1372 = v417.styles[v1370.controller:get()];
        if (v1372 ~= nil and v1371 ~= nil) and v1371:is_alive() then
            v1372:__init(v1371);
        end;
        local v1373 = v417.primary_color:get();
        local v1374 = v417.secondary_color:get();
        local v1375 = v417.tertiary_color:get();
        v1373 = v1373:alpha_modulate(255);
        v1374 = v1374:alpha_modulate(255);
        v1375 = v1375:alpha_modulate(255);
        for _, v1377 in pairs(v417.styles) do
            v1377:__draw(v1373, v1374, v1375);
        end;
    end;
    v417.scope_alignment:depend(function()
        return v417.controller:get() ~= "Modern";
    end);
    v417.anim_speed:depend(function()
        return v417.controller:get() ~= "Legacy";
    end);
    v417.tertiary_color:depend(function()
        return v417.controller:get() == "Modern";
    end);
    v418.controller = v403("MA", "szController", v405.groups.features.screen:combo("Manual Arrows"));
    v418.styles = v405:combo_control(v418.controller, {
        [1] = "Off"
    });
    v418.gear = v418.controller:create();
    v418.controller:dependency(function(v1378, v1379)
        return v1378.branch ~= v1379.branch or v1378:get() ~= "Off";
    end);
    v418.hide_when_scoped = v403("MA", "bHideWhenScoped", v418.gear:switch("Hide when Scoped"));
    v418.primary_color = v403("MA", "clrPrimary", v418.gear:color_picker("Primary Color"));
    v418.secondary_color = v403("MA", "clrSecondary", v418.gear:color_picker("Secondary Color", color(17, 17, 17, 128)));
    v418.get_position = function(_, v1381, v1382)
        local v1383 = v393.center:clone();
        local v1384 = vector();
        if v1381 ~= nil then
            v1384.x = v1384.x + v1381 * v393.offset;
        end;
        if v1382 ~= nil then
            v1384.y = v1384.y + v1382 * v393.offset;
        end;
        return v1383 + v1384;
    end;
    v418.get_manual_yaw = function(_)
        return v408.manual_yaw.controller:get();
    end;
    v418.styles.Triangle = {
        __size = 12 * v393.offset, 
        __init = function(_, v1387)
            if not v418.hide_when_scoped:get() or not v470(v1387) then
                v400:new("ma.triangle.alpha", 1);
            end;
            local v1388 = v418:get_manual_yaw();
            if v1388 == "Left" then
                v400:new("ma.triangle.left", 1);
            end;
            if v1388 == "Right" then
                v400:new("ma.triangle.right", 1);
            end;
        end, 
        __draw = function(v1389, v1390, v1391)
            local v1392 = v400["ma.triangle.alpha"] or 0;
            if v1392 == 0 then
                return ;
            else
                local v1393 = 40;
                local v1394 = vector(1, 0.66) * v1389.__size;
                local v1395 = v1391:lerp(v1390, v400["ma.triangle.left"] or 0);
                v1395.a = v1395.a * v1392;
                if not (v1395 == 0) then
                    local v1396 = v418:get_position(-v1393) + vector(1, 0);
                    render.poly(v1395, v1396 + vector(0, -v1394.y), v1396 + vector(-v1394.x, 0), v1396 + vector(0, v1394.y));
                end;
                v1395 = v1391:lerp(v1390, v400["ma.triangle.right"] or 0);
                v1395.a = v1395.a * v1392;
                if not (v1395 == 0) then
                    local v1397 = v418:get_position(v1393);
                    render.poly(v1395, v1397 + vector(0, -v1394.y), v1397 + vector(v1394.x, 0), v1397 + vector(0, v1394.y));
                end;
                return ;
            end;
        end
    };
    v418.styles.Simple = {
        __flags = "s", 
        __font = render.load_font("Verdana", 19, "ab"), 
        __init = function(_, v1399)
            if not v418.hide_when_scoped:get() or not v470(v1399) then
                v400:new("ma.simple.alpha", 1);
            end;
            local v1400 = v418:get_manual_yaw();
            if v1400 == "Left" then
                v400:new("ma.simple.left", 1);
            end;
            if v1400 == "Right" then
                v400:new("ma.simple.right", 1);
            end;
        end, 
        __draw = function(v1401, v1402, v1403)
            local v1404 = v400["ma.simple.alpha"] or 0;
            if v1404 == 0 then
                return ;
            else
                local v1405 = 40;
                local l___font_4 = v1401.__font;
                local l___flags_2 = v1401.__flags;
                local v1408 = v1403:lerp(v1402, v400["ma.simple.left"] or 0);
                v1408.a = v1408.a * v1404;
                if not (v1408.a == 0) then
                    local v1409 = v418:get_position(-v1405) + vector(1, 0);
                    local v1410 = "<";
                    local v1411 = render.measure_text(l___font_4, l___flags_2, v1410);
                    render.text(l___font_4, v1409 - vector(v1411.x, v1411.y * 0.5), v1408, l___flags_2, v1410);
                end;
                v1408 = v1403:lerp(v1402, v400["ma.simple.right"] or 0);
                v1408.a = v1408.a * v1404;
                if not (v1408.a == 0) then
                    local v1412 = v418:get_position(v1405);
                    local v1413 = ">";
                    render.text(l___font_4, v1412 - vector(0, render.measure_text(l___font_4, l___flags_2, v1413).y * 0.5), v1408, l___flags_2, v1413);
                end;
                return ;
            end;
        end
    };
    v418.render = function(v1414)
        local v1415 = l_get_local_player_0();
        local v1416 = v418.styles[v1414.controller:get()];
        if (v1416 ~= nil and v1415 ~= nil) and v1415:is_alive() then
            v1416:__init(v1415);
        end;
        local v1417 = v418.primary_color:get();
        local v1418 = v418.secondary_color:get();
        for _, v1420 in pairs(v418.styles) do
            v1420:__draw(v1417, v1418);
        end;
    end;
    v419.color = v403("VISUALS", "clrColor", v405.groups.features.interface:color_picker("Accent Color", v399.white));
    v419.truebg = v403("VISUALS", "bBg", v405.groups.features.interface:switch("Use Background Accent Color", false));
    v419.style = v403("VISUALS", "szStyle", v405.groups.features.interface:combo("Style", {
        [1] = "Renewed", 
        [2] = "Old"
    }));
    v654 = v419.style:create();
    v419.glow = v403("VISUALS", "bGlow", v654:switch("Glow", false));
    v419.rounding = v403("VISUALS", "iRounding", v654:slider("Rounding", 1, 8, 4));
    v419.logof = v403("VISUALS", "clrColorLogoFirst", v654:color_picker("Logo First", v399.white));
    v419.logos = v403("VISUALS", "clrColorLogoSecond", v654:color_picker("Logo Second", v399.white));
    v419.rounding:depend(function()
        return v419.style:get() == "Renewed";
    end);
    v419.truebg:depend(function()
        return v419.style:get() == "Renewed";
    end);
    v419.logof:depend(function()
        return v420.controller:get();
    end);
    v419.logos:depend(function()
        return v420.controller:get();
    end);
    v419.Renewed = function(v1421, v1422, v1423, v1424, v1425)
        if not v1425 then
            v1425 = 1;
        end;
        local v1426 = v1421.rounding:get();
        local v1427 = v1421.glow:get();
        local v1428 = v1421.truebg:get();
        v1422 = v1422 - 1;
        v1423 = v1423 + 1;
        local v1429 = 255 * v1425;
        local l_a_0 = v1424.a;
        local v1431 = v1424:alpha_modulate(v1429);
        local v1432 = v1431:alpha_modulate(v1431.a * 0.5);
        local v1433 = v1431:alpha_modulate(v1431.a * 0.7);
        local v1434 = v1423 - v1422;
        if v1427 then
            render.shadow(v1422, v1423 + vector(-1), v1433, 50, 0, v1426);
        end;
        local v1435 = nil;
        if v1428 then
            v1435 = color(v1424.r, v1424.g, v1424.b, l_a_0);
        else
            v1435 = color(17, l_a_0);
        end;
        local v1436 = v1435.alpha_modulate(v1435, l_a_0 * 0.25);
        render.gradient(v1422 + vector(0, v1426), v1423, v1435, v1435, v1436, v1436);
        render.rect(v1422 + vector(v1426), v1422 + vector(v1434.x - v1426, v1426), v1435);
        render.circle(v1422 + v1426, v1435, v1426, 180, 0.25);
        render.circle(v1422 + vector(v1434.x - v1426, v1426), v1435, v1426, 270, 0.25);
        render.circle_outline(v1422 + v1426, v1432, v1426, 180, 0.25, 0);
        render.circle_outline(v1422 + vector(v1434.x - v1426, v1426), v1432, v1426, 270, 0.25, 0);
        render.rect(v1422 + vector(v1426), v1422 + vector(v1434.x - v1426, 1), v1432);
        render.rect(v1422 + vector(0, v1434.y - 1), v1423, v1431);
        render.gradient(v1422 + vector(0, v1426), v1422 + vector(1, v1434.y - 1), v1432, v1432, v1431, v1431);
        render.gradient(v1422 + vector(v1434.x - 1, v1426), v1422 + vector(v1434.x, v1434.y - 1), v1432, v1432, v1431, v1431);
    end;
    v419.Old = function(v1437, v1438, v1439, v1440, v1441)
        if not v1441 then
            v1441 = 1;
        end;
        local v1442 = 255 * v1441;
        local l_a_1 = v1440.a;
        local v1444 = v1437.glow:get();
        local v1445 = v1440:alpha_modulate(v1442);
        local v1446 = v1445:alpha_modulate(v1445.a * 0.5);
        if v1444 then
            render.shadow(vector(v1438.x + 1, v1438.y - 1), vector(v1439.x - 1, v1439.y - 1), v1446, 50, 0, 0);
        end;
        render.rect(vector(v1438.x + 1, v1438.y + 1), vector(v1439.x - 1, v1439.y - 1), color(17, l_a_1), 0);
        render.rect(vector(v1438.x + 1, v1438.y - 1), vector(v1439.x - 1, v1438.y + 1), v1445, 0);
    end;
    v419.draw = function(v1447, v1448, v1449, v1450, v1451)
        v1447[v1447.style:get()](v1447, v1448, v1449, v1450, v1451);
    end;
    v654 = 1;
    v655 = "s";
    v656 = 3;
    v657 = vector(10, 8);
    v420.controller = v403("VISUALS", "bWatermark", v405.groups.features.interface:switch("Watermark"));
    v420.custom_name = v403("VISUALS", "bWatermark.szName", v420.controller:create():input("Custom Name")):depend(v420.controller);
    v420.width = nil;
    v420.pre = function(_)
        if not v420.controller:get() then
            return ;
        else
            v400:new("watermark.alpha", 1);
            return ;
        end;
    end;
    do
        local l_v654_7, l_v655_7, l_v656_6, l_v657_5 = v654, v655, v656, v657;
        v420.post = function(v1457)
            local v1458 = v400["watermark.alpha"] or 0;
            if v1458 == 0 then
                return ;
            else
                local v1459 = 255 * v1458;
                local v1460 = v1457.custom_name:get();
                local _ = v399.white:alpha_modulate(v1459);
                local v1462 = v419.color:get():clone();
                local v1463 = v419.logof:get():clone();
                local v1464 = v419.logos:get():clone();
                v1463.a = 255;
                v1464.a = 255;
                v1462.a = v1462.a * v1458;
                if #v1460 == 0 then
                    v1460 = v393.user;
                end;
                local v1465 = {
                    [1] = l_format_0("%s\aDEFAULT", v402:wave(l_format_0("%s ~ %s", v393.label, v393.build), v1463, v1464)), 
                    [2] = v1460, 
                    [3] = l_format_0("\a%s%s", v1463:alpha_modulate(v1459):to_hex(), common.get_date("%I:%M")) .. l_format_0("\aDEFAULT%s", common.get_date("%p"):lower())
                };
                if globals.is_in_game then
                    local v1466 = l_net_channel_0();
                    if not (v1466 == nil) then
                        if v1466.is_loopback then
                            l_insert_0(v1465, #v1465, "local");
                        else
                            local v1467 = v438(v1466.latency[1] * 1000);
                            if v1467 > 0 then
                                l_insert_0(v1465, #v1465, l_format_0("\a%s%d\aDEFAULTms", v1463:alpha_modulate(v1459):to_hex(), v1467));
                            end;
                        end;
                    end;
                end;
                local v1468 = table.concat(v1465, " \194\183 ");
                local v1469 = render.measure_text(l_v654_7, l_v655_7, v1468);
                local v1470 = vector(v393.scr.x * 0.5, v393.scr.y - l_v656_6);
                local v1471 = v1469 + l_v657_5;
                v1457.width = v400:lerp(v1457.width, v1471.x);
                v1471.x = v1457.width;
                v1470 = v1470 - vector(v1471.x * 0.5, v1471.y);
                v419:draw(v1470, v1470 + v1471, v1462, v1458);
                render.push_clip_rect(v1470, v1470 + v1471);
                v1470.x = v1470.x + 1;
                v1470.y = v1470.y - 1;
                render.text(l_v654_7, v1470 + l_v657_5 * 0.5, v399.white:alpha_modulate(v1459), l_v655_7, v1468);
                render.pop_clip_rect();
                return ;
            end;
        end;
        v420.render = function(v1472)
            v1472:pre();
            v1472:post();
        end;
    end;
    v654 = v411:new("keybinds", v393.scr * 0.5);
    v655 = 1;
    v656 = "s";
    v657 = {
        [1] = "holding", 
        [2] = "toggled"
    };
    v658 = vector(90, 8);
    v421.controller = v403("VISUALS", "bKeybinds", v405.groups.features.interface:switch("Keybinds"));
    v659 = v421.controller:create();
    v421.width = 121;
    v421.pre = function(_, v1474)
        if not v421.controller:get() then
            return ;
        elseif not v468() and not v1474.active then
            return ;
        else
            v400:new("keybinds.alpha", 1);
            return ;
        end;
    end;
    do
        local l_v654_8, l_v655_8, l_v656_7, l_v657_6, l_v658_3 = v654, v655, v656, v657, v658;
        v421.get = function(_)
            local v1481 = 0;
            local v1482 = false;
            local v1483 = {};
            local v1484 = v410:get();
            for v1485 = 1, #v1484 do
                local v1486 = v1484[v1485];
                if v1486.active then
                    v1482 = true;
                end;
                local l_name_0 = v1486.name;
                local l_value_0 = v1486.value;
                local l_alpha_0 = v410:get(l_name_0).alpha;
                if not (l_alpha_0 == 0) then
                    if type(l_value_0) == "boolean" then
                        l_value_0 = l_v657_6[v1486.mode];
                    end;
                    if type(l_value_0) == "table" then
                        for v1490 = 1, #l_value_0 do
                            l_value_0[v1490] = l_value_0[v1490]:sub(1, 1);
                        end;
                        l_value_0 = table.concat(l_value_0, ", ");
                    end;
                    l_value_0 = l_format_0("[%s]", l_value_0):lower();
                    local v1491 = render.measure_text(l_v655_8, l_v656_7, (l_format_0("%s%s", l_name_0, l_value_0)));
                    l_insert_0(v1483, {
                        name = l_name_0, 
                        value = l_value_0, 
                        alpha = l_alpha_0
                    });
                    v1481 = l_max_0(v1481, v1491.x);
                end;
            end;
            return {
                list = v1483, 
                active = v1482, 
                max_width = v1481
            };
        end;
        v421.post = function(v1492, v1493)
            local v1494 = v400["keybinds.alpha"] or 0;
            if v1494 == 0 then
                return ;
            else
                v1494 = v1494 * l_v654_8.alpha;
                local v1495 = v419.color:get():clone();
                v1495.a = v1495.a * v1494;
                local v1496 = 255 * v1494;
                local v1497 = "keybinds";
                local v1498 = render.measure_text(l_v655_8, l_v656_7, v1497);
                local l_pos_1 = l_v654_8.pos;
                local v1500 = v1498 + l_v658_3;
                local _ = l_max_0(v1493.max_width + 20, 121);
                v1492.width = v400:lerp(v1492.width, l_max_0(v1493.max_width + 20, v1500.x), true);
                v1500.x = v438(v1492.width);
                v419:draw(l_pos_1, l_pos_1 + v1500, v1495, v1494);
                render.text(l_v655_8, (l_pos_1 + v1500 * 0.5) - vector(0, 1), v399.white:alpha_modulate(v1496), l_format_0("%sc", l_v656_7), v1497);
                local l_list_0 = v1493.list;
                local v1503 = l_pos_1 + vector(0, v1500.y);
                for v1504 = 1, #l_list_0 do
                    local v1505 = l_list_0[v1504];
                    local v1506 = v399.white:alpha_modulate(v1496 * v1505.alpha);
                    render.text(l_v655_8, v1503 + 3, v1506, l_v656_7, v1505.name);
                    render.text(l_v655_8, v1503 + vector(v1500.x - 3, 3), v1506, l_format_0("%sr", l_v656_7), v1505.value);
                    v1503.y = v1503.y + v438((v1498.y + 3) * v1505.alpha);
                end;
                l_v654_8.size = v1500;
                l_v654_8:update();
                return ;
            end;
        end;
        v421.render = function(v1507)
            local v1508 = v1507:get();
            v1507:pre(v1508);
            v1507:post(v1508);
        end;
    end;
    is_grenade_being_thrown = function(v1509, _)
        return v1509.m_bPinPulled;
    end;
    v423.controller = v403("RAGE", "szExploitTweaks", v405.groups.features.ragebot:selectable("Exploit Tweaks", {
        [1] = "Force Defensive Air", 
        [2] = "Fake Lag on Stand", 
        [3] = "Fake Lag on Crouch", 
        [4] = "Off Fake Lag on DT", 
        [5] = "Fix throw Nades", 
        [6] = "Ignore shift in Air Strafe"
    }));
    v423.shutdown = function(_)
        v395.ragebot.main.lag_options:override();
        v395.ragebot.main.options:override();
        v395.antiaim.fakelag.limit:override();
    end;
    v423.createmove = function(v1512, v1513)
        v1512:shutdown();
        if (v407.onground and not v407.crouch) and v423.controller:get("Off Fake Lag on DT") then
            if v395.antiaim.misc.fake_duck:get() then
                return ;
            elseif v395.ragebot.main.double_tap:get() then
                v395.antiaim.fakelag.limit:override(1);
            else
                v395.antiaim.fakelag.limit:override();
            end;
        else
            v395.antiaim.fakelag.limit:override();
        end;
        if v423.controller:get("Fix throw Nades") then
            local v1514 = l_get_local_player_0();
            if v1514 == nil then
                return ;
            else
                local v1515 = v1514:get_player_weapon();
                if not v1515 then
                    return ;
                elseif ({
                    weapon_flashbang = 1, 
                    weapon_incgrenade = 1, 
                    weapon_molotov = 1, 
                    weapon_smokegrenade = 1, 
                    weapon_hegrenade = 1
                })[v1515:get_weapon_info().console_name] and is_grenade_being_thrown(v1515, v1513) then
                    v395.ragebot.main.lag_options:override("Disabled");
                    return ;
                end;
            end;
        end;
        if v407.onground then
            if v407.crouch and v423.controller:get("Fake Lag on Crouch") then
                v395.ragebot.main.lag_options:override("Always On");
                v395.ragebot.main.options:override("Break LC");
                return ;
            elseif not v407.moving and v423.controller:get("Fake Lag on Stand") then
                v395.ragebot.main.options:override("Break LCf");
                return ;
            else
                return ;
            end;
        else
            if v423.controller:get("Force Defensive Air") then
                v395.ragebot.main.lag_options:override("Always On");
                v395.ragebot.main.options:override("Break LC");
            end;
            if v423.controller:get("Ignore shift in Air Strafe") and v407.velocity > 30 then
                v1513.in_speed = false;
                return ;
            else
                return ;
            end;
        end;
    end;
    v654 = {
        Submachines = 2, 
        Pistols = 1, 
        Knife = 0, 
        Other = 10, 
        Bomb = 7, 
        Grenades = 9, 
        Machineguns = 6, 
        Snipers = 5, 
        Shotguns = 4, 
        Rifles = 3
    };
    v655 = {
        [1] = "Knife", 
        [2] = "Pistols", 
        [3] = "Submachines", 
        [4] = "Rifles", 
        [5] = "Shotguns", 
        [6] = "Snipers", 
        [7] = "Machineguns", 
        [8] = "Bomb", 
        [9] = "Grenades", 
        [10] = "Other"
    };
    v424.controller = v403("RAGE", "bDischargeExploit", v405.groups.features.ragebot:switch("Discharge Exploit"));
    v424.weapons = v403("RAGE", "sDischargeWeapons", v424.controller:create():selectable("Weapons", v655)):depend(v424.controller);
    v657 = {};
    do
        local l_v654_9, l_v655_9, l_v657_7 = v654, v655, v657;
        v424.weapons.ref:set_callback(function()
            local v1519 = v424.weapons:get();
            for v1520 = 1, #l_v655_9 do
                local v1521 = l_v655_9[v1520];
                l_v657_7[l_v654_9[v1521]] = v448(v1519, v1521);
            end;
        end, true);
        v424.createmove = function(v1522)
            if not v1522.controller:get() or not v395.ragebot.main.double_tap:get() then
                return ;
            elseif v407.onground or rage.exploit:get() ~= 1 then
                return ;
            else
                local v1523 = l_get_local_player_0();
                if v1523 == nil then
                    return ;
                else
                    local v1524 = v1523:get_player_weapon();
                    if v1524 == nil then
                        return ;
                    else
                        local l_weapon_type_0 = v1524:get_weapon_info().weapon_type;
                        if not l_v657_7[l_weapon_type_0] then
                            if l_v657_7[l_weapon_type_0] == nil then
                                if not l_v657_7.Other then
                                    return ;
                                end;
                            else
                                return ;
                            end;
                        end;
                        for _, v1527 in pairs((l_get_players_0(true, false))) do
                            cvar.sv_maxusrcmdprocessticks:int(16);
                            if v1527:is_alive() and v1527:is_visible() then
                                return rage.exploit:force_teleport();
                            end;
                        end;
                        return ;
                    end;
                end;
            end;
        end;
    end;
    v654 = v395.ragebot.selection;
    v655 = {};
    v656 = 16;
    v657 = {
        stomach = 2
    };
    v425.controller = v403("RAGE", "bBodyAimIfLethal", v405.groups.features.ragebot:switch("\aB6B665FFBody Aim if Lethal"));
    v658 = v425.controller:create();
    v425.calculate_twoshot = v403("RAGE", "bCalculateTwoshot", v658:switch("Calculate two-shot")):depend(v425.controller);
    v425.calculate_damage = v403("RAGE", "bCalculateDamage", v658:switch("Force target damage")):depend(v425.controller);
    v425.calculate_twoshot:tooltip("Will calculate damage x2, if the weapon can fire twice per second");
    v425.calculate_damage:tooltip("Will override minimum damage on target hp value");
    do
        local l_v654_10, l_v655_10, l_v656_8, l_v657_8 = v654, v655, v656, v657;
        v425.shutdown = function(_)
            l_v654_10.hitboxes:override();
            l_v654_10.minimum_damage:override();
        end;
        v425.extrapolate = function(_, v1534, v1535, v1536)
            local l_tickinterval_0 = globals.tickinterval;
            local v1538 = cvar.sv_gravity:float() * l_tickinterval_0;
            local v1539 = cvar.sv_jump_impulse:float() * l_tickinterval_0;
            local l_v1535_0 = v1535;
            local l_v1535_1 = v1535;
            local l_m_vecVelocity_0 = v1534.m_vecVelocity;
            local v1543 = l_m_vecVelocity_0.z > 0 and -v1538 or v1539;
            for _ = 1, v1536 do
                l_v1535_1 = l_v1535_0;
                l_v1535_0 = vector(l_v1535_0.x + l_m_vecVelocity_0.x * l_tickinterval_0, l_v1535_0.y + l_m_vecVelocity_0.y * l_tickinterval_0, l_v1535_0.z + (l_m_vecVelocity_0.z + v1543) * l_tickinterval_0);
                if utils.trace_line(l_v1535_1, l_v1535_0, v1534).fraction <= 0.99 then
                    return l_v1535_1;
                end;
            end;
            return l_v1535_0;
        end;
        v425.calc = function(v1545, v1546)
            l_v655_10 = {};
            if not v425.controller:get() then
                return ;
            else
                local v1547 = l_get_local_player_0();
                if not (v1547 ~= nil) or not v1547:is_alive() then
                    return ;
                else
                    local v1548 = v1547:get_player_weapon();
                    if v1548 == nil then
                        return ;
                    else
                        local l_m_iClip1_0 = v1548.m_iClip1;
                        local v1550 = v1548:get_weapon_info();
                        if not (l_m_iClip1_0 ~= -1) or v1550 == nil then
                            return ;
                        else
                            local v1551 = l_m_iClip1_0 >= 2 and 1 / v1550.cycle_time > 2;
                            local v1552 = 1;
                            if ((v425.calculate_twoshot:get() and v395.ragebot.main.double_tap:get()) and rage.exploit:get() == 1) and v1551 then
                                v1552 = 2;
                            end;
                            local v1553 = {
                                [1] = v1547
                            };
                            for _, v1555 in pairs(entity.get_players()) do
                                if not v1555:is_enemy() then
                                    table.insert(v1553, v1555);
                                end;
                            end;
                            local v1556 = v1547:get_origin();
                            l_get_players_0(true, false, function(v1557)
                                if not v1557:is_alive() then
                                    return ;
                                elseif v1557:is_dormant() then
                                    return ;
                                else
                                    local v1558 = v1557:get_resource();
                                    if not v1558 then
                                        return ;
                                    else
                                        local l_m_iArmor_0 = v1558.m_iArmor;
                                        local l_m_iHealth_1 = v1557.m_iHealth;
                                        local v1561 = (v1550.damage * 1.25) * math.pow(v1550.range_modifier, (v1556 - v1557:get_eye_position()):length() * 0.002);
                                        if l_m_iArmor_0 > 0 then
                                            v1561 = (v1561 * v1550.armor_ratio) * 0.5;
                                        end;
                                        if l_m_iHealth_1 <= math.ceil(v1561) * v1552 then
                                            l_v655_10[v1557:get_index()] = true;
                                        end;
                                        return ;
                                    end;
                                end;
                            end);
                            return ((function(v1562)
                                if not v1562 or not v1562:is_alive() then
                                    return ;
                                else
                                    local v1563 = v1547:get_eye_position();
                                    local l_m_iHealth_2 = v1562.m_iHealth;
                                    local v1565 = v1545:extrapolate(v1547, v1563, l_v656_8);
                                    local v1566 = 0;
                                    for _, v1568 in pairs(l_v657_8) do
                                        local v1569 = v1562:get_hitbox_position(v1568);
                                        local v1570 = v1545:extrapolate(v1562, v1569, l_v656_8);
                                        local v1571 = utils.trace_bullet(v1547, v1563, v1569, v1553);
                                        if v1566 < v1571 then
                                            v1566 = v1571;
                                        end;
                                        local v1572 = utils.trace_bullet(v1547, v1563, v1570, v1553);
                                        if v1566 < v1572 then
                                            v1566 = v1572;
                                        end;
                                        local v1573 = utils.trace_bullet(v1547, v1565, v1569, v1553);
                                        if v1566 < v1573 then
                                            v1566 = v1573;
                                        end;
                                        local v1574 = utils.trace_bullet(v1547, v1565, v1570, v1553);
                                        if v1566 < v1574 then
                                            v1566 = v1574;
                                        end;
                                    end;
                                    if l_m_iHealth_2 <= v1566 * v1552 then
                                        return l_ceil_0(v1566 - 0.5);
                                    else
                                        return ;
                                    end;
                                end;
                            end)(v1546));
                        end;
                    end;
                end;
            end;
        end;
        v425.target = function(v1575)
            local v1576 = entity.get_threat();
            local v1577 = v1575:calc(v1576);
            if not ((v1576 ~= nil and not v1576:is_dormant()) and v1577) or v1577 == 0 then
                return ;
            else
                l_v654_10.hitboxes:override({
                    [1] = "Stomach"
                });
                if v1575.calculate_damage:get() then
                    l_v654_10.minimum_damage:override(v1577);
                end;
                return true;
            end;
        end;
        v425.net_update_end = function(v1578)
            if not v1578:target() then
                return v1578:shutdown();
            else
                return ;
            end;
        end;
        esp.enemy:new_text(l_format_0("(%s) Baimable", v393.label:upper()), "BAIM", function(v1579)
            if l_v655_10[v1579:get_index()] then
                return "BAIM";
            else
                return ;
            end;
        end);
    end;
    v654 = 0;
    esp.enemy:new_text(l_format_0("(%s) Custom Resolver", v393.label:upper()), "Resolved Angle", function(v1580)
        if v1580:is_dormant() then
            return ;
        else
            local v1581 = v1580.m_flPoseParameter[12] * 120 - 60;
            v654 = v452(v654, v1581 > 58 and 58 or (v1581 < -58 and -58 or v1581), 0.045);
            local v1582 = "(\194\17758\194\176)";
            if v654 >= 57 then
                v1582 = "";
            end;
            return ("CORRECTED: %.1f\194\176 %s"):format(v654, v1582);
        end;
    end);
    v655 = 0;
    v656 = {
        [1] = "\aDEFAULT", 
        [2] = "\a%x%x%x%x%x%x%x%x", 
        [3] = "\a%x%x%x%x%x%x"
    };
    v657 = {
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
    v658 = {
        hegrenade = "Naded", 
        knife = "Knifed", 
        inferno = "Burned"
    };
    do
        local l_v655_11, l_v656_9, l_v657_9, l_v658_4, l_v659_4, l_v660_2, l_v661_3, l_v663_2 = v655, v656, v657, v658, v659, v660, v661, v663;
        l_v659_4 = function(v1591)
            return l_v657_9[v1591] or "?";
        end;
        l_v660_2 = function(v1592)
            for v1593 = 1, #l_v656_9 do
                v1592 = v1592.gsub(v1592, l_v656_9[v1593], "");
            end;
            return v1592;
        end;
        l_v661_3 = function(v1594)
            return (v1594:gsub("(\a%x%x%x%x%x%x)%x%x", "%1"));
        end;
        v426.controller = v403("RAGE", "bRagebotLogs", v405.groups.features.ragebot:switch("Ragebot Logs"));
        v662 = v426.controller:create();
        v426.controller:set_callback(function(v1595)
            if not v1595:get() then
                v395.misc.main.log_events:override();
            else
                v395.misc.main.log_events:override({});
            end;
        end, true);
        v426.draw = v403("RAGE", "bRagebotLogs.szDraw", v662:selectable("Draw", {
            [1] = "On Screen", 
            [2] = "Custom Notify", 
            [3] = "Console"
        })):depend(v426.controller);
        v426.hit_color = v403("RAGE", "bRagebotLogs.clrHit", v662:color_picker("Hit Color")):depend(v426.controller);
        v426.miss_color = v403("RAGE", "bRagebotLogs.clrMiss", v662:color_picker("Miss Color")):depend(v426.controller);
        v426.death_color = v403("RAGE", "bRagebotLogs.clrDeath", v662:color_picker("Death Color")):depend(v426.controller);
        l_v663_2 = {};
        events.aim_fire:set(function(v1596)
            l_v663_2[v1596.id] = v1596.target:get_name();
        end);
        v426.on_screen = function(_, ...)
            if not v426.draw:get("On Screen") then
                return ;
            else
                print_dev(...);
                return ;
            end;
        end;
        v426.custom_notify = function(_, ...)
            if not v426.draw:get("Custom Notify") then
                return ;
            else
                v412:new(...);
                return ;
            end;
        end;
        v426.console = function(_, ...)
            if not v426.draw:get("Console") then
                return ;
            else
                l_print_raw_0(...);
                return ;
            end;
        end;
        v426.aim_fire = function(_, _)
            l_v655_11 = v407.body_yaw;
        end;
        v426.player_hurt = function(v1602, v1603, _, v1605, _)
            if not v1602.controller:get() then
                return ;
            else
                local v1607 = l_v658_4[v1603.weapon];
                if v1607 == nil then
                    return ;
                else
                    local v1608 = v426.hit_color:get():alpha_modulate(255):to_hex();
                    local v1609 = l_format_0("%s \a%s%s\aDEFAULT for \a%s%s \aDEFAULTdamage", v1607, v1608, v1605:get_name(), v1608, v1603.dmg_health);
                    v1602:on_screen(l_v660_2(v1609));
                    v1602:console(l_v661_3(l_format_0("\a%s[%s.lua] \a808080\194\187 \aDEFAULT%s", v1608, v393.label, v1609)));
                    v1602:custom_notify(4, v1609);
                    return ;
                end;
            end;
        end;
        v426.player_death = function(v1610, _, _, _, v1614)
            if not v1610.controller:get() then
                return ;
            else
                local v1615 = v426.death_color:get():alpha_modulate(255):to_hex();
                local v1616 = v1614:get_name();
                if v1616 == "CWorld" then
                    return ;
                else
                    v1610:console(l_v661_3(l_format_0("\a%s[%s.lua] \a808080\194\187 \aDEFAULT%s", v1615, v393.label, (l_format_0("Killed by \a%s%s \aDEFAULTin \a%s%s\aDEFAULT, data: [%sdelta: \a%s%.1f\194\176\aDEFAULT, side: \a%s%s\aDEFAULT, brute_stage: \a%s%d\aDEFAULT]", v1615, v1616, v1615, v407.state:lower(), v407.target ~= v1616 and l_format_0("targetted to: \a%s%s\aDEFAULT, ", v1615, v407.target) or "", v1615, v407.body_yaw, v1615, v408:get_inverter_state(), v1615, v408.antibrute:get() and v408.antibrute.current or 0)))));
                    return ;
                end;
            end;
        end;
        v426.aim_ack = function(v1617, v1618)
            if not v1617.controller:get() then
                return ;
            else
                local v1619 = l_v663_2[v1618.id];
                local v1620 = l_v659_4(v1618.hitgroup);
                local v1621 = l_v659_4(v1618.wanted_hitgroup);
                local v1622 = v1618.damage or 0;
                local v1623 = v1618.wanted_damage or 0;
                local v1624 = v1618.backtrack or 0;
                local v1625 = v1618.hitchance or 0;
                local v1626 = v1618.spread or 0;
                if v1618.state == nil then
                    local v1627 = v426.hit_color:get():alpha_modulate(255):to_hex();
                    local v1628 = l_format_0("\a%s%d\aDEFAULT", v1627, v1622);
                    local v1629 = "";
                    if v1621 ~= v1620 then
                        v1629 = l_format_0("(aimed:\a%s%s\aDEFAULT)", v1627, v1621);
                    end;
                    if v1623 ~= v1622 then
                        v1628 = l_format_0("%s(\a%s%d\aDEFAULT)", v1628, v1627, v1623);
                    end;
                    local v1630 = l_format_0("Hit \a%s%s\aDEFAULT's \a%s%s \aDEFAULTfor %s damage %s(\a%s%d%%\aDEFAULT) (\a%s%.2f\aDEFAULT\194\176, 1:\a%s%d\aDEFAULT\194\176, bt: \a%s%d\aDEFAULT)", v1627, v1619, v1627, v1620, v1628, v1629, v1627, v1625, v1627, v1626, v1627, l_v655_11, v1627, v1624);
                    v1617:on_screen(l_v660_2(v1630));
                    v1617:console(l_v661_3(l_format_0("\a%s[%s.lua] \a808080\194\187 \aDEFAULT%s", v1627, v393.label, v1630)));
                    v1617:custom_notify(4, l_format_0("Hit \a%s%s\aDEFAULT's \a%s%s \aDEFAULTfor %s \aDEFAULTdamage (bt: \a%s%d\aDEFAULT)", v1627, v1619, v1627, v1620, v1628, v1627, v1624));
                    return ;
                elseif v1618.state ~= nil then
                    local v1631 = v426.miss_color:get():alpha_modulate(255):to_hex();
                    local l_state_1 = v1618.state;
                    if l_state_1 == "correction" then
                        l_state_1 = "resolver";
                    end;
                    local v1633 = l_format_0("Missed \a%s%s\aDEFAULT's \a%s%s\aDEFAULT(\a%s%d\aDEFAULT)(\a%s%d%%\aDEFAULT) due to \a%s%s \aDEFAULT(\a%s%.2f\aDEFAULT\194\176, 1:\a%s%d\aDEFAULT\194\176, bt: \a%s%d\aDEFAULT)", v1631, v1619, v1631, v1621, v1631, v1623, v1631, v1625, v1631, l_state_1, v1631, v1626 or 0, v1631, l_v655_11, v1631, v1624);
                    v1617:on_screen(l_v660_2(v1633));
                    v1617:console(l_v661_3(l_format_0("\a%s[%s.lua] \a808080\194\187 \aDEFAULT%s", v1631, v393.label, v1633)));
                    v1617:custom_notify(4, l_format_0("Missed shot at \a%s%s\aDEFAULT's \a%s%s \aDEFAULTdue to \a%s%s \aDEFAULT(bt: \a%s%d\aDEFAULT)", v1631, v1619, v1631, v1621, v1631, l_state_1, v1631, v1624));
                    return ;
                else
                    return ;
                end;
            end;
        end;
        v426.antibrute_reseted = function(v1634, v1635)
            if not v1634.controller:get() then
                return ;
            else
                local _ = nil;
                local v1637 = v426.death_color:get():alpha_modulate(255):to_hex();
                if v1635.userid == v408.antibrute.target then
                    v1634:custom_notify(4, (l_format_0("Reset antibrute due to \a%starget death\aDEFAULT", v1637)));
                end;
                return ;
            end;
        end;
    end;
    v655 = "\t";
    v656 = "\t";
    do
        local l_v655_12, l_v656_10 = v655, v656;
        v657 = function(v1640)
            local v1641 = {};
            local v1642 = #v1640;
            if v1642 < 2 then
                l_insert_0(v1641, v1640);
                return v1641;
            else
                for _ = 1, 8 do
                    l_insert_0(v1641, l_format_0("%s%s%s", l_v655_12, v1640, l_v656_10));
                end;
                for v1644 = 1, v1642 do
                    l_insert_0(v1641, l_format_0("%s%s%s", l_v655_12, v1640:sub(v1644, v1642), l_v656_10));
                end;
                l_insert_0(v1641, l_format_0("%s%s", l_v655_12, l_v656_10));
                for v1645 = l_min_0(2, v1642), v1642 do
                    l_insert_0(v1641, l_format_0("%s%s%s", l_v655_12, v1640:sub(1, v1645), l_v656_10));
                end;
                for _ = 1, 4 do
                    l_insert_0(v1641, l_format_0("%s%s%s", l_v655_12, v1640, l_v656_10));
                end;
                return v1641;
            end;
        end;
        v427.controller = v403("MISC", "bClantag", v405.groups.features.misc:switch("Clantag Spammer"));
        v427.index = -1;
        v427.array = v657(l_format_0("%s.lua", v393.label));
        v427.shutdown = function(_)
            l_set_clan_tag_0("");
            v395.misc.main.clan_tag:override();
        end;
        v427.net_update_end = function(v1648)
            if not v427.controller:get() then
                return ;
            else
                local v1649 = l_get_local_player_0();
                if not (v1649 ~= nil) or v1649.m_iTeamNum == 0 then
                    return ;
                else
                    local v1650 = l_net_channel_0();
                    if v1650 == nil then
                        return ;
                    else
                        local v1651 = v438(((globals.tickcount + v1650.latency[0] / globals.tickinterval) * 0.0625) % #v1648.array) + 1;
                        if v1651 == v1648.index then
                            return ;
                        else
                            v1648.index = v1651;
                            v395.misc.main.clan_tag:override(false);
                            l_set_clan_tag_0(v1648.array[v1651]);
                            return ;
                        end;
                    end;
                end;
            end;
        end;
        v427.controller:set_callback(function(v1652)
            if not v1652:get() then
                v427:shutdown();
            end;
        end);
    end;
    v428.controller = v403("MISC", "bFastLadder", v405.groups.features.misc:switch("Fast Ladder"));
    v428.createmove = function(v1653, v1654)
        if not v1653.controller:get() then
            return ;
        else
            local v1655 = l_get_local_player_0();
            if not (v1655 ~= nil) or v1655.m_MoveType ~= 9 then
                return ;
            else
                local v1656 = v1655:get_player_weapon();
                if v1656 == nil then
                    return ;
                else
                    local l_m_fThrowTime_0 = v1656.m_fThrowTime;
                    if l_m_fThrowTime_0 ~= nil and l_m_fThrowTime_0 ~= 0 then
                        return ;
                    else
                        if v1654.in_forward or v1654.in_back then
                            v1654.in_moveleft = v1654.in_back;
                            v1654.in_moveright = not v1654.in_back;
                            if v1654.sidemove == 0 then
                                v1654.view_angles.y = v1654.view_angles.y + 45;
                            end;
                            if v1654.sidemove > 0 then
                                v1654.view_angles.y = v1654.view_angles.y - 1;
                            end;
                            if v1654.sidemove < 0 then
                                v1654.view_angles.y = v1654.view_angles.y + 90;
                            end;
                        end;
                        return ;
                    end;
                end;
            end;
        end;
    end;
    v655 = {
        [1] = "FEEL THE XO-YAW \208\167\208\156\208\158", 
        [2] = "\208\181\208\177\208\176\209\130\209\140 \209\143 \209\130\208\181\208\177\208\181 \208\191\208\190 \208\179\208\190\208\187\208\190\208\178\208\181 \208\189\208\176\208\181\208\177\208\176\209\136\208\184\208\187", 
        [3] = "\209\130\209\139 \208\177\209\139\208\187 \208\178\208\183\208\177\208\184\209\130 \208\184 \209\131\208\177\208\184\209\130", 
        [4] = "\209\141\208\185 \208\187\209\139\209\129\209\139\208\185 \208\184\208\180\208\184 \208\191\208\190\208\191\208\184\209\129\208\176\208\185", 
        [5] = "\208\191\208\190\208\187\209\131\209\135\208\184\208\187 \208\191\208\190 \208\177\208\176\209\136\208\186\208\181 - \209\131\208\187\208\181\209\130\208\181\208\187 \208\189\208\176 \208\179\208\190\209\128\209\136\208\186\208\181", 
        [6] = "\208\190\209\130\208\186\208\187\209\142\209\135\208\176\209\142 \209\130\208\181\208\177\208\181 \209\129\208\190\208\183\208\189\208\176\208\189\208\184\208\181", 
        [7] = "print(string.rep('ez', 228))", 
        [8] = "\208\186\209\130\208\190 \208\183\208\180\208\181\209\129\209\140", 
        [9] = "\209\143 \208\183\208\180\208\181\209\129\209\140", 
        [10] = "?", 
        [11] = "\208\183\208\180\208\176\209\128\208\190\208\178", 
        [12] = "\209\135\208\181\208\188\209\131 \209\143 \209\131\208\180\208\184\208\178\208\187\209\143\209\142\209\129\209\140, \209\130\209\139 \208\182\208\181 \208\177\208\181\208\183 \209\133\208\190\209\143\208\178\208\176 \208\189\208\184\209\137\208\176\209\143", 
        [13] = "too easy for xo-yaw", 
        [14] = "\208\178\209\129\208\181\208\188 \208\186\209\131 \208\191\208\184\208\180\208\190\209\128\208\176\209\129\209\139", 
        [15] = "oh my god vot eto one tap", 
        [16] = "\208\191\208\190\208\191\208\176\208\187\209\129\209\143 \209\133\208\187\208\190\208\191\208\181\209\134", 
        [17] = "\208\186\209\131\208\183\209\143", 
        [18] = "owned by xo-yaw player lmao", 
        [19] = "f12", 
        [20] = "\209\130\209\128\208\181\209\136\209\130\208\190\208\187\208\186 (\209\131\209\129\208\191\208\190\208\186\208\176\208\184\208\178\208\176\209\142\209\137\208\184\208\185)", 
        [21] = "\208\183\209\131\208\177\209\139 \208\178\209\139\208\191\208\176\208\187\208\184, \208\189\208\190 \208\189\208\181 \209\129\209\129\209\139, \209\141\209\130\208\190 \208\188\208\190\208\187\208\190\209\135\208\189\209\139\208\181", 
        [22] = "\208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\189\208\184\209\143?", 
        [23] = "1 \208\180\208\181\208\179\208\181\208\189\208\181\209\128\208\176\209\130 \208\189\208\181\209\128\209\131\209\129\209\129\208\186\208\184\208\185", 
        [24] = "\209\129\208\187\208\184\209\136\208\186\208\190\208\188 \208\187\208\181\208\179\208\186\208\190 \208\180\208\187\209\143 xo-yaw", 
        [25] = "\209\142\208\184\208\180 \208\191\208\190\208\187\208\184\209\134\208\184\209\143 \208\191\208\190\208\180\209\138\208\181\209\133\208\176\208\187\208\176 \208\190\209\130\208\186\209\128\209\139\208\178\208\176\208\185 \208\180\208\178\208\181\209\128\209\140 \209\131\208\181\208\177\209\139\209\135", 
        [26] = "iqless kid wanna be ahead", 
        [27] = "\230\156\128\229\165\189\231\154\132 XO-YAW.LUA\239\188\129\230\131\179\229\135\187\232\180\165\228\184\150\231\149\140\228\184\138\230\156\128\229\165\189\231\154\132\229\144\151\239\188\159\228\189\191\231\148\168 XO-YAW\239\188\140\230\130\168\229\176\134\230\176\184\232\191\156\233\162\134\229\133\136\229\175\185\230\137\139\228\184\128\230\173\165"
    };
    v656 = function(v1658)
        l_console_exec_0(l_format_0("say %s", v1658));
    end;
    do
        local l_v655_13, l_v656_11, l_v657_10 = v655, v656, v657;
        l_v657_10 = function()
            return l_v655_13[l_random_int_0(1, #l_v655_13)];
        end;
        v429.controller = v403("MISC", "bShitTalking", v405.groups.features.misc:switch("Shit-talking"));
        v429.controller:tooltip("Says in chat some phrases after kill");
        v429.player_death = function(v1662, _)
            if not v1662.controller:get() then
                return ;
            else
                l_v656_11(l_v657_10());
                return ;
            end;
        end;
    end;
    v655 = cvar.r_aspectratio;
    v656 = v655:float();
    v657 = {
        [1] = "16:9", 
        [2] = "16:10", 
        [3] = "3:2", 
        [4] = "4:3", 
        [5] = "5:4"
    };
    v658 = {};
    for v1664 = 1, #v657 do
        v663 = v657[v1664];
        v664, v665 = v663:match("(%d*):(%d*)");
        v658[v438((v664 / v665) * 100)] = v663;
    end;
    v430.controller = v403("MISC", "bAspectRatio", v405.groups.features.misc:switch("Aspect Ratio"));
    v659 = v430.controller:create();
    do
        local l_v655_14, l_v656_12, l_v658_5 = v655, v656, v658;
        v430.ratio = v403("MISC", "flAspectRatio", v659:slider("", 0, 300, v438((v393.scr.x / v393.scr.y) * 100), 0.01, function(v1668)
            if v1668 == 0 then
                return "Off";
            else
                return l_v658_5[v1668] or l_format_0("%.2f", v1668 * 0.01);
            end;
        end)):depend(v430.controller);
        for v1669 = 1, #v657 do
            v664 = v657[v1669];
            v665, v666 = v664:match("(%d*):(%d*)");
            v667 = v438((v665 / v666) * 100);
            do
                local l_v667_3 = v667;
                v430.buttons = v403("MISC", l_format_0("bAspectRatio%s", v1669), v659:button(v664, function()
                    v430.ratio:set(l_v667_3);
                    v430:update();
                end, true)):depend(v430.controller);
            end;
        end;
        v430.shutdown = function(_)
            l_v655_14:float(l_v656_12, true);
        end;
        v430.update = function(v1672)
            if not v430.controller:get() then
                return false;
            else
                l_v655_14:float(v1672.ratio:get() * 0.01, true);
                return true;
            end;
        end;
        v430.controller:set_callback(function(_)
            if not v430:update() then
                v430:shutdown();
            end;
        end, true);
        v430.ratio:set_callback(function()
            v430:update();
        end);
    end;
    v655 = cvar.viewmodel_fov;
    v656 = cvar.viewmodel_offset_x;
    v657 = cvar.viewmodel_offset_y;
    v658 = cvar.viewmodel_offset_z;
    v659 = v655:float();
    v660 = v656:float();
    v661 = v657:float();
    v662 = v658:float();
    v431.controller = v403("MISC", "bViewmodelChanger", v405.groups.features.misc:switch("Viewmodel Changer"));
    v663 = v431.controller:create();
    v431.fov = v403("MISC", "flViewmodelFov", v663:slider("Fov", 150, 1200, v655:float() * 10, 0.1)):depend(v431.controller);
    v431.x = v403("MISC", "flViewmodelX", v663:slider("X", -500, 500, v656:float() * 10, 0.1)):depend(v431.controller);
    v431.y = v403("MISC", "flViewmodelY", v663:slider("Y", -500, 500, v657:float() * 10, 0.1)):depend(v431.controller);
    v431.z = v403("MISC", "flViewmodelZ", v663:slider("Z", -500, 500, v658:float() * 10, 0.1)):depend(v431.controller);
    do
        local l_v655_15, l_v656_13, l_v657_11, l_v658_6, l_v659_5, l_v660_3, l_v661_4, l_v662_2 = v655, v656, v657, v658, v659, v660, v661, v662;
        v431.shutdown = function(_)
            l_v655_15:float(l_v659_5, true);
            l_v656_13:float(l_v660_3, true);
            l_v657_11:float(l_v661_4, true);
            l_v658_6:float(l_v662_2, true);
        end;
        v431.update = function(v1683)
            if not v431.controller:get() then
                return false;
            else
                l_v655_15:float(v1683.fov:get() * 0.1, true);
                l_v656_13:float(v1683.x:get() * 0.1, true);
                l_v657_11:float(v1683.y:get() * 0.1, true);
                l_v658_6:float(v1683.z:get() * 0.1, true);
                return true;
            end;
        end;
        v431.controller:set_callback(function(_)
            if not v431:update() then
                v431:shutdown();
            end;
        end, true);
        v664 = function()
            v431:update();
        end;
        v431.fov:set_callback(v664);
        v431.x:set_callback(v664);
        v431.y:set_callback(v664);
        v431.z:set_callback(v664);
    end;
    v655 = nil;
    v656 = {};
    v657 = {
        ["vgui/hud/800corner2"] = true, 
        ["vgui/hud/800corner1"] = true, 
        vgui_white = true, 
        ["vgui/hud/800corner4"] = true, 
        ["vgui/hud/800corner3"] = true
    };
    v658 = materials.get_materials("vgui");
    for v1685 = 1, #v658 do
        v663 = v658[v1685];
        if v657[v663:get_name()] then
            l_insert_0(v656, v663);
        end;
    end;
    do
        local l_v655_16, l_v656_14, l_v659_6, l_v660_4 = v655, v656, v659, v660;
        l_v659_6 = function(v1690)
            if v1690 == l_v655_16 then
                return ;
            else
                for v1691 = 1, #l_v656_14 do
                    local v1692 = l_v656_14[v1691];
                    if v1692:is_valid() then
                        if v1690 == nil then
                            v1692:reset();
                        else
                            v1692:color_modulate(v1690);
                            v1692:alpha_modulate(v1690.a / 255);
                        end;
                    end;
                end;
                l_v655_16 = v1690;
                return ;
            end;
        end;
        l_v660_4 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
        v432.controller = v403("MISC", "bConsoleColor", v405.groups.features.misc:switch("Console Color"));
        v432.color = v403("MISC", "clrConsoleColor", v432.controller:color_picker("Color"));
        v432.shutdown = function(_)
            l_v659_6();
        end;
        v432.pre_render = function(_)
            if not v432.controller:get() then
                return ;
            elseif l_v660_4() then
                l_v659_6(v432.color:get());
                return ;
            else
                v432:shutdown();
                return ;
            end;
        end;
        v432.controller:set_callback(function()
            v432:shutdown();
        end);
    end;
    v655 = function()
        return l_C_0.GetForegroundWindow() == v393.csgo;
    end;
    v656 = function()
        l_C_0.FlashWindow(v393.csgo, false);
    end;
    v433.controller = v403("MISC", "bTaskbarNotify", v405.groups.features.misc:switch("Taskbar Notify"));
    v433.controller:tooltip("Flashes icon in taskbar, when round starts.");
    do
        local l_v655_17, l_v656_15 = v655, v656;
        v433.round_start = function(_, _)
            local v1699 = entity.get_game_rules();
            if not v1699 then
                return ;
            else
                if (not v1699.m_bIsValveDS and v433.controller:get()) and not l_v655_17() then
                    l_v656_15();
                end;
                return ;
            end;
        end;
    end;
    v655 = {};
    v656 = {
        [1] = "weapon_molotov", 
        [2] = "weapon_incgrenade", 
        [3] = "weapon_hegrenade"
    };
    v657 = {};
    for _, v1701 in next, v656 do
        v657[v1701] = true;
    end;
    v434.controller = v403("MISC", "bDropNades", v405.groups.features.misc:switch("Drop Nades", false));
    v434.controller:tooltip(l_format_0("Very useful function for fast drop nades (for 2v2/3v3/5v5 games) \n\affff00ff%s  You should bind this function", v398["exclamation-triangle"]));
    do
        local l_v657_12 = v657;
        v434.controller:set_callback(function()
            if not v434.controller:get() then
                return ;
            else
                local v1703 = l_get_local_player_0();
                if not v1703 or not v1703:is_alive() then
                    return ;
                elseif #v655 > 0 then
                    return ;
                else
                    local v1704 = 1;
                    local v1705 = v1703:get_player_weapon(true);
                    for v1706 = 1, #v1705 do
                        local v1707 = v1705[v1706];
                        do
                            local l_v1707_0 = v1707;
                            if l_v1707_0 then
                                local l_console_name_0 = l_v1707_0:get_weapon_info().console_name;
                                do
                                    local l_l_console_name_0_0 = l_console_name_0;
                                    if l_v657_12[l_l_console_name_0_0] then
                                        v655[#v655 + 1] = function(v1711)
                                            v1711.no_choke = true;
                                            v1711.send_packet = false;
                                            v1711.in_use = 1;
                                            v1711.weaponselect = l_v1707_0:get_index();
                                            v1711.view_angles = render.camera_angles();
                                        end;
                                        v655[#v655 + 1] = function(v1712)
                                            local l_l_l_console_name_0_0_0 = l_l_console_name_0_0;
                                            local v1714 = l_get_local_player_0();
                                            if not v1714 or not v1714:is_alive() then
                                                return ;
                                            else
                                                local v1715 = v1714:get_player_weapon();
                                                if not v1715 then
                                                    return ;
                                                elseif l_l_l_console_name_0_0_0 ~= v1715:get_weapon_info().console_name then
                                                    return ;
                                                else
                                                    v1712.no_choke = true;
                                                    v1712.send_packet = false;
                                                    v1712.in_use = 1;
                                                    v1712.view_angles = render.camera_angles();
                                                    l_console_exec_0("drop");
                                                    return ;
                                                end;
                                            end;
                                        end;
                                        for _ = 1, 2 do
                                            v655[#v655 + 1] = function(v1717)
                                                v1717.no_choke = true;
                                                v1717.send_packet = false;
                                                v1717.in_use = 1;
                                                v1717.view_angles = render.camera_angles();
                                            end;
                                        end;
                                        v1704 = v1704 + 1;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    return ;
                end;
            end;
        end, false);
    end;
    events.player_connect_full:set(function(v1718)
        if l_get_local_player_0() == l_get_0(v1718.userid, true) then
            v408:player_connect_full(v1718);
            v294.data = {};
            v278.data = {};
        end;
    end);
    events.shutdown:set(function()
        v408:shutdown();
        v413:shutdown();
        v423:shutdown();
        v427:shutdown();
        v430:shutdown();
        v431:shutdown();
        v432:shutdown();
    end);
    events.bullet_impact:set(function(v1719)
        v408.antibrute:bullet_impact(v1719);
    end);
    events.createmove:set(function(v1720)
        v278:new_frame(globals.tickcount);
        v294:new_frame(globals.tickcount);
        v411:createmove(v1720);
        v407:get_target();
        v407:createmove(v1720);
        v408:createmove(v1720);
        v423:createmove(v1720);
        v424:createmove();
        v428:createmove(v1720);
        if v1720.choked_commands == 0 then
            v409.on_update();
            if #v655 > 0 then
                v655[1](v1720);
                table.remove(v655, 1);
            end;
        end;
    end);
    events.override_view:set(function(v1721)
        v413:override_view(v1721);
    end);
    events.render:set(function()
        v409:pre();
        v410:update();
        v411:render();
        v412:render();
        v413:__init();
        v413:render();
        v414:render();
        v415:render();
        v416:render();
        v417:render();
        v418:render();
        v420:render();
        v421:render();
        v409:post();
        v401:paint();
        v400:update();
        if v551.increasing then
            if v551.increase <= 89 then
                v551.increase = v551.increase + 4;
            else
                v551.increasing = false;
            end;
        elseif v551.increase >= -89 then
            v551.increase = v551.increase - 4;
        else
            v551.increasing = true;
        end;
    end);
    events.net_update_end:set(function()
        v425:net_update_end();
        v427:net_update_end();
    end);
    events.pre_render:set(function()
        v432:pre_render();
    end);
    events.item_purchase:set(function(v1722)
        v409:item_purchase(v1722);
    end);
    events.player_spawn:set(function(v1723)
        v409:player_spawn(v1723);
    end);
    events.round_start:set(function(v1724)
        v409:round_start(v1724);
    end);
    events.round_end:set(function(v1725)
        v409:round_end(v1725);
    end);
    events.player_hurt:set(function(v1726)
        local v1727 = l_get_local_player_0();
        local v1728 = l_get_0(v1726.userid, true);
        local v1729 = l_get_0(v1726.attacker, true);
        if v1729 == v1727 and v1728 ~= v1727 then
            v415:player_hurt(v1726);
            v426:player_hurt(v1726, v1727, v1728, v1729);
        end;
    end);
    events.player_death:set(function(v1730)
        local v1731 = l_get_local_player_0();
        local v1732 = l_get_0(v1730.userid, true);
        local v1733 = l_get_0(v1730.attacker, true);
        if v1733 == v1731 and v1732 ~= v1731 then
            v429:player_death(v1730);
        end;
        if v1733 ~= v1731 and v1732 == v1731 then
            v426:player_death(v1730, v1731, v1732, v1733);
        end;
        v408.antibrute:player_death(v1730, v1731, v1732);
    end);
    events.round_start:set(function(v1734)
        v433:round_start(v1734);
    end);
    events.aim_fire:set(function(v1735)
        v426:aim_fire(v1735);
        v414:aim_fire(v1735);
    end);
    events.aim_ack:set(function(v1736)
        v426:aim_ack(v1736);
        v414:aim_ack(v1736);
    end);
    v403:refresh();
end, v5("main"));