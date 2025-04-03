local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/uix")
local var_0_2 = client.set_event_callback
local var_0_3 = client.unset_event_callback
local var_0_4 = client.userid_to_entindex
local var_0_5 = entity.get_local_player
local var_0_6 = ui.get
local var_0_7 = ui.new_checkbox
local var_0_8 = ui.new_combobox
local var_0_9 = ui.set_callback
local var_0_10 = ui.set_visible

local function var_0_11(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = client.create_interface(arg_1_0, arg_1_1) or error("invalid interface", 2)
	local var_1_1 = client.find_signature(arg_1_0, arg_1_2) or error("invalid signature", 2)
	local var_1_2, var_1_3 = pcall(var_0_0.typeof, arg_1_3)

	if not var_1_2 then
		error(var_1_3, 2)
	end

	local var_1_4 = var_0_0.cast(var_1_3, var_1_1) or error("invalid typecast", 2)

	return function(...)
		return var_1_4(var_1_0, ...)
	end
end

local function var_0_12(arg_3_0, arg_3_1, arg_3_2)
	return var_0_0.cast(arg_3_2, var_0_0.cast("void***", arg_3_0)[0][arg_3_1])
end

local function var_0_13(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = client.create_interface(arg_4_0, arg_4_1) or error("invalid interface")
	local var_4_1, var_4_2 = pcall(var_0_0.typeof, arg_4_3)

	if not var_4_1 then
		error(var_4_2, 2)
	end

	local var_4_3 = var_0_12(var_4_0, arg_4_2, var_4_2) or error("invalid vtable")

	return function(...)
		return var_4_3(var_4_0, ...)
	end
end

local var_0_14
local var_0_15
local var_0_16
local var_0_17
local var_0_18 = {}
local var_0_19 = {}
local var_0_20 = var_0_0.typeof("int[1]")
local var_0_21 = var_0_0.typeof("char[?]")
local var_0_22 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xECj\x00\xFFu\x10\xFFu\f\xFFu\b\xE8\xCC\xCC\xCC\xCC]", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
local var_0_23 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xEC\x83\xEC\fS\x8Bً\r\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
local var_0_24 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xECS\x8B]\b\x85", "void(__thiscall*)(void*, int)")
local var_0_25 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xECV\x8Bu\bV\xFFu\f", "bool(__thiscall*)(void*, char*, int)")
local var_0_26 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xEC\x81\xEC\xCC\xCC\xCC̋U\bSVW", "void(__thiscall*)(void*, const char*, const char*, int)")
local var_0_27 = var_0_11("filesystem_stdio.dll", "VFileSystem017", "U\x8B\xEC\x0F\xB7E\b", "bool(__thiscall*)(void*, int)")
local var_0_28 = cvar.sndplaydelay
local var_0_29 = var_0_13("vguimatsurface.dll", "VGUI_Surface031", 82, "void(__thiscall*)(void*, const char*)")

local function var_0_30()
	local var_6_0 = {}
	local var_6_1 = var_0_20()
	local var_6_2 = var_0_22("*", "XGAME", var_6_1)

	while var_6_2 ~= nil do
		local var_6_3 = var_0_0.string(var_6_2)

		if var_0_27(var_6_1[0]) == false and (var_6_3:find(".mp3") or var_6_3:find(".wav")) then
			var_6_0[#var_6_0 + 1] = var_6_3
		end

		var_6_2 = var_0_23(var_6_1[0])
	end

	var_0_24(var_6_1[0])

	return var_6_0
end

local function var_0_31(arg_7_0)
	if arg_7_0:find("_") then
		arg_7_0 = arg_7_0:gsub("_", " ")
	end

	if arg_7_0:find(".mp3") then
		arg_7_0 = arg_7_0:gsub(".mp3", "")
	end

	if arg_7_0:find(".wav") then
		arg_7_0 = arg_7_0:gsub(".wav", "")
	end

	return arg_7_0
end

local function var_0_32(arg_8_0)
	if var_0_4(arg_8_0.attacker) == var_0_5() then
		local var_8_0 = var_0_19[arg_8_0.hitgroup == 1 and var_0_6(var_0_15) or var_0_6(var_0_16)]

		if var_8_0 then
			for iter_8_0 = 1, var_0_6(var_0_17) do
				var_0_29(var_8_0)
			end
		end
	end
end

local function var_0_33(arg_9_0)
	if var_0_4(arg_9_0.attacker) == var_0_5() then
		local var_9_0 = var_0_19[var_0_6(var_0_16)]

		var_0_28:invoke_callback(0, var_9_0)
	end
end

local function var_0_34(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 or var_0_6(arg_10_0)

	var_0_10(var_0_15, var_10_0)
	var_0_10(var_0_16, var_10_0)
	var_0_10(var_0_17, var_10_0)
end

local function var_0_35(arg_11_0, arg_11_1)
	var_0_18[#var_0_18 + 1] = arg_11_0
	var_0_19[arg_11_0] = arg_11_1
end

;(function()
	var_0_35("Wood stop", "doors/wood_stop1.wav")
	var_0_35("Wood strain", "physics/wood/wood_strain7.wav")
	var_0_35("Wood plank impact", "physics/wood/wood_plank_impact_hard4.wav")
	var_0_35("Warning", "resource/warning.wav")

	local var_12_0 = var_0_21(128)

	var_0_25(var_12_0, var_0_0.sizeof(var_12_0))

	local var_12_1 = string.format("%s\\csgo\\sound\\hitsounds", var_0_0.string(var_12_0))

	var_0_26(var_12_1, "XGAME", 0)

	local var_12_2 = var_0_30()

	for iter_12_0 = 1, #var_12_2 do
		local var_12_3 = var_12_2[iter_12_0]

		var_0_35(var_0_31(var_12_3), string.format("hitsounds/%s", var_12_3))
	end

	var_0_14 = var_0_1.new_checkbox("LUA", "B", "Hit marker sound")
	var_0_15 = var_0_8("LUA", "B", "Head shot sound", var_0_18)
	var_0_16 = var_0_8("LUA", "B", "Body shot sound", var_0_18)
	var_0_17 = ui.new_slider("LUA", "B", "\nSound volume", 1, 100, 1, true, "%")

	var_0_14:on("change", var_0_34)
	var_0_14:on("player_hurt", var_0_32)
	var_0_14:on("player_blind", var_0_33)
end)()
