slot0 = vtable_bind("engine.dll", "VEngineClient014", 196, "bool(__thiscall*)(void*)")
slot1 = {}
slot2 = {}

function slot3(slot0, slot1)
	slot2, slot3, slot4 = nil

	if not (slot1 or uv0)[1] then
		for slot8 = 1, 256 do
			slot3 = slot8 - 1

			for slot12 = 1, 8 do
				slot3 = bit.bxor(bit.rshift(slot3, 1), bit.band(3988292384.0, -bit.band(slot3, 1)))
			end

			slot1[slot8] = slot3
		end
	end

	slot3 = 4294967295.0

	for slot8 = 1, #slot0 do
		slot3 = bit.bxor(bit.rshift(slot3, 8), slot1[bit.band(bit.bxor(slot3, string.byte(slot0, slot8)), 255) + 1])
	end

	return bit.band(bit.bnot(slot3), 4294967295.0)
end

function slot4()
	for slot3, slot4 in pairs(package.loaded) do
		if readfile(slot3 .. ".lua") then
			if uv1[slot3] then
				if uv1[slot3] ~= uv0(slot5) then
					print(string.format("%s was changed, reloading active scripts!", slot3))
					client.reload_active_scripts()

					return
				end
			else
				uv1[slot3] = slot6
			end
		end
	end
end

slot5 = false

client.set_event_callback("paint_ui", function ()
	slot0 = uv0()

	if uv1 == false and slot0 then
		uv2()
		client.delay_call(0.5, uv2)
	end

	uv1 = slot0
end)
