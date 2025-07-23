-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}
local var_0_1 = string.char
local var_0_2 = string.byte
local var_0_3 = string.format
local var_0_4 = string.rep
local var_0_5 = string.sub
local var_0_6 = bit.bor
local var_0_7 = bit.band
local var_0_8 = bit.bnot
local var_0_9 = bit.bxor
local var_0_10 = bit.rshift
local var_0_11 = bit.lshift

local function var_0_12(arg_1_0)
	local function var_1_0(arg_2_0)
		return var_0_1(var_0_7(var_0_10(arg_1_0, arg_2_0), 255))
	end

	return var_1_0(0) .. var_1_0(8) .. var_1_0(16) .. var_1_0(24)
end

local function var_0_13(arg_3_0)
	local var_3_0 = 0

	for iter_3_0 = 1, #arg_3_0 do
		var_3_0 = var_3_0 * 256 + var_0_2(arg_3_0, iter_3_0)
	end

	return var_3_0
end

local function var_0_14(arg_4_0)
	local var_4_0 = 0

	for iter_4_0 = #arg_4_0, 1, -1 do
		var_4_0 = var_4_0 * 256 + var_0_2(arg_4_0, iter_4_0)
	end

	return var_4_0
end

local function var_0_15(arg_5_0, ...)
	local var_5_0 = 1
	local var_5_1 = {}
	local var_5_2 = {
		...
	}

	for iter_5_0 = 1, #var_5_2 do
		table.insert(var_5_1, var_0_14(var_0_5(arg_5_0, var_5_0, var_5_0 + var_5_2[iter_5_0] - 1)))

		var_5_0 = var_5_0 + var_5_2[iter_5_0]
	end

	return var_5_1
end

local function var_0_16(arg_6_0)
	return var_0_13(var_0_12(arg_6_0))
end

local var_0_17 = {
	3614090360,
	3905402710,
	606105819,
	3250441966,
	4118548399,
	1200080426,
	2821735955,
	4249261313,
	1770035416,
	2336552879,
	4294925233,
	2304563134,
	1804603682,
	4254626195,
	2792965006,
	1236535329,
	4129170786,
	3225465664,
	643717713,
	3921069994,
	3593408605,
	38016083,
	3634488961,
	3889429448,
	568446438,
	3275163606,
	4107603335,
	1163531501,
	2850285829,
	4243563512,
	1735328473,
	2368359562,
	4294588738,
	2272392833,
	1839030562,
	4259657740,
	2763975236,
	1272893353,
	4139469664,
	3200236656,
	681279174,
	3936430074,
	3572445317,
	76029189,
	3654602809,
	3873151461,
	530742520,
	3299628645,
	4096336452,
	1126891415,
	2878612391,
	4237533241,
	1700485571,
	2399980690,
	4293915773,
	2240044497,
	1873313359,
	4264355552,
	2734768916,
	1309151649,
	4149444226,
	3174756917,
	718787259,
	3951481745,
	1732584193,
	4023233417,
	2562383102,
	271733878
}

local function var_0_18(arg_7_0, arg_7_1, arg_7_2)
	return var_0_6(var_0_7(arg_7_0, arg_7_1), var_0_7(-arg_7_0 - 1, arg_7_2))
end

local function var_0_19(arg_8_0, arg_8_1, arg_8_2)
	return var_0_6(var_0_7(arg_8_0, arg_8_2), var_0_7(arg_8_1, -arg_8_2 - 1))
end

local function var_0_20(arg_9_0, arg_9_1, arg_9_2)
	return var_0_9(arg_9_0, var_0_9(arg_9_1, arg_9_2))
end

local function var_0_21(arg_10_0, arg_10_1, arg_10_2)
	return var_0_9(arg_10_1, var_0_6(arg_10_0, -arg_10_2 - 1))
end

