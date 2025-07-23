-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("bit")
local var_0_1 = {}
local var_0_2 = var_0_0.lshift
local var_0_3 = var_0_0.rshift
local var_0_4 = var_0_0.band
local var_0_5 = string.char
local var_0_6 = string.byte
local var_0_7 = string.gsub
local var_0_8 = string.sub
local var_0_9 = string.format
local var_0_10 = table.concat
local var_0_11 = tostring
local var_0_12 = error
local var_0_13 = pairs

local function var_0_14(arg_1_0, arg_1_1, arg_1_2)
	return var_0_4(var_0_3(arg_1_0, arg_1_1), var_0_2(1, arg_1_2) - 1)
end

local function var_0_15(arg_2_0)
	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0 = 1, 65 do
		local var_2_2 = var_0_6(var_0_8(arg_2_0, iter_2_0, iter_2_0)) or 32

		if var_2_1[var_2_2] ~= nil then
			var_0_12("invalid alphabet: duplicate character " .. var_0_11(var_2_2), 3)
		end

		var_2_0[iter_2_0 - 1] = var_2_2
		var_2_1[var_2_2] = iter_2_0 - 1
	end

	return var_2_0, var_2_1
end

local var_0_16 = {}
local var_0_17 = {}

var_0_16.base64, var_0_17.base64 = var_0_15("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
var_0_16.base64url, var_0_17.base64url = var_0_15("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

local var_0_18 = {
	__index = function(arg_3_0, arg_3_1)
		if type(arg_3_1) == "string" and arg_3_1:len() == 64 or arg_3_1:len() == 65 then
			var_0_16[arg_3_1], var_0_17[arg_3_1] = var_0_15(arg_3_1)

			return arg_3_0[arg_3_1]
		end
	end
}

setmetatable(var_0_16, var_0_18)
setmetatable(var_0_17, var_0_18)

function var_0_1.encode(arg_4_0, arg_4_1)
	arg_4_1 = var_0_16[arg_4_1 or "base64"] or var_0_12("invalid alphabet specified", 2)
	arg_4_0 = var_0_11(arg_4_0)

	local var_4_0 = {}
	local var_4_1 = 1
	local var_4_2 = #arg_4_0
	local var_4_3 = var_4_2 % 3
	local var_4_4 = {}

	for iter_4_0 = 1, var_4_2 - var_4_3, 3 do
		local var_4_5, var_4_6, var_4_7 = var_0_6(arg_4_0, iter_4_0, iter_4_0 + 2)
		local var_4_8 = var_4_5 * 65536 + var_4_6 * 256 + var_4_7
		local var_4_9 = var_4_4[var_4_8]

		if not var_4_9 then
			var_4_9 = var_0_5(arg_4_1[var_0_14(var_4_8, 18, 6)], arg_4_1[var_0_14(var_4_8, 12, 6)], arg_4_1[var_0_14(var_4_8, 6, 6)], arg_4_1[var_0_14(var_4_8, 0, 6)])
			var_4_4[var_4_8] = var_4_9
		end

		var_4_0[var_4_1] = var_4_9
		var_4_1 = var_4_1 + 1
	end

	if var_4_3 == 2 then
		local var_4_10, var_4_11 = var_0_6(arg_4_0, var_4_2 - 1, var_4_2)
		local var_4_12 = var_4_10 * 65536 + var_4_11 * 256

		var_4_0[var_4_1] = var_0_5(arg_4_1[var_0_14(var_4_12, 18, 6)], arg_4_1[var_0_14(var_4_12, 12, 6)], arg_4_1[var_0_14(var_4_12, 6, 6)], arg_4_1[64])
	elseif var_4_3 == 1 then
		local var_4_13 = var_0_6(arg_4_0, var_4_2) * 65536

		var_4_0[var_4_1] = var_0_5(arg_4_1[var_0_14(var_4_13, 18, 6)], arg_4_1[var_0_14(var_4_13, 12, 6)], arg_4_1[64], arg_4_1[64])
	end

	return var_0_10(var_4_0)
end

function var_0_1.decode(arg_5_0, arg_5_1)
	arg_5_1 = var_0_17[arg_5_1 or "base64"] or var_0_12("invalid alphabet specified", 2)

	local var_5_0 = "[^%w%+%/%=]"

	if arg_5_1 then
		local var_5_1
		local var_5_2

		for iter_5_0, iter_5_1 in var_0_13(arg_5_1) do
			if iter_5_1 == 62 then
				var_5_1 = iter_5_0
			elseif iter_5_1 == 63 then
				var_5_2 = iter_5_0
			end
		end

		var_5_0 = var_0_9("[^%%w%%%s%%%s%%=]", var_0_5(var_5_1), var_0_5(var_5_2))
	end

	arg_5_0 = var_0_7(var_0_11(arg_5_0), var_5_0, "")

	local var_5_3 = {}
	local var_5_4 = {}
	local var_5_5 = 1
	local var_5_6 = #arg_5_0
	local var_5_7 = var_0_8(arg_5_0, -2) == "==" and 2 or var_0_8(arg_5_0, -1) == "=" and 1 or 0

	for iter_5_2 = 1, var_5_7 > 0 and var_5_6 - 4 or var_5_6, 4 do
		local var_5_8, var_5_9, var_5_10, var_5_11 = var_0_6(arg_5_0, iter_5_2, iter_5_2 + 3)
		local var_5_12 = var_5_8 * 16777216 + var_5_9 * 65536 + var_5_10 * 256 + var_5_11
		local var_5_13 = var_5_3[var_5_12]

		if not var_5_13 then
			local var_5_14 = arg_5_1[var_5_8] * 262144 + arg_5_1[var_5_9] * 4096 + arg_5_1[var_5_10] * 64 + arg_5_1[var_5_11]

			var_5_13 = var_0_5(var_0_14(var_5_14, 16, 8), var_0_14(var_5_14, 8, 8), var_0_14(var_5_14, 0, 8))
			var_5_3[var_5_12] = var_5_13
		end

		var_5_4[var_5_5] = var_5_13
		var_5_5 = var_5_5 + 1
	end

	if var_5_7 == 1 then
		local var_5_15, var_5_16, var_5_17 = var_0_6(arg_5_0, var_5_6 - 3, var_5_6 - 1)
		local var_5_18 = arg_5_1[var_5_15] * 262144 + arg_5_1[var_5_16] * 4096 + arg_5_1[var_5_17] * 64

		var_5_4[var_5_5] = var_0_5(var_0_14(var_5_18, 16, 8), var_0_14(var_5_18, 8, 8))
	elseif var_5_7 == 2 then
		local var_5_19, var_5_20 = var_0_6(arg_5_0, var_5_6 - 3, var_5_6 - 2)
		local var_5_21 = arg_5_1[var_5_19] * 262144 + arg_5_1[var_5_20] * 4096

		var_5_4[var_5_5] = var_0_5(var_0_14(var_5_21, 16, 8))
	end

	return var_0_10(var_5_4)
end

return var_0_1
