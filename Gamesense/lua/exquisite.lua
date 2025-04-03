local globals_tickcount, globals_realtime, ui_set_visible, math_min, math_max, renderer_line, client_trace_line, math_sqrt, math_floor, entity_get_prop, entity_get_origin, globals_tickinterval, globals_curtime, entity_hitbox_position, entity_set_prop, client_trace_bullet = globals.tickcount, globals.realtime, ui.set_visible, math.min, math.max, renderer.line, client.trace_line, math.sqrt, math.floor, entity.get_prop, entity.get_origin, globals.tickinterval, globals.curtime, entity.hitbox_position, entity.set_prop, client.trace_bullet
local entity_is_alive, ui_mouse_position, entity_get_local_player, math_deg, math_atan2, math_rad, math_sin, math_cos, math_acos, entity_get_players, client_camera_angles, client_eye_position, entity_is_enemy, entity_is_dormant = entity.is_alive, ui.mouse_position, entity.get_local_player, math.deg, math.atan2, math.rad, math.sin, math.cos, math.acos, entity.get_players, client.camera_angles, client.eye_position, entity.is_enemy, entity.is_dormant
local math_abs, client_latency, ui_reference, entity_get_player_weapon = math.abs, client.latency, ui.reference, entity.get_player_weapon
local entity_get_prop, math_sin, math_cos, globals_tickcount, globals_realtime, entity_is_alive, client_latency, ui_is_menu_open, client_key_state, client_set_clan_tag, entity_get_player_name, globals_framecount, client_set_event_callback, client_unset_event_callback = entity.get_prop, math.sin, math.cos, globals.tickcount, globals.realtime, entity.is_alive, client.latency, ui.is_menu_open, client.key_state, client.set_clan_tag, entity.get_player_name, globals.framecount, client.set_event_callback, client.unset_event_callback

local ffi = require("ffi")
local csgo_weapons = require 'gamesense/csgo_weapons'
local images = require("gamesense/images")
local anti_aim = require("gamesense/antiaim_funcs")
local obex_data = {username = 'scriptleaks', build = 'Boosters'}

local username =  obex_data.username

local build = obex_data.build

local function contains(table, val)
    if #table > 0 then
        for i = 1, #table do
            if table[i] == val then
                return true
            end
        end
    end
    return false
end
ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct { float x, y, z; } vec3_anim_t;

    typedef struct animlayer_t27398173981
    {
        char  pad_0000[20];
        uint32_t m_nOrder; //0x0014
        uint32_t m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    }; //Size: 0x0038

    typedef struct CUtlVectorSimple2312323123
    {
        unsigned memory;
        char pad[8];
        unsigned int count;
    };

typedef struct { float x, y, z; } vector_123;

    typedef struct animstate_t23178 {
        char pad0[0x18];
        float        anim_update_timer;                char pad1[0xC];
        float        started_moving_time;
        float        last_move_time;                    char pad2[0x10];
        float        last_lby_time;                    char pad3[0x8];
        float        run_amount;                        char pad4[0x10];
        void*        entity;
        void*        active_weapon;
        void*        last_active_weapon;
        float        last_client_side_animation_update_time;
        int            last_client_side_animation_update_framecount;
        float        eye_timer;
        float        eye_angles_y;
        float        eye_angles_x;
        float        goal_feet_yaw;
        float        current_feet_yaw;
        float        torso_yaw;
        float        last_move_yaw;
        float        lean_amount;                    char pad5[0x4];
        float        feet_cycle;
        float        feet_yaw_rate;                    char pad6[0x4];
        float        duck_amount;
        float        landing_duck_amount;            char pad7[0x4];
        float        current_origin[3];
        float        last_origin[3];
        float        velocity_x;
        float        velocity_y;                        char pad8[0x4];
        float        unknown_float1;                    char pad9[0x8];
        float        unknown_float2;
        float        unknown_float3;
        float        unknown;
        float        m_velocity;
        float        jump_fall_velocity;
        float        clamped_velocity;
        float        feet_speed_forwards_or_sideways;
        float        feet_speed_unknown_forwards_or_sideways;
        float        last_time_started_moving;
        float        last_time_stopped_moving;
        bool        on_ground;
        bool        hit_in_ground_animation;        char pad10[0x4];
        float        time_since_in_air;
        float        last_origin_z;
        float        head_from_ground_distance_standing;
        float        stop_to_full_running_fraction;    char pad11[0x4];
        float        magic_fraction;                    char pad12[0x3C];
        float        world_force;                    char pad13[0x1CA];
        float        min_yaw;
        float        max_yaw;
    };
]]

local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local lp = entity_get_local_player()
local get = ui.get
local set = ui.set

local variables = {
    target = nil,
    freestanding = nil,
    should_jitter = false,
    fake_yaw_limit = 0,
    delayed = true,
    old_health = 100,
    seconds = 0
}

local callbacks = {}

local function create_callback(event, fn)
    table.insert(callbacks, {e = event, f = fn})
end

local ui_fn = {
    includes = function(table, key)
        if table == nil then
            return false, nil
        end

        for i = 1, #table do
            if table[i] == key then
                return true, i
            end
        end

        return false, nil
    end,

    set_visible = function(state, ...)
        local args = {...}

        for i = 1, #args do
            ui_set_visible(args[i], state)
        end
    end,

    mouse_within = function(x, y, w, h)
        local mouse = {ui_mouse_position()}
        return mouse[1] > x and mouse[1] < x + w and mouse[2] > y and mouse[2] < y + h
    end
}

local math_fn = {
    TIME_TO_TICKS = function(t)
        return math_floor(t / globals_tickinterval() + 0.5)
    end,

    TICKS_TO_TIME = function(ticks)
        return globals_tickinterval() * ticks
    end,

    clamp = function(min, max, value)
        if value > max then
            return max
        elseif value < min then
            return min
        else
            return value
        end
    end,

    normalize_yaw = function(yaw)
        yaw = (yaw % 360 + 360) % 360
        return yaw > 180 and yaw - 360 or yaw
    end,

    distance2d = function(start_pos, end_pos)
        local delta = {start_pos[1] - end_pos[1], start_pos[2] - end_pos[2]}
        return math_sqrt(delta[1] * delta[1] + delta[2] * delta[2])
    end,

    distance3d = function(start_pos, end_pos)
        local delta = {start_pos[1] - end_pos[1], start_pos[2] - end_pos[2], start_pos[3] - end_pos[3]}
        return math_sqrt(delta[1] * delta[1] + delta[2] * delta[2] + delta[3] * delta[3])
    end,

    lerp = function(one, two, percent)
        local return_results = {}
        for i=1, #one do
            return_results[i] = one[i] + (two[i] - one[i]) * percent
        end
        return return_results
    end,

    calc_angle = function(start_pos, end_pos)
        if start_pos[1] == nil or end_pos[1] == nil then
            return {0, 0}
        end

        local delta_x, delta_y, delta_z = end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]

        if delta_x == 0 and delta_y == 0 then
            return {(delta_z > 0 and 270 or 90), 0}
        else
            local hyp = math_sqrt(delta_x*delta_x + delta_y*delta_y)

            local pitch = math_deg(math_atan2(-delta_z, hyp))
            local yaw = math_deg(math_atan2(delta_y, delta_x))

            return {pitch, yaw}
        end
    end,

    dot = function(vec1, vec2)
        return vec1[1] * vec2[1] + vec1[2] * vec2[2] + vec1[3] * vec2[3]
    end,

    angle_vector = function(angle)
        local p, y = math_rad(angle[1]), math_rad(angle[2])
        local sp, cp, sy, cy = math_sin(p), math_cos(p), math_sin(y), math_cos(y)
        return {cp*cy, cp*sy, -sp}
    end,

    normalize_vector = function(vec)
        local len = math_sqrt(vec[1] * vec[1] + vec[2] * vec[2] + vec[3] * vec[3])
        if len == 0 then
            return 0, 0, 0
        end
        local r = 1 / len
        return {vec[1]*r, vec[2]*r, vec[3]*r}
    end,

    fov = function(self, start_pos, end_pos, angle)
        if start_pos == nil or end_pos == nil or angle == nil then
            return 180
        end

        local vec = self.angle_vector(angle)
        local normalize_vec = self.normalize_vector({end_pos[1] - start_pos[1], end_pos[2] - start_pos[2], end_pos[3] - start_pos[3]})

        return math_deg(math_acos(self.dot(vec, normalize_vec)))
    end,

    extrapolate_origin = function(self, origin, yaw, units)
        local angle_vec = self.angle_vector({0, yaw})

        local results = {
            origin[1] + angle_vec[1] * units,
            origin[2] + angle_vec[2] * units,
            origin[3] + angle_vec[3] * units
        }
        return results
    end,

    extrapolate_origin_wall = function(self, ignore, origin, yaw, units)
        local forward = self.angle_vector({0, yaw})
        local trace = {client_trace_line(ignore, origin[1], origin[2], origin[3], origin[1] + (forward[1] * units), origin[2] + (forward[2] * units), origin[3] + (forward[3] * units))}
        return {
            origin[1] + (forward[1] * (units * trace[1])),
            origin[2] + (forward[2] * (units * trace[1])),
            origin[3] + (forward[3] * (units * trace[1]))
        }
    end,

    extrapolate_angle_origin_wall = function(self, ignore, origin, angle, units)
        for i = 1, #units do
            units[i] = math_abs(units[i])
        end

        local forward = self.angle_vector(angle)
        local trace = {client_trace_line(ignore, origin[1], origin[2], origin[3], origin[1] + (forward[1] * units[1]), origin[2] + (forward[2] * units[2]), origin[3] + (forward[3] * units[3]))}
        return {
            origin[1] + (forward[1] * (units[1] * trace[1])),
            origin[2] + (forward[2] * (units[2] * trace[1])),
            origin[3] + (forward[3] * (units[3] * trace[1]))
        }
    end,

    extrapolate_player_position = function(player, origin, ticks)
        local vel = {entity_get_prop(player, "m_vecVelocity")}

        if vel[1] == nil then
            return nil
        end

        local pred_tick = globals_tickinterval() * ticks

        return {
            origin[1] + (vel[1] * pred_tick),
            origin[2] + (vel[2] * pred_tick),
            origin[3] + (vel[3] * pred_tick)
        }
    end
}

local ffi_fn = {
    abs_yaw = 0,
    body_yaw = 0,
    goal_feet_yaw = 0,
    srv_goal_feet_yaw = 0,

    anglemod = function(a)
	    return (360 / 65536) * bit.band(math.floor(a * (65536 / 360)), 65535)
    end,

    approach_angle = function(self, target, value, speed)
        target = self.anglemod(target)
        value = self.anglemod(value)

        local delta = target - value

        if speed < 0 then
            speed = -speed
        end

        if delta < -180 then
            delta = delta + 360
        elseif delta > 180 then
            delta = delta - 360
        end

        if delta > speed then
            value = value + speed
        elseif delta < -speed then
            value = value - speed
        else
            value = target
        end

        return value
    end,

    angle_diff = function(dest_angle, src_angle)
        local delta = math.fmod(dest_angle - src_angle, 360)
        if dest_angle > src_angle then
            if delta >= 180 then
                delta = delta - 360
            end
        else
            if delta <= -180 then
                delta = delta + 360
            end
        end
        return delta
    end,

    get_animstate = function(player)
        if(player == nil) then return nil end
        local player_ent = ffi.cast(voidptr, get_client_entity(ientitylist, player))
        if(player_ent == nil) then return nil end
        local animstate_ptr = ffi.cast("char*" , player_ent) + 0x9960
        if(animstate_ptr == nil) then print("nil animstate") return nil end
        local animstate = ffi.cast( "struct animstate_t23178**", animstate_ptr )[0]
        if(animstate == nil) then error("outdated animstate") return nil end

        return animstate
    end,

    get_max_desync = function(self, player) --Returns max possible desync for a player
        local animstate = self.get_animstate(player)

        if animstate == nil then
            return 58
        end

        local duck_amount = animstate.duck_amount
        local speed_fraction = math_max(0, math_min(animstate.feet_speed_forwards_or_sideways, 1))
        local speed_factor = math_max(0, math_min(1, animstate.feet_speed_unknown_forwards_or_sideways))
        local unknown_factor = ((animstate.stop_to_full_running_fraction * -0.30000001) - 0.19999999) * speed_fraction
        local unkown_factor_secondary = unknown_factor + 1

        if (duck_amount > 0) then
            unkown_factor_secondary = unkown_factor_secondary + ((duck_amount * speed_factor) * (0.5 - unkown_factor_secondary))
        end
        return animstate.max_yaw * unkown_factor_secondary
    end,

    run = function(self, cmd)
        local anim_state = self.get_animstate(lp)
        local m_vecVelocity = {entity.get_prop(lp, "m_vecVelocity")}

        if anim_state == nil or m_vecVelocity == nil then
            return
        end

        local max_desync = math_abs(self:get_max_desync(lp)) or 58
        local speed = math.sqrt(m_vecVelocity[1] ^ 2 + m_vecVelocity[2] ^ 2)

        self.srv_goal_feet_yaw = math_fn.clamp(-360, 360, self.srv_goal_feet_yaw)

        local max_movement_speed = 260
        local running_speed = math_fn.clamp(0, 1, speed / (max_movement_speed * 0.520))
        local yaw_modifier = (((anim_state.stop_to_full_running_fraction * -0.3) - 0.2) * running_speed) + 1
        local max_yaw_modifier, min_yaw_modifier = yaw_modifier * 58, yaw_modifier * -58
        local eye_feet_delta = self.angle_diff(self.abs_yaw, self.srv_goal_feet_yaw)

        if eye_feet_delta <= max_yaw_modifier then
            if min_yaw_modifier > eye_feet_delta then
                self.srv_goal_feet_yaw = math.abs(min_yaw_modifier) + self.abs_yaw
            end
        else
            self.srv_goal_feet_yaw = self.abs_yaw - math.abs(max_yaw_modifier)
        end

        if speed > 0.1 then
            self.srv_goal_feet_yaw = self:approach_angle(
                self.abs_yaw,
                math_fn.normalize_yaw(self.srv_goal_feet_yaw),
                ((anim_state.stop_to_full_running_fraction * 20) + 30) * globals_tickinterval()
            )
        else
            self.srv_goal_feet_yaw = self:approach_angle(
                entity.get_prop(lp, "m_flLowerBodyYawTarget"),
                math_fn.normalize_yaw(self.srv_goal_feet_yaw),
                globals_tickinterval() * 100
            )
        end

        self.goal_feet_yaw = math_fn.normalize_yaw(self.srv_goal_feet_yaw)

        --Update everything
        if cmd.chokedcommands ~= 0 then
            return
        end

        --Update abs yaw
        self.abs_yaw = anim_state.eye_angles_y
        self.body_yaw = anim_state.goal_feet_yaw
    end,
}
create_callback("setup_command", function(cmd) ffi_fn:run(cmd) end)


local debug_fn = {
    draw_line = function(start_pos, end_pos, color)
        local start_w2s = {renderer.world_to_screen(start_pos[1], start_pos[2], start_pos[3])}
        local end_w2s = {renderer.world_to_screen(end_pos[1], end_pos[2], end_pos[3])}

        if start_w2s[1] and end_w2s[1] then
            renderer_line(start_w2s[1], start_w2s[2], end_w2s[1], end_w2s[2], color[1], color[2], color[3], color[4])
        end
    end,

    draw_skeleton = function(exquisite, color)
        local connections = {
            {1, 2},
            {2, 7},
            {7, 18},
            {7, 16},
            {7, 5},
            {5, 3},
            {3, 8},
            {3, 9},
            {8, 10},
            {10, 12},
            {9, 11},
            {11, 13},
            {18, 19},
            {19, 15},
            {16, 17},
            {17, 14}
        }

        for i = 1, #connections do
            local points = connections[i]

            local point = exquisite[points[1]]
            local point2 = exquisite[points[2]]

            local start_w2s = {renderer.world_to_screen(point[1], point[2], point[3] + 2)}
            local end_w2s = {renderer.world_to_screen(point2[1], point2[2], point2[3] + 2)}

            if start_w2s[1] and end_w2s[1] then
                renderer_line(start_w2s[1], start_w2s[2], end_w2s[1], end_w2s[2], color[1], color[2], color[3], color[4])
            end
        end
    end,

    lines = {},
    skeletons = {},

    create_line = function(self, start_pos, end_pos, color, time, fade_in)
        table.insert(self.lines, {
            start_pos = start_pos,
            end_pos = end_pos,
            color = color,
            alpha = fade_in and 0 or 255,
            time = globals_realtime() + time
        })
    end,

    create_exquisite = function(player)
        local hitboxes = {}

        for i = 0, 18 do
            hitboxes[i + 1] = {entity_hitbox_position(player, i)}
        end

        return hitboxes
    end,

    create_skeleton = function(self, exquisite, color, time, fade_in)
        table.insert(self.skeletons, {
            exquisite = exquisite,
            color = color,
            alpha = fade_in and 0 or 255,
            time = globals_realtime() + time
        })
    end,

    run = function(self)
        local inc_rate = (255 / 0.1) * globals.frametime()
        local dec_rate = (255 / 0.2) * globals.frametime()

        for i = #self.lines, 1, -1 do
            local line = self.lines[i]
            if line.time < globals_realtime() then
                line.alpha = math_max(0, line.alpha - dec_rate)

                if line.alpha == 0 then
                    table.remove(self.lines, i)
                end
            else
                line.alpha = math_min(line.color[4], line.alpha + inc_rate)
            end

            self.draw_line(line.start_pos, line.end_pos, {line.color[1], line.color[2], line.color[3], line.alpha})
        end

        for i = #self.skeletons, 1, -1 do
            local skeleton = self.skeletons[i]

            if skeleton.time < globals_realtime() then
                skeleton.alpha = math_max(0, skeleton.alpha - dec_rate)

                if skeleton.alpha == 0 then
                    table.remove(self.skeletons, i)
                end
            else
                skeleton.alpha = math_min(skeleton.color[4], skeleton.alpha + inc_rate)
            end

            self.draw_skeleton(skeleton.exquisite, {skeleton.color[1], skeleton.color[2], skeleton.color[3], skeleton.alpha})
        end
    end,
}
create_callback("paint", function() debug_fn:run() end)

local player_fn = {
    players = {},

    target_visible = false,
    cached_freestanding_side = nil,

    valid = function(index, check_dormancy)
        check_dormancy = check_dormancy or true

        if index == nil then
            return false
        elseif entity_is_alive(index) == false then
            return false
        elseif entity_is_enemy(index) == false then
            return false
        elseif check_dormancy and entity_is_dormant(index) then
            return false
        end

        return true
    end,

    speed = function(index)
        local m_vecVelocity = {entity_get_prop(index, "m_vecVelocity")}

        if m_vecVelocity[1] then
            return math_floor(math_sqrt(m_vecVelocity[1] ^ 2 + m_vecVelocity[2] ^ 2) + 0.5)
        else
            return 0
        end
    end,

    eye_position = function(player)
        if player == nil then
            return {}
        end

        local origin = {entity_get_origin(player)}
        if origin[1] == nil then
            return {}
        end

        return {origin[1], origin[2], origin[3] + 64}
    end,

    target = function(self)
        variables.target = client.current_threat()
    end
}


local algorithm = {
    file = "exquisite_preset.lua",
    file_content = nil,
    update_timer = 0,
    update_rate = math_fn.TICKS_TO_TIME(64),

    default_content = [[
function exquisite_preset_antibrute(aa, events, antibrute)
    aa.body_yaw = "Static"
    aa.body_yaw_value = antibrute.side and -60 or 60
end

function exquisite_preset_builder_aa(aa, events)
    aa.name = "Name"

    if events.movestate == "stand" then
        aa.body_yaw = "Static"
        aa.body_yaw_value = 21
    else
        aa.yaw_jitter = "Center"
        aa.yaw_jitter_value = 2

        aa.body_yaw = "Static"
        aa.body_yaw_value = events.freestanding and 60 or -60

        aa.fake_yaw = 58
    end
end]],

    dump_functions = { -- stuff they can use
        "client",
        "entity",
        "globals",
        "math",
        "table",
        "string",
    },

    dump_globals = { -- stuff they can use
        tonumber = tonumber,
        tostring = tostring,
        assert = assert,
        error = error,
        pairs = pairs,
        ipairs = ipairs,
        pcall = pcall,
        type = type,
        unpack = unpack,
        print = print
    },

    ignore_functions = { -- stuff we dont want them to use
        ["string"] = {
            "rep",
            "dump",
            "byte",
            "char",
        },
        ["table"] = {
            "maxn",
            "foreachi",
            "move",
        },
        ["math"] = {
            "log10",
            "huge",
            "ldexp",
            "frexp",
            "tanh",
            "modf"
        },
        ["client"] = {
            "exec",
            "color_log",
            "set_clan_tag",
            "unset_event_callback",
            "set_event_callback",
            "error_log",
        }
    },

    allowed_env = {},

    dumpglobals = function(self, tbl, string, ignore)
        self.allowed_env[string] = {}
        for k, v in pairs(tbl) do
            if type(k) ~= "number" then
                if not ui_fn.includes(ignore[string], k) then
                    self.allowed_env[string][k] = v
                end
            elseif type(v) == "table" and v ~= allowed_env and k ~= "_G" then
                self.allowed_env[k] = self.dump_globals(v)
            end

        end
    end,

    safe_load = function(string)
        exquisite_preset_antibrute = nil
        exquisite_prese_builder_aa = nil
        exquisite_resolver_builder = nil

        local load = function()
            loadstring(string)()
        end

        local call, err = pcall(load)

        if call == false then
            client.color_log(255, 200, 50, "[exquisite]: \0")
            client.color_log(255, 225, 200, "prese builder error: syntax error")
            client.color_log(255, 200, 50, "[Raw error]: \0")
            client.color_log(255, 225, 200, err)
        else
            load()
        end
    end,

    init = function(self)
        for i=1, #self.dump_functions do
            self:dumpglobals(_G[self.dump_functions[i]], self.dump_functions[i], self.ignore_functions)
        end

        for i, v in pairs(self.dump_globals) do
            self.allowed_env[i] = v
        end

        local file_read = readfile(self.file)

        if file_read == nil or string.len(file_read) <= 0 then
            writefile(self.file, self.default_content)
            file_read = self.default_content
        end

        self.safe_load(file_read)

        self.file_content = file_read
        self.old_file_content = file_read
    end,

    update = function(self)
        if self.update_timer < globals_realtime() then
            local file_read = readfile(self.file)

            if file_read == nil or string.len(file_read) <= 0 then
                writefile(self.file, self.default_content)
                file_read = self.default_content
            end

            if file_read ~= self.file_content then
                self.file_content = file_read

                exquisite_preset_antibrute = nil
                exquisite_preset_builder_aa = nil

                self.safe_load(file_read)
            end

            self.update_timer = globals_realtime() + self.update_rate
        end
    end
}
create_callback("paint_ui", function() algorithm:update() end)
algorithm:init()

local ref = {
    --antiaim
    aimbot = ui_reference("RAGE", "Aimbot", "Enabled"),

    aa_enable = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    safe_point = ui_reference("RAGE", "Aimbot", "Force safe point"),
    force_baim = ui_reference("RAGE", "Aimbot", "Force body aim"),


    quickpeek = {ui_reference("RAGE", "Other", "Quick peek assist")},
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    slow_motion = {ui_reference("AA", "Other", "Slow motion")},

    --exploits
    doubletap = {ui_reference("RAGE", "Aimbot", "Double tap")},
    onshot = {ui_reference("AA", "Other", "On shot anti-aim")},
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),

    --fakelag
    limit = ui_reference("AA", "Fake lag", "Limit"),
    sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
    anti_untrusted = ui_reference("MISC", "Settings", "Anti-untrusted"),
    --others
    menu_color = ui_reference("MISC", "Settings", "Menu color"),
    thirdperson = {ui_reference("VISUALS", "Effects", "Force third person (alive)")},


}


local menu_builder = {
    init = function()
        local results = {}

        local movestates = {"Stand", "Slow motion", "Move", "Air", "Duck"}

        for i = 1, #movestates do
            local movestate = movestates[i]

            results[#results + 1] = {
                state = movestate,
                yaw = ui.new_slider("AA", "Anti-aimbot angles", "[" .. movestate .. "] Yaw", -180, 180, 0),
                yaw_jitter = ui.new_combobox("AA", "Anti-aimbot angles", "[" .. movestate .. "] Yaw jitter", "Off", "Offset", "Center", "Random"),
                yaw_jitter_value = ui.new_slider("AA", "Anti-aimbot angles", "\n[" .. movestate .. "] Yaw jitter value", -180, 180, 0),
                body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[" .. movestate .. "] Body yaw", "Off", "Opposite", "Jitter", "Static"),
                body_yaw_value = ui.new_slider("AA", "Anti-aimbot angles", "\n[" .. movestate .. "] Body yaw value", -180, 180, 0),
                roll = ui.new_combobox("AA", "Anti-aimbot angles", "[" .. movestate .. "] Roll", "Off", "Static", "Jitter"),
                roll_value = ui.new_slider("AA", "Anti-aimbot angles", "\n[" .. movestate .. "] Roll value", -50, 50, 0)
            }
        end

        return results
    end
}
local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end
local colours = {

	lightblue = '\a'..rgbToHex(181, 209, 255)..'ff',
	darkerblue = '\a9AC9FFFF',
	grey = '\a898989FF',
	red = '\aff441fFF',
	default = '\ac8c8c8FF',
}

