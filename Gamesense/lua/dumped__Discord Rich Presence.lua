slot0 = require("gamesense/named_pipes")
slot2 = require("ffi").cast
slot3 = vtable_bind("engine.dll", "VEngineClient014", 26, "bool(__thiscall*)(void*)")
slot4 = vtable_bind("engine.dll", "VEngineClient014", 27, "bool(__thiscall*)(void*)")
slot5 = vtable_bind("engine.dll", "VEngineClient014", 28, "bool(__thiscall*)(void*)")
slot6 = 0
slot7 = 1
slot8 = 2
slot9 = 3
slot10 = 4
slot11 = {
	join_request = "ACTIVITY_JOIN_REQUEST",
	spectate_game = "ACTIVITY_SPECTATE",
	join_game = "ACTIVITY_JOIN"
}
slot12 = {
	ERRORED = "error"
}

function slot13(slot0, slot1)
	if slot0 == slot1 then
		return true
	elseif type(slot0) == "table" and type(slot1) == "table" then
		for slot5, slot6 in pairs(slot0) do
			if slot1[slot5] == nil then
				return false
			elseif slot6 ~= slot7 then
				if type(slot6) == "table" and type(slot7) == "table" then
					if not uv0(slot6, slot7) then
						return false
					end
				else
					return false
				end
			end
		end

		for slot5, slot6 in pairs(slot1) do
			if slot0[slot5] == nil then
				return false
			end
		end

		return true
	end

	return false
end

function slot14(slot0, ...)
	for slot5 = 1, #{
		...
	} do
		if slot0 == nil then
			return nil
		end

		slot0 = slot0[slot1[slot5]]
	end

	return slot0 or nil
end

function slot15()
	return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function (slot0)
		return string.format("%x", slot0 == "x" and math.random(0, 15) or math.random(8, 11))
	end)
end

function slot16(slot0)
	return uv0.string(uv0.cast("const char*", uv0.new("uint32_t[1]", slot0)), 4)
end

function slot17(slot0)
	return tonumber(uv0.cast("uint32_t*", uv0.cast("const char*", slot0))[0])
end

function slot18(slot0, slot1)
	return uv0(slot0) .. uv0(slot1:len()) .. slot1
end

function slot19(slot0)
	if slot0:read(8) == nil then
		return
	end

	slot2 = uv0(slot1:sub(1, 4))

	if slot0:read(uv0(slot1:sub(5, 8))) == nil then
		return
	end

	return slot2, json.parse(slot4)
end

slot20 = {}

function slot21(slot0, slot1, ...)
	if slot0.event_handlers[slot1] ~= nil then
		slot0.event_handlers[slot1](slot0, ...)
	end
end

function slot26(slot0)
	if slot0.timestamp_delta_max ~= nil and slot0.timestamp_delta_max > 0 then
		if type(uv0(slot0.activity, "timestamps", "start")) == "number" and type(uv0(slot0.activity_prev, "timestamps", "start")) == "number" and math.abs(slot0.activity_prev.timestamps.start - slot0.activity.timestamps.start) < slot0.timestamp_delta_max then
			slot0.activity.timestamps.start = slot0.activity_prev.timestamps.start
		end

		if type(uv0(slot0.activity, "timestamps", "end")) == "number" and type(uv0(slot0.activity_prev, "timestamps", "end")) == "number" and math.abs(slot0.activity_prev.timestamps["end"] - slot0.activity.timestamps["end"]) < slot0.timestamp_delta_max then
			slot0.activity.timestamps["end"] = slot0.activity_prev.timestamps["end"]
		end
	end

	if slot0.ready and not uv1(slot0.activity, slot0.activity_prev) then
		slot1 = nil

		if slot0.activity ~= nil and slot0.activity.assets ~= nil and (slot0.activity.assets.small_image ~= nil or slot0.activity.assets.large_image ~= nil) then
			slot1 = {
				small_image = slot0.activity.assets.small_image,
				large_image = slot0.activity.assets.large_image
			}
		end

		slot0:request("SET_ACTIVITY", {
			pid = 4,
			activity = slot0.activity
		}, nil, function (slot0, slot1)
			if uv0 ~= nil and slot1.evt == json.null then
				slot2 = false

				for slot6, slot7 in pairs(uv0) do
					if slot1.data.assets[slot6] == nil and not slot0.failed_images[slot7] then
						slot0.failed_images[slot7] = true

						uv1(slot0, "image_failed_to_load", slot7)
					end
				end
			end
		end)

		slot0.activity_prev = slot0.activity
	end
