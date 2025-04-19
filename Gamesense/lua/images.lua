local M = {}

--
-- dependencies
--

local ffi = require "ffi"
local csgo_weapons = require "gamesense/csgo_weapons"

local string_gsub = string.gsub
local math_floor = math.floor
local cast = ffi.cast

--
-- ffi structs
-- (mostly for image parsing)
--

local png_ihdr_t = ffi.typeof([[
struct {
	char type[4];
	uint32_t width;
	uint32_t height;
	char bitDepth;
	char colorType;
	char compression;
	char filter;
	char interlace;
} *
]])

local jpg_segment_t = ffi.typeof([[
struct {
	char type[2];
	uint16_t size;
} *
]])

local jpg_segment_sof0_t = ffi.typeof([[
struct {
	uint16_t size;
	char precision;
	uint16_t height;
	uint16_t width;
} __attribute__((packed)) *
]])

local uint16_t_ptr = ffi.typeof("uint16_t*")
local charbuffer = ffi.typeof("char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")

--
-- constants
--

local INVALID_TEXTURE = -1
local PNG_MAGIC = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"

local JPG_MAGIC_1 = "\xFF\xD8\xFF\xDB"
local JPG_MAGIC_2 = "\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01"

local JPG_SEGMENT_SOI = "\xFF\xD8"
local JPG_SEGMENT_SOF0 = "\xFF\xC0"
local JPG_SEGMENT_SOS = "\xFF\xDA"
local JPG_SEGMENT_EOI = "\xFF\xD9"

local RENDERER_LOAD_FUNCS = {
	png = renderer.load_png,
	svg = renderer.load_svg,
	jpg = renderer.load_jpg,
	rgba = renderer.load_rgba
}

--
-- utility functions
--

local function bswap_16(x)
	return bit.rshift(bit.bswap(x), 16)
end

local function hexdump(str)
	local out = {}
	str:gsub(".", function(chr)
		table.insert(out, string.format("%02x", string.byte(chr)))
	end)
	return table.concat(out, " ")
end

--
-- small filesystem implementation
--

local native_ReadFile = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 0, "int(__thiscall*)(void*, void*, int, void*)")
local native_OpenFile = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 2, "void*(__thiscall*)(void*, const char*, const char*, const char*)")
local native_CloseFile = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 3, "void(__thiscall*)(void*, void*)")
local native_GetFileSize = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 7, "unsigned int(__thiscall*)(void*, void*)")

local function engine_read_file(filename)
	local handle = native_OpenFile(filename, "r", "MOD")
	if handle == nil then return end

	local filesize = native_GetFileSize(handle)
	if filesize == nil or filesize < 0 then return end

	local buffer = charbuffer(filesize + 1)
	if buffer == nil then return end

	local read_success = native_ReadFile(buffer, filesize, handle)
	if not read_success then return end

	return ffi.string(buffer, filesize)
end

--
-- ISteamFriends / ISteamUtils
--

-- That shit now use ingame context of steamapi instead of connecting to global user
-- enjoy, by w7rus

ffi.cdef([[
	typedef struct
	{
		void* steam_client;
		void* steam_user;
		void* steam_friends;
		void* steam_utils;
		void* steam_matchmaking;
		void* steam_user_stats;
		void* steam_apps;
		void* steam_matchmakingservers;
		void* steam_networking;
		void* steam_remotestorage;
		void* steam_screenshots;
		void* steam_http;
		void* steam_unidentifiedmessages;
		void* steam_controller;
		void* steam_ugc;
		void* steam_applist;
		void* steam_music;
		void* steam_musicremote;
		void* steam_htmlsurface;
		void* steam_inventory;
		void* steam_video;
	} S_steamApiCtx_t;
]])

local pS_SteamApiCtx = ffi.cast(
	"S_steamApiCtx_t**", ffi.cast(
		"char*",
		client.find_signature(
			"client_panorama.dll",
			"\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A"
		)
	) + 7
)[0] or error("invalid interface", 2)

local native_ISteamFriends = ffi.cast("void***", pS_SteamApiCtx.steam_friends)
local native_ISteamUtils = ffi.cast("void***", pS_SteamApiCtx.steam_utils)

