slot0 = require("gamesense/chat")
slot1 = require("gamesense/localize")
slot3 = panorama.open().GameStateAPI
slot4 = {}

function slot5(slot0)
	if not entity.is_enemy(client.userid_to_entindex(slot0.userid)) then
		return
	end

	if uv0.IsSelectedPlayerMuted(uv0.GetPlayerXuidStringFromEntIndex(slot1)) then
		return
	end

	if cvar.cl_mute_enemy_team:get_int() == 1 then
		return
	end

	if cvar.cl_mute_all_but_friends_and_party:get_int() == 1 then
		return
	end

	client.delay_call(0.2, function ()
		if uv0[uv1] ~= nil and math.abs(globals.realtime() - uv0[uv1]) < 0.4 then
			return
		end

		slot1 = entity.get_prop(uv1, "m_szLastPlaceName")

		uv4.print_player(uv1, uv2(("Cstrike_Chat_%s_%s"):format(entity.get_prop(entity.get_player_resource(), "m_iTeam", uv1) == 2 and "T" or "CT", entity.is_alive(uv1) and "Loc" or "Dead"), {
			s1 = entity.get_player_name(uv1),
			s2 = uv3.text,
			s3 = uv2(slot1 ~= "" and slot1 or "UI_Unknown")
		}))
	end)
end

function slot6(slot0)
	if not entity.is_enemy(slot0.entity) then
		return
	end

	uv0[slot0.entity] = globals.realtime()
end

ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Reveal enemy teamchat"), function ()
	slot0 = ui.get(uv0) and client.set_event_callback or client.unset_event_callback

	slot0("player_say", uv1)
	slot0("player_chat", uv2)
end)