local menu = {
    --anti aimbot anges
    enable = ui.new_checkbox("AA", "Anti-aimbot angles", colours.lightblue.."Exquisite "..colours.default .."anti-aim [" .. colours.lightblue .. build .. colours.default .. ']'),
    options = ui.new_multiselect("AA", "Anti-aimbot angles", "Options", {"Legit anti-aim", "At targets", "Local view in air", "Anti-backstab", "Freestanding", "Edge yaw", "Manual anti-aim", "Anti-bruteforce", "LBY Fix"}),

    finder = ui.new_combobox("AA", "Anti-aimbot angles", "\n exquisite explorer", {"Main", "Visuals","Roll", "Fake flick","Misc."}),

    vis_options = ui.new_multiselect("AA", "Anti-aimbot angles", "Visuals\nexquisite", {"Crosshair","User Info","Weapon Info"}),
    crosshair_opt = ui.new_multiselect("AA", "Anti-aimbot angles","Crosshair Options \n exquisite", {"Weapon"}),
    lable_1 = ui.new_label("AA", "Anti-aimbot angles", "Gradient color 1\nexquisite"),
    color_1 = ui.new_color_picker("AA", "Anti-aimbot angles", "Color 1\nexquisite", 255, 255, 255, 255),
    lable_2 = ui.new_label("AA", "Anti-aimbot angles", "Gradient color 2\nexquisite"),
    color_2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Color 2\nexquisite", 100, 200, 255, 255),
    userinfox_offset = ui.new_slider("AA", "Anti-aimbot angles", "User Info Postion.X", 0, 2000, 0, true, ""),
    userinfoy_offset = ui.new_slider("AA", "Anti-aimbot angles", "User Info Postion.Y", 0, 1000, 0, true, ""),
    weaponinfox_offset = ui.new_slider("AA", "Anti-aimbot angles", "Weapon Info Postion.X", 0, 2000, 0, true, ""),
    weaponinfoy_offset = ui.new_slider("AA", "Anti-aimbot angles", "Weapon Info Postion.Y", 0, 1000, 0, true, ""),
    logs = ui.new_checkbox("AA", "Anti-aimbot angles", "Logs \n exquisite"),
    logs_fonts = ui.new_combobox("AA", "Anti-aimbot angles","Fonts \n exquisite", {"Default","Normal", "Bold", "Large"}),
    logs_output = ui.new_multiselect("AA", "Anti-aimbot angles","Output \n exquisite", {"Center", "Console", "Top-left corner"}),
    logs_hit = ui.new_label("AA", "Anti-aimbot angles","Hit color"),
    logs_hit_color = ui.new_color_picker("AA", "Anti-aimbot angles","Hit color picker", 163, 255, 15, 255),
    logs_miss = ui.new_label("AA", "Anti-aimbot angles","Miss color"),
    logs_miss_color = ui.new_color_picker("AA", "Anti-aimbot angles","Miss color picker", 255, 50, 50, 255),
    vis_bad = ui.new_checkbox("AA", "Anti-aimbot angles","Another UI \n exquisite"),

    --algorithm
    algorithm_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim mode\n algorithm", {"Presets", "Menu builder"}),

    --Script builder
    algorithm_text = ui.new_label("AA", "Anti-aimbot angles", "Main file: exquisite_preset.lua"),
    algorithm_debug = ui.new_checkbox("AA", "Anti-aimbot angles", "AA debugger"),

    --Presets
    algorithm_options = ui.new_combobox("AA", "Anti-aimbot angles", "Presets", {"Sayuki","Sayuki R Edition","Devil","Tank","Tank 2","Experimental","Jitter","Sway", "Static"}),
    legit_aa_options = ui.new_combobox("AA", "Anti-aimbot angles", "Legit anti-aim Presets", {"Sayuki","Tank","Experimental", "Jitter","Static"}),
    legit_aa_at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "Legit anti-aim at targets"),

    --kinda cope mmmm
    builder_movestate = ui.new_combobox("AA", "Anti-aimbot angles", "Builder movestate", {"Stand", "Slow motion", "Move", "Air", "Duck"}),
    builder = menu_builder.init(),

    --roll
    roll_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable roll"),
    roll_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "Roll disablers", {"Air", "High speed", "Move", "Not slow walking", "Not vulnerable"}),
    roll_override_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Override disablers", true),
    roll_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Mode\nroll", {"Lean", "Jitter", "Dynamic"}),
    roll_lean_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Lean", false),
    roll_side = ui.new_combobox("AA", "Anti-aimbot angles", "Lean direction", {"Automatic", "Inverter"}),
    roll_inverter = ui.new_hotkey("AA", "Anti-aimbot angles", "Lean inverter", true),
    roll_amount_left = ui.new_slider("AA", "Anti-aimbot angles", "Lean amount (left)", 0, 100, 60, true, "%"),
    roll_amount_right = ui.new_slider("AA", "Anti-aimbot angles", "Lean amount (right)", 0, 100, 60, true, "%"),
    roll_jitter_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Roll jitter", false),
    roll_jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Jitter mode\nroll", {"Normal", "Inverted"}),
    roll_dynamic_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Dynamic jitter", false),
    roll_dynamic_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Dynamic mode\nroll", {"Normal", "Inverted"}),


    --fake flick
    fake_flick_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Fake flick"),
    fake_flick_activation_mode = ui.new_combobox("AA", "Anti-aimbot angles", "\n fake flick mode", {"Conditional", "Hotkey"}),
    fake_flick_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Fake flick hotkey", true),
    fake_flick_conditions = ui.new_multiselect("AA", "Anti-aimbot angles", "Conditions\nexquisite", {"Stand", "Move", "Air", "Duck"}),
    fake_flick_requirements = ui.new_multiselect("AA", "Anti-aimbot angles", "Requirements", {"Only when vulnerable", "Only when doubletapping"}),
    fake_flick_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Side", {"Automatic", "Movement", "Inverter"}),
    fake_flick_invert = ui.new_hotkey("AA", "Anti-aimbot angles", "Fake flick Inverter", true),
    fake_flick_delay = ui.new_slider("AA", "Anti-aimbot angles", "Delay between flicks (ticks)", 4, 32, 17, true, "", 1, {[4] = "Auto"}),
    fake_flick_init_delay = ui.new_slider("AA", "Anti-aimbot angles", "First flick delay (ticks)", 3, 16, 5, true, ""),
    fake_flick_variance = ui.new_slider("AA", "Anti-aimbot angles", "Delay variance", 0, 100, 25, true, "%"),
    fake_flick_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Fake flick pitch", {"Minimal", "Up", "Dynamic"}),

    --misc
    legit_antiaim_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit anti-aim key\n exquisite"),
    freestanding_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding key \n exquisite"),
    edge_yaw_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge yaw key \n exquisite"),
    manual_left_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual left \n exquisite"),
    manual_right_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual right \n exquisite"),
    quick_fall = ui.new_checkbox("AA", "Anti-aimbot angles", "Quick fall"),
    quick_fall_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Quick fall hotkey", true),
    quick_fall_prediction = ui.new_slider("AA", "Anti-aimbot angles", "Prediction amount", 10, 30, 12, true, "t"),
    quick_peek = ui.new_checkbox("AA", "Anti-aimbot angles", "DT Quick peek"),
    quick_peek_key = ui.new_hotkey("AA", "Anti-aimbot angles", "DT Quick peek hotkey", true),
    quick_peek_options = ui.new_multiselect("AA", "Anti-aimbot angles", "\n DT quick peek mode", {"Freestanding", "Edge yaw"}),
    quick_peek_restore = ui.new_combobox("AA", "Anti-aimbot angles", "Double tap restore", {"Always on", "On hotkey", "Toggle", "Off hotkey"}),
    freestanding_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "Freestanding & Edge yaw disablers", {"Stand", "Slow motion", "Moving", "Jump", "Crouch"}),
    text111 = ui.new_label("AA", "Anti-aimbot angles","~~~~~~~~~~~Others~~~~~~~~~~~"),
    logger = ui.new_checkbox("AA", "Anti-aimbot angles", "Detailed anti-brute logs"),
    visualize = ui.new_checkbox("AA", "Anti-aimbot angles", "Visualize anti-brute"),
    break_lagcomp = ui.new_checkbox("AA", "Anti-aimbot angles", "Air Conditioner", true),
    break_lagcomp_hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Break lag compensation hotkey", true),
    clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Clantag"),


    --fl tab
    limit = ui.new_slider("AA", "Fake lag", "Limit \n exquisite", 1, 16, 16),
    adaptive_lag = ui.new_checkbox("AA", "Fake lag", "Adaptive fake lag"),

    --other
    leg_breaker = ui.new_checkbox("AA", "Other", "Leg movement breaker"),
    disable_dt_on_nade = ui.new_checkbox("RAGE", "Other", "Disable DT on nades"),
    default_config_set = ui.new_checkbox("AA", "Anti-aimbot angles", "Default config exquisite"),


    global_vis = function(self, state)
        ui_fn.set_visible(false, self.default_config_set)

        ui_fn.set_visible(state,
            self.options,
            self.finder,
            self.disable_dt_on_nade,
            self.quick_fall,
            self.limit,
            self.leg_breaker,
            self.adaptive_lag
        )
        ui_fn.set_visible(state and get(self.quick_fall), self.quick_fall_key, self.quick_fall_prediction)

        local algo_state = state

        if state and get(self.algorithm_mode) == "Script builder" and get(self.algorithm_debug) and get(self.finder) == "Main" then
            algo_state = false
        end

        ui_fn.set_visible(not algo_state,
            ref.yaw[1],
            ref.yaw[2],
            ref.yaw_jitter[1],
            ref.yaw_jitter[2],
            ref.body_yaw[1],
            ref.body_yaw[2],
            ref.roll
        )

        ui_fn.set_visible(not state,
            ref.aa_enable,
            ref.pitch,
            ref.yaw_base,
            ref.freestanding_body_yaw,
            ref.limit,
            ref.edge_yaw,
            ref.freestanding[1],
            ref.freestanding[2]
        )
    end,

    algorithm_vis = function(self, state, vis)
        local options_g = get(self.options)
        local algorithm_mode_g = get(self.algorithm_mode)

        ui_fn.set_visible(state and vis, self.algorithm_mode)
        ui_fn.set_visible(state and vis and algorithm_mode_g == "Presets", self.algorithm_options)
        ui_fn.set_visible(state and vis and ui_fn.includes(options_g, "Legit anti-aim") and algorithm_mode_g == "Presets", self.legit_aa_options, self.legit_aa_at_targets)
        ui_fn.set_visible(state and vis and algorithm_mode_g == "Menu builder", self.builder_movestate)

        for i = 1, #self.builder do
            local builder = self.builder[i]

            ui_fn.set_visible(state and vis and algorithm_mode_g == "Menu builder" and builder.state == get(self.builder_movestate),
                builder.yaw,
                builder.yaw_jitter,
                builder.body_yaw,
                builder.roll
            )

            ui_fn.set_visible(state and vis and algorithm_mode_g == "Menu builder" and builder.state == get(self.builder_movestate) and get(builder.yaw_jitter) ~= "Off", builder.yaw_jitter_value)
            ui_fn.set_visible(state and vis and algorithm_mode_g == "Menu builder" and builder.state == get(self.builder_movestate) and get(builder.body_yaw) ~= "Off", builder.body_yaw_value)
            ui_fn.set_visible(state and vis and algorithm_mode_g == "Menu builder" and builder.state == get(self.builder_movestate) and get(builder.roll) ~= "Off", builder.roll_value)

        end

        ui_fn.set_visible(state and vis and algorithm_mode_g == "Script builder", self.algorithm_text, self.algorithm_debug)
    end,

    roll_vis = function(self, state, vis)
        ui_fn.set_visible(state and vis, self.roll_enable)

        local roll_mode_g = get(self.roll_mode)

        ui_fn.set_visible(state and vis and get(self.roll_enable), self.roll_disablers, self.roll_override_key, self.roll_mode)
        ui_fn.set_visible(state and vis and get(self.roll_enable) and roll_mode_g == "Lean", self.roll_lean_key, self.roll_side, self.roll_amount_left, self.roll_amount_right)
        ui_fn.set_visible(state and vis and get(self.roll_enable) and roll_mode_g == "Lean" and get(self.roll_side) == "Inverter", self.roll_inverter)
        ui_fn.set_visible(state and vis and get(self.roll_enable) and roll_mode_g == "Jitter", self.roll_jitter_key, self.roll_jitter_mode)
        ui_fn.set_visible(state and vis and get(self.roll_enable) and roll_mode_g == "Dynamic", self.roll_dynamic_key, self.roll_dynamic_mode)
    end,
    logs_vis = function(self, state, vis)
        ui_fn.set_visible(state and vis, self.logs)

        ui_fn.set_visible(state and vis and get(self.logs), self.logs_hit, self.logs_miss, self.logs_fonts , self.logs_hit_color , self.logs_miss_color ,self.logs_output)
    end,

    fake_flick_vis = function(self, state, vis)
        ui_fn.set_visible(state and vis, self.fake_flick_enable)
        ui_fn.set_visible(state and vis and get(self.fake_flick_enable), self.fake_flick_activation_mode, self.fake_flick_requirements, self.fake_flick_mode, self.fake_flick_variance, self.fake_flick_delay, self.fake_flick_init_delay, self.fake_flick_pitch)
        ui_fn.set_visible(state and vis and get(self.fake_flick_enable) and get(self.fake_flick_activation_mode) ~= "Hotkey", self.fake_flick_conditions)
        ui_fn.set_visible(state and vis and get(self.fake_flick_enable) and get(self.fake_flick_activation_mode) == "Hotkey", self.fake_flick_hotkey)
        ui_fn.set_visible(state and vis and get(self.fake_flick_enable) and get(self.fake_flick_mode) == "Inverter", self.fake_flick_invert)
    end,

    misc_vis = function(self, state, vis)
        local options_g = get(self.options)

        ui_fn.set_visible(state and vis, self.quick_peek,self.quick_fall,self.quick_fall_prediction,self.quick_fall_key,self.freestanding_disablers, self.logger,self.break_lagcomp,self.break_lagcomp_hotkey,self.clantag,self.text111)

        ui_fn.set_visible(state and vis and get(self.quick_peek), self.quick_peek_key, self.quick_peek_options, self.quick_peek_restore)
        ui_fn.set_visible(state and vis and get(self.logger), self.visualize)
        ui_fn.set_visible(state and vis and ui_fn.includes(options_g, "Legit anti-aim"), self.legit_antiaim_on_key)
        ui_fn.set_visible(state and vis and ui_fn.includes(options_g, "Freestanding"), self.freestanding_key)
        ui_fn.set_visible(state and vis and ui_fn.includes(options_g, "Edge yaw"), self.edge_yaw_key)
        ui_fn.set_visible(state and vis and ui_fn.includes(options_g, "Manual anti-aim"), self.manual_left_key, self.manual_right_key)
    end,

    run = function(self)
        lp = entity_get_local_player()

        --Set default config
        if get(self.default_config_set) == false then
            set(self.options, {
                "Legit anti-aim",
                "At targets",
                "Anti-backstab",
                "Freestanding"
            })
            set(self.quick_peek, true)
            set(self.quick_peek_options, {"Freestanding"})
            set(self.quick_peek_restore, "Toggle")
            set(self.default_config_set, true)
        end

        local state = get(self.enable)
        local finder_g = get(self.finder)

        self:global_vis(state)
        self:algorithm_vis(state, finder_g == "Main")
        self:roll_vis(state, finder_g == "Roll")
        self:logs_vis(state, finder_g == "Visuals")
        self:fake_flick_vis(state, finder_g == "Fake flick")
        self:misc_vis(state, finder_g == "Misc.")
    end
}
create_callback("paint_ui", function() menu:run() end)
client.set_event_callback("pre_render", function()

if ui.get(menu.break_lagcomp) then
  entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
end
end)
local myconfig = ui.new_button("AA", "Anti-aimbot angles", "Recommended Config", function()
  set(menu.options, {
      "Legit anti-aim",
      "At targets",
      "Anti-backstab",
      "Freestanding",
      "LBY Fix"
  })
        set(menu.vis_options,{
          "Crosshair",
          "User Info"
        })
        set(menu.legit_aa_at_targets, true)
        set(menu.quick_peek, true)
        set(menu.quick_peek_options, {"Freestanding"})
        set(menu.quick_peek_restore, "Toggle")
        set(menu.break_lagcomp, true)
        set(menu.break_lagcomp_hotkey, "Always on")
        set(menu.leg_breaker, true)
        set(menu.freestanding_disablers,{
          "Slow motion",
          "Jump",
          "Crouch"
        })
        set(menu.enable, true)
        set(menu.algorithm_options,"Devil")
        set(menu.legit_aa_options,"Jitter")
        set(menu.logs, true)
        set(menu.clantag, true)
        set(menu.logs_output,{"Console",
        "Center"})

  end)
  local clantag = {
      last_tag = "",

      stages = {
          "",
          "E",
          "Ex",
          "Exq",
          "Exqu",
          "Exqui",
          "Exquis",
          "Exquisi",
          "Exquisit",
          "Exquisite",
          "Exquisite",
          "Exquisite",
          "Exquisite",
          "Exquisit",
          "Exquisi",
          "Exquis",
          "Exqui",
          "Exqu",
          "Exq",
          "Ex",
          "E",
          "",
          "",
          ""
      },

      run = function(self)
          local state = get(menu.clantag)

          if state == false then
              if self.last_tag ~= "" then
                  client_set_clan_tag("")

                  self.last_tag = ""
              end
              return
          end

          --tag shit
          local tag_int = math_floor(((globals_tickcount() * 0.045) % #self.stages) + 1)
          local tag_padding = "\t\t  "
          local matrix_tag = tag_padding .. self.stages[tag_int] .. tag_padding

          --default to ot
          local wish_tag = "Exquisite"

          --good kdr
          local resource = entity.get_player_resource()
          if resource ~= nil and lp ~= nil then
              local kills = entity_get_prop(resource, "m_iKills", lp) or 1
              local deaths = entity_get_prop(resource, "m_iDeaths", lp) or 0

              --fix kill count
              kills = (kills == 0 and deaths == 0) and 1 or kills

              if (kills/deaths) >= 1.5 then
                  wish_tag = matrix_tag
              end
          end

          --clip
          if lp ~= nil and entity_is_alive(lp) then
              local m_iNumRoundKills = entity_get_prop(lp, "m_iNumRoundKills") or 0

              if m_iNumRoundKills ~= nil and m_iNumRoundKills >= 5 then
                  wish_tag = matrix_tag
              end
          end

          if wish_tag ~= self.last_tag then
              client_set_clan_tag(wish_tag)
              self.last_tag = wish_tag
          end
      end,

      shutdown = function(self)
          if self.last_tag ~= "" then
              client_set_clan_tag("")
          end
      end,
  }
  create_callback("paint", function() clantag:run() end)
  create_callback("shutdown", function() clantag:shutdown() end)
  local function InAir()--在空中
      return (bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 0)
  end
  local function InDuck()--在蹲下
      if (entity.get_prop(entity.get_local_player(), "m_fFlags") == 263) then
         return true
      else
           return false
      end
  end
  local function InGrenade()--在投掷道具
      local weapon = csgo_weapons[entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")]
      if weapon.type == "grenade" then
          return true
      else
          return false
      end
  end
  local function InPeek()--在PEEK
      if ui.get(ref.quickpeek[2]) then
          return true
      else
          return false
      end
  end
  local function InSlowwalk ()--假走
      if ui.get(ref.slow_motion[1]) and ui.get(ref.slow_motion[2]) then
          return true
      else
          return false
      end
  end
  local function InMove(cmd)--在移动
      if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) then
          return true
      else
          return false
      end
  end
  local function LBY_Fix(cmd)
        if not ui.get(menu.enable) then return end
        if contains(ui.get(menu.options),"LBY Fix") then
          local desync_amount = anti_aim.get_desync(2)
          if desync_amount == nil or InAir() or InGrenade() or InPeek() then return end
          if InMove(cmd) and not InSlowwalk() then return end
          if math.abs(desync_amount) < 15 or cmd.chokedcommands == 0 then return end
          if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then return end
          if (entity.get_prop(entity.get_local_player(), "m_MoveType") or 0) == 9 then return end
          cmd.forwardmove = 0.000000000000000000000000000000001
          cmd.in_forward = 1
      end
  end
  local function setup_command(cmd)
          LBY_Fix(cmd)
  end
  client.set_event_callback("setup_command", setup_command)

  local checkbox_reference, hotkey_reference = ui.reference("AA", "Other", "Slow motion")
  local limit_reference = ui.new_slider("AA", "Other", "Slow Walk Speed", 10, 57, 50, 57, "", 1, {[57] = "Max"})
  local math_sqrt = math.sqrt

  local function modify_velocity(cmd, goalspeed)
    if goalspeed <= 0 then
      return
    end

    local minimalspeed = math_sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))

    if minimalspeed <= 0 then
      return
    end

    if cmd.in_duck == 1 then
      goalspeed = goalspeed * 2.94117647 -- wooo cool magic number
    end

    if minimalspeed <= goalspeed then
      return
    end

    local speedfactor = goalspeed / minimalspeed
    cmd.forwardmove = cmd.forwardmove * speedfactor
    cmd.sidemove = cmd.sidemove * speedfactor
  end

  local function on_setup_cmd(cmd)
    local checkbox = ui.get(checkbox_reference)
    local hotkey = ui.get(hotkey_reference)
    local limit = ui.get(limit_reference)

    if limit >= 57 then
      return
    end

    if checkbox and hotkey then
      modify_velocity(cmd, limit)
    end
  end

  client.set_event_callback('setup_command', on_setup_cmd)


