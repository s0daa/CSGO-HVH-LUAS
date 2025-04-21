local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = getfenv()
local var_0_3 = {
	{
		"chat",
		"30625",
		true
	},
	{
		"cheat_revealer",
		"42104",
		false
	}
}

for iter_0_0, iter_0_1 in ipairs(var_0_3) do
	local var_0_4, var_0_5 = pcall(require, (iter_0_1[2] and "gamesense/" or "lib/") .. iter_0_1[1])

	if var_0_4 then
		var_0_1[iter_0_1[1]] = var_0_5
	else
		table.insert(var_0_0, {
			iter_0_1[1],
			iter_0_1[2],
			iter_0_1[3]
		})
	end
end

if #var_0_0 > 0 then
	client.color_log(255, 255, 50, "\n [ Cheater Detector ]\t\t\t  !!! MISSING LIBRARIES !!!")

	for iter_0_2 = 1, #var_0_0 do
		if var_0_0[iter_0_2][3] then
			client.color_log(255, 50, 50, "   ►  https://gamesense.pub/forums/viewtopic.php?id=" .. var_0_0[iter_0_2][2] .. " | " .. var_0_0[iter_0_2][1] .. "  ( REQUIRED )")
		else
			client.color_log(84, 135, 191, "   ►  https://gamesense.pub/forums/viewtopic.php?id=" .. var_0_0[iter_0_2][2] .. " | " .. var_0_0[iter_0_2][1] .. "  ( OPTIONAL )")
		end
	end
end

if #var_0_0 > 0 then
	local var_0_6 = false

	for iter_0_3 = 1, #var_0_0 do
		if var_0_0[iter_0_3][3] then
			var_0_6 = true

			break
		end
	end

	if var_0_6 then
		client.color_log(255, 90, 90, "\n [ Required Libraries Missing! Please subscribe to them from the links above! ]")
		error("Read error above!")
	else
		client.color_log(255, 100, 50, "\n [ Optional Libraries Missing! However, you can still use it without, but with decreased functionality! ]")
	end
end

local var_0_7 = entity.get_players
local var_0_8 = entity.get_prop
local var_0_9 = entity.get_player_name
local var_0_10 = entity.hitbox_position
local var_0_11 = entity.is_dormant
local var_0_12 = entity.get_origin
local var_0_13 = var_0_1.chat
local var_0_14 = var_0_1.cheat_revealer
local var_0_15 = require("ffi")
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = false
local var_0_20 = {}
local var_0_21 = {
	0,
	0,
	0
}
local var_0_22 = {
	0,
	0,
	0
}
local var_0_23 = 1
local var_0_24 = false
local var_0_25 = 0
local var_0_26 = true
local var_0_27 = panorama.loadstring("\treturn MyPersonaAPI.GetXuid();\n")()
local var_0_28 = ui.new_multiselect("VISUALS", "Player ESP", "ⓘ Account Checkers", {
	"\aFF5500FFFaceIT Checker",
	"\a4E84F2FFEsportal Checker",
	"\aFFB625FFUnmatched Checker",
	"\a67F1A2FFESEA Checker"
})
local var_0_29 = ui.new_combobox("VISUALS", "Player ESP", "◑ \aCDCDCDFFUI Style", {
	"Multicolored",
	"Monochrome"
})
local var_0_30 = ui.new_checkbox("MISC", "Miscellaneous", "\aFF0000FF⛨ \aCDCDCDFFEnable Cheater Detector")
local var_0_31 = ui.new_checkbox("MISC", "Miscellaneous", "\aCDCDCDFF⚙ Show Settings")
local var_0_32 = ui.new_multiselect("MISC", "Miscellaneous", "\a00FF00FF◑ \aCDCDCDFFEnabled Detectors", {
	"↺ High Flicks",
	"↺ Jitter Anti-Aim",
	"♿ Fake Lag",
	"✜ Aimbot",
	"✜ Silent Aimbot",
	"⏫ Bhop",
	"⛼ Shared ESP",
	"↺ Desync"
})
local var_0_33 = ui.new_multiselect("MISC", "Miscellaneous", "\a5BB1FCFF✉ \aCDCDCDFFOutput Methods", {
	"☰ Console",
	"✉ Chat",
	"✉ Local Chat"
})
local var_0_34 = ui.new_checkbox("MISC", "Miscellaneous", "\aFFFF00FF✎ \aCDCDCDFFLog violation on detection")
local var_0_35 = ui.new_checkbox("MISC", "Miscellaneous", "\aFF0000FF⛔ \aCDCDCDFFDisable Local Player Logs")
local var_0_36 = ui.new_checkbox("MISC", "Miscellaneous", "\aFF0000FF⛔ \aCDCDCDFFDisable Teammate Logs")
local var_0_37 = ui.new_checkbox("MISC", "Miscellaneous", "\a5BB1FCFF⋘ \aCDCDCDFFRender Cache History")
local var_0_38 = ui.new_checkbox("MISC", "Miscellaneous", "\aFF0000FF⛨ \aCDCDCDFFOnly Log on Trust Level Change")
local var_0_39 = ui.new_checkbox("MISC", "Miscellaneous", "\aA020F0FF♫ \aCDCDCDFFPlay Sound on Trust Level Change")
local var_0_40 = ui.new_checkbox("MISC", "Miscellaneous", "\a5BB1FCFFⓘ \aCDCDCDFFLog Violation Details")
local var_0_41 = ui.new_checkbox("MISC", "Miscellaneous", "\aFF0000FF⚐ \aCDCDCDFFDisplay ESP Flags")
local var_0_42 = ui.new_checkbox("MISC", "Miscellaneous", "\aCDCDCDFF⛶ Hidden Mode")
local var_0_43 = ui.new_label("MISC", "Miscellaneous", "\a00000000")
local var_0_44 = ui.new_checkbox("MISC", "Miscellaneous", "\aFFFF00FF✎ \aCDCDCDFFShow Logger")
local var_0_45 = ui.new_label("MISC", "Miscellaneous", "\a84AF10FF☰ \aCDCDCDFFPlayers")
local var_0_46 = ui.new_listbox("MISC", "Miscellaneous", "Players", {})
local var_0_47 = ui.new_button("MISC", "Miscellaneous", "\aFFFF00FF✎ \aCDCDCDFFPrint Selected User's Violations", function()
	return
end)
local var_0_48 = ui.new_button("MISC", "Miscellaneous", "\aFFFF00FF✎ \aCDCDCDFFPrint Everyone's Violations", function()
	return
end)
local var_0_49 = ui.new_button("MISC", "Miscellaneous", "\aFF0000FF♨ Reset Everyone's Violations", function()
	Log("All violations have been reset! {info}")

	var_0_18 = {}
	var_0_17 = {}
end)
local var_0_50 = ui.new_button("MISC", "Miscellaneous", "\aFF0000FF✜ View Killcam (BUGGY)", function()
	if #var_0_20 > 0 then
		var_0_19 = true
	else
		Log("No killcam available! {info}")
	end
end)
local var_0_51 = ui.new_checkbox("MISC", "Miscellaneous", "\aCDCDCDFF➤ Auto Play Killcam on Death")
local var_0_52 = ui.new_label("MISC", "Miscellaneous", "\a00000000")
local var_0_53 = ui.new_checkbox("MISC", "Miscellaneous", "\aFFFF00FF⚠ \aCDCDCDFFValue Tweaks \aFF0000FF*")
local var_0_54 = ui.new_label("MISC", "Miscellaneous", "\aFF0000FF ====== !!!WARNING!!! ====== ")
local var_0_55 = ui.new_label("MISC", "Miscellaneous", "\aFF0000FF* Changing values can cause false positives!")
local var_0_56 = ui.new_slider("MISC", "Miscellaneous", "⋘ Max Cache Entries (Lower if potato PC)", 10, 100, 25, true, "x")
local var_0_57 = ui.new_slider("MISC", "Miscellaneous", "↺ Viewangle Change (Anti Aim)", 0, 180, 50, true, "°")
local var_0_58 = ui.new_slider("MISC", "Miscellaneous", "♿ Movement Change (Fake Lag)", 0, 50, 30, true, "m")
local var_0_59 = ui.new_slider("MISC", "Miscellaneous", "✜ Flick Change (Aimbot)", 0, 50, 5, true, "px")
local var_0_60 = ui.new_slider("MISC", "Miscellaneous", "✜ Silent Aimbot Offset", 0, 100, 7, true, "px")
local var_0_61 = ui.new_slider("MISC", "Miscellaneous", "⏫ Local Bhop Speed", 0, 50, 4, true, "m")
local var_0_62 = ui.new_slider("MISC", "Miscellaneous", "⏫ Networked Bhop Speed", 0, 50, 4, true, "m")
local var_0_63 = ui.new_slider("MISC", "Miscellaneous", "⏫ Max Networked Bhop Speed", 0, 50, 12, true, "m")
local var_0_64 = ui.new_slider("MISC", "Miscellaneous", "↺ Min Equal Jitter", 5, 50, 20, true, "x")
local var_0_65 = ui.new_slider("MISC", "Miscellaneous", "⛼ Ping Forgiveness", 1, 10, 4, true, "/•")
local var_0_66 = ui.new_button("MISC", "Miscellaneous", "\aFFF000FF⎌ Default Values", function()
	ui.set(var_0_56, 25)
	ui.set(var_0_57, 50)
	ui.set(var_0_58, 30)
	ui.set(var_0_59, 5)
	ui.set(var_0_60, 7)
	ui.set(var_0_61, 4)
	ui.set(var_0_62, 4)
	ui.set(var_0_63, 12)
	ui.set(var_0_64, 20)
	ui.set(var_0_65, 4)
end)

ui.set_callback(var_0_56, function(arg_6_0)
	local var_6_0 = ui.get(arg_6_0) * 0.8

	if var_6_0 < 10 then
		var_6_0 = 10
	end

	if var_6_0 <= ui.get(var_0_64) then
		ui.set(var_0_64, var_6_0)
	end
end)
ui.set_callback(var_0_64, function(arg_7_0)
	local var_7_0 = ui.get(arg_7_0) / 0.8

	if var_7_0 > 100 then
		var_7_0 = 100
	end

	if var_7_0 >= ui.get(var_0_56) then
		ui.set(var_0_56, var_7_0)
	end
end)

local var_0_67 = false
local var_0_68 = false
local var_0_69 = false
local var_0_70 = false
local var_0_71 = false
local var_0_72 = false
local var_0_73 = false
local var_0_74 = false

ui.set_callback(var_0_32, function(arg_8_0)
	local var_8_0 = ui.get(var_0_32)

	var_0_17 = {}
	var_0_67 = false
	var_0_68 = false
	var_0_69 = false
	var_0_70 = false
	var_0_71 = false
	var_0_72 = false
	var_0_73 = false
	var_0_74 = false

	for iter_8_0 = 1, #var_8_0 do
		if var_8_0[iter_8_0] == "↺ High Flicks" then
			var_0_67 = true
		elseif var_8_0[iter_8_0] == "↺ Jitter Anti-Aim" then
			var_0_68 = true
		elseif var_8_0[iter_8_0] == "♿ Fake Lag" then
			var_0_69 = true
		elseif var_8_0[iter_8_0] == "✜ Aimbot" then
			var_0_70 = true
		elseif var_8_0[iter_8_0] == "✜ Silent Aimbot" then
			var_0_71 = true
		elseif var_8_0[iter_8_0] == "⏫ Bhop" then
			var_0_72 = true
		elseif var_8_0[iter_8_0] == "⛼ Shared ESP" then
			var_0_73 = true
		elseif var_8_0[iter_8_0] == "↺ Desync" then
			var_0_74 = true
		end
	end
end)

