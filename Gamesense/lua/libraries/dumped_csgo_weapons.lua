slot0 = require("ffi")
slot2 = {
	"console_name",
	"primary_clip_size",
	"secondary_clip_size",
	"primary_default_clip_size",
	"secondary_default_clip_size",
	"primary_reserve_ammo_max",
	"secondary_reserve_ammo_max",
	"model_world",
	"model_player",
	"model_dropped",
	"sound_empty",
	"sound_single_shot",
	"sound_single_shot_accurate",
	"sound_burst",
	"sound_reload",
	"sound_special1",
	"sound_special2",
	"sound_special3",
	"sound_nearlyempty",
	"primary_ammo",
	"secondary_ammo",
	"item_name",
	"item_class",
	"itemflag_exhaustible",
	"model_right_handed",
	"is_melee_weapon",
	"weapon_weight",
	"primary_ammo_type",
	"item_gear_slot_position",
	"weapon_type_int",
	"in_game_price",
	"kill_award",
	"player_animation_extension",
	"cycletime",
	"cycletime_alt",
	"time_to_idle",
	"idle_interval",
	"is_full_auto",
	"damage",
	"headshot_multiplier",
	"armor_ratio",
	"bullets",
	"penetration",
	"flinch_velocity_modifier_large",
	"flinch_velocity_modifier_small",
	"range",
	"range_modifier",
	"throw_velocity",
	"has_silencer",
	"crosshair_min_distance",
	"crosshair_delta_distance",
	"max_player_speed",
	"max_player_speed_alt",
	"attack_movespeed_factor",
	"spread",
	"spread_alt",
	"inaccuracy_crouch",
	"inaccuracy_crouch_alt",
	"inaccuracy_stand",
	"inaccuracy_stand_alt",
	"inaccuracy_jump_initial",
	"inaccuracy_jump_apex",
	"inaccuracy_jump",
	"inaccuracy_jump_alt",
	"inaccuracy_land",
	"inaccuracy_land_alt",
	"inaccuracy_ladder",
	"inaccuracy_ladder_alt",
	"inaccuracy_fire",
	"inaccuracy_fire_alt",
	"inaccuracy_move",
	"inaccuracy_move_alt",
	"inaccuracy_reload",
	"recoil_seed",
	"recoil_angle",
	"recoil_angle_alt",
	"recoil_angle_variance",
	"recoil_angle_variance_alt",
	"recoil_magnitude",
	"recoil_magnitude_alt",
	"recoil_magnitude_variance",
	"recoil_magnitude_variance_alt",
	"spread_seed",
	"recovery_time_crouch",
	"recovery_time_stand",
	"recovery_time_crouch_final",
	"recovery_time_stand_final",
	"recovery_transition_start_bullet",
	"recovery_transition_end_bullet",
	"unzoom_after_shot",
	"hide_view_model_zoomed",
	"zoom_levels",
	"zoom_fov_1",
	"zoom_fov_2",
	"zoom_time_0",
	"zoom_time_1",
	"zoom_time_2",
	"addon_location",
	"addon_scale",
	"eject_brass_effect",
	"tracer_effect",
	"tracer_frequency",
	"tracer_frequency_alt",
	"muzzle_flash_effect_1st_person",
	"muzzle_flash_effect_1st_person_alt",
	"muzzle_flash_effect_3rd_person",
	"muzzle_flash_effect_3rd_person_alt",
	"heat_effect",
	"heat_per_shot",
	"zoom_in_sound",
	"zoom_out_sound",
	"inaccuracy_alt_sound_threshold",
	"bot_audible_range",
	"has_burst_mode",
	"is_revolver"
}
slot3 = {
	[0] = "knife",
	"pistol",
	"smg",
	"rifle",
	"shotgun",
	"sniperrifle",
	"machinegun",
	"c4",
	nil,
	"grenade",
	nil,
	"stackableitem",
	"fists",
	"breachcharge",
	"bumpmine",
	"tablet",
	"melee",
	nil,
	nil,
	"equipment"
}
slot4 = {
	[31.0] = "taser"
}
slot8 = slot0.typeof("char*")
slot9 = panorama.loadstring([[
return {
	get_weapon_info: (idx) => {
		let itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(idx)

		if(itemid && itemid > 0) {
			let data = {
				schema: JSON.parse(InventoryAPI.BuildItemSchemaDefJSON(itemid)),
				slot: InventoryAPI.GetSlot(itemid),
				image_hud: `materials/panorama/images/icons/equipment/${InventoryAPI.GetHudIconFileName(idx)}.svg`,
				image_inventory: `resource/Flash/${InventoryAPI.GetItemInventoryImage(itemid)}.png`
			}

			return JSON.stringify(data)
		} else {
			return "null"
		}
	},
	localize: $.Localize
}
]], "CSGOMainMenu")()
slot10 = {}
slot11 = {}