end

function slot27(slot0)
	if slot0.pipe == nil then
		return
	end

	for slot4 = 1, 100 do
		slot5, slot6, slot7 = pcall(uv0, slot0.pipe)

		if not slot5 then
			slot0.pipe = nil
			slot0.open = false
			slot0.ready = false

			uv1(slot0, "error", slot6)

			return
		elseif slot6 == nil then
			break
		elseif slot6 == uv2 and slot7.cmd == "DISPATCH" then
			if type(slot7.evt) == "string" then
				uv1(slot0, uv3[slot7.evt] or slot7.evt:lower(), slot7.data)

				if slot7.evt == "READY" then
					slot0:update_event_handlers()

					slot0.ready = true

					uv4(slot0)
				end
			end
		elseif slot6 == uv2 then
			if slot0.request_callbacks[slot7.nonce] ~= nil then
				slot0.request_callbacks[slot7.nonce] = nil

				slot8(slot0, slot7)
			end
		elseif slot6 == uv5 then
			uv6(slot0, uv7, "")
		elseif slot6 == uv8 then
			slot0.pipe = nil
			slot0.open = false
			slot0.ready = false

			uv1(slot0, "error", slot6)
		end
	end
end

client.set_event_callback("paint_ui", function ()
	for slot3 = 1, #uv0 do
		uv1(uv0[slot3])
	end
end)

slot30 = {
	__index = {
		connect = function (slot0)
			if slot0.pipe == nil then
				slot1, slot2, slot3 = nil

				for slot7 = 0, 10 do
					slot8, slot2 = pcall(uv0.open_pipe, "\\\\?\\pipe\\discord-ipc-" .. slot7)

					if slot8 then
						break
					end

					if slot3 == nil or slot2 ~= "Failed to open pipe: File not found" then
						slot3 = slot2
					end
				end

				if slot1 then
					slot0.pipe = slot2
					slot0.open = true
					slot0.ready = false

					slot0:write(uv1, string.format("{\"v\":1,\"client_id\":%s}", json.stringify(slot0.client_id)))
				else
					uv2(slot0, "failed", slot3:gsub("^Failed to open pipe: ", ""))
				end
			end
		end,
		close = function (slot0)
			if slot0.pipe ~= nil then
				slot0:write(uv0, string.format("{\"v\":1,\"client_id\":%s}", json.stringify(slot0.client_id)))

				slot1, slot2 = pcall(uv1.close_pipe, slot0.pipe)
				slot0.pipe = nil
				slot0.open = false
				slot0.ready = false

				uv2(slot0, "closed")

				if slot1 then
					return true
				end
			end

			return false
		end,
		request = function (slot0, slot1, slot2, slot3, slot4)
			slot8 = string.format("{\"cmd\":%s,%s%s\"nonce\":%s}", json.stringify(slot1), slot2 == nil and "" or string.format("\"args\":%s,", json.stringify(slot2)), slot3 == nil and "" or string.format("\"evt\":%s,", json.stringify(slot3)), json.stringify(uv0()))

			if slot4 ~= nil then
				slot0.request_callbacks[slot7] = slot4
			end

			slot0:write(uv1, slot8)
		end,
		write = function (slot0, slot1, slot2)
			if slot0.pipe ~= nil then
				slot3, slot4 = pcall(slot0.pipe.write, slot0.pipe, uv0(slot1, slot2))

				if not slot3 then
					slot0.pipe = nil
					slot0.open = false
					slot0.ready = false

					uv1(slot0, "error", slot4)
				else
					return true
				end
			end
		end,
		set_activity = function (slot0, slot1)
			slot0.activity = slot1

			uv0(slot0)
		end,
		update_event_handlers = function (slot0)
			for slot4, slot5 in pairs(uv0) do
				if not slot0.event_handlers_subscribed[slot4] and slot0.event_handlers[slot4] ~= nil then
					slot0:request("SUBSCRIBE", nil, slot5)

					slot0.event_handlers_subscribed[slot4] = true
				elseif slot0.event_handlers_subscribed[slot4] and slot0.event_handlers[slot4] == nil then
					slot0:request("UNSUBSCRIBE", nil, slot5)

					slot0.event_handlers_subscribed[slot4] = false
				end
			end
		end
	}
}
slot32 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
slot33 = vtable_thunk(1, "const char*(__thiscall*)(void*)")
slot34 = vtable_thunk(6, "bool(__thiscall*)(void*)")
slot35 = panorama.open()
slot36 = slot35.LobbyAPI
slot37 = slot35.PartyListAPI
slot38 = slot35.GameStateAPI
slot39 = slot35.FriendsListAPI
slot40 = 0
slot41 = 1
slot42 = 2
slot43 = 3
slot44 = 4
slot45 = 5
slot46 = panorama.loadstring([[
	return {
		localize: (str, params) => {
			if(params == null)
				return $.Localize(str)

			var panel = $.CreatePanel("Panel", $.GetContextPanel(), "")

			for(key in params) {
				panel.SetDialogVariable(key, params[key])
			}

			var result = $.Localize(str, panel)

			panel.DeleteAsync(0.0)

			return result
		}
	}
]])().localize
slot47 = {}

