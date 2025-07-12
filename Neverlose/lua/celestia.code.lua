local l_world_to_screen_0 = render.world_to_screen;
local l_weapon_fire_0 = events.weapon_fire;
local l_sqrt_0 = math.sqrt;
local l_circle_0 = render.circle;
local l_grenade_override_view_0 = events.grenade_override_view;
local l_grenade_warning_0 = events.grenade_warning;
local l_grenade_prediction_0 = events.grenade_prediction;
local l_get_offscreen_0 = render.get_offscreen;
local l_circle_gradient_0 = render.circle_gradient;
local l_band_0 = bit.band;
local l_cast_0 = ffi.cast;
local _ = ffi.copy;
local _ = ffi.new;
local l_typeof_0 = ffi.typeof;
local _ = utils.opcode_scan;
local _ = common.get_config_name;
local l_get_system_time_0 = common.get_system_time;
local l_get_username_0 = common.get_username;
local l_get_0 = entity.get;
local l_get_local_player_0 = entity.get_local_player;
local l_aim_ack_0 = events.aim_ack;
local l_aim_fire_0 = events.aim_fire;
local l_bomb_beginplant_0 = events.bomb_beginplant;
local _ = events.client_disconnect;
local l_createmove_0 = events.createmove;
local l_mouse_input_0 = events.mouse_input;
local l_player_connect_full_0 = events.player_connect_full;
local l_item_purchase_0 = events.item_purchase;
local l_player_death_0 = events.player_death;
local l_player_hurt_0 = events.player_hurt;
local l_pre_render_0 = events.pre_render;
local l_render_0 = events.render;
local _ = events.round_end;
local l_round_start_0 = events.round_start;
local _ = events.shutdown;
local l_stringify_0 = json.stringify;
local l_max_0 = math.max;
local l_random_0 = math.random;
local _ = network.get;
local _ = string.format;
local _ = utils.execute_after;
local l_tostring_0 = tostring;
local l_pcall_0 = pcall;
local l_insert_0 = table.insert;
local l_get_alpha_0 = ui.get_alpha;
local l_ipairs_0 = ipairs;
local l_find_0 = ui.find;
local l_console_exec_0 = utils.console_exec;
local l_color_0 = color;
local l_pairs_0 = pairs;
local l_load_image_0 = render.load_image;
local l_screen_size_0 = render.screen_size;
local l_char_0 = string.char;
local l_gsub_0 = string.gsub;
local l_create_0 = ui.create;
local l_get_style_0 = ui.get_style;
local l_vector_0 = vector;
local l_getmetatable_0 = getmetatable;
local l_require_0 = require;
local l_get_icon_0 = ui.get_icon;
local l_random_int_0 = utils.random_int;
local l_lshift_0 = bit.lshift;
local l_get_unixtime_0 = common.get_unixtime;
local l_is_button_down_0 = common.is_button_down;
local _ = common.reload_script;
local l_set_clan_tag_0 = common.set_clan_tag;
local _ = common.unload_script;
local l_get_entities_0 = entity.get_entities;
local l_get_game_rules_0 = entity.get_game_rules;
local l_get_player_resource_0 = entity.get_player_resource;
local l_get_players_0 = entity.get_players;
local l_get_threat_0 = entity.get_threat;
local _ = files.create_folder;
local _ = files.get_size;
local _ = files.read;
local _ = files.write;
local l_get_materials_0 = materials.get_materials;
local l_cos_0 = math.cos;
local l_rad_0 = math.rad;
local l_atan2_0 = math.atan2;
local l_ceil_0 = math.ceil;
local l_clamp_0 = math.clamp;
local l_floor_0 = math.floor;
local l_fmod_0 = math.fmod;
local l_min_0 = math.min;
local l_normalize_yaw_0 = math.normalize_yaw;
local _ = network.post;
local l_load_font_0 = render.load_font;
local l_push_clip_rect_0 = render.push_clip_rect;
local l_rect_0 = render.rect;
local l_shadow_0 = render.shadow;
local l_text_0 = render.text;
local l_find_1 = table.find;
local l_remove_0 = table.remove;
local l_sidebar_0 = ui.sidebar;
local l_create_interface_0 = utils.create_interface;
local l_execute_after_1 = utils.execute_after;
local _ = error;
local l_parse_0 = json.parse;
local l_exp_0 = math.exp;
local l_circle_3d_outline_0 = render.circle_3d_outline;
local l_circle_outline_0 = render.circle_outline;
local l_gradient_0 = render.gradient;
local l_line_0 = render.line;
local l_load_image_from_file_0 = render.load_image_from_file;
local l_measure_text_0 = render.measure_text;
local _ = render.poly;
local l_pop_clip_rect_0 = render.pop_clip_rect;
local l_rect_outline_0 = render.rect_outline;
local l_texture_0 = render.texture;
local l_concat_0 = table.concat;
local l_get_binds_0 = ui.get_binds;
local l_get_mouse_position_0 = ui.get_mouse_position;
local l_net_channel_0 = utils.net_channel;
local l_trace_bullet_0 = utils.trace_bullet;
local l_camera_position_0 = render.camera_position;
local l_camera_angles_0 = render.camera_angles;
local l_sort_0 = table.sort;
local l_trace_line_0 = utils.trace_line;
local l_type_0 = type;
local _ = callback;
local l_abs_0 = math.abs;
local l_sin_0 = math.sin;
local l_format_1 = string.format;
local l_cdef_0 = ffi.cdef;
local v125 = l_require_0("neverlose/chernobyl_library");
local v126 = l_require_0("neverlose/clipboard");
l_cdef_0("    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);\n    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);\n    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);\n\n    typedef struct {\n        char  pad_0000[20];\n        int order; //0x0014\n        int sequence; //0x0018\n        float prev_cycle; //0x001C\n        float weight; //0x0020\n        float weight_delta_rate; //0x0024\n        float playback_rate; //0x0028\n        float cycle; //0x002C\n        void *owner; //0x0030\n        char  pad_0038[4]; //0x0034\n    } c_animlayers;\n");
l_find_1 = function(v127, v128)
    for v129 = 1, #v127 do
        if v127[v129] == v128 then
            return true;
        end;
    end;
    return false;
end;
l_random_0 = function(v130, v131)
    if v131 == nil then
        v131 = v130;
        v130 = 0;
    end;
    return utils[(not (v130 % 1 == 0) or v131 % 1 ~= 0) and "random_float" or "random_int"](math.min(v130, v131), math.max(v130, v131));
end;
local v132 = l_getmetatable_0(l_color_0());
v132.mix = function(v133, v134, v135)
    -- upvalues: l_color_0 (ref)
    return l_color_0(v133.r * v135 + v134.r * (1 - v135), v133.g * v135 + v134.g * (1 - v135), v133.b * v135 + v134.b * (1 - v135));
end;
v132.modulate_alpha = function(v136, v137)
    -- upvalues: l_color_0 (ref)
    return l_color_0(v136.r, v136.g, v136.b, v137);
end;
v132.math_breathe = function(v138, v139)
    -- upvalues: l_abs_0 (ref), l_sin_0 (ref)
    return l_abs_0(l_sin_0(globals.realtime * (v139 or 1) % math.pi + (v138 or 0)));
end;
v132.typing_text = function(v140, v141)
    -- upvalues: l_format_1 (ref)
    local v142 = 0;
    local v143 = #v140:gsub("[\128-\191]", "");
    local v144 = "";
    for v145 in v140:gmatch(".[\128-\191]*") do
        v142 = v142 + 1;
        local v146 = v142 / v143;
        v144 = l_format_1("%s\a%s%s", v144, v141(v142, v143, v145, v146):to_hex(), v145);
    end;
    return v144;
end;
v132.gradient = function(v147, v148, v149, v150)
    -- upvalues: v132 (ref), l_type_0 (ref)
    return v132.typing_text(l_type_0(v149) == "number" and v150 or v149, function(_, _, _, v154)
        -- upvalues: l_type_0 (ref), v149 (ref), v132 (ref), v147 (ref), v148 (ref)
        if l_type_0(v149) == "number" then
            local v155 = v132.math_breathe(v154, v149);
            return v147:lerp(v148, v155);
        else
            return v147:lerp(v148, v154);
        end;
    end);
end;
entity.get_nearest = function()
    -- upvalues: l_get_local_player_0 (ref), l_camera_position_0 (ref), l_camera_angles_0 (ref), l_vector_0 (ref), l_ipairs_0 (ref), l_get_players_0 (ref)
    local v156 = l_get_local_player_0();
    local v157 = {
        dist = math.huge
    };
    if not v156 or not v156:is_alive() then
        return v157.entity, v157.dist;
    else
        local v158 = l_camera_position_0();
        local v159 = l_camera_angles_0();
        local v160 = l_vector_0():angles(v159);
        for _, v162 in l_ipairs_0(l_get_players_0(true, true)) do
            if v162 ~= v156 and v162:is_alive() then
                local v163 = v162:get_origin():dist_to_ray(v158, v160);
                if v163 < v157.dist then
                    v157.dist = v163;
                    v157.entity = v162;
                end;
            end;
        end;
        return v157.entity, v157.dist;
    end;
