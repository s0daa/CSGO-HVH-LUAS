local var_0_0 = panorama.open()
local var_0_1 = var_0_0.MyPersonaAPI
local var_0_2 = var_0_0.PartyListAPI
local var_0_3 = var_0_0.FriendsListAPI
local var_0_4 = var_0_1.GetXuid()
local var_0_5 = require("gamesense/table_gen")
local var_0_6 = require("gamesense/http")
local var_0_7 = require("gamesense/panorama_events")
local var_0_8 = ui.reference("MISC", "Settings", "Hide from OBS")
local var_0_9 = {}
local var_0_10 = {
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday"
}
local var_0_11 = {
	["1,2"] = "2x",
	["3"] = "REDUCED",
	["1"] = "1x",
	[""] = "NO"
}
local var_0_12 = {
	"Name",
	"XP earned",
	"Bonus",
	"Level",
	"Rank",
	"Wins",
	"Prime",
	"Invite code",
	"Last seen",
	"Banned"
}
local var_0_13 = {
	[0] = "Unranked",
	"Silver 1",
	"Silver 2",
	"Silver 3",
	"Silver 4",
	"Silver Elite",
	"Silver Elite Master",
	"Gold Nova 1",
	"Gold Nova 2",
	"Gold Nova 3",
	"Gold Nova 4",
	"Master Guardian 1",
	"Master Guardian 2",
	"Master Guardian Elite",
	"Distinguished Master Guardian",
	"Legendary Eagle",
	"Legendary Eagle Master",
	"Supreme Master First Class",
	"The Global Elite"
}
local var_0_14 = panorama.loadstring("\n\tvar _GetTimestamp = function() {\n\t\treturn Date.now();\n\t}\n\n\tvar _FormatTimestamp = function(timestamp) {\n\t\tvar date = new Date(timestamp);\n\t\treturn `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}`;\n\t}\n\n\tvar _GetEvenLastWednesday = function() {\n\t\tvar date = new Date();\n\t\tvar new_date = new Date(date.setDate(date.getUTCDate()-date.getUTCDay()-4));\n\t\tvar last_wednesday = new Date(new_date.getFullYear(), new_date.getMonth(), date.getDate(), -1, 0, 0);\n\t\treturn last_wednesday.getTime();\n\t}\n\t\n\tvar _GetLastWednesday = function() {\n\t\tvar date = new Date();\n\t\tvar new_date = new Date(date.setDate(date.getUTCDate()-date.getUTCDay() + 3));\n\t\tvar last_wednesday = new Date(new_date.getFullYear(), new_date.getMonth(), date.getDate(), -1, 0, 0);\n\t\treturn last_wednesday.getTime();\n\t}\n\n\tvar _GetTodayUTC = function() {\n\t\tvar date = new Date();\n\t\treturn date.getUTCDay();\n\t}\n\n\tvar _TimeAgo = function(timestamp) {\n\t\tvar date = new Date(timestamp);\n\t\tvar minute = 60;\n\t\tvar hour = minute*60;\n\t\tvar day = hour*24;\n\t\tvar date_utc = new Date()\n\t\tvar elapsed = Math.floor((date_utc - date) / 1000);\n\t\tvar days_elapsed = 0;\n\t\tvar hours_elapsed = 0;\n\t\tvar minutes_elapsed = 0;\n\t\tif (elapsed > 7*day) return true;\n\t\telse return false;\n\t}\n\t\n\treturn {\n\t\tget_timestamp: _GetTimestamp,\n\t\tformat_timestamp: _FormatTimestamp,\n\t\ttoday_utc: _GetTodayUTC,\n\t\tget_last_wednesday: _GetLastWednesday,\n\t\tget_even_last_wednesday: _GetEvenLastWednesday,\n\t\ta_week_went_by: _TimeAgo\n\t}\n")()

local function var_0_15()
	for iter_1_0, iter_1_1 in pairs(var_0_9) do
		var_0_9[iter_1_0].bonus = "2x"
		var_0_9[iter_1_0].initial_xp = var_0_9[iter_1_0].actual_xp
		var_0_9[iter_1_0].initial_level = var_0_9[iter_1_0].actual_level
	end

	database.write("manager_reworked", var_0_9)
end

