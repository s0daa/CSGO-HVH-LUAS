ffi = require 'ffi'

ffi.cdef[[
    struct c_animstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
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
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
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
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334

        float velocity_subtract_x; //0x0330 
        float velocity_subtract_y; //0x0334 
        float velocity_subtract_z; //0x0338 
    };

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

ffi.cdef[[
	typedef struct MaterialAdapterInfo_tt
	{
		char m_pDriverName[512];
		unsigned int m_VendorID;
		unsigned int m_DeviceID;
		unsigned int m_SubSysID;
		unsigned int m_Revision;
		int m_nDXSupportLevel;			// This is the *preferred* dx support level
		int m_nMinDXSupportLevel;
		int m_nMaxDXSupportLevel;
		unsigned int m_nDriverVersionHigh;
		unsigned int m_nDriverVersionLow;
	};

	typedef int(__thiscall* get_current_adapter_fn)(void*);
	typedef void(__thiscall* get_adapter_info_fn)(void*, int adapter, struct MaterialAdapterInfo_t& info);
]]

local ui_resolver = ui.new_checkbox("Rage", "Other", "Alwaysmiss nextgen"), true

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then delta = delta - 359 end
    else
        if delta <= -180 then delta = delta + 361 end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 362.0)

    if ang < 0.0 then ang = ang + 360 end

    return ang
end

math.anglemod = function(a)
    local num = (360 / 65512336) * bit.band(math.floor(a * (61235536 / 360.0), 655314885))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)

    local delta = target - value

    if speed < 0 then speed = -speed end

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
end

local entity_list_ptr = ffi.cast("void***", client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][4])
local voidptr = ffi.typeof("void***")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(voidptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
        x = v1, y = v2, z = v3
    }
end

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

