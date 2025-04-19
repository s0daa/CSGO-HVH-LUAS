slot1 = require("bit").band
slot2 = entity.get_prop
slot3 = entity.get_players
slot4 = entity.is_enemy
slot5 = client.exec

client.set_event_callback("round_freeze_end", function (slot0)
	if uv0() == nil then
		return
	end

	for slot5 = 1, #slot1 do
		if not uv1(slot1[slot5]) and uv2(slot6, "m_fFlags") and uv3(slot7, 512) == 512 then
			uv4("holdpos")

			return
		end
	end
end)