local damage_fn = {
    max_traces_per_tick = 15,

    players = {},

    total_damage_left = 0,
    total_damage_right = 0,

    real_damage_left = 0,
    real_damage_right = 0,

    predict_damage_left = 0,
    predict_damage_right = 0,

    last_freestanding_side = nil,
    fake_lag_limit = 1,
    vulnerable = false,
    wide_peeked = false,
    movement = false,

    init = function(self)
        for i = 1, 64 do
            self.players[i] = { --fill table with data
                {damage = {left = 0, right = 0}, time = 0},
                {damage = {left = 0, right = 0}, time = 0},
                {damage = {left = 0, right = 0}, time = 0},
                {damage = {left = 0, right = 0}, time = 0},
                {damage = {left = 0, right = 0}, time = 0},
            }
        end
    end,

    clear = function(self, index) --used to clear bad players
        self.players[index] = {
            {damage = {left = 0, right = 0}, time = 0},
            {damage = {left = 0, right = 0}, time = 0},
            {damage = {left = 0, right = 0}, time = 0},
            {damage = {left = 0, right = 0}, time = 0},
            {damage = {left = 0, right = 0}, time = 0},
        }
    end,

    run = function(self, cmd)
        local target = variables.target
        local lp_eye_position = {client.eye_position()}
        local target_eye_position = player_fn.eye_position(target)

        local intensity = 2



        self.total_damage_left = 0
        self.total_damage_right = 0
        self.real_damage_left = 0
        self.real_damage_right = 0
        self.predict_damage_left = 0
        self.predict_damage_right = 0

        --reset, aids
        local function reset()
            self.vulnerable = false
            self.wide_peeked = false
        end

        if target == nil or lp_eye_position == nil or target_eye_position[1] == nil then
            reset()
            return self:init()
        end

        local valid_players = entity.get_players(true)

        if #valid_players == 0 then
            reset()
            self.last_freestanding_side = nil
            return self:init()
        end

        --lp_eye_position = math_fn.extrapolate_player_position(lp, lp_eye_position, math_fn.TIME_TO_TICKS(0.05))

        local wait_list = {}
        local stock_time = globals_realtime()

        for i = 1, self.max_traces_per_tick do
            wait_list[i] = {time = stock_time, player = nil, type = nil}
        end

        --add to list
        local function add_to_checklist(time, player, type)
            for i = 1, #wait_list do
                local wait = wait_list[i]

                if time < wait.time then
                    wait_list[i] = {time = time, player = player, type = type}
                    break --only want to replace one in wait list
                end
            end
        end

        --find best traces to run
        for i = 1, #valid_players do
            local index = valid_players[i]
            local data = self.players[index]

            for j = 1, #data do
                local dist = data[j]
                add_to_checklist(dist.time, index, j)
            end
        end

        local angle = math_fn.calc_angle(lp_eye_position, target_eye_position)

        local left_origins = {}
        local right_origins = {}
        local distances = {95, 40, 30, 25, 17, 17}

        for i = 1, #distances do
            left_origins[i] = math_fn:extrapolate_origin_wall(lp, lp_eye_position, math_fn.normalize_yaw(angle[2] + 90), distances[i])
            right_origins[i] = math_fn:extrapolate_origin_wall(lp, lp_eye_position, math_fn.normalize_yaw(angle[2] - 90), distances[i])
        end

        --run traces
        for i = 1, #wait_list do
            local wait = wait_list[i]
            local index = wait.player
            local ranges = self.players[index]

            if ranges then
                for j = 1, #ranges do
                    local data = ranges[j]
                    if j == wait.type then
                        local left_origin = left_origins[j]
                        local right_origin = right_origins[j]

                        local target_origin = player_fn.eye_position(index)

                        if target_origin then
                            --predict players to avoid getting backtracked
                            if j >= 4 then
                                self.players[wait.player][j] = {damage = {left = 0, right = 0}, time = stock_time}
                                local vel = {entity_get_prop(index, "m_vecVelocity")}

                                if vel[1] then
                                    local angle = math_fn.calc_angle({0, 0, 0}, vel)

                                    for i = 1, intensity do
                                        local new_vel = {
                                            vel[1] * ((i / intensity) * 0.5),
                                            vel[2] * ((i / intensity) * 0.5),
                                            vel[3] * ((i / intensity) * 0.5)
                                        }

                                        local updated_origin = math_fn:extrapolate_angle_origin_wall(index, target_origin, angle, new_vel)
                                        local _, left_damage = client_trace_bullet(index, updated_origin[1], updated_origin[2], updated_origin[3], left_origin[1], left_origin[2], left_origin[3], true)
                                        local _, right_damage = client_trace_bullet(index, updated_origin[1], updated_origin[2], updated_origin[3], right_origin[1], right_origin[2], right_origin[3], true)

                                        --debug_fn:create_line(updated_origin, left_origin, {255, 0, 0, 255}, 0.05)
                                        --debug_fn:create_line(updated_origin, right_origin, {0, 0, 255, 255}, 0.05)

                                        self.players[wait.player][j] = {damage = {left = self.players[wait.player][j].damage.left + left_damage, right = self.players[wait.player][j].damage.right + right_damage}, time = stock_time}
                                    end
                                end
                            else
                                local _, left_damage = client_trace_bullet(index, target_origin[1], target_origin[2], target_origin[3], left_origin[1], left_origin[2], left_origin[3], true)
                                local _, right_damage = client_trace_bullet(index, target_origin[1], target_origin[2], target_origin[3], right_origin[1], right_origin[2], right_origin[3], true)

                                --debug_fn:create_line(target_origin, left_origin, {255, 0, 0, 255}, 0.05)
                                --debug_fn:create_line(target_origin, right_origin, {0, 0, 255, 255}, 0.05)

                                self.players[wait.player][j] = {damage = {left = left_damage, right = right_damage}, time = stock_time}
                            end

                            break
                        end
                    end
                end
            end
        end

        --collect_data
        local left_damage_ranges = {0, 0, 0, 0, 0, 0}
        local right_damage_ranges = {0, 0, 0, 0, 0, 0}

        for i = 1, #valid_players do
            local index = valid_players[i]
            local data = self.players[index]

            for j = 1, #data do
                local dist = data[j]
                --print(entity.get_player_name(index) .. " - " .. " l:" .. dist.damage.left .. " r:" .. dist.damage.right)
                left_damage_ranges[j] = left_damage_ranges[j] + dist.damage.left
                right_damage_ranges[j] = right_damage_ranges[j] + dist.damage.right
            end
        end

        for i = 1, #left_damage_ranges do
            if i == 6 or i == 5 then
                self.predict_damage_left = self.predict_damage_left + left_damage_ranges[i]
                self.predict_damage_right = self.predict_damage_right + right_damage_ranges[i]
            elseif i == 4 then
                self.real_damage_left = self.real_damage_left + left_damage_ranges[i]
                self.real_damage_right = self.real_damage_right + right_damage_ranges[i]
            end

            self.total_damage_left = self.total_damage_left + left_damage_ranges[i]
            self.total_damage_right = self.total_damage_right + right_damage_ranges[i]
        end

        if self.total_damage_left ~= 0 or self.total_damage_right ~= 0 then
            self.last_freestanding_side = self.total_damage_left < self.total_damage_right
        end

        self.vulnerable = (self.predict_damage_left + self.predict_damage_right + self.real_damage_left + self.real_damage_right) ~= 0
        self.wide_peeked = (self.predict_damage_left + self.real_damage_left) ~= 0 and (self.predict_damage_right + self.real_damage_right) ~= 0
    end,

    last_freestanding_body_yaw = false,

    environmental_side = function(cmd)
        local lp_eye_position = {client.eye_position()}

        if lp_eye_position == nil then
            return nil
        end

        local yaw = ffi_fn.abs_yaw

        local left_pos = math_fn:extrapolate_origin(lp_eye_position, math_fn.normalize_yaw(yaw - 90), 8192)
        local right_pos = math_fn:extrapolate_origin(lp_eye_position, math_fn.normalize_yaw(yaw + 90), 8192)

        local left_trace, _ = client_trace_line(lp, lp_eye_position[1], lp_eye_position[2], lp_eye_position[3], left_pos[1], left_pos[2], left_pos[3])
        local right_trace, _ = client_trace_line(lp, lp_eye_position[1], lp_eye_position[2], lp_eye_position[3], right_pos[1], right_pos[2], right_pos[3])

        local left_distance = left_trace * 8192
        local right_distance = right_trace * 8192

        if cmd.in_use == 1 then
            return left_distance > right_distance
        else
            return left_distance < right_distance
        end
    end,

    freestanding_body_yaw = function(self, cmd)
        if self.total_damage_left == 0 and self.total_damage_right == 0 then
            if self.last_freestanding_side ~= nil then
                variables.freestanding = self.last_freestanding_side
            else
                variables.freestanding = not self.movement
            end
        else
            if self.total_damage_left == self.total_damage_right and self.wide_peeked then
                variables.freestanding = not self.movement
                self.last_freestanding_body_yaw = variables.freestanding
            else
                if (self.real_damage_left == self.real_damage_right) or (self.real_damage_left == 0 and self.real_damage_right == 0) then
                    variables.freestanding = self.total_damage_left < self.total_damage_right
                else
                    variables.freestanding = self.real_damage_left < self.real_damage_right
                end

                self.last_freestanding_body_yaw = variables.freestanding
            end
        end
    end,

    freestanding_yaw = function(self)
        local target = variables.target

        if target == nil then
            return
        end

        local lp_eye_position = {client.eye_position()}
        local target_eye_position = player_fn.eye_position(target)

        if lp_eye_position == nil or target_eye_position == nil then
            return
        end

        local angle = math_fn.calc_angle(lp_eye_position, target_eye_position)
        local left = math_fn.normalize_yaw(angle[2] + 90)
        local right = math_fn.normalize_yaw(angle[2] - 90)

        if self.total_damage_left == 0 and self.total_damage_right == 0 then
            return nil
        end

        local total_close = self.real_damage_left + self.real_damage_right + self.predict_damage_left + self.predict_damage_right

        if total_close == 0 then
            if (self.total_damage_left + self.total_damage_right) ~= 0 then
                local side = (self.total_damage_left < self.total_damage_right)
                return side and left or right
            end
        else
            local left_damage = self.real_damage_left + self.predict_damage_left
            local right_damage = self.real_damage_right + self.predict_damage_right

            if left_damage == 0 and right_damage ~= 0 then
                return left
            elseif right_damage == 0 and left_damage ~= 0 then
                return right
            end
        end

        return nil
    end,
}
damage_fn:init()
create_callback("run_command", function(cmd) damage_fn:run(cmd) end)

--[[
local server = {
    waitlist = {},

    create = function(self, yaw_jitter, yaw_jitter_val, body_yaw, body_yaw_val, fake_yaw_limit, height, headshot)
        self.waitlist[#self.waitlist + 1] = {
            yaw_jitter = yaw_jitter,
            yaw_jitter_val = yaw_jitter_val,
            body_yaw = body_yaw,
            body_yaw_val = body_yaw_val,
            fake_yaw_limit = fake_yaw_limit,
            height = height,
            headshot = headshot
        }
    end,

    push = function(self)
        --do
    end
}
create_callback("round_start", function() server:push() end)
]]

