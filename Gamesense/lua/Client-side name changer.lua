local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/string_tables")

local function var_0_2(arg_1_0)
	local var_1_0 = var_0_0.cast("uint8_t*", arg_1_0)

	if var_1_0[0] == 232 then
		return var_1_0 + var_0_0.cast("int32_t*", var_1_0 + 1)[0] + 5
	elseif var_1_0[0] == 255 and var_1_0[1] == 21 then
		return var_0_0.cast("uint32_t**", var_0_0.cast("const char*", arg_1_0) + 2)[0][0]
	else
		error(string.format("unknown instruction to follow: %02X!", var_1_0[0]))
	end
end

local var_0_3 = var_0_0.typeof("\tstruct {\n\t\tuint64_t version;\n\t\tuint64_t xuid;\n\t\tchar name[128];\n\t\tint userid;\n\t\tchar guid[33];\n\t\tuint32_t friendsid;\n\t\tchar friendsname[128];\n\t\tbool isbot;\n\t\tbool ishltv;\n\t\tuint32_t customfiles[4];\n\t\tuint8_t filesdownloaded;\n\t}\n")
local var_0_4 = var_0_0.typeof("$*", var_0_3)
local var_0_5 = var_0_0.cast("char*(__thiscall*)(void*, const char*)", var_0_2(client.find_signature("client.dll", "\xE8\xCC\xCC\xCC̉\x87\x1C\x03\x00\x00")))
local var_0_6 = var_0_0.cast("void**", var_0_0.cast("char*", client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC̉\x06")) + 1)[0]
local var_0_7 = ui.new_checkbox("MISC", "Miscellaneous", "Client side name")
local var_0_8 = ui.new_textbox("MISC", "Miscellaneous", "Client side name text")
local var_0_9 = ui.new_string("Client side string", "")

ui.set_visible(var_0_8, false)

local var_0_10
local var_0_11

local function var_0_12(arg_2_0)
	local var_2_0 = entity.get_local_player()

	if var_2_0 == nil then
		return
	end

	local var_2_1 = var_0_1.userinfo

	if var_2_1 == nil then
		return
	end

	local var_2_2 = var_0_0.cast(var_0_4, var_2_1:get_user_data(var_2_0 - 1))

	if var_2_2 == nil then
		return
	end

	local var_2_3 = var_0_0.string(var_2_2.name)

	if var_2_3 ~= var_0_10 then
		var_0_11 = var_2_3
	end

	arg_2_0 = arg_2_0 or var_0_11

	if arg_2_0 == nil then
		return
	end

	var_0_0.copy(var_2_2.name, arg_2_0)

	local var_2_4 = var_0_5(var_0_6, arg_2_0)

	if var_2_4 ~= nil then
		var_0_0.copy(var_2_4, arg_2_0)
	end

	var_0_10 = arg_2_0
end

local function var_0_13()
	local var_3_0 = ui.get(var_0_8):sub(1, 128)

	ui.set(var_0_9, var_3_0)

	if var_3_0 == "" then
		var_3_0 = " "
	end

	var_0_12(var_3_0)
end

local function var_0_14()
	var_0_12()
end

ui.set_callback(var_0_7, function()
	local var_5_0 = ui.get(var_0_7)

	if var_5_0 then
		client.set_event_callback("net_update_end", var_0_13)
		client.set_event_callback("shutdown", var_0_14)
	else
		client.unset_event_callback("net_update_end", var_0_13)
		client.unset_event_callback("shutdown", var_0_14)
		var_0_14()
	end

	ui.set_visible(var_0_8, var_5_0)
end)
client.delay_call(0, function()
	ui.set(var_0_8, ui.get(var_0_9))
end)
client.set_event_callback("post_config_load", function()
	ui.set(var_0_8, ui.get(var_0_9))
end)
