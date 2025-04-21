if ffi == nil then
	ffi = require("ffi")
end

if bit == nil then
	bit = require("bit")
end

local var_0_0 = ffi
local var_0_1 = bit
local var_0_2 = var_0_0.new
local var_0_3 = var_0_0.cast
local var_0_4 = var_0_0.cdef
local var_0_5 = var_0_0.typeof
local var_0_6 = var_0_1.band
local var_0_7 = var_0_1.bor
local var_0_8 = var_0_1.bxor
local var_0_9 = var_0_1.bnot
local var_0_10 = var_0_1.lshift
local var_0_11 = var_0_1.rshift
local var_0_12 = var_0_1.ror
local var_0_13 = var_0_1.rol
local var_0_14
local var_0_15
local var_0_16
local var_0_17
local var_0_18
local var_0_19
local var_0_20
local var_0_21
local var_0_22
local var_0_23
local var_0_24
local var_0_25
local var_0_26
local var_0_27
local var_0_28
local var_0_29
local var_0_30
local var_0_31
local var_0_32
local var_0_33
local var_0_34 = {
	spoof = false,
	unmatched_lua = true,
	debug = false
}
local var_0_35 = {}

local function var_0_36(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		arg_1_0[iter_1_1] = iter_1_0
	end

	return arg_1_0
end

local function var_0_37(...)
	if var_0_34.debug then
		print(...)
	end
end

local var_0_38 = var_0_36({
	"Gamesense",
	"Ev0lve",
	"Fatality",
	"Primordial",
	"Pandora",
	"Plague cheat",
	"Legion",
	"Nixware",
	"Spirthack",
	"Extension",
	"Onetap",
	"Legendware",
	"Neverlose",
	"Airflow",
	"Airflow old",
	"Weave",
	"Fatality old",
	"Solus UI"
})
local var_0_39 = var_0_36({
	"Self",
	"Team",
	"Enemies"
})
local var_0_40 = var_0_36({
	"Real",
	"Random",
	"Ghost"
})
local var_0_41 = var_0_36({
	"Original",
	"Solus",
	"Skeet colored",
	"Skeet monotone"
})
local var_0_42 = var_0_36({
	"NONE",
	"FATALITY",
	"AIRFLOW",
	"NEVERLOSE",
	"PRIMORDIAL",
	"GAMESENSE",
	"PANDORA",
	"ONETAP",
	"EV0LVE",
	"PLAGUE",
	"NIXWARE",
	"SOLUS_UI",
	"RIFK7",
	"LEGION",
	"MONOLITH",
	"AIMWARE",
	"LEGENDWARE",
	"SPIRTHACK",
	"EXTENSION",
	"WEAVE",
	"FATALITY_OLD"
})
local var_0_43 = var_0_36({
	"EV0LVE",
	"FATALITY",
	"PRIMORDIAL",
	"LEGION",
	"PANDORA",
	"GAMESENSE",
	"LEGENDWARE",
	"NEVERLOSE",
	"NIXWARE",
	"SPIRTHACK",
	"RIFK7"
})
local var_0_44 = {
	[var_0_43.EV0LVE] = var_0_42.EV0LVE,
	[var_0_43.FATALITY] = var_0_42.FATALITY,
	[var_0_43.PRIMORDIAL] = var_0_42.PRIMORDIAL,
	[var_0_43.LEGION] = var_0_42.LEGION,
	[var_0_43.PANDORA] = var_0_42.PANDORA,
	[var_0_43.GAMESENSE] = var_0_42.GAMESENSE,
	[var_0_43.LEGENDWARE] = var_0_42.LEGENDWARE,
	[var_0_43.NEVERLOSE] = var_0_42.NEVERLOSE,
	[var_0_43.NIXWARE] = var_0_42.NIXWARE,
	[var_0_43.SPIRTHACK] = var_0_42.SPIRTHACK,
	[var_0_43.RIFK7] = var_0_42.RIFK7
}
local var_0_45

repeat
	if _G == nil then
		if quick_maths ~= nil then
			var_0_45 = var_0_43.RIFK7

			break
		end

		if info.fatality == nil then
			var_0_45 = var_0_43.EV0LVE

			break
		end

		var_0_45 = var_0_43.FATALITY

		break
	end

	if MatSystem ~= nil then
		var_0_45 = var_0_43.SPIRTHACK

		break
	end

	if file ~= nil then
		var_0_45 = var_0_43.LEGENDWARE

		break
	end

	if penetration ~= nil then
		var_0_45 = var_0_43.PANDORA

		break
	end

	if math_utils ~= nil then
		var_0_45 = var_0_43.LEGION

		break
	end

	if plist ~= nil then
		var_0_45 = var_0_43.GAMESENSE

		break
	end

	if network ~= nil then
		var_0_45 = var_0_43.NEVERLOSE

		break
	end

	if renderer ~= nil and renderer.setup_texture ~= nil then
		var_0_45 = var_0_43.NIXWARE

		break
	end

	var_0_45 = var_0_43.PRIMORDIAL
until true

var_0_37("implementation: " .. var_0_43[var_0_45])

local var_0_46 = panorama

if _G == nil or var_0_46 == nil then
	var_0_46 = (function()
		local var_3_0
		local var_3_1
		local var_3_2
		local var_3_3
		local var_3_4
		local var_3_5
		local var_3_6
		local var_3_7
		local var_3_8
		local var_3_9
		local var_3_10
		local var_3_11
		local var_3_12
		local var_3_13
		local var_3_14
		local var_3_15
		local var_3_16
		local var_3_17
		local var_3_18
		local var_3_19
		local var_3_20
		local var_3_21
		local var_3_22
		local var_3_23
		local var_3_24
		local var_3_25
		local var_3_26
		local var_3_27
		local var_3_28
		local var_3_29
		local var_3_30
		local var_3_31
		local var_3_32
		local var_3_33
		local var_3_34
		local var_3_35
		local var_3_36
		local var_3_37
		local var_3_38
		local var_3_39
		local var_3_40
		local var_3_41
		local var_3_42
		local var_3_43
		local var_3_44
		local var_3_45
		local var_3_46
		local var_3_47
		local var_3_48
		local var_3_49
		local var_3_50
		local var_3_51
		local var_3_52
		local var_3_53
		local var_3_54
		local var_3_55
		local var_3_56
		local var_3_57
		local var_3_58
		local var_3_59
		local var_3_60
		local var_3_61
		local var_3_62
		local var_3_63
		local var_3_64
		local var_3_65
		local var_3_66
		local var_3_67
		local var_3_68
		local var_3_69
		local var_3_70
		local var_3_71
		local var_3_72
		local var_3_73
		local var_3_74
		local var_3_75
		local var_3_76
		local var_3_77
		local var_3_78
		local var_3_79
		local var_3_80
		local var_3_81 = {
			_VERSION = 1.7
		}

		setmetatable(var_3_81, {
			__call = function(arg_4_0)
				return arg_4_0._VERSION
			end,
			__tostring = function(arg_5_0)
				return arg_5_0._VERSION
			end
		})

		local var_3_82 = require("ffi")
		local var_3_83 = var_3_82
		local var_3_84, var_3_85, var_3_86, var_3_87, var_3_88 = var_3_83.cast, var_3_83.typeof, var_3_83.new, var_3_83.string, var_3_83.metatype

		local function var_3_89()
			return error("Unsupported provider")
		end

		local function var_3_90()
			return error("Unsupported provider")
		end

		local function var_3_91()
			return print("WARNING: Cleanup before shutdown disabled")
		end

		local var_3_92

		repeat
			if _G == nil then
				if quick_maths == nil then
					if info.fatality == nil then
						var_3_92 = "ev0lve"

						break
					end

					var_3_92 = "fa7ality"

					break
				end

				var_3_92 = "rifk7"

				break
			end

			if MatSystem ~= nil then
				var_3_92 = "spirthack"

				break
			end

			if file ~= nil then
				var_3_92 = "legendware"

				break
			end

			if GameEventManager ~= nil then
				var_3_92 = "memesense"

				break
			end

			if penetration ~= nil then
				var_3_92 = "pandora"

				break
			end

			if math_utils ~= nil then
				var_3_92 = "legion"

				break
			end

			if plist ~= nil then
				var_3_92 = "gamesense"

				break
			end

			if network ~= nil then
				var_3_92 = "neverlose"

				break
			end

			if renderer ~= nil and renderer.setup_texture ~= nil then
				var_3_92 = "nixware"

				break
			end

			var_3_92 = "primordial"
		until true

		local var_3_93 = var_3_92

		if var_3_93 == "ev0lve" then
			var_3_89 = utils.find_pattern
			var_3_90 = utils.find_interface

			local function var_3_94()
				return
			end
		elseif var_3_93 == "fa7ality" then
			var_3_89 = utils.find_pattern
			var_3_90 = utils.find_interface

			local function var_3_95()
				return
			end
		elseif var_3_93 == "primordial" then
			var_3_89 = memory.find_pattern
			var_3_90 = memory.create_interface

			local function var_3_96(arg_11_0)
				return callbacks.add(e_callbacks.SHUTDOWN, arg_11_0)
			end
		elseif var_3_93 == "memesense" then
			var_3_89 = Utils.PatternScan
			var_3_90 = Utils.CreateInterface

			local function var_3_97(arg_12_0)
				return Cheat.RegisterCallback("destroy", arg_12_0)
			end
		elseif var_3_93 == "legendware" then
			var_3_89 = utils.find_signature
			var_3_90 = utils.create_interface

			local function var_3_98(arg_13_0)
				return client.add_callback("unload", arg_13_0)
			end
		elseif var_3_93 == "pandora" then
			var_3_89 = client.find_sig
			var_3_90 = client.create_interface
		elseif var_3_93 == "legion" then
			var_3_89 = memory.find_pattern
			var_3_90 = memory.create_interface

			local function var_3_99(arg_14_0)
				return client.add_callback("on_unload", arg_14_0)
			end
		elseif var_3_93 == "gamesense" then
			function var_3_89(arg_15_0, arg_15_1)
				local var_15_0 = ""

				for iter_15_0 in arg_15_1:gmatch("%S+") do
					var_15_0 = var_15_0 .. (iter_15_0 == "?" and "\xCC" or _G.string.char(tonumber(iter_15_0, 16)))
				end

				return client.find_signature(arg_15_0, var_15_0)
			end

			var_3_90 = client.create_interface

			local function var_3_100(arg_16_0)
				return client.set_event_callback("shutdown", arg_16_0)
			end
		elseif var_3_93 == "nixware" then
			var_3_89 = client.find_pattern
			var_3_90 = se.create_interface

			local function var_3_101(arg_17_0)
				return client.register_callback("unload", arg_17_0)
			end
		elseif var_3_93 == "neverlose" then
			var_3_89 = utils.opcode_scan
			var_3_90 = utils.create_interface

			local function var_3_102()
				return
			end
		elseif var_3_93 == "rifk7" then
			function var_3_89(arg_19_0, arg_19_1)
				local var_19_0 = var_3_84("uint32_t*", engine.signature(arg_19_0, arg_19_1))

				assert(tonumber(var_19_0) ~= 0)

				return var_19_0[0]
			end

			function var_3_90(arg_20_0, arg_20_1)
				arg_20_1 = var_3_87.gsub(arg_20_1, "%d+", "")

				return general.create_interface(arg_20_0, arg_20_1)
			end

			function print(arg_21_0)
				return general.log_to_console_colored("[lua] " .. tostring(arg_21_0), 255, 141, 161, 255)
			end
		elseif var_3_93 == "spirthack" then
			var_3_89 = Utils.PatternScan
			var_3_90 = Utils.CreateInterface
		end

		local var_3_103 = xpcall and pcall and true or false
		local var_3_104 = var_3_82.C and var_3_92 ~= "gamesense"

		print(("\nluv8 panorama library %s;\nhttps://github.com/Shir0ha/luv8\napi: %s; safe_mode: %s; ffi.C: %s"):format(var_3_81._VERSION, var_3_92, tostring(var_3_103), tostring(var_3_104)))

		local function var_3_105()
			for iter_22_0, iter_22_1 in pairs(var_3_51) do
				var_3_56(iter_22_1):disposeGlobal()
			end
		end

		local var_3_106 = error

		if error then
			function error(arg_23_0)
				var_3_105()

				return var_3_106(arg_23_0)
			end
		end

		local function var_3_107(arg_24_0)
			return print("Caught lua exception in V8 HandleScope: ", tostring(arg_24_0))
		end

		local function var_3_108(arg_25_0)
			return print("Caught lua exception in V8 Function Callback: ", tostring(arg_25_0))
		end

		local function var_3_109(arg_26_0, arg_26_1)
			local var_26_0 = getmetatable(arg_26_0)

			setmetatable(arg_26_0, nil)

			local var_26_1 = arg_26_0[arg_26_1]

			setmetatable(arg_26_0, var_26_0)

			return var_26_1
		end

		local function var_3_110(arg_27_0, arg_27_1, arg_27_2)
			local var_27_0 = getmetatable(arg_27_0)

			setmetatable(arg_27_0, nil)

			arg_27_0[arg_27_1] = arg_27_2

			return setmetatable(arg_27_0, var_27_0)
		end

		if not rawget then
			rawget = var_3_109
		end

		if not rawset then
			rawset = var_3_110
		end

		local function var_3_111(arg_28_0, arg_28_1)
			return function(...)
				return arg_28_0(arg_28_1, ...)
			end
		end

		local function var_3_112(arg_30_0)
			local var_30_0 = {}

			for iter_30_0, iter_30_1 in pairs(arg_30_0) do
				var_30_0[iter_30_0] = iter_30_1
			end

			return var_30_0
		end

		local function var_3_113(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			local var_31_0 = var_3_84("void***", var_3_90(arg_31_0, arg_31_1)) or error(arg_31_1 .. " is nil.")

			return var_3_111(var_3_84(arg_31_3, var_31_0[0][arg_31_2]), var_31_0)
		end

		local var_3_114 = var_3_85("void***")

		local function var_3_115(arg_32_0, arg_32_1, arg_32_2)
			return var_3_84(arg_32_2, var_3_84(var_3_114, arg_32_0)[0][arg_32_1])
		end

		local function var_3_116(arg_33_0, arg_33_1)
			local var_33_0 = var_3_85(arg_33_1)

			return function(arg_34_0, ...)
				return var_3_115(arg_34_0, arg_33_0, var_33_0)(arg_34_0, ...)
			end
		end

		local var_3_117 = (function()
			local var_35_0

			local function var_35_1()
				return error("Failed to load GetProcAddress")
			end

			local var_35_2

			local function var_35_3()
				return error("Failed to load GetModuleHandleA")
			end

			if var_3_104 then
				var_3_82.cdef("            uint32_t GetProcAddress(uint32_t, const char*);\n            uint32_t GetModuleHandleA(const char*);\n        ")

				var_35_1 = var_3_82.C.GetProcAddress
				var_35_3 = var_3_82.C.GetModuleHandleA
			else
				var_35_1 = var_3_84("uint32_t(__stdcall*)(uint32_t, const char*)", var_3_84("uint32_t**", var_3_84("uint32_t", var_3_89("engine.dll", "FF 15 ? ? ? ? A3 ? ? ? ? EB 05")) + 2)[0][0])
				var_35_3 = var_3_84("uint32_t(__stdcall*)(const char*)", var_3_84("uint32_t**", var_3_84("uint32_t", var_3_89("engine.dll", "FF 15 ? ? ? ? 85 C0 74 0B")) + 2)[0][0])
			end

			if var_3_92 == "gamesense" then
				local var_35_4 = var_3_89("engine.dll", "51 C3")
				local var_35_5 = var_3_84("void*", var_35_1)

				function var_35_1(arg_38_0, arg_38_1)
					return var_3_84("uint32_t(__thiscall*)(void*, uint32_t, const char*)", var_35_4)(var_35_5, arg_38_0, arg_38_1)
				end

				local var_35_6 = var_3_84("void*", var_35_3)

				function var_35_3(arg_39_0)
					return var_3_84("uint32_t(__thiscall*)(void*, const char*)", var_35_4)(var_35_6, arg_39_0)
				end
			end

			return function(arg_40_0, arg_40_1, arg_40_2)
				return var_3_84(var_3_85(arg_40_2), var_35_1(var_35_3(arg_40_0), arg_40_1))
			end
		end)()

		local function var_3_118(arg_41_0)
			local var_41_0 = var_3_84("uint8_t*", arg_41_0)
			local var_41_1 = var_41_0[0]

			if (232 or 233) == var_41_1 then
				return var_3_84("uint32_t", var_41_0 + var_3_84("int32_t*", var_41_0 + 1)[0] + 5)
			elseif var_41_1 == 255 then
				if var_41_0[1] == 21 then
					return var_3_84("uint32_t**", var_3_84("const char*", arg_41_0) + 2)[0][0]
				end
			else
				return arg_41_0
			end
		end

		local function var_3_119(...)
			local var_42_0 = {
				...
			}
			local var_42_1 = #var_42_0
			local var_42_2 = var_3_86(("void*[%.f]"):format(var_42_1))

			for iter_42_0 = 1, var_42_1 do
				var_42_2[iter_42_0 - 1] = var_3_57:fromLua(var_42_0[iter_42_0]):getInternal()
			end

			return var_42_1, var_42_2
		end

		local function var_3_120(arg_43_0)
			return function(arg_44_0)
				arg_44_0 = var_3_63(arg_44_0)

				local var_44_0 = {}
				local var_44_1 = arg_44_0:length()

				if var_44_1 > 0 then
					for iter_44_0 = 0, var_44_1 - 1 do
						table.insert(var_44_0, arg_44_0:get(iter_44_0))
					end
				end

				local var_44_2

				if var_3_103 then
					local var_44_3, var_44_4 = xpcall(function()
						return arg_43_0(unpack(var_44_0))
					end, var_3_108)

					if var_44_3 then
						var_44_2 = var_44_4
					end
				else
					var_44_2 = arg_43_0(unpack(var_44_0))
				end

				return arg_44_0:setReturnValue(var_3_57:fromLua(var_44_2):getInternal())
			end
		end

		local function var_3_121(arg_46_0)
			local var_46_0 = 1

			for iter_46_0 in pairs(arg_46_0) do
				if arg_46_0[var_46_0] ~= nil then
					var_46_0 = var_46_0 + 1
				else
					return false
				end
			end

			return var_46_0 ~= 1
		end

		local var_3_122 = var_3_86("void*")
		local var_3_123 = var_3_86("int[1]")
		local var_3_124 = {
			panelIDs = {}
		}
		local var_3_125
		local var_3_126 = {
			get = function(arg_47_0, arg_47_1, arg_47_2)
				return var_3_111(var_3_84(arg_47_2, arg_47_0.this[0][arg_47_1]), arg_47_0.this)
			end,
			getInstance = function(arg_48_0)
				return arg_48_0.this
			end
		}

		var_3_126.__index = var_3_126

		local var_3_127 = setmetatable({
			__name = "vtable",
			__init = function(arg_49_0, arg_49_1)
				arg_49_0.this = var_3_84("void***", arg_49_1)
			end,
			__base = var_3_126
		}, {
			__index = var_3_126,
			__call = function(arg_50_0, ...)
				local var_50_0 = setmetatable({}, var_3_126)

				arg_50_0.__init(var_50_0, ...)

				return var_50_0
			end
		})

		var_3_126.__class = var_3_127

		local var_3_128 = var_3_127
		local var_3_129
		local var_3_130 = {
			cache = {},
			get = function(arg_51_0, arg_51_1, arg_51_2)
				if not arg_51_0.cache[arg_51_1] then
					arg_51_0.cache[arg_51_1] = var_3_117(arg_51_0.file, arg_51_1, arg_51_2)
				end

				return arg_51_0.cache[arg_51_1]
			end
		}

		var_3_130.__index = var_3_130

		local var_3_131 = setmetatable({
			__name = "DllImport",
			__init = function(arg_52_0, arg_52_1)
				arg_52_0.file = arg_52_1
			end,
			__base = var_3_130
		}, {
			__index = var_3_130,
			__call = function(arg_53_0, ...)
				local var_53_0 = setmetatable({}, var_3_130)

				arg_53_0.__init(var_53_0, ...)

				return var_53_0
			end
		})

		var_3_130.__class = var_3_131

		local var_3_132 = var_3_131
		local var_3_133 = var_3_128(var_3_113("panorama.dll", "PanoramaUIEngine001", 11, "void*(__thiscall*)(void*)")())
		local var_3_134 = var_3_133:get(36, "bool(__thiscall*)(void*,void const*)")
		local var_3_135 = var_3_133:get(56, "void*(__thiscall*)(void*)")
		local var_3_136 = var_3_133:get(113, "void****(__thiscall*)(void*,void*,char const*,char const*,int,int,bool)")
		local var_3_137 = var_3_111(var_3_84(var_3_85("void*(__thiscall*)(void*,void*,void*,void*,int,bool)"), var_3_118(var_3_89("panorama.dll", "E8 ? ? ? ? 8B 4C 24 10 FF 15"))), var_3_133:getInstance())
		local var_3_138 = var_3_133:get(123, "void*(__thiscall*)(void*)")
		local var_3_139 = var_3_133:get(129, "void*(__thiscall*)(void*)")
		local var_3_140 = var_3_133:get(121, "void(__thiscall*)(void*, void*, void*)")
		local var_3_141 = var_3_116(25, "void*(__thiscall*)(void*)")
		local var_3_142 = var_3_116(9, "const char*(__thiscall*)(void*)")
		local var_3_143 = var_3_116(40, "void*(__thiscall*)(void*,const char*)")
		local var_3_144 = var_3_116(218, "void*(__thiscall*)(void*)")
		local var_3_145 = var_3_111(var_3_84("void***(__thiscall*)(void*,void*)", var_3_118(var_3_89("panorama.dll", "E8 ? ? ? ? 8B 00 85 C0 75 1B"))), var_3_133:getInstance())
		local var_3_146 = {}

		local function var_3_147(arg_54_0)
			if var_3_146[arg_54_0] ~= nil then
				return var_3_146[arg_54_0]
			end

			var_3_146[arg_54_0] = var_3_144(arg_54_0)

			return var_3_146[arg_54_0]
		end

		local var_3_148 = var_3_132("v8.dll")
		local var_3_149 = var_3_139()

		var_3_51 = {}

		local var_3_150
		local var_3_151 = {}

		var_3_151.__index = var_3_151

		local var_3_152 = setmetatable({
			__name = "Message",
			__init = function(arg_55_0, arg_55_1)
				arg_55_0.this = var_3_84("void*", arg_55_1)
			end,
			__base = var_3_151
		}, {
			__index = var_3_151,
			__call = function(arg_56_0, ...)
				local var_56_0 = setmetatable({}, var_3_151)

				arg_56_0.__init(var_56_0, ...)

				return var_56_0
			end
		})

		var_3_151.__class = var_3_152

		local var_3_153 = var_3_152
		local var_3_154
		local var_3_155 = {
			getInternal = function(arg_57_0)
				return arg_57_0.this
			end,
			isValid = function(arg_58_0)
				return arg_58_0.this[0] ~= var_3_122
			end,
			getMessage = function(arg_59_0)
				return var_3_153(arg_59_0.this[0])
			end,
			globalize = function(arg_60_0)
				local var_60_0 = var_3_148:get("?GlobalizeReference@V8@v8@@CAPAPAVObject@internal@2@PAVIsolate@42@PAPAV342@@Z", "void*(__cdecl*)(void*,void*)")(var_3_149, arg_60_0.this[0])
				local var_60_1 = var_3_56(var_60_0)

				var_3_51[var_60_1:getIdentityHash()] = var_60_0

				return var_60_1
			end,
			__call = function(arg_61_0)
				return var_3_57(arg_61_0.this[0])
			end
		}

		var_3_155.__index = var_3_155

		local var_3_156 = setmetatable({
			__name = "Local",
			__init = function(arg_62_0, arg_62_1)
				arg_62_0.this = var_3_84("void**", arg_62_1)
			end,
			__base = var_3_155
		}, {
			__index = var_3_155,
			__call = function(arg_63_0, ...)
				local var_63_0 = setmetatable({}, var_3_155)

				arg_63_0.__init(var_63_0, ...)

				return var_63_0
			end
		})

		var_3_155.__class = var_3_156

		local var_3_157 = var_3_156
		local var_3_158
		local var_3_159 = {
			getInternal = function(arg_64_0)
				return arg_64_0.this
			end,
			toLocalChecked = function(arg_65_0)
				if arg_65_0.this[0] ~= var_3_122 then
					return var_3_157(arg_65_0.this)
				end
			end,
			toValueChecked = function(arg_66_0)
				if arg_66_0.this[0] ~= var_3_122 then
					return var_3_57(arg_66_0.this[0])
				end
			end
		}

		var_3_159.__index = var_3_159

		local var_3_160 = setmetatable({
			__name = "MaybeLocal",
			__init = function(arg_67_0, arg_67_1)
				arg_67_0.this = var_3_84("void**", arg_67_1)
			end,
			__base = var_3_159
		}, {
			__index = var_3_159,
			__call = function(arg_68_0, ...)
				local var_68_0 = setmetatable({}, var_3_159)

				arg_68_0.__init(var_68_0, ...)

				return var_68_0
			end
		})

		var_3_159.__class = var_3_160

		local var_3_161 = var_3_160
		local var_3_162 = {
			__index = function(arg_69_0, arg_69_1)
				local var_69_0 = rawget(arg_69_0, "this")
				local var_69_1 = var_3_73()(function()
					return var_69_0:getAsValue():toObject():get(var_3_57:fromLua(arg_69_1):getInternal()):toValueChecked():toLua()
				end)

				if type(var_69_1) == "table" then
					rawset(var_69_1, "parent", var_69_0)
				end

				return var_69_1
			end,
			__newindex = function(arg_71_0, arg_71_1, arg_71_2)
				local var_71_0 = rawget(arg_71_0, "this")

				return var_3_73()(function()
					return var_71_0:getAsValue():toObject():set(var_3_57:fromLua(arg_71_1):getInternal(), var_3_57:fromLua(arg_71_2):getInternal()):toValueChecked():toLua()
				end)
			end,
			__len = function(arg_73_0)
				local var_73_0 = rawget(arg_73_0, "this")
				local var_73_1 = 0

				if var_73_0.baseType == "Array" then
					var_73_1 = var_3_73()(function()
						return var_73_0:getAsValue():toArray():length()
					end)
				elseif var_73_0.baseType == "Object" then
					var_73_1 = var_3_73()(function()
						return var_73_0:getAsValue():toObject():getPropertyNames():toValueChecked():toArray():length()
					end)
				end

				return var_73_1
			end,
			__pairs = function(arg_76_0)
				local var_76_0 = rawget(arg_76_0, "this")
				local var_76_1

				local function var_76_2()
					return nil
				end

				if var_76_0.baseType == "Object" then
					var_3_73()(function()
						local var_78_0 = var_3_59(var_76_0:getAsValue():toObject():getPropertyNames():toValueChecked())
						local var_78_1 = 0
						local var_78_2 = var_78_0:length()

						function var_76_2()
							var_78_1 = var_78_1 + 1

							local var_79_0 = var_78_0[var_78_1 - 1]

							if var_78_1 <= var_78_2 then
								return var_79_0, arg_76_0[var_79_0]
							end
						end
					end)
				end

				return var_76_2
			end,
			__ipairs = function(arg_80_0)
				local var_80_0 = rawget(arg_80_0, "this")
				local var_80_1

				local function var_80_2()
					return nil
				end

				if var_80_0.baseType == "Array" then
					var_3_73()(function()
						local var_82_0 = 0
						local var_82_1 = var_80_0:getAsValue():toArray():length()

						function var_80_2()
							var_82_0 = var_82_0 + 1

							if var_82_0 <= var_82_1 then
								return var_82_0, arg_80_0[var_82_0 - 1]
							end
						end
					end)
				end

				return var_80_2
			end,
			__call = function(arg_84_0, ...)
				local var_84_0 = rawget(arg_84_0, "this")
				local var_84_1 = {
					...
				}

				if var_84_0.baseType ~= "Function" then
					error("Attempted to call a non-function value: " .. var_84_0.baseType)
				end

				local var_84_2 = false
				local var_84_3 = var_3_73()(function()
					local var_85_0 = var_3_74()

					var_85_0:enter()

					local var_85_1 = var_84_0:getAsValue():toFunction():setParent(rawget(arg_84_0, "parent"))(unpack(var_84_1)):toLocalChecked()

					if var_85_0:hasCaught() then
						var_3_140(var_85_0:getInternal(), var_3_124.getPanel("CSGOJsRegistration"))

						if var_3_103 then
							var_84_2 = true
						end
					end

					var_85_0:exit()

					if var_85_1 == nil then
						return nil
					else
						return var_85_1():toLua()
					end
				end)

				if var_84_2 then
					error("\n\nFailed to call the given javascript function, please check the error message above ^ \n\n(definitely not because I was too lazy to implement my own exception handler)\n")
				end

				return var_84_3
			end,
			__tostring = function(arg_86_0)
				local var_86_0 = rawget(arg_86_0, "this")

				return var_3_73()(function()
					return var_86_0:getAsValue():stringValue()
				end)
			end,
			__gc = function(arg_88_0)
				return rawget(arg_88_0, "this"):disposeGlobal()
			end
		}
		local var_3_163
		local var_3_164 = {
			setType = function(arg_89_0, arg_89_1)
				arg_89_0.baseType = arg_89_1

				return arg_89_0
			end,
			getInternal = function(arg_90_0)
				return arg_90_0.this
			end,
			disposeGlobal = function(arg_91_0)
				return var_3_148:get("?DisposeGlobal@V8@v8@@CAXPAPAVObject@internal@2@@Z", "void(__cdecl*)(void*)")(arg_91_0.this)
			end,
			get = function(arg_92_0)
				return var_3_161(var_3_73:createHandle(arg_92_0.this))
			end,
			getAsValue = function(arg_93_0)
				return var_3_57(var_3_73:createHandle(arg_93_0.this)[0])
			end,
			toLua = function(arg_94_0)
				return arg_94_0:get():toValueChecked():toLua()
			end,
			getIdentityHash = function(arg_95_0)
				return var_3_148:get("?GetIdentityHash@Object@v8@@QAEHXZ", "int(__thiscall*)(void*)")(arg_95_0.this)
			end,
			__call = function(arg_96_0)
				return setmetatable({
					this = arg_96_0
				}, var_3_162)
			end
		}

		var_3_164.__index = var_3_164

		local var_3_165 = setmetatable({
			__name = "Persistent",
			__init = function(arg_97_0, arg_97_1, arg_97_2)
				if arg_97_2 == nil then
					arg_97_2 = "Value"
				end

				arg_97_0.this = arg_97_1
				arg_97_0.baseType = arg_97_2
			end,
			__base = var_3_164
		}, {
			__index = var_3_164,
			__call = function(arg_98_0, ...)
				local var_98_0 = setmetatable({}, var_3_164)

				arg_98_0.__init(var_98_0, ...)

				return var_98_0
			end
		})

		var_3_164.__class = var_3_165
		var_3_56 = var_3_165

		local var_3_166
		local var_3_167 = {
			fromLua = function(arg_99_0, arg_99_1)
				if arg_99_1 == nil then
					return var_3_65(var_3_149):getValue()
				end

				local var_99_0 = type(arg_99_1)

				if var_99_0 == "boolean" then
					return var_3_67(var_3_149, arg_99_1):getValue()
				elseif var_99_0 == "number" then
					return var_3_68(var_3_149, arg_99_1):getInstance()
				elseif var_99_0 == "string" then
					return var_3_70(var_3_149, arg_99_1):getInstance()
				elseif var_99_0 == "table" then
					if var_3_121(arg_99_1) then
						return var_3_59:fromLua(var_3_149, arg_99_1)
					else
						return var_3_58:fromLua(var_3_149, arg_99_1)
					end
				elseif var_99_0 == "function" then
					return var_3_62(var_3_120(arg_99_1)):getFunction()()
				else
					return error("Failed to convert from lua to v8js: Unknown type")
				end
			end,
			isUndefined = function(arg_100_0)
				return var_3_148:get("?IsUndefined@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_100_0.this)
			end,
			isNull = function(arg_101_0)
				return var_3_148:get("?IsNull@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_101_0.this)
			end,
			isBoolean = function(arg_102_0)
				return var_3_148:get("?IsBoolean@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_102_0.this)
			end,
			isBooleanObject = function(arg_103_0)
				return var_3_148:get("?IsBooleanObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_103_0.this)
			end,
			isNumber = function(arg_104_0)
				return var_3_148:get("?IsNumber@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_104_0.this)
			end,
			isNumberObject = function(arg_105_0)
				return var_3_148:get("?IsNumberObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_105_0.this)
			end,
			isString = function(arg_106_0)
				return var_3_148:get("?IsString@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_106_0.this)
			end,
			isStringObject = function(arg_107_0)
				return var_3_148:get("?IsStringObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_107_0.this)
			end,
			isObject = function(arg_108_0)
				return var_3_148:get("?IsObject@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_108_0.this)
			end,
			isArray = function(arg_109_0)
				return var_3_148:get("?IsArray@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_109_0.this)
			end,
			isFunction = function(arg_110_0)
				return var_3_148:get("?IsFunction@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_110_0.this)
			end,
			booleanValue = function(arg_111_0)
				return var_3_148:get("?BooleanValue@Value@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_111_0.this)
			end,
			numberValue = function(arg_112_0)
				return var_3_148:get("?NumberValue@Value@v8@@QBENXZ", "double(__thiscall*)(void*)")(arg_112_0.this)
			end,
			stringValue = function(arg_113_0)
				local var_113_0 = var_3_86("char*[2]")
				local var_113_1 = var_3_148:get("??0Utf8Value@String@v8@@QAE@V?$Local@VValue@v8@@@2@@Z", "struct{char* str; int length;}*(__thiscall*)(void*,void*)")(var_113_0, arg_113_0.this)
				local var_113_2 = var_3_87(var_113_1.str, var_113_1.length)

				var_3_148:get("??1Utf8Value@String@v8@@QAE@XZ", "void(__thiscall*)(void*)")(var_113_0)

				return var_113_2
			end,
			toObject = function(arg_114_0)
				return var_3_58(var_3_161(var_3_148:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(arg_114_0.this, var_3_123)):toValueChecked():getInternal())
			end,
			toArray = function(arg_115_0)
				return var_3_59(var_3_161(var_3_148:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(arg_115_0.this, var_3_123)):toValueChecked():getInternal())
			end,
			toFunction = function(arg_116_0)
				return var_3_60(var_3_161(var_3_148:get("?ToObject@Value@v8@@QBE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(arg_116_0.this, var_3_123)):toValueChecked():getInternal())
			end,
			toLocal = function(arg_117_0)
				return var_3_157(var_3_86("void*[1]", arg_117_0.this))
			end,
			toLua = function(arg_118_0)
				if arg_118_0:isUndefined() or arg_118_0:isNull() then
					return nil
				end

				if arg_118_0:isBoolean() or arg_118_0:isBooleanObject() then
					return arg_118_0:booleanValue()
				end

				if arg_118_0:isNumber() or arg_118_0:isNumberObject() then
					return arg_118_0:numberValue()
				end

				if arg_118_0:isString() or arg_118_0:isStringObject() then
					return arg_118_0:stringValue()
				end

				if arg_118_0:isObject() then
					if arg_118_0:isArray() then
						return arg_118_0:toArray():toLocal():globalize():setType("Array")()
					end

					if arg_118_0:isFunction() then
						return arg_118_0:toFunction():toLocal():globalize():setType("Function")()
					end

					return arg_118_0:toObject():toLocal():globalize():setType("Object")()
				end

				return error("Failed to convert from v8js to lua: Unknown type")
			end,
			getInternal = function(arg_119_0)
				return arg_119_0.this
			end
		}

		var_3_167.__index = var_3_167

		local var_3_168 = setmetatable({
			__name = "Value",
			__init = function(arg_120_0, arg_120_1)
				arg_120_0.this = var_3_84("void*", arg_120_1)
			end,
			__base = var_3_167
		}, {
			__index = var_3_167,
			__call = function(arg_121_0, ...)
				local var_121_0 = setmetatable({}, var_3_167)

				arg_121_0.__init(var_121_0, ...)

				return var_121_0
			end
		})

		var_3_167.__class = var_3_168
		var_3_57 = var_3_168

		local var_3_169
		local var_3_170 = var_3_57
		local var_3_171 = {
			fromLua = function(arg_122_0, arg_122_1, arg_122_2)
				local var_122_0 = var_3_58(var_3_161(var_3_148:get("?New@Object@v8@@SA?AV?$Local@VObject@v8@@@2@PAVIsolate@2@@Z", "void*(__cdecl*)(void*,void*)")(var_3_123, arg_122_1)):toValueChecked():getInternal())

				for iter_122_0, iter_122_1 in pairs(arg_122_2) do
					var_122_0:set(var_3_57:fromLua(iter_122_0):getInternal(), var_3_57:fromLua(iter_122_1):getInternal())
				end

				return var_122_0
			end,
			get = function(arg_123_0, arg_123_1)
				return var_3_161(var_3_148:get("?Get@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@V32@@Z", "void*(__thiscall*)(void*,void*,void*)")(arg_123_0.this, var_3_123, arg_123_1))
			end,
			set = function(arg_124_0, arg_124_1, arg_124_2)
				return var_3_148:get("?Set@Object@v8@@QAE_NV?$Local@VValue@v8@@@2@0@Z", "bool(__thiscall*)(void*,void*,void*)")(arg_124_0.this, arg_124_1, arg_124_2)
			end,
			getPropertyNames = function(arg_125_0)
				return var_3_161(var_3_148:get("?GetPropertyNames@Object@v8@@QAE?AV?$Local@VArray@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(arg_125_0.this, var_3_123))
			end,
			callAsFunction = function(arg_126_0, arg_126_1, arg_126_2, arg_126_3)
				return var_3_161(var_3_148:get("?CallAsFunction@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@V32@HQAV32@@Z", "void*(__thiscall*)(void*,void*,void*,int,void*)")(arg_126_0.this, var_3_123, arg_126_1, arg_126_2, arg_126_3))
			end,
			getIdentityHash = function(arg_127_0)
				return var_3_148:get("?GetIdentityHash@Object@v8@@QAEHXZ", "int(__thiscall*)(void*)")(arg_127_0.this)
			end
		}

		var_3_171.__index = var_3_171

		setmetatable(var_3_171, var_3_170.__base)

		local var_3_172 = setmetatable({
			__name = "Object",
			__init = function(arg_128_0, arg_128_1)
				arg_128_0.this = arg_128_1
			end,
			__base = var_3_171,
			__parent = var_3_170
		}, {
			__index = function(arg_129_0, arg_129_1)
				local var_129_0 = rawget(var_3_171, arg_129_1)

				if var_129_0 == nil then
					local var_129_1 = rawget(arg_129_0, "__parent")

					if var_129_1 then
						return var_129_1[arg_129_1]
					end
				else
					return var_129_0
				end
			end,
			__call = function(arg_130_0, ...)
				local var_130_0 = setmetatable({}, var_3_171)

				arg_130_0.__init(var_130_0, ...)

				return var_130_0
			end
		})

		var_3_171.__class = var_3_172

		if var_3_170.__inherited then
			var_3_170.__inherited(var_3_170, var_3_172)
		end

		var_3_58 = var_3_172

		local var_3_173
		local var_3_174 = var_3_58
		local var_3_175 = {
			fromLua = function(arg_131_0, arg_131_1, arg_131_2)
				local var_131_0 = var_3_59(var_3_161(var_3_148:get("?New@Array@v8@@SA?AV?$Local@VArray@v8@@@2@PAVIsolate@2@H@Z", "void*(__cdecl*)(void*,void*,int)")(var_3_123, arg_131_1, #arg_131_2)):toValueChecked():getInternal())

				for iter_131_0 = 1, #arg_131_2 do
					var_131_0:set(iter_131_0 - 1, var_3_57:fromLua(arg_131_2[iter_131_0]):getInternal())
				end

				return var_131_0
			end,
			get = function(arg_132_0, arg_132_1)
				return var_3_161(var_3_148:get("?Get@Object@v8@@QAE?AV?$Local@VValue@v8@@@2@I@Z", "void*(__thiscall*)(void*,void*,unsigned int)")(arg_132_0.this, var_3_123, arg_132_1))
			end,
			set = function(arg_133_0, arg_133_1, arg_133_2)
				return var_3_148:get("?Set@Object@v8@@QAE_NIV?$Local@VValue@v8@@@2@@Z", "bool(__thiscall*)(void*,unsigned int,void*)")(arg_133_0.this, arg_133_1, arg_133_2)
			end,
			length = function(arg_134_0)
				return var_3_148:get("?Length@Array@v8@@QBEIXZ", "uint32_t(__thiscall*)(void*)")(arg_134_0.this)
			end
		}

		var_3_175.__index = var_3_175

		setmetatable(var_3_175, var_3_174.__base)

		local var_3_176 = setmetatable({
			__name = "Array",
			__init = function(arg_135_0, arg_135_1)
				arg_135_0.this = arg_135_1
			end,
			__base = var_3_175,
			__parent = var_3_174
		}, {
			__index = function(arg_136_0, arg_136_1)
				local var_136_0 = rawget(var_3_175, arg_136_1)

				if var_136_0 == nil then
					local var_136_1 = rawget(arg_136_0, "__parent")

					if var_136_1 then
						return var_136_1[arg_136_1]
					end
				else
					return var_136_0
				end
			end,
			__call = function(arg_137_0, ...)
				local var_137_0 = setmetatable({}, var_3_175)

				arg_137_0.__init(var_137_0, ...)

				return var_137_0
			end
		})

		var_3_175.__class = var_3_176

		if var_3_174.__inherited then
			var_3_174.__inherited(var_3_174, var_3_176)
		end

		var_3_59 = var_3_176

		local var_3_177
		local var_3_178 = var_3_58
		local var_3_179 = {
			setParent = function(arg_138_0, arg_138_1)
				arg_138_0.parent = arg_138_1

				return arg_138_0
			end,
			__call = function(arg_139_0, ...)
				if arg_139_0.parent == nil then
					return arg_139_0:callAsFunction(var_3_72(var_3_71():getCurrentContext()):global():toValueChecked():getInternal(), var_3_119(...))
				else
					return arg_139_0:callAsFunction(arg_139_0.parent:getAsValue():getInternal(), var_3_119(...))
				end
			end
		}

		var_3_179.__index = var_3_179

		setmetatable(var_3_179, var_3_178.__base)

		local var_3_180 = setmetatable({
			__name = "Function",
			__init = function(arg_140_0, arg_140_1, arg_140_2)
				arg_140_0.this = arg_140_1
				arg_140_0.parent = arg_140_2
			end,
			__base = var_3_179,
			__parent = var_3_178
		}, {
			__index = function(arg_141_0, arg_141_1)
				local var_141_0 = rawget(var_3_179, arg_141_1)

				if var_141_0 == nil then
					local var_141_1 = rawget(arg_141_0, "__parent")

					if var_141_1 then
						return var_141_1[arg_141_1]
					end
				else
					return var_141_0
				end
			end,
			__call = function(arg_142_0, ...)
				local var_142_0 = setmetatable({}, var_3_179)

				arg_142_0.__init(var_142_0, ...)

				return var_142_0
			end
		})

		var_3_179.__class = var_3_180

		if var_3_178.__inherited then
			var_3_178.__inherited(var_3_178, var_3_180)
		end

		var_3_60 = var_3_180

		local var_3_181
		local var_3_182 = {}

		var_3_182.__index = var_3_182

		local var_3_183 = setmetatable({
			__name = "ObjectTemplate",
			__init = function(arg_143_0)
				arg_143_0.this = var_3_161(var_3_148:get("?New@ObjectTemplate@v8@@SA?AV?$Local@VObjectTemplate@v8@@@2@XZ", "void*(__cdecl*)(void*)")(var_3_123)):toLocalChecked()
			end,
			__base = var_3_182
		}, {
			__index = var_3_182,
			__call = function(arg_144_0, ...)
				local var_144_0 = setmetatable({}, var_3_182)

				arg_144_0.__init(var_144_0, ...)

				return var_144_0
			end
		})

		var_3_182.__class = var_3_183

		local var_3_184 = var_3_183
		local var_3_185
		local var_3_186 = {
			getFunction = function(arg_145_0)
				return var_3_161(var_3_148:get("?GetFunction@FunctionTemplate@v8@@QAE?AV?$Local@VFunction@v8@@@2@XZ", "void*(__thiscall*)(void*, void*)")(arg_145_0:this():getInternal(), var_3_123)):toLocalChecked()
			end,
			getInstance = function(arg_146_0)
				return arg_146_0:this()
			end
		}

		var_3_186.__index = var_3_186

		local var_3_187 = setmetatable({
			__name = "FunctionTemplate",
			__init = function(arg_147_0, arg_147_1)
				arg_147_0.this = var_3_161(var_3_148:get("?New@FunctionTemplate@v8@@SA?AV?$Local@VFunctionTemplate@v8@@@2@PAVIsolate@2@P6AXABV?$FunctionCallbackInfo@VValue@v8@@@2@@ZV?$Local@VValue@v8@@@2@V?$Local@VSignature@v8@@@2@HW4ConstructorBehavior@2@@Z", "void*(__cdecl*)(void*,void*,void*,void*,void*,int,int)")(var_3_123, var_3_149, var_3_84("void(__cdecl*)(void******)", arg_147_1), var_3_86("int[1]"), var_3_86("int[1]"), 0, 0)):toLocalChecked()
			end,
			__base = var_3_186
		}, {
			__index = var_3_186,
			__call = function(arg_148_0, ...)
				local var_148_0 = setmetatable({}, var_3_186)

				arg_148_0.__init(var_148_0, ...)

				return var_148_0
			end
		})

		var_3_186.__class = var_3_187
		var_3_62 = var_3_187

		local var_3_188
		local var_3_189 = {
			kContextSaveIndex = 6,
			kNewTargetIndex = 7,
			kDataIndex = 4,
			kReturnValueDefaultValueIndex = 2,
			kReturnValueIndex = 3,
			kHolderIndex = 0,
			kCalleeIndex = 5,
			kIsolateIndex = 1,
			getHolder = function(arg_149_0)
				return var_3_161(arg_149_0:getImplicitArgs_()[arg_149_0.kHolderIndex]):toLocalChecked()
			end,
			getIsolate = function(arg_150_0)
				return var_3_71(arg_150_0:getImplicitArgs_()[arg_150_0.kIsolateIndex][0])
			end,
			getReturnValueDefaultValue = function(arg_151_0)
				return var_3_57(var_3_86("void*[1]", arg_151_0:getImplicitArgs_()[arg_151_0.kReturnValueDefaultValueIndex]))
			end,
			getReturnValue = function(arg_152_0)
				return var_3_57(var_3_86("void*[1]", arg_152_0:getImplicitArgs_()[arg_152_0.kReturnValueIndex]))
			end,
			setReturnValue = function(arg_153_0, arg_153_1)
				arg_153_0:getImplicitArgs_()[arg_153_0.kReturnValueIndex] = var_3_84("void**", arg_153_1)[0]
			end,
			getData = function(arg_154_0)
				return var_3_161(arg_154_0:getImplicitArgs_()[arg_154_0.kDataIndex]):toLocalChecked()
			end,
			getCallee = function(arg_155_0)
				return var_3_161(arg_155_0:getImplicitArgs_()[arg_155_0.kCalleeIndex]):toLocalChecked()
			end,
			getContextSave = function(arg_156_0)
				return var_3_161(arg_156_0:getImplicitArgs_()[arg_156_0.kContextSaveIndex]):toLocalChecked()
			end,
			getNewTarget = function(arg_157_0)
				return var_3_161(arg_157_0:getImplicitArgs_()[arg_157_0.kNewTargetIndex]):toLocalChecked()
			end,
			getImplicitArgs_ = function(arg_158_0)
				return arg_158_0.this[0]
			end,
			getValues_ = function(arg_159_0)
				return arg_159_0.this[1]
			end,
			getLength_ = function(arg_160_0)
				return arg_160_0.this[2]
			end,
			length = function(arg_161_0)
				return tonumber(var_3_84("int", arg_161_0:getLength_()))
			end,
			get = function(arg_162_0, arg_162_1)
				if arg_162_1 < arg_162_0:length() then
					return var_3_57(arg_162_0:getValues_() - arg_162_1):toLua()
				else
					return
				end
			end
		}

		var_3_189.__index = var_3_189

		local var_3_190 = setmetatable({
			__name = "FunctionCallbackInfo",
			__init = function(arg_163_0, arg_163_1)
				arg_163_0.this = var_3_84("void****", arg_163_1)
			end,
			__base = var_3_189
		}, {
			__index = var_3_189,
			__call = function(arg_164_0, ...)
				local var_164_0 = setmetatable({}, var_3_189)

				arg_164_0.__init(var_164_0, ...)

				return var_164_0
			end
		})

		var_3_189.__class = var_3_190
		var_3_63 = var_3_190

		local var_3_191
		local var_3_192 = var_3_57
		local var_3_193 = {
			getValue = function(arg_165_0)
				return arg_165_0.this
			end,
			toString = function(arg_166_0)
				return arg_166_0.this:getValue():stringValue()
			end
		}

		var_3_193.__index = var_3_193

		setmetatable(var_3_193, var_3_192.__base)

		local var_3_194 = setmetatable({
			__name = "Primitive",
			__init = function(arg_167_0, arg_167_1)
				arg_167_0.this = arg_167_1
			end,
			__base = var_3_193,
			__parent = var_3_192
		}, {
			__index = function(arg_168_0, arg_168_1)
				local var_168_0 = rawget(var_3_193, arg_168_1)

				if var_168_0 == nil then
					local var_168_1 = rawget(arg_168_0, "__parent")

					if var_168_1 then
						return var_168_1[arg_168_1]
					end
				else
					return var_168_0
				end
			end,
			__call = function(arg_169_0, ...)
				local var_169_0 = setmetatable({}, var_3_193)

				arg_169_0.__init(var_169_0, ...)

				return var_169_0
			end
		})

		var_3_193.__class = var_3_194

		if var_3_192.__inherited then
			var_3_192.__inherited(var_3_192, var_3_194)
		end

		local var_3_195 = var_3_194
		local var_3_196
		local var_3_197 = var_3_195
		local var_3_198 = {}

		var_3_198.__index = var_3_198

		setmetatable(var_3_198, var_3_197.__base)

		local var_3_199 = setmetatable({
			__name = "Null",
			__init = function(arg_170_0, arg_170_1)
				arg_170_0.this = var_3_57(var_3_84("uintptr_t", arg_170_1) + 72)
			end,
			__base = var_3_198,
			__parent = var_3_197
		}, {
			__index = function(arg_171_0, arg_171_1)
				local var_171_0 = rawget(var_3_198, arg_171_1)

				if var_171_0 == nil then
					local var_171_1 = rawget(arg_171_0, "__parent")

					if var_171_1 then
						return var_171_1[arg_171_1]
					end
				else
					return var_171_0
				end
			end,
			__call = function(arg_172_0, ...)
				local var_172_0 = setmetatable({}, var_3_198)

				arg_172_0.__init(var_172_0, ...)

				return var_172_0
			end
		})

		var_3_198.__class = var_3_199

		if var_3_197.__inherited then
			var_3_197.__inherited(var_3_197, var_3_199)
		end

		var_3_65 = var_3_199

		local var_3_200
		local var_3_201 = var_3_195
		local var_3_202 = {}

		var_3_202.__index = var_3_202

		setmetatable(var_3_202, var_3_201.__base)

		local var_3_203 = setmetatable({
			__name = "Undefined",
			__init = function(arg_173_0, arg_173_1)
				arg_173_0.this = var_3_57(var_3_84("uintptr_t", arg_173_1) + 86)
			end,
			__base = var_3_202,
			__parent = var_3_201
		}, {
			__index = function(arg_174_0, arg_174_1)
				local var_174_0 = rawget(var_3_202, arg_174_1)

				if var_174_0 == nil then
					local var_174_1 = rawget(arg_174_0, "__parent")

					if var_174_1 then
						return var_174_1[arg_174_1]
					end
				else
					return var_174_0
				end
			end,
			__call = function(arg_175_0, ...)
				local var_175_0 = setmetatable({}, var_3_202)

				arg_175_0.__init(var_175_0, ...)

				return var_175_0
			end
		})

		var_3_202.__class = var_3_203

		if var_3_201.__inherited then
			var_3_201.__inherited(var_3_201, var_3_203)
		end

		local var_3_204 = var_3_203
		local var_3_205
		local var_3_206 = var_3_195
		local var_3_207 = {}

		var_3_207.__index = var_3_207

		setmetatable(var_3_207, var_3_206.__base)

		local var_3_208 = setmetatable({
			__name = "Boolean",
			__init = function(arg_176_0, arg_176_1, arg_176_2)
				arg_176_0.this = var_3_57(var_3_84("uintptr_t", arg_176_1) + (function()
					if arg_176_2 then
						return 76
					else
						return 80
					end
				end)())
			end,
			__base = var_3_207,
			__parent = var_3_206
		}, {
			__index = function(arg_178_0, arg_178_1)
				local var_178_0 = rawget(var_3_207, arg_178_1)

				if var_178_0 == nil then
					local var_178_1 = rawget(arg_178_0, "__parent")

					if var_178_1 then
						return var_178_1[arg_178_1]
					end
				else
					return var_178_0
				end
			end,
			__call = function(arg_179_0, ...)
				local var_179_0 = setmetatable({}, var_3_207)

				arg_179_0.__init(var_179_0, ...)

				return var_179_0
			end
		})

		var_3_207.__class = var_3_208

		if var_3_206.__inherited then
			var_3_206.__inherited(var_3_206, var_3_208)
		end

		var_3_67 = var_3_208

		local var_3_209
		local var_3_210 = var_3_57
		local var_3_211 = {
			getLocal = function(arg_180_0)
				return arg_180_0.this
			end,
			getValue = function(arg_181_0)
				return arg_181_0:getInstance():numberValue()
			end,
			getInstance = function(arg_182_0)
				return arg_182_0:this()
			end
		}

		var_3_211.__index = var_3_211

		setmetatable(var_3_211, var_3_210.__base)

		local var_3_212 = setmetatable({
			__name = "Number",
			__init = function(arg_183_0, arg_183_1, arg_183_2)
				arg_183_0.this = var_3_161(var_3_148:get("?New@Number@v8@@SA?AV?$Local@VNumber@v8@@@2@PAVIsolate@2@N@Z", "void*(__cdecl*)(void*,void*,double)")(var_3_123, arg_183_1, tonumber(arg_183_2))):toLocalChecked()
			end,
			__base = var_3_211,
			__parent = var_3_210
		}, {
			__index = function(arg_184_0, arg_184_1)
				local var_184_0 = rawget(var_3_211, arg_184_1)

				if var_184_0 == nil then
					local var_184_1 = rawget(arg_184_0, "__parent")

					if var_184_1 then
						return var_184_1[arg_184_1]
					end
				else
					return var_184_0
				end
			end,
			__call = function(arg_185_0, ...)
				local var_185_0 = setmetatable({}, var_3_211)

				arg_185_0.__init(var_185_0, ...)

				return var_185_0
			end
		})

		var_3_211.__class = var_3_212

		if var_3_210.__inherited then
			var_3_210.__inherited(var_3_210, var_3_212)
		end

		var_3_68 = var_3_212

		local var_3_213
		local var_3_214 = var_3_68
		local var_3_215 = {}

		var_3_215.__index = var_3_215

		setmetatable(var_3_215, var_3_214.__base)

		local var_3_216 = setmetatable({
			__name = "Integer",
			__init = function(arg_186_0, arg_186_1, arg_186_2)
				arg_186_0.this = var_3_161(var_3_148:get("?NewFromUnsigned@Integer@v8@@SA?AV?$Local@VInteger@v8@@@2@PAVIsolate@2@I@Z", "void*(__cdecl*)(void*,void*,uint32_t)")(var_3_123, arg_186_1, tonumber(arg_186_2))):toLocalChecked()
			end,
			__base = var_3_215,
			__parent = var_3_214
		}, {
			__index = function(arg_187_0, arg_187_1)
				local var_187_0 = rawget(var_3_215, arg_187_1)

				if var_187_0 == nil then
					local var_187_1 = rawget(arg_187_0, "__parent")

					if var_187_1 then
						return var_187_1[arg_187_1]
					end
				else
					return var_187_0
				end
			end,
			__call = function(arg_188_0, ...)
				local var_188_0 = setmetatable({}, var_3_215)

				arg_188_0.__init(var_188_0, ...)

				return var_188_0
			end
		})

		var_3_215.__class = var_3_216

		if var_3_214.__inherited then
			var_3_214.__inherited(var_3_214, var_3_216)
		end

		local var_3_217 = var_3_216
		local var_3_218
		local var_3_219 = var_3_57
		local var_3_220 = {
			getLocal = function(arg_189_0)
				return arg_189_0.this
			end,
			getValue = function(arg_190_0)
				return arg_190_0:getInstance():stringValue()
			end,
			getInstance = function(arg_191_0)
				return arg_191_0:this()
			end
		}

		var_3_220.__index = var_3_220

		setmetatable(var_3_220, var_3_219.__base)

		local var_3_221 = setmetatable({
			__name = "String",
			__init = function(arg_192_0, arg_192_1, arg_192_2)
				arg_192_0.this = var_3_161(var_3_148:get("?NewFromUtf8@String@v8@@SA?AV?$MaybeLocal@VString@v8@@@2@PAVIsolate@2@PBDW4NewStringType@2@H@Z", "void*(__cdecl*)(void*,void*,const char*,int,int)")(var_3_123, arg_192_1, arg_192_2, 0, #arg_192_2)):toLocalChecked()
			end,
			__base = var_3_220,
			__parent = var_3_219
		}, {
			__index = function(arg_193_0, arg_193_1)
				local var_193_0 = rawget(var_3_220, arg_193_1)

				if var_193_0 == nil then
					local var_193_1 = rawget(arg_193_0, "__parent")

					if var_193_1 then
						return var_193_1[arg_193_1]
					end
				else
					return var_193_0
				end
			end,
			__call = function(arg_194_0, ...)
				local var_194_0 = setmetatable({}, var_3_220)

				arg_194_0.__init(var_194_0, ...)

				return var_194_0
			end
		})

		var_3_220.__class = var_3_221

		if var_3_219.__inherited then
			var_3_219.__inherited(var_3_219, var_3_221)
		end

		var_3_70 = var_3_221

		local var_3_222
		local var_3_223 = {
			enter = function(arg_195_0)
				return var_3_148:get("?Enter@Isolate@v8@@QAEXXZ", "void(__thiscall*)(void*)")(arg_195_0.this)
			end,
			exit = function(arg_196_0)
				return var_3_148:get("?Exit@Isolate@v8@@QAEXXZ", "void(__thiscall*)(void*)")(arg_196_0.this)
			end,
			getCurrentContext = function(arg_197_0)
				return var_3_161(var_3_148:get("?GetCurrentContext@Isolate@v8@@QAE?AV?$Local@VContext@v8@@@2@XZ", "void**(__thiscall*)(void*,void*)")(arg_197_0.this, var_3_123)):toValueChecked():getInternal()
			end,
			getInternal = function(arg_198_0)
				return arg_198_0.this
			end
		}

		var_3_223.__index = var_3_223

		local var_3_224 = setmetatable({
			__name = "Isolate",
			__init = function(arg_199_0, arg_199_1)
				if arg_199_1 == nil then
					arg_199_1 = var_3_149
				end

				arg_199_0.this = arg_199_1
			end,
			__base = var_3_223
		}, {
			__index = var_3_223,
			__call = function(arg_200_0, ...)
				local var_200_0 = setmetatable({}, var_3_223)

				arg_200_0.__init(var_200_0, ...)

				return var_200_0
			end
		})

		var_3_223.__class = var_3_224
		var_3_71 = var_3_224

		local var_3_225
		local var_3_226 = {
			enter = function(arg_201_0)
				return var_3_148:get("?Enter@Context@v8@@QAEXXZ", "void(__thiscall*)(void*)")(arg_201_0.this)
			end,
			exit = function(arg_202_0)
				return var_3_148:get("?Exit@Context@v8@@QAEXXZ", "void(__thiscall*)(void*)")(arg_202_0.this)
			end,
			global = function(arg_203_0)
				return var_3_161(var_3_148:get("?Global@Context@v8@@QAE?AV?$Local@VObject@v8@@@2@XZ", "void*(__thiscall*)(void*,void*)")(arg_203_0.this, var_3_123))
			end
		}

		var_3_226.__index = var_3_226

		local var_3_227 = setmetatable({
			__name = "Context",
			__init = function(arg_204_0, arg_204_1)
				arg_204_0.this = arg_204_1
			end,
			__base = var_3_226
		}, {
			__index = var_3_226,
			__call = function(arg_205_0, ...)
				local var_205_0 = setmetatable({}, var_3_226)

				arg_205_0.__init(var_205_0, ...)

				return var_205_0
			end
		})

		var_3_226.__class = var_3_227
		var_3_72 = var_3_227

		local var_3_228
		local var_3_229 = {
			enter = function(arg_206_0)
				return var_3_148:get("??0HandleScope@v8@@QAE@PAVIsolate@1@@Z", "void(__thiscall*)(void*,void*)")(arg_206_0.this, var_3_149)
			end,
			exit = function(arg_207_0)
				return var_3_148:get("??1HandleScope@v8@@QAE@XZ", "void(__thiscall*)(void*)")(arg_207_0.this)
			end,
			createHandle = function(arg_208_0, arg_208_1)
				return var_3_148:get("?CreateHandle@HandleScope@v8@@KAPAPAVObject@internal@2@PAVIsolate@42@PAV342@@Z", "void**(__cdecl*)(void*,void*)")(var_3_149, arg_208_1)
			end,
			__call = function(arg_209_0, arg_209_1, arg_209_2)
				if arg_209_2 == nil then
					arg_209_2 = var_3_124.GetPanel("CSGOJsRegistration")
				end

				local var_209_0 = var_3_71()

				var_209_0:enter()
				arg_209_0:enter()

				local var_209_1

				if arg_209_2 then
					var_209_1 = var_3_145(var_3_147(arg_209_2))[0]
				else
					var_209_1 = var_3_72(var_209_0:getCurrentContext()):global():getInternal()
				end

				var_209_1 = var_3_72((function()
					if var_209_1 ~= var_3_122 then
						return arg_209_0:createHandle(var_209_1[0])
					else
						return 0
					end
				end)())

				var_209_1:enter()

				local var_209_2

				if var_3_103 then
					local var_209_3, var_209_4 = xpcall(arg_209_1, var_3_107)

					if var_209_3 then
						var_209_2 = var_209_4
					end
				else
					var_209_2 = arg_209_1()
				end

				var_209_1:exit()
				arg_209_0:exit()
				var_209_0:exit()

				return var_209_2
			end
		}

		var_3_229.__index = var_3_229

		local var_3_230 = setmetatable({
			__name = "HandleScope",
			__init = function(arg_211_0)
				arg_211_0.this = var_3_86("char[0xC]")
			end,
			__base = var_3_229
		}, {
			__index = var_3_229,
			__call = function(arg_212_0, ...)
				local var_212_0 = setmetatable({}, var_3_229)

				arg_212_0.__init(var_212_0, ...)

				return var_212_0
			end
		})

		var_3_229.__class = var_3_230
		var_3_73 = var_3_230

		local var_3_231
		local var_3_232 = {
			enter = function(arg_213_0)
				return var_3_148:get("??0TryCatch@v8@@QAE@PAVIsolate@1@@Z", "void(__thiscall*)(void*, void*)")(arg_213_0.this, var_3_149)
			end,
			exit = function(arg_214_0)
				return var_3_148:get("??1TryCatch@v8@@QAE@XZ", "void(__thiscall*)(void*)")(arg_214_0.this)
			end,
			canContinue = function(arg_215_0)
				return var_3_148:get("?CanContinue@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_215_0.this)
			end,
			hasTerminated = function(arg_216_0)
				return var_3_148:get("?HasTerminated@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_216_0.this)
			end,
			hasCaught = function(arg_217_0)
				return var_3_148:get("?HasCaught@TryCatch@v8@@QBE_NXZ", "bool(__thiscall*)(void*)")(arg_217_0.this)
			end,
			message = function(arg_218_0)
				return var_3_157(var_3_148:get("?Message@TryCatch@v8@@QBE?AV?$Local@VMessage@v8@@@2@XZ", "void*(__thiscall*)(void*, void*)")(arg_218_0.this, var_3_123))
			end,
			getInternal = function(arg_219_0)
				return arg_219_0.this
			end
		}

		var_3_232.__index = var_3_232

		local var_3_233 = setmetatable({
			__name = "TryCatch",
			__init = function(arg_220_0)
				arg_220_0.this = var_3_86("char[0x19]")
			end,
			__base = var_3_232
		}, {
			__index = var_3_232,
			__call = function(arg_221_0, ...)
				local var_221_0 = setmetatable({}, var_3_232)

				arg_221_0.__init(var_221_0, ...)

				return var_221_0
			end
		})

		var_3_232.__class = var_3_233
		var_3_74 = var_3_233

		local var_3_234
		local var_3_235 = {
			compile = function(arg_222_0, arg_222_1, arg_222_2, arg_222_3)
				if arg_222_3 == nil then
					arg_222_3 = ""
				end

				return var_3_111(var_3_84("void**(__thiscall*)(void*,void*,const char*,const char*)", var_3_92 == "memesense" and var_3_89("panorama.dll", "E8 ? ? ? ? 8B 4C 24 10 FF 15") - 2816 or var_3_89("panorama.dll", "55 8B EC 83 E4 F8 83 EC 64 53 8B D9")), var_3_133:getInstance())(arg_222_1, arg_222_2, arg_222_3)
			end,
			loadstring = function(arg_223_0, arg_223_1, arg_223_2)
				local var_223_0 = var_3_161(arg_223_0:compile(arg_223_2, arg_223_1)):toLocalChecked()

				if var_223_0 == var_3_122 then
					if var_3_103 then
						error("\nFailed to compile the given javascript string, please check the error message above ^\n")
					else
						print("\nFailed to compile the given javascript string, please check the error message above ^\n")

						return function()
							return print("WARNING: Attempted to call nullptr (script compilation failed)")
						end
					end
				end

				local var_223_1 = var_3_71()
				local var_223_2 = var_3_73()

				var_223_1:enter()
				var_223_2:enter()

				local var_223_3

				if arg_223_2 then
					var_223_3 = var_3_145(var_3_147(arg_223_2))[0]
				else
					var_223_3 = var_3_72(var_223_1:getCurrentContext()):global():getInternal()
				end

				var_223_3 = var_3_72((function()
					if var_223_3 ~= var_3_122 then
						return var_223_2:createHandle(var_223_3[0])
					else
						return 0
					end
				end)())

				var_223_3:enter()

				local var_223_4 = var_3_161(var_3_137(var_3_123, arg_223_2, var_223_0():getInternal(), 0, false)):toValueChecked()

				if var_223_4 == var_3_122 then
					if var_3_103 then
						error("\nFailed to evaluate the given javascript string, please check the error message above ^\n")
					else
						print("\nFailed to evaluate the given javascript string, please check the error message above ^\n")

						function var_223_4()
							return print("WARNING: Attempted to call nullptr (script execution failed)")
						end
					end
				else
					var_223_4 = var_223_4:toLua()
				end

				var_223_3:exit()
				var_223_2:exit()
				var_223_1:exit()

				return var_223_4
			end
		}

		var_3_235.__index = var_3_235

		local var_3_236 = setmetatable({
			__name = "Script",
			__init = function()
				return
			end,
			__base = var_3_235
		}, {
			__index = var_3_235,
			__call = function(arg_228_0, ...)
				local var_228_0 = setmetatable({}, var_3_235)

				arg_228_0.__init(var_228_0, ...)

				return var_228_0
			end
		})

		var_3_235.__class = var_3_236

		local var_3_237 = var_3_236
		local var_3_238 = var_3_85("    struct {\n        char* pad1[0x4];\n        void*         m_pPanel;\n        void* unk1;\n    }\n")
		local var_3_239 = var_3_85("    struct {\n        struct {\n            $ *m_pMemory;\n            int m_nAllocationCount;\n            int m_nGrowSize;\n        } m_Memory;\n        int m_Size;\n        $ *m_pElements;\n    }\n", var_3_238, var_3_238)

		var_3_88(var_3_239, {
			__index = {
				Count = function(arg_229_0)
					return arg_229_0.m_Memory.m_nAllocationCount
				end,
				Element = function(arg_230_0, arg_230_1)
					return var_3_84(var_3_85("$&", var_3_238), arg_230_0.m_Memory.m_pMemory[arg_230_1])
				end,
				RemoveAll = function(arg_231_0)
					arg_231_0 = nil
					arg_231_0 = var_3_85("$[?]", var_3_239)(1)[0]
					arg_231_0.m_Size = 0
				end
			},
			__ipairs = function(arg_232_0)
				local var_232_0 = 0
				local var_232_1 = arg_232_0:Count()

				return function()
					var_232_0 = var_232_0 + 1

					local var_233_0 = arg_232_0:Element(var_232_0 - 1).m_pPanel

					if var_232_0 <= var_232_1 and var_3_134(var_233_0) then
						return var_232_0, var_233_0
					end
				end
			end
		})

		local var_3_240 = var_3_85("$[?]", var_3_239)(1)[0]
		local var_3_241 = var_3_84("unsigned int*", var_3_84("uintptr_t**", var_3_133:getInstance())[0][36] + 21)[0]
		local var_3_242 = var_3_84(var_3_240, var_3_84("uintptr_t", var_3_133:getInstance()) + var_3_241)

		function var_3_124.hasPanel(arg_234_0)
			for iter_234_0, iter_234_1 in ipairs(var_3_242) do
				if var_3_87(var_3_142(iter_234_1)) == arg_234_0 then
					return true
				end
			end

			return false
		end

		function var_3_124.getPanel(arg_235_0, arg_235_1)
			local var_235_0 = var_3_124.panelIDs[arg_235_0]

			if var_235_0 ~= nil and var_3_134(var_235_0) and var_3_87(var_3_142(var_235_0)) == arg_235_0 then
				return var_235_0
			end

			var_3_124.panelIDs = {}

			local var_235_1 = var_3_122

			for iter_235_0, iter_235_1 in ipairs(var_3_242) do
				local var_235_2 = var_3_87(var_3_142(iter_235_1))

				if var_235_2 ~= "" then
					var_3_124.panelIDs[var_235_2] = iter_235_1

					if var_235_2 == arg_235_0 then
						var_235_1 = iter_235_1

						break
					end
				end
			end

			if var_235_1 == var_3_122 then
				if arg_235_1 ~= nil then
					var_235_1 = var_3_124.getPanel(arg_235_1)
				else
					error(("Failed to get target panel %s (EAX == 0)"):format(tostring(arg_235_0)))
				end
			end

			return var_235_1
		end

		function var_3_124.getIsolate()
			return var_3_71(var_3_139())
		end

		function var_3_124.runScript(arg_237_0, arg_237_1, arg_237_2)
			if arg_237_1 == nil then
				arg_237_1 = var_3_124.getPanel("CSGOJsRegistration")
			end

			if arg_237_2 == nil then
				arg_237_2 = "panorama/layout/base.xml"
			end

			if not var_3_134(arg_237_1) then
				error("Invalid panel pointer (EAX == 0)")
			end

			return var_3_136(arg_237_1, arg_237_0, arg_237_2, 8, 10, false)
		end

		function var_3_124.loadstring(arg_238_0, arg_238_1)
			if arg_238_1 == nil then
				arg_238_1 = "CSGOJsRegistration"
			end

			local var_238_0 = "CSGOJsRegistration"

			if arg_238_1 == "CSGOMainMenu" then
				var_238_0 = "CSGOHud"
			end

			if arg_238_1 == "CSGOHud" then
				var_238_0 = "CSGOMainMenu"
			end

			return var_3_237:loadstring(("(()=>{%s})"):format(arg_238_0), var_3_124.getPanel(arg_238_1, var_238_0))
		end

		function var_3_124.open(arg_239_0)
			if arg_239_0 == nil then
				arg_239_0 = "CSGOJsRegistration"
			end

			local var_239_0 = "CSGOJsRegistration"

			if arg_239_0 == "CSGOMainMenu" then
				var_239_0 = "CSGOHud"
			end

			if arg_239_0 == "CSGOHud" then
				var_239_0 = "CSGOMainMenu"
			end

			return var_3_73()(function()
				return var_3_72(var_3_71():getCurrentContext()):global():toValueChecked():toLua()
			end, var_3_124.GetPanel(arg_239_0, var_239_0))
		end

		var_3_124.GetPanel = var_3_124.getPanel
		var_3_124.GetIsolate = var_3_124.getIsolate
		var_3_124.RunScript = var_3_124.runScript
		var_3_124.panelArray = var_3_242
		var_3_124.info = var_3_81
		var_3_124.flush = var_3_105

		setmetatable(var_3_124, {
			__tostring = function(arg_241_0)
				return ("luv8 panorama library v%.1f"):format(var_3_81._VERSION)
			end,
			__index = function(arg_242_0, arg_242_1)
				if var_3_124.hasPanel(arg_242_1) then
					return var_3_124.open(arg_242_1)
				end

				return var_3_124.open()[arg_242_1]
			end
		})

		return var_3_124
	end)()
end

local var_0_47 = (function()
	local var_243_0 = true
	local var_243_1 = false
	local var_243_2 = "json"
	local var_243_3 = pairs
	local var_243_4 = type
	local var_243_5 = tostring
	local var_243_6 = tonumber
	local var_243_7 = getmetatable
	local var_243_8 = setmetatable
	local var_243_9 = rawset
	local var_243_10 = error
	local var_243_11 = require
	local var_243_12 = pcall
	local var_243_13 = select
	local var_243_14 = math.floor
	local var_243_15 = math.huge
	local var_243_16 = string.rep
	local var_243_17 = string.gsub
	local var_243_18 = string.sub
	local var_243_19 = string.byte
	local var_243_20 = string.char
	local var_243_21 = string.find
	local var_243_22 = string.len
	local var_243_23 = string.format
	local var_243_24 = string.match
	local var_243_25 = table.concat
	local var_243_26 = {
		version = "dkjson 2.5"
	}

	if var_243_1 then
		_G[var_243_2] = var_243_26
	end

	local var_243_27

	var_243_12(function()
		local var_244_0 = var_243_11("debug").getmetatable

		if var_244_0 then
			var_243_7 = var_244_0
		end
	end)

	var_243_26.null = var_243_8({}, {
		__tojson = function()
			return "null"
		end
	})

	local function var_243_28(arg_246_0)
		local var_246_0 = 0
		local var_246_1 = 0
		local var_246_2 = 0

		for iter_246_0, iter_246_1 in var_243_3(arg_246_0) do
			if iter_246_0 == "n" and var_243_4(iter_246_1) == "number" then
				var_246_2 = iter_246_1

				if var_246_0 < iter_246_1 then
					var_246_0 = iter_246_1
				end
			else
				if var_243_4(iter_246_0) ~= "number" or iter_246_0 < 1 or var_243_14(iter_246_0) ~= iter_246_0 then
					return false
				end

				if var_246_0 < iter_246_0 then
					var_246_0 = iter_246_0
				end

				var_246_1 = var_246_1 + 1
			end
		end

		if var_246_0 > 10 and var_246_2 < var_246_0 and var_246_0 > var_246_1 * 2 then
			return false
		end

		return true, var_246_0
	end

	local var_243_29 = {
		["\f"] = "\\f",
		["\b"] = "\\b",
		["\n"] = "\\n",
		["\t"] = "\\t",
		["\\"] = "\\\\",
		["\r"] = "\\r",
		["\""] = "\\\""
	}

	local function var_243_30(arg_247_0)
		local var_247_0 = var_243_29[arg_247_0]

		if var_247_0 then
			return var_247_0
		end

		local var_247_1, var_247_2, var_247_3, var_247_4 = var_243_19(arg_247_0, 1, 4)
		local var_247_5, var_247_6, var_247_7

		var_247_5, var_247_6, var_247_7, var_247_4 = var_247_1 or 0, var_247_2 or 0, var_247_3 or 0, var_247_4 or 0

		if var_247_5 <= 127 then
			var_247_0 = var_247_5
		elseif var_247_5 >= 192 and var_247_5 <= 223 and var_247_6 >= 128 then
			var_247_0 = (var_247_5 - 192) * 64 + var_247_6 - 128
		elseif var_247_5 >= 224 and var_247_5 <= 239 and var_247_6 >= 128 and var_247_7 >= 128 then
			var_247_0 = ((var_247_5 - 224) * 64 + var_247_6 - 128) * 64 + var_247_7 - 128
		elseif var_247_5 >= 240 and var_247_5 <= 247 and var_247_6 >= 128 and var_247_7 >= 128 and var_247_4 >= 128 then
			var_247_0 = (((var_247_5 - 240) * 64 + var_247_6 - 128) * 64 + var_247_7 - 128) * 64 + var_247_4 - 128
		else
			return ""
		end

		if var_247_0 <= 65535 then
			return var_243_23("\\u%.4x", var_247_0)
		elseif var_247_0 <= 1114111 then
			local var_247_8 = var_247_0 - 65536
			local var_247_9 = 55296 + var_243_14(var_247_8 / 1024)
			local var_247_10 = 56320 + var_247_8 % 1024

			return var_243_23("\\u%.4x\\u%.4x", var_247_9, var_247_10)
		else
			return ""
		end
	end

	local function var_243_31(arg_248_0, arg_248_1, arg_248_2)
		if var_243_21(arg_248_0, arg_248_1) then
			return var_243_17(arg_248_0, arg_248_1, arg_248_2)
		else
			return arg_248_0
		end
	end

	local function var_243_32(arg_249_0)
		arg_249_0 = var_243_31(arg_249_0, "[%z\x01-\x1F\"\\\x7F]", var_243_30)

		if var_243_21(arg_249_0, "[\xC2\xD8\xDC\xE1\xE2\xEF]") then
			arg_249_0 = var_243_31(arg_249_0, "\xC2[\x80-\x9F\xAD]", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "\xD8[\x80-\x84]", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "܏", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "\xE1\x9E[\xB4\xB5]", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "\xE2\x80[\x8C-\x8F\xA8-\xAF]", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "\xE2\x81[\xA0-\xAF]", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "﻿", var_243_30)
			arg_249_0 = var_243_31(arg_249_0, "\xEF\xBF[\xB0-\xBF]", var_243_30)
		end

		return "\"" .. arg_249_0 .. "\""
	end

	var_243_26.quotestring = var_243_32

	local function var_243_33(arg_250_0, arg_250_1, arg_250_2)
		local var_250_0, var_250_1 = var_243_21(arg_250_0, arg_250_1, 1, true)

		if var_250_0 then
			return var_243_18(arg_250_0, 1, var_250_0 - 1) .. arg_250_2 .. var_243_18(arg_250_0, var_250_1 + 1, -1)
		else
			return arg_250_0
		end
	end

	local var_243_34
	local var_243_35

	local function var_243_36()
		var_243_34 = var_243_24(var_243_5(0.5), "([^05+])")
		var_243_35 = "[^0-9%-%+eE" .. var_243_17(var_243_34, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
	end

	var_243_36()

	local function var_243_37(arg_252_0)
		return var_243_33(var_243_31(var_243_5(arg_252_0), var_243_35, ""), var_243_34, ".")
	end

	local function var_243_38(arg_253_0)
		local var_253_0 = var_243_6(var_243_33(arg_253_0, ".", var_243_34))

		if not var_253_0 then
			var_243_36()

			var_253_0 = var_243_6(var_243_33(arg_253_0, ".", var_243_34))
		end

		return var_253_0
	end

	local function var_243_39(arg_254_0, arg_254_1, arg_254_2)
		arg_254_1[arg_254_2 + 1] = "\n"
		arg_254_1[arg_254_2 + 2] = var_243_16("  ", arg_254_0)
		arg_254_2 = arg_254_2 + 2

		return arg_254_2
	end

	function var_243_26.addnewline(arg_255_0)
		if arg_255_0.indent then
			arg_255_0.bufferlen = var_243_39(arg_255_0.level or 0, arg_255_0.buffer, arg_255_0.bufferlen or #arg_255_0.buffer)
		end
	end

	local var_243_40

	local function var_243_41(arg_256_0, arg_256_1, arg_256_2, arg_256_3, arg_256_4, arg_256_5, arg_256_6, arg_256_7, arg_256_8, arg_256_9)
		local var_256_0 = var_243_4(arg_256_0)

		if var_256_0 ~= "string" and var_256_0 ~= "number" then
			return nil, "type '" .. var_256_0 .. "' is not supported as a key by JSON."
		end

		if arg_256_2 then
			arg_256_6 = arg_256_6 + 1
			arg_256_5[arg_256_6] = ","
		end

		if arg_256_3 then
			arg_256_6 = var_243_39(arg_256_4, arg_256_5, arg_256_6)
		end

		arg_256_5[arg_256_6 + 1] = var_243_32(arg_256_0)
		arg_256_5[arg_256_6 + 2] = ":"

		return var_243_40(arg_256_1, arg_256_3, arg_256_4, arg_256_5, arg_256_6 + 2, arg_256_7, arg_256_8, arg_256_9)
	end

	local function var_243_42(arg_257_0, arg_257_1, arg_257_2)
		local var_257_0 = arg_257_2.bufferlen

		if var_243_4(arg_257_0) == "string" then
			var_257_0 = var_257_0 + 1
			arg_257_1[var_257_0] = arg_257_0
		end

		return var_257_0
	end

	local function var_243_43(arg_258_0, arg_258_1, arg_258_2, arg_258_3, arg_258_4, arg_258_5)
		arg_258_5 = arg_258_5 or arg_258_0

		local var_258_0 = arg_258_2.exception

		if not var_258_0 then
			return nil, arg_258_5
		else
			arg_258_2.bufferlen = arg_258_4

			local var_258_1, var_258_2 = var_258_0(arg_258_0, arg_258_1, arg_258_2, arg_258_5)

			if not var_258_1 then
				return nil, var_258_2 or arg_258_5
			end

			return var_243_42(var_258_1, arg_258_3, arg_258_2)
		end
	end

	function var_243_26.encodeexception(arg_259_0, arg_259_1, arg_259_2, arg_259_3)
		return var_243_32("<" .. arg_259_3 .. ">")
	end

	function var_243_40(arg_260_0, arg_260_1, arg_260_2, arg_260_3, arg_260_4, arg_260_5, arg_260_6, arg_260_7)
		local var_260_0 = var_243_4(arg_260_0)
		local var_260_1 = var_243_7(arg_260_0)

		var_260_1 = var_243_4(var_260_1) == "table" and var_260_1

		local var_260_2 = var_260_1 and var_260_1.__tojson

		if var_260_2 then
			if arg_260_5[arg_260_0] then
				return var_243_43("reference cycle", arg_260_0, arg_260_7, arg_260_3, arg_260_4)
			end

			arg_260_5[arg_260_0] = true
			arg_260_7.bufferlen = arg_260_4

			local var_260_3, var_260_4 = var_260_2(arg_260_0, arg_260_7)

			if not var_260_3 then
				return var_243_43("custom encoder failed", arg_260_0, arg_260_7, arg_260_3, arg_260_4, var_260_4)
			end

			arg_260_5[arg_260_0] = nil
			arg_260_4 = var_243_42(var_260_3, arg_260_3, arg_260_7)
		elseif arg_260_0 == nil then
			arg_260_4 = arg_260_4 + 1
			arg_260_3[arg_260_4] = "null"
		elseif var_260_0 == "number" then
			local var_260_5

			arg_260_3[arg_260_4], arg_260_4 = (arg_260_0 ~= arg_260_0 or arg_260_0 >= var_243_15 or -arg_260_0 >= var_243_15) and "null" or var_243_37(arg_260_0), arg_260_4 + 1
		elseif var_260_0 == "boolean" then
			arg_260_4 = arg_260_4 + 1
			arg_260_3[arg_260_4] = arg_260_0 and "true" or "false"
		elseif var_260_0 == "string" then
			arg_260_4 = arg_260_4 + 1
			arg_260_3[arg_260_4] = var_243_32(arg_260_0)
		elseif var_260_0 == "table" then
			if arg_260_5[arg_260_0] then
				return var_243_43("reference cycle", arg_260_0, arg_260_7, arg_260_3, arg_260_4)
			end

			arg_260_5[arg_260_0] = true
			arg_260_2 = arg_260_2 + 1

			local var_260_6, var_260_7 = var_243_28(arg_260_0)

			if var_260_7 == 0 and var_260_1 and var_260_1.__jsontype == "object" then
				var_260_6 = false
			end

			local var_260_8

			if var_260_6 then
				arg_260_4 = arg_260_4 + 1
				arg_260_3[arg_260_4] = "["

				for iter_260_0 = 1, var_260_7 do
					local var_260_9

					arg_260_4, var_260_9 = var_243_40(arg_260_0[iter_260_0], arg_260_1, arg_260_2, arg_260_3, arg_260_4, arg_260_5, arg_260_6, arg_260_7)

					if not arg_260_4 then
						return nil, var_260_9
					end

					if iter_260_0 < var_260_7 then
						arg_260_4 = arg_260_4 + 1
						arg_260_3[arg_260_4] = ","
					end
				end

				arg_260_4 = arg_260_4 + 1
				arg_260_3[arg_260_4] = "]"
			else
				local var_260_10 = false

				arg_260_4 = arg_260_4 + 1
				arg_260_3[arg_260_4] = "{"

				local var_260_11 = var_260_1 and var_260_1.__jsonorder or arg_260_6

				if var_260_11 then
					local var_260_12 = {}
					local var_260_13 = #var_260_11

					for iter_260_1 = 1, var_260_13 do
						local var_260_14 = var_260_11[iter_260_1]
						local var_260_15 = arg_260_0[var_260_14]

						if var_260_15 then
							var_260_12[var_260_14] = true

							local var_260_16

							arg_260_4, var_260_16 = var_243_41(var_260_14, var_260_15, var_260_10, arg_260_1, arg_260_2, arg_260_3, arg_260_4, arg_260_5, arg_260_6, arg_260_7)
							var_260_10 = true
						end
					end

					for iter_260_2, iter_260_3 in var_243_3(arg_260_0) do
						if not var_260_12[iter_260_2] then
							local var_260_17

							arg_260_4, var_260_17 = var_243_41(iter_260_2, iter_260_3, var_260_10, arg_260_1, arg_260_2, arg_260_3, arg_260_4, arg_260_5, arg_260_6, arg_260_7)

							if not arg_260_4 then
								return nil, var_260_17
							end

							var_260_10 = true
						end
					end
				else
					for iter_260_4, iter_260_5 in var_243_3(arg_260_0) do
						local var_260_18

						arg_260_4, var_260_18 = var_243_41(iter_260_4, iter_260_5, var_260_10, arg_260_1, arg_260_2, arg_260_3, arg_260_4, arg_260_5, arg_260_6, arg_260_7)

						if not arg_260_4 then
							return nil, var_260_18
						end

						var_260_10 = true
					end
				end

				if arg_260_1 then
					arg_260_4 = var_243_39(arg_260_2 - 1, arg_260_3, arg_260_4)
				end

				arg_260_4 = arg_260_4 + 1
				arg_260_3[arg_260_4] = "}"
			end

			arg_260_5[arg_260_0] = nil
		else
			return var_243_43("unsupported type", arg_260_0, arg_260_7, arg_260_3, arg_260_4, "type '" .. var_260_0 .. "' is not supported by JSON.")
		end

		return arg_260_4
	end

	function var_243_26.encode(arg_261_0, arg_261_1)
		arg_261_1 = arg_261_1 or {}

		local var_261_0 = arg_261_1.buffer
		local var_261_1 = var_261_0 or {}

		arg_261_1.buffer = var_261_1

		var_243_36()

		local var_261_2, var_261_3 = var_243_40(arg_261_0, arg_261_1.indent, arg_261_1.level or 0, var_261_1, arg_261_1.bufferlen or 0, arg_261_1.tables or {}, arg_261_1.keyorder, arg_261_1)

		if not var_261_2 then
			var_243_10(var_261_3, 2)
		elseif var_261_0 == var_261_1 then
			arg_261_1.bufferlen = var_261_2

			return true
		else
			arg_261_1.bufferlen = nil
			arg_261_1.buffer = nil

			return var_243_25(var_261_1)
		end
	end

	local function var_243_44(arg_262_0, arg_262_1)
		local var_262_0 = 1
		local var_262_1 = 1
		local var_262_2 = 0

		while true do
			var_262_1 = var_243_21(arg_262_0, "\n", var_262_1, true)

			if var_262_1 and var_262_1 < arg_262_1 then
				var_262_0 = var_262_0 + 1
				var_262_2 = var_262_1
				var_262_1 = var_262_1 + 1
			else
				break
			end
		end

		return "line " .. var_262_0 .. ", column " .. arg_262_1 - var_262_2
	end

	local function var_243_45(arg_263_0, arg_263_1, arg_263_2)
		return nil, var_243_22(arg_263_0) + 1, "unterminated " .. arg_263_1 .. " at " .. var_243_44(arg_263_0, arg_263_2)
	end

	local function var_243_46(arg_264_0, arg_264_1)
		while true do
			arg_264_1 = var_243_21(arg_264_0, "%S", arg_264_1)

			if not arg_264_1 then
				return nil
			end

			local var_264_0 = var_243_18(arg_264_0, arg_264_1, arg_264_1 + 1)

			if var_264_0 == "\xEF\xBB" and var_243_18(arg_264_0, arg_264_1 + 2, arg_264_1 + 2) == "\xBF" then
				arg_264_1 = arg_264_1 + 3
			elseif var_264_0 == "//" then
				arg_264_1 = var_243_21(arg_264_0, "[\n\r]", arg_264_1 + 2)

				if not arg_264_1 then
					return nil
				end
			elseif var_264_0 == "/*" then
				arg_264_1 = var_243_21(arg_264_0, "*/", arg_264_1 + 2)

				if not arg_264_1 then
					return nil
				end

				arg_264_1 = arg_264_1 + 2
			else
				return arg_264_1
			end
		end
	end

	local var_243_47 = {
		b = "\b",
		f = "\f",
		t = "\t",
		r = "\r",
		n = "\n",
		["\\"] = "\\",
		["/"] = "/",
		["\""] = "\""
	}

	local function var_243_48(arg_265_0)
		if arg_265_0 < 0 then
			return nil
		elseif arg_265_0 <= 127 then
			return var_243_20(arg_265_0)
		elseif arg_265_0 <= 2047 then
			return var_243_20(192 + var_243_14(arg_265_0 / 64), 128 + var_243_14(arg_265_0) % 64)
		elseif arg_265_0 <= 65535 then
			return var_243_20(224 + var_243_14(arg_265_0 / 4096), 128 + var_243_14(arg_265_0 / 64) % 64, 128 + var_243_14(arg_265_0) % 64)
		elseif arg_265_0 <= 1114111 then
			return var_243_20(240 + var_243_14(arg_265_0 / 262144), 128 + var_243_14(arg_265_0 / 4096) % 64, 128 + var_243_14(arg_265_0 / 64) % 64, 128 + var_243_14(arg_265_0) % 64)
		else
			return nil
		end
	end

	local function var_243_49(arg_266_0, arg_266_1)
		local var_266_0 = arg_266_1 + 1
		local var_266_1 = {}
		local var_266_2 = 0

		while true do
			local var_266_3 = var_243_21(arg_266_0, "[\"\\]", var_266_0)

			if not var_266_3 then
				return var_243_45(arg_266_0, "string", arg_266_1)
			end

			if var_266_0 < var_266_3 then
				var_266_2 = var_266_2 + 1
				var_266_1[var_266_2] = var_243_18(arg_266_0, var_266_0, var_266_3 - 1)
			end

			if var_243_18(arg_266_0, var_266_3, var_266_3) == "\"" then
				var_266_0 = var_266_3 + 1

				break
			else
				local var_266_4 = var_243_18(arg_266_0, var_266_3 + 1, var_266_3 + 1)
				local var_266_5

				if var_266_4 == "u" then
					var_266_5 = var_243_6(var_243_18(arg_266_0, var_266_3 + 2, var_266_3 + 5), 16)

					if var_266_5 then
						local var_266_6

						if var_266_5 >= 55296 and var_266_5 <= 56319 and var_243_18(arg_266_0, var_266_3 + 6, var_266_3 + 7) == "\\u" then
							var_266_6 = var_243_6(var_243_18(arg_266_0, var_266_3 + 8, var_266_3 + 11), 16)

							if var_266_6 and var_266_6 >= 56320 and var_266_6 <= 57343 then
								var_266_5 = (var_266_5 - 55296) * 1024 + (var_266_6 - 56320) + 65536
							else
								var_266_6 = nil
							end
						end

						var_266_5 = var_266_5 and var_243_48(var_266_5)

						if var_266_5 then
							if var_266_6 then
								var_266_0 = var_266_3 + 12
							else
								var_266_0 = var_266_3 + 6
							end
						end
					end
				end

				if not var_266_5 then
					var_266_5 = var_243_47[var_266_4] or var_266_4
					var_266_0 = var_266_3 + 2
				end

				var_266_2 = var_266_2 + 1
				var_266_1[var_266_2] = var_266_5
			end
		end

		if var_266_2 == 1 then
			return var_266_1[1], var_266_0
		elseif var_266_2 > 1 then
			return var_243_25(var_266_1), var_266_0
		else
			return "", var_266_0
		end
	end

	local var_243_50

	local function var_243_51(arg_267_0, arg_267_1, arg_267_2, arg_267_3, arg_267_4, arg_267_5, arg_267_6)
		local var_267_0 = var_243_22(arg_267_2)
		local var_267_1 = {}
		local var_267_2 = 0
		local var_267_3 = arg_267_3 + 1

		if arg_267_0 == "object" then
			var_243_8(var_267_1, arg_267_5)
		else
			var_243_8(var_267_1, arg_267_6)
		end

		while true do
			var_267_3 = var_243_46(arg_267_2, var_267_3)

			if not var_267_3 then
				return var_243_45(arg_267_2, arg_267_0, arg_267_3)
			end

			if var_243_18(arg_267_2, var_267_3, var_267_3) == arg_267_1 then
				return var_267_1, var_267_3 + 1
			end

			local var_267_4
			local var_267_5
			local var_267_6, var_267_7

			var_267_6, var_267_3, var_267_7 = var_243_50(arg_267_2, var_267_3, arg_267_4, arg_267_5, arg_267_6)

			if var_267_7 then
				return nil, var_267_3, var_267_7
			end

			var_267_3 = var_243_46(arg_267_2, var_267_3)

			if not var_267_3 then
				return var_243_45(arg_267_2, arg_267_0, arg_267_3)
			end

			local var_267_8 = var_243_18(arg_267_2, var_267_3, var_267_3)

			if var_267_8 == ":" then
				if var_267_6 == nil then
					return nil, var_267_3, "cannot use nil as table index (at " .. var_243_44(arg_267_2, var_267_3) .. ")"
				end

				var_267_3 = var_243_46(arg_267_2, var_267_3 + 1)

				if not var_267_3 then
					return var_243_45(arg_267_2, arg_267_0, arg_267_3)
				end

				local var_267_9
				local var_267_10, var_267_11

				var_267_10, var_267_3, var_267_11 = var_243_50(arg_267_2, var_267_3, arg_267_4, arg_267_5, arg_267_6)

				if var_267_11 then
					return nil, var_267_3, var_267_11
				end

				var_267_1[var_267_6] = var_267_10
				var_267_3 = var_243_46(arg_267_2, var_267_3)

				if not var_267_3 then
					return var_243_45(arg_267_2, arg_267_0, arg_267_3)
				end

				var_267_8 = var_243_18(arg_267_2, var_267_3, var_267_3)
			else
				var_267_2 = var_267_2 + 1
				var_267_1[var_267_2] = var_267_6
			end

			if var_267_8 == "," then
				var_267_3 = var_267_3 + 1
			end
		end
	end

	function var_243_50(arg_268_0, arg_268_1, arg_268_2, arg_268_3, arg_268_4)
		arg_268_1 = arg_268_1 or 1
		arg_268_1 = var_243_46(arg_268_0, arg_268_1)

		if not arg_268_1 then
			return nil, var_243_22(arg_268_0) + 1, "no valid JSON value (reached the end)"
		end

		local var_268_0 = var_243_18(arg_268_0, arg_268_1, arg_268_1)

		if var_268_0 == "{" then
			return var_243_51("object", "}", arg_268_0, arg_268_1, arg_268_2, arg_268_3, arg_268_4)
		elseif var_268_0 == "[" then
			return var_243_51("array", "]", arg_268_0, arg_268_1, arg_268_2, arg_268_3, arg_268_4)
		elseif var_268_0 == "\"" then
			return var_243_49(arg_268_0, arg_268_1)
		else
			local var_268_1, var_268_2 = var_243_21(arg_268_0, "^%-?[%d%.]+[eE]?[%+%-]?%d*", arg_268_1)

			if var_268_1 then
				local var_268_3 = var_243_38(var_243_18(arg_268_0, var_268_1, var_268_2))

				if var_268_3 then
					return var_268_3, var_268_2 + 1
				end
			end

			local var_268_4, var_268_5 = var_243_21(arg_268_0, "^%a%w*", arg_268_1)

			if var_268_4 then
				local var_268_6 = var_243_18(arg_268_0, var_268_4, var_268_5)

				if var_268_6 == "true" then
					return true, var_268_5 + 1
				elseif var_268_6 == "false" then
					return false, var_268_5 + 1
				elseif var_268_6 == "null" then
					return arg_268_2, var_268_5 + 1
				end
			end

			return nil, arg_268_1, "no valid JSON value at " .. var_243_44(arg_268_0, arg_268_1)
		end
	end

	local function var_243_52(...)
		if var_243_13("#", ...) > 0 then
			return ...
		else
			return {
				__jsontype = "object"
			}, {
				__jsontype = "array"
			}
		end
	end

	function var_243_26.decode(arg_270_0, arg_270_1, arg_270_2, ...)
		local var_270_0, var_270_1 = var_243_52(...)

		return var_243_50(arg_270_0, arg_270_1, arg_270_2, var_270_0, var_270_1)
	end

	function var_243_26.use_lpeg()
		local var_271_0 = var_243_11("lpeg")

		if var_271_0.version() == "0.11" then
			var_243_10("due to a bug in LPeg 0.11, it cannot be used for JSON matching")
		end

		local var_271_1 = var_271_0.match
		local var_271_2 = var_271_0.P
		local var_271_3 = var_271_0.S
		local var_271_4 = var_271_0.R

		local function var_271_5(arg_272_0, arg_272_1, arg_272_2, arg_272_3)
			if not arg_272_3.msg then
				arg_272_3.msg = arg_272_2 .. " at " .. var_243_44(arg_272_0, arg_272_1)
				arg_272_3.pos = arg_272_1
			end

			return false
		end

		local function var_271_6(arg_273_0)
			return var_271_0.Cmt(var_271_0.Cc(arg_273_0) * var_271_0.Carg(2), var_271_5)
		end

		local var_271_7 = var_271_2("//") * (1 - var_271_3("\n\r"))^0
		local var_271_8 = var_271_2("/*") * (1 - var_271_2("*/"))^0 * var_271_2("*/")
		local var_271_9 = (var_271_3(" \n\r\t") + var_271_2("﻿") + var_271_7 + var_271_8)^0
		local var_271_10 = 1 - var_271_3("\"\\\n\r")
		local var_271_11 = var_271_2("\\") * var_271_0.C(var_271_3("\"\\/bfnrt") + var_271_6("unsupported escape sequence")) / var_243_47
		local var_271_12 = var_271_4("09", "af", "AF")

		local function var_271_13(arg_274_0, arg_274_1, arg_274_2, arg_274_3)
			arg_274_2, arg_274_3 = var_243_6(arg_274_2, 16), var_243_6(arg_274_3, 16)

			if arg_274_2 >= 55296 and arg_274_2 <= 56319 and arg_274_3 >= 56320 and arg_274_3 <= 57343 then
				return true, var_243_48((arg_274_2 - 55296) * 1024 + (arg_274_3 - 56320) + 65536)
			else
				return false
			end
		end

		local function var_271_14(arg_275_0)
			return var_243_48(var_243_6(arg_275_0, 16))
		end

		local var_271_15 = var_271_2("\\u") * var_271_0.C(var_271_12 * var_271_12 * var_271_12 * var_271_12)
		local var_271_16 = var_271_0.Cmt(var_271_15 * var_271_15, var_271_13) + var_271_15 / var_271_14 + var_271_11 + var_271_10
		local var_271_17 = var_271_2("\"") * var_271_0.Cs(var_271_16^0) * (var_271_2("\"") + var_271_6("unterminated string"))
		local var_271_18 = var_271_2("-")^-1 * (var_271_2("0") + var_271_4("19") * var_271_4("09")^0)
		local var_271_19 = var_271_2(".") * var_271_4("09")^0
		local var_271_20 = var_271_3("eE") * var_271_3("+-")^-1 * var_271_4("09")^1
		local var_271_21 = var_271_18 * var_271_19^-1 * var_271_20^-1 / var_243_38
		local var_271_22 = var_271_2("true") * var_271_0.Cc(true) + var_271_2("false") * var_271_0.Cc(false) + var_271_2("null") * var_271_0.Carg(1)
		local var_271_23 = var_271_21 + var_271_17 + var_271_22
		local var_271_24
		local var_271_25

		local function var_271_26(arg_276_0, arg_276_1, arg_276_2, arg_276_3)
			local var_276_0
			local var_276_1
			local var_276_2
			local var_276_3 = {}
			local var_276_4 = 0

			repeat
				local var_276_5, var_276_6, var_276_7 = var_271_1(var_271_24, arg_276_0, arg_276_1, arg_276_2, arg_276_3)

				if not var_276_7 then
					break
				end

				arg_276_1 = var_276_7
				var_276_4 = var_276_4 + 1
				var_276_3[var_276_4] = var_276_5
			until var_276_6 == "last"

			return arg_276_1, var_243_8(var_276_3, arg_276_3.arraymeta)
		end

		local function var_271_27(arg_277_0, arg_277_1, arg_277_2, arg_277_3)
			local var_277_0
			local var_277_1
			local var_277_2
			local var_277_3
			local var_277_4 = {}

			repeat
				local var_277_5, var_277_6, var_277_7, var_277_8 = var_271_1(var_271_25, arg_277_0, arg_277_1, arg_277_2, arg_277_3)

				if not var_277_8 then
					break
				end

				arg_277_1 = var_277_8
				var_277_4[var_277_5] = var_277_6
			until var_277_7 == "last"

			return arg_277_1, var_243_8(var_277_4, arg_277_3.objectmeta)
		end

		local var_271_28 = var_271_9 * (var_271_2("[") * var_271_0.Cmt(var_271_0.Carg(1) * var_271_0.Carg(2), var_271_26) * var_271_9 * (var_271_2("]") + var_271_6("']' expected")) + var_271_2("{") * var_271_0.Cmt(var_271_0.Carg(1) * var_271_0.Carg(2), var_271_27) * var_271_9 * (var_271_2("}") + var_271_6("'}' expected")) + var_271_23)
		local var_271_29 = var_271_28 + var_271_9 * var_271_6("value expected")

		var_271_24 = var_271_28 * var_271_9 * (var_271_2(",") * var_271_0.Cc("cont") + var_271_0.Cc("last")) * var_271_0.Cp()
		var_271_25 = var_271_0.Cg(var_271_9 * var_271_17 * var_271_9 * (var_271_2(":") + var_271_6("colon expected")) * var_271_29) * var_271_9 * (var_271_2(",") * var_271_0.Cc("cont") + var_271_0.Cc("last")) * var_271_0.Cp()

		local var_271_30 = var_271_29 * var_271_0.Cp()

		function var_243_26.decode(arg_278_0, arg_278_1, arg_278_2, ...)
			local var_278_0 = {}

			var_278_0.objectmeta, var_278_0.arraymeta = var_243_52(...)

			local var_278_1, var_278_2 = var_271_1(var_271_30, arg_278_0, arg_278_1, arg_278_2, var_278_0)

			if var_278_0.msg then
				return nil, var_278_0.pos, var_278_0.msg
			else
				return var_278_1, var_278_2
			end
		end

		function var_243_26.use_lpeg()
			return var_243_26
		end

		var_243_26.using_lpeg = true

		return var_243_26
	end

	if var_243_0 then
		var_243_12(var_243_26.use_lpeg)
	end

	var_243_26.parse = var_243_26.decode
	var_243_26.stringify = var_243_26.encode

	return var_243_26
end)()
local var_0_48 = (function()
	local var_280_0 = var_0_1.band
	local var_280_1 = var_0_1.bor
	local var_280_2 = var_0_1.bnot
	local var_280_3 = var_0_1.bxor
	local var_280_4 = var_0_1.lshift
	local var_280_5 = var_0_1.rshift
	local var_280_6 = {}

	var_280_6.__index = var_280_6

	local var_280_7 = 14
	local var_280_8 = 5
	local var_280_9 = var_280_4(1, var_280_8)
	local var_280_10 = 1 / var_280_9

	function var_280_6.new(arg_281_0)
		if arg_281_0 == nil then
			arg_281_0 = {
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
			}
		end

		local var_281_0 = setmetatable({}, var_280_6)

		var_281_0.data = var_0_0.new("uint8_t[?]", #arg_281_0, arg_281_0)
		var_281_0.size = #arg_281_0
		var_281_0.pos = 0
		var_281_0.bit_pos = 0

		return var_281_0
	end

	function var_280_6.read_bits(arg_282_0, arg_282_1)
		local var_282_0 = 0
		local var_282_1 = arg_282_1

		while var_282_1 > 0 do
			while arg_282_0.bit_pos == 8 do
				arg_282_0.bit_pos = arg_282_0.bit_pos - 8
				arg_282_0.pos = arg_282_0.pos + 1
			end

			local var_282_2 = arg_282_0.data[arg_282_0.pos]
			local var_282_3 = math.min(var_282_1, 8 - arg_282_0.bit_pos)
			local var_282_4 = var_280_4(1, var_282_3) - 1

			var_282_0 = var_280_1(var_282_0, var_280_4(var_280_0(var_280_5(var_282_2, arg_282_0.bit_pos), var_282_4), arg_282_1 - var_282_1))
			var_282_1 = var_282_1 - var_282_3
			arg_282_0.bit_pos = arg_282_0.bit_pos + var_282_3
		end

		return var_282_0
	end

	function var_280_6.write_bits(arg_283_0, arg_283_1, arg_283_2)
		local var_283_0 = arg_283_2

		while var_283_0 > 0 do
			while arg_283_0.bit_pos == 8 do
				arg_283_0.bit_pos = arg_283_0.bit_pos - 8
				arg_283_0.pos = arg_283_0.pos + 1
			end

			local var_283_1 = arg_283_0.data[arg_283_0.pos]
			local var_283_2 = math.min(var_283_0, 8 - arg_283_0.bit_pos)
			local var_283_3 = var_280_4(1, var_283_2) - 1
			local var_283_4 = var_280_1(var_280_0(var_283_1, var_280_2(var_280_4(var_283_3, arg_283_0.bit_pos))), var_280_4(var_280_0(arg_283_1, var_283_3), arg_283_0.bit_pos))

			arg_283_1 = var_280_5(arg_283_1, var_283_2)
			var_283_0 = var_283_0 - var_283_2
			arg_283_0.bit_pos = arg_283_0.bit_pos + var_283_2
			arg_283_0.data[arg_283_0.pos] = var_283_4
		end
	end

	function var_280_6.read_coord(arg_284_0)
		local var_284_0 = arg_284_0:read_bits(1)
		local var_284_1 = arg_284_0:read_bits(1)

		if var_284_0 == 0 and var_284_1 == 0 then
			return 0
		end

		local var_284_2 = arg_284_0:read_bits(1)

		if var_284_0 == 1 then
			var_284_0 = arg_284_0:read_bits(var_280_7) + 1
		end

		if var_284_1 == 1 then
			var_284_1 = arg_284_0:read_bits(var_280_8)
		end

		local var_284_3 = var_284_0 + var_284_1 * 0.03125

		if var_284_2 == 1 then
			var_284_3 = -var_284_3
		end

		return var_284_3
	end

	function var_280_6.write_coord(arg_285_0, arg_285_1)
		local var_285_0 = arg_285_1 <= -var_280_10
		local var_285_1 = math.abs(arg_285_1)
		local var_285_2 = math.abs(arg_285_1 * var_280_9) % var_280_9

		arg_285_0:write_bits(var_285_1 ~= 0 and 1 or 0, 1)
		arg_285_0:write_bits(var_285_2 ~= 0 and 1 or 0, 1)

		if var_285_1 ~= 0 or var_285_2 ~= 0 then
			arg_285_0:write_bits(var_285_0 and 1 or 0, 1)

			if var_285_1 ~= 0 then
				local var_285_3 = var_285_1 - 1

				arg_285_0:write_bits(var_285_3, var_280_7)
			end

			if var_285_2 ~= 0 then
				arg_285_0:write_bits(var_285_2, var_280_8)
			end
		end
	end

	function var_280_6.reset(arg_286_0)
		arg_286_0.pos = 0
		arg_286_0.bit_pos = 0
	end

	function var_280_6.to_bytes(arg_287_0)
		local var_287_0 = {}

		for iter_287_0 = 0, arg_287_0.size - 1 do
			table.insert(var_287_0, arg_287_0.data[iter_287_0])
		end

		return var_287_0
	end

	function var_280_6.get_raw_buffer(arg_288_0)
		return arg_288_0.data
	end

	function var_280_6.crypt(arg_289_0, arg_289_1)
		if type(arg_289_1) == "string" then
			local var_289_0 = {}

			for iter_289_0 = 1, #arg_289_1 do
				table.insert(var_289_0, string.byte(arg_289_1, iter_289_0))
			end

			arg_289_1 = var_289_0
		end

		local var_289_1 = #arg_289_1
		local var_289_2 = 0

		for iter_289_1 = 0, arg_289_0.size - 1 do
			arg_289_0.data[iter_289_1] = var_280_3(arg_289_0.data[iter_289_1], arg_289_1[var_289_2 + 1])
			var_289_2 = (var_289_2 + 1) % var_289_1
		end
	end

	return var_280_6
end)()

local function var_0_49(arg_290_0, arg_290_1)
	for iter_290_0, iter_290_1 in pairs(arg_290_0) do
		if iter_290_1 == arg_290_1 then
			return true
		end
	end

	return false
end

local var_0_50 = {
	[var_0_43.PRIMORDIAL] = function()
		local var_291_0 = (function()
			local var_292_0 = require("ffi")
			local var_292_1 = var_292_0.cast("uint32_t**", var_292_0.cast("char**", var_292_0.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) + 1)[0] + 48)[0] or error("steam_http error")
			local var_292_2 = (var_292_0.cast("void***", var_292_1) or error("steam_http_ptr error"))[0] or error("steam_http_ptr was null")

			local function var_292_3(arg_293_0, arg_293_1)
				return function(...)
					return arg_293_0(arg_293_1, ...)
				end
			end

			local var_292_4 = var_292_3(var_292_0.cast(var_292_0.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), var_292_2[0]), var_292_1)
			local var_292_5 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), var_292_2[5]), var_292_1)
			local var_292_6 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), var_292_2[9]), var_292_1)
			local var_292_7 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), var_292_2[10]), var_292_1)
			local var_292_8 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), var_292_2[11]), var_292_1)
			local var_292_9 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), var_292_2[12]), var_292_1)
			local var_292_10 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), var_292_2[3]), var_292_1)
			local var_292_11 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), var_292_2[4]), var_292_1)
			local var_292_12 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), var_292_2[21]), var_292_1)
			local var_292_13 = var_292_3(var_292_0.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", var_292_2[16]), var_292_1)
			local var_292_14 = var_292_3(var_292_0.cast(var_292_0.typeof("bool(__thiscall*)(void*, uint32_t)"), var_292_2[14]), var_292_1)
			local var_292_15 = {}

			callbacks.add(e_callbacks.PAINT, function()
				for iter_295_0, iter_295_1 in ipairs(var_292_15) do
					if global_vars.real_time() - iter_295_1.ls > iter_295_1.task_interval then
						iter_295_1:_process_tasks()

						iter_295_1.ls = global_vars.real_time()
					end
				end
			end)

			local var_292_16 = {}
			local var_292_17 = {
				__index = var_292_16
			}

			function var_292_16.new(arg_296_0, arg_296_1, arg_296_2)
				return setmetatable({
					ticks = 0,
					handle = arg_296_0,
					url = arg_296_1,
					callback = arg_296_2
				}, var_292_17)
			end

			local var_292_18 = {}
			local var_292_19 = {
				__index = var_292_18
			}

			function var_292_18.new(arg_297_0, arg_297_1, arg_297_2)
				return setmetatable({
					status = arg_297_0,
					body = arg_297_1,
					headers = arg_297_2
				}, var_292_19)
			end

			function var_292_18.success(arg_298_0)
				return arg_298_0.status == 200
			end

			local var_292_20 = {
				state = {
					timed_out = 408,
					ok = 200,
					no_response = 204,
					unknown = 0
				}
			}
			local var_292_21 = {
				__index = var_292_20
			}

			function var_292_20.new(arg_299_0)
				arg_299_0 = arg_299_0 or {}

				local var_299_0 = setmetatable({
					requests = {},
					task_interval = arg_299_0.task_interval or 0.3,
					enable_debug = arg_299_0.debug or false,
					timeout = arg_299_0.timeout or 10,
					ls = global_vars.real_time()
				}, var_292_21)

				table.insert(var_292_15, var_299_0)

				return var_299_0
			end

			local var_292_22 = {
				get = 1,
				put = 4,
				head = 2,
				patch = 7,
				options = 6,
				post = 3,
				delete = 5
			}

			function var_292_20.request(arg_300_0, arg_300_1, arg_300_2, arg_300_3, arg_300_4)
				if type(arg_300_3) == "function" and arg_300_4 == nil then
					arg_300_4 = arg_300_3
					arg_300_3 = {}
				end

				arg_300_3 = arg_300_3 or {}

				local var_300_0 = var_292_22[tostring(arg_300_1):lower()]
				local var_300_1 = var_292_4(var_300_0, arg_300_2)
				local var_300_2 = "application/text"

				if type(arg_300_3.headers) == "table" then
					for iter_300_0, iter_300_1 in pairs(arg_300_3.headers) do
						iter_300_0 = tostring(iter_300_0)
						iter_300_1 = tostring(iter_300_1)

						if iter_300_0:lower() == "content-type" then
							var_300_2 = iter_300_1
						end

						var_292_10(var_300_1, iter_300_0, iter_300_1)
					end
				end

				if type(arg_300_3.body) == "string" then
					local var_300_3 = arg_300_3.body:len()

					var_292_13(var_300_1, var_300_2, var_292_0.cast("unsigned char*", arg_300_3.body), var_300_3)
				end

				if type(arg_300_3.params) == "table" then
					for iter_300_2, iter_300_3 in pairs(arg_300_3.params) do
						var_292_11(var_300_1, iter_300_2, iter_300_3)
					end
				end

				if type(arg_300_3.user_agent_info) == "string" then
					var_292_12(var_300_1, arg_300_3.user_agent_info)
				end

				if not var_292_5(var_300_1, 0) then
					return
				end

				local var_300_4 = var_292_16.new(var_300_1, arg_300_2, arg_300_4)

				arg_300_0:_debug("[HTTP] New %s request to: %s", arg_300_1:upper(), arg_300_2)
				table.insert(arg_300_0.requests, var_300_4)
			end

			function var_292_20.get(arg_301_0, arg_301_1, arg_301_2)
				local var_301_0 = var_292_4(1, arg_301_1)

				if not var_292_5(var_301_0, 0) then
					return
				end

				local var_301_1 = var_292_16.new(var_301_0, arg_301_1, arg_301_2)

				arg_301_0:_debug("[HTTP] New GET request to: %s", arg_301_1)
				table.insert(arg_301_0.requests, var_301_1)
			end

			function var_292_20.post(arg_302_0, arg_302_1, arg_302_2, arg_302_3)
				local var_302_0 = var_292_4(3, arg_302_1)

				for iter_302_0, iter_302_1 in pairs(arg_302_2) do
					var_292_11(var_302_0, iter_302_0, iter_302_1)
				end

				if not var_292_5(var_302_0, 0) then
					return
				end

				local var_302_1 = var_292_16.new(var_302_0, arg_302_1, arg_302_3)

				arg_302_0:_debug("[HTTP] New POST request to: %s", arg_302_1)
				table.insert(arg_302_0.requests, var_302_1)
			end

			function var_292_20._process_tasks(arg_303_0)
				for iter_303_0, iter_303_1 in ipairs(arg_303_0.requests) do
					local var_303_0 = var_292_0.new("uint32_t[1]")

					arg_303_0:_debug("[HTTP] Processing request #%s", iter_303_0)

					if var_292_8(iter_303_1.handle, var_303_0) then
						local var_303_1 = var_303_0[0]

						if var_303_1 > 0 then
							local var_303_2 = var_292_0.new("char[?]", var_303_1)

							if var_292_9(iter_303_1.handle, var_303_2, var_303_1) then
								arg_303_0:_debug("[HTTP] Request #%s finished. Invoking callback.", iter_303_0)
								iter_303_1.callback(var_292_18.new(var_292_20.state.ok, var_292_0.string(var_303_2, var_303_1), setmetatable({}, {
									__index = function(arg_304_0, arg_304_1)
										return var_292_20._get_header(iter_303_1, arg_304_1)
									end
								})))
								table.remove(arg_303_0.requests, iter_303_0)
								var_292_14(iter_303_1.handle)
							end
						else
							iter_303_1.callback(var_292_18.new(var_292_20.state.no_response, nil, {}))
							table.remove(arg_303_0.requests, iter_303_0)
							var_292_14(iter_303_1.handle)
						end
					end

					local var_303_3 = iter_303_1.ticks + 1

					if var_303_3 >= arg_303_0.timeout then
						iter_303_1.callback(var_292_18.new(var_292_20.state.timed_out, nil, {}))
						table.remove(arg_303_0.requests, iter_303_0)
						var_292_14(iter_303_1.handle)
					else
						iter_303_1.ticks = var_303_3
					end
				end
			end

			function var_292_20._debug(arg_305_0, ...)
				if arg_305_0.enable_debug then
					client.log(string.format(...))
				end
			end

			function var_292_20._get_header(arg_306_0, arg_306_1)
				local var_306_0 = var_292_0.new("uint32_t[1]")

				if var_292_6(arg_306_0.handle, arg_306_1, var_306_0) then
					local var_306_1 = var_306_0[0]
					local var_306_2 = var_292_0.new("char[?]", var_306_1)

					if var_292_7(arg_306_0.handle, arg_306_1, var_306_2, var_306_1) then
						return var_292_0.string(var_306_2, var_306_1)
					end
				end

				return nil
			end

			function var_292_20._bind(arg_307_0, arg_307_1)
				return function(...)
					return arg_307_0[arg_307_1](arg_307_0, ...)
				end
			end

			return var_292_20
		end)().new()
		local var_291_1
		local var_291_2 = false

		callbacks.add(127, function(arg_309_0)
			if var_291_2 then
				return
			end

			if arg_309_0 == nil then
				return
			end

			local var_309_0, var_309_1 = pcall(function()
				if var_291_1 ~= nil then
					var_291_1(arg_309_0)
				end
			end)

			if var_309_1 then
				print(var_309_1)
			end
		end)

		local var_291_3

		callbacks.add(e_callbacks.SHUTDOWN, function()
			var_291_2 = true

			if var_291_3 ~= nil then
				var_291_3()
			end
		end)

		local var_291_4

		callbacks.add(e_callbacks.EVENT, function(arg_312_0)
			if var_291_4 ~= nil and arg_312_0 ~= nil and arg_312_0.userid ~= nil and entity_list.get_player_from_userid(arg_312_0.userid) ~= nil then
				var_291_4(entity_list.get_player_from_userid(arg_312_0.userid):get_index())
			end
		end, "player_connect_full")

		local var_291_5

		callbacks.add(e_callbacks.PAINT, function()
			if var_291_5 ~= nil then
				var_291_5()
			end
		end)

		local var_291_6

		callbacks.add(e_callbacks.NET_UPDATE, function()
			if var_291_6 ~= nil then
				var_291_6()
			end
		end)

		local var_291_7

		callbacks.add(e_callbacks.EVENT, function(arg_315_0)
			if var_291_7 ~= nil then
				var_291_7()
			end
		end, "round_start")

		local var_291_8

		callbacks.add(e_callbacks.EVENT, function(arg_316_0)
			if var_291_8 ~= nil and arg_316_0 ~= nil and arg_316_0.userid ~= nil and arg_316_0.attacker ~= nil then
				var_291_8(arg_316_0.attacker, arg_316_0.assister, arg_316_0.userid)
			end
		end, "player_death")

		local var_291_9 = (function()
			local var_317_0 = {}

			local function var_317_1(arg_318_0, arg_318_1)
				for iter_318_0 = 1, #var_317_0 do
					if var_317_0[iter_318_0].control == arg_318_0 then
						var_317_0[iter_318_0].fn = arg_318_1

						return
					end
				end

				local var_318_0 = 0
				local var_318_1 = 0
				local var_318_2 = pcall(function()
					var_318_0 = arg_318_0:get()
				end)

				if not var_318_2 then
					var_318_1 = 1
					var_318_2 = pcall(function()
						var_318_0 = arg_318_0:get_items()
					end)
				end

				if not var_318_2 then
					var_318_1 = 2
				end

				if var_318_1 == 1 then
					local var_318_3 = {
						items = arg_318_0:get_items(),
						table = {}
					}

					for iter_318_1 = 1, #var_318_3.items do
						table.insert(var_318_3.table, arg_318_0:get(iter_318_1))
					end

					var_318_0 = var_318_3.table
				end

				var_318_0 = "wow so this shouldn't work then right?"

				table.insert(var_317_0, {
					control = arg_318_0,
					fn = arg_318_1,
					value = var_318_0,
					type = var_318_1
				})
			end

			callbacks.add(e_callbacks.PAINT, function()
				for iter_321_0 = 1, #var_317_0 do
					if var_317_0[iter_321_0].type ~= 1 and var_317_0[iter_321_0].type ~= 2 and var_317_0[iter_321_0].control:get() ~= var_317_0[iter_321_0].value then
						var_317_0[iter_321_0].value = var_317_0[iter_321_0].control:get()

						var_317_0[iter_321_0].fn()
					elseif var_317_0[iter_321_0].type == 1 then
						local var_321_0 = {
							items = var_317_0[iter_321_0].control:get_items(),
							table = {}
						}

						for iter_321_1 = 1, #var_321_0.items do
							table.insert(var_321_0.table, var_317_0[iter_321_0].control:get(iter_321_1))
						end

						for iter_321_2 = 1, #var_321_0.table do
							if var_321_0.table[iter_321_2] ~= var_317_0[iter_321_0].value[iter_321_2] then
								var_317_0[iter_321_0].value = var_321_0.table

								var_317_0[iter_321_0].fn()
							end
						end
					end
				end
			end)

			return var_317_1
		end)()
		local var_291_10
		local var_291_11 = var_0_34.unmatched_lua and "unmatched.lua" or "cheat detector"
		local var_291_12 = menu.add_checkbox(var_291_11, "reveal unmatched.gg rank", true)
		local var_291_13 = menu.add_checkbox(var_291_11, "display estimated data", true)
		local var_291_14 = menu.add_multi_selection(var_291_11, "detection features", {
			"rank image",
			"scoreboard color",
			"spectator hud",
			"killfeed icons"
		})

		var_291_14:set(1, true)
		var_291_14:set(2, true)
		var_291_14:set(3, true)
		var_291_14:set(4, true)

		local var_291_15

		local function var_291_16()
			if var_291_15 ~= nil then
				var_291_15()
			end
		end

		var_291_9(var_291_12, var_291_16)
		var_291_9(var_291_13, var_291_16)
		var_291_9(var_291_14, var_291_16)

		local var_291_17 = {}
		local var_291_18 = 0

		for iter_291_0, iter_291_1 in pairs(var_0_38) do
			if type(iter_291_0) == "number" then
				var_291_18 = var_291_18 + 1
				var_291_17[var_291_18] = iter_291_1
			end
		end

		local var_291_19

		if var_0_34.spoof then
			var_291_19 = menu.add_multi_selection(var_291_11, "spoof cheat", var_291_17)
		end

		local var_291_20 = {}
		local var_291_21 = 0

		for iter_291_2, iter_291_3 in pairs(var_0_39) do
			if type(iter_291_2) == "number" then
				var_291_21 = var_291_21 + 1
				var_291_20[var_291_21] = iter_291_3
			end
		end

		local var_291_22

		if var_0_34.spoof then
			var_291_22 = menu.add_multi_selection(var_291_11, "spoof position of", var_291_20)
		end

		local var_291_23 = {}
		local var_291_24 = 0

		for iter_291_4, iter_291_5 in pairs(var_0_40) do
			if type(iter_291_4) == "number" then
				var_291_24 = var_291_24 + 1
				var_291_23[var_291_24] = iter_291_5
			end
		end

		local var_291_25

		if var_0_34.spoof then
			var_291_25 = menu.add_multi_selection(var_291_11, "spoof mode", var_291_23)
		end

		local var_291_26 = {}
		local var_291_27 = 0

		for iter_291_6, iter_291_7 in pairs(var_0_41) do
			if type(iter_291_6) == "number" then
				var_291_27 = var_291_27 + 1
				var_291_26[var_291_27] = iter_291_7
			end
		end

		local var_291_28 = menu.add_selection(var_291_11, "icon pack", var_291_26)

		var_291_9(var_291_28, var_291_16)

		local var_291_29 = var_0_0.cast("uint32_t(__fastcall*)(void*, void*)", memory.find_pattern("engine.dll", "56 57 8B F9 8D 4F 08 C7 07 ? ? ? ? E8 ? ? ? ? C7"))
		local var_291_30 = memory.find_pattern("engine.dll", "FF E2")

		return {
			http = var_291_0,
			set_shutdown_callback = function(arg_323_0)
				var_291_3 = arg_323_0
			end,
			set_player_connect_callback = function(arg_324_0)
				var_291_4 = arg_324_0
			end,
			set_paint_callback = function(arg_325_0)
				var_291_5 = arg_325_0
			end,
			set_net_update_callback = function(arg_326_0)
				var_291_6 = arg_326_0
			end,
			set_round_start_callback = function(arg_327_0)
				var_291_7 = arg_327_0
			end,
			set_player_death_callback = function(arg_328_0)
				var_291_8 = arg_328_0
			end,
			is_in_game = function()
				return engine.is_in_game()
			end,
			get_local_player_id = function()
				local var_330_0 = entity_list.get_local_player()

				if var_330_0 ~= nil then
					return var_330_0:get_index()
				end

				return nil
			end,
			set_voice_callback = function(arg_331_0)
				var_291_1 = arg_331_0
			end,
			is_unmatched_enabled = function()
				return var_291_12:get()
			end,
			is_rank_image_enabled = function()
				return var_291_14:get(1)
			end,
			is_scoreboard_color_enabled = function()
				return var_291_14:get(2)
			end,
			is_spectator_hud_enabled = function()
				return var_291_14:get(3)
			end,
			is_killfeed_icons_enabled = function()
				return var_291_14:get(4)
			end,
			should_display_estimated_data = function()
				return var_291_13:get()
			end,
			set_features_update_callback = function(arg_338_0)
				var_291_15 = arg_338_0
			end,
			get_spoofed_cheats = function()
				if not var_0_34.spoof then
					return {}
				end

				local var_339_0 = {}

				for iter_339_0 = 1, #var_291_17 do
					if var_291_19:get(iter_339_0) then
						var_339_0[iter_339_0] = true
					end
				end

				return var_339_0
			end,
			get_spoof_targets = function()
				if not var_0_34.spoof then
					return {}
				end

				local var_340_0 = {}

				for iter_340_0 = 1, #var_291_20 do
					if var_291_22:get(iter_340_0) then
						var_340_0[iter_340_0] = true
					end
				end

				return var_340_0
			end,
			get_spoof_modes = function()
				if not var_0_34.spoof then
					return {}
				end

				local var_341_0 = {}

				for iter_341_0 = 1, #var_291_23 do
					if var_291_25:get(iter_341_0) then
						var_341_0[iter_341_0] = true
					end
				end

				return var_341_0
			end,
			get_icon_pack = function()
				return var_291_28:get()
			end,
			create_interface = function(arg_343_0, arg_343_1)
				return memory.create_interface(arg_343_0, arg_343_1)
			end,
			get_unix_time = function()
				return client.get_unix_time()
			end,
			get_construct_voice_message = function()
				return var_291_29
			end,
			get_players = function()
				local var_346_0 = entity_list.get_players(false)

				if not var_346_0 then
					return nil
				end

				local var_346_1 = {}
				local var_346_2 = 0

				for iter_346_0, iter_346_1 in pairs(var_346_0) do
					var_346_2 = var_346_2 + 1
					var_346_1[var_346_2] = iter_346_1:get_index()
				end

				return var_346_1
			end,
			is_player_valid = function(arg_347_0)
				local var_347_0 = entity_list.get_entity(arg_347_0)

				if var_347_0 == nil then
					return false
				end

				return var_347_0:is_player() and var_347_0:is_alive()
			end,
			is_player_enemy = function(arg_348_0)
				local var_348_0 = entity_list.get_entity(arg_348_0)

				if var_348_0 == nil then
					return false
				end

				return var_348_0:is_enemy()
			end,
			is_player_dormant = function(arg_349_0)
				local var_349_0 = entity_list.get_entity(arg_349_0)

				if var_349_0 == nil then
					return false
				end

				return var_349_0:is_dormant()
			end,
			get_tick_count = function()
				return globals.tick_count()
			end,
			get_active_weapon_index = function(arg_351_0)
				local var_351_0 = entity_list.get_entity(arg_351_0)

				if var_351_0 == nil then
					return nil
				end

				local var_351_1 = var_351_0:get_active_weapon()

				if var_351_1 == nil then
					return nil
				end

				return var_351_1:get_prop("m_iItemDefinitionIndex")
			end,
			get_player_position = function(arg_352_0)
				local var_352_0 = entity_list.get_entity(arg_352_0)

				if var_352_0 == nil then
					return nil
				end

				return var_352_0:get_render_origin()
			end,
			get_jmp_edx_addr = function()
				return var_291_30
			end
		}
	end
}
local var_0_51

if var_0_50[var_0_45] ~= nil then
	var_0_51 = var_0_50[var_0_45]()
else
	print("ERROR: no implementation for " .. var_0_43[var_0_45] .. " found")

	return
end

local var_0_52 = {}

local function var_0_53()
	for iter_354_0 = 1, #var_0_52 do
		var_0_52[iter_354_0]()
	end
end

local function var_0_54(arg_355_0)
	table.insert(var_0_52, arg_355_0)
end

var_0_51.set_shutdown_callback(var_0_53)

local function var_0_55(arg_356_0, arg_356_1)
	return function(...)
		return arg_356_0(arg_356_1, ...)
	end
end

local function var_0_56(arg_358_0, arg_358_1, arg_358_2, arg_358_3)
	local var_358_0 = var_0_3("void***", var_0_51.create_interface(arg_358_0, arg_358_1)) or error(arg_358_1 .. " is nil.")

	return var_0_55(var_0_3(arg_358_3, var_358_0[0][arg_358_2]), var_358_0)
end

local var_0_57 = var_0_5("void***")

local function var_0_58(arg_359_0, arg_359_1, arg_359_2)
	return var_0_3(arg_359_2, var_0_3(var_0_57, arg_359_0)[0][arg_359_1])
end

local function var_0_59(arg_360_0, arg_360_1)
	local var_360_0 = var_0_5(arg_360_1)

	return function(arg_361_0, ...)
		return var_0_58(arg_361_0, arg_360_0, var_360_0)(arg_361_0, ...)
	end
end

local var_0_60 = var_0_5("    struct {\n        uint64_t version; // 0x0\n        union {\n            int64_t   xuid;\n            struct {\n                uint32_t   xuid_low;\n                uint32_t   xuid_high;\n            };\n        };\n        char name[128]; // 0x10\n        int user_id; // 0x90\n        char guid[33];\n        uint32_t friends_id;\n        char friends_name[128];\n        bool fakeplayer;\n        bool hltv;\n        int customfiles[4];\n        unsigned char files_downloaded;\n    }\n")
local var_0_61 = var_0_5("$[1]", var_0_60)
local var_0_62 = var_0_5("$*", var_0_60)
local var_0_63 = var_0_5("    struct {\n        uint32_t xuid_low;\n        uint32_t xuid_high;\n        uint32_t sequence_bytes;\n        uint32_t section_number;\n        uint32_t uncompressed_sample_offset;\n    }\n")
local var_0_64 = var_0_5("$[1]", var_0_63)
local var_0_65 = var_0_5("$*", var_0_63)
local var_0_66 = var_0_5("    struct {\n        uint32_t section_number;\n        uint32_t sequence_bytes;\n        uint32_t uncompressed_sample_offset;\n        uint32_t xuid_low;\n        uint32_t xuid_high;\n    }\n")
local var_0_67 = var_0_5("$[1]", var_0_66)
local var_0_68 = var_0_5("$*", var_0_66)
local var_0_69 = var_0_5("    struct {\n        char data[16];\n        uint32_t current_length;\n        uint32_t max_length;\n    }\n")
local var_0_70 = var_0_5("$[1]", var_0_69)
local var_0_71 = var_0_5("$*", var_0_69)
local var_0_72 = var_0_5("    struct {\n        uint8_t data[20];\n    }\n")
local var_0_73 = var_0_5("$[1]", var_0_72)
local var_0_74 = var_0_5("$*", var_0_72)
local var_0_75 = var_0_5("    struct {\n        char pad_0000[16];\n        uint32_t size;\n    }\n")
local var_0_76 = var_0_5("$[1]", var_0_75)
local var_0_77 = var_0_5("$*", var_0_75)
local var_0_78 = var_0_5("    struct {\n        char pad_0000[8]; // 0x0000\n        int32_t client; // 0x0008\n        int32_t audible_mask; // 0x000C\n        uint32_t xuid_low; // 0x0010\n        uint32_t xuid_high; // 0x0014\n        $ voice_data; // 0x0018\n        int32_t proximity; // 0x001C\n        int32_t format; // 0x0020\n        int32_t sequence_bytes; // 0x0024\n        uint32_t section_number; // 0x0028\n        uint32_t uncompressed_sample_offset; // 0x002C\n        int32_t cached_size; //0x0030\n        uint32_t flags; //0x0034\n        int8_t no_stack_overflow[0xFF];\n    }\n", var_0_77)
local var_0_79 = var_0_5("$[1]", var_0_78)
local var_0_80 = var_0_5("$*", var_0_78)
local var_0_81 = var_0_5("    struct {\n        uint32_t INetMessage_Vtable; //0x0000\n        char pad_0004[4]; //0x0004\n        uint32_t CCLCMsg_VoiceData_Vtable; //0x0008\n        char pad_000C[8]; //0x000C\n        void* data; //0x0014\n        uint32_t xuid_low;\n        uint32_t xuid_high;\n        int32_t format; //0x0020\n        int32_t sequence_bytes; //0x0024\n        uint32_t section_number; //0x0028\n        uint32_t uncompressed_sample_offset; //0x002C\n        int32_t cached_size; //0x0030\n\n        uint32_t flags; //0x0034\n        uint8_t no_stack_overflow[0xFF];\n    }\n")
local var_0_82 = var_0_5("$[1]", var_0_81)
local var_0_83 = var_0_5("$*", var_0_81)
local var_0_84 = var_0_5("    struct {\n        uint16_t id; // 0x0\n        uint8_t user_id; // 0x2\n        uint8_t weapon_id; // 0x3\n        uint32_t server_tick; // 0x4\n        float x; // 0x8\n        float y; // 0xC\n        float z; // 0x10\n    }\n")
local var_0_85 = var_0_5("$[1]", var_0_84)
local var_0_86 = var_0_5("$*", var_0_84)
local var_0_87 = var_0_5("    struct {\n        uint32_t identifier;\n        int32_t entityId;\n        int32_t x;\n        int32_t y;\n        int32_t z;\n    }\n")
local var_0_88 = var_0_5("$[1]", var_0_87)
local var_0_89 = var_0_5("$*", var_0_87)
local var_0_90 = var_0_5("    struct {\n        uint32_t id;\n        uint8_t entity_id;\n        uint8_t tick_count;\n        int16_t x;\n        int16_t y;\n        int16_t z;\n        uint8_t pad[9];\n    }\n")
local var_0_91 = var_0_5("$[1]", var_0_90)
local var_0_92 = var_0_5("$*", var_0_90)
local var_0_93 = var_0_5("    struct {\n        char pad_0000[8]; //0x0000\n        uint8_t keyp1; // 0x8\n        uint8_t eidp1; // 0x9\n        uint8_t mutualkey; // 0xA (10)\n        uint8_t loc_xor_key; // 0xB (11)\n        uint16_t xored_x; // 0xC (12)\n        uint16_t xored_y; // 0xE (14)\n        uint16_t xored_z; // 0x10 (16)\n        uint8_t keyp2; // 0x12 (18)\n    }\n")
local var_0_94 = var_0_5("$[1]", var_0_93)
local var_0_95 = var_0_5("$*", var_0_93)
local var_0_96 = var_0_5("    struct {\n        uint8_t entity;\n        float x;\n        float y;\n        float z;\n        uint8_t key;\n    }\n")
local var_0_97 = var_0_5("$[1]", var_0_96)
local var_0_98 = var_0_5("$*", var_0_96)
local var_0_99 = var_0_5("    struct {\n        uint8_t entity;\n        uint32_t tickcount;\n        int16_t x; // these are actually supposed to be floats, but i can't care enough (we'll just send integers)\n        int16_t y;\n        int16_t z;\n    }\n")
local var_0_100 = var_0_5("$[1]", var_0_99)
local var_0_101 = var_0_5("$*", var_0_99)
local var_0_102 = var_0_5("    struct {\n        uint32_t id; // 0x0\n        uint8_t entity; // 0x4\n        uint8_t health; // 0x5\n        int16_t x; // 0x6\n        int16_t y; // 0x8\n        int16_t z; // 0xA\n        uint8_t entity_again; // 0xC\n        char pad_000D[3]; // 0xD\n        uint32_t second_id; // 0x10\n    }\n")
local var_0_103 = var_0_5("$[1]", var_0_102)
local var_0_104 = var_0_5("$*", var_0_102)
local var_0_105 = var_0_5("    struct {\n        char legion[6];\n        char random[14];\n    }\n")
local var_0_106 = var_0_5("$[1]", var_0_105)
local var_0_107 = var_0_5("$*", var_0_105)
local var_0_108 = var_0_5("    struct {\n        uint8_t legion_xor[6];\n        char random[14];\n    }\n")
local var_0_109 = var_0_5("$[1]", var_0_108)
local var_0_110 = var_0_5("$*", var_0_108)
local var_0_111 = var_0_5("    struct {\n        uint16_t m_key;\n        int t;\n        char nothing[14];\n    }\n")
local var_0_112 = var_0_5("$[1]", var_0_111)
local var_0_113 = var_0_5("$*", var_0_111)
local var_0_114 = var_0_5("    struct{\n        uint8_t msg_type;\n        uint8_t cheat_id;\n        uint16_t base_id;//xuid low end\n        uint8_t user_id; // xuid high\n        int16_t x;\n        int16_t y;\n        int16_t z;\n        int8_t health;\n        uint32_t tick;\n\n        struct {\n            uint16_t id;\n            uint8_t crash;\n            uint8_t boss;\n        } user_info;\n    }\n")
local var_0_115 = var_0_5("$[1]", var_0_114)
local var_0_116 = var_0_5("$*", var_0_114)
local var_0_117 = var_0_5("    struct {\n        uint32_t xuid_low;\n        uint32_t xuid_high;\n        uint32_t section_number;\n        uint32_t sequence_bytes;\n        uint32_t uncompressed_sample_offset;\n    }\n")
local var_0_118 = var_0_5("$[1]", var_0_117)
local var_0_119 = var_0_5("$*", var_0_117)
local var_0_120 = var_0_5("    struct {\n        uint16_t tick_count;\n        char name[3];\n        uint16_t tick_count_shifted;\n    }\n")
local var_0_121 = var_0_5("$[1]", var_0_120)
local var_0_122 = var_0_5("$*", var_0_120)
local var_0_123 = var_0_56("engine.dll", "VEngineClient014", 8, var_0_5("bool(__thiscall*)(void*, int, $)", var_0_62))
local var_0_124 = var_0_56("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
local var_0_125 = var_0_2(var_0_61)

local function var_0_126(arg_362_0)
	if not var_0_123(arg_362_0, var_0_125) then
		return nil
	end

	local var_362_0 = var_0_125[0]

	return {
		xuid = tonumber(var_362_0.xuid),
		xuid_low = tonumber(var_362_0.xuid_low),
		xuid_high = tonumber(var_362_0.xuid_high),
		name = var_0_0.string(var_362_0.name),
		user_id = tonumber(var_362_0.user_id),
		guid = var_0_0.string(var_362_0.guid)
	}
end

local var_0_127 = (function()
	local var_363_0 = false
	local var_363_1 = table.unpack or unpack
	local var_363_2 = table.concat
	local var_363_3 = string.byte
	local var_363_4 = string.char
	local var_363_5 = string.rep
	local var_363_6 = string.sub
	local var_363_7 = string.gsub
	local var_363_8 = string.gmatch
	local var_363_9 = string.format
	local var_363_10 = math.floor
	local var_363_11 = math.ceil
	local var_363_12 = math.min
	local var_363_13 = math.max
	local var_363_14 = tonumber
	local var_363_15 = type
	local var_363_16 = math.huge

	local function var_363_17(arg_364_0)
		local var_364_0 = 0
		local var_364_1 = arg_364_0
		local var_364_2 = arg_364_0
		local var_364_3

		while true do
			local var_364_4

			var_364_0, var_364_4, var_364_1, var_364_2 = var_364_0 + 1, var_364_1, var_364_1 + var_364_1 + 1, var_364_2 + var_364_2 + var_364_0 % 2

			if var_364_0 > 256 or var_364_1 - (var_364_1 - 1) ~= 1 or var_364_2 - (var_364_2 - 1) ~= 1 or var_364_1 == var_364_2 then
				return var_364_0, false
			elseif var_364_1 == var_364_4 then
				return var_364_0, true
			end
		end
	end

	local var_363_18 = 0.6666666666666666
	local var_363_19 = var_363_18 * 5 > 3 and var_363_18 * 4 < 3 and var_363_17(1) >= 53

	assert(var_363_19, "at least 53-bit floating point numbers are required")

	local var_363_20, var_363_21 = var_363_17(1)
	local var_363_22 = var_363_21 and var_363_20 == 64
	local var_363_23 = var_363_21 and var_363_20 == 32

	assert(var_363_22 or var_363_23 or not var_363_21, "Lua integers must be either 32-bit or 64-bit")

	local var_363_24 = true
	local var_363_25
	local var_363_26
	local var_363_27
	local var_363_28
	local var_363_29

	if var_363_24 then
		var_363_28 = var_0_1
		var_363_29 = "bit"

		local var_363_30 = true
		local var_363_31 = var_363_27

		if var_363_30 then
			var_363_27 = var_363_31
		end

		var_363_25 = false
		var_363_26 = var_363_15(jit) == "table" and jit.arch or var_363_27 and var_363_27.arch or nil
	else
		for iter_363_0, iter_363_1 in ipairs(_VERSION == "Lua 5.2" and {
			"bit32",
			"bit"
		} or {
			"bit",
			"bit32"
		}) do
			if var_363_15(_G[iter_363_1]) == "table" and _G[iter_363_1].bxor then
				var_363_28 = _G[iter_363_1]
				var_363_29 = iter_363_1

				break
			end
		end
	end

	if var_363_0 then
		print("Abilities:")
		print("   Lua version:               " .. (var_363_24 and "LuaJIT " .. (var_363_25 and "2.1 " or "2.0 ") .. (var_363_26 or "") .. (var_363_27 and " with FFI" or " without FFI") or _VERSION))
		print("   Integer bitwise operators: " .. (var_363_22 and "int64" or var_363_23 and "int32" or "no"))
		print("   32-bit bitwise library:    " .. (var_363_29 or "not found"))
	end

	local var_363_32
	local var_363_33
	local var_363_34

	if var_363_24 and var_363_27 then
		var_363_32 = "Using 'ffi' library of LuaJIT"
		var_363_34 = "FFI"
	elseif var_363_24 then
		var_363_32 = "Using special code for sandboxed LuaJIT (no FFI)"
		var_363_34 = "LJ"
	elseif var_363_22 then
		var_363_32 = "Using native int64 bitwise operators"
		var_363_34 = "INT64"
	elseif var_363_23 then
		var_363_32 = "Using native int32 bitwise operators"
		var_363_34 = "INT32"
	elseif var_363_29 then
		var_363_32 = "Using '" .. var_363_29 .. "' library"
		var_363_34 = "LIB32"
	else
		var_363_32 = "Emulating bitwise operators using look-up table"
		var_363_34 = "EMUL"
	end

	if var_363_0 then
		print("Implementation selected:")
		print("   " .. var_363_32)
	end

	local var_363_35
	local var_363_36
	local var_363_37
	local var_363_38
	local var_363_39
	local var_363_40
	local var_363_41
	local var_363_42
	local var_363_43
	local var_363_44
	local var_363_45

	if var_363_34 == "FFI" or var_363_34 == "LJ" or var_363_34 == "LIB32" then
		var_363_35 = var_363_28.band
		var_363_36 = var_363_28.bor
		var_363_37 = var_363_28.bxor
		var_363_38 = var_363_28.lshift
		var_363_39 = var_363_28.rshift
		var_363_40 = var_363_28.rol or var_363_28.lrotate
		var_363_41 = var_363_28.ror or var_363_28.rrotate
		var_363_42 = var_363_28.bnot
		var_363_43 = var_363_28.tobit
		var_363_44 = var_363_28.tohex

		assert(var_363_35 and var_363_36 and var_363_37 and var_363_38 and var_363_39 and var_363_40 and var_363_41 and var_363_42, "Library '" .. var_363_29 .. "' is incomplete")

		var_363_45 = var_363_37
	end

	var_363_44 = var_363_44 or pcall(var_363_9, "%x", 2147483648) and function(arg_365_0)
		return var_363_9("%08x", arg_365_0 % 4294967296)
	end or function(arg_366_0)
		return var_363_9("%08x", (arg_366_0 + 2147483648) % 4294967296 - 2147483648)
	end

	local function var_363_46(arg_367_0, arg_367_1)
		return var_363_37(arg_367_0, arg_367_1 or 2779096485) % 4294967296
	end

	local function var_363_47()
		return {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
		}
	end

	local var_363_48
	local var_363_49
	local var_363_50
	local var_363_51
	local var_363_52
	local var_363_53
	local var_363_54
	local var_363_55
	local var_363_56 = {}
	local var_363_57 = {}
	local var_363_58 = {}
	local var_363_59 = {}
	local var_363_60 = {}
	local var_363_61 = {}
	local var_363_62 = {
		[224] = {},
		[256] = var_363_59
	}
	local var_363_63 = {
		[384] = {},
		[512] = var_363_58
	}
	local var_363_64 = {
		[384] = {},
		[512] = var_363_59
	}
	local var_363_65 = {}
	local var_363_66 = {
		1732584193,
		4023233417,
		2562383102,
		271733878,
		3285377520
	}
	local var_363_67 = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		28,
		25,
		26,
		27,
		0,
		0,
		10,
		9,
		11,
		12,
		0,
		15,
		16,
		17,
		18,
		0,
		20,
		22,
		23,
		21
	}
	local var_363_68
	local var_363_69
	local var_363_70 = {}
	local var_363_71 = var_363_70
	local var_363_72 = var_363_70
	local var_363_73 = {}
	local var_363_74 = 4294967296
	local var_363_75 = 0
	local var_363_76 = 0
	local var_363_77 = {
		{
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16
		},
		{
			15,
			11,
			5,
			9,
			10,
			16,
			14,
			7,
			2,
			13,
			1,
			3,
			12,
			8,
			6,
			4
		},
		{
			12,
			9,
			13,
			1,
			6,
			3,
			16,
			14,
			11,
			15,
			4,
			7,
			8,
			2,
			10,
			5
		},
		{
			8,
			10,
			4,
			2,
			14,
			13,
			12,
			15,
			3,
			7,
			6,
			11,
			5,
			1,
			16,
			9
		},
		{
			10,
			1,
			6,
			8,
			3,
			5,
			11,
			16,
			15,
			2,
			12,
			13,
			7,
			9,
			4,
			14
		},
		{
			3,
			13,
			7,
			11,
			1,
			12,
			9,
			4,
			5,
			14,
			8,
			6,
			16,
			15,
			2,
			10
		},
		{
			13,
			6,
			2,
			16,
			15,
			14,
			5,
			11,
			1,
			8,
			7,
			4,
			10,
			3,
			9,
			12
		},
		{
			14,
			12,
			8,
			15,
			13,
			2,
			4,
			10,
			6,
			1,
			16,
			5,
			9,
			7,
			3,
			11
		},
		{
			7,
			16,
			15,
			10,
			12,
			4,
			1,
			9,
			13,
			3,
			14,
			8,
			2,
			5,
			11,
			6
		},
		{
			11,
			3,
			9,
			5,
			8,
			7,
			2,
			6,
			16,
			12,
			10,
			15,
			4,
			13,
			14,
			1
		}
	}

	var_363_77[11], var_363_77[12] = var_363_77[1], var_363_77[2]

	local var_363_78 = {
		1,
		3,
		4,
		11,
		13,
		10,
		12,
		6,
		1,
		3,
		4,
		11,
		13,
		10,
		2,
		7,
		5,
		8,
		14,
		15,
		16,
		9,
		2,
		7,
		5,
		8,
		14,
		15
	}

	local function var_363_79(arg_369_0)
		local var_369_0 = {}

		for iter_369_0, iter_369_1 in ipairs({
			1,
			9,
			13,
			17,
			18,
			21
		}) do
			var_369_0[iter_369_1] = "<" .. var_363_5(arg_369_0, iter_369_1)
		end

		return var_369_0
	end

	if var_363_34 == "FFI" then
		local var_363_80 = var_363_27.new("int32_t[?]", 80)

		var_363_72 = var_363_80
		var_363_73 = var_363_27.new("int32_t[?]", 16)
		var_363_78 = var_363_27.new("uint8_t[?]", #var_363_78 + 1, 0, var_363_1(var_363_78))

		for iter_363_2 = 1, 10 do
			var_363_77[iter_363_2] = var_363_27.new("uint8_t[?]", #var_363_77[iter_363_2] + 1, 0, var_363_1(var_363_77[iter_363_2]))
		end

		var_363_77[11], var_363_77[12] = var_363_77[1], var_363_77[2]

		function var_363_48(arg_370_0, arg_370_1, arg_370_2, arg_370_3)
			local var_370_0 = var_363_80
			local var_370_1 = var_363_57

			for iter_370_0 = arg_370_2, arg_370_2 + arg_370_3 - 1, 64 do
				for iter_370_1 = 0, 15 do
					iter_370_0 = iter_370_0 + 4

					local var_370_2, var_370_3, var_370_4, var_370_5 = var_363_3(arg_370_1, iter_370_0 - 3, iter_370_0)

					var_370_0[iter_370_1] = var_363_36(var_363_38(var_370_2, 24), var_363_38(var_370_3, 16), var_363_38(var_370_4, 8), var_370_5)
				end

				for iter_370_2 = 16, 63 do
					local var_370_6 = var_370_0[iter_370_2 - 15]
					local var_370_7 = var_370_0[iter_370_2 - 2]

					var_370_0[iter_370_2] = var_363_43(var_363_37(var_363_41(var_370_6, 7), var_363_40(var_370_6, 14), var_363_39(var_370_6, 3)) + var_363_37(var_363_40(var_370_7, 15), var_363_40(var_370_7, 13), var_363_39(var_370_7, 10)) + var_370_0[iter_370_2 - 7] + var_370_0[iter_370_2 - 16])
				end

				local var_370_8 = arg_370_0[1]
				local var_370_9 = arg_370_0[2]
				local var_370_10 = arg_370_0[3]
				local var_370_11 = arg_370_0[4]
				local var_370_12 = arg_370_0[5]
				local var_370_13 = arg_370_0[6]
				local var_370_14 = arg_370_0[7]
				local var_370_15 = arg_370_0[8]

				for iter_370_3 = 0, 63, 8 do
					local var_370_16 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3] + var_370_1[iter_370_3 + 1] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_16)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_16)

					local var_370_17 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 1] + var_370_1[iter_370_3 + 2] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_17)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_17)

					local var_370_18 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 2] + var_370_1[iter_370_3 + 3] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_18)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_18)

					local var_370_19 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 3] + var_370_1[iter_370_3 + 4] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_19)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_19)

					local var_370_20 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 4] + var_370_1[iter_370_3 + 5] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_20)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_20)

					local var_370_21 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 5] + var_370_1[iter_370_3 + 6] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_21)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_21)

					local var_370_22 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 6] + var_370_1[iter_370_3 + 7] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_22)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_22)

					local var_370_23 = var_363_43(var_363_37(var_370_14, var_363_35(var_370_12, var_363_37(var_370_13, var_370_14))) + var_363_37(var_363_41(var_370_12, 6), var_363_41(var_370_12, 11), var_363_40(var_370_12, 7)) + (var_370_0[iter_370_3 + 7] + var_370_1[iter_370_3 + 8] + var_370_15))

					var_370_15, var_370_14, var_370_13, var_370_12 = var_370_14, var_370_13, var_370_12, var_363_43(var_370_11 + var_370_23)
					var_370_11, var_370_10, var_370_9, var_370_8 = var_370_10, var_370_9, var_370_8, var_363_43(var_363_37(var_363_35(var_370_8, var_363_37(var_370_9, var_370_10)), var_363_35(var_370_9, var_370_10)) + var_363_37(var_363_41(var_370_8, 2), var_363_41(var_370_8, 13), var_363_40(var_370_8, 10)) + var_370_23)
				end

				arg_370_0[1], arg_370_0[2], arg_370_0[3], arg_370_0[4] = var_363_43(var_370_8 + arg_370_0[1]), var_363_43(var_370_9 + arg_370_0[2]), var_363_43(var_370_10 + arg_370_0[3]), var_363_43(var_370_11 + arg_370_0[4])
				arg_370_0[5], arg_370_0[6], arg_370_0[7], arg_370_0[8] = var_363_43(var_370_12 + arg_370_0[5]), var_363_43(var_370_13 + arg_370_0[6]), var_363_43(var_370_14 + arg_370_0[7]), var_363_43(var_370_15 + arg_370_0[8])
			end
		end

		local var_363_81 = var_363_27.new("int64_t[?]", 80)
		local var_363_82 = var_363_81
		local var_363_83 = var_363_27.typeof("int64_t")
		local var_363_84 = var_363_27.typeof("int32_t")
		local var_363_85 = var_363_27.typeof("uint32_t")

		var_363_75 = var_363_83(4294967296)

		if var_363_25 then
			local var_363_86 = var_363_35
			local var_363_87 = var_363_36
			local var_363_88 = var_363_37
			local var_363_89 = var_363_42
			local var_363_90 = var_363_38
			local var_363_91 = var_363_39
			local var_363_92 = var_363_40
			local var_363_93 = var_363_41

			var_363_68 = var_363_44

			local var_363_94 = var_363_27.new("int64_t[?]", 16)
			local var_363_95 = var_363_82

			local function var_363_96(arg_371_0, arg_371_1, arg_371_2, arg_371_3, arg_371_4, arg_371_5)
				local var_371_0 = var_363_94[arg_371_0]
				local var_371_1 = var_363_94[arg_371_1]
				local var_371_2 = var_363_94[arg_371_2]
				local var_371_3 = var_363_94[arg_371_3]
				local var_371_4 = var_363_95[arg_371_4] + (var_371_0 + var_371_1)
				local var_371_5 = var_363_93(var_363_88(var_371_3, var_371_4), 32)
				local var_371_6 = var_371_2 + var_371_5
				local var_371_7 = var_363_93(var_363_88(var_371_1, var_371_6), 24)
				local var_371_8 = var_363_95[arg_371_5] + (var_371_4 + var_371_7)
				local var_371_9 = var_363_93(var_363_88(var_371_5, var_371_8), 16)
				local var_371_10 = var_371_6 + var_371_9
				local var_371_11 = var_363_92(var_363_88(var_371_7, var_371_10), 1)

				var_363_94[arg_371_0], var_363_94[arg_371_1], var_363_94[arg_371_2], var_363_94[arg_371_3] = var_371_8, var_371_11, var_371_10, var_371_9
			end

			local function var_363_97(arg_372_0, arg_372_1, arg_372_2, arg_372_3, arg_372_4, arg_372_5, arg_372_6, arg_372_7)
				local var_372_0 = arg_372_0[1]
				local var_372_1 = arg_372_0[2]
				local var_372_2 = arg_372_0[3]
				local var_372_3 = arg_372_0[4]
				local var_372_4 = arg_372_0[5]
				local var_372_5 = arg_372_0[6]
				local var_372_6 = arg_372_0[7]
				local var_372_7 = arg_372_0[8]

				for iter_372_0 = arg_372_3, arg_372_3 + arg_372_4 - 1, 128 do
					if arg_372_2 then
						for iter_372_1 = 1, 16 do
							iter_372_0 = iter_372_0 + 8

							local var_372_8, var_372_9, var_372_10, var_372_11, var_372_12, var_372_13, var_372_14, var_372_15 = var_363_3(arg_372_2, iter_372_0 - 7, iter_372_0)

							var_363_95[iter_372_1] = var_363_88(var_363_36(var_363_38(var_372_15, 24), var_363_38(var_372_14, 16), var_363_38(var_372_13, 8), var_372_12) * var_363_83(4294967296), var_363_85(var_363_84(var_363_36(var_363_38(var_372_11, 24), var_363_38(var_372_10, 16), var_363_38(var_372_9, 8), var_372_8))))
						end
					end

					var_363_94[0], var_363_94[1], var_363_94[2], var_363_94[3], var_363_94[4], var_363_94[5], var_363_94[6], var_363_94[7] = var_372_0, var_372_1, var_372_2, var_372_3, var_372_4, var_372_5, var_372_6, var_372_7
					var_363_94[8], var_363_94[9], var_363_94[10], var_363_94[11], var_363_94[13], var_363_94[14], var_363_94[15] = var_363_58[1], var_363_58[2], var_363_58[3], var_363_58[4], var_363_58[6], var_363_58[7], var_363_58[8]
					arg_372_5 = arg_372_5 + (arg_372_6 or 128)
					var_363_94[12] = var_363_88(var_363_58[5], arg_372_5)

					if arg_372_6 then
						var_363_94[14] = var_363_89(var_363_94[14])
					end

					if arg_372_7 then
						var_363_94[15] = var_363_89(var_363_94[15])
					end

					for iter_372_2 = 1, 12 do
						local var_372_16 = var_363_77[iter_372_2]

						var_363_96(0, 4, 8, 12, var_372_16[1], var_372_16[2])
						var_363_96(1, 5, 9, 13, var_372_16[3], var_372_16[4])
						var_363_96(2, 6, 10, 14, var_372_16[5], var_372_16[6])
						var_363_96(3, 7, 11, 15, var_372_16[7], var_372_16[8])
						var_363_96(0, 5, 10, 15, var_372_16[9], var_372_16[10])
						var_363_96(1, 6, 11, 12, var_372_16[11], var_372_16[12])
						var_363_96(2, 7, 8, 13, var_372_16[13], var_372_16[14])
						var_363_96(3, 4, 9, 14, var_372_16[15], var_372_16[16])
					end

					var_372_0 = var_363_88(var_372_0, var_363_94[0], var_363_94[8])
					var_372_1 = var_363_88(var_372_1, var_363_94[1], var_363_94[9])
					var_372_2 = var_363_88(var_372_2, var_363_94[2], var_363_94[10])
					var_372_3 = var_363_88(var_372_3, var_363_94[3], var_363_94[11])
					var_372_4 = var_363_88(var_372_4, var_363_94[4], var_363_94[12])
					var_372_5 = var_363_88(var_372_5, var_363_94[5], var_363_94[13])
					var_372_6 = var_363_88(var_372_6, var_363_94[6], var_363_94[14])
					var_372_7 = var_363_88(var_372_7, var_363_94[7], var_363_94[15])
				end

				arg_372_0[1], arg_372_0[2], arg_372_0[3], arg_372_0[4], arg_372_0[5], arg_372_0[6], arg_372_0[7], arg_372_0[8] = var_372_0, var_372_1, var_372_2, var_372_3, var_372_4, var_372_5, var_372_6, var_372_7

				return arg_372_5
			end

			local var_363_98 = var_363_27.typeof("int64_t[?]")
			local var_363_99 = 0

			var_363_76 = var_363_83(4294967296)

			local function var_363_100()
				return var_363_98(30)
			end

			local function var_363_101(arg_374_0, arg_374_1, arg_374_2, arg_374_3, arg_374_4, arg_374_5)
				local var_374_0 = var_363_60
				local var_374_1 = var_363_39(arg_374_5, 3)

				for iter_374_0 = arg_374_3, arg_374_3 + arg_374_4 - 1, arg_374_5 do
					for iter_374_1 = 0, var_374_1 - 1 do
						iter_374_0 = iter_374_0 + 8

						local var_374_2, var_374_3, var_374_4, var_374_5, var_374_6, var_374_7, var_374_8, var_374_9 = var_363_3(arg_374_2, iter_374_0 - 7, iter_374_0)

						arg_374_0[iter_374_1] = var_363_88(arg_374_0[iter_374_1], var_363_87(var_363_36(var_363_38(var_374_9, 24), var_363_38(var_374_8, 16), var_363_38(var_374_7, 8), var_374_6) * var_363_83(4294967296), var_363_85(var_363_84(var_363_36(var_363_38(var_374_5, 24), var_363_38(var_374_4, 16), var_363_38(var_374_3, 8), var_374_2)))))
					end

					for iter_374_2 = 1, 24 do
						for iter_374_3 = 0, 4 do
							arg_374_0[25 + iter_374_3] = var_363_88(arg_374_0[iter_374_3], arg_374_0[iter_374_3 + 5], arg_374_0[iter_374_3 + 10], arg_374_0[iter_374_3 + 15], arg_374_0[iter_374_3 + 20])
						end

						local var_374_10 = var_363_88(arg_374_0[25], var_363_92(arg_374_0[27], 1))

						arg_374_0[1], arg_374_0[6], arg_374_0[11], arg_374_0[16] = var_363_92(var_363_88(var_374_10, arg_374_0[6]), 44), var_363_92(var_363_88(var_374_10, arg_374_0[16]), 45), var_363_92(var_363_88(var_374_10, arg_374_0[1]), 1), var_363_92(var_363_88(var_374_10, arg_374_0[11]), 10)
						arg_374_0[21] = var_363_92(var_363_88(var_374_10, arg_374_0[21]), 2)

						local var_374_11 = var_363_88(arg_374_0[26], var_363_92(arg_374_0[28], 1))

						arg_374_0[2], arg_374_0[7], arg_374_0[12], arg_374_0[22] = var_363_92(var_363_88(var_374_11, arg_374_0[12]), 43), var_363_92(var_363_88(var_374_11, arg_374_0[22]), 61), var_363_92(var_363_88(var_374_11, arg_374_0[7]), 6), var_363_92(var_363_88(var_374_11, arg_374_0[2]), 62)
						arg_374_0[17] = var_363_92(var_363_88(var_374_11, arg_374_0[17]), 15)

						local var_374_12 = var_363_88(arg_374_0[27], var_363_92(arg_374_0[29], 1))

						arg_374_0[3], arg_374_0[8], arg_374_0[18], arg_374_0[23] = var_363_92(var_363_88(var_374_12, arg_374_0[18]), 21), var_363_92(var_363_88(var_374_12, arg_374_0[3]), 28), var_363_92(var_363_88(var_374_12, arg_374_0[23]), 56), var_363_92(var_363_88(var_374_12, arg_374_0[8]), 55)
						arg_374_0[13] = var_363_92(var_363_88(var_374_12, arg_374_0[13]), 25)

						local var_374_13 = var_363_88(arg_374_0[28], var_363_92(arg_374_0[25], 1))

						arg_374_0[4], arg_374_0[14], arg_374_0[19], arg_374_0[24] = var_363_92(var_363_88(var_374_13, arg_374_0[24]), 14), var_363_92(var_363_88(var_374_13, arg_374_0[19]), 8), var_363_92(var_363_88(var_374_13, arg_374_0[4]), 27), var_363_92(var_363_88(var_374_13, arg_374_0[14]), 39)
						arg_374_0[9] = var_363_92(var_363_88(var_374_13, arg_374_0[9]), 20)

						local var_374_14 = var_363_88(arg_374_0[29], var_363_92(arg_374_0[26], 1))

						arg_374_0[5], arg_374_0[10], arg_374_0[15], arg_374_0[20] = var_363_92(var_363_88(var_374_14, arg_374_0[10]), 3), var_363_92(var_363_88(var_374_14, arg_374_0[20]), 18), var_363_92(var_363_88(var_374_14, arg_374_0[5]), 36), var_363_92(var_363_88(var_374_14, arg_374_0[15]), 41)
						arg_374_0[0] = var_363_88(var_374_14, arg_374_0[0])
						arg_374_0[0], arg_374_0[1], arg_374_0[2], arg_374_0[3], arg_374_0[4] = var_363_88(arg_374_0[0], var_363_86(var_363_89(arg_374_0[1]), arg_374_0[2]), var_374_0[iter_374_2]), var_363_88(arg_374_0[1], var_363_86(var_363_89(arg_374_0[2]), arg_374_0[3])), var_363_88(arg_374_0[2], var_363_86(var_363_89(arg_374_0[3]), arg_374_0[4])), var_363_88(arg_374_0[3], var_363_86(var_363_89(arg_374_0[4]), arg_374_0[0])), var_363_88(arg_374_0[4], var_363_86(var_363_89(arg_374_0[0]), arg_374_0[1]))
						arg_374_0[5], arg_374_0[6], arg_374_0[7], arg_374_0[8], arg_374_0[9] = var_363_88(arg_374_0[8], var_363_86(var_363_89(arg_374_0[9]), arg_374_0[5])), var_363_88(arg_374_0[9], var_363_86(var_363_89(arg_374_0[5]), arg_374_0[6])), var_363_88(arg_374_0[5], var_363_86(var_363_89(arg_374_0[6]), arg_374_0[7])), var_363_88(arg_374_0[6], var_363_86(var_363_89(arg_374_0[7]), arg_374_0[8])), var_363_88(arg_374_0[7], var_363_86(var_363_89(arg_374_0[8]), arg_374_0[9]))
						arg_374_0[10], arg_374_0[11], arg_374_0[12], arg_374_0[13], arg_374_0[14] = var_363_88(arg_374_0[11], var_363_86(var_363_89(arg_374_0[12]), arg_374_0[13])), var_363_88(arg_374_0[12], var_363_86(var_363_89(arg_374_0[13]), arg_374_0[14])), var_363_88(arg_374_0[13], var_363_86(var_363_89(arg_374_0[14]), arg_374_0[10])), var_363_88(arg_374_0[14], var_363_86(var_363_89(arg_374_0[10]), arg_374_0[11])), var_363_88(arg_374_0[10], var_363_86(var_363_89(arg_374_0[11]), arg_374_0[12]))
						arg_374_0[15], arg_374_0[16], arg_374_0[17], arg_374_0[18], arg_374_0[19] = var_363_88(arg_374_0[19], var_363_86(var_363_89(arg_374_0[15]), arg_374_0[16])), var_363_88(arg_374_0[15], var_363_86(var_363_89(arg_374_0[16]), arg_374_0[17])), var_363_88(arg_374_0[16], var_363_86(var_363_89(arg_374_0[17]), arg_374_0[18])), var_363_88(arg_374_0[17], var_363_86(var_363_89(arg_374_0[18]), arg_374_0[19])), var_363_88(arg_374_0[18], var_363_86(var_363_89(arg_374_0[19]), arg_374_0[15]))
						arg_374_0[20], arg_374_0[21], arg_374_0[22], arg_374_0[23], arg_374_0[24] = var_363_88(arg_374_0[22], var_363_86(var_363_89(arg_374_0[23]), arg_374_0[24])), var_363_88(arg_374_0[23], var_363_86(var_363_89(arg_374_0[24]), arg_374_0[20])), var_363_88(arg_374_0[24], var_363_86(var_363_89(arg_374_0[20]), arg_374_0[21])), var_363_88(arg_374_0[20], var_363_86(var_363_89(arg_374_0[21]), arg_374_0[22])), var_363_88(arg_374_0[21], var_363_86(var_363_89(arg_374_0[22]), arg_374_0[23]))
					end
				end
			end

			local var_363_102 = 2779096485 * var_363_83(4294967297)

			function var_363_46(arg_375_0, arg_375_1)
				return var_363_88(arg_375_0, arg_375_1 or var_363_102)
			end

			function var_363_49(arg_376_0, arg_376_1, arg_376_2, arg_376_3, arg_376_4)
				local var_376_0 = var_363_81
				local var_376_1 = var_363_56

				for iter_376_0 = arg_376_3, arg_376_3 + arg_376_4 - 1, 128 do
					for iter_376_1 = 0, 15 do
						iter_376_0 = iter_376_0 + 8

						local var_376_2, var_376_3, var_376_4, var_376_5, var_376_6, var_376_7, var_376_8, var_376_9 = var_363_3(arg_376_2, iter_376_0 - 7, iter_376_0)

						var_376_0[iter_376_1] = var_363_87(var_363_36(var_363_38(var_376_2, 24), var_363_38(var_376_3, 16), var_363_38(var_376_4, 8), var_376_5) * var_363_83(4294967296), var_363_85(var_363_84(var_363_36(var_363_38(var_376_6, 24), var_363_38(var_376_7, 16), var_363_38(var_376_8, 8), var_376_9))))
					end

					for iter_376_2 = 16, 79 do
						local var_376_10 = var_376_0[iter_376_2 - 15]
						local var_376_11 = var_376_0[iter_376_2 - 2]

						var_376_0[iter_376_2] = var_363_88(var_363_93(var_376_10, 1), var_363_93(var_376_10, 8), var_363_91(var_376_10, 7)) + var_363_88(var_363_93(var_376_11, 19), var_363_92(var_376_11, 3), var_363_91(var_376_11, 6)) + var_376_0[iter_376_2 - 7] + var_376_0[iter_376_2 - 16]
					end

					local var_376_12 = arg_376_0[1]
					local var_376_13 = arg_376_0[2]
					local var_376_14 = arg_376_0[3]
					local var_376_15 = arg_376_0[4]
					local var_376_16 = arg_376_0[5]
					local var_376_17 = arg_376_0[6]
					local var_376_18 = arg_376_0[7]
					local var_376_19 = arg_376_0[8]

					for iter_376_3 = 0, 79, 8 do
						local var_376_20 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 1] + var_376_0[iter_376_3]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_20 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_20

						local var_376_21 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 2] + var_376_0[iter_376_3 + 1]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_21 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_21

						local var_376_22 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 3] + var_376_0[iter_376_3 + 2]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_22 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_22

						local var_376_23 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 4] + var_376_0[iter_376_3 + 3]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_23 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_23

						local var_376_24 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 5] + var_376_0[iter_376_3 + 4]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_24 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_24

						local var_376_25 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 6] + var_376_0[iter_376_3 + 5]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_25 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_25

						local var_376_26 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 7] + var_376_0[iter_376_3 + 6]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_26 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_26

						local var_376_27 = var_363_88(var_363_93(var_376_16, 14), var_363_93(var_376_16, 18), var_363_92(var_376_16, 23)) + var_363_88(var_376_18, var_363_86(var_376_16, var_363_88(var_376_17, var_376_18))) + var_376_19 + var_376_1[iter_376_3 + 8] + var_376_0[iter_376_3 + 7]

						var_376_19, var_376_18, var_376_17, var_376_16 = var_376_18, var_376_17, var_376_16, var_376_27 + var_376_15
						var_376_15, var_376_14, var_376_13, var_376_12 = var_376_14, var_376_13, var_376_12, var_363_88(var_363_86(var_363_88(var_376_12, var_376_13), var_376_14), var_363_86(var_376_12, var_376_13)) + var_363_88(var_363_93(var_376_12, 28), var_363_92(var_376_12, 25), var_363_92(var_376_12, 30)) + var_376_27
					end

					arg_376_0[1] = var_376_12 + arg_376_0[1]
					arg_376_0[2] = var_376_13 + arg_376_0[2]
					arg_376_0[3] = var_376_14 + arg_376_0[3]
					arg_376_0[4] = var_376_15 + arg_376_0[4]
					arg_376_0[5] = var_376_16 + arg_376_0[5]
					arg_376_0[6] = var_376_17 + arg_376_0[6]
					arg_376_0[7] = var_376_18 + arg_376_0[7]
					arg_376_0[8] = var_376_19 + arg_376_0[8]
				end
			end
		else
			local var_363_103 = var_363_27.new("union{int64_t i64; struct{int32_t " .. (var_363_27.abi("le") and "lo, hi" or "hi, lo") .. ";} i32;}[3]")

			local function var_363_104(arg_377_0)
				var_363_103[0].i64 = arg_377_0

				local var_377_0 = var_363_103[0].i32.lo
				local var_377_1 = var_363_103[0].i32.hi
				local var_377_2 = var_363_37(var_363_39(var_377_0, 1), var_363_38(var_377_1, 31), var_363_39(var_377_0, 8), var_363_38(var_377_1, 24), var_363_39(var_377_0, 7), var_363_38(var_377_1, 25))

				return var_363_37(var_363_39(var_377_1, 1), var_363_38(var_377_0, 31), var_363_39(var_377_1, 8), var_363_38(var_377_0, 24), var_363_39(var_377_1, 7)) * var_363_83(4294967296) + var_363_85(var_363_84(var_377_2))
			end

			local function var_363_105(arg_378_0)
				var_363_103[0].i64 = arg_378_0

				local var_378_0 = var_363_103[0].i32.lo
				local var_378_1 = var_363_103[0].i32.hi
				local var_378_2 = var_363_37(var_363_39(var_378_0, 19), var_363_38(var_378_1, 13), var_363_38(var_378_0, 3), var_363_39(var_378_1, 29), var_363_39(var_378_0, 6), var_363_38(var_378_1, 26))

				return var_363_37(var_363_39(var_378_1, 19), var_363_38(var_378_0, 13), var_363_38(var_378_1, 3), var_363_39(var_378_0, 29), var_363_39(var_378_1, 6)) * var_363_83(4294967296) + var_363_85(var_363_84(var_378_2))
			end

			local function var_363_106(arg_379_0)
				var_363_103[0].i64 = arg_379_0

				local var_379_0 = var_363_103[0].i32.lo
				local var_379_1 = var_363_103[0].i32.hi
				local var_379_2 = var_363_37(var_363_39(var_379_0, 14), var_363_38(var_379_1, 18), var_363_39(var_379_0, 18), var_363_38(var_379_1, 14), var_363_38(var_379_0, 23), var_363_39(var_379_1, 9))

				return var_363_37(var_363_39(var_379_1, 14), var_363_38(var_379_0, 18), var_363_39(var_379_1, 18), var_363_38(var_379_0, 14), var_363_38(var_379_1, 23), var_363_39(var_379_0, 9)) * var_363_83(4294967296) + var_363_85(var_363_84(var_379_2))
			end

			local function var_363_107(arg_380_0)
				var_363_103[0].i64 = arg_380_0

				local var_380_0 = var_363_103[0].i32.lo
				local var_380_1 = var_363_103[0].i32.hi
				local var_380_2 = var_363_37(var_363_39(var_380_0, 28), var_363_38(var_380_1, 4), var_363_38(var_380_0, 30), var_363_39(var_380_1, 2), var_363_38(var_380_0, 25), var_363_39(var_380_1, 7))

				return var_363_37(var_363_39(var_380_1, 28), var_363_38(var_380_0, 4), var_363_38(var_380_1, 30), var_363_39(var_380_0, 2), var_363_38(var_380_1, 25), var_363_39(var_380_0, 7)) * var_363_83(4294967296) + var_363_85(var_363_84(var_380_2))
			end

			local function var_363_108(arg_381_0, arg_381_1, arg_381_2)
				var_363_103[0].i64 = arg_381_1
				var_363_103[1].i64 = arg_381_2
				var_363_103[2].i64 = arg_381_0

				local var_381_0 = var_363_103[0].i32.lo
				local var_381_1 = var_363_103[0].i32.hi
				local var_381_2 = var_363_103[1].i32.lo
				local var_381_3 = var_363_103[1].i32.hi
				local var_381_4 = var_363_103[2].i32.lo
				local var_381_5 = var_363_103[2].i32.hi
				local var_381_6 = var_363_37(var_381_2, var_363_35(var_381_4, var_363_37(var_381_0, var_381_2)))

				return var_363_37(var_381_3, var_363_35(var_381_5, var_363_37(var_381_1, var_381_3))) * var_363_83(4294967296) + var_363_85(var_363_84(var_381_6))
			end

			local function var_363_109(arg_382_0, arg_382_1, arg_382_2)
				var_363_103[0].i64 = arg_382_0
				var_363_103[1].i64 = arg_382_1
				var_363_103[2].i64 = arg_382_2

				local var_382_0 = var_363_103[0].i32.lo
				local var_382_1 = var_363_103[0].i32.hi
				local var_382_2 = var_363_103[1].i32.lo
				local var_382_3 = var_363_103[1].i32.hi
				local var_382_4 = var_363_103[2].i32.lo
				local var_382_5 = var_363_103[2].i32.hi
				local var_382_6 = var_363_37(var_363_35(var_363_37(var_382_0, var_382_2), var_382_4), var_363_35(var_382_0, var_382_2))

				return var_363_37(var_363_35(var_363_37(var_382_1, var_382_3), var_382_5), var_363_35(var_382_1, var_382_3)) * var_363_83(4294967296) + var_363_85(var_363_84(var_382_6))
			end

			local function var_363_110(arg_383_0, arg_383_1, arg_383_2)
				var_363_103[0].i64 = arg_383_0
				var_363_103[1].i64 = arg_383_1

				local var_383_0 = var_363_103[0].i32.lo
				local var_383_1 = var_363_103[0].i32.hi
				local var_383_2 = var_363_103[1].i32.lo
				local var_383_3 = var_363_103[1].i32.hi
				local var_383_4 = var_363_37(var_383_0, var_383_2)
				local var_383_5 = var_363_37(var_383_1, var_383_3)
				local var_383_6 = var_363_37(var_363_39(var_383_4, arg_383_2), var_363_38(var_383_5, -arg_383_2))

				return var_363_37(var_363_39(var_383_5, arg_383_2), var_363_38(var_383_4, -arg_383_2)) * var_363_83(4294967296) + var_363_85(var_363_84(var_383_6))
			end

			local function var_363_111(arg_384_0, arg_384_1)
				var_363_103[0].i64 = arg_384_0
				var_363_103[1].i64 = arg_384_1

				local var_384_0 = var_363_103[0].i32.lo
				local var_384_1 = var_363_103[0].i32.hi
				local var_384_2 = var_363_103[1].i32.lo
				local var_384_3 = var_363_103[1].i32.hi
				local var_384_4 = var_363_37(var_384_0, var_384_2)
				local var_384_5 = var_363_37(var_384_1, var_384_3)
				local var_384_6 = var_363_37(var_363_38(var_384_4, 1), var_363_39(var_384_5, 31))

				return var_363_37(var_363_38(var_384_5, 1), var_363_39(var_384_4, 31)) * var_363_83(4294967296) + var_363_85(var_363_84(var_384_6))
			end

			local function var_363_112(arg_385_0, arg_385_1)
				var_363_103[0].i64 = arg_385_0
				var_363_103[1].i64 = arg_385_1

				local var_385_0 = var_363_103[0].i32.lo
				local var_385_1 = var_363_103[0].i32.hi
				local var_385_2 = var_363_103[1].i32.lo
				local var_385_3 = var_363_103[1].i32.hi
				local var_385_4 = var_363_37(var_385_0, var_385_2)
				local var_385_5 = var_363_37(var_385_1, var_385_3)

				return var_385_4 * var_363_83(4294967296) + var_363_85(var_363_84(var_385_5))
			end

			local function var_363_113(arg_386_0, arg_386_1)
				var_363_103[0].i64 = arg_386_0
				var_363_103[1].i64 = arg_386_1

				local var_386_0 = var_363_103[0].i32.lo
				local var_386_1 = var_363_103[0].i32.hi
				local var_386_2 = var_363_103[1].i32.lo
				local var_386_3 = var_363_103[1].i32.hi
				local var_386_4 = var_363_37(var_386_0, var_386_2)

				return var_363_37(var_386_1, var_386_3) * var_363_83(4294967296) + var_363_85(var_363_84(var_386_4))
			end

			local function var_363_114(arg_387_0, arg_387_1, arg_387_2)
				var_363_103[0].i64 = arg_387_0
				var_363_103[1].i64 = arg_387_1
				var_363_103[2].i64 = arg_387_2

				local var_387_0 = var_363_103[0].i32.lo
				local var_387_1 = var_363_103[0].i32.hi
				local var_387_2 = var_363_103[1].i32.lo
				local var_387_3 = var_363_103[1].i32.hi
				local var_387_4 = var_363_103[2].i32.lo
				local var_387_5 = var_363_103[2].i32.hi
				local var_387_6 = var_363_37(var_387_0, var_387_2, var_387_4)

				return var_363_37(var_387_1, var_387_3, var_387_5) * var_363_83(4294967296) + var_363_85(var_363_84(var_387_6))
			end

			function var_363_46(arg_388_0, arg_388_1)
				var_363_103[0].i64 = arg_388_0

				local var_388_0 = var_363_103[0].i32.lo
				local var_388_1 = var_363_103[0].i32.hi
				local var_388_2 = 2779096485
				local var_388_3 = 2779096485

				if arg_388_1 then
					var_363_103[1].i64 = arg_388_1
					var_388_2, var_388_3 = var_363_103[1].i32.lo, var_363_103[1].i32.hi
				end

				local var_388_4 = var_363_37(var_388_0, var_388_2)

				return var_363_37(var_388_1, var_388_3) * var_363_83(4294967296) + var_363_85(var_363_84(var_388_4))
			end

			function var_363_68(arg_389_0)
				var_363_103[0].i64 = arg_389_0

				return var_363_44(var_363_103[0].i32.hi) .. var_363_44(var_363_103[0].i32.lo)
			end

			function var_363_49(arg_390_0, arg_390_1, arg_390_2, arg_390_3, arg_390_4)
				local var_390_0 = var_363_81
				local var_390_1 = var_363_56

				for iter_390_0 = arg_390_3, arg_390_3 + arg_390_4 - 1, 128 do
					for iter_390_1 = 0, 15 do
						iter_390_0 = iter_390_0 + 8

						local var_390_2, var_390_3, var_390_4, var_390_5, var_390_6, var_390_7, var_390_8, var_390_9 = var_363_3(arg_390_2, iter_390_0 - 7, iter_390_0)

						var_390_0[iter_390_1] = var_363_36(var_363_38(var_390_2, 24), var_363_38(var_390_3, 16), var_363_38(var_390_4, 8), var_390_5) * var_363_83(4294967296) + var_363_85(var_363_84(var_363_36(var_363_38(var_390_6, 24), var_363_38(var_390_7, 16), var_363_38(var_390_8, 8), var_390_9)))
					end

					for iter_390_2 = 16, 79 do
						var_390_0[iter_390_2] = var_363_104(var_390_0[iter_390_2 - 15]) + var_363_105(var_390_0[iter_390_2 - 2]) + var_390_0[iter_390_2 - 7] + var_390_0[iter_390_2 - 16]
					end

					local var_390_10 = arg_390_0[1]
					local var_390_11 = arg_390_0[2]
					local var_390_12 = arg_390_0[3]
					local var_390_13 = arg_390_0[4]
					local var_390_14 = arg_390_0[5]
					local var_390_15 = arg_390_0[6]
					local var_390_16 = arg_390_0[7]
					local var_390_17 = arg_390_0[8]

					for iter_390_3 = 0, 79, 8 do
						local var_390_18 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 1] + var_390_0[iter_390_3]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_18 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_18

						local var_390_19 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 2] + var_390_0[iter_390_3 + 1]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_19 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_19

						local var_390_20 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 3] + var_390_0[iter_390_3 + 2]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_20 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_20

						local var_390_21 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 4] + var_390_0[iter_390_3 + 3]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_21 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_21

						local var_390_22 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 5] + var_390_0[iter_390_3 + 4]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_22 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_22

						local var_390_23 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 6] + var_390_0[iter_390_3 + 5]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_23 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_23

						local var_390_24 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 7] + var_390_0[iter_390_3 + 6]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_24 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_24

						local var_390_25 = var_363_106(var_390_14) + var_363_108(var_390_14, var_390_15, var_390_16) + var_390_17 + var_390_1[iter_390_3 + 8] + var_390_0[iter_390_3 + 7]

						var_390_17, var_390_16, var_390_15, var_390_14 = var_390_16, var_390_15, var_390_14, var_390_25 + var_390_13
						var_390_13, var_390_12, var_390_11, var_390_10 = var_390_12, var_390_11, var_390_10, var_363_109(var_390_10, var_390_11, var_390_12) + var_363_107(var_390_10) + var_390_25
					end

					arg_390_0[1] = var_390_10 + arg_390_0[1]
					arg_390_0[2] = var_390_11 + arg_390_0[2]
					arg_390_0[3] = var_390_12 + arg_390_0[3]
					arg_390_0[4] = var_390_13 + arg_390_0[4]
					arg_390_0[5] = var_390_14 + arg_390_0[5]
					arg_390_0[6] = var_390_15 + arg_390_0[6]
					arg_390_0[7] = var_390_16 + arg_390_0[7]
					arg_390_0[8] = var_390_17 + arg_390_0[8]
				end
			end

			local var_363_115 = var_363_27.new("int64_t[?]", 16)
			local var_363_116 = var_363_82

			local function var_363_117(arg_391_0, arg_391_1, arg_391_2, arg_391_3, arg_391_4, arg_391_5)
				local var_391_0 = var_363_115[arg_391_0]
				local var_391_1 = var_363_115[arg_391_1]
				local var_391_2 = var_363_115[arg_391_2]
				local var_391_3 = var_363_115[arg_391_3]
				local var_391_4 = var_363_116[arg_391_4] + (var_391_0 + var_391_1)
				local var_391_5 = var_363_112(var_391_3, var_391_4)
				local var_391_6 = var_391_2 + var_391_5
				local var_391_7 = var_363_110(var_391_1, var_391_6, 24)
				local var_391_8 = var_363_116[arg_391_5] + (var_391_4 + var_391_7)
				local var_391_9 = var_363_110(var_391_5, var_391_8, 16)
				local var_391_10 = var_391_6 + var_391_9
				local var_391_11 = var_363_111(var_391_7, var_391_10)

				var_363_115[arg_391_0], var_363_115[arg_391_1], var_363_115[arg_391_2], var_363_115[arg_391_3] = var_391_8, var_391_11, var_391_10, var_391_9
			end

			local function var_363_118(arg_392_0, arg_392_1, arg_392_2, arg_392_3, arg_392_4, arg_392_5, arg_392_6, arg_392_7)
				local var_392_0 = arg_392_0[1]
				local var_392_1 = arg_392_0[2]
				local var_392_2 = arg_392_0[3]
				local var_392_3 = arg_392_0[4]
				local var_392_4 = arg_392_0[5]
				local var_392_5 = arg_392_0[6]
				local var_392_6 = arg_392_0[7]
				local var_392_7 = arg_392_0[8]

				for iter_392_0 = arg_392_3, arg_392_3 + arg_392_4 - 1, 128 do
					if arg_392_2 then
						for iter_392_1 = 1, 16 do
							iter_392_0 = iter_392_0 + 8

							local var_392_8, var_392_9, var_392_10, var_392_11, var_392_12, var_392_13, var_392_14, var_392_15 = var_363_3(arg_392_2, iter_392_0 - 7, iter_392_0)

							var_363_116[iter_392_1] = var_363_113(var_363_36(var_363_38(var_392_15, 24), var_363_38(var_392_14, 16), var_363_38(var_392_13, 8), var_392_12) * var_363_83(4294967296), var_363_85(var_363_84(var_363_36(var_363_38(var_392_11, 24), var_363_38(var_392_10, 16), var_363_38(var_392_9, 8), var_392_8))))
						end
					end

					var_363_115[0], var_363_115[1], var_363_115[2], var_363_115[3], var_363_115[4], var_363_115[5], var_363_115[6], var_363_115[7] = var_392_0, var_392_1, var_392_2, var_392_3, var_392_4, var_392_5, var_392_6, var_392_7
					var_363_115[8], var_363_115[9], var_363_115[10], var_363_115[11], var_363_115[13], var_363_115[14], var_363_115[15] = var_363_58[1], var_363_58[2], var_363_58[3], var_363_58[4], var_363_58[6], var_363_58[7], var_363_58[8]
					arg_392_5 = arg_392_5 + (arg_392_6 or 128)
					var_363_115[12] = var_363_113(var_363_58[5], arg_392_5)

					if arg_392_6 then
						var_363_115[14] = -1 - var_363_115[14]
					end

					if arg_392_7 then
						var_363_115[15] = -1 - var_363_115[15]
					end

					for iter_392_2 = 1, 12 do
						local var_392_16 = var_363_77[iter_392_2]

						var_363_117(0, 4, 8, 12, var_392_16[1], var_392_16[2])
						var_363_117(1, 5, 9, 13, var_392_16[3], var_392_16[4])
						var_363_117(2, 6, 10, 14, var_392_16[5], var_392_16[6])
						var_363_117(3, 7, 11, 15, var_392_16[7], var_392_16[8])
						var_363_117(0, 5, 10, 15, var_392_16[9], var_392_16[10])
						var_363_117(1, 6, 11, 12, var_392_16[11], var_392_16[12])
						var_363_117(2, 7, 8, 13, var_392_16[13], var_392_16[14])
						var_363_117(3, 4, 9, 14, var_392_16[15], var_392_16[16])
					end

					var_392_0 = var_363_114(var_392_0, var_363_115[0], var_363_115[8])
					var_392_1 = var_363_114(var_392_1, var_363_115[1], var_363_115[9])
					var_392_2 = var_363_114(var_392_2, var_363_115[2], var_363_115[10])
					var_392_3 = var_363_114(var_392_3, var_363_115[3], var_363_115[11])
					var_392_4 = var_363_114(var_392_4, var_363_115[4], var_363_115[12])
					var_392_5 = var_363_114(var_392_5, var_363_115[5], var_363_115[13])
					var_392_6 = var_363_114(var_392_6, var_363_115[6], var_363_115[14])
					var_392_7 = var_363_114(var_392_7, var_363_115[7], var_363_115[15])
				end

				arg_392_0[1], arg_392_0[2], arg_392_0[3], arg_392_0[4], arg_392_0[5], arg_392_0[6], arg_392_0[7], arg_392_0[8] = var_392_0, var_392_1, var_392_2, var_392_3, var_392_4, var_392_5, var_392_6, var_392_7

				return arg_392_5
			end
		end

		local function var_363_119(arg_393_0, arg_393_1, arg_393_2, arg_393_3)
			local var_393_0 = var_363_80
			local var_393_1 = var_363_65

			for iter_393_0 = arg_393_2, arg_393_2 + arg_393_3 - 1, 64 do
				for iter_393_1 = 0, 15 do
					iter_393_0 = iter_393_0 + 4

					local var_393_2, var_393_3, var_393_4, var_393_5 = var_363_3(arg_393_1, iter_393_0 - 3, iter_393_0)

					var_393_0[iter_393_1] = var_363_36(var_363_38(var_393_5, 24), var_363_38(var_393_4, 16), var_363_38(var_393_3, 8), var_393_2)
				end

				local var_393_6 = arg_393_0[1]
				local var_393_7 = arg_393_0[2]
				local var_393_8 = arg_393_0[3]
				local var_393_9 = arg_393_0[4]

				for iter_393_2 = 0, 15, 4 do
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_9, var_363_35(var_393_7, var_363_37(var_393_8, var_393_9))) + (var_393_1[iter_393_2 + 1] + var_393_0[iter_393_2] + var_393_6), 7) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_9, var_363_35(var_393_7, var_363_37(var_393_8, var_393_9))) + (var_393_1[iter_393_2 + 2] + var_393_0[iter_393_2 + 1] + var_393_6), 12) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_9, var_363_35(var_393_7, var_363_37(var_393_8, var_393_9))) + (var_393_1[iter_393_2 + 3] + var_393_0[iter_393_2 + 2] + var_393_6), 17) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_9, var_363_35(var_393_7, var_363_37(var_393_8, var_393_9))) + (var_393_1[iter_393_2 + 4] + var_393_0[iter_393_2 + 3] + var_393_6), 22) + var_393_7)
				end

				for iter_393_3 = 16, 31, 4 do
					local var_393_10 = 5 * iter_393_3

					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_35(var_393_9, var_363_37(var_393_7, var_393_8))) + (var_393_1[iter_393_3 + 1] + var_393_0[var_363_35(var_393_10 + 1, 15)] + var_393_6), 5) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_35(var_393_9, var_363_37(var_393_7, var_393_8))) + (var_393_1[iter_393_3 + 2] + var_393_0[var_363_35(var_393_10 + 6, 15)] + var_393_6), 9) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_35(var_393_9, var_363_37(var_393_7, var_393_8))) + (var_393_1[iter_393_3 + 3] + var_393_0[var_363_35(var_393_10 - 5, 15)] + var_393_6), 14) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_35(var_393_9, var_363_37(var_393_7, var_393_8))) + (var_393_1[iter_393_3 + 4] + var_393_0[var_363_35(var_393_10, 15)] + var_393_6), 20) + var_393_7)
				end

				for iter_393_4 = 32, 47, 4 do
					local var_393_11 = 3 * iter_393_4

					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_7, var_393_8, var_393_9) + (var_393_1[iter_393_4 + 1] + var_393_0[var_363_35(var_393_11 + 5, 15)] + var_393_6), 4) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_7, var_393_8, var_393_9) + (var_393_1[iter_393_4 + 2] + var_393_0[var_363_35(var_393_11 + 8, 15)] + var_393_6), 11) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_7, var_393_8, var_393_9) + (var_393_1[iter_393_4 + 3] + var_393_0[var_363_35(var_393_11 - 5, 15)] + var_393_6), 16) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_7, var_393_8, var_393_9) + (var_393_1[iter_393_4 + 4] + var_393_0[var_363_35(var_393_11 - 2, 15)] + var_393_6), 23) + var_393_7)
				end

				for iter_393_5 = 48, 63, 4 do
					local var_393_12 = 7 * iter_393_5

					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_36(var_393_7, var_363_42(var_393_9))) + (var_393_1[iter_393_5 + 1] + var_393_0[var_363_35(var_393_12, 15)] + var_393_6), 6) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_36(var_393_7, var_363_42(var_393_9))) + (var_393_1[iter_393_5 + 2] + var_393_0[var_363_35(var_393_12 + 7, 15)] + var_393_6), 10) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_36(var_393_7, var_363_42(var_393_9))) + (var_393_1[iter_393_5 + 3] + var_393_0[var_363_35(var_393_12 - 2, 15)] + var_393_6), 15) + var_393_7)
					var_393_6, var_393_9, var_393_8, var_393_7 = var_393_9, var_393_8, var_393_7, var_363_43(var_363_40(var_363_37(var_393_8, var_363_36(var_393_7, var_363_42(var_393_9))) + (var_393_1[iter_393_5 + 4] + var_393_0[var_363_35(var_393_12 + 5, 15)] + var_393_6), 21) + var_393_7)
				end

				arg_393_0[1], arg_393_0[2], arg_393_0[3], arg_393_0[4] = var_363_43(var_393_6 + arg_393_0[1]), var_363_43(var_393_7 + arg_393_0[2]), var_363_43(var_393_8 + arg_393_0[3]), var_363_43(var_393_9 + arg_393_0[4])
			end
		end

		local function var_363_120(arg_394_0, arg_394_1, arg_394_2, arg_394_3)
			local var_394_0 = var_363_80

			for iter_394_0 = arg_394_2, arg_394_2 + arg_394_3 - 1, 64 do
				for iter_394_1 = 0, 15 do
					iter_394_0 = iter_394_0 + 4

					local var_394_1, var_394_2, var_394_3, var_394_4 = var_363_3(arg_394_1, iter_394_0 - 3, iter_394_0)

					var_394_0[iter_394_1] = var_363_36(var_363_38(var_394_1, 24), var_363_38(var_394_2, 16), var_363_38(var_394_3, 8), var_394_4)
				end

				for iter_394_2 = 16, 79 do
					var_394_0[iter_394_2] = var_363_40(var_363_37(var_394_0[iter_394_2 - 3], var_394_0[iter_394_2 - 8], var_394_0[iter_394_2 - 14], var_394_0[iter_394_2 - 16]), 1)
				end

				local var_394_5 = arg_394_0[1]
				local var_394_6 = arg_394_0[2]
				local var_394_7 = arg_394_0[3]
				local var_394_8 = arg_394_0[4]
				local var_394_9 = arg_394_0[5]

				for iter_394_3 = 0, 19, 5 do
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_8, var_363_35(var_394_6, var_363_37(var_394_8, var_394_7))) + (var_394_0[iter_394_3] + 1518500249 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_8, var_363_35(var_394_6, var_363_37(var_394_8, var_394_7))) + (var_394_0[iter_394_3 + 1] + 1518500249 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_8, var_363_35(var_394_6, var_363_37(var_394_8, var_394_7))) + (var_394_0[iter_394_3 + 2] + 1518500249 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_8, var_363_35(var_394_6, var_363_37(var_394_8, var_394_7))) + (var_394_0[iter_394_3 + 3] + 1518500249 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_8, var_363_35(var_394_6, var_363_37(var_394_8, var_394_7))) + (var_394_0[iter_394_3 + 4] + 1518500249 + var_394_9))
				end

				for iter_394_4 = 20, 39, 5 do
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_4] + 1859775393 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_4 + 1] + 1859775393 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_4 + 2] + 1859775393 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_4 + 3] + 1859775393 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_4 + 4] + 1859775393 + var_394_9))
				end

				for iter_394_5 = 40, 59, 5 do
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_363_35(var_394_8, var_363_37(var_394_6, var_394_7)), var_363_35(var_394_6, var_394_7)) + (var_394_0[iter_394_5] + 2400959708 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_363_35(var_394_8, var_363_37(var_394_6, var_394_7)), var_363_35(var_394_6, var_394_7)) + (var_394_0[iter_394_5 + 1] + 2400959708 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_363_35(var_394_8, var_363_37(var_394_6, var_394_7)), var_363_35(var_394_6, var_394_7)) + (var_394_0[iter_394_5 + 2] + 2400959708 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_363_35(var_394_8, var_363_37(var_394_6, var_394_7)), var_363_35(var_394_6, var_394_7)) + (var_394_0[iter_394_5 + 3] + 2400959708 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_363_35(var_394_8, var_363_37(var_394_6, var_394_7)), var_363_35(var_394_6, var_394_7)) + (var_394_0[iter_394_5 + 4] + 2400959708 + var_394_9))
				end

				for iter_394_6 = 60, 79, 5 do
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_6] + 3395469782 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_6 + 1] + 3395469782 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_6 + 2] + 3395469782 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_6 + 3] + 3395469782 + var_394_9))
					var_394_9, var_394_8, var_394_7, var_394_6, var_394_5 = var_394_8, var_394_7, var_363_41(var_394_6, 2), var_394_5, var_363_43(var_363_40(var_394_5, 5) + var_363_37(var_394_6, var_394_7, var_394_8) + (var_394_0[iter_394_6 + 4] + 3395469782 + var_394_9))
				end

				arg_394_0[1], arg_394_0[2], arg_394_0[3], arg_394_0[4], arg_394_0[5] = var_363_43(var_394_5 + arg_394_0[1]), var_363_43(var_394_6 + arg_394_0[2]), var_363_43(var_394_7 + arg_394_0[3]), var_363_43(var_394_8 + arg_394_0[4]), var_363_43(var_394_9 + arg_394_0[5])
			end
		end
	end

	if var_363_34 == "FFI" and not var_363_25 or var_363_34 == "LJ" then
		if var_363_34 == "FFI" then
			local var_363_121 = var_363_27.typeof("int32_t[?]")

			local function var_363_122()
				return var_363_121(31)
			end
		end

		local function var_363_123(arg_396_0, arg_396_1, arg_396_2, arg_396_3, arg_396_4, arg_396_5)
			local var_396_0 = var_363_60
			local var_396_1 = var_363_61
			local var_396_2 = var_363_39(arg_396_5, 3)

			for iter_396_0 = arg_396_3, arg_396_3 + arg_396_4 - 1, arg_396_5 do
				for iter_396_1 = 1, var_396_2 do
					local var_396_3, var_396_4, var_396_5, var_396_6 = var_363_3(arg_396_2, iter_396_0 + 1, iter_396_0 + 4)

					arg_396_0[iter_396_1] = var_363_37(arg_396_0[iter_396_1], var_363_36(var_363_38(var_396_6, 24), var_363_38(var_396_5, 16), var_363_38(var_396_4, 8), var_396_3))
					iter_396_0 = iter_396_0 + 8

					local var_396_7, var_396_8, var_396_9, var_396_10 = var_363_3(arg_396_2, iter_396_0 - 3, iter_396_0)

					arg_396_1[iter_396_1] = var_363_37(arg_396_1[iter_396_1], var_363_36(var_363_38(var_396_10, 24), var_363_38(var_396_9, 16), var_363_38(var_396_8, 8), var_396_7))
				end

				for iter_396_2 = 1, 24 do
					for iter_396_3 = 1, 5 do
						arg_396_0[25 + iter_396_3] = var_363_37(arg_396_0[iter_396_3], arg_396_0[iter_396_3 + 5], arg_396_0[iter_396_3 + 10], arg_396_0[iter_396_3 + 15], arg_396_0[iter_396_3 + 20])
					end

					for iter_396_4 = 1, 5 do
						arg_396_1[25 + iter_396_4] = var_363_37(arg_396_1[iter_396_4], arg_396_1[iter_396_4 + 5], arg_396_1[iter_396_4 + 10], arg_396_1[iter_396_4 + 15], arg_396_1[iter_396_4 + 20])
					end

					local var_396_11 = var_363_37(arg_396_0[26], var_363_38(arg_396_0[28], 1), var_363_39(arg_396_1[28], 31))
					local var_396_12 = var_363_37(arg_396_1[26], var_363_38(arg_396_1[28], 1), var_363_39(arg_396_0[28], 31))

					arg_396_0[2], arg_396_1[2], arg_396_0[7], arg_396_1[7], arg_396_0[12], arg_396_1[12], arg_396_0[17], arg_396_1[17] = var_363_37(var_363_39(var_363_37(var_396_11, arg_396_0[7]), 20), var_363_38(var_363_37(var_396_12, arg_396_1[7]), 12)), var_363_37(var_363_39(var_363_37(var_396_12, arg_396_1[7]), 20), var_363_38(var_363_37(var_396_11, arg_396_0[7]), 12)), var_363_37(var_363_39(var_363_37(var_396_11, arg_396_0[17]), 19), var_363_38(var_363_37(var_396_12, arg_396_1[17]), 13)), var_363_37(var_363_39(var_363_37(var_396_12, arg_396_1[17]), 19), var_363_38(var_363_37(var_396_11, arg_396_0[17]), 13)), var_363_37(var_363_38(var_363_37(var_396_11, arg_396_0[2]), 1), var_363_39(var_363_37(var_396_12, arg_396_1[2]), 31)), var_363_37(var_363_38(var_363_37(var_396_12, arg_396_1[2]), 1), var_363_39(var_363_37(var_396_11, arg_396_0[2]), 31)), var_363_37(var_363_38(var_363_37(var_396_11, arg_396_0[12]), 10), var_363_39(var_363_37(var_396_12, arg_396_1[12]), 22)), var_363_37(var_363_38(var_363_37(var_396_12, arg_396_1[12]), 10), var_363_39(var_363_37(var_396_11, arg_396_0[12]), 22))

					local var_396_13 = var_363_37(var_396_11, arg_396_0[22])
					local var_396_14 = var_363_37(var_396_12, arg_396_1[22])

					arg_396_0[22], arg_396_1[22] = var_363_37(var_363_38(var_396_13, 2), var_363_39(var_396_14, 30)), var_363_37(var_363_38(var_396_14, 2), var_363_39(var_396_13, 30))

					local var_396_15 = var_363_37(arg_396_0[27], var_363_38(arg_396_0[29], 1), var_363_39(arg_396_1[29], 31))
					local var_396_16 = var_363_37(arg_396_1[27], var_363_38(arg_396_1[29], 1), var_363_39(arg_396_0[29], 31))

					arg_396_0[3], arg_396_1[3], arg_396_0[8], arg_396_1[8], arg_396_0[13], arg_396_1[13], arg_396_0[23], arg_396_1[23] = var_363_37(var_363_39(var_363_37(var_396_15, arg_396_0[13]), 21), var_363_38(var_363_37(var_396_16, arg_396_1[13]), 11)), var_363_37(var_363_39(var_363_37(var_396_16, arg_396_1[13]), 21), var_363_38(var_363_37(var_396_15, arg_396_0[13]), 11)), var_363_37(var_363_39(var_363_37(var_396_15, arg_396_0[23]), 3), var_363_38(var_363_37(var_396_16, arg_396_1[23]), 29)), var_363_37(var_363_39(var_363_37(var_396_16, arg_396_1[23]), 3), var_363_38(var_363_37(var_396_15, arg_396_0[23]), 29)), var_363_37(var_363_38(var_363_37(var_396_15, arg_396_0[8]), 6), var_363_39(var_363_37(var_396_16, arg_396_1[8]), 26)), var_363_37(var_363_38(var_363_37(var_396_16, arg_396_1[8]), 6), var_363_39(var_363_37(var_396_15, arg_396_0[8]), 26)), var_363_37(var_363_39(var_363_37(var_396_15, arg_396_0[3]), 2), var_363_38(var_363_37(var_396_16, arg_396_1[3]), 30)), var_363_37(var_363_39(var_363_37(var_396_16, arg_396_1[3]), 2), var_363_38(var_363_37(var_396_15, arg_396_0[3]), 30))

					local var_396_17, var_396_18 = var_363_37(var_396_15, arg_396_0[18]), var_363_37(var_396_16, arg_396_1[18])

					arg_396_0[18], arg_396_1[18] = var_363_37(var_363_38(var_396_17, 15), var_363_39(var_396_18, 17)), var_363_37(var_363_38(var_396_18, 15), var_363_39(var_396_17, 17))

					local var_396_19 = var_363_37(arg_396_0[28], var_363_38(arg_396_0[30], 1), var_363_39(arg_396_1[30], 31))
					local var_396_20 = var_363_37(arg_396_1[28], var_363_38(arg_396_1[30], 1), var_363_39(arg_396_0[30], 31))

					arg_396_0[4], arg_396_1[4], arg_396_0[9], arg_396_1[9], arg_396_0[19], arg_396_1[19], arg_396_0[24], arg_396_1[24] = var_363_37(var_363_38(var_363_37(var_396_19, arg_396_0[19]), 21), var_363_39(var_363_37(var_396_20, arg_396_1[19]), 11)), var_363_37(var_363_38(var_363_37(var_396_20, arg_396_1[19]), 21), var_363_39(var_363_37(var_396_19, arg_396_0[19]), 11)), var_363_37(var_363_38(var_363_37(var_396_19, arg_396_0[4]), 28), var_363_39(var_363_37(var_396_20, arg_396_1[4]), 4)), var_363_37(var_363_38(var_363_37(var_396_20, arg_396_1[4]), 28), var_363_39(var_363_37(var_396_19, arg_396_0[4]), 4)), var_363_37(var_363_39(var_363_37(var_396_19, arg_396_0[24]), 8), var_363_38(var_363_37(var_396_20, arg_396_1[24]), 24)), var_363_37(var_363_39(var_363_37(var_396_20, arg_396_1[24]), 8), var_363_38(var_363_37(var_396_19, arg_396_0[24]), 24)), var_363_37(var_363_39(var_363_37(var_396_19, arg_396_0[9]), 9), var_363_38(var_363_37(var_396_20, arg_396_1[9]), 23)), var_363_37(var_363_39(var_363_37(var_396_20, arg_396_1[9]), 9), var_363_38(var_363_37(var_396_19, arg_396_0[9]), 23))

					local var_396_21, var_396_22 = var_363_37(var_396_19, arg_396_0[14]), var_363_37(var_396_20, arg_396_1[14])

					arg_396_0[14], arg_396_1[14] = var_363_37(var_363_38(var_396_21, 25), var_363_39(var_396_22, 7)), var_363_37(var_363_38(var_396_22, 25), var_363_39(var_396_21, 7))

					local var_396_23 = var_363_37(arg_396_0[29], var_363_38(arg_396_0[26], 1), var_363_39(arg_396_1[26], 31))
					local var_396_24 = var_363_37(arg_396_1[29], var_363_38(arg_396_1[26], 1), var_363_39(arg_396_0[26], 31))

					arg_396_0[5], arg_396_1[5], arg_396_0[15], arg_396_1[15], arg_396_0[20], arg_396_1[20], arg_396_0[25], arg_396_1[25] = var_363_37(var_363_38(var_363_37(var_396_23, arg_396_0[25]), 14), var_363_39(var_363_37(var_396_24, arg_396_1[25]), 18)), var_363_37(var_363_38(var_363_37(var_396_24, arg_396_1[25]), 14), var_363_39(var_363_37(var_396_23, arg_396_0[25]), 18)), var_363_37(var_363_38(var_363_37(var_396_23, arg_396_0[20]), 8), var_363_39(var_363_37(var_396_24, arg_396_1[20]), 24)), var_363_37(var_363_38(var_363_37(var_396_24, arg_396_1[20]), 8), var_363_39(var_363_37(var_396_23, arg_396_0[20]), 24)), var_363_37(var_363_38(var_363_37(var_396_23, arg_396_0[5]), 27), var_363_39(var_363_37(var_396_24, arg_396_1[5]), 5)), var_363_37(var_363_38(var_363_37(var_396_24, arg_396_1[5]), 27), var_363_39(var_363_37(var_396_23, arg_396_0[5]), 5)), var_363_37(var_363_39(var_363_37(var_396_23, arg_396_0[15]), 25), var_363_38(var_363_37(var_396_24, arg_396_1[15]), 7)), var_363_37(var_363_39(var_363_37(var_396_24, arg_396_1[15]), 25), var_363_38(var_363_37(var_396_23, arg_396_0[15]), 7))

					local var_396_25, var_396_26 = var_363_37(var_396_23, arg_396_0[10]), var_363_37(var_396_24, arg_396_1[10])

					arg_396_0[10], arg_396_1[10] = var_363_37(var_363_38(var_396_25, 20), var_363_39(var_396_26, 12)), var_363_37(var_363_38(var_396_26, 20), var_363_39(var_396_25, 12))

					local var_396_27 = var_363_37(arg_396_0[30], var_363_38(arg_396_0[27], 1), var_363_39(arg_396_1[27], 31))
					local var_396_28 = var_363_37(arg_396_1[30], var_363_38(arg_396_1[27], 1), var_363_39(arg_396_0[27], 31))

					arg_396_0[6], arg_396_1[6], arg_396_0[11], arg_396_1[11], arg_396_0[16], arg_396_1[16], arg_396_0[21], arg_396_1[21] = var_363_37(var_363_38(var_363_37(var_396_27, arg_396_0[11]), 3), var_363_39(var_363_37(var_396_28, arg_396_1[11]), 29)), var_363_37(var_363_38(var_363_37(var_396_28, arg_396_1[11]), 3), var_363_39(var_363_37(var_396_27, arg_396_0[11]), 29)), var_363_37(var_363_38(var_363_37(var_396_27, arg_396_0[21]), 18), var_363_39(var_363_37(var_396_28, arg_396_1[21]), 14)), var_363_37(var_363_38(var_363_37(var_396_28, arg_396_1[21]), 18), var_363_39(var_363_37(var_396_27, arg_396_0[21]), 14)), var_363_37(var_363_39(var_363_37(var_396_27, arg_396_0[6]), 28), var_363_38(var_363_37(var_396_28, arg_396_1[6]), 4)), var_363_37(var_363_39(var_363_37(var_396_28, arg_396_1[6]), 28), var_363_38(var_363_37(var_396_27, arg_396_0[6]), 4)), var_363_37(var_363_39(var_363_37(var_396_27, arg_396_0[16]), 23), var_363_38(var_363_37(var_396_28, arg_396_1[16]), 9)), var_363_37(var_363_39(var_363_37(var_396_28, arg_396_1[16]), 23), var_363_38(var_363_37(var_396_27, arg_396_0[16]), 9))
					arg_396_0[1], arg_396_1[1] = var_363_37(var_396_27, arg_396_0[1]), var_363_37(var_396_28, arg_396_1[1])
					arg_396_0[1], arg_396_0[2], arg_396_0[3], arg_396_0[4], arg_396_0[5] = var_363_37(arg_396_0[1], var_363_35(var_363_42(arg_396_0[2]), arg_396_0[3]), var_396_0[iter_396_2]), var_363_37(arg_396_0[2], var_363_35(var_363_42(arg_396_0[3]), arg_396_0[4])), var_363_37(arg_396_0[3], var_363_35(var_363_42(arg_396_0[4]), arg_396_0[5])), var_363_37(arg_396_0[4], var_363_35(var_363_42(arg_396_0[5]), arg_396_0[1])), var_363_37(arg_396_0[5], var_363_35(var_363_42(arg_396_0[1]), arg_396_0[2]))
					arg_396_0[6], arg_396_0[7], arg_396_0[8], arg_396_0[9], arg_396_0[10] = var_363_37(arg_396_0[9], var_363_35(var_363_42(arg_396_0[10]), arg_396_0[6])), var_363_37(arg_396_0[10], var_363_35(var_363_42(arg_396_0[6]), arg_396_0[7])), var_363_37(arg_396_0[6], var_363_35(var_363_42(arg_396_0[7]), arg_396_0[8])), var_363_37(arg_396_0[7], var_363_35(var_363_42(arg_396_0[8]), arg_396_0[9])), var_363_37(arg_396_0[8], var_363_35(var_363_42(arg_396_0[9]), arg_396_0[10]))
					arg_396_0[11], arg_396_0[12], arg_396_0[13], arg_396_0[14], arg_396_0[15] = var_363_37(arg_396_0[12], var_363_35(var_363_42(arg_396_0[13]), arg_396_0[14])), var_363_37(arg_396_0[13], var_363_35(var_363_42(arg_396_0[14]), arg_396_0[15])), var_363_37(arg_396_0[14], var_363_35(var_363_42(arg_396_0[15]), arg_396_0[11])), var_363_37(arg_396_0[15], var_363_35(var_363_42(arg_396_0[11]), arg_396_0[12])), var_363_37(arg_396_0[11], var_363_35(var_363_42(arg_396_0[12]), arg_396_0[13]))
					arg_396_0[16], arg_396_0[17], arg_396_0[18], arg_396_0[19], arg_396_0[20] = var_363_37(arg_396_0[20], var_363_35(var_363_42(arg_396_0[16]), arg_396_0[17])), var_363_37(arg_396_0[16], var_363_35(var_363_42(arg_396_0[17]), arg_396_0[18])), var_363_37(arg_396_0[17], var_363_35(var_363_42(arg_396_0[18]), arg_396_0[19])), var_363_37(arg_396_0[18], var_363_35(var_363_42(arg_396_0[19]), arg_396_0[20])), var_363_37(arg_396_0[19], var_363_35(var_363_42(arg_396_0[20]), arg_396_0[16]))
					arg_396_0[21], arg_396_0[22], arg_396_0[23], arg_396_0[24], arg_396_0[25] = var_363_37(arg_396_0[23], var_363_35(var_363_42(arg_396_0[24]), arg_396_0[25])), var_363_37(arg_396_0[24], var_363_35(var_363_42(arg_396_0[25]), arg_396_0[21])), var_363_37(arg_396_0[25], var_363_35(var_363_42(arg_396_0[21]), arg_396_0[22])), var_363_37(arg_396_0[21], var_363_35(var_363_42(arg_396_0[22]), arg_396_0[23])), var_363_37(arg_396_0[22], var_363_35(var_363_42(arg_396_0[23]), arg_396_0[24]))
					arg_396_1[1], arg_396_1[2], arg_396_1[3], arg_396_1[4], arg_396_1[5] = var_363_37(arg_396_1[1], var_363_35(var_363_42(arg_396_1[2]), arg_396_1[3]), var_396_1[iter_396_2]), var_363_37(arg_396_1[2], var_363_35(var_363_42(arg_396_1[3]), arg_396_1[4])), var_363_37(arg_396_1[3], var_363_35(var_363_42(arg_396_1[4]), arg_396_1[5])), var_363_37(arg_396_1[4], var_363_35(var_363_42(arg_396_1[5]), arg_396_1[1])), var_363_37(arg_396_1[5], var_363_35(var_363_42(arg_396_1[1]), arg_396_1[2]))
					arg_396_1[6], arg_396_1[7], arg_396_1[8], arg_396_1[9], arg_396_1[10] = var_363_37(arg_396_1[9], var_363_35(var_363_42(arg_396_1[10]), arg_396_1[6])), var_363_37(arg_396_1[10], var_363_35(var_363_42(arg_396_1[6]), arg_396_1[7])), var_363_37(arg_396_1[6], var_363_35(var_363_42(arg_396_1[7]), arg_396_1[8])), var_363_37(arg_396_1[7], var_363_35(var_363_42(arg_396_1[8]), arg_396_1[9])), var_363_37(arg_396_1[8], var_363_35(var_363_42(arg_396_1[9]), arg_396_1[10]))
					arg_396_1[11], arg_396_1[12], arg_396_1[13], arg_396_1[14], arg_396_1[15] = var_363_37(arg_396_1[12], var_363_35(var_363_42(arg_396_1[13]), arg_396_1[14])), var_363_37(arg_396_1[13], var_363_35(var_363_42(arg_396_1[14]), arg_396_1[15])), var_363_37(arg_396_1[14], var_363_35(var_363_42(arg_396_1[15]), arg_396_1[11])), var_363_37(arg_396_1[15], var_363_35(var_363_42(arg_396_1[11]), arg_396_1[12])), var_363_37(arg_396_1[11], var_363_35(var_363_42(arg_396_1[12]), arg_396_1[13]))
					arg_396_1[16], arg_396_1[17], arg_396_1[18], arg_396_1[19], arg_396_1[20] = var_363_37(arg_396_1[20], var_363_35(var_363_42(arg_396_1[16]), arg_396_1[17])), var_363_37(arg_396_1[16], var_363_35(var_363_42(arg_396_1[17]), arg_396_1[18])), var_363_37(arg_396_1[17], var_363_35(var_363_42(arg_396_1[18]), arg_396_1[19])), var_363_37(arg_396_1[18], var_363_35(var_363_42(arg_396_1[19]), arg_396_1[20])), var_363_37(arg_396_1[19], var_363_35(var_363_42(arg_396_1[20]), arg_396_1[16]))
					arg_396_1[21], arg_396_1[22], arg_396_1[23], arg_396_1[24], arg_396_1[25] = var_363_37(arg_396_1[23], var_363_35(var_363_42(arg_396_1[24]), arg_396_1[25])), var_363_37(arg_396_1[24], var_363_35(var_363_42(arg_396_1[25]), arg_396_1[21])), var_363_37(arg_396_1[25], var_363_35(var_363_42(arg_396_1[21]), arg_396_1[22])), var_363_37(arg_396_1[21], var_363_35(var_363_42(arg_396_1[22]), arg_396_1[23])), var_363_37(arg_396_1[22], var_363_35(var_363_42(arg_396_1[23]), arg_396_1[24]))
				end
			end
		end
	end

	if var_363_34 == "LJ" then
		function var_363_48(arg_397_0, arg_397_1, arg_397_2, arg_397_3)
			local var_397_0 = var_363_70
			local var_397_1 = var_363_57

			for iter_397_0 = arg_397_2, arg_397_2 + arg_397_3 - 1, 64 do
				for iter_397_1 = 1, 16 do
					iter_397_0 = iter_397_0 + 4

					local var_397_2, var_397_3, var_397_4, var_397_5 = var_363_3(arg_397_1, iter_397_0 - 3, iter_397_0)

					var_397_0[iter_397_1] = var_363_36(var_363_38(var_397_2, 24), var_363_38(var_397_3, 16), var_363_38(var_397_4, 8), var_397_5)
				end

				for iter_397_2 = 17, 64 do
					local var_397_6 = var_397_0[iter_397_2 - 15]
					local var_397_7 = var_397_0[iter_397_2 - 2]

					var_397_0[iter_397_2] = var_363_43(var_363_43(var_363_37(var_363_41(var_397_6, 7), var_363_40(var_397_6, 14), var_363_39(var_397_6, 3)) + var_363_37(var_363_40(var_397_7, 15), var_363_40(var_397_7, 13), var_363_39(var_397_7, 10))) + var_363_43(var_397_0[iter_397_2 - 7] + var_397_0[iter_397_2 - 16]))
				end

				local var_397_8 = arg_397_0[1]
				local var_397_9 = arg_397_0[2]
				local var_397_10 = arg_397_0[3]
				local var_397_11 = arg_397_0[4]
				local var_397_12 = arg_397_0[5]
				local var_397_13 = arg_397_0[6]
				local var_397_14 = arg_397_0[7]
				local var_397_15 = arg_397_0[8]

				for iter_397_3 = 1, 64, 8 do
					local var_397_16 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3] + var_397_0[iter_397_3] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_16)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_16)

					local var_397_17 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 1] + var_397_0[iter_397_3 + 1] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_17)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_17)

					local var_397_18 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 2] + var_397_0[iter_397_3 + 2] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_18)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_18)

					local var_397_19 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 3] + var_397_0[iter_397_3 + 3] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_19)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_19)

					local var_397_20 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 4] + var_397_0[iter_397_3 + 4] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_20)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_20)

					local var_397_21 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 5] + var_397_0[iter_397_3 + 5] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_21)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_21)

					local var_397_22 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 6] + var_397_0[iter_397_3 + 6] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_22)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_22)

					local var_397_23 = var_363_43(var_363_37(var_363_41(var_397_12, 6), var_363_41(var_397_12, 11), var_363_40(var_397_12, 7)) + var_363_37(var_397_14, var_363_35(var_397_12, var_363_37(var_397_13, var_397_14))) + (var_397_1[iter_397_3 + 7] + var_397_0[iter_397_3 + 7] + var_397_15))

					var_397_15, var_397_14, var_397_13, var_397_12 = var_397_14, var_397_13, var_397_12, var_363_43(var_397_11 + var_397_23)
					var_397_11, var_397_10, var_397_9, var_397_8 = var_397_10, var_397_9, var_397_8, var_363_43(var_363_37(var_363_35(var_397_8, var_363_37(var_397_9, var_397_10)), var_363_35(var_397_9, var_397_10)) + var_363_37(var_363_41(var_397_8, 2), var_363_41(var_397_8, 13), var_363_40(var_397_8, 10)) + var_397_23)
				end

				arg_397_0[1], arg_397_0[2], arg_397_0[3], arg_397_0[4] = var_363_43(var_397_8 + arg_397_0[1]), var_363_43(var_397_9 + arg_397_0[2]), var_363_43(var_397_10 + arg_397_0[3]), var_363_43(var_397_11 + arg_397_0[4])
				arg_397_0[5], arg_397_0[6], arg_397_0[7], arg_397_0[8] = var_363_43(var_397_12 + arg_397_0[5]), var_363_43(var_397_13 + arg_397_0[6]), var_363_43(var_397_14 + arg_397_0[7]), var_363_43(var_397_15 + arg_397_0[8])
			end
		end

		local function var_363_124(arg_398_0, arg_398_1, arg_398_2, arg_398_3, arg_398_4, arg_398_5, arg_398_6, arg_398_7)
			local var_398_0 = arg_398_0 % 4294967296 + arg_398_2 % 4294967296 + arg_398_4 % 4294967296 + arg_398_6 % 4294967296
			local var_398_1 = arg_398_1 + arg_398_3 + arg_398_5 + arg_398_7
			local var_398_2 = var_363_43(var_398_0)
			local var_398_3 = var_363_43(var_398_1 + var_363_10(var_398_0 / 4294967296))

			return var_398_2, var_398_3
		end

		if var_363_26 == "x86" then
			function var_363_49(arg_399_0, arg_399_1, arg_399_2, arg_399_3, arg_399_4)
				local var_399_0 = var_363_70
				local var_399_1 = var_363_56
				local var_399_2 = var_363_57

				for iter_399_0 = arg_399_3, arg_399_3 + arg_399_4 - 1, 128 do
					for iter_399_1 = 1, 32 do
						iter_399_0 = iter_399_0 + 4

						local var_399_3, var_399_4, var_399_5, var_399_6 = var_363_3(arg_399_2, iter_399_0 - 3, iter_399_0)

						var_399_0[iter_399_1] = var_363_36(var_363_38(var_399_3, 24), var_363_38(var_399_4, 16), var_363_38(var_399_5, 8), var_399_6)
					end

					for iter_399_2 = 34, 160, 2 do
						local var_399_7 = var_399_0[iter_399_2 - 30]
						local var_399_8 = var_399_0[iter_399_2 - 31]
						local var_399_9 = var_363_37(var_363_36(var_363_39(var_399_7, 1), var_363_38(var_399_8, 31)), var_363_36(var_363_39(var_399_7, 8), var_363_38(var_399_8, 24)), var_363_36(var_363_39(var_399_7, 7), var_363_38(var_399_8, 25)))
						local var_399_10 = var_363_37(var_363_36(var_363_39(var_399_8, 1), var_363_38(var_399_7, 31)), var_363_36(var_363_39(var_399_8, 8), var_363_38(var_399_7, 24)), var_363_39(var_399_8, 7))
						local var_399_11 = var_399_0[iter_399_2 - 4]
						local var_399_12 = var_399_0[iter_399_2 - 5]
						local var_399_13 = var_363_37(var_363_36(var_363_39(var_399_11, 19), var_363_38(var_399_12, 13)), var_363_36(var_363_38(var_399_11, 3), var_363_39(var_399_12, 29)), var_363_36(var_363_39(var_399_11, 6), var_363_38(var_399_12, 26)))
						local var_399_14 = var_363_37(var_363_36(var_363_39(var_399_12, 19), var_363_38(var_399_11, 13)), var_363_36(var_363_38(var_399_12, 3), var_363_39(var_399_11, 29)), var_363_39(var_399_12, 6))

						var_399_0[iter_399_2], var_399_0[iter_399_2 - 1] = var_363_124(var_399_9, var_399_10, var_399_13, var_399_14, var_399_0[iter_399_2 - 14], var_399_0[iter_399_2 - 15], var_399_0[iter_399_2 - 32], var_399_0[iter_399_2 - 33])
					end

					local var_399_15 = arg_399_0[1]
					local var_399_16 = arg_399_0[2]
					local var_399_17 = arg_399_0[3]
					local var_399_18 = arg_399_0[4]
					local var_399_19 = arg_399_0[5]
					local var_399_20 = arg_399_0[6]
					local var_399_21 = arg_399_0[7]
					local var_399_22 = arg_399_0[8]
					local var_399_23 = arg_399_1[1]
					local var_399_24 = arg_399_1[2]
					local var_399_25 = arg_399_1[3]
					local var_399_26 = arg_399_1[4]
					local var_399_27 = arg_399_1[5]
					local var_399_28 = arg_399_1[6]
					local var_399_29 = arg_399_1[7]
					local var_399_30 = arg_399_1[8]
					local var_399_31 = 0

					for iter_399_3 = 1, 80 do
						local var_399_32 = var_363_37(var_399_21, var_363_35(var_399_19, var_363_37(var_399_20, var_399_21)))
						local var_399_33 = var_363_37(var_399_29, var_363_35(var_399_27, var_363_37(var_399_28, var_399_29)))
						local var_399_34 = var_363_37(var_363_36(var_363_39(var_399_19, 14), var_363_38(var_399_27, 18)), var_363_36(var_363_39(var_399_19, 18), var_363_38(var_399_27, 14)), var_363_36(var_363_38(var_399_19, 23), var_363_39(var_399_27, 9)))
						local var_399_35 = var_363_37(var_363_36(var_363_39(var_399_27, 14), var_363_38(var_399_19, 18)), var_363_36(var_363_39(var_399_27, 18), var_363_38(var_399_19, 14)), var_363_36(var_363_38(var_399_27, 23), var_363_39(var_399_19, 9)))
						local var_399_36 = var_399_34 % 4294967296 + var_399_32 % 4294967296 + var_399_22 % 4294967296 + var_399_1[iter_399_3] + var_399_0[2 * iter_399_3] % 4294967296
						local var_399_37 = var_363_43(var_399_36)
						local var_399_38 = var_363_43(var_399_35 + var_399_33 + var_399_30 + var_399_2[iter_399_3] + var_399_0[2 * iter_399_3 - 1] + var_363_10(var_399_36 / 4294967296))

						var_399_31 = var_399_31 + var_399_31
						var_399_22, var_399_30, var_399_21, var_399_29, var_399_20, var_399_28 = var_363_36(var_399_31, var_399_21), var_363_36(var_399_31, var_399_29), var_363_36(var_399_31, var_399_20), var_363_36(var_399_31, var_399_28), var_363_36(var_399_31, var_399_19), var_363_36(var_399_31, var_399_27)

						local var_399_39 = var_399_37 % 4294967296 + var_399_18 % 4294967296

						var_399_19, var_399_27 = var_363_43(var_399_39), var_363_43(var_399_38 + var_399_26 + var_363_10(var_399_39 / 4294967296))
						var_399_18, var_399_26, var_399_17, var_399_25, var_399_16, var_399_24 = var_363_36(var_399_31, var_399_17), var_363_36(var_399_31, var_399_25), var_363_36(var_399_31, var_399_16), var_363_36(var_399_31, var_399_24), var_363_36(var_399_31, var_399_15), var_363_36(var_399_31, var_399_23)

						local var_399_40 = var_363_37(var_363_36(var_363_39(var_399_16, 28), var_363_38(var_399_24, 4)), var_363_36(var_363_38(var_399_16, 30), var_363_39(var_399_24, 2)), var_363_36(var_363_38(var_399_16, 25), var_363_39(var_399_24, 7)))
						local var_399_41 = var_363_37(var_363_36(var_363_39(var_399_24, 28), var_363_38(var_399_16, 4)), var_363_36(var_363_38(var_399_24, 30), var_363_39(var_399_16, 2)), var_363_36(var_363_38(var_399_24, 25), var_363_39(var_399_16, 7)))
						local var_399_42 = var_363_36(var_363_35(var_399_18, var_399_17), var_363_35(var_399_16, var_363_37(var_399_18, var_399_17)))
						local var_399_43 = var_363_36(var_363_35(var_399_26, var_399_25), var_363_35(var_399_24, var_363_37(var_399_26, var_399_25)))
						local var_399_44 = var_399_37 % 4294967296 + var_399_42 % 4294967296 + var_399_40 % 4294967296

						var_399_15, var_399_23 = var_363_43(var_399_44), var_363_43(var_399_38 + var_399_43 + var_399_41 + var_363_10(var_399_44 / 4294967296))
					end

					arg_399_0[1], arg_399_1[1] = var_363_124(arg_399_0[1], arg_399_1[1], var_399_15, var_399_23, 0, 0, 0, 0)
					arg_399_0[2], arg_399_1[2] = var_363_124(arg_399_0[2], arg_399_1[2], var_399_16, var_399_24, 0, 0, 0, 0)
					arg_399_0[3], arg_399_1[3] = var_363_124(arg_399_0[3], arg_399_1[3], var_399_17, var_399_25, 0, 0, 0, 0)
					arg_399_0[4], arg_399_1[4] = var_363_124(arg_399_0[4], arg_399_1[4], var_399_18, var_399_26, 0, 0, 0, 0)
					arg_399_0[5], arg_399_1[5] = var_363_124(arg_399_0[5], arg_399_1[5], var_399_19, var_399_27, 0, 0, 0, 0)
					arg_399_0[6], arg_399_1[6] = var_363_124(arg_399_0[6], arg_399_1[6], var_399_20, var_399_28, 0, 0, 0, 0)
					arg_399_0[7], arg_399_1[7] = var_363_124(arg_399_0[7], arg_399_1[7], var_399_21, var_399_29, 0, 0, 0, 0)
					arg_399_0[8], arg_399_1[8] = var_363_124(arg_399_0[8], arg_399_1[8], var_399_22, var_399_30, 0, 0, 0, 0)
				end
			end
		else
			function var_363_49(arg_400_0, arg_400_1, arg_400_2, arg_400_3, arg_400_4)
				local var_400_0 = var_363_70
				local var_400_1 = var_363_56
				local var_400_2 = var_363_57

				for iter_400_0 = arg_400_3, arg_400_3 + arg_400_4 - 1, 128 do
					for iter_400_1 = 1, 32 do
						iter_400_0 = iter_400_0 + 4

						local var_400_3, var_400_4, var_400_5, var_400_6 = var_363_3(arg_400_2, iter_400_0 - 3, iter_400_0)

						var_400_0[iter_400_1] = var_363_36(var_363_38(var_400_3, 24), var_363_38(var_400_4, 16), var_363_38(var_400_5, 8), var_400_6)
					end

					for iter_400_2 = 34, 160, 2 do
						local var_400_7 = var_400_0[iter_400_2 - 30]
						local var_400_8 = var_400_0[iter_400_2 - 31]
						local var_400_9 = var_363_37(var_363_36(var_363_39(var_400_7, 1), var_363_38(var_400_8, 31)), var_363_36(var_363_39(var_400_7, 8), var_363_38(var_400_8, 24)), var_363_36(var_363_39(var_400_7, 7), var_363_38(var_400_8, 25)))
						local var_400_10 = var_363_37(var_363_36(var_363_39(var_400_8, 1), var_363_38(var_400_7, 31)), var_363_36(var_363_39(var_400_8, 8), var_363_38(var_400_7, 24)), var_363_39(var_400_8, 7))
						local var_400_11 = var_400_0[iter_400_2 - 4]
						local var_400_12 = var_400_0[iter_400_2 - 5]
						local var_400_13 = var_363_37(var_363_36(var_363_39(var_400_11, 19), var_363_38(var_400_12, 13)), var_363_36(var_363_38(var_400_11, 3), var_363_39(var_400_12, 29)), var_363_36(var_363_39(var_400_11, 6), var_363_38(var_400_12, 26)))
						local var_400_14 = var_363_37(var_363_36(var_363_39(var_400_12, 19), var_363_38(var_400_11, 13)), var_363_36(var_363_38(var_400_12, 3), var_363_39(var_400_11, 29)), var_363_39(var_400_12, 6))

						var_400_0[iter_400_2], var_400_0[iter_400_2 - 1] = var_363_124(var_400_9, var_400_10, var_400_13, var_400_14, var_400_0[iter_400_2 - 14], var_400_0[iter_400_2 - 15], var_400_0[iter_400_2 - 32], var_400_0[iter_400_2 - 33])
					end

					local var_400_15 = arg_400_0[1]
					local var_400_16 = arg_400_0[2]
					local var_400_17 = arg_400_0[3]
					local var_400_18 = arg_400_0[4]
					local var_400_19 = arg_400_0[5]
					local var_400_20 = arg_400_0[6]
					local var_400_21 = arg_400_0[7]
					local var_400_22 = arg_400_0[8]
					local var_400_23 = arg_400_1[1]
					local var_400_24 = arg_400_1[2]
					local var_400_25 = arg_400_1[3]
					local var_400_26 = arg_400_1[4]
					local var_400_27 = arg_400_1[5]
					local var_400_28 = arg_400_1[6]
					local var_400_29 = arg_400_1[7]
					local var_400_30 = arg_400_1[8]

					for iter_400_3 = 1, 80 do
						local var_400_31 = var_363_37(var_400_21, var_363_35(var_400_19, var_363_37(var_400_20, var_400_21)))
						local var_400_32 = var_363_37(var_400_29, var_363_35(var_400_27, var_363_37(var_400_28, var_400_29)))
						local var_400_33 = var_363_37(var_363_36(var_363_39(var_400_19, 14), var_363_38(var_400_27, 18)), var_363_36(var_363_39(var_400_19, 18), var_363_38(var_400_27, 14)), var_363_36(var_363_38(var_400_19, 23), var_363_39(var_400_27, 9)))
						local var_400_34 = var_363_37(var_363_36(var_363_39(var_400_27, 14), var_363_38(var_400_19, 18)), var_363_36(var_363_39(var_400_27, 18), var_363_38(var_400_19, 14)), var_363_36(var_363_38(var_400_27, 23), var_363_39(var_400_19, 9)))
						local var_400_35 = var_400_33 % 4294967296 + var_400_31 % 4294967296 + var_400_22 % 4294967296 + var_400_1[iter_400_3] + var_400_0[2 * iter_400_3] % 4294967296
						local var_400_36 = var_363_43(var_400_35)
						local var_400_37 = var_363_43(var_400_34 + var_400_32 + var_400_30 + var_400_2[iter_400_3] + var_400_0[2 * iter_400_3 - 1] + var_363_10(var_400_35 / 4294967296))

						var_400_22, var_400_30, var_400_21, var_400_29, var_400_20, var_400_28 = var_400_21, var_400_29, var_400_20, var_400_28, var_400_19, var_400_27

						local var_400_38 = var_400_36 % 4294967296 + var_400_18 % 4294967296

						var_400_19, var_400_27 = var_363_43(var_400_38), var_363_43(var_400_37 + var_400_26 + var_363_10(var_400_38 / 4294967296))
						var_400_18, var_400_26, var_400_17, var_400_25, var_400_16, var_400_24 = var_400_17, var_400_25, var_400_16, var_400_24, var_400_15, var_400_23

						local var_400_39 = var_363_37(var_363_36(var_363_39(var_400_16, 28), var_363_38(var_400_24, 4)), var_363_36(var_363_38(var_400_16, 30), var_363_39(var_400_24, 2)), var_363_36(var_363_38(var_400_16, 25), var_363_39(var_400_24, 7)))
						local var_400_40 = var_363_37(var_363_36(var_363_39(var_400_24, 28), var_363_38(var_400_16, 4)), var_363_36(var_363_38(var_400_24, 30), var_363_39(var_400_16, 2)), var_363_36(var_363_38(var_400_24, 25), var_363_39(var_400_16, 7)))
						local var_400_41 = var_363_36(var_363_35(var_400_18, var_400_17), var_363_35(var_400_16, var_363_37(var_400_18, var_400_17)))
						local var_400_42 = var_363_36(var_363_35(var_400_26, var_400_25), var_363_35(var_400_24, var_363_37(var_400_26, var_400_25)))
						local var_400_43 = var_400_36 % 4294967296 + var_400_39 % 4294967296 + var_400_41 % 4294967296

						var_400_15, var_400_23 = var_363_43(var_400_43), var_363_43(var_400_37 + var_400_40 + var_400_42 + var_363_10(var_400_43 / 4294967296))
					end

					arg_400_0[1], arg_400_1[1] = var_363_124(arg_400_0[1], arg_400_1[1], var_400_15, var_400_23, 0, 0, 0, 0)
					arg_400_0[2], arg_400_1[2] = var_363_124(arg_400_0[2], arg_400_1[2], var_400_16, var_400_24, 0, 0, 0, 0)
					arg_400_0[3], arg_400_1[3] = var_363_124(arg_400_0[3], arg_400_1[3], var_400_17, var_400_25, 0, 0, 0, 0)
					arg_400_0[4], arg_400_1[4] = var_363_124(arg_400_0[4], arg_400_1[4], var_400_18, var_400_26, 0, 0, 0, 0)
					arg_400_0[5], arg_400_1[5] = var_363_124(arg_400_0[5], arg_400_1[5], var_400_19, var_400_27, 0, 0, 0, 0)
					arg_400_0[6], arg_400_1[6] = var_363_124(arg_400_0[6], arg_400_1[6], var_400_20, var_400_28, 0, 0, 0, 0)
					arg_400_0[7], arg_400_1[7] = var_363_124(arg_400_0[7], arg_400_1[7], var_400_21, var_400_29, 0, 0, 0, 0)
					arg_400_0[8], arg_400_1[8] = var_363_124(arg_400_0[8], arg_400_1[8], var_400_22, var_400_30, 0, 0, 0, 0)
				end
			end
		end

		local function var_363_125(arg_401_0, arg_401_1, arg_401_2, arg_401_3)
			local var_401_0 = var_363_70
			local var_401_1 = var_363_65

			for iter_401_0 = arg_401_2, arg_401_2 + arg_401_3 - 1, 64 do
				for iter_401_1 = 1, 16 do
					iter_401_0 = iter_401_0 + 4

					local var_401_2, var_401_3, var_401_4, var_401_5 = var_363_3(arg_401_1, iter_401_0 - 3, iter_401_0)

					var_401_0[iter_401_1] = var_363_36(var_363_38(var_401_5, 24), var_363_38(var_401_4, 16), var_363_38(var_401_3, 8), var_401_2)
				end

				local var_401_6 = arg_401_0[1]
				local var_401_7 = arg_401_0[2]
				local var_401_8 = arg_401_0[3]
				local var_401_9 = arg_401_0[4]

				for iter_401_2 = 1, 16, 4 do
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_9, var_363_35(var_401_7, var_363_37(var_401_8, var_401_9))) + (var_401_1[iter_401_2] + var_401_0[iter_401_2] + var_401_6), 7) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_9, var_363_35(var_401_7, var_363_37(var_401_8, var_401_9))) + (var_401_1[iter_401_2 + 1] + var_401_0[iter_401_2 + 1] + var_401_6), 12) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_9, var_363_35(var_401_7, var_363_37(var_401_8, var_401_9))) + (var_401_1[iter_401_2 + 2] + var_401_0[iter_401_2 + 2] + var_401_6), 17) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_9, var_363_35(var_401_7, var_363_37(var_401_8, var_401_9))) + (var_401_1[iter_401_2 + 3] + var_401_0[iter_401_2 + 3] + var_401_6), 22) + var_401_7)
				end

				for iter_401_3 = 17, 32, 4 do
					local var_401_10 = 5 * iter_401_3 - 4

					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_35(var_401_9, var_363_37(var_401_7, var_401_8))) + (var_401_1[iter_401_3] + var_401_0[var_363_35(var_401_10, 15) + 1] + var_401_6), 5) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_35(var_401_9, var_363_37(var_401_7, var_401_8))) + (var_401_1[iter_401_3 + 1] + var_401_0[var_363_35(var_401_10 + 5, 15) + 1] + var_401_6), 9) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_35(var_401_9, var_363_37(var_401_7, var_401_8))) + (var_401_1[iter_401_3 + 2] + var_401_0[var_363_35(var_401_10 + 10, 15) + 1] + var_401_6), 14) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_35(var_401_9, var_363_37(var_401_7, var_401_8))) + (var_401_1[iter_401_3 + 3] + var_401_0[var_363_35(var_401_10 - 1, 15) + 1] + var_401_6), 20) + var_401_7)
				end

				for iter_401_4 = 33, 48, 4 do
					local var_401_11 = 3 * iter_401_4 + 2

					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_7, var_401_8, var_401_9) + (var_401_1[iter_401_4] + var_401_0[var_363_35(var_401_11, 15) + 1] + var_401_6), 4) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_7, var_401_8, var_401_9) + (var_401_1[iter_401_4 + 1] + var_401_0[var_363_35(var_401_11 + 3, 15) + 1] + var_401_6), 11) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_7, var_401_8, var_401_9) + (var_401_1[iter_401_4 + 2] + var_401_0[var_363_35(var_401_11 + 6, 15) + 1] + var_401_6), 16) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_7, var_401_8, var_401_9) + (var_401_1[iter_401_4 + 3] + var_401_0[var_363_35(var_401_11 - 7, 15) + 1] + var_401_6), 23) + var_401_7)
				end

				for iter_401_5 = 49, 64, 4 do
					local var_401_12 = iter_401_5 * 7

					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_36(var_401_7, var_363_42(var_401_9))) + (var_401_1[iter_401_5] + var_401_0[var_363_35(var_401_12 - 7, 15) + 1] + var_401_6), 6) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_36(var_401_7, var_363_42(var_401_9))) + (var_401_1[iter_401_5 + 1] + var_401_0[var_363_35(var_401_12, 15) + 1] + var_401_6), 10) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_36(var_401_7, var_363_42(var_401_9))) + (var_401_1[iter_401_5 + 2] + var_401_0[var_363_35(var_401_12 + 7, 15) + 1] + var_401_6), 15) + var_401_7)
					var_401_6, var_401_9, var_401_8, var_401_7 = var_401_9, var_401_8, var_401_7, var_363_43(var_363_40(var_363_37(var_401_8, var_363_36(var_401_7, var_363_42(var_401_9))) + (var_401_1[iter_401_5 + 3] + var_401_0[var_363_35(var_401_12 - 2, 15) + 1] + var_401_6), 21) + var_401_7)
				end

				arg_401_0[1], arg_401_0[2], arg_401_0[3], arg_401_0[4] = var_363_43(var_401_6 + arg_401_0[1]), var_363_43(var_401_7 + arg_401_0[2]), var_363_43(var_401_8 + arg_401_0[3]), var_363_43(var_401_9 + arg_401_0[4])
			end
		end

		local function var_363_126(arg_402_0, arg_402_1, arg_402_2, arg_402_3)
			local var_402_0 = var_363_70

			for iter_402_0 = arg_402_2, arg_402_2 + arg_402_3 - 1, 64 do
				for iter_402_1 = 1, 16 do
					iter_402_0 = iter_402_0 + 4

					local var_402_1, var_402_2, var_402_3, var_402_4 = var_363_3(arg_402_1, iter_402_0 - 3, iter_402_0)

					var_402_0[iter_402_1] = var_363_36(var_363_38(var_402_1, 24), var_363_38(var_402_2, 16), var_363_38(var_402_3, 8), var_402_4)
				end

				for iter_402_2 = 17, 80 do
					var_402_0[iter_402_2] = var_363_40(var_363_37(var_402_0[iter_402_2 - 3], var_402_0[iter_402_2 - 8], var_402_0[iter_402_2 - 14], var_402_0[iter_402_2 - 16]), 1)
				end

				local var_402_5 = arg_402_0[1]
				local var_402_6 = arg_402_0[2]
				local var_402_7 = arg_402_0[3]
				local var_402_8 = arg_402_0[4]
				local var_402_9 = arg_402_0[5]

				for iter_402_3 = 1, 20, 5 do
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_8, var_363_35(var_402_6, var_363_37(var_402_8, var_402_7))) + (var_402_0[iter_402_3] + 1518500249 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_8, var_363_35(var_402_6, var_363_37(var_402_8, var_402_7))) + (var_402_0[iter_402_3 + 1] + 1518500249 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_8, var_363_35(var_402_6, var_363_37(var_402_8, var_402_7))) + (var_402_0[iter_402_3 + 2] + 1518500249 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_8, var_363_35(var_402_6, var_363_37(var_402_8, var_402_7))) + (var_402_0[iter_402_3 + 3] + 1518500249 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_8, var_363_35(var_402_6, var_363_37(var_402_8, var_402_7))) + (var_402_0[iter_402_3 + 4] + 1518500249 + var_402_9))
				end

				for iter_402_4 = 21, 40, 5 do
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_4] + 1859775393 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_4 + 1] + 1859775393 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_4 + 2] + 1859775393 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_4 + 3] + 1859775393 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_4 + 4] + 1859775393 + var_402_9))
				end

				for iter_402_5 = 41, 60, 5 do
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_363_35(var_402_8, var_363_37(var_402_6, var_402_7)), var_363_35(var_402_6, var_402_7)) + (var_402_0[iter_402_5] + 2400959708 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_363_35(var_402_8, var_363_37(var_402_6, var_402_7)), var_363_35(var_402_6, var_402_7)) + (var_402_0[iter_402_5 + 1] + 2400959708 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_363_35(var_402_8, var_363_37(var_402_6, var_402_7)), var_363_35(var_402_6, var_402_7)) + (var_402_0[iter_402_5 + 2] + 2400959708 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_363_35(var_402_8, var_363_37(var_402_6, var_402_7)), var_363_35(var_402_6, var_402_7)) + (var_402_0[iter_402_5 + 3] + 2400959708 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_363_35(var_402_8, var_363_37(var_402_6, var_402_7)), var_363_35(var_402_6, var_402_7)) + (var_402_0[iter_402_5 + 4] + 2400959708 + var_402_9))
				end

				for iter_402_6 = 61, 80, 5 do
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_6] + 3395469782 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_6 + 1] + 3395469782 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_6 + 2] + 3395469782 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_6 + 3] + 3395469782 + var_402_9))
					var_402_9, var_402_8, var_402_7, var_402_6, var_402_5 = var_402_8, var_402_7, var_363_41(var_402_6, 2), var_402_5, var_363_43(var_363_40(var_402_5, 5) + var_363_37(var_402_6, var_402_7, var_402_8) + (var_402_0[iter_402_6 + 4] + 3395469782 + var_402_9))
				end

				arg_402_0[1], arg_402_0[2], arg_402_0[3], arg_402_0[4], arg_402_0[5] = var_363_43(var_402_5 + arg_402_0[1]), var_363_43(var_402_6 + arg_402_0[2]), var_363_43(var_402_7 + arg_402_0[3]), var_363_43(var_402_8 + arg_402_0[4]), var_363_43(var_402_9 + arg_402_0[5])
			end
		end

		local var_363_127 = {}
		local var_363_128 = {}

		local function var_363_129(arg_403_0, arg_403_1, arg_403_2, arg_403_3, arg_403_4, arg_403_5)
			local var_403_0 = var_363_70
			local var_403_1 = var_363_127[arg_403_0]
			local var_403_2 = var_363_127[arg_403_1]
			local var_403_3 = var_363_127[arg_403_2]
			local var_403_4 = var_363_127[arg_403_3]
			local var_403_5 = var_363_128[arg_403_0]
			local var_403_6 = var_363_128[arg_403_1]
			local var_403_7 = var_363_128[arg_403_2]
			local var_403_8 = var_363_128[arg_403_3]
			local var_403_9 = var_403_0[2 * arg_403_4 - 1] + (var_403_1 % 4294967296 + var_403_2 % 4294967296)
			local var_403_10 = var_363_43(var_403_9)
			local var_403_11 = var_363_43(var_403_0[2 * arg_403_4] + (var_403_5 + var_403_6 + var_363_10(var_403_9 / 4294967296)))
			local var_403_12, var_403_13 = var_363_37(var_403_8, var_403_11), var_363_37(var_403_4, var_403_10)
			local var_403_14 = var_403_3 % 4294967296 + var_403_12 % 4294967296
			local var_403_15 = var_363_43(var_403_14)
			local var_403_16 = var_363_43(var_403_7 + var_403_13 + var_363_10(var_403_14 / 4294967296))
			local var_403_17, var_403_18 = var_363_37(var_403_2, var_403_15), var_363_37(var_403_6, var_403_16)
			local var_403_19, var_403_20 = var_363_37(var_363_39(var_403_17, 24), var_363_38(var_403_18, 8)), var_363_37(var_363_39(var_403_18, 24), var_363_38(var_403_17, 8))
			local var_403_21 = var_403_0[2 * arg_403_5 - 1] + (var_403_10 % 4294967296 + var_403_19 % 4294967296)
			local var_403_22 = var_363_43(var_403_21)
			local var_403_23 = var_363_43(var_403_0[2 * arg_403_5] + (var_403_11 + var_403_20 + var_363_10(var_403_21 / 4294967296)))
			local var_403_24, var_403_25 = var_363_37(var_403_12, var_403_22), var_363_37(var_403_13, var_403_23)
			local var_403_26, var_403_27 = var_363_37(var_363_39(var_403_24, 16), var_363_38(var_403_25, 16)), var_363_37(var_363_39(var_403_25, 16), var_363_38(var_403_24, 16))
			local var_403_28 = var_403_15 % 4294967296 + var_403_26 % 4294967296
			local var_403_29 = var_363_43(var_403_28)
			local var_403_30 = var_363_43(var_403_16 + var_403_27 + var_363_10(var_403_28 / 4294967296))
			local var_403_31, var_403_32 = var_363_37(var_403_19, var_403_29), var_363_37(var_403_20, var_403_30)
			local var_403_33, var_403_34 = var_363_37(var_363_38(var_403_31, 1), var_363_39(var_403_32, 31)), var_363_37(var_363_38(var_403_32, 1), var_363_39(var_403_31, 31))

			var_363_127[arg_403_0], var_363_127[arg_403_1], var_363_127[arg_403_2], var_363_127[arg_403_3] = var_403_22, var_403_33, var_403_29, var_403_26
			var_363_128[arg_403_0], var_363_128[arg_403_1], var_363_128[arg_403_2], var_363_128[arg_403_3] = var_403_23, var_403_34, var_403_30, var_403_27
		end

		local function var_363_130(arg_404_0, arg_404_1, arg_404_2, arg_404_3, arg_404_4, arg_404_5, arg_404_6, arg_404_7)
			local var_404_0 = var_363_70
			local var_404_1 = arg_404_0[1]
			local var_404_2 = arg_404_0[2]
			local var_404_3 = arg_404_0[3]
			local var_404_4 = arg_404_0[4]
			local var_404_5 = arg_404_0[5]
			local var_404_6 = arg_404_0[6]
			local var_404_7 = arg_404_0[7]
			local var_404_8 = arg_404_0[8]
			local var_404_9 = arg_404_1[1]
			local var_404_10 = arg_404_1[2]
			local var_404_11 = arg_404_1[3]
			local var_404_12 = arg_404_1[4]
			local var_404_13 = arg_404_1[5]
			local var_404_14 = arg_404_1[6]
			local var_404_15 = arg_404_1[7]
			local var_404_16 = arg_404_1[8]

			for iter_404_0 = arg_404_3, arg_404_3 + arg_404_4 - 1, 128 do
				if arg_404_2 then
					for iter_404_1 = 1, 32 do
						iter_404_0 = iter_404_0 + 4

						local var_404_17, var_404_18, var_404_19, var_404_20 = var_363_3(arg_404_2, iter_404_0 - 3, iter_404_0)

						var_404_0[iter_404_1] = var_404_20 * 16777216 + var_363_36(var_363_38(var_404_19, 16), var_363_38(var_404_18, 8), var_404_17)
					end
				end

				var_363_127[0], var_363_127[1], var_363_127[2], var_363_127[3], var_363_127[4], var_363_127[5], var_363_127[6], var_363_127[7] = var_404_1, var_404_2, var_404_3, var_404_4, var_404_5, var_404_6, var_404_7, var_404_8
				var_363_127[8], var_363_127[9], var_363_127[10], var_363_127[11], var_363_127[12], var_363_127[13], var_363_127[14], var_363_127[15] = var_363_58[1], var_363_58[2], var_363_58[3], var_363_58[4], var_363_58[5], var_363_58[6], var_363_58[7], var_363_58[8]
				var_363_128[0], var_363_128[1], var_363_128[2], var_363_128[3], var_363_128[4], var_363_128[5], var_363_128[6], var_363_128[7] = var_404_9, var_404_10, var_404_11, var_404_12, var_404_13, var_404_14, var_404_15, var_404_16
				var_363_128[8], var_363_128[9], var_363_128[10], var_363_128[11], var_363_128[12], var_363_128[13], var_363_128[14], var_363_128[15] = var_363_59[1], var_363_59[2], var_363_59[3], var_363_59[4], var_363_59[5], var_363_59[6], var_363_59[7], var_363_59[8]
				arg_404_5 = arg_404_5 + (arg_404_6 or 128)

				local var_404_21 = arg_404_5 % 4294967296
				local var_404_22 = var_363_10(arg_404_5 / 4294967296)

				var_363_127[12] = var_363_37(var_363_127[12], var_404_21)
				var_363_128[12] = var_363_37(var_363_128[12], var_404_22)

				if arg_404_6 then
					var_363_127[14] = var_363_42(var_363_127[14])
					var_363_128[14] = var_363_42(var_363_128[14])
				end

				if arg_404_7 then
					var_363_127[15] = var_363_42(var_363_127[15])
					var_363_128[15] = var_363_42(var_363_128[15])
				end

				for iter_404_2 = 1, 12 do
					local var_404_23 = var_363_77[iter_404_2]

					var_363_129(0, 4, 8, 12, var_404_23[1], var_404_23[2])
					var_363_129(1, 5, 9, 13, var_404_23[3], var_404_23[4])
					var_363_129(2, 6, 10, 14, var_404_23[5], var_404_23[6])
					var_363_129(3, 7, 11, 15, var_404_23[7], var_404_23[8])
					var_363_129(0, 5, 10, 15, var_404_23[9], var_404_23[10])
					var_363_129(1, 6, 11, 12, var_404_23[11], var_404_23[12])
					var_363_129(2, 7, 8, 13, var_404_23[13], var_404_23[14])
					var_363_129(3, 4, 9, 14, var_404_23[15], var_404_23[16])
				end

				var_404_1 = var_363_37(var_404_1, var_363_127[0], var_363_127[8])
				var_404_2 = var_363_37(var_404_2, var_363_127[1], var_363_127[9])
				var_404_3 = var_363_37(var_404_3, var_363_127[2], var_363_127[10])
				var_404_4 = var_363_37(var_404_4, var_363_127[3], var_363_127[11])
				var_404_5 = var_363_37(var_404_5, var_363_127[4], var_363_127[12])
				var_404_6 = var_363_37(var_404_6, var_363_127[5], var_363_127[13])
				var_404_7 = var_363_37(var_404_7, var_363_127[6], var_363_127[14])
				var_404_8 = var_363_37(var_404_8, var_363_127[7], var_363_127[15])
				var_404_9 = var_363_37(var_404_9, var_363_128[0], var_363_128[8])
				var_404_10 = var_363_37(var_404_10, var_363_128[1], var_363_128[9])
				var_404_11 = var_363_37(var_404_11, var_363_128[2], var_363_128[10])
				var_404_12 = var_363_37(var_404_12, var_363_128[3], var_363_128[11])
				var_404_13 = var_363_37(var_404_13, var_363_128[4], var_363_128[12])
				var_404_14 = var_363_37(var_404_14, var_363_128[5], var_363_128[13])
				var_404_15 = var_363_37(var_404_15, var_363_128[6], var_363_128[14])
				var_404_16 = var_363_37(var_404_16, var_363_128[7], var_363_128[15])
			end

			arg_404_0[1], arg_404_0[2], arg_404_0[3], arg_404_0[4], arg_404_0[5], arg_404_0[6], arg_404_0[7], arg_404_0[8] = var_404_1 % 4294967296, var_404_2 % 4294967296, var_404_3 % 4294967296, var_404_4 % 4294967296, var_404_5 % 4294967296, var_404_6 % 4294967296, var_404_7 % 4294967296, var_404_8 % 4294967296
			arg_404_1[1], arg_404_1[2], arg_404_1[3], arg_404_1[4], arg_404_1[5], arg_404_1[6], arg_404_1[7], arg_404_1[8] = var_404_9 % 4294967296, var_404_10 % 4294967296, var_404_11 % 4294967296, var_404_12 % 4294967296, var_404_13 % 4294967296, var_404_14 % 4294967296, var_404_15 % 4294967296, var_404_16 % 4294967296

			return arg_404_5
		end
	end

	if var_363_34 == "FFI" or var_363_34 == "LJ" then
		local var_363_131 = var_363_72
		local var_363_132 = var_363_73

		local function var_363_133(arg_405_0, arg_405_1, arg_405_2, arg_405_3, arg_405_4, arg_405_5)
			local var_405_0 = var_363_132[arg_405_0]
			local var_405_1 = var_363_132[arg_405_1]
			local var_405_2 = var_363_132[arg_405_2]
			local var_405_3 = var_363_132[arg_405_3]
			local var_405_4 = var_363_43(var_363_131[arg_405_4] + (var_405_0 + var_405_1))
			local var_405_5 = var_363_41(var_363_37(var_405_3, var_405_4), 16)
			local var_405_6 = var_363_43(var_405_2 + var_405_5)
			local var_405_7 = var_363_41(var_363_37(var_405_1, var_405_6), 12)
			local var_405_8 = var_363_43(var_363_131[arg_405_5] + (var_405_4 + var_405_7))
			local var_405_9 = var_363_41(var_363_37(var_405_5, var_405_8), 8)
			local var_405_10 = var_363_43(var_405_6 + var_405_9)
			local var_405_11 = var_363_41(var_363_37(var_405_7, var_405_10), 7)

			var_363_132[arg_405_0], var_363_132[arg_405_1], var_363_132[arg_405_2], var_363_132[arg_405_3] = var_405_8, var_405_11, var_405_10, var_405_9
		end

		local function var_363_134(arg_406_0, arg_406_1, arg_406_2, arg_406_3, arg_406_4, arg_406_5, arg_406_6)
			local var_406_0 = var_363_43(arg_406_0[1])
			local var_406_1 = var_363_43(arg_406_0[2])
			local var_406_2 = var_363_43(arg_406_0[3])
			local var_406_3 = var_363_43(arg_406_0[4])
			local var_406_4 = var_363_43(arg_406_0[5])
			local var_406_5 = var_363_43(arg_406_0[6])
			local var_406_6 = var_363_43(arg_406_0[7])
			local var_406_7 = var_363_43(arg_406_0[8])

			for iter_406_0 = arg_406_2, arg_406_2 + arg_406_3 - 1, 64 do
				if arg_406_1 then
					for iter_406_1 = 1, 16 do
						iter_406_0 = iter_406_0 + 4

						local var_406_8, var_406_9, var_406_10, var_406_11 = var_363_3(arg_406_1, iter_406_0 - 3, iter_406_0)

						var_363_131[iter_406_1] = var_363_36(var_363_38(var_406_11, 24), var_363_38(var_406_10, 16), var_363_38(var_406_9, 8), var_406_8)
					end
				end

				var_363_132[0], var_363_132[1], var_363_132[2], var_363_132[3], var_363_132[4], var_363_132[5], var_363_132[6], var_363_132[7] = var_406_0, var_406_1, var_406_2, var_406_3, var_406_4, var_406_5, var_406_6, var_406_7
				var_363_132[8], var_363_132[9], var_363_132[10], var_363_132[11], var_363_132[14], var_363_132[15] = var_363_43(var_363_59[1]), var_363_43(var_363_59[2]), var_363_43(var_363_59[3]), var_363_43(var_363_59[4]), var_363_43(var_363_59[7]), var_363_43(var_363_59[8])
				arg_406_4 = arg_406_4 + (arg_406_5 or 64)

				local var_406_12 = arg_406_4 % 4294967296
				local var_406_13 = var_363_10(arg_406_4 / 4294967296)

				var_363_132[12] = var_363_37(var_363_59[5], var_406_12)
				var_363_132[13] = var_363_37(var_363_59[6], var_406_13)

				if arg_406_5 then
					var_363_132[14] = var_363_42(var_363_132[14])
				end

				if arg_406_6 then
					var_363_132[15] = var_363_42(var_363_132[15])
				end

				for iter_406_2 = 1, 10 do
					local var_406_14 = var_363_77[iter_406_2]

					var_363_133(0, 4, 8, 12, var_406_14[1], var_406_14[2])
					var_363_133(1, 5, 9, 13, var_406_14[3], var_406_14[4])
					var_363_133(2, 6, 10, 14, var_406_14[5], var_406_14[6])
					var_363_133(3, 7, 11, 15, var_406_14[7], var_406_14[8])
					var_363_133(0, 5, 10, 15, var_406_14[9], var_406_14[10])
					var_363_133(1, 6, 11, 12, var_406_14[11], var_406_14[12])
					var_363_133(2, 7, 8, 13, var_406_14[13], var_406_14[14])
					var_363_133(3, 4, 9, 14, var_406_14[15], var_406_14[16])
				end

				var_406_0 = var_363_37(var_406_0, var_363_132[0], var_363_132[8])
				var_406_1 = var_363_37(var_406_1, var_363_132[1], var_363_132[9])
				var_406_2 = var_363_37(var_406_2, var_363_132[2], var_363_132[10])
				var_406_3 = var_363_37(var_406_3, var_363_132[3], var_363_132[11])
				var_406_4 = var_363_37(var_406_4, var_363_132[4], var_363_132[12])
				var_406_5 = var_363_37(var_406_5, var_363_132[5], var_363_132[13])
				var_406_6 = var_363_37(var_406_6, var_363_132[6], var_363_132[14])
				var_406_7 = var_363_37(var_406_7, var_363_132[7], var_363_132[15])
			end

			arg_406_0[1], arg_406_0[2], arg_406_0[3], arg_406_0[4], arg_406_0[5], arg_406_0[6], arg_406_0[7], arg_406_0[8] = var_406_0, var_406_1, var_406_2, var_406_3, var_406_4, var_406_5, var_406_6, var_406_7

			return arg_406_4
		end

		local function var_363_135(arg_407_0, arg_407_1, arg_407_2, arg_407_3, arg_407_4, arg_407_5, arg_407_6, arg_407_7, arg_407_8)
			arg_407_8 = arg_407_8 or 64

			local var_407_0 = var_363_43(arg_407_5[1])
			local var_407_1 = var_363_43(arg_407_5[2])
			local var_407_2 = var_363_43(arg_407_5[3])
			local var_407_3 = var_363_43(arg_407_5[4])
			local var_407_4 = var_363_43(arg_407_5[5])
			local var_407_5 = var_363_43(arg_407_5[6])
			local var_407_6 = var_363_43(arg_407_5[7])
			local var_407_7 = var_363_43(arg_407_5[8])

			arg_407_6 = arg_407_6 or arg_407_5

			for iter_407_0 = arg_407_1, arg_407_1 + arg_407_2 - 1, 64 do
				if arg_407_0 then
					for iter_407_1 = 1, 16 do
						iter_407_0 = iter_407_0 + 4

						local var_407_8, var_407_9, var_407_10, var_407_11 = var_363_3(arg_407_0, iter_407_0 - 3, iter_407_0)

						var_363_131[iter_407_1] = var_363_36(var_363_38(var_407_11, 24), var_363_38(var_407_10, 16), var_363_38(var_407_9, 8), var_407_8)
					end
				end

				var_363_132[0], var_363_132[1], var_363_132[2], var_363_132[3], var_363_132[4], var_363_132[5], var_363_132[6], var_363_132[7] = var_407_0, var_407_1, var_407_2, var_407_3, var_407_4, var_407_5, var_407_6, var_407_7
				var_363_132[8], var_363_132[9], var_363_132[10], var_363_132[11] = var_363_43(var_363_59[1]), var_363_43(var_363_59[2]), var_363_43(var_363_59[3]), var_363_43(var_363_59[4])
				var_363_132[12] = var_363_43(arg_407_4 % 4294967296)
				var_363_132[13] = var_363_10(arg_407_4 / 4294967296)
				var_363_132[14], var_363_132[15] = arg_407_8, arg_407_3

				for iter_407_2 = 1, 7 do
					var_363_133(0, 4, 8, 12, var_363_78[iter_407_2], var_363_78[iter_407_2 + 14])
					var_363_133(1, 5, 9, 13, var_363_78[iter_407_2 + 1], var_363_78[iter_407_2 + 2])
					var_363_133(2, 6, 10, 14, var_363_78[iter_407_2 + 16], var_363_78[iter_407_2 + 7])
					var_363_133(3, 7, 11, 15, var_363_78[iter_407_2 + 15], var_363_78[iter_407_2 + 17])
					var_363_133(0, 5, 10, 15, var_363_78[iter_407_2 + 21], var_363_78[iter_407_2 + 5])
					var_363_133(1, 6, 11, 12, var_363_78[iter_407_2 + 3], var_363_78[iter_407_2 + 6])
					var_363_133(2, 7, 8, 13, var_363_78[iter_407_2 + 4], var_363_78[iter_407_2 + 18])
					var_363_133(3, 4, 9, 14, var_363_78[iter_407_2 + 19], var_363_78[iter_407_2 + 20])
				end

				if arg_407_7 then
					arg_407_6[9] = var_363_37(var_407_0, var_363_132[8])
					arg_407_6[10] = var_363_37(var_407_1, var_363_132[9])
					arg_407_6[11] = var_363_37(var_407_2, var_363_132[10])
					arg_407_6[12] = var_363_37(var_407_3, var_363_132[11])
					arg_407_6[13] = var_363_37(var_407_4, var_363_132[12])
					arg_407_6[14] = var_363_37(var_407_5, var_363_132[13])
					arg_407_6[15] = var_363_37(var_407_6, var_363_132[14])
					arg_407_6[16] = var_363_37(var_407_7, var_363_132[15])
				end

				var_407_0 = var_363_37(var_363_132[0], var_363_132[8])
				var_407_1 = var_363_37(var_363_132[1], var_363_132[9])
				var_407_2 = var_363_37(var_363_132[2], var_363_132[10])
				var_407_3 = var_363_37(var_363_132[3], var_363_132[11])
				var_407_4 = var_363_37(var_363_132[4], var_363_132[12])
				var_407_5 = var_363_37(var_363_132[5], var_363_132[13])
				var_407_6 = var_363_37(var_363_132[6], var_363_132[14])
				var_407_7 = var_363_37(var_363_132[7], var_363_132[15])
			end

			arg_407_6[1], arg_407_6[2], arg_407_6[3], arg_407_6[4], arg_407_6[5], arg_407_6[6], arg_407_6[7], arg_407_6[8] = var_407_0, var_407_1, var_407_2, var_407_3, var_407_4, var_407_5, var_407_6, var_407_7
		end
	end

	local function var_363_136(arg_408_0, arg_408_1, arg_408_2, arg_408_3)
		local var_408_0 = {}
		local var_408_1 = 0
		local var_408_2 = 0
		local var_408_3 = 1

		for iter_408_0 = 1, arg_408_3 do
			for iter_408_1 = var_363_13(1, iter_408_0 + 1 - #arg_408_1), var_363_12(iter_408_0, #arg_408_0) do
				var_408_1 = var_408_1 + arg_408_2 * arg_408_0[iter_408_1] * arg_408_1[iter_408_0 + 1 - iter_408_1]
			end

			local var_408_4 = var_408_1 % 16777216

			var_408_0[iter_408_0] = var_363_10(var_408_4)
			var_408_1 = (var_408_1 - var_408_4) / 16777216
			var_408_2 = var_408_2 + var_408_4 * var_408_3
			var_408_3 = var_408_3 * 16777216
		end

		return var_408_0, var_408_2
	end

	local var_363_137 = 0
	local var_363_138 = {
		4,
		1,
		2,
		-2,
		2
	}
	local var_363_139 = 4
	local var_363_140 = {
		1
	}
	local var_363_141 = var_363_59
	local var_363_142 = var_363_58

	repeat
		var_363_139 = var_363_139 + var_363_138[var_363_139 % 6]

		local var_363_143 = 1

		repeat
			var_363_143 = var_363_143 + var_363_138[var_363_143 % 6]

			if var_363_139 < var_363_143 * var_363_143 then
				local var_363_144 = var_363_139^0.3333333333333333
				local var_363_145 = var_363_144 * 1099511627776
				local var_363_146 = var_363_136({
					var_363_145 - var_363_145 % 1
				}, var_363_140, 1, 2)
				local var_363_147, var_363_148 = var_363_136(var_363_146, var_363_136(var_363_146, var_363_146, 1, 4), -1, 4)
				local var_363_149 = var_363_146[2] % 65536 * 65536 + var_363_10(var_363_146[1] / 256)
				local var_363_150 = var_363_146[1] % 256 * 16777216 + var_363_10(var_363_148 * 4.625929269271485e-18 * var_363_144 / var_363_139)

				if var_363_137 < 16 then
					local var_363_151 = var_363_139^0.5
					local var_363_152 = var_363_151 * 1099511627776
					local var_363_153 = var_363_136({
						var_363_152 - var_363_152 % 1
					}, var_363_140, 1, 2)
					local var_363_154, var_363_155 = var_363_136(var_363_153, var_363_153, -1, 2)
					local var_363_156 = var_363_153[2] % 65536 * 65536 + var_363_10(var_363_153[1] / 256)
					local var_363_157 = var_363_153[1] % 256 * 16777216 + var_363_10(var_363_155 * 7.62939453125e-06 / var_363_151)
					local var_363_158 = var_363_137 % 8 + 1

					var_363_62[224][var_363_158] = var_363_157
					var_363_141[var_363_158], var_363_142[var_363_158] = var_363_156, var_363_157 + var_363_156 * var_363_75

					if var_363_158 > 7 then
						var_363_141, var_363_142 = var_363_64[384], var_363_63[384]
					end
				end

				var_363_137 = var_363_137 + 1
				var_363_57[var_363_137], var_363_56[var_363_137] = var_363_149, var_363_150 % var_363_74 + var_363_149 * var_363_75

				break
			end
		until var_363_139 % var_363_143 == 0
	until var_363_137 > 79

	for iter_363_3 = 224, 256, 32 do
		local var_363_159 = {}
		local var_363_160

		if var_363_68 then
			for iter_363_4 = 1, 8 do
				var_363_159[iter_363_4] = var_363_46(var_363_58[iter_363_4])
			end
		else
			var_363_160 = {}

			for iter_363_5 = 1, 8 do
				var_363_159[iter_363_5] = var_363_46(var_363_58[iter_363_5])
				var_363_160[iter_363_5] = var_363_46(var_363_59[iter_363_5])
			end
		end

		var_363_49(var_363_159, var_363_160, "SHA-512/" .. tostring(iter_363_3) .. "\x80" .. var_363_5("\x00", 115) .. "X", 0, 128)

		var_363_63[iter_363_3] = var_363_159
		var_363_64[iter_363_3] = var_363_160
	end

	local var_363_161 = math.sin
	local var_363_162 = math.abs
	local var_363_163 = math.modf

	for iter_363_6 = 1, 64 do
		local var_363_164, var_363_165 = var_363_163(var_363_162(var_363_161(iter_363_6)) * 65536)

		var_363_65[iter_363_6] = var_363_164 * 65536 + var_363_10(var_363_165 * 65536)
	end

	local var_363_166 = 29

	local function var_363_167()
		local var_409_0 = var_363_166 % 2

		var_363_166 = var_363_45((var_363_166 - var_409_0) / 2, 142 * var_409_0)

		return var_409_0
	end

	for iter_363_7 = 1, 24 do
		local var_363_168 = 0
		local var_363_169

		for iter_363_8 = 1, 6 do
			var_363_169 = var_363_169 and var_363_169 * var_363_169 * 2 or 1
			var_363_168 = var_363_168 + var_363_167() * var_363_169
		end

		local var_363_170 = var_363_167() * var_363_169

		var_363_61[iter_363_7], var_363_60[iter_363_7] = var_363_170, var_363_168 + var_363_170 * var_363_76
	end

	if var_363_34 == "FFI" then
		var_363_57 = var_363_27.new("uint32_t[?]", #var_363_57 + 1, 0, var_363_1(var_363_57))
		var_363_56 = var_363_27.new("int64_t[?]", #var_363_56 + 1, 0, var_363_1(var_363_56))

		if var_363_76 == 0 then
			var_363_60 = var_363_27.new("uint32_t[?]", #var_363_60 + 1, 0, var_363_1(var_363_60))
			var_363_61 = var_363_27.new("uint32_t[?]", #var_363_61 + 1, 0, var_363_1(var_363_61))
		else
			var_363_60 = var_363_27.new("int64_t[?]", #var_363_60 + 1, 0, var_363_1(var_363_60))
		end
	end

	local function var_363_171(arg_410_0, arg_410_1)
		local var_410_0 = {
			var_363_1(var_363_62[arg_410_0])
		}
		local var_410_1 = 0
		local var_410_2 = ""

		local function var_410_3(arg_411_0)
			if arg_411_0 then
				if var_410_2 then
					var_410_1 = var_410_1 + #arg_411_0

					local var_411_0 = 0

					if var_410_2 ~= "" and #var_410_2 + #arg_411_0 >= 64 then
						var_411_0 = 64 - #var_410_2

						var_363_48(var_410_0, var_410_2 .. var_363_6(arg_411_0, 1, var_411_0), 0, 64)

						var_410_2 = ""
					end

					local var_411_1 = #arg_411_0 - var_411_0
					local var_411_2 = var_411_1 % 64

					var_363_48(var_410_0, arg_411_0, var_411_0, var_411_1 - var_411_2)

					var_410_2 = var_410_2 .. var_363_6(arg_411_0, #arg_411_0 + 1 - var_411_2)

					return var_410_3
				else
					error("Adding more chunks is not allowed after receiving the result", 2)
				end
			else
				if var_410_2 then
					local var_411_3 = {
						var_410_2,
						"\x80",
						var_363_5("\x00", (-9 - var_410_1) % 64 + 1)
					}

					var_410_2 = nil
					var_410_1 = var_410_1 * 1.1102230246251565e-16

					for iter_411_0 = 4, 10 do
						var_410_1 = var_410_1 % 1 * 256
						var_411_3[iter_411_0] = var_363_4(var_363_10(var_410_1))
					end

					local var_411_4 = var_363_2(var_411_3)

					var_363_48(var_410_0, var_411_4, 0, #var_411_4)

					local var_411_5 = arg_410_0 / 32

					for iter_411_1 = 1, var_411_5 do
						var_410_0[iter_411_1] = var_363_44(var_410_0[iter_411_1])
					end

					var_410_0 = var_363_2(var_410_0, "", 1, var_411_5)
				end

				return var_410_0
			end
		end

		if arg_410_1 then
			return var_410_3(arg_410_1)()
		else
			return var_410_3
		end
	end

	local function var_363_172(arg_412_0, arg_412_1)
		local var_412_0 = 0
		local var_412_1 = ""
		local var_412_2 = {
			var_363_1(var_363_63[arg_412_0])
		}
		local var_412_3

		var_412_3 = not var_363_68 and {
			var_363_1(var_363_64[arg_412_0])
		}

		local function var_412_4(arg_413_0)
			if arg_413_0 then
				if var_412_1 then
					var_412_0 = var_412_0 + #arg_413_0

					local var_413_0 = 0

					if var_412_1 ~= "" and #var_412_1 + #arg_413_0 >= 128 then
						var_413_0 = 128 - #var_412_1

						var_363_49(var_412_2, var_412_3, var_412_1 .. var_363_6(arg_413_0, 1, var_413_0), 0, 128)

						var_412_1 = ""
					end

					local var_413_1 = #arg_413_0 - var_413_0
					local var_413_2 = var_413_1 % 128

					var_363_49(var_412_2, var_412_3, arg_413_0, var_413_0, var_413_1 - var_413_2)

					var_412_1 = var_412_1 .. var_363_6(arg_413_0, #arg_413_0 + 1 - var_413_2)

					return var_412_4
				else
					error("Adding more chunks is not allowed after receiving the result", 2)
				end
			else
				if var_412_1 then
					local var_413_3 = {
						var_412_1,
						"\x80",
						var_363_5("\x00", (-17 - var_412_0) % 128 + 9)
					}

					var_412_1 = nil
					var_412_0 = var_412_0 * 1.1102230246251565e-16

					for iter_413_0 = 4, 10 do
						var_412_0 = var_412_0 % 1 * 256
						var_413_3[iter_413_0] = var_363_4(var_363_10(var_412_0))
					end

					local var_413_4 = var_363_2(var_413_3)

					var_363_49(var_412_2, var_412_3, var_413_4, 0, #var_413_4)

					local var_413_5 = var_363_11(arg_412_0 / 64)

					if var_363_68 then
						for iter_413_1 = 1, var_413_5 do
							var_412_2[iter_413_1] = var_363_68(var_412_2[iter_413_1])
						end
					else
						for iter_413_2 = 1, var_413_5 do
							var_412_2[iter_413_2] = var_363_44(var_412_3[iter_413_2]) .. var_363_44(var_412_2[iter_413_2])
						end

						var_412_3 = nil
					end

					var_412_2 = var_363_6(var_363_2(var_412_2, "", 1, var_413_5), 1, arg_412_0 / 4)
				end

				return var_412_2
			end
		end

		if arg_412_1 then
			return var_412_4(arg_412_1)()
		else
			return var_412_4
		end
	end

	local var_363_173
	local var_363_174
	local var_363_175
	local var_363_176

	local function var_363_177(arg_414_0)
		return (var_363_7(arg_414_0, "%x%x", function(arg_415_0)
			return var_363_4(var_363_14(arg_415_0, 16))
		end))
	end

	local function var_363_178(arg_416_0)
		return (var_363_7(arg_416_0, ".", function(arg_417_0)
			return var_363_9("%02x", var_363_3(arg_417_0))
		end))
	end

	local var_363_179 = {
		_ = 63,
		[63] = "/",
		[-1] = "=",
		["/"] = 63,
		["+"] = 62,
		[62] = "+",
		["="] = -1,
		["."] = -1,
		["-"] = 62
	}
	local var_363_180 = 0

	for iter_363_9, iter_363_10 in ipairs({
		"AZ",
		"az",
		"09"
	}) do
		for iter_363_11 = var_363_3(iter_363_10), var_363_3(iter_363_10, 2) do
			local var_363_181 = var_363_4(iter_363_11)

			var_363_179[var_363_181] = var_363_180
			var_363_179[var_363_180] = var_363_181
			var_363_180 = var_363_180 + 1
		end
	end

	local function var_363_182(arg_418_0)
		local var_418_0 = {}

		for iter_418_0 = 1, #arg_418_0, 3 do
			local var_418_1, var_418_2, var_418_3, var_418_4 = var_363_3(var_363_6(arg_418_0, iter_418_0, iter_418_0 + 2) .. "\x00", 1, -1)

			var_418_0[#var_418_0 + 1] = var_363_179[var_363_10(var_418_1 / 4)] .. var_363_179[var_418_1 % 4 * 16 + var_363_10(var_418_2 / 16)] .. var_363_179[var_418_3 and var_418_2 % 16 * 4 + var_363_10(var_418_3 / 64) or -1] .. var_363_179[var_418_4 and var_418_3 % 64 or -1]
		end

		return var_363_2(var_418_0)
	end

	local function var_363_183(arg_419_0)
		local var_419_0 = {}
		local var_419_1 = 3

		for iter_419_0, iter_419_1 in var_363_8(var_363_7(arg_419_0, "%s+", ""), "()(.)") do
			local var_419_2 = var_363_179[iter_419_1]

			if var_419_2 < 0 then
				var_419_1 = var_419_1 - 1
				var_419_2 = 0
			end

			local var_419_3 = iter_419_0 % 4

			if var_419_3 > 0 then
				var_419_0[-var_419_3] = var_419_2
			else
				local var_419_4 = var_419_0[-1] * 4 + var_363_10(var_419_0[-2] / 16)
				local var_419_5 = var_419_0[-2] % 16 * 16 + var_363_10(var_419_0[-3] / 4)
				local var_419_6 = var_419_0[-3] % 4 * 64 + var_419_2

				var_419_0[#var_419_0 + 1] = var_363_6(var_363_4(var_419_4, var_419_5, var_419_6), 1, var_419_1)
			end
		end

		return var_363_2(var_419_0)
	end

	local var_363_184

	local function var_363_185(arg_420_0, arg_420_1, arg_420_2)
		return var_363_7(arg_420_0, ".", function(arg_421_0)
			return var_363_4(var_363_45(var_363_3(arg_421_0), arg_420_2))
		end) .. var_363_5(var_363_4(arg_420_2), arg_420_1 - #arg_420_0)
	end

	local function var_363_186(arg_422_0, arg_422_1, arg_422_2)
		local var_422_0 = var_363_184[arg_422_0]

		if not var_422_0 then
			error("Unknown hash function", 2)
		end

		if var_422_0 < #arg_422_1 then
			arg_422_1 = var_363_177(arg_422_0(arg_422_1))
		end

		local var_422_1 = arg_422_0()(var_363_185(arg_422_1, var_422_0, 54))
		local var_422_2

		local function var_422_3(arg_423_0)
			if not arg_423_0 then
				var_422_2 = var_422_2 or arg_422_0(var_363_185(arg_422_1, var_422_0, 92) .. var_363_177(var_422_1()))

				return var_422_2
			elseif var_422_2 then
				error("Adding more chunks is not allowed after receiving the result", 2)
			else
				var_422_1(arg_423_0)

				return var_422_3
			end
		end

		if arg_422_2 then
			return var_422_3(arg_422_2)()
		else
			return var_422_3
		end
	end

	local var_363_187 = {
		sha224 = function(arg_424_0)
			return var_363_171(224, arg_424_0)
		end,
		sha256 = function(arg_425_0)
			return var_363_171(256, arg_425_0)
		end,
		sha512_224 = function(arg_426_0)
			return var_363_172(224, arg_426_0)
		end,
		sha512_256 = function(arg_427_0)
			return var_363_172(256, arg_427_0)
		end,
		sha384 = function(arg_428_0)
			return var_363_172(384, arg_428_0)
		end,
		sha512 = function(arg_429_0)
			return var_363_172(512, arg_429_0)
		end,
		hmac = var_363_186,
		hex_to_bin = var_363_177,
		bin_to_hex = var_363_178,
		base64_to_bin = var_363_183,
		bin_to_base64 = var_363_182,
		hex2bin = var_363_177,
		bin2hex = var_363_178,
		base642bin = var_363_183,
		bin2base64 = var_363_182
	}

	var_363_184 = {
		[var_363_187.sha224] = 64,
		[var_363_187.sha256] = 64,
		[var_363_187.sha512_224] = 128,
		[var_363_187.sha512_256] = 128,
		[var_363_187.sha384] = 128,
		[var_363_187.sha512] = 128
	}

	return var_363_187
end)()
local var_0_128 = {
	gamesense = (function()
		local var_430_0 = var_0_0.new
		local var_430_1 = var_0_0.cast
		local var_430_2 = var_0_0.cdef
		local var_430_3 = var_0_0.typeof
		local var_430_4 = var_0_1.band
		local var_430_5 = var_0_1.bor
		local var_430_6 = var_0_1.bxor
		local var_430_7 = var_0_1.bnot
		local var_430_8 = var_0_1.lshift
		local var_430_9 = var_0_1.rshift
		local var_430_10 = var_0_1.ror
		local var_430_11 = var_0_1.rol

		local function var_430_12(arg_431_0)
			return var_430_4(var_430_9(arg_431_0, 16), 65535)
		end

		local function var_430_13(arg_432_0, arg_432_1)
			arg_432_0 = var_430_4(arg_432_0, 65535)
			arg_432_0 = var_430_5(arg_432_0, var_430_8(arg_432_0, 16))

			return var_430_4(var_430_10(arg_432_0, arg_432_1), 65535)
		end

		local function var_430_14(arg_433_0, arg_433_1)
			return var_430_5(var_430_9(arg_433_0, arg_433_1), var_430_8(arg_433_0, 32 - arg_433_1))
		end

		local function var_430_15(arg_434_0, arg_434_1)
			arg_434_0 = var_430_4(arg_434_0, 65535)

			return var_430_4(var_430_5(var_430_8(arg_434_0, arg_434_1), var_430_9(arg_434_0, 16 - arg_434_1)), 65535)
		end

		local var_430_16 = var_430_0("uint8_t[24]")
		local var_430_17 = var_430_1("uint16_t*", var_430_16)
		local var_430_18 = var_430_1("uint32_t*", var_430_16)

		local function var_430_19(arg_435_0, arg_435_1)
			local var_435_0 = var_0_126(arg_435_1)

			var_430_18[0] = arg_435_0[0].xuid_low
			var_430_18[1] = arg_435_0[0].xuid_high
			var_430_18[2] = arg_435_0[0].section_number
			var_430_18[3] = arg_435_0[0].sequence_bytes
			var_430_18[4] = arg_435_0[0].uncompressed_sample_offset

			local var_435_1 = {
				[0] = 94,
				4,
				184,
				28,
				143,
				210,
				241,
				56,
				207,
				171,
				136,
				61,
				194,
				59,
				115,
				88,
				65,
				204,
				6,
				249,
				32,
				68,
				121,
				77,
				172,
				47,
				202,
				150,
				217,
				237,
				34,
				247,
				44,
				244,
				67,
				147,
				13,
				208,
				70,
				45,
				141,
				42,
				180,
				225,
				12,
				53,
				89,
				16,
				114,
				18,
				236,
				165,
				79,
				188,
				174,
				58,
				71,
				102,
				205,
				40,
				160,
				104,
				154,
				181,
				92,
				99,
				246,
				183,
				36,
				43,
				195,
				51,
				90,
				81,
				76,
				140,
				49,
				212,
				177,
				159,
				122,
				86,
				235,
				82,
				112,
				253,
				2,
				135,
				84,
				151,
				232,
				83,
				10,
				96,
				120,
				29,
				145,
				179,
				134,
				191,
				98,
				189,
				201,
				199,
				7,
				46,
				80,
				106,
				105,
				62,
				190,
				162,
				166,
				22,
				119,
				26,
				196,
				238,
				87,
				175,
				146,
				164,
				176,
				113,
				9,
				173,
				152,
				41,
				206,
				25,
				224,
				54,
				198,
				220,
				230,
				107,
				211,
				223,
				148,
				95,
				131,
				21,
				52,
				234,
				153,
				33,
				221,
				192,
				19,
				11,
				254,
				111,
				66,
				155,
				75,
				50,
				64,
				219,
				222,
				109,
				14,
				27,
				124,
				85,
				255,
				91,
				158,
				39,
				57,
				103,
				138,
				5,
				73,
				193,
				37,
				30,
				31,
				116,
				228,
				8,
				216,
				110,
				127,
				203,
				245,
				242,
				137,
				250,
				38,
				17,
				72,
				169,
				125,
				167,
				200,
				142,
				243,
				23,
				35,
				93,
				128,
				197,
				48,
				74,
				130,
				1,
				240,
				251,
				182,
				144,
				185,
				108,
				209,
				163,
				0,
				15,
				20,
				215,
				161,
				129,
				170,
				63,
				132,
				60,
				252,
				126,
				239,
				229,
				187,
				139,
				213,
				186,
				218,
				156,
				149,
				231,
				69,
				157,
				55,
				24,
				101,
				100,
				214,
				117,
				178,
				226,
				133,
				233,
				248,
				78,
				118,
				123,
				168,
				3,
				97,
				227
			}
			local var_435_2 = 7

			for iter_435_0 = 0, 20 do
				local var_435_3 = var_435_1[iter_435_0 + 129]

				var_435_1[iter_435_0 + 129] = var_435_1[var_430_4(var_435_2 + var_435_3, 255)]
				var_435_1[var_430_4(var_435_2 + var_435_3, 255)] = var_435_3
				var_435_2 = var_430_4(var_435_2 + var_435_3, 255)
				var_430_16[iter_435_0] = var_430_6(var_430_16[iter_435_0], var_435_1[var_430_4(var_435_3 + var_435_1[iter_435_0 + 129], 255)])
			end

			local var_435_4 = 0
			local var_435_5 = 0
			local var_435_6 = 0
			local var_435_7 = 0
			local var_435_8 = 0
			local var_435_9 = 0
			local var_435_10 = 0
			local var_435_11 = 0
			local var_435_12 = 0
			local var_435_13 = 0

			for iter_435_1 = 0, 4 do
				local var_435_14 = 2 * iter_435_1 + 1
				local var_435_15 = var_430_17[var_435_14]
				local var_435_16 = var_430_17[var_435_14 + 1]
				local var_435_17 = 2446691973
				local var_435_18 = var_435_15
				local var_435_19 = var_435_16

				for iter_435_2 = 1, 15 do
					local var_435_20 = var_430_11(var_435_17, 1)
					local var_435_21 = var_430_13(var_435_19 - var_435_17, var_430_4(var_435_18, 15))

					var_435_17 = var_430_11(var_435_17, 2)
					var_435_19 = var_430_4(var_430_6(var_435_18, var_435_21), 65535)
					var_435_11 = var_430_4(var_430_6(var_435_19, var_430_13(var_435_18 - var_435_20, var_430_4(var_435_19, 15))), 65535)
					var_435_18 = var_430_4(var_435_11, 65535)
				end

				var_430_17[var_435_14] = var_430_6(var_435_12, var_435_11 - var_430_11(var_435_17, 1))
				var_430_17[var_435_14 + 1] = var_430_4(var_430_6(var_435_13, var_435_19 - var_435_17), 65535)
				var_435_12 = var_435_15
				var_435_13 = var_435_16
			end

			local var_435_22 = var_430_18[0]
			local var_435_23 = var_430_18[1]
			local var_435_24 = var_430_18[2]
			local var_435_25 = var_430_6(var_435_23, var_435_0.user_id)
			local var_435_26 = var_430_6(var_435_24, arg_435_1)
			local var_435_27 = var_430_6(var_430_12(var_435_0.xuid_low), var_430_12(var_435_22)) == 9252

			var_430_18[0] = var_435_22
			var_430_18[1] = var_435_25
			var_430_18[2] = var_435_26

			if var_435_27 then
				local var_435_28 = {}

				for iter_435_3 = 0, 20 do
					var_435_28[iter_435_3 + 1] = var_430_16[iter_435_3]
				end

				local var_435_29 = var_0_48.new(var_435_28)

				var_435_29:read_bits(32)
				var_435_29:read_bits(32)

				local var_435_30 = var_435_29:read_bits(7) + 1

				var_435_29:read_bits(9)

				local var_435_31 = var_435_29:read_coord()
				local var_435_32 = var_435_29:read_coord()
				local var_435_33 = var_435_29:read_coord()

				if var_435_31 < -16384 or var_435_31 > 16384 or var_435_32 < -16384 or var_435_32 > 16384 or var_435_33 < -16384 or var_435_33 > 16384 then
					return nil
				end

				if not var_0_51.is_player_valid(var_435_30) then
					return nil
				end

				local var_435_34 = var_0_51.get_tick_count()

				if math.abs(var_435_34 - tonumber(var_435_25)) > 32 then
					return nil
				end

				return {
					entity = var_435_30,
					tickcount = tonumber(var_435_25),
					x = var_435_31,
					y = var_435_32,
					z = var_435_33
				}
			end

			return nil
		end

		local function var_430_20(arg_436_0)
			local var_436_0 = 0
			local var_436_1 = 0
			local var_436_2 = 0
			local var_436_3 = 0
			local var_436_4 = 0
			local var_436_5 = 3370829634
			local var_436_6 = var_430_14(var_436_5, 1)

			for iter_436_0 = 0, 4 do
				local var_436_7 = 2 * iter_436_0 + 1
				local var_436_8 = var_430_4(var_436_5 + var_430_6(var_436_1, arg_436_0[var_436_7]), 65535)
				local var_436_9 = var_430_14(var_436_6, 1)

				var_436_0 = var_430_4(var_436_6 + var_430_6(var_436_0, arg_436_0[var_436_7 + 1]), 65535)

				local var_436_10 = 15

				while var_436_10 ~= 0 do
					var_436_3 = var_430_4(var_436_9 + var_430_15(var_430_6(var_436_8, var_436_0), var_430_4(var_436_0, 15)), 65535)

					local var_436_11 = var_430_14(var_436_9, 1)

					var_436_8 = var_436_3
					var_436_0 = var_430_4(var_436_11 + var_430_15(var_430_6(var_436_3, var_436_0), var_430_4(var_436_3, 15)), 65535)
					var_436_9 = var_430_14(var_436_11, 1)
					var_436_10 = var_436_10 - 1
				end

				var_436_1 = var_436_3
				arg_436_0[var_436_7] = var_436_3
				arg_436_0[var_436_7 + 1] = var_436_0
			end
		end

		local function var_430_21(arg_437_0, arg_437_1)
			local var_437_0 = var_0_126(arg_437_1)
			local var_437_1 = var_0_48.new({
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
			})

			var_437_1:write_bits(0, 32)
			var_437_1:write_bits(0, 32)
			var_437_1:write_bits(arg_437_0.entity - 1, 7)
			var_437_1:write_bits(511, 9)
			var_437_1:write_coord(arg_437_0.x)
			var_437_1:write_coord(arg_437_0.y)
			var_437_1:write_coord(arg_437_0.z)

			local var_437_2 = var_430_1("uint8_t*", var_437_1:get_raw_buffer())
			local var_437_3 = var_430_1(var_0_119, var_437_2)
			local var_437_4 = var_430_1("uint16_t*", var_437_2)

			var_437_4[0] = math.random(0, 65535)
			var_437_4[1] = 9252
			var_437_3[0].xuid_high = arg_437_0.tickcount
			var_437_4[1] = var_430_6(var_437_4[1], var_430_12(var_437_0.xuid_low))
			var_437_3[0].xuid_high = var_430_6(var_437_3[0].xuid_high, var_437_0.user_id)
			var_437_3[0].section_number = var_430_6(var_437_3[0].section_number, arg_437_1)

			var_430_20(var_437_4)

			local var_437_5 = {
				[0] = 94,
				4,
				184,
				28,
				143,
				210,
				241,
				56,
				207,
				171,
				136,
				61,
				194,
				59,
				115,
				88,
				65,
				204,
				6,
				249,
				32,
				68,
				121,
				77,
				172,
				47,
				202,
				150,
				217,
				237,
				34,
				247,
				44,
				244,
				67,
				147,
				13,
				208,
				70,
				45,
				141,
				42,
				180,
				225,
				12,
				53,
				89,
				16,
				114,
				18,
				236,
				165,
				79,
				188,
				174,
				58,
				71,
				102,
				205,
				40,
				160,
				104,
				154,
				181,
				92,
				99,
				246,
				183,
				36,
				43,
				195,
				51,
				90,
				81,
				76,
				140,
				49,
				212,
				177,
				159,
				122,
				86,
				235,
				82,
				112,
				253,
				2,
				135,
				84,
				151,
				232,
				83,
				10,
				96,
				120,
				29,
				145,
				179,
				134,
				191,
				98,
				189,
				201,
				199,
				7,
				46,
				80,
				106,
				105,
				62,
				190,
				162,
				166,
				22,
				119,
				26,
				196,
				238,
				87,
				175,
				146,
				164,
				176,
				113,
				9,
				173,
				152,
				41,
				206,
				25,
				224,
				54,
				198,
				220,
				230,
				107,
				211,
				223,
				148,
				95,
				131,
				21,
				52,
				234,
				153,
				33,
				221,
				192,
				19,
				11,
				254,
				111,
				66,
				155,
				75,
				50,
				64,
				219,
				222,
				109,
				14,
				27,
				124,
				85,
				255,
				91,
				158,
				39,
				57,
				103,
				138,
				5,
				73,
				193,
				37,
				30,
				31,
				116,
				228,
				8,
				216,
				110,
				127,
				203,
				245,
				242,
				137,
				250,
				38,
				17,
				72,
				169,
				125,
				167,
				200,
				142,
				243,
				23,
				35,
				93,
				128,
				197,
				48,
				74,
				130,
				1,
				240,
				251,
				182,
				144,
				185,
				108,
				209,
				163,
				0,
				15,
				20,
				215,
				161,
				129,
				170,
				63,
				132,
				60,
				252,
				126,
				239,
				229,
				187,
				139,
				213,
				186,
				218,
				156,
				149,
				231,
				69,
				157,
				55,
				24,
				101,
				100,
				214,
				117,
				178,
				226,
				133,
				233,
				248,
				78,
				118,
				123,
				168,
				3,
				97,
				227
			}
			local var_437_6 = 7

			for iter_437_0 = 0, 20 do
				local var_437_7 = var_437_5[iter_437_0 + 129]

				var_437_5[iter_437_0 + 129] = var_437_5[var_430_4(var_437_6 + var_437_7, 255)]
				var_437_5[var_430_4(var_437_6 + var_437_7, 255)] = var_437_7
				var_437_6 = var_430_4(var_437_6 + var_437_7, 255)
				var_437_2[iter_437_0] = var_430_6(var_437_2[iter_437_0], var_437_5[var_430_4(var_437_7 + var_437_5[iter_437_0 + 129], 255)])
			end

			local var_437_8 = var_437_3[0].sequence_bytes

			var_437_3[0].sequence_bytes = var_437_3[0].section_number
			var_437_3[0].section_number = var_437_8

			return var_430_1(var_0_65, var_437_3)
		end

		return {
			decode = var_430_19,
			encode = var_430_21
		}
	end)(),
	primordial = (function()
		local var_438_0 = var_0_0.new("int16_t[1]")

		local function var_438_1(arg_439_0, arg_439_1)
			var_438_0[0] = var_0_8(arg_439_0, arg_439_1)

			return tonumber(var_0_3("float", var_438_0[0]))
		end

		local function var_438_2(arg_440_0)
			local var_440_0 = var_0_8(arg_440_0.eidp1, arg_440_0.mutualkey)
			local var_440_1 = var_438_1(arg_440_0.xored_x, arg_440_0.loc_xor_key)
			local var_440_2 = var_438_1(arg_440_0.xored_y, arg_440_0.loc_xor_key)
			local var_440_3 = var_438_1(arg_440_0.xored_z, arg_440_0.loc_xor_key)
			local var_440_4 = var_0_8(arg_440_0.keyp1, arg_440_0.keyp2) - arg_440_0.mutualkey

			if var_440_0 == nil or not var_0_51.is_player_valid(var_440_0) then
				return nil
			end

			if var_0_51.is_player_dormant(var_440_0) then
				return nil
			end

			local var_440_5 = var_0_51.get_player_position(var_440_0)

			if math.abs(var_440_5.x - var_440_1) > 256 or math.abs(var_440_5.y - var_440_2) > 256 or math.abs(var_440_5.z - var_440_3) > 256 then
				return nil
			end

			return {
				entity = var_440_0,
				x = var_440_1,
				y = var_440_2,
				z = var_440_3,
				key = var_440_4
			}
		end

		local function var_438_3(arg_441_0)
			local var_441_0 = var_0_0.new(var_0_94)

			var_441_0[0].mutualkey = 0
			var_441_0[0].eidp1 = arg_441_0[0].entity
			var_441_0[0].keyp2 = 0
			var_441_0[0].keyp1 = arg_441_0[0].key
			var_441_0[0].loc_xor_key = 0
			var_441_0[0].xored_x = arg_441_0[0].x
			var_441_0[0].xored_y = arg_441_0[0].y
			var_441_0[0].xored_z = arg_441_0[0].z

			return var_441_0
		end

		return {
			decode = var_438_2,
			encode = var_438_3
		}
	end)(),
	rifk7 = (function()
		local function var_442_0(arg_443_0, arg_443_1)
			local var_443_0 = tonumber(var_0_3("int32_t", arg_443_0[0].xuid_low))
			local var_443_1 = var_443_0 + 28
			local var_443_2 = var_443_0 + 31

			if var_443_1 >= 0 then
				var_443_2 = var_443_1
			end

			local var_443_3 = var_0_11(var_443_2, 2) - arg_443_1 - arg_443_1 + 54
			local var_443_4 = var_0_7(var_443_3, 64)

			if var_443_4 ~= 124 and var_443_4 ~= 252 then
				return false
			end

			return true
		end

		return {
			decode = var_442_0
		}
	end)(),
	legion = (function()
		local var_444_0 = var_0_0.new("uint8_t[8]")

		local function var_444_1(arg_445_0, arg_445_1)
			local var_445_0 = var_0_126(arg_445_1).user_id

			var_444_0[0] = var_0_8(arg_445_0[0].legion_xor[0], var_445_0)
			var_444_0[1] = var_0_8(arg_445_0[0].legion_xor[1], var_445_0)
			var_444_0[2] = var_0_8(arg_445_0[0].legion_xor[2], var_445_0)
			var_444_0[3] = var_0_8(arg_445_0[0].legion_xor[3], var_445_0)
			var_444_0[4] = var_0_8(arg_445_0[0].legion_xor[4], var_445_0)
			var_444_0[5] = var_0_8(arg_445_0[0].legion_xor[5], var_445_0)
			var_444_0[6] = var_0_8(arg_445_0[0].legion_xor[6], var_445_0)
			var_444_0[7] = var_0_8(arg_445_0[0].legion_xor[7], var_445_0)

			return (var_0_3("char*", var_444_0))
		end

		local var_444_2 = var_0_2("uint8_t[6]")

		local function var_444_3(arg_446_0, arg_446_1)
			local var_446_0 = var_0_2(var_0_109)
			local var_446_1 = var_0_126(arg_446_1).user_id

			var_444_2[0] = var_0_8(arg_446_0[0].legion[0], var_446_1)
			var_444_2[1] = var_0_8(arg_446_0[0].legion[1], var_446_1)
			var_444_2[2] = var_0_8(arg_446_0[0].legion[2], var_446_1)
			var_444_2[3] = var_0_8(arg_446_0[0].legion[3], var_446_1)
			var_444_2[4] = var_0_8(arg_446_0[0].legion[4], var_446_1)
			var_444_2[5] = var_0_8(arg_446_0[0].legion[5], var_446_1)
			var_446_0[0].legion_xor[0] = var_444_2[0]
			var_446_0[0].legion_xor[1] = var_444_2[1]
			var_446_0[0].legion_xor[2] = var_444_2[2]
			var_446_0[0].legion_xor[3] = var_444_2[3]
			var_446_0[0].legion_xor[4] = var_444_2[4]
			var_446_0[0].legion_xor[5] = var_444_2[5]
			var_446_0[0].random = arg_446_0[0].random

			return var_446_0
		end

		return {
			decode = var_444_1,
			encode = var_444_3
		}
	end)(),
	pandora = (function()
		local function var_447_0(arg_448_0)
			local var_448_0 = arg_448_0[0].identifier

			if var_448_0 ~= 6969 and var_448_0 ~= 420187 then
				return false
			end

			local var_448_1 = arg_448_0[0].entityId
			local var_448_2 = arg_448_0[0].x
			local var_448_3 = arg_448_0[0].y
			local var_448_4 = arg_448_0[0].z

			if var_448_1 > 64 or var_448_1 < 0 or not var_0_51.is_player_valid(var_448_1) then
				return false
			end

			if var_0_51.is_player_dormant(var_448_1) then
				return false
			end

			local var_448_5 = var_0_51.get_player_position(var_448_1)

			if math.abs(var_448_5.x - var_448_2) > 256 or math.abs(var_448_5.y - var_448_3) > 256 or math.abs(var_448_5.z - var_448_4) > 256 then
				return false
			end

			return true
		end

		return {
			decode = var_447_0
		}
	end)(),
	airflow = (function()
		local function var_449_0(arg_450_0)
			return var_0_6(arg_450_0, 65535)
		end

		local function var_449_1(arg_451_0)
			return var_0_6(var_0_11(arg_451_0, 16), 65535)
		end

		local function var_449_2(arg_452_0)
			return var_0_6(var_0_11(arg_452_0, 24), 255)
		end

		local function var_449_3(arg_453_0)
			return var_0_6(var_0_11(arg_453_0, 8), 255)
		end

		local function var_449_4(arg_454_0, arg_454_1)
			local var_454_0 = arg_454_0

			for iter_454_0 = 0, 31 do
				if var_0_6(var_454_0, var_0_10(1, iter_454_0)) == var_0_6(var_0_10(1, iter_454_0), arg_454_1) then
					var_454_0 = var_0_6(var_454_0, var_0_9(var_0_10(1, iter_454_0)))
				else
					var_454_0 = var_0_7(var_454_0, var_0_10(1, iter_454_0))
				end
			end

			return var_454_0
		end

		local var_449_5 = var_0_36({
			[175] = "Airflow Old",
			[102] = "Floridahook",
			[153] = "Weave",
			[180] = "Karnazity",
			[187] = "Boss",
			[250] = "Airflow",
			[220] = "Furcore",
			[186] = "Airflow Boss"
		})

		local function var_449_6(arg_455_0)
			if arg_455_0 <= 32767 then
				return arg_455_0
			else
				return arg_455_0 - 65536
			end
		end

		local var_449_7 = var_0_2("uint8_t[24]")
		local var_449_8 = var_0_3("uint16_t*", var_449_7)
		local var_449_9 = var_0_3("uint32_t*", var_449_7)

		local function var_449_10(arg_456_0)
			if arg_456_0[0].section_number == 0 or arg_456_0[0].sequence_bytes == 0 or arg_456_0[0].uncompressed_sample_offset == 0 then
				return nil
			end

			var_449_9[0] = arg_456_0[0].xuid_low
			var_449_9[1] = arg_456_0[0].xuid_high
			var_449_9[2] = arg_456_0[0].sequence_bytes
			var_449_9[3] = arg_456_0[0].section_number
			var_449_9[4] = arg_456_0[0].uncompressed_sample_offset

			local var_456_0 = {}

			for iter_456_0 = 0, 20 do
				var_456_0[iter_456_0 + 1] = var_449_7[iter_456_0]
			end

			local var_456_1 = var_0_48.new(var_456_0)
			local var_456_2 = var_456_1:read_bits(8)
			local var_456_3 = var_456_1:read_bits(8)
			local var_456_4 = var_456_1:read_bits(16)
			local var_456_5 = var_456_1:read_bits(8)
			local var_456_6 = var_449_6(tonumber(var_0_0.cast("float", var_456_1:read_bits(16))))
			local var_456_7 = var_449_6(tonumber(var_0_0.cast("float", var_456_1:read_bits(16))))
			local var_456_8 = var_449_6(tonumber(var_0_0.cast("float", var_456_1:read_bits(16))))
			local var_456_9 = var_456_1:read_bits(8)
			local var_456_10 = var_456_1:read_bits(32)

			if var_456_4 ~= 57005 or var_456_2 ~= 241 then
				return nil
			end

			if var_449_5[var_456_3] == nil then
				return nil
			end

			if var_456_5 > 64 or var_456_5 < 0 or not var_0_51.is_player_valid(var_456_5) then
				return nil
			end

			if var_0_51.is_player_dormant(var_456_5) then
				return nil
			end

			local var_456_11 = var_0_51.get_player_position(var_456_5)

			if math.abs(var_456_11.x - var_456_6) > 256 or math.abs(var_456_11.y - var_456_7) > 256 or math.abs(var_456_11.z - var_456_8) > 256 then
				return nil
			end

			local var_456_12 = var_0_6(var_0_51.get_tick_count(), 65535)

			if math.abs(var_456_12 - var_456_10) > 32 then
				return nil
			end

			return {
				cheat_id = var_456_3,
				id = var_456_5,
				x = var_456_6,
				y = var_456_7,
				z = var_456_8,
				tick_count = var_456_10,
				health = var_456_9
			}
		end

		local function var_449_11(arg_457_0)
			local var_457_0 = var_0_48.new({
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
			})

			var_457_0:write_bits(241, 8)
			var_457_0:write_bits(arg_457_0.cheat_id, 8)
			var_457_0:write_bits(57005, 16)
			var_457_0:write_bits(arg_457_0.id, 8)
			var_457_0:write_bits(arg_457_0.x, 16)
			var_457_0:write_bits(arg_457_0.y, 16)
			var_457_0:write_bits(arg_457_0.z, 16)
			var_457_0:write_bits(arg_457_0.health, 8)
			var_457_0:write_bits(var_0_6(arg_457_0.tick_count, 65535), 32)
			var_457_0:write_bits(16515072, 24)
			var_457_0:write_bits(arg_457_0.boss, 8)

			local var_457_1 = var_0_3("uint8_t*", var_457_0:get_raw_buffer())

			return var_0_3(var_0_65, var_457_1)
		end

		return {
			cheat_type = var_449_5,
			decode = var_449_10,
			encode = var_449_11
		}
	end)(),
	legendware = (function()
		local function var_458_0(arg_459_0)
			return arg_459_0[0].m_key == 29804 and (arg_459_0[0].t == 1337 or arg_459_0[0].t == 4759537)
		end

		local var_458_1 = var_0_2(var_0_112)

		var_458_1[0].m_key = 29804
		var_458_1[0].t = 1337

		local function var_458_2(arg_460_0)
			return var_458_1
		end

		return {
			decode = var_458_0,
			encode = var_458_2
		}
	end)(),
	nixware = (function()
		local function var_461_0(arg_462_0, arg_462_1)
			local var_462_0 = arg_462_0:read_bits(16)
			local var_462_1 = arg_462_0:read_bits(7) + 1
			local var_462_2 = arg_462_0:read_coord()
			local var_462_3 = arg_462_0:read_coord()
			local var_462_4 = arg_462_0:read_coord()
			local var_462_5 = arg_462_0:read_bits(32)
			local var_462_6 = arg_462_0:read_bits(7)

			arg_462_0:reset()

			if arg_462_1 then
				print("--------------------")
				print("id: " .. var_462_0)
				print("user_id: " .. var_462_1)
				print("x: " .. var_462_2)
				print("y: " .. var_462_3)
				print("z: " .. var_462_4)
				print("tick_count: " .. var_462_5)
				print("health: " .. var_462_6)
				print("--------------------")
			end

			if var_462_0 ~= 48879 then
				return nil
			end

			if var_462_2 < -16384 or var_462_2 > 16384 or var_462_3 < -16384 or var_462_3 > 16384 or var_462_4 < -16384 or var_462_4 > 16384 then
				return nil
			end

			local var_462_7 = var_0_51.get_tick_count()

			if math.abs(var_462_7 - var_462_5) > 32 then
				return nil
			end

			if not var_0_51.is_player_valid(var_462_1) then
				return nil
			end

			if var_0_51.is_player_dormant(var_462_1) then
				return nil
			end

			local var_462_8 = var_0_51.get_player_position(var_462_1)

			if math.abs(var_462_8.x - var_462_2) > 256 or math.abs(var_462_8.y - var_462_3) > 256 or math.abs(var_462_8.z - var_462_4) > 256 then
				return nil
			end

			return {
				id = var_462_0,
				entity_id = var_462_1,
				x = var_462_2,
				y = var_462_3,
				z = var_462_4,
				tickcount = var_462_5,
				health = var_462_6
			}
		end

		local function var_461_1(arg_463_0, arg_463_1)
			arg_463_1:write_bits(arg_463_0.id, 16)
			arg_463_1:write_bits(arg_463_0.entity_id - 1, 7)
			arg_463_1:write_coord(arg_463_0.x)
			arg_463_1:write_coord(arg_463_0.y)
			arg_463_1:write_coord(arg_463_0.z)
			arg_463_1:write_bits(arg_463_0.tick_count, 32)
			arg_463_1:write_bits(arg_463_0.health, 7)

			return arg_463_1
		end

		return {
			decode = var_461_0,
			encode = var_461_1
		}
	end)(),
	plague = (function()
		local function var_464_0(arg_465_0)
			if arg_465_0[0].id ~= 907415600 then
				return false
			end

			local var_465_0 = arg_465_0[0].entity
			local var_465_1 = arg_465_0[0].x
			local var_465_2 = arg_465_0[0].y
			local var_465_3 = arg_465_0[0].z

			if var_465_0 > 64 or var_465_0 < 0 or not var_0_51.is_player_valid(var_465_0) then
				return false
			end

			if var_0_51.is_player_dormant(var_465_0) then
				return false
			end

			local var_465_4 = var_0_51.get_player_position(var_465_0)

			if math.abs(var_465_4.x - var_465_1) > 256 or math.abs(var_465_4.y - var_465_2) > 256 or math.abs(var_465_4.z - var_465_3) > 256 then
				return false
			end

			return true
		end

		return {
			decode = var_464_0
		}
	end)(),
	onetap = (function()
		local var_466_0 = var_0_0.new
		local var_466_1 = var_0_0.cast
		local var_466_2 = var_0_0.cdef
		local var_466_3 = var_0_0.typeof
		local var_466_4 = var_0_1.band
		local var_466_5 = var_0_1.bor
		local var_466_6 = var_0_1.bxor
		local var_466_7 = var_0_1.bnot
		local var_466_8 = var_0_1.lshift
		local var_466_9 = var_0_1.rshift
		local var_466_10 = var_0_1.ror
		local var_466_11 = var_0_1.rol
		local var_466_12 = var_466_0("uint8_t[20]")
		local var_466_13 = var_466_1("uint16_t*", var_466_12)
		local var_466_14 = var_466_1("uint32_t*", var_466_12)

		local function var_466_15(arg_467_0)
			if arg_467_0 <= 32767 then
				return arg_467_0
			else
				return arg_467_0 - 65536
			end
		end

		local var_466_16 = 1401050875
		local var_466_17 = 359866515
		local var_466_18 = 928134322
		local var_466_19 = {
			var_466_4(var_466_17, 255),
			var_466_4(var_466_9(var_466_17, 8), 255),
			var_466_4(var_466_9(var_466_17, 16), 255),
			var_466_4(var_466_9(var_466_17, 24), 255)
		}
		local var_466_20 = {
			var_466_4(var_466_18, 255),
			var_466_4(var_466_9(var_466_18, 8), 255),
			var_466_4(var_466_9(var_466_18, 16), 255),
			var_466_4(var_466_9(var_466_18, 24), 255)
		}

		local function var_466_21(arg_468_0, arg_468_1)
			var_466_14[0] = arg_468_0[0].xuid_low
			var_466_14[1] = arg_468_0[0].xuid_high
			var_466_14[2] = arg_468_0[0].sequence_bytes
			var_466_14[3] = arg_468_0[0].section_number
			var_466_14[4] = arg_468_0[0].uncompressed_sample_offset

			for iter_468_0 = 0, 19 do
				var_466_12[iter_468_0] = var_466_6(var_466_12[iter_468_0], arg_468_1)
			end

			for iter_468_1 = 1, 4 do
				var_466_12[iter_468_1 + 3] = var_466_6(var_466_12[iter_468_1 + 3], var_466_19[iter_468_1])
			end

			for iter_468_2 = 1, 4 do
				var_466_12[iter_468_2 + 7] = var_466_6(var_466_12[iter_468_2 + 7], var_466_20[iter_468_2])
			end

			for iter_468_3 = 1, 4 do
				var_466_12[iter_468_3 + 11] = var_466_6(var_466_12[iter_468_3 + 11], var_466_19[iter_468_3])
			end

			for iter_468_4 = 1, 4 do
				var_466_12[iter_468_4 + 15] = var_466_6(var_466_12[iter_468_4 + 15], var_466_20[iter_468_4])
			end

			local var_468_0 = var_0_0.cast(var_0_92, var_466_12)[0]

			if var_468_0.id == var_466_16 and var_0_51.is_player_valid(var_468_0.entity_id) then
				local var_468_1 = {}

				for iter_468_5 = 0, 20 do
					var_468_1[iter_468_5 + 1] = var_466_12[iter_468_5]
				end

				local var_468_2 = var_0_48.new(var_468_1)
				local var_468_3 = var_466_4(var_0_51.get_tick_count(), 255)

				var_468_2:read_bits(32)

				local var_468_4 = var_468_2:read_bits(8)
				local var_468_5 = var_468_2:read_bits(8)
				local var_468_6 = var_466_15(tonumber(var_0_0.cast("float", var_468_2:read_bits(16))))
				local var_468_7 = var_466_15(tonumber(var_0_0.cast("float", var_468_2:read_bits(16))))
				local var_468_8 = var_466_15(tonumber(var_0_0.cast("float", var_468_2:read_bits(16))))

				if var_0_51.is_player_dormant(var_468_4) then
					return nil
				end

				local var_468_9 = var_0_51.get_player_position(var_468_4)

				if math.abs(var_468_9.x - var_468_6) > 256 or math.abs(var_468_9.y - var_468_7) > 256 or math.abs(var_468_9.z - var_468_8) > 256 then
					return nil
				end

				if math.abs(var_468_3 - var_468_5) > 32 then
					return nil
				end

				return {
					entity = var_468_0.entity_id,
					tick_count_byte = var_468_5,
					x = var_468_6,
					y = var_468_7,
					z = var_468_8
				}
			end

			return nil
		end

		local function var_466_22(arg_469_0, arg_469_1)
			local var_469_0 = var_466_0(var_0_91)
			local var_469_1 = var_466_1("uint8_t*", var_469_0)
			local var_469_2 = var_466_1("uint32_t*", var_469_0)

			var_469_0[0].id = var_466_16
			var_469_0[0].entity_id = arg_469_0.entity
			var_469_0[0].tick_count = var_466_4(arg_469_0.tick_count, 255)
			var_469_0[0].x = arg_469_0.x
			var_469_0[0].y = arg_469_0.y
			var_469_0[0].z = arg_469_0.z

			for iter_469_0 = 1, 4 do
				var_469_1[iter_469_0 + 3] = var_466_6(var_469_1[iter_469_0 + 3], var_466_19[iter_469_0])
			end

			for iter_469_1 = 1, 4 do
				var_469_1[iter_469_1 + 7] = var_466_6(var_469_1[iter_469_1 + 7], var_466_20[iter_469_1])
			end

			for iter_469_2 = 1, 4 do
				var_469_1[iter_469_2 + 11] = var_466_6(var_469_1[iter_469_2 + 11], var_466_19[iter_469_2])
			end

			for iter_469_3 = 1, 4 do
				var_469_1[iter_469_3 + 15] = var_466_6(var_469_1[iter_469_3 + 15], var_466_20[iter_469_3])
			end

			for iter_469_4 = 0, 19 do
				var_469_1[iter_469_4] = var_466_6(var_469_1[iter_469_4], arg_469_1)
			end

			var_469_0[0].pad[0] = arg_469_1
			var_469_0[0].pad[1] = arg_469_1
			var_469_0[0].pad[2] = arg_469_1
			var_469_0[0].pad[3] = arg_469_1
			var_469_0[0].pad[4] = arg_469_1
			var_469_0[0].pad[5] = arg_469_1
			var_469_0[0].pad[6] = arg_469_1
			var_469_0[0].pad[7] = arg_469_1
			var_469_0[0].pad[8] = arg_469_1

			return var_469_0
		end

		return {
			decode = var_466_21,
			encode = var_466_22
		}
	end)(),
	neverlose = (function()
		local var_470_0 = {
			0,
			1996959894,
			3993919788,
			2567524794,
			124634137,
			1886057615,
			3915621685,
			2657392035,
			249268274,
			2044508324,
			3772115230,
			2547177864,
			162941995,
			2125561021,
			3887607047,
			2428444049,
			498536548,
			1789927666,
			4089016648,
			2227061214,
			450548861,
			1843258603,
			4107580753,
			2211677639,
			325883990,
			1684777152,
			4251122042,
			2321926636,
			335633487,
			1661365465,
			4195302755,
			2366115317,
			997073096,
			1281953886,
			3579855332,
			2724688242,
			1006888145,
			1258607687,
			3524101629,
			2768942443,
			901097722,
			1119000684,
			3686517206,
			2898065728,
			853044451,
			1172266101,
			3705015759,
			2882616665,
			651767980,
			1373503546,
			3369554304,
			3218104598,
			565507253,
			1454621731,
			3485111705,
			3099436303,
			671266974,
			1594198024,
			3322730930,
			2970347812,
			795835527,
			1483230225,
			3244367275,
			3060149565,
			1994146192,
			31158534,
			2563907772,
			4023717930,
			1907459465,
			112637215,
			2680153253,
			3904427059,
			2013776290,
			251722036,
			2517215374,
			3775830040,
			2137656763,
			141376813,
			2439277719,
			3865271297,
			1802195444,
			476864866,
			2238001368,
			4066508878,
			1812370925,
			453092731,
			2181625025,
			4111451223,
			1706088902,
			314042704,
			2344532202,
			4240017532,
			1658658271,
			366619977,
			2362670323,
			4224994405,
			1303535960,
			984961486,
			2747007092,
			3569037538,
			1256170817,
			1037604311,
			2765210733,
			3554079995,
			1131014506,
			879679996,
			2909243462,
			3663771856,
			1141124467,
			855842277,
			2852801631,
			3708648649,
			1342533948,
			654459306,
			3188396048,
			3373015174,
			1466479909,
			544179635,
			3110523913,
			3462522015,
			1591671054,
			702138776,
			2966460450,
			3352799412,
			1504918807,
			783551873,
			3082640443,
			3233442989,
			3988292384,
			2596254646,
			62317068,
			1957810842,
			3939845945,
			2647816111,
			81470997,
			1943803523,
			3814918930,
			2489596804,
			225274430,
			2053790376,
			3826175755,
			2466906013,
			167816743,
			2097651377,
			4027552580,
			2265490386,
			503444072,
			1762050814,
			4150417245,
			2154129355,
			426522225,
			1852507879,
			4275313526,
			2312317920,
			282753626,
			1742555852,
			4189708143,
			2394877945,
			397917763,
			1622183637,
			3604390888,
			2714866558,
			953729732,
			1340076626,
			3518719985,
			2797360999,
			1068828381,
			1219638859,
			3624741850,
			2936675148,
			906185462,
			1090812512,
			3747672003,
			2825379669,
			829329135,
			1181335161,
			3412177804,
			3160834842,
			628085408,
			1382605366,
			3423369109,
			3138078467,
			570562233,
			1426400815,
			3317316542,
			2998733608,
			733239954,
			1555261956,
			3268935591,
			3050360625,
			752459403,
			1541320221,
			2607071920,
			3965973030,
			1969922972,
			40735498,
			2617837225,
			3943577151,
			1913087877,
			83908371,
			2512341634,
			3803740692,
			2075208622,
			213261112,
			2463272603,
			3855990285,
			2094854071,
			198958881,
			2262029012,
			4057260610,
			1759359992,
			534414190,
			2176718541,
			4139329115,
			1873836001,
			414664567,
			2282248934,
			4279200368,
			1711684554,
			285281116,
			2405801727,
			4167216745,
			1634467795,
			376229701,
			2685067896,
			3608007406,
			1308918612,
			956543938,
			2808555105,
			3495958263,
			1231636301,
			1047427035,
			2932959818,
			3654703836,
			1088359270,
			936918000,
			2847714899,
			3736837829,
			1202900863,
			817233897,
			3183342108,
			3401237130,
			1404277552,
			615818150,
			3134207493,
			3453421203,
			1423857449,
			601450431,
			3009837614,
			3294710456,
			1567103746,
			711928724,
			3020668471,
			3272380065,
			1510334235,
			755167117
		}

		local function var_470_1(arg_471_0)
			local var_471_0 = 16
			local var_471_1 = 4294967295
			local var_471_2 = 4

			while var_471_0 > 0 do
				local var_471_3 = arg_471_0[var_471_2]

				var_471_1 = var_0_8(var_0_11(var_471_1, 8), var_470_0[var_0_8(var_0_6(var_471_1, 255), var_471_3) + 1])
				var_471_2 = var_471_2 + 1
				var_471_0 = var_471_0 - 1
			end

			local var_471_4 = var_0_8(var_471_1, 4294967295)

			if var_471_4 < 0 then
				var_471_4 = var_471_4 + 4294967296
			end

			return var_471_4
		end

		local function var_470_2(arg_472_0)
			if var_0_35[arg_472_0] == nil then
				var_0_37("recalculating: " .. arg_472_0)

				var_0_35[arg_472_0] = var_0_127.sha256(arg_472_0)
			end

			return var_0_35[arg_472_0]
		end

		local function var_470_3(arg_473_0)
			if arg_473_0 < 0 then
				return arg_473_0 + 4294967296
			end

			return arg_473_0
		end

		local function var_470_4(arg_474_0, arg_474_1, arg_474_2)
			local var_474_0 = var_0_126(arg_474_2)
			local var_474_1 = var_470_2(tostring(arg_474_2) .. var_474_0.guid)

			arg_474_0:crypt(var_474_1)
			arg_474_0:crypt(arg_474_1)

			local var_474_2 = var_470_3(arg_474_0:read_bits(32))

			if var_470_1(arg_474_0:get_raw_buffer()) ~= var_474_2 then
				arg_474_0:crypt(arg_474_1)
				arg_474_0:crypt(var_474_1)
				arg_474_0:reset()

				return nil
			end

			local var_474_3 = arg_474_0:read_bits(7) + 1
			local var_474_4 = arg_474_0:read_bits(32)
			local var_474_5 = arg_474_0:read_coord()
			local var_474_6 = arg_474_0:read_coord()
			local var_474_7 = arg_474_0:read_coord()
			local var_474_8 = arg_474_0:read_bits(7)

			arg_474_0:reset()
			arg_474_0:crypt(arg_474_1)
			arg_474_0:crypt(var_474_1)

			if var_474_3 > 64 or var_474_3 < 0 or not var_0_51.is_player_valid(var_474_3) then
				return nil
			end

			if var_474_7 < -16384 or var_474_7 > 16384 or var_474_6 < -16384 or var_474_6 > 16384 or var_474_5 < -16384 or var_474_5 > 16384 then
				return nil
			end

			local var_474_9 = var_0_51.get_tick_count()

			if math.abs(var_474_9 - var_474_4) > 32 then
				return nil
			end

			return {
				id = var_474_3,
				x = var_474_7,
				y = var_474_6,
				z = var_474_5,
				tick_count = var_474_4,
				health = var_474_8
			}
		end

		local function var_470_5(arg_475_0, arg_475_1, arg_475_2, arg_475_3)
			local var_475_0 = var_0_126(arg_475_3)
			local var_475_1 = var_470_2(tostring(arg_475_3) .. var_475_0.guid)

			arg_475_1:write_bits(0, 32)
			arg_475_1:write_bits(arg_475_0.id - 1, 7)
			arg_475_1:write_bits(arg_475_0.tick_count, 32)
			arg_475_1:write_coord(arg_475_0.z)
			arg_475_1:write_coord(arg_475_0.y)
			arg_475_1:write_coord(arg_475_0.x)
			arg_475_1:write_bits(arg_475_0.health, 7)
			arg_475_1:reset()

			local var_475_2 = var_470_1(arg_475_1:get_raw_buffer())

			arg_475_1:write_bits(var_475_2, 32)
			arg_475_1:crypt(arg_475_2)
			arg_475_1:crypt(var_475_1)

			return arg_475_1
		end

		return {
			decode = var_470_4,
			encode = var_470_5
		}
	end)(),
	ev0lity_old = (function()
		local function var_476_0(arg_477_0)
			if arg_477_0 <= 127 then
				return arg_477_0
			else
				return arg_477_0 - 256
			end
		end

		local function var_476_1(arg_478_0)
			local var_478_0 = var_0_3(var_0_86, arg_478_0)[0]

			if var_478_0 == nil then
				return nil
			end

			if var_478_0.id ~= 32762 and var_478_0.id ~= 32763 and var_478_0.id ~= 32764 and var_478_0.id ~= 32765 then
				return nil
			end

			if var_478_0.x == nil or var_478_0.y == nil or var_478_0.z == nil then
				return nil
			end

			if var_478_0.x < -16384 or var_478_0.x > 16384 or var_478_0.y < -16384 or var_478_0.y > 16384 or var_478_0.z < -16384 or var_478_0.z > 16384 then
				return nil
			end

			if var_478_0.user_id == nil then
				return nil
			end

			local var_478_1

			for iter_478_0, iter_478_1 in pairs(var_0_51.get_players()) do
				local var_478_2 = var_0_126(iter_478_1)

				if var_478_2 ~= nil and var_0_6(var_478_2.user_id, 255) == var_478_0.user_id then
					var_478_1 = iter_478_1

					break
				end
			end

			if var_478_1 == nil or not var_0_51.is_player_valid(var_478_1) then
				return nil
			end

			if var_0_51.is_player_dormant(var_478_1) then
				return nil
			end

			local var_478_3 = var_0_51.get_player_position(var_478_1)

			if math.abs(var_478_3.x - var_478_0.x) > 256 or math.abs(var_478_3.y - var_478_0.y) > 256 or math.abs(var_478_3.z - var_478_0.z) > 256 then
				return nil
			end

			local var_478_4 = var_0_51.get_tick_count()

			if math.abs(var_478_4 - var_478_0.server_tick) > 32 then
				return nil
			end

			local var_478_5 = var_0_51.get_active_weapon_index(var_478_1)

			if var_478_5 == nil then
				return nil
			end

			if var_0_6(var_478_5, 255) ~= var_478_0.weapon_id then
				return nil
			end

			return {
				id = var_478_0.id,
				entity_id = var_478_1,
				x = var_478_0.x,
				y = var_478_0.y,
				z = var_478_0.z,
				tick_count = var_478_0.server_tick
			}
		end

		local function var_476_2(arg_479_0)
			return
		end

		return {
			decode = var_476_1,
			encode = var_476_2
		}
	end)(),
	ev0lity = (function()
		local function var_480_0(arg_481_0)
			if arg_481_0 <= 32767 then
				return arg_481_0
			else
				return arg_481_0 - 65536
			end
		end

		local function var_480_1(arg_482_0, arg_482_1)
			local var_482_0 = var_0_126(arg_482_1)
			local var_482_1 = var_0_6(var_0_8(var_482_0.xuid_high, arg_482_1) % var_482_0.xuid_low, 4294967295)
			local var_482_2 = var_0_7(var_482_1, var_0_6(var_0_8(var_482_0.xuid_high, var_482_0.xuid_low), 65535))
			local var_482_3 = var_0_3("uint8_t*", arg_482_0)
			local var_482_4 = {}

			for iter_482_0 = 0, 20 do
				var_482_4[iter_482_0 + 1] = var_482_3[iter_482_0]
			end

			local var_482_5 = {
				var_0_6(var_482_2, 255),
				var_0_6(var_0_11(var_482_2, 8), 255),
				var_0_6(var_0_11(var_482_2, 16), 255),
				var_0_6(var_0_11(var_482_2, 24), 255)
			}
			local var_482_6 = #var_482_4

			for iter_482_1 = 1, var_482_6 do
				var_482_4[iter_482_1] = var_0_6(var_0_8(var_482_4[iter_482_1], var_482_5[(iter_482_1 - 1) % 4 + 1]), 255)

				if (iter_482_1 - 1) % 4 == 3 then
					var_482_2 = var_0_7(var_0_10(var_482_2, 8), var_0_6(iter_482_1 - 1, 255))
					var_482_5 = {
						var_0_6(var_482_2, 255),
						var_0_6(var_0_11(var_482_2, 8), 255),
						var_0_6(var_0_11(var_482_2, 16), 255),
						var_0_6(var_0_11(var_482_2, 24), 255)
					}
				end
			end

			local var_482_7 = var_0_48.new(var_482_4)
			local var_482_8 = var_482_7:read_bits(16)
			local var_482_9 = var_482_7:read_bits(8)
			local var_482_10 = var_482_7:read_bits(8)
			local var_482_11 = var_480_0(var_482_7:read_bits(16))
			local var_482_12 = var_480_0(var_482_7:read_bits(16))
			local var_482_13 = var_480_0(var_482_7:read_bits(16))
			local var_482_14 = var_482_7:read_bits(16)
			local var_482_15 = var_482_7:read_bits(32)

			if var_482_8 ~= 32762 and var_482_8 ~= 32763 and var_482_8 ~= 32764 and var_482_8 ~= 32765 then
				return nil
			end

			if not var_0_51.is_player_valid(var_482_9) then
				return nil
			end

			if var_482_11 < -16384 or var_482_11 > 16384 or var_482_12 < -16384 or var_482_12 > 16384 or var_482_13 < -16384 or var_482_13 > 16384 then
				return nil
			end

			return {
				id = var_482_8,
				entity_id = var_482_9,
				weapon_id = var_482_10,
				x = var_482_11,
				y = var_482_12,
				z = var_482_13,
				tick_count = var_482_15
			}
		end

		local function var_480_2(arg_483_0, arg_483_1)
			local var_483_0 = var_0_48.new()

			var_483_0:write_bits(arg_483_0.id, 16)
			var_483_0:write_bits(arg_483_0.entity_id, 8)
			var_483_0:write_bits(arg_483_0.weapon_id, 8)
			var_483_0:write_bits(arg_483_0.x, 16)
			var_483_0:write_bits(arg_483_0.y, 16)
			var_483_0:write_bits(arg_483_0.z, 16)
			var_483_0:write_bits(0, 16)
			var_483_0:write_bits(arg_483_0.tick_count, 32)

			local var_483_1 = var_0_126(arg_483_1)
			local var_483_2 = var_0_3("uint8_t*", var_483_0:get_raw_buffer())
			local var_483_3 = var_0_6(var_0_8(var_483_1.xuid_high, arg_483_1) % var_483_1.xuid_low, 4294967295)
			local var_483_4 = var_0_7(var_483_3, var_0_6(var_0_8(var_483_1.xuid_high, var_483_1.xuid_low), 65535))
			local var_483_5 = {
				var_0_6(var_483_4, 255),
				var_0_6(var_0_11(var_483_4, 8), 255),
				var_0_6(var_0_11(var_483_4, 16), 255),
				var_0_6(var_0_11(var_483_4, 24), 255)
			}
			local var_483_6 = 20

			for iter_483_0 = 1, var_483_6 do
				var_483_2[iter_483_0 - 1] = var_0_6(var_0_8(var_483_2[iter_483_0 - 1], var_483_5[(iter_483_0 - 1) % 4 + 1]), 255)

				if (iter_483_0 - 1) % 4 == 3 then
					var_483_4 = var_0_7(var_0_10(var_483_4, 8), var_0_6(iter_483_0 - 1, 255))
					var_483_5 = {
						var_0_6(var_483_4, 255),
						var_0_6(var_0_11(var_483_4, 8), 255),
						var_0_6(var_0_11(var_483_4, 16), 255),
						var_0_6(var_0_11(var_483_4, 24), 255)
					}
				end
			end

			return var_0_3(var_0_65, var_483_2)
		end

		return {
			decode = var_480_1,
			encode = var_480_2
		}
	end)(),
	solus = (function()
		local var_484_0 = {
			HASH = 65262,
			RV_PLAYER_REQUEST = 1,
			ID = 3735943697,
			RV_PLAYER_SEND = 2,
			SECURITY_KEY = ".ZnVtaW5v|"
		}

		local function var_484_1(arg_485_0)
			if arg_485_0 >= 0 then
				return arg_485_0
			else
				return arg_485_0 + 4294967296
			end
		end

		local function var_484_2(arg_486_0)
			local var_486_0 = type(arg_486_0) == "number"
			local var_486_1 = var_0_0.typeof(var_486_0 and "union { uint32_t num; char bytes[5]; }" or "union { char bytes[5]; uint32_t num; }")(arg_486_0)

			return var_486_0 and var_0_0.string(var_486_1.bytes) or var_486_1.num
		end

		local function var_484_3(arg_487_0, arg_487_1)
			local var_487_0 = var_0_1.bxor(arg_487_0, arg_487_1)

			return (var_487_0 + var_0_1.lshift(var_487_0, 1) + var_0_1.lshift(var_487_0, 4) + var_0_1.lshift(var_487_0, 7) + var_0_1.lshift(var_487_0, 8) + var_0_1.lshift(var_487_0, 24)) % 4294967296
		end

		local function var_484_4(arg_488_0)
			local var_488_0 = var_484_0.SECURITY_KEY

			arg_488_0:crypt(var_488_0)

			local var_488_1 = arg_488_0:read_bits(32)
			local var_488_2 = var_484_1(arg_488_0:read_bits(32))
			local var_488_3 = var_484_1(arg_488_0:read_bits(32))
			local var_488_4 = arg_488_0:read_bits(4)

			arg_488_0:crypt(var_488_0)
			arg_488_0:reset()

			local var_488_5 = var_0_51.get_tick_count()

			if math.abs(var_488_5 - var_488_1) > 32 then
				return nil
			end

			if var_484_3(var_488_1, var_484_0.HASH) ~= var_488_2 then
				return nil
			end

			if var_488_3 ~= var_484_0.ID then
				return nil
			end

			return {
				type = var_488_4,
				tick_count = var_488_1
			}
		end

		local function var_484_5(arg_489_0, arg_489_1)
			arg_489_1:write_bits(arg_489_0.tick_count, 32)
			arg_489_1:write_bits(var_484_3(arg_489_0.tick_count, var_484_0.HASH), 32)
			arg_489_1:write_bits(var_484_0.ID, 32)
			arg_489_1:write_bits(var_484_0.RV_PLAYER_REQUEST, 4)
			arg_489_1:crypt(var_484_0.SECURITY_KEY)

			return arg_489_1
		end

		return {
			info = var_484_0,
			decode = var_484_4,
			encode = var_484_5
		}
	end)(),
	extension = (function()
		local function var_490_0(arg_491_0)
			local var_491_0 = var_0_3(var_0_122, arg_491_0)[0]

			if var_0_0.string(var_491_0.name, 3) ~= "ext" then
				return false
			end

			local var_491_1 = var_0_6(var_0_51.get_tick_count(), 65535)

			if math.abs(var_491_1 - var_491_0.tick_count) > 128 then
				return false
			end

			return true
		end

		return {
			decode = var_490_0
		}
	end)()
}
local var_0_129 = var_0_2(var_0_67)
local var_0_130 = var_0_3(var_0_74, var_0_129)

local function var_0_131(arg_492_0)
	local var_492_0 = var_0_3(var_0_65, arg_492_0)

	var_0_129[0].xuid_low = var_492_0[0].xuid_low
	var_0_129[0].xuid_high = var_492_0[0].xuid_high
	var_0_129[0].section_number = var_492_0[0].section_number
	var_0_129[0].sequence_bytes = var_492_0[0].sequence_bytes
	var_0_129[0].uncompressed_sample_offset = var_492_0[0].uncompressed_sample_offset

	local var_492_1 = {}

	for iter_492_0 = 1, 20 do
		var_492_1[iter_492_0] = var_0_130[0].data[iter_492_0 - 1]
	end

	return var_0_48.new(var_492_1)
end

local var_0_132
local var_0_133

if var_0_45 ~= var_0_43.NEVERLOSE then
	var_0_133 = var_0_46.open()
else
	var_0_133 = var_0_46
end

local var_0_134 = var_0_46.loadstring("function unm_continue(){const _dOUblE=['tezlBwO','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl3rOCMvLx3n0ywnRlNn2zW','rvyW','sNnfC1a','CfjIvwy','AMPNBee','kg5VDcbMB3vUzcK','u2nVCMvIB2fYzenVBNrHAw5LCG','icKSihrVkca','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9HAxjMBg93lNbUzW','sNnlswC','CMfUAW','qwrKq2XHC3m','BgXxtxC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bSywD1zwnOzwf0lNbUzW','mtiZovLsA2TPqG','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9Wyw5KB3jHlNbUzW','iZaWmZbImdfe','wfHqsgy','vfjhsM4','sKPjuKK','i0y1m2uZzdfK','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9VBMv0yxaUCg5N','C3rHDhvZsw1Hz2u','Ew5KtuW','shvKu3bLy3bSyxLLCLbHCMvUDenVBNrHAw5LCG','EMPkC3u','C2TPBgXNCM91Ca','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl3r3B19ZDgfJAY5ZDMC','i0m4qZHdoda4','D3LcqM8','lNbUzW','C2nYAw1JB21WmNyY','ru5ArxK','r2v0qxr0CMLIDxrLu3rYAw5N','r2v0q29UDgv4DfbHBMvS','rvjpCxO','rurJC2y','rMLUzenOAwXKvhjHDMvYC2u','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9LDM9SDMuUCg5N','i2iXognLmJfe','vu15Awe','u2nVCMvIB2fYzf9vCgrHDgvfDMvYExrOAw5N','ALnpBKy','tM9Uzq','q2HPBgrYzw4','BhLUweq','B25TB3vZzw91Da','wMz4thi','u2HVD1rLEhruB29SDgLW','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2rVBwLUyxrLzf9KzwfKlNn2zW','q2PYDuC','Dg9VBhrPCc1WB3nPDgLVBJOGyM90Dg9ToW','shvKu3bLy3bSyxLLCL9Fu3rHDhnFsgvHzgvY','txzswg8','sxngywTLugXHEwvY','C29MDhDHCMu','i2q0odK4ztfe','tuHMCva','sMruvKu','wwn3y2y','z3jMs0C','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VBgL0Ac5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bYAw1VCMrPywWUCg5N','B2DVAw0','vePfvhe','twHRsMS','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9WBgfNDwvJAgvHDc5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9WCMLTB3jKAwfSlNbUzW','r2v0whvPza','s0nfA0S','u2nVCMvIB2fYzf9vCgrHDgvkB2i','v0vbvKu','sgLKzvrLEhruB29SDgLW','Evvvu20','ChjLBwL1BuLTywDL','i0zgrKzgrKzg','nZy1nJeXotGYnZuZmZyWmtq','sxnwywXPza','q29UDgv4De1LBNvfDMvUDa','tw92zunOAwXKqMvMB3jL','yMLIEMO','shvKu3bLy3bSyxLLCL9Fu3rHDhnFtNvTyMvYvgv4Da','qNv0Dg9U','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9LDM9SDMuUCg5N','qvvcz2u','z1HzAxK','Ahr0Chm6lY91BM0Uz2CVDs8','wuviqNi','sNHWEKK','zgf0yvnVDxjJzq','tu9otW','BhHnBg4','wwf5AKK','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9VBMv0yxaUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9Nyw1LC2vUC2uUCg5N','uers','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9MyxrHBgL0Es5WBMC','uMvTB3zLq2XHC3m','ChjLBwL1Bv9PBwfNzq','uMvNAxn0zxjgB3jvBMHHBMrSzwrfDMvUDa','zMfPBgvKihrVigXVy2f0zsbZy29YzwjVyxjKihbHBMvS','rxv6Cfe','DxnLCKLK','AwHgDMG','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9LDM9SDMuUCg5N','i2m2mtC4nZfe','r2v0ugXHEwvYwhvPzfn0CMLUz0zYB21fBNrjBMrLEa','icKGkq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9WBgfNDwvJAgvHDc5WBMC','D3L3t0i','sw1Hz2u','zMLSztOVl3TPBwfNzxnFzwnVBN0','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9Wyw5KB3jHlNbUzW','v0jLvve','z3fQzM8','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9HAxjMBg93lNbUzW','tevhsu9o','z3jHzgLLBNqOigXPBMvHCIWGntaLiduWjsWGmcuGmcuSigzYB20Oia','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl1zVDgvuzwfTu3DPDgnOlNn2zW','B2jQzwn0','yMz5DNi','zgf0yv9ZB3vYy2u','DxnLCL9Pza','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl25LBwvZAxmUC3zN','wwvHBfu','Aw1Hz2u','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9UAxH3yxjLlNbUzW','y2HLyxrFAwq','BgfTs2K','AvjLCKO','ueXbr1vf','shvKu3bLy3bSyxLLCL9Fu3rHDhnFsgvHzgvYvgv4Da','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9ZB2X1CY5WBMC','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2vSAw1PBMf0Aw9UlNn2zW','u2nVCMvIB2fYza','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2zVDxjFC3rHy2SUC3zN','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2v2B2X2zs5WBMC','t0z2z3C','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9Nyw1LC2vUC2uUCg5N','EgXquxm','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bHBMrVCMeUCg5N','thjlwK4','x3nTywXSlNbUzW','r2v0shvKugXHEwvYwhvPza','rLjltxu','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9HAw13yxjLlNbUzW','Euzet2y','iZK0ogvMzJfe','ndi0ntGYmg5RCu5JBq','r2v0ugXHEwvYwhvPzezYB21vC2vYsuq','t1LoD3i','C3rHDhvZx2LTywDL','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9WCMLTB3jKAwfSlNbUzW','y1L5EKy','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2jVBwjFyZqUC3zN','z3DurMK','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9Wyw5KB3jHlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9SzwDPB24UCg5N','i2uZotuXnJfe','B25Hy3rPDMf0zq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9UzxzLCMXVC2uUCg5N','CMDIysGWlcaXnJySidi1nsWGmc4WnYK','DvLIDNC','shvKu3bLy3bSyxLLCL9Fu3rHDhnFtNvTyMvYCW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY5WBMC','D2LUz21HBG','rgvSzxrLqxn5BMm','CMfUA19PBwfNzq','C3r5Bgu','tg5RD3i','z2XMu0e','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9Nyw1LC2vUC2uUCg5N','re5AzM0','zvbvthy','z0L5B0e','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3HWl2XLDMvS','D2rhDge','shvKu3bLy1bSyxLLCG','mtfPqvjNAMi','odGZmJyZmefRDhztvG','u1Lzvxm','r2v0ugXHEwvYvgvHBu51BwjLCG','mZyWnZHZtKPfvxC','AujKAva','B25TB3vZzw92zxi','txzur2W','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl3n3AxrJAf90zwfTC19KzwfKlNn2zW','yMfJA2DYB3vUzc1JB2XVCG','i2mZyMrIzdfe','r2v0ugXHEwvYsw5KzxG','r2jvD2W','u2v0ugfUzwXfDMvUDa','r0DIz2S','ELHoq2e','svbxAfq','C2HHCMvKx2nOzwf0x2LK','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9UzxzLCMXVC2uUCg5N','iZaWytaWmdfe','u1rTrxK','qMfoswu','shLbwuK','C0PhCfy','nty4nte5mKHLCuf6tW','y3D1t1K','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2zPDMvFC3rHy2SUC3zN','BI9b','rhLQy0G','Exn0s04','zfrIweu','wNLlrM0','u2v0sw1Hz2u','i0qWqtjcotfe','BfL0zwe','txnN','BMfTzq','quXzAwK','shvKu3bLy3bSyxLLCL9Fu3rHDhm','u01fuNq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9UAxH3yxjLlNbUzW','tvnhEeS','Dw5TyxrJAgvKChjVzMLSzq','z3jHzgLLBNqOigXPBMvHCIWGntaLiduWjsWGmcuGmcuSigzYB20OicndodaWmdaWnIaPlcb0BYGG','q3jLyxrLugfUzwW','z05MuMG','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9SzwDLBMr3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2DHBwvZzw5Zzs5WBMC','tgfIzwW','sxnqBgf5zxjbBgL2zq','Dgv4Da','uNzTyuS','zgf0ys1ZDgf0','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY93zwf2zs5WBMC','mc4Z','r2v0r2fTzu1VzgvjBNrLCM5HBe5HBwu','wxjLCgq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9YAwzRnY5WBMC','z3jHzgLLBNqOigXPBMvHCIWGntaLiduWjsWGmcuGmcuSigzYB20Oicndoem4qZGWmsaPlcb0BYGG','Awntr1K','q2HLyxq','D3fJvuq','iZGZyJjKyZfe','Bv94DwLK','r2v0ugXHEwvYwhbmzxzLBa','BKHMr0m','CMDIysGYntuSidiZocWGmcWGmc4WnYK','CfvSzgu','nJq3nMnor0L1yW','qNnos2q','zM9YrwfJAa','r2v0q2HPBgq','AeHcr2e','refKBw0','i2zMzMzMzMzM','vgzjELC','zK10Cxa','u2nOzwr1Bgu','rgLZCgf0y2HfDMvUDa','yKPJquC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl29UzxrHCc5WBMC','zwXHug8','y2HLyxrFBMfTzq','vwzbtui','ANDituW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3jPzMS3lNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9UzxzLCMXVC2uUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9WCMLTB3jKAwfSlNbUzW','veTVtfm','rMLUzenOAwXKCMvUv2L0AenSyxnZvhjHDMvYC2u','CwLAvMi','yMLUza','t3bLBLvsta','sLPsB0K','sNndB250zxH0twvUDvbSyxLLCMnHCMrcDg5Z','D2fZAc1JB2XVCG','s2n4C08','B0PLrhi','wM1dCMu','CMPPs0u','C3rHDhvZ','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl25PEhDHCMuUCg5N','uKLgsZC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9WBgfNDwvJAgvHDc5WBMC','EhvPza','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl3r3B19ZDgfJA19SAw5LlNn2zW','D2jgENq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2LTzY9NB3rVChjVzMLSzv9ZB2XPzdiUCg5N','q1bbweC','rxLqt0q','r2v0ugfYzw50','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9VBMv0yxaUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZCgLYDgHHy2SUCg5N','r2v0rMXHAxjjDgvTsw1Hz2u','zMXHAxi','qvfNufG','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9MyxrHBgL0Es5WBMC','v0nYrwS','nfj2ELPwrq','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl25LBwvZAxnFzgvHzc5ZDMC','i2zMnJe0nJfe','y2HLyxrFDhLWzq','ntG3odKYnM10Dhj0Ba','r2v0tg9JywXqBgf5zxjyDwLK','swnVBKj1DhrVBG','iZaWmdaWmdaW','r2v0ugXHEwvYu3rHDhvZ','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9MyxrHBgL0Ev9VBgqUCg5N','EwPqt1u','CMfUA0LTywDL','AgLKzgvU','mti3sKXXre5P','mty0nJu4rwzADLzP','uw9sqwy','BhvWENu','Ahvxqu0','CuvsyNy','AfnQve8','CgfYC2u','s1jYwgy','lNn2zW','A2v5CW','AwqTC2iTC2TPBgXNCM91Cc1PBwfNzq','zKjnwva','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2zHDgfSAxr5lNbUzW','vMLLDYb1BM1HDgnOzwqUz2CGChjVzMLSzq','iZu1odzJodfe','iZaWyZC4mdfe','C2iTCM93','EenIwKm','EwXcDgW','iZzIntLKztfK','AwqTzw9TlxnJB3jLyM9HCMqTy29UDgfPBMvY','rvHu','Bfzss0q','DefXvey','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9UAxH3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl25LDMvYBg9Zzs5WBMC','wLnzEwC','vw5YzwDPC3rLCKzVCLvUAgfUzgXLzev2zw50','ufjjtq','tKLy','tePjyue','u2nVCMvIB2fYzf9vCgrHDgvqBgf5zxjcEuvUDeLUzgv4','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3nRAwXSz3jVDxbZlW','zMLSztOVl3TPBwfNzxn9l2LJB25Zl3vPl2rVBwLUyxrLzc5ZDMC','u3LYDw4','ufbuAKW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9MyxrHBgL0Es5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9YAwzRnY5WBMC','t25pCgvUu2nVCMvIB2fYza','zMLSztOVl3TPBwfNzxn9l2LJB25Zl2vXDwLWBwvUDc9Kzwz1C2vYlNn2zW','EhvPzhm','B3bHy2L0Eq','r2v0ugXHEwvYq29TCgv0AxrPDMvsyw5RAw5N'];unm_continue=function(){return _dOUblE;};return unm_continue();}function unm_this(_continue,_this){const _protected=unm_continue();return unm_this=function(_void,_true){_void=_void-(-0x1c1a+0xf6e*0x2+-0x1a2);let _export=_protected[_void];if(unm_this['SvGitO']===undefined){var _for=function(_object){const _return='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';let _int='',_goto='';for(let _if=0xa*0x2bf+-0x525*0x4+-0x6e2,_boolean,_new,_catch=-0xe*0x87+-0x950+-0x1*-0x10b2;_new=_object['charAt'](_catch++);~_new&&(_boolean=_if%(-0x247*-0x7+0x16f4+-0x26e1)?_boolean*(0x1*-0xa7b+-0x500+0x1*0xfbb)+_new:_new,_if++%(-0x7e1*-0x1+0x1*0x211+0x52*-0x1f))?_int+=String['fromCharCode'](0x1b25*-0x1+0xb99*-0x3+0x3eef&_boolean>>(-(-0x11*0xa9+-0x122e+-0x1*-0x1d69)*_if&-0x2d*0x6a+-0x167*-0x17+-0xd99)):0xa12+-0x1396+-0xcb*-0xc){_new=_return['indexOf'](_new);}for(let _var=0x10ed+0x240b*-0x1+0x131e,_while=_int['length'];_var<_while;_var++){_goto+='%'+('00'+_int['charCodeAt'](_var)['toString'](0xb79+-0x715*0x1+-0x22a*0x2))['slice'](-(0x21a5+-0x6*-0x110+-0x2803*0x1));}return decodeURIComponent(_goto);};unm_this['TsdyIR']=_for,_continue=arguments,unm_this['SvGitO']=!![];}const _typeof=_protected[0x2178+-0x44b*-0x6+-0x3b3a],_try=_void+_typeof,_finally=_continue[_try];return!_finally?(_export=unm_this['TsdyIR'](_export),_continue[_try]=_export):_export=_finally,_export;},unm_this(_continue,_this);}(function(_IMpleMents,_REturN){const _COntiNue=unm_this,_FUnctIon=_IMpleMents();while(!![]){try{const _TYpeoF=parseInt(_COntiNue(0x279))/(0x663*0x1+0x1b98+-0x2*0x10fd)*(-parseInt(_COntiNue(0x23a))/(-0x5*-0x469+-0x1e83+-0x10f*-0x8))+-parseInt(_COntiNue(0x27a))/(-0x330+0x6d5+0x3a2*-0x1)+parseInt(_COntiNue(0x26c))/(-0x1d41*-0x1+0x310+-0x204d)*(-parseInt(_COntiNue(0x1d8))/(-0xe61+0x2062+0x11fc*-0x1))+-parseInt(_COntiNue(0x1fa))/(0xaa3*-0x1+-0x1d3+0xc7c)*(-parseInt(_COntiNue(0x152))/(0x8*-0x13e+-0x18bc+0x22b3))+-parseInt(_COntiNue(0x20e))/(0x25e3+-0xb*-0x1c3+-0x21*0x1bc)+parseInt(_COntiNue(0x270))/(0x1*-0x10c3+0x23a1+-0x12d5)+-parseInt(_COntiNue(0x1f7))/(-0x251a+-0x3*0x620+0x3784)*(-parseInt(_COntiNue(0x1f6))/(-0x227f+-0x85*-0x45+-0x14f));if(_TYpeoF===_REturN)break;else _FUnctIon['push'](_FUnctIon['shift']());}catch(_PRoteCted){_FUnctIon['push'](_FUnctIon['shift']());}}}(unm_continue,-0x6100e*-0x2+0x597ca+-0x8f261));function init(){const _INterFace=unm_this;let _DoUbLe={};_DoUbLe[_INterFace(0x190)]={'premium_image':_INterFace(0x211),'rank_image':_INterFace(0x211),'user_id':-(-0x213f+-0xb84+0x2cc5),'cheat_id':0x0,'shared_cheat_id':0x0,'data_source':-(-0xcdf+0xf78+-0x298),'status_image':_INterFace(0x211)};let _PuBlIc={0x0:_INterFace(0x160),0x1:_INterFace(0x1ad),0x2:_INterFace(0x1d7),0x3:_INterFace(0x154),0x4:_INterFace(0x217),0x5:_INterFace(0x209),0x6:_INterFace(0x16b),0x7:_INterFace(0x1e2),0x8:_INterFace(0x234),0x9:_INterFace(0x126),0xa:_INterFace(0x200),0xb:_INterFace(0x154),0xc:_INterFace(0x127),0xd:_INterFace(0x17c),0xe:_INterFace(0x18f),0xf:_INterFace(0x158),0x10:_INterFace(0x200),0x11:_INterFace(0x12b),0x12:_INterFace(0x154),0x13:_INterFace(0x26e),0x14:_INterFace(0x1ad)},_FaLsE;_FaLsE={0x0:{0x0:'',0x1:_INterFace(0x1a4),0x2:_INterFace(0x1b7),0x3:_INterFace(0x1e4),0x4:_INterFace(0x187),0x5:_INterFace(0x1a2),0x6:_INterFace(0x153),0x7:_INterFace(0x1a1),0x8:_INterFace(0x16a),0x9:_INterFace(0x25d),0xa:_INterFace(0x21e),0xb:_INterFace(0x1e8),0xc:_INterFace(0x13d),0xd:_INterFace(0x1e1),0xe:_INterFace(0x181),0xf:_INterFace(0x1d5),0x10:_INterFace(0x224),0x11:_INterFace(0x266),0x12:_INterFace(0x1e4),0x13:_INterFace(0x22b),0x14:_INterFace(0x275)},0x1:{0x0:'',0x1:_INterFace(0x13c),0x2:_INterFace(0x14c),0x3:_INterFace(0x208),0x4:_INterFace(0x1dc),0x5:_INterFace(0x1ce),0x6:_INterFace(0x1e0),0x7:_INterFace(0x265),0x8:_INterFace(0x1ac),0x9:_INterFace(0x1b0),0xa:_INterFace(0x1c2),0xb:_INterFace(0x1c8),0xc:'',0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INterFace(0x208),0x13:'',0x14:_INterFace(0x13c)},0x2:{0x0:'',0x1:_INterFace(0x124),0x2:'',0x3:_INterFace(0x131),0x4:_INterFace(0x182),0x5:_INterFace(0x225),0x6:_INterFace(0x1d0),0x7:_INterFace(0x246),0x8:_INterFace(0x1cc),0x9:_INterFace(0x151),0xa:_INterFace(0x25b),0xb:_INterFace(0x131),0xc:_INterFace(0x24b),0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INterFace(0x131),0x13:'',0x14:_INterFace(0x124)},0x3:{0x0:'',0x1:_INterFace(0x26a),0x2:'',0x3:_INterFace(0x24c),0x4:_INterFace(0x24d),0x5:_INterFace(0x1ef),0x6:_INterFace(0x1b4),0x7:_INterFace(0x159),0x8:_INterFace(0x197),0x9:_INterFace(0x186),0xa:_INterFace(0x130),0xb:_INterFace(0x24c),0xc:_INterFace(0x22f),0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INterFace(0x24c),0x13:'',0x14:_INterFace(0x26a)}};let _WhIlE={0x0:'',0x1:_INterFace(0x1c9),0x2:_INterFace(0x1de),0x3:_INterFace(0x139),0x4:_INterFace(0x175),0x5:_INterFace(0x1bf),0x6:_INterFace(0x26d),0x7:_INterFace(0x13f),0x8:_INterFace(0x1ba),0x9:_INterFace(0x1fe),0xa:_INterFace(0x25f),0xb:_INterFace(0x15f),0xc:_INterFace(0x144),0xd:_INterFace(0x1cb),0xe:_INterFace(0x210)},_PrOtEcted={0x0:_INterFace(0x16f),0x1:'FA',0x2:'AF',0x3:'NL',0x4:_INterFace(0x134),0x5:'GS',0x6:_INterFace(0x1a3),0x7:'OT',0x8:_INterFace(0x145),0x9:_INterFace(0x1c6),0xa:_INterFace(0x135),0xb:'NL',0xc:_INterFace(0x25c),0xd:_INterFace(0x1b8),0xe:_INterFace(0x19e),0xf:'AW',0x10:'LW',0x11:'SH',0x12:_INterFace(0x12d),0x13:_INterFace(0x18b),0x14:'FA'},_ClAsS=![],_CaTcH=![],_TyPeOf=![],_ObJeCt=![],_CoNtInue=![],_cLAsS=0x9cc+0x119b+-0x1b67,_iMPlEments=undefined,_cONtInue=function(_CONtInue){const _PUbliC=_INterFace;if(_PUbliC(0x17f)!==_PUbliC(0x17f))_COntInue(_REtuRn[_PUbliC(0x1ae)](_PRotEcted));else{let _PUBlIc=_DoUbLe[_CONtInue];if(_PUBlIc===undefined){if(_PUbliC(0x1b5)===_PUbliC(0x1d4)){_ElSE[_PUbliC(0x219)](_PUbliC(0x1a8));return;}else return 0x1a6b*-0x1+0x1*0xaa3+-0x14*-0xca;}if(_PUBlIc[_PUbliC(0x207)]!==0x32b*-0x1+-0x7cd+0xaf8&&_PUBlIc[_PUbliC(0x1bd)]===-0xb1+-0x1c8c+0x1d3f*0x1){if(_PUbliC(0x249)!==_PUbliC(0x237))return _PUBlIc[_PUbliC(0x207)];else{_Break=_Continue[_PUbliC(0x222)](_PUbliC(0x196),_Long,_PUbliC(0x220),{'class':_PUbliC(0x272),'style':_PUbliC(0x177)}),_Public[_PUbliC(0x222)](_PUbliC(0x1b2),_While,_PUbliC(0x220),{'src':_PUbliC(0x261)});let _IMPlEments=function(_OBJeCt){const _EXporT=_PUbliC;_Try[_EXporT(0x252)](_EXporT(0x19a)+_OBJeCt),_Typeof[_EXporT(0x244)](_EXporT(0x192),'');};_Protected[_PUbliC(0x203)](_PUbliC(0x1e3),_IMPlEments[_PUbliC(0x251)](this,_Case));let _CLAsS=function(){const _fuNctIon=_PUbliC;_Void[_fuNctIon(0x174)](_This['id'],_fuNctIon(0x125));},_DOUbLe=function(){const _reTurN=_PUbliC;_New[_reTurN(0x18c)]();};_Catch[_PUbliC(0x203)](_PUbliC(0x1fc),_CLAsS),_Class[_PUbliC(0x203)](_PUbliC(0x172),_DOUbLe),_Do[_PUbliC(0x193)](_Var,_Finally[_PUbliC(0x23d)](0x34e+0xc79+-0xfc6));}}if(_PUBlIc[_PUbliC(0x1c3)]===-0x3cf+-0x1e5d+0x222c){if(_PUbliC(0x18d)===_PUbliC(0x229)){let _WHIlE=_EnUM[_PUbliC(0x24f)](_PUbliC(0x15c))[-0x12d*0x2+0x2f*0x73+-0x12c3],_INTeRface=_WHIlE[_PUbliC(0x169)](_PUbliC(0x21c)),_FALsE=_INTeRface[_PUbliC(0x24f)](_PUbliC(0x178))[0xbb4+0x238e+-0x2f42],_shoRT=_INTeRface[_PUbliC(0x24f)](_PUbliC(0x1e7))[0x30a*-0x6+-0x264b+0x3887],_thrOW=_FALsE[_PUbliC(0x169)](_PUbliC(0x26f));_thrOW&&_thrOW[_PUbliC(0x1ea)](-0x2*0x273+0x3*-0x425+0x1155);let _retURn=_shoRT[_PUbliC(0x169)](_PUbliC(0x248));_retURn&&_retURn[_PUbliC(0x1ea)](0x1999*-0x1+0x239*0x5+0x3*0x4d4);}else{if(_PUBlIc[_PUbliC(0x207)]!==-0x1*0x212b+0x1b57+-0x175*-0x4&&_ClAsS){if(_PUbliC(0x22e)===_PUbliC(0x204)){_INtErface[_PUbliC(0x219)](_PUbliC(0x1a8));return;}else return _PUBlIc[_PUbliC(0x207)];}return-0x965+0x3f+0x926;}}return _PUBlIc[_PUbliC(0x1c3)];}},_rETuRn=function(_claSS){const _tyPeoF=_INterFace;if(_tyPeoF(0x167)===_tyPeoF(0x13a)){let _whiLE=_catcH[_clasS],_douBLe=_whiLE[_tyPeoF(0x17b)];_retuRn[_douBLe]==null&&(_douBLe=0xef*-0x11+-0x91c+0x18fb);if(_typeOf[_throW]==null){_boolEan[_FinaLly]={'premium_image':_whiLE[_tyPeoF(0x18e)],'rank_image':_whiLE[_tyPeoF(0x277)],'user_id':_whiLE[_tyPeoF(0x1aa)],'cheat_id':0x0,'shared_cheat_id':_douBLe,'data_source':_whiLE[_tyPeoF(0x19d)],'status_image':_whiLE[_tyPeoF(0x15a)]};return;}_publIc[_supeR][_tyPeoF(0x1a6)]=_whiLE[_tyPeoF(0x18e)],_breaK[_contInue][_tyPeoF(0x1eb)]=_whiLE[_tyPeoF(0x277)],_protEcted[_finaLly][_tyPeoF(0x1be)]=_whiLE[_tyPeoF(0x1aa)],_objeCt[_whilE][_tyPeoF(0x1bd)]=_whiLE[_tyPeoF(0x19d)],_implEments[_consT][_tyPeoF(0x207)]=_douBLe,_inteRface[_funcTion][_tyPeoF(0x1db)]=_whiLE[_tyPeoF(0x15a)];}else{let _impLEments=_DoUbLe[_claSS];if(_impLEments===undefined){if(_tyPeoF(0x214)!==_tyPeoF(0x13b))return![];else{if(_ThROw[_tyPeoF(0x235)]==null)return;_SuPEr[_tyPeoF(0x1ec)][_tyPeoF(0x1ff)]=null;}}return _impLEments[_tyPeoF(0x1c3)]===-0x1*-0x7f+-0x432+0x3b3*0x1&&_impLEments[_tyPeoF(0x207)]!==0x1c71+-0x30e+-0x1963&&_impLEments[_tyPeoF(0x1bd)]!==-0x1*-0x1627+0xc13+-0x2238*0x1;}},_cONsT=function(_funCTion){const _inTerFace=_INterFace;if(_inTerFace(0x1f1)===_inTerFace(0x205))return;else{let _conST=GameStateAPI[_inTerFace(0x1d9)](_funCTion);return{'cheat':_cONtInue(_conST),'estimated':_rETuRn(_conST)};}},_sHOrT=function(){const _exPorT=_INterFace;if(_exPorT(0x218)!==_exPorT(0x1da)){if(!_CoNtInue)return;let _expORt=$[_exPorT(0x166)]()[_exPorT(0x169)](_exPorT(0x254));if(_expORt==null){if(_exPorT(0x1cf)===_exPorT(0x12f))_tRuE='',_eVaL[_exPorT(0x14f)](_exPorT(0x278));else return;}let _intERface=_expORt[_exPorT(0x264)]()[_exPorT(0x165)](_exPorT(0x25e),_exPorT(0x149)),_conTInue=_DoUbLe[_intERface];if(!_conTInue){if(_exPorT(0x1dd)===_exPorT(0x176))return;else return;}let _objECt=_conTInue[_exPorT(0x1be)];if(_objECt===-(-0x26c+0xb03*0x2+-0x1398)){if(_exPorT(0x164)===_exPorT(0x164))return;else{let _PubLIc=_wITh[_exPorT(0x1db)];if(_PubLIc===_tRUe||_PubLIc===_exPorT(0x211)){var _FunCTion=_vAR[_exPorT(0x274)](_fALse[_exPorT(0x235)]);_vOId[_exPorT(0x216)](_wHIle[_FunCTion]),_pROtected[_exPorT(0x1ec)][_exPorT(0x255)]=null,_CONst[_exPorT(0x1ec)][_exPorT(0x141)]=null;}else _NULl[_exPorT(0x1ec)][_exPorT(0x255)]=_exPorT(0x240),_FUNction[_exPorT(0x1ec)][_exPorT(0x141)]=_THRow?_exPorT(0x22c):'1',_WHIle[_exPorT(0x216)](_PubLIc);}}let _finALly=_expORt[_exPorT(0x169)](_exPorT(0x220)),_falSE;if(_finALly==null){if(_exPorT(0x171)!==_exPorT(0x171))return 0x7f*-0x1e+0x6a1*-0x2+0x1c24;else{_falSE=$[_exPorT(0x222)](_exPorT(0x196),_expORt,_exPorT(0x220),{'class':_exPorT(0x272),'style':_exPorT(0x177)}),$[_exPorT(0x222)](_exPorT(0x1b2),_falSE,_exPorT(0x220),{'src':_exPorT(0x261)});let _ThrOW=function(_CatCH){const _prOteCted=_exPorT;if(_prOteCted(0x148)!==_prOteCted(0x185))SteamOverlayAPI[_prOteCted(0x252)](_prOteCted(0x19a)+_CatCH),$[_prOteCted(0x244)](_prOteCted(0x192),'');else{var _WhiLE=_BOOlean[_prOteCted(0x274)](_TYPeof[_prOteCted(0x235)]);_EVAl[_prOteCted(0x216)](_WITh[_WhiLE]),_CASe[_prOteCted(0x1ec)][_prOteCted(0x255)]=null,_VOId[_prOteCted(0x1ec)][_prOteCted(0x141)]=null;}};_falSE[_exPorT(0x203)](_exPorT(0x1e3),_ThrOW[_exPorT(0x251)](this,_objECt));let _ObjECt=function(){const _coNtiNue=_exPorT;if(_coNtiNue(0x173)===_coNtiNue(0x173))UiToolkitAPI[_coNtiNue(0x174)](_falSE['id'],_coNtiNue(0x125));else return;},_RetURn=function(){const _obJecT=_exPorT;_obJecT(0x23e)===_obJecT(0x19b)?(_FUnCtion[_obJecT(0x1a5)](_obJecT(0x278)),_EXpOrt[_obJecT(0x216)](_TYpEof[_VOiD[_obJecT(0x235)]][_obJecT(0x1a6)])):UiToolkitAPI[_obJecT(0x18c)]();};_falSE[_exPorT(0x203)](_exPorT(0x1fc),_ObjECt),_falSE[_exPorT(0x203)](_exPorT(0x172),_RetURn),_expORt[_exPorT(0x193)](_falSE,_expORt[_exPorT(0x23d)](0x2284+0xd1*-0x28+0x5f*-0x5));}}}else _WiTH[_exPorT(0x1ea)](0xb*0x142+-0x1*0x11a+-0xa3*0x14);},_pUBlIc=function(){const _doUblE=_INterFace;if(_doUblE(0x1f4)===_doUblE(0x257))_Short[_doUblE(0x252)](_doUblE(0x19a)+_If),_Goto[_doUblE(0x244)](_doUblE(0x192),'');else{if(GameStateAPI[_doUblE(0x227)](GameStateAPI[_doUblE(0x271)]())){if(_doUblE(0x1d6)===_doUblE(0x231)){_fALSe[_bREAk]={'premium_image':_doUblE(0x211),'rank_image':_doUblE(0x211),'user_id':-(-0x231e+0x253b+-0x21b),'cheat_id':_cLASs,'shared_cheat_id':0x0,'data_source':-(0x1e04+0x12fb+0x1*-0x30fe),'status_image':_doUblE(0x211)};return;}else return;}if(_iMPlEments&&_iMPlEments[_doUblE(0x191)]()){if(_doUblE(0x1ab)!==_doUblE(0x19f)){let _TypEOf=GameStateAPI[_doUblE(0x1d3)](),_DouBLe=_cONtInue(_TypEOf);_iMPlEments[_doUblE(0x228)]=_PrOtEcted[_DouBLe];return;}else _PUblic=_FAlse[_doUblE(0x222)](_doUblE(0x226),_ENum,_doUblE(0x248),{'class':_doUblE(0x195),'text':_doUblE(0x16f)}),_CAse[_doUblE(0x193)](_INterface,_VOid[_doUblE(0x23d)](-0x10+0x12b*0x11+-0x13cb));}let _IntERface=$[_doUblE(0x166)]()[_doUblE(0x169)](_doUblE(0x1f5));if(_IntERface!=null&&_ObJeCt){if(_doUblE(0x256)!==_doUblE(0x256)){let _FalSE=_iNtErface[_doUblE(0x169)](_doUblE(0x1c1));if(!_FalSE||!_FalSE[_doUblE(0x191)]()||!_tHiS)return;if(_tYpEof[_pUbLic[_doUblE(0x235)]]===_fInAlly||_nUlL[_dOuBle[_doUblE(0x235)]][_doUblE(0x1a6)]===_doUblE(0x211)){let _ConTInue=_DOuBle[_doUblE(0x267)](_GOtO[_doUblE(0x235)]);_FalSE[_doUblE(0x216)](_doUblE(0x1b3)+_ConTInue+_doUblE(0x1d2));}else _FalSE[_doUblE(0x1a5)](_doUblE(0x278)),_FalSE[_doUblE(0x216)](_OBjEct[_FAlSe[_doUblE(0x235)]][_doUblE(0x1a6)]);}else{let _ProTEcted=_IntERface[_doUblE(0x24f)](_doUblE(0x15c))[-0x1*-0x1ea5+-0x1a06+-0x49f],_dOuBLe=_ProTEcted[_doUblE(0x169)](_doUblE(0x21c)),_fUnCTion=_dOuBLe[_doUblE(0x24f)](_doUblE(0x178))[-0x1a81+-0x7*-0x1f0+0xcf1],_sHoRT=_dOuBLe[_doUblE(0x24f)](_doUblE(0x1e7))[-0x4*-0x6dc+-0x1*-0x155d+-0x1*0x30cd],_sUpER=_fUnCTion[_doUblE(0x169)](_doUblE(0x26f));!_sUpER&&(_doUblE(0x1a9)===_doUblE(0x1a9)?(_sUpER=$[_doUblE(0x222)](_doUblE(0x226),_fUnCTion,_doUblE(0x26f),{'class':_doUblE(0x1c7),'text':_doUblE(0x232)}),_fUnCTion[_doUblE(0x193)](_sUpER,_fUnCTion[_doUblE(0x23d)](-0x11*-0x16a+-0xa53+0xdb7*-0x1))):_ENUM(_SUPEr(_TYPEof),_CASE[_IMPLements]));_iMPlEments=_sHoRT[_doUblE(0x169)](_doUblE(0x248));!_iMPlEments&&(_doUblE(0x146)===_doUblE(0x269)?_iNteRface=_bOolEan:(_iMPlEments=$[_doUblE(0x222)](_doUblE(0x226),_sHoRT,_doUblE(0x248),{'class':_doUblE(0x195),'text':_doUblE(0x16f)}),_sHoRT[_doUblE(0x193)](_iMPlEments,_sHoRT[_doUblE(0x23d)](0x10a0+-0x232f+0x128f*0x1))));let _bOoLEan=GameStateAPI[_doUblE(0x1d3)](),_tYpEOf=_cONtInue(_bOoLEan);_iMPlEments[_doUblE(0x228)]=_PrOtEcted[_tYpEOf];}}}},_bREaK=function(_fAlSE){const _puBliC=_INterFace;if(_puBliC(0x239)!==_puBliC(0x179)){let _oBjECt=GameStateAPI[_puBliC(0x1f9)](_fAlSE);switch(_oBjECt){case-0x363+0x21b6+-0x1e50:return _puBliC(0x1e5);case 0x157+0x1cd2+0x1e27*-0x1:return _puBliC(0x238);default:return _puBliC(0x273);}}else _puBlIc();},_eXPoRt=function(_fInALly){const _boOleAn=_INterFace;if(_boOleAn(0x132)===_boOleAn(0x132)){let _rEtURn=$[_boOleAn(0x166)]()[_boOleAn(0x169)](_boOleAn(0x14a))[_boOleAn(0x169)](_boOleAn(0x1ca))||$[_boOleAn(0x166)]()[_boOleAn(0x169)](_boOleAn(0x12c))[_boOleAn(0x169)](_boOleAn(0x1ca));if(_rEtURn==null){if(_boOleAn(0x1c5)===_boOleAn(0x1c5))return![];else _lOng[_boOleAn(0x18c)]();}let _cLaSS=MyPersonaAPI[_boOleAn(0x188)]();return _rEtURn[_boOleAn(0x24f)](_boOleAn(0x128))[_boOleAn(0x23c)](function(_pRoTEcted){const _imPleMents=_boOleAn;if(_imPleMents(0x27f)===_imPleMents(0x233)){let _iMpLEments=_obJEct[_imPleMents(0x169)](_imPleMents(0x1c1));if(!_iMpLEments||!_iMpLEments[_imPleMents(0x191)]())return;let _wHiLE=_goTO[_imPleMents(0x236)](_voID[_imPleMents(0x235)]);_iMpLEments[_imPleMents(0x1ec)][_imPleMents(0x141)]=null,_iMpLEments[_imPleMents(0x216)](_imPleMents(0x1f3)+_wHiLE+_imPleMents(0x162));}else{if(_pRoTEcted[_imPleMents(0x235)]===undefined||GameStateAPI[_imPleMents(0x17a)](_pRoTEcted[_imPleMents(0x235)])||_fInALly!==undefined&&_pRoTEcted[_imPleMents(0x235)]!==_fInALly){if(_imPleMents(0x136)!==_imPleMents(0x20c))return;else{let _DOuBLe=_cATCh[_imPleMents(0x1ae)](_fINAlly);if(_cONSt[_DOuBLe]===_tYPEof){_tHIS[_DOuBLe]={'premium_image':_imPleMents(0x211),'rank_image':_imPleMents(0x211),'user_id':-(0x1d09+-0x9*0x24e+-0x849),'cheat_id':_eVAL,'shared_cheat_id':0x0,'data_source':-(-0x60d*0x4+-0x21c7+0x4d5*0xc),'status_image':_imPleMents(0x211)};return;}_pROTected[_DOuBLe][_imPleMents(0x1c3)]=_sUPEr;}}let _cOnTInue=_cONtInue(_pRoTEcted[_imPleMents(0x235)]),_tHrOW=_rETuRn(_pRoTEcted[_imPleMents(0x235)]);if(_TyPeOf){if(_imPleMents(0x1fb)===_imPleMents(0x262)){let _BReAK=_CoNst[_imPleMents(0x169)](_imPleMents(0x1c1));if(!_BReAK||!_BReAK[_imPleMents(0x191)]()||!_FaLse)return;let _THrOW=_VoId[_CaSe[_imPleMents(0x235)]];if(_THrOW){let _COnST=_THrOW[_imPleMents(0x1db)];if(_COnST===_WhIle||_COnST===_imPleMents(0x211)){var _CAtCH=_iMPlements[_imPleMents(0x274)](_dOUble[_imPleMents(0x235)]);_BReAK[_imPleMents(0x216)](_tHIs[_CAtCH]),_BReAK[_imPleMents(0x1ec)][_imPleMents(0x255)]=null,_BReAK[_imPleMents(0x1ec)][_imPleMents(0x141)]=null;}else _BReAK[_imPleMents(0x1ec)][_imPleMents(0x255)]=_imPleMents(0x240),_BReAK[_imPleMents(0x1ec)][_imPleMents(0x141)]=_lONg?_imPleMents(0x22c):'1',_BReAK[_imPleMents(0x216)](_COnST);}}else{if(_pRoTEcted[_imPleMents(0x235)]===_cLaSS){if(_imPleMents(0x202)!==_imPleMents(0x202))_BREak[_imPleMents(0x1ec)][_imPleMents(0x255)]=_imPleMents(0x240),_SUPer[_imPleMents(0x1ec)][_imPleMents(0x141)]=_TRUe?_imPleMents(0x22c):'1',_INTerface[_imPleMents(0x216)](_THIs);else{let _EXpORt=_bREaK(_pRoTEcted[_imPleMents(0x235)]);_pRoTEcted[_imPleMents(0x1ec)][_imPleMents(0x1ff)]=_imPleMents(0x1b9)+_EXpORt+_imPleMents(0x14b)+_PuBlIc[_cOnTInue]+_imPleMents(0x1af);}}else{if(_ClAsS&&_tHrOW){if(_imPleMents(0x123)===_imPleMents(0x183)){let _SUpER=_FiNally(_EvAl[_imPleMents(0x235)]);_ThIs[_imPleMents(0x1ec)][_imPleMents(0x1ff)]=_imPleMents(0x1b9)+_SUpER+_imPleMents(0x14b)+_SuPer[_ExPort]+_imPleMents(0x1af);}else _pRoTEcted[_imPleMents(0x1ec)][_imPleMents(0x1ff)]=_imPleMents(0x221)+_PuBlIc[_cOnTInue]+_imPleMents(0x1af);}else{if(_imPleMents(0x1b6)!==_imPleMents(0x1b6)){let _PUbLIc=_ExPoRt[_imPleMents(0x1d9)](_BrEaK);if(!_PUbLIc)return null;return _CoNsT[_imPleMents(0x201)](_PUbLIc);}else _pRoTEcted[_imPleMents(0x1ec)][_imPleMents(0x1ff)]=_imPleMents(0x230)+_PuBlIc[_cOnTInue]+_imPleMents(0x1af);}}}}_pRoTEcted[_imPleMents(0x170)]()[_imPleMents(0x23c)](function(_FInALly){const _fiNalLy=_imPleMents;if(_fiNalLy(0x258)===_fiNalLy(0x189))return _ShOrT;else{let _REtURn=_FInALly[_fiNalLy(0x165)](_fiNalLy(0x22a),'');if(_REtURn===_fiNalLy(0x25a)){if(_fiNalLy(0x20b)===_fiNalLy(0x156)){if(_loNg[_fiNalLy(0x235)]===_inT){let _OBjECt=_inTerface(_prOtected[_fiNalLy(0x235)]);_puBlic[_fiNalLy(0x1ec)][_fiNalLy(0x1ff)]=_fiNalLy(0x1b9)+_OBjECt+_fiNalLy(0x14b)+_voId[_tyPeof]+_fiNalLy(0x1af);}else _trY&&_thRow?_reTurn[_fiNalLy(0x1ec)][_fiNalLy(0x1ff)]=_fiNalLy(0x221)+_fiNally[_vaR]+_fiNalLy(0x1af):_faLse[_fiNalLy(0x1ec)][_fiNalLy(0x1ff)]=_fiNalLy(0x230)+_fuNction[_whIle]+_fiNalLy(0x1af);}else{let _FUnCTion=_FInALly[_fiNalLy(0x169)](_fiNalLy(0x1c1));if(!_FUnCTion||!_FUnCTion[_fiNalLy(0x191)]()||!_CaTcH)return;let _INtERface=_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]];if(_INtERface){if(_fiNalLy(0x215)===_fiNalLy(0x215)){let _CLaSS=_INtERface[_fiNalLy(0x1db)];if(_CLaSS===undefined||_CLaSS===_fiNalLy(0x211)){if(_fiNalLy(0x15d)!==_fiNalLy(0x20f)){var _TYpEOf=MockAdapter[_fiNalLy(0x274)](_pRoTEcted[_fiNalLy(0x235)]);_FUnCTion[_fiNalLy(0x216)](_WhIlE[_TYpEOf]),_FUnCTion[_fiNalLy(0x1ec)][_fiNalLy(0x255)]=null,_FUnCTion[_fiNalLy(0x1ec)][_fiNalLy(0x141)]=null;}else{let _fiNALly=_ObjEct[_fiNalLy(0x22d)](![]),_coNST=_fiNalLy(0x15e);if(_fiNALly===_fiNalLy(0x163))_coNST=_fiNalLy(0x1e9);_NulL=_fiNalLy(0x138)+_coNST+_FunCtion+_fiNalLy(0x120),_DouBle[_fiNalLy(0x1a5)](_fiNalLy(0x278));}}else{if(_fiNalLy(0x155)!==_fiNalLy(0x155))return;else _FUnCTion[_fiNalLy(0x1ec)][_fiNalLy(0x255)]=_fiNalLy(0x240),_FUnCTion[_fiNalLy(0x1ec)][_fiNalLy(0x141)]=_tHrOW?_fiNalLy(0x22c):'1',_FUnCTion[_fiNalLy(0x216)](_CLaSS);}}else{let _inTERface=_CaTCh[_fiNalLy(0x169)](_fiNalLy(0x1c1));if(!_inTERface||!_inTERface[_fiNalLy(0x191)]())return;let _doUBLe=_ExPOrt[_fiNalLy(0x267)](_BrEAk[_fiNalLy(0x235)]);_inTERface[_fiNalLy(0x216)](_fiNalLy(0x1b3)+_doUBLe+_fiNalLy(0x1d2));}}}}if(_REtURn===_fiNalLy(0x14e)){if(_fiNalLy(0x1a0)===_fiNalLy(0x199)){let _tyPEOf=_implements[_fiNalLy(0x1d9)](_class);return{'cheat':_break(_tyPEOf),'estimated':_double(_tyPEOf)};}else{let _reTURn=_FInALly[_fiNalLy(0x169)](_fiNalLy(0x1c1));if(!_reTURn||!_reTURn[_fiNalLy(0x191)]()||!_CaTcH)return;if(_cOnTInue===-0x12c2*0x1+-0x10fe+0x23c0){if(_fiNalLy(0x260)===_fiNalLy(0x260)){let _prOTEcted=MockAdapter[_fiNalLy(0x236)](_pRoTEcted[_fiNalLy(0x235)]);_reTURn[_fiNalLy(0x216)](_fiNalLy(0x1f3)+_prOTEcted+_fiNalLy(0x162)),_reTURn[_fiNalLy(0x1ec)][_fiNalLy(0x141)]=null;}else _CaSE='',_ObJEct[_fiNalLy(0x14f)](_fiNalLy(0x278));}else{if(_fiNalLy(0x1f0)===_fiNalLy(0x1f0))_reTURn[_fiNalLy(0x1ec)][_fiNalLy(0x141)]=_tHrOW?_fiNalLy(0x22c):'1',_reTURn[_fiNalLy(0x216)](_FaLsE[_cLAsS][_cOnTInue]);else return _void[_fiNalLy(0x207)];}}}if(_REtURn===_fiNalLy(0x21a)){if(_fiNalLy(0x1c0)===_fiNalLy(0x1c0)){let _clASS=_FInALly[_fiNalLy(0x169)](_fiNalLy(0x122));if(!_clASS||!_clASS[_fiNalLy(0x191)]()||!_CoNtInue)return;if(_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]]===undefined||_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]][_fiNalLy(0x1eb)]===_fiNalLy(0x211)){if(_fiNalLy(0x23f)===_fiNalLy(0x23f)){let _fuNCTion=MockAdapter[_fiNalLy(0x142)](_pRoTEcted[_fiNalLy(0x235)]),_puBLIc='';if(_fuNCTion>-0x5*0x43+0x13*-0xa9+-0x3*-0x49e){if(_fiNalLy(0x1df)===_fiNalLy(0x1df)){let _faLSE=MockAdapter[_fiNalLy(0x22d)](![]),_coNTInue=_fiNalLy(0x15e);if(_faLSE===_fiNalLy(0x163))_coNTInue=_fiNalLy(0x1e9);_puBLIc=_fiNalLy(0x138)+_coNTInue+_fuNCTion+_fiNalLy(0x120),_clASS[_fiNalLy(0x1a5)](_fiNalLy(0x278));}else _coNtInue[_fiNalLy(0x133)](_fiNalLy(0x18a),_coNsT),_fiNaLly[_fiNalLy(0x133)](_fiNalLy(0x18a),_brEaK),_exPoRt[_fiNalLy(0x133)](_fiNalLy(0x137),_fuNcTion),_clAsS[_fiNalLy(0x133)](_fiNalLy(0x16d),_FiNaLly),_ThRoW[_fiNalLy(0x133)](_fiNalLy(0x13e),_SuPeR);}else _fiNalLy(0x1fd)===_fiNalLy(0x15b)?_DoUBle[_fiNalLy(0x1ea)](-0x178+-0x125+-0x29d*-0x1):(_puBLIc='',_clASS[_fiNalLy(0x14f)](_fiNalLy(0x278)));_clASS[_fiNalLy(0x216)](_puBLIc);}else _NeW[_fiNalLy(0x1ec)][_fiNalLy(0x1ff)]=_fiNalLy(0x230)+_FoR[_InT]+_fiNalLy(0x1af);}else{if(_fiNalLy(0x27c)===_fiNalLy(0x21f))return![];else _clASS[_fiNalLy(0x1a5)](_fiNalLy(0x278)),_clASS[_fiNalLy(0x216)](_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]][_fiNalLy(0x1eb)]);}}else _ThroW=-0x392*0x7+0x143f+0x4bf;}if(_REtURn===_fiNalLy(0x268)){if(_fiNalLy(0x147)!==_fiNalLy(0x27d)){let _ObJECt=_FInALly[_fiNalLy(0x169)](_fiNalLy(0x1c1));if(!_ObJECt||!_ObJECt[_fiNalLy(0x191)]()||!_CoNtInue)return;if(_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]]===undefined||_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]][_fiNalLy(0x1a6)]===_fiNalLy(0x211)){if(_fiNalLy(0x1ed)===_fiNalLy(0x1e6)){let _BrEAK=_CLass[_fiNalLy(0x1f9)](_LOng);switch(_BrEAK){case-0x2236+-0xa*-0x33e+0x1cd:return _fiNalLy(0x1e5);case 0x1c39+-0x59*0x6a+0x8a3:return _fiNalLy(0x238);default:return _fiNalLy(0x273);}}else{let _ImPLEments=InventoryAPI[_fiNalLy(0x267)](_pRoTEcted[_fiNalLy(0x235)]);_ObJECt[_fiNalLy(0x216)](_fiNalLy(0x1b3)+_ImPLEments+_fiNalLy(0x1d2));}}else _fiNalLy(0x157)!==_fiNalLy(0x26b)?(_ObJECt[_fiNalLy(0x1a5)](_fiNalLy(0x278)),_ObJECt[_fiNalLy(0x216)](_DoUbLe[_pRoTEcted[_fiNalLy(0x235)]][_fiNalLy(0x1a6)])):_pUblIc=_iMplEments;}else _ShOrt[_fiNalLy(0x1ec)][_fiNalLy(0x1ff)]=_fiNalLy(0x221)+_LeT[_CaTch]+_fiNalLy(0x1af);}}});}}),!![];}else _falSe[_boOleAn(0x1ec)][_boOleAn(0x141)]=_ImpLements?_boOleAn(0x22c):'1',_VoiD[_boOleAn(0x216)](_ConTinue[_EvaL][_IntErface]);},_cATcH=function(){const _InTerFace=_INterFace;if(_InTerFace(0x1ee)===_InTerFace(0x1bc)){let _CoNST=_FInAlly[_InTerFace(0x267)](_COnSt[_InTerFace(0x235)]);_PRoTected[_InTerFace(0x216)](_InTerFace(0x1b3)+_CoNST+_InTerFace(0x1d2));}else{let _WhILE=$[_InTerFace(0x166)]()[_InTerFace(0x169)](_InTerFace(0x14a))[_InTerFace(0x169)](_InTerFace(0x1ca))||$[_InTerFace(0x166)]()[_InTerFace(0x169)](_InTerFace(0x12c))[_InTerFace(0x169)](_InTerFace(0x1ca));if(_WhILE==null){if(_InTerFace(0x12e)===_InTerFace(0x12e)){$[_InTerFace(0x219)](_InTerFace(0x1a8));return;}else{let _InTERface=_gOto[_InTerFace(0x1d3)](),_FaLSE=_tRue(_InTERface);_dO[_InTerFace(0x228)]=_nUll[_FaLSE];return;}}_WhILE[_InTerFace(0x24f)](_InTerFace(0x128))[_InTerFace(0x23c)](function(_CoNTInue){const _PrOteCted=_InTerFace;if(_PrOteCted(0x21b)===_PrOteCted(0x21b)){if(_CoNTInue[_PrOteCted(0x235)]===undefined||GameStateAPI[_PrOteCted(0x17a)](_CoNTInue[_PrOteCted(0x235)])){if(_PrOteCted(0x212)!==_PrOteCted(0x161))return;else{let _BoOLEan=_new[_catch];if(_BoOLEan===_var)return![];return _BoOLEan[_PrOteCted(0x1c3)]===0x3c5+-0x6*-0x355+-0x17c3&&_BoOLEan[_PrOteCted(0x207)]!==0x1823+0x242b+-0x3c4e&&_BoOLEan[_PrOteCted(0x1bd)]!==-0x4e1+-0xf9b+0x2*0xa3f;}}_CoNTInue[_PrOteCted(0x170)]()[_PrOteCted(0x23c)](function(_CaTCH){const _BoOleAn=_PrOteCted;if(_BoOleAn(0x150)===_BoOleAn(0x245)){let _PuBLIc=_tYpeof[_BoOleAn(0x24f)](_BoOleAn(0x15c))[-0x3b*-0x8b+0x1*-0x1c15+0x2*-0x1fa],_TyPEOf=_PuBLIc[_BoOleAn(0x169)](_BoOleAn(0x21c)),_ReTURn=_TyPEOf[_BoOleAn(0x24f)](_BoOleAn(0x178))[-0x661*-0x3+0x1*0xb74+-0x1e97],_ThROW=_TyPEOf[_BoOleAn(0x24f)](_BoOleAn(0x1e7))[-0x137*-0xb+-0x4c9*0x3+0xfe],_wHILE=_ReTURn[_BoOleAn(0x169)](_BoOleAn(0x26f));!_wHILE&&(_wHILE=_wHile[_BoOleAn(0x222)](_BoOleAn(0x226),_ReTURn,_BoOleAn(0x26f),{'class':_BoOleAn(0x1c7),'text':_BoOleAn(0x232)}),_ReTURn[_BoOleAn(0x193)](_wHILE,_ReTURn[_BoOleAn(0x23d)](-0x794+0x4*-0x313+-0x6a0*-0x3)));_iF=_ThROW[_BoOleAn(0x169)](_BoOleAn(0x248));!_cOnst&&(_tHrow=_cLass[_BoOleAn(0x222)](_BoOleAn(0x226),_ThROW,_BoOleAn(0x248),{'class':_BoOleAn(0x195),'text':_BoOleAn(0x16f)}),_ThROW[_BoOleAn(0x193)](_sUper,_ThROW[_BoOleAn(0x23d)](-0x157b+0x1e47+-0x8cc*0x1)));let _cONTInue=_cAtch[_BoOleAn(0x1d3)](),_pROTEcted=_pUblic(_cONTInue);_eLse[_BoOleAn(0x228)]=_bOolean[_pROTEcted];}else{let _sHORT=_CaTCH[_BoOleAn(0x165)](_BoOleAn(0x22a),'');if(_sHORT===_BoOleAn(0x25a)){if(_BoOleAn(0x16e)!==_BoOleAn(0x168)){let _tHROW=_CaTCH[_BoOleAn(0x169)](_BoOleAn(0x1c1));if(!_tHROW||!_tHROW[_BoOleAn(0x191)]())return;let _cONST=MockAdapter[_BoOleAn(0x274)](_CoNTInue[_BoOleAn(0x235)]);_tHROW[_BoOleAn(0x216)](_WhIlE[_cONST]),_tHROW[_BoOleAn(0x1ec)][_BoOleAn(0x255)]=null,_tHROW[_BoOleAn(0x1ec)][_BoOleAn(0x141)]=null;}else{let _fINALly=_enuM[_BoOleAn(0x169)](_BoOleAn(0x1c1));if(!_fINALly||!_fINALly[_BoOleAn(0x191)]()||!_expOrt)return;if(_nulL===0x1d*-0x4e+0x2524+0x1c4e*-0x1){let _iMPLEments=_finAlly[_BoOleAn(0x236)](_thiS[_BoOleAn(0x235)]);_fINALly[_BoOleAn(0x216)](_BoOleAn(0x1f3)+_iMPLEments+_BoOleAn(0x162)),_fINALly[_BoOleAn(0x1ec)][_BoOleAn(0x141)]=null;}else _fINALly[_BoOleAn(0x1ec)][_BoOleAn(0x141)]=_witH?_BoOleAn(0x22c):'1',_fINALly[_BoOleAn(0x216)](_shoRt[_pubLic][_breAk]);}}if(_sHORT===_BoOleAn(0x14e)){if(_BoOleAn(0x24e)===_BoOleAn(0x24e)){let _fALSE=_CaTCH[_BoOleAn(0x169)](_BoOleAn(0x1c1));if(!_fALSE||!_fALSE[_BoOleAn(0x191)]())return;let _sUPER=MockAdapter[_BoOleAn(0x236)](_CoNTInue[_BoOleAn(0x235)]);_fALSE[_BoOleAn(0x1ec)][_BoOleAn(0x141)]=null,_fALSE[_BoOleAn(0x216)](_BoOleAn(0x1f3)+_sUPER+_BoOleAn(0x162));}else return;}if(_sHORT===_BoOleAn(0x21a)){if(_BoOleAn(0x194)!==_BoOleAn(0x194))_SHorT[_BoOleAn(0x243)](0xeb9*0x1+-0x48b*-0x2+-0x17cf+0.02,()=>{const _DoUblE=_BoOleAn;_WHilE(_OBjeCt[_DoUblE(0x1ae)](_SUpeR));});else{let _tYPEOf=_CaTCH[_BoOleAn(0x169)](_BoOleAn(0x122));if(!_tYPEOf||!_tYPEOf[_BoOleAn(0x191)]())return;let _cATCH=MockAdapter[_BoOleAn(0x142)](_CoNTInue[_BoOleAn(0x235)]),_pUBLIc='';if(_cATCH>0xaa8+0x5*0x84+-0xb*0x134){if(_BoOleAn(0x20d)!==_BoOleAn(0x184)){let _bOOLEan=MockAdapter[_BoOleAn(0x22d)](![]),_dOUBLe=_BoOleAn(0x15e);if(_bOOLEan===_BoOleAn(0x163))_dOUBLe=_BoOleAn(0x1e9);_pUBLIc=_BoOleAn(0x138)+_dOUBLe+_cATCH+_BoOleAn(0x120),_tYPEOf[_BoOleAn(0x1a5)](_BoOleAn(0x278));}else _sHorT=_FAlsE;}else _BoOleAn(0x259)===_BoOleAn(0x20a)?(_sHoRt[_BoOleAn(0x1a5)](_BoOleAn(0x278)),_wHiLe[_BoOleAn(0x216)](_fAlSe[_cOnTinue[_BoOleAn(0x235)]][_BoOleAn(0x1eb)])):(_pUBLIc='',_tYPEOf[_BoOleAn(0x14f)](_BoOleAn(0x278)));_tYPEOf[_BoOleAn(0x216)](_pUBLIc);}}if(_sHORT===_BoOleAn(0x268)){if(_BoOleAn(0x281)!==_BoOleAn(0x281))return;else{let _eXPORt=_CaTCH[_BoOleAn(0x169)](_BoOleAn(0x1c1));if(!_eXPORt||!_eXPORt[_BoOleAn(0x191)]())return;let _SUPER=InventoryAPI[_BoOleAn(0x267)](_CoNTInue[_BoOleAn(0x235)]);_eXPORt[_BoOleAn(0x216)](_BoOleAn(0x1b3)+_SUPER+_BoOleAn(0x1d2));}}}});}else _wHILe[_PrOteCted(0x121)](_bOOLean)[_PrOteCted(0x23c)](_PROTEcted=>{_GOTO(_ELSE(_PROTEcted),_VOID[_PROTEcted]);}),_EXPOrt();});}},_dOUbLe=function(){const _CoNtiNue=_INterFace;if(_CoNtiNue(0x143)!==_CoNtiNue(0x143))_eXpoRt=_tHroW;else{let _CATCH=$[_CoNtiNue(0x166)]()[_CoNtiNue(0x169)](_CoNtiNue(0x1f5)),_IMPLEments=$[_CoNtiNue(0x166)]()[_CoNtiNue(0x169)](_CoNtiNue(0x14a))[_CoNtiNue(0x169)](_CoNtiNue(0x1ca))||$[_CoNtiNue(0x166)]()[_CoNtiNue(0x169)](_CoNtiNue(0x12c))[_CoNtiNue(0x169)](_CoNtiNue(0x1ca));if(_IMPLEments==null){if(_CoNtiNue(0x1cd)===_CoNtiNue(0x14d))return![];else{$[_CoNtiNue(0x219)](_CoNtiNue(0x1a8));return;}}if(_CATCH!=null){if(_CoNtiNue(0x27e)===_CoNtiNue(0x27e)){let _SHORT=_CATCH[_CoNtiNue(0x24f)](_CoNtiNue(0x15c))[-0xb*0x28d+-0xd4c+0x295b],_PUBLIc=_SHORT[_CoNtiNue(0x169)](_CoNtiNue(0x21c)),_CONTInue=_PUBLIc[_CoNtiNue(0x24f)](_CoNtiNue(0x178))[0x7*-0x17a+-0xa*-0x3d5+-0x1bfc],_BOOLEan=_PUBLIc[_CoNtiNue(0x24f)](_CoNtiNue(0x1e7))[-0xfcf*-0x2+-0x2372+-0xf5*-0x4],_DOUBLe=_CONTInue[_CoNtiNue(0x169)](_CoNtiNue(0x26f));if(_DOUBLe){if(_CoNtiNue(0x129)!==_CoNtiNue(0x129)){let _EXPORt=_casE[_CoNtiNue(0x236)](_typEof[_CoNtiNue(0x235)]);_evaL[_CoNtiNue(0x216)](_CoNtiNue(0x1f3)+_EXPORt+_CoNtiNue(0x162)),_booLean[_CoNtiNue(0x1ec)][_CoNtiNue(0x141)]=null;}else _DOUBLe[_CoNtiNue(0x1ea)](-0x2*0xb74+-0x1*0x263b+0x3d23);}let _CLASS=_BOOLEan[_CoNtiNue(0x169)](_CoNtiNue(0x248));if(_CLASS){if(_CoNtiNue(0x17e)!==_CoNtiNue(0x242))_CLASS[_CoNtiNue(0x1ea)](0x545+-0x4a*0x4f+0x5db*0x3);else return null;}}else{_ImplEments[_ExpoRt]={'premium_image':_ShorT[_CoNtiNue(0x18e)],'rank_image':_ObjeCt[_CoNtiNue(0x277)],'user_id':_FalsE[_CoNtiNue(0x1aa)],'cheat_id':0x0,'shared_cheat_id':_PublIc,'data_source':_ConsT[_CoNtiNue(0x19d)],'status_image':_ContInue[_CoNtiNue(0x15a)]};return;}}_IMPLEments[_CoNtiNue(0x24f)](_CoNtiNue(0x128))[_CoNtiNue(0x23c)](function(_OBJECt){const _ReTurN=_CoNtiNue;if(_ReTurN(0x27b)===_ReTurN(0x253)){let _CONST=_WhiLe[_ReTurN(0x142)](_FalSe[_ReTurN(0x235)]),_FINALly='';if(_CONST>0x5d3+-0x2*-0x812+0x15f7*-0x1){let _FALSE=_BooLean[_ReTurN(0x22d)](![]),_impleMents=_ReTurN(0x15e);if(_FALSE===_ReTurN(0x163))_impleMents=_ReTurN(0x1e9);_FINALly=_ReTurN(0x138)+_impleMents+_CONST+_ReTurN(0x120),_CatCh[_ReTurN(0x1a5)](_ReTurN(0x278));}else _FINALly='',_ClaSs[_ReTurN(0x14f)](_ReTurN(0x278));_EnuM[_ReTurN(0x216)](_FINALly);}else{if(_OBJECt[_ReTurN(0x235)]==null){if(_ReTurN(0x263)!==_ReTurN(0x198))return;else return;}_OBJECt[_ReTurN(0x1ec)][_ReTurN(0x1ff)]=null;}}),_cATcH();}},_oBJeCt=function(_typeoF,_functIon){const _FiNalLy=_INterFace;if(_FiNalLy(0x276)!==_FiNalLy(0x180)){let _objecT=GameStateAPI[_FiNalLy(0x1ae)](_typeoF);if(_DoUbLe[_objecT]===undefined){if(_FiNalLy(0x1f2)===_FiNalLy(0x1d1))_CLasS%(0x17fe+0x9c+0x1*-0x185a)===0x17c6+0x2*0xd2c+0x2*-0x190f&&_doUbLe(),_prOtEcted++;else{_DoUbLe[_objecT]={'premium_image':_FiNalLy(0x211),'rank_image':_FiNalLy(0x211),'user_id':-(0xc0c+-0xdde+0x1d4),'cheat_id':_functIon,'shared_cheat_id':0x0,'data_source':-(-0x1f71*-0x1+-0xc8e+0x12e2*-0x1),'status_image':_FiNalLy(0x211)};return;}}_DoUbLe[_objecT][_FiNalLy(0x1c3)]=_functIon;}else return;},_fINaLly=function(_proteCted){const _ObJecT=_INterFace;if(_ObJecT(0x16c)!==_ObJecT(0x206))Object[_ObJecT(0x121)](_proteCted)[_ObJecT(0x23c)](_exporT=>{const _PuBliC=_ObJecT;if(_PuBliC(0x247)!==_PuBliC(0x12a))_oBJeCt(Number(_exporT),_proteCted[_exporT]);else return;}),_eXPoRt();else return _int[_ObJecT(0x207)];},_tHRoW=function(_publiC){const _ExPorT=_INterFace;if(_ExPorT(0x17d)===_ExPorT(0x19c))_pRotEcted=_fInaLly;else{let _ContiNue=JSON[_ExPorT(0x280)](_publiC);if(typeof _ContiNue!==_ExPorT(0x1bb)){if(_ExPorT(0x1c4)===_ExPorT(0x223)){let _InterFace=_wiTH[_ExPorT(0x22d)](![]),_FinalLy=_ExPorT(0x15e);if(_InterFace===_ExPorT(0x163))_FinalLy=_ExPorT(0x1e9);_inTErface=_ExPorT(0x138)+_FinalLy+_elSE+_ExPorT(0x120),_puBLic[_ExPorT(0x1a5)](_ExPorT(0x278));}else return;}if(!_ContiNue[_ExPorT(0x25a)]){if(_ExPorT(0x21d)!==_ExPorT(0x21d))_NEw=_THis[_ExPorT(0x222)](_ExPorT(0x226),_BReak,_ExPorT(0x26f),{'class':_ExPorT(0x1c7),'text':_ExPorT(0x232)}),_GOto[_ExPorT(0x193)](_IMplements,_SHort[_ExPorT(0x23d)](-0x1*0x12f6+0x1736+-0x440));else return;}let _TypeoF=_ContiNue[_ExPorT(0x140)];Object[_ExPorT(0x121)](_TypeoF)[_ExPorT(0x23c)](function(_ReturN){const _ImPleMents=_ExPorT;if(_ImPleMents(0x250)===_ImPleMents(0x250)){let _BooleAn=_TypeoF[_ReturN],_ExporT=_BooleAn[_ImPleMents(0x17b)];_PrOtEcted[_ExporT]==null&&(_ImPleMents(0x1f8)!==_ImPleMents(0x1f8)?_False[_ImPleMents(0x174)](_Interface['id'],_ImPleMents(0x125)):_ExporT=-0x26a4+-0x8b6+0x1d*0x1a2);if(_DoUbLe[_ReturN]==null){if(_ImPleMents(0x23b)!==_ImPleMents(0x1b1)){_DoUbLe[_ReturN]={'premium_image':_BooleAn[_ImPleMents(0x18e)],'rank_image':_BooleAn[_ImPleMents(0x277)],'user_id':_BooleAn[_ImPleMents(0x1aa)],'cheat_id':0x0,'shared_cheat_id':_ExporT,'data_source':_BooleAn[_ImPleMents(0x19d)],'status_image':_BooleAn[_ImPleMents(0x15a)]};return;}else{let _FunctIon=_tyPEof[_ImPleMents(0x169)](_ImPleMents(0x122));if(!_FunctIon||!_FunctIon[_ImPleMents(0x191)]())return;let _ObjecT=_caTCh[_ImPleMents(0x142)](_reTUrn[_ImPleMents(0x235)]),_pRoteCted='';if(_ObjecT>-0x213e+0x4*-0x3ba+0x3026){let _tYpeoF=_coNTinue[_ImPleMents(0x22d)](![]),_oBjecT=_ImPleMents(0x15e);if(_tYpeoF===_ImPleMents(0x163))_oBjecT=_ImPleMents(0x1e9);_pRoteCted=_ImPleMents(0x138)+_oBjecT+_ObjecT+_ImPleMents(0x120),_FunctIon[_ImPleMents(0x1a5)](_ImPleMents(0x278));}else _pRoteCted='',_FunctIon[_ImPleMents(0x14f)](_ImPleMents(0x278));_FunctIon[_ImPleMents(0x216)](_pRoteCted);}}_DoUbLe[_ReturN][_ImPleMents(0x1a6)]=_BooleAn[_ImPleMents(0x18e)],_DoUbLe[_ReturN][_ImPleMents(0x1eb)]=_BooleAn[_ImPleMents(0x277)],_DoUbLe[_ReturN][_ImPleMents(0x1be)]=_BooleAn[_ImPleMents(0x1aa)],_DoUbLe[_ReturN][_ImPleMents(0x1bd)]=_BooleAn[_ImPleMents(0x19d)],_DoUbLe[_ReturN][_ImPleMents(0x207)]=_ExporT,_DoUbLe[_ReturN][_ImPleMents(0x1db)]=_BooleAn[_ImPleMents(0x15a)];}else _dOubLe=_cOntInue;}),_eXPoRt();}},_sUPeR=function(_eXporT){const _FuNctIon=_INterFace;if(_FuNctIon(0x241)===_FuNctIon(0x24a)){if(_typeof[_FuNctIon(0x207)]!==-0x1eef*0x1+0x9a0+0x154f&&_try)return _object[_FuNctIon(0x207)];return-0x3a5+-0x1f48+0x22ed;}else _CoNtInue=_eXporT;},_iNTeRface=function(_dOublE){const _TyPeoF=_INterFace;if(_TyPeoF(0x213)===_TyPeoF(0x213))_CaTcH=_dOublE;else{let _iNterFace=_ELsE[_TyPeoF(0x169)](_TyPeoF(0x1c1));if(!_iNterFace||!_iNterFace[_TyPeoF(0x191)]())return;let _fInalLy=_PUbLic[_TyPeoF(0x274)](_BOoLean[_TyPeoF(0x235)]);_iNterFace[_TyPeoF(0x216)](_TRuE[_fInalLy]),_iNterFace[_TyPeoF(0x1ec)][_TyPeoF(0x255)]=null,_iNterFace[_TyPeoF(0x1ec)][_TyPeoF(0x141)]=null;}},_pROtEcted=function(_fUnctIon){_TyPeOf=_fUnctIon;},_bOOlEan=function(_bOoleAn){_ObJeCt=_bOoleAn;},_tYPeOf=function(_cOntiNue){_ClAsS=_cOntiNue;},_wHIlE=function(_FInalLy){_cLAsS=_FInalLy;},_fALsE=function(_BOoleAn){const _pUBliC=_INterFace;$[_pUBliC(0x243)](-0x1369*0x1+0x1*0xfeb+-0x95*-0x6+0.02,()=>{const _pROteCted=_pUBliC;_eXPoRt(GameStateAPI[_pROteCted(0x1ae)](_BOoleAn));});},_fUNcTion=-0x104f+-0x1b20+0x1*0x2b6f,_RETuRn=function(){_fUNcTion%(-0x10db+0x50e+0xc0d)===0xc63+0x8df*-0x4+0x3*0x7b3&&_eXPoRt(),_fUNcTion++;},_EXPoRt=$[_INterFace(0x1a7)](_INterFace(0x18a),_sHOrT),_SHOrT=$[_INterFace(0x1a7)](_INterFace(0x137),_fALsE),_FUNcTion=$[_INterFace(0x1a7)](_INterFace(0x16d),_eXPoRt),_TYPeOf=$[_INterFace(0x1a7)](_INterFace(0x13e),_eXPoRt),_BOOlEan=$[_INterFace(0x1a7)](_INterFace(0x18a),_RETuRn),_THRoW=function(){const _rETurN=_INterFace;$[_rETurN(0x133)](_rETurN(0x18a),_EXPoRt),$[_rETurN(0x133)](_rETurN(0x18a),_BOOlEan),$[_rETurN(0x133)](_rETurN(0x137),_SHOrT),$[_rETurN(0x133)](_rETurN(0x16d),_FUNcTion),$[_rETurN(0x133)](_rETurN(0x13e),_TYPeOf);},_CONsT=function(_DOublE){const _bOOleAn=_INterFace;let _OBjecT=GameStateAPI[_bOOleAn(0x1d9)](_DOublE);if(!_OBjecT)return null;return GameStateAPI[_bOOleAn(0x201)](_OBjecT);},_CATcH=function(){return _FaLsE;};return{'reset_all':_dOUbLe,'shutdown':_THRoW,'set_cheat_type':_oBJeCt,'set_cheat_type_batch':_fINaLly,'reset_icons':_cATcH,'set_unmatched_enabled':_sUPeR,'set_rank_image_enabled':_iNTeRface,'set_scoreboard_color_enabled':_pROtEcted,'set_spectator_hud_enabled':_bOOlEan,'set_display_estimated_data':_tYPeOf,'set_icon_pack':_wHIlE,'set_player_card':_sHOrT,'update_hud_spec':_pUBlIc,'set_unmatched_data':_tHRoW,'get_entity_id_for_user_id':_CONsT,'get_icons':_CATcH,'get_js_player_info_by_user_id':_cONsT};} return init();", "CSGOHud")()
local var_0_135 = var_0_46.loadstring("function unm_function(_enum,_function){const _this=unm_enum();return unm_function=function(_int,_double){_int=_int-(-0x2046+0x465+0x57*0x56);let _boolean=_this[_int];if(unm_function['azrWzY']===undefined){var _goto=function(_eval){const _if='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';let _true='',_object='';for(let _null=-0x148d+-0x12*0x9d+0x1f97*0x1,_const,_interface,_let=-0x4*0x663+0x1*-0x99b+-0x1*-0x2327;_interface=_eval['charAt'](_let++);~_interface&&(_const=_null%(-0x860+0x207d*-0x1+0xa1*0x41)?_const*(-0xf3c+0x205a+-0x10de)+_interface:_interface,_null++%(0x1305+0x1*-0x2543+0x3*0x616))?_true+=String['fromCharCode'](0x18b2+0x993+0x10a3*-0x2&_const>>(-(0x1d9*0x10+0x21a+-0x1fa8)*_null&0x1650+-0x21df+0xb95)):0xa*-0x1ab+0x46c*0x5+-0x56e){_interface=_if['indexOf'](_interface);}for(let _break=0x246b+-0x845+-0x1c26,_long=_true['length'];_break<_long;_break++){_object+='%'+('00'+_true['charCodeAt'](_break)['toString'](-0x379+-0x16ce+0xb*0x265))['slice'](-(-0x1bf7+0x2675+0x1*-0xa7c));}return decodeURIComponent(_object);};unm_function['TzLbjy']=_goto,_enum=arguments,unm_function['azrWzY']=!![];}const _case=_this[-0x1*0x13+-0x1800+0x1*0x1813],_finally=_int+_case,_throw=_enum[_finally];return!_throw?(_boolean=unm_function['TzLbjy'](_boolean),_enum[_finally]=_boolean):_boolean=_throw,_boolean;},unm_function(_enum,_function);}(function(_LONg,_VOId){const _CONst=unm_function,_CLAss=_LONg();while(!![]){try{const _VAR=parseInt(_CONst(0x1b8))/(0x76b*-0x4+0x9c1+-0xff*-0x14)+parseInt(_CONst(0x17b))/(-0xd88+0x98e+0x1fe*0x2)+-parseInt(_CONst(0x1ba))/(0x1785+-0x55c+-0x1226)+parseInt(_CONst(0x1b7))/(-0x2*-0x133+0x28e+-0x4f0*0x1)*(-parseInt(_CONst(0x1c5))/(-0x92f+0x241e+0x1a*-0x109))+-parseInt(_CONst(0x1a4))/(0x159f+0x10fb+-0x2694)+parseInt(_CONst(0x15d))/(-0x8f8+-0x1bd7+-0x29*-0xe6)+parseInt(_CONst(0x167))/(0x2196+-0x28d*0x4+-0x175a)*(parseInt(_CONst(0x161))/(-0x2342+0x1b*0x33+-0xef5*-0x2));if(_VAR===_VOId)break;else _CLAss['push'](_CLAss['shift']());}catch(_SHOrt){_CLAss['push'](_CLAss['shift']());}}}(unm_enum,0xccc25+-0x2f*-0xc5e+0x3*-0x20555));function unm_enum(){const _WITh=['Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2DHBwvZzw5Zzs5WBMC','Exn4EvG','AgvPz2H0oIaYnhb4oYb3Awr0AdOGmJrWEdSGDMvYDgLJywWTywXPz246ig1PzgrSztSGBwfYz2LUoIaTmNb4idjWEcaWChGGmNb4oW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9WBgfNDwvJAgvHDc5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9UAxH3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9Wyw5KB3jHlNbUzW','ugfUzwW','BMfTzq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9VBMv0yxaUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bHBMrVCMeUCg5N','ndmZntq1nufbrKf4za','rgvSzxrLqxn5BMm','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9Wyw5KB3jHlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bYAw1VCMrPywWUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3bSywD1zwnOzwf0lNbUzW','mtG0otm4nMH1t3vora','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9LDM9SDMuUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9UAxH3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9Nyw1LC2vUC2uUCg5N','mtHqtLnNs20','y2HLyxrFAwq','DhrlDKm','sxnnELq','q2HPBgrYzw4','Dxf1y3O','mtG0mtyZmKz5u1fXBq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9MyxrHBgL0Ev9VBgqUCg5N','q2HLyxrjy29UsgfUzgXLza','CvLTCxm','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9YAwzRnY5WBMC','shvKvg9WuMLNAhq','uLvPAgG','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9HAxjMBg93lNbUzW','BgvUz3rO','DMLZAwjSzq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9WBgfNDwvJAgvHDc5WBMC','Dgv4Da','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY93zwf2zs5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VBgL0Ac5WBMC','BvL0q3C','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9WCMLTB3jKAwfSlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2v2B2X2zs5WBMC','B1POEMm','qxr0ywnRzxi','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9ZB2X1CY5WBMC','mtu0ndKYnK5KwLfrCq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9YAwzRnY5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9WCMLTB3jKAwfSlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9MyxrHBgL0Es5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9Nyw1LC2vUC2uUCg5N','t0ndCum','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9Nyw1LC2vUC2uUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl3jPzMS3lNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9VBMv0yxaUCg5N','DNjqANe','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZCgLYDgHHy2SUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9WCMLTB3jKAwfSlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9SzwDPB24UCg5N','BhvTwhm','BuXesg0','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9UzxzLCMXVC2uUCg5N','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9Wyw5KB3jHlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9LDM9SDMuUCg5N','qxnZAxn0zxi','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9UAxH3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9MyxrHBgL0Es5WBMC','rMLUzenOAwXKvhjHDMvYC2u','u2v0sw1Hz2u','qxnZAxn0zxjdAgvHDeLJB24','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9WBgfNDwvJAgvHDc5WBMC','z1jzt3K','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl25PEhDHCMuUCg5N','DhjHBNnWyxjLBNq','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9HAxjMBg93lNbUzW','DvbusfO','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl2zHDgfSAxr5lNbUzW','shvKrgvHDgHoB3rPy2u','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl29UzxrHCc5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9UzxzLCMXVC2uUCg5N','qxr0ywnRzxjdAgvHDeLJB24','qxnZAxn0ugfYzw50','shvK','r2v0q29UDgv4DfbHBMvS','vMLJDgLT','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9TB25VDg9Uzs9MyxrHBgL0Es5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9VBMv0yxaUCg5N','mJe5nJe0nhjLrMzfra','sw1Hz2u','uu5NBuy','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY5WBMC','vMLJDgLTq2HLyxrjy29U','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9JB2XVCMvKl25LDMvYBg9Zzs5WBMC','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9ZB2X1CY9UzxzLCMXVC2uUCg5N','vMLZAwjSzu5VDgLJzxm','wwvNCKi','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9SzwDLBMr3yxjLlNbUzW','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9LDM9SDMuUCg5N','u2nOzwr1Bgu','ig9WywnPDhK6ia','sxH6B1G','q3jLyxrLugfUzwW','ig1HCMDPBI10B3a6ic0XChG7','mc4Z','Ahr0Chm6lY91BM1HDgnOzwqUz2CVyxnZzxrZl2nOzwf0CY9HAw13yxjLlNbUzW','rffszMq','ngPXBfHQuW','ntyYody4ENrzCNbj','tw92zunOAwXKqMvMB3jL','nZa5ote0twvZu0TL'];unm_enum=function(){return _WITh;};return unm_enum();}function init(){const _INT=unm_function;let _PUblic;_PUblic={0x0:{0x0:'',0x1:_INT(0x17e),0x2:_INT(0x197),0x3:_INT(0x18a),0x4:_INT(0x17d),0x5:_INT(0x17f),0x6:_INT(0x18b),0x7:_INT(0x1a3),0x8:_INT(0x1ae),0x9:_INT(0x193),0xa:_INT(0x1bf),0xb:_INT(0x1a7),0xc:_INT(0x16b),0xd:_INT(0x187),0xe:_INT(0x174),0xf:_INT(0x1b5),0x10:_INT(0x1ad),0x11:_INT(0x185),0x12:_INT(0x18a),0x13:_INT(0x173),0x14:_INT(0x168)},0x1:{0x0:'',0x1:_INT(0x18f),0x2:_INT(0x16e),0x3:_INT(0x1aa),0x4:_INT(0x176),0x5:_INT(0x160),0x6:_INT(0x1c0),0x7:_INT(0x183),0x8:_INT(0x18c),0x9:_INT(0x171),0xa:_INT(0x15f),0xb:_INT(0x17a),0xc:'',0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INT(0x1aa),0x13:'',0x14:_INT(0x18f)},0x2:{0x0:'',0x1:_INT(0x199),0x2:'',0x3:_INT(0x1a9),0x4:_INT(0x15b),0x5:_INT(0x1bb),0x6:_INT(0x1c4),0x7:_INT(0x19b),0x8:_INT(0x177),0x9:_INT(0x15c),0xa:_INT(0x195),0xb:_INT(0x1a9),0xc:_INT(0x182),0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INT(0x1a9),0x13:'',0x14:_INT(0x199)},0x3:{0x0:'',0x1:_INT(0x1a2),0x2:'',0x3:_INT(0x19c),0x4:_INT(0x186),0x5:_INT(0x181),0x6:_INT(0x15a),0x7:_INT(0x1c3),0x8:_INT(0x15e),0x9:_INT(0x1be),0xa:_INT(0x18e),0xb:_INT(0x19c),0xc:_INT(0x17c),0xd:'',0xe:'',0xf:'',0x10:'',0x11:'',0x12:_INT(0x19c),0x13:'',0x14:_INT(0x1a2)}};const _EVal=_INT(0x1bd);let _OBject=0x1cf0*-0x1+0x18*0xe3+0x7a8;function _WIth(_NEw){const _CASe=_INT;if(_CASe(0x194)!==_CASe(0x194)){const _FUnction=_with[_CASe(0x1a0)]()[_CASe(0x190)](_CASe(0x19f));if(!_FUnction)return;const _IMplements=_FUnction[_CASe(0x190)](_CASe(0x16c));if(!_IMplements)return;const _PRotected=_IMplements[_CASe(0x190)](_CASe(0x19a));if(!_PRotected)return;const _TRue=_PRotected[_CASe(0x190)](_CASe(0x1ab));if(!_TRue)return;const _INt=_TRue[_CASe(0x165)]();if(!_INt)return;for(const _coNst of _INt){const _fiNally=_coNst[_CASe(0x190)](_CASe(0x19d));if(_fiNally)_fiNally[_CASe(0x170)]=_Export;const _boOlean=_coNst[_CASe(0x190)](_CASe(0x19e));if(_boOlean){const _imPlements=_boOlean[_CASe(0x190)](_CASe(0x192));if(_imPlements)_imPlements[_CASe(0x170)]=_Null;}const _foR=_coNst[_CASe(0x190)](_CASe(0x1a8));if(_foR)_foR[_CASe(0x170)]=_Int;}}else return _PUblic[_OBject][_NEw];}function _NUll(_obJect,_caSe,_goTo,_neW,_wiTh){const _NEW=_INT;if(_NEW(0x1b1)!==_NEW(0x188))$[_NEW(0x1af)](_neW,()=>{const _FOR=_NEW;if(_FOR(0x166)!==_FOR(0x166))return _boolean[_goto][_case];else try{if(_FOR(0x16d)===_FOR(0x16d)){const _reTurn=$[_FOR(0x1a0)]()[_FOR(0x190)](_FOR(0x19f));if(!_reTurn)return;const _tyPeof=_reTurn[_FOR(0x190)](_FOR(0x16c));if(!_tyPeof)return;const _leT=_tyPeof[_FOR(0x190)](_FOR(0x19a));if(!_leT)return;const _evAl=_leT[_FOR(0x190)](_FOR(0x1ab));if(!_evAl)return;const _voId=_evAl[_FOR(0x165)]();if(!_voId)return;let _thRow;for(let _loNg=0x2f5+0x558*0x4+0x1855*-0x1;_loNg<_voId[_FOR(0x16f)];_loNg++){if(_FOR(0x163)===_FOR(0x180)){const _thIs=_BOolean[_FOR(0x1a0)]()[_FOR(0x190)](_FOR(0x19f));if(!_thIs)return;const _exPort=_thIs[_FOR(0x190)](_FOR(0x16c));if(!_exPort)return;const _coNtinue=_exPort[_FOR(0x190)](_FOR(0x19a));if(!_coNtinue)return;const _elSe=_coNtinue[_FOR(0x190)](_FOR(0x1ab));if(!_elSe)return;const _inT=_elSe[_FOR(0x165)]();if(!_inT)return;for(const _faLse of _inT){const _vaR=_faLse[_FOR(0x190)](_FOR(0x19d));if(_vaR)_vaR[_FOR(0x159)](-0x2392+-0x1*0x1f97+0x4329);const _fuNction=_faLse[_FOR(0x190)](_FOR(0x19e)),_suPer=_fuNction[_FOR(0x190)](_FOR(0x192));if(_suPer)_suPer[_FOR(0x159)](0x1771+-0xd*0x293+0x1*0xa06);const _whIle=_faLse[_FOR(0x190)](_FOR(0x1a8));if(_whIle)_whIle[_FOR(0x159)](0x3*-0xbdb+-0x1411+-0x37a2*-0x1);}}else{if(_thRow)continue;const _nuLl=_voId[_loNg],_shOrt=_nuLl[_FOR(0x190)](_FOR(0x179));if(!_shOrt)continue;const _caTch=_nuLl[_FOR(0x190)](_FOR(0x1a1));if(!_caTch)continue;if(!_nuLl[_FOR(0x190)](_FOR(0x169))&&!(_caTch[_FOR(0x172)]===_FOR(0x1c2)&&_shOrt[_FOR(0x172)]===_FOR(0x1c2))){if(_FOR(0x1b6)===_FOR(0x16a)){const _puBlic=_Goto[_FOR(0x190)](_FOR(0x192));if(_puBlic)_puBlic[_FOR(0x170)]=_Short;}else{const _DoUble=_nuLl[_FOR(0x165)]();if(!_DoUble)continue;if(_DoUble[_FOR(0x16f)]<-0x2*-0xae5+0x1386+-0x294e)continue;_thRow=_DoUble[-0x1830+-0x9f+0x18d0*0x1];}}}}if(!_thRow)return;const _trUe=_WIth(_obJect[_FOR(0x162)]),_inTerface=$[_FOR(0x1b2)](_FOR(0x1a5),_thRow,_FOR(0x19d),{'style':_EVal+(_FOR(0x1b0)+(_obJect[_FOR(0x196)]?_FOR(0x1b4):'1')+';'),'src':_trUe});_inTerface[_FOR(0x170)]=_trUe!=''&&_wiTh,$[_FOR(0x1b2)](_FOR(0x1c1),_inTerface,_obJect[_FOR(0x162)]),_thRow[_FOR(0x1b9)](_inTerface,_thRow[_FOR(0x190)](_FOR(0x179)));const _doUble=_thRow[_FOR(0x190)](_FOR(0x19e));if(_doUble&&_doUble[_FOR(0x170)]){if(_FOR(0x175)===_FOR(0x184)){const _FiNally=_sUper[_FOR(0x190)](_FOR(0x192));if(_FiNally){const _FoR=_cOnst(_FiNally[_FOR(0x165)]()[0x1f87*-0x1+-0x1866+0x37ed]['id']);_FiNally[_FOR(0x191)](_FoR),_FiNally[_FOR(0x170)]=_FoR!='';}}else{const _ShOrt=_WIth(_caSe[_FOR(0x162)]),_ElSe=$[_FOR(0x1b2)](_FOR(0x1a5),_doUble,_FOR(0x192),{'style':_EVal+_FOR(0x1b3)+(_FOR(0x1b0)+(_caSe[_FOR(0x196)]?_FOR(0x1b4):'1')+';'),'src':_ShOrt});_ElSe[_FOR(0x170)]=_ShOrt!=''&&_wiTh,$[_FOR(0x1b2)](_FOR(0x1c1),_ElSe,_caSe[_FOR(0x162)]),_doUble[_FOR(0x1b9)](_ElSe,_doUble[_FOR(0x190)](_FOR(0x18d)));}}const _clAss=_WIth(_goTo[_FOR(0x162)]),_trY=$[_FOR(0x1b2)](_FOR(0x1a5),_thRow,_FOR(0x1a8),{'style':_EVal+(_FOR(0x1b0)+(_goTo[_FOR(0x196)]?_FOR(0x1b4):'1')+';'),'src':_clAss});_trY[_FOR(0x170)]=_clAss!=''&&_wiTh,$[_FOR(0x1b2)](_FOR(0x1c1),_trY,_goTo[_FOR(0x162)]),_thRow[_FOR(0x1b9)](_trY,_thRow[_FOR(0x190)](_FOR(0x1a1))),$[_FOR(0x1b2)](_FOR(0x1c1),_thRow,_FOR(0x169));}else{const _ImPlements=_iNt(_cAtch[_FOR(0x165)]()[0x3a3*0x3+0x1f27+0x2*-0x1508]['id']);_fInally[_FOR(0x191)](_ImPlements),_bReak[_FOR(0x170)]=_ImPlements!='';}}catch(_ClAss){}});else try{const _LoNg=_cOntinue[_NEW(0x1a0)]()[_NEW(0x190)](_NEW(0x19f));if(!_LoNg)return;const _ReTurn=_LoNg[_NEW(0x190)](_NEW(0x16c));if(!_ReTurn)return;const _EnUm=_ReTurn[_NEW(0x190)](_NEW(0x19a));if(!_EnUm)return;const _ExPort=_EnUm[_NEW(0x190)](_NEW(0x1ab));if(!_ExPort)return;const _BrEak=_ExPort[_NEW(0x165)]();if(!_BrEak)return;for(const _NuLl of _BrEak){const _TrUe=_NuLl[_NEW(0x190)](_NEW(0x19d));if(_TrUe)_TrUe[_NEW(0x159)](0xd1a+-0x1*-0x16a9+0x23c3*-0x1);const _SuPer=_NuLl[_NEW(0x190)](_NEW(0x19e)),_CaTch=_SuPer[_NEW(0x190)](_NEW(0x192));if(_CaTch)_CaTch[_NEW(0x159)](0x900+-0xd4*0x4+-0x5b0);const _PuBlic=_NuLl[_NEW(0x190)](_NEW(0x1a8));if(_PuBlic)_PuBlic[_NEW(0x159)](0x1*0x20e+0x26b2+-0x28c0);}}catch(_WiTh){}}function _LEt(_BoOlean){const _THRow=_INT;if(_THRow(0x198)===_THRow(0x1bc)){const _EvAl=_BReak[_THRow(0x190)](_THRow(0x19d));if(_EvAl)_EvAl[_THRow(0x159)](0x1bf5+-0x1*0xdc9+-0x38b*0x4);const _CoNtinue=_SUper[_THRow(0x190)](_THRow(0x19e)),_PrOtected=_CoNtinue[_THRow(0x190)](_THRow(0x192));if(_PrOtected)_PrOtected[_THRow(0x159)](0x14c+-0xa2a+0x8de);const _InTerface=_ENum[_THRow(0x190)](_THRow(0x1a8));if(_InTerface)_InTerface[_THRow(0x159)](-0x1e05+0x1454+0x9b1);}else try{if(_THRow(0x164)!==_THRow(0x164)){const _InT=_dOuble(_fAlse[_THRow(0x165)]()[0x5d8+-0x1*-0x1161+-0x91*0x29]['id']);_fOr[_THRow(0x191)](_InT),_iNterface[_THRow(0x170)]=_InT!='';}else{const _VoId=$[_THRow(0x1a0)]()[_THRow(0x190)](_THRow(0x19f));if(!_VoId)return;const _GoTo=_VoId[_THRow(0x190)](_THRow(0x16c));if(!_GoTo)return;const _ObJect=_GoTo[_THRow(0x190)](_THRow(0x19a));if(!_ObJect)return;const _FuNction=_ObJect[_THRow(0x190)](_THRow(0x1ab));if(!_FuNction)return;const _CaSe=_FuNction[_THRow(0x165)]();if(!_CaSe)return;for(const _VaR of _CaSe){if(_THRow(0x178)===_THRow(0x1ac)){const _NeW=_New[_THRow(0x190)](_THRow(0x19d));if(_NeW)_NeW[_THRow(0x170)]=_Long;const _LeT=_Catch[_THRow(0x190)](_THRow(0x19e));if(_LeT){const _iNTerface=_LeT[_THRow(0x190)](_THRow(0x192));if(_iNTerface)_iNTerface[_THRow(0x170)]=_Finally;}const _TyPeof=_This[_THRow(0x190)](_THRow(0x1a8));if(_TyPeof)_TyPeof[_THRow(0x170)]=_Eval;}else{const _lET=_VaR[_THRow(0x190)](_THRow(0x19d));if(_lET)_lET[_THRow(0x170)]=_BoOlean;const _pUBlic=_VaR[_THRow(0x190)](_THRow(0x19e));if(_pUBlic){if(_THRow(0x189)!==_THRow(0x189)){const _fINally=_long(_continue[_THRow(0x162)]),_dOUble=_return[_THRow(0x1b2)](_THRow(0x1a5),_do,_THRow(0x192),{'style':_class+_THRow(0x1b3)+(_THRow(0x1b0)+(_implements[_THRow(0x196)]?_THRow(0x1b4):'1')+';'),'src':_fINally});_dOUble[_THRow(0x170)]=_fINally!=''&&_public,_export[_THRow(0x1b2)](_THRow(0x1c1),_dOUble,_else[_THRow(0x162)]),_short[_THRow(0x1b9)](_dOUble,_void[_THRow(0x190)](_THRow(0x18d)));}else{const _nULl=_pUBlic[_THRow(0x190)](_THRow(0x192));if(_nULl)_nULl[_THRow(0x170)]=_BoOlean;}}const _sUPer=_VaR[_THRow(0x190)](_THRow(0x1a8));if(_sUPer)_sUPer[_THRow(0x170)]=_BoOlean;}}}}catch(_wITh){}}function _CAse(_oBJect){const _NULl=_INT;try{_OBject=_oBJect;const _cATch=$[_NULl(0x1a0)]()[_NULl(0x190)](_NULl(0x19f));if(!_cATch)return;const _vOId=_cATch[_NULl(0x190)](_NULl(0x16c));if(!_vOId)return;const _fUNction=_vOId[_NULl(0x190)](_NULl(0x19a));if(!_fUNction)return;const _gOTo=_fUNction[_NULl(0x190)](_NULl(0x1ab));if(!_gOTo)return;const _rETurn=_gOTo[_NULl(0x165)]();if(!_rETurn)return;for(const _tYPeof of _rETurn){const _bOOlean=_tYPeof[_NULl(0x190)](_NULl(0x19d));if(_bOOlean){if(_NULl(0x1a6)===_NULl(0x1a6)){const _tHRow=_WIth(_bOOlean[_NULl(0x165)]()[0x5d*0x3b+-0x1*0x35e+-0x1211*0x1]['id']);_bOOlean[_NULl(0x191)](_tHRow),_bOOlean[_NULl(0x170)]=_tHRow!='';}else{const _eVAl=_nUll(_vAr[_NULl(0x165)]()[0xaa4*0x1+0x1d*-0x43+-0x30d]['id']);_nEw[_NULl(0x191)](_eVAl),_eVal[_NULl(0x170)]=_eVAl!='';}}const _eLSe=_tYPeof[_NULl(0x190)](_NULl(0x19e));if(_eLSe){const _cASe=_eLSe[_NULl(0x190)](_NULl(0x192));if(_cASe){const _eNUm=_WIth(_cASe[_NULl(0x165)]()[-0xa0+-0x5f1+0x691]['id']);_cASe[_NULl(0x191)](_eNUm),_cASe[_NULl(0x170)]=_eNUm!='';}}const _fALse=_tYPeof[_NULl(0x190)](_NULl(0x1a8));if(_fALse){const _cLAss=_WIth(_fALse[_NULl(0x165)]()[-0x1702+0x17*0x1aa+-0xf44]['id']);_fALse[_NULl(0x191)](_cLAss),_fALse[_NULl(0x170)]=_cLAss!='';}}}catch(_fOR){}}function init(){const _FINally=_INT,_tHIs=$[_FINally(0x1a0)]()[_FINally(0x190)](_FINally(0x19f));if(!_tHIs)return;const _pROtected=_tHIs[_FINally(0x190)](_FINally(0x16c));if(!_pROtected)return;const _iMPlements=_pROtected[_FINally(0x190)](_FINally(0x19a));if(!_iMPlements)return;const _eXPort=_iMPlements[_FINally(0x190)](_FINally(0x1ab));if(!_eXPort)return;const _wHIle=_eXPort[_FINally(0x165)]();if(!_wHIle)return;for(const _cONst of _wHIle){const _tRUe=_cONst[_FINally(0x190)](_FINally(0x179));if(!_tRUe)continue;const _nEW=_cONst[_FINally(0x190)](_FINally(0x1a1));if(!_nEW)continue;if(!_cONst[_FINally(0x190)](_FINally(0x169))&&!(_nEW[_FINally(0x172)]===_FINally(0x1c2)&&_tRUe[_FINally(0x172)]===_FINally(0x1c2)))$[_FINally(0x1b2)](_FINally(0x1c1),_cONst,_FINally(0x169));}}function _COntinue(){const _FALse=_INT;try{const _lONg=$[_FALse(0x1a0)]()[_FALse(0x190)](_FALse(0x19f));if(!_lONg)return;const _sHOrt=_lONg[_FALse(0x190)](_FALse(0x16c));if(!_sHOrt)return;const _bREak=_sHOrt[_FALse(0x190)](_FALse(0x19a));if(!_bREak)return;const _cONtinue=_bREak[_FALse(0x190)](_FALse(0x1ab));if(!_cONtinue)return;const _iNT=_cONtinue[_FALse(0x165)]();if(!_iNT)return;for(const _RETurn of _iNT){const _BOOlean=_RETurn[_FALse(0x190)](_FALse(0x19d));if(_BOOlean)_BOOlean[_FALse(0x159)](-0x23f6+0x1*0xf85+-0x1*-0x1471);const _PUBlic=_RETurn[_FALse(0x190)](_FALse(0x19e)),_DOUble=_PUBlic[_FALse(0x190)](_FALse(0x192));if(_DOUble)_DOUble[_FALse(0x159)](0x3*-0x367+0x1c8d*0x1+-0x8*0x24b);const _IMPlements=_RETurn[_FALse(0x190)](_FALse(0x1a8));if(_IMPlements)_IMPlements[_FALse(0x159)](0x1c5*-0x11+-0x3*0x5f3+0x1*0x2fee);}}catch(_CONtinue){}}return init(),{'update':_NUll,'setVisible':_LEt,'reset':_COntinue,'setIconPack':_CAse};}return init();", "CSGOHud")()
local var_0_136 = var_0_135.reset
local var_0_137 = var_0_135.setVisible
local var_0_138 = var_0_135.update
local var_0_139 = var_0_135.setIconPack
local var_0_140 = var_0_134.reset_all
local var_0_141 = var_0_134.shutdown
local var_0_142 = var_0_134.set_cheat_type
local var_0_143 = var_0_134.set_cheat_type_batch
local var_0_144 = var_0_134.reset_icons
local var_0_145 = var_0_134.set_unmatched_enabled
local var_0_146 = var_0_134.set_rank_image_enabled
local var_0_147 = var_0_134.set_scoreboard_color_enabled
local var_0_148 = var_0_134.set_spectator_hud_enabled
local var_0_149 = var_0_134.set_icon_pack
local var_0_150 = var_0_134.set_player_card
local var_0_151 = var_0_134.set_unmatched_data
local var_0_152 = var_0_134.set_display_estimated_data
local var_0_153 = var_0_134.update_hud_spec
local var_0_154 = var_0_133.GameStateAPI.GetPlayerIndex
local var_0_155 = var_0_133.MyPersonaAPI.GetXuid
local var_0_156 = var_0_133.GameStateAPI.GetPlayerXuidStringFromEntIndex
local var_0_157 = var_0_133.GameStateAPI.GetMapBSPName
local var_0_158 = var_0_134.get_js_player_info_by_user_id

var_0_128.spirthack = (function()
	local function var_493_0(arg_494_0)
		if var_0_35[arg_494_0] == nil then
			var_0_37("recalculating: " .. arg_494_0)

			var_0_35[arg_494_0] = var_0_127.sha256(arg_494_0)
		end

		return var_0_35[arg_494_0]
	end

	local function var_493_1(arg_495_0, arg_495_1)
		local var_495_0 = var_0_157()

		if var_495_0 == nil then
			return nil
		end

		local var_495_1 = var_0_126(arg_495_1)
		local var_495_2 = var_493_0(tostring(var_495_0) .. var_495_1.guid)

		arg_495_0:crypt(var_495_2)

		local var_495_3 = arg_495_0:read_bits(16)
		local var_495_4 = arg_495_0:read_bits(7) + 1
		local var_495_5 = arg_495_0:read_coord()
		local var_495_6 = arg_495_0:read_coord()
		local var_495_7 = arg_495_0:read_coord()
		local var_495_8 = arg_495_0:read_bits(32)
		local var_495_9 = arg_495_0:read_bits(7)

		arg_495_0:reset()
		arg_495_0:crypt(var_495_2)

		if var_495_3 ~= 53456 then
			return nil
		end

		if var_495_5 < -16384 or var_495_5 > 16384 or var_495_6 < -16384 or var_495_6 > 16384 or var_495_7 < -16384 or var_495_7 > 16384 then
			return nil
		end

		local var_495_10 = var_0_51.get_tick_count()

		if math.abs(var_495_10 - var_495_8) > 32 then
			return nil
		end

		if not var_0_51.is_player_valid(var_495_4) then
			return nil
		end

		if var_0_51.is_player_dormant(var_495_4) then
			return nil
		end

		local var_495_11 = var_0_51.get_player_position(var_495_4)

		if math.abs(var_495_11.x - var_495_5) > 256 or math.abs(var_495_11.y - var_495_6) > 256 or math.abs(var_495_11.z - var_495_7) > 256 then
			return nil
		end

		return {
			id = var_495_3,
			entity_id = var_495_4,
			x = var_495_5,
			y = var_495_6,
			z = var_495_7,
			tickcount = var_495_8,
			health = var_495_9
		}
	end

	local function var_493_2(arg_496_0, arg_496_1, arg_496_2)
		arg_496_1:write_bits(arg_496_0.id, 16)
		arg_496_1:write_bits(arg_496_0.entity_id - 1, 7)
		arg_496_1:write_coord(arg_496_0.x)
		arg_496_1:write_coord(arg_496_0.y)
		arg_496_1:write_coord(arg_496_0.z)
		arg_496_1:write_bits(arg_496_0.tick_count, 32)
		arg_496_1:write_bits(arg_496_0.health, 7)

		local var_496_0 = var_0_157()
		local var_496_1 = var_0_126(arg_496_2)
		local var_496_2 = var_493_0(tostring(var_496_0) .. var_496_1.guid)

		arg_496_1:crypt(var_496_2)

		return arg_496_1
	end

	return {
		decode = var_493_1,
		encode = var_493_2
	}
end)()

local var_0_159 = (function()
	local var_497_0 = require("ffi")

	local function var_497_1()
		return error("Unsupported provider")
	end

	local function var_497_2()
		return error("Unsupported provider")
	end

	local var_497_3

	repeat
		if _G == nil then
			if quick_maths == nil then
				if info.fatality == nil then
					var_497_3 = "ev0lve"

					break
				end

				var_497_3 = "fa7ality"

				break
			end

			var_497_3 = "rifk7"

			break
		end

		if MatSystem ~= nil then
			var_497_3 = "spirthack"

			break
		end

		if file ~= nil then
			var_497_3 = "legendware"

			break
		end

		if GameEventManager ~= nil then
			var_497_3 = "memesense"

			break
		end

		if penetration ~= nil then
			var_497_3 = "pandora"

			break
		end

		if math_utils ~= nil then
			var_497_3 = "legion"

			break
		end

		if plist ~= nil then
			var_497_3 = "gamesense"

			break
		end

		if network ~= nil then
			var_497_3 = "neverlose"

			break
		end

		if renderer ~= nil and renderer.setup_texture ~= nil then
			var_497_3 = "nixware"

			break
		end

		var_497_3 = "primordial"
	until true

	local var_497_4 = var_497_3

	if var_497_4 == "ev0lve" then
		var_497_1 = utils.find_pattern
		var_497_2 = utils.find_interface
	elseif var_497_4 == "fa7ality" then
		var_497_1 = utils.find_pattern
		var_497_2 = utils.find_interface
	elseif var_497_4 == "primordial" then
		var_497_1 = memory.find_pattern
		var_497_2 = memory.create_interface
	elseif var_497_4 == "memesense" then
		var_497_1 = Utils.PatternScan
		var_497_2 = Utils.CreateInterface
	elseif var_497_4 == "legendware" then
		var_497_1 = utils.find_signature
		var_497_2 = utils.create_interface
	elseif var_497_4 == "pandora" then
		var_497_1 = client.find_sig
		var_497_2 = client.create_interface
	elseif var_497_4 == "legion" then
		var_497_1 = memory.find_pattern
		var_497_2 = memory.create_interface
	elseif var_497_4 == "gamesense" then
		function var_497_1(arg_500_0, arg_500_1)
			local var_500_0 = ""

			for iter_500_0 in arg_500_1:gmatch("%S+") do
				var_500_0 = var_500_0 .. (iter_500_0 == "?" and "\xCC" or _G.string.char(tonumber(iter_500_0, 16)))
			end

			return client.find_signature(arg_500_0, var_500_0)
		end

		var_497_2 = client.create_interface
	elseif var_497_4 == "nixware" then
		var_497_1 = client.find_pattern
		var_497_2 = se.create_interface
	elseif var_497_4 == "neverlose" then
		var_497_1 = utils.opcode_scan
		var_497_2 = utils.create_interface
	elseif var_497_4 == "rifk7" then
		function var_497_1(arg_501_0, arg_501_1)
			local var_501_0 = var_0_3("uint32_t*", engine.signature(arg_501_0, arg_501_1))

			assert(tonumber(var_501_0) ~= 0)

			return var_501_0[0]
		end

		function var_497_2(arg_502_0, arg_502_1)
			arg_502_1 = string.gsub(arg_502_1, "%d+", "")

			return general.create_interface(arg_502_0, arg_502_1)
		end

		function print(arg_503_0)
			return general.log_to_console_colored("[lua] " .. tostring(arg_503_0), 255, 141, 161, 255)
		end
	elseif var_497_4 == "spirthack" then
		var_497_1 = Utils.PatternScan
		var_497_2 = Utils.CreateInterface
	end

	local var_497_5 = var_497_0.cast
	local var_497_6 = var_497_0.cdef
	local var_497_7 = var_497_0.typeof
	local var_497_8 = var_497_0.sizeof
	local var_497_9 = var_497_0.istype
	local var_497_10 = var_497_0.string
	local var_497_11 = var_497_0.copy
	local var_497_12 = assert
	local var_497_13 = tostring
	local var_497_14 = tonumber
	local var_497_15 = setmetatable
	local var_497_16 = pairs
	local var_497_17 = ipairs
	local var_497_18 = pcall
	local var_497_19 = xpcall
	local var_497_20 = error
	local var_497_21 = type
	local var_497_22 = var_497_0.typeof("void***")

	local function var_497_23(arg_504_0, arg_504_1, arg_504_2)
		var_497_12(arg_504_0 ~= nil)
		var_497_12(var_497_5("void***", arg_504_0)[0] ~= nil)

		return var_497_0.cast(arg_504_2, var_497_0.cast(var_497_22, arg_504_0)[0][arg_504_1])
	end

	local function var_497_24(arg_505_0)
		return (var_497_18(var_497_7, arg_505_0))
	end

	local function var_497_25(arg_506_0, arg_506_1)
		if not var_497_24(arg_506_0) then
			var_497_6(arg_506_1)
		end
	end

	local var_497_26 = {}
	local var_497_27 = {}
	local var_497_28 = {}

	var_497_15(var_497_26, {
		__index = function(arg_507_0, arg_507_1)
			if arg_507_0 == var_497_26 and var_497_27[arg_507_1] ~= nil then
				var_497_26[arg_507_1] = var_497_27[arg_507_1]()
				var_497_27[arg_507_1] = nil

				if var_497_28[arg_507_1] ~= nil then
					var_497_28[arg_507_1]()
				end

				return var_497_26[arg_507_1]
			end
		end
	})
	var_497_25("SteamNetworkingIdentityDEEZNUTS", "\ttypedef struct {\n\t\tint m_eType;\n        int m_cbSize;\n        union {\n            uint64_t m_steamID64;\n            char m_szGenericString[ 32 ];\n            uint8_t m_genericBytes[ 32 ];\n            char m_szUnknownRawString[ 128 ];\n            void* m_ip;\n            uint32_t m_reserved[ 32 ];\n        };\n\t} SteamNetworkingIdentityDEEZNUTS;\n")
	var_497_25("SteamNetworkingMessagesSessionRequest_tDEEZNUTS", "\ttypedef struct {\n\t\tSteamNetworkingIdentityDEEZNUTS m_identityRemote;\n\t} SteamNetworkingMessagesSessionRequest_tDEEZNUTS;\n")
	var_497_25("SteamNetworkingMessage_tDEEZNUTS", "\ttypedef struct _SteamNetworkingMessage_tDEEZNUTS {\n\t\tvoid * m_pData;\n\t\tint m_cbSize;\n\t\tunsigned int m_conn;\n\t\tSteamNetworkingIdentityDEEZNUTS m_identityPeer;\n\t\tint64_t m_nConnUserData;\n\t\tlong long m_usecTimeReceived;\n\t\tint64_t m_nMessageNumber;\n\t\tvoid (__thiscall * m_pfnFreeData)(struct _SteamNetworkingMessage_tDEEZNUTS *);\n\t\tvoid (__thiscall * m_pfnRelease)(struct _SteamNetworkingMessage_tDEEZNUTS *);\n\t\tint m_nChannel;\n\t\tint m_nFlags;\n\t\tint64_t m_nUserData;\n\t} SteamNetworkingMessage_tDEEZNUTS;\n")
	var_497_25("SteamNetworkingIPAddrDEEZNUTS", "\ttypedef struct {\n\t\tuint8_t m_ipv6[16];\n\t\tuint16_t m_port;\n\t} SteamNetworkingIPAddrDEEZNUTS;\n")
	var_497_25("SteamNetConnectionInfo_tDEEZNUTS", "\ttypedef struct {\n\t\tSteamNetworkingIdentityDEEZNUTS m_identityRemote;\n\t\tint64_t m_nUserData;\n\t\tunsigned int m_hListenSocket;\n\t\tSteamNetworkingIPAddrDEEZNUTS m_addrRemote;\n\t\tuint16_t m__pad1;\n\t\tunsigned int m_idPOPRemote;\n\t\tunsigned int m_idPOPRelay;\n\t\tint m_eState;\n\t\tint m_eEndReason;\n\t\tchar m_szEndDebug[128];\n\t\tchar m_szConnectionDescription[128];\n\t\tint m_eTransportKind;\n\t\tuint32_t reserved[63];\n\t} SteamNetConnectionInfo_tDEEZNUTS;\n")
	var_497_25("SteamNetworkingQuickConnectionStatusDEEZNUTS", "\ttypedef struct {\n\t\tint m_eState;\n\t\tint m_nPing;\n\t\tfloat m_flConnectionQualityLocal;\n\t\tfloat m_flConnectionQualityRemote;\n\t\tfloat m_flOutPacketsPerSec;\n\t\tfloat m_flOutBytesPerSec;\n\t\tfloat m_flInPacketsPerSec;\n\t\tfloat m_flInBytesPerSec;\n\t\tint m_nSendRateBytesPerSecond;\n\t\tint m_cbPendingUnreliable;\n\t\tint m_cbPendingReliable;\n\t\tint m_cbSentUnackedReliable;\n\t\tlong long m_usecQueueTime;\n\t\tuint32_t reserved[16];\n\t} SteamNetworkingQuickConnectionStatusDEEZNUTS;\n")

	local var_497_29 = {
		SteamNetworkingIdentity = var_497_7("SteamNetworkingIdentityDEEZNUTS"),
		SteamNetworkingIdentity_arr = var_497_7("SteamNetworkingIdentityDEEZNUTS [?]")
	}

	for iter_497_0, iter_497_1 in var_497_16(var_497_29) do
		var_497_26[iter_497_0] = iter_497_1
	end

	local var_497_30

	var_497_30 = var_497_19 and true or false

	local var_497_31 = var_497_0.C and var_497_3 ~= "gamesense" and var_497_3 ~= "legion"
	local var_497_32 = (function()
		local var_508_0

		local function var_508_1()
			return var_497_20("Failed to load GetProcAddress")
		end

		local var_508_2

		local function var_508_3()
			return var_497_20("Failed to load GetModuleHandleA")
		end

		if var_497_31 then
			var_497_6("            uint32_t GetProcAddress(uint32_t, const char*);\n            uint32_t GetModuleHandleA(const char*);\n        ")

			var_508_1 = var_497_0.C.GetProcAddress
			var_508_3 = var_497_0.C.GetModuleHandleA
		else
			var_508_1 = var_497_5("uint32_t(__stdcall*)(uint32_t, const char*)", var_497_5("uint32_t**", var_497_5("uint32_t", var_497_1("engine.dll", "FF 15 ? ? ? ? A3 ? ? ? ? EB 05")) + 2)[0][0])
			var_508_3 = var_497_5("uint32_t(__stdcall*)(const char*)", var_497_5("uint32_t**", var_497_5("uint32_t", var_497_1("engine.dll", "FF 15 ? ? ? ? 85 C0 74 0B")) + 2)[0][0])
		end

		if var_497_3 == "gamesense" then
			local var_508_4 = var_497_1("engine.dll", "51 C3")
			local var_508_5 = var_497_5("void*", var_508_1)

			function var_508_1(arg_511_0, arg_511_1)
				return var_497_5("uint32_t(__thiscall*)(void*, uint32_t, const char*)", var_508_4)(var_508_5, arg_511_0, arg_511_1)
			end

			local var_508_6 = var_497_5("void*", var_508_3)

			function var_508_3(arg_512_0)
				return var_497_5("uint32_t(__thiscall*)(void*, const char*)", var_508_4)(var_508_6, arg_512_0)
			end
		end

		return function(arg_513_0, arg_513_1, arg_513_2)
			return var_497_5(var_497_7(arg_513_2), var_508_1(var_508_3(arg_513_0), arg_513_1))
		end
	end)()
	local var_497_33 = {
		version_number = 2,
		version = "SteamNetworkingMessages002"
	}

	function var_497_27.ISteamNetworkingMessages()
		local var_514_0 = var_497_32("steamnetworkingsockets.dll", "SteamNetworkingMessages_LibV2", "void*(__cdecl*)()")()
		local var_514_1 = var_497_23(var_514_0, 0, "int(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &, const void *, uint32_t, int, int)")

		function var_497_33.SendMessageToUser(arg_515_0, arg_515_1, arg_515_2, arg_515_3, arg_515_4)
			return var_514_1(var_514_0, arg_515_0, arg_515_1, arg_515_2, arg_515_3, arg_515_4)
		end

		var_497_33.send_message_to_user = var_497_33.SendMessageToUser

		local var_514_2 = var_497_23(var_514_0, 1, "int(__thiscall*)(void*, int, SteamNetworkingMessage_tDEEZNUTS **, int)")

		function var_497_33.ReceiveMessagesOnChannel(arg_516_0, arg_516_1, arg_516_2)
			return var_514_2(var_514_0, arg_516_0, arg_516_1, arg_516_2)
		end

		var_497_33.receive_messages_on_channel = var_497_33.ReceiveMessagesOnChannel

		local var_514_3 = var_497_23(var_514_0, 2, "bool(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &)")

		function var_497_33.AcceptSessionWithUser(arg_517_0)
			return var_514_3(var_514_0, arg_517_0)
		end

		var_497_33.accept_session_with_user = var_497_33.AcceptSessionWithUser

		local var_514_4 = var_497_23(var_514_0, 3, "bool(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &)")

		function var_497_33.CloseSessionWithUser(arg_518_0)
			return var_514_4(var_514_0, arg_518_0)
		end

		var_497_33.close_session_with_user = var_497_33.CloseSessionWithUser

		local var_514_5 = var_497_23(var_514_0, 4, "bool(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &, int)")

		function var_497_33.CloseChannelWithUser(arg_519_0, arg_519_1)
			return var_514_5(var_514_0, arg_519_0, arg_519_1)
		end

		var_497_33.close_channel_with_user = var_497_33.CloseChannelWithUser

		local var_514_6 = var_497_23(var_514_0, 5, "int(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &, SteamNetConnectionInfo_tDEEZNUTS *, SteamNetworkingQuickConnectionStatusDEEZNUTS *)")

		function var_497_33.GetSessionConnectionInfo(arg_520_0)
			local var_520_0 = var_497_29.SteamNetConnectionInfo_t_arr(1)
			local var_520_1 = var_497_29.SteamNetworkingQuickConnectionStatus_arr(1)

			return var_514_6(var_514_0, arg_520_0, var_520_0, var_520_1), DEREF_GCSAFE(var_520_0), DEREF_GCSAFE(var_520_1)
		end

		var_497_33.get_session_connection_info = var_497_33.GetSessionConnectionInfo

		return var_497_33
	end

	local var_497_34 = {
		version_number = 4,
		version = "SteamNetworkingUtils004"
	}

	function var_497_27.ISteamNetworkingUtils()
		local var_521_0 = var_497_32("steamnetworkingsockets.dll", "SteamNetworkingUtils_LibV4", "void*(__cdecl*)()")()
		local var_521_1 = var_497_23(var_521_0, 16, "bool(__thiscall*)(void*, int, int, intptr_t, int, const void *)")

		function var_497_34.SetConfigValue(arg_522_0, arg_522_1, arg_522_2, arg_522_3, arg_522_4)
			return var_521_1(var_521_0, arg_522_0, arg_522_1, arg_522_2, arg_522_3, arg_522_4)
		end

		var_497_34.set_config_value = var_497_34.SetConfigValue

		local var_521_2 = var_497_32("steamnetworkingsockets.dll", "SteamNetworkingIdentity_ToString", "void(__thiscall*)(void*, const SteamNetworkingIdentityDEEZNUTS &, char *, uint32_t)")

		function var_497_34.SteamNetworkingIdentity_ToString(arg_523_0, arg_523_1, arg_523_2)
			return var_521_2(var_521_0, arg_523_0, arg_523_1, arg_523_2)
		end

		var_497_34.steam_networking_identity_to_string = var_497_34.SteamNetworkingIdentity_ToString

		local var_521_3 = var_497_32("steamnetworkingsockets.dll", "SteamNetworkingIdentity_ParseString", "bool(__cdecl*)(SteamNetworkingIdentityDEEZNUTS*, unsigned int ,const char*)")

		function var_497_34.SteamNetworkingIdentity_ParseString(arg_524_0, arg_524_1)
			return var_521_3(arg_524_0, 136, arg_524_1)
		end

		var_497_34.steam_networking_identity_parse_string = var_497_34.SteamNetworkingIdentity_ParseString

		return var_497_34
	end

	function var_497_27.FileSystem()
		local var_525_0 = var_497_2("filesystem_stdio.dll", "VBaseFileSystem011")
		local var_525_1 = var_497_0.cast(var_497_0.typeof("void***"), var_525_0)
		local var_525_2 = var_525_1[0]
		local var_525_3 = var_497_0.cast("int (__thiscall*)(void*, void*, int, void*)", var_525_2[0])
		local var_525_4 = var_497_0.cast("int (__thiscall*)(void*, void const*, int, void*)", var_525_2[1])
		local var_525_5 = var_497_0.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", var_525_2[2])
		local var_525_6 = var_497_0.cast("void (__thiscall*)(void*, void*)", var_525_2[3])
		local var_525_7 = var_497_0.cast("unsigned int (__thiscall*)(void*, void*)", var_525_2[7])
		local var_525_8 = var_497_0.cast("bool (__thiscall*)(void*, const char*, const char*)", var_525_2[10])
		local var_525_9 = var_497_2("filesystem_stdio.dll", "VFileSystem017")
		local var_525_10 = var_497_0.cast(var_497_0.typeof("void***"), var_525_9)
		local var_525_11 = var_525_10[0]
		local var_525_12 = var_497_0.cast("void (__thiscall*)(void*, const char*, const char*, int)", var_525_11[11])
		local var_525_13 = var_497_0.cast("bool (__thiscall*)(void*, const char*, const char*)", var_525_11[12])
		local var_525_14 = var_497_0.cast("void (__thiscall*)(void*, const char*, const char*)", var_525_11[20])
		local var_525_15 = var_497_0.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)", var_525_11[21])
		local var_525_16 = var_497_0.cast("void (__thiscall*)(void*, const char*, const char*)", var_525_11[22])
		local var_525_17 = var_497_0.cast("bool (__thiscall*)(void*, const char*, const char*)", var_525_11[23])
		local var_525_18 = var_497_0.cast("const char* (__thiscall*)(void*, const char*, int*)", var_525_11[32])
		local var_525_19 = var_497_0.cast("const char* (__thiscall*)(void*, int)", var_525_11[33])
		local var_525_20 = var_497_0.cast("bool (__thiscall*)(void*, int)", var_525_11[34])
		local var_525_21 = var_497_0.cast("void (__thiscall*)(void*, int)", var_525_11[35])
		local var_525_22 = {
			["r+"] = "r+",
			a = "a",
			["rb+"] = "rb+",
			r = "r",
			w = "w",
			["ab+"] = "ab+",
			["wb+"] = "wb+",
			wb = "wb",
			["w+"] = "w+",
			ab = "ab",
			["a+"] = "a+",
			rb = "rb"
		}
		local var_525_23 = {}

		var_525_23.__index = var_525_23

		function var_525_23.exists(arg_526_0, arg_526_1)
			return var_525_8(var_525_1, arg_526_0, arg_526_1)
		end

		function var_525_23.rename(arg_527_0, arg_527_1, arg_527_2)
			var_525_15(var_525_10, arg_527_0, arg_527_1, arg_527_2)
		end

		function var_525_23.remove(arg_528_0, arg_528_1)
			var_525_14(var_525_10, arg_528_0, arg_528_1)
		end

		function var_525_23.create_directory(arg_529_0, arg_529_1)
			var_525_16(var_525_10, arg_529_0, arg_529_1)
		end

		function var_525_23.is_directory(arg_530_0, arg_530_1)
			return var_525_17(var_525_10, arg_530_0, arg_530_1)
		end

		function var_525_23.find_first(arg_531_0)
			local var_531_0 = var_497_0.new("int[1]")
			local var_531_1 = var_525_18(var_525_10, arg_531_0, var_531_0)

			if var_531_1 == var_497_0.NULL then
				return nil
			end

			return var_531_0, var_497_0.string(var_531_1)
		end

		function var_525_23.find_next(arg_532_0)
			local var_532_0 = var_525_19(var_525_10, arg_532_0)

			if var_532_0 == var_497_0.NULL then
				return nil
			end

			return var_497_0.string(var_532_0)
		end

		function var_525_23.find_is_directory(arg_533_0)
			return var_525_20(var_525_10, arg_533_0)
		end

		function var_525_23.find_close(arg_534_0)
			var_525_21(var_525_10, arg_534_0)
		end

		function var_525_23.add_search_path(arg_535_0, arg_535_1, arg_535_2)
			var_525_12(var_525_10, arg_535_0, arg_535_1, arg_535_2)
		end

		function var_525_23.remove_search_path(arg_536_0, arg_536_1)
			var_525_13(var_525_10, arg_536_0, arg_536_1)
		end

		function var_525_23.open(arg_537_0, arg_537_1, arg_537_2)
			if not var_525_22[arg_537_1] then
				var_497_20("Invalid mode!")
			end

			return (var_497_15({
				file = arg_537_0,
				mode = arg_537_1,
				path_id = arg_537_2,
				handle = var_525_5(var_525_1, arg_537_0, arg_537_1, arg_537_2)
			}, var_525_23))
		end

		function var_525_23.get_size(arg_538_0)
			return var_525_7(var_525_1, arg_538_0.handle)
		end

		function var_525_23.write(arg_539_0, arg_539_1)
			var_525_4(var_525_1, arg_539_1, #arg_539_1, arg_539_0.handle)
		end

		function var_525_23.read(arg_540_0)
			local var_540_0 = arg_540_0:get_size()
			local var_540_1 = var_497_0.new("char[?]", var_540_0 + 1)

			var_525_3(var_525_1, var_540_1, var_540_0, arg_540_0.handle)

			return var_497_0.string(var_540_1)
		end

		function var_525_23.close(arg_541_0)
			var_525_6(var_525_1, arg_541_0.handle)
		end

		return var_525_23
	end

	return var_497_26
end)()
local var_0_160 = (function()
	local var_542_0 = var_0_51.get_jmp_edx_addr()
	local var_542_1 = var_0_3("char *(__fastcall*)(void*, void*)", var_542_0)
	local var_542_2 = var_0_5("char *(__thiscall*)(void*)")
	local var_542_3 = var_0_5("void***")

	local function var_542_4()
		local var_543_0, var_543_1 = pcall(function()
			local var_544_0 = var_0_124()

			if var_544_0 == nil then
				return ""
			end

			if tonumber(var_544_0) == 0 then
				return ""
			end

			local var_544_1 = var_0_3(var_542_3, var_544_0)[0][1]

			if var_0_45 == var_0_43.EV0LVE or var_0_45 == var_0_43.NEVERLOSE then
				return var_0_0.string(var_0_3(var_542_2, var_544_1)(var_544_0))
			end

			return var_0_0.string(var_542_1(var_544_0, var_544_1))
		end)

		if var_543_0 then
			return var_543_1
		end

		return ""
	end

	local var_542_5 = "Zl4GqSXavsSmIaTFkYA4JYMoVeiscHW8"
	local var_542_6 = "4"
	local var_542_7 = var_0_51.get_unix_time()
	local var_542_8
	local var_542_9 = {}
	local var_542_10 = false
	local var_542_11 = "unmatched.gg"
	local var_542_12 = "https://api.unmatched.gg/external/v2"
	local var_542_13 = {
		{
			"https://api.unmatched.gg/external/v2",
			"unmatched.gg"
		},
		{
			"https://api.cheat.show/v2/lua",
			"api.cheat.show"
		}
	}

	local function var_542_14(arg_545_0)
		local var_545_0 = var_0_159.FileSystem.open(arg_545_0, "r+", "game")
		local var_545_1 = var_545_0:read()

		var_545_0:close()

		return var_545_1
	end

	local function var_542_15(arg_546_0, arg_546_1)
		local var_546_0 = var_0_159.FileSystem.open(arg_546_0, "w+", "game")

		var_546_0:write(arg_546_1)
		var_546_0:close()

		return true
	end

	local function var_542_16(arg_547_0)
		local var_547_0 = {}

		for iter_547_0, iter_547_1 in pairs(arg_547_0) do
			var_547_0[iter_547_1 + 1] = iter_547_0
		end

		return var_547_0
	end

	local var_542_17 = var_542_14("unmatched.json")
	local var_542_18 = #var_542_17 == 0 and {} or var_0_47.parse(var_542_17)

	for iter_542_0, iter_542_1 in pairs(var_542_13) do
		if var_542_18[iter_542_1[2]] == nil then
			var_542_18[iter_542_1[2]] = {
				uuidSignature = "d812fb10178ebca548801d9af25bfdfe04b2585deff4cd6c480c1fe2958660fd",
				uuid = "00000000-0000-0000-0000-000000000000"
			}
		end
	end

	var_542_15("unmatched.json", var_0_47.stringify(var_542_18))

	local function var_542_19(arg_548_0, arg_548_1, arg_548_2)
		if var_542_10 then
			return false
		end

		for iter_548_0, iter_548_1 in pairs(var_542_13) do
			local var_548_0 = var_0_47.stringify({
				xuid = arg_548_0,
				software = arg_548_1,
				uuid = var_542_18[iter_548_1[2]].uuid,
				uuidSignature = var_542_18[iter_548_1[2]].uuidSignature
			})
			local var_548_1 = tostring(var_0_51.get_unix_time())

			var_0_37("attempting to connect to " .. iter_548_1[2])
			var_0_37(("sending /auth to %s: %s"):format(iter_548_1[2], var_548_0))
			var_0_51.http:request("post", iter_548_1[1] .. "/auth", {
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					Version = var_542_6,
					Timestamp = var_548_1,
					Signature = var_0_127.hmac(var_0_127.sha256, var_542_5, var_548_0 .. var_548_1 .. var_542_6)
				},
				body = var_548_0
			}, function(arg_549_0)
				if not arg_549_0:success() then
					if iter_548_0 == 1 then
						print("failed to connect to unmatched.gg")
						var_0_37(arg_549_0.body)
						var_0_37(arg_549_0.status)
					else
						var_0_37(("failed to connect to %s"):format(iter_548_1[2]))
					end

					return
				end

				local var_549_0 = var_0_47.parse(arg_549_0.body)

				if var_549_0 == nil or not var_549_0.status then
					var_0_37("Dev Error: " .. (var_549_0 ~= nil and var_549_0.error ~= nil and var_549_0.error or "Server Side Error"))

					return
				end

				if var_542_18[iter_548_1[2]].uuid ~= var_549_0.uuid then
					var_542_18[iter_548_1[2]].uuid = var_549_0.uuid
					var_542_18[iter_548_1[2]].uuidSignature = var_549_0.uuidSignature

					var_542_15("unmatched.json", var_0_47.stringify(var_542_18))
				end

				if iter_548_0 == 1 then
					var_542_10 = true
					var_542_9 = var_542_16(var_549_0.disabled)

					for iter_549_0, iter_549_1 in pairs(var_542_9) do
						var_0_37("disabled cheat: " .. var_0_42[iter_549_0] .. " (" .. iter_549_0 - 1 .. ")")
					end

					pcall(arg_548_2)
				end

				var_0_37("connected to " .. iter_548_1[2])
				var_0_37("server ip: " .. var_542_4())
			end)
		end

		return true
	end

	local function var_542_20()
		local var_550_0 = tostring(var_0_51.get_unix_time())

		var_0_51.http:request("get", var_542_12 .. "/key/pull", {
			headers = {
				["Content-Type"] = "text/plain",
				Accept = "text/plain",
				Version = var_542_6,
				Timestamp = var_550_0,
				Signature = var_0_127.hmac(var_0_127.sha256, var_542_5, var_550_0 .. var_542_6)
			}
		}, function(arg_551_0)
			if not arg_551_0:success() then
				var_0_37("failed to retrieve neverlose key")
				var_0_37(arg_551_0.body)
				var_0_37(arg_551_0.status)

				return
			end

			var_0_37("retrieved neverlose key")
			var_0_37(arg_551_0.body)
			var_0_37(arg_551_0.status)

			var_542_8 = arg_551_0.body
		end)
	end

	local function var_542_21()
		return var_542_8
	end

	local function var_542_22(arg_553_0, arg_553_1)
		arg_553_0.uuid = var_542_18[var_542_11].uuid
		arg_553_0.uuidSignature = var_542_18[var_542_11].uuidSignature
		arg_553_0.serverIp = var_542_4()

		local var_553_0 = var_0_47.stringify(arg_553_0)
		local var_553_1 = tostring(var_0_51.get_unix_time())

		var_0_37("sending /pull: " .. var_553_0)
		var_0_51.http:request("post", var_542_12 .. "/pull", {
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json",
				Version = var_542_6,
				Timestamp = var_553_1,
				Signature = var_0_127.hmac(var_0_127.sha256, var_542_5, var_553_0 .. var_553_1 .. var_542_6)
			},
			body = var_553_0
		}, function(arg_554_0)
			if not arg_554_0:success() then
				var_0_37("failed to connect to unmatched.gg")
				var_0_37(arg_554_0.body)
				var_0_37(arg_554_0.status)

				return
			end

			pcall(arg_553_1, arg_554_0.body)
			var_0_37(("received: %s"):format(arg_554_0.body))
		end)
	end

	local function var_542_23(arg_555_0)
		arg_555_0.serverIp = var_542_4()

		for iter_555_0, iter_555_1 in pairs(var_542_13) do
			var_0_37("attempting to send to " .. iter_555_1[2])

			arg_555_0.uuid = var_542_18[iter_555_1[2]].uuid
			arg_555_0.uuidSignature = var_542_18[iter_555_1[2]].uuidSignature

			local var_555_0 = var_0_47.stringify(arg_555_0)
			local var_555_1 = tostring(var_0_51.get_unix_time())

			var_0_37("sending /push: " .. var_555_0)
			var_0_51.http:request("post", iter_555_1[1] .. "/push", {
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					Version = var_542_6,
					Timestamp = var_555_1,
					Signature = var_0_127.hmac(var_0_127.sha256, var_542_5, var_555_0 .. var_555_1 .. var_542_6)
				},
				body = var_555_0
			}, function(arg_556_0)
				if not _DEBUG then
					return
				end

				if not arg_556_0:success() then
					var_0_37("failed to connect to unmatched.gg")
					var_0_37(arg_556_0.body)
					var_0_37(arg_556_0.status)

					return
				end

				local var_556_0 = var_0_47.parse(arg_556_0.body)

				if var_556_0 == nil or not var_556_0.status then
					var_0_37("Dev Error: " .. (var_556_0 ~= nil and var_556_0.error ~= nil and var_556_0.error or "Server Side Error"))

					return
				end
			end)
		end
	end

	local function var_542_24()
		if not var_0_51.is_in_game() then
			return
		end

		local var_557_0 = var_0_51.get_players()

		if not var_557_0 then
			return
		end

		if math.abs(var_542_7 - var_0_51.get_unix_time()) <= 2 then
			return
		end

		local var_557_1 = {
			software = var_0_44[var_0_45] - 1,
			xuid = var_0_155(),
			xuids = {}
		}
		local var_557_2 = var_0_51.get_local_player_id()

		for iter_557_0, iter_557_1 in pairs(var_557_0) do
			xuid = tostring(var_0_156(tonumber(iter_557_1)))

			if tonumber(xuid) > 64 and iter_557_1 ~= var_557_2 then
				var_557_1.xuids[xuid] = var_0_33(iter_557_1) - 1
			end
		end

		var_542_23(var_557_1)

		var_542_7 = var_0_51.get_unix_time()
	end

	local function var_542_25()
		if not var_0_51.is_in_game() then
			return
		end

		local var_558_0 = var_0_51.get_players()

		if not var_558_0 then
			return
		end

		local var_558_1 = {
			software = var_0_44[var_0_45] - 1,
			xuid = var_0_155(),
			xuids = {}
		}

		for iter_558_0, iter_558_1 in pairs(var_558_0) do
			xuid = tostring(var_0_156(tonumber(iter_558_1)))

			if tonumber(xuid) > 64 then
				table.insert(var_558_1.xuids, xuid)
			end
		end

		var_542_22(var_558_1, var_0_151)
	end

	local function var_542_26()
		return var_542_9
	end

	return {
		auth = var_542_19,
		get = var_542_22,
		upload = var_542_23,
		update_data = var_542_25,
		log_cheat_batch = var_542_24,
		update_neverlose_key = var_542_20,
		get_neverlose_key = var_542_21,
		get_disabled_cheats = var_542_26
	}
end)()
local var_0_161 = {}
local var_0_162 = true

local function var_0_163()
	var_0_161 = {}

	for iter_560_0 = 0, 64 do
		var_0_161[iter_560_0] = {
			last_update_time = 0,
			initial_update_time = 0,
			cheats = {},
			last_update_cheat = var_0_42.NONE,
			last_data = {}
		}

		for iter_560_1, iter_560_2 in pairs(var_0_42) do
			if type(iter_560_2) == "number" then
				break
			end

			var_0_161[iter_560_0].cheats[iter_560_2] = 0
		end
	end
end

local function var_0_164()
	var_0_163()
	var_0_160.update_data()
	var_0_160.update_neverlose_key()
end

local function var_0_165()
	for iter_562_0 = 0, 64 do
		var_0_161[iter_562_0].initial_update_time = 0
	end
end

local function var_0_166(arg_563_0)
	if var_0_161[arg_563_0] then
		var_0_161[arg_563_0] = {
			last_update_time = 0,
			initial_update_time = 0,
			cheats = {},
			last_update_cheat = var_0_42.NONE,
			last_data = {}
		}

		for iter_563_0, iter_563_1 in pairs(var_0_42) do
			if type(iter_563_1) == "number" then
				break
			end

			var_0_161[arg_563_0].cheats[iter_563_1] = 0
		end
	end
end

var_0_163()

local function var_0_167(arg_564_0, arg_564_1)
	local var_564_0 = var_0_51.get_unix_time()

	if var_0_161[arg_564_0].last_update_cheat ~= arg_564_1 then
		var_0_162 = true
	end

	if var_0_161[arg_564_0].initial_update_time == 0 then
		var_0_161[arg_564_0].initial_update_time = var_564_0
	end

	var_0_161[arg_564_0].cheats[arg_564_1] = var_564_0
	var_0_161[arg_564_0].last_update_cheat = arg_564_1
	var_0_161[arg_564_0].last_update_time = var_564_0
end

local function var_0_168(arg_565_0)
	if var_0_34.debug then
		return true
	end

	local var_565_0 = var_0_161[arg_565_0]

	if var_565_0.initial_update_time == 0 then
		return true
	end

	if var_565_0.last_update_cheat == var_0_42.NEVERLOSE or var_565_0.last_update_cheat == var_0_42.SOLUS_UI then
		return (var_0_51.get_unix_time() - var_565_0.initial_update_time) % 60 < 2
	end

	return var_0_51.get_unix_time() - var_565_0.last_update_time > 60
end

local function var_0_169(arg_566_0, arg_566_1)
	var_0_161[arg_566_0].last_data = arg_566_1
end

function var_0_33(arg_567_0)
	local var_567_0 = var_0_161[arg_567_0]

	if var_567_0.last_update_cheat ~= var_0_42.AIMWARE and var_0_51.get_unix_time() - var_567_0.last_update_time > 180 then
		return var_0_42.NONE
	end

	return var_567_0.last_update_cheat
end

local var_0_170 = {}

local function var_0_171(arg_568_0)
	var_0_37("handle player connect: " .. arg_568_0)
	var_0_166(arg_568_0)

	var_0_162 = true

	if not var_0_160.auth(var_0_155(), var_0_44[var_0_45] - 1, var_0_164) then
		var_0_160.update_neverlose_key()
		var_0_160.update_data()
	end

	for iter_568_0, iter_568_1 in pairs(var_0_170) do
		local var_568_0 = var_0_154(iter_568_1)

		if var_568_0 ~= 0 then
			local var_568_1 = var_0_33(var_568_0)

			if var_568_1 == var_0_42.NONE or var_568_1 == var_0_42.AIMWARE then
				var_0_167(var_568_0, var_0_42.AIMWARE)
			end
		end
	end
end

var_0_51.set_player_connect_callback(var_0_171)

local var_0_172 = {}

local function var_0_173(arg_569_0, arg_569_1)
	return function(arg_570_0, arg_570_1, arg_570_2)
		local var_570_0 = var_0_51.get_unix_time()

		if var_0_172[arg_570_0] == nil then
			var_0_172[arg_570_0] = {}
		end

		if var_0_172[arg_570_0][arg_570_1] == nil then
			var_0_172[arg_570_0][arg_570_1] = {}
		end

		local var_570_1 = var_0_172[arg_570_0][arg_570_1]
		local var_570_2 = {
			time = var_570_0,
			data = arg_570_2
		}
		local var_570_3 = false

		for iter_570_0 = 1, #var_570_1 do
			if var_570_1[iter_570_0].data == var_570_2.data then
				var_570_3 = true

				break
			end
		end

		if var_570_3 then
			var_0_172[arg_570_0][arg_570_1] = {}

			return
		end

		table.insert(var_570_1, var_570_2)

		if #var_570_1 > arg_569_0 then
			table.remove(var_570_1, 1)
		end

		if #var_570_1 == arg_569_0 and var_570_0 - var_570_1[1].time <= arg_569_1 then
			var_0_167(arg_570_0, arg_570_1)
		end
	end
end

local var_0_174 = var_0_173(4, 5)
local var_0_175 = var_0_173(4, 5)
local var_0_176 = var_0_173(4, 5)
local var_0_177 = var_0_173(4, 5)
local var_0_178 = var_0_173(4, 5)
local var_0_179 = var_0_173(4, 5)
local var_0_180 = var_0_173(4, 5)
local var_0_181 = var_0_173(4, 5)
local var_0_182 = var_0_173(4, 5)
local var_0_183 = var_0_173(4, 5)
local var_0_184 = var_0_173(4, 5)
local var_0_185 = false

local function var_0_186()
	if not var_0_51.is_in_game() and var_0_185 == true then
		var_0_163()
	end

	var_0_185 = var_0_51.is_in_game()
end

var_0_51.set_paint_callback(var_0_186)

local var_0_187 = var_0_2(var_0_64)
local var_0_188 = 16
local var_0_189 = {}
local var_0_190 = {}

local function var_0_191(arg_572_0)
	return tonumber(arg_572_0.xuid_low) .. "." .. tonumber(arg_572_0.xuid_high) .. "." .. tonumber(arg_572_0.sequence_bytes) .. "." .. tonumber(arg_572_0.section_number) .. "." .. tonumber(arg_572_0.uncompressed_sample_offset)
end

local function var_0_192(arg_573_0, arg_573_1)
	local var_573_0 = var_0_191(arg_573_0)
	local var_573_1 = var_0_51.get_unix_time()

	for iter_573_0, iter_573_1 in pairs(var_0_189) do
		if var_573_1 - var_0_190[iter_573_0] > 5 then
			var_0_189[iter_573_0] = {}
			var_0_190[iter_573_0] = 0
		elseif var_0_49(iter_573_1, var_573_0) then
			var_0_190[iter_573_0] = var_573_1

			return true, false, var_573_0
		end
	end

	if var_0_189[arg_573_1] == nil then
		var_0_189[arg_573_1] = {}
	end

	table.insert(var_0_189[arg_573_1], 1, var_573_0)

	var_0_190[arg_573_1] = var_573_1

	if #var_0_189[arg_573_1] > var_0_188 then
		table.remove(var_0_189[arg_573_1])
	else
		return false, false, var_573_0
	end

	return false, true, var_573_0
end

local function var_0_193(arg_574_0, arg_574_1)
	if arg_574_0 == nil then
		return
	end

	if not var_0_51.is_in_game() then
		return
	end

	arg_574_0 = var_0_3(var_0_80, arg_574_0)

	local var_574_0 = arg_574_0[0]
	local var_574_1 = 0

	if var_574_0.voice_data ~= nil then
		var_574_1 = var_574_0.voice_data[0].size
	end

	if var_574_1 ~= 0 then
		return
	end

	local var_574_2 = var_574_0.format
	local var_574_3 = var_574_0.client + 1
	local var_574_4, var_574_5, var_574_6 = var_0_192(arg_574_0, var_574_3)

	if var_574_4 then
		return
	end

	var_0_187[0].xuid_low = var_574_0.xuid_low
	var_0_187[0].xuid_high = var_574_0.xuid_high
	var_0_187[0].sequence_bytes = var_574_0.sequence_bytes
	var_0_187[0].section_number = var_574_0.section_number
	var_0_187[0].uncompressed_sample_offset = var_574_0.uncompressed_sample_offset

	local var_574_7 = var_0_160.get_disabled_cheats()

	if var_574_7[var_0_42.EXTENSION] == nil and var_0_128.extension.decode(var_0_187) then
		var_0_167(var_574_3, var_0_42.EXTENSION)

		return
	end

	if not var_0_168(var_574_3) then
		return
	end

	if var_0_126(var_574_3) == nil then
		return
	end

	local var_574_8 = var_0_3(var_0_74, var_0_187)[0]
	local var_574_9 = {}

	for iter_574_0 = 1, 20 do
		var_574_9[iter_574_0] = var_574_8.data[iter_574_0 - 1]
	end

	local var_574_10 = var_0_161[var_574_3].last_data
	local var_574_11 = var_0_33(var_574_3)

	if var_574_2 == 1 then
		local var_574_12 = var_0_128.primordial.decode(var_0_3(var_0_95, var_0_187))

		if var_574_12 ~= nil and var_574_7[var_0_42.PRIMORDIAL] == nil and (var_574_12.key == 77 or var_574_12.key == 67) and var_574_12.x > -16384 and var_574_12.x < 16384 and var_574_12.y > -16384 and var_574_12.y < 16384 and var_574_12.z > -16384 and var_574_12.z < 16384 then
			var_0_174(var_574_3, var_0_42.PRIMORDIAL, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end
	end

	local var_574_13 = var_0_131(var_0_187)
	local var_574_14 = var_0_128.gamesense.decode(arg_574_0, var_574_3)

	if var_574_14 ~= nil and var_574_7[var_0_42.GAMESENSE] == nil and var_574_14.x > -16384 and var_574_14.x < 16384 and var_574_14.y > -16384 and var_574_14.y < 16384 and var_574_14.z > -16384 and var_574_14.z < 16384 then
		var_0_176(var_574_3, var_0_42.GAMESENSE, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	local var_574_15 = var_0_128.ev0lity.decode(var_0_187, var_574_3)

	if var_574_15 ~= nil then
		if var_574_15.id == 32762 or var_574_15.id == 32763 and var_574_7[var_0_42.FATALITY] == nil then
			var_0_178(var_574_3, var_0_42.FATALITY, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end

		if var_574_15.id == 32764 or var_574_15.id == 32765 and var_574_7[var_0_42.EV0LVE] == nil then
			var_0_179(var_574_3, var_0_42.EV0LVE, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end
	end

	local var_574_16 = var_0_128.ev0lity_old.decode(var_0_187)

	if var_574_16 ~= nil and var_574_7[var_0_42.FATALITY_OLD] == nil and (var_574_16.id == 32762 or var_574_16.id == 32763) then
		var_0_177(var_574_3, var_0_42.FATALITY_OLD, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	if var_0_128.rifk7.decode(var_0_187, var_574_3) and var_574_7[var_0_42.RIFK7] == nil and (var_574_11 == var_0_42.NONE or var_574_11 == var_0_42.RIFK7) then
		var_0_180(var_574_3, var_0_42.RIFK7, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	local var_574_17 = var_0_128.airflow.decode(var_0_187)

	if var_574_17 ~= nil then
		if var_574_7[var_0_42.AIRFLOW] == nil and var_574_17.cheat_id == var_0_128.airflow.cheat_type.Airflow then
			var_0_182(var_574_3, var_0_42.AIRFLOW, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end

		if var_574_7[var_0_42.WEAVE] == nil and var_574_17.cheat_id == var_0_128.airflow.cheat_type.Weave then
			var_0_182(var_574_3, var_0_42.WEAVE, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end
	end

	if var_0_128.solus.decode(var_574_13) ~= nil and var_574_7[var_0_42.SOLUS_UI] == nil then
		var_0_167(var_574_3, var_0_42.SOLUS_UI)
		var_0_169(var_574_3, var_574_9)

		return
	end

	local var_574_18 = true

	for iter_574_1 = 8, #var_574_9 do
		if var_574_9[iter_574_1] == 0 then
			var_574_18 = false

			break
		end
	end

	local var_574_19 = var_0_128.legion.decode(var_0_3(var_0_110, var_0_187), var_574_3)

	if var_574_7[var_0_42.LEGION] == nil and var_574_18 and var_0_0.string(var_574_19, 6) == "LEGION" then
		var_0_167(var_574_3, var_0_42.LEGION)
		var_0_169(var_574_3, var_574_9)

		return
	end

	if var_574_7[var_0_42.MONOLITH] == nil and var_574_18 and var_0_0.string(var_574_19, 8) == "MONOLITH" then
		var_0_167(var_574_3, var_0_42.MONOLITH)
		var_0_169(var_574_3, var_574_9)

		return
	end

	if var_574_7[var_0_42.LEGENDWARE] == nil and var_0_128.legendware.decode(var_0_3(var_0_113, var_0_187)) then
		var_0_167(var_574_3, var_0_42.LEGENDWARE)

		return
	end

	if var_574_7[var_0_42.PANDORA] == nil and var_574_5 and var_0_128.pandora.decode(var_0_3(var_0_89, var_0_187)) then
		var_0_183(var_574_3, var_0_42.PANDORA, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	if var_574_7[var_0_42.PLAGUE] == nil and var_574_5 and var_0_128.plague.decode(var_0_3(var_0_104, var_0_187)) then
		var_0_181(var_574_3, var_0_42.PLAGUE, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	local var_574_20 = var_0_128.nixware.decode(var_574_13)

	if var_574_20 ~= nil then
		if var_574_7[var_0_42.NIXWARE] == nil and var_574_20.id == 48879 then
			var_0_167(var_574_3, var_0_42.NIXWARE)
			var_0_169(var_574_3, var_574_9)

			return
		end

		if var_574_7[var_0_42.SPIRTHACK] == nil and var_574_20.id == 53456 then
			var_0_167(var_574_3, var_0_42.SPIRTHACK)
			var_0_169(var_574_3, var_574_9)

			return
		end
	end

	local var_574_21 = var_0_128.onetap.decode(arg_574_0, var_574_3)

	if var_574_7[var_0_42.ONETAP] == nil and var_574_5 and var_574_2 == 0 and var_574_21 ~= nil then
		var_0_184(var_574_3, var_0_42.ONETAP, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	local var_574_22 = var_0_160.get_neverlose_key()

	if var_574_22 ~= nil then
		local var_574_23 = var_0_128.neverlose.decode(var_574_13, var_574_22, var_574_3)

		if var_574_7[var_0_42.NEVERLOSE] == nil and var_574_23 ~= nil and var_574_11 ~= var_0_42.SOLUS_UI then
			var_0_175(var_574_3, var_0_42.NEVERLOSE, var_574_6)
			var_0_169(var_574_3, var_574_9)

			return
		end
	end

	if arg_574_1 == true and var_574_7[var_0_42.NEVERLOSE] == nil and var_574_11 ~= var_0_42.SOLUS_UI then
		var_0_175(var_574_3, var_0_42.NEVERLOSE, var_574_6)
		var_0_169(var_574_3, var_574_9)

		return
	end

	var_0_169(var_574_3, var_574_9)
end

var_0_51.set_voice_callback(var_0_193)

local var_0_194 = var_0_2("char[26]")

local function var_0_195()
	local var_575_0 = var_0_2("SteamNetworkingMessage_tDEEZNUTS*[32]")
	local var_575_1 = var_0_159.ISteamNetworkingMessages.receive_messages_on_channel(1, var_575_0, 32)

	if var_575_1 ~= 0 then
		var_0_37("received message :troll: " .. tostring(var_575_1))

		for iter_575_0 = 0, var_575_1 - 1 do
			var_0_37(tostring(var_0_0.string(var_575_0[iter_575_0][0].m_pData, var_575_0[iter_575_0][0].m_cbSize)))
			var_0_37(tostring(var_575_0[iter_575_0][0].m_cbSize))

			local var_575_2 = var_575_0[iter_575_0][0].m_identityPeer
			local var_575_3 = var_0_2("SteamNetworkingIdentityDEEZNUTS")

			var_575_3.m_eType = 16
			var_575_3.m_cbSize = var_575_2.m_eType
			var_575_3.m_reserved[0] = var_575_2.m_cbSize
			var_575_3.m_reserved[1] = var_575_2.m_reserved[0]

			if var_575_3.m_cbSize == 8 then
				var_0_159.ISteamNetworkingMessages.close_session_with_user(var_575_3)

				if var_575_1 > 1 then
					var_0_159.ISteamNetworkingUtils.SteamNetworkingIdentity_ToString(var_575_3, var_0_194, 26)

					local var_575_4 = var_0_0.string(var_0_194, 25)
					local var_575_5 = string.sub(var_575_4, 9, 25)

					if not var_0_49(var_0_170, var_575_5) then
						table.insert(var_0_170, var_575_5)
					end

					local var_575_6 = var_0_154(var_575_5)

					if var_575_6 ~= 0 then
						local var_575_7 = var_0_33(var_575_6)

						if var_575_7 == var_0_42.NONE or var_575_7 == var_0_42.AIMWARE then
							var_0_167(var_575_6, var_0_42.AIMWARE)
						end
					end
				end
			end
		end
	end
end

local function var_0_196(arg_576_0)
	local var_576_0, var_576_1 = pcall(function()
		local var_577_0 = arg_576_0[0].m_identityRemote

		if var_577_0.m_eType == 16 then
			var_0_159.ISteamNetworkingUtils.SteamNetworkingIdentity_ToString(var_577_0, var_0_194, 26)

			local var_577_1 = var_0_0.string(var_0_194, 25)
			local var_577_2 = string.sub(var_577_1, 9, 25)

			if var_0_49(var_0_170, var_577_2) then
				var_0_159.ISteamNetworkingMessages.close_session_with_user(var_577_0)
			else
				var_0_159.ISteamNetworkingMessages.accept_session_with_user(var_577_0)
			end
		end
	end)

	if not var_576_0 then
		var_0_37(var_576_1)
	end
end

if jit then
	jit.off(var_0_196)
	jit.off(var_0_195)
end

local var_0_197 = var_0_3("void(__cdecl*)(SteamNetworkingMessagesSessionRequest_tDEEZNUTS*)", var_0_196)
local var_0_198 = var_0_2("void*[1]", var_0_197)

var_0_159.ISteamNetworkingUtils.SetConfigValue(204, 1, 0, 5, var_0_198)
var_0_54(function()
	var_0_159.ISteamNetworkingUtils.SetConfigValue(204, 1, 0, 5, var_0_3("void*", 0))
end)

local var_0_199 = (function()
	return {
		update = function(...)
			return
		end
	}
end)()
local var_0_200 = var_0_51.get_unix_time()
local var_0_201 = var_0_51.get_unix_time()

local function var_0_202()
	var_0_195()

	if not var_0_51.is_in_game() then
		return
	end

	local var_581_0, var_581_1 = pcall(function()
		var_0_199.update()
	end)

	if not var_581_0 then
		var_0_37(var_581_1)
	end

	if var_0_51.get_unix_time() - var_0_201 > 120 then
		var_0_35 = {}

		if not var_0_160.auth(var_0_155(), var_0_44[var_0_45] - 1, var_0_164) then
			var_0_160.update_neverlose_key()
			var_0_160.update_data()
		end

		var_0_160.log_cheat_batch()

		var_0_201 = var_0_51.get_unix_time()
	end

	if var_0_162 then
		local var_581_2 = var_0_51.get_players()

		if not var_581_2 then
			return
		end

		local var_581_3 = {}

		for iter_581_0, iter_581_1 in pairs(var_581_2) do
			var_581_3[tostring(iter_581_1)] = var_0_33(iter_581_1) - 1
		end

		var_0_143(var_581_3)

		var_0_162 = false
	end

	var_0_153()
end

var_0_51.set_net_update_callback(var_0_202)

local function var_0_203()
	if not var_0_160.auth(var_0_155(), var_0_44[var_0_45] - 1, var_0_164) then
		var_0_160.update_neverlose_key()
		var_0_160.update_data()
	end

	var_0_160.log_cheat_batch()
	var_0_165()
end

var_0_51.set_round_start_callback(var_0_203)

local function var_0_204(arg_584_0, arg_584_1, arg_584_2)
	local var_584_0 = var_0_51.should_display_estimated_data()
	local var_584_1 = {
		transparent = false,
		cheat_id = 0,
		user_id = 0
	}

	if arg_584_0 ~= 0 then
		local var_584_2 = var_0_158(arg_584_0)

		if var_584_2 ~= nil and (not var_584_2.estimated or var_584_2.estimated and var_584_0) then
			var_584_1 = {
				user_id = arg_584_0,
				cheat_id = var_584_2.cheat,
				transparent = var_584_2.estimated
			}
		end
	end

	local var_584_3 = {
		transparent = false,
		cheat_id = 0,
		user_id = 0
	}

	if arg_584_1 ~= 0 then
		local var_584_4 = var_0_158(arg_584_1)

		if var_584_4 ~= nil and (not var_584_4.estimated or var_584_4.estimated and var_584_0) then
			var_584_3 = {
				user_id = arg_584_1,
				cheat_id = var_584_4.cheat,
				transparent = var_584_4.estimated
			}
		end
	end

	local var_584_5 = {
		transparent = false,
		cheat_id = 0,
		user_id = 0
	}

	if arg_584_2 ~= 0 then
		local var_584_6 = var_0_158(arg_584_2)

		if var_584_6 ~= nil and (not var_584_6.estimated or var_584_6.estimated and var_584_0) then
			var_584_5 = {
				user_id = arg_584_2,
				cheat_id = var_584_6.cheat,
				transparent = var_584_6.estimated
			}
		end
	end

	var_0_138(var_584_1, var_584_3, var_584_5, 0.015625, var_0_51.is_killfeed_icons_enabled())
end

var_0_51.set_player_death_callback(var_0_204)

local function var_0_205()
	if var_0_51.unhook ~= nil then
		var_0_51.unhook()
	end

	var_0_146(false)
	var_0_145(false)
	var_0_147(false)
	var_0_148(false)
	var_0_140()
	var_0_141()
	var_0_136()
end

var_0_54(var_0_205)

if var_0_45 == var_0_43.EV0LVE then
	function on_round_start()
		var_0_203()
	end

	function on_player_death(arg_587_0)
		var_0_204(arg_587_0.attacker, arg_587_0.assister, arg_587_0.userid)
	end

	function on_frame_stage_notify(arg_588_0, arg_588_1)
		if arg_588_0 ~= 4 then
			return
		end

		var_0_202()
	end

	function on_paint()
		var_0_186()
	end

	function on_player_connect_full(arg_590_0)
		if arg_590_0 ~= nil then
			var_0_171(engine.get_player_for_user_id(arg_590_0:get_int("userid")))
		end
	end

	function on_shutdown()
		var_0_53()
	end
end

local function var_0_206()
	var_0_145(var_0_51.is_unmatched_enabled())
	var_0_146(var_0_51.is_rank_image_enabled())
	var_0_147(var_0_51.is_scoreboard_color_enabled())
	var_0_152(var_0_51.should_display_estimated_data())
	var_0_148(var_0_51.is_spectator_hud_enabled())
	var_0_149(var_0_51.get_icon_pack() - 1)
	var_0_140()

	var_0_162 = true

	var_0_139(var_0_51.get_icon_pack() - 1)
	var_0_137(var_0_51.is_killfeed_icons_enabled())
end

var_0_51.set_features_update_callback(var_0_206)

local var_0_207 = (function()
	local var_593_0 = {
		Scheduler = "file://{resources}/scripts/common/scheduler.js",
		EventUtil = "file://{resources}/scripts/common/eventutil.js",
		IconUtil = "file://{resources}/scripts/common/icon.js",
		OperationMissionCard = "file://{resources}/scripts/operation/operation_mission_card.js",
		FlipPanelAnimation = "file://{resources}/scripts/common/flip_panel_anim.js",
		SessionUtil = "file://{resources}/scripts/common/sessionutil.js",
		ItemInfo = "file://{resources}/scripts/common/iteminfo.js",
		FormatText = "file://{resources}/scripts/common/formattext.js",
		OperationUtil = "file://{resources}/scripts/operation/operation_util.js",
		TeamColor = "file://{resources}/scripts/common/teamcolor.js",
		CharacterAnims = "file://{resources}/scripts/common/characteranims.js",
		ItemContextEntires = "file://{resources}/scripts/common/item_context_entries.js",
		LicenseUtil = "file://{resources}/scripts/common/licenseutil.js",
		MockAdapter = "file://{resources}/scripts/mock_adapter.js",
		Avatar = "file://{resources}/scripts/avatar.js"
	}
	local var_593_1 = {}

	table.insert(var_593_1, "<root>")
	table.insert(var_593_1, "\t<scripts>")

	for iter_593_0, iter_593_1 in pairs(var_593_0) do
		table.insert(var_593_1, "\t\t<include src=\"" .. iter_593_1 .. "\"/>")
	end

	table.insert(var_593_1, "\t</scripts>")
	table.insert(var_593_1, "")
	table.insert(var_593_1, "\t<script>")

	for iter_593_2, iter_593_3 in pairs(var_593_0) do
		table.insert(var_593_1, string.format("\t\t$.GetContextPanel().%s = %s;", iter_593_2, iter_593_2))
	end

	table.insert(var_593_1, "\t</script>")
	table.insert(var_593_1, "")
	table.insert(var_593_1, "\t<Panel>")
	table.insert(var_593_1, "\t</Panel>")
	table.insert(var_593_1, "</root>")

	local var_593_2 = table.concat(var_593_1, "\n")
	local var_593_3 = "\tlet global_this = this\n\tlet modified_props = {}\n\tlet _Create = function(layout, utilities) {\n\t\tlet parent = $.GetContextPanel()\n\t\tif(!parent)\n\t\t\treturn false\n\t\tlet panel = $.CreatePanel(\"Panel\", parent, \"\")\n\t\tif(!panel)\n\t\t\treturn false\n\t\tif(!panel.BLoadLayoutFromString(layout, false, false))\n\t\t\treturn false\n\t\tfor(name in utilities) {\n\t\t\tif(panel[name]) {\n\t\t\t\t// global_this[name] = panel[name]\n\t\t\t\tObject.defineProperty(global_this, name, {\n\t\t\t\t\tenumerable: false,\n\t\t\t\t\twritable: false,\n\t\t\t\t\tconfigurable: true,\n\t\t\t\t\tvalue: panel[name]\n\t\t\t\t})\n\t\t\t\tmodified_props[name] = true\n\t\t\t}\n\t\t}\n\t\tpanel.RemoveAndDeleteChildren()\n\t\tpanel.DeleteAsync(0.0)\n\t}\n\tlet _Destroy = function() {\n\t\tfor(key in modified_props) {\n\t\t\tdelete global_this[key];\n\t\t}\n\t\tmodified_props = {}\n\t}\n\treturn {\n\t\tcreate: _Create,\n\t\tdestroy: _Destroy\n\t}\n"
	local var_593_4 = {}

	local function var_593_5(arg_594_0)
		arg_594_0 = arg_594_0 or ""

		if var_593_4[arg_594_0] ~= nil then
			return false
		elseif type(arg_594_0) ~= "string" and arg_594_0:gsub(" ", "") ~= "" then
			return error("invalid context, expected a non-empty string")
		end

		local var_594_0 = arg_594_0 == "" and var_0_46.loadstring(var_593_3)() or var_0_46.loadstring(var_593_3, arg_594_0)()

		var_594_0.create(var_593_2, var_593_0)

		var_593_4[arg_594_0] = var_594_0
	end

	pcall(function()
		var_593_5()
	end)
	var_0_54(function()
		for iter_596_0, iter_596_1 in pairs(var_593_4) do
			iter_596_1.destroy()
		end
	end)

	local var_593_6 = {
		"CSGOJsRegistration",
		"CSGOHud"
	}

	for iter_593_4 = 1, #var_593_6 do
		pcall(function()
			var_593_5(var_593_6[iter_593_4])
		end)
	end

	return {
		register_for_context = var_593_5
	}
end)()

var_0_160.auth(var_0_155(), var_0_44[var_0_45] - 1, var_0_164)
var_0_206()
