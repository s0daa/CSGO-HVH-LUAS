local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/steamworks")
local var_0_2 = require("gamesense/http")
local var_0_3 = require("gamesense/clipboard")
local var_0_4 = require("gamesense/pretty_json")
local var_0_5 = var_0_1.ISteamFriends
local var_0_6 = var_0_1.ISteamMatchmakingServers
local var_0_7 = panorama.open()
local var_0_8 = ui.reference("PLAYERS", "Players", "Player list")
local var_0_9 = ui.new_checkbox("LUA", "B", "Player tracker")
local var_0_10 = {
	autoRefresh = ui.new_checkbox("LUA", "B", "Automatically refresh tracker"),
	markTargets = ui.new_checkbox("LUA", "B", "Mark targets with esp flag"),
	saveRecentlySeen = ui.new_checkbox("LUA", "B", "Save recently played with"),
	manageData = ui.new_checkbox("LUA", "B", "Manage data"),
	dataExport = ui.new_button("LUA", "B", "Export targets", function()
		return
	end),
	dataImport = ui.new_button("LUA", "B", "Import targets", function()
		return
	end),
	deleteData = ui.new_button("LUA", "B", "Delete all targets", function()
		return
	end),
	mainLabel = ui.new_label("LUA", "B", "Player tracker"),
	listBox = ui.new_listbox("LUA", "B", "tracker content", {})
}
local var_0_11 = {
	ui.new_label("LUA", "B", "Steam info"),
	ui.new_label("LUA", "B", "Status"),
	ui.new_label("LUA", "B", "Game score"),
	ui.new_label("LUA", "B", "Maps in queue"),
	ui.new_label("LUA", "B", "Server")
}
local var_0_12 = ui.new_button("LUA", "B", "Join server", function()
	return
end)
local var_0_13 = ui.new_button("LUA", "B", "Watch game", function()
	return
end)
local var_0_14 = ui.new_button("LUA", "B", "Copy IP to clipboard", function()
	return
end)
local var_0_15
local var_0_16
local var_0_17 = 300
local var_0_18
local var_0_19 = 0
local var_0_20
local var_0_21 = {}
local var_0_22
local var_0_23 = database.read("stalkinfodataset123!@#") or {}

