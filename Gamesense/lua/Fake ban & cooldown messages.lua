local var_0_0 = false
local var_0_1 = false
local var_0_2 = false
local var_0_3 = false
local var_0_4 = false
local var_0_5 = false
local var_0_6 = false
local var_0_7 = true
local var_0_8 = "nil"
local var_0_9 = ui.get
local var_0_10 = ui.set
local var_0_11 = ui.reference
local var_0_12 = ui.new_checkbox
local var_0_13 = ui.new_multiselect
local var_0_14 = ui.new_combobox
local var_0_15 = ui.new_button
local var_0_16 = ui.set_visible
local var_0_17 = ui.set_callback
local var_0_18 = client.color_log
local var_0_19 = client.set_event_callback
local var_0_20 = client.unset_event_callback
local var_0_21 = client.set_clan_tag
local var_0_22 = client.userid_to_entindex
local var_0_23 = client.delay_call
local var_0_24 = client.exec
local var_0_25 = entity.get_local_player
local var_0_26 = entity.get_prop
local var_0_27 = globals.mapname
local var_0_28 = string.rep
local var_0_29 = string.len
local var_0_30 = string.sub
local var_0_31 = var_0_11("MISC", "Miscellaneous", "Steal player name")
local var_0_32 = var_0_11("MISC", "Miscellaneous", "Clan tag spammer")
local var_0_33 = cvar.name:get_string()
local var_0_34 = var_0_21

local function var_0_35(arg_1_0)
	cvar.name:set_string(arg_1_0)
end

var_0_19("player_connect_full", function(arg_2_0)
	if var_0_22(arg_2_0.userid) == var_0_25() and var_0_27() ~= nil then
		var_0_7 = true
	end
end)

local var_0_36 = {
	Cooldown = "abandoned the match and received a ",
	Ban = "has been permanently banned from official CS:GO servers."
}
local var_0_37 = {
	["30-Mins"] = "30 minute competitive matchmaking cooldown.",
	["24-Hrs"] = "24 hour competitive matchmaking cooldown.",
	["2-Hrs"] = "2 hour competitive matchmaking cooldown.",
	["7-Days"] = "7 day competitive matchmaking cooldown."
}
local var_0_38 = var_0_12("LUA", "A", "Enable Troll-Name")
local var_0_39 = var_0_12("LUA", "A", "CleanChat on initial change")
local var_0_40 = var_0_13("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Disconnect-Dmg", "Auto-Revert Name", "Hide Name Change", "Use Console Value", "Custom Gap Value")
local var_0_41 = var_0_14("LUA", "A", "Name Type", "Ban", "Cooldown")
local var_0_42 = var_0_14("LUA", "A", "Ban Length", "30-Mins", "2-Hrs", "24-Hrs", "7-Days")
local var_0_43 = ui.new_label("LUA", "A", "Player Name")
local var_0_44 = ui.new_textbox("LUA", "A", "Textbox")
local var_0_45 = ui.new_slider("LUA", "A", "Gap Value", 1, 20, 1, true)

local function var_0_46()
	var_0_0 = false
	var_0_1 = false
	var_0_2 = false
	var_0_3 = false
	var_0_4 = false
	var_0_5 = false
end

local function var_0_47(arg_4_0)
	var_0_8 = arg_4_0

	var_0_18(3, 198, 252, "Current Input: " .. var_0_8)

	return true
end

local function var_0_48()
	local var_5_0 = var_0_9(var_0_40)

	for iter_5_0 = 1, #var_5_0 do
		if var_5_0[iter_5_0] ~= "Auto-Disconnect" then
			var_0_0 = false
		end

		if var_5_0[iter_5_0] ~= "Auto-Disconnect-Dmg" then
			var_0_1 = false
		end

		if var_5_0[iter_5_0] ~= "Auto-Revert Name" then
			var_0_2 = false
		end

		if var_5_0[iter_5_0] ~= "Hide Name Change" then
			var_0_3 = false
		end

		if var_5_0[iter_5_0] ~= "Use Console Value" then
			var_0_4 = false
		end

		if var_5_0[iter_5_0] ~= "Custom Gap Value" then
			var_0_5 = false
		end
	end

	for iter_5_1 = 1, #var_5_0 do
		if var_5_0[iter_5_1] == "Auto-Disconnect" then
			var_0_0 = true
		end

		if var_5_0[iter_5_1] == "Auto-Disconnect-Dmg" then
			var_0_1 = true
		end

		if var_5_0[iter_5_1] == "Auto-Revert Name" then
			var_0_2 = true
		end

		if var_5_0[iter_5_1] == "Hide Name Change" then
			var_0_3 = true
		end

		if var_5_0[iter_5_1] == "Use Console Value" then
			var_0_4 = true
		end

		if var_5_0[iter_5_1] == "Custom Gap Value" then
			var_0_5 = true
		end
	end

	if next(var_0_9(var_0_40)) == nil then
		var_0_46()
	end
end

