local var_0_0 = require("bit")
local var_0_1 = renderer
local var_0_2 = var_0_1.gradient
local var_0_3 = var_0_1.rectangle
local var_0_4 = var_0_1.text
local var_0_5 = var_0_1.measure_text
local var_0_6 = client.screen_size
local var_0_7 = client.latency
local var_0_8 = globals.absoluteframetime
local var_0_9 = globals.tickinterval
local var_0_10 = entity.get_local_player
local var_0_11 = entity.get_prop
local var_0_12 = math.min
local var_0_13 = math.max
local var_0_14 = math.abs
local var_0_15 = math.sqrt
local var_0_16 = math.floor
local var_0_17 = var_0_0.band
local var_0_18 = var_0_0.bnot
local var_0_19 = var_0_0.bor
local var_0_20 = 64
local var_0_21 = 0.5
local var_0_22 = 1
local var_0_23 = 2
local var_0_24 = 3
local var_0_25 = 4
local var_0_26 = 5
local var_0_27 = 6
local var_0_28 = {}
local var_0_29 = 0
local var_0_30 = 0
local var_0_31 = 0
local var_0_32 = {}

local function var_0_33(arg_1_0)
	return var_0_16(arg_1_0 + 0.5)
end

local function var_0_34(arg_2_0)
	return var_0_17(arg_2_0 + 1, var_0_18(1))
end

local function var_0_35()
	local var_3_0 = var_0_8()

	if var_3_0 > 0 then
		var_0_28[var_0_29] = var_3_0
		var_0_29 = var_0_29 + 1

		if var_0_29 >= var_0_20 then
			var_0_29 = 0
		end
	end

	local var_3_1 = 0
	local var_3_2 = 0
	local var_3_3 = var_0_29
	local var_3_4

	var_0_30 = 0

	for iter_3_0 = 0, var_0_20 - 1 do
		var_3_3 = var_3_3 - 1

		if var_3_3 < 0 then
			var_3_3 = var_0_20 - 1
		end

		local var_3_5 = var_0_28[var_3_3]

		if var_3_5 == 0 then
			break
		end

		var_3_1 = var_3_1 + var_3_5
		var_3_2 = var_3_2 + 1

		if var_3_4 then
			var_0_30 = var_0_13(var_0_30, var_0_14(var_3_5 - var_3_4))
		end

		var_3_4 = var_3_5

		if var_3_1 >= var_0_21 then
			break
		end
	end

	if var_3_2 == 0 then
		return 0
	end

	local var_3_6 = var_3_1 / var_3_2
	local var_3_7 = var_0_33(1 / var_3_6)

	if var_0_14(var_3_7 - var_0_31) > 5 then
		var_0_31 = var_3_7
	else
		var_3_7 = var_0_31
	end

	return var_3_7
end

local function var_0_36()
	return 255, 60, 80
end

local function var_0_37()
	return 255, 222, 0
end

local function var_0_38()
	return 159, 202, 43
end

local function var_0_39(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0[var_0_25] = arg_7_1
	arg_7_0[var_0_26] = arg_7_2
	arg_7_0[var_0_27] = arg_7_3
end

local function var_0_40(arg_8_0, arg_8_1)
	arg_8_0[var_0_24] = arg_8_1
end

local function var_0_41(arg_9_0)
	local var_9_0 = var_0_33(var_0_12(1000, var_0_7() * 1000))

	if var_9_0 < 40 then
		var_0_39(arg_9_0, var_0_38())
	elseif var_9_0 < 100 then
		var_0_39(arg_9_0, var_0_37())
	else
		var_0_39(arg_9_0, var_0_36())
	end

	var_0_40(arg_9_0, var_9_0)
end

local function var_0_42(arg_10_0)
	local var_10_0 = var_0_35()

	if var_10_0 < 1 / var_0_9() then
		var_0_39(arg_10_0, var_0_36())
	else
		var_0_39(arg_10_0, var_0_38())
	end

	var_0_40(arg_10_0, var_10_0)
end

local function var_0_43(arg_11_0)
	local var_11_0 = var_0_30
	local var_11_1 = var_0_9()

	if var_11_1 < var_11_0 then
		var_0_39(arg_11_0, var_0_36())
	elseif var_11_0 > var_11_1 * 0.5 then
		var_0_39(arg_11_0, var_0_37())
	else
		var_0_39(arg_11_0, var_0_38())
	end

	var_0_40(arg_11_0, var_0_33(var_11_0 * 1000))
end

local function var_0_44(arg_12_0)
	local var_12_0, var_12_1 = var_0_11(var_0_10(), "m_vecVelocity")

	var_0_40(arg_12_0, var_12_0 and var_0_33(var_0_12(10000, var_0_15(var_12_0 * var_12_0 + var_12_1 * var_12_1))) or 0)
end

local function var_0_45()
	local var_13_0, var_13_1 = var_0_5("d", "0")
	local var_13_2 = var_0_34(var_13_0)
	local var_13_3 = var_0_33(var_13_1 * 0.5)
	local var_13_4 = var_13_2 * 13
	local var_13_5, var_13_6 = var_0_5("d-", "0")
	local var_13_7 = var_13_1 - var_13_6
	local var_13_8 = var_13_3 + var_13_1 + var_13_3
	local var_13_9 = var_13_4 * #var_0_32
	local var_13_10 = var_13_9 * 0.5
	local var_13_11, var_13_12 = var_0_6()
	local var_13_13 = var_0_33(var_13_11 * 0.5)
	local var_13_14 = var_13_12 - var_13_8

	var_0_2(var_13_13 - var_13_9, var_13_14, var_13_10, var_13_8, 0, 0, 0, 0, 0, 0, 0, 80, true)
	var_0_3(var_13_13 - var_13_10, var_13_14, var_13_9, var_13_8, 0, 0, 0, 80)
	var_0_2(var_13_13 + var_13_10, var_13_14, var_13_10, var_13_8, 0, 0, 0, 80, 0, 0, 0, 0, true)

	local var_13_15 = var_13_13 - var_13_10 + var_13_4 * 0.5
	local var_13_16 = var_13_14 + var_13_3

	for iter_13_0 = 1, #var_0_32 do
		local var_13_17 = var_0_32[iter_13_0]

		var_13_17[var_0_23](var_13_17)
		var_0_4(var_13_15, var_13_16, var_13_17[var_0_25], var_13_17[var_0_26], var_13_17[var_0_27], 255, "dr", 0, var_13_17[var_0_24])
		var_0_4(var_13_15 + var_13_5, var_13_16 + var_13_7, 255, 255, 255, 175, "d-", 0, var_13_17[var_0_22])

		var_13_15 = var_13_15 + var_13_4
	end
end

local function var_0_46(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	var_0_32[#var_0_32 + 1] = {
		arg_14_0,
		arg_14_1,
		0,
		arg_14_2,
		arg_14_3,
		arg_14_4
	}
end

;(function()
	local var_15_0 = var_0_8()

	for iter_15_0 = var_0_20 - 1, 0, -1 do
		var_0_28[iter_15_0] = var_15_0
	end

	var_0_46("PING", var_0_41, 255, 255, 255)
	var_0_46("FPS", var_0_42, 255, 255, 255)
	var_0_46("VAR", var_0_43, 255, 255, 255)
	var_0_46("SPEED", var_0_44, 255, 255, 255)
	client.set_event_callback("paint", var_0_45)
end)()
