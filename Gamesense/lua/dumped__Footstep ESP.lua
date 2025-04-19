slot0 = require("gamesense/uix")
slot1 = client.userid_to_entindex
slot2 = entity.get_players
slot3 = entity.get_prop
slot4 = entity.is_dormant
slot5 = entity.is_enemy
slot6 = globals.curtime
slot7 = math.sqrt
slot8 = renderer.text
slot9 = renderer.world_to_screen
slot10 = table.remove
slot11 = ui.get
slot12 = ui.new_checkbox
slot13 = ui.new_color_picker
slot14 = ui.new_slider
slot15 = ui.reference
slot16 = ui.set_callback
slot17 = ui.set_visible
slot18, slot19, slot20 = nil
slot21 = {}

function slot22(slot0, slot1, slot2, slot3, slot4, slot5)
	return uv0((slot3 - slot0)^2 + (slot4 - slot1)^2 + (slot5 - slot2)^2)
end

function slot23(slot0, slot1, slot2)
	for slot8 = 1, #uv0() do
		if uv3(slot3[slot8]) == false then
			slot10, slot11, slot12 = uv4(slot9, "m_vecOrigin")

			if uv5(slot10, slot11, slot12, slot0, slot1, slot2) <= uv1(uv2) then
				return true
			end
		end
	end

	return false
end

function slot24()
	slot1, slot2, slot3, slot4 = uv1(uv2)

	for slot8 = #uv3, 1, -1 do
		if uv3[slot8].delay_time <= uv0() then
			slot9.alpha = slot9.alpha - 1

			if slot9.alpha <= 0 then
				uv4(uv3, slot8)
			end
		end

		slot10, slot11 = uv5(slot9.x, slot9.y, slot9.z)

		if slot10 ~= nil then
			uv6(slot10, slot11, slot1, slot2, slot3, slot9.alpha, "cd", 0, "step")
		end
	end
end

function slot25(slot0)
	if uv1(uv0(slot0.userid)) == true then
		slot2, slot3, slot4 = entity.get_origin(slot1)

		if slot2 ~= nil and uv2(slot2, slot3, slot4) then
			uv3[#uv3 + 1] = {
				alpha = 255,
				x = slot2,
				y = slot3,
				z = slot4,
				delay_time = uv4() + 1
			}
		end
	end
end

function slot26(slot0)
	uv0 = {}
end

function slot27()
	uv0 = {}
end

function slot28(slot0)
	uv1(uv2, uv0(slot0))
end

function ()
	uv0 = uv1.new_checkbox("LUA", "A", "Footstep ESP")
	uv2 = uv3("LUA", "A", "Footstep color", 255, 255, 255, 255)
	uv4 = uv5("LUA", "A", "\nFootstep distance", 0, 1250, 850, true, "u")

	uv0:on("change", uv6)
	uv0:on("paint", uv7)
	uv0:on("player_footstep", uv8)
	uv0:on("round_start", uv9)
	uv0:on("level_init", uv10)
end()
