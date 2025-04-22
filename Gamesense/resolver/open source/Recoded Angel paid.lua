---@diagnostic disable: undefined-global
local ffi = require 'ffi'

local function contains(tbl, val)
    if tbl == nil then return false end
    for i=1, #tbl do
        if tbl[i] == val then return true end
    end
    return false
end

ffi.cdef[[
    struct animation_layer_t {
        char pad_0000[20];
        uint32_t m_nOrder; //0x0014
        uint32_t m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030 // player's thisptr
        char pad_0038[4]; //0x0034
    };

    struct animstate_t {
        char pad[3];
        char m_bForceWeaponUpdate; //0x4
        char pad1[91];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[4];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[4];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[4];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[4];
        float m_flUnknownFloat1; //0xD4
        char pad6[8];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        char pad7[2];
        float m_flJumpToFall;
        float m_flTimeSinceInAir; //0x110
        float m_flLastOriginZ; //0x114
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x118
        float m_flStopToFullRunningFraction; //0x11C
        char pad8[4];
        float m_flMagicFraction; //0x124
        char pad9[60];
        float m_flWorldForce; //0x164
        char pad10[462];
        float m_flMaxYaw; //0x334
    };
    
    typedef struct {
        float x;
        float y;
        float z;
    } Vector;
    
    typedef struct {
        float m[3][4];
    } matrix3x4_t;
]]

local classptr = ffi.typeof('void***')
local get_client_entity_type = ffi.typeof('void*(__thiscall*)(void*, int)')
local get_studio_model_type = ffi.typeof('void*(__thiscall*)(void*, const void*)')
local get_sequence_activity_type = ffi.typeof('int(__fastcall*)(void*, void*, int)')

local raw_entity_list = client.create_interface('client_panorama.dll', 'VClientEntityList003')
local entity_list_ptr = ffi.cast(classptr, raw_entity_list) or error('Entity list interface not found', 2)
local get_client_entity = ffi.cast(get_client_entity_type, entity_list_ptr[0][3])

local raw_model_info = client.create_interface('engine.dll', 'VModelInfoClient004')
local model_info_ptr = ffi.cast(classptr, raw_model_info) or error('Model info interface not found', 2)
local get_studio_model = ffi.cast(get_studio_model_type, model_info_ptr[0][32])

local RESOLVER_CONST = {
    LAYER_AIMMATRIX = 0,
    LAYER_WEAPON_ACTION = 1,
    LAYER_WEAPON_ACTION_RECROUCH = 2,
    LAYER_ADJUST = 3,
    LAYER_MOVEMENT_JUMP_OR_FALL = 4,
    LAYER_MOVEMENT_LAND_OR_CLIMB = 5,
    LAYER_MOVEMENT_MOVE = 6,
    LAYER_MOVEMENT_STRAFECHANGE = 7,
    LAYER_WHOLE_BODY = 8,
    LAYER_FLASHED = 9,
    LAYER_FLINCH = 10,
    LAYER_ALIVELOOP = 11,
    LAYER_LEAN = 12,
    
    MAX_DESYNC_DELTA = 58,
    BRUTE_FORCE_STEPS = 5,
    MAX_HISTORY_SIZE = 64,
    MIN_DELTA_FOR_CORRECTION = 5,
    JITTER_DETECTION_THRESHOLD = 40,
    DEFENSIVE_TRIGGER_TIME = 0.15,
    RESOLVER_CHANGE_TIMEOUT = 2.0,
    
    STATE_STAND = 1,
    STATE_MOVE = 2,
    STATE_CROUCH = 3,
    STATE_AIR = 4,
    STATE_SLOWWALK = 5,
    STATE_CROUCHWALK = 6
}

local ui_colors = {
    accent = {r = 155, g = 220, b = 255, a = 255},
    highlight = {r = 240, g = 196, b = 255, a = 255},
    warning = {r = 255, g = 120, b = 120, a = 255},
    success = {r = 120, g = 255, b = 140, a = 255},
    neutral = {r = 200, g = 200, b = 200, a = 255}
}

local seq_activity_sig = client.find_signature('client_panorama.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

local function get_model(entity_ptr)
    if entity_ptr then
        entity_ptr = ffi.cast(classptr, entity_ptr)
        local client_unknown = ffi.cast('void*(__thiscall*)(void*)', entity_ptr[0][0])(entity_ptr)
        
        if client_unknown then
            client_unknown = ffi.cast(classptr, client_unknown)
            local renderable = ffi.cast('void*(__thiscall*)(void*)', client_unknown[0][5])(client_unknown)
            
            if renderable then
                renderable = ffi.cast(classptr, renderable)
                return ffi.cast('const void*(__thiscall*)(void*)', renderable[0][8])(renderable)
            end
        end
    end
    return nil
end

local function get_animstate(entity_ptr)
    if not entity_ptr then return nil end
    return ffi.cast('struct animstate_t*', ffi.cast('uintptr_t', entity_ptr) + 0x3914)
end

local function get_sequence_activity(entity_ptr, sequence)
    if not entity_ptr or not sequence then return -1 end
    
    local model_ptr = get_model(entity_ptr)
    if not model_ptr then return -1 end
    
    local studio_model = get_studio_model(model_info_ptr, model_ptr)
    if not studio_model then return -1 end
    
    local seq_activity_fn = ffi.cast(get_sequence_activity_type, seq_activity_sig)
    return seq_activity_fn(entity_ptr, studio_model, sequence)
end

local function get_anim_layer(entity_ptr, layer_index)
    if not entity_ptr then return nil end
    
    local anim_layer_ptr = ffi.cast('struct animation_layer_t**', ffi.cast('char*', entity_ptr) + 0x2990)
    if anim_layer_ptr == nil or anim_layer_ptr[0] == nil then return nil end
    
    return (layer_index >= 0 and layer_index <= 13) and anim_layer_ptr[0][layer_index] or nil
end

local function get_all_anim_layers(entity_ptr)
    if not entity_ptr then return {} end
    
    local layers = {}
    for i = 0, 13 do
        local layer = get_anim_layer(entity_ptr, i)
        if layer then
            layers[i] = {
                sequence = layer.m_nSequence,
                weight = layer.m_flWeight,
                cycle = layer.m_flCycle,
                playback_rate = layer.m_flPlaybackRate,
                prev_cycle = layer.m_flPrevCycle,
                weight_delta_rate = layer.m_flWeightDeltaRate
            }
        end
    end
    
    return layers
end

math_util = {
    clamp = function(value, min_val, max_val)
        if value > max_val then return max_val end
        if value < min_val then return min_val end
        return value
    end,
    
    normalize_yaw = function(yaw)
        while yaw > 360 do yaw = yaw - 360 end
        while yaw < 0 do yaw = yaw + 360 end
        return yaw
    end,
    
    to_180_range = function(yaw)
        if yaw > 180 then return yaw - 360 end
        return yaw
    end,
    
    lerp = function(a, b, t)
        return a + (b - a) * t
    end,
    
    approach_angle = function(target, current, speed)
        local delta = math_util.to_180_range(target - current)
        if speed > math.abs(delta) then
            return target
        end
        return math_util.normalize_yaw(current + (delta >= 0 and speed or -speed))
    end,
    
    angle_diff = function(a, b)
        local diff = math.abs(math_util.to_180_range(a) - math_util.to_180_range(b)) % 360
        return diff > 180 and 360 - diff or diff
    end
}

vec_util = {
    length = function(vec)
        return math.sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z)
    end,
    
    length2d = function(vec)
        return math.sqrt(vec.x*vec.x + vec.y*vec.y)
    end,
    
    get_velocity = function(player)
        local vx = entity.get_prop(player, "m_vecVelocity[0]") or 0
        local vy = entity.get_prop(player, "m_vecVelocity[1]") or 0
        local vz = entity.get_prop(player, "m_vecVelocity[2]") or 0
        return {x = vx, y = vy, z = vz}
    end,
    
    get_origin = function(player)
        local x = entity.get_prop(player, "m_vecOrigin[0]") or 0
        local y = entity.get_prop(player, "m_vecOrigin[1]") or 0
        local z = entity.get_prop(player, "m_vecOrigin[2]") or 0
        return {x = x, y = y, z = z}
    end,
    
    predict_position = function(player, time_delta)
        local origin = vec_util.get_origin(player)
        local velocity = vec_util.get_velocity(player)
        
        return {
            x = origin.x + velocity.x * time_delta,
            y = origin.y + velocity.y * time_delta,
            z = origin.z + velocity.z * time_delta
        }
    end
}

