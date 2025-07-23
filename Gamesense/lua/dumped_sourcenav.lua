-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = string.format
local var_0_2 = var_0_0.cast
local var_0_3 = var_0_0.string
local var_0_4 = {
	b = "int8_t",
	f = "float",
	L = "uint64_t",
	d = "double",
	l = "int64_t",
	c = "const char",
	I = "uint32_t",
	i = "int32_t",
	H = "uint16_t",
	h = "int16_t",
	B = "uint8_t"
}
local var_0_5 = setmetatable({}, {
	__index = function(arg_1_0, arg_1_1)
		local var_1_0 = "struct { "
		local var_1_1 = {}
		local var_1_2 = 1
		local var_1_3 = 1

		while var_1_2 <= arg_1_1:len() do
			local var_1_4 = arg_1_1:sub(var_1_2, -1)
			local var_1_5 = var_1_4:sub(1, 1)
			local var_1_6
			local var_1_7

			if var_0_4[var_1_5] ~= nil then
				var_1_6 = var_0_4[var_1_5]

				if var_1_5 == "c" then
					local var_1_8 = var_1_4:match("^c(%d+)")

					if var_1_8 then
						var_1_2 = var_1_2 + var_1_8:len()
						var_1_7 = tonumber(var_1_8)
					end

					var_1_1[var_1_3] = var_1_7
				end
			else
				error("invalid format string")
			end

			if var_1_6 ~= nil then
				if var_1_7 == nil then
					var_1_0 = var_1_0 .. string.format("%s v%d; ", var_1_6, var_1_3)
				else
					var_1_0 = var_1_0 .. string.format("%s v%d[%d]; ", var_1_6, var_1_3, var_1_7)
				end

				var_1_3 = var_1_3 + 1
			end

			var_1_2 = var_1_2 + 1
		end

		local var_1_9 = var_1_0 .. "} __attribute__((packed))"

		arg_1_0[arg_1_1] = {
			var_0_0.typeof(var_1_9 .. "*"),
			var_0_0.sizeof(var_1_9),
			var_1_3 - 1,
			var_1_1
		}

		return arg_1_0[arg_1_1]
	end
})
local var_0_6 = 0
local var_0_7 = {
	__index = {
		seek = function(arg_2_0, arg_2_1, arg_2_2)
			if arg_2_2 == nil or arg_2_2 == "CUR" then
				arg_2_0.base_va = arg_2_0.base_va + arg_2_1
			elseif arg_2_2 == "END" or arg_2_2 == "SET" then
				arg_2_0.base_va = var_0_0.cast("const uint8_t *", var_0_0.cast("const char *", arg_2_0.raw)) + (arg_2_2 == "SET" and arg_2_1 or arg_2_0.len + arg_2_1)
			end
		end,
		unpack = function(arg_3_0, arg_3_1)
			local var_3_0, var_3_1, var_3_2, var_3_3 = unpack(var_0_5[arg_3_1])
			local var_3_4 = {}
			local var_3_5 = var_0_2(var_3_0, arg_3_0.base_va)[0]

			for iter_3_0 = 1, var_3_2 do
				var_3_4[iter_3_0] = var_3_5[var_0_1("v%d", iter_3_0)]

				if var_3_3[iter_3_0] then
					var_3_4[iter_3_0] = var_0_3(var_3_4[iter_3_0], var_3_3[iter_3_0])
				end
			end

			arg_3_0.base_va = arg_3_0.base_va + var_3_1

			return unpack(var_3_4)
		end,
		unpack_vec = function(arg_4_0)
			local var_4_0, var_4_1, var_4_2 = arg_4_0:unpack("fff")

			return {
				x = var_4_0,
				y = var_4_1,
				z = var_4_2
			}
		end
	}
}

local function var_0_8(arg_5_0)
	local var_5_0 = setmetatable({
		raw = arg_5_0,
		len = arg_5_0:len()
	}, var_0_7)

	var_5_0:seek(0, "SET")

	return var_5_0
end

local var_0_9 = {}

local function var_0_10(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}

	local var_6_0
	local var_6_1
	local var_6_2

	if not arg_6_1[1] then
		for iter_6_0 = 1, 256 do
			local var_6_3 = iter_6_0 - 1

			for iter_6_1 = 1, 8 do
				local var_6_4 = -bit.band(var_6_3, 1)

				var_6_3 = bit.bxor(bit.rshift(var_6_3, 1), bit.band(3988292384, var_6_4))
			end

			arg_6_1[iter_6_0] = var_6_3
		end
	end

	local var_6_5 = 4294967295

	for iter_6_2 = 1, #arg_6_0 do
		local var_6_6 = string.byte(arg_6_0, iter_6_2)

		var_6_5 = bit.bxor(bit.rshift(var_6_5, 8), arg_6_1[bit.band(bit.bxor(var_6_5, var_6_6), 255) + 1])
	end

	return bit.band(bit.bnot(var_6_5), 4294967295)
end

