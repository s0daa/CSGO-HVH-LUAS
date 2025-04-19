slot0 = require("vector")
slot1 = require("gamesense/antiaim_funcs")
slot2 = {
	enabled = ui.new_checkbox("VISUALS", "Other ESP", "Radial anti-aim indicator"),
	selector = ui.new_combobox("VISUALS", "Other ESP", "Customize", "Hide", "Real", "Fake"),
	real = {
		mode = ui.new_combobox("VISUALS", "Other ESP", "Real mode", "Off", "Circle", "Lines"),
		color = ui.new_color_picker("VISUALS", "Other ESP", "Real color", 255, 255, 255, 255),
		offset = ui.new_slider("VISUALS", "Other ESP", "Real offset", 1, 100, 10),
		max = ui.new_slider("VISUALS", "Other ESP", "Real max", 1, 100, 10),
		add = ui.new_slider("VISUALS", "Other ESP", "Real add", -100, 100, 10, true, nil, 0.1),
		dec = ui.new_slider("VISUALS", "Other ESP", "Real decay factor", 1, 100, 80, true, nil, 0.01),
		lag = ui.new_slider("VISUALS", "Other ESP", "Real update", 1, 16, 1, true, "t"),
		divs = ui.new_slider("VISUALS", "Other ESP", "Real subdivisions", 2, 36, 8)
	},
	fake = {
		mode = ui.new_combobox("VISUALS", "Other ESP", "Fake mode", "Off", "Circle", "Lines"),
		color = ui.new_color_picker("VISUALS", "Other ESP", "Fake color", 255, 0, 0, 255),
		offset = ui.new_slider("VISUALS", "Other ESP", "Fake offset", 1, 100, 10),
		max = ui.new_slider("VISUALS", "Other ESP", "Fake max", 1, 100, 10),
		add = ui.new_slider("VISUALS", "Other ESP", "Fake add", -100, 100, 10, true, nil, 0.1),
		dec = ui.new_slider("VISUALS", "Other ESP", "Fake decay factor", 1, 100, 80, true, nil, 0.01),
		lag = ui.new_slider("VISUALS", "Other ESP", "Fake update", 1, 16, 1, true, "t"),
		divs = ui.new_slider("VISUALS", "Other ESP", "Fake subdivisons", 2, 36, 8)
	}
}

function slot3(slot0, slot1, slot2)
	for slot6, slot7 in pairs(slot0) do
		if slot7 ~= slot2 then
			ui.set_visible(slot7, slot1)
		end
	end
end

slot4 = {
	lp = entity.get_local_player(),
	fake = {
		draw = function ()
		end,
		angles = {},
		color = {
			ui.get(slot2.fake.color)
		},
		offset = ui.get(slot2.fake.offset),
		max = ui.get(slot2.fake.max),
		add = ui.get(slot2.fake.add) * 0.1,
		dec = ui.get(slot2.fake.dec) * 0.01,
		lag = ui.get(slot2.fake.lag),
		divs = ui.get(slot2.fake.divs)
	},
	real = {
		draw = function ()
		end,
		angles = {},
		color = {
			ui.get(slot8)
		},
		offset = ui.get(slot2.real.offset),
		max = ui.get(slot2.real.max),
		add = ui.get(slot2.real.add) * 0.1,
		dec = ui.get(slot2.real.dec) * 0.01,
		lag = ui.get(slot2.real.lag),
		divs = ui.get(slot2.real.divs)
	}
}
slot8 = slot2.real.color

for slot8 = 1, 361 do
	slot4.fake.angles[slot8] = 0
	slot4.real.angles[slot8] = 0
end

ui.set_callback(slot2.fake.color, function ()
	uv0.fake.color = {
		ui.get(uv1.fake.color)
	}
end)
ui.set_callback(slot2.fake.offset, function ()
	uv0.fake.offset = ui.get(uv1.fake.offset)
end)
ui.set_callback(slot2.fake.max, function ()
	uv0.fake.max = ui.get(uv1.fake.max)
end)
ui.set_callback(slot2.fake.add, function ()
	uv0.fake.add = ui.get(uv1.fake.add) * 0.1
end)
ui.set_callback(slot2.fake.dec, function ()
	uv0.fake.dec = ui.get(uv1.fake.dec) * 0.01
end)
ui.set_callback(slot2.fake.lag, function ()
	uv0.fake.lag = ui.get(uv1.fake.lag)
end)
ui.set_callback(slot2.fake.divs, function ()
	uv0.fake.divs = ui.get(uv1.fake.divs)
end)
ui.set_callback(slot2.real.color, function ()
	uv0.real.color = {
		ui.get(uv1.real.color)
	}
end)
ui.set_callback(slot2.real.offset, function ()
	uv0.real.offset = ui.get(uv1.real.offset)
end)
ui.set_callback(slot2.real.max, function ()
	uv0.real.max = ui.get(uv1.real.max)
end)
ui.set_callback(slot2.real.add, function ()
	uv0.real.add = ui.get(uv1.real.add) * 0.1
end)
ui.set_callback(slot2.real.dec, function ()
	uv0.real.dec = ui.get(uv1.real.dec) * 0.01
end)
ui.set_callback(slot2.real.lag, function ()
	uv0.real.lag = ui.get(uv1.real.lag)
end)
ui.set_callback(slot2.real.divs, function ()
	uv0.real.divs = ui.get(uv1.real.divs)
end)

