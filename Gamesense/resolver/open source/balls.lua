local function on_paint()
    local me = entity.get_local_player()
    if not me then return end

    local rr, gg, bb = 87, 235, 61
    local width, height = client.screen_size()
    local r2, g2, b2, a2 = 55, 55, 55, 255
    local highlight_fraction = (globals.realtime() / 2 % 1.2 * 2) - 1.2
    local output = ""
    local text_to_draw = "balls resolver"

    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw
        local r1, g1, b1, a1 = 255, 255, 255, 255
        local highlight_delta = character_fraction - highlight_fraction

        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction = r2 - r1, g2 - g1, b2 - b1
            r1 = r1 + r_fraction * highlight_delta / 0.8
            g1 = g1 + g_fraction * highlight_delta / 0.8
            b1 = b1 + b_fraction * highlight_delta / 0.8
        end

        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, 255, character)
    end

    renderer.text(width - (width - 70), height - 555, rr, gg, bb, 255, "c", 0, output .. ' \afa5757FF[V3.0]')
end

client.set_event_callback("paint", on_paint)

local client_latency, client_screen_size, client_set_event_callback, client_system_time, entity_get_local_player, entity_get_player_resource, entity_get_prop, globals_absoluteframetime, globals_tickinterval, math_ceil, math_floor, math_min, math_sqrt, renderer_measure_text, ui_reference, pcall, renderer_gradient, renderer_rectangle, renderer_text, string_format, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_multiselect, ui_new_textbox, ui_set, ui_set_callback, ui_set_visible = client.latency, client.screen_size, client.set_event_callback, client.system_time, entity.get_local_player, entity.get_player_resource, entity.get_prop, globals.absoluteframetime, globals.tickinterval, math.ceil, math.floor, math.min, math.sqrt, renderer.measure_text, ui.reference, pcall, renderer.gradient, renderer.rectangle, renderer.text, string.format, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_multiselect, ui.new_textbox, ui.set, ui.set_callback, ui.set_visible

local ffi = require 'ffi'

