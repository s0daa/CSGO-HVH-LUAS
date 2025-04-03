local var_0_0 = require("vector")
local var_0_1 = require("gamesense/entity")
local var_0_2 = require("gamesense/antiaim_funcs")
local var_0_3 = require("gamesense/csgo_weapons")
local var_0_4 = ui.new_checkbox("RAGE", "Other", "Force baim on lethal")
local var_0_5 = ui.new_multiselect("RAGE", "Other", "\n", "Extrapolate local player", "Double tap", "I'm an advanced user")
local var_0_6 = ui.new_checkbox("RAGE", "Other", "Visualise calculations")
local var_0_7 = ui.new_slider("RAGE", "Other", "Trace add distance", 5, 50, 20, true, "u")
local var_0_8 = ui.reference("PLAYERS", "Players", "Player list")
local var_0_9 = ui.reference("PLAYERS", "Players", "Reset all")
local var_0_10 = ui.new_checkbox("PLAYERS", "Adjustments", "Ignore force baim calculations")
local var_0_11, var_0_12 = ui.reference("Rage", "Aimbot", "Double tap")
local var_0_13 = false
local var_0_14 = {
	2,
	3,
	4,
	5,
	7,
	8
}
local var_0_15 = {}
local var_0_16

local function var_0_17(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true, iter_1_0
		end
	end

	return false, -1
end

local function var_0_18(arg_2_0, arg_2_1, arg_2_2)
	return arg_2_1 + var_0_0(arg_2_0:get_prop("m_vecVelocity")) * arg_2_2 * globals.tickinterval()
end

local function var_0_19(arg_3_0)
	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		plist.set(iter_3_1:get_entindex(), "Override prefer body aim", "-")
	end
end

local function var_0_20(arg_4_0)
	local var_4_0 = var_0_0(arg_4_0:get_prop("m_vecOrigin"))

	var_4_0.z = var_4_0.z + arg_4_0:get_prop("m_vecViewOffset[2]")

	return var_4_0
end

local function var_0_21(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = arg_5_0:to(arg_5_1):vectors()
	local var_5_2 = arg_5_0:clone() + var_5_0

	var_5_2.z = arg_5_0.z

	local var_5_3 = ui.get(var_0_7)

	return {
		var_5_2,
		var_5_2 + var_5_0 * var_5_3,
		var_5_2 - var_5_0 * var_5_3
	}
end

local function var_0_22(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2 and var_0_18(arg_6_0, var_0_20(arg_6_0), 5) or var_0_20(arg_6_0)
	local var_6_1 = var_0_20(arg_6_1)
	local var_6_2 = var_0_21(var_6_0, var_6_1)
	local var_6_3 = 0

	for iter_6_0, iter_6_1 in ipairs(var_6_2) do
		local var_6_4 = 0

		for iter_6_2 = 1, #var_0_14 do
			local var_6_5 = var_0_0(arg_6_1:hitbox_position(var_0_14[iter_6_2]))
			local var_6_6, var_6_7 = arg_6_0:trace_bullet(iter_6_1.x, iter_6_1.y, iter_6_1.z, var_6_5.x, var_6_5.y, var_6_5.z, false)

			if var_6_3 < var_6_7 then
				var_6_3 = var_6_7
			end

			if var_6_4 < var_6_7 then
				var_6_4 = var_6_7
			end
		end

		if arg_6_3 then
			local var_6_8 = var_0_0(renderer.world_to_screen(var_6_1:unpack()))
			local var_6_9 = var_0_0(renderer.world_to_screen(iter_6_1:unpack()))
			local var_6_10 = var_0_0(renderer.world_to_screen(var_6_0:unpack()))

			if var_6_8:length() ~= 0 and var_6_9:length() ~= 0 and var_6_10:length() ~= 0 then
				renderer.text(var_6_9.x, var_6_9.y, 255, 0, 0, 255, "d+", 0, string.format("%s", var_6_4))
				renderer.line(var_6_8.x, var_6_8.y, var_6_9.x, var_6_9.y, 255, 255, 255, 255)
				renderer.line(var_6_9.x, var_6_9.y, var_6_10.x, var_6_10.y, 255, 255, 255, 255)
			end
		end
	end

	return var_6_3
end

local function var_0_23(arg_7_0)
	return arg_7_0 and arg_7_0.cycletime and arg_7_0.cycletime >= 0.2 and arg_7_0.cycletime <= 0.3
end

local function var_0_24(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 <= arg_8_2 then
		return true
	end

	if ui.get(var_0_11) and ui.get(var_0_12) and var_0_2.get_tickbase_shifting() > 2 and var_0_17(ui.get(var_0_5), "Double tap") then
		return var_0_23(arg_8_0) and arg_8_1 <= arg_8_2 * 2
	end

	return false
end

local function var_0_25(arg_9_0)
	local var_9_0 = var_0_1.new(client.current_threat())

	if var_9_0 == nil then
		return
	end

	if var_0_17(var_0_15, var_9_0:get_entindex()) then
		return
	end

	local var_9_1 = var_0_1.get_local_player()
	local var_9_2 = var_9_0:get_entindex()
	local var_9_3 = var_0_17(ui.get(var_0_5), "Extrapolate local player")
	local var_9_4 = var_0_22(var_9_1, var_9_0, var_9_3, arg_9_0)

	if arg_9_0 then
		return
	end

	local var_9_5 = var_9_0:get_prop("m_iHealth")
	local var_9_6 = var_9_1:get_player_weapon()
	local var_9_7 = var_0_3(var_9_6:get_entindex())
	local var_9_8 = var_0_24(var_9_7, var_9_5, var_9_4)

	if var_0_16 ~= nil and var_0_16:get_entindex() ~= var_9_2 then
		plist.set(var_0_16:get_entindex(), "Override prefer body aim", "-")
	end

	var_0_16 = var_9_0

	plist.set(var_9_2, "Override prefer body aim", var_9_8 and "Force" or "-")
end

local function var_0_26(arg_10_0)
	var_0_25(false)
end

local function var_0_27()
	var_0_25(true)
end

local function var_0_28(arg_12_0)
	return ui.get(var_0_4) and plist.get(arg_12_0, "Override prefer body aim") == "Force" and not var_0_17(var_0_15, arg_12_0)
end

local function var_0_29()
	local var_13_0 = var_0_17(ui.get(var_0_5), "I'm an advanced user") and ui.get(var_0_4)
	local var_13_1 = var_13_0 and ui.get(var_0_6) and client.set_event_callback or client.unset_event_callback

	ui.set_visible(var_0_6, var_13_0)
	ui.set_visible(var_0_7, var_13_0)
	var_13_1("paint", var_0_27)
end

local function var_0_30()
	local var_14_0 = ui.get(var_0_4)
	local var_14_1 = var_14_0 and client.set_event_callback or client.unset_event_callback

	var_14_1("setup_command", var_0_26)
	var_14_1("round_prestart", function()
		var_0_19(var_0_1.get_players(true))
	end)

	if not var_0_13 then
		client.register_esp_flag("FORCE", 255, 255, 255, var_0_28)

		var_0_13 = true
	end

	ui.set_visible(var_0_5, var_14_0)
	var_0_29()
end

ui.set_callback(var_0_4, var_0_30)
ui.set_callback(var_0_5, var_0_29)
ui.set_callback(var_0_6, var_0_29)
var_0_30()
ui.set_callback(var_0_10, function(arg_16_0)
	local var_16_0 = ui.get(arg_16_0)
	local var_16_1 = ui.get(var_0_8)
	local var_16_2, var_16_3 = var_0_17(var_0_15, ui.get(var_0_8))

	if var_16_0 and not var_16_2 then
		table.insert(var_0_15, var_16_1)
		plist.set(var_16_1, "Override prefer body aim", "-")
		client.update_player_list()
	elseif not var_16_0 and var_16_2 then
		table.remove(var_0_15, var_16_3)
	end
end)
ui.set_callback(var_0_8, function(arg_17_0)
	ui.set(var_0_10, var_0_17(var_0_15, ui.get(arg_17_0)))
end)
ui.set_callback(var_0_9, function()
	var_0_15 = {}

	ui.set(var_0_10, false)
end)
