slot0 = require("bit")
slot1 = require("gamesense/uilib")
slot2 = require("vector")
slot3 = entity.get_origin
slot4 = 31
slot5 = slot1.new_checkbox("RAGE", "Other", "Melee magnet")

function slot7(slot0)
	slot2, slot3 = nil

	for slot8 = 1, #entity.get_players(true) do
		if uv0(uv1(slot4[slot8])):distsqr(slot0) < 40000 and not plist.get(slot9, "Add to whitelist") then
			slot1 = slot11
			slot2 = slot9
			slot3 = slot10
		end
	end

	return slot2, slot3
end

slot5:add_event_callback("setup_command", function (slot0)
	if entity.get_player_weapon(entity.get_local_player()) then
		slot4, slot5 = uv1(uv0(client.eye_position()))

		if slot4 then
			slot6, slot7 = client.trace_line(slot1, slot3.x, slot3.y, slot3.z, slot5.x, slot5.y, slot5.z)

			if slot6 >= 1 or slot7 == slot4 then
				slot8, slot0.move_yaw = slot3:to(slot5):angles()

				if entity.get_classname(slot2) == "CKnife" and uv2:contains("Knife magnet") then
					if uv3.band(entity.get_prop(slot1, "m_fFlags"), 1) ~= 1 then
						slot0.forwardmove = 450
					end
				elseif entity.get_prop(slot2, "m_iItemDefinitionIndex") == uv4 and uv2:contains("Zeus magnet") then
					slot0.move_yaw = slot9
					slot0.forwardmove = 450
				end

				if entity.get_player_weapon(slot4) and entity.get_classname(slot10) == "CKnife" and uv2:contains("Forwards AA on knife") then
					slot0.yaw = slot9
					slot0.pitch = 89
				end
			end
		end
	end
end)
slot1.new_multiselect("RAGE", "Other", "Melee magnet options", "Zeus magnet", "Knife magnet", "Forwards AA on knife"):set_parent(slot5)
slot5:invoke()
