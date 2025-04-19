slot0 = require("ffi")
slot1 = require("gamesense/steamworks")
slot2 = require("gamesense/http")
slot3 = require("gamesense/clipboard")
slot4 = require("gamesense/pretty_json")
slot5 = slot1.ISteamFriends
slot6 = slot1.ISteamMatchmakingServers
slot7 = panorama.open()
slot8 = ui.reference("PLAYERS", "Players", "Player list")
slot10 = {
	autoRefresh = ui.new_checkbox("LUA", "B", "Automatically refresh tracker"),
	markTargets = ui.new_checkbox("LUA", "B", "Mark targets with esp flag"),
	saveRecentlySeen = ui.new_checkbox("LUA", "B", "Save recently played with"),
	manageData = ui.new_checkbox("LUA", "B", "Manage data"),
	dataExport = ui.new_button("LUA", "B", "Export targets", function ()
	end),
	dataImport = ui.new_button("LUA", "B", "Import targets", function ()
	end),
	deleteData = ui.new_button("LUA", "B", "Delete all targets", function ()
	end),
	mainLabel = ui.new_label("LUA", "B", "Player tracker"),
	listBox = ui.new_listbox("LUA", "B", "tracker content", {})
}
slot11 = {
	ui.new_label("LUA", "B", "Steam info"),
	ui.new_label("LUA", "B", "Status"),
	ui.new_label("LUA", "B", "Game score"),
	ui.new_label("LUA", "B", "Maps in queue"),
	ui.new_label("LUA", "B", "Server")
}
slot15, slot16 = nil
slot17 = 300
slot18 = nil
slot19 = 0
slot20 = nil
slot21 = {}
slot22 = nil
slot23 = database.read("stalkinfodataset123!@#") or {}

