slot0 = require("bit")
slot1 = renderer
slot2 = slot1.gradient
slot3 = slot1.rectangle
slot4 = slot1.text
slot5 = slot1.measure_text
slot6 = client.screen_size
slot7 = client.latency
slot8 = globals.absoluteframetime
slot9 = globals.tickinterval
slot10 = entity.get_local_player
slot11 = entity.get_prop
slot12 = math.min
slot13 = math.max
slot14 = math.abs
slot15 = math.sqrt
slot16 = math.floor
slot17 = slot0.band
slot18 = slot0.bnot
slot19 = slot0.bor
slot20 = 64
slot21 = 0.5
slot22 = 1
slot23 = 2
slot24 = 3
slot25 = 4
slot26 = 5
slot27 = 6
slot28 = {}
slot29 = 0
slot30 = 0
slot31 = 0
slot32 = {}

function slot33(slot0)
	return uv0(slot0 + 0.5)
end

function slot34(slot0)
	return uv0(slot0 + 1, uv1(1))
end

function slot35()
	if uv0() > 0 then
		uv1[uv2] = slot0
		uv2 = uv2 + 1

		if uv3 <= uv2 then
			uv2 = 0
		end
	end

	slot1 = 0
	slot2 = 0
	slot4 = nil
	uv4 = 0

	for slot8 = 0, uv3 - 1 do
		if uv2 - 1 < 0 then
			slot3 = uv3 - 1
		end

		if uv1[slot3] == 0 then
			break
		end

		slot1 = slot1 + slot0
		slot2 = slot2 + 1

		if slot4 then
			uv4 = uv5(uv4, uv6(slot0 - slot4))
		end

		slot4 = slot0

		if uv7 <= slot1 then
			break
		end
	end

	if slot2 == 0 then
		return 0
	end

	if uv6(uv8(1 / (slot1 / slot2)) - uv9) > 5 then
		uv9 = slot5
	else
		slot5 = uv9
	end

	return slot5
end

function slot36()
	return 255, 60, 80
end

function slot37()
	return 255, 222, 0
end

function slot38()
	return 159, 202, 43
end

function slot39(slot0, slot1, slot2, slot3)
	slot0[uv0] = slot1
	slot0[uv1] = slot2
	slot0[uv2] = slot3
end

function slot40(slot0, slot1)
	slot0[uv0] = slot1
end

function slot41(slot0)
	if uv0(uv1(1000, uv2() * 1000)) < 40 then
		uv3(slot0, uv4())
	elseif slot1 < 100 then
		uv3(slot0, uv5())
	else
		uv3(slot0, uv6())
	end

	uv7(slot0, slot1)
end

function slot42(slot0)
	if uv0() < 1 / uv1() then
		uv2(slot0, uv3())
	else
		uv2(slot0, uv4())
	end

	uv5(slot0, slot1)
end

function slot43(slot0)
	if uv1() < uv0 then
		uv2(slot0, uv3())
	elseif slot1 > slot2 * 0.5 then
		uv2(slot0, uv4())
	else
		uv2(slot0, uv5())
	end

	uv6(slot0, uv7(slot1 * 1000))
end

function slot44(slot0)
	slot1, slot2 = uv0(uv1(), "m_vecVelocity")

	uv2(slot0, slot1 and uv3(uv4(10000, uv5(slot1 * slot1 + slot2 * slot2))) or 0)
end

function slot45()
	slot0, slot1 = uv0("d", "0")
	slot2 = uv2(slot1 * 0.5)
	slot3 = uv1(slot0) * 13
	slot4, slot5 = uv0("d-", "0")
	slot7 = slot2 + slot1 + slot2
	slot8 = slot3 * #uv3
	slot9 = slot8 * 0.5
	slot10, slot11 = uv4()
	slot12 = uv2(slot10 * 0.5)
	slot13 = slot11 - slot7

	uv5(slot12 - slot8, slot13, slot9, slot7, 0, 0, 0, 0, 0, 0, 0, 80, true)
	uv6(slot12 - slot9, slot13, slot8, slot7, 0, 0, 0, 80)

	slot17 = slot9

	uv5(slot12 + slot9, slot13, slot17, slot7, 0, 0, 0, 80, 0, 0, 0, 0, true)

	slot12 = slot12 - slot9 + slot3 * 0.5
	slot13 = slot13 + slot2

	for slot17 = 1, #uv3 do
		slot18 = uv3[slot17]

		slot18[uv7](slot18)
		uv8(slot12, slot13, slot18[uv9], slot18[uv10], slot18[uv11], 255, "dr", 0, slot18[uv12])
		uv8(slot12 + slot4, slot13 + slot1 - slot5, 255, 255, 255, 175, "d-", 0, slot18[uv13])

		slot12 = slot12 + slot3
	end
end

function slot46(slot0, slot1, slot2, slot3, slot4)
	uv0[#uv0 + 1] = {
		slot0,
		slot1,
		0,
		slot2,
		slot3,
		slot4
	}
end

function ()
	for slot4 = uv1 - 1, 0, -1 do
		uv2[slot4] = uv0()
	end

	uv3("PING", uv4, 255, 255, 255)
	uv3("FPS", uv5, 255, 255, 255)
	uv3("VAR", uv6, 255, 255, 255)
	uv3("SPEED", uv7, 255, 255, 255)
	client.set_event_callback("paint", uv8)
end()
