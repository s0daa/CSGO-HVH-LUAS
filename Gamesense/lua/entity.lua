local ffi = require 'ffi'

local animation_layer_t = ffi.typeof([[
	struct {										char pad_0x0000[0x18];
		uint32_t	sequence;
		float		prev_cycle;
		float		weight;
		float		weight_delta_rate;
		float		playback_rate;
		float		cycle;
		void		*entity;						char pad_0x0038[0x4];
	} **
]])

local animation_state_t = ffi.typeof([[
	struct {										char pad_0x0000[0x18];
		float		anim_update_timer;				char pad_0x001C[0xC];
		float		started_moving_time;
		float		last_move_time;					char pad_0x0030[0x10];
		float		last_lby_time;					char pad_0x0044[0x8];
		float		run_amount;						char pad_0x0050[0x10];
		void		*entity;
		__int32		active_weapon;
		__int32		last_active_weapon;
		float		last_client_side_animation_update_time;
		__int32		last_client_side_animation_update_framecount;
		float		eye_timer;
		float		eye_angles_y;
		float		eye_angles_x;
		float		goal_feet_yaw;
		float		current_feet_yaw;
		float		torso_yaw;
		float		last_move_yaw;
		float		lean_amount;					char pad_0x0094[0x4];
		float		feet_cycle;
		float		feet_yaw_rate;					char pad_0x00A0[0x4];
		float		duck_amount;
		float		landing_duck_amount;			char pad_0x00AC[0x4];
		float		current_origin[3];
		float		last_origin[3];
		float		velocity_x;
		float		velocity_y;						char pad_0x00D0[0x10];
		float		move_direction_1;
		float		move_direction_2;				char pad_0x00E8[0x4];
		float		m_velocity;
		float		jump_fall_velocity;
		float		clamped_velocity;
		float		feet_speed_forwards_or_sideways;
		float		feet_speed_unknown_forwards_or_sideways;
		float		last_time_started_moving;
		float		last_time_stopped_moving;
		bool		on_ground;
		bool		hit_in_ground_animation;		char pad_0x0110[0x8];
		float		last_origin_z;
		float		head_from_ground_distance_standing;
		float		stop_to_full_running_fraction;	char pad_0x0120[0x14];
		__int32 	is_not_moving;					char pad_0x0138[0x20];
		float		last_anim_update_time;
		float		moving_direction_x;
		float		moving_direction_y;
		float		moving_direction_z;				char pad_0x0168[0x44];
		__int32 	started_moving;					char pad_0x01B0[0x8];
		float		lean_yaw;						char pad_0x01BC[0x8];
		float		poses_speed;					char pad_0x01C8[0x8];
		float		ladder_speed;					char pad_0x01D4[0x8];
		float		ladder_yaw;						char pad_0x01E0[0x8];
		float		some_pose;						char pad_0x01EC[0x14];
		float		body_yaw;						char pad_0x0204[0x8];
		float		body_pitch;						char pad_0x0210[0x8];
		float		death_yaw;						char pad_0x021C[0x8];
		float		stand;							char pad_0x0228[0x8];
		float		jump_fall;						char pad_0x0234[0x8];
		float		aim_blend_stand_idle;			char pad_0x0240[0x8];
		float		aim_blend_crouch_idle;			char pad_0x024C[0x8];
		float		strafe_yaw;						char pad_0x0258[0x8];
		float		aim_blend_stand_walk;			char pad_0x0264[0x8];
		float		aim_blend_stand_run;			char pad_0x0270[0x8];
		float		aim_blend_crouch_walk;			char pad_0x027C[0x8];
		float		move_blend_walk;				char pad_0x0288[0x8];
		float		move_blend_run;					char pad_0x0294[0x8];
		float		move_blend_crouch;				char pad_0x02A0[0x4];
		float		speed;
		__int32 	moving_in_any_direction;
		float		acceleration;					char pad_0x02B0[0x74];
		float		crouch_height;
		__int32 	is_full_crouched;				char pad_0x032C[0x4];
		float		velocity_subtract_x;
		float		velocity_subtract_y;
		float		velocity_subtract_z;
		float		standing_head_height;			char pad_0x0340[0x4];
	} **
]])

local get_weapon_info_t = ffi.typeof([[
	struct {
		char	pad_vtable[0x4];
		char*	consoleName;		char	pad_0[0xc];
		int		iMaxClip1;
		int		MaxClip2;
		int		iDefaultClip1;
		int 	iDefaultClip2;
		int		iPrimaryReserveAmmoMax;
		int		iSecondaryReserveAmmoMax;
		char*	szWorldModel;
		char*	szViewModel;
		char*	szDroppedModel;		char	pad_9[0x50];
		char*	szHudName;
		char*	szWeaponName;		char	pad_11[0x2];
		bool	bIsMeleeWeapon;		char	pad_12[0x9];
		float	flWeaponWeight;		char	pad_13[0x2c];
		int		iWeaponType;
		int		iWeaponPrice;
		int		iKillAward;			char	pad_16[0x4];
		float	flCycleTime;
		float	flCycleTimeAlt;		char	pad_18[0x8];
		bool	bFullAuto;			char	pad_19[0x3];
		int		iDamage;
		float	flArmorRatio;
		int		iBullets;
		float	flPenetration;		char	pad_23[0x8];
		float	flWeaponRange;
		float	flRangeModifier;
		float	flThrowVelocity;	char	pad_26[0xc];
		bool	bHasSilencer;		char	pad_27[0xb];
		char*	szBulletType;
		float	flMaxSpeed;
		float	flMaxSpeedAlt;		char	pad_29[0x50];
		int		iRecoilSeed;
	}* (__thiscall*)(void*)
]])

