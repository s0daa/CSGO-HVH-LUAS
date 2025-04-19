slot0 = ui.new_checkbox("MISC", "Miscellaneous", "Auto plant")
slot1 = ui.new_hotkey("MISC", "Miscellaneous", "Auto plant hotkey", true)
slot2 = nil

client.set_event_callback("setup_command", function (slot0)
	if not ui.get(uv0) then
		return
	end

	slot1 = entity.get_local_player()

	if (slot0.in_use == 1 or slot0.in_attack == 1 or ui.get(uv1)) and entity.get_classname(entity.get_player_weapon(slot1)) == "CC4" then
		if (entity.get_prop(slot1, "m_bInBombZone") == 1 and bit.band(entity.get_prop(slot1, "m_fFlags"), 1) == 1) == false or uv2 == false then
			slot0.in_attack = 0
			slot0.in_use = 0
		elseif slot2 then
			slot0.in_attack = 1
		end

		uv2 = slot2
	else
		uv2 = nil
	end
end)