local native_ISteamFriends_GetSmallFriendAvatar = vtable_thunk(34, "int(__thiscall*)(void*, uint64_t)")
local native_ISteamFriends_GetMediumFriendAvatar = vtable_thunk(35, "int(__thiscall*)(void*, uint64_t)")
local native_ISteamFriends_GetLargeFriendAvatar = vtable_thunk(36, "int(__thiscall*)(void*, uint64_t)")

local native_ISteamUtils_GetImageSize = vtable_thunk(5, "bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)")
local native_ISteamUtils_GetImageRGBA = vtable_thunk(6, "bool(__thiscall*)(void*, int, unsigned char*, int)")

--
-- image object implementation
--

local function image_measure(self, width, height)
	if width ~= nil and height ~= nil then
		return width, height
	else
		if self.width == nil or self.height == nil then
			error("Image dimensions not known, full size is required")
		elseif width == nil then
			height = height or self.height
			local width = math_floor(self.width * (height/self.height))
			return width, height
		elseif height == nil then
			width = width or self.width
			local height = math_floor(self.height * (width/self.width))
			return width, height
		else
			return self.width, self.height
		end
	end
end

local function image_draw(self, x, y, width, height, r, g, b, a, force_same_res_render, flags)
	width, height = image_measure(self, width, height)

	local id = string.format("%f_%f", width, height)
	local texture = self.textures[id]

	-- no texture with same width and height has been loaded
	if texture == nil then
		if ({next(self.textures)})[2] == nil or force_same_res_render or force_same_res_render == nil then
			-- try and load the texture
			local func = RENDERER_LOAD_FUNCS[self.type]
			if func then
				if self.type == "rgba" then
					width, height = self.width, self.height
				end
				texture = func(self.contents, width, height)
			end

			if texture == nil then
				self.textures[id] = INVALID_TEXTURE
				error("failed to load texture for " .. width .. "x" .. height, 2)
			else
				-- client.log("loaded svg ", self.name, " for ", width, "x", height)
				self.textures[id] = texture
			end
		else
			--right now we just choose a random texture (determined by the pairs order aka unordered)
			--todo: select the texture with the highest or closest resolution?
			texture = ({next(self.textures)})[2]
		end
	end

	if texture == nil or texture == INVALID_TEXTURE then
		return
	elseif a == nil or a > 0 then
		renderer.texture(texture, x, y, width, height, r or 255, g or 255, b or 255, a or 255, flags or "f")
	end

	return width, height
end

local image_mt = {
	__index = {
		measure = image_measure,
		draw = image_draw
	}
}

--
-- functions for loading images
--

local function load_png(contents)
	if contents:sub(1, 8) ~= PNG_MAGIC then
		error("Invalid magic", 2)
		return
	end

	local ihdr_raw = contents:sub(13, 30)
	if ihdr_raw:len() < 17 then
		error("Incomplete data", 2)
		return
	end

	local ihdr = cast(png_ihdr_t, cast("const uint8_t *", cast("const char*", ihdr_raw)))

	if ffi.string(ihdr.type, 4) ~= "IHDR" then
		error("Invalid chunk type, expected IHDR", 2)
		return
	end

	local width = bit.bswap(ihdr.width)
	local height = bit.bswap(ihdr.height)

	if width <= 0 or height <= 0 then
		error("Invalid width or height", 2)
		return
	end

	return setmetatable({
		type = "png",
		width = width,
		height = height,
		contents = contents,
		textures = {}
	}, image_mt)
end