local state_util = {
    get_state = function(player)
        local duck_amount = entity.get_prop(player, "m_flDuckAmount") or 0
        local flags = entity.get_prop(player, "m_fFlags") or 0
        local in_air = bit.band(flags, 1) == 0
        local velocity = vec_util.get_velocity(player)
        local speed2d = vec_util.length2d(velocity)
        
        if in_air then
            return RESOLVER_CONST.STATE_AIR
        elseif duck_amount > 0.7 then
            return speed2d > 20 and RESOLVER_CONST.STATE_CROUCHWALK or RESOLVER_CONST.STATE_CROUCH
        elseif speed2d < 5 then
            return RESOLVER_CONST.STATE_STAND
        elseif speed2d < 40 then
            return RESOLVER_CONST.STATE_SLOWWALK
        else
            return RESOLVER_CONST.STATE_MOVE
        end
    end,
    
    is_breaking_lc = function(player, player_data)
        if not player_data.position_history or #player_data.position_history < 2 then
            return false
        end
        
        local cur_pos = vec_util.get_origin(player)
        local old_pos = player_data.position_history[#player_data.position_history]
        local vel = vec_util.get_velocity(player)
        local speed = vec_util.length2d(vel)
        
        local time_delta = globals.tickinterval() * (globals.tickcount() - player_data.last_tickcount)
        local max_possible_delta = speed * time_delta
        
        local actual_delta = vec_util.length({
            x = cur_pos.x - old_pos.x,
            y = cur_pos.y - old_pos.y,
            z = cur_pos.z - old_pos.z
        })
        
        return actual_delta > max_possible_delta * 1.5 or actual_delta > 64
    end
}

fade_label = function(time, text, r, g, b, a)
    local function rgba_to_hex(r, g, b, a) 
        return string.format("\a%02X%02X%02X%02X", r, g, b, a) 
    end

    local color1, color2, color3 = 255, 255, 255 -- White base color
    local r_add, g_add, b_add = (color1 - r), (color2 - g), (color3 - b)
    local output = {}

    for i = 1, #text do
        local iter = (i - 1) / (#text - 1) + time
        output[#output + 1] = rgba_to_hex(
            r + r_add * math.abs(math.cos(iter)), 
            g + g_add * math.abs(math.cos(iter)), 
            b + b_add * math.abs(math.cos(iter)), 
            a
        ) .. text:sub(i, i)
    end

    return table.concat(output)
end

local menu = {
    refs = {
        anti_aim_correction = ui.reference("Rage", "Other", "Anti-Aim Correction"),
        reset_all = ui.reference("Players", "Players", "Reset All"),
        force_body_yaw = ui.reference("Players", "Adjustments", "Force Body Yaw"),
        correction_active = ui.reference("Players", "Adjustments", "Correction Active")
    },
    
    custom = {
        header = ui.new_label("Rage", "Other", "Angel Resolver"),
        enable = ui.new_checkbox("Rage", "Other", "Enable Resolver"),
        mode = ui.new_combobox("Rage", "Other", "Resolver Mode", "Standard", "Aggressive", "Brute Force", "Adaptive", "Maximum"),
        options = ui.new_multiselect("Rage", "Other", "Resolver Options", "Resolve On Miss", "Predict Movement", "Handle Defensive", "Detect Jitter", "Low Delta Priority"),
        debug = ui.new_multiselect("Rage", "Other", "Debug Options", "Console Logs", "ESP Flags", "Indicators", "Skeleton", "Statistics"),
        manual_override = ui.new_checkbox("Rage", "Other", "Manual Override"),
        override_mode = ui.new_combobox("Rage", "Other", "Override Method", "Force Left", "Force Right", "Force Center", "Opposite"),
        desync_prediction = ui.new_slider("Rage", "Other", "Desync Prediction Strength", 0, 100, 50, true, "%"),
    }
}

local function update_menu_visibility()
    local enabled = ui.get(menu.custom.enable)
    
    ui.set_visible(menu.custom.header, true)
    ui.set_visible(menu.custom.mode, enabled)
    ui.set_visible(menu.custom.options, enabled)
    ui.set_visible(menu.custom.debug, enabled)
    ui.set_visible(menu.custom.manual_override, enabled)
    ui.set_visible(menu.custom.override_mode, enabled and ui.get(menu.custom.manual_override))
    ui.set_visible(menu.custom.desync_prediction, enabled)
    
    ui.set_visible(menu.refs.force_body_yaw, not enabled)
    ui.set_visible(menu.refs.correction_active, not enabled)
    
    if not enabled then
        ui.set(menu.refs.reset_all, true)
    end
end

update_menu_visibility()
ui.set_callback(menu.custom.enable, update_menu_visibility)
ui.set_callback(menu.custom.manual_override, update_menu_visibility)

local player_data = {}
local resolver_stats = {
    total_hits = 0,
    total_misses = 0,
    hits_by_method = {
        animation = 0,
        matrix = 0,
        brute = 0,
        adaptive = 0,
        maximum = 0
    },
    misses_by_method = {
        animation = 0,
        matrix = 0,
        brute = 0,
        adaptive = 0,
        maximum = 0
    },
    misses_by_reason = {
        spread = 0,
        prediction = 0,
        lagcomp = 0,
        correction = 0,
        unknown = 0
    }
}

local MAX_PLAYERS = 64

for i = 1, MAX_PLAYERS do
    player_data[i] = {
        side = 1,             -- 1 = right, 2 = left, 0 = center
        desync = 25,          -- Desync value (0-60)
        last_pitch = 0,       -- For defensive AA detection
        anim_debug = 0,       -- Debug value for logs
        
        current_state = 0,    -- Current movement state
        is_breaking_lc = false, -- Lagcomp breaker detection
        defensive_triggered = false, -- Defensive AA active
        desync_pattern = "unknown", -- Detected pattern
        max_desync_delta = RESOLVER_CONST.MAX_DESYNC_DELTA, -- Maximum desync angle
        
        animation_layers_history = {}, -- Stores recent animation layers
        eye_angles_history = {},     -- Stores recent eye angles
        position_history = {},       -- Stores recent player positions
        simulation_time_history = {}, -- Stores recent simulation times
        jitter_data = {},           -- Jitter analysis data
        
        shots_fired = 0,
        shots_hit = 0,
        shots_missed = 0,
        last_hit_side = 0,
        last_miss_side = 0,
        miss_count = 0,         -- Consecutive misses for brute force
        last_missed_reason = "", -- Last miss reason
        
        brute_stage = 0,
        brute_direction = 1,    -- Direction to brute force
        brute_yaw_offset = 0,   -- Current brute force yaw
        
        last_update = 0,
        last_shot_time = 0,
        last_miss_time = 0,
        last_hit_time = 0,
        last_defensive_time = 0,
        last_resolving_method = "animation",
        last_tickcount = 0
    }
end

local function analyze_anim_layer(layers)
    if not layers or not layers[RESOLVER_CONST.LAYER_MOVEMENT_MOVE] then
        return nil
    end
    
    local layer6 = layers[RESOLVER_CONST.LAYER_MOVEMENT_MOVE]
    local playback_rate = layer6.playback_rate or 0
    local digits = {}
    
    for i = 1, 13 do
        digits[i] = math.floor(playback_rate * (10^i)) % 10
    end
    
    local anim_45 = tonumber(digits[4] .. digits[5]) or 0
    local anim_67 = tonumber(digits[6] .. digits[7]) or 0
    local anim_89 = tonumber(digits[8] .. digits[9]) or 0
    local anim_4567 = tonumber(anim_45 .. digits[6] .. digits[7]) or 0
    local anim_6789 = tonumber(anim_67 .. digits[8] .. digits[9]) or 0
    
    local r_side_r = digits[4] + digits[5] + digits[6] + digits[7]
    local r_side_s = digits[6] + digits[7] + digits[8] + digits[9]
    
    local diff_1 = math.abs(anim_6789 - anim_67)
    local diff_2 = math.abs(anim_4567 - anim_45)

    local weight_spread = 0
    local cycle_delta = 0
    
    if layers[RESOLVER_CONST.LAYER_AIMMATRIX] and layers[RESOLVER_CONST.LAYER_WEAPON_ACTION] then
        weight_spread = math.abs(layers[RESOLVER_CONST.LAYER_AIMMATRIX].weight - layers[RESOLVER_CONST.LAYER_WEAPON_ACTION].weight)
        cycle_delta = math.abs(layers[RESOLVER_CONST.LAYER_AIMMATRIX].cycle - layers[RESOLVER_CONST.LAYER_WEAPON_ACTION].cycle)
    end
    
    return {
        is_moving = digits[3] ~= 0,
        anim_45 = anim_45,
        anim_67 = anim_67,
        anim_89 = anim_89,
        anim_4567 = anim_4567,
        anim_6789 = anim_6789,
        r_side_r = r_side_r,
        r_side_s = r_side_s,
        diff_1 = diff_1,
        diff_2 = diff_2,
        digits = digits,
        weight_spread = weight_spread,
        cycle_delta = cycle_delta
    }
end

local function detect_jitter_pattern(player, player_data)
    if not player_data.animation_layers_history or #player_data.animation_layers_history < 3 then
        return "unknown", 0
    end
    
    local angle_switches = 0
    local last_side = 0
    local pattern_type = "unknown"
    local jitter_amount = 0
    
    if #player_data.eye_angles_history >= 3 then
        local angles = player_data.eye_angles_history
        
        for i = 1, #angles - 1 do
            local diff = math_util.angle_diff(angles[i].y, angles[i + 1].y)
            if diff > RESOLVER_CONST.JITTER_DETECTION_THRESHOLD then
                angle_switches = angle_switches + 1
                jitter_amount = math.max(jitter_amount, diff)
            end
        end
    end
    
    if #player_data.animation_layers_history >= 3 then
        local layers = player_data.animation_layers_history
        
        local weight_changes = 0
        local weight_sum = 0
        
        for i = 1, #layers - 1 do
            if layers[i][RESOLVER_CONST.LAYER_AIMMATRIX] and layers[i+1][RESOLVER_CONST.LAYER_AIMMATRIX] then
                local diff = math.abs(layers[i][RESOLVER_CONST.LAYER_AIMMATRIX].weight - layers[i+1][RESOLVER_CONST.LAYER_AIMMATRIX].weight)
                if diff > 0.2 then
                    weight_changes = weight_changes + 1
                    weight_sum = weight_sum + diff
                end
            end
        end
        
        if weight_changes > 0 then
            jitter_amount = math.max(jitter_amount, (weight_sum / weight_changes) * 100)
        end
    end
    
    if angle_switches >= 2 then
        pattern_type = "random"
    elseif angle_switches == 1 then
        pattern_type = "switch"
    elseif angle_switches == 0 then
        pattern_type = "static"
    end
    
    if pattern_type == "random" then
        jitter_amount = math.min(jitter_amount * 1.2, RESOLVER_CONST.MAX_DESYNC_DELTA)
    elseif pattern_type == "switch" then
        jitter_amount = math.min(jitter_amount, RESOLVER_CONST.MAX_DESYNC_DELTA)
    else
        jitter_amount = math.min(jitter_amount * 0.8, RESOLVER_CONST.MAX_DESYNC_DELTA)
    end
    
    return pattern_type, jitter_amount
end

local function detect_defensive_aa(player, player_data)
    local entity_ptr = get_client_entity(entity_list_ptr, player)
    if not entity_ptr then return false end
    
    local animstate = get_animstate(entity_ptr)
    if not animstate then return false end
    
    local defensiveActive = false
    
    if #player_data.eye_angles_history >= 3 then
        local current_pitch = player_data.eye_angles_history[1].x
        local prev_pitch = player_data.eye_angles_history[2].x
        
        if math.abs(current_pitch - prev_pitch) > 45 then
            defensiveActive = true
        end
    end--xd55
    
    if #player_data.animation_layers_history >= 2 then
        local current = player_data.animation_layers_history[1]
        local previous = player_data.animation_layers_history[2]
        
        if current[RESOLVER_CONST.LAYER_AIMMATRIX] and previous[RESOLVER_CONST.LAYER_AIMMATRIX] then
            local cycle_delta = math.abs(current[RESOLVER_CONST.LAYER_AIMMATRIX].cycle - previous[RESOLVER_CONST.LAYER_AIMMATRIX].cycle)
            local weight_delta = math.abs(current[RESOLVER_CONST.LAYER_AIMMATRIX].weight - previous[RESOLVER_CONST.LAYER_AIMMATRIX].weight)
            
            if cycle_delta > 0.9 or weight_delta > 0.9 then
                defensiveActive = true
            end
        end
    end
    
    if player_data.defensive_triggered and 
       globals.curtime() - player_data.last_defensive_time < RESOLVER_CONST.DEFENSIVE_TRIGGER_TIME then
        defensiveActive = true
    end

    if #player_data.simulation_time_history >= 2 then
        local sim_diff = player_data.simulation_time_history[1] - player_data.simulation_time_history[2]
        if sim_diff > globals.tickinterval() * 2 or sim_diff < 0 then
            defensiveActive = true
        end
    end
    
    if defensiveActive and not player_data.defensive_triggered then
        player_data.last_defensive_time = globals.curtime()
    end
    
    return defensiveActive
end

local function calculate_max_desync(player, state)
    local max_desync = RESOLVER_CONST.MAX_DESYNC_DELTA

    if state == RESOLVER_CONST.STATE_AIR then
        max_desync = max_desync * 0.85
    elseif state == RESOLVER_CONST.STATE_MOVE then
        max_desync = max_desync * 0.9
    elseif state == RESOLVER_CONST.STATE_CROUCH then
        max_desync = max_desync * 0.95
    elseif state == RESOLVER_CONST.STATE_SLOWWALK then
        max_desync = max_desync * 0.92
    end
    
    return max_desync
end

local function resolve_player_angle(player, player_data, manual_override)
    local resolved_side = 0
    local resolved_desync = 0
    local confidence = 0
    local resolver_method = "unknown"
    
    if manual_override then
        local override_mode = ui.get(menu.custom.override_mode)
        
        if override_mode == "Force Left" then
            return 2, RESOLVER_CONST.MAX_DESYNC_DELTA, 1.0, "manual"
        elseif override_mode == "Force Right" then
            return 1, RESOLVER_CONST.MAX_DESYNC_DELTA, 1.0, "manual"
        elseif override_mode == "Force Center" then
            return 0, 0, 1.0, "manual"
        elseif override_mode == "Opposite" and player_data.last_miss_side ~= 0 then
            return player_data.last_miss_side == 1 and 2 or 1, RESOLVER_CONST.MAX_DESYNC_DELTA, 1.0, "manual"
        end
    end
    
    local options = ui.get(menu.custom.options)
    local resolve_on_miss = contains(options, "Resolve On Miss")
    
    if resolve_on_miss and player_data.miss_count > 0 and player_data.last_miss_side ~= 0 and
       globals.curtime() - player_data.last_miss_time < RESOLVER_CONST.RESOLVER_CHANGE_TIMEOUT then
        
        if player_data.miss_count >= 3 then
            local brute_steps = RESOLVER_CONST.BRUTE_FORCE_STEPS
            local step_size = RESOLVER_CONST.MAX_DESYNC_DELTA / brute_steps
            local brute_stage = player_data.brute_stage % brute_steps
            local side_multiplier = player_data.brute_direction
            
            resolved_desync = step_size * (brute_stage + 1)
            resolved_side = side_multiplier > 0 and 1 or 2
            
            player_data.brute_stage = player_data.brute_stage + 1
            if player_data.brute_stage >= brute_steps then
                player_data.brute_direction = -player_data.brute_direction
                player_data.brute_stage = 0
            end
            
            return resolved_side, resolved_desync, 0.7, "brute"
        else
            resolved_side = player_data.last_miss_side == 1 and 2 or 1
            resolved_desync = player_data.max_desync_delta * 0.9
            return resolved_side, resolved_desync, 0.6, "miss"
        end
    end
    
    local resolver_mode = ui.get(menu.custom.mode)
    
    local handle_defensive = contains(options, "Handle Defensive")
    
    if handle_defensive and player_data.defensive_triggered then
        resolved_desync = RESOLVER_CONST.MAX_DESYNC_DELTA
        if player_data.last_hit_side ~= 0 and globals.curtime() - player_data.last_hit_time < 5.0 then
            resolved_side = player_data.last_hit_side
        else
            if #player_data.animation_layers_history > 0 then
                local layers = player_data.animation_layers_history[1]
                if layers[RESOLVER_CONST.LAYER_AIMMATRIX] then
                    resolved_side = layers[RESOLVER_CONST.LAYER_AIMMATRIX].weight > 0.5 and 1 or 2
                else
                    resolved_side = 1
                end
            else
                resolved_side = 1
            end
        end
        
        return resolved_side, resolved_desync, 0.65, "defensive"
    end
    
    if #player_data.animation_layers_history > 0 then
        local analysis = analyze_anim_layer(player_data.animation_layers_history[1])
        
        if analysis then
            if not analysis.is_moving then
                if (analysis.diff_1 > 10 and analysis.diff_1 < 500) or 
                   (analysis.diff_1 > 1200 and analysis.diff_1 < 2200) or 
                   (analysis.diff_1 > 2500 and analysis.diff_1 < 3100) or 
                   (analysis.diff_1 > 4600 and analysis.diff_1 < 5300) or 
                   (analysis.diff_1 > 7000 and analysis.diff_1 < 8000) then
                    resolved_side = 2  -- Left
                elseif (analysis.diff_1 > 500 and analysis.diff_1 < 1200) or 
                       (analysis.diff_1 > 2200 and analysis.diff_1 < 2500) or 
                       (analysis.diff_1 > 3100 and analysis.diff_1 < 4600) or 
                       (analysis.diff_1 > 5300 and analysis.diff_1 < 7000) or 
                       (analysis.diff_1 > 8000 and analysis.diff_1 < 9000) then
                    resolved_side = 1  -- Right
                end
                
                local tmp_desync = -3.4117 * analysis.r_side_s + 98.9393
                if tmp_desync < 64 then
                    resolved_desync = tmp_desync
                end
                
                player_data.anim_debug = analysis.diff_1
            else
                -- Moving pattern analysis
                if (analysis.diff_2 > 10 and analysis.diff_2 < 500) or 
                   (analysis.diff_2 > 1200 and analysis.diff_2 < 2200) or 
                   (analysis.diff_2 > 2500 and analysis.diff_2 < 3100) or 
                   (analysis.diff_2 > 4600 and analysis.diff_2 < 5700) or 
                   (analysis.diff_2 > 7000 and analysis.diff_2 < 8000) then
                    resolved_side = 2  -- Left
                elseif (analysis.diff_2 > 500 and analysis.diff_2 < 1200) or 
                       (analysis.diff_2 > 2200 and analysis.diff_2 < 2500) or 
                       (analysis.diff_2 > 3100 and analysis.diff_2 < 4600) or 
                       (analysis.diff_2 > 5700 and analysis.diff_2 < 7000) or 
                       (analysis.diff_2 > 8000 and analysis.diff_2 < 9000) then
                    resolved_side = 1  -- Right
                end
                
                local tmp_desync = -3.4117 * analysis.r_side_r + 98.9393
                if tmp_desync < 64 then
                    resolved_desync = tmp_desync
                end
                
                player_data.anim_debug = analysis.diff_2
            end
            
            if analysis.weight_spread > 0.5 then
                resolved_desync = math.min(resolved_desync * 1.15, RESOLVER_CONST.MAX_DESYNC_DELTA)
            end
            
            -- Jitter detection
            local detect_jitter = contains(options, "Detect Jitter")
            if detect_jitter then
                local jitter_pattern, jitter_amount = detect_jitter_pattern(player, player_data)
                
                if jitter_pattern ~= "unknown" and jitter_pattern ~= "static" then
                    resolved_desync = math.min(jitter_amount, RESOLVER_CONST.MAX_DESYNC_DELTA)
                    if jitter_pattern == "random" and player_data.last_miss_side ~= 0 then
                        resolved_side = player_data.last_miss_side == 1 and 2 or 1
                    end
                    
                    player_data.desync_pattern = jitter_pattern
                end
            end
            
            resolver_method = "animation"
            confidence = 0.8
        end
    end
    
    resolved_desync = math_util.clamp(math.abs(math.floor(resolved_desync)), 0, player_data.max_desync_delta)
    
    if resolver_mode == "Aggressive" then
        resolved_desync = math.min(resolved_desync * 1.2, RESOLVER_CONST.MAX_DESYNC_DELTA)
        resolver_method = "aggressive"
    elseif resolver_mode == "Brute Force" then
        if player_data.shots_fired > 0 then
            local hit_ratio = player_data.shots_hit / player_data.shots_fired
            if hit_ratio < 0.3 and player_data.shots_fired > 3 then
                local brute_factor = 0.5 + (player_data.brute_stage % 5) * 0.1
                resolved_desync = RESOLVER_CONST.MAX_DESYNC_DELTA * brute_factor
                
                if player_data.brute_stage % 2 == 0 then
                    resolved_side = resolved_side == 1 and 2 or 1
                end
                
                player_data.brute_stage = (player_data.brute_stage + 1) % 5
                resolver_method = "brute"
            end
        end
    elseif resolver_mode == "Adaptive" then
        local hit_ratio = player_data.shots_hit / math.max(player_data.shots_fired, 1)
        
        if hit_ratio > 0.7 then
            resolved_desync = resolved_desync * 0.9
        elseif hit_ratio < 0.3 and player_data.shots_fired > 3 then
            resolved_side = player_data.last_miss_side == 1 and 2 or 1
            resolved_desync = player_data.max_desync_delta
        end
        
        resolver_method = "adaptive"
    elseif resolver_mode == "Maximum" then
        resolved_desync = RESOLVER_CONST.MAX_DESYNC_DELTA
        resolver_method = "maximum"
    end
    
    local low_delta_priority = contains(options, "Low Delta Priority")
    if low_delta_priority and resolved_desync > 30 then
        resolved_desync = resolved_desync * 0.85
    end
    
    local prediction_strength = ui.get(menu.custom.desync_prediction) / 100
    if prediction_strength > 0 and #player_data.animation_layers_history > 1 then
        local analysis1 = analyze_anim_layer(player_data.animation_layers_history[1])
        local analysis2 = analyze_anim_layer(player_data.animation_layers_history[2])
        
        if analysis1 and analysis2 then
            local delta_weight = 0
            local delta_cycle = 0
            
            if analysis1.weight_spread > 0 and analysis2.weight_spread > 0 then
                delta_weight = analysis1.weight_spread - analysis2.weight_spread
            end
            
            if analysis1.cycle_delta > 0 and analysis2.cycle_delta > 0 then
                delta_cycle = analysis1.cycle_delta - analysis2.cycle_delta
            end
            
            local predicted_desync = resolved_desync
            if math.abs(delta_weight) > 0.1 then
                predicted_desync = resolved_desync + (delta_weight * 20 * prediction_strength)
            end
            
            resolved_desync = math_util.lerp(resolved_desync, predicted_desync, prediction_strength)
            resolved_desync = math_util.clamp(resolved_desync, 0, player_data.max_desync_delta)
        end
    end
    
    return resolved_side, resolved_desync, confidence, resolver_method
end

local function update_player_history(player, player_data)
    local entity_ptr = get_client_entity(entity_list_ptr, player)
    if not entity_ptr then return end

    local pitch = entity.get_prop(player, "m_angEyeAngles[0]") or 0
    local yaw = entity.get_prop(player, "m_angEyeAngles[1]") or 0
    
    if pitch and yaw then
        table.insert(player_data.eye_angles_history, 1, {x = pitch, y = yaw})
        if #player_data.eye_angles_history > RESOLVER_CONST.MAX_HISTORY_SIZE then
            table.remove(player_data.eye_angles_history)
        end
    end
    
    local sim_time = entity.get_prop(player, "m_flSimulationTime")
    if sim_time then
        table.insert(player_data.simulation_time_history, 1, sim_time)
        
        if #player_data.simulation_time_history > 16 then
            table.remove(player_data.simulation_time_history)
        end
    end
    
    local origin = vec_util.get_origin(player)
    table.insert(player_data.position_history, 1, origin)
    
    if #player_data.position_history > 16 then
        table.remove(player_data.position_history)
    end
    
    local layers = get_all_anim_layers(entity_ptr)
    if next(layers) then
        table.insert(player_data.animation_layers_history, 1, layers)
        
        if #player_data.animation_layers_history > 8 then
            table.remove(player_data.animation_layers_history)
        end
    end
    
    player_data.current_state = state_util.get_state(player)
    player_data.max_desync_delta = calculate_max_desync(player, player_data.current_state)
    player_data.is_breaking_lc = state_util.is_breaking_lc(player, player_data)
    player_data.defensive_triggered = detect_defensive_aa(player, player_data)
    
    player_data.last_tickcount = globals.tickcount()
end

local function resolver_update()
    if not ui.get(menu.custom.enable) then return end
    
    local players = entity.get_players(true)
    
    for _, player in ipairs(players) do
        if not entity.is_alive(player) then goto continue end
        
        update_player_history(player, player_data[player])
        
        local is_manual_override = ui.get(menu.custom.manual_override) and entity.is_dormant(player) == false
        
        local side, desync, confidence, method = resolve_player_angle(player, player_data[player], is_manual_override)

        player_data[player].side = side
        player_data[player].desync = desync
        player_data[player].last_resolving_method = method
        player_data[player].last_update = globals.curtime()
        
        plist.set(player, "Force Body Yaw", true)
        
        if side == 1 then
            plist.set(player, "Force Body Yaw Value", desync)  -- Right
        elseif side == 2 then
            plist.set(player, "Force Body Yaw Value", -desync)  -- Left
        else
            plist.set(player, "Force Body Yaw Value", 0)  -- Center
        end
        
        if player_data[player].defensive_triggered then
            local player_pitch = entity.get_prop(player, "m_angEyeAngles[0]") or 0
            
            if player_pitch < -80 then  -- Extremely low pitch, likely defensive
                plist.set(player, "Force Pitch", true)
                plist.set(player, "Force Pitch Value", player_data[player].last_pitch or 0)
            else
                plist.set(player, "Force Pitch", false)
                player_data[player].last_pitch = player_pitch
            end
        else
            plist.set(player, "Force Pitch", false)
        end
        
        ::continue::
    end
end

local function on_paint()
    if not ui.get(menu.custom.enable) then return end
    
    local debug_options = ui.get(menu.custom.debug)
    local show_indicators = contains(debug_options, "Indicators")
    local show_skeleton = contains(debug_options, "Skeleton")
    local show_statistics = contains(debug_options, "Statistics")
    
    if not show_indicators and not show_skeleton and not show_statistics then return end
    
    local local_player = entity.get_local_player()
    if not local_player then return end
    
    local players = entity.get_players(true)
    local screen_w, screen_h = client.screen_size()
    
    if show_indicators then
        local y_offset = screen_h * 0.4
        local text = "Angel Resolver"
        local hit_rate = resolver_stats.total_hits / math.max(resolver_stats.total_hits + resolver_stats.total_misses, 1)
        
        for i = 1, #text do
            local char = text:sub(i, i)
            local alpha = 255 - (i * 12)
            if alpha < 0 then alpha = 0 end
            
            renderer.text(screen_w * 0.01 + (i-1)*8, y_offset, ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, alpha, "-", 0, char)
        end
        
        y_offset = y_offset + 25
        
        local hit_color = hit_rate > 0.6 and ui_colors.success or ui_colors.warning
        
        renderer.text(screen_w * 0.01, y_offset, hit_color.r, hit_color.g, hit_color.b, hit_color.a, "", 0, string.format("Hit Rate: %d%% (%d hits, %d misses)", math.floor(hit_rate * 100), resolver_stats.total_hits, resolver_stats.total_misses))
        y_offset = y_offset + 20
        
        renderer.text(screen_w * 0.01, y_offset, ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, ui_colors.accent.a, "", 0, "Resolved Players:")
        y_offset = y_offset + 20
        
        local displayed = 0
        for _, player in ipairs(players) do
            if not entity.is_alive(player) or displayed >= 5 then goto next_player end
            
            local p_data = player_data[player]
            if p_data and p_data.last_update > 0 and globals.curtime() - p_data.last_update < 5 then
                local name = entity.get_player_name(player)
                local side_text = p_data.side == 1 and "Right" or (p_data.side == 2 and "Left" or "Center")
                local method_text = p_data.last_resolving_method or "unknown"
                
                local method_color = method_text == "brute" and ui_colors.warning or (method_text == "defensive" and ui_colors.highlight or ui_colors.neutral)
                
                renderer.text(screen_w * 0.01, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, string.format("%s: %s (%.1f°) [%s]", name:sub(1, 12), side_text, p_data.desync, method_text))
                
                y_offset = y_offset + 15
                displayed = displayed + 1
            end
            
            ::next_player::
        end
    end
    
    if show_statistics then
        local x_offset = screen_w * 0.8
        local y_offset = screen_h * 0.3
        
        renderer.rectangle(x_offset - 10, y_offset - 10, 220, 285, 10, 10, 10, 200)
        
        renderer.text(x_offset, y_offset, ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, ui_colors.accent.a, "", 0, "Angel Statistics")
        y_offset = y_offset + 30
        
        renderer.text(x_offset, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, "Resolver Performance:")
        y_offset = y_offset + 20
        
        local total_shots = resolver_stats.total_hits + resolver_stats.total_misses
        local accuracy = total_shots > 0 and (resolver_stats.total_hits / total_shots) * 100 or 0
        
        renderer.text(x_offset, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, string.format("Accuracy: %.1f%% (%d hits, %d misses)", accuracy, resolver_stats.total_hits, resolver_stats.total_misses))
        y_offset = y_offset + 20
        
        renderer.text(x_offset, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, "Method Success Rates:")
        y_offset = y_offset + 20
        
        local methods = {"animation", "matrix", "brute", "adaptive", "maximum"}
        for _, method in ipairs(methods) do
            local hits = resolver_stats.hits_by_method[method] or 0
            local misses = resolver_stats.misses_by_method[method] or 0
            local total = hits + misses
            local rate = total > 0 and (hits / total) * 100 or 0
            
            local method_color = rate > 70 and ui_colors.success or (rate > 40 and ui_colors.neutral or ui_colors.warning)
            
            renderer.text(x_offset, y_offset, method_color.r, method_color.g, method_color.b, method_color.a, "", 0, string.format("%s: %.1f%%", method:sub(1,1):upper() .. method:sub(2), rate))
            y_offset = y_offset + 15
        end
        
        y_offset = y_offset + 10
        renderer.text(x_offset, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, "Miss Reasons:")
        y_offset = y_offset + 20
        
        local reasons = {"spread", "prediction", "lagcomp", "correction", "unknown"}
        for _, reason in ipairs(reasons) do
            local count = resolver_stats.misses_by_reason[reason] or 0
            local percent = total_shots > 0 and (count / total_shots) * 100 or 0
            
            renderer.text(x_offset, y_offset, ui_colors.neutral.r, ui_colors.neutral.g, ui_colors.neutral.b, ui_colors.neutral.a, "", 0, string.format("%s: %d (%.1f%%)", reason:sub(1,1):upper() .. reason:sub(2), count, percent))
            y_offset = y_offset + 15
        end
    end
    
    if show_skeleton then
        for _, player in ipairs(players) do
            if not entity.is_alive(player) or entity.is_dormant(player) then goto next_skeleton end
            
            local p_data = player_data[player]
            if not p_data or not p_data.side then goto next_skeleton end
            
            local function get_bone_position(player, bone)
                local x, y, z = entity.get_prop(player, "m_vecOrigin")
                if not x then return nil end
                
                local bx, by, bz = entity.hitbox_position(player, bone)
                if not bx then return nil end
                
                return bx, by, bz
            end
            
            local color = p_data.side == 1 and {r = 255, g = 100, b = 100, a = 200} or (p_data.side == 2 and {r = 100, g = 100, b = 255, a = 200} or {r = 200, g = 200, b = 200, a = 200})
            
            local head_x, head_y, head_z = get_bone_position(player, 8)  -- Head bone
            local spine_x, spine_y, spine_z = get_bone_position(player, 6)  -- Spine bone
            local pelvis_x, pelvis_y, pelvis_z = get_bone_position(player, 0)  -- Pelvis bone
            
            if head_x and spine_x and pelvis_x then
                local head_sx, head_sy = client.world_to_screen(head_x, head_y, head_z)
                local spine_sx, spine_sy = client.world_to_screen(spine_x, spine_y, spine_z)
                local pelvis_sx, pelvis_sy = client.world_to_screen(pelvis_x, pelvis_y, pelvis_z)
                
                if head_sx and spine_sx and pelvis_sx then
                    renderer.line(head_sx, head_sy, spine_sx, spine_sy, color.r, color.g, color.b, color.a)
                    renderer.line(spine_sx, spine_sy, pelvis_sx, pelvis_sy, color.r, color.g, color.b, color.a)
                    
                    local yaw = entity.get_prop(player, "m_angEyeAngles[1]") or 0
                    local resolved_yaw = yaw
                    
                    if p_data.side == 1 then
                        resolved_yaw = yaw - p_data.desync
                    elseif p_data.side == 2 then
                        resolved_yaw = yaw + p_data.desync
                    end
                    
                    local rad_yaw = math.rad(resolved_yaw)
                    local dir_x = math.cos(rad_yaw) * 20
                    local dir_y = math.sin(rad_yaw) * 20
                    
                    local end_x, end_y, end_z = head_x + dir_x, head_y + dir_y, head_z
                    local end_sx, end_sy = client.world_to_screen(end_x, end_y, end_z)
                    
                    if end_sx then
                        renderer.line(head_sx, head_sy, end_sx, end_sy, 255, 255, 0, 255)
                    end
                end
            end
            
            ::next_skeleton::
        end
    end
end

-- This file was sold by https://discord.gg/kqdKMEbXG7 author angel.

local function analyze_miss_reason(e)
    local reason = e.reason
    local target = e.target
    
    if not player_data[target] then return "unknown" end
    
    if reason == "?" then
        local target_data = player_data[target]
        
        if target_data.is_breaking_lc then
            resolver_stats.misses_by_reason.lagcomp = resolver_stats.misses_by_reason.lagcomp + 1
            return "lagcomp"
        end
        
        if target_data.defensive_triggered then
            resolver_stats.misses_by_reason.correction = resolver_stats.misses_by_reason.correction + 1
            return "defensive"
        end
        
        if math.abs(target_data.desync - RESOLVER_CONST.MAX_DESYNC_DELTA) > 10 then
            resolver_stats.misses_by_reason.prediction = resolver_stats.misses_by_reason.prediction + 1
            return "prediction"
        end
        
        resolver_stats.misses_by_reason.spread = resolver_stats.misses_by_reason.spread + 1
        return "spread"
    else
        if reason == "spread" then
            resolver_stats.misses_by_reason.spread = resolver_stats.misses_by_reason.spread + 1
        elseif reason == "prediction error" then
            resolver_stats.misses_by_reason.prediction = resolver_stats.misses_by_reason.prediction + 1
        else
            resolver_stats.misses_by_reason.unknown = resolver_stats.misses_by_reason.unknown + 1
        end
        
        return reason
    end
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

client.set_event_callback('aim_hit', function(e)
    if not ui.get(menu.custom.enable) then return end
    
    local player = e.target
    if not player_data[player] then return end
    
    local debug_logs = contains(ui.get(menu.custom.debug), "Console Logs")
    local p_data = player_data[player]
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    local method = p_data.last_resolving_method or "unknown"
    
    p_data.shots_hit = p_data.shots_hit + 1
    p_data.shots_fired = p_data.shots_fired + 1
    p_data.last_hit_side = p_data.side
    p_data.last_hit_time = globals.curtime()
    p_data.miss_count = 0
    
    resolver_stats.total_hits = resolver_stats.total_hits + 1
    
    if resolver_stats.hits_by_method[method] then
        resolver_stats.hits_by_method[method] = resolver_stats.hits_by_method[method] + 1
    end
    
    if debug_logs then
        client.color_log(ui_colors.success.r, ui_colors.success.g, ui_colors.success.b,
            string.format('[Angel] Hit %s in the %s for %d damage (%d health remaining) (Side: %s | Desync: %.1f° | Method: %s)',
            entity.get_player_name(player),
            group,
            e.damage,
            entity.get_prop(player, 'm_iHealth'),
            p_data.side == 1 and "Right" or (p_data.side == 2 and "Left" or "Center"),
            p_data.desync,
            method
        ))
    end
end)

client.set_event_callback('aim_miss', function(e)
    if not ui.get(menu.custom.enable) then return end
    
    local player = e.target
    if not player_data[player] then return end
    
    local debug_logs = contains(ui.get(menu.custom.debug), "Console Logs")
    local p_data = player_data[player]
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    local method = p_data.last_resolving_method or "unknown"
    
    local detailed_reason = analyze_miss_reason(e)
    
    p_data.shots_missed = p_data.shots_missed + 1
    p_data.shots_fired = p_data.shots_fired + 1
    p_data.miss_count = p_data.miss_count + 1
    p_data.last_miss_side = p_data.side
    p_data.last_miss_time = globals.curtime()
    p_data.last_missed_reason = detailed_reason
    
    resolver_stats.total_misses = resolver_stats.total_misses + 1
    
    if resolver_stats.misses_by_method[method] then
        resolver_stats.misses_by_method[method] = resolver_stats.misses_by_method[method] + 1
    end
    
    if debug_logs then
        client.color_log(ui_colors.warning.r, ui_colors.warning.g, ui_colors.warning.b,
            string.format('[Angel] Missed %s (%s) due to %s | Detailed: %s (Side: %s | Desync: %.1f° | Method: %s)',
            entity.get_player_name(player),
            group,
            e.reason,
            detailed_reason,
            p_data.side == 1 and "Right" or (p_data.side == 2 and "Left" or "Center"),
            p_data.desync,
            method
        ))
    end
end)

client.register_esp_flag("Right", ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, function(player)
    if not ui.get(menu.custom.enable) or not contains(ui.get(menu.custom.debug), "ESP Flags") then
        return false
    end
    
    return player_data[player] and player_data[player].side == 1
end)

client.register_esp_flag("Left", ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, function(player)
    if not ui.get(menu.custom.enable) or not contains(ui.get(menu.custom.debug), "ESP Flags") then
        return false
    end
    
    return player_data[player] and player_data[player].side == 2
end)

client.register_esp_flag("Defensive", ui_colors.warning.r, ui_colors.warning.g, ui_colors.warning.b, function(player)
    if not ui.get(menu.custom.enable) or not contains(ui.get(menu.custom.debug), "ESP Flags") then
        return false
    end
    
    return player_data[player] and player_data[player].defensive_triggered
end)

client.register_esp_flag("L+C", ui_colors.warning.r, ui_colors.warning.g, ui_colors.warning.b, function(player)
    if not ui.get(menu.custom.enable) or not contains(ui.get(menu.custom.debug), "ESP Flags") then
        return false
    end
    
    return player_data[player] and player_data[player].is_breaking_lc
end)

client.set_event_callback("net_update_end", resolver_update)
client.set_event_callback("paint", on_paint)

client.set_event_callback('shutdown', function()
    ui.set_visible(menu.refs.force_body_yaw, true)
    ui.set_visible(menu.refs.correction_active, true)
    ui.set(menu.refs.reset_all, true)
end)

client.color_log(ui_colors.highlight.r, ui_colors.highlight.g, ui_colors.highlight.b, "[Angel] Configuration available in RAGE > Other tab")
client.color_log(ui_colors.highlight.r, ui_colors.highlight.g, ui_colors.highlight.b, "[Angel] Recoded by Angel - The most resolver available")

local function report_statistics()
    if ui.get(menu.custom.enable) then
        local hit_rate = resolver_stats.total_hits / math.max(resolver_stats.total_hits + resolver_stats.total_misses, 1)
        
        client.color_log(ui_colors.accent.r, ui_colors.accent.g, ui_colors.accent.b, string.format("[Angel] Performance Report - Accuracy: %.1f%% (%d hits, %d misses)", hit_rate * 100, resolver_stats.total_hits, resolver_stats.total_misses))
        
        local best_method = "none"
        local best_accuracy = 0
        
        for method, hits in pairs(resolver_stats.hits_by_method) do
            local misses = resolver_stats.misses_by_method[method] or 0
            local total = hits + misses
            local accuracy = total > 0 and hits / total or 0
            
            if accuracy > best_accuracy and total > 5 then
                best_accuracy = accuracy
                best_method = method
            end
        end
        
        if best_method ~= "none" then
            client.color_log(ui_colors.success.r, ui_colors.success.g, ui_colors.success.b, string.format("[Angel] Most effective method: %s (%.1f%% accuracy)", best_method, best_accuracy * 100))
        end
    end
    
    client.delay_call(300, report_statistics)
end

client.set_event_callback("paint_ui", function()
    local time = globals.realtime() * 2
    local fade_text = fade_label(time, "Angel Resolver", 159, 202, 11, 255)
    ui.set(menu.custom.header, fade_text)
end)

client.delay_call(300, report_statistics)