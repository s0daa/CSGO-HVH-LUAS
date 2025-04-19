slot0 = require("ffi")

function slot1(slot0, slot1, slot2)
	if slot0 < slot1 then
		return slot1
	end

	if slot2 < slot0 then
		return slot2
	end

	return slot0
end

function slot2(slot0, slot1, slot2, slot3)
	return uv0(slot0, 0, 255), uv0(slot1, 0, 255), uv0(slot2, 0, 255), uv0(slot3, 0, 255)
end

function slot3(slot0)
	return slot0 + 0.5 - (slot0 + 0.5) % 1
end

function slot4(slot0, slot1, slot2, slot3, slot4)
	slot5 = slot4 and 1 or 255

	if slot0 == nil then
		slot3 = slot5
		slot2 = slot5
		slot1 = slot5
		slot0 = slot5
	elseif slot1 == nil then
		slot3 = slot5
		slot2 = slot0
		slot1 = slot0
	elseif slot2 == nil then
		slot3 = slot1
		slot2 = slot0
		slot1 = slot0
	elseif slot3 == nil then
		slot3 = slot5
	end

	if slot4 then
		slot3 = slot3 * 255
		slot2 = slot2 * 255
		slot1 = slot1 * 255
		slot0 = slot0 * 255
	end

	return uv0(uv1(slot0), uv1(slot1), uv1(slot2), uv1(slot3))
end

function slot5(slot0)
	if slot0:sub(1, 1) == "#" then
		slot0 = slot0:sub(2)
	end

	return tonumber(slot0:sub(1, 2), 16), tonumber(slot0:sub(3, 4), 16), tonumber(slot0:sub(5, 6), 16), tonumber(slot0:sub(7, 8), 16)
end

function slot6(slot0, slot1, slot2)
	if slot2 < 0 then
		slot2 = slot2 + 1
	end

	if slot2 > 1 then
		slot2 = slot2 - 1
	end

	if slot2 < 0.16666666666666666 then
		return slot0 + (slot1 - slot0) * 6 * slot2
	end

	if slot2 < 0.5 then
		return slot1
	end

	if slot2 < 0.6666666666666666 then
		return slot0 + (slot1 - slot0) * (0.6666666666666666 - slot2) * 6
	end

	return slot0
end

function slot7(slot0, slot1, slot2, slot3)
	slot4, slot5, slot6 = nil

	if slot1 == 0 then
		slot6 = slot2
		slot5 = slot2
		slot4 = slot2
	else
		slot7 = slot2 < 0.5 and slot2 * (1 + slot1) or slot2 + slot1 - slot2 * slot1
		slot8 = 2 * slot2 - slot7
		slot4 = uv0(slot8, slot7, slot0 + 0.3333333333333333)
		slot5 = uv0(slot8, slot7, slot0)
		slot6 = uv0(slot8, slot7, slot0 - 0.3333333333333333)
	end

	return slot4 * 255, slot5 * 255, slot6 * 255, slot3
end

function slot8(slot0, slot1, slot2, slot3)
	slot4, slot5, slot6 = nil
	slot7 = math.floor(slot0 * 6)
	slot8 = slot0 * 6 - slot7
	slot10 = slot2 * (1 - slot8 * slot1)

	if slot7 % 6 == 0 then
		slot6 = slot2 * (1 - slot1)
		slot5 = slot2 * (1 - (1 - slot8) * slot1)
		slot4 = slot2
	elseif slot7 == 1 then
		slot6 = slot9
		slot5 = slot2
		slot4 = slot10
	elseif slot7 == 2 then
		slot6 = slot11
		slot5 = slot2
		slot4 = slot9
	elseif slot7 == 3 then
		slot6 = slot2
		slot5 = slot10
		slot4 = slot9
	elseif slot7 == 4 then
		slot6 = slot2
		slot5 = slot9
		slot4 = slot11
	elseif slot7 == 5 then
		slot6 = slot10
		slot5 = slot9
		slot4 = slot2
	end

	return slot4 * 255, slot5 * 255, slot6 * 255, slot3
end

