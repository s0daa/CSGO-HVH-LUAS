-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}
local var_0_1 = require("ffi")
local var_0_2 = require("gamesense/steamworks")
local var_0_3 = require("gamesense/csgo_weapons")
local var_0_4 = string.gsub
local var_0_5 = math.floor
local var_0_6 = var_0_1.cast
local var_0_7 = var_0_1.typeof("struct {\n\tchar type[4];\n\tuint32_t width;\n\tuint32_t height;\n\tchar bitDepth;\n\tchar colorType;\n\tchar compression;\n\tchar filter;\n\tchar interlace;\n} *\n")
local var_0_8 = var_0_1.typeof("struct {\n\tchar type[2];\n\tuint16_t size;\n} *\n")
local var_0_9 = var_0_1.typeof("struct {\n\tuint16_t size;\n\tchar precision;\n\tuint16_t height;\n\tuint16_t width;\n} __attribute__((packed)) *\n")
local var_0_10 = var_0_1.typeof("uint16_t*")
local var_0_11 = var_0_1.typeof("char[?]")
local var_0_12 = var_0_1.typeof("unsigned int[?]")
local var_0_13 = -1
local var_0_14 = "\x89PNG\r\n\x1A\n"
local var_0_15 = "\xFF\xD8\xFF\xDB"
local var_0_16 = "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01"
local var_0_17 = "\xFF\xD8"
local var_0_18 = "\xFF\xC0"
local var_0_19 = "\xFF\xDA"
local var_0_20 = "\xFF\xD9"
local var_0_21 = {
	png = renderer.load_png,
	svg = renderer.load_svg,
	jpg = renderer.load_jpg,
	rgba = renderer.load_rgba
}

local function var_0_22(arg_1_0)
	return bit.rshift(bit.bswap(arg_1_0), 16)
end

local function var_0_23(arg_2_0)
	local var_2_0 = {}

	arg_2_0:gsub(".", function(arg_3_0)
		table.insert(var_2_0, string.format("%02x", string.byte(arg_3_0)))
	end)

	return table.concat(var_2_0, " ")
end

local var_0_24 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 0, "int(__thiscall*)(void*, void*, int, void*)")
local var_0_25 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 2, "void*(__thiscall*)(void*, const char*, const char*, const char*)")
local var_0_26 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 3, "void(__thiscall*)(void*, void*)")
local var_0_27 = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 7, "unsigned int(__thiscall*)(void*, void*)")

local function var_0_28(arg_4_0)
	local var_4_0 = var_0_25(arg_4_0, "r", "MOD")

	if var_4_0 == nil then
		return
	end

	local var_4_1 = var_0_27(var_4_0)

	if var_4_1 == nil or var_4_1 < 0 then
		return
	end

	local var_4_2 = var_0_11(var_4_1 + 1)

	if var_4_2 == nil then
		return
	end

	if not var_0_24(var_4_2, var_4_1, var_4_0) then
		return
	end

	return var_0_1.string(var_4_2, var_4_1)
end

local var_0_29 = vtable_bind("steamclient.dll", "SteamClient017", 2, "int(__thiscall*)(void*, int)")
local var_0_30 = vtable_bind("steamclient.dll", "SteamClient017", 8, "int*(__thiscall*)(void*, int, int, const char*)")
local var_0_31 = vtable_bind("steamclient.dll", "SteamClient017", 9, "int*(__thiscall*)(void*, int, const char*)")
local var_0_32
local var_0_33
local var_0_34
local var_0_35
local var_0_36 = vtable_thunk(34, "int(__thiscall*)(void*, uint64_t)")
local var_0_37 = vtable_thunk(35, "int(__thiscall*)(void*, uint64_t)")
local var_0_38 = vtable_thunk(36, "int(__thiscall*)(void*, uint64_t)")
local var_0_39 = vtable_thunk(5, "bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)")
local var_0_40 = vtable_thunk(6, "bool(__thiscall*)(void*, int, unsigned char*, int)")

