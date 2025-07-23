-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = math.pow
local var_0_1 = math.sin
local var_0_2 = math.cos
local var_0_3 = math.pi
local var_0_4 = math.sqrt
local var_0_5 = math.abs
local var_0_6 = math.asin

local function var_0_7(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return arg_1_2 * arg_1_0 / arg_1_3 + arg_1_1
end

local function var_0_8(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0 = arg_2_0 / arg_2_3

	return arg_2_2 * var_0_0(arg_2_0, 2) + arg_2_1
end

local function var_0_9(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0 = arg_3_0 / arg_3_3

	return -arg_3_2 * arg_3_0 * (arg_3_0 - 2) + arg_3_1
end

local function var_0_10(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0 = arg_4_0 / arg_4_3 * 2

	if arg_4_0 < 1 then
		return arg_4_2 / 2 * var_0_0(arg_4_0, 2) + arg_4_1
	else
		return -arg_4_2 / 2 * ((arg_4_0 - 1) * (arg_4_0 - 3) - 1) + arg_4_1
	end
end

local function var_0_11(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0 < arg_5_3 / 2 then
		return var_0_9(arg_5_0 * 2, arg_5_1, arg_5_2 / 2, arg_5_3)
	else
		return var_0_8(arg_5_0 * 2 - arg_5_3, arg_5_1 + arg_5_2 / 2, arg_5_2 / 2, arg_5_3)
	end
end

local function var_0_12(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0 = arg_6_0 / arg_6_3

	return arg_6_2 * var_0_0(arg_6_0, 3) + arg_6_1
end

local function var_0_13(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0 = arg_7_0 / arg_7_3 - 1

	return arg_7_2 * (var_0_0(arg_7_0, 3) + 1) + arg_7_1
end

local function var_0_14(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0 = arg_8_0 / arg_8_3 * 2

	if arg_8_0 < 1 then
		return arg_8_2 / 2 * arg_8_0 * arg_8_0 * arg_8_0 + arg_8_1
	else
		arg_8_0 = arg_8_0 - 2

		return arg_8_2 / 2 * (arg_8_0 * arg_8_0 * arg_8_0 + 2) + arg_8_1
	end
end

local function var_0_15(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_0 < arg_9_3 / 2 then
		return var_0_13(arg_9_0 * 2, arg_9_1, arg_9_2 / 2, arg_9_3)
	else
		return var_0_12(arg_9_0 * 2 - arg_9_3, arg_9_1 + arg_9_2 / 2, arg_9_2 / 2, arg_9_3)
	end
end

local function var_0_16(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0 = arg_10_0 / arg_10_3

	return arg_10_2 * var_0_0(arg_10_0, 4) + arg_10_1
end

local function var_0_17(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0 = arg_11_0 / arg_11_3 - 1

	return -arg_11_2 * (var_0_0(arg_11_0, 4) - 1) + arg_11_1
end

local function var_0_18(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0 = arg_12_0 / arg_12_3 * 2

	if arg_12_0 < 1 then
		return arg_12_2 / 2 * var_0_0(arg_12_0, 4) + arg_12_1
	else
		arg_12_0 = arg_12_0 - 2

		return -arg_12_2 / 2 * (var_0_0(arg_12_0, 4) - 2) + arg_12_1
	end
end

local function var_0_19(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0 < arg_13_3 / 2 then
		return var_0_17(arg_13_0 * 2, arg_13_1, arg_13_2 / 2, arg_13_3)
	else
		return var_0_16(arg_13_0 * 2 - arg_13_3, arg_13_1 + arg_13_2 / 2, arg_13_2 / 2, arg_13_3)
	end
end

local function var_0_20(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0 = arg_14_0 / arg_14_3

	return arg_14_2 * var_0_0(arg_14_0, 5) + arg_14_1
end

local function var_0_21(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0 = arg_15_0 / arg_15_3 - 1

	return arg_15_2 * (var_0_0(arg_15_0, 5) + 1) + arg_15_1
end

local function var_0_22(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0 = arg_16_0 / arg_16_3 * 2

	if arg_16_0 < 1 then
		return arg_16_2 / 2 * var_0_0(arg_16_0, 5) + arg_16_1
	else
		arg_16_0 = arg_16_0 - 2

		return arg_16_2 / 2 * (var_0_0(arg_16_0, 5) + 2) + arg_16_1
	end
end

local function var_0_23(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_0 < arg_17_3 / 2 then
		return var_0_21(arg_17_0 * 2, arg_17_1, arg_17_2 / 2, arg_17_3)
	else
		return var_0_20(arg_17_0 * 2 - arg_17_3, arg_17_1 + arg_17_2 / 2, arg_17_2 / 2, arg_17_3)
	end
end

local function var_0_24(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	return -arg_18_2 * var_0_2(arg_18_0 / arg_18_3 * (var_0_3 / 2)) + arg_18_2 + arg_18_1
end

local function var_0_25(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	return arg_19_2 * var_0_1(arg_19_0 / arg_19_3 * (var_0_3 / 2)) + arg_19_1
end

local function var_0_26(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	return -arg_20_2 / 2 * (var_0_2(var_0_3 * arg_20_0 / arg_20_3) - 1) + arg_20_1
end

local function var_0_27(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0 < arg_21_3 / 2 then
		return var_0_25(arg_21_0 * 2, arg_21_1, arg_21_2 / 2, arg_21_3)
	else
		return var_0_24(arg_21_0 * 2 - arg_21_3, arg_21_1 + arg_21_2 / 2, arg_21_2 / 2, arg_21_3)
	end
end

local function var_0_28(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_0 == 0 then
		return arg_22_1
	else
		return arg_22_2 * var_0_0(2, 10 * (arg_22_0 / arg_22_3 - 1)) + arg_22_1 - arg_22_2 * 0.001
	end
end

local function var_0_29(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_0 == arg_23_3 then
		return arg_23_1 + arg_23_2
	else
		return arg_23_2 * 1.001 * (-var_0_0(2, -10 * arg_23_0 / arg_23_3) + 1) + arg_23_1
	end
end

local function var_0_30(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_0 == 0 then
		return arg_24_1
	end

	if arg_24_0 == arg_24_3 then
		return arg_24_1 + arg_24_2
	end

	arg_24_0 = arg_24_0 / arg_24_3 * 2

	if arg_24_0 < 1 then
		return arg_24_2 / 2 * var_0_0(2, 10 * (arg_24_0 - 1)) + arg_24_1 - arg_24_2 * 0.0005
	else
		arg_24_0 = arg_24_0 - 1

		return arg_24_2 / 2 * 1.0005 * (-var_0_0(2, -10 * arg_24_0) + 2) + arg_24_1
	end
end

local function var_0_31(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0 < arg_25_3 / 2 then
		return var_0_29(arg_25_0 * 2, arg_25_1, arg_25_2 / 2, arg_25_3)
	else
		return var_0_28(arg_25_0 * 2 - arg_25_3, arg_25_1 + arg_25_2 / 2, arg_25_2 / 2, arg_25_3)
	end
end

local function var_0_32(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0 = arg_26_0 / arg_26_3

	return -arg_26_2 * (var_0_4(1 - var_0_0(arg_26_0, 2)) - 1) + arg_26_1
end

local function var_0_33(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0 = arg_27_0 / arg_27_3 - 1

	return arg_27_2 * var_0_4(1 - var_0_0(arg_27_0, 2)) + arg_27_1
end

local function var_0_34(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_0 = arg_28_0 / arg_28_3 * 2

	if arg_28_0 < 1 then
		return -arg_28_2 / 2 * (var_0_4(1 - arg_28_0 * arg_28_0) - 1) + arg_28_1
	else
		arg_28_0 = arg_28_0 - 2

		return arg_28_2 / 2 * (var_0_4(1 - arg_28_0 * arg_28_0) + 1) + arg_28_1
	end
end

local function var_0_35(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_0 < arg_29_3 / 2 then
		return var_0_33(arg_29_0 * 2, arg_29_1, arg_29_2 / 2, arg_29_3)
	else
		return var_0_32(arg_29_0 * 2 - arg_29_3, arg_29_1 + arg_29_2 / 2, arg_29_2 / 2, arg_29_3)
	end
end

local function var_0_36(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	if arg_30_0 == 0 then
		return arg_30_1
	end

	arg_30_0 = arg_30_0 / arg_30_3

	if arg_30_0 == 1 then
		return arg_30_1 + arg_30_2
	end

	arg_30_5 = arg_30_5 or arg_30_3 * 0.3

	local var_30_0

	if not arg_30_4 or arg_30_4 < var_0_5(arg_30_2) then
		arg_30_4 = arg_30_2
		var_30_0 = arg_30_5 / 4
	else
		var_30_0 = arg_30_5 / (2 * var_0_3) * var_0_6(arg_30_2 / arg_30_4)
	end

	arg_30_0 = arg_30_0 - 1

	return -(arg_30_4 * var_0_0(2, 10 * arg_30_0) * var_0_1((arg_30_0 * arg_30_3 - var_30_0) * (2 * var_0_3) / arg_30_5)) + arg_30_1
end

local function var_0_37(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	if arg_31_0 == 0 then
		return arg_31_1
	end

	arg_31_0 = arg_31_0 / arg_31_3

	if arg_31_0 == 1 then
		return arg_31_1 + arg_31_2
	end

	arg_31_5 = arg_31_5 or arg_31_3 * 0.3

	local var_31_0

	if not arg_31_4 or arg_31_4 < var_0_5(arg_31_2) then
		arg_31_4 = arg_31_2
		var_31_0 = arg_31_5 / 4
	else
		var_31_0 = arg_31_5 / (2 * var_0_3) * var_0_6(arg_31_2 / arg_31_4)
	end

	return arg_31_4 * var_0_0(2, -10 * arg_31_0) * var_0_1((arg_31_0 * arg_31_3 - var_31_0) * (2 * var_0_3) / arg_31_5) + arg_31_2 + arg_31_1
end

local function var_0_38(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	if arg_32_0 == 0 then
		return arg_32_1
	end

	arg_32_0 = arg_32_0 / arg_32_3 * 2

	if arg_32_0 == 2 then
		return arg_32_1 + arg_32_2
	end

	arg_32_5 = arg_32_5 or arg_32_3 * 0.44999999999999996
	arg_32_4 = arg_32_4 or 0

	local var_32_0

	if not arg_32_4 or arg_32_4 < var_0_5(arg_32_2) then
		arg_32_4 = arg_32_2
		var_32_0 = arg_32_5 / 4
	else
		var_32_0 = arg_32_5 / (2 * var_0_3) * var_0_6(arg_32_2 / arg_32_4)
	end

	if arg_32_0 < 1 then
		arg_32_0 = arg_32_0 - 1

		return -0.5 * (arg_32_4 * var_0_0(2, 10 * arg_32_0) * var_0_1((arg_32_0 * arg_32_3 - var_32_0) * (2 * var_0_3) / arg_32_5)) + arg_32_1
	else
		arg_32_0 = arg_32_0 - 1

		return arg_32_4 * var_0_0(2, -10 * arg_32_0) * var_0_1((arg_32_0 * arg_32_3 - var_32_0) * (2 * var_0_3) / arg_32_5) * 0.5 + arg_32_2 + arg_32_1
	end
end

local function var_0_39(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if arg_33_0 < arg_33_3 / 2 then
		return var_0_37(arg_33_0 * 2, arg_33_1, arg_33_2 / 2, arg_33_3, arg_33_4, arg_33_5)
	else
		return var_0_36(arg_33_0 * 2 - arg_33_3, arg_33_1 + arg_33_2 / 2, arg_33_2 / 2, arg_33_3, arg_33_4, arg_33_5)
	end
end

local function var_0_40(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	arg_34_4 = arg_34_4 or 1.70158
	arg_34_0 = arg_34_0 / arg_34_3

	return arg_34_2 * arg_34_0 * arg_34_0 * ((arg_34_4 + 1) * arg_34_0 - arg_34_4) + arg_34_1
end

local function var_0_41(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	arg_35_4 = arg_35_4 or 1.70158
	arg_35_0 = arg_35_0 / arg_35_3 - 1

	return arg_35_2 * (arg_35_0 * arg_35_0 * ((arg_35_4 + 1) * arg_35_0 + arg_35_4) + 1) + arg_35_1
end

local function var_0_42(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	arg_36_4 = arg_36_4 or 1.70158
	arg_36_4 = arg_36_4 * 1.525
	arg_36_0 = arg_36_0 / arg_36_3 * 2

	if arg_36_0 < 1 then
		return arg_36_2 / 2 * (arg_36_0 * arg_36_0 * ((arg_36_4 + 1) * arg_36_0 - arg_36_4)) + arg_36_1
	else
		arg_36_0 = arg_36_0 - 2

		return arg_36_2 / 2 * (arg_36_0 * arg_36_0 * ((arg_36_4 + 1) * arg_36_0 + arg_36_4) + 2) + arg_36_1
	end
end

local function var_0_43(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	if arg_37_0 < arg_37_3 / 2 then
		return var_0_41(arg_37_0 * 2, arg_37_1, arg_37_2 / 2, arg_37_3, arg_37_4)
	else
		return var_0_40(arg_37_0 * 2 - arg_37_3, arg_37_1 + arg_37_2 / 2, arg_37_2 / 2, arg_37_3, arg_37_4)
	end
end

local function var_0_44(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_0 = arg_38_0 / arg_38_3

	if arg_38_0 < 0.36363636363636365 then
		return arg_38_2 * (7.5625 * arg_38_0 * arg_38_0) + arg_38_1
	elseif arg_38_0 < 0.7272727272727273 then
		arg_38_0 = arg_38_0 - 0.5454545454545454

		return arg_38_2 * (7.5625 * arg_38_0 * arg_38_0 + 0.75) + arg_38_1
	elseif arg_38_0 < 0.9090909090909091 then
		arg_38_0 = arg_38_0 - 0.8181818181818182

		return arg_38_2 * (7.5625 * arg_38_0 * arg_38_0 + 0.9375) + arg_38_1
	else
		arg_38_0 = arg_38_0 - 0.9545454545454546

		return arg_38_2 * (7.5625 * arg_38_0 * arg_38_0 + 0.984375) + arg_38_1
	end
end

local function var_0_45(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	return arg_39_2 - var_0_44(arg_39_3 - arg_39_0, 0, arg_39_2, arg_39_3) + arg_39_1
end

local function var_0_46(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if arg_40_0 < arg_40_3 / 2 then
		return var_0_45(arg_40_0 * 2, 0, arg_40_2, arg_40_3) * 0.5 + arg_40_1
	else
		return var_0_44(arg_40_0 * 2 - arg_40_3, 0, arg_40_2, arg_40_3) * 0.5 + arg_40_2 * 0.5 + arg_40_1
	end
end

local function var_0_47(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_0 < arg_41_3 / 2 then
		return var_0_44(arg_41_0 * 2, arg_41_1, arg_41_2 / 2, arg_41_3)
	else
		return var_0_45(arg_41_0 * 2 - arg_41_3, arg_41_1 + arg_41_2 / 2, arg_41_2 / 2, arg_41_3)
	end
end

return {
	linear = var_0_7,
	quad_in = var_0_8,
	quad_out = var_0_9,
	quad_in_out = var_0_10,
	quad_out_in = var_0_11,
	cubic_in = var_0_12,
	cubic_out = var_0_13,
	cubic_in_out = var_0_14,
	cubic_out_in = var_0_15,
	quart_in = var_0_16,
	quart_out = var_0_17,
	quart_in_out = var_0_18,
	quart_out_in = var_0_19,
	quint_in = var_0_20,
	quint_out = var_0_21,
	quint_in_out = var_0_22,
	quint_out_in = var_0_23,
	sine_in = var_0_24,
	sine_out = var_0_25,
	sine_in_out = var_0_26,
	sine_out_in = var_0_27,
	expo_in = var_0_28,
	expo_out = var_0_29,
	expo_in_out = var_0_30,
	expo_out_in = var_0_31,
	circ_in = var_0_32,
	circ_out = var_0_33,
	circ_in_out = var_0_34,
	circ_out_in = var_0_35,
	elastic_in = var_0_36,
	elastic_out = var_0_37,
	elastic_in_out = var_0_38,
	elastic_out_in = var_0_39,
	back_in = var_0_40,
	back_out = var_0_41,
	back_in_out = var_0_42,
	back_out_in = var_0_43,
	bounce_in = var_0_45,
	bounce_out = var_0_44,
	bounce_in_out = var_0_46,
	bounce_out_in = var_0_47
}