local antiaim = {
    limit = 0,

    --Should anti-aim while using custom desync
    class_blacklist = {
        "CMolotovGrenade",
        "CSmokeGrenade",
        "CDecoyGrenade",
        "CFlashbang",
        "CHEGrenade",
        "CIncendiaryGrenade",
        "CSnowball",
        "CSensorGrenade",
    },
    grenade_release_timer = 0,

    bomb_time = function(ent)
        local c4_time = entity_get_prop(ent, "m_flC4Blow") - globals_curtime()
        return c4_time ~= nil and c4_time > 0 and c4_time or 0
    end,

    should_run_antiaim = function(self, cmd)
        local weapon = entity_get_player_weapon(lp)

        if weapon == nil then
            return false
        end

        local m_flNextAttack = entity_get_prop(lp, "m_flNextAttack")
        local m_flNextPrimaryAttack = entity_get_prop(weapon, "m_flNextPrimaryAttack")
        local m_nTickBase = entity_get_prop(lp, "m_nTickBase")

        if m_flNextAttack == nil or m_flNextPrimaryAttack == nil or m_nTickBase == nil then
            return false
        end

        local curtime = globals_curtime() -- m_nTickBase * globals_tickinterval() - client_latency()

        local game_rules = entity.get_game_rules()

        if game_rules ~= nil then
            local m_bFreezePeriod = entity_get_prop(game_rules, "m_bFreezePeriod")

            if m_bFreezePeriod ~= nil and m_bFreezePeriod == 1 then
                return false
            end
        end

        local defuse = entity_get_prop(lp, "m_bIsDefusing")

        if defuse and defuse == 1 then
            return false
        end

        local m_bIsGrabbingHostage = entity_get_prop(lp, "m_bIsGrabbingHostage")

        if m_bIsGrabbingHostage and m_bIsGrabbingHostage == 1 then
            return false
        end

        local team = entity_get_prop(lp, "m_iTeamNum")

        if team and team == 3 then
            local bombs = entity.get_all("CPlantedC4")
            local origin = {entity_get_origin(lp)}

            if origin == nil or origin[1] == nil then
                return false
            end

            for i = 1, #bombs do
                local bomb = bombs[i]

                if bomb ~= nil and entity_get_prop(bomb, "m_bBombDefused") == 0 and self.bomb_time(bomb) > 0 then
                    local bomb_origin = {entity_get_origin(bomb)}

                    if bomb_origin ~= nil and bomb_origin[1] ~= nil then
                        local dist = math_fn.distance2d(origin, bomb_origin)

                        if dist <= 75 then
                            return false
                        end
                    end
                end
            end
        end

        --Check move type
        local m_MoveType = entity_get_prop(lp, "m_MoveType")

        if m_MoveType then
            if m_MoveType == 9 or m_MoveType == 8 then --Ladder/Fly check
                return false
            end
        else
            return false
        end

        --Grenade check
        local classname = entity.get_classname(weapon)
        local itemindex = entity_get_prop(weapon, "m_iItemDefinitionIndex")

        local blacklisted_weapon = ui_fn.includes(self.class_blacklist, classname)

        if blacklisted_weapon then --Grenade
            local m_bPinPulled = entity_get_prop(weapon, "m_bPinPulled")
            local m_fThrowTime = entity_get_prop(weapon, "m_fThrowTime")

            if m_bPinPulled and m_fThrowTime then
                if m_bPinPulled or cmd.in_attack == 1 or cmd.in_attack2 == 1 then --Holding
                    if m_fThrowTime > 0 and m_fThrowTime < curtime then
                        self.grenade_release_timer = curtime + math_fn.TICKS_TO_TIME(2)
                        return false
                    end
                end
            end
        else
            --Fire check
            if m_flNextAttack > curtime then
                return true
            else
                local clip = entity_get_prop(weapon, "m_iClip1")

                if clip == 0 then
                    return true
                end

                if m_flNextPrimaryAttack <= curtime and (itemindex == 64 and (cmd.in_attack == 1 or cmd.in_attack2 == 1) or cmd.in_attack == 1) then
                    if itemindex == 64 then --revolver fix
                        local m_flPostponeFireReadyTime = entity_get_prop(weapon, "m_flPostponeFireReadyTime")

                        if m_flPostponeFireReadyTime then --not perfect
                            local delta = m_flPostponeFireReadyTime - curtime

                            if cmd.in_attack == 1 and delta < 0.01 then
                                return false
                            elseif cmd.in_attack == 0 and cmd.in_attack2 == 1 and delta >= 3.4028234663853 then
                                return false
                            end
                        else
                            return false
                        end
                    else
                        return false
                    end
                else
                    local burst = entity_get_prop(weapon, "m_iBurstShotsRemaining")

                    if burst ~= nil and burst > 0 then
                        return false
                    end
                end
            end
        end

        if self.grenade_release_timer > curtime then
            return false
        end

        return true
    end,

    micromovemnt_switch = false,

    micromove = function(self, cmd)
        local flags = entity_get_prop(lp, "m_fFlags")

        if flags then
            local air = bit.band(flags, 1) == 0
            local speed = player_fn.speed(lp)

            if cmd.forwardmove == 0 and cmd.sidemove == 0 and air == false and speed < 3.1 then
                local duck_amount = entity_get_prop(lp, "m_flDuckAmount") or 0
                local amount = duck_amount > 0.1 and 3.10 or 1.10
                cmd.sidemove = self.micromovemnt_switch and amount or -amount
                self.micromovemnt_switch = not self.micromovemnt_switch
            end
        end
    end,

    do_antiaim = function(self, cmd, pitch_mode, at_targets, freestanding, yaw_offset, yaw_jitter, yaw_jitter_offset, body_yaw, body_yaw_offset, fake_yaw_limit, roll)
        body_yaw = body_yaw or "Static"
        body_yaw_offset = body_yaw_offset or 60
        fake_yaw_limit = 60

        --dont ask why
        body_yaw_offset = -body_yaw_offset

        local pitch, yaw = client_camera_angles()

        if self:should_run_antiaim(cmd) == false then
            return
        end

        local set_pitch, set_yaw = pitch, math_fn.normalize_yaw(yaw + 180)
        local set_desync_value = 0

        --Pitch
        if pitch_mode == "Minimal" then
            set_pitch = 89
        elseif pitch_mode == "Up" then
            set_pitch = -89
        elseif pitch_mode == "Off" then
            set_pitch = pitch - 0.00001
        end

        --Yaw
        if at_targets then
            if variables.target then
                local lp_eye_position = {client_eye_position()}
                local target_eye_position = player_fn.eye_position(variables.target)

                if lp_eye_position ~= nil and target_eye_position ~= nil then
                    local angle = math_fn.calc_angle(lp_eye_position, target_eye_position)
                    set_yaw = math_fn.normalize_yaw(angle[2] + 180)
                end
            end
        end

        if freestanding then
            local freestanding_yaw = damage_fn:freestanding_yaw()

            if freestanding_yaw ~= nil then
                set_yaw = freestanding_yaw
            end
        else
            if static then
                set_yaw = yaw_offset
            else
                set_yaw = math_fn.normalize_yaw(set_yaw + yaw_offset)
            end
        end

        --Yaw jitter
        if yaw_jitter == "Offset" then
            if self.jitter then
                set_yaw = math_fn.normalize_yaw(set_yaw + yaw_jitter_offset)
            end
        elseif yaw_jitter == "Center" then
            if self.jitter then
                set_yaw = math_fn.normalize_yaw(set_yaw + yaw_jitter_offset/2)
            else
                set_yaw = math_fn.normalize_yaw(set_yaw - yaw_jitter_offset/2)
            end
        elseif yaw_jitter == "Random" then
            set_yaw = math_fn.normalize_yaw(set_yaw + math.random(-yaw_jitter_offset/2, yaw_jitter_offset/2))
        end

        --Desync
        fake_yaw_limit = math_fn.clamp(0, 60, fake_yaw_limit)
        body_yaw_offset = math_fn.clamp(-fake_yaw_limit, fake_yaw_limit, body_yaw_offset)

        if body_yaw == "Opposite" then
            local fake_real_delta = 60
            set_desync_value = fake_real_delta > 0 and fake_yaw_limit or -fake_yaw_limit
        elseif body_yaw == "Static" then
            set_desync_value = body_yaw_offset
        elseif body_yaw == "Jitter" then
            set_desync_value = (self.jitter and body_yaw_offset or -body_yaw_offset)
        end

        if body_yaw ~= "Off" then
            if self.liimt ~= nil then
                cmd.allow_send_packet = cmd.chokedcommands > self.liimt
            else
                cmd.allow_send_packet = cmd.chokedcommands > 1
            end

            local body_yaw = math_fn.normalize_yaw(ffi_fn.body_yaw - ffi_fn.abs_yaw)

            if set_desync_value < 0 then
                if body_yaw > (set_desync_value - 5) then
                    set_desync_value = -set_desync_value
                end
            else
                if body_yaw < (set_desync_value + 5) then
                    set_desync_value = -set_desync_value
                end
            end

            --Apply desync
            if cmd.chokedcommands == 0 then
                local max_dys = ffi_fn:get_max_desync(lp)

                set_desync_value = -set_desync_value

                if set_desync_value > 0 then
                    set_yaw = set_yaw + max_dys + set_desync_value
                else
                    set_yaw = set_yaw - max_dys + set_desync_value
                end
            end

            --self:micromove(cmd)
        end

        cmd.pitch = set_pitch
        cmd.yaw = set_yaw + 0.0001
        cmd.roll = roll
    end,

    --Other
    networked_side = false,
    choke_resets = 0,
    fire_angle = nil,
    ground_time = 0,
    last_registered_shot_time = 0,
    last_shot_time = 0,
    jitter = false,
    switch = false,
    flip_on_shot = false,
    duck_amount = 0,
    movestate = "stand",
    last_hits = {},
    legit_aa_timer = 0,
    last_leg = 0,

    --Manaul
    left_ready = true,
    right_ready = true,
    manual_state = "back",

    --visual shit

    --Double tap
    shift = 0,
    shift_time = 0,
    old_sim_time = 0,
    last_fake_lag = 0,

    --Fake flick
    fake_flick_cycle = 0,
    fake_flick_delay = 0,
    fake_flick_timer = 0,
    last_fake_flick_time = 0,
    fake_flick_toggled = false,
    fake_flick_cleared = false,
    disable_dt_next = false,

    --Freestanding
    custom_freestanding_active = false,

    --LC Stuff
    last_origin = {0, 0, 0},
    lag_comp_percent = 0,
    origin_delta = 0,

    --Alternate algorithm
    headshot_count = 0,

    --ab
    backtrack = {},
    exquisite = {},
    last_alive = 0,

    local_visible = function(self, index)
        local origin = player_fn.eye_position(index)

        if origin == nil or origin[1] == nil then
            return false
        end

        for i = 6, 8 do
            local hb = {entity_hitbox_position(lp, i)}

            if hb ~= nil and hb[1] ~= nil then
                local trace = {client_trace_line(index, origin[1], origin[2], origin[3], hb[1], hb[2], hb[3])}

                if trace[1] == 1 or trace[2] == lp then
                    return true
                end
            end
        end

        return false
    end,

    anti_backstab = function(self)
        if lp == nil or entity_is_alive(lp) == false then
            return nil
        end

        local nearest_target = {175, nil, nil}
        local lp_origin = {entity_get_origin(lp)}

        if lp_origin == nil or lp_origin[1] == nil then
            return nil
        end

        local enemies = entity_get_players(true)

        for i = 1, #enemies do
            local enemy = enemies[i]
            local weapon = entity_get_player_weapon(enemy)

            if weapon ~= nil and entity.get_classname(weapon) == "CKnife" and entity_is_dormant(enemy) == false then
                local enemy_origin = {entity_get_origin(enemy)}

                if enemy_origin ~= nil and enemy_origin[1] ~= nil then
                    local dist = math_fn.distance2d(lp_origin, enemy_origin)

                    if dist < nearest_target[1] and self:local_visible(enemy) then
                        nearest_target = {dist, enemy_origin, enemy}
                    end
                end
            end
        end

        if nearest_target[3] ~= nil then
            local yaw = math_fn.calc_angle(lp_origin, nearest_target[2])
            return yaw[2]
        end

        return nil
    end,

    last_z = 0,
    height_timer = 0,

    height_disadvantage = function(self)
        if variables.target == nil or entity_is_alive(variables.target) == false or lp == nil then
            return false
        end

        local eye = player_fn.eye_position(variables.target)

        if self.last_z == nil or eye[3] == nil then
            return false
        end

        if (eye[3] - self.last_z) < 15 then
            self.height_timer = globals_tickcount()
        end

        return (globals_tickcount() - self.height_timer) > 7
    end,

    --For all the aa presets
    config = function(self, cmd)
        local player = {
            shots = 0,
            side = nil,
            last_shot_time = 0
        }

        local aa = {
            name = "exquisite",
            bp = nil,
            yaw_static = false,
            yaw_value = 0,
            yaw_jitter = "Off",
            yaw_jitter_value = 0,
            body_yaw = "Static",
            body_yaw_value = 180,
            fake_yaw = 60,
            roll = nil,

            color = {255, 255, 255, 255},
            color2 = nil,

            preset = nil,

            dt = false,
            custom_desync = false, --Set to true to use custom desync
            legit_anti_aim = false
        }

        if variables.target ~= nil and player_fn.valid(variables.target) then
            player = player_fn.players[variables.target]
        end

        local options_g = get(menu.options)
        local antibrute_active = player.shots ~= 0
        local shot_at_angle = player.side
        local team = entity_get_prop(lp, "m_iTeamNum") == 3
        local desync_amount = math_fn.normalize_yaw(ffi_fn.goal_feet_yaw - ffi_fn.abs_yaw)

        local events = {
            freestanding = variables.freestanding,
            jitter = self.jitter,
            movement_side = damage_fn.movement,
            manual = self.manual_state,
            air = self.ground_time < 4,
            slowwalk = get(ref.slow_motion[1]) and get(ref.slow_motion[2]),
            duck = self.duck_amount > 0.5,
            flip_on_shot = self.flip_on_shot,
            doubletap_active = self.shift_time > 10,
            legit_aa = cmd.in_use == 1,
            cmd = cmd,
            on_ct = team,
            on_t = not team,
            speed = player_fn.speed(lp) or 0,
            movestate = "stand",
            fake_duck = get(ref.fakeduck),
            quick_peek = get(menu.quick_peek) and get(menu.quick_peek_key),

            abs_yaw = ffi_fn.abs_yaw,
            fake_yaw = ffi_fn.goal_feet_yaw,
            desync_angle = -desync_amount,
            desync = math.floor(math_fn.normalize_yaw(ffi_fn.goal_feet_yaw - ffi_fn.body_yaw)),
            avoid_angle = desync_amount > 0 and 180 or -180,
            avoid_overlap_side = desync_amount > 0,
            max_desync = ffi_fn:get_max_desync(lp) or 58,
            target = variables.target or nil,

            height_disadvantage = self:height_disadvantage(),

            vulnerable = damage_fn.vulnerable,
            wide_peeked = damage_fn.wide_peeked,

            color = _G.exquisite_visual_data and _G.exquisite_visual_data.color or {255, 255, 255, 255},
            color2 = _G.exquisite_visual_data and _G.exquisite_visual_data.color2 or {255, 255, 255, 255},
            beta = _G.exquisite_visual_data and _G.exquisite_visual_data.beta or false
        }

        local antibrute = {
            side = player.side,
            missed_shots = player.shots
        }

        if self.ground_time < 4 then
            events.movestate = "air"
        elseif events.speed < 1.1 then
            events.movestate = "stand"
        elseif events.slowwalk then
            events.movestate = "slow"
        else
            events.movestate = "move"
        end
        self.movestate = events.movestate

        local body_yaw_g = get(menu.algorithm_options)
        local old_header_data = nil

        local legit_antiaim_active = (get(menu.legit_antiaim_on_key) and ui_fn.includes(options_g, "Legit anti-aim"))

        if legit_antiaim_active then
            body_yaw_g = get(menu.legit_aa_options)
            if self.legit_aa_timer < globals_realtime() then --To allow picking up weapons
                events.freestanding = not events.freestanding
                events.movement_side = not events.movement_side
            end
        else
            self.legit_aa_timer = globals_realtime() + math_fn.TICKS_TO_TIME(1)
        end

        local algorithm_mode_g = get(menu.algorithm_mode)

        if algorithm_mode_g == "Script builder" then
            aa.name = "Preset builder"

            if antibrute_active and exquisite_algorithm_antibrute ~= nil and type(exquisite_algorithm_antibrute) == "function" then
                setfenv(exquisite_algorithm_antibrute, algorithm.allowed_env)
                exquisite_algorithm_antibrute(aa, events, antibrute)
            elseif exquisite_algorithm_builder_aa ~= nil and type(exquisite_algorithm_builder_aa) == "function" then
                setfenv(exquisite_algorithm_builder_aa, algorithm.allowed_env)
                exquisite_algorithm_builder_aa(aa, events)
            end

            body_yaw_g = aa.preset

            --bc presets will change the name, we want to restore them
            if aa.preset ~= nil then
                old_header_data = {aa.name, aa.color}
            end
        elseif algorithm_mode_g == "Menu builder" then
            local movestate = "Stand"

            if events.movestate == "stand" then
                movestate = "Stand"
            elseif events.movestate == "slow" then
                movestate = "Slow motion"
            elseif events.movestate == "move" then
                movestate = "Move"
            else
                movestate = "Air"
            end

            if movestate ~= "Air" and events.duck then
                movestate = "Duck"
            end

            if ui.is_menu_open() == false then
                set(menu.builder_movestate, movestate)
            end

            for i = 1, #menu.builder do
                local builder = menu.builder[i]

                if builder.state == movestate then
                    aa.name = "Builder: " .. builder.state

                    aa.yaw_value = get(builder.yaw)

                    local yaw_jitter_g = get(builder.yaw_jitter)

                    if yaw_jitter_g == "Offset" then
                        if self.jitter then
                            aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + get(builder.yaw_jitter_value))
                        end
                    elseif yaw_jitter_g == "Center" then
                        if self.jitter then
                            aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + get(builder.yaw_jitter_value)/2)
                        else
                            aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value - get(builder.yaw_jitter_value)/2)
                        end
                    elseif yaw_jitter_g == "Random" then
                        aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + math.random(-get(builder.yaw_jitter_value)/2, get(builder.yaw_jitter_value)/2))
                    end

                    local body_g = get(builder.body_yaw)

                    if body_g == "Jitter" and get(builder.body_yaw_value) == 0 then
                        aa.body_yaw = "Static"
                        aa.body_yaw_value = self.jitter and 180 or -180
                    else
                        aa.body_yaw = get(builder.body_yaw)
                        aa.body_yaw_value = get(builder.body_yaw_value)
                    end
                    aa.yaw_jitter = "Off"
                --    aa.fake_yaw = get(builder.fake_yaw_limit)

                    local roll_g = get(builder.roll)

                    if roll_g == "Static" then
                        aa.roll = get(builder.roll_value)
                    elseif roll_g == "Jitter" then
                        aa.roll = self.jitter and get(builder.roll_value) or -get(builder.roll_value)
                    end
                end
            end
        end


        if algorithm_mode_g == "Presets" or aa.preset then


				 if body_yaw_g == "Sayuki" then
                local health = entity.get_prop(lp, "m_iHealth") or 100
                local health_update = false

                if health ~= variables.old_health then
                    variables.old_health = health
                    variables.should_jitter = true

                    client.delay_call(math.random(1, 3), function()
                        variables.should_jitter = false
                    end)
                end


                local function sway(max, speed, min) return math_abs(math_floor(math_sin(globals_curtime() / speed * 1) * max)) end

                local roll_table = {-50, 50}

                local mode_table = {
                    ["vulnerable"] = {
                        ["stand"] =     { 0, "Center", 36, "Jitter", 0, 60, 0},
                        ["air"] =       { events.jitter and 7 or -7, "Center", 73, "Jitter", 0, 60, 0 },
                        ["move"] =      { events.jitter and 5 or -18, "Center", 56, "Jitter", 0, 60, 0 },
                        ["move106"] =   { events.jitter and 5 or -18, "Center", 57, "Jitter", 0, 60, 0 },
                        ["move135"] =   { events.jitter and 5 or -18, "Center", 55, "Jitter", 0, 60, 0 },
                        ["slow"] =      { 0, "Center", events.jitter and 50 or -50, "Jitter", 0, 60, 0},
                        ["duck"] =      { 0, "Center", 48, "Jitter", 0, 60, 0},
                        ["E"] =         { events.jitter and 180 or -180, "Center", events.jitter and 20 or -20, "Jitter", events.jitter and 180 or -180, 60, roll_table[client.random_int(1, 2)]},

                    },
                    ["not_vulnerable"] = {
                        ["stand"] =     { 0, "Center", 36, "Jitter", 0, 60, 0},
                        ["air"] =       { events.jitter and 7 or -7, "Center", 73, "Jitter", 0, 60, 0 },
                        ["move"] =      { events.jitter and 5 or -18, "Center", 56, "Jitter", 0, 60, 0 },
                        ["slow"] =      { 0, "Center", events.jitter and 50 or -50, "Jitter", 0, 60, 0},
                        ["duck"] =      { 0, "Center", 48, "Jitter", 0, 60, 0},
                        ["E"] =         { events.jitter and 180 or -180, "Center", events.jitter and 20 or -20, "Jitter", events.jitter and 180 or -180, 60, roll_table[client.random_int(1, 2)]},
                    },
                    ["randomization_values"] = {
                        ["xjv"] = {-83, -50},
                        ["xby"] = {-83, -50},
                        ["fy"] = {30, 45, 60},
                        ["xrll"] = {-50, -25, 25, 50},
                    },
                    ["antibrute"] = {
                        ["dynamic"] = {
                            ["base"] = { 3, "Random", 8, "Static", -60, 60, 50},
                            ["safe"] = {
                                ["safe_yaw_jitter"] = {-8, -2, 8},
                                ["safe_body_yaw"] = {-60, 60},
                                ["roll"] = {-50, -25, 25, 50},
                            },
                            ["hurt"] = {},
                        },

                        ["left"] = {0, "Random", math.random(10, 15), "Static", -157, math.random(55, 60), math.random(30, 40) },
                        ["right"] = {0, "Random", math.random(-15, -10), "Static", 58, math.random(40, 55), math.random(-50, -35) },
                        ["jitter"] = {},

                    },
                }

                local function set_aa_table(aa, aa_table)
                    aa.yaw_value = aa_table[1]
                    aa.yaw_jitter = aa_table[2]
                    aa.yaw_jitter_value = aa_table[3]
                    aa.body_yaw =  aa_table[4]
                    aa.body_yaw_value = aa_table[5]
                    aa.fake_yaw = aa_table[6]
                    aa.roll = aa_table[7]
                end

                local function aa_stand(aa, events)


                    set_aa_table(aa, mode_table.not_vulnerable.stand)
                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.stand)
                        -- jitters roll + and -
                        mode_table.vulnerable.stand[7] =  mode_table.vulnerable.stand[7] * -1
                    end
                    if math_abs(events.desync_angle) > 5 then
                        aa.body_yaw_value = events.avoid_angle
                    end
                end

                local function aa_air(aa, events)


                    -- call sway to update value
                    mode_table.not_vulnerable.air[6] = sway(58, 1.0, 15)
                    set_aa_table(aa, mode_table.not_vulnerable.air)

                    if events.vulnerable == true then
                        set_aa_table(aa, mode_table.vulnerable.air)
                    end

                end

                local function aa_move(aa, events)
                    set_aa_table(aa, mode_table.not_vulnerable.move)

                    local velocity = events.speed;
                    if events.vulnerable == true then

                        if velocity > 135 then
                            set_aa_table(aa, mode_table.vulnerable.move)
                        elseif velocity > 106 then
                            set_aa_table(aa, mode_table.vulnerable.move)
                        end
                    else
                        if velocity > 135 then
                            set_aa_table(aa, mode_table.not_vulnerable.move)

                            if math_abs(events.desync_angle) > 5 then
                                aa.body_yaw_value = events.avoid_angle
                            end
                        elseif velocity > 106 then
                            set_aa_table(aa, mode_table.not_vulnerable.move)
                        end
                    end

                end

                local function aa_slow(aa, events)

                    if events.vulnerable == true then
                        mode_table.vulnerable.slow[5] = mode_table.vulnerable.slow[5] * 1
                        set_aa_table(aa, mode_table.vulnerable.slow)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.slow)
                    end

                end

                local function aa_duck(aa, events)

                    if events.vulnerable == true then
                        set_aa_table(aa, mode_table.vulnerable.duck)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.duck)
                    end

                end

                local function aa_e(aa, events)

                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.E)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.E)
                    end
                end

                if antibrute_active then
                    local function randomize_table()
                        mode_table.antibrute.dynamic.base[3] = mode_table.randomization_values.xjv[client.random_int(1,2)]
                        mode_table.antibrute.dynamic.base[5] = mode_table.randomization_values.xby[client.random_int(1,2)]
                    end

                    local antibrute_table = {mode_table.antibrute.left, mode_table.antibrute.right}

                    if variables.should_jitter then
                        --hurt
                        set_aa_table(aa, antibrute_table[math.random(1,2)])

                    else

                        aa.body = "Static"
                    end
                else
                    if #entity_get_players(true) == 0 then

                        aa.yaw_jitter = "Off"
                        aa.yaw_jitter_value = 0;
                        aa.body_yaw = "Static"
                        aa.body_yaw_value = events.freestanding and 60 or -60;
                        aa.fake_yaw = 60
                    else
                        if events.movestate == "stand" then
                            aa_stand(aa, events)
                        elseif events.movestate == "air" then
                            aa_air(aa, events)
                        elseif events.movestate == "move" then
                            aa_move(aa, events)
                        elseif events.movestate == "slow" then
                            aa_slow(aa, events)
                        end

                        if events.duck and events.movestate == "stand" or (events.duck and events.movestate == "move") or (events.duck and events.movestate == "slow") or events.double_active then
                            aa_duck(aa, events)
                        end
                        if events.legit_aa then
                            aa_e(aa, events)
                        end
                    end
                end
				 elseif body_yaw_g == "Sayuki R Edition" then
                local health = entity.get_prop(lp, "m_iHealth") or 100
                local health_update = false

                if health ~= variables.old_health then
                    variables.old_health = health
                    variables.should_jitter = true

                    client.delay_call(math.random(1, 3), function()
                        variables.should_jitter = false
                    end)
                end


                local function sway(max, speed, min) return math_abs(math_floor(math_sin(globals_curtime() / speed * 1) * max)) end

                local roll_table = {-50, 50}

                local mode_table = {
                    ["vulnerable"] = {
                        ["stand"] =     { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, 58, 33},
                        ["air"] =       { events.jitter and 5 or -9, "Off", 0, "Static", events.freestanding and 95 or -95, 60, 32 },
                        ["move"] =      { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 58 or 59, 28 },
                        ["move106"] =   { events.jitter and 32 or -44, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 58 or 59, 28 },
                        ["move135"] =   { events.jitter and 36 or -43, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 58 or 59, 28 },
                        ["slow"] =      { events.jitter and 26 or -33, "Offset", events.jitter and 23 or -28, "Static", events.jitter and 60 or -60, 58, 38},
                        ["duck"] =      { events.jitter and 35 or -43, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 51 or 60, 33},
                        ["E"] =         { events.jitter and 180 or -180, "Center", events.jitter and 12 or -7, "Jitter", 180, 58, roll_table[client.random_int(1, 2)]},

                    },
                    ["not_vulnerable"] = {
                        ["stand"] =     { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, 58, 33},
                        ["air"] =       { events.jitter and 5 or -9, "Off", 0, "Static", events.freestanding and 95 or -95, 60, 32 },
                        ["move"] =      { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 58 or 59, 28 },
                        ["slow"] =      { events.jitter and 26 or -33, "Offset", events.jitter and 23 or -28, "Static", events.jitter and 60 or -60, 58, 38},
                        ["duck"] =      { events.jitter and 35 or -43, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 51 or 60, 33},
                        ["E"] =         { events.jitter and 180 or -180, "Center", events.jitter and 20 or -20, "Jitter", events.jitter and 180 or -180, 60, roll_table[client.random_int(1, 2)]},
                    },
                    ["randomization_values"] = {
                        ["xjv"] = {-83, -50},
                        ["xby"] = {-83, -50},
                        ["fy"] = {30, 45, 60},
                        ["xrll"] = {-50, -25, 25, 50},
                    },
                    ["antibrute"] = {
                        ["dynamic"] = {
                            ["base"] = { 3, "Random", 8, "Static", -60, 60, 50},
                            ["safe"] = {
                                ["safe_yaw_jitter"] = {-8, -2, 8},
                                ["safe_body_yaw"] = {-60, 60},
                                ["roll"] = {-50, -25, 25, 50},
                            },
                            ["hurt"] = {},
                        },

                        ["left"] = {0, "Random", math.random(10, 15), "Static", -157, math.random(55, 60), math.random(30, 40) },
                        ["right"] = {0, "Random", math.random(-15, -10), "Static", 58, math.random(40, 55), math.random(-50, -35) },
                        ["jitter"] = {},

                    },
                }

                local function set_aa_table(aa, aa_table)
                    aa.yaw_value = aa_table[1]
                    aa.yaw_jitter = aa_table[2]
                    aa.yaw_jitter_value = aa_table[3]
                    aa.body_yaw =  aa_table[4]
                    aa.body_yaw_value = aa_table[5]
                    aa.fake_yaw = aa_table[6]
                    aa.roll = aa_table[7]
                end

                local function aa_stand(aa, events)



                    set_aa_table(aa, mode_table.not_vulnerable.stand)
                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.stand)
                        -- jitters roll + and -
                        mode_table.vulnerable.stand[7] =  mode_table.vulnerable.stand[7] * -1
                    end
                    if math_abs(events.desync_angle) > 5 then
                        aa.body_yaw_value = events.avoid_angle
                    end
                end

                local function aa_air(aa, events)



                    -- call sway to update value
                    mode_table.not_vulnerable.air[6] = sway(58, 1.0, 15)
                    set_aa_table(aa, mode_table.not_vulnerable.air)

                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.air)
                    end


                end

                local function aa_move(aa, events)
                    set_aa_table(aa, mode_table.not_vulnerable.move)

                    local velocity = events.speed;
                    if events.vulnerable == true then


                        if velocity > 135 then
                            set_aa_table(aa, mode_table.vulnerable.move)
							mode_table.vulnerable.move[7] =  mode_table.vulnerable.move[7] * -1
                        elseif velocity > 106 then
                            set_aa_table(aa, mode_table.vulnerable.move)
							mode_table.vulnerable.move[7] =  mode_table.vulnerable.move[7] * 1
                        end
                    else

                        if velocity > 135 then
                            set_aa_table(aa, mode_table.not_vulnerable.move)

                            if math_abs(events.desync_angle) > 5 then
                                aa.body_yaw_value = events.avoid_angle
                            end
                        elseif velocity > 106 then
                            set_aa_table(aa, mode_table.not_vulnerable.move)
                        end
                    end


                end

                local function aa_slow(aa, events)

                    if events.vulnerable == true then

                        mode_table.vulnerable.slow[5] = mode_table.vulnerable.slow[5] * 1
                        set_aa_table(aa, mode_table.vulnerable.slow)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.slow)
                    end

                end

                local function aa_duck(aa, events)

                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.duck)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.duck)
                    end

                end

                local function aa_e(aa, events)

                    if events.vulnerable == true then

                        set_aa_table(aa, mode_table.vulnerable.E)
                    else

                        set_aa_table(aa, mode_table.not_vulnerable.E)
                    end
                end

                if antibrute_active then
                    local function randomize_table()
                        mode_table.antibrute.dynamic.base[3] = mode_table.randomization_values.xjv[client.random_int(1,2)]
                        mode_table.antibrute.dynamic.base[5] = mode_table.randomization_values.xby[client.random_int(1,2)]
                    end

                    local antibrute_table = {mode_table.antibrute.left, mode_table.antibrute.right}

                    if variables.should_jitter then
                        --hurt
                        set_aa_table(aa, antibrute_table[math.random(1,2)])

                    else

                        aa.body = "Static"
                    end
                else
                    if #entity_get_players(true) == 0 then

                        aa.yaw_jitter = "Off"
                        aa.yaw_jitter_value = 0;
                        aa.body_yaw = "Static"
                        aa.body_yaw_value = events.freestanding and 60 or -60;
                        aa.fake_yaw = 60
                    else
                        if events.movestate == "stand" then
                            aa_stand(aa, events)
                        elseif events.movestate == "air" then
                            aa_air(aa, events)
                        elseif events.movestate == "move" then
                            aa_move(aa, events)
                        elseif events.movestate == "slow" then
                            aa_slow(aa, events)
                        end

                        if events.duck and events.movestate == "stand" or (events.duck and events.movestate == "move") or (events.duck and events.movestate == "slow") or events.double_active then
                            aa_duck(aa, events)
                        end
                        if events.legit_aa then
                            aa_e(aa, events)
                        end
                    end
                end
              elseif body_yaw_g == "Tank" then
                  if events.movestate == "stand" then
                      aa.yaw_value = events.jitter and -33 or 35
                      aa.yaw_jitter = "Off"
                      aa.yaw_jitter_value = 0
                      aa.body_yaw = "Static"
                      aa.body_yaw_value = events.jitter and -60 or 60
                      aa.fake_yaw = 60
                  elseif events.movestate == "air" then
                      aa.yaw_value = events.jitter and -15 or 22
                      aa.yaw_jitter = "Off"
                      aa.yaw_jitter_value = 0
                      aa.body_yaw = "Jitter"
                      aa.body_yaw_value = events.jitter and -60 or 60
                      aa.fake_yaw = 60
                  elseif events.movestate == "move" then
                      aa.yaw_value = events.jitter and -37 or 43
                      aa.yaw_jitter = "Off"
                      aa.yaw_jitter_value = 0
                      aa.body_yaw = "Static"
                      aa.body_yaw_value = events.jitter and -60 or 60
                      aa.fake_yaw = 60
                  elseif events.movestate == "slow" then
                      aa.yaw_value = events.jitter and -35 or 41
                      aa.yaw_jitter = "Off"
                      aa.yaw_jitter_value = 0
                      aa.body_yaw = "Static"
                      aa.body_yaw_value = events.jitter and -60 or 60
                      aa.fake_yaw = 60
                    end
                  elseif body_yaw_g == "Tank 2" then
                      if events.movestate == "stand" then
                        aa.yaw_value = events.jitter and -5 or 5
                        aa.yaw_jitter = "Center"
                        aa.yaw_jitter_value = 65
                          aa.body_yaw = "Jitter"
                          aa.body_yaw_value = 0
                          aa.fake_yaw = 58
                      elseif events.movestate == "air" then
                          aa.yaw_value = events.jitter and -5 or 5
                          aa.yaw_jitter = "Center"
                          aa.yaw_jitter_value = 15
                          aa.body_yaw = "Jitter"
                          aa.body_yaw_value = 0
                          aa.fake_yaw = 58
                      elseif events.movestate == "move" then
                          aa.yaw_value = events.jitter and -5 or 5
                          aa.yaw_jitter = "Center"
                          aa.yaw_jitter_value = 65
                          aa.body_yaw = "Jitter"
                          aa.body_yaw_value = 0
                          aa.fake_yaw = 58
                      elseif events.movestate == "slow" then
                        aa.yaw_value = events.jitter and -5 or 5
                        aa.yaw_jitter = "Center"
                        aa.yaw_jitter_value = 65
                          aa.body_yaw = "Jitter"
                          aa.body_yaw_value = 0
                          aa.fake_yaw = 58
                        elseif events.movestate == "Duck" then
                            aa.yaw_value = -10
                            aa.yaw_jitter = "Center"
                            aa.yaw_jitter_value = 14
                            aa.body_yaw = "Static"
                            aa.body_yaw_value = -180
                            aa.fake_yaw = 60
                        end
                      elseif body_yaw_g == "Devil" then
                        if events.movestate == "stand" then
                          aa.yaw_value = 0
                          aa.yaw_jitter = "Off"
                          aa.yaw_jitter_value = 0
                            aa.body_yaw = "Opposite"
                            aa.body_yaw_value = 0
                            aa.fake_yaw = 60
                        elseif events.movestate == "air" then
                            aa.yaw_value = 0
                            aa.yaw_jitter = "Center"
                            aa.yaw_jitter_value = 15
                            aa.body_yaw = "Jitter"
                            aa.body_yaw_value = 0
                            aa.fake_yaw = 60
                        elseif events.movestate == "move" then
                            aa.yaw_value = 0
                            aa.yaw_jitter = "Center"
                            aa.yaw_jitter_value =  80
                            aa.body_yaw = "Jitter"
                            aa.body_yaw_value = 0
                            aa.fake_yaw = 45
                        elseif events.movestate == "slow" then
                          aa.yaw_value = 0
                          aa.yaw_jitter = "Offset"
                          aa.yaw_jitter_value = events.freestanding and 77 or -18
                            aa.body_yaw = "Jitter"
                            aa.body_yaw_value = 0
                            aa.fake_yaw = 45
                        else
                            aa.yaw_value = 0
                            aa.yaw_jitter = "Offset"
                            aa.yaw_jitter_value = 23
                              aa.body_yaw = "Opposite"
                              aa.body_yaw_value = 0
                              aa.fake_yaw = 60
                          end
                      elseif body_yaw_g == "Sway" then
                        if antibrute_active == false then
                        local function sway(max, speed, min) return math_abs(math_floor(math_sin(globals_curtime() / speed * 1) * max)) end
                          if events.movestate == "stand" then
                              aa.yaw_value = 0
                              aa.yaw_jitter = "Off"
                              aa.yaw_jitter_value = 0
                              aa.body_yaw = "Static"
                              aa.body_yaw_value = events.freestanding and 180 or -180
                              aa.fake_yaw = sway(61, 1.0, 1)
                          elseif events.movestate == "air" then
                              aa.yaw_value = 0
                              aa.yaw_jitter = "Off"
                              aa.yaw_jitter_value = 0
                              aa.body_yaw = "Static"
                              aa.body_yaw_value = events.freestanding and 180 or -180
                              aa.fake_yaw = sway(61, 1.0, 1)
                          elseif events.movestate == "move" then
                              aa.yaw_value = 0
                              aa.yaw_jitter = "Off"
                              aa.yaw_jitter_value = 0
                              aa.body_yaw = "Static"
                              aa.body_yaw_value = events.freestanding and 180 or -180
                              aa.fake_yaw = sway(61, 1.0, 1)
                          elseif events.movestate == "slow" then
                              aa.yaw_value = 0
                              aa.yaw_jitter = "Off"
                              aa.yaw_jitter_value = 0
                              aa.body_yaw = "Static"
                              aa.body_yaw_value = events.freestanding and 180 or -180
                              aa.fake_yaw = sway(61, 1.0, 1)
                            end
                          else
                              aa.body_yaw_value = antibrute.side and -25 or 25
                          end
                      elseif body_yaw_g == "Jitter" then
                          if events.movestate == "air" then
                              aa.yaw_jitter = "Center"
                              aa.yaw_jitter_value = 22
                              aa.body_yaw = "Jitter"
                              aa.body_yaw_value = 0
                              aa.fake_yaw_limit = 54
                          elseif events.movestate == "move" then
                              aa.yaw_jitter = "Center"
                              aa.yaw_jitter_value = 55
                              aa.body_yaw = "Static"
                              aa.body_yaw_value = -5
                              aa.fake_yaw_limit = 58
                          elseif events.movestate == "slow" then
                              aa.yaw_jitter = "Center"
                              aa.yaw_jitter_value = 44
                              aa.body_yaw = "Jitter"
                              aa.body_yaw_value = 59
                              aa.fake_yaw_limit = 58
                          elseif events.movestate == "duck" then
                              aa.yaw_jitter = "Center"
                              aa.yaw_jitter_value = 62
                              aa.body_yaw = "Jitter"
                              aa.body_yaw_value = 180
                              aa.fake_yaw_limit = 58
                            elseif events.movestate == "stand" then
                                aa.yaw_jitter = "Center"
                                aa.yaw_jitter_value = 62
                                aa.body_yaw = "Jitter"
                                aa.body_yaw_value = 180
                                aa.fake_yaw_limit = 58
                          end
                      elseif body_yaw_g == "Experimental" then




                                              local function sway(max, speed, min) return math_abs(math_floor(math_sin(globals_curtime() / speed * 1) * max)) end

                                              local roll_table = {-50, 50}
                                              local ab = sway(33,0.01,12)
                                              local bc = math.random(-12,-7)
                                              local cd = math.random(55,60)
                                              local aa2 = math.random (41,50)
                                              local jitter1 = events.jitter and -33 or 25
                                              local jitter2 = events.jitter and 33 or -25
                                              local mode_table = {
                                                  ["vulnerable"] = {
                                                      ["stand"] =     { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, 58, 0},
                                                      ["air"] =       { events.jitter and -33 or 19, "Off", 73, "Jitter", 0, 60, 0 },
                                                      ["move"] =      { events.jitter and 34 or -22, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 60 or 56, 0},
                                                      ["move106"] =   { events.jitter and 34 or -22, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 60 or 56, 0},
                                                      ["move135"] =   { events.jitter and 34 or -22, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 60 or 56, 0},
                                                      ["slow"] =      { events.jitter and events.jitter and 33 or -16 or events.jitter and -33 or 16, "Off", 0, "Static", events.jitter and 180 or -180, events.jitter and cd or ab, 0},
                                                      ["duck"] =      { events.jitter and -14 or 19, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 55 or 57, 0},
                                                      ["E"] =         { events.jitter and 180 or -180, "Center", events.jitter and 12 or -7, "Jitter", 60, 58, 0},

                                                  },
                                                  ["not_vulnerable"] = {
                                                    ["stand"] =     { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, 58, 0},
                                                    ["air"] =       { events.jitter and -33 or 19, "Off", 73, "Jitter", 0, 60, 0 },
                                                    ["move"] =      { events.jitter and 34 or -22, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 60 or 56, 0},
                                                    ["slow"] =       { events.jitter and events.jitter and 33 or -16 or events.jitter and -33 or 16, "Off", 0, "Static", events.jitter and 180 or -180, events.jitter and cd or ab, 0},
                                                    ["duck"] =      { events.jitter and -14 or 19, "Off", 0, "Static", events.jitter and 60 or -60, events.jitter and 55 or 57, 0},
                                                    ["E"] =         { events.jitter and 43 or -34, "Off", 0, "Static", events.jitter and 60 or -60, 58, 0},
                                                  },
                                                  ["randomization_values"] = {
                                                      ["xjv"] = {-83, -50},
                                                      ["xby"] = {-83, -50},
                                                      ["fy"] = {30, 45, 60},
                                                      ["xrll"] = {-50, -25, 25, 50},
                                                  },
                                                  ["antibrute"] = {
                                                      ["dynamic"] = {
                                                          ["base"] = { events.jitter and -5 or 12, "Off", 0, "Jitter", 0, 60, 0},
                                                          ["safe"] = {
                                                              ["safe_yaw_jitter"] = {-6, -2, 6},
                                                              ["safe_body_yaw"] = {-60, 60},
                                                              ["roll"] = {-50, -25, 25, 50},
                                                          },
                                                          ["hurt"] = {},
                                                      },

                                                      ["left"] = {0, "Random", math.random(10, 15), "Static", -157, math.random(55, 60), math.random(30, 40) },
                                                      ["right"] = {0, "Random", math.random(-15, -10), "Static", 58, math.random(40, 55), math.random(-50, -35) },
                                                      ["jitter"] = {},

                                                  },
                                              }

                                              local function set_aa_table(aa, aa_table)
                                                  aa.yaw_value = aa_table[1]
                                                  aa.yaw_jitter = aa_table[2]
                                                  aa.yaw_jitter_value = aa_table[3]
                                                  aa.body_yaw =  aa_table[4]
                                                  aa.body_yaw_value = aa_table[5]
                                                  aa.fake_yaw = aa_table[6]
                                                  aa.roll = aa_table[7]
                                              end

                                              local function aa_stand(aa, events)



                                                  set_aa_table(aa, mode_table.not_vulnerable.stand)
                                                  if events.vulnerable == true then

                                                      set_aa_table(aa, mode_table.vulnerable.stand)
                                                      -- jitters roll + and -
                                                  end
                                              end

                                              local function aa_air(aa, events)



                                                  -- call sway to update value
                                                  set_aa_table(aa, mode_table.not_vulnerable.air)


                                                  if events.vulnerable == true then

                                                      set_aa_table(aa, mode_table.vulnerable.air)
                                                  end


                                              end

                                              local function aa_move(aa, events)
                                                  set_aa_table(aa, mode_table.not_vulnerable.move)
                                                  if events.vulnerable == true then
                                                          set_aa_table(aa, mode_table.vulnerable.move)

                                                  end


                                              end
                                              local function aa_slow(aa, events)

                                                  if events.vulnerable == true then
                                                      set_aa_table(aa, mode_table.vulnerable.slow)

                                                  else
                                                      set_aa_table(aa, mode_table.not_vulnerable.slow)

                                                  end

                                              end

                                              local function aa_duck(aa, events)

                                                  if events.vulnerable == true then

                                                      set_aa_table(aa, mode_table.vulnerable.duck)
                                                  else

                                                      set_aa_table(aa, mode_table.not_vulnerable.duck)
                                                  end

                                              end

                                              local function aa_e(aa, events)

                                                  if events.vulnerable == true then

                                                      set_aa_table(aa, mode_table.vulnerable.E)
                                                  else

                                                      set_aa_table(aa, mode_table.not_vulnerable.E)
                                                  end
                                              end

                                              if antibrute_active then
                                                  local function randomize_table()
                                                      mode_table.antibrute.dynamic.base[3] = mode_table.randomization_values.xjv[client.random_int(1,2)]
                                                      mode_table.antibrute.dynamic.base[5] = mode_table.randomization_values.xby[client.random_int(1,2)]
                                                  end

                                                  local antibrute_table = {mode_table.antibrute.left, mode_table.antibrute.right}

                                              else
                                                  if #entity_get_players(true) == 0 then

                                                      aa.yaw_jitter = "Off"
                                                      aa.yaw_jitter_value = 0;
                                                      aa.body_yaw = "Static"
                                                      aa.body_yaw_value = events.freestanding and 60 or -60;
                                                      aa.fake_yaw = 60
                                                  else
                                                      if events.movestate == "stand" then
                                                          aa_stand(aa, events)
                                                      elseif events.movestate == "air" then
                                                          aa_air(aa, events)
                                                      elseif events.movestate == "move" then
                                                          aa_move(aa, events)
                                                      elseif events.movestate == "slow" then
                                                          aa_slow(aa, events)
                                                      end

                                                      if events.duck and events.movestate == "stand" or (events.duck and events.movestate == "move") or (events.duck and events.movestate == "slow") or events.double_active then
                                                          aa_duck(aa, events)
                                                      end
                                                      if events.legit_aa then
                                                          aa_e(aa, events)
                                                      end
                                                  end
                                              end
            end
        end


        --Never trust shit lol
        aa.yaw_value = math_fn.clamp(-180, 180, aa.yaw_value)
        if aa.yaw_jitter ~= "Off" and aa.yaw_jitter ~= "Offset" and aa.yaw_jitter ~= "Center" and aa.yaw_jitter ~= "Random" then
            aa.yaw_jitter = "Off"
        end
        aa.yaw_jitter_value = math_fn.clamp(-180, 180, aa.yaw_jitter_value)

       if aa.body_yaw ~= "Off" and aa.body_yaw ~= "Opposite" and aa.body_yaw ~= "Jitter" and aa.body_yaw ~= "Static" then
            aa.body_yaw = "Static"
        end
        aa.body_yaw_value = math_fn.clamp(-180, 180, aa.body_yaw_value)
      aa.fake_yaw = math_fn.clamp(0, 60, aa.fake_yaw)

        if old_header_data ~= nil then
            aa.name = old_header_data[1]
           aa.color = old_header_data[2]
       end

        --fix up colors from possible algorithm errors
        if type(aa.color) ~= "table" then
            aa.color = {255, 255, 255, 255}
        else
            for i = 1, 4 do
                if type(aa.color[i]) == "number" then
                    aa.color[i] = math_fn.clamp(0, 255, aa.color[i])
                else
                    aa.color[i] = 255
                end
            end
        end

        if type(aa.color2) ~= "table" then
            aa.color2 = aa.color
        else
            for i = 1, 4 do
                if type(aa.color2[i]) == "number" then
                    aa.color2[i] = math_fn.clamp(0, 255, aa.color2[i])
                else
                    aa.color2[i] = 255
                end
            end
        end

        self.antiaim_color = aa.color
        self.antiaim_color2 = aa.color2
        self.antiaim_name = aa.name
        self.antiaim_break_point = aa.bp
        return aa
    end,

    init = function(self)
        for i = 0, 64 do
            table.insert(player_fn.players, {
                shots = 0,
                side = nil,
                last_shot_time = 0,
                headshots = 0
            })
        end
    end,

    net_update_start = function(self)
        if lp == nil or entity_is_alive(lp) == false then
            for i = 1, #player_fn.players do
                local player = player_fn.players[i]
                player.shots = 0
                player.side = nil
                player.last_shot_time = 0
            end
            return
        end


        for i = 1, #player_fn.players do
            local player = player_fn.players[i]

            --Reset old data
            if player_fn.valid(i, false) == false then
                player.shots = 0
                player.side = nil
                player.last_shot_time = 0
            end
        end
    end,

    net_update_end = function(self) --For getting shifted ticks
        if lp == nil or entity_is_alive(lp) == false then
            return
        end

        self.last_alive = globals_realtime()

        local sim_time = entity_get_prop(lp, "m_flSimulationTime")
        if sim_time ~= nil then
            if self.old_sim_time ~= sim_time then
                self.shift = (sim_time/globals_tickinterval()) - globals_tickcount()
                self.old_sim_time = sim_time
            end
        end
    end,

    weapon_fire = function(self, e)
        local userid = client.userid_to_entindex(e.userid)

        if userid ~= lp then
            return
        end

        local tickcount = globals_tickcount()

        if self.last_shot_time < tickcount then --To avoid "double flipping" while double tapping
            self.last_registered_shot_time = globals_realtime()
            self.switch = not self.switch
            self.shot_at_angle = not self.shot_at_angle
            self.choke_resets = 0
            self.last_shot_time = tickcount + 5
        end
    end,

    player_hurt = function(self, e)
        local index = client.userid_to_entindex(e.userid)

        if index ~= lp then
            return
        end

        local attacker = client.userid_to_entindex(e.attacker)

        if e.hitgroup == 1 then
            self.headshot_count = self.headshot_count + 1
            player_fn.players[attacker].headshots = player_fn.players[attacker].headshots + 1
        end

        self.last_hits[#self.last_hits + 1] = {
            index = attacker,
            hs = e.hitgroup == 1,
            damage = e.dmg_health,
            time = globals_tickcount(),
        }
    end,

    bullet_impact = function(self, e, tickcount, lp_eye_position, origin, target_eye_position, curtime, height_disadvantage, networked_side, movement, backtrack, exquisite, is_fake_flick, is_bot, bp, refer)
        local impact = {e.x, e.y, e.z}
        local index = client.userid_to_entindex(e.userid)
        local data = player_fn.players[index]

        local shot_distance, shot_backtrack, shot_max_distance = 999, 0, 0
        local shot_exquisite, shot_impact_point = nil, nil

        for i = #backtrack, 1, -1 do
            local cur_backtrack = backtrack[i]

            local distance_to_player = math_fn.distance2d(target_eye_position, cur_backtrack.eye_position)
            local distance_to_impact = math_fn.distance2d(target_eye_position, impact)
            local bullet_player_point = math_fn.lerp(target_eye_position, impact, (distance_to_player - 16)/distance_to_impact)
            local actual_bullet_player_point = math_fn.lerp(target_eye_position, impact, distance_to_player/distance_to_impact)

            local _, damage = client_trace_bullet(index, target_eye_position[1], target_eye_position[2], target_eye_position[3], bullet_player_point[1], bullet_player_point[2], bullet_player_point[3], true)

            if damage ~= 0 then
                local average_center = (cur_backtrack.eye_position[3] + cur_backtrack.origin[3]) / 2
                local z_distance_from_center = math_abs(actual_bullet_player_point[3] - average_center)

                if z_distance_from_center < 45 then
                    local angle_to_player = math_fn.calc_angle(target_eye_position, cur_backtrack.eye_position)

                    local left_point = math_fn:extrapolate_origin_wall(lp, cur_backtrack.eye_position, math_fn.normalize_yaw(angle_to_player[2] + 90), 25)
                    local right_point = math_fn:extrapolate_origin_wall(lp, cur_backtrack.eye_position, math_fn.normalize_yaw(angle_to_player[2] - 90), 25)

                    local angle_to_left_point = math_fn.calc_angle(target_eye_position, left_point)
                    local angle_to_right_point = math_fn.calc_angle(target_eye_position, right_point)

                    local left_delta = math_abs(math_fn.normalize_yaw(angle_to_left_point[2] - angle_to_player[2]))
                    local right_delta = math_abs(math_fn.normalize_yaw(angle_to_right_point[2] - angle_to_player[2]))

                    local max_delta = math_max(left_delta, right_delta)
                    local angle_to_impact = math_fn.calc_angle(target_eye_position, impact)
                    local best_delta = math_fn.normalize_yaw(angle_to_impact[2] - angle_to_player[2])

                    if (math_abs(best_delta) < max_delta) and (math_abs(shot_distance) > math_abs(best_delta)) then
                        shot_distance = best_delta
                        shot_max_distance = max_delta
                        shot_backtrack = cur_backtrack.tickcount
                        shot_exquisite = cur_backtrack.exquisite
                        shot_impact_point = actual_bullet_player_point
                    end
                end
            end
        end

        if shot_exquisite == nil then
            return --failed
        end

        local side = shot_distance < 0

        if side == networked_side then
            side = not side
        end

        local log = {false, false}
        local log_time = 16

        for i = 1, #self.last_hits do
            local hit = self.last_hits[i]

            if hit.index == index then
                local delta = math_abs(hit.time - tickcount)

                if log_time > delta then
                    log = {true, hit.hs, hit.damage, i}
                    log_time = delta
                end
            end
        end

        if log[1] then
            table.remove(self.last_hits, log[4]) --already used, dont need it anymore
        end

        local onshot_delta = (curtime - self.last_registered_shot_time)

        if (ui_fn.includes(get(menu.options), "Anti-bruteforce") or get(menu.logger)) then
            --antibrute
            if ui_fn.includes(get(menu.options), "Anti-bruteforce") then
                data.side = side
                data.shots = data.shots + 1
            end

            --logs
            local flags = {}
            local color = {163, 255, 15}

            if log[1] then
                table.insert(flags, "hit [damage: " .. log[3] .. "]")
            end

            if log[2] then
                table.insert(flags, "headshot")

                if onshot_delta < 0.2 and onshot_delta > 0 then
                    table.insert(flags, "onshot [delta: " .. math_floor(onshot_delta * 1000) .. "ms]")
                end
            end

            if height_disadvantage then
                table.insert(flags, "height disadvantage")
            end

            if is_fake_flick then
                table.insert(flags, "fake flick")
            end

            local flag_string = ""

            if #flags ~= 0 then
                --flag_string = "("
                for i = 1, #flags do
                    flag_string = flag_string .. (#flags == i and flags[i] or (flags[i] .. ", "))
                end
                --flag_string = flag_string .. ")"
            end

            if log[2] then
                color = {255, 75, 75}
            elseif log[1] then
                color = {255, 200, 50}
            end
            local log_fn = {
                create_log = function(type, data, time)
                    if _G.exquisite_log_data == nil then
                        _G.exquisite_log_data = {
                            enabled = false,
                            modes = {},
                            font_style = "Normal",
                            data = {}
                        }
                    end

                    table.insert(_G.exquisite_log_data.data, {
                        type = type,
                        data = data,
                        time = time
                    })
                end,

                init = function()
                    _G.exquisite_log_data = {
                        enabled = false,
                        modes = {},
                        font_style = "Normal",
                        data = {}
                    }
                end
            }
            log_fn.init()


            if get(menu.logger) then
                log_fn.create_log({"console"}, {
                    {color[1], color[2], color[3], "<---------------------------------------------------------->"}
                }, 10)
            end

            local bt_ticks = math_fn.clamp(0, 24, math_abs(tickcount - shot_backtrack))

            log_fn.create_log({"center"}, {
                {color[1], color[2], color[3], entity.get_player_name(index)},
                {255, 255, 255, " shot in your direction"},
                {255, 255, 255, flag_string ~= "" and " (flags: " or ""},
                {color[1], color[2], color[3], flag_string},
                {255, 255, 255, flag_string ~= "" and ")" or ""},
                {255, 255, 255, " (bt: "},
                {color[1], color[2], color[3], bt_ticks},
                {255, 255, 255, ")"},
            }, 5)

            if get(menu.logger) then
                local distance = math.floor(math_abs(shot_distance / shot_max_distance) * 100)
                --client.color_log(color[1], color[2], color[3], "About: \0")
                --client.color_log(255, 255, 255, "Shot count: " .. data.shots .. " | Shot distance: " .. distance .. " unit[s] | Movestate: " .. movement .. " | Max desync: " .. math_floor(ffi_fn:get_max_desync(lp) or -1))
                --client.color_log(color[1], color[2], color[3], "Anti-aim: \0")
                --client.color_log(255, 255, 255, string.format("Algorithm: %s | Yaw: %s | Yaw val: %s | Body yaw: %s | Body yaw value: %s | Fake yaw limit: %s | Break point: %s", (type(self.antiaim_name) == "table" and self.antiaim_name[1] or self.antiaim_name), refer.yaw_jitter, refer.yaw_jitter_value, refer.body_yaw, refer.body_yaw_value, refer.fake_yaw, bp))
                --client.color_log(color[1], color[2], color[3], "<---------------------------------------------------------->")

                log_fn.create_log({"console"}, {
                    {color[1], color[2], color[3], "Anti-aim: "},
                    {255, 255, 255, "Preset: "},
                    {color[1], color[2], color[3], (type(self.antiaim_name) == "table" and self.antiaim_name[1] or self.antiaim_name)},
                    {255, 255, 255, " | Yaw: "},
                    {color[1], color[2], color[3], refer.yaw_jitter},
                    {255, 255, 255, " | Yaw val: "},
                    {color[1], color[2], color[3], refer.yaw_jitter_value},
                    {255, 255, 255, " | Body yaw: "},
                    {color[1], color[2], color[3], refer.body_yaw},
                    {255, 255, 255, " | Body yaw value: "},
                    {color[1], color[2], color[3], refer.body_yaw_value},
                    {255, 255, 255, " | Fake yaw limit: "},
                    {color[1], color[2], color[3], refer.fake_yaw},
                    {255, 255, 255, " | Break point: "},
                    {color[1], color[2], color[3], bp},
                }, 10)

                log_fn.create_log({"console"}, {
                    {color[1], color[2], color[3], "About: "},
                    {255, 255, 255, "shot count: "},
                    {color[1], color[2], color[3], data.shots},
                    {255, 255, 255, " | shot distance: "},
                    {color[1], color[2], color[3], distance},
                    {255, 255, 255, " unit[s] | state: "},
                    {color[1], color[2], color[3], movement},
                    {255, 255, 255, " | max desync: "},
                    {color[1], color[2], color[3], math_floor(ffi_fn:get_max_desync(lp) or -1)},
                }, 10)

                if get(menu.visualize) then
                    debug_fn:create_line(target_eye_position, shot_impact_point, {color[1], color[2], color[3], 100}, 3, true)
                    debug_fn:create_skeleton(shot_exquisite, {color[1], color[2], color[3], 175}, 3, true)
                end
            end

            log_fn.create_log({"corner", "console"}, {
                {255, 255, 255, "["},
                {color[1], color[2], color[3], "anti-bruteforce"},
                {255, 255, 255, "] "},
                {color[1], color[2], color[3], entity.get_player_name(index)},
                {255, 255, 255, " shot in your direction"},
                {255, 255, 255, flag_string ~= "" and " (flags: " or ""},
                {color[1], color[2], color[3], flag_string},
                {255, 255, 255, flag_string ~= "" and ")" or ""},
                {255, 255, 255, " (bt: "},
                {color[1], color[2], color[3], bt_ticks},
                {255, 255, 255, ")"},
            }, 10)

            if get(menu.logger) then
                log_fn.create_log({"console"}, {
                    {color[1], color[2], color[3], "<---------------------------------------------------------->"}
                }, 10)
            end
        end

        --data to share
        --[[
        if is_bot == false and is_fake_flick == false then --ignore data from bots/fake flick hits
            server:create(refer.yaw_jitter, refer.yaw_jitter_value, refer.body_yaw, refer.body_yaw_value, refer.fake_yaw, height_disadvantage, log[2])
        end
        ]]
        --Restrict regardless if ab is on or not
    end,

    aim_fire = function(self, e)
        self.last_registered_shot_time = globals_realtime()
    end,

    run = function(self, cmd)
        self.custom_freestanding_active = false
        self.fake_flick_toggled = false

        --remove old stuff
        for i = #self.last_hits, 1, -1 do
            local hit = self.last_hits[i]

            if hit then
                if (globals_tickcount() - hit.time) > (math_fn.TIME_TO_TICKS(client.real_latency()) + 7) then
                    table.remove(self.last_hits, i)
                end
            end
        end

        if get(menu.enable) == false or lp == nil or entity_is_alive(lp) == false then
            return
        end

        --remove old
        for i = #self.backtrack, 1, -1 do
            local backtrack = self.backtrack[i]

            if backtrack then
                local delta = globals_tickcount() - backtrack.tickcount

                if delta > math_fn.TIME_TO_TICKS(0.25) then
                    table.remove(self.backtrack, i)
                end
            end
        end

        table.insert(self.backtrack, {
            eye_position = {client.eye_position()},
            origin = {entity.get_origin(lp)},
            exquisite = debug_fn.create_exquisite(lp),
            tickcount = globals_tickcount()
        })

        self.last_alive = globals_realtime()

        --update shift timer
        self.shift_time = self.shift < 0 and self.shift_time + 1 or 0

        --Get best target
        player_fn:target()
        damage_fn:freestanding_body_yaw(cmd)

        if cmd.chokedcommands == 0 then
            local by = math_fn.normalize_yaw(ffi_fn.abs_yaw - ffi_fn.body_yaw)
            self.networked_side = by < 0
            self.duck_amount = entity_get_prop(lp, "m_flDuckAmount") or 1
            self.choke_resets = self.choke_resets + 1
            self.fake_flick_cleared = true
            self.jitter = not self.jitter

            --Get z position
            local _, _, z = client.eye_position()
            self.last_z = z

            --movement side shit
            if math_abs(cmd.sidemove) > 0 then
                damage_fn.movement = cmd.sidemove < 0
            end

            --LC
            local origin = {entity_get_origin(lp)}

            if origin then
                local delta = {self.last_origin[1] - origin[1], self.last_origin[2] - origin[2], self.last_origin[3] - origin[3]}

                self.origin_delta = delta[1] * delta[1] + delta[2] * delta[2] + delta[3] * delta[3]
                self.lag_comp_percent = self.origin_delta / 4096
                self.last_origin = origin
            end

            --Fake lag calc
            damage_fn.fake_lag_limit = self.last_fake_lag
        else
            --leg breaker
            local move_angle = math_fn.calc_angle({cmd.forwardmove, cmd.sidemove, 0}, {0, 0, 0})
            move_angle[2] = math_fn.normalize_yaw(move_angle[2])
            self.last_leg = (move_angle[2] / 360) + 0.5
        end

        self.last_fake_lag = cmd.chokedcommands

        --Ground timer
        local flags = entity_get_prop(lp, "m_fFlags")

        if flags then
            if bit.band(flags, 1) == 0 then
                self.ground_time = 0
            else
                self.ground_time = self.ground_time + 1
            end
        else
            self.ground_time = self.ground_time + 1
        end

        --Get antiaim data
        local options_g = get(menu.options)
        local aa = self:config(cmd)
        local pitch = "Minimal"
        local at_targets = false

        if ui_fn.includes(options_g, "At targets") then
            at_targets = true
        end

        if ui_fn.includes(options_g, "Local view in air") and self.ground_time < 4 then
            at_targets = false
        end

        --Freestanding
        local freestanding_active = (ui_fn.includes(options_g, "Freestanding") and get(menu.freestanding_key)) or (get(menu.quick_peek) and get(menu.quick_peek_key))
        local edge_yaw_active = ui_fn.includes(options_g, "Edge yaw") and get(menu.edge_yaw_key)

        --& Manual
        if ui_fn.includes(options_g, "Manual anti-aim") then
            if get(menu.manual_left_key) and self.left_ready then
                if self.manual_state == "left" then
                    self.manual_state = "back"
                else
                    self.manual_state = "left"
                end
                self.left_ready = false
            elseif get(menu.manual_right_key) and self.right_ready then
                if self.manual_state == "right" then
                    self.manual_state = "back"
                else
                    self.manual_state = "right"
                end
                self.right_ready = false
            end

            --Reset manual
            if not get(menu.manual_left_key) then
                self.left_ready = true
            end

            if not get(menu.manual_right_key) then
                self.right_ready = true
            end

            --Apply manual
            if self.manual_state == "left" then
                aa.yaw_value = -90
            elseif self.manual_state == "right" then
                aa.yaw_value = 90
            end

            if self.manual_state ~= "back" then
                at_targets = false
                freestanding_active = false
                edge_yaw_active = false
            end
        else
            self.manual_state = "back"
        end

        --Legit anti-aim
        local legit_antiaim_active = get(menu.legit_antiaim_on_key) and ui_fn.includes(options_g, "Legit anti-aim")

        if legit_antiaim_active then
            if self.legit_aa_timer < globals_realtime() then --To allow picking up weapons
                pitch = "Off"
                aa.yaw_value = 180
                aa.yaw_jitter = "Off"
                at_targets = get(menu.legit_aa_at_targets)
                freestanding_active = false
                --aa.custom_desync = true
            else
                aa.legit_anti_aim = true
            end
        else
            self.legit_aa_timer = globals_realtime() + math_fn.TICKS_TO_TIME(3)
        end

        local anti_backstab_active = false

        if ui_fn.includes(options_g, "Anti-backstab") and cmd.in_use == 0 then
            local angle = self:anti_backstab()

            if angle ~= nil then
                anti_backstab_active = true

                at_targets = false
                freestanding_active = false
                edge_yaw_active = false

                aa.yaw_static = true
                aa.yaw_value = angle
            end
        end

        --On shot side
        local os_state = get(ref.onshot[1]) and get(ref.onshot[2])
        local dt_state = get(ref.doubletap[1]) and get(ref.doubletap[2])

        if get(menu.adaptive_lag) then
            if get(ref.fakeduck) then
                set(ref.limit, 14)
            elseif (self.choke_resets < 2) or (os_state or dt_state) or anti_backstab_active then
                set(ref.limit, 1)
            else
                set(ref.limit, math_fn.clamp(1, 14, get(menu.limit) - (damage_fn.vulnerable and client.random_int(1, 8) or 0)))
            end

            cmd.allow_send_packet = false
        else
            set(ref.limit, math_fn.clamp(1, 14, get(menu.limit)))
        end

        --set fs and edge yaw
        set(ref.freestanding[1], true)
        set(ref.freestanding[2], freestanding_active and "Always on" or "On hotkey")
        set(ref.edge_yaw, edge_yaw_active)

        --on shot side
        local disable_dt = false

        if self.disable_dt_next then
            disable_dt = true
            self.disable_dt_next = false
        end

        if get(menu.quick_peek) then
            set(ref.quickpeek[1], true)

            if get(menu.quick_peek_key) then
                if not get(ref.fakeduck) then
                    set(ref.limit, damage_fn.vulnerable and 1 or 14)
                end

                local quick_peek_options_g = get(menu.quick_peek_options)

                set(ref.freestanding[1], true)
                set(ref.freestanding[2], ui_fn.includes(quick_peek_options_g, "Freestanding") and "Always on" or "On hotkey")
                set(ref.edge_yaw, ui_fn.includes(quick_peek_options_g, "Edge yaw"))

                set(ref.doubletap[2], "Always on")
                set(ref.quickpeek[2], "Always on")
            else
                set(ref.quickpeek[2], "On hotkey")
                set(ref.doubletap[2], get(menu.quick_peek_restore))
            end
        end

        if (self.last_fake_flick_time + 0.3) > globals_realtime() then
            at_targets = true
            aa.yaw_value = (legit_antiaim_active or cmd.in_use == 1) and 180 or 0
            aa.yaw_jitter = "Off"
            if not get(ref.fakeduck) and ((self.last_fake_flick_time + math_fn.TICKS_TO_TIME(5)) > globals_realtime()) then
                set(ref.limit, 1)
            end
            set(ref.freestanding[1], false)
            freestanding_active = false
        end

        if get(menu.fake_flick_enable) and not get(ref.fakeduck) and self.manual_state == "back" then
            local active = false

            if get(menu.fake_flick_activation_mode) == "Hotkey" then
                active = get(menu.fake_flick_hotkey)
            else
                local fake_flick_conditions_g = get(menu.fake_flick_conditions)

                for i = 1, #fake_flick_conditions_g do
                    local c = fake_flick_conditions_g[i]

                    if c == "Stand" and self.movestate == "stand" and self.duck_amount < 0.1 then
                        active = true
                        break
                    elseif c == "Move" and (self.movestate == "move" or self.movestate == "slow") and self.duck_amount < 0.1 then
                        active = true
                        break
                    elseif c == "Air" and (self.ground_time < 4) then
                        active = true
                        break
                    elseif c == "Duck" and self.duck_amount > 0.1 then
                        active = true
                        break
                    end
                end
            end

            if active then
                local fake_flick_requirements_g = get(menu.fake_flick_requirements)
                local met = true

                for i = 1, #fake_flick_requirements_g do
                    local c = fake_flick_requirements_g[i]

                    if c == "Only when vulnerable" and damage_fn.vulnerable == false then
                        met = false
                        break
                    elseif c == "Only when doubletapping" and (dt_state == false or self.shift_time <= 1) then
                        met = false
                        break
                    end
                end

                if met then
                    self.fake_flick_toggled = true
                    at_targets = true
                    aa.yaw_jitter = "Off"
                    set(ref.freestanding[1], false)
                    freestanding_active = false

                    local side = false
                    local fake_flick_mode_g = get(menu.fake_flick_mode)

                    if fake_flick_mode_g == "Automatic" then
                        side = variables.freestanding
                    elseif fake_flick_mode_g == "Movement" then
                        side = not damage_fn.movement
                    elseif fake_flick_mode_g == "Inverter" then
                        side = get(menu.fake_flick_invert)
                    end

                    local delay_g = get(menu.fake_flick_delay)
                    local flick_angle = side and 85 or -85

                    if self.fake_flick_timer <= (globals_realtime() + math_fn.TICKS_TO_TIME(1)) then
                        set(ref.limit, 1)
                    end

                    if self.fake_flick_timer < globals_realtime() and cmd.chokedcommands ~= 0 then
                        local var_g = get(menu.fake_flick_variance)
                        set(ref.limit, 1)

                        if delay_g == 4 then
                            local player_resource = entity.get_player_resource()
                            local threat = client.current_threat()
                            if player_resource and threat then
                                delay_g = math_fn.TIME_TO_TICKS(0.25 + (entity_get_prop(player_resource, "m_iPing", threat) or 0)/1000)
                            end
                        end

                        local fake_flick_pitch_g = get(menu.fake_flick_pitch)

                        if fake_flick_pitch_g == "Dynamic" then
                            local height = self:height_disadvantage()

                            if height then
                                fake_flick_pitch_g = "Up"
                            else
                                fake_flick_pitch_g = "Minimal"
                            end
                        end

                        if cmd.in_use == 1 then
                            fake_flick_pitch_g = "Off"
                        end

                        pitch = fake_flick_pitch_g

                        aa.body_yaw = "Off"
                        aa.body_yaw_value = variables.freestanding and -60 or 60
                        aa.fake_yaw = 60
                        aa.yaw_value = flick_angle

                        local calc_variance = math_floor(((math.random(0, var_g*1.5) / 100) * delay_g) + 0.5)
                        self.fake_flick_delay = math_fn.TICKS_TO_TIME(delay_g + calc_variance)
                        self.fake_flick_timer = globals_realtime() + math_fn.TICKS_TO_TIME(delay_g + calc_variance)
                        self.fake_flick_cleared = false
                        self.last_fake_flick_time = globals_realtime()
                    end
                else
                    self.fake_flick_delay = math_fn.TICKS_TO_TIME(get(menu.fake_flick_init_delay))
                    self.fake_flick_timer = globals_realtime() + math_fn.TICKS_TO_TIME(get(menu.fake_flick_init_delay))
                end
            end

            self.fake_flick_cycle = (self.fake_flick_timer - globals_realtime()) / self.fake_flick_delay
        end

        if not (get(menu.quick_peek) and get(menu.quick_peek_key)) then
            local freestanding_disablers_g = get(menu.freestanding_disablers)

            --Could do this with a big or statement but fuck that
            if (ui_fn.includes(freestanding_disablers_g, "Stand") and self.movestate == "stand") or (ui_fn.includes(freestanding_disablers_g, "Slow motion") and self.movestate == "slow") or (ui_fn.includes(freestanding_disablers_g, "Moving") and self.movestate == "move") or (ui_fn.includes(freestanding_disablers_g, "Jump") and self.movestate == "air") or (ui_fn.includes(freestanding_disablers_g, "Crouch") and entity_get_prop(lp, "m_flDuckAmount") > 0.0 and self.movestate ~= "air") then
                set(ref.freestanding[1], false)
                set(ref.edge_yaw, false)
            end
        end

        if get(menu.roll_enable) then
            local wish_roll = 0
            local roll_mode_g = get(menu.roll_mode)

            local active = ((roll_mode_g == "Lean" and get(menu.roll_lean_key)) or (roll_mode_g == "Jitter" and get(menu.roll_jitter_key) or (roll_mode_g == "Dynamic" and get(menu.roll_dynamic_mode))) or aa.roll ~= nil or self.fake_flick_cleared == false) and not anti_backstab_active

            if active then
                local roll_disablers_g = get(menu.roll_disablers)
                local disabled = false

                if not get(menu.roll_override_key) then
                    for i = 1, #roll_disablers_g do
                        local cur = roll_disablers_g[i]

                        if cur == "Air" and self.ground_time < 5 then
                            disabled = true
                            break
                        elseif cur == "High speed" and self.ground_time > 5 and player_fn.speed(lp) > 120 then
                            disabled = true
                            break
                        elseif cur == "Move" and self.ground_time > 5 and player_fn.speed(lp) > 3.1 then
                            disabled = true
                            break
                        elseif cur == "Not slow walking" and self.ground_time > 5 and player_fn.speed(lp) > 3.1 and not (get(ref.slow_motion[1]) and get(ref.slow_motion[2])) then
                            disabled = true
                            break
                        elseif cur == "Not vulnerable" and damage_fn.vulnerable == false then
                            disabled = true
                            break
                        end
                    end
                end

                if not disabled then
                    if self.fake_flick_cleared == false then
                        if variables.freestanding then
                            wish_roll = -50
                        else
                            wish_roll = 50
                        end
                    else
                        if roll_mode_g == "Lean" and get(menu.roll_lean_key) then
                            local side = false

                            if get(menu.roll_side) == "Automatic" then
                                side = variables.freestanding
                            else
                                side = get(menu.roll_inverter)
                            end

                            local yaw_amount = (side and get(menu.roll_amount_left) or get(menu.roll_amount_right)) / 1.11111111111

                            if cmd.in_use == 1 then
                                pitch = "Off"
                                side = not side
                            end

                            if side then
                                aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + yaw_amount)
                                aa.body_yaw_value = 60
                                wish_roll = 50
                            else
                                aa.body_yaw_value = -60
                                aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value - yaw_amount)
                                wish_roll = -50
                            end

                            aa.yaw_jitter = "Off"
                            aa.yaw_jitter_value = 0
                            aa.fake_yaw = 60
                        elseif roll_mode_g == "Jitter" and get(menu.roll_jitter_key) then
                            aa.yaw_jitter = "Off"

                            if get(menu.roll_jitter_mode) == "Normal" then
                                wish_roll = self.jitter and 50 or -50
                                aa.yaw_value = self.jitter and 10 or -10

                                if legit_antiaim_active then
                                    aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + 180)
                                end

                                aa.body_yaw = "Static"
                                aa.body_yaw_value = self.jitter and 180 or -180
                            else
                                aa.yaw_value = self.jitter and -20 or 20
                                wish_roll = self.jitter and -50 or 50

                                if legit_antiaim_active then
                                    aa.yaw_value = math_fn.normalize_yaw(aa.yaw_value + 180)
                                end

                                aa.body_yaw = "Static"
                                aa.body_yaw_value = self.jitter and 180 or -180
                            end
                            aa.fake_yaw = 60
                        elseif roll_mode_g == "Dynamic" and get(menu.roll_dynamic_key) then
                            local side = aa.body_yaw_value > 0

                            if get(menu.roll_dynamic_mode) == "Inverted" then
                                side = not side
                            end

                            wish_roll = side and 50 or -50
                        elseif aa.roll ~= nil and type(aa.roll) == "number" then
                            wish_roll = aa.roll
                        end
                    end
                end
            end

            local skeet_roll_active = player_fn.speed(lp) < 3.1 or (get(ref.slow_motion[1]) and get(ref.slow_motion[2]) and get(ref.slow_motion_type) == "Favor anti-aim")

            if skeet_roll_active then
                set(ref.roll, wish_roll)
            else
                cmd.roll = wish_roll
            end
        else
            set(ref.roll, 0)
        end

        local total_enemies = #entity_get_players(true)

        if aa.legit_anti_aim == false and self:should_run_antiaim(cmd) then
            set(ref.pitch, pitch)
            set(ref.yaw_base, at_targets and "At targets" or "Local view")
            set(ref.yaw[1], aa.yaw_static and "Static" or "180")
            set(ref.yaw[2], aa.yaw_value)
            set(ref.yaw_jitter[1], aa.yaw_jitter)
            set(ref.yaw_jitter[2], aa.yaw_jitter_value)
            set(ref.body_yaw[1], aa.body_yaw)
            set(ref.body_yaw[2], aa.body_yaw_value)
            set(ref.freestanding_body_yaw, false)
   --         set(ref.fake_yaw_limit, aa.fake_yaw)

            if legit_antiaim_active then
                cmd.in_use = 0
            end
        end

        set(ref.doubletap[1], true)

        --dt breaks nades
        if get(menu.disable_dt_on_nade) then
            local weapon = entity_get_player_weapon(lp)

            if weapon then
                local classname = entity.get_classname(weapon)

                if classname then
                    if string.match(classname, "Grenade") or string.match(classname, "bang") then
                        set(ref.doubletap[1], false)
                    end
                end
            end
        end

        if get(menu.quick_fall) and get(menu.quick_fall_key) and get(menu.quick_fall_prediction) then
            local fall_velocity = entity_get_prop(lp, "m_flFallVelocity")
            local air = bit.band(entity_get_prop(lp, "m_fFlags") or 0, 1) == 0

            if air and cmd.in_jump == 0 and get(ref.doubletap[1]) then
                local origin = {entity_get_origin(lp)}

                if origin[1] ~= nil then
                    local pred_origin = math_fn.extrapolate_player_position(lp, origin, get(menu.quick_fall_prediction))

                    if pred_origin[1] ~= nil then
                        local trace = {client_trace_line(lp, origin[1], origin[2], origin[3], pred_origin[1], pred_origin[2], pred_origin[3])}

                        if trace[1] ~= 1 then
                            set(ref.doubletap[1], false)
                        end
                    end
                end
            end
        end

        if aa.dt or disable_dt then
            set(ref.doubletap[1], false)
        end

        if self.fake_flick_cleared == false and not get(ref.fakeduck) then
            set(ref.limit, 1)
        end
    end,

    pre_render = function(self)
        if get(menu.enable) == false or get(menu.leg_breaker) == false then
            return
        end

        if lp == nil or entity_is_alive(lp) == false then
            return
        end

        set(ref.leg_movement, "Always slide")

        local new_leg = self.last_leg + 0.5
        if new_leg > 1 then
            new_leg = new_leg - 1
        end
        new_leg = new_leg * 1.2
        entity_set_prop(lp, "m_flPoseParameter", new_leg, 0)
    end,
}
create_callback("net_update_start", function() antiaim:net_update_start() end)
create_callback("weapon_fire", function(e) antiaim:weapon_fire(e) end)
create_callback("player_hurt", function(e) antiaim:player_hurt(e) end)
create_callback("aim_fire", function(e) antiaim:aim_fire(e) end)
create_callback("setup_command", function(cmd) antiaim:run(cmd) end)
create_callback("pre_render", function() antiaim:pre_render() end)
create_callback("net_update_end", function() antiaim:net_update_end() end)