local function var_0_16(arg_2_0)
	if not arg_2_0 then
		var_0_9[var_0_4] = {
			custom_name = false,
			xp = 0,
			actual_xp = var_0_1.GetCurrentXp(),
			actual_level = var_0_1.GetCurrentLevel(),
			initial_level = var_0_1.GetCurrentLevel(),
			initial_xp = var_0_1.GetCurrentXp(),
			rank = var_0_1.GetCompetitiveRank(),
			wins = var_0_1.GetCompetitiveWins(),
			invite_code = var_0_1.GetFriendCode(),
			banned = var_0_3.GetFriendIsVacBanned(var_0_4) and "YES" or "NO",
			last_seen = var_0_14.format_timestamp(var_0_14.get_timestamp()),
			prime = var_0_2.GetFriendPrimeEligible(var_0_4) and "YES" or "NO",
			bonus = var_0_11[var_0_1.GetActiveXpBonuses()] or "NO"
		}
	elseif var_0_9[var_0_4] then
		var_0_9[var_0_4].name = var_0_1.GetName()
		var_0_9[var_0_4].actual_xp = var_0_1.GetCurrentXp()
		var_0_9[var_0_4].actual_level = var_0_1.GetCurrentLevel()
		var_0_9[var_0_4].rank = var_0_1.GetCompetitiveRank()
		var_0_9[var_0_4].wins = var_0_1.GetCompetitiveWins()
		var_0_9[var_0_4].bonus = var_0_11[var_0_1.GetActiveXpBonuses()] or "NO"
		var_0_9[var_0_4].last_seen = var_0_14.format_timestamp(var_0_14.get_timestamp())
		var_0_9[var_0_4].prime = var_0_2.GetFriendPrimeEligible(var_0_4) and "YES" or "NO"
		var_0_9[var_0_4].banned = var_0_3.GetFriendIsVacBanned(var_0_4) and "YES" or "NO"
	end

	database.write("manager_reworked", var_0_9)
end

;(function()
	if database.read("manager_reworked") == nil then
		var_0_16(false)
	else
		var_0_9 = database.read("manager_reworked")

		for iter_3_0, iter_3_1 in pairs(var_0_9) do
			if iter_3_0 == var_0_4 then
				return
			end
		end

		var_0_16(false)
	end
end)()
;(function()
	for iter_4_0, iter_4_1 in pairs(var_0_9) do
		var_0_6.get("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=E9EA79BB465366C98E5BAF31EC8A6F31&steamids=" .. iter_4_0, function(arg_5_0, arg_5_1)
			if not arg_5_0 or arg_5_1.status ~= 200 then
				return
			end

			local var_5_0 = json.parse(arg_5_1.body)

			if var_5_0 and #var_5_0.players > 0 then
				local var_5_1 = var_5_0.players[1]

				var_0_9[iter_4_0].banned = var_5_1.NumberOfVACBans > 0 and var_5_1.NumberOfGameBans > 0 and "YES" or "NO"
			end
		end)
	end

	database.write("manager_reworked", var_0_9)
end)()