local function load_jpg(contents)
	local buffer = ffi.cast("const uint8_t *", ffi.cast("const char *", contents))
	local len_remaining = contents:len()

	local width, height

	if contents:sub(1, 4) == JPG_MAGIC_1 or contents:sub(1, 12) == JPG_MAGIC_2 then
		local got_soi, got_sos = false, false

		-- read segments until we find a SOF0 header (containing width/height)
		while len_remaining > 0 do
			local segment = ffi.cast(jpg_segment_t, buffer)
			local typ = ffi.string(segment.type, 2)

			buffer = buffer + 2
			len_remaining = len_remaining - 2

			if typ == JPG_SEGMENT_SOI then
				got_soi = true
			elseif not got_soi then
				error("expected SOI segment", 2)
			elseif typ == JPG_SEGMENT_SOS or typ == JPG_SEGMENT_EOI then
				if typ == JPG_SEGMENT_SOS then
					got_sos = true
				end
				break
			else
				-- endian convert of the size (be -> le)
				local size = bswap_16(segment.size)

				if typ == JPG_SEGMENT_SOF0 then
					local sof0 = cast(jpg_segment_sof0_t, buffer)

					height = bswap_16(sof0.height)
					width = bswap_16(sof0.width)

					if width <= 0 or height <= 0 then
						error("Invalid width or height")
						return
					end
				end

				buffer = buffer + size
				len_remaining = len_remaining - size
			end
		end

		if not got_soi then
			error("Incomplete image, missing SOI segment", 2)
			return
		elseif not got_sos then
			error("Incomplete image, missing SOS segment", 2)
			return
		elseif width == nil then
			error("Incomplete image, missing SOF0 segment", 2)
			return
		end
	else
		error("Invalid magic", 2)
		return
	end

	return setmetatable({
		type = "jpg",
		width = width,
		height = height,
		contents = contents,
		textures = {}
	}, image_mt)
end

