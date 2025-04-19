slot1 = client.trace_bullet
slot2 = entity.get_local_player
slot3 = entity.get_prop
slot4 = entity.hitbox_position
slot5 = entity.is_alive
slot6 = entity.is_enemy

client.register_esp_flag("LETHAL", 255, 0, 0, function (slot0)
	if uv0(uv1()) and uv2(slot0) and #{
		uv3(slot0, "pelvis")
	} == 3 then
		slot2, slot3 = uv4(uv1(), slot1[1] - 1, slot1[2] - 1, slot1[3] - 1, slot1[1], slot1[2], slot1[3], true)

		return uv5(slot0, "m_iHealth") <= slot3
	end
end)