local function var_0_17(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0 == arg_6_2 then
		return arg_6_3 - arg_6_1
	elseif arg_6_0 < arg_6_2 then
		return 5000 * (arg_6_2 - arg_6_0) - arg_6_1 + arg_6_3
	elseif arg_6_2 < arg_6_0 then
		var_0_9[arg_6_4].initial_level = var_0_9[arg_6_4].actual_level
		var_0_9[arg_6_4].initial_xp = var_0_9[arg_6_4].actual_xp

		database.write("manager_reworked", var_0_9)

		return 0
	end
end

local function var_0_18(arg_7_0)
	var_0_16(true)

	local var_7_0 = {}

	for iter_7_0, iter_7_1 in pairs(var_0_9) do
		local var_7_1 = var_0_9[iter_7_0]

		var_7_1.xp = var_0_17(var_7_1.initial_level, var_7_1.initial_xp, var_7_1.actual_level, var_7_1.actual_xp, iter_7_0)

		table.insert(var_7_0, {
			var_7_1.custom_name or var_7_1.name,
			tostring(var_7_1.xp) .. " XP",
			var_7_1.bonus,
			var_7_1.actual_level,
			var_0_13[var_7_1.rank],
			var_7_1.wins,
			var_7_1.prime,
			var_7_1.invite_code,
			var_7_1.last_seen,
			var_7_1.banned
		})
	end

	local var_7_2 = var_0_5(var_7_0, var_0_12, {
		style = "Unicode (Single Line)"
	})

	if database.read("manager_output") then
		writefile("acc_manager.txt", var_7_2)
	end

	if ui.get(var_0_8) or arg_7_0 then
		return
	end

	client.color_log(20, 255, 20, "[Account manager]")
	client.color_log(255, 255, 255, var_7_2)
end

local var_0_19 = ui.new_button("MISC", "Settings", "Account manager", function()
	var_0_18(false)
end)

local function var_0_20()
	if type(database.read("reset_day")) ~= "number" then
		local var_9_0 = var_0_14.get_last_wednesday()

		if not (var_0_14.today_utc() >= 3) then
			var_9_0 = var_0_14.get_even_last_wednesday()
		end

		database.write("reset_day", var_9_0)
		var_0_15()
	else
		local var_9_1 = database.read("reset_day")

		if var_0_14.a_week_went_by(var_9_1) then
			local var_9_2 = var_0_14.get_last_wednesday()

			if not (var_0_14.today_utc() >= 3) then
				var_9_2 = var_0_14.get_even_last_wednesday()
			end

			database.write("reset_day", var_9_2)
			var_0_15()

			if ui.get(var_0_8) then
				return
			end

			client.color_log(20, 255, 20, "[Account manager] XP bonus is back, enjoy!")
		end
	end
end

var_0_20()

if database.read("manager_output") then
	var_0_18(true)
end

client.set_event_callback("console_input", function(arg_10_0)
	if ui.get(var_0_8) then
		return false
	end

	if arg_10_0:match("^manager_delete") then
		local var_10_0 = arg_10_0:match("^manager_delete (.*)$")

		if var_0_9[var_10_0] then
			var_0_9[var_10_0] = nil

			client.color_log(20, 255, 20, "[Account manager] Account deleted.")
		else
			client.color_log(240, 20, 20, "[Account manager] ID64 not found.")
		end

		return true
	elseif arg_10_0:match("^manager_rename") then
		if arg_10_0:sub(16, #arg_10_0) ~= "" then
			if var_0_9[arg_10_0:sub(16, 32)] then
				if arg_10_0:sub(34, #arg_10_0) ~= "" then
					var_0_9[arg_10_0:sub(16, 32)].custom_name = arg_10_0:sub(34, #arg_10_0)

					client.color_log(20, 255, 20, "[Account manager] Custom name set for " .. arg_10_0:sub(16, 32))
					var_0_16(true)
				else
					client.color_log(240, 20, 20, "[Account manager] Please define a name for " .. arg_10_0:sub(16, 32))
				end
			elseif var_0_9[var_0_4] then
				var_0_9[var_0_4].custom_name = arg_10_0:sub(16, #arg_10_0)

				var_0_16(true)
				client.color_log(20, 255, 20, "[Account manager] Custom name set.")
			end
		elseif var_0_9[var_0_4] then
			client.color_log(240, 20, 20, "[Account manager] Please define a name for this account.")
		else
			client.color_log(240, 20, 20, "[Account manager] Account doesn't exist in your database.")
		end

		return true
	elseif arg_10_0:match("^manager_list") then
		local var_10_1 = {}

		for iter_10_0, iter_10_1 in pairs(var_0_9) do
			local var_10_2 = var_0_9[iter_10_0]

			table.insert(var_10_1, {
				iter_10_0,
				var_10_2.custom_name or var_10_2.name
			})
		end

		local var_10_3 = var_0_5(var_10_1, {
			"ID64",
			"Name"
		}, {
			style = "Unicode (Single Line)"
		})

		client.color_log(20, 255, 20, "[Account manager]")
		client.color_log(255, 255, 255, var_10_3)

		return true
	elseif arg_10_0:match("^manager_output") then
		if not database.read("manager_output") then
			database.write("manager_output", true)
			client.color_log(20, 255, 20, "[Account manager] Output enabled.")
		else
			database.write("manager_output", false)
			client.color_log(20, 255, 20, "[Account manager] Output disabled.")
		end

		return true
	elseif arg_10_0:match("^manager_print") then
		var_0_18(false)

		return true
	end
end)
var_0_7.register_event("CSGOShowMainMenu", function()
	var_0_20()
	var_0_16(true)
end)
var_0_7.register_event("ShowContentPanel", function()
	var_0_20()
	var_0_16(true)
end)
var_0_7.register_event("PanoramaComponent_Lobby_PlayerUpdated", function()
	var_0_20()
	var_0_16(true)
end)
client.set_event_callback("cs_win_panel_match", function()
	var_0_20()
	var_0_16(true)
end)
client.set_event_callback("shutdown", function()
	var_0_16(true)
end)
