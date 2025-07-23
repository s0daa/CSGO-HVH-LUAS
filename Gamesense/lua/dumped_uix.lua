-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = setmetatable
local var_0_1 = error
local var_0_2 = client.set_event_callback
local var_0_3 = client.unset_event_callback
local var_0_4 = ui.get
local var_0_5 = ui.new_checkbox
local var_0_6 = pairs
local var_0_7 = ui.set
local var_0_8 = ui.set_callback
local var_0_9 = ui.set_visible
local var_0_10 = 0
local var_0_11 = 1
local var_0_12 = 2
local var_0_13 = {}
local var_0_14 = {}
local var_0_15
local var_0_16

local function var_0_17(arg_1_0)
	return var_0_13[arg_1_0] or var_0_1("invalid object", 3)
end

local function var_0_18(arg_2_0)
	return var_0_14[arg_2_0] or var_0_1("invalid reference", 2)
end

local function var_0_19(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = var_0_0({}, var_0_15)

	var_3_0[var_0_10] = arg_3_0
	var_3_0[var_0_12] = {}
	var_0_13[var_3_1] = var_3_0
	var_0_14[arg_3_0] = var_3_0

	return var_3_1
end

local function var_0_20(...)
	local var_4_0 = var_0_5(...)

	if var_4_0 then
		local var_4_1 = var_0_19(var_4_0)

		return var_0_0(var_4_1, var_0_16)
	end
end

local function var_0_21(arg_5_0)
	local var_5_0 = var_0_4(arg_5_0)
	local var_5_1 = var_0_18(arg_5_0)
	local var_5_2 = var_5_1[var_0_11]

	if var_5_2 then
		var_5_2(arg_5_0, var_5_0)
	end

	local var_5_3 = var_5_1[var_0_12]

	if var_5_3 then
		local var_5_4 = var_5_0 and var_0_2 or var_0_3

		for iter_5_0, iter_5_1 in var_0_6(var_5_3) do
			var_5_4(iter_5_0, iter_5_1)
		end
	end
end

local function var_0_22(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = var_0_17(arg_6_0)

	if arg_6_1 == "change" then
		var_6_0[var_0_11] = arg_6_2
	else
		var_6_0[var_0_12][arg_6_1] = arg_6_2
	end

	var_0_21(var_6_0[var_0_10])
	var_0_8(var_6_0[var_0_10], var_0_21)
end

local function var_0_23(arg_7_0)
	local var_7_0 = var_0_17(arg_7_0)

	var_0_9(var_7_0[var_0_10], false)
end

local function var_0_24(arg_8_0)
	local var_8_0 = var_0_17(arg_8_0)

	var_0_9(var_8_0[var_0_10], true)
end

local function var_0_25(arg_9_0)
	local var_9_0 = var_0_17(arg_9_0)

	return var_0_4(var_9_0[var_0_10])
end

local function var_0_26(arg_10_0, arg_10_1)
	local var_10_0 = var_0_17(arg_10_0)

	var_0_7(var_10_0[var_0_10], arg_10_1)
end

;(function()
	var_0_15 = {
		on = var_0_22,
		hide = var_0_23,
		show = var_0_24,
		get = var_0_25,
		set = var_0_26
	}
	var_0_16 = {
		__index = var_0_15
	}
end)()

return {
	new_checkbox = var_0_20
}
