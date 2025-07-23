-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = var_0_0.cast
local var_0_2 = var_0_0.string
local var_0_3 = json.stringify
local var_0_4 = panorama.loadstring("\treturn {\n\t\tlocalize: (str, params) => {\n\t\t\tif(params == null)\n\t\t\t\treturn $.Localize(str)\n\n\t\t\tvar panel = $.CreatePanel(\"Panel\", $.GetContextPanel(), \"\")\n\n\t\t\tfor(key in params) {\n\t\t\t\tpanel.SetDialogVariable(key, params[key])\n\t\t\t}\n\n\t\t\tvar result = $.Localize(str, panel)\n\n\t\t\tpanel.DeleteAsync(0.0)\n\n\t\t\treturn result\n\t\t},\n\t\tlanguage: () => {\n\t\t\treturn $.Language()\n\t\t}\n\t}\n")()
local var_0_5 = var_0_0.typeof("char[?]")
local var_0_6 = var_0_0.typeof("uint16_t*")
local var_0_7 = vtable_bind("localize.dll", "Localize_001", 16, "int(__thiscall*)(void*, const unsigned char*, char*, int)")
local var_0_8 = vtable_bind("localize.dll", "Localize_001", 11, "unsigned char*(__thiscall*)(void*, const char*)")

local function var_0_9(arg_1_0)
	arg_1_0 = var_0_1("wchar_t*", arg_1_0)

	local var_1_0 = 0

	while arg_1_0[var_1_0] ~= 0 do
		var_1_0 = var_1_0 + 1
	end

	return var_1_0 + 1
end

local function var_0_10(arg_2_0)
	local var_2_0 = var_0_8(arg_2_0)

	if var_2_0 == nil then
		return arg_2_0
	end

	local var_2_1 = var_0_9(var_2_0)
	local var_2_2 = var_0_5(var_2_1)
	local var_2_3 = var_0_7(var_2_0, var_2_2, var_2_1)

	if var_2_3 < 2 then
		return ""
	end

	return var_2_2 and var_0_2(var_2_2, var_2_3 - 1) or nil
end

local var_0_11 = var_0_4.language()
local var_0_12 = {}

local function var_0_13(arg_3_0, arg_3_1)
	if arg_3_0 == nil then
		return ""
	end

	local var_3_0 = var_0_12[arg_3_0]

	if var_3_0 == nil then
		var_3_0 = {}
		var_0_12[arg_3_0] = var_3_0
	end

	local var_3_1 = arg_3_1 ~= nil
	local var_3_2 = var_3_1 and var_0_3(arg_3_1) or true

	if var_3_0[var_3_2] == nil then
		var_3_0[var_3_2] = var_3_1 and var_0_4.localize(arg_3_0, arg_3_1) or var_0_10(arg_3_0)
	end

	return var_3_0[var_3_2]
end

local var_0_14 = var_0_13

if var_0_11 ~= "english" then
	function var_0_14(arg_4_0, ...)
		return var_0_13("#[english]" .. arg_4_0:sub(2, -1))
	end
end

return setmetatable({
	localize = var_0_13,
	localize_english = var_0_14,
	language = function()
		return var_0_11
	end
}, {
	__call = function(arg_6_0, ...)
		return var_0_13(...)
	end
})