ffi.cdef[[
    struct c_animstate {
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
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[4]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[60]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[462]; //0x162
        float m_flMaxYaw; //0x334
        float velocity_subtract_x; //0x330
        float velocity_subtract_y; //0x334
        float velocity_subtract_z; //0x338
    };

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float m_anim_time;
        float m_fade_out_time;
        int m_flags;
        int m_activity;
        int m_priority;
        int m_order;
        int m_sequence;
        float m_prev_cycle;
        float m_weight;
        float m_weight_delta_rate;
        float m_playback_rate;
        float m_cycle;
        void* m_owner;
        int m_bits;
    } C_AnimationLayer;

    typedef uintptr_t(__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

ffi.cdef[[
    typedef struct MaterialAdapterInfo_tt
    {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
    };

    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapter_info_fn)(void*, int adapter, struct MaterialAdapterInfo_tt& info);
]]


local ui_resolver = ui.new_checkbox("Rage", "Other", "+/- \aFF0000FFballs RESOLVER BY\aFFFFFFFF luckybrev")


math.clamp = function(value, min, max)
    return value < min and min or (value > max and max or value)
end


math.vec_length2d = function(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end


math.vec_length3d = function(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
end


math.dot2d = function(vec1, vec2)
    return vec1.x * vec2.x + vec1.y * vec2.y
end


math.dot3d = function(vec1, vec2)
    return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
end


math.cross3d = function(vec1, vec2)
    return {
        x = vec1.y * vec2.z - vec1.z * vec2.y,
        y = vec1.z * vec2.x - vec1.x * vec2.z,
        z = vec1.x * vec2.y - vec1.y * vec2.x
    }
end


math.angle_normalize = function(angle)
    return (angle % 360 + 360) % 360
end


math.angle_diff = function(dest, src)
    local delta = (dest - src + 540) % 360 - 180
    return delta
end


math.approach_angle = function(target, value, speed)
    target = math.angle_normalize(target)
    value = math.angle_normalize(value)

    local delta = math.angle_diff(target, value)
    speed = math.abs(speed)

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return math.angle_normalize(value)
end


math.lerp = function(a, b, t)
    return a + (b - a) * t
end


math.inv_lerp = function(a, b, value)
    return (value - a) / (b - a)
end


math.remap = function(value, in_min, in_max, out_min, out_max)
    return out_min + (value - in_min) * (out_max - out_min) / (in_max - in_min)
end


math.distance2d = function(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    return math.sqrt(dx * dx + dy * dy)
end


math.distance3d = function(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    local dz = point2.z - point1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end


math.midpoint2d = function(point1, point2)
    return {
        x = (point1.x + point2.x) * 0.5,
        y = (point1.y + point2.y) * 0.5
    }
end


math.midpoint3d = function(point1, point2)
    return {
        x = (point1.x + point2.x) * 0.5,
        y = (point1.y + point2.y) * 0.5,
        z = (point1.z + point2.z) * 0.5
    }
end


math.angle_between2d = function(vec1, vec2)
    local dot = math.dot2d(vec1, vec2)
    local len1 = math.vec_length2d(vec1)
    local len2 = math.vec_length2d(vec2)
    return math.acos(dot / (len1 * len2))
end


math.angle_between3d = function(vec1, vec2)
    local dot = math.dot3d(vec1, vec2)
    local len1 = math.vec_length3d(vec1)
    local len2 = math.vec_length3d(vec2)
    return math.acos(dot / (len1 * len2))
end


math.point_in_bbox2d = function(point, bbox_min, bbox_max)
    return point.x >= bbox_min.x and point.x <= bbox_max.x and
           point.y >= bbox_min.y and point.y <= bbox_max.y
end


math.point_in_bbox3d = function(point, bbox_min, bbox_max)
    return point.x >= bbox_min.x and point.x <= bbox_max.x and
           point.y >= bbox_min.y and point.y <= bbox_max.y and
           point.z >= bbox_min.z and point.z <= bbox_max.z
end


math.signed_area_triangle2d = function(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end


math.point_in_triangle2d = function(point, a, b, c)
    local d1 = math.signed_area_triangle2d(point, a, b)
    local d2 = math.signed_area_triangle2d(point, b, c)
    local d3 = math.signed_area_triangle2d(point, c, a)

    local has_neg = d1 < 0 or d2 < 0 or d3 < 0
    local has_pos = d1 > 0 or d2 > 0 or d3 > 0

    return not (has_neg and has_pos)
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasn't found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)


entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {x = v1, y = v2, z = v3}
end

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end


local resolver = {
    layers = {},
    prediction_time = 0.3,
    smoothing_factor = 0.1,
    max_prediction_time = 0.5,
    min_prediction_time = 0.1,
    history = {},
    max_history_size = 10
}

resolver.m_flMaxDelta = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return 0 end

    local speedfactor = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (animstate.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = animstate.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity
        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor * animstate.m_flMaxYaw
end

resolver.update_layers = function(idx)
    local layers = entity.get_animlayer(idx)
    if not layers then return end
    if not resolver.layers[idx] then
        resolver.layers[idx] = {}
    end

    for i = 0, 13 do
        local layer = layers[i]
        if not resolver.layers[idx][i] then
            resolver.layers[idx][i] = {}
        end

        resolver.layers[idx][i].m_cycle = layer.m_cycle
        resolver.layers[idx][i].m_playback_rate = layer.m_playback_rate
        resolver.layers[idx][i].m_weight = layer.m_weight
        resolver.layers[idx][i].m_weight_delta_rate = layer.m_weight_delta_rate
    end
end

resolver.get_layers = function(idx)
    return resolver.layers[idx] or {}
end

resolver.predict_position = function(idx)
    local animstate = entity.get_animstate(idx)
    if not animstate then return end

    local velocity = entity.get_vector_prop(idx, "m_vecVelocity")
    local origin = entity.get_vector_prop(idx, "m_vecOrigin")

    
    local speed = math.vec_length2d(velocity)
    local acceleration = math.vec_length2d({x = animstate.velocity_subtract_x, y = animstate.velocity_subtract_y, z = animstate.velocity_subtract_z})
    local dynamic_prediction_time = math.clamp(resolver.prediction_time, resolver.min_prediction_time, resolver.max_prediction_time)
    dynamic_prediction_time = dynamic_prediction_time * (speed / 100) * (1 + acceleration / 1000)

    
    local future_position = {
        x = origin.x + velocity.x * dynamic_prediction_time,
        y = origin.y + velocity.y * dynamic_prediction_time,
        z = origin.z + velocity.z * dynamic_prediction_time
    }

    future_position.x = future_position.x + 0.5 * animstate.velocity_subtract_x * dynamic_prediction_time^2
    future_position.y = future_position.y + 0.5 * animstate.velocity_subtract_y * dynamic_prediction_time^2
    future_position.z = future_position.z + 0.5 * animstate.velocity_subtract_z * dynamic_prediction_time^2

   
    if not resolver.history[idx] then
        resolver.history[idx] = {}
    end
    table.insert(resolver.history[idx], {position = future_position, time = globals.curtime()})
    if #resolver.history[idx] > resolver.max_history_size then
        table.remove(resolver.history[idx], 1)
    end

    return future_position
end

resolver.predict_yaw = function(idx, current_yaw)
    local animstate = entity.get_animstate(idx)
    if not animstate then return current_yaw end

    local velocity = entity.get_vector_prop(idx, "m_vecVelocity")
    local speed = math.vec_length2d(velocity)

    
    local acceleration = math.vec_length2d({x = animstate.velocity_subtract_x, y = animstate.velocity_subtract_y, z = animstate.velocity_subtract_z})
    local dynamic_prediction_time = math.clamp(resolver.prediction_time, resolver.min_prediction_time, resolver.max_prediction_time)
    dynamic_prediction_time = dynamic_prediction_time * (speed / 100) * (1 + acceleration / 1000)

    
    local predicted_yaw = animstate.m_flGoalFeetYaw + (animstate.m_flFeetYawRate * dynamic_prediction_time)

    
    local delta = math.abs(predicted_yaw - current_yaw)
    local smoothing_factor = resolver.smoothing_factor * (1 + speed / 300) * (1 + delta / 180)
    local smoothed_yaw = math.angle_normalize(current_yaw + (predicted_yaw - current_yaw) * smoothing_factor)

    return smoothed_yaw
end


client.set_event_callback("net_update_end", function()
    local players = entity.get_players(true)
    if not players then return end

    for i = 1, #players do
        local ent = players[i]
        resolver.update_layers(ent)
    end
end)

local function find_layer(ent, act)
    local layers = entity.get_animlayer(ent)
    if not layers then return -1 end

    for i = 0, 13 do
        local layer = layers[i]
        if layer.m_activity == act then
            return i
        end
    end
    return -1
end

client.set_event_callback("paint", function()
    if not ui.get(ui_resolver) then return end

    local players = entity.get_players(true)
    for i = 1, #players do
        local ent = players[i]

        local lay = find_layer(ent, 1)
        if lay == -1 then goto skip end

        local animstate = entity.get_animstate(ent)
        if not animstate then return end

        local max_delta = resolver.m_flMaxDelta(ent)
        local delta = entity.get_prop(ent, "m_angEyeAngles[1]")
        local speed = entity.get_prop(ent, "m_vecVelocity[0]")

        delta = math.angle_diff(delta, 0)
        local feet_yaw = max_delta

        local clamped_delta = math.clamp(delta, -feet_yaw, feet_yaw)
        local ang = entity.get_prop(ent, "m_angEyeAngles[1]") + clamped_delta

        local predicted_yaw = resolver.predict_yaw(ent, animstate.m_flGoalFeetYaw)
        local approach_delta = math.approach_angle(predicted_yaw, ang, math.max(0.1, math.abs(predicted_yaw - ang) / 10))
        animstate.m_flGoalFeetYaw = approach_delta

        if speed <= 0.1 then
            animstate.m_flGoalFeetYaw = ang
        end

        ::skip::
    end
end)