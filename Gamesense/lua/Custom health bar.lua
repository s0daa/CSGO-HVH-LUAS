local var_0_0 = client.set_event_callback
local var_0_1 = client.userid_to_entindex
local var_0_2 = database.read
local var_0_3 = database.write
local var_0_4 = entity.get_bounding_box
local var_0_5 = entity.get_esp_data
local var_0_6 = entity.get_local_player
local var_0_7 = entity.get_origin
local var_0_8 = entity.get_player_weapon
local var_0_9 = entity.get_prop
local var_0_10 = entity.is_alive
local var_0_11 = entity.is_dormant
local var_0_12 = entity.is_enemy
local var_0_13 = globals.maxplayers
local var_0_14 = math.pow
local var_0_15 = renderer.gradient
local var_0_16 = renderer.rectangle
local var_0_17 = renderer.text
local var_0_18 = type
local var_0_19 = ui.get
local var_0_20 = ui.new_checkbox
local var_0_21 = ui.new_color_picker
local var_0_22 = ui.new_combobox
local var_0_23 = ui.reference
local var_0_24 = ui.set
local var_0_25 = ui.set_callback
local var_0_26 = ui.set_visible
local var_0_27 = unpack
local var_0_28 = pairs
local var_0_29 = require("vector")
local var_0_30 = require("gamesense/csgo_weapons")
local var_0_31 = {}
local var_0_32 = var_0_2("healthbar_storage") or {}
local var_0_33 = var_0_6()
local var_0_34 = var_0_7(var_0_33) and var_0_29(var_0_7(var_0_33)) or var_0_29()
local var_0_35 = false
local var_0_36 = var_0_23("Visuals", "Player ESP", "Health bar")
local var_0_37 = {
	state = var_0_20("Visuals", "Player ESP", "Custom health bar"),
	color = var_0_21("Visuals", "Player ESP", "Health bar color", 57, 152, 255, 255),
	bar_type = var_0_22("Visuals", "Player ESP", "\n", {
		"Solid",
		"Gradient",
		"Health based"
	}),
	second_color = var_0_21("Visuals", "Player ESP", "Health bar second color", 11, 70, 255, 255)
}

var_0_32.s_state = var_0_19(var_0_36)

local var_0_38 = var_0_19(var_0_37.bar_type)
local var_0_39, var_0_40, var_0_41, var_0_42 = var_0_19(var_0_37.color)
local var_0_43, var_0_44, var_0_45, var_0_46 = var_0_19(var_0_37.second_color)

local function var_0_47(arg_1_0)
	for iter_1_0, iter_1_1 in var_0_28(var_0_37) do
		if iter_1_1 ~= var_0_37.state and iter_1_1 ~= var_0_37.color then
			var_0_26(iter_1_1, arg_1_0)
		end
	end
end

var_0_47(false)