slot5 = {
	Circle = function (slot0)
		slot1 = {}

		for slot6, slot7 in ipairs(slot0.angles) do
			if slot6 % slot0.divs == 0 then
				table.insert(slot1, math.min(0 + slot7, slot0.max))

				slot2 = 0
			end
		end

		slot3 = uv0(entity.get_origin(uv1.lp))

		for slot7 = 1, #slot1 - 1 do
			slot9, slot10 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, slot7 * slot0.divs - slot0.divs / 2) * (slot0.offset + slot1[slot7])):unpack())
			slot12, slot13 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, (slot7 + 1) * slot0.divs - slot0.divs / 2) * (slot0.offset + slot1[slot7 + 1])):unpack())

			renderer.line(slot9, slot10, slot12, slot13, unpack(slot0.color))
		end

		slot5, slot6 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, slot0.divs - slot0.divs / 2) * (slot0.offset + slot1[1])):unpack())
		slot8, slot9 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, #slot1 * slot0.divs - slot0.divs / 2) * (slot0.offset + slot1[#slot1])):unpack())

		renderer.line(slot5, slot6, slot8, slot9, unpack(slot0.color))
	end,
	Lines = function (slot0)
		slot1 = {}

		for slot6, slot7 in ipairs(slot0.angles) do
			if (slot6 - 1) % slot0.divs == 0 then
				table.insert(slot1, math.min(0 + slot7, slot0.max))

				slot2 = 0
			end
		end

		slot3 = uv0(entity.get_origin(uv1.lp))

		for slot7 = 1, #slot1 do
			slot9, slot10 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, slot7 * slot0.divs - slot0.divs * 1.5) * (slot0.offset - 2)):unpack())
			slot12, slot13 = renderer.world_to_screen((slot3 + uv0():init_from_angles(0, slot7 * slot0.divs - slot0.divs * 1.5) * (slot0.offset + slot1[slot7])):unpack())

			renderer.line(slot9, slot10, slot12, slot13, unpack(slot0.color))
		end
	end,
	Off = function (slot0)
	end
}

function slot6(slot0)
	uv0.lp = entity.get_local_player()
	slot1, slot2 = uv1.get_body_yaw()

	if uv0.real.add < 0 then
		uv0.real.angles[slot3] = math.max(uv0.real.angles[math.max(math.min(math.floor(slot1) + 1, 361), 1)] + uv0.real.add, -uv0.real.max)
	else
		uv0.real.angles[slot3] = math.min(slot4 + uv0.real.add, uv0.real.max)
	end

	if uv0.fake.add < 0 then
		uv0.fake.angles[slot5] = math.max(uv0.fake.angles[math.max(math.min(math.floor(slot2) + 1, 361), 1)] + uv0.fake.add, -uv0.fake.max)
	else
		uv0.fake.angles[slot5] = math.min(slot6 + uv0.fake.add, uv0.fake.max)
	end

	if slot0.command_number % uv0.real.lag == 0 then
		for slot10, slot11 in ipairs(uv0.real.angles) do
			if math.abs(slot11) > 0 and slot10 ~= slot3 then
				uv0.real.angles[slot10] = slot11 * uv0.real.dec
			end
		end
	end

	if slot0.command_number % uv0.fake.lag == 0 then
		for slot10, slot11 in ipairs(uv0.fake.angles) do
			if slot11 > 0 and slot10 ~= slot5 then
				uv0.fake.angles[slot10] = slot11 * uv0.fake.dec

				if uv0.fake.angles[slot10] < 0.5 then
					uv0.fake.angles[slot10] = 0
				end
			end
		end
	end
end

function slot7()
	if entity.is_alive(uv0.lp) then
		uv0.fake:draw()
		uv0.real:draw()
	end
end

function slot9()
	uv0.fake.draw = uv1[ui.get(uv2.fake.mode)]
	uv0.real.draw = uv1[ui.get(uv2.real.mode)]

	uv3()
end

function slot10()
	slot1 = ui.get(uv0.enabled) and client.set_event_callback or client.unset_event_callback

	slot1("setup_command", uv1)
	slot1("paint", uv2)
	ui.set_visible(uv0.selector, slot0)
	uv3()
end

ui.set_callback(slot2.real.mode, slot9)
ui.set_callback(slot2.fake.mode, slot9)
ui.set_callback(slot2.selector, function ()
	if ui.get(uv0.enabled) then
		if ui.get(uv0.selector) == "Hide" then
			uv1(uv0.real, false)
			uv1(uv0.fake, false)
		elseif slot0 == "Real" then
			ui.set_visible(uv0.real.mode, true)
			uv1(uv0.real, ui.get(uv0.real.mode) ~= "Off", uv0.real.mode)
			uv1(uv0.fake, false)
		elseif slot0 == "Fake" then
			uv1(uv0.real, false)
			ui.set_visible(uv0.fake.mode, true)
			uv1(uv0.fake, ui.get(uv0.fake.mode) ~= "Off", uv0.fake.mode)
		end
	else
		uv1(uv0.real, false)
		uv1(uv0.fake, false)
	end
end)
ui.set_callback(slot2.enabled, slot10)
slot10()
