local var_0_0 = require("vector")
local var_0_1 = require("ffi")
local var_0_2 = ui.get
local var_0_3 = ui.set
local var_0_4 = ui.set_visible
local var_0_5 = ui.set_callback
local var_0_6 = ui.new_checkbox
local var_0_7 = ui.new_color_picker
local var_0_8 = ui.new_slider
local var_0_9 = ui.new_multiselect
local var_0_10 = ui.reference
local var_0_11 = client.create_interface
local var_0_12 = client.screen_size
local var_0_13 = client.set_event_callback
local var_0_14 = client.unset_event_callback
local var_0_15 = entity.get_local_player
local var_0_16 = entity.get_player_weapon
local var_0_17 = entity.get_prop
local var_0_18 = entity.is_alive
local var_0_19 = renderer.gradient
local var_0_20 = globals.frametime
local var_0_21 = math.min
local var_0_22 = math.max
local var_0_23 = math.pi
local var_0_24 = var_0_1.cdef
local var_0_25 = var_0_1.typeof
local var_0_26 = var_0_1.cast
local var_0_27 = var_0_11("client.dll", "VClientEntityList003") or error("VClientEntityList003 not found.", 2)
local var_0_28 = var_0_26(var_0_25("void***"), var_0_27) or error("raw_iEntityList is nil", 2)
local var_0_29 = var_0_26(var_0_25("void*(__thiscall*)(void*, int)"), var_0_28[0][3]) or error("native_getClientEntity is nil", 2)
local var_0_30 = vtable_thunk(453, "float(__thiscall*)(void*)")
local var_0_31 = vtable_thunk(483, "float(__thiscall*)(void*)")
local var_0_32 = var_0_0()
local var_0_33
local var_0_34
local var_0_35
local var_0_36 = 0
local var_0_37 = "visuals"
local var_0_38 = "effects"
local var_0_39 = {
	enabled = var_0_6(var_0_37, var_0_38, "Custom scope lines"),
	color = var_0_7(var_0_37, var_0_38, "\n scope_lines_color_picker", 0, 0, 0, 190),
	color2 = var_0_7(var_0_37, var_0_38, "\n scope_lines_color_picker2", 0, 0, 0, 0),
	options = var_0_9(var_0_37, var_0_38, "\n scope_options", {
		"Dynamic offset",
		"Remove top line",
		"Disable animation"
	}),
	size = var_0_8(var_0_37, var_0_38, "\n scope_lines_initial_pos", 0, 500, 190),
	offset = var_0_8(var_0_37, var_0_38, "\n scope_lines_offset", 0, 500, 10),
	thickness = var_0_8(var_0_37, var_0_38, "\n scope_lines_thickness", 1, 10, 1, true, "px"),
	fade = var_0_8(var_0_37, var_0_38, "Fade animation speed", 3, 20, 12, true, "fr", 1, {
		[3] = "Off"
	}),
	scope_ovr = var_0_10(var_0_37, var_0_38, "Remove scope overlay"),
	fov = var_0_10("misc", "miscellaneous", "override fov")
}

local function var_0_40(arg_1_0, arg_1_1, arg_1_2)
	return var_0_22(arg_1_1, var_0_21(arg_1_2, arg_1_0))
end

