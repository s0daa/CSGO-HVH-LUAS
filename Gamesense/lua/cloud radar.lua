local var_0_0 = require("gamesense/http")
local var_0_1 = require("gamesense/websockets")
local var_0_2 = require("gamesense/chat")
local var_0_3 = require("gamesense/clipboard")
local var_0_4 = client.userid_to_entindex
local var_0_5 = client.color_log
local var_0_6 = client.trace_line
local var_0_7 = entity.get_all
local var_0_8 = entity.get_local_player
local var_0_9 = entity.get_player_resource
local var_0_10 = entity.get_player_name
local var_0_11 = entity.get_steam64
local var_0_12 = entity.get_classname
local var_0_13 = entity.is_dormant
local var_0_14 = entity.get_prop
local var_0_15 = entity.get_origin
local var_0_16 = globals.tickcount
local var_0_17 = globals.mapname
local var_0_18 = globals.maxplayers
local var_0_19 = json.stringify
local var_0_20 = renderer.indicator
local var_0_21 = math.rad
local var_0_22 = math.sin
local var_0_23 = math.cos
local var_0_24 = math.tan
local var_0_25 = math.sqrt
local var_0_26 = ui.get
local var_0_27 = ui.set
local var_0_28 = ui.set_visible
local var_0_29 = _NAME:gsub("*", ""):upper()

local function var_0_30(...)
	var_0_5(217, 217, 217, "[ \x00")
	var_0_5(85, 134, 190, var_0_29 .. "\x00")
	var_0_5(217, 217, 217, " ]\x00")

	local var_1_0 = 1

	while select(var_1_0, ...) ~= nil do
		var_0_5(217, 217, 217, " ", select(var_1_0, ...), "\x00")

		var_1_0 = var_1_0 + 1
	end

	var_0_5(217, 217, 217, " ")
end

local var_0_31 = {}

var_0_31.white = "{white}"
var_0_31.red = "{red}"
var_0_31.green = "{lime}"

local function var_0_32(arg_2_0, arg_2_1)
	var_0_2.print("{white} [ {blue}" .. var_0_29 .. "{white} ] " .. arg_2_0 .. arg_2_1)
	var_0_30(arg_2_1)
end

local var_0_33 = "cr.velema.dev/"
local var_0_34 = "https://" .. var_0_33
local var_0_35 = ""
local var_0_36 = ""
local var_0_37 = false
local var_0_38 = "wss://" .. var_0_33 .. "in"
local var_0_39
local var_0_40 = {}
local var_0_41 = 1
local var_0_42 = 0

local function var_0_43()
	local var_3_0 = 5

	if var_3_0 >= var_0_41 then
		if var_0_37 == true and var_0_36 ~= "" and var_0_39 == nil then
			var_0_32(var_0_31.green, "Connection lost! Trying to reconnect! Attempt: " .. var_0_41 .. "/" .. var_3_0)
			var_0_1.connect(var_0_38, var_0_40)

			var_0_41 = var_0_41 + 1
		end
	else
		var_0_32(var_0_31.red, "Could not reconnect, please reload or open a support ticket in the discord!")
	end
end

var_0_40 = {
	open = function(arg_4_0)
		var_0_32(var_0_31.green, "Connection opened!")

		var_0_39 = arg_4_0
		var_0_41 = 1
	end,
	message = function(arg_5_0, arg_5_1)
		var_0_32(var_0_31.blue, arg_5_1)
	end,
	close = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		var_0_32(var_0_31.red, "Connection closed!")

		var_0_39 = nil

		if var_0_37 then
			var_0_43()
		end
	end,
	error = function(arg_7_0, arg_7_1)
		var_0_39 = nil

		if var_0_37 then
			var_0_43()
		else
			var_0_32(var_0_31.red, "[WS] Error: ", arg_7_1, "!")
		end
	end
}

local function var_0_44()
	if var_0_39 ~= nil then
		var_0_0.get(var_0_34 .. "in/ClearScoreboard?radarId=" .. var_0_35, function(arg_9_0, arg_9_1)
			if arg_9_0 then
				var_0_42 = globals.realtime() + 30
			end
		end)
	end
