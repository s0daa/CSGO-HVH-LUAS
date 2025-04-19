slot0 = entity.get_prop
slot1 = ui.get
slot2 = math.sqrt
slot3 = math.sin
slot5 = entity.get_local_player
slot6 = entity.get_players
slot7 = entity.get_player_name
slot8 = client.screen_size
slot9 = renderer.text
slot11 = math.cos(math.rad(10))

function slot13(slot0, slot1, slot2)
	if uv0(slot0 * slot0 + slot1 * slot1 + slot2 * slot2) == 0 then
		return 0, 0, 0
	end

	slot4 = 1 / slot3

	return slot0 * slot4, slot1 * slot4, slot2 * slot4
end

function slot14(slot0, slot1, slot2, slot3, slot4, slot5)
	return slot0 * slot3 + slot1 * slot4 + slot2 * slot5
end

function slot15(slot0, slot1)
	slot2 = uv0(slot0)
	slot3 = uv0(slot1)
	slot5 = uv2(slot2)

	return slot5 * uv2(slot3), slot5 * uv1(slot3), -uv1(slot2)
end

function slot16(slot0, slot1, slot2, slot3)
	slot4, slot5 = uv0(slot0, "m_angEyeAngles")

	if slot4 == nil then
		return false
	end

	slot6, slot7, slot8 = uv1(slot4, slot5)
	slot9, slot10, slot11 = uv0(slot0, "m_vecOrigin")

	if slot9 == nil then
		return false
	end

	slot12, slot13, slot14 = uv2(slot1 - slot9, slot2 - slot10, slot3 - slot11)

	return uv4 < uv3(slot12, slot13, slot14, slot6, slot7, slot8)
end

function slot17()
	if uv0() == nil then
		return false, nil
	end

	slot1, slot2, slot3 = uv1(slot0, "m_vecOrigin")

	if slot1 == nil then
		return false, nil
	end

	for slot8 = 1, #uv2(true) do
		if uv3(slot4[slot8], slot1, slot2, slot3) then
			return true, uv4(slot0) or "An enemy"
		end
	end

	return false, nil
end

function slot18()
	slot0, slot1 = uv0()

	if slot0 then
		slot2, slot3 = uv1()

		uv2(slot2 / 2, slot3 - 100, 255, 255, 50, 255, "c+", 0, slot1, " is aiming in your direction")
	end
end

ui.set_callback(ui.new_checkbox("VISUALS", "Other ESP", "Show threats"), function (slot0)
	if uv0(slot0) then
		client.set_event_callback("paint", uv1)
	else
		client.unset_event_callback("paint", uv1)
	end
end)