local function var_0_41(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if iter_2_1 == arg_2_1 then
			return true
		end
	end

	return false
end

local var_0_42 = {
	paint_ui = function()
		var_0_3(var_0_39.scope_ovr, true)
	end,
	paint = function()
		var_0_3(var_0_39.scope_ovr, false)

		var_0_32.x, var_0_32.y = var_0_12()

		local var_4_0 = var_0_2(var_0_39.offset) * (var_0_32.y / 1080)
		local var_4_1 = var_0_2(var_0_39.size) * (var_0_32.y / 1080)
		local var_4_2 = var_0_2(var_0_39.fade)
		local var_4_3 = var_0_2(var_0_39.thickness)
		local var_4_4 = {
			var_0_2(var_0_39.color)
		}
		local var_4_5 = {
			var_0_2(var_0_39.color2)
		}
		local var_4_6 = var_0_15()

		if var_4_6 == nil then
			return
		end

		local var_4_7 = var_0_16(var_4_6)

		if var_4_7 == nil then
			return
		end

		if var_0_33 then
			local var_4_8 = var_0_29(var_0_28, var_4_7)

			if var_4_8 ~= nil then
				local var_4_9 = var_0_30(var_4_8)
				local var_4_10 = (var_0_31(var_4_8) + var_4_9) * 360

				var_4_0, var_4_1 = var_4_0 + var_4_10, var_4_1 + var_4_10
			end
		end

		local var_4_11 = var_0_17(var_4_7, "m_zoomLevel")
		local var_4_12 = var_0_17(var_4_6, "m_bIsScoped") == 1
		local var_4_13 = var_0_17(var_4_6, "m_bResumeZoom") == 1
		local var_4_14 = var_0_18(var_4_6) and var_4_7 ~= nil and var_4_11 ~= nil and var_4_11 > 0 and var_4_12 and not var_4_13
		local var_4_15 = var_4_2 > 3 and var_0_20() * var_4_2 or 1
		local var_4_16 = var_0_32.x * 0.5
		local var_4_17 = var_0_32.y * 0.5
		local var_4_18 = var_4_3 > 1 and var_4_3 * 0.5 or 0

		if not var_0_35 then
			var_4_0 = var_4_0 + var_4_1 * (1 - var_0_36)
		end

		if var_0_36 > 0 then
			var_0_19(var_4_16 - var_4_1 + 2, var_4_17 - var_4_18, var_4_1 - var_4_0, var_4_3, var_4_5[1], var_4_5[2], var_4_5[3], var_4_5[4] * var_0_36, var_4_4[1], var_4_4[2], var_4_4[3], var_4_4[4] * var_0_36, true)
			var_0_19(var_4_16 + var_4_0, var_4_17 - var_4_18, var_4_1 - var_4_0, var_4_3, var_4_4[1], var_4_4[2], var_4_4[3], var_4_4[4] * var_0_36, var_4_5[1], var_4_5[2], var_4_5[3], var_4_5[4] * var_0_36, true)

			if not var_0_34 then
				var_0_19(var_4_16 - var_4_18, var_4_17 - var_4_1 + 2, var_4_3, var_4_1 - var_4_0, var_4_5[1], var_4_5[2], var_4_5[3], var_4_5[4] * var_0_36, var_4_4[1], var_4_4[2], var_4_4[3], var_4_4[4] * var_0_36, false)
			end

			var_0_19(var_4_16 - var_4_18, var_4_17 + var_4_0, var_4_3, var_4_1 - var_4_0, var_4_4[1], var_4_4[2], var_4_4[3], var_4_4[4] * var_0_36, var_4_5[1], var_4_5[2], var_4_5[3], var_4_5[4] * var_0_36, false)
		end

		var_0_36 = var_0_40(var_0_36 + (var_4_14 and var_4_15 or -var_4_15), 0, 1)
	end,
	shutdown = function()
		var_0_4(var_0_39.scope_ovr, true)
		var_0_3(var_0_39.scope_ovr, true)
	end
}

local function var_0_43()
	local var_6_0 = var_0_2(var_0_39.enabled)
	local var_6_1 = var_6_0 and var_0_13 or var_0_14

	if not var_6_0 then
		var_0_36 = 0
	end

	local var_6_2 = var_0_2(var_0_39.options)

	var_0_33, var_0_34, var_0_35 = var_0_41(var_6_2, "Dynamic offset"), var_0_41(var_6_2, "Remove top line"), var_0_41(var_6_2, "Disable animation")

	var_0_4(var_0_39.scope_ovr, not var_6_0)
	var_0_4(var_0_39.color2, var_6_0)
	var_0_4(var_0_39.options, var_6_0)
	var_0_4(var_0_39.size, var_6_0)
	var_0_4(var_0_39.offset, var_6_0)
	var_0_4(var_0_39.thickness, var_6_0)
	var_0_4(var_0_39.fade, var_6_0)

	for iter_6_0, iter_6_1 in pairs(var_0_42) do
		var_6_1(iter_6_0, iter_6_1)
	end
end

var_0_5(var_0_39.enabled, var_0_43)
var_0_43()
var_0_5(var_0_39.options, var_0_43)