end;
local v164 = {
    slow_walk = l_find_0("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    yaw_offset = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    double_tap = l_find_0("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hide_shots = l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    fake_lag = l_find_0("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
    lag_options = l_find_0("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    hs_options = l_find_0("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    hidden = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    freestanding = l_find_0("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    pitch = l_find_0("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    yaw_modifier = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    modifier_offset = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    body_yaw = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    by_options = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    yaw_base = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    by_freestanding = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    left_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    right_limit = l_find_0("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    avoid_backstab = l_find_0("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
    leg_movement = l_find_0("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    fl_limit = l_find_0("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
    fl_var = l_find_0("Aimbot", "Anti Aim", "Fake Lag", "Variability"), 
    fake_duck = l_find_0("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    min_damage = l_find_0("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
    fake_latency = l_find_0("Miscellaneous", "Main", "Other", "Fake Latency"), 
    dormant_aim = l_find_0("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    safe_points = l_find_0("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    body_aim = l_find_0("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    clan_tag = l_find_0("Miscellaneous", "Main", "In-Game", "Clan Tag"), 
    hit_chance = l_find_0("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
    damage_marker = l_find_0("Visuals", "World", "Other", "Hit Marker", "Damage Marker"), 
    marker_3d = l_find_0("Visuals", "World", "Other", "Hit Marker", "3D Marker"), 
    trajectory_color = l_find_0("Visuals", "World", "Other", "Grenade Prediction", "Color"), 
    trajectory_hit_color = ({
        l_find_0("Visuals", "World", "Other", "Grenade Prediction", "Color Hit")
    })[2]
};
local v165 = "UkbQrquVOEZPpjBDyYdS4g3zFs1oWHRJTL5eGlh0CNnacA6f98MxwItKmXvi27";
local v182 = {
    encode = function(v166)
        -- upvalues: v165 (ref)
        return (v166:gsub(".", function(v167)
            local v168 = "";
            local v169 = v167:byte();
            for v170 = 8, 1, -1 do
                v168 = v168 .. (v169 % 2 ^ v170 - v169 % 2 ^ (v170 - 1) > 0 and "1" or "0");
            end;
            return v168;
        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(v171)
            -- upvalues: v165 (ref)
            if #v171 < 6 then
                return "";
            else
                local v172 = 0;
                for v173 = 1, 6 do
                    v172 = v172 + (v171:sub(v173, v173) == "1" and 2 ^ (6 - v173) or 0);
                end;
                return v165:sub(v172 + 1, v172 + 1);
            end;
        end) .. ({
            [1] = "", 
            [2] = "", 
            [3] = ""
        })[#v166 % 3 + 1];
    end, 
    decode = function(v174)
        -- upvalues: l_gsub_0 (ref), v165 (ref), l_char_0 (ref)
        return (l_gsub_0(v174, "[^" .. v165 .. "]", ""):gsub(".", function(v175)
            -- upvalues: v165 (ref)
            if v175 == "" then
                return "";
            else
                local v176 = "";
                local v177 = v165:find(v175) - 1;
                for v178 = 6, 1, -1 do
                    v176 = v176 .. (v177 % 2 ^ v178 - v177 % 2 ^ (v178 - 1) > 0 and "1" or "0");
                end;
                return v176;
            end;
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(v179)
            -- upvalues: l_char_0 (ref)
            if #v179 ~= 8 then
                return "";
            else
                local v180 = 0;
                for v181 = 1, 8 do
                    v180 = v180 + (v179:sub(v181, v181) == "1" and 2 ^ (8 - v181) or 0);
                end;
                return l_char_0(v180);
            end;
        end));
    end
};
local v183 = "lua";
local v960 = new_class():struct("anti_aim")({
    is_fired = false, 
    inverter = false, 
    is_air_exploit = false, 
    current_tick = 0, 
    is_safe_head = false, 
    is_edge_yaw = false, 
    d = false, 
    is_legit_aa_active = false, 
    jitter_switch = false, 
    c = 1, 
    state_list = {}, 
    BIT_FLAG_POINTER = {
        FL_ONGROUND = l_lshift_0(1, 0), 
        FL_DUCKING = l_lshift_0(1, 1)
    }, 
    BIT_FLAG_POINT = {
        FL_DUCKING = 2, 
        FL_ONGROUND = 1, 
        FL_IN_AIR = 0
    }, 
    convert_state = {
        Crouching = 6, 
        ["Air Crouch"] = 5, 
        Jumping = 4, 
        Walking = 2, 
        Standing = 1, 
        ["Slow Walk"] = 3
    }, 
    get_state = function(v184, v185)
        -- upvalues: l_get_local_player_0 (ref), l_band_0 (ref), v164 (ref)
        if not v184.state_list[v185:get_name()] then
            v184.state_list[v185:get_name()] = {
                jump_timer = 0, 
                is_jumping = false
            };
        end;
        local l_m_fFlags_0 = v185.m_fFlags;
        local l_m_flDuckAmount_0 = v185.m_flDuckAmount;
        local v188 = nil;
        local v189 = v185.m_vecVelocity:length();
        local v190 = v185 == l_get_local_player_0();
        local v191 = v184.state_list[v185:get_name()];
        if l_band_0(l_m_fFlags_0, 1) == 1 then
            if v191.jump_timer == 0 then
                v191.jump_timer = globals.curtime;
            end;
            if globals.curtime - v191.jump_timer > 0.06 then
                v191.is_jumping = false;
                v191.jump_timer = 0;
            end;
        else
            v191.is_jumping = true;
            v191.jump_timer = 0;
        end;
        if v190 then
            local v192 = v164.slow_walk:get();
            local v193 = v164.fake_duck:get();
            if l_band_0(l_m_fFlags_0, v184.BIT_FLAG_POINTER.FL_ONGROUND) == v184.BIT_FLAG_POINT.FL_ONGROUND then
                v188 = v192 and v189 > 2 and "Slow Walk" or v189 > 2 and "Walking" or "Standing";
            end;
            if l_band_0(l_m_fFlags_0, v184.BIT_FLAG_POINTER.FL_DUCKING) == v184.BIT_FLAG_POINT.FL_DUCKING then
                v188 = "Crouching";
            end;
            if v193 then
                v188 = "Crouching";
            end;
        else
            if l_band_0(l_m_fFlags_0, v184.BIT_FLAG_POINTER.FL_ONGROUND) == v184.BIT_FLAG_POINT.FL_ONGROUND then
                v188 = v189 > 5 and v189 < 90 and "Slow Walk" or v189 >= 2 and "Walking" or "Standing";
            end;
            if l_band_0(l_m_fFlags_0, v184.BIT_FLAG_POINTER.FL_DUCKING) == v184.BIT_FLAG_POINT.FL_DUCKING then
                v188 = "Crouching";
            end;
        end;
        if v191.is_jumping then
            v188 = l_m_flDuckAmount_0 > 0 and "Air Crouch" or "Jumping";
        end;
        return v188;
    end, 
    start_time = globals.realtime, 
    anti_aim_on_use = function(v194, v195, v196)
        -- upvalues: l_get_local_player_0 (ref), l_get_entities_0 (ref), l_min_0 (ref)
        v194.is_legit_aa_active = false;
        if not v196.menu.anti_aim.tweaks:get("AA on Use") then
            return;
        elseif not v195.in_use then
            v194.start_time = globals.realtime;
            return;
        else
            local v197 = l_get_local_player_0();
            if v197 == nil then
                return;
            else
                local v198 = v197:get_origin();
                local v199 = l_get_entities_0("CPlantedC4");
                local v200 = 999;
                if #v199 > 0 then
                    v200 = v198:dist((v199[1]:get_origin()));
                end;
                local v201 = l_get_entities_0("CHostage");
                local v202 = 999;
                if #v201 > 0 and v201[1] and v201[2] then
                    local v203 = {
                        v201[1]:get_origin(), 
                        v201[2]:get_origin()
                    };
                    v202 = l_min_0(v198:dist(v203[1]), v198:dist(v203[2]));
                end;
                if v202 < 65 and v197.m_iTeamNum ~= 2 then
                    return;
                elseif v200 < 65 and v197.m_iTeamNum ~= 2 then
                    return;
                elseif v195.in_use and globals.realtime - v194.start_time < 0.02 then
                    return;
                else
                    v195.in_use = false;
                    v194.is_legit_aa_active = true;
                    return;
                end;
            end;
        end;
    end, 
    vector_to_angle = function(_, v205)
        -- upvalues: l_atan2_0 (ref), l_sqrt_0 (ref), l_vector_0 (ref)
        local v206 = 0;
        local v207 = 0;
        local v208 = 0;
        if v205.y == 0 and v205.x == 0 then
            v207 = 0;
            v208 = v205.z > 0 and 270 or 90;
        else
            v207 = l_atan2_0(v205.y, v205.x) * 180 / math.pi;
            if v207 < 0 then
                v207 = v207 + 360;
            end;
            v206 = l_sqrt_0(v205.x * v205.x + v205.y * v205.y);
            v208 = l_atan2_0(-v205.z, v206) * 180 / math.pi;
            if v208 < 0 then
                v208 = v208 + 360;
            end;
        end;
        return l_vector_0(v208, v207, 0);
    end, 
    vecnew = l_vector_0(), 
    edge_yaw = function(v209, _, v211)
        -- upvalues: l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_vector_0 (ref), l_normalize_yaw_0 (ref), l_trace_line_0 (ref), l_sort_0 (ref), l_abs_0 (ref), v164 (ref)
        local v212 = l_get_local_player_0();
        v209.is_edge_yaw = false;
        if not v212 or not v211.menu.anti_aim.tweaks:get("Edge Yaw") or v209.is_legit_aa_active or v211.menu.anti_aim.manuals:get() ~= "Disabled" then
            return;
        else
            if globals.choked_commands == 0 then
                v209.vecnew = v212:get_eye_position();
            end;
            local v213 = {};
            local v214 = l_camera_angles_0();
            local v215 = v214 == nil and l_vector_0() or v214;
            for v216 = 18, 360, 18 do
                local v217 = l_normalize_yaw_0(v216);
                local v218 = l_vector_0(0, v217, 0);
                local v219 = v209.vecnew + l_vector_0():angles(v218) * 144;
                local v220 = l_trace_line_0(v209.vecnew, v219);
                if v220.entity and v220.entity:get_classname() == "CWorld" and v220.fraction < 0.3 and v220.fraction > 0 then
                    v213[#v213 + 1] = {
                        vec_trace_end = v220.end_pos, 
                        yaww = v217
                    };
                end;
            end;
            l_sort_0(v213, function(v221, v222)
                return v221.yaww < v222.yaww;
            end);
            local v223 = nil;
            if #v213 >= 2 then
                local v224 = v213[1].vec_trace_end + (v213[#v213].vec_trace_end - v213[1].vec_trace_end) * 0.5;
                v223 = v209:vector_to_angle(v209.vecnew - v224);
            end;
            if v223 then
                local l_y_0 = v215.y;
                local l_y_1 = v223.y;
                local v227 = l_normalize_yaw_0(l_y_1 - l_y_0);
                local v228 = nil;
                v228 = l_normalize_yaw_0(v227);
                v209.is_edge_yaw = true;
                v164.yaw_offset:override(v228);
            end;
            return;
        end;
    end, 
    avoid_collisions = function(_, v230, v231)
        -- upvalues: l_get_local_player_0 (ref), l_camera_angles_0 (ref), l_vector_0 (ref), l_trace_line_0 (ref), l_abs_0 (ref), l_cos_0 (ref), l_rad_0 (ref), l_sin_0 (ref)
        if not v231.menu.miscellaneous.avoid_collisions:get() then
            return;
        else
            local v232 = l_get_local_player_0();
            if not v232 then
                return;
            else
                local v233 = v231.menu.miscellaneous.avoid_coll_dist:get() * 3 + 15;
                local l_y_2 = l_camera_angles_0().y;
                local l_m_vecOrigin_0 = v232.m_vecOrigin;
                local v236 = v232.m_vecVelocity:length();
                local l_huge_0 = math.huge;
                local l_huge_1 = math.huge;
                for v239 = 1, 180 do
                    local v240 = l_vector_0():angles(l_vector_0(0, l_y_2 + v239 - 90, 0));
                    local v241 = l_vector_0(l_m_vecOrigin_0.x + v240.x * 70, l_m_vecOrigin_0.y + v240.y * 70, l_m_vecOrigin_0.z + 60);
                    local v242 = l_trace_line_0(l_m_vecOrigin_0, v241, nil, nil, 1);
                    if l_m_vecOrigin_0:dist(v242.end_pos) <= l_huge_0 then
                        l_huge_0 = l_m_vecOrigin_0:dist(v242.end_pos);
                        l_huge_1 = v239;
                    end;
                end;
                if l_huge_0 <= v233 + 15 and v230.in_jump and not v230.in_moveright and not v230.in_moveleft and not v230.in_back and not v230.in_duck and not v230.in_speed then
                    v230.forwardmove = l_abs_0(v236 * l_cos_0(l_rad_0(l_huge_1)));
                    v230.sidemove = v236 * l_sin_0(l_rad_0(l_huge_1)) * (l_abs_0(l_huge_1 - 90) < 40 and (25 + v233 - l_huge_0) / 15 or 1) * (l_huge_1 >= 90 and 1 or -1);
                end;
                return;
            end;
        end;
    end, 
    edge_bug = function(_, v244, v245)
        -- upvalues: l_get_local_player_0 (ref), l_trace_line_0 (ref), l_vector_0 (ref)
        if not v245.menu.miscellaneous.no_fall_damage:get() then
            return;
        else
            local v246 = l_get_local_player_0();
            if not v246 then
                return;
            else
                local v247 = v246:get_origin();
                if not v247 then
                    return;
                else
                    if v246.m_vecVelocity.z <= -500 then
                        local l_fraction_0 = l_trace_line_0(v247, v247 + l_vector_0(0, 0, -256), v246).fraction;
                        if l_fraction_0 <= 0.26 and l_fraction_0 > 0.05 then
                            v244.in_duck = true;
                        elseif l_fraction_0 <= 0.04 then
                            v244.in_duck = false;
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end, 
    angle = l_vector_0(), 
    super_toss = function(v249, v250, v251)
        -- upvalues: l_vector_0 (ref)
        if not v251.menu.miscellaneous.super_toss:get() then
            return;
        else
            local v252 = entity.get_local_player();
            if not v252 then
                return;
            else
                local v253 = v252:get_player_weapon();
                if not v253 or not v253:get_classname():lower():find("grenade") and not v253:get_classname():lower():find("flashbang") then
                    return;
                else
                    local v254 = v252.m_vecVelocity:length2d() / 245;
                    local v255 = 0;
                    if v250.in_moveright and not v250.in_back and not v250.in_forward then
                        v255 = 1;
                    elseif v250.in_moveleft and not v250.in_back and not v250.in_forward then
                        v255 = -1;
                    elseif v250.in_moveright and (v250.in_back or v250.in_forward) then
                        v255 = 0.7;
                    elseif v250.in_moveleft and (v250.in_back or v250.in_forward) then
                        v255 = -0.7;
                    end;
                    v255 = v255 * v254;
                    v249.angle = v250.view_angles + l_vector_0(-v254, 29 * v255);
                    v250.view_angles = v250.view_angles + l_vector_0(-v254, 28 * v255);
                    return;
                end;
            end;
        end;
    end, 
    super_toss_line = function(v256, v257, v258)
        if not v258.menu.miscellaneous.super_toss:get() then
            return;
        else
            local v259 = entity.get_local_player();
            if not v259 then
                return;
            else
                local v260 = v259:get_player_weapon();
                if not v260 or not v260:get_classname():lower():find("grenade") and not v260:get_classname():lower():find("flashbang") then
                    return;
                else
                    v257.angles = v256.angle;
                    return;
                end;
            end;
        end;
    end, 
    nade_info = {}, 
    collect_prediction_data = function(v261, v262)
        v261.nade_info = v262;
    end, 
    grenade_release = function(v263, v264, v265)
        if not v265.menu.miscellaneous.grenade_release:get() then
            return;
        elseif not v263.nade_info.type then
            return;
        else
            if v263.nade_info.type == "Frag" and (v263.nade_info.damage >= v265.menu.miscellaneous.grenade_release_dmg:get() or v263.nade_info.fatal) then
                if not v263.d then
                    v264.in_attack = true;
                    v263.d = true;
                else
                    v264.in_attack = false;
                    v264.in_attack2 = false;
                    v263.d = false;
                end;
            end;
            v263.nade_info = {};
            return;
        end;
    end, 
    safe_head_weap = {
        [1] = false, 
        [2] = false, 
        [3] = false, 
        [4] = false
    }, 
    safe_head = function(v266, v267, v268)
        -- upvalues: l_get_local_player_0 (ref), l_trace_bullet_0 (ref), l_vector_0 (ref)
        v266.is_safe_head = false;
        v266.safe_head_weap = {
            [1] = false, 
            [2] = false, 
            [3] = false, 
            [4] = false
        };
        if #v268.menu.anti_aim.safe_head:get() == 0 then
            return;
        else
            local v269 = nil;
            local v270 = nil;
            local v271 = nil;
            v269 = false;
            v270 = false;
            v271 = false;
            local v272 = l_get_local_player_0();
            if v272 and v272:is_alive() then
                local v273 = v272:get_player_weapon();
                local v274 = v273 and v273:get_classname():lower() or "";
                v271 = v268.menu.anti_aim.safe_head:get("Air Knife") and (not (v267 ~= "Jumping") or v267 == "Air Crouch") and v274:find("knife") ~= nil;
                v270 = v268.menu.anti_aim.safe_head:get("Air Zeus") and (not (v267 ~= "Jumping") or v267 == "Air Crouch") and v274:find("taser") ~= nil;
                local v275 = entity.get_nearest();
                if v275 and v275:get_origin().z + 5 <= v272:get_origin().z and not v271 and not v270 and l_trace_bullet_0(v275, v275:get_eye_position(), v272:get_hitbox_position(0) + l_vector_0(0, 0, 6)) > 0 then
                    v269 = v268.menu.anti_aim.safe_head:get(v267);
                end;
            end;
            if v269 or v271 or v270 then
                v266.is_safe_head = true;
                v266.safe_head_weap = {
                    [1] = v271, 
                    [2] = v270, 
                    [3] = v268.menu.anti_aim.safe_head:get("Crouching") and v267 == "Crouching", 
                    [4] = v268.menu.anti_aim.safe_head:get("Air Crouch") and v267 == "Air Crouch"
                };
                rage.antiaim:inverter(v271);
            end;
            return;
        end;
    end, 
    defensive_anti_aim = function(v276, v277, v278)
        -- upvalues: v164 (ref), l_get_local_player_0 (ref)
        v164.lag_options:override("On Peek");
        v164.hs_options:override("Favor Fire Rate");
        v164.hidden:override(false);
        if v278.menu.anti_aim.lc_disabler:get("Freestand") and v164.freestanding:get() or not v278.menu.anti_aim.force_lc:get() then
            return;
        elseif v278.menu.anti_aim.lc_disabler:get("Manuals") and v278.menu.anti_aim.manuals:get() ~= "Disabled" or v276.is_air_exploit then
            return;
        elseif v276.is_legit_aa_active or v276.is_edge_yaw then
            return;
        else
            local v279 = nil;
            local v280 = l_get_local_player_0();
            v279 = v280 and v280:get_player_weapon() or nil;
            if not v279 or v279.m_bPinPulled then
                return;
            else
                if v278.menu.anti_aim.defensive_opt:get(v277) and v278.menu.anti_aim.lc_aa_on:get(v277) then
                    v164.hidden:override(v278.menu.anti_aim.lc_type:get("Double Tap") and v164.double_tap:get() or v278.menu.anti_aim.lc_type:get("Hide Shots") and v164.hide_shots:get());
                    v164.lag_options:override("Always On");
                    v164.hs_options:override("Break LC");
                elseif v278.menu.anti_aim.defensive_opt:get(v277) and not v278.menu.anti_aim.lc_aa_on:get(v277) then
                    v164.lag_options:override("Always On");
                    v164.hs_options:override("Break LC");
                    v164.hidden:override(false);
                elseif not v278.menu.anti_aim.defensive_opt:get(v277) and v278.menu.anti_aim.lc_aa_on:get("On Peek") then
                    v164.hidden:override(v278.menu.anti_aim.lc_type:get("Double Tap") and v164.double_tap:get() or v278.menu.anti_aim.lc_type:get("Hide Shots") and v164.hide_shots:get());
                    v164.lag_options:override("On Peek");
                    v164.hs_options:override("Favor Fire Rate");
                else
                    v164.hidden:override(false);
                    v164.lag_options:override("On Peek");
                    v164.hs_options:override("Favor Fire Rate");
                end;
                if v276.is_safe_head then
                    v164.hidden:override(false);
                end;
                if v278.menu.anti_aim.lc_disabler:get("Nades") and v279 and v279.m_bPinPulled then
                    v164.hs_options:override("Favor Fire Rate");
                    v164.lag_options:override("On Peek");
                    v164.hidden:override(false);
                end;
                return;
            end;
        end;
    end, 
    flick_fix = function(v281)
        -- upvalues: v164 (ref)
        v281.is_fired = v164.hide_shots:get();
    end, 
    fast_ladder = function(_, v283, v284)
        -- upvalues: l_get_local_player_0 (ref), l_pairs_0 (ref), l_camera_angles_0 (ref)
        if not v284.menu.miscellaneous.fast_ladder:get() then
            return;
        else
            local v285 = l_get_local_player_0();
            if not v285 then
                return;
            elseif v285.m_MoveType ~= 9 then
                return;
            else
                for _, v287 in l_pairs_0({
                    [1] = 43, 
                    [2] = 44, 
                    [3] = 45, 
                    [4] = 46, 
                    [5] = 47, 
                    [6] = 48
                }) do
                    if not v285:get_player_weapon() or v285:get_player_weapon():get_weapon_index() == v287 then
                        return;
                    end;
                end;
                local v288 = 113;
                if v283.in_forward and v283.in_moveleft then
                    v283.in_back = 1;
                    v283.in_forward = 0;
                    v283.in_moveleft = 0;
                    v283.in_moveright = 1;
                    v288 = 180;
                elseif v283.in_forward and v283.in_moveright then
                    v283.in_back = 1;
                    v283.in_forward = 0;
                    v283.in_moveleft = 1;
                    v283.in_moveright = 0;
                    v288 = 180;
                elseif v283.in_back and v283.in_moveright then
                    v283.in_back = 0;
                    v283.in_forward = 1;
                    v283.in_moveleft = 1;
                    v283.in_moveright = 0;
                    v288 = 180;
                elseif v283.in_back and v283.in_moveleft then
                    v283.in_back = 0;
                    v283.in_forward = 1;
                    v283.in_moveleft = 0;
                    v283.in_moveright = 1;
                    v288 = 180;
                elseif v283.in_moveleft then
                    v283.in_back = 0;
                    v283.in_forward = 0;
                    v283.in_moveleft = 0;
                    v283.in_moveright = 1;
                    v288 = 180;
                elseif v283.in_moveright then
                    v283.in_back = 0;
                    v283.in_forward = 0;
                    v283.in_moveleft = 1;
                    v283.in_moveright = 0;
                    v288 = 180;
                elseif v283.in_forward then
                    v283.in_back = 1;
                    v283.in_forward = 0;
                    v283.in_moveleft = 0;
                    v283.in_moveright = 1;
                elseif v283.in_back then
                    v283.in_back = 0;
                    v283.in_forward = 1;
                    v283.in_moveleft = 1;
                    v283.in_moveright = 0;
                    v288 = 96;
                end;
                local v289 = 90;
                local v290 = l_camera_angles_0().y + v288;
                v283.view_angles.x = v289;
                v283.view_angles.y = v290;
                return;
            end;
        end;
    end, 
    way_counter = {}, 
    calculate_ways = function(v291, v292)
        -- upvalues: l_type_0 (ref)
        if l_type_0(v292) == "string" then
            local v293 = tonumber(v292);
            if v293 then
                v292 = v293;
            end;
        end;
        if v291.way_counter[v292] == nil then
            v291.way_counter[v292] = 1;
        end;
        if globals.choked_commands == 0 then
            v291.way_counter[v292] = v291.way_counter[v292] + 1;
            if v292 < v291.way_counter[v292] then
                v291.way_counter[v292] = 1;
            end;
        end;
        return v291.way_counter[v292];
    end, 
    air_exploit = function(v294, v295)
        -- upvalues: l_get_local_player_0 (ref), v164 (ref)
        local v296 = v294:get_state((l_get_local_player_0()));
        v294.is_air_exploit = false;
        if v295.menu.anti_aim.air_exploit:get() and (v296 == "Air Crouch" or v296 == "Jumping") then
            v164.fl_limit:override(17);
            v164.fl_var:override(0);
            v164.lag_options:override("On Peek");
            if globals.tickcount % 2 == 1 then
                cvar.sv_maxusrcmdprocessticks:int(16);
                v294.c = v294.c + 1;
                v164.fake_duck:override(true);
            end;
            if v294.c > 2 then
                cvar.sv_maxusrcmdprocessticks:int(19);
                v294.c = 1;
                v164.fake_duck:override(false);
            end;
            v294.is_air_exploit = true;
        else
            v164.fl_limit:override();
            v164.fl_var:override();
            v164.fake_duck:override();
            cvar.sv_maxusrcmdprocessticks:int(16);
        end;
    end, 
    set_anti_aim = function(v297, v298, v299)
        -- upvalues: v164 (ref), l_find_1 (ref), l_random_int_0 (ref), l_random_0 (ref), l_clamp_0 (ref)
        v164.yaw_modifier:override(v298 and v298[4] or nil);
        if globals.choked_commands == 0 then
            local v300 = {
                Left = (v299.menu.anti_aim.static_manual:get() and 0 or v298 and v298[3] or 0) - 90, 
                Right = (v299.menu.anti_aim.static_manual:get() and 0 or v298 and v298[3] or 0) + 90, 
                Forward = (v299.menu.anti_aim.static_manual:get() and 0 or v298 and v298[3] or 0) + 180
            };
            local l_yaw_offset_0 = v164.yaw_offset;
            local l_l_yaw_offset_0_0 = l_yaw_offset_0;
            l_yaw_offset_0 = l_yaw_offset_0.override;
            local v303;
            if v297.is_legit_aa_active then
                v303 = 180;
            else
                if v297.is_disable_aa then
                    v303 = globals.tickcount * 10 % 360;
                    if v303 then
                        goto label0;
                    end;
                end;
                if v297.is_disable_aa then
                    v303 = 0;
                elseif v297.is_safe_head then
                    v303 = v297.safe_head_weap[1] and 0 or v297.safe_head_weap[2] and 23 or v297.safe_head_weap[3] and 27 or v297.safe_head_weap[4] and 0 or 15;
                else
                    v303 = v297.is_legit_aa_active and 180 or v300[v299.menu.anti_aim.manuals:get()] or v298 and v298[3] or nil;
                end;
            end;
            ::label0::;
            l_yaw_offset_0(l_l_yaw_offset_0_0, v303);
        end;
        local l_body_yaw_0 = v164.body_yaw;
        local l_l_body_yaw_0_0 = l_body_yaw_0;
        l_body_yaw_0 = l_body_yaw_0.override;
        if v297.is_disable_aa then

        end;
        l_body_yaw_0(l_l_body_yaw_0_0, v298 and v298[6] or nil);
        if not v297.is_legit_aa_active and v299.menu.anti_aim.manuals:get() ~= "Disabled" then
            v164.freestanding:override(false);
            if v299.menu.anti_aim.static_manual:get() and (not v164.freestanding:get_override() or not v164.freestanding:get()) then
                v164.by_options:override({});
                v164.yaw_modifier:override("Disabled");
            else
                v164.by_options:override(v164.freestanding:get() and v299.menu.anti_aim.static_manual:get() and {} or v298 and v298[7] or nil);
            end;
            v164.yaw_base:override("Local View");
        else
            v164.freestanding:override();
            v164.yaw_base:override();
            v164.by_options:override(v297.is_safe_head and {} or v298 and v298[7] or nil);
        end;
        v164.pitch:override(v297.is_legit_aa_active and "Disabled" or v297.is_disable_aa and "Disabled" or v298 and v298[1] or nil);
        v164.yaw:override(v298 and v298[2] or nil);
        l_body_yaw_0 = (not not v297.is_edge_yaw or v297.is_disable_aa or v297.is_safe_head) and 0 or v298 and v298[5] or nil;
        v164.modifier_offset:override(l_body_yaw_0);
        v164.by_freestanding:override(v297.is_safe_head and "Off" or v298 and v298[8] or nil);
        l_l_body_yaw_0_0 = v164.left_limit;
        local l_l_l_body_yaw_0_0_0 = l_l_body_yaw_0_0;
        l_l_body_yaw_0_0 = l_l_body_yaw_0_0.override;
        local v307;
        if v297.is_fired then
            v307 = 3;
        elseif v297.is_safe_head then
            v307 = v297.safe_head_weap[1] and 60 or v297.safe_head_weap[2] and 60 or v297.safe_head_weap[3] and 45 or 24;
        else
            v307 = v298 and v298[9] or nil;
        end;
        l_l_body_yaw_0_0(l_l_l_body_yaw_0_0_0, v307);
        l_l_body_yaw_0_0 = v164.right_limit;
        l_l_l_body_yaw_0_0_0 = l_l_body_yaw_0_0;
        l_l_body_yaw_0_0 = l_l_body_yaw_0_0.override;
        if v297.is_fired then
            v307 = 3;
        elseif v297.is_safe_head then
            v307 = v297.safe_head_weap[1] and 60 or v297.safe_head_weap[2] and 30 or v297.safe_head_weap[3] and 45 or 24;
        else
            v307 = v298 and v298[10] or nil;
        end;
        l_l_body_yaw_0_0(l_l_l_body_yaw_0_0_0, v307);
        v164.avoid_backstab:override(v299.menu.anti_aim.tweaks:get("Anti Backstab"));
        if globals.choked_commands == 0 then
            v297.jitter_switch = not v297.jitter_switch;
        end;
        l_l_body_yaw_0_0 = not l_find_1(v298 and v298[7] or {}, "Jitter") and (v298 and v298[8] or "Off") == "Off" and globals.tickcount % 5 >= l_random_int_0(14, 26) * 0.1 or rage.antiaim:inverter();
        if (v164.double_tap:get() or v164.hide_shots:get()) and not v297.is_safe_head and v299.menu.anti_aim.force_lc:get() then
            l_l_l_body_yaw_0_0_0 = nil;
            if v299.menu.anti_aim.lc_pitch:get() == "Custom" then
                l_l_l_body_yaw_0_0_0 = v299.menu.anti_aim.lc_value:get();
            elseif v299.menu.anti_aim.lc_pitch:get() == "Down" then
                l_l_l_body_yaw_0_0_0 = 89;
            elseif v299.menu.anti_aim.lc_pitch:get() == "Zero" then
                l_l_l_body_yaw_0_0_0 = 0;
            elseif v299.menu.anti_aim.lc_pitch:get() == "Up" then
                l_l_l_body_yaw_0_0_0 = -89;
            elseif v299.menu.anti_aim.lc_pitch:get() == "3-Way" then
                l_l_l_body_yaw_0_0_0 = ({
                    [1] = -45, 
                    [2] = 0, 
                    [3] = 45
                })[v297:calculate_ways(3)];
            elseif v299.menu.anti_aim.lc_pitch:get() == "SideWays" and globals.choked_commands ~= 0 then
                l_l_l_body_yaw_0_0_0 = l_l_body_yaw_0_0 and v299.menu.anti_aim.lc_valuer:get() or v299.menu.anti_aim.lc_valuel:get();
            elseif v299.menu.anti_aim.lc_pitch:get():find("Switch") then
                l_l_l_body_yaw_0_0_0 = v299.menu.anti_aim.lc_pitch:get():find("Up") and -45 or 45;
            end;
            v307 = nil;
            if v299.menu.anti_aim.lc_yaw_type:get() == "Random" then
                v307 = globals.tickcount % 3 >= 2 and l_random_0(-180, -90) or l_random_0(90, 180);
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "SideWays" and globals.choked_commands ~= 0 then
                v307 = v297.jitter_switch and 90 or -90;
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "Spin" then
                v307 = globals.tickcount * 25 % 360;
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "3-Way" then
                v307 = ({
                    nil, 
                    -180, 
                    [1] = -v299.menu.anti_aim.lc_yaw:get(), 
                    v299.menu.anti_aim.lc_yaw:get()
                })[v297:calculate_ways(3)];
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "Center" then
                local v308 = l_l_body_yaw_0_0 and 1 or -1;
                v307 = v299.menu.anti_aim.lc_yaw:get() * v308;
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "Offset" then
                local v309 = l_l_body_yaw_0_0 and 1 or -1;
                v307 = v299.menu.anti_aim.lc_yaw:get() * (v309 + 1);
            elseif v299.menu.anti_aim.lc_yaw_type:get() == "Forward" then
                v307 = 180;
            end;
            if v164.freestanding:get() or v164.freestanding:get_override() or v299.menu.anti_aim.manuals:get() ~= "Disabled" then
                v307 = 180;
                l_l_l_body_yaw_0_0_0 = 0;
            end;
            if l_l_l_body_yaw_0_0_0 then
                rage.antiaim:override_hidden_pitch(l_clamp_0(l_l_l_body_yaw_0_0_0 + l_random_0(-v299.menu.anti_aim.lc_randomize:get(), v299.menu.anti_aim.lc_randomize:get()), -89, 89));
            end;
            if v307 then
                local v310 = 0;
                local v311 = l_l_body_yaw_0_0 and 1 or -1;
                local v312 = v298 and v298[4] or "";
                if v312 == "Center" then
                    v310 = l_body_yaw_0 * 0.5 * v311;
                elseif v312 == "Offset" then
                    v310 = l_body_yaw_0 * (v311 + 1) * 0.5;
                end;
                if not l_find_1(v298 and v298[7] or {}, "Jitter") or not v310 then
                    v311 = 0;
                else
                    v311 = v310;
                end;
                v311 = v307 + v311 + (v298 and v298[3] or 0) + l_random_0(-v299.menu.anti_aim.lc_yaw_randomize:get(), v299.menu.anti_aim.lc_yaw_randomize:get());
                rage.antiaim:override_hidden_yaw_offset(v311);
            end;
        end;
        if v297.is_fired then
            v297.is_fired = false;
        end;
    end, 
    get_inverter_side = function(v313)
        -- upvalues: l_get_local_player_0 (ref)
        local v314 = l_get_local_player_0();
        if v314 == nil or globals.choked_commands ~= 0 then
            return;
        else
            v313.inverter = v314.m_flPoseParameter[11] * 120 - 60 < 0;
            return;
        end;
    end, 
    calculate_yaw = function(v315, v316)
        -- upvalues: l_ceil_0 (ref), v164 (ref), l_random_0 (ref)
        local v317 = 0;
        if v316.yaw:get():find("Way") then
            if v316.custom_ways:get() then
                v317 = ({
                    v316.way1:get(), 
                    v316.way2:get(), 
                    v316.way3:get(), 
                    v316.way4:get(), 
                    v316.way5:get()
                })[v315:calculate_ways(v316.yaw:get():gsub("-Way", ""))];
            else
                v317 = ({
                    [1] = nil, 
                    [2] = 0, 
                    [1] = -v316.yaw_add:get() * 0.5, 
                    [3] = v316.yaw_add:get() * 0.5, 
                    [4] = v316.yaw_add:get() * 0.25, 
                    [5] = -v316.yaw_add:get() * 0.25
                })[v315:calculate_ways(v316.yaw:get():gsub("-Way", ""))];
            end;
        else
            if v316.delay_ticks:get() ~= 0 then
                local v318 = l_ceil_0(0.16 * v316.delay_ticks:get());
                if (v164.double_tap:get() and rage.exploit:get() == 1 or v164.hide_shots:get()) and l_ceil_0(0.16 * v318) > 0 then
                    local v319 = l_random_0(0, 1) == 1;
                    if v318 < v315.current_tick and globals.choked_commands == 0 then
                        v315.delay_inverter = v316.body_yaw_options:get("Randomize Jitter") and v319 or not v315.delay_inverter;
                        v315.current_tick = 0;
                    end;
                    v315.inverter = not v315.delay_inverter;
                    if globals.choked_commands == 0 then
                        v315.current_tick = v315.current_tick + 1;
                    end;
                    rage.antiaim:inverter(v315.delay_inverter or false);
                end;
            end;
            if v316.yaw_mode:get() == "L & R" then
                v317 = not v315.inverter and v316.yaw_addl:get() or v316.yaw_addr:get();
            else
                v317 = v316.yaw_add:get();
            end;
        end;
        return v315.is_legit_aa_active and 180 or v317;
    end, 
    createmove = function(v320, v321, v322, v323)
        -- upvalues: l_get_local_player_0 (ref), l_random_0 (ref), v164 (ref)
        if v320.mamu_ebal then
            return;
        else
            local v324 = l_get_local_player_0();
            if v324 == nil or not v324:is_alive() then
                return;
            else
                local v325 = v320:get_state(v324);
                local v326 = {
                    values = {}
                };
                local v327 = v322.menu.anti_aim.builder[v320.convert_state[v325]];
                if v322.menu.anti_aim.builder[v320.convert_state[v325]].enable:get() then
                    v326.values = {
                        [1] = "Down", 
                        [2] = v327.yaw:get(), 
                        [3] = v320:calculate_yaw(v327), 
                        [4] = v327.yaw_modifier:get(), 
                        [5] = v327.modifier_offset:get() + l_random_0(-v327.modifier_randomize:get(), v327.modifier_randomize:get()), 
                        [6] = v327.body_yaw:get(), 
                        [7] = v327.body_yaw_options:get(), 
                        [8] = v327.body_yaw_freestanding:get(), 
                        [9] = v327.body_yaw_options:get("Jitter") and v327.fake_limitl:get() or v327.fake_limit:get(), 
                        [10] = v327.body_yaw_options:get("Jitter") and v327.fake_limitr:get() or v327.fake_limit:get()
                    };
                    v326.yaw_base = v327.yaw_base:get();
                else
                    v326.values = v323[v322.menu.anti_aim.preset:get()] and v323[v322.menu.anti_aim.preset:get()][v320.convert_state[v325]] or v323[v322.menu.anti_aim.preset:get()];
                end;
                v320:set_anti_aim(v326.values, v322);
                v164.yaw_base:override((not (not v320.is_legit_aa_active and v322.menu.anti_aim.manuals:get() == "Disabled") or v320.is_edge_yaw) and "Local View" or v326.yaw_base);
                v320:anti_aim_on_use(v321, v322);
                v320:edge_yaw(v321, v322);
                v320:defensive_anti_aim(v325, v322);
                v320:safe_head(v325, v322);
                v320:fast_ladder(v321, v322);
                v320:avoid_collisions(v321, v322);
                v320:super_toss(v321, v322);
                v320:grenade_release(v321, v322);
                v320:air_exploit(v322);
                return v325;
            end;
        end;
    end
}):struct("visuals")({
    is_tab = false, 
    defensive_state = false, 
    old_tick_base = 0, 
    planting_site = "", 
    remove_tag = false, 
    current_tag = "", 
    planting = false, 
    unset_callback = false, 
    on_plant_time = 0, 
    set_callback = false, 
    data = {}, 
    lerp = function(v328, v329, v330, v331)
        -- upvalues: l_clamp_0 (ref), l_type_0 (ref), l_ipairs_0 (ref), l_color_0 (ref), l_floor_0 (ref), l_ceil_0 (ref)
        v331 = l_clamp_0(v331, 0, 1);
        if l_type_0(v329) == "userdata" then
            local v332 = {
                [1] = 0, 
                [2] = 0, 
                [3] = 0, 
                [4] = 0
            };
            for v333, v334 in l_ipairs_0({
                [1] = "r", 
                [2] = "g", 
                [3] = "b", 
                [4] = "a"
            }) do
                v332[v333] = v328:lerp(v329[v334], v330[v334], v331);
            end;
            return l_color_0(unpack(v332));
        else
            local v335 = (v330 - v329) * v331 + v329;
            if v330 == 0 and v335 < 0.01 and v335 > -0.01 then
                v335 = 0;
            elseif v330 == 1 and v335 < 1.01 and v335 > 0.995 then
                v335 = 1;
            end;
            if v335 % 1 < 1.0E-4 then
                v335 = l_floor_0(v335);
            elseif v335 % 1 > 0.9999 then
                v335 = l_ceil_0(v335);
            end;
            return v335;
        end;
    end, 
    animate = function(v336, v337, v338, v339)
        -- upvalues: l_type_0 (ref)
        if v336.data[v337] == nil then
            v336.data[v337] = l_type_0(v338) == "number" and 0 or v338;
        end;
        v336.data[v337] = v336:lerp(v336.data[v337], v338, v339);
        return v336.data[v337];
    end, 
    sidebar = function(_)
        -- upvalues: l_sidebar_0 (ref), l_color_0 (ref), l_get_style_0 (ref), v183 (ref)
        l_sidebar_0(l_color_0(0):mix(l_get_style_0("Link Active"), 0.7):gradient(l_get_style_0("Link Active"), -1, ("celestia          "):format(v183:lower())), "cat");
    end, 
    viewmodel_data = {
        cvar.viewmodel_fov:float() / 0.1, 
        cvar.viewmodel_offset_x:float() / 0.1, 
        cvar.viewmodel_offset_y:float() / 0.1, 
        cvar.viewmodel_offset_z:float() / 0.1, 
        cvar.cl_righthand:int()
    }, 
    set_viewmodel = function(_, v342)
        cvar.viewmodel_fov:float(v342[1] * 0.1, true);
        cvar.viewmodel_offset_x:float(v342[2] * 0.1, true);
        cvar.viewmodel_offset_y:float(v342[3] * 0.1, true);
        cvar.viewmodel_offset_z:float(v342[4] * 0.1, true);
    end, 
    opposite_knife_hand = function(v343, v344)
        -- upvalues: l_get_local_player_0 (ref)
        local l_cl_righthand_0 = cvar.cl_righthand;
        local v346 = v343.viewmodel_data[5];
        if not v344.menu.visuals.opposite_knife:get() or not v344.menu.visuals.viewmodel:get() then
            l_cl_righthand_0:int(v346);
            return;
        else
            local v347 = nil;
            local v348 = l_get_local_player_0();
            v347 = v348 and v348:get_player_weapon() or nil;
            if v347 then
                local v349 = v347:get_classname():lower();
                if v349 then
                    v347 = v349;
                    goto label1 --[[  true, true  ]];
                end;
            end;
            v347 = "";
            ::label1::;
            if v347.find(v347, "knife") then
                l_cl_righthand_0:int(v346 == 1 and 0 or 1);
            else
                l_cl_righthand_0:int(v346);
            end;
            return;
        end;
    end, 
    dpi_scale = {
        font = 1, 
        scale = 1, 
        verdana = l_load_font_0("verdana", 12, "ad"), 
        update = function(v350, v351)
            local v352 = v351.menu.visuals.dpi_scale:get();
            v350.scale = v352 == 1 and 1 or v352 == 2 and 1.25 or v352 == 3 and 1.5 or v352 == 4 and 1.75 or v352 == 5 and 2;
            v350.font = v350.scale == 1 and 1 or v350.verdana;
            if v350.scale ~= 1 then
                v350.verdana:set_size(12 * v350.scale);
            end;
        end
    }, 
    screen_size = l_screen_size_0(), 
    render_window = function(v353, v354, v355, v356, v357, v358, v359)
        -- upvalues: l_shadow_0 (ref), l_rect_0 (ref), l_color_0 (ref), l_vector_0 (ref), l_push_clip_rect_0 (ref), l_text_0 (ref), l_pop_clip_rect_0 (ref)
        local v360 = v353:animate(("window_shadow_%s"):format(v354 and v354:gsub("\a(%x%x%x%x%x%x%x%x)", ""):sub(0, 14) or "s"), v359.menu.visuals.windows_additions:get() and 1 or 0, globals.frametime * 12);
        if v360 > 0.01 then
            l_shadow_0(v355, v355 + v356, v357:modulate_alpha(v358 * v360), 16, nil, 4.5);
        end;
        l_rect_0(v355, v355 + v356, l_color_0(17, v358 * v359.menu.visuals.background_alpha:get() * 0.01), 4.5 * v353.dpi_scale.scale);
        l_shadow_0(v355 - l_vector_0(1 * v353.dpi_scale.scale, -5), v355 + l_vector_0(1 * v353.dpi_scale.scale, v356.y - 6), v357:modulate_alpha(v358), 16);
        l_rect_0(v355 - l_vector_0(1 * v353.dpi_scale.scale, -5), v355 + l_vector_0(1 * v353.dpi_scale.scale, v356.y - 6), v357:modulate_alpha(v358), 3 * v353.dpi_scale.scale);
        l_shadow_0(v355 + v356 - l_vector_0(1 * v353.dpi_scale.scale, v356.y - 5), v355 + v356 + l_vector_0(1 * v353.dpi_scale.scale, -6), v357:modulate_alpha(v358), 16);
        l_rect_0(v355 + v356 - l_vector_0(1 * v353.dpi_scale.scale, v356.y - 5), v355 + v356 + l_vector_0(1 * v353.dpi_scale.scale, -6), v357:modulate_alpha(v358), 3 * v353.dpi_scale.scale);
        if v354 then
            l_push_clip_rect_0(v355, v355 + v356);
            l_text_0(v353.dpi_scale.font, v355 + v356 * 0.5 + l_vector_0(1, 0), l_color_0():modulate_alpha(v358), "c", v354);
            l_pop_clip_rect_0();
        end;
    end, 
    fps_data = {
        framerate = 0, 
        current_fps = 0
    }, 
    get_fps = function(v361)
        v361.fps_data.framerate = 0.9 * v361.fps_data.framerate + 0.09999999999999998 * globals.absoluteframetime;
        if v361.fps_data.framerate <= 0 then
            v361.fps_data.framerate = 1;
        end;
        if globals.tickcount % 64 == 0 or v361.fps_data.framerate == 0 then
            v361.fps_data.current_fps = tonumber(("%i"):format(1 / v361.fps_data.framerate));
        end;
        return v361.fps_data.current_fps;
    end, 
    player_data = {}, 
    execute_player_data = function(v362)
        -- upvalues: v125 (ref), l_parse_0 (ref), l_floor_0 (ref), l_ceil_0 (ref), l_load_image_0 (ref), l_vector_0 (ref)
        v125.get("http://ip-api.com/json/?fields=61439", function(v363, v364)
            -- upvalues: l_parse_0 (ref), v362 (ref), v125 (ref), l_floor_0 (ref), l_ceil_0 (ref), l_load_image_0 (ref), l_vector_0 (ref)
            if v363 and v364.status == 200 then
                local v365 = l_parse_0(v364.body);
                v362.player_data.country_code = v365.countryCode;
                v125.get(("https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s"):format(v365.lat, v365.lon, "b2f18742162c946243515e69c575b119"), function(v366, v367)
                    -- upvalues: l_parse_0 (ref), l_floor_0 (ref), l_ceil_0 (ref), v362 (ref), v125 (ref), l_load_image_0 (ref), l_vector_0 (ref)
                    if v366 and v367.status == 200 then
                        local v368 = l_parse_0(v367.body);
                        local v369 = v368.main.temp - 273.15;
                        v369 = v369 >= 0 and l_floor_0(v369 + 0.5) or l_ceil_0(v369 - 0.5);
                        v362.player_data.temperature = (v369 > 0 and "+" .. v369 or v369) .. "\194\176C";
                        v125.get(("http://openweathermap.org/img/wn/%s@2x.png"):format(v368.weather[1].icon), function(v370, v371)
                            -- upvalues: v362 (ref), l_load_image_0 (ref), l_vector_0 (ref)
                            if v370 and v371.status == 200 then
                                v362.player_data.weather_icon = l_load_image_0(v371.body, l_vector_0(32, 32));
                            end;
                        end);
                    end;
                end);
            end;
        end);
    end, 
    dragging_data = {
        index = 0, 
        is_dragging = false, 
        drag_fix = {}, 
        all_elements = {}
    }, 
    dragging_fn = function(v372)
        -- upvalues: l_screen_size_0 (ref), l_vector_0 (ref), l_insert_0 (ref), l_get_mouse_position_0 (ref), l_rect_0 (ref), l_color_0 (ref), l_text_0 (ref), l_get_alpha_0 (ref), l_is_button_down_0 (ref), l_pairs_0 (ref), l_floor_0 (ref), l_render_0 (ref), l_remove_0 (ref), l_createmove_0 (ref)
        local l_v372_0 = v372;
        local v374 = {};
        local v375 = l_screen_size_0();
        v374.list = {};
        v374.windows = {};
        v374.__index = v374;
        v374.register = function(v376, v377, v378, v379, v380)
            -- upvalues: l_v372_0 (ref), l_vector_0 (ref), l_insert_0 (ref), v374 (ref)
            l_v372_0.dragging_data.index = l_v372_0.dragging_data.index + 1;
            local v381 = {
                cock = true, 
                is_default = false, 
                is_dragging = false, 
                size = l_vector_0(v378, v379), 
                position = l_vector_0(v376:get() - v378, v377:get()), 
                drag_position = l_vector_0(), 
                index = l_v372_0.dragging_data.index, 
                global_name = v376:name(), 
                ins_function = v380, 
                ui_callbacks = {
                    x = v376, 
                    y = v377
                }
            };
            l_insert_0(v374.windows, v381);
            v374.mt_data = setmetatable(v381, v374);
            l_insert_0(l_v372_0.dragging_data.all_elements, v374.mt_data);
            return v374.mt_data;
        end;
        v374.limit_positions = function(v382)
            -- upvalues: v375 (ref)
            if v382.position.x <= 0 then
                v382.position.x = 0;
            end;
            if v382.position.x + v382.size.x >= v375.x - 1 then
                v382.position.x = v375.x - v382.size.x - 1;
            end;
            if v382.position.y <= 0 then
                v382.position.y = 0;
            end;
            if v382.position.y + v382.size.y >= v375.y - 1 then
                v382.position.y = v375.y - v382.size.y - 1;
            end;
        end;
        v374.is_in_area = function(v383, v384)
            return v384.x >= v383.position.x and v384.x <= v383.position.x + v383.size.x and v384.y >= v383.position.y and v384.y <= v383.position.y + v383.size.y;
        end;
        v374.stapled = function(v385, v386, v387, v388, v389, v390, v391)
            -- upvalues: l_v372_0 (ref), l_get_mouse_position_0 (ref), l_vector_0 (ref), l_rect_0 (ref), l_color_0 (ref), l_text_0 (ref)
            if v390:find("watermark") == nil then
                return "";
            else
                local v392 = "None";
                local v393 = l_v372_0:animate(("%s Stapled Alpha"):format(v390), v385.is_dragging and 1 or 0, globals.frametime * 12);
                if v393 < 0.1 then
                    return "";
                else
                    local v394 = {
                        [1] = {
                            [1] = 6, 
                            [2] = 8, 
                            [3] = nil, 
                            [4] = nil, 
                            [5] = "T-L", 
                            [3] = v388 + 1, 
                            [4] = v389
                        }, 
                        [2] = {
                            [1] = nil, 
                            [2] = 8, 
                            [3] = nil, 
                            [4] = nil, 
                            [5] = "T-R", 
                            [1] = l_v372_0.screen_size.x - v388 - 14, 
                            [3] = v388 + 1, 
                            [4] = v389
                        }, 
                        [3] = {
                            [1] = nil, 
                            [2] = nil, 
                            [3] = nil, 
                            [4] = nil, 
                            [5] = "B-C", 
                            [1] = l_v372_0.screen_size.x * 0.5 - v388 * 0.5 - 1, 
                            [2] = l_v372_0.screen_size.y - v389 - 7, 
                            [3] = v388 + 2, 
                            [4] = v389
                        }
                    };
                    for v395 = 1, #v394 do
                        local v396 = v394[v395];
                        local v397, v398, v399, v400, v401 = unpack(v396);
                        local v402 = l_v372_0:animate(("%s %s"):format(v390, v401), l_get_mouse_position_0():dist(l_vector_0(v397 + v399 * 0.5, v398 + v400 * 0.5)) < l_v372_0.screen_size.x * 0.33 and 1 or 0, globals.frametime * 12);
                        l_rect_0(l_vector_0(v397, v398), l_vector_0(v397 + v399, v398 + v400), l_color_0(18, 126 * v393 * v402), 4.5);
                        l_text_0(l_v372_0.dpi_scale.font, l_vector_0(v397 + v399 * 0.5, v398 + v400 * 0.5), l_color_0(255, 200 * v393 * v402), "c", "DRAG THE WIDGET HERE TO ATTACH");
                        local v403 = false;
                        if v397 <= v386 and v386 <= v397 + v399 and v398 <= v387 and v387 <= v398 + v400 or v397 <= v386 + v388 and v386 + v388 <= v397 + v399 and v398 <= v387 + v389 and v387 + v389 <= v398 + v400 or v397 <= v386 + v388 and v386 + v388 <= v397 + v399 and v398 <= v387 and v387 <= v398 + v400 or v397 <= v386 and v386 <= v397 + v399 and v398 <= v387 + v389 and v387 + v389 <= v398 + v400 then
                            v403 = true;
                        end;
                        if v402 > 0.1 and v403 then
                            v392 = v401;
                        end;
                    end;
                    v391.menu.visuals.stapled_watermark:set(v392);
                    return v392;
                end;
            end;
        end;
        v374.update = function(v404, v405, v406, ...)
            -- upvalues: l_get_alpha_0 (ref), l_screen_size_0 (ref), l_get_mouse_position_0 (ref), v374 (ref), l_is_button_down_0 (ref), l_pairs_0 (ref), l_v372_0 (ref), l_floor_0 (ref), l_vector_0 (ref)
            local v407 = l_get_alpha_0() == 1;
            v404.position_magnitize = v404:stapled(v404.position.x, v404.position.y, v404.size.x, v404.size.y, v404.global_name:lower(), v406);
            local l_x_0 = l_screen_size_0().x;
            local l_y_3 = l_screen_size_0().y;
            local v410 = l_get_mouse_position_0();
            local v411 = v404:is_in_area(v410);
            local l_list_0 = v374.list;
            local v413 = l_is_button_down_0(1);
            l_list_0.in_drag_area = v411;
            for v414, v415 in l_pairs_0(l_v372_0.dragging_data.drag_fix) do
                if v414 ~= l_list_0.target and v415 then
                    v411 = false;
                end;
            end;
            if (v411 or v404.is_dragging) and v413 and (l_list_0.target == "" or l_list_0.target == v404.global_name) and v407 then
                l_v372_0.dragging_data.is_dragging = true;
                l_list_0.target = v404.global_name;
                if not v404.is_dragging then
                    v404.is_dragging = true;
                    v404.drag_position = v410 - v404.position;
                else
                    v404.position = v410 - v404.drag_position;
                    v404:limit_positions();
                    v404.ui_callbacks.x:set(l_floor_0(v404.position.x));
                    v404.ui_callbacks.y:set(l_floor_0(v404.position.y));
                end;
            elseif not v413 then
                for _, v417 in l_pairs_0(v374.windows) do
                    v417.position = l_vector_0(v417.ui_callbacks.x:get(), v417.ui_callbacks.y:get());
                end;
                l_v372_0.dragging_data.is_dragging = false;
                l_list_0.target = "";
                v404.is_dragging = false;
                v404.drag_position = l_vector_0();
                if v405 and (v406.menu.visuals.stapled_watermark:get() == "B-C" or v404.position_magnitize == "B-C") then
                    v404.position = l_vector_0(l_x_0 / 2 - v404.size.x / 2, l_y_3 - v404.size.y - 7);
                elseif v405 and (v406.menu.visuals.stapled_watermark:get() == "T-R" or v404.position_magnitize == "T-R") then
                    v404.position = l_vector_0(l_x_0 - v404.size.x - 13, 8);
                elseif v405 and (v406.menu.visuals.stapled_watermark:get() == "T-L" or v404.position_magnitize == "T-L") then
                    v404.position = l_vector_0(7, 8);
                end;
                v404:limit_positions();
                v404.ui_callbacks.x:set(l_floor_0(v404.position.x));
                v404.ui_callbacks.y:set(l_floor_0(v404.position.y));
            end;
            l_v372_0.dragging_data.drag_fix[v404.global_name] = v404.is_dragging;
            v404:ins_function(...);
        end;
        v374.execute = function(v418, v419)
            -- upvalues: l_render_0 (ref), l_v372_0 (ref), l_remove_0 (ref), l_insert_0 (ref), l_createmove_0 (ref), l_get_mouse_position_0 (ref)
            l_render_0(function()
                -- upvalues: l_v372_0 (ref), l_remove_0 (ref), l_insert_0 (ref), v419 (ref)
                for v420 = 1, #l_v372_0.dragging_data.all_elements do
                    local l_all_elements_0 = l_v372_0.dragging_data.all_elements;
                    if not l_all_elements_0[v420] then
                        l_all_elements_0[v420] = {};
                    end;
                    if not l_all_elements_0[v420].update then
                        return;
                    else
                        if l_all_elements_0[v420].is_dragging and l_all_elements_0[v420].cock then
                            l_all_elements_0[v420].cock = false;
                            local v422 = l_all_elements_0[v420];
                            l_remove_0(l_all_elements_0, v420);
                            l_insert_0(l_all_elements_0, 1, v422);
                        else
                            l_all_elements_0[v420].cock = not l_all_elements_0[v420].is_dragging;
                        end;
                        l_all_elements_0[v420]:update(l_all_elements_0[v420].global_name:find("watermark"), v419);
                    end;
                end;
            end);
            l_createmove_0(function(v423)
                -- upvalues: l_v372_0 (ref), l_get_mouse_position_0 (ref), v418 (ref)
                for v424 = 1, #l_v372_0.dragging_data.all_elements do
                    local l_all_elements_1 = l_v372_0.dragging_data.all_elements;
                    local v426 = l_get_mouse_position_0();
                    if l_all_elements_1[v424]:is_in_area(v426) or v418.is_dragging then
                        v423.in_attack = false;
                    end;
                end;
            end);
        end;
        return v374;
    end, 
    is_in_area = {
        gamesense = false, 
        slowdown = false, 
        spectators = false, 
        watermark = false, 
        side = "T-R", 
        keybinds = false
    }, 
    watermark = function(v427, v428, v429)
        -- upvalues: l_get_system_time_0 (ref), l_floor_0 (ref), l_color_0 (ref), l_min_0 (ref), l_net_channel_0 (ref), l_measure_text_0 (ref), l_get_mouse_position_0 (ref), l_get_alpha_0 (ref), l_vector_0 (ref), l_text_0 (ref), l_get_entities_0 (ref), l_get_local_player_0 (ref), l_exp_0 (ref), l_max_0 (ref), l_push_clip_rect_0 (ref), l_circle_outline_0 (ref), l_texture_0 (ref), l_pop_clip_rect_0 (ref)
        local v430 = globals.frametime * 16;
        local v431 = v429.menu.visuals.windows_color:get("Fade")[1];
        local v432 = v429.menu.visuals.windows_color:get("Solid")[1];
        local l_v427_0 = v427;
        local l_animate_0 = v427.animate;
        local v435 = "watermark_alpha";
        local v436;
        if v429.menu.visuals.windows_display:get("Watermark") and v429.menu.visuals.windows:get() and not v428.is_dragging then
            v436 = 1;
        else
            v436 = v428.is_dragging and 0.7 or 0;
        end;
        l_animate_0 = l_animate_0(l_v427_0, v435, v436, v430);
        if l_animate_0 > 0.01 then
            l_v427_0 = {
                x = v428.position.x, 
                y = v428.position.y, 
                w = v428.size.x, 
                h = v428.size.y
            };
            v435 = l_get_system_time_0();
            v436 = ("%02d:%02d"):format(v435.hours, v435.minutes);
            local v437 = (v429.menu.visuals.windows_color:get() == "Fade" and v431 or v432):modulate_alpha(255);
            local v438 = v427:get_fps();
            if l_floor_0(v438) <= 70 then
                local v439 = "\a" .. l_color_0(255, 117, 117):lerp(l_color_0(255, 25, 25), l_min_0(1, 1 - (v438 - 60) / 10)):to_hex() .. v438;
                if v439 then
                    v438 = v439;
                end;
            end;
            local v440 = l_net_channel_0();
            local v441 = v440 and math.max(0, math.floor((v440.avg_latency[1] + -0.0078125) * 1000)) or 0;
            if v441 == 0 and (not v440 or not v440.is_loopback) then
                v441 = "";
            else
                v441 = v440 and v440.is_loopback and "local \226\151\143 " or v441 .. "ms \226\151\143 ";
            end;
            local v442 = ("%s \aDEFAULT\226\151\143 %s \226\151\143 %s%sfps\aDEFAULT \226\151\143 %s"):format(v429.menu.visuals.windows_color:get() == "Fade" and v431:gradient(v429.menu.visuals.windows_color:get("Fade")[2], -3, "celestia") or ("cele\a%sstia"):format(v437:to_hex()), v429.menu.username, v441, v438, v436);
            local v443 = l_measure_text_0(v427.dpi_scale.font, "c", v442);
            v428.size.x = v427:animate("drag.size.x", v443.x + 9, v430 * 0.5);
            local v444 = v429.menu.visuals.stapled_watermark:get();
            if v444 == "T-R" then
                v429.menu.visuals.watermark_x:set(v427.screen_size.x - v428.size.x - 13);
                v429.menu.visuals.watermark_y:set(8);
            elseif v444 == "T-L" then
                v429.menu.visuals.watermark_x:set(7);
                v429.menu.visuals.watermark_y:set(8);
            elseif v444 == "B-C" then
                v429.menu.visuals.watermark_x:set(v427.screen_size.x * 0.5 - v428.size.x * 0.5);
                v429.menu.visuals.watermark_y:set(v427.screen_size.y - v428.size.y - 7);
            end;
            local v445 = v427:animate("watermark_is_in_area", (not (v428:is_in_area((l_get_mouse_position_0())) and l_get_alpha_0() == 1) or v428.is_dragging) and 0 or 1, v430);
            v427.is_in_area.watermark = v445 > 0.01;
            if v445 > 0.01 then
                local v446 = l_vector_0(l_v427_0.x + l_v427_0.w, l_v427_0.y + l_v427_0.h);
                local v447 = "r";
                if v427.is_in_area.side == "B-R" then
                    local v448 = l_vector_0(l_v427_0.x + l_v427_0.w, l_v427_0.y - v443.y);
                    v447 = "r";
                    v446 = v448;
                elseif v427.is_in_area.side == "B-C" then
                    local v449 = l_vector_0(l_v427_0.x + l_v427_0.w * 0.5, l_v427_0.y - v443.y + 4 * v427.dpi_scale.scale);
                    v447 = "c";
                    v446 = v449;
                elseif v427.is_in_area.side == "T-C" then
                    local v450 = l_vector_0(l_v427_0.x + l_v427_0.w * 0.5, l_v427_0.y + l_v427_0.h + 6 * v427.dpi_scale.scale);
                    v447 = "c";
                    v446 = v450;
                elseif v427.is_in_area.side == "T-L" then
                    local v451 = l_vector_0(l_v427_0.x, l_v427_0.y + l_v427_0.h);
                    v447 = nil;
                    v446 = v451;
                elseif v427.is_in_area.side == "B-L" then
                    local v452 = l_vector_0(l_v427_0.x, l_v427_0.y - v443.y);
                    v447 = nil;
                    v446 = v452;
                end;
                l_text_0(v427.dpi_scale.font, v446, l_color_0(255, 220 * v445 * l_animate_0), v447, "Use mouse wheel to resize.");
            end;
            v427:render_window(v442, l_vector_0(l_v427_0.x, l_v427_0.y), l_vector_0(l_v427_0.w, l_v427_0.h), v437, v437.a * l_animate_0, v429);
            local v453 = v427:animate("windows_more_alpha", v429.menu.visuals.windows_more:get() and 1 or 0, v430) * l_animate_0;
            if v453 > 0.01 then
                local v454 = v427.player_data.temperature ~= nil and v427.player_data.weather_icon ~= nil and v427.player_data.country_code ~= nil;
                local v455 = "";
                l_get_entities_0("CPlantedC4", false, function(v456)
                    -- upvalues: l_get_local_player_0 (ref), v455 (ref), l_exp_0 (ref), l_max_0 (ref), v454 (ref)
                    if not v456 or v456.m_bBombDefused then
                        return;
                    else
                        local v457 = v456.m_flC4Blow - globals.curtime;
                        if v457 >= 0 then
                            local v458 = v456.m_hBombDefuser ~= nil and (v456.m_flDefuseCountDown - globals.curtime) / 1 or -1;
                            local v459 = l_get_local_player_0();
                            if not v459 then
                                return;
                            else
                                local v460 = v456.m_nBombSite == 0 and "A" or "B";
                                local v461 = v459:is_alive() and l_get_local_player_0() or v459.m_hObserverTarget;
                                if not v461 then
                                    return;
                                else
                                    local v462 = v461 and v461.m_iHealth or 0;
                                    v455 = ("%s: %s%.1fs\aDEFAULT \226\151\143 "):format(v460, v458 > 0 and v458 < v457 and "" or v458 > 0 and v457 < v458 and "\aFF0032FF" or "", v457);
                                    if v461 and v461:get_eye_position() then
                                        local v463 = (v461:is_alive() and v461:get_eye_position() or v461 and v461.m_hObserverTarget and v461.m_hObserverTarget:get_eye_position() or v461:get_eye_position()):dist(v456:get_origin());
                                        local v464 = nil;
                                        v464 = 500;
                                        local v465 = v464 * 3.5;
                                        v464 = v464 * l_exp_0(-(v463 * v463 / (v465 * 2 / 3 * (v465 / 3))));
                                        v464 = l_max_0(v464, 0);
                                        local l_m_ArmorValue_0 = v461.m_ArmorValue;
                                        if l_m_ArmorValue_0 > 0 then
                                            local v467 = v464 * 0.5;
                                            if l_m_ArmorValue_0 < (v464 - v467) * 0.5 then
                                                v467 = v464 - l_m_ArmorValue_0 * 2;
                                            end;
                                            v464 = v467;
                                        end;
                                        if v461 then
                                            if v462 < v464 then
                                                v455 = v455 .. "\aFF0032FFFATAL\aDEFAULT" .. (v454 and " \226\151\143 " or "");
                                            elseif v464 > 1 then
                                                v455 = v455 .. ("\aFCF369FF-%i HP\aDEFAULT%s"):format(v464, v454 and " \226\151\143 " or "");
                                            elseif not v454 then
                                                v455 = ("%s: %s%.1fs\aDEFAULT"):format(v460, v458 > 0 and v458 < v457 and "" or v458 > 0 and v457 < v458 and "\aFF0032FF" or "", v457);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        return;
                    end;
                end);
                if v427.planting then
                    v455 = v454 and ("    %s \226\151\143 "):format(v427.planting_site) or v427.planting_site;
                end;
                local l_v427_1 = v427;
                local l_animate_1 = v427.animate;
                local v470 = "is_bomb";
                local v471;
                if v455 ~= "" and not v454 then
                    v471 = 1;
                else
                    v471 = v454 and 1 or 0;
                end;
                l_animate_1 = l_animate_1(l_v427_1, v470, v471, v430 * 4);
                if l_animate_1 < 0.01 then
                    return;
                else
                    l_v427_1 = l_measure_text_0(v427.dpi_scale.font, "c", v455 .. (v454 and v427.player_data.temperature or ""));
                    v471 = v427;
                    v470 = v427.animate;
                    local v472 = "temperature_size.x";
                    local l_x_1 = l_v427_1.x;
                    local v474;
                    if not v427.planting and not v454 then
                        v474 = 9;
                    else
                        v474 = v454 and 22 or 24;
                    end;
                    v470 = v470(v471, v472, l_x_1 + v474 * v427.dpi_scale.scale, v430 * 0.5);
                    v471 = v427:animate("temperature_size.y", l_v427_1.y + 8 * v427.dpi_scale.scale, v430 * 0.5);
                    v472 = {
                        side = (l_v427_0.y + l_v427_0.h > v427.screen_size.y * 0.5 + l_v427_0.h * 0.5 and "B" or "T") .. "-" .. (l_v427_0.x + l_v427_0.w > v427.screen_size.x - l_v427_0.w - 14 and "R" or l_v427_0.x - l_v427_0.w < v427.screen_size.x * 0.005 and "L" or "C")
                    };
                    v472.x = v427:animate("temperature.x", v472.side:find("R") and l_v427_0.x + l_v427_0.w - v470 or v472.side:find("L") and l_v427_0.x or l_v427_0.x + l_v427_0.w * 0.5 - v470 * 0.5, v430 * 2);
                    v427.is_in_area.side = v472.side;
                    l_x_1 = v427:animate("temperature.y", l_v427_0.y + (v472.side:find("T") and 25 * v427.dpi_scale.scale + 10 * v445 * v427.dpi_scale.scale or -21 * v427.dpi_scale.scale + -10 * v445 * v427.dpi_scale.scale), v430);
                    l_v427_0.h = v471;
                    l_v427_0.y = l_x_1;
                    v427:render_window(nil, l_vector_0(v472.x, l_v427_0.y - 2 * v427.dpi_scale.scale), l_vector_0(v470, l_v427_0.h), v437, v437.a * v453, v429);
                    l_push_clip_rect_0(l_vector_0(v472.x, l_v427_0.y - 2 * v427.dpi_scale.scale), l_vector_0(v472.x + l_v427_0.w, l_v427_0.y - 2 * v427.dpi_scale.scale + l_v427_0.h));
                    if v427.planting then
                        l_x_1 = 3.125 - (3.125 + v427.on_plant_time - globals.curtime);
                        if l_x_1 > 3.125 then
                            l_x_1 = 3.125;
                        end;
                        l_circle_outline_0(l_vector_0(v472.x - (v454 and 11 or -4) * v427.dpi_scale.scale, l_v427_0.y - 2 * v427.dpi_scale.scale) + l_vector_0(v470 * 0.5, l_v427_0.h) * 0.5, l_color_0(15, 220 * v453), 5 * v427.dpi_scale.scale, 0, 1, 1 * v427.dpi_scale.scale);
                        l_circle_outline_0(l_vector_0(v472.x - (v454 and 11 or -4) * v427.dpi_scale.scale, l_v427_0.y - 2 * v427.dpi_scale.scale) + l_vector_0(v470 * 0.5, l_v427_0.h) * 0.5, l_color_0(255, 220 * v453), 5 * v427.dpi_scale.scale, 0, l_x_1 * 0.32114155788, 1 * v427.dpi_scale.scale);
                    end;
                    l_x_1 = l_text_0;
                    v474 = v427.dpi_scale.font;
                    local l_l_vector_0_0 = l_vector_0;
                    local l_x_2 = v472.x;
                    local v477;
                    if not v427.planting and not v454 then
                        v477 = -1;
                    else
                        v477 = v454 and 7 or -7;
                    end;
                    l_x_1(v474, l_l_vector_0_0(l_x_2 - v477 * v427.dpi_scale.scale, l_v427_0.y - 2 * v427.dpi_scale.scale) + l_vector_0(v470, l_v427_0.h) * 0.5, l_color_0():modulate_alpha(v437.a * v453 * l_animate_1), "c", v455 .. (v454 and v427.player_data.temperature or ""));
                    if v454 then
                        l_texture_0(v427.player_data.weather_icon, l_vector_0(v472.x + v470 - 17 * v427.dpi_scale.scale, l_v427_0.y), l_vector_0(16) * v427.dpi_scale.scale, l_color_0(255, 255 * v453));
                    end;
                    l_pop_clip_rect_0();
                    --[[ close >= 21 ]]
                end;
            end;
            v428.size.y = v427:animate("drag.size.y", 20 * v427.dpi_scale.scale, v430 * 0.5);
        end;
        return v427.player_data.temperature ~= nil and v427.player_data.weather_icon ~= nil and v427.player_data.country_code ~= nil;
    end, 
    get_keys = function(_)
        -- upvalues: l_get_binds_0 (ref), l_insert_0 (ref)
        local v479 = {};
        local v480 = l_get_binds_0();
        for v481 = 1, #v480 do
            l_insert_0(v479, 1, v480[v481]);
        end;
        return v479;
    end, 
    keybinds_vars = {
        window = {
            width = 0
        }
    }, 
    get_value = function(_, v483, v484)
        -- upvalues: l_type_0 (ref), l_ipairs_0 (ref), l_concat_0 (ref), l_tostring_0 (ref)
        local v485 = l_type_0(v484);
        if v485 == "boolean" then
            v484 = v484 == false and "disabled" or v483 == 1 and "holding" or "toggled";
        end;
        if v485 == "table" then
            local v486 = {};
            if #v484 <= 1 then
                v486 = v484;
            else
                for _, v488 in l_ipairs_0(v484) do
                    local v489 = "";
                    do
                        local l_v489_0 = v489;
                        v488:gsub("%w+", function(v491)
                            -- upvalues: l_v489_0 (ref)
                            l_v489_0 = l_v489_0 .. v491:sub(1, 1);
                        end);
                        v486[#v486 + 1] = l_v489_0:upper();
                    end;
                end;
            end;
            v484 = l_concat_0(v486, ", ");
        end;
        return l_tostring_0(v484);
    end, 
    icons = {
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        nil, 
        "GS", 
        [1] = l_get_icon_0("angle-right", true), 
        [2] = l_get_icon_0("discord"), 
        [3] = l_get_icon_0("file-arrow-up"), 
        [4] = l_get_icon_0("file-arrow-down"), 
        [5] = l_get_icon_0("trash"), 
        [6] = l_get_icon_0("floppy-disk"), 
        [7] = l_get_icon_0("arrows-left-right-to-line"), 
        [8] = l_get_icon_0("wand-magic-sparkles"), 
        [9] = l_get_icon_0("dice-d6"), 
        [10] = l_get_icon_0("eye-slash"), 
        [11] = l_get_icon_0("eye"), 
        [12] = l_get_icon_0("hammer-crash"), 
        [13] = l_get_icon_0("life-ring"), 
        [14] = l_get_icon_0("ear-muffs"), 
        [15] = l_get_icon_0("bolt"), 
        [16] = l_get_icon_0("bolt"), 
        [17] = l_get_icon_0("bolt"), 
        [18] = l_get_icon_0("bars"), 
        [19] = l_get_icon_0("sliders"), 
        [20] = l_get_icon_0("hand-sparkles"), 
        [21] = l_get_icon_0("camera-viewfinder"), 
        [22] = l_get_icon_0("bullseye-arrow"), 
        [23] = l_get_icon_0("rectangle-history"), 
        [24] = l_get_icon_0("hundred-points"), 
        [25] = l_get_icon_0("crosshairs-simple"), 
        [26] = l_get_icon_0("browsers"), 
        [27] = l_get_icon_0("warning"), 
        l_get_icon_0("street-view"), 
        l_get_icon_0("circle-exclamation"), 
        l_get_icon_0("person-falling-burst"), 
        l_get_icon_0("person-arrow-down-to-line"), 
        l_get_icon_0("person-circle-check"), 
        l_get_icon_0("tag"), 
        l_get_icon_0("rectangle-terminal"), 
        l_get_icon_0("person-falling"), 
        l_get_icon_0("square-bolt"), 
        l_get_icon_0("trash-can-clock"), 
        l_get_icon_0("volume-xmark"), 
        l_get_icon_0("dice-six"), 
        l_get_icon_0("bolt"), 
        l_get_icon_0("bomb")
    }, 
    keybinds = function(v492, v493, v494)
        -- upvalues: l_ipairs_0 (ref), l_pairs_0 (ref), l_measure_text_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_max_0 (ref), l_get_mouse_position_0 (ref), l_get_alpha_0 (ref)
        local v495 = globals.frametime * 16;
        local l_v492_0 = v492;
        local l_animate_2 = v492.animate;
        local v498 = "keybinds_alpha";
        local v499;
        if v494.menu.visuals.windows_display:get("Keybinds") and v494.menu.visuals.windows:get() and not v493.is_dragging then
            v499 = 1;
        else
            v499 = v493.is_dragging and 0.7 or 0;
        end;
        l_animate_2 = l_animate_2(l_v492_0, v498, v499, v495);
        if l_animate_2 > 0.01 then
            l_v492_0 = {
                x = v493.position.x, 
                y = v493.position.y, 
                w = v493.size.x, 
                h = 20 * v492.dpi_scale.scale
            };
            v498 = 0;
            v499 = 0;
            local v500 = 0;
            local v501 = v492:get_keys();
            for _, v503 in l_ipairs_0(v501) do
                local l_name_0 = v503.name;
                for _, v506 in l_pairs_0(v492.icons) do
                    l_name_0 = l_name_0.gsub(l_name_0, v506, ""):gsub("  ", ""):gsub("\aDEFAULT", ""):gsub("\a{Link Active}", ""):gsub("\n", "");
                end;
                if l_name_0.sub(l_name_0, 1, 1) == " " then
                    local v507 = l_name_0.sub(l_name_0, 2);
                    if v507 then
                        l_name_0 = v507;
                    end;
                end;
                l_name_0 = l_name_0.sub(l_name_0, 1, 1):upper() .. l_name_0.sub(l_name_0, 2):lower();
                local v508 = v492:get_value(v503.mode, v503.value):gsub("\n", ""):lower();
                if v508 == "" then
                    v508 = "select";
                end;
                local v509 = v492:animate("keyb vars.alpha" .. l_name_0, v503.active and 1 or 0, v495);
                local v510 = l_measure_text_0(v492.dpi_scale.font, nil, l_name_0);
                local v511 = l_measure_text_0(v492.dpi_scale.font, nil, v508);
                local v512 = -(6 - v510.y / 4 * v509);
                l_text_0(v492.dpi_scale.font, l_vector_0(l_v492_0.x + 2 * v492.dpi_scale.scale, l_v492_0.y + v511.y + 13 * v492.dpi_scale.scale + v498 + v512), l_color_0(255, 255 * v509 * l_animate_2), nil, l_name_0);
                l_text_0(v492.dpi_scale.font, l_vector_0(l_v492_0.x - 2 * v492.dpi_scale.scale + l_v492_0.w, l_v492_0.y + v511.y + 13 * v492.dpi_scale.scale + v498 + v512), l_color_0(255, 255 * v509 * l_animate_2), "r", ("[%s]"):format(v508));
                v498 = v498 + (v510.y + v510.y / 2.85) * v509;
                v499 = l_max_0(v499, v510.x);
                v500 = l_max_0(v500, v511.x);
            end;
            local v513 = l_measure_text_0(v492.dpi_scale.font, nil, "keybinds");
            local v514 = v492:animate("keybinds_is_in_area", (not (v493:is_in_area((l_get_mouse_position_0())) and l_get_alpha_0() == 1) or v493.is_dragging) and 0 or 1, v495);
            v492.is_in_area.keybinds = v514 > 0.01;
            if v492.is_in_area.keybinds then
                l_text_0(v492.dpi_scale.font, l_vector_0(l_v492_0.x + 2 * v492.dpi_scale.scale, l_v492_0.y + v493.size.y - 9 * v492.dpi_scale.scale), l_color_0(255, 220 * v514 * l_animate_2), nil, "Use mouse wheel to resize.");
                v498 = v498 + 8 * v492.dpi_scale.scale;
            end;
            local v515 = v492:animate("keyb window_alpha", (not (l_get_alpha_0() <= 0) or #v501 > 0) and l_animate_2 or 0, v495);
            local v516 = l_max_0(20 + v513.x, l_max_0(100 * v492.dpi_scale.scale, v499 + v500 + 25 * v492.dpi_scale.scale));
            local v517 = (v494.menu.visuals.windows_color:get() == "Fade" and v494.menu.visuals.windows_color:get("Fade")[1] or v494.menu.visuals.windows_color:get("Solid")[1]):modulate_alpha(255 * v515);
            v492:render_window(v494.menu.visuals.windows_color:get() == "Fade" and v494.menu.visuals.windows_color:get("Fade")[1]:gradient(v494.menu.visuals.windows_color:get("Fade")[2], -3, "keybinds") or "keybinds", l_vector_0(l_v492_0.x, l_v492_0.y), l_vector_0(l_v492_0.w, v492:animate("keybind text y", v513.y + 8 * v492.dpi_scale.scale, v495 * 0.5)), v517, v517.a, v494);
            v493.size.x = v492:animate("keybinds w", v516, v495);
            v493.size.y = v492:animate("keybinds h", v498, v495) + 22 * v492.dpi_scale.scale;
        end;
    end, 
    spectators_vars = {
        players = {}, 
        window = {
            width = 0, 
            alpha = 0
        }, 
        specs = {
            m_active = {}, 
            m_contents = {}, 
            unsorted = {}
        }
    }, 
    get_spectators = function(_)
        -- upvalues: l_get_local_player_0 (ref), l_get_players_0 (ref), l_pairs_0 (ref), l_insert_0 (ref)
        local v519 = {};
        local v520, v521 = l_get_local_player_0();
        if v520 ~= nil then
            if v520.m_hObserverTarget then
                v521 = v520.m_hObserverTarget;
            else
                v521 = v520;
            end;
            local v522 = l_get_players_0(false, false);
            if v522 ~= nil then
                for _, v524 in l_pairs_0(v522) do
                    local l_m_hObserverTarget_0 = v524.m_hObserverTarget;
                    if l_m_hObserverTarget_0 and l_m_hObserverTarget_0 == v521 and v524 ~= v520 then
                        l_insert_0(v519, v524);
                    end;
                end;
            end;
        end;
        return v519;
    end, 
    spectators = function(v526, v527, v528)
        -- upvalues: l_pairs_0 (ref), l_measure_text_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_texture_0 (ref), l_insert_0 (ref), l_get_mouse_position_0 (ref), l_get_alpha_0 (ref), l_max_0 (ref)
        local v529 = globals.frametime * 16;
        local v530 = v526:get_spectators();
        local l_v526_0 = v526;
        local l_animate_3 = v526.animate;
        local v533 = "spectators_alpha";
        local v534;
        if v528.menu.visuals.windows_display:get("Spectators") and v528.menu.visuals.windows:get() and not v527.is_dragging then
            v534 = 1;
        else
            v534 = v527.is_dragging and 0.7 or 0;
        end;
        l_animate_3 = l_animate_3(l_v526_0, v533, v534, v529);
        if l_animate_3 <= 0.01 then
            return;
        else
            l_v526_0 = {
                x = v527.position.x, 
                y = v527.position.y, 
                w = v527.size.x, 
                h = 20 * v526.dpi_scale.scale
            };
            v533 = l_v526_0.x + l_v526_0.w * 0.5 > v526.screen_size.x * 0.5;
            v534 = {};
            local v535 = {};
            local v536 = 0;
            local v537 = 0;
            local v538 = 0;
            for _, v540 in l_pairs_0(v530) do
                local v541 = v540:get_name();
                if v534[v541] == nil then
                    v534[v541] = 0;
                end;
                v534[v541] = v526:animate("spectators_" .. v541, v540 and 1 or 0, v529);
                if v534[v541] >= 0.01 then
                    local v542 = l_measure_text_0(v526.dpi_scale.font, nil, v541);
                    local v543 = {
                        text_x = 0, 
                        text = v542.y + 10 * v526.dpi_scale.scale, 
                        avatar = 1 * v526.dpi_scale.scale
                    };
                    if v533 then
                        v543 = {
                            text = 3 * v526.dpi_scale.scale, 
                            avatar = v527.size.x - v542.y - 5 * v526.dpi_scale.scale, 
                            text_x = 15 * v526.dpi_scale.scale
                        };
                    end;
                    v543.text = v526:animate("spec text" .. v541, v543.text, v529);
                    v543.avatar = v526:animate("spec avatar" .. v541, v543.avatar, v529);
                    v543.text_x = v526:animate("spec text_x" .. v541, v543.text_x, v529);
                    local v544 = -(6 - v542.y / 4 * v534[v541]);
                    l_text_0(v526.dpi_scale.font, l_vector_0(l_v526_0.x + v543.text, l_v526_0.y + v542.y + 13 * v526.dpi_scale.scale + v536 + v544), l_color_0(255, 255 * v534[v541] * l_animate_3), nil, v541);
                    if v540:get_steam_avatar() then
                        l_texture_0(v540:get_steam_avatar(), l_vector_0(l_v526_0.x + 2 * v526.dpi_scale.scale + v543.avatar, l_v526_0.y + v542.y + 13 * v526.dpi_scale.scale + v536 + v544), l_vector_0(v542.y, v542.y), l_color_0(255, 255 * v534[v541] * l_animate_3), "f");
                    end;
                    if v540 then
                        l_insert_0(v535, v540);
                    end;
                    v536 = v536 + (v542.y + v542.y / 2.85) * v534[v541];
                    if v537 < v542.x + v543.text_x then
                        v537 = v542.x + v543.text_x;
                    end;
                    if v538 < v542.y then
                        v538 = v542.y;
                    end;
                end;
            end;
            local v545 = l_measure_text_0(v526.dpi_scale.font, nil, "spectators");
            local v546 = v526:animate("spectators_is_in_area", (not (v527:is_in_area((l_get_mouse_position_0())) and l_get_alpha_0() == 1) or v527.is_dragging) and 0 or 1, v529);
            v526.is_in_area.spectators = v546 > 0.01;
            if v546 > 0.01 then
                l_text_0(v526.dpi_scale.font, l_vector_0(l_v526_0.x + 2 * v526.dpi_scale.scale, l_v526_0.y + v527.size.y - 9 * v526.dpi_scale.scale), l_color_0(255, 220 * v546 * l_animate_3), nil, "Use mouse wheel to resize.");
                v536 = v536 + 8 * v526.dpi_scale.scale;
            end;
            local v547 = v526:animate("spec window_alpha", (not (l_get_alpha_0() <= 0) or #v535 > 0) and l_animate_3 or 0, v529);
            local v548 = l_max_0(20 + v545.x, l_max_0(100 * v526.dpi_scale.scale, v537 + 25 * v526.dpi_scale.scale));
            local v549 = (v528.menu.visuals.windows_color:get() == "Fade" and v528.menu.visuals.windows_color:get("Fade")[1] or v528.menu.visuals.windows_color:get("Solid")[1]):modulate_alpha(255 * v547);
            v526:render_window(v528.menu.visuals.windows_color:get() == "Fade" and v528.menu.visuals.windows_color:get("Fade")[1]:gradient(v528.menu.visuals.windows_color:get("Fade")[2], -3, "spectators") or "spectators", l_vector_0(l_v526_0.x, l_v526_0.y), l_vector_0(l_v526_0.w, v545.y + 8 * v526.dpi_scale.scale), v549, v549.a, v528);
            v527.size.x = v526:animate("spectators w", v548, v529);
            v527.size.y = v526:animate("spectators h", v536, v529) + 22 * v526.dpi_scale.scale;
            return;
        end;
    end, 
    slowdown = function(v550, v551, v552)
        -- upvalues: l_measure_text_0 (ref), l_get_local_player_0 (ref), l_get_mouse_position_0 (ref), l_get_alpha_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_is_button_down_0 (ref), l_shadow_0 (ref), l_rect_0 (ref), l_rect_outline_0 (ref), l_push_clip_rect_0 (ref), l_pop_clip_rect_0 (ref)
        local v553 = globals.frametime * 16;
        local v554 = v552.menu.visuals.windows_color:get("Fade")[1];
        local v555 = v552.menu.visuals.windows_color:get("Solid")[1];
        local v556 = l_measure_text_0(v550.dpi_scale.font, "c", "Max velocity reduced by 100%");
        local v557 = l_get_local_player_0();
        local l_v550_0 = v550;
        local l_animate_4 = v550.animate;
        local v560 = "slowdown_alpha";
        local v561;
        if v552.menu.visuals.windows_display:get("Slowdown") and v557 and v552.menu.visuals.windows:get() and not v551.is_dragging then
            v561 = 1;
        else
            v561 = v551.is_dragging and 0.7 or 0;
        end;
        l_animate_4 = l_animate_4(l_v550_0, v560, v561, v553);
        if l_animate_4 > 0.01 then
            l_v550_0 = {
                x = v551.position.x, 
                y = v551.position.y, 
                w = v551.size.x, 
                h = 20 * v550.dpi_scale.scale
            };
            v561 = v550:animate("slowdown_is_in_area", (not (v551:is_in_area((l_get_mouse_position_0())) and l_get_alpha_0() == 1) or v551.is_dragging) and 0 or 1, v553);
            v550.is_in_area.slowdown = v561 > 0.01;
            if v550.is_in_area.slowdown then
                l_text_0(v550.dpi_scale.font, l_vector_0(l_v550_0.x, l_v550_0.y + l_v550_0.h), l_color_0(255, 220 * v561 * l_animate_4), nil, "Press RMB to center align.");
                l_text_0(v550.dpi_scale.font, l_vector_0(l_v550_0.x, l_v550_0.y + l_v550_0.h + v556.y), l_color_0(255, 220 * v561 * l_animate_4), nil, "Use mouse wheel to resize.");
                if l_is_button_down_0(2) then
                    v552.menu.visuals.slowdown_x:set(v550.screen_size.x * 0.5 - v551.size.x * 0.5 - 0.5);
                    v551.position.x = v550.screen_size.x * 0.5 - v551.size.x * 0.5 - 0.5;
                end;
            end;
            local v562 = globals.realtime % 3 <= 1 and 1 or globals.realtime % 3 <= 2 and 0.5 or 0;
            local l_v550_1 = v550;
            local l_animate_5 = v550.animate;
            local v565 = "velocity_modifier";
            local v566;
            if v561 ~= 1 or not v562 then
                if v557 == nil then
                    v566 = l_get_alpha_0() >= 0.5 and 0.75 or 1;
                else
                    v566 = v557:is_alive() and v557.m_flVelocityModifier or 1;
                end;
            else
                v566 = v562;
            end;
            l_animate_5 = l_animate_5(l_v550_1, v565, v566, v553 * 0.3);
            l_v550_1 = v550:animate("slowdown_alpha2", v557 and (not (l_animate_5 >= 1 and l_get_alpha_0() <= 0) or l_get_alpha_0() > 0) and 1 or 0, v553) * l_animate_4;
            if l_v550_1 < 0.01 then
                return;
            else
                v565 = ("Max velocity reduced by %d%%"):format(100 - l_animate_5 * 100);
                v566 = (v552.menu.visuals.windows_color:get() == "Fade" and v554 or v555):modulate_alpha(255 * l_v550_1);
                l_shadow_0(l_vector_0(l_v550_0.x, l_v550_0.y + v556.y + 4 * v550.dpi_scale.scale), l_vector_0(l_v550_0.x + l_v550_0.w, l_v550_0.y + l_v550_0.h), v552.menu.visuals.windows_color:get() == "Fade" and v552.menu.visuals.windows_color:get("Fade")[2]:modulate_alpha(255 * l_v550_1):lerp(v566, l_animate_5) or v566, 16);
                l_rect_0(l_vector_0(l_v550_0.x, l_v550_0.y + v556.y + 4 * v550.dpi_scale.scale), l_vector_0(l_v550_0.x + l_v550_0.w, l_v550_0.y + l_v550_0.h), l_color_0(16, 125 * l_v550_1));
                l_rect_outline_0(l_vector_0(l_v550_0.x, l_v550_0.y + v556.y + 4 * v550.dpi_scale.scale), l_vector_0(l_v550_0.x + l_v550_0.w, l_v550_0.y + l_v550_0.h), l_color_0(16, 125 * l_v550_1));
                l_rect_0(l_vector_0(l_v550_0.x + 1 * v550.dpi_scale.scale, l_v550_0.y + v556.y + 5 * v550.dpi_scale.scale), l_vector_0(l_v550_0.x + 2 * v550.dpi_scale.scale + (l_v550_0.w - 3 * v550.dpi_scale.scale) * l_animate_5, l_v550_0.y + l_v550_0.h - 1 * v550.dpi_scale.scale), v552.menu.visuals.windows_color:get() == "Fade" and v552.menu.visuals.windows_color:get("Fade")[2]:modulate_alpha(255 * l_v550_1):lerp(v566, l_animate_5) or v566);
                l_push_clip_rect_0(l_vector_0(l_v550_0.x, l_v550_0.y), l_vector_0(l_v550_0.x + v556.x, l_v550_0.y + l_v550_0.h));
                l_text_0(v550.dpi_scale.font, l_vector_0(l_v550_0.x, l_v550_0.y) + l_vector_0(v556.x, l_v550_0.h - 12 * v550.dpi_scale.scale) * 0.5, l_color_0(255, 255 * l_v550_1), "c", v565);
                l_pop_clip_rect_0();
                v551.size.x = v556.x;
                v551.size.y = v550:animate("slowdown_text_size.h", 20 * v550.dpi_scale.scale, v553) + v556.y * 2 * v561;
            end;
        end;
    end, 
    update_defensive_state = function(v567, v568)
        -- upvalues: l_get_local_player_0 (ref), l_band_0 (ref)
        local v569 = rage.exploit:get();
        local l_m_nTickBase_0 = l_get_local_player_0().m_nTickBase;
        v567.is_tab = l_band_0(v568.buttons, 65536) == 65536;
        if v569 < 1 or globals.choked_commands > 0 then
            v567.old_tick_base = l_m_nTickBase_0;
            return;
        else
            local v571 = l_m_nTickBase_0 - v567.old_tick_base;
            v567.defensive_state = v571 < 0 or v571 > 1;
            v567.old_tick_base = l_m_nTickBase_0;
            return;
        end;
    end, 
    crosshair_indicators = function(v572, v573)
        -- upvalues: l_get_local_player_0 (ref), l_measure_text_0 (ref), v183 (ref), l_color_0 (ref), l_shadow_0 (ref), l_vector_0 (ref), l_text_0 (ref), l_rect_0 (ref), l_rect_outline_0 (ref), l_abs_0 (ref), l_max_0 (ref), l_min_0 (ref), l_floor_0 (ref), l_gradient_0 (ref), v164 (ref), l_get_binds_0 (ref), l_tostring_0 (ref), l_ceil_0 (ref)
        local v574 = l_get_local_player_0();
        if v574 == nil then
            return;
        else
            local v575 = globals.frametime * 3;
            if v574:is_alive() and v573.menu.visuals.crosshair_indicators:get() then
                local v576 = l_measure_text_0(2, "c", "CELESTIA  " .. v183:upper());
                local v577 = {
                    x = v572.screen_size.x, 
                    y = v572.screen_size.y
                };
                local v578 = 30;
                local v579 = v572:animate("scope_value", v574.m_bIsScoped and 1 or 0, v575 * 6);
                local v580 = false;
                if v574 then
                    local v581 = v574:get_player_weapon();
                    if not v581 then
                        return;
                    else
                        local v582 = v581:get_weapon_info();
                        if not v582 then
                            return;
                        else
                            v580 = v582.weapon_type == 9;
                        end;
                    end;
                end;
                local v583 = v573.menu.visuals.indicators_color:get() == "Fade";
                local v584 = v572:animate("addition_alpha", not v573.menu.visuals.indicators_additions:get("Alpha Modulate") and 1 or v572.is_tab and 0 or v580 and 0.5 or 1, v575 * 6);
                local v585 = v573.menu.visuals.indicators_color:get("Solid")[1];
                local v586 = v573.menu.visuals.indicators_color:get("Fade")[1]:modulate_alpha(255):gradient(v573.menu.visuals.indicators_color:get("Fade")[2]:modulate_alpha(255), -3, v183:upper());
                local v587 = v583 and v586 or v183:upper();
                if v573.menu.visuals.indicators_additions:get("Glow Text") then
                    local v588 = (v583 and v587 ~= nil and l_color_0(230):mix(l_color_0(v587:sub(#v587 - 8, #v587 - 1)), 0.3) or l_color_0(230):mix(v585, 0.3)):alpha_modulate(225 * v584);
                    l_shadow_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 2 + 8) * v579 - v576.x * 0.5, v577.y * 0.5 + v578 + 1), l_vector_0(v577.x * 0.5 + 32 * v579 + v576.x * 0.5, v577.y * 0.5 + v578 + 1), v588);
                end;
                local v589 = v572:animate("pulse_anim", globals.realtime % 2 >= 0.5 and 1 or 0.1, v575);
                local v590 = v183:upper() == "CODE" and 1 or 0;
                l_text_0(2, l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 - v576.x * 0.5 + 2 + v590, v577.y * 0.5 + v578 - 6), l_color_0(210, 255 * v584), nil, "CELESTIA");
                l_text_0(2, l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 - v576.x * 0.5 + 2 + l_measure_text_0(2, nil, "CELESTIA").x + v590, v577.y * 0.5 + v578 - 6), v585:modulate_alpha(255 * v584 * v589), nil, v583 and v586 or v183:upper());
                l_rect_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 - v576.x * 0.5, v577.y * 0.5 + v578 + 6), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 + v576.x * 0.5 + v590 * 2, v577.y * 0.5 + v578 + 11), l_color_0(0, 100 * v584));
                l_rect_outline_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 - v576.x * 0.5, v577.y * 0.5 + v578 + 6), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 + v576.x * 0.5 + v590 * 2, v577.y * 0.5 + v578 + 11), l_color_0(0, 200 * v584));
                local v591 = nil;
                v591 = l_abs_0(l_max_0(-57, l_min_0(57, l_floor_0((v574.m_flPoseParameter[11] or 0) * 120 - 60 + 0.5))));
                v591 = l_floor_0(v572:animate("body_yaw", v591, v575 * 2)) / 57;
                l_gradient_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 - v576.x * 0.5 + 1, v577.y * 0.5 + v578 + 7), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 - (v576.x * 0.5 + 1 - v590 * 2) + v576.x * v591, v577.y * 0.5 + v578 + 10), (v583 and v573.menu.visuals.indicators_color:get("Fade")[1] or v585):modulate_alpha(200 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[2] or v585):modulate_alpha(50 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[1] or v585):modulate_alpha(200 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[2] or v585):modulate_alpha(50 * v584));
                local v592 = (not not v164.hide_shots:get() or v164.double_tap:get()) and v572.defensive_state;
                v578 = v578 + 10;
                local v593 = l_get_binds_0();
                local v594 = false;
                for v595 = 1, #v593 do
                    if v593[v595].active and l_tostring_0(v593[v595].reference):find("Min. Damage") ~= nil then
                        v594 = true;
                    end;
                end;
                l_text_0(2, l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 2 - v576.x * 0.5 - 2, v577.y * 0.5 + v578), l_color_0(), nil, ("\a%sDOUBLETAP%s\a%sHIDE"):format(l_color_0(210, (v164.double_tap:get() and 255 or 120) * v584):to_hex(), v590 == 1 and "  " or "     ", l_color_0(210, (v164.hide_shots:get() and 255 or 120) * v584):to_hex()));
                v578 = v578 + 10;
                l_text_0(2, l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 2 - v576.x * 0.5 - 2, v577.y * 0.5 + v578), l_color_0(), nil, ("\a%sFS  \a%sDMG  \a%sLC"):format(l_color_0(210, ((not not v164.freestanding:get_override() or v164.freestanding:get()) and 255 or 120) * v584):to_hex(), l_color_0(210, (v594 and 255 or 120) * v584):to_hex(), l_color_0(210, ((v164.lag_options:get_override() == "Always On" and v164.double_tap:get() or v164.hide_shots:get() and v164.hs_options:get_override() == "Break LC") and 255 or v592 and 255 or 120) * v584):to_hex()));
                local v596 = v572:animate("defensive_value", v592 and 20 - v590 * 3 or 1, v575 * 8);
                local v597 = l_measure_text_0(2, nil, "FS  DMG  LC");
                l_rect_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 - v576.x * 0.5 + v597.x, v577.y * 0.5 + v578 + 5), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 2 - v576.x * 0.5 + v597.x + 22 - v590 * 3, v577.y * 0.5 - 4 + v578 + v597.y), l_color_0(0, 100 * v584));
                l_rect_outline_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 - v576.x * 0.5 + v597.x, v577.y * 0.5 + v578 + 5), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 2 - v576.x * 0.5 + v597.x + 22 - v590 * 3, v577.y * 0.5 - 4 + v578 + v597.y), l_color_0(0, 200 * v584));
                if v596 > 2.2 then
                    l_gradient_0(l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 4 - v576.x * 0.5 + v597.x, v577.y * 0.5 + v578 + 6), l_vector_0(v577.x * 0.5 + (v576.x * 0.5 + 4) * v579 + 3 - v576.x * 0.5 + v597.x + v596, v577.y * 0.5 + v578 + v597.y - 5), (v583 and v573.menu.visuals.indicators_color:get("Fade")[1] or v585):modulate_alpha(200 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[2] or v585):modulate_alpha(50 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[1] or v585):modulate_alpha(200 * v584), (v583 and v573.menu.visuals.indicators_color:get("Fade")[2] or v585):modulate_alpha(50 * v584));
                end;
                if v573.menu.visuals.indicators_additions:get("Min. Damage") then
                    local v598 = v572:animate("min_damage", v164.min_damage:get(), v575 * 8);
                    v598 = v598 >= 0 and l_floor_0(v598 + 0.5) or l_ceil_0(v598 - 0.5);
                    local v599 = v572:animate("min_damage_alpha", v598 == v164.min_damage:get() and 1 or 0.5, v575 * 8);
                    l_text_0(1, l_vector_0(v572.screen_size.x * 0.5 + 5, v572.screen_size.y * 0.5 - 14), l_color_0(255, 255 * v599), nil, v598 == 0 and "Auto" or v598);
                end;
            end;
            return;
        end;
    end, 
    logs_data = {}, 
    logs_vars = {
        shot_id = -1, 
        hitgroups = {
            [1] = "generic", 
            [2] = "head", 
            [3] = "chest", 
            [4] = "stomach", 
            [5] = "left arm", 
            [6] = "right arm", 
            [7] = "left leg", 
            [8] = "right leg", 
            [9] = "neck", 
            [10] = "?", 
            [11] = "gear"
        }
    }, 
    logs_data_dev = {}, 
    print_log = function(v600, ...)
        -- upvalues: l_random_0 (ref)
        table.insert(v600.logs_data_dev, 1, {
            count = true, 
            text = ..., 
            time = globals.realtime + 8, 
            id = globals.tickcount * globals.curtime + l_random_0(1, 100000)
        });
    end, 
    on_paint = function(v601)
        -- upvalues: l_pairs_0 (ref), l_text_0 (ref), l_vector_0 (ref), l_color_0 (ref), l_remove_0 (ref), l_max_0 (ref)
        local v602 = 5;
        local v603 = globals.frametime * 8;
        for v604, v605 in l_pairs_0(v601.logs_data_dev) do
            local v606 = v605.text .. v605.id;
            local v607 = v605.time - globals.realtime;
            local v608 = v601:animate("logs_dev" .. v606, v607 > 0 and v605.count and 1 or 0, v603);
            l_text_0(1, l_vector_0(8, v602), l_color_0(255, 255 * v608), nil, v605.text);
            if v608 <= 0 then
                l_remove_0(v601.logs_data_dev, v604);
            elseif #v601.logs_data_dev >= 8 and v601.logs_data_dev[l_max_0(8, v604)].count then
                v601.logs_data_dev[l_max_0(8, v604)].count = false;
            end;
            v602 = v602 + 12 * v608;
        end;
    end, 
    log_push = function(v609, v610, v611, v612, v613)
        -- upvalues: l_tostring_0 (ref), l_insert_0 (ref), l_random_0 (ref)
        if not v612 or not v612 then
            v612 = {};
        end;
        v611 = l_tostring_0(v611):gsub("\n", "");
        l_insert_0(v609.logs_data, 1, {
            count = true, 
            alpha = 0, 
            clr = v610, 
            text = v611, 
            event_time = globals.curtime, 
            id = v613 or globals.tickcount * globals.curtime + l_random_0(1, 100000), 
            userid = v612[1], 
            prefix = v612[2], 
            damage = v612[3]
        });
    end, 
    log_paint = function(v614, v615)
        -- upvalues: l_get_local_player_0 (ref), l_pairs_0 (ref), l_color_0 (ref), l_pcall_0 (ref), l_max_0 (ref), l_measure_text_0 (ref), l_rect_0 (ref), l_vector_0 (ref), l_shadow_0 (ref), l_text_0 (ref), l_remove_0 (ref)
        v614:on_paint();
        if l_get_local_player_0() == nil then
            v614.logs_data = {};
            return;
        else
            local v616 = globals.frametime * 3;
            local v617 = 5;
            local v618 = 110;
            local v619 = 0;
            local v620 = 2;
            for v621, v622 in l_pairs_0(v614.logs_data) do
                local v623 = v622.text .. v622.id;
                local v624 = v614:animate("logss" .. v623, globals.curtime - v622.event_time <= v617 - 0.1 and v622.alpha == 0 and v622.count and 1 or 1.1, v616 * 2);
                local v625 = v614:animate("logss2" .. v623, globals.curtime - v622.event_time <= v617 - 0.1 and v622.alpha == 0 and v622.count and 1 or 0, v616 * 2);
                v622.clr = v622.clr or l_color_0();
                local l_clr_0 = v622.clr;
                local l_v624_0 = v624;
                local v628 = nil;
                v628 = v622.text:gsub("\n", "");
                do
                    local l_v622_0 = v622;
                    do
                        local l_v628_0 = v628;
                        l_pcall_0(function()
                            -- upvalues: l_v622_0 (ref), l_v628_0 (ref), l_max_0 (ref)
                            if l_v622_0.damage and l_v622_0.userid:is_player() then
                                l_v628_0 = l_v628_0:gsub("%d+\aDEFAULT damage", l_v622_0.damage .. "\aDEFAULT damage"):gsub("%d+\aDEFAULT remaining", l_max_0(0, l_v622_0.userid.m_iHealth) .. "\aDEFAULT remaining");
                            end;
                        end);
                        local v631 = l_measure_text_0(1, nil, l_v628_0);
                        l_rect_0(l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 - v631.x / 2 - 6, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 - 10), l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 + v631.x * 0.5 + 5, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 + 10), l_color_0(16, 255 * v625 * v615.menu.visuals.background_logs:get() * 0.01), 4.5);
                        local v632 = (5.9 - (globals.curtime - l_v622_0.event_time)) / 5.9;
                        if v632 >= 0.1 then
                            l_shadow_0(l_vector_0(v614.screen_size.x * 0.5 - v631.x / 2 - 4 - v620 * 0.5 - 1, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 - 4.5 * v632), l_vector_0(v614.screen_size.x * 0.5 - v631.x / 2 - 2 - v620 * 0.5 - 1, v614.screen_size.y - v618 + v619 - 50 * l_v624_0 + 4.5 * v632), l_color_0(l_clr_0.r, l_clr_0.g, l_clr_0.b, 255 * v625), 16);
                            l_rect_0(l_vector_0(v614.screen_size.x * 0.5 - v631.x / 2 - 4 - v620 * 0.5 - 1, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 - 4.5 * v632), l_vector_0(v614.screen_size.x * 0.5 - v631.x / 2 - 2 - v620 * 0.5 - 1, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 + 4.5 * v632), l_color_0(l_clr_0.r, l_clr_0.g, l_clr_0.b, 255 * v625), 3);
                            l_shadow_0(l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 + v631.x / 2 + 4, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 - 4.5 * v632), l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 + v631.x / 2 + 6, v614.screen_size.y - v618 + v619 - 50 * l_v624_0 + 4.5 * v632), l_color_0(l_clr_0.r, l_clr_0.g, l_clr_0.b, 255 * v625), 16);
                            l_rect_0(l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 + v631.x / 2 + 4, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 - 4.5 * v632), l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5 + v631.x / 2 + 6, v614.screen_size.y - v618 + v619 + 1 - 50 * l_v624_0 + 4.5 * v632), l_color_0(l_clr_0.r, l_clr_0.g, l_clr_0.b, 255 * v625), 3);
                        end;
                        l_text_0(1, l_vector_0(v620 * 0.5 + v614.screen_size.x * 0.5, v614.screen_size.y - v618 + v619 - 50 * l_v624_0), l_color_0(255, 255 * v625), "c", l_v628_0);
                        if globals.curtime - l_v622_0.event_time > v617 + 1 then
                            l_remove_0(v614.logs_data, v621);
                        elseif #v614.logs_data >= 7 and v614.logs_data[l_max_0(7, v621)].count then
                            v614.logs_data[l_max_0(7, v621)].count = false;
                        end;
                        v619 = v619 - (v631.y + v631.y * 1.5) * v624;
                    end;
                end;
            end;
            return;
        end;
    end, 
    cmarker_data = {}, 
    crosshair_marker = function(v633, v634)
        -- upvalues: l_get_local_player_0 (ref), l_insert_0 (ref), l_line_0 (ref), l_vector_0 (ref), l_remove_0 (ref)
        if not l_get_local_player_0() or not v634.menu.visuals.aimbot_logs:get() then
            v633.cmarker_data = {};
            return;
        else
            local v635 = {};
            for v636 = 1, #v633.cmarker_data do
                local v637 = v633.cmarker_data[v636];
                if globals.curtime - v637.time < 0.5 and (#v633.cmarker_data <= 8 or v636 >= #v633.cmarker_data - 8) then
                    if v637.offset < 1 then
                        v637.offset = v637.offset + 0.033;
                    end;
                elseif v637.offset > 0 then
                    v637.offset = v637.offset - 0.033;
                else
                    l_insert_0(v635, v636);
                end;
                if #v633.cmarker_data > 1 then
                    l_insert_0(v635, v636);
                end;
                local v638 = v633.screen_size.x * 0.5;
                local v639 = v633.screen_size.y * 0.5;
                local v640 = 5;
                l_line_0(l_vector_0(v638 - v640 * 2, v639 - v640 * 2), l_vector_0(v638 - v640, v639 - v640), v637.color:modulate_alpha(255 * (1 - (globals.curtime - v637.time) * 1.5)));
                l_line_0(l_vector_0(v638 - v640 * 2, v639 + v640 * 2), l_vector_0(v638 - v640, v639 + v640), v637.color:modulate_alpha(255 * (1 - (globals.curtime - v637.time) * 1.5)));
                l_line_0(l_vector_0(v638 + v640 * 2, v639 + v640 * 2), l_vector_0(v638 + v640, v639 + v640), v637.color:modulate_alpha(255 * (1 - (globals.curtime - v637.time) * 1.5)));
                l_line_0(l_vector_0(v638 + v640 * 2, v639 - v640 * 2), l_vector_0(v638 + v640, v639 - v640), v637.color:modulate_alpha(255 * (1 - (globals.curtime - v637.time) * 1.5)));
            end;
            for v641 = 1, #v635 do
                l_remove_0(v633.cmarker_data, v641);
            end;
            return;
        end;
    end, 
    pluses_data = {}, 
    pluses_marker = function(v642, v643)
        -- upvalues: l_get_local_player_0 (ref), v164 (ref), l_insert_0 (ref), l_vector_0 (ref), l_line_0 (ref), l_remove_0 (ref)
        local v644 = l_get_local_player_0();
        v164.marker_3d:override();
        if not v644 or not v643.menu.visuals.aimbot_logs:get() then
            v642.pluses_data = {};
            return;
        else
            v164.marker_3d:override(false);
            local v645 = {};
            for v646 = 1, #v642.pluses_data do
                local v647 = v642.pluses_data[v646];
                if globals.curtime - v647.time < 2 and (#v642.pluses_data <= 8 or v646 >= #v642.pluses_data - 8) then
                    if v647.offset < 1 then
                        v647.offset = v647.offset + 0.01;
                    end;
                elseif v647.offset > 0 then
                    v647.offset = v647.offset - 0.01;
                else
                    l_insert_0(v645, v646);
                end;
                local v648 = v647.vector and v647.vector:to_screen() or l_vector_0(0, 0);
                local l_x_3 = v648.x;
                local l_y_4 = v648.y;
                l_line_0(l_vector_0(l_x_3 - 6, l_y_4 - 0), l_vector_0(l_x_3 + 6, l_y_4 - 0), v647.color:modulate_alpha(255 * v647.offset));
                l_line_0(l_vector_0(l_x_3 - 0, l_y_4 - 6), l_vector_0(l_x_3 + 0, l_y_4 + 6), v647.color:modulate_alpha(255 * v647.offset));
            end;
            for v651 = 1, #v645 do
                l_remove_0(v642.pluses_data, v651);
            end;
            return;
        end;
    end, 
    gamesense_buffer = {}, 
    render_indicator = function(v652, v653, v654, v655, v656, v657, v658, v659)
        -- upvalues: l_insert_0 (ref), l_color_0 (ref)
        for v660 = 1, #v652.gamesense_buffer do
            if v652.gamesense_buffer[v660].name == v657 then
                return;
            end;
        end;
        l_insert_0(v652.gamesense_buffer, {
            name = v657, 
            color = l_color_0(v653, v654, v655, v656), 
            is_circle = v658, 
            is_bomb = v659
        });
    end, 
    calibri = l_load_font_0("calibri", l_vector_0(24, 23.5), "ab"), 
    image = l_load_image_from_file_0("materials/panorama/images/icons/ui/bomb_c4.svg", l_vector_0(64, 64)), 
    clear_planting_info = function(v661)
        v661.planting = false;
        v661.on_plant_time = 0;
        v661.planting_site = "";
    end, 
    bomb_beginplant = function(v662, v663)
        -- upvalues: l_get_player_resource_0 (ref), l_get_0 (ref)
        local v664 = l_get_player_resource_0();
        if not v664 then
            return;
        else
            local l_m_bombsiteCenterA_0 = v664.m_bombsiteCenterA;
            local l_m_bombsiteCenterB_0 = v664.m_bombsiteCenterB;
            local v667 = l_get_0(v663.site);
            if not v667 then
                return;
            else
                local v668 = v667.m_vecMins:lerp(v667.m_vecMaxs, 0.5);
                v662.planting_site = v668:distsqr(l_m_bombsiteCenterA_0) < v668:distsqr(l_m_bombsiteCenterB_0) and "A" or "B";
                v662.on_plant_time = globals.curtime;
                v662.planting = true;
                return;
            end;
        end;
    end, 
    is_doubletap = function(_)
        -- upvalues: v164 (ref), l_get_local_player_0 (ref)
        if not v164.double_tap:get() or rage.exploit:get() ~= 1 then
            return false;
        else
            local v670 = l_get_local_player_0();
            if not v670 or not v670:is_alive() then
                return;
            else
                local v671 = v670:get_player_weapon();
                if not v671 then
                    return false;
                else
                    local v672 = v670.m_flNextAttack + 0.25;
                    local l_m_flNextPrimaryAttack_0 = v671.m_flNextPrimaryAttack;
                    if l_m_flNextPrimaryAttack_0 == nil then
                        return;
                    else
                        local v674 = l_m_flNextPrimaryAttack_0 + 0.3;
                        if v672 == nil or v674 == nil then
                            return false;
                        else
                            return v672 - globals.curtime < 0 and v674 - globals.curtime < 0;
                        end;
                    end;
                end;
            end;
        end;
    end, 
    vars = {
        hits = 0, 
        shots = 0
    }, 
    gs_aim_ack = function(v675, v676)
        v675.vars.shots = v675.vars.shots + 1;
        if not v676.state then
            v675.vars.hits = v675.vars.hits + 1;
        end;
    end, 
    gs_indicators = function(v677, v678)
        -- upvalues: l_get_local_player_0 (ref), l_get_binds_0 (ref), l_tostring_0 (ref), l_net_channel_0 (ref), l_min_0 (ref), l_max_0 (ref), l_abs_0 (ref), l_color_0 (ref), v164 (ref), l_get_threat_0 (ref), l_get_entities_0 (ref), l_rect_0 (ref), l_vector_0 (ref), l_exp_0 (ref), l_measure_text_0 (ref), l_gradient_0 (ref), l_circle_outline_0 (ref), l_texture_0 (ref), l_text_0 (ref), l_pairs_0 (ref), l_get_mouse_position_0 (ref), l_get_alpha_0 (ref)
        if not globals.is_connected then
            v677.vars.shots = 0;
            v677.vars.hits = 0;
        end;
        local v679 = l_get_local_player_0();
        if v679 == nil or not globals.is_in_game or not globals.is_connected or not v678.menu.visuals.skeet_indicators:get() or not v678.menu.visuals.gs_display:get() then
            return;
        else
            local v680 = l_get_binds_0();
            local v681 = false;
            local v682 = false;
            for v683 = 1, #v680 do
                if l_tostring_0(v680[v683].reference):find("Min. Damage") ~= nil and v680[v683].active then
                    v681 = true;
                end;
                if l_tostring_0(v680[v683].reference):find("Hit Chance") ~= nil and v680[v683].active then
                    v682 = true;
                end;
            end;
            local l_gs_display_0 = v678.menu.visuals.gs_display;
            if v679:is_alive() then
                if l_gs_display_0:get("Hitchance") and v682 then
                    v677:render_indicator(255, 255, 255, 205, "HC");
                end;
                if l_gs_display_0:get("Aim Stats") then
                    local v685 = v677.vars.hits == 0 and v677.vars.shots == 0 and 0 or v677.vars.hits / v677.vars.shots * 100 or 0;
                    v677:render_indicator(255, 255, 255, 205, v677.vars.hits == 0 and v677.vars.shots == 0 and "NULL" or ("%.0f%%"):format(v685));
                end;
                local v686 = l_net_channel_0();
                if globals.is_connected and v686 and l_gs_display_0:get("Fake Latency") then
                    local v687 = v686.latency[1];
                    local v688 = v686.latency[0];
                    local v689 = l_min_0(l_max_0(0, l_abs_0((v688 + v687) * 1000) / 200), 1);
                    local v690 = v689 < 0.5 and l_color_0(167, 194, 41):mix(l_color_0(255, 233, 161), v689 * 2) or l_color_0(169, 233, 18):mix(l_color_0(167, 194, 41), (v689 - 0.5) * 2);
                    if v164.fake_latency:get() ~= 0 then
                        v677:render_indicator(v690.r, v690.g, v690.b, 205, "PING");
                    end;
                end;
                if not v164.fake_duck:get() and v164.double_tap:get() and l_gs_display_0:get("Double Tap") then
                    v677:render_indicator(v677:is_doubletap() and 255 or 255, v677:is_doubletap() and 255 or 0, v677:is_doubletap() and 255 or 50, v677:is_doubletap() and 205 or 245, "DT");
                end;
                if not v164.fake_duck:get() and v164.hide_shots:get() and not v164.double_tap:get() and l_gs_display_0:get("Hide Shots") then
                    v677:render_indicator(255, 255, 255, 205, "OSAA");
                end;
                if v164.dormant_aim:get() and l_gs_display_0:get("Dormant Aim") then
                    local v691 = 255;
                    local v692 = 255;
                    local v693 = 255;
                    local v694 = 205;
                    if l_get_threat_0() and l_get_threat_0():is_dormant() then
                        local v695 = 255;
                        local v696 = 0;
                        local v697 = 50;
                        v694 = 245;
                        v693 = v697;
                        v692 = v696;
                        v691 = v695;
                    end;
                    v677:render_indicator(v691, v692, v693, v694, "DA");
                end;
                if v164.fake_duck:get() and l_gs_display_0:get("Fake Duck") then
                    v677:render_indicator(255, 255, 255, 205, "DUCK");
                end;
                if v164.safe_points:get() == "Force" and l_gs_display_0:get("Safe Points") then
                    v677:render_indicator(255, 255, 255, 205, "SAFE");
                end;
                if v164.body_aim:get() == "Force" and l_gs_display_0:get("Body Aim") then
                    v677:render_indicator(255, 255, 255, 205, "BODY");
                end;
                if v681 and l_gs_display_0:get("Damage") then
                    v677:render_indicator(255, 255, 255, 205, "MD");
                end;
                if v164.freestanding:get() and l_gs_display_0:get("Freestanding") then
                    v677:render_indicator(255, 255, 255, 205, "FS");
                end;
            end;
            l_get_entities_0("CPlantedC4", false, function(v698)
                -- upvalues: l_gs_display_0 (ref), l_color_0 (ref), v677 (ref), l_rect_0 (ref), l_vector_0 (ref), v679 (ref), l_get_local_player_0 (ref), l_exp_0 (ref), l_max_0 (ref)
                if not v698 or v698.m_bBombDefused then
                    return;
                else
                    if l_gs_display_0:get("Bomb Info") or l_gs_display_0:get("Defusing") then
                        local v699 = v698.m_flC4Blow - globals.curtime;
                        if v699 >= 0 then
                            local v700 = v698.m_hBombDefuser ~= nil;
                            local l_m_flDefuseLength_0 = v698.m_flDefuseLength;
                            local v702 = v700 and (v698.m_flDefuseCountDown - globals.curtime) / 1 or -1;
                            if v702 > 0 and l_gs_display_0:get("Defusing") then
                                local v703 = v702 < v699 and l_color_0(40, 140, 50, 200) or l_color_0(255, 0, 0, 200);
                                local v704 = (v677.screen_size.y + 70) / l_m_flDefuseLength_0 * v702;
                                l_rect_0(l_vector_0(0, 0), l_vector_0(20, v677.screen_size.y), l_color_0(5, 200));
                                l_rect_0(l_vector_0(1, v677.screen_size.y - v704), l_vector_0(19, v677.screen_size.y), v703);
                            end;
                            local v705 = v698.m_nBombSite == 0 and "A" or "B";
                            if not v679 then
                                return;
                            else
                                local v706 = v679:is_alive() and l_get_local_player_0() or v679.m_hObserverTarget;
                                if not v706 then
                                    return;
                                else
                                    local v707 = v706 and v706.m_iHealth or 0;
                                    if l_gs_display_0:get("Bomb Info") then
                                        v677:render_indicator(255, 255, 255, 205, ("%s - %.1fs"):format(v705, v699), nil, true);
                                    end;
                                    if v706 and v706:get_eye_position() then
                                        local v708 = (v706:is_alive() and v706:get_eye_position() or v706 and v706.m_hObserverTarget and v706.m_hObserverTarget:get_eye_position() or v706:get_eye_position()):dist(v698:get_origin());
                                        local v709 = nil;
                                        v709 = 500;
                                        local v710 = v709 * 3.5;
                                        v709 = v709 * l_exp_0(-(v708 * v708 / (v710 * 2 / 3 * (v710 / 3))));
                                        v709 = l_max_0(v709, 0);
                                        local l_m_ArmorValue_1 = v706.m_ArmorValue;
                                        local v712 = 0.5;
                                        local v713 = 0.5;
                                        if l_m_ArmorValue_1 > 0 then
                                            local v714 = v709 * v712;
                                            if l_m_ArmorValue_1 < (v709 - v714) * v713 then
                                                v714 = v709 - l_m_ArmorValue_1 * (1 / v713);
                                            end;
                                            v709 = v714;
                                        end;
                                        if l_gs_display_0:get("Bomb Info") and v706 then
                                            if v707 < v709 then
                                                v677:render_indicator(255, 0, 50, 245, "FATAL");
                                            elseif v709 > 1 then
                                                v677:render_indicator(252, 243, 105, 205, ("-%i HP"):format(v709));
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    return;
                end;
            end);
            if v677.planting and l_gs_display_0:get("Bomb Info") then
                local v715 = 3.125 - (3.125 + v677.on_plant_time - globals.curtime);
                if v715 > 3.125 then
                    v715 = 3.125;
                end;
                v677:render_indicator(252, 243, 105, 205, v677.planting_site, {
                    [1] = l_color_0(213, 213, 214, 255), 
                    [2] = v715 * 0.32114155788
                }, true);
            end;
            local v716 = {
                l_vector_0(-200, -200), 
                l_vector_0(-200, -200)
            };
            v677.calibri:set_size(l_vector_0(24 * v677.dpi_scale.scale, 23.5 * v677.dpi_scale.scale));
            for v717 = 1, #v677.gamesense_buffer do
                local v718 = v677.gamesense_buffer[v717];
                local v719 = l_measure_text_0(v677.calibri, nil, v718.is_bomb and " " .. v718.name or v718.name);
                v719.x = (v718.is_bomb and 32 * v677.dpi_scale.scale or 0) + v719.x;
                local v720 = l_vector_0(30, v677.screen_size.y / 1.385 - 1 + (v719.y + 17) * -v717);
                l_gradient_0(l_vector_0(v720.x - 10, v720.y - 7) - l_vector_0(20), l_vector_0(v720.x - 10 + (v720.x + v719.x + 7) / 2, v720.y + v719.y + 2), l_color_0(0, 0), l_color_0(0, 55), l_color_0(0, 0), l_color_0(0, 55));
                l_gradient_0(l_vector_0(v720.x - 10 + (v720.x + v719.x + 7) / 2, v720.y - 7), l_vector_0(v720.x + v719.x + 7, v720.y + v719.y + 2) + l_vector_0(20), l_color_0(0, 55), l_color_0(0, 0), l_color_0(0, 55), l_color_0(0, 0));
                if v718.is_circle then
                    l_circle_outline_0(l_vector_0(l_measure_text_0(v677.calibri, "as", v718.is_bomb and " " .. v718.name or v718.name).x + 14 + (v718.is_bomb and 64 or 32) * v677.dpi_scale.scale, v720.y + 10 * v677.dpi_scale.scale), l_color_0(0, 0, 0, 200), 11 * v677.dpi_scale.scale, 0, 1, 5 * v677.dpi_scale.scale);
                    l_circle_outline_0(l_vector_0(l_measure_text_0(v677.calibri, "as", v718.is_bomb and " " .. v718.name or v718.name).x + 14 + (v718.is_bomb and 64 or 32) * v677.dpi_scale.scale, v720.y + 10 * v677.dpi_scale.scale), v718.is_circle[1], 10 * v677.dpi_scale.scale, 0, v718.is_circle[2], 3 * v677.dpi_scale.scale);
                end;
                if v718.is_bomb then
                    l_texture_0(v677.image, v720 - l_vector_0(0, 6), l_vector_0(32 * v677.dpi_scale.scale, 31 * v677.dpi_scale.scale), v718.color);
                end;
                l_text_0(v677.calibri, v720 + l_vector_0(v718.is_bomb and 32 * v677.dpi_scale.scale or 0, 0), l_color_0(0, 100), nil, v718.is_bomb and " " .. v718.name or v718.name);
                l_text_0(v677.calibri, v720 + l_vector_0(v718.is_bomb and 32 * v677.dpi_scale.scale or 0, 1), l_color_0(0, 55), nil, v718.is_bomb and " " .. v718.name or v718.name);
                l_text_0(v677.calibri, v720 + l_vector_0(v718.is_bomb and 32 * v677.dpi_scale.scale or 1, 1), l_color_0(0, 100), nil, v718.is_bomb and " " .. v718.name or v718.name);
                l_text_0(v677.calibri, v720 + l_vector_0(v718.is_bomb and 32 * v677.dpi_scale.scale or 0, 0), v718.color, nil, v718.is_bomb and " " .. v718.name or v718.name);
                if v717 == 1 then
                    v716[1] = v720;
                end;
                v716[2] = v720;
            end;
            local v721 = l_vector_0(-200, -200);
            for _, v723 in l_pairs_0(v677.gamesense_buffer) do
                local v724 = l_measure_text_0(v677.calibri, nil, v723.name);
                if v724.x > v721.x then
                    v721.x = v724.x;
                end;
                if v724.y > v721.y then
                    v721.y = v724.y;
                end;
            end;
            local v725 = l_get_mouse_position_0();
            local v726 = v677:animate("gamesense", v725.x > v716[1].x - 20 and v725.x < v716[1].x + v721.x + 20 and v725.y > v716[2].y - 8 and v725.y < v716[1].y + v721.y + 2 and 1 or 0, globals.frametime * 16) * l_get_alpha_0();
            v677.is_in_area.gamesense = v726 > 0;
            if v726 > 0 then
                l_text_0(v677.dpi_scale.font, l_vector_0(v716[1].x - 20, v716[1].y + v721.y + 2), l_color_0(255, 220 * v726), nil, "Use mouse wheel to resize.");
            end;
            v677.gamesense_buffer = {};
            return;
        end;
    end, 
    anti_aim_arrows = function(v727, v728)
        -- upvalues: l_get_local_player_0 (ref), l_text_0 (ref), l_vector_0 (ref)
        local v729 = l_get_local_player_0();
        if v729 == nil or not v729:is_alive() then
            return;
        else
            local v730 = globals.frametime * 12;
            local v731 = v727:animate("is_arrows_anim", v728.menu.anti_aim.aa_arrows:get() and 1 or 0, v730);
            if v731 < 0.01 then
                return;
            else
                v731 = v727:animate("arrows_alpha", v729.m_bIsScoped and 0 or 1, v730 * 4) * v731;
                if v731 < 0.01 then
                    return;
                else
                    local v732 = v728.menu.anti_aim.arrows_color:get();
                    local v733 = v727:animate("arrows_indent", v728.menu.anti_aim.arrows_indent:get(), v730 * 2);
                    local v734 = v727:animate("manuals_left", v728.menu.anti_aim.manuals:get() == "Left" and v732:modulate_alpha(255 * v731) or v732:modulate_alpha(40 * v731), v730 * 2);
                    local v735 = v727:animate("manuals_right", v728.menu.anti_aim.manuals:get() == "Right" and v732:modulate_alpha(255 * v731) or v732:modulate_alpha(40 * v731), v730 * 2);
                    l_text_0(v727.calibri, l_vector_0(v727.screen_size.x * 0.5 - v733, v727.screen_size.y * 0.5 + 1), v734, "c", "\226\157\176");
                    l_text_0(v727.calibri, l_vector_0(v727.screen_size.x * 0.5 + v733, v727.screen_size.y * 0.5 + 1), v735, "c", "\226\157\177");
                    return;
                end;
            end;
        end;
    end, 
    marker_data = {
        array = {}, 
        hitgroups = {
            [0] = "generic", 
            [1] = "head", 
            [2] = "chest", 
            [3] = "stomach", 
            [4] = "left arm", 
            [5] = "right arm", 
            [6] = "left leg", 
            [7] = "right leg", 
            [8] = nil, 
            [9] = nil, 
            [10] = "gear"
        }, 
        hitgroup_to_hitbox = {
            [1] = 0, 
            [2] = 5, 
            [3] = 2, 
            [4] = 13, 
            [5] = 14, 
            [6] = 7, 
            [7] = 8
        }
    }, 
    marker_hurt = function(v736, v737, v738)
        -- upvalues: l_get_0 (ref), l_get_local_player_0 (ref), l_vector_0 (ref), l_insert_0 (ref)
        if not v738.menu.visuals.damage_marker:get() then
            return;
        else
            local l_userid_0 = v737.userid;
            local l_attacker_0 = v737.attacker;
            l_attacker_0 = l_get_0(l_attacker_0, true);
            l_userid_0 = l_get_0(l_userid_0, true);
            if l_attacker_0 == nil or l_userid_0 == nil then
                return;
            elseif l_attacker_0 ~= l_get_local_player_0() then
                return;
            else
                local l_hitgroup_0 = v737.hitgroup;
                local v742 = v736.marker_data.hitgroup_to_hitbox[l_hitgroup_0];
                if v742 == nil then
                    v742 = 5;
                end;
                local v743 = l_userid_0:get_hitbox_position(v742) + l_vector_0(0, 0, 25);
                l_insert_0(v736.marker_data.array, {
                    time = globals.realtime + 2, 
                    damage = v737.dmg_health, 
                    remains = v737.health, 
                    weapon = v737.weapon, 
                    position = v743, 
                    hitgroup = v736.marker_data.hitgroups[l_hitgroup_0]
                });
                return;
            end;
        end;
    end, 
    marker_paint = function(v744, v745)
        -- upvalues: v164 (ref), l_ipairs_0 (ref), l_tostring_0 (ref), l_remove_0 (ref), l_text_0 (ref)
        v164.damage_marker:override();
        if not v745.menu.visuals.damage_marker:get() then
            return;
        else
            v164.damage_marker:override(false);
            local l_realtime_0 = globals.realtime;
            local l_frametime_0 = globals.frametime;
            for v748, v749 in l_ipairs_0(v744.marker_data.array) do
                local v750 = v744:animate(l_tostring_0(v749.time), l_realtime_0 < v749.time and 1 or 0, l_frametime_0 * 12);
                if v750 <= 0.05 and v749.time <= l_realtime_0 then
                    l_remove_0(v744.marker_data.array, v748);
                end;
                v749.position.z = v749.position.z + 50 * l_frametime_0;
                local v751 = v745.menu.visuals.damage_marker_color:get("Body")[1];
                local v752 = v745.menu.visuals.damage_marker_color:get("Head")[1];
                l_text_0(1, v749.position:to_screen(), v749.hitgroup == "head" and v752:modulate_alpha(v750 * v752.a) or v751:modulate_alpha(v750 * v751.a), nil, v749.damage);
            end;
            return;
        end;
    end, 
    scope_paint = function(v753, v754)
        -- upvalues: l_get_local_player_0 (ref), l_gradient_0 (ref), l_vector_0 (ref)
        local v755 = l_get_local_player_0();
        if not v754.menu.visuals.custom_scope:get() or not v755 or not v755:is_alive() then
            return;
        else
            local v756 = v755:get_player_weapon();
            if not v756 then
                return;
            else
                local v757 = globals.frametime * 12;
                local v758 = 0;
                if v754.menu.visuals.custom_scope_modif:get("Inaccuracy") then
                    v758 = v753:animate("scope_inaccuracy", v756:get_inaccuracy() * 100, v757 * 2);
                end;
                local v759 = v753:animate("scope_alpha", v755.m_bIsScoped and 1 or 0, v757);
                local l_custom_scope_color_0 = v754.menu.visuals.custom_scope_color;
                local v761 = l_custom_scope_color_0:get() == "Fade" and l_custom_scope_color_0:get("Fade")[2]:modulate_alpha(l_custom_scope_color_0:get("Fade")[2].a * v759) or l_custom_scope_color_0:get("Solid")[1]:modulate_alpha(0);
                local v762 = l_custom_scope_color_0:get() == "Fade" and l_custom_scope_color_0:get("Fade")[1]:modulate_alpha(l_custom_scope_color_0:get("Fade")[1].a * v759) or l_custom_scope_color_0:get("Solid")[1]:modulate_alpha(l_custom_scope_color_0:get("Solid")[1].a * v759);
                local v763 = v754.menu.visuals.custom_scope_line:get();
                local v764;
                if v754.menu.visuals.custom_scope_line:get() > v754.menu.visuals.custom_scope_dist:get() or not v758 then
                    v764 = 0;
                else
                    v764 = v758;
                end;
                v763 = v763 + v764;
                v764 = v754.menu.visuals.custom_scope_dist:get();
                local v765;
                if v754.menu.visuals.custom_scope_dist:get() > v763 or not v758 then
                    v765 = 0;
                else
                    v765 = v758;
                end;
                v764 = v764 + v765;
                v765 = v753.screen_size * 0.5;
                if not v754.menu.visuals.custom_scope_modif:get("T-Style") then
                    l_gradient_0(l_vector_0(v765.x, v765.y - v763), l_vector_0(v765.x + 1, v765.y - v764 + 1), v761, v761, v762, v762);
                end;
                l_gradient_0(l_vector_0(v765.x, v765.y + v763 + 1), l_vector_0(v765.x + 1, v765.y + v764), v761, v761, v762, v762);
                l_gradient_0(l_vector_0(v765.x - v764 + 1, v765.y), l_vector_0(v765.x - v763, v765.y + 1), v762, v761, v762, v761);
                l_gradient_0(l_vector_0(v765.x + v763 + 1, v765.y), l_vector_0(v765.x + v764, v765.y + 1), v761, v762, v761, v762);
                return;
            end;
        end;
    end, 
    molotovs_created_at = {}, 
    radius_paint = function(v766, v767)
        -- upvalues: l_get_local_player_0 (ref), l_get_entities_0 (ref), l_insert_0 (ref), l_format_1 (ref), l_circle_3d_outline_0 (ref), l_vector_0 (ref), l_max_0 (ref)
        if not v767.menu.visuals.grenade_radius:get() then
            return;
        else
            local v768 = l_get_local_player_0();
            local v769 = l_get_entities_0("CSmokeGrenadeProjectile");
            local l_tickcount_0 = globals.tickcount;
            local l_tickinterval_0 = globals.tickinterval;
            local l_curtime_0 = globals.curtime;
            local v773 = globals.frametime * 8;
            local v774 = {};
            local l_molotovs_created_at_0 = v766.molotovs_created_at;
            v766.molotovs_created_at = {};
            v774 = l_get_entities_0("CInferno");
            for v776 = 1, #v774 do
                local v777 = v774[v776];
                if v777.m_fireCount > 0 then
                    v766.molotovs_created_at[v777] = l_molotovs_created_at_0[v777] ~= nil and l_molotovs_created_at_0[v777] or l_curtime_0;
                    l_insert_0(v769, v777);
                end;
            end;
            for v778 = 1, #v769 do
                local v779 = v769[v778];
                local v780 = v779:get_classname();
                if v780 == "CSmokeGrenadeProjectile" then
                    local l_m_vecOrigin_1 = v779.m_vecOrigin;
                    if v779.m_bDidSmokeEffect then
                        local l_m_nSmokeEffectTickBegin_0 = v779.m_nSmokeEffectTickBegin;
                        if l_m_nSmokeEffectTickBegin_0 ~= nil then
                            local v783 = l_tickinterval_0 * (l_tickcount_0 - l_m_nSmokeEffectTickBegin_0);
                            if v783 > 0 and 17.55 - v783 > 0 then
                                local v784 = 125;
                                if v783 < 0.3 then
                                    v784 = v784 * 0.6 + v784 * (v783 / 0.3) * 0.4;
                                end;
                                local v785 = v766:animate("smokevalues" .. v778, 17.55 - v783 > 0.2 and 1 or 0, v773 * 2);
                                local v786 = v766:animate("smoke values" .. v778, v768 and v768:is_alive() and l_m_vecOrigin_1:dist(v768:get_origin()) < 900 and 1 or l_m_vecOrigin_1:dist(v768:get_origin()) >= 1250 and 0 or 0.3, v773);
                                local v787 = v767.menu.visuals.grenade_radius_color:get("Smoke")[1]:modulate_alpha(v767.menu.visuals.grenade_radius_color:get("Smoke")[1].a * v785 * v786);
                                if tonumber(l_format_1("%.1f", v786)) ~= 0 then
                                    l_circle_3d_outline_0(l_m_vecOrigin_1, v787, v784, 0, 1, 1);
                                end;
                            end;
                        end;
                    end;
                end;
                if v780 == "CInferno" then
                    local l_m_vecOrigin_2 = v779.m_vecOrigin;
                    local v789 = {};
                    local v790 = 40;
                    local v791 = 0;
                    local v792 = nil;
                    local v793 = nil;
                    for v794 = 1, 32 do
                        if v779.m_bFireIsBurning[v794] then
                            local v795 = v779.m_fireXDelta[v794];
                            local v796 = v779.m_fireYDelta[v794];
                            local v797 = v779.m_fireZDelta[v794];
                            l_insert_0(v789, l_vector_0(v795, v796, v797));
                        end;
                    end;
                    for v798 = 1, #v789 do
                        local v799 = v789[v798];
                        for v800 = 1, #v789 do
                            local v801 = v789[v800];
                            local v802 = v799:dist(v801);
                            if v791 < v802 then
                                v791 = v802;
                                v792 = v799;
                                v793 = v801;
                            end;
                        end;
                    end;
                    if v792 ~= nil and v793 ~= nil then
                        local l_m_hOwnerEntity_0 = v779.m_hOwnerEntity;
                        local v804 = false;
                        if l_m_hOwnerEntity_0 and cvar.mp_friendlyfire:int() == 0 and l_m_hOwnerEntity_0 ~= v768 and not l_m_hOwnerEntity_0:is_enemy() then
                            v804 = true;
                        end;
                        local v805 = l_max_0(0, tonumber(l_format_1("%.1f", 7.03125 - globals.tickinterval * (globals.tickcount - v779.m_nFireEffectTickBegin))));
                        local v806 = v792.lerp(v792, v793, 0.5);
                        local v807 = v766:animate("molotovvalues" .. v778, v805 > 0.2 and 1 or 0, v773 * 2);
                        local v808 = v766:animate("radius" .. v778, v791 * 0.5 + v790, v773);
                        local v809 = v766:animate("molotov values" .. v778, v768 and v768:is_alive() and l_m_vecOrigin_2:dist(v768:get_origin()) >= 500 and l_m_vecOrigin_2:dist(v768:get_origin()) <= 900 and 0.3 or v768 and v768:is_alive() and l_m_vecOrigin_2:dist(v768:get_origin()) >= 900 and 0 or 1, v773);
                        local l_grenade_radius_color_0 = v767.menu.visuals.grenade_radius_color;
                        local v811 = v804 and l_grenade_radius_color_0:get("Friend Molotov")[1]:modulate_alpha(l_grenade_radius_color_0:get("Friend Molotov")[1].a * v807 * v809) or l_grenade_radius_color_0:get("Molotov")[1]:modulate_alpha(l_grenade_radius_color_0:get("Molotov")[1].a * v807 * v809);
                        if tonumber(l_format_1("%.1f", v809)) ~= 0 then
                            l_circle_3d_outline_0(l_m_vecOrigin_2 + v806, v811, v808, 0, 1, 1);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end, 
    inferno = l_load_image_from_file_0("materials/panorama/images/icons/equipment/inferno.svg", l_vector_0(30, 28)), 
    hegrenade = l_load_image_from_file_0("materials/panorama/images/icons/equipment/hegrenade.svg", l_vector_0(19, 32)), 
    font = l_load_font_0("calibri", 11, "ab"), 
    warning_data = {}, 
    clear_warning_info = function(v812)
        -- upvalues: l_pairs_0 (ref), l_get_0 (ref)
        for v813, v814 in l_pairs_0(v812.warning_data) do
            if not v814.entity or not l_get_0(v814.entity) then
                v812.warning_data[v813] = nil;
            end;
        end;
    end, 
    grenade_warning = function(v815, v816)
        -- upvalues: l_get_local_player_0 (ref), l_get_offscreen_0 (ref), l_clamp_0 (ref), l_circle_gradient_0 (ref), l_color_0 (ref), l_circle_outline_0 (ref), l_texture_0 (ref), l_vector_0 (ref), l_text_0 (ref)
        local v817 = v816.expire_time - globals.curtime;
        local v818 = ("%s%s%s"):format(v816.expire_time, v816.origin, v816.type);
        if not v815.warning_data[v818] then
            v815.warning_data[v818] = {
                entity = v816.entity, 
                start_time = v817, 
                realtime = globals.realtime
            };
        end;
        if v817 < 0.015 then
            v815.warning_data[v818] = nil;
        end;
        if not v815.warning_data[v818] then
            return;
        else
            local v819 = l_get_local_player_0();
            if not v819 then
                return;
            else
                local v820 = v819:is_alive() and v819 or v819.m_hObserverTarget;
                if not v820 then
                    return;
                else
                    local v821 = v816.origin:to_screen() and v816.origin:to_screen() or l_get_offscreen_0(v816.origin, 0.92, true);
                    local l_start_time_0 = v815.warning_data[v818].start_time;
                    if v816.type == "Molly" and v815.warning_data[v818] then
                        local v823 = v816.closest_point:dist(v820:get_origin());
                        local v824 = l_clamp_0(180 - v823, 0, 100) * 0.01;
                        l_circle_gradient_0(v821, l_color_0(0, 220), l_color_0(255 * v824, 0, 0, 220), 30 + 20 * v824, 360, 1);
                        l_circle_outline_0(v821, l_color_0(255, 220), 29.5 + 20 * v824, 360, v816.entity:get_classname() == "CMolotovProjectile" and v817 / l_start_time_0 or v817 / 7, 2);
                        l_texture_0(v815.inferno, v821 - l_vector_0(15, 25), l_color_0(255, 220));
                        l_text_0(v815.font, v821 + l_vector_0(0, 16), l_color_0(255, 220), "c", ("%.0f"):format(v816.origin:dist(v820:get_origin()) * 0.08128));
                    else
                        local v825 = v816.origin:dist(v820:get_origin());
                        local v826 = v816.damage >= 1 and l_clamp_0(346 - v825, 0, 100) * 0.01 or 0;
                        local v827 = v816.damage >= 1 and l_clamp_0(250 - v825, 0, 100) * 0.01 or 0;
                        l_circle_gradient_0(v821, l_color_0(0, 220), v816.damage >= 1 and l_color_0(100, 220):lerp(l_color_0(255, 10, 10, 220), v826) or l_color_0(0, 220), 30 + 20 * v827, 360, 1);
                        l_circle_outline_0(v821, l_color_0(255, 220), 29.5 + 20 * v827, 360, v817 * 0.63, 2);
                        l_texture_0(v815.hegrenade, v821 - l_vector_0(10, 27), l_color_0(255, 220));
                        l_text_0(v815.font, v821 + l_vector_0(0, 16), l_color_0(255, 220), "c", v816.damage);
                    end;
                    return;
                end;
            end;
        end;
    end, 
    preditcion_info = {}, 
    collect_prediction_data = function(v828, v829)
        v828.preditcion_info = v829;
    end, 
    grenade_prediction = function(v830)
        -- upvalues: l_line_0 (ref), v164 (ref), l_circle_0 (ref), l_color_0 (ref), l_text_0 (ref), l_vector_0 (ref)
        if not v830.preditcion_info.type then
            return;
        else
            for v831 = 1, #v830.preditcion_info.path do
                local v832 = v830.preditcion_info.path[math.max(1, v831 - 1)]:to_screen();
                local v833 = v830.preditcion_info.path[v831]:to_screen();
                if v832 and v833 then
                    l_line_0(v832, v833, v830.preditcion_info.damage >= 1 and v164.trajectory_hit_color:get() or v164.trajectory_color:get());
                end;
            end;
            if #v830.preditcion_info.path > 1 then
                for v834 = 1, #v830.preditcion_info.collisions - 1 do
                    local v835 = v830.preditcion_info.collisions[v834]:to_screen();
                    if v835 then
                        l_circle_0(v835, l_color_0(0, 150), 3, 360, 1);
                        l_circle_0(v835, l_color_0(), 2, 360, 1);
                    end;
                end;
                local v836 = v830.preditcion_info.path[#v830.preditcion_info.path]:to_screen();
                if v836 then
                    l_circle_0(v836, l_color_0(0, 150), 3, 360, 1);
                    local v837 = v830.preditcion_info.damage >= 1 and l_color_0(0, 255, 0, 255) or l_color_0(255, 0, 0, 255);
                    l_circle_0(v836, v837, 2.4, 360, 1);
                    if v830.preditcion_info.damage >= 1 and v836 then
                        local v838 = v830.preditcion_info.type == "Molly" and ("%.1f ft"):format(v830.preditcion_info.damage * 0.083529) or v830.preditcion_info.type == "Flash" and v830.preditcion_info.damage .. "%" or v830.preditcion_info.type == "Frag" and v830.preditcion_info.damage .. " dmg" or "";
                        l_text_0(1, v836 - l_vector_0(0, 9), l_color_0(), "c", v838);
                    end;
                end;
            end;
            v830.preditcion_info = {};
            return;
        end;
    end, 
    tag_anim = {
        [1] = "C|", 
        [2] = "C\206\181|", 
        [3] = "C\206\181|", 
        [4] = "C|", 
        [5] = "CE|", 
        [6] = "CE|", 
        [7] = "CE\197\129|", 
        [8] = "CE\197\129|", 
        [9] = "CE|", 
        [10] = "CE|", 
        [11] = "CEL|", 
        [12] = "CEL|", 
        [13] = "CEL3|", 
        [14] = "CEL3|", 
        [15] = "CEL|", 
        [16] = "CEL|", 
        [17] = "CELE|", 
        [18] = "CELE|", 
        [19] = "CELE|#", 
        [20] = "CELE|#!", 
        [21] = "CELE|#!?", 
        [22] = "CELE|#!?<", 
        [23] = "CELE|#!<", 
        [24] = "CELE|#<", 
        [25] = "CELE|<", 
        [26] = "CELES|<", 
        [27] = "CELES|", 
        [28] = "CELEST|", 
        [29] = "CELEST|", 
        [30] = "CELESTk|", 
        [31] = "CELEST|", 
        [32] = "CELESTI|", 
        [33] = "CELESTI|", 
        [34] = "CELESTIA|", 
        [35] = "CELESTIA", 
        [36] = "CELESTIA", 
        [37] = "CELESTI|<", 
        [38] = "CELEST|<", 
        [39] = "CELES|<", 
        [40] = "CEL3|<", 
        [41] = "CEL|<", 
        [42] = "C3|<", 
        [43] = "C|<", 
        [44] = "0|<", 
        [45] = "", 
        [46] = "", 
        [47] = "", 
        [48] = ""
    }, 
    clantag = function(v839, v840)
        -- upvalues: l_get_local_player_0 (ref), v164 (ref), l_set_clan_tag_0 (ref), l_net_channel_0 (ref), l_get_game_rules_0 (ref), l_floor_0 (ref), l_fmod_0 (ref)
        if not l_get_local_player_0() then
            return;
        elseif not v840.menu.miscellaneous.clan_tag:get() then
            if not v839.remove_tag then
                v164.clan_tag:override();
                l_set_clan_tag_0("\000");
                v839.remove_tag = true;
            end;
            return;
        else
            local v841 = l_net_channel_0();
            if not v841 then
                return;
            else
                v164.clan_tag:override(false);
                local v842 = l_get_game_rules_0();
                if v842.m_gamePhase == 5 or v842.m_gamePhase == 4 then
                    l_set_clan_tag_0("CELESTIA");
                else
                    local v843 = v841.latency[1] / globals.tickinterval;
                    local v844 = globals.tickcount + v843;
                    local v845 = l_floor_0(l_fmod_0(v844 / 10, #v839.tag_anim + 1) + 1);
                    if #v839.tag_anim < v845 then
                        v845 = 1;
                    end;
                    local v846 = v839.tag_anim[v845];
                    if v839.current_tag ~= v846 then
                        l_set_clan_tag_0(v846);
                        v839.current_tag = v846;
                    end;
                end;
                v839.remove_tag = false;
                return;
            end;
        end;
    end, 
    engine_client = l_cast_0(l_typeof_0("void***"), l_create_interface_0("engine.dll", "VEngineClient014")), 
    console_is_visible = l_cast_0(l_typeof_0("bool(__thiscall*)(void*)"), l_cast_0(l_typeof_0("void***"), l_create_interface_0("engine.dll", "VEngineClient014"))[0][11]), 
    materials = {
        [1] = "vgui_white", 
        [2] = "vgui/hud/800corner1", 
        [3] = "vgui/hud/800corner2", 
        [4] = "vgui/hud/800corner3", 
        [5] = "vgui/hud/800corner4"
    }, 
    console_color = l_color_0(), 
    console_modifier = function(v847, v848, v849)
        -- upvalues: l_pairs_0 (ref), l_get_materials_0 (ref), l_color_0 (ref)
        if v848 ~= "shutdown" then
            if not v847.set_callback and v847.console_is_visible(v847.engine_client) and v847.console_color ~= v849.menu.miscellaneous.console_color:get() then
                for _, v851 in l_pairs_0(v847.materials) do
                    l_get_materials_0(v851)[1]:alpha_modulate(v849.menu.miscellaneous.console_color:get().a / 255);
                    l_get_materials_0(v851)[1]:color_modulate(v849.menu.miscellaneous.console_color:get());
                end;
                v847.console_color = v849.menu.miscellaneous.console_color:get();
                v847.set_callback = true;
            else
                v847.set_callback = v847.console_is_visible(v847.engine_client);
            end;
            if not v847.unset_callback and not v847.console_is_visible(v847.engine_client) then
                for _, v853 in l_pairs_0(v847.materials) do
                    l_get_materials_0(v853)[1]:reset();
                end;
                v847.unset_callback = true;
                v847.console_color = l_color_0();
            else
                v847.unset_callback = not v847.console_is_visible(v847.engine_client);
            end;
        else
            for _, v855 in l_pairs_0(v847.materials) do
                l_get_materials_0(v855)[1]:reset();
            end;
        end;
    end, 
    dormant_utils = {
        data = {
            round_started = 0, 
            miss_info = {}, 
            shot_info = {}
        }
    }, 
    auto_stop = function(_, v857, v858)
        -- upvalues: l_sqrt_0 (ref)
        local v859 = l_sqrt_0(v857.forwardmove * v857.forwardmove + v857.sidemove * v857.sidemove);
        if v858 <= 0 or v859 <= 0 then
            return;
        else
            if v857.in_duck then
                v858 = v858 * 2.94117647;
            end;
            if v859 <= v858 then
                return;
            else
                local v860 = v858 / v859;
                v857.forwardmove = v857.forwardmove * v860;
                v857.sidemove = v857.sidemove * v860;
                return;
            end;
        end;
    end, 
    dormant_aimbot_run = function(v861, v862, v863)
        -- upvalues: v164 (ref), l_get_local_player_0 (ref), l_get_players_0 (ref), l_vector_0 (ref), l_random_0 (ref), l_max_0 (ref), l_trace_bullet_0 (ref)
        if not v863.menu.miscellaneous.dormant_aim:get() then
            v164.dormant_aim:override();
            return;
        else
            v164.dormant_aim:override(false);
            local v864 = l_get_local_player_0();
            local v865 = v864:get_eye_position();
            if not v864 or not v864:is_alive() then
                return;
            else
                l_get_players_0(true, true, function(v866)
                    -- upvalues: v861 (ref), v864 (ref), l_vector_0 (ref), l_random_0 (ref), v164 (ref), l_max_0 (ref), l_trace_bullet_0 (ref), v865 (ref), v862 (ref)
                    if not v866:is_dormant() or not v866:is_alive() then
                        v861.dormant_utils.data.miss_info[v866:get_index()] = nil;
                        return;
                    else
                        if v866:is_alive() and v866.m_iHealth > 0 then
                            local v867 = v866:get_origin();
                            local v868 = v864:get_player_weapon();
                            if not v868 then
                                return;
                            else
                                local v869 = v868:get_inaccuracy();
                                if v869 == nil then
                                    return;
                                else
                                    local v870 = v868:get_weapon_info();
                                    if v870 == nil then
                                        return;
                                    else
                                        local v871 = v868:get_weapon_index();
                                        local l_weapon_type_0 = v870.weapon_type;
                                        if l_weapon_type_0 == 0 or l_weapon_type_0 == 9 or v868:get_weapon_reload() ~= -1 or v871 == 31 then
                                            return;
                                        elseif v867:length2d() > v870.range then
                                            return;
                                        else
                                            if v861.dormant_utils.data.miss_info[v866:get_index()] == nil then
                                                v861.dormant_utils.data.miss_info[v866:get_index()] = {
                                                    missed = 0, 
                                                    health = v866.m_iHealth, 
                                                    last_origin = v867:floor(), 
                                                    new_shot_pos = v866:get_hitbox_position(0) + l_vector_0(0, 0, l_random_0(-3, 0))
                                                };
                                            end;
                                            if v867:floor() ~= v861.dormant_utils.data.miss_info[v866:get_index()].last_origin then
                                                v861.dormant_utils.data.miss_info[v866:get_index()].missed = 0;
                                                v861.dormant_utils.data.miss_info[v866:get_index()].last_origin = v867:floor();
                                                v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos = v866:get_hitbox_position(0) + l_vector_0(0, 0, l_random_0(-3, 0));
                                            end;
                                            if not v164.dormant_aim:get() then
                                                return;
                                            else
                                                local l_tickcount_1 = globals.tickcount;
                                                local v874 = v864.m_flSimulationTime - 0.04;
                                                if l_tickcount_1 < v861.dormant_utils.data.round_started then
                                                    return;
                                                else
                                                    local v875 = nil;
                                                    local v876 = v164.hide_shots:get() and 0.2 or 0;
                                                    if v871 == 64 then
                                                        v875 = v868.m_flNextPrimaryAttack + v876 < v874;
                                                    else
                                                        v875 = (not (l_weapon_type_0 == 1 and not v871 == 64) or not (not v871 == 1)) and l_max_0(v864.m_flNextAttack + v876, v868.m_flNextPrimaryAttack + v876, v868.m_flNextSecondaryAttack) < v874;
                                                    end;
                                                    if not v875 then
                                                        return;
                                                    else
                                                        local v877 = v871 == 9;
                                                        local v878 = v871 == 40;
                                                        if (v877 and 3 or (v878 or v871 == 64) and 3 or 5) <= v861.dormant_utils.data.miss_info[v866:get_index()].missed then
                                                            return;
                                                        else
                                                            local v879 = l_trace_bullet_0(v864, v865, v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos);
                                                            local l_health_0 = v861.dormant_utils.data.miss_info[v866:get_index()].health;
                                                            if l_health_0 and l_health_0 <= v879 and v879 > 0 then
                                                                v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos = v867 + l_vector_0(0, 0, 40 + l_random_0(-8, -4));
                                                            elseif v879 > 0 and v861.dormant_utils.data.miss_info[v866:get_index()].missed == 0 then
                                                                v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos = v866:get_hitbox_position(0) + (v861.dormant_utils.data.miss_info[v866:get_index()].missed >= 1 and l_vector_0(0, 0, l_random_0(-14, 0)) or l_vector_0());
                                                            end;
                                                            if not (v164.min_damage:get() <= v879 and not v866:is_visible() and v879 > 0) then
                                                                return;
                                                            else
                                                                local v881 = v865:to(v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos):angles();
                                                                if not v864.m_bIsScoped and l_weapon_type_0 == 5 and not v862.in_jump then
                                                                    v862.in_attack2 = true;
                                                                end;
                                                                v861:auto_stop(v862, (v864.m_bIsScoped and v870.max_player_speed_alt or v870.max_player_speed) * 0.33);
                                                                if v869 < 0.03 then
                                                                    if not v164.fake_duck:get() or v862.choked_commands ~= 0 then

                                                                    end;
                                                                    v862.view_angles = v881;
                                                                    v862.in_attack = true;
                                                                    if not v861.dormant_utils.data.shot_info[v866:get_index()] or not v861.dormant_utils.data.shot_info[v866:get_index()].hurted then
                                                                        v861.dormant_utils.data.miss_info[v866:get_index()].missed = v861.dormant_utils.data.miss_info[v866:get_index()].missed + 1;
                                                                        if v861.dormant_utils.data.miss_info[v866:get_index()].missed >= 1 then
                                                                            v861.dormant_utils.data.miss_info[v866:get_index()].new_shot_pos = v867 + l_vector_0(0, 0, 40 + l_random_0(-8, -4));
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
                            end;
                        end;
                        return;
                    end;
                end);
                return;
            end;
        end;
    end, 
    get_bbox = function(_, v883, v884)
        -- upvalues: l_vector_0 (ref), l_world_to_screen_0 (ref), l_floor_0 (ref)
        local l_m_vecMins_0 = v883.m_vecMins;
        local l_m_vecMaxs_0 = v883.m_vecMaxs;
        local v887 = v884 + l_m_vecMins_0;
        local v888 = v884 + l_m_vecMaxs_0;
        local v889 = {
            l_vector_0(v887.x, v887.y, v887.z), 
            l_vector_0(v887.x, v888.y, v887.z), 
            l_vector_0(v888.x, v888.y, v887.z), 
            l_vector_0(v888.x, v887.y, v887.z), 
            l_vector_0(v888.x, v888.y, v888.z), 
            l_vector_0(v887.x, v888.y, v888.z), 
            l_vector_0(v887.x, v887.y, v888.z), 
            l_vector_0(v888.x, v887.y, v888.z)
        };
        local v890 = l_world_to_screen_0(v889[4]) or l_vector_0(0, 0);
        local v891 = l_world_to_screen_0(v889[6]) or l_vector_0(0, 0);
        local v892 = l_world_to_screen_0(v889[1]) or l_vector_0(0, 0);
        local v893 = l_world_to_screen_0(v889[5]) or l_vector_0(0, 0);
        local v894 = l_world_to_screen_0(v889[3]) or l_vector_0(0, 0);
        local v895 = l_world_to_screen_0(v889[2]) or l_vector_0(0, 0);
        local v896 = l_world_to_screen_0(v889[7]) or l_vector_0(0, 0);
        local v897 = l_world_to_screen_0(v889[8]) or l_vector_0(0, 0);
        if not v890 and not v891 and not v892 and not v893 and not v894 and not v895 and not v896 and not v897 then
            return false;
        else
            local v898 = {
                [1] = v890, 
                [2] = v891, 
                [3] = v892, 
                [4] = v893, 
                [5] = v894, 
                [6] = v895, 
                [7] = v896, 
                [8] = v897
            };
            local l_x_4 = v890.x;
            local l_y_5 = v890.y;
            local l_x_5 = v890.x;
            local l_y_6 = v890.y;
            for v903 = 1, 8 do
                if v898[v903].x < l_x_4 then
                    l_x_4 = v898[v903].x;
                end;
                if l_y_5 < v898[v903].y then
                    l_y_5 = v898[v903].y;
                end;
                if l_x_5 < v898[v903].x then
                    l_x_5 = v898[v903].x;
                end;
                if v898[v903].y < l_y_6 then
                    l_y_6 = v898[v903].y;
                end;
            end;
            return {
                w = 0, 
                x = 0, 
                y = 0, 
                h = 0, 
                x = l_floor_0(l_x_4), 
                y = l_floor_0(l_y_6), 
                w = l_floor_0(l_x_5 - l_x_4), 
                h = l_floor_0(l_y_5 - l_y_6)
            };
        end;
    end, 
    dormant_aimbot_paint = function(v904, v905)
        -- upvalues: l_get_players_0 (ref), l_vector_0 (ref), l_screen_size_0 (ref), l_rect_outline_0 (ref), l_text_0 (ref), l_color_0 (ref)
        if not v905.menu.miscellaneous.dormant_aim:get() then
            return;
        else
            l_get_players_0(true, true, function(v906)
                -- upvalues: v904 (ref), l_vector_0 (ref), l_screen_size_0 (ref), v905 (ref), l_rect_outline_0 (ref), l_text_0 (ref), l_color_0 (ref)
                if not v906:is_dormant() then
                    return;
                else
                    if v904.dormant_utils.data.miss_info[v906:get_index()] ~= nil and v904.dormant_utils.data.miss_info[v906:get_index()].new_shot_pos and v904.dormant_utils.data.miss_info[v906:get_index()].new_shot_pos:to_screen() then
                        local v907 = v904:get_bbox(v906, v904.dormant_utils.data.miss_info[v906:get_index()].last_origin);
                        local v908 = {
                            [1] = v906:get_bbox().pos1 or l_vector_0(v907.x, v907.y + 3), 
                            [2] = v906:get_bbox().pos2 or l_vector_0(v907.x + v907.w, v907.y + 1 + v907.h)
                        };
                        if not v908[1] or v908[1].x < 0 or v908[1].x > l_screen_size_0().x or v908[1].y < 0 or v908[1].y > l_screen_size_0().y then
                            return;
                        elseif not v908[2] or v908[2].x < 0 or v908[2].x > l_screen_size_0().x or v908[2].y < 0 or v908[2].y > l_screen_size_0().y then
                            return;
                        else
                            local v909 = v905.menu.miscellaneous.dormant_aim_color:get();
                            l_rect_outline_0(v908[1], v908[2], v909);
                            if not v906:get_bbox().pos1 then
                                l_text_0(1, l_vector_0(v907.x + v907.w * 0.5, v907.y - 4), l_color_0(200, v909.a), "c", v906:get_name());
                                l_text_0(1, l_vector_0(v907.x - 2, v907.y + 1), l_color_0(200, v909.a), "r", v906.m_iHealth);
                            end;
                        end;
                    end;
                    return;
                end;
            end);
            return;
        end;
    end, 
    dormant_aimbot_reset = function(v910, _, v912)
        if not v912.menu.miscellaneous.dormant_aim:get() then
            return;
        else
            local v913 = (cvar.mp_freezetime:float() + 1) / globals.tickinterval;
            v910.dormant_utils.data.round_started = globals.tickcount + v913;
            v910.dormant_utils.data.miss_info = {};
            return;
        end;
    end, 
    dormant_aimbot_fire = function(v914, v915, v916)
        -- upvalues: l_get_0 (ref), l_get_local_player_0 (ref)
        if not v916.menu.miscellaneous.dormant_aim:get() then
            return;
        else
            if l_get_0(v915.userid, true) == l_get_local_player_0() then
                v914.dormant_utils.data.shot_info = {};
            end;
            return;
        end;
    end, 
    dormant_aimbot_death = function(v917, v918, v919)
        -- upvalues: l_get_0 (ref)
        if not v919.menu.miscellaneous.dormant_aim:get() then
            return;
        else
            local v920 = l_get_0(v918.userid, true);
            if v917.dormant_utils.data.shot_info[v920:get_index()] == nil then
                v917.dormant_utils.data.shot_info[v920:get_index()] = {};
            end;
            if v917.dormant_utils.data.miss_info[v920:get_index()] then
                v917.dormant_utils.data.miss_info[v920:get_index()].missed = 0;
                v917.dormant_utils.data.miss_info[v920:get_index()].health = 0;
            end;
            v917.dormant_utils.data.shot_info[v920:get_index()].hurted = true;
            return;
        end;
    end, 
    dormant_aimbot_hurt = function(v921, v922, v923)
        -- upvalues: l_get_0 (ref), l_get_local_player_0 (ref), l_max_0 (ref)
        if not v923.menu.miscellaneous.dormant_aim:get() then
            return;
        else
            local v924 = l_get_0(v922.attacker, true);
            local v925 = l_get_0(v922.userid, true);
            if v924 == l_get_local_player_0() then
                if v921.dormant_utils.data.shot_info[v925:get_index()] == nil then
                    v921.dormant_utils.data.shot_info[v925:get_index()] = {};
                end;
                if v921.dormant_utils.data.miss_info[v925:get_index()] then
                    local l_health_1 = v921.dormant_utils.data.miss_info[v925:get_index()].health;
                    v921.dormant_utils.data.miss_info[v925:get_index()].health = l_max_0(0, l_health_1 - v922.dmg_health);
                    if v921.dormant_utils.data.miss_info[v925:get_index()].health == 0 and v925:is_alive() then
                        v921.dormant_utils.data.miss_info[v925:get_index()].health = 100;
                    elseif not v925:is_alive() then
                        v921.dormant_utils.data.miss_info[v925:get_index()].health = 0;
                    end;
                end;
                v921.dormant_utils.data.shot_info[v925:get_index()].hurted = true;
            end;
            return;
        end;
    end, 
    trashtalk_list = {}, 
    trashtalk_type = {
        ASSIST = 2, 
        KILL = 1, 
        KILLERS_DEATH = 4, 
        SELF_DEATH = 3
    }, 
    add_in_kill_queue = function(v927, v928, v929)
        -- upvalues: l_get_local_player_0 (ref), l_get_game_rules_0 (ref), l_get_0 (ref), l_random_0 (ref), l_insert_0 (ref)
        local v930 = l_get_local_player_0();
        if not v930 or not v929.menu.miscellaneous.trashtalk:get() or l_get_game_rules_0().m_bWarmupPeriod then
            return;
        else
            local v931 = l_get_0(v928.userid, true);
            local v932 = l_get_0(v928.attacker, true);
            local v933 = l_get_0(v928.assister, true);
            if v931 == v932 then
                return;
            else
                if v931 == v930 then
                    v927.last_killer = v932;
                end;
                if l_random_0(1, 5) == 1 then
                    return;
                else
                    if v929.menu.miscellaneous.talk_on:get("Kill") and v932 == v930 then
                        l_insert_0(v927.trashtalk_list, {
                            real_time = globals.realtime, 
                            type = v927.trashtalk_type.KILL
                        });
                    end;
                    if v929.menu.miscellaneous.talk_on:get("Assist") and v933 == v930 and v930:is_alive() then
                        l_insert_0(v927.trashtalk_list, {
                            real_time = globals.realtime, 
                            type = v927.trashtalk_type.ASSIST
                        });
                    end;
                    if v929.menu.miscellaneous.talk_on:get("Self Death") and v931 == v930 then
                        l_insert_0(v927.trashtalk_list, {
                            real_time = globals.realtime, 
                            type = v927.trashtalk_type.SELF_DEATH
                        });
                    end;
                    if v929.menu.miscellaneous.talk_on:get("Killers Death") and v931 == v927.last_killer then
                        l_insert_0(v927.trashtalk_list, {
                            real_time = globals.realtime, 
                            type = v927.trashtalk_type.KILLERS_DEATH
                        });
                        v927.last_killer = nil;
                    end;
                    return;
                end;
            end;
        end;
    end, 
    data_base = {
        [1] = {
            [1] = {
                [1] = "1"
            }, 
            [2] = {
                [1] = "\208\178 \209\129\208\190\208\189", 
                [2] = "\209\133\209\131\208\181\209\129\208\190\209\129"
            }, 
            [3] = {
                [1] = "1", 
                [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [4] = {
                [1] = "\208\189\208\176\209\133\209\131\208\185 \209\129 \208\191\208\187\209\143\208\182\208\176", 
                [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [5] = {
                [1] = "\208\159\208\151\208\165\208\170\208\144\208\151\208\170\208\144\208\159\208\165\208\151\208\144\208\159\208\165\208\170", 
                [2] = "1 \208\180\208\190\208\187\208\177\208\176\208\181\208\177"
            }, 
            [6] = {
                [1] = "1", 
                [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
                [3] = "\208\191\208\184\208\180\208\190\209\128\208\176", 
                [4] = "\209\129"
            }, 
            [7] = {
                [1] = "\208\151\208\165\208\159\208\170\208\151\208\165\208\170\208\144\208\159\208\170\208\165\208\159\208\144", 
                [2] = "\208\162\208\171 \208\167\208\149 \208\161\208\158\208\146\208\161\208\149\208\156 \208\148\208\158\208\155\208\145\208\144\208\149\208\145?"
            }, 
            [8] = {
                [1] = "\209\129\208\191\208\176\209\130\209\140", 
                [2] = "\209\129\209\139\208\189 \208\177\208\187\209\143\208\180\208\184"
            }, 
            [9] = {
                [1] = "1."
            }, 
            [10] = {
                [1] = "\208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\185\209\129\209\143", 
                [2] = "\208\188\208\189\208\181", 
                [3] = "\208\178 \209\133\209\131\208\185", 
                [4] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [11] = {
                [1] = "1", 
                [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187", 
                [3] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184"
            }, 
            [12] = {
                [1] = "cya@yt", 
                [2] = "\209\129\209\139\208\189 \209\136\208\176\208\187\208\176\208\178\209\139"
            }, 
            [13] = {
                [1] = "iq?"
            }, 
            [14] = {
                [1] = "\208\183\209\133\209\138\208\191\208\176\208\178\208\183\209\138\209\133\208\191\208\178\208\176\208\183\209\138\209\133", 
                [2] = "\208\189\208\176\208\185\209\129 \208\176\208\176", 
                [3] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [15] = {
                [1] = "1", 
                [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
                [3] = "\208\183\208\176\209\130\209\131\208\191\208\190\208\186"
            }, 
            [16] = {
                [1] = "\208\186\208\176\208\186\208\190\208\185", 
                [2] = "\208\182\208\181", 
                [3] = "\209\130\209\139", 
                [4] = "\209\130\209\131\208\191\208\190\208\185"
            }
        }, 
        [2] = {
            [1] = {
                [1] = "\209\131\208\181\208\177\208\184\209\137\208\181", 
                [2] = "\208\189\208\176\209\133\209\131\208\185 \209\130\209\139 \208\186\208\184\208\187\208\187 \209\129\208\191\208\184\208\183\208\180\208\184\208\187?"
            }, 
            [2] = {
                [1] = "\208\189\208\181 \208\191\208\184\208\183\208\180\208\184 \208\186\208\184\208\187\208\187\209\139 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [3] = {
                [1] = "\208\191\208\190\208\180\209\129\208\190\209\129 \208\181\208\177\209\131\209\135\208\184\208\185"
            }, 
            [4] = {
                [1] = "\208\189\209\131 \208\189\208\176\209\133\209\131\209\143 \208\180\208\190\208\187\208\177\208\190\208\181\208\177"
            }, 
            [5] = {
                [1] = "\209\143 \208\177\209\139 \209\131\208\177\208\184\208\187 \208\180\208\176\209\131\208\189 \209\130\209\131\208\191\208\190\208\185"
            }, 
            [6] = {
                [1] = "\209\129\209\139\208\189 \208\181\208\177\209\131\209\135\208\181\208\185 \209\136\208\187\209\142\209\133\208\184 \209\141\209\130\208\190 \208\188\208\190\208\185 \208\186\208\184\208\187\208\187 \208\177\209\139\208\187"
            }
        }, 
        [3] = {
            [1] = {
                [1] = "\208\151\208\159\208\165\208\170\208\144\208\151\208\165\208\170\208\144\208\159\208\151\208\159\208\165\208\170\208\144", 
                [2] = "\209\130\209\131\208\191\208\190\208\185", 
                [3] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [2] = {
                [1] = "\209\131\208\181\208\177\208\184\209\137\208\181", 
                [2] = "\208\186\208\176\208\186 \209\130\209\139 \208\188\208\181\208\189\209\143 \209\131\208\177\208\184\208\187"
            }, 
            [3] = {
                [1] = "\208\189\209\131 \208\181\208\177\208\176\208\189\209\139\208\185 \209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
                [2] = "\208\186\208\176\208\186 \209\130\209\139 \208\188\208\181\208\189\209\143 \208\186\209\131\208\188\208\176\209\128\208\184\209\136\209\140"
            }, 
            [4] = {
                [1] = "\208\151\208\146\208\170\208\165\208\144\208\170\208\151\208\146\208\165\208\144\208\159\208\144\208\159\208\151\208\170", 
                [2] = "\209\135\208\181 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187"
            }, 
            [5] = {
                [1] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
                [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187"
            }, 
            [6] = {
                [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185", 
                [2] = "\209\130\209\139 \208\188\209\131\208\178\208\176\209\130\209\140\209\129\209\143 \208\182\208\181 \208\189\208\181 \209\131\208\188\208\181\208\181\209\136\209\140"
            }, 
            [7] = {
                [1] = "\208\180\208\190\208\187\208\177\208\176\208\181\208\177", 
                [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187"
            }, 
            [8] = {
                [1] = "\208\177\208\176\209\130\209\140\208\186\208\176 \209\130\208\178\208\190\208\181\208\179\208\190 \208\189\208\190\208\179\208\176\208\188\208\184 \208\191\208\184\208\189\208\176\208\187"
            }, 
            [9] = {
                [1] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
                [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129", 
                [3] = "\209\135\208\181 \209\130\209\139 \208\180\208\181\208\187\208\176\208\181\209\136\209\140"
            }, 
            [10] = {
                [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\133\209\131\208\181\208\178\209\139\208\185", 
                [2] = "\209\129\209\139\208\189 \208\181\208\177\208\176\208\189\208\189\208\190\208\185 \208\177\208\187\209\143\208\180\208\184"
            }, 
            [11] = {
                [1] = "\208\188\208\176\209\131\209\133\209\131 \209\130\208\178\208\190\209\142 \208\191\208\184\208\189\208\176\208\187 \208\189\208\190\208\179\208\176\208\188\208\184"
            }, 
            [12] = {
                [1] = "\208\189\209\131 \209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
                [2] = "\209\143 \208\178\209\129\209\142 \209\130\208\178\208\190\209\142 \209\129\208\181\208\188\209\140\209\142 \208\191\208\181\209\128\208\181\209\128\208\181\208\183\208\176\208\187"
            }, 
            [13] = {
                [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185", 
                [2] = "\208\180\208\190\208\187\208\177\208\176\208\181\208\177"
            }, 
            [14] = {
                [1] = "\209\129\209\139\208\189 \209\130\208\178\208\176\209\128\208\184 \209\130\209\131\208\191\208\190\208\185", 
                [2] = "\208\186\208\176\208\186 \208\182\208\181 \209\130\209\139 \208\188\208\181\208\189\209\143 \208\183\208\176\208\181\208\177\208\176\208\187"
            }, 
            [15] = {
                [1] = "\209\130\208\176\208\186\208\190\208\185", 
                [2] = "\209\130\208\190", 
                [3] = "\208\177\208\187\209\143\208\180\209\140", 
                [4] = "\209\131\208\177\209\140\208\181\209\130"
            }, 
            [16] = {
                [1] = "\208\189\209\131 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\183\208\176\209\130\209\131\208\191\208\190\208\186", 
                [2] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185"
            }
        }, 
        [4] = {
            [1] = {
                [1] = "1"
            }, 
            [2] = {
                [1] = "\209\129\208\191\208\176\209\130\209\140 \208\189\208\176\209\133\209\131\208\185"
            }, 
            [3] = {
                [1] = "1", 
                [2] = "\209\129\209\139\208\189 \208\181\208\177\208\176\208\189\208\189\208\190\208\185 \208\177\208\187\209\143\208\180\208\184"
            }, 
            [4] = {
                [1] = "\209\129\208\191\208\184 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [5] = {
                [1] = "1", 
                [2] = "\209\129\209\139\208\189 \209\130\208\178\208\176\209\128\208\184"
            }, 
            [6] = {
                [1] = "1", 
                [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\183\208\176\209\130\209\131\208\191\208\190\208\186"
            }, 
            [7] = {
                [1] = "\208\191\208\190\208\186\208\176\208\183\208\176\208\187 \208\188\208\190\208\183\208\179", 
                [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
            }, 
            [8] = {
                [1] = "\208\191\208\190 \208\191\209\128\208\184\208\186\208\176\208\183\209\131", 
                [2] = "\209\131\208\188\208\181\209\128 \208\180\208\190\208\187\208\177\208\190\208\181\208\177"
            }
        }
    }, 
    current_phase = {
        [1] = {
            [1] = 0, 
            [2] = 0
        }, 
        [2] = {
            [1] = 0, 
            [2] = 0
        }, 
        [3] = {
            [1] = 0, 
            [2] = 0
        }, 
        [4] = {
            [1] = 0, 
            [2] = 0
        }
    }, 
    control_queue = function(v934, v935)
        -- upvalues: l_get_game_rules_0 (ref), l_random_0 (ref), l_min_0 (ref), l_get_unixtime_0 (ref), l_console_exec_0 (ref), l_max_0 (ref)
        if not v935.menu.miscellaneous.trashtalk:get() or #v935.menu.miscellaneous.talk_on:get() == 0 or #v934.trashtalk_list == 0 or l_get_game_rules_0().m_bWarmupPeriod then
            return;
        else
            local l_realtime_1 = globals.realtime;
            local v937 = v934.trashtalk_list[1];
            if v937.real_time == l_realtime_1 then
                return;
            else
                if not v937.delay_data then
                    v934.current_phase[v937.type][1] = v934.current_phase[v937.type][1] + 1;
                    if v934.current_phase[v937.type][1] > #v934.data_base[v937.type] then
                        v934.current_phase[v937.type][1] = 1;
                    end;
                    v937.delay_data = {
                        counter = 1, 
                        time = l_random_0(1.5, 4), 
                        step_time = l_random_0(1.5, 2), 
                        last_id = {}, 
                        current_target = v934.data_base[v937.type][v934.current_phase[v937.type][1]], 
                        max_counter = l_min_0(#v934.data_base[v937.type][v934.current_phase[v937.type][1]], #v934.data_base[v937.type])
                    };
                end;
                if l_realtime_1 % v937.real_time > (v937.delay_data.counter == 1 and v937.delay_data.time or v937.delay_data.step_time) then
                    v934.current_phase[v937.type][2] = v934.current_phase[v937.type][2] + 1;
                    if v934.current_phase[v937.type][2] > #v937.delay_data.current_target then
                        v934.current_phase[v937.type][2] = 1;
                    end;
                    local v938 = v934.current_phase[v937.type][2];
                    while v937.delay_data.last_id[v938] do
                        math_randomseed(l_get_unixtime_0());
                        v938 = l_random_0(1, #v937.delay_data.current_target);
                    end;
                    l_console_exec_0(("%s \243\160\131\144\243\160\131\144%s"):format(v937.type == v934.trashtalk_type.ASSIST and "say_team" or "say", v937.delay_data.current_target[v938]));
                    v937.delay_data.last_id[v938] = true;
                    v937.real_time = l_realtime_1;
                    v937.delay_data.time = l_max_0(#v937.delay_data.current_target[l_min_0(v938 + 1, #v937.delay_data.current_target)] * 0.1, 0.7);
                    v937.delay_data.step_time = l_max_0(#v937.delay_data.current_target[l_min_0(v938 + 1, #v937.delay_data.current_target)] * 0.1, 0.7);
                    v937.delay_data.counter = v937.delay_data.counter + 1;
                    if v937.delay_data.counter > v937.delay_data.max_counter then
                        v934.current_phase[v937.type][2] = 0;
                        v934.trashtalk_list = {};
                    end;
                end;
                return;
            end;
        end;
    end, 
    animate_configs = function(v939, v940)
        -- upvalues: l_color_0 (ref)
        if #v940.menu.config_list.name == 0 then
            local v941 = ("\a%sThere is no Configurations."):format(v939:animate("cfg_alpha", globals.realtime % 2 >= 0.9 and l_color_0(255, 255) or l_color_0(255, 10), globals.frametime * 3):to_hex());
            v940.menu.general.local_configs:update(v941);
        end;
    end, 
    js = panorama.GameStateAPI, 
    unmute_players = function(v942, v943)
        -- upvalues: l_get_players_0 (ref), l_pairs_0 (ref)
        local v944 = l_get_players_0();
        if v944 and v943.menu.miscellaneous.players_mute:get() then
            for _, v946 in l_pairs_0(v944) do
                local v947 = v942.js.GetPlayerXuidStringFromEntIndex(v946:get_index());
                if v942.js.IsSelectedPlayerMuted(v947) and v943.menu.miscellaneous.players_mute_type:get() == "Unmute" or not v942.js.IsSelectedPlayerMuted(v947) and v943.menu.miscellaneous.players_mute_type:get() == "Mute" then
                    v942.js.ToggleMute(v947);
                end;
            end;
        end;
    end, 
    custom_hitchance = function(_, v949, v950)
        -- upvalues: v164 (ref), l_get_local_player_0 (ref)
        v164.hit_chance:override();
        local v951 = l_get_local_player_0();
        if not v951 or not v950.menu.miscellaneous.custom_hitchance:get() then
            return;
        else
            local v952 = v949 == "Jumping" or v949 == "Air Crouch";
            local v953 = "";
            local v954 = v951:get_player_weapon();
            if not v954 then
                return;
            else
                local v955 = v954:get_weapon_info();
                if not v955 then
                    return;
                else
                    v953 = v955.console_name:gsub("weapon_", ""):gsub("item_", "");
                    if v955.is_revolver then
                        v953 = "r8";
                    elseif v953 == "scar20" or v953 == "g3sg1" then
                        v953 = "auto";
                    end;
                    if v950.menu.miscellaneous["ch_mode_" .. v953] then
                        if v950.menu.miscellaneous["ch_mode_" .. v953]:get("No Scope") and not v951.m_bIsScoped then
                            v164.hit_chance:override(v950.menu.miscellaneous["ch_no_scope_" .. v953]:get());
                        end;
                        if v950.menu.miscellaneous["ch_mode_" .. v953]:get("In Air") and v952 then
                            v164.hit_chance:override(v950.menu.miscellaneous["ch_in_air_" .. v953]:get());
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end, 
    get_role = function(v956)
        -- upvalues: v125 (ref), v183 (ref), l_get_username_0 (ref), v126 (ref), l_get_style_0 (ref), l_console_exec_0 (ref)
        v125.get(("https://api.chernobyl.store/celestia/%s/%s"):format(v183:lower() == "code" and "stable" or "alpha", l_get_username_0()), {
            user_agent_info = "Windows;chernobyl"
        }, function(v957, v958)
            -- upvalues: v126 (ref), v956 (ref), l_get_style_0 (ref), l_console_exec_0 (ref)
            if v957 and v958.status == 200 then
                local v959 = ("^role %s"):format(v958.body);
                v126.set(v959);
                v956:log_push(l_get_style_0("Link Active"), ("The key is copied to the clipboard: \a%s%s"):format(l_get_style_0("Link Active"):to_hex(), v959));
                l_console_exec_0("play ui/beepclear");
            end;
        end);
    end
});
local function v962(v961)
    -- upvalues: l_type_0 (ref), l_getmetatable_0 (ref)
    if l_type_0(l_getmetatable_0(v961)) == "table" and v961.__type then
        return v961.__type.name:lower();
    else
        if l_type_0(v961) == "boolean" then
            v961 = v961 and 1 or 0;
        end;
        return l_type_0(v961);
    end;
end;
local v963 = nil;
v963 = l_get_icon_0;
l_get_icon_0 = function(v964, v965, v966)
    -- upvalues: v963 (ref)
    return v965 and v963(v964) or v966 == nil and ("\a{Link Active}%s\aDEFAULT"):format(v963(v964)) or ("\a%s%s\aDEFAULT"):format(v966:to_hex(), v963(v964));
end;
local v967 = db.celest1a or {};
local v1142 = new_class():struct("menu")({
    build_date = "12.05.2024", 
    style_color = "\a{Link Active}", 
    icons = {
        skeet_ind = "\a{Link Active}GS\aDEFAULT ", 
        arrow_right = l_get_icon_0("angle-right", true), 
        discord = l_get_icon_0("discord"), 
        export = l_get_icon_0("file-arrow-up"), 
        import = l_get_icon_0("file-arrow-down"), 
        delete = l_get_icon_0("trash"), 
        save = l_get_icon_0("floppy-disk"), 
        manuals = l_get_icon_0("arrows-left-right-to-line") .. " ", 
        tweaks = l_get_icon_0("wand-magic-sparkles") .. " ", 
        animbreakers = l_get_icon_0("dice-d6") .. " ", 
        disable_aa = l_get_icon_0("eye-slash") .. " ", 
        defensive_options = l_get_icon_0("hammer-crash") .. " ", 
        safe_head = l_get_icon_0("life-ring") .. " ", 
        presets = l_get_icon_0("ear-muffs"), 
        preset1 = l_get_icon_0("bolt") .. " ", 
        preset2 = l_get_icon_0("bolt") .. " ", 
        preset3 = l_get_icon_0("bolt") .. " ", 
        conditions = l_get_icon_0("bars") .. " ", 
        override = l_get_icon_0("sliders") .. " ", 
        viewmodel = l_get_icon_0("hand-sparkles") .. " ", 
        aspect_ratio = l_get_icon_0("camera-viewfinder") .. " ", 
        cross_ind = l_get_icon_0("bullseye-arrow") .. " ", 
        event_logs = l_get_icon_0("rectangle-history") .. " ", 
        dmg_marker = l_get_icon_0("hundred-points") .. " ", 
        scope_overlay = l_get_icon_0("crosshairs-simple") .. " ", 
        windows = l_get_icon_0("browsers") .. " ", 
        grenade_radius = l_get_icon_0("street-view") .. " ", 
        grenade_modulation = l_get_icon_0("circle-exclamation") .. " ", 
        no_fall_dmg = l_get_icon_0("person-falling-burst") .. " ", 
        fast_ladder = l_get_icon_0("person-arrow-down-to-line") .. " ", 
        avoid_col = l_get_icon_0("person-circle-check") .. " ", 
        clantag = l_get_icon_0("tag") .. " ", 
        console_mod = l_get_icon_0("rectangle-terminal") .. " ", 
        air_exploit = l_get_icon_0("triangle-exclamation") .. " ", 
        ragdoll_anim = l_get_icon_0("person-falling") .. " ", 
        dormant_aim = l_get_icon_0("square-bolt") .. " ", 
        trashtalk = l_get_icon_0("trash-can-clock") .. " ", 
        players_mute = l_get_icon_0("volume-xmark") .. " ", 
        custom_hc = l_get_icon_0("dice-six") .. " ", 
        super_toss = l_get_icon_0("bolt") .. " ", 
        grenade_release = l_get_icon_0("bomb") .. " ", 
        themes1 = l_get_icon_0("sun", nil, l_color_0(134, 187, 224, 159)), 
        themes2 = l_get_icon_0("moon", nil, l_color_0(89, 83, 129))
    }, 
    username = l_get_username_0(), 
    builder = {
        states = {
            [1] = "Standing", 
            [2] = "Walking", 
            [3] = "Slow Walk", 
            [4] = "Jumping", 
            [5] = "Air Crouch", 
            [6] = "Crouching"
        }
    }, 
    screen_size = l_screen_size_0(), 
    show_more = {
        [1] = false, 
        [2] = false
    }, 
    load_menu = function(v968)
        -- upvalues: l_create_0 (ref), l_pairs_0 (ref), l_type_0 (ref), l_get_username_0 (ref), l_get_style_0 (ref), l_color_0 (ref), l_find_0 (ref), v960 (ref)
        local v969 = l_create_0("CELESTIA", "select");
        local v970 = l_create_0("CELESTIA", "configs");
        local v971 = l_create_0("CELESTIA", "\000");
        local v972 = {
            config_selected = v969:list("", {
                [1] = v968.icons.arrow_right .. "  Home", 
                [2] = v968.icons.arrow_right .. "  Anti Aim", 
                [3] = v968.icons.arrow_right .. "  Visuals", 
                [4] = v968.icons.arrow_right .. "  Misc"
            }), 
            key = v971:label("   Join in us \a{Link Active}discord\aDEFAULT "), 
            discord = v971:button(("   %s  Discord Server    "):format(v968.icons.discord), function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/rdGtrsRYVK");
            end, true), 
            configs = v971:label("\a{Small Text}Themes"), 
            theme1 = v971:button(v968.icons.themes1, function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/getitem?c=uLFdopWrT5dhKkqt-u2tdrxzE2N");
            end, true), 
            theme2 = v971:button(v968.icons.themes2, function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/getitem?c=kpDqGp3pPaqJo7Mm-_bPtjlCxZY");
            end, true), 
            local_configs = v970:list(" \n", {
                [1] = "There is no Configurations."
            }), 
            config_name = v970:input(""), 
            skip = v970:selectable("Skip Data:", {
                [1] = "Anti Aim", 
                [2] = "Visuals", 
                [3] = "Misc", 
                [4] = "View"
            })
        };
        v972.save = v970:button((" %s "):format(v968.icons.save), function()
            -- upvalues: v968 (ref), v972 (ref)
            return v968:create_config(v972.config_name:get());
        end, true);
        v972.save:tooltip("Save");
        v972.load_config = v970:button("                   Load Config                   ", function()
            -- upvalues: v968 (ref), v972 (ref)
            return v968:load_config(v972.config_name:get());
        end, true);
        v972.delete = v970:button((" %s "):format(v968.icons.delete), function()
            -- upvalues: v968 (ref), v972 (ref)
            return v968:delete_config(v972.config_name:get());
        end, true);
        v972.delete:tooltip("Delete");
        v972.export = v970:button((" %s "):format(v968.icons.export), function()
            -- upvalues: v968 (ref)
            return v968:export_data();
        end, true);
        v972.export:tooltip("Export");
        v972.default_config = v970:button("                 Default Config                ", function()
            -- upvalues: v968 (ref)
            v968:import_data("celestia_eyJBZGQgcGhhc2UgYRMELo0YNztqNodOvRMELFg7LW0EfHKp5B0YMH34cOhqNWl7lRVkcotlwOeNhF38xsd95F3XNog75WhgL1tgMWMOvshqcWt4cOhq613IJ13XJF3lMOeC54KYLHuleOr8lsKp5PbELohlAzt76zt8Lohy5B5Er1zjLFh8lsbOcOhq613IJoKYCszO5BlAHPbELW0EfHKjJFt7coKO5B5EuYGsuYGsuY5OcOhqMWh7KWI7NohYlo0y5BeWxPeUcOhEI138GszO5BlAiOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8iOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8iOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8iOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8iOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8iOhEfsVlJR3qKOeNhF38xsd95Fh7GRg7XFzHJs0ElszjwF3XG13X0OeC5StshO595Fh7GRg7XFzHJoKkw1376WMOv3IwcOhjIWKYfog7KFzlxOeNhF38xsd95sugcFzlJHule1Kp5BeU6pb95s3XLFh8lOeNhF38xsd95shqasg7c13INHbOvjeU6pb95shqasg7c13INHu95BeF9PeUcOhsL1tgJoulA1zYMOeCtpbm9PbEAotYNshllWl7fshsxszy5BeU6pb95o37G13sNszEJWhq6su7A1zNlOeC9PeUcO0HLRSr5BeU6pb95HtqXp5Ovpbm9PbEKFzGxOeC9PeUcO0HLRSy5BeU6pb95HtqXjdOvpbm9PbEXFzW5B5Er1zjLFh8lsbOcO0lLHI7Lsuy5BeU6pb95R3qKztqGsu95BeU6pb95R3qKztqGsVO5BeU6pb95R3qKztELWt45B5EpotjLobk313gKO595R3qKztIfsu45B5Ers3sLH38wO595R3qKztIfsulh13gMOeC5YulxF3Ecs3y5Jd8ozd8ozd8ozgwcOhjfohYNHulfo0p5B5EZH3I913X0O595sughs3Xx1zslzt79HbOv3MEZH3I913X0O595y3lMOrjMoKge1bOcOGjMoKge1ul6sMEHPbEG1zjLFh8lztqLOeNhF38xsd95sulxF3Ecsg7LFg7fo5Ov3MEDo5kzFzEAHzU5zd95sh7MFtgJoup5B0YMH34cOh8eztqLzt76OeNoOGNIozkNohW5PbEk1zOTyKEfH3jCO595yKEfH3jC13X0OlwcOh8eztYNWtq5ougMOeNoOGXLsugxOlwcOh8ezKkNHujCOeC5gzUT4KHNHujCO595oujJWhq6su7A1zNlOeC9PeUcOh8ezKYXWu45Blc5Yu7IFh8lOqYLWbOcOGLNsu4T4tLfHVp5zd95oujJHhqcH345BeU6pb95oujJHhqcH3gcOeC9PeUcOh8ezKsLoVglW5Ovpbm9PbEcFI7XFzW5BeU6pb95oujJR3qKzKELohYfo3lvsdOvpbm9PbEcFI7XFzHJHVl9sdOvOljNsugzFzlxO595WVElWtgwOeCMPeUcO0jLshgJ1ugLsbOv3IwcO0jwFzYNFI7AF3XIF395B0YMH34cO0y5B0c5Ft76sulw1376WMOv3MEZH3I913X0O595y3lMOrjMoKge1bOcOGjMoKge1ul6sMOcOG76Oqkls3c5zd95ouqxHq7tF395Blc5d0gAWul6sMOcOGqNW5kQWh7IFtT5PbEQWh7IFtLNohW5zzwcO0YKs3qaWMOv3MEko0YNOrELFtAxHuq5OlwcO0Hl13HCHq7tF38IsdOvpS49Pek7PbEA1zjes38cF3XloKgxOeNiOhqtotlGztjfou8JsulxHbOvjdm9PbELHh7Nsq7eot8c1zjNotXxOeNhF38xsd95FtLJ13XJF3lMztqIHu25Ber6pb95FtLJ13XJF3lMztqKWbOvpdm9PbEe1q7Nol7L1zEJWeT5Ber6pb95FtLJ13XJF3lMzKjxsxUmOeCwjdm9PbEe1q7AotYlztqIHu25BlAHPbEe1q7AotYlztqKWbOv3IwcOhjCztIfsugJWeT5BlAHPbEe1q7AotYlzKjxsxUmOeNoOGl6OrqNW5EHPbEe1q76oI7xFt79sg7LHzYfOeC8PeUcOhjCztXfzKjeoKklztqKWbOvpdm9PbEe1q76oI7xFt79sg7xWtW9BbOvpdm9PbEe1q7Ks3q9otm5B5ES4wWApQT5PbEeouq6zKYLsMOvshqcWt4cOhjfo0jfougJFt7coKO5B5OIpS48jSqrp5OcOhjfo0jfougJo37G13sNszO5BhsLoVjlPbEeHzjwotIJ1ulwFtLLohjlOeNwW0glPbEGoKEAF3XwztqNodOvshqcWt4cOhYfWhILo0YJF3lAztjfou7MOeC5ySU9pQU9yxT5PbEhFzjwzt8LsuYlW5OvshqcWt4cOhHMs3XLsugJWhgcs3qxsdOvshqcWt4cOhHMs3XLsugJWhgcs3qxsg7Go3W5BepIPeUcOhXfztsLou8JsuqAF3HlOeNwW0glPbE9ouqXszExztIIHu45BhsLoVjlPbE9ouqXszExztIIHugJHVl9sdOvOlg6ozgwsdOcO0jIWugMzKYfWKp5BhsLoVjlPbEwF38azt76OeNoOGANou95PbEkWKjNWKy5PbESs38hOrYlFzYCO595dtlcougMWMkrs3qw1bEHPbEwWhqx1VYLouc5B0YMH3g7PbEt1zjIF38xOeNiOhqNo3EfHq7cotHxOeNwW0glPbELWKklFKYJWhqw1325B0YMH34cOhqxWugeHq7MFzYNoI7tF38IsdOvpSyMPeUcOhELFtA0Wh7IohYJF3891ur5Bep9PeUcOhELFtA0Wh7IohYJou70WMOvpxU6pb95FKEfWKjCF3lMztl6suleFzYfW0p5BhsLoVjlPbEeHzjwotIJWtjfWu45BhsLoVjlPbEeHzjwotIJWtjfWugJFt7coKO5B0c5ohqAsdOvOljfoulGO595HhqcH345B0c5YhqGsdOv3MEuYGsuYGsuY5OcOGsuYGsuYeU9OlwcOljfoulGOeNoOGsuYGsuYGsuOlI7Jd95FKgxHu7AzKjeoKklztYNWKy5BerIPeUcOhjIWKYfog7xFt79sg7c13XlOeCMpQU6pb95FKgxHu7AzKjeoKklztIfsulhOeNozd95suqAF3HlztILWhAlW5OvshqcWt4cOhYLo3q0sg7AFzEaszEJFt7coKO5B0c5ohqAsdOvOGLlF3y5PbEtF38IsdOvRMEbotYXOeNoOGsuYGsuYGsuOlwcOGLlF3y5Blc5BSEbjxOMYGF5zzI7PbEGWulJWtjLou45Ber6pb95sKElohqGsg7AotYIouqw1376OeNhF38xsd95sKElohqGsg79WhgG13jw1376OeNwW0glPbE0Whg6F3YlzKELsulIWMOvHVEIsd95sKElohqGsg7MF3YNHzjJFt7coKO5B0c5ohqAsdOvOljAotAlO595HhqcH345B0c5Y0ENs3XGOrIfou7woKF5Blc5BQkuYeT9Brr5zd95S37coKYfH5Ov3MEuYeyKpQUKy5EHPbESo37asdOv3MOmpQT9YGFKydEHJzwcOhHMs3XLsugJHtqMohl6sMOvHVEIsd95sKjJsulxWu8LRdOv3MEroKg5ou4Tguq9O595dulGsdkS1u7wWMOcOGsMs3gxHuq6sul6sMOcOGYLo3q0sdOcOGLNHujCF3XesdOcOGsL1t4TSuqws3XeRdOcOGEfo3OTd3XhoMOcOGYfWhILo0yTy3lAO595y3lAOqjwFzYxO595YhqasdkrH3jaO595yh7GRdkk13w5PbESF3slOqkf13XwWMEHPbENohYNFtqwoKExztqGsulw1376WMOv3IwcOhl6suleFzYfW0jJFt7coKO5B0c5ohqAsdOvOljfoulGO595HhqcH345B0c5YhqGsdOv3MOmj4EbYrFXY5OcOGsuYGsuYGsuOlwcOljfoulGOeNoOeTIyGErYeluOlI7Jd951tgXFhl6sVjJRbOvper9PeUcOhAlR3ENohYxzKG5BeFIBbm9PbEcotHxztjfou7MOeNiOhXLo345B5Py03lwO595HhqcH345B0c5SKYCszO5Blc5jSTIpeT8YGF5zd95wE8NWKp5Blc5YGFKYeHuYGF5zd95wEINHbOv3MEbyGEuYGsuY5EHJzwcOh8fsKjJsulxWu8LRdOv3xO6pb9xPeUcjbm9zd95ou70WI7wRzklOeNoOGqNo3EfHbkS1u7wWMOcOlkIWhjCFzjlWMEHPbEfWVkfWtlwsg7aohlhsdOvshqcWt4cO0jas3gwztl6suleFzYfW0p5BhsLoVjlPbExou7Ksu7Kol7mOeC8peUMPeUcO0jcoKHGoKH6zKG5Beptpbm9PbExWugeHuqwoKExzKT5Be46pb95WKklFKYLHu7MWI7XOeCKjQU6pb95WKYLWu8lsq7KFzYlWhILWhc5B5E4PgO5PbEw1uq6oKjJWtXLWbOvshqcWt4cO0sNszHAotYlobOvshqcWt4cO0sNszHAotYloq7hoKF5BeF9pbm9PbEt13gKo37Gs38JRbOvpeU6pb95HhllHtIfsugczKG5BeO9PeUcO0sNszHAotYloq7vOeCApS46pb95HtqwszEAFzEazKT5BeOxjSG6pb95HtqwszEAFzEazKG5BeT6pb95Htl6su7KWMOvHVEIsd95Htl6su7KWI7LsuYNHulfo0p5BhsLoVjlPbEK13XGoKHxztjfou7MOeNiOhXLo345B5ESot8NsbOcO0sLoVglOeNiOGsLsu45Blc5YGsuYGsuYGF5PbEuYGsuYGsuY5EHPbESot8NsbOv3MEbB4OXyeG9pbEHJzwcO0HNohYfHKjJsulxWu8LRdOv3xr6pb9MPekHPbEK13XGoKHxztIfWh45B0YMH3g7Jy_celestia", true);
        end, true);
        v972.import = v970:button((" %s "):format(v968.icons.import), function()
            -- upvalues: v968 (ref)
            v968:import_data(nil, true);
        end, true);
        v972.import:tooltip("Import");
        v972.config_selected:set_callback(function(v973)
            -- upvalues: l_pairs_0 (ref), v972 (ref)
            for v974, v975 in l_pairs_0(v972) do
                if v974 ~= "config_selected" then
                    v975:visibility(v973:get() == 1);
                end;
            end;
        end, true);
        v968.general = v972;
        local v976 = l_create_0("CELESTIA", "Anti Aim", 1);
        local v977 = l_create_0("CELESTIA", "Presets", 2);
        local v978 = l_create_0("CELESTIA", "Builder", 2);
        local v979 = {
            builder = {}, 
            manuals = v976:combo(v968.icons.manuals .. " Manuals", {
                [1] = "Disabled", 
                [2] = "Forward", 
                [3] = "Left", 
                [4] = "Right"
            })
        };
        local v980 = v979.manuals:create();
        v979.static_manual = v980:switch("Static Manual");
        v979.aa_arrows = v980:switch("Anti Aim Arrows");
        v979.arrows_color = v980:color_picker("Color");
        v979.arrows_indent = v980:slider("Indent", v968.screen_size.x * 0.0105, v968.screen_size.x * 0.052, v968.screen_size.x * 0.0287);
        v979.aa_arrows:set_callback(function(v981)
            -- upvalues: v979 (ref)
            v979.arrows_color:visibility(v981:get());
            v979.arrows_indent:visibility(v981:get());
        end, true);
        v979.tweaks = v976:selectable(v968.icons.tweaks .. " Tweaks", {
            [1] = "AA on Use", 
            [2] = "Anti Backstab", 
            [3] = "Edge Yaw"
        });
        v979.safe_head = v976:selectable(v968.icons.safe_head .. "  Safe Head", {
            [1] = "Air Knife", 
            [2] = "Air Zeus", 
            [3] = "Standing", 
            [4] = "Air Crouch", 
            [5] = "Crouching"
        });
        v979.anim_breakers = v976:switch(v968.icons.animbreakers .. "   Animations");
        v980 = v979.anim_breakers:create();
        v979.anim_on_land = v980:combo("On Land", {
            [1] = "Disabled", 
            [2] = "Follow Direction", 
            [3] = "Moon Walk"
        });
        v979.anim_in_air = v980:combo("In Air", {
            [1] = "Disabled", 
            [2] = "Static Legs", 
            [3] = "Moon Walk"
        });
        v979.anim_other = v980:selectable("Other", {
            [1] = "Pitch Zero on Land", 
            [2] = "Body Lean", 
            [3] = "Sliding Slowwalk", 
            [4] = "Sliding Crouch"
        });
        v979.weight_value = v980:slider("Lean Multiplier", 99, 500, 100, 0.01, function(v982)
            return v982 == 100 and "Default" or v982 == 99 and "Disabled" or ("x%s"):format(v982 * 0.01);
        end);
        v979.anim_breakers:set_callback(function(v983)
            -- upvalues: v979 (ref)
            v979.anim_on_land:visibility(v983:get());
            v979.anim_in_air:visibility(v983:get());
            v979.anim_other:visibility(v983:get());
            v979.weight_value:visibility(v983:get() and v979.anim_other:get("Body Lean"));
        end, true);
        v979.anim_other:set_callback(function(v984)
            -- upvalues: v979 (ref)
            v979.weight_value:visibility(v979.anim_breakers:get() and v984:get("Body Lean"));
        end, true);
        v979.air_exploit = v976:switch(v968.icons.air_exploit .. "  Air Exploit");
        v979.force_lc = v976:switch(v968.icons.defensive_options .. " Defensive Options");
        v980 = v979.force_lc:create();
        v979.defensive_opt = v980:selectable("Force LC on", {
            [1] = "Standing", 
            [2] = "Walking", 
            [3] = "Slow Walk", 
            [4] = "Jumping", 
            [5] = "Air Crouch", 
            [6] = "Crouching"
        });
        v979.lc_aa_on = v980:selectable("LC Anti-Aim on", {
            [1] = "On Peek"
        });
        v979.lc_type = v980:selectable("Type", {
            [1] = "Double Tap", 
            [2] = "Hide Shots"
        });
        v979.lc_disabler = v980:selectable("Disable on", {
            [1] = "Nades", 
            [2] = "Freestand", 
            [3] = "Manuals"
        });
        v979.lc_pitch = v980:combo("Pitch Type", {
            [1] = "Down", 
            [2] = "Down Switch", 
            [3] = "Up Switch", 
            [4] = "Up", 
            [5] = "SideWays", 
            [6] = "3-Way", 
            [7] = "Custom"
        });
        v979.lc_value = v980:slider("Pitch", -89, 89, 0, nil, "\194\176");
        v979.lc_valuel = v980:slider("Pitch Left", -89, 89, 0, nil, "\194\176");
        v979.lc_valuer = v980:slider("Pitch Right", -89, 89, 0, nil, "\194\176");
        v979.lc_randomize = v980:slider("Pitch Randomize", -45, 45, 10, nil, "\194\176");
        v979.lc_yaw_type = v980:combo("Yaw Type", {
            [1] = "Forward", 
            [2] = "SideWays", 
            [3] = "Center", 
            [4] = "Offset", 
            [5] = "Spin", 
            [6] = "3-Way", 
            [7] = "Random"
        });
        v979.lc_yaw = v980:slider("Yaw", -180, 180, 0, nil, "\194\176");
        v979.lc_yaw_randomize = v980:slider("Yaw Randomize", 0, 90, 35, nil, "\194\176");
        local function v985()
            -- upvalues: v979 (ref)
            v979.defensive_opt:visibility(v979.force_lc:get());
            v979.lc_aa_on:visibility(v979.force_lc:get());
            v979.lc_disabler:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
            v979.lc_type:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
            v979.lc_pitch:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
            v979.lc_valuel:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.lc_pitch:get() == "SideWays" and v979.force_lc:get());
            v979.lc_valuer:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.lc_pitch:get() == "SideWays" and v979.force_lc:get());
            v979.lc_value:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.lc_pitch:get() == "Custom" and v979.force_lc:get());
            v979.lc_randomize:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
            v979.lc_yaw_type:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
            v979.lc_yaw:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and (not (v979.lc_yaw_type:get() ~= "3-Way" and v979.lc_yaw_type:get() ~= "Center") or v979.lc_yaw_type:get() == "Offset") and v979.force_lc:get());
            v979.lc_yaw_randomize:visibility((not (#v979.defensive_opt:get() == 0) or v979.lc_aa_on:get("On Peek")) and v979.force_lc:get());
        end;
        v979.t = {
            last_val = v979.lc_aa_on:get(), 
            conditions = {}
        };
        do
            local l_v985_0 = v985;
            v979.force_lc:set_callback(function()
                -- upvalues: l_v985_0 (ref)
                l_v985_0();
            end, true);
            v979.defensive_opt:set_callback(function(v987)
                -- upvalues: v979 (ref), l_v985_0 (ref)
                v979.t.conditions = v987:get();
                table.insert(v979.t.conditions, "On Peek");
                v979.lc_aa_on:update(v979.t.conditions);
                v979.lc_aa_on:set(v979.t.last_val);
                l_v985_0();
            end, true);
            v979.lc_pitch:set_callback(function()
                -- upvalues: l_v985_0 (ref)
                l_v985_0();
            end, true);
            v979.lc_aa_on:set_callback(function()
                -- upvalues: v979 (ref), l_v985_0 (ref)
                v979.t.last_val = v979.lc_aa_on:get();
                l_v985_0();
            end, true);
            v979.lc_yaw_type:set_callback(function()
                -- upvalues: l_v985_0 (ref)
                l_v985_0();
            end, true);
        end;
        v979.preset = v977:list("\000", {
            [1] = v968.icons.preset1 .. " Disabled", 
            [2] = v968.icons.preset1 .. " Jitter", 
            [3] = v968.icons.preset2 .. " Jitter 2"
        });
        v979.conditions = v977:combo(v968.icons.conditions .. " Conditions", v968.builder.states);
        v972.config_selected:set_callback(function(v988)
            -- upvalues: v979 (ref)
            v979.preset:visibility(v988:get() == 2);
            v979.conditions:visibility(v988:get() == 2);
            v979.safe_head:visibility(v988:get() == 2);
            v979.force_lc:visibility(v988:get() == 2);
            v979.anim_breakers:visibility(v988:get() == 2);
            v979.tweaks:visibility(v988:get() == 2);
            v979.manuals:visibility(v988:get() == 2);
            v979.air_exploit:visibility(v988:get() == 2);
        end, true);
        for v989 = 1, #v968.builder.states do
            v979.builder[v989] = {};
            local v990 = v979.builder[v989];
            v990.enable = v978:switch(v968.icons.override .. " Override");
            v990.yaw = v978:combo("Yaw", {
                [1] = "Disabled", 
                [2] = "Backward", 
                [3] = "3-Way", 
                [4] = "5-Way"
            });
            local v991 = v990.yaw:create();
            v990.yaw_mode = v991:combo("Mode", {
                [1] = "Default", 
                [2] = "L & R"
            });
            v990.yaw_base = v991:combo("Base", {
                [1] = "Local View", 
                [2] = "At Target"
            });
            v990.custom_ways = v991:switch("Custom Ways");
            for v992 = 1, 5 do
                v990["way" .. v992] = v991:slider("Way #" .. v992, -180, 180, 0, nil, "\194\176");
            end;
            v990.yaw_add = v978:slider("Yaw Add", -180, 180, 0, nil, "\194\176");
            v990.yaw_addl = v978:slider("Yaw Add [L]", -180, 180, 0, nil, "\194\176");
            v990.yaw_addr = v978:slider("Yaw Add [R]", -180, 180, 0, nil, "\194\176");
            v990.delay_ticks = v978:slider("Delay Ticks", 0, 30, 0, nil, function(v993)
                return v993 == 0 and "Off" or v993 .. "t";
            end);
            v990.yaw_modifier = v978:combo("Yaw Modifier", {
                [1] = "Disabled", 
                [2] = "Center", 
                [3] = "Offset", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "3-Way", 
                [7] = "5-Way"
            });
            v990.modifier_randomize = v990.yaw_modifier:create():slider("Randomize", 0, 180, 0, nil, "\194\176");
            v990.modifier_offset = v978:slider("Modifier Offset", -180, 180, 0, nil, "\194\176");
            v990.body_yaw = v978:switch("Body Yaw");
            v991 = v990.body_yaw:create();
            v990.body_yaw_options = v991:selectable("Options", {
                [1] = "Avoid Overlap", 
                [2] = "Jitter", 
                [3] = "Randomize Jitter", 
                [4] = "Anti Bruteforce"
            });
            v990.body_yaw_freestanding = v991:combo("Freestanding", {
                [1] = "Off", 
                [2] = "Peek Fake", 
                [3] = "Peek Real"
            });
            v990.fake_limit = v978:slider("Fake Limit", 0, 60, 60, nil, "\194\176");
            v990.fake_limitl = v978:slider("Fake Limit [L]", 0, 60, 60, nil, "\194\176");
            v990.fake_limitr = v978:slider("Fake Limit [R]", 0, 60, 60, nil, "\194\176");
            do
                local l_v989_0 = v989;
                do
                    local l_v990_0 = v990;
                    for v996, v997 in l_pairs_0(l_v990_0) do
                        do
                            local l_v996_0, l_v997_0 = v996, v997;
                            local function v1001()
                                -- upvalues: v979 (ref), v968 (ref), l_v989_0 (ref), l_v996_0 (ref), l_v990_0 (ref), v972 (ref), l_type_0 (ref), l_v997_0 (ref)
                                local v1000 = v979.conditions:get() == v968.builder.states[l_v989_0] and (l_v996_0 == "enable" or l_v990_0.enable:get()) and v972.config_selected:get() == 2;
                                if l_type_0(l_v997_0) ~= "table" then
                                    l_v997_0:visibility(v1000);
                                end;
                                l_v990_0.yaw_mode:visibility(l_v990_0.yaw:get() ~= "Disabled" and v1000);
                                l_v990_0.yaw_base:visibility(l_v990_0.yaw:get() ~= "Disabled" and v1000);
                                l_v990_0.custom_ways:visibility(l_v990_0.yaw:get():find("Way") ~= nil and v1000);
                                l_v990_0.way1:visibility(l_v990_0.yaw:get():find("Way") ~= nil and l_v990_0.custom_ways:get() and v1000);
                                l_v990_0.way2:visibility(l_v990_0.yaw:get():find("Way") ~= nil and l_v990_0.custom_ways:get() and v1000);
                                l_v990_0.way3:visibility(l_v990_0.yaw:get():find("Way") ~= nil and l_v990_0.custom_ways:get() and v1000);
                                l_v990_0.way4:visibility(l_v990_0.yaw:get() == "5-Way" and l_v990_0.custom_ways:get() and v1000);
                                l_v990_0.way5:visibility(l_v990_0.yaw:get() == "5-Way" and l_v990_0.custom_ways:get() and v1000);
                                l_v990_0.yaw_mode:disabled(l_v990_0.yaw:get():find("Way") ~= nil and v1000);
                                if not l_v990_0.yaw:get():find("Way") then
                                    l_v990_0.custom_ways:set(false);
                                end;
                                l_v990_0.yaw_add:visibility(v1000 and l_v990_0.yaw:get() ~= "Disabled" and (l_v990_0.yaw_mode:get() == "Default" and not l_v990_0.custom_ways:get() or l_v990_0.yaw:get():find("Way") ~= nil and not l_v990_0.custom_ways:get()));
                                l_v990_0.yaw_addl:visibility(v1000 and l_v990_0.yaw:get() ~= "Disabled" and l_v990_0.yaw:get():find("Way") == nil and not l_v990_0.custom_ways:get() and l_v990_0.yaw_mode:get() == "L & R");
                                l_v990_0.yaw_addr:visibility(v1000 and l_v990_0.yaw:get() ~= "Disabled" and l_v990_0.yaw:get():find("Way") == nil and not l_v990_0.custom_ways:get() and l_v990_0.yaw_mode:get() == "L & R");
                                l_v990_0.delay_ticks:visibility(v1000 and l_v990_0.yaw:get() ~= "Disabled" and l_v990_0.yaw:get():find("Way") == nil and not l_v990_0.custom_ways:get() and l_v990_0.yaw_mode:get() == "L & R");
                                l_v990_0.modifier_randomize:visibility(l_v990_0.yaw_modifier:get() ~= "Disabled" and v1000);
                                l_v990_0.modifier_offset:visibility(l_v990_0.yaw_modifier:get() ~= "Disabled" and v1000);
                                l_v990_0.body_yaw_options:visibility(l_v990_0.body_yaw:get() and v1000);
                                l_v990_0.body_yaw_freestanding:visibility(l_v990_0.body_yaw:get() and v1000);
                                l_v990_0.fake_limit:visibility(v1000 and l_v990_0.body_yaw:get() and not l_v990_0.body_yaw_options:get("Jitter"));
                                l_v990_0.fake_limitl:visibility(v1000 and l_v990_0.body_yaw:get() and l_v990_0.body_yaw_options:get("Jitter"));
                                l_v990_0.fake_limitr:visibility(v1000 and l_v990_0.body_yaw:get() and l_v990_0.body_yaw_options:get("Jitter"));
                            end;
                            v972.config_selected:set_callback(v1001, true);
                            v979.conditions:set_callback(v1001, true);
                            v979.defensive_opt:set_callback(v1001, true);
                            for _, v1003 in l_pairs_0({
                                [1] = "enable", 
                                [2] = "yaw", 
                                [3] = "custom_ways", 
                                [4] = "yaw_mode", 
                                [5] = "yaw_modifier", 
                                [6] = "body_yaw", 
                                [7] = "body_yaw_options"
                            }) do
                                l_v990_0[v1003]:set_callback(v1001, true);
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if l_get_username_0() == "DarkLuny" or l_get_username_0() == "137000" then
            v972.export_preset = v978:button("Export Preset", function()
                -- upvalues: v968 (ref)
                return v968:export_preset();
            end, true);
            v972.config_selected:set_callback(function(v1004)
                -- upvalues: v972 (ref)
                v972.export_preset:visibility(v1004:get() == 2);
            end, true);
        end;
        v968.anti_aim = v979;
        v980 = {};
        v985 = l_create_0("CELESTIA", "View", 1);
        local v1005 = l_create_0("CELESTIA", "Visuals", 2);
        v980.viewmodel = v985:switch(v968.icons.viewmodel .. "Viewmodel Changer");
        local v1006 = v980.viewmodel:create();
        v980.viewmodel_fov = v1006:slider("FOV", -1800, 1800, cvar.viewmodel_fov:float() * 10, 0.1);
        v980.viewmodel_x = v1006:slider("X", -1800, 1800, cvar.viewmodel_offset_x:float() * 10, 0.1);
        v980.viewmodel_y = v1006:slider("Y", -1800, 1800, cvar.viewmodel_offset_y:float() * 10, 0.1);
        v980.viewmodel_z = v1006:slider("Z", -1800, 1800, cvar.viewmodel_offset_z:float() * 10, 0.1);
        v980.opposite_knife = v1006:switch("Opposite Knife Hand");
        v980.viewmodel_reset = v1006:button("                             Reset                             ", nil, true);
        v980.viewmodel:set_callback(function(v1007)
            -- upvalues: v980 (ref)
            v980.viewmodel_fov:visibility(v1007:get());
            v980.viewmodel_x:visibility(v1007:get());
            v980.viewmodel_y:visibility(v1007:get());
            v980.viewmodel_z:visibility(v1007:get());
            v980.opposite_knife:visibility(v1007:get());
            v980.viewmodel_reset:visibility(v1007:get());
        end, true);
        v980.aspect_ratio = v985:switch(v968.icons.aspect_ratio .. "  Aspect Ratio");
        v1006 = v980.aspect_ratio:create();
        v980.aspect_ratio_value = v1006:slider("Value", 0, 500, 0, 0.01, function(v1008)
            if v1008 == 0 then
                return "Off";
            else
                return;
            end;
        end);
        local v1009 = v1006:button("16:9", function()
            -- upvalues: v980 (ref)
            v980.aspect_ratio_value:set(178);
        end, true);
        local v1010 = v1006:button("16:10", function()
            -- upvalues: v980 (ref)
            v980.aspect_ratio_value:set(160);
        end, true);
        local v1011 = v1006:button("3:2", function()
            -- upvalues: v980 (ref)
            v980.aspect_ratio_value:set(150);
        end, true);
        local v1012 = v1006:button("4:3", function()
            -- upvalues: v980 (ref)
            v980.aspect_ratio_value:set(133);
        end, true);
        local v1013 = v1006:button("5:4", function()
            -- upvalues: v980 (ref)
            v980.aspect_ratio_value:set(125);
        end, true);
        v980.aspect_ratio_value:set_callback(function(v1014)
            -- upvalues: v980 (ref)
            if v980.aspect_ratio:get() then
                cvar.r_aspectratio:float(v1014:get() * 0.01);
            end;
        end, true);
        do
            local l_v1009_0, l_v1010_0, l_v1011_0, l_v1012_0, l_v1013_0 = v1009, v1010, v1011, v1012, v1013;
            v980.aspect_ratio:set_callback(function(v1020)
                -- upvalues: v980 (ref), l_v1009_0 (ref), l_v1010_0 (ref), l_v1011_0 (ref), l_v1012_0 (ref), l_v1013_0 (ref)
                v980.aspect_ratio_value:visibility(v1020:get());
                l_v1009_0:visibility(v1020:get());
                l_v1010_0:visibility(v1020:get());
                l_v1011_0:visibility(v1020:get());
                l_v1012_0:visibility(v1020:get());
                l_v1013_0:visibility(v1020:get());
                if not v1020:get() then
                    cvar.r_aspectratio:float(0);
                else
                    cvar.r_aspectratio:float(v980.aspect_ratio_value:get() * 0.01);
                end;
            end, true);
        end;
        v980.thanos_snap = v985:switch(v968.icons.ragdoll_anim .. "  Ragdoll Animate");
        v980.thanos_snap:set_callback(function(v1021)
            cvar.cl_ragdoll_physics_enable:int(v1021:get() and 0 or 1);
        end, true);
        v980.crosshair_indicators = v1005:switch(v968.icons.cross_ind .. " Crosshair Indicators");
        v1006 = v980.crosshair_indicators:create();
        v980.indicators_additions = v1006:selectable("Additions", {
            [1] = "Min. Damage", 
            [2] = "Glow Text", 
            [3] = "Alpha Modulate"
        });
        v980.indicators_color = v1006:color_picker("Accent Color", {
            Solid = {
                l_get_style_0("Link Active")
            }, 
            Fade = {
                l_get_style_0("Link Active"), 
                l_color_0()
            }
        });
        v980.crosshair_indicators:set_callback(function(v1022)
            -- upvalues: v980 (ref)
            v980.indicators_additions:visibility(v1022:get());
            v980.indicators_color:visibility(v1022:get());
        end, true);
        v980.aimbot_logs = v1005:switch(v968.icons.event_logs .. " Event Logs");
        v1006 = v980.aimbot_logs:create();
        v980.logs_display = v1006:listable("Display", {
            [1] = "On Center", 
            [2] = "Top Left", 
            [3] = "Console", 
            [4] = "Crosshair", 
            [5] = "Pluses"
        });
        v980.logs_type = v1006:selectable("Type", {
            [1] = "Aimbot Shots", 
            [2] = "Purchases"
        });
        v980.logs_color = v1006:color_picker("Miss Reason Color", {
            ["\208\157it"] = {
                l_color_0(187, 191, 255, 255)
            }, 
            ["\208\156iss"] = {
                l_color_0(255, 127, 127, 255)
            }, 
            Other = {
                l_color_0(88, 82, 129, 255)
            }
        });
        v980.background_logs = v1006:slider("BG Alpha", 0, 100, 30, nil, "%");
        v980.aimbot_logs:set_callback(function(v1023)
            -- upvalues: v980 (ref)
            v980.logs_color:visibility(#v980.logs_display:get() > 0 and v1023:get());
            v980.background_logs:visibility(#v980.logs_display:get() > 0 and v1023:get());
            v980.logs_display:visibility(v1023:get());
            v980.logs_type:visibility(v1023:get());
            v980.logs_display:set_callback(function(v1024)
                -- upvalues: v980 (ref), v1023 (ref)
                v980.logs_color:visibility(#v1024:get() > 0 and v1023:get());
                v980.background_logs:visibility(v1024:get("On Center") and v1023:get());
            end, true);
        end, true);
        v980.damage_marker = v1005:switch(v968.icons.dmg_marker .. " Damage Marker");
        v980.damage_marker_color = v980.damage_marker:color_picker({
            Head = {
                l_color_0(146, 183, 34)
            }, 
            Body = {
                l_color_0()
            }
        });
        v980.damage_marker:set_callback(function(v1025)
            -- upvalues: v980 (ref)
            v980.damage_marker_color:visibility(v1025:get());
        end, true);
        v980.custom_scope = v1005:switch(v968.icons.scope_overlay .. " Scope Overlay");
        v1006 = v980.custom_scope:create();
        v980.custom_scope_line = v1006:slider("Initial", 0, 512, 200, nil, "px");
        v980.custom_scope_dist = v1006:slider("Offset", 0, 512, 15, nil, "px");
        v980.custom_scope_modif = v1006:selectable("Modification", {
            [1] = "T-Style", 
            [2] = "Inaccuracy"
        });
        v980.custom_scope_color = v1006:color_picker("Color", {
            Solid = {
                l_color_0()
            }, 
            Fade = {
                l_color_0(), 
                l_color_0(255, 0)
            }
        });
        v980.custom_scope:set_callback(function(v1026)
            -- upvalues: v980 (ref), l_find_0 (ref)
            v980.custom_scope_line:visibility(v1026:get());
            v980.custom_scope_dist:visibility(v1026:get());
            v980.custom_scope_modif:visibility(v1026:get());
            v980.custom_scope_color:visibility(v1026:get());
            l_find_0("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override(v1026:get() and "Remove All" or nil);
        end, true);
        v980.windows = v1005:switch(v968.icons.windows .. " Windows");
        v1006 = v980.windows:create();
        v980.windows_display = v1006:listable("Display", {
            [1] = "Watermark", 
            [2] = "Keybinds", 
            [3] = "Spectators", 
            [4] = "Slowdown"
        });
        v980.windows_additions = v1006:switch("Glow");
        v980.windows_color = v1006:color_picker("Color", {
            Solid = {
                l_color_0()
            }, 
            Fade = {
                l_color_0(), 
                l_color_0()
            }
        });
        v980.background_alpha = v1006:slider("BG Alpha", 0, 100, 30, nil, "%");
        v980.windows_more = v1006:switch("Weather & Bomb Info");
        v980.stapled_watermark = v1006:combo("stapled_watermark", {
            [1] = "T-R", 
            [2] = "T-L", 
            [3] = "B-C", 
            [4] = "None"
        }):visibility(false);
        v980.watermark_x = v1006:slider("watermark_x", 0, v968.screen_size.x, v968.screen_size.x - 120):visibility(false);
        v980.watermark_y = v1006:slider("watermark_y", 0, v968.screen_size.y, 8):visibility(false);
        v980.keybinds_x = v1006:slider("keybinds_x", 0, v968.screen_size.x, 5):visibility(false);
        v980.keybinds_y = v1006:slider("keybinds_y", 0, v968.screen_size.y, v968.screen_size.y * 0.5 - 20):visibility(false);
        v980.spectators_x = v1006:slider("spectators_x", 0, v968.screen_size.x, 5):visibility(false);
        v980.spectators_y = v1006:slider("spectators_y", 0, v968.screen_size.y, v968.screen_size.y * 0.5 + 20):visibility(false);
        v980.slowdown_x = v1006:slider("slowdown_x", 0, v968.screen_size.x, v968.screen_size.x * 0.5 + 22):visibility(false);
        v980.slowdown_y = v1006:slider("slowdown_y", 0, v968.screen_size.y, v968.screen_size.y * 0.25):visibility(false);
        v980.dpi_scale = v1006:slider("dpi_scale", 1, 5, 1):visibility(false);
        v980.windows:set_callback(function(v1027)
            -- upvalues: v980 (ref), v960 (ref)
            v980.windows_display:visibility(v1027:get());
            if v1027:get() and v980.windows_display:get("Watermark") then
                v960.visuals:execute_player_data();
            end;
            v980.windows_more:visibility(v1027:get() and v980.windows_display:get("Watermark"));
            v980.windows_additions:visibility(v1027:get() and #v980.windows_display:get() > 0);
            v980.background_alpha:visibility(v1027:get() and #v980.windows_display:get() > 0);
            v980.windows_color:visibility(v1027:get() and #v980.windows_display:get() > 0);
        end, true);
        v980.windows_display:set_callback(function(v1028)
            -- upvalues: v980 (ref), v960 (ref)
            if v980.windows:get() and v1028:get("Watermark") then
                v960.visuals:execute_player_data();
            end;
            v980.windows_more:visibility(v980.windows:get() and v1028:get("Watermark"));
            v980.windows_additions:visibility(v980.windows:get() and #v1028:get() > 0);
            v980.background_alpha:visibility(v980.windows:get() and #v1028:get() > 0);
            v980.windows_color:visibility(v980.windows:get() and #v1028:get() > 0);
        end, true);
        v980.skeet_indicators = v1005:switch(v968.icons.skeet_ind .. " Indicators");
        v980.gs_display = v980.skeet_indicators:create():selectable("Display", {
            [1] = "Double Tap", 
            [2] = "Hide Shots", 
            [3] = "Freestanding", 
            [4] = "Damage", 
            [5] = "Hitchance", 
            [6] = "Fake Latency", 
            [7] = "Bomb Info", 
            [8] = "Dormant Aim", 
            [9] = "Aim Stats", 
            [10] = "Fake Duck", 
            [11] = "Body Aim", 
            [12] = "Safe Points"
        });
        v980.skeet_indicators:set_callback(function(v1029)
            -- upvalues: v980 (ref)
            v980.gs_display:visibility(v1029:get());
        end, true);
        v980.grenade_radius = v1005:switch(v968.icons.grenade_radius .. " Grenade Radius");
        v980.grenade_radius_color = v980.grenade_radius:color_picker({
            Smoke = {
                l_color_0(128, 128, 255, 255)
            }, 
            Molotov = {
                l_color_0(255, 128, 128, 255)
            }, 
            ["Friend Molotov"] = {
                l_color_0(128, 255, 128, 255)
            }
        });
        v980.grenade_radius:set_callback(function(v1030)
            -- upvalues: v980 (ref)
            v980.grenade_radius_color:visibility(v1030:get());
        end, true);
        v980.grenade_modulation = v1005:switch(v968.icons.grenade_modulation .. " Grenade Modulation");
        v1006 = v980.grenade_modulation:create();
        v980.grenade_prediction = v1006:switch("Grenade Prediction");
        v980.grenade_warning = v1006:switch("Grenade Proximity Warning");
        v980.grenade_modulation:set_callback(function(v1031)
            -- upvalues: v980 (ref)
            v980.grenade_prediction:visibility(v1031:get());
            v980.grenade_warning:visibility(v1031:get());
        end, true);
        v972.config_selected:set_callback(function(v1032)
            -- upvalues: v980 (ref)
            v980.viewmodel:visibility(v1032:get() == 3);
            v980.aspect_ratio:visibility(v1032:get() == 3);
            v980.crosshair_indicators:visibility(v1032:get() == 3);
            v980.thanos_snap:visibility(v1032:get() == 3);
            v980.aimbot_logs:visibility(v1032:get() == 3);
            v980.damage_marker:visibility(v1032:get() == 3);
            v980.custom_scope:visibility(v1032:get() == 3);
            v980.windows:visibility(v1032:get() == 3);
            v980.grenade_modulation:visibility(v1032:get() == 3);
            v980.skeet_indicators:visibility(v1032:get() == 3);
            v980.grenade_radius:visibility(v1032:get() == 3);
        end, true);
        v968.visuals = v980;
        v1006 = {};
        v1009 = l_create_0("CELESTIA", "Helpers", 1);
        v1010 = l_create_0("CELESTIA", "Misc", 2);
        v1006.no_fall_damage = v1009:switch(v968.icons.no_fall_dmg .. " No Fall Damage");
        v1006.fast_ladder = v1009:switch(v968.icons.fast_ladder .. " Fast Ladder");
        v1006.avoid_collisions = v1009:switch(v968.icons.avoid_col .. " Avoid Collisions");
        v1006.avoid_coll_dist = v1006.avoid_collisions:create():slider("Distance", 0, 15, 5, 0.1, "m");
        v1006.avoid_collisions:set_callback(function(v1033)
            -- upvalues: v1006 (ref)
            v1006.avoid_coll_dist:visibility(v1033:get());
        end, true);
        v1006.clan_tag = v1010:switch(v968.icons.clantag .. " Clantag");
        v1006.console_modifier = v1010:switch(v968.icons.console_mod .. " Console Modifier");
        v1006.console_color = v1006.console_modifier:color_picker(l_color_0(81, 210));
        v1006.console_modifier:set_callback(function(v1034)
            -- upvalues: v1006 (ref)
            v1006.console_color:visibility(v1034:get());
        end, true);
        v1006.dormant_aim = v1010:switch(v968.icons.dormant_aim .. " Unsafe Dormant Aimbot"):tooltip("Just on it here and use bind in neverlose (ragebot -> dormant aimbot)");
        v1006.dormant_aim_color = v1006.dormant_aim:color_picker(l_color_0(160, 0, 0, 200));
        v1006.dormant_aim:set_callback(function(v1035)
            -- upvalues: v1006 (ref)
            v1006.dormant_aim_color:visibility(v1035:get());
        end, true);
        v1006.trashtalk = v1010:switch(v968.icons.trashtalk .. " TrashTalk");
        v1006.talk_on = v1006.trashtalk:create():selectable("Talk on", {
            [1] = "Kill", 
            [2] = "Assist", 
            [3] = "Self Death", 
            [4] = "Killers Death"
        });
        v1006.trashtalk:set_callback(function(v1036)
            -- upvalues: v1006 (ref)
            v1006.talk_on:visibility(v1036:get());
        end, true);
        v1006.players_mute = v1010:switch(v968.icons.players_mute .. " Players Mute | Unmute");
        v1006.players_mute_type = v1006.players_mute:create():combo("Type", {
            [1] = "Unmute", 
            [2] = "Mute"
        });
        v1006.players_mute:set_callback(function(v1037)
            -- upvalues: v1006 (ref)
            v1006.players_mute_type:visibility(v1037:get());
        end, true);
        v1006.custom_hitchance = v1010:switch(v968.icons.custom_hc .. " Custom Hitchance");
        v1011 = v1006.custom_hitchance:create();
        v1012 = {
            [1] = "SSG-08", 
            [2] = "AWP", 
            [3] = "R8 Revolver", 
            [4] = "AutoSnipers"
        };
        v1006.ch_weapon = v1011:combo("Weapon", {
            [1] = "SSG-08", 
            [2] = "AWP", 
            [3] = "R8 Revolver", 
            [4] = "AutoSnipers"
        });
        for v1038 = 1, #v1012 do
            local v1039 = v1012[v1038] == "SSG-08" and "ssg08" or v1012[v1038] == "AWP" and "awp" or v1012[v1038] == "R8 Revolver" and "r8" or v1012[v1038] == "AutoSnipers" and "auto" or "";
            v1006[("ch_mode_%s"):format(v1039)] = v1011:selectable("Mode" .. (" "):rep(v1038), v1039 == "r8" and {
                [1] = "In Air"
            } or {
                [1] = "In Air", 
                [2] = "No Scope"
            });
            v1006[("ch_in_air_%s"):format(v1039)] = v1011:slider("In Air" .. (" "):rep(v1038), 1, 100, 1, "%");
            if v1039 ~= "r8" then
                v1006[("ch_no_scope_%s"):format(v1039)] = v1011:slider("No Scope" .. (" "):rep(v1038), 1, 100, 1, "%");
            end;
        end;
        v1006.custom_hitchance:set_callback(function(v1040)
            -- upvalues: v1006 (ref), l_pairs_0 (ref)
            v1006.ch_weapon:visibility(v1040:get());
            v1006.ch_weapon:set_callback(function(v1041)
                -- upvalues: l_pairs_0 (ref), v1006 (ref), v1040 (ref)
                for v1042, v1043 in l_pairs_0({
                    auto = "AutoSnipers", 
                    awp = "AWP", 
                    ssg08 = "SSG-08", 
                    r8 = "R8 Revolver"
                }) do
                    do
                        local l_v1042_0, l_v1043_0 = v1042, v1043;
                        v1006[("ch_mode_%s"):format(l_v1042_0)]:set_callback(function(v1046)
                            -- upvalues: v1040 (ref), l_v1043_0 (ref), v1041 (ref), v1006 (ref), l_v1042_0 (ref)
                            v1046:visibility(v1040:get() and l_v1043_0 == v1041:get());
                            v1006[("ch_in_air_%s"):format(l_v1042_0)]:visibility(v1040:get() and l_v1043_0 == v1041:get() and v1046:get("In Air"));
                            if l_v1042_0 ~= "r8" then
                                v1006[("ch_no_scope_%s"):format(l_v1042_0)]:visibility(v1040:get() and l_v1043_0 == v1041:get() and v1046:get("No Scope"));
                            end;
                        end, true);
                    end;
                end;
            end, true);
        end, true);
        v1006.super_toss = v1010:switch(v968.icons.super_toss .. " Super Toss");
        v1006.grenade_release = v1010:switch(v968.icons.grenade_release .. " Grenade Release");
        v1006.grenade_release_dmg = v1006.grenade_release:create():slider("Min. Damage", 1, 55, 35, nil, "hp");
        v1006.grenade_release:set_callback(function(v1047)
            -- upvalues: v1006 (ref)
            v1006.grenade_release_dmg:visibility(v1047:get());
        end, true);
        v972.config_selected:set_callback(function(v1048)
            -- upvalues: v1006 (ref)
            v1006.no_fall_damage:visibility(v1048:get() == 4);
            v1006.fast_ladder:visibility(v1048:get() == 4);
            v1006.clan_tag:visibility(v1048:get() == 4);
            v1006.console_modifier:visibility(v1048:get() == 4);
            v1006.dormant_aim:visibility(v1048:get() == 4);
            v1006.trashtalk:visibility(v1048:get() == 4);
            v1006.players_mute:visibility(v1048:get() == 4);
            v1006.custom_hitchance:visibility(v1048:get() == 4);
            v1006.super_toss:visibility(v1048:get() == 4);
            v1006.grenade_release:visibility(v1048:get() == 4);
            v1006.avoid_collisions:visibility(v1048:get() == 4);
        end, true);
        v968.miscellaneous = v1006;
    end, 
    export_preset = function(v1049)
        -- upvalues: l_require_0 (ref)
        local v1050 = l_require_0("neverlose/inspect");
        print_raw("\aDA70D6FF{ \a6A9955FF--\208\191\209\128\208\181\209\129\208\181\209\130");
        for v1051 = 1, #v1049.builder.states do
            local v1052 = v1049.anti_aim.builder[v1051];
            print_raw(("\t\a1B9FFFFF{\aCE9178FF'%s'\aDEFAULT, \aCE9178FF'%s'\aDEFAULT, %s\aDEFAULT, \aCE9178FF'%s'\aDEFAULT, \aB5CEA8FF%s\aDEFAULT, \a368CD6FF%s\aDEFAULT, \aCE9178FF%s\aDEFAULT, \aCE9178FF'%s'\aDEFAULT, \aB5CEA8FF%s\aDEFAULT, \aB5CEA8FF%s\a1B9FFFFF}\aDEFAULT, \a6A9955FF--%s"):format("Down", "Backward", v1052.yaw_mode:get() == "L & R" and ("not \a9CDCFEFFinverter \aDEFAULTand \aB5CEA8FF%s\aDEFAULT or \aB5CEA8FF%s"):format(v1052.yaw_addl:get(), v1052.yaw_addr:get()) or ("\aB5CEA8FF%s"):format(v1052.yaw_add:get()), v1052.yaw_modifier:get(), v1052.modifier_randomize:get() == 0 and v1052.modifier_offset:get() or ("\aB5CEA8FF%s \aDEFAULT+ \aDCDCAAFFmath_random\aFFC814FF(\aB5CEA8FF%s\aDEFAULT, \aB5CEA8FF%s\aFFC814FF)"):format(v1052.modifier_offset:get(), -v1052.modifier_randomize:get(), v1052.modifier_randomize:get()), v1052.body_yaw:get(), v1050(v1052.body_yaw_options:get()), v1052.body_yaw_freestanding:get(), v1052.body_yaw_options:get("Jitter") and v1052.fake_limitl:get() or v1052.fake_limit:get(), v1052.body_yaw_options:get("Jitter") and v1052.fake_limitr:get() or v1052.fake_limit:get(), v1049.builder.states[v1051]));
        end;
        print_raw("\aDA70D6FF}");
    end, 
    export_data = function(v1053, v1054)
        -- upvalues: v960 (ref), l_get_style_0 (ref), l_console_exec_0 (ref), l_type_0 (ref), l_pcall_0 (ref), l_ipairs_0 (ref), l_insert_0 (ref), v962 (ref), l_pairs_0 (ref), v182 (ref), l_stringify_0 (ref), v126 (ref)
        local v1055 = nil;
        local l_skip_0 = v1053.general.skip;
        v1055 = {
            anti_aim = {
                builder = {
                    [1] = {}, 
                    [2] = {}, 
                    [3] = {}, 
                    [4] = {}, 
                    [5] = {}, 
                    [6] = {}, 
                    [7] = {}, 
                    [8] = {}, 
                    [9] = {}
                }
            }, 
            visuals = {}, 
            miscellaneous = {}
        };
        if not l_skip_0:get("Anti Aim") and l_skip_0:get("Visuals") and not l_skip_0:get("Misc") then
            v1055 = {
                anti_aim = {
                    builder = {
                        [1] = {}, 
                        [2] = {}, 
                        [3] = {}, 
                        [4] = {}, 
                        [5] = {}, 
                        [6] = {}, 
                        [7] = {}, 
                        [8] = {}, 
                        [9] = {}
                    }
                }, 
                miscellaneous = {}
            };
        elseif l_skip_0:get("Anti Aim") and not l_skip_0:get("Visuals") and not l_skip_0:get("Misc") then
            v1055 = {
                visuals = {}, 
                miscellaneous = {}
            };
        elseif not l_skip_0:get("Anti Aim") and not l_skip_0:get("Visuals") and l_skip_0:get("Misc") then
            v1055 = {
                anti_aim = {
                    builder = {
                        [1] = {}, 
                        [2] = {}, 
                        [3] = {}, 
                        [4] = {}, 
                        [5] = {}, 
                        [6] = {}, 
                        [7] = {}, 
                        [8] = {}, 
                        [9] = {}
                    }
                }, 
                visuals = {}
            };
        elseif l_skip_0:get("Anti Aim") and l_skip_0:get("Visuals") and not l_skip_0:get("Misc") then
            v1055 = {
                miscellaneous = {}
            };
        elseif l_skip_0:get("Anti Aim") and not l_skip_0:get("Visuals") and l_skip_0:get("Misc") then
            v1055 = {
                visuals = {}
            };
        elseif not l_skip_0:get("Anti Aim") and l_skip_0:get("Visuals") and l_skip_0:get("Misc") then
            v1055 = {
                anti_aim = {
                    builder = {
                        [1] = {}, 
                        [2] = {}, 
                        [3] = {}, 
                        [4] = {}, 
                        [5] = {}, 
                        [6] = {}, 
                        [7] = {}, 
                        [8] = {}, 
                        [9] = {}
                    }
                }
            };
        elseif l_skip_0:get("Anti Aim") and l_skip_0:get("Visuals") and l_skip_0:get("Misc") then
            v960.visuals:log_push(l_get_style_0("Link Active"), "You can't skip all the elements!");
            l_console_exec_0("play resource/warning");
            return;
        end;
        l_skip_0 = {
            save = 0, 
            key1 = 0, 
            market = 0, 
            skip = 0, 
            welcome = 0, 
            default_config = 0, 
            version = 0, 
            delete = 0, 
            configs = 0, 
            viewmodel_reset = 0, 
            local_configs = 0, 
            load_config = 0, 
            import = 0, 
            export = 0, 
            build_date = 0, 
            export_preset = 0, 
            manuals = 0, 
            config_name = 0, 
            discord = 0, 
            theme2 = 0, 
            theme1 = 0, 
            key = 0
        };
        if v1053.general.skip:get("View") then
            l_skip_0.viewmodel = 0;
            l_skip_0.viewmodel_fov = 0;
            l_skip_0.viewmodel_x = 0;
            l_skip_0.viewmodel_y = 0;
            l_skip_0.viewmodel_z = 0;
            l_skip_0.aspect_ratio = 0;
            l_skip_0.opposite_knife = 0;
            l_skip_0.aspect_ratio_value = 0;
        end;
        local function v1068(v1057, v1058, v1059)
            -- upvalues: l_type_0 (ref), l_pcall_0 (ref), l_ipairs_0 (ref), l_insert_0 (ref), v962 (ref)
            if l_type_0(v1059) == "userdata" then
                local v1060 = v1059:get();
                local v1061 = true;
                do
                    local l_v1060_0, l_v1061_0 = v1060, v1061;
                    l_pcall_0(function()
                        -- upvalues: v1059 (ref), l_type_0 (ref), l_ipairs_0 (ref), l_insert_0 (ref), v1057 (ref), v1058 (ref), v962 (ref), l_v1060_0 (ref), l_v1061_0 (ref)
                        if v1059 ~= nil and l_type_0(v1059) ~= "table" and v1059:list() ~= nil and v1059:list() ~= 0 and l_type_0(v1059:get()) == "string" and l_type_0(v1059:get(v1059:get())) == "table" and l_type_0(v1059:get(v1059:list()[1])) == "table" then
                            local v1064 = {};
                            for _, v1066 in l_ipairs_0(v1059:list()) do
                                for v1067 = 1, #v1059:get(v1066) do
                                    if not v1064[v1066] then
                                        v1064[v1066] = {};
                                    end;
                                    l_insert_0(v1064[v1066], v1059:get(v1066)[v1067]:to_hex());
                                end;
                                v1057[v1058] = {
                                    name = v1059:get(), 
                                    value = v1064
                                };
                            end;
                        else
                            v1057[v1058] = v962(l_v1060_0) == "imcolor" and l_v1060_0:to_hex() or l_v1060_0;
                        end;
                        l_v1061_0 = false;
                    end);
                    if l_v1061_0 then
                        v1057[v1058] = v962(l_v1060_0) == "imcolor" and l_v1060_0:to_hex() or l_v1060_0;
                    end;
                end;
            else
                v1057[v1058] = v1059;
            end;
        end;
        for v1069, _ in l_pairs_0(v1055) do
            for v1071, v1072 in l_pairs_0(v1053[v1069]) do
                if v1071 == "t" then
                    v1068(v1055[v1069], v1071, v1072);
                elseif l_skip_0[v1071] == nil then
                    if v962(v1072) == "table" then
                        for v1073, v1074 in l_pairs_0(v1072) do
                            if l_type_0(v1074) == "table" then
                                for v1075, v1076 in l_pairs_0(v1074) do
                                    if l_type_0(v1076) == "table" then
                                        for v1077 = 1, #v1076 do
                                            v1068(v1055.anti_aim.builder[v1073], v1075 .. v1077, v1076[v1077]);
                                        end;
                                    else
                                        v1068(v1055.anti_aim.builder[v1073], v1075, v1076);
                                    end;
                                end;
                            end;
                        end;
                    else
                        v1068(v1055[v1069], v1071, v1072);
                    end;
                end;
            end;
        end;
        local v1078 = ("celestia_eyJBZGQgcGhhc2UgY%s_celestia"):format(v182.encode(l_stringify_0(v1055)));
        if v1054 ~= nil then
            return v1078;
        else
            v126.set(v1078);
            v960.visuals:log_push(l_get_style_0("Link Active"), "Config successfully exported!");
            l_console_exec_0("play ui/beepclear");
            return;
        end;
    end, 
    change_style = function(_)
        -- upvalues: l_get_alpha_0 (ref), v960 (ref)
        if l_get_alpha_0() ~= 0 then
            v960.visuals:sidebar();
        end;
    end, 
    import_data = function(v1080, v1081)
        -- upvalues: l_execute_after_1 (ref), v126 (ref), v182 (ref), l_pcall_0 (ref), v960 (ref), l_get_style_0 (ref), l_console_exec_0 (ref), l_pairs_0 (ref), l_type_0 (ref), l_insert_0 (ref), l_color_0 (ref), l_tostring_0 (ref)
        l_execute_after_1(0.3, function()
            -- upvalues: v1081 (ref), v126 (ref), v182 (ref), l_pcall_0 (ref), v960 (ref), l_get_style_0 (ref), l_console_exec_0 (ref), v1080 (ref), l_pairs_0 (ref), l_type_0 (ref), l_insert_0 (ref), l_color_0 (ref), l_tostring_0 (ref)
            local v1082 = nil;
            v1082 = (v1081 or v126.get() or ""):gsub("celestia_eyJBZGQgcGhhc2UgY", ""):gsub("_celestia", ""):gsub("_celesti", ""):gsub("_celest", "");
            v1082 = v182.decode(v1082:match("[%w%+%/]+%=*"));
            local v1083, v1084 = l_pcall_0(json.parse, v1082);
            if not v1083 then
                v960.visuals:log_push(l_get_style_0("Link Active"), "Your JSON-config is wrong!");
                l_console_exec_0("play resource/warning");
                return;
            else
                local v1085 = v1084 and v1080.general.skip;
                local l_l_pairs_0_0 = l_pairs_0;
                local v1087 = v1084 or {};
                for v1088, v1089 in l_l_pairs_0_0(v1087) do
                    do
                        local l_v1089_0 = v1089;
                        if (not v1085:get("Anti Aim") or v1085:get("Visuals") or v1085:get("Misc") or v1088 ~= "anti_aim") and (v1085:get("Anti Aim") or not v1085:get("Visuals") or v1085:get("Misc") or v1088 ~= "visuals") and (v1085:get("Anti Aim") or v1085:get("Visuals") or not v1085:get("Misc") or v1088 ~= "miscellaneous") and (not v1085:get("Anti Aim") or not v1085:get("Visuals") or v1085:get("Misc") or v1088 ~= "anti_aim" and v1088 ~= "visuals") and (not v1085:get("Anti Aim") or v1085:get("Visuals") or not v1085:get("Misc") or v1088 ~= "anti_aim" and v1088 ~= "miscellaneous") and (v1085:get("Anti Aim") or not v1085:get("Visuals") or not v1085:get("Misc") or v1088 ~= "visuals" and v1088 ~= "miscellaneous") then
                            if v1085:get("Anti Aim") and v1085:get("Visuals") and v1085:get("Misc") then
                                v960.visuals:log_push(l_get_style_0("Link Active"), "You can't skip all the elements!");
                                l_console_exec_0("play resource/warning");
                                return;
                            else
                                local l_l_pairs_0_1 = l_pairs_0;
                                local v1092 = l_v1089_0 or {};
                                for v1093, v1094 in l_l_pairs_0_1(v1092) do
                                    local v1095 = v1080[v1088][v1093];
                                    local l_v1094_0 = v1094;
                                    do
                                        local l_v1094_1 = v1094;
                                        do
                                            local l_v1095_0 = v1095;
                                            if l_v1095_0 ~= nil then
                                                if v1088 ~= "anti_aim" then
                                                    if v1085:get("View") and (v1093:find("viewmodel") or v1093:find("aspect_ratio") or v1093:find("opposite_knife")) then
                                                        --[[ close >= 9 ]]
                                                        break;
                                                    elseif l_v1095_0:list() ~= nil and l_type_0(l_v1094_1) == "table" and l_type_0(l_v1095_0:get(l_v1095_0:list()[1])) == "table" then
                                                        local v1099 = {};
                                                        local l_l_pairs_0_2 = l_pairs_0;
                                                        local v1101 = l_v1094_0.name and l_v1094_1.value or l_v1094_1;
                                                        for v1102, v1103 in l_l_pairs_0_2(v1101) do
                                                            if not v1099[v1102] then
                                                                v1099[v1102] = {};
                                                            end;
                                                            for _, v1105 in l_pairs_0(v1103) do
                                                                l_insert_0(v1099[v1102], l_color_0(v1105));
                                                            end;
                                                        end;
                                                        l_v1094_1 = v1099;
                                                        l_v1095_0:update(l_v1094_1);
                                                    end;
                                                end;
                                                if l_tostring_0(l_v1095_0):find("color_picker") then
                                                    l_v1094_1 = l_color_0(l_v1094_1);
                                                end;
                                                if l_type_0(l_v1095_0) == "table" then
                                                    local v1106 = {};
                                                    for v1107, v1108 in l_pairs_0(l_v1094_1) do
                                                        v1106[v1107] = {};
                                                        for v1109, v1110 in l_pairs_0(v1108) do
                                                            v1106[v1107][v1109] = v1110;
                                                        end;
                                                    end;
                                                    for v1111, v1112 in l_pairs_0(l_v1095_0) do
                                                        for v1113, v1114 in l_pairs_0(v1112) do
                                                            if l_type_0(v1114) == "table" then
                                                                for v1115 = 1, #v1114 do
                                                                    if v1106[v1111] ~= nil and v1106[v1111][v1113 .. v1115] ~= nil then
                                                                        v1114[v1115]:set(v1106[v1111][v1113 .. v1115]);
                                                                    end;
                                                                end;
                                                            elseif l_type_0(v1114) == "userdata" and v1106[v1111] ~= nil and v1106[v1111][v1113] ~= nil then
                                                                v1114:set(v1106[v1111][v1113]);
                                                            end;
                                                        end;
                                                    end;
                                                else
                                                    l_pcall_0(function()
                                                        -- upvalues: l_v1095_0 (ref), l_v1094_1 (ref)
                                                        l_v1095_0:set(l_v1094_1);
                                                    end);
                                                end;
                                                if v1093 == "lc_aa_on" and v1088 == "anti_aim" and l_v1089_0.t then
                                                    utils.execute_after(0.2, function()
                                                        -- upvalues: l_v1095_0 (ref), l_v1089_0 (ref)
                                                        l_v1095_0:set(l_v1089_0.t.last_val);
                                                    end);
                                                end;
                                            end;
                                            if l_v1095_0 ~= nil and l_type_0(l_v1095_0) ~= "table" and l_type_0(l_v1094_1) == "table" and l_v1095_0:list() ~= nil and l_type_0(l_v1095_0:get(l_v1095_0:list()[1])) == "table" then
                                                l_v1095_0:set(l_v1094_0.name);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v960.visuals:log_push(l_get_style_0("Link Active"), "Config successfully loaded!");
                l_console_exec_0("play ui/beepclear");
                return;
            end;
        end);
    end, 
    config_data = v967.configs or {}, 
    config_list = {
        data = {}, 
        name = {}
    }, 
    load_config = function(v1116, v1117)
        -- upvalues: l_pairs_0 (ref)
        for v1118, v1119 in l_pairs_0(v1116.config_data) do
            if v1118 == v1117 then
                v1116:import_data(v1119, true);
            end;
        end;
    end, 
    update_list = function(v1120)
        -- upvalues: l_pairs_0 (ref), l_insert_0 (ref)
        v1120.config_list = {
            data = {}, 
            name = {}
        };
        for v1121, _ in l_pairs_0(v1120.config_data) do
            l_insert_0(v1120.config_list.name, v1121);
        end;
        v1120.general.local_configs:update(#v1120.config_list.name == 0 and "There is no Configurations." or v1120.config_list.name);
        local v1123 = v1120.general.local_configs:list()[v1120.general.local_configs:get()] or "There is no Configurations.";
        v1120.general.config_name:set(v1123 == "There is no Configurations." and "celestia config" or v1123);
    end, 
    delete_config = function(v1124, v1125)
        -- upvalues: l_pairs_0 (ref), v967 (ref), v960 (ref), l_get_style_0 (ref), l_console_exec_0 (ref)
        for v1126, _ in l_pairs_0(v1124.config_data) do
            if v1126 == v1125 then
                v1124.config_data[v1125] = nil;
            end;
        end;
        v967.configs = v1124.config_data;
        v1124:update_list();
        v960.visuals:log_push(l_get_style_0("Link Active"), "Config successfully deleted!");
        l_console_exec_0("play ui/beepclear");
    end, 
    create_config = function(v1128, v1129)
        -- upvalues: v967 (ref), v960 (ref), l_get_style_0 (ref), l_console_exec_0 (ref)
        if v1128:export_data(1) == nil then
            return;
        else
            if v1129:gsub(" ", "") == "" then
                local l_username_0 = v1128.username;
                if l_username_0 then
                    v1129 = l_username_0;
                end;
            end;
            v1128.config_data[v1129] = v1128:export_data(1);
            v967.configs = v1128.config_data;
            v1128:update_list();
            v960.visuals:log_push(l_get_style_0("Link Active"), "Config successfully saved!");
            l_console_exec_0("play ui/beepclear");
            return;
        end;
    end
}):struct("animation_breakers")({
    end_time = 0, 
    ground_ticks = 1, 
    get_anim_overlay = function(_, v1132, v1133)
        -- upvalues: l_cast_0 (ref), l_typeof_0 (ref), l_get_local_player_0 (ref)
        if not v1133 then
            v1133 = 1;
        end;
        if l_cast_0(l_typeof_0("void***"), v1132) == l_cast_0(l_typeof_0("void***"), l_get_local_player_0()[0]) then
            v1132 = l_get_local_player_0()[0];
        else
            v1132 = l_cast_0(l_typeof_0("void***"), v1132);
        end;
        return l_cast_0("c_animlayers**", l_cast_0("char*", v1132) + 10640)[0][v1133];
    end, 
    animation_breakers = function(v1134, v1135, v1136)
        -- upvalues: l_get_local_player_0 (ref), v164 (ref), l_band_0 (ref)
        if not v1136.menu.anti_aim.anim_breakers:get() then
            return;
        else
            local v1137 = l_get_local_player_0();
            if v1137 == nil then
                return;
            elseif v1135 ~= v1137 then
                return;
            elseif not v1137:is_alive() then
                return;
            elseif v1137[0] == nil then
                return;
            elseif v1137.m_MoveType == 8 or v1137.m_MoveType == 9 then
                return;
            else
                if v1136.menu.anti_aim.anim_on_land:get() == "Follow Direction" then
                    v1137.m_flPoseParameter[0] = 1;
                    v164.leg_movement:override("Sliding");
                elseif v1136.menu.anti_aim.anim_on_land:get() == "Moon Walk" then
                    v1137.m_flPoseParameter[7] = 1;
                    v164.leg_movement:override("Walking");
                end;
                if v1136.menu.anti_aim.anim_in_air:get() == "Static Legs" then
                    v1137.m_flPoseParameter[6] = 1;
                elseif v1136.menu.anti_aim.anim_in_air:get() == "Moon Walk" then
                    local v1138 = v1134:get_anim_overlay(v1137[0], 6);
                    if not v1138 then
                        return;
                    else
                        local l_m_vecVelocity_0 = v1137.m_vecVelocity;
                        l_m_vecVelocity_0.z = 0;
                        if l_m_vecVelocity_0:length() >= 5 then
                            v1138.weight = 1;
                            v1137.m_flPoseParameter[6] = 1;
                            v1137.m_flPoseParameter[7] = 1;
                        end;
                    end;
                end;
                if v1136.menu.anti_aim.anim_other:get("Body Lean") and v1137.m_vecVelocity:length() >= 3 then
                    local v1140 = v1134:get_anim_overlay(v1137[0], 12);
                    if not v1140 then
                        return;
                    else
                        v1140.weight = v1136.menu.anti_aim.weight_value:get() == 99 and 0 or v1137:get_anim_overlay(12).weight * (v1136.menu.anti_aim.weight_value:get() * 0.01);
                    end;
                end;
                if v1136.menu.anti_aim.anim_other:get("Pitch Zero on Land") then
                    if l_band_0(v1137.m_fFlags, 1) == 1 then
                        v1134.ground_ticks = v1134.ground_ticks + 1;
                    else
                        v1134.ground_ticks = 0;
                        v1134.end_time = globals.curtime + 1;
                    end;
                    if v1134.ground_ticks > v164.fl_limit:get() + 1 and v1134.end_time > globals.curtime then
                        v1137.m_flPoseParameter[12] = 0.5;
                    end;
                end;
                if v1136.menu.anti_aim.anim_other:get("Sliding Slowwalk") and v164.slow_walk:get() then
                    v1137.m_flPoseParameter[9] = 0;
                    v164.leg_movement:override("Walking");
                end;
                if v1136.menu.anti_aim.anim_other:get("Sliding Crouch") then
                    v1137.m_flPoseParameter[8] = 0;
                end;
                return;
            end;
        end;
    end, 
    reset_data = function(v1141)
        v1141.ground_ticks = 1;
        v1141.end_time = 0;
    end
});
v1142.menu:load_menu();
v1142.menu.general.local_configs:set_callback(function()
    -- upvalues: v1142 (ref)
    return v1142.menu:update_list();
end, true);
v960.visuals:dragging_fn().register(v1142.menu.visuals.watermark_x, v1142.menu.visuals.watermark_y, 120, 20, function(v1143)
    -- upvalues: v1142 (ref), v960 (ref)
    v1142.menu.show_more[1] = v960.visuals:watermark(v1143, v1142);
end);
v960.visuals:dragging_fn().register(v1142.menu.visuals.keybinds_x, v1142.menu.visuals.keybinds_y, 100, 20, function(v1144)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:keybinds(v1144, v1142);
end);
v960.visuals:dragging_fn().register(v1142.menu.visuals.spectators_x, v1142.menu.visuals.spectators_y, 100, 20, function(v1145)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:spectators(v1145, v1142);
end);
v960.visuals:dragging_fn().register(v1142.menu.visuals.slowdown_x, v1142.menu.visuals.slowdown_y, 100, 20, function(v1146)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:slowdown(v1146, v1142);
end);
v960.visuals:dragging_fn():execute(v1142);
for _, v1148 in l_pairs_0({
    [1] = "bomb_abortplant", 
    [2] = "bomb_defused", 
    [3] = "bomb_planted", 
    [4] = "round_start"
}) do
    events[v1148](function(v1149)
        -- upvalues: v960 (ref)
        v960.visuals:clear_planting_info(v1149);
    end);
end;
l_bomb_beginplant_0(function(v1150)
    -- upvalues: v960 (ref)
    v960.visuals:bomb_beginplant(v1150);
end);
v1142.menu.show_more[2] = false;
l_round_start_0(function()
    -- upvalues: v1142 (ref), v960 (ref)
    v1142.animation_breakers:reset_data();
    v960.visuals:execute_player_data();
end);
l_aim_fire_0(function(_)
    -- upvalues: v960 (ref)
    v960.anti_aim:flick_fix();
end);
local v1152 = "";
local v1153 = nil;
l_createmove_0(function(v1154)
    -- upvalues: v1153 (ref), l_random_0 (ref), v960 (ref), v1152 (ref), v1142 (ref)
    if globals.choked_commands == 0 then
        v1153 = rage.antiaim:inverter();
    end;
    local v1155 = {
        [2] = {
            [1] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 60, 
                [10] = 60, 
                [3] = not v1153 and -23 or 51, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [2] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -20 or 50, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [3] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -23 or 51, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [4] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -13 or 34, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [5] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -15 or 44, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [6] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -20 or 30, 
                [7] = {
                    [1] = "Jitter"
                }
            }
        }, 
        [3] = {
            [1] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Center", 
                [5] = -17, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 60, 
                [10] = 60, 
                [3] = not v1153 and -3 or 17, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [2] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Center", 
                [5] = -56, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 60, 
                [10] = 60, 
                [3] = not v1153 and -10 or 10, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [3] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = 44, 
                [4] = "Offset", 
                [5] = nil, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 60, 
                [10] = 60, 
                [5] = -78 + l_random_0(-14, 14), 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [4] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -13 or 34, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [5] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 58, 
                [10] = 58, 
                [3] = not v1153 and -15 or 44, 
                [7] = {
                    [1] = "Jitter"
                }
            }, 
            [6] = {
                [1] = "Down", 
                [2] = "Backward", 
                [3] = nil, 
                [4] = "Disabled", 
                [5] = 0, 
                [6] = true, 
                [7] = nil, 
                [8] = "Off", 
                [9] = 60, 
                [10] = 60, 
                [3] = not v1153 and -23 or 40, 
                [7] = {
                    [1] = "Jitter"
                }
            }
        }
    };
    v960.anti_aim:get_inverter_side();
    v1152 = v960.anti_aim:createmove(v1154, v1142, v1155);
    v960.visuals:update_defensive_state(v1154);
    v960.visuals:custom_hitchance(v1152, v1142);
    v960.anti_aim:edge_bug(v1154, v1142);
    v960.visuals:dormant_aimbot_run(v1154, v1142);
end);
events.post_update_clientside_animation(function(v1156)
    -- upvalues: v1142 (ref)
    if v1142.menu.anti_aim.anim_breakers:get() and (v1142.menu.anti_aim.anim_on_land:get() ~= "Disabled" or v1142.menu.anti_aim.anim_in_air:get() ~= "Disabled" or #v1142.menu.anti_aim.anim_other:get() > 0) then
        v1142.animation_breakers:animation_breakers(v1156, v1142);
    end;
end);
v960.visuals.opposite_knife_hand_f = function()
    -- upvalues: v960 (ref), v1142 (ref)
    return v960.visuals:opposite_knife_hand(v1142);
end;
v1142.menu.visuals.viewmodel:set_callback(function()
    -- upvalues: v1142 (ref), v960 (ref), l_createmove_0 (ref)
    v1142.menu.visuals.opposite_knife:set_callback(function()
        -- upvalues: v1142 (ref), v960 (ref), l_createmove_0 (ref)
        if not v1142.menu.visuals.viewmodel:get() or not v1142.menu.visuals.opposite_knife:get() then
            cvar.cl_righthand:int(v960.visuals.viewmodel_data[5]);
            l_createmove_0:unset(v960.visuals.opposite_knife_hand_f);
        else
            l_createmove_0:set(v960.visuals.opposite_knife_hand_f);
        end;
    end, true);
end, true);
for _, v1158 in l_pairs_0({
    [1] = "viewmodel", 
    [2] = "viewmodel_fov", 
    [3] = "viewmodel_x", 
    [4] = "viewmodel_y", 
    [5] = "viewmodel_z", 
    [6] = "viewmodel_reset"
}) do
    do
        local l_v1158_0 = v1158;
        v1142.menu.visuals[l_v1158_0]:set_callback(function()
            -- upvalues: l_v1158_0 (ref), v1142 (ref), v960 (ref)
            if l_v1158_0 ~= "viewmodel_reset" then
                if v1142.menu.visuals.viewmodel:get() then
                    v960.visuals:set_viewmodel({
                        v1142.menu.visuals.viewmodel_fov:get(), 
                        v1142.menu.visuals.viewmodel_x:get(), 
                        v1142.menu.visuals.viewmodel_y:get(), 
                        v1142.menu.visuals.viewmodel_z:get()
                    });
                else
                    v960.visuals:set_viewmodel(v960.visuals.viewmodel_data);
                end;
            else
                v1142.menu.visuals.viewmodel_fov:set(v960.visuals.viewmodel_data[1]);
                v1142.menu.visuals.viewmodel_x:set(v960.visuals.viewmodel_data[2]);
                v1142.menu.visuals.viewmodel_y:set(v960.visuals.viewmodel_data[3]);
                v1142.menu.visuals.viewmodel_z:set(v960.visuals.viewmodel_data[4]);
            end;
        end, true);
    end;
end;
l_mouse_input_0(function(v1160)
    -- upvalues: v960 (ref), v1142 (ref)
    if not v960.visuals.is_in_area.watermark and not v960.visuals.is_in_area.keybinds and not v960.visuals.is_in_area.spectators and not v960.visuals.is_in_area.slowdown and not v960.visuals.is_in_area.gamesense then
        return;
    else
        v1142.menu.visuals.dpi_scale:set(v1142.menu.visuals.dpi_scale:get() + v1160.wheel);
        return false;
    end;
end);
l_render_0(function()
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:crosshair_indicators(v1142);
    v960.visuals:log_paint(v1142);
    v960.visuals.dpi_scale:update(v1142);
    v960.visuals:gs_indicators(v1142);
    v960.visuals:marker_paint(v1142);
    v960.visuals:scope_paint(v1142);
    v960.visuals:radius_paint(v1142);
    v960.visuals:crosshair_marker(v1142);
    v960.visuals:pluses_marker(v1142);
    v960.visuals:anti_aim_arrows(v1142);
    if v1142.menu.visuals.grenade_modulation:get() and v1142.menu.visuals.grenade_prediction:get() then
        v960.visuals:grenade_prediction();
    end;
    v960.visuals:dormant_aimbot_paint(v1142);
end);
local v1161 = 0;
l_pre_render_0(function()
    -- upvalues: v960 (ref), v1142 (ref), v1161 (ref)
    v960.visuals:clear_warning_info();
    v1142.menu:change_style();
    if globals.realtime > v1161 then
        v960.visuals:execute_player_data();
        v1161 = globals.realtime + 30;
    end;
    v960.visuals:clantag(v1142);
    if v1142.menu.miscellaneous.console_modifier:get() then
        v960.visuals:console_modifier("pre_render", v1142);
    end;
    v960.visuals:control_queue(v1142);
    v960.visuals:animate_configs(v1142);
    if not globals.is_connected then
        v1142.animation_breakers:reset_data();
    end;
end);
local v1162 = {
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
    [10] = "gear", 
    [11] = "?"
};
l_aim_ack_0(function(v1163)
    -- upvalues: v1142 (ref), v1162 (ref), l_format_1 (ref), v960 (ref), l_max_0 (ref), l_insert_0 (ref), l_color_0 (ref)
    if v1142.menu.visuals.aimbot_logs:get() and v1142.menu.visuals.logs_type:get("Aimbot Shots") then
        local v1164 = v1162[v1163.wanted_hitgroup or 11] or "?";
        local v1165 = v1162[v1163.hitgroup or 11] or "?";
        local v1166 = v1163.target:get_name():gsub("\n", "");
        do
            local l_v1164_0, l_v1165_0 = v1164, v1165;
            if not v1163.state then
                local v1169 = "\a" .. v1142.menu.visuals.logs_color:get("\208\157it")[1]:modulate_alpha(255):to_hex();
                do
                    local l_v1169_0 = v1169;
                    local v1175 = (function()
                        -- upvalues: l_v1165_0 (ref), l_v1164_0 (ref), v1163 (ref), l_format_1 (ref), l_v1169_0 (ref)
                        local v1171 = "";
                        local v1172 = l_v1165_0 ~= l_v1164_0;
                        local v1173 = v1163.damage ~= v1163.wanted_damage;
                        if v1172 or v1173 then
                            v1171 = l_format_1(" | wanted in %s", (function()
                                -- upvalues: l_v1169_0 (ref), l_v1164_0 (ref), v1163 (ref)
                                local _ = "";
                                return (("%s%s\aDEFAULT: %s%i\aDEFAULThp"):format(l_v1169_0, l_v1164_0, l_v1169_0, v1163.wanted_damage));
                            end)());
                        end;
                        return v1171;
                    end)();
                    local v1176 = ("[%sCELESTIA\aDEFAULT] Hit %s%s\aDEFAULT in %s%s\aDEFAULT for %s%i\aDEFAULT health [ bt: ~%s%i\aDEFAULTms(%s%i\aDEFAULTt)%s | hc: %s%i\aDEFAULT%% ]"):format(l_v1169_0, l_v1169_0, v1166, l_v1169_0, l_v1165_0, l_v1169_0, v1163.damage, l_v1169_0, 0.015625 * v1163.backtrack * 1000, l_v1169_0, v1163.backtrack, v1175, l_v1169_0, v1163.hitchance);
                    if v1142.menu.visuals.logs_display:get("Console") then
                        print_raw(v1176);
                    end;
                    if v1142.menu.visuals.logs_display:get("Top Left") then
                        v960.visuals:print_log(v1176:sub(29));
                    end;
                    if v1142.menu.visuals.logs_display:get("On Center") then
                        local v1177 = "\a" .. v1142.menu.visuals.logs_color:get("\208\157it")[1]:modulate_alpha(255):to_hex();
                        local v1178 = ("%s %s%s\aDEFAULT in %s%s\aDEFAULT [ bt: ~%s%i\aDEFAULTms(%s%i\aDEFAULTt) | hc: %s%i\aDEFAULT%% ]"):format(l_max_0(0, v1163.target.m_iHealth) == 0 and "Killed" or "Hit", v1177, v1166, v1177, l_v1165_0, v1177, 0.015625 * v1163.backtrack * 1000, v1177, v1163.backtrack, v1177, v1163.hitchance):gsub("\n", "");
                        v960.visuals:log_push(v1142.menu.visuals.logs_color:get("\208\157it")[1]:modulate_alpha(255), v1178);
                    end;
                    if v1142.menu.visuals.logs_display:get("Crosshair") then
                        l_insert_0(v960.visuals.cmarker_data, {
                            offset = 0, 
                            color = l_color_0(255, 200), 
                            time = globals.curtime
                        });
                    end;
                    if v1142.menu.visuals.logs_display:get("Pluses") then
                        l_insert_0(v960.visuals.pluses_data, {
                            offset = 0, 
                            color = v1142.menu.visuals.logs_color:get("\208\157it")[1]:modulate_alpha(255), 
                            vector = v1163.aim, 
                            time = globals.curtime
                        });
                    end;
                end;
            else
                local v1179 = "\a" .. v1142.menu.visuals.logs_color:get("\208\156iss")[1]:modulate_alpha(255):to_hex();
                local v1180 = ("[%sCELESTIA\aDEFAULT] Missed %s%s\aDEFAULT in %s%s\aDEFAULT due to %s%s\aDEFAULT for %s%i\aDEFAULT health [ bt: ~%s%i\aDEFAULTms(%s%i\aDEFAULTt) | hc: %s%i\aDEFAULT%% ]"):format(v1179, v1179, v1166, v1179, l_v1164_0, v1179, v1163.state, v1179, v1163.wanted_damage, v1179, 0.015625 * v1163.backtrack * 1000, v1179, v1163.backtrack, v1179, v1163.hitchance):gsub("\n", "");
                if v1142.menu.visuals.logs_display:get("Console") then
                    print_raw(v1180);
                end;
                if v1142.menu.visuals.logs_display:get("Top Left") then
                    v960.visuals:print_log(v1180:sub(29));
                end;
                if v1142.menu.visuals.logs_display:get("On Center") then
                    local v1181 = "\a" .. v1142.menu.visuals.logs_color:get("\208\156iss")[1]:modulate_alpha(255):to_hex();
                    local v1182 = ("Missed %s%s\aDEFAULT due to %s%s\aDEFAULT [ bt: ~%s%i\aDEFAULTms(%s%i\aDEFAULTt) | hc: %s%i\aDEFAULT%% ]"):format(v1181, v1166, v1181, v1163.state, v1181, 0.015625 * v1163.backtrack * 1000, v1181, v1163.backtrack, v1181, v1163.hitchance):gsub("\n", "");
                    v960.visuals:log_push(v1142.menu.visuals.logs_color:get("\208\156iss")[1]:modulate_alpha(255), v1182);
                end;
                if v1142.menu.visuals.logs_display:get("Pluses") then
                    l_insert_0(v960.visuals.pluses_data, {
                        offset = 0, 
                        color = v1142.menu.visuals.logs_color:get("\208\156iss")[1]:modulate_alpha(255), 
                        vector = v1163.aim, 
                        time = globals.curtime
                    });
                end;
            end;
        end;
    end;
    v960.visuals:gs_aim_ack(v1163);
end);
local v1183 = {
    hegrenade = "Exploded", 
    inferno = "Burned", 
    knife = "Knifed"
};
l_player_hurt_0(function(v1184)
    -- upvalues: v960 (ref), v1142 (ref), l_get_local_player_0 (ref), l_get_0 (ref), v1183 (ref), l_pairs_0 (ref)
    v960.visuals:dormant_aimbot_hurt(v1184, v1142);
    v960.visuals:marker_hurt(v1184, v1142);
    if v1142.menu.visuals.aimbot_logs:get() and v1142.menu.visuals.logs_type:get("Aimbot Shots") then
        local v1185 = l_get_local_player_0();
        local v1186 = l_get_0(v1184.userid, true);
        local v1187 = l_get_0(v1184.attacker, true);
        if not v1186 or not v1187 or v1187 ~= v1185 then
            return;
        else
            local v1188 = v1183[v1184.weapon];
            if v1188 then
                local v1189 = "\a" .. v1142.menu.visuals.logs_color:get("Other")[1]:modulate_alpha(255):to_hex();
                local v1190 = ("[%sCELESTIA\aDEFAULT] %s %s%s\aDEFAULT for %s%i\aDEFAULT damage (%s%i\aDEFAULT remaining)"):format(v1189, v1188, v1189, v1186:get_name(), v1189, v1184.dmg_health, v1189, v1184.health):gsub("\n", "");
                if v1142.menu.visuals.logs_display:get("Console") then
                    print_raw(v1190);
                end;
                if v1142.menu.visuals.logs_display:get("Top Left") then
                    v960.visuals:print_log(v1190:sub(29));
                end;
                if v1142.menu.visuals.logs_display:get("On Center") then
                    local v1191 = 0;
                    for v1192, v1193 in l_pairs_0(v960.visuals.logs_data) do
                        if v1193.userid == v1186 and v1193.prefix == "Burned" then
                            v1191 = v1192;
                        end;
                    end;
                    if v1191 == 0 or v1188 ~= "Burned" then
                        local v1194 = "\a" .. v1142.menu.visuals.logs_color:get("Other")[1]:modulate_alpha(255):to_hex();
                        local v1195 = ("%s %s%s\aDEFAULT for %s%i\aDEFAULT damage (%s%i\aDEFAULT %s)"):format(v1188, v1194, v1186:get_name(), v1194, v1184.dmg_health, v1194, v1184.health, v1188 == "Burned" and "remaining" or "r\208\181maining"):gsub("\n", "");
                        v960.visuals:log_push(v1142.menu.visuals.logs_color:get("Other")[1]:modulate_alpha(255), v1195, {
                            [1] = v1186, 
                            [2] = v1188, 
                            [3] = v1184.dmg_health
                        });
                    else
                        v960.visuals.logs_data[v1191].damage = v960.visuals.logs_data[v1191].damage + v1184.dmg_health;
                    end;
                end;
            end;
        end;
    end;
end);
l_item_purchase_0:set(function(v1196)
    -- upvalues: v1142 (ref), l_get_local_player_0 (ref), l_get_0 (ref), v960 (ref)
    if v1142.menu.visuals.aimbot_logs:get() and v1142.menu.visuals.logs_type:get("Purchases") then
        local v1197 = l_get_local_player_0();
        local v1198 = l_get_0(v1196.userid, true);
        if not v1198 then
            return;
        elseif v1197 and v1198 ~= v1197 and v1198:is_enemy() then
            if v1196.weapon == "weapon_unknown" then
                return;
            else
                local v1199 = "\a" .. v1142.menu.visuals.logs_color:get("Other")[1]:modulate_alpha(255):to_hex();
                local v1200 = ("[%sCELESTIA\aDEFAULT] %s%s \aDEFAULTbought \a%s%s"):format(v1199, v1199, v1198:get_name() or "?", v1199, v1196.weapon or "?"):gsub("\n", "");
                if v1142.menu.visuals.logs_display:get("Console") then
                    print_raw(v1200);
                end;
                if v1142.menu.visuals.logs_display:get("Top Left") then
                    v960.visuals:print_log(v1200:sub(29));
                end;
                if v1142.menu.visuals.logs_display:get("On Center") then
                    v960.visuals:log_push(v1142.menu.visuals.logs_color:get("Other")[1]:modulate_alpha(255), v1200);
                end;
            end;
        end;
    end;
end);
l_player_death_0(function(v1201)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:dormant_aimbot_death(v1201, v1142);
    v960.visuals:add_in_kill_queue(v1201, v1142);
end);
local v1202 = {};
local v1203 = {
    [1] = {
        [1] = "r_shadows", 
        [2] = 0
    }, 
    [2] = {
        [1] = "violence_hblood", 
        [2] = 0
    }, 
    [3] = {
        [1] = "cl_csm_rope_shadows", 
        [2] = 0
    }, 
    [4] = {
        [1] = "cl_csm_sprite_shadows", 
        [2] = 0
    }, 
    [5] = {
        [1] = "cl_foot_contact_shadows", 
        [2] = 0
    }, 
    [6] = {
        [1] = "cl_csm_viewmodel_shadows", 
        [2] = 0
    }, 
    [7] = {
        [1] = "cl_csm_static_prop_shadows", 
        [2] = 0
    }, 
    [8] = {
        [1] = "r_3dsky", 
        [2] = 0
    }, 
    [9] = {
        [1] = "r_drawrain", 
        [2] = 0
    }, 
    [10] = {
        [1] = "r_drawropes", 
        [2] = 0
    }, 
    [11] = {
        [1] = "r_drawsprites", 
        [2] = 0
    }, 
    [12] = {
        [1] = "fog_enable_water_fog", 
        [2] = 0
    }, 
    [13] = {
        [1] = "func_break_max_pieces", 
        [2] = 0
    }, 
    [14] = {
        [1] = "r_dynamic", 
        [2] = 0
    }, 
    [15] = {
        [1] = "dsp_slow_cpu", 
        [2] = 1
    }, 
    [16] = {
        [1] = "r_dynamiclighting", 
        [2] = 0
    }, 
    [17] = {
        [1] = "mat_disable_bloom", 
        [2] = 1
    }, 
    [18] = {
        [1] = "cl_disable_ragdolls", 
        [2] = 1
    }, 
    [19] = {
        [1] = "r_eyemove", 
        [2] = 0
    }, 
    [20] = {
        [1] = "r_eyesize", 
        [2] = 0
    }, 
    [21] = {
        [1] = "r_eyegloss", 
        [2] = 0
    }, 
    [22] = {
        [1] = "r_eyeshift_x", 
        [2] = 0
    }, 
    [23] = {
        [1] = "r_eyeshift_y", 
        [2] = 0
    }, 
    [24] = {
        [1] = "r_eyeshift_z", 
        [2] = 0
    }, 
    [25] = {
        [1] = "muzzleflash_light", 
        [2] = 0
    }, 
    [26] = {
        [1] = "cl_disablehtmlmotd", 
        [2] = 1
    }, 
    [27] = {
        [1] = "r_drawtracers_firstperson", 
        [2] = 0
    }
};
for _, v1205 in l_pairs_0(v1203) do
    v1202[v1205[1]] = cvar[v1205[1]]:int();
end;
v1142.menu.miscellaneous.console_modifier:set_callback(function(v1206)
    -- upvalues: v960 (ref), v1142 (ref), l_pairs_0 (ref)
    if not v1206:get() then
        v960.visuals:console_modifier("shutdown", v1142);
    elseif v960.visuals.console_is_visible(v960.visuals.engine_client) then
        for _, v1208 in l_pairs_0(v960.visuals.materials) do
            materials.get_materials(v1208)[1]:alpha_modulate(v1142.menu.miscellaneous.console_color:get().a / 255);
            materials.get_materials(v1208)[1]:color_modulate(v1142.menu.miscellaneous.console_color:get());
        end;
    end;
end, true);
v1142.menu.miscellaneous.console_color:set_callback(function()
    -- upvalues: v1142 (ref), v960 (ref), l_pairs_0 (ref)
    if not v1142.menu.miscellaneous.console_modifier:get() then
        v960.visuals:console_modifier("shutdown", v1142);
    elseif v960.visuals.console_is_visible(v960.visuals.engine_client) then
        for _, v1210 in l_pairs_0(v960.visuals.materials) do
            materials.get_materials(v1210)[1]:alpha_modulate(v1142.menu.miscellaneous.console_color:get().a / 255);
            materials.get_materials(v1210)[1]:color_modulate(v1142.menu.miscellaneous.console_color:get());
        end;
    end;
end, true);
v1142.menu.miscellaneous.players_mute:set_callback(function(_)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:unmute_players(v1142);
end, true);
v1142.menu.miscellaneous.players_mute_type:set_callback(function(_)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:unmute_players(v1142);
end, true);
l_player_connect_full_0(function()
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:unmute_players(v1142);
end);
l_weapon_fire_0(function(v1213)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:dormant_aimbot_fire(v1213, v1142);
end);
l_grenade_override_view_0(function(v1214)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.anti_aim:super_toss_line(v1214, v1142);
end);
l_grenade_warning_0(function(v1215)
    -- upvalues: v1142 (ref), v960 (ref)
    if not v1142.menu.visuals.grenade_modulation:get() then
        return;
    elseif v1142.menu.visuals.grenade_warning:get() then
        v960.visuals:grenade_warning(v1215);
        return false;
    else
        return;
    end;
end);
l_grenade_prediction_0(function(v1216)
    -- upvalues: v960 (ref), v1142 (ref)
    v960.anti_aim:collect_prediction_data(v1216);
    if not v1142.menu.visuals.grenade_modulation:get() then
        return;
    elseif v1142.menu.visuals.grenade_prediction:get() then
        v960.visuals:collect_prediction_data(v1216);
        return false;
    else
        return;
    end;
end);
l_round_start_0(function()
    -- upvalues: v960 (ref), v1142 (ref)
    v960.visuals:dormant_aimbot_reset(e, v1142);
end);