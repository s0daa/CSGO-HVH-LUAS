slot0 = {}
slot1 = table.insert
slot2 = table.concat
slot3 = string.rep
slot4 = string.len
slot5 = string.sub
slot6 = math.max
slot7 = math.floor
slot8 = math.ceil

function slot9(slot0)
	slot1, slot2 = string.gsub(tostring(slot0), "[^\\x80-\\xc1]", "")

	return slot2
end

for slot14, slot15 in pairs({
	ASCII = {
		"-",
		"|",
		"+"
	},
	Compact = {
		"-",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		" "
	},
	["ASCII (Girder)"] = {
		"=",
		"||",
		"//",
		"[]",
		"\\\\",
		"|]",
		"[]",
		"[|",
		"\\\\",
		"[]",
		"//"
	},
	Unicode = {
		"═",
		"║",
		"╔",
		"╦",
		"╗",
		"╠",
		"╬",
		"╣",
		"╚",
		"╩",
		"╝"
	},
	["Unicode (Single Line)"] = {
		"─",
		"│",
		"┌",
		"┬",
		"┐",
		"├",
		"┼",
		"┤",
		"└",
		"┴",
		"┘"
	},
	["Markdown (Github)"] = {
		"-",
		"|",
		"|"
	}
}) do
	if #slot15 == 3 then
		for slot19 = 4, 11 do
			slot15[slot19] = slot15[3]
		end
	end
end

function slot11(slot0, slot1)
	slot0 = uv0(slot0, 1, slot1)
	slot2 = uv1(slot0)

	return uv2(" ", uv3(slot1 / 2 - slot2 / 2)) .. slot0 .. uv2(" ", uv4(slot1 / 2 - slot2 / 2))
end

function slot12(slot0, slot1)
	slot0 = uv0(slot0, 1, slot1)

	return slot0 .. uv1(" ", slot1 - uv2(slot0))
end

function slot0.generate_table(slot0, slot1, slot2)
	if type(slot2) == "string" or slot2 == nil then
		slot2 = {
			style = slot2 or "ASCII"
		}
	end

	if slot2.top_line == nil then
		slot2.top_line = slot2.style ~= "Markdown (Github)"
	end

	if slot2.bottom_line == nil then
		slot2.bottom_line = slot2.style ~= "Markdown (Github)"
	end

	if slot2.header_seperator_line == nil then
		slot2.header_seperator_line = true
	end

	slot3 = uv0[slot2.style] or uv0.ASCII
	slot4 = {}
	slot5 = {}
	slot6 = 0

	if slot1 ~= nil and #slot1 > 0 then
		for slot11 = 1, #slot1 do
			slot5[slot11] = uv1(slot1[slot11]) + 2
		end

		slot6 = #slot1
	else
		for slot11 = 1, #slot0 do
			slot6 = uv2(slot6, #slot0[slot11])
		end
	end

	for slot11 = 1, #slot0 do
		for slot16 = 1, slot6 do
			slot5[slot16] = uv2(slot5[slot16] or 2, uv1(slot0[slot11][slot16]) + 2)
		end
	end

	for slot12 = 1, slot6 do
		uv3({}, uv4(slot3[1], slot5[slot12]))
	end

	if slot2.top_line then
		uv3(slot4, slot3[3] .. uv5(slot8, slot3[4]) .. slot3[5])
	end

	if slot7 then
		for slot13 = 1, slot6 do
		end

		uv3(slot4, slot3[2] .. uv5({
			[slot13] = uv6(slot1[slot13], slot5[slot13])
		}, slot3[2]) .. slot3[2])

		if slot2.header_seperator_line then
			uv3(slot4, slot3[6] .. uv5(slot8, slot3[7]) .. slot3[8])
		end
	end

	for slot12 = 1, #slot0 do
		slot14 = {}

		if #slot0[slot12] == 0 then
			uv3(slot4, slot3[6] .. uv5(slot8, slot3[7]) .. slot3[8])
		else
			for slot18 = 1, slot6 do
				slot14[slot18] = " " .. (slot2.value_justify == "center" and uv6(slot13[slot18] or "", slot5[slot18] - 2) or uv7(slot13[slot18] or "", slot5[slot18] - 2)) .. " "
			end

			uv3(slot4, slot3[2] .. uv5(slot14, slot3[2]) .. slot3[2])
		end
	end

	if slot2.bottom_line and slot3[9] then
		uv3(slot4, slot3[9] .. uv5(slot8, slot3[10]) .. slot3[11])
	end

	return uv5(slot4, "\n")
end

return setmetatable(slot0, {
	__call = function (slot0, ...)
		return uv0.generate_table(...)
	end
})