function slot48(slot0, slot1)
	if slot0 == nil then
		return ""
	end

	if uv0[slot0] == nil then
		uv0[slot0] = {}
	end

	if uv0[slot0][slot1 ~= nil and json.stringify(slot1) or true] == nil then
		uv0[slot0][slot2] = uv1(slot0, slot1)
	end

	return uv0[slot0][slot2]
end

slot49 = setmetatable({
	HauptmenÜ = "Im Hauptmenü",
	["Main Menu"] = "In Main Menu",
	Offline = "Local Server",
	["Practice With Bots"] = "Local Server",
	["Playing CS:GO"] = "In Game"
}, {
	__index = function (slot0, slot1)
		slot0[slot1] = slot1

		return slot1
	end
})
slot50 = panorama.loadstring("return Date.now()/1000")() - globals.realtime()

function slot51()
	return math.floor(uv0 + globals.realtime() + 0.5)
end

function slot52(slot0)
	for slot5 = 1, #slot0 do
	end

	return {
		[slot0[slot5]] = true
	}
end

function slot53(slot0)
	if slot0 == uv0.GetMapDisplayNameToken(slot0) then
		return slot0
	end

	return uv1(slot1)
end

function slot54(slot0)
	if slot0:find("ag_texture") then
		return "aim_ag_texture2"
	elseif slot0:find("dust2") then
		return "de_dust2"
	elseif slot0:find("dust") then
		return "de_dust"
	elseif slot0:find("mirage") then
		return "de_mirage"
	end

	return slot0:gsub("_scrimmagemap$", "")
end

function slot55(slot0)
	return slot0:sub(1, 1) .. slot0:sub(2, -1):lower()
end

function slot56(slot0)
	return slot0:gsub("%u%u+", uv0)
end

slot59 = ui.new_textbox("MISC", "Miscellaneous", "2nd Line Text")
slot60 = ui.new_label("MISC", "Miscellaneous", "Status: Not connected")
slot61 = ui.new_string("Discord RPC custom text")

function (slot0)
	if slot0 ~= nil then
		ui.set(uv0, "> " .. slot0)
		ui.set_visible(uv0, ui.get(uv1))
	else
		ui.set(uv0, "")
		ui.set_visible(uv0, false)
	end
end(nil)

slot63 = nil
slot64 = 0
slot65 = globals.realtime() + 5
slot66 = "^" .. slot48("SFUI_Scoreboard_ServerName", {
	s1 = "(.*)"
}) .. "$"
slot67 = slot48("SFUI_PlayMenu_Online"):gsub(".", function (slot0)
	return string.format("[%s%s]", slot0:lower(), slot0:upper())
end)

