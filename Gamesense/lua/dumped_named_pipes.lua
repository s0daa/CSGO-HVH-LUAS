-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = string.match
local var_0_2 = string.len
local var_0_3 = string.gsub
local var_0_4 = string.gmatch
local var_0_5 = string.byte
local var_0_6 = var_0_0.cast
local var_0_7 = var_0_0.typeof
local var_0_8 = var_0_0.string
local var_0_9 = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̅\xC0t\v") or error("Couldn't find signature #1")
local var_0_10 = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̣\xCC\xCC\xCC\xCC\xEB\x05") or error("Couldn't find signature #2")
local var_0_11 = client.find_signature("engine.dll", "\xFF\xE1")
local var_0_12 = var_0_6("uint32_t**", var_0_6("uint32_t", var_0_10) + 2)[0][0]
local var_0_13 = var_0_6("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", var_0_11)
local var_0_14 = var_0_6("uint32_t**", var_0_6("uint32_t", var_0_9) + 2)[0][0]
local var_0_15 = var_0_6("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", var_0_11)

local function var_0_16(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = var_0_7(arg_1_2)
	local var_1_1 = var_0_15(var_0_14, 0, arg_1_0)
	local var_1_2 = var_0_13(var_0_12, 0, var_1_1, arg_1_1)
	local var_1_3 = var_0_6(var_1_0, var_0_11)

	return function(...)
		return var_1_3(var_1_2, 0, ...)
	end
end

local var_0_17 = var_0_7("unsigned long[?]")
local var_0_18 = var_0_7("const char*")
local var_0_19 = var_0_7("const char[?]")
local var_0_20 = var_0_7("unsigned short*")
local var_0_21 = var_0_7("unsigned short[?]")

local function var_0_22(arg_3_0)
	local var_3_0 = var_0_2(arg_3_0) + 1
	local var_3_1 = var_0_21(var_3_0)
	local var_3_2 = 0

	for iter_3_0 in var_0_4(arg_3_0, ".") do
		var_3_1[var_3_2] = var_0_5(iter_3_0)
		var_3_2 = var_3_2 + 1
	end

	return var_0_6(var_0_20, var_3_1)
end

local var_0_23 = var_0_16("kernel32.dll", "CreateFileW", "void*(__fastcall*)(unsigned int, unsigned int, const wchar_t*, unsigned long, unsigned long, void*, unsigned long, unsigned long, void*)")
local var_0_24 = var_0_16("kernel32.dll", "CloseHandle", "bool(__fastcall*)(unsigned int, unsigned int, void*)")
local var_0_25 = var_0_16("kernel32.dll", "WriteFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
local var_0_26 = var_0_16("kernel32.dll", "ReadFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
local var_0_27 = var_0_16("kernel32.dll", "PeekNamedPipe", "bool(__fastcall*)(unsigned int, unsigned int, void*, void*, unsigned long, unsigned long*, unsigned long*, unsigned long*)")
local var_0_28 = var_0_16("kernel32.dll", "GetLastError", "unsigned long(__fastcall*)(unsigned int, unsigned int)")
local var_0_29 = var_0_16("kernel32.dll", "GetFileType", "unsigned long(__fastcall*)(unsigned int, unsigned int, void*)")
local var_0_30 = 2147483648
local var_0_31 = 1073741824
local var_0_32 = bit.bor(var_0_30, var_0_31)
local var_0_33 = 1
local var_0_34 = 3
local var_0_35 = 67108992
local var_0_36 = 128
local var_0_37 = 3
local var_0_38 = var_0_0.cast("void*", -1)
local var_0_39 = {}
local var_0_40 = {}
local var_0_41 = {
	nil,
	"File not found",
	"Path not found",
	nil,
	"Access denied",
	[230] = "Bad pipe",
	[80] = "File exists",
	[109] = "Broken pipe",
	[231] = "Pipe busy"
}

local function var_0_42()
	local var_4_0 = var_0_28()

	return var_0_41[var_4_0] or tostring(var_4_0)
end

local function var_0_43(arg_5_0)
	if type(arg_5_0) ~= "string" then
		return error("Invalid path, expected string", 2)
	elseif not var_0_1(arg_5_0, "^\\\\%?\\pipe\\") then
		return error("Invalid path, expected \\\\?\\pipe\\", 2)
	end

	local var_5_0 = var_0_22(arg_5_0)
	local var_5_1 = var_0_23(var_5_0, var_0_32, 0, nil, var_0_34, 0, nil)

	if var_5_1 == var_0_38 then
		return error("Failed to open pipe: " .. var_0_42())
	elseif var_0_29(var_5_1) ~= var_0_37 then
		var_0_24(var_5_1)

		return error("Failed to open pipe: Invalid file type")
	end

	local var_5_2 = setmetatable({
		path = arg_5_0
	}, var_0_39)

	var_0_40[var_5_2] = {
		open = true,
		handle = var_5_1
	}

	return var_5_2
end

local function var_0_44(arg_6_0)
	local var_6_0 = var_0_40[arg_6_0]

	if var_6_0 == nil then
		return error("Invalid pipe")
	end

	var_0_40[arg_6_0] = nil

	if not var_0_24(var_6_0.handle) then
		return error("Failed to close pipe: " .. var_0_42())
	end
end

local function var_0_45(arg_7_0, arg_7_1)
	local var_7_0 = var_0_40[arg_7_0]

	if var_7_0 == nil then
		return error("Invalid pipe")
	end

	arg_7_1 = tostring(arg_7_1) or ""

	local var_7_1 = var_0_17(1)
	local var_7_2 = var_0_2(arg_7_1)

	if var_0_25(var_7_0.handle, arg_7_1, var_7_2, var_7_1, nil) then
		return tonumber(var_7_1[0])
	else
		return error("Failed to write: " .. var_0_42())
	end
end

local function var_0_46(arg_8_0, arg_8_1)
	if arg_8_1 ~= nil then
		if type(arg_8_1) ~= "number" then
			return error("Invalid size, expected number or nil", 2)
		elseif arg_8_1 < 0 then
			return error("Invalid size", 2)
		end
	end

	local var_8_0 = var_0_40[arg_8_0]

	if var_8_0 == nil then
		return error("Invalid pipe")
	end

	local var_8_1 = var_0_17(1)

	if var_0_27(var_8_0.handle, nil, 0, nil, var_8_1, nil) then
		local var_8_2 = var_8_1[0]

		if arg_8_1 == nil and var_8_2 > 0 then
			arg_8_1 = var_8_2
		elseif arg_8_1 ~= nil and var_8_2 < arg_8_1 then
			arg_8_1 = nil
		end

		if arg_8_1 ~= nil then
			local var_8_3 = var_0_19(arg_8_1)
			local var_8_4 = var_0_17(1)

			if var_0_26(var_8_0.handle, var_8_3, arg_8_1, var_8_4, nil) and var_8_4[0] == arg_8_1 then
				return var_0_8(var_8_3, arg_8_1)
			else
				return error("Failed to read: " .. var_0_42())
			end
		end
	else
		return error("Failed to peek: " .. var_0_42())
	end
end

var_0_39.__index = {
	close = var_0_44,
	read = var_0_46,
	write = var_0_45
}

client.set_event_callback("shutdown", function()
	for iter_9_0, iter_9_1 in pairs(var_0_40) do
		pcall(var_0_44, iter_9_0)
	end
end)

return {
	open_pipe = var_0_43
}
