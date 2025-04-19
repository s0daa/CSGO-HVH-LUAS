local vector = require 'vector'
local ffi = require 'ffi'

ffi.cdef[[	
    typedef void*(__thiscall* get_client_entity_t_128481294812948)(void*, int);

	struct CCSGOPlayerAnimstate_128481294812948 {
		char pad[3];
		char m_bForceWeaponUpdate;
		char pad1[91];
		void* m_pBaseEntity;
		void* m_pActiveWeapon;
		void* m_pLastActiveWeapon;
		float m_flLastClientSideAnimationUpdateTime;
		int m_iLastClientSideAnimationUpdateFramecount;
		float m_flAnimUpdateDelta;
		float m_flEyeYaw;
		float m_flPitch;
		float m_flGoalFeetYaw;
		float m_flCurrentFeetYaw;
		float m_flCurrentTorsoYaw;
		float m_flUnknownVelocityLean;
		float m_flLeanAmount;
		char pad2[4];
		float m_flFeetCycle;
		float m_flFeetYawRate;
		char pad3[4];
		float m_fDuckAmount;
		float m_fLandingDuckAdditiveSomething;
		char pad4[4];
		float m_vOriginX;
		float m_vOriginY;
		float m_vOriginZ;
		float m_vLastOriginX;
		float m_vLastOriginY;
		float m_vLastOriginZ;
		float m_vVelocityX;
		float m_vVelocityY;
		char pad5[4];
		float m_flUnknownFloat1;
		char pad6[8];
		float m_flUnknownFloat2;
		float m_flUnknownFloat3;
		float m_flUnknown;
		float m_flSpeed2D;
		float m_flUpVelocity;
		float m_flSpeedNormalized;
		float m_flFeetSpeedForwardsOrSideWays;
		float m_flFeetSpeedUnknownForwardOrSideways;
		float m_flTimeSinceStartedMoving;
		float m_flTimeSinceStoppedMoving;
		bool m_bOnGround;
		bool m_bInHitGroundAnimation;
		float m_flTimeSinceInAir;
        float m_flLastOriginZ;
        float m_flLastOriginZ;
		float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
	};
]]

local entity_list = ffi.cast(ffi.typeof("void***"), client.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity = ffi.cast("get_client_entity_t_128481294812948", entity_list[0][3])

-- Caching common functions
local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local entity_set_prop = entity.set_prop
local globals_chokedcommands = globals.chokedcommands
local globals_curtime = globals.curtime
local math_min = math.min
local math_max = math.max
local ffi_cast = ffi.cast
local ui_get = ui.get

-- Magic numbers
local start_falling_time = 0.359375
local end_falling_time = 1.15625

local falling_time = 0
local simulated_server_jump_fall = 0

-- I really don't like this part of the code
local jumping = false
local reset = false
local bunny_hop_reference = ui.reference('misc', 'movement', 'bunny hop')

client.set_event_callback('setup_command', function(cmd)
    local bunny_hop = ui_get(bunny_hop_reference)

	jumping = bunny_hop and cmd.in_jump ~= 1

	if cmd.in_jump == 1 then
		reset = false
	end
end)
-- I really don't like this part of the code

client.set_event_callback('predict_command', function()
    local local_player = entity_get_local_player()
  
    entity_set_prop(local_player, "m_flPoseParameter", 1, 6)

    local player_ptr = ffi_cast("void***", get_client_entity(entity_list, local_player))
	local animstate_ptr = ffi_cast("char*" , player_ptr) + 0x3914
    local animstate = ffi_cast("struct CCSGOPlayerAnimstate_128481294812948**", animstate_ptr)[0]

    local in_hit_ground_animation = animstate.m_bInHitGroundAnimation
    local head_height_or_offset_from_hitting_ground_animation = animstate.m_flHeadHeightOrOffsetFromHittingGroundAnimation
    
    if in_hit_ground_animation then
        if head_height_or_offset_from_hitting_ground_animation and jumping and not reset then
            entity_set_prop(local_player, 'm_flPoseParameter', 0.5, 12)
        end
    end
end)

client.set_event_callback('round_freeze_end', function()
	reset = true
end)