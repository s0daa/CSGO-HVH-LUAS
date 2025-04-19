slot1 = client.set_cvar
slot2 = math.fmod
slot3 = tonumber
slot4 = ui.get
slot5 = ui.new_slider
slot6 = ui.set_callback
slot7 = ui.set_visible

function slot8(slot0)
	slot1, slot2 = uv0()
	slot3 = slot1 * slot0 / slot2

	if slot0 == 1 then
		slot3 = 0
	end

	uv1("r_aspectratio", uv2(slot3))
end

function slot9(slot0, slot1)
	while slot0 ~= 0 do
		slot0 = uv0(slot0, slot0)
	end

	return slot1
end

slot10, slot11, slot12 = nil

function slot13()
	uv2(2 - uv0(uv1) * 0.01)
end

slot14 = 0.01
slot15 = 200

function (slot0, slot1)
	uv1 = slot1
	uv0 = slot0
	slot2 = {
		[slot6] = uv0 * slot7 / slot8 .. ":" .. uv1 / slot8
	}

	for slot6 = 1, uv2 do
		slot7 = (uv2 - slot6) * uv3

		if uv0 * slot7 / uv4(uv0 * slot7, uv1) < 100 or slot7 == 1 then
			-- Nothing
		end
	end

	if uv5 ~= nil then
		uv6(uv5, false)
		uv7(uv5, function ()
		end)
	end

	uv5 = uv8("VISUALS", "Effects", "Force aspect ratio", 0, uv2 - 1, uv2 / 2, true, "%", 1, slot2)

	uv7(uv5, uv9)
end(client.screen_size())
client.set_event_callback("paint", function (slot0)
	slot1, slot2 = uv0()

	if slot1 ~= uv1 or slot2 ~= uv2 then
		uv3(slot1, slot2)
	end
end)