local function var_0_22(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	arg_11_1 = var_0_7(arg_11_1 + arg_11_0(arg_11_2, arg_11_3, arg_11_4) + arg_11_5 + arg_11_7, 4294967295)

	return var_0_6(var_0_11(var_0_7(arg_11_1, var_0_10(4294967295, arg_11_6)), arg_11_6), var_0_10(arg_11_1, 32 - arg_11_6)) + arg_11_2
end

local function var_0_23(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0
	local var_12_1 = arg_12_1
	local var_12_2 = arg_12_2
	local var_12_3 = arg_12_3
	local var_12_4 = var_0_17
	local var_12_5 = var_0_22(var_0_18, var_12_0, var_12_1, var_12_2, var_12_3, arg_12_4[0], 7, var_12_4[1])
	local var_12_6 = var_0_22(var_0_18, var_12_3, var_12_5, var_12_1, var_12_2, arg_12_4[1], 12, var_12_4[2])
	local var_12_7 = var_0_22(var_0_18, var_12_2, var_12_6, var_12_5, var_12_1, arg_12_4[2], 17, var_12_4[3])
	local var_12_8 = var_0_22(var_0_18, var_12_1, var_12_7, var_12_6, var_12_5, arg_12_4[3], 22, var_12_4[4])
	local var_12_9 = var_0_22(var_0_18, var_12_5, var_12_8, var_12_7, var_12_6, arg_12_4[4], 7, var_12_4[5])
	local var_12_10 = var_0_22(var_0_18, var_12_6, var_12_9, var_12_8, var_12_7, arg_12_4[5], 12, var_12_4[6])
	local var_12_11 = var_0_22(var_0_18, var_12_7, var_12_10, var_12_9, var_12_8, arg_12_4[6], 17, var_12_4[7])
	local var_12_12 = var_0_22(var_0_18, var_12_8, var_12_11, var_12_10, var_12_9, arg_12_4[7], 22, var_12_4[8])
	local var_12_13 = var_0_22(var_0_18, var_12_9, var_12_12, var_12_11, var_12_10, arg_12_4[8], 7, var_12_4[9])
	local var_12_14 = var_0_22(var_0_18, var_12_10, var_12_13, var_12_12, var_12_11, arg_12_4[9], 12, var_12_4[10])
	local var_12_15 = var_0_22(var_0_18, var_12_11, var_12_14, var_12_13, var_12_12, arg_12_4[10], 17, var_12_4[11])
	local var_12_16 = var_0_22(var_0_18, var_12_12, var_12_15, var_12_14, var_12_13, arg_12_4[11], 22, var_12_4[12])
	local var_12_17 = var_0_22(var_0_18, var_12_13, var_12_16, var_12_15, var_12_14, arg_12_4[12], 7, var_12_4[13])
	local var_12_18 = var_0_22(var_0_18, var_12_14, var_12_17, var_12_16, var_12_15, arg_12_4[13], 12, var_12_4[14])
	local var_12_19 = var_0_22(var_0_18, var_12_15, var_12_18, var_12_17, var_12_16, arg_12_4[14], 17, var_12_4[15])
	local var_12_20 = var_0_22(var_0_18, var_12_16, var_12_19, var_12_18, var_12_17, arg_12_4[15], 22, var_12_4[16])
	local var_12_21 = var_0_22(var_0_19, var_12_17, var_12_20, var_12_19, var_12_18, arg_12_4[1], 5, var_12_4[17])
	local var_12_22 = var_0_22(var_0_19, var_12_18, var_12_21, var_12_20, var_12_19, arg_12_4[6], 9, var_12_4[18])
	local var_12_23 = var_0_22(var_0_19, var_12_19, var_12_22, var_12_21, var_12_20, arg_12_4[11], 14, var_12_4[19])
	local var_12_24 = var_0_22(var_0_19, var_12_20, var_12_23, var_12_22, var_12_21, arg_12_4[0], 20, var_12_4[20])
	local var_12_25 = var_0_22(var_0_19, var_12_21, var_12_24, var_12_23, var_12_22, arg_12_4[5], 5, var_12_4[21])
	local var_12_26 = var_0_22(var_0_19, var_12_22, var_12_25, var_12_24, var_12_23, arg_12_4[10], 9, var_12_4[22])
	local var_12_27 = var_0_22(var_0_19, var_12_23, var_12_26, var_12_25, var_12_24, arg_12_4[15], 14, var_12_4[23])
	local var_12_28 = var_0_22(var_0_19, var_12_24, var_12_27, var_12_26, var_12_25, arg_12_4[4], 20, var_12_4[24])
	local var_12_29 = var_0_22(var_0_19, var_12_25, var_12_28, var_12_27, var_12_26, arg_12_4[9], 5, var_12_4[25])
	local var_12_30 = var_0_22(var_0_19, var_12_26, var_12_29, var_12_28, var_12_27, arg_12_4[14], 9, var_12_4[26])
	local var_12_31 = var_0_22(var_0_19, var_12_27, var_12_30, var_12_29, var_12_28, arg_12_4[3], 14, var_12_4[27])
	local var_12_32 = var_0_22(var_0_19, var_12_28, var_12_31, var_12_30, var_12_29, arg_12_4[8], 20, var_12_4[28])
	local var_12_33 = var_0_22(var_0_19, var_12_29, var_12_32, var_12_31, var_12_30, arg_12_4[13], 5, var_12_4[29])
	local var_12_34 = var_0_22(var_0_19, var_12_30, var_12_33, var_12_32, var_12_31, arg_12_4[2], 9, var_12_4[30])
	local var_12_35 = var_0_22(var_0_19, var_12_31, var_12_34, var_12_33, var_12_32, arg_12_4[7], 14, var_12_4[31])
	local var_12_36 = var_0_22(var_0_19, var_12_32, var_12_35, var_12_34, var_12_33, arg_12_4[12], 20, var_12_4[32])
	local var_12_37 = var_0_22(var_0_20, var_12_33, var_12_36, var_12_35, var_12_34, arg_12_4[5], 4, var_12_4[33])
	local var_12_38 = var_0_22(var_0_20, var_12_34, var_12_37, var_12_36, var_12_35, arg_12_4[8], 11, var_12_4[34])
	local var_12_39 = var_0_22(var_0_20, var_12_35, var_12_38, var_12_37, var_12_36, arg_12_4[11], 16, var_12_4[35])
	local var_12_40 = var_0_22(var_0_20, var_12_36, var_12_39, var_12_38, var_12_37, arg_12_4[14], 23, var_12_4[36])
	local var_12_41 = var_0_22(var_0_20, var_12_37, var_12_40, var_12_39, var_12_38, arg_12_4[1], 4, var_12_4[37])
	local var_12_42 = var_0_22(var_0_20, var_12_38, var_12_41, var_12_40, var_12_39, arg_12_4[4], 11, var_12_4[38])
	local var_12_43 = var_0_22(var_0_20, var_12_39, var_12_42, var_12_41, var_12_40, arg_12_4[7], 16, var_12_4[39])
	local var_12_44 = var_0_22(var_0_20, var_12_40, var_12_43, var_12_42, var_12_41, arg_12_4[10], 23, var_12_4[40])
	local var_12_45 = var_0_22(var_0_20, var_12_41, var_12_44, var_12_43, var_12_42, arg_12_4[13], 4, var_12_4[41])
	local var_12_46 = var_0_22(var_0_20, var_12_42, var_12_45, var_12_44, var_12_43, arg_12_4[0], 11, var_12_4[42])
	local var_12_47 = var_0_22(var_0_20, var_12_43, var_12_46, var_12_45, var_12_44, arg_12_4[3], 16, var_12_4[43])
	local var_12_48 = var_0_22(var_0_20, var_12_44, var_12_47, var_12_46, var_12_45, arg_12_4[6], 23, var_12_4[44])
	local var_12_49 = var_0_22(var_0_20, var_12_45, var_12_48, var_12_47, var_12_46, arg_12_4[9], 4, var_12_4[45])
	local var_12_50 = var_0_22(var_0_20, var_12_46, var_12_49, var_12_48, var_12_47, arg_12_4[12], 11, var_12_4[46])
	local var_12_51 = var_0_22(var_0_20, var_12_47, var_12_50, var_12_49, var_12_48, arg_12_4[15], 16, var_12_4[47])
	local var_12_52 = var_0_22(var_0_20, var_12_48, var_12_51, var_12_50, var_12_49, arg_12_4[2], 23, var_12_4[48])
	local var_12_53 = var_0_22(var_0_21, var_12_49, var_12_52, var_12_51, var_12_50, arg_12_4[0], 6, var_12_4[49])
	local var_12_54 = var_0_22(var_0_21, var_12_50, var_12_53, var_12_52, var_12_51, arg_12_4[7], 10, var_12_4[50])
	local var_12_55 = var_0_22(var_0_21, var_12_51, var_12_54, var_12_53, var_12_52, arg_12_4[14], 15, var_12_4[51])
	local var_12_56 = var_0_22(var_0_21, var_12_52, var_12_55, var_12_54, var_12_53, arg_12_4[5], 21, var_12_4[52])
	local var_12_57 = var_0_22(var_0_21, var_12_53, var_12_56, var_12_55, var_12_54, arg_12_4[12], 6, var_12_4[53])
	local var_12_58 = var_0_22(var_0_21, var_12_54, var_12_57, var_12_56, var_12_55, arg_12_4[3], 10, var_12_4[54])
	local var_12_59 = var_0_22(var_0_21, var_12_55, var_12_58, var_12_57, var_12_56, arg_12_4[10], 15, var_12_4[55])
	local var_12_60 = var_0_22(var_0_21, var_12_56, var_12_59, var_12_58, var_12_57, arg_12_4[1], 21, var_12_4[56])
	local var_12_61 = var_0_22(var_0_21, var_12_57, var_12_60, var_12_59, var_12_58, arg_12_4[8], 6, var_12_4[57])
	local var_12_62 = var_0_22(var_0_21, var_12_58, var_12_61, var_12_60, var_12_59, arg_12_4[15], 10, var_12_4[58])
	local var_12_63 = var_0_22(var_0_21, var_12_59, var_12_62, var_12_61, var_12_60, arg_12_4[6], 15, var_12_4[59])
	local var_12_64 = var_0_22(var_0_21, var_12_60, var_12_63, var_12_62, var_12_61, arg_12_4[13], 21, var_12_4[60])
	local var_12_65 = var_0_22(var_0_21, var_12_61, var_12_64, var_12_63, var_12_62, arg_12_4[4], 6, var_12_4[61])
	local var_12_66 = var_0_22(var_0_21, var_12_62, var_12_65, var_12_64, var_12_63, arg_12_4[11], 10, var_12_4[62])
	local var_12_67 = var_0_22(var_0_21, var_12_63, var_12_66, var_12_65, var_12_64, arg_12_4[2], 15, var_12_4[63])
	local var_12_68 = var_0_22(var_0_21, var_12_64, var_12_67, var_12_66, var_12_65, arg_12_4[9], 21, var_12_4[64])

	return var_0_7(arg_12_0 + var_12_65, 4294967295), var_0_7(arg_12_1 + var_12_68, 4294967295), var_0_7(arg_12_2 + var_12_67, 4294967295), var_0_7(arg_12_3 + var_12_66, 4294967295)
end

local function var_0_24(arg_13_0, arg_13_1)
	arg_13_0.pos = arg_13_0.pos + #arg_13_1
	arg_13_1 = arg_13_0.buf .. arg_13_1

	for iter_13_0 = 1, #arg_13_1 - 63, 64 do
		local var_13_0 = var_0_15(var_0_5(arg_13_1, iter_13_0, iter_13_0 + 63), 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)

		assert(#var_13_0 == 16)

		var_13_0[0] = table.remove(var_13_0, 1)
		arg_13_0.a, arg_13_0.b, arg_13_0.c, arg_13_0.d = var_0_23(arg_13_0.a, arg_13_0.b, arg_13_0.c, arg_13_0.d, var_13_0)
	end

	arg_13_0.buf = var_0_5(arg_13_1, math.floor(#arg_13_1 / 64) * 64 + 1, #arg_13_1)

	return arg_13_0
end

local function var_0_25(arg_14_0)
	local var_14_0 = arg_14_0.pos
	local var_14_1 = 56 - var_14_0 % 64

	if var_14_0 % 64 > 56 then
		var_14_1 = var_14_1 + 64
	end

	if var_14_1 == 0 then
		var_14_1 = 64
	end

	local var_14_2 = var_0_1(128) .. var_0_4(var_0_1(0), var_14_1 - 1) .. var_0_12(var_0_7(8 * var_14_0, 4294967295)) .. var_0_12(math.floor(var_14_0 / 536870912))

	var_0_24(arg_14_0, var_14_2)
	assert(arg_14_0.pos % 64 == 0)

	return var_0_12(arg_14_0.a) .. var_0_12(arg_14_0.b) .. var_0_12(arg_14_0.c) .. var_0_12(arg_14_0.d)
end

function var_0_0.new()
	return {
		buf = "",
		pos = 0,
		a = var_0_17[65],
		b = var_0_17[66],
		c = var_0_17[67],
		d = var_0_17[68],
		update = var_0_24,
		finish = var_0_25
	}
end

function var_0_0.tohex(arg_16_0)
	return var_0_3("%08x%08x%08x%08x", var_0_13(var_0_5(arg_16_0, 1, 4)), var_0_13(var_0_5(arg_16_0, 5, 8)), var_0_13(var_0_5(arg_16_0, 9, 12)), var_0_13(var_0_5(arg_16_0, 13, 16)))
end

function var_0_0.sum(arg_17_0)
	return var_0_0.new():update(arg_17_0):finish()
end

function var_0_0.sumhexa(arg_18_0)
	return var_0_0.tohex(var_0_0.sum(arg_18_0))
end

return var_0_0
