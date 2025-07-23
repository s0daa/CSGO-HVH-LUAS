-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/csgo_weapons")
local var_0_2 = entity.get_local_player
local var_0_3 = entity.is_enemy
local var_0_4 = entity.get_bounding_box
local var_0_5 = entity.get_all
local var_0_6 = entity.set_prop
local var_0_7 = entity.is_alive
local var_0_8 = entity.get_steam64
local var_0_9 = entity.get_classname
local var_0_10 = entity.get_player_resource
local var_0_11 = entity.get_esp_data
local var_0_12 = entity.is_dormant
local var_0_13 = entity.get_player_name
local var_0_14 = entity.get_game_rules
local var_0_15 = entity.get_origin
local var_0_16 = entity.hitbox_position
local var_0_17 = entity.get_player_weapon
local var_0_18 = entity.get_players
local var_0_19 = entity.get_prop
local var_0_20 = client.userid_to_entindex
local var_0_21 = client.draw_hitboxes
local var_0_22 = client.scale_damage
local var_0_23 = client.trace_line
local var_0_24 = client.trace_bullet
local var_0_25 = materialsystem.get_model_materials
local var_0_26 = plist.set
local var_0_27 = plist.get
local var_0_28 = string.format
local var_0_29 = var_0_0.cast
local var_0_30 = var_0_0.typeof("\tstruct {\n\t\tchar pad[0x64];\n\t\tint index;\n\t}\n")
local var_0_31 = var_0_0.typeof("\tstruct {\n\t\tchar\t\tpad0[0x18];\n\t\tuint32_t\tsequence;\n\t\tfloat\t\tprev_cycle;\n\t\tfloat\t\tweight;\n\t\tfloat\t\tweight_delta_rate;\n\t\tfloat\t\tplayback_rate;\n\t\tfloat\t\tcycle;\n\t\tvoid*\t\tentity;\n\t\tchar\t\tpad1[0x4];\n\t} **\n")
local var_0_32 = var_0_0.typeof("\tstruct {\n\t\tchar\tpad0[0x18];\n\t\tfloat\tanim_update_timer;\n\t\tchar\tpad1[0xC];\n\t\tfloat\tstarted_moving_time;\n\t\tfloat\tlast_move_time;\n\t\tchar\tpad2[0x10];\n\t\tfloat\tlast_lby_time;\n\t\tchar\tpad3[0x8];\n\t\tfloat\trun_amount;\n\t\tchar\tpad4[0x10];\n\t\tvoid*\tentity;\n\t\tvoid*\tactive_weapon;\n\t\tvoid*\tlast_active_weapon;\n\t\tfloat\tlast_client_side_animation_update_time;\n\t\tint\t\tlast_client_side_animation_update_framecount;\n\t\tfloat\teye_timer;\n\t\tfloat\teye_angles_y;\n\t\tfloat\teye_angles_x;\n\t\tfloat\tgoal_feet_yaw;\n\t\tfloat\tcurrent_feet_yaw;\n\t\tfloat\ttorso_yaw;\n\t\tfloat\tlast_move_yaw;\n\t\tfloat\tlean_amount;\n\t\tchar\tpad5[0x4];\n\t\tfloat\tfeet_cycle;\n\t\tfloat\tfeet_yaw_rate;\n\t\tchar\tpad6[0x4];\n\t\tfloat\tduck_amount;\n\t\tfloat\tlanding_duck_amount;\n\t\tchar\tpad7[0x4];\n\t\tfloat\tcurrent_origin[3];\n\t\tfloat\tlast_origin[3];\n\t\tfloat\tvelocity_x;\n\t\tfloat\tvelocity_y;\n\t\tchar\tpad8[0x4];\n\t\tfloat\tunknown_float1;\n\t\tchar\tpad9[0x8];\n\t\tfloat\tunknown_float2;\n\t\tfloat\tunknown_float3;\n\t\tfloat\tunknown;\n\t\tfloat\tm_velocity;\n\t\tfloat\tjump_fall_velocity;\n\t\tfloat\tclamped_velocity;\n\t\tfloat\tfeet_speed_forwards_or_sideways;\n\t\tfloat\tfeet_speed_unknown_forwards_or_sideways;\n\t\tfloat\tlast_time_started_moving;\n\t\tfloat\tlast_time_stopped_moving;\n\t\tbool\ton_ground;\n\t\tbool\thit_in_ground_animation;\n\t\tchar\tpad10[0x4];\n\t\tfloat\ttime_since_in_air;\n\t\tfloat\tlast_origin_z;\n\t\tfloat\thead_from_ground_distance_standing;\n\t\tfloat\tstop_to_full_running_fraction;\n\t\tchar\tpad11[0x4];\n\t\tfloat\tmagic_fraction;\n\t\tchar\tpad12[0x3C];\n\t\tfloat\tworld_force;\n\t\tchar\tpad13[0x1CA];\n\t\tfloat\tmin_yaw;\n\t\tfloat\tmax_yaw;\n\t} **\n")
local var_0_33 = var_0_0.typeof("$ *", var_0_30)
local var_0_34 = var_0_0.typeof("char*")
local var_0_35 = vtable_bind("client.dll", "VClientEntityList003", 0, "void*(__thiscall*)(void*, int)")
local var_0_36 = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local var_0_37 = vtable_thunk(0, "void*(__thiscall*)(void*)")
local var_0_38 = client.find_signature("client.dll", "U\x8B\xECS\x8B]\bV\x8B\xF1\x83") or error("invalid GetSequenceActivity signature")
local var_0_39 = var_0_0.cast("int(__thiscall*)(void*, int)", var_0_38)