create_callback("bullet_impact", function(e)
    local index = client.userid_to_entindex(e.userid)

    if index == lp or lp == nil or entity.is_enemy(index) == false or entity_is_dormant(index) or get(menu.enable) == false then
        return
    end

    --cope solution to run for fatal shot
    local alive_delta = math_abs(antiaim.last_alive - globals_realtime())

    if alive_delta > math_fn.TICKS_TO_TIME(16) then
        return
    end

    --because event is delayed by x ticks, we must store values as they can change within 5 or so ticks which causes inaccurate data
    local lp_eye_position = {client.eye_position()}
    local target_eye_position = player_fn.eye_position(index)
    local origin = {entity.get_origin(lp)}

    if lp_eye_position[1] == nil or target_eye_position[1] == nil or origin[1] == nil then
        return
    end

    local bot = false
    local flags = entity_get_prop(index, "m_fFlags")

    if flags then
        bot = bit.band(flags, 0x200) == 0x200
    end

    local tickcount = globals_tickcount()
    local curtime = globals_realtime()
    local height = antiaim:height_disadvantage()
    local bp = antiaim.antiaim_break_point
    local side = networked_side
    local exquisite = antiaim.exquisite
    local copy_of_backtrack = antiaim.backtrack
    local is_fake_flick = math_abs(antiaim.last_fake_flick_time - curtime) < 0.1

    --Log hitbox positions
    local cache = {
        yaw_jitter = get(ref.yaw_jitter[1]),
        yaw_jitter_value = get(ref.yaw_jitter[2]),
        body_yaw = get(ref.body_yaw[1]),
        body_yaw_value = get(ref.body_yaw[2]),
        fake_yaw = get(ref.fake_yaw_limit)
    }

    local data = player_fn.players[index]

    if tickcount < data.last_shot_time then
        return
    end

    --delay call, gives time for the player_hurt event to register
    client.delay_call(math_fn.TICKS_TO_TIME(5), function()
        antiaim:bullet_impact(e, tickcount, lp_eye_position, origin, target_eye_position, curtime, height, side, antiaim.movestate, copy_of_backtrack, exquisite, is_fake_flick, bot, bp, cache)
    end)

    data.last_shot_time = tickcount + 1
end)
antiaim:init()


