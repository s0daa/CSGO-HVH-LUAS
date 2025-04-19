slot0 = require("ffi")
slot1 = require("gamesense/csgo_weapons")
slot2 = entity.get_local_player
slot5 = entity.get_all
slot10 = entity.get_player_resource
slot14 = entity.get_game_rules
slot17 = entity.get_player_weapon
slot18 = entity.get_players
slot20 = client.userid_to_entindex
slot28 = string.format
slot29 = slot0.cast
slot31 = slot0.typeof([[
	struct {
		char		pad0[0x18];
		uint32_t	sequence;
		float		prev_cycle;
		float		weight;
		float		weight_delta_rate;
		float		playback_rate;
		float		cycle;
		void*		entity;
		char		pad1[0x4];
	} **
]])
slot32 = slot0.typeof([[
	struct {
		char	pad0[0x18];
		float	anim_update_timer;
		char	pad1[0xC];
		float	started_moving_time;
		float	last_move_time;
		char	pad2[0x10];
		float	last_lby_time;
		char	pad3[0x8];
		float	run_amount;
		char	pad4[0x10];
		void*	entity;
		void*	active_weapon;
		void*	last_active_weapon;
		float	last_client_side_animation_update_time;
		int		last_client_side_animation_update_framecount;
		float	eye_timer;
		float	eye_angles_y;
		float	eye_angles_x;
		float	goal_feet_yaw;
		float	current_feet_yaw;
		float	torso_yaw;
		float	last_move_yaw;
		float	lean_amount;
		char	pad5[0x4];
		float	feet_cycle;
		float	feet_yaw_rate;
		char	pad6[0x4];
		float	duck_amount;
		float	landing_duck_amount;
		char	pad7[0x4];
		float	current_origin[3];
		float	last_origin[3];
		float	velocity_x;
		float	velocity_y;
		char	pad8[0x4];
		float	unknown_float1;
		char	pad9[0x8];
		float	unknown_float2;
		float	unknown_float3;
		float	unknown;
		float	m_velocity;
		float	jump_fall_velocity;
		float	clamped_velocity;
		float	feet_speed_forwards_or_sideways;
		float	feet_speed_unknown_forwards_or_sideways;
		float	last_time_started_moving;
		float	last_time_stopped_moving;
		bool	on_ground;
		bool	hit_in_ground_animation;
		char	pad10[0x4];
		float	time_since_in_air;
		float	last_origin_z;
		float	head_from_ground_distance_standing;
		float	stop_to_full_running_fraction;
		char	pad11[0x4];
		float	magic_fraction;
		char	pad12[0x3C];
		float	world_force;
		char	pad13[0x1CA];
		float	min_yaw;
		float	max_yaw;
	} **
]])
slot33 = slot0.typeof("$ *", slot0.typeof([[
	struct {
		char pad[0x64];
		int index;
	}
]]))
slot34 = slot0.typeof("char*")
slot35 = vtable_bind("client.dll", "VClientEntityList003", 0, "void*(__thiscall*)(void*, int)")
slot36 = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
slot37 = vtable_thunk(0, "void*(__thiscall*)(void*)")
slot39 = slot0.cast("int(__thiscall*)(void*, int)", client.find_signature("client.dll", "U\\x8b\\xecS\\x8b]V\\x8b\\xf1\\x83") or error("invalid GetSequenceActivity signature"))
slot41 = {
	new = function (slot0)
		if slot0 == nil then
			return
		end

		if uv0(slot0) == nil then
			return
		end

		return uv1(uv2, slot1)
	end,
	new_from_userid = function (slot0)
		return uv0(uv1(slot0))
	end,
	get_local_player = function ()
		return uv0(uv1())
	end,
	get_all = function (...)
		for slot4, slot5 in ipairs(uv0(...)) do
			slot0[slot4] = uv1(slot5)
		end

		return slot0
	end,
	get_player_resource = function ()
		return uv0(uv1())
	end,
	get_game_rules = function ()
		return uv0(uv1())
	end,
	get_players = function (...)
		for slot4, slot5 in ipairs(uv0(...)) do
			slot0[slot4] = uv1(slot5)
		end

		return slot0
	end,
	get_player_weapon = function (slot0)
		return uv0(uv1(slot0:get_entindex()))
	end,
	get_entindex = function (slot0)
		if slot0 == nil then
			return
		end

		return slot0.index
	end,
	get_anim_overlay = function (slot0, slot1)
		return uv0(uv1, uv0(uv2, slot0) + 10640)[0][slot1 or 1]
	end,
	get_anim_state = function (slot0)
		return uv0(uv1, uv0(uv2, slot0) + 39264)[0][0]
	end,
	get_sequence_activity = function (slot0, slot1)
		if slot0 == nil then
			return
		end

		return uv0(slot0, slot1)
	end,
	get_client_networkable = function (slot0)
		if uv0(slot0:get_entindex()) == nil then
			return
		end

		return slot1
	end,
	get_client_unknown = function (slot0)
		if slot0:get_client_networkable() == nil then
			return
		end

		if uv0(slot1) == nil then
			return
		end

		return slot2
	end,
	get_weapon_info = function (slot0)
		return uv0[slot0:get_prop("m_iItemDefinitionIndex")]
	end
}

function slot42(slot0, slot1)
	uv0[slot1] = function (slot0, ...)
		return uv0(slot0:get_entindex(), ...)
	end
end

slot42(entity.is_enemy, "is_enemy")
slot42(entity.get_bounding_box, "get_bounding_box")
slot42(entity.set_prop, "set_prop")
slot42(entity.is_alive, "is_alive")
slot42(entity.get_steam64, "get_steam64")
slot42(entity.get_classname, "get_classname")
slot42(entity.get_esp_data, "get_esp_data")
slot42(entity.get_origin, "get_origin")
slot42(entity.is_dormant, "is_dormant")
slot42(entity.get_player_name, "get_player_name")
slot42(entity.hitbox_position, "hitbox_position")
slot42(entity.get_prop, "get_prop")
slot42(client.draw_hitboxes, "draw_hitboxes")
slot42(client.scale_damage, "scale_damage")
slot42(client.trace_line, "trace_line")
slot42(client.trace_bullet, "trace_bullet")
slot42(materialsystem.get_model_materials, "get_model_materials")
slot42(plist.set, "plist_set")
slot42(plist.get, "plist_get")
slot0.metatype(slot30, {
	__index = slot41,
	__tostring = function (slot0)
		return uv0("%d", slot0:get_entindex())
	end,
	__concat = function (slot0, slot1)
		return uv0("%s%s", slot0, slot1)
	end
})

return setmetatable(slot41, {
	__metatable = true,
	__call = function (slot0, slot1)
		return uv0(slot1)
	end
})