local function var_0_49()
	if var_0_9(var_0_38) then
		var_0_48()

		if var_0_9(var_0_41) == "Cooldown" then
			var_0_16(var_0_42, true)
		else
			var_0_16(var_0_42, false)
		end

		if var_0_5 then
			var_0_16(var_0_45, true)
		else
			var_0_16(var_0_45, false)
		end

		if var_0_3 then
			var_0_10(var_0_32, false)
			var_0_16(var_0_39, true)
		else
			var_0_16(var_0_39, false)
		end

		if var_0_4 then
			var_0_24("clear")
			var_0_18(181, 252, 3, "Simply enter the text you want as input.")
			var_0_18(252, 3, 3, "WARNING: The game will not process any console inputs until you turn off \"Use Console Value\" or the main checkbox for the script.")
			var_0_18(3, 252, 169, "Last Input: " .. var_0_8)
			var_0_16(var_0_44, false)
			var_0_16(var_0_43, false)
			var_0_19("console_input", var_0_47)
		else
			var_0_16(var_0_44, true)
			var_0_16(var_0_43, true)
			var_0_24("clear")
			var_0_20("console_input", var_0_47)
		end
	else
		var_0_16(var_0_44, false)
		var_0_16(var_0_42, false)
		var_0_16(var_0_43, false)
		var_0_16(var_0_45, false)
		var_0_16(var_0_39, false)
		var_0_20("console_input", var_0_47)
	end
end

local function var_0_50()
	local var_7_0 = var_0_36[var_0_9(var_0_41)]
	local var_7_1 = var_0_9(var_0_45)
	local var_7_2 = ""
	local var_7_3 = ""
	local var_7_4 = ""
	local var_7_5

	var_0_7 = false

	if var_0_4 then
		var_7_4 = var_0_8
	else
		var_7_4 = var_0_9(var_0_44)
	end

	if var_0_9(var_0_41) == "Cooldown" then
		var_7_0 = var_7_0 .. var_0_37[var_0_9(var_0_42)]
	end

	local var_7_6 = var_0_29(var_7_4 .. var_7_0)
	local var_7_7 = "ᅠ"

	if var_0_5 then
		var_7_2 = var_0_28(var_7_7, GapValue)
	else
		var_7_2 = " "
	end

	local var_7_8 = var_7_0 .. var_7_2

	if var_0_0 then
		var_0_34()
		var_0_35(" \a" .. var_7_4 .. " " .. var_7_8 .. "\x01 ? ")
		var_0_23(0.8, var_0_24, "disconnect")
		var_0_23(5.2, function()
			var_0_10(var_0_38, false)
			print("Automatically disconnected from the server after setting Banned-Name.")
		end)
	elseif var_0_3 then
		if var_0_29(var_7_4) > 12 then
			var_0_18(252, 3, 3, "Clamped the clantag, don't use \"Hide Name Change\" if the input is more than 12 chars.")
		end

		var_0_34(" \a" .. var_0_30(var_7_4, 0, 12) .. "\n")
		var_0_35("\a" .. var_7_8 .. "\x01You")
	else
		var_0_34()
		var_0_35(" \a" .. var_7_4 .. " " .. var_7_8 .. "\x01You")
	end

	print(var_7_6)
end

local var_0_51 = var_0_15("LUA", "A", "Set Name", function()
	local var_9_0 = var_0_29(var_0_33)

	var_0_10(var_0_31, true)
	var_0_35("\n\xAD\xAD\xAD\xAD")
	var_0_23(0, function()
		if var_0_3 and var_0_7 and var_0_9(var_0_39) then
			var_0_23(0.01, var_0_24, "Say " .. var_0_28(" ﷽﷽", 40))
			print("Spammed the chat in an attempt to hide the initial name change.")
		end
	end)
	var_0_23(0.2, var_0_50)
end)

local function var_0_52()
	local var_11_0 = var_0_9(var_0_38)

	var_0_16(var_0_40, var_11_0)
	var_0_16(var_0_41, var_11_0)
	var_0_16(var_0_42, var_11_0)
	var_0_16(var_0_43, var_11_0)
	var_0_16(var_0_44, var_11_0)
	var_0_16(var_0_51, var_11_0)

	if var_11_0 then
		var_0_33 = cvar.name:get_string()
		var_0_6 = true
	elseif var_0_6 == true then
		var_0_35(var_0_33)
		var_0_34()
		var_0_46()

		var_0_6 = false
	end

	var_0_49()
end

local function var_0_53()
	var_0_49()
end

var_0_52()
var_0_17(var_0_40, var_0_49)
var_0_17(var_0_41, var_0_53)

local function var_0_54(arg_13_0)
	local var_13_0 = var_0_25()
	local var_13_1 = var_0_26(var_0_22(arg_13_0.userid), "m_iTeamNum") == var_0_26(var_13_0, "m_iTeamNum")

	if var_0_22(arg_13_0.attacker) == var_13_0 and var_13_1 then
		if var_0_2 then
			var_0_10(var_0_38, false)
			print("Reverted name and disabled the main checkbox for the script.")
		end

		if var_0_1 then
			var_0_10(var_0_38, false)
			var_0_24("Disconnect")
			print("Disconnected from the server after reverting name.")
		end
	end
end

local function var_0_55(arg_14_0)
	var_0_52()
	;(var_0_9(arg_14_0) and var_0_19 or var_0_20)("player_hurt", var_0_54)
end

var_0_19("shutdown", function()
	var_0_10(var_0_38, false)
end)
var_0_55(var_0_38)
var_0_17(var_0_38, var_0_55)