local function var_0_41(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 ~= nil and arg_5_2 ~= nil then
		return arg_5_1, arg_5_2
	elseif arg_5_0.width == nil or arg_5_0.height == nil then
		error("Image dimensions not known, full size is required")
	elseif arg_5_1 == nil then
		arg_5_2 = arg_5_2 or arg_5_0.height

		return var_0_5(arg_5_0.width * (arg_5_2 / arg_5_0.height)), arg_5_2
	elseif arg_5_2 == nil then
		arg_5_1 = arg_5_1 or arg_5_0.width

		local var_5_0 = var_0_5(arg_5_0.height * (arg_5_1 / arg_5_0.width))

		return arg_5_1, var_5_0
	else
		return arg_5_0.width, arg_5_0.height
	end
end

local function var_0_42(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	arg_6_3, arg_6_4 = var_0_41(arg_6_0, arg_6_3, arg_6_4)

	local var_6_0 = string.format("%f_%f", arg_6_3, arg_6_4)
	local var_6_1 = arg_6_0.textures[var_6_0]

	if var_6_1 == nil then
		if ({
			next(arg_6_0.textures)
		})[2] == nil or arg_6_9 or arg_6_9 == nil then
			local var_6_2 = var_0_21[arg_6_0.type]

			if var_6_2 then
				if arg_6_0.type == "rgba" then
					arg_6_3, arg_6_4 = arg_6_0.width, arg_6_0.height
				end

				var_6_1 = var_6_2(arg_6_0.contents, arg_6_3, arg_6_4)
			end

			if var_6_1 == nil then
				arg_6_0.textures[var_6_0] = var_0_13

				error("failed to load texture for " .. arg_6_3 .. "x" .. arg_6_4, 2)
			else
				arg_6_0.textures[var_6_0] = var_6_1
			end
		else
			var_6_1 = ({
				next(arg_6_0.textures)
			})[2]
		end
	end

	if var_6_1 == nil or var_6_1 == var_0_13 then
		return
	elseif arg_6_8 == nil or arg_6_8 > 0 then
		renderer.texture(var_6_1, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5 or 255, arg_6_6 or 255, arg_6_7 or 255, arg_6_8 or 255, arg_6_10 or "f")
	end

	return arg_6_3, arg_6_4
end

local var_0_43 = {
	__index = {
		measure = var_0_41,
		draw = var_0_42
	}
}

local function var_0_44(arg_7_0)
	if arg_7_0:sub(1, 8) ~= var_0_14 then
		error("Invalid magic", 2)

		return
	end

	local var_7_0 = arg_7_0:sub(13, 30)

	if var_7_0:len() < 17 then
		error("Incomplete data", 2)

		return
	end

	local var_7_1 = var_0_6(var_0_7, var_0_6("const uint8_t *", var_0_6("const char*", var_7_0)))

	if var_0_1.string(var_7_1.type, 4) ~= "IHDR" then
		error("Invalid chunk type, expected IHDR", 2)

		return
	end

	local var_7_2 = bit.bswap(var_7_1.width)
	local var_7_3 = bit.bswap(var_7_1.height)

	if var_7_2 <= 0 or var_7_3 <= 0 then
		error("Invalid width or height", 2)

		return
	end

	return setmetatable({
		type = "png",
		width = var_7_2,
		height = var_7_3,
		contents = arg_7_0,
		textures = {}
	}, var_0_43)
end

local function var_0_45(arg_8_0)
	local var_8_0 = var_0_1.cast("const uint8_t *", var_0_1.cast("const char *", arg_8_0))
	local var_8_1 = arg_8_0:len()
	local var_8_2
	local var_8_3

	if arg_8_0:sub(1, 4) == var_0_15 or arg_8_0:sub(1, 12) == var_0_16 then
		local var_8_4 = false
		local var_8_5 = false

		while var_8_1 > 0 do
			local var_8_6 = var_0_1.cast(var_0_8, var_8_0)
			local var_8_7 = var_0_1.string(var_8_6.type, 2)

			var_8_0 = var_8_0 + 2
			var_8_1 = var_8_1 - 2

			if var_8_7 == var_0_17 then
				var_8_4 = true
			elseif not var_8_4 then
				error("expected SOI segment", 2)
			elseif var_8_7 == var_0_19 or var_8_7 == var_0_20 then
				if var_8_7 == var_0_19 then
					var_8_5 = true
				end

				break
			else
				local var_8_8 = var_0_22(var_8_6.size)

				if var_8_7 == var_0_18 then
					local var_8_9 = var_0_6(var_0_9, var_8_0)

					var_8_3 = var_0_22(var_8_9.height)
					var_8_2 = var_0_22(var_8_9.width)

					if var_8_2 <= 0 or var_8_3 <= 0 then
						error("Invalid width or height")

						return
					end
				end

				var_8_0 = var_8_0 + var_8_8
				var_8_1 = var_8_1 - var_8_8
			end
		end

		if not var_8_4 then
			error("Incomplete image, missing SOI segment", 2)

			return
		elseif not var_8_5 then
			error("Incomplete image, missing SOS segment", 2)

			return
		elseif var_8_2 == nil then
			error("Incomplete image, missing SOF0 segment", 2)

			return
		end
	else
		error("Invalid magic", 2)

		return
	end

	return setmetatable({
		type = "jpg",
		width = var_8_2,
		height = var_8_3,
		contents = arg_8_0,
		textures = {}
	}, var_0_43)
end

local function var_0_46(arg_9_0)
	local var_9_0 = arg_9_0:match("<svg(.*)>.*</svg>")

	if var_9_0 == nil then
		error("Invalid svg, missing <svg> tag", 2)

		return
	end

	local var_9_1 = var_9_0:gsub("\r\n", ""):gsub("\n", "")
	local var_9_2 = false
	local var_9_3 = ""
	local var_9_4 = ""
	local var_9_5 = {}
	local var_9_6 = 1

	while true do
		local var_9_7 = var_9_1:sub(var_9_6, var_9_6)

		if var_9_7 == "" then
			break
		end

		if var_9_2 then
			if var_9_7 == "\"" then
				var_9_2 = false
				var_9_5[var_9_3:gsub("\t", ""):lower()] = var_9_4
				var_9_3, var_9_4 = "", ""
			else
				var_9_4 = var_9_4 .. var_9_7
			end
		elseif var_9_7 == ">" then
			break
		elseif var_9_7 == "=" then
			if var_9_1:sub(var_9_6, var_9_6 + 1) == "=\"" then
				var_9_2 = true
				var_9_6 = var_9_6 + 1
			end
		else
			var_9_3 = var_9_7 == " " and "" or var_9_3 .. var_9_7
		end

		var_9_6 = var_9_6 + 1
	end

	local var_9_8
	local var_9_9

	if var_9_5.width ~= nil then
		var_9_8 = tonumber((var_9_5.width:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")))

		if var_9_8 ~= nil and var_9_8 <= 0 then
			var_9_8 = nil
		end
	end

	if var_9_5.height ~= nil then
		var_9_9 = tonumber((var_9_5.height:gsub("px$", ""):gsub("pt$", ""):gsub("mm$", "")))

		if var_9_9 ~= nil and var_9_9 <= 0 then
			var_9_9 = nil
		end
	end

	if var_9_8 == nil or var_9_9 == nil and var_9_5.viewbox ~= nil then
		local var_9_10, var_9_11, var_9_12, var_9_13 = var_9_5.viewbox:match("^%s*([%d.]*) ([%d.]*) ([%d.]*) ([%d.]*)%s*$")

		var_9_8, var_9_9 = tonumber(var_9_8), tonumber(var_9_9)

		if var_9_8 ~= nil and var_9_9 ~= nil and (var_9_8 <= 0 or var_9_9 <= 0) then
			var_9_8, var_9_9 = nil
		end
	end

	local var_9_14 = setmetatable({
		type = "svg",
		contents = arg_9_0,
		textures = {}
	}, var_0_43)

	if var_9_8 ~= nil and var_9_9 ~= nil and var_9_8 > 0 and var_9_9 > 0 then
		var_9_14.width, var_9_14.height = var_9_8, var_9_9
	end

	return var_9_14
end

local function var_0_47(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 == nil or arg_10_2 == nil or arg_10_1 <= 0 or arg_10_2 <= 0 then
		error("Invalid size: width and height are required and have to be greater than zero.")

		return
	end

	local var_10_0 = arg_10_1 * arg_10_2 * 4

	if arg_10_0:len() ~= var_10_0 then
		error("invalid buffer length, expected width*height*4", 2)

		return
	end

	local var_10_1 = renderer.load_rgba(arg_10_0, arg_10_1, arg_10_2)

	if var_10_1 == nil then
		return
	end

	return setmetatable({
		type = "rgba",
		width = arg_10_1,
		height = arg_10_2,
		contents = arg_10_0,
		textures = {
			[string.format("%f_%f", arg_10_1, arg_10_2)] = var_10_1
		}
	}, var_0_43)
end

local function var_0_48(arg_11_0)
	if type(arg_11_0) == "table" then
		if getmetatable(arg_11_0) == var_0_43 then
			return error("trying to load an existing image")
		else
			local var_11_0 = {}

			for iter_11_0, iter_11_1 in pairs(arg_11_0) do
				var_11_0[iter_11_0] = var_0_48(iter_11_1)
			end

			return var_11_0
		end
	elseif type(arg_11_0) == "string" then
		if arg_11_0:sub(1, 8) == var_0_14 then
			return var_0_44(arg_11_0)
		elseif arg_11_0:sub(1, 4) == var_0_15 or arg_11_0:sub(1, 12) == var_0_16 then
			return var_0_45(arg_11_0)
		elseif arg_11_0:match("^%s*%<%?xml") ~= nil then
			return var_0_46(arg_11_0)
		else
			return error("Failed to determine image type")
		end
	end
end

local var_0_49 = setmetatable({}, {
	__mode = "k"
})

local function var_0_50(arg_12_0)
	if var_0_49[arg_12_0] == nil then
		local var_12_0 = var_0_4(var_0_4(var_0_4(var_0_4(var_0_4(arg_12_0, "%z", ""), "%c", ""), "\\", "/"), "%.%./", ""), "^/+", "")
		local var_12_1 = var_0_28("materials/panorama/images/" .. var_12_0)

		if var_12_1 then
			local var_12_2 = var_0_48(var_12_1)

			var_0_49[arg_12_0] = var_12_2
		else
			var_0_49[arg_12_0] = false
		end
	end

	if var_0_49[arg_12_0] then
		return var_0_49[arg_12_0]
	end
end

local var_0_51 = setmetatable({}, {
	__mode = "k"
})

local function var_0_52(arg_13_0)
	if var_0_51[arg_13_0] == nil then
		local var_13_0
		local var_13_1 = type(arg_13_0)

		if var_13_1 == "table" and arg_13_0.console_name ~= nil then
			var_13_0 = arg_13_0.console_name
		elseif var_13_1 == "number" then
			local var_13_2 = var_0_3[arg_13_0]

			if var_13_2 == nil then
				var_0_51[arg_13_0] = false

				return
			end

			var_13_0 = var_13_2.console_name
		elseif var_13_1 == "string" then
			var_13_0 = tostring(arg_13_0)
		elseif arg_13_0 ~= nil then
			var_0_51[arg_13_0] = nil

			return
		else
			return
		end

		local var_13_3 = var_0_4(var_0_4(var_13_0, "^weapon_", ""), "^item_", "")
		local var_13_4 = var_0_50("icons/equipment/" .. var_13_3 .. ".svg")

		var_0_51[arg_13_0] = var_13_4 or false
	end

	if var_0_51[arg_13_0] then
		return var_0_51[arg_13_0]
	end
end

local var_0_53 = {}

local function var_0_54(arg_14_0, arg_14_1)
	local var_14_0 = string.format("%s_%d", arg_14_0, arg_14_1 or 32)

	if var_0_32 == nil then
		var_0_32 = 1
		var_0_33 = var_0_29(var_0_32)
		var_0_34 = var_0_30(var_0_33, var_0_32, "SteamFriends015")
		var_0_35 = var_0_31(var_0_32, "SteamUtils009")
	end

	if var_0_53[var_14_0] == nil then
		local var_14_1

		if arg_14_1 == nil then
			var_14_1 = var_0_36
		elseif arg_14_1 > 64 then
			var_14_1 = var_0_38
		elseif arg_14_1 > 32 then
			var_14_1 = var_0_37
		else
			var_14_1 = var_0_36
		end

		local var_14_2

		if type(arg_14_0) == "string" then
			var_14_2 = 76500000000000000ULL + tonumber(arg_14_0:sub(4, -1))
		elseif type(arg_14_0) == "number" then
			var_14_2 = 76561197960265728ULL + arg_14_0
		else
			return
		end

		local var_14_3 = var_14_1(var_0_34, var_14_2)

		if var_14_3 > 0 then
			local var_14_4 = var_0_12(1)
			local var_14_5 = var_0_12(1)

			if var_0_39(var_0_35, var_14_3, var_14_4, var_14_5) and var_14_4[0] > 0 and var_14_5[0] > 0 then
				local var_14_6 = var_14_4[0] * var_14_5[0] * 4
				local var_14_7 = var_0_11(var_14_6)

				if var_0_40(var_0_35, var_14_3, var_14_7, var_14_6) then
					var_0_53[var_14_0] = var_0_47(var_0_1.string(var_14_7, var_14_6), var_14_4[0], var_14_5[0])
				end
			end
		elseif var_14_3 ~= -1 then
			var_0_53[var_14_0] = false
		end
	end

	if var_0_53[var_14_0] then
		return var_0_53[var_14_0]
	end
end

return {
	load = var_0_48,
	load_png = var_0_44,
	load_jpg = var_0_45,
	load_svg = var_0_46,
	load_rgba = var_0_47,
	get_weapon_icon = var_0_52,
	get_panorama_image = var_0_50,
	get_steam_avatar = var_0_54
}