local var_0_75 = panorama.loadstring("\treturn (() => {\n\t\tconst CreatePanel_orig = $.CreatePanel;\n\t\n\t\tlet hidden_mode = false;\n\t\tlet players_detection = {};\n\t\tlet violation_level_limit = {\n\t\t\thigh_flick: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 25,\n\t\t\t\t3: 50,\n\t\t\t},\n\t\t\tjitter_anti_aim: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 25,\n\t\t\t\t3: 50,\n\t\t\t},\n\t\t\tfake_lag: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 25,\n\t\t\t\t3: 50,\n\t\t\t},\n\t\t\taimbot: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 2,\n\t\t\t\t3: 4,\n\t\t\t},\n\t\t\tsilent_aimbot: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 1,\n\t\t\t\t3: 2,\n\t\t\t},\n\t\t\tbhop: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 10,\n\t\t\t\t3: 20,\n\t\t\t},\n\t\t\tdesync: {\n\t\t\t\t1: 0,\n\t\t\t\t2: 3,\n\t\t\t\t3: 5,\n\t\t\t},\n\t\t};\n\n\t\tlet mono_icons = false;\n\n\t\tlet faceitprofiles = [];\n\t\tlet pendingfaceitprofiles = [];\n\t\tlet faceit_checker = false;\n\t\tlet faceit_icon = 'https://cdn.discordapp.com/attachments/1081028391869886466/1107072251133702294/faceit.png';\n\t\tlet faceit_icon_mono = 'https://media.discordapp.net/attachments/1081091376101457992/1117397795742154812/faceit.png'\n\n\t\tlet esportalprofiles = [];\n\t\tlet pendingesportalprofiles = [];\n\t\tlet e_checker = false;\n\t\tlet esportal_icon = 'https://media.discordapp.net/attachments/1081091376101457992/1117408539279900692/cUTp4C1.png';\n\t\tlet esportal_icon_mono = 'https://media.discordapp.net/attachments/1081091376101457992/1117493681264545823/kMZ9Wgk.png'\n\t\tlet esportal_currentRank = null;\n\t\tconst esportal_ranks = {\n\t\t\t\"Legend\": 2000,\n\t\t\t\"Pro II\": 1900,\n\t\t\t\"Pro I\": 1800,\n\t\t\t\"Elite II\": 1700,\n\t\t\t\"Elite I\": 1600,\n\t\t\t\"Master II\": 1500,\n\t\t\t\"Master I\": 1400,\n\t\t\t\"Veteran II\": 1300,\n\t\t\t\"Veteran I\": 1200,\n\t\t\t\"Gold II\": 1100,\n\t\t\t\"Gold I\": 1000,\n\t\t\t\"Silver II\": 900,\n\t\t\t\"Silver I\": 0,\n\t\t};\n\n\t\tlet eseaprofiles = [];\n\t\tlet pendingeseaprofiles = [];\n\t\tlet esea_checker = false;\n\t\tlet esea_icon = 'https://static.esea.net/global/images/clubs/logo/55.1582667803.png';\n\t\tlet esea_icon_mono = 'https://media.discordapp.net/attachments/1081091376101457992/1117397795503095808/esea.png'\n\n\t\tlet unmatchedprofiles = [];\n\t\tlet pendingunmatchedprofiles = [];\n\t\tlet unmatched_checker = false;\n\t\tlet unmatched_icon = 'https://unmatched.gg/assets/img/logo.png';\n\t\tlet unmatched_icon_mono = 'https://media.discordapp.net/attachments/1081091376101457992/1117417013074219028/logo.png'\n\n\n\t\tlet unmatched_detections = [];\n\t\tconst unmatched_cheats = {\n\t\t\t\"unknown\": 0,\n\t\t\t\"fatality\": 1,\n\t\t\t\"airflow\": 2,\n\t\t\t\"neverlose\": 3,\n\t\t\t\"primordial\": 4,\n\t\t\t\"gamesense\": 5,\n\t\t\t\"pandora\": 6,\n\t\t\t\"onetap\": 7,\n\t\t\t\"ev0lve\": 8,\n\t\t\t\"plague\": 9,\n\t\t\t\"nixware\": 10,\n\t\t\t\"solus ui\": 11,\n\t\t\t\"rifk7\": 12,\n\t\t\t\"legion\": 13,\n\t\t\t\"monolith\": 14,\n\t\t\t\"aimware\": 15,\n\t\t\t\"legendware\": 16,\n\t\t\t\"spirthack\": 17,\n\t\t\t\"extension\": 18,\n\t\t\t\"weave\": 19,\n\t\t\t\"fatality crack\": 20,\n\t\t};\n\n\t\tfunction FindUnmatchedCheatByID(CheatID) {\n\t\t\tfor (let cheat in unmatched_cheats)\n\t\t\t\tif (unmatched_cheats[cheat] == CheatID)\n\t\t\t\t\treturn cheat;\n\t\t\t\n\t\t\treturn \"unknown\";\n\t\t}\n\t\n// ===================================== FACEIT API =====================================\n\t\tfunction _CheckFaceitProfile(id, oncomplete) {\n\t\t\tconst profile = faceitprofiles.find((v, i) => { return v.id == id });\n\t\n\t\t\tif (!profile || pendingfaceitprofiles.find((v, i) => { return v == id })) {  \n\t\t\t\tpendingfaceitprofiles.push(id);\n\t\t\t\t\n\t\t\t\t$.AsyncWebRequest(`https://api.faceit.com/search/v1/?limit=1&query=${id}`, {\n\t\t\t\t\ttype: 'GET',\n\t\t\t\t\tdata: {},\n\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\tif (!data || !data.payload || !data.payload.players \n\t\t\t\t\t\t\t|| !data.payload.players.results || data.payload.players.total_count == 0) {\n\t\t\t\t\t\t\treturn;\n\t\t\t\t\t\t}\n\t\n\t\t\t\t\t\tconst profile = data.payload.players.results[0];\n\t\t\t\t\t\tlet level = profile.games.find((v, i) => { return v.name == 'csgo'; });\n\t\t\t\t\t\tif (level)\n\t\t\t\t\t\t\tlevel = level.skill_level;\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tlevel = 0;\n\n\t\t\t\t\t\t// verified is boolean\n\t\t\t\t\t\tlet verified = profile.verified;\n\t\t\t\t\t\tif (profile.verified)\n\t\t\t\t\t\t\tverified = 'Yes';\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tverified = 'No';\n\t\t\t\t\t\t\t\n\t\n\t\t\t\t\t\tfaceitprofiles.push({name: profile.nickname, id: id, level: level, country: profile.country, avatar: profile.avatar, verified: verified});\n\t\t\t\t\t}),\n\t\t\t\t\tcomplete: (() => {\n\t\t\t\t\t\tif (oncomplete)\n\t\t\t\t\t\t\toncomplete(faceitprofiles.find((v, i) => { return v.id == id }));\n\t\n\t\t\t\t\t\tpendingfaceitprofiles.splice(pendingfaceitprofiles.indexOf(id), 1);\n\t\t\t\t\t}),\n\t\t\t\t\ttimeout: 5000,\n\t\t\t\t\theaders: {}\n\t\t\t\t});\n\t\n\t\t\t\treturn false;\n\t\t\t}\n\t\n\t\t\tif (oncomplete)\n\t\t\t\toncomplete(profile);\n\t\n\t\t\treturn !!profile;\n\t\t}\n// ===================================== FACEIT API =====================================\n\n\n// ===================================== ESPORTAL API =====================================\n\t\tfunction _CheckEsportalProfile(id, oncomplete) {\n\t\t\tconst profile = esportalprofiles.find((v, i) => { return v.id == id });\n\n\t\t\tif (!profile || pendingesportalprofiles.find((v, i) => { return v == id })) {  \n\t\t\t\tpendingesportalprofiles.push(id);\n\t\t\t\tlet timestamp = Date.now();\n\t\t\t\tlet steamid3 = id;\n\t\t\t\tif (id.length == 17) {\n\t\t\t\t\t// Ghetto workaround around big integer problem;\n\t\t\t\t\t$.AsyncWebRequest(`https://estate.red/convertID.php?id=${id}`, {\n\t\t\t\t\t\ttype: 'GET',\n\t\t\t\t\t\tdata: {},\n\t\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\t\tif (!data) {\n\t\t\t\t\t\t\t\treturn;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tsteamid3 = data.SteamID3;\n\t\t\t\t\t\t\t//strip universe and brackets\n\t\t\t\t\t\t\tsteamid3 = steamid3.replace('[U:1:', '');\n\t\t\t\t\t\t\tsteamid3 = steamid3.replace(']', '');\n\n\t\t\t\t\t\t\t_makeEsportalProfileRequest();\n\t\t\t\t\t\t}),\n\t\t\t\t\t});\n\t\t\t\t}\n\n\t\t\t\tfunction _makeEsportalProfileRequest() {\n\t\t\t\t\t$.AsyncWebRequest(`https://esportal.com/api/user_profile/get?_=${timestamp}&id=${steamid3}&bans=1`, {\n\t\t\t\t\t\ttype: 'GET',\n\t\t\t\t\t\tdata: {},\n\t\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\t\tif (!data) {\n\t\t\t\t\t\t\t\treturn;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t//Name, Elo, Rank(https://esportal.com/en/ranking), Wins, Winrate(Wins / (wins+losses)*100)\n\t\t\t\t\t\t\tlet winrate = (data.wins / (data.wins + data.losses) * 100).toFixed(2)\n\n\t\t\t\t\t\t\t//Convert elo to rank\n\t\t\t\t\t\t\tfor (const rank in esportal_ranks) {\n\t\t\t\t\t\t\t\tif (data.elo >= esportal_ranks[rank]) {\n\t\t\t\t\t\t\t\t\tesportal_currentRank = rank;\n\t\t\t\t\t\t\t\t\tbreak; // Break out of the loop after finding the appropriate rank\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\n\n\t\t\t\t\t\t\tesportalprofiles.push({name: data.username, id: id, elo: data.elo, rank: esportal_currentRank, wins: data.wins, losses: data.losses, winrate: winrate, banned: data.banned});\n\t\t\t\t\t\t}),\n\t\t\t\t\t\tcomplete: (() => {\n\t\t\t\t\t\t\tif (oncomplete)\n\t\t\t\t\t\t\t\toncomplete(esportalprofiles.find((v, i) => { return v.id == id }));\n\n\t\t\t\t\t\t\tpendingesportalprofiles.splice(pendingesportalprofiles.indexOf(id), 1);\n\t\t\t\t\t\t}),\n\t\t\t\t\t\ttimeout: 5000,\n\t\t\t\t\t\theaders: {}\n\t\t\t\t\t});\n\t\t\t\t}\n\n\t\t\t\treturn false;\n\t\t\t}\n\n\t\t\tif (oncomplete)\n\t\t\t\toncomplete(profile);\n\n\t\t\treturn !!profile;\n\t\t}\n// ===================================== ESPORTAL API =====================================\n\n// ===================================== ESEA API =====================================\n\t\tfunction _CheckEseaProfile(id, oncomplete) {\n\t\t\tconst profile = eseaprofiles.find((v, i) => { return v.id == id });\n\n\t\t\tif (!profile || pendingeseaprofiles.find((v, i) => { return v == id })) {  \n\t\t\t\t\tpendingeseaprofiles.push(id);\n\t\t\t\t\tlet timestamp = Date.now();\n\t\t\t\t\tlet steamID = id;\n\t\t\t\t\tif (id.length == 17) {\n\t\t\t\t\t\t// Ghetto workaround around big integer problem;\n\t\t\t\t\t\t$.AsyncWebRequest(`https://estate.red/convertID.php?id=${id}`, {\n\t\t\t\t\t\t\ttype: 'GET',\n\t\t\t\t\t\t\tdata: {},\n\t\t\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\t\t\tif (!data) {\n\t\t\t\t\t\t\t\t\treturn;\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\tsteamID = data.SteamID;\n\t\t\t\t\t\t\t\tsteamID = steamID.split(':').pop();\n\t\t\t\t\t\t\t\tsteamID = `1:0:${steamID}`;\n\t\t\t\t\t\t\t\t_makeEseaProfileRequest();\n\t\t\t\t\t\t\t}),\n\t\t\t\t\t\t});\n\t\t\t\t\t}\n\n\t\t\t\tfunction _makeEseaProfileRequest() {\n\t\t\t\t\t$.AsyncWebRequest(`https://estate.red/esea/?query=${steamID}`, {\n\t\t\t\t\t\ttype: 'GET',\n\t\t\t\t\t\tdata: {},\n\t\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\t\tif (!data || data.success != true) {\n\t\t\t\t\t\t\t\treturn;\n\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\tdata.id = id;\n\t\t\t\t\t\t\teseaprofiles.push(data);\n\t\t\t\t\t\t}),\n\t\t\t\t\t\tcomplete: ((e) => {\n\t\t\t\t\t\t\tif (oncomplete)\n\t\t\t\t\t\t\t\toncomplete(eseaprofiles.find((v, i) => { return v.id == id }));\n\n\t\t\t\t\t\t\tpendingeseaprofiles.splice(pendingeseaprofiles.indexOf(id), 1);\n\t\t\t\t\t\t}),\n\t\t\t\t\t\ttimeout: 5000\n\t\t\t\t\t});\n\t\t\t\t}\n\n\t\t\t\treturn false;\n\t\t\t}\n\n\t\t\tif (oncomplete)\n\t\t\t\toncomplete(profile);\n\n\t\t\treturn !!profile;\n\t\t}\n// ===================================== ESEA API =====================================\n\n\n// ===================================== UNMATCHED API =====================================\n\t\tfunction _CheckUnmatchedProfile(id, oncomplete) {\n\t\t\tconst profile = unmatchedprofiles.find((v, i) => { return v.id == id });\n\n\t\t\tif (!profile || pendingunmatchedprofiles.find((v, i) => { return v == id })) {  \n\t\t\t\t\tpendingunmatchedprofiles.push(id);\n\t\t\t\t\tlet timestamp = Date.now();\n\t\t\t\t\tif (id.length == 17)\n\t\t\t\t\t\t_makeUnmatchedProfileRequest();\n\n\t\t\t\tfunction _makeUnmatchedProfileRequest() {\n\t\t\t\t\tconst ids = [];\n\t\t\t\t\tids.push(id);\n\n\t\t\t\t\t$.AsyncWebRequest(`https://api.cheat.show/v2/partners/detector/pull`, {\n\t\t\t\t\t\ttype: 'POST',\n\t\t\t\t\t\ttimeout: 5000,\n\t\t\t\t\t\tdata: {payload: JSON.stringify({\n\t\t\t\t\t\t\txuid: id,\n\t\t\t\t\t\t\txuids: ids\n\t\t\t\t\t\t})},\n\t\t\t\t\t\theaders: {\n\t\t\t\t\t\t\t\"X-Api-Key\" : \"7d35b6dd-b3db-437b-af24-c8a37f56616f\"\n\t\t\t\t\t\t},\n\t\t\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\t\t\tif (!data || data.status != true || !data.xuids || !data.xuids[id] || data.xuids[id].lastSoftware == 0)\n\t\t\t\t\t\t\t\treturn;\n\n\t\t\t\t\t\t\tconst profile = data;\n\t\t\t\t\t\t\tprofile.used_cheats = [];\n\t\t\t\t\t\t\tprofile.last_used_cheat = null;\n\t\t\t\t\t\t\tprofile.last_inject = null;\n\n\t\t\t\t\t\t\tconst xuidprofile = profile.xuids[id];\n\t\t\t\t\t\t\tif (xuidprofile.software) {\n\t\t\t\t\t\t\t\tfor (const cheat in xuidprofile.software) {\n\t\t\t\t\t\t\t\t\tlet cheatstring = FindUnmatchedCheatByID(cheat);\n\t\t\t\t\t\t\t\t\tcheatstring = cheatstring.charAt(0).toUpperCase() + cheatstring.slice(1);\n\t\t\t\t\t\t\t\t\tprofile.used_cheats.push(cheatstring);\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\tif (xuidprofile.lastSoftware)\n\t\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\tlet cheatstring = FindUnmatchedCheatByID(xuidprofile.lastSoftware);\n\t\t\t\t\t\t\t\tcheatstring = cheatstring.charAt(0).toUpperCase() + cheatstring.slice(1);\n\t\t\t\t\t\t\t\tprofile.last_used_cheat = cheatstring;\n\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\tif (xuidprofile.detectionTime)\n\t\t\t\t\t\t\t\tprofile.last_inject = new Date(xuidprofile.detectionTime);\n\n\t\t\t\t\t\t\tunmatchedprofiles.push({id: id, used_cheats: profile.used_cheats, last_used_cheat: profile.last_used_cheat, last_inject: profile.last_inject});\n\t\t\t\t\t\t}),\n\t\t\t\t\t\tcomplete: ((e) => {\n\t\t\t\t\t\t\tif (oncomplete)\n\t\t\t\t\t\t\t\toncomplete(unmatchedprofiles.find((v, i) => { return v.id == id }));\n\n\t\t\t\t\t\t\tpendingunmatchedprofiles.splice(pendingunmatchedprofiles.indexOf(id), 1);\n\t\t\t\t\t\t}),\n\t\t\t\t\t});\n\t\t\t\t}\n\n\t\t\t\treturn false;\n\t\t\t}\n\t\n\t\t\tif (oncomplete)\n\t\t\t\toncomplete(profile);\n\t\n\t\t\treturn !!profile;\n\t\t}\n// ===================================== UNMATCHED API =====================================\n\n\n\n\n\t\tfunction _CreatePanel_Hook(...args) {\n\t\t\tif (args[2] == 'JsContextMenuPlayercardBtns') {\n\t\t\t\tconst panel = CreatePanel_orig.call(this, ...args);\n\n\t\t\t\tif (hidden_mode) return panel;\n\t\t\t\t\n\t\t\t\t$.Schedule(0, () => {\n\t\t\t\t\tconst xuid = args[1].GetAttributeString( \"xuid\", \"Failed to Fetch\" );\n\t\t\t\t\tconst type = args[1].GetAttributeString( \"type\", \"\" );\n\t\t\t\t\tlet commendspanel = args[1].FindChildTraverse('JsPlayerCommendations');\n\t\t\t\t\tlet parent2 = commendspanel.GetParent();\n\t\t\t\t\tlet leadercommends = args[1].FindChildTraverse('JsPlayerleader');\n\t\t\t\t\tlet parent = leadercommends.GetParent();\n\n\t\t\t\t\t// add new panel <Panel class=\"player-card-commendations\">\n\t\t\t\t\tconst extras_panel = $.CreatePanel('Panel', parent2, 'extrapanel', { \n\t\t\t\t\t\tclass: 'player-card-commendations-container player-card-border',\n\t\t\t\t\t\t// same line items\n\t\t\t\t\t\tstyle: 'height: 30px; width: 100%; margin-top: 5px; margin-bottom: 5px; margin-left: 0px; margin-right: 0px; padding: 0px;'\n\t\t\t\t\t});\n\n\t\t\t\t\t// after parent\n\t\t\t\t\tparent2.MoveChildBefore(extras_panel, commendspanel);\n\n\t\t\t\t\t// ======================== FaceIT ========================\n\t\t\t\t\tif (faceit_checker)\n\t\t\t\t\t{\n\t\t\t\t\t\tconst elEntryBtn = $.CreatePanel('Panel', extras_panel, 'faceit', { \n\t\t\t\t\t\t\tclass: 'player-card-commendations-icon',\n\t\t\t\t\t\t\tstyle: 'height: 22px; width: 22px; margin: 0px; margin-left: 35px; margin-right: 5px;'\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.AddClass('hidden');\n\t\t\t\t\t\telEntryBtn.visible = false;\n\n\t\t\t\t\t\textras_panel.MoveChildAfter(elEntryBtn, parent2);\n\t\t\t\t\t\n\t\t\t\t\t\tlet usedicon = mono_icons ? faceit_icon_mono : faceit_icon;\n\n\t\t\t\t\t\t$.CreatePanel( 'Image', elEntryBtn, 'faceit', {\n\t\t\t\t\t\t\tsrc: usedicon,\n\t\t\t\t\t\t\tid: 'faceiticon'\n\t\t\t\t\t\t});\n\t\t\t\t\t\n\t\t\t\t\t\t_CheckFaceitProfile(xuid, ((profile) => {\n\t\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\t\tif (profile && elEntryBtn) {\n\t\t\t\t\t\t\t\t\telEntryBtn.visible = true;\n\t\t\t\t\t\t\t\t\telEntryBtn.RemoveClass('hidden');\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tcatch(err) { }\n\t\t\t\t\t\t}));\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent( 'onactivate', (function ( id, type ) {\n\t\t\t\t\t\t\t$.DispatchEvent('ContextMenuEvent', '');\n\t\t\t\t\t\t\tSteamOverlayAPI.OpenURL(`https://www.faceit.com/en/players/${faceitprofiles.find((v, i) => { return v.id == id }).name}`);\n\t\t\t\t\t\t}).bind( this, xuid, type ) );\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseover', () =>\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\tconst profile = faceitprofiles.find((v, i) => { return v.id == xuid });\n\t\t\t\t\t\t\tlet text =  ``\n\t\t\t\t\t\t\tif (profile.avatar)\n\t\t\t\t\t\t\t\ttext += `<img src=\"${profile != null && profile.avatar || ''}\"><br>`;\n\n\t\t\t\t\t\t\ttext +=\t `<b><font color=\"#FF5500\">FaceIT Profile</font></b><br>` +\n\t\t\t\t\t\t\t\t\t\t`Name: <font color=\"#FF5500\">${profile != null && profile.name || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Level: <font color=\"#FF5500\">${profile != null && profile.level || '0'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Country: <font color=\"#FF5500\">${profile != null && profile.country || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Verified: <font color=\"${profile != null && profile.verified == 'Yes' && '#00FF00' || '#FF0000'}\">${profile != null && profile.verified || '#ERROR'}</font>`;\n\t\t\t\t\t\t\t\n\n\t\t\t\t\t\t\tUiToolkitAPI.ShowTextTooltip(elEntryBtn.id, text);\n\t\t\t\t\t\t});\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseout', function() {\n\t\t\t\t\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\t\t\t\t});\n\t\t\t\t\t}\n\n\t\t\t\t\t// ======================== ESPORTAL ========================\n\t\t\t\t\tif (esportal_checker)\n\t\t\t\t\t{\n\t\t\t\t\t\tconst elEntryBtn = $.CreatePanel('Panel', extras_panel, 'esportal', { \n\t\t\t\t\t\t\tclass: 'player-card-commendations-icon',\n\t\t\t\t\t\t\tstyle: 'height: 22px; width: 22px; margin: 0px; margin-left: 35px; margin-right: 5px;'\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.AddClass('hidden');\n\t\t\t\t\t\telEntryBtn.visible = false;\n\t\t\t\t\t\n\t\t\t\t\t\textras_panel.MoveChildAfter(elEntryBtn, parent2);\n\t\t\t\t\t\n\t\t\t\t\t\tlet usedicon = mono_icons ? esportal_icon_mono : esportal_icon;\n\n\t\t\t\t\t\t$.CreatePanel( 'Image', elEntryBtn, 'esportal', {\n\t\t\t\t\t\t\tsrc: usedicon,\n\t\t\t\t\t\t\tid: 'esportalicon'\n\t\t\t\t\t\t});\n\t\t\t\t\t\t\n\t\t\t\t\t\t_CheckEsportalProfile(xuid, ((profile) => {\n\t\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\t\tif (profile && elEntryBtn) {\n\t\t\t\t\t\t\t\t\telEntryBtn.visible = true;\n\t\t\t\t\t\t\t\t\telEntryBtn.RemoveClass('hidden');\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tcatch(err) { }\n\t\t\t\t\t\t}));\n\n\n\t\t\t\t\t\telEntryBtn.SetPanelEvent( 'onactivate', (function ( id, type ) {\n\t\t\t\t\t\t\tconst profile = esportalprofiles.find((v, i) => { return v.id == xuid });\t\t\t\t\t\t \n\t\t\t\t\t\t\t$.DispatchEvent('ContextMenuEvent', '');\n\t\t\t\t\t\t\tSteamOverlayAPI.OpenURL(`https://esportal.com/profile/${esportalprofiles.find((v, i) => { return v.id == id }).name}`);\n\t\t\t\t\t\t}).bind( this, xuid, type ) );\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseover', () =>\n\t\t\t\t\t\t{   \n\t\t\t\t\t\t\tconst profile = esportalprofiles.find((v, i) => { return v.id == xuid });\t\t\t\t\t\t \n\t\t\t\t\t\t\tlet text =  `<b><font color=\"#4E84F2FF\">Esportal Profile</font></b><br>` +\n\t\t\t\t\t\t\t\t\t\t`Name: <font color=\"#4E84F2FF\">${profile != null && profile.name || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Elo: <font color=\"#4E84F2FF\">${profile != null && profile.elo || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Rank: <font color=\"#4E84F2FF\">${profile != null && profile.rank || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`W/L: <font color=\"#4E84F2FF\">${profile != null ? `${profile.wins} / ${profile.losses}` : '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Winrate: <font color=\"#4E84F2FF\">${profile != null && profile.winrate && !isNaN(profile.winrate) ? `${profile.winrate}%` : 'No wins or losses'}</font>`;\n\n\t\t\t\t\t\t\tUiToolkitAPI.ShowTextTooltip(elEntryBtn.id, text);\n\t\t\t\t\t\t});\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseout', function() {\n\t\t\t\t\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\t\t\t\t});\n\t\t\t\t\t}\n\n\t\t\t\t\t// ======================== ESEA ========================\n\t\t\t\t\tif (esea_checker)\n\t\t\t\t\t{\n\t\t\t\t\t\tconst elEntryBtn = $.CreatePanel('Panel', extras_panel, 'esea', { \n\t\t\t\t\t\t\tclass: 'player-card-commendations-icon',\n\t\t\t\t\t\t\tstyle: 'height: 22px; width: 22px; margin: 0px; margin-left: 35px; margin-right: 5px;'\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.AddClass('hidden');\n\t\t\t\t\t\telEntryBtn.visible = false;\n\t\t\t\t\t\n\t\t\t\t\t\textras_panel.MoveChildAfter(elEntryBtn, parent2);\n\t\t\t\t\t\n\t\t\t\t\t\tlet usedicon = mono_icons ? esea_icon_mono : esea_icon;\n\n\t\t\t\t\t\t$.CreatePanel('Image', elEntryBtn, 'esea', {\n\t\t\t\t\t\t\tsrc: usedicon,\n\t\t\t\t\t\t\tid: 'eseaicon'\n\t\t\t\t\t\t});\n\n\t\t\t\t\t\t_CheckEseaProfile(xuid, ((profile) => {\n\t\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\t\tif (profile && elEntryBtn) {\n\t\t\t\t\t\t\t\t\telEntryBtn.visible = true;\n\t\t\t\t\t\t\t\t\telEntryBtn.RemoveClass('hidden');\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tcatch(err) { }\n\t\t\t\t\t\t}));\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent( 'onactivate', (function ( id, type ) {\n\t\t\t\t\t\t\t$.DispatchEvent('ContextMenuEvent', '');\n\t\t\t\t\t\t\tSteamOverlayAPI.OpenURL(`https://play.esea.net/users/${eseaprofiles.find((v, i) => { return v.id == id }).user_id}`);\n\t\t\t\t\t\t}).bind( this, xuid, type ) );\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseover', () =>\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\tconst profile = eseaprofiles.find((v, i) => { return v.id == xuid });\n\n\t\t\t\t\t\t\tlet text =  ``\n\t\t\t\t\t\t\tif (profile.avatar_url)\n\t\t\t\t\t\t\t\ttext += `<img src=\"${profile != null && profile.avatar_url || ''}\"><br>`;\n\n\t\t\t\t\t\t\ttext =\t  `<b><font color=\"#67F1A2FF\">ESEA Profile</font></b><br>` +\n\t\t\t\t\t\t\t\t\t\t`Name: <font color=\"#67F1A2FF\">${profile != null && profile.name || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Karma: <font color=\"#67F1A2FF\">${profile != null && profile.karma || '0'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Real Name: <font color=\"#67F1A2FF\">${profile != null && profile.real_name || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Age: <font color=\"#67F1A2FF\">${profile != null && profile.age || '0'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Location: <font color=\"#67F1A2FF\">${profile != null && profile.location || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Joined: <font color=\"#67F1A2FF\">${profile != null && profile.joined || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Last Online: <font color=\"#67F1A2FF\">${profile != null && profile.last_online || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Banned: <font color=\"${profile != null && profile.banned == false && '#00FF00' || '#FF0000'}\">${profile != null && profile.banned || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`VIP: <font color=\"${profile != null && profile.is_vip == 0 && '#FF0000' || '#00FF00'}\">${profile != null && profile.is_vip || '#ERROR'}</font><br>`;\n\n\n\t\t\t\t\t\t\ttext +=\t `<br><b><font color=\"#67F1A2FF\">Rank:</font></b><br>`;\n\n\t\t\t\t\t\t\tif (profile.rank != \"Unranked\")\n\t\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\ttext += `Current: <font color=\"#67F1A2FF\">${profile != null && profile.rank || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`MMR: <font color=\"#67F1A2FF\">${profile != null && profile.mmr || '0'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Level: <font color=\"#67F1A2FF\">${profile != null && profile.level || '0'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Prestige: <font color=\"#67F1A2FF\">${profile != null && profile.prestige || '0'}</font><br>`;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t{\t \n\t\t\t\t\t\t\t\ttext += `Current: <font color=\"#67F1A2FF\">${profile != null && profile.rank || 'Unranked'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Placement Matches Remaining: <font color=\"#67F1A2FF\">${profile != null && profile.placement_matches_remaining || '0'}</font><br>`;\t\t\t\t\t\t   \n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\ttext +=\t `<br><b><font color=\"#67F1A2FF\">Stats:</font></b><br>`;\n\n\n\n\t\t\t\t\t\t\ttext +=\t `Highest ADR: <font color=\"#67F1A2FF\">${profile != null && profile.highest_adr_game || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Highest RWS: <font color=\"#67F1A2FF\">${profile != null && profile.highest_rws_game || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Highest Winning Map: <font color=\"#67F1A2FF\">${profile != null && profile.highest_winning_map || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Lowest Winning Map: <font color=\"#67F1A2FF\">${profile != null && profile.lowest_winning_map || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Pistol Rounds Won: <font color=\"#67F1A2FF\">${profile != null && profile.pistol_rounds_won || '#ERROR'}</font><br>` +\n\t\t\t\t\t\t\t\t\t\t`Current Win Rate: <font color=\"#67F1A2FF\">${profile != null && profile.current_win_rate || '#ERROR'}</font>`;\n\n\t\t\t\t\t\t\tUiToolkitAPI.ShowTextTooltip(elEntryBtn.id, text);\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseout', function() {\n\t\t\t\t\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\t\t\t\t});\n\t\t\t\t\t}\n\n\n\t\t\t\t\t// ======================== UNMATCHED ========================\n\t\t\t\t\tif (unmatched_checker)\n\t\t\t\t\t{\n\t\t\t\t\t\tconst elEntryBtn = $.CreatePanel('Panel', extras_panel, 'unmatched', { \n\t\t\t\t\t\t\tclass: 'player-card-commendations-icon',\n\t\t\t\t\t\t\tstyle: 'height: 22px; width: 22px; margin: 0px; margin-left: 35px; margin-right: 5px;'\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.AddClass('hidden');\n\t\t\t\t\t\telEntryBtn.visible = false;\n\n\t\t\t\t\t\textras_panel.MoveChildAfter(elEntryBtn, parent2);\n\t\t\t\t\t\n\t\t\t\t\t\tlet usedicon = mono_icons ? unmatched_icon_mono : unmatched_icon;\n\n\t\t\t\t\t\t$.CreatePanel( 'Image', elEntryBtn, 'unmatched', {\n\t\t\t\t\t\t\tsrc: usedicon,\n\t\t\t\t\t\t\tid: 'unmatchedicon'\n\t\t\t\t\t\t});\n\n\t\t\t\t\t\t_CheckUnmatchedProfile(xuid, ((profile) => {\n\t\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\t\tif (profile && elEntryBtn) {\n\t\t\t\t\t\t\t\t\telEntryBtn.visible = true;\n\t\t\t\t\t\t\t\t\telEntryBtn.RemoveClass('hidden');\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tcatch(err) { }\n\t\t\t\t\t\t}));\n\t\t\t\t\t\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseover', () =>\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\tconst profile = unmatchedprofiles.find((v, i) => { return v.id == xuid });\n\t\t\t\t\t\t\tlet text =  ``;\n\n\t\t\t\t\t\t\t// if used_cheats is empty but last_used_cheat is not, then add to used_cheats\n\t\t\t\t\t\t\tif (profile.used_cheats != undefined && profile.used_cheats.length == 0 && profile.last_used_cheat != null)\n\t\t\t\t\t\t\t\tprofile.used_cheats.push(profile.last_used_cheat);\n\n\t\t\t\t\t\t\tif (profile.used_cheats != undefined && profile.used_cheats.length > 0)\n\t\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\ttext += `Cheats Used:<br>`;\n\t\t\t\t\t\t\t\tfor (let i = 0; i < profile.used_cheats.length; i++)\n\t\t\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\t\tif (profile.used_cheats[i] == profile.last_used_cheat)\n\t\t\t\t\t\t\t\t\t\ttext += `<font color=\"#FFB625FF\">► ${profile.used_cheats[i]} <font color=\"#00FF00FF\">[LAST USED]</font></font><br>`;\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\ttext += `<font color=\"#FFB625FF\">► ${profile.used_cheats[i]}</font><br>`;\n\t\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\t\ttext += `<br>Last Inject: <font color=\"#FFB625FF\">${profile != null && profile.last_inject || '#ERROR'}</font>`;\n\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\tUiToolkitAPI.ShowTextTooltip(elEntryBtn.id, text);\n\t\t\t\t\t\t});\n\t\t\t\t\t\telEntryBtn.SetPanelEvent('onmouseout', function() {\n\t\t\t\t\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\t\t\t\t});\n\t\t\t\t\t}\n\n\n\t\t\t\t\t// ======================== TRUST ========================\n\t\t\t\t\tconst trust_btn = $.CreatePanel('Panel', extras_panel, 'trust', { \n\t\t\t\t\t\tclass: 'player-card-commendations-icon',\n\t\t\t\t\t\tstyle: 'height: 22px; width: 22px; margin: 0px; margin-left: 35px; margin-right: 5px;'\n\t\t\t\t\t});\n\t\t\t\t\ttrust_btn.AddClass('hidden');\n\t\t\t\t\ttrust_btn.visible = false;\n\n\t\t\t\t\textras_panel.MoveChildAfter(trust_btn, parent2);\n\n\t\t\t\t\t$.CreatePanel('Image', trust_btn, 'violations-' + xuid, { \n\t\t\t\t\t\tsrc: 'https://cdn.discordapp.com/attachments/1081028391869886466/1107072055934984292/green.png'\n\t\t\t\t\t});\n\n\t\t\t\t\tlet violation_data = players_detection[xuid];\n\t\t\t\t\tif (violation_data && trust_btn) {\n\t\t\t\t\t\ttrust_btn.visible = true;\n\t\t\t\t\t\ttrust_btn.RemoveClass('hidden');\n\n\t\t\t\t\t\t// return data from _GetViolationData\n\t\t\t\t\t\tlet vdata = _GetViolationData(violation_data);\n\n\t\t\t\t\t\tlet text = `Cheater Detector:\\n`;\n\n\t\t\t\t\t\t// if over 50 violations, make it red, 10-50 yellow, 0-10 green\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.high_flick == 3 ? '#FF0000' : vdata.high_flick == 2 ? '#FFFF00' : '#00FF00'}\">High Flicks: ${violation_data.high_flick_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.jitter_anti_aim == 3 ? '#FF0000' : vdata.jitter_anti_aim == 2 ? '#FFFF00' : '#00FF00'}\">Jitter Anti-Aim: ${violation_data.jitter_anti_aim_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.fake_lag == 3 ? '#FF0000' : vdata.fake_lag == 2 ? '#FFFF00' : '#00FF00'}\">Fake Lag: ${violation_data.fake_lag_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.aimbot == 3 ? '#FF0000' : vdata.aimbot == 2 ? '#FFFF00' : '#00FF00'}\">Aimbot: ${violation_data.aimbot_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.silent_aimbot == 3 ? '#FF0000' : vdata.silent_aimbot == 2 ? '#FFFF00' : '#00FF00'}\">Silent Aimbot: ${violation_data.silent_aimbot_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.bhop == 3 ? '#FF0000' : vdata.bhop == 2 ? '#FFFF00' : '#00FF00'}\">Bhop: ${violation_data.bhop_violations}</font><br>`;\n\t\t\t\t\t\ttext += `► <font color=\"${vdata.desync == 3 ? '#FF0000' : vdata.desync == 2 ? '#FFFF00' : '#00FF00'}\">Desync: ${violation_data.desync_violations}</font>`; \n\n\n\t\t\t\t\t\tif (vdata.cheat != \"unknown\")\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\tlet cheatUppercase = vdata.cheat.charAt(0).toUpperCase() + vdata.cheat.slice(1);\n\t\t\t\t\t\t\ttext += `\\n► <font color=\"#FF0000\">Cheat: ${cheatUppercase}</font>`;\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\t// set the image based on the violation level\n\t\t\t\t\t\tif (vdata.violation_level == 3)\t  trust_btn.FindChildTraverse('violations-' + xuid).SetImage(`https://cdn.discordapp.com/attachments/1081028391869886466/1107072056186638446/red.png`);\n\t\t\t\t\t\telse if (vdata.violation_level == 2) trust_btn.FindChildTraverse('violations-' + xuid).SetImage(`https://cdn.discordapp.com/attachments/1081028391869886466/1107072056438292551/yellow.png`);\n\t\t\t\t\t\telse if (vdata.violation_level == 1) trust_btn.FindChildTraverse('violations-' + xuid).SetImage(`https://cdn.discordapp.com/attachments/1081028391869886466/1107072055934984292/green.png`);\n\t\t\t\t\t\t\n\t\t\t\t\t\ttrust_btn.SetPanelEvent('onmouseover', function() {  UiToolkitAPI.ShowTextTooltip(trust_btn.id, text); });\n\t\t\t\t\t\ttrust_btn.SetPanelEvent('onmouseout', function() { UiToolkitAPI.HideTextTooltip(); });\n\t\t\t\t\t}\n\t\t\t\t});\n\n\t\t\t\treturn panel;\n\t\t\t}\n\t\t}\n\n\t\tfunction _HookEverything() {\n\t\t\t$.CreatePanel = (function (...args) {\n\t\t\t\tconst res = _CreatePanel_Hook(...args);\n\t\t\t\tif (res != undefined)\n\t\t\t\t\treturn res;\n\t\t\t\t\n\t\t\t\treturn CreatePanel_orig.call(this, ...args);\n\t\t\t});\n\t\t}\n\t\n\t\tfunction _UnhookEverything() { $.CreatePanel = CreatePanel_orig; }\n\t\tfunction _EnableHiddenMode(enabled) { hidden_mode = enabled; }\n\t\tfunction _UpdateValues(steamid, player_detection_data) { players_detection[steamid] = player_detection_data; }\n\t\tfunction _GetUserSteamID64(player_index) { return GameStateAPI.GetPlayerXuidStringFromEntIndex(player_index); }\n\t\tfunction _EnableFaceITChecker(enabled) { faceit_checker = enabled; }\n\t\tfunction _EnableEsportalChecker(enabled) { esportal_checker = enabled; }\n\t\tfunction _EnableESEAChecker(enabled) { esea_checker = enabled; }\n\t\tfunction _EnableUnmatchedChecker(enabled) { unmatched_checker = enabled; }\n\t\tfunction _EnableMonoIcons(enabled) { mono_icons = enabled; }\n\n\t\tfunction _GetViolationData(violation_data) {\n\t\t\tif (!violation_data)\n\t\t\t\treturn;\n\n\t\t\t// get violation level\n\t\t\tlet high_flick = violation_data.high_flick_violations >= violation_level_limit.high_flick[3] ? 3 : violation_data.high_flick_violations >= violation_level_limit.high_flick[2] ? 2 : violation_data.high_flick_violations >= violation_level_limit.high_flick[1] ? 1 : 0;\n\t\t\tlet jitter_anti_aim = violation_data.jitter_anti_aim_violations >= violation_level_limit.jitter_anti_aim[3] ? 3 : violation_data.jitter_anti_aim_violations >= violation_level_limit.jitter_anti_aim[2] ? 2 : violation_data.jitter_anti_aim_violations >= violation_level_limit.jitter_anti_aim[1] ? 1 : 0;\n\t\t\tlet fake_lag = violation_data.fake_lag_violations >= violation_level_limit.fake_lag[3] ? 3 : violation_data.fake_lag_violations >= violation_level_limit.fake_lag[2] ? 2 : violation_data.fake_lag_violations >= violation_level_limit.fake_lag[1] ? 1 : 0;\n\t\t\tlet aimbot = violation_data.aimbot_violations >= violation_level_limit.aimbot[3] ? 3 : violation_data.aimbot_violations >= violation_level_limit.aimbot[2] ? 2 : violation_data.aimbot_violations >= violation_level_limit.aimbot[1] ? 1 : 0;\n\t\t\tlet silent_aimbot = violation_data.silent_aimbot_violations >= violation_level_limit.silent_aimbot[3] ? 3 : violation_data.silent_aimbot_violations >= violation_level_limit.silent_aimbot[2] ? 2 : violation_data.silent_aimbot_violations >= violation_level_limit.silent_aimbot[1] ? 1 : 0;\n\t\t\tlet bhop = violation_data.bhop_violations >= violation_level_limit.bhop[3] ? 3 : violation_data.bhop_violations >= violation_level_limit.bhop[2] ? 2 : violation_data.bhop_violations >= violation_level_limit.bhop[1] ? 1 : 0;\n\t\t\tlet desync = violation_data.desync_violations >= violation_level_limit.desync[3] ? 3 : violation_data.desync_violations >= violation_level_limit.desync[2] ? 2 : violation_data.desync_violations >= violation_level_limit.desync[1] ? 1 : 0;\n\n\t\t\tlet violation_level = \n\t\t\t\t\t\thigh_flick == 3 || jitter_anti_aim == 3 || fake_lag == 3 || aimbot == 3 || silent_aimbot == 3 || bhop == 3 || desync == 3 || violation_data.cheat != \"unknown\" ? 3 :\n\t\t\t\t\t\thigh_flick == 2 || jitter_anti_aim == 2 || fake_lag == 2 || aimbot == 2 || silent_aimbot == 2 || bhop == 2 || desync == 2 || violation_data.cheat != \"unknown\" ? 2 :\n\t\t\t\t\t\thigh_flick == 1 || jitter_anti_aim == 1 || fake_lag == 1 || aimbot == 1 || silent_aimbot == 1 || bhop == 1 || desync == 1 || violation_data.cheat != \"unknown\" ? 1 : 0;\n\n\t\t\treturn {\n\t\t\t\tviolation_level: violation_level,\n\t\t\t\thigh_flick: high_flick,\n\t\t\t\tjitter_anti_aim: jitter_anti_aim,\n\t\t\t\tfake_lag: fake_lag,\n\t\t\t\taimbot: aimbot,\n\t\t\t\tsilent_aimbot: silent_aimbot,\n\t\t\t\tbhop: bhop,\n\t\t\t\tdesync: desync,\n\t\t\t\tcheat: violation_data.cheat\n\t\t\t};\n\t\t}\n\n\t\tfunction _PullUnmatchedDetection(steamids) {\n\t\t\tlet local_steamid = MyPersonaAPI.GetXuid();\n\t\t\t\n\t\t\t$.AsyncWebRequest(`https://api.cheat.show/v2/partners/detector/pull`, {\n\t\t\t\ttype: 'POST',\n\t\t\t\ttimeout: 5000,\n\t\t\t\tdata: {payload: JSON.stringify({\n\t\t\t\t\txuid: local_steamid,\n\t\t\t\t\txuids: steamids\n\t\t\t\t})},\n\t\t\t\theaders: {\n\t\t\t\t\t\"X-Api-Key\" : \"7d35b6dd-b3db-437b-af24-c8a37f56616f\"\n\t\t\t\t},\n\t\t\t\tsuccess: ((data) => {\n\t\t\t\t\tif (!data || !data.status || !data.xuids)\n\t\t\t\t\t\treturn;\n\n\t\t\t\t\tfor (const xuid in data.xuids) {\n\t\t\t\t\t\tlet player_response = data.xuids[xuid];\n\t\t\t\t\t\tlet cheat = FindUnmatchedCheatByID(player_response.lastSoftware);\n\t\t\t\t\t\tlet player_data = {\n\t\t\t\t\t\t\tcheat: cheat,\n\t\t\t\t\t\t\tsteamid: xuid\n\t\t\t\t\t\t};\n\t\t\t\t\t\tunmatched_detections.push(player_data);\n\t\t\t\t\t}\n\t\t\t\t})\n\t\t\t});\n\n\t\t\treturn false;\n\t\t}\n\n\t\tfunction _GetUnmatchedDetection(steamid) {\n\t\t\treturn unmatched_detections.find((v, i) => { return v.steamid == steamid });\n\t\t}\n\t\n\t\treturn {\n\t\t\tHookEverything: _HookEverything,\n\t\t\tUnhookEverything: _UnhookEverything,\n\t\t\tEnableHiddenMode: _EnableHiddenMode,\n\t\t\tUpdateValues: _UpdateValues,\n\t\t\tGetUserSteamID64: _GetUserSteamID64,\n\t\t\tEnableFaceITChecker: _EnableFaceITChecker,\n\t\t\tEnableEsportalChecker: _EnableEsportalChecker,\n\t\t\tEnableESEAChecker: _EnableESEAChecker,\n\t\t\tEnableUnmatchedChecker: _EnableUnmatchedChecker,\n\t\t\tEnableMonoIcons: _EnableMonoIcons,\n\t\t\tGetViolationData: _GetViolationData,\n\t\t\tPullUnmatchedDetection: _PullUnmatchedDetection,\n\t\t\tGetUnmatchedDetection: _GetUnmatchedDetection,\n\t\t};\n\t})();\n", "MainMenu")()