end

local var_0_45
local var_0_46
local var_0_47 = ui.new_button("LUA", "A", "Create cloud radar", function()
	if var_0_36 == "" then
		local var_10_0 = var_0_26(var_0_45)
		local var_10_1 = ""

		if var_10_0 then
			local var_10_2 = var_0_26(var_0_46):gsub("%p", ""):gsub("%c", "")

			var_10_1 = "&customUrl=" .. var_10_2:gsub(" ", "_")
		end

		var_0_0.get(var_0_34 .. "in/create?steamId=" .. panorama.open().MyPersonaAPI.GetXuid() .. var_10_1, function(arg_11_0, arg_11_1)
			if arg_11_0 and arg_11_1 and arg_11_1.body then
				var_0_35 = arg_11_1.body

				if string.match(var_0_35, "IN_USE") then
					var_0_32(var_0_31.red, "Custom radar link already in use!")

					return
				end

				var_0_36 = var_0_34 .. "?id=" .. var_0_35

				var_0_32(var_0_31.green, "Created cloud radar. Link: " .. var_0_36)

				if var_0_39 == nil then
					var_0_1.connect(var_0_38, var_0_40)
				end

				client.delay_call(3, var_0_44)

				var_0_37 = true
			elseif arg_11_1.timed_out then
				var_0_32(var_0_31.red, "Timed out while trying to create a cloud radar.")
			else
				var_0_32(var_0_31.red, "An unknown error accoured while creating the cloud radar.")
			end
		end)
	else
		var_0_32(var_0_31.white, "You already created a cloud radar. Link: " .. var_0_36)

		if var_0_39 == nil then
			var_0_1.connect(var_0_38, var_0_40)
		end
	end
end)

var_0_45 = ui.new_checkbox("LUA", "A", "[CR] Custom Link")
var_0_46 = ui.new_textbox("LUA", "A", "Custom Link")

local var_0_48 = ui.new_button("LUA", "A", "Destroy cloud radar", function()
	var_0_37 = false

	var_0_0.get(var_0_34 .. "in/delete?steamId=" .. panorama.open().MyPersonaAPI.GetXuid(), function(arg_13_0, arg_13_1)
		var_0_36 = ""
		var_0_35 = ""
		var_0_37 = false

		if arg_13_0 then
			var_0_32(var_0_31.green, "Destroyed cloud radar.")

			if var_0_39 ~= nil then
				var_0_39:close()
			else
				var_0_32(var_0_31.red, "No open connection.")
			end
		elseif arg_13_1.timed_out then
			var_0_32(var_0_31.red, "Timed out while trying to destroy a cloud radar.")

			if var_0_39 ~= nil then
				var_0_39:close()
			end
		else
			var_0_32(var_0_31.red, "An unknown error accoured while destroying the cloud radar.")

			if var_0_39 ~= nil then
				var_0_39:close()
			end
		end
	end)
end)
local var_0_49 = ui.new_button("LUA", "A", "Copy link", function()
	var_0_3.set(var_0_36)
end)
local var_0_50 = {
	"\a7bf542FF Very Fast",
	[6] = "\a7bf542FF Fast",
	[12] = "\ad6a335FF Medium",
	[64] = "\a6e1916FF Slowest",
	[48] = "\a8a3936FF Very Slow",
	[32] = "\af54242FF Slow"
}
local var_0_51 = ui.new_slider("LUA", "A", "[CR] Update rate", 1, 64, 4, true, "", 1, var_0_50)
local var_0_52 = ui.new_checkbox("LUA", "A", "[CR]\ad6a335FF Enable dormant for better results")
local var_0_53 = ui.reference("VISUALS", "Player ESP", "Dormant")

