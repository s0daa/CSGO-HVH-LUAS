slot0 = {}

function slot1()
	uv0 = {}
end

slot2 = ui.new_checkbox("LUA", "a", "Enable Trails")
slot3 = ui.new_slider("LUA", "a", "Trail Segment Expiration", 1, 100, 10, true, "s", 0.1)
slot4 = ui.new_combobox("LUA", "a", "Trail Type", "Line", "Advanced Line", "Rect")
slot5 = ui.new_combobox("LUA", "a", "Trail Color Type", "Static", "Chroma", "Gradient Chroma")
slot6 = ui.new_color_picker("LUA", "a", "Trail Color", 246, 34, 34, 255)
slot7 = ui.new_slider("LUA", "a", "Trail Chroma Speed Multiplier", 1, 100, 1, true, "%", 0.1)
slot8 = ui.new_slider("LUA", "a", "Line Size", 1, 100, 1, true)
slot9 = ui.new_slider("LUA", "a", "Rect Width", 1, 100, 1, true)
slot10 = ui.new_slider("LUA", "a", "Rect Height", 1, 100, 1, true)
slot11 = ui.new_slider("LUA", "a", "Trail X Width", 1, 100, 1, true)
slot12 = ui.new_slider("LUA", "a", "Trail Y Width", 1, 100, 1, true)

ui.new_button("LUA", "a", "Clear Trail Data", slot1)

slot13 = require("vector")

function slot14(slot0, slot1)
	return math.floor(math.sin((globals.realtime() + slot0) * slot1) * 127 + 128), math.floor(math.sin((globals.realtime() + slot0) * slot1 + 2) * 127 + 128), math.floor(math.sin((globals.realtime() + slot0) * slot1 + 4) * 127 + 128)
end

client.set_event_callback("paint", function ()
	slot1 = ui.get(uv1)

	ui.set_visible(uv2, ui.get(uv0) == "Static")
	ui.set_visible(uv3, slot0 ~= "Static")
	ui.set_visible(uv4, slot1 == "Advanced Line")
	ui.set_visible(uv5, slot1 == "Advanced Line")
	ui.set_visible(uv6, slot1 == "Line")
	ui.set_visible(uv7, slot1 == "Rect")
	ui.set_visible(uv8, slot1 == "Rect")

	if entity.is_alive(entity.get_local_player()) and ui.get(uv9) then
		slot3 = globals.curtime()
		slot4 = uv10(entity.get_prop(slot2, "m_vecOrigin"))

		if uv11.lastOrigin == nil then
			uv11.lastOrigin = slot4
		end

		slot5 = slot4:dist(uv11.lastOrigin)

		if uv11.trailSegments == nil then
			uv11.trailSegments = {}
		end

		if slot5 ~= 0 then
			slot6, slot7, slot8 = entity.get_prop(slot2, "m_vecOrigin")

			table.insert(uv11.trailSegments, {
				pos = slot4,
				exp = slot3 + ui.get(uv12) * 0.1,
				x = slot6,
				y = slot7,
				z = slot8
			})
		end

		uv11.lastOrigin = slot4

		for slot9 = #uv11.trailSegments, 1, -1 do
			if uv11.trailSegments[slot9].exp < slot3 then
				table.remove(uv11.trailSegments, slot9)
			end
		end

		for slot9, slot10 in ipairs(uv11.trailSegments) do
			slot11, slot12 = renderer.world_to_screen(slot10.x, slot10.y, slot10.z)
			slot13 = 0

			if slot0 == "Gradient Chroma" then
				slot13 = slot9
			end

			if slot11 ~= nil and slot12 ~= nil then
				slot14, slot15, slot16 = uv13(slot13, ui.get(uv3) * 0.1)

				if slot0 == "Static" then
					slot14, slot15, slot16 = ui.get(uv2)
				end

				if slot1 == "Line" or slot1 == "Advanced Line" then
					if slot9 < #uv11.trailSegments then
						slot17 = uv11.trailSegments[slot9 + 1]
						slot18, slot19 = renderer.world_to_screen(slot17.x, slot17.y, slot17.z)

						if slot18 ~= nil and slot19 ~= nil then
							if slot1 == "Advanced Line" then
								for slot23 = 1, ui.get(uv4) do
									renderer.line(slot11 + slot23, slot12, slot18 + slot23, slot19, slot14, slot15, slot16, 255)
								end

								for slot23 = 1, ui.get(uv5) do
									renderer.line(slot11, slot12 + slot23, slot18, slot19 + slot23, slot14, slot15, slot16, 255)
								end
							else
								for slot23 = 1, ui.get(uv6) do
									renderer.line(slot11 + slot23, slot12 + slot23, slot18 + slot23, slot19 + slot23, slot14, slot15, slot16, 255)
								end
							end
						end
					end
				else
					renderer.rectangle(slot11, slot12, ui.get(uv7), ui.get(uv8), slot14, slot15, slot16, 255)
				end
			end
		end
	end
end)
client.set_event_callback("round_start", slot1)
