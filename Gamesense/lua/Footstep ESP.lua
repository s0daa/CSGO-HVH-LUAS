local var_0_0 = require("gamesense/uix")
local var_0_1 = client.userid_to_entindex
local var_0_2 = entity.get_players
local var_0_3 = entity.get_prop
local var_0_4 = entity.is_dormant
local var_0_5 = entity.is_enemy
local var_0_6 = globals.curtime
local var_0_7 = math.sqrt
local var_0_8 = renderer.text
local var_0_9 = renderer.world_to_screen
local var_0_10 = table.remove
local var_0_11 = ui.get
local var_0_12 = ui.new_checkbox
local var_0_13 = ui.new_color_picker
local var_0_14 = ui.new_slider
local var_0_15 = ui.reference
local var_0_16 = ui.set_callback
local var_0_17 = ui.set_visible
local var_0_18
local var_0_19
local var_0_20
local var_0_21 = {}

local function var_0_22(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	return var_0_7((arg_1_3 - arg_1_0)^2 + (arg_1_4 - arg_1_1)^2 + (arg_1_5 - arg_1_2)^2)
end

local function var_0_23(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_2()
	local var_2_1 = var_0_11(var_0_20)

	for iter_2_0 = 1, #var_2_0 do
		local var_2_2 = var_2_0[iter_2_0]

		if var_0_5(var_2_2) == false then
			local var_2_3, var_2_4, var_2_5 = var_0_3(var_2_2, "m_vecOrigin")

			if var_2_1 >= var_0_22(var_2_3, var_2_4, var_2_5, arg_2_0, arg_2_1, arg_2_2) then
				return true
			end
		end
	end

	return false
end

local function var_0_24()
	local var_3_0 = var_0_6()
	local var_3_1, var_3_2, var_3_3, var_3_4 = var_0_11(var_0_19)

	for iter_3_0 = #var_0_21, 1, -1 do
		local var_3_5 = var_0_21[iter_3_0]

		if var_3_0 >= var_3_5.delay_time then
			var_3_5.alpha = var_3_5.alpha - 1

			if var_3_5.alpha <= 0 then
				var_0_10(var_0_21, iter_3_0)
			end
		end

		local var_3_6, var_3_7 = var_0_9(var_3_5.x, var_3_5.y, var_3_5.z)

		if var_3_6 ~= nil then
			var_0_8(var_3_6, var_3_7, var_3_1, var_3_2, var_3_3, var_3_5.alpha, "cd", 0, "step")
		end
	end
end

local function var_0_25(arg_4_0)
	local var_4_0 = var_0_1(arg_4_0.userid)

	if var_0_5(var_4_0) == true then
		local var_4_1, var_4_2, var_4_3 = entity.get_origin(var_4_0)

		if var_4_1 ~= nil and var_0_23(var_4_1, var_4_2, var_4_3) then
			var_0_21[#var_0_21 + 1] = {
				alpha = 255,
				x = var_4_1,
				y = var_4_2,
				z = var_4_3,
				delay_time = var_0_6() + 1
			}
		end
	end
end

local function var_0_26(arg_5_0)
	var_0_21 = {}
end

local function var_0_27()
	var_0_21 = {}
end

local function var_0_28(arg_7_0)
	local var_7_0 = var_0_11(arg_7_0)

	var_0_17(var_0_20, var_7_0)
end

;(function()
	var_0_18 = var_0_0.new_checkbox("LUA", "A", "Footstep ESP")
	var_0_19 = var_0_13("LUA", "A", "Footstep color", 255, 255, 255, 255)
	var_0_20 = var_0_14("LUA", "A", "\nFootstep distance", 0, 1250, 850, true, "u")

	var_0_18:on("change", var_0_28)
	var_0_18:on("paint", var_0_24)
	var_0_18:on("player_footstep", var_0_25)
	var_0_18:on("round_start", var_0_26)
	var_0_18:on("level_init", var_0_27)
end)()