local function var_0_54(arg_15_0)
	local var_15_0
	local var_15_1

	if arg_15_0 == nil or arg_15_0 == 0 then
		return "0"
	end

	if arg_15_0 % 2 == 0 then
		var_15_0 = 0
		var_15_1 = arg_15_0 / 2
	else
		var_15_0 = 1
		var_15_1 = (arg_15_0 - 1) / 2
	end

	return "7656119" .. var_15_1 * 2 + (7960265728 + var_15_0)
end

local function var_0_55(arg_16_0)
	local var_16_0 = var_0_14(arg_16_0, "m_flC4Blow") - globals.curtime()

	if var_16_0 == nil then
		return 0
	end

	if var_16_0 > 0 then
		return var_16_0
	end

	return 0
end

local var_0_56 = false
local var_0_57 = 0
local var_0_58 = {}

client.set_event_callback("paint", function()
	if var_0_37 and var_0_39 ~= nil then
		if var_0_57 + var_0_26(var_0_51) < var_0_16() and not var_0_56 then
			local var_17_0 = var_0_9()

			var_0_57 = var_0_16()

			local var_17_1 = {}

			var_17_1.Premium = "4dc6822c-22d9-4f54-853b-bf3cfe7f265f"
			var_17_1.Map = var_0_17()
			var_17_1.MatchId = var_0_35

			local var_17_2 = tostring(cvar.game_type:get_int())

			var_17_1.GameType = var_17_2

			local var_17_3 = var_0_7("CPlantedC4")[1]
			local var_17_4 = var_0_7("CC4")[1]
			local var_17_5 = ""
			local var_17_6 = entity.get_game_rules()
			local var_17_7 = tostring(var_0_14(var_17_6, "m_fRoundStartTime") + var_0_14(var_17_6, "m_iRoundTime") - globals.curtime())

			if var_17_3 ~= nil then
				var_17_1.IsPlanted = true

				local var_17_8, var_17_9, var_17_10 = var_0_15(var_17_3)

				var_17_1.PlantedX = tostring(var_17_8)
				var_17_1.PlantedY = tostring(var_17_9)
				var_17_7 = var_0_55(var_17_3)

				local var_17_11 = var_0_14(var_17_3, "m_hBombDefuser")
				local var_17_12 = var_0_14(var_17_3, "m_flDefuseLength")
				local var_17_13 = var_0_14(var_17_3, "m_hBombDefuser") ~= 4294967295 and math.floor((var_0_14(var_17_3, "m_flDefuseCountDown") - globals.curtime()) * 100) / 100 or -1

				if var_17_11 ~= nil then
					var_17_1.DefuseTimer = tostring(var_17_13)
				else
					var_17_1.DefuseTimer = "0"
				end
			elseif var_17_4 ~= nil then
				var_17_1.IsPlanted = false

				local var_17_14, var_17_15, var_17_16 = var_0_15(var_17_4)

				var_17_1.PlantedX = tostring(var_17_14)
				var_17_1.PlantedY = tostring(var_17_15)
			end

			var_17_1.BombTimer = tostring(var_17_7)

			local var_17_17 = var_0_7("CCSTeam")[4]
			local var_17_18 = var_0_7("CCSTeam")[3]

			if var_17_17 ~= nil then
				var_17_1.CT_Rounds = tostring(var_0_14(var_17_17, "m_scoreTotal"))
			else
				var_17_1.CT_Rounds = "-"
			end

			if var_17_18 ~= nil then
				var_17_1.T_Rounds = tostring(var_0_14(var_17_18, "m_scoreTotal"))
			else
				var_17_1.CT_Rounds = "-"
			end

			var_17_1.Players = {}

			for iter_17_0 = 1, var_0_18() do
				if var_0_12(iter_17_0) == "CCSPlayer" then
					player = {}
					player.Name = var_0_10(iter_17_0)
					player.Steam_ID = var_0_54(var_0_11(iter_17_0))

					local var_17_19, var_17_20, var_17_21 = var_0_15(iter_17_0)

					if var_17_19 ~= nil then
						local var_17_22 = var_17_21 + 64 - var_0_14(iter_17_0, "m_flDuckAmount")
						local var_17_23, var_17_24 = var_0_14(iter_17_0, "m_angEyeAngles")

						player.X = tostring(var_17_19)
						player.Y = tostring(var_17_20)

						local var_17_25 = 0
						local var_17_26 = 1

						while var_17_26 == 1 and var_17_25 < 5000 do
							var_17_25 = var_17_25 + 100

							local var_17_27 = var_17_19 - var_0_23(var_0_21(var_17_24 + 180)) * var_17_25
							local var_17_28 = var_17_20 - var_0_22(var_0_21(var_17_24 + 180)) * var_17_25
							local var_17_29 = var_17_22 - var_0_24(var_0_21(var_17_23)) * var_17_25

							var_17_26 = var_0_6(iter_17_0, var_17_19, var_17_20, var_17_22, var_17_27, var_17_28, var_17_29)
						end

						player.VX = tostring(var_17_19 - var_0_23(var_0_21(var_17_24 + 180)) * var_17_25 * var_17_26)
						player.VY = tostring(var_17_20 - var_0_22(var_0_21(var_17_24 + 180)) * var_17_25 * var_17_26)
					else
						player.X = ""
						player.Y = ""
						player.VX = ""
						player.VY = ""
					end

					player.IsInactive = var_0_13(iter_17_0)

					local var_17_30 = "0"

					if var_17_2 == "0" then
						var_17_30 = var_0_14(var_17_0, "m_iTeam", iter_17_0)
					elseif var_17_2 == "6" then
						var_17_30 = entity.get_prop(iter_17_0, "m_nSurvivalTeam")
					end

					player.Team = var_17_30
					player.Health = var_0_14(var_17_0, "m_iHealth", iter_17_0)

					local var_17_31 = var_0_14(iter_17_0, "m_iAccount")

					if var_17_31 ~= nil then
						player.Money = tostring(var_17_31)
					else
						player.Money = "-"
					end

					local var_17_32 = var_0_14(var_17_0, "m_iCompetitiveRanking", iter_17_0)

					if var_17_32 ~= nil then
						player.Rank = tostring(var_17_32)
					else
						player.Rank = "0"
					end

					local var_17_33 = var_0_14(var_17_0, "m_iCompetitiveWins", iter_17_0)

					if var_17_33 ~= nil then
						player.Wins = tostring(var_17_33)
					else
						player.Wins = "-"
					end

					local var_17_34 = entity.get_player_weapon(iter_17_0)
					local var_17_35 = entity.get_classname(var_17_34)

					if var_17_35 ~= nil then
						player.ActiveWeapon = var_17_35
					else
						player.ActiveWeapon = ""
					end

					local var_17_36 = var_0_14(var_17_0, "m_iPlayerC4")

					if var_17_36 ~= nil then
						player.HasC4 = var_17_36 == iter_17_0
					else
						player.HasC4 = false
					end

					local var_17_37 = entity.is_alive(iter_17_0)

					player.IsAlive = var_17_37

					local var_17_38 = var_0_14(var_17_0, "m_iArmor", iter_17_0)

					if var_17_38 ~= nil then
						player.HasArmor = var_17_38 > 0
					else
						player.HasArmor = false
					end

					local var_17_39 = var_0_14(var_17_0, "m_bHasHelmet", iter_17_0)

					if var_17_39 ~= nil then
						player.HasHelmet = var_17_39 == 1
					else
						player.HasHelmet = false
					end

					local var_17_40 = var_0_14(var_17_0, "m_bHasDefuser", iter_17_0)

					if var_17_40 ~= nil then
						player.HasDefuse = var_17_40 == 1
					else
						player.HasDefuse = false
					end

					playerWeapons = {}

					if var_17_34 ~= nil and var_17_37 then
						for iter_17_1 = 0, 63 do
							local var_17_41 = var_0_14(iter_17_0, "m_hMyWeapons", iter_17_1)

							if var_17_41 ~= nil then
								table.insert(playerWeapons, entity.get_classname(var_17_41, "m_iItemDefinitionIndex"))
							end
						end
					end

					if #playerWeapons == 0 then
						table.insert(playerWeapons, "default_empty")
					end

					player.Weapons = playerWeapons

					if player.X ~= "" and player.Y ~= "" then
						table.insert(var_17_1.Players, player)
					end
				end
			end

			var_17_1.Smokes = {}

			local var_17_42 = var_0_7("CSmokeGrenadeProjectile")

			for iter_17_2 = 1, #var_17_42 do
				local var_17_43 = var_17_42[iter_17_2]
				local var_17_44, var_17_45 = var_0_15(var_17_43)
				local var_17_46 = var_0_14(var_17_43, "m_nSmokeEffectTickBegin")

				if var_17_46 ~= 0 and (globals.tickcount() - var_17_46) * globals.tickinterval() < 17.5 then
					local var_17_47 = {
						X = tostring(var_17_44),
						Y = tostring(var_17_45)
					}

					table.insert(var_17_1.Smokes, var_17_47)
				end
			end

			if #var_17_1.Smokes == 0 then
				var_17_1.Smokes = {
					{}
				}
			end

			var_17_1.Incendiaries = {}

			local var_17_48 = var_0_7("CInferno")

			for iter_17_3 = 1, #var_17_48 do
				local var_17_49 = var_17_48[iter_17_3]
				local var_17_50, var_17_51 = var_0_15(var_17_49)

				if var_0_14(var_17_49, "m_bFireIsBurning") ~= false then
					molo = {}
					molo.X = tostring(var_17_50)
					molo.Y = tostring(var_17_51)

					table.insert(var_17_1.Incendiaries, molo)
				end

				iter_17_3 = iter_17_3 + 1
			end

			if #var_17_1.Incendiaries == 0 then
				var_17_1.Incendiaries = {
					{}
				}
			end

			if var_17_1 ~= var_0_58 then
				var_0_58 = var_17_1
				var_0_56 = true

				local var_17_52 = var_0_19(var_17_1)

				var_0_39:send(var_17_52)

				var_0_56 = false
			end
		elseif var_0_57 > var_0_16() then
			var_0_57 = var_0_16()
		end
	end
end)

