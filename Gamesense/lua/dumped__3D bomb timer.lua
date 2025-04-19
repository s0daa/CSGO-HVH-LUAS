slot1 = ui.new_color_picker("VISUALS", "Other ESP", "C4 Timer Color")
slot2 = ui.new_slider("VISUALS", "Other ESP", "Radius", 20, 100, 50, true, "%")
slot3 = ui.new_slider("VISUALS", "Other ESP", "Oval", 0, 50, 0, true, "%")

function slot4(slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = slot0 - slot3
	slot7 = slot1 - slot4

	return math.deg(math.atan((slot2 - slot5) / math.sqrt(slot6 * slot6 + slot7 * slot7))), math.deg(math.atan(slot7 / slot6))
end

function slot5(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot7, slot8 = client.screen_size()
	slot9, slot10, slot11 = client.camera_angles()
	slot12, slot13 = uv0(slot0, slot1, slot2, slot3, slot4, slot5)

	if math.rad(slot10 - slot13 - 90) < 0 and slot14 > -math.pi then
		slot14 = slot14 + math.pi
	end

	return slot7 * 0.5 + slot7 * (0.5 + ui.get(uv1) / 100) * slot6 * math.cos(slot14), slot8 * 0.5 + slot7 * 0.5 * slot6 * math.sin(slot14)
end

function slot6()
	for slot4 = 1, #entity.get_all("CPlantedC4") do
		if entity.get_prop(slot0[slot4], "m_flC4Blow") < globals.curtime() then
			return
		end

		slot7 = math.floor((slot6 - globals.curtime()) * 10) / 10
		slot8 = slot7 / cvar.mp_c4timer:get_int()

		if slot7 <= 0 or slot7 == nil then
			return
		end

		slot9, slot10, slot11 = entity.get_origin(entity.get_local_player())
		slot12, slot13, slot14 = entity.get_origin(slot5)
		slot15, slot16 = renderer.world_to_screen(slot12, slot13, slot14)
		slot17, slot18, slot19, slot20 = ui.get(uv0)

		if slot15 ~= nil and slot16 ~= nil then
			renderer.circle_outline(slot15, slot16, 0, 0, 0, 200, 25, 270, 1, 8)
			renderer.circle_outline(slot15, slot16, slot17, slot18, slot19, slot20, 25, 270, slot8, 8)
			renderer.text(slot15, slot16, 255, 255, 255, 255, "c", 0, slot7)
		else
			slot21, slot22 = uv1(slot12, slot13, slot14, slot9, slot10, slot11, ui.get(uv2) / 200)

			renderer.circle_outline(slot21, slot22, 0, 0, 0, 200, 25, 270, 1, 8)
			renderer.circle_outline(slot21, slot22, slot17, slot18, slot19, slot20, 25, 270, slot8, 8)
			renderer.text(slot21, slot22, 255, 255, 255, 255, "c", 0, slot7)
		end
	end
end

ui.set_callback(ui.new_checkbox("VISUALS", "Other ESP", "Enable C4 Timer"), function ()
	if ui.get(uv0) then
		client.set_event_callback("paint", uv1)
	else
		client.unset_event_callback("paint", uv1)
	end
end)
