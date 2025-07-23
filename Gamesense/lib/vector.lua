-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = error
local var_0_1 = type
local var_0_2 = tonumber
local var_0_3 = math.sin
local var_0_4 = math.cos
local var_0_5 = math.atan2
local var_0_6 = math.sqrt
local var_0_7 = math.rad
local var_0_8 = math.deg
local var_0_9 = string.format
local var_0_10 = require("ffi")
local var_0_11 = var_0_10.sizeof
local var_0_12 = var_0_10.istype

var_0_10.cdef("typedef struct {\n\tfloat x, y, z;\n} Vector;\n")

local var_0_13 = var_0_10.typeof("Vector")
local var_0_14
local var_0_15 = 1 / 0
local var_0_16 = 1.1920929e-07

local function var_0_17(arg_1_0, arg_1_1, arg_1_2)
	return var_0_13(var_0_2(arg_1_0) or 0, var_0_2(arg_1_1) or 0, var_0_2(arg_1_2) or 0)
end

local function var_0_18(arg_2_0)
	return arg_2_0 ~= nil and var_0_12(var_0_13, arg_2_0)
end

local function var_0_19(arg_3_0)
	return arg_3_0 ~= nil and var_0_1(arg_3_0) == "number"
end

local function var_0_20(arg_4_0, arg_4_1)
	return var_0_0(var_0_9("bad argument #%d (expected %s)", arg_4_0, arg_4_1), 4)
end

local function var_0_21(arg_5_0, arg_5_1)
	return var_0_18(arg_5_0) or var_0_20(arg_5_1, "Vector")
end

local function var_0_22(arg_6_0, arg_6_1)
	return var_0_19(arg_6_0) or var_0_20(arg_6_1, "number")
end

local function var_0_23(arg_7_0)
	return var_0_17(arg_7_0.x, arg_7_0.y, arg_7_0.z)
end

local function var_0_24(arg_8_0)
	return arg_8_0.x, arg_8_0.y, arg_8_0.z
end