client.set_event_callback("shutdown", function()
	var_0_75.UnhookEverything()
end)

local var_0_76 = 0

function Log(arg_10_0)
	if not arg_10_0 or ui.get(var_0_42) then
		return
	end

	if ui.get(var_0_38) and not arg_10_0:find("{log_only_on_trust_level_change}") and not arg_10_0:find("{info}") then
		return
	end

	arg_10_0 = arg_10_0:gsub("{log_only_on_trust_level_change}", "")
	arg_10_0 = arg_10_0:gsub("{info}", "")

	local var_10_0 = ui.get(var_0_33)

	for iter_10_0 = 1, #var_10_0 do
		local var_10_1 = var_10_0[iter_10_0]

		if var_10_1 == "☰ Console" then
			client.color_log(255, 0, 0, " [ Cheater Detector ]")
			client.color_log(255, 180, 255, "   ► " .. arg_10_0 .. "\n")
		elseif var_10_1 == "✉ Chat" then
			if globals.curtime() - var_0_76 > 0.5 then
				client.exec("say " .. arg_10_0)

				var_0_76 = globals.curtime()
			end
		elseif var_10_1 == "✉ Local Chat" then
			var_0_13.print("{red}[ Cheater Detector ]  ► {white}" .. arg_10_0)
		end
	end
