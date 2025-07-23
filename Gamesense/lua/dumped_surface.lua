-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}
local var_0_1 = require("ffi")
local var_0_2 = require("bit").bor
local var_0_3 = var_0_1.string
local var_0_4 = var_0_1.cast

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	return var_0_1.cast(arg_1_2, var_0_1.cast("void***", arg_1_0)[0][arg_1_1])
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = client.create_interface(arg_2_0, arg_2_1) or error("invalid interface")
	local var_2_1, var_2_2 = pcall(var_0_1.typeof, arg_2_3)

	if not var_2_1 then
		error(var_2_2, 2)
	end

	local var_2_3 = var_0_5(var_2_0, arg_2_2, var_2_2) or error("invalid vtable")

	return function(...)
		return var_2_3(var_2_0, ...)
	end
end

local function var_0_7(arg_4_0, arg_4_1)
	local var_4_0 = var_0_1.typeof(arg_4_1)

	return function(arg_5_0, ...)
		assert(arg_5_0 ~= nil)

		if arg_5_0 then
			return var_0_5(arg_5_0, arg_4_0, var_4_0)(arg_5_0, ...)
		end
	end
end

local var_0_8 = var_0_1.typeof("char[?]")
local var_0_9 = var_0_1.typeof("int[1]")
local var_0_10 = var_0_1.typeof("wchar_t[?]")
local var_0_11 = var_0_6("localize.dll", "Localize_001", 15, "int(__thiscall*)(void*, const char*, wchar_t*, int)")
local var_0_12 = var_0_6("localize.dll", "Localize_001", 16, "int(__thiscall*)(void*, wchar_t*, char*, int)")
local var_0_13 = var_0_6("localize.dll", "Localize_001", 12, "wchar_t*(__thiscall*)(void*, const char*)")
local var_0_14 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_15 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 16, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_16 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 18, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_17 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 19, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_18 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 20, "void(__thiscall*)(void*, int*, int*, int)")
local var_0_19 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 23, "void(__thiscall*)(void*, unsigned long)")
local var_0_20 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 25, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_21 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 26, "void(__thiscall*)(void*, int, int)")
local var_0_22 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 28, "void(__thiscall*)(void*, const wchar_t*, int, int)")
local var_0_23 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 34, "int(__thiscall*)(void*, const char*)")
local var_0_24 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 35, "bool(__thiscall*)(void*, int, char*, int)")
local var_0_25 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 36, "void(__thiscall*)(void*, int, const char*, int, bool)")
local var_0_26 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 37, "void(__thiscall*)(void*, int, const wchar_t*, int, int)")
local var_0_27 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 38, "void(__thiscall*)(void*, int)")
local var_0_28 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 39, "void(__thiscall*)(void*, int)")
local var_0_29 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 40, "void(__thiscall*)(void*, int, int&, int&)")
local var_0_30 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 41, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_31 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 42, "bool(__thiscall*)(void*, int)")
local var_0_32 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 43, "int(__thiscall*)(void*, bool)")
local var_0_33 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 66, "void(__thiscall*)(void*)")
local var_0_34 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 67, "void(__thiscall*)(void*)")
local var_0_35 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 71, "unsigned int(__thiscall*)(void*)")
local var_0_36 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 72, "void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)")
local var_0_37 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 79, "void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)")
local var_0_38 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 100, "unsigned int(__thiscall*)(void*, int*, int*)")
local var_0_39 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 101, "unsigned int(__thiscall*)(void*, int, int)")
local var_0_40 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 103, "void(__thiscall*)(void*, int, int, int, int)")
local var_0_41 = var_0_6("vguimatsurface.dll", "VGUI_Surface031", 123, "void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)")

local function var_0_42(arg_6_0, arg_6_1)
	if arg_6_1 then
		local var_6_0 = 1024
		local var_6_1 = var_0_8(var_6_0)

		var_0_12(arg_6_0, var_6_1, var_6_0)

		local var_6_2 = var_0_3(var_6_1)

		return var_0_22(arg_6_0, var_6_2:len(), 0)
	else
		local var_6_3 = 1024
		local var_6_4 = var_0_10(var_6_3)

		var_0_11(arg_6_0, var_6_4, var_6_3)

		return var_0_22(var_6_4, arg_6_0:len(), 0)
	end
end

local function var_0_43(arg_7_0, arg_7_1)
	local var_7_0 = var_0_10(1024)
	local var_7_1 = var_0_9()
	local var_7_2 = var_0_9()

	var_0_11(arg_7_1, var_7_0, 1024)
	var_0_37(arg_7_0, var_7_0, var_7_1, var_7_2)

	local var_7_3 = tonumber(var_7_1[0])
	local var_7_4 = tonumber(var_7_2[0])

	return var_7_3, var_7_4
end

local var_0_44 = {}