local function var_0_25(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.x = arg_9_1 or 0
	arg_9_0.y = arg_9_2 or 0
	arg_9_0.z = arg_9_3 or 0
end

local function var_0_26(arg_10_0, arg_10_1, arg_10_2)
	var_0_22(arg_10_1, 2)
	var_0_22(arg_10_2, 3)

	local var_10_0 = var_0_7(arg_10_1)
	local var_10_1 = var_0_7(arg_10_2)
	local var_10_2 = var_0_3(var_10_0)
	local var_10_3 = var_0_4(var_10_0)
	local var_10_4 = var_0_3(var_10_1)

	arg_10_0.x = var_10_3 * var_0_4(var_10_1)
	arg_10_0.y = var_10_3 * var_10_4
	arg_10_0.z = -var_10_2

	return arg_10_0
end

local function var_0_27(arg_11_0)
	return arg_11_0 * arg_11_0
end

local function var_0_28(arg_12_0, arg_12_1)
	var_0_21(arg_12_1, 2)

	return var_0_17(arg_12_0.x * arg_12_1.x, arg_12_0.y * arg_12_1.y, arg_12_0.z * arg_12_1.z)
end

local function var_0_29(arg_13_0)
	return var_0_27(arg_13_0.x) + var_0_27(arg_13_0.y)
end

local function var_0_30(arg_14_0)
	return var_0_27(arg_14_0.x) + var_0_27(arg_14_0.y) + var_0_27(arg_14_0.z)
end

local function var_0_31(arg_15_0)
	return var_0_6(var_0_29(arg_15_0))
end

local function var_0_32(arg_16_0)
	return var_0_6(var_0_30(arg_16_0))
end

local function var_0_33(arg_17_0, arg_17_1)
	var_0_21(arg_17_1, 2)

	return arg_17_0.x * arg_17_1.x + arg_17_0.y * arg_17_1.y + arg_17_0.z * arg_17_1.z
end

local function var_0_34(arg_18_0, arg_18_1)
	var_0_21(arg_18_1, 2)

	return var_0_27(arg_18_0.x - arg_18_1.x) + var_0_27(arg_18_0.y - arg_18_1.y) + var_0_27(arg_18_0.z - arg_18_1.z)
end

local function var_0_35(arg_19_0, arg_19_1)
	var_0_21(arg_19_1, 2)

	return var_0_6(var_0_27(arg_19_0.x - arg_19_1.x) + var_0_27(arg_19_0.y - arg_19_1.y) + var_0_27(arg_19_0.z - arg_19_1.z))
end

local function var_0_36(arg_20_0, arg_20_1)
	var_0_21(arg_20_1, 2)

	return var_0_27(arg_20_0.x - arg_20_1.x) + var_0_27(arg_20_0.y - arg_20_1.y)
end

local function var_0_37(arg_21_0, arg_21_1)
	var_0_21(arg_21_1, 2)

	return var_0_6(var_0_27(arg_21_0.x - arg_21_1.x) + var_0_27(arg_21_0.y - arg_21_1.y))
end

local function var_0_38(arg_22_0, arg_22_1)
	var_0_22(arg_22_1, 2)

	arg_22_0.x = arg_22_0.x * arg_22_1
	arg_22_0.y = arg_22_0.y * arg_22_1
	arg_22_0.z = arg_22_0.z * arg_22_1
end

local function var_0_39(arg_23_0, arg_23_1)
	var_0_22(arg_23_1, 2)

	return var_0_17(arg_23_0.x * arg_23_1, arg_23_0.y * arg_23_1, arg_23_0.z * arg_23_1)
end

local function var_0_40(arg_24_0)
	local var_24_0 = var_0_32(arg_24_0) + var_0_16

	var_0_38(arg_24_0, 1 / var_24_0)

	return var_24_0
end

local function var_0_41(arg_25_0)
	return var_0_39(arg_25_0, 1 / (var_0_32(arg_25_0) + var_0_16))
end

local function var_0_42(arg_26_0, arg_26_1, arg_26_2)
	return var_0_21(arg_26_1, 2) and var_0_17(arg_26_0.x + (arg_26_1.x - arg_26_0.x) * arg_26_2, arg_26_0.y + (arg_26_1.y - arg_26_0.y) * arg_26_2, arg_26_0.z + (arg_26_1.z - arg_26_0.z) * arg_26_2)
end

local function var_0_43(arg_27_0, arg_27_1)
	var_0_21(arg_27_1, 2)

	return var_0_17(arg_27_0.y * arg_27_1.z - arg_27_0.z * arg_27_1.y, arg_27_0.z * arg_27_1.x - arg_27_0.x * arg_27_1.z, arg_27_0.x * arg_27_1.y - arg_27_0.y * arg_27_1.x)
end

local function var_0_44(arg_28_0)
	if arg_28_0.x == 0 and arg_28_0.y == 0 then
		return arg_28_0.z > 0 and -90 or 90, 0, 0
	end

	return var_0_8(var_0_5(-arg_28_0.z, var_0_31(arg_28_0))), var_0_8(var_0_5(arg_28_0.y, arg_28_0.x)), 0
end

local function var_0_45(arg_29_0)
	local var_29_0
	local var_29_1

	if arg_29_0.x == 0 and arg_29_0.y == 0 then
		var_29_0 = var_0_17(0, -1, 0)
		var_29_1 = var_0_17(-arg_29_0.z, 0, 0)
	else
		var_29_0 = var_0_43(arg_29_0, var_0_14)

		var_0_40(var_29_0)

		var_29_1 = var_0_43(var_29_0, arg_29_0)

		var_0_40(var_29_1)
	end

	return var_29_0, var_29_1
end

local function var_0_46(arg_30_0, arg_30_1)
	var_0_21(arg_30_1, 2)

	local var_30_0 = var_0_17(arg_30_1.x - arg_30_0.x, arg_30_1.y - arg_30_0.y, arg_30_1.z - arg_30_0.z)

	var_0_40(var_30_0)

	return var_30_0
end

local function var_0_47(arg_31_0, arg_31_1)
	return var_0_18(arg_31_1) and arg_31_0.x == arg_31_1.x and arg_31_0.y == arg_31_1.y and arg_31_0.z == arg_31_1.z
end

local function var_0_48(arg_32_0)
	return var_0_17(-arg_32_0.x, -arg_32_0.y, -arg_32_0.z)
end

local function var_0_49(arg_33_0, arg_33_1)
	return var_0_21(arg_33_1, 3) and var_0_17(arg_33_0.x + arg_33_1.x, arg_33_0.y + arg_33_1.y, arg_33_0.z + arg_33_1.z)
end

local function var_0_50(arg_34_0, arg_34_1)
	return var_0_18(arg_34_0) and var_0_49(arg_34_0, arg_34_1) or var_0_49(arg_34_1, arg_34_0)
end

local function var_0_51(arg_35_0, arg_35_1)
	return var_0_21(arg_35_1, 2) and var_0_17(arg_35_0.x - arg_35_1.x, arg_35_0.y - arg_35_1.y, arg_35_0.z - arg_35_1.z)
end

local function var_0_52(arg_36_0, arg_36_1)
	return var_0_18(arg_36_0) and var_0_51(arg_36_0, arg_36_1) or var_0_51(arg_36_1, arg_36_0)
end

local function var_0_53(arg_37_0, arg_37_1)
	return var_0_18(arg_37_1) and var_0_28(arg_37_0, arg_37_1) or var_0_39(arg_37_0, arg_37_1)
end

local function var_0_54(arg_38_0, arg_38_1)
	return var_0_18(arg_38_0) and var_0_53(arg_38_0, arg_38_1) or var_0_53(arg_38_1, arg_38_0)
end

local function var_0_55(arg_39_0, arg_39_1)
	return var_0_22(arg_39_1) and var_0_39(arg_39_0, 1 / arg_39_1)
end

local function var_0_56(arg_40_0, arg_40_1)
	return var_0_18(arg_40_0) and var_0_55(arg_40_0, arg_40_1) or var_0_55(arg_40_1, arg_40_0)
end

local function var_0_57(arg_41_0)
	return var_0_9("%f %f %f", arg_41_0.x, arg_41_0.y, arg_41_0.z)
end

local var_0_58 = {
	__add = var_0_50,
	__div = var_0_56,
	__eq = var_0_47,
	__len = var_0_32,
	__mul = var_0_54,
	__sub = var_0_52,
	__tostring = var_0_57,
	__unm = var_0_48,
	__index = {
		clone = var_0_23,
		unpack = var_0_24,
		init = var_0_25,
		init_from_angles = var_0_26,
		scale = var_0_38,
		scaled = var_0_39,
		normalize = var_0_40,
		normalized = var_0_41,
		length2d = var_0_31,
		length = var_0_32,
		length2dsqr = var_0_29,
		lengthsqr = var_0_30,
		lerp = var_0_42,
		dot = var_0_33,
		dist = var_0_35,
		distsqr = var_0_34,
		dist2d = var_0_37,
		dist2dsqr = var_0_36,
		cross = var_0_43,
		angles = var_0_44,
		vectors = var_0_45,
		to = var_0_46
	}
}

var_0_13 = var_0_10.metatype(var_0_13, var_0_58)
var_0_14 = var_0_13(0, 0, 1)

return var_0_17
