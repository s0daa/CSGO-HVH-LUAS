slot0 = string.format
slot1 = math.floor
slot2 = math.ceil
slot3 = math.abs
slot4 = math.min
slot5 = type
slot6 = assert
slot7 = setmetatable
slot8 = globals.frametime
slot11 = vtable_bind("engine.dll", "VEngineClient014", 91, "float(__thiscall*)(void*)")

function slot12(slot0, slot1, slot2, slot3, slot4)
	if uv0(slot0(slot3, slot1, slot2 - slot1, slot4)) == "number" then
		if uv1(slot2 - slot5) <= 0.001 then
			return slot2
		end

		if slot5 % 1 < 0.001 then
			return uv2(slot5)
		end

		if slot6 > 0.999 then
			return uv3(slot5)
		end
	end

	return slot5
end

slot13 = {
	__metatable = false,
	__call = function (slot0, slot1, slot2, slot3)
		slot4 = uv0(slot0.value)

		if uv0(slot2) == "boolean" then
			slot2 = slot2 and 1 or 0
			slot5 = "number"
		end

		uv1(slot4 == slot5, uv2("type mismatch, expected %s (received %s)", slot4, slot5))

		if slot2 ~= slot0.to then
			slot0.clock = 0
			slot0.from = slot0.value
			slot0.to = slot2
		end

		slot6 = uv3() / uv4()

		if slot0.clock == (slot1 or 0.15) then
			return slot2
		end

		if slot6 <= 0 and slot7 <= slot6 then
			slot0.clock = 0
			slot0.from = slot2
			slot0.to = slot2
			slot0.value = slot2

			return slot2
		end

		slot0.clock = uv5(slot0.clock + slot6, slot7)
		slot0.value = uv6(slot3 or slot0.easing, slot0.from, slot2, slot0.clock, slot7)

		return slot0.value
	end,
	__index = slot13
}

return {
	new = function (slot0, slot1, slot2)
		if uv0(slot1) == "boolean" then
			slot1 = slot1 and 1 or 0
		end

		return uv1({
			clock = 0,
			value = slot1 or 0,
			easing = slot2 or function (slot0, slot1, slot2, slot3)
				return slot2 * slot0 / slot3 + slot1
			end
		}, uv2)
	end
}