function slot24(slot0)
	slot4 = uv0.new("MatchMakingKeyValuePair_t**", uv0.new("MatchMakingKeyValuePair_t*[1]", uv0.new("MatchMakingKeyValuePair_t*", uv0.new("MatchMakingKeyValuePair_t[?]", #slot0))))

	for slot8, slot9 in ipairs(slot0) do
		slot1[slot8 - 1].m_szKey = slot9[1]
		slot1[slot8 - 1].m_szValue = tostring(slot9[2])
	end

	return slot4
end

function slot26(slot0, slot1)
	slot2 = {}
	slot6 = slot1

	for slot6 in (slot0 .. slot1):gmatch("(.-)" .. slot6) do
		table.insert(slot2, slot6)
	end

	return slot2
end

function slot27(slot0)
	if type(slot0) == "string" then
		return 0
	end

	if type(slot0) == "number" and slot0 < 0 then
		return 0
	end

	slot1 = nil
	slot5 = math.floor(math.floor((client.unix_time() - slot0) / 60) / 1440) == 0 and math.floor(slot3 / 60) or math.floor((slot3 - slot4 * 1440) / 60)
	slot6 = slot3 - slot5 * 60 - slot4 * 1440
	slot1 = slot4 > 0 and ("%d%s"):format(slot4, "d ") or ""
	slot1 = slot5 > 0 and ("%s%d%s"):format(slot1, slot5, "h ") or slot1 .. ""

	if (slot6 > 0 and ("%s%d%s"):format(slot1, slot6, "m") or slot1 .. ""):len() == 0 then
		slot1 = "just now"
	end

	return slot1
end

function slot28()
	table.sort(uv0, function (slot0, slot1)
		if slot0.lastseen == slot1.lastseen then
			return slot1.steamid < slot0.steamid
		else
			return slot1.lastseen < slot0.lastseen
		end
	end)
end

function slot29()
	if not uv0 then
		slot0 = {}

		uv1()

		for slot4, slot5 in ipairs(uv2) do
			table.insert(slot0, ("%s● %s%s"):format(slot5.expiry and "FFF696FF" or slot5.active and "76FAE2FF" or slot5.richData and next(slot5.richData) and "7687FFFF" or "758492FF", "FFFFFFC8", slot5.note))
		end

		ui.update(uv3.listBox, slot0)
	end

	if not ui.get(uv3.listBox) then
		return
	end

	if #uv2 == 0 then
		return
	end

	slot1 = uv2[ui.get(uv3.listBox) + 1] or {}
	slot3 = next(slot1.richData or {})

	ui.set(uv4[1], ("Steam: %s | %s"):format(slot1.nickname, slot1.steamid))

	if slot1.active then
		ui.set(uv4[2], ("Status: playing on %s..."):format(slot1.status[2]:sub(1, 20)))
		ui.set(uv4[5], ("Server info: %s | %s | %s | %s"):format(slot1.status[3], slot1.status[5], slot1.status[4], slot1.status[1]))
		ui.set(uv4[3], ("Match score: %s"):format(slot2["game:score"] or ""))
	elseif slot3 then
		ui.set(uv4[2], ("Status: %s / %s"):format(slot2.status, slot2["game:state"] or "?"))

		if slot2["game:mapgroupname"] then
			ui.set(uv4[4], ("Selected maps: %s"):format(slot2["game:mapgroupname"]:gsub("mg_de_", "")))
		end

		ui.set(uv4[3], ("Match score: %s"):format(slot2["game:score"] or ""))
	else
		if not slot1.lastseen then
			ui.set(uv4[2], "Status: last seen never")
		else
			ui.set(uv4[2], ("Status: last seen %s"):format(slot1.lastseen <= 0 and "never" or uv5(uv2[slot0].lastseen)))
		end

		ui.set(uv4[5], "Server info: offline")
	end

	if uv6 and not uv0 and client.unix_time() - uv6 > 60 then
		ui.set(uv3.mainLabel, ("Player tracker (last refresh: %s ago)"):format(uv5(uv6)))
	end

	if slot1.expiry then
		ui.set_visible(uv4[1], true)
		ui.set_visible(uv4[2], false)
		ui.set_visible(uv4[3], false)
		ui.set_visible(uv4[4], false)
		ui.set_visible(uv4[5], false)
		ui.set_visible(uv7, false)
		ui.set_visible(uv8, false)
		ui.set_visible(uv9, false)
	else
		ui.set_visible(uv4[1], true)
		ui.set_visible(uv4[2], true)
		ui.set_visible(uv4[3], slot3 and slot2["game:score"] or false)
		ui.set_visible(uv4[4], slot3 and slot2["game:state"] == "lobby" and slot2["game:mapgroupname"] or false)
		ui.set_visible(uv4[5], slot1.active)
		ui.set_visible(uv7, slot1.active)
		ui.set_visible(uv8, slot1.active)
		ui.set_visible(uv9, slot3 and tonumber(slot2.watch) == 1 or false)
	end
end

function slot30(slot0, slot1, slot2)
	if not uv0.SteamID(slot0) then
		print("[TRACKER] Invalid steamid: ", tostring(slot0))

		return
	end

	slot4 = slot3:render_steam64()

	for slot8, slot9 in ipairs(uv1) do
		if slot9.steamid == slot4 then
			print("[TRACKER] Target with this steamid already exists!")

			return
		end
	end

	uv2.get("https://steamcommunity.com/profiles/" .. slot4, {
		params = {
			xml = 1
		}
	}, function (slot0, slot1)
		slot2 = "Refresh list to fetch"

		if slot1.status == 200 and slot1.body:match("<steamID><%!%[CDATA%[(.+)%]%]></steamID>") then
			slot2 = slot3
		end

		table.insert(uv0, {
			status = "Unknown",
			steamid = uv1,
			nickname = uv2 and uv3 or slot2,
			lastseen = uv2 and -1 or 0,
			note = uv3,
			expiry = uv2 and client.unix_time() or nil
		})
		print(("[TRACKER] Adding %s to %slist: %s"):format(uv3, uv2 and "temporary " or "", uv4))
		uv5()
		database.write("stalkinfodataset123!@#", uv0)
		database.flush()
	end)
end

function slot31(slot0)
	if not uv0[slot0] then
		print("[TRACKER] Attampting to remove non-existent user")

		return
	end

	table.remove(uv0, slot0)
	print(("[TRACKER] Removed %s from the list"):format(uv0[slot0].steamid))
end

function slot32(slot0)
	slot1 = {}

	if uv1.GetFriendRichPresenceKeyCount(uv0.SteamID(slot0)) == 0 then
		return {}
	end

	for slot7 = 0, slot3 do
		slot8 = uv1.GetFriendRichPresenceKeyByIndex(slot2, slot7)
		slot1[slot8] = uv1.GetFriendRichPresence(slot2, slot8)
	end

	return slot1
end

client.set_event_callback("console_input", function (slot0)
	if slot0:match("^track (.+)") and #(string.match(uv0(slot1, ",")[1], "[0-9]+") or {}) == 17 then
		uv1(slot2[1], slot2[2])
		uv2()

		return true
	end
end)

function slot33()
	if #uv0 == 0 then
		print("[TRACKER] Tracking list is empty")

		return
	end

	if uv1 then
		print("[TRACKER] Query is already running")

		return
	end

	uv1 = true

	ui.set(uv2.mainLabel, "Player tracker - refreshing")

	slot0 = 0

	for slot4, slot5 in ipairs(uv0) do
		slot5.active = false
	end

	uv10 = uv5.RequestInternetServerList(730, uv3({
		{
			"gametagsand",
			"hvh"
		}
	}), 1, uv4.ISteamMatchmakingServerListResponse.new({
		ServerResponded = function (slot0, slot1, slot2)
			if slot2 then
				uv1 = math.min(uv1 + 1, uv2 or 9999)

				ui.set(uv3.mainLabel, ("Player tracker - fetching servers (%d%%)"):format(uv1 / uv2 * 100))

				if uv0.GetServerDetails(slot1, slot2).m_nPlayers > 0 then
					slot7 = uv4.string(slot3.m_szMap)
					slot9 = uv0.PlayerDetails(slot3.m_NetAdr.m_unIP, slot3.m_NetAdr.m_usConnectionPort, uv5.ISteamMatchmakingPlayersResponse.new({
						AddPlayerToList = function (slot0, slot1, slot2, slot3)
							slot4 = uv0.string(slot1)

							for slot8, slot9 in ipairs(uv1) do
								if slot9.expiry then
									-- Nothing
								elseif slot4 == slot9.nickname and uv2 == slot9.richData["game:map"] then
									slot9.lastseen = client.unix_time()
									slot9.status = {
										("%s:%s"):format(uv3.ipv4_tostring(uv4.m_NetAdr.m_unIP), uv4.m_NetAdr.m_usConnectionPort),
										("%s"):format(uv0.string(uv4.m_szServerName)):sub(1, 50),
										uv2,
										uv4.m_nPing .. "ms",
										("(%d/%d)"):format(uv4.m_nPlayers, uv4.m_nMaxPlayers)
									}
									slot9.active = true
								end
							end
						end,
						PlayersRefreshComplete = function ()
						end
					}))
				end

				uv7 = slot1
			end
		end,
		ServerFailedToRespond = function ()
		end,
		RefreshComplete = function ()
			ui.set(uv0.mainLabel, "Player tracker")

			uv1 = uv2
			uv3 = false
			uv4 = client.unix_time()

			uv5.ReleaseRequest(uv6)

			if ui.get(uv7) then
				uv8()
			end
		end
	}))
end

client.set_event_callback("paint_ui", function ()
	if ui.get(uv0.autoRefresh) and uv1 < globals.realtime() - 60 then
		uv2()

		uv1 = slot0
	end

	if ui.get(uv0.saveRecentlySeen) then
		if not (globals.mapname() ~= nil) and uv3 then
			client.delay_call(2, function ()
				for slot3, slot4 in pairs(uv0) do
					if slot4.steamid > 0 then
						uv1(uv2.SteamID(slot4.steamid), slot4.name, true)
					end
				end

				table.clear(uv0)
			end)
		end

		uv3 = slot0
	end
end)
client.register_esp_flag("PT", 255, 255, 255, function (slot0)
	if not ui.get(uv0.markTargets) then
		return
	end

	for slot5, slot6 in ipairs(uv2) do
		if slot6.steamid == uv1.SteamID(entity.get_steam64(slot0)) then
			return true
		end
	end

	return false
end)
client.set_event_callback("shutdown", function ()
	database.write("stalkinfodataset123!@#", uv0)
	database.flush()
	uv1.CancelQuery(uv2)
	uv1.ReleaseRequest(uv3)
end)
client.set_event_callback("round_prestart", function ()
	for slot4 = 1, globals.maxplayers() do
		if entity.get_classname(slot4) == "CCSPlayer" then
			slot0 = 0 + 1
		end
	end

	table.clear(uv0)

	for slot5 = 0, 9999 do
		if client.userid_to_entindex(slot5) > 0 and slot6 ~= entity.get_local_player() then
			uv0[slot5] = {
				name = entity.get_player_name(slot6),
				idx = slot6,
				steamid = entity.get_steam64(slot6)
			}

			if 0 + 1 == slot0 then
				break
			end
		end
	end
end)
client.set_event_callback("player_team", function (slot0)
	if not ui.get(uv0.saveRecentlySeen) then
		return
	end

	if not slot0.disconnect then
		uv1()

		return
	end

	if not (uv2[slot0.userid] or {}).steamid or slot1.steamid == 0 then
		return
	end

	slot2 = uv3.SteamID(slot1.steamid)

	for slot6, slot7 in ipairs(uv4) do
		if slot7.steamid == slot2 and slot7.expiry then
			slot7.expiry = client.unix_time()

			print("[TRACER] target already logged, expiry time updated")

			return
		end
	end

	uv5(slot2, slot1.name, true)
	uv6()
end)

slot36 = {
	refresher = ui.new_button("LUA", "B", "Refresh list", function ()
		if #uv0 == 0 then
			print("[TRACKER] Tracking list is empty")

			return
		end

		ui.set(uv1.mainLabel, "Player tracker - fetching steam names")

		slot0 = 0

		for slot4 = #uv0, 1, -1 do
			if uv0[slot4].expiry and client.unix_time() - slot5.expiry > 600 then
				uv2(slot4)
				print("[TRACkER] removing expired temp player: ", slot5.note, " with timestamp: ", slot5.expiry)
			end
		end

		for slot4, slot5 in ipairs(uv0) do
			if not slot5.expiry then
				slot6 = slot5.steamid

				uv3.RequestFriendRichPresence(slot6)
				uv3.RequestUserInformation(slot6, true)

				slot0 = slot0 + 1

				uv4.get("https://steamcommunity.com/profiles/" .. slot6, {
					params = {
						xml = 1
					}
				}, function (slot0, slot1)
					if slot1.status == 200 then
						ui.set(uv2.mainLabel, ("Player tracker - fetching steam names (%d%%)"):format(100 - uv0 / #uv1 * 100))

						uv0 = uv0 - 1

						if slot1.body:match("<steamID><%!%[CDATA%[(.+)%]%]></steamID>") then
							uv3.nickname = slot3
						end

						uv3.richData = uv4(uv5)

						if next(uv4(uv5)) then
							uv3.lastseen = client.unix_time()
						end

						if uv0 == 0 then
							uv6()
						end
					end
				end)
			end
		end
	end),
	opener = ui.new_button("LUA", "B", "Open steam profile", function ()
		if not ui.get(uv0.listBox) then
			return
		end

		uv1.SteamOverlayAPI.ShowUserProfilePage(tostring(uv2[ui.get(uv0.listBox) + 1].steamid))
	end),
	editer = ui.new_button("LUA", "B", "Edit player", function ()
	end),
	editerField = ui.new_textbox("LUA", "B", "Edit player"),
	confirmer = ui.new_button("LUA", "B", "(CONFIRM)", function ()
	end),
	canceller = ui.new_button("LUA", "B", "(CANCEL)", function ()
	end),
	remover = ui.new_button("LUA", "B", "Remove player from list", function ()
	end),
	adder = ui.new_button("LUA", "B", "Add player permanently", function ()
	end),
	plistSaver = ui.new_button("PLAYERS", "Adjustments", "Add player to tracking list", function ()
	end)
}

ui.set_callback(slot10.listBox, function ()
	if not ui.get(uv0.listBox) then
		return
	end

	slot1 = uv1[ui.get(uv0.listBox) + 1] or {}

	if ui.get(uv2) then
		ui.set_visible(uv3.refresher, not slot1.expiry)
		ui.set_visible(uv3.opener, not slot1.expiry)
		ui.set_visible(uv3.editer, not slot1.expiry)
		ui.set_visible(uv3.adder, slot1.expiry)
	end

	uv4()
end)

function slot38(slot0)
	ui.set_visible(uv0.editer, not slot0)
	ui.set_visible(uv0.editerField, slot0)
	ui.set_visible(uv0.confirmer, slot0)
	ui.set_visible(uv0.canceller, slot0)
	ui.set_visible(uv0.remover, slot0)
end

ui.set_callback(slot36.plistSaver, function ()
	uv2(uv1.SteamID(entity.get_steam64(ui.get(uv0))), "From player list")
	uv3()
end)
ui.set_callback(slot36.editer, function ()
	if not ui.get(uv0.listBox) then
		return
	end

	uv1(true)
end)
ui.set_callback(ui.new_button("LUA", "B", "Copy IP to clipboard", function ()
end), function ()
	if not ui.get(uv0.listBox) then
		return
	end

	if tostring(uv1[ui.get(uv0.listBox) + 1].status[1]) and slot1 ~= "" then
		uv2.set(slot1)
		print("[TRACKER] Copied ip into clipboard: ", slot1)
	end
end)
ui.set_callback(slot36.confirmer, function ()
	for slot4, slot5 in ipairs(uv1) do
		if slot4 == ui.get(uv0.listBox) + 1 then
			slot5.note = #ui.get(uv2.editerField) == 0 and "Unknown" or tostring(ui.get(uv2.editerField))

			print("[TRACKER] Successfully changed nickname for " .. slot5.steamid)
			uv3()
			ui.set(uv2.editerField, "")
		end
	end

	uv4(false)
end)
ui.set_callback(slot36.canceller, function ()
	uv0(false)
	ui.set(uv1.editerField, "")
end)
ui.set_callback(slot36.remover, function ()
	if not ui.get(uv0.listBox) then
		return
	end

	ui.set(uv0.listBox, 0)
	uv1(ui.get(uv0.listBox) + 1)
	uv2()
	uv3(false)
	ui.set(uv4.editerField, "")
end)
ui.set_callback(slot36.adder, function ()
	if not ui.get(uv0.listBox) then
		return
	end

	slot0 = ui.get(uv0.listBox) + 1
	uv1[slot0].expiry = nil
	uv1[slot0].lastseen = 0

	print(("[TRACKER] successfully added %s as permanent target"):format(uv1[slot0].note))
	uv2()
end)
ui.set_callback(ui.new_button("LUA", "B", "Join server", function ()
end), function ()
	if not ui.get(uv0.listBox) then
		return
	end

	uv2.GameInterfaceAPI.ConsoleCommand("connect " .. uv1[ui.get(uv0.listBox) + 1].status[1]:match("(%d+%.%d+%.%d+%.%d+:%d+)"))
end)
ui.set_callback(ui.new_button("LUA", "B", "Watch game", function ()
end), function ()
	if not ui.get(uv0.listBox) then
		return
	end

	uv2.FriendsListAPI.ActionWatchFriendSession(uv1[ui.get(uv0.listBox) + 1].steamid)
end)
ui.set_callback(slot10.dataExport, function ()
	slot0 = {}

	for slot4, slot5 in ipairs(uv0) do
		if not slot5.expiry then
			table.insert(slot0, {
				slot5.steamid,
				slot5.note
			})
		end
	end

	uv1.set(uv2.stringify(slot0))
	print(("[TRACKER] successfully exported %d %s into clipboard"):format(#uv0, #uv0 == 1 and "player" or "players"))
end)
ui.set_callback(slot10.dataImport, function ()
	if not uv0.get() then
		print("Error importing: clipboard is empty")
	end

	slot1, slot2 = pcall(json.parse, slot0)

	if slot1 and slot0:sub(1, 1) ~= "[" and slot0:sub(1, 1) ~= "{" then
		slot2 = "Expected object or array"
		slot1 = false
	end

	if not slot1 then
		print("Failed to import: " .. string.format("Invalid JSON: %s", slot2))

		return
	end

	for slot6, slot7 in ipairs(slot2) do
		uv1(slot7[1], slot7[2], false)
	end

	print(("[TRACKER] successfully imported %d %s"):format(#slot2, #slot2 == 1 and "player" or "players"))
end)
ui.set_callback(slot10.deleteData, function ()
	uv0 = {}

	uv1()
	uv2()
	print("[TRACKER] successfully removed all players")
end)
ui.set_callback(ui.new_checkbox("LUA", "B", "Player tracker"), function ()
	for slot4, slot5 in pairs(uv1) do
		ui.set_visible(slot5, ui.get(uv0))
	end

	for slot4, slot5 in pairs(uv2) do
		ui.set_visible(slot5, slot0)
	end

	for slot4, slot5 in pairs(uv3) do
		ui.set_visible(slot5, slot0)
	end

	ui.set_visible(uv4, slot0)
	ui.set_visible(uv5, slot0)
	ui.set_visible(uv6, slot0)

	if slot0 then
		uv7(false)
		uv8()
		uv9()
	end

	if #uv10 == 0 then
		for slot4, slot5 in pairs(uv1) do
			ui.set_visible(slot5, slot0)
		end

		for slot4, slot5 in pairs(uv2) do
			ui.set_visible(slot5, false)
		end

		for slot4, slot5 in pairs(uv3) do
			ui.set_visible(slot5, false)
		end

		ui.set_visible(uv4, false)
		ui.set_visible(uv5, false)
		ui.set_visible(uv6, false)
		ui.set_visible(uv1.listBox, slot0)
		ui.set_visible(uv3.plistSaver, slot0)

		if slot0 then
			uv9()
		end
	end
end)
ui.set_callback(slot10.manageData, function ()
	slot0 = ui.get(uv0.manageData)

	ui.set_visible(uv0.dataExport, slot0)
	ui.set_visible(uv0.dataImport, slot0)
	ui.set_visible(uv0.deleteData, slot0)
end)

function slot41()
	uv0()
	uv1()
	uv2()
	uv3()
end

slot41()
client.set_event_callback("post_config_load", slot41)