function slot69()
	uv0 = 0
end

slot63 = function (slot0, slot1)
	slot2 = setmetatable({
		ready = false,
		timestamp_delta_max = 300,
		client_id = slot0,
		event_handlers = {},
		event_handlers_subscribed = {},
		failed_images = {},
		request_callbacks = {}
	}, uv0)

	for slot6, slot7 in pairs(slot1) do
		slot2.event_handlers[slot6] = slot7
	end

	table.insert(uv1, slot2)

	return slot2
end("774277207451107398", {
	ready = function (slot0, slot1)
		uv0()
		uv1("Connected to " .. slot1.user.username .. "#" .. slot1.user.discriminator)
		client.delay_call(10, function ()
			if ui.get(uv0) == "> " .. uv1 then
				uv2(nil)
			end
		end)
	end,
	failed = function (slot0, slot1)
		if slot1 == "File not found" then
			uv0("Connection failed: Discord not found.")
		else
			uv0("Connection failed: " .. tostring(slot1))
		end

		uv1 = globals.realtime() + 5
	end,
	error = function (slot0, slot1)
		uv0 = globals.realtime() + 5

		uv1("Error: " .. slot1)
	end,
	join_game = function (slot0)
	end,
	join_request = function (slot0)
	end,
	spectate_game = function (slot0)
	end,
	image_failed_to_load = function ()
		slot1 = {
			instance = true,
			assets = {
				large_image = "csgo-logo2",
				large_text = "Counter-Strike: Global Offensive"
			}
		}

		if not uv0(ui.get(uv1))["Hide gamesense.pub"] then
			slot1.assets.small_image = "gamesense"
			slot1.assets.small_text = "gamesense.pub"
		end

		if globals.mapname() ~= nil then
			slot3 = uv2()
			slot4 = entity.get_game_rules()

			if slot0["Custom Text"] then
				if ui.get(uv3):gsub(" ", "") ~= "" then
					slot1.state = slot5
				end
			else
				slot1.state = uv4[uv5("SFUI_Lobby_StatusPlayingCSGO")]

				if slot3 ~= nil then
					if uv6(slot3) then
						slot1.state = uv4[uv5("play_setting_offline")]
					elseif uv7.IsDemoOrHltv() then
						slot1.state = uv5("SFUI_Lobby_StatusWatchingCSGO")
					elseif slot4 ~= nil and entity.get_prop(slot4, "m_bIsValveDS") == 1 then
						slot1.state = uv4[uv5("play_setting_online"):gsub(uv8, uv5("Panorama_Vote_Server"))]
					elseif uv7.GetServerName() ~= "" then
						slot1.state = uv7.GetServerName():match(uv9)
					end
				end
			end

			slot7, slot8 = nil

			if json.parse(tostring(uv7.GetTimeDataJSO())).gamephase == uv10 or slot5.gamephase == uv11 then
				slot1.details = string.format("%s [%s]", uv7.GetGameModeName(true), uv5("gamephase_" .. slot5.gamephase))

				if slot5.gamephase == uv10 and slot5.time ~= nil then
					slot8 = globals.curtime() - cvar.mp_warmuptime:get_float() + slot5.time + cvar.mp_warmuptime:get_float()
				end
			elseif slot5.gamephase == uv12 then
				slot11, slot12 = nil

				if entity.get_local_player() ~= nil and entity.get_prop(slot10, "m_iTeamNum") == 2 then
					if entity.get_prop(slot10, "m_iTeamNum") == 2 then
						slot12 = "CT"
						slot11 = "TERRORIST"
					elseif entity.get_prop(slot10, "m_iTeamNum") == 3 then
						slot12 = "TERRORIST"
						slot11 = "CT"
					end
				end

				slot13 = json.parse(tostring(uv7.GetScoreDataJSO()))

				if slot11 ~= nil then
					if slot13.teamdata[slot11].score == 0 and slot13.teamdata[slot12].score == 0 then
						if entity.get_player_resource() ~= nil then
							slot1.details = string.format("%s [ %d | %d | %d ]", slot9, entity.get_prop(slot16, "m_iKills", slot10) or 0, entity.get_prop(slot16, "m_iAssists", slot10) or 0, entity.get_prop(slot16, "m_iDeaths", slot10) or 0)
						end
					elseif slot14 ~= nil and slot15 ~= nil then
						slot1.details = string.format("%s [%d:%d %s]", slot9, slot14, slot15, uv5(slot14 == slot15 and "eom-result-tie2" or slot15 < slot14 and "eom-result-win2" or "eom-result-loss2"))
					end
				end

				if slot1.details == nil then
					slot1.details = string.format("%s [%s]", slot9, uv5("gamephase_5"))
				end
			elseif slot5.gamephase == uv13 or slot5.gamephase == uv14 or slot5.gamephase == uv15 then
				if slot5.roundtime <= slot5.roundtime_remaining then
					if entity.get_prop(slot4, "m_fRoundStartTime") ~= nil then
						slot7 = slot8 - cvar.mp_freezetime:get_float()
					end
				elseif slot5.roundtime_remaining < slot5.roundtime then
					slot7 = entity.get_prop(slot4, "m_fRoundStartTime") + 0.5
				end

				slot10 = nil
				slot12 = entity.get_local_player()

				if uv7.GetGameModeInternalName(true) == "casual" or slot11 == "competitive" or slot11 == "scrimcomp2v2" or slot11 == "demolition" then
					slot13 = json.parse(tostring(uv7.GetScoreDataJSO()))
					slot14 = "CT"
					slot15 = "TERRORIST"

					if slot12 ~= nil and entity.get_prop(slot12, "m_iTeamNum") == 2 then
						slot15 = "CT"
						slot14 = "TERRORIST"
					end

					if slot13.teamdata[slot14] ~= nil and slot13.teamdata[slot15] ~= nil then
						slot10 = string.format("%d : %d", slot13.teamdata[slot14].score, slot13.teamdata[slot15].score)
					end
				elseif entity.get_player_resource() ~= nil then
					slot10 = string.format("%d | %d | %d", entity.get_prop(slot13, "m_iKills", slot12) or 0, entity.get_prop(slot13, "m_iAssists", slot12) or 0, entity.get_prop(slot13, "m_iDeaths", slot12) or 0)
				end

				slot1.details = slot9 .. (slot10 and " [ " .. slot10 .. " ]" or "")
			end

			slot1.assets = {
				large_image = "map_" .. uv16(slot2),
				large_text = uv7.IsDemoOrHltv() and uv5("SFUI_Lobby_StatusWatchingCSGO") or uv5("matchdraft_final_map", {
					mapname = uv7.GetMapName()
				}),
				small_image = slot0["Hide gamesense.pub"] and "csgo-logo2" or "gamesense",
				small_text = slot0["Hide gamesense.pub"] and "Counter-Strike: Global Offensive" or "Using gamesense.pub"
			}

			if uv17.failed_images[slot1.assets.large_image] then
				slot1.assets.large_image = "bg_default"
			end

			if slot7 ~= nil then
				slot1.timestamps = {
					start = math.floor((uv18() - globals.curtime() + slot7) * 1000)
				}

				if slot8 ~= nil and slot7 < slot8 then
					slot1.timestamps["end"] = math.floor((slot11 + slot8) * 1000)
				end
			end
		elseif uv19() then
			slot1.state = uv5("LoadingProgress_Connecting")
		else
			slot1.details = uv4[uv20(uv5("SFUI_MAINMENU"))]

			if uv21.IsSessionActive() then
				if json.parse(tostring(uv21.GetSessionSettings())).system.network == "LIVE" then
					slot1.details = uv4[uv5("SFUI_Lobby_StatusInLobby")]
				end

				slot4 = uv21.GetMatchmakingStatusString()

				if slot3.system.network == "LIVE" or slot4 ~= nil and slot4 ~= "" then
					slot5 = slot3.game.mode ~= nil and uv5("SFUI_GameMode" .. slot3.game.mode) or uv4[uv20(uv5("SFUI_MAINMENU"))]

					if slot4 ~= nil and slot4 ~= "" then
						if ((slot4 ~= nil and uv5(slot4) or nil) == nil or slot6 == "") and slot3.game ~= nil and slot3.game.mmqueue ~= nil then
							slot6 = uv20(slot3.game.mmqueue)
						end

						slot1.state = string.format("%s - %s", slot5, slot6 or "")
						slot1.timestamps = {
							start = (uv18() - uv21.GetTimeSpentMatchmaking()) * 1000
						}

						if uv22.GetPartySessionSetting("game/mmqueue") == "reserved" or slot7 == "connect" then
							slot1.assets.large_image = uv22.GetPartySessionSetting("game/map") ~= nil and slot8 ~= "" and not slot8:find(",") and "map_" .. slot8 or "bg_blurry"
							slot1.assets.large_text = uv23(slot8)

							if uv17.failed_images[slot1.assets.large_image] then
								slot1.assets.large_image = "bg_blurry"
							end
						end
					else
						slot1.state = slot5
					end

					slot6 = 5

					if slot3.game.mode == "scrimcomp2v2" or slot3.game.mode == "cooperative" or slot3.game.mode == "coopmission" then
						slot6 = 2
					elseif slot3.game.mode == "survival" then
						slot6 = 2
					end

					if slot3.system.network == "LIVE" then
						slot1.party = {
							size = {
								uv22.GetCount(),
								slot6
							}
						}
					end
				end
			end
		end

		uv17:set_activity(slot1)
	end
})
slot70 = {
	paint_ui = function ()
		slot0 = globals.realtime()

		if not uv0.open and uv1 ~= nil and uv1 < slot0 then
			uv2("Connecting...")

			uv1 = slot0

			uv0:connect()
		elseif uv0.open and not uv0.ready and slot0 > uv1 + 150 then
			uv2("Connection timed out.")

			uv1 = uv1 + 150 + 30

			uv0:close()
		elseif uv0.open and uv0.ready and slot0 - uv3 > 1 then
			ui.set(uv4, ui.get(uv5))

			uv3 = slot0

			uv6()
		end
	end,
	player_death = slot69,
	bomb_planted = slot69,
	round_start = slot69,
	round_end = slot69,
	buytime_ended = slot69,
	cs_game_disconnected = slot69,
	cs_win_panel_match = slot69,
	cs_match_end_restart = slot69
}