end

function get_all_players()
	local var_11_0 = var_0_7(false)
	local var_11_1 = {}

	for iter_11_0 = 1, #var_11_0 do
		local var_11_2 = var_11_0[iter_11_0]
		local var_11_3 = var_0_75.GetUserSteamID64(var_11_2)

		if var_11_3 == 0 then
			-- block empty
		else
			local var_11_4 = var_0_9(var_11_2)
			local var_11_5, var_11_6, var_11_7 = var_0_12(var_11_2)
			local var_11_8, var_11_9 = var_0_8(var_11_2, "m_vecVelocity")
			local var_11_10, var_11_11, var_11_12 = var_0_10(var_11_2, 0)
			local var_11_13, var_11_14, var_11_15 = var_0_8(var_11_2, "m_angEyeAngles")
			local var_11_16 = var_0_8(var_11_2, "m_flDuckAmount")
			local var_11_17 = entity.is_dormant(var_11_2)
			local var_11_18 = 0
			local var_11_19 = 0
			local var_11_20 = 0
			local var_11_21 = var_0_8(var_11_2, "m_iTeamNum")
			local var_11_22 = var_0_8(var_11_2, "m_fFlags") == 257
			local var_11_23 = var_0_8(entity.get_player_resource(), "m_iPing", var_11_2)
			local var_11_24 = globals.tickcount()
			local var_11_25 = "unknown"

			if var_11_25 == "unknown" then
				local var_11_26 = var_0_75.GetUnmatchedDetection(var_11_3)

				if var_11_26 then
					var_11_25 = var_11_26.cheat
				end
			end

			var_11_1[iter_11_0] = {
				ent_id = iter_11_0,
				steamid = var_11_3,
				name = var_11_4,
				x = var_11_5,
				y = var_11_6,
				z = var_11_7,
				vel_x = var_11_8,
				vel_y = var_11_9,
				head_x = var_11_10,
				head_y = var_11_11,
				head_z = var_11_12,
				pitch = var_11_13,
				yaw = var_11_14,
				roll = var_11_15,
				duck_amount = var_11_16,
				is_dormant = var_11_17,
				is_shooting = var_11_18,
				damaged_player = var_11_19,
				killer_player = var_11_20,
				team = var_11_21,
				is_grounded = var_11_22,
				ping = var_11_23,
				tick = var_11_24,
				cheat = var_11_25
			}
		end
	end

	return var_11_1
