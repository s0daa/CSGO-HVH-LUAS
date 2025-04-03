local var_0_0 = entity.get_prop
local var_0_1 = ui.get
local var_0_2 = math.sqrt
local var_0_3 = math.sin
local var_0_4 = math.cos
local var_0_5 = entity.get_local_player
local var_0_6 = entity.get_players
local var_0_7 = entity.get_player_name
local var_0_8 = client.screen_size
local var_0_9 = renderer.text
local var_0_10 = math.rad
local var_0_11 = var_0_4(var_0_10(10))
local var_0_12 = ui.new_checkbox("VISUALS", "Other ESP", "Show threats")

local function var_0_13(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = var_0_2(arg_1_0 * arg_1_0 + arg_1_1 * arg_1_1 + arg_1_2 * arg_1_2)

	if var_1_0 == 0 then
		return 0, 0, 0
	end

	local var_1_1 = 1 / var_1_0

	return arg_1_0 * var_1_1, arg_1_1 * var_1_1, arg_1_2 * var_1_1
end

local function var_0_14(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	return arg_2_0 * arg_2_3 + arg_2_1 * arg_2_4 + arg_2_2 * arg_2_5
end

local function var_0_15(arg_3_0, arg_3_1)
	local var_3_0 = var_0_10(arg_3_0)
	local var_3_1 = var_0_10(arg_3_1)
	local var_3_2 = var_0_3(var_3_0)
	local var_3_3 = var_0_4(var_3_0)
	local var_3_4 = var_0_3(var_3_1)

	return var_3_3 * var_0_4(var_3_1), var_3_3 * var_3_4, -var_3_2
end

local function var_0_16(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0, var_4_1 = var_0_0(arg_4_0, "m_angEyeAngles")

	if var_4_0 == nil then
		return false
	end

	local var_4_2, var_4_3, var_4_4 = var_0_15(var_4_0, var_4_1)
	local var_4_5, var_4_6, var_4_7 = var_0_0(arg_4_0, "m_vecOrigin")

	if var_4_5 == nil then
		return false
	end

	local var_4_8, var_4_9, var_4_10 = var_0_13(arg_4_1 - var_4_5, arg_4_2 - var_4_6, arg_4_3 - var_4_7)

	return var_0_14(var_4_8, var_4_9, var_4_10, var_4_2, var_4_3, var_4_4) > var_0_11
end

local function var_0_17()
	local var_5_0 = var_0_5()

	if var_5_0 == nil then
		return false, nil
	end

	local var_5_1, var_5_2, var_5_3 = var_0_0(var_5_0, "m_vecOrigin")

	if var_5_1 == nil then
		return false, nil
	end

	local var_5_4 = var_0_6(true)

	for iter_5_0 = 1, #var_5_4 do
		local var_5_5 = var_5_4[iter_5_0]

		if var_0_16(var_5_5, var_5_1, var_5_2, var_5_3) then
			return true, var_0_7(var_5_5) or "An enemy"
		end
	end

	return false, nil
end

local function var_0_18()
	local var_6_0, var_6_1 = var_0_17()

	if var_6_0 then
		local var_6_2, var_6_3 = var_0_8()

		var_0_9(var_6_2 / 2, var_6_3 - 100, 255, 255, 50, 255, "c+", 0, var_6_1, " is aiming in your direction")
	end
end

local function var_0_19(arg_7_0)
	if var_0_1(arg_7_0) then
		client.set_event_callback("paint", var_0_18)
	else
		client.unset_event_callback("paint", var_0_18)
	end
end

ui.set_callback(var_0_12, var_0_19)