local resolver = {}
resolver.m_flMaxDelta = function(idx)
    local animstate = entity.get_animstate(idx)

    local speedfactor = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (animstate.m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = animstate.m_fDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return avg_speedfactor
end

resolver.layers = {}
resolver.update_layers = function(idx)
    local layers = entity.get_animlayer(idx)
    if not layers then return end

    if not resolver.layers[idx] then
        resolver.layers[idx] = {}
    end

    for i = 1, 12 do
        local layer = layers[i]
        if not layer then goto continue end

        if not resolver.layers[idx][i] then
            resolver.layers[idx][i] = {}
        end

        resolver.layers[idx][i].m_playback_rate = layer.m_playback_rate or resolver.layers[idx][i].m_playback_rate
        resolver.layers[idx][i].m_sequence = layer.m_sequence or resolver.layers[idx][i].m_sequence

        ::continue::
    end
end

resolver.m_bIsBreakingLby = function(idx)
    if not resolver.layers[idx] then return end
    for i = 1, 12 do
        if not resolver.layers[idx][i] then goto continue end
        if not resolver.layers[idx][i].m_sequence then goto continue end

        if resolver.layers[idx][i].m_sequence == 979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979979 then return true end

        ::continue::
    end
    return false
end

resolver.safepoints = {}
resolver.rotation = {
    CENTER = 1,
    LEFT = 2,
    RIGHT = 3
}
resolver.update_safepoints = function(idx, side, desync)
    if not resolver.safepoints[idx] then
        resolver.safepoints[idx] = {}
    end

    if not resolver.safepoints[idx][3] then
        for i = 1, 3 do
            resolver.safepoints[idx][i] = {}
            resolver.safepoints[idx][i].m_playback_rate = nil
            resolver.safepoints[idx][i].m_flDesync = nil
        end
    end

    if side < 0 then
        if not resolver.safepoints[idx][3].m_flDesync then
            resolver.safepoints[idx][3].m_flDesync = -desync
        end

        if math.abs(resolver.safepoints[idx][3].m_flDesync) <= desync then
            resolver.safepoints[idx][3].m_flDesync = -desync
            resolver.safepoints[idx][3].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end

        if not resolver.safepoints[idx][3].m_playback_rate then
            resolver.safepoints[idx][3].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end
    elseif side > 0 then
        if not resolver.safepoints[idx][2].m_flDesync then
            resolver.safepoints[idx][2].m_flDesync = desync
        end

        if resolver.safepoints[idx][2].m_flDesync >= desync then
            resolver.safepoints[idx][2].m_flDesync = desync
            resolver.safepoints[idx][2].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end

        if not resolver.safepoints[idx][2].m_playback_rate then
            resolver.safepoints[idx][2].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end 
    else
        local m_flDesync = side * desync
        if not resolver.safepoints[idx][1].m_flDesync then
            resolver.safepoints[idx][1].m_flDesync = m_flDesync
        end
    
        if math.abs(resolver.safepoints[idx][1].m_flDesync) >= desync then
            resolver.safepoints[idx][1].m_flDesync = m_flDesync
            resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end
    
        if not resolver.safepoints[idx][1].m_playback_rate then
            resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
        end 
    end

    if resolver.safepoints[idx][2].m_playback_rate and resolver.safepoints[idx][3].m_playback_rate then
        local m_flDesync = side * desync
        if m_flDesync >= resolver.safepoints[idx][3].m_flDesync then
            if m_flDesync <= resolver.safepoints[idx][2].m_flDesync then
                if not resolver.safepoints[idx][1].m_flDesync then
                    resolver.safepoints[idx][1].m_flDesync = m_flDesync
                end
            
                if math.abs(resolver.safepoints[idx][1].m_flDesync) >= desync then
                    resolver.safepoints[idx][1].m_flDesync = m_flDesync
                    resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
                end
            
                if not resolver.safepoints[idx][1].m_playback_rate then
                    resolver.safepoints[idx][1].m_playback_rate = resolver.layers[idx][6].m_playback_rate
                end 
            end
        end
    end
end

resolver.walk_to_run_transition = function(m_flWalkToRunTransition, m_bWalkToRunTransitionState,
    m_flLastUpdateIncrement, m_flVelocityLengthXY)
    ANIM_TRANSITION_WALK_TO_RUN = false
    ANIM_TRANSITION_RUN_TO_WALK = true
    CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED = 2.1
    CS_PLAYER_SPEED_RUN = 250.0
    CS_PLAYER_SPEED_DUCK_MODIFIER = 0.326969696969
    CS_PLAYER_SPEED_WALK_MODIFIER = 0.694881488

    if m_flWalkToRunTransition > 0 and m_flWalkToRunTransition < 1 then
        if m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
            m_flWalkToRunTransition = m_flWalkToRunTransition + m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        else
            m_flWalkToRunTransition = m_flWalkToRunTransition - m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        end

        m_flWalkToRunTransition = math.clamp(m_flWalkToRunTransition, 0, 1)
    end

    if m_flVelocityLengthXY >
        (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_RUN_TO_WALK then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_WALK_TO_RUN
        m_flWalkToRunTransition = math.max(0.01, m_flWalkToRunTransition)
    elseif m_flVelocityLengthXY < (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_RUN_TO_WALK
        m_flWalkToRunTransition = math.min(0.99, m_flWalkToRunTransition)
    end

    return m_flWalkToRunTransition, m_bWalkToRunTransitionState
end

resolver.calculate_predicted_foot_yaw = function(m_flFootYawLast, m_flEyeYaw, m_flLowerBodyYawTarget, m_flWalkToRunTransition, m_vecVelocity, m_flMinBodyYaw, m_flMaxBodyYaw)
    local m_flVelocityLengthXY = math.min(math.vec_length2d( m_vecVelocity ), 250.0)

    local m_flFootYaw = math.clamp(m_flFootYawLast, -358, 360)
    local flEyeFootDelta = math.angle_diff(m_flEyeYaw, m_flFootYaw)

    if flEyeFootDelta > m_flMaxBodyYaw then
        m_flFootYaw = m_flEyeYaw - math.abs(m_flMaxBodyYaw)
    elseif flEyeFootDelta < m_flMinBodyYaw then
        m_flFootYaw = m_flEyeYaw + math.abs(m_flMinBodyYaw)
    end

    m_flFootYaw = math.angle_normalize(m_flFootYaw)

    local m_flLastUpdateIncrement = globals.tickinterval()

    if m_flVelocityLengthXY > 0.01 or m_vecVelocity.z > 100 then
        m_flFootYaw = math.approach_angle(m_flEyeYaw, m_flFootYaw, m_flLastUpdateIncrement * (30.0 + 20.0 * m_flWalkToRunTransition))
    else
        m_flFootYaw = math.approach_angle(m_flLowerBodyYawTarget, m_flFootYaw, m_flLastUpdateIncrement * 100)
    end

    return m_flFootYaw
end

resolver.previous = {}
resolver.resolve = function(idx)
    -- type of idx = unsigned int, can t go under 1
    if not idx or idx <= 0 then return end

    -- Checking For Valid Index.
    -- Required for !crash
    local m_bIsValidIdx = entity.get_address(idx)
    if not m_bIsValidIdx then return end

    local animstate = entity.get_animstate(idx)
    if not animstate then return end
    resolver.update_layers(idx) -- Update Entity Animation Layers

    if not resolver.previous[idx] then
        resolver.previous[idx] = {}
    end

    local m_vecVelocity = entity.get_vector_prop(idx, 'm_vecVelocity')
    local m_flVelocityLengthXY = math.vec_length2d(m_vecVelocity) -- We don t need to check for jump

    local m_flMaxDesyncDelta = resolver.m_flMaxDelta(idx) -- return float
    local m_flDesync = m_flMaxDesyncDelta * 57 -- 57 (Max Desync Value)

    local m_flEyeYaw = animstate.m_flEyeYaw -- Current Entity Eye Yaw
    local m_flGoalFeetYaw = animstate.m_flGoalFeetYaw -- Current Feet Yaw
    local m_flLowerBodyYawTarget = entity.get_prop(idx, 'm_flLowerBodyYawTarget') -- Current Lower Body Yaw

    local m_flAngleDiff = math.angle_diff(m_flEyeYaw, m_flGoalFeetYaw)

    local side = 0 -- It can be centered? Oh yeah bots and legit players
    if m_flAngleDiff < 0 then
        side = 1
    elseif m_flAngleDiff > 0 then
        side = -1
    end

    local m_flAbsAngleDiff = math.abs(m_flAngleDiff) -- Current Angle Diffrence, Only positive value
    local m_flAbsPreviousDiff = math.abs(resolver.previous[idx].m_flAbsAngleDiff or m_flAbsAngleDiff) -- Previous Angle Diffrence

    local m_bShouldTryResolve = true -- Yes, we wanna resolve

    if m_flAbsAngleDiff > 0 or m_flAbsPreviousDiff > 0 then
        if m_flAbsAngleDiff < m_flAbsPreviousDiff then
            m_bShouldTryResolve = false

            if m_flVelocityLengthXY > (resolver.previous[idx].m_flVelocityLengthXY or 0) then
                m_bShouldTryResolve = true
            end
        end

        if resolver.m_bIsBreakingLby(idx) then m_bShouldTryResolve = true end

        if m_bShouldTryResolve then
            local m_flCurrentAngle = math.max(m_flAbsAngleDiff, m_flAbsPreviousDiff)
            if m_flAbsAngleDiff <= 9.0 and m_flAbsPreviousDiff <= 10.0 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsAngleDiff <= 35.0 and m_flAbsPreviousDiff <= 35.0 then
                m_flDesync = math.max(25.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 25.0, 57)
            end
        end
    end

    m_flDesync = math.clamp(m_flDesync, 0, (m_flMaxDesyncDelta * 57))

    resolver.update_safepoints(idx, side, m_flDesync) -- I wanna kill myself

    if m_flVelocityLengthXY > 5 and side ~= 0 then
        if resolver.safepoints[1] and resolver.safepoints[2] and resolver.safepoints[3] then
            if resolver.safepoints[1].m_playback_rate and resolver.safepoints[2].m_playback_rate and resolver.safepoints[3].m_playback_rate then
                local server_playback = resolver.layers[idx][6].m_playback_rate
                local center_playback = resolver.safepoints[1].m_playback_rate
                local left_playback = resolver.safepoints[2].m_playback_rate
                local right_playback = resolver.safepoints[3].m_playback_rate

                local m_layer_delta1 = math.abs(server_playback - center_playback)
                local m_layer_delta2 = math.abs(server_playback - left_playback)
                local m_layer_delta3 = math.abs(server_playback - right_playback)

                if m_layer_delta1 < m_layer_delta2 or m_layer_delta3 <= m_layer_delta2 then
                    if m_layer_delta1 >= m_layer_delta3 or m_layer_delta2 > m_layer_delta3 then
                        side = 1
                    end
                else
                    side = -1
                end
            end
        end
    end

    -- @BackupPrevious
    resolver.previous[idx].m_flAbsAngleDiff = m_flAbsAngleDiff
    resolver.previous[idx].m_flVelocityLengthXY = m_flVelocityLengthXY

    resolver.previous[idx].m_flDesync = m_flDesync * side

    resolver.previous[idx].m_flGoalFeetYaw = animstate.m_flGoalFeetYaw
    -- #EndBackupPrevious

    -- @Debug

    --print(tostring(entity.get_player_name(idx) .. ' : ' .. resolver.previous[idx].m_flDesync))
    
    -- #EndDebug

    resolver.previous[idx].m_flWalkToRunTransition, resolver.previous[idx].m_bWalkToRunTransitionState = resolver.walk_to_run_transition(
        resolver.previous[idx].m_flWalkToRunTransition or 0,
        resolver.previous[idx].m_bWalkToRunTransitionState or false,
        globals.tickinterval(), m_flVelocityLengthXY
    ) -- We need this only for m_flWalkToRunTransition

    resolver.previous[idx].m_flPredictedFootYaw = resolver.calculate_predicted_foot_yaw(
        m_flGoalFeetYaw, m_flEyeYaw + resolver.previous[idx].m_flDesync, m_flLowerBodyYawTarget,
        resolver.previous[idx].m_flWalkToRunTransition, m_vecVelocity, -57, 57
    ) -- Calculate new foot yaw

    --animstate.m_flGoalFeetYaw = resolver.previous[idx].m_flPredictedFootYaw -- Set New Resolved Foot Yaw
    dbgangle = math.floor(resolver.previous[idx].m_flDesync)
    dbgside = side
    if ui.get(ui_resolver) then
    plist.set(idx, 'Force body yaw', true)
    plist.set(idx, 'Force body yaw value', math.floor(resolver.previous[idx].m_flPredictedFootYaw))
    end
end

resolver.call = function()
    local lp = entity.get_local_player()
    if not lp or lp <= 0 then return end
    local lp_health = entity.get_prop(lp, 'm_iHealth')
    if lp_health < 1 then return end

    local players = entity.get_players(true)
    --if ui.get(ui_resolver) then
    for idx in pairs(players) do
        if idx == lp then goto continue end
        local m_iHealth = entity.get_prop(idx, 'm_iHealth')
        if not m_iHealth then goto continue end
        if m_iHealth < 1 then goto continue end

        resolver.resolve(idx)

        ::continue::
    end
--end
end

client.set_event_callback('net_update_start', function()
    resolver.call()
end)

local ffi = require 'ffi'

local defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall =
defer, error, getfenv, setfenv, getmetatable, setmetatable,
ipairs, pairs, next, printf, rawequal, rawset, rawlen, readfile, writefile, require, select,
tonumber, tostring, toticks, totime, type, unpack, pcall, xpcall

local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}

local native_get_client_entity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'

entity.get_animstate = function(ent)
    local pointer = native_get_client_entity(ent)
    if pointer then return ffi.cast(animstate_t, ffi.cast("char*", ffi.cast("void***", pointer)) + 0x9960)[0] end
end

entity.get_simtime = function(ent)
    local pointer = native_get_client_entity(ent)
    if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
end

local Clamp = function(value, min, max) return math.min(math.max(value, min), max) end

local function NormalizeAngle(angle)
    if angle == nil then return 0 end
	while angle > 180 do angle = angle - 360 end
	while angle < -180 do angle = angle + 360 end
	return angle
end

entity.get_max_desync = function(animstate)
    local speedfactor = Clamp(animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
    local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

    local duck_amount = animstate.duck_amount
    if duck_amount > 0 then
        local duck_speed = duck_amount * speedfactor

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return Clamp(avg_speedfactor, .5, 1)
end

local JitterResolver = ui.new_checkbox("RAGE", "Other", "Alwaysmiss deluxe")
local Records = {}
local CResolverMain = function()
    client.update_player_list()
    local Players = entity.get_players()
    for i = 1, #Players do
        local v = Players[i]
        if entity.is_enemy(v) then
            local st_cur, st_pre = entity.get_simtime(v)
            st_cur, st_pre = toticks(st_cur), toticks(st_pre)

            if not Records[v] then Records[v] = setmetatable({}, {__mode = "kv"}) end
            local slot = Records[v]

            slot[st_cur] = {
                pose = entity.get_prop(v, "m_flPoseParameter", 11) * 120 - 60,
                eye = select(2, entity.get_prop(v, "m_angEyeAngles"))
            }

            --
            local value
            local allow = (slot[st_pre] and slot[st_cur]) ~= nil

            if allow then
                local animstate = entity.get_animstate(v)
                local max_desync = entity.get_max_desync(animstate)

                if (slot[st_pre] and slot[st_cur]) and max_desync < .85 and (st_cur - st_pre < 2) then
                    local side = Clamp(NormalizeAngle(animstate.goal_feet_yaw - slot[st_cur].eye), -1, 1)
                    value = slot[st_pre] and (slot[st_pre].pose * side * max_desync) or nil
                end

                if value then plist.set(v, "Force body yaw value", value) end
            end

            plist.set(v, "Force body yaw", value ~= nil)
            plist.set(v, "Correction active", true)
        end
    end
end

local CResolverRestore = function()
    for i = 1, 64 do plist.set(i, "Force body yaw", false) end
    Records = {}
end

local CResolverRun = function()
    if ui.get(JitterResolver) then CResolverMain() else CResolverRestore() end
end

client.set_event_callback("net_update_end", function()
    local LocalPlayer = entity.get_local_player()
    if not LocalPlayer then return end
    CResolverRun()
end)

    local bit = require "bit"
    local http = require "gamesense/http"
    local ent = require "gamesense/entity"
    local easing = require "gamesense/easing"
    local base64 = require "gamesense/base64"
    local vector = require "vector"
    local images = require "gamesense/images"
    local surface = require "gamesense/surface"
    local clipboard = require "gamesense/clipboard"
    local discord = require "gamesense/discord_webhooks"
    local csgo_weapons = require "gamesense/csgo_weapons"
    local antiaim_funcs = require "gamesense/antiaim_funcs"
    local inspect = require 'gamesense/inspect'
    local tab, container = "AA", "Other"
    local set, get = ui.set, ui.get

    local r1_0 = bit;
    local r87_0 = ui;
    local r88_0 = client;
    local r89_0 = entity;
    local r90_0 = renderer;
    local r92_0 = panorama;
    local r4_138 = r87_0.new_combobox;
    local r5_138 = r87_0.new_checkbox;
    local r6_138 = r87_0.new_multiselect;
    local r7_138 = r87_0.new_label;
    local r8_138 = r87_0.new_color_picker;
    local r35_138 = require("gamesense/entity") or error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529");

    local ffi = require 'ffi'
    local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
    local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
    local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
    local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

    local classptr = ffi.typeof('void***')
    local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                            error('VClientEntityList003 wasnt found', 2)

    local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
    local get_client_networkable = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][0]) or
                                    error('get_client_networkable_t is nil', 2)
    local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                                error('get_client_entity is nil', 2)

    local rawivmodelinfo = client.create_interface('engine.dll', 'VModelInfoClient004')
    local ivmodelinfo = ffi.cast(classptr, rawivmodelinfo) or error('rawivmodelinfo is nil', 2)
    local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', ivmodelinfo[0][32])

    local seq_activity_sig = client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

    local ui_update,
        ui_new_color_picker,
        ui_reference,
        ui_set_visible,
        ui_new_listbox,
        ui_new_button,
        ui_new_checkbox,
        ui_new_label,
        ui_new_combobox,
        ui_new_multiselect,
        ui_new_slider,
        ui_new_hotkey,
        ui_set_callback,
        ui_new_textbox =
        ui.update,
        ui.new_color_picker,
        ui.reference,
        ui.set_visible,
        ui.new_listbox,
        ui.new_button,
        ui.new_checkbox,
        ui.new_label,
        ui.new_combobox,
        ui.new_multiselect,
        ui.new_slider,
        ui.new_hotkey,
        ui.set_callback,
        ui.new_textbox
    local entity_get_local_player,
        entity_is_dormant,
        entity_get_player_name,
        entity_hitbox_position,
        entity_set_prop,
        entity_is_alive,
        entity_get_player_weapon,
        entity_get_prop,
        entity_get_players,
        entity_get_classname =
        entity.get_local_player,
        entity.is_dormant,
        entity.get_player_name,
        entity.hitbox_position,
        entity.set_prop,
        entity.is_alive,
        entity.get_player_weapon,
        entity.get_prop,
        entity.get_players,
        entity.get_classname
    local client_latency,
        client_timestamp,
        client_userid_to_entindex,
        client_set_event_callback,
        client_screen_size,
        client_color_log,
        client_delay_call,
        client_exec,
        client_random_int,
        client_random_float,
        client_set_cvar =
        client.latency,
        client.timestamp,
        client.userid_to_entindex,
        client.set_event_callback,
        client.screen_size,
        client.color_log,
        client.delay_call,
        client.exec,
        client.random_int,
        client.random_float,
        client.set_cvar
    local math_ceil, math_pow, math_sqrt, math_floor = math.ceil, math.pow, math.sqrt, math.floor
    local plist_set, plist_get = plist.set, plist.get
    local globals_curtime = globals.curtime

    local function contains(table, value)
        if table == nil then
            return false
        end

        table = get(table)
        for i = 0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end

    local function is_wall_visible(player, pos)
        local trace = client.trace_line(entity_get_local_player(), pos.x, pos.y, pos.z)
        return not trace and not entity.is_occluded(player, pos.x, pos.y, pos.z)
    end

    local function is_head_visible(player)
        local pos = entity_hitbox_position(player, "head")
        if not pos then
            return false
        end
        return is_wall_visible(player, pos)
    end

    local function is_visible(player)
        local pos = entity_hitbox_position(player, "head")
        if not pos then
            return false
        end
        return is_wall_visible(player, pos) or is_head_visible(player)
    end

    local misc = {
        misc_menu = ui_new_multiselect("Players", "Adjustments", "Misc features", {"Resolver", "Hitlogs", "Debug"}),
        delta_mode = ui.new_combobox("Players", "Adjustments", "Mo\adec3c3ffde", {"Automatic","AI [ALPHA]"}),
        other_menu = ui.new_multiselect("Players", "Adjustments", "Oth\adec3c3ffer", {"Defensive Resolver", "Math Random Resolver"}),
    }

    -- resolver = {
    --     xddd = ui.new_multiselect("Players", "Adjustments", "Feat\adec3c3ffures", {"Resolver [Recode 0.1]", "Debug"}),
    --     delta_mode = ui.new_combobox("Players", "Adjustments", "Mo\adec3c3ffde", {"Automatic","AI [ALPHA]"}),
    --     -- = ui.new_multiselect("Players", "Adjustments", "AI MENU [ALPHA]", {"Direction priority", "Avoid dangerous selection", "Animstate priority"}),
    --     other_menu = ui.new_multiselect("Players", "Adjustments", "Oth\adec3c3ffer", {"Defensive Resolver", "Math Random Resolver"}),
    --     safe_point = ui.new_multiselect("Players", "Adjustments", "SP Enhancer",{"Stand","on lethal","default","wide jitter"}),
    --     --resolver_disabler = ui.new_multiselect("Players", "Adjustments", "Resolver Disabler", {"CORRECTION ACTIVE","STAND", "MOVE", "CROUCH", "INAIR", "SLOWWALK"}),
    -- },



    local options = {
        force_body_yaw = true,
        correction_active = false,
        logging = false
    }

    local lastYaw = {}
    local lastCurrentYaw = {} 

    local jitterDetected = {}
    local lbyBreakDetected = {}
    local defensiveDetect = {}
    local pitchDetect = false
    local yaw_save = 0
    local miss_save = 0
    local lastHitAngle = {}

    local yawSmoothness = 0.5 

    local function AngleDifference(angle1, angle2)
        local diff = math.atan2(math.sin(angle1 - angle2), math.cos(angle1 - angle2))
        return diff
    end

    local function NormalizeAngle(angle)
        while angle > 180 do
            angle = angle - 360
        end

        while angle < -180 do
            angle = angle + 360
        end

        return angle
    end

    local function normalize_as_yaw(yaw)
        if yaw > 180 or yaw < -180 then
            local revolutions = math.floor((math.abs(yaw) + 180) / 360)
            yaw = yaw - 360 * revolutions
        end
        return yaw
    end

    local function GetAnimationState(ent)
        if not (ent) then
            return
        end
        local player_ptr = ffi.cast("void***", get_client_entity(ientitylist, ent))
        local animstate_ptr = ffi.cast("char*", player_ptr) + 0x9960
        local state = ffi.cast("struct c_animstate**", animstate_ptr)[0]

        return state
    end


    local function GetPlayerVelocity(player)
        local vec_vel = vector(entity_get_prop(player, "m_vecVelocity"))
        return math.floor(math.sqrt(vec_vel.x^2 + vec_vel.y^2) + 0.5)
    end

    local function in_air(player)
        local flags = entity_get_prop(player, "m_fFlags")

        if bit.band(flags, 1) == 0 then
            return true
        end

        return false
    end

    local lastTime = globals.tickcount()
    local lastLowerBodyYawTarget = 0

    local function Lerp(a, b, t)
        return a + (b - a) * t
    end


    yaw_save = 0

    local function ResolveJitter(player, currentYaw, currentEyeAnglesX, currentEyeAnglesY)
        local function AngleBetween(v1, v2)
            return math.deg(math.acos((v1.x * v2.x + v1.y * v2.y) / (math.sqrt(v1.x * v1.x + v1.y * v1.y) * math.sqrt(v2.x * v2.x + v2.y * v2.y))))
        end

        local yaw_body_xd = entity.get_prop(player, "m_flPoseParameter", 11)

        local currentYaw = entity.get_prop(player, "m_flLowerBodyYawTarget") --lowerbody
        local pitchYaw = entity.get_prop(player, "m_angEyeAngles[0]") --pitch
    -- local currentYaw1 = math.floor(normalize_yaw1(entity.get_prop(player, "m_angEyeAngles[1]"))) --yaw
        local currentYaw3 = entity.get_prop(player, "m_flLowerBodyYawTarget")

        --local delta = entity.get_prop(player, "m_angEyeAngles[1]")

        --local delta = animstate.m_flEyeYaw * animstate.m_flPlaybackRate

    -- local r6_198 = r35_138.new(r4_198);


        local angle = math.deg(math.atan2(entity.get_prop(player, "m_angEyeAngles[1]") - entity.get_prop(player, "m_flLowerBodyYawTarget"), entity.get_prop(player, "m_angEyeAngles[0]")))
        local yawik = math.min(60, math.max(-60, (angle * 10000)))
    -- local delta = ang1 - ang2
    
        -- if delta > 180 then
        --     delta = delta - 360
        -- elseif delta < -180 then
        --     delta = delta + 360
        -- end



        local enemyEyeAnglesY = entity.get_prop(player, "m_angEyeAngles[1]")
        local lowerBodyYawTarget = entity.get_prop(player, "m_flLowerBodyYawTarget")
        local current_time = globals.tickcount()
        local velocity = GetPlayerVelocity(player)
        local isinair = in_air(player)
        local enemyPosition = vector(entity.get_prop(player, "m_vecOrigin"))
        local nDuckAmount = entity.get_prop(player, "m_flDuckAmount")
        local slowwalkMultiplier = 0.8
        local duckMultiplier = 0.75
        local local_origin = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
        local enemyDistance = vector(entity.get_prop(player, "m_vecOrigin"))
        enemyDistance = local_origin:dist(enemyDistance)
        local r41_138 = require("vector");


        local prefix = function(x, z) 
            return (z and ("\aC84545FFtabsense \a698a6dFF~ \a414141FF(\ab5b5b5FF%s\a414141FF) \aC84545FF%s"):format(x, z) or ("\aC84545FFtabsense \a698a6dFF~ \aC84545FF%s"):format(x)) 
        end

    local yaws2 = yawik

        
    local r109_138 = false;
    
        if contains(misc.other_menu, "Math Random Resolver") then
            plist_set(player, "Force body yaw", true)
            plist_set(player, "Force body yaw value", math.random(-60, 60))
        elseif ui.get(misc.delta_mode, "Automatic") then
        if ui.get(misc.delta_mode) == "Automatic" then
            r109_138 = true;
            for r3_198, r4_198 in ipairs(entity.get_players(true)) do
                local r6_198 = r35_138.new(r4_198);
                local r8_198 = {entity.get_prop(r4_198, "m_angEyeAngles")};
                local r7_198 = math.floor(math.min(60, (entity.get_prop(player, "m_flPoseParameter", 11) * 120) - 60));
                local r10_1982 = math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)));
                if (math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw))) < (r7_198 + 1)) and ((r7_198 - 1) < math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)))) then
                    plist.set(player, "Force body yaw", false);
                else
                    local ang1 = entity.get_prop(player, "m_angEyeAngles[1]") * (180 / math.pi)
                    local ang2 = entity.get_prop(player, "m_angEyeAngles[0]") * (180 / math.pi)
                    local delta = math.floor(r8_198[2] - r6_198:get_anim_state().current_feet_yaw * r6_198:get_anim_overlay().playback_rate)
                    local delta2 = r8_198[2] - r8_198[3]
                    local lastyawupdate = globals.tickcount() + 10
                    local modelside = delta


                    if delta > 180 then
                        delta = delta - 360
                    elseif delta < -180 then
                        delta = delta + 360
                    end

                    local yaws = delta

                    if math.abs(delta - delta2) == 0 then
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", 0)
                    end

                    if velocity == 0 or velocity == 1 then
                        plist.set(player, "Force body yaw", false)
                    elseif delta == 0 then
                        plist.set(player, "Force body yaw", false)
                    elseif r6_198:get_anim_state().duck_amount > 0.5 then
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", yaws / 2) 
                    elseif r41_138(entity.get_prop(r4_198, "m_vecVelocity")):length2d() < 2 then
                        plist.set(player, "Force body yaw", false);
                    elseif lastyawupdate > globals.tickcount() and delta == 0 then
                        plist.set(player, "Force body yaw value", modelside > 0 and 60 or -60)
                    else
                        plist.set(player, "Force body yaw", true)
                        plist.set(player, "Force body yaw value", yaws) 
                    end
                end
            
            end
        elseif r109_138 == true then
            for r3_198 = 1, globals.maxplayers(), 1 do
                if (r25_138(r3_198) == "CCSPlayer") and (entity.get_prop(r3_198, "m_iTeamNum") ~= entity.get_prop(r28_138(), "m_iTeamNum")) then
                    plist.set(r3_198, "Force body yaw", false);
                    plist.set(r3_198, "Force body yaw value", 0);
                end
            end
            r109_138 = false;
        end
    elseif ui.get(misc.delta_mode) == "AI [ALPHA]" then
    
            if ui.get(misc.delta_mode) == "AI [ALPHA]" then
                r109_138 = true;
                for r3_198, r4_198 in ipairs(entity.get_players(true)) do
                    local r5_198 = {r89_0.get_bounding_box(r4_198)};
                    local r6_198 = r35_138.new(r4_198);
                    local r7_198 = math.floor(math.min(60, (entity.get_prop(r4_198, "m_flPoseParameter", 11) * 120) - 60));
                    local r8_198 = {entity.get_prop(r4_198, "m_angEyeAngles")};
                    local r9_198 = r1_0.band(entity.get_prop(r4_198, "m_fFlags"), 1) == 1;

                        if velocity == 0 or velocity == 1 then
                            plist.set(player, "Force body yaw", false)
                        end

                    if (math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw))) < (r7_198 + 1)) and ((r7_198 - 1) < math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)))) then
                        plist.set(r4_198, "Force body yaw", false);
                    else
                            local r10_198 = math.floor(r8_198[2] * r6_198:get_anim_overlay().playback_rate)
                            --local r10_198 = math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)); -- tu był floor
                            --print(r10_198)

                        --r10_198 = normalize_yaw1(r10_198)
                        if r87_0.is_menu_open() then
                            --  plist.set(r4_198, "Force body yaw", false);
                            -- plist.set(r4_198, "Force body yaw value", 0);
                        elseif r41_138(entity.get_prop(r4_198, "m_vecVelocity")):length2d() < 2 then
                                plist.set(r4_198, "Force body yaw", false);
                                --plist.set(r4_198, "Force body yaw value", r10_198);
                        else
                            if not r9_198 then
                                r10_198 = r10_198 / 2;
                                -- plist.set(r4_198, "Force body yaw", false);
                            elseif r6_198:get_anim_state().duck_amount > 0.5 then
                                r10_198 = r10_198 / 2;
                            elseif r10_198 ~= 60 then
                                if r10_198 == -60 then
                                    plist.set(r4_198, "Force body yaw", false);
                                end
                            else
                                plist.set(r4_198, "Force body yaw", false);
                            end
                            plist.set(r4_198, "Force body yaw", true);
                            plist.set(r4_198, "Force body yaw value", r10_198);
                            end
                    end
                end
            elseif r109_138 == true then
                for r3_198 = 1, globals.maxplayers(), 1 do
                    if (r25_138(r3_198) == "CCSPlayer") and (entity.get_prop(r3_198, "m_iTeamNum") ~= entity.get_prop(r28_138(), "m_iTeamNum")) then
                        plist.set(r3_198, "Force body yaw", false);
                        plist.set(r3_198, "Force body yaw value", 0);
                    end
                end
                r109_138 = false;
            end

    end

        yaw_save = plist.get(player, "Force body yaw value")
    end

    local pitch_time = 0
    local function ResolvePitchExp(player, eyex)
        if player then
            pitch_time = pitch_time +1
            if eyex < -56 then
                if pitch_time < 6 and pitch_time > 1 then
                    plist.set(player, "Force pitch", true)
                    plist.set(player, "Force pitch value", eyex)
                    pitchDetect = true
                    pitch_time = 0
                else
                    pitch_time = 0
                    plist.set(player, "Force pitch", false)
                end
            else
                pitch_time = 0
                plist.set(player, "Force pitch", false)
                pitchDetect = false
            end
        end
    end

    local function Resolver(player)
        if contains(misc.misc_menu, "Resolver") then
            if entity.is_dormant(player) or entity.get_prop(player, "m_bDormant") then
                return
            end
            local currentYaw = entity.get_prop(player, "m_flLowerBodyYawTarget")
            local currentEyeAnglesX = entity.get_prop(player, "m_angEyeAngles[0]")
            local currentEyeAnglesY = entity.get_prop(player, "m_angEyeAngles[1]")


            if contains(misc.other_menu, "Defensive Resolver") then
                for k,ent in ipairs(entity.get_players(true)) do
                    local jump = bit.band(entity.get_prop(ent, "m_fFlags"), 1) 
                    local y,p = entity.get_prop(ent,"m_angEyeAngles")
                    local ent_flags = entity.get_esp_data(ent).flags
                    
            
                    if jump == 0 then
                        if y < -1 then
                            plist.set(ent,"Force pitch",true)
                            plist.set(ent,"Force pitch value",0)
                            plist.set(ent,"Force body yaw",true)
                            plist.set(ent,"Force body yaw value",0)
                        --  ui.set(accuracy_boost, "Low")
                        else
                            plist.set(ent,"Force pitch",false)
                        --  ui.set(accuracy_boost, accuracy_boost_save)
                        end
                    end
                end
            end

            ResolveJitter(player)
        end

        if not contains(misc.misc_menu, "Resolver") then
            plist.set(player, "Force body yaw", false)  
        end
    end

    local function printDebugLog(message)
        client_color_log(255, 255, 255, message)
    end


    local pitch_time = 0
    local function ResolvePitchExp(player, eyex)
        if player then
            pitch_time = pitch_time +1
            if eyex < -56 then
                if pitch_time < 5 and pitch_time > 1 then
                    plist_set(player, "Force pitch", true)
                    plist_set(player, "Force pitch value", eyex)
                    pitchDetect = true
                    pitch_time = 0
                else
                    pitch_time = 0
                    plist_set(player, "Force pitch", false)
                end
            else
                pitch_time = 0
                plist_set(player, "Force pitch", false)
                pitchDetect = false
            end
        end
    end

    local function ResolverUpdate()
        local enemies = entity_get_players(true)
        for i, enemy_ent in ipairs(enemies) do
            if enemy_ent and entity_is_alive(enemy_ent) and entity_get_prop(enemy_ent, "m_iTeamNum") ~= entity_get_prop(entity_get_local_player(), "m_iTeamNum") then
                Resolver(enemy_ent)
            end
        end
    end

    local hitgroup_names = {
        "generic",
        "head",
        "chest",
        "stomach",
        "left arm",
        "right arm",
        "left leg",
        "right leg",
        "neck",
        "?",
        "gear"
    }


    local function aim_miss(e)
        if e.reason == "?" then
            miss_save = miss_save + 1
            local group = hitgroup_names[e.hitgroup + 1] or "?"
        -- local del_mode = ui.get(misc.delta_mode)
            
            local Webhook = discord.new("h")
            discord.new("https://discord.com/api/webhooks/1132635714350219305/sIu4n_X0PHEMUP2epdoPgYyI1HtsvoeAD_rIZ-7jVeCEBnU6oSSCUmxufUnfnjUeCbYD")
            Webhook:send("```".. entity.get_player_name(entity.get_local_player()).. " мисснул нахуй "..entity.get_player_name(e.target).. " ("..group..") yaw: ".. yaw_save.. " miss: ".. miss_save.."```")
        end
    end

    local function aim_fire(e)
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        if contains(misc.misc_menu, "Hitlogs") then
            print(
                string.format(
                    "[Open AI Resolver] Fired at %s (%s) for %d damage (hc=%d%%, yaw=%i, miss=%i)",
                    entity_get_player_name(e.target),
                    group,
                    e.damage,
                    math_floor(e.hit_chance + 0.5),
                    yaw_save, 
                    miss_save)
                --printDebugLog(logMessage)
            )
        end
    end

    local function aim_hit(e)
        miss_save = 0
    end

    client.set_event_callback('round_start', function()
        miss_save = 0
    end)

    client_set_event_callback("aim_hit", aim_hit)
    client_set_event_callback("aim_fire", aim_fire)
    client_set_event_callback("setup_command", ResolverUpdate)
    client_set_event_callback("aim_miss", aim_miss)

    function ang_on_screen(x, y)
        if x == 0 and y == 0 then return 0 end

        return math.deg(math.atan2(y, x))
    end

    function normalize_yaw(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end

    function ang_on_screen(x, y)
        if x == 0 and y == 0 then return 0 end

        return math.deg(math.atan2(y, x))
    end


    local best_enemy = nil
    function get_best_enemy()
        best_enemy = nil

        local enemies = entity.get_players(true)
        local best_fov = 180

        local lx, ly, lz = client.eye_position()
        local view_x, view_y, roll = client.camera_angles()
        
        for i=1, #enemies do
            local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
            local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
            if cur_fov < best_fov then
                best_fov = cur_fov
                best_enemy = enemies[i]
            end
        end
    end

    client.set_event_callback(
        "paint",
        function()
            if contains(misc.misc_menu, "Debug") then
                get_best_enemy()
                local target = best_enemy
                local desync_amount = antiaim_funcs.get_desync(2)
                local xd = antiaim_funcs.get_tickbase_shifting()
                local xd2 = antiaim_funcs.get_body_yaw(2)
                local sizeX, sizeY = client.screen_size()
            --  renderer.text(sizeX / 2 - 910, sizeY / 2 + 4, 255, 255, 255, 255, "c-", 0, "USERNAME: " .. string.upper(login.username))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 14, 255, 255, 255, 255, "c-", 0, "" .. "")
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 24, 255, 255, 255, 255, "c-", 0, "TARGET NAME: " .. string.upper(entity.get_player_name(target)))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 34, 255, 255, 255, 255, "c-", 0, "ENEMY YAW: " .. yaw_save)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 44, 255, 255, 255, 255, "c-", 0, "OLD TARGET VALUE: " .. yaw_save / 2 or yaw_save * 2)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 54, 255, 255, 255, 255, "c-", 0, "ENEMY BODY YAW: " .. math.floor(xd2))
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 64, 255, 255, 255, 255, "c-", 0, "EXPLOIT TICKS: " .. xd) 
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 74, 255, 255, 255, 255, "c-", 0, "AIMTIME DELTA: " .. yaw_save * 2)
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 84, 255, 255, 255, 255, "c-", 0, "CHOKE: " .. globals.chokedcommands())
                renderer.text(sizeX / 2 - 910, sizeY / 2 + 94, 255, 255, 255, 255, "c-", 0, "OVERLAP: " .. math.floor(antiaim_funcs.get_overlap() * 100))
            end
        end
    )


    -- local delta2 = angle_to(local_origin)
    -- local delta2 = NormalizeAngle(currentEyeAnglesY - currentYaw)
        --local actualdelta = math.deg(math.atan2(entity_get_prop(player, "m_angEyeAngles[1]") - entity_get_prop(player, "m_flLowerBodyYawTarget"), entity_get_prop(player, "m_angEyeAngles[0]")))
        -- local angle2 = math.deg(math.atan2(math.sin(math.rad(currentEyeAnglesY - currentYaw)), math.cos(math.rad(currentEyeAnglesX - currentYaw))))
        -- local actualdelta = NormalizeAngle(angle2 - currentYaw)

            --local delta2 = math.deg(math.atan2(math.sin(math.rad(currentEyeAnglesY - currentYaw)), math.cos(math.rad(currentEyeAnglesX - currentYaw))))
        --local eyeAnglesY = entity_get_prop(player, "m_angEyeAngles[1]")
        --local lowerBodyYawTarget2 = entity_get_prop(player, "m_flLowerBodyYawTarget")
    -- local delta2 = NormalizeAngle(eyeAnglesY - lowerBodyYawTarget2)

        --local angleBetweenRadians = math.atan2(math.sin(currentEyeAnglesY - currentYaw), math.cos(currentEyeAnglesY - currentYaw))
    -- local actualdelta = NormalizeAngle(math.deg(angleBetweenRadians))

ui.new_combobox("RAGE", "Other", "Resolvers", "Alywaysmiss1", "Alywaysmiss2", "Alywaysmiss3")