local function var_0_11(arg_7_0, arg_7_1)
	local var_7_0

	if arg_7_1 == nil or arg_7_1 then
		var_7_0 = var_0_10(arg_7_0)

		if var_0_9[var_7_0] ~= nil then
			return var_0_9[var_7_0]
		end
	end

	local var_7_1 = var_0_8(arg_7_0)
	local var_7_2 = {}

	var_7_2.magic, var_7_2.major, var_7_2.minor, var_7_2.bspsize, var_7_2.analyzed, var_7_2.places_count = var_7_1:unpack("IIIIbH")

	assert(var_7_2.magic == 4277009102, "invalid magic, expected 0xFEEDFACE")
	assert(var_7_2.major == 16, "invalid major version, expected 16")
	assert(var_7_2.analyzed == 1, "invalid nav mesh: not analyzed")

	var_7_2.places = {}

	for iter_7_0 = 1, var_7_2.places_count do
		local var_7_3 = {
			name_length = var_7_1:unpack("H")
		}

		var_7_3.name = var_7_1:unpack(string.format("c%db", var_7_3.name_length - 1))
		var_7_2.places[iter_7_0] = var_7_3
	end

	var_7_2.has_unnamed_areas, var_7_2.areas_count = var_7_1:unpack("bI")
	var_7_2.areas = {}

	for iter_7_1 = 1, var_7_2.areas_count do
		local var_7_4 = {}

		var_7_4.id, var_7_4.flags = var_7_1:unpack("II")
		var_7_4.north_west = var_7_1:unpack_vec()
		var_7_4.south_east = var_7_1:unpack_vec()
		var_7_4.north_east_z, var_7_4.south_west_z = var_7_1:unpack("ff")
		var_7_4.connections = {}

		for iter_7_2 = 1, 4 do
			local var_7_5 = {
				count = var_7_1:unpack("I"),
				connections = {}
			}

			for iter_7_3 = 1, var_7_5.count do
				local var_7_6
				local var_7_7 = var_7_1:unpack("I")

				var_7_5.connections[iter_7_3] = var_7_7
			end

			var_7_4.connections[iter_7_2] = var_7_5
		end

		var_7_4.hiding_spots_count = var_7_1:unpack("B")
		var_7_4.hiding_spots = {}

		for iter_7_4 = 1, var_7_4.hiding_spots_count do
			local var_7_8 = {
				id = var_7_1:unpack("I"),
				location = var_7_1:unpack_vec(),
				flags = var_7_1:unpack("b")
			}

			var_7_4.hiding_spots[iter_7_4] = var_7_8
		end

		var_7_4.encounter_paths_count = var_7_1:unpack("I")
		var_7_4.encounter_paths = {}

		for iter_7_5 = 1, var_7_4.encounter_paths_count do
			local var_7_9 = {}

			var_7_9.from_id, var_7_9.from_direction, var_7_9.to_id, var_7_9.to_direction, var_7_9.spots_count = var_7_1:unpack("IBIBB")
			var_7_9.spots = {}

			for iter_7_6 = 1, var_7_9.spots_count do
				var_7_9.spots[iter_7_6] = {}
				var_7_9.spots[iter_7_6].order_id, var_7_9.spots[iter_7_6].distance = var_7_1:unpack("IB")
			end

			var_7_4.encounter_paths[iter_7_5] = var_7_9
		end

		var_7_4.place_id = var_7_1:unpack("H")
		var_7_4.ladders = {}

		for iter_7_7 = 1, 2 do
			var_7_4.ladders[iter_7_7] = {}
			var_7_4.ladders[iter_7_7].connection_count = var_7_1:unpack("I")
			var_7_4.ladders[iter_7_7].connections = {}

			for iter_7_8 = 1, var_7_4.ladders[iter_7_7].connection_count do
				var_7_4.ladders[iter_7_7].connections[iter_7_8] = var_7_1:unpack("I")
			end
		end

		var_7_4.earliest_occupy_time_first_team, var_7_4.earliest_occupy_time_second_team = var_7_1:unpack("ff")
		var_7_4.light_intensity_north_west, var_7_4.light_intensity_north_east, var_7_4.light_intensity_south_east, var_7_4.light_intensity_south_west = var_7_1:unpack("ffff")
		var_7_4.visible_area_count = var_7_1:unpack("I")
		var_7_4.visible_areas = {}

		for iter_7_9 = 1, var_7_4.visible_area_count do
			var_7_4.visible_areas[iter_7_9] = {}
			var_7_4.visible_areas[iter_7_9].id, var_7_4.visible_areas[iter_7_9].attributes = var_7_1:unpack("Ib")
		end

		var_7_4.inherit_visibility_from_area_id = var_7_1:unpack("I")
		var_7_4.garbage_count = var_7_1:unpack("B")

		var_7_1:seek(var_7_4.garbage_count * 14)

		var_7_2.areas[iter_7_1] = var_7_4
	end

	var_7_2.ladders_count = var_7_1:unpack("I")
	var_7_2.ladders = {}

	for iter_7_10 = 1, var_7_2.ladders_count do
		local var_7_10 = {}

		var_7_10.id, var_7_10.width = var_7_1:unpack("If")
		var_7_10.top = var_7_1:unpack_vec()
		var_7_10.bottom = var_7_1:unpack_vec()
		var_7_10.length, var_7_10.direction = var_7_1:unpack("fI")
		var_7_10.top_forward_area_id, var_7_10.top_left_area_id, var_7_10.top_right_area_id, var_7_10.top_behind_area_id = var_7_1:unpack("IIII")
		var_7_10.bottom_area_id = var_7_1:unpack("I")
		var_7_2.ladders[iter_7_10] = var_7_10
	end

	if var_7_0 ~= nil and var_0_9[var_7_0] == nil then
		var_0_9[var_7_0] = var_7_2
	end

	return var_7_2
end

return {
	parse = var_0_11
}