local var_0_59 = ""

client.set_event_callback("paint_ui", function()
	if var_0_37 then
		var_0_28(var_0_48, true)
		var_0_28(var_0_51, true)
		var_0_28(var_0_49, true)
		var_0_28(var_0_45, false)
		var_0_28(var_0_46, false)
		var_0_28(var_0_47, false)

		if not var_0_26(var_0_53) then
			var_0_28(var_0_52, true)

			if var_0_26(var_0_52) then
				var_0_27(var_0_53, true)
				var_0_27(var_0_52, false)
				var_0_28(var_0_52, false)
			end
		end
	end

	if var_0_39 == nil and var_0_37 == false then
		var_0_28(var_0_48, false)
		var_0_28(var_0_51, false)
		var_0_28(var_0_49, false)
		var_0_28(var_0_52, false)
		var_0_28(var_0_45, true)

		if var_0_26(var_0_45) then
			var_0_28(var_0_46, true)
		else
			var_0_28(var_0_46, false)
		end

		var_0_28(var_0_47, true)
	elseif var_0_42 < globals.realtime() and panorama.open().GameStateAPI.IsConnectedOrConnectingToServer() == true and panorama.open().GameStateAPI.IsDemoOrHltv() == false then
		if var_0_59 == "" then
			var_0_59 = panorama.open().GameStateAPI.GetLocalPlayerXuid()
		elseif panorama.open().GameStateAPI.IsPlayerConnected(var_0_59) == false then
			var_0_44()
		end
	end
end)
client.set_event_callback("shutdown", function()
	if var_0_39 ~= nil then
		var_0_39:close()
	end
end)
client.set_event_callback("begin_new_match", function()
	if var_0_39 ~= nil then
		var_0_44()
	end
end)
var_0_32(var_0_31.green, "Loaded successfully")
