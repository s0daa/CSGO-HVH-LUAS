local ffi = require "ffi"

local string_format = string.format
local ffi_cast = ffi.cast
local ffi_string = ffi.string

local ffi_type_map = {
	b = "int8_t", -- "b" a signed char.
	B = "uint8_t", -- "B" an unsigned char.
	h = "int16_t", -- "h" a signed short (2 bytes).
	H = "uint16_t", -- "H" an unsigned short (2 bytes).
	i = "int32_t", -- "i" a signed int (4 bytes).
	I = "uint32_t", -- "I" an unsigned int (4 bytes).
	l = "int64_t", -- "l" a signed long (8 bytes).
	L = "uint64_t", -- "L" an unsigned long (8 bytes).
	f = "float", -- "f" a float (4 bytes).
	d = "double", -- "d" a double (8 bytes).
	c = "const char" -- "cn" a sequence of exactly n chars corresponding to a single Lua string.
}

local ffi_structs = setmetatable({}, {
	__index = function(tbl, key)
		local struct_text = "struct { "

		local string_vals = {}
		local i, j = 1, 1
		while i <= key:len() do
			local a = key:sub(i, -1)
			local c = a:sub(1, 1)

			local t, l
			if ffi_type_map[c] ~= nil then
				t = ffi_type_map[c]
				if c == "c" then
					local match = a:match("^c(%d+)")

					if match then
						i = i + match:len()
						l = tonumber(match)
					end

					string_vals[j] = l
				end
			else
				error("invalid format string")
			end

			if t ~= nil then
				if l == nil then
					struct_text = struct_text .. string.format("%s v%d; ", t, j)
				else
					struct_text = struct_text .. string.format("%s v%d[%d]; ", t, j, l)
				end
				j = j + 1
			end
			i = i + 1
		end
		struct_text = struct_text .. "} __attribute__((packed))"

		tbl[key] = {ffi.typeof(struct_text .. "*"), ffi.sizeof(struct_text), j-1, string_vals}

		return tbl[key]
	end
})

local unpacks = 0
local struct_buffer_mt = {
	__index = {
		seek = function(self, seek_val, seek_mode)
			if seek_mode == nil or seek_mode == "CUR" then
				self.base_va = self.base_va + seek_val
			elseif seek_mode == "END" or seek_mode == "SET" then
				self.base_va = ffi.cast("const uint8_t *", ffi.cast("const char *", self.raw)) + (seek_mode == "SET" and seek_val or self.len + seek_val)
			end
		end,
		unpack = function(self, format_str)
			local struct, size, len, string_vals = unpack(ffi_structs[format_str])
			local unpacked = {}
			local val = ffi_cast(struct, self.base_va)[0]

			for i=1, len do
				unpacked[i] = val[string_format("v%d", i)]

				if string_vals[i] then
					unpacked[i] = ffi_string(unpacked[i], string_vals[i])
				end
			end

			self.base_va = self.base_va + size

			return unpack(unpacked)
		end,
		unpack_vec = function(self)
			local x, y, z = self:unpack("fff")
			return {x=x, y=y, z=z}
		end
	}
}

local function struct_buffer(raw)
	local buf = setmetatable({
		raw = raw,
		len = raw:len()
	}, struct_buffer_mt)
	buf:seek(0, "SET")
	return buf
end

-- cache
local navigation_mesh_cache = {}

-- use checksum so we dont have to keep the whole thing in memory
local function crc32(s, lt)
	-- return crc32 checksum of string as an integer
	-- use lookup table lt if provided or create one on the fly
	-- if lt is empty, it is initialized.
	lt = lt or {}
	local b, crc, mask
	if not lt[1] then -- setup table
		for i = 1, 256 do
			crc = i - 1
			for _ = 1, 8 do --eight times
				mask = -bit.band(crc, 1)
				crc = bit.bxor(bit.rshift(crc, 1), bit.band(0xedb88320, mask))
			end
			lt[i] = crc
		end
	end

	-- compute the crc
	crc = 0xffffffff
	for i = 1, #s do
		b = string.byte(s, i)
		crc = bit.bxor(bit.rshift(crc, 8), lt[bit.band(bit.bxor(crc, b), 0xFF) + 1])
	end
	return bit.band(bit.bnot(crc), 0xffffffff)
end

