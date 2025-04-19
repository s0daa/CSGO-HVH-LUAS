slot0 = require("vector")
slot1 = require("gamesense/csgo_weapons")
slot3 = true
slot4 = false

function slot5(slot0, slot1)
	for slot5, slot6 in ipairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

slot6 = false
slot7 = {}
slot8 = {
	"taser",
	"grenade",
	"c4"
}
slot9 = 64

function slot10(slot0)
	if entity.get_prop(slot0, "m_nModelIndex") == 824 then
		slot1 = uv0(entity.get_origin(slot0))
		slot1.x = slot1.x - 15

		return slot1
	end

	return uv0(entity.get_origin(slot0)) + uv0(entity.get_prop(slot0, "m_vecMins")) / 2 + uv0(entity.get_prop(slot0, "m_vecMaxs")) / 2
end

function slot11()
	slot0 = {}

	for slot4 = 65, 1000 do
		slot5, slot6 = pcall(entity.get_prop, slot4, "m_MoveType")

		if slot5 and slot6 == 7 and bit.band(entity.get_prop(slot4, "m_usSolidFlags"), 65535) == 2048 then
			slot0[#slot0 + 1] = slot4
		end
	end

	return slot0
end

function slot12()
	uv0 = {}

	if #uv1() > 0 then
		if uv2 then
			uv0 = slot0

			return
		end

		slot3 = uv3(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
		slot3.z = 0
		slot3 = uv3(client.eye_position()) + slot3:scaled(globals.tickinterval() * 64)

		for slot7, slot8 in ipairs(slot0) do
			slot9, slot10 = client.trace_line(entity.get_local_player(), slot2.x, slot2.y, slot2.z, slot3.x, slot3.y, slot3.z)

			if slot10 == slot8 then
				uv0[#uv0 + 1] = slot8

				break
			end
		end

		if #uv0 == 0 then
			slot4 = uv3():init_from_angles(client.camera_angles())

			slot4:scale(uv4 / 2)

			slot4 = slot4 + slot2

			for slot8, slot9 in ipairs(slot0) do
				slot10, slot11 = client.trace_line(slot1, slot2.x, slot2.y, slot2.z, slot4.x, slot4.y, slot4.z)

				if slot11 == slot9 then
					uv0[#uv0 + 1] = slot9

					break
				end
			end
		end
	end
end

function slot13(slot0)
	slot1 = uv0(entity.get_origin(slot0))
	slot6 = uv0(renderer.world_to_screen(uv1(slot0):unpack()))
	slot7 = uv0(renderer.world_to_screen((slot1 + uv0(entity.get_prop(slot0, "m_vecMins"))):unpack()))
	slot8 = uv0(renderer.world_to_screen((slot1 + uv0(entity.get_prop(slot0, "m_vecMaxs"))):unpack()))

	renderer.line(slot7.x, slot7.y, slot8.x, slot8.y, 0, 0, 0, 255)
	renderer.circle(slot6.x, slot6.y, 50, 50, 50, 255, 3, 0, 100)
end

function slot14(slot0, slot1)
	if math.min(1, 2 - uv0(slot0):dist(slot1) / (uv1 * 2)) > 0 then
		slot5, slot6, slot7 = nil
		slot8 = uv2(renderer.world_to_screen(slot2:unpack()))

		renderer.circle(slot8.x, slot8.y, uv1 < slot3 and 255 or 0, slot4 == 1 and 255 or 0, 0, 255 * slot4, 5, 0, 100)
	end
end

function slot15()
	for slot4, slot5 in ipairs(uv1) do
		uv2(slot5, uv0(client.eye_position()))
	end

	if uv3 then
		for slot4, slot5 in ipairs(uv4()) do
			uv5(slot5)
		end

		slot1 = uv0(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
		slot1.z = 0
		slot2 = uv0(renderer.world_to_screen(slot0:unpack()))
		slot3 = uv0(renderer.world_to_screen((slot0 + slot1:scaled(globals.tickinterval() * uv6)):unpack()))

		renderer.line(slot2.x, slot2.y, slot3.x, slot3.y, 255, 255, 255, 255)

		slot4 = uv0():init_from_angles(client.camera_angles())

		slot4:scale(1024)

		slot4 = slot4 + slot0
		slot5, slot6 = client.trace_line(entity.get_local_player(), slot0.x, slot0.y, slot0.z, slot4.x, slot4.y, slot4.z)

		renderer.text(1280, 730, 255, 255, 255, 255, "cd", 0, string.format("%.2f %d", slot5, slot6))
		cvar.cl_pdump:set_int(slot6)

		if slot6 ~= -1 then
			print(bit.band(entity.get_prop(slot6, "m_nSolidType"), 65535))
			uv5(slot6)
		end
	end
end

function slot16(slot0)
	if uv0(entity.get_player_weapon(entity.get_local_player())) == nil then
		return
	end

	if math.max(0, entity.get_prop(slot2, "m_flNextPrimaryAttack") or 0, entity.get_prop(slot1, "m_flNextAttack") or 0) - globals.curtime() < 0 and (slot3.type == "knife" or entity.get_prop(slot2, "m_iClip1") > 0) and not uv1(uv2, slot3.type) then
		slot5 = uv3(client.eye_position())
		slot7 = nil

		for slot11, slot12 in ipairs(uv4) do
			if slot5:dist(uv5(slot12)) < uv6 and slot14 < 256 then
				slot15, slot16 = client.trace_line(slot1, slot5.x, slot5.y, slot5.z, slot13.x, slot13.y, slot13.z)

				if slot15 >= 0.95 or slot16 == slot12 then
					slot6 = slot14
					slot7 = slot13
				end
			end
		end

		if slot7 ~= nil then
			slot0.pitch, slot0.yaw = slot5:to(slot7):angles()
			slot0.in_attack = 1
		end
	end
end

function slot17()
	ui.get(uv0) and client.set_event_callback or client.unset_event_callback("net_update_end", uv1)

	if uv2 then
		slot1("paint", uv3)
	end

	slot1("setup_command", uv4)
end

ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Breakables Ragebot"), slot17)
slot17()
