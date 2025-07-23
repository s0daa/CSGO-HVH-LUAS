-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}
local var_0_1 = client.color_log
local var_0_2 = unpack
local var_0_3 = tostring
local var_0_4 = table.concat
local var_0_5 = table.insert
local var_0_6 = table.remove
local var_0_7 = string.sub
local var_0_8 = string.rep
local var_0_9 = string.len
local var_0_10 = {
	221,
	221,
	221
}
local var_0_11 = {
	180,
	230,
	30
}
local var_0_12 = {
	96,
	160,
	220
}
local var_0_13 = {
	218,
	230,
	30
}

function var_0_0.format(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0 = var_0_3(arg_1_0)
	arg_1_1, arg_1_2, arg_1_3 = var_0_3(arg_1_1 or "\n"), var_0_3(arg_1_2 or "\t"), var_0_3(arg_1_3 or " ")

	local var_1_0 = 1
	local var_1_1 = 0
	local var_1_2 = 0
	local var_1_3 = var_0_9(arg_1_0)
	local var_1_4 = {}
	local var_1_5
	local var_1_6
	local var_1_7 = var_0_7(arg_1_3, -1) == "\n"

	for iter_1_0 = 1, var_1_3 do
		local var_1_8 = var_0_7(arg_1_0, iter_1_0, iter_1_0)

		if not var_1_6 and (var_1_8 == "{" or var_1_8 == "[") then
			var_1_4[var_1_0] = var_1_5 == ":" and var_1_8 .. arg_1_1 or var_0_8(arg_1_2, var_1_1) .. var_1_8 .. arg_1_1
			var_1_1 = var_1_1 + 1
		elseif not var_1_6 and (var_1_8 == "}" or var_1_8 == "]") then
			var_1_1 = var_1_1 - 1

			if var_1_5 == "{" or var_1_5 == "[" then
				var_1_0 = var_1_0 - 1
				var_1_4[var_1_0] = var_0_8(arg_1_2, var_1_1) .. var_1_5 .. var_1_8
			else
				var_1_4[var_1_0] = arg_1_1 .. var_0_8(arg_1_2, var_1_1) .. var_1_8
			end
		elseif not var_1_6 and var_1_8 == "," then
			var_1_4[var_1_0] = var_1_8 .. arg_1_1
			var_1_2 = -1
		elseif not var_1_6 and var_1_8 == ":" then
			var_1_4[var_1_0] = var_1_8 .. arg_1_3

			if var_1_7 then
				var_1_0 = var_1_0 + 1
				var_1_4[var_1_0] = var_0_8(arg_1_2, var_1_1)
			end
		else
			if var_1_8 == "\"" and var_1_5 ~= "\\" then
				var_1_6 = not var_1_6 and true or nil
			end

			if var_1_1 ~= var_1_2 then
				var_1_4[var_1_0] = var_0_8(arg_1_2, var_1_1)
				var_1_0, var_1_2 = var_1_0 + 1, var_1_1
			end

			var_1_4[var_1_0] = var_1_8
		end

		var_1_5, var_1_0 = var_1_8, var_1_0 + 1
	end

	return var_0_4(var_1_4)
end

local var_0_14 = var_0_0.format

function var_0_0.highlight(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_1, arg_2_3, arg_2_4, arg_2_2 = arg_2_1 or var_0_10, arg_2_3 or var_0_11, arg_2_4 or var_0_12, arg_2_2 or var_0_13
	arg_2_0 = var_0_3(arg_2_0)

	local var_2_0 = 1
	local var_2_1 = var_0_9(arg_2_0)
	local var_2_2 = {}
	local var_2_3
	local var_2_4
	local var_2_5 = arg_2_1
	local var_2_6 = {}

	for iter_2_0 = 1, var_2_1 do
		local var_2_7 = var_0_7(arg_2_0, iter_2_0, iter_2_0)
		local var_2_8

		if not var_2_4 and (var_2_7 == "{" or var_2_7 == "[") then
			var_2_8 = arg_2_1

			var_0_5(var_2_6, var_2_7)
		elseif not var_2_4 and (var_2_7 == "}" or var_2_7 == "]") then
			var_2_8 = arg_2_1

			if var_2_3 == "{" or var_2_3 == "[" then
				var_0_5(var_2_6, var_0_4(var_2_3, var_2_7))
			else
				var_0_5(var_2_6, var_2_7)
			end
		elseif not var_2_4 and (var_2_7 == "," or var_2_7 == ":") then
			var_2_8 = arg_2_1

			var_0_5(var_2_6, var_2_7)
		else
			if var_2_7 == "\"" and var_2_3 ~= "\\" then
				var_2_4 = not var_2_4 and true or nil
				var_2_8 = arg_2_2
			elseif var_2_5 == arg_2_2 then
				var_2_8 = var_2_4 and arg_2_3 or arg_2_4
			elseif var_2_5 == arg_2_1 and var_2_7 ~= " " and var_2_7 ~= "\n" and var_2_7 ~= "\t" then
				var_2_8 = var_2_4 and arg_2_3 or arg_2_4
			end

			var_0_5(var_2_6, var_2_7)
		end

		if var_2_8 ~= nil and var_2_8 ~= var_2_5 then
			local var_2_9 = {
				var_0_6(var_2_6, #var_2_6)
			}

			var_0_5(var_2_2, {
				var_2_5[1],
				var_2_5[2],
				var_2_5[3],
				var_0_4(var_2_6)
			})

			var_2_5, var_2_6 = var_2_8, var_2_9
		end

		var_2_3 = var_2_7
	end

	if #var_2_6 > 0 then
		var_0_5(var_2_2, {
			var_2_5[1],
			var_2_5[2],
			var_2_5[3],
			var_0_4(var_2_6)
		})
	end

	return var_2_2
end

local var_0_15 = var_0_0.highlight

function var_0_0.print_highlighted(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = var_0_15(arg_3_0, arg_3_1, arg_3_3, arg_3_4, arg_3_2)
	local var_3_1 = #var_3_0

	for iter_3_0 = 1, var_3_1 do
		local var_3_2, var_3_3, var_3_4, var_3_5 = var_0_2(var_3_0[iter_3_0])

		var_0_1(var_3_2, var_3_3, var_3_4, var_3_5, iter_3_0 == var_3_1 and "" or "\x00")
	end

	return var_3_0
end

function var_0_0.stringify(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0, var_4_1 = pcall(json.stringify, arg_4_0)

	if not var_4_0 then
		error(var_4_1, 2)

		return
	end

	return var_0_14(var_4_1, arg_4_1, arg_4_2, arg_4_3)
end

return var_0_0
