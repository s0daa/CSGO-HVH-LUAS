slot0 = entity.get_player_name
slot1 = entity.get_prop
slot2 = globals.curtime
slot3 = math.max
slot4 = renderer.text
slot5 = renderer.rectangle
slot6 = renderer.measure_text
slot7 = table.insert
slot8 = table.remove
slot9 = ui.get
slot10 = ui.set_visible
slot11 = client.set_event_callback
slot12 = client.unset_event_callback
slot13, slot14 = client.screen_size()
slot15 = {
	slot13 / 2,
	slot14 / 2
}
slot16, slot17, slot18, slot19, slot20, slot21 = nil
slot22 = {}

function slot23()
	slot0 = {}

	for slot4 = 1, #uv0 do
		slot5 = 0
		slot6 = 0
		slot7 = 0

		if uv1 * uv2(0, 0 - (uv3() - uv0[slot4][3] - uv4) / uv4) <= 0 or slot8 > 255 then
			slot0[#slot0 + 1] = slot4
		else
			cur_shot = uv0[slot4]
			slot9 = "r"

			if cur_shot[1] == 2 then
				slot7 = 70
				slot6 = 255
				slot5 = 255
				slot9 = "rb"
			elseif cur_shot[1] == 1 then
				slot7 = 0
				slot6 = 255
				slot5 = 0
			else
				slot7 = 0
				slot6 = 50
				slot5 = 255
			end

			slot10 = uv5 >= 0 and uv6[2] - uv5 - slot4 * 12 or uv6[2] - uv5 + slot4 * 12

			uv7(uv6[1] - 2, slot10, slot5, slot6, slot7, slot8, slot9, 0, cur_shot[2])
			uv7(uv6[1] + 2, slot10, uv8, uv9, uv10, slot8, "b", 0, cur_shot[4])

			if cur_shot[5] then
				uv11(uv6[1] + 3, slot10 + 7, uv12("b", cur_shot[4]) + 2, 2, 0, 0, 0, slot8 / 2)
				uv11(uv6[1] + 2, slot10 + 6, uv12("b", cur_shot[4]) + 2, 2, 255, 50, 0, slot8)
			end
		end
	end

	for slot4 = 1, #slot0 do
		uv13(uv0, slot0[slot4])
	end
end

function slot24(slot0)
	uv0(uv1, {
		slot0.hitgroup == 1 and 2 or 1,
		slot0.damage,
		uv2(),
		uv3(slot0.target),
		uv4(slot0.target, "m_iHealth") <= 0
	})
end

function slot25(slot0)
	uv0(uv1, {
		0,
		slot0.reason,
		uv2(),
		uv3(slot0.target),
		false
	})
end

function slot26()
	uv0 = {}
end

slot27, slot28, slot29, slot30 = nil

function slot31(slot0)
	slot2 = uv0(slot0) and uv1 or uv2

	slot2("paint", uv3)
	slot2("aim_hit", uv4)
	slot2("aim_miss", uv5)
	slot2("level_init", uv6)
	uv7(uv8, slot1)
	uv7(uv9, slot1)
	uv7(uv10, slot1)
end

slot27 = ui.new_checkbox("VISUALS", "Effects", "Simple hitlog")
slot28 = ui.new_color_picker("VISUALS", "Effects", "Simple hitlog color", 255, 255, 255, 255)
slot29 = ui.new_slider("VISUALS", "Effects", "\nHitlog offset", -500, 500, 128, true, "px")
slot30 = ui.new_slider("VISUALS", "Effects", "\nHitlog fade time", 1, 15, 4, true, "s")

ui.set_callback(slot28, function (slot0)
	uv0, uv1, uv2, uv3 = uv4(slot0)
end)

slot18, slot19, slot20, slot21 = slot9(slot28)

ui.set_callback(slot29, function (slot0)
	uv0 = uv1(slot0)
end)

slot16 = slot9(slot29)

ui.set_callback(slot30, function (slot0)
	uv0 = uv1(slot0)
end)

slot17 = slot9(slot30)

ui.set_callback(slot27, slot31)
slot31(slot27)
