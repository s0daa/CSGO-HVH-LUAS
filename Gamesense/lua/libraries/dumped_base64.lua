slot0 = require("bit")
slot2 = slot0.lshift
slot3 = slot0.rshift
slot4 = slot0.band
slot5 = string.char
slot6 = string.byte
slot7 = string.gsub
slot8 = string.sub
slot9 = string.format
slot10 = table.concat
slot11 = tostring
slot12 = error
slot13 = pairs

function slot14(slot0, slot1, slot2)
	return uv0(uv1(slot0, slot1), uv2(1, slot2) - 1)
end

function slot15(slot0)
	slot1 = {}
	slot2 = {}

	for slot6 = 1, 65 do
		if slot2[uv0(uv1(slot0, slot6, slot6)) or 32] ~= nil then
			uv2("invalid alphabet: duplicate character " .. uv3(slot7), 3)
		end

		slot1[slot6 - 1] = slot7
		slot2[slot7] = slot6 - 1
	end

	return slot1, slot2
end

slot18, slot19 = slot15("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
slot18, slot19 = slot15("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
slot18 = {
	__index = function (slot0, slot1)
		if type(slot1) == "string" and slot1:len() == 64 or slot1:len() == 65 then
			uv0[slot1], uv1[slot1] = uv2(slot1)

			return slot0[slot1]
		end
	end
}

setmetatable({
	base64 = slot18,
	base64url = slot18
}, slot18)
setmetatable({
	base64 = slot19,
	base64url = slot19
}, slot18)

return {
	encode = function (slot0, slot1)
		slot1 = uv0[slot1 or "base64"] or uv1("invalid alphabet specified", 2)
		slot2 = {}
		slot3 = 1
		slot4 = #uv2(slot0)
		slot6 = {}

		for slot10 = 1, slot4 - slot4 % 3, 3 do
			slot11, slot12, slot13 = uv3(slot0, slot10, slot10 + 2)

			if not slot6[slot11 * 65536 + slot12 * 256 + slot13] then
				slot6[slot14] = uv4(slot1[uv5(slot14, 18, 6)], slot1[uv5(slot14, 12, 6)], slot1[uv5(slot14, 6, 6)], slot1[uv5(slot14, 0, 6)])
			end

			slot2[slot3] = slot15
			slot3 = slot3 + 1
		end

		if slot5 == 2 then
			slot7, slot8 = uv3(slot0, slot4 - 1, slot4)
			slot9 = slot7 * 65536 + slot8 * 256
			slot2[slot3] = uv4(slot1[uv5(slot9, 18, 6)], slot1[uv5(slot9, 12, 6)], slot1[uv5(slot9, 6, 6)], slot1[64])
		elseif slot5 == 1 then
			slot7 = uv3(slot0, slot4) * 65536
			slot2[slot3] = uv4(slot1[uv5(slot7, 18, 6)], slot1[uv5(slot7, 12, 6)], slot1[64], slot1[64])
		end

		return uv6(slot2)
	end,
	decode = function (slot0, slot1)
		slot2 = uv0
		slot2 = "[^%w%+%/%=]"

		if slot2[slot1 or "base64"] or uv1("invalid alphabet specified", 2) then
			slot3, slot4 = nil

			for slot8, slot9 in uv2(slot1) do
				if slot9 == 62 then
					slot3 = slot8
				elseif slot9 == 63 then
					slot4 = slot8
				end
			end

			slot2 = uv3("[^%%w%%%s%%%s%%=]", uv4(slot3), uv4(slot4))
		end

		slot0 = uv5(uv6(slot0), slot2, "")
		slot3 = {}
		slot4 = {}
		slot5 = 1
		slot6 = #slot0

		for slot11 = 1, (uv7(slot0, -2) == "==" and 2 or uv7(slot0, -1) == "=" and 1 or 0) > 0 and slot6 - 4 or slot6, 4 do
			slot12, slot13, slot14, slot15 = uv8(slot0, slot11, slot11 + 3)

			if not slot3[slot12 * 16777216 + slot13 * 65536 + slot14 * 256 + slot15] then
				slot18 = slot1[slot12] * 262144 + slot1[slot13] * 4096 + slot1[slot14] * 64 + slot1[slot15]
				slot3[slot16] = uv4(uv9(slot18, 16, 8), uv9(slot18, 8, 8), uv9(slot18, 0, 8))
			end

			slot4[slot5] = slot17
			slot5 = slot5 + 1
		end

		if slot7 == 1 then
			slot8, slot9, slot10 = uv8(slot0, slot6 - 3, slot6 - 1)
			slot11 = slot1[slot8] * 262144 + slot1[slot9] * 4096 + slot1[slot10] * 64
			slot4[slot5] = uv4(uv9(slot11, 16, 8), uv9(slot11, 8, 8))
		elseif slot7 == 2 then
			slot8, slot9 = uv8(slot0, slot6 - 3, slot6 - 2)
			slot4[slot5] = uv4(uv9(slot1[slot8] * 262144 + slot1[slot9] * 4096, 16, 8))
		end

		return uv10(slot4)
	end
}
