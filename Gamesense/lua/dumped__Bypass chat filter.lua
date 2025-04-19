slot1 = require("gamesense/steamworks")
slot2 = require("ffi").typeof("char[?]")
slot4 = vtable_thunk(32, "int(__thiscall*)(void*, char*, uint32_t, const char*, bool)")

if vtable_bind("steamclient.dll", "SteamClient017", 9, "uintptr_t*(__thiscall*)(void*, int, const char*)")(1, "SteamUtils009") == nil then
	return error("failed to get ISteamUtils")
end

function slot6(slot0, slot1)
	slot2 = slot0:len() + 1
	slot3 = uv0(slot2)

	return uv3.string(slot3, slot2 - 1), uv1(uv2, slot3, slot2, slot0, slot1)
end

slot7 = ui.new_checkbox("LUA", "B", "Bypass Chat Filter")
slot8 = {
	B = "Ḃ",
	h = "ḥ",
	i = "į",
	P = "Ṗ",
	b = "ḃ",
	p = "ṗ",
	A = "Ȧ",
	O = "Ȯ",
	q = "ɋ",
	o = "ȯ",
	Q = "Ɋ",
	N = "Ṇ",
	r = "ṛ",
	R = "Ṛ",
	M = "Ṃ",
	s = "ṣ",
	m = "ṃ",
	S = "Ṣ",
	L = "Ḷ",
	t = "ṭ",
	l = "ḷ",
	T = "Ṭ",
	z = "ẓ",
	Z = "Ẓ",
	n = "ṇ",
	Y = "Ỵ",
	y = "ỵ",
	X = "Ẋ",
	G = "Ġ",
	x = "ẋ",
	g = "ġ",
	W = "Ẉ",
	F = "Ḟ",
	w = "ẉ",
	f = "ḟ",
	V = "Ṿ",
	E = "Ẹ",
	v = "ṿ",
	e = "ẹ",
	U = "Ụ",
	D = "Ḍ",
	u = "ụ",
	d = "ḍ",
	K = "Ḳ",
	C = "Ċ",
	k = "ḳ",
	c = "ċ",
	J = "Ĵ",
	j = "ĵ",
	I = "Į",
	a = "ȧ",
	H = "Ḥ"
}
slot9 = "‌​"
slot10 = " "
slot11 = {
	MyPersonaAPI = panorama.open().MyPersonaAPI,
	PartyListAPI = panorama.open().PartyListAPI
}

function slot12(slot0)
	slot1 = {}

	for slot5 in slot0:gmatch("[^%s]+") do
		slot6, slot7 = uv0(slot5, false)

		if slot7 > 0 and slot5:len() > 1 then
			slot5 = slot5:sub(1, 2) .. (uv1[slot5:sub(3, 3)] or slot8) .. slot5:sub(4, -1)
		end

		table.insert(slot1, slot5)
	end

	uv2.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", uv2.MyPersonaAPI.GetXuid(), table.concat(slot1, uv3)))
end

client.set_event_callback("console_input", function (slot0)
	if slot0:sub(1, #"party_say") == "party_say" then
		uv0(slot0:sub(#"party_say" + 2, -1))

		return true
	end
end)
client.set_event_callback("string_cmd", function (slot0)
	if not ui.get(uv0) then
		return
	end

	slot1, slot2 = slot0.text:match("^(.-) (.+)$")

	if (slot1 == "say" or slot1 == "say_team") and slot2 ~= nil then
		slot3 = false
		slot4 = {}

		if slot2:find("\"", 1) and slot2:find("\"", -1) then
			slot2 = slot2:sub(2, -2)
		end

		for slot8 in slot2:gmatch("[^%s]+") do
			slot9, slot10 = uv1(slot8, false)

			if slot10 > 0 and slot8:len() > 1 then
				slot3 = true
				slot11 = slot8:len() > 2 and 3 or 2
				slot8 = slot8:sub(1, slot11 - 1) .. (uv2[slot8:sub(slot11, slot11)] or slot12) .. slot8:sub(slot11 + 1, -1)
			end

			table.insert(slot4, slot8)
		end

		if slot3 then
			slot0.text = slot1 .. " " .. table.concat(slot4, " ")
		end
	end
end)
