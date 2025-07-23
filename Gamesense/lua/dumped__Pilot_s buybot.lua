-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = require("gamesense/panorama_events")
local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {}
local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = table.insert
local var_0_8 = false
local var_0_9
local var_0_10
local var_0_11
local var_0_12 = panorama.open()
local var_0_13 = var_0_12.LoadoutAPI
local var_0_14 = var_0_12.InventoryAPI
local var_0_15 = var_0_12.MatchStatsAPI
local var_0_16 = false
local var_0_17 = {}
local var_0_18 = database.read("pilotbuybot") or {}
local var_0_19 = ui.new_checkbox("LUA", "B", "Pilot's buybot")
local var_0_20

local function var_0_21(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_22(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		if iter_2_1[1] == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_23(arg_3_0, arg_3_1)
	local var_3_0 = {}

	for iter_3_0 in (arg_3_0 .. arg_3_1):gmatch("(.-)" .. arg_3_1) do
		table.insert(var_3_0, iter_3_0)
	end

	return var_3_0
end

;(function()
	if var_0_20 then
		ui.set_visible(var_0_20, false)

		var_0_16 = true
	end

	local var_4_0 = {}
	local var_4_1 = ""

	for iter_4_0, iter_4_1 in ipairs(var_0_18) do
		table.insert(var_4_0, iter_4_1.name)
		table.insert(var_0_17, iter_4_1.values)

		var_4_1 = var_4_1 .. iter_4_1.name .. ","
	end

	local var_4_2 = var_4_1 .. "Custom [+]"

	table.insert(var_4_0, "Custom [+]")

	var_0_11 = var_0_23(var_4_2, ",")

	if not var_0_20 and #var_0_18 > 0 then
		var_0_20 = ui.new_combobox("LUA", "B", "Preset", var_0_11)
	end
end)()
var_0_7(var_0_3, "-")
var_0_7(var_0_4, "-")
var_0_7(var_0_6, "Flashbang")

local function var_0_24(arg_5_0, arg_5_1)
	local var_5_0 = var_0_14.GetFauxItemIDFromDefAndPaintIndex(arg_5_0)
	local var_5_1 = var_0_14.GetSlotSubPosition(var_5_0)
	local var_5_2 = var_0_13.GetItemID(arg_5_1, var_5_1)

	return var_0_14.GetItemDefinitionIndex(var_5_2)
end

local var_0_25
local var_0_26
local var_0_27
local var_0_28 = var_0_0.weapon_m4a1_silencer.idx
local var_0_29 = var_0_0.weapon_cz75a.idx

if var_0_24(var_0_28, "ct") == var_0_28 then
	var_0_25 = true
end

if var_0_24(var_0_29, "ct") == var_0_29 then
	var_0_26 = true
end

if var_0_24(var_0_29, "t") == var_0_29 then
	var_0_27 = true
end

local var_0_30 = {
	["SG 553"] = "\aB5D4EEFFAUG\aFFFFFFCC  \aEAD18AFFSG 553",
	MP9 = "\aB5D4EEFFMP9\aFFFFFFCC  \aEAD18AFFMAC-10",
	["MP5-SD"] = "MP5-SD / MP7",
	FAMAS = "\aB5D4EEFFFAMAS\aFFFFFFCC  \aEAD18AFFGalil",
	G3SG1 = "\aB5D4EEFFSCAR-20\aFFFFFFCC  \aEAD18AFFG3SG1",
	["MAG-7"] = "\aB5D4EEFFMAG-7\aFFFFFFCC  \aEAD18AFFSawed-Off",
	["SCAR-20"] = "\aB5D4EEFFSCAR-20\aFFFFFFCC  \aEAD18AFFG3SG1",
	["Defuse Kit"] = "Defuse / Rescue Kit",
	["Rescue Kit"] = "SKIP",
	["Kevlar + Helmet"] = "Helmet",
	["R8 Revolver"] = "Desert Eagle / R8 Revolver",
	Molotov = "\aB5D4EEFFIncendiary Grenade\aFFFFFFCC  \aEAD18AFFMolotov",
	["Desert Eagle"] = "Desert Eagle / R8 Revolver",
	MP7 = "MP5-SD / MP7",
	["Incendiary Grenade"] = "\aB5D4EEFFIncendiary Grenade\aFFFFFFCC  \aEAD18AFFMolotov",
	["USP-S"] = "SKIP",
	P2000 = "SKIP",
	["MAC-10"] = "\aB5D4EEFFMP9\aFFFFFFCC  \aEAD18AFFMAC-10",
	["Glock-18"] = "SKIP",
	["Sawed-Off"] = "\aB5D4EEFFMAG-7\aFFFFFFCC  \aEAD18AFFSawed-Off",
	AUG = "\aB5D4EEFFAUG\aFFFFFFCC  \aEAD18AFFSG 553",
	Galil = "\aB5D4EEFFFAMAS\aFFFFFFCC  \aEAD18AFFGalil",
	["AK-47"] = var_0_25 and "\aB5D4EEFFM4A1-S\aFFFFFFCC  \aEAD18AFFAK-47" or "\aB5D4EEFFM4A4\aFFFFFFCC  \aEAD18AFFAK-47",
	M4A4 = var_0_25 and "\aB5D4EEFFM4A1-S\aFFFFFFCC  \aEAD18AFFAK-47" or "\aB5D4EEFFM4A4\aFFFFFFCC  \aEAD18AFFAK-47",
	["M4A1-S"] = var_0_25 and "\aB5D4EEFFM4A1-S\aFFFFFFCC  \aEAD18AFFAK-47" or "\aB5D4EEFFM4A4\aFFFFFFCC  \aEAD18AFFAK-47",
	["Five-SeveN"] = var_0_26 and var_0_27 and "CZ75-Auto" or var_0_26 and "\aB5D4EEFFCZ75-Auto  \aEAD18AFFTec-9" or var_0_27 and "\aB5D4EEFFFive-SeveN  \aEAD18AFFCZ75-Auto" or "\aB5D4EEFFFive-SeveN  \aEAD18AFFTec-9",
	["Tec-9"] = var_0_26 and var_0_27 and "CZ75-Auto" or var_0_26 and "\aB5D4EEFFCZ75-Auto  \aEAD18AFFTec-9" or var_0_27 and "\aB5D4EEFFFive-SeveN  \aEAD18AFFCZ75-Auto" or "\aB5D4EEFFFive-SeveN  \aEAD18AFFTec-9",
	["CZ75-Auto"] = var_0_26 and var_0_27 and "CZ75-Auto" or var_0_26 and "\aB5D4EEFFCZ75-Auto  \aEAD18AFFTec-9" or var_0_27 and "\aB5D4EEFFFive-SeveN  \aEAD18AFFCZ75-Auto" or "\aB5D4EEFFFive-SeveN  \aEAD18AFFTec-9"
}
local var_0_31 = {
	weapon_scar20 = "g3sg1",
	weapon_shield = "1 25",
	weapon_galilar = "famas",
	item_assaultsuit = "vesthelm",
	weapon_sg556 = "aug",
	item_kevlar = "vest",
	weapon_m4a1 = "ak47",
	weapon_m4a1_silencer = "ak47",
	weapon_incgrenade = "molotov",
	weapon_cz75a = "fn57",
	weapon_mp5sd = "mp7",
	weapon_sawedoff = "mag7",
	weapon_revolver = "deagle",
	weapon_tec9 = "fn57",
	weapon_mp9 = "mac10",
	weapon_fiveseven = "fn57"
}

local function var_0_32()
	for iter_6_0 = 1, 64 do
		if var_0_0[iter_6_0] then
			local var_6_0 = var_0_30[var_0_0[iter_6_0].name] or var_0_0[iter_6_0].name

			if var_6_0 == "SKIP" then
				-- block empty
			else
				local var_6_1 = var_0_23(var_0_0[iter_6_0].console_name, "_")
				local var_6_2 = var_0_31[var_0_0[iter_6_0].console_name] or var_6_1[2]

				if not var_0_22(var_0_2, var_6_0) and var_0_0[iter_6_0].is_melee_weapon == false and var_0_0[iter_6_0].idx ~= 52 and var_0_0[iter_6_0].in_game_price > 0 then
					var_0_7(var_0_2, {
						var_6_0,
						var_0_0[iter_6_0].type,
						var_6_2,
						var_0_0[iter_6_0].in_game_price
					})

					if var_0_0[iter_6_0].type == "rifle" or var_0_0[iter_6_0].type == "sniperrifle" or var_0_0[iter_6_0].type == "heavy" or var_0_0[iter_6_0].type == "smg" or var_0_0[iter_6_0].type == "shotgun" or var_0_0[iter_6_0].type == "machinegun" then
						var_0_7(var_0_3, var_6_0)
					end

					if var_0_0[iter_6_0].type == "pistol" then
						var_0_7(var_0_4, var_6_0)
					end

					if var_0_0[iter_6_0].type == "equipment" or var_0_0[iter_6_0].type == "taser" then
						var_0_7(var_0_5, var_6_0)
					end

					if var_0_0[iter_6_0].type == "grenade" then
						var_0_7(var_0_6, var_6_0)
					end
				end
			end
		end
	end
end

local function var_0_33()
	local var_7_0 = {}

	for iter_7_0 = 0, 64 do
		local var_7_1 = entity.get_prop(entity.get_local_player(), "m_hMyWeapons", iter_7_0)

		if var_7_1 then
			table.insert(var_7_0, var_7_1)
		end
	end

	return var_7_0
end

var_0_32()

local var_0_34 = ui.new_combobox("LUA", "B", "Primary weapon", var_0_3)
local var_0_35 = ui.new_combobox("LUA", "B", "Secondary weapon", var_0_4)
local var_0_36 = ui.new_multiselect("LUA", "B", "Misc items", var_0_5)
local var_0_37 = ui.new_multiselect("LUA", "B", "Grenades", var_0_6)

local function var_0_38(arg_8_0, arg_8_1)
	local var_8_0 = 0
	local var_8_1 = ""
	local var_8_2 = entity.get_prop(entity.get_local_player(), "m_iAccount") or 800

	if not arg_8_1 or arg_8_0 == 2 then
		for iter_8_0, iter_8_1 in ipairs(var_0_2) do
			if (var_8_2 > 800 or arg_8_0 == 1) and iter_8_1[1] == ui.get(var_0_34) then
				var_8_1 = var_8_1 .. "buy " .. iter_8_1[3] .. ";"
				var_8_0 = var_8_0 + iter_8_1[4]
			end

			if arg_8_1 and arg_8_0 == 2 and arg_8_1:find(iter_8_1[3]) then
				var_8_0 = var_8_0 + iter_8_1[4]
			end
		end
	elseif var_8_2 > 800 or arg_8_0 == 1 then
		var_8_1 = arg_8_1
	end

	if arg_8_0 == 1 then
		return var_8_1
	end

	for iter_8_2 = 1, #var_0_33() do
		local var_8_3 = entity.get_prop(var_0_33()[iter_8_2], "m_iItemDefinitionIndex")

		if var_8_1:find(var_0_0[var_8_3].console_name:gsub("weapon_", "")) or var_8_1:find(var_0_0[var_8_3].console_name:gsub("item_", "")) or var_8_1:find(var_0_31[var_0_0[var_8_3].console_name] or "abcdefg") then
			local var_8_4 = var_0_31[var_0_0[var_8_3].console_name] or var_0_0[var_8_3].console_name:gsub("weapon_", ""):gsub("item_", "")

			var_8_1 = var_8_1:gsub("buy " .. var_8_4 .. ";", "")
			var_8_0 = var_8_0 - var_0_0[var_8_3].in_game_price
		end
	end

	if arg_8_0 == 2 then
		return var_8_0
	end

	return var_8_1
end

local function var_0_39(arg_9_0, arg_9_1)
	local var_9_0 = 0
	local var_9_1 = ""
	local var_9_2 = entity.get_prop(entity.get_local_player(), "m_iAccount") or 800

	if not arg_9_1 or arg_9_0 == 2 then
		for iter_9_0, iter_9_1 in ipairs(var_0_2) do
			if var_9_2 > 800 or arg_9_0 == 1 then
				if iter_9_1[1] == ui.get(var_0_35) then
					var_9_1 = var_9_1 .. "buy " .. iter_9_1[3] .. ";"
					var_9_0 = var_9_0 + iter_9_1[4]
				end

				local var_9_3 = ui.get(var_0_36)

				for iter_9_2 = 1, #var_9_3 do
					if var_9_3[iter_9_2] == iter_9_1[1] then
						var_9_1 = var_9_1 .. "buy " .. iter_9_1[3] .. ";"

						if entity.get_local_player() then
							if entity.get_prop(entity.get_local_player(), "m_ArmorValue") > 99 and iter_9_1[3] == "vesthelm" then
								var_9_0 = var_9_0 + 350
							else
								var_9_0 = var_9_0 + iter_9_1[4]
							end
						end
					end
				end

				local var_9_4 = ui.get(var_0_37)

				for iter_9_3 = 1, #var_9_4 do
					if var_9_4[iter_9_3] == iter_9_1[1] then
						var_9_1 = var_9_1 .. "buy " .. iter_9_1[3] .. ";"
						var_9_0 = var_9_0 + iter_9_1[4]
					end
				end
			end

			if arg_9_1 and arg_9_0 == 2 and arg_9_1:find(iter_9_1[3]) then
				var_9_0 = var_9_0 + iter_9_1[4]
			end
		end
	elseif var_9_2 > 800 or arg_9_0 == 1 then
		var_9_1 = arg_9_1
	end

	if arg_9_0 == 1 then
		return var_9_1
	end

	local var_9_5 = var_0_23(var_9_1, ";")
	local var_9_6 = 0

	for iter_9_4 = 1, #var_9_5 do
		if var_9_5[iter_9_4]:find("flashbang") then
			var_9_6 = var_9_6 + 1
		end
	end

	for iter_9_5 = 1, #var_0_33() do
		local var_9_7 = entity.get_prop(var_0_33()[iter_9_5], "m_iItemDefinitionIndex")

		if var_0_0 then
			if var_0_0[var_9_7].name == "Flashbang" and var_9_6 < 2 then
				var_9_1 = var_9_1:gsub("buy flashbang;", "")
				var_9_0 = var_9_0 - var_0_0[var_9_7].in_game_price
			end

			if var_9_1:find(var_0_0[var_9_7].console_name:gsub("weapon_", "")) or var_9_1:find(var_0_0[var_9_7].console_name:gsub("item_", "")) or var_9_1:find(var_0_31[var_0_0[var_9_7].console_name] or "abcdefg") then
				local var_9_8 = var_0_31[var_0_0[var_9_7].console_name] or var_0_0[var_9_7].console_name:gsub("weapon_", ""):gsub("item_", "")

				if var_9_8 ~= "flashbang" then
					var_9_1 = var_9_1:gsub("buy " .. var_9_8 .. ";", "")
					var_9_0 = var_9_0 - var_0_0[var_9_7].in_game_price
				end
			end
		end
	end

	if entity.get_prop(entity.get_local_player(), "m_bHasDefuser") > 0 or entity.get_prop(entity.get_local_player(), "m_iTeamNum") == 2 then
		var_9_1 = var_9_1:gsub("buy defuser;", "")

		if entity.get_prop(entity.get_local_player(), "m_iTeamNum") ~= 2 then
			var_9_0 = var_9_0 - 400
		end
	end

	if entity.get_prop(entity.get_local_player(), "m_ArmorValue") > 99 then
		var_9_1 = var_9_1:gsub("buy vest;", "")
		var_9_0 = var_9_0 - 650
	end

	if entity.get_prop(entity.get_local_player(), "m_bHasHelmet") then
		if entity.get_prop(entity.get_local_player(), "m_bHasHelmet") > 0 then
			var_9_1 = var_9_1:gsub("buy vesthelm;", "")

			if entity.get_prop(entity.get_local_player(), "m_ArmorValue") < 100 then
				var_9_0 = var_9_0 - 1000
			else
				var_9_0 = var_9_0 - 350
			end
		end

		if entity.get_prop(entity.get_local_player(), "m_bHasHelmet") < 1 and entity.get_prop(entity.get_local_player(), "m_ArmorValue") < 100 and var_9_1:find("vest") then
			var_9_1 = var_9_1:gsub("buy vest;", "")
			var_9_1 = var_9_1:gsub("buy vesthelm;", "")
			var_9_1 = var_9_1 .. "buy vesthelm;"
			var_9_0 = var_9_0 - 650
		end
	end

	if arg_9_0 == 2 then
		return var_9_0
	end

	return var_9_1
end

local var_0_40 = {
	["Desert Eagle"] = var_0_0.weapon_deagle.idx,
	["R8 Revolver"] = var_0_0.weapon_revolver.idx
}

local function var_0_41(arg_10_0, arg_10_1)
	local var_10_0 = var_0_14.GetFauxItemIDFromDefAndPaintIndex(arg_10_0)
	local var_10_1 = var_0_14.GetSlotSubPosition(var_10_0)

	var_0_13.EquipItemInSlot(arg_10_1, var_10_0, var_10_1)
end

local var_0_42 = {
	"ct",
	"t",
	"ct"
}
local var_0_43 = ui.new_textbox("LUA", "B", "Name")
local var_0_44 = ui.new_button("LUA", "B", "Save Preset", function()
	local var_11_0 = var_0_38(1)
	local var_11_1 = var_0_39(1)

	if ui.get(var_0_43) ~= "" and #var_11_0 > 0 or ui.get(var_0_43) ~= "" and #var_11_1 > 0 then
		table.insert(var_0_18, {
			name = ui.get(var_0_43),
			values = var_11_0 .. "!" .. var_11_1
		})
		ui.set(var_0_43, "")
		database.write("pilotbuybot", var_0_18)
		database.flush()
		client.delay_call(0, function()
			client.reload_active_scripts()
		end)
	elseif ui.get(var_0_43) == "" then
		error("Enter a preset name")
	else
		error("Values must not be empty")
	end
end)
local var_0_45 = ui.new_button("LUA", "B", "Delete", function()
	for iter_13_0, iter_13_1 in ipairs(var_0_11) do
		if ui.get(var_0_20) == iter_13_1 and iter_13_0 ~= #var_0_18 + 1 then
			table.remove(var_0_18, iter_13_0)
			database.write("pilotbuybot", var_0_18)
			database.flush()
		end
	end

	ui.set(var_0_34, "-")
	ui.set(var_0_35, "-")
	ui.set(var_0_36, "-")
	ui.set(var_0_37, "-")
	client.delay_call(0, function()
		client.reload_active_scripts()
	end)
end)

ui.set_visible(var_0_45, #var_0_18 > 0)

local var_0_46 = ui.new_checkbox("LUA", "B", "Buybot blacklist")
local var_0_47 = ui.new_multiselect("LUA", "B", "\n", "Valve", "non-$16k")
local var_0_48 = ui.new_checkbox("LUA", "B", "R8 pistol round")

ui.set_callback(var_0_46, function(arg_15_0)
	ui.set_visible(var_0_47, ui.get(arg_15_0))
end)
ui.set_visible(var_0_47, ui.get(var_0_46))

local function var_0_49(arg_16_0)
	if not ui.get(var_0_48) then
		return
	end

	local var_16_0 = var_0_0.weapon_revolver.idx
	local var_16_1 = var_0_0.weapon_deagle.idx
	local var_16_2 = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
	local var_16_3 = entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod")
	local var_16_4 = entity.get_prop(entity.get_local_player(), "m_iAccount")

	if not var_16_4 or arg_16_0 == 1 then
		for iter_16_0, iter_16_1 in ipairs(var_0_42) do
			if var_0_24(var_16_0, iter_16_1) ~= var_16_0 then
				var_0_41(var_16_0, iter_16_1)
			end
		end
	elseif (var_16_4 > 800 and var_16_3 < 1 or var_16_4 < 800 and var_16_3 < 1) and var_0_24(var_16_1, var_0_42[var_16_2]) ~= var_16_1 then
		var_0_41(var_16_1, var_0_42[var_16_2])
	end
end

ui.set_callback(var_0_48, function(arg_17_0)
	if ui.get(arg_17_0) then
		var_0_1.register_event("QueueConnectToServer", var_0_49)
		client.set_event_callback("announce_phase_end", function()
			var_0_49(1)
		end)
		client.set_event_callback("cs_win_panel_match", function()
			var_0_49(1)
		end)
		client.set_event_callback("round_start", var_0_49)
		client.set_event_callback("exit_buyzone", var_0_49)
	else
		var_0_1.unregister_event("QueueConnectToServer", var_0_49)
		client.unset_event_callback("round_start", var_0_49)
		client.unset_event_callback("exit_buyzone", var_0_49)
	end
end)

local function var_0_50()
	local var_20_0 = var_0_38(1)
	local var_20_1 = var_0_39(1)
	local var_20_2 = #var_20_0 > 0 or #var_20_1 > 0

	ui.set_visible(var_0_20, (ui.get(var_0_19)))
	ui.set_visible(var_0_45, false)
	ui.set_visible(var_0_43, ui.get(var_0_19) and var_20_2)
	ui.set_visible(var_0_44, ui.get(var_0_19) and var_20_2)
	ui.set_visible(var_0_34, (ui.get(var_0_19)))
	ui.set_visible(var_0_35, (ui.get(var_0_19)))
	ui.set_visible(var_0_36, (ui.get(var_0_19)))
	ui.set_visible(var_0_37, (ui.get(var_0_19)))
end

local function var_0_51()
	ui.set_visible(var_0_20, (ui.get(var_0_19)))
	ui.set_visible(var_0_43, false)
	ui.set_visible(var_0_45, (ui.get(var_0_19)))
	ui.set_visible(var_0_44, false)
	ui.set_visible(var_0_34, false)
	ui.set_visible(var_0_35, false)
	ui.set_visible(var_0_36, false)
	ui.set_visible(var_0_37, false)
end

local function var_0_52()
	local var_22_0 = var_0_38(1)
	local var_22_1 = var_0_39(1)
	local var_22_2 = #var_22_0 > 0 or #var_22_1 > 0

	ui.set_visible(var_0_34, (ui.get(var_0_19)))
	ui.set_visible(var_0_35, (ui.get(var_0_19)))
	ui.set_visible(var_0_36, (ui.get(var_0_19)))
	ui.set_visible(var_0_37, (ui.get(var_0_19)))
	ui.set_visible(var_0_43, ui.get(var_0_19) and var_22_2)
	ui.set_visible(var_0_44, ui.get(var_0_19) and var_22_2)
end

local function var_0_53()
	for iter_23_0 = #var_0_18, 1, -1 do
		for iter_23_1, iter_23_2 in ipairs(var_0_11) do
			if ui.get(var_0_20) == iter_23_2 and iter_23_1 == #var_0_18 + 1 then
				var_0_50()
			else
				var_0_51()
			end
		end
	end

	client.delay_call(0, function()
		if #var_0_18 < 1 then
			var_0_52()
		end
	end)
end

ui.set_callback(var_0_34, var_0_53)
ui.set_callback(var_0_35, var_0_53)
ui.set_callback(var_0_36, var_0_53)
ui.set_callback(var_0_37, var_0_53)
ui.set_callback(var_0_19, var_0_53)

local var_0_54 = 0

local function var_0_55()
	for iter_25_0, iter_25_1 in ipairs(var_0_11) do
		if ui.get(var_0_20) == iter_25_1 and iter_25_0 ~= #var_0_18 + 1 then
			local var_25_0 = var_0_23(var_0_17[iter_25_0], "!")

			var_0_9 = var_25_0[1]
			var_0_10 = var_25_0[2]
			var_0_54 = 1
		elseif ui.get(var_0_20) == iter_25_1 and iter_25_0 == #var_0_18 + 1 then
			var_0_54 = 0
		end
	end

	var_0_53()
end

if var_0_20 then
	ui.set_callback(var_0_20, var_0_55)
	client.delay_call(0, var_0_55)
end

var_0_53()

local function var_0_56(arg_26_0)
	if var_0_54 > 0 then
		client.exec(var_0_38(0, var_0_9))
	else
		client.exec(var_0_38())
	end

	local var_26_0 = string.len(var_0_38(0, var_0_9)) > 0
	local var_26_1 = string.len(var_0_38()) > 0
	local var_26_2 = var_26_0 or var_26_1

	return arg_26_0 > 0 and not var_0_8 and var_26_2 and client.delay_call(0.0001, var_0_56, arg_26_0 - 1)
end

client.set_event_callback("cs_pre_restart", function()
	if not ui.get(var_0_19) then
		return
	end

	local var_27_0 = entity.get_prop(entity.get_local_player(), "m_iAccount")
	local var_27_1 = var_0_15.IsServerWhitelistedValveOfficial()

	if var_27_0 < var_0_38(2) + var_0_39(2) then
		return
	end

	if ui.get(var_0_46) and var_0_21(ui.get(var_0_47), "Valve") and var_27_1 then
		return
	end

	if ui.get(var_0_46) and var_0_21(ui.get(var_0_47), "non-$16k") and cvar.mp_afterroundmoney:get_int() < 16000 then
		return
	end

	return client.delay_call(0.3 - (client.latency() + totime(8)), var_0_56, 16)
end)

local function var_0_57()
	if not ui.get(var_0_19) then
		return
	end

	local var_28_0 = entity.get_prop(entity.get_local_player(), "m_iAccount")
	local var_28_1 = var_0_15.IsServerWhitelistedValveOfficial()

	if var_28_0 < var_0_38(2) + var_0_39(2) then
		return
	end

	if ui.get(var_0_46) and var_0_21(ui.get(var_0_47), "Valve") and var_28_1 then
		return
	end

	if ui.get(var_0_46) and var_0_21(ui.get(var_0_47), "non-$16k") and cvar.mp_afterroundmoney:get_int() < 16000 then
		return
	end

	client.delay_call(0.01, function()
		if var_0_54 > 0 then
			client.exec(var_0_39(0, var_0_10))
		else
			client.exec(var_0_39())
		end
	end)
end

client.set_event_callback("round_prestart", function()
	client.delay_call(0.1, var_0_57)
end)
client.set_event_callback("player_spawn", function(arg_31_0)
	if client.userid_to_entindex(arg_31_0.userid) == entity.get_local_player() then
		var_0_57()
	end
end)
client.set_event_callback("item_purchase", function(arg_32_0)
	if client.userid_to_entindex(arg_32_0.userid) == entity.get_local_player() then
		var_0_8 = true

		client.delay_call(0.00011, function()
			var_0_8 = false
		end)
	end
end)
client.delay_call(0, function()
	ui.set(var_0_34, "-")
	ui.set(var_0_35, "-")
	ui.set(var_0_36, "-")
	ui.set(var_0_37, "-")
end)