function var_0_0.create_font(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = 0
	local var_8_1 = type(arg_8_3)

	if var_8_1 == "number" then
		var_8_0 = arg_8_3
	elseif var_8_1 == "table" then
		for iter_8_0 = 1, #arg_8_3 do
			var_8_0 = var_8_0 + arg_8_3[iter_8_0]
		end
	else
		error("invalid flags type, has to be number or table")
	end

	local var_8_2 = string.format("%s\x00%d\x00%d\x00%d", arg_8_0, arg_8_1, arg_8_2, var_8_0)

	if var_0_44[var_8_2] == nil then
		var_0_44[var_8_2] = var_0_35()

		var_0_36(var_0_44[var_8_2], arg_8_0, arg_8_1, arg_8_2, 0, 0, var_0_2(var_8_0), 0, 0)
	end

	return var_0_44[var_8_2]
end

function var_0_0.localize_string(arg_9_0, arg_9_1)
	local var_9_0 = var_0_13(arg_9_0)
	local var_9_1 = var_0_8(arg_9_1 or 1024)

	var_0_12(var_9_0, var_9_1, arg_9_1 or 1024)

	return var_9_1 and var_0_3(var_9_1) or nil
end

function var_0_0.draw_text(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	var_0_21(arg_10_0, arg_10_1)
	var_0_19(arg_10_6)
	var_0_20(arg_10_2, arg_10_3, arg_10_4, arg_10_5)

	return var_0_42(arg_10_7, false)
end

function var_0_0.draw_localized_text(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	var_0_21(arg_11_0, arg_11_1)
	var_0_19(arg_11_6)
	var_0_20(arg_11_2, arg_11_3, arg_11_4, arg_11_5)

	local var_11_0 = var_0_13(arg_11_7)

	return var_0_42(var_11_0, true)
end

function var_0_0.draw_line(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	var_0_14(arg_12_4, arg_12_5, arg_12_6, arg_12_7)

	return var_0_17(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
end

function var_0_0.draw_filled_rect(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	var_0_14(arg_13_4, arg_13_5, arg_13_6, arg_13_7)

	return var_0_15(arg_13_0, arg_13_1, arg_13_0 + arg_13_2, arg_13_1 + arg_13_3)
end

function var_0_0.draw_outlined_rect(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
	var_0_14(arg_14_4, arg_14_5, arg_14_6, arg_14_7)

	return var_0_16(arg_14_0, arg_14_1, arg_14_0 + arg_14_2, arg_14_1 + arg_14_3)
end

function var_0_0.draw_filled_outlined_rect(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11)
	var_0_14(arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	var_0_15(arg_15_0, arg_15_1, arg_15_0 + arg_15_2, arg_15_1 + arg_15_3)
	var_0_14(arg_15_8, arg_15_9, arg_15_10, arg_15_11)

	return var_0_16(arg_15_0, arg_15_1, arg_15_0 + arg_15_2, arg_15_1 + arg_15_3)
end

function var_0_0.draw_filled_gradient_rect(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12)
	var_0_14(arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	var_0_41(arg_16_0, arg_16_1, arg_16_0 + arg_16_2, arg_16_1 + arg_16_3, 255, 255, arg_16_12)
	var_0_14(arg_16_8, arg_16_9, arg_16_10, arg_16_11)

	return var_0_41(arg_16_0, arg_16_1, arg_16_0 + arg_16_2, arg_16_1 + arg_16_3, 0, 255, arg_16_12)
end

function var_0_0.draw_outlined_circle(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	var_0_14(arg_17_2, arg_17_3, arg_17_4, arg_17_5)

	return var_0_40(arg_17_0, arg_17_1, arg_17_6, arg_17_7)
end

function var_0_0.draw_poly_line(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	var_0_14(arg_18_2, arg_18_3, arg_18_4, arg_18_5)

	return var_0_18(var_0_9(arg_18_0), var_0_9(arg_18_1), arg_18_6)
end

function var_0_0.test_font(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0, var_19_1 = var_0_43(arg_19_6, "a b c d e f g h i j k l m n o p q r s t u v w x y z")

	var_0_0.draw_text(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, "a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ß + # ä ö ü , . -")
	var_0_0.draw_text(arg_19_0, arg_19_1 + var_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z = ! \" § $ % & / ( ) = ? { [ ] } \\ * ' _ : ; ~ ")
end

function var_0_0.get_text_size(arg_20_0, arg_20_1)
	return var_0_43(arg_20_0, arg_20_1)
end

function var_0_0.set_mouse_pos(arg_21_0, arg_21_1)
	return var_0_39(arg_21_0, arg_21_1)
end

function var_0_0.get_mouse_pos()
	local var_22_0 = var_0_9()
	local var_22_1 = var_0_9()

	var_0_38(var_22_0, var_22_1)

	local var_22_2 = tonumber(var_22_0[0])
	local var_22_3 = tonumber(var_22_1[0])

	return var_22_2, var_22_3
end

function var_0_0.unlock_cursor()
	return var_0_33()
end

function var_0_0.lock_cursor()
	return var_0_34()
end

function var_0_0.load_texture(arg_25_0)
	local var_25_0 = var_0_32(false)

	var_0_25(var_25_0, arg_25_0, true, true)

	local var_25_1 = var_0_9()
	local var_25_2 = var_0_9()

	var_0_29(var_25_0, var_25_1, var_25_2)

	local var_25_3 = tonumber(var_25_1[0])
	local var_25_4 = tonumber(var_25_2[0])

	return var_25_0, var_25_3, var_25_4
end

setmetatable(var_0_0, {
	__index = renderer
})

return var_0_0