local function load_svg(contents)
	-- try and find <svg> tag

	local match = contents:match("<svg(.*)>.*</svg>")
	if match == nil then
		error("Invalid svg, missing <svg> tag", 2)
		return
	end

	match = match:gsub("\r\n", ""):gsub("\n", "")

	-- parse tag contents
	local in_quote = false
	local key, value = "", ""

	local attributes = {}

	local offset = 1
	while true do
		local chr = match:sub(offset, offset)

		if chr == "" then
			break
		end

		if in_quote then
			-- text inside quotation marks
			if chr == "\"" then
				in_quote = false
				attributes[key:gsub("\t", ""):lower()] = value
				key, value = "", ""
			else
				value = value .. chr
			end
		else
			-- normal text, not inside quotes
			if chr == ">" then
				break
			elseif chr == "=" then
				if match:sub(offset, offset+1) == "=\"" then
					in_quote = true
					offset = offset + 1
				end
			elseif chr == " " then
				key = ""
			else
				key = key .. chr
			end
		end

		offset = offset + 1
	end

	-- heuristics to find valid image width and height
	local width, height

	if attributes["width"] ~= nil then
		width = tonumber((attributes["width"]:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")))

		if width ~= nil and 0 >= width then
			width = nil
		end
	end

	if attributes["height"] ~= nil then
		height = tonumber((attributes["height"]:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")))

		if height ~= nil and 0 >= height then
			height = nil
		end
	end

	if width == nil or height == nil and attributes["viewbox"] ~= nil then
		local x, y, w, h = attributes["viewbox"]:match("^%s*([%d.]*) ([%d.]*) ([%d.]*) ([%d.]*)%s*$")

		width, height = tonumber(width), tonumber(height)

		if width ~= nil and height ~= nil and (0 >= width or 0 >= height) then
			width, height = nil, nil
		end
	end

	local self = setmetatable({
		type = "svg",
		contents = contents,
		textures = {}
	}, image_mt)

	if width ~= nil and height ~= nil and width > 0 and height > 0 then
		self.width, self.height = width, height
	end

	return self
end

local function load_rgba(contents, width, height)
	if width == nil or height == nil or width <= 0 or height <= 0 then
		error("Invalid size: width and height are required and have to be greater than zero.")
		return
	end

	local size = width*height*4
	if contents:len() ~= size then
		error("invalid buffer length, expected width*height*4", 2)
		return
	end

	-- load texture
	local texture = renderer.load_rgba(contents, width, height)
	if texture == nil then
		return
	end

	return setmetatable({
		type = "rgba",
		width = width,
		height = height,
		contents = contents,
		textures = {[string.format("%f_%f", width, height)] = texture}
	}, image_mt)
end

local function load_image(contents)
	if type(contents) == "table" then
		if getmetatable(contents) == image_mt then
			return error("trying to load an existing image")
		else
			local result = {}
			for key, value in pairs(contents) do
				result[key] = load_image(value)
			end
			return result
		end
	else
		-- try and determine type etc by looking for magic value
		if type(contents) == "string" then
			if contents:sub(1, 8) == PNG_MAGIC then
				return load_png(contents)
			elseif contents:sub(1, 4) == JPG_MAGIC_1 or contents:sub(1, 12) == JPG_MAGIC_2 then
				return load_jpg(contents)
			elseif contents:match("^%s*%<%?xml") ~= nil then
				return load_svg(contents)
			else
				return error("Failed to determine image type")
			end
		end
	end
end

local panorama_images = setmetatable({},  {__mode = "k"})
local function get_panorama_image(path)
	if panorama_images[path] == nil then
		local path_cleaned = string_gsub(string_gsub(string_gsub(string_gsub(string_gsub(path, "%z", ""), "%c", ""), "\\", "/"), "%.%./", ""), "^/+", "")
		local contents = engine_read_file("materials/panorama/images/" .. path_cleaned)

		if contents then
			local image = load_image(contents)

			panorama_images[path] = image
		else
			panorama_images[path] = false
		end
	end

	if panorama_images[path] then
		return panorama_images[path]
	end
end

local weapon_icons = setmetatable({}, {__mode = "k"})
local function get_weapon_icon(weapon_name)
	if weapon_icons[weapon_name] == nil then
		local weapon_name_cleaned
		local typ = type(weapon_name)

		if typ == "table" and weapon_name.console_name ~= nil then
			weapon_name_cleaned = weapon_name.console_name
		elseif typ == "number" then
			local weapon = csgo_weapons[weapon_name]
			if weapon == nil then
				weapon_icons[weapon_name] = false
				return
			end
			weapon_name_cleaned = weapon.console_name
		elseif typ == "string" then
			weapon_name_cleaned = tostring(weapon_name)
		elseif weapon_name ~= nil then
			weapon_icons[weapon_name] = nil
			return
		else
			return
		end

		weapon_name_cleaned = string_gsub(string_gsub(weapon_name_cleaned, "^weapon_", ""), "^item_", "")

		local image = get_panorama_image("icons/equipment/" .. weapon_name_cleaned .. ".svg")
		weapon_icons[weapon_name] = image or false
	end

	if weapon_icons[weapon_name] then
		return weapon_icons[weapon_name]
	end
end

local steam_avatars = {}
local function get_steam_avatar(steamid3_or_steamid64, size)
	local cache_key = string.format("%s_%d", steamid3_or_steamid64, size or 32)

	if steam_avatars[cache_key] == nil then
		local func
		if size == nil then
			func = native_ISteamFriends_GetSmallFriendAvatar
		elseif size > 64 then
			func = native_ISteamFriends_GetLargeFriendAvatar
		elseif size > 32 then
			func = native_ISteamFriends_GetMediumFriendAvatar
		else
			func = native_ISteamFriends_GetSmallFriendAvatar
		end

		local steamid
		if type(steamid3_or_steamid64) == "string" then
			steamid = 76500000000000000ULL + tonumber(steamid3_or_steamid64:sub(4, -1))
		elseif type(steamid3_or_steamid64) == "number" then
			steamid = 76561197960265728ULL + steamid3_or_steamid64
		else
			return
		end

		local handle = func(native_ISteamFriends, steamid)

		if handle > 0 then
			local width = uintbuffer(1)
			local height = uintbuffer(1)
			if native_ISteamUtils_GetImageSize(native_ISteamUtils, handle, width, height) then
				if width[0] > 0 and height[0] > 0 then
					local rgba_buffer_size = width[0]*height[0]*4
					local rgba_buffer = charbuffer(rgba_buffer_size)

					if native_ISteamUtils_GetImageRGBA(native_ISteamUtils, handle, rgba_buffer, rgba_buffer_size) then
						steam_avatars[cache_key] = load_rgba(ffi.string(rgba_buffer, rgba_buffer_size), width[0], height[0])
					end
				end
			end
		elseif handle ~= -1 then
			steam_avatars[cache_key] = false
		end
	end

	if steam_avatars[cache_key] then
		return steam_avatars[cache_key]
	end
end

return {
	load = load_image,
	load_png = load_png,
	load_jpg = load_jpg,
	load_svg = load_svg,
	load_rgba = load_rgba,
	get_weapon_icon = get_weapon_icon,
	get_panorama_image = get_panorama_image,
	get_steam_avatar = get_steam_avatar
}