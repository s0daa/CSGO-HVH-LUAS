-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = string.len
local var_0_2 = tostring
local var_0_3 = var_0_0.string
local var_0_4 = {}
local var_0_5 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local var_0_6 = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
local var_0_7 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
local var_0_8 = var_0_0.typeof("char[?]")

function var_0_4.get()
	local var_1_0 = var_0_5()

	if var_1_0 > 0 then
		local var_1_1 = var_0_8(var_1_0)

		var_0_7(0, var_1_1, var_1_0)

		return var_0_3(var_1_1, var_1_0 - 1)
	end
end

var_0_4.paste = var_0_4.get

function var_0_4.set(arg_2_0)
	arg_2_0 = var_0_2(arg_2_0)

	var_0_6(arg_2_0, var_0_1(arg_2_0))
end

var_0_4.copy = var_0_4.set

return var_0_4
