-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = "struct {\n\tchar\t\t __pad_0x0000[4];\t\t\t\t\t   // 0x0000\n\tchar*\t\tconsole_name;\t\t\t\t\t\t  // 0x0004\n\tchar\t\t __pad_0x0008[12];\t\t\t\t\t  // 0x0008\n\tint\t\t  primary_clip_size;\t\t\t\t\t // 0x0014\n\tint\t\t  secondary_clip_size;\t\t\t\t   // 0x0018\n\tint\t\t  primary_default_clip_size;\t\t\t // 0x001c\n\tint\t\t  secondary_default_clip_size;\t\t   // 0x0020\n\tint\t\t  primary_reserve_ammo_max;\t\t\t  // 0x0024\n\tint\t\t  secondary_reserve_ammo_max;\t\t\t// 0x0028\n\tchar*\t\tmodel_world;\t\t\t\t\t\t   // 0x002c\n\tchar*\t\tmodel_player;\t\t\t\t\t\t  // 0x0030\n\tchar*\t\tmodel_dropped;\t\t\t\t\t\t // 0x0034\n\tchar*\t\tsound_empty;\t\t\t\t\t\t   // 0x0038\n\tchar*\t\tsound_single_shot;\t\t\t\t\t // 0x003c\n\tchar*\t\tsound_single_shot_accurate;\t\t\t// 0x0040\n\tchar\t\t __pad_0x0044[12];\t\t\t\t\t  // 0x0044\n\tchar*\t\tsound_burst;\t\t\t\t\t\t   // 0x0050\n\tchar*\t\tsound_reload;\t\t\t\t\t\t  // 0x0054\n\tchar\t\t __pad_0x0058[16];\t\t\t\t\t  // 0x0058\n\tchar*\t\tsound_special1;\t\t\t\t\t\t// 0x0068\n\tchar*\t\tsound_special2;\t\t\t\t\t\t// 0x006c\n\tchar*\t\tsound_special3;\t\t\t\t\t\t// 0x0070\n\tchar\t\t __pad_0x0074[4];\t\t\t\t\t   // 0x0074\n\tchar*\t\tsound_nearlyempty;\t\t\t\t\t // 0x0078\n\tchar\t\t __pad_0x007c[4];\t\t\t\t\t   // 0x007c\n\tchar*\t\tprimary_ammo;\t\t\t\t\t\t  // 0x0080\n\tchar*\t\tsecondary_ammo;\t\t\t\t\t\t// 0x0084\n\tchar*\t\titem_name;\t\t\t\t\t\t\t // 0x0088\n\tchar*\t\titem_class;\t\t\t\t\t\t\t// 0x008c\n\tbool\t\t itemflag_exhaustible;\t\t\t\t  // 0x0090\n\tbool\t\t model_right_handed;\t\t\t\t\t// 0x0091\n\tbool\t\t is_melee_weapon;\t\t\t\t\t   // 0x0092\n\tchar\t\t __pad_0x0093[9];\t\t\t\t\t   // 0x0093\n\tint\t\t  weapon_weight;\t\t\t\t\t\t // 0x009c\n\tint\t\t  primary_ammo_type;\t\t\t\t\t // 0x00a0\n\tchar\t\t __pad_0x00a4[4];\t\t\t\t\t   // 0x00a4\n\tint\t\t  item_gear_slot_position;\t\t\t   // 0x00a8\n\tchar\t\t __pad_0x00ac[28];\t\t\t\t\t  // 0x00ac\n\tint\t\t  weapon_type_int;\t\t\t\t\t   // 0x00c8\n\tchar\t\t __pad_0x00cc[4];\t\t\t\t\t   // 0x00cc\n\tint\t\t  in_game_price;\t\t\t\t\t\t // 0x00d0\n\tint\t\t  kill_award;\t\t\t\t\t\t\t// 0x00d4\n\tchar*\t\tplayer_animation_extension;\t\t\t// 0x00d8\n\tfloat\t\tcycletime;\t\t\t\t\t\t\t // 0x00dc\n\tfloat\t\tcycletime_alt;\t\t\t\t\t\t // 0x00e0\n\tfloat\t\ttime_to_idle;\t\t\t\t\t\t  // 0x00e4\n\tfloat\t\tidle_interval;\t\t\t\t\t\t // 0x00e8\n\tbool\t\t is_full_auto;\t\t\t\t\t\t  // 0x00ec\n\tchar\t\t __pad_0x00ed[3];\t\t\t\t\t   // 0x00ed\n\tint\t\t  damage;\t\t\t\t\t\t\t\t// 0x00f0\n\tfloat\t\theadshot_multiplier;\t\t\t\t   // 0x00f4\n\tfloat\t\tarmor_ratio;\t\t\t\t\t\t   // 0x00f8\n\tint\t\t  bullets;\t\t\t\t\t\t\t   // 0x00fc\n\tfloat\t\tpenetration;\t\t\t\t\t\t   // 0x0100\n\tfloat\t\tflinch_velocity_modifier_large;\t\t// 0x0104\n\tfloat\t\tflinch_velocity_modifier_small;\t\t// 0x0108\n\tfloat\t\trange;\t\t\t\t\t\t\t\t // 0x010c\n\tfloat\t\trange_modifier;\t\t\t\t\t\t// 0x0110\n\tfloat\t\tthrow_velocity;\t\t\t\t\t\t// 0x0114\n\tchar\t\t __pad_0x0118[12];\t\t\t\t\t  // 0x0118\n\tint\t\t  has_silencer;\t\t\t\t\t\t  // 0x0124\n\tchar\t\t __pad_0x0128[4];\t\t\t\t\t   // 0x0128\n\tint\t\t  crosshair_min_distance;\t\t\t\t// 0x012c\n\tint\t\t  crosshair_delta_distance;\t\t\t  // 0x0130\n\tfloat\t\tmax_player_speed;\t\t\t\t\t  // 0x0134\n\tfloat\t\tmax_player_speed_alt;\t\t\t\t  // 0x0138\n\tfloat\t\tattack_movespeed_factor;\t\t\t   // 0x013c\n\tfloat\t\tspread;\t\t\t\t\t\t\t\t// 0x0140\n\tfloat\t\tspread_alt;\t\t\t\t\t\t\t// 0x0144\n\tfloat\t\tinaccuracy_crouch;\t\t\t\t\t // 0x0148\n\tfloat\t\tinaccuracy_crouch_alt;\t\t\t\t // 0x014c\n\tfloat\t\tinaccuracy_stand;\t\t\t\t\t  // 0x0150\n\tfloat\t\tinaccuracy_stand_alt;\t\t\t\t  // 0x0154\n\tfloat\t\tinaccuracy_jump_initial;\t\t\t   // 0x0158\n\tfloat\t\tinaccuracy_jump_apex;\t\t\t\t  // 0x015c\n\tfloat\t\tinaccuracy_jump;\t\t\t\t\t   // 0x0160\n\tfloat\t\tinaccuracy_jump_alt;\t\t\t\t   // 0x0164\n\tfloat\t\tinaccuracy_land;\t\t\t\t\t   // 0x0168\n\tfloat\t\tinaccuracy_land_alt;\t\t\t\t   // 0x016c\n\tfloat\t\tinaccuracy_ladder;\t\t\t\t\t // 0x0170\n\tfloat\t\tinaccuracy_ladder_alt;\t\t\t\t // 0x0174\n\tfloat\t\tinaccuracy_fire;\t\t\t\t\t   // 0x0178\n\tfloat\t\tinaccuracy_fire_alt;\t\t\t\t   // 0x017c\n\tfloat\t\tinaccuracy_move;\t\t\t\t\t   // 0x0180\n\tfloat\t\tinaccuracy_move_alt;\t\t\t\t   // 0x0184\n\tfloat\t\tinaccuracy_reload;\t\t\t\t\t // 0x0188\n\tint\t\t  recoil_seed;\t\t\t\t\t\t   // 0x018c\n\tfloat\t\trecoil_angle;\t\t\t\t\t\t  // 0x0190\n\tfloat\t\trecoil_angle_alt;\t\t\t\t\t  // 0x0194\n\tfloat\t\trecoil_angle_variance;\t\t\t\t // 0x0198\n\tfloat\t\trecoil_angle_variance_alt;\t\t\t // 0x019c\n\tfloat\t\trecoil_magnitude;\t\t\t\t\t  // 0x01a0\n\tfloat\t\trecoil_magnitude_alt;\t\t\t\t  // 0x01a4\n\tfloat\t\trecoil_magnitude_variance;\t\t\t // 0x01a8\n\tfloat\t\trecoil_magnitude_variance_alt;\t\t // 0x01ac\n\tint\t\t  spread_seed;\t\t\t\t\t\t   // 0x01b0\n\tfloat\t\trecovery_time_crouch;\t\t\t\t  // 0x01b4\n\tfloat\t\trecovery_time_stand;\t\t\t\t   // 0x01b8\n\tfloat\t\trecovery_time_crouch_final;\t\t\t// 0x01bc\n\tfloat\t\trecovery_time_stand_final;\t\t\t // 0x01c0\n\tint\t\t  recovery_transition_start_bullet;\t  // 0x01c4\n\tint\t\t  recovery_transition_end_bullet;\t\t// 0x01c8\n\tbool\t\t unzoom_after_shot;\t\t\t\t\t // 0x01cc\n\tbool\t\t hide_view_model_zoomed;\t\t\t\t// 0x01cd\n\tchar\t\t __pad_0x01ce[2];\t\t\t\t\t   // 0x01ce\n\tint\t\t  zoom_levels;\t\t\t\t\t\t   // 0x01d0\n\tint\t\t  zoom_fov_1;\t\t\t\t\t\t\t// 0x01d4\n\tint\t\t  zoom_fov_2;\t\t\t\t\t\t\t// 0x01d8\n\tint\t\t  zoom_time_0;\t\t\t\t\t\t   // 0x01dc\n\tint\t\t  zoom_time_1;\t\t\t\t\t\t   // 0x01e0\n\tint\t\t  zoom_time_2;\t\t\t\t\t\t   // 0x01e4\n\tchar*\t\taddon_location;\t\t\t\t\t\t// 0x01e8\n\tchar\t\t __pad_0x01ec[4];\t\t\t\t\t   // 0x01ec\n\tfloat\t\taddon_scale;\t\t\t\t\t\t   // 0x01f0\n\tchar*\t\teject_brass_effect;\t\t\t\t\t// 0x01f4\n\tchar*\t\ttracer_effect;\t\t\t\t\t\t // 0x01f8\n\tint\t\t  tracer_frequency;\t\t\t\t\t  // 0x01fc\n\tint\t\t  tracer_frequency_alt;\t\t\t\t  // 0x0200\n\tchar*\t\tmuzzle_flash_effect_1st_person;\t\t// 0x0204\n\tchar*\t\tmuzzle_flash_effect_1st_person_alt;\t// 0x0208\n\tchar*\t\tmuzzle_flash_effect_3rd_person;\t\t// 0x020c\n\tchar*\t\tmuzzle_flash_effect_3rd_person_alt;\t// 0x0210\n\tchar*\t\theat_effect;\t\t\t\t\t\t   // 0x0214\n\tfloat\t\theat_per_shot;\t\t\t\t\t\t // 0x0218\n\tchar*\t\tzoom_in_sound;\t\t\t\t\t\t // 0x021c\n\tchar*\t\tzoom_out_sound;\t\t\t\t\t\t// 0x0220\n\tchar\t\t __pad_0x0224[4];\t\t\t\t\t   // 0x0224\n\tfloat\t\tinaccuracy_alt_sound_threshold;\t\t// 0x0228\n\tfloat\t\tbot_audible_range;\t\t\t\t\t // 0x022c\n\tchar\t\t __pad_0x0230[12];\t\t\t\t\t  // 0x0230\n\tbool\t\t has_burst_mode;\t\t\t\t\t\t// 0x023c\n\tbool\t\t is_revolver;\t\t\t\t\t\t   // 0x023d\n}\n"
local var_0_2 = {
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
local var_0_3 = {
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
local var_0_4 = {
	[31] = "taser"
}
local var_0_5 = client.find_signature("client.dll", "\x8B5\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0") or error("IWeaponSystem signature invalid")
local var_0_6 = var_0_0.cast("void****", var_0_0.cast("char*", var_0_5) + 2)[0]
local var_0_7 = vtable_thunk(2, var_0_1 .. "*(__thiscall*)(void*, unsigned int)") or error("invalid GetCSWeaponInfo index")
local var_0_8 = var_0_0.typeof("char*")
local var_0_9 = panorama.loadstring("return {\n\tget_weapon_info: (idx) => {\n\t\tlet itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(idx)\n\n\t\tif(itemid && itemid > 0) {\n\t\t\tlet data = {\n\t\t\t\tschema: JSON.parse(InventoryAPI.BuildItemSchemaDefJSON(itemid)),\n\t\t\t\tslot: InventoryAPI.GetSlot(itemid),\n\t\t\t\timage_hud: `materials/panorama/images/icons/equipment/${InventoryAPI.GetHudIconFileName(idx)}.svg`,\n\t\t\t\timage_inventory: `resource/Flash/${InventoryAPI.GetItemInventoryImage(itemid)}.png`\n\t\t\t}\n\n\t\t\treturn JSON.stringify(data)\n\t\t} else {\n\t\t\treturn \"null\"\n\t\t}\n\t},\n\tlocalize: $.Localize\n}\n", "CSGOMainMenu")()
local var_0_10 = {}
local var_0_11 = {}

for iter_0_0 = 1, 1000 do
	local var_0_12 = var_0_7(var_0_6, iter_0_0)

	if var_0_12 ~= nil then
		local var_0_13 = {}

		for iter_0_1 = 1, #var_0_2 do
			local var_0_14 = var_0_2[iter_0_1]
			local var_0_15 = var_0_12[var_0_14]
			local var_0_16, var_0_17 = pcall(var_0_0.typeof, var_0_15)

			if var_0_16 and var_0_17 == var_0_8 then
				var_0_13[var_0_14] = var_0_0.string(var_0_15)
			else
				var_0_13[var_0_14] = var_0_15
			end
		end

		var_0_13.idx = iter_0_0
		var_0_13.type = var_0_4[iter_0_0] or var_0_3[var_0_12.weapon_type_int]
		var_0_13.name = var_0_9.localize(var_0_13.item_name)
		var_0_13.raw = var_0_12
		var_0_13.is_grenade = var_0_13.type == "grenade"
		var_0_13.is_taser = var_0_13.type == "taser"
		var_0_13.is_knife = var_0_13.type == "knife"
		var_0_13.is_gun = var_0_13.type == "pistol" or var_0_13.type == "smg" or var_0_13.type == "rifle" or var_0_13.type == "shotgun" or var_0_13.type == "sniperrifle" or var_0_13.type == "machinegun"

		local var_0_18 = json.parse(var_0_9.get_weapon_info(iter_0_0))

		if var_0_18 ~= nil then
			for iter_0_2, iter_0_3 in pairs(var_0_18) do
				var_0_13[iter_0_2] = iter_0_3
			end
		end

		var_0_10[iter_0_0] = var_0_13
		var_0_11[var_0_13.console_name] = var_0_13
	end
end

local function var_0_19(arg_1_0, arg_1_1)
	if arg_1_0 ~= var_0_10 or type(arg_1_1) ~= "number" or arg_1_1 < 0 or arg_1_1 > 8191 then
		return
	end

	local var_1_0 = entity.get_prop(arg_1_1, "m_iItemDefinitionIndex")

	return var_0_10[var_1_0]
end

function var_0_11.get_player_weapon(arg_2_0, arg_2_1)
	return var_0_19(arg_2_0, entity.get_player_weapon(arg_2_1))
end

function var_0_11.get_player_weapons(arg_3_0, arg_3_1)
	local var_3_0 = {}

	for iter_3_0 = 0, 63 do
		local var_3_1 = entity.get_prop(arg_3_1, "m_hMyWeapons", iter_3_0)

		if var_3_1 ~= nil and var_3_1 > 0 then
			table.insert(var_3_0, var_0_19(arg_3_0, var_3_1))
		end
	end

	return var_3_0
end

setmetatable(var_0_10, {
	__metatable = false,
	__index = var_0_11,
	__call = var_0_19
})

return var_0_10
