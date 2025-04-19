slot0 = require("ffi")
slot1 = string.format
slot2 = slot0.cast
slot3 = slot0.string
slot4 = {
	f = "float",
	H = "uint16_t",
	d = "double",
	h = "int16_t",
	c = "const char",
	B = "uint8_t",
	b = "int8_t",
	L = "uint64_t",
	l = "int64_t",
	I = "uint32_t",
	i = "int32_t"
}
slot5 = setmetatable({}, {
	__index = function (slot0, slot1)
		slot2 = "struct { "
		slot3 = {}
		slot4 = 1
		slot5 = 1

		while slot4 <= slot1:len() do
			slot8, slot9 = nil

			if uv0[slot1:sub(slot4, -1):sub(1, 1)] ~= nil then
				slot8 = uv0[slot7]

				if slot7 == "c" then
					if slot6:match("^c(%d+)") then
						slot4 = slot4 + slot10:len()
						slot9 = tonumber(slot10)
					end

					slot3[slot5] = slot9
				end
			else
				error("invalid format string")
			end

			if slot8 ~= nil then
				slot2 = slot9 == nil and slot2 .. string.format("%s v%d; ", slot8, slot5) or slot2 .. string.format("%s v%d[%d]; ", slot8, slot5, slot9)
				slot5 = slot5 + 1
			end

			slot4 = slot4 + 1
		end

		slot2 = slot2 .. "} __attribute__((packed))"
		slot0[slot1] = {
			uv1.typeof(slot2 .. "*"),
			uv1.sizeof(slot2),
			slot5 - 1,
			slot3
		}

		return slot0[slot1]
	end
})
slot6 = 0
slot7 = {
	__index = {
		seek = function (slot0, slot1, slot2)
			if slot2 == nil or slot2 == "CUR" then
				slot0.base_va = slot0.base_va + slot1
			elseif slot2 == "END" or slot2 == "SET" then
				slot0.base_va = uv0.cast("const uint8_t *", uv0.cast("const char *", slot0.raw)) + (slot2 == "SET" and slot1 or slot0.len + slot1)
			end
		end,
		unpack = function (slot0, slot1)
			slot2, slot3, slot4, slot5 = unpack(uv0[slot1])
			slot6 = {
				[slot11] = uv1(slot2, slot0.base_va)[0][uv2("v%d", slot11)]
			}

			for slot11 = 1, slot4 do
				if slot5[slot11] then
					slot6[slot11] = uv3(slot6[slot11], slot5[slot11])
				end
			end

			slot0.base_va = slot0.base_va + slot3

			return unpack(slot6)
		end,
		unpack_vec = function (slot0)
			slot1, slot2, slot3 = slot0:unpack("fff")

			return {
				x = slot1,
				y = slot2,
				z = slot3
			}
		end
	}
}

function slot8(slot0)
	slot1 = setmetatable({
		raw = slot0,
		len = slot0:len()
	}, uv0)

	slot1:seek(0, "SET")

	return slot1
end

slot9 = {}

function slot10(slot0, slot1)
	slot2, slot3, slot4 = nil

	if not (slot1 or {})[1] then
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

