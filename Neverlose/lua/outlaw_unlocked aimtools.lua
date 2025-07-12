local v0 = 2;
local v1 = common.get_username();
local v2 = v1 == "put your name here" or v1 == "keqx";
xpcall(function()
    -- upvalues: v2 (ref), v1 (ref), v0 (ref)
     l_min_0 = math.min;
     l_max_0 = math.max;
     l_abs_0 = math.abs;
     l_clamp_0 = math.clamp;
     l_floor_0 = math.floor;
     l_fmod_0 = math.fmod;
     l_normalize_yaw_0 = math.normalize_yaw;
     l_exp_0 = math.exp;
     l_atan2_0 = math.atan2;
     l_sin_0 = math.sin;
     l_cos_0 = math.cos;
     l_rad_0 = math.rad;
     l_pow_0 = math.pow;
     l_random_0 = math.random;
     l_pi_0 = math.pi;
     l_format_0 = string.format;
     l_byte_0 = string.byte;
     l_char_0 = string.char;
     l_len_0 = string.len;
     l_find_0 = string.find;
     l_sub_0 = string.sub;
     l_gsub_0 = string.gsub;
     l_rep_0 = string.rep;
     l_tonumber_0 = tonumber;
     l_tostring_0 = tostring;
     l_type_0 = type;
     l_pcall_0 = pcall;
     l_xpcall_0 = xpcall;
     l_assert_0 = assert;
     l_next_0 = next;
     l_ipairs_0 = ipairs;
     l_pairs_0 = pairs;
     l_band_0 = bit.band;
    local l_bxor_0 = bit.bxor;
    local l_rshift_0 = bit.rshift;
    local l_bnot_0 = bit.bnot;
    local l_lshift_0 = bit.lshift;
    local l_insert_0 = table.insert;
    local l_remove_0 = table.remove;
    local l_concat_0 = table.concat;
    local l_sort_0 = table.sort;
    local l_cast_0 = ffi.cast;
    local l_new_0 = ffi.new;
    local l_string_0 = ffi.string;
    local l_text_0 = render.text;
    local l_measure_text_0 = render.measure_text;
    local l_camera_angles_0 = render.camera_angles;
    local l_rect_outline_0 = render.rect_outline;
    local l_rect_0 = render.rect;
    local l_push_clip_rect_0 = render.push_clip_rect;
    local l_pop_clip_rect_0 = render.pop_clip_rect;
    local l_line_0 = render.line;
    local l_shadow_0 = render.shadow;
    local l_blur_0 = render.blur;
    local l_texture_0 = render.texture;
    local l_gradient_0 = render.gradient;
    local l_poly_0 = render.poly;
    local l_get_offscreen_0 = render.get_offscreen;
    local l_circle_outline_0 = render.circle_outline;
    local l_get_0 = entity.get;
    local l_get_local_player_0 = entity.get_local_player;
    local l_get_players_0 = entity.get_players;
    local l_get_entities_0 = entity.get_entities;
    local l_get_player_resource_0 = entity.get_player_resource;
    local l_get_game_rules_0 = entity.get_game_rules;
    local l_get_threat_0 = entity.get_threat;
    local l_is_button_down_0 = common.is_button_down;
    local l_get_date_0 = common.get_date;
    local l_set_clan_tag_0 = common.set_clan_tag;
    local l_get_timestamp_0 = common.get_timestamp;
    local l_get_unixtime_0 = common.get_unixtime;
    local l_execute_after_0 = utils.execute_after;
    local l_trace_hull_0 = utils.trace_hull;
    local l_trace_line_0 = utils.trace_line;
    local l_console_exec_0 = utils.console_exec;
    local l_random_float_0 = utils.random_float;
    local l_trace_bullet_0 = utils.trace_bullet;
    local l_random_int_0 = utils.random_int;
    local l_net_channel_0 = utils.net_channel;
    local l_antiaim_0 = rage.antiaim;
    local l_inverter_0 = l_antiaim_0.inverter;
    local l_get_target_0 = l_antiaim_0.get_target;
    local l_override_hidden_pitch_0 = l_antiaim_0.override_hidden_pitch;
    local l_override_hidden_yaw_offset_0 = l_antiaim_0.override_hidden_yaw_offset;
    local l_exploit_0 = rage.exploit;
    local l_get_1 = l_exploit_0.get;
    local l_globals_0 = globals;
    local l_vector_0 = vector;
    local v91 = vector();
    local l_dist_0 = v91.dist;
    local l_dist2d_0 = v91.dist2d;
    local l_distsqr_0 = v91.distsqr;
    local l_lerp_0 = v91.lerp;
    local l_angles_0 = v91.angles;
    local l_normalize_0 = v91.normalize;
    local l_normalized_0 = v91.normalized;
    local l_vectors_0 = v91.vectors;
    local l_closest_ray_point_0 = v91.closest_ray_point;
    local l_color_0 = color;
    local v102 = color();
    local l_alpha_modulate_0 = v102.alpha_modulate;
    local l_to_hex_0 = v102.to_hex;
    local v105 = nil;
    local v106 = nil;
    local v107 = nil;
    local v108 = nil;
    local v109 = nil;
    local v110 = nil;
    local v111 = nil;
    local v112 = nil;
    local v113 = nil;
    if l_globals_0.is_connected then
        local v114 = l_get_local_player_0();
        if v114 ~= nil then
            v105 = v114.get_eye_position;
            v106 = v114.get_origin;
            v107 = v114.get_player_weapon;
            v108 = v114.get_hitbox_position;
            v109 = v114.is_dormant;
            v110 = v114.is_alive;
            v111 = v114.is_enemy;
            v112 = v114.is_visible;
            v113 = v114.get_index;
        end;
    else
        local v115 = nil;
        do
            local l_v115_0 = v115;
            l_v115_0 = function()
                -- upvalues: l_get_local_player_0 (ref), v105 (ref), v106 (ref), v107 (ref), v108 (ref), v109 (ref), v110 (ref), v111 (ref), v112 (ref), v113 (ref), l_v115_0 (ref)
                local v117 = l_get_local_player_0();
                if v117 == nil then
                    return;
                else
                    v105 = v117.get_eye_position;
                    v106 = v117.get_origin;
                    v107 = v117.get_player_weapon;
                    v108 = v117.get_hitbox_position;
                    v109 = v117.is_dormant;
                    v110 = v117.is_alive;
                    v111 = v117.is_enemy;
                    v112 = v117.is_visible;
                    v113 = v117.get_index;
                    events.render(l_v115_0, false);
                    l_v115_0 = nil;
                    return;
                end;
            end;
            events.render(l_v115_0);
        end;
    end;
    local v118 = nil;
    local v119 = nil;
    v118 = render.screen_size();
    v119 = v118 * 0.5;
    local v128 = (function()
        -- upvalues: l_len_0 (ref), l_new_0 (ref), l_string_0 (ref), l_find_0 (ref), l_sub_0 (ref)
        local v120 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)");
        local v121 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)");
        local v122 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)");
        return function(v123)
            -- upvalues: v121 (ref), l_len_0 (ref), v120 (ref), l_new_0 (ref), v122 (ref), l_string_0 (ref), l_find_0 (ref), l_sub_0 (ref)
            if v123 then
                return v121(v123, l_len_0(v123));
            else
                local v124 = v120();
                if v124 == 0 then
                    return;
                else
                    local v125 = l_new_0("char[?]", v124);
                    v122(0, v125, v124);
                    local v126 = l_string_0(v125, v124 - 1);
                    local v127 = l_find_0(v126, "_outlaw");
                    if v127 then
                        v126 = l_sub_0(v126, 1, v127);
                    end;
                    return v126;
                end;
            end;
        end;
    end)();
    local v194, v195, v196 = (function()
        -- upvalues: l_band_0 (ref), l_rshift_0 (ref), l_lshift_0 (ref), l_sub_0 (ref), l_next_0 (ref), l_byte_0 (ref), l_len_0 (ref), l_char_0 (ref), l_concat_0 (ref), l_format_0 (ref), l_gsub_0 (ref)
        base64 = {};
        local function v132(v129, v130, v131)
            -- upvalues: l_band_0 (ref), l_rshift_0 (ref), l_lshift_0 (ref)
            return l_band_0(l_rshift_0(v129, v130), l_lshift_0(1, v131) - 1);
        end;
        base64.makeencoder = function(v133)
            -- upvalues: l_sub_0 (ref), l_next_0 (ref), l_byte_0 (ref)
            local v134 = {};
            local v135 = {};
            for v136 = 1, #v133 do
                v135[v136 - 1] = l_sub_0(v133, v136, v136);
            end;
            for v137, v138 in l_next_0, v135 do
                v134[v137] = l_byte_0(v138);
            end;
            return v134;
        end;
        base64.makedecoder = function(v139)
            -- upvalues: l_next_0 (ref)
            local v140 = {};
            for v141, v142 in l_next_0, base64.makeencoder(v139) do
                v140[v142] = v141;
            end;
            return v140;
        end;
        local v143 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        local v144 = "0ucHJINGekQRUwZWVbPXyYlshz65DfLnpxTtKiFvor4ad9A7M3mSBCE21gjO8q+/=";
        local v145 = base64.makeencoder(v143);
        local v146 = base64.makedecoder(v143);
        local v147 = base64.makeencoder(v144);
        local v148 = base64.makedecoder(v144);
        base64.encode = function(v149, v150, v151)
            -- upvalues: v145 (ref), l_len_0 (ref), l_byte_0 (ref), l_char_0 (ref), v132 (ref), l_concat_0 (ref)
            if not v150 then
                v150 = v145;
            end;
            local v152 = {};
            local v153 = 1;
            local v154 = l_len_0(v149);
            local v155 = v154 % 3;
            local v156 = {};
            for v157 = 1, v154 - v155, 3 do
                local v158, v159, v160 = l_byte_0(v149, v157, v157 + 2);
                local v161 = v158 * 65536 + v159 * 256 + v160;
                local v162 = nil;
                if v151 then
                    v162 = v156[v161];
                    if not v162 then
                        v162 = l_char_0(v150[v132(v161, 18, 6)], v150[v132(v161, 12, 6)], v150[v132(v161, 6, 6)], v150[v132(v161, 0, 6)]);
                        v156[v161] = v162;
                    end;
                else
                    v162 = l_char_0(v150[v132(v161, 18, 6)], v150[v132(v161, 12, 6)], v150[v132(v161, 6, 6)], v150[v132(v161, 0, 6)]);
                end;
                v152[v153] = v162;
                v153 = v153 + 1;
            end;
            if v155 == 2 then
                local v163, v164 = l_byte_0(v149, v154 - 1, v154);
                local v165 = v163 * 65536 + v164 * 256;
                v152[v153] = l_char_0(v150[v132(v165, 18, 6)], v150[v132(v165, 12, 6)], v150[v132(v165, 6, 6)], v150[64]);
            elseif v155 == 1 then
                local v166 = l_byte_0(v149, v154) * 65536;
                v152[v153] = l_char_0(v150[v132(v166, 18, 6)], v150[v132(v166, 12, 6)], v150[64], v150[64]);
            end;
            return l_concat_0(v152);
        end;
        base64.decode = function(v167, v168, v169)
            -- upvalues: v146 (ref), l_next_0 (ref), l_format_0 (ref), l_char_0 (ref), l_gsub_0 (ref), l_sub_0 (ref), l_byte_0 (ref), v132 (ref), l_concat_0 (ref)
            if not v168 then
                v168 = v146;
            end;
            local v170 = "[^%w%+%/%=]";
            if v168 then
                local v171 = nil;
                local v172 = nil;
                for v173, v174 in l_next_0, v168 do
                    if v174 == 62 then
                        v171 = v173;
                    elseif v174 == 63 then
                        v172 = v173;
                    end;
                end;
                v170 = l_format_0("[^%%w%%%s%%%s%%=]", l_char_0(v171), l_char_0(v172));
            end;
            v167 = l_gsub_0(v167, v170, "");
            local v175 = v169 and {};
            local v176 = {};
            local v177 = 1;
            local v178 = #v167;
            local v179 = l_sub_0(v167, -2) == "==" and 2 or l_sub_0(v167, -1) == "=" and 1 or 0;
            local v180 = 1;
            local v181 = v179 > 0 and v178 - 4 or v178;
            for v182 = v180, v181, 4 do
                local v183, v184, v185, v186 = l_byte_0(v167, v182, v182 + 3);
                local v187 = nil;
                if v169 then
                    local v188 = v183 * 16777216 + v184 * 65536 + v185 * 256 + v186;
                    v187 = v175[v188];
                    if not v187 then
                        local v189 = v168[v183] * 262144 + v168[v184] * 4096 + v168[v185] * 64 + v168[v186];
                        v187 = l_char_0(v132(v189, 16, 8), v132(v189, 8, 8), v132(v189, 0, 8));
                        v175[v188] = v187;
                    end;
                else
                    local v190 = v168[v183] * 262144 + v168[v184] * 4096 + v168[v185] * 64 + v168[v186];
                    v187 = l_char_0(v132(v190, 16, 8), v132(v190, 8, 8), v132(v190, 0, 8));
                end;
                v176[v177] = v187;
                v177 = v177 + 1;
            end;
            if v179 == 1 then
                local v191;
                v180, v181, v191 = l_byte_0(v167, v178 - 3, v178 - 1);
                local v192 = v168[v180] * 262144 + v168[v181] * 4096 + v168[v191] * 64;
                v176[v177] = l_char_0(v132(v192, 16, 8), v132(v192, 8, 8));
            elseif v179 == 2 then
                v180, v181 = l_byte_0(v167, v178 - 3, v178 - 2);
                local v193 = v168[v180] * 262144 + v168[v181] * 4096;
                v176[v177] = l_char_0(v132(v193, 16, 8));
            end;
            return l_concat_0(v176);
        end;
        return base64, v147, v148;
    end)();
    local v329 = (function()
        -- upvalues: l_tonumber_0 (ref), l_clamp_0 (ref), l_concat_0 (ref), l_new_0 (ref), l_bxor_0 (ref), l_string_0 (ref), v194 (ref), l_pcall_0 (ref), l_globals_0 (ref), l_assert_0 (ref), l_type_0 (ref), l_cast_0 (ref), l_band_0 (ref), l_rshift_0 (ref), l_get_local_player_0 (ref), v113 (ref), l_lshift_0 (ref), l_get_0 (ref), v110 (ref), l_abs_0 (ref), l_format_0 (ref), l_ipairs_0 (ref), l_pairs_0 (ref), l_max_0 (ref), l_sort_0 (ref), l_get_players_0 (ref), l_tostring_0 (ref), l_remove_0 (ref), l_insert_0 (ref)
        local v197 = 120;
        local v198 = 0;
        local v199 = 0;
        local l_voice_message_0 = events.voice_message;
        local l_voice_modenable_0 = cvar.voice_modenable;
        local l_cl_mute_enemy_team_0 = cvar.cl_mute_enemy_team;
        local l_cl_mute_all_but_friends_and_party_0 = cvar.cl_mute_all_but_friends_and_party;
        local l_cl_mute_player_after_reporting_abuse_0 = cvar.cl_mute_player_after_reporting_abuse;
        local v205 = 0;
        cvar.voice_buffer_debug:set_callback(function(v206, v207, v208)
            -- upvalues: l_tonumber_0 (ref), v199 (ref), l_clamp_0 (ref)
            local v209 = l_tonumber_0(v208);
            local v210 = l_tonumber_0(v207);
            v199 = 0;
            if v209 > 1 then
                v206:int(v210);
                v199 = l_clamp_0(v209 - 1, 0, 2);
            end;
        end);
        local v211 = {
            PRIMORDIAL = "PRMD", 
            SPIRT = "SPRT", 
            GAMESENSE = "GS", 
            NEVERLOSE = "NL", 
            EVOLVE = "EVO", 
            NIXWARE = "NW", 
            PANDORA = "PD", 
            ONETAP = "OT", 
            FATALITY = "FT"
        };
        local v212 = {
            [v211.NEVERLOSE] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/neverlose.png", 
            [v211.GAMESENSE] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/gamesense.png", 
            [v211.PRIMORDIAL] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/primordial.png", 
            [v211.FATALITY] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/fatality.png", 
            [v211.ONETAP] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/onetap.png", 
            [v211.PANDORA] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/pandora.png", 
            [v211.NIXWARE] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/nixware.png", 
            [v211.EVOLVE] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/ev0.png", 
            [v211.SPIRT] = "https://raw.githubusercontent.com/tickcount/.p2c-icons/main/spirthack.png"
        };
        local function v220(...)
            -- upvalues: l_concat_0 (ref), l_new_0 (ref), l_bxor_0 (ref), l_string_0 (ref)
            local v213 = l_concat_0({
                ...
            });
            local v214 = "64 0e 87 3c e5 b1 4f c8 05 9a";
            local v215 = #v213;
            local v216 = #v214;
            local v217 = l_new_0("char[?]", v215 + 1);
            local v218 = l_new_0("char[?]", v216 + 1);
            ffi.copy(v217, v213);
            ffi.copy(v218, v214);
            for v219 = 0, v215 - 1 do
                v217[v219] = l_bxor_0(v217[v219], v218[v219 % v216]);
            end;
            return l_string_0(v217, v215);
        end;
        local v221 = nil;
        local v222 = nil;
        v222 = "@vclistener";
        local v224, v225 = l_pcall_0(function(v223)
            -- upvalues: v220 (ref), v194 (ref)
            return json.parse(v220(v194.decode(v223)));
        end, db[v222]);
        v221 = v224 == true and v225 or {};
        db[v222] = nil;
        local function v228(v226, v227)
            return v226.is_reliable and v226.amount > v227.amount;
        end;
        v224 = function()
            -- upvalues: l_globals_0 (ref)
            return l_globals_0.realtime;
        end;
        v225 = nil;
        local v229 = nil;
        ffi.cdef("                void* VirtualAlloc(void* lpAddress, size_t dwSize, uint32_t flAllocationType, uint32_t flProtect);\n                int VirtualFree(void* lpAddress, size_t dwSize, uint32_t dwFreeType);\n            ");
        local function v234(v230)
            -- upvalues: l_assert_0 (ref), l_type_0 (ref), l_new_0 (ref)
            l_assert_0(l_type_0(v230) == "table", "invalid shellcode");
            local v231 = #v230;
            local v232 = ffi.C.VirtualAlloc(nil, v231, 4096, 64);
            l_assert_0(v232 ~= nil, "allocation failed");
            ffi.gc(v232, function(v233)
                -- upvalues: v231 (ref)
                ffi.C.VirtualFree(v233, v231, 32768);
            end);
            ffi.copy(v232, l_new_0("char[?]", v231, v230), v231);
            return v232;
        end;
        local v235 = ffi.typeof("                struct {\n                    uint64_t version;\n                    uint32_t xuid_low;\n                    uint32_t xuid_high;\n                    char name[128];\n                    int userid;\n                    char guid[33];\n                    uint32_t friendsid;\n                    char friendsname[128];\n                    bool isbot;\n                    bool ishltv;\n                    uint32_t customfiles[4];\n                    uint8_t filesdownloaded;\n                }\n            ");
        local v236 = utils.get_vfunc("engine.dll", "VEngineClient014", 8, "bool(__thiscall*)(void*, int, $*)", v235);
        do
            local l_v235_0, l_v236_0 = v235, v236;
            v229 = function(v239)
                -- upvalues: l_type_0 (ref), l_v235_0 (ref), l_v236_0 (ref)
                if l_type_0(v239) ~= "number" then
                    return;
                else
                    local v240 = l_v235_0();
                    v240.version = 18446744073709547522ULL;
                    if l_v236_0(v239, v240) then
                        return v240;
                    else
                        return;
                    end;
                end;
            end;
            v225 = l_cast_0("bool(__fastcall*)(void*, uint32_t)", v234({
                [1] = 129, 
                [2] = 236, 
                [3] = 76, 
                [4] = 1, 
                [5] = 0, 
                [6] = 0, 
                [7] = 83, 
                [8] = 85, 
                [9] = 86, 
                [10] = 139, 
                [11] = 241, 
                [12] = 137, 
                [13] = 84, 
                [14] = 36, 
                [15] = 84, 
                [16] = 51, 
                [17] = 219, 
                [18] = 199, 
                [19] = 68, 
                [20] = 36, 
                [21] = 16, 
                [22] = 104, 
                [23] = 51, 
                [24] = 5, 
                [25] = 151, 
                [26] = 87, 
                [27] = 199, 
                [28] = 68, 
                [29] = 36, 
                [30] = 24, 
                [31] = 54, 
                [32] = 6, 
                [33] = 212, 
                [34] = 234, 
                [35] = 191, 
                [36] = 0, 
                [37] = 1, 
                [38] = 0, 
                [39] = 0, 
                [40] = 139, 
                [41] = 70, 
                [42] = 16, 
                [43] = 139, 
                [44] = 78, 
                [45] = 20, 
                [46] = 137, 
                [47] = 68, 
                [48] = 36, 
                [49] = 48, 
                [50] = 139, 
                [51] = 70, 
                [52] = 40, 
                [53] = 137, 
                [54] = 68, 
                [55] = 36, 
                [56] = 56, 
                [57] = 139, 
                [58] = 70, 
                [59] = 36, 
                [60] = 137, 
                [61] = 68, 
                [62] = 36, 
                [63] = 60, 
                [64] = 139, 
                [65] = 70, 
                [66] = 44, 
                [67] = 137, 
                [68] = 68, 
                [69] = 36, 
                [70] = 64, 
                [71] = 139, 
                [72] = 195, 
                [73] = 199, 
                [74] = 68, 
                [75] = 36, 
                [76] = 28, 
                [77] = 79, 
                [78] = 196, 
                [79] = 164, 
                [80] = 62, 
                [81] = 199, 
                [82] = 68, 
                [83] = 36, 
                [84] = 32, 
                [85] = 133, 
                [86] = 178, 
                [87] = 172, 
                [88] = 15, 
                [89] = 137, 
                [90] = 76, 
                [91] = 36, 
                [92] = 52, 
                [93] = 137, 
                [94] = 92, 
                [95] = 36, 
                [96] = 40, 
                [97] = 136, 
                [98] = 68, 
                [99] = 4, 
                [100] = 92, 
                [101] = 64, 
                [102] = 59, 
                [103] = 199, 
                [104] = 114, 
                [105] = 247, 
                [106] = 138, 
                [107] = 243, 
                [108] = 139, 
                [109] = 243, 
                [110] = 138, 
                [111] = 84, 
                [112] = 52, 
                [113] = 92, 
                [114] = 139, 
                [115] = 198, 
                [116] = 131, 
                [117] = 224, 
                [118] = 15, 
                [119] = 138, 
                [120] = 68, 
                [121] = 4, 
                [122] = 20, 
                [123] = 2, 
                [124] = 194, 
                [125] = 2, 
                [126] = 240, 
                [127] = 15, 
                [128] = 182, 
                [129] = 206, 
                [130] = 138, 
                [131] = 68, 
                [132] = 12, 
                [133] = 92, 
                [134] = 136, 
                [135] = 68, 
                [136] = 52, 
                [137] = 92, 
                [138] = 70, 
                [139] = 136, 
                [140] = 84, 
                [141] = 12, 
                [142] = 92, 
                [143] = 59, 
                [144] = 247, 
                [145] = 114, 
                [146] = 219, 
                [147] = 138, 
                [148] = 227, 
                [149] = 139, 
                [150] = 251, 
                [151] = 189, 
                [152] = 128, 
                [153] = 0, 
                [154] = 0, 
                [155] = 0, 
                [156] = 138, 
                [157] = 244, 
                [158] = 254, 
                [159] = 198, 
                [160] = 15, 
                [161] = 182, 
                [162] = 246, 
                [163] = 138, 
                [164] = 84, 
                [165] = 52, 
                [166] = 92, 
                [167] = 2, 
                [168] = 226, 
                [169] = 15, 
                [170] = 182, 
                [171] = 204, 
                [172] = 138, 
                [173] = 68, 
                [174] = 12, 
                [175] = 92, 
                [176] = 136, 
                [177] = 68, 
                [178] = 52, 
                [179] = 92, 
                [180] = 136, 
                [181] = 84, 
                [182] = 12, 
                [183] = 92, 
                [184] = 131, 
                [185] = 237, 
                [186] = 1, 
                [187] = 117, 
                [188] = 225, 
                [189] = 254, 
                [190] = 198, 
                [191] = 15, 
                [192] = 182, 
                [193] = 246, 
                [194] = 138, 
                [195] = 84, 
                [196] = 52, 
                [197] = 92, 
                [198] = 138, 
                [199] = 218, 
                [200] = 2, 
                [201] = 220, 
                [202] = 15, 
                [203] = 182, 
                [204] = 203, 
                [205] = 138, 
                [206] = 68, 
                [207] = 12, 
                [208] = 92, 
                [209] = 136, 
                [210] = 68, 
                [211] = 52, 
                [212] = 92, 
                [213] = 136, 
                [214] = 84, 
                [215] = 12, 
                [216] = 92, 
                [217] = 138, 
                [218] = 68, 
                [219] = 52, 
                [220] = 92, 
                [221] = 2, 
                [222] = 194, 
                [223] = 15, 
                [224] = 182, 
                [225] = 192, 
                [226] = 138, 
                [227] = 68, 
                [228] = 4, 
                [229] = 92, 
                [230] = 138, 
                [231] = 227, 
                [232] = 48, 
                [233] = 68, 
                [234] = 60, 
                [235] = 48, 
                [236] = 71, 
                [237] = 131, 
                [238] = 255, 
                [239] = 20, 
                [240] = 114, 
                [241] = 203, 
                [242] = 51, 
                [243] = 255, 
                [244] = 137, 
                [245] = 124, 
                [246] = 36, 
                [247] = 44, 
                [248] = 139, 
                [249] = 239, 
                [250] = 199, 
                [251] = 68, 
                [252] = 36, 
                [253] = 36, 
                [254] = 15, 
                [255] = 0, 
                [256] = 0, 
                [257] = 0, 
                [258] = 139, 
                [259] = 124, 
                [260] = 36, 
                [261] = 36, 
                [262] = 209, 
                [263] = 237, 
                [264] = 137, 
                [265] = 108, 
                [266] = 36, 
                [267] = 72, 
                [268] = 15, 
                [269] = 183, 
                [270] = 76, 
                [271] = 172, 
                [272] = 50, 
                [273] = 139, 
                [274] = 193, 
                [275] = 15, 
                [276] = 191, 
                [277] = 201, 
                [278] = 137, 
                [279] = 68, 
                [280] = 36, 
                [281] = 84, 
                [282] = 15, 
                [283] = 183, 
                [284] = 68, 
                [285] = 172, 
                [286] = 52, 
                [287] = 189, 
                [288] = 133, 
                [289] = 142, 
                [290] = 213, 
                [291] = 145, 
                [292] = 139, 
                [293] = 208, 
                [294] = 137, 
                [295] = 76, 
                [296] = 36, 
                [297] = 68, 
                [298] = 139, 
                [299] = 216, 
                [300] = 137, 
                [301] = 84, 
                [302] = 36, 
                [303] = 76, 
                [304] = 139, 
                [305] = 193, 
                [306] = 15, 
                [307] = 183, 
                [308] = 240, 
                [309] = 43, 
                [310] = 221, 
                [311] = 36, 
                [312] = 15, 
                [313] = 139, 
                [314] = 213, 
                [315] = 138, 
                [316] = 200, 
                [317] = 209, 
                [318] = 194, 
                [319] = 102, 
                [320] = 211, 
                [321] = 203, 
                [322] = 139, 
                [323] = 234, 
                [324] = 102, 
                [325] = 139, 
                [326] = 195, 
                [327] = 209, 
                [328] = 197, 
                [329] = 102, 
                [330] = 51, 
                [331] = 198, 
                [332] = 43, 
                [333] = 242, 
                [334] = 15, 
                [335] = 183, 
                [336] = 216, 
                [337] = 138, 
                [338] = 203, 
                [339] = 128, 
                [340] = 225, 
                [341] = 15, 
                [342] = 102, 
                [343] = 211, 
                [344] = 206, 
                [345] = 102, 
                [346] = 51, 
                [347] = 240, 
                [348] = 15, 
                [349] = 183, 
                [350] = 206, 
                [351] = 15, 
                [352] = 183, 
                [353] = 198, 
                [354] = 131, 
                [355] = 239, 
                [356] = 1, 
                [357] = 117, 
                [358] = 203, 
                [359] = 139, 
                [360] = 124, 
                [361] = 36, 
                [362] = 40, 
                [363] = 139, 
                [364] = 197, 
                [365] = 43, 
                [366] = 216, 
                [367] = 137, 
                [368] = 108, 
                [369] = 36, 
                [370] = 36, 
                [371] = 51, 
                [372] = 92, 
                [373] = 36, 
                [374] = 80, 
                [375] = 131, 
                [376] = 199, 
                [377] = 2, 
                [378] = 139, 
                [379] = 108, 
                [380] = 36, 
                [381] = 72, 
                [382] = 209, 
                [383] = 192, 
                [384] = 43, 
                [385] = 200, 
                [386] = 137, 
                [387] = 124, 
                [388] = 36, 
                [389] = 40, 
                [390] = 139, 
                [391] = 68, 
                [392] = 36, 
                [393] = 76, 
                [394] = 51, 
                [395] = 76, 
                [396] = 36, 
                [397] = 44, 
                [398] = 15, 
                [399] = 183, 
                [400] = 192, 
                [401] = 137, 
                [402] = 68, 
                [403] = 36, 
                [404] = 80, 
                [405] = 139, 
                [406] = 68, 
                [407] = 36, 
                [408] = 84, 
                [409] = 15, 
                [410] = 183, 
                [411] = 192, 
                [412] = 102, 
                [413] = 137, 
                [414] = 92, 
                [415] = 172, 
                [416] = 52, 
                [417] = 102, 
                [418] = 137, 
                [419] = 76, 
                [420] = 172, 
                [421] = 50, 
                [422] = 137, 
                [423] = 68, 
                [424] = 36, 
                [425] = 44, 
                [426] = 131, 
                [427] = 255, 
                [428] = 9, 
                [429] = 15, 
                [430] = 130, 
                [431] = 69, 
                [432] = 255, 
                [433] = 255, 
                [434] = 255, 
                [435] = 139, 
                [436] = 68, 
                [437] = 36, 
                [438] = 48, 
                [439] = 139, 
                [440] = 76, 
                [441] = 36, 
                [442] = 88, 
                [443] = 193, 
                [444] = 248, 
                [445] = 16, 
                [446] = 193, 
                [447] = 249, 
                [448] = 16, 
                [449] = 51, 
                [450] = 193, 
                [451] = 185, 
                [452] = 36, 
                [453] = 36, 
                [454] = 0, 
                [455] = 0, 
                [456] = 95, 
                [457] = 94, 
                [458] = 102, 
                [459] = 59, 
                [460] = 193, 
                [461] = 93, 
                [462] = 15, 
                [463] = 148, 
                [464] = 192, 
                [465] = 91, 
                [466] = 129, 
                [467] = 196, 
                [468] = 76, 
                [469] = 1, 
                [470] = 0, 
                [471] = 0, 
                [472] = 195
            }));
        end;
        v234 = function(v241)
            -- upvalues: l_cast_0 (ref), l_band_0 (ref), l_rshift_0 (ref)
            local v242 = l_cast_0("uintptr_t*", v241[0]);
            if l_band_0(l_rshift_0(v242[13], 4), 1) == 1 and l_cast_0("uintptr_t*", v242[6] + 16)[0] ~= 0 then
                return false;
            elseif l_band_0(l_rshift_0(v242[13], 6), 1) == 0 then
                return false;
            elseif v242[8] ~= 0 then
                return false;
            elseif l_band_0(v242[13], 389) ~= 389 then
                return false;
            else
                return true;
            end;
        end;
        v235 = nil;
        v236 = function(v243)
            -- upvalues: l_type_0 (ref), l_get_local_player_0 (ref), v234 (ref), l_cast_0 (ref), v229 (ref), v113 (ref), l_lshift_0 (ref), v211 (ref), v225 (ref), l_get_0 (ref), l_globals_0 (ref), v110 (ref), l_abs_0 (ref), l_bxor_0 (ref), l_band_0 (ref), l_rshift_0 (ref), v235 (ref), v199 (ref), l_format_0 (ref)
            if l_type_0(v243) ~= "userdata" or v243.entity == nil then
                return nil;
            elseif v243.entity == l_get_local_player_0() then
                return nil;
            else
                local v244 = v234(v243);
                local v245 = l_cast_0("uint16_t*", l_cast_0("uint32_t", v243[0]) + 16)[0];
                local v246 = v229(v113(v243.entity));
                if v246 == nil or v243.sequence_bytes == 0 and v243.section_number == 0 and v243.uncompressed_sample_offset == 0 then
                    return;
                else
                    local v247 = l_lshift_0(v243.sequence_bytes + v243.section_number + v243.uncompressed_sample_offset, 4) % 4294967296;
                    if v244 == true then
                        if v243.is_nl then
                            return v211.NEVERLOSE, v247;
                        elseif v225(v243[0], v246.xuid_low) then
                            return v211.GAMESENSE, v247;
                        else
                            local l_buffer_0 = v243.buffer;
                            local v249 = l_buffer_0:read_bits(16);
                            local v250 = l_buffer_0:read_bits(7) + 1;
                            local v251 = l_buffer_0:read_bits(32);
                            local v252 = l_buffer_0:read_bits(7);
                            l_buffer_0:reset();
                            local v253 = l_get_0(v250);
                            local v254 = l_globals_0.server_tick - v251;
                            if v253 and v110(v253) and v252 >= 0 and v252 <= 127 and v254 > 0 and v254 * l_globals_0.tickinterval < 1 then
                                if l_abs_0(l_globals_0.curtime * 0.5 - v245) <= 2 then
                                    if v249 == 48879 then
                                        return v211.NIXWARE, v247;
                                    elseif v249 == 53456 then
                                        return v211.SPIRT, v247;
                                    end;
                                end;
                                return nil;
                            elseif v245 == 32762 then
                                return v211.FATALITY, v247;
                            elseif v245 == 22522 then
                                return v211.ONETAP, v247;
                            elseif v245 == 32764 or v245 == 32765 then
                                return v211.EVOLVE, v247;
                            elseif v245 == 26971 or v245 == 45041 or v245 == 6969 then
                                return v211.PANDORA, v247;
                            end;
                        end;
                    else
                        local l_sequence_bytes_0 = v243.sequence_bytes;
                        local l_uncompressed_sample_offset_0 = v243.uncompressed_sample_offset;
                        local v257 = l_bxor_0(l_band_0(l_sequence_bytes_0, 255), l_band_0(l_rshift_0(l_uncompressed_sample_offset_0, 16), 255)) - l_rshift_0(l_sequence_bytes_0, 16);
                        if v244 == false and l_band_0(v257, 255) == 77 then
                            local v258 = l_band_0(l_bxor_0(l_rshift_0(l_sequence_bytes_0, 16), l_rshift_0(l_sequence_bytes_0, 8)), 255);
                            local v259 = v258 >= 1 and v258 <= 64 and l_get_0(v258);
                            if v259 and v259 == v243.entity then
                                return v211.PRIMORDIAL, v247;
                            end;
                        end;
                    end;
                    if v235 == nil or v199 == 0 then
                        v235 = {};
                    end;
                    if v199 > 0 then
                        local v260 = false;
                        local v261 = v244 and "\aC0FF91" or "\aFF3E3E";
                        if v199 == 1 and v245 ~= v235[v113(v243.entity)] then
                            v235[v113(v243.entity)] = v245;
                            v260 = true;
                        end;
                        if v260 or v199 == 2 then
                            print_raw(l_format_0("\a9BF0EB[revealer] \aBABFCCentity: [%s] | pct: %s%d [0x%X] \aBABFCC[seqb: \aE4AF36%d\aBABFCC | secn: \aE4AF36%d\aBABFCC | ucso: \aE4AF36%d\aBABFCC]", v243.entity:get_name(), v261, v245, v245, v243.sequence_bytes, v243.section_number, v243.uncompressed_sample_offset));
                        end;
                    end;
                    return nil;
                end;
            end;
        end;
        local function v269(v262)
            -- upvalues: l_ipairs_0 (ref), l_pairs_0 (ref), l_max_0 (ref), l_sort_0 (ref), v228 (ref)
            local v263 = {};
            for _, v265 in l_ipairs_0(v262.records) do
                local v266 = false;
                for _, v268 in l_pairs_0(v263) do
                    if v268.signature == v265.signature then
                        v268.amount = v268.amount + 1;
                        v268.time = l_max_0(v268.time, v265.time);
                        if not v268.is_reliable then
                            v268.is_reliable = v268.amount > 4 or v265.is_shared;
                        end;
                        v266 = true;
                        break;
                    end;
                end;
                if not v266 then
                    v263[#v263 + 1] = {
                        amount = 1, 
                        is_reliable = false, 
                        time = v265.time, 
                        signature = v265.signature
                    };
                end;
            end;
            l_sort_0(v263, v228);
            v262.sorted_records = v263;
        end;
        local function v283(v270)
            -- upvalues: v224 (ref), l_abs_0 (ref), v198 (ref), l_get_players_0 (ref), l_tostring_0 (ref), l_pairs_0 (ref), v221 (ref), v197 (ref), l_ipairs_0 (ref), v269 (ref)
            local v271 = v224();
            if v270 ~= true then
                if l_abs_0(v198 - v271) <= 1 then
                    return;
                else
                    v198 = v271;
                end;
            end;
            local v272 = {};
            local v273 = false;
            l_get_players_0(false, true, function(v274)
                -- upvalues: v272 (ref), l_tostring_0 (ref)
                v272[l_tostring_0(v274:get_xuid())] = v274;
            end);
            for v275, v276 in l_pairs_0(v221) do
                if v272[v275] == nil or v271 < v276.heartbeat or v271 - v276.heartbeat >= v197 or #v276.records <= 0 then
                    v221[v275] = nil;
                    v273 = true;
                else
                    local v277 = {};
                    for _, v279 in l_ipairs_0(v276.records) do
                        if v279 ~= nil and v271 < v279.time or v271 - v279.time <= v197 then
                            v277[#v277 + 1] = v279;
                        end;
                    end;
                    if #v277 <= 0 then
                        v221[v275] = nil;
                        v273 = true;
                    else
                        v276.records = v277;
                        v269(v276);
                    end;
                end;
            end;
            if v273 == true then
                local v280 = {};
                for v281, v282 in l_pairs_0(v221) do
                    if v282 ~= nil then
                        v280[v281] = v282;
                    end;
                end;
                v221 = v280;
            end;
            return v221;
        end;
        local function v302(v284, v285, v286, v287, v288)
            -- upvalues: l_pairs_0 (ref), v211 (ref), v224 (ref), l_tostring_0 (ref), v221 (ref), l_ipairs_0 (ref), l_abs_0 (ref), l_remove_0 (ref), l_insert_0 (ref), v269 (ref)
            if v284 == nil or v285 == nil then
                return;
            else
                local v289 = false;
                for _, v291 in l_pairs_0(v211) do
                    if v285 == v291 then
                        v289 = true;
                        break;
                    end;
                end;
                if not v289 then
                    return;
                else
                    local v292 = v287 or v224();
                    local v293 = l_tostring_0(v284:get_xuid());
                    if not v286 then
                        v286 = false;
                    end;
                    v221[v293] = v221[v293] or {
                        heartbeat = 0, 
                        records = {}, 
                        sorted_records = {}
                    };
                    local v294 = v221[v293];
                    local l_records_0 = v294.records;
                    v294.heartbeat = v292;
                    if l_records_0 and #l_records_0 > 0 then
                        local v296 = false;
                        for _, v298 in l_ipairs_0(l_records_0) do
                            if v296 then
                                break;
                            elseif v298.signature == v285 then
                                v296 = true;
                                if l_abs_0(v292 - v298.time) <= 0.5 then
                                    return;
                                end;
                            end;
                        end;
                    end;
                    if #l_records_0 >= 16 then
                        for v299 = 16, #l_records_0 do
                            l_remove_0(l_records_0, v299);
                        end;
                    end;
                    for _, v301 in l_ipairs_0(l_records_0) do
                        if v288 ~= nil and v288 == v301.hash then
                            return false;
                        elseif v285 == v301.signature and v292 < v301.time then
                            return false;
                        end;
                    end;
                    l_insert_0(l_records_0, 1, {
                        signature = v285, 
                        is_shared = v286, 
                        time = v292, 
                        hash = v288
                    });
                    v269(v294);
                    return true;
                end;
            end;
        end;
        local function v310(v303, v304)
            -- upvalues: l_tostring_0 (ref), v221 (ref), l_ipairs_0 (ref), v224 (ref)
            if v303 == nil then
                return;
            else
                local v305 = v221[l_tostring_0(v303:get_xuid())];
                if v305 == nil or #v305.sorted_records <= 0 then
                    return;
                else
                    local v306 = {};
                    local v307 = #v305.records;
                    for _, v309 in l_ipairs_0(v305.sorted_records) do
                        if not v304 or v309.is_reliable then
                            v306[#v306 + 1] = {
                                signature = v309.signature, 
                                is_reliable = v309.is_reliable, 
                                amount = v309.amount / v307, 
                                heartbeat = v224() - v309.time
                            };
                        end;
                    end;
                    return #v306 > 0 and v306 or nil;
                end;
            end;
        end;
        local function v314(v311)
            -- upvalues: l_tostring_0 (ref), v221 (ref), v224 (ref)
            if v311 == nil then
                return;
            else
                local v312 = v221[l_tostring_0(v311:get_xuid())];
                if v312 == nil or #v312.sorted_records <= 0 then
                    return;
                else
                    local v313 = v312.sorted_records[1];
                    if not v313.is_reliable then
                        return;
                    else
                        return {
                            signature = v313.signature, 
                            amount = v313.amount / #v312.records, 
                            heartbeat = v224() - v313.time
                        };
                    end;
                end;
            end;
        end;
        local function v316(v315)
            -- upvalues: v212 (ref)
            return v212[v315] or nil;
        end;
        v283(true);
        local function v321(v317)
            -- upvalues: v236 (ref), v302 (ref)
            local l_entity_0 = v317.entity;
            if l_entity_0 == nil then
                return;
            else
                local v319, v320 = v236(v317);
                if v319 == nil then
                    return;
                else
                    v302(l_entity_0, v319, false, nil, v320);
                    return;
                end;
            end;
        end;
        local function v325()
            -- upvalues: v283 (ref), l_pairs_0 (ref), v222 (ref), v194 (ref), v220 (ref)
            local v322 = v283(true);
            local v323 = 0;
            for _ in l_pairs_0(v322) do
                v323 = v323 + 1;
            end;
            db[v222] = v323 > 0 and v194.encode(v220(json.stringify(v322))) or nil;
        end;
        local function v327()
            -- upvalues: l_globals_0 (ref), l_abs_0 (ref), v205 (ref), l_voice_modenable_0 (ref), l_cl_mute_enemy_team_0 (ref), l_cl_mute_all_but_friends_and_party_0 (ref), l_cl_mute_player_after_reporting_abuse_0 (ref)
            local l_realtime_0 = l_globals_0.realtime;
            if l_abs_0(l_realtime_0 - v205) <= 0.1 then
                return;
            else
                l_voice_modenable_0:int(1, true);
                l_cl_mute_enemy_team_0:int(0, true);
                l_cl_mute_all_but_friends_and_party_0:int(0, true);
                l_cl_mute_player_after_reporting_abuse_0:int(0, true);
                v205 = l_realtime_0;
                return;
            end;
        end;
        local function v328()
            -- upvalues: l_voice_modenable_0 (ref), l_tonumber_0 (ref), l_cl_mute_enemy_team_0 (ref), l_cl_mute_all_but_friends_and_party_0 (ref), l_cl_mute_player_after_reporting_abuse_0 (ref)
            l_voice_modenable_0:int(l_tonumber_0(l_voice_modenable_0:string()));
            l_cl_mute_enemy_team_0:int(l_tonumber_0(l_cl_mute_enemy_team_0:string()));
            l_cl_mute_all_but_friends_and_party_0:int(l_tonumber_0(l_cl_mute_all_but_friends_and_party_0:string()));
            l_cl_mute_player_after_reporting_abuse_0:int(l_tonumber_0(l_cl_mute_player_after_reporting_abuse_0:string()));
        end;
        events.render(v283);
        events.shutdown(v325);
        events.render(v327);
        events.shutdown(v328);
        l_voice_message_0(v321);
        return {
            get_all = v310, 
            get_software = v314, 
            get_icon = v316
        };
    end)();
    local v500 = (function()
        -- upvalues: l_tostring_0 (ref), l_tonumber_0 (ref), l_cast_0 (ref), l_xpcall_0 (ref), l_pcall_0 (ref), l_next_0 (ref), l_format_0 (ref), l_string_0 (ref), l_gsub_0 (ref), l_sub_0 (ref), l_type_0 (ref)
        local v330 = nil;
        local v331 = nil;
        local v332 = ffi.typeof("                struct {\n                    void(__thiscall *run1)(void*, void*, bool, uint64_t);\n                    void(__thiscall *run2)(void*, void*);\n                    int(__thiscall *get_size)(void*);\n                }\n            ");
        local v333 = ffi.typeof("                struct {\n                    $ *vtbl;\n                    uint8_t flags;\n                    int id;\n                    uint64_t api_call_handle;\n                    $ vtbl_storage[1];\n                }\n            ", v332, v332);
        local v334 = nil;
        local v335 = nil;
        local v336 = nil;
        local v337 = nil;
        local l_v333_0 = v333;
        local v339 = ffi.sizeof(l_v333_0);
        local v340 = ffi.typeof("$[1]", v333);
        local v341 = ffi.typeof("$*", v333);
        local v342 = ffi.typeof("uintptr_t");
        local v343 = {};
        local v344 = {};
        local v345 = {};
        do
            local l_v334_0, l_v335_0, l_v336_0, l_v337_0, l_v339_0, l_v340_0, l_v341_0, l_v342_0, l_v343_0, l_v344_0, l_v345_0 = v334, v335, v336, v337, v339, v340, v341, v342, v343, v344, v345;
            local function v358(v357)
                -- upvalues: l_tostring_0 (ref), l_tonumber_0 (ref), l_cast_0 (ref), l_v342_0 (ref)
                return l_tostring_0(l_tonumber_0(l_cast_0(l_v342_0, v357)));
            end;
            local function v364(v359, v360, v361)
                -- upvalues: v358 (ref), l_v343_0 (ref), l_xpcall_0 (ref), l_v344_0 (ref)
                v359.api_call_handle = 0;
                local v362 = v358(v359);
                local v363 = l_v343_0[v362];
                if v363 ~= nil then
                    l_xpcall_0(v363, print, v360, v361);
                end;
                if l_v344_0[v362] ~= nil then
                    l_v343_0[v362] = nil;
                    l_v344_0[v362] = nil;
                end;
            end;
            local function v369(v365, v366, v367, v368)
                -- upvalues: v364 (ref)
                if v368 == v365.api_call_handle then
                    v364(v365, v366, v367);
                end;
            end;
            local function v372(v370, v371)
                -- upvalues: v364 (ref)
                v364(v370, v371, false);
            end;
            local function v373()
                -- upvalues: l_v339_0 (ref)
                return l_v339_0;
            end;
            local function v376(v374)
                -- upvalues: l_v335_0 (ref), v358 (ref), l_v343_0 (ref), l_v344_0 (ref)
                if v374.api_call_handle ~= 0 then
                    l_v335_0(v374, v374.api_call_handle);
                    v374.api_call_handle = 0;
                    local v375 = v358(v374);
                    l_v343_0[v375] = nil;
                    l_v344_0[v375] = nil;
                end;
            end;
            l_pcall_0(ffi.metatype, l_v333_0, {
                __gc = v376, 
                __index = {
                    cancel = v376
                }
            });
            local v377 = l_cast_0(ffi.typeof("void(__thiscall*)($*, void*, bool, uint64_t)", v333), v369);
            local v378 = l_cast_0(ffi.typeof("void(__thiscall*)($*, void*)", v333), v372);
            local v379 = l_cast_0(ffi.typeof("int(__thiscall*)($*)", v333), v373);
            v330 = function(v380, v381, v382)
                -- upvalues: l_v340_0 (ref), l_cast_0 (ref), l_v341_0 (ref), v377 (ref), v378 (ref), v379 (ref), v358 (ref), l_v343_0 (ref), l_v344_0 (ref), l_v334_0 (ref)
                if v380 ~= 0 then
                    local v383 = l_v340_0();
                    local v384 = l_cast_0(l_v341_0, v383);
                    v384.vtbl_storage[0].run1 = v377;
                    v384.vtbl_storage[0].run2 = v378;
                    v384.vtbl_storage[0].get_size = v379;
                    v384.vtbl = v384.vtbl_storage;
                    v384.api_call_handle = v380;
                    v384.id = v382;
                    local v385 = v358(v384);
                    l_v343_0[v385] = v381;
                    l_v344_0[v385] = v383;
                    l_v334_0(v384, v380);
                    return v384;
                else
                    return;
                end;
            end;
            v331 = function(v386, v387)
                -- upvalues: l_v345_0 (ref), l_v340_0 (ref), l_cast_0 (ref), l_v341_0 (ref), v377 (ref), v378 (ref), v379 (ref), v358 (ref), l_v343_0 (ref), l_v336_0 (ref)
                if l_v345_0[v386] == nil then
                    local v388 = l_v340_0();
                    local v389 = l_cast_0(l_v341_0, v388);
                    v389.vtbl_storage[0].run1 = v377;
                    v389.vtbl_storage[0].run2 = v378;
                    v389.vtbl_storage[0].get_size = v379;
                    v389.vtbl = v389.vtbl_storage;
                    v389.api_call_handle = 0;
                    v389.id = v386;
                    l_v343_0[v358(v389)] = v387;
                    l_v345_0[v386] = v388;
                    l_v336_0(v389, v386);
                end;
            end;
            l_v334_0 = l_cast_0(ffi.typeof("void(__cdecl*)($*, uint64_t)", v333), utils.opcode_scan("steam_api.dll", "55 8B EC 83 3D ? ? ? ? ? 7E ? 68 ? ? ? ? FF 15 ? ? ? ? 5D C3 FF 75 ? C7 05 ? ? ? ? ? ? ? ? FF 75 ? FF 75 ?"));
            l_v335_0 = l_cast_0(ffi.typeof("void(__cdecl*)($*, uint64_t)", v333), utils.opcode_scan("steam_api.dll", "55 8B EC FF 75 ? FF 75 ? FF 75 ? E8 ? ? ? ?"));
            l_v336_0 = l_cast_0(ffi.typeof("void(__cdecl*)($*, int)", v333), utils.opcode_scan("steam_api.dll", "55 8B EC 83 3D ? ? ? ? ? 7E ? 68 ? ? ? ? FF 15 ? ? ? ? 5D C3 C7 05 ? ? ? ? ? ? ? ?"));
            l_v337_0 = l_cast_0(ffi.typeof("void(__cdecl*)($*)", v333), utils.opcode_scan("steam_api.dll", "E9 ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? 55 8B EC"));
            _G.events.shutdown(function()
                -- upvalues: l_next_0 (ref), l_v344_0 (ref), l_cast_0 (ref), l_v341_0 (ref), v376 (ref), l_v345_0 (ref), l_v337_0 (ref)
                for _, v391 in l_next_0, l_v344_0 do
                    local v392 = l_cast_0(l_v341_0, v391);
                    v376(v392);
                end;
                for _, v394 in l_next_0, l_v345_0 do
                    local v395 = l_cast_0(l_v341_0, v394);
                    l_v337_0(v395);
                end;
            end);
        end;
        v332 = ffi.typeof("            struct {\n                bool(__thiscall *ISteamHTMLSurface)(uintptr_t);\n                bool(__thiscall *Init)(uintptr_t);\n                bool(__thiscall *Shutdown)(uintptr_t);\n                uint64_t(__thiscall *CreateBrowser)(uintptr_t, const char*, const char*);\n                void(__thiscall *RemoveBrowser)(uintptr_t, uint32_t);\n                void(__thiscall *LoadURL)(uintptr_t, uint32_t, const char*, const char*);\n                void(__thiscall *SetSize)(uintptr_t, uint32_t, uint32_t, uint32_t);\n                void(__thiscall *StopLoad)(uintptr_t, uint32_t);\n                void(__thiscall *Reload)(uintptr_t, uint32_t);\n                void(__thiscall *GoBack)(uintptr_t, uint32_t);\n                void(__thiscall *GoForward)(uintptr_t, uint32_t);\n                void(__thiscall *AddHeader)(uintptr_t, uint32_t, const char*, const char*);\n                void(__thiscall *ExecuteJavascript)(uintptr_t, uint32_t, const char*);\n                void(__thiscall *MouseUp)(uintptr_t, uint32_t, int);\n                void(__thiscall *MouseDown)(uintptr_t, uint32_t, int);\n                void(__thiscall *MouseDoubleClick)(uintptr_t, uint32_t, int);\n                void(__thiscall *MouseMove)(uintptr_t, uint32_t, int, int);\n                void(__thiscall *MouseWheel)(uintptr_t, uint32_t, int32_t);\n                void(__thiscall *KeyDown)(uintptr_t, uint32_t, uint32_t, int, bool);\n                void(__thiscall *KeyUp)(uintptr_t, uint32_t, uint32_t, int);\n                void(__thiscall *KeyChar)(uintptr_t, uint32_t, uint32_t, int);\n                void(__thiscall *SetHorizontalScroll)(uintptr_t, uint32_t, uint32_t);\n                void(__thiscall *SetVerticalScroll)(uintptr_t, uint32_t, uint32_t);\n                void(__thiscall *SetKeyFocus)(uintptr_t, uint32_t, bool);\n                void(__thiscall *ViewSource)(uintptr_t, uint32_t);\n                void(__thiscall *CopyToClipboard)(uintptr_t, uint32_t);\n                void(__thiscall *PasteFromClipboard)(uintptr_t, uint32_t);\n                void(__thiscall *Find)(uintptr_t, uint32_t, const char*, bool, bool);\n                void(__thiscall *StopFind)(uintptr_t, uint32_t);\n                void(__thiscall *GetLinkAtPosition)(uintptr_t, uint32_t, int, int);\n                void(__thiscall *SetCookie)(uintptr_t, const char*, const char*, const char*, const char*, uint32_t, bool, bool);\n                void(__thiscall *SetPageScaleFactor)(uintptr_t, uint32_t, float, int, int);\n                void(__thiscall *SetBackgroundMode)(uintptr_t, uint32_t, bool);\n                void(__thiscall *SetDPIScalingFactor)(uintptr_t, uint32_t, float);\n                void(__thiscall *OpenDeveloperTools)(uintptr_t, uint32_t);\n                void(__thiscall *AllowStartRequest)(uintptr_t, uint32_t, bool);\n                void(__thiscall *JSDialogResponse)(uintptr_t, uint32_t, bool);\n                void(__thiscall *FileLoadDialogResponse)(uintptr_t, uint32_t, const char**);\n            }\n        ");
        v333 = 4501;
        v334 = 4503;
        v335 = 4505;
        v336 = 4508;
        v337 = 4514;
        l_v333_0 = function()
            -- upvalues: l_cast_0 (ref), v332 (ref)
            local v396 = l_cast_0("uintptr_t", utils.opcode_scan("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84", 1));
            v396 = l_cast_0("uintptr_t*", v396)[0];
            v396 = l_cast_0("uintptr_t", v396);
            local v397 = l_cast_0("uintptr_t*", v396)[18];
            if v397 == 0 then
                return error("find_isteamhtmlsurface failed");
            else
                local v398 = l_cast_0(ffi.typeof("$**", v332), v397)[0];
                if v398 == nil then
                    return error("find_isteamhtmlsurface failed");
                else
                    return v397, v398;
                end;
            end;
        end;
        v339 = function(v399, v400)
            return function(...)
                -- upvalues: v399 (ref), v400 (ref)
                return v399(v400, ...);
            end;
        end;
        v340 = ffi.typeof("            struct {\n                uint32_t unBrowserHandle;\n            } *\n        ");
        v341 = ffi.typeof("            struct {\n                uint32_t unBrowserHandle;\n                const char* pchURL;\n                const char* pchTarget;\n                const char* pchPostData;\n                bool bIsRedirect;\n            } *\n        ");
        v342 = ffi.typeof("            struct {\n                uint32_t unBrowserHandle;\n                const char* pchMessage;\n            } *\n        ");
        v343 = ffi.typeof("            struct {\n                uint32_t unBrowserHandle;\n                const char* pchTitle;\n            } *\n        ");
        v344 = ffi.typeof("            struct {\n                uint32_t unBrowserHandle;\n                const char* pchURL;\n                const char* pchPostData;\n                bool bIsRedirect;\n                const char* pchPageTitle;\n                bool bNewNavigation;\n            } *\n        ");
        local v401;
        v345, v401 = l_v333_0();
        local v402 = v339(v401.CreateBrowser, v345);
        local v403 = v339(v401.RemoveBrowser, v345);
        local v404 = v339(v401.LoadURL, v345);
        local v405 = v339(v401.ExecuteJavascript, v345);
        local v406 = v339(v401.AllowStartRequest, v345);
        local v407 = v339(v401.JSDialogResponse, v345);
        local v408 = nil;
        local v409 = {};
        local v414 = {
            send = function(v410)
                -- upvalues: v408 (ref), v405 (ref), l_format_0 (ref)
                if v408 ~= nil then
                    v405(v408, l_format_0("Client.receive(%s)", json.stringify(v410)));
                end;
            end, 
            receive = function(v411)
                -- upvalues: v409 (ref)
                v411 = json.parse(v411);
                if v409[v411.type] ~= nil then
                    v409[v411.type](v411);
                end;
            end, 
            register_handler = function(v412, v413)
                -- upvalues: v409 (ref)
                v409[v412] = v413;
            end
        };
        local v415 = {};
        local v418 = {
            register = function(v416, v417)
                -- upvalues: v415 (ref)
                v415[v416] = v417;
            end
        };
        v414.register_handler("rpc", function(v419)
            -- upvalues: v415 (ref), l_pcall_0 (ref), v414 (ref)
            if v415[v419.method] then
                local v420 = {
                    type = "rpc_resp", 
                    id = v419.id
                };
                local v421, v422 = l_pcall_0(v415[v419.method], unpack(v419.params or {}));
                if v421 then
                    v420.result = v422;
                else
                    v420.error = v422;
                end;
                v414.send(v420);
            end;
        end);
        local v423 = {};
        local v424 = 0;
        local v429 = {
            call = function(v425, v426, ...)
                -- upvalues: v424 (ref), v423 (ref), v414 (ref)
                v424 = v424 + 1;
                local v427 = {
                    type = "rpc", 
                    method = v425, 
                    id = v424
                };
                local v428 = {
                    ...
                };
                if #v428 > 0 then
                    v427.params = v428;
                end;
                v423[v424] = v426;
                v414.send(v427);
            end
        };
        v414.register_handler("rpc_resp", function(v430)
            -- upvalues: v423 (ref), l_xpcall_0 (ref)
            if v423[v430.id] ~= nil then
                if v430.error ~= nil then
                    l_xpcall_0(v423[v430.id], print, v430.error);
                else
                    l_xpcall_0(v423[v430.id], print, nil, v430.result);
                end;
            end;
        end);
        local function v450(v431)
            -- upvalues: l_cast_0 (ref), v340 (ref), v408 (ref), v404 (ref), v331 (ref), v334 (ref), v341 (ref), v406 (ref), v337 (ref), v342 (ref), l_string_0 (ref), v414 (ref), v407 (ref), v336 (ref), v343 (ref), l_gsub_0 (ref), l_sub_0 (ref), v405 (ref), l_xpcall_0 (ref), v335 (ref), v344 (ref), v402 (ref), v330 (ref), v333 (ref), v403 (ref)
            local v432 = "                // communication with client\n                var Client = (function(){\n                    var handlers = {}\n                    var _SendMessage = function(message) {\n                        var json = JSON.stringify(message)\n\n                        // console.log(`sending ${json}`)\n\n                        if(json.length > 10200) {\n                            // alert has a size limit, so we need to use document.location.hash - should be rare since it has its own rate limiting too\n                            var ensureChangeChar = document.location.hash[1] == 'h' ? 'H' : 'h'\n\n                            // setting location causes a HTML_ChangedTitle_t event (even if the title didnt actually change) so we set it to an empty string here and avoid that\n                            document.title = ''\n                            document.location.hash = ensureChangeChar + json\n\n                            // console.log('used hash with ensureChangeChar ' + JSON.stringify(ensureChangeChar))\n                        } else if(json.length > 4090) {\n                            // alert has no rate limit but is rather slow (and limited to 10240 chars), so only use it if its required\n                            alert(json)\n                            // console.log('used alert')\n                        } else {\n                            // title has an even smaller size limit (4096), but its the fastest\n                            var ensureChangeChar = document.title[0] == 't' ? 'T' : 't'\n                            document.title = ensureChangeChar + json\n                            // console.log('used title with ensureChangeChar ' + JSON.stringify(ensureChangeChar) + ' because title is ' + JSON.stringify(document.title))\n                        }\n                    }\n\n                    var _RegisterHandler = function(type, callback) {\n                        handlers[type] = callback\n                    }\n\n                    var _ReceiveMessage = function(message) {\n                        if(handlers[message.type]) {\n                            handlers[message.type](message)\n                        }\n                    }\n\n                    return {\n                        send: _SendMessage,\n                        register_handler: _RegisterHandler,\n                        receive: _ReceiveMessage\n                    }\n                })()\n\n                var RPCServer = (function(){\n                    var rpc_functions = {}\n\n                    // internal func to handle incoming RPC messages\n                    var _RPCHandler = function(message) {\n                        if(rpc_functions[message.method]) {\n                            var resp = {\n                                type: 'rpc_resp',\n                                id: message.id\n                            }\n\n                            try {\n                                var params = message.params || []\n\n                                resp.result = rpc_functions[message.method](...params)\n                            } catch (e) {\n                                resp.error = e.toString()\n                            }\n\n                            Client.send(resp)\n                        }\n                    }\n                    Client.register_handler('rpc', _RPCHandler)\n\n                    var _RegisterRPCFunction = function(name, callback) {\n                        rpc_functions[name] = callback\n                    }\n\n                    return {\n                        register: _RegisterRPCFunction\n                    }\n                })()\n\n                RPCServer.register('add', function(a, b){\n                    return a + b\n                })\n\n                var RPCClient = (function(){\n                    var index = 0\n                    var pending_requests = {}\n\n                    var _RPCRespHandler = function(message) {\n                        if(pending_requests[message.id]) {\n                            if(message.error) {\n                                pending_requests[message.id].reject(message.error)\n                            } else {\n                                pending_requests[message.id].resolve(message.result)\n                            }\n                            pending_requests[message.id] = null\n                        }\n                    }\n                    Client.register_handler('rpc_resp', _RPCRespHandler)\n\n                    var _Call = async function(method, params) {\n                        index += 1\n                        var req = {\n                            type: 'rpc',\n                            method: method,\n                            id: index\n                        }\n\n                        if(params) {\n                            req.params = params\n                        }\n\n                        var result = new Promise((resolve, reject) => {\n                            pending_requests[index] = {resolve: resolve, reject: reject}\n                        })\n\n                        Client.send(req)\n\n                        return result\n                    }\n\n                    return {\n                        call: _Call\n                    }\n                })()\n\n                // websocket implementation\n                var ws_api = (function(){\n                    var open_websockets = []\n                    var socket_index = 0\n\n                    var _OnOpen = function(index, e) {\n                        RPCClient.call('ws_open', [index, {extensions: e.target.extensions, protocol: e.target.protocol}])\n                    }\n\n                    var _OnMessage = function(index, e) {\n                        RPCClient.call('ws_message', [index, e.data])\n                    }\n\n                    var _OnClose = function(index, e) {\n                        RPCClient.call('ws_closed', [index, e.code, e.reason, e.wasClean])\n                        open_websockets[index] = null\n                    }\n\n                    var _OnError = function(index, error) {\n                        RPCClient.call('ws_error', [index])\n                    }\n\n                    RPCServer.register('ws_create', function(url, protocols){\n                        var index = socket_index++\n                        console.log(`creating websocket with index ${index}`)\n                        var socket = (typeof protocols != 'undefined') ? (new WebSocket(url, protocols)) : (new WebSocket(url))\n\n                        socket.onopen = _OnOpen.bind(null, index)\n                        socket.onmessage = _OnMessage.bind(null, index)\n                        socket.onclose = _OnClose.bind(null, index)\n                        socket.onerror = _OnError.bind(null, index)\n\n                        open_websockets[index] = socket\n\n                        return index\n                    })\n\n                    RPCServer.register('ws_send', function(index, data){\n                        if(open_websockets[index]) {\n                            console.log('sending ', data)\n                            open_websockets[index].send(data)\n                        }\n                    })\n\n                    RPCServer.register('ws_close', function(index, code, reason){\n                        if(open_websockets[index]) {\n                            open_websockets[index].close(code, reason)\n                        }\n                    })\n                })()\n\n                RPCClient.call('browser_ready')\n            ";
            local v433 = false;
            local function v436(v434)
                -- upvalues: l_cast_0 (ref), v340 (ref), v408 (ref), v404 (ref)
                if v434 == nil then
                    return;
                else
                    local v435 = l_cast_0(v340, v434);
                    if v435.unBrowserHandle == nil then
                        return;
                    else
                        v408 = v435.unBrowserHandle;
                        v404(v408, "about:blank", "");
                        return;
                    end;
                end;
            end;
            v331(v334, function(v437)
                -- upvalues: l_cast_0 (ref), v341 (ref), v408 (ref), v406 (ref)
                if v437 == nil then
                    return;
                else
                    if l_cast_0(v341, v437).unBrowserHandle == v408 then
                        v406(v408, true);
                    end;
                    return;
                end;
            end);
            v331(v337, function(v438)
                -- upvalues: l_cast_0 (ref), v342 (ref), v408 (ref), l_string_0 (ref), v414 (ref), v407 (ref)
                if v438 == nil then
                    return;
                else
                    local v439 = l_cast_0(v342, v438);
                    if v439.unBrowserHandle == v408 and v439.pchMessage ~= nil then
                        local v440 = l_string_0(v439.pchMessage);
                        v414.receive(v440);
                        v407(v408, false);
                    end;
                    return;
                end;
            end);
            v331(v336, function(v441)
                -- upvalues: l_cast_0 (ref), v343 (ref), v408 (ref), l_string_0 (ref), v433 (ref), l_gsub_0 (ref), l_sub_0 (ref), v414 (ref), v405 (ref), v432 (ref), v431 (ref), l_xpcall_0 (ref)
                if v441 == nil then
                    return;
                else
                    local v442 = l_cast_0(v343, v441);
                    if v442.unBrowserHandle == v408 and v442.pchTitle ~= nil then
                        local v443 = l_string_0(v442.pchTitle);
                        if v433 then
                            v443 = l_gsub_0(v443, "^about:blank#", "");
                            local v444 = l_sub_0(v443, 1, 1);
                            if v444 == "t" or v444 == "T" then
                                v414.receive(l_sub_0(v443, 2, -1));
                            end;
                        elseif v443 == "about:blank" then
                            v405(v408, v432);
                            v433 = true;
                            if v431 ~= nil then
                                l_xpcall_0(v431, print);
                            end;
                        end;
                    end;
                    return;
                end;
            end);
            v331(v335, function(v445)
                -- upvalues: l_cast_0 (ref), v344 (ref), v408 (ref), l_string_0 (ref), v433 (ref), l_sub_0 (ref), v414 (ref)
                if v445 == nil then
                    return;
                else
                    local v446 = l_cast_0(v344, v445);
                    if v446.unBrowserHandle == v408 and v446.bNewNavigation == false and v446.bIsRedirect == false and v446.pchURL ~= nil then
                        local v447 = l_string_0(v446.pchURL);
                        if v433 then
                            local v448 = l_sub_0(v447, 1, 13);
                            if v448 == "about:blank#h" or v448 == "about:blank#H" then
                                v414.receive(l_sub_0(v447, 14, -1));
                            end;
                        end;
                    end;
                    return;
                end;
            end);
            local v449 = v402(nil, nil);
            v330(v449, v436, v333);
            _G.events.shutdown(function()
                -- upvalues: v408 (ref), v403 (ref)
                if v408 ~= nil then
                    v403(v408);
                    v408 = nil;
                end;
            end);
        end;
        local v451 = {};
        local v452 = setmetatable({}, {
            __mode = "k"
        });
        local function v456(v453, v454)
            -- upvalues: v452 (ref), l_xpcall_0 (ref)
            if v454 ~= nil then
                local v455 = v452[v453];
                if v455 ~= nil and v455.callback_error ~= nil then
                    l_xpcall_0(v455.callback_error, print, v453, v454);
                end;
            end;
        end;
        local v464 = {
            __metatable = false, 
            __index = {
                close = function(v457, v458, v459)
                    -- upvalues: v452 (ref), v429 (ref), v339 (ref), v456 (ref)
                    local v460 = v452[v457];
                    if v460 == nil then
                        return;
                    elseif not v460.open then
                        return;
                    else
                        v429.call("ws_close", v339(v456, v457), v460.index, v458, v459);
                        return;
                    end;
                end, 
                send = function(v461, v462)
                    -- upvalues: v452 (ref), v429 (ref), v339 (ref), v456 (ref), l_tostring_0 (ref)
                    local v463 = v452[v461];
                    if v463 == nil then
                        return;
                    elseif not v463.open then
                        return;
                    else
                        v429.call("ws_send", v339(v456, v461), v463.index, l_tostring_0(v462));
                        return;
                    end;
                end
            }
        };
        v418.register("ws_open", function(v465, v466)
            -- upvalues: v451 (ref), v452 (ref), l_xpcall_0 (ref)
            local v467 = v451[v465];
            local v468 = v452[v467];
            if v468 ~= nil then
                v467.open = true;
                v468.open = true;
                v467.protocol = v466.protocol;
                v467.extensions = v466.extensions;
                if v468.callback_open ~= nil then
                    l_xpcall_0(v468.callback_open, print, v467);
                end;
            end;
        end);
        v418.register("ws_message", function(v469, v470)
            -- upvalues: v451 (ref), v452 (ref), l_xpcall_0 (ref)
            local v471 = v451[v469];
            local v472 = v452[v471];
            if v472 ~= nil and v472.callback_message ~= nil then
                l_xpcall_0(v472.callback_message, print, v471, v470);
            end;
        end);
        v418.register("ws_closed", function(v473, v474, v475, v476)
            -- upvalues: v451 (ref), v452 (ref), l_xpcall_0 (ref)
            local v477 = v451[v473];
            local v478 = v452[v477];
            if v478 ~= nil then
                v477.open = false;
                v478.open = false;
                if v478.callback_close ~= nil then
                    l_xpcall_0(v478.callback_close, print, v477, v474, v475, v476);
                end;
                v451[v473] = nil;
                v452[v477] = nil;
            end;
        end);
        v418.register("ws_error", function(v479)
            -- upvalues: v451 (ref), v452 (ref), l_xpcall_0 (ref)
            local v480 = v451[v479];
            local v481 = v452[v480];
            if v481 ~= nil and v481.callback_error ~= nil then
                l_xpcall_0(v481.callback_error, print, v480);
            end;
        end);
        local v482 = 0;
        local v483 = {};
        local function v491(v484, v485, v486, v487)
            -- upvalues: v452 (ref), v429 (ref), l_xpcall_0 (ref), v451 (ref)
            local l_error_0 = v487.error;
            v452[v484] = {
                open = false, 
                callback_open = v487.open, 
                callback_error = l_error_0, 
                callback_message = v487.message, 
                callback_close = v487.close
            };
            v429.call("ws_create", function(v489, v490)
                -- upvalues: l_error_0 (ref), l_xpcall_0 (ref), v484 (ref), v452 (ref), v451 (ref)
                if v489 then
                    if l_error_0 ~= nil then
                        l_xpcall_0(l_error_0, print, v484, v489);
                    end;
                    v452[v484] = nil;
                    return;
                else
                    v451[v490] = v484;
                    v452[v484].index = v490;
                    return;
                end;
            end, v485, v486);
        end;
        return function(v492, v493, v494)
            -- upvalues: l_type_0 (ref), v482 (ref), v450 (ref), v483 (ref), l_xpcall_0 (ref), v491 (ref), v464 (ref)
            if v494 == nil then
                v494 = v493;
                v493 = nil;
            end;
            if l_type_0(v492) ~= "string" then
                return error("Invalid url, has to be a string");
            elseif l_type_0(v494) ~= "table" then
                return error("Invalid callbacks, has to be a table");
            elseif v494.open == nil or l_type_0(v494.open) ~= "function" then
                return error("Invalid callbacks, open callback has to be registered");
            elseif v494.open == nil and v494.error == nil and v494.message == nil and v494.close == nil then
                return error("Invalid callbacks, at least one callback has to be registered");
            elseif v494.error ~= nil and l_type_0(v494.error) ~= "function" or v494.message ~= nil and l_type_0(v494.message) ~= "function" or v494.close ~= nil and l_type_0(v494.close) ~= "function" then
                return error("Invalid callbacks, all callbacks have to be functions");
            else
                local v495 = nil;
                if l_type_0(v493) == "table" then
                    if l_type_0(v493.protocols) == "string" then
                        v495 = v493.protocols;
                    elseif l_type_0(v493.protocols) == "table" and #v493.protocols > 0 then
                        for v496 = 1, #v493.protocols do
                            if l_type_0(v493.protocols[v496]) ~= "string" then
                                return error("Invalid options.protocols, has to be an array of strings");
                            end;
                        end;
                        v495 = v493.protocols;
                    elseif v493.protocols ~= nil then
                        return error("Invalid options.protocols, has to be a string or array");
                    end;
                elseif v493 ~= nil then
                    return error("Invalid options, has to be a table");
                end;
                if v482 == 0 then
                    v482 = 1;
                    v450(function()
                        -- upvalues: v482 (ref), v483 (ref), l_xpcall_0 (ref), v491 (ref)
                        v482 = 2;
                        for v497 = 1, #v483 do
                            local v498 = v483[v497];
                            l_xpcall_0(v491, print, v498.websocket, v498.url, v498.protocols, v498.callbacks);
                        end;
                        v483 = nil;
                    end);
                end;
                local v499 = setmetatable({
                    open = false, 
                    url = v492
                }, v464);
                if v482 ~= 2 then
                    v483[#v483 + 1] = {
                        websocket = v499, 
                        url = v492, 
                        protocols = v495, 
                        callbacks = v494
                    };
                else
                    v491(v499, v492, v495, v494);
                end;
                return v499;
            end;
        end;
    end)();
    local l_events_0 = events;
    local v502 = nil;
    local v503 = {};
    do
        local l_v503_0 = v503;
        local function v516(v505, v506, v507)
            -- upvalues: l_v503_0 (ref), l_events_0 (ref), l_get_local_player_0 (ref), v110 (ref), v105 (ref), v107 (ref), l_get_players_0 (ref), l_next_0 (ref)
            local v508 = l_v503_0[v505];
            if v508 == nil then
                l_v503_0[v505] = {};
                l_events_0[v505](function(...)
                    -- upvalues: l_get_local_player_0 (ref), v110 (ref), v105 (ref), v107 (ref), l_get_players_0 (ref), l_next_0 (ref), v508 (ref)
                    local v509 = {};
                    local v510 = l_get_local_player_0();
                    if v510 ~= nil then
                        v509.localplayer = v510;
                        v509.is_alive = v110(v510);
                        v509.eye_position = v105(v510);
                        local v511 = v107(v510);
                        local l_v511_0 = v511;
                        v509.weapon_info = v511 ~= nil and v511:get_weapon_info() or nil;
                        v509.weapon = l_v511_0;
                    end;
                    v509.players = l_get_players_0(false, true);
                    v509.enemies = l_get_players_0(true, false);
                    v509.all_enemies = l_get_players_0(true, true);
                    local v513 = nil;
                    for v514 in l_next_0, v508 do
                        local v515 = v514(v509, ...);
                        if v515 ~= nil then
                            v513 = v515;
                        end;
                    end;
                    return v513;
                end);
            end;
            v508 = l_v503_0[v505];
            v508[v506] = v507 == true or not (v507 ~= nil) or nil;
        end;
        v502 = function(_)
            -- upvalues: v516 (ref)
            return v516;
        end;
    end;
    v503 = (function()
        -- upvalues: l_tostring_0 (ref), l_vector_0 (ref), l_is_button_down_0 (ref), l_max_0 (ref), l_min_0 (ref), v118 (ref)
        local v521 = {
            group = ui.create("dragging"), 
            is_in_area = function(v518, v519, v520)
                return v518.x >= v519.x and v518.x <= v519.x + v520.x and v518.y >= v519.y and v518.y <= v519.y + v520.y;
            end
        };
        local function v538(v522, v523, v524)
            -- upvalues: l_tostring_0 (ref), l_vector_0 (ref), l_is_button_down_0 (ref), v521 (ref), l_max_0 (ref), l_min_0 (ref), v118 (ref)
            local v525 = l_tostring_0(v523);
            local v526 = v524 or l_vector_0();
            local v527 = {
                dragging = false, 
                positions = {
                    x = v522.group:slider("x: " .. v525, -99999, 99999, v526.x):visibility(false), 
                    y = v522.group:slider("y: " .. v525, -99999, 99999, v526.y):visibility(false)
                }
            };
            local v537 = {
                get_position = function(v528)
                    -- upvalues: l_vector_0 (ref)
                    return v528.position or l_vector_0(v528.positions.x:get(), v528.positions.y:get());
                end, 
                update = function(v529, v530, v531)
                    -- upvalues: l_vector_0 (ref), l_is_button_down_0 (ref), v521 (ref), v525 (ref), l_max_0 (ref), l_min_0 (ref), v118 (ref), v526 (ref), v527 (ref)
                    if not v531 then
                        v531 = l_vector_0();
                    end;
                    v529.position = l_vector_0(v529.positions.x:get(), v529.positions.y:get());
                    local v532 = l_is_button_down_0(1);
                    local v533 = l_is_button_down_0(2);
                    local v534 = ui.get_mouse_position();
                    if not (ui.get_alpha() > 0) then
                        return;
                    else
                        local v535 = v521.is_in_area(v534, v529.position - v531, v530 + v531);
                        if (v532 or v533) and v529.intersected == nil then
                            v529.intersected = v535;
                            v529.drag_position = v534 - v529.position;
                        end;
                        if (v532 or v533) and v529.intersected then
                            v529.dragging = true;
                        elseif not v532 and not v533 then
                            v529.dragging = false;
                            v529.intersected = nil;
                            v521.target = nil;
                        end;
                        if v529.dragging then
                            if v521.target == nil or v521.target == v525 then
                                v521.target = v525;
                                if v532 then
                                    local v536 = v534 - v529.drag_position;
                                    v529.positions.x:set(l_max_0(1 + v531.x, l_min_0(v118.x - v530.x - 1, v536.x)));
                                    v529.positions.y:set(l_max_0(1 + v531.y, l_min_0(v118.y - v530.y - 1, v536.y)));
                                else
                                    v529.positions.x:set(v526.x);
                                    v529.positions.y:set(v526.y);
                                end;
                            else
                                v529.dragging = false;
                            end;
                        end;
                        v529.block_mouse_input = v527.dragging or v535;
                        return;
                    end;
                end
            };
            _G.events.mouse_input(function()
                -- upvalues: v527 (ref)
                if ui.get_alpha() > 0 and v527.block_mouse_input then
                    return false;
                else
                    return;
                end;
            end);
            return setmetatable(v527, {
                __index = v537
            });
        end;
        return setmetatable(v521, {
            __metatable = false, 
            __call = v538
        });
    end)();
    local v539 = nil;
    local v540 = nil;
    local v541 = nil;
    local v542 = nil;
    local v543 = nil;
    v541 = function(v544, v545, v546)
        return v544 + (v545 - v544) * v546;
    end;
    v542 = function(v547, v548, v549, v550)
        return v549 * v547 / v550 + v548;
    end;
    v543 = function(v551, v552, v553, v554)
        v551 = v551 / v554 * 2;
        if v551 < 1 then
            return v553 * 0.5 * v551 * v551 * v551 + v552;
        else
            v551 = v551 - 2;
            return v553 * 0.5 * (v551 * v551 * v551 + 2) + v552;
        end;
    end;
    v540 = {};
    v539 = function(v555, v556, v557, v558, v559, v560)
        -- upvalues: v540 (ref), l_clamp_0 (ref), v542 (ref), l_globals_0 (ref)
        local v561 = v540[v555];
        if v561 == nil then
            v561 = v560 or v557;
            v540[v555] = v561;
        end;
        if v561 == v557 and not v556 then
            return v557;
        elseif v561 == v558 and v556 then
            return v558;
        else
            v561 = l_clamp_0(v542(1, v561, l_globals_0.frametime * (v556 and v559 or -v559) * 175, 1), v557, v558);
            v540[v555] = v561;
            return v561;
        end;
    end;
    files.create_folder("nl\\melancholia");
    local v562 = nil;
    local v563 = nil;
    local v564 = "nl\\melancholia\\the_greatest_font.ttf";
    local v565 = 9;
    local v566 = "aou";
    local v567, v568 = l_pcall_0(render.load_font, v564, v565, v566);
    do
        local l_v564_0, l_v565_0, l_v566_0, l_v568_0 = v564, v565, v566, v568;
        if not v567 then
            l_v568_0 = 2;
            network.get("https://northon.dev/neverlose/melancholia/small_pixel.ttf", {}, function(v573)
                -- upvalues: l_v564_0 (ref), l_v568_0 (ref), l_v565_0 (ref), l_v566_0 (ref)
                if v573 == nil or #v573 == 0 then
                    return;
                else
                    files.write(l_v564_0, v573, true);
                    l_v568_0 = render.load_font(l_v564_0, l_v565_0, l_v566_0);
                    return;
                end;
            end);
        end;
        v562 = l_v568_0;
        v563 = render.load_font("Verdana", l_vector_0(11, 11, 0), "do");
    end;
    v564 = nil;
    v564 = {};
    v565 = {
        [1] = "Global", 
        [2] = "Standing", 
        [3] = "Moving", 
        [4] = "Slowwalk", 
        [5] = "Crouching T", 
        [6] = "Crouching CT", 
        [7] = "Air", 
        [8] = "Crouch-Air", 
        [9] = "Using", 
        [10] = "Fake Lag", 
        [11] = "Fake Duck"
    };
    v566 = nil;
    v566 = {};
    v567 = nil;
    v566.Global = {};
    v568 = nil;
    v566.Standing = {
        ["Anti Skeet::1"] = {
            [1] = "T4zMDFYSzsPFV2YSfNq94Nk7zGinLlI2xQiSzl3ih2br5E1urEYAhlkdzlXH4GwnDNxxDEYS06zM6NISzsZYxQCxfFqrzIq7fFYm5NIMM4b95Ebi4yrrfGbiDTulU43FDFYiD2bx5Fbr5FLtXEzFrGbr5lyIxQCxfFqrzIq7fFYm5NIMM4b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFrGbr5lyIxQCxfFqrzIq7fFYm5NIMM4b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFrGbr5lyIxQCxfFqrzIq7fFYm5NIMM4b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFrGbr5lyIxQCxfFqrzIq7fFYm5NIMM4b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFrGbr5lyI4NqEzskm6lbiMjYM6sbt6QbJ52fAaGixfCq95EbrzFiiDoZK5lqKz6zHzlgBzsQF5EzFDEYBNQxxzGzx5FwizeZoDCqM6NISzsUu4swi5NYtfNi75pNFDNxxDEYSihZKfNi9zVlK5lqKz6xJ6swxhF3izQz7zFzSzsV0pjbB6lCiu6b95Ebi4JbrDEIT5NYKrFqFzvwif0cHrGbr5lyIrNC7zNlobNiShlkdzlPF5EzFDEYB0eZKfNi9zVlK5lqKz6xJ6swxhF3izQz7zFzSzsV0pjbB6lCiu6b95Ebi4JbrDEIT5NYKrFqFzvwif0cBzNYFzlgS6szisEw75FbrfNi75vZdXF8pbNYFzlgS6szir2umzswifGZu4KIAfNKpyE9izsPQrvumzswifQzHfswB5EEohFqKLYqghsLJ4GwnDNxxDEYS06fi5FIT5NYKMjiSzl3ih2br5E1urvuohswiDglJalIE5EiKsEqEzskdhsHcrNC7zNlrPFiBfNYmeIhmrGbr5lyIaNzmzlYSfNIAzNiAzjwWzF6JalIE5EiKsEqEzskdhsHcrNC7zNlFy2bxfNitrGbr5lyIaNzmzlYSfNIAzNiAzjwWzF6JalIE5EiKsEqEzskdhsHcrNC7zNlFy2bxfNitrGbr5lyIaNzmzlYSfNIAzNiAzjwWzF6JalIE5EiKsEqEzskdhsHcrNC7zNlFy2bxfNitrGbr5lyIaNzmzlYSfNIAzNiAzjwWzF6JalIE5EiKsEqEzskdhsHcrNC7zNlFy2bxfNitrGbr5lyIaNzmzlYSfNIAzNiAzjwWzF6o52ziDvkrzNsHrsurfNworJb7fEjtLlI2x6bThswi4yIBeIbxDFfifQzM6NISzsZYx6bBLsuiaJ3izvVpncuP6lfofQYm6lfof0jazNYdhsinfNit62UJrGbr5lyIrN3izvVIx6bBLsuiaJ3izvVpncuP6lfofQYm6lfof0cazNYdhsinfNit62UNrGbr5lyIrN3izvV0x6bBLsuiaJ3izvVpncuP6lfofQYm6lfof0cazNYdhsinfNit62UNrGbr5lyIrN3izvV0x6bBLsuiaJ3izvVpncuP6lfofQYm6lfof0cazNYdhsinfNit62UNrGbr5lyIrN3izvV0x6bBLsuiaJ3izvVpncuP6lfofQYm6lfof0cazNYdhsinfNit62UNrGbr5lyIrN3izvV04GwnDNxxDEYS06iSzl3ih2br5E1urNC7zNloVFIt62fxDFPBzNYFzlgS6szisEw75FbrfNi75vZdXF8pbNYFzlgS6szir2umzswifGZVaEz7DFwisEbizFYADEiEzzQ4bNqChF3ieIbxDQre6lbieIwo52bS4lbizFYADEiEzhPdLlI2sEC7zNiF6lYmT6b95EbirBbizFIC5GPBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3B4NIKfFIAhEYKpjxSs2uohswiDMNrDEYdzlwB6lqA06zM6NISzsZYT6bB6lCiu6b95EbirBbizFIC5GPBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0co5EzFDEYBsSJ04NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04YSDNYiz0NkrGbr5lyIrNC7zNlvbNYFhsYdfRbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0Qx7zFzSzsbnUVco5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrswMzlYK0hFKfNi9zVlK5lqKz6fJzlzxfl3B9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV04NqFzvwifI830Qx7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQiD2uizlVuT6bB6lCiu6b95EbirBbizFIC5GPBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0co5EzFDEYBsSJ04NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04YSDNYiz0NkrGbr5lyIrNC7zNlvbNYFhsYdfRbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0Qx7zFzSzsbnUVco5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrswMzlYKUaix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04x7zFzSzsbnUVco5EzFDEYBsSe0rFqFzvwif0ciD2uizlVm4Fbi5NIgs2br5ly0rsurfNwoxQx7zFzSzsbnUYFK5lqKz6zXfNIB6lZF5EzFDEYBl6x7zFzSzsbnUiFvzlgxhF3izUQdLlI2sEC7zNiF6lYmpjxxzGzx5FwizeZoDCqM6NISzsUu4swi5NYtfNi75pNFDNxxDEYSihZKfNi9zVlK5lqKz6xJ6swxhF3izQz7zFzSzsV0pjbB6lCiu6b95Ebi4JbrDEIT5NYKrFqFzvwif0cHrGbr5lyIrNC7zNlobNiShlkdzlPF5EzFDEYB0eZKfNi9zVlK5lqKz6xJ6swxhF3izQz7zFzSzsV0pjbB6lCiu6b95Ebi4JbrDEIT5NYKrFqFzvwif0cF5EzFDEYBNQb95EbirKwi5vbiD4qF52ktzYqKzlzi5vwrfFlP4Kb7flkdzPuyhsc4PNiKzPuX6NqBDjwghsLIrNkxDElrVsVpYNImzEYBrvuohswiDglIrGbgDNldXNYFfcu8eIkrzExBrskrzExBH49Kzl3xLYqB6lwaDMNKfNi9zVlK5NYFf0lIrGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6KfNi9zVlK5NYFf0cIrGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6KfNi9zVlK5NYFf0cIrGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6KfNi9zVlK5NYFf0cIrGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6KfNi9zVlK5NYFf0crDEYdzlwB6lqA06b95Ebi4JkxhE92hskK4GwnDNxxDEYS06iKzlzi5vwrfFlJaGixfCq95EbrzFiiDoFK5lqKz6fJzlzxfl3B9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQxxzGzx5FwizeZoDCqM6NISzsUu4swi5NYtfNi75pNFDNxxDEYSihFKfNi9zVlK5lqKz6fJzlzxfl3B9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV04NqFzvwifI830Qx7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQiD2uizlVuT6bB6lCiu6b95EbirBbizFIC5GPBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0co5EzFDEYBsSJ04NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04YSDNYiz0NkrGbr5lyIrNC7zNlvbNYFhsYdfRbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0Qx7zFzSzsbnUVco5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrswMzlYK0hFKfNi9zVlK5lqKz6fJzlzxfl3B9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV04NqFzvwifI830Qx7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQiD2uizlVuT6bB6lCiu6b95EbirBbizFIC5GPBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0co5EzFDEYBsSJ04NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04YSDNYizHQF5EzFDEYB0Qx7zFzSzsbnUVco5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrswMzlYKU4fi5FIT5NYKM4YM6sbt6ePo5EzFDEYBsSIzrNC7zNlFy2bxfNitrFqFzvwifIFo5EzFDEYBsSkz4Fbi5NIgs2br5ly0WNw75FbrfNi75t1=_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive", 
                [2] = "Defensive"
            }
        }
    };
    local v574 = nil;
    v566.Moving = {
        ["Anti Skeet::1"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Mix::3"] = {
            [1] = "T4xT5Ebgs2ixf1PvzlgxhF3izUZFDNxxDEYSihPK5lqKz6iQ6sbBzsepYtQKfNi9zVl9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFzoPK5lqKz6zXfNIB6lZKfNi9zVl9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFzoPK5lqKz6zXfNIB6lZKfNi9zVl9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFzoPK5lqKz6zXfNIB6lZKfNi9zVl9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFzoPK5lqKz6zXfNIB6lZKfNi9zVl9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4xSs2uohswiDMNrDEYdzlwB6lqA06iKzlzi5vwrfFlJrEYAhlkdzlXc4Fbi5NIgs2br5ly0aGixfCq95EbrzFiiDoFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cohlbEhlgtzlPHrvuohswiDglk9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV0rGbr5lyI4NqFzvwifI830QYSDNYizHQo5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrNC7zNlvbNYFhsYdfeFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cKfNi9zVlo5EzFDEYBsSJ0rswMzlYKU4x7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQK5lqKz6fJzlzxfl3BT5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QbB6lCiu6x7zFzSzsbnUVciD2uizlVm4NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04b95EbirBbizFIC5GPk9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV0rGbr5lyI4NqFzvwifI830QYSDNYizHQo5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrNC7zNlvbNYFhsYdfeFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cKfNi9zVlo5EzFDEYBsSJ0rswMzlYKU4x7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQK5lqKz6fJzlzxfl3B4GwnDNxxDEYS06iSzl3ih2br5E1u4NqFzvwifI83BQ6iD2uizlVm4NqFzvwifI8mlaix5vbrsEkmfsbizFqmhEYnDFIAzNq96sriH4b95EbiaBIAfNKpVvkCfNYF52ktz6YM6sbt6ePK5lqKz6iN5GYtfGYxfNlo5EzFDEYBsSeH4NqFzvwifI83jQz7zFzSzsV0r2umzswifGZcrBIAfNKpXKmQ4Nk7zGinLlI2xQfi5FIT5NYKMjzM6NISzsZYxQb95EbiriwBhsbrhjbB6lCiu6CxfFqrzIq7fFYm5NIMMj3FDFYiD2bx5Fbr5FLtXEzFxQb95EbiriwBhsbrhjbB6lCiu6CxfFqrzIq7fFYm5NIMM43FDFYiD2bx5Fbr5FLtXEzFxQb95EbiriwBhsbrhjbB6lCiu6CxfFqrzIq7fFYm5NIMM43FDFYiD2bx5Fbr5FLtXEzFxQb95EbiriwBhsbrhjbB6lCiu6CxfFqrzIq7fFYm5NIMM43FDFYiD2bx5Fbr5FLtXEzFxQb95EbiriwBhsbrhjbB6lCiu6CxfFqrzIq7fFYm5NIMM43FDFYiD2bx5Fbr5FLtXEzF4GwnDNxxDEYS06iSzl3ih2br5E1u4lbizFYADEiEzhPvzlgxhF3izUZ4zNYdhsinfNi9zVcdLlI2sEC7zNiF6lYmT5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QxxzGzx5FwizeZFDNxxDEYSihFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cKfNi9zVlo5EzFDEYBsSJ0rNC7zNlvbNYFhsYdfQYSDNYizHQghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQo5EzFDEYBsSe0T5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QbB6lCiu6x7zFzSzsbnUVcK5lqKz6fJzlzxfl3BrswMzlYKUaix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04x7zFzSzsbnUpck9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV0rGbr5lyI4NqFzvwifI830Qb95EbirBbizFIC5GPiD2uizlVmAlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFyc4NqFzvwifI8m0eFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cKfNi9zVlo5EzFDEYBsSJ0rNC7zNlvbNYFhsYdfQYSDNYizHQghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQo5EzFDEYBsSe0T5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QbB6lCiu6x7zFzSzsbnUVcK5lqKz6fJzlzxfl3BrswMzlYKUaix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04x7zFzSzsbnUpcoDCqM6NISzsUu4swi5NYtfNi75pNo5EzFDEYBsSJ0rNC7zNl7VlgB6PucDvYBzlz7DFwirswMzlYKUaix5vbrsEkmfsbizFqmhEYnDFIAzNq96sric4x7zFzSzsbnUpciDNiBhETJrFqFzvwif0co5EzFDEYBsSkz4NqFzvwifI83l6b95EbiriwBhsbrhjqF52ktzYqKzlzi5vwrfFlP4Kb7flkdzPuyhsc4PNiKzPuX6NqBDjx7fFYmDFiKzDZtLlI2x6bThswi4yIBeIbxDFfifQb95Ebi4JkxhE92hskKrvuohswiDglIrGbr5lyIrN3izvVRrGbgDNldXNYFfcu8eIkrzExBrskrzExBcj9Kzl3xLYqB6lwaD3cIrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6IrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6IrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6IrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0Q9Kzl3xLYqB6lwaDM6oDCqM6NISzsUu4swi5NYtfNi75pNBzNYFzlgS6szisEw75FbrfNi75vZdXF8pbNYFzlgS6szir2umzswifGZVrvumzswifQzHfswB5EEdLlI2sEC7zNiF6lYmpjz7zFzSzsVd4NIKfFIAhEYKpjzM6NISzsZYpjz7zFzSzsV0rGbr5lyIrNC7zNlobNiShlkdzlPHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izeZF5EzFDEYB0QbB6lCiu6b95Ebi4JbrDEIT5NYKpjz7zFzSzsV0rGbr5lyIrNC7zNlobNiShlkdzlPHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izQxSs2uohswiDMNrDEYdzlwB6lqA06b95Ebi4JbrDEIT5NYKrsurfNworJb7fEj4VlgB6PuX6EYifeFohFqKLYqghsLJrEYAhlkdzlXHrvuohswiDglJrNC7zNlrPFiBfNYmeIhmrGbr5lyIalIE5EiKsEqEzskdhsHcaNzmzlYSfNIAzNiAzjwWzF6JrNC7zNlFy2bxfNitrGbr5lyIalIE5EiKsEqEzskdhsHcaNzmzlYSfNIAzNiAzjwWzF6JrNC7zNlFy2bxfNitrGbr5lyIalIE5EiKsEqEzskdhsHcaNzmzlYSfNIAzNiAzjwWzF6JrNC7zNlFy2bxfNitrGbr5lyIalIE5EiKsEqEzskdhsHcaNzmzlYSfNIAzNiAzjwWzF6JrNC7zNlFy2bxfNitrGbr5lyIalIE5EiKsEqEzskdhsHcaNzmzlYSfNIAzNiAzjwWzF6oDCqM6NISzsUu4swi5NYtfNi75pNrzNYFzlgS6szixQfi5FIT5NYKM4rKzl3xLYqB6lCi0Q3ghsfn5lqK6lzrzsQk9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV04NIKfFIAhEYKpjzM6NISzsZYT5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QbB6lCiu6x7zFzSzsbnUVcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQo5EzFDEYBsSe0rNC7zNlvbNYFhsYdfQYSDNYiz0Nk9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV0rGbr5lyI4NqFzvwifI830Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04x7zFzSzsbnUpcK5lqKz6fJzlzxfl3BrswMzlYK0hFBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BrFqFzvwif0cKfNi9zVlo5EzFDEYBsSJ0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFyc4NqFzvwifI8m0Qb95EbirBbizFIC5GPiD2uizlVuT5bx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPF5EzFDEYB0QbB6lCiu6x7zFzSzsbnUVcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQo5EzFDEYBsSe0rNC7zNlvbNYFhsYdfQYSDNYiz0Nk9NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQz7zFzSzsV0rGbr5lyI4NqFzvwifI830Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04x7zFzSzsbnUpcK5lqKz6fJzlzxfl3BrswMzlYKU4xSs2uohswiDMNrDEYdzlwB6lqA06x7zFzSzsbnUVcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQo5EzFDEYBsSe0rNC7zNlvbNYFhsYdfQYSDNYizHQiDNiBhETJrFqFzvwifIFo5EzFDEYBsSkz4NqFzvwifI83l6b95EbiriwBhsbrhjfMDFYSzsbSKQx7fFYmDFiKzDZtLlI2x6bThswi4yIBeIbxDFfifQb95Ebi4JkxhE92hskKrvuohswiDglI4Ebi5NIgs2brhE9S06bdzlzBjjbBLsuiaJ3izvVpncuP6lfofQYm6lfofcNKfNi9zVlI4Ebi5NIgs2brhE9Su4bdzlzB0QbBLsuiaJ3izvVpncuP6lfofQYm6lfof0cKfNi9zVlI4Ebi5NIgs2brhE9Su4bdzlzB0QbBLsuiaJ3izvVpncuP6lfofQYm6lfof0cKfNi9zVlI4Ebi5NIgs2brhE9Su4bdzlzB0QbBLsuiaJ3izvVpncuP6lfofQYm6lfof0cKfNi9zVlI4Ebi5NIgs2brhE9Su4bdzlzB0QbBLsuiaJ3izvVpncuP6lfofQYm6lfof0cKfNi9zVloDCqM6NISzsUu4swi5NYtfNi75pN7zFqmhEYnzNYFzlgS6sziK4rJ52YT5NypYNIM4KxrzNypyEx7fGZFDGkiDEYBrKwCD2b7563ghsfn5lqK6lzrzsQHrFqFzvwif0mohlbEhlgtzlPHrvuohswiDglHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izeZF5EzFDEYB0QbB6lCiu6b95Ebi4JbrDEIT5NYKpjz7zFzSzsV0rGbr5lyIrNC7zNlobNiShlkdzlPHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izeZF5EzFDEYB0QbB6lCiu6b95Ebi4JbrDEIT5NYK4GwnDNxxDEYS06iSzl3ih2br5E1urNC7zNlFVEYAfNYmrsurfNworJb7fEjo52ziDvkrzNsHo2ixf1lKhFISz6iufcuyhskvzsPK5lqKz6xchlwafEImzQzM6NISzsZYx6bB6lCiuQbdzlzBBwEKfGiMz63UzlzBeGMpyFiv6GPiDFiv6GVo4Ebi5NIgs2brhE9S01lKfNi9zVlK5NYFfwHfrGbgDNldXNYFfcu8eIkrzExBrskrzExBQQ9Kzl3xLYqB6lwaDMNIrGbr5lyIrN3izvXV26bBLsuiaJ3izvVpncuP6lfofQYm6lfofcTazNYdhsinfNit62Ucx6bB6lCi0jbdzlzBBwEKfGiMz63UzlzBeGMpyFiv6GPiDFiv6GVo4Ebi5NIgs2brhE9S0hlKfNi9zVlK5NYFf0cKfGiMz63UzlzBeGMpyFiv6GPiDFiv6GV04Ebi5NIgs2brhE9Su4xSs2uohswiDMPrDEYdzlwB6lqAuRbKzlzi5vwrfFYnhEqAzNiB6lqADj3Z5muJzlzi5vwrfFl7zFqmhEYnzNYFzlgS6sziKQzMDFYSzsPFV2YSfNq9aGixfCq95EbrzFiiDoZK5lqKz6xJ6swxhF3izQxxzGzx5FwizeZFDNxxDEYSihZK5lqKz6xJ6swxhF3izQbB6lCiu6z7zFzSzsV0pjb95Ebi4JbrDEIT5NYKrGbr5lyIrFqFzvwif0cHrNC7zNlobNiShlkdzlPKfNi9zVlF5EzFDEYB0eZK5lqKz6xJ6swxhF3izQbB6lCiu6z7zFzSzsV0pjb95Ebi4JbrDEIT5NYKrGbr5lyIrFqFzvwif0coDCqM6NISzsUu4swi5NYtfNi75pNF5EzFDEYBujYM6sbt6QbJ52fAWNw75FbrfNi75t1=_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }
    };
    local v575 = nil;
    v566.Slowwalk = {
        ["Anti Skeet::1"] = {
            [1] = "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z6xuzGzx5FwizQz7zFzSzsXUr4x7zFzSzsbnUpciDNiBhETJ4NqFzvwifI83BUTK5lqKz6zXfNIB6lZF5EzFDEYBBUNo5EzFDEYBsSRVE4fi5FIT5NYKMjrKzl3xLYqB6lCi0QYM6sbt6QbJ52fA9NbizFYADEiEzYqt5EgK6sbr5EgSaJg7eJbizFYADEiEz6zMDFYSzsPFV2YSfNq94Nk7zGinLlI2xQxSs2uohswiDMNFDNxxDEYSihP9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4b95Ebi4yrrfGbiDTulU4bB6lCiceP9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvrKxghvkrzQb95EbirKrrfGbiD4bB6lCiuhP9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4b95EbiriwBhsbrhjbB6lCiuhP9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4b95EbiriwBhsbrhjbB6lCiuhP9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4b95EbiriwBhsbrhjbB6lCiu6iSzl3ih2br5E1urEYAhlkdzlXHaEz7DFwisEbizFYADEiEzzQ4bNqChF3ieIbxDQre6lbieIwo52bSr2umzswifGZcrBIAfNKpXKmQo2ixf1lFDNxxDEYSihlazNYdhsinfNit62UQrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExBNhlazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0QxSs2uohswiDMNKhFISz6iufcuyhskvzsPrDEYdzlwB6lqA06b95Ebi4JkxhE92hskK9NbizFYADEiEzYqt5EgK6sbr5EgSaJg7eJbizFYADEiEz63ghsfn5lqK6lzrzsQH4NIKfFIAhEYK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_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }
    };
    local v576 = nil;
    v566["Crouching T"] = {
        ["Anti Skeet::1"] = {
            [1] = "T4qF52ktzYqKzlzi5vwrfFlP4Kb7flkdzPuyhsc4PNiKzPuX6NqBDjiKzlzi5vwrfFlJ4Fbi5NIgs2br5ly0rsurfNwoxQz7zFzSzsbzrNC7zNlFy2bxfNit4NqFzvwifI8ml6x7zFzSzsbnUYFdLlI2sEC7zNiF6lYmT6YSDNYizHQF5EzFDEYB0Rbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU6x7zFzSzsbnUVcohlbEhlgtzlPH4GwnDNxxDEYS06iSzl3ih2br5E1urvuohswiDglkrGbr5lyIrswMzlYK06z7zFzSzsV09NIAfNinhvkCfNYF52ktzYq95Ebiovh34NqFzvwifI830Rix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPo5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrNC7zNlvbNYFhsYdfeFKfNi9zVliD2uizlVurFqFzvwif0cBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNo5EzFDEYBsSJ0AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQx7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQK5lqKz6fJzlzxfl3BT6bB6lCiu6YSDNYiz0NF5EzFDEYB0Rbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU6x7zFzSzsbnUVcghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3B4NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04b95EbirBbizFIC5GPkrGbr5lyIrswMzlYK06z7zFzSzsV09NIAfNinhvkCfNYF52ktzYq95Ebiovh34NqFzvwifI830Rix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPo5EzFDEYBsSe0AlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFycrNC7zNlvbNYFhsYdfeFKfNi9zVliD2uizlVmrFqFzvwif0cBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNo5EzFDEYBsSJ0AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQx7zFzSzsbnUpcghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzVQK5lqKz6fJzlzxfl3B4NqFzvwifI8m0Rix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri0aix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPK5lqKz6fJzlzxfl3BrEYAhlkdzlXc4NqEzskm6lbiMjfMDFYSzsbSKQYM6sbt6QbJ52fAo2ixf1loDCqM6NISzsUurNkxDElrVsVpYNImzEYBrNC7zNloVFIt62fxDFPrDEYdzlwB6lqA06zM6NISzsZYx6bBLsuiaJ3izvVpncuP6lfofQbdzlzB86Ym6lfofuLKfNi9zVlazNYdhsinfNit62Uux6bBLsuiaJ3izvVpncuP6lfofQbdzlzB0QYm6lfof0cKfNi9zVlazNYdhsinfNit62UNx6bBLsuiaJ3izvVpncuP6lfofQbdzlzB0QYm6lfof0cKfNi9zVlazNYdhsinfNit62UNx6bBLsuiaJ3izvVpncuP6lfofQbdzlzB0QYm6lfof0cKfNi9zVlazNYdhsinfNit62UNx6bBLsuiaJ3izvVpncuP6lfofQbdzlzB0QYm6lfof0cKfNi9zVlazNYdhsinfNit62UNrvumzswifQzHfswB5EEohFqKLYqghsLJ4GwnDNxxDEYS06zM6NISzsZYxQCxfFqrzIq7fFYm5NIMM4bB6lCiu6b95Ebi4yrrfGbiDTulU43FDFYiD2bx5Fbr5FLtXEzFxQCxfFqrzIq7fFYm5NIMM4bB6lCiu6b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFxQCxfFqrzIq7fFYm5NIMM4bB6lCiu6b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFxQCxfFqrzIq7fFYm5NIMM4bB6lCiu6b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzFxQCxfFqrzIq7fFYm5NIMM4bB6lCiu6b95EbiriwBhsbrhj3FDFYiD2bx5Fbr5FLtXEzF4swi5NYtfNi75pNvzlgxhF3izUZdLlI2sEC7zNiF6lYmpjz7zFzSzsVb4NIKfFIAhEYKpjxSs2uohswiDMNrDEYdzlwB6lqA06zM6NISzsZYpjz7zFzSzsV0rGbr5lyIrNC7zNlobNiShlkdzlPHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izeZF5EzFDEYB0QbB6lCiu6b95Ebi4JbrDEIT5NYKpjz7zFzSzsV0rGbr5lyIrNC7zNlobNiShlkdzlPHrFqFzvwif0cKfNi9zVlK5lqKz6xJ6swxhF3izQb95EbirKwi5vbiDabKzlzi5vwrfFYnhEqAzNiB6lqADj3Z5muJzlzi5vwrfFy8hEqAzNiB6lqAWp==_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive", 
                [2] = "Defensive"
            }
        }
    };
    local v577 = nil;
    v566["Crouching CT"] = {
        ["Anti Skeet::1"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive", 
                [2] = "Defensive"
            }
        }
    };
    local v578 = nil;
    v566.Air = {
        ["Anti Skeet::1"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "No Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }
    };
    local v579 = nil;
    v566["Crouch-Air"] = {
        ["Anti Skeet::1"] = {
            [1] = "T4fMDFYSzsbSKQx7fFYmDFiKzDZrzNYFzlgS6szixQfi5FIT5NYKMj3ghsfn5lqK6lzrzsQk4NqFzvwifI8m0Qb95Ebi4JIKfFIAhEYKAlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFyH4NIKfFIAhEYKpjzM6NISzsZYT6x7zFzSzsbnUpcK5lqKz6qu5vbreJkmfsbizFqmhElghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzV4iD2uizlbKrGbr5lyHrFqFzvwifUBu6Qx7zFzSzsbnUVcBhlgB6YqTDvYBzlz7DFwisEC7zNlTftNghlgB6YqTDvYBzlz7DFwis2wrzNYn5lqKz6fJzlzxfl3BT6x7zFzSzsbnUpcK5lqKz6bXDNiAAlIAfNinhvkCfNYF52ktzYqmhlgK5ECrLFyQrswMzlYKzQbB6lCi0jz7zFzSzsXw0lTo5EzFDEYBsSJ09NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfeFo5EzFDEYBsSRVd4b95EbiaBIAfNKpVvkCfNYF52ktz5ix5vbrsEkmfsbizFqmhEYnDFIAzNq96sri04YSDNYizHQKfNi9zVPF5EzFDEYB0Qx7zFzSzsbnUfcm9NIAfNinhvkCfNYF52ktzYq95EbiovhmAlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfeFo5EzFDEYBsSe0rNC7zNlKy2ur5aix5vbrsEkmfsbizFqmhEYnDFIAzNq96sric4YSDNYizIcKfNi9zVZF5EzFDEYBBnjh4NqFzvwifI830Rbx5vbrsEkmfsbizFqmhEYn5lqKz6kEU5ix5vbrsEkmfsbizFqmhEYnDEiKzYq95EbirBbizFIC5GPk4NqFzvwifI8mSkAK5lqKz6qu5vbreJkmfsbizFqmhElghlgB6YqTDvYBzlz7DFwis2kx5Fb75lijzV4iD2uizlVmrGbr5lyIrFqFzvwif0co5EzFDEYBsSI39NIAfNinhvkCfNYF52ktzYq95EbiovhmAlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQxSs2uohswiDMZrDEYdzlwB6lqA0jYSDNYizuLF5EzFDEYBSQ6o5EzFDEYBsSJ09NIAfNinhvkCfNYF52ktzYq95Ebiovh3AlIAfNinhvkCfNYF52ktzYqS6lbisEC7zNlvbNYFhsYdfQrKzl3xLYqB6lCi0QYM6sbt6ePo5EzFDEYBsSRVE4x7zFzSzsbnUfHerNC7zNlFy2bxfNitrFqFzvwif0c7zFqmhEYnzNYFzlgS6sziK4rJ52YT5NypYNIM4KxrzNypyEx7fGZdLlI2sEC7zNiF6lYmpjb95Ebi4JbrDEIT5NYK4NIKfFIAhEYKpjzM6NISzsZYpjbB6lCiuQb95EbirKwi5vbiD4z7zFzSzsVPpjbB6lCi0jb95EbirKwi5vbiD4z7zFzSzsVYpjbB6lCiuQb95EbirKwi5vbiD4z7zFzSzsVVpjbB6lCiuQb95EbirKwi5vbiD4z7zFzSzsVlpjbB6lCi04b95EbirKwi5vbiD4z7zFzSzsVK4GwnDNxxDEYSu6iSzl3ih2br5E1crFqFzvwifu6tLlI2x6zM6NISzsZYx6Ym6lfof0+KfGiMz63UzlzBeGMpyFiv6GPazNYdhsinfNit62UurN3izvVIrGbr5lyex6Ym6lfofuTKfGiMz63UzlzBeGMpyFiv6GPazNYdhsinfNit62UerN3izvVHrGbr5lyex6Ym6lfofuFKfGiMz63UzlzBeGMpyFiv6GPazNYdhsinfNit62UurN3izvVJrGbr5lyJx6Ym6lfofucKfGiMz63UzlzBeGMpyFiv6GPazNYdhsinfNit62UJrN3izvVJrGbr5lyNx6Ym6lfof0cKfGiMz63UzlzBeGMpyFiv6GPazNYdhsinfNit62UNrN3izvV0rGbr5lyIrNkxDElrVsVpYNImzEYB4GwnDNxxDEYSuQb95Ebi4JkxhE92hskK4swi5NYtfNi75pNBzNYFzlgS6szisEw75FbrfNi75vZdXF8pbNYFzlgS6szirvumzswifQzHfswB5EEohFqKLYqghsLJrEYAhlkdzlXHrvuohswiDglJaNzmzlYSfNIAzNiAzjwWzF69hsz76lbn52ziDF3xDUQK5lqKz6iQ6sbBzsepYtQKfNi9zVTJaNzmzlYSfNIAzNiAzjzeLlkm6lP9hsz76lbn52ziDF3xDUQK5lqKz6zQ6sbBzsQKfNi9zVlJaNzmzlYSfNIAzNiAzjwWzF69hsz76lbn52ziDF3xDUQK5lqKz6zXfNIB6lZKfNi9zVlJaNzmzlYSfNIAzNiAzjwWzF69hsz76lbn52ziDF3xDUQK5lqKz6zXfNIB6lZKfNi9zVlJaNzmzlYSfNIAzNiAzjwWzF69hsz76lbn52ziDF3xDUQK5lqKz6zXfNIB6lZKfNi9zVloDCqM6NISzsUu4swi5NYtfNi75pNiDNiBhETKbNq25t3t5EgK6sbr5E1+_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }, 
        ["Anti NL::2"] = {
            [1] = "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_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }, 
        ["Mix::3"] = {
            [1] = "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zFzSzsV0rNC7zNlFy2bxfNit4Fbi5NIgs2br5ly0rEYAhlkdzlXHrsurfNworJb7fEjBzNYFzlgS6szisEw75FbrfNi75vZdXF8pbNYFzlgS6szirvumzswifQzHfswB5EEdLlI2sEC7zNiF6lYmpjxxzGzx5FwizeZFDNxxDEYSihZKfNi9zVlF5EzFDEYB0Qb95Ebi4JbrDEIT5NYKpjbB6lCiu6z7zFzSzsV0rNC7zNlobNiShlkdzlPHrGbr5lyIrFqFzvwif0cK5lqKz6xJ6swxhF3izeZKfNi9zVlF5EzFDEYB0Qb95Ebi4JbrDEIT5NYKpjbB6lCiu6z7zFzSzsV0rNC7zNlobNiShlkdzlPoDCqM6NISzsUu4swi5NYtfNi75pNF5EzFDEYBRQb95Ebi4JbrDEIT5NYKaEz7DFwisEbizFYADEiEzzQ4bNqChF3ieIbxDQre6lbieIwo52bS4Nk7zGinLlI2xQxSs2uohswiDMNFDNxxDEYSihP9hsz76lbn52ziDF3xDUZdzvkizswBhlgK6lgvoBqFz4bB6lCiu6b95EbiriwBhsbrh1P9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4bB6lCiu6b95EbiriwBhsbrh1P9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4bB6lCiu6b95EbiriwBhsbrh1P9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4bB6lCiu6b95EbiriwBhsbrh1P9hsz76lbn52ziDF3xDUQdzvkizswBhlgK6lgvoBqFz4bB6lCiu6b95EbiriwBhsbrhjiSzl3ih2br5E1urEYAhlkdzlXH4KIAfNKpyE9izsPko2ixf1lFDNxxDEYSihlazNYdhsinfNit62UurGbr5lyIrN3izvXarGbgDNldXNYFfcu8eIkrzExBrskrzExBehlazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit62UNrGbr5lyIrN3izvV0rGbgDNldXNYFfcu8eIkrzExBrskrzExB0elazNYdhsinfNit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_outlaw", 
            [2] = {
                [1] = "Defensive"
            }
        }
    };
    local v580 = nil;
    v566.Using = {};
    local v581 = nil;
    v566["Fake Lag"] = {};
    local v582 = nil;
    v566["Fake Duck"] = {};
    local v583 = nil;
    local v584 = nil;
    local v585 = {};
    v584 = {};
    v583 = v585;
    for _, v587 in l_ipairs_0(v565) do
        local v588 = {};
        local v589 = {};
        local l_v588_0 = v588;
        v584[v587] = v589;
        v583[v587] = l_v588_0;
        for v591, v592 in l_next_0, v566[v587] do
            local v593 = v591:match("::%d");
            if v593 ~= nil then
                preset = v592[1];
                defensive_modes = v592[2];
                local v594 = l_gsub_0(v591, v593, "");
                v588[l_tonumber_0(l_sub_0(v593, 3))] = v594;
                preset = l_gsub_0(preset, "_outlaw", "");
                local v595, v596 = l_pcall_0(v194.decode, preset, v196);
                if v595 and l_find_0(v596, "<condition>") ~= nil then
                    v596 = l_gsub_0(v596, "<condition>", "");
                    local v597, v598 = l_pcall_0(msgpack.unpack, v596);
                    if v597 then
                        v589[v594] = v598;
                    end;
                end;
            end;
        end;
    end;
    v585 = v583;
    v566.presets = v584;
    v566.menu = v585;
    v564.advanced = v566;
    v565 = nil;
    v565 = {};
    v566 = nil;
    v567 = nil;
    v567 = {
        switch = true, 
        slider = true, 
        combo = true, 
        selectable = true, 
        color_picker = true, 
        hotkey = true, 
        textbox = true, 
        list = true, 
        listable = true
    };
    v568 = nil;
    v568 = function(v599)
        -- upvalues: l_next_0 (ref), l_to_hex_0 (ref), l_type_0 (ref)
        local v600 = {
            color_picker = true
        };
        local v601 = v599:get();
        local v602 = v599:list();
        for _, v604 in l_next_0, v602 do
            local v605 = v599:get(v604);
            for v606, v607 in l_next_0, v605 do
                local v608 = v600[v604];
                if v608 == nil then
                    v608 = {};
                    v600[v604] = v608;
                end;
                v608[v606] = l_to_hex_0(v607);
            end;
        end;
        if l_type_0(v601) == "string" then
            v600.mode = v601;
        end;
        return v600;
    end;
    do
        local l_v567_0, l_v568_1 = v567, v568;
        v566 = function(v611)
            -- upvalues: l_next_0 (ref), l_v567_0 (ref), l_v568_1 (ref)
            local v612 = {};
            for v613, v614 in l_next_0, v611 do
                local v615 = v614:type();
                if l_v567_0[v615] ~= nil then
                    v612[v613] = v615 == "color_picker" and l_v568_1(v614) or v614:get();
                end;
            end;
            return v612;
        end;
    end;
    v567 = nil;
    v568 = nil;
    v568 = function(v616, v617)
        -- upvalues: l_pcall_0 (ref), l_next_0 (ref), l_color_0 (ref)
        if v617.mode then
            l_pcall_0(v616.set, v616, v617.mode);
            v617.mode = nil;
        end;
        v617.color_picker = nil;
        for v618, v619 in l_next_0, v617 do
            for v620, v621 in l_next_0, v619 do
                v619[v620] = l_color_0(v621);
            end;
            l_pcall_0(v616.set, v616, v618, v619);
        end;
    end;
    do
        local l_v568_2 = v568;
        v567 = function(v623, v624)
            -- upvalues: l_next_0 (ref), l_type_0 (ref), l_pcall_0 (ref), l_v568_2 (ref), v2 (ref), l_format_0 (ref)
            for v625, v626 in l_next_0, v624 do
                local v627 = v623[v625];
                if v627 ~= nil then
                    if l_type_0(v626) == "table" and v626.color_picker then
                        l_pcall_0(l_v568_2, v627, v626);
                    else
                        l_pcall_0(v627.set, v627, v626);
                    end;
                elseif v2 then
                    print_raw(l_format_0("reference %s is nil", v625));
                end;
            end;
        end;
    end;
    v568 = function(v628, v629, v630)
        -- upvalues: l_assert_0 (ref), l_type_0 (ref)
        l_assert_0(l_type_0(v629) == "string", "invalid name");
        l_assert_0(l_type_0(v630) == "userdata", "invalid reference");
        l_assert_0(v628[v629] == nil, v629 .. " already exists");
        v628[v629] = v630;
    end;
    v574 = {};
    v575 = {};
    do
        local l_v566_1, l_v567_1, l_v568_3, l_v574_0, l_v575_0 = v566, v567, v568, v574, v575;
        v565.global = function(...)
            -- upvalues: l_v566_1 (ref), l_v574_0 (ref), l_type_0 (ref), l_v567_1 (ref), l_v568_3 (ref)
            if #{
                ...
            } == 0 then
                return l_v566_1(l_v574_0);
            elseif l_type_0(...) == "table" then
                return l_v567_1(l_v574_0, ...);
            else
                local v636, v637 = ...;
                l_v568_3(l_v574_0, v636, v637);
                return v637;
            end;
        end;
        v565.antiaim = function(...)
            -- upvalues: l_v566_1 (ref), l_v575_0 (ref), l_type_0 (ref), l_v567_1 (ref), l_v568_3 (ref), l_v574_0 (ref)
            if #{
                ...
            } == 0 then
                return l_v566_1(l_v575_0);
            elseif l_type_0(...) == "table" then
                return l_v567_1(l_v575_0, ...);
            else
                local v638, v639 = ...;
                l_v568_3(l_v574_0, v638, v639);
                l_v568_3(l_v575_0, v638, v639);
                return v639;
            end;
        end;
    end;
    v566 = nil;
    v566 = {};
    v567 = nil;
    v567 = function(v640)
        return function()
            -- upvalues: v640 (ref)
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(v640);
        end;
    end;
    v568 = nil;
    v574 = ui.create("\239\128\149", "\238\134\167  welcome", 1);
    v568 = {
        main = v574:label("\238\134\167  \aDEFAULT Welcome, \a{Link Active}" .. v1 .. "\aDEFAULT!"), 
        online = v574:label("Online Users")
    };
    v568.online:visibility(false);
    v568.date = v574:label(" \239\129\179   \a{Link Active}" .. l_get_date_0("%A") .. "\aDEFAULT, " .. l_get_date_0("%B %d"));
    v566.welcome = v568;
    v574 = ui.create("\239\128\149", "\239\131\129  links", 1);
    v575 = v574:button(" \239\128\147 ", nil, true);
    v575:tooltip("Author's Cheat Config");
    v575:set_callback(v567("https://en.neverlose.cc/market/item?id=r3bYnf"));
    v576 = v574:button("\aFF2020FF \239\133\167 ", nil, true);
    v576:tooltip("Author's YouTube Channel");
    v576:set_callback(v567("https://www.youtube.com/@quecy"));
    v577 = v574:button(" \239\139\134 ", nil, true);
    v577:tooltip("Join The Telegram Channel");
    v577:set_callback(v567("https://t.me/OGquecy"));
    v578 = v574:button("\a5865F2FF \239\142\146 ", nil, true);
    v578:tooltip("Join The Discord Channel");
    v578:set_callback(v567("https://discord.gg/GM97CnmtzV"));
    v579 = v574:button(" \239\131\129 ", nil, true);
    v579:tooltip("Get Discord Verification Code");
    v580 = nil;
    v580 = function(v641, v642)
        -- upvalues: l_band_0 (ref), l_bxor_0 (ref), l_rshift_0 (ref), l_byte_0 (ref), l_bnot_0 (ref)
        if not v642 then
            v642 = {};
        end;
        local v643 = nil;
        local v644 = nil;
        local v645 = nil;
        if v642[1] == nil then
            for v646 = 1, 256 do
                v644 = v646 - 1;
                for _ = 1, 8 do
                    v645 = -l_band_0(v644, 1);
                    v644 = l_bxor_0(l_rshift_0(v644, 1), l_band_0(3988292384, v645));
                end;
                v642[v646] = v644;
            end;
        end;
        v644 = 4294967295;
        for v648 = 1, #v641 do
            v643 = l_byte_0(v641, v648);
            v644 = l_bxor_0(l_rshift_0(v644, 8), v642[l_band_0(l_bxor_0(v644, v643), 255) + 1]);
        end;
        return l_band_0(l_bnot_0(v644), 4294967295);
    end;
    do
        local l_v580_0 = v580;
        v579:set_callback(function()
            -- upvalues: v0 (ref), l_tostring_0 (ref), l_floor_0 (ref), l_abs_0 (ref), l_v580_0 (ref), v1 (ref), l_get_timestamp_0 (ref), l_format_0 (ref), v194 (ref), v195 (ref), l_len_0 (ref), v128 (ref)
            local v650 = v0 == 3 and "melancholia-elite" or "melancholia";
            local v651 = l_tostring_0(l_floor_0(l_abs_0(l_v580_0(v1) + l_get_timestamp_0())));
            local v652 = l_format_0("%s:%s:%s", v1, v650, v651);
            v652 = v194.encode(v652, v195);
            network.get("https://northon.dev/neverlose/discord/get_verification_code.php?data=" .. v652, {}, function(v653)
                -- upvalues: l_len_0 (ref), v128 (ref), l_format_0 (ref), v650 (ref)
                if v653 == nil or l_len_0(v653) == 0 then
                    return;
                else
                    v128(v653);
                    print_raw(l_format_0("\aB4E61EFF[%s] \aFFFFFFFFYour verification code: \aB0C5FFFF%s\aFFFFFFFF (Copied to clipboard)", v650, v653));
                    return;
                end;
            end);
        end);
        v581 = v574:button(" \226\156\168 ", nil, true);
        v581:tooltip("Melancholia Neverlose Theme");
        v581:set_callback(v567("https://neverlose.cc/getitem?c=JsSgHYQrvABjzFyU-FCCoUz-iZW"));
        v582 = v574:button("  \239\132\166  ", nil, true);
        v582:tooltip("Link to Elite Version");
        v582:set_callback(v567("https://neverlose.cc/market/item?id=2nWGaE"));
    end;
    v574 = ui.create("\239\128\149", "\239\128\147  configurations", 1);
    v575 = function(v654, v655)
        -- upvalues: l_format_0 (ref)
        local v656 = v654 and "\aA0CB27FF" or "\aFF7575FF";
        local v657 = v654 and "[+] " or "[-] ";
        local v658 = l_format_0("%s%s%s", v656, v657, v655);
        local v659 = l_format_0("%s[outlaw]\aDEFAULT %s", v656, v655);
        print_dev(v658);
        print_raw(v659);
    end;
    v574:button(" \a{Link Active}\239\149\174\aDEFAULT Export Config ", function()
        -- upvalues: v565 (ref), v194 (ref), v195 (ref), v128 (ref)
        local v660 = v565.global();
        v660 = msgpack.pack(v660);
        v660 = v194.encode(v660, v195) .. "_outlaw";
        v128(v660);
    end, true);
    do
        local l_v575_1 = v575;
        v574:button(" \a{Link Active}\239\149\175\aDEFAULT Import Config ", function()
            -- upvalues: v128 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), l_v575_1 (ref), v565 (ref)
            local v662 = v128();
            local v663, v664 = l_pcall_0(v194.decode, v662, v196);
            if not v663 then
                return l_v575_1(false, "failed to import config");
            else
                local v665, v666 = l_pcall_0(msgpack.unpack, v664);
                if not v665 then
                    return l_v575_1(false, "failed to import config");
                elseif v666.name and v666.config and v666.username and v666.unixtime then
                    return l_v575_1(false, "failed to import config (not global config)");
                else
                    v565.global(v666);
                    l_v575_1(true, "config has been successfully imported");
                    return;
                end;
            end;
        end, true);
    end;
    v574 = ui.create("\239\128\149", "\239\128\147 default configurations", 2);
    v575 = function(v667, v668)
        -- upvalues: l_format_0 (ref)
        local v669 = v667 and "\aA0CB27FF" or "\aFF7575FF";
        local v670 = v667 and "[+] " or "[-] ";
        local v671 = l_format_0("%s%s%s", v669, v670, v668);
        local v672 = l_format_0("%s[outlaw]\aDEFAULT %s", v669, v668);
        print_dev(v671);
        print_raw(v672);
    end;
    v576 = v574:list("\n version", "\239\131\154  Live", "\239\131\154  Alpha", "\239\131\154  Elite");
    v577 = v574:list("\n config", "\239\131\154  Default", "\239\131\154  Experimental");
    v578, v579 = v574:label("updated");
    v578:visibility(false);
    do
        local l_v575_2, l_v576_0, l_v577_0, l_v578_0, l_v579_0, l_v580_1, l_v581_0 = v575, v576, v577, v578, v579, v580, v581;
        l_v580_1 = function()
            -- upvalues: l_v579_0 (ref), l_v576_0 (ref), l_v577_0 (ref), l_get_date_0 (ref), l_v578_0 (ref)
            if l_v579_0 ~= nil then
                local v680 = l_v576_0:get();
                local v681 = l_v577_0:get();
                local l_unixtime_0 = l_v579_0[v680][v681].unixtime;
                local v683 = l_get_date_0("%d.%m %H:%M", l_unixtime_0);
                l_v578_0:name("  \239\129\132 Updated: " .. v683);
                l_v578_0:visibility(true);
            end;
        end;
        l_v576_0:set_callback(l_v580_1, true);
        l_v577_0:set_callback(l_v580_1, true);
        v574:button(" \a{Link Active}\239\129\152\aDEFAULT Load ", function()
            -- upvalues: l_v579_0 (ref), l_v576_0 (ref), l_v577_0 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), l_v575_2 (ref), v565 (ref)
            if l_v579_0 == nil then
                return;
            else
                local v684 = l_v576_0:get();
                local v685 = l_v577_0:get();
                v685 = l_v579_0[v684][v685].text;
                local v686, v687 = l_pcall_0(v194.decode, v685, v196);
                if not v686 then
                    return l_v575_2(false, "failed to import config");
                else
                    local v688, v689 = l_pcall_0(msgpack.unpack, v687);
                    if not v688 then
                        return l_v575_2(false, "failed to import config");
                    else
                        v565.global(v689);
                        l_v575_2(true, "config has been successfully imported");
                        return;
                    end;
                end;
            end;
        end, true);
        l_v581_0 = function()
            -- upvalues: l_len_0 (ref), l_pcall_0 (ref), l_type_0 (ref), l_v579_0 (ref), l_v580_1 (ref)
            network.get("https://northon.dev/neverlose/melancholia/api/", {}, function(v690)
                -- upvalues: l_len_0 (ref), l_pcall_0 (ref), l_type_0 (ref), l_v579_0 (ref), l_v580_1 (ref)
                if v690 and l_len_0(v690) == 0 then
                    return;
                else
                    local v691, v692 = l_pcall_0(json.parse, v690);
                    if not v691 or l_type_0(v692) ~= "table" then
                        return;
                    else
                        l_v579_0 = v692;
                        l_v580_1();
                        return;
                    end;
                end;
            end);
        end;
        l_v581_0();
        if v2 then
            v574:button("\a{Link Active} \208\175 \208\154\208\149\208\154\208\161\aDEFAULT (\208\144\208\159\208\148\208\149\208\153\208\162)", function()
                -- upvalues: l_v576_0 (ref), l_v577_0 (ref), l_get_unixtime_0 (ref), v565 (ref), v194 (ref), v195 (ref), l_v581_0 (ref)
                local v693 = l_v576_0:get();
                local v694 = l_v577_0:get();
                local v695 = l_get_unixtime_0();
                local v696 = v565.global();
                v696 = msgpack.pack(v696);
                v696 = v194.encode(v696, v195);
                network.post("https://northon.dev/neverlose/melancholia/api/update.php", {
                    version = v693, 
                    config = v694, 
                    text = v696, 
                    unixtime = v695
                }, {}, function(v697)
                    -- upvalues: l_v581_0 (ref)
                    print_raw(v697);
                    l_v581_0();
                end);
            end, true);
        end;
    end;
    v574 = ui.create("\239\128\147", "\239\132\164 Tab Selection", 1):list("\n tab selection", "\239\129\155  Ragebot Assistant", "\239\132\178  Anti Aim Manager", "\239\129\187  Anti Aim Configs");
    v575 = ui.create("\239\128\147", "\239\129\155  Ragebot", 1);
    do
        local l_v575_3, l_v579_1, l_v581_1 = v575, v579, v581;
        v574:set_callback(function(v701)
            -- upvalues: l_v575_3 (ref)
            l_v575_3:visibility(v701:get() == 1);
        end, true);
        v576 = nil;
        v576 = {
            enabled = v565.global("nm", l_v575_3:switch("\239\153\136  Noscope Mode"))
        };
        v577 = v576.enabled:create();
        v578 = {
            [1] = "Autosniper", 
            [2] = "SSG 08", 
            [3] = "AWP"
        };
        for v702, v703 in l_ipairs_0(v578) do
            v576[v702] = v565.global("nm" .. v702, v577:slider(v703 .. " HC", -1, 100, 50, 1, function(v704)
                return v704 == -1 and "Off" or v704 .. "%";
            end));
        end;
        v576.distance = v565.global("nmd", v577:slider("Distance", 40, 201, 0, 0.1, function(v705)
            return v705 == 201 and "inf" or v705 * 0.1 .. "m";
        end));
        do
            local l_v577_1 = v577;
            v576.enabled:set_callback(function(v707)
                -- upvalues: l_v577_1 (ref)
                l_v577_1:visibility(v707:get());
            end, true);
            v566.noscope_mode = v576;
        end;
        v577 = nil;
        v566.adaptive_air_stop = v565.global("aas", l_v575_3:switch("\239\129\158  Adaptive Air Stop"));
        v578 = nil;
        v578 = {
            enabled = v565.global("as", l_v575_3:switch("\239\129\155  Adaptive Silent"))
        };
        l_v579_1 = v578.enabled:create();
        v578.fov = v565.global("asf", l_v579_1:slider("\n fov", 1, 180, 5, 1, "\194\176"));
        do
            local l_l_v579_1_0 = l_v579_1;
            v578.enabled:set_callback(function(v709)
                -- upvalues: l_l_v579_1_0 (ref)
                l_l_v579_1_0:visibility(v709:get());
            end, true);
            v566.adaptive_silent = v578;
        end;
        l_v579_1 = nil;
        l_v579_1 = {};
        v580 = ui.create("\239\128\147", "\n aimtools", 1);
        do
            local l_v580_2, l_v582_0, l_v583_0 = v580, v582, v583;
            v574:set_callback(function(v713)
                -- upvalues: l_v580_2 (ref)
                l_v580_2:visibility(v713:get() == 1);
            end, true);
            l_v579_1.enabled = v565.global("a", l_v580_2:switch("\239\130\173  Aim Tools"));
            l_v579_1.group = l_v579_1.enabled:create();
            
            if v2 then
                l_v579_1.keks_debugger = l_v579_1.group:switch("Debugger (\208\186\208\181\208\186\209\129\208\176)");
            end;
            l_v579_1.debugger = v565.global("ad", l_v579_1.group:switch("Debugger"));
            l_v579_1.static_autostops = v565.global("asa", l_v579_1.group:switch("FD Static autostops"));
            l_v579_1.adaptive_safepoint_logic = v565.global("aasl", l_v579_1.group:selectable("Adaptive Safepoint Logic", "Distance", "Condition", "Air", "Min Damage", "Multipoint"));
            l_v579_1.fast_quick_peeking = v565.global("afqp", l_v579_1.group:selectable("Fast Quick Peeking", "Revolver", "Advanced", "Min Damage"));
            l_v581_1 = function()
                -- upvalues: v0 (ref), l_v579_1 (ref)
                if v0 == 3 then
                    return;
                else
                    l_v579_1.debugger:disabled(false);
                    l_v579_1.adaptive_safepoint_logic:disabled(false);
                    l_v579_1.fast_quick_peeking:disabled(false);
                    return;
                end;
            end;
            l_v579_1.debugger:set_callback(l_v581_1, true);
            l_v579_1.adaptive_safepoint_logic:set_callback(l_v581_1, true);
            l_v579_1.fast_quick_peeking:set_callback(l_v581_1, true);
            l_v582_0 = nil;
            l_v582_0 = {
                enabled = v565.global("aafbs", l_v580_2:switch("\239\132\178  Adaptive Force Body / Safety"))
            };
            l_v583_0 = l_v582_0.enabled:create();
            l_v582_0.selection = v565.global("aafbss", l_v583_0:list("\n selection", "Force Body", "Force Safety"));
            l_v582_0.mode = v565.global("aafbsm", l_v583_0:list("\n mode", "Safety", "Custom"));
            v584 = {
                [1] = "Global", 
                [2] = "AutoSnipers", 
                [3] = "SSG-08", 
                [4] = "AWP", 
                [5] = "Desert Eagle", 
                [6] = "R8 Revolver", 
                [7] = "Pistols"
            };
            l_v582_0.weapon_selection = v565.global("aafbws", l_v583_0:list("\n selection", v584));
            l_v582_0.mode:set_callback(function(v714)
                -- upvalues: l_v582_0 (ref)
                l_v582_0.weapon_selection:visibility(v714:get() == 2);
            end, true);
            for v715 in l_ipairs_0(v584) do
                local v716 = l_rep_0(" ", v715);
                l_v582_0[v715] = {};
                if v715 ~= 1 then
                    l_v582_0[v715].enabled = v565.global("aafbw" .. v715, l_v583_0:switch("Enabled" .. v716));
                end;
                l_v582_0[v715].distance = v565.global("aafbwd" .. v715, l_v583_0:slider("Distance" .. v716, 1, 3000, 10, 1, "u"));
                l_v582_0[v715].damage = v565.global("aafbd" .. v715, l_v583_0:slider("\n damage" .. v716, 0, 100, 0, 1, "hp"));
                do
                    local l_v715_0 = v715;
                    local function v721()
                        -- upvalues: l_v715_0 (ref), l_v582_0 (ref)
                        local v718 = l_v715_0 == 1 or l_v582_0[l_v715_0].enabled:get();
                        local v719 = l_v582_0.mode:get() == 2;
                        local v720 = l_v582_0.weapon_selection:get() == l_v715_0;
                        if l_v715_0 ~= 1 then
                            l_v582_0[l_v715_0].enabled:visibility(v719 and v720);
                        end;
                        l_v582_0[l_v715_0].distance:visibility(v718 and v719 and v720);
                        l_v582_0[l_v715_0].damage:visibility(v718 and v719 and v720);
                    end;
                    l_v582_0.mode:set_callback(v721, true);
                    l_v582_0.weapon_selection:set_callback(v721, true);
                    if l_v715_0 ~= 1 then
                        l_v582_0[l_v715_0].enabled:set_callback(v721, true);
                    end;
                end;
            end;
            do
                local l_l_v583_0_0 = l_v583_0;
                l_v582_0.enabled:set_callback(function(v723)
                    -- upvalues: l_l_v583_0_0 (ref)
                    l_l_v583_0_0:visibility(v723:get());
                end, true);
                v566.adaptive_force_body_safety = l_v582_0;
            end;
            l_v583_0 = nil;
            l_v583_0 = {
                enabled = v565.global("afst", l_v580_2:switch("\239\132\178  Force Safety Triggers"))
            };
            v584 = l_v583_0.enabled:create();
            l_v583_0.selection = v565.global("afsts", v584:listable("\n force safety triggers", "Target is Using Grenades", "Target is Switching Weapon", "Target is Shooting"));
            do
                local l_v584_0 = v584;
                v585 = function()
                    -- upvalues: l_v579_1 (ref), l_v583_0 (ref), l_v584_0 (ref)
                    local v725 = l_v579_1.enabled:get();
                    local v726 = l_v583_0.enabled:get();
                    l_v583_0.enabled:visibility(v725);
                    l_v584_0:visibility(v725 and v726);
                end;
                l_v579_1.enabled:set_callback(v585, true);
                l_v583_0.enabled:set_callback(v585, true);
                v566.force_safety_triggets = l_v583_0;
            end;
            l_v579_1.enabled:set_callback(function(v727)
                -- upvalues: l_v579_1 (ref), l_v582_0 (ref)
                local v728 = v727:get();
                l_v579_1.group:visibility(v728);
                l_v582_0.enabled:visibility(v728);
            end, true);
            v566.aimtools = l_v579_1;
        end;
        v580 = nil;
        l_v581_1 = ui.create("\239\128\147", "\n anti aim", 1);
        do
            local l_l_v581_1_0, l_v582_1, l_v583_1, l_v584_1, l_v585_0 = l_v581_1, v582, v583, v584, v585;
            v574:set_callback(function(v734)
                -- upvalues: l_l_v581_1_0 (ref)
                l_l_v581_1_0:visibility(v734:get() == 1);
            end, true);
            v580 = {
                enabled = v565.global("b", l_l_v581_1_0:switch("\aAFAF62FF\239\156\140  Animation Changer"))
            };
            l_v582_1 = v580.enabled:create();
            l_v583_1 = nil;
            l_v583_1 = {
                enabled = v565.global("ablm", l_v582_1:switch("\239\131\154  Leg Movement")), 
                selection = v565.global("ablms", l_v582_1:combo("\n leg movement", "Static", "Jitter", "Walking"))
            };
            l_v583_1.enabled:set_callback(function(v735)
                -- upvalues: l_v583_1 (ref)
                l_v583_1.selection:visibility(v735:get());
            end, true);
            v580.leg_movement = l_v583_1;
            v580.sliding_slowwalk = v565.global("abss", l_v582_1:switch("\239\131\154  Sliding Slowwalk"));
            l_v584_1 = nil;
            l_v584_1 = {
                enabled = v565.global("abia", l_v582_1:switch("\239\131\154  In Air")), 
                selection = v565.global("abias", l_v582_1:combo("\n in air", "Static", "Walking"))
            };
            l_v584_1.enabled:set_callback(function(v736)
                -- upvalues: l_v584_1 (ref)
                l_v584_1.selection:visibility(v736:get());
            end, true);
            v580.in_air = l_v584_1;
            v580.legacy_force_falling = v565.global("ablff", l_v582_1:switch("\239\131\154  Legacy Force Falling"));
            l_v585_0 = nil;
            l_v585_0 = {
                enabled = v565.global("abmle", l_v582_1:switch("\239\131\154  Move Lean")), 
                force = v565.global("abmlf", l_v582_1:slider("\n move lean", 1, 100, 100, 1, "%"))
            };
            l_v585_0.enabled:set_callback(function(v737)
                -- upvalues: l_v585_0 (ref)
                l_v585_0.force:visibility(v737:get());
            end, true);
            v580.move_lean = l_v585_0;
            v580.landing_pitch = v565.global("ablp", l_v582_1:switch("\239\131\154  Landing Pitch"));
            v580.enabled:set_callback(function(v738)
                -- upvalues: l_v582_1 (ref)
                l_v582_1:visibility(v738:get());
            end, true);
            v566.animation_breaker = v580;
        end;
        l_v581_1 = ui.create("\239\128\147", "\239\139\170  Anti Aim", 1);
        v574:set_callback(function(v739)
            -- upvalues: l_v581_1 (ref)
            l_v581_1:visibility(v739:get() == 2);
        end, true);
        v582 = nil;
        v582 = {
            enabled = v565.global("f", l_v581_1:switch("\239\139\177  Freestanding"))
        };
        v583 = v582.enabled:create();
        v582.selection = v565.global("fs", v583:listable("\n selection", "Disable Yaw Modifiers", "Body Freestanding"));
        v582.disablers = v565.global("fd", v583:selectable("\239\131\154  Disablers:", "On Slow Walking", "In Air", "In Crouching"));
        v582.yaw_type = v565.global("fyt", v583:slider("\239\131\154  Yaw Type", 1, 2, 1, 1, function(v740)
            if v740 == 1 then
                return "Static";
            elseif v740 == 2 then
                return "Flick";
            else
                return;
            end;
        end));
        v566.freestanding = v582;
        v583 = nil;
        v583 = {
            base = v565.global("my", l_v581_1:combo("\238\130\160  Manual Yaw", "Off", "Left", "Right", "Forward"))
        };
        v584 = v583.base:create();
        v583.disablers = v565.global("yd", v584:selectable("\239\131\154  Disablers:", "Yaw Modifiers", "At Target"));
        v583.yaw_type = v565.global("myyt", v584:slider("\239\131\154  Yaw Type", 1, 2, 1, 1, function(v741)
            if v741 == 1 then
                return "Static";
            elseif v741 == 2 then
                return "Flick";
            else
                return;
            end;
        end));
        v566.manual_yaw = v583;
        v584 = nil;
        v584 = {
            enabled = v565.global("ey", l_v581_1:switch("\239\129\182  Edge Yaw"))
        };
        v585 = v584.enabled:create();
        v584.selection = v565.global("eys", v585:listable("\n selection", "Disable Yaw Modifiers", "Static Body Yaw", "Disable Defensive AA"));
        v584.disablers = v565.global("eyd", v585:selectable("\239\131\154  Disablers:", "On Slow Walking", "In Air", "In Crouching"));
        v566.edge_yaw = v584;
        v585 = nil;
        v585 = {};
        local v742 = ui.create("\239\128\147", "\n anti aim flick", 1);
        do
            local l_v742_0 = v742;
            v574:set_callback(function(v744)
                -- upvalues: l_v742_0 (ref)
                l_v742_0:visibility(v744:get() == 2);
            end, true);
            v585.enabled = v565.global("faa", l_v742_0:switch("\239\141\163  \aFF9E9EFFFlick \aDEFAULTAA"));
            local v745 = v585.enabled:create();
            v585.enabled:set_callback(function(v746)
                -- upvalues: v745 (ref)
                v745:visibility(v746:get());
            end, true);
            local v747 = {
                [1] = "Standing", 
                [2] = "Moving", 
                [3] = "Slowwalk", 
                [4] = "Crouching", 
                [5] = "Air", 
                [6] = "Crouch-Air"
            };
            for v748, v749 in l_ipairs_0(v747) do
                v585[v749] = v565.global("faa" .. v748, v745:selectable(v749, "Always", "Invisible", "High Ground"));
            end;
            v566.flick_aa = v585;
        end;
        v742 = nil;
        local v750 = ui.create("\239\128\147", "\239\128\147  Helpers", 1);
        do
            local l_v750_0 = v750;
            v574:set_callback(function(v752)
                -- upvalues: l_v750_0 (ref)
                l_v750_0:visibility(v752:get() == 2);
            end, true);
            v566.helpers = v565.global("h", l_v750_0:listable("\n helpers", "\239\155\181  Static with Knife", "\238\128\163   Disable FL on Exploits", "\239\128\145   Disable AA on Warmup", "\239\148\150  Unbalance Dormant AA"));
        end;
        v750 = ui.create("\239\128\147", "\239\128\147  Builder", 2);
        local v753 = nil;
        local v754 = nil;
        v753 = {
            [1] = "Global", 
            [2] = "Standing", 
            [3] = "Moving", 
            [4] = "Slowwalk", 
            [5] = "Crouching T", 
            [6] = "Crouching CT", 
            [7] = "Air", 
            [8] = "Crouch-Air", 
            [9] = "Using", 
            [10] = "Fake Lag", 
            [11] = "Fake Duck"
        };
        v754 = {
            ["Fake Lag"] = "\238\129\130", 
            Using = "\238\149\145", 
            ["Crouch-Air"] = "\239\159\135", 
            Air = "\239\159\135", 
            ["Crouching CT"] = "\238\136\159", 
            ["Crouching T"] = "\238\136\159", 
            Slowwalk = "\239\149\148", 
            Moving = "\239\156\140", 
            Standing = "\239\134\131", 
            Global = "\239\130\172", 
            ["Fake Duck"] = "\238\136\159"
        };
        local v755 = nil;
        if v0 == 3 then
            v755 = v565.antiaim("bm", v750:list("\n mode", "\239\145\168  Disabled", "\239\132\166   Automatic Set Presets", "\239\151\189   Advanced"));
        else
            v755 = v565.antiaim("bm", v750:list("\n mode", "\239\145\168  Disabled", "\239\151\189   Advanced"));
        end;
        v566.mode = v755;
        local v756 = nil;
        v756 = {};
        local v757 = ui.create("\239\128\147", "\239\136\179   Advanced", 2);
        do
            local l_v757_0 = v757;
            v755.set_callback(v755, function(v759)
                -- upvalues: l_v757_0 (ref), v0 (ref)
                l_v757_0:visibility(v759:get() == (v0 == 3 and 3 or 2));
            end, true);
            local v760 = nil;
            v760 = function(v761)
                local v762 = v761.s_phases:get();
                if v762 == 5 then
                    return;
                else
                    v762 = v762 + 1;
                    v761.s_phases:set(v762);
                    return;
                end;
            end;
            local v763 = nil;
            v763 = function(v764)
                local v765 = v764.s_phases:get();
                if v765 == 1 then
                    return;
                else
                    v765 = v765 - 1;
                    v764.s_phases:set(v765);
                    v764.selection:set(v765);
                    return;
                end;
            end;
            local v766 = nil;
            v766 = function(v767)
                -- upvalues: l_next_0 (ref), l_pcall_0 (ref)
                local v768 = v767.selection:get();
                v768 = v767.phases[v768];
                for _, v770 in l_next_0, v768 do
                    l_pcall_0(v770.reset, v770);
                end;
            end;
            local v771 = nil;
            v771 = function(v772, v773)
                -- upvalues: l_format_0 (ref)
                local v774 = v772 and "\aA0CB27FF" or "\aFF7575FF";
                local v775 = v772 and "[+] " or "[-] ";
                local v776 = l_format_0("%s%s%s", v774, v775, v773);
                local v777 = l_format_0("%s[outlaw]\aDEFAULT %s", v774, v773);
                print_dev(v776);
                print_raw(v777);
            end;
            local v778 = nil;
            local v779 = nil;
            v779 = {
                switch = true, 
                slider = true, 
                combo = true, 
                selectable = true, 
                color_picker = true, 
                hotkey = true, 
                textbox = true, 
                list = true, 
                listable = true
            };
            do
                local l_v779_0 = v779;
                v778 = function(v781)
                    -- upvalues: l_next_0 (ref), l_type_0 (ref), v778 (ref), l_v779_0 (ref), l_pcall_0 (ref)
                    local v782 = {};
                    for v783, v784 in l_next_0, v781 do
                        local v785 = l_type_0(v784);
                        if v785 == "table" then
                            v782[v783] = v778(v784);
                        elseif v785 == "userdata" then
                            local l_v784_0 = v784;
                            if l_v779_0[l_v784_0.type and l_v784_0:type() or ""] ~= nil then
                                local v787, v788 = l_pcall_0(l_v784_0.get, l_v784_0);
                                if v787 then
                                    v782[v783] = v788;
                                end;
                            end;
                        else
                            v782[v783] = v784;
                        end;
                    end;
                    return v782;
                end;
            end;
            v779 = nil;
            v779 = function(v789, v790)
                -- upvalues: l_type_0 (ref), l_next_0 (ref), l_pcall_0 (ref), v779 (ref)
                if l_type_0(v789) ~= "table" or l_type_0(v790) ~= "table" then
                    return false;
                else
                    for v791, v792 in l_next_0, v790 do
                        local v793 = v789[v791];
                        if v793 then
                            if l_type_0(v793) == "userdata" then
                                l_pcall_0(v793.set, v793, v792);
                            elseif l_type_0(v792) == "table" then
                                v779(v793, v792);
                            end;
                        end;
                    end;
                    return true;
                end;
            end;
            local v794 = nil;
            v794 = function(v795, v796, v797)
                -- upvalues: v778 (ref), v194 (ref), v195 (ref), v128 (ref)
                return function()
                    -- upvalues: v796 (ref), v795 (ref), v778 (ref), v797 (ref), v194 (ref), v195 (ref), v128 (ref)
                    local v798 = v795[v796:get()];
                    local v799 = v778(v798);
                    v799 = msgpack.pack(v799) .. v797;
                    v799 = v194.encode(v799, v195) .. "_outlaw";
                    v128(v799);
                end;
            end;
            local v800 = nil;
            v800 = function(v801, v802, v803)
                -- upvalues: v128 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), v771 (ref), l_find_0 (ref), l_format_0 (ref), l_gsub_0 (ref), v779 (ref)
                return function()
                    -- upvalues: v802 (ref), v801 (ref), v128 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), v771 (ref), l_find_0 (ref), v803 (ref), l_format_0 (ref), l_gsub_0 (ref), v779 (ref)
                    local v804 = v801[v802:get()];
                    local v805 = v128();
                    local v806, v807 = l_pcall_0(v194.decode, v805, v196);
                    if not v806 then
                        return v771(false, "failed to import config");
                    elseif l_find_0(v807, v803) == nil then
                        return v771(false, l_format_0("the config is not valid for antiaim (%s)", l_gsub_0(l_gsub_0(v803, "<", ""), ">", "")));
                    else
                        v807 = l_gsub_0(v807, v803, "");
                        local v808, v809 = l_pcall_0(msgpack.unpack, v807);
                        if not v808 then
                            return v771(false, "failed to import config");
                        else
                            local v810, v811 = l_pcall_0(v779, v804, v809);
                            if not v810 or not v811 then
                                return v771(false, "failed to import config");
                            else
                                print_dev("\aA0CB27FF[+] config has been successfully imported");
                                print_raw("\aA0CB27FF[outlaw] \aDEFAULTconfig has been successfully imported");
                                return;
                            end;
                        end;
                    end;
                end;
            end;
            local v812 = nil;
            v812 = l_v757_0:combo("Condition", v753);
            v812:set_callback(function(v813)
                -- upvalues: v754 (ref)
                local v814 = v754[v813:get()];
                if v814 == nil then
                    return;
                else
                    v813:name(v814 .. "  Condition");
                    return;
                end;
            end, true);
            local v815 = "";
            for v816, v817 in l_ipairs_0(v753) do
                v815 = v815 .. " ";
                local v818 = nil;
                v818 = {};
                local v819 = nil;
                if v817 ~= "Global" then
                    v819 = v565.antiaim("bao" .. v816, l_v757_0:switch("\239\131\154  Override " .. v817 .. v815));
                    v818.override = v819;
                end;
                v815 = v815 .. " ";
                local v820 = nil;
                local v821 = {
                    [1] = "Custom"
                };
                local l_advanced_0 = v564.advanced;
                for _, v824 in l_ipairs_0(l_advanced_0.menu[v817]) do
                    v821[#v821 + 1] = v824;
                end;
                v820 = v565.antiaim("bap" .. v816, l_v757_0:combo("\239\131\154  Preset " .. v815, v821));
                local v825 = l_advanced_0.presets[v817];
                v818.preset = v820;
                v818.presets = v825;
                v821 = nil;
                v821 = v565.antiaim("dc" .. v816, l_v757_0:combo("\239\131\154  Defensive AA" .. v815, "No Defensive", "Defensive"));
                v818.defensive_conditions = v821;
                l_advanced_0 = nil;
                v825 = nil;
                do
                    local l_v817_0 = v817;
                    do
                        local l_v818_0 = v818;
                        if v2 then
                            l_advanced_0 = l_v757_0:button("\208\186\208\181\208\186\209\129\208\184\208\186 (\209\141\208\186\209\129\208\191\208\190\209\128\209\130)", function()
                                -- upvalues: v778 (ref), l_v818_0 (ref), v194 (ref), v195 (ref), v128 (ref)
                                local v828 = v778(l_v818_0);
                                v828 = msgpack.pack(v828) .. "<condition>";
                                v828 = v194.encode(v828, v195) .. "_outlaw";
                                v128(v828);
                            end, true);
                            v825 = l_v757_0:button("\208\186\208\181\208\186\209\129\208\184\208\186 (\208\184\208\188\208\191\208\190\209\128\209\130)", function()
                                -- upvalues: v128 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), v771 (ref), l_find_0 (ref), l_gsub_0 (ref), v779 (ref), l_v818_0 (ref)
                                local v829 = v128();
                                local v830, v831 = l_pcall_0(v194.decode, v829, v196);
                                if not v830 then
                                    return v771(false, "failed to import config");
                                elseif l_find_0(v831, "<condition>") == nil then
                                    return v771(false, "the config is not valid for antiaim (condition)");
                                else
                                    v831 = l_gsub_0(v831, "<condition>", "");
                                    local v832, v833 = l_pcall_0(msgpack.unpack, v831);
                                    if not v832 or not v833 then
                                        return v771(false, "failed to import config");
                                    else
                                        local v834, v835 = l_pcall_0(v779, l_v818_0, v833);
                                        if not v834 or not v835 then
                                            return v771(false, "failed to import config");
                                        else
                                            return v771(true, "config has been successfully imported");
                                        end;
                                    end;
                                end;
                            end, true);
                        end;
                        local v836 = ui.create("\239\128\147", "\n advanced" .. l_v817_0 .. v815, 2);
                        local _ = nil;
                        l_v818_0.pitch = v565.antiaim("builder advanced pitch" .. v816, v836:combo("\239\131\154  Pitch" .. v815, "Disabled", "Down", "Fake Down", "Fake Up"));
                        local v838 = nil;
                        v838 = {
                            mode = v565.antiaim("baym" .. v816, v836:combo("\239\131\154  Yaw" .. v815, "Disabled", "Backward", "Static"))
                        };
                        local v839 = v838.mode:create();
                        v838.base = v565.antiaim("bayb" .. v816, v839:combo("\239\131\154  Base" .. v815, "Local View", "At Target"));
                        v838.s_phases = v565.antiaim("baasp" .. v816, v839:slider("Phases" .. v815, 1, 5, 1):visibility(false));
                        do
                            local l_v819_0, l_v820_0, l_v821_0, l_l_advanced_0_0, l_v825_0, l_v836_0, l_v838_0, l_v839_0 = v819, v820, v821, l_advanced_0, v825, v836, v838, v839;
                            l_v838_0.add_phase = l_v839_0:button("+", function()
                                -- upvalues: v760 (ref), l_v838_0 (ref)
                                v760(l_v838_0);
                            end, true):tooltip("Add New Phase");
                            l_v838_0.remove_phase = l_v839_0:button("\239\135\184", function()
                                -- upvalues: v763 (ref), l_v838_0 (ref)
                                v763(l_v838_0);
                            end, true):tooltip("Remove Last Phase");
                            l_v838_0.reset = l_v839_0:button("\239\139\177", function()
                                -- upvalues: v766 (ref), l_v838_0 (ref)
                                v766(l_v838_0);
                            end, true):tooltip("Reset Selected Phase");
                            l_v838_0.export = l_v839_0:button("\239\149\174", nil, true):tooltip("Export Selected Phase");
                            l_v838_0.import = l_v839_0:button("\239\149\175 ", nil, true):tooltip("Import Selected Phase");
                            local v848 = nil;
                            v848 = v565.antiaim("baas" .. v816, l_v839_0:list("\n phases" .. v815, "1"));
                            do
                                local l_l_v839_0_0, l_v848_0 = l_v839_0, v848;
                                l_v838_0.s_phases:set_callback(function(v851)
                                    -- upvalues: l_tostring_0 (ref), l_v848_0 (ref)
                                    local v852 = v851:get();
                                    local v853 = {};
                                    for v854 = 1, v852 do
                                        v853[v854] = l_tostring_0(v854);
                                    end;
                                    l_v848_0:update(v853);
                                end, true);
                                l_v838_0.selection = l_v848_0;
                                local v855 = nil;
                                v855 = {};
                                for v856 = 1, 5 do
                                    local v857 = l_rep_0(" ", v856) .. v815;
                                    local v858 = nil;
                                    v858 = {
                                        type = v565.antiaim("baapt" .. v816 .. v856, l_l_v839_0_0:combo("\239\131\154  Type" .. v857, "Left | Right")), 
                                        left = v565.antiaim("baapl" .. v816 .. v856, l_l_v839_0_0:slider("\239\131\154  Left" .. v857, -180, 180, 0, 1, "\194\176")), 
                                        right = v565.antiaim("baapr" .. v816 .. v856, l_l_v839_0_0:slider("\239\131\154  Right" .. v857, -180, 180, 0, 1, "\194\176")), 
                                        delay_ticks = v565.antiaim("baapdt" .. v816 .. v856, l_l_v839_0_0:slider("\239\131\154  Delay Ticks" .. v857, 1, 20, 2, 1, function(v859)
                                            if v859 == 1 then
                                                return "Off";
                                            else
                                                return v859 .. "t";
                                            end;
                                        end)), 
                                        time = v565.antiaim("baapti" .. v816 .. v856, l_l_v839_0_0:slider("\239\131\154  Time" .. v857, 1, 150, 5, 0.1, "s"))
                                    };
                                    local v860 = nil;
                                    do
                                        local l_v856_0 = v856;
                                        do
                                            local l_v858_0 = v858;
                                            v860 = function()
                                                -- upvalues: l_v848_0 (ref), l_v856_0 (ref), l_v858_0 (ref)
                                                local v863 = l_v848_0:get() == l_v856_0;
                                                l_v858_0.type:visibility(v863);
                                                l_v858_0.left:visibility(v863);
                                                l_v858_0.right:visibility(v863);
                                                l_v858_0.delay_ticks:visibility(v863);
                                                l_v858_0.time:visibility(v863);
                                            end;
                                            l_v848_0:set_callback(v860, true);
                                            l_v858_0.type:set_callback(v860, true);
                                            v855[l_v856_0] = l_v858_0;
                                        end;
                                    end;
                                end;
                                l_v838_0.phases = v855;
                                l_v838_0.export:set_callback(v794(l_v838_0.phases, l_v838_0.selection, "<yaw>"));
                                l_v838_0.import:set_callback(v800(l_v838_0.phases, l_v838_0.selection, "<yaw>"));
                                local v864 = nil;
                                v864 = function()
                                    -- upvalues: l_v838_0 (ref), l_l_v839_0_0 (ref)
                                    local v865 = l_v838_0.mode:get() ~= "Disabled";
                                    l_l_v839_0_0:visibility(v865);
                                end;
                                l_v838_0.mode:set_callback(v864, true);
                                l_v818_0.yaw = l_v838_0;
                            end;
                            l_v839_0 = nil;
                            l_v839_0 = {
                                mode = v565.antiaim("baymm" .. v816, l_v836_0:combo("\239\131\154  Yaw Modifier" .. v815, "Disabled", "Center", "Offset", "Spin", "Advanced"))
                            };
                            v848 = l_v839_0.mode:create();
                            l_v839_0.offset = v565.antiaim("baymo" .. v816, v848:slider("\239\131\154  Offset" .. v815, -180, 180, 0, 1, "\194\176"));
                            local v866 = nil;
                            v866 = {
                                s_phases = v565.antiaim("baymsp" .. v816, v848:slider("Phases" .. v815, 1, 5, 1)):visibility(false)
                            };
                            do
                                local l_v848_1, l_v866_0 = v848, v866;
                                l_v866_0.add_phase = l_v848_1:button("+", function()
                                    -- upvalues: v760 (ref), l_v866_0 (ref)
                                    v760(l_v866_0);
                                end, true):tooltip("Add New Phase");
                                l_v866_0.remove_phase = l_v848_1:button("\239\135\184", function()
                                    -- upvalues: v763 (ref), l_v866_0 (ref)
                                    v763(l_v866_0);
                                end, true):tooltip("Remove Last Phase");
                                l_v866_0.reset = l_v848_1:button("\239\139\177", function()
                                    -- upvalues: v766 (ref), l_v866_0 (ref)
                                    v766(l_v866_0);
                                end, true):tooltip("Reset Selected Phase");
                                l_v866_0.export = l_v848_1:button("\239\149\174", nil, true):tooltip("Export Selected Phase");
                                l_v866_0.import = l_v848_1:button("\239\149\175 ", nil, true):tooltip("Import Selected Phase");
                                local v869 = nil;
                                v869 = v565.antiaim("baymselection" .. v816, l_v848_1:list("\n phases" .. v815, "1"));
                                do
                                    local l_v869_0 = v869;
                                    l_v866_0.s_phases:set_callback(function(v871)
                                        -- upvalues: l_tostring_0 (ref), l_v869_0 (ref)
                                        local v872 = v871:get();
                                        local v873 = {};
                                        for v874 = 1, v872 do
                                            v873[v874] = l_tostring_0(v874);
                                        end;
                                        l_v869_0:update(v873);
                                    end, true);
                                    l_v866_0.selection = l_v869_0;
                                    local v875 = nil;
                                    v875 = {};
                                    for v876 = 1, 5 do
                                        local v877 = l_rep_0(" ", v876) .. v815;
                                        local v878 = nil;
                                        v878 = {
                                            mode = v565.antiaim("baympm" .. v816 .. v876, l_v848_1:combo("\239\131\154  Yaw Modifier" .. v877, "Disabled", "Center", "Offset", "Spin")), 
                                            offset = v565.antiaim("baympo" .. v816 .. v876, l_v848_1:slider("\239\131\154  Offset" .. v877, -180, 180, 0, 1, "\194\176")), 
                                            time = v565.antiaim("baympti" .. v816 .. v876, l_v848_1:slider("\239\131\154  Time" .. v877, 1, 150, 5, 0.1, "s"))
                                        };
                                        local v879 = nil;
                                        do
                                            local l_v876_0 = v876;
                                            do
                                                local l_v878_0 = v878;
                                                v879 = function()
                                                    -- upvalues: l_v869_0 (ref), l_v876_0 (ref), l_v878_0 (ref), l_v839_0 (ref)
                                                    local v882 = l_v869_0:get() == l_v876_0;
                                                    local v883 = l_v878_0.mode:get() ~= "Disabled";
                                                    local v884 = l_v839_0.mode:get() == "Advanced";
                                                    l_v878_0.mode:visibility(v884 and v882);
                                                    l_v878_0.offset:visibility(v884 and v882 and v883);
                                                    l_v878_0.time:visibility(v884 and v882);
                                                end;
                                                l_v869_0:set_callback(v879, true);
                                                l_v878_0.mode:set_callback(v879, true);
                                                l_v839_0.mode:set_callback(v879, true);
                                                v875[l_v876_0] = l_v878_0;
                                            end;
                                        end;
                                    end;
                                    l_v866_0.phases = v875;
                                    l_v866_0.export:set_callback(v794(l_v866_0.phases, l_v866_0.selection, "<yaw modifier>"));
                                    l_v866_0.import:set_callback(v800(l_v866_0.phases, l_v866_0.selection, "<yaw modifier>"));
                                    l_v839_0.advanced = l_v866_0;
                                end;
                                v869 = nil;
                                v869 = function()
                                    -- upvalues: l_v839_0 (ref), l_v848_1 (ref), l_v866_0 (ref)
                                    local v885 = l_v839_0.mode:get();
                                    local v886 = v885 ~= "Disabled";
                                    local v887 = v885 == "Advanced";
                                    l_v848_1:visibility(v886);
                                    l_v839_0.offset:visibility(not v887);
                                    l_v866_0.add_phase:visibility(v887);
                                    l_v866_0.remove_phase:visibility(v887);
                                    l_v866_0.reset:visibility(v887);
                                    l_v866_0.export:visibility(v887);
                                    l_v866_0.import:visibility(v887);
                                    l_v866_0.selection:visibility(v887);
                                end;
                                l_v839_0.mode:set_callback(v869, true);
                                l_v818_0.yaw_modifier = l_v839_0;
                            end;
                            v848 = nil;
                            v848 = {
                                enabled = v565.antiaim("baby" .. v816, l_v836_0:switch("\239\131\154  Body Yaw" .. v815))
                            };
                            v866 = v848.enabled:create();
                            v848.s_phases = v565.antiaim("babyasp" .. v816, v866:slider("Phases" .. v815, 1, 5, 1)):visibility(false);
                            v848.add_phase = v866:button("+", function()
                                -- upvalues: v760 (ref), v848 (ref)
                                v760(v848);
                            end, true):tooltip("Add New Phase");
                            v848.remove_phase = v866:button("\239\135\184", function()
                                -- upvalues: v763 (ref), v848 (ref)
                                v763(v848);
                            end, true):tooltip("Remove Last Phase");
                            v848.reset = v866:button("\239\139\177", function()
                                -- upvalues: v766 (ref), v848 (ref)
                                v766(v848);
                            end, true):tooltip("Reset Selected Phase");
                            v848.export = v866:button("\239\149\174", nil, true):tooltip("Export Selected Phase");
                            v848.import = v866:button("\239\149\175 ", nil, true):tooltip("Import Selected Phase");
                            local v888 = nil;
                            v888 = v565.antiaim("baby advanced selection" .. v816, v866:list("\n phases" .. v815, "1"));
                            do
                                local l_v866_1, l_v888_0 = v866, v888;
                                v848.s_phases:set_callback(function(v891)
                                    -- upvalues: l_tostring_0 (ref), l_v888_0 (ref)
                                    local v892 = v891:get();
                                    local v893 = {};
                                    for v894 = 1, v892 do
                                        v893[v894] = l_tostring_0(v894);
                                    end;
                                    l_v888_0:update(v893);
                                end, true);
                                v848.selection = l_v888_0;
                                local v895 = nil;
                                v895 = {};
                                for v896 = 1, 5 do
                                    local v897 = l_rep_0(" ", v896) .. v815;
                                    local v898 = nil;
                                    v898 = {
                                        mode = v565.antiaim("baplm" .. v816 .. v896, l_v866_1:combo("\239\131\154  Mode" .. v897, "Static", "Jitter", "Jitter V2")), 
                                        avoid_overlap = v565.antiaim("bapa" .. v816 .. v896, l_v866_1:switch("\239\131\154  Avoid Overlap" .. v897)), 
                                        freestanding = v565.antiaim("bapf" .. v816 .. v896, l_v866_1:combo("\239\131\154  Freestanding" .. v897, "Off", "Peek Fake", "Peek Real", "Hybrid", "Jitter")), 
                                        time = v565.antiaim("bapt" .. v816 .. v896, l_v866_1:slider("\239\131\154  Time" .. v897, 1, 150, 5, 0.1, "s"))
                                    };
                                    local _ = nil;
                                    do
                                        local l_v896_0 = v896;
                                        do
                                            local l_v898_0 = v898;
                                            l_v888_0:set_callback(function()
                                                -- upvalues: l_v888_0 (ref), l_v896_0 (ref), l_v898_0 (ref)
                                                local v902 = l_v888_0:get() == l_v896_0;
                                                l_v898_0.mode:visibility(v902);
                                                l_v898_0.avoid_overlap:visibility(v902);
                                                l_v898_0.freestanding:visibility(v902);
                                                l_v898_0.time:visibility(v902);
                                            end, true);
                                            v895[l_v896_0] = l_v898_0;
                                        end;
                                    end;
                                end;
                                v848.phases = v895;
                                v848.export:set_callback(v794(v848.phases, v848.selection, "<body_yaw>"));
                                v848.import:set_callback(v800(v848.phases, v848.selection, "<body_yaw>"));
                                local v903 = nil;
                                v903 = function()
                                    -- upvalues: v848 (ref), l_v866_1 (ref)
                                    local v904 = v848.enabled:get();
                                    l_v866_1:visibility(v904);
                                end;
                                v848.enabled:set_callback(v903, true);
                                l_v818_0.body_yaw = v848;
                            end;
                            v866 = nil;
                            v866 = {
                                enabled = v565.antiaim("bad" .. v816, l_v836_0:switch("\239\131\154  Defensive AA" .. v815))
                            };
                            v888 = v866.enabled:create();
                            local v905 = nil;
                            v905 = {
                                mode = v565.antiaim("badpm" .. v816, v888:combo("\239\131\154  Pitch" .. v815, "Static", "Jitter", "Random", "Fluctuate")), 
                                offset = v565.antiaim("badpo" .. v816, v888:slider("\239\131\154  Offset" .. v815, -89, 89, 89, 1, "\194\176")), 
                                offset_1 = v565.antiaim("badpoo1" .. v816, v888:slider("\239\131\154  Offset 1" .. v815, -89, 89, 89, 1, "\194\176")), 
                                offset_2 = v565.antiaim("badpoo2" .. v816, v888:slider("\239\131\154  Offset 2" .. v815, -89, 89, 89, 1, "\194\176"))
                            };
                            v866.pitch = v905;
                            local v906 = nil;
                            v906 = {
                                mode = v565.antiaim("badymm" .. v816, v888:combo("\239\131\154  Yaw Modifier" .. v815, "Default", "Spin", "Anti Bruteforce", "Side Based", "Advanced")), 
                                offset = v565.antiaim("badymo" .. v816, v888:slider("\239\131\154  Offset" .. v815 .. v815, -360, 360, 0, 1, "\194\176")), 
                                speed = v565.antiaim("badyms" .. v816, v888:slider("\239\131\154  Speed" .. v815, 1, 100, 50, 1, "%")), 
                                anti_bruteforce_mode = v565.antiaim("badymab" .. v816, v888:combo("\239\131\154  Mode" .. v815, "v1", "v2")), 
                                anti_bruteforce_side_mode = v565.antiaim("badymabm" .. v816, v888:combo("\239\131\154  Side Mode" .. v815, "Default", "Crosshair")), 
                                anti_bruteforce_randomize = v565.antiaim("badymabr" .. v816, v888:slider("\239\131\154  Randomize" .. v815, 2, 20, 2, 1, function(v907)
                                    if v907 == 2 then
                                        return "Off";
                                    else
                                        return v907 .. "t";
                                    end;
                                end)), 
                                offset_1 = v565.antiaim("badymoo1" .. v816, v888:slider("\239\131\154  Offset 1" .. v815 .. v815, -180, 180, 0, 1, "\194\176")), 
                                offset_2 = v565.antiaim("badymoo2" .. v816, v888:slider("\239\131\154  Offset 2" .. v815 .. v815, -180, 180, 0, 1, "\194\176"))
                            };
                            v866.yaw_modifier = v906;
                            local v908 = nil;
                            v908 = {
                                s_phases = v565.antiaim("badymasp" .. v816, v888:slider("Phases" .. v815, 1, 5, 1)):visibility(false)
                            };
                            do
                                local l_v888_1, l_v905_0, l_v906_0, l_v908_0 = v888, v905, v906, v908;
                                l_v908_0.add_phase = l_v888_1:button("+", function()
                                    -- upvalues: v760 (ref), l_v908_0 (ref)
                                    v760(l_v908_0);
                                end, true):tooltip("Add New Phase");
                                l_v908_0.remove_phase = l_v888_1:button("\239\135\184", function()
                                    -- upvalues: v763 (ref), l_v908_0 (ref)
                                    v763(l_v908_0);
                                end, true):tooltip("Remove Last Phase");
                                l_v908_0.reset = l_v888_1:button("\239\139\177", function()
                                    -- upvalues: v766 (ref), l_v908_0 (ref)
                                    v766(l_v908_0);
                                end, true):tooltip("Reset Selected Phase");
                                l_v908_0.export = l_v888_1:button("\239\149\174", nil, true):tooltip("Export Selected Phase");
                                l_v908_0.import = l_v888_1:button("\239\149\175 ", nil, true):tooltip("Import Selected Phase");
                                local v913 = nil;
                                v913 = v565.antiaim("badymas" .. v816, l_v888_1:list("\n phases" .. v815, "1"));
                                do
                                    local l_v913_0 = v913;
                                    l_v908_0.s_phases:set_callback(function(v915)
                                        -- upvalues: l_tostring_0 (ref), l_v913_0 (ref)
                                        local v916 = v915:get();
                                        local v917 = {};
                                        for v918 = 1, v916 do
                                            v917[v918] = l_tostring_0(v918);
                                        end;
                                        l_v913_0:update(v917);
                                    end, true);
                                    l_v908_0.selection = l_v913_0;
                                    local v919 = nil;
                                    v919 = {};
                                    for v920 = 1, 5 do
                                        local v921 = l_rep_0(" ", v920) .. v815;
                                        local v922 = nil;
                                        v922 = {
                                            mode = v565.antiaim("badymam" .. v816 .. v920, l_v888_1:combo("\239\131\154  Yaw Modifier" .. v921, "Default", "Spin", "Anti Bruteforce", "Side Based")), 
                                            offset = v565.antiaim("badymao" .. v816 .. v920, l_v888_1:slider("\239\131\154  Offset" .. v921 .. v921, -360, 360, 0, 1, "\194\176")), 
                                            speed = v565.antiaim("pbadymas" .. v816 .. v920, l_v888_1:slider("\239\131\154  Speed" .. v921, 1, 100, 50, 1, "%")), 
                                            anti_bruteforce_mode = v565.antiaim("pbadymab" .. v816 .. v920, l_v888_1:combo("\239\131\154  Mode" .. v921 .. v921, "v1", "v2")), 
                                            anti_bruteforce_side_mode = v565.antiaim("pbadymabm" .. v816 .. v920, l_v888_1:combo("\239\131\154  Side Mode" .. v921 .. v921, "Default", "Crosshair")), 
                                            anti_bruteforce_randomize = v565.antiaim("pbadymabr" .. v816 .. v920, l_v888_1:slider("\239\131\154  Randomize" .. v921 .. v921, 2, 20, 2, 1, function(v923)
                                                if v923 == 2 then
                                                    return "Off";
                                                else
                                                    return v923 .. "t";
                                                end;
                                            end)), 
                                            offset_1 = v565.antiaim("badymo1" .. v816 .. v920, l_v888_1:slider("\239\131\154  Offset 1" .. v921 .. v921 .. v921, -180, 180, 0, 1, "\194\176")), 
                                            offset_2 = v565.antiaim("badymo2" .. v816 .. v920, l_v888_1:slider("\239\131\154  Offset 2" .. v921 .. v921 .. v921, -180, 180, 0, 1, "\194\176")), 
                                            time = v565.antiaim("badymat" .. v816 .. v920, l_v888_1:slider("\239\131\154  Time" .. v921, 1, 150, 5, 0.1, "s"))
                                        };
                                        local v924 = nil;
                                        do
                                            local l_v920_0 = v920;
                                            do
                                                local l_v922_0 = v922;
                                                v924 = function()
                                                    -- upvalues: l_v913_0 (ref), l_v920_0 (ref), l_v906_0 (ref), l_v922_0 (ref)
                                                    local v927 = l_v913_0:get() == l_v920_0;
                                                    local v928 = l_v906_0.mode:get() == "Advanced";
                                                    local v929 = l_v922_0.mode:get();
                                                    local v930 = v929 == "Spin";
                                                    local v931 = v929 == "Anti Bruteforce";
                                                    local v932 = v929 == "Side Based";
                                                    l_v922_0.mode:visibility(v927 and v928);
                                                    l_v922_0.offset:visibility(v927 and v928 and v930);
                                                    l_v922_0.speed:visibility(v927 and v928 and v930);
                                                    l_v922_0.anti_bruteforce_mode:visibility(v927 and v928 and v931);
                                                    l_v922_0.anti_bruteforce_side_mode:visibility(v927 and v928 and v931);
                                                    l_v922_0.anti_bruteforce_randomize:visibility(v927 and v928 and v931);
                                                    l_v922_0.offset_1:visibility(v932);
                                                    l_v922_0.offset_2:visibility(v932);
                                                    l_v922_0.time:visibility(v927 and v928);
                                                end;
                                                l_v913_0:set_callback(v924, true);
                                                l_v906_0.mode:set_callback(v924, true);
                                                l_v922_0.mode:set_callback(v924, true);
                                                v919[l_v920_0] = l_v922_0;
                                            end;
                                        end;
                                    end;
                                    l_v908_0.phases = v919;
                                    l_v908_0.export:set_callback(v794(l_v908_0.phases, l_v908_0.selection, "<defensive>"));
                                    l_v908_0.import:set_callback(v800(l_v908_0.phases, l_v908_0.selection, "<defensive>"));
                                    v866.yaw_modifier.advanced = l_v908_0;
                                end;
                                v866.delay_time = v565.antiaim("badd" .. v816, l_v888_1:slider("\239\131\154  Delay Time" .. v815, 0, 50, 0, 0.1, function(v933)
                                    if v933 == 0 then
                                        return "Off";
                                    else
                                        return v933 * 0.1 .. "s";
                                    end;
                                end));
                                v913 = nil;
                                v913 = function()
                                    -- upvalues: v866 (ref), l_v905_0 (ref), l_v888_1 (ref), l_v906_0 (ref), l_v908_0 (ref)
                                    local v934 = v866.enabled:get();
                                    local v935 = l_v905_0.mode:get() == "Static";
                                    l_v888_1:visibility(v934);
                                    l_v905_0.offset:visibility(v935);
                                    l_v905_0.offset_1:visibility(not v935);
                                    l_v905_0.offset_2:visibility(not v935);
                                    local v936 = l_v906_0.mode:get();
                                    local v937 = v936 == "Spin";
                                    local v938 = v936 == "Anti Bruteforce";
                                    local v939 = v936 == "Side Based";
                                    local v940 = v936 == "Advanced";
                                    l_v906_0.offset:visibility(v937);
                                    l_v906_0.speed:visibility(v937);
                                    l_v906_0.anti_bruteforce_mode:visibility(v938);
                                    l_v906_0.anti_bruteforce_side_mode:visibility(v938);
                                    l_v906_0.anti_bruteforce_randomize:visibility(v938);
                                    l_v906_0.offset_1:visibility(v939);
                                    l_v906_0.offset_2:visibility(v939);
                                    l_v908_0.add_phase:visibility(v940);
                                    l_v908_0.remove_phase:visibility(v940);
                                    l_v908_0.reset:visibility(v940);
                                    l_v908_0.export:visibility(v940);
                                    l_v908_0.import:visibility(v940);
                                    l_v908_0.selection:visibility(v940);
                                end;
                                v866.enabled:set_callback(v913, true);
                                l_v905_0.mode:set_callback(v913, true);
                                l_v906_0.mode:set_callback(v913, true);
                                l_v818_0.defensive = v866;
                            end;
                            v888 = nil;
                            l_v818_0.force_defensive = v565.antiaim("bafd" .. v816, l_v836_0:selectable("\239\131\154  Force Defensive" .. v815, "Double Tap", "Hide Shots"));
                            v905 = nil;
                            v905 = function()
                                -- upvalues: v755 (ref), v0 (ref), v812 (ref), l_v817_0 (ref), l_v819_0 (ref), l_v820_0 (ref), l_v821_0 (ref), v2 (ref), l_l_advanced_0_0 (ref), l_v825_0 (ref), l_v836_0 (ref)
                                local v941 = v755:get() == (v0 == 3 and 3 or 2);
                                local v942 = v812:get() == l_v817_0;
                                local v943 = l_v817_0 == "Global" or l_v819_0:get();
                                local v944 = l_v820_0:get() == "Custom";
                                l_v820_0:visibility(v942 and v943);
                                if l_v821_0 ~= nil then
                                    l_v821_0:visibility(v942 and v943 and not v944);
                                end;
                                if v2 then
                                    l_l_advanced_0_0:visibility(v942 and v943 and v944);
                                    l_v825_0:visibility(v942 and v943 and v944);
                                end;
                                l_v836_0:visibility(v941 and v942 and v943 and v944);
                            end;
                            v908 = v755;
                            v755.set_callback(v908, v905, true);
                            v812:set_callback(v905, true);
                            l_v820_0:set_callback(v905, true);
                            if l_v817_0 ~= "Global" then
                                v908 = l_v819_0;
                                l_v819_0.set_callback(v908, v905, true);
                            end;
                            v906 = nil;
                            v906 = function()
                                -- upvalues: v812 (ref), l_v817_0 (ref), l_v819_0 (ref)
                                local v945 = v812:get() == l_v817_0;
                                if not (l_v817_0 == "Global") then
                                    l_v819_0:visibility(v945);
                                end;
                            end;
                            v812:set_callback(v906, true);
                            if l_v817_0 ~= "Global" then
                                local l_l_v819_0_0 = l_v819_0;
                                l_v819_0.set_callback(l_l_v819_0_0, v906, true);
                            end;
                        end;
                        v756[l_v817_0] = l_v818_0;
                    end;
                end;
            end;
            v566.advanced = v756;
        end;
        v757 = ui.create("\239\128\147", "\239\128\147  configurations", 1);
        v574:set_callback(function(v947)
            -- upvalues: v757 (ref)
            v757:visibility(v947:get() == 3);
        end, true);
        v757:label("   \aAFAF62FF\239\129\177  Double-Click to Load");
        local v948 = v757:label("info text");
        v948:visibility(false);
        local v949 = v757:list("\n default antiatim configurations", "");
        local v950 = v757:list("\n antiatim configurations", "");
        local v951 = v757:input("\n input");
        v951:set("");
        local v952 = v757:button("\a{Link Active}\238\134\131", nil, true);
        v952:tooltip("Save");
        local v953 = v757:button("\a{Link Active}\239\135\184", nil, true);
        v953:tooltip("Delete");
        local v954 = v757:button("last update date", nil, true);
        v954:tooltip("Last Update Date");
        local v955 = v757:button("\a{Link Active}\239\149\174", nil, true);
        v955:tooltip("Export");
        local v956 = v757:button("\a{Link Active}\239\149\175", nil, true);
        v956:tooltip("Import");
        local function v963(v957, v958)
            -- upvalues: l_format_0 (ref)
            local v959 = v957 and "\aA0CB27FF" or "\aFF7575FF";
            local v960 = v957 and "[+] " or "[-] ";
            local v961 = l_format_0("%s%s%s", v959, v960, v958);
            local v962 = l_format_0("%s[outlaw]\aDEFAULT %s", v959, v958);
            print_dev(v961);
            print_raw(v962);
        end;
        local v964 = nil;
        v964 = function(v965, v966)
            -- upvalues: l_next_0 (ref)
            local v967 = {};
            for v968, v969 in l_next_0, v965 do
                local v970, v971 = v966(v968, v969);
                v967[v970] = v971;
            end;
            return v967;
        end;
        local v972 = db["outlaw::antiaim::configurations"] or {};
        v972.default = v972.default or {};
        v972.default[1] = {
            unixtime = 0, 
            name = "Author's Config", 
            username = "keqx", 
            config = {}
        };
        v972.default[2] = {
            unixtime = 0, 
            name = "Unmatched | League", 
            username = "keqx", 
            config = {}
        };
        v972.default[3] = nil;
        v972.default[4] = nil;
        do
            local l_v948_0, l_v949_0, l_v950_0, l_v951_0, l_v954_0, l_v963_0, l_v964_0, l_v972_0 = v948, v949, v950, v951, v954, v963, v964, v972;
            network.get("https://northon.dev/neverlose/melancholia/api/default_antiaim.txt", {}, function(v981)
                -- upvalues: l_pcall_0 (ref), v194 (ref), v196 (ref), l_v972_0 (ref)
                if v981 == nil or #v981 == 0 then
                    return;
                else
                    local v982, v983 = l_pcall_0(v194.decode, v981, v196);
                    if not v982 then
                        return;
                    else
                        local v984, v985 = l_pcall_0(msgpack.unpack, v983);
                        if not v984 then
                            return;
                        elseif not (v985.name and v985.config and v985.username and v985.unixtime) then
                            return;
                        else
                            l_v972_0.default[1].config = v985.config;
                            return;
                        end;
                    end;
                end;
            end);
            network.get("https://northon.dev/neverlose/melancholia/api/tournament.txt", {}, function(v986)
                -- upvalues: l_pcall_0 (ref), v194 (ref), v196 (ref), l_v972_0 (ref)
                if v986 == nil or #v986 == 0 then
                    return;
                else
                    local v987, v988 = l_pcall_0(v194.decode, v986, v196);
                    if not v987 then
                        return;
                    else
                        local v989, v990 = l_pcall_0(msgpack.unpack, v988);
                        if not v989 then
                            return;
                        elseif not (v990.name and v990.config and v990.username and v990.unixtime) then
                            return;
                        else
                            l_v972_0.default[2].config = v990.config;
                            return;
                        end;
                    end;
                end;
            end);
            local v991 = 0;
            local v992 = nil;
            local v993 = nil;
            local v994 = nil;
            local function v995()
                -- upvalues: l_v948_0 (ref)
                l_v948_0:visibility(false);
            end;
            local function v998(v996)
                -- upvalues: l_globals_0 (ref), v991 (ref), l_v948_0 (ref), l_execute_after_0 (ref), v995 (ref), v565 (ref), v993 (ref), v994 (ref)
                if l_globals_0.realtime - v991 <= 5 then
                    l_v948_0:name("   \a{Link Active}\239\129\177\aDEFAULT Load no more than 5 seconds");
                    l_v948_0:visibility(true);
                    l_execute_after_0(3, v995);
                else
                    v565.antiaim(v996.config);
                    l_v948_0:name("   \a{Link Active}\239\128\140\aDEFAULT  Loaded: " .. v996.name);
                    l_v948_0:visibility(true);
                    l_execute_after_0(3, v995);
                    local v997 = 0;
                    v994 = 0;
                    v993 = v997;
                    v991 = l_globals_0.realtime;
                end;
            end;
            l_v950_0:set_callback(function()
                -- upvalues: l_v950_0 (ref), l_v972_0 (ref), l_v954_0 (ref), l_get_date_0 (ref), l_v951_0 (ref), v994 (ref), v992 (ref), v993 (ref), v998 (ref)
                local v999 = l_v950_0:get();
                local v1000 = l_v972_0[v999];
                if v1000 == nil then
                    l_v954_0:visibility(false);
                    return;
                else
                    local v1001 = l_get_date_0("%d.%m %H:%M", v1000.unixtime);
                    l_v954_0:name("\a{Link Active}\238\145\178 \aDEFAULT" .. v1001);
                    l_v954_0:visibility(true);
                    local l_name_0 = v1000.name;
                    l_v951_0:set(l_name_0);
                    local v1003 = l_get_date_0("%d.%m %H:%M", v1000.unixtime);
                    l_v954_0:name("\a{Link Active}\238\145\178 \aDEFAULT" .. v1003);
                    l_v954_0:visibility(true);
                    v994 = 0;
                    if v992 ~= v999 then
                        v993 = 0;
                    end;
                    v992 = v999;
                    v993 = v993 + 1;
                    if v993 >= 2 then
                        v998(v1000);
                    end;
                    return;
                end;
            end, true);
            v993 = 0;
            l_v949_0:set_callback(function()
                -- upvalues: l_v949_0 (ref), l_v972_0 (ref), l_v954_0 (ref), l_v951_0 (ref), v993 (ref), v992 (ref), v994 (ref), v998 (ref)
                local v1004 = l_v949_0:get();
                local v1005 = l_v972_0.default[v1004];
                if v1005 == nil then
                    l_v954_0:visibility(false);
                    return;
                else
                    local l_name_1 = v1005.name;
                    l_v951_0:set(l_name_1);
                    v993 = 0;
                    if v992 ~= v1004 then
                        v994 = 0;
                    end;
                    v992 = v1004;
                    v994 = v994 + 1;
                    if v994 >= 2 then
                        v998(v1005);
                    end;
                    return;
                end;
            end, true);
            v994 = 0;
            local function v1013()
                -- upvalues: l_ipairs_0 (ref), l_v972_0 (ref), l_format_0 (ref), l_v954_0 (ref), l_v950_0 (ref), l_v949_0 (ref)
                local v1007 = {};
                for v1008, v1009 in l_ipairs_0(l_v972_0) do
                    v1007[v1008] = l_format_0("%s (%s)", v1009.name, v1009.username);
                end;
                if #v1007 == 0 then
                    l_v954_0:visibility(false);
                    v1007[#v1007 + 1] = "\aFFFFFFAFThere's nothing.";
                end;
                l_v950_0:update(v1007);
                local v1010 = {};
                for v1011, v1012 in l_ipairs_0(l_v972_0.default) do
                    v1010[v1011] = l_format_0("%s (%s)", v1012.name, v1012.username);
                end;
                if #v1010 == 0 then
                    l_v954_0:visibility(false);
                    v1010[#v1010 + 1] = "\aFFFFFFAFThere's nothing.";
                end;
                l_v949_0:update(v1010);
            end;
            v1013();
            v952:set_callback(function()
                -- upvalues: l_v951_0 (ref), l_v964_0 (ref), l_v972_0 (ref), v565 (ref), l_get_unixtime_0 (ref), v1 (ref), l_get_date_0 (ref), l_v954_0 (ref), l_v948_0 (ref), l_execute_after_0 (ref), v995 (ref), v1013 (ref)
                local v1014 = l_v951_0:get();
                local v1017 = l_v964_0(l_v972_0, function(v1015, v1016)
                    if v1015 ~= "default" then
                        return v1016.name, v1015;
                    else
                        return "dhsauvdhv123yu1fe67asyudcvasdtyas           ", 999;
                    end;
                end);
                local v1018 = v565.antiaim();
                local v1019 = l_get_unixtime_0();
                local v1020 = {
                    name = v1014, 
                    config = v1018, 
                    username = v1, 
                    unixtime = v1019
                };
                local v1021 = v1017[v1014];
                l_v972_0[v1021 or #l_v972_0 + 1] = v1020;
                local v1022 = l_get_date_0("%d.%m %H:%M", v1019);
                l_v954_0:name("\a{Link Active}\238\145\178 \aDEFAULT" .. v1022);
                l_v954_0:visibility(true);
                l_v948_0:name("   \a{Link Active}\238\134\131\aDEFAULT" .. (v1021 and "  Saved: " or "  Created: ") .. v1020.name);
                l_v948_0:visibility(true);
                l_execute_after_0(3, v995);
                v1013();
            end);
            v953:set_callback(function()
                -- upvalues: l_v950_0 (ref), l_v972_0 (ref), l_remove_0 (ref), l_get_date_0 (ref), l_v954_0 (ref), l_v948_0 (ref), l_execute_after_0 (ref), v995 (ref), v1013 (ref)
                local v1023 = l_v950_0:get();
                local v1024 = l_v972_0[v1023];
                if v1024 == nil then
                    return;
                else
                    l_remove_0(l_v972_0, v1023);
                    local v1025 = l_get_date_0("%d.%m %H:%M", v1024.unixtime);
                    l_v954_0:name("\a{Link Active}\238\145\178 \aDEFAULT" .. v1025);
                    l_v954_0:visibility(true);
                    l_v948_0:name("   \a{Link Active}\239\149\175\aDEFAULT  Deleted: " .. v1024.name);
                    l_v948_0:visibility(true);
                    l_execute_after_0(3, v995);
                    v1013();
                    return;
                end;
            end);
            v955:set_callback(function()
                -- upvalues: l_v950_0 (ref), l_v972_0 (ref), l_v948_0 (ref), l_execute_after_0 (ref), v995 (ref), v194 (ref), v195 (ref), v128 (ref)
                local v1026 = l_v972_0[l_v950_0:get()];
                if v1026 == nil then
                    return;
                else
                    l_v948_0:name("   \a{Link Active}\239\149\174\aDEFAULT  Exported: " .. v1026.name);
                    l_v948_0:visibility(true);
                    l_execute_after_0(3, v995);
                    v1026 = msgpack.pack(v1026);
                    v1026 = v194.encode(v1026, v195) .. "_outlaw";
                    v128(v1026);
                    return;
                end;
            end);
            v956:set_callback(function()
                -- upvalues: v128 (ref), l_pcall_0 (ref), v194 (ref), v196 (ref), l_v963_0 (ref), l_get_date_0 (ref), l_v954_0 (ref), l_v948_0 (ref), l_execute_after_0 (ref), v995 (ref), v565 (ref), l_v972_0 (ref), v1013 (ref)
                local v1027 = v128();
                local v1028, v1029 = l_pcall_0(v194.decode, v1027, v196);
                if not v1028 then
                    return l_v963_0(false, "failed to import config");
                else
                    local v1030, v1031 = l_pcall_0(msgpack.unpack, v1029);
                    if not v1030 then
                        return l_v963_0(false, "failed to import config");
                    elseif not (v1031.name and v1031.config and v1031.username and v1031.unixtime) then
                        return l_v963_0(false, "failed to import config (not antiaim config)");
                    else
                        local v1032 = l_get_date_0("%d.%m %H:%M", v1031.unixtime);
                        l_v954_0:name("\a{Link Active}\238\145\178 \aDEFAULT" .. v1032);
                        l_v954_0:visibility(true);
                        l_v948_0:name("   \a{Link Active}\239\149\175\aDEFAULT  Imported: " .. v1031.name);
                        l_v948_0:visibility(true);
                        l_execute_after_0(3, v995);
                        v565.antiaim(v1031.config);
                        l_v972_0[#l_v972_0 + 1] = v1031;
                        v1013();
                        l_v963_0(true, "config has been successfully imported");
                        return;
                    end;
                end;
            end);
            local function v1033()
                -- upvalues: l_v972_0 (ref)
                db["outlaw::antiaim::configurations"] = l_v972_0;
            end;
            l_events_0.shutdown(v1033);
        end;
        v948 = ui.create("\238\140\163", "\239\132\164 Tab Selection", 1):list("\n tab selection", "\239\153\137  Visuals", "\239\139\155  Misc");
        v949 = ui.create("\238\140\163", "\239\153\137  Visuals", 2);
        v948:set_callback(function(v1034)
            -- upvalues: v949 (ref)
            v949:visibility(v1034:get() == 1);
        end, true);
        v950 = nil;
        v950 = v949:label("\239\135\158  Damage Visuals"):create();
        v951 = nil;
        v951 = {
            enabled = v565.global("di", v950:switch("Damage Indicator")), 
            font = v565.global("dif", v950:combo("\239\131\154  Font", "Default", "Pixel"))
        };
        v951.color = v565.global("dic", v951.font:color_picker());
        v951.style = v565.global("dis", v950:list("\n style", "Default", "Kibit"));
        v951.show_on_damage = v565.global("disod", v950:switch("\239\131\154  Show on Damage"));
        do
            local l_v951_1, l_v952_0 = v951, v952;
            l_v952_0 = function()
                -- upvalues: l_v951_1 (ref)
                local v1037 = l_v951_1.enabled:get();
                local v1038 = l_v951_1.style:get() == 1;
                l_v951_1.font:visibility(v1037);
                l_v951_1.color:visibility(v1037);
                l_v951_1.style:visibility(v1037);
                l_v951_1.show_on_damage:visibility(v1037 and v1038);
            end;
            l_v951_1.enabled:set_callback(l_v952_0, true);
            l_v951_1.style:set_callback(l_v952_0, true);
            v566.damage_indicator = l_v951_1;
            l_v952_0 = nil;
            l_v952_0 = {
                enabled = v565.global("dm", v950:switch("Damage Marker")), 
                font = v565.global("dmf", v950:combo("\239\131\154  Font ", "Default", "Pixel", "Bold"))
            };
            l_v952_0.color = v565.global("dmc", l_v952_0.enabled:color_picker());
            l_v952_0.animation = v565.global("dma", v950:switch("\239\131\154  Animation"));
            l_v952_0.enabled:set_callback(function(v1039)
                -- upvalues: l_v952_0 (ref)
                local v1040 = v1039:get();
                l_v952_0.font:visibility(v1040);
                l_v952_0.color:visibility(v1040);
                l_v952_0.animation:visibility(v1040);
            end, true);
            v566.damage_marker = l_v952_0;
        end;
        v951 = nil;
        v951 = {
            enabled = v565.global("ci", v949:switch("\239\129\155  Crosshair Indicators"))
        };
        v952 = v951.enabled:create();
        v951.mode = v565.global("cim", v952:list("Color", "Old", "New"));
        v951.selection = v565.global("cis", v952:selectable("\n selection", "Version", "Side", "Binds"));
        v951.color = v565.global("cic", v951.mode:color_picker(l_color_0(218, 218, 255)));
        do
            local l_v952_1 = v952;
            v951.enabled:set_callback(function(v1042)
                -- upvalues: l_v952_1 (ref)
                l_v952_1:visibility(v1042:get());
            end, true);
            v951.mode:set_callback(function(v1043)
                -- upvalues: v951 (ref)
                v951.selection:visibility(v1043:get() == 1);
            end, true);
            v566.crosshair_indicators = v951;
        end;
        v952 = nil;
        v952 = {
            enabled = v565.global("ma", v949:switch("\239\141\164  Manual Arrows"))
        };
        v953 = v952.enabled:create();
        v952.options = v565.global("mao", v953:selectable("\n options", "Show Active Only", "Hide in Scope"));
        v954 = {
            [1] = "TS", 
            [2] = "New"
        };
        do
            local l_v953_0, l_v954_1 = v953, v954;
            v952.type = v565.global("mat", l_v953_0:slider("Type", 1, 2, 1, 1, function(v1046)
                -- upvalues: l_v954_1 (ref)
                return l_v954_1[v1046];
            end));
            v952.color = v565.global("mac", v952.options:color_picker(l_color_0(175, 175, 255)));
            v952.enabled:set_callback(function(v1047)
                -- upvalues: l_v953_0 (ref)
                l_v953_0:visibility(v1047:get());
            end, true);
            v566.manual_arrows = v952;
        end;
        v953 = nil;
        v566.disablers = v565.global("d", v949:selectable("\239\139\147   Disablers", "Arms in 3-rd", "Weapon in 3-rd", "Teammate Rendering", "Blood"));
        v954 = ui.create("\238\140\163", "\239\160\157  Gentlemen Indicators", 2);
        v948:set_callback(function(v1048)
            -- upvalues: v954 (ref)
            v954:visibility(v1048:get() == 1);
        end, true);
        v955 = nil;
        v566.gamesense_indicators = v565.global("gi", v954:selectable("\n gentlemen indicators", "DT", "OSAA", "Bomb Info", "FS", "BODY", "SAFE", "DUCK", "PING", "SLOW", "DAMAGE", "HITCHANCE", "DA"));
        v956 = ui.create("\238\140\163", "\n visuals 3", 2);
        v948:set_callback(function(v1049)
            -- upvalues: v956 (ref)
            v956:visibility(v1049:get() == 1);
        end, true);
        v963 = nil;
        v963 = {
            enabled = v565.global("sa", v956:switch("\239\129\190  Skeet Arrows"))
        };
        v964 = v963.enabled:create();
        v963.radius = v565.global("sar", v964:slider("Radius", 1, 100, 50));
        v963.size = v565.global("sas", v964:slider("Size", 5, 20));
        v963.color = v565.global("sac", v964:color_picker("Color"));
        do
            local l_v964_1 = v964;
            v963.enabled:set_callback(function(v1051)
                -- upvalues: l_v964_1 (ref)
                l_v964_1:visibility(v1051:get());
            end, true);
            v566.skeet_arrows = v963;
        end;
        v964 = nil;
        v964 = {
            enabled = v565.global("cso", v956:switch("\239\162\144  Custom Scope Overlay"))
        };
        v972 = v964.enabled:create();
        v964.line = v565.global("csol", v972:slider("\239\131\154  Line", 0, 100, 30));
        v964.gap = v565.global("csog", v972:slider("\239\131\154  Gap", 0, 100, 5));
        v964.lines = v565.global("csoli", v972:selectable("\239\131\154  Lines", "Left", "Top", "Right", "Bottom"));
        v964.color = v565.global("csoc", v964.lines:color_picker({
            Static = {
                l_color_0(169, 175, 208)
            }, 
            Gradient = {
                l_color_0(36, 255), 
                l_color_0(169, 175, 208)
            }
        }));
        v964.animation = v565.global("csoa", v972:slider("\239\131\154  Animation", 0, 10, 5, nil, function(v1052)
            -- upvalues: l_tostring_0 (ref)
            return v1052 == 0 and "Off" or l_tostring_0(v1052 * 0.1);
        end));
        do
            local l_v972_1 = v972;
            v964.enabled:set_callback(function(v1054)
                -- upvalues: l_v972_1 (ref)
                l_v972_1:visibility(v1054:get());
            end, true);
            v964.lines:set_callback(function(v1055)
                if #v1055:get() ~= 0 then
                    return;
                else
                    v1055:set({
                        [1] = "Left", 
                        [2] = "Top", 
                        [3] = "Right", 
                        [4] = "Bottom"
                    });
                    return;
                end;
            end, true);
            v566.custom_scope_overlay = v964;
        end;
        v972 = ui.create("\238\140\163", "\n visuals 4", 2);
        v948:set_callback(function(v1056)
            -- upvalues: v972 (ref)
            v972:visibility(v1056:get() == 1);
        end, true);
        local v1057 = nil;
        v1057 = {
            enabled = v565.global("wos", v972:switch("\238\136\155   Wireframe On Shot"))
        };
        local v1058 = v1057.enabled:create();
        v1057.duration = v565.global("wosd", v1058:slider("\n Duration", 1, 10, 1, 1, "s"));
        v1057.color = v565.global("wosc", v1057.duration:color_picker());
        do
            local l_v1058_0 = v1058;
            v1057.enabled:set_callback(function(v1060)
                -- upvalues: l_v1058_0 (ref)
                l_v1058_0:visibility(v1060:get());
            end, true);
            v566.wireframe_on_shot = v1057;
        end;
        v1058 = nil;
        v1058 = {
            enabled = v565.global("zw", v972:switch("\238\134\157  Zeus Warning"))
        };
        v1058.color = v565.global("zwc", v1058.enabled:color_picker());
        v1058.enabled:set_callback(function(v1061)
            -- upvalues: v1058 (ref)
            v1058.color:visibility(v1061:get());
        end, true);
        v566.zeus_warning = v1058;
        local v1062 = nil;
        v1062 = {
            enabled = v565.global("gr", v972:switch("\238\132\133  Grenade Radius"))
        };
        local v1063 = v1062.enabled:create();
        v1062.render_mode = v565.global("grrm", v1063:list("\n Render Mode", "Fill", "Outline"));
        local v1064 = nil;
        v1064 = {
            enabled = v565.global("grf", v1063:switch("Fire"))
        };
        v1064.color = v565.global("grfc", v1064.enabled:color_picker({
            Enemy = {
                l_color_0(255, 0, 0)
            }, 
            Friendly = {
                l_color_0(100, 100, 255)
            }
        }));
        v1062.fire = v1064;
        local v1065 = nil;
        v1065 = {
            enabled = v565.global("grs", v1063:switch("Smoke"))
        };
        v1065.color = v565.global("grsc", v1065.enabled:color_picker());
        v1062.smoke = v1065;
        do
            local l_v1063_0 = v1063;
            v1062.enabled:set_callback(function(v1067)
                -- upvalues: l_v1063_0 (ref)
                l_v1063_0:visibility(v1067:get());
            end, true);
            v566.grenade_radius = v1062;
        end;
        v1063 = ui.create("\238\140\163", "\n outlaw ui", 1);
        v948:set_callback(function(v1068)
            -- upvalues: v1063 (ref)
            v1063:visibility(v1068:get() == 1);
        end, true);
        v1064 = nil;
        v1064 = {
            double_click_text = v1063:label("   \aAFAF62FF\239\129\177  Double-Click for Enable")
        };
        v1065 = ui.create("\238\140\163", "\239\144\142  Outlaw UI", 1);
        do
            local l_v1065_0 = v1065;
            v948:set_callback(function(v1070)
                -- upvalues: l_v1065_0 (ref)
                l_v1065_0:visibility(v1070:get() == 1);
            end, true);
            local v1071 = {
                [1] = "Disabled", 
                [2] = "\239\162\162  Old", 
                [3] = "\239\128\133  Modern"
            };
            v1064.style = v565.global("mus", l_v1065_0:slider("\n style", 1, 3, 1, 1, function(v1072)
                -- upvalues: v1071 (ref)
                return v1071[v1072];
            end));
            local v1073 = ui.find("Miscellaneous", "Main", "Other", "Windows");
            local function v1075()
                -- upvalues: v1073 (ref), v1064 (ref)
                v1073:override();
                if v1064.style:get() == 1 then
                    return;
                else
                    local v1074 = {};
                    if v1073:get("Watermark") and not v1064["   Watermark"]:get() then
                        v1074[#v1074 + 1] = "Watermark";
                    end;
                    if v1073:get("Hotkeys") and not v1064["  Keybinds"]:get() then
                        v1074[#v1074 + 1] = "Hotkeys";
                    end;
                    if v1073:get("Spectators") and not v1064["  Spectators"]:get() then
                        v1074[#v1074 + 1] = "Spectators";
                    end;
                    if v1073:get("Bomb Info") then
                        v1074[#v1074 + 1] = "Bomb Info";
                    end;
                    v1073:override(v1074);
                    return;
                end;
            end;
            local v1076 = {
                [1] = {
                    [1] = "\238\128\162", 
                    [2] = "   Watermark"
                }, 
                [2] = {
                    [1] = "\239\146\169", 
                    [2] = "  Keybinds"
                }, 
                [3] = {
                    [1] = "\239\131\128", 
                    [2] = "  Spectators"
                }
            };
            local function v1083()
                -- upvalues: v1064 (ref), l_ipairs_0 (ref), v1076 (ref)
                if v1064.double_click_selection == nil then
                    return;
                else
                    local v1077 = {};
                    for v1078, v1079 in l_ipairs_0(v1076) do
                        local v1080 = v1079[1];
                        local v1081 = v1079[2];
                        local v1082 = v1064[v1081];
                        v1077[v1078] = (v1082 ~= nil and v1082:get() and "\aFFFFFFFF" or "\a808080FF") .. v1080 .. v1081;
                    end;
                    v1064.double_click_selection:update(v1077);
                    return;
                end;
            end;
            for _, v1085 in l_ipairs_0(v1076) do
                local v1086 = v1085[2];
                v1064[v1086] = v565.global("m" .. v1086, l_v1065_0:switch(v1086));
                v1064[v1086]:set_callback(v1083, true);
                v1064[v1086]:set_callback(v1075);
                v1064[v1086]:visibility(false);
            end;
            v1073:set_callback(v1075);
            local function v1090(v1087)
                -- upvalues: v1064 (ref), v1076 (ref), v1083 (ref)
                local v1088 = v1087:get();
                if v1064.index ~= v1088 then
                    v1064.clicks = 0;
                end;
                v1064.index = v1088;
                v1064.clicks = v1064.clicks + 1;
                if v1064.clicks > 1 then
                    local v1089 = v1064[v1076[v1088][2]];
                    v1089:set(not v1089:get());
                end;
                v1083();
            end;
            v1064.double_click_selection = l_v1065_0:list("\n melancholia ui", "");
            v1064.double_click_selection:set_callback(v1090, true);
            v1064.clicks = 0;
            v1064.style:set_callback(function(v1091)
                -- upvalues: v1064 (ref), v1075 (ref)
                v1064.double_click_selection:visibility(v1091:get() ~= 1);
                v1075();
            end, true);
            local v1092 = nil;
            v1092 = {};
            local v1093 = ui.create("\238\140\163", "\n watermark", 1);
            do
                local l_v1093_0 = v1093;
                local function v1099()
                    -- upvalues: v1064 (ref), v948 (ref), l_v1093_0 (ref)
                    local v1095 = v1064.style:get();
                    local v1096 = v948:get();
                    local v1097 = v1064.double_click_selection:get();
                    local v1098 = v1064["   Watermark"]:get();
                    l_v1093_0:visibility(v1095 ~= 1 and v1096 == 1 and v1098 and v1097 == 1);
                end;
                v1064.style:set_callback(v1099, true);
                v1064.double_click_selection:set_callback(v1099, true);
                v948:set_callback(v1099, true);
                v1064["   Watermark"]:set_callback(v1099, true);
                v1092.selection = v565.global("ws", l_v1093_0:selectable("\239\131\154  Selection", "Lua Name", "Username", "Ping", "FPS", "SV", "Time"));
                local v1100 = nil;
                local function v1103(v1101)
                    -- upvalues: v1092 (ref), v1100 (ref)
                    local v1102 = v1101:get();
                    if #v1102 == 0 then
                        v1092.selection:set(not v1100 and "Lua Name" or v1100[1]);
                    else
                        v1100 = v1102;
                    end;
                end;
                v1092.selection:set_callback(v1103, true);
                local v1104 = v1092.selection:create();
                v1092.color = v565.global("watermark color", v1104:color_picker("\239\131\154  Color", {
                    Static = {
                        l_color_0()
                    }, 
                    Gradient = {
                        l_color_0()
                    }, 
                    ["Animated Gradient"] = {
                        l_color_0()
                    }
                }));
                local v1105 = nil;
                v1105 = {
                    color = v565.global("wlnc", v1104:color_picker("\239\131\154  Lua Name", {
                        Default = {
                            l_color_0()
                        }, 
                        Custom = {
                            l_color_0(), 
                            l_color_0()
                        }
                    })), 
                    [1] = v565.global("wln1", v1104:input("\n lua name 1", "melanc")), 
                    [2] = v565.global("wln2", v1104:input("\n lua name 2", "holia.ws"))
                };
                local function v1108()
                    -- upvalues: v1092 (ref), v1105 (ref)
                    local v1106 = v1092.selection:get("Lua Name");
                    v1105.color:visibility(v1106);
                    local v1107 = v1105.color:get() == "Custom";
                    v1105[1]:visibility(v1106 and v1107);
                    v1105[2]:visibility(v1106 and v1107);
                end;
                v1105.color:set_callback(v1108, true);
                v1092.selection:set_callback(v1108, true);
                v1092.lua_name = v1105;
                v1092.username = v565.global("wu", l_v1093_0:combo("\239\131\154  Username", "Neverlose", "Steam", "Custom"));
                v1108 = v1092.username:create();
                v1092.custom_username = v565.global("wcu", v1108:input("\n username", ""));
                v1092.m_color = v565.global("wmc", l_v1093_0:color_picker("\239\131\154  Color"));
                local function v1110()
                    -- upvalues: v1064 (ref), v1092 (ref), v1108 (ref)
                    local v1109 = v1064.style:get();
                    v1092.selection:visibility(v1109 == 2);
                    v1092.username:visibility(v1109 == 2 and v1092.selection:get("Username") or v1109 == 3);
                    v1108:visibility(v1092.username:get() == "Custom");
                    v1092.m_color:visibility(v1109 == 3);
                end;
                v1064.style:set_callback(v1110, true);
                v1092.selection:set_callback(v1110, true);
                v1092.username:set_callback(v1110, true);
                v1064.watermark = v1092;
            end;
            v1093 = nil;
            v1093 = {};
            local v1111 = ui.create("\238\140\163", "\n keybinds", 1);
            do
                local l_v1111_0 = v1111;
                local function v1117()
                    -- upvalues: v1064 (ref), v948 (ref), l_v1111_0 (ref)
                    local v1113 = v1064.style:get();
                    local v1114 = v948:get();
                    local v1115 = v1064.double_click_selection:get();
                    local v1116 = v1064["  Keybinds"]:get();
                    l_v1111_0:visibility(v1113 ~= 1 and v1114 == 1 and v1116 and v1115 == 2);
                end;
                v1064.style:set_callback(v1117, true);
                v948:set_callback(v1117, true);
                v1064.double_click_selection:set_callback(v1117, true);
                v1064["  Keybinds"]:set_callback(v1117, true);
                v1093.min_width = v565.global("kmw", l_v1111_0:slider("\n Min Width", 90, 200, 120, 1, "px"));
                v1093.m_color = v565.global("kmc", v1093.min_width:color_picker({
                    Static = {
                        l_color_0()
                    }, 
                    Gradient = {
                        l_color_0()
                    }, 
                    ["Animated Gradient"] = {
                        l_color_0()
                    }
                }));
                v1093.mode = v565.global("km", l_v1111_0:combo("\239\131\154  Mode", "State", "State & Value"));
                v1093.m_color2 = v565.global("kmc2", v1093.mode:color_picker());
                v1064.style:set_callback(function(v1118)
                    -- upvalues: v1093 (ref)
                    local v1119 = v1118:get();
                    v1093.m_color:visibility(v1119 == 2);
                    v1093.m_color2:visibility(v1119 == 3);
                end, true);
                v1064.keybinds = v1093;
            end;
            v566.melancholia_ui = v1064;
        end;
        v1065 = ui.create("\238\140\163", "\n misc", 1);
        v948:set_callback(function(v1120)
            -- upvalues: v1065 (ref)
            v1065:visibility(v1120:get() == 2);
        end, true);
        local v1121 = nil;
        v1121 = {
            double_click_text = v1065:label("   \aAFAF62FF\239\129\177  Double-Click for Enable")
        };
        local v1122 = {
            [1] = {
                [1] = "\238\128\162", 
                [2] = "   Avoid Collisions"
            }, 
            [2] = {
                [1] = "\239\151\184", 
                [2] = "  Rare Weapon Animations"
            }, 
            [3] = {
                [1] = "\239\146\169", 
                [2] = "  Auto Unmute"
            }, 
            [4] = {
                [1] = "\238\148\185", 
                [2] = "  Fast Ladder Move"
            }, 
            [5] = {
                [1] = "\238\149\135", 
                [2] = "  No Fall Damage"
            }, 
            [6] = {
                [1] = "\239\135\160", 
                [2] = "    Shared Logo"
            }, 
            [7] = {
                [1] = "\238\138\158", 
                [2] = "   Taskbar Notification"
            }
        };
        do
            local l_v1122_0 = v1122;
            local function v1130()
                -- upvalues: v1121 (ref), l_ipairs_0 (ref), l_v1122_0 (ref)
                if v1121.item == nil then
                    return;
                else
                    local v1124 = {};
                    for v1125, v1126 in l_ipairs_0(l_v1122_0) do
                        local v1127 = v1126[1];
                        local v1128 = v1126[2];
                        local v1129 = v1121[v1128];
                        v1124[v1125] = (v1129 ~= nil and v1129:get() and "\aFFFFFFFF" or "\a808080FF") .. v1127 .. v1128;
                    end;
                    v1121.item:update(v1124);
                    return;
                end;
            end;
            for _, v1132 in l_ipairs_0(l_v1122_0) do
                local v1133 = v1132[2];
                v1121[v1133] = v565.global(v1133, v1065:switch(v1133));
                v1121[v1133]:set_callback(v1130, true);
                v1121[v1133]:visibility(false);
            end;
            local function v1137(v1134)
                -- upvalues: v1121 (ref), l_v1122_0 (ref), v1130 (ref)
                local v1135 = v1134:get();
                if v1121.index ~= v1135 then
                    v1121.clicks = 0;
                end;
                v1121.index = v1135;
                v1121.clicks = v1121.clicks + 1;
                if v1121.clicks > 1 then
                    local v1136 = v1121[l_v1122_0[v1135][2]];
                    v1136:set(not v1136:get());
                end;
                v1130();
            end;
            local v1138 = ui.create("\238\140\163", "\n misc 2", 1);
            v948:set_callback(function(v1139)
                -- upvalues: v1138 (ref)
                v1138:visibility(v1139:get() == 2);
            end, true);
            v1121.item = v1138:list("\n misc", "");
            v1121.item:set_callback(v1137, true);
            v1121.clicks = 0;
            v566.misc = v1121;
        end;
        v1122 = ui.create("\238\140\163", "\239\139\155  Others", 2);
        v948:set_callback(function(v1140)
            -- upvalues: v1122 (ref)
            v1122:visibility(v1140:get() == 2);
        end, true);
        local v1141 = nil;
        v1141 = {
            selection = v565.global("le", v1122:selectable("\239\130\174  Log Events", "\238\136\182   Console", "\239\142\144  On Screen", "\239\129\160   Center-Left", " \238\130\157   Upper-Left"))
        };
        local v1142 = v1141.selection:create();
        v1141.spread = v565.global("les", v1142:input("Spread", "spread"));
        v1141.correction = v565.global("lec", v1142:input("Correction", "correction"));
        v1141.misprediction = v565.global("lemi", v1142:input("Misprediction", "misprediction"));
        v1141["prediction error"] = v565.global("lepe", v1142:input("Prediction Error", "prediction error"));
        v1141["backtrack failure"] = v565.global("lebf", v1142:input("Backtrack Failure", "backtrack failure"));
        local v1143 = nil;
        v1143 = {
            enabled = v565.global("leh", v1142:switch("Hit"))
        };
        v1143.color = v565.global("lehc", v1143.enabled:color_picker(l_color_0(160, 203, 39)));
        v1141.hit = v1143;
        local v1144 = nil;
        v1144 = {
            enabled = v565.global("lem", v1142:switch("Miss"))
        };
        v1144.color = v565.global("lemc", v1144.enabled:color_picker(l_color_0(255, 117, 117)));
        v1141.miss = v1144;
        local v1145 = nil;
        v1145 = {
            enabled = v565.global("lek", v1142:switch("Knife"))
        };
        v1145.color = v565.global("lekc", v1145.enabled:color_picker(l_color_0(160, 203, 39)));
        v1141.knife = v1145;
        local v1146 = nil;
        v1146 = {
            enabled = v565.global("leg", v1142:switch("Grenade"))
        };
        v1146.color = v565.global("legc", v1146.enabled:color_picker(l_color_0(160, 203, 39)));
        v1141.grenade = v1146;
        local v1147 = nil;
        v1147 = {
            enabled = v565.global("lep", v1142:switch("Purchase"))
        };
        v1147.color = v565.global("lepc", v1147.enabled:color_picker(l_color_0(160, 203, 39)));
        v1141.purchases = v1147;
        local v1148 = nil;
        v1148 = v1142:button("\238\135\166  Push Test Logs", nil, true);
        local v1149 = {
            [1] = "spread", 
            [2] = "correction", 
            [3] = "misprediction", 
            [4] = "prediction error", 
            [5] = "backtrack failure"
        };
        do
            local l_v1149_0 = v1149;
            v1148:set_callback(function()
                -- upvalues: l_ipairs_0 (ref), l_v1149_0 (ref), v1141 (ref), l_format_0 (ref), l_gsub_0 (ref)
                for v1151, v1152 in l_ipairs_0(l_v1149_0) do
                    local v1153 = v1141[v1152]:get();
                    local v1154 = "\a" .. v1141.miss.color:get():to_hex();
                    local v1155 = l_format_0("{}[outlaw]{d} [%s] Missed shot in Player's {}head{d}(100)(90%%), due to {}%s{d} (b:30)", v1151, v1153);
                    local v1156 = l_gsub_0(l_gsub_0(v1155, "{}", v1154), "{d}", "\aDEFAULT");
                    print_raw(v1156);
                end;
                local v1157 = "\a" .. v1141.hit.color:get():to_hex();
                local v1158 = l_format_0("{}[outlaw]{d} [%s] Hit Player's {}head{d} for 101(130)(90%%), (0 remaining), (b:10)", #l_v1149_0 + 1);
                local v1159 = l_gsub_0(l_gsub_0(v1158, "{}", v1157), "{d}", "\aDEFAULT");
                print_raw(v1159);
            end);
        end;
        do
            local l_v1142_0, l_v1147_0, l_v1148_0 = v1142, v1147, v1148;
            v1141.selection:set_callback(function(v1163)
                -- upvalues: l_v1142_0 (ref), l_v1147_0 (ref), l_v1148_0 (ref)
                local v1164 = #v1163:get() ~= 0;
                l_v1142_0:visibility(v1164);
                local v1165 = v1163:get(1);
                l_v1147_0.enabled:visibility(v1165);
                local v1166 = v1163:get(1);
                l_v1148_0:visibility(v1166);
            end, true);
            v566.log_events = v1141;
        end;
        v1142 = nil;
        v1142 = {
            selection = v565.global("c", v1122:combo("\239\128\171   Clan Tag", " \239\128\141   Disabled", "\239\148\136   Default", "\239\128\133  Modern"))
        };
        v1143 = v1142.selection:create();
        v1142.disable_at_low_kd = v565.global("cdal", v1143:switch("Disable at Low K/D"));
        do
            local l_v1143_0 = v1143;
            v1142.selection:set_callback(function(v1168)
                -- upvalues: l_v1143_0 (ref), l_find_0 (ref)
                l_v1143_0:visibility(l_find_0(v1168:get(), "Disabled") == nil);
            end, true);
            v566.clantag = v1142;
        end;
        v1143 = nil;
        v1143 = {
            selection = v565.global("k", v1122:combo("\239\149\140   Killsay", " \239\128\141   Disabled", "\239\149\140   Trashtalk", " \239\133\147   Sponsor"))
        };
        v1144 = v1143.selection:create();
        v1143.delay = v565.global("kd", v1144:slider("Delay", 1, 10, 2, 1, "s"));
        do
            local l_v1144_0 = v1144;
            v1143.selection:set_callback(function(v1170)
                -- upvalues: l_v1144_0 (ref), l_find_0 (ref)
                l_v1144_0:visibility(l_find_0(v1170:get(), "Disabled") == nil);
            end, true);
            v566.killsay = v1143;
        end;
        v1144 = ui.create("\238\140\163", "\n others 2", 2);
        v948:set_callback(function(v1171)
            -- upvalues: v1144 (ref)
            v1144:visibility(v1171:get() == 2);
        end, true);
        v1145 = nil;
        v1145 = {
            duration = v565.global("chd", v1144:slider("\239\153\136   Hitmarker", 4, 20, 4, 0.1, function(v1172)
                if v1172 == 4 then
                    return "Off";
                else
                    return;
                end;
            end))
        };
        v1145.color = v565.global("chc", v1145.duration:color_picker());
        v1145.duration:set_callback(function(v1173)
            -- upvalues: v1145 (ref)
            v1145.color:visibility(v1173:get() ~= 4);
        end, true);
        v566.crosshair_hitmarker = v1145;
        v1146 = nil;
        v566.custom_thirdperson_animation = v565.global("cta", v1144:slider(" \239\134\131   3-rd Person Anim.", 0, 50, 0, 0.1, function(v1174)
            if v1174 == 0 then
                return "Off";
            else
                return;
            end;
        end));
        v1147 = ui.create("\238\140\163", "\n others 3", 2);
        v948:set_callback(function(v1175)
            -- upvalues: v1147 (ref)
            v1147:visibility(v1175:get() == 2);
        end, true);
        v1148 = nil;
        v1148 = {
            enabled = v565.global("ccc", v1147:switch("\238\136\182    Custom Console Color"))
        };
        v1148.color = v565.global("cccc", v1148.enabled:color_picker(l_color_0(55, 190)));
        v1148.enabled:set_callback(function(v1176)
            -- upvalues: v1148 (ref)
            v1148.color:visibility(v1176:get());
        end, true);
        v566.custom_console_color = v1148;
        v1149 = nil;
        v1149 = {
            enabled = v565.global("cmo", v1147:switch("\239\128\142    Custom Model Opacity"))
        };
        local v1177 = v1149.enabled:create();
        v1149.mode = v565.global("cmom", v1177:listable("\n Custom Model Opacity Mode", "In Scope", "Grenades"));
        local v1178 = nil;
        v1178 = {
            scope = v565.global("mos", v1177:slider("In Scope", 0, 100, 50)), 
            grenades = v565.global("cmog", v1177:slider("Grenades", 0, 100, 50))
        };
        do
            local l_v1177_0, l_v1178_0 = v1177, v1178;
            v1149.mode:set_callback(function(v1181)
                -- upvalues: l_v1178_0 (ref)
                l_v1178_0.scope:visibility(v1181:get("In Scope"));
                l_v1178_0.grenades:visibility(v1181:get("Grenades"));
            end, true);
            v1149.transparency = l_v1178_0;
            v1149.enabled:set_callback(function(v1182)
                -- upvalues: l_v1177_0 (ref)
                l_v1177_0:visibility(v1182:get());
            end, true);
            v566.custom_model_opacity = v1149;
        end;
        v1177 = nil;
        v1177 = {
            enabled = v565.global("sp", v1147:switch("\239\131\137     Debug Panel"))
        };
        v1178 = v1177.enabled:create();
        v1177.selection = v565.global("sps", v1178:listable("\n selection", "Enemy Miss Count", "Current Preset", "Advanced Phases", "Aimtools Status"));
        v1177.color = v565.global("spc", v1178:color_picker("Text Color"));
        v1177.animation = v565.global("spa", v1178:list("Animation", "Static", "Dynamic"));
        v1177.reset = v565.global("spr", v1178:listable("Reset Triggers", "Round Start", "After Game", "After Localplayer Death"));
        v1177.button_reset = v1178:button(" \239\139\177 Reset ", nil, true);
        do
            local l_v1178_1 = v1178;
            v1177.enabled:set_callback(function(v1184)
                -- upvalues: l_v1178_1 (ref)
                l_v1178_1:visibility(v1184:get());
            end, true);
            v566.state_panel = v1177;
        end;
        v1178 = nil;
        v1178 = {
            enabled = v565.global("ov", v1147:switch("\239\137\150    Override Viewmodel"))
        };
        local v1185 = v1178.enabled:create();
        v1178.fov = v565.global("ovf", v1185:slider("Fov", 0, 1500, cvar.viewmodel_fov:float() * 10, 0.1));
        v1178.x = v565.global("ovx", v1185:slider("Offset X", -200, 200, cvar.viewmodel_offset_x:float() * 10, 0.1));
        v1178.y = v565.global("ovy", v1185:slider("Offset Y", -200, 200, cvar.viewmodel_offset_y:float() * 10, 0.1));
        v1178.z = v565.global("ovz", v1185:slider("Offset Z", -200, 200, cvar.viewmodel_offset_z:float() * 10, 0.1));
        v1178.reverse_on_knife = v565.global("ovrok", v1185:switch("Reverse on Knife"));
        v1178.reset = v1185:button(" \239\139\177 Reset ", nil, true);
        do
            local l_v1185_0 = v1185;
            v1178.enabled:set_callback(function(v1187)
                -- upvalues: l_v1185_0 (ref)
                l_v1185_0:visibility(v1187:get());
            end, true);
            v566.override_viewmodel = v1178;
        end;
        v1185 = nil;
        v1185 = {
            enabled = v565.global("oa", v1147:switch("\239\142\144   Override Aspectratio"))
        };
        local v1188 = v1185.enabled:create();
        local v1189 = {
            [59] = "Off", 
            [160] = "16:10", 
            [177] = "16:9", 
            [125] = "5:4", 
            [150] = "3:2", 
            [133] = "4:3"
        };
        do
            local l_v1188_0, l_v1189_0 = v1188, v1189;
            v1185.value = v565.global("oav", l_v1188_0:slider("\n value", 59, 250, 59, 0.01, function(v1192)
                -- upvalues: l_v1189_0 (ref)
                return l_v1189_0[v1192];
            end));
            for v1193, v1194 in l_next_0, l_v1189_0 do
                do
                    local l_v1193_0 = v1193;
                    if v1194 ~= "Off" then
                        l_v1188_0:button(v1194, function()
                            -- upvalues: v1185 (ref), l_v1193_0 (ref)
                            v1185.value:set(l_v1193_0);
                        end, true);
                    end;
                end;
            end;
            v1185.enabled:set_callback(function(v1196)
                -- upvalues: l_v1188_0 (ref)
                l_v1188_0:visibility(v1196:get());
            end, true);
            v566.override_aspectratio = v1185;
        end;
        ui.sidebar("\a{Link Active}outlaw", "\a{Link Active}  \239\147\188");
    end;
    v567 = v566.welcome.main;
    v568 = v567.get;
    v574 = v567.override;
    v575 = nil;
    v576 = nil;
    v577 = ui.get_binds;
    v578 = ui.get_alpha;
    v575 = {};
    do
        local l_v577_2, l_v578_1 = v577, v578;
        v579 = function()
            -- upvalues: v575 (ref), l_v577_2 (ref), v576 (ref), l_v578_1 (ref)
            v575 = l_v577_2();
            for v1199 = 1, #v575 do
                local v1200 = v575[v1199];
                v575[v1200.name] = v1200;
            end;
            v576 = l_v578_1();
        end;
        l_events_0.render(v579);
    end;
    v577 = nil;
    v577 = {};
    v578 = false;
    v579 = nil;
    v579 = function(v1201, v1202)
        -- upvalues: l_type_0 (ref), v568 (ref)
        if l_type_0(v1201) == "userdata" then
            if v1202 == nil then
                return v568(v1201);
            else
                return v568(v1201, v1202);
            end;
        else
            return v1201;
        end;
    end;
    v580 = nil;
    v580 = {
        enabled = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
    };
    v581 = nil;
    v581 = {
        enabled = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
    };
    v582 = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled");
    v583 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
    v584 = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk");
    v585 = nil;
    v585 = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
    };
    local v1203 = nil;
    local v1204 = nil;
    local v1205 = nil;
    local v1206 = nil;
    local v1207 = nil;
    do
        local l_v578_2, l_v579_2, l_v580_3, l_v581_2, l_v582_2, l_v585_1, l_v1203_0, l_v1204_0, l_v1205_0, l_v1206_0, l_v1207_0 = v578, v579, v580, v581, v582, v585, v1203, v1204, v1205, v1206, v1207;
        l_v580_3.enabled:set_callback(function(v1219)
            -- upvalues: l_v1203_0 (ref), v568 (ref)
            l_v1203_0 = v568(v1219);
        end, true);
        l_v581_2.enabled:set_callback(function(v1220)
            -- upvalues: l_v1204_0 (ref), v568 (ref)
            l_v1204_0 = v568(v1220);
        end, true);
        l_v582_2:set_callback(function(v1221)
            -- upvalues: l_v1205_0 (ref), v568 (ref)
            l_v1205_0 = v568(v1221);
        end, true);
        v583:set_callback(function(v1222)
            -- upvalues: l_v1206_0 (ref), v568 (ref)
            l_v1206_0 = v568(v1222);
        end, true);
        v584:set_callback(function(v1223)
            -- upvalues: l_v1207_0 (ref), v568 (ref)
            l_v1207_0 = v568(v1223);
        end, true);
        local v1224 = 0;
        local v1225 = 0;
        local v1226 = nil;
        local v1227 = nil;
        local v1228 = nil;
        local v1229 = nil;
        local v1230 = nil;
        local function v1232(v1231)
            -- upvalues: v1228 (ref), v568 (ref)
            v1228 = v568(v1231);
        end;
        local function v1234(v1233)
            -- upvalues: v1229 (ref), v568 (ref)
            v1229 = v568(v1233);
        end;
        local function v1236(v1235)
            -- upvalues: v1230 (ref), v568 (ref)
            v1230 = v568(v1235);
        end;
        do
            local l_v1232_0, l_v1234_0, l_v1236_0 = v1232, v1234, v1236;
            v566.mode:set_callback(function(v1240)
                -- upvalues: v1227 (ref), l_v1232_0 (ref), l_v1234_0 (ref), l_v1236_0 (ref), v568 (ref), v566 (ref)
                if v1227 then
                    v1227.Using.override:unset_callback(l_v1232_0);
                    v1227["Fake Lag"].override:unset_callback(l_v1234_0);
                    v1227["Fake Duck"].override:unset_callback(l_v1236_0);
                end;
                v1227 = v568(v1240) ~= 1 and v566.advanced;
                if v1227 then
                    v1227.Using.override:set_callback(l_v1232_0, true);
                    v1227["Fake Lag"].override:set_callback(l_v1234_0, true);
                    v1227["Fake Duck"].override:set_callback(l_v1236_0, true);
                end;
            end, true);
        end;
        v1232 = nil;
        v1234 = nil;
        v1236 = nil;
        local l_length_0 = l_vector_0().length;
        do
            local l_l_length_0_0 = l_length_0;
            v1232 = function(v1243, v1244)
                -- upvalues: v1228 (ref), l_v578_2 (ref), v1234 (ref), v1236 (ref), l_v1206_0 (ref), v1230 (ref), v1229 (ref), l_v1205_0 (ref), l_v1204_0 (ref), l_v1203_0 (ref), l_band_0 (ref), l_l_length_0_0 (ref), l_v1207_0 (ref)
                if v1243.in_use and v1228 and not l_v578_2 then
                    local v1245 = "Using";
                    v1236 = 8;
                    v1234 = v1245;
                    return v1234;
                elseif l_v1206_0 and v1230 and not l_v578_2 then
                    local v1246 = "Fake Duck";
                    v1236 = 10;
                    v1234 = v1246;
                    return v1234;
                elseif v1229 and not l_v578_2 and l_v1205_0 and not l_v1204_0 and not l_v1203_0 then
                    local v1247 = "Fake Lag";
                    v1236 = 9;
                    v1234 = v1247;
                    return v1234;
                else
                    local v1248 = l_band_0(v1244.m_fFlags, 1) ~= 0 and not v1243.in_jump;
                    local v1249 = v1244.m_flDuckAmount > 0 or l_v1206_0;
                    if not v1248 then
                        local v1250 = v1249 and "Crouch-Air" or "Air";
                        v1236 = v1249 and 7 or 6;
                        v1234 = v1250;
                        return v1234;
                    elseif v1249 then
                        local l_m_iTeamNum_0 = v1244.m_iTeamNum;
                        v1234 = l_m_iTeamNum_0 == 2 and "Crouching T" or "Crouching CT";
                        v1236 = l_m_iTeamNum_0 == 2 and 4 or 5;
                        return v1234;
                    elseif l_l_length_0_0(v1244.m_vecAbsVelocity) < 2 then
                        local v1252 = "Standing";
                        v1236 = 1;
                        v1234 = v1252;
                        return v1234;
                    elseif l_v1207_0 then
                        local v1253 = "Slowwalk";
                        v1236 = 3;
                        v1234 = v1253;
                        return v1234;
                    elseif v1248 then
                        local v1254 = "Moving";
                        v1236 = 2;
                        v1234 = v1254;
                        return v1234;
                    else
                        return;
                    end;
                end;
            end;
        end;
        l_length_0 = nil;
        local v1255 = nil;
        l_length_0 = function()
            -- upvalues: l_globals_0 (ref), v1255 (ref), l_inverter_0 (ref), l_antiaim_0 (ref)
            if l_globals_0.choked_commands == 0 then
                v1255 = l_inverter_0(l_antiaim_0);
            end;
            return v1255;
        end;
        local v1256 = nil;
        v1256 = {};
        v566.manual_yaw.base:set_callback(function(v1257)
            -- upvalues: v568 (ref), v1256 (ref)
            local v1258 = v568(v1257);
            v1256.yaw = v1258 == "Left" and -90 or v1258 == "Right" and 90 or v1258 == "Forward" and 180;
        end, true);
        v566.manual_yaw.disablers:set_callback(function(v1259)
            -- upvalues: v568 (ref), v1256 (ref)
            local v1260 = v1259:list();
            for v1261 = 1, #v1260 do
                local v1262 = v1260[v1261];
                v1260[v1262] = v568(v1259, v1262);
            end;
            v1256.disablers = v1260;
        end, true);
        v566.manual_yaw.yaw_type:set_callback(function(v1263)
            -- upvalues: v1256 (ref), v568 (ref)
            v1256.yaw_type = v568(v1263);
        end, true);
        v577.manual_yaw = v1256;
        local v1264 = nil;
        local v1265 = nil;
        v1265 = {};
        local v1266 = nil;
        do
            local l_v1266_0 = v1266;
            v566.freestanding.enabled:set_callback(function(v1268)
                -- upvalues: l_v1266_0 (ref), v568 (ref), v1265 (ref)
                l_v1266_0 = v568(v1268);
                v1265.enabled = l_v1266_0;
                v1265.active = l_v1266_0;
            end, true);
            local v1269 = nil;
            local v1270 = nil;
            v566.freestanding.selection:set_callback(function(v1271)
                -- upvalues: v1269 (ref), v1270 (ref), v568 (ref)
                local v1272 = v568(v1271, 1);
                v1270 = v568(v1271, 2);
                v1269 = v1272;
            end, true);
            local v1273 = nil;
            v566.freestanding.disablers:set_callback(function(v1274)
                -- upvalues: v568 (ref), v1265 (ref), v1273 (ref)
                local v1275 = v1274:list();
                for v1276 = 1, #v1275 do
                    local v1277 = v1275[v1276];
                    v1275[v1277] = v568(v1274, v1277);
                end;
                local l_v1265_0 = v1265;
                local l_v1275_0 = v1275;
                v1273 = v1275;
                l_v1265_0.disablers = l_v1275_0;
            end, true);
            v566.freestanding.yaw_type:set_callback(function(v1280)
                -- upvalues: v1265 (ref), v568 (ref)
                v1265.yaw_type = v568(v1280);
            end, true);
            v1264 = function()
                -- upvalues: l_get_target_0 (ref), l_antiaim_0 (ref), v1273 (ref), v1236 (ref), l_v1266_0 (ref), v1256 (ref), v1265 (ref), v574 (ref), l_v585_1 (ref), v1269 (ref), v1270 (ref)
                local v1281 = l_get_target_0(l_antiaim_0);
                local v1282 = l_get_target_0(l_antiaim_0, true);
                local v1283 = v1282 ~= nil and v1281 ~= v1282;
                local v1284 = v1273["On Slow Walking"] and v1236 == 3;
                local v1285 = v1273["In Air"] and (v1236 == 7 or v1236 == 6);
                local v1286 = v1273["In Crouching"] and not (v1236 ~= 4) or v1236 == 5;
                local l_l_v1266_0_0 = l_v1266_0;
                if v1236 == 8 or not v1283 or v1284 or v1285 or v1286 or v1256.yaw then
                    l_l_v1266_0_0 = false;
                end;
                v1265.enabled = l_l_v1266_0_0;
                v574(l_v585_1.enabled, l_l_v1266_0_0);
                v574(l_v585_1.disable_yaw_modifiers, v1269);
                v574(l_v585_1.body_freestanding, v1270);
            end;
        end;
        v1266 = nil;
        local v1288 = nil;
        v1288 = {};
        local v1289 = nil;
        do
            local l_v1289_0 = v1289;
            v566.edge_yaw.enabled:set_callback(function(v1291)
                -- upvalues: l_v1289_0 (ref), v568 (ref), v1288 (ref)
                l_v1289_0 = v568(v1291);
                v1288.enabled = l_v1289_0;
            end, true);
            v566.edge_yaw.selection:set_callback(function(v1292)
                -- upvalues: v568 (ref), v1288 (ref)
                local v1293 = v1292:list();
                for v1294 = 1, #v1293 do
                    local v1295 = v1293[v1294];
                    v1293[v1295] = v568(v1292, v1295);
                end;
                v1288.selection = v1293;
            end, true);
            local v1296 = nil;
            v566.edge_yaw.disablers:set_callback(function(v1297)
                -- upvalues: v568 (ref), v1288 (ref), v1296 (ref)
                local v1298 = v1297:list();
                for v1299 = 1, #v1298 do
                    local v1300 = v1298[v1299];
                    v1298[v1300] = v568(v1297, v1300);
                end;
                local l_v1288_0 = v1288;
                local l_v1298_0 = v1298;
                v1296 = v1298;
                l_v1288_0.disablers = l_v1298_0;
            end, true);
            local v1303 = {};
            for v1304 = -162, 180, 18 do
                v1303[v1304] = l_angles_0(v91, 0, v1304) * 96;
            end;
            local function v1307(v1305, v1306)
                return v1305.yaw < v1306.yaw;
            end;
            v1266 = function(v1308)
                -- upvalues: v1288 (ref), l_v1289_0 (ref), v1296 (ref), v1236 (ref), v1303 (ref), l_trace_line_0 (ref), v113 (ref), l_sort_0 (ref), v1307 (ref), l_lerp_0 (ref), l_angles_0 (ref), l_camera_angles_0 (ref), l_normalize_yaw_0 (ref), l_abs_0 (ref)
                v1288.yaw = nil;
                if not l_v1289_0 then
                    return;
                else
                    local v1309 = v1296["On Slow Walking"] and v1236 == 3;
                    local v1310 = v1296["In Air"] and (v1236 == 7 or v1236 == 6);
                    local v1311 = v1296["In Crouching"] and not (v1236 ~= 4) or v1236 == 5;
                    if v1309 or v1310 or v1311 then
                        return;
                    else
                        local l_localplayer_0 = v1308.localplayer;
                        local l_eye_position_0 = v1308.eye_position;
                        local v1314 = {};
                        for v1315 = -162, 180, 18 do
                            local v1316 = l_eye_position_0 + v1303[v1315];
                            local v1317 = l_trace_line_0(l_eye_position_0, v1316, l_localplayer_0, 33570827);
                            local l_entity_1 = v1317.entity;
                            local l_fraction_0 = v1317.fraction;
                            if l_entity_1 and v113(l_entity_1) == 0 and l_fraction_0 < 0.3 then
                                v1314[#v1314 + 1] = {
                                    endpos = v1317.end_pos, 
                                    yaw = v1315
                                };
                            end;
                        end;
                        l_sort_0(v1314, v1307);
                        local v1320 = nil;
                        if #v1314 >= 2 then
                            local v1321 = l_lerp_0(v1314[1].endpos, v1314[#v1314].endpos, 0.5);
                            v1320 = l_angles_0(l_eye_position_0 - v1321);
                        end;
                        if v1320 then
                            local l_y_0 = l_camera_angles_0().y;
                            local l_y_1 = v1320.y;
                            local v1324 = l_normalize_yaw_0(l_y_1 - l_y_0);
                            if l_abs_0(v1324) < 90 then
                                v1324 = 0;
                                l_y_0 = l_normalize_yaw_0(l_y_1 + 180);
                            end;
                            local v1325 = -l_y_0;
                            v1325 = l_normalize_yaw_0(v1325 + l_y_1 + 180);
                            v1288.yaw = l_normalize_yaw_0(v1325 + v1324);
                        end;
                        return;
                    end;
                end;
            end;
        end;
        v1289 = nil;
        local v1326 = {
            CCSPlayer = true, 
            CFuncBrush = true, 
            CWorld = true
        };
        local v1327 = l_vector_0(2, 2, 2);
        local v1328 = 1174421515;
        local v1329 = 8192;
        do
            local l_v1326_0, l_v1327_0, l_v1328_0, l_v1329_0 = v1326, v1327, v1328, v1329;
            v1289 = function(v1334, v1335)
                -- upvalues: v1227 (ref), l_v579_2 (ref), l_get_entities_0 (ref), v106 (ref), l_dist_0 (ref), l_camera_angles_0 (ref), l_angles_0 (ref), v91 (ref), l_v1329_0 (ref), l_trace_hull_0 (ref), l_v1327_0 (ref), l_v1328_0 (ref), l_v1326_0 (ref)
                if v1227 == nil then
                    return false;
                else
                    local v1336 = l_v579_2(v1227.Using.override);
                    local l_localplayer_1 = v1335.localplayer;
                    local l_weapon_0 = v1335.weapon;
                    if not l_weapon_0 then
                        return not v1334.in_use;
                    else
                        local v1339 = l_weapon_0:get_weapon_index() == 49 and l_localplayer_1.m_bInBombZone;
                        local v1340 = l_get_entities_0("CPlantedC4");
                        local v1341 = #v1340 > 0;
                        local v1342 = 100;
                        if v1341 then
                            local v1343 = v1340[#v1340];
                            local v1344 = v106(v1343);
                            local v1345 = v106(l_localplayer_1);
                            v1342 = l_dist_0(v1344, v1345);
                        end;
                        if v1342 < 62 and l_localplayer_1.m_iTeamNum == 3 then
                            return not v1334.in_use;
                        else
                            local l_eye_position_1 = v1335.eye_position;
                            local v1347 = l_camera_angles_0();
                            local v1348 = l_eye_position_1 + l_angles_0(v91, v1347) * l_v1329_0;
                            local v1349 = l_trace_hull_0(l_eye_position_1, v1348, l_v1327_0, l_v1327_0, l_localplayer_1, l_v1328_0);
                            local l_entity_2 = v1349.entity;
                            local l_fraction_1 = v1349.fraction;
                            local l_in_use_0 = v1334.in_use;
                            local v1353 = true;
                            if not v1336 then
                                v1353 = not l_in_use_0;
                            end;
                            if l_entity_2 and l_fraction_1 < 0.97 then
                                l_in_use_0 = l_v1326_0[l_entity_2:get_classname()] == nil;
                            end;
                            if not l_in_use_0 and not v1339 then
                                v1334.in_use = false;
                            end;
                            return v1353;
                        end;
                    end;
                end;
            end;
        end;
        v1326 = nil;
        v1327 = nil;
        v1328 = v566.flick_aa;
        v1328.enabled:set_callback(function(v1354)
            -- upvalues: v1326 (ref)
            v1326 = v1354:get();
        end, true);
        v1327 = {};
        for v1355, v1356 in l_pairs_0(v1328) do
            do
                local l_v1355_0 = v1355;
                if l_v1355_0 ~= "enabled" then
                    v1356:set_callback(function(v1358)
                        -- upvalues: v1327 (ref), l_v1355_0 (ref)
                        v1327[l_v1355_0] = {
                            is_always = v1358:get("Always"), 
                            is_invisible = v1358:get("Invisible"), 
                            is_high_ground = v1358:get("High Ground")
                        };
                    end, true);
                end;
            end;
        end;
        v1328 = nil;
        v566.helpers:set_callback(function(v1359)
            -- upvalues: l_next_0 (ref), v568 (ref), v1328 (ref)
            local v1360 = v1359:list();
            for v1361, v1362 in l_next_0, v1360 do
                v1360[v1361] = v568(v1359, v1362);
            end;
            v1328 = v1360;
        end, true);
        v1329 = nil;
        v1329 = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")
        };
        local v1363 = nil;
        v1329.yaw = {
            mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
            base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
            offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
            hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
        };
        local v1364 = nil;
        v1329.yaw_modifier = {
            mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
            offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
        };
        local v1365 = nil;
        v1329.body_yaw = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
            inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
        };
        local v1366 = nil;
        v1329.extended_angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
            roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
        };
        v1363 = nil;
        v1364 = nil;
        v1364 = {};
        v1365 = {};
        do
            local l_v1364_0, l_v1365_0, l_v1366_0 = v1364, v1365, v1366;
            do
                local l_l_v1365_0_0, l_l_v1366_0_0 = l_v1365_0, l_v1366_0;
                l_l_v1366_0_0 = function(v1372)
                    -- upvalues: v329 (ref), l_l_v1365_0_0 (ref), l_v1364_0 (ref)
                    local v1373 = v1372:get_xuid();
                    local v1374 = v329.get_software(v1372);
                    l_l_v1365_0_0[v1373] = v1372;
                    if v1374 == nil then
                        l_v1364_0[v1373] = "other";
                    elseif v1374 ~= nil and l_v1364_0[v1373] == nil then
                        local l_signature_0 = v1374.signature;
                        if l_signature_0 == "GS" then
                            l_v1364_0[v1373] = "gs";
                        elseif l_signature_0 == "NL" then
                            l_v1364_0[v1373] = "nl";
                        else
                            l_v1364_0[v1373] = "other";
                        end;
                    end;
                end;
                local function v1377()
                    -- upvalues: l_l_v1365_0_0 (ref), l_get_players_0 (ref), l_l_v1366_0_0 (ref), l_pairs_0 (ref), l_v1364_0 (ref)
                    l_l_v1365_0_0 = {};
                    l_get_players_0(true, false, l_l_v1366_0_0);
                    for v1376 in l_pairs_0(l_v1364_0) do
                        if l_l_v1365_0_0[v1376] == nil then
                            l_v1364_0[v1376] = nil;
                        end;
                    end;
                end;
                l_events_0.net_update_end(v1377);
            end;
            esp.enemy:new_text("CHEAT", "CHEAT", function(v1378)
                -- upvalues: l_v1364_0 (ref)
                local v1379 = l_v1364_0[v1378:get_xuid()];
                if v1379 == "other" then
                    return;
                else
                    return v1379;
                end;
            end);
            l_v1365_0 = {
                gs = {
                    Standing = {
                        [1] = "Anti Skeet", 
                        [2] = "No Defensive"
                    }, 
                    Moving = {
                        [1] = "Anti Skeet", 
                        [2] = "No Defensive"
                    }, 
                    Slowwalk = {
                        [1] = "Anti Skeet", 
                        [2] = "Defensive"
                    }, 
                    ["Crouching T"] = {
                        [1] = "Anti Skeet", 
                        [2] = "No Defensive"
                    }, 
                    ["Crouching CT"] = {
                        [1] = "Anti Skeet", 
                        [2] = "No Defensive"
                    }, 
                    Air = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouch-Air"] = {
                        [1] = "Anti Skeet", 
                        [2] = "Defensive"
                    }
                }, 
                nl = {
                    Standing = {
                        [1] = "Anti NL", 
                        [2] = "No Defensive"
                    }, 
                    Moving = {
                        [1] = "Mix", 
                        [2] = "No Defensive"
                    }, 
                    Slowwalk = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouching T"] = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouching CT"] = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    Air = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouch-Air"] = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }
                }, 
                other = {
                    Standing = {
                        [1] = "Anti NL", 
                        [2] = "No Defensive"
                    }, 
                    Moving = {
                        [1] = "Mix", 
                        [2] = "No Defensive"
                    }, 
                    Slowwalk = {
                        [1] = "Anti Skeet", 
                        [2] = "Defensive"
                    }, 
                    ["Crouching T"] = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouching CT"] = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    Air = {
                        [1] = "Anti NL", 
                        [2] = "Defensive"
                    }, 
                    ["Crouch-Air"] = {
                        [1] = "Mix", 
                        [2] = "Defensive"
                    }
                }
            };
            l_v1366_0 = 0;
            local v1380 = {};
            local v1381 = {
                [1] = "Standing", 
                [2] = "Moving", 
                [3] = "Slowwalk", 
                [4] = "Crouching T", 
                [5] = "Crouching CT", 
                [6] = "Air", 
                [7] = "Crouch-Air", 
                [8] = "Using", 
                [9] = "Fake Lag", 
                [10] = "Fake Duck"
            };
            for _, v1383 in l_ipairs_0(v1381) do
                v1380[v1383] = {
                    yaw = {
                        index = 1, 
                        time = l_globals_0.realtime
                    }, 
                    yaw_modifier = {
                        index = 1, 
                        time = l_globals_0.realtime
                    }, 
                    body_yaw = {
                        index = 1, 
                        time = l_globals_0.realtime
                    }, 
                    defensive = {
                        index = 1, 
                        pitch_modifier = -1, 
                        pitch = 0, 
                        time = l_globals_0.realtime
                    }
                };
            end;
            local l_advanced_1 = v566.advanced;
            local l_Global_0 = l_advanced_1.Global;
            local v1402 = {
                Disabled = function(_, v1387, v1388)
                    return "Disabled", 0, v1387, v1388;
                end, 
                Center = function(v1389, v1390, v1391, v1392, v1393)
                    if not v1392 then
                        return "Center", v1389, v1390, v1391;
                    else
                        return "Disabled", 0, v1390 + v1389 * (v1393 and 1 or -1), v1391;
                    end;
                end, 
                Offset = function(v1394, v1395, v1396, v1397, v1398)
                    if not v1397 then
                        return "Offset", v1394, v1395, v1396;
                    else
                        if v1398 then
                            v1395 = v1395 + v1394;
                        end;
                        return "Disabled", 0, v1395, v1396;
                    end;
                end, 
                Spin = function(v1399, v1400, v1401)
                    return "Spin", v1399, v1400, v1401;
                end
            };
            local v1417 = {
                Static = function(v1403)
                    -- upvalues: l_v579_2 (ref), l_override_hidden_pitch_0 (ref), l_antiaim_0 (ref)
                    local v1404 = l_v579_2(v1403.offset);
                    l_override_hidden_pitch_0(l_antiaim_0, v1404);
                end, 
                Jitter = function(v1405)
                    -- upvalues: v1224 (ref), l_v579_2 (ref), l_override_hidden_pitch_0 (ref), l_antiaim_0 (ref)
                    local v1406 = v1224 % 4 + 1 > 2;
                    local v1407 = l_v579_2(v1406 and v1405.offset_1 or v1405.offset_2);
                    l_override_hidden_pitch_0(l_antiaim_0, v1407);
                end, 
                Random = function(v1408)
                    -- upvalues: l_random_float_0 (ref), l_v579_2 (ref), l_override_hidden_pitch_0 (ref), l_antiaim_0 (ref)
                    local v1409 = l_random_float_0(l_v579_2(v1408.offset_1), l_v579_2(v1408.offset_2));
                    l_override_hidden_pitch_0(l_antiaim_0, v1409);
                end, 
                Fluctuate = function(v1410, v1411)
                    -- upvalues: l_v579_2 (ref), l_min_0 (ref), l_max_0 (ref), l_clamp_0 (ref), l_override_hidden_pitch_0 (ref), l_antiaim_0 (ref)
                    local v1412 = l_v579_2(v1410.offset_1);
                    local v1413 = l_v579_2(v1410.offset_2);
                    local v1414 = l_min_0(v1412, v1413);
                    local v1415 = l_max_0(v1412, v1413);
                    local l_pitch_0 = v1411.pitch;
                    l_pitch_0 = l_clamp_0(l_pitch_0 + v1411.pitch_modifier, v1414, v1415);
                    if l_pitch_0 == v1415 or l_pitch_0 == v1414 then
                        v1411.pitch_modifier = l_pitch_0 == v1415 and -2 or 2;
                    end;
                    v1411.pitch = l_pitch_0;
                    l_override_hidden_pitch_0(l_antiaim_0, l_pitch_0);
                end
            };
            local v1423 = {
                Default = function()

                end, 
                Spin = function(v1418)
                    -- upvalues: l_v579_2 (ref), l_v1366_0 (ref), l_override_hidden_yaw_offset_0 (ref), l_antiaim_0 (ref)
                    local v1419 = l_v579_2(v1418.offset);
                    local v1420 = l_v579_2(v1418.speed) * 0.1;
                    if v1419 > 0 then
                        l_v1366_0 = l_v1366_0 - v1420;
                        if v1419 < -l_v1366_0 then
                            l_v1366_0 = 0;
                        end;
                    else
                        l_v1366_0 = l_v1366_0 + v1420;
                        if l_v1366_0 > -v1419 then
                            l_v1366_0 = 0;
                        end;
                    end;
                    l_override_hidden_yaw_offset_0(l_antiaim_0, l_v1366_0);
                end, 
                ["Side Based"] = function(v1421)
                    -- upvalues: l_v579_2 (ref), v1255 (ref), l_override_hidden_yaw_offset_0 (ref), l_antiaim_0 (ref)
                    local v1422 = l_v579_2(v1255 and v1421.offset_1 or v1421.offset_2);
                    l_override_hidden_yaw_offset_0(l_antiaim_0, v1422);
                end
            };
            local v1424 = 0;
            local v1425 = false;
            local v1426 = nil;
            local v1427, v1428 = l_pcall_0(v194.decode, "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", v196);
            if v1427 and l_find_0(v1428, "<condition>") ~= nil then
                v1428 = l_gsub_0(v1428, "<condition>", "");
                local v1429, v1430 = l_pcall_0(msgpack.unpack, v1428);
                if v1429 then
                    v1426 = v1430;
                end;
            end;
            local v1431 = nil;
            v1427 = nil;
            v1363 = function(v1432, v1433)
                -- upvalues: l_get_threat_0 (ref), v574 (ref), l_v581_2 (ref), l_v580_3 (ref), l_advanced_1 (ref), v1234 (ref), l_v579_2 (ref), l_Global_0 (ref), v1226 (ref), l_v578_2 (ref), l_v1364_0 (ref), l_v1365_0 (ref), v1326 (ref), v1327 (ref), v106 (ref), v112 (ref), v1265 (ref), v1426 (ref), v1236 (ref), l_globals_0 (ref), v1431 (ref), v1427 (ref), l_get_1 (ref), l_exploit_0 (ref), v1380 (ref), v1256 (ref), v1288 (ref), v1225 (ref), v1255 (ref), v1224 (ref), l_antiaim_0 (ref), v1402 (ref), v1417 (ref), v1425 (ref), v1424 (ref), l_camera_angles_0 (ref), l_atan2_0 (ref), l_pi_0 (ref), l_override_hidden_yaw_offset_0 (ref), v1423 (ref), l_next_0 (ref), l_v1204_0 (ref), l_v1203_0 (ref), l_override_hidden_pitch_0 (ref), v1328 (ref), l_v582_2 (ref), l_get_game_rules_0 (ref), v1289 (ref), v109 (ref), v110 (ref), v1329 (ref), v577 (ref)
                local l_localplayer_2 = v1433.localplayer;
                local v1435 = l_get_threat_0();
                v574(l_v581_2.options);
                v574(l_v580_3.options);
                local v1436 = l_advanced_1[v1234];
                if not l_v579_2(v1436.override) or not v1436 then
                    v1436 = l_Global_0;
                end;
                local l_defensive_conditions_0 = v1436.defensive_conditions;
                local l_presets_0 = v1436.presets;
                local v1439 = l_v579_2(v1436.preset);
                if v1439 ~= "Global" then
                    v1226 = v1439;
                end;
                if l_v578_2 then
                    local v1440 = nil;
                    if v1435 ~= nil then
                        v1440 = l_v1364_0[v1435:get_xuid()];
                    end;
                    if v1440 == nil then
                        v1440 = "other";
                    end;
                    local v1441 = l_v1365_0[v1440][v1234];
                    if v1441 ~= nil then
                        v1436 = l_advanced_1[v1234];
                        l_presets_0 = v1436.presets;
                        local v1442 = v1441[1];
                        local v1443 = v1441[2];
                        v1439 = v1442;
                        v1226 = v1442;
                        l_defensive_conditions_0 = v1443;
                    end;
                end;
                local v1444 = false;
                local v1445 = false;
                if v1326 and v1435 ~= nil then
                    local v1446 = v1327[v1234];
                    if v1446 ~= nil then
                        local v1447 = v106(l_localplayer_2);
                        local v1448 = v106(v1435);
                        v1445 = v1447.z - v1448.z > 20;
                        local v1449 = false;
                        if v1446.is_always then
                            v1449 = true;
                        else
                            if v1446.is_invisible then
                                v1449 = not v112(v1435) or false;
                            end;
                            local l_is_high_ground_0 = v1446.is_high_ground;
                            if not v1449 and l_is_high_ground_0 and v1445 then
                                v1449 = true;
                            end;
                        end;
                        if not v1265.active and v1449 then
                            v1436 = v1426;
                            l_defensive_conditions_0 = nil;
                            v1439 = "Custom";
                            v1226 = "Custom";
                            v1444 = true;
                        end;
                    end;
                end;
                v1439 = l_presets_0[v1439];
                if v1439 ~= nil then
                    v1436 = v1439;
                end;
                local v1451 = v1236 ~= 8;
                local l_realtime_1 = l_globals_0.realtime;
                if v1431 ~= v1236 then
                    local l_v1236_1 = v1236;
                    v1427 = l_globals_0.realtime;
                    v1431 = l_v1236_1;
                end;
                if l_get_1(l_exploit_0) == 0 then
                    v1427 = l_globals_0.realtime;
                end;
                local v1454 = l_v579_2(v1436.pitch);
                local v1455 = v1380[v1234];
                local l_yaw_0 = v1436.yaw;
                local v1457 = l_v579_2(l_yaw_0.mode);
                local v1458 = l_v579_2(l_yaw_0.base);
                local l_yaw_1 = v1455.yaw;
                l_yaw_1.enabled = v1457 ~= "Disabled";
                local l_index_0 = l_yaw_1.index;
                local v1461 = l_realtime_1 - l_yaw_1.time;
                local v1462 = l_yaw_0.phases[l_index_0];
                if l_v579_2(v1462.time) * 0.1 <= v1461 then
                    l_index_0 = l_index_0 + 1;
                    if l_v579_2(l_yaw_0.s_phases) < l_index_0 then
                        l_index_0 = 1;
                    end;
                    l_yaw_1.index = l_index_0;
                    l_yaw_1.time = l_realtime_1;
                end;
                local l_body_yaw_0 = v1436.body_yaw;
                local v1464 = l_v579_2(l_body_yaw_0.enabled);
                local v1465 = false;
                local l_body_yaw_1 = v1455.body_yaw;
                l_body_yaw_1.enabled = v1464;
                local l_index_1 = l_body_yaw_1.index;
                local v1468 = l_realtime_1 - l_body_yaw_1.time;
                local v1469 = l_body_yaw_0.phases[l_index_1];
                if l_v579_2(v1469.time) * 0.1 <= v1468 then
                    l_index_1 = l_index_1 + 1;
                    if l_v579_2(l_body_yaw_0.s_phases) < l_index_1 then
                        l_index_1 = 1;
                    end;
                    l_body_yaw_1.index = l_index_1;
                    l_body_yaw_1.time = l_realtime_1;
                end;
                local v1470 = l_v579_2(v1469.mode);
                local v1471 = l_v579_2(v1469.avoid_overlap);
                local v1472 = 60;
                local v1473 = 60;
                local v1474 = {};
                local v1475 = l_v579_2(v1469.freestanding);
                if v1444 then
                    v1475 = v1445 and "Off" or "Jitter";
                end;
                if v1471 then
                    v1474[#v1474 + 1] = "Avoid Overlap";
                end;
                local v1476 = v1470 == "Jitter V2";
                if v1470 == "Jitter" or v1476 then
                    v1474[#v1474 + 1] = "Jitter";
                end;
                local v1477 = v1256.yaw or v1288.enabled and v1288.yaw ~= nil and v1288.selection["Static Body Yaw"];
                if v1256.yaw or v1265.enabled then
                    v1474 = {};
                    v1470 = "Static";
                end;
                if v1477 then
                    v1472 = 0;
                end;
                if v1477 then
                    v1473 = 0;
                end;
                if v1475 == "Hybrid" then
                    if v1435 ~= nil then
                        v1475 = v112(v1435) and "Off" or "Peek Fake";
                    else
                        v1475 = "Peek Fake";
                    end;
                elseif v1475 == "Jitter" then
                    v1475 = v1225 % 4 > 1 and "Peek Fake" or "Peek Real";
                end;
                local v1478 = l_v579_2(v1462.right);
                local v1479 = l_v579_2(v1462.left);
                local l_v1478_0 = v1478;
                if v1470 ~= "Static" then
                    local v1481 = l_v579_2(v1462.delay_ticks);
                    v1255 = v1481 < v1224 % (v1481 * 2) + 1;
                    l_antiaim_0:inverter(not v1255);
                    l_v1478_0 = v1255 and v1478 or v1479;
                end;
                local l_yaw_modifier_0 = v1436.yaw_modifier;
                local v1483 = l_v579_2(l_yaw_modifier_0.mode);
                local l_yaw_modifier_1 = v1455.yaw_modifier;
                local v1485 = v1483 == "Advanced";
                l_yaw_modifier_1.enabled = v1485;
                if v1485 then
                    local l_advanced_2 = l_yaw_modifier_0.advanced;
                    local l_index_2 = l_yaw_modifier_1.index;
                    local v1488 = l_realtime_1 - l_yaw_modifier_1.time;
                    l_yaw_modifier_0 = l_advanced_2.phases[l_index_2];
                    if l_v579_2(l_yaw_modifier_0.time) * 0.1 <= v1488 then
                        l_index_2 = l_index_2 + 1;
                        if l_v579_2(l_advanced_2.s_phases) < l_index_2 then
                            l_index_2 = 1;
                        end;
                        l_yaw_modifier_1.index = l_index_2;
                        l_yaw_modifier_1.time = l_realtime_1;
                    end;
                end;
                v1483 = l_v579_2(l_yaw_modifier_0.mode);
                local v1489 = l_v579_2(l_yaw_modifier_0.offset);
                local v1490, v1491, v1492, v1493 = v1402[v1483](v1489, l_v1478_0, v1474, v1476, v1255);
                v1474 = v1493;
                l_v1478_0 = v1492;
                v1489 = v1491;
                v1483 = v1490;
                if v1451 then
                    v1490 = v1288.yaw;
                    if v1288.enabled and v1490 ~= nil then
                        v1457 = "Backward";
                        l_v1478_0 = v1490;
                        if v1288.selection["Disable Yaw Modifiers"] then
                            v1483 = "Disabled";
                        end;
                    end;
                    v1491 = v1256.yaw;
                    if v1491 then
                        v1457 = "Backward";
                        l_v1478_0 = v1491;
                        v1492 = v1256.disablers;
                        if v1492["Yaw Modifiers"] then
                            v1483 = "Disabled";
                        end;
                        if v1492["At Target"] then
                            v1458 = "Local View";
                        end;
                    end;
                end;
                v1490 = v1436.defensive;
                v1491 = v1490.pitch;
                v1492 = v1490.yaw_modifier;
                local v1494 = l_v579_2(v1492.mode) == "Advanced";
                v1455.defensive.enabled = v1494;
                local l_delay_time_0 = v1490.delay_time;
                local v1496 = (l_delay_time_0 ~= nil and l_v579_2(l_delay_time_0) * 0.1 or 0) <= l_globals_0.realtime - v1427;
                local v1497 = l_v579_2(v1490.enabled) and not v1265.active and not v1256.yaw and (not (v1288.enabled and v1288.yaw ~= nil) or not v1288.selection["Disable Defensive AA"]) and v1496;
                if l_defensive_conditions_0 ~= nil and v1226 ~= "Custom" then
                    v1497 = l_v579_2(l_defensive_conditions_0) == "Defensive" and v1496;
                end;
                if v1497 then
                    local l_defensive_0 = v1455.defensive;
                    v1417[l_v579_2(v1491.mode)](v1491, l_defensive_0);
                    local l_advanced_3 = v1492.advanced;
                    if v1494 then
                        local l_index_3 = l_defensive_0.index;
                        local v1501 = l_realtime_1 - l_defensive_0.time;
                        v1492 = l_advanced_3.phases[l_index_3];
                        if l_v579_2(v1492.time) * 0.1 <= v1501 then
                            l_index_3 = l_index_3 + 1;
                            if l_v579_2(l_advanced_3.s_phases) < l_index_3 then
                                l_index_3 = 1;
                            end;
                            l_defensive_0.index = l_index_3;
                            l_defensive_0.time = l_realtime_1;
                        end;
                    end;
                    local v1502 = l_v579_2(v1492.mode);
                    if v1502 == "Anti Bruteforce" then
                        local v1503 = l_get_threat_0(true);
                        if v1425 ~= v1503 and l_globals_0.choked_commands == 0 then
                            v1424 = v1432.sidemove;
                            v1425 = v1503;
                        end;
                        local v1504 = 0;
                        local v1505 = l_v579_2(v1492.anti_bruteforce_mode) == "v1" and -1 or 1;
                        if v1425 then
                            local v1506 = v1424 == -450 and 1 or -1;
                            v1504 = 90 * v1505 * v1506;
                        else
                            local v1507 = l_v579_2(v1492.anti_bruteforce_side_mode);
                            local v1508 = 1;
                            if v1507 == "Default" then
                                v1508 = v1432.sidemove == -450 and -1 or 1;
                            elseif v1507 == "Crosshair" and v1435 ~= nil then
                                local v1509 = l_camera_angles_0();
                                local v1510 = v106(v1435) - v106(l_localplayer_2);
                                v1508 = (l_atan2_0(v1510.y, v1510.x) * 180 / l_pi_0 - v1509.y + 180) % 360 - 180 > 0 and -1 or 1;
                            end;
                            v1504 = 90 * v1505 * v1508;
                        end;
                        local v1511 = l_v579_2(v1492.anti_bruteforce_randomize);
                        if v1511 ~= 2 and v1224 % v1511 + 1 == v1511 then
                            v1504 = -v1504;
                        end;
                        l_override_hidden_yaw_offset_0(l_antiaim_0, v1504);
                    else
                        v1423[v1502](v1492);
                    end;
                end;
                local v1512 = {};
                local v1513 = l_v579_2(v1436.force_defensive);
                for _, v1515 in l_next_0, v1513 do
                    v1512[v1515] = true;
                end;
                if v1512["Double Tap"] ~= nil and l_v1204_0 or v1512["Hide Shots"] ~= nil and l_v1203_0 then
                    v574(l_v581_2.options, "Always On");
                    v574(l_v580_3.options, "Break LC");
                end;
                if v1256.yaw and v1256.yaw_type == 2 or v1265.enabled and v1265.yaw_type == 2 then
                    v574(l_v581_2.options);
                    v574(l_v580_3.options);
                    v1497 = true;
                    l_override_hidden_pitch_0(l_antiaim_0, 0);
                    l_override_hidden_yaw_offset_0(l_antiaim_0, 180);
                end;
                if v1328[1] and v1451 then
                    local l_weapon_info_0 = v1433.weapon_info;
                    if l_weapon_info_0 and l_weapon_info_0.weapon_name == "weapon_knife" then
                        v1454 = "Down";
                        if (not v1288.enabled or v1288.yaw == nil) and not v1256.yaw then
                            v1457 = "Backward";
                            v1458 = "At Target";
                            l_v1478_0 = 28;
                            v1497 = false;
                        end;
                        v1483 = "Offset";
                        v1489 = -3;
                        v1464 = true;
                        v1474 = {};
                        v1472 = 60;
                        v1473 = 60;
                        v1475 = "Off";
                        l_antiaim_0:inverter(false);
                    end;
                end;
                if v1328[2] and (l_v1204_0 or l_v1203_0) then
                    v574(l_v582_2, false);
                else
                    v574(l_v582_2);
                end;
                local v1517 = true;
                if v1328[3] then
                    local v1518 = l_get_game_rules_0();
                    v1517 = v1518 == nil or not v1518.m_bWarmupPeriod;
                end;
                if v1517 then
                    v1517 = v1289(v1432, v1433);
                end;
                if v1328[4] and v1451 then
                    local v1519 = {};
                    local l_all_enemies_0 = v1433.all_enemies;
                    for v1521 = 1, #l_all_enemies_0 do
                        local v1522 = l_all_enemies_0[v1521];
                        if not v109(v1522) and v110(v1522) then
                            v1519[#v1519 + 1] = 1;
                        end;
                    end;
                    if #v1519 == 0 and #l_all_enemies_0 > 0 then
                        v1454 = "Down";
                        if (not v1288.enabled or v1288.yaw == nil) and not v1256.yaw then
                            v1457 = "Backward";
                            v1458 = "At Target";
                            l_v1478_0 = 28;
                            v1497 = false;
                        end;
                        v1483 = "Offset";
                        v1489 = -3;
                        v1464 = true;
                        v1474 = {};
                        v1472 = 60;
                        v1473 = 60;
                        v1475 = "Off";
                        l_antiaim_0:inverter(false);
                    end;
                end;
                v574(v1329.enabled, v1517);
                v574(v1329.pitch, v1454);
                local l_yaw_2 = v1329.yaw;
                v574(l_yaw_2.mode, v1457);
                v574(l_yaw_2.base, v1458);
                v574(l_yaw_2.offset, l_v1478_0);
                v574(l_yaw_2.hidden, v1497);
                local l_yaw_modifier_2 = v1329.yaw_modifier;
                v574(l_yaw_modifier_2.mode, v1483);
                v574(l_yaw_modifier_2.offset, v1489);
                local l_body_yaw_2 = v1329.body_yaw;
                v574(l_body_yaw_2.enabled, v1464);
                v574(l_body_yaw_2.inverter, v1465);
                v574(l_body_yaw_2.left_limit, v1472);
                v574(l_body_yaw_2.right_limit, v1473);
                v574(l_body_yaw_2.options, v1474);
                v574(l_body_yaw_2.freestanding, v1475);
                v574(v1329.extended_angles.enabled, false);
                v577.advanced_data = v1455;
            end;
            l_events_0.round_start(function()
                -- upvalues: l_ipairs_0 (ref), v1381 (ref), v1380 (ref), l_globals_0 (ref)
                for _, v1527 in l_ipairs_0(v1381) do
                    v1380[v1527] = {
                        yaw = {
                            index = 1, 
                            time = l_globals_0.realtime
                        }, 
                        yaw_modifier = {
                            index = 1, 
                            time = l_globals_0.realtime
                        }, 
                        body_yaw = {
                            index = 1, 
                            time = l_globals_0.realtime
                        }, 
                        defensive = {
                            index = 1, 
                            pitch_modifier = -1, 
                            pitch = 0, 
                            time = l_globals_0.realtime
                        }
                    };
                end;
            end);
        end;
        v1364 = nil;
        v566.mode:set_callback(function(v1528)
            -- upvalues: v568 (ref), v1364 (ref), v1363 (ref), l_v578_2 (ref), v0 (ref), v577 (ref), v574 (ref), l_v581_2 (ref), l_v580_3 (ref), v1329 (ref), l_v582_2 (ref)
            local v1529 = v568(v1528);
            v1364 = nil;
            if v1529 ~= 1 then
                v1364 = v1363;
            end;
            l_v578_2 = false;
            if v0 == 3 then
                l_v578_2 = v1529 == 2;
            end;
            if not v1364 then
                local l_v577_3 = v577;
                local l_v577_4 = v577;
                local v1532 = nil;
                l_v577_4.preset_name = nil;
                l_v577_3.advanced_data = v1532;
            end;
            v574(l_v581_2.options);
            v574(l_v580_3.options);
            v574(v1329.enabled);
            v574(v1329.pitch);
            v574(v1329.yaw.mode);
            v574(v1329.yaw.base);
            v574(v1329.yaw.offset);
            v574(v1329.yaw.hidden);
            v574(v1329.yaw_modifier.mode);
            v574(v1329.yaw_modifier.offset);
            v574(v1329.body_yaw.enabled);
            v574(v1329.body_yaw.inverter);
            v574(v1329.body_yaw.left_limit);
            v574(v1329.body_yaw.right_limit);
            v574(v1329.body_yaw.options);
            v574(v1329.body_yaw.freestanding);
            v574(v1329.extended_angles.enabled);
            v574(v1329.extended_angles.pitch);
            v574(v1329.extended_angles.roll);
            v574(l_v582_2);
        end, true);
        v1365 = nil;
        v1365 = function(v1533, v1534)
            -- upvalues: v1225 (ref), l_globals_0 (ref), v1224 (ref), v577 (ref), v1232 (ref), l_length_0 (ref), v1364 (ref), v1264 (ref), v1266 (ref), v1226 (ref)
            local l_localplayer_3 = v1533.localplayer;
            local l_is_alive_0 = v1533.is_alive;
            if l_localplayer_3 == nil or not l_is_alive_0 then
                return;
            else
                v1225 = v1225 + 1;
                if l_globals_0.choked_commands == 0 then
                    v1224 = v1224 + 1;
                end;
                v577.condition = v1232(v1534, l_localplayer_3);
                v577.inverter = l_length_0();
                if not v1364 then
                    return;
                else
                    v1264();
                    v1266(v1533);
                    v1364(v1534, v1533);
                    v577.preset_name = v1226;
                    return;
                end;
            end;
        end;
        v502("Anti Aim")("createmove", v1365);
    end;
    v578 = nil;
    v578 = {
        weapon_knife = 9, 
        weapon_taser = 8, 
        weapon_mag7 = 7, 
        weapon_sawedoff = 7, 
        weapon_xm1014 = 7, 
        weapon_nova = 7, 
        weapon_cz75a = 6, 
        weapon_tec9 = 6, 
        weapon_glock = 6, 
        weapon_usp_silencer = 6, 
        weapon_fiveseven = 6, 
        weapon_p250 = 6, 
        weapon_elite = 6, 
        weapon_hkp2000 = 6, 
        weapon_deagle = 5, 
        weapon_revolver = 4, 
        weapon_awp = 3, 
        weapon_ssg08 = 2, 
        weapon_scar20 = 1, 
        weapon_g3sg1 = 1
    };
    v579 = nil;
    v579 = v566.noscope_mode;
    v580 = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance");
    v581 = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope");
    v582 = nil;
    v583 = nil;
    v582 = {};
    do
        local l_v580_4, l_v581_3, l_v582_3, l_v583_2, l_v584_2, l_v585_2 = v580, v581, v582, v583, v584, v585;
        for v1543 = 1, #v579 do
            do
                local l_v1543_0 = v1543;
                v579[l_v1543_0]:set_callback(function(v1545)
                    -- upvalues: l_v582_3 (ref), l_v1543_0 (ref), v568 (ref)
                    l_v582_3[l_v1543_0] = v568(v1545);
                end, true);
            end;
        end;
        v579.distance:set_callback(function(v1546)
            -- upvalues: l_v583_2 (ref), v568 (ref)
            l_v583_2 = v568(v1546);
            l_v583_2 = l_v583_2 == 201 and 9999 or l_v583_2 * 10;
        end, true);
        l_v584_2 = {};
        l_v585_2 = function(v1547)
            -- upvalues: l_v584_2 (ref), v574 (ref), l_v580_4 (ref), l_v581_3 (ref), v578 (ref), l_v582_3 (ref), v110 (ref), l_dist_0 (ref), v105 (ref), l_v583_2 (ref), v113 (ref)
            l_v584_2 = {};
            v574(l_v580_4);
            v574(l_v581_3);
            local l_localplayer_4 = v1547.localplayer;
            local l_is_alive_1 = v1547.is_alive;
            if l_localplayer_4 == nil or not l_is_alive_1 then
                return;
            else
                local l_weapon_info_1 = v1547.weapon_info;
                if l_weapon_info_1 == nil then
                    return;
                else
                    local l_weapon_name_0 = l_weapon_info_1.weapon_name;
                    local l_zoom_level_0 = l_weapon_info_1.zoom_level;
                    local v1553 = v578[l_weapon_name_0];
                    if v1553 == nil then
                        v1553 = 10;
                    end;
                    local v1554 = l_v582_3[v1553];
                    if v1554 == nil or v1554 == -1 then
                        return;
                    else
                        local l_eye_position_2 = v1547.eye_position;
                        local v1556 = true;
                        local l_m_bIsScoped_0 = l_localplayer_4.m_bIsScoped;
                        local l_enemies_0 = v1547.enemies;
                        for v1559 = 1, #l_enemies_0 do
                            local v1560 = l_enemies_0[v1559];
                            if v110(v1560) and l_dist_0(l_eye_position_2, v105(v1560)) <= l_v583_2 then
                                l_v584_2[v113(v1560)] = true;
                                v1556 = false;
                            end;
                        end;
                        v574(l_v581_3, v1556);
                        if not l_m_bIsScoped_0 and l_zoom_level_0 ~= 0 then
                            v574(l_v580_4, v1554);
                        end;
                        return;
                    end;
                end;
            end;
        end;
        if v0 == 3 then
            v1203 = function(v1561)
                -- upvalues: l_v584_2 (ref), v113 (ref)
                if l_v584_2[v113(v1561)] ~= nil then
                    return "NOZOOM";
                else
                    return;
                end;
            end;
            esp.enemy:new_text("No Scope", "NOZOOM", v1203);
        end;
        v579.enabled:set_callback(function(v1562)
            -- upvalues: v574 (ref), l_v580_4 (ref), l_v581_3 (ref), v502 (ref), l_v585_2 (ref), v568 (ref)
            v574(l_v580_4);
            v574(l_v581_3);
            v502("Noscope Mode")("createmove", l_v585_2, v568(v1562));
        end, true);
    end;
    v580 = nil;
    v580 = v566.adaptive_air_stop;
    v581 = ui.find("Aimbot", "Ragebot", "Accuracy", "SSG-08", "Auto Stop", "Options");
    v582 = {
        ["Crouch-Air"] = true, 
        Air = true
    };
    v583 = l_vector_0().length2d;
    do
        local l_v581_4, l_v582_4, l_v583_3, l_v584_3 = v581, v582, v583, v584;
        l_v584_3 = function(v1567)
            -- upvalues: v574 (ref), l_v581_4 (ref), v577 (ref), l_v582_4 (ref), l_v583_3 (ref)
            v574(l_v581_4);
            local l_localplayer_5 = v1567.localplayer;
            local l_is_alive_2 = v1567.is_alive;
            if l_localplayer_5 == nil or not l_is_alive_2 then
                return;
            elseif l_v582_4[v577.condition] == nil then
                return;
            else
                local v1570 = l_v583_3(l_localplayer_5.m_vecVelocity);
                v574(l_v581_4, v1570 < 220 and "In Air" or "Move Between Shots");
                return;
            end;
        end;
        v580:set_callback(function(v1571)
            -- upvalues: v574 (ref), l_v581_4 (ref), v502 (ref), l_v584_3 (ref), v568 (ref)
            v574(l_v581_4);
            v502("Adaptive Air Stop")("createmove", l_v584_3, v568(v1571));
        end, true);
    end;
    v581 = nil;
    v581 = v566.adaptive_silent;
    v582 = nil;
    do
        local l_v582_5, l_v583_4 = v582, v583;
        v581.fov:set_callback(function(v1574)
            -- upvalues: l_v582_5 (ref), v568 (ref)
            l_v582_5 = v568(v1574);
        end, true);
        l_v583_4 = function(v1575)
            -- upvalues: l_get_local_player_0 (ref), v110 (ref), v105 (ref), l_camera_angles_0 (ref), l_angles_0 (ref), l_normalize_yaw_0 (ref), l_abs_0 (ref), l_normalize_0 (ref), l_v582_5 (ref)
            local v1576 = l_get_local_player_0();
            if v1576 == nil or not v110(v1576) then
                return;
            else
                local v1577 = v105(v1576);
                local v1578 = l_camera_angles_0();
                local v1579 = l_angles_0(v1575.aim - v1577);
                local v1580 = v1578 - v1579;
                v1580.y = l_normalize_yaw_0(v1580.y);
                if not (l_abs_0(l_normalize_0(v1580)) < l_v582_5) then
                    return;
                else
                    l_camera_angles_0(v1579);
                    return;
                end;
            end;
        end;
        v581.enabled:set_callback(function(v1581)
            -- upvalues: l_events_0 (ref), l_v583_4 (ref), v568 (ref)
            l_events_0.aim_fire(l_v583_4, v568(v1581));
        end, true);
    end;
    v582 = nil;
    v582 = v566.aimtools;
    v583 = v566.adaptive_force_body_safety;
    v584 = v566.force_safety_triggets;
    v585 = nil;
    v585 = {
        enabled = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        disablers = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
    };
    v1203 = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points");
    v1204 = nil;
    v1204 = {
        enabled = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop"), 
        options = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Options"), 
        doubletap = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Double Tap"), 
        autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop")
    };
    v1205 = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes");
    v1206 = nil;
    v1206 = {
        enabled = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint"), 
        head_scale = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"), 
        body_scale = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale")
    };
    v1207 = nil;
    v1207 = {
        main = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        doubletap = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance", "Double Tap")
    };
    local v1582 = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Extended Backtrack");
    local v1583 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
    local v1584 = ui.find("Aimbot", "Ragebot", "Selection", "Penetrate Walls");
    local v1585 = ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety");
    local v1586 = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope");
    local v1587, v1588 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
    do
        local l_v583_5, l_v585_3, l_v1203_1, l_v1204_1, l_v1205_1, l_v1206_1, l_v1207_1, l_v1582_0, l_v1583_0, l_v1584_0, l_v1585_0, l_v1586_0, l_v1588_0 = v583, v585, v1203, v1204, v1205, v1206, v1207, v1582, v1583, v1584, v1585, v1586, v1588;
        v1587:set_callback(function(v1602)
            -- upvalues: l_v1588_0 (ref), v568 (ref)
            l_v1588_0 = v568(v1602);
        end, true);
        local v1603, v1604 = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist");
        v1603:set_callback(function(v1605)
            -- upvalues: v1604 (ref), v568 (ref)
            v1604 = v568(v1605);
        end, true);
        local v1606, v1607 = ui.find("Miscellaneous", "Main", "Other", "Fake Latency");
        v1606:set_callback(function(v1608)
            -- upvalues: v1607 (ref), v568 (ref)
            v1607 = v568(v1608);
        end, true);
        local v1609, v1610 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
        v1609:set_callback(function(v1611)
            -- upvalues: v1610 (ref), v568 (ref)
            v1610 = v568(v1611);
        end, true);
        local v1612 = nil;
        local v1613 = nil;
        local v1614 = nil;
        local v1615 = nil;
        local v1616 = nil;
        local v1617 = nil;
        local v1618 = nil;
        local v1619 = nil;
        local v1620 = nil;
        local v1621 = nil;
        local v1622 = nil;
        v582.enabled:set_callback(function(v1623)
            -- upvalues: v1612 (ref), v568 (ref), v574 (ref), l_v585_3 (ref), l_v1203_1 (ref), l_v1204_1 (ref), l_v1205_1 (ref), l_v1206_1 (ref), l_v1207_1 (ref), l_v1582_0 (ref), l_v1583_0 (ref), l_v1584_0 (ref), l_v1585_0 (ref), l_v1586_0 (ref), v1606 (ref)
            v1612 = v568(v1623);
            v574(l_v585_3.enabled);
            v574(l_v585_3.disablers);
            v574(l_v1203_1);
            v574(l_v1204_1.enabled);
            v574(l_v1204_1.options);
            v574(l_v1204_1.doubletap);
            v574(l_v1204_1.autopeek);
            v574(l_v1205_1);
            v574(l_v1206_1.enabled);
            v574(l_v1206_1.head_scale);
            v574(l_v1206_1.body_scale);
            v574(l_v1207_1.main);
            v574(l_v1207_1.doubletap);
            v574(l_v1582_0);
            v574(l_v1583_0);
            v574(l_v1584_0);
            v574(l_v1585_0);
            v574(l_v1586_0);
            v574(v1606);
        end, true);
        l_v583_5.enabled:set_callback(function(v1624)
            -- upvalues: v1613 (ref), v568 (ref)
            v1613 = v568(v1624);
        end, true);
        l_v583_5.mode:set_callback(function(v1625)
            -- upvalues: v1614 (ref), v568 (ref)
            v1614 = v568(v1625) == 1;
        end, true);
        l_v583_5.selection:set_callback(function(v1626)
            -- upvalues: v1615 (ref), v568 (ref)
            v1615 = v568(v1626) == 1;
        end, true);
        v582.static_autostops:set_callback(function(v1627)
            -- upvalues: v1616 (ref), v568 (ref)
            v1616 = v568(v1627);
        end, true);
        v584.enabled:set_callback(function(v1628)
            -- upvalues: v1617 (ref), v568 (ref)
            v1617 = v568(v1628);
        end, true);
        v584.selection:set_callback(function(v1629)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), v1618 (ref)
            local v1630 = v1629:list();
            for _, v1632 in l_ipairs_0(v1630) do
                v1630[v1632] = v568(v1629, v1632);
            end;
            v1618 = v1630;
        end, true);
        v582.adaptive_safepoint_logic:set_callback(function(v1633)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), v1619 (ref)
            local v1634 = v1633:list();
            for _, v1636 in l_ipairs_0(v1634) do
                v1634[v1636] = v568(v1633, v1636);
            end;
            v1619 = v1634;
        end, true);
        v582.fast_quick_peeking:set_callback(function(v1637)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), v1620 (ref)
            local v1638 = v1637:list();
            for _, v1640 in l_ipairs_0(v1638) do
                v1638[v1640] = v568(v1637, v1640);
            end;
            v1620 = v1638;
        end, true);
        if v2 then
            v582.keks_debugger:set_callback(function(v1641)
                -- upvalues: v1621 (ref), v568 (ref)
                v1621 = v568(v1641);
            end, true);
        end;
        v582.debugger:set_callback(function(v1642)
            -- upvalues: v1622 (ref), v568 (ref)
            v1622 = v568(v1642);
        end, true);
        v582.is_working = false;
        local v1643 = {};
        local l_stringify_0 = json.stringify;
        local v1645 = nil;
        v1645 = function(v1646, v1647)
            -- upvalues: v575 (ref), v574 (ref), v2 (ref), v1621 (ref), l_tostring_0 (ref), l_type_0 (ref), l_next_0 (ref), l_sub_0 (ref), v1643 (ref), l_gsub_0 (ref), l_stringify_0 (ref), v582 (ref)
            if v575[v1646:name()] == nil then
                v574(v1646, v1647);
                if v2 and v1621 then
                    local v1648 = l_tostring_0(v1646);
                    local l_v1647_0 = v1647;
                    if l_type_0(v1647) == "table" then
                        l_v1647_0 = {};
                        for _, v1651 in l_next_0, v1647 do
                            l_v1647_0[#l_v1647_0 + 1] = l_sub_0(v1651, 1, 1);
                        end;
                    end;
                    v1643[#v1643 + 1] = l_gsub_0(v1648, "menu_item(", "") .. ": " .. l_stringify_0(l_v1647_0);
                end;
            end;
            v582.is_working = true;
        end;
        local v1652 = {};
        local v1653 = nil;
        v1653 = {
            weapon_cz75a = 7, 
            weapon_tec9 = 7, 
            weapon_glock = 7, 
            weapon_usp_silencer = 7, 
            weapon_fiveseven = 7, 
            weapon_p250 = 7, 
            weapon_elite = 7, 
            weapon_hkp2000 = 7, 
            weapon_deagle = 5, 
            weapon_revolver = 6, 
            weapon_awp = 4, 
            weapon_ssg08 = 3, 
            weapon_scar20 = 2, 
            weapon_g3sg1 = 2
        };
        local v1654 = nil;
        v1654 = {
            weapon_flashbang = "Flashbang", 
            weapon_smokegrenade = "Smoke", 
            weapon_molotov = "Molotov", 
            weapon_hegrenade = "High Explosive", 
            weapon_decoy = "Decoy Grenade"
        };
        local v1655 = nil;
        local l_length_1 = l_vector_0().length;
        do
            local l_l_length_1_0 = l_length_1;
            v1655 = function(v1658)
                -- upvalues: l_band_0 (ref), l_l_length_1_0 (ref)
                local v1659 = l_band_0(v1658.m_fFlags, 1) == 1;
                local v1660 = v1658.m_flDuckAmount > 0;
                if not v1659 then
                    return v1660 and 6 or 5;
                elseif v1660 then
                    return 4;
                else
                    local v1661 = l_l_length_1_0(v1658.m_vecAbsVelocity);
                    if v1661 > 60 and v1661 < 70 then
                        return 3;
                    else
                        return v1661 >= 2 and 2 or 1;
                    end;
                end;
            end;
        end;
        l_length_1 = 0;
        local v1662 = nil;
        local v1663 = {};
        local v1664 = nil;
        v1664 = function(v1665)
            -- upvalues: v113 (ref), v1663 (ref), l_globals_0 (ref)
            local l_target_0 = v1665.target;
            local l_state_0 = v1665.state;
            local v1668 = v113(l_target_0);
            local v1669 = v1663[v1668];
            if v1669 == nil or l_state_0 == nil then
                v1669 = {
                    last_miss = 0, 
                    miss_count = 0
                };
                v1663[v1668] = v1669;
            end;
            if l_state_0 ~= nil then
                if l_globals_0.realtime - v1669.last_miss > 5 then
                    v1669.last_miss = l_globals_0.realtime;
                    v1669.miss_count = 0;
                end;
                v1669.miss_count = v1669.miss_count + 1;
            end;
        end;
        local function v1720(v1670)
            -- upvalues: v582 (ref), v1643 (ref), v1613 (ref), v1653 (ref), l_v583_5 (ref), v568 (ref), v113 (ref), v105 (ref), v109 (ref), v1655 (ref), l_dist_0 (ref), v1614 (ref), v1652 (ref), l_get_threat_0 (ref), v107 (ref), v1662 (ref), l_length_1 (ref), l_globals_0 (ref), v1616 (ref), v1610 (ref), v1645 (ref), l_v1204_1 (ref), v1615 (ref), l_v585_3 (ref), l_v1203_1 (ref), v1617 (ref), v1618 (ref), v1654 (ref), v1619 (ref), l_v1207_1 (ref), v575 (ref), v112 (ref), v1663 (ref), l_v1206_1 (ref), v1620 (ref), v1607 (ref), v1604 (ref), l_v1588_0 (ref)
            local l_v582_6 = v582;
            local v1672 = false;
            v1643 = {};
            l_v582_6.is_working = v1672;
            l_v582_6 = v1670.localplayer;
            v1672 = v1670.is_alive;
            if l_v582_6 == nil or not v1672 then
                return;
            else
                local l_eye_position_3 = v1670.eye_position;
                local l_weapon_info_2 = v1670.weapon_info;
                if not l_weapon_info_2 then
                    return;
                else
                    local v1675 = v1670.weapon:get_weapon_index();
                    local l_weapon_name_1 = l_weapon_info_2.weapon_name;
                    local l_weapon_type_0 = l_weapon_info_2.weapon_type;
                    local v1678 = nil;
                    if v1613 then
                        local v1679 = v1653[l_weapon_name_1];
                        local v1680 = l_v583_5[v1679];
                        if v1679 == nil or not v568(v1680.enabled) then
                            v1680 = l_v583_5[1];
                        end;
                        v1678 = {
                            distance = v568(v1680.distance), 
                            damage = v568(v1680.damage)
                        };
                    end;
                    local l_enemies_1 = v1670.enemies;
                    for v1682 = 1, #l_enemies_1 do
                        local v1683 = l_enemies_1[v1682];
                        local v1684 = v113(v1683);
                        local v1685 = v105(v1683);
                        local v1686 = v109(v1683);
                        local v1687 = v1655(v1683);
                        local v1688 = l_dist_0(l_eye_position_3, v1685);
                        local l_m_iHealth_0 = v1683.m_iHealth;
                        local v1690 = nil;
                        local v1691 = nil;
                        local v1692 = nil;
                        if v1678 ~= nil then
                            v1690 = v1614 and 2000 or v1678.distance;
                            v1691 = v1614 and 30 or v1678.damage;
                            v1692 = v1688 <= v1690 and l_m_iHealth_0 <= v1691;
                        end;
                        v1652[v1684] = {
                            player = v1683, 
                            state = v1687, 
                            distance = v1688, 
                            health = l_m_iHealth_0, 
                            is_active = not not v1692 and v1692, 
                            is_dormant = v1686
                        };
                    end;
                    local v1693 = l_get_threat_0();
                    if v1693 == nil then
                        return;
                    else
                        local v1694 = v105(v1693);
                        local v1695 = v107(v1693);
                        if v1695 == nil then
                            return;
                        else
                            local l_weapon_name_2 = v1695:get_weapon_info().weapon_name;
                            local v1697 = v113(v1693);
                            local v1698 = v1652[v1697];
                            if v1698 == nil or v1698.is_dormant then
                                return;
                            else
                                if v1697 ~= v1662 then
                                    l_length_1 = l_globals_0.realtime;
                                    v1662 = v1697;
                                end;
                                if v1616 and v1610 then
                                    v1645(l_v1204_1.options, {});
                                    v1645(l_v1204_1.doubletap, {});
                                end;
                                if v1613 then
                                    local l_distance_0 = v1698.distance;
                                    local l_health_0 = v1698.health;
                                    local v1701 = v1614 and 2000 or v1678.distance;
                                    local v1702 = v1614 and 30 or v1678.damage;
                                    if l_distance_0 <= v1701 and l_health_0 <= v1702 then
                                        v1645(v1615 and l_v585_3.enabled or l_v1203_1, "Force");
                                    end;
                                end;
                                if v1617 then
                                    if v1618["Enemy is using nades"] and v1654[l_weapon_name_2] ~= nil then
                                        v1645(l_v1203_1, "Prefer");
                                        v1698.is_active = true;
                                    end;
                                    if v1618["Enemy is switching weapon"] and v1693.m_flNextAttack - 0.1 > l_globals_0.curtime then
                                        v1645(l_v1203_1, "Prefer");
                                        v1698.is_active = true;
                                    end;
                                    if v1618["Enemy is shooting"] and v1695.m_fLastShotTime > l_globals_0.curtime - 0.04 then
                                        v1645(l_v1203_1, "Prefer");
                                        v1698.is_active = true;
                                    end;
                                end;
                                if v1619.Distance then
                                    local l_distance_1 = v1698.distance;
                                    local l_health_1 = v1698.health;
                                    if l_distance_1 > 1150 and l_health_1 >= 91 then
                                        if v1675 == 40 then
                                            v1645(l_v1207_1.main, 70);
                                        end;
                                        if v1675 ~= 38 and v1675 ~= 9 and v1675 ~= 11 then
                                            v1645(l_v1203_1, "Default");
                                        end;
                                        v1698.is_active = true;
                                    end;
                                end;
                                if v1619.Condition then
                                    local l_distance_2 = v1698.distance;
                                    local l_health_2 = v1698.health;
                                    if v1698.state == 4 and l_distance_2 >= 350 and l_health_2 >= 91 and l_eye_position_3.z <= v1694.z and v1675 ~= 38 and v1675 ~= 9 and v1675 ~= 11 then
                                        v1645(l_v1203_1, "Default");
                                        v1698.is_active = true;
                                    end;
                                    local v1707 = v1655(l_v582_6);
                                    if v1707 == 1 or v1707 == 4 or v1707 == 3 then
                                        local v1708 = v575["Min. Damage"];
                                        if not (v1708 ~= nil and v1708.active) and l_health_2 < 85 and (v1675 == 9 and v112(v1693) or v1675 == 40) and l_distance_2 >= 800 then
                                            v1645(l_v1203_1, "Default");
                                            v1645(l_v1207_1.main, 85);
                                            v1698.is_active = true;
                                        end;
                                    end;
                                end;
                                if v1619.Air then
                                    local l_distance_3 = v1698.distance;
                                    local v1710 = v1655(l_v582_6);
                                    if (v1710 == 6 or v1710 == 5) and l_distance_3 > 200 and (v1675 == 40 or v1675 == 64) then
                                        v1645(l_v1203_1, "Default");
                                        v1698.is_active = true;
                                    end;
                                end;
                                local v1711 = v575["Min. Damage"];
                                local v1712 = v1711 ~= nil and v1711.active;
                                if v1619["Min Damage"] and v1712 and (v1675 == 40 or v1675 == 9 or v1675 == 1) then
                                    v1645(l_v1203_1, "Default");
                                    v1698.is_active = true;
                                end;
                                if v1619.Multipoint and (v1675 == 9 or v1675 == 40) then
                                    local v1713 = v1663[v1697];
                                    if v1713 and l_globals_0.realtime - v1713.last_miss < 5 and v1713.miss_count > 2 then
                                        v1645(l_v1206_1.head_scale, 60);
                                        v1645(l_v1206_1.body_scale, 60);
                                        v1698.is_active = true;
                                    end;
                                end;
                                if v1620.Revolver and v1675 == 64 then
                                    v1645(l_v1204_1.autopeek, {});
                                    v1698.is_active = true;
                                end;
                                if v1620.Advanced and l_globals_0.realtime - l_length_1 > 1.5 then
                                    if (v1675 == 40 or v1675 == 9 or l_weapon_type_0 == 1) and l_v582_6.m_iHealth <= 92 then
                                        v1645(l_v1207_1.doubletap, 0);
                                        v1645(l_v1204_1.autopeek, {});
                                        v1698.is_active = true;
                                    end;
                                    if v1675 == 40 then
                                        if l_v582_6.m_iHealth <= 92 and v1607 > 0 then
                                            v1645(l_v1204_1.autopeek, {});
                                            v1698.is_active = true;
                                        end;
                                        local l_player_0 = v1698.player;
                                        local v1715 = 0;
                                        if l_player_0 ~= nil then
                                            local v1716 = l_player_0:get_resource();
                                            v1715 = v1716 ~= nil and v1716.m_iPing or 0;
                                        end;
                                        if v1715 > 50 then
                                            v1645(l_v1204_1.autopeek, {});
                                            v1698.is_active = true;
                                        end;
                                        if v1604 and v1715 < 50 and l_v1588_0 and v1607 == 0 then
                                            v1645(l_v1204_1.autopeek, {
                                                [1] = "Full Stop"
                                            });
                                            v1698.is_active = true;
                                        end;
                                    end;
                                end;
                                local l_player_1 = v1698.player;
                                local v1718 = 0;
                                if l_player_1 ~= nil then
                                    local v1719 = l_player_1:get_resource();
                                    v1718 = v1719 ~= nil and v1719.m_iPing or 0;
                                end;
                                if v1712 and v1620["Min Damage"] and v1718 < 70 and l_v1588_0 then
                                    v1645(l_v1204_1.autopeek, {
                                        [1] = "Full Stop"
                                    });
                                    v1698.is_active = true;
                                end;
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        local v1721 = l_color_0();
        local function v1739(v1722)
            -- upvalues: v574 (ref), l_v585_3 (ref), l_v1203_1 (ref), l_v1204_1 (ref), l_v1205_1 (ref), l_v1206_1 (ref), l_v1207_1 (ref), l_v1582_0 (ref), l_v1583_0 (ref), l_v1584_0 (ref), l_v1585_0 (ref), l_v1586_0 (ref), v1606 (ref), v2 (ref), v1621 (ref), v1643 (ref), l_text_0 (ref), l_vector_0 (ref), v1721 (ref), v1622 (ref), v568 (ref), l_random_int_0 (ref), v110 (ref), v106 (ref), l_trace_bullet_0 (ref), v582 (ref), l_globals_0 (ref), v119 (ref), l_color_0 (ref), l_format_0 (ref), l_clamp_0 (ref)
            v574(l_v585_3.enabled);
            v574(l_v585_3.disablers);
            v574(l_v1203_1);
            v574(l_v1204_1.enabled);
            v574(l_v1204_1.options);
            v574(l_v1204_1.doubletap);
            v574(l_v1204_1.autopeek);
            v574(l_v1205_1);
            v574(l_v1206_1.enabled);
            v574(l_v1206_1.head_scale);
            v574(l_v1206_1.body_scale);
            v574(l_v1207_1.main);
            v574(l_v1207_1.doubletap);
            v574(l_v1582_0);
            v574(l_v1583_0);
            v574(l_v1584_0);
            v574(l_v1585_0);
            v574(l_v1586_0);
            v574(v1606);
            local l_localplayer_6 = v1722.localplayer;
            local l_is_alive_3 = v1722.is_alive;
            if l_localplayer_6 == nil or not l_is_alive_3 then
                return;
            else
                if v2 and v1621 then
                    local v1725 = 500;
                    for v1726 = 1, #v1643 do
                        local v1727 = v1643[v1726];
                        l_text_0(1, l_vector_0(10, v1725), v1721, nil, v1727);
                        v1725 = v1725 + 10;
                    end;
                end;
                local l_eye_position_4 = v1722.eye_position;
                local l_weapon_info_3 = v1722.weapon_info;
                if not l_weapon_info_3 then
                    return;
                else
                    local l_weapon_type_1 = l_weapon_info_3.weapon_type;
                    if l_weapon_type_1 == 9 or l_weapon_type_1 == 0 then
                        return;
                    else
                        if v1622 then
                            local v1731 = v568(l_v1583_0) / 3;
                            local v1732 = l_random_int_0(0, 100);
                            local l_enemies_2 = v1722.enemies;
                            for v1734 = 1, #l_enemies_2 do
                                local v1735 = l_enemies_2[v1734];
                                if v110(v1735) then
                                    local v1736 = v106(v1735);
                                    local v1737 = l_trace_bullet_0(l_localplayer_6, l_eye_position_4, v1736);
                                    if v1737 > 0 then
                                        if not v582.render_mda and v1732 >= 65 and v1737 > v1731 then
                                            v582.render_mda = l_globals_0.realtime;
                                        end;
                                        if not v582.render_mda2 and v1737 <= v1731 and v1732 >= 80 then
                                            v582.render_mda2 = l_globals_0.realtime;
                                        end;
                                    end;
                                end;
                            end;
                            if v582.render_mda then
                                if l_globals_0.realtime - v582.render_mda <= 0.5 then
                                    local v1738 = v568(l_v1207_1.main);
                                    l_text_0(2, v119 + l_vector_0(20, -30), l_color_0(), nil, l_format_0("    AIMTOOLS DEBUG:\n    CAN ATTACK\n    HC: ( %s: %s )\n    ", v1738, l_clamp_0(l_random_int_0(v1738 - 20, v1738 - 10), 0, 100)));
                                end;
                                if l_globals_0.realtime - v582.render_mda > 5 then
                                    v582.render_mda = nil;
                                end;
                            elseif v582.render_mda2 then
                                if l_globals_0.realtime - v582.render_mda2 <= 0.5 then
                                    l_text_0(2, v119 + l_vector_0(20, -30), l_color_0(), nil, "    AIMTOOLS DEBUG:\n    CANT ATTACK\n    ");
                                end;
                                if l_globals_0.realtime - v582.render_mda2 > 5 then
                                    v582.render_mda2 = nil;
                                end;
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
        if v0 == 3 then
            local v1740 = nil;
            local v1741 = nil;
            local v1742 = nil;
            local v1743 = nil;
            do
                local l_v1740_0, l_v1741_0, l_v1742_0, l_v1743_0 = v1740, v1741, v1742, v1743;
                local function v1751(v1748)
                    -- upvalues: v1612 (ref), l_get_local_player_0 (ref), v110 (ref), v109 (ref), v113 (ref), v1652 (ref), l_v1740_0 (ref), l_v1742_0 (ref), l_v1741_0 (ref), l_v1743_0 (ref)
                    if not v1612 then
                        return;
                    else
                        local v1749 = l_get_local_player_0();
                        if v1749 == nil or not v110(v1749) then
                            return;
                        elseif not v1748 or not v110(v1748) or v109(v1748) then
                            return;
                        else
                            local v1750 = v1652[v113(v1748)];
                            if v1750 == nil then
                                return;
                            elseif l_v1740_0 then
                                if v1750.is_active then
                                    return "\a" .. l_v1742_0 .. l_v1741_0;
                                else
                                    return;
                                end;
                            else
                                return "\a" .. (v1750.is_active and l_v1742_0 or l_v1743_0) .. l_v1741_0;
                            end;
                        end;
                    end;
                end;
                local v1752 = esp.enemy:new_text("Aim Tools", "Aim", v1751):create();
                local v1753 = v1752:switch("Custom Name");
                local v1754 = v1752:input("\n input");
                local function v1757()
                    -- upvalues: v568 (ref), v1753 (ref), v1754 (ref), l_gsub_0 (ref), l_v1741_0 (ref)
                    local v1755 = v568(v1753);
                    local v1756 = v568(v1754);
                    if not v1755 or l_gsub_0(v1756, " ", "") == "" then
                        l_v1741_0 = "AIM";
                        return;
                    else
                        l_v1741_0 = v1756;
                        return;
                    end;
                end;
                v1753:set_callback(v1757, true);
                v1754:set_callback(v1757, true);
                v1753:set_callback(function(v1758)
                    -- upvalues: v1754 (ref), v568 (ref)
                    v1754:visibility(v568(v1758));
                end, true);
                v1752:switch("Active Only"):set_callback(function(v1759)
                    -- upvalues: l_v1740_0 (ref), v568 (ref)
                    l_v1740_0 = v568(v1759);
                end, true);
                v1753:color_picker({
                    Enabled = {
                        l_color_0(124, 195, 13)
                    }, 
                    Disabled = {
                        l_color_0(248, 0, 13)
                    }
                }):set_callback(function(v1760)
                    -- upvalues: l_v1742_0 (ref), l_v1743_0 (ref), v568 (ref)
                    local v1761 = v568(v1760, "Enabled")[1]:to_hex();
                    l_v1743_0 = v568(v1760, "Disabled")[1]:to_hex();
                    l_v1742_0 = v1761;
                end, true);
            end;
        end;
        v582.enabled:set_callback(function()
            -- upvalues: l_events_0 (ref), v1664 (ref), v1612 (ref), v502 (ref), v1720 (ref), v1739 (ref)
            l_events_0.aim_ack(v1664, v1612);
            v502("Aim Tools")("createmove", v1720, v1612);
            v502("Aim Tools")("render", v1739, v1612);
        end, true);
    end;
    if v0 == 3 then
        v583 = nil;
        v583 = {};
        v584 = nil;
        v585 = nil;
        v1203 = {};
        v1204 = l_vector_0().length;
        do
            local l_v583_6 = v583;
            do
                local l_v584_4, l_v585_4, l_v1203_2, l_v1204_2 = v584, v585, v1203, v1204;
                v1205 = function(v1767)
                    -- upvalues: l_v584_4 (ref), l_get_threat_0 (ref), v108 (ref), l_v1204_2 (ref), l_floor_0 (ref), l_pow_0 (ref), l_v583_6 (ref), v113 (ref)
                    if not l_v584_4:get() then
                        return;
                    else
                        local l_localplayer_7 = v1767.localplayer;
                        local l_is_alive_4 = v1767.is_alive;
                        if l_localplayer_7 == nil or not l_is_alive_4 then
                            return;
                        else
                            local l_eye_position_5 = v1767.eye_position;
                            local l_weapon_info_4 = v1767.weapon_info;
                            if not l_weapon_info_4 then
                                return;
                            else
                                local v1772 = l_get_threat_0();
                                if not v1772 then
                                    return;
                                else
                                    local v1773 = v108(v1772, 3);
                                    local v1774 = l_v1204_2(v1773 - l_eye_position_5);
                                    local v1775 = l_floor_0(l_weapon_info_4.damage * l_pow_0(l_weapon_info_4.range_modifier, v1774 / 500) + l_weapon_info_4.range_modifier * 5.5);
                                    if v1772.m_ArmorValue == 0 then
                                        v1775 = v1775 + (v1775 - v1775 * (l_weapon_info_4.armor_ratio * 0.5));
                                    end;
                                    l_v583_6[v113(v1772)] = l_floor_0(v1775);
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;
                v1206 = function(v1776)
                    -- upvalues: v113 (ref), l_v583_6 (ref), l_v585_4 (ref), l_format_0 (ref), v112 (ref), l_v1203_2 (ref), l_to_hex_0 (ref)
                    local v1777 = l_v583_6[v113(v1776)];
                    if not v1777 then
                        return;
                    else
                        local v1778 = l_v585_4 == "-" and "-" or l_v585_4 == "+" and "+" or "";
                        local v1779 = l_format_0("%s %d %s", v1778, v1777, v1778);
                        local v1780 = v112(v1776) and l_v1203_2.Visible or l_v1203_2.Unvisible;
                        return ("\a" .. l_to_hex_0(v1780)) .. v1779;
                    end;
                end;
                l_v584_4 = esp.enemy:new_text("Damage", "Damage", v1206);
                v1582 = l_v584_4:create():combo("Style ", "-", "+", "Only Damage");
                v1582:set_callback(function(v1781)
                    -- upvalues: l_v585_4 (ref), v568 (ref)
                    l_v585_4 = v568(v1781);
                end, true);
                v1582:color_picker({
                    Visible = {
                        l_color_0(255, 0, 0, 255)
                    }, 
                    Unvisible = {
                        l_color_0()
                    }
                }):set_callback(function(v1782)
                    -- upvalues: l_ipairs_0 (ref), l_v1203_2 (ref), v568 (ref)
                    local v1783 = v1782:list();
                    for _, v1785 in l_ipairs_0(v1783) do
                        l_v1203_2[v1785] = v568(v1782, v1785)[1];
                    end;
                end, true);
                v502("Penetration Damage")("createmove", v1205);
            end;
        end;
    end;
    v583 = nil;
    v583 = {
        len = 0
    };
    v584 = function()
        return false;
    end;
    do
        local l_v584_5 = v584;
        v585 = function(v1787)
            -- upvalues: v583 (ref), v109 (ref), v110 (ref), v113 (ref), v108 (ref), l_trace_bullet_0 (ref), l_v584_5 (ref)
            v583 = {};
            v583.len = 0;
            local l_localplayer_8 = v1787.localplayer;
            local l_is_alive_5 = v1787.is_alive;
            if l_localplayer_8 == nil or not l_is_alive_5 then
                return;
            else
                local l_eye_position_6 = v1787.eye_position;
                local l_all_enemies_1 = v1787.all_enemies;
                for v1792 = 1, #l_all_enemies_1 do
                    local v1793 = l_all_enemies_1[v1792];
                    if v109(v1793) and v110(v1793) then
                        local v1794 = v1793:get_network_state();
                        if v1794 == 1 or v1794 == 2 or v1794 == 3 or v1794 == 4 then
                            local v1795 = v113(v1793);
                            local v1796 = v108(v1793, 3);
                            if l_trace_bullet_0(l_localplayer_8, l_eye_position_6, v1796, l_v584_5) > 0 then
                                v583[v1795] = true;
                                v583.len = v583.len + 1;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
        if v0 == 3 then
            v1203 = function(v1797)
                -- upvalues: v109 (ref), v110 (ref), v113 (ref), v583 (ref)
                if v109(v1797) and v110(v1797) and v583[v113(v1797)] ~= nil then
                    return "DA";
                else
                    return;
                end;
            end;
            esp.enemy:new_text("Dormant Aimbot", "DA", v1203);
        end;
        v502("Dormant Aimbot")("createmove", v585);
    end;
    v584 = nil;
    v584 = v566.animation_breaker;
    v585 = nil;
    v1203 = nil;
    v1204 = nil;
    v1205 = nil;
    v1206 = nil;
    v1207 = nil;
    v1582 = nil;
    v1583 = nil;
    do
        local l_v585_5, l_v1203_3, l_v1204_3, l_v1205_2, l_v1206_2, l_v1207_2, l_v1582_1, l_v1583_1, l_v1584_1, l_v1586_1, l_v1587_0, l_v1588_1 = v585, v1203, v1204, v1205, v1206, v1207, v1582, v1583, v1584, v1586, v1587, v1588;
        v584.leg_movement.enabled:set_callback(function(v1810)
            -- upvalues: l_v585_5 (ref), v568 (ref)
            l_v585_5 = v568(v1810);
        end, true);
        v584.leg_movement.selection:set_callback(function(v1811)
            -- upvalues: l_v1203_3 (ref), v568 (ref)
            l_v1203_3 = v568(v1811);
        end, true);
        v584.sliding_slowwalk:set_callback(function(v1812)
            -- upvalues: l_v1204_3 (ref), v568 (ref)
            l_v1204_3 = v568(v1812);
        end, true);
        v584.in_air.enabled:set_callback(function(v1813)
            -- upvalues: l_v1205_2 (ref), v568 (ref)
            l_v1205_2 = v568(v1813);
        end, true);
        v584.in_air.selection:set_callback(function(v1814)
            -- upvalues: l_v1206_2 (ref), v568 (ref)
            l_v1206_2 = v568(v1814);
        end, true);
        v584.legacy_force_falling:set_callback(function(v1815)
            -- upvalues: l_v1207_2 (ref), v568 (ref)
            l_v1207_2 = v568(v1815);
        end, true);
        l_v1584_1 = function()
            -- upvalues: v568 (ref), v584 (ref), l_v1582_1 (ref)
            local v1816 = v568(v584.move_lean.enabled);
            local v1817 = v568(v584.move_lean.force) * 0.01;
            l_v1582_1 = v1816 and v1817 or 0;
        end;
        v584.move_lean.enabled:set_callback(l_v1584_1, true);
        v584.move_lean.force:set_callback(l_v1584_1, true);
        v584.landing_pitch:set_callback(function(v1818)
            -- upvalues: l_v1583_1 (ref), v568 (ref)
            l_v1583_1 = v568(v1818);
        end, true);
        l_v1584_1 = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement");
        v1585 = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk");
        l_v1586_1 = nil;
        v1585:set_callback(function(v1819)
            -- upvalues: l_v1586_1 (ref), v568 (ref)
            l_v1586_1 = v568(v1819);
        end, true);
        l_v1587_0 = 1;
        l_v1588_1 = 0;
        local v1820 = 10640;
        local v1821 = ffi.typeof("            struct {\n                char pad0[0x18];\n                uint32_t sequence;\n                float prev_cycle;\n                float weight;\n                float weight_delta_rate;\n                float playback_rate;\n                float cycle;\n                void *entity;\n                char pad1[0x4];\n            } **\n        ");
        local v1822 = 39264;
        local v1823 = ffi.typeof("            struct {\t\t\t\t\t\t\t\t\t\tchar pad0[0x18];\n                float\t\tanim_update_timer;\t\t\t\tchar pad1[0xC];\n                float\t\tstarted_moving_time;\n                float\t\tlast_move_time;\t\t\t\t\tchar pad2[0x10];\n                float\t\tlast_lby_time;\t\t\t\t\tchar pad3[0x8];\n                float\t\trun_amount;\t\t\t\t\t\tchar pad4[0x10];\n                void*\t\tentity;\n                void*\t\tactive_weapon;\n                void*\t\tlast_active_weapon;\n                float\t\tlast_client_side_animation_update_time;\n                int\t\t\tlast_client_side_animation_update_framecount;\n                float\t\teye_timer;\n                float\t\teye_angles_y;\n                float\t\teye_angles_x;\n                float\t\tgoal_feet_yaw;\n                float\t\tcurrent_feet_yaw;\n                float\t\ttorso_yaw;\n                float\t\tlast_move_yaw;\n                float\t\tlean_amount;\t\t\t\t\tchar pad5[0x4];\n                float\t\tfeet_cycle;\n                float\t\tfeet_yaw_rate;\t\t\t\t\tchar pad6[0x4];\n                float\t\tduck_amount;\n                float\t\tlanding_duck_amount;\t\t\tchar pad7[0x4];\n                float\t\tcurrent_origin[3];\n                float\t\tlast_origin[3];\n                float\t\tvelocity_x;\n                float\t\tvelocity_y;\t\t\t\t\t\tchar pad8[0x4];\n                float\t\tunknown_float1;\t\t\t\t\tchar pad9[0x8];\n                float\t\tunknown_float2;\n                float\t\tunknown_float3;\n                float\t\tunknown;\n                float\t\tm_velocity;\n                float\t\tjump_fall_velocity;\n                float\t\tclamped_velocity;\n                float\t\tfeet_speed_forwards_or_sideways;\n                float\t\tfeet_speed_unknown_forwards_or_sideways;\n                float\t\tlast_time_started_moving;\n                float\t\tlast_time_stopped_moving;\n                bool\t\ton_ground;\n                bool\t\thit_in_ground_animation;\n                char pad10[0x4];\n                float\t\ttime_since_in_air;\n                float\t\tlast_origin_z;\n                float\t\thead_from_ground_distance_standing;\n                float\t\tstop_to_full_running_fraction;\tchar pad11[0x4];\n                float\t\tmagic_fraction;\t\t\t\t\tchar pad12[0x3C];\n                float\t\tworld_force;\t\t\t\t\tchar pad13[0x1CA];\n                float\t\tmin_yaw;\n                float\t\tmax_yaw;\n            } **\n        ");
        local function v1828(v1824, v1825)
            -- upvalues: v574 (ref), l_v1584_1 (ref), l_v1588_1 (ref), l_band_0 (ref), l_v1587_0 (ref), l_v1586_1 (ref), l_v1204_3 (ref), l_v585_5 (ref), l_v1203_3 (ref)
            local l_localplayer_9 = v1824.localplayer;
            local l_is_alive_6 = v1824.is_alive;
            if l_localplayer_9 == nil or not l_is_alive_6 then
                return v574(l_v1584_1);
            else
                l_v1588_1 = v1825.in_use and 9999 or not (not (l_band_0(l_localplayer_9.m_fFlags, l_v1587_0) ~= 0) or v1825.in_jump) and l_v1588_1 + 1 or 0;
                if l_v1586_1 and l_v1204_3 then
                    v574(l_v1584_1, "Walking");
                elseif l_v585_5 then
                    v574(l_v1584_1, l_v1203_3 == "Walking" and "Walking" or "Sliding");
                else
                    v574(l_v1584_1);
                end;
                return;
            end;
        end;
        local v1834 = {
            Static = function(v1829)
                v1829.m_flPoseParameter[0] = 1;
            end, 
            Jitter = function(v1830)
                -- upvalues: l_random_int_0 (ref), l_globals_0 (ref)
                local v1831 = l_random_int_0(1, 3);
                local v1832;
                if l_globals_0.choked_commands > 3 then
                    v1832 = l_globals_0.tickcount % 3 == v1831 and 0.63 or 1;
                else
                    v1832 = (not (l_globals_0.tickcount % 4 ~= 1) or l_globals_0.tickcount % 4 == 2) and 0.83 + v1831 * 0.01 or 1;
                end;
                v1830.m_flPoseParameter[0] = v1832;
            end, 
            Walking = function(v1833)
                v1833.m_flPoseParameter[7] = 0.5;
            end
        };
        local v1838 = {
            Static = function(v1835)
                v1835.m_flPoseParameter[6] = 1;
            end, 
            Walking = function(_, v1837)
                v1837[6].weight = 1;
            end
        };
        local function v1846(v1839)
            -- upvalues: l_get_local_player_0 (ref), v110 (ref), l_cast_0 (ref), v1821 (ref), v1820 (ref), v1822 (ref), v1823 (ref), l_v1588_1 (ref), l_v585_5 (ref), v1834 (ref), l_v1203_3 (ref), l_v1204_3 (ref), l_v1586_1 (ref), l_v1207_2 (ref), l_v1205_2 (ref), v1838 (ref), l_v1206_2 (ref), l_v1582_1 (ref), l_v1583_1 (ref)
            local v1840 = l_get_local_player_0();
            if v1839 ~= v1840 or v1840 == nil or not v110(v1840) then
                return;
            else
                local v1841 = v1840[0];
                local v1842 = l_cast_0("char*", v1841);
                local v1843 = l_cast_0(v1821, v1842 + v1820)[0];
                local v1844 = l_cast_0("char*", v1841) + v1822;
                if v1844 == nil then
                    return;
                else
                    local v1845 = l_cast_0(v1823, v1844);
                    if v1845 == nil then
                        return;
                    else
                        v1845 = v1845[0];
                        if l_v1588_1 ~= 0 then
                            if l_v585_5 then
                                v1834[l_v1203_3](v1840);
                            end;
                            if l_v1204_3 and l_v1586_1 then
                                v1840.m_flPoseParameter[9] = 0;
                            end;
                        else
                            if l_v1207_2 then
                                v1840.m_flPoseParameter[6] = 1;
                                v1845.time_since_in_air = 1;
                            end;
                            if l_v1205_2 then
                                v1838[l_v1206_2](v1840, v1843);
                            end;
                            v1843[12].weight = l_v1582_1;
                        end;
                        if l_v1583_1 and l_v1588_1 > 3 and l_v1588_1 < 60 then
                            v1840.m_flPoseParameter[12] = 0.5;
                        end;
                        return;
                    end;
                end;
            end;
        end;
        v584.enabled:set_callback(function(v1847)
            -- upvalues: v568 (ref), v502 (ref), v1828 (ref), l_events_0 (ref), v1846 (ref), v574 (ref), l_v1584_1 (ref)
            local v1848 = v568(v1847);
            v502("Animation Breaker")("createmove", v1828, v1848);
            l_events_0.post_update_clientside_animation(v1846, v1848);
            v574(l_v1584_1);
        end, true);
    end;
    v585 = nil;
    v585 = v566.damage_indicator;
    v1203 = nil;
    v1204 = nil;
    v1205 = nil;
    v1206 = nil;
    v1207 = nil;
    do
        local l_v1203_4, l_v1204_4, l_v1205_3, l_v1206_3, l_v1207_3, l_v1582_2, l_v1583_2 = v1203, v1204, v1205, v1206, v1207, v1582, v1583;
        v585.enabled:set_callback(function(v1856)
            -- upvalues: l_v1203_4 (ref), v568 (ref)
            l_v1203_4 = v568(v1856);
        end, true);
        v585.font:set_callback(function(v1857)
            -- upvalues: l_v1204_4 (ref), v568 (ref), v562 (ref)
            l_v1204_4 = v568(v1857);
            l_v1204_4 = l_v1204_4 == "Default" and 1 or v562;
        end, true);
        v585.color:set_callback(function(v1858)
            -- upvalues: l_v1205_3 (ref), v568 (ref)
            l_v1205_3 = v568(v1858);
        end, true);
        v585.style:set_callback(function(v1859)
            -- upvalues: l_v1206_3 (ref), v568 (ref)
            l_v1206_3 = v568(v1859);
        end, true);
        v585.show_on_damage:set_callback(function(v1860)
            -- upvalues: l_v1207_3 (ref), v568 (ref)
            l_v1207_3 = v568(v1860);
        end, true);
        l_v1582_2 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
        l_v1583_2 = v503("damage indicator", l_vector_0(v119.x + 10, v119.y - 20));
        v1584 = function(v1861)
            -- upvalues: v539 (ref), l_v1203_4 (ref), l_v1583_2 (ref), v575 (ref), l_v1206_3 (ref), l_v1207_3 (ref), v568 (ref), l_v1582_2 (ref), l_v1204_4 (ref), l_tostring_0 (ref), l_measure_text_0 (ref), l_v1205_3 (ref), l_text_0 (ref), l_vector_0 (ref), v576 (ref), l_rect_outline_0 (ref), l_color_0 (ref)
            local v1862 = v539("damage indicator", l_v1203_4, 0, 1, 0.025);
            if v1862 == 0 then
                return;
            else
                local l_localplayer_10 = v1861.localplayer;
                local l_is_alive_7 = v1861.is_alive;
                if l_localplayer_10 == nil or not l_is_alive_7 then
                    return;
                else
                    local v1865 = l_v1583_2:get_position();
                    local v1866 = v575["Min. Damage"];
                    local v1867 = v1866 ~= nil and v1866.active;
                    if l_v1206_3 == 1 and l_v1207_3 and not v1867 then
                        return;
                    else
                        local v1868 = v568(l_v1582_2);
                        if v1868 == 0 then
                            v1868 = l_v1204_4 == 1 and "Auto" or "AUTO";
                        end;
                        local v1869 = l_tostring_0(v1868);
                        local v1870 = l_measure_text_0(l_v1204_4, nil, v1869);
                        l_v1205_3.a = 255 * v1862;
                        l_text_0(l_v1204_4, v1865, l_v1205_3, nil, v1869);
                        if l_v1206_3 == 2 then
                            l_text_0(l_v1204_4, v1865 - l_vector_0(30, 0), l_v1205_3, nil, v1867 and "1" or "0");
                        end;
                        if v576 == 0 then
                            return;
                        else
                            local v1871 = l_v1206_3 == 2 and l_vector_0(30, 0) or l_vector_0();
                            l_rect_outline_0(v1865 - v1871 - l_vector_0(1, 1), v1865 + v1870 + l_vector_0(1, 1), l_color_0(255, 255 * v1862), 1, 4);
                            l_v1583_2:update(v1870, v1871);
                            return;
                        end;
                    end;
                end;
            end;
        end;
        v502("Damage Indicator")("render", v1584);
    end;
    v1203 = nil;
    v1203 = v566.damage_marker;
    v1204 = nil;
    v1205 = nil;
    v1206 = nil;
    do
        local l_v1204_5, l_v1205_4, l_v1206_4, l_v1207_4, l_v1582_3, l_v1583_3, l_v1584_2 = v1204, v1205, v1206, v1207, v1582, v1583, v1584;
        v1203.color:set_callback(function(v1879)
            -- upvalues: l_v1204_5 (ref), v568 (ref)
            l_v1204_5 = v568(v1879);
        end, true);
        v1203.font:set_callback(function(v1880)
            -- upvalues: l_v1205_4 (ref), v568 (ref), v562 (ref)
            l_v1205_4 = v568(v1880);
            l_v1205_4 = l_v1205_4 == "Default" and 1 or l_v1205_4 == "Pixel" and v562 or 4;
        end, true);
        v1203.animation:set_callback(function(v1881)
            -- upvalues: l_v1206_4 (ref), v568 (ref)
            l_v1206_4 = v568(v1881);
        end, true);
        l_v1207_4 = {};
        l_v1582_3 = l_vector_0().to_screen;
        l_v1583_3 = function(v1882)
            -- upvalues: l_v1207_4 (ref), l_globals_0 (ref), l_v1582_3 (ref), l_v1204_5 (ref), l_v1206_4 (ref), l_floor_0 (ref), l_text_0 (ref), l_v1205_4 (ref), l_remove_0 (ref)
            if #l_v1207_4 == 0 then
                return;
            else
                local l_localplayer_11 = v1882.localplayer;
                local l_is_alive_8 = v1882.is_alive;
                if l_localplayer_11 == nil or not l_is_alive_8 then
                    return;
                else
                    local l_realtime_2 = l_globals_0.realtime;
                    for v1886 = 1, #l_v1207_4 do
                        local v1887 = l_v1207_4[v1886];
                        if v1887 ~= nil then
                            local l_position_0 = v1887.position;
                            local l_damage_0 = v1887.damage;
                            local v1890 = l_realtime_2 - v1887.realtime;
                            l_position_0 = l_v1582_3(l_position_0);
                            if l_position_0 ~= nil then
                                local v1891 = 1;
                                if v1890 < 1 then
                                    v1891 = v1890;
                                elseif v1890 > 3 then
                                    v1891 = 4 - v1890;
                                end;
                                l_v1204_5.a = 255 * v1891;
                                local v1892 = l_v1206_4 and l_floor_0(l_damage_0 * v1891) or l_damage_0;
                                l_text_0(l_v1205_4, l_position_0, l_v1204_5, nil, v1892);
                                if v1891 < 0 then
                                    l_remove_0(l_v1207_4, v1886);
                                end;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
        l_v1584_2 = function(v1893)
            -- upvalues: l_v1207_4 (ref), l_globals_0 (ref)
            if v1893.state ~= nil then
                return;
            else
                l_v1207_4[#l_v1207_4 + 1] = {
                    position = v1893.aim, 
                    damage = v1893.damage, 
                    realtime = l_globals_0.realtime
                };
                return;
            end;
        end;
        v1203.enabled:set_callback(function(v1894)
            -- upvalues: v568 (ref), v502 (ref), l_v1583_3 (ref), l_events_0 (ref), l_v1584_2 (ref)
            local v1895 = v568(v1894);
            v502("Damage Marker")("render", l_v1583_3, v1895);
            l_events_0.aim_ack(l_v1584_2, v1895);
        end, true);
    end;
    v1204 = nil;
    v1204 = v566.crosshair_indicators;
    v1205 = nil;
    v1206 = nil;
    v1207 = nil;
    v1582 = nil;
    v1583 = nil;
    v1584 = nil;
    do
        local l_v1205_5, l_v1206_5, l_v1207_5, l_v1582_4, l_v1583_4, l_v1584_3, l_v1588_2 = v1205, v1206, v1207, v1582, v1583, v1584, v1588;
        v1204.enabled:set_callback(function(v1903)
            -- upvalues: l_v1205_5 (ref), v568 (ref)
            l_v1205_5 = v568(v1903);
        end, true);
        v1204.mode:set_callback(function(v1904)
            -- upvalues: l_v1206_5 (ref), v568 (ref)
            l_v1206_5 = v568(v1904);
        end, true);
        v1204.selection:set_callback(function(v1905)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v1207_5 (ref), l_v1582_4 (ref), l_v1583_4 (ref)
            local v1906 = v1905:list();
            for _, v1908 in l_ipairs_0(v1906) do
                v1906[v1908] = v568(v1905, v1908);
            end;
            l_v1207_5 = v568(v1905, "Version");
            l_v1582_4 = v568(v1905, "Side");
            l_v1583_4 = v568(v1905, "Binds");
        end, true);
        v1204.color:set_callback(function(v1909)
            -- upvalues: l_v1584_3 (ref), v568 (ref)
            l_v1584_3 = v568(v1909);
        end, true);
        v1585 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
        v1586 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
        v1587 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
        l_v1588_2 = nil;
        local v1910 = nil;
        local v1911 = nil;
        v1585:set_callback(function(v1912)
            -- upvalues: l_v1588_2 (ref), v568 (ref)
            l_v1588_2 = v568(v1912);
        end, true);
        v1586:set_callback(function(v1913)
            -- upvalues: v1910 (ref), v568 (ref)
            v1910 = v568(v1913);
        end, true);
        v1587:set_callback(function(v1914)
            -- upvalues: v1911 (ref), v568 (ref)
            v1911 = v568(v1914);
        end, true);
        local v1915 = 0;
        local function v1970(v1916)
            -- upvalues: v539 (ref), l_v1205_5 (ref), l_globals_0 (ref), v1915 (ref), v543 (ref), l_min_0 (ref), l_alpha_modulate_0 (ref), l_v1584_3 (ref), v119 (ref), l_v1206_5 (ref), l_v1207_5 (ref), v0 (ref), l_format_0 (ref), l_to_hex_0 (ref), l_color_0 (ref), l_measure_text_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_v1582_4 (ref), v577 (ref), l_floor_0 (ref), l_v1583_4 (ref), v575 (ref), l_get_1 (ref), l_exploit_0 (ref), l_v1588_2 (ref), v1910 (ref), v1911 (ref), v562 (ref), l_push_clip_rect_0 (ref), l_pop_clip_rect_0 (ref)
            local v1917 = v539("crosshair indicators", l_v1205_5, 0, 1, 0.025);
            if v1917 == 0 then
                return;
            else
                local l_localplayer_12 = v1916.localplayer;
                local l_is_alive_9 = v1916.is_alive;
                if l_localplayer_12 == nil or not l_is_alive_9 then
                    return;
                else
                    local l_frametime_0 = l_globals_0.frametime;
                    local l_weapon_info_5 = v1916.weapon_info;
                    if l_weapon_info_5 then
                        local v1922 = l_weapon_info_5.weapon_type ~= 9 and 1 or 0.5;
                        if v1915 < v1922 then
                            v1915 = v543(1, v1915, l_frametime_0 * 4, 2);
                            v1915 = l_min_0(v1922, v1915);
                        elseif v1922 < v1915 then
                            v1915 = v543(-1, v1915, l_frametime_0 * -4, -2);
                        end;
                        v1917 = v1917 * v1915;
                    end;
                    local v1923 = 255 * v1917;
                    local v1924 = l_alpha_modulate_0(l_v1584_3, v1923);
                    local l_x_0 = v119.x;
                    local l_y_2 = v119.y;
                    local v1927 = l_x_0 + 2;
                    l_y_2 = l_y_2 + 35;
                    l_x_0 = v1927;
                    v1927 = l_localplayer_12.m_bIsScoped;
                    local v1928 = v539("crosshair indicators -> adjusting position in scope", v1927, 0, 1, 0.125);
                    local v1929 = "OUTLAW";
                    if l_v1206_5 == 1 then
                        if l_v1207_5 then
                            v1929 = v0 == 1 and "OUTLAW" or v0 == 2 and l_format_0("OUTLAW  \a%s[+]", l_to_hex_0(l_color_0(248, 153, 153, 255 * v1915))) or l_format_0("OUTLAW  \a%s[BETA]", l_to_hex_0(l_color_0(248, 153, 153, 255 * v1915)));
                        end;
                        local v1930 = ((l_measure_text_0(2, nil, v1929) * 0.5).x + 7) * v1928;
                        l_text_0(2, l_vector_0(l_x_0 + v1930, l_y_2), v1924, "c", v1929);
                        l_y_2 = l_y_2 + 8;
                        if l_v1582_4 then
                            local v1931 = l_format_0("SIDE:  \a%s%s", l_to_hex_0(v1924), v577.inverter and "L" or "R");
                            local v1932 = l_measure_text_0(2, nil, v1931) * 0.5;
                            v1932.x = l_floor_0(v1932.x);
                            local v1933 = (v1932.x + 7) * v1928;
                            l_text_0(2, l_vector_0(l_x_0 + v1933 - v1932.x, l_y_2 - 6), l_color_0(248, 153, 153, v1923), nil, v1931);
                            l_y_2 = l_y_2 + 9;
                        end;
                        if l_v1583_4 then
                            local v1934 = v575["Min. Damage"];
                            local v1935 = v575["Safe Points"];
                            local v1936 = v575["Body Aim"];
                            local v1937 = v575["Fake Latency"];
                            local v1938 = {
                                [1] = {
                                    text = "RAPID", 
                                    color = l_get_1(l_exploit_0) == 1 and l_color_0(212) or l_color_0(255, 0, 0), 
                                    active = l_v1588_2
                                }, 
                                [2] = {
                                    text = "OS-AA", 
                                    color = l_color_0(130, 194, 18), 
                                    active = v1910
                                }, 
                                [3] = {
                                    text = "DMG", 
                                    color = l_color_0(212), 
                                    active = v1934 ~= nil and v1934.active
                                }, 
                                [4] = {
                                    text = "SAFE", 
                                    color = l_color_0(212), 
                                    active = v1935 ~= nil and v1935.active
                                }, 
                                [5] = {
                                    text = "BAIM", 
                                    color = l_color_0(212), 
                                    active = v1936 ~= nil and v1936.active
                                }, 
                                [6] = {
                                    text = "PING", 
                                    color = l_color_0(130, 194, 18), 
                                    active = v1937 ~= nil and v1937.active
                                }, 
                                [7] = {
                                    text = "DUCK", 
                                    color = l_color_0(212), 
                                    active = v1911
                                }
                            };
                            for v1939 = 1, #v1938 do
                                local v1940 = v1938[v1939];
                                local l_text_1 = v1940.text;
                                local l_color_1 = v1940.color;
                                local l_active_0 = v1940.active;
                                local v1944 = l_measure_text_0(v562, nil, l_text_1) * 0.5;
                                local v1945 = (v1944.x + 7) * v1928;
                                local v1946 = v539("crosshair indicators -> bind alpha: " .. l_text_1, l_active_0, 0, 1, 0.0365);
                                if v1946 > 0 then
                                    l_push_clip_rect_0(l_vector_0(l_x_0 - (v1944.x + v1945), l_y_2 - v1944.y), l_vector_0(l_x_0 + (v1944.x + v1945), l_y_2 + v1944.y));
                                    l_text_0(v562, l_vector_0(l_x_0 + v1945, l_y_2), l_alpha_modulate_0(l_color_1, v1924.a * v1946), "c", l_text_1);
                                    l_pop_clip_rect_0();
                                    l_y_2 = l_y_2 + 8 * v1946;
                                end;
                            end;
                        end;
                    else
                        v1929 = v0 == 1 and "OUTLAW" or v0 == 2 and l_format_0("OUTLAW  \a%s[+]", l_to_hex_0(l_color_0(248, 153, 153, 255 * v1915))) or l_format_0("OUTLAW  \a%s[BETA]", l_to_hex_0(l_color_0(248, 153, 153, 255 * v1915)));
                        l_x_0 = l_x_0 + 5;
                        l_y_2 = l_y_2 - 10;
                        l_text_0(2, l_vector_0(l_x_0, l_y_2), v1924, nil, v1929);
                        l_y_2 = l_y_2 + 9;
                        local v1947 = l_color_0(255, 255, 255);
                        local l_v1947_0 = v1947;
                        if l_v1588_2 then
                            l_v1947_0 = l_get_1(l_exploit_0) == 1 and l_color_0(130, 196, 17) or l_color_0(255, 0, 0);
                        end;
                        local v1949 = v539("crosshair indicators -> doubletap", l_v1588_2, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0, l_y_2), l_alpha_modulate_0(l_v1947_0, 255 * v1949), nil, "DT");
                        local v1950 = v539("crosshair indicators -> hideshots", v1910, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0 + 12, l_y_2), l_alpha_modulate_0(v1947, 255 * v1950), nil, "OS");
                        l_y_2 = l_y_2 + 9;
                        local v1951 = v575["Dormant Aimbot"];
                        local v1952 = v1951 ~= nil and v1951.active;
                        local v1953 = v539("crosshair indicators -> dormant aimbot", v1952, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0, l_y_2), l_alpha_modulate_0(v1947, 255 * v1953), nil, "DA");
                        local v1954 = v575["Peek Assist"];
                        local v1955 = v1954 ~= nil and v1954.active;
                        local v1956 = v539("crosshair indicators -> quick peek", v1955, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0 + 12, l_y_2), l_alpha_modulate_0(v1947, 255 * v1956), nil, "QP");
                        local v1957 = v575["Fake Latency"];
                        local v1958 = v1957 ~= nil and v1957.active;
                        local l_v1947_1 = v1947;
                        if v1958 then
                            l_v1947_1 = l_get_1(l_exploit_0) == 1 and l_color_0(130, 196, 17) or l_color_0(255);
                        end;
                        local v1960 = v539("crosshair indicators -> ping", v1958, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0 + 26, l_y_2), l_alpha_modulate_0(l_v1947_1, 255 * v1960), nil, "PING");
                        l_y_2 = l_y_2 + 9;
                        local v1961 = v575["Min. Damage"];
                        local v1962 = v1961 ~= nil and v1961.active;
                        local v1963 = v539("crosshair indicators -> dmg", v1962, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0, l_y_2), l_alpha_modulate_0(v1947, 255 * v1963), nil, "DMG");
                        local v1964 = v575["Safe Points"];
                        local v1965 = is_safe_point ~= nil and v1964.active;
                        local v1966 = v539("crosshair indicators -> safe point", v1965, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0 + 19, l_y_2), l_alpha_modulate_0(v1947, 255 * v1966), nil, "SP");
                        local v1967 = v575["Body Aim"];
                        local v1968 = v1967 ~= nil and v1967.active;
                        local v1969 = v539("crosshair indicators -> body aim", v1968, 0.5, 1, 0.02);
                        l_text_0(2, l_vector_0(l_x_0 + 32, l_y_2), l_alpha_modulate_0(v1947, 255 * v1969), nil, "BODY");
                    end;
                    return;
                end;
            end;
        end;
        v502("Crosshair Indicators")("render", v1970);
    end;
    v1205 = nil;
    v1205 = v566.manual_arrows;
    v1206 = nil;
    v1207 = nil;
    v1582 = nil;
    v1583 = nil;
    v1584 = nil;
    do
        local l_v1206_6, l_v1207_6, l_v1582_5, l_v1583_5, l_v1584_4, l_v1585_1, l_v1586_2, l_v1587_1 = v1206, v1207, v1582, v1583, v1584, v1585, v1586, v1587;
        v1205.enabled:set_callback(function(v1979)
            -- upvalues: l_v1206_6 (ref), v568 (ref)
            l_v1206_6 = v568(v1979);
        end, true);
        v1205.color:set_callback(function(v1980)
            -- upvalues: l_v1207_6 (ref), v568 (ref)
            l_v1207_6 = v568(v1980);
        end, true);
        v1205.options:set_callback(function(v1981)
            -- upvalues: l_v1582_5 (ref), l_v1583_5 (ref), v568 (ref)
            local v1982 = v568(v1981, "Show Active Only");
            l_v1583_5 = v568(v1981, "Hide in Scope");
            l_v1582_5 = v1982;
        end, true);
        v1205.type:set_callback(function(v1983)
            -- upvalues: l_v1584_4 (ref), v568 (ref)
            l_v1584_4 = v568(v1983);
        end, true);
        l_v1585_1 = v119.x;
        l_v1586_2 = v119.y;
        l_v1587_1 = v577.manual_yaw;
        v1588 = function(v1984)
            -- upvalues: v539 (ref), l_v1206_6 (ref), l_v1583_5 (ref), l_v1587_1 (ref), v577 (ref), l_v1584_4 (ref), l_v1207_6 (ref), l_rect_0 (ref), l_vector_0 (ref), l_v1585_1 (ref), l_v1586_2 (ref), l_color_0 (ref), l_poly_0 (ref), l_v1582_5 (ref), l_line_0 (ref)
            local v1985 = v539("Manual Arrows -> Enabled", l_v1206_6, 0, 1, 0.025);
            if v1985 == 0 then
                return;
            else
                local l_localplayer_13 = v1984.localplayer;
                local l_is_alive_10 = v1984.is_alive;
                if l_localplayer_13 == nil or not l_is_alive_10 then
                    return;
                else
                    local v1988 = v539("Manual Arrows -> Scope", not l_localplayer_13.m_bIsScoped, l_v1583_5 and 0 or 0.5, 1, 0.035);
                    local l_yaw_3 = l_v1587_1.yaw;
                    local l_inverter_1 = v577.inverter;
                    local v1991 = l_yaw_3 == -90;
                    local v1992 = l_yaw_3 == 90;
                    if l_v1584_4 == 1 then
                        l_v1207_6.a = 225 * v1985 * v1988;
                        l_rect_0(l_vector_0(l_v1585_1 + 44, l_v1586_2 - 7), l_vector_0(l_v1585_1 + 46, l_v1586_2 + 9), l_inverter_1 and l_v1207_6 or l_color_0(35, 35, 35, (l_inverter_1 and 225 or 150) * v1985));
                        l_rect_0(l_vector_0(l_v1585_1 - 46, l_v1586_2 - 7), l_vector_0(l_v1585_1 - 44, l_v1586_2 + 9), not l_inverter_1 and l_v1207_6 or l_color_0(35, 35, 35, (l_inverter_1 and 225 or 150) * v1985));
                        l_poly_0(v1991 and l_v1207_6 or l_color_0(35, 35, 35, (v1991 and 225 or 150) * v1985), l_vector_0(l_v1585_1 - 59, l_v1586_2 + 1), l_vector_0(l_v1585_1 - 47, l_v1586_2 - 7), l_vector_0(l_v1585_1 - 47, l_v1586_2 + 9));
                        l_poly_0(v1992 and l_v1207_6 or l_color_0(35, 35, 35, (v1992 and 225 or 150) * v1985), l_vector_0(l_v1585_1 + 59, l_v1586_2 + 1), l_vector_0(l_v1585_1 + 47, l_v1586_2 - 7), l_vector_0(l_v1585_1 + 47, l_v1586_2 + 9));
                    elseif l_v1584_4 == 2 then
                        local v1993 = v539("Manual Arrows -> Left", v1991, l_v1582_5 and 0 or 0.5, 1, 0.025);
                        local v1994 = v539("Manual Arrows -> Right", v1992, l_v1582_5 and 0 or 0.5, 1, 0.035);
                        local v1995 = v1985 * v1993 * v1988 * 255;
                        v1994 = v1985 * v1994 * v1988 * 255;
                        l_v1207_6.a = v1995;
                        l_line_0(l_vector_0(l_v1585_1 - 50, l_v1586_2 - 5), l_vector_0(l_v1585_1 - 54, l_v1586_2), l_v1207_6);
                        l_line_0(l_vector_0(l_v1585_1 - 50, l_v1586_2 + 5), l_vector_0(l_v1585_1 - 54, l_v1586_2), l_v1207_6);
                        l_v1207_6.a = v1994;
                        l_line_0(l_vector_0(l_v1585_1 + 50, l_v1586_2 - 5), l_vector_0(l_v1585_1 + 54, l_v1586_2), l_v1207_6);
                        l_line_0(l_vector_0(l_v1585_1 + 50, l_v1586_2 + 5), l_vector_0(l_v1585_1 + 54, l_v1586_2), l_v1207_6);
                    end;
                    return;
                end;
            end;
        end;
        v502("Manual Arrows")("render", v1588);
    end;
    v1206 = nil;
    v1206 = v566.disablers;
    v1207 = cvar.violence_ablood;
    v1582 = cvar.violence_hblood;
    v1583 = cvar.r_cleardecals;
    v1584 = nil;
    v1585 = nil;
    do
        local l_v1207_7, l_v1582_6, l_v1583_6, l_v1584_5, l_v1585_2 = v1207, v1582, v1583, v1584, v1585;
        v1206:set_callback(function(v2001)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v1584_5 (ref), l_v1585_2 (ref)
            local v2002 = v2001:list();
            for _, v2004 in l_ipairs_0(v2002) do
                v2002[v2004] = v568(v2001, v2004);
            end;
            local v2005 = #v568(v2001) > 0;
            l_v1585_2 = v2002;
            l_v1584_5 = v2005;
        end, true);
        v1586 = function()
            -- upvalues: l_v1585_2 (ref), l_v1207_7 (ref), l_v1582_6 (ref), l_v1583_6 (ref)
            local v2006 = l_v1585_2.Blood and 0 or 1;
            l_v1207_7:int(v2006);
            l_v1582_6:int(v2006);
            l_v1583_6:call();
        end;
        v1587 = function()
            -- upvalues: l_v1585_2 (ref), l_get_local_player_0 (ref), l_get_players_0 (ref), v111 (ref), l_cast_0 (ref)
            if not l_v1585_2["Teammate Rendering"] then
                return;
            else
                local v2007 = l_get_local_player_0();
                local v2008 = l_get_players_0(false, true);
                for v2009 = 1, #v2008 do
                    local v2010 = v2008[v2009];
                    if not v111(v2010) and v2010 ~= v2007 then
                        l_cast_0("bool*", l_cast_0("unsigned int", v2010[0]) + 628)[0] = false;
                    end;
                end;
                return;
            end;
        end;
        v1588 = function(v2011)
            -- upvalues: l_v1584_5 (ref), l_get_local_player_0 (ref), l_v1585_2 (ref)
            if not l_v1584_5 then
                return;
            else
                local v2012 = l_get_local_player_0();
                local l_entity_3 = v2011.entity;
                if l_entity_3 == nil or l_entity_3 ~= v2012 then
                    return;
                else
                    local v2014 = l_entity_3:get_name();
                    if l_v1585_2["Arms in 3-rd"] and v2014 == "CEconWearable" or l_v1585_2["Weapon in 3-rd"] and v2014 == "CBaseWeaponWorldModel" then
                        return false;
                    else
                        return;
                    end;
                end;
            end;
        end;
        local function v2015()
            -- upvalues: l_v1207_7 (ref), l_v1582_6 (ref), l_v1583_6 (ref)
            l_v1207_7:int(1);
            l_v1582_6:int(1);
            l_v1583_6:call();
        end;
        l_events_0.localplayer_transparency(v1587);
        l_events_0.draw_model(v1588);
        l_events_0.shutdown(v2015);
        v1206:set_callback(v1586, true);
        l_v1207_7:set_callback(v1586);
        l_v1582_6:set_callback(v1586);
    end;
    v1207 = nil;
    v1207 = v566.gamesense_indicators;
    v1582 = nil;
    v1583 = nil;
    v1582 = {
        planting_time = 3.125
    };
    v1584 = function(v2016, v2017)
        local v2018 = 0.5;
        local v2019 = 0.5;
        if v2017 and v2017 > 0 then
            local v2020 = v2016 * v2018;
            if v2017 < (v2016 - v2020) * v2019 then
                v2020 = v2016 - v2017 * (1 / v2019);
            end;
            v2016 = v2020;
        end;
        return v2016;
    end;
    do
        local l_v1582_7, l_v1583_7, l_v1584_6, l_v1585_3, l_v1586_3, l_v1587_2, l_v1588_3 = v1582, v1583, v1584, v1585, v1586, v1587, v1588;
        do
            local l_l_v1584_6_0 = l_v1584_6;
            l_v1583_7 = function(v2029, v2030, v2031)
                -- upvalues: v106 (ref), l_dist_0 (ref), l_exp_0 (ref), l_floor_0 (ref), l_l_v1584_6_0 (ref), l_max_0 (ref)
                if v2029 == nil then
                    return;
                else
                    local v2032 = v106(v2029);
                    local v2033 = l_dist_0(v2032, v106(v2030));
                    local v2034 = 500;
                    local v2035 = v2034 * 3.5;
                    v2034 = v2034 * l_exp_0(-(v2033 * v2033 / (v2035 * 2 * 0.3 * (v2035 * 0.3))));
                    return (l_floor_0(l_l_v1584_6_0(l_max_0(v2034, 0), v2031)));
                end;
            end;
            l_v1585_3 = function()
                -- upvalues: l_v1582_7 (ref)
                l_v1582_7.planting_site = nil;
            end;
            l_v1586_3 = function(v2036)
                -- upvalues: l_get_player_resource_0 (ref), l_v1582_7 (ref), l_get_0 (ref), l_lerp_0 (ref), l_distsqr_0 (ref), l_globals_0 (ref)
                local v2037 = l_get_player_resource_0();
                if v2037 == nil then
                    l_v1582_7.planting_site = nil;
                    return;
                else
                    local v2038 = l_get_0(v2036.site);
                    if v2038 == nil then
                        l_v1582_7.planting_site = nil;
                        return;
                    else
                        local l_m_bombsiteCenterA_0 = v2037.m_bombsiteCenterA;
                        local l_m_bombsiteCenterB_0 = v2037.m_bombsiteCenterB;
                        local l_m_vecMins_0 = v2038.m_vecMins;
                        local l_m_vecMaxs_0 = v2038.m_vecMaxs;
                        local v2043 = l_lerp_0(l_m_vecMins_0, l_m_vecMaxs_0, 0.5);
                        l_v1582_7.planting_site = l_distsqr_0(v2043, l_m_bombsiteCenterA_0) < l_distsqr_0(v2043, l_m_bombsiteCenterB_0) and "A" or "B";
                        l_v1582_7.planting_started = l_globals_0.curtime;
                        return;
                    end;
                end;
            end;
            l_events_0.bomb_abortplant(l_v1585_3);
            l_events_0.bomb_planted(l_v1585_3);
            l_events_0.cs_win_panel_match(l_v1585_3);
            l_events_0.round_start(l_v1585_3);
            l_events_0.bomb_beginplant(l_v1586_3);
        end;
        l_v1584_6 = nil;
        l_v1585_3 = nil;
        v1207:set_callback(function(v2044)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v1584_6 (ref), l_v1585_3 (ref)
            local v2045 = v2044:list();
            for _, v2047 in l_ipairs_0(v2045) do
                v2045[v2047] = v568(v2044, v2047);
            end;
            local v2048 = #v568(v2044) > 0;
            l_v1585_3 = v2045;
            l_v1584_6 = v2048;
        end, true);
        l_v1586_3 = render.load_font("Calibri Bold", l_vector_0(24, 23, 0), "ad");
        l_v1587_2 = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", l_vector_0(30, 30));
        l_v1588_3 = cvar.hud_scaling;
        local v2049 = 0;
        local v2050 = nil;
        v2050 = {
            white = l_color_0(255, 200), 
            red = l_color_0(255, 0, 50), 
            t_red = l_color_0(255, 0, 50, 200), 
            yellow = l_color_0(200, 200, 102), 
            green = l_color_0(143, 194, 21, 200)
        };
        local v2051 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap");
        local v2052 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots");
        local v2053 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck");
        local v2054 = ui.find("Miscellaneous", "Main", "Other", "Fake Latency");
        local v2055 = nil;
        local v2056 = nil;
        local v2057 = nil;
        local v2058 = nil;
        local v2059 = nil;
        local v2060 = nil;
        v2051:set_callback(function(v2061)
            -- upvalues: v2055 (ref), v568 (ref)
            v2055 = v568(v2061);
        end, true);
        v2052:set_callback(function(v2062)
            -- upvalues: v2056 (ref), v568 (ref)
            v2056 = v568(v2062);
        end, true);
        v566.freestanding.enabled:set_callback(function(v2063)
            -- upvalues: v2057 (ref), v568 (ref)
            v2057 = v568(v2063);
        end, true);
        v2053:set_callback(function(v2064)
            -- upvalues: v2058 (ref), v568 (ref)
            v2058 = v568(v2064);
        end, true);
        v2054:set_callback(function(v2065)
            -- upvalues: v2060 (ref), v568 (ref), v2059 (ref)
            v2060 = v568(v2065);
            v2059 = v2060 > 0;
        end, true);
        local l_lerp_1 = l_color_0().lerp;
        local function v2105(v2067)
            -- upvalues: v2058 (ref), v2055 (ref), l_v1585_3 (ref), l_get_1 (ref), l_exploit_0 (ref), v2050 (ref), v2056 (ref), l_v1582_7 (ref), l_get_game_rules_0 (ref), l_globals_0 (ref), l_get_entities_0 (ref), l_format_0 (ref), l_v1583_7 (ref), l_rect_0 (ref), l_vector_0 (ref), v118 (ref), l_color_0 (ref), l_rect_outline_0 (ref), v2057 (ref), v575 (ref), v2059 (ref), l_net_channel_0 (ref), v2060 (ref), l_clamp_0 (ref), v2049 (ref), v541 (ref), l_lerp_1 (ref), v539 (ref), l_abs_0 (ref), v540 (ref), l_max_0 (ref), v583 (ref)
            local v2068 = {};
            local l_localplayer_14 = v2067.localplayer;
            local l_is_alive_11 = v2067.is_alive;
            if not v2058 then
                if v2055 then
                    if v2055 and l_v1585_3.DT then
                        local v2071 = l_get_1(l_exploit_0) == 1;
                        v2068[#v2068 + 1] = {
                            text = "DT", 
                            color = v2071 and v2050.white or v2050.t_red
                        };
                    end;
                elseif v2056 and l_v1585_3.OSAA then
                    v2068[#v2068 + 1] = {
                        text = "OSAA", 
                        color = v2050.white
                    };
                end;
            end;
            if l_v1585_3["Bomb Info"] then
                local l_planting_site_0 = l_v1582_7.planting_site;
                if l_planting_site_0 then
                    local v2073 = l_get_game_rules_0();
                    if v2073 then
                        local v2074 = l_v1582_7.planting_started + l_v1582_7.planting_time < v2073.m_fRoundStartTime + v2073.m_iRoundTime and v2050.yellow or v2050.t_red;
                        local v2075 = (l_globals_0.curtime - l_v1582_7.planting_started) / l_v1582_7.planting_time;
                        v2068[#v2068 + 1] = {
                            is_bomb = true, 
                            text = l_planting_site_0, 
                            color = v2074, 
                            percentage = v2075
                        };
                    end;
                end;
                local v2076 = l_get_entities_0("CPlantedC4", false);
                for v2077 = 1, #v2076 do
                    local v2078 = v2076[v2077];
                    if not v2078.m_bBombDefused and v2078.m_bBombTicking then
                        local v2079 = v2078.m_nBombSite == 0 and "A" or "B";
                        local v2080 = v2078.m_flC4Blow - l_globals_0.curtime;
                        if v2080 > 0 then
                            local v2081 = l_format_0("%s - %.1fs", v2079, v2080);
                            v2068[#v2068 + 1] = {
                                is_bomb = true, 
                                text = v2081, 
                                color = v2050.white
                            };
                            local l_m_iObserverMode_0 = l_localplayer_14.m_iObserverMode;
                            if l_m_iObserverMode_0 ~= 1 and l_m_iObserverMode_0 ~= 2 and l_m_iObserverMode_0 ~= 6 then
                                local v2083 = l_localplayer_14.m_hObserverTarget or l_localplayer_14;
                                local l_m_iHealth_1 = v2083.m_iHealth;
                                local l_m_ArmorValue_0 = v2083.m_ArmorValue;
                                local v2086 = l_v1583_7(v2083, v2078, l_m_ArmorValue_0);
                                if v2086 and v2086 > 0 then
                                    local v2087 = l_m_iHealth_1 <= v2086;
                                    local v2088 = v2087 and v2050.t_red or v2050.yellow;
                                    local v2089 = v2087 and "FATAL" or l_format_0("-%d HP", v2086);
                                    v2068[#v2068 + 1] = {
                                        is_bomb = true, 
                                        is_damage = true, 
                                        text = v2089, 
                                        color = v2088
                                    };
                                end;
                                local l_m_hBombDefuser_0 = v2078.m_hBombDefuser;
                                local l_m_flDefuseLength_0 = v2078.m_flDefuseLength;
                                local v2092 = l_m_hBombDefuser_0 and v2078.m_flDefuseCountDown - l_globals_0.curtime or -1;
                                if v2092 > 0 then
                                    l_rect_0(l_vector_0(), l_vector_0(16, v118.y), l_color_0(25, 160));
                                    l_rect_outline_0(l_vector_0(), l_vector_0(16, v118.y), l_color_0(25, 160));
                                    l_rect_0(l_vector_0(0, v118.y - (v118.y - 50) / l_m_flDefuseLength_0 * v2092), l_vector_0(16, v118.y), v2092 < v2080 and l_color_0(58, 191, 54, 160) or l_color_0(255, 0, 0, 125));
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if l_v1585_3.FS and v2057 then
                v2068[#v2068 + 1] = {
                    text = "FS", 
                    color = v2050.white
                };
            end;
            local v2093 = v575["Body Aim"];
            if l_v1585_3.BODY and v2093 ~= nil and v2093.active then
                v2068[#v2068 + 1] = {
                    text = "BODY", 
                    color = v2050.white
                };
            end;
            local v2094 = v575["Safe Points"];
            if l_v1585_3.SAFE and v2094 ~= nil and v2094.active then
                v2068[#v2068 + 1] = {
                    text = "SAFE", 
                    color = v2050.white
                };
            end;
            if l_v1585_3.DUCK and v2058 then
                v2068[#v2068 + 1] = {
                    text = "DUCK", 
                    color = v2050.white
                };
            end;
            if l_v1585_3.PING and v2059 then
                local v2095 = l_net_channel_0();
                local v2096 = 0;
                if v2095 then
                    v2096 = v2095.latency[0] + v2095.latency[1];
                end;
                local v2097 = v2096 / (v2060 * 0.001);
                v2097 = l_clamp_0(v2097, 0, 1);
                local v2098 = l_clamp_0(l_globals_0.frametime * 2 * 7.875, 0, 1);
                v2049 = v541(v2049, v2097, v2098);
                v2068[#v2068 + 1] = {
                    text = "PING", 
                    color = l_lerp_1(v2050.red, v2050.green, v2049)
                };
            end;
            local l_SLOW_0 = l_v1585_3.SLOW;
            local v2100 = l_is_alive_11 and l_localplayer_14.m_flVelocityModifier or 1;
            if l_SLOW_0 then
                local v2101 = 1;
                if v2100 == 1 then
                    v2101 = v539("Gamesense Indicators: Slow", v2100 == 1, 0, 6.01, 0.01, 6.01);
                    v2101 = l_abs_0(1 - v2101 % 2);
                else
                    v540["Gamesense Indicators: Slow"] = 0;
                end;
                if v540["Gamesense Indicators: Slow"] < 6.01 then
                    v2068[#v2068 + 1] = {
                        text = "SLOW", 
                        color = l_color_0(248 - 124 * v2100, 195 * v2100, 13, l_max_0(30, 200 * v2101))
                    };
                end;
            end;
            local v2102 = v575["Min. Damage"];
            if l_v1585_3.DAMAGE and v2102 ~= nil and v2102.active then
                v2068[#v2068 + 1] = {
                    text = "MD", 
                    color = v2050.white
                };
            end;
            local v2103 = v575["Hit Chance"];
            if l_v1585_3.HITCHANCE and v2103 ~= nil and v2103.active then
                v2068[#v2068 + 1] = {
                    text = "HC", 
                    color = v2050.white
                };
            end;
            local v2104 = v575["Dormant Aimbot"];
            if l_v1585_3.DA and v2104 ~= nil and v2104.active then
                v2068[#v2068 + 1] = {
                    text = "DA", 
                    color = v583.len > 0 and v2050.green or v2050.white
                };
            end;
            return v2068;
        end;
        local function v2121(v2106)
            -- upvalues: v2105 (ref), v118 (ref), l_v1588_3 (ref), l_measure_text_0 (ref), l_v1586_3 (ref), l_gradient_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_texture_0 (ref), l_v1587_2 (ref), l_circle_outline_0 (ref), v2050 (ref), l_text_0 (ref)
            local l_localplayer_15 = v2106.localplayer;
            local l_is_alive_12 = v2106.is_alive;
            if l_localplayer_15 == nil then
                return;
            else
                local v2109 = v2105(v2106);
                local v2110 = v118.y / 1.4 - l_v1588_3:float() * 55;
                for v2111 = #v2109, 1, -1 do
                    local v2112 = v2109[v2111];
                    local l_is_bomb_0 = v2112.is_bomb;
                    local l_percentage_0 = v2112.percentage;
                    local l_is_damage_0 = v2112.is_damage;
                    if l_is_bomb_0 or l_is_alive_12 then
                        local l_text_2 = v2112.text;
                        local l_color_2 = v2112.color;
                        local v2118 = (not l_is_bomb_0 or l_is_damage_0) and 7 or 40;
                        local v2119 = l_measure_text_0(l_v1586_3, nil, l_text_2) * 0.5 + v2118;
                        l_gradient_0(l_vector_0(9, v2110 - 4), l_vector_0(12 + v2119.x, v2110 + 26), l_color_0(0, 0), l_color_0(0, 80), l_color_0(0, 0), l_color_0(0, 80));
                        l_gradient_0(l_vector_0(12 + v2119.x, v2110 - 4), l_vector_0(23 + v2119.x * 2, v2110 + 26), l_color_0(0, 80), l_color_0(0, 0), l_color_0(0, 80), l_color_0(0, 0));
                        if l_is_bomb_0 then
                            if not l_is_damage_0 then
                                l_texture_0(l_v1587_2, l_vector_0(26, v2110 - 4), l_vector_0(30, 30), l_color_2);
                            end;
                            if l_percentage_0 then
                                local v2120 = v2119 * 2 - v2118;
                                l_circle_outline_0(l_vector_0(35 + v2120.x, v2110 + 10), l_color_0(0), 10, 0, 1, 5);
                                l_circle_outline_0(l_vector_0(35 + v2120.x, v2110 + 10), v2050.white, 9, 0, l_percentage_0, 3);
                            end;
                        end;
                        l_text_0(l_v1586_3, l_vector_0(20 + v2118, v2110), l_color_2, nil, l_text_2);
                        v2110 = v2110 - 40;
                    end;
                end;
                return;
            end;
        end;
        local function v2122()
            -- upvalues: v540 (ref)
            v540["Gamesense Indicators: Slow"] = 600;
        end;
        v1207:set_callback(function()
            -- upvalues: v502 (ref), v2121 (ref), l_v1584_6 (ref), l_events_0 (ref), v2122 (ref)
            v502("Gamesense Indicators")("render", v2121, l_v1584_6);
            l_events_0.round_start(v2122, l_v1584_6);
        end, true);
    end;
    v1582 = nil;
    v1582 = v566.skeet_arrows;
    v1583 = ui.find("Visuals", "Players", "Enemies", "ESP", "Offscreen ESP");
    v1584 = nil;
    v1585 = nil;
    v1586 = nil;
    v1583:set_callback(function(v2123)
        -- upvalues: v574 (ref)
        v574(v2123);
        if enabled then
            v574(v2123, false);
        end;
    end);
    do
        local l_v1583_8, l_v1584_7, l_v1585_4, l_v1586_4, l_v1587_3, l_v1588_4 = v1583, v1584, v1585, v1586, v1587, v1588;
        v1582.radius:set_callback(function(v2130)
            -- upvalues: l_v1584_7 (ref), v568 (ref)
            l_v1584_7 = v568(v2130);
        end, true);
        v1582.size:set_callback(function(v2131)
            -- upvalues: l_v1585_4 (ref), v568 (ref)
            l_v1585_4 = v568(v2131) + 10;
        end, true);
        v1582.color:set_callback(function(v2132)
            -- upvalues: l_v1586_4 (ref), v568 (ref)
            l_v1586_4 = v568(v2132);
        end, true);
        l_v1587_3 = v119.x;
        l_v1588_4 = v119.y;
        local function v2138(v2133, v2134, v2135)
            -- upvalues: l_sin_0 (ref), l_cos_0 (ref)
            local v2136 = l_sin_0(v2133);
            local v2137 = l_cos_0(v2133);
            return v2134 * v2137 - v2135 * v2136, v2134 * v2136 + v2135 * v2137;
        end;
        local function v2154(v2139, v2140, v2141, v2142, v2143, v2144)
            -- upvalues: v2138 (ref), l_poly_0 (ref), l_vector_0 (ref)
            local v2145, v2146 = v2138(v2143, v2141 / 2, 0);
            local v2147, v2148 = v2138(v2143, 0, v2142);
            local v2149, v2150 = v2138(v2143, v2141, v2142);
            local v2151, v2152 = v2138(v2143, -v2141 / 2, -v2142 / 2);
            local v2153 = v2139 + v2151;
            v2140 = v2140 + v2152;
            v2139 = v2153;
            l_poly_0(v2144, l_vector_0(v2139 + v2145, v2140 + v2146), l_vector_0(v2139 + v2147, v2140 + v2148), l_vector_0(v2139 + v2149, v2140 + v2150));
        end;
        local function v2168(v2155)
            -- upvalues: l_sin_0 (ref), l_abs_0 (ref), l_pi_0 (ref), l_globals_0 (ref), l_v1586_4 (ref), v109 (ref), v110 (ref), l_get_offscreen_0 (ref), v105 (ref), l_atan2_0 (ref), l_v1588_4 (ref), l_v1587_3 (ref), l_rad_0 (ref), v2138 (ref), l_v1584_7 (ref), v2154 (ref), l_v1585_4 (ref)
            local l_localplayer_16 = v2155.localplayer;
            local l_is_alive_13 = v2155.is_alive;
            if l_localplayer_16 == nil or not l_is_alive_13 then
                return;
            else
                local v2158 = l_sin_0(l_abs_0(-l_pi_0 + l_globals_0.curtime * 1.5 % 6));
                if v2158 == 0 then
                    return;
                else
                    l_v1586_4.a = 255 * v2158;
                    local l_all_enemies_2 = v2155.all_enemies;
                    for v2160 = 1, #l_all_enemies_2 do
                        local v2161 = l_all_enemies_2[v2160];
                        if not v109(v2161) and v110(v2161) then
                            local v2162, _, v2164 = l_get_offscreen_0(v105(v2161), 100, false);
                            if v2164 then
                                local v2165 = l_atan2_0(v2162.y - l_v1588_4, v2162.x - l_v1587_3) + l_rad_0(90);
                                local v2166, v2167 = v2138(v2165, 0, -l_v1588_4 + (450 - l_v1584_7 * 4.5));
                                v2154(l_v1587_3 + v2166, l_v1588_4 + v2167, l_v1585_4 * 0.9, l_v1585_4, v2165, l_v1586_4);
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
        v1582.enabled:set_callback(function(v2169)
            -- upvalues: v568 (ref), v502 (ref), v2168 (ref), v574 (ref), l_v1583_8 (ref)
            local v2170 = v568(v2169);
            v502("Skeet Arrows")("render", v2168, v2170);
            v574(l_v1583_8);
            if v2170 then
                v574(l_v1583_8, false);
            end;
        end, true);
    end;
    v1583 = nil;
    v1583 = v566.custom_scope_overlay;
    v1584 = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay");
    v1585 = nil;
    v1586 = nil;
    v1587 = nil;
    v1588 = nil;
    local v2171 = nil;
    local v2172 = nil;
    do
        local l_v1584_8, l_v1585_5, l_v1586_5, l_v1587_4, l_v1588_5, l_v2171_0, l_v2172_0 = v1584, v1585, v1586, v1587, v1588, v2171, v2172;
        v1583.enabled:set_callback(function(v2180)
            -- upvalues: l_v1585_5 (ref), v568 (ref), v574 (ref), l_v1584_8 (ref)
            l_v1585_5 = v568(v2180);
            v574(l_v1584_8);
            if l_v1585_5 then
                v574(l_v1584_8, "Remove All");
            end;
        end, true);
        l_v1584_8:set_callback(function(v2181)
            -- upvalues: v574 (ref), l_v1585_5 (ref)
            v574(v2181);
            if l_v1585_5 then
                v574(v2181, "Remove All");
            end;
        end, true);
        v1583.line:set_callback(function(v2182)
            -- upvalues: l_v1586_5 (ref), v568 (ref)
            l_v1586_5 = v568(v2182) * 4.2;
        end, true);
        v1583.gap:set_callback(function(v2183)
            -- upvalues: l_v1587_4 (ref), v568 (ref)
            l_v1587_4 = v568(v2183) * 2.5;
        end, true);
        v1583.color:set_callback(function(v2184)
            -- upvalues: v568 (ref), l_v1588_5 (ref), l_v2171_0 (ref)
            local v2185, v2186 = v568(v2184);
            if v2185 == "Static" then
                local l_v2186_0 = v2186;
                l_v2171_0 = v2186;
                l_v1588_5 = l_v2186_0;
            elseif v2185 == "Gradient" then
                local v2188 = v2186[1];
                l_v2171_0 = v2186[2];
                l_v1588_5 = v2188;
            end;
        end, true);
        v1583.animation:set_callback(function(v2189)
            -- upvalues: l_v2172_0 (ref), v568 (ref)
            l_v2172_0 = v568(v2189) * 0.01;
            if l_v2172_0 == 0 then
                l_v2172_0 = 1;
            end;
        end, true);
        local v2190 = {};
        local function v2191()
            -- upvalues: v2190 (ref), v568 (ref), v1583 (ref), v119 (ref), l_vector_0 (ref), l_v1587_4 (ref), l_v1586_5 (ref), l_v1588_5 (ref), l_alpha_modulate_0 (ref), l_v2171_0 (ref)
            v2190 = {};
            if v568(v1583.lines, "Left") then
                v2190[#v2190 + 1] = {
                    positions = {
                        [1] = v119 - l_vector_0(l_v1587_4, -1), 
                        [2] = v119 - l_vector_0(l_v1586_5, 0)
                    }, 
                    colors = {
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0), 
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0)
                    }
                };
            end;
            if v568(v1583.lines, "Top") then
                v2190[#v2190 + 1] = {
                    positions = {
                        [1] = v119 - l_vector_0(0, l_v1587_4), 
                        [2] = v119 - l_vector_0(-1, l_v1586_5)
                    }, 
                    colors = {
                        l_v1588_5, 
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0), 
                        l_alpha_modulate_0(l_v2171_0, 0)
                    }
                };
            end;
            if v568(v1583.lines, "Right") then
                v2190[#v2190 + 1] = {
                    positions = {
                        [1] = v119 + l_vector_0(l_v1587_4 + 1, 0), 
                        [2] = v119 + l_vector_0(l_v1586_5, 1)
                    }, 
                    colors = {
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0), 
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0)
                    }
                };
            end;
            if v568(v1583.lines, "Bottom") then
                v2190[#v2190 + 1] = {
                    positions = {
                        [1] = v119 + l_vector_0(0, l_v1587_4 + 1), 
                        [2] = v119 + l_vector_0(1, l_v1586_5)
                    }, 
                    colors = {
                        l_v1588_5, 
                        l_v1588_5, 
                        l_alpha_modulate_0(l_v2171_0, 0), 
                        l_alpha_modulate_0(l_v2171_0, 0)
                    }
                };
            end;
        end;
        local function v2207(v2192)
            -- upvalues: v539 (ref), l_v1585_5 (ref), l_v2172_0 (ref), v2190 (ref), l_alpha_modulate_0 (ref), l_gradient_0 (ref)
            local v2193 = v539("custom scope overlay", l_v1585_5, 0, 1, 0.025);
            if v2193 == 0 then
                return;
            else
                local l_localplayer_17 = v2192.localplayer;
                local l_is_alive_14 = v2192.is_alive;
                if l_localplayer_17 == nil or not l_is_alive_14 then
                    return;
                else
                    local l_m_bIsScoped_1 = l_localplayer_17.m_bIsScoped;
                    local v2197 = v539("custom scope overlay scoped alpha", l_m_bIsScoped_1, 0, 1, l_v2172_0) * v2193;
                    if v2197 == 0 then
                        return;
                    else
                        for v2198 = 1, #v2190 do
                            local v2199 = v2190[v2198];
                            local v2200 = v2199.colors[1];
                            local v2201 = v2199.colors[2];
                            local v2202 = v2199.colors[3];
                            local v2203 = v2199.colors[4];
                            local v2204 = l_alpha_modulate_0(v2200, v2200.a * v2197);
                            local v2205 = l_alpha_modulate_0(v2201, v2201.a * v2197);
                            local v2206 = l_alpha_modulate_0(v2202, v2202.a * v2197);
                            v2203 = l_alpha_modulate_0(v2203, v2203.a * v2197);
                            l_gradient_0(v2199.positions[1], v2199.positions[2], v2204, v2205, v2206, v2203);
                        end;
                        return;
                    end;
                end;
            end;
        end;
        v1583.line:set_callback(v2191, true);
        v1583.gap:set_callback(v2191, true);
        v1583.lines:set_callback(v2191, true);
        v1583.color:set_callback(v2191, true);
        v502("Custom Scope Overlay")("render", v2207);
    end;
    v1584 = nil;
    v1584 = v566.wireframe_on_shot;
    v1585 = nil;
    v1586 = nil;
    v1587 = nil;
    v1588 = nil;
    v2171 = nil;
    v2172 = nil;
    do
        local l_v1585_6, l_v1586_6, l_v1587_5, l_v1588_6, l_v2171_1, l_v2172_1 = v1585, v1586, v1587, v1588, v2171, v2172;
        v1584.enabled:set_callback(function(v2214)
            -- upvalues: l_v1585_6 (ref), v568 (ref)
            l_v1585_6 = v568(v2214);
        end, true);
        v1584.color:set_callback(function(v2215)
            -- upvalues: v568 (ref), l_v1586_6 (ref), l_v1587_5 (ref), l_v1588_6 (ref), l_v2171_1 (ref)
            local v2216 = v568(v2215);
            local l_r_0 = v2216.r;
            local l_g_0 = v2216.g;
            local l_b_0 = v2216.b;
            l_v2171_1 = v2216.a;
            l_v1588_6 = l_b_0;
            l_v1587_5 = l_g_0;
            l_v1586_6 = l_r_0;
        end, true);
        v1584.duration:set_callback(function(v2220)
            -- upvalues: l_v2172_1 (ref), v568 (ref)
            l_v2172_1 = v568(v2220);
        end, true);
        local v2221 = ffi.typeof("float[1]");
        local v2222 = ffi.typeof("            struct {\n                float x;\n                float y;\n                float z;\n            }\n        ");
        local v2223 = ffi.typeof("            struct {\n                int id;\n                int version;\n                int checksum;\n                char name[64];\n                int length;\n                $ eyePosition;\n                $ illumPosition;\n                $ hullMin;\n                $ hullMax;\n                $ bbMin;\n                $ bbMax;\n                int flags;\n                int numBones;\n                int boneIndex;\n                int numBoneControllers;\n                int boneControllerIndex;\n                int numHitboxSets;\n                int hitboxSetIndex;\n            }\n        ", v2222, v2222, v2222, v2222, v2222, v2222);
        local v2224 = ffi.typeof("            struct {\n                int nameIndex;\n                int numHitboxes;\n                int hitboxIndex;\n            } *\n        ");
        local v2225 = ffi.typeof("            struct {\n                int bone;\n                int group;\n                $ bbMin;\n                $ bbMax;\n                int hitboxNameIndex;\n                $ offsetOrientation;\n                float capsuleRadius;\n                int unused[4];\n            } *\n        ", v2222, v2222, v2222);
        local v2226 = utils.get_vfunc("engine.dll", "VModelInfoClient004", 1, "void*(__thiscall*)(void*, int)");
        local v2227 = utils.get_vfunc("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)");
        local v2228 = utils.get_vfunc("engine.dll", "VModelInfoClient004", 32, ffi.typeof("$*(__thiscall*)(void*, void*)", v2223));
        local v2229 = utils.get_vfunc("engine.dll", "VDebugOverlay004", 23, ffi.typeof("void(__thiscall*)(void*, const $&, const $&, const float&, int, int, int, int, float)", v2222, v2222));
        local function v2241(v2230, v2231, v2232, v2233, v2234, v2235, v2236, v2237)
            -- upvalues: v2222 (ref), v2221 (ref), v2229 (ref)
            local v2238 = v2222(v2230.x, v2230.y, v2230.z);
            local v2239 = v2222(v2231.x, v2231.y, v2231.z);
            local v2240 = v2221(v2232);
            v2229(v2238, v2239, v2240, v2233, v2234, v2235, v2236, v2237);
        end;
        local function v2244(v2242, v2243)
            -- upvalues: l_vector_0 (ref)
            return l_vector_0(v2242.x * v2243[0] + v2242.y * v2243[1] + v2242.z * v2243[2] + v2243[3], v2242.x * v2243[4] + v2242.y * v2243[5] + v2242.z * v2243[6] + v2243[7], v2242.x * v2243[8] + v2242.y * v2243[9] + v2242.z * v2243[10] + v2243[11]);
        end;
        local v2245 = "float*";
        local v2246 = "uintptr_t";
        local v2247 = "uintptr_t*";
        local function v2250(v2248, v2249)
            -- upvalues: l_cast_0 (ref), v2245 (ref), v2247 (ref), v2246 (ref)
            return l_cast_0(v2245, l_cast_0(v2247, l_cast_0(v2246, v2248[0]) + 9896)[0] + 48 * v2249);
        end;
        local function v2260(v2251, v2252)
            -- upvalues: v2227 (ref), v2226 (ref), v2228 (ref), l_cast_0 (ref), v2224 (ref), v2246 (ref), v2225 (ref)
            local v2253 = v2227("models/" .. v2251:get_model_name());
            local v2254 = v2226(v2253);
            if v2254 == nil then
                return;
            else
                local v2255 = v2228(v2254);
                if v2255 == nil then
                    return;
                else
                    local v2256 = l_cast_0(v2224, l_cast_0(v2246, v2255) + v2255.hitboxSetIndex) + v2251.m_nHitboxSet;
                    local v2257 = {};
                    for v2258 = 1, #v2252 do
                        local v2259 = v2252[v2258];
                        v2257[v2259 % v2256.numHitboxes] = l_cast_0(v2225, l_cast_0(v2246, v2256) + v2256.hitboxIndex) + v2259 % v2256.numHitboxes;
                    end;
                    return v2257;
                end;
            end;
        end;
        local v2261 = {
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
            [12] = 15, 
            [13] = 16, 
            [14] = 17, 
            [15] = 18
        };
        local function v2268(v2262)
            -- upvalues: v2260 (ref), v2261 (ref), v2250 (ref), v2241 (ref), v2244 (ref), l_v1586_6 (ref), l_v1587_5 (ref), l_v1588_6 (ref), l_v2171_1 (ref), l_v2172_1 (ref)
            local l_target_1 = v2262.target;
            local v2264 = v2260(l_target_1, v2261);
            if v2264 == nil then
                return;
            else
                for v2265 = 1, #v2264 do
                    local v2266 = v2264[v2265];
                    if v2266 ~= nil then
                        local v2267 = v2250(l_target_1, v2266.bone);
                        if v2267 then
                            v2241(v2244(v2266.bbMin, v2267), v2244(v2266.bbMax, v2267), v2266.capsuleRadius, l_v1586_6, l_v1587_5, l_v1588_6, l_v2171_1, l_v2172_1);
                        end;
                    end;
                end;
                return;
            end;
        end;
        local v2269 = ui.find("Visuals", "Players", "Enemies", "Chams", "On Shot");
        local function v2270()
            -- upvalues: v574 (ref), v2269 (ref), l_v1585_6 (ref)
            v574(v2269);
            if l_v1585_6 then
                v574(v2269, false);
            end;
        end;
        v1584.enabled:set_callback(v2270, true);
        v2269:set_callback(v2270, true);
        v1584.enabled:set_callback(function()
            -- upvalues: l_events_0 (ref), v2268 (ref), l_v1585_6 (ref)
            l_events_0.aim_ack(v2268, l_v1585_6);
        end, true);
    end;
    v1585 = nil;
    v1585 = v566.zeus_warning;
    v1586 = nil;
    do
        local l_v1586_7, l_v1587_6, l_v1588_7, l_v2171_2 = v1586, v1587, v1588, v2171;
        v1585.color:set_callback(function(v2275)
            -- upvalues: l_v1586_7 (ref), v568 (ref)
            l_v1586_7 = v568(v2275);
        end, true);
        l_v1587_6 = nil;
        l_v1588_7 = nil;
        l_v1588_7 = l_vector_0(48, 48);
        l_v2171_2 = "nl\\melancholia\\zeus.png";
        local v2276;
        v2172, v2276 = l_pcall_0(render.load_image_from_file, l_v2171_2, l_v1588_7);
        do
            local l_l_v2171_2_0, l_v2276_0 = l_v2171_2, v2276;
            if not v2172 then
                network.get("https://northon.dev/neverlose/melancholia/zeus.png", {}, function(v2279)
                    -- upvalues: l_l_v2171_2_0 (ref), l_v2276_0 (ref), l_v1588_7 (ref)
                    if v2279 == nil or #v2279 == 0 then
                        return;
                    else
                        files.write(l_l_v2171_2_0, v2279, true);
                        l_v2276_0 = render.load_image_from_file(l_l_v2171_2_0, l_v1588_7);
                        return;
                    end;
                end);
            end;
            l_v1587_6 = l_v2276_0;
        end;
        l_v2171_2 = function(v2280)
            -- upvalues: l_sin_0 (ref), l_abs_0 (ref), l_pi_0 (ref), l_globals_0 (ref), l_v1586_7 (ref), v110 (ref), v107 (ref), v105 (ref), l_dist_0 (ref), l_texture_0 (ref), l_v1587_6 (ref), l_vector_0 (ref), l_v1588_7 (ref)
            local l_localplayer_18 = v2280.localplayer;
            local l_is_alive_15 = v2280.is_alive;
            if l_localplayer_18 == nil or not l_is_alive_15 then
                return;
            else
                local l_eye_position_7 = v2280.eye_position;
                l_v1586_7.a = 255 * l_sin_0(l_abs_0(-l_pi_0 + l_globals_0.curtime * 1.5 % 6));
                local l_enemies_3 = v2280.enemies;
                for v2285 = 1, #l_enemies_3 do
                    local v2286 = l_enemies_3[v2285];
                    if v110(v2286) then
                        local v2287 = v107(v2286);
                        if v2287 and v2287:get_weapon_index() == 31 then
                            local v2288 = v105(v2286);
                            if l_dist_0(l_eye_position_7, v2288) <= 800 then
                                local v2289 = v2286:get_bbox();
                                local l_pos1_0 = v2289.pos1;
                                local l_pos2_0 = v2289.pos2;
                                if l_pos1_0 and l_pos2_0 then
                                    l_pos2_0.y = l_pos1_0.y;
                                    local v2292 = l_pos1_0 + (l_pos2_0 - l_pos1_0) / 2;
                                    l_texture_0(l_v1587_6, v2292 - l_vector_0(24, 50), l_v1588_7, l_v1586_7);
                                end;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
        v1585.enabled:set_callback(function(v2293)
            -- upvalues: v502 (ref), l_v2171_2 (ref), v568 (ref)
            v502("Zeus Warning")("render", l_v2171_2, v568(v2293));
        end, true);
    end;
    v1586 = nil;
    v1586 = v566.grenade_radius;
    v1587 = nil;
    v1588 = nil;
    v2171 = nil;
    v2172 = nil;
    local v2294 = nil;
    local v2295 = nil;
    local v2296 = nil;
    do
        local l_v1587_7, l_v1588_8, l_v2171_3, l_v2172_2, l_v2294_0, l_v2295_0, l_v2296_0 = v1587, v1588, v2171, v2172, v2294, v2295, v2296;
        v1586.enabled:set_callback(function(v2304)
            -- upvalues: l_v1587_7 (ref), v568 (ref)
            l_v1587_7 = v568(v2304);
        end, true);
        v1586.render_mode:set_callback(function(v2305)
            -- upvalues: l_v1588_8 (ref), v568 (ref)
            l_v1588_8 = v568(v2305) == 1 and render.circle_3d or render.circle_3d_outline;
        end, true);
        v1586.fire.enabled:set_callback(function(v2306)
            -- upvalues: l_v2171_3 (ref), v568 (ref)
            l_v2171_3 = v568(v2306);
        end, true);
        v1586.fire.color:set_callback(function(v2307)
            -- upvalues: l_v2172_2 (ref), l_v2294_0 (ref), v568 (ref)
            local v2308 = v568(v2307, "Friendly")[1];
            l_v2294_0 = v568(v2307, "Enemy")[1];
            l_v2172_2 = v2308;
        end, true);
        v1586.smoke.enabled:set_callback(function(v2309)
            -- upvalues: l_v2295_0 (ref), v568 (ref)
            l_v2295_0 = v568(v2309);
        end, true);
        v1586.smoke.color:set_callback(function(v2310)
            -- upvalues: l_v2296_0 (ref), v568 (ref)
            l_v2296_0 = v568(v2310);
        end, true);
        local v2311 = 125;
        local v2312 = 17.55;
        local v2313 = 7.05;
        local function v2349(v2314)
            -- upvalues: v539 (ref), l_v1587_7 (ref), l_v2171_3 (ref), l_get_entities_0 (ref), l_ipairs_0 (ref), l_vector_0 (ref), l_dist2d_0 (ref), v106 (ref), l_lerp_0 (ref), l_globals_0 (ref), v2313 (ref), v111 (ref), l_v2294_0 (ref), l_v2172_2 (ref), l_alpha_modulate_0 (ref), l_v1588_8 (ref), l_v2295_0 (ref), v2312 (ref), v2311 (ref), l_v2296_0 (ref)
            local v2315 = v539("Grenade Radius", l_v1587_7, 0, 1, 0.025);
            if v2315 == 0 then
                return;
            elseif v2314.localplayer == nil then
                return;
            else
                local v2316 = v539("Grenade Radius: Fire", l_v2171_3, 0, 1, 0.025) * v2315;
                if v2316 > 0 then
                    local v2317 = l_get_entities_0("CInferno", true);
                    for _, v2319 in l_ipairs_0(v2317) do
                        local v2320 = {};
                        for v2321 = 1, 64 do
                            if v2319.m_bFireIsBurning[v2321] then
                                v2320[#v2320 + 1] = l_vector_0(v2319.m_fireXDelta[v2321], v2319.m_fireYDelta[v2321], v2319.m_fireZDelta[v2321]);
                            end;
                        end;
                        local v2322 = 0;
                        local v2323 = nil;
                        local v2324 = nil;
                        for v2325 = 1, #v2320 do
                            local v2326 = v2320[v2325];
                            for v2327 = 1, #v2320 do
                                local v2328 = v2320[v2327];
                                local v2329 = l_dist2d_0(v2326, v2328);
                                if v2322 < v2329 then
                                    v2322 = v2329;
                                    local l_v2326_0 = v2326;
                                    v2324 = v2328;
                                    v2323 = l_v2326_0;
                                end;
                            end;
                        end;
                        if v2323 and v2324 then
                            local v2331 = v106(v2319);
                            local v2332 = v2331 + v2323;
                            local v2333 = v2331 + v2324;
                            v2331 = l_lerp_0(v2332, v2333, 0.5);
                            local l_v2316_0 = v2316;
                            local v2335 = l_globals_0.tickinterval * (l_globals_0.tickcount - v2319.m_nFireEffectTickBegin);
                            if v2335 < 0.5 then
                                l_v2316_0 = l_v2316_0 * v2335;
                            end;
                            local v2336 = v2313 - v2335;
                            if v2336 < 1 then
                                l_v2316_0 = l_v2316_0 * v2336;
                            end;
                            local l_m_hOwnerEntity_0 = v2319.m_hOwnerEntity;
                            local v2338 = l_m_hOwnerEntity_0 and v111(l_m_hOwnerEntity_0) and l_v2294_0 or l_v2172_2;
                            v2338 = l_alpha_modulate_0(v2338, v2338.a * l_v2316_0);
                            l_v1588_8(v2331, v2338, v2322 * 0.5 + 40, 0, 1, 1);
                        end;
                    end;
                end;
                local v2339 = v539("Grenade Radius: Smoke", l_v2295_0, 0, 1, 0.025) * v2315;
                if v2339 > 0 then
                    local v2340 = l_get_entities_0("CSmokeGrenadeProjectile", true);
                    for _, v2342 in l_ipairs_0(v2340) do
                        if v2342.m_bDidSmokeEffect then
                            local v2343 = v106(v2342);
                            local v2344 = l_globals_0.tickinterval * (l_globals_0.tickcount - v2342.m_nSmokeEffectTickBegin);
                            local v2345 = v2312 - v2344;
                            if v2344 > 0 and v2345 > 0 then
                                local l_v2339_0 = v2339;
                                local l_v2311_0 = v2311;
                                if v2344 < 0.5 then
                                    l_v2311_0 = l_v2311_0 * 0.6 + l_v2311_0 * (v2344 / 0.3) * 0.4;
                                    l_v2339_0 = l_v2339_0 * (v2344 / 0.3);
                                end;
                                if v2345 < 1 then
                                    l_v2311_0 = l_v2339_0 * (l_v2311_0 * (v2345 * 0.3 + 0.7));
                                    l_v2339_0 = v2345;
                                end;
                                local v2348 = l_alpha_modulate_0(l_v2296_0, l_v2296_0.a * l_v2339_0);
                                l_v1588_8(v2343, v2348, l_v2311_0, 0, 1, 1);
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
        v502("Grenade Radius")("render", v2349);
    end;
    v1587 = nil;
    v1587 = v566.melancholia_ui;
    v1588 = nil;
    do
        local l_v1588_9, l_v2171_4, l_v2172_3, l_v2294_1 = v1588, v2171, v2172, v2294;
        v1587.style:set_callback(function(v2354)
            -- upvalues: l_v1588_9 (ref), v568 (ref)
            l_v1588_9 = v568(v2354);
        end, true);
        l_v2171_4 = nil;
        l_v2171_4 = function(v2355, v2356, v2357, v2358, v2359, v2360)
            -- upvalues: l_rect_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_alpha_modulate_0 (ref), l_gradient_0 (ref), l_globals_0 (ref), l_sin_0 (ref)
            local l_x_1 = v2355.x;
            local l_y_3 = v2355.y;
            local l_x_2 = v2356.x;
            local l_y_4 = v2356.y;
            l_rect_0(l_vector_0(l_x_1, l_y_3), l_vector_0(l_x_1 + l_x_2, l_y_3 + l_y_4), l_color_0(37, v2357));
            l_rect_0(l_vector_0(l_x_1 + 1, l_y_3 + 1), l_vector_0(l_x_1 + l_x_2 - 1, l_y_3 + l_y_4 - 1), l_color_0(53, v2357));
            l_rect_0(l_vector_0(l_x_1 + 2, l_y_3 + 2), l_vector_0(l_x_1 + l_x_2 - 2, l_y_3 + l_y_4 - 2), l_color_0(37, v2357));
            l_rect_0(l_vector_0(l_x_1 + 3, l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 - 3, l_y_3 + l_y_4 - 3), l_color_0(10, v2357));
            if v2358 ~= nil and v2359 ~= nil then
                v2357 = v2357 / 255;
                v2359 = l_alpha_modulate_0(v2359, v2359.a * v2357);
                if v2358 == "Static" then
                    if v2360 ~= nil then
                        l_rect_0(l_vector_0(l_x_1 + 46 * (1.07 - v2360), l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 * 0.5 + l_x_2 * 0.5 * v2360 - 4, l_y_3 + 4), v2359);
                    else
                        l_rect_0(l_vector_0(l_x_1 + 3, l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 - 3, l_y_3 + 4), v2359);
                    end;
                end;
                if v2358 == "Gradient" then
                    local v2365 = l_color_0(201, 227, 58, v2359.a);
                    local v2366 = l_color_0(202, 70, 205, v2359.a);
                    if v2360 ~= nil then
                        l_gradient_0(l_vector_0(l_x_1 + 46 * (1.07 - v2360), l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 * 0.5 + l_x_2 * 0.5 * v2360 - 4, l_y_3 + 4), v2365, v2366, v2365, v2366);
                    else
                        l_gradient_0(l_vector_0(l_x_1 + 3, l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 - 3, l_y_3 + 4), v2365, v2366, v2365, v2366);
                    end;
                end;
                if v2358 == "Animated Gradient" then
                    local v2367 = l_globals_0.realtime * 2;
                    local v2368 = (l_sin_0(v2367) * 127 + 128) * 0.001 * 3.92 * 255;
                    local v2369 = (l_sin_0(v2367 + 2) * 127 + 128) * 0.001 * 3.92 * 255;
                    local v2370 = (l_sin_0(v2367 + 4) * 127 + 128) * 0.001 * 3.92 * 255;
                    if v2360 ~= nil then
                        l_gradient_0(l_vector_0(l_x_1 + 46 * (1.07 - v2360), l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 * 0.5 + l_x_2 * 0.5 * v2360 - 4, l_y_3 + 4), l_color_0(v2369, v2370, v2368, v2359.a), l_color_0(v2368, v2369, v2370, v2359.a), l_color_0(v2369, v2370, v2368, v2359.a), l_color_0(v2368, v2369, v2370, v2359.a));
                    else
                        l_gradient_0(l_vector_0(l_x_1 + 3, l_y_3 + 3), l_vector_0(l_x_1 + l_x_2 - 3, l_y_3 + 4), l_color_0(v2369, v2370, v2368, v2359.a), l_color_0(v2368, v2369, v2370, v2359.a), l_color_0(v2369, v2370, v2368, v2359.a), l_color_0(v2368, v2369, v2370, v2359.a));
                    end;
                end;
            end;
        end;
        l_v2172_3 = nil;
        l_v2172_3 = v1587.watermark;
        l_v2294_1 = nil;
        v2295 = nil;
        v2296 = nil;
        local v2371 = nil;
        local v2372 = nil;
        local v2373 = nil;
        local v2374 = nil;
        local v2375 = nil;
        local v2376 = nil;
        local v2377 = nil;
        local v2378 = nil;
        do
            local l_l_v2294_1_0, l_v2295_1, l_v2296_1, l_v2371_0, l_v2372_0, l_v2373_0, l_v2374_0, l_v2375_0, l_v2376_0, l_v2377_0, l_v2378_0 = l_v2294_1, v2295, v2296, v2371, v2372, v2373, v2374, v2375, v2376, v2377, v2378;
            v1587["   Watermark"]:set_callback(function(v2390)
                -- upvalues: l_l_v2294_1_0 (ref), v568 (ref)
                l_l_v2294_1_0 = v568(v2390);
            end, true);
            l_v2172_3.selection:set_callback(function(v2391)
                -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v2295_1 (ref)
                local v2392 = v2391:list();
                for _, v2394 in l_ipairs_0(v2392) do
                    v2392[v2394] = v568(v2391, v2394);
                end;
                l_v2295_1 = v2392;
            end, true);
            l_v2172_3.color:set_callback(function(v2395)
                -- upvalues: l_v2296_1 (ref), l_v2371_0 (ref), v568 (ref)
                local v2396, v2397 = v568(v2395);
                l_v2371_0 = v2397;
                l_v2296_1 = v2396;
            end, true);
            l_v2172_3.m_color:set_callback(function(v2398)
                -- upvalues: l_v2372_0 (ref), v568 (ref)
                l_v2372_0 = v568(v2398);
            end, true);
            l_v2172_3.lua_name.color:set_callback(function(v2399)
                -- upvalues: l_v2373_0 (ref), l_v2374_0 (ref), v568 (ref)
                local v2400, v2401 = v568(v2399);
                l_v2374_0 = v2401;
                l_v2373_0 = v2400;
            end, true);
            l_v2172_3.lua_name[1]:set_callback(function(v2402)
                -- upvalues: l_v2375_0 (ref), v568 (ref)
                l_v2375_0 = v568(v2402);
            end, true);
            l_v2172_3.lua_name[2]:set_callback(function(v2403)
                -- upvalues: l_v2376_0 (ref), v568 (ref)
                l_v2376_0 = v568(v2403);
            end, true);
            l_v2172_3.username:set_callback(function(v2404)
                -- upvalues: l_v2377_0 (ref), v568 (ref)
                l_v2377_0 = v568(v2404);
            end, true);
            l_v2172_3.custom_username:set_callback(function(v2405)
                -- upvalues: l_v2378_0 (ref), v568 (ref), l_gsub_0 (ref), v1 (ref)
                l_v2378_0 = v568(v2405);
                if l_gsub_0(l_v2378_0, " ", "") == "" then
                    l_v2378_0 = v1;
                end;
            end, true);
            local v2406 = " | ";
            local v2407 = 0;
            local v2408 = nil;
            local v2409 = nil;
            local v2410 = nil;
            local v2411 = "nl\\melancholia\\watermark.png";
            local v2412 = l_vector_0(20, 9);
            local v2413, v2414 = l_pcall_0(render.load_image_from_file, v2411, v2412);
            do
                local l_v2411_0, l_v2412_0, l_v2414_0 = v2411, v2412, v2414;
                if not v2413 then
                    network.get("https://northon.dev/neverlose/melancholia/watermark.png", {}, function(v2418)
                        -- upvalues: l_v2411_0 (ref), l_v2414_0 (ref), l_v2412_0 (ref)
                        if not v2418 or #v2418 == 0 then
                            return;
                        else
                            files.write(l_v2411_0, v2418, true);
                            l_v2414_0 = render.load_image_from_file(l_v2411_0, l_v2412_0);
                            return;
                        end;
                    end);
                end;
                v2410 = l_v2414_0;
            end;
            v2411 = nil;
            v2412 = panorama.MyPersonaAPI.GetXuid();
            network.get(l_format_0("https://steamcommunity.com/profiles/%s/?xml=1", v2412), {}, function(v2419)
                -- upvalues: l_find_0 (ref), l_sub_0 (ref), v2411 (ref), l_vector_0 (ref)
                if not v2419 or #v2419 == 0 then
                    return;
                else
                    local v2420 = l_find_0(v2419, "<avatarMedium>");
                    if v2420 == nil then
                        return;
                    else
                        local v2421 = l_find_0(v2419, "</avatarMedium>");
                        if v2421 == nil then
                            return;
                        else
                            local v2422 = l_sub_0(v2419, v2420 + 23, v2421 - 4);
                            network.get(v2422, {}, function(v2423)
                                -- upvalues: v2411 (ref), l_vector_0 (ref)
                                if not v2423 or #v2423 == 0 then
                                    return;
                                else
                                    v2411 = render.load_image(v2423, l_vector_0(16, 16));
                                    return;
                                end;
                            end);
                            return;
                        end;
                    end;
                end;
            end);
            v2412 = 0;
            v2413 = panorama.MyPersonaAPI.GetName;
            v2414 = v118.x;
            local function v2445(v2424)
                -- upvalues: v539 (ref), l_l_v2294_1_0 (ref), l_v1588_9 (ref), l_v2172_3 (ref), l_net_channel_0 (ref), l_globals_0 (ref), l_v2295_1 (ref), l_v2373_0 (ref), l_format_0 (ref), l_to_hex_0 (ref), l_v2374_0 (ref), l_v2375_0 (ref), l_v2376_0 (ref), l_v2377_0 (ref), v1 (ref), v2413 (ref), l_v2378_0 (ref), v2406 (ref), l_floor_0 (ref), v2407 (ref), v2412 (ref), v2408 (ref), v2409 (ref), l_get_date_0 (ref), l_concat_0 (ref), l_sub_0 (ref), l_measure_text_0 (ref), v563 (ref), v2414 (ref), l_vector_0 (ref), l_v2171_4 (ref), l_v2296_1 (ref), l_v2371_0 (ref), l_text_0 (ref), l_color_0 (ref), l_v2372_0 (ref), l_rect_0 (ref), l_rect_outline_0 (ref)
                local v2425 = v539("Melancholia UI: Watermark", l_l_v2294_1_0 and l_v1588_9 ~= 1, 0, 1, 0.025);
                if v2425 == 0 then
                    l_v2172_3.size = nil;
                    return;
                else
                    v2425 = v2425 * 255;
                    if v2424.localplayer == nil then
                        return;
                    else
                        local v2426 = l_net_channel_0();
                        local l_realtime_3 = l_globals_0.realtime;
                        if l_v1588_9 == 2 then
                            local v2428 = {};
                            if l_v2295_1["Lua Name"] then
                                v2428[#v2428 + 1] = l_v2373_0 == "Default" and l_format_0("\a" .. l_to_hex_0(l_v2374_0) .. "outlaw\aDEFAULT | ") or l_format_0("\a%s%s\a%s%s\aDEFAULT | ", l_to_hex_0(l_v2374_0[1]), l_v2375_0, l_to_hex_0(l_v2374_0[2]), l_v2376_0);
                            end;
                            if l_v2295_1.Username then
                                v2428[#v2428 + 1] = (l_v2377_0 == "Neverlose" and v1 or l_v2377_0 == "Steam" and v2413() or l_v2378_0) .. v2406;
                            end;
                            if l_v2295_1.Ping and v2426 then
                                v2428[#v2428 + 1] = (v2426.is_loopback and "local" or l_floor_0(v2426.latency[1] * 1000) .. " ms") .. v2406;
                            end;
                            v2407 = 0.9 * v2407 + 0.1 * l_globals_0.absoluteframetime;
                            if v2412 + 0.4 < l_realtime_3 or not v2408 or not v2409 then
                                v2408 = l_format_0("%d fps | ", 1 / v2407);
                                if v2426 then
                                    local v2429 = v2426:get_server_info();
                                    local l_frame_time_0 = v2429.frame_time;
                                    local l_deviation_0 = v2429.deviation;
                                    v2409 = l_format_0("sv: %.1f +- %.1f | ", l_frame_time_0, l_deviation_0);
                                end;
                                v2412 = l_realtime_3;
                            end;
                            if l_v2295_1.FPS then
                                v2428[#v2428 + 1] = v2408;
                            end;
                            if l_v2295_1.SV then
                                v2428[#v2428 + 1] = v2409;
                            end;
                            if l_v2295_1.Time then
                                v2428[#v2428 + 1] = l_get_date_0("%I:%M pm") .. v2406;
                            end;
                            v2428 = l_concat_0(v2428, "");
                            v2428 = l_sub_0(v2428, 1, -3);
                            local v2432 = l_measure_text_0(v563, nil, v2428);
                            local v2433 = v2414 - v2432.x - 10;
                            local v2434 = 10;
                            l_v2172_3.size = l_vector_0(v2433 - 7, 23);
                            l_v2171_4(l_vector_0(v2433 - 7, v2434 - 4), l_vector_0(v2432.x + 10, 23), v2425, l_v2296_1, l_v2371_0);
                            l_text_0(v563, l_vector_0(v2433, v2434), l_color_0(255, v2425), nil, v2428);
                        elseif l_v1588_9 == 3 then
                            local v2435 = l_v2377_0 == "Neverlose" and v1 or l_v2377_0 == "Steam" and v2413() or l_v2378_0;
                            local v2436 = "0";
                            if v2426 then
                                v2436 = v2426.is_loopback and "0" or l_floor_0(v2426.latency[1] * 1000);
                            end;
                            local v2437 = l_get_date_0("%I:%M \a737373FFpm");
                            local v2438 = "\a" .. l_to_hex_0(l_v2372_0);
                            local v2439 = l_format_0(v2438 .. "outlaw \a737373FF/ %s " .. v2438 .. "%s\a737373FF ms " .. v2438 .. "%s", v2435, v2436, v2437);
                            local v2440 = l_measure_text_0(v563, nil, v2439);
                            local v2441 = v2425 / 255;
                            local v2442 = v2414 - v2440.x - 10;
                            local v2443 = 10;
                            local l_x_3 = v2440.x;
                            l_rect_0(l_vector_0(v2442 - 2, v2443), l_vector_0(v2442 + l_x_3 - 1, v2443 + 16), l_color_0(0, 0, 0, 255 * v2441));
                            l_rect_outline_0(l_vector_0(v2442 - 3, v2443 - 1), l_vector_0(v2442 + l_x_3, v2443 + 17), l_color_0(15, 15, 15, 200 * v2441));
                            l_rect_outline_0(l_vector_0(v2442 - 4, v2443 - 2), l_vector_0(v2442 + l_x_3 + 1, v2443 + 18), l_color_0(15, 15, 15, 200 * v2441));
                            l_rect_outline_0(l_vector_0(v2442 - 5, v2443 - 3), l_vector_0(v2442 + l_x_3 + 2, v2443 + 19), l_color_0(10, 10, 10, 255 * v2441));
                            l_text_0(v563, l_vector_0(v2442, v2443), l_color_0(255, v2425), nil, v2439);
                            l_v2172_3.size = l_vector_0(v2442 - 7, 23);
                        end;
                        return;
                    end;
                end;
            end;
            v502("Melancholia UI: Watermark")("render", v2445);
        end;
        l_v2294_1 = nil;
        l_v2294_1 = v1587.keybinds;
        v2295 = nil;
        v2296 = nil;
        v2371 = nil;
        v2372 = nil;
        v2373 = nil;
        v2374 = nil;
        do
            local l_v2295_2, l_v2296_2, l_v2371_1, l_v2372_1, l_v2373_1, l_v2374_1, l_v2375_1, l_v2376_1, l_v2377_1 = v2295, v2296, v2371, v2372, v2373, v2374, v2375, v2376, v2377;
            v1587["  Keybinds"]:set_callback(function(v2455)
                -- upvalues: l_v2295_2 (ref), v568 (ref)
                l_v2295_2 = v568(v2455);
            end, true);
            l_v2294_1.min_width:set_callback(function(v2456)
                -- upvalues: l_v2296_2 (ref), v568 (ref)
                l_v2296_2 = v568(v2456);
            end, true);
            l_v2294_1.mode:set_callback(function(v2457)
                -- upvalues: l_v2371_1 (ref), v568 (ref)
                l_v2371_1 = v568(v2457) == "State";
            end, true);
            l_v2294_1.m_color:set_callback(function(v2458)
                -- upvalues: l_v2372_1 (ref), l_v2373_1 (ref), v568 (ref)
                local v2459, v2460 = v568(v2458);
                l_v2373_1 = v2460;
                l_v2372_1 = v2459;
            end, true);
            l_v2294_1.m_color2:set_callback(function(v2461)
                -- upvalues: l_v2374_1 (ref), v568 (ref)
                l_v2374_1 = v568(v2461);
            end, true);
            l_v2375_1 = v503("keybinds", l_vector_0(200, 325));
            l_v2376_1 = 0;
            l_v2377_1 = "keybinds";
            v2378 = function(v2462)
                -- upvalues: v539 (ref), l_v2295_2 (ref), l_v1588_9 (ref), v575 (ref), v576 (ref), l_globals_0 (ref), l_v2375_1 (ref), l_v2296_2 (ref), l_ipairs_0 (ref), l_v2294_1 (ref), l_type_0 (ref), l_next_0 (ref), l_sub_0 (ref), l_concat_0 (ref), l_v2371_1 (ref), l_clamp_0 (ref), v542 (ref), l_measure_text_0 (ref), l_v2376_1 (ref), v543 (ref), l_min_0 (ref), l_v2377_1 (ref), l_alpha_modulate_0 (ref), l_v2373_1 (ref), l_v2171_4 (ref), l_vector_0 (ref), l_v2372_1 (ref), l_shadow_0 (ref), l_text_0 (ref), l_color_0 (ref), v563 (ref), l_v2374_1 (ref), l_rect_0 (ref), l_rect_outline_0 (ref)
                local v2463 = v539("Melancholia UI: Keybinds", l_v2295_2 and l_v1588_9 ~= 1, 0, 1, 0.025);
                if v2463 == 0 then
                    return;
                else
                    local v2464 = v539("Melancholia UI: Keybinds: Binds", #v575 > 0 or v576 > 0, 0, 1, 0.025) * v2463;
                    if v2464 == 0 then
                        return;
                    else
                        v2464 = v2464 * 255;
                        if v2462.localplayer == nil then
                            return;
                        else
                            local l_frametime_1 = l_globals_0.frametime;
                            local v2466 = l_v2375_1:get_position();
                            local l_x_4 = v2466.x;
                            local l_y_5 = v2466.y;
                            local l_l_v2296_2_0 = l_v2296_2;
                            local v2470 = 0.045;
                            for _, v2472 in l_ipairs_0(v575) do
                                local l_active_1 = v2472.active;
                                local l_name_2 = v2472.name;
                                local l_value_0 = v2472.value;
                                if not l_v2294_1[l_name_2] then
                                    l_v2294_1[l_name_2] = {};
                                end;
                                local v2476 = l_type_0(l_value_0);
                                if v2476 == "table" then
                                    local v2477 = {};
                                    for _, v2479 in l_next_0, l_value_0 do
                                        v2477[#v2477 + 1] = l_sub_0(v2479, 1, 1);
                                        v2477[#v2477 + 1] = ",";
                                    end;
                                    v2477[#v2477] = nil;
                                    l_value_0 = l_concat_0(v2477);
                                end;
                                local v2480;
                                if l_v2371_1 then
                                    v2480 = l_value_0 and "[on]" or "[off]";
                                elseif v2476 == "boolean" then
                                    v2480 = l_value_0 and "[on]" or "[off]";
                                elseif v2476 ~= "table" or not l_value_0 then
                                    v2480 = "[" .. l_value_0 .. "]";
                                else
                                    v2480 = l_value_0;
                                end;
                                v2480 = v2480.lower(v2480);
                                l_v2294_1[l_name_2].alpha = l_clamp_0(v542(1, l_v2294_1[l_name_2].alpha or 0, l_frametime_1 * (l_active_1 and v2470 or -v2470) * 175, 1), 0, 1);
                                l_v2294_1[l_name_2].name = l_name_2;
                                l_v2294_1[l_name_2].text_size = l_measure_text_0(1, nil, l_name_2).x;
                                l_v2294_1[l_name_2].value = v2480;
                                local l_x_5 = l_measure_text_0(1, nil, v2480).x;
                                l_v2294_1[l_name_2].m_text_size = l_x_5;
                                l_v2294_1[l_name_2].c_width = l_x_5;
                                local v2482 = l_v2294_1[l_name_2].text_size + l_v2294_1[l_name_2].m_text_size + 14;
                                if l_l_v2296_2_0 < v2482 then
                                    l_l_v2296_2_0 = v2482;
                                end;
                            end;
                            if l_v2376_1 < l_l_v2296_2_0 then
                                l_v2376_1 = v543(1, l_v2376_1, l_globals_0.frametime * 750, 2);
                                l_v2376_1 = l_min_0(l_l_v2296_2_0, l_v2376_1);
                            elseif l_l_v2296_2_0 < l_v2376_1 then
                                l_v2376_1 = v543(-1, l_v2376_1, l_globals_0.frametime * -750, -2);
                            end;
                            local l_l_v2376_1_0 = l_v2376_1;
                            local v2484 = 21;
                            if l_v1588_9 == 2 then
                                local v2485 = l_measure_text_0(1, nil, l_v2377_1).x * 0.5;
                                local v2486 = l_alpha_modulate_0(l_v2373_1, l_v2373_1.a * v2464 / 255);
                                l_v2171_4(l_vector_0(l_x_4, l_y_5 - 4), l_vector_0(l_l_v2376_1_0, 23), v2464, l_v2372_1, l_v2373_1);
                                l_shadow_0(l_vector_0(l_x_4 + l_l_v2376_1_0 * 0.5 - v2485 - 1, l_y_5 + 8), l_vector_0(l_x_4 + l_l_v2376_1_0 * 0.5 + v2485 - 1, l_y_5 + 8), v2486, 15, 1);
                                l_text_0(1, l_vector_0(l_x_4 + l_l_v2376_1_0 * 0.5 - v2485, l_y_5 + 1), l_alpha_modulate_0(l_v2373_1, v2464), nil, l_v2377_1);
                                for _, v2488 in l_ipairs_0(v575) do
                                    local v2489 = l_v2294_1[v2488.name];
                                    local v2490 = v2489.alpha * v2464;
                                    l_text_0(1, l_vector_0(l_x_4 + 4, l_y_5 + v2484), l_color_0(204, v2490), nil, v2489.name);
                                    l_text_0(1, l_vector_0(l_x_4 + l_l_v2376_1_0 - v2489.m_text_size - 4, l_y_5 + v2484), l_color_0(204, v2490), nil, v2489.value);
                                    v2484 = v2484 + 13 * v2489.alpha;
                                end;
                            elseif l_v1588_9 == 3 then
                                local v2491 = l_measure_text_0(v563, nil, l_v2377_1).x * 0.5;
                                l_v2374_1.a = v2464;
                                local v2492 = v2464 / 255;
                                l_rect_0(l_vector_0(l_x_4 - 2, l_y_5), l_vector_0(l_x_4 + l_l_v2376_1_0 - 1, l_y_5 + 16), l_color_0(0, 0, 0, 255 * v2492));
                                l_rect_outline_0(l_vector_0(l_x_4 - 3, l_y_5 - 1), l_vector_0(l_x_4 + l_l_v2376_1_0, l_y_5 + 17), l_color_0(15, 15, 15, 200 * v2492));
                                l_rect_outline_0(l_vector_0(l_x_4 - 4, l_y_5 - 2), l_vector_0(l_x_4 + l_l_v2376_1_0 + 1, l_y_5 + 18), l_color_0(15, 15, 15, 200 * v2492));
                                l_rect_outline_0(l_vector_0(l_x_4 - 5, l_y_5 - 3), l_vector_0(l_x_4 + l_l_v2376_1_0 + 2, l_y_5 + 19), l_color_0(10, 10, 10, 255 * v2492));
                                l_text_0(v563, l_vector_0(l_x_4 + l_l_v2376_1_0 * 0.5 - v2491, l_y_5), l_v2374_1, nil, l_v2377_1);
                                for _, v2494 in l_ipairs_0(v575) do
                                    local v2495 = l_v2294_1[v2494.name];
                                    local v2496 = v2495.alpha * v2464;
                                    l_text_0(1, l_vector_0(l_x_4, l_y_5 + v2484), l_color_0(200, v2496), nil, v2495.name);
                                    l_text_0(1, l_vector_0(l_x_4 + l_l_v2376_1_0 - v2495.m_text_size, l_y_5 + v2484), l_color_0(200, v2496), nil, v2495.value);
                                    v2484 = v2484 + 13 * v2495.alpha;
                                end;
                            end;
                            local v2497 = l_vector_0(l_l_v2376_1_0, v2484);
                            l_v2375_1:update(v2497);
                            return;
                        end;
                    end;
                end;
            end;
            local function v2499(v2498)
                -- upvalues: l_v2376_1 (ref), v568 (ref)
                l_v2376_1 = v568(v2498);
            end;
            v502("Melancholia UI: Keybinds")("render", v2378);
            l_v2294_1.min_width:set_callback(v2499, true);
        end;
        v2295 = nil;
        v2296 = nil;
        do
            local l_v2295_3, l_v2296_3, l_v2371_2, l_v2372_2 = v2295, v2296, v2371, v2372;
            v1587["  Spectators"]:set_callback(function(v2504)
                -- upvalues: l_v2295_3 (ref), v568 (ref)
                l_v2295_3 = v568(v2504);
            end, true);
            l_v2296_3 = l_color_0();
            l_v2371_2 = v503("spectators list", l_vector_0(v118.x - 80, 0));
            l_v2372_2 = l_vector_0(80, 38);
            v2373 = function(v2505)
                -- upvalues: v539 (ref), l_v2295_3 (ref), l_v1588_9 (ref), l_v2296_3 (ref), v576 (ref), l_v2371_2 (ref), l_v2372_2 (ref), v118 (ref), l_ipairs_0 (ref), l_type_0 (ref), l_measure_text_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_blur_0 (ref), v562 (ref), l_color_0 (ref), l_rect_outline_0 (ref), l_min_0 (ref), l_v2172_3 (ref), v568 (ref)
                local v2506 = v539("Melancholia UI: Spectators List", l_v2295_3 and l_v1588_9 ~= 1, 0, 1, 0.025);
                if v2506 == 0 then
                    return;
                else
                    v2506 = 255 * v2506;
                    l_v2296_3.a = v2506;
                    local l_localplayer_19 = v2505.localplayer;
                    local l_is_alive_16 = v2505.is_alive;
                    local v2509 = l_localplayer_19 and l_is_alive_16 and l_localplayer_19 or l_localplayer_19 and l_localplayer_19.m_hObserverTarget;
                    local v2510 = {};
                    if v2509 then
                        v2510 = v2509:get_spectators() or {};
                    end;
                    local v2511 = v576 > 0;
                    if v2511 then
                        v2510 = {};
                        v2510[#v2510 + 1] = "Adam";
                        v2510[#v2510 + 1] = "Keith";
                        v2510[#v2510 + 1] = "Tim";
                    end;
                    local v2512 = l_v2371_2:get_position();
                    local l_x_6 = v2512.x;
                    local l_y_6 = v2512.y;
                    local v2515 = (l_x_6 + l_v2372_2.x) / (v118.x - l_v2372_2.x) - l_v2372_2.x / (v118.x - l_v2372_2.x);
                    local v2516 = 0;
                    for _, v2518 in l_ipairs_0(v2510) do
                        local v2519 = l_type_0(v2518) == "string" and v2518 or v2518:get_name();
                        local l_x_7 = l_measure_text_0(1, nil, v2519).x;
                        l_text_0(1, l_vector_0(l_x_6 + 2 + (l_v2372_2.x - 4 - l_x_7) * v2515, l_y_6 + v2516), l_v2296_3, nil, v2519);
                        v2516 = v2516 + 12;
                    end;
                    l_v2371_2:update(l_v2372_2);
                    if v2511 then
                        local l_dragging_0 = l_v2371_2.dragging;
                        local v2522 = v539("Drag: Spectators List", l_dragging_0, 0, 1, 0.035);
                        if l_dragging_0 then
                            l_blur_0(v2512, v2512 + l_v2372_2, v2522 * 3, v2522 * 1, v2522 * 6);
                        end;
                        l_text_0(v562, v2512 + l_vector_0(l_v2372_2.x * 0.5, -5), l_color_0(255, (1 - v2522) * v2506), "c", "PRESS M2 TO DEFAULT POSITION");
                        l_rect_outline_0(v2512, v2512 + l_v2372_2, l_color_0(255, l_min_0(1, 1.5 - v2522) * v2506), 1, 6, true);
                        local l_size_0 = l_v2172_3.size;
                        if l_size_0 then
                            local l_x_8 = l_size_0.x;
                            local l_y_7 = l_size_0.y;
                            local v2526 = l_x_8 - 5;
                            local v2527 = l_y_7 + 15;
                            if v2526 < v568(l_v2371_2.positions.x) + 80 and v568(l_v2371_2.positions.y) < v2527 then
                                l_v2371_2.positions.y:set(v2527);
                            end;
                        end;
                    end;
                    return;
                end;
            end;
            v502("Melancholia UI: Spectators List")("render", v2373);
        end;
    end;
    v1588 = nil;
    v1588 = v566.misc["   Avoid Collisions"];
    v2171 = 1;
    v2172 = function(v2528)
        return not v2528:is_player();
    end;
    v2294 = function(v2529, v2530)
        -- upvalues: l_angles_0 (ref), v91 (ref), l_vectors_0 (ref), l_normalized_0 (ref)
        local l_forwardmove_0 = v2529.forwardmove;
        local l_sidemove_0 = v2529.sidemove;
        if l_forwardmove_0 == 0 and l_sidemove_0 == 0 then
            l_forwardmove_0 = 450;
        end;
        local v2533 = l_angles_0(v91, 0, v2530.y);
        local v2534 = l_vectors_0(v2533);
        local v2535 = v2533 * l_forwardmove_0 + v2534 * l_sidemove_0;
        return (l_normalized_0(v2535));
    end;
    v2295 = 536870912;
    do
        local l_v2171_5, l_v2172_4, l_v2294_2, l_v2295_4, l_v2296_4 = v2171, v2172, v2294, v2295, v2296;
        l_v2296_4 = function(v2541, v2542)
            -- upvalues: l_band_0 (ref), l_v2171_5 (ref), v106 (ref), l_camera_angles_0 (ref), l_v2294_2 (ref), l_trace_hull_0 (ref), l_v2172_4 (ref), l_v2295_4 (ref), l_vectors_0 (ref), l_dist_0 (ref), l_angles_0 (ref)
            local l_localplayer_20 = v2541.localplayer;
            local l_is_alive_17 = v2541.is_alive;
            if l_localplayer_20 == nil or not l_is_alive_17 then
                return;
            else
                local l_weapon_info_6 = v2541.weapon_info;
                if l_weapon_info_6 == nil then
                    return;
                elseif l_weapon_info_6.weapon_type == 9 then
                    return;
                else
                    local v2546 = l_band_0(l_localplayer_20.m_fFlags, l_v2171_5) ~= 0 and not v2542.in_jump;
                    local v2547 = l_localplayer_20.m_MoveType == 9;
                    local l_in_speed_0 = v2542.in_speed;
                    local v2549 = l_localplayer_20.m_flDuckAmount > 0;
                    if v2546 or l_in_speed_0 or v2547 or v2549 then
                        return;
                    else
                        local v2550 = v106(l_localplayer_20);
                        v2550.z = v2550.z + 24;
                        local l_m_vecMins_1 = l_localplayer_20.m_vecMins;
                        local l_m_vecMaxs_1 = l_localplayer_20.m_vecMaxs;
                        local v2553 = l_camera_angles_0();
                        local v2554 = v2550 + l_v2294_2(v2542, v2553) * 4096;
                        local v2555 = l_trace_hull_0(v2550, v2554, l_m_vecMins_1, l_m_vecMaxs_1, l_v2172_4, l_v2295_4, 1);
                        local l_fraction_2 = v2555.fraction;
                        local v2557 = v2555:did_hit();
                        if l_fraction_2 <= 0.01 and v2557 then
                            return;
                        else
                            local v2558 = 0;
                            l_m_vecMaxs_1.z = l_m_vecMaxs_1.z * 0.25;
                            l_m_vecMins_1.z = v2558;
                            v2558 = l_trace_hull_0(v2550, v2554, l_m_vecMins_1, l_m_vecMaxs_1, l_v2172_4);
                            if v2558.fraction > 0.007 then
                                return;
                            else
                                local l_end_pos_0 = v2558.end_pos;
                                local v2560 = l_vectors_0(v2558.plane.normal);
                                local v2561 = l_end_pos_0 + v2560;
                                local v2562 = l_end_pos_0 - v2560;
                                local v2563 = l_dist_0(v2554, v2561) < l_dist_0(v2554, v2562) and v2561 or v2562;
                                v2563 = l_angles_0(v2563 - l_end_pos_0).y;
                                local v2564 = true;
                                v2542.in_back = false;
                                v2542.in_forward = v2564;
                                v2564 = false;
                                v2542.in_moveright = false;
                                v2542.in_moveleft = v2564;
                                v2564 = 450;
                                v2542.sidemove = 0;
                                v2542.forwardmove = v2564;
                                v2542.move_yaw = v2563;
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v1588:set_callback(function(v2565)
            -- upvalues: v502 (ref), l_v2296_4 (ref), v568 (ref)
            v502("Avoid Collisions")("createmove", l_v2296_4, v568(v2565));
        end, true);
    end;
    v2171 = nil;
    v2171 = v566.misc["  Rare Weapon Animations"];
    v2172 = {
        weapon_knife_butterfly = {
            [1] = 0, 
            [13] = 15, 
            [14] = 15
        }, 
        weapon_knife_falchion = {
            [12] = 13
        }, 
        weapon_knife_ursus = {
            [0] = 1, 
            [14] = 13
        }, 
        weapon_knife_stiletto = {
            [13] = 12
        }, 
        weapon_knife_widowmaker = {
            [14] = 15
        }, 
        weapon_knife_skeleton = {
            [0] = 1, 
            [13] = 14
        }, 
        weapon_knife_canis = {
            [0] = 1, 
            [14] = 13
        }, 
        weapon_knife_cord = {
            [0] = 1, 
            [14] = 13
        }, 
        weapon_knife_outdoor = {
            [14] = 13
        }, 
        weapon_deagle = {
            [7] = 8
        }, 
        weapon_revolver = {
            [3] = 4
        }
    };
    do
        local l_v2172_5, l_v2294_3 = v2172, v2294;
        l_v2294_3 = function(v2568)
            -- upvalues: l_v2172_5 (ref)
            local l_localplayer_21 = v2568.localplayer;
            local l_is_alive_18 = v2568.is_alive;
            if l_localplayer_21 == nil or not l_is_alive_18 then
                return;
            else
                local l_weapon_info_7 = v2568.weapon_info;
                if l_weapon_info_7 == nil then
                    return;
                else
                    local v2572 = l_v2172_5[l_weapon_info_7.console_name];
                    if v2572 == nil then
                        return;
                    else
                        local l_m_hViewModel_0 = l_localplayer_21.m_hViewModel;
                        if l_m_hViewModel_0 == nil then
                            return;
                        else
                            l_m_hViewModel_0 = l_m_hViewModel_0[0];
                            local v2574 = v2572[l_m_hViewModel_0.m_nSequence];
                            if v2574 == nil then
                                return;
                            else
                                l_m_hViewModel_0.m_nSequence = v2574;
                                return;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v2171:set_callback(function(v2575)
            -- upvalues: v502 (ref), l_v2294_3 (ref), v568 (ref)
            v502("Rare Weapon Animations")("createmove", l_v2294_3, v568(v2575));
        end, true);
    end;
    v2172 = nil;
    v2172 = v566.misc["  Auto Unmute"];
    v2294 = panorama.GameStateAPI;
    v2295 = v2294.GetPlayerXuidStringFromEntIndex;
    v2296 = v2294.IsSelectedPlayerMuted;
    do
        local l_v2294_4, l_v2295_5, l_v2296_5 = v2294, v2295, v2296;
        local function v2584()
            -- upvalues: l_get_players_0 (ref), l_ipairs_0 (ref), v113 (ref), l_v2295_5 (ref), l_v2296_5 (ref), l_v2294_4 (ref)
            local v2579 = l_get_players_0(false, true);
            for _, v2581 in l_ipairs_0(v2579) do
                local v2582 = v113(v2581);
                local v2583 = l_v2295_5(v2582);
                if l_v2296_5(v2583) then
                    l_v2294_4.ToggleMute(v2583);
                end;
            end;
        end;
        v2172:set_callback(function(v2585)
            -- upvalues: v568 (ref), l_events_0 (ref), v2584 (ref)
            local v2586 = v568(v2585);
            l_events_0.round_start(v2584, v2586);
            l_events_0.player_connect_full(v2584, v2586);
        end, true);
        v2172:set_callback(v2584, true);
    end;
    v2294 = nil;
    v2294 = v566.misc["  Fast Ladder Move"];
    v2295 = function(v2587, v2588)
        local l_localplayer_22 = v2587.localplayer;
        local l_is_alive_19 = v2587.is_alive;
        if l_localplayer_22 == nil or not l_is_alive_19 then
            return;
        else
            local l_m_MoveType_0 = l_localplayer_22.m_MoveType;
            local l_weapon_info_8 = v2587.weapon_info;
            if l_weapon_info_8 == nil then
                return;
            else
                local l_weapon_type_2 = l_weapon_info_8.weapon_type;
                if l_m_MoveType_0 ~= 9 or l_weapon_type_2 == 9 then
                    return;
                else
                    if v2588.sidemove == 0 then
                        v2588.view_angles.y = v2588.view_angles.y + 45;
                    end;
                    if v2588.in_forward and v2588.sidemove < 0 then
                        v2588.view_angles.y = v2588.view_angles.y + 90;
                    end;
                    if v2588.in_back and v2588.sidemove > 0 then
                        v2588.view_angles.y = v2588.view_angles.y + 90;
                    end;
                    v2588.in_moveleft = v2588.in_back;
                    v2588.in_moveright = v2588.in_forward;
                    if v2588.view_angles.x < 0 then
                        v2588.view_angles.x = -45;
                    end;
                    return;
                end;
            end;
        end;
    end;
    do
        local l_v2295_6 = v2295;
        v2294:set_callback(function(v2595)
            -- upvalues: v502 (ref), l_v2295_6 (ref), v568 (ref)
            v502("Fast Ladder Mode")("createmove", l_v2295_6, v568(v2595));
        end, true);
    end;
    v2295 = nil;
    v2295 = v566.misc["  No Fall Damage"];
    v2296 = function(v2596, v2597)
        -- upvalues: v106 (ref), l_globals_0 (ref), l_trace_line_0 (ref), l_vector_0 (ref)
        local l_localplayer_23 = v2596.localplayer;
        local l_is_alive_20 = v2596.is_alive;
        if l_localplayer_23 == nil or not l_is_alive_20 then
            return;
        else
            local l_m_vecVelocity_0 = l_localplayer_23.m_vecVelocity;
            if l_m_vecVelocity_0.z >= -575 then
                return;
            else
                local v2601 = v106(l_localplayer_23);
                local v2602 = v2601.z + l_m_vecVelocity_0.z * l_globals_0.tickinterval;
                local l_end_pos_1 = l_trace_line_0(v2601, v2601 - l_vector_0(0, 0, 256), l_localplayer_23).end_pos;
                v2597.in_duck = true;
                if v2602 <= l_end_pos_1.z then
                    v2597.in_duck = false;
                end;
                return;
            end;
        end;
    end;
    do
        local l_v2296_6 = v2296;
        v2295:set_callback(function(v2605)
            -- upvalues: v502 (ref), l_v2296_6 (ref), v568 (ref)
            v502("No Fall Damage")("createmove", l_v2296_6, v568(v2605));
        end, true);
    end;
    v2296 = nil;
    v2296 = v566.misc["    Shared Logo"];
    local v2606 = v194.makeencoder("WCPMoV0LRTFXNZSIHG4m9lBA2Kgur6dhbijnEczpase5tvqyfO1kU3x7JQwYD8+/=");
    local v2607 = v194.makedecoder("WCPMoV0LRTFXNZSIHG4m9lBA2Kgur6dhbijnEczpase5tvqyfO1kU3x7JQwYD8+/=");
    local l_encode_0 = v194.encode;
    local l_decode_0 = v194.decode;
    local l_parse_0 = json.parse;
    local v2611 = nil;
    local v2612 = l_tostring_0(l_sub_0(panorama.MyPersonaAPI.GetXuid(), 7) - 97960265728);
    do
        local l_v2606_0, l_v2607_0, l_l_encode_0_0, l_l_decode_0_0, l_l_parse_0_0, l_v2611_0, l_v2612_0 = v2606, v2607, l_encode_0, l_decode_0, l_parse_0, v2611, v2612;
        local function v2621()
            -- upvalues: l_v2612_0 (ref), l_v2611_0 (ref), l_l_encode_0_0 (ref), l_v2606_0 (ref)
            local v2620 = json.stringify({
                steam_id = l_v2612_0, 
                enabled = l_v2611_0
            });
            return l_l_encode_0_0(v2620, l_v2606_0);
        end;
        local v2622 = nil;
        local v2623 = {};
        local v2624 = {};
        local _ = nil;
        v500("wss://northon.dev/outlaw-ws/", {
            open = function(v2626)
                -- upvalues: v2621 (ref), v2622 (ref)
                v2626:send((v2621()));
                v2622 = v2626;
            end, 
            message = function(_, v2628)
                -- upvalues: l_pcall_0 (ref), l_l_decode_0_0 (ref), l_v2607_0 (ref), l_type_0 (ref), l_l_parse_0_0 (ref), l_next_0 (ref), v566 (ref), l_format_0 (ref), v2624 (ref)
                local v2629, v2630 = l_pcall_0(l_l_decode_0_0, v2628, l_v2607_0);
                if not v2629 or l_type_0(v2630) ~= "string" then
                    return;
                else
                    local v2631, v2632 = l_pcall_0(l_l_parse_0_0, v2630);
                    if not v2631 or l_type_0(v2632) ~= "table" then
                        return;
                    else
                        local v2633 = 10;
                        for _, _ in l_next_0, v2632 do
                            v2633 = v2633 + 1;
                        end;
                        if v2633 == 0 then
                            return;
                        else
                            v566.welcome.online:name(l_format_0("\239\131\128 \aDEFAULT Online Users: \a{Link Active}%s                                                 ", v2633));
                            v566.welcome.online:visibility(true);
                            v2624 = v2632;
                            return;
                        end;
                    end;
                end;
            end
        });
        local v2636 = "https://northon.dev/neverlose/melancholia/shared.png";
        local function v2641(v2637)
            -- upvalues: l_ipairs_0 (ref), l_tostring_0 (ref), v2624 (ref), v2636 (ref), v2623 (ref)
            for _, v2639 in l_ipairs_0(v2637.players) do
                local v2640 = l_tostring_0(v2639:get_xuid());
                if v2624[v2640] then
                    v2639:set_icon(v2636);
                    v2623[v2640] = false;
                elseif not v2623[v2640] then
                    v2639:set_icon();
                    v2623[v2640] = true;
                end;
            end;
        end;
        local function v2645(v2642)
            -- upvalues: l_ipairs_0 (ref)
            for _, v2644 in l_ipairs_0(v2642.players) do
                v2644:set_icon();
            end;
        end;
        v2296:set_callback(function(v2646)
            -- upvalues: l_v2611_0 (ref), v568 (ref), l_get_players_0 (ref), l_ipairs_0 (ref), v502 (ref), v2641 (ref), v2622 (ref), v2621 (ref)
            l_v2611_0 = v568(v2646);
            if not l_v2611_0 then
                local v2647 = l_get_players_0(false, true);
                for _, v2649 in l_ipairs_0(v2647) do
                    v2649:set_icon();
                end;
            end;
            v502("Shared Features")("render", v2641, l_v2611_0);
            if not v2622 then
                return;
            else
                local v2650 = v2621();
                v2622:send(v2650);
                return;
            end;
        end, true);
        v502("Shared Features")("shutdown", v2645);
    end;
    v2606 = nil;
    v2606 = v566.misc["   Taskbar Notification"];
    ffi.cdef("            void* FindWindowA(const char*, const char*);\n            bool FlashWindow(void*, bool);\n        ");
    v2607 = ffi.C.FlashWindow;
    l_encode_0 = ffi.C.FindWindowA;
    do
        local l_v2607_1, l_l_encode_0_1, l_l_decode_0_1 = v2607, l_encode_0, l_decode_0;
        l_l_decode_0_1 = function()
            -- upvalues: l_get_game_rules_0 (ref), l_l_encode_0_1 (ref), l_v2607_1 (ref)
            local v2654 = l_get_game_rules_0();
            if v2654 == nil or v2654.m_bIsValveDS then
                return;
            else
                local v2655 = l_l_encode_0_1("Valve001", nil);
                l_v2607_1(v2655, false);
                return;
            end;
        end;
        v2606:set_callback(function(v2656)
            -- upvalues: l_events_0 (ref), l_l_decode_0_1 (ref), v568 (ref)
            l_events_0.round_start(l_l_decode_0_1, v568(v2656));
        end, true);
    end;
    v2607 = nil;
    v2607 = v566.log_events;
    l_encode_0 = nil;
    l_decode_0 = ui.find("Miscellaneous", "Main", "Other", "Log Events");
    do
        local l_l_decode_0_2 = l_decode_0;
        l_encode_0 = function()
            -- upvalues: v574 (ref), l_l_decode_0_2 (ref), v568 (ref), v2607 (ref)
            v574(l_l_decode_0_2);
            if #v568(v2607.selection) == 0 then
                return;
            else
                v574(l_l_decode_0_2, {});
                return;
            end;
        end;
        l_l_decode_0_2:set_callback(l_encode_0, true);
        v2607.selection:set_callback(l_encode_0, true);
        v2607.hit.enabled:set_callback(l_encode_0, true);
        v2607.miss.enabled:set_callback(l_encode_0, true);
        v2607.knife.enabled:set_callback(l_encode_0, true);
        v2607.grenade.enabled:set_callback(l_encode_0, true);
        v2607.purchases.enabled:set_callback(l_encode_0, true);
    end;
    l_decode_0 = nil;
    l_parse_0 = nil;
    v2611 = nil;
    v2612 = nil;
    local v2658 = nil;
    local v2659 = nil;
    local v2660 = nil;
    local v2661 = nil;
    local v2662 = nil;
    local v2663 = nil;
    local v2664 = nil;
    local v2665 = nil;
    local v2666 = nil;
    do
        local l_l_decode_0_3, l_l_parse_0_1, l_v2611_1, l_v2612_1, l_v2658_0, l_v2659_0, l_v2660_0, l_v2661_0, l_v2662_0, l_v2663_0, l_v2664_0, l_v2665_0, l_v2666_0 = l_decode_0, l_parse_0, v2611, v2612, v2658, v2659, v2660, v2661, v2662, v2663, v2664, v2665, v2666;
        v2607.selection:set_callback(function(v2680)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_l_decode_0_3 (ref), l_l_parse_0_1 (ref)
            local v2681 = v2680:list();
            for v2682 in l_ipairs_0(v2681) do
                v2681[v2682] = v568(v2680, v2682);
            end;
            local v2683 = #v568(v2680) > 0;
            l_l_parse_0_1 = v2681;
            l_l_decode_0_3 = v2683;
        end, true);
        l_v2611_1 = {};
        v2607.spread:set_callback(function(v2684)
            -- upvalues: l_v2611_1 (ref), v568 (ref)
            l_v2611_1.spread = v568(v2684);
        end, true);
        v2607.correction:set_callback(function(v2685)
            -- upvalues: l_v2611_1 (ref), v568 (ref)
            l_v2611_1.correction = v568(v2685);
        end, true);
        v2607.misprediction:set_callback(function(v2686)
            -- upvalues: l_v2611_1 (ref), v568 (ref)
            l_v2611_1.misprediction = v568(v2686);
        end, true);
        v2607["prediction error"]:set_callback(function(v2687)
            -- upvalues: l_v2611_1 (ref), v568 (ref)
            l_v2611_1["prediction error"] = v568(v2687);
        end, true);
        v2607["backtrack failure"]:set_callback(function(v2688)
            -- upvalues: l_v2611_1 (ref), v568 (ref)
            l_v2611_1["backtrack failure"] = v568(v2688);
        end, true);
        v2607.hit.enabled:set_callback(function(v2689)
            -- upvalues: l_v2612_1 (ref), v568 (ref)
            l_v2612_1 = v568(v2689);
        end, true);
        v2607.hit.color:set_callback(function(v2690)
            -- upvalues: l_v2658_0 (ref), v568 (ref)
            l_v2658_0 = v568(v2690);
            l_v2658_0.a = 255;
        end, true);
        v2607.miss.enabled:set_callback(function(v2691)
            -- upvalues: l_v2659_0 (ref), v568 (ref)
            l_v2659_0 = v568(v2691);
        end, true);
        v2607.miss.color:set_callback(function(v2692)
            -- upvalues: l_v2660_0 (ref), v568 (ref)
            l_v2660_0 = v568(v2692);
            l_v2660_0.a = 255;
        end, true);
        v2607.knife.enabled:set_callback(function(v2693)
            -- upvalues: l_v2661_0 (ref), v568 (ref)
            l_v2661_0 = v568(v2693);
        end, true);
        v2607.knife.color:set_callback(function(v2694)
            -- upvalues: l_v2662_0 (ref), v568 (ref)
            l_v2662_0 = v568(v2694);
            l_v2662_0.a = 255;
        end, true);
        v2607.grenade.enabled:set_callback(function(v2695)
            -- upvalues: l_v2663_0 (ref), v568 (ref)
            l_v2663_0 = v568(v2695);
        end, true);
        v2607.grenade.color:set_callback(function(v2696)
            -- upvalues: l_v2664_0 (ref), v568 (ref)
            l_v2664_0 = v568(v2696);
            l_v2664_0.a = 255;
        end, true);
        v2607.purchases.enabled:set_callback(function(v2697)
            -- upvalues: l_v2665_0 (ref), v568 (ref)
            l_v2665_0 = v568(v2697);
        end, true);
        v2607.purchases.color:set_callback(function(v2698)
            -- upvalues: l_v2666_0 (ref), v568 (ref)
            l_v2666_0 = v568(v2698);
            l_v2666_0.a = 255;
        end, true);
        local v2699 = nil;
        v2699 = {};
        local v2700 = nil;
        v2700 = {
            center = {}, 
            left = {}
        };
        do
            local l_v2700_0 = v2700;
            v2699.center = function(v2702, v2703, v2704)
                -- upvalues: l_v2700_0 (ref), l_insert_0 (ref), l_globals_0 (ref)
                local l_center_0 = l_v2700_0.center;
                l_insert_0(l_center_0, 1, {
                    push = 0, 
                    text = v2702, 
                    time = v2703, 
                    start_time = l_globals_0.realtime, 
                    color = v2704
                });
            end;
            v2699.left = function(v2706, v2707, v2708)
                -- upvalues: l_v2700_0 (ref), l_insert_0 (ref), l_globals_0 (ref)
                local l_left_0 = l_v2700_0.left;
                l_insert_0(l_left_0, 1, {
                    push = 0, 
                    text = v2706, 
                    time = v2707, 
                    start_time = l_globals_0.realtime, 
                    avatar = v2708
                });
            end;
            local v2710 = v503("notify", l_vector_0(v119.x - 120, v118.y - 250));
            local function v2748()
                -- upvalues: l_l_parse_0_1 (ref), l_globals_0 (ref), v576 (ref), v2710 (ref), l_vector_0 (ref), v118 (ref), l_v2700_0 (ref), l_v2611_1 (ref), l_to_hex_0 (ref), l_v2660_0 (ref), l_gsub_0 (ref), l_v2658_0 (ref), l_ipairs_0 (ref), l_measure_text_0 (ref), v562 (ref), l_clamp_0 (ref), v542 (ref), l_remove_0 (ref), l_shadow_0 (ref), l_alpha_modulate_0 (ref), l_text_0 (ref), l_color_0 (ref), v539 (ref), l_blur_0 (ref), l_rect_outline_0 (ref), l_min_0 (ref), v119 (ref), l_rect_0 (ref), l_texture_0 (ref)
                local v2711 = l_l_parse_0_1[2];
                local v2712 = l_l_parse_0_1[3];
                if not v2711 and not v2712 then
                    return;
                else
                    local l_frametime_2 = l_globals_0.frametime;
                    local l_realtime_4 = l_globals_0.realtime;
                    if v2711 then
                        local v2715 = v576 > 0;
                        local v2716 = v2710:get_position();
                        local v2717 = 2;
                        local v2718 = l_vector_0(250, 75);
                        local v2719 = v2716.x / v118.x;
                        local l_center_1 = l_v2700_0.center;
                        if v2715 then
                            l_center_1 = {};
                            local l_spread_0 = l_v2611_1.spread;
                            local v2722 = "\a" .. l_to_hex_0(l_v2660_0);
                            l_center_1[1] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("missed {}player{d} in the {}head{d} due to {}" .. l_spread_0, "{}", v2722), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2660_0
                            };
                            l_spread_0 = l_v2611_1.correction;
                            v2722 = "\a" .. l_to_hex_0(l_v2660_0);
                            l_center_1[2] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("missed {}player{d} in the {}head{d} due to {}" .. l_spread_0, "{}", v2722), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2660_0
                            };
                            l_spread_0 = l_v2611_1.misprediction;
                            v2722 = "\a" .. l_to_hex_0(l_v2660_0);
                            l_center_1[3] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("missed {}player{d} in the {}head{d} due to {}" .. l_spread_0, "{}", v2722), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2660_0
                            };
                            l_spread_0 = l_v2611_1["prediction error"];
                            v2722 = "\a" .. l_to_hex_0(l_v2660_0);
                            l_center_1[4] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("missed {}player{d} in the {}head{d} due to {}" .. l_spread_0, "{}", v2722), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2660_0
                            };
                            l_spread_0 = l_v2611_1["backtrack failure"];
                            v2722 = "\a" .. l_to_hex_0(l_v2660_0);
                            l_center_1[5] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("missed {}player{d} in the {}head{d} due to {}" .. l_spread_0, "{}", v2722), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2660_0
                            };
                            l_spread_0 = "\a" .. l_to_hex_0(l_v2658_0);
                            l_center_1[6] = {
                                time = 1, 
                                push = 1, 
                                text = l_gsub_0(l_gsub_0("hit {}player{d} in the {}head{d} for {}100{d} damage {}(0hp left)", "{}", l_spread_0), "{d}", "\aDEFAULT"), 
                                start_time = l_realtime_4, 
                                color = l_v2658_0
                            };
                        end;
                        for v2723, v2724 in l_ipairs_0(l_center_1) do
                            if v2724 then
                                local v2725 = v2724.text:upper();
                                local l_time_0 = v2724.time;
                                local l_start_time_0 = v2724.start_time;
                                local l_color_3 = v2724.color;
                                local v2729 = l_measure_text_0(v562, nil, v2725);
                                local v2730 = l_realtime_4 - l_start_time_0;
                                local v2731 = v2730 >= 0 and v2730 <= l_time_0 and v2723 <= 6;
                                v2724.push = l_clamp_0(v542(1, v2724.push, l_frametime_2 * (v2731 and 4.375 or -4.375), 1), 0, 1);
                                local l_push_0 = v2724.push;
                                if l_time_0 <= v2730 and l_push_0 == 0 then
                                    l_remove_0(l_center_1, v2723);
                                end;
                                l_shadow_0(l_vector_0(v2716.x - (v2729.x - v2718.x) * v2719 + 2, v2716.y + v2717 + 4), l_vector_0(v2716.x - (v2729.x - v2718.x) * v2719 + v2729.x - 6, v2716.y + v2717 + 4), l_alpha_modulate_0(l_color_3, 200 * l_push_0), 22, 2);
                                l_text_0(v562, l_vector_0(v2716.x - (v2729.x - v2718.x) * v2719, v2716.y + v2717), l_color_0(255, 255 * l_push_0), nil, v2725);
                                v2717 = v2717 + 12 * l_push_0;
                            end;
                        end;
                        if v2715 then
                            local l_dragging_1 = v2710.dragging;
                            local v2734 = v539("Drag: Notify", l_dragging_1, 0, 1, 0.035);
                            if l_dragging_1 then
                                l_blur_0(v2716, v2716 + v2718, v2734 * 3, v2734 * 1, v2734 * 6);
                            end;
                            l_text_0(v562, v2716 + l_vector_0(v2718.x * 0.5, -5), l_color_0(255, (1 - v2734) * 255), "c", "PRESS M2 TO DEFAULT POSITION");
                            l_rect_outline_0(v2716, v2716 + v2718, l_color_0(255, l_min_0(1, 1.5 - v2734) * 255), 1, 6, true);
                            v2710:update(v2718);
                        end;
                    end;
                    if v2712 then
                        local v2735 = l_vector_0(0, v119.y + 25);
                        local l_left_1 = l_v2700_0.left;
                        for v2737 = #l_left_1, 1, -1 do
                            local v2738 = l_left_1[v2737];
                            local v2739 = v2738.text:upper();
                            local l_time_1 = v2738.time;
                            local l_start_time_1 = v2738.start_time;
                            local l_avatar_0 = v2738.avatar;
                            local v2743 = l_measure_text_0(v562, nil, v2739);
                            local v2744 = l_realtime_4 - l_start_time_1;
                            local v2745 = v2744 >= 0 and v2744 <= l_time_1 and v2737 <= 5;
                            v2738.push = l_clamp_0(v542(1, v2738.push, l_frametime_2 * (v2745 and 4.375 or -5.375), 1), 0, 1);
                            local l_push_1 = v2738.push;
                            if l_time_1 <= v2744 and l_push_1 == 0 then
                                l_remove_0(l_left_1, v2737);
                            end;
                            local v2747 = 255 * l_push_1;
                            l_rect_0(l_vector_0(3 * l_push_1, v2735.y - 1), l_vector_0((v2743.x + 60) * l_push_1, v2735.y + 30), l_color_0(0, v2747), 4);
                            l_texture_0(l_avatar_0, l_vector_0(3 * l_push_1, v2735.y), l_vector_0(29 * l_push_1, 29), l_color_0(255, v2747), nil, 4);
                            l_text_0(v562, l_vector_0(50 * l_push_1, v2735.y), l_color_0(255, v2747), nil, v2739);
                            v2735.y = v2735.y - 35 * l_push_1;
                        end;
                    end;
                    return;
                end;
            end;
            v502("Notify")("render", v2748);
        end;
        v2700 = 0;
        local v2749 = {
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
        local v2750 = nil;
        v2750 = function(v2751)
            -- upvalues: l_l_decode_0_3 (ref), v2700 (ref), v2749 (ref), l_v2611_1 (ref), l_v2659_0 (ref), l_v2612_1 (ref), l_v2660_0 (ref), l_v2658_0 (ref), l_to_hex_0 (ref), l_l_parse_0_1 (ref), l_format_0 (ref), l_gsub_0 (ref), v2699 (ref), l_floor_0 (ref), l_abs_0 (ref), l_random_0 (ref), l_globals_0 (ref)
            if not l_l_decode_0_3 then
                return;
            else
                v2700 = v2700 + 1;
                local v2752 = v2749[v2751.wanted_hitgroup];
                local l_wanted_damage_0 = v2751.wanted_damage;
                local l_hitchance_0 = v2751.hitchance;
                local l_backtrack_0 = v2751.backtrack;
                local v2756 = v2749[v2751.hitgroup];
                local l_damage_1 = v2751.damage;
                local l_target_2 = v2751.target;
                local l_state_1 = v2751.state;
                local v2760 = l_target_2:get_name();
                local l_m_iHealth_2 = l_target_2.m_iHealth;
                local v2762 = l_v2611_1[l_state_1];
                if v2762 then
                    l_state_1 = v2762;
                end;
                if not (l_state_1 ~= nil and l_v2659_0 or l_state_1 == nil and l_v2612_1) then
                    return;
                else
                    local v2763 = l_state_1 ~= nil and l_v2660_0 or l_v2658_0;
                    local v2764 = "\a" .. l_to_hex_0(v2763);
                    if l_l_parse_0_1[1] then
                        local v2765 = l_format_0("{}[outlaw]{d} [%s]", v2700);
                        if l_state_1 then
                            v2765 = l_format_0("%s Missed shot in %s's {}%s{d}(%s)(%s%%), due to {}%s{d} (b:%s)", v2765, v2760, v2752, l_wanted_damage_0, l_hitchance_0, l_state_1, l_backtrack_0);
                        else
                            v2765 = l_format_0("%s Hit %s's {}%s{d} for %s(%s)(%s%%), (%s remaining), (b:%s)", v2765, v2760, v2756, l_damage_1, l_wanted_damage_0, l_hitchance_0, l_m_iHealth_2, l_backtrack_0);
                        end;
                        local v2766 = l_gsub_0(l_gsub_0(v2765, "{}", v2764), "{d}", "\aDEFAULT");
                        print_raw(v2766);
                    end;
                    if l_l_parse_0_1[2] then
                        local v2767 = nil;
                        if l_state_1 then
                            v2767 = l_format_0("missed {}%s{d} in the {}%s{d} due to {}%s", v2760, v2752, l_state_1);
                        else
                            v2767 = l_format_0("hit {}%s{d} in the {}%s{d} for {}%s{d} damage {}(%shp left)", v2760, v2756, l_damage_1, l_m_iHealth_2);
                        end;
                        v2767 = l_gsub_0(l_gsub_0(v2767, "{}", v2764), "{d}", "\aDEFAULT");
                        v2699.center(v2767, 3, v2763);
                    end;
                    if l_l_parse_0_1[3] then
                        local v2768 = nil;
                        if l_state_1 then
                            v2768 = l_format_0("    Target: {}%s{d}\n    Hitbox: {}%s{d}\n    Reason: {}%s{d}", v2760, v2752, l_state_1);
                        else
                            v2768 = l_format_0("    Target: {}%s{d}\n    Hitbox: {}%s{d}\n    Damage: {}%s(%s){d}", v2760, v2756, l_damage_1, l_wanted_damage_0);
                        end;
                        local v2769 = l_target_2:get_steam_avatar();
                        v2768 = l_gsub_0(l_gsub_0(v2768, "{}", v2764), "{d}", "\aDEFAULT");
                        v2699.left(v2768, 3, v2769);
                    end;
                    if l_l_parse_0_1[4] then
                        local v2770 = l_floor_0(l_target_2.m_flPoseParameter[11] * 116 - 58);
                        local v2771 = v2770 < 0 and "1" or "2";
                        local v2772 = l_abs_0(v2770) < 29 and "2" or "1";
                        local v2773 = (l_random_0(1, 4) == 1 and "E" or "") .. (l_random_0(1, 2) == 1 and "B" or "") .. (l_random_0(1, 3) == 1 and "H" or "");
                        if v2773 ~= "" then
                            v2773 = v2773 .. " ";
                        end;
                        local v2774 = nil;
                        if l_state_1 then
                            v2774 = l_format_0("\aFF7575FF[-] Missed %s' %s for %s (%s%%) due to %s bt=%sms (%s) [%s:%s:%s\194\176] %smove=%s t=%s", v2760, v2752, l_wanted_damage_0, l_hitchance_0, l_state_1, l_backtrack_0 * l_floor_0(l_globals_0.tickinterval * 1000 + 0.5), l_backtrack_0, v2771, v2772, v2770, v2773, l_random_0(0, 1), l_backtrack_0 + 1);
                        else
                            local v2775 = l_damage_1 < l_wanted_damage_0 and "(" .. l_wanted_damage_0 .. ") " or "";
                            v2774 = l_format_0("\aA0CB27FF[+] Hit %s' %s for %s %sdamage (%s%%) bt=%sms (%s) [%s:%s:%s\194\176] %smove=%s t=%s", v2760, v2756, l_damage_1, v2775, l_hitchance_0, l_backtrack_0 * l_floor_0(l_globals_0.tickinterval * 1000 + 0.5), l_backtrack_0, v2771, v2772, v2770, v2773, l_random_0(0, 1), l_backtrack_0 + 1);
                        end;
                        print_dev(v2774);
                    end;
                    return;
                end;
            end;
        end;
        local v2776 = nil;
        local v2777 = {
            knife = "Knifed", 
            inferno = "Burned", 
            hegrenade = "Naded"
        };
        do
            local l_v2777_0 = v2777;
            v2776 = function(v2779, v2780)
                -- upvalues: l_l_decode_0_3 (ref), l_v2777_0 (ref), l_v2661_0 (ref), l_v2663_0 (ref), l_v2662_0 (ref), l_v2664_0 (ref), l_to_hex_0 (ref), l_get_0 (ref), l_l_parse_0_1 (ref), l_format_0 (ref), l_gsub_0 (ref), v2699 (ref)
                if not l_l_decode_0_3 then
                    return;
                else
                    local l_localplayer_24 = v2779.localplayer;
                    local l_is_alive_21 = v2779.is_alive;
                    if l_localplayer_24 == nil or not l_is_alive_21 then
                        return;
                    else
                        local v2783 = l_v2777_0[v2780.weapon];
                        if v2783 == nil then
                            return;
                        else
                            local v2784 = v2783 == "Knifed";
                            if not (v2784 and l_v2661_0 or not v2784 and l_v2663_0) then
                                return;
                            else
                                local v2785 = v2784 and l_v2662_0 or l_v2664_0;
                                local v2786 = "\a" .. l_to_hex_0(v2785);
                                local v2787 = l_get_0(v2780.attacker, true);
                                local v2788 = l_get_0(v2780.userid, true);
                                if v2788 == l_localplayer_24 or v2787 ~= l_localplayer_24 then
                                    return;
                                else
                                    local v2789 = v2788:get_name();
                                    local l_dmg_health_0 = v2780.dmg_health;
                                    local l_health_3 = v2780.health;
                                    if l_l_parse_0_1[1] then
                                        local v2792 = l_format_0("{}[outlaw]{d} %s %s's for %s damage (%s remaining)", v2783, v2789, l_dmg_health_0, l_health_3);
                                        local v2793 = l_gsub_0(l_gsub_0(v2792, "{}", v2786), "{d}", "\aDEFAULT");
                                        print_raw(v2793);
                                    end;
                                    if l_l_parse_0_1[2] then
                                        local v2794 = l_format_0("%s {}%s{d} for {}%s{d} damage", v2783, v2789, l_dmg_health_0);
                                        v2794 = l_gsub_0(l_gsub_0(v2794, "{}", v2786), "{d}", "\aDEFAULT");
                                        v2699.center(v2794, 3, v2785);
                                    end;
                                    if l_l_parse_0_1[3] then
                                        local v2795 = l_format_0("    %s: {}%s{d}\n    damage: {}%s{d}\n    state: {}%s{d}", v2783, v2789, l_dmg_health_0, l_health_3 <= 0 and "dead" or "alive");
                                        local v2796 = v2788:get_steam_avatar();
                                        v2795 = l_gsub_0(l_gsub_0(v2795, "{}", v2786), "{d}", "\aDEFAULT");
                                        v2699.left(v2795, 3, v2796);
                                    end;
                                    if l_l_parse_0_1[4] then
                                        local v2797 = l_format_0("\aA0CB27FF[+] %s %s for %s damage (%s remaining)", v2783, v2789, l_dmg_health_0, l_health_3);
                                        print_dev(v2797);
                                    end;
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v2777 = nil;
        v2777 = function(v2798, v2799)
            -- upvalues: l_l_decode_0_3 (ref), l_v2665_0 (ref), l_get_0 (ref), l_to_hex_0 (ref), l_v2666_0 (ref), l_l_parse_0_1 (ref), l_format_0 (ref), l_gsub_0 (ref)
            if not l_l_decode_0_3 or not l_v2665_0 then
                return;
            else
                local l_localplayer_25 = v2798.localplayer;
                if l_localplayer_25 == nil then
                    return;
                else
                    local v2801 = l_get_0(v2799.userid, true);
                    if v2801 == nil or v2801 == l_localplayer_25 then
                        return;
                    else
                        local v2802 = "\a" .. l_to_hex_0(l_v2666_0);
                        local v2803 = v2801:get_name();
                        local l_weapon_1 = v2799.weapon;
                        if l_l_parse_0_1[1] then
                            local v2805 = l_format_0("{}[outlaw]{d} %s bought %s", v2803, l_weapon_1);
                            local v2806 = l_gsub_0(l_gsub_0(v2805, "{}", v2802), "{d}", "\aDEFAULT");
                            print_raw(v2806);
                        end;
                        if l_l_parse_0_1[4] then
                            local v2807 = l_format_0("\aA0CB27FF[+] %s bought %s", v2803, l_weapon_1);
                            print_dev(v2807);
                        end;
                        return;
                    end;
                end;
            end;
        end;
        l_events_0.aim_ack(v2750);
        v502("Log Events")("player_hurt", v2776);
        v502("Log Events")("item_purchase", v2777);
    end;
    l_encode_0 = nil;
    l_encode_0 = v566.clantag;
    l_decode_0 = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag");
    l_parse_0 = nil;
    v2611 = nil;
    v2612 = nil;
    do
        local l_l_decode_0_4, l_l_parse_0_2, l_v2611_2, l_v2612_2, l_v2658_1, l_v2659_1, l_v2660_1 = l_decode_0, l_parse_0, v2611, v2612, v2658, v2659, v2660;
        l_encode_0.selection:set_callback(function(v2815)
            -- upvalues: v568 (ref), l_l_parse_0_2 (ref), l_v2611_2 (ref), l_find_0 (ref), l_set_clan_tag_0 (ref), v574 (ref), l_l_decode_0_4 (ref)
            local v2816 = v568(v2815);
            local v2817 = l_find_0(v2816, "Disabled") == nil;
            l_v2611_2 = l_find_0(v2816, "Default") ~= nil and 1 or 2;
            l_l_parse_0_2 = v2817;
            l_set_clan_tag_0("");
            v574(l_l_decode_0_4);
            if l_l_parse_0_2 then
                v574(l_l_decode_0_4, false);
            end;
        end, true);
        l_l_decode_0_4:set_callback(function(v2818)
            -- upvalues: v574 (ref), l_l_parse_0_2 (ref)
            v574(v2818);
            if l_l_parse_0_2 then
                v574(v2818, false);
            end;
        end, true);
        l_encode_0.disable_at_low_kd:set_callback(function(v2819)
            -- upvalues: l_v2612_2 (ref), v568 (ref)
            l_v2612_2 = v568(v2819);
        end, true);
        l_v2658_1 = {
            [1] = "", 
            [2] = " a ", 
            [3] = " @ ", 
            [4] = " a| ", 
            [5] = " a1 ", 
            [6] = " @i ", 
            [7] = "ai_ ", 
            [8] = " ai| ", 
            [9] = "@ilml", 
            [10] = "aim_", 
            [11] = "aimt0|", 
            [12] = "aimto0", 
            [13] = "aimto0", 
            [14] = "aimtool_", 
            [15] = "aimtool$|", 
            [16] = "@imt00ls|", 
            [17] = "aimt00ls.", 
            [18] = "aimtools.|", 
            [19] = "aimtool$.w|", 
            [20] = "aimt00l$.#s", 
            [21] = "aimtools.ws", 
            [22] = "aimt00ls.ws", 
            [23] = "aimtools.ws", 
            [24] = "aimtools.w<", 
            [25] = "aimtools.<", 
            [26] = "aimtool$", 
            [27] = "aimto0l<", 
            [28] = "aimto0l<", 
            [29] = "aimt0o<", 
            [30] = "aimto<", 
            [31] = "@imt<", 
            [32] = "aim", 
            [33] = "ai", 
            [34] = "a", 
            [35] = "@", 
            [36] = ""
        };
        l_v2659_1 = nil;
        l_v2660_1 = function(v2820, v2821, v2822)
            -- upvalues: l_globals_0 (ref), l_floor_0 (ref), l_sub_0 (ref)
            local v2823 = "               " .. v2820 .. "                      ";
            local l_tickinterval_0 = l_globals_0.tickinterval;
            local v2825 = (l_globals_0.tickcount + l_floor_0(v2822.latency[0] + 0.25 / l_tickinterval_0 + 0.5)) / l_floor_0(0.3 / l_tickinterval_0 + 0.5);
            v2825 = v2821[l_floor_0(v2825 % #v2821) + 1] + 1;
            return l_sub_0(v2823, v2825, v2825 + 15);
        end;
        v2661 = function(v2826)
            -- upvalues: l_l_parse_0_2 (ref), l_net_channel_0 (ref), l_v2611_2 (ref), l_v2660_1 (ref), l_globals_0 (ref), l_floor_0 (ref), l_fmod_0 (ref), l_v2658_1 (ref), l_get_game_rules_0 (ref), l_v2612_2 (ref), l_v2659_1 (ref), l_set_clan_tag_0 (ref)
            if not l_l_parse_0_2 then
                return;
            else
                local l_localplayer_26 = v2826.localplayer;
                if l_localplayer_26 == nil then
                    return;
                else
                    local v2828 = l_net_channel_0();
                    if v2828 == nil then
                        return;
                    else
                        local v2829 = nil;
                        if l_v2611_2 == 1 then
                            v2829 = l_v2660_1("@outlaws", {
                                [1] = 0, 
                                [2] = 2, 
                                [3] = 3, 
                                [4] = 4, 
                                [5] = 5, 
                                [6] = 6, 
                                [7] = 7, 
                                [8] = 8, 
                                [9] = 9, 
                                [10] = 10, 
                                [11] = 12, 
                                [12] = 12, 
                                [13] = 12, 
                                [14] = 12, 
                                [15] = 12, 
                                [16] = 12, 
                                [17] = 13, 
                                [18] = 13, 
                                [19] = 13, 
                                [20] = 14, 
                                [21] = 16, 
                                [22] = 17, 
                                [23] = 18, 
                                [24] = 19, 
                                [25] = 20, 
                                [26] = 21, 
                                [27] = 22, 
                                [28] = 23, 
                                [29] = 24, 
                                [30] = 25
                            }, v2828);
                        else
                            local v2830 = v2828.latency[0] / l_globals_0.tickinterval;
                            v2829 = l_v2658_1[l_floor_0(l_fmod_0((l_globals_0.tickcount + v2830) / 14, #l_v2658_1)) + 1];
                        end;
                        local v2831 = l_get_game_rules_0();
                        if v2831 ~= nil then
                            local l_m_gamePhase_0 = v2831.m_gamePhase;
                            if l_m_gamePhase_0 == 4 or l_m_gamePhase_0 == 5 then
                                v2829 = l_v2611_2 == 1 and "@outlaws" or "aimtools.ws";
                            end;
                        end;
                        local v2833 = l_localplayer_26:get_resource();
                        local l_m_iKills_0 = v2833.m_iKills;
                        local l_m_iDeaths_0 = v2833.m_iDeaths;
                        if l_v2612_2 and l_m_iKills_0 / l_m_iDeaths_0 < 1 then
                            v2829 = "";
                        end;
                        if v2829 ~= l_v2659_1 then
                            l_set_clan_tag_0(v2829);
                            l_v2659_1 = v2829;
                        end;
                        return;
                    end;
                end;
            end;
        end;
        v2662 = function()
            -- upvalues: l_set_clan_tag_0 (ref)
            l_set_clan_tag_0("");
        end;
        v502("Clan Tag")("render", v2661);
        l_events_0.shutdown(v2662);
    end;
    l_decode_0 = nil;
    l_decode_0 = v566.killsay;
    l_parse_0 = {
        [1] = {
            [1] = "\240\157\144\142\240\157\144\148\240\157\144\147\240\157\144\139\240\157\144\128\240\157\144\150 \240\157\144\136\240\157\144\146 \240\157\144\128 \240\157\144\134\240\157\144\145\240\157\144\132\240\157\144\128\240\157\144\147\240\157\144\132\240\157\144\146\240\157\144\147 \240\157\144\139\240\157\144\148\240\157\144\128", 
            [2] = "\240\157\144\135\240\157\144\158\240\157\144\178, \240\157\144\162 \240\157\144\155\240\157\144\162\240\157\144\157 \240\157\159\147\240\157\159\142\240\157\159\142\240\157\159\142$ \240\157\144\168\240\157\144\167 \240\157\144\178\240\157\144\168\240\157\144\174\240\157\144\171 \240\157\144\167\240\157\144\174\240\157\144\166\240\157\144\155\240\157\144\158\240\157\144\171  \240\157\159\150\240\157\159\150\240\157\159\150", 
            [3] = "\229\191\167\233\131\129[outlaw]\230\145\167\230\175\129\228\184\128\229\136\135!", 
            [4] = "\226\153\155\240\157\144\162\240\157\144\165\240\157\144\165\240\157\144\158\240\157\144\160\240\157\144\154\240\157\144\165 \240\157\144\156\240\157\144\165\240\157\144\174\240\157\144\155\226\153\155", 
            [5] = "\240\157\144\128\240\157\144\139\240\157\144\139 \240\157\144\140\240\157\144\152 \240\157\144\135\240\157\144\142\240\157\144\140\240\157\144\136\240\157\144\132\240\157\144\146 \240\157\144\148\240\157\144\146\240\157\144\132 \240\157\144\142\240\157\144\148\240\157\144\147\240\157\144\139\240\157\144\128\240\157\144\150", 
            [6] = "\240\157\144\178\240\157\144\168\240\157\144\174\240\157\144\173\240\157\144\174\240\157\144\155\240\157\144\158.\240\157\144\156\240\157\144\168\240\157\144\166/@\240\157\144\170\240\157\144\174\240\157\144\158\240\157\144\156\240\157\144\178", 
            [7] = "\240\157\152\189\240\157\153\148 \240\157\153\134\240\157\152\188\240\157\153\141\240\157\153\143\240\157\152\188\240\157\153\143\240\157\152\188\240\157\153\132 \240\157\153\143\240\157\153\128\240\157\152\188\240\157\153\136", 
            [8] = "\240\157\153\138\240\157\153\130 \240\157\153\144\240\157\153\142\240\157\153\128\240\157\153\141 \240\157\153\145\240\157\153\142 \240\157\153\146\240\157\152\188\240\157\153\135\240\157\153\134\240\157\152\189\240\157\153\138\240\157\153\143\240\157\153\142", 
            [9] = "\226\152\134\234\167\129\226\156\172\226\151\166\194\176\203\154\194\176\226\151\166. \201\155\202\144 .\226\151\166\194\176\203\154\194\176\226\151\166\226\156\172\234\167\130\226\152\134", 
            [10] = "\226\152\134\240\157\144\175\240\157\144\162\240\157\144\169\240\157\144\162\240\157\144\177 \240\157\144\156\240\157\144\168\240\157\144\157\240\157\144\158 \240\157\144\156\240\157\144\168\240\157\144\171\240\157\144\169\240\157\144\168\240\157\144\171\240\157\144\154\240\157\144\173\240\157\144\162\240\157\144\168\240\157\144\167\226\152\134", 
            [11] = "\202\141\208\184\208\189\208\184\225\180\132\225\180\155\225\180\135\225\180\169\225\180\132\225\180\155\202\153\208\190 \225\180\168\208\190 \208\177\208\190\225\180\169\209\140\208\177\225\180\135 \225\180\132 \208\177\225\180\167\225\180\128\225\180\166\208\190\225\180\168\208\190\225\180\167\209\131\209\135\208\184\225\180\135\202\141", 
            [12] = "\226\152\134\234\167\129\226\156\172\226\151\166\194\176\203\154\194\176\226\151\166. \201\174\202\143 \201\174\201\155\214\134\200\182 \202\159\202\138\199\159 .\226\151\166\194\176\203\154\194\176\226\151\166\226\156\172\234\167\130\226\152\134", 
            [13] = "\240\157\153\151\240\157\153\154\240\157\153\163\240\157\153\170\240\157\153\169\240\157\153\175\240\157\153\154 \240\157\153\153\240\157\153\150\240\157\153\168 \240\157\153\170\240\157\153\167\240\157\153\168\240\157\153\165\240\157\153\167\195\188\240\157\153\163\240\157\153\156\240\157\153\161\240\157\153\158\240\157\153\152\240\157\153\157\240\157\153\154 \240\157\153\168\240\157\153\160\240\157\153\167\240\157\153\158\240\157\153\165\240\157\153\169", 
            [14] = "\240\157\153\148\240\157\153\164\240\157\153\170\240\157\153\167 \240\157\153\153\240\157\153\154\240\157\153\150\240\157\153\169\240\157\153\157 \240\157\153\172\240\157\153\150\240\157\153\168 \240\157\153\168\240\157\153\165\240\157\153\164\240\157\153\163\240\157\153\168\240\157\153\164\240\157\153\167\240\157\153\154\240\157\153\153 \240\157\153\151\240\157\153\174 @\240\157\153\164\240\157\153\170\240\157\153\169\240\157\153\161\240\157\153\150\240\157\153\172", 
            [15] = "\240\157\153\164\240\157\153\170\240\157\153\169\240\157\153\161\240\157\153\150\240\157\153\172 \240\157\153\172\240\157\153\158\240\157\153\161\240\157\153\161 \240\157\153\150\240\157\153\161\240\157\153\172\240\157\153\150\240\157\153\174\240\157\153\168 \240\157\153\151\240\157\153\154 \240\157\153\150\240\157\153\157\240\157\153\154\240\157\153\150\240\157\153\153", 
            [16] = "\240\157\153\164\240\157\153\170\240\157\153\169\240\157\153\161\240\157\153\150\240\157\153\172 \240\157\153\172\240\157\153\158\240\157\153\161\240\157\153\161 \240\157\153\150\240\157\153\161\240\157\153\172\240\157\153\150\240\157\153\174\240\157\153\168 \240\157\153\151\240\157\153\154 \240\157\153\150\240\157\153\157\240\157\153\154\240\157\153\150\240\157\153\153", 
            [17] = "\240\157\149\128\240\157\149\138 \240\157\149\132\240\157\149\144 \240\157\149\131\240\157\149\140\240\157\148\184 \240\157\148\185\240\157\148\184\240\157\148\187? \240\157\149\140 \240\157\149\129\240\157\149\140\240\157\149\138\240\157\149\139 \226\132\141\240\157\148\184\240\157\149\141\240\157\148\188\226\132\149\240\157\149\139 \240\157\149\132\240\157\149\134\226\132\149\240\157\148\188\240\157\149\144", 
            [18] = "\240\157\153\168\240\157\153\152\240\157\153\167\240\157\153\158\240\157\153\165\240\157\153\169 \240\157\153\153\240\157\153\154 \240\157\153\150\240\157\153\161\240\157\153\169\240\157\153\150 \240\157\153\152\240\157\153\150\240\157\153\161\240\157\153\158\240\157\153\153\240\157\153\150\240\157\153\153 * \240\157\153\164\240\157\153\170\240\157\153\169\240\157\153\161\240\157\153\150\240\157\153\172 *", 
            [19] = "\226\153\155 \240\157\159\147\240\157\159\142\240\157\159\142$ \240\157\144\139\240\157\144\148\240\157\144\128 \240\157\144\137\240\157\144\136\240\157\144\147\240\157\144\147\240\157\144\132\240\157\144\145 \240\157\144\133\240\157\144\136\240\157\144\151? \240\157\144\139\240\157\144\136\240\157\144\141\240\157\144\138 \240\157\144\136\240\157\144\141 \240\157\144\131\240\157\144\132\240\157\144\146\240\157\144\145\240\157\144\136\240\157\144\143\240\157\144\147\240\157\144\136\240\157\144\142\240\157\144\141", 
            [20] = "\226\153\155 @\240\157\153\138\240\157\153\144\240\157\153\143\240\157\153\135\240\157\152\188\240\157\153\146 \226\153\155", 
            [21] = "\240\157\153\146\240\157\152\188\240\157\153\137\240\157\153\137\240\157\152\188 \240\157\152\189\240\157\153\128 \240\157\153\135\240\157\153\132\240\157\153\134\240\157\153\128 \240\157\153\136\240\157\153\128? \240\157\153\130\240\157\153\128\240\157\153\143 @\240\157\153\138\240\157\153\144\240\157\153\143\240\157\153\135\240\157\152\188\240\157\153\146.\240\157\152\190\240\157\153\135\240\157\153\144\240\157\152\189", 
            [22] = "@\240\157\144\136\240\157\144\157\240\157\159\144\240\157\159\142\240\157\159\142", 
            [23] = "\226\153\155 \240\157\144\172\240\157\144\164\240\157\144\158\240\157\144\158\240\157\144\173.\240\157\144\156\240\157\144\156 \226\153\155", 
            [24] = "\226\153\160\239\184\143 \240\157\144\134\240\157\144\142\240\157\144\131 \240\157\144\129\240\157\144\139\240\157\144\132\240\157\144\146\240\157\144\146\240\157\144\146 \240\157\144\142\240\157\144\148\240\157\144\147\240\157\144\139\240\157\144\128\240\157\144\150.\240\157\144\130\240\157\144\139\240\157\144\148\240\157\144\129 \226\153\160\239\184\143"
        }, 
        [2] = {
            [1] = "\240\157\144\152\240\157\144\168\240\157\144\174 \240\157\144\167\240\157\144\158\240\157\144\158\240\157\144\157 \240\157\144\173\240\157\144\168 \240\157\144\169\240\157\144\154\240\157\144\172\240\157\144\172 \240\157\144\154\240\157\144\167 \240\157\144\128\240\157\144\140\240\157\144\139 \240\157\144\156\240\157\144\161\240\157\144\158\240\157\144\156\240\157\144\164", 
            [2] = "\240\157\149\168\240\157\149\153\240\157\149\170 \240\157\149\170\240\157\149\160\240\157\149\166 \240\157\149\164\240\157\149\160 \240\157\149\147\240\157\149\146\240\157\149\149? \240\157\149\152\240\157\149\160 \240\157\149\161\240\157\149\157\240\157\149\146\240\157\149\170 \240\157\149\131\240\157\149\150\240\157\148\190\240\157\149\154\240\157\149\139", 
            [3] = "\226\153\160\239\184\143 \240\157\153\139\240\157\153\148\240\157\152\190\240\157\152\190\240\157\153\134\240\157\153\144\240\157\153\128 \240\157\152\189\240\157\153\138\240\157\153\139\240\157\153\151\240\157\153\161 \226\153\160\239\184\143", 
            [4] = "\240\157\144\148 \240\157\144\173\240\157\144\158\240\157\144\155\240\157\144\178\240\157\144\154 \240\157\144\179\240\157\144\154\240\157\144\165\240\157\144\158\240\157\144\173!", 
            [5] = "\240\157\149\153\240\157\149\146\240\157\149\164\240\157\149\164\240\157\149\150 \240\157\149\150\240\157\149\164 \240\157\149\160\240\157\149\149\240\157\149\150\240\157\149\163 \240\157\149\157\240\157\149\154\240\157\149\150\240\157\149\147\240\157\149\150 \240\157\149\150\240\157\149\164.", 
            [6] = "\240\157\159\146\240\157\159\144\240\157\159\151\240\157\159\147\240\157\159\145\240\157\159\142\240\157\159\147\240\157\159\148\240\157\159\151\240\157\159\147\240\157\159\145\240\157\159\148\240\157\159\145\240\157\159\144\240\157\159\151\240\157\159\146 \240\157\144\139\240\157\144\168\240\157\144\156\240\157\144\154\240\157\144\173\240\157\144\162\240\157\144\168\240\157\144\167: \240\157\144\128\240\157\144\174\240\157\144\172\240\157\144\173\240\157\144\171\240\157\144\154\240\157\144\165\240\157\144\162\240\157\144\154", 
            [7] = "\240\157\153\170\240\157\153\163\240\157\153\161\240\157\153\164\240\157\153\150\240\157\153\153 \240\157\153\170\240\157\153\167 \240\157\153\168\240\157\153\157\240\157\153\158\240\157\153\169 \240\157\153\165\240\157\153\150\240\157\153\168\240\157\153\169\240\157\153\154", 
            [8] = "\240\157\144\175\240\157\144\158\240\157\144\167\240\157\144\162 \240\157\144\175\240\157\144\162\240\157\144\157\240\157\144\162 \240\157\144\175\240\157\144\162\240\157\144\156\240\157\144\162", 
            [9] = "\240\157\149\164\240\157\149\148\240\157\149\153\240\157\149\157\240\157\149\146\240\157\149\151 \240\157\149\167\240\157\149\150\240\157\149\163\240\157\149\149\240\157\149\146\240\157\149\158\240\157\149\158\240\157\149\165\240\157\149\150\240\157\149\164 \240\157\149\146\240\157\149\163\240\157\149\164\240\157\149\148\240\157\149\153\240\157\149\157\240\157\149\160\240\157\149\148\240\157\149\153", 
            [10] = "\240\157\153\148\240\157\153\164\240\157\153\170\240\157\153\167 \240\157\153\162\240\157\153\164\240\157\153\169\240\157\153\157\240\157\153\154\240\157\153\167 \240\157\153\172\240\157\153\150\240\157\153\163\240\157\153\169\240\157\153\168 \240\157\153\174\240\157\153\164\240\157\153\170 \240\157\153\153\240\157\153\154\240\157\153\150\240\157\153\153", 
            [11] = "[\240\157\159\143\240\157\144\175\240\157\159\143] \240\157\144\146\240\157\144\128\240\157\144\141\240\157\144\130\240\157\144\135\240\157\144\132\240\157\144\153 \240\157\144\136\240\157\144\146 \240\157\144\147\240\157\144\135\240\157\144\128\240\157\144\147 \240\157\144\128 \240\157\144\130\240\157\144\139\240\157\144\142\240\157\144\150\240\157\144\141?", 
            [12] = "\240\157\148\184\226\132\149\240\157\149\139\240\157\149\128-\226\132\153\226\132\141\240\157\149\134\240\157\149\139\240\157\149\134\240\157\148\190\226\132\157\240\157\148\184\226\132\153\226\132\141 \240\157\149\132\240\157\149\134\240\157\148\187\240\157\148\188 \240\157\148\188\226\132\149\240\157\148\184\240\157\148\185\240\157\149\131\240\157\148\188\240\157\148\187", 
            [13] = "\240\157\153\169\240\157\153\167\240\157\153\174 \240\157\153\157\240\157\153\158\240\157\153\169 \240\157\153\162\240\157\153\174 \240\157\153\162\240\157\153\154\240\157\153\169\240\157\153\150 \240\157\153\150\240\157\153\163\240\157\153\169\240\157\153\158\240\157\153\150\240\157\153\158\240\157\153\162\240\157\153\168", 
            [14] = "[\240\157\153\142\240\157\153\157\240\157\153\150\240\157\153\167\240\157\153\160\240\157\153\139\240\157\153\167\240\157\153\164\240\157\153\159\240\157\153\154\240\157\153\152\240\157\153\169] \240\157\153\138\240\157\153\137\240\157\153\128 \240\157\153\145\240\157\153\142 \240\157\152\188\240\157\153\135\240\157\153\135 (\240\157\153\142\240\157\153\143\240\157\153\132\240\157\153\145\240\157\152\188\240\157\153\131\240\157\152\188, \240\157\153\141\240\157\152\188\240\157\153\148\240\157\153\149\240\157\153\128\240\157\153\137, \240\157\153\138\240\157\153\137\240\157\153\128\240\157\153\133, \240\157\153\142\240\157\152\188\240\157\153\137\240\157\152\190\240\157\153\131\240\157\153\128\240\157\153\149\240\157\153\133)", 
            [15] = "\240\157\147\189\240\157\147\177\240\157\147\178\240\157\147\188 \240\157\147\178\240\157\147\188 \240\157\147\182\240\157\148\130 \240\157\147\185\240\157\147\170\240\157\147\187\240\157\147\189\240\157\148\130 \240\157\147\170\240\157\147\183\240\157\147\173 \240\157\148\130\240\157\147\184\240\157\147\190 \240\157\147\170\240\157\147\187\240\157\147\174 \240\157\147\182\240\157\148\130 \240\157\148\128\240\157\147\177\240\157\147\184\240\157\147\187\240\157\147\174 ", 
            [16] = "\239\189\151\239\189\136\239\189\129\239\189\148 \239\189\129\239\189\146\239\189\133 \239\189\149 \239\189\132\239\189\143\239\189\137\239\189\142\239\189\135 \239\189\132\239\189\143\239\189\135", 
            [17] = "\226\153\155 \240\157\144\172\240\157\144\164\240\157\144\158\240\157\144\158\240\157\144\173.\240\157\144\156\240\157\144\156 \226\153\155", 
            [18] = "\240\157\144\137\240\157\144\165\240\157\144\168\240\157\144\171 \240\157\144\129\240\157\159\148\240\157\144\174\240\157\144\129\240\157\144\154\240\157\144\158\240\157\144\147 @\240\157\144\140\240\157\144\174\240\157\144\171\240\157\144\162\240\157\144\167\240\157\144\168\240\157\144\138\240\157\144\147", 
            [19] = "\226\153\155\240\157\144\166\240\157\144\129\240\157\144\142\240\157\144\143\240\157\144\166\240\157\144\166\240\157\159\142\240\157\159\147\240\157\144\145\240\157\144\148\240\157\144\146\226\153\155", 
            [20] = "\240\157\153\137\240\157\153\132\240\157\152\190\240\157\153\128 \240\157\153\141\240\157\153\128\240\157\153\142\240\157\153\138\240\157\153\135\240\157\153\145\240\157\153\128\240\157\153\141 \240\157\153\131\240\157\152\188\240\157\153\131\240\157\152\188\240\157\153\131\240\157\152\188", 
            [21] = "\239\189\147\239\189\139\239\189\133\239\189\133\239\189\148 \239\189\132\239\189\143\239\189\142\239\189\148 \239\189\142\239\189\133\239\189\133\239\189\132 \239\189\149\239\189\144\239\189\132\239\189\129\239\189\148\239\189\133 (\226\151\163_\226\151\162)", 
            [22] = "\240\157\153\136\240\157\153\154\240\157\153\169\240\157\153\150\240\157\153\172\240\157\153\150\240\157\153\174\240\157\153\158\240\157\153\163\240\157\153\156 \240\157\153\167\240\157\153\163... \240\157\153\152\240\157\153\150\240\157\153\163\240\157\153\169 \240\157\153\167\240\157\153\154\240\157\153\165\240\157\153\161\240\157\153\174", 
            [23] = "\240\157\153\156_\240\157\153\130 \240\157\152\189\240\157\153\164\240\157\153\143", 
            [24] = "\240\157\153\158\240\157\153\169 \240\157\153\172\240\157\153\150\240\157\153\168 \240\157\153\162\240\157\153\158\240\157\153\168\240\157\153\169\240\157\153\150\240\157\153\160\240\157\153\154 \240\157\153\169\240\157\153\164 \240\157\153\151\240\157\153\150\240\157\153\163 \240\157\153\162\240\157\153\154 \240\157\153\158\240\157\153\163 \240\157\153\156\240\157\153\150\240\157\153\162\240\157\153\154\240\157\153\168\240\157\153\154\240\157\153\163\240\157\153\168\240\157\153\154", 
            [25] = "\240\157\148\184\240\157\149\138-\240\157\149\138\240\157\148\184\240\157\149\131\240\157\148\184\240\157\149\132 \240\157\148\184\240\157\149\131\240\157\148\184\240\157\149\128\240\157\149\130\240\157\149\140\240\157\149\132", 
            [26] = "\240\157\144\135\240\157\144\158\240\157\144\178, \240\157\144\162 \240\157\144\155\240\157\144\162\240\157\144\157 \240\157\159\147\240\157\159\142\240\157\159\142\240\157\159\142$ \240\157\144\168\240\157\144\167 \240\157\144\178\240\157\144\168\240\157\144\174\240\157\144\171 \240\157\144\167\240\157\144\174\240\157\144\166\240\157\144\155\240\157\144\158\240\157\144\171  \240\157\159\150\240\157\159\150\240\157\159\150", 
            [27] = "\239\188\167\239\189\143\239\188\178\239\189\129\239\189\135\239\189\133 \239\188\175\239\188\178 \239\188\167\239\189\143\239\188\168\239\189\143\239\189\141\239\189\133", 
            [28] = "\240\157\144\142\240\157\144\141\240\157\144\139\240\157\144\136\240\157\144\141\240\157\144\132 \240\157\144\129\240\157\144\142\240\157\144\130\240\157\144\137\240\157\144\165\240\157\144\174\240\157\144\147\240\157\144\154\240\157\144\141\240\157\144\174\240\157\144\132", 
            [29] = "\240\157\144\143\240\157\144\168\240\157\144\129\240\157\144\135\240\157\144\155\240\157\144\165\240\157\144\174_\240\157\144\137\240\157\144\165\240\157\144\154\240\157\144\156\240\157\144\154\240\157\144\135", 
            [30] = "\239\189\148\239\189\136\239\189\133\239\189\146\239\189\133 \239\189\129\239\189\146\239\189\133 \239\189\134\239\189\133\239\189\151 \239\189\140\239\189\137\239\189\139\239\189\133 \239\189\141\239\189\133", 
            [31] = "We are pleased to inform you that your item has been successfully purchased!", 
            [32] = "\226\132\153\240\157\148\188\226\132\149\240\157\149\128\226\132\149\240\157\148\190 \240\157\149\142\240\157\149\128\240\157\149\139\226\132\141 \226\132\157\240\157\148\188\240\157\148\187\240\157\148\185\240\157\149\134\240\157\149\134\240\157\149\131", 
            [33] = "\226\152\133\226\152\133\226\152\133 \240\157\148\190\240\157\149\150\240\157\149\139 \240\157\148\190\240\157\149\160\240\157\149\160\240\157\148\187 \226\152\133\226\152\133\226\152\133", 
            [34] = "\240\157\144\142\240\157\144\176\240\157\144\141\240\157\144\158\240\157\144\131\240\157\144\155\240\157\144\178\240\157\144\130\240\157\144\158\240\157\144\143\240\157\144\158\240\157\144\171\240\157\144\128\240\157\144\138\240\157\144\154\240\157\144\143\240\157\144\154\240\157\144\130\240\157\144\155\240\157\159\143\240\157\159\151\240\157\159\151\240\157\159\148", 
            [35] = "old SANCHEZj is back but i never left [1v1] onej"
        }
    };
    v2611 = nil;
    v2612 = nil;
    v2658 = nil;
    do
        local l_l_parse_0_3, l_v2611_3, l_v2612_3, l_v2658_2, l_v2659_2, l_v2660_2 = l_parse_0, v2611, v2612, v2658, v2659, v2660;
        l_decode_0.selection:set_callback(function(v2842)
            -- upvalues: v568 (ref), l_v2611_3 (ref), l_v2612_3 (ref), l_find_0 (ref)
            local v2843 = v568(v2842);
            local v2844 = l_find_0(v2843, "Disabled") == nil;
            l_v2612_3 = l_find_0(v2843, "Trashtalk") ~= nil and 2 or 1;
            l_v2611_3 = v2844;
        end, true);
        l_decode_0.delay:set_callback(function(v2845)
            -- upvalues: l_v2658_2 (ref), v568 (ref)
            l_v2658_2 = v568(v2845);
        end, true);
        l_v2659_2 = 0;
        l_v2660_2 = function(v2846, v2847)
            -- upvalues: l_v2611_3 (ref), l_get_0 (ref), l_l_parse_0_3 (ref), l_v2612_3 (ref), l_v2659_2 (ref), l_execute_after_0 (ref), l_v2658_2 (ref), l_console_exec_0 (ref)
            if not l_v2611_3 then
                return;
            else
                local l_localplayer_27 = v2846.localplayer;
                local l_is_alive_22 = v2846.is_alive;
                if l_localplayer_27 == nil or not l_is_alive_22 then
                    return;
                else
                    local v2850 = l_get_0(v2847.userid, true);
                    if l_get_0(v2847.attacker, true) ~= l_localplayer_27 or v2850 == l_localplayer_27 then
                        return;
                    else
                        local v2851 = l_l_parse_0_3[l_v2612_3];
                        l_v2659_2 = l_v2659_2 + 1;
                        if l_v2659_2 > #v2851 then
                            l_v2659_2 = 1;
                        end;
                        local v2852 = v2851[l_v2659_2];
                        l_execute_after_0(l_v2658_2, l_console_exec_0, "say " .. v2852);
                        return;
                    end;
                end;
            end;
        end;
        l_decode_0.selection:set_callback(function()
            -- upvalues: v502 (ref), l_v2660_2 (ref), l_v2611_3 (ref)
            v502("Killsay")("player_death", l_v2660_2, l_v2611_3);
        end, true);
    end;
    l_parse_0 = nil;
    l_parse_0 = v566.crosshair_hitmarker;
    v2611 = nil;
    v2612 = nil;
    v2658 = nil;
    do
        local l_v2611_4, l_v2612_4, l_v2658_3, l_v2659_3, l_v2660_3, l_v2661_1, l_v2662_1, l_v2663_1 = v2611, v2612, v2658, v2659, v2660, v2661, v2662, v2663;
        l_parse_0.duration:set_callback(function(v2861)
            -- upvalues: l_v2612_4 (ref), v568 (ref), l_v2611_4 (ref)
            l_v2612_4 = v568(v2861);
            l_v2611_4 = l_v2612_4 ~= 4;
        end, true);
        l_parse_0.color:set_callback(function(v2862)
            -- upvalues: l_v2658_3 (ref), v568 (ref)
            l_v2658_3 = v568(v2862);
        end, true);
        l_v2659_3 = 0;
        l_v2660_3 = v119.x;
        l_v2661_1 = v119.y;
        l_v2662_1 = function()
            -- upvalues: l_v2659_3 (ref), l_globals_0 (ref), l_clamp_0 (ref), l_v2658_3 (ref), l_line_0 (ref), l_vector_0 (ref), l_v2660_3 (ref), l_v2661_1 (ref)
            local v2863 = l_v2659_3 - l_globals_0.realtime;
            local v2864 = 255 * (v2863 * 2);
            if v2864 <= 0 then
                return;
            else
                local v2865 = l_clamp_0(10 * (v2863 * 3.5), 5, 10);
                l_v2658_3.a = v2864;
                l_line_0(l_vector_0(l_v2660_3 - v2865, l_v2661_1 - v2865), l_vector_0(l_v2660_3 - 5, l_v2661_1 - 5), l_v2658_3);
                l_line_0(l_vector_0(l_v2660_3 + v2865, l_v2661_1 + v2865), l_vector_0(l_v2660_3 + 5, l_v2661_1 + 5), l_v2658_3);
                l_line_0(l_vector_0(l_v2660_3 - v2865, l_v2661_1 + v2865), l_vector_0(l_v2660_3 - 5, l_v2661_1 + 5), l_v2658_3);
                l_line_0(l_vector_0(l_v2660_3 + v2865, l_v2661_1 - v2865), l_vector_0(l_v2660_3 + 5, l_v2661_1 - 5), l_v2658_3);
                return;
            end;
        end;
        l_v2663_1 = function(v2866, v2867)
            -- upvalues: l_get_0 (ref), l_v2659_3 (ref), l_globals_0 (ref), l_v2612_4 (ref)
            local l_localplayer_28 = v2866.localplayer;
            local l_is_alive_23 = v2866.is_alive;
            if l_localplayer_28 == nil or not l_is_alive_23 then
                return;
            else
                local v2870 = l_get_0(v2867.userid, true);
                if l_get_0(v2867.attacker, true) ~= l_localplayer_28 or v2870 == l_localplayer_28 then
                    return;
                else
                    l_v2659_3 = l_globals_0.realtime + l_v2612_4 * 0.1;
                    return;
                end;
            end;
        end;
        l_parse_0.duration:set_callback(function()
            -- upvalues: v502 (ref), l_v2662_1 (ref), l_v2611_4 (ref), l_v2663_1 (ref)
            v502("Crosshair Hitmarket")("render", l_v2662_1, l_v2611_4);
            v502("Crosshair Hitmarket")("player_hurt", l_v2663_1, l_v2611_4);
        end, true);
    end;
    v2611 = nil;
    v2611 = v566.custom_thirdperson_animation;
    v2612 = nil;
    v2612 = {
        enabled = ui.find("Visuals", "World", "Main", "Force Thirdperson"), 
        distance = ui.find("Visuals", "World", "Main", "Force Thirdperson", "Distance")
    };
    v2658 = nil;
    v2659 = nil;
    v2660 = nil;
    v2661 = nil;
    do
        local l_v2612_5, l_v2658_4, l_v2659_4, l_v2660_4, l_v2661_2, l_v2662_2 = v2612, v2658, v2659, v2660, v2661, v2662;
        v2611:set_callback(function(v2877)
            -- upvalues: v568 (ref), l_v2658_4 (ref), l_v2659_4 (ref), v574 (ref), l_v2612_5 (ref)
            local v2878 = v568(v2877);
            local v2879 = v2878 ~= 0;
            l_v2659_4 = v2878 * 0.1;
            l_v2658_4 = v2879;
            v574(l_v2612_5.distance);
        end, true);
        l_v2612_5.enabled:set_callback(function(v2880)
            -- upvalues: l_v2660_4 (ref), v568 (ref)
            l_v2660_4 = v568(v2880);
        end, true);
        l_v2612_5.distance:set_callback(function(v2881)
            -- upvalues: l_v2661_2 (ref), v568 (ref)
            l_v2661_2 = v568(v2881);
        end, true);
        l_v2662_2 = function(v2882)
            -- upvalues: v574 (ref), l_v2612_5 (ref), v539 (ref), l_v2660_4 (ref), l_v2661_2 (ref), l_v2659_4 (ref)
            local l_localplayer_29 = v2882.localplayer;
            local l_is_alive_24 = v2882.is_alive;
            if l_localplayer_29 == nil or not l_is_alive_24 then
                return v574(l_v2612_5.distance);
            else
                local v2885 = v539("Custom Thirdperson Animation", l_v2660_4 and l_is_alive_24, 15, l_v2661_2, l_v2659_4);
                v574(l_v2612_5.distance, v2885);
                return;
            end;
        end;
        v2611:set_callback(function()
            -- upvalues: v502 (ref), l_v2662_2 (ref), l_v2658_4 (ref)
            v502("Custom Thirdperson Animation")("render", l_v2662_2, l_v2658_4);
        end, true);
    end;
    v2612 = nil;
    v2612 = v566.custom_console_color;
    v2658 = l_color_0();
    v2659 = nil;
    v2660 = nil;
    do
        local l_v2658_5, l_v2659_5, l_v2660_5, l_v2661_3, l_v2662_3, l_v2663_2, l_v2664_1 = v2658, v2659, v2660, v2661, v2662, v2663, v2664;
        v2612.enabled:set_callback(function(v2893)
            -- upvalues: l_v2659_5 (ref), v568 (ref)
            l_v2659_5 = v568(v2893);
        end, true);
        v2612.color:set_callback(function(v2894)
            -- upvalues: l_v2660_5 (ref), v568 (ref)
            l_v2660_5 = v568(v2894);
        end, true);
        l_v2661_3, l_v2662_3 = utils.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)");
        l_v2663_2 = nil;
        l_v2663_2 = materials.get_materials("vgui/hud/800corner");
        l_v2663_2[#l_v2663_2 + 1] = materials.get_materials("vgui_white")[1];
        l_v2664_1 = function()
            -- upvalues: l_v2659_5 (ref), l_v2662_3 (ref), l_v2660_5 (ref), l_v2658_5 (ref), l_ipairs_0 (ref), l_v2663_2 (ref)
            local v2895 = l_v2659_5 and l_v2662_3 and l_v2660_5 or l_v2658_5;
            local v2896 = v2895.a / 255;
            for _, v2898 in l_ipairs_0(l_v2663_2) do
                v2898:color_modulate(v2895);
                v2898:alpha_modulate(v2896);
            end;
        end;
        v2665 = function()
            -- upvalues: l_v2659_5 (ref), l_v2661_3 (ref), l_v2662_3 (ref), l_v2664_1 (ref)
            if not l_v2659_5 then
                return;
            else
                local v2899 = l_v2661_3();
                if v2899 ~= l_v2662_3 then
                    l_v2662_3 = v2899;
                    l_v2664_1();
                end;
                return;
            end;
        end;
        v2666 = function()
            -- upvalues: l_v2662_3 (ref), l_v2664_1 (ref)
            l_v2662_3 = false;
            l_v2664_1();
        end;
        v2612.enabled:set_callback(l_v2664_1, true);
        v2612.color:set_callback(l_v2664_1, true);
        l_events_0.pre_render(v2665);
        l_events_0.shutdown(v2666);
    end;
    v2658 = nil;
    v2658 = v566.custom_model_opacity;
    v2659 = nil;
    v2660 = nil;
    v2661 = nil;
    v2662 = nil;
    do
        local l_v2659_6, l_v2660_6, l_v2661_4, l_v2662_4, l_v2663_3 = v2659, v2660, v2661, v2662, v2663;
        v2658.mode:set_callback(function(v2905)
            -- upvalues: l_v2659_6 (ref), l_v2660_6 (ref), v568 (ref)
            local v2906 = v568(v2905, "In Scope");
            l_v2660_6 = v568(v2905, "Grenades");
            l_v2659_6 = v2906;
        end, true);
        v2658.transparency.scope:set_callback(function(v2907)
            -- upvalues: l_v2661_4 (ref), v568 (ref)
            l_v2661_4 = v568(v2907) * 2.55;
        end, true);
        v2658.transparency.grenades:set_callback(function(v2908)
            -- upvalues: l_v2662_4 (ref), v568 (ref)
            l_v2662_4 = v568(v2908) * 2.55;
        end, true);
        l_v2663_3 = nil;
        l_v2663_3 = function(v2909)
            -- upvalues: l_v2659_6 (ref), l_v2661_4 (ref), l_v2660_6 (ref), l_v2662_4 (ref)
            local l_localplayer_30 = v2909.localplayer;
            local l_is_alive_25 = v2909.is_alive;
            if l_localplayer_30 == nil or not l_is_alive_25 then
                return;
            else
                local l_m_bIsScoped_2 = l_localplayer_30.m_bIsScoped;
                if l_v2659_6 and l_m_bIsScoped_2 then
                    return l_v2661_4;
                else
                    local l_weapon_info_9 = v2909.weapon_info;
                    if l_weapon_info_9 == nil then
                        return;
                    else
                        local l_weapon_type_3 = l_weapon_info_9.weapon_type;
                        if l_v2660_6 and l_weapon_type_3 == 9 then
                            return l_v2662_4;
                        else
                            return;
                        end;
                    end;
                end;
            end;
        end;
        v2658.enabled:set_callback(function(v2915)
            -- upvalues: v502 (ref), l_v2663_3 (ref), v568 (ref)
            v502("Custom Model Opacity")("localplayer_transparency", l_v2663_3, v568(v2915));
        end, true);
    end;
    v2659 = nil;
    v2659 = v566.state_panel;
    v2660 = v503("state panel", l_vector_0(10, v119.y));
    v2661 = 0;
    v2662 = nil;
    v2662 = {
        [1] = {
            [1] = "aimtools.ws"
        }, 
        [2] = {
            [1] = "", 
            [2] = "a", 
            [3] = "@", 
            [4] = "a| ", 
            [5] = "a1 ", 
            [6] = "@i ", 
            [7] = "ai_ ", 
            [8] = "ai| ", 
            [9] = "@ilml", 
            [10] = "aim_", 
            [11] = "aimt0|", 
            [12] = "aimto0", 
            [13] = "aimto0", 
            [14] = "aimtool_", 
            [15] = "aimtool$|", 
            [16] = "@imt00ls|", 
            [17] = "aimt00ls.", 
            [18] = "aimtools.|", 
            [19] = "aimtool$.w|", 
            [20] = "aimt00l$.#s", 
            [21] = "aimtools.ws", 
            [22] = "aimt00ls.ws", 
            [23] = "aimtools.ws", 
            [24] = "aimtools.w<", 
            [25] = "aimtools.<", 
            [26] = "aimtool$", 
            [27] = "aimto0l<", 
            [28] = "aimto0l<", 
            [29] = "aimt0o<", 
            [30] = "aimto<", 
            [31] = "@imt<", 
            [32] = "aim", 
            [33] = "ai", 
            [34] = "a", 
            [35] = "@", 
            [36] = ""
        }
    };
    v2663 = nil;
    v2664 = nil;
    v2665 = nil;
    v2666 = nil;
    local v2916 = nil;
    do
        local l_v2660_7, l_v2661_5, l_v2662_5, l_v2663_4, l_v2664_2, l_v2665_1, l_v2666_1, l_v2916_0 = v2660, v2661, v2662, v2663, v2664, v2665, v2666, v2916;
        v2659.enabled:set_callback(function(v2925)
            -- upvalues: l_v2663_4 (ref), v568 (ref)
            l_v2663_4 = v568(v2925);
        end, true);
        v2659.selection:set_callback(function(v2926)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v2664_2 (ref)
            local v2927 = v2926:list();
            for _, v2929 in l_ipairs_0(v2927) do
                v2927[v2929] = v568(v2926, v2929);
            end;
            l_v2664_2 = v2927;
        end, true);
        local function v2930()
            -- upvalues: v568 (ref), v2659 (ref), l_v2665_1 (ref), l_v2662_5 (ref)
            l_v2665_1 = l_v2662_5[v568(v2659.animation)];
        end;
        v2659.animation:set_callback(v2930, true);
        v2659.color:set_callback(function(v2931)
            -- upvalues: l_v2666_1 (ref), v568 (ref)
            l_v2666_1 = v568(v2931);
        end, true);
        v2659.reset:set_callback(function(v2932)
            -- upvalues: l_ipairs_0 (ref), v568 (ref), l_v2916_0 (ref)
            local v2933 = v2932:list();
            for _, v2935 in l_ipairs_0(v2933) do
                v2933[v2935] = v568(v2932, v2935);
            end;
            l_v2916_0 = v2933;
        end, true);
        v2930 = nil;
        v566.aimtools.enabled:set_callback(function(v2936)
            -- upvalues: v2930 (ref), v568 (ref)
            v2930 = v568(v2936);
        end, true);
        local function v2968(v2937)
            -- upvalues: v539 (ref), l_v2663_4 (ref), l_floor_0 (ref), l_fmod_0 (ref), l_globals_0 (ref), l_v2665_1 (ref), l_measure_text_0 (ref), v562 (ref), l_v2660_7 (ref), l_v2666_1 (ref), l_to_hex_0 (ref), l_shadow_0 (ref), l_vector_0 (ref), l_text_0 (ref), l_color_0 (ref), l_v2664_2 (ref), l_v2661_5 (ref), v577 (ref), l_concat_0 (ref), v2930 (ref), v582 (ref), v576 (ref), l_rect_outline_0 (ref)
            local v2938 = v539("State Panel: Enabled", l_v2663_4, 0, 1, 0.025);
            if v2938 == 0 then
                return;
            else
                v2938 = v2938 * 255;
                local l_localplayer_31 = v2937.localplayer;
                local l_is_alive_26 = v2937.is_alive;
                if l_localplayer_31 == nil then
                    return;
                else
                    local v2941 = l_v2665_1[l_floor_0(l_fmod_0(l_globals_0.tickcount / 14, #l_v2665_1)) + 1]:upper();
                    local v2942 = l_measure_text_0(v562, nil, v2941);
                    local l_x_9 = v2942.x;
                    local v2944 = l_v2660_7:get_position();
                    local v2945 = 0;
                    local v2946 = v539("State Panel: Text", #v2941 > 2, 0, 1, 0.0349) * v2938;
                    l_v2666_1.a = v2938;
                    local v2947 = "\a" .. l_to_hex_0(l_v2666_1);
                    l_v2666_1.a = v2946;
                    l_shadow_0(v2944 + l_vector_0(0, 5), v2944 + l_vector_0(v2942.x, 5), l_v2666_1);
                    l_text_0(v562, v2944, l_v2666_1, nil, v2941);
                    v2945 = v2945 + 11;
                    local v2948 = l_color_0(255, v2938);
                    if l_v2664_2["Enemy Miss Count"] and l_is_alive_26 then
                        local v2949 = "ENEMY MISS COUNT: " .. v2947 .. l_v2661_5;
                        local v2950 = l_measure_text_0(v562, nil, v2949);
                        if l_x_9 < v2950.x then
                            l_x_9 = v2950.x;
                        end;
                        l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2949);
                        v2945 = v2945 + 11;
                    end;
                    local l_preset_name_0 = v577.preset_name;
                    if l_v2664_2["Current Preset"] and l_preset_name_0 ~= nil and l_is_alive_26 then
                        local v2952 = "CURRENT PRESET: " .. v2947 .. l_preset_name_0;
                        local v2953 = l_measure_text_0(v562, nil, v2952);
                        if l_x_9 < v2953.x then
                            l_x_9 = v2953.x;
                        end;
                        l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2952);
                        v2945 = v2945 + 11;
                    end;
                    local l_advanced_data_0 = v577.advanced_data;
                    if l_advanced_data_0 ~= nil and l_v2664_2["Advanced Phases"] and l_preset_name_0 == "Custom" then
                        local v2955 = {};
                        local l_yaw_4 = l_advanced_data_0.yaw;
                        if l_yaw_4.enabled then
                            v2955[#v2955 + 1] = "YAW: " .. v2947 .. l_yaw_4.index .. "\aDEFAULT ";
                        end;
                        local l_yaw_modifier_3 = l_advanced_data_0.yaw_modifier;
                        if l_yaw_modifier_3.enabled then
                            v2955[#v2955 + 1] = "MODIFIER: " .. v2947 .. l_yaw_modifier_3.index;
                        end;
                        if #v2955 > 0 then
                            v2955 = l_concat_0(v2955);
                            local v2958 = l_measure_text_0(v562, nil, v2955);
                            if l_x_9 < v2958.x then
                                l_x_9 = v2958.x;
                            end;
                            l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2955);
                            v2945 = v2945 + 11;
                        end;
                        local l_body_yaw_3 = l_advanced_data_0.body_yaw;
                        if l_body_yaw_3.enabled then
                            local v2960 = "BODY YAW: " .. v2947 .. l_body_yaw_3.index;
                            local v2961 = l_measure_text_0(v562, nil, v2960);
                            if l_x_9 < v2961.x then
                                l_x_9 = v2961.x;
                            end;
                            l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2960);
                            v2945 = v2945 + 11;
                        end;
                        local l_defensive_1 = l_advanced_data_0.defensive;
                        if l_defensive_1.enabled then
                            local v2963 = "DEFENSIVE: " .. v2947 .. l_defensive_1.index;
                            local v2964 = l_measure_text_0(v562, nil, v2963);
                            if l_x_9 < v2964.x then
                                l_x_9 = v2964.x;
                            end;
                            l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2963);
                            v2945 = v2945 + 11;
                        end;
                    end;
                    if v2930 and l_v2664_2["Aimtools Status"] and l_is_alive_26 then
                        local v2965 = "AIMTOOLS STATUS: " .. v2947 .. (v582.is_working and "WORKING" or "NOT WORKING");
                        local v2966 = l_measure_text_0(v562, nil, v2965);
                        if l_x_9 < v2966.x then
                            l_x_9 = v2966.x;
                        end;
                        l_text_0(v562, v2944 + l_vector_0(0, v2945), v2948, nil, v2965);
                        v2945 = v2945 + 11;
                    end;
                    local v2967 = l_vector_0(l_x_9, v2945);
                    if v576 > 0 then
                        l_rect_outline_0(v2944 - l_vector_0(1, 1), v2944 + v2967 + l_vector_0(1, 1), v2948, 1, 6, true);
                    end;
                    l_v2660_7:update(v2967);
                    return;
                end;
            end;
        end;
        local v2969 = {};
        local function v2981(v2970, v2971)
            -- upvalues: l_v2663_4 (ref), l_get_0 (ref), v111 (ref), v110 (ref), v105 (ref), l_vector_0 (ref), l_dist_0 (ref), l_closest_ray_point_0 (ref), l_execute_after_0 (ref), l_floor_0 (ref), l_globals_0 (ref), v2969 (ref), l_v2661_5 (ref)
            if not l_v2663_4 then
                return;
            else
                local l_localplayer_32 = v2970.localplayer;
                local l_is_alive_27 = v2970.is_alive;
                if l_localplayer_32 == nil or not l_is_alive_27 then
                    return;
                else
                    local l_userid_0 = v2971.userid;
                    local v2975 = l_get_0(l_userid_0, true);
                    if not v2975 or v2975 == l_localplayer_32 or not v111(v2975) or not v110(v2975) then
                        return;
                    else
                        local l_eye_position_8 = v2970.eye_position;
                        local v2977 = v105(v2975);
                        local v2978 = l_vector_0(v2971.x, v2971.y, v2971.z);
                        if l_dist_0(l_closest_ray_point_0(l_eye_position_8, v2978, v2977), l_eye_position_8) > 100 then
                            return;
                        else
                            local l_m_iHealth_3 = l_localplayer_32.m_iHealth;
                            l_execute_after_0(0.01, function()
                                -- upvalues: l_floor_0 (ref), l_globals_0 (ref), l_m_iHealth_3 (ref), l_localplayer_32 (ref), v2969 (ref), l_userid_0 (ref), l_v2661_5 (ref)
                                local v2980 = l_floor_0(l_globals_0.realtime);
                                if l_m_iHealth_3 ~= l_localplayer_32.m_iHealth or v2969[l_userid_0] == v2980 then
                                    return;
                                else
                                    l_v2661_5 = l_v2661_5 + 1;
                                    v2969[l_userid_0] = v2980;
                                    return;
                                end;
                            end);
                            return;
                        end;
                    end;
                end;
            end;
        end;
        local function v2982()
            -- upvalues: l_v2916_0 (ref), l_v2661_5 (ref)
            if not l_v2916_0["Round Start"] then
                return;
            else
                l_v2661_5 = 0;
                return;
            end;
        end;
        local function v2983()
            -- upvalues: l_v2916_0 (ref), l_v2661_5 (ref)
            if not l_v2916_0["After Game"] then
                return;
            else
                l_v2661_5 = 0;
                return;
            end;
        end;
        local function v2988(v2984, v2985)
            -- upvalues: l_v2916_0 (ref), l_get_0 (ref), l_v2661_5 (ref)
            if not l_v2916_0["After Localplayer Death"] then
                return;
            else
                local l_localplayer_33 = v2984.localplayer;
                local l_is_alive_28 = v2984.is_alive;
                if l_localplayer_33 == nil or not l_is_alive_28 then
                    return;
                elseif l_get_0(v2985.userid, true) ~= l_localplayer_33 then
                    return;
                else
                    l_v2661_5 = 0;
                    return;
                end;
            end;
        end;
        local function v2989()
            -- upvalues: l_v2661_5 (ref)
            l_v2661_5 = 0;
        end;
        v502("State Panel")("render", v2968);
        v502("State Panel")("bullet_impact", v2981);
        l_events_0.round_start(v2982);
        l_events_0.cs_win_panel_match(v2983);
        v502("State Panel")("player_death", v2988);
        v2659.button_reset:set_callback(v2989);
    end;
    v2660 = nil;
    v2660 = v566.override_viewmodel;
    v2661 = nil;
    v2662 = nil;
    v2663 = nil;
    v2664 = nil;
    v2665 = nil;
    v2666 = nil;
    do
        local l_v2661_6, l_v2662_6, l_v2663_5, l_v2664_3, l_v2665_2, l_v2666_2, l_v2916_1 = v2661, v2662, v2663, v2664, v2665, v2666, v2916;
        v2660.enabled:set_callback(function(v2997)
            -- upvalues: l_v2661_6 (ref), v568 (ref)
            l_v2661_6 = v568(v2997);
        end, true);
        v2660.fov:set_callback(function(v2998)
            -- upvalues: l_v2662_6 (ref), v568 (ref)
            l_v2662_6 = v568(v2998) * 0.1;
        end, true);
        v2660.x:set_callback(function(v2999)
            -- upvalues: l_v2663_5 (ref), v568 (ref)
            l_v2663_5 = v568(v2999) * 0.1;
        end, true);
        v2660.y:set_callback(function(v3000)
            -- upvalues: l_v2664_3 (ref), v568 (ref)
            l_v2664_3 = v568(v3000) * 0.1;
        end, true);
        v2660.z:set_callback(function(v3001)
            -- upvalues: l_v2665_2 (ref), v568 (ref)
            l_v2665_2 = v568(v3001) * 0.1;
        end, true);
        v2660.reverse_on_knife:set_callback(function(v3002)
            -- upvalues: l_v2666_2 (ref), v568 (ref)
            l_v2666_2 = v568(v3002);
        end, true);
        l_v2916_1 = nil;
        l_v2916_1 = {
            fov = cvar.viewmodel_fov, 
            x = cvar.viewmodel_offset_x, 
            y = cvar.viewmodel_offset_y, 
            z = cvar.viewmodel_offset_z, 
            cl_righthand = cvar.cl_righthand, 
            data = {}
        };
        l_v2916_1.data.fov = l_v2916_1.fov:float();
        l_v2916_1.data.x = l_v2916_1.x:float();
        l_v2916_1.data.y = l_v2916_1.y:float();
        l_v2916_1.data.z = l_v2916_1.z:float();
        l_v2916_1.data.cl_righthand = l_v2916_1.cl_righthand:int();
        l_v2916_1.data.get = true;
        local function v3003()
            -- upvalues: l_v2661_6 (ref), l_v2916_1 (ref), l_v2662_6 (ref), l_v2663_5 (ref), l_v2664_3 (ref), l_v2665_2 (ref)
            if l_v2661_6 then
                if l_v2916_1.data.get then
                    l_v2916_1.data.fov = l_v2916_1.fov:float();
                    l_v2916_1.data.x = l_v2916_1.x:float();
                    l_v2916_1.data.y = l_v2916_1.y:float();
                    l_v2916_1.data.z = l_v2916_1.z:float();
                    l_v2916_1.data.get = false;
                end;
            else
                l_v2916_1.data.get = true;
            end;
            l_v2916_1.fov:float(l_v2661_6 and l_v2662_6 or l_v2916_1.data.fov, true);
            l_v2916_1.x:float(l_v2661_6 and l_v2663_5 or l_v2916_1.data.x, true);
            l_v2916_1.y:float(l_v2661_6 and l_v2664_3 or l_v2916_1.data.y, true);
            l_v2916_1.z:float(l_v2661_6 and l_v2665_2 or l_v2916_1.data.z, true);
        end;
        local v3004 = nil;
        local function v3011(v3005)
            -- upvalues: l_v2661_6 (ref), l_v2666_2 (ref), v3004 (ref), l_v2916_1 (ref)
            if not l_v2661_6 or not l_v2666_2 then
                return;
            else
                local l_localplayer_34 = v3005.localplayer;
                local l_is_alive_29 = v3005.is_alive;
                if l_localplayer_34 == nil or not l_is_alive_29 then
                    return;
                else
                    local l_weapon_info_10 = v3005.weapon_info;
                    if l_weapon_info_10 == nil then
                        return;
                    else
                        local l_weapon_name_3 = l_weapon_info_10.weapon_name;
                        if v3004 ~= l_weapon_name_3 then
                            local v3010;
                            if l_weapon_name_3 == "weapon_knife" then
                                v3010 = l_v2916_1.data.cl_righthand == 0 and 1 or 0;
                            else
                                v3010 = l_v2916_1.data.cl_righthand;
                            end;
                            l_v2916_1.cl_righthand:int(v3010);
                            v3004 = l_weapon_name_3;
                        elseif l_weapon_name_3 ~= "weapon_knife" then
                            l_v2916_1.data.cl_righthand = l_v2916_1.cl_righthand:int();
                        end;
                        return;
                    end;
                end;
            end;
        end;
        local function v3012()
            -- upvalues: l_v2661_6 (ref), l_v2666_2 (ref), l_v2916_1 (ref)
            if l_v2661_6 and l_v2666_2 then
                return;
            else
                l_v2916_1.cl_righthand:int(l_v2916_1.data.cl_righthand);
                return;
            end;
        end;
        local function v3013()
            -- upvalues: v2660 (ref), l_v2916_1 (ref)
            v2660.fov:set(l_v2916_1.data.fov * 10);
            v2660.x:set(l_v2916_1.data.x * 10);
            v2660.y:set(l_v2916_1.data.y * 10);
            v2660.z:set(l_v2916_1.data.z * 10);
        end;
        local function v3014()
            -- upvalues: l_v2916_1 (ref)
            l_v2916_1.fov:float(l_v2916_1.data.fov, true);
            l_v2916_1.x:float(l_v2916_1.data.x, true);
            l_v2916_1.y:float(l_v2916_1.data.y, true);
            l_v2916_1.z:float(l_v2916_1.data.z, true);
            l_v2916_1.cl_righthand:int(l_v2916_1.data.cl_righthand);
        end;
        v2660.enabled:set_callback(v3003, true);
        v2660.enabled:set_callback(v3012);
        v2660.fov:set_callback(v3003, true);
        v2660.x:set_callback(v3003, true);
        v2660.y:set_callback(v3003, true);
        v2660.z:set_callback(v3003, true);
        v2660.reverse_on_knife:set_callback(v3012);
        v2660.reset:set_callback(v3013);
        v502("Override Viewmodel")("createmove", v3011);
        l_events_0.shutdown(v3014);
    end;
    v2661 = nil;
    v2661 = v566.override_aspectratio;
    v2662 = cvar.r_aspectratio;
    do
        local l_v2662_7 = v2662;
        v2663 = function()
            -- upvalues: v568 (ref), v2661 (ref), l_v2662_7 (ref)
            local v3016 = v568(v2661.enabled);
            local v3017 = v568(v2661.value) * 0.01;
            if not v3016 or v3017 == 0.59 then
                v3017 = 0;
            end;
            l_v2662_7:float(v3017, true);
        end;
        v2664 = function()
            -- upvalues: l_v2662_7 (ref)
            l_v2662_7:float(0, true);
        end;
        v2661.enabled:set_callback(v2663, true);
        v2661.value:set_callback(v2663, true);
        l_v2662_7:set_callback(v2663);
        l_events_0.shutdown(v2664);
    end;
    v2662 = nil;
    v2663 = nil;
    v2663 = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")
    };
    v2664 = nil;
    v2663.yaw = {
        mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
        base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden")
    };
    v2665 = nil;
    v2663.yaw_modifier = {
        mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
    };
    v2666 = nil;
    v2663.body_yaw = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
    };
    v2916 = nil;
    v2663.extended_angles = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"), 
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"), 
        roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
    };
    v2664 = nil;
    v2664 = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
    };
    v2665 = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled");
    v2666 = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement");
    v2916 = nil;
    v2916 = {
        enabled = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        disablers = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers")
    };
    local v3018 = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points");
    local v3019 = nil;
    v3019 = {
        enabled = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop"), 
        options = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Options"), 
        doubletap = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Stop", "Double Tap"), 
        autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop")
    };
    local v3020 = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes");
    local v3021 = nil;
    v3021 = {
        enabled = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint"), 
        head_scale = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"), 
        body_scale = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale")
    };
    local v3022 = nil;
    v3022 = {
        main = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        doubletap = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance", "Double Tap")
    };
    local v3023 = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Extended Backtrack");
    local v3024 = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
    local v3025 = ui.find("Aimbot", "Ragebot", "Selection", "Penetrate Walls");
    local v3026 = ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety");
    local v3027 = ui.find("Aimbot", "Ragebot", "Accuracy", "Auto Scope");
    do
        local l_v2663_6, l_v2664_4, l_v2665_3, l_v2666_3, l_v2916_2, l_v3018_0, l_v3019_0, l_v3020_0, l_v3021_0, l_v3022_0, l_v3023_0, l_v3024_0, l_v3025_0, l_v3026_0, l_v3027_0 = v2663, v2664, v2665, v2666, v2916, v3018, v3019, v3020, v3021, v3022, v3023, v3024, v3025, v3026, v3027;
        v2662 = function()
            -- upvalues: v576 (ref), v574 (ref), l_v2663_6 (ref), l_v2664_4 (ref), l_v2665_3 (ref), l_v2666_3 (ref), l_v2916_2 (ref), l_v3018_0 (ref), l_v3019_0 (ref), l_v3020_0 (ref), l_v3021_0 (ref), l_v3022_0 (ref), l_v3023_0 (ref), l_v3024_0 (ref), l_v3025_0 (ref), l_v3026_0 (ref), l_v3027_0 (ref)
            if v576 == 0 then
                return;
            else
                v574(l_v2663_6.enabled);
                v574(l_v2663_6.pitch);
                local l_yaw_5 = l_v2663_6.yaw;
                v574(l_yaw_5.mode);
                v574(l_yaw_5.base);
                v574(l_yaw_5.offset);
                v574(l_yaw_5.hidden);
                local l_yaw_modifier_4 = l_v2663_6.yaw_modifier;
                v574(l_yaw_modifier_4.mode);
                v574(l_yaw_modifier_4.offset);
                local l_body_yaw_4 = l_v2663_6.body_yaw;
                v574(l_body_yaw_4.enabled);
                v574(l_body_yaw_4.inverter);
                v574(l_body_yaw_4.left_limit);
                v574(l_body_yaw_4.right_limit);
                v574(l_body_yaw_4.options);
                v574(l_body_yaw_4.freestanding);
                local l_extended_angles_0 = l_v2663_6.extended_angles;
                v574(l_extended_angles_0.enabled);
                v574(l_extended_angles_0.pitch);
                v574(l_extended_angles_0.roll);
                v574(l_v2664_4.enabled);
                v574(l_v2664_4.disable_yaw_modifiers);
                v574(l_v2664_4.body_freestanding);
                v574(l_v2665_3);
                v574(l_v2666_3);
                v574(l_v2916_2.enabled);
                v574(l_v2916_2.disablers);
                v574(l_v3018_0);
                v574(l_v3019_0.enabled);
                v574(l_v3019_0.options);
                v574(l_v3019_0.doubletap);
                v574(l_v3019_0.autopeek);
                v574(l_v3020_0);
                v574(l_v3021_0.enabled);
                v574(l_v3021_0.head_scale);
                v574(l_v3021_0.body_scale);
                v574(l_v3022_0.main);
                v574(l_v3022_0.doubletap);
                v574(l_v3023_0);
                v574(l_v3024_0);
                v574(l_v3025_0);
                v574(l_v3026_0);
                v574(l_v3027_0);
                return;
            end;
        end;
        l_events_0.render(v2662);
    end;
end, function(_)
    -- upvalues: v2 (ref)
    if not v2 then
        return;
    else
        print(print_error);
        return;
    end;
end);