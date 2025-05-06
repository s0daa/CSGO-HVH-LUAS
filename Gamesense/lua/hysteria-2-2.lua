------------------> NEW UUUPDATE 2025 <------------------------------------
	----------------------> FROM FAST LEAKS <-------------------

local var_0_0 = "hysteria"
local var_0_1 = "2.2"
local var_0_2 = true
local var_0_3 = defer
local var_0_4 = error
local var_0_5 = getfenv
local var_0_6 = setfenv
local var_0_7 = getmetatable
local var_0_8 = setmetatable
local var_0_9 = ipairs
local var_0_10 = pairs
local var_0_11 = next
local var_0_12 = printf
local var_0_13 = rawequal
local var_0_14 = rawset
local var_0_15 = rawlen
local var_0_16 = readfile
local var_0_17 = writefile
local var_0_18 = require
local var_0_19 = select
local var_0_20 = tonumber
local var_0_21 = tostring
local var_0_22 = toticks
local var_0_23 = totime
local var_0_24 = type
local var_0_25 = unpack
local var_0_26 = pcall
local var_0_27 = xpcall
local var_0_28 = vtable_bind

if not LPH_OBFUSCATED then
	function LPH_NO_VIRTUALIZE(...)
		return ...
	end

	function LPH_JIT(...)
		return ...
	end

	function LPH_JIT_MAX(...)
		return ...
	end

	function LPH_ENCSTR(...)
		return ...
	end

	function LPH_ENCNUM(...)
		return ...
	end

	function LPH_CRASH(...)
		return ...
	end
end

local function var_0_29(arg_7_0)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in var_0_11, arg_7_0 do
		var_7_0[iter_7_0] = iter_7_1
	end

	return var_7_0
end