for slot15 = 1, 1000 do
	if vtable_thunk(2, [[
struct {
	char		 __pad_0x0000[4];					   // 0x0000
	char*		console_name;						  // 0x0004
	char		 __pad_0x0008[12];					  // 0x0008
	int		  primary_clip_size;					 // 0x0014
	int		  secondary_clip_size;				   // 0x0018
	int		  primary_default_clip_size;			 // 0x001c
	int		  secondary_default_clip_size;		   // 0x0020
	int		  primary_reserve_ammo_max;			  // 0x0024
	int		  secondary_reserve_ammo_max;			// 0x0028
	char*		model_world;						   // 0x002c
	char*		model_player;						  // 0x0030
	char*		model_dropped;						 // 0x0034
	char*		sound_empty;						   // 0x0038
	char*		sound_single_shot;					 // 0x003c
	char*		sound_single_shot_accurate;			// 0x0040
	char		 __pad_0x0044[12];					  // 0x0044
	char*		sound_burst;						   // 0x0050
	char*		sound_reload;						  // 0x0054
	char		 __pad_0x0058[16];					  // 0x0058
	char*		sound_special1;						// 0x0068
	char*		sound_special2;						// 0x006c
	char*		sound_special3;						// 0x0070
	char		 __pad_0x0074[4];					   // 0x0074
	char*		sound_nearlyempty;					 // 0x0078
	char		 __pad_0x007c[4];					   // 0x007c
	char*		primary_ammo;						  // 0x0080
	char*		secondary_ammo;						// 0x0084
	char*		item_name;							 // 0x0088
	char*		item_class;							// 0x008c
	bool		 itemflag_exhaustible;				  // 0x0090
	bool		 model_right_handed;					// 0x0091
	bool		 is_melee_weapon;					   // 0x0092
	char		 __pad_0x0093[9];					   // 0x0093
	int		  weapon_weight;						 // 0x009c
	int		  primary_ammo_type;					 // 0x00a0
	char		 __pad_0x00a4[4];					   // 0x00a4
	int		  item_gear_slot_position;			   // 0x00a8
	char		 __pad_0x00ac[28];					  // 0x00ac
	int		  weapon_type_int;					   // 0x00c8
	char		 __pad_0x00cc[4];					   // 0x00cc
	int		  in_game_price;						 // 0x00d0
	int		  kill_award;							// 0x00d4
	char*		player_animation_extension;			// 0x00d8
	float		cycletime;							 // 0x00dc
	float		cycletime_alt;						 // 0x00e0
	float		time_to_idle;						  // 0x00e4
	float		idle_interval;						 // 0x00e8
	bool		 is_full_auto;						  // 0x00ec
	char		 __pad_0x00ed[3];					   // 0x00ed
	int		  damage;								// 0x00f0
	float		headshot_multiplier;				   // 0x00f4
	float		armor_ratio;						   // 0x00f8
	int		  bullets;							   // 0x00fc
	float		penetration;						   // 0x0100
	float		flinch_velocity_modifier_large;		// 0x0104
	float		flinch_velocity_modifier_small;		// 0x0108
	float		range;								 // 0x010c
	float		range_modifier;						// 0x0110
	float		throw_velocity;						// 0x0114
	char		 __pad_0x0118[12];					  // 0x0118
	int		  has_silencer;						  // 0x0124
	char		 __pad_0x0128[4];					   // 0x0128
	int		  crosshair_min_distance;				// 0x012c
	int		  crosshair_delta_distance;			  // 0x0130
	float		max_player_speed;					  // 0x0134
	float		max_player_speed_alt;				  // 0x0138
	float		attack_movespeed_factor;			   // 0x013c
	float		spread;								// 0x0140
	float		spread_alt;							// 0x0144
	float		inaccuracy_crouch;					 // 0x0148
	float		inaccuracy_crouch_alt;				 // 0x014c
	float		inaccuracy_stand;					  // 0x0150
	float		inaccuracy_stand_alt;				  // 0x0154
	float		inaccuracy_jump_initial;			   // 0x0158
	float		inaccuracy_jump_apex;				  // 0x015c
	float		inaccuracy_jump;					   // 0x0160
	float		inaccuracy_jump_alt;				   // 0x0164
	float		inaccuracy_land;					   // 0x0168
	float		inaccuracy_land_alt;				   // 0x016c
	float		inaccuracy_ladder;					 // 0x0170
	float		inaccuracy_ladder_alt;				 // 0x0174
	float		inaccuracy_fire;					   // 0x0178
	float		inaccuracy_fire_alt;				   // 0x017c
	float		inaccuracy_move;					   // 0x0180
	float		inaccuracy_move_alt;				   // 0x0184
	float		inaccuracy_reload;					 // 0x0188
	int		  recoil_seed;						   // 0x018c
	float		recoil_angle;						  // 0x0190
	float		recoil_angle_alt;					  // 0x0194
	float		recoil_angle_variance;				 // 0x0198
	float		recoil_angle_variance_alt;			 // 0x019c
	float		recoil_magnitude;					  // 0x01a0
	float		recoil_magnitude_alt;				  // 0x01a4
	float		recoil_magnitude_variance;			 // 0x01a8
	float		recoil_magnitude_variance_alt;		 // 0x01ac
	int		  spread_seed;						   // 0x01b0
	float		recovery_time_crouch;				  // 0x01b4
	float		recovery_time_stand;				   // 0x01b8
	float		recovery_time_crouch_final;			// 0x01bc
	float		recovery_time_stand_final;			 // 0x01c0
	int		  recovery_transition_start_bullet;	  // 0x01c4
	int		  recovery_transition_end_bullet;		// 0x01c8
	bool		 unzoom_after_shot;					 // 0x01cc
	bool		 hide_view_model_zoomed;				// 0x01cd
	char		 __pad_0x01ce[2];					   // 0x01ce
	int		  zoom_levels;						   // 0x01d0
	int		  zoom_fov_1;							// 0x01d4
	int		  zoom_fov_2;							// 0x01d8
	int		  zoom_time_0;						   // 0x01dc
	int		  zoom_time_1;						   // 0x01e0
	int		  zoom_time_2;						   // 0x01e4
	char*		addon_location;						// 0x01e8
	char		 __pad_0x01ec[4];					   // 0x01ec
	float		addon_scale;						   // 0x01f0
	char*		eject_brass_effect;					// 0x01f4
	char*		tracer_effect;						 // 0x01f8
	int		  tracer_frequency;					  // 0x01fc
	int		  tracer_frequency_alt;				  // 0x0200
	char*		muzzle_flash_effect_1st_person;		// 0x0204
	char*		muzzle_flash_effect_1st_person_alt;	// 0x0208
	char*		muzzle_flash_effect_3rd_person;		// 0x020c
	char*		muzzle_flash_effect_3rd_person_alt;	// 0x0210
	char*		heat_effect;						   // 0x0214
	float		heat_per_shot;						 // 0x0218
	char*		zoom_in_sound;						 // 0x021c
	char*		zoom_out_sound;						// 0x0220
	char		 __pad_0x0224[4];					   // 0x0224
	float		inaccuracy_alt_sound_threshold;		// 0x0228
	float		bot_audible_range;					 // 0x022c
	char		 __pad_0x0230[12];					  // 0x0230
	bool		 has_burst_mode;						// 0x023c
	bool		 is_revolver;						   // 0x023d
}
]] .. "*(__thiscall*)(void*, unsigned int)") or error("invalid GetCSWeaponInfo index")(slot0.cast("void****", slot0.cast("char*", client.find_signature("client.dll", "\\x8b5\\xcc\\xcc\\xcc\\xcc\\xff\\xb7\\xc0") or error("IWeaponSystem signature invalid")) + 2)[0], slot15) ~= nil then
		slot17 = {
			[slot22] = slot0.string(slot23),
			idx = slot15,
			type = slot4[slot15] or slot3[slot16.weapon_type_int]
		}

		for slot21 = 1, #slot2 do
			slot24, slot25 = pcall(slot0.typeof, slot16[slot2[slot21]])

			if slot24 and slot25 == slot8 then
				-- Nothing
			else
				slot17[slot22] = slot23
			end
		end

		slot17.name = slot9.localize(slot17.item_name)
		slot17.raw = slot16
		slot17.is_grenade = slot17.type == "grenade"
		slot17.is_taser = slot17.type == "taser"
		slot17.is_knife = slot17.type == "knife"
		slot17.is_gun = slot17.type == "pistol" or slot17.type == "smg" or slot17.type == "rifle" or slot17.type == "shotgun" or slot17.type == "sniperrifle" or slot17.type == "machinegun"

		if json.parse(slot9.get_weapon_info(slot15)) ~= nil then
			for slot22, slot23 in pairs(slot18) do
				slot17[slot22] = slot23
			end
		end

		slot10[slot15] = slot17
		slot11[slot17.console_name] = slot17
	end
end

function slot11.get_player_weapon(slot0, slot1)
	return uv0(slot0, entity.get_player_weapon(slot1))
end

function slot11.get_player_weapons(slot0, slot1)
	slot2 = {}

	for slot6 = 0, 63 do
		if entity.get_prop(slot1, "m_hMyWeapons", slot6) ~= nil and slot7 > 0 then
			table.insert(slot2, uv0(slot0, slot7))
		end
	end

	return slot2
end

setmetatable(slot10, {
	__metatable = false,
	__index = slot11,
	__call = function (slot0, slot1)
		if slot0 ~= uv0 or type(slot1) ~= "number" or slot1 < 0 or slot1 > 8191 then
			return
		end

		return uv0[entity.get_prop(slot1, "m_iItemDefinitionIndex")]
	end
})

return slot10