local function var_0_40(arg_1_0)
	if arg_1_0 == nil then
		return
	end

	local var_1_0 = var_0_36(arg_1_0)

	if var_1_0 == nil then
		return
	end

	return var_0_29(var_0_33, var_1_0)
end

local var_0_41 = {
	new = var_0_40
}

local function var_0_42(arg_2_0, arg_2_1)
	var_0_41[arg_2_1] = function(arg_3_0, ...)
		return arg_2_0(arg_3_0:get_entindex(), ...)
	end
end

function var_0_41.new_from_userid(arg_4_0)
	return var_0_40(var_0_20(arg_4_0))
end

function var_0_41.get_local_player()
	return var_0_40(var_0_2())
end

function var_0_41.get_all(...)
	local var_6_0 = var_0_5(...)

	for iter_6_0, iter_6_1 in ipairs(var_6_0) do
		var_6_0[iter_6_0] = var_0_40(iter_6_1)
	end

	return var_6_0
end

function var_0_41.get_player_resource()
	return var_0_40(var_0_10())
end

function var_0_41.get_game_rules()
	return var_0_40(var_0_14())
end

function var_0_41.get_players(...)
	local var_9_0 = var_0_18(...)

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		var_9_0[iter_9_0] = var_0_40(iter_9_1)
	end

	return var_9_0
end

function var_0_41.get_player_weapon(arg_10_0)
	return var_0_40(var_0_17(arg_10_0:get_entindex()))
end

function var_0_41.get_entindex(arg_11_0)
	if arg_11_0 == nil then
		return
	end

	return arg_11_0.index
end

function var_0_41.get_anim_overlay(arg_12_0, arg_12_1)
	return var_0_29(var_0_31, var_0_29(var_0_34, arg_12_0) + 10640)[0][arg_12_1 or 1]
end

function var_0_41.get_anim_state(arg_13_0)
	return var_0_29(var_0_32, var_0_29(var_0_34, arg_13_0) + 39264)[0][0]
end

function var_0_41.get_sequence_activity(arg_14_0, arg_14_1)
	if arg_14_0 == nil then
		return
	end

	return var_0_39(arg_14_0, arg_14_1)
end

function var_0_41.get_client_networkable(arg_15_0)
	local var_15_0 = var_0_35(arg_15_0:get_entindex())

	if var_15_0 == nil then
		return
	end

	return var_15_0
end

function var_0_41.get_client_unknown(arg_16_0)
	local var_16_0 = arg_16_0:get_client_networkable()

	if var_16_0 == nil then
		return
	end

	local var_16_1 = var_0_37(var_16_0)

	if var_16_1 == nil then
		return
	end

	return var_16_1
end

function var_0_41.get_weapon_info(arg_17_0)
	local var_17_0 = arg_17_0:get_prop("m_iItemDefinitionIndex")

	return var_0_1[var_17_0]
end

var_0_42(var_0_3, "is_enemy")
var_0_42(var_0_4, "get_bounding_box")
var_0_42(var_0_6, "set_prop")
var_0_42(var_0_7, "is_alive")
var_0_42(var_0_8, "get_steam64")
var_0_42(var_0_9, "get_classname")
var_0_42(var_0_11, "get_esp_data")
var_0_42(var_0_15, "get_origin")
var_0_42(var_0_12, "is_dormant")
var_0_42(var_0_13, "get_player_name")
var_0_42(var_0_16, "hitbox_position")
var_0_42(var_0_19, "get_prop")
var_0_42(var_0_21, "draw_hitboxes")
var_0_42(var_0_22, "scale_damage")
var_0_42(var_0_23, "trace_line")
var_0_42(var_0_24, "trace_bullet")
var_0_42(var_0_25, "get_model_materials")
var_0_42(var_0_26, "plist_set")
var_0_42(var_0_27, "plist_get")

local var_0_43 = {
	__index = var_0_41,
	__tostring = function(arg_18_0)
		return var_0_28("%d", arg_18_0:get_entindex())
	end,
	__concat = function(arg_19_0, arg_19_1)
		return var_0_28("%s%s", arg_19_0, arg_19_1)
	end
}

var_0_0.metatype(var_0_30, var_0_43)

return setmetatable(var_0_41, {
	__metatable = true,
	__call = function(arg_20_0, arg_20_1)
		return var_0_40(arg_20_1)
	end
})
