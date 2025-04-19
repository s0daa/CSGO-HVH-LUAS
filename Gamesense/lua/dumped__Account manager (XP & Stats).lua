slot0 = panorama.open()
slot2 = slot0.PartyListAPI
slot3 = slot0.FriendsListAPI
slot4 = slot0.MyPersonaAPI.GetXuid()
slot5 = require("gamesense/table_gen")
slot6 = require("gamesense/http")
slot7 = require("gamesense/panorama_events")
slot8 = ui.reference("MISC", "Settings", "Hide from OBS")
slot9 = {}
slot10 = {
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday"
}
slot11 = {
	["3"] = "REDUCED",
	["1"] = "1x",
	[""] = "NO",
	["1,2"] = "2x"
}
slot12 = {
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
slot13 = {
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
slot14 = panorama.loadstring([[

	var _GetTimestamp = function() {
		return Date.now();
	}

	var _FormatTimestamp = function(timestamp) {
		var date = new Date(timestamp);
		return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}`;
	}

	var _GetEvenLastWednesday = function() {
		var date = new Date();
		var new_date = new Date(date.setDate(date.getUTCDate()-date.getUTCDay()-4));
		var last_wednesday = new Date(new_date.getFullYear(), new_date.getMonth(), date.getDate(), -1, 0, 0);
		return last_wednesday.getTime();
	}
	
	var _GetLastWednesday = function() {
		var date = new Date();
		var new_date = new Date(date.setDate(date.getUTCDate()-date.getUTCDay() + 3));
		var last_wednesday = new Date(new_date.getFullYear(), new_date.getMonth(), date.getDate(), -1, 0, 0);
		return last_wednesday.getTime();
	}

	var _GetTodayUTC = function() {
		var date = new Date();
		return date.getUTCDay();
	}

	var _TimeAgo = function(timestamp) {
		var date = new Date(timestamp);
		var minute = 60;
		var hour = minute*60;
		var day = hour*24;
		var date_utc = new Date()
		var elapsed = Math.floor((date_utc - date) / 1000);
		var days_elapsed = 0;
		var hours_elapsed = 0;
		var minutes_elapsed = 0;
		if (elapsed > 7*day) return true;
		else return false;
	}
	
	return {
		get_timestamp: _GetTimestamp,
		format_timestamp: _FormatTimestamp,
		today_utc: _GetTodayUTC,
		get_last_wednesday: _GetLastWednesday,
		get_even_last_wednesday: _GetEvenLastWednesday,
		a_week_went_by: _TimeAgo
	}
]])()

function slot15()
	for slot3, slot4 in pairs(uv0) do
		uv0[slot3].bonus = "2x"
		uv0[slot3].initial_xp = uv0[slot3].actual_xp
		uv0[slot3].initial_level = uv0[slot3].actual_level
	end

	database.write("manager_reworked", uv0)
end

function slot16(slot0)
	if not slot0 then
		uv0[uv1] = {
			custom_name = false,
			xp = 0,
			actual_xp = uv2.GetCurrentXp(),
			actual_level = uv2.GetCurrentLevel(),
			initial_level = uv2.GetCurrentLevel(),
			initial_xp = uv2.GetCurrentXp(),
			rank = uv2.GetCompetitiveRank(),
			wins = uv2.GetCompetitiveWins(),
			invite_code = uv2.GetFriendCode(),
			banned = uv3.GetFriendIsVacBanned(uv1) and "YES" or "NO",
			last_seen = uv4.format_timestamp(uv4.get_timestamp()),
			prime = uv5.GetFriendPrimeEligible(uv1) and "YES" or "NO",
			bonus = uv6[uv2.GetActiveXpBonuses()] or "NO"
		}
	elseif uv0[uv1] then
		uv0[uv1].name = uv2.GetName()
		uv0[uv1].actual_xp = uv2.GetCurrentXp()
		uv0[uv1].actual_level = uv2.GetCurrentLevel()
		uv0[uv1].rank = uv2.GetCompetitiveRank()
		uv0[uv1].wins = uv2.GetCompetitiveWins()
		uv0[uv1].bonus = uv6[uv2.GetActiveXpBonuses()] or "NO"
		uv0[uv1].last_seen = uv4.format_timestamp(uv4.get_timestamp())
		uv0[uv1].prime = uv5.GetFriendPrimeEligible(uv1) and "YES" or "NO"
		uv0[uv1].banned = uv3.GetFriendIsVacBanned(uv1) and "YES" or "NO"
	end

	database.write("manager_reworked", uv0)
end

function ()
	if database.read("manager_reworked") == nil then
		uv0(false)
	else
		uv1 = database.read("manager_reworked")

		for slot3, slot4 in pairs(uv1) do
			if slot3 == uv2 then
				return
			end
		end

		uv0(false)
	end
end()
function ()
	for slot3, slot4 in pairs(uv0) do
		uv1.get("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=E9EA79BB465366C98E5BAF31EC8A6F31&steamids=" .. slot3, function (slot0, slot1)
			if not slot0 or slot1.status ~= 200 then
				return
			end

			if json.parse(slot1.body) and #slot2.players > 0 then
				uv0[uv1].banned = slot2.players[1].NumberOfVACBans > 0 and slot3.NumberOfGameBans > 0 and "YES" or "NO"
			end
		end)
	end

	database.write("manager_reworked", uv0)
end()

function slot19(slot0, slot1, slot2, slot3, slot4)
	if slot0 == slot2 then
		return slot3 - slot1
	elseif slot0 < slot2 then
		return 5000 * (slot2 - slot0) - slot1 + slot3
	elseif slot2 < slot0 then
		uv0[slot4].initial_level = uv0[slot4].actual_level
		uv0[slot4].initial_xp = uv0[slot4].actual_xp

		database.write("manager_reworked", uv0)

		return 0
	end
end

slot21 = ui.new_button("MISC", "Settings", "Account manager", function ()
	uv0(false)
end)

function ()
	if type(database.read("reset_day")) ~= "number" then
		slot0 = uv0.get_last_wednesday()

		if uv0.today_utc() < 3 then
			slot0 = uv0.get_even_last_wednesday()
		end

		database.write("reset_day", slot0)
		uv1()
	elseif uv0.a_week_went_by(database.read("reset_day")) then
		slot1 = uv0.get_last_wednesday()

		if uv0.today_utc() < 3 then
			slot1 = uv0.get_even_last_wednesday()
		end

		database.write("reset_day", slot1)
		uv1()

		if ui.get(uv2) then
			return
		end

		client.color_log(20, 255, 20, "[Account manager] XP bonus is back, enjoy!")
	end
end()

if database.read("manager_output") then
	function (slot0)
		uv0(true)

		for slot5, slot6 in pairs(uv1) do
			slot7 = uv1[slot5]
			slot7.xp = uv2(slot7.initial_level, slot7.initial_xp, slot7.actual_level, slot7.actual_xp, slot5)

			table.insert({}, {
				slot7.custom_name or slot7.name,
				tostring(slot7.xp) .. " XP",
				slot7.bonus,
				slot7.actual_level,
				uv3[slot7.rank],
				slot7.wins,
				slot7.prime,
				slot7.invite_code,
				slot7.last_seen,
				slot7.banned
			})
		end

		if database.read("manager_output") then
			writefile("acc_manager.txt", uv4(slot1, uv5, {
				style = "Unicode (Single Line)"
			}))
		end

		if ui.get(uv6) or slot0 then
			return
		end

		client.color_log(20, 255, 20, "[Account manager]")
		client.color_log(255, 255, 255, slot2)
	end(true)
end

client.set_event_callback("console_input", function (slot0)
	if ui.get(uv0) then
		return false
	end

	if slot0:match("^manager_delete") then
		if uv1[slot0:match("^manager_delete (.*)$")] then
			uv1[slot1] = nil

			client.color_log(20, 255, 20, "[Account manager] Account deleted.")
		else
			client.color_log(240, 20, 20, "[Account manager] ID64 not found.")
		end

		return true
	elseif slot0:match("^manager_rename") then
		if slot0:sub(16, #slot0) ~= "" then
			if uv1[slot0:sub(16, 32)] then
				if slot0:sub(34, #slot0) ~= "" then
					uv1[slot0:sub(16, 32)].custom_name = slot0:sub(34, #slot0)

					client.color_log(20, 255, 20, "[Account manager] Custom name set for " .. slot0:sub(16, 32))
					uv2(true)
				else
					client.color_log(240, 20, 20, "[Account manager] Please define a name for " .. slot0:sub(16, 32))
				end
			elseif uv1[uv3] then
				uv1[uv3].custom_name = slot0:sub(16, #slot0)

				uv2(true)
				client.color_log(20, 255, 20, "[Account manager] Custom name set.")
			end
		elseif uv1[uv3] then
			client.color_log(240, 20, 20, "[Account manager] Please define a name for this account.")
		else
			client.color_log(240, 20, 20, "[Account manager] Account doesn't exist in your database.")
		end

		return true
	elseif slot0:match("^manager_list") then
		slot1 = {}

		for slot5, slot6 in pairs(uv1) do
			table.insert(slot1, {
				slot5,
				uv1[slot5].custom_name or slot7.name
			})
		end

		client.color_log(20, 255, 20, "[Account manager]")
		client.color_log(255, 255, 255, uv4(slot1, {
			"ID64",
			"Name"
		}, {
			style = "Unicode (Single Line)"
		}))

		return true
	elseif slot0:match("^manager_output") then
		if not database.read("manager_output") then
			database.write("manager_output", true)
			client.color_log(20, 255, 20, "[Account manager] Output enabled.")
		else
			database.write("manager_output", false)
			client.color_log(20, 255, 20, "[Account manager] Output disabled.")
		end

		return true
	elseif slot0:match("^manager_print") then
		uv5(false)

		return true
	end
end)
slot7.register_event("CSGOShowMainMenu", function ()
	uv0()
	uv1(true)
end)
slot7.register_event("ShowContentPanel", function ()
	uv0()
	uv1(true)
end)
slot7.register_event("PanoramaComponent_Lobby_PlayerUpdated", function ()
	uv0()
	uv1(true)
end)
client.set_event_callback("cs_win_panel_match", function ()
	uv0()
	uv1(true)
end)
client.set_event_callback("shutdown", function ()
	uv0(true)
end)