return {
	parse = function (slot0, slot1)
		slot2 = nil

		if (slot1 == nil or slot1) and uv1[uv0(slot0)] ~= nil then
			return uv1[slot2]
		end

		slot5, slot6, slot7, slot8, slot9, slot10 = uv2(slot0):unpack("IIIIbH")

		assert(({
			places_count = slot10,
			analyzed = slot9,
			bspsize = slot8,
			minor = slot7,
			major = slot6,
			magic = slot5
		}).magic == 4277009102.0, "invalid magic, expected 0xFEEDFACE")
		assert(slot4.major == 16, "invalid major version, expected 16")
		assert(slot4.analyzed == 1, "invalid nav mesh: not analyzed")

		slot4.places = {}

		for slot8 = 1, slot4.places_count do
			slot9 = {
				name_length = slot3:unpack("H")
			}
			slot9.name = slot3:unpack(string.format("c%db", slot9.name_length - 1))
			slot4.places[slot8] = slot9
		end

		slot4.has_unnamed_areas, slot4.areas_count = slot3:unpack("bI")
		slot4.areas = {}

		for slot8 = 1, slot4.areas_count do
			slot9 = {
				flags = slot11,
				id = slot10,
				north_west = slot3:unpack_vec(),
				south_east = slot3:unpack_vec(),
				south_west_z = slot11,
				north_east_z = slot10,
				connections = {}
			}
			slot10, slot11 = slot3:unpack("II")
			slot10, slot11 = slot3:unpack("ff")

			for slot13 = 1, 4 do
				for slot18 = 1, ({
					count = slot3:unpack("I"),
					connections = {}
				}).count do
					slot19 = nil
					slot14.connections[slot18] = slot3:unpack("I")
				end

				slot9.connections[slot13] = slot14
			end

			slot9.hiding_spots_count = slot3:unpack("B")
			slot9.hiding_spots = {}

			for slot13 = 1, slot9.hiding_spots_count do
				slot9.hiding_spots[slot13] = {
					id = slot3:unpack("I"),
					location = slot3:unpack_vec(),
					flags = slot3:unpack("b")
				}
			end

			slot9.encounter_paths_count = slot3:unpack("I")
			slot9.encounter_paths = {}

			for slot13 = 1, slot9.encounter_paths_count do
				slot15, slot16, slot17, slot18, slot19 = slot3:unpack("IBIBB")

				for slot18 = 1, ({
					spots_count = slot19,
					to_direction = slot18,
					to_id = slot17,
					from_direction = slot16,
					from_id = slot15,
					spots = {}
				}).spots_count do
					slot14.spots[slot18] = {}
					slot14.spots[slot18].order_id, slot14.spots[slot18].distance = slot3:unpack("IB")
				end

				slot9.encounter_paths[slot13] = slot14
			end

			slot9.place_id = slot3:unpack("H")
			slot9.ladders = {}

			for slot13 = 1, 2 do
				slot9.ladders[slot13] = {}
				slot17 = "I"
				slot9.ladders[slot13].connection_count = slot3:unpack(slot17)
				slot9.ladders[slot13].connections = {}

				for slot17 = 1, slot9.ladders[slot13].connection_count do
					slot9.ladders[slot13].connections[slot17] = slot3:unpack("I")
				end
			end

			slot9.earliest_occupy_time_first_team, slot9.earliest_occupy_time_second_team = slot3:unpack("ff")
			slot9.light_intensity_north_west, slot9.light_intensity_north_east, slot9.light_intensity_south_east, slot13 = slot3:unpack("ffff")
			slot9.light_intensity_south_west = slot13
			slot9.visible_area_count = slot3:unpack("I")
			slot9.visible_areas = {}

			for slot13 = 1, slot9.visible_area_count do
				slot9.visible_areas[slot13] = {}
				slot9.visible_areas[slot13].id, slot9.visible_areas[slot13].attributes = slot3:unpack("Ib")
			end

			slot9.inherit_visibility_from_area_id = slot3:unpack("I")
			slot9.garbage_count = slot3:unpack("B")

			slot3:seek(slot9.garbage_count * 14)

			slot4.areas[slot8] = slot9
		end

		slot4.ladders_count = slot3:unpack("I")
		slot4.ladders = {}

		for slot8 = 1, slot4.ladders_count do
			slot10, slot11 = slot3:unpack("If")
			slot10, slot11 = slot3:unpack("fI")
			slot10, slot11, slot12, slot13 = slot3:unpack("IIII")
			slot4.ladders[slot8] = {
				width = slot11,
				id = slot10,
				top = slot3:unpack_vec(),
				bottom = slot3:unpack_vec(),
				direction = slot11,
				length = slot10,
				top_behind_area_id = slot13,
				top_right_area_id = slot12,
				top_left_area_id = slot11,
				top_forward_area_id = slot10,
				bottom_area_id = slot3:unpack("I")
			}
		end

		if slot2 ~= nil and uv1[slot2] == nil then
			uv1[slot2] = slot4
		end

		return slot4
	end
}