function slot71()
	slot0 = ui.get(uv0)

	ui.set_visible(uv2, slot0)
	ui.set_visible(uv3, slot0 and uv1(ui.get(uv2))["Custom Text"])

	if not slot0 then
		ui.set_visible(uv4, false)
	end

	uv5()
end

ui.set_callback(ui.new_multiselect("MISC", "Miscellaneous", "Rich Presence Options", {
	"Custom Text",
	"Hide gamesense.pub"
}), slot71)
slot71()
ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Discord Rich Presence"), function ()
	slot0 = ui.get(uv0)

	for slot4, slot5 in pairs(uv1) do
		if slot0 then
			client.set_event_callback(slot4, slot5)
		else
			client.unset_event_callback(slot4, slot5)

			if uv2.open and uv2.ready then
				uv2:set_activity(nil)
			end
		end
	end

	if not slot0 and uv2 ~= nil then
		slot1 = uv3

		client.delay_call(60, function ()
			if not ui.get(uv0) and uv1.open and uv2 == uv3 then
				uv3 = globals.realtime() + 10

				uv1:close()
			end
		end)
	end

	uv4()
end)
client.set_event_callback("pre_config_save", function ()
	ui.set(uv0, ui.get(uv1))
end)
client.set_event_callback("post_config_load", function ()
	ui.set(uv0, ui.get(uv1) or "")
end)
client.delay_call(0, function ()
	ui.set(uv0, ui.get(uv1) or "")
end)
client.set_event_callback("shutdown", function ()
	if uv0.open then
		uv1(nil)
		uv0:close()
	end
end)
