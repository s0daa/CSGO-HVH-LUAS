local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/steamworks")
local var_0_2 = var_0_0.typeof("char[?]")
local var_0_3 = vtable_bind("steamclient.dll", "SteamClient017", 9, "uintptr_t*(__thiscall*)(void*, int, const char*)")
local var_0_4 = vtable_thunk(32, "int(__thiscall*)(void*, char*, uint32_t, const char*, bool)")
local var_0_5 = var_0_3(1, "SteamUtils009")

if var_0_5 == nil then
	return error("failed to get ISteamUtils")
end

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:len() + 1
	local var_1_1 = var_0_2(var_1_0)
	local var_1_2 = var_0_4(var_0_5, var_1_1, var_1_0, arg_1_0, arg_1_1)

	return var_0_0.string(var_1_1, var_1_0 - 1), var_1_2
end

local var_0_7 = ui.new_checkbox("LUA", "B", "Bypass Chat Filter")
local var_0_8 = {
	i = "į",
	y = "ỵ",
	H = "Ḥ",
	X = "Ẋ",
	h = "ḥ",
	x = "ẋ",
	G = "Ġ",
	W = "Ẉ",
	g = "ġ",
	w = "ẉ",
	F = "Ḟ",
	V = "Ṿ",
	f = "ḟ",
	v = "ṿ",
	E = "Ẹ",
	U = "Ụ",
	e = "ẹ",
	u = "ụ",
	D = "Ḍ",
	T = "Ṭ",
	d = "ḍ",
	t = "ṭ",
	C = "Ċ",
	S = "Ṣ",
	c = "ċ",
	s = "ṣ",
	R = "Ṛ",
	b = "ḃ",
	r = "ṛ",
	A = "Ȧ",
	Q = "Ɋ",
	a = "ȧ",
	n = "ṇ",
	q = "ɋ",
	B = "Ḃ",
	P = "Ṗ",
	p = "ṗ",
	O = "Ȯ",
	o = "ȯ",
	N = "Ṇ",
	M = "Ṃ",
	m = "ṃ",
	L = "Ḷ",
	l = "ḷ",
	K = "Ḳ",
	k = "ḳ",
	J = "Ĵ",
	Z = "Ẓ",
	j = "ĵ",
	z = "ẓ",
	I = "Į",
	Y = "Ỵ"
}
local var_0_9 = "‌​"
local var_0_10 = " "
local var_0_11 = {
	MyPersonaAPI = panorama.open().MyPersonaAPI,
	PartyListAPI = panorama.open().PartyListAPI
}

local function var_0_12(arg_2_0)
	local var_2_0 = {}

	for iter_2_0 in arg_2_0:gmatch("[^%s]+") do
		local var_2_1, var_2_2 = var_0_6(iter_2_0, false)

		if var_2_2 > 0 and iter_2_0:len() > 1 then
			local var_2_3 = iter_2_0:sub(3, 3)

			var_2_3 = var_0_8[var_2_3] or var_2_3
			iter_2_0 = iter_2_0:sub(1, 2) .. var_2_3 .. iter_2_0:sub(4, -1)
		end

		table.insert(var_2_0, iter_2_0)
	end

	var_0_11.PartyListAPI.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", var_0_11.MyPersonaAPI.GetXuid(), table.concat(var_2_0, var_0_10)))
end

client.set_event_callback("console_input", function(arg_3_0)
	if arg_3_0:sub(1, #"party_say") == "party_say" then
		arg_3_0 = arg_3_0:sub(#"party_say" + 2, -1)

		var_0_12(arg_3_0)

		return true
	end
end)
client.set_event_callback("string_cmd", function(arg_4_0)
	if not ui.get(var_0_7) then
		return
	end

	local var_4_0, var_4_1 = arg_4_0.text:match("^(.-) (.+)$")

	if (var_4_0 == "say" or var_4_0 == "say_team") and var_4_1 ~= nil then
		local var_4_2 = false
		local var_4_3 = {}

		if var_4_1:find("\"", 1) and var_4_1:find("\"", -1) then
			var_4_1 = var_4_1:sub(2, -2)
		end

		for iter_4_0 in var_4_1:gmatch("[^%s]+") do
			local var_4_4, var_4_5 = var_0_6(iter_4_0, false)

			if var_4_5 > 0 and iter_4_0:len() > 1 then
				var_4_2 = true

				local var_4_6 = iter_4_0:len() > 2 and 3 or 2
				local var_4_7 = iter_4_0:sub(var_4_6, var_4_6)

				var_4_7 = var_0_8[var_4_7] or var_4_7
				iter_4_0 = iter_4_0:sub(1, var_4_6 - 1) .. var_4_7 .. iter_4_0:sub(var_4_6 + 1, -1)
			end

			table.insert(var_4_3, iter_4_0)
		end

		if var_4_2 then
			arg_4_0.text = var_4_0 .. " " .. table.concat(var_4_3, " ")
		end
	end
end)
