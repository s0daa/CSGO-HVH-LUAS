local var_0_0 = {
	checkbox = ui.new_checkbox,
	slider = ui.new_slider,
	multiselect = ui.new_multiselect,
	combobox = ui.new_combobox,
	label = ui.new_label,
	textbox = ui.new_textbox,
	color_picker = ui.new_color_picker,
	hotkey = ui.new_hotkey,
	set = ui.set,
	get = ui.get,
	ref = ui.reference,
	callback = ui.set_callback,
	visible = ui.set_visible
}
local var_0_1 = {
	_debug = false,
	menu = {
		"config",
		"Presets"
	},
	groups = {
		awp = {
			9
		},
		auto = {
			11,
			38
		},
		scout = {
			40
		},
		revolver = {
			64
		},
		deagle = {
			1
		},
		pistol = {
			2,
			3,
			4,
			30,
			32,
			36,
			61,
			63
		},
		rifle = {
			7,
			8,
			10,
			13,
			16,
			39,
			60
		},
		smg = {
			17,
			19,
			24,
			26,
			33,
			34
		},
		heavy = {
			14,
			28
		},
		shotgun = {
			25,
			27,
			29,
			35
		}
	},
	call = function(arg_1_0, arg_1_1, arg_1_2, ...)
		if arg_1_1 == nil then
			return
		end

		local var_1_0 = arg_1_2[2] or ""

		if arg_1_2[1] ~= nil then
			var_1_0 = var_1_0 ~= "" and var_1_0 .. " " or var_1_0
			var_1_0 = var_1_0 .. "\n " .. arg_1_2[1]
		end

		return arg_1_1(arg_1_0.menu[1], arg_1_0.menu[2], var_1_0, ...)
	end
}
local var_0_2
local var_0_3
local var_0_4
local var_0_5

local function var_0_6(arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_0 do
		if arg_2_0[iter_2_0] == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_7(arg_3_0, arg_3_1)
	if arg_3_0 == nil then
		return false
	end

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		arg_3_0(iter_3_0, iter_3_1)
	end
end

local function var_0_8(arg_4_0)
	return (arg_4_0:gsub("^%l", string.upper))
end

local function var_0_9(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = 1

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		var_5_0[var_5_1] = var_0_8(iter_5_0)
		var_5_1 = var_5_1 + 1
	end

	table.sort(var_5_0)

	return var_5_0
end

local function var_0_10(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(var_0_1.groups) do
		if var_0_6(iter_6_1, arg_6_0) then
			return var_0_8(iter_6_0)
		end
	end

	return false
end

local function var_0_11(arg_7_0)
	local var_7_0 = entity.get_player_weapon(arg_7_0)

	return (bit.band(65535, entity.get_prop(var_7_0, "m_iItemDefinitionIndex")))
end

local function var_0_12(arg_8_0)
	if arg_8_0 > 40 and arg_8_0 < 50 or arg_8_0 > 499 and arg_8_0 < 524 or arg_8_0 == 31 then
		return true
	end
end

local var_0_13 = var_0_0.label(var_0_1.menu[1], var_0_1.menu[2], "-------------------------------------------------")
local var_0_14 = var_0_1:call(var_0_0.checkbox, {
	"rcl_disabled",
	"Disable weapon based preset loading"
})
local var_0_15 = var_0_1:call(var_0_0.label, {
	"rcl_active_lbl",
	"Active preset:"
})
local var_0_16 = var_0_1:call(var_0_0.label, {
	"rcl_prefix_lbl",
	"Preset name prefix"
})
local var_0_17 = var_0_1:call(var_0_0.textbox, {
	"rcl_prefix",
	"preset_name_prefix"
})
local var_0_18 = var_0_1:call(var_0_0.multiselect, {
	"rcl_selected",
	"Selected weapon groups"
}, var_0_9(var_0_1.groups))
local var_0_19 = var_0_1:call(var_0_0.checkbox, {
	"rcl_indicator",
	"Indicate current preset name"
})
local var_0_20 = var_0_1:call(var_0_0.color_picker, {
	"rcl_indicator_color",
	"indicator_color"
}, 123, 193, 21, 255)

local function var_0_21(arg_9_0)
	local var_9_0 = string.format("%s%s", var_0_0.get(var_0_17), arg_9_0)
	local var_9_1 = var_0_0.get(var_0_14)
	local var_9_2 = var_0_0.get(var_0_17)
	local var_9_3 = var_0_0.get(var_0_18)
	local var_9_4 = var_0_0.get(var_0_19)

	config.load(var_9_0)

	var_0_3 = var_9_0

	var_0_0.set(var_0_15, string.format("Active preset: %s", var_9_0))
	var_0_7(var_0_0.set, {
		[var_0_14] = var_9_1,
		[var_0_17] = var_9_2,
		[var_0_18] = var_9_3,
		[var_0_19] = var_9_4
	})
end

local function var_0_22(arg_10_0)
	if var_0_12(arg_10_0) then
		return
	end

	local var_10_0 = var_0_10(arg_10_0)
	local var_10_1 = var_0_0.get(var_0_18)

	if not var_0_6(var_10_1, var_0_8(var_10_0)) then
		var_10_0 = "global"
	end

	if var_0_6(var_10_1, var_0_8(var_10_0)) and var_10_0 ~= "global" then
		var_0_4 = string.lower(var_10_0)
	else
		var_0_4 = "global"
	end

	var_0_21(var_0_4)
end

local function var_0_23(arg_11_0)
	local var_11_0 = entity.get_local_player()

	if not entity.is_alive(var_11_0) then
		return
	end

	if var_0_11(var_11_0) == var_0_2 then
		return
	end

	var_0_2 = var_0_11(var_11_0)

	var_0_22(var_0_2)
end

local function var_0_24()
	if not var_0_0.get(var_0_19) then
		return
	end

	if not var_0_3 then
		return
	end

	local var_12_0, var_12_1, var_12_2, var_12_3 = var_0_0.get(var_0_20)

	renderer.indicator(var_12_0, var_12_1, var_12_2, var_12_3, string.upper(var_0_3))
end

local function var_0_25()
	local var_13_0 = not var_0_0.get(var_0_14)

	var_0_7(var_0_0.visible, {
		[var_0_15] = var_13_0,
		[var_0_16] = var_13_0,
		[var_0_17] = var_13_0,
		[var_0_18] = var_13_0,
		[var_0_19] = var_13_0,
		[var_0_20] = var_13_0
	})
end

local function var_0_26()
	local var_14_0 = not var_0_0.get(var_0_14)

	var_0_25()

	local var_14_1 = var_14_0 and client.set_event_callback or client.unset_event_callback

	var_14_1("net_update_end", var_0_23)
	var_14_1("paint", var_0_24)
end

var_0_26()
var_0_0.callback(var_0_14, var_0_26)
var_0_0.callback(var_0_19, var_0_25)
