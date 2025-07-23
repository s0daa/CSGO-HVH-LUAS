-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = string.gsub
local var_0_2 = pairs
local var_0_3 = {
	["{lightred}"] = "\x0F",
	‮ = "",
	["{violet}"] = "\x0E",
	["%%"] = "%%%%",
	["{purple}"] = "\r",
	["{darkblue}"] = "\f",
	["{blue}"] = "\v",
	["{bluegrey}"] = "\n",
	["{yellow}"] = "\t",
	["{grey}"] = "\b",
	["{red}"] = "\a",
	["{lime}"] = "\x06",
	["{lightgreen}"] = "\x05",
	["{green}"] = "\x04",
	["{team}"] = "\x03",
	["{darkred}"] = "\x02",
	  = "",
	["{white}"] = "\x01",
	["{orange}"] = "\x10",
	["  +"] = function(arg_1_0)
		return " " .. ("\x18 "):rep(arg_1_0:len() - 1)
	end
}

local function var_0_4(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = client.find_signature(arg_2_0, arg_2_1) or error("signature not found", 2)
	local var_2_1 = var_0_0.cast("uintptr_t", var_2_0)

	if arg_2_3 ~= nil and arg_2_3 ~= 0 then
		var_2_1 = var_2_1 + arg_2_3
	end

	if arg_2_4 ~= nil then
		for iter_2_0 = 1, arg_2_4 do
			var_2_1 = var_0_0.cast("uintptr_t*", var_2_1)[0]

			if var_2_1 == nil then
				return error("signature not found", 2)
			end
		end
	end

	return var_0_0.cast(arg_2_2, var_2_1)
end

local function var_0_5(arg_3_0, arg_3_1)
	local var_3_0 = ""

	for iter_3_0 = 1, #arg_3_0 do
		var_3_0 = var_3_0 .. tostring(arg_3_0[iter_3_0]) .. (iter_3_0 == #arg_3_0 and "" or arg_3_1)
	end

	return var_3_0
end

local var_0_6 = var_0_4("client.dll", "\xB9\xCC\xCC\xCC̈F\t", "void*", 1, 1)
local var_0_7 = var_0_4("client.dll", "U\x8B\xECS\x8B]\bVW\x8B\xF93\xF69w(", "void***(__thiscall*)(void*, const char*)")
local var_0_8 = vtable_thunk(27, "void(__cdecl*)(void*, int, int, const char*, ...)")
local var_0_9 = var_0_7(var_0_6, "CHudChat")

if var_0_9 == nil then
	error("CHudChat not found")
end

local var_0_10 = var_0_7(var_0_6, "CCSGO_HudChat")

if var_0_10 == nil then
	error("CCSGO_HudChat not found")
end

local var_0_11 = var_0_0.cast("bool*", var_0_10) + 88

local function var_0_12(arg_4_0, ...)
	local var_4_0 = var_0_5(arg_4_0 == 0 and {
		" ",
		...
	} or {
		...
	}, "")

	for iter_4_0, iter_4_1 in var_0_2(var_0_3) do
		var_4_0 = var_0_1(var_4_0, iter_4_0, iter_4_1)
	end

	var_0_8(var_0_9, arg_4_0, 0, var_4_0)
end

local function var_0_13(...)
	return var_0_12(0, ...)
end

local function var_0_14()
	return var_0_11[0]
end

return {
	print = var_0_13,
	print_player = var_0_12,
	is_open = var_0_14
}
