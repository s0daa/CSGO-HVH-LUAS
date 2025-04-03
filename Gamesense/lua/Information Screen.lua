local var_0_0 = client.key_state
local var_0_1 = client.set_event_callback
local var_0_2 = database.read
local var_0_3 = database.write
local var_0_4 = entity.get_all
local var_0_5 = entity.get_bounding_box
local var_0_6 = entity.get_classname
local var_0_7 = entity.get_local_player
local var_0_8 = entity.get_player_name
local var_0_9 = entity.get_player_weapon
local var_0_10 = entity.get_players
local var_0_11 = entity.get_prop
local var_0_12 = globals.maxplayers
local var_0_13 = math.min
local var_0_14 = renderer.rectangle
local var_0_15 = renderer.text
local var_0_16 = string.gsub
local var_0_17 = string.len
local var_0_18 = string.sub
local var_0_19 = table.insert
local var_0_20 = ui.get
local var_0_21 = ui.is_menu_open
local var_0_22 = ui.mouse_position
local var_0_23 = ui.new_checkbox
local var_0_24 = ui.new_color_picker
local var_0_25 = ui.reference
local var_0_26 = ui.set_callback
local var_0_27 = ui.set_visible
local var_0_28 = unpack
local var_0_29 = require("gamesense/uix")
local var_0_30 = {}
local var_0_31 = database.read("InfoScreen") or {}

var_0_30.x = var_0_31.x or 150
var_0_30.y = var_0_31.y or 150
var_0_30.dragging = false

local var_0_32 = var_0_29.new_checkbox("MISC", "Miscellaneous", "Info Screen")
local var_0_33 = var_0_24("MISC", "Miscellaneous", "Info Screen", 193, 255, 107, 255)
local var_0_34 = var_0_23("MISC", "Miscellaneous", "Info Screen: Location")
local var_0_35 = var_0_25("VISUALS", "Player ESP", "Teammates")