local function var_0_24(arg_7_0)
	local var_7_0 = var_0_0.new("MatchMakingKeyValuePair_t[?]", #arg_7_0)
	local var_7_1 = var_0_0.new("MatchMakingKeyValuePair_t*", var_7_0)
	local var_7_2 = var_0_0.new("MatchMakingKeyValuePair_t*[1]", var_7_1)
	local var_7_3 = var_0_0.new("MatchMakingKeyValuePair_t**", var_7_2)

	for iter_7_0, iter_7_1 in ipairs(arg_7_0) do
		var_7_0[iter_7_0 - 1].m_szKey = iter_7_1[1]
		var_7_0[iter_7_0 - 1].m_szValue = tostring(iter_7_1[2])
	end

	return var_7_3
end

local function var_0_25()
	local var_8_0 = 0

	for iter_8_0 = 1, globals.maxplayers() do
		if entity.get_classname(iter_8_0) == "CCSPlayer" then
			var_8_0 = var_8_0 + 1
		end
	end

	table.clear(var_0_21)

	local var_8_1 = 0

	for iter_8_1 = 0, 9999 do
		local var_8_2 = client.userid_to_entindex(iter_8_1)

		if var_8_2 > 0 and var_8_2 ~= entity.get_local_player() then
			var_0_21[iter_8_1] = {
				name = entity.get_player_name(var_8_2),
				idx = var_8_2,
				steamid = entity.get_steam64(var_8_2)
			}
			var_8_1 = var_8_1 + 1

			if var_8_1 == var_8_0 then
				break
			end
		end
	end
end

local function var_0_26(arg_9_0, arg_9_1)
	local var_9_0 = {}

	for iter_9_0 in (arg_9_0 .. arg_9_1):gmatch("(.-)" .. arg_9_1) do
		table.insert(var_9_0, iter_9_0)
	end

	return var_9_0
end

local function var_0_27(arg_10_0)
	if type(arg_10_0) == "string" then
		return 0
	end

	if type(arg_10_0) == "number" and arg_10_0 < 0 then
		return 0
	end

	local var_10_0
	local var_10_1 = client.unix_time()
	local var_10_2 = math.floor((var_10_1 - arg_10_0) / 60)
	local var_10_3 = math.floor(var_10_2 / 1440)
	local var_10_4 = var_10_3 == 0 and math.floor(var_10_2 / 60) or math.floor((var_10_2 - var_10_3 * 1440) / 60)
	local var_10_5 = var_10_2 - var_10_4 * 60 - var_10_3 * 1440
	local var_10_6 = var_10_3 > 0 and ("%d%s"):format(var_10_3, "d ") or ""

	var_10_6 = var_10_4 > 0 and ("%s%d%s"):format(var_10_6, var_10_4, "h ") or var_10_6 .. ""
	var_10_6 = var_10_5 > 0 and ("%s%d%s"):format(var_10_6, var_10_5, "m") or var_10_6 .. ""
	var_10_6 = var_10_6:len() == 0 and "just now" or var_10_6

	return var_10_6
end

local function var_0_28()
	table.sort(var_0_23, function(arg_12_0, arg_12_1)
		if arg_12_0.lastseen == arg_12_1.lastseen then
			return arg_12_0.steamid > arg_12_1.steamid
		else
			return arg_12_0.lastseen > arg_12_1.lastseen
		end
	end)
end

local function var_0_29()
	if not var_0_18 then
		local var_13_0 = {}

		var_0_28()

		for iter_13_0, iter_13_1 in ipairs(var_0_23) do
			local var_13_1 = ("%s● %s%s"):format(iter_13_1.expiry and "\aFFF696FF" or iter_13_1.active and "\a76FAE2FF" or iter_13_1.richData and next(iter_13_1.richData) and "\a7687FFFF" or "\a758492FF", "\aFFFFFFC8", iter_13_1.note)

			table.insert(var_13_0, var_13_1)
		end

		ui.update(var_0_10.listBox, var_13_0)
	end

	if not ui.get(var_0_10.listBox) then
		return
	end

	if #var_0_23 == 0 then
		return
	end

	local var_13_2 = ui.get(var_0_10.listBox) + 1
	local var_13_3 = var_0_23[var_13_2] or {}
	local var_13_4 = var_13_3.richData or {}
	local var_13_5 = next(var_13_4)

	ui.set(var_0_11[1], ("Steam: %s | %s"):format(var_13_3.nickname, var_13_3.steamid))

	if var_13_3.active then
		ui.set(var_0_11[2], ("Status: playing on %s..."):format(var_13_3.status[2]:sub(1, 20)))
		ui.set(var_0_11[5], ("Server info: %s | %s | %s | %s"):format(var_13_3.status[3], var_13_3.status[5], var_13_3.status[4], var_13_3.status[1]))
		ui.set(var_0_11[3], ("Match score: %s"):format(var_13_4["game:score"] or ""))
	elseif var_13_5 then
		ui.set(var_0_11[2], ("Status: %s / %s"):format(var_13_4.status, var_13_4["game:state"] or "?"))

		if var_13_4["game:mapgroupname"] then
			ui.set(var_0_11[4], ("Selected maps: %s"):format(var_13_4["game:mapgroupname"]:gsub("mg_de_", "")))
		end

		ui.set(var_0_11[3], ("Match score: %s"):format(var_13_4["game:score"] or ""))
	else
		if not var_13_3.lastseen then
			ui.set(var_0_11[2], "Status: last seen never")
		else
			ui.set(var_0_11[2], ("Status: last seen %s"):format(var_13_3.lastseen <= 0 and "never" or var_0_27(var_0_23[var_13_2].lastseen)))
		end

		ui.set(var_0_11[5], "Server info: offline")
	end

	if var_0_20 and not var_0_18 and client.unix_time() - var_0_20 > 60 then
		ui.set(var_0_10.mainLabel, ("Player tracker (last refresh: %s ago)"):format(var_0_27(var_0_20)))
	end

	if var_13_3.expiry then
		ui.set_visible(var_0_11[1], true)
		ui.set_visible(var_0_11[2], false)
		ui.set_visible(var_0_11[3], false)
		ui.set_visible(var_0_11[4], false)
		ui.set_visible(var_0_11[5], false)
		ui.set_visible(var_0_12, false)
		ui.set_visible(var_0_14, false)
		ui.set_visible(var_0_13, false)
	else
		ui.set_visible(var_0_11[1], true)
		ui.set_visible(var_0_11[2], true)
		ui.set_visible(var_0_11[3], var_13_5 and var_13_4["game:score"] or false)
		ui.set_visible(var_0_11[4], var_13_5 and var_13_4["game:state"] == "lobby" and var_13_4["game:mapgroupname"] or false)
		ui.set_visible(var_0_11[5], var_13_3.active)
		ui.set_visible(var_0_12, var_13_3.active)
		ui.set_visible(var_0_14, var_13_3.active)
		ui.set_visible(var_0_13, var_13_5 and tonumber(var_13_4.watch) == 1 or false)
	end
end

local function var_0_30(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = var_0_1.SteamID(arg_14_0)

	if not var_14_0 then
		print("[TRACKER] Invalid steamid: ", tostring(arg_14_0))

		return
	end

	local var_14_1 = var_14_0:render_steam64()

	for iter_14_0, iter_14_1 in ipairs(var_0_23) do
		if iter_14_1.steamid == var_14_1 then
			print("[TRACKER] Target with this steamid already exists!")

			return
		end
	end

	var_0_2.get("https://steamcommunity.com/profiles/" .. var_14_1, {
		params = {
			xml = 1
		}
	}, function(arg_15_0, arg_15_1)
		local var_15_0 = "Refresh list to fetch"

		if arg_15_1.status == 200 then
			local var_15_1 = arg_15_1.body:match("<steamID><%!%[CDATA%[(.+)%]%]></steamID>")

			if var_15_1 then
				var_15_0 = var_15_1
			end
		end

		table.insert(var_0_23, {
			status = "Unknown",
			steamid = var_14_1,
			nickname = arg_14_2 and arg_14_1 or var_15_0,
			lastseen = arg_14_2 and -1 or 0,
			note = arg_14_1,
			expiry = arg_14_2 and client.unix_time() or nil
		})
		print(("[TRACKER] Adding %s to %slist: %s"):format(arg_14_1, arg_14_2 and "temporary " or "", arg_14_0))
		var_0_29()
		database.write("stalkinfodataset123!@#", var_0_23)
		database.flush()
	end)
end

local function var_0_31(arg_16_0)
	if not var_0_23[arg_16_0] then
		print("[TRACKER] Attampting to remove non-existent user")

		return
	end

	local var_16_0 = var_0_23[arg_16_0].steamid

	table.remove(var_0_23, arg_16_0)
	print(("[TRACKER] Removed %s from the list"):format(var_16_0))
end

local function var_0_32(arg_17_0)
	local var_17_0 = {}
	local var_17_1 = var_0_1.SteamID(arg_17_0)
	local var_17_2 = var_0_5.GetFriendRichPresenceKeyCount(var_17_1)

	if var_17_2 == 0 then
		return {}
	end

	for iter_17_0 = 0, var_17_2 do
		local var_17_3 = var_0_5.GetFriendRichPresenceKeyByIndex(var_17_1, iter_17_0)

		var_17_0[var_17_3] = var_0_5.GetFriendRichPresence(var_17_1, var_17_3)
	end

	return var_17_0
end

client.set_event_callback("console_input", function(arg_18_0)
	local var_18_0 = arg_18_0:match("^track (.+)")

	if var_18_0 then
		local var_18_1 = var_0_26(var_18_0, ",")

		if #(string.match(var_18_1[1], "[0-9]+") or {}) == 17 then
			var_0_30(var_18_1[1], var_18_1[2])
			var_0_29()

			return true
		end
	end
end)

local function var_0_33()
	if #var_0_23 == 0 then
		print("[TRACKER] Tracking list is empty")

		return
	end

	if var_0_18 then
		print("[TRACKER] Query is already running")

		return
	end

	var_0_18 = true

	ui.set(var_0_10.mainLabel, "Player tracker - refreshing")

	local var_19_0 = 0

	for iter_19_0, iter_19_1 in ipairs(var_0_23) do
		iter_19_1.active = false
	end

	local var_19_1 = var_0_24({
		{
			"gametagsand",
			"hvh"
		}
	})
	local var_19_2 = var_0_1.ISteamMatchmakingServerListResponse.new({
		ServerResponded = function(arg_20_0, arg_20_1, arg_20_2)
			if arg_20_2 then
				local var_20_0 = var_0_6.GetServerDetails(arg_20_1, arg_20_2)

				var_19_0 = math.min(var_19_0 + 1, var_0_17 or 9999)

				local var_20_1 = ("Player tracker - fetching servers (%d%%)"):format(var_19_0 / var_0_17 * 100)

				ui.set(var_0_10.mainLabel, var_20_1)

				if var_20_0.m_nPlayers > 0 then
					local var_20_2 = var_20_0.m_NetAdr.m_unIP
					local var_20_3 = var_20_0.m_NetAdr.m_usConnectionPort
					local var_20_4 = var_0_0.string(var_20_0.m_szMap)
					local var_20_5 = var_0_1.ISteamMatchmakingPlayersResponse.new({
						AddPlayerToList = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
							local var_21_0 = var_0_0.string(arg_21_1)

							for iter_21_0, iter_21_1 in ipairs(var_0_23) do
								if iter_21_1.expiry then
									-- block empty
								elseif var_21_0 == iter_21_1.nickname and var_20_4 == iter_21_1.richData["game:map"] then
									local var_21_1 = ("%s:%s"):format(var_0_1.ipv4_tostring(var_20_0.m_NetAdr.m_unIP), var_20_0.m_NetAdr.m_usConnectionPort)
									local var_21_2 = ("%s"):format(var_0_0.string(var_20_0.m_szServerName)):sub(1, 50)
									local var_21_3 = var_20_0.m_nPing .. "ms"
									local var_21_4 = ("(%d/%d)"):format(var_20_0.m_nPlayers, var_20_0.m_nMaxPlayers)

									iter_21_1.lastseen = client.unix_time()
									iter_21_1.status = {
										var_21_1,
										var_21_2,
										var_20_4,
										var_21_3,
										var_21_4
									}
									iter_21_1.active = true
								end
							end
						end,
						PlayersRefreshComplete = function()
							return
						end
					})
					local var_20_6 = var_0_6.PlayerDetails(var_20_2, var_20_3, var_20_5)
				end

				var_0_15 = arg_20_1
			end
		end,
		ServerFailedToRespond = function()
			return
		end,
		RefreshComplete = function()
			ui.set(var_0_10.mainLabel, "Player tracker")

			var_0_17 = var_19_0
			var_0_18 = false
			var_0_20 = client.unix_time()

			var_0_6.ReleaseRequest(var_0_16)

			if ui.get(var_0_9) then
				var_0_29()
			end
		end
	})

	var_0_16 = var_0_6.RequestInternetServerList(730, var_19_1, 1, var_19_2)
end

local function var_0_34()
	if #var_0_23 == 0 then
		print("[TRACKER] Tracking list is empty")

		return
	end

	ui.set(var_0_10.mainLabel, "Player tracker - fetching steam names")

	local var_25_0 = 0

	for iter_25_0 = #var_0_23, 1, -1 do
		local var_25_1 = var_0_23[iter_25_0]

		if var_25_1.expiry and client.unix_time() - var_25_1.expiry > 600 then
			var_0_31(iter_25_0)
			print("[TRACkER] removing expired temp player: ", var_25_1.note, " with timestamp: ", var_25_1.expiry)
		end
	end

	for iter_25_1, iter_25_2 in ipairs(var_0_23) do
		local var_25_2 = iter_25_2.expiry

		if var_25_2 then
			-- block empty
		else
			var_25_2 = iter_25_2.steamid

			var_0_5.RequestFriendRichPresence(var_25_2)
			var_0_5.RequestUserInformation(var_25_2, true)

			var_25_0 = var_25_0 + 1

			var_0_2.get("https://steamcommunity.com/profiles/" .. var_25_2, {
				params = {
					xml = 1
				}
			}, function(arg_26_0, arg_26_1)
				if arg_26_1.status == 200 then
					local var_26_0 = ("Player tracker - fetching steam names (%d%%)"):format(100 - var_25_0 / #var_0_23 * 100)

					ui.set(var_0_10.mainLabel, var_26_0)

					var_25_0 = var_25_0 - 1

					local var_26_1 = arg_26_1.body:match("<steamID><%!%[CDATA%[(.+)%]%]></steamID>")

					if var_26_1 then
						iter_25_2.nickname = var_26_1
					end

					iter_25_2.richData = var_0_32(var_25_2)

					if next(var_0_32(var_25_2)) then
						iter_25_2.lastseen = client.unix_time()
					end

					if var_25_0 == 0 then
						var_0_33()
					end
				end
			end)
		end
	end
end

client.set_event_callback("paint_ui", function()
	if ui.get(var_0_10.autoRefresh) then
		local var_27_0 = globals.realtime()

		if var_27_0 - 60 > var_0_19 then
			var_0_34()

			var_0_19 = var_27_0
		end
	end

	if ui.get(var_0_10.saveRecentlySeen) then
		local var_27_1 = globals.mapname() ~= nil

		if not var_27_1 and var_0_22 then
			client.delay_call(2, function()
				for iter_28_0, iter_28_1 in pairs(var_0_21) do
					if iter_28_1.steamid > 0 then
						var_0_30(var_0_1.SteamID(iter_28_1.steamid), iter_28_1.name, true)
					end
				end

				table.clear(var_0_21)
			end)
		end

		var_0_22 = var_27_1
	end
end)
client.register_esp_flag("PT", 255, 255, 255, function(arg_29_0)
	if not ui.get(var_0_10.markTargets) then
		return
	end

	local var_29_0 = var_0_1.SteamID(entity.get_steam64(arg_29_0))

	for iter_29_0, iter_29_1 in ipairs(var_0_23) do
		if iter_29_1.steamid == var_29_0 then
			return true
		end
	end

	return false
end)
client.set_event_callback("shutdown", function()
	database.write("stalkinfodataset123!@#", var_0_23)
	database.flush()
	var_0_6.CancelQuery(var_0_15)
	var_0_6.ReleaseRequest(var_0_16)
end)
client.set_event_callback("round_prestart", var_0_25)
client.set_event_callback("player_team", function(arg_31_0)
	if not ui.get(var_0_10.saveRecentlySeen) then
		return
	end

	if not arg_31_0.disconnect then
		var_0_25()

		return
	end

	local var_31_0 = var_0_21[arg_31_0.userid] or {}

	if not var_31_0.steamid or var_31_0.steamid == 0 then
		return
	end

	local var_31_1 = var_0_1.SteamID(var_31_0.steamid)

	for iter_31_0, iter_31_1 in ipairs(var_0_23) do
		if iter_31_1.steamid == var_31_1 and iter_31_1.expiry then
			iter_31_1.expiry = client.unix_time()

			print("[TRACER] target already logged, expiry time updated")

			return
		end
	end

	var_0_30(var_31_1, var_31_0.name, true)
	var_0_29()
end)

local function var_0_35()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_32_0 = ui.get(var_0_10.listBox) + 1

	var_0_7.SteamOverlayAPI.ShowUserProfilePage(tostring(var_0_23[var_32_0].steamid))
end

local var_0_36 = {
	refresher = ui.new_button("LUA", "B", "Refresh list", var_0_34),
	opener = ui.new_button("LUA", "B", "Open steam profile", var_0_35),
	editer = ui.new_button("LUA", "B", "Edit player", function()
		return
	end),
	editerField = ui.new_textbox("LUA", "B", "Edit player"),
	confirmer = ui.new_button("LUA", "B", "(CONFIRM)", function()
		return
	end),
	canceller = ui.new_button("LUA", "B", "(CANCEL)", function()
		return
	end),
	remover = ui.new_button("LUA", "B", "Remove player from list", function()
		return
	end),
	adder = ui.new_button("LUA", "B", "Add player permanently", function()
		return
	end),
	plistSaver = ui.new_button("PLAYERS", "Adjustments", "Add player to tracking list", function()
		return
	end)
}

local function var_0_37()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_39_0 = ui.get(var_0_10.listBox) + 1
	local var_39_1 = var_0_23[var_39_0] or {}

	if ui.get(var_0_9) then
		ui.set_visible(var_0_36.refresher, not var_39_1.expiry)
		ui.set_visible(var_0_36.opener, not var_39_1.expiry)
		ui.set_visible(var_0_36.editer, not var_39_1.expiry)
		ui.set_visible(var_0_36.adder, var_39_1.expiry)
	end

	var_0_29()
end

ui.set_callback(var_0_10.listBox, var_0_37)

local function var_0_38(arg_40_0)
	ui.set_visible(var_0_36.editer, not arg_40_0)
	ui.set_visible(var_0_36.editerField, arg_40_0)
	ui.set_visible(var_0_36.confirmer, arg_40_0)
	ui.set_visible(var_0_36.canceller, arg_40_0)
	ui.set_visible(var_0_36.remover, arg_40_0)
end

local function var_0_39()
	local var_41_0 = ui.get(var_0_10.manageData)

	ui.set_visible(var_0_10.dataExport, var_41_0)
	ui.set_visible(var_0_10.dataImport, var_41_0)
	ui.set_visible(var_0_10.deleteData, var_41_0)
end

ui.set_callback(var_0_36.plistSaver, function()
	local var_42_0 = ui.get(var_0_8)
	local var_42_1 = "From player list"
	local var_42_2 = var_0_1.SteamID(entity.get_steam64(var_42_0))

	var_0_30(var_42_2, var_42_1)
	var_0_29()
end)
ui.set_callback(var_0_36.editer, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	var_0_38(true)
end)
ui.set_callback(var_0_14, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_44_0 = ui.get(var_0_10.listBox) + 1
	local var_44_1 = tostring(var_0_23[var_44_0].status[1])

	if var_44_1 and var_44_1 ~= "" then
		var_0_3.set(var_44_1)
		print("[TRACKER] Copied ip into clipboard: ", var_44_1)
	end
end)
ui.set_callback(var_0_36.confirmer, function()
	local var_45_0 = ui.get(var_0_10.listBox) + 1

	for iter_45_0, iter_45_1 in ipairs(var_0_23) do
		if iter_45_0 == var_45_0 then
			iter_45_1.note = #ui.get(var_0_36.editerField) == 0 and "Unknown" or tostring(ui.get(var_0_36.editerField))

			print("[TRACKER] Successfully changed nickname for " .. iter_45_1.steamid)
			var_0_29()
			ui.set(var_0_36.editerField, "")
		end
	end

	var_0_38(false)
end)
ui.set_callback(var_0_36.canceller, function()
	var_0_38(false)
	ui.set(var_0_36.editerField, "")
end)
ui.set_callback(var_0_36.remover, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_47_0 = ui.get(var_0_10.listBox) + 1

	ui.set(var_0_10.listBox, 0)
	var_0_31(var_47_0)
	var_0_29()
	var_0_38(false)
	ui.set(var_0_36.editerField, "")
end)
ui.set_callback(var_0_36.adder, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_48_0 = ui.get(var_0_10.listBox) + 1

	var_0_23[var_48_0].expiry = nil
	var_0_23[var_48_0].lastseen = 0

	print(("[TRACKER] successfully added %s as permanent target"):format(var_0_23[var_48_0].note))
	var_0_37()
end)
ui.set_callback(var_0_12, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_49_0 = ui.get(var_0_10.listBox) + 1
	local var_49_1 = var_0_23[var_49_0].status[1]:match("(%d+%.%d+%.%d+%.%d+:%d+)")

	var_0_7.GameInterfaceAPI.ConsoleCommand("connect " .. var_49_1)
end)
ui.set_callback(var_0_13, function()
	if not ui.get(var_0_10.listBox) then
		return
	end

	local var_50_0 = ui.get(var_0_10.listBox) + 1
	local var_50_1 = var_0_23[var_50_0].steamid

	var_0_7.FriendsListAPI.ActionWatchFriendSession(var_50_1)
end)
ui.set_callback(var_0_10.dataExport, function()
	local var_51_0 = {}

	for iter_51_0, iter_51_1 in ipairs(var_0_23) do
		if not iter_51_1.expiry then
			table.insert(var_51_0, {
				iter_51_1.steamid,
				iter_51_1.note
			})
		end
	end

	var_0_3.set(var_0_4.stringify(var_51_0))
	print(("[TRACKER] successfully exported %d %s into clipboard"):format(#var_0_23, #var_0_23 == 1 and "player" or "players"))
end)
ui.set_callback(var_0_10.dataImport, function()
	local var_52_0 = var_0_3.get()

	if not var_52_0 then
		print("Error importing: clipboard is empty")
	end

	local var_52_1, var_52_2 = pcall(json.parse, var_52_0)

	if var_52_1 and var_52_0:sub(1, 1) ~= "[" and var_52_0:sub(1, 1) ~= "{" then
		var_52_1, var_52_2 = false, "Expected object or array"
	end

	if not var_52_1 then
		local var_52_3 = string.format("Invalid JSON: %s", var_52_2)

		print("Failed to import: " .. var_52_3)

		return
	end

	for iter_52_0, iter_52_1 in ipairs(var_52_2) do
		var_0_30(iter_52_1[1], iter_52_1[2], false)
	end

	print(("[TRACKER] successfully imported %d %s"):format(#var_52_2, #var_52_2 == 1 and "player" or "players"))
end)

local function var_0_40()
	local var_53_0 = ui.get(var_0_9)

	for iter_53_0, iter_53_1 in pairs(var_0_10) do
		ui.set_visible(iter_53_1, var_53_0)
	end

	for iter_53_2, iter_53_3 in pairs(var_0_11) do
		ui.set_visible(iter_53_3, var_53_0)
	end

	for iter_53_4, iter_53_5 in pairs(var_0_36) do
		ui.set_visible(iter_53_5, var_53_0)
	end

	ui.set_visible(var_0_12, var_53_0)
	ui.set_visible(var_0_14, var_53_0)
	ui.set_visible(var_0_13, var_53_0)

	if var_53_0 then
		var_0_38(false)
		var_0_37()
		var_0_39()
	end

	if #var_0_23 == 0 then
		for iter_53_6, iter_53_7 in pairs(var_0_10) do
			ui.set_visible(iter_53_7, var_53_0)
		end

		for iter_53_8, iter_53_9 in pairs(var_0_11) do
			ui.set_visible(iter_53_9, false)
		end

		for iter_53_10, iter_53_11 in pairs(var_0_36) do
			ui.set_visible(iter_53_11, false)
		end

		ui.set_visible(var_0_12, false)
		ui.set_visible(var_0_14, false)
		ui.set_visible(var_0_13, false)
		ui.set_visible(var_0_10.listBox, var_53_0)
		ui.set_visible(var_0_36.plistSaver, var_53_0)

		if var_53_0 then
			var_0_39()
		end
	end
end

ui.set_callback(var_0_10.deleteData, function()
	var_0_23 = {}

	var_0_29()
	var_0_40()
	print("[TRACKER] successfully removed all players")
end)
ui.set_callback(var_0_9, var_0_40)
ui.set_callback(var_0_10.manageData, var_0_39)

local function var_0_41()
	var_0_29()
	var_0_37()
	var_0_40()
	var_0_39()
end

var_0_41()
client.set_event_callback("post_config_load", var_0_41)
