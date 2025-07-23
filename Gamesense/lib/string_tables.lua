-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = -1
local var_0_2 = vtable_bind("engine.dll", "VEngineClientStringTable001", 3, "void*(__thiscall*)(void*, const char*)")
local var_0_3 = vtable_bind("engine.dll", "VEngineClientStringTable001", 4, "void*(__thiscall*)(void*, int)")
local var_0_4 = vtable_bind("engine.dll", "VEngineClientStringTable001", 5, "int(__thiscall*)(void*)")
local var_0_5 = vtable_bind("engine.dll", "VEngineClientStringTable001", 6, "void(__thiscall*)(void*, void*, bool)")
local var_0_6 = vtable_thunk(1, "const char*(__thiscall*)(void*)")
local var_0_7 = vtable_thunk(2, "int(__thiscall*)(void*)")
local var_0_8 = vtable_thunk(3, "int(__thiscall*)(void*)")
local var_0_9 = vtable_thunk(4, "int(__thiscall*)(void*)")
local var_0_10 = vtable_thunk(8, "int(__thiscall*)(void*, bool, const char*, int, const void*)")
local var_0_11 = vtable_thunk(9, "const char*(__thiscall*)(void*, int)")
local var_0_12 = vtable_thunk(10, "const char*(__thiscall*)(void*, int, int, const void*)")
local var_0_13 = vtable_thunk(11, "const void*(__thiscall*)(void*, int, int*)")
local var_0_14 = vtable_thunk(12, "int(__thiscall*)(void*, const char*)")

local function var_0_15(arg_1_0, arg_1_1)
	if arg_1_0 ~= nil then
		if type(arg_1_0) == "string" then
			arg_1_1 = arg_1_0:len()
			arg_1_0 = var_0_0.new("char[?]", arg_1_1, arg_1_0)
		end
	else
		arg_1_1 = -1
	end

	return arg_1_0, arg_1_1
end

local var_0_16 = {
	name = function(arg_2_0)
		local var_2_0 = var_0_6(arg_2_0)

		if var_2_0 ~= nil then
			return var_0_0.string(var_2_0)
		end
	end,
	id = function(arg_3_0)
		return var_0_7(arg_3_0)
	end,
	size = function(arg_4_0)
		return var_0_8(arg_4_0)
	end,
	max_size = function(arg_5_0)
		return var_0_9(arg_5_0)
	end,
	add = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_6_2, arg_6_3 = var_0_15(arg_6_2, arg_6_3)

		return var_0_10(arg_6_0, false, arg_6_1, arg_6_3, arg_6_2)
	end,
	get = function(arg_7_0, arg_7_1)
		if arg_7_1 > #arg_7_0 then
			return
		end

		local var_7_0 = var_0_11(arg_7_0, arg_7_1)

		if var_7_0 ~= nil then
			return var_0_0.string(var_7_0)
		end
	end,
	get_user_data = function(arg_8_0, arg_8_1)
		if arg_8_0:get(arg_8_1) == nil then
			return
		end

		local var_8_0 = var_0_0.new("int[1]")
		local var_8_1 = var_0_13(arg_8_0, arg_8_1, var_8_0)

		if var_8_1 ~= nil then
			return var_8_1, var_8_0[0]
		end
	end,
	set_user_data = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		arg_9_2, arg_9_3 = var_0_15(arg_9_2, arg_9_3)

		return var_0_12(arg_9_0, arg_9_1, arg_9_3, arg_9_2)
	end,
	find = function(arg_10_0, arg_10_1)
		local var_10_0 = var_0_14(arg_10_0, arg_10_1)

		if var_10_0 ~= var_0_1 then
			return var_10_0
		end
	end
}

local function var_0_17(arg_11_0, arg_11_1)
	arg_11_1 = arg_11_1 + 1

	local var_11_0 = arg_11_0[arg_11_1]

	if var_11_0 ~= nil then
		return arg_11_1, var_11_0
	end
end

local var_0_18 = var_0_0.metatype("struct {}", {
	__index = function(arg_12_0, arg_12_1)
		if type(arg_12_1) == "number" then
			return var_0_16.get(arg_12_0, arg_12_1)
		end

		return var_0_16[arg_12_1]
	end,
	__tostring = function(arg_13_0)
		return string.format("<string table \"%s\">", var_0_16.name(arg_13_0))
	end,
	__len = function(arg_14_0)
		return var_0_16.size(arg_14_0)
	end,
	__pairs = function(arg_15_0)
		return var_0_17, arg_15_0, 0
	end,
	__ipairs = function(arg_16_0)
		return var_0_17, arg_16_0, 0
	end
})
local var_0_19 = var_0_0.typeof("$*", var_0_18)

local function var_0_20(arg_17_0)
	local var_17_0 = var_0_2(arg_17_0)

	if var_17_0 ~= nil then
		return var_0_0.cast(var_0_19, var_17_0)[0]
	end
end

return (setmetatable({
	get_all = function()
		local var_18_0 = {}

		for iter_18_0 = 0, var_0_4() - 1 do
			local var_18_1 = var_0_3(iter_18_0)

			if var_18_1 ~= nil then
				table.insert(var_18_0, var_0_0.cast(var_0_19, var_18_1)[0])
			end
		end

		return var_18_0
	end
}, {
	__metatable = false,
	__index = function(arg_19_0, arg_19_1)
		if type(arg_19_1) ~= "string" then
			return
		end

		return var_0_20(arg_19_1)
	end
}))