local get_client_networkable = vtable_bind('client.dll', 'VClientEntityList003', 0, 'void*(__thiscall*)(void*, int)')
local get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local get_client_unknown = vtable_thunk(0, 'void*(__thiscall*)(void*)')
local get_client_renderable = vtable_thunk(5, 'void*(__thiscall*)(void*)')
local get_model = vtable_thunk(8, 'const void*(__thiscall*)(void*)')
local get_studio_model = vtable_bind('engine.dll', 'VModelInfoClient004', 32, 'void*(__thiscall*)(void*, const void*)')
local get_weapon_info = vtable_thunk(460, get_weapon_info_t)

local get_sequence_activity_match = client.find_signature('client_panorama.dll','\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83') or error('Invalid GetSequenceActivity signature')
local get_sequence_activity = ffi.cast('int(__fastcall*)(void*, void*, int)', get_sequence_activity_match)

local ent_c = {}
local ent_mt = {
	__index = ent_c,
	__metatable = 'ent'
}

local function is_ent(value)
	return getmetatable(value) == 'ent'
end

function ent_mt.__call(ent, entindex_new)
	entindex_new = entindex_new or ent.entindex

	ent.entindex = entindex_new
end

function ent_mt.__eq(ent_a, ent_b)
	local a, b = ent_a, ent_b

	if is_ent(ent_a) then
		a = ent_a.entindex
	end

	if is_ent(ent_b) then
		b = ent_b.entindex
	end

	return a == b
end

function ent_c.new(entindex)
	return setmetatable(
		{
			entindex = entindex or 0
		},
		ent_mt
	)
end

function ent_mt.__tostring(ent)
	return string.format('%d', ent.entindex)
end

function ent_c.get_local_player()
	return ent_c.new(entity.get_local_player())
end

function ent_c.get_all(classname)
	local tbl = {}

	local entities = classname and entity.get_all(classname) or entity.get_all()
	for i=1, #entities do
		tbl[i] = ent_c.new(entities[i])
	end

	return tbl
end

function ent_c.get_players(enemies_only)
	local tbl = {}
	
	local players = enemies_only and entity.get_players(enemies_only) or entity.get_players()
	for i=1, #players do
		tbl[i] = ent_c.new(players[i])
	end

	return tbl
end

function ent_c.get_game_rules()
	return ent_c.new(entity.get_game_rules())
end

function ent_c.get_player_resource()
	return ent_c.new(entity.get_player_resource())
end

function ent_c:get_entindex()
	return self.entindex
end

function ent_c:get_classname()
	return entity.get_classname(self.entindex)
end

function ent_c:set_prop(propname, value, array_index)
	if is_ent(array_index) then
		array_index = array_index.entindex
	end
	
	return array_index and entity.set_prop(self.entindex, propname, value, array_index) or entity.set_prop(self.entindex, propname, value)
end

function ent_c:get_prop(propname, array_index)
	if is_ent(array_index) then
		array_index = array_index.entindex
	end

	-- it wouldn't return multiple values otherwise :(
	if array_index then
		return entity.get_prop(self.entindex, propname, array_index)
	else
		return entity.get_prop(self.entindex, propname)
	end
end

function ent_c:is_enemy()
	return entity.is_enemy(self.entindex)
end

function ent_c:is_alive()
	return entity.is_alive(self.entindex)
end

function ent_c:is_dormant()
	return entity.is_dormant(self.entindex)
end

function ent_c:get_player_name()
	return entity.get_player_name(self.entindex)
end

function ent_c:get_player_weapon()
	return ent_c.new(entity.get_player_weapon(self.entindex))
end

function ent_c:hitbox_position(hitbox)
	return entity.hitbox_position(self.entindex, hitbox)
end

function ent_c:get_steam64()
	return entity.get_steam64(self.entindex)
end

function ent_c:get_bounding_box()
	return entity.get_bounding_box(self.entindex)
end

function ent_c:get_origin()
	return entity.get_origin(self.entindex)
end

function ent_c:get_esp_data()
	return entity.get_esp_data(self.entindex)
end

function ent_c:get_client_networkable()
	return get_client_networkable(self.entindex)
end

function ent_c:get_client_entity()
	return get_client_entity(self.entindex)
end

function ent_c:get_model()
	local client_ptr = ffi.cast('void***', self:get_client_networkable())
	local unknown_ptr = ffi.cast('void***', get_client_unknown(client_ptr))
	local renderable_ptr = ffi.cast('void***', get_client_renderable(unknown_ptr))

	return get_model(renderable_ptr)
end

function ent_c:get_sequence_activity(sequence)
	local hdr = get_studio_model(self:get_model())

	if not hdr then
		return -1
	end

	return get_sequence_activity(self:get_client_entity(), hdr, sequence)
end

function ent_c:get_anim_overlay(layer) -- (*(animation_layer_t)((char*)ent_ptr + 0x2980))[layer]
	local ent_ptr = ffi.cast('void***', self:get_client_entity())

	return ffi.cast(animation_layer_t, ffi.cast('char*', ent_ptr) + 0x2980)[0][layer] 
end

function ent_c:get_anim_state() -- (*(animation_state_t)((char*)ent_ptr + 0x3914))
	local ent_ptr = ffi.cast('void***', self:get_client_entity())

	return ffi.cast(animation_state_t, ffi.cast('char*', ent_ptr) + 0x3914)[0]
end

function ent_c:get_weapon_info()
	local ent_ptr = ffi.cast('void***', self:get_client_entity())

	return get_weapon_info(ent_ptr)
end

return ent_c