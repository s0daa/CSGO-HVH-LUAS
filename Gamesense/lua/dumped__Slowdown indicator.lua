slot0 = client.screen_size
slot1 = entity.get_local_player
slot2 = entity.get_prop
slot3 = entity.is_alive
slot4 = globals.curtime
slot5 = math.abs
slot6 = math.floor
slot7 = renderer.indicator
slot8 = renderer.rectangle
slot9 = renderer.text
slot10 = string.format
slot11 = ui.get
slot13 = ui.reference
slot16 = require("gamesense/images").get_panorama_image("icons/ui/warning.svg")
slot18 = 0

function slot19(slot0)
	return 248 - 124 * slot0, 195 * slot0, 13
end

function slot20(slot0, slot1, slot2, slot3, slot4, slot5)
	slot3 = slot3 or 0

	if slot5 ~= false then
		slot6 = math.min(1, math.max(0, (slot0 - slot3) / ((slot4 or 1) - slot3)))
	end

	return slot1 + (slot2 - slot1) * slot6
end

function slot21(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
	slot8 = slot8 or 1

	uv0(slot0, slot1, slot2, slot8, slot4, slot5, slot6, slot7)
	uv0(slot0, slot1 + slot3 - slot8, slot2, slot8, slot4, slot5, slot6, slot7)
	uv0(slot0, slot1 + slot8, slot8, slot3 - slot8 * 2, slot4, slot5, slot6, slot7)
	uv0(slot0 + slot2 - slot8, slot1 + slot8, slot8, slot3 - slot8 * 2, slot4, slot5, slot6, slot7)
end

function slot22(slot0, slot1, slot2, slot3, slot4, slot5)
	uv0 = uv0 + (1 - slot0) * 0.7 + 0.3
	slot6 = uv1(uv0 * 0.01 % 2 - 1) * 255
	slot8, slot9 = uv2()
	slot12, slot13 = uv3:measure(nil, 35)

	uv3:draw(slot8 / 2 - 95 - 3, slot9 * 0.35 - 4, slot12 + 6, slot13 + 6, 16, 16, 16, 255 * slot4)

	if slot4 > 0.7 then
		uv4(slot10 + 13, slot11 + 11, 8, 20, 16, 16, 16, 255 * slot4)
	end

	uv3:draw(slot10, slot11, nil, 35, slot1, slot2, slot3, slot6 * slot4)
	uv5(slot10 + slot12 + 8, slot11 + 3, 255, 255, 255, 255 * slot4, "b", 0, uv6("%s %d%%", slot5, slot0 * 100))

	slot14 = slot10 + slot12 + 8
	slot15 = slot11 + 3 + 17
	slot16 = slot7
	slot17 = 12

	uv7(slot14, slot15, slot16, slot17, 0, 0, 0, 255 * slot4, 1)
	uv4(slot14 + 1, slot15 + 1, slot16 - 2, slot17 - 2, 16, 16, 16, 180 * slot4)
	uv4(slot14 + 1, slot15 + 1, uv8((slot16 - 2) * slot0), slot17 - 2, slot1, slot2, slot3, 180 * slot4)
end

function slot23()
	if not uv1(uv0()) then
		return
	end

	if uv2(slot0, "m_flVelocityModifier") == 1 then
		return
	end

	slot2, slot3, slot4 = uv3(slot1)

	if uv5(uv6) == "Bar" then
		uv7(slot1, slot2, slot3, slot4, uv4(slot1, 1, 0, 0.85, 1), "Slowed down")
	else
		uv8(slot2, slot3, slot4, slot5 * 255, "SLOW")
	end
end

ui.set_callback(ui.new_combobox("VISUALS", "Other ESP", "Display maximum speed", "Off", "Bar", "Indicator"), function ()
	uv0(uv1) ~= "Off" and client.set_event_callback or client.unset_event_callback("paint", uv2)
end)
