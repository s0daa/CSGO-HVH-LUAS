slot1 = entity.get_bounding_box
slot2 = entity.get_players
slot3 = entity.get_prop
slot4 = table.insert
slot5 = ui.get
slot8 = unpack
slot9 = entity.get_origin
slot10 = entity.get_local_player
slot12 = math.floor
slot13 = require("gamesense/images")
slot14 = require("gamesense/csgo_weapons")
slot15 = ui.new_checkbox("LUA", "A", "Grenade Inventory")
slot16 = ui.new_color_picker("LUA", "A", "Grenade Inventory color", 255, 255, 255, 255)
slot17 = ui.new_slider("LUA", "A", "Grenade Icon Scale", 6, 10, 8, true, "x", 0.1)

function slot18(slot0)
	slot1 = {}

	for slot5 = 0, 64 do
		if uv0(slot0, "m_hMyWeapons", slot5) ~= nil and uv1(slot6) ~= nil and slot7.type == "grenade" then
			uv2(slot1, slot7.idx)
		end
	end

	return slot1
end

client.set_event_callback("paint", function ()
	if not uv0(uv1) then
		return
	end

	slot0, slot1, slot2, slot3 = uv0(uv2)

	for slot8, slot9 in ipairs(uv3(true)) do
		if #uv4(slot9) > 0 then
			slot11, slot12, slot13, slot14, slot15 = uv5(slot9)

			if slot14 ~= nil and slot15 > 0 then
				slot16 = 0

				for slot20, slot21 in ipairs(slot10) do
					slot22 = uv6.get_weapon_icon(slot21)
					slot23, slot24 = slot22:measure()
					slot23 = uv7(slot23 * uv0(uv8) / 10)
					slot24 = uv7(slot24 * uv0(uv8) / 10)
					slot25 = (24 - slot23) / 2

					slot22:draw(slot13 - 3 + slot16 + slot25, slot14 - slot24 - 3, slot23 + 5, slot24 + 5, 0, 0, 0, 225)
					slot22:draw(slot13 + slot16 + slot25, slot14 - slot24, slot23, slot24, slot0, slot1, slot2, slot3)

					slot16 = slot16 + 24
				end
			end
		end
	end
end)
