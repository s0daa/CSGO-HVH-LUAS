slot0 = client.set_event_callback
slot1 = entity.get_local_player
slot2 = entity.get_player_weapon
slot3 = entity.get_prop
slot4 = math.abs
slot5 = math.atan2
slot6 = math.ceil
slot7 = math.cos
slot8 = math.floor
slot9 = math.max
slot10 = math.sin
slot11 = math.sqrt
slot12 = ui.get
slot14 = ui.reference
slot15 = ui.set
slot16 = ui.set_visible
slot19, slot20 = slot14("AA", "Other", "Slow motion")
slot21 = slot14("AA", "Anti-aimbot angles", "Fake yaw limit")
slot24 = ui.new_combobox("AA", "Anti-aimbot angles", "Fakewalk mode", {
	"Opposite",
	"Extend",
	"Jitter"
})

function slot25(slot0, slot1, slot2)
	return {
		x = slot0 or 0,
		y = slot1 or 0,
		z = slot2 or 0
	}
end

function slot26(slot0)
	return slot0 * math.pi / 180
end

function slot27(slot0, slot1)
	if slot0.x == 0 and slot0.y == 0 then
		if slot0.z > 0 then
			slot1.x = -90
		else
			slot1.x = 90
		end

		slot1.y = 0
	else
		slot1.x = uv0(-slot0.z, uv1(slot0.x * slot0.x + slot0.y * slot0.y)) * 180 / math.pi
		slot1.y = uv0(slot0.y, slot0.x) * 180 / math.pi
	end

	slot1.z = 0
end

function slot28(slot0, slot1)
	slot3 = uv2(uv1(slot0.x))
	slot1.x = slot3 * uv2(uv1(slot0.y))
	slot1.y = slot3 * uv0(uv1(slot0.y))
	slot1.z = -uv0(uv1(slot0.x))
end

function round(slot0)
	return slot0 >= 0 and uv0(slot0 + 0.5) or uv1(slot0 - 0.5)
end

function slot29(slot0)
	if slot0 > 180 or slot0 < -180 then
		slot1 = round(uv0(slot0 / 360))
		slot0 = slot0 < 0 and slot0 + 360 * slot1 or slot0 + 360 * slot1 - 360 * slot1
	end

	return slot0
end

function slot30(slot0)
	slot1 = uv0(uv1(uv2(), "m_vecVelocity"))
	slot2 = uv3(slot1.x * slot1.x + slot1.y * slot1.y)
	slot3 = uv0(0, 0, 0)

	uv4(slot1, slot3)

	slot3.y = slot0.yaw - slot3.y
	slot4 = uv0(0, 0, 0)

	uv5(slot3, slot4)

	slot6 = 450 / uv6(uv7(slot0.forwardmove), uv7(slot0.sidemove))
	slot4 = uv0(slot4.x * -slot6, slot4.y * -slot6, slot4.z * -slot6)
	slot0.forwardmove = slot4.x
	slot0.sidemove = slot4.y
end

slot31 = 0
slot32 = ""

function slot33()
	slot0 = uv0(uv1())
	slot1 = uv2(uv1(), "m_bIsScoped")

	if uv3 == "deagle" or uv3 == "aug" and slot1 == 1 then
		return 10
	end

	if uv3 == "negev" or uv3 == "sg556" and slot1 == 1 then
		return 9
	end

	return 8
end

slot34 = false
slot35 = slot12(slot14("AA", "Other", "On shot anti-aim"))
slot36 = slot12(slot14("AA", "Fake lag", "Limit"))
slot37 = slot12(slot14("AA", "Fake lag", "Variance"))
slot38 = slot12(slot14("Misc", "Movement", "Fast walk"))
slot39 = 0

slot0("setup_command", function (slot0)
	if uv0(uv1) then
		return
	end

	if not uv0(uv2) then
		if uv3 and uv4 > 0 then
			uv5(uv6, uv7)
			uv5(uv8, uv4)
			uv5(uv9, uv10)
			uv5(uv11, uv12)
		end

		uv7 = uv0(uv6)
		uv4 = uv0(uv8)
		uv10 = uv0(uv9)
		uv12 = uv0(uv11)
		uv3 = false

		return
	end

	slot3 = uv16(uv13(uv14(uv15(), "m_angAbsRotation")).y - uv13(uv14(uv15(), "m_angEyeAngles")).y) > 0 and -1 or 1
	slot4 = uv13(uv14(uv15(), "m_vecVelocity"))
	slot5 = uv17(slot4.x * slot4.x + slot4.y * slot4.y)
	uv3 = true

	uv5(uv6, false)
	uv5(uv8, 14)
	uv5(uv9, 0)
	uv5(uv11, true)

	if slot0.chokedcommands >= uv0(uv8) - uv18() and (slot0.forwardmove ~= 0 or slot0.sidemove ~= 0) then
		uv19(slot0)
	end

	if slot0.chokedcommands == uv0(uv8) - 3 then
		if slot5 <= 0 then
			slot0.forwardmove = -1.01
		end

		uv20 = uv20 + 1

		if uv0(uv21) == "Opposite" then
			slot0.yaw = uv16(slot1.y + 60 * slot3)
		elseif uv0(uv21) == "Extend" then
			slot0.yaw = uv16(slot1.y + 90 * slot3)
		elseif uv0(uv21) == "Jitter" then
			slot0.yaw = uv16(slot1.y + 60 * (uv20 % 2 == 0 and -1 or 1))
		end
	end
end)
slot0("item_equip", function (slot0)
	uv0 = slot0.item
	uv1 = slot0.weptype
end)
slot0("pre_render", function ()
	uv0(uv1, not uv2(uv3) and true or false)
end)
