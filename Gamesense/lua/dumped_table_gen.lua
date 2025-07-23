-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}
local var_0_1 = table.insert
local var_0_2 = table.concat
local var_0_3 = string.rep
local var_0_4 = string.len
local var_0_5 = string.sub
local var_0_6 = math.max
local var_0_7 = math.floor
local var_0_8 = math.ceil

local function var_0_9(arg_1_0)
	local var_1_0, var_1_1 = string.gsub(tostring(arg_1_0), "[^\x80-\xC1]", "")

	return var_1_1
end

local var_0_10 = {
	ASCII = {
		"-",
		"|",
		"+"
	},
	Compact = {
		"-",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		" "
	},
	["ASCII (Girder)"] = {
		"=",
		"||",
		"//",
		"[]",
		"\\\\",
		"|]",
		"[]",
		"[|",
		"\\\\",
		"[]",
		"//"
	},
	Unicode = {
		"═",
		"║",
		"╔",
		"╦",
		"╗",
		"╠",
		"╬",
		"╣",
		"╚",
		"╩",
		"╝"
	},
	["Unicode (Single Line)"] = {
		"─",
		"│",
		"┌",
		"┬",
		"┐",
		"├",
		"┼",
		"┤",
		"└",
		"┴",
		"┘"
	},
	["Markdown (Github)"] = {
		"-",
		"|",
		"|"
	}
}

for iter_0_0, iter_0_1 in pairs(var_0_10) do
	if #iter_0_1 == 3 then
		for iter_0_2 = 4, 11 do
			iter_0_1[iter_0_2] = iter_0_1[3]
		end
	end
end

local function var_0_11(arg_2_0, arg_2_1)
	arg_2_0 = var_0_5(arg_2_0, 1, arg_2_1)

	local var_2_0 = var_0_9(arg_2_0)

	return var_0_3(" ", var_0_7(arg_2_1 / 2 - var_2_0 / 2)) .. arg_2_0 .. var_0_3(" ", var_0_8(arg_2_1 / 2 - var_2_0 / 2))
end

local function var_0_12(arg_3_0, arg_3_1)
	arg_3_0 = var_0_5(arg_3_0, 1, arg_3_1)

	return arg_3_0 .. var_0_3(" ", arg_3_1 - var_0_9(arg_3_0))
end

function var_0_0.generate_table(arg_4_0, arg_4_1, arg_4_2)
	if type(arg_4_2) == "string" or arg_4_2 == nil then
		arg_4_2 = {
			style = arg_4_2 or "ASCII"
		}
	end

	if arg_4_2.top_line == nil then
		arg_4_2.top_line = arg_4_2.style ~= "Markdown (Github)"
	end

	if arg_4_2.bottom_line == nil then
		arg_4_2.bottom_line = arg_4_2.style ~= "Markdown (Github)"
	end

	if arg_4_2.header_seperator_line == nil then
		arg_4_2.header_seperator_line = true
	end

	local var_4_0 = var_0_10[arg_4_2.style] or var_0_10.ASCII
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = 0
	local var_4_4 = arg_4_1 ~= nil and #arg_4_1 > 0

	if var_4_4 then
		for iter_4_0 = 1, #arg_4_1 do
			var_4_2[iter_4_0] = var_0_9(arg_4_1[iter_4_0]) + 2
		end

		var_4_3 = #arg_4_1
	else
		for iter_4_1 = 1, #arg_4_0 do
			var_4_3 = var_0_6(var_4_3, #arg_4_0[iter_4_1])
		end
	end

	for iter_4_2 = 1, #arg_4_0 do
		local var_4_5 = arg_4_0[iter_4_2]

		for iter_4_3 = 1, var_4_3 do
			var_4_2[iter_4_3] = var_0_6(var_4_2[iter_4_3] or 2, var_0_9(var_4_5[iter_4_3]) + 2)
		end
	end

	local var_4_6 = {}

	for iter_4_4 = 1, var_4_3 do
		var_0_1(var_4_6, var_0_3(var_4_0[1], var_4_2[iter_4_4]))
	end

	if arg_4_2.top_line then
		var_0_1(var_4_1, var_4_0[3] .. var_0_2(var_4_6, var_4_0[4]) .. var_4_0[5])
	end

	if var_4_4 then
		local var_4_7 = {}

		for iter_4_5 = 1, var_4_3 do
			var_4_7[iter_4_5] = var_0_11(arg_4_1[iter_4_5], var_4_2[iter_4_5])
		end

		var_0_1(var_4_1, var_4_0[2] .. var_0_2(var_4_7, var_4_0[2]) .. var_4_0[2])

		if arg_4_2.header_seperator_line then
			var_0_1(var_4_1, var_4_0[6] .. var_0_2(var_4_6, var_4_0[7]) .. var_4_0[8])
		end
	end

	for iter_4_6 = 1, #arg_4_0 do
		local var_4_8 = arg_4_0[iter_4_6]
		local var_4_9 = {}

		if #var_4_8 == 0 then
			var_0_1(var_4_1, var_4_0[6] .. var_0_2(var_4_6, var_4_0[7]) .. var_4_0[8])
		else
			for iter_4_7 = 1, var_4_3 do
				local var_4_10 = arg_4_2.value_justify == "center" and var_0_11(var_4_8[iter_4_7] or "", var_4_2[iter_4_7] - 2) or var_0_12(var_4_8[iter_4_7] or "", var_4_2[iter_4_7] - 2)

				var_4_9[iter_4_7] = " " .. var_4_10 .. " "
			end

			var_0_1(var_4_1, var_4_0[2] .. var_0_2(var_4_9, var_4_0[2]) .. var_4_0[2])
		end
	end

	if arg_4_2.bottom_line and var_4_0[9] then
		var_0_1(var_4_1, var_4_0[9] .. var_0_2(var_4_6, var_4_0[10]) .. var_4_0[11])
	end

	return var_0_2(var_4_1, "\n")
end

return setmetatable(var_0_0, {
	__call = function(arg_5_0, ...)
		return var_0_0.generate_table(...)
	end
})
