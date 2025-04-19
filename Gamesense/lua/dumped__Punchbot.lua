slot0 = client.eye_position
slot1 = client.camera_angles
slot2 = client.visible
slot3 = client.trace_line
slot4 = renderer.text
slot5 = renderer.world_to_screen
slot6 = entity.get_prop
slot7 = entity.get_all
slot8 = entity.get_local_player
slot9 = math.deg
slot10 = math.atan2
slot11 = math.sqrt
slot12 = math.pow
slot13 = ui.get
slot14 = ui.new_checkbox
slot16 = entity.get_player_resource
slot17 = entity.get_classname
slot18 = entity.get_prop
slot19 = entity.get_origin
slot20 = entity.get_local_player
slot21 = table.insert
slot22 = entity.get_player_weapon
slot23 = bit.band
slot24 = entity.hitbox_position
slot25 = entity.is_enemy
slot26 = slot14("Misc", "Miscellaneous", "Punchbot")
slot27 = ui.new_hotkey("Misc", "Miscellaneous", "Punchbot", true)
slot28 = slot14("Misc", "Miscellaneous", "Punchbot Silent aim")
slot29 = slot14("Misc", "Miscellaneous", "Punchbot Ignore Team Check")
slot30 = require("vector")

function slot31()
	slot1 = {}

	for slot6 = 1, 64 do
		if uv2(slot6) == "CCSPlayer" and uv3(uv0(), "m_bAlive", slot6) == 1 and uv1() ~= slot6 then
			if not uv4(uv5) and uv6(slot6) then
				uv7(slot1, slot6)
			elseif slot7 then
				uv7(slot1, slot6)
			end
		end
	end

	if #slot1 ~= 0 then
		slot4 = nil

		for slot9 = 1, #slot1 do
			if uv8(uv9(slot2)):dist(uv8(uv9(slot1[slot9]))) < 999999999 then
				slot5 = slot12
				slot4 = slot10
			end
		end

		if slot4 ~= nil and slot5 ~= 999999999 then
			for slot9 = 0, 18 do
				slot11 = uv8(uv10())
				slot12 = uv8(uv11(slot4, slot9))
				slot13 = slot11:dist(slot12)
				slot14, slot15 = uv12(uv1(), slot11.x, slot11.y, slot11.z, slot12.x, slot12.y, slot12.z)

				if slot15 ~= slot4 then
					slot13 = 999999
				end

				if slot13 < 80 then
					return slot12
				end
			end
		end
	end

	return nil
end

client.set_event_callback("setup_command", function (slot0)
	if not uv0() or uv1(slot1, "m_lifeState") ~= 0 then
		return
	end

	if not uv2(slot1) then
		return
	end

	if uv4(uv5) and uv3(uv1(slot2, "m_iItemDefinitionIndex"), 65535) == 69 and uv6() ~= nil then
		slot0.pitch, slot0.yaw = uv7(uv8()):to(slot4):angles()

		if uv4(uv9) then
			if uv4(uv10) then
				slot0.in_attack = 1
			else
				uv11(slot6, slot7)

				slot0.in_attack = 1
			end
		end
	end
end)
