slot0 = bit.band
slot1 = client.set_event_callback
slot2 = entity.get_bounding_box
slot3 = entity.get_local_player
slot4 = entity.get_players
slot5 = entity.get_prop
slot6 = entity.hitbox_position
slot7 = entity.is_alive
slot8 = math.ceil
slot9 = math.pow
slot10 = math.sqrt
slot11 = renderer.line
slot12 = renderer.text
slot13 = renderer.world_to_screen
slot14 = ui.get

function slot17(slot0, slot1, slot2)
	return {
		x = slot0 or 0,
		y = slot1 or 0,
		z = slot2 or 0
	}
end

function slot18(slot0, slot1, slot2, slot3, slot4, slot5)
	return uv0(uv1(uv2(slot0 - slot3, 2) + uv2(slot1 - slot4, 2) + uv2(slot2 - slot5, 2)))
end

function slot19(slot0, slot1)
	if slot0 == nil then
		return
	end

	if slot1 == nil then
		return
	end

	if uv0(uv0(slot0, "m_hActiveWeapon"), "m_iItemDefinitionIndex") == nil then
		return
	end

	slot4 = uv2(uv0(slot0, "m_vecOrigin"))
	slot5 = uv2(uv0(slot1, "m_vecOrigin"))
	slot6 = uv3(slot4.x, slot4.y, slot4.z, slot5.x, slot5.y, slot5.z)

	if uv1(slot2, 65535) ~= 64 or not (uv0(slot1, "m_ArmorValue") == 0) then
		return 0
	end

	if slot6 < 585 and slot6 > 511 then
		return 1
	elseif slot6 < 511 then
		return 2
	else
		return 0
	end
end

function slot20(slot0, slot1)
	slot2, slot3, slot4, slot5, slot6 = uv0(slot0)

	if slot2 == nil or slot6 == 0 then
		return
	end

	if slot1 == 1 then
		uv1(slot2 / 2 + slot4 / 2, slot3 - 20 + (name == "" and -8 or 0), 255, 0, 0, 255, "cb", 0, "DMG")
	else
		uv1(slot7, slot3 - 20 + slot8, 50, 205, 50, 255, "cb", 0, "DMG+")
	end
end

function slot21()
	if not uv0(uv1) then
		return
	end

	if uv2() == nil then
		return
	end

	if not uv3(slot0) then
		return
	end

	if #uv4(true) == nil or #slot1 == 0 then
		return
	end

	for slot5 = 1, #slot1 do
		if slot1[slot5] ~= nil and slot6 ~= uv2() then
			slot7 = uv5(uv6(slot6, 13))
			slot8 = uv5(uv6(slot0, 3))
			slot9, slot10 = uv7(slot7.x, slot7.y, slot7.z)
			slot11, slot12 = uv7(slot8.x, slot8.y, slot8.z)
			slot14 = uv8(slot6, slot0)

			if uv8(slot0, slot6) ~= 0 and slot13 ~= nil then
				uv9(slot6, slot13)
			end

			if slot14 ~= 0 and slot14 ~= nil and slot9 ~= nil and slot11 ~= nil and slot10 ~= nil and slot12 ~= nil then
				uv10(slot9, slot10, slot11, slot12, 255, 0, 0, 255)
			end
		end
	end
end

ui.set_callback(ui.new_checkbox("lua", "a", "Enable revolver helper"), function (slot0)
	if ui.get(slot0) then
		client.set_event_callback("paint", uv0)
	else
		client.unset_event_callback("paint", uv0)
	end
end)