function slot9(slot0, slot1, slot2, slot3)
	return string.format("%02x%02x%02x%02x", slot0, slot1, slot2, slot3)
end

function slot10(slot0, slot1, slot2, slot3)
	slot2 = slot2 / 255
	slot1 = slot1 / 255
	slot0 = slot0 / 255
	slot4 = math.max(slot0, slot1, slot2)
	slot5 = math.min(slot0, slot1, slot2)
	slot6 = (slot4 + slot5) / 2
	slot7 = 0
	slot8 = (slot4 + slot5) / 2

	if slot4 ~= slot5 then
		slot9 = slot4 - slot5
		slot7 = slot8 > 0.5 and slot9 / (2 - slot4 - slot5) or slot9 / (slot4 + slot5)

		if slot4 == slot0 then
			slot6 = (slot1 - slot2) / slot9 + (slot1 < slot2 and 6 or 0)
		elseif slot4 == slot1 then
			slot6 = (slot2 - slot0) / slot9 + 2
		elseif slot4 == slot2 then
			slot6 = (slot0 - slot1) / slot9 + 4
		end

		slot6 = slot6 / 6
	end

	return slot6, slot7, slot8, slot3
end

function slot11(slot0, slot1, slot2, slot3)
	slot2 = slot2 / 255
	slot1 = slot1 / 255
	slot0 = slot0 / 255
	slot4 = math.max(slot0, slot1, slot2)
	slot5 = math.min(slot0, slot1, slot2)
	slot6 = slot4
	slot7 = slot4 == 0 and 0 or (slot4 - slot5) / slot4
	slot8 = slot4

	if slot4 ~= slot5 then
		if slot4 == slot0 then
			slot6 = (slot1 - slot2) / (slot4 - slot5) + (slot1 < slot2 and 6 or 0)
		elseif slot4 == slot1 then
			slot6 = (slot2 - slot0) / slot9 + 2
		elseif slot4 == slot2 then
			slot6 = (slot0 - slot1) / slot9 + 4
		end

		slot6 = slot6 / 6
	end

	return slot6, slot7, slot8, slot3
end