end

function Detect()
	for iter_12_0, iter_12_1 in pairs(var_0_17) do
		if iter_12_0 == 0 or iter_12_0 == nil then
			-- block empty
		else
			local var_12_0 = var_0_17[iter_12_0]

			if var_12_0[1] == nil then
				-- block empty
			else
				if var_0_18[iter_12_0] == nil then
					var_0_18[iter_12_0] = {
						cheat = "unknown",
						desync_violations = 0,
						bhop_violations = 0,
						silent_aimbot_violations = 0,
						aimbot_violations = 0,
						fake_lag_violations = 0,
						jitter_anti_aim_violations = 0,
						high_flick_violations = 0,
						violation_level = 0,
						name = var_12_0[1].name
					}
				end

				local var_12_1 = var_0_75.GetViolationData(var_0_18[iter_12_0]).violation_level

				if var_0_73 then
					var_0_18[iter_12_0].cheat = var_12_0[1].cheat
				end

				if ui.get(var_0_35) and iter_12_0 == var_0_27 then
					-- block empty
				else
					if ui.get(var_0_36) then
						local var_12_2 = var_0_17[var_0_27][1]
						local var_12_3 = var_12_0[1]

						if var_12_2 and var_12_3 and var_12_2.team == var_12_3.team and var_12_3.steamid ~= var_0_27 then
							goto label_12_0
						end
					end

					for iter_12_2 = 1, #var_12_0 do
						local var_12_4 = var_12_0[iter_12_2]
						local var_12_5 = var_12_0[iter_12_2 - 1]
						local var_12_6 = var_12_0[iter_12_2 + 1]
						local var_12_7 = false

						if not var_12_5 or not var_12_6 then
							-- block empty
						else
							if ui.get(var_0_37) and not ui.get(var_0_42) then
								local var_12_8 = var_12_4.x
								local var_12_9 = var_12_4.y
								local var_12_10 = var_12_4.z
								local var_12_11 = var_12_5.x
								local var_12_12 = var_12_5.y
								local var_12_13 = var_12_5.z
								local var_12_14 = 0 + iter_12_2 * (255 / ui.get(var_0_56))
								local var_12_15 = 255
								local var_12_16 = 255
								local var_12_17 = 255

								if iter_12_2 <= 5 and iter_12_2 < ui.get(var_0_56) - 5 then
									var_12_15, var_12_16, var_12_17 = 255, 0, 0
									var_12_14 = 255
								end

								local var_12_18, var_12_19 = renderer.world_to_screen(var_12_8, var_12_9, var_12_10 + 32.5)
								local var_12_20, var_12_21 = renderer.world_to_screen(var_12_11, var_12_12, var_12_13 + 32.5)

								renderer.line(var_12_18, var_12_19, var_12_20, var_12_21, var_12_15, var_12_16, var_12_17, var_12_14)
							end

							if var_0_68 or var_0_67 then
								local var_12_22 = var_12_4.yaw - var_12_5.yaw
								local var_12_23 = var_12_4.pitch - var_12_5.pitch

								if math.abs(var_12_22) > ui.get(var_0_57) and var_12_22 < 180 and var_12_22 > -180 or math.abs(var_12_23) > ui.get(var_0_57) and var_12_23 < 90 and var_12_23 > -90 then
									if var_0_67 then
										var_0_18[iter_12_0].high_flick_violations = var_0_18[iter_12_0].high_flick_violations + 1

										if ui.get(var_0_34) then
											Log("High Flick violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | YAW CHANGE: " .. var_12_22 .. " | PITCH CHANGE: " .. var_12_23 or ""))
										end

										var_12_7 = true

										client.fire_event("player_violation", {
											iter_12_0,
											"High Flick",
											{
												var_12_22,
												var_12_23
											}
										})
									end
								elseif var_0_68 then
									local var_12_24 = 0
									local var_12_25 = 0

									for iter_12_3 = 1, #var_12_0 do
										local var_12_26 = var_12_0[iter_12_3]
										local var_12_27 = var_12_0[iter_12_3 + 1]

										if not var_12_26 or not var_12_27 then
											-- block empty
										else
											local var_12_28 = math.abs(var_12_26.yaw - var_12_27.yaw)
											local var_12_29 = math.abs(var_12_26.pitch - var_12_27.pitch)

											if var_12_22 == var_12_28 and var_12_22 > 0.9 then
												var_12_24 = var_12_24 + 1
											end

											if var_12_23 == var_12_29 and var_12_23 > 0.9 then
												var_12_25 = var_12_25 + 1
											end
										end
									end

									if var_12_24 > 5 or var_12_25 > 5 then
										var_0_18[iter_12_0].jitter_anti_aim_violations = var_0_18[iter_12_0].jitter_anti_aim_violations + 1

										if ui.get(var_0_34) then
											Log("Jitter Anti-Aim violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | YAW CHANGE: " .. var_12_22 .. " | PITCH CHANGE: " .. var_12_23 or ""))
										end

										var_12_7 = true

										client.fire_event("player_violation", {
											iter_12_0,
											"Jitter Anti-Aim",
											{
												var_12_22,
												var_12_23
											}
										})
									end
								end
							end

							if var_0_69 then
								local var_12_30 = math.sqrt((var_12_4.x - var_12_5.x)^2 + (var_12_4.y - var_12_5.y)^2) - math.abs(var_12_4.ping / ui.get(var_0_65))

								if var_12_30 > ui.get(var_0_58) then
									var_0_18[iter_12_0].fake_lag_violations = var_0_18[iter_12_0].fake_lag_violations + 1

									if ui.get(var_0_34) then
										Log("Fake-lag violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | Moved: " .. var_12_30 .. "m" or ""))
									end

									var_12_7 = true

									client.fire_event("player_violation", {
										iter_12_0,
										"Fake Lag",
										{
											var_12_30
										}
									})
								end
							end

							if var_0_70 and (var_12_5.is_shooting == 1 or var_12_4.is_shooting == 1 or var_12_6.is_shooting == 1) and (var_12_5.damaged_player ~= 0 or var_12_4.damaged_player ~= 0 or var_12_6.damaged_player ~= 0) then
								local var_12_31 = math.sqrt((math.abs(var_12_5.yaw) - math.abs(var_12_6.yaw))^2 + (math.abs(var_12_5.pitch) - math.abs(var_12_6.pitch))^2)
								local var_12_32 = math.sqrt((math.abs(var_12_5.yaw) - math.abs(var_12_4.yaw))^2 + (math.abs(var_12_5.pitch) - math.abs(var_12_4.pitch))^2)

								if var_12_31 < ui.get(var_0_60) and var_12_32 - 1 > ui.get(var_0_60) then
									var_0_18[iter_12_0].silent_aimbot_violations = var_0_18[iter_12_0].silent_aimbot_violations + 1

									if ui.get(var_0_34) then
										Log("Silent-Aimbot violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | Pre-Tick Distance: " .. var_12_31 .. " | Forward-Tick Distance: " .. var_12_32 or ""))
									end

									var_12_7 = true

									client.fire_event("player_violation", {
										iter_12_0,
										"Silent Aimbot",
										{
											var_12_31,
											var_12_32
										}
									})
								end

								if var_12_32 > ui.get(var_0_59) then
									var_0_18[iter_12_0].aimbot_violations = var_0_18[iter_12_0].aimbot_violations + 1

									if ui.get(var_0_34) then
										Log("Aimbot violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | Pre-Tick Distance: " .. var_12_31 .. " | Forward-Tick Distance: " .. var_12_32 or ""))
									end

									var_12_7 = true

									client.fire_event("player_violation", {
										iter_12_0,
										"Aimbot",
										{
											var_12_31,
											var_12_32
										}
									})
								end
							end

							if var_0_72 and not var_12_5.is_grounded and var_12_4.is_grounded and not var_12_6.is_grounded then
								local var_12_33 = math.sqrt((var_12_4.x - var_12_6.x)^2 + (var_12_4.y - var_12_6.y)^2)
								local var_12_34 = math.abs(var_12_33 - var_12_4.ping / ui.get(var_0_65))

								if iter_12_0 == var_0_27 and var_12_34 > ui.get(var_0_61) and var_12_34 < ui.get(var_0_63) or iter_12_0 ~= var_0_27 and var_12_34 > ui.get(var_0_62) and var_12_34 < ui.get(var_0_63) then
									var_0_18[iter_12_0].bhop_violations = var_0_18[iter_12_0].bhop_violations + 1

									if ui.get(var_0_34) then
										Log("Bhop violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | Speed: " .. var_12_34 or ""))
									end

									var_12_7 = true

									client.fire_event("player_violation", {
										iter_12_0,
										"Bhop",
										{
											var_12_34
										}
									})
								end
							end

							if var_0_74 and math.abs(var_12_4.vel_x) < 1 and math.abs(var_12_4.vel_y) < 1 and math.abs(var_12_4.vel_x) > 0 and math.abs(var_12_4.vel_y) > 0 and iter_12_0 == var_0_27 then
								local var_12_35 = 0

								for iter_12_4 = 1, #var_12_0 do
									local var_12_36 = var_12_0[iter_12_4]
									local var_12_37 = var_12_0[iter_12_4 + 1]

									if not var_12_36 or not var_12_37 then
										-- block empty
									else
										local var_12_38 = math.abs(var_12_36.x - var_12_37.x)
										local var_12_39 = math.abs(var_12_36.y - var_12_37.y)

										if var_12_38 < 1 and var_12_39 < 1 then
											var_12_35 = var_12_35 + 1
										end
									end
								end

								if var_12_35 > 2 then
									var_0_18[iter_12_0].desync_violations = var_0_18[iter_12_0].desync_violations + 1

									if ui.get(var_0_34) then
										Log("Desync violation" .. (ui.get(var_0_40) and ": " .. var_12_4.name .. " | Velocity: " .. var_12_4.vel_x .. " " .. var_12_4.vel_y or ""))
									end

									var_12_7 = true

									client.fire_event("player_violation", {
										iter_12_0,
										"Desync",
										{
											var_12_4.vel_x,
											var_12_4.vel_y
										}
									})
								end
							end

							if var_12_7 then
								var_0_17[iter_12_0] = {}
							end
						end
					end

					local var_12_40 = var_0_75.GetViolationData(var_0_18[iter_12_0]).violation_level

					if var_12_40 > (var_0_18[iter_12_0].violation_level or 0) and var_12_40 ~= 0 and var_12_40 ~= 1 then
						var_0_18[iter_12_0].violation_level = var_12_40

						local var_12_41 = var_12_40 == 3 and "cheating" or var_12_40 == 2 and "suspicious" or var_12_40 == 1 and "legit" or ""

						Log(var_0_18[iter_12_0].name .. " is " .. var_12_41 .. "{log_only_on_trust_level_change}")

						if ui.get(var_0_39) then
							client.exec("playvol " .. var_12_41 .. ".wav 0.5")
						end

						client.fire_event("player_trustlevel", {
							iter_12_0,
							var_12_40
						})
					end
				end
			end
		end

		::label_12_0::
	end