local data_management = {
    player_connect_full = function(e)
        local index = client.userid_to_entindex(e.userid)

        if index == lp then
            antiaim.last_registered_shot_time = 0
            antiaim.last_shot_time = 0
            antiaim.last_fake_flick_time = 0
            antiaim.grenade_release_timer = 0

            for i = 1, #player_fn.players do
                player_fn.players[i].last_shot_time = 0
                player_fn.players[i].headshots = 0
            end
        else
            player_fn.players[index].last_shot_time = 0
            player_fn.players[index].headshots = 0
        end

    end,

    reset = function()
        if (lp == nil or entity_is_alive(lp) == false) then
            antiaim.last_registered_shot_time = 0
            antiaim.last_shot_time = 0
            antiaim.last_fake_flick_time = 0
            antiaim.grenade_release_timer = 0

            for i = 1, #player_fn.players do
                player_fn.players[i].last_shot_time = 0
            end
        end
    end,

    shutdown = function(e)
        ui_fn.set_visible(true,
            ref.aa_enable,
            ref.pitch,
            ref.yaw_base,
            ref.yaw[1],
            ref.yaw[2],
            ref.yaw_jitter[1],
            ref.yaw_jitter[2],
            ref.body_yaw[1],
            ref.body_yaw[2],
            ref.freestanding_body_yaw,
            ref.fake_yaw_limit,
            ref.edge_yaw,
            ref.freestanding[1],
            ref.freestanding[2],
            ref.limit
        )
    end
}
create_callback("player_connect_full", data_management.player_connect_full)
create_callback("shutdown", data_management.shutdown)
create_callback("paint_ui", data_management.reset)

--Init. callbacks
for i = 1, #callbacks do
    local callback = callbacks[i]
    client.set_event_callback(callback.e, callback.f)
end


local ffi = require("ffi")
local antiaim_funcs = require("gamesense/antiaim_funcs")

--local username = "admin"

local globals_tickcount, globals_realtime, ui_set_visible, math_min, math_max, renderer_line, client_trace_line, math_sqrt, math_floor, entity_get_prop, entity_get_origin, globals_tickinterval, globals_curtime, entity_hitbox_position, entity_set_prop, client_trace_bullet = globals.tickcount, globals.realtime, ui.set_visible, math.min, math.max, renderer.line, client.trace_line, math.sqrt, math.floor, entity.get_prop, entity.get_origin, globals.tickinterval, globals.curtime, entity.hitbox_position, entity.set_prop, client.trace_bullet
local entity_is_alive, ui_mouse_position, entity_get_local_player, math_deg, math_atan2, math_rad, math_sin, math_cos, math_acos, entity_get_players, client_camera_angles, client_eye_position, entity_is_enemy, entity_is_dormant = entity.is_alive, ui.mouse_position, entity.get_local_player, math.deg, math.atan2, math.rad, math.sin, math.cos, math.acos, entity.get_players, client.camera_angles, client.eye_position, entity.is_enemy, entity.is_dormant
local math_abs, client_latency, ui_reference, entity_get_player_weapon, globals_frametime = math.abs, client.latency, ui.reference, entity.get_player_weapon, globals.frametime
local get, set = ui.get, ui.set
local renderer_world_to_screen = renderer.world_to_screen

--store local player (obviously update it in callbacks)
local lp = entity_get_local_player()

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}


local ui_new_checkbox = function(tab, parent, name, exploit, required_build)
    return ui.new_checkbox(tab, parent, name)
end


local ui_fn = {
    includes = function(table, key)
        for i = 1, #table do
            if table[i] == key then
                return true, i
            end
        end

        return false, nil
    end,

    set_visible = function(state, ...)
        local args = {...}

        for i = 1, #args do
            ui_set_visible(args[i], state)
        end
    end,

    mouse_within = function(x, y, w, h)
        local mouse = {ui_mouse_position()}
        return mouse[1] > x and mouse[1] < x + w and mouse[2] > y and mouse[2] < y + h
    end
}


local debug_fn = {
    draw_line = function(start_pos, end_pos, color)
        local start_w2s = {renderer_world_to_screen(start_pos[1], start_pos[2], start_pos[3])}
        local end_w2s = {renderer_world_to_screen(end_pos[1], end_pos[2], end_pos[3])}

        if start_w2s[1] and end_w2s[1] then
            renderer_line(start_w2s[1], start_w2s[2], end_w2s[1], end_w2s[2], color[1], color[2], color[3], color[4])
        end
    end,


    lines = {},
    skeletons = {},

    create_line = function(self, start_pos, end_pos, color, time, fade_in)
        table.insert(self.lines, {
            start_pos = start_pos,
            end_pos = end_pos,
            color = color,
            alpha = fade_in and 0 or 255,
            time = globals_realtime() + time
        })
    end,

    create_exquisite = function(player)
        local hitboxes = {}

        for i = 0, 18 do
            hitboxes[i + 1] = {entity_hitbox_position(player, i)}
        end

        return hitboxes
    end,

    create_skeleton = function(self, exquisite, color, time, fade_in)
        table.insert(self.skeletons, {
            exquisite = exquisite,
            color = color,
            alpha = fade_in and 0 or 255,
            time = globals_realtime() + time
        })
    end,

    run = function(self)
        local inc_rate = (255 / 0.1) * globals.frametime()
        local dec_rate = (255 / 0.2) * globals.frametime()

        for i = #self.lines, 1, -1 do
            local line = self.lines[i]
            if line.time < globals_realtime() then
                line.alpha = math_max(0, line.alpha - dec_rate)

                if line.alpha == 0 then
                    table.remove(self.lines, i)
                end
            else
                line.alpha = math_min(line.color[4], line.alpha + inc_rate)
            end

            self.draw_line(line.start_pos, line.end_pos, {line.color[1], line.color[2], line.color[3], line.alpha})
        end

        for i = #self.skeletons, 1, -1 do
            local skeleton = self.skeletons[i]

            if skeleton.time < globals_realtime() then
                skeleton.alpha = math_max(0, skeleton.alpha - dec_rate)

                if skeleton.alpha == 0 then
                    table.remove(self.skeletons, i)
                end
            else
                skeleton.alpha = math_min(skeleton.color[4], skeleton.alpha + inc_rate)
            end

            self.draw_skeleton(skeleton.exquisite, {skeleton.color[1], skeleton.color[2], skeleton.color[3], skeleton.alpha})
        end
    end,
}

local handle_menu = {
    paint_ui = function()
        local state = get(menu.enable)
        ui_fn.set_visible(not state, ref.aa_enable, ref.pitch, ref.yaw_base, ref.yaw[1], ref.yaw[2], ref.yaw_jitter[1], ref.yaw_jitter[2], ref.body_yaw[1], ref.body_yaw[2], ref.roll, ref.freestanding_body_yaw, ref.fake_yaw_limit, ref.edge_yaw, ref.freestanding[1], ref.freestanding[2], ref.limit)

        local vis = state and get(menu.finder) == "Visuals"

        ui_fn.set_visible(state, menu.finder)

        ui_fn.set_visible(vis, menu.vis_options)
        ui_fn.set_visible(vis and ui_fn.includes(get(menu.vis_options), "User Info"), menu.userinfox_offset , menu.userinfoy_offset)
        ui_fn.set_visible(vis and ui_fn.includes(get(menu.vis_options), "Weapon Info"), menu.weaponinfox_offset , menu.weaponinfoy_offset)
        ui_fn.set_visible(vis and ui_fn.includes(get(menu.vis_options), "Crosshair"), menu.crosshair_opt)
        ui_fn.set_visible(vis, menu.vis_bad)


        ui_fn.set_visible(vis and #get(menu.vis_options) ~= 0,
            menu.lable_1,
            menu.lable_2,
            menu.color_1,
            menu.color_2
        )
    end,

    shutdown = function()
        ui_fn.set_visible(true,
            ref.aa_enable,
            ref.pitch,
            ref.yaw_base,
            ref.yaw[1],
            ref.yaw[2],
            ref.yaw_jitter[1],
            ref.yaw_jitter[2],
            ref.body_yaw[1],
            ref.body_yaw[2],
            ref.roll,
            ref.freestanding_body_yaw,
            ref.edge_yaw,
            ref.freestanding[1],
            ref.freestanding[2],
            ref.limit
        )
        set(ref.yaw_jitter[1], "Off")
        set(ref.yaw_jitter[2], 0)
        set(ref.body_yaw[1], "Opposite")
        set(ref.body_yaw[2], 0)
        --set(ref.fake_yaw_limit, 60)
    end,
}