function slot12(slot0)
	if type(slot0[1]) ~= "table" then
		for slot5, slot6 in ipairs(slot0) do
			slot0[slot5] = {
				slot6,
				(slot5 - 1) * 1 / (#slot0 - 1)
			}
		end
	end

	if #slot0 < 2 then
		error("2 or more colors required!")
	end

	if slot0[1][2] ~= 0 then
		error("First color must start at position 0!")
	end

	if slot0[#slot0][2] ~= 1 then
		error("Last color must end at position 1!")
	end

	slot1 = 0

	for slot5, slot6 in ipairs(slot0) do
		if not slot6[2] then
			error("Color doesn't have a stop property!")
		end

		if slot7 < 0 or slot7 > 1 then
			error("Color stop is out of boundaries!")
		end

		if slot1 <= slot7 then
			slot1 = slot7
		else
			error("Color stops are out of order!")
		end
	end

	return slot0
end

slot14 = {
	__index = slot14,
	__metatable = "Read only",
	color = true
}
slot15 = setmetatable({}, slot14)

function slot14.__call(slot0, slot1, slot2, slot3, slot4, slot5)
	slot1, slot2, slot3, slot4 = uv0(slot1, slot2, slot3, slot4, slot5)

	if not uv1 then
		return setmetatable({
			r = slot1,
			g = slot2,
			b = slot3,
			a = slot4
		}, uv2)
	end

	return uv1(slot1, slot2, slot3, slot4)
end

function slot14.fraction(slot0, slot1, slot2, slot3)
	return uv0(slot0, slot1, slot2, slot3, true)
end

function slot14.hex(slot0)
	slot1, slot2, slot3, slot4 = uv0(slot0)

	return uv1(slot1, slot2, slot3, slot4)
end

function slot14.hsl(slot0, slot1, slot2, slot3)
	slot4, slot5, slot6, slot7 = uv0(slot0, slot1, slot2, slot3)

	return uv1(slot4, slot5, slot6, slot7)
end

function slot14.hsv(slot0, slot1, slot2, slot3)
	slot4, slot5, slot6, slot7 = uv0(slot0, slot1, slot2, slot3)

	return uv1(slot4, slot5, slot6, slot7)
end

function slot14.to_hex(slot0)
	return uv0(slot0.r, slot0.g, slot0.b, slot0.a)
end

function slot14.to_hsl(slot0)
	return uv0(slot0.r, slot0.g, slot0.b, slot0.a)
end

function slot14.to_hsv(slot0)
	return uv0(slot0.r, slot0.g, slot0.b, slot0.a)
end

function slot14.__tostring(slot0)
	return string.format("color(%d, %d, %d, %d)", slot0.r, slot0.g, slot0.b, slot0.a)
end

function slot14.__concat(slot0, slot1)
	return tostring(slot0) .. tostring(slot1)
end

function slot14.__add(slot0, slot1)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return uv0(slot0.r + slot1.r, slot0.g + slot1.g, slot0.b + slot1.b, slot0.a + slot1.a)
end

function slot14.__sub(slot0, slot1)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return uv0(slot0.r - slot1.r, slot0.g - slot1.g, slot0.b - slot1.b, slot0.a - slot1.a)
end

function slot14.__mul(slot0, slot1)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return uv0(slot0.r * slot1.r, slot0.g * slot1.g, slot0.b * slot1.b, slot0.a * slot1.a)
end

function slot14.__div(slot0, slot1)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return uv0(slot0.r / slot1.r, slot0.g / slot1.g, slot0.b / slot1.b, slot0.a / slot1.a)
end

function slot14.__eq(slot0, slot1)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return slot0.r == slot1.r and slot0.g == slot1.g and slot0.b == slot1.b and slot0.a == slot1.a
end

function slot14.lerp(slot0, slot1, slot2)
	slot1 = uv0.is_color(slot1) and slot1 or uv0(slot1)

	return uv0(slot0.r + (slot1.r - slot0.r) * slot2, slot0.g + (slot1.g - slot0.g) * slot2, slot0.b + (slot1.b - slot0.b) * slot2, slot0.a + (slot1.a - slot0.a) * slot2)
end

function slot14.gamma_correct(slot0, slot1)
	return uv0(math.pow(slot0.r, slot1), math.pow(slot0.g, slot1), math.pow(slot0.b, slot1), slot0.a)
end

function slot14.grayscale(slot0)
	slot1 = (slot0.r + slot0.g + slot0.b) / 3

	return uv0(slot1, slot1, slot1, slot0.a)
end

function slot14.invert(slot0)
	return uv0(255 - slot0.r, 255 - slot0.g, 255 - slot0.b, slot0.a)
end

function slot14.rotate(slot0, slot1)
	slot2, slot3, slot4 = uv0(slot0.r, slot0.g, slot0.b, slot0.a)
	slot5, slot6, slot7 = uv1((slot2 * 360 + slot1) % 360 / 360, slot3, slot4, slot0.a)

	return uv2(slot5, slot6, slot7, slot0.a)
end

function slot14.alpha_modulate(slot0, slot1)
	return uv0(slot0.r, slot0.g, slot0.b, slot1)
end

function slot14.unpack(slot0, slot1)
	if slot1 then
		return slot0.r, slot0.g, slot0.b
	end

	return slot0.r, slot0.g, slot0.b, slot0.a
end

function slot14.clone(slot0)
	return uv0(slot0.r, slot0.g, slot0.b, slot0.a)
end

function slot15.is_color(slot0)
	return (type(slot0) == "table" or type(slot0) == "cdata") and slot0.color
end

function slot15.linear_gradient(slot0, slot1)
	slot0 = uv0(slot0)
	slot2 = 1

	while slot0[slot2 + 1][2] < slot1 do
		slot2 = slot2 + 1
	end

	return slot0[slot2][1]:lerp(slot0[slot2 + 1][1], (slot1 - slot0[slot2][2]) / (slot0[slot2 + 1][2] - slot0[slot2][2]))
end

slot0.metatype(slot0.typeof("struct { uint8_t r, g, b, a;}"), slot14)

return slot15