local function var_0_48(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = (arg_2_3 - arg_2_0) * arg_2_6 + arg_2_0
	local var_2_1 = (arg_2_4 - arg_2_1) * arg_2_6 + arg_2_1
	local var_2_2 = (arg_2_5 - arg_2_2) * arg_2_6 + arg_2_2

	return var_2_0, var_2_1, var_2_2
end

local var_0_49 = {
	Solid = function(arg_3_0)
		local var_3_0 = arg_3_0.data.health < 100 and 1 or 0

		var_0_16(arg_3_0.x - 4, arg_3_0.b_box[4] - (arg_3_0.h * (arg_3_0.data.health / arg_3_0.h_div) - var_3_0), 2, arg_3_0.h * (arg_3_0.data.health / arg_3_0.h_div), arg_3_0.r1, arg_3_0.g1, arg_3_0.b1, arg_3_0.b_box[5] * var_0_42)
	end,
	Gradient = function(arg_4_0)
		local var_4_0 = arg_4_0.data.health < 100 and 1 or 0

		var_0_15(arg_4_0.x - 4, arg_4_0.b_box[4] - (arg_4_0.h * (arg_4_0.data.health / arg_4_0.h_div) - var_4_0), 2, arg_4_0.h * (arg_4_0.data.health / arg_4_0.h_div), arg_4_0.r1, arg_4_0.g1, arg_4_0.b1, arg_4_0.b_box[5] * var_0_42, arg_4_0.r2, arg_4_0.g2, arg_4_0.b2, arg_4_0.b_box[5] * var_0_46, false)
	end,
	["Health based"] = function(arg_5_0)
		local var_5_0 = arg_5_0.data.health < 100 and 1 or 0
		local var_5_1, var_5_2, var_5_3 = var_0_48(arg_5_0.r2, arg_5_0.g2, arg_5_0.b2, arg_5_0.r1, arg_5_0.g1, arg_5_0.b1, arg_5_0.data.health / arg_5_0.h_div)

		var_0_16(arg_5_0.x - 4, arg_5_0.b_box[4] - (arg_5_0.h * (arg_5_0.data.health / arg_5_0.h_div) - var_5_0), 2, arg_5_0.h * (arg_5_0.data.health / arg_5_0.h_div), var_5_1, var_5_2, var_5_3, arg_5_0.b_box[5] * var_0_42)
	end
}

local function var_0_50(arg_6_0, arg_6_1)
	if not var_0_31[arg_6_0] and arg_6_0 ~= var_0_33 or arg_6_1 then
		var_0_31[arg_6_0] = {
			lethal = false,
			armor_value = 0,
			health = 100,
			seen = false,
			origin = var_0_29()
		}
	end
end

local function var_0_51(arg_7_0, arg_7_1)
	if not var_0_31[arg_7_0] or not var_0_31[arg_7_1] then
		return false
	end

	local var_7_0 = var_0_31[arg_7_0].team or var_0_9(arg_7_0, "m_iTeamNum")
	local var_7_1 = var_0_31[arg_7_1].team or var_0_9(arg_7_1, "m_iTeamNum")

	if not var_7_0 or not var_7_1 then
		return false
	end

	return var_7_0 ~= var_7_1
end

local function var_0_52(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1 = arg_8_1 * 1.25

	if not (var_0_31[arg_8_0].armor_value > 0) then
		return arg_8_1
	end

	if var_0_31[arg_8_0].armor_value > 0 then
		arg_8_1 = arg_8_1 * (arg_8_2 * 0.5)
	end

	return arg_8_1
end

local function var_0_53(arg_9_0)
	if not var_0_10(var_0_33) then
		return false
	end

	if not var_0_31[arg_9_0].seen then
		return var_0_31[arg_9_0].health <= 92
	end

	local var_9_0 = var_0_34:dist(var_0_31[arg_9_0].origin)
	local var_9_1 = var_0_8(var_0_33)
	local var_9_2 = var_0_9(var_9_1, "m_iItemDefinitionIndex")

	if not var_0_30[var_9_2] then
		return var_0_31[arg_9_0].health <= 92
	end

	local var_9_3 = var_0_30[var_9_2]
	local var_9_4 = var_9_3.damage * var_0_14(var_9_3.range_modifier, var_9_0 * 0.002)
	local var_9_5 = var_0_52(arg_9_0, var_9_4, var_9_3.armor_ratio)

	if var_9_2 ~= 64 and var_9_2 ~= 40 then
		return var_0_31[arg_9_0].health <= 90
	end

	return var_9_5 >= var_0_31[arg_9_0].health or var_0_31[arg_9_0].health <= 90
end

local function var_0_54()
	for iter_10_0 = 0, var_0_13() do
		if var_0_5(iter_10_0) and iter_10_0 ~= var_0_33 then
			var_0_50(iter_10_0, false)

			if not var_0_11(iter_10_0) then
				var_0_31[iter_10_0].armor_value = var_0_9(iter_10_0, "m_ArmorValue")
				var_0_31[iter_10_0].team = var_0_9(iter_10_0, "m_iTeamNum")

				if not var_0_31[iter_10_0].seen then
					var_0_31[iter_10_0].seen = true
				end
			end

			if var_0_7(iter_10_0) then
				var_0_31[iter_10_0].origin = var_0_29(var_0_7(iter_10_0))
			end

			var_0_31[iter_10_0].lethal = var_0_53(iter_10_0)
			var_0_31[iter_10_0].health = var_0_5(iter_10_0).health or var_0_31[iter_10_0].health
		end
	end
end

local function var_0_55()
	if not var_0_35 then
		var_0_33 = var_0_6()
		var_0_34 = var_0_29(var_0_7(var_0_33))

		if var_0_9(var_0_33, "m_iTeamNum") == 0 then
			return
		end

		var_0_54()
	end

	for iter_11_0, iter_11_1 in var_0_28(var_0_31) do
		repeat
			local var_11_0 = {
				var_0_4(iter_11_0)
			}
			local var_11_1 = var_0_5(iter_11_0)
			local var_11_2 = false

			if not var_11_1 or var_11_1.alpha == 0 then
				break
			end

			if not var_11_0 or not var_11_0[1] or not var_11_0[2] or not var_11_0[3] or not var_11_0[4] or not var_11_0[5] then
				break
			end

			if var_11_0[5] == 0 then
				break
			end

			if not var_0_35 then
				local var_11_3 = var_0_9(var_0_33, "m_hObserverTarget")
				local var_11_4 = var_0_9(var_0_33, "m_iObserverMode")

				if var_11_3 ~= nil and var_11_4 ~= nil and var_11_4 == 5 and var_11_3 <= 64 then
					if var_11_3 == iter_11_0 then
						break
					end

					if not var_0_51(var_11_3, iter_11_0) then
						break
					end
				end

				var_11_2 = iter_11_1.health <= 92
			else
				var_11_2 = var_0_31[iter_11_0].lethal
			end

			local var_11_5 = var_0_34:dist(iter_11_1.origin)
			local var_11_6 = var_11_0[4] - var_11_0[2]
			local var_11_7 = var_11_0[3] - var_11_0[1]
			local var_11_8 = var_11_0[1] - var_11_7 / (var_11_5 * 255)
			local var_11_9 = var_11_0[4] - var_11_6
			local var_11_10 = var_0_39
			local var_11_11 = var_0_40
			local var_11_12 = var_0_41
			local var_11_13 = var_0_43
			local var_11_14 = var_0_44
			local var_11_15 = var_0_45
			local var_11_16 = iter_11_1.health > 100 and iter_11_1.health or 100

			if var_0_11(iter_11_0) then
				var_11_10, var_11_11, var_11_12 = 175, 175, 175
				var_11_13, var_11_14, var_11_15 = 175, 175, 175
			end

			local var_11_17 = var_11_6 - 1 - var_11_6 * (iter_11_1.health / var_11_16) + 1
			local var_11_18 = iter_11_1.health >= 100 and 170 or 230

			var_0_16(var_11_8 - 4, var_11_9, 2, var_11_17, 0, 0, 0, var_11_0[5] * 170)
			var_0_16(var_11_8 - 2, var_11_9 - 1, 1, var_11_17 + 1, 0, 0, 0, var_11_0[5] * 220)
			var_0_16(var_11_8 - 2, var_11_0[4] + 1, 1, -(var_11_6 * (iter_11_1.health / var_11_16) + 2), 0, 0, 0, var_11_0[5] * 170)
			var_0_16(var_11_8 - 5, var_11_9 - 1, 1, var_11_17 + 1, 0, 0, 0, var_11_0[5] * 220)
			var_0_16(var_11_8 - 5, var_11_0[4] + 1, 1, -(var_11_6 * (iter_11_1.health / var_11_16) + 2), 0, 0, 0, var_11_0[5] * 170)
			var_0_16(var_11_8 - 5, var_11_9 - 1, 4, 1, 0, 0, 0, var_11_0[5] * var_11_18)
			var_0_16(var_11_8 - 5, var_11_0[4], 4, 1, 0, 0, 0, var_11_0[5] * 170)
			var_0_49[var_0_38]({
				b_box = var_11_0,
				h = var_11_6,
				w = var_11_7,
				x = var_11_8,
				y = var_11_9,
				r1 = var_11_10,
				g1 = var_11_11,
				b1 = var_11_12,
				r2 = var_11_13,
				g2 = var_11_14,
				b2 = var_11_15,
				h_div = var_11_16,
				data = iter_11_1
			})

			if var_11_2 or iter_11_1.health > 100 then
				var_0_17(var_11_8 - 6, var_11_0[4] - var_11_6 * (iter_11_1.health / var_11_16) + 2, 255, 255, 255, var_11_0[5] * 230, "-cd", 0, iter_11_1.health)
			end
		until true
	end
end

local function var_0_56()
	var_0_33 = var_0_6()
	var_0_34 = var_0_29(var_0_7(var_0_33))
	var_0_35 = true

	var_0_54()
end

local function var_0_57(arg_13_0)
	local var_13_0 = var_0_1(arg_13_0.userid)

	if var_0_31[var_13_0] then
		var_0_31[var_13_0] = nil
	end

	if var_13_0 == var_0_33 then
		var_0_35 = false
	end
end

local function var_0_58(arg_14_0)
	local var_14_0 = var_0_1(arg_14_0.userid)

	var_0_50(var_14_0, false)

	if var_0_31[var_14_0] and arg_14_0.health > 0 then
		var_0_31[var_14_0].health = arg_14_0.health
		var_0_31[var_14_0].armor_value = arg_14_0.armor
	end
end

local function var_0_59(arg_15_0)
	local var_15_0 = var_0_1(arg_15_0.userid)

	var_0_50(var_15_0, true)
end

local function var_0_60()
	var_0_31 = {}

	for iter_16_0 = 0, var_0_13() do
		if var_0_5(iter_16_0) and iter_16_0 ~= var_0_33 then
			var_0_50(iter_16_0, false)

			if var_0_12(iter_16_0) ~= nil then
				var_0_31[iter_16_0].team = var_0_9(iter_16_0, "m_iTeamNum")
			end
		end
	end
end

local function var_0_61(arg_17_0)
	local var_17_0 = var_0_1(arg_17_0.userid)

	var_0_50(var_17_0, false)
end

local function var_0_62(arg_18_0)
	local var_18_0 = var_0_1(arg_18_0.userid)

	var_0_50(var_18_0, false)

	local var_18_1 = {
		item_kevlar = 3,
		item_heavyassaultsuit = 2,
		item_assaultsuit = 1
	}

	if var_0_31[var_18_0] and var_18_1[arg_18_0.weapon] then
		var_0_31[var_18_0].armor_value = 100
	end
end

local function var_0_63(arg_19_0)
	lp = var_0_6()

	local var_19_0 = var_0_1(arg_19_0.userid)

	if lp == var_19_0 then
		var_0_31 = {}
		var_0_35 = false
	end
end

local function var_0_64()
	var_0_32.s_state = var_0_19(var_0_36)
end

function handle_callbacks(arg_21_0)
	local var_21_0 = arg_21_0 and var_0_0 or client.unset_event_callback

	var_21_0("run_command", var_0_56)
	var_21_0("paint", var_0_55)
	var_21_0("player_death", var_0_57)
	var_21_0("player_hurt", var_0_58)
	var_21_0("player_spawned", var_0_59)
	var_21_0("round_start", var_0_60)
	var_21_0("player_footstep", var_0_61)
	var_21_0("item_purchase", var_0_62)
	var_21_0("player_connect_full", var_0_63)
	var_21_0("post_config_load", var_0_64)
end

var_0_25(var_0_37.state, function()
	local var_22_0 = var_0_19(var_0_37.state)

	handle_callbacks(var_22_0)

	if not var_22_0 then
		var_0_47(false)

		if var_0_32.s_state then
			var_0_24(var_0_36, var_0_32.s_state)
		end
	else
		var_0_24(var_0_36, false)
		var_0_26(var_0_37.bar_type, var_22_0)
		var_0_26(var_0_37.color, var_22_0)

		local var_22_1 = var_0_19(var_0_37.bar_type) == "Gradient" or var_0_19(var_0_37.bar_type) == "Health based"

		var_0_26(var_0_37.second_color, var_22_1)
	end

	var_0_26(var_0_36, not var_22_0)
end)
var_0_25(var_0_37.bar_type, function()
	local var_23_0 = var_0_19(var_0_37.bar_type) == "Gradient" or var_0_19(var_0_37.bar_type) == "Health based"

	var_0_26(var_0_37.second_color, var_23_0)

	var_0_38 = var_0_19(var_0_37.bar_type)
end)
var_0_25(var_0_37.color, function()
	var_0_39, var_0_40, var_0_41, var_0_42 = var_0_19(var_0_37.color)
end)
var_0_25(var_0_37.second_color, function()
	var_0_43, var_0_44, var_0_45, var_0_46 = var_0_19(var_0_37.second_color)
end)
var_0_0("shutdown", function()
	var_0_31 = nil

	var_0_26(var_0_36, true)

	for iter_26_0, iter_26_1 in var_0_28(var_0_37) do
		if iter_26_0 == "color" or iter_26_0 == "second_color" then
			var_0_32[iter_26_0] = {
				var_0_19(iter_26_1)
			}
		else
			var_0_32[iter_26_0] = var_0_19(iter_26_1)
		end
	end

	var_0_3("healthbar_storage", var_0_32)
	handle_callbacks(false)
end)

for iter_0_0, iter_0_1 in var_0_28(var_0_32) do
	if var_0_37[iter_0_0] and var_0_18(iter_0_1) == "table" then
		var_0_24(var_0_37[iter_0_0], var_0_27(iter_0_1))

		if iter_0_0 == "color" then
			var_0_39, var_0_40, var_0_41, var_0_42 = var_0_19(var_0_37.color)
		elseif iter_0_0 == "second_color" then
			var_0_43, var_0_44, var_0_45, var_0_46 = var_0_19(var_0_37.second_color)
		end
	end
end