local render_fn = {
    --gradient line.
    line = function(pos, end_pos, thickness, color, end_color, precision)
        pos[3] = 0
        end_pos[3] = 0

        local cxy = math_fn.lerp(pos, end_pos, 0.1)
        local max_distance = math_fn.distance2d(pos, cxy) * 15

        local angle = math_fn.calc_angle(pos, end_pos)
        local max = precision

        for i = 1, max do
            local c1 = math_fn.lerp(pos, end_pos, (i - 2) / max)
            local c2 = math_fn.lerp(pos, end_pos, i / max)
            local col = math_fn.lerp(color, end_color, (i - 2) / max)


            local distance = 1 - math_fn.clamp(0, 1, 1.2 * (math_fn.distance2d(c1, cxy) / max_distance))
            col[4] = col[4] * distance

            local xy1 = math_fn.angle_vector({0, math_fn.normalize_yaw(angle[2] + 35), 0})

            local xa = xy1[1] * (thickness / 2)
            local ya = xy1[2] * (thickness / 2)
            local xa2 = xy1[1] * (thickness / 4)
            local ya2 = xy1[2] * (thickness / 4)
            local p1 = {c1[1] + xa, c1[2] + ya, c1[3]}
            local p1_5 = {c1[1] + xa2, c1[2] + ya2, c1[3]}
            local p2 = {c1[1] - xa, c1[2] - ya, c1[3]}
            local p2_5 = {c1[1] - xa2, c1[2] - ya2, c1[3]}
            local p3 = {c2[1] + xa, c2[2] + ya, c2[3]}
            local p3_5 = {c2[1] + xa2, c2[2] + ya2, c2[3]}
            local p4 = {c2[1] - xa, c2[2] - ya, c2[3]}
            local p4_5 = {c2[1] - xa2, c2[2] - ya2, c2[3]}

            --outer stripe
            renderer.triangle(p1[1], p1[2], p3[1], p3[2], p1_5[1], p1_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)
            renderer.triangle(p1_5[1], p1_5[2], p3[1], p3[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)

            --middle
            renderer.triangle(p1_5[1], p1_5[2], p2_5[1], p2_5[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * distance)
            renderer.triangle(p2_5[1], p2_5[2], p3_5[1], p3_5[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * distance)

            --outer stripe
            renderer.triangle(p2[1], p2[2], p4[1], p4[2], p2_5[1], p2_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)
            renderer.triangle(p2_5[1], p2_5[2], p4[1], p4[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * 0.5 * distance)
        end

        --renderer.line("AA", "Anti-aimbot angles",end_pos[1], end_pos[2], 255, 255, 255, color[4])
    end,

    --world gradient line (bo$$)
    world_line = function(pos, yaw, distance, thickness, color, end_color)
        local end_pos = {pos[1] + math.cos(math.rad(yaw)) * distance, pos[2] + math.sin(math.rad(yaw)) * distance, pos[3]}

        local angle = math_fn.calc_angle(pos, end_pos)
        local max = 12

        local cxy = math_fn.lerp(pos, end_pos, 0.5)
        local max_distance = math_fn.distance2d(pos, cxy) * 1.25

        for i = 1, max do
            local c1 = math_fn.lerp(pos, end_pos, (i - 1) / max)
            local c2 = math_fn.lerp(pos, end_pos, i / max)
            local col = math_fn.lerp(color, end_color, (i - 1) / max)

            local xy1 = {
                math.cos(math.rad(math_fn.normalize_yaw(yaw + 90))),
                math.sin(math.rad(math_fn.normalize_yaw(yaw + 90))),
            }

            local distance = 1 - math_fn.clamp(0, 1, 1.2 * (math_fn.distance2d(c1, cxy) / max_distance))
            col[4] = col[4] * distance

            local xa = xy1[1] * (thickness / 2)
            local ya = xy1[2] * (thickness / 2)
            local xa2 = xy1[1] * (thickness / 4)
            local ya2 = xy1[2] * (thickness / 4)
            local p1 = {c1[1] + xa, c1[2] + ya, c1[3]}
            local p1_5 = {c1[1] + xa2, c1[2] + ya2, c1[3]}
            local p2 = {c1[1] - xa, c1[2] - ya, c1[3]}
            local p2_5 = {c1[1] - xa2, c1[2] - ya2, c1[3]}
            local p3 = {c2[1] + xa, c2[2] + ya, c2[3]}
            local p3_5 = {c2[1] + xa2, c2[2] + ya2, c2[3]}
            local p4 = {c2[1] - xa, c2[2] - ya, c2[3]}
            local p4_5 = {c2[1] - xa2, c2[2] - ya2, c2[3]}

            p1 = {renderer_world_to_screen(p1[1], p1[2], p1[3])}
            p1_5 = {renderer_world_to_screen(p1_5[1], p1_5[2], p1_5[3])}
            p2 = {renderer_world_to_screen(p2[1], p2[2], p2[3])}
            p2_5 = {renderer_world_to_screen(p2_5[1], p2_5[2], p2_5[3])}
            p3 = {renderer_world_to_screen(p3[1], p3[2], p3[3])}
            p3_5 = {renderer_world_to_screen(p3_5[1], p3_5[2], p3_5[3])}
            p4 = {renderer_world_to_screen(p4[1], p4[2], p4[3])}
            p4_5 = {renderer_world_to_screen(p4_5[1], p4_5[2], p4_5[3])}

            if p1[1] and p2[1] and p3[1] and p4[1] and p1_5[1] and p2_5[1] and p3_5[1] and p4_5[1] then
                --outer stripe
                renderer.triangle(p1[1], p1[2], p3[1], p3[2], p1_5[1], p1_5[2], col[1], col[2], col[3], col[4] * 0.5)
                renderer.triangle(p1_5[1], p1_5[2], p3[1], p3[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4] * 0.5)

                --middle
                renderer.triangle(p1_5[1], p1_5[2], p2_5[1], p2_5[2], p3_5[1], p3_5[2], col[1], col[2], col[3], col[4])
                renderer.triangle(p2_5[1], p2_5[2], p3_5[1], p3_5[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4])

                --outer stripe
                renderer.triangle(p2[1], p2[2], p4[1], p4[2], p2_5[1], p2_5[2], col[1], col[2], col[3], col[4] * 0.5)
                renderer.triangle(p2_5[1], p2_5[2], p4[1], p4[2], p4_5[1], p4_5[2], col[1], col[2], col[3], col[4] * 0.5)
            end
        end

        return end_pos
    end,

    rounded_gradient_rectangle = function(x, y, w, h, r, color1, color2, color3, color4, background, max_alpha, padding, thickness, percent)
        x = math_floor(x)
        y = math_floor(y)
        w = math_floor(w)
        h = math_floor(h)

        color1[4] = math.min(color1[4], max_alpha)
        color2[4] = math.min(color2[4], max_alpha)
        color3[4] = math.min(color3[4], max_alpha)
        color4[4] = math.min(color4[4], max_alpha)
        background[4] = math.min(background[4], max_alpha)

        local anims = {}

        anims[1] = math.max(0, math.min(percent * 2, 1))
        anims[2] = anims[1] == 1 and math.max(0, math.min((percent - 0.5) * 2, 1)) or 0

        --Background
        renderer.rectangle(x + r, y + r, w - r * 2, h - r * 2, background[1], background[2], background[3], background[4] * anims[1])
        renderer.rectangle(x + r, y, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
        renderer.rectangle(x, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])
        renderer.rectangle(x + r, y + h - r, w - (r * 2), r, background[1], background[2], background[3], background[4] * anims[1])
        renderer.rectangle(x + w - r, y + r, r, h - (r * 2), background[1], background[2], background[3], background[4] * anims[1])

        renderer.circle(x + r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 180, 0.25)
        renderer.circle(x + w - r, y + r, background[1], background[2], background[3], background[4] * anims[1], r, 90, 0.25)
        renderer.circle(x + r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 270, 0.25)
        renderer.circle(x + w - r, y + h - r, background[1], background[2], background[3], background[4] * anims[1], r, 0, 0.25)

        --Gradient outline
        renderer.gradient(x + r, y + padding, (w - (r * 2)), thickness, color1[1], color1[2], color1[3], color1[4] * anims[2], color2[1], color2[2], color2[3], color2[4] * anims[2], true)
        renderer.gradient(x + w - padding - thickness, y + r, thickness, (h - (r * 2)), color2[1], color2[2], color2[3], color2[4] * anims[2], color3[1], color3[2], color3[3], color3[4] * anims[2], false)
        renderer.gradient(x + w - padding - r + 1, y + h - padding - thickness, -((w) - (r * 2)), thickness, color3[1], color3[2], color3[3], color3[4] * anims[2], color4[1], color4[2], color4[3], color4[4] * anims[2], true)
        renderer.gradient(x + padding, y + h - r, thickness, -(h - (r * 2)), color4[1], color4[2], color4[3], color4[4] * anims[2], color1[1], color1[2], color1[3], color1[4] * anims[2], false)

        renderer.circle_outline(x + r + padding, y + r + padding, color1[1], color1[2], color1[3], color1[4] * anims[2], r, 180, 0.25, thickness)
        renderer.circle_outline(x + w - r - padding, y + r + padding, color2[1], color2[2], color2[3], color2[4] * anims[2], r, 270, 0.25, thickness)
        renderer.circle_outline(x + r + padding, y + h - r - padding, color4[1], color4[2], color4[3], color4[4] * anims[2], r, 90, 0.25, thickness)
        renderer.circle_outline(x + w - r - padding, y + h - r - padding, color3[1], color3[2], color3[3], color3[4] * anims[2], r, 0, 0.25, thickness)
    end,

    rounded_gradient = function(x, y, w, h, c1, c2, rad)
        renderer.circle(x + rad, y + rad, c1[1], c1[2], c1[3], c1[4], rad, 180, 0.25)
        renderer.circle(x + w - rad, y + rad, c2[1], c2[2], c2[3], c2[4], rad, 90, 0.25)
        renderer.circle(x + rad, y + h - rad, c1[1], c1[2], c1[3], c1[4], rad, 270, 0.25)
        renderer.circle(x + w - rad, y + h - rad, c2[1], c2[2], c2[3], c2[4], rad, 0, 0.25)

        renderer.rectangle(x, y + rad, rad, h - (rad * 2), c1[1], c1[2], c1[3], c1[4])
        renderer.rectangle(x + w - rad, y + rad, rad, h - (rad * 2), c2[1], c2[2], c2[3], c2[4])

        renderer.gradient(x + rad, y, w - rad * 2, h, c1[1], c1[2], c1[3], c1[4], c2[1], c2[2], c2[3], c2[4], true)
    end,
}

local gui = {
    data = {},

    create = function(self, index, name)
        self.data[index] = {
            name = name,
            click_pos = {nil, nil},
            pos = {nil, nil},
            size = {nil, nil},
            elements = {},
            active = false,
            anim = 0
        }
    end,


    left_state = false,
    left_release = false,
    right_state = false,
    right_release = false,
    index_active = nil,

    measure_size = function(self, id)
        local size = {135, 30}

        for i = 1, #self.data[id].elements do
            local element = self.data[id].elements[i]

            if element.type == "combo_list" then
                size[2] = size[2] + 27
            elseif element.type == "multi_list" then
                size[2] = size[2] + 10
            end
        end

        return size
    end,

    run = function(self)
        local menu_inc = (1 / 0.4) * globals_frametime()
        local menu_dec = (1 / 0.2) * globals_frametime()
        local menu_open = ui.is_menu_open()
        local mouse = {ui_mouse_position()}

        local active_color = {get(ref.menu_color)}
        local hover_color = {255, 255, 255, 255}
        local disabled_color = {200, 200, 200, 255}

        self.left_release = false
        local left_key = client.key_state(0x01)
        if left_key ~= self.left_state then
            if left_key == false then
                self.left_release = true
            end
            self.left_state = left_key
        end

        --right key
        self.right_release = false
        local right_key = client.key_state(0x02)
        if right_key ~= self.right_state then
            if right_key == false then
                self.right_release = true
            end
            self.right_state = right_key
        end

        --find active menu and update alphas
        self.index_active = nil

        for i = 1, #self.data do
            local data = self.data[i]

            if menu_open == false then
                data.active = false
            end

            data.anim = math_fn.clamp(0, 1, data.anim + (data.active and menu_inc or -menu_dec))

            if data.active and data.pos[1] ~= nil and data.size[1] ~= nil then
                self.index_active = i
                break
            end
        end

        if self.index_active == nil then
            local index = nil
            local smallest_hover = math.huge

            for i = 1, #self.data do
                local data = self.data[i]

                if data.pos[1] ~= nil and data.size[1] ~= nil then

                    local area = data.size[1] * data.size[2]

                    if ui_fn.mouse_within(data.pos[1], data.pos[2], data.size[1], data.size[2]) and (area < smallest_hover) and self.right_release then
                        smallest_hover = area
                        index = i
                    end
                end
            end

            if index ~= nil then
                self.data[index].active = true
                self.data[index].click_pos = mouse
            end
        end

        for i = 1, #self.data do
            local data = self.data[i]
            local size = self:measure_size(i)

            if data.pos[1] ~= nil and data.size[1] ~= nil and data.anim > 0 then
                local pos = {data.click_pos[1] - size[1]/2, data.click_pos[2] - size[2]/2}

                render_fn.rounded_gradient_rectangle("AA", "Anti-aimbot angles",size[1], size[2], 5, active_color, active_color, active_color, active_color, {25, 25, 25, data.anim * 200}, data.anim * 255, 2, 2, data.anim)

                if ui_fn.mouse_within("AA", "Anti-aimbot angles",size[1], size[2]) == false and self.left_release then
                    data.active = false
                end

                local offset = 6

                local title_size = {renderer.measure_text("b", data.name)}
                renderer.text(pos[1] + size[1]/2 - title_size[1]/2, pos[2] + offset, 220, 220, 220, 255 * data.anim, "b", 0, data.name)
                offset = offset + title_size[2] + 2

                for j = 1, #data.elements do
                    local element = data.elements[j]

                    if element.type == "combo_list" then
                        local cur_element = get(element.ref)

                        local hover = ui_fn.mouse_within(pos[1], pos[2] + offset - 6, size[1], 28)
                        local col = hover and hover_color or disabled_color


                        renderer.rectangle(pos[1] + 4, pos[2] + offset, size[1] - 8, 14, 200, 200, 200, 10 * data.anim)
                        renderer.text(pos[1] + 8, pos[2] + offset, 255, 255, 255, 255 * data.anim, "", 0, element.name)
                        offset = offset + 15

                        if hover then
                            local item_pos = 0

                            for i = 1, #element.list do
                                if element.list[i] == cur_element then
                                    item_pos = i
                                    break
                                end
                            end

                            if self.left_release then
                                if item_pos + 1 > #element.list then
                                    item_pos = 1
                                else
                                    item_pos = item_pos + 1
                                end
                            elseif self.right_release then
                                if item_pos - 1 < 1 then
                                    item_pos = #element.list
                                else
                                    item_pos = item_pos - 1
                                end
                            end
                            set(element.ref, element.list[item_pos])
                        end
                        renderer.text(pos[1] + 8, pos[2] + offset, col[1], col[2], col[3], 255 * data.anim, "b", 0, cur_element)
                        offset = offset + 14
                    end
                end
            end
        end
    end,

    setup_command = function(self, cmd)
        if self.index_active == nil then
            return
        end

        cmd.in_attack = 0
        cmd.in_attack2 = 0
    end,
}


local antiaim = {
    break_lc_active = false,


    sent_since_shot = false,
    ground_time = 0,
    last_origin = {0,0,0},
    lag_comp_percent = 0,
    last_choke = 0,
    fake_lag_limit = 0,


    events = {
        doubletap = false,
        break_lagcomp = false,
        bhop_aa = false,
        override_dt = nil,
        override_osaa = nil
    },
    break_lc_exploit = function(self, cmd)
        cmd.force_defensive = false
        self.break_lc_active = false
        entity_set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)

        if get(menu.break_lagcomp) == false or get(menu.break_lagcomp_hotkey) == false or (get(ref.doubletap[1]) and get(ref.doubletap[2])) == false then
            return
        end

        if self.ground_time > 8 then
            return
        end

        --shit works (or atleast used to work) really well
        entity_set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
        self.break_lc_active = true
        cmd.force_defensive = true
    end,
    run = function(self, cmd)

       self:break_lc_exploit(cmd)
    end,
}

ffi.cdef('typedef struct { float x; float y; float z; } bbvec3_t;')

local visuals = {
    --lowkey hella pasted
    pClientEntityList = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("invalid interface", 2),
    fnGetClientEntity = vtable_thunk(3, "void*(__thiscall*)(void*, int)"),

    fnGetAttachment = vtable_thunk(84, "bool(__thiscall*)(void*, int, bbvec3_t&)"),
    fnGetMuzzleAttachmentIndex1stPerson = vtable_thunk(468, "int(__thiscall*)(void*, void*)"),
    fnGetMuzzleAttachmentIndex3stPerson = vtable_thunk(469, "int(__thiscall*)(void*)"),

    get_attachment_vector = function(self, world_model)
        local wpn = entity.get_player_weapon(lp)

        if lp == nil or wpn == nil then
            return
        end

        local model = world_model and entity.get_prop(wpn, 'm_hWeaponWorldModel') or entity.get_prop(lp, 'm_hViewModel[0]')

        local active_weapon = self.fnGetClientEntity(self.pClientEntityList, wpn)
        local g_model = self.fnGetClientEntity(self.pClientEntityList, model)

        if active_weapon == nil or g_model == nil then
            return
        end

        local attachment_vector = ffi.new("bbvec3_t[1]")
        local att_index = world_model and
            self.fnGetMuzzleAttachmentIndex3stPerson(active_weapon) or
            self.fnGetMuzzleAttachmentIndex1stPerson(active_weapon, g_model)

        if att_index > 0 and self.fnGetAttachment(g_model, att_index, attachment_vector[0]) then
            local pos = { attachment_vector[0].x, attachment_vector[0].y, attachment_vector[0].z }

            return {renderer_world_to_screen(pos[1],pos[2],pos[3])}
        end
    end,




    color_1 = {},
    color_2 = {},
    crosshair_data = {},
    crosshair_text_data = {},

    antiaim_animation = 0,
    userinfo_animation = 0,
    weaponinfo_animation = 0,


    master_alpha = 0,
    doubletap_animation = 0,
    background_animation = 1,

    attached_to_gun = false,
    cur_position = {0,0},
    cur_end_position = center,




    update_crosshair = function(self, id, name, state, percent, col)
        local index = nil

        for i = 1, #self.crosshair_data do
            if self.crosshair_data[i].id == id then
                index = i
            end
        end

        if index == nil then
            self.crosshair_data[#self.crosshair_data + 1] = {
                id = id,
                state = state,
                name = name,
                percent = percent,
                col = col,
                col2 = col2,
                anim = 0,
                anim2 = 0
            }
        else
            self.crosshair_data[index] = {
                id = id,
                state = state,
                name = name,
                percent = percent,
                col = col,
                col2 = col2,
                anim = math_fn.clamp(0, 1, self.crosshair_data[index].anim + (state and (1 / 0.3) or -(1 / 0.3)) * globals_frametime()),
                anim2 = math_fn.clamp(0, 1, self.crosshair_data[index].anim2 + ((self.crosshair_data[index].anim == 0 and -(1 / 0.3) or (1 / 0.2)) * globals_frametime()))
            }
        end
    end,

    update_text = function(self, id, text, state)
        local index = nil

        for i = 1, #self.crosshair_text_data do
            if self.crosshair_text_data[i].id == id then
                index = i
            end
        end

        if index == nil then
            self.crosshair_text_data[#self.crosshair_text_data + 1] = {
                id = id,
                text = text,
                state = state,
                pad_anim = 0,
                text_alpha = 0,
            }
        else
            local old = self.crosshair_text_data[index]

            self.crosshair_text_data[index] = {
                id = id,
                text = text,
                state = state,
                pad_anim = old.text_alpha == 0 and math_fn.clamp(0, 1, old.pad_anim + (state and (1 / 0.2) or -(1 / 0.2)) * globals_frametime()) or old.pad_anim,
                text_alpha = old.pad_anim == 1 and math_fn.clamp(0, 1, old.text_alpha + (state and (1 / 0.2) or -(1 / 0.2)) * globals_frametime()) or old.text_alpha,
            }
        end
    end,

    update_attachment_position = function(self)
        local pos = self:get_attachment_vector()
        local thirdperson = get(ref.thirdperson[1]) and get(ref.thirdperson[2])

        if (pos == nil or pos[1] == nil) or thirdperson or entity_get_prop(lp, "m_bIsScoped") == 1 and ui_fn.includes(get(menu.crosshair_opt), "Weapon") == false then
            self.attached_to_gun = false
          elseif ui_fn.includes(get(menu.crosshair_opt), "Weapon") == true and entity_get_prop(lp, "m_bIsScoped") == 0 then
            self.attached_to_gun = true
          else
            self.attached_to_gun = false
          end
          if ui_fn.includes(get(menu.crosshair_opt), "Weapon") == true and entity_get_prop(lp, "m_bIsScoped") == 1 then
            self.attached_to_gun = false
        end

        if pos ~= nil and pos[1] ~= nil then
            self.cur_position = pos
        end

        local wish_end = {0, 0}

        if self.attached_to_gun == false then
            wish_end = {center[1] + 5, center[2] + 5}
        else
            local yaw = math_rad(-125)
            local end_offset = {math_floor(math.sin(yaw) * 275), math_floor(math.cos(yaw) * 175)}

            --Avoid overlapping with crosshair
            local new_wish_end = {pos[1] + end_offset[1], pos[2] + end_offset[2]}
            local distance_to_center = math_fn.distance2d(center, new_wish_end)
            local max_distance = 150
            local percent = distance_to_center / max_distance
            local lerped_distance = math_fn.lerp(pos, new_wish_end, math_fn.clamp(0.6, 1, percent))

            wish_end = lerped_distance --{pos[1] + end_offset[1], pos[2] + end_offset[2]}
        end

        for i = 1, 2 do
            local inc = ((wish_end[i] - self.cur_end_position[i]) / 0.3) * globals.frametime()
            self.cur_end_position[i] = self.cur_end_position[i] + inc
        end
    end,

    update_animations = function(self, state)
        local inc = (1 / 0.1) * globals_frametime()
        local alpha = (1 / 0.1) * globals_frametime()

        if self.attached_to_gun == false then
            inc = inc * -1
        end

        if state == false then
            alpha = alpha * -1
        end

        if antiaim_funcs.get_tickbase_shifting() > 0 then
            self.doubletap_animation = math_fn.clamp(0.1, 1, self.doubletap_animation + ((0.5 / 0.2) * globals_frametime()))
        else
            self.doubletap_animation = math_fn.clamp(0.1, 1, self.doubletap_animation - ((0.5 / 0.1) * globals_frametime()))
        end

        self.master_alpha = math_fn.clamp(0, 1, self.master_alpha + alpha)
        self.background_animation = math_fn.clamp(0, self.master_alpha, math_fn.clamp(0, 1, self.background_animation + inc))
    end,

    indicator_contents = function(self, render)
        local offset = 2
        local longest_text = 0
        local size = {90 + (10 * self.background_animation), 20}
        local average_color = math_fn.lerp(self.color_1, self.color_2, 0.5)

        for i = 1, #self.crosshair_data do
            local crosshair = self.crosshair_data[i]
            if crosshair.anim2 > 0 then
                local text_size = {renderer.measure_text("-", crosshair.name)}

                if text_size[1] > longest_text then
                    longest_text = text_size[1]
                end

                size[2] = size[2] + (10 * crosshair.anim2)
            end
        end

        for i = 1, #self.crosshair_text_data do
            local text = self.crosshair_text_data[i]

            if text.pad_anim > 0 then
                size[2] = size[2] + (10 * text.pad_anim)
            end
        end
        size[2] = size[2] + 10

        --title text
        local text_size = {renderer.measure_text("", "Exquisite")}
        local title_offset = math_floor(math_fn.lerp({5}, {size[1]/2 - text_size[1]/2}, self.background_animation)[1])
        renderer.text(self.cur_end_position[1] + title_offset + 35, self.cur_end_position[2] + offset + 7.5, 220, 220, 220, 255 * (1 - self.background_animation) * self.master_alpha, "-c", 0, "EXQUISITE")
        renderer.text(self.cur_end_position[1] + title_offset + 19 , self.cur_end_position[2] + offset + 7.5, 220, 220, 220, 255 * self.background_animation, "-c", 0, "EXQUISITE")
        offset = offset + text_size[2] + 2

        --sliders

        --draw sliders
        local padding = 4 * self.background_animation

        for i = 1, #self.crosshair_data do
            local crosshair = self.crosshair_data[i]
            local bar_size = size[1] - (4*2) - longest_text * 2 - 8

            if crosshair.anim2 > 0 then
                local alpha = self.master_alpha * crosshair.anim * 255
                local col = average_color
                col[4] = alpha

                renderer.text(self.cur_end_position[1] + 4 + padding, self.cur_end_position[2] + offset, 220, 220, 220, alpha, "-", 0, crosshair.name)
                --bars
                render_fn.gradient(self.cur_end_position[1] + (4*2) + padding + 2 + longest_text, self.cur_end_position[2] + offset + text_size[2]/4, bar_size * crosshair.anim, 4, {25, 25, 25, alpha}, {25, 25, 25, alpha}, 2)
                render_fn.gradient(self.cur_end_position[1] + (4*2) + padding + 2 + longest_text, self.cur_end_position[2] + offset + text_size[2]/4, math_floor(bar_size * crosshair.anim * crosshair.percent + 0.5), 4, col, col, 2)
                offset = offset + (10 * crosshair.anim2)
            end
        end

        offset = offset + 1

        --draw list indicators
        local indicators = {}

        local function create(name, col)
            indicators[#indicators + 1] = {
                name = name,
                color = col,
                size = {renderer.measure_text("-", name)}
            }
        end


        local white = {235, 235, 235, 255}
        local disabled_color = {180, 180, 180, 255}

        if antiaim_funcs.get_tickbase_shifting() > 0 then
          DTCOLOR = {0,255,0,255}
        else
          DTCOLOR = {255,0,0,255}
        end
        create("OS", (get(ref.onshot[1]) and get(ref.onshot[2])) and white or disabled_color)
        create("FD", get(ref.fakeduck) and white or disabled_color)
        --create("FS", (#get(ref.freestanding[1]) ~= 0 and get(ref.freestanding[2])) and white or disabled_color)
        create("BM", get(ref.force_baim) and white or disabled_color)


        local x_offset = 4 + padding
        local ind_offset = (size[1] / #indicators) - 4 - (1 * (1 - self.background_animation))

        for i = 1, #indicators do
            local indicator = indicators[i]

            renderer.text(self.cur_end_position[1] + x_offset,  self.cur_end_position[2] + offset, indicator.color[1], indicator.color[2], indicator.color[3], self.master_alpha * 255, "-", 0, indicator.name)
            x_offset = math_floor(x_offset + ind_offset + indicator.size[1] / #indicators)
        end

        offset = offset + 10
        self:update_text("legit",
            {
                {"LEGIT AA", "-", average_color},
                {self.doubletap_animation == 1 and "" or "", "-", self.doubletap_animation == 1 and average_color or {255, 150, 150, 255}},
        }, get(menu.legit_antiaim_on_key))
        self:update_text("doubletap",
            {
                {"DOUBLE TAP:  ", "-", disabled_color},
                {self.doubletap_animation == 1 and "+" or "-", "-", self.doubletap_animation == 1 and average_color or {255, 150, 150, 255}},
        }, get(ref.doubletap[1]) and get(ref.doubletap[2]))

        self:update_text("quick",
            {
                {"IDEAL TICK:  ", "-", disabled_color},
                {self.doubletap_animation == 1 and "CHARGED" or "CHARGING", "-", self.doubletap_animation == 1 and average_color or {255, 150, 150, 255}},
        }, get(menu.quick_peek) and get(menu.quick_peek_key))
        self:update_text("AIR",
            {
                {"AIR:  ", "-", disabled_color},
                {antiaim.break_lc_active and "HOOD BY AIR" or "", "-", average_color},
                {antiaim.break_lc_active and "" or "HOOD BY AIR", "-", {255, 150, 150, 255}}
        }, antiaim.break_lc_active or (antiaim.ground_time < 8 and antiaim.lag_comp_percent == 1))



        --bottom text
        for i = 1, #self.crosshair_text_data do
            local text = self.crosshair_text_data[i]

            if text.pad_anim > 0 then
                local x = self.cur_end_position[1] + 4 + padding

                for j = 1, #text.text do
                    local c = text.text[j]
                    local text_size = {renderer.measure_text(c[2], c[1])}
                    renderer.text(x, self.cur_end_position[2] + offset, c[3][1], c[3][2], c[3][3], text.text_alpha * self.master_alpha * 255, c[2], 0, c[1])
                    x = x + text_size[1]
                end
                offset = offset + (10 * text.pad_anim)
            end
        end

        if render == false then
            return size
        end
    end,

    indicator_frame = function(self)
      local pos = self:get_attachment_vector()
        local size = self:indicator_contents(false)
        if(pos == nil or pos[1] == nil) then return end
        renderer.line(pos[1]  ,pos[2]   ,self.cur_end_position[1] + size[1], self.cur_end_position[2] + size[2], 153, 204, 255, 255, 255, 255,255, 0, true)
        render_fn.rounded_gradient_rectangle(self.cur_end_position[1], self.cur_end_position[2], size[1], size[2], 4, self.color_1, self.color_2, self.color_1, self.color_2, {25, 25, 25, 165 * self.master_alpha}, self.master_alpha * 255, 1, 0.5, self.background_animation)
    end,

    crosshair = function(self)
        self:update_attachment_position()
        self:update_animations(lp ~= nil and entity_is_alive(lp) and get(menu.enable) and ui_fn.includes(get(menu.vis_options), "Crosshair"))

        if self.master_alpha <= 0 then
            return
        end

        if self.background_animation > 0 then
            self:indicator_frame()
        end

        self:indicator_contents(true)
    end,


    userinfo = function(self)
        local inc = (1 / 0.5) * globals_frametime()
        local offset = -5
        local x_offset = 10
        if (get(menu.enable) and ui_fn.includes(get(menu.vis_options), "User Info")) == false then
            inc = inc * -1
        end
        self.userinfo_animation = math_fn.clamp(0, 1, self.userinfo_animation + inc)

        if self.userinfo_animation <= 0 then
            return
        end

        local white = {220, 220, 220, 255}
        local disabled_color = {150, 150, 150, 255}
        local average_color = math_fn.lerp(self.color_1, self.color_2, 0.5)

        local size = {10, 70}

        local resource = entity.get_player_resource()

        local ping = 0

        if resource ~= nil then
            ping = entity_get_prop(resource, "m_iPing", lp)
        end
        ping = math_floor(ping)

        local text = {
          {"Welcome To Exquisite.lua", "b", average_color},
            {"", "b", average_color},
            {" ", "", white},
            {"", "b", average_color},
            {" ", "", white},
            {" ", "", white},
            {"", "", white},
            {"", "b", average_color},
            {" ", "", white},
            {"", "b", average_color},
        }
        local text321 = {
          {"Welcome To 312431.P1us", "b", average_color},
        }

        for i = 1, #text do
            local c = text[i]
            local text_size = {renderer.measure_text(c[2], c[1])}

            size[1] = size[1] + text_size[1]

            if size[2] < text_size[2] then
                size[2] = text_size[2]
            end
        end

        local x = screen[1]/2 - 790
        if ui_fn.includes(get(menu.vis_options), "User Info") == true and not ui.get(menu.vis_bad) then
        render_fn.rounded_gradient_rectangle(x_offset + ui.get(menu.userinfox_offset), offset + ui.get(menu.userinfoy_offset), size[1], size[2] , 2, self.color_1, self.color_2, self.color_1, self.color_2, {25, 25, 25, 165 * self.userinfo_animation}, self.userinfo_animation * 255, 1, 1, self.userinfo_animation)
        elseif ui.get(menu.vis_bad) then
        renderer.gradient(ui.get(menu.userinfox_offset),  ui.get(menu.userinfoy_offset), size[1], size[2] - 10 ,153, 204, 255, 255, 153, 204, 255, 0, 255, 0, true)
        end
        for i = 1, #text do
            local c = text[i]
            local text_size = {renderer.measure_text(c[2], c[1])}
            if ui_fn.includes(get(menu.vis_options), "User Info") == true and not ui.get(menu.vis_bad) then
            renderer.text(x_offset + 10 + ui.get(menu.userinfox_offset) , offset +5 + ui.get(menu.userinfoy_offset), c[3][1], c[3][2], c[3][3], self.userinfo_animation * 255, c[2], 0, c[1])
          elseif ui.get(menu.vis_bad) then
            renderer.text(x_offset - 1  + ui.get(menu.userinfox_offset) , offset + 7.5 + ui.get(menu.userinfoy_offset), c[3][1], c[3][2], c[3][3], self.userinfo_animation * 255, c[2], 0, c[1])
end

            x = x + text_size[1]
        end
        local fakeyawtext = ""
        local side = ui.get(ref.body_yaw[2])
        if side > 0 then
          fakeyawtext = "R"
        elseif side < 0 then
          fakeyawtext = "L"
        elseif side == 0 then
          fakeyawtext = "O"
        end
  if ui_fn.includes(get(menu.vis_options), "User Info") == true and not ui.get(menu.vis_bad) then
        renderer.text(x_offset + 10 + ui.get(menu.userinfox_offset), offset +20 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "User: "..username)
        renderer.text(x_offset + 10 + ui.get(menu.userinfox_offset), offset +30 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Build: "..build)
        renderer.text(x_offset + 10 + ui.get(menu.userinfox_offset), offset +40 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Fake Limit: "..get(ref.fake_yaw_limit))
        renderer.text(x_offset + 10 + ui.get(menu.userinfox_offset), offset +50 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Fake Yaw: "..fakeyawtext)
          elseif ui.get(menu.vis_bad) then
            renderer.text(x_offset  + ui.get(menu.userinfox_offset), offset +20 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "User: "..username)
            renderer.text(x_offset  + ui.get(menu.userinfox_offset), offset +30 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Build: "..build)
         --   renderer.text(x_offset + ui.get(menu.userinfox_offset), offset +40 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Fake Limit: "..get(ref.fake_yaw_limit))
            renderer.text(x_offset + ui.get(menu.userinfox_offset), offset +50 + ui.get(menu.userinfoy_offset), 255, 255, 255, self.userinfo_animation * 255, "b", 0, "Fake Yaw: "..fakeyawtext)
          end



    end,

    weaponinfo = function(self)
        local inc = (1 / 0.5) * globals_frametime()
        local offset = -5
        local x_offset = 10
        if (get(menu.enable) and ui_fn.includes(get(menu.vis_options), "Weapon Info")) == false then
            inc = inc * -1
        end
        self.weaponinfo_animation = math_fn.clamp(0, 1, self.weaponinfo_animation + inc)

        if self.weaponinfo_animation <= 0 then
            return
        end
        weapon_ent = entity_get_player_weapon(lp)
        weapon = csgo_weapons[entity_get_prop(weapon_ent, "m_iItemDefinitionIndex")]
        if weapon == nil then return else weapon_icon = images.get_weapon_icon(weapon) end

        local white = {220, 220, 220, 255}
        local disabled_color = {150, 150, 150, 255}
        local average_color = math_fn.lerp(self.color_1, self.color_2, 0.5)

        local size = {20, 20}

        local resource = entity.get_player_resource()

        local ping = 0

        if resource ~= nil then
            ping = entity_get_prop(resource, "m_iPing", lp)
        end
        ping = math_floor(ping)

        local text = {
          {"   Weapon", "b", average_color},
            {"", "b", average_color},
            {" ", "", white},
            {"", "b", average_color},
            {" ", "", white},
            {" ", "", white},
            {"", "", white},
            {"", "b", average_color},
            {" ", "", white},
            {"", "b", average_color},
        }
        local text321 = {
          {"Welcome To 312431.P1us", "b", average_color},
        }

        for i = 1, #text do
            local c = text[i]
            local text_size = {renderer.measure_text(c[2], c[1])}

            size[1] = size[1] + text_size[1]

            if size[2] < text_size[2] then
                size[2] = text_size[2]
            end
        end

        local x = screen[1]/2 - 790
        if ui_fn.includes(get(menu.vis_options), "User Info") == true and not ui.get(menu.vis_bad) then
        render_fn.rounded_gradient_rectangle(x_offset + ui.get(menu.weaponinfox_offset), offset + ui.get(menu.weaponinfoy_offset), size[1], size[2] , 2, self.color_1, self.color_2, self.color_1, self.color_2, {25, 25, 25, 165 * self.weaponinfo_animation}, self.weaponinfo_animation * 255, 1, 1, self.weaponinfo_animation)
      elseif  ui.get(menu.vis_bad) then
        renderer.gradient(ui.get(menu.weaponinfox_offset)+ 15,  ui.get(menu.weaponinfoy_offset) + 1, size[1], size[2] - 10 ,153, 204, 255, 255, 153, 204, 255, 0, 255, 0, false)
      end


        for i = 1, #text do
            local c = text[i]
            local text_size = {renderer.measure_text(c[2], c[1])}

            renderer.text(x_offset + 10 + ui.get(menu.weaponinfox_offset) , offset +5 + ui.get(menu.weaponinfoy_offset), c[3][1], c[3][2], c[3][3], self.weaponinfo_animation * 255, c[2], 0, c[1])

            x = x + text_size[1]
        end
        weapon_icon:draw(x_offset + 8 + ui.get(menu.weaponinfox_offset), offset +20 + ui.get(menu.weaponinfoy_offset), 65,30,255,255,255,self.weaponinfo_animation * 255,255)





    end,



    run = function(self)
        self.color_1 = {get(menu.color_1)}
        self.color_2 = {get(menu.color_2)}

        self:crosshair()
        self:userinfo()
        self:weaponinfo()
    end,
}




local callbacks = {
    setup_command = function(cmd)
        lp = entity_get_local_player()

        if get(menu.enable) == false or lp == nil or entity_is_alive(lp) == false then
            return
        end

        antiaim:run(cmd)
        gui:setup_command(cmd)
    end,

    paint_ui = function()
        lp = entity_get_local_player()

        screen = {client.screen_size()}
        center = {screen[1]/2, screen[2]/2}

        handle_menu.paint_ui()
        debug_fn:run()
        visuals:run()
        gui:run()
        algorithm:update()
    end,

    weapon_fire = function(e)
        local player = client.userid_to_entindex(e.userid)

        if player ~= nil and lp ~= nil and player == lp then
            antiaim.sent_since_shot = false
        end
    end,


    shutdown = function()
        handle_menu.shutdown()
    end,
}

client.set_event_callback("setup_command", callbacks.setup_command)
client.set_event_callback("paint_ui", callbacks.paint_ui)
client.set_event_callback("shutdown", callbacks.shutdown)
client.set_event_callback("weapon_fire", callbacks.weapon_fire)
ui.set_callback(menu.enable, callbacks.shutdown)

local  remove =  table.remove

local callbacks = {}

local function insert(table, data)
    table[#table + 1] = data
end

local function create_callback(event, fn)
    insert(callbacks, {e = event, f = fn})
end

local log_fn = {
    create_log = function(type, data, time)
        if _G.exquisite_log_data == nil then
            _G.exquisite_log_data = {
                enabled = false,
                modes = {},
                font_style = ui.get(menu.logs_fonts),
                data = {}
            }
        end

        table.insert(_G.exquisite_log_data.data, {
            type = type,
            data = data,
            time = time
        })
    end,

    init = function()
        _G.exquisite_log_data = {
            enabled = false,
            modes = {},
            font_style = ui.get(menu.logs_fonts),
            data = {}
        }
    end
}
log_fn.init()

local logs = {
    white = {255, 255, 255, 255},
    hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"},

    multicolor_console = function(...)
        local texts = {...}
        for i=1, #texts do
            local text = texts[i]
            client.color_log(text[1], text[2], text[3], i ~= #texts and (text[4] .. '\0') or text[4])
        end
    end,

    logs_data = {
        text = {},
        cur_offset = {},
        alpha = {},
        time = {}
    },

    fire_logs = {
        id = {},
        pred_hc = {},
        pred_hb = {},
        pred_dmg = {}
    },

    create_log = function(self, time, ...)
        insert(self.logs_data.text, {...})
        insert(self.logs_data.cur_offset, 0)
        insert(self.logs_data.alpha, 0)
        insert(self.logs_data.time, globals_realtime() + time)
    end,

    remove_shot_data = function(self, id)
        for i=1, #self.fire_logs.id do
            if self.fire_logs.id[i] == id then
                remove(self.fire_logs.pred_hc, i)
                remove(self.fire_logs.pred_hb, i)
                remove(self.fire_logs.pred_dmg, i)
                remove(self.fire_logs.id, i)
            end
        end
    end,

    aim_fire = function(self, e) --Aimbot fire
        if get(menu.enable) and get(menu.logs) then
            local contains, i = ui_fn.includes(self.fire_logs.id, e.id) --Collect targeted hc, hb, and pred. dmg
            if contains == false then
                insert(self.fire_logs.id, e.id)
                insert(self.fire_logs.pred_hc, e.hit_chance)
                insert(self.fire_logs.pred_hb, e.hitgroup)
                insert(self.fire_logs.pred_dmg, e.damage)
            end
        end
    end,

    aim_hit = function(self, e) --Aimbot hit
        local target = e.target

        if get(menu.enable) and get(menu.logs) then
            local contains, i = ui_fn.includes(self.fire_logs.id, e.id)
            if contains then --Add logs
                local pred_hc = self.fire_logs.pred_hc[i]
                local pred_hb = self.hitgroup_names[self.fire_logs.pred_hb[i] + 1]
                local pred_dmg = self.fire_logs.pred_dmg[i]

                local name = entity_get_player_name(target)
                local acc = e.hit_chance
                local hitbox = self.hitgroup_names[e.hitgroup + 1]
                local damage = e.damage
                local health = entity_get_prop(target, "m_iHealth") or 0

                local hit_color = {get(menu.logs_hit_color)}

                log_fn.create_log({"center"}, {
                    {self.white[1], self.white[2], self.white[3], "Hit "},
                    {hit_color[1], hit_color[2], hit_color[3], name},
                    {self.white[1], self.white[2], self.white[3], " in the "},
                    {hit_color[1], hit_color[2], hit_color[3], hitbox},
                    {self.white[1], self.white[2], self.white[3], " for "},
                    {hit_color[1], hit_color[2], hit_color[3], damage},
                    {self.white[1], self.white[2], self.white[3], " damage ("},
                    {hit_color[1], hit_color[2], hit_color[3], health},
                    {self.white[1], self.white[2], self.white[3], " health remaining)"}
                }, 5)

                log_fn.create_log({"console", "corner"}, {
                    {self.white[1], self.white[2], self.white[3], "["},
                    {hit_color[1], hit_color[2], hit_color[3], "Exquisite"},
                    {self.white[1], self.white[2], self.white[3], "] "},
                    {self.white[1], self.white[2], self.white[3], "Hit "},
                    {hit_color[1], hit_color[2], hit_color[3], name},
                    {self.white[1], self.white[2], self.white[3], " in the "},
                    {hit_color[1], hit_color[2], hit_color[3], hitbox},
                    {self.white[1], self.white[2], self.white[3], " for "},
                    {hit_color[1], hit_color[2], hit_color[3], damage},
                    {self.white[1], self.white[2], self.white[3], " damage ("},
                    {hit_color[1], hit_color[2], hit_color[3], health},
                    {self.white[1], self.white[2], self.white[3], " health remaining, real hitchance: "},
                    {hit_color[1], hit_color[2], hit_color[3], math_floor(acc)},
                    {self.white[1], self.white[2], self.white[3], ", client hitchance: "},
                    {hit_color[1], hit_color[2], hit_color[3], math_floor(pred_hc)},
                    {self.white[1], self.white[2], self.white[3], ", client hitbox: "},
                    {hit_color[1], hit_color[2], hit_color[3], pred_hb},
                    {self.white[1], self.white[2], self.white[3], ", client damage: "},
                    {hit_color[1], hit_color[2], hit_color[3], pred_dmg},
                    {self.white[1], self.white[2], self.white[3], ")"}
                }, 10)

                self:remove_shot_data(e.id)
            end
        end
    end,

    aim_miss = function(self, e) --ehhh... nothing new
        local target = e.target

        if get(menu.enable) and get(menu.logs) then
            local contains, i = ui_fn.includes(self.fire_logs.id, e.id)
            if contains then
                local name = entity_get_player_name(target)
                local acc = e.hit_chance
                local hitbox = self.hitgroup_names[e.hitgroup + 1]
                local reason = e.reason == "?" and "resolver" or e.reason
                local pred_hc = self.fire_logs.pred_hc[i]
                local pred_hb = self.hitgroup_names[self.fire_logs.pred_hb[i] + 1]
                local pred_dmg = self.fire_logs.pred_dmg[i]

                local miss_color = {get(menu.logs_miss_color)}

                log_fn.create_log({"center"}, {
                    {self.white[1], self.white[2], self.white[3], "Missed "},
                    {miss_color[1], miss_color[2], miss_color[3], name},
                    {self.white[1], self.white[2], self.white[3], "'s "},
                    {miss_color[1], miss_color[2], miss_color[3], hitbox},
                    {self.white[1], self.white[2], self.white[3], " due to "},
                    {miss_color[1], miss_color[2], miss_color[3], reason},
                    {self.white[1], self.white[2], self.white[3], " ("},
                    {miss_color[1], miss_color[2], miss_color[3], math_floor(acc)},
                    {self.white[1], self.white[2], self.white[3], "% hitchance)"}
                }, 5)

                log_fn.create_log({"console", "corner"}, {
                    {self.white[1], self.white[2], self.white[3], "["},
                    {miss_color[1], miss_color[2], miss_color[3], "Exquisite"},
                    {self.white[1], self.white[2], self.white[3], "] "},
                    {self.white[1], self.white[2], self.white[3], "Missed "},
                    {miss_color[1], miss_color[2], miss_color[3], name},
                    {self.white[1], self.white[2], self.white[3], "'s "},
                    {miss_color[1], miss_color[2], miss_color[3], hitbox},
                    {self.white[1], self.white[2], self.white[3], " due to "},
                    {miss_color[1], miss_color[2], miss_color[3], reason},
                    {self.white[1], self.white[2], self.white[3], " (real hitchance: "},
                    {miss_color[1], miss_color[2], miss_color[3], math_floor(acc)},
                    {self.white[1], self.white[2], self.white[3], ", client hitchance: "},
                    {miss_color[1], miss_color[2], miss_color[3], math_floor(pred_hc)},
                    {self.white[1], self.white[2], self.white[3], ", client hitbox: "},
                    {miss_color[1], miss_color[2], miss_color[3], pred_hb},
                    {self.white[1], self.white[2], self.white[3], ", client damage: "},
                    {miss_color[1], miss_color[2], miss_color[3], pred_dmg},
                    {self.white[1], self.white[2], self.white[3], ")"}
                }, 10)

                --Remove old data that we aren't gonna use
                self:remove_shot_data(e.id)
            end
        end
    end,

    run = function(self)

        _G.exquisite_log_data.enabled = get(menu.enable) and get(menu.logs)
        _G.exquisite_log_data.modes = get(menu.logs_output)
        _G.exquisite_log_data.font_style = ui.get(menu.logs_fonts)
    end
}

create_callback("aim_fire", function(e) logs:aim_fire(e) end)
create_callback("aim_hit", function(e) logs:aim_hit(e) end)
create_callback("aim_miss", function(e) logs:aim_miss(e) end)
create_callback("paint", function() logs:run() end)

--Init. callbacks
for i = 1, #callbacks do
    local callback = callbacks[i]
    client_set_event_callback(callback.e, callback.f)
end


local log_weapon_purchases = ui.reference("MISC", "Miscellaneous", "Log weapon purchases")
local log_damage_dealt = ui.reference("MISC", "Miscellaneous", "Log damage dealt")

local ui_fn = {
    includes = function(table, key)
        for i = 1, #table do
            if table[i] == key then
                return true, i
            end
        end

        return false, nil
    end,

    set_visible = function(state, ...)
        local args = {...}

        for i = 1, #args do
            ui.set_visible(args[i], state)
        end
    end,
}

local math_fn = {
    clamp = function(min, max, value)
        if value > max then
            return max
        elseif value < min then
            return min
        else
            return value
        end
    end
}

local log = {
    font = "Normal",

    multicolor_console = function(...)
        local texts = {...}
        for i=1, #texts do
            local text = texts[i]
            client.color_log(text[1], text[2], text[3], i ~= #texts and (text[4] .. '\0') or text[4])
        end
    end,

    logs_data = {
        text = {},
        cur_offset = {},
        alpha = {},
        time = {}
    },

    create_log = function(self, time, data)
        table.insert(self.logs_data.text, data)
        table.insert(self.logs_data.cur_offset, 0)
        table.insert(self.logs_data.alpha, 0)
        table.insert(self.logs_data.time, globals.realtime() + time)
    end,


    run = function(self)
        local alpha_inc = (255/0.25) * globals.frametime()
        local offset = 0
        local flags = ""
        local uppercase = false
        local log_font_g = self.font

        if log_font_g == "Default" then
            flags = ""
        elseif log_font_g == "Bold" then
            flags = "b"
        elseif log_font_g == "Large" then
            flags = "+"
          elseif log_font_g == "Normal" then
              flags = "b-"
        else
            flags = "-"
            uppercase = true
        end

        local min_x = screen[1]
        local max_x = 0

        for i=#self.logs_data.text, 1, -1 do
            if self.logs_data.text[i] ~= nil then
                local table_text = self.logs_data.text[i]

                local max_alpha = self.logs_data.alpha[i]
                self.logs_data.alpha[i] = math_fn.clamp(0, 255, self.logs_data.time[i] < globals.realtime() and max_alpha - alpha_inc or max_alpha + alpha_inc)

                local old_offset = self.logs_data.cur_offset[i]
                if old_offset ~= offset then
                    self.logs_data.cur_offset[i] = math_fn.clamp(0, offset, old_offset < offset and old_offset + (200 * globals.frametime()) or offset)
                end

                local new_offset = self.logs_data.cur_offset[i]

                local raw_text = ''

                for i2=1, #table_text do
                    raw_text = raw_text .. table_text[i2][4]
                end

                if uppercase then
                    raw_text = string.upper(raw_text)
                end

                local total_size = {renderer.measure_text(flags, raw_text)}

                local percent = 1-(max_alpha/255)
                local x_offset = self.logs_data.time[i] > globals.realtime() and -percent*40 or percent*40

                local text_height = 0
                local text_offset = 0

                for i2=1, #table_text do
                    local cur_table_text = table_text[i2]

                    local text = cur_table_text[4]
                    if uppercase then
                        text = string.upper(cur_table_text[4])
                    end

                    local text_size = {renderer.measure_text(flags, text)}

                    if text_height < text_size[2] then
                        text_height = text_size[2]
                    end

                    renderer.text((center[1] - total_size[1]/2) + text_offset + x_offset, screen[2] - 300 + new_offset, cur_table_text[1], cur_table_text[2], cur_table_text[3], max_alpha, flags, 0, text)
                    text_offset = text_offset + text_size[1] + (uppercase and 1 or 0)
                end

                if (center[1] - total_size[1]/2) < min_x then
                    min_x = center[1] - total_size[1]/2
                end

                if max_x < text_offset then
                    max_x = text_offset
                end

                offset = offset + text_height + 2
            end
        end

        for i=1, #self.logs_data.text do
            local dif_from_newest = #self.logs_data.text - i

            if dif_from_newest > 5 then
                self.logs_data.time[i] = 0
            end
        end

        --Remove old logs
        for i=1, #self.logs_data.text do
            if self.logs_data.alpha[i] == 0 and self.logs_data.time[i] < globals.realtime() then
                table.remove(self.logs_data.cur_offset, i)
                table.remove(self.logs_data.alpha, i)
                table.remove(self.logs_data.time, i)
                table.remove(self.logs_data.text, i)
            end
        end
    end
}

local corner = {
    logs = {},

    create = function(self, time, text)
        local total_string = ""

        for i = 1, #text do
            total_string = total_string .. text[i][4]
        end

        local text_size = {renderer.measure_text("", total_string)}

        table.insert(self.logs, {
            text = text,
            alpha = 0,
            time = globals.realtime() + time
        })
    end,

    run = function(self)
        local alpha_inc = (255/0.3) * globals.frametime()
        local dec = (20 / 0.3) * globals.frametime()
        local offset = -10

        for i = #self.logs, 1, -1 do
            local delta = #self.logs - i

            if delta > 7 then
                table.remove(self.logs, i)
            end
        end

        for i = 1, #self.logs do
            local log = self.logs[i]

            if log then
                if log.time < globals.realtime() then
                    log.alpha = math.max(0, log.alpha - alpha_inc)

                    if log.alpha == 0 then
                        table.remove(self.logs, i)
                    end
                else
                    log.alpha = math.min(255, log.alpha + alpha_inc)
                end

                local x_offset = 5

                for j = 1, #log.text do
                    local text = log.text[j]
                    local size = {renderer.measure_text("", text[4])}
                    renderer.text(x_offset, offset + 10, text[1], text[2], text[3], log.alpha, "", 0, text[4])
                    x_offset = x_offset + size[1]
                end

                offset = offset + 13
            end
        end
    end,
}

client.set_event_callback("paint_ui", function()
    corner:run()
    log:run()
end)

local function test()
    if _G.exquisite_log_data == nil then
        _G.exquisite_log_data = {
            enabled = false,
            modes = {},
            font_style = ui.get(menu.logs_fonts),
            data = {}
        }
        return
    end

    if _G.exquisite_log_data.enabled == false then
        return
    end

    log.font = _G.exquisite_log_data.font_style

    local console = ui_fn.includes(_G.exquisite_log_data.modes, "Console")
    local center = ui_fn.includes(_G.exquisite_log_data.modes, "Center")
    local top_left = ui_fn.includes(_G.exquisite_log_data.modes, "Top-left corner")

    if top_left then
        ui.set(log_weapon_purchases, false)
        ui.set(log_damage_dealt, false)

        ui_fn.set_visible(false, log_weapon_purchases, log_damage_dealt)
    else
        ui_fn.set_visible(true, log_weapon_purchases, log_damage_dealt)
    end

    for i = 100, 1, -1 do
        local scan = _G.exquisite_log_data.data[i]

        if scan then
            if ui_fn.includes(scan.type, "console") and console then
                log.multicolor_console(unpack(scan.data))
            end

            if ui_fn.includes(scan.type, "center") and center then
                log:create_log(scan.time, scan.data)
            end

            if ui_fn.includes(scan.type, "corner") and top_left then
                corner:create(scan.time, scan.data)
            end

            table.remove(_G.exquisite_log_data.data, i)
        end
    end
end

client.set_event_callback("paint_ui", test)

local http = require "gamesense/http" or error("Missing gamesense/http")
local images = require "gamesense/images" or error("Missing gamesense/images")
local gif_decoder = require 'gamesense/gif_decoder' or error("Missing gamesense/gif_decoder")

--local font = surface.create_font("TT_Skip-E 85W", 12, 1, {0x010}, {0x100}) --Genshin Impact font https://www.mediafire.com/file/x9732fvuwlbrwct/Genshin_Imapct_Fonts.rar/file

local start_time = globals.realtime()

local mikuurl, miku = "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/65f99b17-b632-4ffb-8b5a-15ef5a546979/ddelv9e-90c5d8f6-234f-4d81-b6fd-cf65ba2a13ce.gif?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzY1Zjk5YjE3LWI2MzItNGZmYi04YjVhLTE1ZWY1YTU0Njk3OVwvZGRlbHY5ZS05MGM1ZDhmNi0yMzRmLTRkODEtYjZmZC1jZjY1YmEyYTEzY2UuZ2lmIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.m405p8unB585ccrom29s9biiNEmSl9ahqk2XcOQxmRc", nil
http.get(mikuurl, function(s, r)
    if s and r.status == 200 then
        miku = gif_decoder.load_gif(r.body)
    end
end)

client.set_event_callback("paint", function()
 local menux, menuy = ui.menu_position()
	if ui.is_menu_open() then
   	  renderer.text(menux - 106.5, menuy + 15, 255, 255, 255, 255, 'b', 0, 'Exquisite.lua')
      if miku == nil then return end
      miku:draw(globals.realtime()-start_time, menux - 140, menuy + 0, 132, 155)
end
end)