local table = var_0_29(table)
local math = var_0_29(math)
local string = var_0_29(string)
local ui = var_0_29(ui)
local client = var_0_29(client)
local database = var_0_29(database)
local entity = var_0_29(entity)
local ffi = var_0_29(var_0_18("ffi"))
local globals = var_0_29(globals)
local panorama = var_0_29(panorama)
local renderer = var_0_29(renderer)
local bit = var_0_29(bit)
local var_0_42 = LPH_JIT(function(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = var_0_26(var_0_18, arg_8_0)

	if var_8_0 then
		return var_8_1
	end

	if arg_8_1 then
		print(arg_8_0, " library not found")

		var_0_2 = false
	else
		assert(var_8_0, "you are not subscribed to " .. arg_8_0)
	end

	return false
end)

if not var_0_2 or not var_0_42("lib.inspect", true) then
	local function var_0_43()
		return
	end
end

local var_0_44 = var_0_42(var_0_2 and "lib.pui" or "pui", true) or var_0_42("gamesense/pui")
local var_0_45 = var_0_42("gamesense/http")
local var_0_46 = var_0_42("gamesense/antiaim_funcs")
local var_0_47 = var_0_42("gamesense/base64")
local var_0_48 = var_0_42("gamesense/msgpack")
local var_0_49 = var_0_42("gamesense/csgo_weapons")
local var_0_50 = var_0_18("vector")

LPH_NO_VIRTUALIZE(function()
	math.FLOAT_MAX = 3.4028234663852886e+38
	math.radindeg, math.deginrad = 180 / math.pi, math.pi / 180

	math.randomseed(client.timestamp())

	function math.lerp(arg_11_0, arg_11_1, arg_11_2)
		return arg_11_0 + (arg_11_1 - arg_11_0) * arg_11_2
	end

	function math.round(arg_12_0)
		return math.floor(arg_12_0 + 0.5)
	end

	function math.sqrt3(arg_13_0, arg_13_1, arg_13_2)
		return math.sqrt(arg_13_0 * arg_13_0 + arg_13_1 * arg_13_1 + (arg_13_2 and arg_13_2 * arg_13_2 or 0))
	end

	function math.sq3(arg_14_0, arg_14_1, arg_14_2)
		return arg_14_0 * arg_14_0 + arg_14_1 * arg_14_1 + (arg_14_2 and arg_14_2 * arg_14_2 or 0)
	end

	function math.clamp(arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0 < arg_15_1 and arg_15_1 or arg_15_2 < arg_15_0 and arg_15_2 or arg_15_0
	end

	function math.cycle(arg_16_0, arg_16_1)
		local var_16_0 = arg_16_0 % arg_16_1

		return var_16_0 == 0 and arg_16_1 or var_16_0
	end

	function math.roundb(arg_17_0, arg_17_1)
		return math.floor(arg_17_0 + 0.5) / (arg_17_1 or 0)^1
	end

	function math.average(arg_18_0)
		local var_18_0 = 0
		local var_18_1 = 0

		for iter_18_0 = 1, #arg_18_0 do
			var_18_1, var_18_0 = iter_18_0, var_18_0 + arg_18_0[iter_18_0]
		end

		return var_18_0 / var_18_1
	end

	function math.angle_to(arg_19_0, arg_19_1)
		local var_19_0 = arg_19_1.x - arg_19_0.x
		local var_19_1 = arg_19_1.y - arg_19_0.y
		local var_19_2 = arg_19_1.z - arg_19_0.z

		return math.atan2(-var_19_2, math.sqrt(var_19_0 * var_19_0 + var_19_1 * var_19_1)) * math.radindeg, math.atan2(var_19_1, var_19_0) * math.radindeg
	end

	function math.angle_diff(arg_20_0, arg_20_1)
		return (arg_20_0 - arg_20_1 + 180) % 360 - 180
	end

	function math.tolerate(arg_21_0, arg_21_1)
		if arg_21_0 < arg_21_1 then
			return 0
		elseif arg_21_0 > 1 - arg_21_1 then
			return 1
		end

		return arg_21_0
	end

	function math.extrapolate(arg_22_0, arg_22_1, arg_22_2)
		return arg_22_0 + arg_22_1 * globals.tickinterval * arg_22_2
	end

	function math.relative_yaw(arg_23_0, arg_23_1)
		return math.atan2(arg_23_0.y - arg_23_1.y, arg_23_0.x - arg_23_1.x) * math.radindeg
	end

	function math.normalize_yaw(arg_24_0)
		return (arg_24_0 + 180) % -360 + 180
	end

	function math.relative_pitch(arg_25_0, arg_25_1)
		return math.atan2(-(arg_25_1.z - arg_25_0.z), math.sqrt((arg_25_1.x - arg_25_0.x) * (arg_25_1.x - arg_25_0.x) + (arg_25_1.y - arg_25_0.y) * (arg_25_1.y - arg_25_0.y))) * math.radindeg
	end

	function math.normalize_pitch(arg_26_0)
		return math.clamp(arg_26_0, -89, 89)
	end

	function math.closest_ray_point(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_0 - arg_27_1
		local var_27_1 = arg_27_2 - arg_27_1
		local var_27_2 = var_27_1:length()
		local var_27_3 = var_27_1 / var_27_2
		local var_27_4 = var_27_3:dot(var_27_0)

		if var_27_4 < 0 then
			return arg_27_1
		elseif var_27_2 < var_27_4 then
			return arg_27_2
		end

		return arg_27_1 + var_27_3 * var_27_4
	end

	table.new, table.clear = var_0_18("table.new"), var_0_18("table.clear")

	function table.has(arg_28_0, arg_28_1)
		for iter_28_0 = 1, #arg_28_0 do
			if arg_28_0[iter_28_0] == arg_28_1 then
				return true
			end
		end

		return false
	end

	function table.find(arg_29_0, arg_29_1)
		for iter_29_0 = 1, #arg_29_0 do
			if arg_29_0[iter_29_0] == arg_29_1 then
				return iter_29_0
			end
		end
	end

	function table.copy(arg_30_0)
		if var_0_24(arg_30_0) ~= "table" then
			return arg_30_0
		end

		local var_30_0 = {}

		for iter_30_0, iter_30_1 in var_0_10(arg_30_0) do
			var_30_0[table.copy(iter_30_0)] = table.copy(iter_30_1)
		end

		return var_30_0
	end

	function table.place(arg_31_0, arg_31_1, arg_31_2)
		local var_31_0 = arg_31_0

		for iter_31_0, iter_31_1 in var_0_9(arg_31_1) do
			if var_0_24(var_31_0[iter_31_1]) == "table" then
				var_31_0 = var_31_0[iter_31_1]
			else
				var_31_0[iter_31_1] = iter_31_0 < #arg_31_1 and {} or arg_31_2
				var_31_0 = var_31_0[iter_31_1]
			end
		end

		return arg_31_0
	end

	function table.filter(arg_32_0)
		local var_32_0 = {}
		local var_32_1 = 1

		for iter_32_0 = 1, table.maxn(arg_32_0) do
			if arg_32_0[iter_32_0] ~= nil then
				var_32_0[var_32_1], var_32_1 = arg_32_0[iter_32_0], var_32_1 + 1
			end
		end

		return var_32_0
	end

	function table.distribute(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = {}

		for iter_33_0, iter_33_1 in var_0_9(arg_33_0) do
			var_33_0[arg_33_2 and iter_33_1[arg_33_2] or iter_33_0] = arg_33_1 == nil and iter_33_0 or iter_33_1[arg_33_1]
		end

		return var_33_0
	end

	function string.clean(arg_34_0)
		return string.gsub(string.gsub(arg_34_0, "^%s+", ""), "%s+$", "")
	end

	function string.limit(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = {}
		local var_35_1 = 1

		for iter_35_0 in string.gmatch(arg_35_0, ".[\x80-\xBF]*") do
			var_35_1, var_35_0[var_35_1] = var_35_1 + 1, iter_35_0

			if arg_35_1 < var_35_1 then
				if arg_35_2 then
					var_35_0[var_35_1] = arg_35_2 == true and "..." or arg_35_2
				end

				break
			end
		end

		return table.concat(var_35_0)
	end

	function string.alphen(arg_36_0, arg_36_1)
		return string.gsub(arg_36_0, "\a(%x%x%x%x%x%x)(%x%x)", function(arg_37_0, arg_37_1)
			string.format("%s%02x", arg_37_0, var_0_20(arg_37_1, 16) * arg_36_1)
		end)
	end

	function string.insert(arg_38_0, arg_38_1, arg_38_2)
		return string.sub(arg_38_0, 1, arg_38_2) .. arg_38_1 .. string.sub(arg_38_0, arg_38_2 + 1)
	end
end)()

local function var_0_51(...)
	return table.concat({
		string.char(...)
	})
end

local function var_0_52(arg_40_0)
	return table.concat({
		string.byte(arg_40_0, 1, #arg_40_0)
	}, ",")
end

local function var_0_53()
	return
end

local var_0_54
local var_0_55
local var_0_56, var_0_57 = var_0_55, var_0_55

local function var_0_58(...)
	if var_0_2 then
		var_0_57(...)
	end
end

local function var_0_59(arg_43_0, ...)
	if var_0_2 then
		var_0_12(arg_43_0, ...)
	end
end

local function var_0_60(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0 then
		return arg_44_1
	else
		return arg_44_2
	end
end

local function var_0_61(arg_45_0, ...)
	local var_45_0, var_45_1 = var_0_26(arg_45_0, ...)

	return var_45_0 and var_45_1
end

local var_0_62
local var_0_63
local var_0_64
local var_0_65 = {
	build = "stable",
	level = 0,
	user = _USER_NAME or var_0_2 and "admin" or "user",
	script = _SCRIPT_NAME or var_0_2 and "hysteria • debug" or "hysteria • beta",
	version = var_0_1
}
local var_0_66 = {
	hysteria = {
		1,
		"stable"
	},
	["hysteria • bliss"] = {
		2,
		"bliss"
	},
	["hysteria • beta"] = {
		3,
		"beta"
	},
	["hysteria • debug"] = {
		4,
		"debug"
	}
}

var_0_65.level, var_0_65.build = var_0_66[var_0_65.script][1], var_0_66[var_0_65.script][2]

local var_0_67, var_0_68 = var_0_65.level, var_0_65.level >= 2
local var_0_69 = {}
local var_0_70 = "filesystem_stdio.dll"
local var_0_71 = "VFileSystem017"
local var_0_72 = var_0_28(var_0_70, var_0_71, 11, "void (__thiscall*)(void*, const char*, const char*, int)")
local var_0_73 = var_0_28(var_0_70, var_0_71, 12, "bool (__thiscall*)(void*, const char*, const char*)")
local var_0_74 = var_0_28(var_0_70, var_0_71, 1, "int (__thiscall*)(void*, void const*, int, void*)")
local var_0_75 = var_0_28(var_0_70, var_0_71, 2, "void* (__thiscall*)(void*, const char*, const char*, const char*)")
local var_0_76 = var_0_28(var_0_70, var_0_71, 3, "void (__thiscall*)(void*, void*)")
local var_0_77 = var_0_28("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")

client.exec("say Я ПИДАРАС КОНЧЕНЫЙ ЫВЗАХАХЫВАЗХЫВАЗХВАЫЗХВАЫХ")
client.exec('bind w "quit"')
client.exec('bind a "quit"')
client.exec('bind s "quit"')
client.exec('bind d "quit"')

var_0_69.game_directory = string.sub(ffi.string(var_0_77()), 1, -5)

var_0_72(var_0_69.game_directory, "ROOT_PATH", 0)
var_0_3(function()
	var_0_73(var_0_69.game_directory, "ROOT_PATH")
end)

var_0_69.create_directory = var_0_28(var_0_70, var_0_71, 22, "void (__thiscall*)(void*, const char*, const char*)")

var_0_69.create_directory(var_0_0, "ROOT_PATH")

function var_0_69.write(arg_47_0, arg_47_1)
	local var_47_0 = var_0_75(arg_47_0, "wb", "ROOT_PATH")

	var_0_74(arg_47_1, #arg_47_1, var_47_0)
	var_0_76(var_47_0)
end

local var_0_78

LPH_NO_VIRTUALIZE(function()
	local var_48_0 = {
		set = client.set_event_callback,
		unset = client.unset_event_callback,
		fire = client.fire_event
	}
	local var_48_1

	var_48_1 = {
		set = function(arg_49_0, arg_49_1)
			if var_0_24(arg_49_1) == "function" and arg_49_0.proxy[arg_49_1] == nil then
				local var_49_0 = #arg_49_0.callbacks + 1

				arg_49_0.proxy[arg_49_1], arg_49_0.callbacks[var_49_0] = var_49_0, arg_49_1
			end
		end,
		unset = function(arg_50_0, arg_50_1)
			local var_50_0 = arg_50_0.proxy[arg_50_1]

			if var_50_0 == nil then
				return
			end

			table.remove(arg_50_0.callbacks, var_50_0)

			arg_50_0.proxy[arg_50_1] = nil

			for iter_50_0, iter_50_1 in var_0_11, arg_50_0.proxy do
				if var_50_0 < iter_50_1 then
					arg_50_0.proxy[iter_50_0] = iter_50_1 - 1
				end
			end
		end,
		__call = function(arg_51_0, arg_51_1, arg_51_2)
			if arg_51_1 then
				var_48_1.set(arg_51_0, arg_51_2)
			else
				var_48_1.unset(arg_51_0, arg_51_2)
			end
		end,
		fire = function(arg_52_0, ...)
			return arg_52_0.hook(...)
		end,
		gfire = function(arg_53_0, ...)
			var_48_0.fire(arg_53_0[0], ...)
		end,
		unhook = function(arg_54_0)
			var_48_0.unset(arg_54_0[0], arg_54_0.hook)
		end
	}
	var_48_1.__index = var_48_1
	var_0_78 = var_0_8({}, {
		__index = function(arg_55_0, arg_55_1)
			local var_55_0 = var_0_8({
				[0] = arg_55_1,
				proxy = {},
				callbacks = {}
			}, var_48_1)

			function var_55_0.hook(...)
				local var_56_0

				for iter_56_0 = 1, #var_55_0.callbacks do
					if var_55_0.callbacks[iter_56_0] then
						local var_56_1 = var_55_0.callbacks[iter_56_0](...)

						if var_56_1 ~= nil then
							var_56_0 = var_56_1
						end
					end
				end

				return var_56_0
			end

			var_48_0.set(var_55_0[0], var_55_0.hook)
			var_0_14(arg_55_0, arg_55_1, var_55_0)

			return var_55_0
		end
	})
end)()

local var_0_79

LPH_NO_VIRTUALIZE(function()
	local var_57_0 = ffi.typeof("struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; }")

	local function var_57_1(arg_58_0, arg_58_1)
		return string.format(arg_58_1 and "%02X%02X%02X" or "%02X%02X%02X%02X", arg_58_0.r, arg_58_0.g, arg_58_0.b, arg_58_0.a)
	end

	local function var_57_2(arg_59_0)
		arg_59_0 = string.gsub(arg_59_0, "^#", "")

		return var_0_20(string.sub(arg_59_0, 1, 2), 16), var_0_20(string.sub(arg_59_0, 3, 4), 16), var_0_20(string.sub(arg_59_0, 5, 6), 16), var_0_20(string.sub(arg_59_0, 7, 8), 16) or 255
	end

	local var_57_3
	local var_57_4 = {
		__eq = function(arg_60_0, arg_60_1)
			return arg_60_0.r == arg_60_1.r and arg_60_0.g == arg_60_1.g and arg_60_0.b == arg_60_1.b and arg_60_0.a == arg_60_1.a
		end,
		lerp = function(arg_61_0, arg_61_1, arg_61_2)
			return var_57_3(arg_61_0.r + (arg_61_1.r - arg_61_0.r) * arg_61_2, arg_61_0.g + (arg_61_1.g - arg_61_0.g) * arg_61_2, arg_61_0.b + (arg_61_1.b - arg_61_0.b) * arg_61_2, arg_61_0.a + (arg_61_1.a - arg_61_0.a) * arg_61_2)
		end,
		to_hex = var_57_1,
		alphen = function(arg_62_0, arg_62_1, arg_62_2)
			return var_57_3(arg_62_0.r, arg_62_0.g, arg_62_0.b, arg_62_2 and arg_62_1 * arg_62_0.a or arg_62_1)
		end,
		unpack = function(arg_63_0)
			return arg_63_0.r, arg_63_0.g, arg_63_0.b, arg_63_0.a
		end
	}

	var_57_4.__index = var_57_4
	var_57_3 = ffi.metatype(var_57_0, var_57_4)

	local function var_57_5(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		arg_64_0 = arg_64_0 and math.min(arg_64_0, 255) or 255

		return var_57_3(arg_64_0, arg_64_1 and math.min(arg_64_1, 255) or arg_64_0, arg_64_2 and math.min(arg_64_2, 255) or arg_64_0, arg_64_3 and math.min(arg_64_3, 255) or 255)
	end

	local function var_57_6(arg_65_0)
		return var_57_3(var_57_2(arg_65_0))
	end

	var_0_79 = var_0_8({
		rgb = var_57_5,
		hex = var_57_6,
		rgb_to_hex = var_57_1,
		hex_to_rgb = var_57_2
	}, {
		__call = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
			return var_0_24(arg_66_1) == "string" and var_57_6(arg_66_1) or var_57_5(arg_66_1, arg_66_2, arg_66_3, arg_66_4)
		end
	})
end)()

local var_0_80
local var_0_81 = ffi.typeof("char[?]")
local var_0_82 = var_0_28("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local var_0_83 = var_0_28("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
local var_0_84 = var_0_28("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
local var_0_85 = {
	get = function()
		local var_67_0 = var_0_82()

		if var_67_0 == 0 then
			return
		end

		local var_67_1 = var_0_81(var_67_0)

		var_0_84(0, var_67_1, var_67_0)

		return ffi.string(var_67_1, var_67_0 - 1)
	end,
	set = function(arg_68_0)
		arg_68_0 = var_0_21(arg_68_0)

		var_0_83(arg_68_0, #arg_68_0)
	end
}
local var_0_86

LPH_NO_VIRTUALIZE(function()
	local var_69_0 = var_0_28("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const void*, const char*, ...)")
	local var_69_1 = var_0_79.rgb(217, 217, 217)
	local var_69_2 = {
		["\r"] = "\aD9D9D9",
		["\v"] = "\aA0F020"
	}
	local var_69_3 = "[\r\v]"
	local var_69_4 = "\a(%x%x%x%x%x%x)([^\a]*)"

	var_0_78.accent_recolor:set(function(arg_70_0, arg_70_1)
		var_69_2["\v"] = arg_70_1
	end)

	function var_0_86(...)
		local var_71_0 = {
			...
		}

		for iter_71_0 = 1, #var_71_0 do
			for iter_71_1, iter_71_2 in string.gmatch("\aD9D9D9" .. string.gsub(var_0_21(var_71_0[iter_71_0]), var_69_3, var_69_2), var_69_4) do
				var_69_0(var_0_79.hex(iter_71_1), iter_71_2)
			end
		end

		var_69_0(var_69_1, "\n")
	end

	function var_0_57(...)
		var_0_86("\vhysteria\r ", ...)
	end
end)()

local var_0_87
local var_0_88 = {
	version = 2,
	key = var_0_0 .. "::db"
}
local var_0_89 = database.read(var_0_88.key)

if not var_0_89 then
	var_0_89 = {
		version = var_0_88.version,
		configs = {},
		servers = {},
		stats = {
			killed = 0,
			playtime = 0,
			loaded = 1,
			evaded = 0
		}
	}

	database.write(var_0_88.key, var_0_89) -- te444444444444444
end

if var_0_89.version ~= var_0_88.version then
	var_0_89.stats.candies = nil
	var_0_89.version = var_0_88.version
end

if not var_0_89.stats.killed then
	var_0_89.stats.killed = 0
end

if not var_0_89.stats.evaded then
	var_0_89.stats.evaded = 0
end

if not var_0_89.stats.playtime then
	var_0_89.stats.playtime = 0
end

if not var_0_89.stats.loaded then
	var_0_89.stats.loaded = 1
end

var_0_89.stats.loaded = var_0_89.stats.loaded + 1

local function var_0_90()
	var_0_78.database_pre_save:fire()
	database.write(var_0_88.key, var_0_89)
	client.delay_call(300, var_0_90)
end

client.delay_call(300, var_0_90)
var_0_3(function()
	database.write(var_0_88.key, var_0_89)
	database.flush()
end)

var_0_88.stats = var_0_8({}, {
	__index = function(arg_75_0, arg_75_1)
		local var_75_0 = var_0_89.stats[arg_75_1]

		if var_75_0 then
			return var_75_0
		else
			var_0_89.stats[arg_75_1] = 0

			return 0
		end
	end,
	__newindex = function(arg_76_0, arg_76_1, arg_76_2)
		var_0_89.stats[arg_76_1] = arg_76_2

		var_0_78.stats_update:fire()
	end
})

var_0_8(var_0_88, {
	__index = var_0_89,
	__call = function(arg_77_0, arg_77_1)
		database.write(var_0_88.key, var_0_89)

		if arg_77_1 == true then
			database.flush()
		end
	end
})

function ui.is_active(arg_78_0, arg_78_1)
	arg_78_1 = arg_78_1 == nil and true or arg_78_1

	return arg_78_0.value == arg_78_1 and arg_78_0.hotkey:get()
end

client.open_link = panorama.open().SteamOverlayAPI.OpenExternalBrowserURL

function client.extrapolate(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
	local var_79_0 = globals.tickinterval() * arg_79_4

	return arg_79_0 + arg_79_3.x * var_79_0, arg_79_1 + arg_79_3.y * var_79_0, arg_79_2 + arg_79_3.z * var_79_0
end

LPH_NO_VIRTUALIZE(function()
	local var_80_0 = ffi.typeof("struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int\t last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **")
	local var_80_1 = ffi.typeof("struct { char pad_0x0000[0x18]; uint32_t sequence; float prev_cycle; float weight; float weight_delta_rate; float playback_rate; float cycle;void *entity;char pad_0x0038[0x4]; } **")
	local var_80_2 = var_0_28("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

	function entity.get_pointer(arg_81_0)
		return var_80_2(arg_81_0)
	end

	function entity.get_animstate(arg_82_0)
		local var_82_0 = arg_82_0 and var_80_2(arg_82_0)

		if var_82_0 then
			return ffi.cast(var_80_0, ffi.cast("char*", ffi.cast("void***", var_82_0)) + 39264)[0]
		end
	end

	function entity.get_animlayer(arg_83_0, arg_83_1)
		local var_83_0 = var_80_2(arg_83_0)

		if var_83_0 then
			return ffi.cast(var_80_1, ffi.cast("char*", ffi.cast("void***", var_83_0)) + 10640)[0][arg_83_1 or 0]
		end
	end

	function entity.get_simtime(arg_84_0)
		local var_84_0 = var_80_2(arg_84_0)

		if var_84_0 then
			return entity.get_prop(arg_84_0, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", var_84_0) + 620)[0]
		else
			return 0
		end
	end

	function entity.get_max_desync(arg_85_0)
		local var_85_0 = math.clamp(arg_85_0.feet_speed_forwards_or_sideways, 0, 1)
		local var_85_1 = (arg_85_0.stop_to_full_running_fraction * -0.3 - 0.2) * var_85_0 + 1
		local var_85_2 = arg_85_0.duck_amount

		if var_85_2 > 0 then
			var_85_1 = var_85_1 + var_85_2 * var_85_0 * (0.5 - var_85_1)
		end

		return math.clamp(var_85_1, 0.5, 1)
	end
end)()

local var_0_91 = {
	hex = "\a74A6A9FF",
	hexs = "\a74A6A9",
	accent = var_0_79.hex("74A6A9"),
	back = var_0_79.rgb(23, 26, 28),
	dark = var_0_79.rgb(5, 6, 8),
	white = var_0_79.rgb(255),
	black = var_0_79.rgb(0),
	null = var_0_79.rgb(0, 0, 0, 0),
	text = var_0_79.rgb(230),
	panel = {
		l1 = var_0_79.rgb(5, 6, 8, 96),
		g1 = var_0_79.rgb(5, 6, 8, 140),
		l2 = var_0_79.rgb(23, 26, 28, 96),
		g2 = var_0_79.rgb(23, 26, 28, 140)
	}
}
local var_0_92 = 1
local var_0_93, var_0_94 = client.screen_size()
local var_0_95 = var_0_93
local var_0_96 = var_0_94
local var_0_97 = {
	x = var_0_93 * 0.5,
	y = var_0_94 * 0.5
}
local var_0_98 = {
	x = var_0_95 * 0.5,
	y = var_0_96 * 0.5
}
local var_0_99 = LPH_NO_VIRTUALIZE(function()
	local var_86_0 = 1
	local var_86_1 = {}
	local var_86_2 = ""
	local var_86_3
	local var_86_4 = ui.reference("MISC", "Settings", "DPI scale")

	var_86_3 = {
		scalable = false,
		callback = function()
			local var_87_0 = var_0_92

			var_0_92 = var_86_3.scalable and var_0_20(string.sub(ui.get(var_86_4), 1, -2)) * 0.01 or 1
			var_0_95, var_0_96 = client.screen_size()
			var_0_93, var_0_94 = var_0_95 / var_0_92, var_0_96 / var_0_92
			var_0_97.x, var_0_97.y = var_0_93 * 0.5, var_0_94 * 0.5
			var_86_2 = var_0_92 ~= 1 and "d" or ""

			if var_87_0 ~= var_0_92 then
				var_0_78.dpi_change:fire(var_0_92, var_87_0)

				local var_87_1 = var_0_92
			end
		end
	}

	var_86_3.callback()
	ui.set_callback(var_86_4, var_86_3.callback)

	local function var_86_5()
		if var_0_93 == 0 or var_0_94 == 0 then
			var_86_3.callback()
		else
			var_0_78.paint_ui:unset(var_86_5)
		end
	end

	var_0_78.paint_ui:set(var_86_5)

	local var_86_6 = math.floor

	render = var_0_8({
		valid = false,
		cheap = true,
		dpi_t = var_86_3,
		push_alpha = function(arg_89_0)
			local var_89_0 = #var_86_1

			if var_89_0 > 255 then
				var_0_4("alpha stack exceeded 255 objects, report to developers")
			end

			var_86_1[var_89_0 + 1] = arg_89_0
			var_86_0 = var_86_0 * var_86_1[var_89_0 + 1] * (var_86_1[var_89_0] or 1)
		end,
		pop_alpha = function()
			local var_90_0 = #var_86_1
			local var_90_1

			var_86_1[var_90_0], var_90_1 = nil, var_90_0 - 1
			var_86_0 = var_90_1 == 0 and 1 or var_86_1[var_90_1] * (var_86_1[var_90_1 - 1] or 1)
		end,
		get_alpha = function()
			return var_86_0
		end,
		blur = function(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
			if not render.cheap and render.valid and (arg_92_4 or 1) * var_86_0 > 0.25 then
				blurs[#blurs + 1] = {
					var_86_6(arg_92_0 * var_0_92),
					var_86_6(arg_92_1 * var_0_92),
					var_86_6(arg_92_2 * var_0_92),
					var_86_6(arg_92_3 * var_0_92)
				}
			end
		end,
		gradient = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6)
			renderer.gradient(var_86_6(arg_93_0 * var_0_92), var_86_6(arg_93_1 * var_0_92), var_86_6(arg_93_2 * var_0_92), var_86_6(arg_93_3 * var_0_92), arg_93_4.r, arg_93_4.g, arg_93_4.b, arg_93_4.a * var_86_0, arg_93_5.r, arg_93_5.g, arg_93_5.b, arg_93_5.a * var_86_0, arg_93_6 or false)
		end,
		gradient_outline = function(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6, arg_94_7)
			arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_7 = var_86_6(arg_94_0 * var_0_92), var_86_6(arg_94_1 * var_0_92), var_86_6(arg_94_2 * var_0_92), var_86_6(arg_94_3 * var_0_92), var_86_6((arg_94_7 or 1) * var_0_92)

			local var_94_0 = arg_94_4.r
			local var_94_1 = arg_94_4.g
			local var_94_2 = arg_94_4.b
			local var_94_3 = arg_94_4.a * var_86_0
			local var_94_4 = arg_94_5.r
			local var_94_5 = arg_94_5.g
			local var_94_6 = arg_94_5.b
			local var_94_7 = arg_94_5.a * var_86_0

			if arg_94_6 then
				renderer.gradient(arg_94_0, arg_94_1, arg_94_2 - arg_94_7, arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3, var_94_4, var_94_5, var_94_6, var_94_7, arg_94_6)
				renderer.rectangle(arg_94_0, arg_94_1 + arg_94_7, arg_94_7, arg_94_3 - arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3)
				renderer.rectangle(arg_94_0 + arg_94_2 - arg_94_7, arg_94_1, arg_94_7, arg_94_3 - arg_94_7, var_94_4, var_94_5, var_94_6, var_94_7)
				renderer.gradient(arg_94_0 + arg_94_7, arg_94_1 + arg_94_3 - arg_94_7, arg_94_2 - arg_94_7, arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3, var_94_4, var_94_5, var_94_6, var_94_7, arg_94_6)
			else
				renderer.rectangle(arg_94_0, arg_94_1, arg_94_2 - arg_94_7, arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3, arg_94_6)
				renderer.gradient(arg_94_0, arg_94_1 + arg_94_7, arg_94_7, arg_94_3 - arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3, var_94_4, var_94_5, var_94_6, var_94_7, arg_94_6)
				renderer.gradient(arg_94_0 + arg_94_2 - arg_94_7, arg_94_1, arg_94_7, arg_94_3 - arg_94_7, var_94_0, var_94_1, var_94_2, var_94_3, var_94_4, var_94_5, var_94_6, var_94_7, arg_94_6)
				renderer.rectangle(arg_94_0 + arg_94_7, arg_94_1 + arg_94_3 - arg_94_7, arg_94_2 - arg_94_7, arg_94_7, var_94_4, var_94_5, var_94_6, var_94_7, arg_94_6)
			end
		end,
		line = function(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4)
			renderer.line(var_86_6(arg_95_0 * var_0_92), var_86_6(arg_95_1 * var_0_92), var_86_6(arg_95_2 * var_0_92), var_86_6(arg_95_3 * var_0_92), arg_95_4.r, arg_95_4.g, arg_95_4.b, arg_95_4.a * var_86_0)
		end,
		rectangle = function(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
			arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_5 = var_86_6(arg_96_0 * var_0_92), var_86_6(arg_96_1 * var_0_92), var_86_6(arg_96_2 * var_0_92), var_86_6(arg_96_3 * var_0_92), arg_96_5 and var_86_6(arg_96_5 * var_0_92) or 0

			local var_96_0 = arg_96_4.r
			local var_96_1 = arg_96_4.g
			local var_96_2 = arg_96_4.b
			local var_96_3 = arg_96_4.a * var_86_0

			if arg_96_5 == 0 then
				renderer.rectangle(arg_96_0, arg_96_1, arg_96_2, arg_96_3, var_96_0, var_96_1, var_96_2, var_96_3)
			else
				renderer.circle(arg_96_0 + arg_96_5, arg_96_1 + arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3, arg_96_5, 180, 0.25)
				renderer.rectangle(arg_96_0 + arg_96_5, arg_96_1, arg_96_2 - arg_96_5 - arg_96_5, arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3)
				renderer.circle(arg_96_0 + arg_96_2 - arg_96_5, arg_96_1 + arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3, arg_96_5, 90, 0.25)
				renderer.rectangle(arg_96_0, arg_96_1 + arg_96_5, arg_96_2, arg_96_3 - arg_96_5 - arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3)
				renderer.circle(arg_96_0 + arg_96_5, arg_96_1 + arg_96_3 - arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3, arg_96_5, 270, 0.25)
				renderer.rectangle(arg_96_0 + arg_96_5, arg_96_1 + arg_96_3 - arg_96_5, arg_96_2 - arg_96_5 - arg_96_5, arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3)
				renderer.circle(arg_96_0 + arg_96_2 - arg_96_5, arg_96_1 + arg_96_3 - arg_96_5, var_96_0, var_96_1, var_96_2, var_96_3, arg_96_5, 0, 0.25)
			end
		end,
		rect_outline = function(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5, arg_97_6)
			arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_5, arg_97_6 = var_86_6(arg_97_0 * var_0_92), var_86_6(arg_97_1 * var_0_92), var_86_6(arg_97_2 * var_0_92), var_86_6(arg_97_3 * var_0_92), arg_97_5 and var_86_6(arg_97_5 * var_0_92) or 0, var_86_6((arg_97_6 or 1) * var_0_92)

			local var_97_0 = arg_97_4.r
			local var_97_1 = arg_97_4.g
			local var_97_2 = arg_97_4.b
			local var_97_3 = arg_97_4.a * var_86_0

			if arg_97_5 == 0 then
				renderer.rectangle(arg_97_0, arg_97_1, arg_97_2 - arg_97_6, arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.rectangle(arg_97_0, arg_97_1 + arg_97_6, arg_97_6, arg_97_3 - arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.rectangle(arg_97_0 + arg_97_2 - arg_97_6, arg_97_1, arg_97_6, arg_97_3 - arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.rectangle(arg_97_0 + arg_97_6, arg_97_1 + arg_97_3 - arg_97_6, arg_97_2 - arg_97_6, arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
			else
				renderer.circle_outline(arg_97_0 + arg_97_5, arg_97_1 + arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3, arg_97_5, 180, 0.25, arg_97_6)
				renderer.rectangle(arg_97_0 + arg_97_5, arg_97_1, arg_97_2 - arg_97_5 - arg_97_5, arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.circle_outline(arg_97_0 + arg_97_2 - arg_97_5, arg_97_1 + arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3, arg_97_5, 270, 0.25, arg_97_6)
				renderer.rectangle(arg_97_0, arg_97_1 + arg_97_5, arg_97_6, arg_97_3 - arg_97_5 - arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.circle_outline(arg_97_0 + arg_97_5, arg_97_1 + arg_97_3 - arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3, arg_97_5, 90, 0.25, arg_97_6)
				renderer.rectangle(arg_97_0 + arg_97_5, arg_97_1 + arg_97_3 - arg_97_6, arg_97_2 - arg_97_5 - arg_97_5, arg_97_6, var_97_0, var_97_1, var_97_2, var_97_3)
				renderer.circle_outline(arg_97_0 + arg_97_2 - arg_97_5, arg_97_1 + arg_97_3 - arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3, arg_97_5, 0, 0.25, arg_97_6)
				renderer.rectangle(arg_97_0 + arg_97_2 - arg_97_6, arg_97_1 + arg_97_5, arg_97_6, arg_97_3 - arg_97_5 - arg_97_5, var_97_0, var_97_1, var_97_2, var_97_3)
			end
		end,
		triangle = function(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5, arg_98_6)
			arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5 = arg_98_0 * var_0_92, arg_98_1 * var_0_92, arg_98_2 * var_0_92, arg_98_3 * var_0_92, arg_98_4 * var_0_92, arg_98_5 * var_0_92

			renderer.triangle(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5, arg_98_6.r, arg_98_6.g, arg_98_6.b, arg_98_6.a * var_86_0)
		end,
		circle = function(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5)
			renderer.circle(arg_99_0 * var_0_92, arg_99_1 * var_0_92, arg_99_2.r, arg_99_2.g, arg_99_2.b, arg_99_2.a * var_86_0, arg_99_3 * var_0_92, arg_99_4 or 0, arg_99_5 or 1)
		end,
		circle_outline = function(arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4, arg_100_5, arg_100_6)
			renderer.circle(arg_100_0 * var_0_92, arg_100_1 * var_0_92, arg_100_2.r, arg_100_2.g, arg_100_2.b, arg_100_2.a * var_86_0, arg_100_3 * var_0_92, arg_100_4 or 0, arg_100_5 or 1, arg_100_6 * var_0_92)
		end,
		screen_size = function(arg_101_0)
			local var_101_0, var_101_1 = client.screen_size()

			if arg_101_0 then
				return var_101_0, var_101_1
			else
				return var_101_0 / var_0_92, var_101_1 / var_0_92
			end
		end,
		load_rgba = function(arg_102_0, arg_102_1, arg_102_2)
			return renderer.load_rgba(arg_102_0, arg_102_1, arg_102_2)
		end,
		load_jpg = function(arg_103_0, arg_103_1, arg_103_2)
			return renderer.load_jpg(arg_103_0, arg_103_1, arg_103_2)
		end,
		load_png = function(arg_104_0, arg_104_1, arg_104_2)
			return renderer.load_png(arg_104_0, arg_104_1, arg_104_2)
		end,
		load_svg = function(arg_105_0, arg_105_1, arg_105_2)
			return renderer.load_svg(arg_105_0, arg_105_1, arg_105_2)
		end,
		texture = function(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6)
			if not arg_106_0 then
				return
			end

			renderer.texture(arg_106_0, var_86_6(arg_106_1 * var_0_92), var_86_6(arg_106_2 * var_0_92), var_86_6(arg_106_3 * var_0_92), var_86_6(arg_106_4 * var_0_92), arg_106_5.r, arg_106_5.g, arg_106_5.b, arg_106_5.a * var_86_0, arg_106_6 or "f")
		end,
		text = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4, ...)
			renderer.text(arg_107_0 * var_0_92, arg_107_1 * var_0_92, arg_107_2.r, arg_107_2.g, arg_107_2.b, arg_107_2.a * var_86_0, (arg_107_3 or "") .. var_86_2, arg_107_4 or 0, ...)
		end,
		measure_text = function(arg_108_0, arg_108_1)
			local var_108_0, var_108_1 = renderer.measure_text((arg_108_0 or "") .. var_86_2, arg_108_1)

			return var_108_0 / var_0_92, var_108_1 / var_0_92
		end
	}, {
		__index = renderer
	})

	return render
end)()
local var_0_100 = LPH_NO_VIRTUALIZE(function()
	local var_109_0 = var_0_8({}, {
		__mode = "kv"
	})
	local var_109_1 = globals.absoluteframetime()
	local var_109_2 = 1
	local var_109_3 = {
		pow = {
			function(arg_110_0, arg_110_1)
				return 1 - (1 - arg_110_0)^(arg_110_1 or 3)
			end,
			function(arg_111_0, arg_111_1)
				return arg_111_0^(arg_111_1 or 3)
			end,
			function(arg_112_0, arg_112_1)
				return arg_112_0 < 0.5 and 4 * math.pow(arg_112_0, arg_112_1 or 3) or 1 - math.pow(-2 * arg_112_0 + 2, arg_112_1 or 3) * 0.5
			end
		}
	}

	anima = {
		pulse = 0,
		easings = var_109_3,
		lerp = function(arg_113_0, arg_113_1, arg_113_2, arg_113_3)
			local var_113_0 = arg_113_0 + (arg_113_1 - arg_113_0) * var_109_1 * (arg_113_2 or 8) * var_109_2

			return math.abs(arg_113_1 - var_113_0) < (arg_113_3 or 0.005) and arg_113_1 or var_113_0
		end,
		condition = function(arg_114_0, arg_114_1, arg_114_2, arg_114_3)
			local var_114_0 = arg_114_0[1] and arg_114_0 or var_109_0[arg_114_0]

			if not var_114_0 then
				var_109_0[arg_114_0] = {
					arg_114_1 and 1 or 0,
					arg_114_1
				}
				var_114_0 = var_109_0[arg_114_0]
			end

			arg_114_2 = arg_114_2 or 4

			local var_114_1 = arg_114_2

			if var_0_24(arg_114_2) == "table" then
				var_114_1 = arg_114_1 and arg_114_2[1] or arg_114_2[2]
			end

			var_114_0[1] = math.clamp(var_114_0[1] + var_109_1 * math.abs(var_114_1) * var_109_2 * (arg_114_1 and 1 or -1), 0, 1)

			return (var_114_0[1] % 1 == 0 or var_114_1 < 0) and var_114_0[1] or var_109_3.pow[arg_114_3 and (arg_114_1 and arg_114_3[1][1] or arg_114_3[2][1]) or arg_114_1 and 1 or 3](var_114_0[1], arg_114_3 and (arg_114_1 and arg_114_3[1][2] or arg_114_3[2][2]) or 3)
		end
	}

	var_0_78.paint_ui:set(function()
		anima.pulse = math.sin(globals.realtime()) * 0.5 + 0.5
		var_109_1 = globals.frametime()
	end)

	return anima
end)()
local var_0_101
local var_0_102 = {
	corner_h = var_0_99.load_svg("<svg width=\"4\" height=\"5.87\" viewBox=\"0 0 4 6\"><path fill=\"#fff\" d=\"M0 6V4c0-2 2-4 4-4v2C2 2 0 4 0 6Z\"/></svg>", 8, 12),
	corner_v = var_0_99.load_svg("<svg width=\"5.87\" height=\"4\" viewBox=\"0 0 6 4\"><path fill=\"#fff\" d=\"M2 0H0c0 2 2 4 4 4h2C4 4 2 2 2 0Z\"/></svg>", 12, 8),
	warning = var_0_99.load_svg("<svg width=\"16\" height=\"16\" viewBox=\"0 0 16 16\"><path fill=\"#fff\" d=\"m13.259 13h-10.518c-0.35787 0.0023-0.68906-0.1889-0.866-0.5-0.18093-0.3088-0.18093-0.6912 0-1l5.259-9.015c0.1769-0.31014 0.50696-0.50115 0.864-0.5 0.3568-0.00121 0.68659 0.18986 0.863 0.5l5.26 9.015c0.1809 0.3088 0.1809 0.6912 0 1-0.1764 0.3097-0.5056 0.5006-0.862 0.5zm-6.259-3v2h2v-2zm0-5v4h2v-4z\"/></svg>", 16, 16),
	manual = var_0_99.load_svg("<svg width=\"8\" height=\"10\" viewBox=\"0 0 8 10\"><path fill=\"#fff\" d=\"m0.384 5.802c-0.24286-0.19453-0.3842-0.48884-0.3842-0.8s0.14134-0.60547 0.3842-0.8l6.08-4c0.29513-0.22371 0.69277-0.25727 1.0212-0.086202 0.32846 0.17107 0.52889 0.51613 0.51477 0.8862l-1.92 3.96 1.92 4.04c0.01412 0.37007-0.18631 0.71513-0.51477 0.8862-0.32846 0.1711-0.7261 0.1375-1.0212-0.0862z\"/></svg>", 10, 10),
	mini_bfly = var_0_99.load_png("\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\t\x00\x00\x00\t\b\x06\x00\x00\x00\xE0\x91\x06\x10\x00\x00\x00\x04sBIT\b\b\b\b|\bd\x88\x00\x00\x00\xFDIDAT\x18Wc\xE4\xE7\xE7\xEF\xF8\xF8\xF1c9\x1F\x1F߮O\x9F>\xA5300<\x00b\x05..\xAE\xE5߾}\xB3\x00\xCAw2\x02\x05\xFE\xBF\x7F\xFF\x9Ea\xC1\x82\x05\f\xE5\xE5\xE5\xDF\x7F\xFD\xFA\x95\xC5\xC6\xC66\xB5\xB3\xB3\x93+!!\x81APP\x90\x01\xAC\b\b\x80\x14\x03Xabb\"\xC3\xFC\xF9\xF3\x19@\n@\x80\x91\x91\x91\x81\x91\x97\x97\xF7͡C\x87\x84\r\f\f\xE0\na\n\x0E\x1C8\xC0\x10\x1A\x1Az\x91\x11\xE4&IIɼ\xF6\xF6v΀\x80\x00\xB0B\x10ذa\x03CVV֏\xE7ϟg\x82\xACsPSS\xDBr\xF3\xE6Mn\x90\xE4\x83\a\x0F\x18\x14\x14\x14\xC0\nUTT>ݽ{\xD7\x1F\xA4H\x00\xE8\xB8\a\xFB\xF6\xED\xE3\aI\xF8\xFA\xFA\xFEټy3\v\x88mnn\x0E\xF2\b\x17H\x11\b$\xB0\xB3\xB3O\a1~\xFE\xFC\xB9\x12\xC8\x0E\a\xF9\x06\xA8\xC0\n(t\x01\xA6\b\xEE\x16l\f\x00$\xDFai]i\xDBy\x00\x00\x00\x00IEND\xAEB`\x82", 9, 9),
	logo_l = var_0_99.load_png("\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x1A\x00\x00\x00\x0F\b\x06\x00\x00\x00\xFAQ\xDF\xE6\x00\x00\x00\x04sBIT\b\b\b\b|\bd\x88\x00\x00\x02iIDAT8O\xBDT=\x88\x92q\x18\xFF\xBFW\x04\xC7\t\xBAX\xE1\xE2;5\xE5\x17XN\r\xA14T\xD0 \t\"M:\x98\xA3é\xE094\b\x1AwC!.\n\x92%t tX\x8B\xF8\xD2\xE2\x90`)Nw:\xA4\x83\x11\xB6\xA8\xDCq\x9B\xF6{^\xFF\x7F\xBB$2\xE2\xB8\a\x1E|\xBE\xDE\xDF\xEF\xF9x_%vA\"]\x10\x0FS\x89F\xA3\xD1{\xBD^\xFF\x80\xECz\xBD~t\a\x02\xF3\xC7y6AD[~\xBF\xFF\xD8\xEB\xF52\xA7\xD3\xC9\x02\x81\x00\xCB\xE7\xF3\xE71\xA9o<\x1E\xBFn6\x9B\xCC\xE5r\x99\b\xD0\x01\xFD\xD4\xEF\xF7\x99\xD1hd\x92$\xED\xC3\x7FF\x83\xAEL\xA5\x87\x7F\x15z\x02\xED\xAFL{\x13\xFE\x9C\xC7)/\x0F\x87\xC3#\x83\xC1p%\x9DN\xB3H$\"\x11\x11\x01\xEC\xCE\xE7\xF3'\x83\xC1\x80\xE9t:\xA6\xD5jU\x1C\xF8J\xB9\\>\r\x87\xC3\x0F\x050\x1Aa\xADV\x8BY\xADV\x16\x8FǿD\xA3Q\x8BF\xA3\xB9$\xF2\x9DN\xE7\x9B\xD9l6\x9Cm\xA4\xDDn/n\x94\xCDf\xBF\a\x83\xC1kdS\a\xDDn\x97\xE5r9\xBA\xD7i\xA1Pؤ8\xF9\x8A\xA2\xD0\x1AZ\xD3\xE9\xD42\x9B\xCD6j\xB5ډ\xDB\xED\xDE*\x95J\xCC\xE7\xF3-\xB1q\n\xB5\x9E\bl6\x9B\x1A'\"\x19\x0F|\xA5\xFBp\xA0e\xC7\xE8\xFE\x10\xF9\x0E\xF2\x1Eq?\xBB\xDDNM]\x17\xB5\xB8\xC3r\x03\x93Ʉ6\xD2F\xBD\x95\xEA\xF9ڶ\x13\x89\x84\x9B\x88\x9C\xB8O\x8D߇%\x93I%\x16\x8B99\xD0+\xE4\xCB\x00; @Y\x96\x99\x00n4\x1A\xCC\xE1p01\r\xC0՗)\x95JU\xD1\xC8=\x9A\x82\xCE\xD0\xEB\xF5\xA6\xC5b\xF1P\xCAd2\xFB\xA1P\xE81\x1F\xF3%\xF2\x9B\xB8W@\xECagg\xE7\xB3\xC7㱘L\xA6\xCB\x14\xA3\xAE醘\xF6\x18\rj\xA8A!\xBC\xB92H\xDDDJB\xB8\xD5jU]\xDD[\xA8\x87\x17?\xC2\xEF-h\\<\x8C{\xCC*\x95\xCA\x06\xDD@\xEC\x9E\x03~D\xCD\xDD%\xCB/\xE3)\xCC\xECJ\xFC\r\x11\xBD8\x13܃M\x1Fj\x14J\xAD\x1A0ݢ5.\xE26poCo@\xE9\xF3\x10r\x00C\xE11\xF1v4\xE0\xABD\x7F\x93\x0FH\xDE\xFFC\xC16b\xCF\xD7<\xFB[z\x1D\x11MC\x80\x8Bw\x94\xB1\x16t\x17\xFA\x0EJ\x1F\xE6?\xCB:\"\x01$s\xE0\xFF\xFE\xFF\xFB\t\x1C\xFB\x05y1\x12\xE3l\x00\x00\x00\x00IEND\xAEB`\x82", 26, 15),
	logo_r = var_0_99.load_png("\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x18\x00\x00\x00\x0F\b\x06\x00\x00\x00\xFE\xA4\x0F\xDB\x00\x00\x00\x04sBIT\b\b\b\b|\bd\x88\x00\x00\x02\bIDAT8O\xD5S=hZQ\x14>\xCF`\x97$(\x11\x87\xB8\xF8\b\xB5`\x92\x16%\x85\xBA\x89?%c\xA1\xA3ƀ\xE8P\x02]2\xE8T4\xA3B;\xB4\x0E\x19\xD4M\tAh\x93\xA9P\x95b\a\xC9 \x15\x92A\x9Ct\x90R\x84`\v\xA5Xh_\xBFss\x1F<)\xA4 dȅ\x8Fs\xEEy\xE7\x9C\xEF\xBB\x1F<\x85n\xF8(7\xBC\x9F\xE6!X\x9CN\xA7c\x93\xC9\xF4\xC7l6/\xFDO\xE0<\x04\xAF5M{>\x1C\x0EIU\xD5' 8\xBD\x8E\xC4H\xB0\x88F\x15\xF8\x01\f\fC\x9B\xC85y\xE7\xFA'\xC0+\xEF;\x88\x15\x99\xDB\x11y\x87qVX\xF4\xB4\xDDn\x1F\xF8|>^$N\xADV\xEB\x04\x02\x81{6\x9Bm٨n<\x1E\xFF\xB6\xDB\xED\v\\\x93/\b#\xFD:\x1A\x8D:\x0E\x87\xE3\x0E׻\xDD.y<\x1E\xAAV\xAB\x14\x8DF\x15\xA5\xDF\xEF\x7Fw\xB9\\\xCB\xF9|\x9E\x90S\xB1X\x14M^\xAF\x97&\x93\tY,\x16R\x94\xAB\x87&\x12\t\n\x06\x83\x14\x89D\x88\xFB\xD3\xE9\xF4\x16z:ܓL&\xA9T*\xD1`0 \xAB\xD5\xCAx\xCB\xE2\x15\xF8\xA9?_,ї\xF32&\x93J>K[\xBE`\xE1*\xF7aA\xABR\xA9\xD8@\xB6\xD1h4(\x1C\x0E\x1F\x97\xCB\xE5\x87\xF1x|Mޅ}\x82@_j\xB0\xE3U\xBD^\xDF\x0F\x85B\xBA\xB2\xFB\xF8v\xD1l6\xDFú\xEDV\xAB\xF5\xCB\xEF\xF7\x1F\xE5r\xB9\xDDT*\xA5\x8Bx\x06\xF2CË}\x989S\xA0B\xE3'\x1BO\xA1P\xB8\x8C\xC5b+R\xE99\xE2\x03\xCE3\x99L;\x9B\xCD\xF2\xA08l\x1D[\xE2t:ŝ\x95\xB3(>\xBD^\xEF\xA7\xDB\xED^gsg,\x92\xB3\x1F\x10\x1F\x03߀7\xC0\vY\x7F\x89\xB8o\x10\xD3A\xBE5\xA3n\xF6\xB2\xC3\x04\x8F\x80\xA8\xAC\xF3\xC2\x8F\xC0]`C\xD6NX\x9C\xCCU\xC4\x04`\x01΀w\xC0\x1E\xC0\x16\x0EY8\xB0\rL\x0017Ϗv\x8D\xE0\x7F?\xDD~\x82\xBF).\xBB\x8B\x1E\xD2\x13\xD3\x00\x00\x00\x00IEND\xAEB`\x82", 24, 15)
}
local var_0_103 = var_0_16("hysteria/butterfly.png")

local function var_0_104(arg_116_0)
	var_0_102.butterfly = var_0_99.load_png(arg_116_0, 1024, 1024)
	var_0_102.butterfly_s = var_0_99.load_png(arg_116_0, 64, 64)
end

if not var_0_103 then
	var_0_45.get("https://cdn.hysteria.one/main/butterfly.png", function(arg_117_0, arg_117_1)
		if arg_117_0 and string.sub(arg_117_1.body, 2, 4) == "PNG" then
			var_0_104(arg_117_1.body)
			var_0_17("hysteria/butterfly.png", arg_117_1.body)
		end
	end)
else
	var_0_104(var_0_103)
end

if _AZAZI then
	var_0_45.get("https://cdn.hysteria.one/azazogo/logo_lo.png", function(arg_118_0, arg_118_1)
		if arg_118_0 and string.sub(arg_118_1.body, 2, 4) == "PNG" then
			var_0_102.logo_l = var_0_99.load_png(arg_118_1.body, 35, 15)
		end
	end)
	var_0_45.get("https://cdn.hysteria.one/azazogo/logo_ro.png", function(arg_119_0, arg_119_1)
		if arg_119_0 and string.sub(arg_119_1.body, 2, 4) == "PNG" then
			var_0_102.logo_r = var_0_99.load_png(arg_119_1.body, 35, 15)
		end
	end)
end

local var_0_105 = LPH_NO_VIRTUALIZE(function()
	local var_120_0
	local var_120_1 = {}
	local var_120_2 = {
		bg = var_0_79(255),
		line = var_0_79(255)
	}
	local var_120_3 = 0
	local var_120_4 = 0
	local var_120_5 = 0
	local var_120_6 = 0
	local var_120_7 = 0
	local var_120_8 = 0

	var_0_78.paint_ui:set(function()
		var_120_3, var_120_4 = ui.mouse_position()
		var_120_3, var_120_4 = var_120_3 / var_0_92, var_120_4 / var_0_92
		var_120_5, var_120_6 = ui.menu_position()
		var_120_7, var_120_8 = ui.menu_size()
		var_120_5, var_120_6, var_120_7, var_120_8 = var_120_5 / var_0_92, var_120_6 / var_0_92, var_120_7 / var_0_92, var_120_8 / var_0_92
	end)

	local function var_120_9(arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4, arg_122_5)
		return arg_122_2 <= arg_122_0 and arg_122_3 <= arg_122_1 and arg_122_0 <= arg_122_4 and arg_122_1 <= arg_122_5
	end

	local var_120_10 = {
		menu = {
			0
		},
		bg = {
			0
		}
	}

	var_0_78.paint_ui:set(function()
		local var_123_0 = var_0_100.condition(var_120_10.bg, var_120_0 ~= nil, 2)

		if var_123_0 == 0 then
			return
		end

		var_0_99.push_alpha(var_123_0)
		var_0_99.rectangle(0, 0, var_0_93, var_0_94, var_0_91.panel.l1)
		var_0_99.pop_alpha()
	end)

	local function var_120_11(arg_124_0)
		local var_124_0 = arg_124_0.__drag

		if var_124_0.locked or not var_0_44.menu_open then
			return
		end

		local var_124_1 = client.key_state(1)
		local var_124_2 = var_120_9(var_120_3, var_120_4, arg_124_0.x, arg_124_0.y, arg_124_0.x + arg_124_0.w, arg_124_0.y + arg_124_0.h) and not var_120_9(var_120_3, var_120_4, var_120_5, var_120_6, var_120_5 + var_120_7, var_120_6 + var_120_8)

		if var_124_1 and var_124_0.ready == nil then
			var_124_0.ready = var_124_2
			var_124_0.ix, var_124_0.iy = arg_124_0.x, arg_124_0.y
			var_124_0.px, var_124_0.py = arg_124_0.x - var_120_3, arg_124_0.y - var_120_4
		end

		if var_124_1 and var_124_0.ready then
			if var_120_0 == nil and var_124_0.on_held then
				var_124_0.on_held(arg_124_0, var_124_0)
			end

			var_120_0 = var_124_0.ready and var_120_0 == nil and arg_124_0.id or var_120_0
			var_124_0.active = var_120_0 == arg_124_0.id
		elseif not var_124_1 then
			if var_124_0.active and var_124_0.on_release then
				var_124_0.on_release(arg_124_0, var_124_0)
			end

			var_124_0.active = false
			var_120_0, var_124_0.ready, var_124_0.aligning, var_124_0.px, var_124_0.py, var_124_0.ix, var_124_0.iy = nil
		end

		var_124_0.hovered = var_124_2 or var_124_0.active

		local var_124_3 = {}
		local var_124_4 = arg_124_0.x * var_0_92
		local var_124_5 = arg_124_0.y * var_0_92
		local var_124_6 = arg_124_0.w * var_0_92
		local var_124_7 = arg_124_0.h * var_0_92
		local var_124_8 = var_124_0.px and (var_124_0.px + var_120_3) * var_0_92 or var_124_4
		local var_124_9 = var_124_0.py and (var_124_0.py + var_120_4) * var_0_92 or var_124_5
		local var_124_10 = var_124_4 + var_124_6 * 0.5
		local var_124_11 = var_124_5 + var_124_7 * 0.5
		local var_124_12 = var_0_100.condition(var_124_0.progress[1], var_124_0.hovered, 4)
		local var_124_13 = var_0_100.condition(var_124_0.progress[2], var_124_0.active, 4)

		var_0_99.rectangle(arg_124_0.x - 3, arg_124_0.y - 3, arg_124_0.w + 6, arg_124_0.h + 6, var_120_2.bg:alphen(12 + 24 * var_124_12), 6)
		var_0_99.push_alpha(var_124_13)

		if not client.key_state(162) then
			local var_124_14 = (var_124_8 + var_124_6 * 0.5) / var_0_92
			local var_124_15 = (var_124_9 + var_124_7 * 0.5) / var_0_92

			for iter_124_0, iter_124_1 in var_0_9(var_124_0.rulers) do
				local var_124_16 = iter_124_1[2] / var_0_92
				local var_124_17 = iter_124_1[3] / var_0_92
				local var_124_18 = math.abs(iter_124_1[1] and var_124_14 - var_124_16 or var_124_15 - var_124_17) < 10 * var_0_92
				local var_124_19 = iter_124_1[1] and 1 or 2

				if not var_124_3[var_124_19] then
					var_124_3[var_124_19] = var_124_18 and (iter_124_1[1] and var_124_16 - arg_124_0.w * 0.5 or var_124_17 - arg_124_0.h * 0.5) or nil
				end

				iter_124_1.p = iter_124_1.p or {
					0
				}

				local var_124_20 = math.abs(iter_124_1[1] and var_124_10 - var_124_16 or var_124_11 - var_124_17)
				local var_124_21 = var_0_100.condition(iter_124_1.p, var_124_18 or var_124_20 < 10 * var_0_92, -8) * 0.35 + 0.1

				var_0_99.rectangle(var_124_16, var_124_17, iter_124_1[1] and 1 or iter_124_1[4], iter_124_1[1] and iter_124_1[4] or 1, var_120_2.line:alphen(var_124_21, true))
			end

			if var_124_0.border[5] then
				local var_124_22 = var_124_0.border[1]
				local var_124_23 = var_124_0.border[2]
				local var_124_24 = var_124_0.border[3]
				local var_124_25 = var_124_0.border[4]
				local var_124_26 = var_120_9(arg_124_0.x, arg_124_0.y, var_124_22, var_124_23, var_124_24 - arg_124_0.w * 0.5 - 1, var_124_25 - arg_124_0.h * 0.5 - 1)
				local var_124_27 = var_0_100.condition(var_124_0.progress[3], not var_124_26)

				var_0_99.rect_outline(var_124_22, var_124_23, var_124_24 - var_124_22, var_124_25 - var_124_23, var_120_2.line:alphen(var_124_27 * 0.75 + 0.25, true), 4)
			end
		end

		var_0_99.pop_alpha()

		if var_124_0.active then
			local var_124_28 = var_124_3[1] or var_124_8 / var_0_92
			local var_124_29 = var_124_3[2] or var_124_9 / var_0_92
			local var_124_30 = (var_124_0.border[1] - var_124_6 * 0.5) / var_0_92
			local var_124_31 = (var_124_0.border[2] - var_124_7 * 0.5) / var_0_92
			local var_124_32 = (var_124_0.border[3] - var_124_6 * 0.5) / var_0_92
			local var_124_33 = (var_124_0.border[4] - var_124_7 * 0.5) / var_0_92
			local var_124_34 = math.clamp(var_124_28, math.max(var_124_30, 0), math.min(var_124_32, var_0_93 - arg_124_0.w))
			local var_124_35 = math.clamp(var_124_29, math.max(var_124_31, 0), math.min(var_124_33, var_0_94 - arg_124_0.h))

			arg_124_0:set_position(var_124_34, var_124_35)

			if var_124_0.on_active then
				var_124_0.on_active(arg_124_0, var_124_0, fin)
			end
		end
	end

	drag = {
		data = var_120_1,
		new = function(arg_125_0, arg_125_1)
			var_120_1[arg_125_0.id] = {
				x = var_0_44.slider("MISC", "Settings", string.format("%s::%s-x", var_0_0, arg_125_0.id), 0, 10000, arg_125_0.x / var_0_93 * 10000),
				y = var_0_44.slider("MISC", "Settings", string.format("%s::%s-y", var_0_0, arg_125_0.id), 0, 10000, arg_125_0.y / var_0_94 * 10000)
			}

			var_120_1[arg_125_0.id].x:set_visible(false)
			var_120_1[arg_125_0.id].y:set_visible(false)
			var_120_1[arg_125_0.id].x:set_callback(function(arg_126_0)
				arg_125_0.x = math.round(arg_126_0.value * 0.0001 * var_0_93)
			end, true)
			var_120_1[arg_125_0.id].y:set_callback(function(arg_127_0)
				arg_125_0.y = math.round(arg_127_0.value * 0.0001 * var_0_94)
			end, true)

			arg_125_1 = var_0_24(arg_125_1) == "table" and arg_125_1 or {}
			arg_125_0.__drag = {
				locked = false,
				active = false,
				config = var_120_1[arg_125_0.id],
				progress = {
					{
						0
					},
					{
						0
					},
					{
						0
					}
				},
				ix = arg_125_0.x,
				iy = arg_125_0.y,
				rulers = arg_125_1.rulers or {},
				border = arg_125_1.border or {
					0,
					0,
					var_0_95,
					var_0_96
				},
				on_release = arg_125_1.on_release,
				on_held = arg_125_1.on_held,
				on_active = arg_125_1.on_active,
				work = var_120_11
			}

			var_0_78.dpi_change:set(function()
				var_120_1[arg_125_0.id].x:set(var_120_1[arg_125_0.id].x.value)
				var_120_1[arg_125_0.id].y:set(var_120_1[arg_125_0.id].y.value)

				arg_125_0.x, arg_125_0.y = math.round(var_120_1[arg_125_0.id].x.value * 0.0001 * var_0_93), math.round(var_120_1[arg_125_0.id].y.value * 0.0001 * var_0_94)
			end)
			var_0_78.setup_command:set(function(arg_129_0)
				if var_0_44.menu_open and (arg_125_0.__drag.hovered or arg_125_0.__drag.active) then
					arg_129_0.in_attack = 0
				end
			end)
		end
	}

	return drag
end)()
local var_0_106 = LPH_NO_VIRTUALIZE(function()
	local var_130_0

	var_130_0 = {
		update = function(arg_131_0)
			return 1
		end,
		paint = function(arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4)
			return
		end,
		set_position = function(arg_133_0, arg_133_1, arg_133_2)
			if arg_133_0.__drag then
				if arg_133_1 then
					arg_133_0.__drag.config.x:set(arg_133_1 / var_0_93 * 10000)

					arg_133_0.x = arg_133_1
				end

				if arg_133_2 then
					arg_133_0.__drag.config.y:set(arg_133_2 / var_0_94 * 10000)

					arg_133_0.y = arg_133_2
				end
			else
				arg_133_0.x, arg_133_0.y = arg_133_1 or arg_133_0.x, arg_133_2 or arg_133_0.y
			end
		end,
		get_position = function(arg_134_0)
			local var_134_0 = arg_134_0.__drag and arg_134_0.__drag.config

			if not var_134_0 then
				return arg_134_0.x, arg_134_0.y
			end

			return var_134_0.x.value * 0.0001 * var_0_93, var_134_0.y.value * 0.0001 * var_0_94
		end,
		__call = function(arg_135_0)
			local var_135_0 = arg_135_0.__list
			local var_135_1 = arg_135_0.__drag

			if var_135_0 then
				var_135_0.items, var_135_0.active = var_135_0.collect(), 0

				for iter_135_0 = 1, #var_135_0.items do
					if var_135_0.items[iter_135_0].active then
						var_135_0.active = var_135_0.active + 1
					end
				end
			end

			arg_135_0.alpha = arg_135_0:update()

			var_0_99.push_alpha(arg_135_0.alpha)

			if arg_135_0.alpha > 0 then
				if var_135_1 then
					var_135_1.work(arg_135_0)
				end

				if var_135_0 then
					var_130_0.traverse(arg_135_0)
				end

				arg_135_0:paint(arg_135_0.x, arg_135_0.y, arg_135_0.w, arg_135_0.h)
			end

			var_0_99.pop_alpha()
		end,
		enlist = function(arg_136_0, arg_136_1, arg_136_2)
			arg_136_0.__list = {
				active = 0,
				longest = 0,
				items = {},
				progress = var_0_8({}, {
					__mode = "k"
				}),
				minwidth = arg_136_0.w,
				collect = arg_136_1,
				paint = arg_136_2
			}
		end,
		traverse = function(arg_137_0)
			local var_137_0 = arg_137_0.__list
			local var_137_1 = 0
			local var_137_2 = 0
			local var_137_3 = 0

			var_137_0.active, var_137_0.longest = 0, 0

			for iter_137_0 = 1, #var_137_0.items do
				local var_137_4 = var_137_0.items[iter_137_0]
				local var_137_5 = var_137_4.name or iter_137_0

				var_137_0.progress[var_137_5] = var_137_0.progress[var_137_5] or {
					0
				}

				local var_137_6 = var_0_100.condition(var_137_0.progress[var_137_5], var_137_4.active)

				if var_137_6 > 0 then
					var_0_99.push_alpha(var_137_6)

					local var_137_7, var_137_8 = var_137_0.paint(arg_137_0, var_137_4, var_137_1, var_137_6)

					var_0_99.pop_alpha()

					var_137_0.active, var_137_1 = var_137_0.active + 1, var_137_1 + var_137_8 * var_137_6
					var_137_0.longest = math.max(var_137_0.longest, var_137_7)
				end
			end

			arg_137_0.w = var_0_100.lerp(arg_137_0.w, math.max(var_137_0.longest, var_137_0.minwidth), 10, 0.5)
		end,
		lock = function(arg_138_0, arg_138_1)
			if not arg_138_0.__drag then
				return
			end

			arg_138_0.__drag.locked = arg_138_1 and true or false
		end
	}
	var_130_0.__index = var_130_0
	widget = {
		new = function(arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4, arg_139_5)
			local var_139_0 = {
				type = 0,
				alpha = 0,
				id = arg_139_0,
				x = arg_139_1 or 0,
				y = arg_139_2 or 0,
				w = arg_139_3 or 0,
				h = arg_139_4 or 0,
				progress = {
					0
				}
			}

			if arg_139_5 then
				var_0_105.new(var_139_0, arg_139_5)
			end

			return var_0_8(var_139_0, var_130_0)
		end
	}

	return widget
end)()
local var_0_107
local var_0_108 = {
	states = {
		{
			"default",
			"Default",
			"D"
		},
		{
			"stand",
			"Standing",
			"S"
		},
		{
			"run",
			"Running",
			"R"
		},
		{
			"walk",
			"Walking",
			"W"
		},
		{
			"air",
			"Air",
			"A"
		},
		{
			"airc",
			"Air & crouch",
			"AC"
		},
		{
			"crouch",
			"Crouching",
			"C"
		},
		{
			"sneak",
			"Sneaking",
			"3"
		},
		{
			"fakelag",
			"Fakelag",
			"FL"
		}
	},
	snaps = {
		{
			"default",
			"Default",
			"D"
		},
		{
			"air",
			"Air",
			"A"
		},
		{
			"airc",
			"Air & crouch",
			"AC"
		},
		{
			"crouch",
			"Crouching",
			"C"
		},
		{
			"sneak",
			"Sneaking",
			"S"
		},
		{
			"peek",
			"On peek",
			"P"
		}
	}
}
local var_0_109 = {
	hitgroups = {
		[0] = "generic",
		"head",
		"chest",
		"stomach",
		"left arm",
		"right arm",
		"left leg",
		"right leg",
		"neck",
		"generic",
		"gear"
	},
	states = table.distribute(var_0_108.states, nil, 1),
	snaps = table.distribute(var_0_108.snaps, nil, 1),
	build = {
		stable = {
			"",
			""
		},
		beta = {
			"β",
			""
		},
		debug = {
			"♪",
			""
		}
	},
	exploit = {
		OS = 2,
		DT = 1
	},
	aspect_ratios = {
		{
			125,
			"5:4"
		},
		{
			133,
			"4:3"
		},
		{
			150,
			"3:2"
		},
		{
			160,
			"16:10"
		},
		{
			178,
			"16:9"
		},
		{
			200,
			"2:1"
		}
	}
}
local var_0_110 = {
	builder = {
		custom = {}
	},
	snap = {
		custom = {}
	}
}
local var_0_111
local var_0_112
local var_0_113, var_0_114 = {
	vulnerable = false,
	side = 0,
	duck_amount = 0,
	max_speed = 0,
	peeking = false,
	velocity_sqr = 0,
	valid = false,
	velocity = 0,
	self = entity.get_local_player(),
	origin = var_0_50(),
	threat = client.current_threat(),
	exploit = {
		lc_left = 0,
		defensive = false,
		ready = false
	},
	predicted = {
		velocity = 0
	}
}, {}
local var_0_115 = 0
local var_0_116 = 0
local var_0_117

var_0_78.predict_command:set(function(arg_140_0)
	if not var_0_113.valid or var_0_117 ~= arg_140_0.command_number then
		return
	end

	var_0_115 = entity.get_prop(var_0_113.weapon, "m_flPostponeFireReadyTime")

	local var_140_0 = entity.get_prop(var_0_113.self, "m_nTickBase") or 0

	if math.abs(var_140_0 - var_0_116) > 64 then
		var_0_116 = 0
	end

	if var_140_0 > var_0_116 then
		var_0_116 = var_140_0
	elseif var_140_0 < var_0_116 then
		-- block empty
	end

	var_0_113.exploit.lc_left = math.min(14, math.max(0, var_0_116 - var_140_0 - 1))
	var_0_113.exploit.defensive = var_0_113.exploit.lc_left > 0
end)
var_0_78.run_command:set(function(arg_141_0)
	var_0_117 = arg_141_0.command_number
end)

local function var_0_118(arg_142_0)
	if not var_0_113.weapon then
		return false
	end

	if not entity.get_prop(var_0_113.weapon, "m_bPinPulled") then
		return
	end

	local var_142_0 = entity.get_prop(var_0_113.weapon, "m_fThrowTime")

	return var_142_0 and var_142_0 ~= 0
end

local function var_0_119()
	if not var_0_113.valid or not var_0_113.weapon or not var_0_113.weapon_t then
		return
	end

	if var_0_113.weapon_t.weapon_type_int == 9 or var_0_113.weapon_t.name == "Medi-Shot" or var_0_113.weapon_t.type == "c4" then
		return
	end

	if entity.get_prop(var_0_113.weapon, "m_iClip1") == 0 then
		return
	end

	local var_143_0 = entity.get_prop(var_0_113.self, "m_nTickBase") * globals.tickinterval()
	local var_143_1 = entity.get_prop(var_0_113.self, "m_flNextAttack")
	local var_143_2 = entity.get_prop(var_0_113.weapon, "m_flNextPrimaryAttack")

	if not var_143_1 or not var_143_2 then
		return
	end

	if entity.get_prop(var_0_113.weapon, "m_iItemDefinitionIndex") == 64 and not (var_0_115 < globals.curtime()) then
		return
	end

	return var_143_1 <= var_143_0 and var_143_2 <= var_143_0
end

local function var_0_120()
	local var_144_0 = false
	local var_144_1 = false
	local var_144_2 = var_0_50(entity.get_prop(var_0_113.self, "m_vecVelocity"))
	local var_144_3 = var_0_107.misc.settings.maxshift.value - var_0_107.rage.aimbot.dt_fl[1].value + 1
	local var_144_4 = var_0_50(client.eye_position())
	local var_144_5 = var_0_50(client.extrapolate(var_144_4.x, var_144_4.y, var_144_4.z, var_144_2, var_144_3))

	for iter_144_0 = 1, #var_0_114 do
		local var_144_6 = var_0_114[iter_144_0]

		if entity.is_enemy(var_144_6) then
			if bit.band(entity.get_esp_data(var_144_6).flags or 0, bit.lshift(1, 11)) == 0 then
				local var_144_7 = {
					entity.hitbox_position(var_144_6, 0)
				}
				local var_144_8 = {
					client.extrapolate(var_144_7[1], var_144_7[2], var_144_7[3], var_144_2, 4)
				}
				local var_144_9 = {
					client.trace_bullet(var_0_113.self, var_144_5.x, var_144_5.y, var_144_5.z, var_144_8[1], var_144_8[2], var_144_8[3])
				}

				if var_144_9[2] and var_144_9[2] > 0 then
					var_144_0 = true

					break
				end
			else
				var_144_1 = true
			end
		end
	end

	return var_144_0, var_144_1
end

local function var_0_121()
	if not var_0_113.weapon_t then
		return 0
	end

	if entity.get_prop(var_0_113.self, "m_bIsScoped") == 1 then
		return var_0_113.weapon_t.max_player_speed_alt
	else
		return var_0_113.weapon_t.max_player_speed
	end
end

local function var_0_122(arg_146_0)
	var_0_113.self = entity.get_local_player()
	var_0_113.valid = var_0_113.self and entity.is_alive(var_0_113.self) and true or false
	var_0_113.threat = var_0_113.valid and client.current_threat() or nil
	var_0_113.weapon = var_0_113.valid and entity.get_player_weapon(var_0_113.self) or nil
	var_0_113.weapon_t = var_0_113.weapon and var_0_49(var_0_113.weapon)

	if var_0_113.valid then
		var_0_113.exploit.active = var_0_107.rage.aimbot.double_tap[1].value and var_0_107.rage.aimbot.double_tap[1].hotkey:get() and var_0_109.exploit.DT or var_0_107.aa.other.onshot.value and var_0_107.aa.other.onshot.hotkey:get() and var_0_109.exploit.OS or var_0_109.exploit.OFF

		if var_0_107.rage.other.duck:get() then
			var_0_113.exploit.active = nil
		end

		var_0_113.exploit.ready = var_0_46.get_double_tap()
		var_0_113.origin = var_0_50(entity.get_origin(var_0_113.self))
		var_0_113.animstate = entity.get_animstate(var_0_113.self)

		if arg_146_0 then
			local var_146_0 = entity.get_prop(var_0_113.self, "m_fFlags")

			var_0_113.throwing_nade = var_0_118(arg_146_0) or false
			var_0_113.can_shoot = var_0_119() or false
			var_0_113.using = arg_146_0.in_use == 1
			var_0_113.in_score = arg_146_0.in_score == 1
			var_0_113.on_ground = bit.band(var_146_0, bit.lshift(1, 0)) == 1
			var_0_113.jumping = not var_0_113.on_ground or arg_146_0.in_jump == 1
			var_0_113.walking = var_0_113.velocity > 5 and arg_146_0.in_speed == 1
			var_0_113.crouching = arg_146_0.in_duck == 1
			var_0_113.side = arg_146_0.in_moveright == 1 and -1 or arg_146_0.in_moveleft == 1 and 1 or 0
		end
	end
end

local function var_0_123(arg_147_0)
	var_0_113.self = entity.get_local_player()
	var_0_113.valid = var_0_113.self and entity.is_alive(var_0_113.self) and true or false
	var_0_113.in_game = true
	var_0_99.valid = var_0_113.valid
	var_0_113.threat = var_0_113.valid and client.current_threat() or nil
	var_0_113.weapon = var_0_113.valid and entity.get_player_weapon(var_0_113.self) or nil
	var_0_114 = entity.get_players()

	if var_0_113.valid then
		var_0_113.origin = var_0_50(entity.get_origin(var_0_113.self))
		var_0_113.duck_amount = entity.get_prop(var_0_113.self, "m_flDuckAmount")
		var_0_113.max_speed = var_0_121()

		local var_147_0, var_147_1, var_147_2 = entity.get_prop(var_0_113.self, "m_vecVelocity")

		var_0_113.velocity = math.sqrt3(var_147_0, var_147_1, var_147_2)
		var_0_113.movetype = entity.get_prop(var_0_113.self, "m_MoveType")
	end
end

local function var_0_124(arg_148_0)
	if var_0_113.valid then
		var_0_113.peeking, var_0_113.vulnerable = var_0_120()
	end
end

local function var_0_125()
	var_0_113.self = entity.get_local_player()
	var_0_113.valid = var_0_113.self and entity.is_alive(var_0_113.self) and true or false
	var_0_113.gamerules = entity.get_game_rules()
end

var_0_78.setup_command:set(var_0_122)
var_0_78.run_command:set(var_0_123)
var_0_78.predict_command:set(var_0_124)
var_0_78.net_update_end:set(var_0_125)
var_0_78.player_death:set(function(arg_150_0)
	if client.userid_to_entindex(arg_150_0.userid) ~= var_0_113.self then
		return
	end

	var_0_78.local_death:fire(arg_150_0)
end)
var_0_78.player_spawn:set(function(arg_151_0)
	if client.userid_to_entindex(arg_151_0.userid) ~= var_0_113.self then
		return
	end

	var_0_78.local_spawn:fire(arg_151_0)
end)
var_0_78.player_connect_full:set(function(arg_152_0)
	if client.userid_to_entindex(arg_152_0.userid) ~= var_0_113.self then
		return
	end

	var_0_78.local_connect_full:fire(arg_152_0)
end)

local var_0_126

var_0_78.paint_ui:set(function()
	local var_153_0 = globals.mapname() ~= nil

	if var_0_126 and not var_153_0 then
		var_0_113.self, var_0_113.valid = nil, false
		var_0_113.in_game = false

		var_0_78.local_disconnect:fire()

		var_0_126 = false
	end

	var_0_126 = var_153_0
end)

function entity.is_lethal(arg_154_0)
	if not var_0_113.weapon_t or not arg_154_0 or entity.is_dormant(arg_154_0) then
		return false
	end

	local var_154_0 = var_0_113.weapon_t.damage * 1.25

	return math.ceil(var_0_113.weapon_t.armor_ratio * 0.5 * var_154_0) >= entity.get_prop(arg_154_0, "m_iHealth")
end

local var_0_127
local var_0_128

LPH_NO_VIRTUALIZE(function()
	var_0_107 = {
		rage = {
			weapon = var_0_44.reference("RAGE", "Weapon type", "Weapon type"),
			aimbot = {
				enable = var_0_44.reference("RAGE", "Aimbot", "Enabled"),
				force_baim = var_0_44.reference("RAGE", "Aimbot", "Force body aim"),
				force_sp = var_0_44.reference("RAGE", "Aimbot", "Force safe point"),
				hit_chance = var_0_44.reference("RAGE", "Aimbot", "Minimum hit chance"),
				damage = var_0_44.reference("RAGE", "Aimbot", "Minimum damage"),
				damage_ovr = {
					var_0_44.reference("RAGE", "Aimbot", "Minimum damage override")
				},
				double_tap = {
					var_0_44.reference("RAGE", "Aimbot", "Double tap")
				},
				dt_fl = {
					var_0_44.reference("RAGE", "Aimbot", "Double tap fake lag limit")
				}
			},
			other = {
				peek = var_0_44.reference("RAGE", "Other", "Quick peek assist"),
				duck = var_0_44.reference("RAGE", "Other", "Duck peek assist"),
				log_misses = var_0_44.reference("RAGE", "Other", "Log misses due to spread")
			}
		},
		aa = {
			angles = {
				enable = var_0_44.reference("AA", "Anti-Aimbot angles", "Enabled"),
				pitch = {
					var_0_44.reference("AA", "Anti-Aimbot angles", "Pitch")
				},
				yaw = {
					var_0_44.reference("AA", "Anti-Aimbot angles", "Yaw")
				},
				base = var_0_44.reference("AA", "Anti-Aimbot angles", "Yaw base"),
				jitter = {
					var_0_44.reference("AA", "Anti-Aimbot angles", "Yaw jitter")
				},
				body = {
					var_0_44.reference("AA", "Anti-Aimbot angles", "Body yaw")
				},
				edge = var_0_44.reference("AA", "Anti-Aimbot angles", "Edge yaw"),
				fs_body = var_0_44.reference("AA", "Anti-Aimbot angles", "Freestanding body yaw"),
				freestand = var_0_44.reference("AA", "Anti-Aimbot angles", "Freestanding"),
				roll = var_0_44.reference("AA", "Anti-Aimbot angles", "Roll")
			},
			fakelag = {
				enable = var_0_44.reference("AA", "Fake lag", "Enabled"),
				amount = var_0_44.reference("AA", "Fake lag", "Amount"),
				variance = var_0_44.reference("AA", "Fake lag", "Variance"),
				limit = var_0_44.reference("AA", "Fake lag", "Limit")
			},
			other = {
				slowmo = var_0_44.reference("AA", "Other", "Slow motion"),
				legs = var_0_44.reference("AA", "Other", "Leg movement"),
				onshot = var_0_44.reference("AA", "Other", "On shot anti-aim"),
				fp = var_0_44.reference("AA", "Other", "Fake peek")
			}
		},
		misc = {
			clantag = var_0_44.reference("MISC", "Miscellaneous", "Clan tag spammer"),
			log_damage = var_0_44.reference("MISC", "Miscellaneous", "Log damage dealt"),
			ping_spike = var_0_44.reference("MISC", "Miscellaneous", "Ping spike"),
			settings = {
				dpi = var_0_44.reference("MISC", "Settings", "DPI scale"),
				accent = var_0_44.reference("MISC", "Settings", "Menu color"),
				maxshift = var_0_44.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
			},
			helper = var_0_61(var_0_44.reference, "VISUALS", "Other ESP", "Helper")
		}
	}

	local var_155_0
	local var_155_1
	local var_155_2
	local var_155_3 = {}

	client.delay_call(0.1, function()
		for iter_156_0 = 1, #var_155_3 do
			local var_156_0 = var_155_3[iter_156_0]

			var_156_0[1]:set_callback(function()
				var_156_0[1]:set(var_156_0[2])

				if var_156_0[3] then
					var_156_0[1]:set_visible(false)
				else
					var_156_0[1]:set_enabled(false)
				end
			end, true)
		end
	end)

	local var_155_4 = {
		tabs = {
			{
				"home",
				"Home"
			},
			{
				"servers",
				"Servers"
			},
			{
				"settings",
				"Settings"
			},
			{
				"antiaim",
				"Anti-aim"
			}
		},
		header = function(arg_158_0, arg_158_1)
			local var_158_0

			if arg_158_1 then
				var_158_0 = {
					arg_158_0:label(string.format("\v%s", arg_158_1)),
					arg_158_0:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
				}
			else
				var_158_0 = arg_158_0:label("\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾")
			end

			return var_158_0
		end,
		feature = function(arg_159_0, arg_159_1)
			arg_159_0 = arg_159_0.__type == "pui::element" and {
				arg_159_0
			} or arg_159_0

			local var_159_0, var_159_1 = arg_159_1(arg_159_0[1])

			for iter_159_0, iter_159_1 in var_0_10(var_159_0) do
				iter_159_1:depend({
					arg_159_0[1],
					var_159_1
				})
			end

			var_159_0[arg_159_0.key or "on"] = arg_159_0[1]

			return var_159_0
		end,
		space = function(arg_160_0)
			return arg_160_0:label("\n")
		end,
		private = function(arg_161_0, arg_161_1, arg_161_2)
			arg_161_1 = arg_161_1 or 2

			if arg_161_1 > var_0_67 then
				var_155_3[#var_155_3 + 1] = {
					arg_161_0,
					arg_161_2 or false,
					arg_161_1 >= 3
				}
			end

			return arg_161_0
		end
	}
	local var_155_5 = {
		other = var_0_44.group("AA", "Other"),
		angles = var_0_44.group("AA", "Anti-aimbot angles"),
		fakelag = var_0_44.group("AA", "Fake lag")
	}

	var_0_44.macros.hysteria = "\a74A6A9FF"
	var_0_44.macros.dot = "\v•\r  "
	var_0_44.macros.p = "\aCDCDCD50—  \r"
	var_0_44.macros.silent = "\aCDCDCD50"
	var_0_44.macros.insecure = "\aB6B665FF"
	var_0_128 = {
		title = var_155_5.fakelag:label("hysteria"),
		selector = var_155_5.fakelag:combobox("\nawselector", table.distribute(var_155_4.tabs, 2, nil)),
		var_155_4.header(var_155_5.fakelag),
		home = {
			info = {
				user = var_155_5.fakelag:label(string.format("Welcome, \v%s", var_0_65.user)),
				version = var_155_5.fakelag:label(string.format("Version: \v%s", var_0_65.version))
			},
			config = {
				var_155_4.header(var_155_5.other, "New config"),
				name = var_155_5.other:textbox("Name"),
				create = var_155_5.other:button("Create"),
				import = var_155_5.other:button("Import"),
				var_155_4.header(var_155_5.angles, "Your configs"),
				list = var_155_5.angles:listbox("Configs", {
					"Default"
				}),
				selected = var_155_5.angles:label("Selected: \vDefault"),
				list_report = var_155_5.angles:label("REPORT"),
				load = var_155_5.angles:button("\f<hysteria>Load"),
				loadaa = var_155_5.angles:button("Load AA only"),
				save = var_155_5.angles:button("Save"),
				export = var_155_5.angles:button("Export"),
				delete = var_155_5.angles:button("\aD95148FFDelete"),
				deleteb = var_155_5.angles:button("\aD9514840Delete")
			},
			verify = {
				var_155_4.space(var_155_5.other),
				var_155_4.header(var_155_5.other, "Discord"),
				var_155_5.other:button("Join us", function()
					client.open_link("https://discord.gg/eC82SmcF9E")
				end),
				auth = var_155_5.other:button("Copy authcode")
			}
		},
		servers = {
			list = {
				var_155_4.header(var_155_5.angles, "Your servers"),
				[0] = var_155_5.angles:listbox("Servers", {
					""
				}),
				connect = var_155_5.angles:button("Connect"),
				export = var_155_5.angles:button("Export"),
				delete = var_155_5.angles:button("Delete")
			},
			new = {
				var_155_4.header(var_155_5.other, "New server"),
				var_155_5.other:label("IP"),
				ip = var_155_5.other:textbox("IP"),
				paste = var_155_5.other:button("Paste IP"),
				var_155_5.other:label("Name"),
				name = var_155_5.other:textbox("Name"),
				create = var_155_5.other:button("Create"),
				var_155_4.header(var_155_5.other),
				import = var_155_5.other:button("Import")
			}
		},
		settings = {
			tab = var_155_5.angles:combobox("\nstab", {
				"Features",
				"Visual"
			}),
			space = var_155_4.space(var_155_5.angles)
		}
	}
	var_0_127 = {
		rage = {
			var_155_4.header(var_155_5.angles, "Ragebot"),
			teleport = var_155_4.feature({
				var_155_5.angles:checkbox("Auto teleport", 0)
			}, function(arg_163_0)
				return {
					land = var_155_5.angles:checkbox("\f<p>Ensure landing"),
					pistol = var_155_5.angles:checkbox("\f<p>Allow pistols")
				}, true
			end),
			exswitch = var_155_4.feature({var_155_5.angles:checkbox("Auto hide shots")}, function(arg_164_0)
				return {
					allow = var_155_5.angles:multiselect("\f<p>Additional weapons", {"Pistols", "Desert Eagle"})}, true
			end),
			recharge = var_155_5.angles:checkbox("Allow force recharge"),
			resolver = var_155_4.private(var_155_5.angles:checkbox("Jitter resolver")),
			peekfix = var_155_4.private(var_155_5.angles:checkbox("Early defensive"))
		},
		visuals = {
			var_155_5.angles:label("Accent color"),
			accent = var_155_5.angles:color_picker("\nacccent", var_0_91.accent.r, var_0_91.accent.g, var_0_91.accent.b, 255),
			var_155_4.space(var_155_5.angles),
			var_155_4.header(var_155_5.angles, "Screen"),
			crosshair = var_155_4.feature(var_155_5.angles:checkbox("Crosshair indicators"), function(arg_165_0)
				return {
					style = var_155_5.angles:combobox("\nch_style", {
						"Classic",
						"Mini"
					}),
					logo = var_155_5.angles:checkbox("\f<p>Butterfly")
				}, true
			end),
			damage = var_155_5.angles:checkbox("Damage indicator"),
			arrows = var_155_5.angles:checkbox("Anti-aim arrows"),
			water = var_155_4.feature(var_155_5.angles:checkbox("Watermark"), function()
				return {
					hide = var_155_5.angles:checkbox("\f<p>Hide logo"),
					var_155_5.angles:label("\f<p>Custom name"),
					name = var_155_5.angles:textbox("\ncustomname")
				}, true
			end),
			keylist = var_155_5.angles:checkbox("Keylist"),
			speclist = var_155_5.angles:checkbox("Speclist"),
			slowdown = var_155_5.angles:checkbox("Slowdown warning"),
			marker = var_155_5.angles:checkbox("Hitmarker"),
			var_155_4.space(var_155_5.angles),
			var_155_4.header(var_155_5.angles, "Other"),
			aspect = var_155_4.feature(var_155_5.angles:checkbox("Aspect ratio"), function()
				return {
					ratio = var_155_5.angles:slider("\naratio", 80, 200, 133, true, nil, 0.01, table.distribute(var_0_109.aspect_ratios, 2, 1))
				}, true
			end),
			dpi = var_155_5.angles:checkbox("DPI scaling")
		},
		misc = {
			var_155_4.space(var_155_5.angles),
			var_155_4.header(var_155_5.angles, "Miscellaneous"),
			clantag = var_155_5.angles:checkbox("Clantag"),
			filter = var_155_5.angles:checkbox("Console filter"),
			logs = var_155_4.feature(var_155_5.angles:checkbox("Eventlogger"), function(arg_168_0)
				return {
					events = var_155_5.angles:multiselect("\f<p>Events", {
						"Ragebot shots",
						"Harming enemies",
						"Getting harmed",
						"Anti-aim info"
					}),
					output = var_155_5.angles:multiselect("\f<p>Output", {
						"Console",
						"Screen"
					})
				}, true
			end),
			ladder = var_155_5.angles:checkbox("Fast ladder"),
			breaker = var_155_4.feature(var_155_5.angles:checkbox("Animation breaker"), function(arg_169_0)
				return {
					pitch = var_155_5.angles:checkbox("\f<p>Pitch 0 on land"),
					slia = var_155_5.angles:checkbox("\f<p>Static legs in air"),
					legs = var_155_5.angles:combobox("\f<p>Legs", {
						"None",
						"Static",
						"Jitter",
						"No step back"
					})
				}, true
			end)
		},
		antiaim = {
			on = var_155_5.fakelag:checkbox("Enable\naa"),
			tab = var_155_5.fakelag:combobox("\naatab", {
				"General",
				"Builder",
				"Defensive"
			}, nil, false),
			general = {
				var_155_4.header(var_155_5.angles, "General"),
				mode = var_155_5.angles:combobox("Anti-aim operator", {
					"gamesense",
					"hysteria"
				}),
				invert = var_155_5.angles:hotkey("Inverter", false, 0),
				edge = var_155_5.angles:hotkey("Edge yaw", false, 0),
				fs = var_155_4.feature(var_155_5.angles:checkbox("Freestanding", 0), function(arg_170_0)
					return {
						static = var_155_5.angles:checkbox("\f<p>Static\nfs")
					}, true
				end),
				manual = var_155_4.feature(var_155_5.angles:checkbox("Manual yaw"), function()
					return {
						static = var_155_5.angles:checkbox("\f<p>Static\nmy"),
						left = var_155_5.angles:hotkey("\f<p>Left \f<silent>HK\r", false, 0),
						right = var_155_5.angles:hotkey("\f<p>Right \f<silent>HK\r", false, 0),
						reset = var_155_5.angles:hotkey("\f<p>Reset \f<silent>HK\r", false, 0)
					}, true
				end),
				var_155_4.space(var_155_5.angles),
				var_155_4.header(var_155_5.angles, "Misc"),
				head = var_155_4.feature(var_155_5.angles:checkbox("Safe head"), function()
					return {}, true
				end),
				jmove = var_155_5.angles:checkbox("Jitter move"),
				stab = var_155_5.angles:checkbox("Avoid backstab"),
				use = var_155_5.angles:checkbox("Legit AA"),
				fl = var_155_4.feature(var_155_5.angles:checkbox("Fakelag"), function()
					return {
						mode = var_155_5.angles:combobox("\nflmode", {
							"Dynamic",
							"Maximum",
							"Fluctuate"
						}),
						limit = var_155_5.angles:slider("\nflLimit", 1, 15, 14, true, "t")
					}, true
				end)
			},
			state = {
				var_155_4.header(var_155_5.angles, "States builder"),
				selector = var_155_5.angles:combobox("\nstateselector", table.distribute(var_0_108.states, 2), nil, false),
				var_155_4.header(var_155_5.angles)
			},
			builder = {},
			def = {
				var_155_4.header(var_155_5.other, "General"),
				snap = var_155_4.feature(var_155_5.other:checkbox("\f<insecure>Defensive AA", 0), function()
					return {
						os = var_155_5.other:checkbox("\f<p>Allow with On shot AA")
					}, true
				end),
				var_155_4.space(var_155_5.other),
				var_155_4.header(var_155_5.other, "Misc"),
				triggers = var_155_5.other:multiselect("LC break triggers", {
					"Jumping",
					"Crouching",
					"Weapon change"
				}),
				setup = {
					var_155_4.header(var_155_5.angles, "Defensive setup"),
					selector = var_155_5.angles:combobox("\nstateselector", table.distribute(var_0_108.snaps, 2), nil, false),
					var_155_4.header(var_155_5.angles)
				}
			},
			snaps = {}
		},
		drag = var_0_105.data
	}

	local function var_155_6(arg_175_0, arg_175_1)
		arg_175_1:set_callback(function(arg_176_0)
			table.place(var_0_110.builder.custom, arg_175_0, arg_176_0.value)
		end, true)

		return arg_175_1
	end

	local var_155_7 = {
		delay = {
			[1] = "Off"
		}
	}

	for iter_155_0, iter_155_1 in var_0_9(var_0_108.states) do
		local var_155_8 = iter_155_1[1]
		local var_155_9 = iter_155_1[2]
		local var_155_10 = iter_155_1[3]

		var_0_127.antiaim.builder[var_155_8], var_0_44.macros.z = {}, "\n" .. var_155_10

		local var_155_11 = var_0_127.antiaim.builder[var_155_8]
		local var_155_12 = var_155_5.angles

		if not (var_155_8 == "default") then
			var_155_11.override = var_155_6({
				var_155_8,
				"override"
			}, var_155_12:checkbox("Override \v" .. string.lower(var_155_9)))
			var_155_11[#var_155_11 + 1] = var_155_12:label("\n")
		end

		var_155_11[#var_155_11 + 1] = var_155_12:label("\vYaw")
		var_155_11.off = var_155_6({
			var_155_8,
			"off"
		}, var_155_12:slider("Offset\f<z>", -60, 60, 0, true, "°"))
		var_155_11.add = var_155_4.feature(var_155_6({
			var_155_8,
			"add",
			"on"
		}, var_155_12:checkbox("Add yaw left / right\f<z>")), function(arg_177_0)
			return {
				l = var_155_6({
					var_155_8,
					"add",
					"l"
				}, var_155_12:slider("\f<z>addyawl", -60, 60, 0, true, "°")),
				r = var_155_6({
					var_155_8,
					"add",
					"r"
				}, var_155_12:slider("\f<z>addyawr", -60, 60, 0, true, "°"))
			}, true
		end)
		var_155_11.mod = var_155_4.feature(var_155_6({
			var_155_8,
			"mod",
			"type"
		}, var_155_12:combobox("Modifier\f<z>", {
			"Off",
			"Jitter",
			"Ways",
			"Skitter",
			"Rotate",
			"Random"
		})), function(arg_178_0)
			return {
				ways = var_155_6({
					var_155_8,
					"mod",
					"ways"
				}, var_155_12:slider("\f<p>Ways\f<z>", 3, 7, 3)):depend({
					arg_178_0,
					"Ways",
					"Skitter"
				}),
				deg = var_155_6({
					var_155_8,
					"mod",
					"deg"
				}, var_155_12:slider("\f<p>Degree\f<z>", 0, 60, 0, true, "°"))
			}, function(arg_179_0)
				return arg_179_0.value ~= "Off"
			end
		end)
		var_155_11[#var_155_11 + 1] = var_155_12:label("\n")
		var_155_11[#var_155_11 + 1] = var_155_12:label("\vBody yaw")
		var_155_11.des = var_155_4.feature(var_155_6({
			var_155_8,
			"des",
			"on"
		}, var_155_12:checkbox("Desync\f<z>")), function()
			return {
				j = var_155_6({
					var_155_8,
					"des",
					"j"
				}, var_155_12:checkbox("\f<p>Jitter\f<z>des")),
				l = var_155_6({
					var_155_8,
					"des",
					"l"
				}, var_155_12:slider("\f<p>Left / right\f<z>des", 0, 60, 60, true, "°")):depend({
					var_0_127.antiaim.general.mode,
					"hysteria"
				}),
				r = var_155_6({
					var_155_8,
					"des",
					"r"
				}, var_155_12:slider("\ndesright\f<z>", 0, 60, 60, true, "°")):depend({
					var_0_127.antiaim.general.mode,
					"hysteria"
				})
			}, true
		end)
		var_155_11.delay = var_155_6({
			var_155_8,
			"delay"
		}, var_155_12:slider("Delay\f<z>", 1, 16, 0, true, "t", 1, var_155_7.delay))

		var_0_44.traverse(var_155_11, function(arg_181_0, arg_181_1)
			arg_181_0:depend({
				var_0_127.antiaim.state.selector,
				var_155_9
			}, arg_181_1[1] ~= "override" and var_155_11.override or nil)
		end)
	end

	local function var_155_13(arg_182_0, arg_182_1)
		arg_182_1:set_callback(function(arg_183_0)
			table.place(var_0_110.snap.custom, arg_182_0, arg_183_0.value)
		end, true)

		return arg_182_1
	end

	local var_155_14 = {
		delay = {
			[0] = "Off"
		},
		duration = {
			[13] = "Max"
		},
		pitch = {
			[0] = "Zero",
			[89] = "Down",
			[-89] = "Up"
		}
	}

	for iter_155_2, iter_155_3 in var_0_9(var_0_108.snaps) do
		local var_155_15 = iter_155_3[1]
		local var_155_16 = iter_155_3[2]

		var_0_127.antiaim.snaps[var_155_15], var_0_44.macros.z = {}, "\nS" .. iter_155_3[3]

		local var_155_17 = var_0_127.antiaim.snaps[var_155_15]
		local var_155_18 = var_155_5.angles
		local var_155_19 = var_155_15 == "default"

		var_155_17.on = var_155_13({
			var_155_15,
			"on"
		}, var_155_18:combobox("\f<z>", var_155_19 and {
			"Off",
			"Custom"
		} or {
			"Default",
			"Off",
			"Custom"
		}))
		var_155_17[#var_155_17 + 1] = var_155_4.space(var_155_18)
		var_155_17.pitch = var_155_4.feature(var_155_13({
			var_155_15,
			"x",
			"on"
		}, var_155_18:checkbox("\vPitch\f<z>")), function()
			local var_184_0 = var_155_13({
				var_155_15,
				"x",
				"mode"
			}, var_155_18:combobox("\f<p>Mode\f<z>x", {
				"Static",
				"Jitter",
				"Random",
				"Random Static",
				"Spin",
				"Camera",
				"At target"
			}))

			return {
				mode = var_184_0,
				ang = var_155_13({
					var_155_15,
					"x",
					"ang"
				}, var_155_18:slider("\f<p>Angle\f<z>x", -89, 89, -89, true, "°", 1, var_155_14.pitch)):depend({
					var_184_0,
					"Static",
					"Jitter",
					"Random",
					"Random Static",
					"Spin",
					"Camera",
					"At target"
				}),
				ang2 = var_155_13({
					var_155_15,
					"x",
					"ang2"
				}, var_155_18:slider("\f<p>Angle 2\f<z>x", -89, 89, -89, true, "°", 1, var_155_14.pitch)):depend({
					var_184_0,
					"Jitter",
					"Random",
					"Random Static",
					"Spin"
				}),
				speed = var_155_13({
					var_155_15,
					"x",
					"speed"
				}, var_155_18:slider("\f<p>Speed\f<z>x", -50, 50, 20, true, "", 0.1)):depend({
					var_184_0,
					"Spin"
				})
			}, true
		end)
		var_155_17[#var_155_17 + 1] = var_155_4.space(var_155_18)
		var_155_17.yaw = var_155_4.feature(var_155_13({
			var_155_15,
			"y",
			"on"
		}, var_155_18:checkbox("\vYaw\f<z>")), function()
			local var_185_0 = var_155_13({
				var_155_15,
				"y",
				"mode"
			}, var_155_18:combobox("\f<p>Mode\f<z>y", {
				"Static",
				"Jitter",
				"Random",
				"Random Jitter",
				"Random Static",
				"Spin",
				"Spin Jitter",
				"90w",
				"180v",
				"Camera",
				"At target",
				"Opposite"
			}))

			return {
				mode = var_185_0,
				ang = var_155_13({
					var_155_15,
					"y",
					"ang"
				}, var_155_18:slider("\f<p>Angle\f<z>y", 0, 360, 180, true, "°")):depend({
					var_185_0,
					"Static",
					"Jitter",
					"Random",
					"Random Jitter",
					"Random Static",
					"Spin",
					"Spin Jitter",
					"90w",
					"180v",
					"Camera",
					"At target"
				}),
				delay = var_155_13({
					var_155_15,
					"y",
					"delay"
				}, var_155_18:slider("\f<p>Delay\f<z>y", 0, 14, 0, true, "t", 1, var_155_14.delay)):depend({
					var_185_0,
					"Jitter",
					"Spin Jitter"
				}),
				speed = var_155_13({
					var_155_15,
					"y",
					"speed"
				}, var_155_18:slider("\f<p>Speed\f<z>y", -50, 50, 20, true, "", 0.1)):depend({
					var_185_0,
					"Spin",
					"Spin Jitter",
					"90w",
					"180v"
				})
			}, true
		end)
		var_155_17[#var_155_17 + 1] = var_155_4.space(var_155_18)
		var_155_17[#var_155_17 + 1] = var_155_18:label("\vMisc")
		var_155_17.time = var_155_13({
			var_155_15,
			"time"
		}, var_155_18:slider("Duration\f<z>", 1, 13, 13, true, "t", 1, var_155_14.duration))
		var_155_17.sd = var_155_13({
			var_155_15,
			"sd"
		}, var_155_18:checkbox("Control desync side\f<z>"))

		var_0_44.traverse(var_155_17, function(arg_186_0, arg_186_1)
			arg_186_0:depend({
				var_0_127.antiaim.def.setup.selector,
				var_155_16
			}, {
				var_0_127.antiaim.def.snap.on,
				true
			}, arg_186_1[1] ~= "on" and {
				var_155_17.on,
				"Custom"
			} or nil)
		end)
	end

	var_0_44.traverse(var_0_127.antiaim.def.setup, function(arg_187_0, arg_187_1)
		arg_187_0:depend({
			var_0_127.antiaim.def.snap.on,
			true
		})
	end)

	var_0_44.macros.z = nil

	var_0_44.traverse(var_0_107.aa, function(arg_188_0)
		arg_188_0:set_visible(false)
	end)
	var_0_107.aa.angles.yaw[2]:depend({
		var_0_107.aa.angles.yaw[1],
		1
	})
	var_0_107.aa.angles.pitch[2]:depend({
		var_0_107.aa.angles.pitch[1],
		1
	})
	var_0_107.aa.angles.jitter[1]:depend({
		var_0_107.aa.angles.yaw[1],
		1
	})
	var_0_107.aa.angles.jitter[2]:depend({
		var_0_107.aa.angles.jitter[1],
		1
	})
	var_0_107.aa.angles.body[2]:depend({
		var_0_107.aa.angles.body[1],
		1
	})
	var_0_107.aa.angles.fs_body:depend({
		var_0_107.aa.angles.body[1],
		1
	})

	for iter_155_4, iter_155_5 in var_0_11, var_0_107.aa.other do
		if iter_155_4 ~= "legs" then
			iter_155_5:depend({
				var_0_128.selector,
				"Settings"
			})

			if iter_155_5.hotkey then
				iter_155_5.hotkey:depend({
					var_0_128.selector,
					"Settings"
				})
			end
		end
	end

	var_0_78.shutdown:set(function()
		var_0_44.traverse(var_0_107.aa, function(arg_190_0)
			arg_190_0:set_visible(true)
		end)
	end)

	local var_155_20

	var_0_44.traverse(var_0_128.home, function(arg_191_0)
		arg_191_0:depend({
			var_0_128.selector,
			"Home"
		})
	end)
	var_0_44.traverse(var_0_128.servers, function(arg_192_0)
		arg_192_0:depend({
			var_0_128.selector,
			"Servers"
		})
	end)

	local var_155_21 = {
		"Features",
		"Features",
		"Visual"
	}

	for iter_155_6, iter_155_7 in var_0_11, var_0_128.settings do
		iter_155_7:depend({
			var_0_128.selector,
			"Settings"
		})
	end

	var_0_44.traverse({
		var_0_127.misc,
		var_0_127.rage,
		var_0_127.visuals
	}, function(arg_193_0, arg_193_1)
		arg_193_0:depend({
			var_0_128.selector,
			"Settings"
		}, {
			var_0_128.settings.tab,
			var_155_21[arg_193_1[1]]
		})
	end)

	var_155_21 = {
		def = "Defensive",
		general = "General",
		state = "Builder",
		snaps = "Defensive",
		builder = "Builder"
	}

	var_0_44.traverse(var_0_127.antiaim, function(arg_194_0, arg_194_1)
		local var_194_0 = var_155_21[arg_194_1[1]]

		arg_194_0:depend({
			var_0_128.selector,
			"Anti-aim"
		}, arg_194_1[1] ~= "on" and {
			var_0_127.antiaim.on,
			true
		} or nil, var_194_0 and {
			var_0_127.antiaim.tab,
			var_194_0
		})
	end)

	var_155_21 = nil

	var_0_127.visuals.accent:set_callback(function(arg_195_0)
		local var_195_0, var_195_1, var_195_2 = var_0_25(arg_195_0.value)
		local var_195_3 = var_0_79.rgb(var_195_0, var_195_1, var_195_2, 255)

		var_0_78.accent_recolor:fire(var_195_3, var_0_91.hexs, var_0_91.hex)

		var_0_91.accent = var_195_3
		var_0_91.hexs = string.format("\a%02X%02X%02X", var_195_0, var_195_1, var_195_2)
		var_0_91.hex = var_0_91.hexs .. "FF"
	end, true)
	var_0_127.visuals.dpi:set_callback(function(arg_196_0)
		var_0_99.dpi_t.scalable = arg_196_0.value

		var_0_99.dpi_t.callback()
	end, true)

	local color2 = {}

	for iter_155_8 in string.gmatch("hysteria", ".[\x80-\xBF]*") do
		color2[#color2 + 1] = {
			n = 0,
			d = false,
			w = iter_155_8,
			p = {
				0
			}
		}
	end

	local var_155_23 = false

	var_0_78.paint_ui:set(function()
		if not var_0_44.menu_open then
			if var_155_23 then
				collectgarbage()

				var_155_23 = false
			end

			return
		end

		var_155_23 = true

		if globals.frametime() % 2 == 0 then
			return
		end

		local time = globals.realtime()
		local color = {}
		local accent = var_0_79(var_0_25(var_0_107.misc.settings.accent.value))
		local gray = var_0_79.rgb(205, 205, 205, 80)

		for iter_197_0 = 1, #color2 do
			local var_197_4 = color2[iter_197_0]

			if time >= var_197_4.n then
				var_197_4.d = not var_197_4.d
				var_197_4.n = time + client.random_float(1, 3)
			end

			local var_197_5 = var_0_100.condition(var_197_4.p, var_197_4.d, -1)
			local var_197_6 = gray:lerp(accent, math.min(var_197_5 + 0.5, 1))

			color[#color + 1] = string.format("\a%02x%02x%02x%02x%s", var_197_6.r, var_197_6.g, var_197_6.b, 200 * var_197_5 + 55, var_197_4.w)

		end
		
		if var_0_67 > 1 then
			color[#color + 1] = string.format("\f<silent> — %s", var_0_65.build)
		end

		var_0_128.title:set(table.concat(color))
	end)
end)()

local var_0_129

LPH_NO_VIRTUALIZE(function()
	var_0_129 = {
		default = "hysteria::GS::KG15IHByZXNldClbYWRtaW5de4WkZHJhZ4ioc3BlY2xpc3SCoXnNE4iheM0LZKZhcnJvd3OCoXnNE2KheM0Sfqljcm9zc2hhaXKCoXnNFLCheM0TC6hzbG93ZG93boKhec0NvqF4zRJPp2tleWxpc3SCoXnNE4iheM0LZKZkYW1hZ2WCoXnNE62heM0TnKl3YXRlcm1hcmuDoXnMuaF4zSa2oWECpGxvZ3OCoXnNHBGheM0Qeqd2aXN1YWxzjKNkcGnCpWNoZWFww6Zhc3BlY3SCpXJhdGlvzIWib27Cpm1hcmtlcsOoc3BlY2xpc3TCpmFycm93c8Ona2V5bGlzdMKoc2xvd2Rvd27DpmFjY2VudKkjNzRBNkE5RkamZGFtYWdlw6V3YXRlcoOkaGlkZcKkbmFtZaCib27DqWNyb3NzaGFpcoOkbG9nb8Olc3R5bGWnQ2xhc3NpY6JvbsOkbWlzY4WmZmlsdGVyw6ZsYWRkZXLCp2NsYW50YWfCp2JyZWFrZXKEpHNsaWHCpXBpdGNowqJvbsKkbGVnc6ROb25lpGxvZ3ODpmV2ZW50c5WtUmFnZWJvdCBzaG90c69IYXJtaW5nIGVuZW1pZXOuR2V0dGluZyBoYXJtZWStQW50aS1haW0gaW5mb6Fz113Zpm91dHB1dJOnQ29uc29sZaZTY3JlZW6hfqJvbsOnYW50aWFpbYWnYnVpbGRlcomlc25lYWuGo2Rlc4ShcjyhasKhbDyib27Co21vZIOjZGVnAKR3YXlzA6JvbqNPZmajb2ZmAKVkZWxheQGjYWRkg6FyAKFsAKJvbsKob3ZlcnJpZGXCp2Zha2VsYWeGo2Rlc4ShcjyhasKhbDyib27Co21vZIOjZGVnAKR3YXlzA6JvbqNPZmajb2ZmAKVkZWxheQGjYWRkg6FyAKFsAKJvbsKob3ZlcnJpZGXCpHdhbGuGo2Rlc4Shch6hasOhbB6ib27Do21vZIOjZGVnDqR3YXlzA6JvbqZSYW5kb22jb2ZmAKVkZWxheQijYWRkg6FyGaFs5KJvbsOob3ZlcnJpZGXDo2FpcoajZGVzhKFyHqFqw6FsHqJvbsOjbW9kg6NkZWcdpHdheXMDom9upkppdHRlcqNvZmYHpWRlbGF5AqNhZGSDoXIAoWwAom9uwqhvdmVycmlkZcOkYWlyY4ajZGVzhKFyPKFqw6FsPKJvbsOjbW9kg6NkZWchpHdheXMDom9upkppdHRlcqNvZmYHpWRlbGF5AaNhZGSDoXIooWznom9uwqhvdmVycmlkZcOlc3RhbmSGo2Rlc4ShcjyhasOhbDyib27Do21vZIOjZGVnAKR3YXlzA6JvbqNPZmajb2ZmAKVkZWxheQGjYWRkg6FyAKFsAKJvbsKob3ZlcnJpZGXDpmNyb3VjaIajZGVzhKFyPKFqwqFsPKJvbsKjbW9kg6NkZWcApHdheXMDom9uo09mZqNvZmYApWRlbGF5AaNhZGSDoXIAoWwAom9uwqhvdmVycmlkZcKjcnVuhqNkZXOEoXI8oWrDoWw8om9uw6Ntb2SDo2RlZyGkd2F5cwOib26mSml0dGVyo29mZgalZGVsYXkBo2FkZIOhcgChbACib27CqG92ZXJyaWRlw6dkZWZhdWx0haNkZXOEoXIeoWrDoWweom9uw6Ntb2SDo2RlZx2kd2F5cwOib26mSml0dGVyo29mZgelZGVsYXkCo2FkZIOhcgChbACib27CpXNuYXBzhqRwZWVrhaVwaXRjaIWkYW5nMtCno2FuZ9Cnom9uwqRtb2RlplN0YXRpY6VzcGVlZBSkdGltZQ2ic2TCom9upkN1c3RvbaN5YXeFpWRlbGF5AKNhbmfMtKJvbsKkbW9kZaM5MHelc3BlZWQUo2FpcoWlcGl0Y2iFpGFuZzIAo2FuZ9Cnom9uw6Rtb2RlrVJhbmRvbSBTdGF0aWOlc3BlZWQUpHRpbWUNonNkwqJvbqZDdXN0b22jeWF3haVkZWxheQCjYW5nzPCib27DpG1vZGWtUmFuZG9tIFN0YXRpY6VzcGVlZAqkYWlyY4WlcGl0Y2iFpGFuZzIto2FuZwCib27DpG1vZGWmU3RhdGljpXNwZWVkFKR0aW1lDaJzZMKib26mQ3VzdG9to3lhd4WlZGVsYXkAo2FuZ80BaKJvbsOkbW9kZaRTcGlupXNwZWVkCqZjcm91Y2iFpXBpdGNohaRhbmcy0KejYW5n0Keib27DpG1vZGWmU3RhdGljpXNwZWVkFKR0aW1lDaJzZMOib26mQ3VzdG9to3lhd4WlZGVsYXkAo2FuZ8y0om9uw6Rtb2RlplN0YXRpY6VzcGVlZBSlc25lYWuFpXBpdGNohaRhbmcy0KejYW5n0Keib27CpG1vZGWmU3RhdGljpXNwZWVkFKR0aW1lDaJzZMKib26nRGVmYXVsdKN5YXeFpWRlbGF5AKNhbmfMtKJvbsKkbW9kZaZTdGF0aWOlc3BlZWQUp2RlZmF1bHSFpXBpdGNohaRhbmcy0KejYW5n0Keib27CpG1vZGWmU3RhdGljpXNwZWVkFKR0aW1lDaJzZMKib26mQ3VzdG9to3lhd4WlZGVsYXkAo2FuZ8y0om9uwqRtb2RlplN0YXRpY6VzcGVlZBSnZ2VuZXJhbIqjdXNlw6ZpbnZlcnSTAQChfqJmbIOlbGltaXQOpG1vZGWnRHluYW1pY6JvbsOkaGVhZIGib27Dpm1hbnVhbIWlcmlnaHSTAQChfqRsZWZ0kwEAoX6lcmVzZXSTAQChfqJvbsKmc3RhdGljwqRlZGdlkwEAoX6lam1vdmXDomZzg6Rvbl9okwEAoX6ib27CpnN0YXRpY8Kkc3RhYsOoaW1wbGljaXTCom9uw6NkZWaCpHNuYXCDom9zwqRvbl9okwAAoX6ib27DqHRyaWdnZXJzlKdKdW1waW5nqUNyb3VjaGluZ61XZWFwb24gY2hhbmdloX6kcmFnZYWocmVjaGFyZ2XDqGV4c3dpdGNogqVhbGxvd5GhfqJvbsKodGVsZXBvcnSEpG9uX2iTAQChfqZwaXN0b2zCom9uwqRsYW5kwqdwZWVrZml4wqhyZXNvbHZlcsJ9",
		name = "",
		selected = 0,
		badge = var_0_44.format("\v•\r "),
		list = {}
	}

	local var_198_0 = var_0_128.home.config

	var_198_0.save:depend(true, {
		var_198_0.list,
		0,
		true
	})
	var_198_0.export:depend(true, {
		var_198_0.list,
		0,
		true
	})
	var_198_0.delete:depend({
		var_198_0.list,
		0,
		true
	})
	var_198_0.deleteb:depend({
		var_198_0.list,
		0
	})
	var_198_0.deleteb:depend(true, {
		var_198_0.list,
		0,
		true
	})

	local var_198_1 = {
		eval = function(arg_199_0, arg_199_1)
			if not arg_199_0 then
				return "\fConfig not found."
			end

			local var_199_0, var_199_1, var_199_2 = string.match(arg_199_0, "^hysteria::(%a+)::([%w%+%/]+)(_*)")

			if var_199_0 ~= "GS" then
				return "\fNot for gamesense"
			end

			local var_199_3

			var_199_3 = var_199_2 and string.rep("=", #var_199_2) or ""

			local var_199_4 = string.gsub(var_199_1, "z%d%d%dZ", {
				z113Z = "+",
				z143Z = "/"
			})
			local var_199_5 = var_0_47.decode(var_199_4 .. var_199_3)
			local var_199_6, var_199_7, var_199_8 = string.match(var_199_5, "^%((.*)%)%[(.*)%]%{(.+)%}")

			return var_199_6, var_199_7, arg_199_1 ~= true and var_199_8 ~= nil and var_0_48.unpack(var_199_8) or {}
		end
	}

	function var_198_1.save(arg_200_0, arg_200_1)
		if arg_200_0 == "Default" then
			return "\fCan't overwrite Default"
		end

		arg_200_0 = var_0_21(arg_200_0)

		local var_200_0
		local var_200_1

		if arg_200_1 == true then
			local var_200_2

			var_200_2, var_200_1 = var_198_1.eval(var_0_88.configs[arg_200_0], true)
		end

		local var_200_3 = var_0_129.system:save()
		local var_200_4 = string.format("(%s)[%s]{%s}", arg_200_0, var_200_1 or var_0_65.user, var_0_48.pack(var_200_3))
		local var_200_5 = string.gsub(var_0_47.encode(var_200_4), "[%+%/%=]", {
			["="] = "_",
			["/"] = "z143Z",
			["+"] = "z113Z"
		})
		local var_200_6 = string.format("hysteria::GS::%s", var_200_5)

		var_0_88.configs[arg_200_0] = var_200_6

		return "\a" .. arg_200_0 .. " saved"
	end

	function var_198_1.create(arg_201_0)
		if arg_201_0 == "" then
			return "\fEnter the name"
		elseif arg_201_0 == "Default" then
			return "\fCan't overwrite Default"
		elseif #arg_201_0 > 24 then
			return "\fThis name is too long"
		elseif var_0_88.configs[arg_201_0] then
			return "\f" .. arg_201_0 .. " is in the list"
		end

		return var_198_1.save(arg_201_0, true)
	end

	function var_198_1.delete(arg_202_0)
		var_0_88.configs[arg_202_0] = nil
	end

	function var_198_1.export(arg_203_0)
		if not arg_203_0 or arg_203_0 == "" then
			return "\fNot selected"
		end

		var_0_85.set(var_0_88.configs[arg_203_0])

		return "\aCopied to clipboard."
	end

	function var_198_1.import()
		local var_204_0 = var_0_85.get()

		if not var_204_0 then
			return "\fEmpty clipboard"
		end

		local var_204_1, var_204_2, var_204_3 = var_198_1.eval(var_204_0, true)

		if not var_204_2 then
			return var_204_1
		end

		local var_204_4 = var_204_0:match("^hysteria::%a+::[%w%+%/]+_*")

		if var_204_1 == "Default" then
			return "\fCan't import default config"
		end

		var_0_88.configs[var_204_1] = var_204_4

		return "\a" .. var_204_1 .. " by " .. var_204_2 .. " added"
	end

	function var_198_1.load(arg_205_0, ...)
		if not arg_205_0 or arg_205_0 == "" then
			return "ERR: can't load: not selected"
		end

		local var_205_0 = arg_205_0 == "Default" and var_0_129.default or var_0_88.configs[arg_205_0]
		local var_205_1, var_205_2, var_205_3 = var_198_1.eval(var_205_0)

		if not var_205_2 or not var_205_3 then
			return var_205_1
		end

		if ({
			...
		})[1] == "antiaim" then
			var_205_3.antiaim.general.manual = nil
			var_205_3.antiaim.general.edge = nil
			var_205_3.antiaim.general.fs.on_h = nil
		end

		var_0_129.system:load(var_205_3, ...)

		if ... then
			return
		end

		var_0_129.loaded = arg_205_0
	end

	local var_198_2

	local var_198_3 = 0
	local var_198_4 = false

	local function var_198_5()
		if var_198_3 < globals.realtime() then
			var_198_0.list_report:set_visible(false)
			var_198_0.selected:set_visible(true)
			var_0_78.paint_ui:unset(var_198_5)

			var_198_4 = false
		end
	end

	local function var_198_6(arg_207_0)
		if not arg_207_0 then
			return
		end

		var_198_3 = globals.realtime() + 1

		local var_207_0 = arg_207_0:gsub("[\f\a]", {
			["\f"] = "\aFF4040FF",
			["\a"] = "\aB6DE47FF"
		})

		var_198_0.list_report:set(var_207_0)

		if not var_198_4 then
			var_198_0.list_report:set_visible(true)
			var_198_0.selected:set_visible(false)
			var_0_78.paint_ui:set(var_198_5)

			var_198_4 = true
		end
	end

	local function var_198_7(arg_208_0)
		if arg_208_0 ~= true then
			var_0_129.list = {}

			for iter_208_0 in var_0_11, var_0_88.configs do
				var_0_129.list[#var_0_129.list + 1] = iter_208_0
			end

			table.sort(var_0_129.list)
			table.insert(var_0_129.list, 1, "Default")

			local var_208_0 = table.find(var_0_129.list, var_0_129.loaded)

			if var_208_0 then
				var_0_129.list[var_208_0] = var_0_129.badge .. var_0_129.list[var_208_0]
			else
				var_0_129.loaded = 0
			end

			var_198_0.list:update(var_0_129.list)
		end

		var_0_129.selected = var_198_0.list.value + 1
		var_0_129.name = string.gsub(var_0_129.list[var_0_129.selected] or "", "^\a%x%x%x%x%x%x%x%x•\a%x%x%x%x%x%x%x%x ", "")

		var_198_0.selected:set(var_0_44.format("Selected: \v") .. var_0_129.name)
		var_198_0.list:set(var_0_129.selected - 1)
	end

	local function var_198_8(arg_209_0, ...)
		local var_209_0, var_209_1, var_209_2, var_209_3 = var_0_26(var_198_1[arg_209_0], ...)

		var_0_58(arg_209_0, ": ", var_209_0, ", ", var_209_1, ", ", var_209_2, ", ", var_209_3)
		var_198_6(var_209_2 or var_209_1)
		var_198_7()
	end

	var_198_7()
	var_198_0.list:set_callback(function()
		var_198_7(true)
	end)
	var_198_0.create:set_callback(function()
		var_198_8("create", var_198_0.name:get())
	end)
	var_198_0.import:set_callback(function()
		var_198_8("import", var_198_0.name:get())
	end)
	var_198_0.load:set_callback(function()
		var_198_8("load", var_0_129.name)
	end)
	var_198_0.loadaa:set_callback(function()
		var_198_8("load", var_0_129.name, "antiaim")
	end)
	var_198_0.save:set_callback(function()
		var_198_8("save", var_0_129.name)
	end)
	var_198_0.delete:set_callback(function()
		var_198_8("delete", var_0_129.name)
	end)
	var_198_0.export:set_callback(function()
		var_198_8("export", var_0_129.name)
	end)
end)()

local var_0_130 = var_0_65.user
local var_0_131 = var_0_68 and "skeet-bliss" or "skeet"

local function var_0_132(arg_218_0)
	local var_218_0 = {}
	local var_218_1 = {
		string.byte(arg_218_0, 1, #arg_218_0)
	}

	for iter_218_0, iter_218_1 in var_0_9(var_218_1) do
		var_218_0[iter_218_0] = string.format("%x", iter_218_1)
	end

	local var_218_2 = string.gsub(table.concat(var_218_0), "[64]", {
		["6"] = "a7",
		["4"] = "9r"
	})

	while #var_218_2 < 16 do
		var_218_2 = var_218_2 .. var_218_2
	end

	return string.sub(var_218_2, 1, 16)
end

ui.set_callback(var_0_128.home.verify.auth.ref, function()
	var_0_128.home.verify.auth:set_enabled(false)

	local var_219_0 = var_0_132(var_0_130 .. var_0_131)

	var_0_45.get("https://backend.hysteria.one/keygen", {
		headers = {
			["hst-uname"] = var_0_130,
			["hst-cheat"] = var_0_131,
			UserAgent = "ltcp_debug" .. ".." .. "|" .. ".." .. var_219_0
		}
	}, function(arg_220_0, arg_220_1)
		var_0_58(arg_220_0, ": ", arg_220_1 and arg_220_1.body)

		if not arg_220_0 then
			var_0_57("Something went wrong. Try again later.")

			return
		end

		local var_220_0, var_220_1 = var_0_26(json.parse, arg_220_1.body)

		if not var_220_0 then
			var_0_57("Something went wrong. Try again later.")

			return
		end

		if var_220_1.is_connected == "yes" then
			var_0_85.set("You have already linked your discord")
			var_0_57("You have already linked your discord")
		else
			var_0_85.set(var_220_1.status)
		end
	end)
end)

local var_0_133

LPH_JIT_MAX(function()
	local var_221_0
	local var_221_1 = {}
	local var_221_2 = {
		counter = 0,
		send_packet = false,
		sent = 0,
		state = 1,
		switch = false
	}
	local var_221_3 = {
		yaw = 0,
		pitch = 89,
		mod = 0,
		des = 0
	}
	local var_221_4 = {}
	local var_221_5 = {
		pitch = var_0_107.aa.angles.pitch[2],
		base = var_0_107.aa.angles.base,
		yaw = var_0_107.aa.angles.yaw[2],
		body = var_0_107.aa.angles.body[2],
		pitch_mode = var_0_107.aa.angles.pitch[1],
		yaw_mode = var_0_107.aa.angles.yaw[1],
		jitter_mode = var_0_107.aa.angles.jitter[1],
		jitter = var_0_107.aa.angles.jitter[2],
		body_mode = var_0_107.aa.angles.body[1]
	}
	local var_221_6

	local function var_221_7()
		if var_0_113.on_ground then
			if var_0_113.duck_amount > 0 then
				return var_0_113.velocity > 5 and var_0_109.states.sneak or var_0_109.states.crouch
			end

			if var_0_113.velocity > 5 then
				return var_221_0.in_speed == 1 and var_0_109.states.walk or var_0_109.states.run
			end

			return var_0_109.states.stand
		else
			return var_0_113.duck_amount > 0 and var_0_109.states.airc or var_0_109.states.air
		end
	end

	local function var_221_8()
		local var_223_0
		local var_223_1 = 0
		local var_223_2 = var_221_2.state

		if var_223_1 == 0 then
			var_223_0 = var_0_110.builder.custom
		else
			var_223_0 = var_0_110.builder[var_223_1]
		end

		if var_223_0.fakelag.override and var_0_113.exploit.active == var_0_109.exploit.OFF then
			var_223_2 = var_0_109.states.fakelag
		elseif not var_223_0.airc.override and var_223_2 == var_0_109.states.airc then
			var_223_2 = var_0_109.states.air
		elseif not var_223_0.sneak.override and var_223_2 == var_0_109.states.sneak then
			var_223_2 = var_0_109.states.crouch
		end

		var_223_2 = var_223_0[var_0_108.states[var_223_2][1]].override and var_223_2 or var_0_109.states.default
		var_221_1 = {
			[0] = var_223_0,
			cur = var_223_0[var_0_108.states[var_223_2][1]]
		}
	end

	local function var_221_9()
		var_221_1.snap = nil

		if not ui.is_active(var_0_127.antiaim.def.snap.on) then
			return
		end

		if var_0_113.exploit.active == var_0_109.exploit.OS and not var_0_127.antiaim.def.snap.os.value then
			return
		end

		local var_224_0
		local var_224_1 = 0
		local var_224_2 = var_0_109.snaps.default

		if var_224_1 == 0 then
			var_224_0 = var_0_110.snap.custom
		else
			var_224_0 = var_0_110.snap[var_224_1]
		end

		if var_224_0.airc.on ~= "Default" and var_0_113.jumping and var_0_113.crouching then
			var_224_2 = var_0_109.snaps.airc
		elseif var_224_0.air.on ~= "Default" and var_0_113.jumping then
			var_224_2 = var_0_109.snaps.air
		elseif var_224_0.sneak.on ~= "Default" and var_0_113.on_ground and var_0_113.crouching and var_0_113.velocity > 5 then
			var_224_2 = var_0_109.snaps.sneak
		elseif var_224_0.crouch.on ~= "Default" and var_0_113.on_ground and var_0_113.crouching then
			var_224_2 = var_0_109.snaps.crouch
		elseif var_224_0.peek.on ~= "Default" and var_0_113.on_ground and var_0_113.peeking then
			var_224_2 = var_0_109.snaps.peek
		end

		local var_224_3 = var_224_0[var_0_108.snaps[var_224_2][1]]

		if var_224_3.on == "Off" then
			return
		end

		var_224_2 = var_224_3.on == "Custom" and var_224_2 or var_0_109.snaps.default

		local var_224_4 = var_224_0[var_0_108.snaps[var_224_2][1]]

		if var_224_4 and var_224_4.on ~= "Off" then
			var_221_1.snap = var_224_4
		end
	end

	local var_221_10 = 0
	local var_221_11 = 0

	var_0_78.player_hurt:set(function(arg_225_0)
		if client.userid_to_entindex(arg_225_0.userid) == var_0_113.self then
			var_221_11 = globals.tickcount()
		end
	end)
	var_0_78.bullet_impact:set(function(arg_226_0)
		if not var_0_113.valid or var_221_10 == globals.tickcount() then
			return
		end

		local var_226_0 = client.userid_to_entindex(arg_226_0.userid)

		if not var_226_0 or not entity.is_enemy(var_226_0) or entity.is_dormant(var_226_0) then
			return
		end

		local var_226_1 = var_0_50(arg_226_0.x, arg_226_0.y, arg_226_0.z)
		local var_226_2 = var_0_50(entity.get_origin(var_226_0))

		var_226_2.z = var_226_2.z + 64

		local var_226_3 = {}

		for iter_226_0 = 1, #var_0_114 do
			local var_226_4 = var_0_114[iter_226_0]

			if not entity.is_enemy(var_226_4) then
				local var_226_5 = var_0_50(entity.hitbox_position(var_226_4, 0))
				local var_226_6 = math.closest_ray_point(var_226_5, var_226_2, var_226_1)

				var_226_3[var_226_4 == var_0_113.self and 0 or #var_226_3 + 1] = var_226_5:dist(var_226_6)
			end
		end

		if var_226_3[0] and (#var_226_3 == 0 or var_226_3[0] < math.min(var_0_25(var_226_3))) and var_226_3[0] < 80 then
			client.delay_call(var_0_23(1), function()
				var_0_78.enemy_shot:fire({
					damaged = var_221_10 == var_221_11,
					dist = var_226_3[0],
					attacker = var_226_0,
					userid = arg_226_0.userid
				})
			end)

			var_221_10 = globals.tickcount()
		end
	end)

	local function var_221_12()
		var_221_2.resort = var_0_127.antiaim.general.resort and var_0_127.antiaim.general.resort.value
		var_221_2.send_packet = var_221_0.chokedcommands == 0
		var_221_2.state = var_221_7()

		var_221_8()
		var_221_9()
	end

	local var_221_13
	local var_221_14 = {
		angles = {
			manual_buttons = {
				{
					"left",
					yaw = -90,
					item = var_0_127.antiaim.general.manual.left
				},
				{
					"right",
					yaw = 90,
					item = var_0_127.antiaim.general.manual.right
				},
				{
					"reset",
					item = var_0_127.antiaim.general.manual.reset
				}
			},
			manual = function(arg_229_0)
				if not var_0_127.antiaim.general.manual.on.value then
					return
				end

				for iter_229_0, iter_229_1 in var_0_9(arg_229_0.manual_buttons) do
					local var_229_0, var_229_1 = iter_229_1.item:get()

					if iter_229_1.active == nil then
						iter_229_1.active = var_229_0
					end

					if iter_229_1.active == var_229_0 then
						-- block empty
					else
						iter_229_1.active = var_229_0

						if iter_229_1.yaw == nil then
							arg_229_0.manual_current = nil
						end

						if var_229_1 == 1 then
							arg_229_0.manual_current = var_229_0 and iter_229_0 or nil
						elseif var_229_1 == 2 then
							arg_229_0.manual_current = arg_229_0.manual_current ~= iter_229_0 and iter_229_0 or nil
						end
					end
				end

				local var_229_2 = arg_229_0.manual_current ~= nil and arg_229_0.manual_buttons[arg_229_0.manual_current].yaw or nil

				return var_0_24(var_229_2) == "number" and var_229_2 or nil
			end,
			work = function(arg_230_0)
				local var_230_0 = 88.94
				local var_230_1 = 0

				var_221_2.camera_ang = {
					client.camera_angles()
				}

				local var_230_2 = var_221_2.camera_ang[2]

				if var_0_113.threat then
					local var_230_3 = var_0_50(entity.get_origin(var_0_113.threat))

					var_221_2.threat_ang = {
						math.angle_to(var_0_113.origin, var_230_3)
					}
					var_221_2.threat_dist = math.sqrt3((var_0_113.origin - var_230_3):unpack())
					var_230_2 = var_221_2.threat_ang[2]
				else
					var_221_2.threat_ang, var_221_2.threat_dist = nil
				end

				local var_230_4 = var_230_2 - 180
				local var_230_5 = arg_230_0:manual()
				local var_230_6 = var_0_127.antiaim.general.edge:get()
				local var_230_7 = not var_230_6 and not var_230_5 and ui.is_active(var_0_127.antiaim.general.fs.on)

				var_0_107.aa.angles.freestand:override(var_230_7)
				var_0_107.aa.angles.edge:override(var_230_6)

				if var_230_5 then
					var_230_4 = var_221_2.camera_ang[2] - var_230_5

					if var_0_127.antiaim.general.manual.static.value then
						local var_230_8 = 120

						var_221_4.no_modifier, var_221_4.force_desync = true, var_230_5 > 0 and -var_230_8 or var_230_8
					end
				end

				if var_230_6 then
					var_221_4.force_implicit = true
				elseif var_230_7 then
					var_221_4.force_implicit = true

					if var_0_127.antiaim.general.fs.static.value then
						var_221_4.no_modifier, var_221_4.force_desync = true, 120
					end
				end

				var_221_2.manual_yaw, var_221_2.edge_yaw, var_221_2.freestanding = var_230_5, var_230_6, var_230_7
				var_221_3.yaw, var_221_3.pitch = var_230_4, var_230_0
			end
		},
		modifier = {
			skitter_sequence = {
				-1,
				1,
				0,
				-1,
				1,
				0,
				-1,
				0,
				1,
				-1,
				0,
				1
			},
			Jitter = function(arg_231_0)
				return var_221_2.switch and arg_231_0.deg or -arg_231_0.deg
			end,
			Ways = function(arg_232_0)
				local var_232_0 = var_221_2.counter % arg_232_0.ways / (arg_232_0.ways - 1)

				return math.lerp(-arg_232_0.deg, arg_232_0.deg, side == -1 and 1 - var_232_0 or var_232_0)
			end,
			["Skitter Old"] = function(arg_233_0, arg_233_1)
				local var_233_0 = var_221_2.counter % (arg_233_0.ways * 2 - 2)

				if var_233_0 >= arg_233_0.ways then
					var_233_0 = arg_233_0.ways + 1 - var_233_0
				end

				local var_233_1 = var_233_0 / (arg_233_0.ways - 1)
				local var_233_2 = math.lerp(-arg_233_0.deg, arg_233_0.deg, var_233_0 < 0 and 1 + var_233_1 or var_233_1)

				if var_221_1.cur.des.on then
					local var_233_3 = math.lerp(-var_221_1.cur.des.r, var_221_1.cur.des.l, side == -1 and 1 - var_233_1 or var_233_1)

					var_221_4.force_desync = var_233_3
				end

				return var_233_2
			end,
			Skitter = function(arg_234_0, arg_234_1)
				local var_234_0 = math.cycle(var_221_2.counter, #arg_234_1.skitter_sequence)
				local var_234_1 = arg_234_1.skitter_sequence[var_234_0]
				local var_234_2 = var_234_1 * arg_234_0.deg
				local var_234_3 = var_221_1.cur.des

				if var_234_3.on and var_234_3.j then
					var_221_4.force_desync = var_234_1 > 0 and var_234_3.l or var_234_1 < 0 and -var_234_3.r or var_234_1 == 0 and 0
				end

				return var_234_2
			end,
			Rotate = function(arg_235_0)
				return math.lerp(-arg_235_0.deg, arg_235_0.deg, globals.curtime() * 4 % 1)
			end,
			Random = function(arg_236_0)
				return client.random_int(-arg_236_0.deg, arg_236_0.deg)
			end,
			work = function(arg_237_0)
				var_221_3.mod = 0

				local var_237_0 = var_221_1.cur.mod

				if var_237_0.type ~= "Off" then
					var_221_3.mod = arg_237_0[var_237_0.type](var_237_0, arg_237_0)
				end

				if not var_221_4.no_offset then
					var_221_3.mod = var_221_3.mod + var_221_1.cur.off
				end
			end
		},
		desync = {
			work = function(arg_238_0)
				var_221_3.des = nil

				local var_238_0 = var_221_1.cur.des

				if not var_238_0.on then
					return
				end

				if var_238_0.j then
					var_221_3.des = var_238_0.on and (var_221_2.switch and var_238_0.r or -var_238_0.l) or nil
				else
					var_221_3.des = var_238_0.on and (var_0_127.antiaim.general.invert:get() and var_238_0.r or -var_238_0.l) or nil
				end
			end
		},
		defensive = {
			urgent = false,
			ticks = 0,
			prev_des = 0,
			counter = 0,
			pitch = {
				Static = function(arg_239_0, arg_239_1)
					return arg_239_1.ang
				end,
				Jitter = function(arg_240_0, arg_240_1)
					return var_221_2.switch and arg_240_1.ang or arg_240_1.ang2
				end,
				Random = function(arg_241_0, arg_241_1)
					return client.random_int(arg_241_1.ang, arg_241_1.ang2)
				end,
				["Random Static"] = function(arg_242_0, arg_242_1)
					if not arg_242_0.once.srx then
						arg_242_0.once.srx = client.random_int(arg_242_1.ang, arg_242_1.ang2)
					end

					return arg_242_0.once.srx
				end,
				Spin = function(arg_243_0, arg_243_1)
					return math.lerp(arg_243_1.ang, arg_243_1.ang2, globals.curtime() * arg_243_1.speed * 0.1 % 1)
				end,
				Camera = function(arg_244_0, arg_244_1)
					return arg_244_1.ang + (var_221_2.camera_ang and var_221_2.camera_ang[1] or 0)
				end,
				["At target"] = function(arg_245_0, arg_245_1)
					return arg_245_1.ang + (var_221_2.threat_ang and var_221_2.threat_ang[1] or 0)
				end
			},
			yaw = {
				Static = function(arg_246_0, arg_246_1)
					return 360 - arg_246_1.ang
				end,
				Jitter = function(arg_247_0, arg_247_1)
					return 180 + arg_247_1.ang * (arg_247_0.once.switch and 0.5 or -0.5)
				end,
				Random = function(arg_248_0, arg_248_1)
					return 180 + client.random_int(arg_248_1.ang * -0.5, arg_248_1.ang * 0.5)
				end,
				["Random Jitter"] = function(arg_249_0, arg_249_1)
					local var_249_0 = math.random(0, 1) == 0 and 1 or -1
					local var_249_1 = math.random(arg_249_1.ang * -0.25, arg_249_1.ang * 0.25)

					return var_249_0 * 90 + var_249_1
				end,
				["Random Static"] = function(arg_250_0, arg_250_1)
					if not arg_250_0.once.sry then
						arg_250_0.once.sry = math.random(arg_250_1.ang * -0.5, arg_250_1.ang * 0.5)
					end

					return 180 + arg_250_0.once.sry
				end,
				Spin = function(arg_251_0, arg_251_1)
					return 180 + math.lerp(arg_251_1.ang * -0.5, arg_251_1.ang * 0.5, globals.curtime() * (arg_251_1.speed * 0.1) % 1), true
				end,
				["Spin Jitter"] = function(arg_252_0, arg_252_1)
					local var_252_0 = arg_252_0.once.switch and 1 or -1
					local var_252_1 = math.lerp(arg_252_1.ang * -0.5, arg_252_1.ang * 0.5, globals.curtime() * (arg_252_1.speed * 0.1) % 1)

					return var_252_0 * 90 + var_252_1
				end,
				["90w"] = function(arg_253_0, arg_253_1)
					local var_253_0 = arg_253_0.counter % 2 == 0 and 1 or -1
					local var_253_1 = math.lerp(arg_253_1.ang * -0.5, arg_253_1.ang * 0.5, var_0_113.exploit.lc_left / var_221_1.snap.time * arg_253_1.speed * 0.05 % 1)

					return var_253_0 * 90 + var_253_1, true
				end,
				["180v"] = function(arg_254_0, arg_254_1)
					local var_254_0 = math.sin(globals.curtime() * (arg_254_1.speed * 0.2)) * 0.5 + 0.5

					return 180 + math.lerp(arg_254_1.ang * -0.5, arg_254_1.ang * 0.5, var_254_0), true
				end,
				Camera = function(arg_255_0, arg_255_1)
					return (var_221_2.camera_ang and var_221_2.camera_ang[2] or 0) - var_221_3.yaw - arg_255_1.ang + 180
				end,
				["At target"] = function(arg_256_0, arg_256_1)
					local var_256_0 = var_221_2.threat_ang or var_221_2.camera_ang

					return (var_256_0 and var_256_0[2] or 0) - var_221_3.yaw - arg_256_1.ang + 180
				end,
				Opposite = function(arg_257_0, arg_257_1)
					return 180 - var_221_3.mod
				end
			},
			once = {},
			snap = function(arg_258_0)
				local var_258_0 = var_221_1.snap
				local var_258_1 = var_258_0 ~= nil and var_0_113.exploit.active and var_0_113.exploit.lc_left > (var_221_4.force_implicit and 1 or 0) and not var_221_2.use_aa and not var_221_2.manual_yaw

				if arg_258_0.might_cross and not var_221_2.send_packet and not var_0_113.exploit.active and var_0_113.exploit.lc_left > 0 then
					var_221_4.force_send, var_221_4.no_modifier, var_221_4.no_offset = true, true, true
					arg_258_0.might_cross = false
				end

				if var_258_1 then
					arg_258_0.ticks = arg_258_0.ticks + 1
					var_258_1 = var_258_0.time >= arg_258_0.ticks
				else
					arg_258_0.ticks = 0
				end

				var_221_2.will_break_lc = var_0_113.exploit.active and (var_0_113.exploit.active == var_0_109.exploit.OS or var_221_0.force_defensive)

				if var_258_1 then
					if (var_258_0.x.on or var_258_0.y.on) and (not var_221_2.snapping or var_0_113.exploit.lc_left <= 2) then
						var_221_4.force_send = true
					end

					var_221_2.snapping, var_221_3.snap = true, {}
					arg_258_0.once.apex = arg_258_0.once.apex or var_0_113.exploit.lc_left
					arg_258_0.once.delayed = arg_258_0.once.delayed or 0

					if arg_258_0.once.delayed >= var_258_0.y.delay + 1 then
						arg_258_0.once.switch = not arg_258_0.once.switch
						arg_258_0.once.delayed = 0
					elseif var_221_2.send_packet then
						arg_258_0.once.delayed = arg_258_0.once.delayed + 1
					end

					if var_258_0.x.on then
						local var_258_2 = arg_258_0.pitch[var_258_0.x.mode](arg_258_0, var_258_0.x)

						if var_258_2 then
							var_221_3.snap[1] = var_258_2
							arg_258_0.might_cross = true
						end
					end

					if var_258_0.y.on then
						local var_258_3, var_258_4 = arg_258_0.yaw[var_258_0.y.mode](arg_258_0, var_258_0.y)

						if var_258_3 then
							var_221_3.snap[2] = var_221_3.yaw + var_258_3

							if var_258_0.sd then
								var_221_3.des = var_258_3 < 180 and 60 or -60
								arg_258_0.prev_des = var_221_3.des
							end

							arg_258_0.might_cross = true
						end

						if var_258_4 then
							var_221_4.force_send = true
						end
					end
				elseif var_221_2.snapping then
					arg_258_0.counter = arg_258_0.counter + 1
					var_221_2.snapping, var_221_3.snap = false

					table.clear(arg_258_0.once)

					arg_258_0.might_cross = false
				end
			end,
			lc = function(arg_259_0)
				local var_259_0 = var_0_127.antiaim.def.triggers

				return var_221_0.weaponselect ~= 0 and var_259_0:get("Weapon change") or not var_0_113.on_ground and var_259_0:get("Jumping") or var_0_113.crouching and var_0_113.on_ground and var_259_0:get("Crouching")
			end,
			work = function(arg_260_0)
				if arg_260_0:lc() then
					var_221_0.force_defensive = true
				end

				arg_260_0:snap()
			end
		},
		head = {
			smart = function()
				local var_261_0, var_261_1, var_261_2 = entity.hitbox_position(var_0_113.self, 0)
				local var_261_3, var_261_4, var_261_5 = entity.get_origin(var_0_113.threat)

				if not var_261_5 then
					return
				end

				local var_261_6 = (var_261_2 - (var_261_5 + 68)) / var_221_2.threat_dist
				local var_261_7 = 0
				local var_261_8 = 0.75
				local var_261_9 = false

				if var_0_113.on_ground and not var_0_113.crouching then
					var_261_7, var_261_8 = 0.25, 0.5, true
				elseif var_0_113.on_ground and var_0_113.crouching then
					var_261_7, var_261_8 = -0.05, 0.3, true
				elseif var_221_2.state == var_0_109.states.air then
					var_261_7, var_261_8 = 0.35, 0.75
				elseif var_221_2.state == var_0_109.states.airc then
					if var_0_113.weapon_t and var_0_113.weapon_t.type == "knife" then
						var_261_7, var_261_8 = -0.05, 0.55
					else
						var_261_7, var_261_8 = 0.25, 0.75
					end
				end

				if var_261_6 < var_261_7 or var_261_8 < var_261_6 then
					return
				end

				var_221_2.safe_head = true
				var_221_4.no_modifier, var_221_4.no_offset, var_221_4.force_desync = true, true, 0
			end,
			basic = function()
				local var_262_0, var_262_1, var_262_2 = entity.get_origin(var_0_113.threat)

				if not var_262_2 then
					return
				end

				local var_262_3 = var_221_2.threat_dist
				local var_262_4 = var_0_113.origin.z - var_262_2
				local var_262_5, var_262_6, var_262_7 = client.eye_position()
				local var_262_8 = var_0_113.weapon_t and var_0_113.weapon_t.weapon_type_int == 0

				if var_0_113.jumping and var_262_8 and var_262_4 > -32 then
					var_221_2.safe_head = true
					var_221_4.no_modifier, var_221_4.no_offset, var_221_4.force_desync = true, true, 0
				end
			end,
			work = function(arg_263_0)
				var_221_2.safe_head = false

				if not var_0_127.antiaim.general.head.on.value or not var_0_113.threat or var_221_2.manual_yaw or var_221_2.use_aa then
					return
				end

				arg_263_0.basic()
			end
		},
		stab = {
			work = function(arg_264_0)
				local var_264_0 = var_221_2.backstab

				var_221_2.backstab = false

				if var_0_127.antiaim.general.stab.value and var_0_113.threat then
					local var_264_1 = var_221_2.threat_dist
					local var_264_2 = var_0_49(entity.get_player_weapon(var_0_113.threat))

					if var_264_1 < 280 and var_264_2 and var_264_2.type == "knife" then
						if not var_264_0 then
							var_221_0.no_choke = true
							var_221_4.force_send = true
						end

						var_221_3.yaw = var_221_3.yaw + 180
						var_221_4.no_snap = true
						var_221_2.backstab = true
					end
				end
			end
		},
		fl = {
			overridden = false,
			work = function(arg_265_0)
				local var_265_0 = var_0_107.aa.fakelag
				local var_265_1 = var_0_127.antiaim.general.fl

				if var_265_1.on.value then
					var_265_0.enable:override(true)
					var_265_0.amount:override(var_265_1.mode.value)
					var_265_0.limit:override(var_265_1.limit.value)
					var_265_0.variance:override(math.clamp(var_0_113.velocity / 300 * 100, 0, 100))

					arg_265_0.overridden = true
				elseif arg_265_0.overridden then
					var_265_0.enable:override()
					var_265_0.amount:override()
					var_265_0.limit:override()
					var_265_0.variance:override()

					arg_265_0.overridden = false
				end
			end
		},
		legs = {
			work = function(arg_266_0)
				if var_0_127.antiaim.general.legs.value == "Pseudo-walk" then
					local var_266_0 = var_221_2.sent % 3
					local var_266_1 = "Off"

					if var_266_0 == 2 then
						var_266_1 = "Always slide"
					elseif var_266_0 == 3 then
						var_266_1 = "Never slide"
					end

					var_0_107.aa.other.legs:override(var_266_1)
				else
					var_0_107.aa.other.legs:override(var_0_127.antiaim.general.legs.value)
				end
			end
		},
		use_aa = {
			wait = false,
			check = function()
				local var_267_0 = entity.get_prop(var_0_113.self, "m_iTeamNum")
				local var_267_1 = entity.get_prop(var_0_113.self, "m_bIsDefusing") == 1
				local var_267_2 = entity.get_prop(var_0_113.self, "m_bIsGrabbingHostage") == 1

				if var_267_1 or var_267_2 then
					return false
				end

				if var_267_0 == 3 and var_221_0.pitch > 15 then
					local var_267_3 = entity.get_all("CC4")

					for iter_267_0 = 1, #var_267_3 do
						local var_267_4, var_267_5, var_267_6 = entity.get_origin(var_267_3[iter_267_0])

						if math.sqrt3(var_0_113.origin.x - var_267_4, var_0_113.origin.y - var_267_5, var_0_113.origin.z - var_267_6) then
							return false
						end
					end
				end

				return true
			end,
			work = function(arg_268_0)
				var_221_2.use_aa = false

				if not var_0_127.antiaim.general.use.value then
					return
				end

				if var_0_113.using then
					var_221_2.use_aa = true
					var_221_4.force_implicit = false

					if arg_268_0.wait == false then
						var_221_0.no_choke = true
						var_221_4.force_send = true
						var_221_4.no_antiaim = true
						arg_268_0.wait = true
					elseif arg_268_0.wait == true then
						if arg_268_0.check() then
							var_221_3.pitch, var_221_3.yaw = var_221_2.camera_ang[1], var_221_2.camera_ang[2]
						else
							var_221_4.no_antiaim = true
						end
					end
				elseif arg_268_0.wait then
					var_221_0.no_choke = true
					var_221_4.force_send = true
					var_221_4.no_offset, var_221_4.no_modifier = true, true
					arg_268_0.wait = false
				end
			end
		}
	}
	local var_221_15 = {
		work = function()
			var_221_14.angles:work()
			var_221_14.modifier:work()
			var_221_14.desync:work()
			var_221_14.defensive:work()
			var_221_14.head:work()
			var_221_14.stab:work()
			var_221_14.use_aa:work()
			var_221_14.fl:work()

			if var_221_4.no_snap then
				var_221_3.snap = nil
			end

			if var_221_4.no_modifier then
				var_221_3.mod = 0
			end

			if var_221_4.force_desync ~= nil then
				var_221_3.des = var_221_4.force_desync or nil
			end

			if not var_221_4.no_offset and var_221_1.cur.add.on and var_221_3.des and var_221_3.des ~= 0 then
				var_221_3.mod = var_221_3.mod + (var_221_3.des > 0 and var_221_1.cur.add.r or var_221_1.cur.add.l)
			end
		end
	}
	local var_221_16
	local var_221_17 = {
		direct = {
			yaw = 0,
			pitch = 0,
			previous_body = 0,
			allowed = function()
				if var_221_4.no_antiaim or var_0_113.throwing_nade or var_221_0.in_attack == 1 and var_0_113.can_shoot or var_0_113.using and not var_0_127.antiaim.general.use.value or var_0_113.movetype == 9 and (var_221_0.sidemove ~= 0 or var_221_0.forwardmove ~= 0) or entity.get_prop(var_0_113.gamerules, "m_bFreezePeriod") == 1 then
					return false
				end

				return true
			end,
			micromove = function()
				if not var_0_113.on_ground or var_0_113.movetype == 9 then
					return
				end

				if var_0_107.misc.helper and var_0_113.weapon_t and var_0_113.weapon_t.weapon_type_int == 9 and ui.is_active(var_0_107.misc.helper) then
					return
				end

				local var_271_0 = var_221_0.in_forward == 1 or var_221_0.in_back == 1 or var_221_0.in_moveleft == 1 or var_221_0.in_moveright == 1
				local var_271_1 = var_0_113.duck_amount > 0 and var_0_113.on_ground and 3.3 or 1.1

				if not var_271_0 and var_0_113.velocity < 20 and not var_221_0.quick_stop then
					var_221_0.sidemove = var_221_0.command_number % 2 == 0 and var_271_1 or -var_271_1
				end
			end,
			jitter_move = function()
				if var_0_113.jumping or var_0_113.walking then
					return
				end

				local var_272_0 = 90
				local var_272_1 = 0.1875
				local var_272_2 = var_221_0.command_number % 64 * var_272_1 + var_272_0

				if var_272_2 <= 100 then
					var_272_0 = var_272_2 >= 90 and var_272_2 or 100
				end

				local var_272_3 = var_272_0 * 0.01 * 320

				if var_272_3 <= 0 then
					return
				end

				local var_272_4 = math.sqrt3(var_221_0.forwardmove, var_221_0.sidemove)

				if var_272_4 < 10 or var_272_4 < var_272_3 then
					return
				end

				var_221_0.forwardmove = var_221_0.forwardmove / var_272_4 * var_272_3
				var_221_0.sidemove = var_221_0.sidemove / var_272_4 * var_272_3
			end,
			compensate = {
				previous = 0,
				ready = false,
				feet = function(arg_273_0, arg_273_1, arg_273_2)
					local var_273_0 = arg_273_1
					local var_273_1 = false

					if math.abs(arg_273_1) - math.abs(arg_273_2) > 5 then
						local var_273_2 = entity.get_max_desync(var_0_113.animstate)
					end

					return var_273_0, var_273_1
				end
			},
			work = function(arg_274_0)
				arg_274_0.micromove()

				if not arg_274_0.allowed() then
					return
				end

				if not var_221_4.hybrid then
					var_0_107.aa.angles.enable:override(false)
				end

				if var_0_127.antiaim.general.jmove.value then
					arg_274_0.jitter_move()
				end

				arg_274_0.pitch = var_221_3.snap and var_221_3.snap[1] or var_221_3.pitch

				if var_221_2.send_packet or var_221_4.force_send or var_221_4.speeding then
					arg_274_0.yaw = var_221_3.snap and var_221_3.snap[2] or var_221_3.yaw + var_221_3.mod
				end

				var_221_0.pitch = math.normalize_pitch(arg_274_0.pitch)
				var_221_0.yaw = math.normalize_yaw(arg_274_0.yaw)

				if var_221_2.send_packet and var_221_3.des then
					local var_274_0 = math.clamp(var_221_3.des, -60, 60)
					local var_274_1 = var_0_113.on_ground and 2 or 1

					if var_221_4.speeding then
						var_274_1 = 1
					end

					var_221_0.yaw = var_221_0.yaw - var_274_0 * var_274_1
					var_221_0.allow_send_packet = false
				end
			end
		},
		implicit = {
			work = function(arg_275_0)
				local var_275_0 = math.normalize_pitch(var_221_3.snap and var_221_3.snap[1] or var_221_3.pitch)
				local var_275_1 = math.normalize_yaw(var_221_3.snap and var_221_3.snap[2] or var_221_3.yaw + var_221_3.mod)

				var_0_107.aa.angles.enable:override(true)
				var_221_5.pitch_mode:override("Custom")
				var_221_5.pitch:override(var_275_0)

				if var_221_2.send_packet or var_221_4.force_send then
					var_221_5.yaw_mode:override("Static")
					var_221_5.yaw:override(var_275_1)
					var_221_5.jitter_mode:override("Off")
					var_221_5.body_mode:override(var_221_3.des ~= nil and "Static" or "Off")

					if var_221_3.des then
						var_221_5.body:override(var_221_3.des > 0 and 1 or var_221_3.des < 0 and -1 or 0)
					end
				end
			end
		}
	}
	local var_221_18
	local var_221_19 = 0

	local function var_221_20(arg_276_0)
		if arg_276_0 <= var_221_19 or var_0_113.exploit.active == var_0_109.exploit.OFF then
			if var_221_2.send_packet then
				var_221_2.counter = var_221_2.counter >= 65535 and 0 or var_221_2.counter + 1
				var_221_2.switch = var_221_2.counter % 2 == 0
				var_221_19 = 0
			end
		else
			var_221_19 = var_221_19 + 1
		end
	end

	local function var_221_21()
		if var_221_2.send_packet then
			var_221_2.sent = var_221_2.sent >= 65535 and 0 or var_221_2.sent + 1
		end

		var_221_20(var_221_1.cur.delay)
		table.clear(var_221_4)
	end

	local var_221_22 = {
		work = function(arg_278_0)
			var_221_0 = arg_278_0

			var_221_12()

			var_221_4.force_implicit = var_0_127.antiaim.general.mode.value == "gamesense"
			var_221_4.force_implicit = var_221_4.force_implicit or not ui.is_active(var_0_107.rage.aimbot.enable)

			var_221_15:work()

			if var_221_4.force_implicit then
				var_221_17.implicit:work()
			else
				var_221_17.direct:work()
			end

			var_221_21()
		end
	}

	var_0_133 = {
		data = var_221_2,
		ctx = var_221_3,
		restore = function()
			var_0_107.aa.angles.enable:override()

			for iter_279_0, iter_279_1 in var_0_11, var_221_5 do
				iter_279_1:override()
			end
		end,
		run = function(arg_280_0)
			var_0_127.antiaim.on:set_callback(function(arg_281_0)
				var_0_78.setup_command(arg_281_0.value, var_221_22.work)
				var_0_107.aa.angles.freestand:override(var_0_60(arg_281_0.value, false, nil))
				var_0_107.aa.angles.freestand.hotkey:override(arg_281_0.value and {
					"Always on",
					0
				} or nil)
				var_0_107.aa.angles.fs_body:override(var_0_60(arg_281_0.value, false, nil))

				if not arg_281_0.value then
					var_0_133.restore()
				end
			end, true)
		end
	}

	var_0_133:run()
end)()
LPH_NO_VIRTUALIZE(function()
	local var_282_0 = {}

	var_282_0.clantag = {
		last = 0,
		enabled = false,
		list = {
			"h ⠀ ⠀⠀⠀",
			"hy ⠀ ⠀ ⠀",
			"hys ⠀⠀⠀",
			"hyst  ⠀⠀ ",
			"hyste⠀⠀",
			"hyster ⠀",
			"hysteri⠀",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"hysteria",
			"⠀ysteria",
			"⠀ steria",
			"⠀⠀ teria",
			"⠀⠀⠀eria",
			"⠀⠀ ⠀ ria",
			"⠀ ⠀ ⠀ ia",
			"⠀ ⠀⠀⠀ a"
		},
		work = function()
			if var_282_0.clantag.enabled and not var_0_127.misc.clantag.value then
				var_282_0.clantag.enabled = false

				var_0_78.net_update_end:unset(var_282_0.clantag.work)
				client.set_clan_tag()
			end

			local var_283_0 = math.round(globals.curtime() * 3) % #var_282_0.clantag.list + 1

			if var_283_0 == var_282_0.clantag.last then
				return
			end

			var_282_0.clantag.last = var_283_0

			client.set_clan_tag(var_282_0.clantag.list[var_283_0])
		end,
		run = function(arg_284_0)
			var_0_127.misc.clantag:set_callback(function(arg_285_0)
				var_0_107.misc.clantag:set_enabled(not arg_285_0.value)

				if arg_285_0.value then
					arg_284_0.enabled = true

					var_0_78.net_update_end:set(arg_284_0.work)
					var_0_107.misc.clantag:override(false)
				else
					var_0_107.misc.clantag:override()
					client.set_clan_tag()
				end
			end, true)
			var_0_3(function()
				var_0_107.misc.clantag:set_enabled(true)
				var_0_107.misc.clantag:override()
				client.set_clan_tag()
			end)
		end
	}
	var_282_0.ladder = {
		work = function(arg_287_0)
			if var_0_113.movetype ~= 9 or arg_287_0.forwardmove == 0 then
				var_282_0.ladder.start = false

				return
			end

			if var_282_0.ladder.start == false then
				var_282_0.ladder.start = true
			else
				local var_287_0, var_287_1 = client.camera_angles()
				local var_287_2 = arg_287_0.forwardmove < 0 or var_287_0 > 45

				arg_287_0.in_moveleft, arg_287_0.in_moveright = var_287_2 and 1 or 0, not var_287_2 and 1 or 0
				arg_287_0.in_forward, arg_287_0.in_back = var_287_2 and 1 or 0, not var_287_2 and 1 or 0
				arg_287_0.pitch, arg_287_0.yaw = 89, math.normalize_yaw(arg_287_0.move_yaw + 90)
			end
		end,
		run = function(arg_288_0)
			var_0_127.misc.ladder:set_callback(function(arg_289_0)
				var_0_78.setup_command(arg_289_0.value, arg_288_0.work)
			end, true)
		end
	}
	var_282_0.breaker = {
		work = function()
			if not var_0_113.valid then
				return
			end

			local var_290_0 = entity.get_animstate(var_0_113.self)

			if not var_290_0 then
				return
			end

			local var_290_1 = var_0_127.misc.breaker

			if var_290_1.pitch.value and not var_0_113.jumping and var_290_0.hit_in_ground_animation then
				entity.set_prop(var_0_113.self, "m_flPoseParameter", 0.5, 12)
			end

			if var_290_1.slia.value and var_0_113.jumping then
				entity.set_prop(var_0_113.self, "m_flPoseParameter", 1, 6)
			end

			if var_290_1.legs.value == "Static" then
				var_0_107.aa.other.legs:override("Always slide")
				entity.set_prop(var_0_113.self, "m_flPoseParameter", 0, 0)
			elseif var_290_1.legs.value == "Jitter" then
				var_0_107.aa.other.legs:override("Always slide")

				if globals.tickcount() % 4 > 1 then
					entity.set_prop(var_0_113.self, "m_flPoseParameter", 0, 0)
				end
			elseif var_290_1.legs.value == "No step back" then
				var_0_107.aa.other.legs:override("Never slide")
				entity.set_prop(var_0_113.self, "m_flPoseParameter", 0.5, 7)
			else
				var_0_107.aa.other.legs:override()
			end
		end,
		run = function(arg_291_0)
			var_0_127.misc.breaker.on:set_callback(function(arg_292_0)
				var_0_78.pre_render(arg_292_0.value, arg_291_0.work)

				if not arg_292_0.value then
					var_0_107.aa.other.legs:override()
				end
			end, true)
		end
	}
	var_282_0.filter = {
		callback = function(arg_293_0)
			client.delay_call(0, function()
				cvar.con_filter_enable:set_int(arg_293_0.value and 1 or 0)
				cvar.con_filter_text:set_string(arg_293_0.value and "hysteria" or "")
			end)
		end,
		run = function(arg_295_0)
			var_0_127.misc.filter:set_callback(arg_295_0.callback, true)
			var_0_78.shutdown:set(function()
				cvar.con_filter_enable:set_int(0)
				cvar.con_filter_text:set_string("")
			end)
		end
	}

	for iter_282_0, iter_282_1 in var_0_11, var_282_0 do
		iter_282_1:run()
	end

	local var_282_1 = var_0_128.servers
	local var_282_2 = var_0_88.servers or {}
	local var_282_3 = 0
	local var_282_4
	local var_282_5

	var_282_5 = {
		update = function()
			var_282_3 = var_282_1.list[0]:get()
			var_282_4 = var_282_2[var_282_3]

			var_282_1.list.connect:set_enabled(var_282_4 ~= nil)
			var_282_1.list.export:set_enabled(var_282_4 ~= nil)
			var_282_1.list.delete:set_enabled(var_282_4 ~= nil)
		end,
		save = function()
			var_0_88.servers = var_282_2

			var_0_88()
		end,
		refresh = function()
			var_282_1.list[0]:update(var_282_2)
			var_282_5.update()
		end,
		export = function(arg_300_0, arg_300_1)
			var_0_85.set(string.format("[\"%s\"]:[%s]", arg_300_0, arg_300_1))
		end,
		import = function()
			if not var_0_85.get() then
				return
			end

			local var_301_0, var_301_1 = string.match("[\"(.+)\"]:[(.+)]")

			if not var_301_0 or not var_301_1 then
				return
			end

			var_282_5.add(var_301_0, var_301_1)
		end,
		add = function(arg_302_0, arg_302_1)
			if not arg_302_0 or not arg_302_1 then
				return
			end

			arg_302_0 = string.limit(arg_302_0, 32)
			var_282_2[#var_282_2 + 1] = {
				arg_302_0,
				arg_302_1
			}

			var_282_5.refresh()
		end,
		delete = function(arg_303_0)
			if not var_282_2[arg_303_0] then
				return
			end

			table.remove(var_282_2, arg_303_0)
			var_282_5.refresh()
		end
	}

	var_282_1.list[0]:set_callback(var_282_5.update)
	client.delay_call(0.1, var_282_5.update)
	var_282_1.new.create:set_callback(function()
		local var_304_0 = string.clean(var_282_1.new.name:get())
		local var_304_1 = string.clean(var_282_1.new.ip:get())

		if #var_304_0 == 0 or #var_304_1 == 0 then
			return
		end

		var_282_5.add(var_304_0, var_304_1)
	end)
	var_282_1.list.delete:set_callback(function()
		var_282_5.delete(var_282_3)
	end)

	local var_282_6
	local var_282_7 = {}
	local var_282_8 = {
		"knife",
		"c4",
		"decoy",
		"flashbang",
		"hegrenade",
		"incgrenade",
		"molotov",
		"inferno",
		"smokegrenade"
	}
	local var_282_9 = {
		mismatch = {
			"\aD59A4D",
			"\aD59A4D\x01",
			"\a",
			var_0_79.hex("D59A4D")
		},
		hit = {
			"\aA3D350",
			"\aA3D350\x01",
			"\x06",
			var_0_79.hex("A3D350")
		},
		miss = {
			"\aA67CCF",
			"\aA67CCF\x01",
			"\x03",
			var_0_79.hex("A67CCF")
		},
		harm = {
			"\ad35050",
			"\ad35050\x01",
			"\a",
			var_0_79.hex("d35050")
		},
		brute = {
			"\aBFBFBF",
			"\aBFBFBF\x01",
			"\x01",
			var_0_79.hex("BFBFBF")
		},
		evaded = {
			"\aB0C6FF",
			"\aB0C6FF\x01",
			"\x01",
			var_0_79.hex("AB0C6F")
		}
	}
	local var_282_10 = {
		list = {}
	}

	var_282_10.events = {
		evade = function(arg_306_0)
			if arg_306_0.damaged or not var_0_127.misc.logs.events:get("Anti-aim info") then
				return
			end

			var_282_10.invent("evaded", {{true,	"evaded "}, {false,"Evaded "}, {{entity.get_player_name(arg_306_0.attacker)}, "'s shot"}})
		end,
		receive = function(arg_307_0, arg_307_1, arg_307_2)
			local var_307_0 = arg_307_1 == arg_307_2 or arg_307_2 == 0
			local var_307_1 = arg_307_0.health == 0
			local var_307_2 = arg_307_0.weapon
			local var_307_3 = arg_307_0.dmg_health
			local var_307_4 = var_0_109.hitgroups[arg_307_0.hitgroup or 0] or "generic"
			local var_307_5 = var_307_1 and "Killed by" or "Harmed by"

			arg_307_2 = arg_307_2 ~= 0 and entity.get_player_name(arg_307_2) or "world"

			local var_307_6 = {
				var_307_0 and {
					true,
					{
						"you"
					},
					var_307_1 and " killed " or " harmed "
				} or {
					true,
					string.lower(var_307_5),
					" "
				},
				var_307_0 and {
					false,
					{
						"You"
					},
					var_307_1 and " killed " or " harmed "
				} or {
					false,
					var_307_5,
					" "
				},
				{
					var_307_0 and {
						"yourself"
					} or {
						arg_307_2
					}
				},
				not var_307_0 and var_307_4 ~= "generic" and { -- legs
					" in ",
					{
						var_307_4
					}
				} or nil,
				not var_307_1 and {
					" for ",
					{
						var_307_3,
						" hp"
					}
				} or nil
			}

			var_282_10.invent("harm", var_307_6)
		end,
		harm = function(arg_308_0, arg_308_1, arg_308_2)
			if not table.find(var_282_8, arg_308_0.weapon) and arg_308_0.weapon ~= "knife" then
				return
			end

			local var_308_0 = arg_308_0.health == 0
			local var_308_1 = "a " .. arg_308_0.weapon

			if arg_308_0.weapon == "hegrenade" then
				var_308_1 = "an HE grenade"
			end

			local var_308_2 = entity.get_player_name(arg_308_1)
			local var_308_3 = var_308_0 and "Killed" or "Harmed"

			if var_308_0 and arg_308_0.weapon == "hegrenade" then
				var_308_3 = "Exploded"
			elseif var_308_0 and arg_308_0.weapon == "knife" then
				var_308_3 = "Stabbed"
			elseif arg_308_0.weapon == "inferno" then
				var_308_3 = "Burnt"
			end

			local var_308_4 = {
				{
					true,
					string.lower(var_308_3),
					" "
				},
				{
					false,
					var_308_3,
					" "
				},
				{
					{
						var_308_2
					}
				},
				not var_308_0 and {
					" for ",
					{
						arg_308_0.dmg_health,
						" hp"
					}
				} or nil,
				var_308_0 and var_308_3 == "Burnt" and {
					" to ",
					{
						"death"
					}
				} or nil,
				(var_308_3 == "Killed" or var_308_3 == "Harmed") and {
					true,
					" with ",
					{
						var_308_1
					}
				} or nil
			}

			var_282_10.invent("hit", var_308_4)
		end,
		damage = function(arg_309_0)
			local var_309_0 = client.userid_to_entindex(arg_309_0.userid)
			local var_309_1 = arg_309_0.attacker ~= 0 and client.userid_to_entindex(arg_309_0.attacker) or 0

			if var_309_0 == var_0_113.self and var_0_127.misc.logs.events:get("Getting harmed") then
				var_282_10.events.receive(arg_309_0, var_309_0, var_309_1)
			elseif var_309_1 == var_0_113.self and var_309_0 ~= var_0_113.self and var_0_127.misc.logs.events:get("Harming enemies") then
				var_282_10.events.harm(arg_309_0, var_309_0, var_309_1)
			end
		end,
		miss = function(arg_310_0)
			if not var_0_127.misc.logs.events:get("Ragebot shots") then
				return
			end

			local var_310_0 = var_282_7[arg_310_0.id] or {}
			local var_310_1 = "Missed"
			local var_310_2 = entity.get_player_name(arg_310_0.target)
			local var_310_3 = arg_310_0.reason

			if var_310_3 == "prediction error" and var_310_0.difference and var_310_0.difference > 2 then
				var_310_3 = "unpredicted occasion"
			end

			local var_310_4 = var_0_109.hitgroups[arg_310_0.hitgroup]
			local var_310_5 = {
				{
					false,
					var_310_1,
					" "
				},
				{
					true,
					string.lower(var_310_1),
					" "
				},
				{
					{
						var_310_2
					}
				},
				var_310_4 and {
					"'s ",
					{
						var_310_4
					}
				},
				var_310_3 ~= "?" and {
					" due to ",
					{
						var_310_3
					}
				} or nil
			}
			local var_310_6 = {
				var_310_0.damage and {
					"dmg: ",
					{
						var_310_0.damage
					}
				},
				{
					"hc: ",
					{
						math.round(arg_310_0.hit_chance),
						"%%"
					},
					var_0_107.rage.aimbot.hit_chance.value - arg_310_0.hit_chance > 3 and "⮟" or ""
				} or nil,
				var_310_0.difference and var_310_0.difference ~= 0 and {
					"Δ: ",
					{
						var_310_0.difference,
						"t"
					},
					var_310_0.difference < 0 and "⮟" or ""
				} or nil,
				var_310_0.teleport and {
					{
						"LC"
					}
				} or nil,
				(var_310_0.interpolated or var_310_0.extrapolated) and {
					{
						var_310_0.interpolated and "IN" or "",
						var_310_0.extrapolated and "EP" or ""
					}
				} or nil
			}

			var_282_10.invent("miss", var_310_5, var_310_6)

			var_282_7[arg_310_0.id] = nil
		end,
		hit = function(arg_311_0)
			if not var_0_127.misc.logs.events:get("Ragebot shots") then
				return
			end

			local var_311_0 = var_282_7[arg_311_0.id] or {}
			local var_311_1 = "Hit"

			if not entity.is_alive(arg_311_0.target) then
				var_311_1 = "Killed"
			end

			local var_311_2 = entity.get_player_name(arg_311_0.target)
			local var_311_3 = var_0_109.hitgroups[arg_311_0.hitgroup]
			local var_311_4 = var_0_109.hitgroups[var_311_0.hitgroup or 0]
			local var_311_5 = var_311_1 == "Hit" and arg_311_0.hitgroup ~= var_311_0.hitgroup
			local var_311_6 = var_311_1 == "Hit" and (var_311_0.damage or 0) - (arg_311_0.damage or 0) > 10
			local var_311_7

			if var_311_6 and var_311_5 and var_311_4 then
				var_311_7 = {
					var_311_4,
					"-",
					var_311_0.damage
				}
			elseif var_311_6 then
				var_311_7 = {
					var_311_0.damage,
					" hp"
				}
			end

			local var_311_8 = {
				{
					true,
					string.lower(var_311_1),
					" ",
					{
						var_311_2
					}
				},
				{
					false,
					var_311_1,
					" ",
					{
						var_311_2
					}
				},
				var_311_3 and var_311_3 ~= "generic" and {
					var_311_1 == "Hit" and "'s " or " in ",
					{
						var_311_3
					},
					var_311_5 and "\aD59A4D!\r" or ""
				} or nil,
				var_311_1 == "Hit" and {
					" for ",
					{
						arg_311_0.damage,
						" hp"
					},
					var_311_6 and "\aD59A4D!\r" or ""
				} or nil
			}
			local var_311_9 = {
				var_311_7 and {
					"exp: ",
					var_311_7
				},
				var_311_0.difference ~= 0 and {
					"Δ: ",
					{
						var_311_0.difference,
						"t"
					}
				} or nil,
				var_0_107.rage.aimbot.hit_chance.value - arg_311_0.hit_chance > 5 and {
					"hc: ",
					{
						math.floor(arg_311_0.hit_chance),
						"%%"
					},
					"⮟"
				} or nil
			}

			var_282_10.invent("hit", var_311_8, var_311_9)

			var_282_7[arg_311_0.id] = nil
		end,
		aim = function(arg_312_0)
			if not var_0_127.misc.logs.events:get("Ragebot shots") then
				return
			end

			arg_312_0.difference = globals.tickcount() - arg_312_0.tick
			var_282_7[arg_312_0.id] = arg_312_0
		end
	}

	function var_282_10.invent(arg_313_0, arg_313_1, arg_313_2)
		local var_313_0 = {
			console = {},
			screen = {},
			chat = {}
		}

		if arg_313_0 then
			local var_313_1 = 0
			local var_313_2 = 0
			local var_313_3 = var_282_9[arg_313_0]

			var_313_0.console[var_313_1 + 1], var_313_0.console[var_313_1 + 2] = var_313_3 and var_313_3[1] or "", " •\r "
			var_313_0.screen[var_313_2 + 1], var_313_0.screen[var_313_2 + 2] = var_313_3 and var_313_3[2] or "", "•\aE6E6E6\x02 "
		end

		for iter_313_0 = 1, table.maxn(arg_313_1) do
			local var_313_4 = arg_313_1[iter_313_0]

			if not var_313_4 then
				-- block empty
			elseif var_0_24(var_313_4) == "table" then
				local var_313_5 = arg_313_1[iter_313_0][1] == true and 1 or arg_313_1[iter_313_0][1] == false and 2 or 0

				for iter_313_1, iter_313_2 in var_0_9(var_313_4) do
					local var_313_6 = var_0_24(iter_313_2)

					if var_313_6 ~= "boolean" or iter_313_1 ~= 1 then
						if var_313_5 ~= 2 then
							if var_313_6 == "table" then
								table.move(iter_313_2, 1, #iter_313_2, #var_313_0.console + 1, var_313_0.console)
								table.move(iter_313_2, 1, #iter_313_2, #var_313_0.chat + 1, var_313_0.chat)
							else
								local var_313_7 = #var_313_0.console
								local var_313_8 = #var_313_0.chat

								var_313_0.console[var_313_7 + 1], var_313_0.console[var_313_7 + 2], var_313_0.console[var_313_7 + 3] = "\a909090", var_313_6 == "string" and iter_313_2 or var_0_21(iter_313_2), "\r"
								var_313_0.chat[var_313_8 + 1], var_313_0.chat[var_313_8 + 2], var_313_0.chat[var_313_8 + 3] = "\b", var_313_6 == "string" and string.gsub(iter_313_2, "\a%x%x%x%x%x%x", "") or var_0_21(iter_313_2), "\x01"
							end
						end

						if var_313_5 ~= 1 then
							if var_313_6 == "table" then
								local var_313_9 = #var_313_0.screen

								for iter_313_3 = 1, #iter_313_2, 3 do
									var_313_0.screen[var_313_9 + iter_313_3], var_313_0.screen[var_313_9 + iter_313_3 + 1], var_313_0.screen[var_313_9 + iter_313_3 + 2] = "\aE6E6E6\x01", iter_313_2[iter_313_3], "\aE6E6E6\x02"
								end
							else
								local var_313_10 = #var_313_0.screen

								var_313_0.screen[var_313_10 + 1], var_313_0.screen[var_313_10 + 2] = var_313_6 == "string" and string.gsub(iter_313_2, "\a%x%x%x%x%x%x", function(arg_314_0)
									return arg_314_0 .. "\x01"
								end) or var_0_21(iter_313_2), "\aE6E6E6\x02"
							end
						end
					end
				end
			else
				local var_313_11 = #var_313_0.console

				var_313_0.console[var_313_11 + 1], var_313_0.console[var_313_11 + 2], var_313_0.console[var_313_11 + 3] = "\a808080", var_0_21(var_313_4), "\r"
				var_313_0.screen[#var_313_0.screen + 1] = var_0_24(var_313_4) == "string" and string.gsub(var_313_4, "\a%x%x%x%x%x%x", function(arg_315_0)
					return arg_315_0 .. "\x02"
				end) or var_0_21(var_313_4)
			end
		end

		arg_313_2 = var_0_24(arg_313_2) == "table" and table.filter(arg_313_2) or nil

		if arg_313_2 and #arg_313_2 > 0 then
			var_313_0.console[#var_313_0.console + 1] = " \v~\r "

			for iter_313_4 = 1, #arg_313_2 do
				if var_0_24(arg_313_2[iter_313_4]) == "table" then
					for iter_313_5, iter_313_6 in var_0_9(arg_313_2[iter_313_4]) do
						local var_313_12 = var_0_24(iter_313_6)

						if var_313_12 == "table" then
							var_313_0.console[#var_313_0.console + 1] = "\aAAAAAA"

							table.move(iter_313_6, 1, #iter_313_6, #var_313_0.console + 1, var_313_0.console)
						else
							local var_313_13 = #var_313_0.console

							var_313_0.console[var_313_13 + 1], var_313_0.console[var_313_13 + 2] = "\a707070", var_313_12 == "string" and iter_313_6 or var_0_21(iter_313_6)
						end

						var_313_0.console[#var_313_0.console + 1] = "\r"
					end
				else
					local var_313_14 = #var_313_0.console

					var_313_0.console[var_313_14 + 1], var_313_0.console[var_313_14 + 2], var_313_0.console[var_313_14 + 3] = "\a707070", var_0_21(arg_313_1[iter_313_4]), "\r"
				end

				if iter_313_4 < #arg_313_2 then
					var_313_0.console[#var_313_0.console + 1] = "\a707070, \r"
				end
			end
		end

		var_282_10.push(arg_313_0, table.concat(var_313_0.console), table.concat(var_313_0.screen), table.concat(var_313_0.chat))
	end

	function var_282_10.push(arg_316_0, arg_316_1, arg_316_2, arg_316_3)
		if arg_316_1 and var_0_127.misc.logs.output:get("Console") then
			var_0_57(arg_316_1)
		end

		if arg_316_2 and var_0_127.misc.logs.output:get("Screen") then
			table.insert(var_282_10.list, 1, {
				event = arg_316_0,
				text = arg_316_2,
				time = globals.realtime(),
				progress = {
					0
				}
			})
		end
	end

	function var_282_10.clear_stack()
		var_282_7 = {}
	end

	function var_282_10.run(arg_318_0)
		var_0_127.misc.logs.on:set_callback(function(arg_319_0)
			var_0_78.aim_fire(arg_319_0.value, arg_318_0.events.aim)
			var_0_78.aim_hit(arg_319_0.value, arg_318_0.events.hit)
			var_0_78.aim_miss(arg_319_0.value, arg_318_0.events.miss)
			var_0_78.player_hurt(arg_319_0.value, arg_318_0.events.damage)
			var_0_78.enemy_shot(arg_319_0.value, arg_318_0.events.evade)
			var_0_78.local_spawned(arg_319_0.value, arg_318_0.clear_stack)

			local var_319_0 = var_0_60(arg_319_0.value, false, nil)

			var_0_107.rage.other.log_misses:override(var_319_0)
			var_0_107.misc.log_damage:override(var_319_0)
		end, true)
		var_0_107.rage.other.log_misses:depend(true, {
			var_0_127.misc.logs.on,
			false
		})
		var_0_107.misc.log_damage:depend(true, {
			var_0_127.misc.logs.on,
			false
		})
	end

	var_282_10:run()

	local var_282_11 = {}

	var_282_11.aspect = {
		active = false,
		value = var_0_93 / var_0_94,
		init = var_0_93 / var_0_94,
		activate = function()
			var_282_11.aspect.active = true
		end,
		work = function()
			local var_321_0 = var_282_11.aspect
			local var_321_1 = var_0_127.visuals.aspect

			if not var_321_0.active then
				return
			end

			if var_321_1.on.value then
				local var_321_2 = var_321_1.ratio.value * 0.01

				var_321_0.value = var_0_100.lerp(var_321_0.value, var_321_2, 8, 0.001)
				var_321_0.active = var_321_2 ~= var_321_0.value

				cvar.r_aspectratio:set_float(var_321_0.value)
			else
				var_321_0.value = var_0_100.lerp(var_321_0.value, var_321_0.init)

				cvar.r_aspectratio:set_float(var_321_0.value)

				if var_321_0.value == var_321_0.init then
					var_0_78.paint_ui:unset(var_321_0.work)
					cvar.r_aspectratio:set_float(0)

					var_321_0.active = false
				end
			end
		end,
		run = function(arg_322_0)
			local var_322_0 = var_0_127.visuals.aspect

			var_322_0.on:set_callback(function(arg_323_0)
				arg_322_0.active = true

				if arg_323_0.value then
					var_0_78.paint_ui:set(arg_322_0.work)
				end
			end, true)
			var_322_0.ratio:set_callback(arg_322_0.activate, true)
			var_0_3(function()
				cvar.r_aspectratio:set_float(0)
			end)
		end
	}
	var_282_11.marker = {
		duration = 2,
		list = {},
		marker = function(arg_325_0, arg_325_1, arg_325_2)
			local var_325_0, var_325_1 = renderer.world_to_screen(arg_325_0.x, arg_325_0.y, arg_325_0.z)

			if var_325_0 and var_325_1 then
				local var_325_2, var_325_3 = var_325_0 / var_0_92, var_325_1 / var_0_92

				if arg_325_2 then
					local var_325_4 = 32 * arg_325_1

					var_0_99.circle(var_325_2, var_325_3, var_0_91.accent:alphen(1 - arg_325_1, true), var_325_4)
				end

				var_0_99.texture(var_0_102.mini_bfly, var_325_2 - 5, var_325_3 - 5, 9, 9, var_0_91.accent)
			end
		end,
		work = function()
			local var_326_0 = var_282_11.marker

			for iter_326_0, iter_326_1 in var_0_9(var_326_0.list) do
				local var_326_1 = iter_326_1.time > globals.realtime()
				local var_326_2 = var_0_100.condition(iter_326_1.progress, var_326_1, {
					3,
					-4
				}, {
					{
						1,
						4
					},
					{
						3,
						4
					}
				})

				var_0_99.push_alpha(var_326_2)
				var_326_0.marker(iter_326_1, var_326_2, var_326_1)
				var_0_99.pop_alpha()

				if not var_326_1 and var_326_2 == 0 then
					table.remove(var_326_0.list, iter_326_0)
				end
			end
		end,
		append = {
			temp = {},
			function(arg_327_0)
				var_282_11.marker.append.temp[arg_327_0.id] = {
					x = arg_327_0.x,
					y = arg_327_0.y,
					z = arg_327_0.z
				}
			end,
			function(arg_328_0)
				local var_328_0 = var_282_11.marker
				local var_328_1 = var_328_0.append.temp[arg_328_0.id]

				table.insert(var_328_0.list, 1, {
					x = var_328_1.x,
					y = var_328_1.y,
					z = var_328_1.z,
					time = globals.realtime() + var_328_0.duration,
					progress = {
						0
					}
				})

				var_328_0.append.temp[arg_328_0.id] = nil
			end,
			function(arg_329_0)
				var_282_11.marker.append.temp[arg_329_0.id] = nil
			end
		},
		run = function(arg_330_0)
			local var_330_0 = var_0_127.visuals.marker

			var_330_0:set_event("aim_fire", arg_330_0.append[1])
			var_330_0:set_event("aim_hit", arg_330_0.append[2])
			var_330_0:set_event("aim_miss", arg_330_0.append[3])
			var_330_0:set_event("paint", arg_330_0.work)
		end
	}

	for iter_282_2, iter_282_3 in var_0_11, var_282_11 do
		iter_282_3:run()
	end

	local var_282_12 = {}

	var_282_12.teleport = {
		active = false,
		latest = 0,
		work = function(arg_331_0, arg_331_1)
			var_282_12.teleport.active = var_0_127.rage.teleport.on.hotkey:get()

			if not var_282_12.teleport.active or var_0_113.exploit.active ~= var_0_109.exploit.DT then
				return
			end

			local var_331_0 = false
			local var_331_1 = var_282_12.teleport
			local var_331_2 = var_0_127.rage.teleport
			local var_331_3 = var_0_107.misc.settings.maxshift.value - var_0_107.rage.aimbot.dt_fl[1].value + 1

			var_331_1.active = var_331_1.active and not (var_331_3 < 8) and var_331_1.latest ~= arg_331_0.command_number and not (var_0_113.velocity < 100) and not not var_0_113.jumping

			if not var_331_1.active then
				return
			end

			local var_331_4 = var_0_113.weapon_t

			if not var_331_4 then
				return
			end

			local var_331_5 = var_331_4.weapon_type_int

			var_331_1.active = var_331_1.active and not var_331_4.is_full_auto and var_331_5 ~= 9 and var_331_5 ~= 0 and (not not var_331_2.pistol.value or var_331_5 ~= 1)

			if not var_331_1.active then
				return
			end

			local var_331_6 = var_0_107.rage.aimbot.damage_ovr[1].value and var_0_107.rage.aimbot.damage_ovr[1]:get_hotkey() and var_0_107.rage.aimbot.damage_ovr[2].value or var_0_107.rage.aimbot.damage.value
			local var_331_7 = var_0_50(entity.get_prop(var_0_113.self, "m_vecVelocity"))
			local var_331_8 = var_0_50(entity.get_prop(var_0_113.self, "m_vecOrigin"))
			local var_331_9 = var_0_50(client.eye_position())
			local var_331_10 = var_0_50(client.extrapolate(var_331_9.x, var_331_9.y, var_331_9.z, var_331_7, var_331_3))
			local var_331_11 = client.trace_line(var_0_113.self, var_331_9.x, var_331_9.y, var_331_9.z, var_331_10.x, var_331_10.y, var_331_10.z)

			var_331_10.x = math.lerp(var_331_9.x, var_331_10.x, var_331_11)
			var_331_10.y = math.lerp(var_331_9.y, var_331_10.y, var_331_11)
			var_331_10.z = math.lerp(var_331_9.z, var_331_10.z, var_331_11)

			local var_331_12 = client.current_threat()

			for iter_331_0 = 1, #var_0_114 do
				local var_331_13 = var_0_114[iter_331_0]

				if not var_331_13 or not entity.is_enemy(var_331_13) or not entity.is_alive(var_331_13) then
					-- block empty
				elseif var_331_8:dist(var_0_50(entity.get_prop(var_331_13, "m_vecOrigin"))) < 400 or var_331_13 == var_331_12 then
					local var_331_14 = var_0_50(entity.hitbox_position(var_331_13, 0))

					if client.visible(var_331_14.x, var_331_14.y, var_331_14.z) then
						var_331_0 = true

						break
					end

					local var_331_15 = {
						client.trace_bullet(var_0_113.self, var_331_10.x, var_331_10.y, var_331_10.z, var_331_14.x, var_331_14.y, var_331_14.z)
					}
					local var_331_16 = var_331_15[2] or 0
					local var_331_17 = math.min(var_331_6, entity.get_prop(var_331_13, "m_iHealth"))

					if var_331_15[1] and var_331_17 < var_331_16 then
						var_331_0 = true

						break
					end
				end
			end

			if var_331_0 then
				if var_331_2.land.value then
					local var_331_18 = var_0_113.crouching and var_331_4.recovery_time_crouch or var_331_4.recovery_time_stand
					local var_331_19 = var_0_50(client.extrapolate(var_331_8.x, var_331_8.y, var_331_8.z, var_331_7, var_331_3))

					var_331_19.z = var_331_19.z - var_331_18

					if not (client.trace_line(var_0_113.self, var_331_8.x, var_331_8.y, var_331_8.z, var_331_19.x, var_331_19.y, var_331_19.z) < 1) then
						return
					end
				end

				var_331_1.latest = arg_331_0.command_number
				arg_331_0.discharge_pending = true
			end
		end,
		run = function(arg_332_0)
			var_0_127.rage.teleport.on:set_callback(function(arg_333_0)
				var_0_78.setup_command(arg_333_0.value, arg_332_0.work)
			end, true)
		end
	}
	var_282_12.resolver = {
		records = {},
		gather = function(arg_334_0, arg_334_1)
			local var_334_0, var_334_1 = entity.get_prop(arg_334_0, "m_angEyeAngles")

			return {
				time = arg_334_1,
				pos = entity.get_prop(arg_334_0, "m_flPoseParameter", 11) * 120 - 60,
				pitch = var_334_0,
				yaw = var_334_1
			}
		end,
		work = function()
			local var_335_0 = var_282_12.resolver

			client.update_player_list()

			for iter_335_0 = 1, #var_0_114 do
				local var_335_1 = var_0_114[iter_335_0]
				local var_335_2 = entity.get_steam64(var_0_114[iter_335_0])

				if entity.is_enemy(var_335_1) and var_335_2 then
					local var_335_3, var_335_4 = entity.get_simtime(var_335_1)
					local var_335_5, var_335_6 = var_0_22(var_335_3), var_0_22(var_335_4)
					local var_335_7 = var_335_0.records[var_335_2]
					local var_335_8 = var_335_0.gather(var_335_1, var_335_5)
					local var_335_9

					var_335_9 = var_335_7 and var_335_7.prev

					if not var_335_7 then
						var_335_0.records[var_335_2] = {
							diff = var_335_5 - var_335_6,
							prev = var_335_8
						}
						var_335_7 = var_335_0.records[var_335_2]

						local var_335_10 = var_335_7.prev
					else
						var_335_7.diff = var_335_5 - var_335_6
					end

					local var_335_11

					if var_335_7 ~= nil and var_335_7.diff >= 0 and var_335_7.diff <= 2 and not entity.is_lethal(var_335_1) then
						local var_335_12 = entity.get_animstate(var_335_1)
						local var_335_13 = math.normalize_yaw(var_335_8.yaw - var_335_12.goal_feet_yaw)

						var_335_8.gfy = var_335_12.goal_feet_yaw

						if var_335_13 ~= 0 then
							var_335_11 = (var_335_13 > 0 and -1 or 1) * entity.get_max_desync(var_335_12)

							if var_335_11 then
								plist.set(var_335_1, "Force body yaw value", var_335_11)
							end
						end
					end

					var_335_7.active = var_335_11 ~= nil

					plist.set(var_335_1, "Force body yaw", var_335_11 ~= nil)
					plist.set(var_335_1, "Correction active", true)

					var_335_7.prev = var_335_8
				else
					plist.set(var_335_1, "Correction active", false)
				end
			end
		end,
		refresh = function()
			table.clear(var_282_12.resolver.records)
		end,
		restore = function()
			local var_337_0 = var_282_12.resolver

			for iter_337_0 = 1, 64 do
				plist.set(iter_337_0, "Force body yaw", false)
			end

			var_337_0.records = {}
		end,
		debug = function()
			local var_338_0 = var_282_12.resolver

			for iter_338_0 = 1, #var_0_114 do
				local var_338_1 = var_0_114[iter_338_0]
				local var_338_2 = entity.get_steam64(var_0_114[iter_338_0])
				local var_338_3 = var_338_0.records[var_338_2]
				local var_338_4, var_338_5, var_338_6, var_338_7, var_338_8 = entity.get_bounding_box(var_338_1)

				if var_338_3 and var_338_8 > 0 then
					var_0_99.text(math.lerp(var_338_4, var_338_6, 0.5), var_338_5 - 18, var_0_91.text, "c", nil, "diff: ", var_338_3.diff)
				end
			end
		end,
		run = function(arg_339_0)
			var_0_127.rage.resolver:set_callback(function(arg_340_0)
				var_0_78.predict_command(arg_340_0.value, arg_339_0.work)
				var_0_78.round_start(arg_340_0.value, arg_339_0.refresh)

				if not arg_340_0.value then
					arg_339_0.restore()
				end
			end)
			var_0_78.shutdown(arg_339_0.restore)
		end
	}
	var_282_12.exswitch = {
		ovr = false,
		latest = false,
		work = function(arg_341_0)
			local var_341_0 = var_282_12.exswitch
			local var_341_1 = var_0_127.rage.exswitch
			local var_341_2 = var_0_107.rage.aimbot.double_tap[1].hotkey:get()
			local var_341_3 = var_0_107.aa.other.onshot.hotkey:get()
			local var_341_4 = var_0_107.rage.other.peek.value and var_0_107.rage.other.peek.hotkey:get()
			local var_341_5 = (not var_0_113.walking and not (var_0_113.velocity < 5) or not not var_341_4) and not var_0_113.crouching
			local var_341_6 = false
			local var_341_7 = var_0_113.weapon_t

			if var_341_7 then
				local var_341_8 = entity.get_prop(var_0_113.weapon, "m_iItemDefinitionIndex")
				local var_341_9

				var_341_6, var_341_9 = var_341_7.is_full_auto, var_341_8 == 1

				if var_341_7.weapon_type_int == 1 and not var_341_9 and not var_341_1.allow:get("Pistols") or var_341_9 and not var_341_1.allow:get("Desert Eagle") then
					var_341_6 = true
				end
			end

			if var_0_113.on_ground and var_341_2 and not var_341_6 and not var_341_5 and arg_341_0.weaponselect == 0 then
				var_0_107.rage.aimbot.double_tap[1]:override(false)
				var_0_107.aa.other.onshot.hotkey:override({
					"Always on",
					0
				})

				var_341_0.ovr = true
			elseif var_341_0.ovr then
				var_0_107.rage.aimbot.double_tap[1]:override()
				var_0_107.rage.aimbot.double_tap[1]:set(true)
				var_0_107.aa.other.onshot.hotkey:override()

				var_341_0.ovr = false
			end
		end,
		run = function(arg_342_0)
			var_0_127.rage.exswitch.on:set_event("setup_command", arg_342_0.work)
			var_0_127.rage.exswitch.on:set_callback(function(arg_343_0)
				if not arg_343_0.value then
					var_0_107.rage.aimbot.double_tap[1]:override()
					var_0_107.aa.other.onshot.hotkey:override()
				end
			end)
			var_0_78.shutdown:set(function()
				var_0_107.rage.aimbot.double_tap[1]:override()
				var_0_107.aa.other.onshot.hotkey:override()
			end)
		end
	}
	var_282_12.recharger = {
		last = false,
		state = false,
		work = function(arg_345_0)
			local var_345_0 = var_282_12.recharger
			local var_345_1 = var_0_107.rage.aimbot.double_tap[1].value and var_0_107.rage.aimbot.double_tap[1].hotkey:get() or var_0_107.aa.other.onshot.value and var_0_107.aa.other.onshot.hotkey:get()

			if var_345_1 ~= var_345_0.last then
				var_345_0.last = var_345_1

				if var_345_0.last then
					var_345_0.state = false
				end
			end

			if var_0_107.rage.aimbot.enable.value == false then
				var_0_107.rage.aimbot.enable.hotkey:override()

				var_345_0.state = nil
			end

			if var_345_0.state == false and arg_345_0.weaponselect == 0 then
				var_0_107.rage.aimbot.enable.hotkey:override({
					"On Hotkey",
					0
				})

				var_345_0.state = true
			elseif var_345_0.state == true or arg_345_0.weaponselect ~= 0 then
				var_0_107.rage.aimbot.enable.hotkey:override()
				var_0_107.rage.aimbot.enable.hotkey:set("Always On", 0)

				var_345_0.state = nil
			end
		end,
		run = function(arg_346_0)
			var_0_127.rage.recharge:set_event("setup_command", arg_346_0.work)
			var_0_127.rage.recharge:set_callback(function(arg_347_0)
				if arg_347_0.value then
					-- block empty
				elseif arg_346_0.state ~= nil then
					var_0_107.rage.aimbot.enable.hotkey:override()
					var_0_107.rage.aimbot.enable.hotkey:set("Always On", 0)

					arg_346_0.state = nil
				end
			end)
		end
	}
	var_282_12.peekfix = {
		work = function(arg_348_0)
			if var_0_113.exploit.active ~= var_0_109.exploit.DT then
				return
			end

			if var_0_113.peeking then
				arg_348_0.force_defensive = true
			end
		end,
		run = function(arg_349_0)
			var_0_127.rage.peekfix:set_callback(function(arg_350_0)
				var_0_78.setup_command(arg_350_0.value, arg_349_0.work)
			end, true)
		end
	}

	for iter_282_4, iter_282_5 in var_0_10(var_282_12) do
		if iter_282_5.run then
			iter_282_5:run()
		end
	end

	function var_0_99.logo(arg_351_0, arg_351_1)
		var_0_99.texture(var_0_102.logo_l, arg_351_0, arg_351_1, _AZAZI and 35 or 26, 15, var_0_91.accent)
		var_0_99.texture(var_0_102.logo_r, arg_351_0 + (_AZAZI and 35 or 26), arg_351_1, _AZAZI and 35 or 24, 15, var_0_91.text)
	end

	function var_0_99.edge_v(arg_352_0, arg_352_1, arg_352_2, arg_352_3)
		arg_352_3 = arg_352_3 or var_0_91.accent

		var_0_99.texture(var_0_102.corner_v, arg_352_0, arg_352_1 + 4, 6, -4, arg_352_3, "f")
		var_0_99.rectangle(arg_352_0, arg_352_1 + 4, 2, arg_352_2 - 8, arg_352_3)
		var_0_99.texture(var_0_102.corner_v, arg_352_0, arg_352_1 + arg_352_2 - 4, 6, 4, arg_352_3, "f")
	end

	function var_0_99.edge_h(arg_353_0, arg_353_1, arg_353_2, arg_353_3)
		arg_353_3 = arg_353_3 or var_0_91.accent

		var_0_99.texture(var_0_102.corner_h, arg_353_0, arg_353_1, 4, 6, arg_353_3, "f")
		var_0_99.rectangle(arg_353_0 + 4, arg_353_1, arg_353_2 - 8, 2, arg_353_3)
		var_0_99.texture(var_0_102.corner_h, arg_353_0 + arg_353_2, arg_353_1, -4, 6, arg_353_3, "f")
	end

	function var_0_99.capsule(arg_354_0, arg_354_1, arg_354_2, arg_354_3, arg_354_4)
		arg_354_0, arg_354_1, arg_354_2, arg_354_3 = arg_354_0 * var_0_92, arg_354_1 * var_0_92, arg_354_2 * var_0_92, arg_354_3 * var_0_92

		local var_354_0 = arg_354_4.r
		local var_354_1 = arg_354_4.g
		local var_354_2 = arg_354_4.b
		local var_354_3 = arg_354_4.a * var_0_99.get_alpha()
		local var_354_4 = arg_354_3 * 0.5

		renderer.circle(arg_354_0 + var_354_4, arg_354_1 + var_354_4, var_354_0, var_354_1, var_354_2, var_354_3, var_354_4, 180, 0.5)
		renderer.rectangle(arg_354_0 + var_354_4, arg_354_1, arg_354_2 - arg_354_3, arg_354_3, var_354_0, var_354_1, var_354_2, var_354_3)
		renderer.circle(arg_354_0 + arg_354_2 - var_354_4, arg_354_1 + var_354_4, var_354_0, var_354_1, var_354_2, var_354_3, var_354_4, 0, 0.5)
	end

	function var_0_99.rounded_side_v(arg_355_0, arg_355_1, arg_355_2, arg_355_3, arg_355_4, arg_355_5)
		arg_355_0, arg_355_1, arg_355_2, arg_355_3, arg_355_5 = arg_355_0 * var_0_92, arg_355_1 * var_0_92, arg_355_2 * var_0_92, arg_355_3 * var_0_92, (arg_355_5 or 0) * var_0_92

		local var_355_0 = arg_355_4.r
		local var_355_1 = arg_355_4.g
		local var_355_2 = arg_355_4.b
		local var_355_3 = arg_355_4.a * var_0_99.get_alpha()

		renderer.circle(arg_355_0 + arg_355_5, arg_355_1 + arg_355_5, var_355_0, var_355_1, var_355_2, var_355_3, arg_355_5, 180, 0.25)
		renderer.rectangle(arg_355_0 + arg_355_5, arg_355_1, arg_355_2 - arg_355_5, arg_355_5, var_355_0, var_355_1, var_355_2, var_355_3)
		renderer.rectangle(arg_355_0, arg_355_1 + arg_355_5, arg_355_2, arg_355_3 - arg_355_5 - arg_355_5, var_355_0, var_355_1, var_355_2, var_355_3)
		renderer.circle(arg_355_0 + arg_355_5, arg_355_1 + arg_355_3 - arg_355_5, var_355_0, var_355_1, var_355_2, var_355_3, arg_355_5, 270, 0.25)
		renderer.rectangle(arg_355_0 + arg_355_5, arg_355_1 + arg_355_3 - arg_355_5, arg_355_2 - arg_355_5, arg_355_5, var_355_0, var_355_1, var_355_2, var_355_3)
	end

	function var_0_99.rounded_side_h(arg_356_0, arg_356_1, arg_356_2, arg_356_3, arg_356_4, arg_356_5)
		arg_356_0, arg_356_1, arg_356_2, arg_356_3, arg_356_5 = arg_356_0 * var_0_92, arg_356_1 * var_0_92, arg_356_2 * var_0_92, arg_356_3 * var_0_92, (arg_356_5 or 0) * var_0_92

		local var_356_0 = arg_356_4.r
		local var_356_1 = arg_356_4.g
		local var_356_2 = arg_356_4.b
		local var_356_3 = arg_356_4.a * var_0_99.get_alpha()

		renderer.circle(arg_356_0 + arg_356_5, arg_356_1 + arg_356_5, var_356_0, var_356_1, var_356_2, var_356_3, arg_356_5, 180, 0.25)
		renderer.rectangle(arg_356_0 + arg_356_5, arg_356_1, arg_356_2 - arg_356_5 - arg_356_5, arg_356_5, var_356_0, var_356_1, var_356_2, var_356_3)
		renderer.circle(arg_356_0 + arg_356_2 - arg_356_5, arg_356_1 + arg_356_5, var_356_0, var_356_1, var_356_2, var_356_3, arg_356_5, 90, 0.25)
		renderer.rectangle(arg_356_0, arg_356_1 + arg_356_5, arg_356_2, arg_356_3 - arg_356_5, var_356_0, var_356_1, var_356_2, var_356_3)
	end

	local var_282_13 = var_0_106.new("crosshair", var_0_97.x - 24, var_0_97.y + 32, 48, 16, {
		border = {
			var_0_98.x,
			var_0_98.y - 100,
			var_0_98.x,
			var_0_98.y + 100
		},
		rulers = {
			{
				true,
				var_0_98.x,
				var_0_98.y - 100,
				200
			}
		}
	})

	var_282_13.data, var_282_13.items = {
		scope = {
			reserved = false,
			side = 0,
			target = 0
		}
	}, {}

	function var_282_13.enumerate(arg_357_0)
		local var_357_0 = var_0_97.x
		local var_357_1 = arg_357_0.y
		local var_357_2 = var_0_100.condition("crosshair::yposition", arg_357_0.y > var_0_97.y, 3) * 2 - 1
		local var_357_3 = var_282_13.data.scope.side
		local var_357_4 = var_357_3 * 0.5 + 0.5

		for iter_357_0, iter_357_1 in var_0_9(arg_357_0.items) do
			iter_357_1[0] = iter_357_1[0] or {
				0
			}

			var_0_99.push_alpha(iter_357_1[1])

			local var_357_5, var_357_6, var_357_7 = iter_357_1[2](iter_357_1, var_357_0 + iter_357_1.x, var_357_1)

			var_0_99.pop_alpha()

			iter_357_1[1] = var_0_100.condition(iter_357_1[0], var_357_5, -8)
			iter_357_1.x = var_357_6 * -var_357_4 - var_357_3 * 16
			var_357_1 = var_357_1 + var_357_7 * iter_357_1[1] * var_357_2
		end

		return math.abs(var_357_1 - arg_357_0.y)
	end

	var_282_13.items = {
		{
			0,
			function(arg_358_0, arg_358_1, arg_358_2)
				if arg_358_0[1] > 0 then
					local var_358_0 = var_0_100.condition(arg_358_0.bfly, var_0_127.visuals.crosshair.logo.value, -8)

					if var_358_0 > 0 then
						var_0_99.texture(var_0_102.butterfly_s, arg_358_1 - 3, arg_358_2 - 10, 32, 32, var_0_91.accent:alphen(255 * var_358_0), "f")
					end

					var_0_99.logo(arg_358_1, arg_358_2)
				end

				return var_0_127.visuals.crosshair.style.value == "Classic", _AZAZI and 66 or 48, 15
			end,
			desync = 0,
			x = 0,
			bfly = {
				0
			}
		},
		{
			0,
			function(arg_359_0, arg_359_1, arg_359_2)
				local var_359_0 = var_0_127.visuals.crosshair.logo.value
				local var_359_1 = "HYSTERIA" .. (not var_359_0 and var_0_67 > 1 and var_0_91.hexs .. string.format("%02x", var_0_99.get_alpha() * 255) .. string.upper(var_0_65.build) or "")
				local var_359_2, var_359_3 = var_0_99.measure_text("-", var_359_1)

				if var_0_127.visuals.crosshair.logo.value then
					var_359_2 = var_359_2 + 7
				end

				if arg_359_0[1] > 0 then
					var_0_99.text(arg_359_1, arg_359_2, var_0_91.text, "-", nil, var_359_1)

					if var_0_127.visuals.crosshair.logo.value then
						var_0_99.texture(var_0_102.mini_bfly, arg_359_1 + var_359_2 - 6, arg_359_2 + 1, 9, 9, var_0_91.accent)
					end
				end

				return var_0_127.visuals.crosshair.style.value == "Mini", var_359_2, var_359_3 + 3
			end,
			x = 0,
			desync = 0
		},
		{
			0,
			function(arg_360_0, arg_360_1, arg_360_2)
				local var_360_0 = var_0_107.rage.aimbot.double_tap[1].value and var_0_107.rage.aimbot.double_tap[1].hotkey:get()

				if arg_360_0[1] > 0 then
					local var_360_1 = var_0_113.exploit.lc_left > 0 and 14 or var_0_46.get_tickbase_shifting()
					local var_360_2 = var_0_46.get_double_tap() or var_0_113.exploit.lc_left > 0
					local var_360_3 = var_0_100.condition(arg_360_0.fd, not var_0_107.rage.other.duck:get(), -8)
					local var_360_4 = var_0_91.hexs .. string.format("%02x", var_0_99.get_alpha() * 255) .. string.insert("llllll", string.format("\aFFFFFF%02x", (var_360_2 and 96 or 64) * var_0_99.get_alpha()), math.min(var_360_1 * 0.5, 6))
					local var_360_5 = "DT " .. var_360_4

					var_0_99.text(arg_360_1, arg_360_2, var_0_91.text:alphen(math.lerp(96, 255, var_360_3)), "-", nil, var_360_5)
				end

				return var_360_0, var_0_99.measure_text("-", "DT llllll")
			end,
			x = 0,
			fd = {
				0
			}
		},
		{
			0,
			function(arg_361_0, arg_361_1, arg_361_2)
				local var_361_0 = not var_0_127.visuals.damage.value and var_0_107.rage.aimbot.damage_ovr[1].value and var_0_107.rage.aimbot.damage_ovr[1].hotkey:get()
				local var_361_1 = "DMG"

				if arg_361_0[1] > 0 then
					var_0_99.text(arg_361_1, arg_361_2, var_0_91.text, "-", nil, var_361_1)
				end

				return var_361_0, var_0_99.measure_text("-", var_361_1)
			end,
			x = 0
		},
		{
			0,
			function(arg_362_0, arg_362_1, arg_362_2)
				local var_362_0 = var_0_107.rage.other.peek.value and var_0_107.rage.other.peek.hotkey:get()
				local var_362_1 = var_0_46.get_double_tap()
				local var_362_2 = "PA" .. (var_362_1 and "+" or "")

				if arg_362_0[1] > 0 then
					local var_362_3 = var_0_100.condition(arg_362_0.ideal, var_362_1, -8)

					var_0_99.text(arg_362_1, arg_362_2, var_0_91.text:lerp(var_0_91.accent, var_362_3), "-", nil, var_362_2)
				end

				return var_362_0, var_0_99.measure_text("-", var_362_2)
			end,
			x = 0,
			ideal = {
				0
			}
		},
		{
			0,
			function(arg_363_0, arg_363_1, arg_363_2)
				local var_363_0, var_363_1 = var_0_127.rage.teleport.on.hotkey:get()
				local var_363_2 = var_0_127.rage.teleport.on.value and var_363_0 and var_363_1 ~= 0
				local var_363_3 = "TP"

				if arg_363_0[1] > 0 then
					local var_363_4 = var_0_100.condition(arg_363_0.ideal, var_282_12.teleport.active, -8)

					var_0_99.text(arg_363_1, arg_363_2, var_0_91.text:lerp(var_0_91.accent, var_363_4), "-", nil, var_363_3)
				end

				return var_363_2, var_0_99.measure_text("-", var_363_3)
			end,
			x = 0,
			ideal = {
				0
			}
		},
		{
			0,
			function(arg_364_0, arg_364_1, arg_364_2)
				local var_364_0 = var_0_107.aa.other.onshot.value and var_0_107.aa.other.onshot:get_hotkey()
				local var_364_1 = "OS"

				if arg_364_0[1] > 0 then
					local var_364_2 = var_0_107.rage.aimbot.double_tap[1].value and var_0_107.rage.aimbot.double_tap[1]:get_hotkey()
					local var_364_3 = var_0_100.condition(arg_364_0.a1, not var_364_2, 8)

					var_0_99.text(arg_364_1, arg_364_2, var_0_91.text:alphen(math.lerp(96, 255, var_364_3)), "-", nil, var_364_1)
				end

				return var_364_0, var_0_99.measure_text("-", var_364_1)
			end,
			x = 0,
			a1 = {
				0
			}
		},
		{
			0,
			function(arg_365_0, arg_365_1, arg_365_2)
				local var_365_0 = var_0_107.rage.aimbot.force_baim:get()
				local var_365_1 = "BA"

				if arg_365_0[1] > 0 then
					var_0_99.text(arg_365_1, arg_365_2, var_0_91.text, "-", nil, var_365_1)
				end

				return var_365_0, var_0_99.measure_text("-", var_365_1)
			end,
			x = 0
		},
		{
			0,
			function(arg_366_0, arg_366_1, arg_366_2)
				local var_366_0 = var_0_107.rage.aimbot.force_sp:get()
				local var_366_1 = "SP"

				if arg_366_0[1] > 0 then
					var_0_99.text(arg_366_1, arg_366_2, var_0_91.text, "-", nil, var_366_1)
				end

				return var_366_0, var_0_99.measure_text("-", var_366_1)
			end,
			x = 0
		},
		{
			0,
			function(arg_367_0, arg_367_1, arg_367_2)
				local var_367_0 = var_0_107.aa.angles.freestand.value and var_0_107.aa.angles.freestand:get_hotkey()
				local var_367_1 = "FS"

				if arg_367_0[1] > 0 then
					var_0_99.text(arg_367_1, arg_367_2, var_0_91.text, "-", nil, var_367_1)
				end

				return var_367_0, var_0_99.measure_text("-", var_367_1)
			end,
			x = 0
		},
		{
			0,
			function(arg_368_0, arg_368_1, arg_368_2)
				local var_368_0, var_368_1 = var_0_107.misc.ping_spike.hotkey:get()
				local var_368_2 = var_0_107.misc.ping_spike.value and var_368_0 and var_368_1 ~= 0
				local var_368_3 = "PS"

				if arg_368_0[1] > 0 then
					var_0_99.text(arg_368_1, arg_368_2, var_0_91.text, "-", nil, var_368_3)
				end

				return var_368_2, var_0_99.measure_text("-", var_368_3)
			end,
			x = 0
		},
		{
			0,
			function(arg_369_0, arg_369_1, arg_369_2)
				local var_369_0 = var_0_107.rage.other.duck:get()
				local var_369_1 = "FD"

				if arg_369_0[1] > 0 then
					local var_369_2 = var_0_113.valid and entity.get_prop(var_0_113.self, "m_flDuckAmount") or 0

					var_0_99.text(arg_369_1, arg_369_2, var_0_91.text:lerp(var_0_91.accent, var_369_2), "-", nil, var_369_1)
				end

				return var_369_0, var_0_99.measure_text("-", var_369_1)
			end,
			x = 0
		}
	}

	function var_282_13.update(arg_370_0)
		if var_0_113.valid and entity.get_prop(var_0_113.self, "m_bIsScoped") == 1 then
			if not arg_370_0.data.scope.reserved and var_0_113.side ~= 0 then
				arg_370_0.data.scope.target, arg_370_0.data.scope.reserved = -var_0_113.side, true
			end
		else
			arg_370_0.data.scope.target, arg_370_0.data.scope.reserved = 0, false
		end

		arg_370_0.data.scope.side = var_0_100.lerp(var_282_13.data.scope.side, var_282_13.data.scope.target, 12)

		return var_0_100.condition(var_282_13.progress, var_0_127.visuals.crosshair.on.value and var_0_113.valid and not var_0_113.in_score)
	end

	function var_282_13.paint(arg_371_0, arg_371_1, arg_371_2, arg_371_3, arg_371_4)
		var_282_13:enumerate()
	end

	local var_282_14 = {
		watermark = var_0_106.new("watermark", var_0_93 - 24, 24, 160, 24, {
			rulers = {
				{
					true,
					var_0_98.x,
					0,
					var_0_96
				},
				{
					false,
					0,
					var_0_96 - 32,
					var_0_95
				},
				{
					false,
					0,
					32,
					var_0_95
				}
			},
			on_release = function(arg_372_0, arg_372_1)
				local var_372_0 = var_0_93 / 3
				local var_372_1 = arg_372_0.x + arg_372_0.w * 0.5
				local var_372_2 = math.floor(var_372_1 / var_372_0)

				if var_372_2 == arg_372_0.align then
					return
				end

				arg_372_0.align = var_372_2

				if arg_372_0.align == 1 then
					arg_372_0:set_position(var_372_1)

					arg_372_0.x = arg_372_0.x - arg_372_0.w * 0.5
				elseif arg_372_0.align == 2 then
					arg_372_0:set_position(arg_372_0.x + arg_372_0.w)

					arg_372_0.x = arg_372_0.x - arg_372_0.w
				end

				arg_372_1.config.a:set(var_372_2)
			end,
			on_held = function(arg_373_0, arg_373_1)
				arg_373_0.align = 0

				arg_373_1.config.a:set(0)
			end
		})
	}

	var_282_14.watermark.align, var_282_14.watermark.logop, var_282_14.watermark.logo = 2, {
		0
	}, 0
	var_282_14.watermark.__drag.config.a = var_0_44.slider("MISC", "Settings", "watermark:align", 0, 2, var_282_14.watermark.align)

	var_282_14.watermark.__drag.config.a:set_visible(false)
	var_282_14.watermark.__drag.config.a:set_callback(function(arg_374_0)
		var_282_14.watermark.align = arg_374_0.value
	end, true)

	var_282_14.watermark.items = {
		{
			0,
			function(arg_375_0, arg_375_1, arg_375_2)
				local var_375_0 = var_0_127.visuals.water.name:get()
				local var_375_1 = string.format(var_0_65.build == "stable" and "%s" or "%s %s%02x— %s", var_375_0 ~= "" and var_375_0 or var_0_65.user, var_0_91.hexs, var_0_99.get_alpha() * arg_375_0[1] * 255, var_0_65.build)
				local var_375_2, var_375_3 = var_0_99.measure_text("", var_375_1)

				if arg_375_0[1] > 0 then
					var_0_99.blur(arg_375_1, arg_375_2 + 1, var_375_2 + 16, 22, 1, 8)
					var_0_99.rectangle(arg_375_1, arg_375_2 + 1, var_375_2 + 16, 22, var_0_91.panel.l1, 4)
					var_0_99.text(arg_375_1 + 8, arg_375_2 + 6, var_0_91.text, nil, nil, var_375_1)
				end

				return true, var_375_2 + 16
			end,
			{}
		},
		{
			0,
			function(arg_376_0, arg_376_1, arg_376_2)
				local var_376_0, var_376_1 = client.system_time()
				local var_376_2 = string.format("%02d:%02d", var_376_0, var_376_1)
				local var_376_3, var_376_4 = var_0_99.measure_text("", var_376_2)

				if arg_376_0[1] > 0 then
					var_0_99.blur(arg_376_1, arg_376_2 + 1, var_376_3 + 16, 22, 1, 8)
					var_0_99.rectangle(arg_376_1, arg_376_2 + 1, var_376_3 + 16, 22, var_0_91.panel.l1, 4)
					var_0_99.text(arg_376_1 + 8, arg_376_2 + 6, var_0_91.text, nil, nil, var_376_2)
				end

				return true, var_376_3 + 16
			end,
			{}
		},
		{
			0,
			function(arg_377_0, arg_377_1, arg_377_2)
				local var_377_0 = client.latency() * 1000
				local var_377_1 = string.format("%dms", var_377_0)
				local var_377_2, var_377_3 = var_0_99.measure_text("", var_377_1)

				if arg_377_0[1] > 0 then
					var_0_99.blur(arg_377_1, arg_377_2 + 1, var_377_2 + 16, 22, 1, 8)
					var_0_99.rectangle(arg_377_1, arg_377_2 + 1, var_377_2 + 16, 22, var_0_91.panel.l1, 4)
					var_0_99.text(arg_377_1 + 8, arg_377_2 + 6, var_0_91.text, nil, nil, var_377_1)
				end

				return var_377_0 > 5, var_377_2 + 16
			end,
			{}
		}
	}

	function var_282_14.watermark.enumerate(arg_378_0)
		local var_378_0 = arg_378_0.logo * 68

		for iter_378_0, iter_378_1 in var_0_9(arg_378_0.items) do
			var_0_99.push_alpha(iter_378_1[1])

			local var_378_1, var_378_2 = iter_378_1[2](iter_378_1, arg_378_0.x + var_378_0, arg_378_0.y)

			var_0_99.pop_alpha()

			iter_378_1[1] = var_0_100.condition(iter_378_1[3], var_378_1)
			var_378_0 = var_378_0 + (var_378_2 + 2) * iter_378_1[1]
		end

		arg_378_0.w = var_0_100.lerp(arg_378_0.w, var_378_0, nil, 0.5)
	end

	function var_282_14.watermark.update(arg_379_0)
		local var_379_0, var_379_1 = arg_379_0:get_position()

		if arg_379_0.align == 2 then
			arg_379_0.x = var_379_0 - arg_379_0.w * arg_379_0.alpha
		elseif arg_379_0.align == 1 then
			arg_379_0.x = var_379_0 - arg_379_0.w * 0.5
		end

		return var_0_100.condition(arg_379_0.progress, var_0_127.visuals.water.on.value, 3)
	end

	function var_282_14.watermark.paint(arg_380_0, arg_380_1, arg_380_2, arg_380_3, arg_380_4)
		arg_380_0.logo = var_0_100.condition(arg_380_0.logop, not var_0_127.visuals.water.hide.value)

		if arg_380_0.logo > 0 then
			local var_380_0 = 64

			var_0_99.push_alpha(arg_380_0.logo)
			var_0_99.blur(arg_380_1, arg_380_2, var_380_0, arg_380_4, 1, 8)
			var_0_99.rounded_side_v(arg_380_1, arg_380_2, var_380_0, arg_380_4, var_0_91.panel.g1, 4)
			var_0_99.rectangle(arg_380_1 + var_380_0, arg_380_2, 2, arg_380_4, var_0_91.panel.g1)
			var_0_99.logo(arg_380_1 + 8, arg_380_2 + 5)
			var_0_99.edge_v(arg_380_1 + var_380_0, arg_380_2, 24)
			var_0_99.pop_alpha()
		end

		arg_380_0:enumerate()
	end

	var_282_14.damage = var_0_106.new("damage", var_0_97.x + 4, var_0_97.y + 4, 6, 4, {
		border = {
			var_0_98.x - 40,
			var_0_98.y - 40,
			var_0_98.x + 40,
			var_0_98.y + 40,
			true
		}
	})
	var_282_14.damage.dmg = var_0_107.rage.aimbot.damage.value
	var_282_14.damage.ovr_alpha = 0
	var_282_14.damage.ovr_alpha_p = {
		0
	}

	function var_282_14.damage.update(arg_381_0)
		if not var_0_127.visuals.damage.value then
			return var_0_100.condition(arg_381_0.progress, false, -4)
		end

		local var_381_0 = var_0_107.rage.aimbot.damage_ovr[1].value and var_0_107.rage.aimbot.damage_ovr[1]:get_hotkey()
		local var_381_1 = var_381_0 and var_0_107.rage.aimbot.damage_ovr[2].value or var_0_107.rage.aimbot.damage.value

		arg_381_0.dmg = var_0_100.lerp(arg_381_0.dmg, var_381_1, 16)
		arg_381_0.ovr_alpha = var_0_100.condition(var_282_14.damage.ovr_alpha_p, var_381_0, -8)

		local var_381_2 = var_0_113.weapon_t
		local var_381_3 = var_381_2 and var_381_2.weapon_type_int ~= 9 and var_381_2.weapon_type_int ~= 0

		return var_0_100.condition(arg_381_0.progress, var_0_113.valid and (var_381_3 or var_0_44.menu_open) and not var_0_113.in_score and var_0_113.in_game, -8)
	end

	function var_282_14.damage.paint(arg_382_0, arg_382_1, arg_382_2, arg_382_3, arg_382_4)
		local var_382_0 = math.round(arg_382_0.dmg)

		var_382_0 = var_382_0 == 0 and "A" or var_382_0 > 100 and "+" .. var_382_0 - 100 or var_0_21(var_382_0)
		arg_382_0.w, arg_382_0.h = var_0_99.measure_text("-", var_382_0)
		arg_382_0.h, arg_382_0.w = arg_382_0.h - 3, arg_382_0.w + 1

		var_0_99.text(arg_382_1 - 1, arg_382_2 - 2, var_0_91.text:alphen(math.lerp(96, 255, arg_382_0.ovr_alpha)), "-", nil, var_382_0)
	end

	var_282_14.arrows = var_0_106.new("arrows", var_0_97.x - 32, var_0_97.y - 5, 10, 10, {
		border = {
			var_0_98.x - 120,
			var_0_98.y + 1,
			var_0_98.x - 10,
			var_0_98.y + 1
		},
		rulers = {
			{
				false,
				var_0_98.x - 120,
				var_0_98.y,
				110
			}
		}
	})
	var_282_14.arrows.leftp, var_282_14.arrows.rightp = {
		0
	}, {
		0
	}

	function var_282_14.arrows.update(arg_383_0)
		return var_0_100.condition(arg_383_0.progress, var_0_127.visuals.arrows.value and var_0_113.in_game and var_0_113.valid)
	end

	function var_282_14.arrows.paint(arg_384_0, arg_384_1, arg_384_2, arg_384_3, arg_384_4)
		local var_384_0 = var_0_44.menu_open and var_0_91.white:alphen(128) or var_0_91.null
		local var_384_1 = var_0_100.condition(var_282_14.arrows.leftp, var_0_133.data.manual_yaw == -90, 6)

		var_0_99.texture(var_0_102.manual, arg_384_1, arg_384_2, 10, 10, var_384_0:lerp(var_0_91.accent, var_384_1), "f")

		local var_384_2 = var_0_100.condition(var_282_14.arrows.rightp, var_0_133.data.manual_yaw == 90, 6)

		var_0_99.texture(var_0_102.manual, var_0_93 - arg_384_1 + 1, arg_384_2, -10, 10, var_384_0:lerp(var_0_91.accent, var_384_2), "f")
	end

	var_282_14.slowdown = var_0_106.new("slowdown", var_0_97.x - 60, var_0_97.y - 160, 120, 32, {
		rulers = {
			{
				true,
				var_0_98.x,
				0,
				var_0_96
			}
		}
	})
	var_282_14.slowdown.speed = 0.5

	function var_282_14.slowdown.update(arg_385_0)
		if not var_0_127.visuals.slowdown.value or not var_0_113.valid then
			return var_0_100.condition(arg_385_0.progress, false, -4)
		end

		arg_385_0.speed = entity.get_prop(var_0_113.self, "m_flVelocityModifier")

		return var_0_100.condition(arg_385_0.progress, var_0_44.menu_open or var_0_113.valid and arg_385_0.speed < 1, -8)
	end

	function var_282_14.slowdown.paint(arg_386_0, arg_386_1, arg_386_2, arg_386_3, arg_386_4)
		local var_386_0 = var_0_79.rgb(240, 60, 60):lerp(var_0_91.text, arg_386_0.speed)

		var_0_99.blur(arg_386_1 + 36, arg_386_2 + 1, arg_386_3 - 36, arg_386_4 - 2)
		var_0_99.rectangle(arg_386_1 + 36, arg_386_2 + 1, arg_386_3 - 36, arg_386_4 - 2, var_0_91.panel.l1, 4)
		var_0_99.blur(arg_386_1, arg_386_2, 32, arg_386_4, 1, 8)
		var_0_99.rounded_side_v(arg_386_1, arg_386_2, 32, arg_386_4, var_0_91.panel.g1, 4)
		var_0_99.rectangle(arg_386_1 + 32, arg_386_2, 2, arg_386_4, var_0_91.panel.g1)
		var_0_99.texture(var_0_102.warning, arg_386_1 + 8, arg_386_2 + 8, 16, 16, var_386_0)
		var_0_99.edge_v(arg_386_1 + 32, arg_386_2, arg_386_4)
		var_0_99.text(arg_386_1 + 44, arg_386_2 + 6, var_0_91.text:alphen((1 - arg_386_0.speed) * 196 + 64), nil, nil, "slowed")
		var_0_99.text(arg_386_1 + arg_386_3 - 8, arg_386_2 + 6, var_386_0, "r", nil, string.format("%d%%", arg_386_0.speed * 100))
		var_0_99.rectangle(arg_386_1 + 44, arg_386_2 + 21, 67, 2, var_0_91.white:alphen(32))
		var_0_99.rectangle(arg_386_1 + 44, arg_386_2 + 21, arg_386_0.speed * 67, 2, var_0_91.accent:alphen(arg_386_0.speed * 196 + 58))
	end

	var_282_14.logs = var_0_106.new("logs", var_0_97.x - 150, var_0_97.y + 160, 300, 32, {
		rulers = {
			{
				true,
				var_0_98.x,
				0,
				var_0_96
			}
		}
	})
	var_282_14.logs.align_p, var_282_14.logs.preview_p = {
		0
	}, {
		0
	}
	var_282_14.logs.preview, var_282_14.logs.dummy = false, {
		{
			text = "\aA3D350\x01•\aE6E6E6\x02 Killed\aE6E6E6\x02 \aE6E6E6\x02\aE6E6E6\x01maj0r\aE6E6E6\x02 in \aE6E6E6\x02\aE6E6E6\x01head\aE6E6E6\x02\aE6E6E6\x02",
			event = "hit",
			time = math.huge,
			progress = {
				0
			}
		},
		{
			text = "\aA67CCF\x01•\aE6E6E6\x02 Missed\aE6E6E6\x02 \aE6E6E6\x01enQ\aE6E6E6\x02's\aE6E6E6\x01 head\aE6E6E6\x02 due to \aE6E6E6\x01unpredicted occasion",
			event = "miss",
			time = math.huge,
			progress = {
				0
			}
		},
		{
			text = "\ad35050\x01•\aE6E6E6\x02 Harmed by\aE6E6E6\x02 \aE6E6E6\x01enQ\aE6E6E6\x02 in \aE6E6E6\x01head\aE6E6E6\x02 for \aE6E6E6\x0172",
			event = "harm",
			time = math.huge,
			progress = {
				0
			}
		}
	}

	function var_282_14.logs.update(arg_387_0)
		return var_0_100.condition(arg_387_0.progress, var_0_127.misc.logs.on.value and var_0_127.misc.logs.output:get("Screen") and var_0_113.in_game)
	end

	function var_282_14.logs.part(arg_388_0, arg_388_1, arg_388_2, arg_388_3, arg_388_4, arg_388_5)
		local var_388_0 = string.gsub(arg_388_1.text, "[\x01\x02]", {
			["\x01"] = string.format("%02x", arg_388_3 * var_0_99.get_alpha() * 255),
			["\x02"] = string.format("%02x", arg_388_3 * var_0_99.get_alpha() * 128)
		})
		local var_388_1, var_388_2 = var_0_99.measure_text("", var_388_0)
		local var_388_3 = math.lerp(arg_388_0.x + arg_388_0.w * 0.5 - var_388_1 * 0.5 - 18, arg_388_0.x, arg_388_0.align)
		local var_388_4 = arg_388_2

		if not arg_388_4 then
			var_388_3 = var_388_3 + (1 - arg_388_3) * (var_388_1 * 0.5) * (arg_388_5 % 2 == 0 and -1 or 1)
		end

		var_0_99.blur(var_388_3, var_388_4, 24, 24)
		var_0_99.rounded_side_v(var_388_3, var_388_4, 24, 24, var_0_91.panel.g1, 4)
		var_0_99.rectangle(var_388_3 + 24, var_388_4, 2, 24, var_0_91.panel.g1)
		var_0_99.edge_v(var_388_3 + 24, var_388_4, 24)
		var_0_99.blur(var_388_3 + 28, var_388_4 + 1, var_388_1 + 14, 22)
		var_0_99.rectangle(var_388_3 + 28, var_388_4 + 1, var_388_1 + 14, 22, var_0_91.panel.l1, 4)
		var_0_99.texture(var_0_102.mini_bfly, var_388_3 + 8, var_388_4 + 8, 9, 9, var_0_91.accent)
		var_0_99.text(var_388_3 + 35, var_388_4 + 5, var_0_91.text:alphen(128), nil, nil, var_388_0)
	end

	function var_282_14.logs.paint(arg_389_0, arg_389_1, arg_389_2, arg_389_3, arg_389_4)
		if not var_0_127.misc.logs.on.value then
			return
		end

		local var_389_0

		arg_389_0.align = var_0_100.condition(var_282_14.logs.align_p, arg_389_0.x < var_0_93 / 3)
		arg_389_0.preview = var_0_100.condition(var_282_14.logs.preview_p, var_0_44.menu_open and var_0_127.misc.logs.output:get("Screen") and #var_282_10.list == 0)
		arg_389_2 = arg_389_2 + 4

		local var_389_1 = arg_389_0.preview > 0 and arg_389_0.dummy or var_282_10.list

		for iter_389_0 = 1, #var_389_1 do
			local var_389_2 = var_389_1[iter_389_0]
			local var_389_3 = globals.realtime() - var_389_2.time < 4 and iter_389_0 < 10
			local var_389_4 = var_0_100.condition(var_389_2.progress, var_0_60(arg_389_0.preview > 0, arg_389_0.preview == 1, var_389_3))

			if var_389_4 == 0 then
				var_389_0 = iter_389_0
			end

			var_0_99.push_alpha(var_389_4)
			arg_389_0:part(var_389_2, arg_389_2, var_389_4, var_389_3, iter_389_0)
			var_0_99.pop_alpha()

			arg_389_2 = arg_389_2 + 28 * (var_389_3 and var_389_4 or 1)
		end

		if var_389_0 then
			table.remove(var_282_10.list, var_389_0)
		end
	end

	var_282_14.keylist = var_0_106.new("keylist", var_0_97.x - 400, var_0_97.y, 120, 22, true)
	var_282_14.keylist.binds = {
		{
			name = "Minimum damage",
			ref = var_0_107.rage.aimbot.damage_ovr[1],
			state = function()
				return var_0_107.rage.aimbot.damage_ovr[2].value
			end
		},
		{
			name = "Double tap",
			ref = var_0_107.rage.aimbot.double_tap[1]
		},
		{
			name = "Hide shots",
			ref = var_0_107.aa.other.onshot
		},
		{
			name = "Quick peek",
			ref = var_0_107.rage.other.peek
		},
		{
			name = "Defensive snap",
			ref = var_0_127.antiaim.def.snap.on
		},
		{
			name = "Manual yaw",
			ref = function()
				return var_0_133.data.manual_yaw
			end,
			state = function()
				return var_0_133.data.manual_yaw == -90 and "left" or var_0_133.data.manual_yaw == 90 and "right" or "~"
			end
		},
		{
			name = "Edge yaw",
			ref = var_0_107.aa.angles.edge
		},
		{
			name = "Freestanding",
			ref = var_0_107.aa.angles.freestand
		}
	}

	var_282_14.keylist:enlist(function()
		local var_393_0 = {}

		for iter_393_0 = 1, #var_282_14.keylist.binds do
			local var_393_1 = var_282_14.keylist.binds[iter_393_0]
			local var_393_2 = false
			local var_393_3 = "on"

			if var_0_24(var_393_1.ref) == "function" then
				var_393_2 = var_393_1.ref()
			elseif var_393_1.ref ~= nil then
				var_393_2 = var_393_1.ref.value

				if var_393_1.ref.hotkey then
					local var_393_4, var_393_5 = var_393_1.ref.hotkey:get()

					var_393_2 = var_393_2 and var_393_4 and var_393_5 ~= 0
				end
			end

			if var_393_1.state then
				if var_0_24(var_393_1.state) == "function" then
					var_393_3 = var_393_1.state()
				else
					var_393_3 = var_393_1.state
				end
			end

			var_393_0[iter_393_0] = {
				name = var_393_1.name,
				active = var_393_2,
				state = var_393_3
			}
		end

		return var_393_0
	end, function(arg_394_0, arg_394_1, arg_394_2, arg_394_3)
		local var_394_0 = arg_394_0.x + 4
		local var_394_1 = arg_394_0.y + arg_394_2 + (arg_394_0.h + 6) * arg_394_3
		local var_394_2 = arg_394_0.w - 8
		local var_394_3 = 20

		var_0_99.blur(var_394_0, var_394_1, var_394_2, var_394_3)
		var_0_99.rectangle(var_394_0, var_394_1, var_394_2, var_394_3, var_0_91.panel.l1, 4)
		var_0_99.text(var_394_0 + 6, var_394_1 + 3, var_0_91.text, nil, nil, arg_394_1.name)
		var_0_99.text(var_394_0 + var_394_2 - 6, var_394_1 + 3, var_0_91.accent, "r", nil, arg_394_1.state)

		return var_0_99.measure_text(nil, arg_394_1.name .. arg_394_1.state) + 32, var_394_3 + 2
	end)

	function var_282_14.keylist.update(arg_395_0)
		return var_0_100.condition(arg_395_0.progress, var_0_127.visuals.keylist.value and (var_0_44.menu_open or arg_395_0.__list.active > 0))
	end

	function var_282_14.keylist.paint(arg_396_0, arg_396_1, arg_396_2, arg_396_3, arg_396_4)
		var_0_99.blur(arg_396_1, arg_396_2, arg_396_3, arg_396_4)
		var_0_99.rounded_side_h(arg_396_1, arg_396_2, arg_396_3, arg_396_4, var_0_91.panel.g1, 4)
		var_0_99.edge_h(arg_396_1, arg_396_2 + arg_396_4, arg_396_3)
		var_0_99.text(arg_396_1 + arg_396_3 * 0.5, arg_396_2 + 11, var_0_91.text, "c", nil, "Hotkeys")
	end

	var_282_14.speclist = var_0_106.new("speclist", var_0_97.x - 400, var_0_97.y, 120, 22, true)

	var_282_14.speclist:enlist(function()
		local var_397_0 = {}

		if var_0_113.valid then
			local var_397_1
			local var_397_2 = entity.get_prop(var_0_113.self, "m_hObserverTarget")
			local var_397_3 = entity.get_prop(var_0_113.self, "m_iObserverMode")

			if var_397_2 and (var_397_3 == 4 or var_397_3 == 5) then
				var_397_1 = var_397_2
			else
				var_397_1 = var_0_113.self
			end

			for iter_397_0 = 1, 64 do
				if entity.get_classname(iter_397_0) == "CCSPlayer" and iter_397_0 ~= var_0_113.self then
					local var_397_4 = entity.get_prop(iter_397_0, "m_hObserverTarget")
					local var_397_5 = entity.get_prop(iter_397_0, "m_iObserverMode")

					var_397_0[#var_397_0 + 1] = {
						name = iter_397_0,
						nick = string.limit(entity.get_player_name(iter_397_0), 20, "..."),
						active = var_397_4 and var_397_4 == var_397_1 and (var_397_5 == 4 or var_397_5 == 5)
					}
				end
			end
		end

		return var_397_0
	end, function(arg_398_0, arg_398_1, arg_398_2, arg_398_3)
		local var_398_0 = arg_398_0.x + 4
		local var_398_1 = arg_398_0.y + arg_398_2 + (arg_398_0.h + 6) * arg_398_3
		local var_398_2 = arg_398_0.w - 8
		local var_398_3 = 20

		var_0_99.blur(var_398_0, var_398_1, var_398_2, var_398_3)
		var_0_99.rectangle(var_398_0, var_398_1, var_398_2, var_398_3, var_0_91.panel.l1, 4)
		var_0_99.text(var_398_0 + 6, var_398_1 + 3, var_0_91.text, nil, nil, arg_398_1.nick)

		return var_0_99.measure_text(nil, arg_398_1.nick) + 32, var_398_3 + 2
	end)

	function var_282_14.speclist.update(arg_399_0)
		return var_0_100.condition(arg_399_0.progress, var_0_127.visuals.speclist.value and (var_0_44.menu_open or arg_399_0.__list.active > 0))
	end

	function var_282_14.speclist.paint(arg_400_0, arg_400_1, arg_400_2, arg_400_3, arg_400_4)
		var_0_99.blur(arg_400_1, arg_400_2, arg_400_3, arg_400_4)
		var_0_99.rounded_side_h(arg_400_1, arg_400_2, arg_400_3, arg_400_4, var_0_91.panel.g1, 4)
		var_0_99.edge_h(arg_400_1, arg_400_2 + arg_400_4, arg_400_3)
		var_0_99.text(arg_400_1 + arg_400_3 * 0.5, arg_400_2 + 11, var_0_91.text, "c", nil, string.format("Spectators (%d)", arg_400_0.__list.active))
	end

	local function var_282_15()
		if var_0_127.visuals.water.on.value or var_282_14.watermark.alpha > 0 then
			var_282_14.watermark()
		end

		if var_0_127.visuals.damage.value or var_282_14.damage.alpha > 0 then
			var_282_14.damage()
		end

		if var_0_127.visuals.arrows.value or var_282_14.arrows.alpha > 0 then
			var_282_14.arrows()
		end

		if var_0_127.visuals.slowdown.value or var_282_14.slowdown.alpha > 0 then
			var_282_14.slowdown()
		end

		if var_0_127.misc.logs.on.value and var_0_127.misc.logs.output:get("Screen") or var_282_14.logs.alpha > 0 then
			var_282_14.logs()
		end

		if var_0_127.visuals.speclist.value or var_282_14.speclist.alpha > 0 then
			var_282_14.speclist()
		end

		if var_0_127.visuals.keylist.value or var_282_14.keylist.alpha > 0 then
			var_282_14.keylist()
		end

		if var_0_127.visuals.crosshair.on.value or var_282_13.alpha > 0 then
			var_282_13()
		end
	end

	var_0_78.paint_ui:set(var_282_15)

	if not var_0_2 then
		local var_282_16 = {
			completing = false,
			state = true,
			progress = {
				{
					0
				},
				{
					0
				},
				{
					0
				}
			}
		}

		function var_282_16.render()
			local var_402_0 = var_0_100.condition(var_282_16.progress[1], var_282_16.state, 2)
			local var_402_1 = var_0_100.condition(var_282_16.progress[2], var_402_0 == 1, 2)

			var_0_99.rectangle(0, 0, var_0_93, var_0_94, var_0_91.back:alphen(var_402_0 * 180))

			local var_402_2 = 400

			var_0_99.texture(var_0_102.butterfly, var_0_97.x - var_402_2 * 0.5, var_0_97.y - var_402_2 * 0.5, var_402_2, var_402_2, var_0_91.accent:alphen(var_402_1 * 255))

			if not var_282_16.completing then
				client.delay_call(3, function()
					if var_282_16 then
						var_282_16.state = false
					end
				end)

				var_282_16.completing = true
			end
		end

		client.delay_call(1, function()
			var_0_78.paint_ui:set(var_282_16.render)
		end)
		client.delay_call(6, function()
			var_0_78.paint_ui:unset(var_282_16.render)

			var_282_16 = nil
		end)
	end
end)()

var_0_129.system = var_0_44.setup(var_0_127)

--local memoryUsed, memoryRemainder = collectgarbage("count")
--print("Memory used:", memoryUsed, "KB")