local function var_0_36(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_37(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0 ~= nil and arg_2_0 or false
	local var_2_1 = arg_2_1 ~= nil and arg_2_1 or true
	local var_2_2 = {}
	local var_2_3 = var_0_4("CCSPlayerResource")[1]

	for iter_2_0 = 1, var_0_12() do
		if var_0_11(var_2_3, "m_bConnected", iter_2_0) == 1 then
			local var_2_4

			if var_2_0 then
				var_2_4 = var_0_11(var_0_7(), "m_iTeamNum")
			end

			local var_2_5 = true

			if var_2_0 and var_0_11(iter_2_0, "m_iTeamNum") == var_2_4 then
				var_2_5 = false
			end

			if var_2_5 then
				local var_2_6 = true

				if var_2_1 and var_0_11(var_2_3, "m_bAlive", iter_2_0) ~= 1 then
					var_2_6 = false
				end

				if var_2_6 then
					var_0_19(var_2_2, iter_2_0)
				end
			end
		end
	end

	return var_2_2
end

local function var_0_38()
	local var_3_0 = var_0_32:get()

	var_0_27(var_0_34, var_3_0)
end

var_0_32:on("change", var_0_38)
var_0_38()

local var_0_39 = {}

local function var_0_40(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0, var_4_1 = var_0_22()

	arg_4_4 = arg_4_4 or false

	if arg_4_4 then
		var_0_14(arg_4_0, arg_4_1, arg_4_2, arg_4_3, 255, 0, 0, 50)
	end

	return arg_4_0 <= var_4_0 and var_4_0 <= arg_4_0 + arg_4_2 and arg_4_1 <= var_4_1 and var_4_1 <= arg_4_1 + arg_4_3
end

local function var_0_41()
	if var_0_32:get() then
		local var_5_0 = var_0_20(var_0_34)
		local var_5_1 = var_0_20(var_0_35)
		local var_5_2 = {}
		local var_5_3 = {}
		local var_5_4 = {
			"PLAYER",
			"HEALTH",
			"WEAPON"
		}
		local var_5_5 = 2

		var_0_30.w = 220

		if var_5_0 then
			var_5_4 = {
				"PLAYER",
				"HEALTH",
				"WEAPON",
				"LOCATION"
			}
			var_5_5 = 3
			var_0_30.w = 300
		end

		local var_5_6 = var_0_37(not var_5_1)

		if #var_5_6 == 0 then
			return
		end

		local var_5_7 = var_0_10(not var_5_1)
		local var_5_8 = var_0_4("CCSPlayerResource")[1]

		if var_5_8 == nil then
			return
		end

		local var_5_9 = var_0_11(var_5_8, "m_iPlayerC4")

		var_0_30.h = #var_5_6 * 15 + 30
		var_0_30.h = var_0_13(var_0_30.h, 145)

		var_0_14(var_0_30.x, var_0_30.y, var_0_30.w, var_0_30.h, 29, 31, 38, 170)
		var_0_14(var_0_30.x, var_0_30.y, var_0_30.w, 20, 29, 31, 38, 100)

		for iter_5_0 = 1, #var_5_6 do
			local var_5_10 = var_5_6[iter_5_0]
			local var_5_11 = var_0_8(var_5_10)
			local var_5_12 = var_0_11(var_5_10, "m_iHealth")
			local var_5_13 = var_0_9(var_5_10)
			local var_5_14 = var_0_6(var_5_13) or "Unknown"

			if var_5_14 ~= nil and var_5_14 ~= "Unknown" and var_0_17(var_5_14) > 2 then
				var_5_14 = var_0_18(var_5_14, 2)
				var_5_14 = var_0_16(var_5_14, "Weapon", "")
			end

			local var_5_15 = var_0_11(var_5_10, "m_bHasDefuser")

			var_5_3[iter_5_0] = {
				255,
				255,
				255,
				255
			}

			if var_5_9 ~= nil and var_5_10 == var_5_9 then
				var_5_3[iter_5_0] = {
					255,
					0,
					0,
					255
				}
			end

			if var_5_15 == 1 then
				var_5_3[iter_5_0] = {
					50,
					50,
					255,
					255
				}
			end

			if not var_0_36(var_5_7, var_5_10) then
				local var_5_16, var_5_17, var_5_18, var_5_19, var_5_20 = var_0_5(ctx, var_5_10)

				if var_5_20 == nil or var_5_20 < 0.15 then
					var_5_20 = 0.15
				end

				local var_5_21, var_5_22, var_5_23, var_5_24 = var_0_28(var_5_3[iter_5_0])

				var_5_3[iter_5_0] = {
					var_5_21,
					var_5_22,
					var_5_23,
					var_5_24 * var_5_20
				}
			end

			if var_5_0 then
				local var_5_25 = {
					["^ "] = "",
					["of "] = " of "
				}
				local var_5_26 = ((entity.get_prop(var_5_10, "m_szLastPlaceName") or " ") .. " "):gsub("%u[%l ]", function(arg_6_0)
					return " " .. arg_6_0
				end):sub(1, -2)

				for iter_5_1, iter_5_2 in pairs(var_5_25) do
					place_name = var_5_11:gsub(iter_5_1, iter_5_2)
				end

				var_5_2[iter_5_0] = {
					var_5_11,
					var_5_12,
					var_5_14,
					var_5_26
				}
			else
				var_5_2[iter_5_0] = {
					var_5_11,
					var_5_12,
					var_5_14
				}
			end
		end

		local var_5_27, var_5_28, var_5_29, var_5_30 = var_0_20(var_0_33)

		for iter_5_3 = 0, var_5_5 do
			var_0_15(var_0_30.x + 31 + iter_5_3 * 75, var_0_30.y + 11, var_5_27, var_5_28, var_5_29, var_5_30, "-c", 70, var_5_4[iter_5_3 + 1])

			if #var_5_6 >= 1 then
				for iter_5_4 = 1, #var_5_6 do
					local var_5_31 = 255
					local var_5_32 = 255
					local var_5_33 = 255
					local var_5_34 = 255

					if var_5_3[iter_5_4] ~= nil then
						var_5_31, var_5_32, var_5_33, var_5_34 = var_0_28(var_5_3[iter_5_4])
					end

					var_0_15(var_0_30.x + 31 + iter_5_3 * 75, var_0_30.y + (15 + iter_5_4 * 12), var_5_31, var_5_32, var_5_33, var_5_34, "c", 70, var_5_2[iter_5_4][iter_5_3 + 1])
				end
			end
		end

		if var_0_21() then
			var_0_39.x, var_0_39.y = var_0_22()

			local var_5_35 = var_0_0(1)

			var_0_15(var_0_30.x, var_0_30.y - 1, 255, 255, 255, 255, "b", 999, "Drag here to move info screen")

			if var_0_30.dragging and not var_5_35 then
				var_0_30.dragging = false
			end

			if var_0_30.dragging and var_5_35 then
				var_0_30.x = var_0_39.x - var_0_30.drag_x
				var_0_30.y = var_0_39.y - var_0_30.drag_y
			end

			if var_0_40(var_0_30.x, var_0_30.y, var_0_30.w, 10, true) and var_5_35 then
				var_0_30.dragging = true
				var_0_30.drag_x = var_0_39.x - var_0_30.x
				var_0_30.drag_y = var_0_39.y - var_0_30.y
			end
		end
	end
end

var_0_32:on("paint", var_0_41)
var_0_1("shutdown", function()
	var_0_3("InfoScreen", {
		x = var_0_30.x,
		y = var_0_30.y
	})
end)
