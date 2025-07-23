-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = assert
local var_0_1 = defer
local var_0_2 = error
local var_0_3 = getfenv
local var_0_4 = setfenv
local var_0_5 = getmetatable
local var_0_6 = setmetatable
local var_0_7 = ipairs
local var_0_8 = pairs
local var_0_9 = next
local var_0_10 = pcall
local var_0_11 = rawequal
local var_0_12 = rawset
local var_0_13 = rawlen
local var_0_14 = readfile
local var_0_15 = require
local var_0_16 = select
local var_0_17 = tonumber
local var_0_18 = tostring
local var_0_19 = type
local var_0_20 = unpack
local var_0_21 = xpcall

local function var_0_22(arg_1_0)
	if var_0_19(arg_1_0) ~= "table" then
		return arg_1_0
	end

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in var_0_8(arg_1_0) do
		var_1_0[var_0_22(iter_1_0)] = var_0_22(iter_1_1)
	end

	return var_1_0
end

local var_0_23 = var_0_22(table)
local var_0_24 = var_0_22(math)
local var_0_25 = var_0_22(string)
local var_0_26 = var_0_22(ui)
local var_0_27 = var_0_22(client)

function var_0_23.find(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in var_0_8(arg_2_0) do
		if iter_2_1 == arg_2_1 then
			return iter_2_0
		end
	end

	return false
end

function var_0_23.ifind(arg_3_0, arg_3_1)
	for iter_3_0 = 1, var_0_23.maxn(arg_3_0) do
		if arg_3_0[iter_3_0] == arg_3_1 then
			return iter_3_0
		end
	end
end

function var_0_23.qfind(arg_4_0, arg_4_1)
	for iter_4_0 = 1, #arg_4_0 do
		if arg_4_0[iter_4_0] == arg_4_1 then
			return iter_4_0
		end
	end
end

function var_0_23.ihas(arg_5_0, ...)
	local var_5_0 = {
		...
	}

	for iter_5_0 = 1, var_0_23.maxn(arg_5_0) do
		for iter_5_1 = 1, #var_5_0 do
			if arg_5_0[iter_5_0] == var_5_0[iter_5_1] then
				return true
			end
		end
	end

	return false
end

function var_0_23.minn(arg_6_0)
	local var_6_0 = 0

	for iter_6_0 = 1, #arg_6_0 do
		if arg_6_0[iter_6_0] == nil then
			break
		end

		var_6_0 = var_6_0 + 1
	end

	return var_6_0
end

function var_0_23.filter(arg_7_0)
	local var_7_0 = {}

	for iter_7_0 = 1, var_0_23.maxn(arg_7_0) do
		if arg_7_0[iter_7_0] ~= nil then
			var_7_0[#var_7_0 + 1] = arg_7_0[iter_7_0]
		end
	end

	return var_7_0
end

function var_0_23.append(arg_8_0, ...)
	for iter_8_0, iter_8_1 in var_0_7({
		...
	}) do
		var_0_23.insert(arg_8_0, iter_8_1)
	end
end

var_0_23.copy = var_0_22

local function var_0_28(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0 then
		return arg_9_1
	else
		return arg_9_2
	end
end

local function var_0_29(arg_10_0, arg_10_1, ...)
	local var_10_0 = {
		var_0_10(arg_10_0, ...)
	}

	if not var_10_0[1] then
		return var_0_19(arg_10_1) == "function" and arg_10_1(var_10_0[2]) or var_0_2(var_10_0[2], arg_10_1 or 2)
	end

	return var_0_20(var_10_0, 2)
end

local var_0_30 = {
	execute = function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0
		local var_11_1

		for iter_11_0, iter_11_1 in var_0_7(arg_11_1) do
			var_11_1, var_11_0, arg_11_0 = iter_11_1, arg_11_0, arg_11_0[iter_11_1]

			if arg_11_0 == nil then
				return
			end
		end

		if var_11_0[var_11_1] then
			arg_11_2(var_11_0[var_11_1])
		end
	end,
	replace = function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0
		local var_12_1

		for iter_12_0, iter_12_1 in var_0_7(arg_12_1) do
			var_12_1, var_12_0, arg_12_0 = iter_12_1, arg_12_0, arg_12_0[iter_12_1]

			if arg_12_0 == nil then
				return
			end
		end

		var_12_0[var_12_1] = arg_12_2
	end,
	find = function(arg_13_0, arg_13_1)
		local var_13_0
		local var_13_1

		for iter_13_0, iter_13_1 in var_0_7(arg_13_1) do
			var_13_1, var_13_0, arg_13_0 = iter_13_1, arg_13_0, arg_13_0[iter_13_1]

			if arg_13_0 == nil then
				return
			end
		end

		return var_13_0[var_13_1]
	end,
	pave = function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = arg_14_0

		for iter_14_0, iter_14_1 in var_0_7(arg_14_2) do
			if var_0_19(var_14_0[iter_14_1]) == "table" then
				var_14_0 = var_14_0[iter_14_1]
			else
				var_14_0[iter_14_1] = iter_14_0 < #arg_14_2 and {} or arg_14_1
				var_14_0 = var_14_0[iter_14_1]
			end
		end

		return arg_14_0
	end
}

function var_0_30.extract(arg_15_0, arg_15_1)
	if not arg_15_1 or #arg_15_1 == 0 then
		return arg_15_0
	end

	local var_15_0 = var_0_30.find(arg_15_0, arg_15_1)

	return var_0_30.pave({}, var_15_0, arg_15_1)
end

local var_0_31 = {}
local var_0_32 = {}
local var_0_33 = {
	element = {},
	group = {}
}
local var_0_34 = {
	button = {
		type = "function",
		unsavable = true,
		arg = 2
	},
	checkbox = {
		init = false,
		type = "boolean",
		arg = 1
	},
	color_picker = {
		arg = 5,
		type = "table"
	},
	combobox = {
		variable = true,
		type = "string",
		arg = 2
	},
	hotkey = {
		type = "table",
		arg = 3,
		enum = {
			[0] = "Always on",
			"On hotkey",
			"Toggle",
			"Off hotkey"
		}
	},
	label = {
		type = "string",
		unsavable = true,
		arg = 1
	},
	listbox = {
		init = 0,
		type = "number",
		variable = true,
		arg = 2
	},
	multiselect = {
		type = "table",
		variable = true,
		arg = 2,
		init = {}
	},
	slider = {
		arg = 8,
		type = "number"
	},
	textbox = {
		init = "",
		type = "string",
		arg = 1
	},
	string = {
		init = "",
		type = "string",
		arg = 2
	},
	unknown = {
		init = "",
		type = "string",
		arg = 2
	}
}
local var_0_35 = {
	"Global",
	"G3SG1 / SCAR-20",
	"SSG 08",
	"AWP",
	"R8 Revolver",
	"Desert Eagle",
	"Pistol",
	"Zeus",
	"Rifle",
	"Shotgun",
	"SMG",
	"Machine gun"
}
local var_0_36 = {}
local var_0_37 = {}
local var_0_38 = {}

var_0_27.set_event_callback("shutdown", function()
	for iter_16_0, iter_16_1 in var_0_9, var_0_36 do
		if iter_16_1.__ref and not iter_16_1.__rage then
			if iter_16_1.overridden then
				var_0_26.set(iter_16_0, iter_16_1.original)
			end

			var_0_26.set_enabled(iter_16_0, true)
			var_0_26.set_visible(iter_16_0, not iter_16_1.__hidden)
		end
	end

	var_0_37.cycle(function(arg_17_0)
		for iter_17_0, iter_17_1 in var_0_8(var_0_37.context[arg_17_0]) do
			if iter_17_1 ~= nil and var_0_36[iter_17_0].overridden then
				var_0_26.set(iter_17_0, iter_17_1)
			end
		end
	end, true)
end)
var_0_27.set_event_callback("pre_config_save", function()
	for iter_18_0, iter_18_1 in var_0_9, var_0_36 do
		if iter_18_1.__ref and not iter_18_1.__rage and iter_18_1.overridden then
			iter_18_1.ovr_restore = {
				var_0_26.get(iter_18_0)
			}

			var_0_26.set(iter_18_0, iter_18_1.original)
		end
	end

	var_0_37.cycle(function(arg_19_0)
		for iter_19_0, iter_19_1 in var_0_8(var_0_37.context[arg_19_0]) do
			if var_0_36[iter_19_0].overridden then
				var_0_37.cache[arg_19_0][iter_19_0] = var_0_26.get(iter_19_0)

				var_0_26.set(iter_19_0, iter_19_1)
			end
		end
	end, true)
end)
var_0_27.set_event_callback("post_config_save", function()
	for iter_20_0, iter_20_1 in var_0_9, var_0_36 do
		if iter_20_1.__ref and not iter_20_1.__rage and iter_20_1.overridden then
			var_0_26.set(iter_20_0, var_0_20(iter_20_1.ovr_restore))

			iter_20_1.ovr_restore = nil
		end
	end

	var_0_37.cycle(function(arg_21_0)
		for iter_21_0, iter_21_1 in var_0_8(var_0_37.context[arg_21_0]) do
			if var_0_36[iter_21_0].overridden then
				var_0_26.set(iter_21_0, var_0_37.cache[arg_21_0][iter_21_0])

				var_0_37.cache[arg_21_0][iter_21_0] = nil
			end
		end
	end, true)
end)

local var_0_39 = {}

local function var_0_40(arg_22_0, arg_22_1)
	if arg_22_0.name == "Weapon type" and var_0_25.lower(var_0_36[arg_22_0.ref].tab) == "rage" then
		return var_0_26.get(arg_22_0.ref)
	end

	var_0_26.set_callback(arg_22_0.ref, function(arg_23_0)
		if var_0_36[arg_23_0].__rage and var_0_37.silent then
			return
		end

		for iter_23_0 = 0, #var_0_36[arg_23_0].callbacks do
			if var_0_19(var_0_36[arg_23_0].callbacks[iter_23_0]) == "function" then
				var_0_36[arg_23_0].callbacks[iter_23_0](arg_22_0)
			end
		end
	end)

	if arg_22_0.type == "button" then
		return
	elseif arg_22_0.type == "color_picker" or arg_22_0.type == "hotkey" then
		var_0_36[arg_22_0.ref].callbacks[0] = function(arg_24_0)
			arg_22_0.value = {
				var_0_26.get(arg_24_0.ref)
			}
		end

		return {
			var_0_26.get(arg_22_0.ref)
		}
	else
		var_0_36[arg_22_0.ref].callbacks[0] = function(arg_25_0)
			arg_22_0.value = var_0_26.get(arg_25_0.ref)
		end

		if arg_22_0.type == "multiselect" then
			arg_22_0.value = var_0_26.get(arg_22_0.ref)
			var_0_36[arg_22_0.ref].callbacks[1] = function(arg_26_0)
				var_0_36[arg_22_0.ref].options = {}

				for iter_26_0 = 1, #arg_26_0.value do
					var_0_36[arg_22_0.ref].options[arg_26_0.value[iter_26_0]] = true
				end
			end

			var_0_36[arg_22_0.ref].callbacks[1](arg_22_0)
		end

		return var_0_26.get(arg_22_0.ref)
	end
end

function var_0_39.new(arg_27_0, arg_27_1)
	local var_27_0 = {}

	arg_27_1 = arg_27_1 or {}
	var_27_0.ref = arg_27_0
	var_27_0.name, var_27_0.type = var_0_26.name(arg_27_0), var_0_26.type(arg_27_0)
	var_0_36[arg_27_0] = var_0_36[arg_27_0] or {
		overridden = false,
		type = var_27_0.type,
		ref = arg_27_0,
		tab = arg_27_1.__tab,
		container = arg_27_1.__container,
		__ref = arg_27_1.__ref,
		__hidden = arg_27_1.__hidden,
		__init = arg_27_1.__init,
		__list = arg_27_1.__list,
		__rage = arg_27_1.__rage,
		__plist = arg_27_1.__plist and var_27_0.type ~= "label" and var_27_0.type ~= "button" and var_27_0.type ~= "hotkey",
		original = var_27_0.value,
		donotsave = arg_27_1.__plist or false,
		callbacks = {
			[0] = arg_27_1.__callback
		},
		events = {},
		depend = {
			[0] = {
				arg_27_0
			},
			{},
			{}
		}
	}
	var_0_36[arg_27_0].self = var_0_6(var_27_0, var_0_33.element)
	var_27_0.value = var_0_40(var_27_0, arg_27_1.__ref)

	if arg_27_1.__rage then
		var_0_33.element.set_callback(var_27_0, var_0_37.memorize)
	end

	if var_0_36[arg_27_0].__plist then
		var_0_38.elements[#var_0_38.elements + 1] = var_27_0

		var_0_33.element.set_callback(var_27_0, var_0_38.slot_update, true)
	end

	return var_27_0
end

function var_0_39.group(...)
	return var_0_6({
		...
	}, var_0_33.group)
end

function var_0_39.string(arg_29_0, arg_29_1)
	local var_29_0 = {
		ref = var_0_26.new_string(arg_29_0, arg_29_1 or "")
	}

	var_29_0.type = "string"
	var_29_0[0] = {
		savable = true
	}

	return var_0_6(var_29_0, var_0_33.element)
end

function var_0_39.features(arg_30_0, arg_30_1)
	local var_30_0
	local var_30_1 = arg_30_1[1]
	local var_30_2 = var_0_19(arg_30_1[1])

	if not var_30_0 and (var_30_2 == "table" or var_30_2 == "cdata") and not var_30_1.r then
		var_30_0 = "color"

		local var_30_3 = var_30_1[1] or 255
		local var_30_4 = var_30_1[2] or 255
		local var_30_5 = var_30_1[3] or 255
		local var_30_6 = var_30_1[4] or 255

		arg_30_0.color = var_0_39.new(var_0_26.new_color_picker(var_0_36[arg_30_0.ref].tab, var_0_36[arg_30_0.ref].container, arg_30_0.name, var_30_3, var_30_4, var_30_5, var_30_6), {
			__init = {
				var_30_3,
				var_30_4,
				var_30_5,
				var_30_6
			},
			__plist = var_0_36[arg_30_0.ref].__plist
		})
	elseif not var_30_0 and (var_30_2 == "table" or var_30_2 == "cdata") and var_30_1.r then
		var_30_0 = "color"
		arg_30_0.color = var_0_39.new(var_0_26.new_color_picker(var_0_36[arg_30_0.ref].tab, var_0_36[arg_30_0.ref].container, arg_30_0.name, var_30_1.r, var_30_1.g, var_30_1.b, var_30_1.a), {
			__init = {
				var_30_1.r,
				var_30_1.g,
				var_30_1.b,
				var_30_1.a
			},
			__plist = var_0_36[arg_30_0.ref].__plist
		})
	elseif not var_30_0 and var_30_2 == "number" then
		var_30_0 = "hotkey"
		arg_30_0.hotkey = var_0_39.new(var_0_26.new_hotkey(var_0_36[arg_30_0.ref].tab, var_0_36[arg_30_0.ref].container, arg_30_0.name, true, var_30_1, {
			__init = var_30_1
		}))
	end

	var_0_36[arg_30_0.ref].depend[0][2] = var_30_0 and arg_30_0[var_30_0].ref
	var_0_36[arg_30_0.ref].__addon = var_30_0
	var_0_36[arg_30_0.ref].donotsave = arg_30_1[2] == false
end

function var_0_39.memorize(arg_31_0, arg_31_1, arg_31_2)
	if var_0_36[arg_31_0.ref].donotsave then
		return
	end

	if not var_0_34[arg_31_0.type].unsavable then
		var_0_30.pave(arg_31_2, arg_31_0.ref, arg_31_1)
	end

	if arg_31_0.color then
		arg_31_1[#arg_31_1] = arg_31_1[#arg_31_1] .. "_c"

		var_0_30.pave(arg_31_2, arg_31_0.color.ref, arg_31_1)
	end

	if arg_31_0.hotkey then
		arg_31_1[#arg_31_1] = arg_31_1[#arg_31_1] .. "_h"

		var_0_30.pave(arg_31_2, arg_31_0.hotkey.ref, arg_31_1)
	end
end

var_0_39.hidden_refs = {
	"Unlock hidden cvars",
	"Allow custom game events",
	"Faster grenade toss",
	"sv_maxunlag",
	"sv_maxusrcmdprocessticks",
	"sv_clockcorrection_msecs"
}

local var_0_41 = {
	combobox = function(arg_32_0)
		if arg_32_0[3] == true then
			return arg_32_0[1].value ~= arg_32_0[2]
		else
			for iter_32_0 = 2, #arg_32_0 do
				if arg_32_0[1].value == arg_32_0[iter_32_0] then
					return true
				end
			end
		end

		return false
	end,
	listbox = function(arg_33_0)
		if arg_33_0[3] == true then
			return arg_33_0[1].value ~= arg_33_0[2]
		else
			for iter_33_0 = 2, #arg_33_0 do
				if arg_33_0[1].value == arg_33_0[iter_33_0] then
					return true
				end
			end
		end

		return false
	end,
	multiselect = function(arg_34_0)
		return var_0_23.ihas(arg_34_0[1].value, var_0_20(arg_34_0, 2))
	end,
	slider = function(arg_35_0)
		return arg_35_0[2] <= arg_35_0[1].value and arg_35_0[1].value <= (arg_35_0[3] or arg_35_0[2])
	end
}

local function var_0_42(arg_36_0)
	local var_36_0 = false

	if var_0_19(arg_36_0[2]) == "function" then
		var_36_0 = arg_36_0[2](arg_36_0[1])
	else
		local var_36_1 = var_0_41[arg_36_0[1].type]

		if var_36_1 then
			var_36_0 = var_36_1(arg_36_0)
		else
			var_36_0 = arg_36_0[1].value == arg_36_0[2]
		end
	end

	return var_36_0 and true or false
end

function var_0_39.dependant(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = 0

	for iter_37_0 = 1, #arg_37_0 do
		if var_0_42(arg_37_0[iter_37_0]) then
			var_37_0 = var_37_0 + 1
		else
			break
		end
	end

	local var_37_1 = var_37_0 >= #arg_37_0
	local var_37_2 = arg_37_2 and "set_enabled" or "set_visible"

	for iter_37_1, iter_37_2 in var_0_7(arg_37_1) do
		var_0_26[var_37_2](iter_37_2, var_37_1)
	end
end

local var_0_43 = {
	rgb_to_hex = function(arg_38_0)
		return var_0_25.format("%02X%02X%02X%02X", arg_38_0[1], arg_38_0[2], arg_38_0[3], arg_38_0[4] or 255)
	end,
	hex_to_rgb = function(arg_39_0)
		arg_39_0 = arg_39_0:gsub("^#", "")

		return var_0_17(arg_39_0:sub(1, 2), 16), var_0_17(arg_39_0:sub(3, 4), 16), var_0_17(arg_39_0:sub(5, 6), 16), var_0_17(arg_39_0:sub(7, 8), 16) or 255
	end,
	gradient_text = function(arg_40_0, arg_40_1, arg_40_2)
		local var_40_0 = {}
		local var_40_1 = #var_0_25.gsub(arg_40_0, ".[\x80-\xBF]*", "a")
		local var_40_2 = 1 / (#arg_40_1 - 1)

		arg_40_2 = arg_40_2 or 1

		local var_40_3 = 0

		for iter_40_0 in var_0_25.gmatch(arg_40_0, ".[\x80-\xBF]*") do
			var_40_3 = var_40_3 + 1

			local var_40_4 = var_40_3 / var_40_1 / var_40_2
			local var_40_5 = var_0_24.ceil(var_40_4)
			local var_40_6 = var_40_4 / var_40_5
			local var_40_7 = arg_40_1[var_40_5]
			local var_40_8 = arg_40_1[var_40_5 + 1]
			local var_40_9 = var_40_7[1] + (var_40_8[1] - var_40_7[1]) * var_40_6
			local var_40_10 = var_40_7[2] + (var_40_8[2] - var_40_7[2]) * var_40_6
			local var_40_11 = var_40_7[3] + (var_40_8[3] - var_40_7[3]) * var_40_6
			local var_40_12 = var_40_7[4] + (var_40_8[4] - var_40_7[4]) * var_40_6

			var_40_0[#var_40_0 + 1] = (var_40_3 - 1) % arg_40_2 == 0 and ("\a%02x%02x%02x%02x%s"):format(var_40_9, var_40_10, var_40_11, var_40_12, iter_40_0) or iter_40_0
		end

		var_40_0[#var_40_0 + 1] = "\aCDCDCDFF"

		return var_0_23.concat(var_40_0)
	end
}

local function var_0_44(arg_41_0, arg_41_1)
	local var_41_0 = {}

	for iter_41_0 in var_0_25.gmatch(arg_41_0, "\b%x+") do
		var_41_0[#var_41_0 + 1] = {
			var_0_43.hex_to_rgb(var_0_25.sub(iter_41_0, 2))
		}
	end

	if #var_41_0 > 0 then
		return var_0_43.gradient_text(arg_41_1, var_41_0, #arg_41_1 > 8 and 2 or 1)
	end
end

function var_0_43.format(arg_42_0)
	if var_0_19(arg_42_0) == "string" then
		arg_42_0 = var_0_25.gsub(arg_42_0, "\f<(.-)>", var_0_31.macros)
		arg_42_0 = var_0_25.gsub(arg_42_0, "[\v\r\t]", {
			["\r"] = "\aCDCDCDFF",
			["\t"] = "    ",
			["\v"] = "\a" .. var_0_31.accent
		})
		arg_42_0 = var_0_25.gsub(arg_42_0, "([\b%x]-)%[(.-)%]", var_0_44)
	end

	return arg_42_0
end

function var_0_43.unpack_color(...)
	local var_43_0 = {
		...
	}
	local var_43_1 = var_0_19(var_43_0[1])

	if var_43_1 == "table" or var_43_1 == "cdata" or var_43_1 == "userdata" then
		if var_43_0[1].r then
			return {
				var_43_0[1].r,
				var_43_0[1].g,
				var_43_0[1].b,
				var_43_0[1].a
			}
		elseif var_43_0[1][1] then
			return {
				var_43_0[1][1],
				var_43_0[1][2],
				var_43_0[1][3],
				var_43_0[1][4]
			}
		end
	end

	return var_43_0
end

local var_0_45 = {
	color_picker = function(arg_44_0)
		arg_44_0[1] = var_0_25.sub(var_0_43.format(arg_44_0[1]), 1, 117)

		if var_0_19(arg_44_0[2]) ~= "number" then
			local var_44_0 = arg_44_0[2]

			arg_44_0.n, arg_44_0.req, arg_44_0[2] = arg_44_0.n + 3, arg_44_0.req + 3, var_44_0.r

			var_0_23.insert(arg_44_0, 3, var_44_0.g)
			var_0_23.insert(arg_44_0, 4, var_44_0.b)
			var_0_23.insert(arg_44_0, 5, var_44_0.a)
		end

		for iter_44_0 = arg_44_0.req + 1, arg_44_0.n do
			arg_44_0.misc[iter_44_0 - arg_44_0.req] = arg_44_0[iter_44_0]
		end

		arg_44_0.data.__init = {
			arg_44_0[2] or 255,
			arg_44_0[3] or 255,
			arg_44_0[4] or 255,
			arg_44_0[5] or 255
		}
	end,
	listbox = function(arg_45_0, arg_45_1)
		arg_45_0[1] = var_0_25.sub(var_0_43.format(arg_45_0[1]), 1, 117)

		for iter_45_0 = arg_45_0.req + 1, arg_45_0.n do
			arg_45_0.misc[iter_45_0 - arg_45_0.req] = arg_45_0[iter_45_0]
		end

		arg_45_0.data.__init, arg_45_0.data.__list = 0, not arg_45_1 and arg_45_0[2] or {
			var_0_20(arg_45_0, 2, arg_45_0.n)
		}
	end,
	combobox = function(arg_46_0, arg_46_1)
		arg_46_0[1] = var_0_25.sub(var_0_43.format(arg_46_0[1]), 1, 117)

		for iter_46_0 = arg_46_0.req + 1, arg_46_0.n do
			arg_46_0.misc[iter_46_0 - arg_46_0.req] = arg_46_0[iter_46_0]
		end

		arg_46_0.data.__init, arg_46_0.data.__list = not arg_46_1 and arg_46_0[2][1] or arg_46_0[2], not arg_46_1 and arg_46_0[2] or {
			var_0_20(arg_46_0, 2, arg_46_0.n)
		}
	end,
	multiselect = function(arg_47_0, arg_47_1)
		arg_47_0[1] = var_0_25.sub(var_0_43.format(arg_47_0[1]), 1, 117)

		for iter_47_0 = arg_47_0.req + 1, arg_47_0.n do
			arg_47_0.misc[iter_47_0 - arg_47_0.req] = arg_47_0[iter_47_0]
		end

		arg_47_0.data.__init, arg_47_0.data.__list = {}, not arg_47_1 and arg_47_0[2] or {
			var_0_20(arg_47_0, 2, arg_47_0.n)
		}
	end,
	slider = function(arg_48_0)
		arg_48_0[1] = var_0_25.sub(var_0_43.format(arg_48_0[1]), 1, 117)

		for iter_48_0 = arg_48_0.req + 1, arg_48_0.n do
			arg_48_0.misc[iter_48_0 - arg_48_0.req] = arg_48_0[iter_48_0]
		end

		arg_48_0.data.__init = arg_48_0[4] or arg_48_0[2]
	end,
	button = function(arg_49_0)
		arg_49_0[2] = arg_49_0[2] or function()
			return
		end
		arg_49_0[1] = var_0_25.sub(var_0_43.format(arg_49_0[1]), 1, 117)
		arg_49_0.n, arg_49_0.data.__callback = 2, arg_49_0[2]
	end
}

function var_0_43.dispense(arg_51_0, arg_51_1, ...)
	local var_51_0 = {
		...
	}
	local var_51_1 = {}
	local var_51_2 = var_0_34[arg_51_0]

	if var_0_19(arg_51_1) == "table" then
		var_51_1[1], var_51_1[2] = arg_51_1[1], arg_51_1[2]
		var_51_1.__plist = arg_51_1.__plist
	else
		var_51_1[1], var_51_1[2] = arg_51_1, var_51_0[1]

		var_0_23.remove(var_51_0, 1)
	end

	var_51_0.n, var_51_0.data = var_0_23.maxn(var_51_0), {
		__tab = var_51_1[1],
		__container = var_51_1[2],
		__plist = var_51_1.__plist and true or nil
	}

	local var_51_3 = var_51_2 and var_51_2.variable and var_0_19(var_51_0[2]) == "string"

	var_51_0.req, var_51_0.misc = not var_51_3 and var_51_2.arg or var_51_0.n, {}

	if var_0_45[arg_51_0] then
		var_0_45[arg_51_0](var_51_0, var_51_3)
	else
		for iter_51_0 = 1, var_51_0.n do
			if var_0_19(var_51_0[iter_51_0]) == "string" then
				var_51_0[iter_51_0] = var_0_25.sub(var_0_43.format(var_51_0[iter_51_0]), 1, 117)
			end

			if iter_51_0 > var_51_0.req then
				var_51_0.misc[iter_51_0 - var_51_0.req] = var_51_0[iter_51_0]
			end
		end

		var_51_0.data.__init = var_51_2.init
	end

	return var_51_0, var_51_1
end

var_0_31.macros = var_0_6({}, {
	__newindex = function(arg_52_0, arg_52_1, arg_52_2)
		var_0_12(arg_52_0, var_0_18(arg_52_1), arg_52_2)
	end,
	__index = function(arg_53_0, arg_53_1)
		return rawget(arg_53_0, var_0_18(arg_53_1))
	end
})
var_0_31.accent, var_0_31.menu_open = nil, var_0_26.is_menu_open()

local var_0_46 = var_0_26.reference("MISC", "Settings", "Menu color")

var_0_31.accent = var_0_43.rgb_to_hex({
	var_0_26.get(var_0_46)
})

local var_0_47 = var_0_31.accent

var_0_26.set_callback(var_0_46, function()
	local var_54_0 = {
		var_0_26.get(var_0_46)
	}

	var_0_31.accent = var_0_43.rgb_to_hex(var_54_0)

	for iter_54_0, iter_54_1 in var_0_9, var_0_36 do
		if iter_54_1.type == "label" and not iter_54_1.__ref then
			local var_54_1, var_54_2 = var_0_25.gsub(iter_54_1.self.value, var_0_47, var_0_31.accent)

			if var_54_2 > 0 then
				var_0_26.set(iter_54_0, var_54_1)

				iter_54_1.self.value = var_54_1
			end
		end
	end

	var_0_47 = var_0_31.accent

	var_0_27.fire_event("pui::accent_color", var_54_0)
end)
var_0_27.set_event_callback("paint_ui", function()
	local var_55_0 = var_0_26.is_menu_open()

	if var_55_0 ~= var_0_31.menu_open then
		var_0_27.fire_event("pui::menu_state", var_55_0)

		var_0_31.menu_open = var_55_0
	end
end)

function var_0_31.group(arg_56_0, arg_56_1)
	return var_0_39.group(arg_56_0, arg_56_1)
end

var_0_31.format = var_0_43.format

function var_0_31.reference(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = {
		var_0_29(var_0_26.reference, 3, arg_57_0, arg_57_1, arg_57_2)
	}
	local var_57_1 = #var_57_0
	local var_57_2 = false

	if var_0_25.lower(arg_57_0) == "misc" and var_0_25.lower(arg_57_1) == "settings" then
		for iter_57_0, iter_57_1 in var_0_7(var_0_39.hidden_refs) do
			if var_0_25.find(arg_57_2, "^" .. iter_57_1) then
				var_57_2 = true

				break
			end
		end
	end

	for iter_57_2, iter_57_3 in var_0_7(var_57_0) do
		var_57_0[iter_57_2] = var_0_39.new(iter_57_3, {
			__ref = true,
			__hidden = var_57_2 or nil,
			__tab = arg_57_0,
			__container = arg_57_1,
			__rage = arg_57_1 == "Aimbot" or nil
		})
	end

	if var_57_1 > 1 then
		local var_57_3 = 0

		for iter_57_4 = 1, var_57_1 > 4 and var_57_1 or 4, 2 do
			local var_57_4 = iter_57_4 - var_57_3
			local var_57_5 = iter_57_4 + 1 - var_57_3

			if var_57_0[var_57_5] and (var_57_0[var_57_5].type == "hotkey" or var_57_0[var_57_5].type == "color_picker") then
				local var_57_6 = var_57_0[var_57_5].type == "color_picker" and "color" or "hotkey"

				var_0_36[var_57_0[var_57_4].ref].__addon, var_57_0[var_57_4][var_57_6] = var_57_6, var_57_0[var_57_5]

				var_0_23.remove(var_57_0, var_57_5)

				var_57_3 = var_57_3 + 1
			end
		end

		return var_0_20(var_57_0)
	else
		return var_57_0[1]
	end
end

function var_0_31.traverse(arg_58_0, arg_58_1, arg_58_2)
	arg_58_2 = arg_58_2 or {}

	if var_0_19(arg_58_0) == "table" and arg_58_0.__name ~= "pui::element" and arg_58_0[#arg_58_0] ~= "~" then
		for iter_58_0, iter_58_1 in var_0_9, arg_58_0 do
			local var_58_0 = var_0_23.copy(arg_58_2)

			var_58_0[#var_58_0 + 1] = iter_58_0

			var_0_31.traverse(iter_58_1, arg_58_1, var_58_0)
		end
	else
		arg_58_1(arg_58_0, arg_58_2)
	end
end

local function var_0_48(arg_59_0, ...)
	local var_59_0 = {}

	var_0_31.traverse(var_0_30.extract(arg_59_0, {
		...
	}), function(arg_60_0, arg_60_1)
		local var_60_0
		local var_60_1 = var_0_36[arg_60_0].type

		if var_60_1 == "color_picker" then
			var_60_0 = "#" .. var_0_43.rgb_to_hex({
				var_0_26.get(arg_60_0)
			})
		elseif var_60_1 == "hotkey" then
			local var_60_2, var_60_3, var_60_4 = var_0_26.get(arg_60_0)

			var_60_0 = {
				var_60_3,
				var_60_4 or 0
			}
		else
			var_60_0 = var_0_26.get(arg_60_0)
		end

		if var_0_19(var_60_0) == "table" then
			var_60_0[#var_60_0 + 1] = "~"
		end

		var_0_30.pave(var_59_0, var_60_0, arg_60_1)
	end)

	return var_59_0
end

local function var_0_49(arg_61_0, arg_61_1, ...)
	if not arg_61_1 then
		return
	end

	local var_61_0 = var_0_30.extract(arg_61_1, {
		...
	})

	var_0_31.traverse(var_0_30.extract(arg_61_0, {
		...
	}), function(arg_62_0, arg_62_1)
		local var_62_0 = var_0_30.find(var_61_0, arg_62_1)
		local var_62_1 = var_0_36[arg_62_0]
		local var_62_2 = var_0_19(var_62_0)
		local var_62_3 = var_62_1.type
		local var_62_4 = var_0_34[var_62_3]

		if var_62_2 == "string" and var_62_0:sub(1, 1) == "#" then
			var_62_0, var_62_2 = {
				var_0_43.hex_to_rgb(var_62_0)
			}, "table"
		elseif var_62_2 == "table" and var_62_0[#var_62_0] == "~" then
			var_62_0[#var_62_0] = nil
		end

		if var_62_3 == "hotkey" and var_62_0 and var_0_19(var_62_0[1]) == "number" then
			var_62_0[1] = var_0_34.hotkey.enum[var_62_0[1]]
		end

		local var_62_5, var_62_6 = var_0_10(function()
			if var_62_4 and var_62_4.type == var_62_2 then
				if var_62_2 == "table" and var_62_3 ~= "multiselect" then
					var_0_26.set(arg_62_0, var_0_20(var_62_0))

					if var_62_3 == "color_picker" then
						var_0_33.element.invoke(var_62_1.self)
					end
				else
					var_0_26.set(arg_62_0, var_62_0)
				end
			elseif var_62_1.__init then
				var_0_26.set(arg_62_0, var_62_1.__init)
			end
		end)
	end)
end

local var_0_50 = {
	__type = "pui::package",
	__metatable = false,
	__call = function(arg_64_0, arg_64_1, ...)
		return (var_0_19(arg_64_1) == "table" and var_0_49 or var_0_48)(arg_64_0[0], arg_64_1, ...)
	end,
	save = function(arg_65_0, ...)
		return var_0_48(arg_65_0[0], ...)
	end,
	load = function(arg_66_0, ...)
		var_0_49(arg_66_0[0], ...)
	end
}

var_0_50.__index = var_0_50

function var_0_31.setup(arg_67_0)
	local var_67_0 = {
		[0] = {}
	}

	var_0_31.traverse(arg_67_0, function(arg_68_0, arg_68_1)
		var_0_39.memorize(arg_68_0, arg_68_1, var_67_0[0])
	end)

	return var_0_6(var_67_0, var_0_50)
end

var_0_33.element = {
	__name = "pui::element",
	__metatable = false,
	__type = "pui::element",
	__eq = function(arg_69_0, arg_69_1)
		return arg_69_0.ref == arg_69_1.ref
	end,
	__tostring = function(arg_70_0)
		return var_0_25.format("pui.%s[%d] \"%s\"", arg_70_0.type, arg_70_0.ref, arg_70_0.name)
	end,
	__call = function(arg_71_0, ...)
		if #{
			...
		} > 0 then
			var_0_26.set(arg_71_0.ref, ...)
		else
			return var_0_26.get(arg_71_0.ref)
		end
	end,
	depend = function(arg_72_0, ...)
		local var_72_0 = {
			...
		}
		local var_72_1 = var_72_0[1] == true
		local var_72_2 = var_0_36[arg_72_0.ref].depend[var_72_1 and 2 or 1]
		local var_72_3 = var_0_36[arg_72_0.ref].depend[0]

		for iter_72_0 = var_72_1 and 2 or 1, var_0_23.maxn(var_72_0) do
			local var_72_4 = var_72_0[iter_72_0]

			if var_72_4 then
				if var_72_4.__name == "pui::element" then
					var_72_4 = {
						var_72_4,
						true
					}
				end

				var_72_2[#var_72_2 + 1] = var_72_4

				local function var_72_5()
					var_0_39.dependant(var_72_2, var_72_3, var_72_1)
				end

				var_72_5()

				var_0_36[var_72_4[1].ref].callbacks[#var_0_36[var_72_4[1].ref].callbacks + 1] = var_72_5
			end
		end

		return arg_72_0
	end,
	override = function(arg_74_0, arg_74_1)
		local var_74_0 = arg_74_0.type == "hotkey"
		local var_74_1 = var_0_36[arg_74_0.ref]
		local var_74_2 = var_0_37.context[var_0_37.ref.value]

		if arg_74_1 ~= nil then
			if not var_74_1.overridden then
				if var_74_0 then
					arg_74_0.value = {
						var_0_26.get(arg_74_0.ref)
					}
				end

				if var_74_1.__rage then
					var_74_2[arg_74_0.ref] = arg_74_0.value
				else
					var_74_1.original = arg_74_0.value
				end
			end

			var_74_1.overridden = true

			if var_74_0 then
				var_0_26.set(arg_74_0.ref, arg_74_1[1], arg_74_1[2])
			else
				var_0_26.set(arg_74_0.ref, arg_74_1)
			end

			if var_74_1.__rage then
				var_74_1.__ovr_v = arg_74_1
			end
		elseif var_74_1.overridden then
			local var_74_3 = var_74_1.original

			if var_74_1.__rage then
				var_74_3, var_74_1.__ovr_v = var_74_2[arg_74_0.ref]
			end

			if var_74_0 then
				var_0_26.set(arg_74_0.ref, var_0_34.hotkey.enum[var_74_3[2]], var_74_3[3] or 0)
			else
				var_0_26.set(arg_74_0.ref, var_74_3)
			end

			var_74_1.overridden = false
		end
	end,
	get_original = function(arg_75_0)
		if var_0_36[arg_75_0.ref].__rage then
			if var_0_36[arg_75_0.ref].overridden then
				return var_0_37.context[var_0_37.ref.value][arg_75_0.ref]
			else
				return arg_75_0.value
			end
		elseif var_0_36[arg_75_0.ref].overridden then
			return var_0_36[arg_75_0.ref].original
		else
			return arg_75_0.value
		end
	end,
	set = function(arg_76_0, ...)
		if arg_76_0.type == "color_picker" then
			var_0_26.set(arg_76_0.ref, var_0_20(var_0_43.unpack_color(...)))
			var_0_33.element.invoke(arg_76_0)
		elseif arg_76_0.type == "label" then
			local var_76_0 = var_0_43.format(...)

			var_0_26.set(arg_76_0.ref, var_76_0)

			arg_76_0.value = var_76_0
		else
			var_0_26.set(arg_76_0.ref, ...)
		end
	end,
	get = function(arg_77_0, arg_77_1)
		if arg_77_1 and arg_77_0.type == "multiselect" then
			return var_0_36[arg_77_0.ref].options[arg_77_1] or false
		end

		return var_0_26.get(arg_77_0.ref)
	end,
	reset = function(arg_78_0)
		if var_0_36[arg_78_0.ref].__init then
			var_0_26.set(arg_78_0.ref, var_0_36[arg_78_0.ref].__init)
		end
	end,
	update = function(arg_79_0, arg_79_1)
		var_0_26.update(arg_79_0.ref, arg_79_1)

		var_0_36[arg_79_0.ref].__list = arg_79_1

		local var_79_0 = #arg_79_1 - 1

		if var_79_0 < var_0_26.get(arg_79_0.ref) then
			var_0_26.set(arg_79_0.ref, var_79_0)
		end
	end,
	get_list = function(arg_80_0)
		return var_0_36[arg_80_0.ref].__list
	end,
	get_color = function(arg_81_0)
		if var_0_36[arg_81_0.ref].__addon then
			return var_0_26.get(arg_81_0.color.ref)
		end
	end,
	set_color = function(arg_82_0, ...)
		if var_0_36[arg_82_0.ref].__addon then
			var_0_33.element.set(arg_82_0.color, ...)
		end
	end,
	get_hotkey = function(arg_83_0)
		if var_0_36[arg_83_0.ref].__addon then
			return var_0_26.get(arg_83_0.hotkey.ref)
		end
	end,
	set_hotkey = function(arg_84_0, ...)
		if var_0_36[arg_84_0.ref].__addon then
			var_0_33.element.set(arg_84_0.hotkey, ...)
		end
	end,
	is_reference = function(arg_85_0)
		return var_0_36[arg_85_0.ref].__ref or false
	end,
	get_type = function(arg_86_0)
		return arg_86_0.type
	end,
	get_name = function(arg_87_0)
		return arg_87_0.name
	end,
	set_visible = function(arg_88_0, arg_88_1)
		var_0_26.set_visible(arg_88_0.ref, arg_88_1)

		if var_0_36[arg_88_0.ref].__addon then
			var_0_26.set_visible(arg_88_0[var_0_36[arg_88_0.ref].__addon].ref, arg_88_1)
		end
	end,
	set_enabled = function(arg_89_0, arg_89_1)
		var_0_26.set_enabled(arg_89_0.ref, arg_89_1)

		if var_0_36[arg_89_0.ref].__addon then
			var_0_26.set_enabled(arg_89_0[var_0_36[arg_89_0.ref].__addon].ref, arg_89_1)
		end
	end,
	set_callback = function(arg_90_0, arg_90_1, arg_90_2)
		if arg_90_2 == true then
			arg_90_1(arg_90_0)
		end

		var_0_36[arg_90_0.ref].callbacks[#var_0_36[arg_90_0.ref].callbacks + 1] = arg_90_1
	end,
	unset_callback = function(arg_91_0, arg_91_1)
		var_0_23.remove(var_0_36[arg_91_0.ref].callbacks, var_0_23.qfind(var_0_36[arg_91_0.ref].callbacks, arg_91_1) or 0)
	end,
	invoke = function(arg_92_0, ...)
		for iter_92_0 = 0, #var_0_36[arg_92_0.ref].callbacks do
			var_0_36[arg_92_0.ref].callbacks[iter_92_0](arg_92_0, ...)
		end
	end,
	set_event = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
		local var_93_0 = var_0_36[arg_93_0.ref]

		if arg_93_3 == nil then
			arg_93_3 = true
		end

		local var_93_1 = var_0_19(arg_93_3) == "function"
		local var_93_2

		var_93_0.events[arg_93_2] = function(arg_94_0)
			local var_94_0

			if var_93_1 then
				var_94_0 = arg_93_3(arg_94_0)
			else
				var_94_0 = arg_94_0.value == arg_93_3
			end

			local var_94_1 = var_94_0 and var_0_27.set_event_callback or var_0_27.unset_event_callback

			if var_93_2 ~= var_94_0 then
				var_94_1(arg_93_1, arg_93_2)

				var_93_2 = var_94_0
			end
		end

		var_93_0.events[arg_93_2](arg_93_0)

		var_93_0.callbacks[#var_93_0.callbacks + 1] = var_93_0.events[arg_93_2]
	end,
	unset_event = function(arg_95_0, arg_95_1, arg_95_2)
		var_0_27.unset_event_callback(arg_95_1, arg_95_2)
		var_0_33.element.unset_callback(arg_95_0, var_0_36[arg_95_0.ref].events[arg_95_2])

		var_0_36[arg_95_0.ref].events[arg_95_2] = nil
	end,
	get_location = function(arg_96_0)
		return var_0_36[arg_96_0.ref].tab, var_0_36[arg_96_0.ref].container
	end
}
var_0_33.element.__index = var_0_33.element
var_0_33.group = {
	__metatable = false,
	__name = "pui::group",
	__index = function(arg_97_0, arg_97_1)
		return rawget(var_0_33.group, arg_97_1) or var_0_32.__index(arg_97_0, arg_97_1)
	end,
	get_location = function(arg_98_0)
		return arg_98_0[1], arg_98_0[2]
	end
}

for iter_0_0, iter_0_1 in var_0_9, var_0_34 do
	function iter_0_1.fn(arg_99_0, ...)
		local var_99_0, var_99_1 = var_0_43.dispense(iter_0_0, arg_99_0, ...)
		local var_99_2 = var_0_39.new(var_0_29(var_0_26["new_" .. iter_0_0], 3, var_99_1[1], var_99_1[2], var_0_20(var_99_0, 1, var_99_0.n < var_99_0.req and var_99_0.n or var_99_0.req)), var_99_0.data)

		var_0_39.features(var_99_2, var_99_0.misc)

		return var_99_2
	end
end

var_0_32.__name, var_0_32.__metatable = "pui::basement", false

function var_0_32.__index(arg_100_0, arg_100_1)
	if not var_0_34[arg_100_1] then
		return var_0_26[arg_100_1]
	end

	if arg_100_1 == "string" then
		return var_0_39.string
	end

	return var_0_34[arg_100_1].fn
end

var_0_37 = {
	silent = false,
	ref = var_0_31.reference("RAGE", "Weapon type", "Weapon type"),
	context = {},
	cache = {}
}

local var_0_51 = var_0_37.ref.value
local var_0_52

for iter_0_2, iter_0_3 in var_0_7(var_0_35) do
	var_0_37.context[iter_0_3], var_0_37.cache[iter_0_3] = {}, {}
end

local var_0_53 = var_0_26.reference("RAGE", "Aimbot", "Enabled")

var_0_26.set_callback(var_0_53, function()
	if not var_0_37.silent then
		var_0_27.delay_call(0, var_0_27.fire_event, "pui::adaptive_weapon", var_0_37.ref.value, var_0_51)
	end

	if var_0_52 then
		var_0_52(var_0_37.ref.value)
	end
end)

function var_0_37.cycle(arg_102_0, arg_102_1)
	var_0_52 = arg_102_1 and arg_102_0 or nil
	var_0_37.silent = arg_102_1 and true or false

	for iter_102_0, iter_102_1 in var_0_7(var_0_35) do
		var_0_37.ref:override(iter_102_1)
	end

	var_0_37.ref:override()

	var_0_52, var_0_37.silent = nil, false
end

var_0_26.set_callback(var_0_37.ref.ref, function(arg_103_0)
	var_0_37.ref.value = var_0_26.get(arg_103_0)

	if not var_0_37.silent and var_0_51 ~= var_0_37.ref.value then
		for iter_103_0 = 1, #var_0_36[arg_103_0].callbacks do
			var_0_36[arg_103_0].callbacks[iter_103_0](var_0_37.ref)
		end
	end

	var_0_51 = var_0_37.ref.value
end)

function var_0_37.memorize(arg_104_0)
	local var_104_0 = var_0_37.context[var_0_37.ref.value]

	if var_0_36[arg_104_0.ref].overridden then
		if var_104_0[arg_104_0.ref] == nil then
			var_104_0[arg_104_0.ref] = arg_104_0.value
		end
	elseif var_104_0[arg_104_0.ref] then
		var_0_33.element.set(arg_104_0, var_104_0[arg_104_0.ref])

		var_104_0[arg_104_0.ref] = nil
	end
end

var_0_38 = {
	elements = {},
	list = {}
}
var_0_31.plist = var_0_39.group("PLAYERS", "Adjustments")
var_0_31.plist.__plist = true

local var_0_54 = 0
local var_0_55 = {
	list = var_0_31.reference("PLAYERS", "Players", "Player list"),
	reset = var_0_31.reference("PLAYERS", "Players", "Reset all"),
	apply = var_0_31.reference("PLAYERS", "Adjustments", "Apply to all")
}
local var_0_56 = {}
local var_0_57 = {
	__type = "pui::player_slot",
	__metatable = false,
	__tostring = function(arg_105_0)
		return var_0_25.format("pui::player_slot[%d] of %s", arg_105_0.idx, var_0_33.element.__tostring(var_0_36[arg_105_0.ref].self))
	end,
	set = function(arg_106_0, ...)
		local var_106_0 = var_0_36[arg_106_0.ref]
		local var_106_1 = {
			...
		}
		local var_106_2 = var_106_0.type == "color_picker"

		if var_106_2 then
			var_106_1 = var_0_43.unpack_color(...)
		end

		if arg_106_0.idx == var_0_54 then
			var_0_26.set(arg_106_0.ref, var_0_20(var_106_1))

			if var_106_2 then
				var_0_33.element.invoke(var_106_0.self)
			end
		else
			arg_106_0.value = var_106_2 and var_106_1 or var_0_20(var_106_1)
		end
	end,
	get = function(arg_107_0, arg_107_1)
		if arg_107_1 and var_0_36[arg_107_0.ref].type == "multiselect" then
			return var_0_23.qfind(arg_107_0.value, arg_107_1) ~= nil
		end

		if var_0_36[arg_107_0.ref].type ~= "color_picker" then
			return arg_107_0.value
		else
			return var_0_20(arg_107_0.value)
		end
	end
}

var_0_57.__index = var_0_57

function var_0_38.traverse(arg_108_0)
	for iter_108_0, iter_108_1 in var_0_7(var_0_38.elements) do
		arg_108_0(iter_108_1)
	end
end

local var_0_58 = {
	select = function(arg_109_0)
		if not arg_109_0 then
			return
		end

		for iter_109_0, iter_109_1 in var_0_7(var_0_38.elements) do
			var_0_33.element.set(iter_109_1, iter_109_1[arg_109_0].value)
		end
	end,
	add = function(arg_110_0)
		if not arg_110_0 then
			return
		end

		for iter_110_0, iter_110_1 in var_0_7(var_0_38.elements) do
			local var_110_0 = var_0_28(var_0_36[iter_110_1.ref].__init ~= nil, var_0_36[iter_110_1.ref].__init, iter_110_1.value)

			iter_110_1[arg_110_0], var_0_38.list[arg_110_0] = var_0_6({
				ref = iter_110_1.ref,
				idx = arg_110_0,
				value = var_110_0
			}, var_0_57), true
		end
	end,
	remove = function(arg_111_0)
		if not arg_111_0 then
			return
		end

		for iter_111_0, iter_111_1 in var_0_7(var_0_38.elements) do
			iter_111_1[arg_111_0], var_0_38.list[arg_111_0] = nil
		end
	end
}

function var_0_38.slot_update(arg_112_0)
	if arg_112_0[var_0_54] then
		arg_112_0[var_0_54].value = arg_112_0.value
	else
		var_0_58.add(var_0_54)
	end
end

local var_0_59 = false

local function var_0_60(arg_113_0)
	var_0_54 = var_0_26.get(var_0_55.list.ref)

	local var_113_0 = entity.get_players()
	local var_113_1 = var_0_38.list
	local var_113_2 = entity.get_local_player()

	for iter_113_0, iter_113_1 in var_0_9, var_113_1 do
		if entity.get_classname(iter_113_0) ~= "CCSPlayer" then
			var_0_58.remove(iter_113_0)
		end
	end

	for iter_113_2, iter_113_3 in var_0_7(var_113_0) do
		if iter_113_3 ~= var_113_2 and not var_0_38.list[iter_113_3] and entity.get_classname(iter_113_3) == "CCSPlayer" then
			var_0_58.add(iter_113_3)
		end
	end

	if not var_0_59 and not arg_113_0.value then
		for iter_113_4 = #var_113_0, 1, -1 do
			if var_113_0[iter_113_4] ~= var_113_2 then
				var_0_26.set(var_0_55.list.ref, var_113_0[iter_113_4])

				break
			end
		end

		var_0_27.update_player_list()

		var_0_59 = true
	else
		var_0_59 = false
	end

	var_0_58.select(var_0_54)
	var_0_27.fire_event("pui::plist_update", var_0_54)
end

local function var_0_61()
	var_0_60({})
	var_0_27.unset_event_callback("pre_render", var_0_61)
end

var_0_27.set_event_callback("pre_render", var_0_61)
var_0_33.element.set_callback(var_0_55.list, var_0_60, true)
var_0_27.set_event_callback("player_connect_full", var_0_60)
var_0_27.set_event_callback("player_disconnect", var_0_60)
var_0_27.set_event_callback("player_spawned", var_0_60)
var_0_27.set_event_callback("player_spawn", var_0_60)
var_0_27.set_event_callback("player_death", var_0_60)
var_0_27.set_event_callback("player_team", var_0_60)
var_0_33.element.set_callback(var_0_55.apply, function()
	var_0_38.traverse(function(arg_116_0)
		for iter_116_0, iter_116_1 in var_0_9, var_0_38.list do
			arg_116_0[iter_116_0].value = arg_116_0[var_0_54].value
		end
	end)
end)
var_0_33.element.set_callback(var_0_55.reset, function()
	var_0_38.traverse(function(arg_118_0)
		for iter_118_0, iter_118_1 in var_0_9, var_0_38.list do
			if iter_118_0 == var_0_54 then
				var_0_57.set(arg_118_0[iter_118_0], var_0_36[arg_118_0.ref].__init)
			else
				arg_118_0[iter_118_0].value = var_0_36[arg_118_0.ref].__init
			end
		end
	end)
end)

return var_0_6(var_0_31, var_0_32)