local function parse(raw, use_cache)
	local checksum
	if use_cache == nil or use_cache then
		checksum = crc32(raw)
		if navigation_mesh_cache[checksum] ~= nil then
			return navigation_mesh_cache[checksum]
		end
	end

	local buf = struct_buffer(raw)

	local self = {}
	self.magic, self.major, self.minor, self.bspsize, self.analyzed, self.places_count = buf:unpack("IIIIbH")

	assert(self.magic == 0xFEEDFACE, "invalid magic, expected 0xFEEDFACE")
	assert(self.major == 16, "invalid major version, expected 16")
	assert(self.analyzed == 1, "invalid nav mesh: not analyzed")

	-- place names
	self.places = {}
	for i=1, self.places_count do
		local place = {}
		place.name_length = buf:unpack("H")

		-- read but ignore null byte
		place.name = buf:unpack(string.format("c%db", place.name_length-1))

		self.places[i] = place
	end

	-- areas
	self.has_unnamed_areas, self.areas_count = buf:unpack("bI")

	self.areas = {}
	for i=1, self.areas_count do
		local area = {}
		area.id, area.flags = buf:unpack("II")

		area.north_west = buf:unpack_vec()
		area.south_east = buf:unpack_vec()

		area.north_east_z, area.south_west_z = buf:unpack("ff")

		-- connections
		area.connections = {}
		for dir=1, 4 do
			local connections_dir = {}
			connections_dir.count = buf:unpack("I")

			connections_dir.connections = {}
			for i=1, connections_dir.count do
				local target
				target = buf:unpack("I")
				connections_dir.connections[i] = target
			end
			area.connections[dir] = connections_dir
		end

		-- hiding spots
		area.hiding_spots_count = buf:unpack("B")
		area.hiding_spots = {}
		for i=1, area.hiding_spots_count do
			local hiding_spot = {}
			hiding_spot.id = buf:unpack("I")
			hiding_spot.location = buf:unpack_vec()
			hiding_spot.flags = buf:unpack("b")
			area.hiding_spots[i] = hiding_spot
		end

		-- encounter paths
		area.encounter_paths_count = buf:unpack("I")

		area.encounter_paths = {}
		for i=1, area.encounter_paths_count do
			local encounter_path = {}
			encounter_path.from_id, encounter_path.from_direction, encounter_path.to_id, encounter_path.to_direction, encounter_path.spots_count = buf:unpack("IBIBB")

			encounter_path.spots = {}
			for i=1, encounter_path.spots_count do
				encounter_path.spots[i] = {}
				encounter_path.spots[i].order_id, encounter_path.spots[i].distance = buf:unpack("IB")
			end
			area.encounter_paths[i] = encounter_path
		end

		area.place_id = buf:unpack("H")

		-- place ladders
		area.ladders = {}
		for i=1, 2 do
			area.ladders[i] = {}
			area.ladders[i].connection_count = buf:unpack("I")

			area.ladders[i].connections = {}
			for j=1, area.ladders[i].connection_count do
				area.ladders[i].connections[j] = buf:unpack("I")
			end
		end

		area.earliest_occupy_time_first_team, area.earliest_occupy_time_second_team = buf:unpack("ff")
		area.light_intensity_north_west, area.light_intensity_north_east, area.light_intensity_south_east, area.light_intensity_south_west = buf:unpack("ffff")

		-- visible areas
		area.visible_area_count = buf:unpack("I")
		area.visible_areas = {}
		for i=1, area.visible_area_count do
			area.visible_areas[i] = {}
			area.visible_areas[i].id, area.visible_areas[i].attributes = buf:unpack("Ib")
		end
		area.inherit_visibility_from_area_id = buf:unpack("I")

		-- garbage?
		area.garbage_count = buf:unpack("B")
		buf:seek(area.garbage_count*14)

		self.areas[i] = area
	end

	-- ladders
	self.ladders_count = buf:unpack("I")
	self.ladders = {}
	for i=1, self.ladders_count do
		local ladder = {}
		ladder.id, ladder.width = buf:unpack("If")

		ladder.top = buf:unpack_vec()
		ladder.bottom = buf:unpack_vec()

		ladder.length, ladder.direction = buf:unpack("fI")

		ladder.top_forward_area_id, ladder.top_left_area_id, ladder.top_right_area_id, ladder.top_behind_area_id = buf:unpack("IIII")
		ladder.bottom_area_id = buf:unpack("I")

		self.ladders[i] = ladder
	end

	if checksum ~= nil and navigation_mesh_cache[checksum] == nil then
		navigation_mesh_cache[checksum] = self
	end

	return self
end

return {
	parse = parse
}