slot0 = client.key_state
slot2 = database.read
slot3 = database.write
slot4 = entity.get_all
slot5 = entity.get_bounding_box
slot6 = entity.get_classname
slot7 = entity.get_local_player
slot8 = entity.get_player_name
slot9 = entity.get_player_weapon
slot10 = entity.get_players
slot11 = entity.get_prop
slot12 = globals.maxplayers
slot13 = math.min
slot14 = renderer.rectangle
slot15 = renderer.text
slot16 = string.gsub
slot17 = string.len
slot18 = string.sub
slot19 = table.insert
slot20 = ui.get
slot21 = ui.is_menu_open
slot22 = ui.mouse_position
slot26 = ui.set_callback
slot27 = ui.set_visible
slot28 = unpack
slot30 = {
	x = slot31.x or 150,
	y = slot31.y or 150,
	dragging = false
}
slot31 = database.read("InfoScreen") or {}
slot32 = require("gamesense/uix").new_checkbox("MISC", "Miscellaneous", "Info Screen")
slot33 = ui.new_color_picker("MISC", "Miscellaneous", "Info Screen", 193, 255, 107, 255)
slot34 = ui.new_checkbox("MISC", "Miscellaneous", "Info Screen: Location")
slot35 = ui.reference("VISUALS", "Player ESP", "Teammates")

function slot36(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot37(slot0, slot1)
	slot2 = slot0 ~= nil and slot0 or false
	slot3 = slot1 ~= nil and slot1 or true
	slot4 = {}

	for slot9 = 1, uv1() do
		if uv2(uv0("CCSPlayerResource")[1], "m_bConnected", slot9) == 1 then
			slot10 = nil

			if slot2 then
				slot10 = uv2(uv3(), "m_iTeamNum")
			end

			slot11 = true

			if slot2 and uv2(slot9, "m_iTeamNum") == slot10 then
				slot11 = false
			end

			if slot11 then
				slot12 = true

				if slot3 and uv2(slot5, "m_bAlive", slot9) ~= 1 then
					slot12 = false
				end

				if slot12 then
					uv4(slot4, slot9)
				end
			end
		end
	end

	return slot4
end

function slot38()
	uv1(uv2, uv0:get())
end

slot32:on("change", slot38)
slot38()

slot39 = {}

function slot40(slot0, slot1, slot2, slot3, slot4)
	slot5, slot6 = uv0()

	if slot4 or false then
		uv1(slot0, slot1, slot2, slot3, 255, 0, 0, 50)
	end

	return slot0 <= slot5 and slot5 <= slot0 + slot2 and slot1 <= slot6 and slot6 <= slot1 + slot3
end

slot32:on("paint", function ()
	if uv0:get() then
		slot1 = uv1(uv3)
		slot2 = {}
		slot3 = {}
		slot4 = {
			"PLAYER",
			"HEALTH",
			"WEAPON"
		}
		slot5 = 2
		uv4.w = 220

		if uv1(uv2) then
			slot4 = {
				"PLAYER",
				"HEALTH",
				"WEAPON",
				"LOCATION"
			}
			slot5 = 3
			uv4.w = 300
		end

		if #uv5(not slot1) == 0 then
			return
		end

		slot7 = uv6(not slot1)

		if uv7("CCSPlayerResource")[1] == nil then
			return
		end

		slot9 = uv8(slot8, "m_iPlayerC4")
		uv4.h = #slot6 * 15 + 30
		uv4.h = uv9(uv4.h, 145)

		uv10(uv4.x, uv4.y, uv4.w, uv4.h, 29, 31, 38, 170)

		slot13 = uv4.w

		uv10(uv4.x, uv4.y, slot13, 20, 29, 31, 38, 100)

		for slot13 = 1, #slot6 do
			slot14 = slot6[slot13]
			slot15 = uv11(slot14)
			slot16 = uv8(slot14, "m_iHealth")

			if (uv13(uv12(slot14)) or "Unknown") ~= nil and slot18 ~= "Unknown" and uv14(slot18) > 2 then
				slot18 = uv16(uv15(slot18, 2), "Weapon", "")
			end

			slot19 = uv8(slot14, "m_bHasDefuser")
			slot3[slot13] = {
				255,
				255,
				255,
				255
			}

			if slot9 ~= nil and slot14 == slot9 then
				slot3[slot13] = {
					255,
					0,
					0,
					255
				}
			end

			if slot19 == 1 then
				slot3[slot13] = {
					50,
					50,
					255,
					255
				}
			end

			if not uv17(slot7, slot14) then
				slot20, slot21, slot22, slot23, slot24 = uv18(ctx, slot14)

				if slot24 == nil or slot24 < 0.15 then
					slot24 = 0.15
				end

				slot25, slot26, slot27, slot28 = uv19(slot3[slot13])
				slot3[slot13] = {
					slot25,
					slot26,
					slot27,
					slot28 * slot24
				}
			end

			if slot0 then
				slot21 = ((entity.get_prop(slot14, "m_szLastPlaceName") or " ") .. " "):gsub("%u[%l ]", function (slot0)
					return " " .. slot0
				end):sub(1, -2)

				for slot25, slot26 in pairs({
					["of "] = " of ",
					["^ "] = ""
				}) do
					place_name = slot15:gsub(slot25, slot26)
				end

				slot2[slot13] = {
					slot15,
					slot16,
					slot18,
					slot21
				}
			else
				slot2[slot13] = {
					slot15,
					slot16,
					slot18
				}
			end
		end

		slot10, slot11, slot12, slot13 = uv1(uv20)

		for slot17 = 0, slot5 do
			uv21(uv4.x + 31 + slot17 * 75, uv4.y + 11, slot10, slot11, slot12, slot13, "-c", 70, slot4[slot17 + 1])

			if #slot6 >= 1 then
				for slot21 = 1, #slot6 do
					slot22 = 255
					slot23 = 255
					slot24 = 255
					slot25 = 255

					if slot3[slot21] ~= nil then
						slot22, slot23, slot24, slot25 = uv19(slot3[slot21])
					end

					uv21(uv4.x + 31 + slot17 * 75, uv4.y + 15 + slot21 * 12, slot22, slot23, slot24, slot25, "c", 70, slot2[slot21][slot17 + 1])
				end
			end
		end

		if uv22() then
			uv23.x, uv23.y = uv24()
			slot14 = uv25(1)

			uv21(uv4.x, uv4.y - 1, 255, 255, 255, 255, "b", 999, "Drag here to move info screen")

			if uv4.dragging and not slot14 then
				uv4.dragging = false
			end

			if uv4.dragging and slot14 then
				uv4.x = uv23.x - uv4.drag_x
				uv4.y = uv23.y - uv4.drag_y
			end

			if uv26(uv4.x, uv4.y, uv4.w, 10, true) and slot14 then
				uv4.dragging = true
				uv4.drag_x = uv23.x - uv4.x
				uv4.drag_y = uv23.y - uv4.y
			end
		end
	end
end)
client.set_event_callback("shutdown", function ()
	uv0("InfoScreen", {
		x = uv1.x,
		y = uv1.y
	})
end)
