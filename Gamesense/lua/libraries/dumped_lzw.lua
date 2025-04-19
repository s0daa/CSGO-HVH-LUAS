slot0 = string.char
slot1 = type
slot2 = select
slot3 = string.sub
slot4 = table.concat
slot5 = {
	[slot11] = slot12
}
slot6 = {
	[slot12] = slot11
}

for slot10 = 0, 255 do
	slot11 = slot0(slot10)
	slot12 = slot0(slot10, 0)
end

function slot7(slot0, slot1, slot2, slot3)
	if slot2 >= 256 then
		slot2 = 0

		if slot3 + 1 >= 256 then
			slot1 = {}
			slot3 = 1
		end
	end

	slot1[slot0] = uv0(slot2, slot3)

	return slot1, slot2 + 1, slot3
end

function slot9(slot0, slot1, slot2, slot3)
	if slot2 >= 256 then
		slot2 = 0

		if slot3 + 1 >= 256 then
			slot1 = {}
			slot3 = 1
		end
	end

	slot1[uv0(slot2, slot3)] = slot0

	return slot1, slot2 + 1, slot3
end

return {
	compress = function (slot0)
		if uv0(slot0) ~= "string" then
			return nil, "string expected, got " .. uv0(slot0)
		end

		if #slot0 <= 1 then
			return "u" .. slot0
		end

		slot2 = {}
		slot3 = 0
		slot4 = 1
		slot5 = {
			"c"
		}
		slot6 = 1
		slot7 = 2
		slot8 = ""

		for slot12 = 1, slot1 do
			if not uv2[slot8 .. uv1(slot0, slot12, slot12)] and not slot2[slot14] then
				if not (uv2[slot8] or slot2[slot8]) then
					return nil, "algorithm error, could not fetch word"
				end

				slot5[slot7] = slot15
				slot7 = slot7 + 1

				if slot1 <= slot6 + #slot15 then
					return "u" .. slot0
				end

				slot2, slot3, slot4 = uv3(slot14, slot2, slot3, slot4)
				slot8 = slot13
			else
				slot8 = slot14
			end
		end

		slot5[slot7] = uv2[slot8] or slot2[slot8]
		slot7 = slot7 + 1

		if slot1 <= slot6 + #slot5[slot7] then
			return "u" .. slot0
		end

		return uv4(slot5)
	end,
	decompress = function (slot0)
		if uv0(slot0) ~= "string" then
			return nil, "string expected, got " .. uv0(slot0)
		end

		if #slot0 < 1 then
			return nil, "invalid input - not a compressed string"
		end

		if uv1(slot0, 1, 1) == "u" then
			return uv1(slot0, 2)
		elseif slot1 ~= "c" then
			return nil, "invalid input - not a compressed string"
		end

		if #uv1(slot0, 2) < 2 then
			return nil, "invalid input - not a compressed string"
		end

		slot4 = 0
		slot5 = 1
		slot6 = {
			[slot7] = uv2[uv1(slot0, 1, 2)] or ({})[slot8]
		}
		slot7 = 1 + 1

		for slot12 = 3, slot2, 2 do
			slot13 = uv1(slot0, slot12, slot12 + 1)

			if not (uv2[slot8] or slot3[slot8]) then
				return nil, "could not find last from dict. Invalid input?"
			end

			if uv2[slot13] or slot3[slot13] then
				slot6[slot7] = slot15
				slot7 = slot7 + 1
				slot3, slot4, slot5 = uv3(slot14 .. uv1(slot15, 1, 1), slot3, slot4, slot5)
			else
				slot16 = slot14 .. uv1(slot14, 1, 1)
				slot6[slot7] = slot16
				slot7 = slot7 + 1
				slot3, slot4, slot5 = uv3(slot16, slot3, slot4, slot5)
			end

			slot8 = slot13
		end

		return uv4(slot6)
	end
}
