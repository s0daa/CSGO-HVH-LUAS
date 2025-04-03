local var_0_0 = require("gamesense/steamworks").ISteamMatchmaking
local var_0_1 = panorama.open()

MyPersonaAPI = var_0_1.MyPersonaAPI
PartyListAPI = var_0_1.PartyListAPI

local var_0_2 = panorama.loadstring("    let _ActionInviteFriend = FriendsListAPI.ActionInviteFriend;\n    let Invites = [];\n    \n    FriendsListAPI.ActionInviteFriend = (xuid)=>{\n        if ( !LobbyAPI.CreateSession() ) {\n            LobbyAPI.CreateSession();\n            PartyListAPI.SessionCommand('MakeOnline', '');\n        }\n        Invites.push(xuid);\n    };\n\n    return {\n        get: ()=>{\n            let inviteCache = Invites;\n            Invites = [];\n            return inviteCache;\n        },\n        old: (xuid)=>{\n            _ActionInviteFriend(xuid);\n        },\n        shutdown: ()=>{\n            FriendsListAPI.ActionInviteFriend = _ActionInviteFriend;\n        }\n    }\n")()
local var_0_3 = ui.new_checkbox("Misc", "Miscellaneous", "Silent Invites")

local function var_0_4(arg_1_0)
	local var_1_0 = var_0_0.GetLobbyID()

	if var_1_0 ~= nil then
		if not ui.get(var_0_3) then
			PartyListAPI.SessionCommand("Game::ChatInviteMessage", string.format("run all xuid %s %s %s", MyPersonaAPI.GetXuid(), "friend", arg_1_0))
		end

		var_0_0.InviteUserToLobby(var_1_0, arg_1_0)
	else
		client.delay_call(0.1, var_0_4, arg_1_0)
	end
end

local function var_0_5()
	local var_2_0 = var_0_2.get()

	for iter_2_0 = 0, var_2_0.length - 1 do
		var_0_4(var_2_0[iter_2_0])
	end

	client.delay_call(0.05, var_0_5)
end

var_0_5()
client.set_event_callback("shutdown", function()
	var_0_2.shutdown()
end)