end

function loop()
	var_0_16 = get_all_players()

	for iter_13_0, iter_13_1 in pairs(var_0_17) do
		local var_13_0 = false

		for iter_13_2 = 1, #var_0_16 do
			if var_0_16[iter_13_2].steamid == iter_13_0 then
				var_13_0 = true

				break
			end
		end

		if not var_13_0 then
			var_0_17[iter_13_0] = {}
		end
	end

	for iter_13_3 = 1, #var_0_16 do
		local var_13_1 = var_0_16[iter_13_3]
		local var_13_2 = var_13_1.steamid

		if var_13_2 == nil then
			-- block empty
		else
			if not var_0_17[var_13_2] and var_0_17 ~= nil then
				var_0_17[var_13_2] = {}
			end

			local var_13_3 = var_0_17[var_13_2][#var_0_17[var_13_2]]

			if var_13_3 and var_13_3.yaw == var_13_1.yaw and var_13_3.pitch == var_13_1.pitch and var_13_3.x == var_13_1.x and var_13_3.y == var_13_1.y and var_13_3.z == var_13_1.z then
				-- block empty
			else
				table.insert(var_0_17[var_13_2], var_13_1)
			end

			while #var_0_17[var_13_2] > ui.get(var_0_56) do
				table.remove(var_0_17[var_13_2], 1)
			end

			if not var_0_18[var_13_2] then
				var_0_18[var_13_2] = {}
				var_0_18[var_13_2].name = var_13_1.name
				var_0_18[var_13_2].high_flick_violations = 0
				var_0_18[var_13_2].jitter_anti_aim_violations = 0
				var_0_18[var_13_2].fake_lag_violations = 0
				var_0_18[var_13_2].silent_aimbot_violations = 0
				var_0_18[var_13_2].aimbot_violations = 0
				var_0_18[var_13_2].bhop_violations = 0
				var_0_18[var_13_2].desync_violations = 0
				var_0_18[var_13_2].cheat = "unknown"
			end
		end
	end

	client.delay_call(0.01, loop)
end

client.delay_call(1, loop)

function UpdateUI()
	local var_14_0 = ui.get(var_0_31) and ui.get(var_0_30)
	local var_14_1 = ui.get(var_0_53) and ui.get(var_0_30)
	local var_14_2 = ui.get(var_0_44) and ui.get(var_0_30)

	ui.set_visible(var_0_32, var_14_0)
	ui.set_visible(var_0_33, var_14_0)
	ui.set_visible(var_0_34, var_14_0)
	ui.set_visible(var_0_35, var_14_0)
	ui.set_visible(var_0_36, var_14_0)
	ui.set_visible(var_0_37, var_14_0)
	ui.set_visible(var_0_38, var_14_0)
	ui.set_visible(var_0_39, var_14_0)
	ui.set_visible(var_0_40, var_14_0)
	ui.set_visible(var_0_41, var_14_0)
	ui.set_visible(var_0_42, var_14_0)
	ui.set_visible(var_0_43, var_14_0)
	ui.set_visible(var_0_45, var_14_2)
	ui.set_visible(var_0_46, var_14_2)
	ui.set_visible(var_0_47, var_14_2)
	ui.set_visible(var_0_48, var_14_2)
	ui.set_visible(var_0_49, var_14_2)
	ui.set_visible(var_0_50, var_14_2)
	ui.set_visible(var_0_51, var_14_2)
	ui.set_visible(var_0_52, var_14_2)
	ui.set_visible(var_0_54, var_14_1)
	ui.set_visible(var_0_55, var_14_1)
	ui.set_visible(var_0_56, var_14_1)
	ui.set_visible(var_0_57, var_14_1)
	ui.set_visible(var_0_58, var_14_1)
	ui.set_visible(var_0_59, var_14_1)
	ui.set_visible(var_0_60, var_14_1)
	ui.set_visible(var_0_61, var_14_1)
	ui.set_visible(var_0_62, var_14_1)
	ui.set_visible(var_0_63, var_14_1)
	ui.set_visible(var_0_64, var_14_1)
	ui.set_visible(var_0_65, var_14_1)
	ui.set_visible(var_0_66, var_14_1)
end

client.set_event_callback("paint_ui", function()
	if ui.get(var_0_30) and var_0_26 and globals.mapname() ~= nil then
		Detect()
	end

	UpdateUI()
	var_0_75.EnableFaceITChecker(false)
	var_0_75.EnableEsportalChecker(false)
	var_0_75.EnableESEAChecker(false)
	var_0_75.EnableUnmatchedChecker(false)
	var_0_75.EnableHiddenMode(ui.get(var_0_42))

	if ui.get(var_0_29) == "Multicolored" then
		var_0_75.EnableMonoIcons(false)
	elseif ui.get(var_0_29) == "Monochrome" then
		var_0_75.EnableMonoIcons(true)
	end

	local var_15_0 = ui.get(var_0_28)

	for iter_15_0 = 1, #var_15_0 do
		local var_15_1 = var_15_0[iter_15_0]

		if var_15_1 == "\aFF5500FFFaceIT Checker" then
			var_0_75.EnableFaceITChecker(true)
		elseif var_15_1 == "\a4E84F2FFEsportal Checker" then
			var_0_75.EnableEsportalChecker(true)
		elseif var_15_1 == "\a67F1A2FFESEA Checker" then
			var_0_75.EnableESEAChecker(true)
		elseif var_15_1 == "\aFFB625FFUnmatched Checker" then
			var_0_75.EnableUnmatchedChecker(true)
		end
	end

	ui.set_visible(var_0_31, ui.get(var_0_30))
	ui.set_visible(var_0_44, ui.get(var_0_30))
	ui.set_visible(var_0_53, ui.get(var_0_30))

	for iter_15_1, iter_15_2 in pairs(var_0_18) do
		var_0_75.UpdateValues(iter_15_1, iter_15_2)
	end

	local var_15_2 = {}

	for iter_15_3, iter_15_4 in pairs(var_0_18) do
		table.insert(var_15_2, iter_15_4.name)
	end

	ui.update(var_0_46, var_15_2)

	if var_0_19 then
		local var_15_3, var_15_4 = client.screen_size()
		local var_15_5 = "Killed by: " .. var_0_20[1].name
		local var_15_6 = math.sqrt((var_0_21[1] - var_0_20[1].x)^2 + (var_0_21[2] - var_0_20[1].y)^2)
		local var_15_7 = math.floor(var_15_6 / 39.37)
		local var_15_8 = "Distance: " .. var_15_7 .. "m (" .. math.floor(var_15_6) .. " units)"

		renderer.text(var_15_3 / 2, var_15_4 / 2 + 25, 255, 255, 255, 255, "c+", 0, var_15_5)
		renderer.text(var_15_3 / 2, var_15_4 / 2 + 50, 255, 255, 255, 255, "c+", 0, var_15_8)

		local var_15_9, var_15_10 = renderer.world_to_screen(var_0_21[1], var_0_21[2], var_0_21[3])
		local var_15_11 = 1 / (var_15_6 / 1000)
		local var_15_12 = 20 * var_15_11
		local var_15_13 = 100 * var_15_11
		local var_15_14 = {
			255,
			255,
			255,
			100
		}

		if var_0_24 then
			var_15_14 = {
				255,
				0,
				0,
				100
			}
		end

		renderer.rectangle(var_15_9 - var_15_12 / 2, var_15_10 - var_15_13 / 2, var_15_12, var_15_13, var_15_14[1], var_15_14[2], var_15_14[3], var_15_14[4])
	end

	if var_0_19 and var_0_24 then
		local var_15_15, var_15_16 = client.screen_size()

		renderer.text(var_15_15 / 2, var_15_16 / 2 - 25, 255, 0, 0, 255, "c+", 0, "Killed")
	end
end)
ui.set_callback(var_0_47, function()
	local var_16_0
	local var_16_1 = 0

	for iter_16_0, iter_16_1 in pairs(var_0_18) do
		if var_16_1 == ui.get(var_0_46) then
			var_16_0 = iter_16_0
		end

		var_16_1 = var_16_1 + 1
	end

	local var_16_2 = var_0_18[var_16_0]

	if var_16_2 then
		local var_16_3 = var_0_75.GetViolationData(var_16_2)
		local var_16_4 = ("Name: " .. var_16_2.name) .. " | Trust Level: " .. (var_16_3.violation_level == 3 and "Cheating" or var_16_3.violation_level == 2 and "Suspicious" or var_16_3.violation_level == 1 and "Legit" or "Unknown")

		if ui.get(var_0_40) then
			var_16_4 = var_16_4 .. " | High Flicks: " .. var_16_2.high_flick_violations
			var_16_4 = var_16_4 .. " | Jitter Anti-Aim: " .. var_16_2.jitter_anti_aim_violations
			var_16_4 = var_16_4 .. " | Fake-Lag: " .. var_16_2.fake_lag_violations
			var_16_4 = var_16_4 .. " | Aimbot: " .. var_16_2.aimbot_violations
			var_16_4 = var_16_4 .. " | Silent-Aimbot: " .. var_16_2.silent_aimbot_violations
			var_16_4 = var_16_4 .. " | Bhop: " .. var_16_2.bhop_violations
			var_16_4 = var_16_4 .. " | Desync: " .. var_16_2.desync_violations

			if var_16_2.cheat ~= "unknown" then
				var_16_4 = var_16_4 .. " | Cheat: " .. var_16_2.cheat:gsub("^%l", string.upper)
			end
		end

		Log(var_16_4 .. "{info}")
	end
end)
ui.set_callback(var_0_48, function()
	local var_17_0 = 0

	for iter_17_0, iter_17_1 in pairs(var_0_18) do
		client.delay_call(var_17_0, function()
			local var_18_0 = var_0_75.GetViolationData(iter_17_1)
			local var_18_1 = ("Name: " .. iter_17_1.name) .. " | Trust Level: " .. (var_18_0.violation_level == 3 and "Cheating" or var_18_0.violation_level == 2 and "Suspicious" or var_18_0.violation_level == 1 and "Legit" or "Unknown")

			if ui.get(var_0_40) then
				var_18_1 = var_18_1 .. " | High Flicks: " .. iter_17_1.high_flick_violations
				var_18_1 = var_18_1 .. " | Jitter Anti-Aim: " .. iter_17_1.jitter_anti_aim_violations
				var_18_1 = var_18_1 .. " | Fake-Lag: " .. iter_17_1.fake_lag_violations
				var_18_1 = var_18_1 .. " | Aimbot: " .. iter_17_1.aimbot_violations
				var_18_1 = var_18_1 .. " | Silent-Aimbot: " .. iter_17_1.silent_aimbot_violations
				var_18_1 = var_18_1 .. " | Bhop: " .. iter_17_1.bhop_violations
				var_18_1 = var_18_1 .. " | Desync: " .. iter_17_1.desync_violations

				if iter_17_1.cheat ~= "unknown" then
					var_18_1 = var_18_1 .. " | Cheat: " .. iter_17_1.cheat:gsub("^%l", string.upper)
				end
			end

			Log(var_18_1 .. "{info}")
		end)

		local var_17_1 = ui.get(var_0_33)

		for iter_17_2 = 1, #var_17_1 do
			if var_17_1[iter_17_2] == "Chat" then
				var_17_0 = var_17_0 + 0.7
			end
		end
	end
end)
var_0_75.HookEverything()
client.set_event_callback("player_death", function(arg_19_0)
	local var_19_0 = var_0_75.GetUserSteamID64(client.userid_to_entindex(arg_19_0.userid))
	local var_19_1 = var_0_75.GetUserSteamID64(client.userid_to_entindex(arg_19_0.attacker))

	if var_19_0 == var_0_27 then
		var_0_25 = globals.tickcount()

		if var_0_17[var_19_1] then
			local var_19_2 = #var_0_17[var_19_1]

			if var_0_17[var_19_1][var_19_2] then
				var_0_20 = var_0_17[var_19_1]
				var_0_21 = {
					var_0_17[var_19_1][var_19_2].x,
					var_0_17[var_19_1][var_19_2].y,
					var_0_17[var_19_1][var_19_2].z
				}
				var_0_22 = {
					var_0_17[var_19_1][var_19_2].pitch,
					var_0_17[var_19_1][var_19_2].yaw,
					var_0_17[var_19_1][var_19_2].roll
				}

				if ui.get(var_0_51) and not ui.get(var_0_42) then
					client.delay_call(3.5, function()
						var_0_19 = true
					end)
				end
			end
		end
	end

	if var_19_0 == 0 then
		return
	end

	if var_0_17[var_19_0] ~= nil then
		var_0_17[var_19_0] = {}
	end
end)
client.set_event_callback("round_end", function()
	client.delay_call(5, function()
		var_0_17 = {}
		var_0_26 = false
	end)
end)
client.set_event_callback("round_start", function()
	var_0_17 = {}
	var_0_26 = false

	client.delay_call(5, function()
		var_0_17 = {}
		var_0_26 = true
	end)
end)
client.set_event_callback("weapon_fire", function(arg_25_0)
	local var_25_0 = var_0_75.GetUserSteamID64(client.userid_to_entindex(arg_25_0.userid))

	if var_25_0 == 0 then
		return
	end

	pcall(function()
		if var_0_17[var_25_0][#var_0_17[var_25_0]] then
			var_0_17[var_25_0][#var_0_17[var_25_0]].is_shooting = 1
		end
	end)
end)
client.set_event_callback("player_hurt", function(arg_27_0)
	local var_27_0 = var_0_75.GetUserSteamID64(client.userid_to_entindex(arg_27_0.userid))
	local var_27_1 = var_0_75.GetUserSteamID64(client.userid_to_entindex(arg_27_0.attacker))

	if var_27_1 == 0 then
		return
	end

	pcall(function()
		local var_28_0 = #var_0_17[var_27_1]

		if var_0_17[var_27_1][var_28_0] then
			var_0_17[var_27_1][var_28_0].damaged_player = var_27_0
		end
	end)
end)

local var_0_77 = 0
local var_0_78 = -1
local var_0_79 = {
	0,
	0,
	0
}
local var_0_80 = {
	0,
	0,
	0
}

client.set_event_callback("override_view", function(arg_29_0)
	if not var_0_19 then
		return
	end

	arg_29_0.x = var_0_79[1]
	arg_29_0.y = var_0_79[2]
	arg_29_0.z = var_0_79[3]
	arg_29_0.pitch = var_0_80[1]
	arg_29_0.yaw = var_0_80[2]
	arg_29_0.roll = var_0_80[3]

	if var_0_77 == globals.tickcount() then
		return
	end

	var_0_77 = globals.tickcount()

	if #var_0_20 == var_0_23 and var_0_78 == -1 then
		var_0_78 = 50

		return
	end

	if var_0_78 > 0 then
		var_0_78 = var_0_78 - 1
		var_0_23 = #var_0_20
	elseif var_0_78 == 0 then
		var_0_19 = false
		var_0_23 = 1
		var_0_78 = -1
		var_0_24 = false

		return
	end

	local var_29_0 = var_0_20[var_0_23]

	if not var_29_0 then
		return
	end

	if var_29_0.tick > var_0_25 and not var_0_24 then
		var_0_24 = true

		client.exec("playvol player/death1.wav 1")
	end

	if var_29_0.is_shooting == 1 and not var_0_24 and var_29_0.tick < var_0_25 then
		client.exec("playvol weapons/ak47/ak47-1.wav 0.2")
	end

	var_0_79 = {
		var_29_0.head_x,
		var_29_0.head_y,
		var_29_0.head_z
	}
	var_0_80 = {
		var_29_0.pitch,
		var_29_0.yaw,
		var_29_0.roll
	}
	var_0_23 = var_0_23 + 1
end)

local var_0_81 = {
	{
		g = 0,
		b = 0,
		id = 3,
		name = "cheating",
		r = 255
	},
	{
		g = 255,
		b = 0,
		id = 2,
		name = "suspicious",
		r = 255
	}
}

for iter_0_4 = 1, #var_0_81 do
	local var_0_82 = var_0_81[iter_0_4]

	client.register_esp_flag(var_0_82.name, var_0_82.r, var_0_82.g, var_0_82.b, function(arg_30_0)
		if not ui.get(var_0_41) or ui.get(var_0_42) then
			return false
		end

		local var_30_0

		for iter_30_0 = 1, #var_0_16 do
			if var_0_16[iter_30_0].ent_id == arg_30_0 then
				var_30_0 = var_0_16[iter_30_0]

				break
			end
		end

		if var_30_0 == nil then
			return false
		end

		local var_30_1 = var_0_75.GetViolationData(var_0_18[var_30_0.steamid]).violation_level

		if var_30_1 == nil then
			return false
		end

		if var_30_1 == var_0_82.id then
			return true
		end
	end)
end

function unmatched_loop()
	local var_31_0 = {}

	for iter_31_0, iter_31_1 in pairs(var_0_18) do
		table.insert(var_31_0, iter_31_0)
	end

	var_0_75.PullUnmatchedDetection(var_31_0)
	client.delay_call(60, unmatched_loop)
end

client.delay_call(0, unmatched_loop)
client.set_event_callback("cheat_detected", function(arg_32_0)
	local var_32_0 = arg_32_0.cheat_long
	local var_32_1 = var_32_0:gsub("^%l", string.upper)
	local var_32_2 = arg_32_0.player
	local var_32_3

	for iter_32_0 = 1, #var_0_16 do
		if var_0_16[iter_32_0].ent_id == var_32_2 then
			var_32_3 = var_0_16[iter_32_0]

			break
		end
	end

	if var_32_3 == nil then
		return
	end

	Log(var_32_3.name .. " is using " .. var_32_1 .. "{log_only_on_trust_level_change}")

	var_0_18[var_32_3.steamid].cheat = var_32_0
	var_0_18[var_32_3.steamid].violation_level = 3

	if ui.get(var_0_39) then
		client.exec("playvol cheating.wav 0.5")
	end

	client.fire_event("player_trustlevel", {
		var_32_3.steamid,
		3
	})
end)
client.color_log(255, 0, 0, "\n [ Cheater Detector ]")
client.color_log(255, 180, 255, "   ► Loaded successfully\n")
