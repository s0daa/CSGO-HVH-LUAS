local var_0_0 = client.delay_call
local var_0_1 = client.find_signature
local var_0_2 = globals.realtime
local var_0_3 = panorama.open
local var_0_4 = error
local var_0_5 = print
local var_0_6 = require("ffi")
local var_0_7 = require("gamesense/uix")
local var_0_8 = var_0_3()
local var_0_9 = 0
local var_0_10
local var_0_11
local var_0_12 = var_0_1("engine.dll", "\x8B\r\xCC\xCC\xCC̅\xC9t\x16\x8B\x01\x8B") or var_0_4("Invalid signature #1")
local var_0_13 = var_0_1("gameoverlayrenderer.dll", "U\x8B\xEC\x83\xEC\x14\x8BE\f\xF7") or var_0_4("Invalid signature #2")
local var_0_14 = var_0_1("gameoverlayrenderer.dll", "\xFF\xE1") or var_0_4("Invalid signature #3")
local var_0_15 = var_0_1("gameoverlayrenderer.dll", "\xFF\x15\xCC\xCC\xCC\xCC;\xC6t") or var_0_4("Invalid signature #4")
local var_0_16 = var_0_6.cast("uintptr_t***", var_0_6.cast("uintptr_t", var_0_12) + 2)[0][0] + 2
local var_0_17 = var_0_6.cast("int(__stdcall*)(uintptr_t, int)", var_0_13)
local var_0_18 = var_0_6.cast("int(__thiscall*)(uintptr_t)", var_0_14)
local var_0_19 = var_0_6.cast("uintptr_t**", var_0_6.cast("uintptr_t", var_0_15) + 2)[0][0]

local function var_0_20()
	return var_0_16[0]
end

local function var_0_21()
	return var_0_18(var_0_19)
end

local function var_0_22()
	local var_3_0 = var_0_20()

	if var_0_21() ~= var_3_0 then
		var_0_17(var_3_0, 1)

		return true
	end

	return false
end

local function var_0_23()
	if var_0_22() then
		var_0_0(1, var_0_23)
	end
end

local function var_0_24()
	if var_0_2() >= var_0_9 then
		if var_0_8.PartyListAPI.GetPartySessionSetting("game/mmqueue") == "reserved" then
			var_0_22()
		end

		var_0_9 = var_0_2() + 1
	end
end

local var_0_25 = var_0_7.new_checkbox("LUA", "A", "Notify on match found")

var_0_25:on("paint_ui", var_0_24)
var_0_25:set(true)

local var_0_26 = var_0_7.new_checkbox("LUA", "A", "Notify on round start")

var_0_26:on("round_start", var_0_23)
var_0_26:set(true)
