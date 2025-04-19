slot1 = require("gamesense/steamworks").ISteamMatchmaking
slot2 = panorama.open()
MyPersonaAPI = slot2.MyPersonaAPI
PartyListAPI = slot2.PartyListAPI
slot3 = panorama.loadstring([[
    let _ActionInviteFriend = FriendsListAPI.ActionInviteFriend;
    let Invites = [];
    
    FriendsListAPI.ActionInviteFriend = (xuid)=>{
        if ( !LobbyAPI.CreateSession() ) {
            LobbyAPI.CreateSession();
            PartyListAPI.SessionCommand('MakeOnline', '');
        }
        Invites.push(xuid);
    };

    return {
        get: ()=>{
            let inviteCache = Invites;
            Invites = [];
            return inviteCache;
        },
        old: (xuid)=>{
            _ActionInviteFriend(xuid);
        },
        shutdown: ()=>{
            FriendsListAPI.ActionInviteFriend = _ActionInviteFriend;
        }
    }
]])()
slot4 = ui.new_checkbox("Misc", "Miscellaneous", "Silent Invites")

function slot5(slot0)
	if uv0.GetLobbyID() ~= nil then
		if not ui.get(uv1) then
			PartyListAPI.SessionCommand("Game::ChatInviteMessage", string.format("run all xuid %s %s %s", MyPersonaAPI.GetXuid(), "friend", slot0))
		end

		uv0.InviteUserToLobby(slot1, slot0)
	else
		client.delay_call(0.1, uv2, slot0)
	end
end

function ()
	for slot4 = 0, uv0.get().length - 1 do
		uv1(slot0[slot4])
	end

	client.delay_call(0.05, uv2)
end()
client.set_event_callback("shutdown", function ()
	uv0.shutdown()
end)
